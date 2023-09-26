Class User.DHCAppTreeGroup Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlTableName = DHC_AppTreeGroup, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On TRAChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_AppTreeGroup Parent Reference TRA_Link_ParRef
Relationship TRALinkParRef As User.DHCAppTreeLink [ Cardinality = parent, Inverse = ChildDHCAPPTREEGROUP, Required, SqlFieldName = TRA_Link_ParRef ];

/// TRA_ChildSub
Property TRAChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = TRA_ChildSub ];

/// TRA_GroupDR
Property TRAGroupDR As User.SSGroup [ SqlColumnNumber = 3, SqlFieldName = TRA_GroupDR ];

/// TRA_IsAuth
Property TRAIsAuth As %Library.String(COLLATION = "Exact", MAXLEN = 1, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = TRA_IsAuth ];

Storage SQLStorage
{
<SQLMap name="DataMaster">
<Data name="TRA_GroupDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TRA_IsAuth">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCAPPTRA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_AppTreeAdd.TRA_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHC_AppTreeLink.TRA_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>TRA_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_AppTreeAdd.TRA_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_AppTreeLink.TRA_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"G"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TRA_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexTreeGroup">
<Global>^DHCAPPTRA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_AppTreeAdd.TRA_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DHC_AppTreeLink.TRA_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>TRA_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TreeGroup"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TRA_GroupDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_AppTreeAdd.TRA_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHC_AppTreeLink.TRA_ChildSub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{TRA_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>TRA_RowID</SqlRowIdName>
<StreamLocation>^User.DHCAppTreeGroupS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
