Class User.DHCManfAddionInfoPic Extends (%Persistent, User.Abstract) [ SqlRowIdName = MP_RowId, SqlTableName = DHC_Manf_AddionInfoPic, StorageStrategy = SqlStorage1 ]
{

Property MPPHMNFDR As User.PHManufacturer [ Required, SqlColumnNumber = 2, SqlFieldName = MP_PHMNF_DR ];

Property MPPicSrc As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = MP_PicSrc ];

Property MPType As %String [ SqlColumnNumber = 4, SqlFieldName = MP_Type ];

Property MPDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = MP_Date ];

/// 图片名称
Property MPFileName As %Library.String(COLLATION = "Exact", MAXLEN = 600, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = MP_FileName ];

/// 资质/人员id
Property MPPoint As %Library.String(COLLATION = "Exact", TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = MP_Point ];

Storage SqlStorage1
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCMANFPIC)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MP_Date">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MP_FileName">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MP_PHMNF_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MP_PicSrc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MP_Point">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MP_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCMANFPIC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{MP_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexManf">
<Global>^DHCMANFPIC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"MANF"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{MP_PHMNF_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{MP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>MP_RowId</SqlRowIdName>
<StreamLocation>^User.DHCManfAddionInfoPicS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCMANFPIC)
	s oldI = +$g(^mdata("DHCMANFADDIONINFOPIC"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCMANFPIC = maxI
	s ^mdata("DHCMANFADDIONINFOPIC") = maxI
}

}
