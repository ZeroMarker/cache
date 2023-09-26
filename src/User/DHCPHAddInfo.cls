/// 名称: 注意事项、不良反应表 
/// 编写者:基础数据平台组-谷雪萍
/// 编写日期: 2014-12-15
Class User.DHCPHAddInfo Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = PDAI_RowId, SqlTableName = DHC_PHAddInfo, StorageStrategy = SQLStorage ]
{

/// PDA_RowId  ^DHCPHDISAGE
Property PDAIInstDr As DHCPHInstructions [ SqlColumnNumber = 5, SqlFieldName = PDAI_Inst_Dr ];

Property PDAICode As %String [ SqlColumnNumber = 2, SqlFieldName = PDAI_Code ];

Property PDAIText As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PDAI_Text ];

Property PDAIOrdNum As %Float [ SqlColumnNumber = 4, SqlFieldName = PDAI_OrdNum ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCPHADDI(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PDAI_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PDAI_Inst_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PDAI_OrdNum">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PDAI_Text">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPHADDI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PDAI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PDAI_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="InstIndex">
<Global>^DHCPHADDI</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PDAI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Inst"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDAI_Inst_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PDAI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PDAI_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPHAddInfoS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
