Class User.DHCMedDepGroupDIA Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MDGD_Rowid, SqlTableName = DHC_MedDepGroupDIA, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On MDGDChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_MedDepGroup Parent Reference
Relationship MDGDParRef As User.DHCMedDepGroup [ Cardinality = parent, Inverse = ChildDHCMedDepGroupDIA, Required, SqlFieldName = MDGD_ParRef ];

/// Child subscript
Property MDGDChildSub As %Library.Float [ InitialExpression = {$i(^DHCMDG($p(%d(0),$c(1),1),"D",0))}, Required, SqlColumnNumber = 2, SqlFieldName = MDGD_ChildSub ];

/// MDGD_ActiveFlag
Property MDGDActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 3, SqlFieldName = MDGD_ActiveFlag ];

/// MDGD_MIDIA_DR
Property MDGDMIDIADR As User.DHCMedInfDiagnose [ SqlColumnNumber = 4, SqlFieldName = MDGD_MIDIA_DR ];

/// MDGD_Demo
Property MDGDDemo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = MDGD_Demo ];

/// MDGD_Points
Property MDGDPoints As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = MDGD_Points ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterMap">
<Data name="MDGD_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MDGD_Demo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MDGD_MIDIA_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MDGD_Points">
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
<Field>MDGD_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_MedDepGroup.MDG_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"D"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MDGD_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCMedDepGroupDIAS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
