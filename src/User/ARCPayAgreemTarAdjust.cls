/// ARC PayAgreem Tariff Adjust(1419)
Class User.ARCPayAgreemTarAdjust Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_PayAgreemTarAdjust, StorageStrategy = SQLStorage ]
{

/// Adjustment (%)
Property ADJAdjustment As %Float(MAXVAL = 100, MINVAL = -100) [ Required, SqlColumnNumber = 6, SqlFieldName = ADJ_Adjustment ];

/// Des Ref BillGrp
Property ADJBillGrpDR As ARCBillGrp [ SqlColumnNumber = 5, SqlFieldName = ADJ_BillGrp_DR ];

/// Childsub
Property ADJChildsub As %Float [ InitialExpression = {$i(^ARC("PAY",$p($s($d(initvalue):initvalue,1:%d(0)),"||"),"TAR",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"ADJ",0))}, SqlColumnNumber = 2, SqlFieldName = ADJ_Childsub ];

/// Date From
Property ADJDateFrom As %Date [ Required, SqlColumnNumber = 3, SqlFieldName = ADJ_DateFrom ];

/// Date To
Property ADJDateTo As %Date [ SqlColumnNumber = 4, SqlFieldName = ADJ_DateTo ];

/// Max Amt Covered
Property ADJMaxAmtCovered As %Float [ SqlColumnNumber = 8, SqlFieldName = ADJ_MaxAmtCovered ];

/// ARC_PayAgreemTariff Parent Reference
Relationship ADJParRef As ARCPayAgreemTariff [ Cardinality = parent, Inverse = ChildARCPayAgreemTarAdjust, Required, SqlFieldName = ADJ_ParRef ];

/// Payor Share
Property ADJPayorShare As %Float [ SqlColumnNumber = 7, SqlFieldName = ADJ_PayorShare ];

/// Type
Property ADJType As %String(DISPLAYLIST = ",Insurance,Patient", MAXLEN = 9, TRUNCATE = 1, VALUELIST = ",I,P") [ SqlColumnNumber = 9, SqlFieldName = ADJ_Type ];

Relationship ChildARCPayAgreemTarAdjBillSub As ARCPayAgreemTarAdjBillSub [ Cardinality = children, Inverse = BSParRef ];

Index RowIDBasedIDKeyIndex On ADJChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCPayAgreemTarAdjust).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCPayAgreemTarAdjust","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCPayAgreemTarAdjust).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCPayAgreemTarAdjust","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCPayAgreemTarAdjust).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCPayAgreemTarAdjust","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCPayAgreemTarAdjust).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCPayAgreemTarAdjust","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCPayAgreemTarAdjust).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCPayAgreemTarAdjust","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ADJ_Adjustment">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ADJ_BillGrp_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ADJ_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ADJ_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ADJ_MaxAmtCovered">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ADJ_PayorShare">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ADJ_Type">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^ARC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ARC_PaymentAgreement.PAY_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>ARC_PayAgreemTariff.TAR_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>ADJ_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PAY"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_PaymentAgreement.PAY_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"TAR"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARC_PayAgreemTariff.TAR_Childsub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"ADJ"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ADJ_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBillGrp">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ARC_PaymentAgreement.PAY_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>ARC_PayAgreemTariff.TAR_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L10}</Expression>
<Field>ADJ_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PAY"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_PaymentAgreement.PAY_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"TAR"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARC_PayAgreemTariff.TAR_Childsub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"ADJ"</Expression>
</Subscript>
<Subscript name="6">
<Expression>0</Expression>
</Subscript>
<Subscript name="7">
<Expression>"BillGrp"</Expression>
</Subscript>
<Subscript name="8">
<Expression>{ADJ_BillGrp_DR}</Expression>
</Subscript>
<Subscript name="9">
<Expression>{ADJ_DateFrom}</Expression>
</Subscript>
<Subscript name="10">
<Expression>{ADJ_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ADJ_RowId</SqlRowIdName>
<StreamLocation>^User.ARCPayAgreemTarAdjustS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
