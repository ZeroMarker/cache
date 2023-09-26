Class User.DHCRefuseReqLocItm Extends (%Persistent, User.Abstract) [ SqlRowIdName = RFU_RowId, SqlTableName = DHC_RefuseReqLocItm, StorageStrategy = SQLStorage ]
{

Property RFUFrLocDR As User.CTLoc [ SqlColumnNumber = 2, SqlFieldName = RFU_FrLoc_DR ];

Property RFUToLocDR As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = RFU_ToLoc_DR ];

Property RFUINCIDR As User.INCItm [ SqlColumnNumber = 4, SqlFieldName = RFU_INCI_DR ];

Property RFUDateFrom As %Library.Date [ SqlColumnNumber = 5, SqlFieldName = RFU_DateFrom ];

Property RFUDateTo As %Library.Date [ SqlColumnNumber = 6, SqlFieldName = RFU_DateTo ];

Property RFURemark As %String [ SqlColumnNumber = 7, SqlFieldName = RFU_Remark ];

Property RFUUseFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = RFU_UseFlag ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCRFUREQ)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="RFU_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="RFU_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="RFU_FrLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RFU_INCI_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RFU_Remark">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="RFU_ToLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RFU_UseFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCRFUREQ</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RFU_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{RFU_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexFrLoc">
<Global>^DHCRFUREQ</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RFU_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"FTI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{RFU_FrLoc_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{RFU_ToLoc_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{RFU_INCI_DR}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>{RFU_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInciLoc">
<Global>^DHCRFUREQ</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>FRU_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"FIT"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{RFU_FrLoc_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{RFU_INCI_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{RFU_ToLoc_DR}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>{RFU_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>RFU_RowId</SqlRowIdName>
<StreamLocation>^User.DHCRefuseReqLocItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCRFUREQ)
	s oldI = +$g(^mdata("DHCREFUSEREQLOCITM"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCRFUREQ = maxI
	s ^mdata("DHCREFUSEREQLOCITM") = maxI
}

}
