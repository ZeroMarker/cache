Class User.DHCCRMFUSDSTemplate Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SDST_RowId, SqlTableName = DHC_CRM_FUSDSTemplate, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On SDSTChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_CRM_FUSDSelect Parent Reference
Relationship SDSTParRef As User.DHCCRMFUSDSelect [ Cardinality = parent, Inverse = ChildDHCCRMFUSDSTemplate, Required, SqlFieldName = SDST_ParRef ];

/// SDST_ChildSub
Property SDSTChildSub As %Library.Float [ InitialExpression = {$i(^DHCCRMFUS($p(%d(0),"||"),"SD",$p(%d(0),"||",2),"SDS",$p(%d(0),"||",3),"SDST",0))}, Required, SqlColumnNumber = 2, SqlFieldName = SDST_ChildSub ];

/// SDST_TextVal
Property SDSTTextVal As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = SDST_TextVal ];

/// SDST_Sequence
Property SDSTSequence As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = SDST_Sequence ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterDHCCRMFUS">
<Data name="SDST_Sequence">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SDST_TextVal">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCCRMFUS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_CRM_FUSubject.FUS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHC_CRM_FUSDetail.SD_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>DHC_CRM_FUSDSelect.SDS_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L7}</Expression>
<Field>SDST_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_CRM_FUSubject.FUS_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"SD"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DHC_CRM_FUSDetail.SD_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>"SDS"</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{DHC_CRM_FUSDSelect.SDS_ChildSub}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>"SDST"</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>{SDST_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexSequence">
<Global>^DHCCRMFUS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_CRM_FUSubject.FUS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>DHC_CRM_FUSDetail.SD_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>DHC_CRM_FUSDSelect.SDS_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L7}</Expression>
<Field>SDST_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"SDST_Sequence"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DHC_CRM_FUSubject.FUS_RowId}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHC_CRM_FUSDetail.SD_ChildSub}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{DHC_CRM_FUSDSelect.SDS_ChildSub}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{SDST_Sequence}</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>{SDST_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCCRMFUSDSTemplateS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
