Class User.DHCMedInfPosSubDIA Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MPOSD_Rowid, SqlTableName = DHC_MedInfPosSubDIA, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On MPOSDChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_MedInfPosition Parent Reference
Relationship MPOSDParRef As User.DHCMedInfPosition [ Cardinality = parent, Inverse = ChildDHCMedInfPosSubDIA, Required, SqlFieldName = MPOSD_ParRef ];

/// Child subscript
Property MPOSDChildSub As %Library.Float [ InitialExpression = {$i(^DHCMPOS($p(%d(0),$c(1),1),"D",0))}, Required, SqlColumnNumber = 2, SqlFieldName = MPOSD_ChildSub ];

/// MPOSD_ActiveFlag
Property MPOSDActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 3, SqlFieldName = MPOSD_ActiveFlag ];

/// MPOSD_MIDIA_DR
Property MPOSDMIDIADR As User.DHCMedInfDiagnose [ SqlColumnNumber = 4, SqlFieldName = MPOSD_MIDIA_DR ];

/// MPOSD_Demo
Property MPOSDDemo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = MPOSD_Demo ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterMap">
<Data name="MPOSD_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MPOSD_Demo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MPOSD_MIDIA_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCMPOS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_MedInfPosition.MPOS_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>MPOSD_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_MedInfPosition.MPOS_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"D"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MPOSD_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCMedInfPosSubDIAS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
