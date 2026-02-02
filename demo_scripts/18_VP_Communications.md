# Demo Script 16: Social Media & Sentiment Analytics

## Persona: VP of Communications / Head of Brand

**Name:** Emma Richardson  
**Role:** VP of Communications  
**Focus:** Brand reputation, social media monitoring, crisis management, voice of customer

**Key Documents:** Crisis_Communications_Playbook.md

---

## Background

Emma manages SnowTelco's brand reputation and communications. She monitors social media sentiment, responds to customer concerns, identifies emerging issues before they escalate, and measures brand perception.

---

## Demo Questions

### Sentiment Analysis

1. **"What's our overall social media sentiment this month?"**
   - Expected: Sentiment distribution (positive/negative/neutral)
   - Data: social_mention_fact

2. **"Show me the sentiment trend over the past week"**
   - Expected: Daily sentiment trend
   - Data: social_mention_fact

3. **"Which platforms have the most negative mentions?"**
   - Expected: Platform sentiment comparison
   - Data: social_mention_fact

### Topic Analysis

4. **"What topics are customers talking about most?"**
   - Expected: Topic distribution
   - Data: social_mention_fact

5. **"Show me negative mentions about network quality"**
   - Expected: Network-related complaints
   - Data: social_mention_fact

6. **"Which topics have the worst sentiment?"**
   - Expected: Topic sentiment ranking
   - Data: social_mention_fact

### Response Management

7. **"How many mentions require a response that we haven't responded to?"**
   - Expected: Response backlog
   - Data: social_mention_fact

8. **"What's our average response time to negative mentions?"**
   - Expected: Response time metrics
   - Data: social_mention_fact

9. **"Show me high-reach negative mentions from influencers"**
   - Expected: Priority response list
   - Data: social_mention_fact

### Crisis Management (Document Search)

10. **"What is our crisis response protocol and escalation timeline?"**
    - Expected: Process from Crisis_Communications_Playbook.md
    - Insights: Golden hour activities, stakeholder notification order

11. **"What are our message templates for network outage communications?"**
    - Expected: Templates from Crisis_Communications_Playbook.md
    - Data: Holding statement templates, status update formats

---

## Key Insights to Highlight

- Social sentiment distribution (35% positive, 40% negative, 25% neutral)
- Platform-specific patterns
- Topic correlation with sentiment
- Importance of timely response
- Crisis playbook provides response protocols and templates
- First hour "golden hour" is critical for crisis management

---

## SQL Examples

```sql
-- Overall sentiment distribution
SELECT 
    sentiment,
    COUNT(*) as mentions,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 1) as pct,
    ROUND(AVG(sentiment_score), 3) as avg_score,
    SUM(reach_count) as total_reach
FROM social_mention_fact
WHERE mention_date >= DATEADD(month, -1, CURRENT_DATE)
GROUP BY sentiment
ORDER BY mentions DESC;

-- Sentiment by platform
SELECT 
    platform,
    COUNT(*) as mentions,
    SUM(CASE WHEN sentiment = 'positive' THEN 1 ELSE 0 END) as positive,
    SUM(CASE WHEN sentiment = 'negative' THEN 1 ELSE 0 END) as negative,
    ROUND(AVG(sentiment_score), 3) as avg_sentiment
FROM social_mention_fact
WHERE mention_date >= DATEADD(month, -1, CURRENT_DATE)
GROUP BY platform
ORDER BY mentions DESC;

-- Topic sentiment analysis
SELECT 
    topic,
    COUNT(*) as mentions,
    ROUND(AVG(sentiment_score), 3) as avg_sentiment,
    SUM(CASE WHEN sentiment = 'negative' THEN 1 ELSE 0 END) as negative_count,
    SUM(reach_count) as total_reach
FROM social_mention_fact
WHERE mention_date >= DATEADD(week, -1, CURRENT_DATE)
GROUP BY topic
ORDER BY negative_count DESC;

-- Response backlog
SELECT 
    platform,
    COUNT(*) as unresponded_mentions,
    SUM(reach_count) as total_reach_at_risk
FROM social_mention_fact
WHERE requires_response = TRUE 
    AND responded = FALSE
    AND mention_date >= DATEADD(day, -7, CURRENT_DATE)
GROUP BY platform
ORDER BY total_reach_at_risk DESC;

-- High-priority negative mentions (influencers)
SELECT 
    mention_id,
    platform,
    mention_timestamp,
    content_snippet,
    topic,
    reach_count,
    responded
FROM social_mention_fact
WHERE sentiment = 'negative' 
    AND is_influencer = TRUE
    AND mention_date >= DATEADD(day, -7, CURRENT_DATE)
ORDER BY reach_count DESC
LIMIT 20;

-- Daily sentiment trend
SELECT 
    mention_date,
    COUNT(*) as total_mentions,
    ROUND(AVG(sentiment_score), 3) as avg_sentiment,
    SUM(CASE WHEN sentiment = 'positive' THEN 1 ELSE 0 END) as positive,
    SUM(CASE WHEN sentiment = 'negative' THEN 1 ELSE 0 END) as negative
FROM social_mention_fact
WHERE mention_date >= DATEADD(day, -30, CURRENT_DATE)
GROUP BY mention_date
ORDER BY mention_date;
```

---

## Demo Flow

1. Show overall sentiment dashboard
2. Analyze platform differences
3. Deep dive into topic sentiment
4. Review response management metrics
5. Identify priority items for action
