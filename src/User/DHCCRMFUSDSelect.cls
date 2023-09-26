Class User.DHCCRMFUSDSelect Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SDS_RowId, SqlTableName = DHC_CRM_FUSDSelect, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On SDSChildSub [ IdKey, PrimaryKey, Unique ];

Relationship ChildDHCCRMFUSDSTemplate As User.DHCCRMFUSDSTemplate [ Cardinality = children, Inverse = SDSTParRef ];

/// DHC_CRM_FUSDetail Parent Reference
Relationship SDSParRef As User.DHCCRMFUSDetail [ Cardinality = parent, Inverse = ChildDHCCRMFUSDSelect, Required, SqlFieldName = SDS_ParRef ];

/// SDS_ChildSub
Property SDSChildSub As %Library.Float [ InitialExpression = {$i(^DHCCRMFUS(+%d(0),"SD",$p($p(%d(0),$c(1)),"||",2),"SDS",0))}, Required, SqlColumnNumber = 2, SqlFieldName = SDS_ChildSub ];

/// SDS_TextVal
Property SDSTextVal As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = SDS_TextVal ];

/// SDS_Unit
Property SDSUnit As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = SDS_Unit ];

/// SDS_DefaultValue
Property SDSDefaultValue As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = SDS_DefaultValue ];

/// SDS_Sequence
Property SDSSequence As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = SDS_Sequence ];

Property SDSDesc As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = SDS_Desc ];

/// SDS_LinkDetail
Property SDSLinkDetail As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = SDS_LinkDetail ];

/// SDS_ExclusiveDetail
Property SDSExclusiveDetail As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = SDS_ExclusiveDetail ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterDHCCRMFUS">
<Data name="SDS_DefaultValue">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SDS_Desc">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SDS_ExclusiveDetail">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SDS_LinkDetail">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SDS_Sequence">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SDS_TextVal">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SDS_Unit">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
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
<Field>SDS_ChildSub</Field>
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
<Expression>{SDS_ChildSub}</Expression>
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
<Expression>{L6}</Expression>
<Field>SDS_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"SDS_Sequence"</Expression>
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
<Expression>{SDS_Sequence}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{SDS_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCCRMFUSDSelectS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
