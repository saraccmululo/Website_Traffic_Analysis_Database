-- Typical SQL queries users can run on this database

--1. Get the most visits by country:
SELECT "country", COUNT("country") AS "visitors_count" FROM "visitors"
GROUP BY "country" ORDER BY "visitors_count" DESC;

--2. Retrieve the most visits by device type:
SELECT "device_type", COUNT("device_type") AS "total" FROM "visitors"
GROUP BY "device" ORDER BY "total" DESC;

--3. Calculate the number of sessions per visitor:
SELECT "visitor_id", COUNT("visitor_id") AS "total_sessions" FROM "sessions"
GROUP BY "visitor_id" ORDER BY "total_sessions" DESC;

--4. Get the 10 most visited pages (utilizing top_pages view):
SELECT * FROM "top_pages" LIMIT 10;

--5. Find the 5 top landing pages (utilizing top_landing_pages view):
SELECT * FROM "top_landing_pages" LIMIT 5;

--6. Retrieve the pages with the most average time spent:
SELECT "page_url", AVG("time_spent") AS "avg_time_spent" FROM "page_views"
GROUP BY "page_url" ORDER BY "avg_time_spent" DESC;

--7. Count total events by type (utilizing the event summary view):
SELECT * FROM "event_summary";

--8. Get traffic trend by day (utilizing the daily_traffic view):
SELECT * FROM "daily_traffic";

--9. Retrieve the top 5 referrer:
SELECT "referrer", COUNT("referrer") AS "total_count" FROM "sessions"
GROUP BY "referrer" ORDER BY "total_count" DESC LIMIT 5;

--10. Show visitors and their total number of events:
SELECT "visitors"."id", "visitors"."country", COUNT("events"."id") AS "total_events"
FROM "visitors" JOIN "sessions" ON "visitors"."id"="sessions"."visitor_id"
JOIN "events" ON "sessions"."id"="events"."session_id"
GROUP BY "visitors"."id" ORDER BY "total_events" DESC;

--11. Insert a new visitor:
INSERT INTO "visitors" ("device_type", "browser", "city", "country")
VALUES ('mobile', 'Chrome', 'Toronto', 'Canada');

--12. Insert a new session for a visitor:
INSERT INTO "sessions" ("visitor_id", "start_time", "end_time", "referrer", "landing_page")
VALUES (1, '2025-11-12 10:00:00', '2025-11-12 10:30:00', 'https://google.com', '/home');

--13. Insert a new page view:
INSERT INTO "page_views" ("session_id", "page_url", "timestamp", "time_spent")
VALUES (1,'/home','2025-11-12 10:01',5);

--14. Insert an event (e.g., a button click):
INSERT INTO "events" ("session_id", "event_type", "event_target", "timestamp")
VALUES (1, 'click', '#signup-button', '2025-11-12 10:07:00');

--15. Update the end_time of a session:
UPDATE "sessions" SET "end_time" = '2025-11-12 10:45:00' WHERE "id"=1;

--16. Delete a visitor:
DELETE FROM "visitors" WHERE "id"=5;
