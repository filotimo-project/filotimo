// IMPORTANT: Start your code on the 2nd line
// Integrate with KDE better
pref("widget.use-xdg-desktop-portal.file-picker", 1);

// Better performance in constrained situations
pref("browser.low_commit_space_threshold_mb", 750);
pref("browser.tabs.unloadOnLowMemory", true);
pref("browser.cache.memory.enable", true);
pref("network.ssl_tokens_cache_capacity", 32768); // more TLS token caching (fast reconnects)
// Keep DNS lookup info longer (in seconds, default = 60 = a minute)
pref("network.dnsCacheExpiration", 7200); // 7200 = 2 hours. "To reduce load on DNS servers and to speed up response time, Mozilla caches DNS results. This preference controls how long to cache results." / "DNS lookup staying in cache means faster lookup = faster page loads.")
pref("network.dnsCacheExpirationGracePeriod", 3600);
// Increase DNS cache
pref("dnsCacheEntries", 2000);
pref("network.buffer.cache.size", 262144); // in bytes, 262144=256KB / "the stream buffer segment size used for most network activity." (http://forums.mozillazine.org/viewtopic.php?f=7&t=2416193) / "the default setting is 32 kB, and that corresponds with the buffer size of very old TCP/IP stacks." (https://www.mail-archive.com/support-seamonkey@lists.mozilla.org/msg74561.html)
pref("network.buffer.cache.count", 128); // https://www.mail-archive.com/support-seamonkey@lists.mozilla.org/msg74561.html
pref("network.http.pacing.requests.burst", 12); // default=10, controls how many HTTP requests are sent at once pref("network.http.pacing.requests.min-parallelism", 8); // default=6
pref("network.ssl_tokens_cache_capacity", 32768); // more TLS token caching (fast reconnects)
// Max connections (can speed things up as well)
pref("network.http.max-connections", 1800); // default=900
pref("network.http.max-connections-per-server", 32); // might not be used anymore, there's no line for it in searchfox (last default might have been 15) https://kb.mozillazine.org/Network.http.max-connections-per-server
pref("network.http.max-persistent-connections-per-server", 12); // default=6
pref("network.http.max-urgent-start-excessive-connections-per-host", 6); // default=3

// Codecs and DRM
pref("gfx.webrender.all", true);
pref("media.eme.enabled", true);
pref("media.gmp-gmpopenh264.enabled", true);
pref("media.ffmpeg.vaapi.enabled", true);

// De-enshittify and improve privacy
pref("browser.urlbar.suggest.trending", false);
pref("dom.private-attribution.submission.enabled", false);
pref("dom.security.https_only_mode", true);
pref("dom.security.https_only_mode_ever_enabled", true);
pref("privacy.donottrackheader.enabled", false); // Nothing uses this so turning it on just makes you more identifiable
pref("privacy.fingerprintingProtection", true);
pref("privacy.globalprivacycontrol.enabled", true);
pref("privacy.trackingprotection.emailtracking.enabled", true);
pref("privacy.trackingprotection.enabled", true);
pref("privacy.trackingprotection.socialtracking.enabled", true);
pref("signon.firefoxRelay.feature", "disabled");
pref("privacy.query_stripping.enabled", true);
pref("privacy.query_stripping.enabled.pbmode", true);
pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);
pref("browser.contentblocking.category", "strict");
pref("extensions.getAddons.showPane", false);
pref("extensions.webservice.discoverURL", "");
pref("extensions.getAddons.discovery.api_url", "");
pref("browser.discovery.enabled", false); // [SETTING] Privacy & Security>Firefox Data Collection & Use>...>Allow Firefox to make personalized extension recs. This pref has no effect when Health Reports are disabled
pref("extensions.htmlaboutaddons.discover.enabled", false);
pref("extensions.htmlaboutaddons.recommendations.enabled", false);
pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons", false); // Disable Extension recommendations ("Recommend extensions as you browse")
pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features", false); // "Recommend features as you browse"
pref("extensions.pocket.enabled", false);

// Disable all telemetry
pref("browser.newtabpage.activity-stream.feeds.telemetry", false);
pref("browser.newtabpage.activity-stream.telemetry", false);
pref("browser.ping-centre.telemetry", false);
pref("datareporting.healthreport.service.enabled", false);
pref("datareporting.healthreport.uploadEnabled", false);
pref("datareporting.policy.dataSubmissionEnabled", false);
pref("datareporting.sessions.current.clean", true);
pref("devtools.onboarding.telemetry.logged", false);
pref("toolkit.telemetry.archive.enabled", false);
pref("toolkit.telemetry.bhrPing.enabled", false);
pref("toolkit.telemetry.enabled", false);
pref("toolkit.telemetry.firstShutdownPing.enabled", false);
pref("toolkit.telemetry.hybridContent.enabled", false);
pref("toolkit.telemetry.newProfilePing.enabled", false);
pref("toolkit.telemetry.prompted", 2);
pref("toolkit.telemetry.rejected", true);
pref("toolkit.telemetry.reportingpolicy.firstRun", false);
pref("toolkit.telemetry.server", "");
pref("toolkit.telemetry.shutdownPingSender.enabled", false);
pref("toolkit.telemetry.unified", false);
pref("toolkit.telemetry.unifiedIsOptIn", false);
pref("toolkit.telemetry.updatePing.enabled", false);

// Speed things up
pref("network.dns.disablePrefetch", false);
pref("network.prefetch-next", true);
pref("network.predictor.enabled", true);
pref("network.dns.disablePrefetchFromHTTPS", false);
pref("network.predictor.enable-hover-on-ssl", true);
pref("security.remote_settings.crlite_filters.enabled", true);
pref("network.http.speculative-parallel-limit", 10);

// Better UX
pref("browser.download.useDownloadDir", false);
