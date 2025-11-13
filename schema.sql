--Creating tables:

CREATE TABLE "visitors" (
    "id" INTEGER PRIMARY KEY,
    "device_type" TEXT CHECK("device_type" IN ('desktop', 'mobile', 'tablet', 'tv', 'console')),
    "browser" TEXT DEFAULT 'unknown',
    "city" TEXT NOT NULL,
    "country" TEXT NOT NULL
)

CREATE TABLE "sessions" (
    "id" INTEGER PRIMARY KEY,
    "visitor_id" INTEGER NOT NULL,
    "start_time" TEXT NOT NULL,
    "end_time" TEXT,
    "referrer" TEXT,
    "landing_page" TEXT NOT NULL,
    FOREIGN KEY "visitor_id" REFERENCES "visitors"("id") ON DELETE CASCADE
)

CREATE TABLE "page_views" (
    "id" INTEGER PRIMARY KEY,
    "session_id" INTEGER NOT NULL,
    "page_url" TEXT NOT NULL,
    "timestamp" TEXT NOT NULL,
    "time_spent" INTEGER,
    FOREIGN KEY "session_id" REFERENCES "sessions"("id") ON DELETE CASCADE
)

CREATE TABLE "events" (
    "id" INTEGER PRIMARY KEY,
    "session_id" INTEGER NOT NULL,
    "event_type" TEXT CHECK("event_type" IN ('click', 'scroll', 'signup', 'hover'))NOT NULL,
    "event_target" TEXT NOT NULL,
    "timestamp" TEXT NOT NULL,
    FOREIGN KEY "session_id" REFERENCES "sessions"("id") ON DELETE CASCADE
)

--Creating indexes to optimize the most popular queries:

CREATE INDEX "sessions_visitor" ON "sessions"("visitor_id");
CREATE INDEX "page_views_session" ON "page_views"("session_id");
CREATE INDEX "events_session" ON "events"("session_id");
CREATE INDEX "page_views_url" ON "page_views"("page_url");
CREATE INDEX "visitors_device" ON "visitors"("device_type");
CREATE INDEX "visitors_country" ON "visitors"("country");
CREATE INDEX "sessions_referrer" ON "sessions"("referrer");
CREATE INDEX "sessions_landing" ON "sessions"("landing_page");

--Creating views:

--1. Top Pages View:
CREATE VIEW "top_pages" AS
SELECT "page_url", COUNT(*) AS "visits" FROM "page_views"
GROUP BY "page_url" ORDER BY "visits" DESC;

--2. Top Landing Pages:
CREATE VIEW "top_landing_pages" AS
SELECT "landing_page", COUNT("landing_page") AS "sessions_count" FROM "sessions"
GROUP BY "landing_page" ORDER BY "sessions_count" DESC;

--3. Visitor Sessions Summary:
CREATE VIEW "visitor_sessions" AS
SELECT "visitors"."id", COUNT("sessions"."id") AS "total_sessions",
COUNT("page_views"."id") AS "total_pages_viewed" FROM "visitors"
LEFT JOIN "sessions" ON "sessions"."visitor_id"="visitors"."id"
LEFT JOIN "page_views" ON "page_views"."session_id"="sessions"."id"
GROUP BY "visitors"."id";

--4. Event Summary:
CREATE VIEW "event_summary" AS
SELECT "event_type", COUNT("event_type") AS "total_count" FROM "events"
GROUP BY "event_type"
ORDER BY "total_count" DESC;

--5. Daily Traffic View:
CREATE VIEW "daily_traffic" AS
SELECT DATE("start_time") AS "date", COUNT(*) AS "sessions_count" FROM "sessions"
GROUP BY DATE("start_time") ORDER BY DATE("start_time");


