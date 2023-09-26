/// Pay Agreem Tar Adjust Billsub(1847)
Class User.ARCPayAgreemTarAdjBillSub Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_PayAgreemTarAdjBillSub, StorageStrategy = SQLStorage ]
{

/// Adjustment
Property BSAdjustment As %Float [ SqlColumnNumber = 6, SqlFieldName = BS_Adjustment ];

/// Des Ref BillSub
Property BSBillSubDR As ARCBillSub [ SqlColumnNumber = 5, SqlFieldName = BS_BillSub_DR ];

/// Childsub
Property BSChildsub As %Float [ InitialExpression = {$$next^at1847()}, SqlColumnNumber = 2, SqlFieldName = BS_Childsub ];

/// Date From
Property BSDateFrom As %Date [ SqlColumnNumber = 3, SqlFieldName = BS_DateFrom ];

/// Date To
Property BSDateTo As %Date [ SqlColumnNumber = 4, SqlFieldName = BS_DateTo ];

/// ARC_PayAgreemTarAdjust Parent Reference
Relationship BSParRef As ARCPayAgreemTarAdjust [ Cardinality = parent, Inverse = ChildARCPayAgreemTarAdjBillSub, Required, SqlFieldName = BS_ParRef ];

/// Type
Property BSType As %String(DISPLAYLIST = ",Insurance,Patient", MAXLEN = 9, TRUNCATE = 1, VALUELIST = ",I,P") [ SqlColumnNumber = 7, SqlFieldName = BS_Type ];

Relationship ChildARCPayAgreemTarAdjustItem As ARCPayAgreemTarAdjustItem [ Cardinality = children, Inverse = ITMParRef ];

Index RowIDBasedIDKeyIndex On BSChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCPayAgreemTarAdjBillSub).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCPayAgreemTarAdjBillSub","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCPayAgreemTarAdjBillSub).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCPayAgreemTarAdjBillSub","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCPayAgreemTarAdjBillSub).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCPayAgreemTarAdjBillSub","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCPayAgreemTarAdjBillSub).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCPayAgreemTarAdjBillSub","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCPayAgreemTarAdjBillSub).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCPayAgreemTarAdjBillSub","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="BS_Adjustment">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="BS_BillSub_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="BS_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BS_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="BS_Type">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
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
<Field>ARC_PayAgreemTarAdjust.ADJ_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L8}</Expression>
<Field>BS_Childsub</Field>
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
<Expression>{ARC_PayAgreemTarAdjust.ADJ_Childsub}</Expression>
</Subscript>
<Subscript name="7">
<Expression>"BS"</Expression>
</Subscript>
<Subscript name="8">
<Expression>{BS_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBillsub">
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
<Field>ARC_PayAgreemTarAdjust.ADJ_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L11}</Expression>
<Field>BS_Childsub</Field>
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
<Expression>"BillSub"</Expression>
</Subscript>
<Subscript name="8">
<Expression>{BS_BillSub_DR}</Expression>
</Subscript>
<Subscript name="9">
<Expression>{BS_DateFrom}</Expression>
</Subscript>
<Subscript name="10">
<Expression>{ARC_PayAgreemTarAdjust.ADJ_Childsub}</Expression>
</Subscript>
<Subscript name="11">
<Expression>{BS_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>BS_RowId</SqlRowIdName>
<StreamLocation>^User.ARCPayAgreemTarAdjBillSubS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
