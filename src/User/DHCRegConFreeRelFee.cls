Class User.DHCRegConFreeRelFee Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = RCFR_RowId, SqlTableName = DHC_RegConFreeRelFee, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On RCFRChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_RegConFree Parent Reference
Relationship RCFRParRef As User.DHCRegConFree [ Cardinality = parent, Inverse = ChildDHCRegConFreeRelFee, Required, SqlFieldName = RCFR_ParRef ];

/// RCFR_ChildSub
Property RCFRChildSub As %Library.Float(MINVAL = 1) [ InitialExpression = {$i(^DHCRCF($p(%d(0),$c(1)),0))}, Required, SqlColumnNumber = 2, SqlFieldName = RCFR_ChildSub ];

/// RCFR_ARCIM_Dr
Property RCFRARCIMDr As User.ARCItmMast [ SqlColumnNumber = 3, SqlFieldName = RCFR_ARCIM_Dr ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="MasterIndex">
<Data name="RCFR_ARCIM_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCRCF</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_RegConFree.RCF_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>RCFR_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_RegConFree.RCF_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Free"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{RCFR_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRegConFreeRelFeeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
