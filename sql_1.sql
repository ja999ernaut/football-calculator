WITH active_cus
     AS (SELECT
             [t].[id_client] AS                              [id_client]
           , DATEADD(DAY, 1, EOMONTH([t].[date_new], -1)) AS [trx_month]
           , SUM([sum_payment]) AS                           [payment_sum]
           , COUNT(DISTINCT [id_check]) AS                   [check_cnt]
         FROM  [tmp].[trx] AS [t]
         WHERE [t].[date_new] >= CONVERT(DATE, '2015-07-01')
         GROUP BY
             [t].[id_client]
           , DATEADD(DAY, 1, EOMONTH([t].[date_new], -1)))
     SELECT
         [cus].[id_client] AS                               [id_client]
       , ISNULL([cus].[gender], 'N/A') AS                   [gender]
       , [cus].[age] AS                                     [age]
       , [cus].[count_city] AS                              [count_city]
       , [cus].[response_communcation] AS                   [response_communcation]
       , [cus].[communication_3month] AS                    [communication_3month]
       , [cus].[tenure] AS                                  [tenure]
       , [cus].[total_amount] AS                            [total_amount]
       , CONVERT(NUMERIC(19, 2), [ct].[payment_sum]) AS     [payment_sum]
       , [ct].[check_cnt] AS                                [check_cnt]
       , CONVERT(NUMERIC(19, 2), [ct].[payment_avg_sum]) AS [payment_avg_sum]
       , CONVERT(NUMERIC(19, 2), [ct].[check_avg_sum]) AS   [check_avg_sum]
     FROM      [tmp].[customers] AS [cus]
     OUTER APPLY
     (
         SELECT
             SUM([ac].[payment_sum]) AS                         [payment_sum]
           , SUM([ac].[check_cnt]) AS                           [check_cnt]
           , AVG([ac].[payment_sum]) AS                         [payment_avg_sum]
           , SUM([ac].[payment_sum]) / SUM([ac].[check_cnt]) AS [check_avg_sum]
         FROM  [active_cus] AS [ac]
         WHERE [ac].[id_client] = [cus].[id_client]
         GROUP BY
             [ac].[id_client]
     ) AS [ct]
     WHERE EXISTS
     (
         SELECT
             1
         FROM  [active_cus] AS [acc]
         WHERE [acc].[id_client] = [cus].[id_client]
         GROUP BY
             [acc].[id_client]
         HAVING COUNT([acc].[trx_month]) = 12
     );