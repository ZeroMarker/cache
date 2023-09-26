/// Payment Agreem ICD(1735)
Class User.ARCPayAgreemICD Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_PayAgreemICD, StorageStrategy = SQLStorage ]
{

/// Des Ref BillSub
Property ICDBillSubDR As ARCBillSub [ SqlColumnNumber = 4, SqlFieldName = ICD_BillSub_DR ];

/// Childsub
Property ICDChildsub As %Float [ InitialExpression = {$i(^ARC("PAY",$p(%d(0),$c(1)),"ICD",0))}, SqlColumnNumber = 2, SqlFieldName = ICD_Childsub ];

/// Des Ref ICDDx
Property ICDICDDxDR As MRCICDDx [ SqlColumnNumber = 3, SqlFieldName = ICD_ICDDx_DR ];

/// ARC_PaymentAgreement Parent Reference
Relationship ICDParRef As ARCPaymentAgreement [ Cardinality = parent, Inverse = ChildARCPayAgreemICD, Required, SqlFieldName = ICD_ParRef ];

Index RowIDBasedIDKeyIndex On ICDChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 8;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCPayAgreemICD).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCPayAgreemICD","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCPayAgreemICD).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCPayAgreemICD","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCPayAgreemICD).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCPayAgreemICD","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCPayAgreemICD).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCPayAgreemICD","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCPayAgreemICD).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCPayAgreemICD","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>8</ExtentSize>
<Property name="ICDBillSubDR">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="ICDChildsub">
<Selectivity>14.2857%</Selectivity>
</Property>
<Property name="ICDICDDxDR">
<Selectivity>12.5000%</Selectivity>
</Property>
<Property name="ICDParRef">
<Selectivity>50.0000%</Selectivity>
</Property>
<SQLMap name="Datamaster">
<Data name="ICD_BillSub_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ICD_ICDDx_DR">
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
<Field>ICD_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PAY"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_PaymentAgreement.PAY_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ICD"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ICD_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexICD">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ARC_PaymentAgreement.PAY_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>ICD_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PAY"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_PaymentAgreement.PAY_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ICD"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"ICD"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ICD_ICDDx_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ICD_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ICD_RowId</SqlRowIdName>
<StreamLocation>^User.ARCPayAgreemICDS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
