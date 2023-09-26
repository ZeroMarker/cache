/// 基础数据平台-临床知识库-溶媒分类明细
Class User.DHCPHMenstruumItm Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlRowIdName = PHMI_RowId, SqlTableName = DHC_PHMenstruumItm, StorageStrategy = SQLStorage ]
{

// ^DHCPHMIT

Property PHMIDrugDr As User.DHCPHProName [ SqlColumnNumber = 2, SqlFieldName = PHMI_Drug_Dr ];

Property PHMIMentDr As User.DHCPHMenstruumCat [ SqlColumnNumber = 3, SqlFieldName = PHMI_Ment_Dr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCPHMIT(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PHMI_Drug_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHMI_Ment_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPHMIT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHMI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{PHMI_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDrug">
<Global>^DHCPHMITi</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHMI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Drug"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHMI_Drug_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHMI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDrugMent">
<Global>^DHCPHMITi</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PHMI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DrugMent"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHMI_Drug_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHMI_Ment_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHMI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMent">
<Global>^DHCPHMITi</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHMI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Ment"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHMI_Ment_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHMI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PHMI_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPHMenstruumItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
