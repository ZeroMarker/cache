Class User.DHCMRInfo Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DHCMRInfo_RowID, SqlTableName = DHCMRInfo, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// MR_YLFFFS
Property MRYLFFFS As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = MR_YLFFFS ];

/// MR_JKKH
Property MRJKKH As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = MR_JKKH ];

/// MR_ZYCS
Property MRZYCS As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = MR_ZYCS ];

/// MR_BAH
Property MRBAH As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = MR_BAH ];

/// MR_ZYH
Property MRZYH As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = MR_ZYH ];

/// MR_ADM
Property MRADM As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = MR_ADM ];

/// MR_PAPMIDR
Property MRPAPMIDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = MR_PAPMIDR ];

/// MR_XM
Property MRXM As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = MR_XM ];

/// MR_XB
Property MRXB As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = MR_XB ];

/// MR_CSRQ
Property MRCSRQ As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = MR_CSRQ ];

/// MR_NN
Property MRNN As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = MR_NN ];

/// MR_GJ
Property MRGJ As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = MR_GJ ];

/// MR_BZZSNN
Property MRBZZSNN As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = MR_BZZSNN ];

/// MR_XSECSTZ
Property MRXSECSTZ As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = MR_XSECSTZ ];

/// MR_XSERYTZ
Property MRXSERYTZ As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = MR_XSERYTZ ];

/// MR_CSD
Property MRCSD As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = MR_CSD ];

/// MR_JG
Property MRJG As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = MR_JG ];

/// MR_MZ
Property MRMZ As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = MR_MZ ];

/// MR_SFZH
Property MRSFZH As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = MR_SFZH ];

/// MR_ZY
Property MRZY As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = MR_ZY ];

/// MR_HY
Property MRHY As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = MR_HY ];

/// MR_XZZ
Property MRXZZ As %Library.String(COLLATION = "Exact", MAXLEN = 4096, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = MR_XZZ ];

/// MR_XZZDH
Property MRXZZDH As %Library.String(COLLATION = "Exact", MAXLEN = 4096, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = MR_XZZDH ];

/// MR_XZZYB
Property MRXZZYB As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = MR_XZZYB ];

/// MR_HKDZ
Property MRHKDZ As %Library.String(COLLATION = "Exact", MAXLEN = 4096, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = MR_HKDZ ];

/// MR_HKYB
Property MRHKYB As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = MR_HKYB ];

/// MR_GZDWDZ
Property MRGZDWDZ As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = MR_GZDWDZ ];

/// MR_GZDWDH
Property MRGZDWDH As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = MR_GZDWDH ];

/// MR_GZDWYB
Property MRGZDWYB As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = MR_GZDWYB ];

/// MR_LXRXM
Property MRLXRXM As %Library.String(COLLATION = "Exact", MAXLEN = 1024, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = MR_LXRXM ];

/// MR_LXRGX
Property MRLXRGX As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = MR_LXRGX ];

/// MR_LXRDZ
Property MRLXRDZ As %Library.String(COLLATION = "Exact", MAXLEN = 1024, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = MR_LXRDZ ];

/// MR_LXRDH
Property MRLXRDH As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = MR_LXRDH ];

/// MR_RYTJ
Property MRRYTJ As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = MR_RYTJ ];

/// MR_RYRQ
Property MRRYRQ As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 36, SqlFieldName = MR_RYRQ ];

/// MR_RYKB
Property MRRYKB As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 37, SqlFieldName = MR_RYKB ];

/// MR_RYBF
Property MRRYBF As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 38, SqlFieldName = MR_RYBF ];

/// MR_ZKKB
Property MRZKKB As %Library.String(COLLATION = "Exact", MAXLEN = 4096, TRUNCATE = 0) [ SqlColumnNumber = 39, SqlFieldName = MR_ZKKB ];

/// MR_CYRQ
Property MRCYRQ As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 40, SqlFieldName = MR_CYRQ ];

/// MR_CYKB
Property MRCYKB As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 41, SqlFieldName = MR_CYKB ];

/// MR_CYBF
Property MRCYBF As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 42, SqlFieldName = MR_CYBF ];

/// MR_SJZYTS
Property MRSJZYTS As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 43, SqlFieldName = MR_SJZYTS ];

/// MR_MJZZDMC
Property MRMJZZDMC As %Library.String(COLLATION = "Exact", MAXLEN = 1024, TRUNCATE = 0) [ SqlColumnNumber = 44, SqlFieldName = MR_MJZZDMC ];

/// MR_MJZZDJBBM
Property MRMJZZDJBBM As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 45, SqlFieldName = MR_MJZZDJBBM ];

/// MR_RYBQ
Property MRRYBQ As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 46, SqlFieldName = MR_RYBQ ];

/// MR_LYFS
Property MRLYFS As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 47, SqlFieldName = MR_LYFS ];

/// MR_LYFSYLJSJGMC
Property MRLYFSYLJSJGMC As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 48, SqlFieldName = MR_LYFSYLJSJGMC ];

/// MR_RYZD
Property MRRYZD As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 49, SqlFieldName = MR_RYZD ];

/// MR_RYZDMC
Property MRRYZDMC As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 50, SqlFieldName = MR_RYZDMC ];

/// MR_RYZDRYBQ
Property MRRYZDRYBQ As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 51, SqlFieldName = MR_RYZDRYBQ ];

/// MR_RYHQZRQ
Property MRRYHQZRQ As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 52, SqlFieldName = MR_RYHQZRQ ];

/// MR_CYZYZD
Property MRCYZYZD As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 53, SqlFieldName = MR_CYZYZD ];

/// MR_CYZYZDMC
Property MRCYZYZDMC As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 54, SqlFieldName = MR_CYZYZDMC ];

/// MR_CYZYZDRYBQ
Property MRCYZYZDRYBQ As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 55, SqlFieldName = MR_CYZYZDRYBQ ];

/// MR_CYZYZDZLJG
Property MRCYZYZDZLJG As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 56, SqlFieldName = MR_CYZYZDZLJG ];

/// MR_CYQTZD1
Property MRCYQTZD1 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 57, SqlFieldName = MR_CYQTZD1 ];

/// MR_CYQTZDMC1
Property MRCYQTZDMC1 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 58, SqlFieldName = MR_CYQTZDMC1 ];

/// MR_CYQTZDRYBQ1
Property MRCYQTZDRYBQ1 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 59, SqlFieldName = MR_CYQTZDRYBQ1 ];

/// MR_CYQTZDZLJG1
Property MRCYQTZDZLJG1 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 60, SqlFieldName = MR_CYQTZDZLJG1 ];

/// MR_CYQTZD2
Property MRCYQTZD2 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 61, SqlFieldName = MR_CYQTZD2 ];

/// MR_CYQTZDMC2
Property MRCYQTZDMC2 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 62, SqlFieldName = MR_CYQTZDMC2 ];

/// MR_CYQTZDRYBQ2
Property MRCYQTZDRYBQ2 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 63, SqlFieldName = MR_CYQTZDRYBQ2 ];

/// MR_CYQTZDZLJG2
Property MRCYQTZDZLJG2 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 64, SqlFieldName = MR_CYQTZDZLJG2 ];

/// MR_CYQTZD3
Property MRCYQTZD3 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 65, SqlFieldName = MR_CYQTZD3 ];

/// MR_CYQTZDMC3
Property MRCYQTZDMC3 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 66, SqlFieldName = MR_CYQTZDMC3 ];

/// MR_CYQTZDRYBQ3
Property MRCYQTZDRYBQ3 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 67, SqlFieldName = MR_CYQTZDRYBQ3 ];

/// MR_CYQTZDZLJG3
Property MRCYQTZDZLJG3 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 68, SqlFieldName = MR_CYQTZDZLJG3 ];

/// MR_CYQTZD4
Property MRCYQTZD4 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 69, SqlFieldName = MR_CYQTZD4 ];

/// MR_CYQTZDMC4
Property MRCYQTZDMC4 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 70, SqlFieldName = MR_CYQTZDMC4 ];

/// MR_CYQTZDRYBQ4
Property MRCYQTZDRYBQ4 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 71, SqlFieldName = MR_CYQTZDRYBQ4 ];

/// MR_CYQTZDZLJG4
Property MRCYQTZDZLJG4 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 72, SqlFieldName = MR_CYQTZDZLJG4 ];

/// MR_CYQTZD5
Property MRCYQTZD5 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 73, SqlFieldName = MR_CYQTZD5 ];

/// MR_CYQTZDMC5
Property MRCYQTZDMC5 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 74, SqlFieldName = MR_CYQTZDMC5 ];

/// MR_CYQTZDRYBQ5
Property MRCYQTZDRYBQ5 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 75, SqlFieldName = MR_CYQTZDRYBQ5 ];

/// MR_CYQTZDZLJG5
Property MRCYQTZDZLJG5 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 76, SqlFieldName = MR_CYQTZDZLJG5 ];

/// MR_CYQTZD6
Property MRCYQTZD6 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 77, SqlFieldName = MR_CYQTZD6 ];

/// MR_CYQTZDMC6
Property MRCYQTZDMC6 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 78, SqlFieldName = MR_CYQTZDMC6 ];

/// MR_CYQTZDRYBQ6
Property MRCYQTZDRYBQ6 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 79, SqlFieldName = MR_CYQTZDRYBQ6 ];

/// MR_CYQTZDZLJG6
Property MRCYQTZDZLJG6 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 80, SqlFieldName = MR_CYQTZDZLJG6 ];

/// MR_CYQTZD7
Property MRCYQTZD7 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 81, SqlFieldName = MR_CYQTZD7 ];

/// MR_CYQTZDMC7
Property MRCYQTZDMC7 As %Library.String(COLLATION = "Exact", MAXLEN = 512, SELECTIVITY = "33.3333%", TRUNCATE = 0) [ SqlColumnNumber = 82, SqlFieldName = MR_CYQTZDMC7 ];

/// MR_CYQTZDRYBQ7
Property MRCYQTZDRYBQ7 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 83, SqlFieldName = MR_CYQTZDRYBQ7 ];

/// MR_CYQTZDZLJG7
Property MRCYQTZDZLJG7 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 84, SqlFieldName = MR_CYQTZDZLJG7 ];

/// MR_CYQTZD8
Property MRCYQTZD8 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 85, SqlFieldName = MR_CYQTZD8 ];

/// MR_CYQTZDMC8
Property MRCYQTZDMC8 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 86, SqlFieldName = MR_CYQTZDMC8 ];

/// MR_CYQTZDRYBQ8
Property MRCYQTZDRYBQ8 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 87, SqlFieldName = MR_CYQTZDRYBQ8 ];

/// MR_CYQTZDZLJG8
Property MRCYQTZDZLJG8 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 88, SqlFieldName = MR_CYQTZDZLJG8 ];

/// MR_CYQTZD9
Property MRCYQTZD9 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 89, SqlFieldName = MR_CYQTZD9 ];

/// MR_CYQTZDMC9
Property MRCYQTZDMC9 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 90, SqlFieldName = MR_CYQTZDMC9 ];

/// MR_CYQTZDRYBQ9
Property MRCYQTZDRYBQ9 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 91, SqlFieldName = MR_CYQTZDRYBQ9 ];

/// MR_CYQTZDZLJG9
Property MRCYQTZDZLJG9 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 92, SqlFieldName = MR_CYQTZDZLJG9 ];

/// MR_CYQTZD10
Property MRCYQTZD10 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 93, SqlFieldName = MR_CYQTZD10 ];

/// MR_CYQTZDMC10
Property MRCYQTZDMC10 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 94, SqlFieldName = MR_CYQTZDMC10 ];

/// MR_CYQTZDRYBQ10
Property MRCYQTZDRYBQ10 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 95, SqlFieldName = MR_CYQTZDRYBQ10 ];

/// MR_CYQTZDZLJG10
Property MRCYQTZDZLJG10 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 96, SqlFieldName = MR_CYQTZDZLJG10 ];

/// MR_CYQTZD11
Property MRCYQTZD11 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 97, SqlFieldName = MR_CYQTZD11 ];

/// MR_CYQTZDMC11
Property MRCYQTZDMC11 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 98, SqlFieldName = MR_CYQTZDMC11 ];

/// MR_CYQTZDRYBQ11
Property MRCYQTZDRYBQ11 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 99, SqlFieldName = MR_CYQTZDRYBQ11 ];

/// MR_CYQTZDZLJG11
Property MRCYQTZDZLJG11 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 100, SqlFieldName = MR_CYQTZDZLJG11 ];

/// MR_CYQTZD12
Property MRCYQTZD12 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 101, SqlFieldName = MR_CYQTZD12 ];

/// MR_CYQTZDMC12
Property MRCYQTZDMC12 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 102, SqlFieldName = MR_CYQTZDMC12 ];

/// MR_CYQTZDRYBQ12
Property MRCYQTZDRYBQ12 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 103, SqlFieldName = MR_CYQTZDRYBQ12 ];

/// MR_CYQTZDZLJG12
Property MRCYQTZDZLJG12 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 104, SqlFieldName = MR_CYQTZDZLJG12 ];

/// MR_CYQTZD13
Property MRCYQTZD13 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 105, SqlFieldName = MR_CYQTZD13 ];

/// MR_CYQTZDMC13
Property MRCYQTZDMC13 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 106, SqlFieldName = MR_CYQTZDMC13 ];

/// MR_CYQTZDRYBQ13
Property MRCYQTZDRYBQ13 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 107, SqlFieldName = MR_CYQTZDRYBQ13 ];

/// MR_CYQTZDZLJG13
Property MRCYQTZDZLJG13 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 108, SqlFieldName = MR_CYQTZDZLJG13 ];

/// MR_CYQTZD14
Property MRCYQTZD14 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 109, SqlFieldName = MR_CYQTZD14 ];

/// MR_CYQTZDMC14
Property MRCYQTZDMC14 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 110, SqlFieldName = MR_CYQTZDMC14 ];

/// MR_CYQTZDRYBQ14
Property MRCYQTZDRYBQ14 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 111, SqlFieldName = MR_CYQTZDRYBQ14 ];

/// MR_CYQTZDZLJG14
Property MRCYQTZDZLJG14 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 112, SqlFieldName = MR_CYQTZDZLJG14 ];

/// MR_CYQTZD15
Property MRCYQTZD15 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 113, SqlFieldName = MR_CYQTZD15 ];

/// MR_CYQTZDMC15
Property MRCYQTZDMC15 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 114, SqlFieldName = MR_CYQTZDMC15 ];

/// MR_CYQTZDRYBQ15
Property MRCYQTZDRYBQ15 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 115, SqlFieldName = MR_CYQTZDRYBQ15 ];

/// MR_CYQTZDZLJG15
Property MRCYQTZDZLJG15 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 116, SqlFieldName = MR_CYQTZDZLJG15 ];

/// MR_YYGRMCBM
Property MRYYGRMCBM As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 117, SqlFieldName = MR_YYGRMCBM ];

/// MR_YYGRZDMC
Property MRYYGRZDMC As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 118, SqlFieldName = MR_YYGRZDMC ];

/// MR_YYGRZDQK
Property MRYYGRZDQK As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 119, SqlFieldName = MR_YYGRZDQK ];

/// MR_SSBM1
Property MRSSBM1 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 120, SqlFieldName = MR_SSBM1 ];

/// MR_SSJB1
Property MRSSJB1 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 121, SqlFieldName = MR_SSJB1 ];

/// MR_SSRQ1
Property MRSSRQ1 As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 122, SqlFieldName = MR_SSRQ1 ];

/// MR_SSMC1
Property MRSSMC1 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 123, SqlFieldName = MR_SSMC1 ];

/// MR_SSCZYS1
Property MRSSCZYS1 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 124, SqlFieldName = MR_SSCZYS1 ];

/// MR_SSIZ1
Property MRSSIZ1 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 125, SqlFieldName = MR_SSIZ1 ];

/// MR_SSIIZ1
Property MRSSIIZ1 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 126, SqlFieldName = MR_SSIIZ1 ];

/// MR_SSMZFS1
Property MRSSMZFS1 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 127, SqlFieldName = MR_SSMZFS1 ];

/// MR_SSQKYHDJ1
Property MRSSQKYHDJ1 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 128, SqlFieldName = MR_SSQKYHDJ1 ];

/// MR_SSMZYS1
Property MRSSMZYS1 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 129, SqlFieldName = MR_SSMZYS1 ];

/// MR_SSSFZQ1
Property MRSSSFZQ1 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 130, SqlFieldName = MR_SSSFZQ1 ];

/// MR_SSBM2
Property MRSSBM2 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 131, SqlFieldName = MR_SSBM2 ];

/// MR_SSJB2
Property MRSSJB2 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 132, SqlFieldName = MR_SSJB2 ];

/// MR_SSRQ2
Property MRSSRQ2 As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 133, SqlFieldName = MR_SSRQ2 ];

/// MR_SSMC2
Property MRSSMC2 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 134, SqlFieldName = MR_SSMC2 ];

/// MR_SSCZYS2
Property MRSSCZYS2 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 135, SqlFieldName = MR_SSCZYS2 ];

/// MR_SSIZ2
Property MRSSIZ2 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 136, SqlFieldName = MR_SSIZ2 ];

/// MR_SSIIZ2
Property MRSSIIZ2 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 137, SqlFieldName = MR_SSIIZ2 ];

/// MR_SSMZFS2
Property MRSSMZFS2 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 138, SqlFieldName = MR_SSMZFS2 ];

/// MR_SSQKYHDJ2
Property MRSSQKYHDJ2 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 139, SqlFieldName = MR_SSQKYHDJ2 ];

/// MR_SSMZYS2
Property MRSSMZYS2 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 140, SqlFieldName = MR_SSMZYS2 ];

/// MR_SSSFZQ2
Property MRSSSFZQ2 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 141, SqlFieldName = MR_SSSFZQ2 ];

/// MR_SSBM3
Property MRSSBM3 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 142, SqlFieldName = MR_SSBM3 ];

/// MR_SSJB3
Property MRSSJB3 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 143, SqlFieldName = MR_SSJB3 ];

/// MR_SSRQ3
Property MRSSRQ3 As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 144, SqlFieldName = MR_SSRQ3 ];

/// MR_SSMC3
Property MRSSMC3 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 145, SqlFieldName = MR_SSMC3 ];

/// MR_SSCZYS3
Property MRSSCZYS3 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 146, SqlFieldName = MR_SSCZYS3 ];

/// MR_SSIZ3
Property MRSSIZ3 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 147, SqlFieldName = MR_SSIZ3 ];

/// MR_SSIIZ3
Property MRSSIIZ3 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 148, SqlFieldName = MR_SSIIZ3 ];

/// MR_SSMZFS3
Property MRSSMZFS3 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 149, SqlFieldName = MR_SSMZFS3 ];

/// MR_SSQKYHDJ3
Property MRSSQKYHDJ3 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 150, SqlFieldName = MR_SSQKYHDJ3 ];

/// MR_SSMZYS3
Property MRSSMZYS3 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 151, SqlFieldName = MR_SSMZYS3 ];

/// MR_SSSFZQ3
Property MRSSSFZQ3 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 152, SqlFieldName = MR_SSSFZQ3 ];

/// MR_SSBM4
Property MRSSBM4 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 153, SqlFieldName = MR_SSBM4 ];

/// MR_SSJB4
Property MRSSJB4 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 154, SqlFieldName = MR_SSJB4 ];

/// MR_SSRQ4
Property MRSSRQ4 As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 155, SqlFieldName = MR_SSRQ4 ];

/// MR_SSMC4
Property MRSSMC4 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 156, SqlFieldName = MR_SSMC4 ];

/// MR_SSCZYS4
Property MRSSCZYS4 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 157, SqlFieldName = MR_SSCZYS4 ];

/// MR_SSIZ4
Property MRSSIZ4 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 158, SqlFieldName = MR_SSIZ4 ];

/// MR_SSIIZ4
Property MRSSIIZ4 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 159, SqlFieldName = MR_SSIIZ4 ];

/// MR_SSMZFS4
Property MRSSMZFS4 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 160, SqlFieldName = MR_SSMZFS4 ];

/// MR_SSQKYHDJ4
Property MRSSQKYHDJ4 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 161, SqlFieldName = MR_SSQKYHDJ4 ];

/// MR_SSSFZQ4
Property MRSSSFZQ4 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 162, SqlFieldName = MR_SSSFZQ4 ];

/// MR_SSMZYS4
Property MRSSMZYS4 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 163, SqlFieldName = MR_SSMZYS4 ];

/// MR_SSBM5
Property MRSSBM5 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 164, SqlFieldName = MR_SSBM5 ];

/// MR_SSJB5
Property MRSSJB5 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 165, SqlFieldName = MR_SSJB5 ];

/// MR_SSRQ5
Property MRSSRQ5 As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 166, SqlFieldName = MR_SSRQ5 ];

/// MR_SSMC5
Property MRSSMC5 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 167, SqlFieldName = MR_SSMC5 ];

/// MR_SSCZYS5
Property MRSSCZYS5 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 168, SqlFieldName = MR_SSCZYS5 ];

/// MR_SSIZ5
Property MRSSIZ5 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 169, SqlFieldName = MR_SSIZ5 ];

/// MR_SSIIZ5
Property MRSSIIZ5 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 170, SqlFieldName = MR_SSIIZ5 ];

/// MR_SSMZFS5
Property MRSSMZFS5 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 171, SqlFieldName = MR_SSMZFS5 ];

/// MR_SSQKYHDJ5
Property MRSSQKYHDJ5 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 172, SqlFieldName = MR_SSQKYHDJ5 ];

/// MR_SSMZYS5
Property MRSSMZYS5 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 173, SqlFieldName = MR_SSMZYS5 ];

/// MR_SSSFZQ5
Property MRSSSFZQ5 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 174, SqlFieldName = MR_SSSFZQ5 ];

/// MR_SSBM6
Property MRSSBM6 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 175, SqlFieldName = MR_SSBM6 ];

/// MR_SSJB6
Property MRSSJB6 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 176, SqlFieldName = MR_SSJB6 ];

/// MR_SSRQ6
Property MRSSRQ6 As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 177, SqlFieldName = MR_SSRQ6 ];

/// MR_SSMC6
Property MRSSMC6 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 178, SqlFieldName = MR_SSMC6 ];

/// MR_SSCZYS6
Property MRSSCZYS6 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 179, SqlFieldName = MR_SSCZYS6 ];

/// MR_SSIZ6
Property MRSSIZ6 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 180, SqlFieldName = MR_SSIZ6 ];

/// MR_SSIIZ6
Property MRSSIIZ6 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 181, SqlFieldName = MR_SSIIZ6 ];

/// MR_SSMZFS6
Property MRSSMZFS6 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 182, SqlFieldName = MR_SSMZFS6 ];

/// MR_SSQKYHDJ6
Property MRSSQKYHDJ6 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 183, SqlFieldName = MR_SSQKYHDJ6 ];

/// MR_SSMZYS6
Property MRSSMZYS6 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 184, SqlFieldName = MR_SSMZYS6 ];

/// MR_SSSFZQ6
Property MRSSSFZQ6 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 185, SqlFieldName = MR_SSSFZQ6 ];

/// MR_SSBM7
Property MRSSBM7 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 186, SqlFieldName = MR_SSBM7 ];

/// MR_SSJB7
Property MRSSJB7 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 187, SqlFieldName = MR_SSJB7 ];

/// MR_SSRQ7
Property MRSSRQ7 As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 188, SqlFieldName = MR_SSRQ7 ];

/// MR_SSMC7
Property MRSSMC7 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 189, SqlFieldName = MR_SSMC7 ];

/// MR_SSCZYS7
Property MRSSCZYS7 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 190, SqlFieldName = MR_SSCZYS7 ];

/// MR_SSIZ7
Property MRSSIZ7 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 191, SqlFieldName = MR_SSIZ7 ];

/// MR_SSIIZ7
Property MRSSIIZ7 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 192, SqlFieldName = MR_SSIIZ7 ];

/// MR_SSMZFS7
Property MRSSMZFS7 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 193, SqlFieldName = MR_SSMZFS7 ];

/// MR_SSQKYHDJ7
Property MRSSQKYHDJ7 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 194, SqlFieldName = MR_SSQKYHDJ7 ];

/// MR_SSMZYS7
Property MRSSMZYS7 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 195, SqlFieldName = MR_SSMZYS7 ];

/// MR_SSSFZQ7
Property MRSSSFZQ7 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 196, SqlFieldName = MR_SSSFZQ7 ];

/// MR_SSBM8
Property MRSSBM8 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 197, SqlFieldName = MR_SSBM8 ];

/// MR_SSJB8
Property MRSSJB8 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 198, SqlFieldName = MR_SSJB8 ];

/// MR_SSRQ8
Property MRSSRQ8 As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 199, SqlFieldName = MR_SSRQ8 ];

/// MR_SSMC8
Property MRSSMC8 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 200, SqlFieldName = MR_SSMC8 ];

/// MR_SSCZYS8
Property MRSSCZYS8 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 201, SqlFieldName = MR_SSCZYS8 ];

/// MR_SSIZ8
Property MRSSIZ8 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 202, SqlFieldName = MR_SSIZ8 ];

/// MR_SSIIZ8
Property MRSSIIZ8 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 203, SqlFieldName = MR_SSIIZ8 ];

/// MR_SSMZFS8
Property MRSSMZFS8 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 204, SqlFieldName = MR_SSMZFS8 ];

/// MR_SSQKYHDJ8
Property MRSSQKYHDJ8 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 205, SqlFieldName = MR_SSQKYHDJ8 ];

/// MR_SSMZYS8
Property MRSSMZYS8 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 206, SqlFieldName = MR_SSMZYS8 ];

/// MR_SSSFZQ8
Property MRSSSFZQ8 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 207, SqlFieldName = MR_SSSFZQ8 ];

/// MR_SSBM9
Property MRSSBM9 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 208, SqlFieldName = MR_SSBM9 ];

/// MR_SSJB9
Property MRSSJB9 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 209, SqlFieldName = MR_SSJB9 ];

/// MR_SSRQ9
Property MRSSRQ9 As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 210, SqlFieldName = MR_SSRQ9 ];

/// MR_SSMC9
Property MRSSMC9 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 211, SqlFieldName = MR_SSMC9 ];

/// MR_SSCZYS9
Property MRSSCZYS9 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 212, SqlFieldName = MR_SSCZYS9 ];

/// MR_SSIZ9
Property MRSSIZ9 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 213, SqlFieldName = MR_SSIZ9 ];

/// MR_SSIIZ9
Property MRSSIIZ9 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 214, SqlFieldName = MR_SSIIZ9 ];

/// MR_SSMZFS9
Property MRSSMZFS9 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 215, SqlFieldName = MR_SSMZFS9 ];

/// MR_SSQKYHDJ9
Property MRSSQKYHDJ9 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 216, SqlFieldName = MR_SSQKYHDJ9 ];

/// MR_SSMZYS9
Property MRSSMZYS9 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 217, SqlFieldName = MR_SSMZYS9 ];

/// MR_SSSFZQ9
Property MRSSSFZQ9 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 218, SqlFieldName = MR_SSSFZQ9 ];

/// MR_SSBM10
Property MRSSBM10 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 219, SqlFieldName = MR_SSBM10 ];

/// MR_SSJB10
Property MRSSJB10 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 220, SqlFieldName = MR_SSJB10 ];

/// MR_SSRQ10
Property MRSSRQ10 As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 221, SqlFieldName = MR_SSRQ10 ];

/// MR_SSMC10
Property MRSSMC10 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 222, SqlFieldName = MR_SSMC10 ];

/// MR_SSCZYS10
Property MRSSCZYS10 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 223, SqlFieldName = MR_SSCZYS10 ];

/// MR_SSIZ10
Property MRSSIZ10 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 224, SqlFieldName = MR_SSIZ10 ];

/// MR_SSIIZ10
Property MRSSIIZ10 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 225, SqlFieldName = MR_SSIIZ10 ];

/// MR_SSMZFS10
Property MRSSMZFS10 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 226, SqlFieldName = MR_SSMZFS10 ];

/// MR_SSQKYHDJ10
Property MRSSQKYHDJ10 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 227, SqlFieldName = MR_SSQKYHDJ10 ];

/// MR_SSMZYS10
Property MRSSMZYS10 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 228, SqlFieldName = MR_SSMZYS10 ];

/// MR_SSSFZQ10
Property MRSSSFZQ10 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 229, SqlFieldName = MR_SSSFZQ10 ];

/// MR_QJCS
Property MRQJCS As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 230, SqlFieldName = MR_QJCS ];

/// MR_QJCGCS
Property MRQJCGCS As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 231, SqlFieldName = MR_QJCGCS ];

/// MR_ZYZFF
Property MRZYZFF As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 232, SqlFieldName = MR_ZYZFF ];

/// MR_ZFJE
Property MRZFJE As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 233, SqlFieldName = MR_ZFJE ];

/// MR_YBYLFWF
Property MRYBYLFWF As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 234, SqlFieldName = MR_YBYLFWF ];

/// MR_YBYLCZF
Property MRYBYLCZF As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 235, SqlFieldName = MR_YBYLCZF ];

/// MR_HLF
Property MRHLF As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 236, SqlFieldName = MR_HLF ];

/// MR_QTFY
Property MRQTFY As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 237, SqlFieldName = MR_QTFY ];

/// MR_BLZDF
Property MRBLZDF As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 238, SqlFieldName = MR_BLZDF ];

/// MR_SYSZDF
Property MRSYSZDF As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 239, SqlFieldName = MR_SYSZDF ];

/// MR_YXXZDF
Property MRYXXZDF As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 240, SqlFieldName = MR_YXXZDF ];

/// MR_LCZDXMF
Property MRLCZDXMF As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 241, SqlFieldName = MR_LCZDXMF ];

/// MR_FSSZLXMF
Property MRFSSZLXMF As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 242, SqlFieldName = MR_FSSZLXMF ];

/// MR_LCWLZLF
Property MRLCWLZLF As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 243, SqlFieldName = MR_LCWLZLF ];

/// MR_SSZLF
Property MRSSZLF As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 244, SqlFieldName = MR_SSZLF ];

/// MR_MZF
Property MRMZF As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 245, SqlFieldName = MR_MZF ];

/// MR_SSF
Property MRSSF As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 246, SqlFieldName = MR_SSF ];

/// MR_KFF
Property MRKFF As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 247, SqlFieldName = MR_KFF ];

/// MR_ZYZLF
Property MRZYZLF As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 248, SqlFieldName = MR_ZYZLF ];

/// MR_XYF
Property MRXYF As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 249, SqlFieldName = MR_XYF ];

/// MR_KJYWFY
Property MRKJYWFY As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 250, SqlFieldName = MR_KJYWFY ];

/// MR_ZCHENGYF
Property MRZCHENGYF As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 251, SqlFieldName = MR_ZCHENGYF ];

/// MR_ZCAOYF
Property MRZCAOYF As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 252, SqlFieldName = MR_ZCAOYF ];

/// MR_XF
Property MRXF As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 253, SqlFieldName = MR_XF ];

/// MR_BDBLZPF
Property MRBDBLZPF As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 254, SqlFieldName = MR_BDBLZPF ];

/// MR_QDBLZPF
Property MRQDBLZPF As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 255, SqlFieldName = MR_QDBLZPF ];

/// MR_JCYYCXYYCLF
Property MRJCYYCXYYCLF As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 256, SqlFieldName = MR_JCYYCXYYCLF ];

/// MR_ZLYYCXYYCLF
Property MRZLYYCXYYCLF As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 257, SqlFieldName = MR_ZLYYCXYYCLF ];

/// MR_SSYYCXYYCLF
Property MRSSYYCXYYCLF As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 258, SqlFieldName = MR_SSYYCXYYCLF ];

/// MR_QTF
Property MRQTF As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 259, SqlFieldName = MR_QTF ];

/// MR_SSZDDWBYS
Property MRSSZDDWBYS As %Library.String(COLLATION = "Exact", MAXLEN = 4096, TRUNCATE = 0) [ SqlColumnNumber = 260, SqlFieldName = MR_SSZDDWBYS ];

/// MR_SSZDDJBBM
Property MRSSZDDJBBM As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 261, SqlFieldName = MR_SSZDDJBBM ];

/// MR_BLZD
Property MRBLZD As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 262, SqlFieldName = MR_BLZD ];

/// MR_BLZDBM
Property MRBLZDBM As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 263, SqlFieldName = MR_BLZDBM ];

/// MR_BLH
Property MRBLH As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 264, SqlFieldName = MR_BLH ];

/// MR_YWGMBZ
Property MRYWGMBZ As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 265, SqlFieldName = MR_YWGMBZ ];

/// MR_YWGMW
Property MRYWGMW As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 266, SqlFieldName = MR_YWGMW ];

/// MR_SWHZSJ
Property MRSWHZSJ As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 267, SqlFieldName = MR_SWHZSJ ];

/// MR_XX
Property MRXX As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 268, SqlFieldName = MR_XX ];

/// MR_RH
Property MRRH As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 269, SqlFieldName = MR_RH ];

/// MR_KZR
Property MRKZR As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 270, SqlFieldName = MR_KZR ];

/// MR_ZRYS
Property MRZRYS As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 271, SqlFieldName = MR_ZRYS ];

/// MR_ZZYS
Property MRZZYS As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 272, SqlFieldName = MR_ZZYS ];

/// MR_ZYYS
Property MRZYYS As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 273, SqlFieldName = MR_ZYYS ];

/// MR_ZRHS
Property MRZRHS As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 274, SqlFieldName = MR_ZRHS ];

/// MR_JXYS
Property MRJXYS As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 275, SqlFieldName = MR_JXYS ];

/// MR_XXYS
Property MRXXYS As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 276, SqlFieldName = MR_XXYS ];

/// MR_BMY
Property MRBMY As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 277, SqlFieldName = MR_BMY ];

/// MR_BAZL
Property MRBAZL As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 278, SqlFieldName = MR_BAZL ];

/// MR_ZKYS
Property MRZKYS As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 279, SqlFieldName = MR_ZKYS ];

/// MR_ZKHS
Property MRZKHS As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 280, SqlFieldName = MR_ZKHS ];

/// MR_ZKRQ
Property MRZKRQ As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 281, SqlFieldName = MR_ZKRQ ];

/// MR_MRDate
Property MRMRDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 282, SqlFieldName = MR_MRDate ];

/// MR_ZZYJH
Property MRZZYJH As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 283, SqlFieldName = MR_ZZYJH ];

/// MR_ZZYMD
Property MRZZYMD As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 284, SqlFieldName = MR_ZZYMD ];

/// MR_SFTBZZZY
Property MRSFTBZZZY As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 285, SqlFieldName = MR_SFTBZZZY ];

/// MR_LNSSRYQHMSJT
Property MRLNSSRYQHMSJT As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 286, SqlFieldName = MR_LNSSRYQHMSJT ];

/// MR_LNSSRYQHMSJS
Property MRLNSSRYQHMSJS As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 287, SqlFieldName = MR_LNSSRYQHMSJS ];

/// MR_LNSSRYQHMSJF
Property MRLNSSRYQHMSJF As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 288, SqlFieldName = MR_LNSSRYQHMSJF ];

/// MR_LNSSRYHHMSJT
Property MRLNSSRYHHMSJT As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 289, SqlFieldName = MR_LNSSRYHHMSJT ];

/// MR_LNSSRYHHMSJS
Property MRLNSSRYHHMSJS As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 290, SqlFieldName = MR_LNSSRYHHMSJS ];

/// MR_LNSSRYHHMSJF
Property MRLNSSRYHHMSJF As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 291, SqlFieldName = MR_LNSSRYHHMSJF ];

/// MR_BAFX
Property MRBAFX As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 292, SqlFieldName = MR_BAFX ];

/// MR_SFSSZZJH
Property MRSFSSZZJH As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 293, SqlFieldName = MR_SFSSZZJH ];

/// MR_JHSJRRQSJ
Property MRJHSJRRQSJ As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 294, SqlFieldName = MR_JHSJRRQSJ ];

/// MR_JHSTCRQSJ
Property MRJHSTCRQSJ As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 295, SqlFieldName = MR_JHSTCRQSJ ];

/// MR_SFDBZGL
Property MRSFDBZGL As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 296, SqlFieldName = MR_SFDBZGL ];

/// MR_SFSSLCLJGL
Property MRSFSSLCLJGL As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 297, SqlFieldName = MR_SFSSLCLJGL ];

/// MR_SFSSDGL
Property MRSFSSDGL As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 298, SqlFieldName = MR_SFSSDGL ];

/// MR_SFSYKSS
Property MRSFSYKSS As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 299, SqlFieldName = MR_SFSYKSS ];

/// MR_SYKSSYW
Property MRSYKSSYW As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 300, SqlFieldName = MR_SYKSSYW ];

/// MR_SFLHSYKSS
Property MRSFLHSYKSS As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 301, SqlFieldName = MR_SFLHSYKSS ];

/// MR_LHSYKSSYW
Property MRLHSYKSSYW As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 302, SqlFieldName = MR_LHSYKSSYW ];

/// MR_SFXJPYBBSJ
Property MRSFXJPYBBSJ As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 303, SqlFieldName = MR_SFXJPYBBSJ ];

/// MR_SFFDCRB
Property MRSFFDCRB As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 304, SqlFieldName = MR_SFFDCRB ];

/// MR_ZLFQ
Property MRZLFQ As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 305, SqlFieldName = MR_ZLFQ ];

/// MR_XSEAPF
Property MRXSEAPF As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 306, SqlFieldName = MR_XSEAPF ];

/// MR_HXB
Property MRHXB As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 307, SqlFieldName = MR_HXB ];

/// MR_XXB
Property MRXXB As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 308, SqlFieldName = MR_XXB ];

/// MR_XJ
Property MRXJ As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 309, SqlFieldName = MR_XJ ];

/// MR_QX
Property MRQX As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 310, SqlFieldName = MR_QX ];

/// MR_SFFSRC
Property MRSFFSRC As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 311, SqlFieldName = MR_SFFSRC ];

/// MR_SFFSYLSG
Property MRSFFSYLSG As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 312, SqlFieldName = MR_SFFSYLSG ];

/// MR_SFFSYLCC
Property MRSFFSYLCC As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 313, SqlFieldName = MR_SFFSYLCC ];

/// MR_SFSZ
Property MRSFSZ As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 314, SqlFieldName = MR_SFSZ ];

/// MR_SZSJN
Property MRSZSJN As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 315, SqlFieldName = MR_SZSJN ];

/// MR_SZSJY
Property MRSZSJY As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 316, SqlFieldName = MR_SZSJY ];

/// MR_SZSJZ
Property MRSZSJZ As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 317, SqlFieldName = MR_SZSJZ ];

/// MR_TSHLTS
Property MRTSHLTS As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 318, SqlFieldName = MR_TSHLTS ];

/// MR_YJHLTS
Property MRYJHLTS As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 319, SqlFieldName = MR_YJHLTS ];

/// MR_EJHLTS
Property MREJHLTS As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 320, SqlFieldName = MR_EJHLTS ];

/// MR_SJHLTS
Property MRSJHLTS As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 321, SqlFieldName = MR_SJHLTS ];

/// MR_WZBRQJBZ
Property MRWZBRQJBZ As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 322, SqlFieldName = MR_WZBRQJBZ ];

/// MR_SFSX
Property MRSFSX As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 323, SqlFieldName = MR_SFSX ];

/// MR_SXFY
Property MRSXFY As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 324, SqlFieldName = MR_SXFY ];

/// MR_SFCFSSS
Property MRSFCFSSS As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 325, SqlFieldName = MR_SFCFSSS ];

/// MR_SFSY
Property MRSFSY As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 326, SqlFieldName = MR_SFSY ];

/// MR_SYFY
Property MRSYFY As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 327, SqlFieldName = MR_SYFY ];

/// MR_XSECS
Property MRXSECS As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 328, SqlFieldName = MR_XSECS ];

/// MR_CFCS
Property MRCFCS As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 329, SqlFieldName = MR_CFCS ];

/// MR_YYCUSW
Property MRYYCUSW As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 330, SqlFieldName = MR_YYCUSW ];

/// MR_SSYWYL
Property MRSSYWYL As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 331, SqlFieldName = MR_SSYWYL ];

/// MR_YYXQX
Property MRYYXQX As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 332, SqlFieldName = MR_YYXQX ];

/// MR_YYXYWCCLS
Property MRYYXYWCCLS As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 333, SqlFieldName = MR_YYXYWCCLS ];

/// MR_BYXJC
Property MRBYXJC As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 334, SqlFieldName = MR_BYXJC ];

/// MR_SSBFZ
Property MRSSBFZ As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 335, SqlFieldName = MR_SSBFZ ];

/// MR_SSBFZMC
Property MRSSBFZMC As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 336, SqlFieldName = MR_SSBFZMC ];

/// MR_SWSFFSZWSSQN
Property MRSWSFFSZWSSQN As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 337, SqlFieldName = MR_SWSFFSZWSSQN ];

/// MR_SFYNFSDDHZCSJ
Property MRSFYNFSDDHZCSJ As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 338, SqlFieldName = MR_SFYNFSDDHZCSJ ];

/// MR_SHCD
Property MRSHCD As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 339, SqlFieldName = MR_SHCD ];

/// MR_MZRYZDFHQK
Property MRMZRYZDFHQK As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 340, SqlFieldName = MR_MZRYZDFHQK ];

/// MR_RYCYZDFHQK
Property MRRYCYZDFHQK As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 341, SqlFieldName = MR_RYCYZDFHQK ];

/// MR_SQSHZDFHQK
Property MRSQSHZDFHQK As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 342, SqlFieldName = MR_SQSHZDFHQK ];

/// MR_LCBLZDFHQK
Property MRLCBLZDFHQK As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 343, SqlFieldName = MR_LCBLZDFHQK ];

/// MR_FSBLZDFHQK
Property MRFSBLZDFHQK As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 344, SqlFieldName = MR_FSBLZDFHQK ];

/// MR_SSBDSLBLZDFH
Property MRSSBDSLBLZDFH As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 345, SqlFieldName = MR_SSBDSLBLZDFH ];

/// MR_SEXZLSQSHZDFH
Property MRSEXZLSQSHZDFH As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 346, SqlFieldName = MR_SEXZLSQSHZDFH ];

/// MR_GEXZLSQSHZDFH
Property MRGEXZLSQSHZDFH As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 347, SqlFieldName = MR_GEXZLSQSHZDFH ];

/// MR_FEXZLSQSHZDFH
Property MRFEXZLSQSHZDFH As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 348, SqlFieldName = MR_FEXZLSQSHZDFH ];

/// MR_WEXZLSQSHZDFH
Property MRWEXZLSQSHZDFH As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 349, SqlFieldName = MR_WEXZLSQSHZDFH ];

/// MR_ZCEXZLSQSHZDFH
Property MRZCEXZLSQSHZDFH As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 350, SqlFieldName = MR_ZCEXZLSQSHZDFH ];

/// MR_JCEXZLSQSHZDFH
Property MRJCEXZLSQSHZDFH As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 351, SqlFieldName = MR_JCEXZLSQSHZDFH ];

/// MR_LXYZLZPF
Property MRLXYZLZPF As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 352, SqlFieldName = MR_LXYZLZPF ];

/// MR_XBYZLZPF
Property MRXBYZLZPF As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 353, SqlFieldName = MR_XBYZLZPF ];

/// 新增6个诊断  add by zlf 20191112
/// MR_CYQTZD16
Property MRCYQTZD16 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 354, SqlFieldName = MR_CYQTZD16 ];

/// MR_CYQTZDMC16
Property MRCYQTZDMC16 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 355, SqlFieldName = MR_CYQTZDMC16 ];

/// MR_CYQTZDRYBQ16
Property MRCYQTZDRYBQ16 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 356, SqlFieldName = MR_CYQTZDRYBQ16 ];

/// MR_CYQTZDZLJG16
Property MRCYQTZDZLJG16 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 357, SqlFieldName = MR_CYQTZDZLJG16 ];

/// MR_CYQTZD17
Property MRCYQTZD17 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 358, SqlFieldName = MR_CYQTZD17 ];

/// MR_CYQTZDMC17
Property MRCYQTZDMC17 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 359, SqlFieldName = MR_CYQTZDMC17 ];

/// MR_CYQTZDRYBQ17
Property MRCYQTZDRYBQ17 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 360, SqlFieldName = MR_CYQTZDRYBQ17 ];

/// MR_CYQTZDZLJG17
Property MRCYQTZDZLJG17 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 361, SqlFieldName = MR_CYQTZDZLJG17 ];

/// MR_CYQTZD18
Property MRCYQTZD18 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 362, SqlFieldName = MR_CYQTZD18 ];

/// MR_CYQTZDMC18
Property MRCYQTZDMC18 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 363, SqlFieldName = MR_CYQTZDMC18 ];

/// MR_CYQTZDRYBQ18
Property MRCYQTZDRYBQ18 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 364, SqlFieldName = MR_CYQTZDRYBQ18 ];

/// MR_CYQTZDZLJG18
Property MRCYQTZDZLJG18 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 365, SqlFieldName = MR_CYQTZDZLJG18 ];

/// MR_CYQTZD19
Property MRCYQTZD19 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 366, SqlFieldName = MR_CYQTZD19 ];

/// MR_CYQTZDMC19
Property MRCYQTZDMC19 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 367, SqlFieldName = MR_CYQTZDMC19 ];

/// MR_CYQTZDRYBQ19
Property MRCYQTZDRYBQ19 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 368, SqlFieldName = MR_CYQTZDRYBQ19 ];

/// MR_CYQTZDZLJG19
Property MRCYQTZDZLJG19 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 369, SqlFieldName = MR_CYQTZDZLJG19 ];

/// MR_CYQTZD20
Property MRCYQTZD20 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 370, SqlFieldName = MR_CYQTZD20 ];

/// MR_CYQTZDMC20
Property MRCYQTZDMC20 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 371, SqlFieldName = MR_CYQTZDMC20 ];

/// MR_CYQTZDRYBQ20
Property MRCYQTZDRYBQ20 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 372, SqlFieldName = MR_CYQTZDRYBQ20 ];

/// MR_CYQTZDZLJG20
Property MRCYQTZDZLJG20 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 373, SqlFieldName = MR_CYQTZDZLJG20 ];

/// MR_CYQTZD21
Property MRCYQTZD21 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 374, SqlFieldName = MR_CYQTZD21 ];

/// MR_CYQTZDMC21
Property MRCYQTZDMC21 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 375, SqlFieldName = MR_CYQTZDMC21 ];

/// MR_CYQTZDRYBQ21
Property MRCYQTZDRYBQ21 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 376, SqlFieldName = MR_CYQTZDRYBQ21 ];

/// MR_CYQTZDZLJG21
Property MRCYQTZDZLJG21 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 377, SqlFieldName = MR_CYQTZDZLJG21 ];

/// 手术增加到30个
/// MR_SSBM11
Property MRSSBM11 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 378, SqlFieldName = MR_SSBM11 ];

/// MR_SSJB11
Property MRSSJB11 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 379, SqlFieldName = MR_SSJB11 ];

/// MR_SSRQ11
Property MRSSRQ11 As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 380, SqlFieldName = MR_SSRQ11 ];

/// MR_SSMC11
Property MRSSMC11 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 381, SqlFieldName = MR_SSMC11 ];

/// MR_SSCZYS11
Property MRSSCZYS11 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 382, SqlFieldName = MR_SSCZYS11 ];

/// MR_SSIZ11
Property MRSSIZ11 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 383, SqlFieldName = MR_SSIZ11 ];

/// MR_SSIIZ11
Property MRSSIIZ11 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 384, SqlFieldName = MR_SSIIZ11 ];

/// MR_SSMZFS11
Property MRSSMZFS11 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 385, SqlFieldName = MR_SSMZFS11 ];

/// MR_SSQKYHDJ11
Property MRSSQKYHDJ11 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 386, SqlFieldName = MR_SSQKYHDJ11 ];

/// MR_SSMZYS11
Property MRSSMZYS11 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 387, SqlFieldName = MR_SSMZYS11 ];

/// MR_SSSFZQ11
Property MRSSSFZQ11 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 388, SqlFieldName = MR_SSSFZQ11 ];

/// MR_SSBM12
Property MRSSBM12 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 389, SqlFieldName = MR_SSBM12 ];

/// MR_SSJB12
Property MRSSJB12 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 390, SqlFieldName = MR_SSJB12 ];

/// MR_SSRQ12
Property MRSSRQ12 As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 391, SqlFieldName = MR_SSRQ12 ];

/// MR_SSMC12
Property MRSSMC12 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 392, SqlFieldName = MR_SSMC12 ];

/// MR_SSCZYS12
Property MRSSCZYS12 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 393, SqlFieldName = MR_SSCZYS12 ];

/// MR_SSIZ12
Property MRSSIZ12 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 394, SqlFieldName = MR_SSIZ12 ];

/// MR_SSIIZ12
Property MRSSIIZ12 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 395, SqlFieldName = MR_SSIIZ12 ];

/// MR_SSMZFS12
Property MRSSMZFS12 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 396, SqlFieldName = MR_SSMZFS12 ];

/// MR_SSQKYHDJ12
Property MRSSQKYHDJ12 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 397, SqlFieldName = MR_SSQKYHDJ12 ];

/// MR_SSMZYS12
Property MRSSMZYS12 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 398, SqlFieldName = MR_SSMZYS12 ];

/// MR_SSSFZQ12
Property MRSSSFZQ12 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 399, SqlFieldName = MR_SSSFZQ12 ];

/// MR_SSBM13
Property MRSSBM13 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 400, SqlFieldName = MR_SSBM13 ];

/// MR_SSJB13
Property MRSSJB13 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 401, SqlFieldName = MR_SSJB13 ];

/// MR_SSRQ13
Property MRSSRQ13 As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 402, SqlFieldName = MR_SSRQ13 ];

/// MR_SSMC13
Property MRSSMC13 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 403, SqlFieldName = MR_SSMC13 ];

/// MR_SSCZYS13
Property MRSSCZYS13 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 404, SqlFieldName = MR_SSCZYS13 ];

/// MR_SSIZ13
Property MRSSIZ13 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 405, SqlFieldName = MR_SSIZ13 ];

/// MR_SSIIZ13
Property MRSSIIZ13 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 406, SqlFieldName = MR_SSIIZ13 ];

/// MR_SSMZFS13
Property MRSSMZFS13 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 407, SqlFieldName = MR_SSMZFS13 ];

/// MR_SSQKYHDJ13
Property MRSSQKYHDJ13 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 408, SqlFieldName = MR_SSQKYHDJ13 ];

/// MR_SSMZYS13
Property MRSSMZYS13 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 409, SqlFieldName = MR_SSMZYS13 ];

/// MR_SSSFZQ13
Property MRSSSFZQ13 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 410, SqlFieldName = MR_SSSFZQ13 ];

/// MR_SSBM14
Property MRSSBM14 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 411, SqlFieldName = MR_SSBM14 ];

/// MR_SSJB14
Property MRSSJB14 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 412, SqlFieldName = MR_SSJB14 ];

/// MR_SSRQ14
Property MRSSRQ14 As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 413, SqlFieldName = MR_SSRQ14 ];

/// MR_SSMC14
Property MRSSMC14 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 414, SqlFieldName = MR_SSMC14 ];

/// MR_SSCZYS14
Property MRSSCZYS14 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 415, SqlFieldName = MR_SSCZYS14 ];

/// MR_SSIZ14
Property MRSSIZ14 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 416, SqlFieldName = MR_SSIZ14 ];

/// MR_SSIIZ14
Property MRSSIIZ14 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 417, SqlFieldName = MR_SSIIZ14 ];

/// MR_SSMZFS14
Property MRSSMZFS14 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 418, SqlFieldName = MR_SSMZFS14 ];

/// MR_SSQKYHDJ14
Property MRSSQKYHDJ14 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 419, SqlFieldName = MR_SSQKYHDJ14 ];

/// MR_SSMZYS14
Property MRSSMZYS14 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 420, SqlFieldName = MR_SSMZYS14 ];

/// MR_SSSFZQ14
Property MRSSSFZQ14 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 421, SqlFieldName = MR_SSSFZQ14 ];

/// MR_SSBM15
Property MRSSBM15 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 422, SqlFieldName = MR_SSBM15 ];

/// MR_SSJB15
Property MRSSJB15 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 423, SqlFieldName = MR_SSJB15 ];

/// MR_SSRQ15
Property MRSSRQ15 As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 424, SqlFieldName = MR_SSRQ15 ];

/// MR_SSMC15
Property MRSSMC15 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 425, SqlFieldName = MR_SSMC15 ];

/// MR_SSCZYS15
Property MRSSCZYS15 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 426, SqlFieldName = MR_SSCZYS15 ];

/// MR_SSIZ15
Property MRSSIZ15 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 427, SqlFieldName = MR_SSIZ15 ];

/// MR_SSIIZ15
Property MRSSIIZ15 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 428, SqlFieldName = MR_SSIIZ15 ];

/// MR_SSMZFS15
Property MRSSMZFS15 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 429, SqlFieldName = MR_SSMZFS15 ];

/// MR_SSQKYHDJ15
Property MRSSQKYHDJ15 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 430, SqlFieldName = MR_SSQKYHDJ15 ];

/// MR_SSMZYS15
Property MRSSMZYS15 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 431, SqlFieldName = MR_SSMZYS15 ];

/// MR_SSSFZQ15
Property MRSSSFZQ15 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 432, SqlFieldName = MR_SSSFZQ15 ];

/// MR_SSBM16
Property MRSSBM16 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 433, SqlFieldName = MR_SSBM16 ];

/// MR_SSJB16
Property MRSSJB16 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 434, SqlFieldName = MR_SSJB16 ];

/// MR_SSRQ16
Property MRSSRQ16 As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 435, SqlFieldName = MR_SSRQ16 ];

/// MR_SSMC16
Property MRSSMC16 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 436, SqlFieldName = MR_SSMC16 ];

/// MR_SSCZYS16
Property MRSSCZYS16 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 437, SqlFieldName = MR_SSCZYS16 ];

/// MR_SSIZ16
Property MRSSIZ16 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 438, SqlFieldName = MR_SSIZ16 ];

/// MR_SSIIZ16
Property MRSSIIZ16 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 439, SqlFieldName = MR_SSIIZ16 ];

/// MR_SSMZFS16
Property MRSSMZFS16 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 440, SqlFieldName = MR_SSMZFS16 ];

/// MR_SSQKYHDJ16
Property MRSSQKYHDJ16 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 441, SqlFieldName = MR_SSQKYHDJ16 ];

/// MR_SSMZYS16
Property MRSSMZYS16 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 442, SqlFieldName = MR_SSMZYS16 ];

/// MR_SSSFZQ16
Property MRSSSFZQ16 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 443, SqlFieldName = MR_SSSFZQ16 ];

/// MR_SSBM17
Property MRSSBM17 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 444, SqlFieldName = MR_SSBM17 ];

/// MR_SSJB17
Property MRSSJB17 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 445, SqlFieldName = MR_SSJB17 ];

/// MR_SSRQ17
Property MRSSRQ17 As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 446, SqlFieldName = MR_SSRQ17 ];

/// MR_SSMC17
Property MRSSMC17 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 447, SqlFieldName = MR_SSMC17 ];

/// MR_SSCZYS17
Property MRSSCZYS17 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 448, SqlFieldName = MR_SSCZYS17 ];

/// MR_SSIZ17
Property MRSSIZ17 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 449, SqlFieldName = MR_SSIZ17 ];

/// MR_SSIIZ17
Property MRSSIIZ17 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 450, SqlFieldName = MR_SSIIZ17 ];

/// MR_SSMZFS17
Property MRSSMZFS17 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 451, SqlFieldName = MR_SSMZFS17 ];

/// MR_SSQKYHDJ17
Property MRSSQKYHDJ17 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 452, SqlFieldName = MR_SSQKYHDJ17 ];

/// MR_SSMZYS17
Property MRSSMZYS17 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 453, SqlFieldName = MR_SSMZYS17 ];

/// MR_SSSFZQ17
Property MRSSSFZQ17 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 454, SqlFieldName = MR_SSSFZQ17 ];

/// MR_SSBM18
Property MRSSBM18 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 455, SqlFieldName = MR_SSBM18 ];

/// MR_SSJB18
Property MRSSJB18 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 456, SqlFieldName = MR_SSJB18 ];

/// MR_SSRQ18
Property MRSSRQ18 As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 457, SqlFieldName = MR_SSRQ18 ];

/// MR_SSMC18
Property MRSSMC18 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 458, SqlFieldName = MR_SSMC18 ];

/// MR_SSCZYS18
Property MRSSCZYS18 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 459, SqlFieldName = MR_SSCZYS18 ];

/// MR_SSIZ18
Property MRSSIZ18 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 460, SqlFieldName = MR_SSIZ18 ];

/// MR_SSIIZ18
Property MRSSIIZ18 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 461, SqlFieldName = MR_SSIIZ18 ];

/// MR_SSMZFS18
Property MRSSMZFS18 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 462, SqlFieldName = MR_SSMZFS18 ];

/// MR_SSQKYHDJ18
Property MRSSQKYHDJ18 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 463, SqlFieldName = MR_SSQKYHDJ18 ];

/// MR_SSMZYS18
Property MRSSMZYS18 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 464, SqlFieldName = MR_SSMZYS18 ];

/// MR_SSSFZQ18
Property MRSSSFZQ18 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 465, SqlFieldName = MR_SSSFZQ18 ];

/// MR_SSBM19
Property MRSSBM19 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 466, SqlFieldName = MR_SSBM19 ];

/// MR_SSJB19
Property MRSSJB19 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 467, SqlFieldName = MR_SSJB19 ];

/// MR_SSRQ19
Property MRSSRQ19 As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 468, SqlFieldName = MR_SSRQ19 ];

/// MR_SSMC19
Property MRSSMC19 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 469, SqlFieldName = MR_SSMC19 ];

/// MR_SSCZYS19
Property MRSSCZYS19 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 470, SqlFieldName = MR_SSCZYS19 ];

/// MR_SSIZ19
Property MRSSIZ19 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 471, SqlFieldName = MR_SSIZ19 ];

/// MR_SSIIZ19
Property MRSSIIZ19 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 472, SqlFieldName = MR_SSIIZ19 ];

/// MR_SSMZFS19
Property MRSSMZFS19 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 473, SqlFieldName = MR_SSMZFS19 ];

/// MR_SSQKYHDJ19
Property MRSSQKYHDJ19 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 474, SqlFieldName = MR_SSQKYHDJ19 ];

/// MR_SSMZYS19
Property MRSSMZYS19 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 475, SqlFieldName = MR_SSMZYS19 ];

/// MR_SSSFZQ19
Property MRSSSFZQ19 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 476, SqlFieldName = MR_SSSFZQ19 ];

/// MR_SSBM20
Property MRSSBM20 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 477, SqlFieldName = MR_SSBM20 ];

/// MR_SSJB20
Property MRSSJB20 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 478, SqlFieldName = MR_SSJB20 ];

/// MR_SSRQ20
Property MRSSRQ20 As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 479, SqlFieldName = MR_SSRQ20 ];

/// MR_SSMC20
Property MRSSMC20 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 480, SqlFieldName = MR_SSMC20 ];

/// MR_SSCZYS20
Property MRSSCZYS20 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 481, SqlFieldName = MR_SSCZYS20 ];

/// MR_SSIZ20
Property MRSSIZ20 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 482, SqlFieldName = MR_SSIZ20 ];

/// MR_SSIIZ20
Property MRSSIIZ20 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 483, SqlFieldName = MR_SSIIZ20 ];

/// MR_SSMZFS20
Property MRSSMZFS20 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 484, SqlFieldName = MR_SSMZFS20 ];

/// MR_SSQKYHDJ20
Property MRSSQKYHDJ20 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 485, SqlFieldName = MR_SSQKYHDJ20 ];

/// MR_SSMZYS20
Property MRSSMZYS20 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 486, SqlFieldName = MR_SSMZYS20 ];

/// MR_SSSFZQ20
Property MRSSSFZQ20 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 487, SqlFieldName = MR_SSSFZQ20 ];

/// MR_SSBM21
Property MRSSBM21 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 488, SqlFieldName = MR_SSBM21 ];

/// MR_SSJB21
Property MRSSJB21 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 489, SqlFieldName = MR_SSJB21 ];

/// MR_SSRQ21
Property MRSSRQ21 As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 490, SqlFieldName = MR_SSRQ21 ];

/// MR_SSMC21
Property MRSSMC21 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 491, SqlFieldName = MR_SSMC21 ];

/// MR_SSCZYS21
Property MRSSCZYS21 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 492, SqlFieldName = MR_SSCZYS21 ];

/// MR_SSIZ21
Property MRSSIZ21 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 493, SqlFieldName = MR_SSIZ21 ];

/// MR_SSIIZ21
Property MRSSIIZ21 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 494, SqlFieldName = MR_SSIIZ21 ];

/// MR_SSMZFS21
Property MRSSMZFS21 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 495, SqlFieldName = MR_SSMZFS21 ];

/// MR_SSQKYHDJ21
Property MRSSQKYHDJ21 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 496, SqlFieldName = MR_SSQKYHDJ21 ];

/// MR_SSMZYS21
Property MRSSMZYS21 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 497, SqlFieldName = MR_SSMZYS21 ];

/// MR_SSSFZQ21
Property MRSSSFZQ21 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 498, SqlFieldName = MR_SSSFZQ21 ];

/// MR_SSBM22
Property MRSSBM22 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 499, SqlFieldName = MR_SSBM22 ];

/// MR_SSJB22
Property MRSSJB22 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 500, SqlFieldName = MR_SSJB22 ];

/// MR_SSRQ22
Property MRSSRQ22 As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 501, SqlFieldName = MR_SSRQ22 ];

/// MR_SSMC22
Property MRSSMC22 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 502, SqlFieldName = MR_SSMC22 ];

/// MR_SSCZYS22
Property MRSSCZYS22 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 503, SqlFieldName = MR_SSCZYS22 ];

/// MR_SSIZ22
Property MRSSIZ22 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 504, SqlFieldName = MR_SSIZ22 ];

/// MR_SSIIZ22
Property MRSSIIZ22 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 505, SqlFieldName = MR_SSIIZ22 ];

/// MR_SSMZFS22
Property MRSSMZFS22 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 506, SqlFieldName = MR_SSMZFS22 ];

/// MR_SSQKYHDJ22
Property MRSSQKYHDJ22 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 507, SqlFieldName = MR_SSQKYHDJ22 ];

/// MR_SSMZYS22
Property MRSSMZYS22 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 508, SqlFieldName = MR_SSMZYS22 ];

/// MR_SSSFZQ22
Property MRSSSFZQ22 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 509, SqlFieldName = MR_SSSFZQ22 ];

/// MR_SSBM23
Property MRSSBM23 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 510, SqlFieldName = MR_SSBM23 ];

/// MR_SSJB23
Property MRSSJB23 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 511, SqlFieldName = MR_SSJB23 ];

/// MR_SSRQ23
Property MRSSRQ23 As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 512, SqlFieldName = MR_SSRQ23 ];

/// MR_SSMC23
Property MRSSMC23 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 513, SqlFieldName = MR_SSMC23 ];

/// MR_SSCZYS23
Property MRSSCZYS23 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 514, SqlFieldName = MR_SSCZYS23 ];

/// MR_SSIZ23
Property MRSSIZ23 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 515, SqlFieldName = MR_SSIZ23 ];

/// MR_SSIIZ23
Property MRSSIIZ23 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 516, SqlFieldName = MR_SSIIZ23 ];

/// MR_SSMZFS23
Property MRSSMZFS23 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 517, SqlFieldName = MR_SSMZFS23 ];

/// MR_SSQKYHDJ23
Property MRSSQKYHDJ23 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 518, SqlFieldName = MR_SSQKYHDJ23 ];

/// MR_SSMZYS23
Property MRSSMZYS23 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 519, SqlFieldName = MR_SSMZYS23 ];

/// MR_SSSFZQ23
Property MRSSSFZQ23 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 520, SqlFieldName = MR_SSSFZQ23 ];

/// MR_SSBM24
Property MRSSBM24 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 521, SqlFieldName = MR_SSBM24 ];

/// MR_SSJB24
Property MRSSJB24 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 522, SqlFieldName = MR_SSJB24 ];

/// MR_SSRQ24
Property MRSSRQ24 As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 523, SqlFieldName = MR_SSRQ24 ];

/// MR_SSMC24
Property MRSSMC24 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 524, SqlFieldName = MR_SSMC24 ];

/// MR_SSCZYS24
Property MRSSCZYS24 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 525, SqlFieldName = MR_SSCZYS24 ];

/// MR_SSIZ24
Property MRSSIZ24 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 526, SqlFieldName = MR_SSIZ24 ];

/// MR_SSIIZ24
Property MRSSIIZ24 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 527, SqlFieldName = MR_SSIIZ24 ];

/// MR_SSMZFS24
Property MRSSMZFS24 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 528, SqlFieldName = MR_SSMZFS24 ];

/// MR_SSQKYHDJ24
Property MRSSQKYHDJ24 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 529, SqlFieldName = MR_SSQKYHDJ24 ];

/// MR_SSMZYS24
Property MRSSMZYS24 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 530, SqlFieldName = MR_SSMZYS24 ];

/// MR_SSSFZQ24
Property MRSSSFZQ24 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 531, SqlFieldName = MR_SSSFZQ24 ];

/// MR_SSBM25
Property MRSSBM25 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 532, SqlFieldName = MR_SSBM25 ];

/// MR_SSJB25
Property MRSSJB25 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 533, SqlFieldName = MR_SSJB25 ];

/// MR_SSRQ25
Property MRSSRQ25 As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 534, SqlFieldName = MR_SSRQ25 ];

/// MR_SSMC25
Property MRSSMC25 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 535, SqlFieldName = MR_SSMC25 ];

/// MR_SSCZYS25
Property MRSSCZYS25 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 536, SqlFieldName = MR_SSCZYS25 ];

/// MR_SSIZ25
Property MRSSIZ25 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 537, SqlFieldName = MR_SSIZ25 ];

/// MR_SSIIZ25
Property MRSSIIZ25 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 538, SqlFieldName = MR_SSIIZ25 ];

/// MR_SSMZFS25
Property MRSSMZFS25 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 539, SqlFieldName = MR_SSMZFS25 ];

/// MR_SSQKYHDJ25
Property MRSSQKYHDJ25 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 540, SqlFieldName = MR_SSQKYHDJ25 ];

/// MR_SSMZYS25
Property MRSSMZYS25 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 541, SqlFieldName = MR_SSMZYS25 ];

/// MR_SSSFZQ25
Property MRSSSFZQ25 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 542, SqlFieldName = MR_SSSFZQ25 ];

/// MR_SSBM26
Property MRSSBM26 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 543, SqlFieldName = MR_SSBM26 ];

/// MR_SSJB26
Property MRSSJB26 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 544, SqlFieldName = MR_SSJB26 ];

/// MR_SSRQ26
Property MRSSRQ26 As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 545, SqlFieldName = MR_SSRQ26 ];

/// MR_SSMC26
Property MRSSMC26 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 546, SqlFieldName = MR_SSMC26 ];

/// MR_SSCZYS26
Property MRSSCZYS26 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 547, SqlFieldName = MR_SSCZYS26 ];

/// MR_SSIZ26
Property MRSSIZ26 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 548, SqlFieldName = MR_SSIZ26 ];

/// MR_SSIIZ26
Property MRSSIIZ26 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 549, SqlFieldName = MR_SSIIZ26 ];

/// MR_SSMZFS26
Property MRSSMZFS26 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 550, SqlFieldName = MR_SSMZFS26 ];

/// MR_SSQKYHDJ26
Property MRSSQKYHDJ26 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 551, SqlFieldName = MR_SSQKYHDJ26 ];

/// MR_SSMZYS26
Property MRSSMZYS26 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 552, SqlFieldName = MR_SSMZYS26 ];

/// MR_SSSFZQ26
Property MRSSSFZQ26 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 553, SqlFieldName = MR_SSSFZQ26 ];

/// MR_SSBM27
Property MRSSBM27 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 554, SqlFieldName = MR_SSBM27 ];

/// MR_SSJB27
Property MRSSJB27 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 555, SqlFieldName = MR_SSJB27 ];

/// MR_SSRQ27
Property MRSSRQ27 As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 556, SqlFieldName = MR_SSRQ27 ];

/// MR_SSMC27
Property MRSSMC27 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 557, SqlFieldName = MR_SSMC27 ];

/// MR_SSCZYS27
Property MRSSCZYS27 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 558, SqlFieldName = MR_SSCZYS27 ];

/// MR_SSIZ27
Property MRSSIZ27 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 559, SqlFieldName = MR_SSIZ27 ];

/// MR_SSIIZ27
Property MRSSIIZ27 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 560, SqlFieldName = MR_SSIIZ27 ];

/// MR_SSMZFS27
Property MRSSMZFS27 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 561, SqlFieldName = MR_SSMZFS27 ];

/// MR_SSQKYHDJ27
Property MRSSQKYHDJ27 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 562, SqlFieldName = MR_SSQKYHDJ27 ];

/// MR_SSMZYS27
Property MRSSMZYS27 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 563, SqlFieldName = MR_SSMZYS27 ];

/// MR_SSSFZQ27
Property MRSSSFZQ27 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 564, SqlFieldName = MR_SSSFZQ27 ];

/// MR_SSBM28
Property MRSSBM28 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 565, SqlFieldName = MR_SSBM28 ];

/// MR_SSJB28
Property MRSSJB28 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 566, SqlFieldName = MR_SSJB28 ];

/// MR_SSRQ28
Property MRSSRQ28 As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 567, SqlFieldName = MR_SSRQ28 ];

/// MR_SSMC28
Property MRSSMC28 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 568, SqlFieldName = MR_SSMC28 ];

/// MR_SSCZYS28
Property MRSSCZYS28 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 569, SqlFieldName = MR_SSCZYS28 ];

/// MR_SSIZ28
Property MRSSIZ28 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 570, SqlFieldName = MR_SSIZ28 ];

/// MR_SSIIZ28
Property MRSSIIZ28 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 571, SqlFieldName = MR_SSIIZ28 ];

/// MR_SSMZFS28
Property MRSSMZFS28 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 572, SqlFieldName = MR_SSMZFS28 ];

/// MR_SSQKYHDJ28
Property MRSSQKYHDJ28 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 573, SqlFieldName = MR_SSQKYHDJ28 ];

/// MR_SSMZYS28
Property MRSSMZYS28 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 574, SqlFieldName = MR_SSMZYS28 ];

/// MR_SSSFZQ28
Property MRSSSFZQ28 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 575, SqlFieldName = MR_SSSFZQ28 ];

/// MR_SSBM29
Property MRSSBM29 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 576, SqlFieldName = MR_SSBM29 ];

/// MR_SSJB29
Property MRSSJB29 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 577, SqlFieldName = MR_SSJB29 ];

/// MR_SSRQ29
Property MRSSRQ29 As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 578, SqlFieldName = MR_SSRQ29 ];

/// MR_SSMC29
Property MRSSMC29 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 579, SqlFieldName = MR_SSMC29 ];

/// MR_SSCZYS29
Property MRSSCZYS29 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 580, SqlFieldName = MR_SSCZYS29 ];

/// MR_SSIZ29
Property MRSSIZ29 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 581, SqlFieldName = MR_SSIZ29 ];

/// MR_SSIIZ29
Property MRSSIIZ29 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 582, SqlFieldName = MR_SSIIZ29 ];

/// MR_SSMZFS29
Property MRSSMZFS29 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 583, SqlFieldName = MR_SSMZFS29 ];

/// MR_SSQKYHDJ29
Property MRSSQKYHDJ29 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 584, SqlFieldName = MR_SSQKYHDJ29 ];

/// MR_SSMZYS29
Property MRSSMZYS29 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 585, SqlFieldName = MR_SSMZYS29 ];

/// MR_SSSFZQ29
Property MRSSSFZQ29 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 586, SqlFieldName = MR_SSSFZQ29 ];

/// MR_SSBM30
Property MRSSBM30 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 587, SqlFieldName = MR_SSBM30 ];

/// MR_SSJB30
Property MRSSJB30 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 588, SqlFieldName = MR_SSJB30 ];

/// MR_SSRQ30
Property MRSSRQ30 As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 589, SqlFieldName = MR_SSRQ30 ];

/// MR_SSMC30
Property MRSSMC30 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 590, SqlFieldName = MR_SSMC30 ];

/// MR_SSCZYS30
Property MRSSCZYS30 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 591, SqlFieldName = MR_SSCZYS30 ];

/// MR_SSIZ30
Property MRSSIZ30 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 592, SqlFieldName = MR_SSIZ30 ];

/// MR_SSIIZ30
Property MRSSIIZ30 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 593, SqlFieldName = MR_SSIIZ30 ];

/// MR_SSMZFS30
Property MRSSMZFS30 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 594, SqlFieldName = MR_SSMZFS30 ];

/// MR_SSQKYHDJ30
Property MRSSQKYHDJ30 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 595, SqlFieldName = MR_SSQKYHDJ30 ];

/// MR_SSMZYS30
Property MRSSMZYS30 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 596, SqlFieldName = MR_SSMZYS30 ];

/// MR_SSSFZQ30
Property MRSSSFZQ30 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 597, SqlFieldName = MR_SSSFZQ30 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCMRInfo(0))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="MR_ADM">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MR_BAFX">
<Delimiter>"^"</Delimiter>
<Piece>291</Piece>
</Data>
<Data name="MR_BAH">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MR_BAZL">
<Delimiter>"^"</Delimiter>
<Piece>277</Piece>
</Data>
<Data name="MR_BDBLZPF">
<Delimiter>"^"</Delimiter>
<Piece>253</Piece>
</Data>
<Data name="MR_BLH">
<Delimiter>"^"</Delimiter>
<Piece>263</Piece>
</Data>
<Data name="MR_BLZD">
<Delimiter>"^"</Delimiter>
<Piece>261</Piece>
</Data>
<Data name="MR_BLZDBM">
<Delimiter>"^"</Delimiter>
<Piece>262</Piece>
</Data>
<Data name="MR_BLZDF">
<Delimiter>"^"</Delimiter>
<Piece>237</Piece>
</Data>
<Data name="MR_BMY">
<Delimiter>"^"</Delimiter>
<Piece>276</Piece>
</Data>
<Data name="MR_BYXJC">
<Delimiter>"^"</Delimiter>
<Piece>333</Piece>
</Data>
<Data name="MR_BZZSNN">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="MR_CFCS">
<Delimiter>"^"</Delimiter>
<Piece>328</Piece>
</Data>
<Data name="MR_CSD">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="MR_CSRQ">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="MR_CYBF">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="MR_CYKB">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="MR_CYQTZD1">
<Delimiter>"^"</Delimiter>
<Piece>56</Piece>
</Data>
<Data name="MR_CYQTZD10">
<Delimiter>"^"</Delimiter>
<Piece>92</Piece>
</Data>
<Data name="MR_CYQTZD11">
<Delimiter>"^"</Delimiter>
<Piece>96</Piece>
</Data>
<Data name="MR_CYQTZD12">
<Delimiter>"^"</Delimiter>
<Piece>100</Piece>
</Data>
<Data name="MR_CYQTZD13">
<Delimiter>"^"</Delimiter>
<Piece>104</Piece>
</Data>
<Data name="MR_CYQTZD14">
<Delimiter>"^"</Delimiter>
<Piece>108</Piece>
</Data>
<Data name="MR_CYQTZD15">
<Delimiter>"^"</Delimiter>
<Piece>112</Piece>
</Data>
<Data name="MR_CYQTZD16">
<Delimiter>"^"</Delimiter>
<Piece>353</Piece>
</Data>
<Data name="MR_CYQTZD17">
<Delimiter>"^"</Delimiter>
<Piece>357</Piece>
</Data>
<Data name="MR_CYQTZD18">
<Delimiter>"^"</Delimiter>
<Piece>361</Piece>
</Data>
<Data name="MR_CYQTZD19">
<Delimiter>"^"</Delimiter>
<Piece>365</Piece>
</Data>
<Data name="MR_CYQTZD2">
<Delimiter>"^"</Delimiter>
<Piece>60</Piece>
</Data>
<Data name="MR_CYQTZD20">
<Delimiter>"^"</Delimiter>
<Piece>369</Piece>
</Data>
<Data name="MR_CYQTZD21">
<Delimiter>"^"</Delimiter>
<Piece>373</Piece>
</Data>
<Data name="MR_CYQTZD3">
<Delimiter>"^"</Delimiter>
<Piece>64</Piece>
</Data>
<Data name="MR_CYQTZD4">
<Delimiter>"^"</Delimiter>
<Piece>68</Piece>
</Data>
<Data name="MR_CYQTZD5">
<Delimiter>"^"</Delimiter>
<Piece>72</Piece>
</Data>
<Data name="MR_CYQTZD6">
<Delimiter>"^"</Delimiter>
<Piece>76</Piece>
</Data>
<Data name="MR_CYQTZD7">
<Delimiter>"^"</Delimiter>
<Piece>80</Piece>
</Data>
<Data name="MR_CYQTZD8">
<Delimiter>"^"</Delimiter>
<Piece>84</Piece>
</Data>
<Data name="MR_CYQTZD9">
<Delimiter>"^"</Delimiter>
<Piece>88</Piece>
</Data>
<Data name="MR_CYQTZDMC1">
<Delimiter>"^"</Delimiter>
<Piece>57</Piece>
</Data>
<Data name="MR_CYQTZDMC10">
<Delimiter>"^"</Delimiter>
<Piece>93</Piece>
</Data>
<Data name="MR_CYQTZDMC11">
<Delimiter>"^"</Delimiter>
<Piece>97</Piece>
</Data>
<Data name="MR_CYQTZDMC12">
<Delimiter>"^"</Delimiter>
<Piece>101</Piece>
</Data>
<Data name="MR_CYQTZDMC13">
<Delimiter>"^"</Delimiter>
<Piece>105</Piece>
</Data>
<Data name="MR_CYQTZDMC14">
<Delimiter>"^"</Delimiter>
<Piece>109</Piece>
</Data>
<Data name="MR_CYQTZDMC15">
<Delimiter>"^"</Delimiter>
<Piece>113</Piece>
</Data>
<Data name="MR_CYQTZDMC16">
<Delimiter>"^"</Delimiter>
<Piece>354</Piece>
</Data>
<Data name="MR_CYQTZDMC17">
<Delimiter>"^"</Delimiter>
<Piece>358</Piece>
</Data>
<Data name="MR_CYQTZDMC18">
<Delimiter>"^"</Delimiter>
<Piece>362</Piece>
</Data>
<Data name="MR_CYQTZDMC19">
<Delimiter>"^"</Delimiter>
<Piece>366</Piece>
</Data>
<Data name="MR_CYQTZDMC2">
<Delimiter>"^"</Delimiter>
<Piece>61</Piece>
</Data>
<Data name="MR_CYQTZDMC20">
<Delimiter>"^"</Delimiter>
<Piece>370</Piece>
</Data>
<Data name="MR_CYQTZDMC21">
<Delimiter>"^"</Delimiter>
<Piece>374</Piece>
</Data>
<Data name="MR_CYQTZDMC3">
<Delimiter>"^"</Delimiter>
<Piece>65</Piece>
</Data>
<Data name="MR_CYQTZDMC4">
<Delimiter>"^"</Delimiter>
<Piece>69</Piece>
</Data>
<Data name="MR_CYQTZDMC5">
<Delimiter>"^"</Delimiter>
<Piece>73</Piece>
</Data>
<Data name="MR_CYQTZDMC6">
<Delimiter>"^"</Delimiter>
<Piece>77</Piece>
</Data>
<Data name="MR_CYQTZDMC7">
<Delimiter>"^"</Delimiter>
<Piece>81</Piece>
</Data>
<Data name="MR_CYQTZDMC8">
<Delimiter>"^"</Delimiter>
<Piece>85</Piece>
</Data>
<Data name="MR_CYQTZDMC9">
<Delimiter>"^"</Delimiter>
<Piece>89</Piece>
</Data>
<Data name="MR_CYQTZDRYBQ1">
<Delimiter>"^"</Delimiter>
<Piece>58</Piece>
</Data>
<Data name="MR_CYQTZDRYBQ10">
<Delimiter>"^"</Delimiter>
<Piece>94</Piece>
</Data>
<Data name="MR_CYQTZDRYBQ11">
<Delimiter>"^"</Delimiter>
<Piece>98</Piece>
</Data>
<Data name="MR_CYQTZDRYBQ12">
<Delimiter>"^"</Delimiter>
<Piece>102</Piece>
</Data>
<Data name="MR_CYQTZDRYBQ13">
<Delimiter>"^"</Delimiter>
<Piece>106</Piece>
</Data>
<Data name="MR_CYQTZDRYBQ14">
<Delimiter>"^"</Delimiter>
<Piece>110</Piece>
</Data>
<Data name="MR_CYQTZDRYBQ15">
<Delimiter>"^"</Delimiter>
<Piece>114</Piece>
</Data>
<Data name="MR_CYQTZDRYBQ16">
<Delimiter>"^"</Delimiter>
<Piece>355</Piece>
</Data>
<Data name="MR_CYQTZDRYBQ17">
<Delimiter>"^"</Delimiter>
<Piece>359</Piece>
</Data>
<Data name="MR_CYQTZDRYBQ18">
<Delimiter>"^"</Delimiter>
<Piece>363</Piece>
</Data>
<Data name="MR_CYQTZDRYBQ19">
<Delimiter>"^"</Delimiter>
<Piece>367</Piece>
</Data>
<Data name="MR_CYQTZDRYBQ2">
<Delimiter>"^"</Delimiter>
<Piece>62</Piece>
</Data>
<Data name="MR_CYQTZDRYBQ20">
<Delimiter>"^"</Delimiter>
<Piece>371</Piece>
</Data>
<Data name="MR_CYQTZDRYBQ21">
<Delimiter>"^"</Delimiter>
<Piece>375</Piece>
</Data>
<Data name="MR_CYQTZDRYBQ3">
<Delimiter>"^"</Delimiter>
<Piece>66</Piece>
</Data>
<Data name="MR_CYQTZDRYBQ4">
<Delimiter>"^"</Delimiter>
<Piece>70</Piece>
</Data>
<Data name="MR_CYQTZDRYBQ5">
<Delimiter>"^"</Delimiter>
<Piece>74</Piece>
</Data>
<Data name="MR_CYQTZDRYBQ6">
<Delimiter>"^"</Delimiter>
<Piece>78</Piece>
</Data>
<Data name="MR_CYQTZDRYBQ7">
<Delimiter>"^"</Delimiter>
<Piece>82</Piece>
</Data>
<Data name="MR_CYQTZDRYBQ8">
<Delimiter>"^"</Delimiter>
<Piece>86</Piece>
</Data>
<Data name="MR_CYQTZDRYBQ9">
<Delimiter>"^"</Delimiter>
<Piece>90</Piece>
</Data>
<Data name="MR_CYQTZDZLJG1">
<Delimiter>"^"</Delimiter>
<Piece>59</Piece>
</Data>
<Data name="MR_CYQTZDZLJG10">
<Delimiter>"^"</Delimiter>
<Piece>95</Piece>
</Data>
<Data name="MR_CYQTZDZLJG11">
<Delimiter>"^"</Delimiter>
<Piece>99</Piece>
</Data>
<Data name="MR_CYQTZDZLJG12">
<Delimiter>"^"</Delimiter>
<Piece>103</Piece>
</Data>
<Data name="MR_CYQTZDZLJG13">
<Delimiter>"^"</Delimiter>
<Piece>107</Piece>
</Data>
<Data name="MR_CYQTZDZLJG14">
<Delimiter>"^"</Delimiter>
<Piece>111</Piece>
</Data>
<Data name="MR_CYQTZDZLJG15">
<Delimiter>"^"</Delimiter>
<Piece>115</Piece>
</Data>
<Data name="MR_CYQTZDZLJG16">
<Delimiter>"^"</Delimiter>
<Piece>356</Piece>
</Data>
<Data name="MR_CYQTZDZLJG17">
<Delimiter>"^"</Delimiter>
<Piece>360</Piece>
</Data>
<Data name="MR_CYQTZDZLJG18">
<Delimiter>"^"</Delimiter>
<Piece>364</Piece>
</Data>
<Data name="MR_CYQTZDZLJG19">
<Delimiter>"^"</Delimiter>
<Piece>368</Piece>
</Data>
<Data name="MR_CYQTZDZLJG2">
<Delimiter>"^"</Delimiter>
<Piece>63</Piece>
</Data>
<Data name="MR_CYQTZDZLJG20">
<Delimiter>"^"</Delimiter>
<Piece>372</Piece>
</Data>
<Data name="MR_CYQTZDZLJG21">
<Delimiter>"^"</Delimiter>
<Piece>376</Piece>
</Data>
<Data name="MR_CYQTZDZLJG3">
<Delimiter>"^"</Delimiter>
<Piece>67</Piece>
</Data>
<Data name="MR_CYQTZDZLJG4">
<Delimiter>"^"</Delimiter>
<Piece>71</Piece>
</Data>
<Data name="MR_CYQTZDZLJG5">
<Delimiter>"^"</Delimiter>
<Piece>75</Piece>
</Data>
<Data name="MR_CYQTZDZLJG6">
<Delimiter>"^"</Delimiter>
<Piece>79</Piece>
</Data>
<Data name="MR_CYQTZDZLJG7">
<Delimiter>"^"</Delimiter>
<Piece>83</Piece>
</Data>
<Data name="MR_CYQTZDZLJG8">
<Delimiter>"^"</Delimiter>
<Piece>87</Piece>
</Data>
<Data name="MR_CYQTZDZLJG9">
<Delimiter>"^"</Delimiter>
<Piece>91</Piece>
</Data>
<Data name="MR_CYRQ">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="MR_CYZYZD">
<Delimiter>"^"</Delimiter>
<Piece>52</Piece>
</Data>
<Data name="MR_CYZYZDMC">
<Delimiter>"^"</Delimiter>
<Piece>53</Piece>
</Data>
<Data name="MR_CYZYZDRYBQ">
<Delimiter>"^"</Delimiter>
<Piece>54</Piece>
</Data>
<Data name="MR_CYZYZDZLJG">
<Delimiter>"^"</Delimiter>
<Piece>55</Piece>
</Data>
<Data name="MR_EJHLTS">
<Delimiter>"^"</Delimiter>
<Piece>319</Piece>
</Data>
<Data name="MR_FEXZLSQSHZDFH">
<Delimiter>"^"</Delimiter>
<Piece>347</Piece>
</Data>
<Data name="MR_FSBLZDFHQK">
<Delimiter>"^"</Delimiter>
<Piece>343</Piece>
</Data>
<Data name="MR_FSSZLXMF">
<Delimiter>"^"</Delimiter>
<Piece>241</Piece>
</Data>
<Data name="MR_GEXZLSQSHZDFH">
<Delimiter>"^"</Delimiter>
<Piece>346</Piece>
</Data>
<Data name="MR_GJ">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="MR_GZDWDH">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="MR_GZDWDZ">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="MR_GZDWYB">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="MR_HKDZ">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="MR_HKYB">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="MR_HLF">
<Delimiter>"^"</Delimiter>
<Piece>235</Piece>
</Data>
<Data name="MR_HXB">
<Delimiter>"^"</Delimiter>
<Piece>306</Piece>
</Data>
<Data name="MR_HY">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="MR_JCEXZLSQSHZDFH">
<Delimiter>"^"</Delimiter>
<Piece>350</Piece>
</Data>
<Data name="MR_JCYYCXYYCLF">
<Delimiter>"^"</Delimiter>
<Piece>255</Piece>
</Data>
<Data name="MR_JG">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="MR_JHSJRRQSJ">
<Delimiter>"^"</Delimiter>
<Piece>293</Piece>
</Data>
<Data name="MR_JHSTCRQSJ">
<Delimiter>"^"</Delimiter>
<Piece>294</Piece>
</Data>
<Data name="MR_JKKH">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MR_JXYS">
<Delimiter>"^"</Delimiter>
<Piece>274</Piece>
</Data>
<Data name="MR_KFF">
<Delimiter>"^"</Delimiter>
<Piece>246</Piece>
</Data>
<Data name="MR_KJYWFY">
<Delimiter>"^"</Delimiter>
<Piece>249</Piece>
</Data>
<Data name="MR_KZR">
<Delimiter>"^"</Delimiter>
<Piece>269</Piece>
</Data>
<Data name="MR_LCBLZDFHQK">
<Delimiter>"^"</Delimiter>
<Piece>342</Piece>
</Data>
<Data name="MR_LCWLZLF">
<Delimiter>"^"</Delimiter>
<Piece>242</Piece>
</Data>
<Data name="MR_LCZDXMF">
<Delimiter>"^"</Delimiter>
<Piece>240</Piece>
</Data>
<Data name="MR_LHSYKSSYW">
<Delimiter>"^"</Delimiter>
<Piece>301</Piece>
</Data>
<Data name="MR_LNSSRYHHMSJF">
<Delimiter>"^"</Delimiter>
<Piece>290</Piece>
</Data>
<Data name="MR_LNSSRYHHMSJS">
<Delimiter>"^"</Delimiter>
<Piece>289</Piece>
</Data>
<Data name="MR_LNSSRYHHMSJT">
<Delimiter>"^"</Delimiter>
<Piece>288</Piece>
</Data>
<Data name="MR_LNSSRYQHMSJF">
<Delimiter>"^"</Delimiter>
<Piece>287</Piece>
</Data>
<Data name="MR_LNSSRYQHMSJS">
<Delimiter>"^"</Delimiter>
<Piece>286</Piece>
</Data>
<Data name="MR_LNSSRYQHMSJT">
<Delimiter>"^"</Delimiter>
<Piece>285</Piece>
</Data>
<Data name="MR_LXRDH">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="MR_LXRDZ">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="MR_LXRGX">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="MR_LXRXM">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="MR_LXYZLZPF">
<Delimiter>"^"</Delimiter>
<Piece>351</Piece>
</Data>
<Data name="MR_LYFS">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="MR_LYFSYLJSJGMC">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="MR_MJZZDJBBM">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="MR_MJZZDMC">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="MR_MRDate">
<Delimiter>"^"</Delimiter>
<Piece>281</Piece>
</Data>
<Data name="MR_MZ">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="MR_MZF">
<Delimiter>"^"</Delimiter>
<Piece>244</Piece>
</Data>
<Data name="MR_MZRYZDFHQK">
<Delimiter>"^"</Delimiter>
<Piece>339</Piece>
</Data>
<Data name="MR_NN">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="MR_PAPMIDR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MR_QDBLZPF">
<Delimiter>"^"</Delimiter>
<Piece>254</Piece>
</Data>
<Data name="MR_QJCGCS">
<Delimiter>"^"</Delimiter>
<Piece>230</Piece>
</Data>
<Data name="MR_QJCS">
<Delimiter>"^"</Delimiter>
<Piece>229</Piece>
</Data>
<Data name="MR_QTF">
<Delimiter>"^"</Delimiter>
<Piece>258</Piece>
</Data>
<Data name="MR_QTFY">
<Delimiter>"^"</Delimiter>
<Piece>236</Piece>
</Data>
<Data name="MR_QX">
<Delimiter>"^"</Delimiter>
<Piece>309</Piece>
</Data>
<Data name="MR_RH">
<Delimiter>"^"</Delimiter>
<Piece>268</Piece>
</Data>
<Data name="MR_RYBF">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="MR_RYBQ">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="MR_RYCYZDFHQK">
<Delimiter>"^"</Delimiter>
<Piece>340</Piece>
</Data>
<Data name="MR_RYHQZRQ">
<Delimiter>"^"</Delimiter>
<Piece>51</Piece>
</Data>
<Data name="MR_RYKB">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="MR_RYRQ">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="MR_RYTJ">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="MR_RYZD">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="MR_RYZDMC">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="MR_RYZDRYBQ">
<Delimiter>"^"</Delimiter>
<Piece>50</Piece>
</Data>
<Data name="MR_SEXZLSQSHZDFH">
<Delimiter>"^"</Delimiter>
<Piece>345</Piece>
</Data>
<Data name="MR_SFCFSSS">
<Delimiter>"^"</Delimiter>
<Piece>324</Piece>
</Data>
<Data name="MR_SFDBZGL">
<Delimiter>"^"</Delimiter>
<Piece>295</Piece>
</Data>
<Data name="MR_SFFDCRB">
<Delimiter>"^"</Delimiter>
<Piece>303</Piece>
</Data>
<Data name="MR_SFFSRC">
<Delimiter>"^"</Delimiter>
<Piece>310</Piece>
</Data>
<Data name="MR_SFFSYLCC">
<Delimiter>"^"</Delimiter>
<Piece>312</Piece>
</Data>
<Data name="MR_SFFSYLSG">
<Delimiter>"^"</Delimiter>
<Piece>311</Piece>
</Data>
<Data name="MR_SFLHSYKSS">
<Delimiter>"^"</Delimiter>
<Piece>300</Piece>
</Data>
<Data name="MR_SFSSDGL">
<Delimiter>"^"</Delimiter>
<Piece>297</Piece>
</Data>
<Data name="MR_SFSSLCLJGL">
<Delimiter>"^"</Delimiter>
<Piece>296</Piece>
</Data>
<Data name="MR_SFSSZZJH">
<Delimiter>"^"</Delimiter>
<Piece>292</Piece>
</Data>
<Data name="MR_SFSX">
<Delimiter>"^"</Delimiter>
<Piece>322</Piece>
</Data>
<Data name="MR_SFSY">
<Delimiter>"^"</Delimiter>
<Piece>325</Piece>
</Data>
<Data name="MR_SFSYKSS">
<Delimiter>"^"</Delimiter>
<Piece>298</Piece>
</Data>
<Data name="MR_SFSZ">
<Delimiter>"^"</Delimiter>
<Piece>313</Piece>
</Data>
<Data name="MR_SFTBZZZY">
<Delimiter>"^"</Delimiter>
<Piece>284</Piece>
</Data>
<Data name="MR_SFXJPYBBSJ">
<Delimiter>"^"</Delimiter>
<Piece>302</Piece>
</Data>
<Data name="MR_SFYNFSDDHZCSJ">
<Delimiter>"^"</Delimiter>
<Piece>337</Piece>
</Data>
<Data name="MR_SFZH">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="MR_SHCD">
<Delimiter>"^"</Delimiter>
<Piece>338</Piece>
</Data>
<Data name="MR_SJHLTS">
<Delimiter>"^"</Delimiter>
<Piece>320</Piece>
</Data>
<Data name="MR_SJZYTS">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="MR_SQSHZDFHQK">
<Delimiter>"^"</Delimiter>
<Piece>341</Piece>
</Data>
<Data name="MR_SSBDSLBLZDFH">
<Delimiter>"^"</Delimiter>
<Piece>344</Piece>
</Data>
<Data name="MR_SSBFZ">
<Delimiter>"^"</Delimiter>
<Piece>334</Piece>
</Data>
<Data name="MR_SSBFZMC">
<Delimiter>"^"</Delimiter>
<Piece>335</Piece>
</Data>
<Data name="MR_SSBM1">
<Delimiter>"^"</Delimiter>
<Piece>119</Piece>
</Data>
<Data name="MR_SSBM10">
<Delimiter>"^"</Delimiter>
<Piece>218</Piece>
</Data>
<Data name="MR_SSBM11">
<Delimiter>"^"</Delimiter>
<Piece>377</Piece>
</Data>
<Data name="MR_SSBM12">
<Delimiter>"^"</Delimiter>
<Piece>388</Piece>
</Data>
<Data name="MR_SSBM13">
<Delimiter>"^"</Delimiter>
<Piece>399</Piece>
</Data>
<Data name="MR_SSBM14">
<Delimiter>"^"</Delimiter>
<Piece>410</Piece>
</Data>
<Data name="MR_SSBM15">
<Delimiter>"^"</Delimiter>
<Piece>421</Piece>
</Data>
<Data name="MR_SSBM16">
<Delimiter>"^"</Delimiter>
<Piece>432</Piece>
</Data>
<Data name="MR_SSBM17">
<Delimiter>"^"</Delimiter>
<Piece>443</Piece>
</Data>
<Data name="MR_SSBM18">
<Delimiter>"^"</Delimiter>
<Piece>454</Piece>
</Data>
<Data name="MR_SSBM19">
<Delimiter>"^"</Delimiter>
<Piece>465</Piece>
</Data>
<Data name="MR_SSBM2">
<Delimiter>"^"</Delimiter>
<Piece>130</Piece>
</Data>
<Data name="MR_SSBM20">
<Delimiter>"^"</Delimiter>
<Piece>476</Piece>
</Data>
<Data name="MR_SSBM21">
<Delimiter>"^"</Delimiter>
<Piece>487</Piece>
</Data>
<Data name="MR_SSBM22">
<Delimiter>"^"</Delimiter>
<Piece>498</Piece>
</Data>
<Data name="MR_SSBM23">
<Delimiter>"^"</Delimiter>
<Piece>509</Piece>
</Data>
<Data name="MR_SSBM24">
<Delimiter>"^"</Delimiter>
<Piece>520</Piece>
</Data>
<Data name="MR_SSBM25">
<Delimiter>"^"</Delimiter>
<Piece>531</Piece>
</Data>
<Data name="MR_SSBM26">
<Delimiter>"^"</Delimiter>
<Piece>542</Piece>
</Data>
<Data name="MR_SSBM27">
<Delimiter>"^"</Delimiter>
<Piece>553</Piece>
</Data>
<Data name="MR_SSBM28">
<Delimiter>"^"</Delimiter>
<Piece>564</Piece>
</Data>
<Data name="MR_SSBM29">
<Delimiter>"^"</Delimiter>
<Piece>575</Piece>
</Data>
<Data name="MR_SSBM3">
<Delimiter>"^"</Delimiter>
<Piece>141</Piece>
</Data>
<Data name="MR_SSBM30">
<Delimiter>"^"</Delimiter>
<Piece>586</Piece>
</Data>
<Data name="MR_SSBM4">
<Delimiter>"^"</Delimiter>
<Piece>152</Piece>
</Data>
<Data name="MR_SSBM5">
<Delimiter>"^"</Delimiter>
<Piece>163</Piece>
</Data>
<Data name="MR_SSBM6">
<Delimiter>"^"</Delimiter>
<Piece>174</Piece>
</Data>
<Data name="MR_SSBM7">
<Delimiter>"^"</Delimiter>
<Piece>185</Piece>
</Data>
<Data name="MR_SSBM8">
<Delimiter>"^"</Delimiter>
<Piece>196</Piece>
</Data>
<Data name="MR_SSBM9">
<Delimiter>"^"</Delimiter>
<Piece>207</Piece>
</Data>
<Data name="MR_SSCZYS1">
<Delimiter>"^"</Delimiter>
<Piece>123</Piece>
</Data>
<Data name="MR_SSCZYS10">
<Delimiter>"^"</Delimiter>
<Piece>222</Piece>
</Data>
<Data name="MR_SSCZYS11">
<Delimiter>"^"</Delimiter>
<Piece>381</Piece>
</Data>
<Data name="MR_SSCZYS12">
<Delimiter>"^"</Delimiter>
<Piece>392</Piece>
</Data>
<Data name="MR_SSCZYS13">
<Delimiter>"^"</Delimiter>
<Piece>403</Piece>
</Data>
<Data name="MR_SSCZYS14">
<Delimiter>"^"</Delimiter>
<Piece>414</Piece>
</Data>
<Data name="MR_SSCZYS15">
<Delimiter>"^"</Delimiter>
<Piece>425</Piece>
</Data>
<Data name="MR_SSCZYS16">
<Delimiter>"^"</Delimiter>
<Piece>436</Piece>
</Data>
<Data name="MR_SSCZYS17">
<Delimiter>"^"</Delimiter>
<Piece>447</Piece>
</Data>
<Data name="MR_SSCZYS18">
<Delimiter>"^"</Delimiter>
<Piece>458</Piece>
</Data>
<Data name="MR_SSCZYS19">
<Delimiter>"^"</Delimiter>
<Piece>469</Piece>
</Data>
<Data name="MR_SSCZYS2">
<Delimiter>"^"</Delimiter>
<Piece>134</Piece>
</Data>
<Data name="MR_SSCZYS20">
<Delimiter>"^"</Delimiter>
<Piece>480</Piece>
</Data>
<Data name="MR_SSCZYS21">
<Delimiter>"^"</Delimiter>
<Piece>491</Piece>
</Data>
<Data name="MR_SSCZYS22">
<Delimiter>"^"</Delimiter>
<Piece>502</Piece>
</Data>
<Data name="MR_SSCZYS23">
<Delimiter>"^"</Delimiter>
<Piece>513</Piece>
</Data>
<Data name="MR_SSCZYS24">
<Delimiter>"^"</Delimiter>
<Piece>524</Piece>
</Data>
<Data name="MR_SSCZYS25">
<Delimiter>"^"</Delimiter>
<Piece>535</Piece>
</Data>
<Data name="MR_SSCZYS26">
<Delimiter>"^"</Delimiter>
<Piece>546</Piece>
</Data>
<Data name="MR_SSCZYS27">
<Delimiter>"^"</Delimiter>
<Piece>557</Piece>
</Data>
<Data name="MR_SSCZYS28">
<Delimiter>"^"</Delimiter>
<Piece>568</Piece>
</Data>
<Data name="MR_SSCZYS29">
<Delimiter>"^"</Delimiter>
<Piece>579</Piece>
</Data>
<Data name="MR_SSCZYS3">
<Delimiter>"^"</Delimiter>
<Piece>145</Piece>
</Data>
<Data name="MR_SSCZYS30">
<Delimiter>"^"</Delimiter>
<Piece>590</Piece>
</Data>
<Data name="MR_SSCZYS4">
<Delimiter>"^"</Delimiter>
<Piece>156</Piece>
</Data>
<Data name="MR_SSCZYS5">
<Delimiter>"^"</Delimiter>
<Piece>167</Piece>
</Data>
<Data name="MR_SSCZYS6">
<Delimiter>"^"</Delimiter>
<Piece>178</Piece>
</Data>
<Data name="MR_SSCZYS7">
<Delimiter>"^"</Delimiter>
<Piece>189</Piece>
</Data>
<Data name="MR_SSCZYS8">
<Delimiter>"^"</Delimiter>
<Piece>200</Piece>
</Data>
<Data name="MR_SSCZYS9">
<Delimiter>"^"</Delimiter>
<Piece>211</Piece>
</Data>
<Data name="MR_SSF">
<Delimiter>"^"</Delimiter>
<Piece>245</Piece>
</Data>
<Data name="MR_SSIIZ1">
<Delimiter>"^"</Delimiter>
<Piece>125</Piece>
</Data>
<Data name="MR_SSIIZ10">
<Delimiter>"^"</Delimiter>
<Piece>224</Piece>
</Data>
<Data name="MR_SSIIZ11">
<Delimiter>"^"</Delimiter>
<Piece>383</Piece>
</Data>
<Data name="MR_SSIIZ12">
<Delimiter>"^"</Delimiter>
<Piece>394</Piece>
</Data>
<Data name="MR_SSIIZ13">
<Delimiter>"^"</Delimiter>
<Piece>405</Piece>
</Data>
<Data name="MR_SSIIZ14">
<Delimiter>"^"</Delimiter>
<Piece>416</Piece>
</Data>
<Data name="MR_SSIIZ15">
<Delimiter>"^"</Delimiter>
<Piece>427</Piece>
</Data>
<Data name="MR_SSIIZ16">
<Delimiter>"^"</Delimiter>
<Piece>438</Piece>
</Data>
<Data name="MR_SSIIZ17">
<Delimiter>"^"</Delimiter>
<Piece>449</Piece>
</Data>
<Data name="MR_SSIIZ18">
<Delimiter>"^"</Delimiter>
<Piece>460</Piece>
</Data>
<Data name="MR_SSIIZ19">
<Delimiter>"^"</Delimiter>
<Piece>471</Piece>
</Data>
<Data name="MR_SSIIZ2">
<Delimiter>"^"</Delimiter>
<Piece>136</Piece>
</Data>
<Data name="MR_SSIIZ20">
<Delimiter>"^"</Delimiter>
<Piece>482</Piece>
</Data>
<Data name="MR_SSIIZ21">
<Delimiter>"^"</Delimiter>
<Piece>493</Piece>
</Data>
<Data name="MR_SSIIZ22">
<Delimiter>"^"</Delimiter>
<Piece>504</Piece>
</Data>
<Data name="MR_SSIIZ23">
<Delimiter>"^"</Delimiter>
<Piece>515</Piece>
</Data>
<Data name="MR_SSIIZ24">
<Delimiter>"^"</Delimiter>
<Piece>526</Piece>
</Data>
<Data name="MR_SSIIZ25">
<Delimiter>"^"</Delimiter>
<Piece>537</Piece>
</Data>
<Data name="MR_SSIIZ26">
<Delimiter>"^"</Delimiter>
<Piece>548</Piece>
</Data>
<Data name="MR_SSIIZ27">
<Delimiter>"^"</Delimiter>
<Piece>559</Piece>
</Data>
<Data name="MR_SSIIZ28">
<Delimiter>"^"</Delimiter>
<Piece>570</Piece>
</Data>
<Data name="MR_SSIIZ29">
<Delimiter>"^"</Delimiter>
<Piece>581</Piece>
</Data>
<Data name="MR_SSIIZ3">
<Delimiter>"^"</Delimiter>
<Piece>147</Piece>
</Data>
<Data name="MR_SSIIZ30">
<Delimiter>"^"</Delimiter>
<Piece>592</Piece>
</Data>
<Data name="MR_SSIIZ4">
<Delimiter>"^"</Delimiter>
<Piece>158</Piece>
</Data>
<Data name="MR_SSIIZ5">
<Delimiter>"^"</Delimiter>
<Piece>169</Piece>
</Data>
<Data name="MR_SSIIZ6">
<Delimiter>"^"</Delimiter>
<Piece>180</Piece>
</Data>
<Data name="MR_SSIIZ7">
<Delimiter>"^"</Delimiter>
<Piece>191</Piece>
</Data>
<Data name="MR_SSIIZ8">
<Delimiter>"^"</Delimiter>
<Piece>202</Piece>
</Data>
<Data name="MR_SSIIZ9">
<Delimiter>"^"</Delimiter>
<Piece>213</Piece>
</Data>
<Data name="MR_SSIZ1">
<Delimiter>"^"</Delimiter>
<Piece>124</Piece>
</Data>
<Data name="MR_SSIZ10">
<Delimiter>"^"</Delimiter>
<Piece>223</Piece>
</Data>
<Data name="MR_SSIZ11">
<Delimiter>"^"</Delimiter>
<Piece>382</Piece>
</Data>
<Data name="MR_SSIZ12">
<Delimiter>"^"</Delimiter>
<Piece>393</Piece>
</Data>
<Data name="MR_SSIZ13">
<Delimiter>"^"</Delimiter>
<Piece>404</Piece>
</Data>
<Data name="MR_SSIZ14">
<Delimiter>"^"</Delimiter>
<Piece>415</Piece>
</Data>
<Data name="MR_SSIZ15">
<Delimiter>"^"</Delimiter>
<Piece>426</Piece>
</Data>
<Data name="MR_SSIZ16">
<Delimiter>"^"</Delimiter>
<Piece>437</Piece>
</Data>
<Data name="MR_SSIZ17">
<Delimiter>"^"</Delimiter>
<Piece>448</Piece>
</Data>
<Data name="MR_SSIZ18">
<Delimiter>"^"</Delimiter>
<Piece>459</Piece>
</Data>
<Data name="MR_SSIZ19">
<Delimiter>"^"</Delimiter>
<Piece>470</Piece>
</Data>
<Data name="MR_SSIZ2">
<Delimiter>"^"</Delimiter>
<Piece>135</Piece>
</Data>
<Data name="MR_SSIZ20">
<Delimiter>"^"</Delimiter>
<Piece>481</Piece>
</Data>
<Data name="MR_SSIZ21">
<Delimiter>"^"</Delimiter>
<Piece>492</Piece>
</Data>
<Data name="MR_SSIZ22">
<Delimiter>"^"</Delimiter>
<Piece>503</Piece>
</Data>
<Data name="MR_SSIZ23">
<Delimiter>"^"</Delimiter>
<Piece>514</Piece>
</Data>
<Data name="MR_SSIZ24">
<Delimiter>"^"</Delimiter>
<Piece>525</Piece>
</Data>
<Data name="MR_SSIZ25">
<Delimiter>"^"</Delimiter>
<Piece>536</Piece>
</Data>
<Data name="MR_SSIZ26">
<Delimiter>"^"</Delimiter>
<Piece>547</Piece>
</Data>
<Data name="MR_SSIZ27">
<Delimiter>"^"</Delimiter>
<Piece>558</Piece>
</Data>
<Data name="MR_SSIZ28">
<Delimiter>"^"</Delimiter>
<Piece>569</Piece>
</Data>
<Data name="MR_SSIZ29">
<Delimiter>"^"</Delimiter>
<Piece>580</Piece>
</Data>
<Data name="MR_SSIZ3">
<Delimiter>"^"</Delimiter>
<Piece>146</Piece>
</Data>
<Data name="MR_SSIZ30">
<Delimiter>"^"</Delimiter>
<Piece>591</Piece>
</Data>
<Data name="MR_SSIZ4">
<Delimiter>"^"</Delimiter>
<Piece>157</Piece>
</Data>
<Data name="MR_SSIZ5">
<Delimiter>"^"</Delimiter>
<Piece>168</Piece>
</Data>
<Data name="MR_SSIZ6">
<Delimiter>"^"</Delimiter>
<Piece>179</Piece>
</Data>
<Data name="MR_SSIZ7">
<Delimiter>"^"</Delimiter>
<Piece>190</Piece>
</Data>
<Data name="MR_SSIZ8">
<Delimiter>"^"</Delimiter>
<Piece>201</Piece>
</Data>
<Data name="MR_SSIZ9">
<Delimiter>"^"</Delimiter>
<Piece>212</Piece>
</Data>
<Data name="MR_SSJB1">
<Delimiter>"^"</Delimiter>
<Piece>120</Piece>
</Data>
<Data name="MR_SSJB10">
<Delimiter>"^"</Delimiter>
<Piece>219</Piece>
</Data>
<Data name="MR_SSJB11">
<Delimiter>"^"</Delimiter>
<Piece>378</Piece>
</Data>
<Data name="MR_SSJB12">
<Delimiter>"^"</Delimiter>
<Piece>389</Piece>
</Data>
<Data name="MR_SSJB13">
<Delimiter>"^"</Delimiter>
<Piece>400</Piece>
</Data>
<Data name="MR_SSJB14">
<Delimiter>"^"</Delimiter>
<Piece>411</Piece>
</Data>
<Data name="MR_SSJB15">
<Delimiter>"^"</Delimiter>
<Piece>422</Piece>
</Data>
<Data name="MR_SSJB16">
<Delimiter>"^"</Delimiter>
<Piece>433</Piece>
</Data>
<Data name="MR_SSJB17">
<Delimiter>"^"</Delimiter>
<Piece>444</Piece>
</Data>
<Data name="MR_SSJB18">
<Delimiter>"^"</Delimiter>
<Piece>455</Piece>
</Data>
<Data name="MR_SSJB19">
<Delimiter>"^"</Delimiter>
<Piece>466</Piece>
</Data>
<Data name="MR_SSJB2">
<Delimiter>"^"</Delimiter>
<Piece>131</Piece>
</Data>
<Data name="MR_SSJB20">
<Delimiter>"^"</Delimiter>
<Piece>477</Piece>
</Data>
<Data name="MR_SSJB21">
<Delimiter>"^"</Delimiter>
<Piece>488</Piece>
</Data>
<Data name="MR_SSJB22">
<Delimiter>"^"</Delimiter>
<Piece>499</Piece>
</Data>
<Data name="MR_SSJB23">
<Delimiter>"^"</Delimiter>
<Piece>510</Piece>
</Data>
<Data name="MR_SSJB24">
<Delimiter>"^"</Delimiter>
<Piece>521</Piece>
</Data>
<Data name="MR_SSJB25">
<Delimiter>"^"</Delimiter>
<Piece>532</Piece>
</Data>
<Data name="MR_SSJB26">
<Delimiter>"^"</Delimiter>
<Piece>543</Piece>
</Data>
<Data name="MR_SSJB27">
<Delimiter>"^"</Delimiter>
<Piece>554</Piece>
</Data>
<Data name="MR_SSJB28">
<Delimiter>"^"</Delimiter>
<Piece>565</Piece>
</Data>
<Data name="MR_SSJB29">
<Delimiter>"^"</Delimiter>
<Piece>576</Piece>
</Data>
<Data name="MR_SSJB3">
<Delimiter>"^"</Delimiter>
<Piece>142</Piece>
</Data>
<Data name="MR_SSJB30">
<Delimiter>"^"</Delimiter>
<Piece>587</Piece>
</Data>
<Data name="MR_SSJB4">
<Delimiter>"^"</Delimiter>
<Piece>153</Piece>
</Data>
<Data name="MR_SSJB5">
<Delimiter>"^"</Delimiter>
<Piece>164</Piece>
</Data>
<Data name="MR_SSJB6">
<Delimiter>"^"</Delimiter>
<Piece>175</Piece>
</Data>
<Data name="MR_SSJB7">
<Delimiter>"^"</Delimiter>
<Piece>186</Piece>
</Data>
<Data name="MR_SSJB8">
<Delimiter>"^"</Delimiter>
<Piece>197</Piece>
</Data>
<Data name="MR_SSJB9">
<Delimiter>"^"</Delimiter>
<Piece>208</Piece>
</Data>
<Data name="MR_SSMC1">
<Delimiter>"^"</Delimiter>
<Piece>122</Piece>
</Data>
<Data name="MR_SSMC10">
<Delimiter>"^"</Delimiter>
<Piece>221</Piece>
</Data>
<Data name="MR_SSMC11">
<Delimiter>"^"</Delimiter>
<Piece>380</Piece>
</Data>
<Data name="MR_SSMC12">
<Delimiter>"^"</Delimiter>
<Piece>391</Piece>
</Data>
<Data name="MR_SSMC13">
<Delimiter>"^"</Delimiter>
<Piece>402</Piece>
</Data>
<Data name="MR_SSMC14">
<Delimiter>"^"</Delimiter>
<Piece>413</Piece>
</Data>
<Data name="MR_SSMC15">
<Delimiter>"^"</Delimiter>
<Piece>424</Piece>
</Data>
<Data name="MR_SSMC16">
<Delimiter>"^"</Delimiter>
<Piece>435</Piece>
</Data>
<Data name="MR_SSMC17">
<Delimiter>"^"</Delimiter>
<Piece>446</Piece>
</Data>
<Data name="MR_SSMC18">
<Delimiter>"^"</Delimiter>
<Piece>457</Piece>
</Data>
<Data name="MR_SSMC19">
<Delimiter>"^"</Delimiter>
<Piece>468</Piece>
</Data>
<Data name="MR_SSMC2">
<Delimiter>"^"</Delimiter>
<Piece>133</Piece>
</Data>
<Data name="MR_SSMC20">
<Delimiter>"^"</Delimiter>
<Piece>479</Piece>
</Data>
<Data name="MR_SSMC21">
<Delimiter>"^"</Delimiter>
<Piece>490</Piece>
</Data>
<Data name="MR_SSMC22">
<Delimiter>"^"</Delimiter>
<Piece>501</Piece>
</Data>
<Data name="MR_SSMC23">
<Delimiter>"^"</Delimiter>
<Piece>512</Piece>
</Data>
<Data name="MR_SSMC24">
<Delimiter>"^"</Delimiter>
<Piece>523</Piece>
</Data>
<Data name="MR_SSMC25">
<Delimiter>"^"</Delimiter>
<Piece>534</Piece>
</Data>
<Data name="MR_SSMC26">
<Delimiter>"^"</Delimiter>
<Piece>545</Piece>
</Data>
<Data name="MR_SSMC27">
<Delimiter>"^"</Delimiter>
<Piece>556</Piece>
</Data>
<Data name="MR_SSMC28">
<Delimiter>"^"</Delimiter>
<Piece>567</Piece>
</Data>
<Data name="MR_SSMC29">
<Delimiter>"^"</Delimiter>
<Piece>578</Piece>
</Data>
<Data name="MR_SSMC3">
<Delimiter>"^"</Delimiter>
<Piece>144</Piece>
</Data>
<Data name="MR_SSMC30">
<Delimiter>"^"</Delimiter>
<Piece>589</Piece>
</Data>
<Data name="MR_SSMC4">
<Delimiter>"^"</Delimiter>
<Piece>155</Piece>
</Data>
<Data name="MR_SSMC5">
<Delimiter>"^"</Delimiter>
<Piece>166</Piece>
</Data>
<Data name="MR_SSMC6">
<Delimiter>"^"</Delimiter>
<Piece>177</Piece>
</Data>
<Data name="MR_SSMC7">
<Delimiter>"^"</Delimiter>
<Piece>188</Piece>
</Data>
<Data name="MR_SSMC8">
<Delimiter>"^"</Delimiter>
<Piece>199</Piece>
</Data>
<Data name="MR_SSMC9">
<Delimiter>"^"</Delimiter>
<Piece>210</Piece>
</Data>
<Data name="MR_SSMZFS1">
<Delimiter>"^"</Delimiter>
<Piece>126</Piece>
</Data>
<Data name="MR_SSMZFS10">
<Delimiter>"^"</Delimiter>
<Piece>225</Piece>
</Data>
<Data name="MR_SSMZFS11">
<Delimiter>"^"</Delimiter>
<Piece>384</Piece>
</Data>
<Data name="MR_SSMZFS12">
<Delimiter>"^"</Delimiter>
<Piece>395</Piece>
</Data>
<Data name="MR_SSMZFS13">
<Delimiter>"^"</Delimiter>
<Piece>406</Piece>
</Data>
<Data name="MR_SSMZFS14">
<Delimiter>"^"</Delimiter>
<Piece>417</Piece>
</Data>
<Data name="MR_SSMZFS15">
<Delimiter>"^"</Delimiter>
<Piece>428</Piece>
</Data>
<Data name="MR_SSMZFS16">
<Delimiter>"^"</Delimiter>
<Piece>439</Piece>
</Data>
<Data name="MR_SSMZFS17">
<Delimiter>"^"</Delimiter>
<Piece>450</Piece>
</Data>
<Data name="MR_SSMZFS18">
<Delimiter>"^"</Delimiter>
<Piece>461</Piece>
</Data>
<Data name="MR_SSMZFS19">
<Delimiter>"^"</Delimiter>
<Piece>472</Piece>
</Data>
<Data name="MR_SSMZFS2">
<Delimiter>"^"</Delimiter>
<Piece>137</Piece>
</Data>
<Data name="MR_SSMZFS20">
<Delimiter>"^"</Delimiter>
<Piece>483</Piece>
</Data>
<Data name="MR_SSMZFS21">
<Delimiter>"^"</Delimiter>
<Piece>494</Piece>
</Data>
<Data name="MR_SSMZFS22">
<Delimiter>"^"</Delimiter>
<Piece>505</Piece>
</Data>
<Data name="MR_SSMZFS23">
<Delimiter>"^"</Delimiter>
<Piece>516</Piece>
</Data>
<Data name="MR_SSMZFS24">
<Delimiter>"^"</Delimiter>
<Piece>527</Piece>
</Data>
<Data name="MR_SSMZFS25">
<Delimiter>"^"</Delimiter>
<Piece>538</Piece>
</Data>
<Data name="MR_SSMZFS26">
<Delimiter>"^"</Delimiter>
<Piece>549</Piece>
</Data>
<Data name="MR_SSMZFS27">
<Delimiter>"^"</Delimiter>
<Piece>560</Piece>
</Data>
<Data name="MR_SSMZFS28">
<Delimiter>"^"</Delimiter>
<Piece>571</Piece>
</Data>
<Data name="MR_SSMZFS29">
<Delimiter>"^"</Delimiter>
<Piece>582</Piece>
</Data>
<Data name="MR_SSMZFS3">
<Delimiter>"^"</Delimiter>
<Piece>148</Piece>
</Data>
<Data name="MR_SSMZFS30">
<Delimiter>"^"</Delimiter>
<Piece>593</Piece>
</Data>
<Data name="MR_SSMZFS4">
<Delimiter>"^"</Delimiter>
<Piece>159</Piece>
</Data>
<Data name="MR_SSMZFS5">
<Delimiter>"^"</Delimiter>
<Piece>170</Piece>
</Data>
<Data name="MR_SSMZFS6">
<Delimiter>"^"</Delimiter>
<Piece>181</Piece>
</Data>
<Data name="MR_SSMZFS7">
<Delimiter>"^"</Delimiter>
<Piece>192</Piece>
</Data>
<Data name="MR_SSMZFS8">
<Delimiter>"^"</Delimiter>
<Piece>203</Piece>
</Data>
<Data name="MR_SSMZFS9">
<Delimiter>"^"</Delimiter>
<Piece>214</Piece>
</Data>
<Data name="MR_SSMZYS1">
<Delimiter>"^"</Delimiter>
<Piece>128</Piece>
</Data>
<Data name="MR_SSMZYS10">
<Delimiter>"^"</Delimiter>
<Piece>227</Piece>
</Data>
<Data name="MR_SSMZYS11">
<Delimiter>"^"</Delimiter>
<Piece>386</Piece>
</Data>
<Data name="MR_SSMZYS12">
<Delimiter>"^"</Delimiter>
<Piece>397</Piece>
</Data>
<Data name="MR_SSMZYS13">
<Delimiter>"^"</Delimiter>
<Piece>408</Piece>
</Data>
<Data name="MR_SSMZYS14">
<Delimiter>"^"</Delimiter>
<Piece>419</Piece>
</Data>
<Data name="MR_SSMZYS15">
<Delimiter>"^"</Delimiter>
<Piece>430</Piece>
</Data>
<Data name="MR_SSMZYS16">
<Delimiter>"^"</Delimiter>
<Piece>441</Piece>
</Data>
<Data name="MR_SSMZYS17">
<Delimiter>"^"</Delimiter>
<Piece>452</Piece>
</Data>
<Data name="MR_SSMZYS18">
<Delimiter>"^"</Delimiter>
<Piece>463</Piece>
</Data>
<Data name="MR_SSMZYS19">
<Delimiter>"^"</Delimiter>
<Piece>474</Piece>
</Data>
<Data name="MR_SSMZYS2">
<Delimiter>"^"</Delimiter>
<Piece>139</Piece>
</Data>
<Data name="MR_SSMZYS20">
<Delimiter>"^"</Delimiter>
<Piece>485</Piece>
</Data>
<Data name="MR_SSMZYS21">
<Delimiter>"^"</Delimiter>
<Piece>496</Piece>
</Data>
<Data name="MR_SSMZYS22">
<Delimiter>"^"</Delimiter>
<Piece>507</Piece>
</Data>
<Data name="MR_SSMZYS23">
<Delimiter>"^"</Delimiter>
<Piece>518</Piece>
</Data>
<Data name="MR_SSMZYS24">
<Delimiter>"^"</Delimiter>
<Piece>529</Piece>
</Data>
<Data name="MR_SSMZYS25">
<Delimiter>"^"</Delimiter>
<Piece>540</Piece>
</Data>
<Data name="MR_SSMZYS26">
<Delimiter>"^"</Delimiter>
<Piece>551</Piece>
</Data>
<Data name="MR_SSMZYS27">
<Delimiter>"^"</Delimiter>
<Piece>562</Piece>
</Data>
<Data name="MR_SSMZYS28">
<Delimiter>"^"</Delimiter>
<Piece>573</Piece>
</Data>
<Data name="MR_SSMZYS29">
<Delimiter>"^"</Delimiter>
<Piece>584</Piece>
</Data>
<Data name="MR_SSMZYS3">
<Delimiter>"^"</Delimiter>
<Piece>150</Piece>
</Data>
<Data name="MR_SSMZYS30">
<Delimiter>"^"</Delimiter>
<Piece>595</Piece>
</Data>
<Data name="MR_SSMZYS4">
<Delimiter>"^"</Delimiter>
<Piece>161</Piece>
</Data>
<Data name="MR_SSMZYS5">
<Delimiter>"^"</Delimiter>
<Piece>172</Piece>
</Data>
<Data name="MR_SSMZYS6">
<Delimiter>"^"</Delimiter>
<Piece>183</Piece>
</Data>
<Data name="MR_SSMZYS7">
<Delimiter>"^"</Delimiter>
<Piece>194</Piece>
</Data>
<Data name="MR_SSMZYS8">
<Delimiter>"^"</Delimiter>
<Piece>205</Piece>
</Data>
<Data name="MR_SSMZYS9">
<Delimiter>"^"</Delimiter>
<Piece>216</Piece>
</Data>
<Data name="MR_SSQKYHDJ1">
<Delimiter>"^"</Delimiter>
<Piece>127</Piece>
</Data>
<Data name="MR_SSQKYHDJ10">
<Delimiter>"^"</Delimiter>
<Piece>226</Piece>
</Data>
<Data name="MR_SSQKYHDJ11">
<Delimiter>"^"</Delimiter>
<Piece>385</Piece>
</Data>
<Data name="MR_SSQKYHDJ12">
<Delimiter>"^"</Delimiter>
<Piece>396</Piece>
</Data>
<Data name="MR_SSQKYHDJ13">
<Delimiter>"^"</Delimiter>
<Piece>407</Piece>
</Data>
<Data name="MR_SSQKYHDJ14">
<Delimiter>"^"</Delimiter>
<Piece>418</Piece>
</Data>
<Data name="MR_SSQKYHDJ15">
<Delimiter>"^"</Delimiter>
<Piece>429</Piece>
</Data>
<Data name="MR_SSQKYHDJ16">
<Delimiter>"^"</Delimiter>
<Piece>440</Piece>
</Data>
<Data name="MR_SSQKYHDJ17">
<Delimiter>"^"</Delimiter>
<Piece>451</Piece>
</Data>
<Data name="MR_SSQKYHDJ18">
<Delimiter>"^"</Delimiter>
<Piece>462</Piece>
</Data>
<Data name="MR_SSQKYHDJ19">
<Delimiter>"^"</Delimiter>
<Piece>473</Piece>
</Data>
<Data name="MR_SSQKYHDJ2">
<Delimiter>"^"</Delimiter>
<Piece>138</Piece>
</Data>
<Data name="MR_SSQKYHDJ20">
<Delimiter>"^"</Delimiter>
<Piece>484</Piece>
</Data>
<Data name="MR_SSQKYHDJ21">
<Delimiter>"^"</Delimiter>
<Piece>495</Piece>
</Data>
<Data name="MR_SSQKYHDJ22">
<Delimiter>"^"</Delimiter>
<Piece>506</Piece>
</Data>
<Data name="MR_SSQKYHDJ23">
<Delimiter>"^"</Delimiter>
<Piece>517</Piece>
</Data>
<Data name="MR_SSQKYHDJ24">
<Delimiter>"^"</Delimiter>
<Piece>528</Piece>
</Data>
<Data name="MR_SSQKYHDJ25">
<Delimiter>"^"</Delimiter>
<Piece>539</Piece>
</Data>
<Data name="MR_SSQKYHDJ26">
<Delimiter>"^"</Delimiter>
<Piece>550</Piece>
</Data>
<Data name="MR_SSQKYHDJ27">
<Delimiter>"^"</Delimiter>
<Piece>561</Piece>
</Data>
<Data name="MR_SSQKYHDJ28">
<Delimiter>"^"</Delimiter>
<Piece>572</Piece>
</Data>
<Data name="MR_SSQKYHDJ29">
<Delimiter>"^"</Delimiter>
<Piece>583</Piece>
</Data>
<Data name="MR_SSQKYHDJ3">
<Delimiter>"^"</Delimiter>
<Piece>149</Piece>
</Data>
<Data name="MR_SSQKYHDJ30">
<Delimiter>"^"</Delimiter>
<Piece>594</Piece>
</Data>
<Data name="MR_SSQKYHDJ4">
<Delimiter>"^"</Delimiter>
<Piece>160</Piece>
</Data>
<Data name="MR_SSQKYHDJ5">
<Delimiter>"^"</Delimiter>
<Piece>171</Piece>
</Data>
<Data name="MR_SSQKYHDJ6">
<Delimiter>"^"</Delimiter>
<Piece>182</Piece>
</Data>
<Data name="MR_SSQKYHDJ7">
<Delimiter>"^"</Delimiter>
<Piece>193</Piece>
</Data>
<Data name="MR_SSQKYHDJ8">
<Delimiter>"^"</Delimiter>
<Piece>204</Piece>
</Data>
<Data name="MR_SSQKYHDJ9">
<Delimiter>"^"</Delimiter>
<Piece>215</Piece>
</Data>
<Data name="MR_SSRQ1">
<Delimiter>"^"</Delimiter>
<Piece>121</Piece>
</Data>
<Data name="MR_SSRQ10">
<Delimiter>"^"</Delimiter>
<Piece>220</Piece>
</Data>
<Data name="MR_SSRQ11">
<Delimiter>"^"</Delimiter>
<Piece>379</Piece>
</Data>
<Data name="MR_SSRQ12">
<Delimiter>"^"</Delimiter>
<Piece>390</Piece>
</Data>
<Data name="MR_SSRQ13">
<Delimiter>"^"</Delimiter>
<Piece>401</Piece>
</Data>
<Data name="MR_SSRQ14">
<Delimiter>"^"</Delimiter>
<Piece>412</Piece>
</Data>
<Data name="MR_SSRQ15">
<Delimiter>"^"</Delimiter>
<Piece>423</Piece>
</Data>
<Data name="MR_SSRQ16">
<Delimiter>"^"</Delimiter>
<Piece>434</Piece>
</Data>
<Data name="MR_SSRQ17">
<Delimiter>"^"</Delimiter>
<Piece>445</Piece>
</Data>
<Data name="MR_SSRQ18">
<Delimiter>"^"</Delimiter>
<Piece>456</Piece>
</Data>
<Data name="MR_SSRQ19">
<Delimiter>"^"</Delimiter>
<Piece>467</Piece>
</Data>
<Data name="MR_SSRQ2">
<Delimiter>"^"</Delimiter>
<Piece>132</Piece>
</Data>
<Data name="MR_SSRQ20">
<Delimiter>"^"</Delimiter>
<Piece>478</Piece>
</Data>
<Data name="MR_SSRQ21">
<Delimiter>"^"</Delimiter>
<Piece>489</Piece>
</Data>
<Data name="MR_SSRQ22">
<Delimiter>"^"</Delimiter>
<Piece>500</Piece>
</Data>
<Data name="MR_SSRQ23">
<Delimiter>"^"</Delimiter>
<Piece>511</Piece>
</Data>
<Data name="MR_SSRQ24">
<Delimiter>"^"</Delimiter>
<Piece>522</Piece>
</Data>
<Data name="MR_SSRQ25">
<Delimiter>"^"</Delimiter>
<Piece>533</Piece>
</Data>
<Data name="MR_SSRQ26">
<Delimiter>"^"</Delimiter>
<Piece>544</Piece>
</Data>
<Data name="MR_SSRQ27">
<Delimiter>"^"</Delimiter>
<Piece>555</Piece>
</Data>
<Data name="MR_SSRQ28">
<Delimiter>"^"</Delimiter>
<Piece>566</Piece>
</Data>
<Data name="MR_SSRQ29">
<Delimiter>"^"</Delimiter>
<Piece>577</Piece>
</Data>
<Data name="MR_SSRQ3">
<Delimiter>"^"</Delimiter>
<Piece>143</Piece>
</Data>
<Data name="MR_SSRQ30">
<Delimiter>"^"</Delimiter>
<Piece>588</Piece>
</Data>
<Data name="MR_SSRQ4">
<Delimiter>"^"</Delimiter>
<Piece>154</Piece>
</Data>
<Data name="MR_SSRQ5">
<Delimiter>"^"</Delimiter>
<Piece>165</Piece>
</Data>
<Data name="MR_SSRQ6">
<Delimiter>"^"</Delimiter>
<Piece>176</Piece>
</Data>
<Data name="MR_SSRQ7">
<Delimiter>"^"</Delimiter>
<Piece>187</Piece>
</Data>
<Data name="MR_SSRQ8">
<Delimiter>"^"</Delimiter>
<Piece>198</Piece>
</Data>
<Data name="MR_SSRQ9">
<Delimiter>"^"</Delimiter>
<Piece>209</Piece>
</Data>
<Data name="MR_SSSFZQ1">
<Delimiter>"^"</Delimiter>
<Piece>129</Piece>
</Data>
<Data name="MR_SSSFZQ10">
<Delimiter>"^"</Delimiter>
<Piece>228</Piece>
</Data>
<Data name="MR_SSSFZQ11">
<Delimiter>"^"</Delimiter>
<Piece>387</Piece>
</Data>
<Data name="MR_SSSFZQ12">
<Delimiter>"^"</Delimiter>
<Piece>398</Piece>
</Data>
<Data name="MR_SSSFZQ13">
<Delimiter>"^"</Delimiter>
<Piece>409</Piece>
</Data>
<Data name="MR_SSSFZQ14">
<Delimiter>"^"</Delimiter>
<Piece>420</Piece>
</Data>
<Data name="MR_SSSFZQ15">
<Delimiter>"^"</Delimiter>
<Piece>431</Piece>
</Data>
<Data name="MR_SSSFZQ16">
<Delimiter>"^"</Delimiter>
<Piece>442</Piece>
</Data>
<Data name="MR_SSSFZQ17">
<Delimiter>"^"</Delimiter>
<Piece>453</Piece>
</Data>
<Data name="MR_SSSFZQ18">
<Delimiter>"^"</Delimiter>
<Piece>464</Piece>
</Data>
<Data name="MR_SSSFZQ19">
<Delimiter>"^"</Delimiter>
<Piece>475</Piece>
</Data>
<Data name="MR_SSSFZQ2">
<Delimiter>"^"</Delimiter>
<Piece>140</Piece>
</Data>
<Data name="MR_SSSFZQ20">
<Delimiter>"^"</Delimiter>
<Piece>486</Piece>
</Data>
<Data name="MR_SSSFZQ21">
<Delimiter>"^"</Delimiter>
<Piece>497</Piece>
</Data>
<Data name="MR_SSSFZQ22">
<Delimiter>"^"</Delimiter>
<Piece>508</Piece>
</Data>
<Data name="MR_SSSFZQ23">
<Delimiter>"^"</Delimiter>
<Piece>519</Piece>
</Data>
<Data name="MR_SSSFZQ24">
<Delimiter>"^"</Delimiter>
<Piece>530</Piece>
</Data>
<Data name="MR_SSSFZQ25">
<Delimiter>"^"</Delimiter>
<Piece>541</Piece>
</Data>
<Data name="MR_SSSFZQ26">
<Delimiter>"^"</Delimiter>
<Piece>552</Piece>
</Data>
<Data name="MR_SSSFZQ27">
<Delimiter>"^"</Delimiter>
<Piece>563</Piece>
</Data>
<Data name="MR_SSSFZQ28">
<Delimiter>"^"</Delimiter>
<Piece>574</Piece>
</Data>
<Data name="MR_SSSFZQ29">
<Delimiter>"^"</Delimiter>
<Piece>585</Piece>
</Data>
<Data name="MR_SSSFZQ3">
<Delimiter>"^"</Delimiter>
<Piece>151</Piece>
</Data>
<Data name="MR_SSSFZQ30">
<Delimiter>"^"</Delimiter>
<Piece>596</Piece>
</Data>
<Data name="MR_SSSFZQ4">
<Delimiter>"^"</Delimiter>
<Piece>162</Piece>
</Data>
<Data name="MR_SSSFZQ5">
<Delimiter>"^"</Delimiter>
<Piece>173</Piece>
</Data>
<Data name="MR_SSSFZQ6">
<Delimiter>"^"</Delimiter>
<Piece>184</Piece>
</Data>
<Data name="MR_SSSFZQ7">
<Delimiter>"^"</Delimiter>
<Piece>195</Piece>
</Data>
<Data name="MR_SSSFZQ8">
<Delimiter>"^"</Delimiter>
<Piece>206</Piece>
</Data>
<Data name="MR_SSSFZQ9">
<Delimiter>"^"</Delimiter>
<Piece>217</Piece>
</Data>
<Data name="MR_SSYWYL">
<Delimiter>"^"</Delimiter>
<Piece>330</Piece>
</Data>
<Data name="MR_SSYYCXYYCLF">
<Delimiter>"^"</Delimiter>
<Piece>257</Piece>
</Data>
<Data name="MR_SSZDDJBBM">
<Delimiter>"^"</Delimiter>
<Piece>260</Piece>
</Data>
<Data name="MR_SSZDDWBYS">
<Delimiter>"^"</Delimiter>
<Piece>259</Piece>
</Data>
<Data name="MR_SSZLF">
<Delimiter>"^"</Delimiter>
<Piece>243</Piece>
</Data>
<Data name="MR_SWHZSJ">
<Delimiter>"^"</Delimiter>
<Piece>266</Piece>
</Data>
<Data name="MR_SWSFFSZWSSQN">
<Delimiter>"^"</Delimiter>
<Piece>336</Piece>
</Data>
<Data name="MR_SXFY">
<Delimiter>"^"</Delimiter>
<Piece>323</Piece>
</Data>
<Data name="MR_SYFY">
<Delimiter>"^"</Delimiter>
<Piece>326</Piece>
</Data>
<Data name="MR_SYKSSYW">
<Delimiter>"^"</Delimiter>
<Piece>299</Piece>
</Data>
<Data name="MR_SYSZDF">
<Delimiter>"^"</Delimiter>
<Piece>238</Piece>
</Data>
<Data name="MR_SZSJN">
<Delimiter>"^"</Delimiter>
<Piece>314</Piece>
</Data>
<Data name="MR_SZSJY">
<Delimiter>"^"</Delimiter>
<Piece>315</Piece>
</Data>
<Data name="MR_SZSJZ">
<Delimiter>"^"</Delimiter>
<Piece>316</Piece>
</Data>
<Data name="MR_TSHLTS">
<Delimiter>"^"</Delimiter>
<Piece>317</Piece>
</Data>
<Data name="MR_WEXZLSQSHZDFH">
<Delimiter>"^"</Delimiter>
<Piece>348</Piece>
</Data>
<Data name="MR_WZBRQJBZ">
<Delimiter>"^"</Delimiter>
<Piece>321</Piece>
</Data>
<Data name="MR_XB">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MR_XBYZLZPF">
<Delimiter>"^"</Delimiter>
<Piece>352</Piece>
</Data>
<Data name="MR_XF">
<Delimiter>"^"</Delimiter>
<Piece>252</Piece>
</Data>
<Data name="MR_XJ">
<Delimiter>"^"</Delimiter>
<Piece>308</Piece>
</Data>
<Data name="MR_XM">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MR_XSEAPF">
<Delimiter>"^"</Delimiter>
<Piece>305</Piece>
</Data>
<Data name="MR_XSECS">
<Delimiter>"^"</Delimiter>
<Piece>327</Piece>
</Data>
<Data name="MR_XSECSTZ">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="MR_XSERYTZ">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="MR_XX">
<Delimiter>"^"</Delimiter>
<Piece>267</Piece>
</Data>
<Data name="MR_XXB">
<Delimiter>"^"</Delimiter>
<Piece>307</Piece>
</Data>
<Data name="MR_XXYS">
<Delimiter>"^"</Delimiter>
<Piece>275</Piece>
</Data>
<Data name="MR_XYF">
<Delimiter>"^"</Delimiter>
<Piece>248</Piece>
</Data>
<Data name="MR_XZZ">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="MR_XZZDH">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="MR_XZZYB">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="MR_YBYLCZF">
<Delimiter>"^"</Delimiter>
<Piece>234</Piece>
</Data>
<Data name="MR_YBYLFWF">
<Delimiter>"^"</Delimiter>
<Piece>233</Piece>
</Data>
<Data name="MR_YJHLTS">
<Delimiter>"^"</Delimiter>
<Piece>318</Piece>
</Data>
<Data name="MR_YLFFFS">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MR_YWGMBZ">
<Delimiter>"^"</Delimiter>
<Piece>264</Piece>
</Data>
<Data name="MR_YWGMW">
<Delimiter>"^"</Delimiter>
<Piece>265</Piece>
</Data>
<Data name="MR_YXXZDF">
<Delimiter>"^"</Delimiter>
<Piece>239</Piece>
</Data>
<Data name="MR_YYCUSW">
<Delimiter>"^"</Delimiter>
<Piece>329</Piece>
</Data>
<Data name="MR_YYGRMCBM">
<Delimiter>"^"</Delimiter>
<Piece>116</Piece>
</Data>
<Data name="MR_YYGRZDMC">
<Delimiter>"^"</Delimiter>
<Piece>118</Piece>
</Data>
<Data name="MR_YYGRZDQK">
<Delimiter>"^"</Delimiter>
<Piece>117</Piece>
</Data>
<Data name="MR_YYXQX">
<Delimiter>"^"</Delimiter>
<Piece>331</Piece>
</Data>
<Data name="MR_YYXYWCCLS">
<Delimiter>"^"</Delimiter>
<Piece>332</Piece>
</Data>
<Data name="MR_ZCAOYF">
<Delimiter>"^"</Delimiter>
<Piece>251</Piece>
</Data>
<Data name="MR_ZCEXZLSQSHZDFH">
<Delimiter>"^"</Delimiter>
<Piece>349</Piece>
</Data>
<Data name="MR_ZCHENGYF">
<Delimiter>"^"</Delimiter>
<Piece>250</Piece>
</Data>
<Data name="MR_ZFJE">
<Delimiter>"^"</Delimiter>
<Piece>232</Piece>
</Data>
<Data name="MR_ZKHS">
<Delimiter>"^"</Delimiter>
<Piece>279</Piece>
</Data>
<Data name="MR_ZKKB">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="MR_ZKRQ">
<Delimiter>"^"</Delimiter>
<Piece>280</Piece>
</Data>
<Data name="MR_ZKYS">
<Delimiter>"^"</Delimiter>
<Piece>278</Piece>
</Data>
<Data name="MR_ZLFQ">
<Delimiter>"^"</Delimiter>
<Piece>304</Piece>
</Data>
<Data name="MR_ZLYYCXYYCLF">
<Delimiter>"^"</Delimiter>
<Piece>256</Piece>
</Data>
<Data name="MR_ZRHS">
<Delimiter>"^"</Delimiter>
<Piece>273</Piece>
</Data>
<Data name="MR_ZRYS">
<Delimiter>"^"</Delimiter>
<Piece>270</Piece>
</Data>
<Data name="MR_ZY">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="MR_ZYCS">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MR_ZYH">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MR_ZYYS">
<Delimiter>"^"</Delimiter>
<Piece>272</Piece>
</Data>
<Data name="MR_ZYZFF">
<Delimiter>"^"</Delimiter>
<Piece>231</Piece>
</Data>
<Data name="MR_ZYZLF">
<Delimiter>"^"</Delimiter>
<Piece>247</Piece>
</Data>
<Data name="MR_ZZYJH">
<Delimiter>"^"</Delimiter>
<Piece>282</Piece>
</Data>
<Data name="MR_ZZYMD">
<Delimiter>"^"</Delimiter>
<Piece>283</Piece>
</Data>
<Data name="MR_ZZYS">
<Delimiter>"^"</Delimiter>
<Piece>271</Piece>
</Data>
<Global>^DHCMRInfo</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHCMRInfo_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DHCMRInfo_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexMRADMDATE">
<Global>^DHCMRInfo</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCMRInfo_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"MR_ADM_DATE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MR_RYRQ}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCMRInfo_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMRADMDEPTDR">
<Global>^DHCMRInfo</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCMRInfo_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"MR_ADM_DEPT_DR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MR_RYKB}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCMRInfo_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMRDISDATE">
<Global>^DHCMRInfo</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCMRInfo_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"MR_DIS_DATE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MR_CYRQ}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCMRInfo_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMRDISDEPTDR">
<Global>^DHCMRInfo</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCMRInfo_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"MR_DIS_DEPT_DR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MR_CYKB}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCMRInfo_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMRID">
<Global>^DHCMRInfo</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCMRInfo_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"MR_ID"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MR_BAH}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCMRInfo_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMRMRDATE">
<Global>^DHCMRInfo</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCMRInfo_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"MR_MRDATE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MR_MRDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCMRInfo_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMRPAADMDR">
<Global>^DHCMRInfo</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCMRInfo_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"MR_PAADM_DR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MR_ADM}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCMRInfo_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMRPAPMIDR">
<Global>^DHCMRInfo</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCMRInfo_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"MR_PAPMI_DR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MR_PAPMIDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCMRInfo_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCMRInfoS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
