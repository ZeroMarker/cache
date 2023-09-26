Class User.APCVendorAddionInfo Extends (%Persistent, User.Abstract) [ SqlRowIdName = APCINFO_RowId, SqlTableName = APC_VendorAddionInfo, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Property APCINFODR As User.APCVendor [ SqlColumnNumber = 2, SqlFieldName = APCINFO_DR ];

Property APCINFOPICSRC As %Library.String(COLLATION = "Exact", MAXLEN = 350, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = APCINFO_PICSRC ];

Property APCINFOTYPE As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = APCINFO_TYPE ];

Property APCINFOUpdateDate As %Date [ SqlColumnNumber = 5, SqlFieldName = APCINFO_UpdateDate ];

/// 医院审核或拒绝供应商资质时更新 Y审核通过，N拒绝
Property APCINFOUseFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = APCINFO_UseFlag ];

/// 拒绝日期做个记录（实际作用不大）
Property APCINFONotUseDate As %Date [ SqlColumnNumber = 7, SqlFieldName = APCINFO_NotUseDate ];

/// 供应商资质同步过了，供应商换证时更新标志
Property APCINFOCurFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = APCINFO_CurFlag ];

/// 同步供应商资质的效期
Property APCINFORegDate As %Date [ SqlColumnNumber = 9, SqlFieldName = APCINFO_RegDate ];

/// 同步供应商资质的证件号
Property APCINFORegNo As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = APCINFO_RegNo ];

/// 图片名称
Property APCINFOFileName As %Library.String(COLLATION = "Exact", MAXLEN = 600, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = APCINFO_FileName ];

/// 资质/人员id
Property APCINFOPoint As %Library.String(COLLATION = "Exact", TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = APCINFO_Point ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^APCVENDORINFO)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="APCINFO_CurFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="APCINFO_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="APCINFO_FileName">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="APCINFO_NotUseDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="APCINFO_PICSRC">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="APCINFO_Point">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="APCINFO_RegDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="APCINFO_RegNo">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="APCINFO_TYPE">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="APCINFO_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="APCINFO_UseFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^APCVENDORINFO</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>APCINFO_Row</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{APCINFO_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexApc">
<Global>^APCVENDORINFO</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>APCINFO_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Apc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{APCINFO_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{APCINFO_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>APCINFO_RowId</SqlRowIdName>
<StreamLocation>^User.APCVendorAddionInfoS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^APCVENDORINFO)
	s oldI = +$g(^mdata("APCVENDORADDINFO"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^APCVENDORINFO = maxI
	s ^mdata("APCVENDORADDINFO") = maxI
}

}
