Class User.DHCMedEpidemicSub Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MEPDS_Rowid, SqlTableName = DHC_MedEpidemicSub, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On MEPDSChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_MedEpidemic Parent Reference
Relationship MEPDSParRef As User.DHCMedEpidemic [ Cardinality = parent, Inverse = ChildDHCMedEpidemicSub, Required, SqlFieldName = MEPDS_ParRef ];

/// Child subscript
Property MEPDSChildSub As %Library.Float [ InitialExpression = {$i(^DHCMEPD($p(%d(0),$c(1),1),"I",0))}, Required, SqlColumnNumber = 2, SqlFieldName = MEPDS_ChildSub ];

/// MEPDS_MedDictory_DR
Property MEPDSMedDictoryDR As User.DHCMedDictory [ SqlColumnNumber = 3, SqlFieldName = MEPDS_MedDictory_DR ];

/// MEPDS_Value
Property MEPDSValue As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = MEPDS_Value ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterMap">
<Data name="MEPDS_MedDictory_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MEPDS_Value">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCMEPD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_MedEpidemic.MEPD_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>MEPDS_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_MedEpidemic.MEPD_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MEPDS_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCMedEpidemicSubS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
