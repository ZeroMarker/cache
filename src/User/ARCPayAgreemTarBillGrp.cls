/// ARC Pay Agreem Tar Bil Grp(1665)
Class User.ARCPayAgreemTarBillGrp Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_PayAgreemTarBillGrp, StorageStrategy = SQLStorage ]
{

/// Des Ref BillGrp
Property BGBillGrpDR As ARCBillGrp [ SqlColumnNumber = 3, SqlFieldName = BG_BillGrp_DR ];

/// Childsub
Property BGChildsub As %Float [ InitialExpression = {$i(^ARC("PAY",$p(%d(0),"||"),"TAR",$p(%d(0),"||",2),"BG",0))}, SqlColumnNumber = 2, SqlFieldName = BG_Childsub ];

/// ARC_PayAgreemTariff Parent Reference
Relationship BGParRef As ARCPayAgreemTariff [ Cardinality = parent, Inverse = ChildARCPayAgreemTarBillGrp, Required, SqlFieldName = BG_ParRef ];

Index RowIDBasedIDKeyIndex On BGChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 48;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCPayAgreemTarBillGrp).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCPayAgreemTarBillGrp","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCPayAgreemTarBillGrp).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCPayAgreemTarBillGrp","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCPayAgreemTarBillGrp).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCPayAgreemTarBillGrp","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCPayAgreemTarBillGrp).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCPayAgreemTarBillGrp","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCPayAgreemTarBillGrp).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCPayAgreemTarBillGrp","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>48</ExtentSize>
<Property name="BGBillGrpDR">
<Selectivity>8.3333%</Selectivity>
</Property>
<Property name="BGChildsub">
<Selectivity>8.3333%</Selectivity>
</Property>
<Property name="BGParRef">
<Selectivity>25.0000%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="BG_BillGrp_DR">
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
<Field>ARC_PayAgreemTariff.TAR_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>BG_Childsub</Field>
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
<Expression>"BG"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{BG_Childsub}</Expression>
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
<Expression>{L9}</Expression>
<Field>BG_Childsub</Field>
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
<Expression>"BG"</Expression>
</Subscript>
<Subscript name="6">
<Expression>0</Expression>
</Subscript>
<Subscript name="7">
<Expression>"BillGrp"</Expression>
</Subscript>
<Subscript name="8">
<Expression>{BG_BillGrp_DR}</Expression>
</Subscript>
<Subscript name="9">
<Expression>{BG_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>BG_RowId</SqlRowIdName>
<StreamLocation>^User.ARCPayAgreemTarBillGrpS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
