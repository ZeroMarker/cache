/// 名称: 重复用药
/// 编写者:基础数据平台组-高姗姗
/// 编写日期: 2017-3-15
Class User.DHCPHRepeatItm Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlRowIdName = PHRI_RowId, SqlTableName = DHC_PHRepeatItm, StorageStrategy = SQLStorage ]
{

/// PHRI_RowId  ^DHCPHRITM
Property PHRIInstDr As DHCPHInstructions [ SqlColumnNumber = 2, SqlFieldName = PHRI_Inst_Dr ];

Property PHRIProDr As DHCPHProName [ SqlColumnNumber = 3, SqlFieldName = PHRI_Pro_Dr ];

Property PHRIRuleDr As DHCPHRepeatFeild [ SqlColumnNumber = 4, SqlFieldName = PHRI_Rule_Dr ];

Property PHRIManage As %String(DISPLAYLIST = ",Warn,Control,Stat", VALUELIST = ",W,C,S") [ SqlColumnNumber = 5, SqlFieldName = PHRI_Manage ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCPHRITM(0))</SqlIdExpression>
<SQLMap name="IndexInst">
<Global>^DHCPHRITM</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHRI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Inst"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHRI_Inst_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHRI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="PHRI_Inst_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHRI_Manage">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHRI_Pro_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHRI_Rule_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCPHRITM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHRI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{PHRI_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PHRI_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPHRepeatItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
