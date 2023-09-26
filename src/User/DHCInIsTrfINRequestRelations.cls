Class User.DHCInIsTrfINRequestRelations Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ITIR_Rowid, SqlTableName = DHC_InIsTrfINRequestRelations, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

// ITIR_Rowid

Index RowIDBasedIDKeyIndex On ITIRChildsub [ IdKey, PrimaryKey, Unique ];

/// DHC_StkCatGroup Parent Reference
Relationship ITIRISTRParref As User.DHCInIsTrf [ Cardinality = parent, Inverse = ChildDHCInIsTrfINRequestRelations, Required, SqlFieldName = ITIR_ISTR_Parref ];

/// ITIR_RequsetDR
Property ITIRRequsetDR As User.INRequest [ SqlColumnNumber = 3, SqlFieldName = ITIR_RequsetDR ];

/// ITIR_Childsub
Property ITIRChildsub As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = ITIR_Childsub ];

Index ITIRRequsetDRUnqIdx1 On ITIRRequsetDR;

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterDHCITIR">
<Data name="ITIR_RequsetDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCITIR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_InIsTrf.INIT_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ITIR_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHC_InIsTrf.INIT_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"IR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{ITIR_Childsub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCInIsTrfINRequestRelationsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
