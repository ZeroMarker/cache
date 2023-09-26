Class User.DHCOECAction Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ACTI_RowId, SqlTableName = DHC_OECAction, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On (ACTIACTParRef, ACTIChildSub) [ IdKey, PrimaryKey, Unique ];

/// ACTI_ACT_ParRef
Property ACTIACTParRef As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ACTI_ACT_ParRef ];

/// ACTI_ChildSub
Property ACTIChildSub As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ InitialExpression = {$i(^OEC("ACT",$p(%d(3),$c(1),1),"Item",0))}, Required, SqlColumnNumber = 4, SqlFieldName = ACTI_ChildSub ];

/// ACTI_ARCIM_DR
Property ACTIARCIMDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = ACTI_ARCIM_DR ];

/// ACTI_Qty
Property ACTIQty As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = ACTI_Qty ];

/// ACTIInstrDR
Property ACTIInstrDR As PHCInstruc [ SqlColumnNumber = 7, SqlFieldName = ACTI_Instr_DR ];

/// ACTIHospDR
Property ACTIHospDR As CTHospital [ SqlColumnNumber = 8, SqlFieldName = ACTI_Hosp_DR ];

/// ACTIDoseQty
Property ACTIDoseQty As %String [ SqlColumnNumber = 9, SqlFieldName = ACTI_DoseQty ];

/// ACTIDoseUomDR
Property ACTIDoseUomDR As CTHospital [ SqlColumnNumber = 10, SqlFieldName = ACTI_DoseUom_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="MasterData">
<Data name="ACTI_ARCIM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ACTI_DoseQty">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ACTI_DoseUom_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ACTI_Hosp_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ACTI_Instr_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ACTI_Qty">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^OEC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ACTI_ACT_ParRef</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>ACTI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"ACT"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{ACTI_ACT_ParRef}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"Item"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{ACTI_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCOECActionS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
