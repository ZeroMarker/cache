Class User.PHAINMenuConfigItm Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PIMCI_RowID, SqlTableName = PHAIN_MenuConfigItm, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On PIMCIChildSub [ IdKey, PrimaryKey, Unique ];

Relationship PIMCIPIMCParRef As User.PHAINMenuConfig [ Cardinality = parent, Inverse = ChildPHAINMenuConfigItm, Required, SqlFieldName = PIMCI_PIMC_ParRef ];

Property PIMCIChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = PIMCI_ChildSub ];

Property PIMCIMobMenuDR As User.PHAINMobMenu [ SqlColumnNumber = 3, SqlFieldName = PIMCI_MobMenu_DR ];

Property PIMCISort As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 4, SqlFieldName = PIMCI_Sort ];

Storage SQLStorage
{
<SQLMap name="DataMaster">
<Data name="PIMCI_MobMenu_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PIMCI_Sort">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^CF.PHA.IN.MenuConfig</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHAIN_MenuConfig.PIMC_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PIMCI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHAIN_MenuConfig.PIMC_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PIMCI_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.PHAINMenuConfigItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
