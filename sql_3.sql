IF OBJECT_ID('tempdb..#res') IS NULL
    BEGIN

        SELECT
            [ag].[age_group] AS                                                                                                                           [age_group]
          , COUNT(DISTINCT [cus].[id_client]) AS                                                                                                          [customer_cnt]
          , COUNT(DISTINCT [trx].[id_check]) AS                                                                                                           [check_cnt]
          , COUNT([trx].[id_check]) AS                                                                                                                    [check_items_cnt]
          , CONVERT(NUMERIC(19, 2), SUM([trx].[sum_payment]) / COUNT(DISTINCT [trx].[id_check])) AS                                                       [check_avg_sum]
          , SUM([trx].[sum_payment]) AS                                                                                                                   [payment_sum]
          , COUNT(DISTINCT IIF([q].[trx_quarter] = '2015_03', [trx].[id_check], NULL)) AS                                                                 [2015_03_check_cnt]
          , SUM(IIF([q].[trx_quarter] = '2015_03', [trx].[sum_payment], NULL)) AS                                                                         [2015_03_payment_sum]
          , CONVERT(NUMERIC(19, 2), SUM(IIF([q].[trx_quarter] = '2015_03', [trx].[sum_payment], NULL)) / COUNT(DISTINCT IIF([q].[trx_quarter] = '2015_03', [trx].[id_check], NULL))) AS
                                                                                                                                                          [2015_03_check_avg_sum]
          , CONVERT(NUMERIC(5, 4), COUNT(DISTINCT IIF([q].[trx_quarter] = '2015_03', [trx].[id_check], NULL)) * 1. / COUNT(DISTINCT [trx].[id_check])) AS [2015_03_check_sum_share]
          , COUNT(DISTINCT IIF([q].[trx_quarter] = '2015_04', [trx].[id_check], NULL)) AS                                                                 [2015_04_check_cnt]
          , SUM(IIF([q].[trx_quarter] = '2015_04', [trx].[sum_payment], NULL)) AS                                                                         [2015_04_payment_sum]
          , CONVERT(NUMERIC(19, 2), SUM(IIF([q].[trx_quarter] = '2015_04', [trx].[sum_payment], NULL)) / COUNT(DISTINCT IIF([q].[trx_quarter] = '2015_04', [trx].[id_check], NULL))) AS
                                                                                                                                                          [2015_04_check_avg_sum]
          , CONVERT(NUMERIC(5, 4), COUNT(DISTINCT IIF([q].[trx_quarter] = '2015_04', [trx].[id_check], NULL)) * 1. / COUNT(DISTINCT [trx].[id_check])) AS [2015_04_check_sum_share]
          , COUNT(DISTINCT IIF([q].[trx_quarter] = '2016_01', [trx].[id_check], NULL)) AS                                                                 [2016_01_check_cnt]
          , SUM(IIF([q].[trx_quarter] = '2016_01', [trx].[sum_payment], NULL)) AS                                                                         [2016_01_payment_sum]
          , CONVERT(NUMERIC(19, 2), SUM(IIF([q].[trx_quarter] = '2016_01', [trx].[sum_payment], NULL)) / COUNT(DISTINCT IIF([q].[trx_quarter] = '2016_01', [trx].[id_check], NULL))) AS
                                                                                                                                                          [2016_01_check_avg_sum]
          , CONVERT(NUMERIC(5, 4), COUNT(DISTINCT IIF([q].[trx_quarter] = '2016_01', [trx].[id_check], NULL)) * 1. / COUNT(DISTINCT [trx].[id_check])) AS [2016_01_check_sum_share]
          , COUNT(DISTINCT IIF([q].[trx_quarter] = '2016_02', [trx].[id_check], NULL)) AS                                                                 [2016_02_check_cnt]
          , SUM(IIF([q].[trx_quarter] = '2016_02', [trx].[sum_payment], NULL)) AS                                                                         [2016_02_payment_sum]
          , CONVERT(NUMERIC(19, 2), SUM(IIF([q].[trx_quarter] = '2016_02', [trx].[sum_payment], NULL)) / COUNT(DISTINCT IIF([q].[trx_quarter] = '2016_02', [trx].[id_check], NULL))) AS
                                                                                                                                                          [2016_02_check_avg_sum]
          , CONVERT(NUMERIC(5, 4), COUNT(DISTINCT IIF([q].[trx_quarter] = '2016_02', [trx].[id_check], NULL)) * 1. / COUNT(DISTINCT [trx].[id_check])) AS [2016_02_check_sum_share]
        INTO
            [#res]
        FROM  [tmp].[trx] AS [trx]
        JOIN [tmp].[customers] AS [cus]
            ON [cus].[id_client] = [trx].[id_client]
        OUTER APPLY
        (
            SELECT
                CASE
                    WHEN [cus].[age] <= 25
                    THEN '00-25'
                    WHEN [cus].[age] BETWEEN 26 AND 35
                    THEN '26-35'
                    WHEN [cus].[age] BETWEEN 36 AND 45
                    THEN '36-45'
                    WHEN [cus].[age] BETWEEN 46 AND 55
                    THEN '46-55'
                    WHEN [cus].[age] BETWEEN 56 AND 65
                    THEN '56-65'
                    WHEN [cus].[age] BETWEEN 66 AND 99
                    THEN '66-99'
                    ELSE 'n/a'
                END AS [age_group]
        ) AS [ag]
        OUTER APPLY
        (
            SELECT
                concat(YEAR([trx].[date_new]), '_', RIGHT('00' + CONVERT(NVARCHAR(2), DATEPART(quarter, [trx].[date_new])), 2)) AS [trx_quarter]
        ) AS [q]
        WHERE [trx].[date_new] >= CONVERT(DATE, '2015-07-01')
        GROUP BY
            [ag].[age_group];
END;

SELECT
    [age_group]
  , [customer_cnt]
  , [check_cnt]
  , [check_items_cnt]
  , [check_avg_sum]
  , [payment_sum]
  , [2015_03_check_cnt]
  , [2015_03_payment_sum]
  , [2015_03_check_avg_sum]
  , [2015_03_check_sum_share]
  , [2015_04_check_cnt]
  , [2015_04_payment_sum]
  , [2015_04_check_avg_sum]
  , [2015_04_check_sum_share]
  , [2016_01_check_cnt]
  , [2016_01_payment_sum]
  , [2016_01_check_avg_sum]
  , [2016_01_check_sum_share]
  , [2016_02_check_cnt]
  , [2016_02_payment_sum]
  , [2016_02_check_avg_sum]
  , [2016_02_check_sum_share]
FROM [#res];

/**************************************************************************************
/**************************************************************************************
******************************Альтернативное представление*****************************
**************************************************************************************/

SELECT
    [indicator]
  , [00-25]
  , [26-35]
  , [36-45]
  , [46-55]
  , [56-65]
  , [66-99]
  , [N/A]
FROM
(
    SELECT
        [age_group]
      , [indicator]
      , [value]
    FROM
    (
        SELECT
            [age_group]
          , CONVERT(FLOAT, [customer_cnt]) AS            [01.customer_cnt]
          , CONVERT(FLOAT, [check_cnt]) AS               [02.check_cnt]
          , CONVERT(FLOAT, [check_items_cnt]) AS         [03.check_items_cnt]
          , CONVERT(FLOAT, [check_avg_sum]) AS           [04.check_avg_sum]
          , CONVERT(FLOAT, [payment_sum]) AS             [05.payment_sum]
          , CONVERT(FLOAT, [2015_03_check_cnt]) AS       [06.2015_03_check_cnt]
          , CONVERT(FLOAT, [2015_03_payment_sum]) AS     [07.2015_03_payment_sum]
          , CONVERT(FLOAT, [2015_03_check_avg_sum]) AS   [08.2015_03_check_avg_sum]
          , CONVERT(FLOAT, [2015_03_check_sum_share]) AS [09.2015_03_check_sum_share]
          , CONVERT(FLOAT, [2015_04_check_cnt]) AS       [10.2015_04_check_cnt]
          , CONVERT(FLOAT, [2015_04_payment_sum]) AS     [11.2015_04_payment_sum]
          , CONVERT(FLOAT, [2015_04_check_avg_sum]) AS   [12.2015_04_check_avg_sum]
          , CONVERT(FLOAT, [2015_04_check_sum_share]) AS [13.2015_04_check_sum_share]
          , CONVERT(FLOAT, [2016_01_check_cnt]) AS       [14.2016_01_check_cnt]
          , CONVERT(FLOAT, [2016_01_payment_sum]) AS     [15.2016_01_payment_sum]
          , CONVERT(FLOAT, [2016_01_check_avg_sum]) AS   [16.2016_01_check_avg_sum]
          , CONVERT(FLOAT, [2016_01_check_sum_share]) AS [17.2016_01_check_sum_share]
          , CONVERT(FLOAT, [2016_02_check_cnt]) AS       [18.2016_02_check_cnt]
          , CONVERT(FLOAT, [2016_02_payment_sum]) AS     [19.2016_02_payment_sum]
          , CONVERT(FLOAT, [2016_02_check_avg_sum]) AS   [20.2016_02_check_avg_sum]
          , CONVERT(FLOAT, [2016_02_check_sum_share]) AS [21.2016_02_check_sum_share]
        FROM [#res]
    ) AS [res] UNPIVOT([value] FOR [indicator] IN(
        [01.customer_cnt]
      , [02.check_cnt]
      , [03.check_items_cnt]
      , [04.check_avg_sum]
      , [05.payment_sum]
      , [06.2015_03_check_cnt]
      , [07.2015_03_payment_sum]
      , [08.2015_03_check_avg_sum]
      , [09.2015_03_check_sum_share]
      , [10.2015_04_check_cnt]
      , [11.2015_04_payment_sum]
      , [12.2015_04_check_avg_sum]
      , [13.2015_04_check_sum_share]
      , [14.2016_01_check_cnt]
      , [15.2016_01_payment_sum]
      , [16.2016_01_check_avg_sum]
      , [17.2016_01_check_sum_share]
      , [18.2016_02_check_cnt]
      , [19.2016_02_payment_sum]
      , [20.2016_02_check_avg_sum]
      , [21.2016_02_check_sum_share])) AS [upvt]
) AS [res] PIVOT(SUM(value) FOR [age_group] IN(
    [00-25]
  , [26-35]
  , [36-45]
  , [46-55]
  , [56-65]
  , [66-99]
  , [N/A])) AS [pvt];
**************************************************************************************/