
-- ===============================================
-- Query 1: Get User Transaction History
-- ===============================================
-- Replace @user_id with desired user ID before executing
SET @user_id = 1;

SELECT 
    t.id AS transaction_id,
    t.total_amount,
    t.created_at,
    t.email,
    t.payment_method,
    t.alamat,
    t.shipping_method,
    p.name AS product_name,
    ti.quantity,
    ti.price
FROM transactions t
JOIN transaction_items ti ON t.id = ti.transaction_id
JOIN products p ON ti.product_id = p.id
WHERE t.user_id = @user_id
ORDER BY t.created_at DESC;

-- ===============================================
-- Query 2: Get All Transactions With Details
-- ===============================================
SELECT 
    t.id AS transaction_id,
    t.user_id,
    u.username AS buyer_username,
    t.total_amount,
    t.created_at,
    t.email,
    t.payment_method,
    t.alamat,
    t.shipping_method,
    p.name AS product_name,
    ti.quantity,
    ti.price
FROM transactions t
JOIN users u ON t.user_id = u.id
JOIN transaction_items ti ON t.id = ti.transaction_id
JOIN products p ON ti.product_id = p.id
ORDER BY t.created_at DESC;

-- ===============================================
-- Query 3: Stored Procedure for Abandoned Carts
-- ===============================================

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_abandoned_carts$$

CREATE PROCEDURE sp_abandoned_carts()
BEGIN
    SELECT 
        u.email,
        u.username,
        COUNT(DISTINCT ci.product_id) AS items_in_cart,
        SUM(p.price * ci.quantity) AS potential_revenue,
        DATEDIFF(NOW(), MAX(ci.created_at)) AS days_abandoned,
        GROUP_CONCAT(p.name SEPARATOR ', ') AS abandoned_books
    FROM cart_items ci
    JOIN users u ON ci.user_id = u.id
    JOIN products p ON ci.product_id = p.id
    WHERE NOT EXISTS (
        SELECT 1
        FROM transactions t
        JOIN transaction_items ti ON t.id = ti.transaction_id
        WHERE t.user_id = ci.user_id 
        AND ti.product_id = ci.product_id
        AND t.created_at > ci.created_at
    )
    AND DATEDIFF(NOW(), ci.created_at) > 7
    GROUP BY u.id
    HAVING potential_revenue > 1000;
END$$

DELIMITER ;

-- ===============================================
-- Query 4: Reports - Top Selling, Income By Type, Daily Sales
-- ===============================================

-- Top Selling Products
-- Replace @limit with desired number of top products
SET @limit = 5;

SELECT 
    p.name AS product_name,
    SUM(ti.quantity) AS total_sold
FROM transaction_items ti
JOIN products p ON ti.product_id = p.id
GROUP BY ti.product_id
ORDER BY total_sold DESC
LIMIT @limit;

-- Income by Product Type
SELECT 
    p.type AS tipe_produk,
    SUM(ti.quantity * ti.price) AS total_income
FROM transaction_items ti
JOIN products p ON ti.product_id = p.id
GROUP BY p.type
ORDER BY total_income DESC;

-- Daily Sales Report
SELECT 
    DATE(t.created_at) AS tanggal,
    COUNT(DISTINCT t.id) AS jumlah_transaksi,
    SUM(ti.quantity) AS total_produk_terjual,
    SUM(ti.quantity * ti.price) AS total_pendapatan
FROM transactions t
JOIN transaction_items ti ON t.id = ti.transaction_id
GROUP BY DATE(t.created_at)
ORDER BY tanggal DESC;
