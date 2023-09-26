Class User.DHCMDTCareProv Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MD_RowID, SqlTableName = DHC_MDTCareProv, StorageStrategy = SQLStorage ]
{

/// 分组指针  MD_Group_Dr
Property MDGroupDr As User.DHCMDTGroup [ SqlColumnNumber = 2, SqlFieldName = MD_Group_Dr ];

/// 号别科室  MD_Loc_Dr 
Property MDLocDr As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = MD_Loc_Dr ];

/// 医护资源表  MD_Care_Dr 
Property MDCareDr As User.CTCareProv [ SqlColumnNumber = 4, SqlFieldName = MD_Care_Dr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCMDTCP)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MD_Care_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MD_Group_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MD_Loc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCMDTCP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MD_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{MD_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexGroup">
<Global>^DHCMDTCP</Global>
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
<StreamLocation>^User.DHCMDTCareProvS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
