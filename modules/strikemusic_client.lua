local StrikeMusicClient = {}

local httpRequest =
    request or
    http_request or
    (syn and syn.request)

local function hasRawRequest()
    return httpRequest ~= nil
end

local function rawGet(url)
    if not hasRawRequest() then
        return nil, "request_not_supported"
    end

    local ok, response = pcall(function()
        return httpRequest({
            Url = url,
            Method = "GET"
        })
    end)

    if not ok or not response then
        return nil, "request_failed"
    end

    if response.StatusCode and response.StatusCode >= 400 then
        return nil, "download_http_error"
    end

    if not response.Body then
        return nil, "download_empty_body"
    end

    return response.Body, nil
end

local function now()
    return os.time()
end

function StrikeMusicClient.Create(Api, Storage)
    local client = {}

    local function ensureReady()
        if not Api then
            return {
                status = "blocked",
                reason = "api_not_configured"
            }
        end

        if not Storage then
            return {
                status = "blocked",
                reason = "storage_not_configured"
            }
        end

        if not Storage.HasFilesystem() then
            return {
                status = "blocked",
                reason = "filesystem_not_supported"
            }
        end

        return {
            status = "ok"
        }
    end

    function client.Open(player)
        local ready = ensureReady()

        if ready.status ~= "ok" then
            return ready
        end

        local folderResult = Storage.EnsureFolders()

        if folderResult.status ~= "ok" then
            return folderResult
        end

        local sessionResult = Api.OpenPersonalMusicSession(player)
        local rebuildResult = client.RebuildLibraryFromLocal(player)

        return {
            status = "ok",
            session = sessionResult,
            rebuild = rebuildResult
        }
    end

    function client.Minimize(player)
        return Api.MinimizePersonalMusicSession(player)
    end

    function client.Restore(player)
        return Api.RestorePersonalMusicSession(player)
    end

    function client.Close(player)
        return Api.ClosePersonalMusicSession(player)
    end

    function client.RebuildLibraryFromLocal(player)
        local localLibrary = Storage.GetLocalLibraryItems()

        if localLibrary.status ~= "ok" then
            return localLibrary
        end

        local rebuildResult = Api.RebuildPersonalMusicLibraryLocal(
            player,
            localLibrary.items
        )

        return {
            status = "ok",
            local_library = localLibrary,
            rebuild = rebuildResult
        }
    end

    function client.SyncExistingFiles(player)
        local keysResult = Storage.GetExistingFileKeys()

        if keysResult.status ~= "ok" then
            return keysResult
        end

        return Api.SyncPersonalMusicLibraryFiles(
            player,
            keysResult.file_keys
        )
    end

    function client.Search(player, query, limit)
        return Api.SearchPersonalMusic(player, query, limit or 10)
    end

    function client.GetLibrary(player)
        return Api.GetPersonalMusicLibrary(player)
    end

    function client.GetQueue(player)
        return Api.GetPersonalMusicQueue(player)
    end

    function client.GetHistory(player, limit)
        return Api.GetPersonalMusicHistory(player, limit or 25)
    end

    function client.GetFavorites(player)
        return Api.GetPersonalMusicFavorites(player)
    end

    function client.BuildDownloadData(result, mediaType)
        mediaType = mediaType or "mp3"

        return {
            source = result.source or "unknown",
            source_id = result.source_id or result.source_url or result.title,
            source_url = result.source_url,
            title = result.title or "StrikeMusic",
            artist = result.artist,
            duration_seconds = result.duration_seconds,
            thumbnail_url = result.thumbnail_url,
            media_type = mediaType,
            quality = Storage.GetDefaultQuality(mediaType)
        }
    end

    function client.CreateDownload(player, result, mediaType)
        return Api.CreatePersonalMusicDownload(
            player,
            client.BuildDownloadData(result, mediaType)
        )
    end

    function client.PrepareDownload(player, downloadJobId)
        return Api.PreparePersonalMusicDownload(player, downloadJobId)
    end

    function client.WaitForReadyDownload(player, downloadJobId, timeoutSeconds)
        local startedAt = os.clock()
        timeoutSeconds = timeoutSeconds or 30

        while os.clock() - startedAt <= timeoutSeconds do
            local result = Api.GetPersonalMusicDownload(player, downloadJobId)
            local job = result and result.job

            if job then
                if job.status == "ready" then
                    return {
                        status = "ready",
                        job = job
                    }
                end

                if job.status == "failed" or job.status == "expired" then
                    return {
                        status = "blocked",
                        reason = job.error_reason or job.status,
                        job = job
                    }
                end
            end

            task.wait(1)
        end

        return {
            status = "blocked",
            reason = "download_ready_timeout"
        }
    end

    function client.DownloadReadyJob(player, job)
        local ready = ensureReady()

        if ready.status ~= "ok" then
            return ready
        end

        if not job or not job.download_job_id then
            return {
                status = "blocked",
                reason = "download_job_not_found"
            }
        end

        if job.status ~= "ready" or not job.download_url then
            return {
                status = "blocked",
                reason = "download_job_not_ready",
                job = job
            }
        end

        local body, downloadError = rawGet(job.download_url)

        if not body then
            Api.FailPersonalMusicDownload(
                player,
                job.download_job_id,
                downloadError or "client_download_failed"
            )

            return {
                status = "blocked",
                reason = downloadError or "client_download_failed",
                job = job
            }
        end

        local fileKey = Storage.BuildFileKey(
            job.source_id or job.download_job_id,
            job.media_type,
            job.quality
        )
        local localPath = Storage.GetMediaPath(fileKey, job.media_type)
        local folderResult = Storage.EnsureFolders()

        if folderResult.status ~= "ok" then
            return folderResult
        end

        writefile(localPath, body)

        local fileSizeBytes = #body
        local metadataResult = Storage.SaveDownloadedMetadata(
            job,
            fileKey,
            localPath,
            fileSizeBytes
        )

        if metadataResult.status ~= "saved" then
            return metadataResult
        end

        local completeResult = Api.CompletePersonalMusicDownloadLocal(
            player,
            job.download_job_id,
            fileKey,
            fileSizeBytes
        )

        return {
            status = "downloaded",
            file_key = fileKey,
            local_path = localPath,
            file_size_bytes = fileSizeBytes,
            metadata = metadataResult.metadata,
            complete = completeResult,
            saved_at = now()
        }
    end

    function client.DownloadResult(player, result, mediaType)
        local createResult = client.CreateDownload(player, result, mediaType)
        local job = createResult and createResult.job

        if not job then
            return {
                status = "blocked",
                reason = createResult and createResult.reason or "download_create_failed",
                result = createResult
            }
        end

        local prepareResult = client.PrepareDownload(player, job.download_job_id)
        local preparedJob = prepareResult and prepareResult.job

        if not preparedJob then
            return {
                status = "blocked",
                reason = prepareResult and prepareResult.reason or "download_prepare_failed",
                result = prepareResult
            }
        end

        if preparedJob.status ~= "ready" then
            local waitResult = client.WaitForReadyDownload(
                player,
                preparedJob.download_job_id
            )

            if waitResult.status ~= "ready" then
                return waitResult
            end

            preparedJob = waitResult.job
        end

        return client.DownloadReadyJob(player, preparedJob)
    end

    function client.DeleteLocalItem(player, metadata)
        local deleteResult = Storage.DeleteMedia(metadata)

        if deleteResult.status ~= "deleted" then
            return deleteResult
        end

        local syncResult = client.SyncExistingFiles(player)

        return {
            status = "deleted",
            sync = syncResult
        }
    end

    function client.StartPlayback(player, libraryItemId, source, positionSeconds)
        return Api.StartPersonalMusicPlayback(
            player,
            libraryItemId,
            source or "manual",
            positionSeconds or 0,
            true
        )
    end

    function client.PausePlayback(player, positionSeconds)
        return Api.PausePersonalMusicPlayback(player, positionSeconds)
    end

    function client.ResumePlayback(player)
        return Api.ResumePersonalMusicPlayback(player)
    end

    function client.StopPlayback(player)
        return Api.StopPersonalMusicPlayback(player)
    end

    function client.UpdatePlaybackPosition(player, positionSeconds)
        return Api.UpdatePersonalMusicPlaybackPosition(
            player,
            positionSeconds or 0
        )
    end

    function client.PlayNext(player)
        return Api.PlayNextPersonalMusic(player)
    end

    function client.AddToQueue(player, libraryItemId)
        return Api.AddPersonalMusicQueueItem(player, libraryItemId)
    end

    function client.ClearQueue(player)
        return Api.ClearPersonalMusicQueue(player)
    end

    function client.AddFavorite(player, libraryItemId)
        return Api.AddPersonalMusicFavorite(player, libraryItemId)
    end

    function client.DeleteFavorite(player, libraryItemId)
        return Api.DeletePersonalMusicFavorite(player, libraryItemId)
    end

    return client
end

return StrikeMusicClient
