/// PatBillClaim(2547)
Class User.ARPatBillClaim Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = AR_PatBillClaim, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On CLChildsub [ IdKey, PrimaryKey, Unique ];

/// AR_PatientBill Parent Reference
Relationship CLParRef As ARPatientBill [ Cardinality = parent, Inverse = ChildARPatBillClaim, Required, SqlFieldName = CL_ParRef ];

/// Childsub
Property CLChildsub As %Float [ InitialExpression = {$i(^ARPBL($p(%d(0),$c(1)),"CL",0))}, SqlColumnNumber = 2, SqlFieldName = CL_Childsub ];

/// Des Ref BillGrp
Property CLBillGrpDR As ARCBillGrp [ SqlColumnNumber = 3, SqlFieldName = CL_BillGrp_DR ];

/// Des Ref BillSub
Property CLBillSubDR As ARCBillSub [ SqlColumnNumber = 4, SqlFieldName = CL_BillSub_DR ];

/// Des Ref ARCIM
Property CLARCIMDR As ARCItmMast [ SqlColumnNumber = 5, SqlFieldName = CL_ARCIM_DR ];

/// ClaimAmount
Property CLClaimAmount As %Float [ SqlColumnNumber = 6, SqlFieldName = CL_ClaimAmount ];

/// Des Ref BillItem
Property CLBillItemDR As OEOrdItem [ SqlColumnNumber = 7, SqlFieldName = CL_BillItem_DR ];

/// Selected
Property CLSelected As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = CL_Selected ];

/// BillAmount
Property CLBillAmount As %Float [ SqlColumnNumber = 9, SqlFieldName = CL_BillAmount ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="CL_ARCIM_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CL_BillAmount">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CL_BillGrp_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CL_BillItem_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CL_BillSub_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CL_ClaimAmount">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CL_Selected">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^ARPBL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AR_PatientBill.ARPBL_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>CL_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{AR_PatientBill.ARPBL_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CL"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CL_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>CL_RowId</SqlRowIdName>
<StreamLocation>^User.ARPatBillClaimS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
