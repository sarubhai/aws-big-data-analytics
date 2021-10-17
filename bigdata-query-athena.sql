-- Database
CREATE DATABASE bigdatagen;

-- Region Table
CREATE EXTERNAL TABLE IF NOT EXISTS region (
  r_regionkey INT,
  r_name CHAR(25),
  r_comment VARCHAR(152)
) 
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\n'
LOCATION 's3://bigdata-gen/bigdata/region/';

SELECT count(*) count FROM region;
SELECT * FROM region LIMIT 10;

-- Nation Table
CREATE EXTERNAL TABLE IF NOT EXISTS nation (
  n_nationkey INT,
  n_name CHAR(25),
  n_regionkey INT,
  n_comment VARCHAR(152)
) 
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\n'
LOCATION 's3://bigdata-gen/bigdata/nation/';

SELECT count(*) count FROM nation;
SELECT * FROM nation LIMIT 10;

-- Customer Table
CREATE EXTERNAL TABLE IF NOT EXISTS customer (
  c_custkey INT,
  c_name CHAR(25),
  c_address VARCHAR(40),
  c_nationkey INT,
  c_phone CHAR(15),
  c_acctbal DECIMAL(12,2),
  c_mktsegment CHAR(10),
  c_comment VARCHAR(117)
) 
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\n'
LOCATION 's3://bigdata-gen/bigdata/customer/';

SELECT count(*) count FROM customer;
SELECT * FROM customer LIMIT 10;

-- Supplier Table
CREATE EXTERNAL TABLE IF NOT EXISTS supplier (
  s_suppkey INT,
  s_name CHAR(25),
  s_address VARCHAR(40),
  s_nationkey INT,
  s_phone CHAR(15),
  s_acctbal DECIMAL(12,2),
  s_comment VARCHAR(101)
) 
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\n'
LOCATION 's3://bigdata-gen/bigdata/supplier/';

SELECT count(*) count FROM supplier;
SELECT * FROM supplier LIMIT 10;

-- Part Table
CREATE EXTERNAL TABLE IF NOT EXISTS part (
  p_partkey INT,
  p_name CHAR(55),
  p_mfgr CHAR(25),
  p_brand CHAR(10),
  p_type VARCHAR(25),
  p_size INT,
  p_container CHAR(10),
  p_retailprice DECIMAL(12,2),
  p_comment VARCHAR(23)
) 
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\n'
LOCATION 's3://bigdata-gen/bigdata/part/';

SELECT count(*) count FROM part;
SELECT * FROM part LIMIT 10;

-- PartSupplier Table
CREATE EXTERNAL TABLE IF NOT EXISTS partsupp (
  ps_partkey INT,
  ps_suppkey INT,
  ps_availqty INT,
  ps_supplycost DECIMAL(12,2),
  ps_comment VARCHAR(199)
) 
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\n'
LOCATION 's3://bigdata-gen/bigdata/partsupp/';

SELECT count(*) count FROM partsupp;
SELECT * FROM partsupp LIMIT 10;

-- Orders Table
CREATE EXTERNAL TABLE IF NOT EXISTS orders (
  o_orderkey INT,
  o_custkey INT,
  o_orderstatus CHAR(1),
  o_totalprice DECIMAL(12,2),
  o_orderdate DATE,
  o_orderpriority CHAR(15),
  o_clerk CHAR(15),
  o_shippriority INT,
  o_comment VARCHAR(79)
) 
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\n'
LOCATION 's3://bigdata-gen/bigdata/orders/';

SELECT count(*) count FROM orders;
SELECT * FROM orders LIMIT 10;

-- LineItem table
CREATE EXTERNAL TABLE IF NOT EXISTS lineitem (
  l_orderkey INT,
  l_partkey INT,
  l_suppkey INT,
  l_linenumber INT,
  l_quantity DECIMAL(12,2),
  l_extendedprice DECIMAL(12,2),
  l_discount DECIMAL(12,2),
  l_tax DECIMAL(12,2),
  l_returnflag CHAR(1),
  l_linestatus CHAR(1),
  l_shipdate DATE,
  l_commitdate DATE,
  l_receiptdate DATE,
  l_shipinstruct CHAR(25),
  l_shipmode CHAR(10),
  l_comment VARCHAR(44)
) 
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\n'
LOCATION 's3://bigdata-gen/bigdata/lineitem/';

SELECT count(*) count FROM lineitem;
SELECT * FROM lineitem LIMIT 10;



-- Query Analysis
-- Query 1
SELECT
  l_returnflag,
  l_linestatus,
  sum(l_quantity) as sum_qty,
  sum(l_extendedprice) as sum_base_price,
  sum(l_extendedprice * (1 - l_discount)) as sum_disc_price,
  sum(l_extendedprice * (1 - l_discount) * (1 + l_tax)) as sum_charge,
  avg(l_quantity) as avg_qty,
  avg(l_extendedprice) as avg_price,
  avg(l_discount) as avg_disc,
  count(*) as count_order
FROM
  lineitem
WHERE
  l_shipdate <= date '1998-12-01' - interval '90' day
GROUP BY
  l_returnflag,
  l_linestatus
ORDER BY
  l_returnflag,
  l_linestatus;

-- Query 3
SELECT
  l_orderkey,
  sum(l_extendedprice * (1 - l_discount)) as revenue,
  o_orderdate,
  o_shippriority
FROM
  customer,
  orders,
  lineitem
WHERE
  c_custkey = o_custkey
  AND l_orderkey = o_orderkey
  AND c_mktsegment = 'BUILDING'
  AND o_orderdate < date '1995-03-15'
  AND l_shipdate > date '1995-03-15'
GROUP BY
  l_orderkey,
  o_orderdate,
  o_shippriority
ORDER BY
  revenue desc,
  o_orderdate
LIMIT 20;

-- Query 5
SELECT
  n_name,
  sum(l_extendedprice * (1 - l_discount)) as revenue
FROM
  customer,
  orders,
  lineitem,
  supplier,
  nation,
  region
WHERE
  c_custkey = o_custkey
  AND l_orderkey = o_orderkey
  AND l_suppkey = s_suppkey
  AND c_nationkey = s_nationkey
  AND s_nationkey = n_nationkey
  AND n_regionkey = r_regionkey
  AND r_name = 'ASIA'
  AND o_orderdate >= date '1994-01-01'
  AND o_orderdate < date '1994-01-01' + interval '1' year
GROUP BY
  n_name
ORDER BY
  revenue desc;

-- Query 6
SELECT
  sum(l_extendedprice * l_discount) as revenue
FROM
  lineitem
WHERE
  l_shipdate >= date '1994-01-01'
  AND l_shipdate < date '1994-01-01' + interval '1' year
  AND l_discount between 0.06 - 0.01 AND 0.06 + 0.01
  AND l_quantity < 24;

-- Query 10
SELECT
  c_custkey,
  c_name,
  sum(l_extendedprice * (1 - l_discount)) as revenue,
  c_acctbal,
  n_name,
  c_address,
  c_phone,
  c_comment
FROM
  customer,
  nation,
  orders,
  lineitem
WHERE
  c_nationkey = n_nationkey
  AND c_custkey = o_custkey
  AND o_orderkey = l_orderkey
  AND o_orderdate >= date '1993-10-01'
  AND o_orderdate < date '1993-10-01' + interval '3' month
  AND l_returnflag = 'R'
GROUP BY
  c_custkey,
  c_name,
  c_acctbal,
  c_phone,
  n_name,
  c_address,
  c_comment
ORDER BY
  revenue desc
LIMIT 20;

-- Query 12
SELECT
  l_shipmode,
  sum(case
    when o_orderpriority = '1-URGENT'
      OR o_orderpriority = '2-HIGH'
      then 1
    else 0
  end) as high_line_count,
  sum(case
    when o_orderpriority <> '1-URGENT'
      AND o_orderpriority <> '2-HIGH'
      then 1
    else 0
  end) AS low_line_count
FROM
  orders,
  lineitem
WHERE
  o_orderkey = l_orderkey
  AND l_shipmode in ('MAIL', 'SHIP')
  AND l_commitdate < l_receiptdate
  AND l_shipdate < l_commitdate
  AND l_receiptdate >= date '1994-01-01'
  AND l_receiptdate < date '1994-01-01' + interval '1' year
GROUP BY
  l_shipmode
ORDER BY
  l_shipmode;

-- Query 14
SELECT
  100.00 * sum(case
    when p_type like 'PROMO%'
      then l_extendedprice * (1 - l_discount)
    else 0
  end) / sum(l_extendedprice * (1 - l_discount)) as promo_revenue
FROM
  lineitem,
  part
WHERE
  l_partkey = p_partkey
  AND l_shipdate >= date '1995-09-01'
  AND l_shipdate < date '1995-09-01' + interval '1' month;

-- Query 19
SELECT
  sum(l_extendedprice* (1 - l_discount)) as revenue
FROM
  lineitem,
  part
WHERE
  (
    p_partkey = l_partkey
    AND p_brand = 'Brand#12'
    AND p_container in ('SM CASE', 'SM BOX', 'SM PACK', 'SM PKG')
    AND l_quantity >= 1 AND l_quantity <= 1 + 10
    AND p_size between 1 AND 5
    AND l_shipmode in ('AIR', 'AIR REG')
    AND l_shipinstruct = 'DELIVER IN PERSON'
  )
  OR
  (
    p_partkey = l_partkey
    AND p_brand = 'Brand#23'
    AND p_container in ('MED BAG', 'MED BOX', 'MED PKG', 'MED PACK')
    AND l_quantity >= 10 AND l_quantity <= 10 + 10
    AND p_size between 1 AND 10
    AND l_shipmode in ('AIR', 'AIR REG')
    AND l_shipinstruct = 'DELIVER IN PERSON'
  )
  OR
  (
    p_partkey = l_partkey
    AND p_brand = 'Brand#34'
    AND p_container in ('LG CASE', 'LG BOX', 'LG PACK', 'LG PKG')
    AND l_quantity >= 20 AND l_quantity <= 20 + 10
    AND p_size between 1 AND 15
    AND l_shipmode in ('AIR', 'AIR REG')
    AND l_shipinstruct = 'DELIVER IN PERSON'
  );


-- Cleanup
/*
DROP TABLE lineitem; 
DROP TABLE orders; 
DROP TABLE partsupp; 
DROP TABLE part; 
DROP TABLE supplier; 
DROP TABLE customer; 
DROP TABLE nation; 
DROP TABLE region; 
DROP DATABASE bigdatagen;
*/
