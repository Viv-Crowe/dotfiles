// Form Fill

user_pref("browser.formfill.enable", false);
user_pref("extensions.formautofill.addresses.enabled", false);
user_pref("extensions.formautofill.creditCards.enabled", false);

// Telemetry / Mozilla

user_pref("app.shield.optoutstudies.enabled", false);
user_pref("datareporting.healthreport.uploadEnabled", false);
user_pref("toolkit.telemetry.pioneer-new-studies-available", false);

// Home Page

user_pref("browser.startup.homepage", "about:blank");
user_pref("browser.newtabpage.activity-stream.feeds.section.topstories", false);
user_pref("browser.newtabpage.activity-stream.feeds.topsites", false);
user_pref("browser.newtabpage.activity-stream.showSearch", false);
user_pref("browser.newtabpage.enabled", false);

// Search

user_pref("browser.search.hiddenOneOffs", "Amazon.ca,eBay");
user_pref("browser.search.region", "CA");

// Security

user_pref("browser.contentblocking.category", "strict");
user_pref("dom.security.https_only_mode", true);
user_pref("network.dns.disablePrefetch", true);

// DNS

user_pref("network.trr.uri", "https://dns.quad9.net/dns-query");
user_pref("network.trr.custom_uri", "https://dns.quad9.net/dns-query");
user_pref("network.trr.mode", 2);

// Browsing History

user_pref("places.history.enabled", false);
user_pref("privacy.clearOnShutdown.cache", false);
user_pref("privacy.clearOnShutdown.cookies", false);
user_pref("privacy.clearOnShutdown.sessions", false);
user_pref("privacy.donottrackheader.enabled", true);
user_pref("privacy.history.custom", true);

// Tracking and Privacy

user_pref("privacy.partition.network_state.ocsp_cache", true);
user_pref("privacy.purge_trackers.date_in_cookie_database", "0");
user_pref("privacy.sanitize.sanitizeOnShutdown", true);
user_pref("privacy.trackingprotection.enabled", true);
user_pref("privacy.trackingprotection.socialtracking.enabled", true);
user_pref("privacy.userContext.enabled", true);
user_pref("privacy.userContext.extension", "@contain-facebook");
user_pref("privacy.userContext.ui.enabled", true);
