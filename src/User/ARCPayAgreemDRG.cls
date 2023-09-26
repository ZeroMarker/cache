/// ARC Payment Agreem DRG(1761)
Class User.ARCPayAgreemDRG Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_PayAgreemDRG, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On DRGChildsub [ IdKey, PrimaryKey, Unique ];

Relationship ChildARCPayAgreemDRGDetails As ARCPayAgreemDRGDetails [ Cardinality = children, Inverse = DETParRef ];

/// ARC_PaymentAgreement Parent Reference
Relationship DRGParRef As ARCPaymentAgreement [ Cardinality = parent, Inverse = ChildARCPayAgreemDRG, Required, SqlFieldName = DRG_ParRef ];

/// DRG_Childsub
Property DRGChildsub As %Float [ InitialExpression = {$i(^ARC("PAY",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"DRG",0))}, SqlColumnNumber = 2, SqlFieldName = DRG_Childsub ];

/// Des Ref DRGCode
Property DRGDRGCodeDR As MRCDRGCodes [ SqlColumnNumber = 3, SqlFieldName = DRG_DRGCode_DR ];

/// Days
Property DRGDays As %Float [ SqlColumnNumber = 4, SqlFieldName = DRG_Days ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="DRG_DRGCode_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DRG_Days">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^ARC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ARC_PaymentAgreement.PAY_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>DRG_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PAY"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_PaymentAgreement.PAY_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DRG"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DRG_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDRG">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ARC_PaymentAgreement.PAY_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>DRG_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PAY"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_PaymentAgreement.PAY_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DRG"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"DRG"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DRG_DRGCode_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{DRG_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DRG_RowId</SqlRowIdName>
<StreamLocation>^User.ARCPayAgreemDRGS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
