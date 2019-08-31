# Answers
1. What is the number of unique users?
* 2903 
```
SELECT COUNT(DISTINCT(user_id)) from users
```
2. Who are the marketing ad providers? 
* Instagram
* Facebook
* Snapchat
* Spotify
``` 
SELECT DISTINCT(provider) from marketing
```
3. Which user property is changed the most frequently?
* drinking
```
SELECT property, COUNT(event_id) as times_changed from users GROUP BY property ORDER by times_changed DESC
```
4. Which ad was showed the most to users who identify as moderates?
* ad_id 4 (Technically this is for users who ever identified as moderate)
```
SELECT marketing.ad_id, COUNT(marketing.event_id) as times_shown FROM marketing JOIN users ON marketing.phone_id = users.phone_id WHERE users.property='politics' AND users.property_value='Moderate' GROUP BY marketing.ad_id ORDER BY times_shown DESC
```
5. What are the top 5 ads? Explain how you arrived at that conclusion.

If you look only at the ads served most often then it will look like 1,4,3,0 and 2 are the best ads.  But this is mostly because they are only ads that run on Spotify while ad traffic is spread out more across the other providers.
```
SELECT COUNT(DISTINCT(ad_id)) as num_unique_ads, provider FROM marketing GROUP BY provider
```
If we make the assumption that the reason an ad doesn't run on a provider is down to the provider and not the ad success than we should create a "top" ad rating that takes this into account and doesn't punish ads for not running on a provider. I added a table called ad_scores using Python that assigns a weighted value for each ad shown on a provider. It simply takes the set using the following query for each provider
```
SELECT ad_id, COUNT(event_id) as times_shown FROM marketing WHERE provider = (%s) GROUP BY marketing.ad_id ORDER BY times_shown DESC
```
And then calculates a score for each ad shown on a provider ranked between 0 and 1 based on number of times shown with 1 being the "best" ad and 0 being the "worst" ad. <b>Top five ads are 20, 15, 10, 21, and 5</b> via following query
```
SELECT ad_id, AVG(score) as avg_score from ad_scores group by ad_id ORDER BY avg_score DESC
```
Can see that this gives a much different set with none of the spotify ads making the cut. Ad 1 is just outside the top 5 at number 6.  ad_id 20 only runs on Instagram but is the best ad there.  This method probably favors the ads that only run on a few providers as the step down isn't as big between each ad. Could change the algorithm to only award points for the top 5 ads on each provider in reverse order to alleviate this problem.
