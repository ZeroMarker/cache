/// 名称: 炮制作用表 
/// 编写者:基础数据平台组-高姗姗
/// 编写日期: 2017-3-27
Class User.DHCPHProcessingAct Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlRowIdName = PACT_RowId, SqlTableName = DHC_PHProcessingAct, StorageStrategy = SQLStorage ]
{

/// PACT_RowId  ^DHCPHPACT
Property PACTInstDr As DHCPHInstructions [ SqlColumnNumber = 5, SqlFieldName = PACT_Inst_Dr ];

Property PACTCode As %String [ SqlColumnNumber = 2, SqlFieldName = PACT_Code ];

Property PACTText As %String(COLLATION = "Exact", MAXLEN = 800, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PACT_Text ];

Property PACTOrdNum As %Float [ SqlColumnNumber = 4, SqlFieldName = PACT_OrdNum ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCPHPACT(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PACT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PACT_Inst_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PACT_OrdNum">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PACT_Text">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPHPACT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PACT_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PACT_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexInst">
<Global>^DHCPHPACT</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PACT_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Inst"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PACT_Inst_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PACT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PACT_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPHProcessingActS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
