Class User.DHCPhaCollectOutDrugDet Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PCODL_Rowid, SqlTableName = DHC_PhaCollectOutDrugDet, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PCODLChildsub [ IdKey, PrimaryKey, Unique ];

/// DHC_PhaCollectOutDrug Parent Reference
Relationship PCODLPCODParref As User.DHCPhaCollectOutDrug [ Cardinality = parent, Inverse = ChildDHCPhaCollectOutDrugDet, Required, SqlFieldName = PCODL_PCOD_Parref ];

/// PCODL_Childsub
Property PCODLChildsub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = PCODL_Childsub ];

/// PCODL_PHAC_DR User.DHCPHACollected 
Property PCODLPHACIDR As User.DHCPHACollected [ SqlColumnNumber = 3, SqlFieldName = PCODL_PHACI_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterPCODL">
<Data name="PCODL_PHACI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCPCOD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PhaCollectOutDrug.PCOD_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PCODL_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_PhaCollectOutDrug.PCOD_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"L"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PCODL_Childsub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPhaCollectOutDrugDetS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
