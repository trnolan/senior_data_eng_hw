-- What is the number of unique users?
SELECT COUNT(DISTINCT(user_id)) from users
/* 2903 */
-- Who are the marketing ad providers?
SELECT DISTINCT(provider) from marketing
/* 
1 Instagram
2	Facebook
3	Snapchat
4	Spotify
*/
-- Which user property is changed the most frequently?
-- drinking
SELECT property, COUNT(event_id) as times_changed from users GROUP BY property ORDER by times_changed DESC
/*
1   drinking	1473
2	politics	1435
3	notifications	1434
4	sex	1427
5	smoking	1418
*/
-- Which ad was showed the most to users who identify as moderates?
-- ad_id 4
SELECT marketing.ad_id, COUNT(marketing.event_id) as times_shown, users.property, users.property_value FROM marketing JOIN users ON marketing.phone_id = users.phone_id WHERE users.property='politics' AND users.property_value='Moderate' GROUP BY marketing.ad_id, users.property, users.property_value ORDER BY times_shown DESC
/*
ad_id times_shown property property_value
1	4	77	politics	Moderate
2	2	68	politics	Moderate
3	1	64	politics	Moderate
4	0	60	politics	Moderate
5	3	55	politics	Moderate
6	7	47	politics	Moderate
7	8	39	politics	Moderate
8	5	38	politics	Moderate
9	9	37	politics	Moderate
10	6	29	politics	Moderate
11	12	23	politics	Moderate
12	10	21	politics	Moderate
13	15	21	politics	Moderate
14	17	18	politics	Moderate
15	19	17	politics	Moderate
16	14	17	politics	Moderate
17	20	16	politics	Moderate
18	18	16	politics	Moderate
19	13	15	politics	Moderate
20	11	13	politics	Moderate
21	16	11	politics	Moderate
22	21	7	politics	Moderate
23	22	5	politics	Moderate
*/
-- What are the top 5 ads? Explain how you arrived at that conclusion.
SELECT COUNT(DISTINCT(ad_id)) as num_unique_ads, provider FROM marketing GROUP BY provider
SELECT ad_id, COUNT(event_id) as times_shown, provider FROM marketing GROUP BY marketing.ad_id, provider ORDER BY times_shown DESC
SELECT ad_id, AVG(score) as avg_score from ad_scores group by ad_id ORDER BY avg_score DESC