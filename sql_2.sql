SELECT
    [mon].[trx_month] AS                                                       [trx_month]
  , [mon].[active_client_cnt] AS                                               [active_client_cnt]
  , [mon].[check_cnt] AS                                                       [check_cnt]
  , CONVERT(NUMERIC(4, 3), [mon].[check_cnt] * 1. / [y].[check_cnt_yearly]) AS [yearly_check_cnt_share]
  , [mon].[payment_sum] AS                                                     [payment_sum]
  , CONVERT(NUMERIC(4, 3), [mon].[payment_sum] / [y].[payment_sum_yearly]) AS  [yearly_payment_sum_share]
  , CONVERT(NUMERIC(19, 2), [mon].[check_avg_sum]) AS                          [check_avg_sum]
  , [mon].[female_payment_sum] AS                                              [female_payment_sum]
  , [mon].[male_payment_sum] AS                                                [male_payment_sum]
  , [mon].[na_payment_sum] AS                                                  [na_payment_sum]
  , CONVERT(NUMERIC(3, 2), [mon].[female_share]) AS                            [female_share]
  , CONVERT(NUMERIC(3, 2), [mon].[male_share]) AS                              [male_share]
  , CONVERT(NUMERIC(3, 2), [mon].[na_share]) AS                                [na_share]
  , CONVERT(NUMERIC(3, 2), [mon].[female_payment_share]) AS                    [female_payment_share]
  , CONVERT(NUMERIC(3, 2), [mon].[male_payment_share]) AS                      [male_payment_share]
  , CONVERT(NUMERIC(3, 2), [mon].[na_payment_share]) AS                        [na_payment_share]
FROM
(
    SELECT
        DATEADD(day, 1, EOMONTH([trx].[date_new], -1)) AS                                                                               [trx_month]
      , COUNT(DISTINCT [trx].[id_client]) AS                                                                                            [active_client_cnt]
      , COUNT(DISTINCT [trx].[id_check]) AS                                                                                             [check_cnt]
      , SUM([trx].[sum_payment]) AS                                                                                                     [payment_sum]
      , SUM([trx].[sum_payment]) / COUNT(DISTINCT [trx].[id_check]) AS                                                                  [check_avg_sum]
      , SUM(IIF(ISNULL([cus].[gender], 'N/A') = 'F', [trx].[sum_payment], NULL)) AS                                                     [female_payment_sum]
      , SUM(IIF(ISNULL([cus].[gender], 'N/A') = 'M', [trx].[sum_payment], NULL)) AS                                                     [male_payment_sum]
      , SUM(IIF(ISNULL([cus].[gender], 'N/A') = 'N/A', [trx].[sum_payment], NULL)) AS                                                   [na_payment_sum]
      , COUNT(DISTINCT IIF(ISNULL([cus].[gender], 'N/A') = 'F', [trx].[id_client], NULL)) * 1. / COUNT(DISTINCT [trx].[id_client]) AS   [female_share]
      , COUNT(DISTINCT IIF(ISNULL([cus].[gender], 'N/A') = 'M', [trx].[id_client], NULL)) * 1. / COUNT(DISTINCT [trx].[id_client]) AS   [male_share]
      , COUNT(DISTINCT IIF(ISNULL([cus].[gender], 'N/A') = 'N/A', [trx].[id_client], NULL)) * 1. / COUNT(DISTINCT [trx].[id_client]) AS [na_share]
      , SUM(IIF(ISNULL([cus].[gender], 'N/A') = 'F', [trx].[sum_payment], NULL)) / SUM([trx].[sum_payment]) AS                          [female_payment_share]
      , SUM(IIF(ISNULL([cus].[gender], 'N/A') = 'M', [trx].[sum_payment], NULL)) / SUM([trx].[sum_payment]) AS                          [male_payment_share]
      , SUM(IIF(ISNULL([cus].[gender], 'N/A') = 'N/A', [trx].[sum_payment], NULL)) / SUM([trx].[sum_payment]) AS                        [na_payment_share]
    FROM  [tmp].[trx] AS [trx]
    JOIN [tmp].[customers] AS [cus]
        ON [cus].[id_client] = [trx].[id_client]
    WHERE 1 = 1
          --AND [trx].[date_new] >= CONVERT(DATE, '2015-07-01')
          AND 1 = 1
    GROUP BY
        DATEADD(day, 1, EOMONTH([trx].[date_new], -1))
) AS [mon]
OUTER APPLY
(
    SELECT
        SUM([ty].[sum_payment]) AS         [payment_sum_yearly]
      , COUNT(DISTINCT [ty].[id_check]) AS [check_cnt_yearly]
    FROM  [tmp].[trx] AS [ty]
    WHERE YEAR([ty].[date_new]) = YEAR([mon].[trx_month])
    GROUP BY
        YEAR([ty].[date_new])
) AS [y];