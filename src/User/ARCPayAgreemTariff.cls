/// ARC Pay Agreem Tariff(1417)
Class User.ARCPayAgreemTariff Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_PayAgreemTariff, StorageStrategy = SQLStorage ]
{

Relationship ChildARCPayAgreemTarAdjust As ARCPayAgreemTarAdjust [ Cardinality = children, Inverse = ADJParRef ];

Relationship ChildARCPayAgreemTarBillGrp As ARCPayAgreemTarBillGrp [ Cardinality = children, Inverse = BGParRef ];

/// Childsub
Property TARChildsub As %Float [ InitialExpression = {$i(^ARC("PAY",$p(%d(0),$c(1)),"TAR",0))}, SqlColumnNumber = 2, SqlFieldName = TAR_Childsub ];

/// ARC_PaymentAgreement Parent Reference
Relationship TARParRef As ARCPaymentAgreement [ Cardinality = parent, Inverse = ChildARCPayAgreemTariff, Required, SqlFieldName = TAR_ParRef ];

/// Sequence
Property TARSequence As %Float(MINVAL = 0) [ Required, SqlColumnNumber = 4, SqlFieldName = TAR_Sequence ];

/// Des Ref Tariff
Property TARTariffDR As ARCTariff [ SqlColumnNumber = 3, SqlFieldName = TAR_Tariff_DR ];

Index RowIDBasedIDKeyIndex On TARChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 34;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCPayAgreemTariff).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCPayAgreemTariff","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCPayAgreemTariff).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCPayAgreemTariff","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCPayAgreemTariff).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCPayAgreemTariff","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCPayAgreemTariff).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCPayAgreemTariff","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCPayAgreemTariff).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCPayAgreemTariff","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>34</ExtentSize>
<Property name="TARChildsub">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="TARParRef">
<Selectivity>3.4483%</Selectivity>
</Property>
<Property name="TARSequence">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="TARTariffDR">
<Selectivity>16.6667%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="TAR_Sequence">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TAR_Tariff_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^ARC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ARC_PaymentAgreement.PAY_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>TAR_Childsub</Field>
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
<Expression>{TAR_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexSeqNo">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ARC_PaymentAgreement.PAY_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L8}</Expression>
<Field>TAR_Childsub</Field>
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
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"Seq"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{TAR_Sequence}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{TAR_Tariff_DR}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{TAR_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>TAR_RowId</SqlRowIdName>
<StreamLocation>^User.ARCPayAgreemTariffS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
