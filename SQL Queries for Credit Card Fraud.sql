-- 1 -- Taking a look at the transations who were Successfully Completed AND Flagged as Fraud
SELECT 
  transaction_date_and_time,
  transaction_mount,
  transaction_currency,
  transaction_response_code
FROM `majestic-casing-426419-i6.credit_card_fraud.cc_fraud`
WHERE
  transaction_response_code = 0
  AND fraud_flag_or_label = 1
ORDER BY
  transaction_date_and_time DESC;

-- 2 -- Taking a look at the total of confirmed fraud transactions per currency that were Successfully Complete
SELECT 
  transaction_currency,
  SUM(transaction_mount) AS total_transaction_amount
FROM (
  SELECT
    transaction_mount,
    transaction_currency
  FROM `majestic-casing-426419-i6.credit_card_fraud.cc_fraud`
  WHERE
    transaction_response_code = 0
    AND fraud_flag_or_label = 1
)
GROUP BY transaction_currency
ORDER BY transaction_currency DESC;

-- 3 -- Total transactions in the entire dataset in each currency (important for statistics and calculations compared to query nr. 2)
SELECT 
  transaction_currency,
  SUM(transaction_mount) AS total_transaction_amount
FROM `majestic-casing-426419-i6.credit_card_fraud.cc_fraud`
GROUP BY transaction_currency
ORDER BY transaction_currency DESC;

-- 4 -- Taking a look at the total fraud transactions per card type that were Successfully Complete 
SELECT DISTINCT
  card_type,
  SUM(transaction_mount) AS total_transaction_amount
FROM 
  `majestic-casing-426419-i6.credit_card_fraud.cc_fraud`
WHERE
    transaction_response_code = 0
    AND fraud_flag_or_label = 1
GROUP By card_type
ORDER BY card_type DESC;

-- 5 -- Total successful fraud transactions made in Person VS Online 
SELECT
  transaction_source,
  SUM(transaction_mount) AS total_transaction_amount
FROM 
  `majestic-casing-426419-i6.credit_card_fraud.cc_fraud`
WHERE
    transaction_response_code = 0
    AND fraud_flag_or_label = 1
GROUP By transaction_source
ORDER BY transaction_source DESC;

-- 5.1 -- Total transactions (ALL) made in Person VS Online
SELECT
  transaction_source,
  SUM(transaction_mount) AS total_transaction_amount
FROM 
  `majestic-casing-426419-i6.credit_card_fraud.cc_fraud`
GROUP BY transaction_source
ORDER BY transaction_source DESC;

--5.2 -- Total transactions that were flagged as fraud BUT were BLOCKED/DECLINED
SELECT
  transaction_source,
  SUM(transaction_mount) AS total_transaction_amount
FROM 
  `majestic-casing-426419-i6.credit_card_fraud.cc_fraud`
WHERE
  (transaction_response_code IN (5, 12))
  AND fraud_flag_or_label = 1
GROUP BY transaction_source
ORDER BY transaction_source DESC;

-- 6 -- SC Fraud by Device
SELECT 
  device_information,
  SUM(transaction_mount) AS total_transaction_amount
FROM `majestic-casing-426419-i6.credit_card_fraud.cc_fraud`
WHERE
  transaction_response_code = 0
  AND fraud_flag_or_label = 1
GROUP BY device_information
ORDER BY device_information DESC;

-- 7 -- Top 10 Location with SC Fraud
SELECT
  transaction_location,
  ROUND (SUM(transaction_mount)) AS total_transaction_amount
FROM 
  `majestic-casing-426419-i6.credit_card_fraud.cc_fraud`
WHERE
    transaction_response_code = 0
    AND fraud_flag_or_label = 1
GROUP BY transaction_location
ORDER BY total_transaction_amount DESC
LIMIT 10
