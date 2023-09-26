/// xiaowenwu 2020-03-06 MDT随访次数维护表
Class User.DHCMDTFolUpTimes Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MD_RowID, SqlTableName = DHC_MDTFolUpTimes, StorageStrategy = NewStorage1 ]
{

/// 关联表ID
Property MDGroupDr As User.DHCMDTGroup [ SqlFieldName = MD_Group_Dr ];

Property MDTimes As %Integer [ SqlFieldName = MD_Times ];

Property MDInterval As %Integer [ SqlFieldName = MD_Interval ];

Storage NewStorage1
{
<SqlIdExpression>$i(^DHCMDTFUT(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MD_Group_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MD_Interval">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MD_Times">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCMDTFUT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MD_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{MD_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexGroup">
<Global>^DHCMDTFUT</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MD_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Group"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MD_Group_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCMDTFolUpTimesS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
