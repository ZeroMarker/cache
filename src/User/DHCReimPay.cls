/// 报销支付单
Class User.DHCReimPay Extends (%Persistent, User.Abstract) [ SqlRowIdName = RP_RowId, SqlTableName = DHC_ReimPay, StorageStrategy = SQLStorage ]
{

Relationship ChildDHCReimPayInv As User.DHCReimPayInv [ Cardinality = children, Inverse = RPIRPParRef ];

/// 单号
Property RPNo As %Library.String [ Required, SqlColumnNumber = 2, SqlFieldName = RP_No ];

/// 制单日期
Property RPCreateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = RP_CreateDate ];

/// 制单时间
Property RPCreateTime As %Library.Time [ SqlColumnNumber = 4, SqlFieldName = RP_CreateTime ];

/// 科室
Property RPCTLocDR As User.CTLoc [ SqlColumnNumber = 5, SqlFieldName = RP_CTLoc_DR ];

/// 完成标志
Property RPCompleted As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = RP_Completed ];

/// 制单人
Property RPCreateUser As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = RP_CreateUser ];

/// 审核日期
Property RPAduitDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = RP_AduitDate ];

/// 制单时间
Property RPAduitTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = RP_AduitTime ];

/// 审核标志
Property RPAduit As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = RP_Aduit ];

/// 审核人
Property RPAduitUser As User.SSUser [ SqlColumnNumber = 11, SqlFieldName = RP_AduitUser ];

/// 凭证号
Property RPAcctVoucherNo As %Library.String [ SqlColumnNumber = 12, SqlFieldName = RP_AcctVoucherNo ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCREIMPAY)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="RP_AcctVoucherNo">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="RP_Aduit">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="RP_AduitDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="RP_AduitTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="RP_AduitUser">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="RP_CTLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="RP_Completed">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="RP_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RP_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RP_CreateUser">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="RP_No">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCREIMPAY</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{RP_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLoc">
<Global>^DHCREIMPAY</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Loc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RP_CTLoc_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexNo">
<Global>^DHCREIMPAY</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"No"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RP_No}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>RP_RowId</SqlRowIdName>
<StreamLocation>^User.DHCReimPayS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCREIMPAY)
	s oldI = +$g(^mdata("DHCREIMPAY"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCREIMPAY = maxI
	s ^mdata("DHCREIMPAY") = maxI
}

}
