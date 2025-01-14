
-----------------------------------------------------
------ Check that Filter Push Down is working -------
-----------------------------------------------------

-- Check that the filter is being pushed down. We create an external table
-- that returns the filter being sent from the C-side

DROP EXTERNAL TABLE IF EXISTS test_filter CASCADE;

CREATE EXTERNAL TABLE test_filter (t0 text, a1 integer, b2 boolean, filterValue text)
    LOCATION (E'pxf://dummy_path?FRAGMENTER=org.greenplum.pxf.diagnostic.FilterVerifyFragmenter&ACCESSOR=org.greenplum.pxf.diagnostic.UserDataVerifyAccessor&RESOLVER=org.greenplum.pxf.plugins.hdfs.StringPassResolver')
    FORMAT 'TEXT' ( DELIMITER ',');

SET gp_external_enable_filter_pushdown = true;
SET optimizer = off;

SELECT * FROM test_filter WHERE  t0 = 'A' and a1 = 0 ORDER BY t0, a1;

SELECT * FROM test_filter WHERE  t0 = 'B' AND a1 <= 1 ORDER BY t0, a1;

SELECT * FROM test_filter WHERE  t0 = 'B' AND (a1 = 1 OR a1 = 10) ORDER BY t0, a1;

SELECT * FROM test_filter WHERE  t0 = 'B' OR (a1 >= 0 AND a1 <= 2) ORDER BY t0, a1;

SELECT * FROM test_filter WHERE  b2 = false ORDER BY t0, a1;

SELECT t0, a1, filtervalue FROM test_filter WHERE a1 < 5 AND b2 = false ORDER BY t0, a1;

SELECT * FROM test_filter WHERE  b2 = false AND (a1 = 1 OR a1 = 10) ORDER BY t0, a1;

SELECT * FROM test_filter WHERE  b2 = false OR (a1 >= 0 AND a1 <= 2) ORDER BY t0, a1;

SET optimizer = on;

SELECT * FROM test_filter WHERE  t0 = 'A' and a1 = 0 ORDER BY t0, a1;

SELECT * FROM test_filter WHERE  t0 = 'B' AND a1 <= 1 ORDER BY t0, a1;

SELECT * FROM test_filter WHERE  t0 = 'B' AND (a1 = 1 OR a1 = 10) ORDER BY t0, a1;

SELECT * FROM test_filter WHERE  t0 = 'B' OR (a1 >= 0 AND a1 <= 2) ORDER BY t0, a1;

SELECT * FROM test_filter WHERE  b2 = false ORDER BY t0, a1;

SELECT t0, a1, filtervalue FROM test_filter WHERE a1 < 5 AND b2 = false ORDER BY t0, a1;

SELECT * FROM test_filter WHERE  b2 = false AND (a1 = 1 OR a1 = 10) ORDER BY t0, a1;

SELECT * FROM test_filter WHERE  b2 = false OR (a1 >= 0 AND a1 <= 2) ORDER BY t0, a1;

-----------------------------------------------------
------ Check that Filter Push Down is disabled ------
-----------------------------------------------------

-- Now let's make sure nothing gets pushed down when we disable the
-- gp_external_enable_filter_pushdown guc

SET gp_external_enable_filter_pushdown = off;

SELECT * FROM test_filter WHERE  t0 = 'A' and a1 = 0 ORDER BY t0, a1;

-- Recreate the same table as above, but now we use varchar for the t0 column
-- type. We want to make sure varchar predicates are being pushed down.

DROP EXTERNAL TABLE IF EXISTS test_filter CASCADE;

CREATE EXTERNAL TABLE test_filter (t0 varchar(1), a1 integer, b2 boolean, filterValue text)
    LOCATION (E'pxf://dummy_path?FRAGMENTER=org.greenplum.pxf.diagnostic.FilterVerifyFragmenter&ACCESSOR=org.greenplum.pxf.diagnostic.UserDataVerifyAccessor&RESOLVER=org.greenplum.pxf.plugins.hdfs.StringPassResolver')
    FORMAT 'TEXT' ( DELIMITER ',');

SET gp_external_enable_filter_pushdown = true;
SET optimizer = off;

SELECT * FROM test_filter WHERE  t0 = 'A' and a1 = 0 ORDER BY t0, a1;

SELECT * FROM test_filter WHERE  t0 = 'B' AND a1 <= 1 ORDER BY t0, a1;

SELECT * FROM test_filter WHERE  t0 = 'B' AND (a1 = 1 OR a1 = 10) ORDER BY t0, a1;

SELECT * FROM test_filter WHERE  t0 = 'B' OR (a1 >= 0 AND a1 <= 2) ORDER BY t0, a1;

SELECT * FROM test_filter WHERE  b2 = false ORDER BY t0, a1;

SELECT t0, a1, filtervalue FROM test_filter WHERE a1 < 5 AND b2 = false ORDER BY t0, a1;

SELECT * FROM test_filter WHERE  b2 = false AND (a1 = 1 OR a1 = 10) ORDER BY t0, a1;

SELECT * FROM test_filter WHERE  b2 = false OR (a1 >= 0 AND a1 <= 2) ORDER BY t0, a1;

SET optimizer = on;

SELECT * FROM test_filter WHERE  t0 = 'A' and a1 = 0 ORDER BY t0, a1;

SELECT * FROM test_filter WHERE  t0 = 'B' AND a1 <= 1 ORDER BY t0, a1;

SELECT * FROM test_filter WHERE  t0 = 'B' AND (a1 = 1 OR a1 = 10) ORDER BY t0, a1;

SELECT * FROM test_filter WHERE  t0 = 'B' OR (a1 >= 0 AND a1 <= 2) ORDER BY t0, a1;

SELECT * FROM test_filter WHERE  b2 = false ORDER BY t0, a1;

SELECT t0, a1, filtervalue FROM test_filter WHERE a1 < 5 AND b2 = false ORDER BY t0, a1;

SELECT * FROM test_filter WHERE  b2 = false AND (a1 = 1 OR a1 = 10) ORDER BY t0, a1;

SELECT * FROM test_filter WHERE  b2 = false OR (a1 >= 0 AND a1 <= 2) ORDER BY t0, a1;

-- Now let's make sure nothing gets pushed down when we disable the
-- gp_external_enable_filter_pushdown guc

SET gp_external_enable_filter_pushdown = off;

SELECT * FROM test_filter WHERE  t0 = 'A' and a1 = 0 ORDER BY t0, a1;

-----------------------------------------------------------------------
------ Check that Filter Push Down is working with HEX delimiter ------
-----------------------------------------------------------------------

DROP EXTERNAL TABLE IF EXISTS test_filter CASCADE;

CREATE EXTERNAL TABLE test_filter (t0 text, a1 integer, b2 boolean, filterValue text)
    LOCATION (E'pxf://dummy_path?FRAGMENTER=org.greenplum.pxf.diagnostic.FilterVerifyFragmenter&ACCESSOR=org.greenplum.pxf.diagnostic.UserDataVerifyAccessor&RESOLVER=org.greenplum.pxf.plugins.hdfs.StringPassResolver')
    FORMAT 'TEXT' ( DELIMITER E'\x01');

SET gp_external_enable_filter_pushdown = true;
SET optimizer = off;

SELECT * FROM test_filter WHERE t0 = 'J' and a1 = 9 ORDER BY t0, a1;

SET optimizer = on;

SELECT * FROM test_filter WHERE t0 = 'J' and a1 = 9 ORDER BY t0, a1;

-- Recreate the same table as above and make sure that varchar is also being
-- pushed down.

DROP EXTERNAL TABLE IF EXISTS test_filter CASCADE;

CREATE EXTERNAL TABLE test_filter (t0 varchar(1), a1 integer, b2 boolean, filterValue text)
    LOCATION (E'pxf://dummy_path?FRAGMENTER=org.greenplum.pxf.diagnostic.FilterVerifyFragmenter&ACCESSOR=org.greenplum.pxf.diagnostic.UserDataVerifyAccessor&RESOLVER=org.greenplum.pxf.plugins.hdfs.StringPassResolver')
    FORMAT 'TEXT' ( DELIMITER E'\x01');

SET gp_external_enable_filter_pushdown = true;
SET optimizer = off;

SELECT * FROM test_filter WHERE t0 = 'J' and a1 = 9 ORDER BY t0, a1;

SET optimizer = on;

SELECT * FROM test_filter WHERE t0 = 'J' and a1 = 9 ORDER BY t0, a1;

-- start_ignore
{{ CLEAN_UP }}-- clean up used tables
{{ CLEAN_UP }}DROP EXTERNAL TABLE IF EXISTS test_filter CASCADE;
-- end_ignore
