/// 名称: 诊断与症状知识字典关联表
/// 编写者:基础数据平台组-谷雪萍
/// 编写日期: 2016-7-18
Class User.DHCPHDisLinkSym Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlRowIdName = LSY_RowId, SqlTableName = DHC_PHDisLinkSym, StorageStrategy = SQLStorage ]
{

/// ^DHCPHDLSY
Property LSYIcdDr As DHCExtIcdFeild [ SqlColumnNumber = 2, SqlFieldName = LSY_Icd_Dr ];

Property LSYSymDr As DHCPHSymptom [ SqlColumnNumber = 3, SqlFieldName = LSY_Sym_Dr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCPHDLSY(0))</SqlIdExpression>
<SQLMap name="ICDIndex">
<Global>^DHCPHDLSY</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>LSY_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ICD"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LSY_Icd_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LSY_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="LSY_Icd_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="LSY_Sym_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPHDLSY</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>LSY_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{LSY_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="SYMIndex">
<Global>^DHCPHDLSY</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>LSY_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SYM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LSY_Sym_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LSY_Icd_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{LSY_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>LSY_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPHDisLinkSymS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
