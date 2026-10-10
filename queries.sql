-- Query 1: Vendor Fill Rate Analysis (Milk Category in Coimbatore)
-- Analyzes weekly purchase orders vs. received GRN quantities to isolate supply collapse
SELECT 
    sk.category,
    CASE 
        WHEN po.po_date BETWEEN '2026-07-06' AND '2026-07-12' THEN 'Week 1'
        WHEN po.po_date BETWEEN '2026-07-13' AND '2026-07-19' THEN 'Week 2'
        WHEN po.po_date BETWEEN '2026-07-20' AND '2026-07-26' THEN 'Week 3'
        WHEN po.po_date BETWEEN '2026-07-27' AND '2026-08-02' THEN 'Week 4'
        WHEN po.po_date BETWEEN '2026-08-03' AND '2026-08-09' THEN 'Week 5'
        WHEN po.po_date BETWEEN '2026-08-10' AND '2026-08-16' THEN 'Week 6'
        WHEN po.po_date BETWEEN '2026-08-17' AND '2026-08-23' THEN 'Week 7'
        WHEN po.po_date BETWEEN '2026-08-24' AND '2026-08-31' THEN 'Week 8'
    END AS week_name,
    SUM(po.po_qty) AS total_ordered,
    SUM(g.received_qty) AS total_received,
    ROUND(SUM(g.received_qty) * 100.0 / SUM(po.po_qty), 2) AS fill_rate_pct
FROM purchase_orders po
JOIN grn g ON po.po_id = g.po_id
JOIN stores s ON po.store_id = s.store_id
JOIN skus sk ON po.sku_id = sk.sku_id
WHERE s.city = 'Coimbatore' AND sk.category = 'Milk'
GROUP BY week_name
ORDER BY week_name;

-- Query 2: Store Downtime Analysis (Full-Day Maintenance Closures)
-- Audits dark store downtime at CBE04 and CBE09
SELECT 
    store_id,
    reason,
    COUNT(closure_date) AS total_days_closed
FROM store_closures
WHERE closed_full_day = 1
GROUP BY store_id, reason;
