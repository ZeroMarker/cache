/// 科室物资维修记录表
Class User.DHCLocMaintain Extends (%Persistent, User.Abstract) [ SqlRowIdName = DHCLM_Rowid, SqlTableName = DHC_LocMaintain, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCLocMaintainItm As User.DHCLocMaintainItm [ Cardinality = children, Inverse = DHCLMParref ];

Property DHCLMINCIDR As User.INCItm [ SqlColumnNumber = 2, SqlFieldName = DHCLM_INCI_DR ];

Property DHCLMBarcode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DHCLM_Barcode ];

Property DHCLMCTUOMDR As User.CTUOM [ SqlColumnNumber = 4, SqlFieldName = DHCLM_CTUOM_DR ];

Property DHCLMRp As %Library.Float(MAXVAL = 9999999999999999, MINVAL = 0) [ SqlColumnNumber = 5, SqlFieldName = DHCLM_Rp ];

Property DHCLMSp As %Library.Float(MAXVAL = 9999999999999999, MINVAL = 0) [ SqlColumnNumber = 6, SqlFieldName = DHCLM_Sp ];

Property DHCLMCurrLocDR As User.CTLoc [ SqlColumnNumber = 7, SqlFieldName = DHCLM_CtLoc_DR ];

Property DHCLMStatus As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = DHCLM_Status ];

Property DHCLMCreateDate As %Library.Date [ SqlColumnNumber = 9, SqlFieldName = DHCLM_CreateDate ];

Property DHCLMCreateTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = DHCLM_CreateTime ];

Property DHCLMCreateUser As User.SSUser [ SqlColumnNumber = 11, SqlFieldName = DHCLM_CreateUser ];

Property DHCLMRemarks As list Of %Library.String(COLLATION = "AlphaUp", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = DHCLM_Remarks, SqlListType = SUBNODE ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCLM)</SqlIdExpression>
<SQLMap name="IndexBarcode">
<Global>^DHCLM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>{DHCLM_Rowid}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BARCODE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCLM_Barcode}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCLM_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocInci">
<Global>^DHCLM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>{DHCLM_Rowid}</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"LOCINCI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{DHCLM_CtLoc_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHCLM_INCI_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{DHCLM_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMap">
<Data name="DHCLM_Barcode">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHCLM_CTUOM_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DHCLM_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DHCLM_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DHCLM_CreateUser">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DHCLM_CtLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DHCLM_INCI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHCLM_Remarks">
<Node>"REM"</Node>
</Data>
<Data name="DHCLM_Rp">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DHCLM_Sp">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DHCLM_Status">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Global>^DHCLM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHCLM_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHCLM_Rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>DHCLM_Rowid</SqlRowIdName>
<StreamLocation>^User.DHCLocMaintainS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCLM)
	s oldI = +$g(^mdata("DHCLOCMAIN"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCLM = maxI
	s ^mdata("DHCLOCMAIN") = maxI
}

}
