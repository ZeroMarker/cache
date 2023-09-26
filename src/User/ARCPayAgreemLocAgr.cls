/// ARC PayAgreemLocAgr(1418)
Class User.ARCPayAgreemLocAgr Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_PayAgreemLocAgr, StorageStrategy = SQLStorage ]
{

/// Des Ref BillGrp
Property AGRBillGrpDR As ARCBillGrp [ SqlColumnNumber = 3, SqlFieldName = AGR_BillGrp_DR ];

/// Childsub
Property AGRChildsub As %Float [ InitialExpression = {$i(^ARC("PAY",$p(%d(0),"||"),"LOC",$p(%d(0),"||",2),"AGR",0))}, SqlColumnNumber = 2, SqlFieldName = AGR_Childsub ];

/// Des Ref Hospital
Property AGRHospitalDR As CTHospital [ SqlColumnNumber = 4, SqlFieldName = AGR_Hospital_DR ];

/// ARC_PayAgreemLocation Parent Reference
Relationship AGRParRef As ARCPayAgreemLocation [ Cardinality = parent, Inverse = ChildARCPayAgreemLocAgr, Required, SqlFieldName = AGR_ParRef ];

Index RowIDBasedIDKeyIndex On AGRChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCPayAgreemLocAgr).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCPayAgreemLocAgr","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCPayAgreemLocAgr).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCPayAgreemLocAgr","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCPayAgreemLocAgr).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCPayAgreemLocAgr","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCPayAgreemLocAgr).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCPayAgreemLocAgr","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCPayAgreemLocAgr).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCPayAgreemLocAgr","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="AGR_BillGrp_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AGR_Hospital_DR">
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
<Field>ARC_PayAgreemLocation.LOC_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>AGR_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PAY"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_PaymentAgreement.PAY_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"LOC"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARC_PayAgreemLocation.LOC_Childsub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"AGR"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{AGR_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>AGR_RowId</SqlRowIdName>
<StreamLocation>^User.ARCPayAgreemLocAgrS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
