Class User.INSUTarItems Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = INTIM_Rowid, SqlTableName = INSU_TarItems, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// INTIM_sfdlbm
Property INTIMsfdlbm As %Library.String(CAPTION = "费用分类", COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = INTIM_sfdlbm ];

/// INTIM_sfxmbm
Property INTIMsfxmbm As %Library.String(CAPTION = "医保类型", COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = INTIM_sfxmbm ];

/// INTIM_xmbm
Property INTIMxmbm As %Library.String(CAPTION = "项目编码", COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = INTIM_xmbm ];

/// INTIM_xmmc
Property INTIMxmmc As %Library.String(CAPTION = "项目名称", COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = INTIM_xmmc ];

/// INTIM_xmrj
Property INTIMxmrj As %Library.String(CAPTION = "拼音码", COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = INTIM_xmrj ];

/// INTIM_txbz
Property INTIMtxbz As %Library.String(CAPTION = "限制用药标志", COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = INTIM_txbz ];

/// INTIM_xmlb
Property INTIMxmlb As %Library.String(CAPTION = "项目类别", COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = INTIM_xmlb ];

/// INTIM_jx
Property INTIMjx As %Library.String(CAPTION = "剂型", COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = INTIM_jx ];

/// INTIM_gg
Property INTIMgg As %Library.String(CAPTION = "规格", COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = INTIM_gg ];

/// INTIM_dw
Property INTIMdw As %Library.String(CAPTION = "单位", COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = INTIM_dw ];

/// INTIM_yf
Property INTIMyf As %Library.String(CAPTION = "用法", COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = INTIM_yf ];

/// INTIM_yl
Property INTIMyl As %Library.String(CAPTION = "用量", COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = INTIM_yl ];

/// INTIM_sl
Property INTIMsl As %Library.Float(CAPTION = "数量") [ SqlColumnNumber = 14, SqlFieldName = INTIM_sl ];

/// INTIM_pzwh
Property INTIMpzwh As %Library.String(CAPTION = "批准文号", COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = INTIM_pzwh ];

/// INTIM_bzjg
Property INTIMbzjg As %Library.Float(CAPTION = "标准价格") [ SqlColumnNumber = 16, SqlFieldName = INTIM_bzjg ];

/// INTIM_sjjg
Property INTIMsjjg As %Library.Float(CAPTION = "实际价格") [ SqlColumnNumber = 17, SqlFieldName = INTIM_sjjg ];

/// INTIM_zgxj
Property INTIMzgxj As %Library.Float(CAPTION = "最高限价") [ SqlColumnNumber = 18, SqlFieldName = INTIM_zgxj ];

/// INTIM_zfbl1
Property INTIMzfbl1 As %Library.Float(CAPTION = "自付比例1") [ SqlColumnNumber = 19, SqlFieldName = INTIM_zfbl1 ];

/// INTIM_zfbl2
Property INTIMzfbl2 As %Library.Float(CAPTION = "自付比例2") [ SqlColumnNumber = 20, SqlFieldName = INTIM_zfbl2 ];

/// INTIM_zfbl3
Property INTIMzfbl3 As %Library.Float(CAPTION = "自付比例3") [ SqlColumnNumber = 21, SqlFieldName = INTIM_zfbl3 ];

/// INTIM_bpxe
Property INTIMbpxe As %Library.Float(CAPTION = "报批限额") [ SqlColumnNumber = 22, SqlFieldName = INTIM_bpxe ];

/// INTIM_bz
Property INTIMbz As %Library.String(CAPTION = "备注", COLLATION = "Exact", MAXLEN = 4000, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = INTIM_bz ];

/// INTIM_tjdm
Property INTIMtjdm As %Library.String(CAPTION = "项目等级", COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = INTIM_tjdm ];

/// INTIM_flzb1 分类指标1
Property INTIMflzb1 As %Library.String(CAPTION = "是否医保", COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = INTIM_flzb1 ];

/// INTIM_flzb2 分类指标2
Property INTIMflzb2 As %Library.String(CAPTION = "有效标志", COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = INTIM_flzb2 ];

/// INTIM_flzb3
Property INTIMflzb3 As %Library.String(CAPTION = "分类指标3", COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = INTIM_flzb3 ];

/// INTIM_flzb4
Property INTIMflzb4 As %Library.String(CAPTION = "分类指标4", COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = INTIM_flzb4 ];

/// INTIM_flzb5
Property INTIMflzb5 As %Library.String(CAPTION = "分类指标5", COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = INTIM_flzb5 ];

/// INTIM_flzb6
Property INTIMflzb6 As %Library.String(CAPTION = "分类指标6", COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = INTIM_flzb6 ];

/// INTIM_flzb7
Property INTIMflzb7 As %Library.String(CAPTION = "分类指标7", COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = INTIM_flzb7 ];

/// INTIM_spmc
Property INTIMspmc As %Library.String(CAPTION = "商品名称", COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = INTIM_spmc ];

/// INTIM_spmcrj
Property INTIMspmcrj As %Library.String(CAPTION = "商品名称拼音码", COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = INTIM_spmcrj ];

/// INTIM_ljzfbz
Property INTIMljzfbz As %Library.String(CAPTION = "累计增负标志", COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = INTIM_ljzfbz ];

/// INTIM_yyjzjbz
Property INTIMyyjzjbz As %Library.String(CAPTION = "医院增加标志", COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = INTIM_yyjzjbz ];

/// INTIM_yysmbm
Property INTIMyysmbm As %Library.String(CAPTION = "医院三目编码", COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 36, SqlFieldName = INTIM_yysmbm ];

/// INTIM_fplb
Property INTIMfplb As %Library.String(CAPTION = "发票类别", COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 37, SqlFieldName = INTIM_fplb ];

/// INTIM_DicType
Property INTIMDicType As %Library.String(CAPTION = "目录类别", COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 38, SqlFieldName = INTIM_DicType ];

/// INTIM_User_Dr
Property INTIMUserDr As User.SSUser(CAPTION = "操作员") [ SqlColumnNumber = 39, SqlFieldName = INTIM_User_Dr ];

/// INTIM_Date
Property INTIMDate As %Library.Date(CAPTION = "操作日期", FORMAT = 1) [ SqlColumnNumber = 40, SqlFieldName = INTIM_Date ];

/// INTIM_Time
Property INTIMTime As %Library.Time(CAPTION = "操作时间") [ SqlColumnNumber = 41, SqlFieldName = INTIM_Time ];

/// INTIM_ADDIP
Property INTIMADDIP As %Library.String(CAPTION = "修改人IP", COLLATION = "Exact", MAXLEN = 15, TRUNCATE = 0) [ SqlColumnNumber = 42, SqlFieldName = INTIM_ADDIP ];

/// INTIM_ActiveDate
Property INTIMActiveDate As %Library.Date(CAPTION = "项目生效日期", FORMAT = 1) [ SqlColumnNumber = 43, SqlFieldName = INTIM_ActiveDate ];

/// INTIM_Unique
Property INTIMUnique As %Library.String(CAPTION = "医保中心唯一码", COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 44, SqlFieldName = INTIM_Unique ];

/// INTIM_ExpiryDate
Property INTIMExpiryDate As %Library.Date(CAPTION = "失效日期", FORMAT = 1) [ SqlColumnNumber = 45, SqlFieldName = INTIM_ExpiryDate ];

/// INTIM_HospDr
Property INTIMHospDr As %Library.String(CAPTION = "院区") [ SqlColumnNumber = 46, SqlFieldName = INTIM_HospDr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCINTIM)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="INTIM_ADDIP">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="INTIM_ActiveDate">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="INTIM_Date">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="INTIM_DicType">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="INTIM_ExpiryDate">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="INTIM_HospDr">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="INTIM_Time">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="INTIM_Unique">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="INTIM_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="INTIM_bpxe">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="INTIM_bz">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="INTIM_bzjg">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="INTIM_dw">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INTIM_flzb1">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="INTIM_flzb2">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="INTIM_flzb3">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="INTIM_flzb4">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="INTIM_flzb5">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="INTIM_flzb6">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="INTIM_flzb7">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="INTIM_fplb">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="INTIM_gg">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INTIM_jx">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INTIM_ljzfbz">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="INTIM_pzwh">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="INTIM_sfdlbm">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INTIM_sfxmbm">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INTIM_sjjg">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="INTIM_sl">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INTIM_spmc">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="INTIM_spmcrj">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="INTIM_tjdm">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="INTIM_txbz">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INTIM_xmbm">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INTIM_xmlb">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INTIM_xmmc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INTIM_xmrj">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INTIM_yf">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INTIM_yl">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INTIM_yyjzjbz">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="INTIM_yysmbm">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="INTIM_zfbl1">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="INTIM_zfbl2">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="INTIM_zfbl3">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="INTIM_zgxj">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Global>^DHCINTIM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INTIM_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{INTIM_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAlias">
<Global>^DHCINTIM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INTIM_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Alias"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({INTIM_xmrj})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INTIM_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCINTIM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INTIM_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"CODE"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({INTIM_xmbm})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INTIM_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCINTIM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INTIM_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"DESC"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({INTIM_xmmc})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INTIM_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypeCode">
<Global>^DHCINTIM</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ITYPECODE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INTIM_sfxmbm}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INTIM_xmbm}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INTIM_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Indexsfdlbm">
<Global>^DHCINTIM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INTIM_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"DLBM"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INTIM_sfdlbm}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INTIM_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Indextjdm">
<Global>^DHCINTIM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INTIM_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"TJDM"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INTIM_tjdm}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INTIM_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Indexxmlb">
<Global>^DHCINTIM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INTIM_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"XMLB"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{INTIM_xmlb}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{INTIM_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexAliasHosp">
<Global>^DHCINTIM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>INTIM_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HOSP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INTIM_HospDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"Alias"</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({INTIM_xmrj})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INTIM_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexCodeHosp">
<Global>^DHCINTIM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>INTIM_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HOSP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INTIM_HospDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"CODE"</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({INTIM_xmbm})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INTIM_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexDescHosp">
<Global>^DHCINTIM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>INTIM_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HOSP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INTIM_HospDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DESC"</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({INTIM_xmmc})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INTIM_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexPzwhHosp">
<Global>^DHCINTIM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>INTIM_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HOSP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INTIM_HospDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"PZWH"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INTIM_pzwh}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INTIM_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexTypeCodeHosp">
<Global>^DHCINTIM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>INTIM_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HOSP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INTIM_HospDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"ITYPECODE"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INTIM_sfxmbm}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INTIM_xmbm}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{INTIM_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexhisrow">
<Global>^DHCINTIM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INTIM_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"HISROW"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{INTIM_flzb7}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{INTIM_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexsfdlbmHosp">
<Global>^DHCINTIM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>INTIM_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HOSP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INTIM_HospDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DLBM"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INTIM_sfdlbm}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INTIM_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indextjdmHosp">
<Global>^DHCINTIM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>INTIM_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HOSP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INTIM_HospDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"TJDM"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INTIM_tjdm}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INTIM_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexxmlbHosp">
<Global>^DHCINTIM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>INTIM_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HOSP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INTIM_HospDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"XMLB"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INTIM_xmlb}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INTIM_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.INSUTarItemsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

// ------------------------------------------------------------------------------------------

/// 删除
Trigger BeforDelete [ Event = DELETE ]
{
  	s $zt="BeforDeleteError"
	s bdRowid=+{INTIM_Rowid}
	q:bdRowid<1
	q:$d(^DHCINTIM(bdRowid))=0
	s bdStr=^DHCINTIM(bdRowid)
	s classname=$classname()
	s ^CacheTemp(classname,"BeforDelete",$j,bdRowid)=bdStr
	s userid=%session.Get("LOGON.USERID") 
	s ^CacheTemp(classname,"BeforDeleteUSERID",$j,bdRowid)=userid
	q $$$OK
BeforDeleteError
	s $zt=""
	q $$$OK
}

Trigger AfterDelete [ Event = DELETE, Time = AFTER ]
{
  	s $zt="AfterDeleteError"
	s bdRowid=+{INTIM_Rowid}
	q:bdRowid<1 $$$OK
	s classname=$classname()
	q:$d(^CacheTemp(classname,"BeforDelete",$j,bdRowid))=0 $$$OK
	s optdate=+$h
	s opttime=$p($h,",",2)
	s userid="null"
	s bdStr=bdRowid_"^"_^CacheTemp(classname,"BeforDelete",$j,bdRowid)
	s TableTypeCode=$p(bdStr,"^",2)
	i $d(^CacheTemp(classname,"BeforDeleteUSERID",$j,bdRowid)) d
	.s userid=^CacheTemp(classname,"BeforDeleteUSERID",$j,bdRowid)
	&sql(insert into CF_INSU_MI.DataLog (TableClassName,TableRowId,TableTypeCode,OptType,OptDate,OptTime,UserId,Data) values(UCase(:classname),:bdRowid,:TableTypeCode,'DELETE',:optdate,:opttime,:userid,:bdStr))
	i SQLCODE=0 d
	.k ^CacheTemp(classname,"BeforDelete",$j,bdRowid)
	.k ^CacheTemp(classname,"BeforDeleteUSERID",$j,bdRowid)
	
	q $$$OK
AfterDeleteError
	s $zt=""
	q $$$OK
}

/// 更新
Trigger BeforeUpdate [ Event = UPDATE ]
{
	s $zt="BeforeUpdateError"
	;s ^TMPZMC("tttt u")=$classname() ;%session.Get("LOGON.USERID")	
	s bdRowid=+{INTIM_Rowid}
	q:bdRowid<1 $$$OK
	s classname=$classname()
	q:$d(^DHCINTIM(bdRowid))=0 $$$OK
	s bdStr=^DHCINTIM(bdRowid)
	s ^CacheTemp(classname,"BeforeUpdate",$j,bdRowid)=bdStr	
	s userid=%session.Get("LOGON.USERID") 
	s ^CacheTemp(classname,"BeforeUpdateUSERID",$j,bdRowid)=userid
	q $$$OK
BeforeUpdateError
	s $zt=""
	q $$$OK
}

Trigger AfterUpdate [ Event = UPDATE, Time = AFTER ]
{
  	s $zt="AfterUpdate"
	s bdRowid=+{INTIM_Rowid}
	q:bdRowid<1 $$$OK
	s classname=$classname()
	q:$d(^CacheTemp(classname,"BeforeUpdate",$j,bdRowid))=0 $$$OK
	s updatestr=^CacheTemp(classname,"BeforeUpdate",$j,bdRowid)
	q:(^DHCINTIM(bdRowid))=updatestr $$$OK
	s optdate=+$h
	s opttime=$p($h,",",2)
	s userid="null"
	i $d(^CacheTemp(classname,"BeforeUpdateUSERID",$j,bdRowid)) d
	.s userid=^CacheTemp(classname,"BeforeUpdateUSERID",$j,bdRowid)
	s bdStr=bdRowid_"^"_updatestr
	s TableTypeCode=$p(bdStr,"^",2)
	s NewData=$g(^DHCINTIM(bdRowid))
	&sql(insert into CF_INSU_MI.DataLog (TableClassName,TableRowId,TableTypeCode,OptType,OptDate,OptTime,UserId,Data,NewData) values(UCase(:classname),:bdRowid,:TableTypeCode,'UPDATE',:optdate,:opttime,:userid,:bdStr,:NewData))
	i SQLCODE=0 d
	.k ^CacheTemp(classname,"BeforeUpdate",$j,bdRowid)
	.k ^CacheTemp(classname,"BeforeUpdateUSERID",$j,bdRowid)
	q $$$OK
AfterUpdate
	s $zt=""
	q $$$OK
}

/// 修改(注意对象二次修改时会触发update)
Method %OnBeforeSave(insert As %Boolean) As %Status [ Private ]
{
	s $zt="OnBeforeSaveError"
	s bdRowid=+$this.%Id()
	q:bdRowid<1 $$$OK
	s classname=$classname()
	q:$d(^DHCINTIM(bdRowid))=0 $$$OK
	s bdStr=^DHCINTIM(bdRowid)
	s ^CacheTemp(classname,"%OnBeforeSave",$j,bdRowid)=bdStr	
	s userid=%session.Get("LOGON.USERID") 
	s ^CacheTemp(classname,"%OnBeforeSaveUSERID",$j,bdRowid)=userid
	Quit $$$OK
OnBeforeSaveError
	s $zt=""
 	Quit $$$OK
}

Method %OnAfterSave(insert As %Boolean) As %Status [ Private ]
{
	s $zt="OnAfterSave"
	s bdRowid=+$this.%Id()
	q:bdRowid<1 $$$OK
	s classname=$classname()
	q:$d(^CacheTemp(classname,"%OnBeforeSave",$j,bdRowid))=0 $$$OK
	s updatestr=^CacheTemp(classname,"%OnBeforeSave",$j,bdRowid)
	q:(^DHCINTIM(bdRowid))=updatestr $$$OK
	s optdate=+$h
	s opttime=$p($h,",",2)
	s userid="null"
	i $d(^CacheTemp(classname,"%OnBeforeSaveUSERID",$j,bdRowid)) d
	.s userid=^CacheTemp(classname,"%OnBeforeSaveUSERID",$j,bdRowid)
	s bdStr=bdRowid_"^"_updatestr
	s TableTypeCode=$p(bdStr,"^",2)
	s NewData=$g(^DHCINTIM(bdRowid))
	&sql(insert into CF_INSU_MI.DataLog (TableClassName,TableRowId,TableTypeCode,OptType,OptDate,OptTime,UserId,Data,NewData) values(UCase(:classname),:bdRowid,:TableTypeCode,'SAVE',:optdate,:opttime,:userid,:bdStr,:NewData))
	i SQLCODE=0 d
	.k ^CacheTemp(classname,"%OnBeforeSave",$j,bdRowid)
	
	Quit $$$OK
OnAfterSave
	s $zt=""
 	Quit $$$OK
}

/// 删除
ClassMethod %OnDelete(oid As %ObjectIdentity) As %Status [ Private, ServerOnly = 1 ]
{
	s $zt="OnDeleteError"
	;S tmpOBJ= ##class(User.INSUTarItems).%Open(oid) 
	Set bdRowid = $lg(oid) 
	q:bdRowid<1 $$$OK
	s classname=$classname()
	q:$d(^DHCINTIM(bdRowid))=0 $$$OK
	s bdStr=^DHCINTIM(bdRowid)
	s ^CacheTemp(classname,"%OnDelete",$j,bdRowid)=bdStr	
	s userid=%session.Get("LOGON.USERID") 
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
	q:$d(^CacheTemp(classname,"%OnDelete",$j,bdRowid))=0 $$$OK
	s optdate=+$h
	s opttime=$p($h,",",2)
	s userid="null"
	s bdStr=bdRowid_"^"_^CacheTemp(classname,"%OnDelete",$j,bdRowid)
	s TableTypeCode=$p(bdStr,"^",2)
	i $d(^CacheTemp(classname,"%OnDeleteUSERID",$j,bdRowid)) d
	.s userid=^CacheTemp(classname,"%OnDeleteUSERID",$j,bdRowid)
	&sql(insert into CF_INSU_MI.DataLog (TableClassName,TableRowId,TableTypeCode,OptType,OptDate,OptTime,UserId,Data) values(UCase(:classname),:bdRowid,:TableTypeCode,'DELETE',:optdate,:opttime,:userid,:bdStr))
	i SQLCODE=0 d
	.k ^CacheTemp(classname,"%OnDelete",$j,bdRowid)
	.k ^CacheTemp(classname,"%OnDeleteUSERID",$j,bdRowid)
	
	q $$$OK
OnafterDeleteError
	s $zt=""
	q $$$OK
}

Trigger %InsertAfter [ Event = INSERT, Time = AFTER ]
{
	s $zt="InsertAfter"
	s bdRowid=+{INTIM_Rowid}
	q:bdRowid<1 $$$OK
	s classname=$classname()
	s updatestr=""
	s optdate=+$h
	s opttime=$p($h,",",2)
	s userid="null"
	s bdStr=bdRowid_"^"_$g(^DHCINTIM(bdRowid))
	s NewData=$g(^DHCINTIM(bdRowid))
	s TableTypeCode=$p(NewData,"^",1)
	s ^CacheTemp("%InsertAfter",3)=""
	&sql(insert into CF_INSU_MI.DataLog (TableClassName,TableRowId,TableTypeCode,OptType,OptDate,OptTime,UserId,Data,NewData) values(UCase(:classname),:bdRowid,:TableTypeCode,'INSERT',:optdate,:opttime,:userid,:bdStr,:NewData))
InsertAfter
	s $zt=""
	q $$$OK
}

}
