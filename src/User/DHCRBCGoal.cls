Class User.DHCRBCGoal Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DRG_RowID, SqlTableName = DHCRBC_Goal, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DRG_Oeorditem_DR
Property DRGArcItmMastDR As User.ARCItmMast [ SqlColumnNumber = 2, SqlFieldName = DRG_ArcItmMast_DR ];

/// DRG_GoalDesc
Property DRGGoalDesc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DRG_GoalDesc ];

/// DRG_PAADM_DR
Property DRGPAADMDR As User.PAAdm [ SqlColumnNumber = 4, SqlFieldName = DRG_PAADM_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBCApp("GLOBAL"))</SqlIdExpression>
<SQLMap name="IndexPaadmdr">
<Global>^DHCRBAppi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DRG_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Goal-Paadm"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRG_PAADM_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DRG_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterDataIndex">
<Data name="DRG_ArcItmMast_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DRG_GoalDesc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DRG_PAADM_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCRBCApp</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DRG_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"GLOBAL"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRG_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexorder">
<Global>^DHCRBAppi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DRG_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Goal-orditem"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRG_ArcItmMast_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DRG_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCGoalS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
