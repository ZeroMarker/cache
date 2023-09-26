Class User.DHCINSULocInfo Extends (%Library.Persistent, %XML.Adaptor) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = INLOC_RowID, SqlTableName = DHC_INSULocInfo, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// 20221117增加 ,对于XML的 <属性></属性> 转换成对象时， 
/// 如果=0（默认）则obj.属性 = $c(0)，保存到global中会破坏存储结构；如果=1 则obj.属性 = ""。
Parameter XMLIGNORENULL = 1;

Relationship ChildDHCINSULocAccount As User.DHCINSULocAccount [ Cardinality = children, Inverse = INSULAINLOCParRef ];

/// INLOC_XXLX
Property INLOCXXLX As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = INLOC_XXLX ];

/// INLOC_YLZBH
Property INLOCYLZBH As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = INLOC_YLZBH ];

/// INLOC_YLZZT
Property INLOCYLZZT As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = INLOC_YLZZT ];

/// INLOC_SBCARD
Property INLOCSBCARD As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = INLOC_SBCARD ];

/// INLOC_TXM
Property INLOCTXM As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = INLOC_TXM ];

/// INLOC_SFZH
Property INLOCSFZH As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = INLOC_SFZH ];

/// INLOC_XM
Property INLOCXM As %Library.String(COLLATION = "Exact", MAXLEN = 32, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = INLOC_XM ];

/// INLOC_XB
Property INLOCXB As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = INLOC_XB ];

/// INLOC_CSNY
Property INLOCCSNY As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = INLOC_CSNY ];

/// INLOC_FYID
Property INLOCFYID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = INLOC_FYID ];

/// INLOC_FFXZID
Property INLOCFFXZID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = INLOC_FFXZID ];

/// INLOC_RZID
Property INLOCRZID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = INLOC_RZID ];

/// INLOC_JBID
Property INLOCJBID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = INLOC_JBID ];

/// INLEAD_BZNY
Property INLOCBZNY As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = INLOC_BZNY ];

/// INLOC_YYDH
Property INLOCYYDH As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = INLOC_YYDH ];

/// INLOC_DWDM
Property INLOCDWDM As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = INLOC_DWDM ];

/// INLOC_DWXZDM
Property INLOCDWXZDM As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = INLOC_DWXZDM ];

/// INLOC_DWMC
Property INLOCDWMC As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = INLOC_DWMC ];

/// INLOC_DWDZ
Property INLOCDWDZ As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = INLOC_DWDZ ];

/// INLOC_DWDH
Property INLOCDWDH As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = INLOC_DWDH ];

/// INLOC_DWYB
Property INLOCDWYB As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = INLOC_DWYB ];

/// INLOC_JTZZ
Property INLOCJTZZ As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = INLOC_JTZZ ];

/// INLOC_ZZDH
Property INLOCZZDH As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = INLOC_ZZDH ];

/// INLOC_ZZYB
Property INLOCZZYB As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = INLOC_ZZYB ];

/// INLOC_iDate
Property INLOCiDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 26, SqlFieldName = INLOC_iDate ];

/// INLOC_iTime
Property INLOCiTime As %Library.Time [ SqlColumnNumber = 27, SqlFieldName = INLOC_iTime ];

/// INLOC_StaDate
Property INLOCStaDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 28, SqlFieldName = INLOC_StaDate ];

/// INLOC_StaTime
Property INLOCStaTime As %Library.Time [ SqlColumnNumber = 29, SqlFieldName = INLOC_StaTime ];

/// INLOC_EndDate
Property INLOCEndDate As %Library.Date [ SqlColumnNumber = 30, SqlFieldName = INLOC_EndDate ];

/// INLOC_EndTime
Property INLOCEndTime As %Library.Time [ SqlColumnNumber = 31, SqlFieldName = INLOC_EndTime ];

/// INLOC_YearStrDate_
Property INLOCYearStrDate As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = INLOC_YearStrDate ];

/// INLOC_AdmReason_Dr
Property INLOCAdmReasonDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = INLOC_AdmReason_Dr ];

/// INLOC_YearStrTime
Property INLOCYearStrTime As %Library.Time [ SqlColumnNumber = 34, SqlFieldName = INLOC_YearStrTime ];

/// INOC_MZQFD
Property INLOCMZQFD As %Library.Float [ SqlColumnNumber = 35, SqlFieldName = INLOC_MZQFD ];

/// INLOC_MZLJ
Property INLOCMZLJ As %Library.Float [ SqlColumnNumber = 36, SqlFieldName = INLOC_MZLJ ];

/// INLOC_ZYQFX
Property INLOCZYQFX As %Library.Float [ SqlColumnNumber = 37, SqlFieldName = INLOC_ZYQFX ];

/// INLOC_NDLJ
Property INLOCNDLJ As %Library.Float [ SqlColumnNumber = 38, SqlFieldName = INLOC_NDLJ ];

/// INLOC_ZYCS
Property INLOCZYCS As %Library.Float [ SqlColumnNumber = 39, SqlFieldName = INLOC_ZYCS ];

/// INLOC_TZLX
Property INLOCTZLX As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 40, SqlFieldName = INLOC_TZLX ];

/// INLOC_ZCYYDM
Property INLOCZCYYDM As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 41, SqlFieldName = INLOC_ZCYYDM ];

/// INLOC_ZCKSMC
Property INLOCZCKSMC As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 42, SqlFieldName = INLOC_ZCKSMC ];

/// INLOC_ZCBQMC
Property INLOCZCBQMC As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 43, SqlFieldName = INLOC_ZCBQMC ];

/// INLOC_ZCCWBH
Property INLOCZCCWBH As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 44, SqlFieldName = INLOC_ZCCWBH ];

/// INLOC_ZRYYDH
Property INLOCZRYYDH As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 45, SqlFieldName = INLOC_ZRYYDH ];

/// INLOC_ZRKSMC
Property INLOCZRKSMC As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 46, SqlFieldName = INLOC_ZRKSMC ];

/// INLOC_ZRBQMC
Property INLOCZRBQMC As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 47, SqlFieldName = INLOC_ZRBQMC ];

/// INLOC_LastOpDate
Property INLOCLastOpDate As %Library.Date [ SqlColumnNumber = 48, SqlFieldName = INLOC_LastOpDate ];

/// INLOC_LastIpDate
Property INLOCLastIpDate As %Library.Date [ SqlColumnNumber = 49, SqlFieldName = INLOC_LastIpDate ];

/// INLOC_HospDr
Property INLOCHospDr As %Library.String [ SqlColumnNumber = 50, SqlFieldName = INLOC_HospDr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCINLOC)</SqlIdExpression>
<SQLMap name="DateMasterMap">
<Data name="INLOC_AdmReason_Dr">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="INLOC_BZNY">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="INLOC_CSNY">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INLOC_DWDH">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="INLOC_DWDM">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="INLOC_DWDZ">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="INLOC_DWMC">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="INLOC_DWXZDM">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="INLOC_DWYB">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="INLOC_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="INLOC_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="INLOC_FFXZID">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INLOC_FYID">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INLOC_HospDr">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="INLOC_JBID">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INLOC_JTZZ">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="INLOC_LastIpDate">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="INLOC_LastOpDate">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="INLOC_MZLJ">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="INLOC_MZQFD">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="INLOC_NDLJ">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="INLOC_RZID">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INLOC_SBCARD">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INLOC_SFZH">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INLOC_StaDate">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="INLOC_StaTime">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="INLOC_TXM">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INLOC_TZLX">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="INLOC_XB">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INLOC_XM">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INLOC_XXLX">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INLOC_YLZBH">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INLOC_YLZZT">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INLOC_YYDH">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="INLOC_YearStrDate">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="INLOC_YearStrTime">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="INLOC_ZCBQMC">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="INLOC_ZCCWBH">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="INLOC_ZCKSMC">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="INLOC_ZCYYDM">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="INLOC_ZRBQMC">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="INLOC_ZRKSMC">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="INLOC_ZRYYDH">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="INLOC_ZYCS">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="INLOC_ZYQFX">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="INLOC_ZZDH">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="INLOC_ZZYB">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="INLOC_iDate">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="INLOC_iTime">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Global>^DHCINLOC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INLOC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{INLOC_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexofAdmReason">
<Global>^DHCINLOC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INLOC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"AdmReason"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INLOC_AdmReason_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INLOC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofAdmReasonHosp">
<Global>^DHCINLOC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>INLOC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HOSP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INLOC_HospDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"AdmReason"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INLOC_AdmReason_Dr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INLOC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofEndDate">
<Global>^DHCINLOC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INLOC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"EndDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INLOC_EndDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INLOC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofEndDateHosp">
<Global>^DHCINLOC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>INLOC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HOSP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INLOC_HospDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"EndDate"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INLOC_EndDate}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INLOC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofSBCARD">
<Global>^DHCINLOC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INLOC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"SBCARD"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INLOC_SBCARD}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INLOC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofSBCARDHosp">
<Global>^DHCINLOC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>INLOC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HOSP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INLOC_HospDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"SBCARD"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INLOC_SBCARD}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INLOC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofSHZH">
<Global>^DHCINLOC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INLOC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"SSID"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INLOC_SFZH}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INLOC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofSHZHHosp">
<Global>^DHCINLOC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>INLOC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HOSP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INLOC_HospDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"SSID"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INLOC_SFZH}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INLOC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofSatDate">
<Global>^DHCINLOC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INLOC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"StaDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INLOC_StaDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INLOC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofSatDateHosp">
<Global>^DHCINLOC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>INLOC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HOSP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INLOC_HospDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"StaDate"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INLOC_StaDate}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INLOC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofTYPEYLZ">
<Global>^DHCINLOC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INLOC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"TypeYLZ"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INLOC_AdmReason_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INLOC_YLZBH}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{INLOC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofTYPEYLZHosp">
<Global>^DHCINLOC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>INLOC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HOSP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INLOC_HospDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"TypeYLZ"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INLOC_AdmReason_Dr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INLOC_YLZBH}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{INLOC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofYLZBH">
<Global>^DHCINLOC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INLOC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"YLZBH"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INLOC_YLZBH}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INLOC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofYLZBHHosp">
<Global>^DHCINLOC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>INLOC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HOSP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INLOC_HospDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"YLZBH"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INLOC_YLZBH}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INLOC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofYYDH">
<Global>^DHCINLOC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INLOC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"YYDH"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INLOC_YYDH}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INLOC_SBCARD}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{INLOC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofYYDHHosp">
<Global>^DHCINLOC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>INLOC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HOSP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INLOC_HospDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"YYDH"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INLOC_YYDH}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INLOC_SBCARD}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{INLOC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofiDate">
<Global>^DHCINLOC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INLOC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"iDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INLOC_iDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INLOC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofiDateHosp">
<Global>^DHCINLOC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>INLOC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HOSP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INLOC_HospDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"iDate"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INLOC_iDate}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INLOC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCINSULocInfoS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 修改(注意对象二次修改时会触发update)
Method %OnBeforeSave(insert As %Boolean) As %Status [ Private ]
{
	s $zt="OnBeforeSaveError"
	s bdRowid=+$this.%Id()
	q:bdRowid<1 $$$OK
	s classname=$classname()
	q:$d(^DHCINLOC(bdRowid))=0 $$$OK
	s DHCINSULocInfo=$tr(^DHCINLOC(bdRowid),$c(0),"")
	s oldDHCINSULocInfoObj=##class(INSU.Utils.COM.Object).%New()
	s dicObj=##class(%Dictionary.CompiledClass).%OpenId("User.DHCINSULocInfo")
    f oldIndx=1:1:dicObj.Properties.Count() {
		s property=dicObj.Properties.GetAt(oldIndx)
		s propertyName=property.Name
		s propertySqlColumnNumber=property.SqlColumnNumber
		continue:($e(propertyName,1)="%")||(propertyName="ChildDHCINSULocAccount")
		d oldDHCINSULocInfoObj.Set(propertyName,$p(DHCINSULocInfo,"^",propertySqlColumnNumber-1))
	}
	d oldDHCINSULocInfoObj.Set("Rowid",bdRowid)
	s oldDHCINSULocInfoJsonStr=oldDHCINSULocInfoObj.ToJSON()
	s ^CacheTemp(classname,"%OnBeforeSave",$j,bdRowid,"JSON")=oldDHCINSULocInfoJsonStr	
	s userid=""
	s:$g(%session)'="" userid=%session.Get("LOGON.USERID")  
	s ^CacheTemp(classname,"%OnBeforeSaveUSERID",$j,bdRowid)=userid
	Quit $$$OK
OnBeforeSaveError
	s $zt=""
 	Quit $$$OK
}

/// 修改(注意对象二次修改时会触发update)
Method %OnAfterSave(insert As %Boolean) As %Status [ Private ]
{
	s $zt="OnAfterSave"
	k ^temp("insert1")
	s ^temp("insert1")=insert
	s bdRowid=+$this.%Id()
	s ^temp("insertbdRowid")=bdRowid
	q:bdRowid<1 $$$OK
	s classname=$classname()
	q:('insert)&&($d(^CacheTemp(classname,"%OnBeforeSave",$j,bdRowid,"JSON"))=0) $$$OK
	s userid=""
	i $d(^CacheTemp(classname,"%OnBeforeSaveUSERID",$j,bdRowid)) d
	.s userid=^CacheTemp(classname,"%OnBeforeSaveUSERID",$j,bdRowid)
	s newDHCINSULocInfoObj=##class(INSU.Utils.COM.Object).%New()
	set dicObj=##class(%Dictionary.CompiledClass).%OpenId("User.DHCINSULocInfo")
	for newIndx=1:1:dicObj.Properties.Count() {
		set property=dicObj.Properties.GetAt(newIndx)
		set propertyName=property.Name
		continue:($e(propertyName,1)="%")||(propertyName="ChildDHCINSULocAccount")
		d newDHCINSULocInfoObj.Set(propertyName,$tr($ZOBJPROPERTY($this,propertyName),$c(0),""))
	}
	d newDHCINSULocInfoObj.Set("Rowid",bdRowid)
	s newDHCINSULocInfoJsonStr = newDHCINSULocInfoObj.ToJSON()
	
	i insert d 
	.d ##class(INSU.COM.BaseDataLog).SaveLogForOther("DHC_INSULocInfo","User.DHCINSULocInfo", "本地人员名单",$this.%Id() ,$this.INLOCXM,"A",newDHCINSULocInfoJsonStr,userid)
	e  d
	.s oldDHCINSULocInfoJsonStr =$g(^CacheTemp(classname,"%OnBeforeSave",$j,bdRowid,"JSON"))
	.d ##class(INSU.COM.BaseDataLog).SaveLogForOther("DHC_INSULocInfo","User.DHCINSULocInfo", "本地人员名单",$this.%Id() ,$this.INLOCXM,"U",newDHCINSULocInfoJsonStr,oldDHCINSULocInfoJsonStr,userid)
	k ^CacheTemp(classname,"%OnBeforeSave",$j,bdRowid)
	k ^CacheTemp(classname,"%OnBeforeSaveUSERID",$j,bdRowid)
	Quit $$$OK
OnAfterSave
	s $zt=""
 	Quit $$$OK
}

/// 删除
ClassMethod %OnDelete(oid As %ObjectIdentity) As %Status [ Private, ServerOnly = 1 ]
{
	s $zt="OnDeleteError"
	Set bdRowid = $lg(oid) 
	q:bdRowid<1 $$$OK
	s classname=$classname()
	q:$d(^DHCINLOC(bdRowid))=0 $$$OK
	s DHCINSULocInfo=$tr(^DHCINLOC(bdRowid),$c(0),"")
	s oldDHCINSULocInfoObj=##class(INSU.Utils.COM.Object).%New()
	s dicObj=##class(%Dictionary.CompiledClass).%OpenId("User.DHCINSULocInfo")
	s INLOCXM=""
    f oldIndx=1:1:dicObj.Properties.Count() {
		s property=dicObj.Properties.GetAt(oldIndx)
		s propertyName=property.Name
		s propertySqlColumnNumber=property.SqlColumnNumber
		continue:($e(propertyName,1)="%")||(propertyName="ChildDHCINSULocAccount")
		i propertyName="INLOCXM"{s INLOCXM=$p(DHCINSULocInfo,"^",propertySqlColumnNumber-1)}
		d oldDHCINSULocInfoObj.Set(propertyName,$p(DHCINSULocInfo,"^",propertySqlColumnNumber-1))
	}
	d oldDHCINSULocInfoObj.Set("Rowid",bdRowid)
	s oldDHCINSULocInfoJsonStr=oldDHCINSULocInfoObj.ToJSON()	
	s ^CacheTemp(classname,"%OnDelete",$j,bdRowid,"JSON")=oldDHCINSULocInfoJsonStr	
	s ^CacheTemp(classname,"%OnDelete",$j,bdRowid,"INLOCXM")= INLOCXM
	s userid=""
	s:$g(%session)'="" userid=%session.Get("LOGON.USERID") 
	s ^CacheTemp(classname,"%OnDeleteUSERID",$j,bdRowid)=userid
	
	q $$$OK
OnDeleteError
	s $zt=""
	q $$$OK
}

ClassMethod %OnAfterDelete(oid As %ObjectIdentity) As %Status [ Private, ServerOnly = 1 ]
{
	s $zt="OnafterDeleteError"
	s bdRowid=+$lg(oid)
	q:bdRowid<1 $$$OK
	s classname=$classname()
	q:$d(^CacheTemp(classname,"%OnDelete",$j,bdRowid,"JSON"))=0 $$$OK
	s optdate=+$h
	s INLOCXM=^CacheTemp(classname,"%OnDelete",$j,bdRowid,"INLOCXM")
	s delDHCINSULocInfoJsonStr=^CacheTemp(classname,"%OnDelete",$j,bdRowid,"JSON")
	s userid=""
	i $d(^CacheTemp(classname,"%OnDeleteUSERID",$j,bdRowid)) d
	.s userid=^CacheTemp(classname,"%OnDeleteUSERID",$j,bdRowid)
	d ##class(INSU.COM.BaseDataLog).SaveLogForOther("DHC_INSULocInfo","User.DHCINSULocInfo", "本地人员名单",bdRowid ,INLOCXM,"D",delDHCINSULocInfoJsonStr,userid)
	k ^CacheTemp(classname,"%OnDelete",$j,bdRowid)
	k ^CacheTemp(classname,"%OnDeleteUSERID",$j,bdRowid)
	
	q $$$OK
OnafterDeleteError
	s $zt=""
	q $$$OK
}

/// 新增
Trigger %InsertAfter [ Event = INSERT, Time = AFTER ]
{
	s $zt="InsertAfter"
	s bdRowid=+{INLOC_RowID}
	q:bdRowid<1 $$$OK
	s classname=$classname()
	s userid=""
	s:$g(%session)'="" userid=session.Get("LOGON.USERID") 
	s newDHCINSULocInfoObj=##class(INSU.Utils.COM.Object).%New()
	set dicObj=##class(%Dictionary.CompiledClass).%OpenId("User.DHCINSULocInfo")
	for newIndx=1:1:dicObj.Properties.Count() {
		set property=dicObj.Properties.GetAt(newIndx)
		set propertyName=property.Name
		continue:($e(propertyName,1)="%")||(propertyName="ChildDHCINSULocAccount")
		d newDHCINSULocInfoObj.Set(propertyName,$tr($ZOBJPROPERTY($this,propertyName),$c(0),""))
	}
	d newDHCINSULocInfoObj.Set("Rowid",bdRowid)
	s newDHCINSULocInfoJsonStr = newDHCINSULocInfoObj.ToJSON()
	d ##class(INSU.COM.BaseDataLog).SaveLogForOther("DHC_INSULocInfo","User.DHCINSULocInfo", "本地人员名单",bdRowid ,$this.INLOCXM,"A",newDHCINSULocInfoJsonStr,userid)
InsertAfter
	s $zt=""
	q $$$OK
}

/// 更新Before
Trigger BeforeUpdate [ Event = UPDATE ]
{
	s $zt="BeforeUpdateError"
	;s ^TMPZMC("tttt u")=$classname() ;%session.Get("LOGON.USERID")	
	s bdRowid=+{INLOC_RowID}
	q:bdRowid<1 $$$OK
	s classname=$classname()
	q:$d(^DHCINLOC(bdRowid))=0 $$$OK
	s DHCINSULocInfo=$tr(^DHCINLOC(bdRowid),$c(0),"")
	s oldDHCINSULocInfoObj=##class(INSU.Utils.COM.Object).%New()
	s dicObj=##class(%Dictionary.CompiledClass).%OpenId("User.DHCINSULocInfo")
	s INLOCXM=""
    f oldIndx=1:1:dicObj.Properties.Count() {
		s property=dicObj.Properties.GetAt(oldIndx)
		s propertyName=property.Name
		s propertySqlColumnNumber=property.SqlColumnNumber
		continue:($e(propertyName,1)="%")||(propertyName="ChildDHCINSULocAccount")
		d oldDHCINSULocInfoObj.Set(propertyName,$p(DHCINSULocInfo,"^",propertySqlColumnNumber-1))
	}
	d oldDHCINSULocInfoObj.Set("Rowid",bdRowid)
	s oldDHCINSULocInfoJsonStr=oldDHCINSULocInfoObj.ToJSON()
	s ^CacheTemp(classname,"BeforeUpdate",$j,bdRowid,"JSON")=oldDHCINSULocInfoJsonStr	
	s ^CacheTemp(classname,"BeforeUpdate",$j,bdRowid,"INLOCXM")= INLOCXM
	s userid=""
	s:$g(%session)'="" userid=%session.Get("LOGON.USERID") 
	s ^CacheTemp(classname,"BeforeUpdateUSERID",$j,bdRowid)=userid
	
	q $$$OK
BeforeUpdateError
	s $zt=""
	q $$$OK
}

/// 更新 After
Trigger AfterUpdate [ Event = UPDATE, Time = AFTER ]
{
  	s $zt="AfterUpdate"
	s bdRowid=+{INLOC_RowID}
	q:bdRowid<1 $$$OK
	s classname=$classname()
	q:$d(^CacheTemp(classname,"BeforeUpdate",$j,bdRowid,"JSON"))=0 $$$OK
	s userid=""
	i $d(^CacheTemp(classname,"BeforeUpdateUSERID",$j,bdRowid)) d
	.s userid=^CacheTemp(classname,"BeforeUpdateUSERID",$j,bdRowid)
	s newDHCINSULocInfoObj=##class(INSU.Utils.COM.Object).%New()
	set dicObj=##class(%Dictionary.CompiledClass).%OpenId("User.DHCINSULocInfo")
	for newIndx=1:1:dicObj.Properties.Count() {
		set property=dicObj.Properties.GetAt(newIndx)
		set propertyName=property.Name
		continue:($e(propertyName,1)="%")||(propertyName="ChildDHCINSULocAccount")
		d newDHCINSULocInfoObj.Set(propertyName,$tr($ZOBJPROPERTY($this,propertyName),$c(0),""))
	}
	d newDHCINSULocInfoObj.Set("Rowid",bdRowid)
	s newDHCINSULocInfoJsonStr = newDHCINSULocInfoObj.ToJSON()
	s oldDHCINSULocInfoJsonStr =$g(^CacheTemp(classname,"BeforeUpdate",$j,bdRowid,"JSON"))
	s ^temp("test1")=newDHCINSULocInfoJsonStr
	d ##class(INSU.COM.BaseDataLog).SaveLogForOther("DHC_INSULocInfo","User.DHCINSULocInfo", "本地人员名单",$this.%Id() ,$this.INLOCXM,"U",newDHCINSULocInfoJsonStr,oldDHCINSULocInfoJsonStr)
	k ^CacheTemp(classname,"BeforeUpdate",$j,bdRowid)
	k ^CacheTemp(classname,"BeforeUpdateUSERID",$j,bdRowid)
	q $$$OK
AfterUpdate
	s $zt=""
	q $$$OK
}

/// 删除 Befor
Trigger BeforDelete [ Event = DELETE ]
{
  	s $zt="BeforDeleteError"
	s bdRowid=+{INLOC_RowID}
	q:bdRowid<1
	s classname=$classname()
	q:$d(^DHCINLOC(bdRowid))=0 $$$OK
	s DHCINSULocInfo=$tr(^DHCINLOC(bdRowid),$c(0),"")
	s oldDHCINSULocInfoObj=##class(INSU.Utils.COM.Object).%New()
	s dicObj=##class(%Dictionary.CompiledClass).%OpenId("User.DHCINSULocInfo")
	s INLOCXM=""
    f oldIndx=1:1:dicObj.Properties.Count() {
		s property=dicObj.Properties.GetAt(oldIndx)
		s propertyName=property.Name
		s propertySqlColumnNumber=property.SqlColumnNumber
		continue:($e(propertyName,1)="%")||(propertyName="ChildDHCINSULocAccount")
		i propertyName="INLOCXM"{s INLOCXM=$p(DHCINSULocInfo,"^",propertySqlColumnNumber-1)}
		d oldDHCINSULocInfoObj.Set(propertyName,$p(DHCINSULocInfo,"^",propertySqlColumnNumber-1))
	}
	d oldDHCINSULocInfoObj.Set("Rowid",bdRowid)
	s oldDHCINSULocInfoJsonStr=oldDHCINSULocInfoObj.ToJSON()
	s ^temp("testdel30")=oldDHCINSULocInfoJsonStr
	s ^CacheTemp(classname,"BeforDelete",$j,bdRowid,"JSON")=oldDHCINSULocInfoJsonStr	
	s ^CacheTemp(classname,"BeforDelete",$j,bdRowid,"INLOCXM")= INLOCXM
	s userid=""
	s:$g(%session)'="" userid=%session.Get("LOGON.USERID") 
	s ^CacheTemp(classname,"BeforDeleteUSERID",$j,bdRowid)=userid
	s ^temp("dd0")=userid
	q $$$OK
BeforDeleteError
	s $zt=""
	q $$$OK
}

/// 删除  After
Trigger AfterDelete [ Event = DELETE, Time = AFTER ]
{
  	s $zt="AfterDeleteError"
	s bdRowid=+{INLOC_RowID}
	q:bdRowid<1 $$$OK
	s classname=$classname()
	q:$d(^CacheTemp(classname,"BeforDelete",$j,bdRowid,"JSON"))=0 $$$OK
	s INLOCXM=^CacheTemp(classname,"BeforDelete",$j,bdRowid,"INLOCXM")
	s delDHCINSULocInfoJsonStr=^CacheTemp(classname,"BeforDelete",$j,bdRowid,"JSON")
	s userid=^CacheTemp(classname,"BeforDeleteUSERID",$j,bdRowid)
    s ^temp("dd")=userid
	d ##class(INSU.COM.BaseDataLog).SaveLogForOther("DHC_INSULocInfo","User.DHCINSULocInfo", "本地人员名单",bdRowid ,INLOCXM,"D",delDHCINSULocInfoJsonStr,userid)
	k ^CacheTemp(classname,"BeforDelete",$j,bdRowid)
	k ^CacheTemp(classname,"BeforDeleteUSERID",$j,bdRowid)
	
	q $$$OK
AfterDeleteError
	s $zt=""
	q $$$OK
}

}
