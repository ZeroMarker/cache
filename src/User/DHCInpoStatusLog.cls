Class User.DHCInpoStatusLog Extends (%Library.Persistent, User.Abstract) [ SqlRowIdName = IPSL_RowId, SqlTableName = DHC_InpoStatusLog, StorageStrategy = SQLStorage ]
{

/// 订单明细ID
Property IPSLInpoiDr As User.INPOItm [ SqlColumnNumber = 2, SqlFieldName = IPSL_Inpoi_Dr ];

/// 状态描述
Property IPSLStatusDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = IPSL_StatusDesc ];

/// 状态改变日期
Property IPSLStatusdChangeDate As %Date [ Required, SqlColumnNumber = 4, SqlFieldName = IPSL_StatusdChangeDate ];

/// 同步状态日期
Property IPSLSynDate As %Date [ Required, SqlColumnNumber = 5, SqlFieldName = IPSL_SynDate ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCIPSL(0))</SqlIdExpression>
<SQLMap name="DataMater">
<Data name="IPSL_Inpoi_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="IPSL_StatusDesc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="IPSL_StatusdChangeDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="IPSL_SynDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCIPSL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>IPSL_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{IPSL_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="Indexinpostate">
<Global>^DHCIPSL</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IPSL_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INPO"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IPSL_Inpoi_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IPSL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>IPSL_RowId</SqlRowIdName>
<StreamLocation>^User.DHCInpoStatusLogS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
