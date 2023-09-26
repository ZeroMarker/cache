Class User.DHCVendorInciInfo Extends (%Persistent, User.Abstract) [ SqlRowIdName = VenInc_RowId, SqlTableName = DHC_VendorInciInfo, StorageStrategy = SQLStorage ]
{

Property VenIncInciDr As User.INCItm [ SqlColumnNumber = 2, SqlFieldName = VenInc_InciDr ];

Property VenIncVendorDr As User.APCVendor [ SqlColumnNumber = 3, SqlFieldName = VenInc_VendorDr ];

Property VenIncTYPE As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = VenInc_type ];

/// 资质归属者名称(比如:VenIncText为生产厂家供应商执照,则VenIncTextPar记录生产厂家名称)
Property VenIncTextPar As %Library.String(COLLATION = "Exact", MAXLEN = 150, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = VenInc_TextPar ];

Property VenIncText As %Library.String(COLLATION = "Exact", MAXLEN = 150, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = VenInc_Text ];

Property VenIncDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = VenInc_Date ];

Property VenIncAudited As %Library.String(DISPLAYLIST = ",Yes,No,Reject", MAXLEN = 3, SELECTIVITY = "25%", VALUELIST = ",Y,N,R") [ InitialExpression = "N", SqlColumnNumber = 8, SqlFieldName = VenInc_AuditedFlag ];

Property VenIncSSUSRDR As User.SSUser [ SqlColumnNumber = 9, SqlFieldName = VenInc_SSUSR_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCVendorInciInFo)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="VenInc_AuditedFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="VenInc_Date">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="VenInc_InciDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="VenInc_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="VenInc_Text">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="VenInc_TextPar">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="VenInc_VendorDr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="VenInc_type">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCVendorInciInFo</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>VenInc_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{VenInc_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexVenIncType">
<Global>^DHCVendorInciInFo</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>VenInc_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"VenIncType"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{VenInc_AuditedFlag}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{VenInc_VendorDr}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{VenInc_InciDr}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>{VenInc_type}</Expression>
</Subscript>
<Subscript name="7">
<AccessType>Sub</AccessType>
<Expression>{VenInc_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>VenInc_RowId</SqlRowIdName>
<StreamLocation>^User.DHCVendorInciInfoS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCVendorInciInFo)
	s oldI = +$g(^mdata("DHCVendorInciInFo"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCVendorInciInFo = maxI
	s ^mdata("DHCVendorInciInFo") = maxI
}

Parameter EXTENTSIZE = 250;

}
