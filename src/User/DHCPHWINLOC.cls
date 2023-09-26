Class User.DHCPHWINLOC Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHWL_RowId, SqlTableName = DHC_PHWINLOC, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PHWLChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_PHWINDOW Parent Reference
Relationship PHWLParRef As User.DHCPHWINDOW [ Cardinality = parent, Inverse = ChildDHCPHWINLOC, Required, SqlFieldName = PHWL_ParRef ];

/// PHWL_ChildSub
Property PHWLChildSub As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = PHWL_ChildSub ];

/// PHWL_CTLOC_DR
Property PHWLCTLOCDR As User.CTLoc [ SqlColumnNumber = 5, SqlFieldName = PHWL_CTLOC_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="PHWLMASTER">
<Data name="PHWL_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCPHWINL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PHWINDOW.PHW_ROWID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PHWL_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_PHWINDOW.PHW_ROWID}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHWL_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHWINLOCS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
