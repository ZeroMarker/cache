Class User.DHCMedDepGroupArcim Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MDGA_Rowid, SqlTableName = DHC_MedDepGroupArcim, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On MDGAChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_MedDepGroup Parent Reference
Relationship MDGAParRef As User.DHCMedDepGroup [ Cardinality = parent, Inverse = ChildDHCMedDepGroupArcim, Required, SqlFieldName = MDGA_ParRef ];

/// Child subscript
Property MDGAChildSub As %Library.Float [ InitialExpression = {$i(^DHCMDG($p(%d(0),$c(1),1),"A",0))}, Required, SqlColumnNumber = 2, SqlFieldName = MDGA_ChildSub ];

/// MDGA_ActiveFlag
Property MDGAActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 3, SqlFieldName = MDGA_ActiveFlag ];

/// MDGA_Arcim_DR
Property MDGAArcimDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = MDGA_Arcim_DR ];

/// MDGA_Demo
Property MDGADemo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = MDGA_Demo ];

/// MDGA_Points
Property MDGAPoints As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = MDGA_Points ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterMap">
<Data name="MDGA_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MDGA_Arcim_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MDGA_Demo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MDGA_Points">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCMDG</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_MedDepGroup.MDG_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>MDGA_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_MedDepGroup.MDG_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"A"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MDGA_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCMedDepGroupArcimS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
