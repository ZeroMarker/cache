Class User.DHCRBCGroupArcItmMast Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DGA_RowID, SqlTableName = DHCRBC_GroupArcItmMast, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DGA_ItemGroup_DR
Property DGAItemGroupDR As User.DHCRBCItemGroupLocSet [ SqlColumnNumber = 2, SqlFieldName = DGA_ItemGroup_DR ];

/// DGA_ArcItmMast_DR
Property DGAArcItmMastDR As User.ARCItmMast [ SqlColumnNumber = 3, SqlFieldName = DGA_ArcItmMast_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBCGroupArcItmMast)</SqlIdExpression>
<SQLMap name="IndexItmGroup">
<Global>^DHCRBCGroupArcItmMasti</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DGA_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ItmGroup"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DGA_ItemGroup_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DGA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMap">
<Data name="DGA_ArcItmMast_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DGA_ItemGroup_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCRBCGroupArcItmMast</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DGA_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DGA_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCGroupArcItmMastS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
