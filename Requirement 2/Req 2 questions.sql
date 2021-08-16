SELECT * from sys.tables

SELECT * FROM user
SELECT * FROM receipts
SELECT * FROM brand
SELECT * FROM item
SELECT * FROM reward
SELECT * FROM rewardUser
SELECT * FROM rewardReceiptItemList










-- =========================================================
-- What are the top 5 brands by receipts scanned for most recent month?
-- =========================================================


SET @top5BrandsLastMonth = (SELECT  B.name AS top5BrandsM1, COUNT(*) AS quantity1 FROM 

brand B join Item AS I ON
B.brandId = I.brandId

join rewardsReceiptItemList AS RwRI ON
RwRI.itemBarcode = I.barcode 

join receipts AS R ON
R.id = RwRI.receiptId


WHERE R.dateScanned between '7/1/2021' and '7/31/2021'
-- is the latest month
-- or maybe assume between '7/1/2021' and '7/31/2021' assuming that the data is updated less than a week ago

GROUP BY B.name

ORDER BY quantity

LIMIT 5)

-- =========================================================
-- How does the ranking of the top 5 brands by receipts scanned for the recent month compare to the ranking for the previous month?
-- =========================================================

SET @top5BrandsBeforeLastMonth = (SELECT  B.name AS Top5BrandsM2, COUNT(*) AS quantity2 FROM 

brand AS B join Item AS I ON
B.brandId = I.brandId

join rewardsReceiptItemList AS RwRI ON
RwRI.itemBarcode = I.barcode 

join receipts AS R ON
R.id = RwRI.receiptId


WHERE R.dateScanned between '6/1/2021' and '6/30/2021'
-- month before the latest month
-- or maybe assume between '6/1/2021' and '6/30/2021' assuming that the data is updated less than a week ago

GROUP BY B.name

ORDER BY quantity

LIMIT 5)


SELECT * FROM @top5BrandsLastMonth, @top5BrandsBeforeLastMonth 

-- =========================================================
-- When considering average spend from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?
-- =========================================================

SET @avgSpendAccepted  = (SELECT AVG(R.totalSpend) AS spendAverage ,  R.rewardsReceiptStatus AS receiptStatus
FROM receipts AS R
WHERE R.rewardsReceiptStatus = 'ACCEPTED')  -- matching Upper case

SET @avgSpendRejected = ( SELECT AVG(R.totalSpend) , R.rewardsReceiptStatus AS receiptStatus
FROM receipts AS R
WHERE R.rewardsReceiptStatus = 'REJECTED' ) -- matching Upper case

SELECT MAX (spendAverage), receiptStatus
FROM @avgSpendAccepted UNION @avgSpendRejected
 



-- =========================================================
-- When considering total number of items purchased from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?
-- =========================================================




SET @receiptCountAccepted = (SELECT COUNT(*) AS numItemsPurchased, R.id AS receipt , R.rewardsReceiptStatus AS receiptStatus
FROM receipts AS R join rewardReceiptItemList AS RwRI ON
R.Id = RwRI.receiptId

WHERE R.rewardsReceiptStatus = 'ACCEPTED'
GROUP BY receipt)

-- returns a table with the sum of all items from all receipts with status 'ACCEPTED'
SET @totalItemsAccepted = (SELECT SUM( numItemsPurchased ) AS totalItems, receiptStatus
FROM @receiptCountAccepted)




SET @receiptCountRejected = (SELECT COUNT(*) AS numItemsPurchased, R.id AS receipt , R.rewardsReceiptStatus AS receiptStatus
FROM receipts AS R join rewardReceiptItemList AS RwRI ON
R.Id = RwRI.receiptId

WHERE R.rewardsReceiptStatus = 'REJECTED'
GROUP BY receipt)

-- returns a table with the sum of all items from all receipts with status 'REJECTED'
SET @totalItemsRejected = (SELECT SUM( numItemsPurchased ) AS totalItems, receiptStatus
FROM @receiptCountRejected)





SELECT MAX (totalItems), receiptStatus
FROM @totalItemsAccepted UNION @totalItemsRejected




-- =========================================================
-- Which brand has the most spend among users who were created within the past 6 months?
-- =========================================================

SET @recentUsers = ( SELECT U.Id
FROM user AS U
WHERE U.createdDate >= '2/13/2021' )

SELECT SUM( I.itemPrice ) AS brandTotalSpend, B.name  
FROM @recentUsers AS RU join receipts AS R ON
RU.id = R.userID

join rewardReceiptItemList AS RwRI ON
R.Id = RwRI.receiptId

join item AS I ON
I.barcode = RwRI.itemBarcode

join brand AS B ON
B.Id = I.brandId

GROUP BY B.name

ORDER BY brandTotalSpend DESC

LIMIT 1






-- =========================================================
-- Which brand has the most transactions among users who were created within the past 6 months?
-- =========================================================

SET @recentUsers = ( SELECT U.Id
FROM user AS U
WHERE U.createdDate >= '2/13/2021'


SET @doubleGroupTable  = ( SELECT B.name, R.Id  
FROM @recentUsers AS RU join receipts AS R ON
RU.id = R.userID

join rewardReceiptItemList AS RwRI ON
R.Id = RwRI.receiptId

join item AS I ON
I.barcode = RwRI.itemBarcode

join brand AS B ON
B.Id = I.brandId

GROUP BY B.name , R.Id )


SELECT B.name, COUNT(B.name) AS totalTransactionsByBrand
FROM @doubleGroupTable

GROUP BY B.name

ORDER BY totalTransactionsByBrand DESC

LIMIT 1



