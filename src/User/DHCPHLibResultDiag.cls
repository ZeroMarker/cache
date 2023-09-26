/// 名称: 药品业务表 检验结果辅助诊断
/// 编写者:基础数据平台组-高姗姗
/// 编写日期: 2017-3-23
Class User.DHCPHLibResultDiag Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = PLRD_RowId, SqlTableName = DHC_PHLibResultDiag, StorageStrategy = SQLStorage ]
{

/// PLRD_RowId  ^DHCPHLRD
Property PLRDInstDr As DHCPHInstructions [ SqlColumnNumber = 2, SqlFieldName = PLRD_Inst_Dr ];

Property PLRDNormal As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PLRD_Normal ];

Property PLRDHigh As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PLRD_High ];

Property PLRDLow As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PLRD_Low ];

Property PLRDNegative As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PLRD_Negative ];

Property PLRDPositive As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = PLRD_Positive ];

Property PLRDOther As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = PLRD_Other ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCPHLRD(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PLRD_High">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PLRD_Inst_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PLRD_Low">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PLRD_Negative">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PLRD_Normal">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PLRD_Other">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PLRD_Positive">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCPHLRD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PLRD_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PLRD_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="InstIndex">
<Global>^DHCPHLRD</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PLRD_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Inst"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PLRD_Inst_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PLRD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PLRD_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPHLibResultDiagS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
