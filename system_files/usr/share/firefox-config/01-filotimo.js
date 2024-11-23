// IMPORTANT: Start your code on the 2nd line
// Integrate with KDE better
pref("widget.use-xdg-desktop-portal.file-picker", 1);

// Better performance in constrained situations
pref("browser.low_commit_space_threshold_mb", 750);
pref("browser.tabs.unloadOnLowMemory", true);

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
