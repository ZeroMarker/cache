Class User.DHCMedDepGroupSub Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MDGS_Rowid, SqlTableName = DHC_MedDepGroupSub, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On MDGSChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_MedDepGroup Parent Reference
Relationship MDGSParRef As User.DHCMedDepGroup [ Cardinality = parent, Inverse = ChildDHCMedDepGroupSub, Required, SqlFieldName = MDGS_ParRef ];

/// Child subscript
Property MDGSChildSub As %Library.Float [ InitialExpression = {$i(^mdata("DHCMEDDEPGROUPSUB"))}, Required, SqlColumnNumber = 2, SqlFieldName = MDGS_ChildSub ];

/// MDGS_Low
Property MDGSLow As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = MDGS_Low ];

/// MDGS_High
Property MDGSHigh As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = MDGS_High ];

/// MDGS_Color
Property MDGSColor As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = MDGS_Color ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterMap">
<Data name="MDGS_Color">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MDGS_High">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MDGS_Low">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCMDG</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_MedDepGroup.MDG_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>MDGS_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_MedDepGroup.MDG_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"S"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MDGS_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCMedDepGroupSubS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
