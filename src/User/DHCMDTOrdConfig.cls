Class User.DHCMDTOrdConfig Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MD_RowID, SqlTableName = DHC_MDTOrdConfig, StorageStrategy = SQLStorage ]
{

/// 分组指针  MD_Group_Dr
Property MDGroupDr As User.DHCMDTGroup [ SqlColumnNumber = 2, SqlFieldName = MD_Group_Dr ];

/// 医嘱ID  MC_ArcItem_Dr 
Property MDArcItemDr As User.ARCItmMast [ SqlColumnNumber = 3, SqlFieldName = MD_ArcItem_Dr ];

/// 医嘱数量  MD_OrdNum 
Property MDOrdNum As %Library.Integer [ SqlColumnNumber = 4, SqlFieldName = MD_OrdNum ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCMDTOC)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MD_ArcItem_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MD_Group_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MD_OrdNum">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCMDTOC</Global>
<PopulationType>nonnull</PopulationType>
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
<Global>^DHCMDTOC</Global>
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
<StreamLocation>^User.DHCMDTOrdConfigS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
