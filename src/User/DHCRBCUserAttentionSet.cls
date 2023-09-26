Class User.DHCRBCUserAttentionSet Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DUAS_RowID, SqlTableName = DHCRBC_UserAttentionSet, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DUAS_User_DR
Property DUASUserDR As User.SSUser [ SqlColumnNumber = 2, SqlFieldName = DUAS_User_DR ];

/// DUAS_ArcItmMast_DR
Property DUASArcItmMastDR As User.ARCItmMast [ SqlColumnNumber = 3, SqlFieldName = DUAS_ArcItmMast_DR ];

/// DUAS_AppLoc_DR
Property DUASAppLocDR As User.CTLoc [ SqlColumnNumber = 4, SqlFieldName = DUAS_AppLoc_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBCUserAttentionSet)</SqlIdExpression>
<SQLMap name="IndexUser">
<Global>^DHCRBCUserAttentionSeti</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DUAS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"USER"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DUAS_User_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DUAS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMap">
<Data name="DUAS_AppLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DUAS_ArcItmMast_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DUAS_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCRBCUserAttentionSet</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DUAS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DUAS_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCUserAttentionSetS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
