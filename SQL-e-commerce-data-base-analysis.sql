-- The data that are related to the account need to be collected and joined
WITH
  account_params AS(
  SELECT
    s.date AS date_creation,
    sp.country,
    a.send_interval,
    a.is_verified,
    a.is_unsubscribed,
    COUNT(DISTINCT a.id) AS account_cnt
  FROM
    DA.account a
  JOIN
    DA.account_session acs
  ON
    a.id = acs.account_id
  JOIN
    DA.session s
  ON
    acs.ga_session_id = s.ga_session_id
  JOIN
    DA.session_params sp
  ON
    acs.ga_session_id = sp.ga_session_id
  GROUP BY
    s.date,
    sp.country,
    a.send_interval,
    a.is_verified,
    a.is_unsubscribed),
  --We collect email metrics(sent, opened and visited) by date and countries
  cnt_messages AS(
SELECT
  sp.country,
  a.send_interval,
  a.is_verified,
  a.is_unsubscribed,
  DATE_ADD(s.date, INTERVAL es.sent_date DAY) AS sent_date,
  COUNT(DISTINCT es.id_message) AS sent_msg,
  COUNT(DISTINCT eo.id_message) AS open_msg,
  COUNT(DISTINCT ev.id_message) AS visit_msg
FROM
  DA.email_sent es
LEFT JOIN
  DA.email_open eo
ON
  es.id_message = eo.id_message
LEFT JOIN
  DA.email_visit ev
ON
  eo.id_message = ev.id_message
JOIN
  DA.account a
ON
  es.id_account = a.id
JOIN
  DA.account_session acs
ON
  a.id = acs.account_id
JOIN
  DA.session s
ON
  acs.ga_session_id = s.ga_session_id
JOIN
  DA.session_params sp
ON
  s.ga_session_id = sp.ga_session_id
GROUP BY
  sent_date,
  sp.country,
  a.send_interval,
  a.is_verified,
  a.is_unsubscribed ),
  -- The two previous tables are being combined
union_acc_and_emails AS(
SELECT
  ap.date_creation AS date,
  ap.country,
  ap.send_interval,
  ap.is_verified,
  ap.is_unsubscribed,
  ap.account_cnt,
  0 AS sent_msg,
  0 AS open_msg,
  0 AS visit_msg
FROM
  account_params ap
UNION ALL
SELECT
  cm.sent_date AS date,
  cm.country,
  cm.send_interval,
  cm.is_verified,
  cm.is_unsubscribed,
  0 AS account_cnt,
  cm.sent_msg,
  cm.open_msg,
  cm. visit_msg
FROM
  cnt_messages cm ),
  --We aggregate the previously combined data to summarize all rows in the table.
  aggregation AS(
SELECT
  date,
  country,
  send_interval,
  is_verified,
  is_unsubscribed,
  SUM(account_cnt) AS account_cnt,
  SUM(sent_msg) AS sent_msg,
  SUM(open_msg) AS open_msg,
  SUM(visit_msg) AS visit_msg
FROM
  union_acc_and_emails
GROUP BY
  date,
  country,
  send_interval,
  is_verified,
  is_unsubscribed ),
  --The total number of created subscribers and sent letters is calculated separately for each country
  total_account AS(
SELECT
  *,
  SUM(a.account_cnt)OVER(PARTITION BY a.country) AS total_country_account_cnt,
  SUM(a.sent_msg) OVER(PARTITION BY a.country) AS total_country_sent_cnt
FROM
  aggregation a),
  --The rankings based on the number of created subscribers and the number of sent letters are calculated separately for each country
  rank_total AS(
SELECT
  *,
  DENSE_RANK()OVER (ORDER BY ta.total_country_account_cnt DESC) AS rank_total_country_account_cnt,
  DENSE_RANK()OVER (ORDER BY ta.total_country_sent_cnt DESC) AS rank_total_country_sent_cnt
FROM
  total_account ta )
  --We filter the final result where either rank_total_country_sent_cnt or rank_total_country_account_cnt is less than or equal to 10


 
SELECT
  *
FROM
  rank_total rt
WHERE
  rt.rank_total_country_account_cnt <=10
  OR rt.rank_total_country_sent_cnt <=10
ORDER BY
  rt.date
