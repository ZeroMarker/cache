/// MR Diagnos Appintment(1951)
Class User.MRDiagnosisAllocation Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MR_DiagnosisAllocation, StorageStrategy = SQLStorage ]
{

/// Des Ref Appointment
Property ALLOCAppointmentDR As RBAppointment [ SqlColumnNumber = 3, SqlFieldName = ALLOC_Appointment_DR ];

/// Childsub
Property ALLOCChildsub As %Float [ InitialExpression = {$i(^MR($p($s($d(initvalue):initvalue,1:%d(0)),"||"),"DIA",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"APPT",0))}, SqlColumnNumber = 2, SqlFieldName = ALLOC_Childsub ];

/// MR_Diagnos Parent Reference
Relationship ALLOCParRef As MRDiagnos [ Cardinality = parent, Inverse = ChildMRDiagnosisAllocation, Required, SqlFieldName = ALLOC_ParRef ];

/// Des Ref Transaction
Property ALLOCTransactionDR As PAAdmTransaction [ SqlColumnNumber = 4, SqlFieldName = ALLOC_Transaction_DR ];

Index RowIDBasedIDKeyIndex On ALLOCChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 57;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.MRDiagnosisAllocation).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRDiagnosisAllocation","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.MRDiagnosisAllocation).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRDiagnosisAllocation","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.MRDiagnosisAllocation).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRDiagnosisAllocation","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.MRDiagnosisAllocation).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRDiagnosisAllocation","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.MRDiagnosisAllocation).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRDiagnosisAllocation","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>57</ExtentSize>
<Property name="ALLOCAppointmentDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="ALLOCChildsub">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="ALLOCParRef">
<Selectivity>1.7544%</Selectivity>
</Property>
<Property name="ALLOCTransactionDR">
<Selectivity>3.0303%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="ALLOC_Appointment_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ALLOC_Transaction_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^MR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>MR_Diagnos.MRDIA_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>ALLOC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DIA"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MR_Diagnos.MRDIA_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"APPT"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ALLOC_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAppt">
<Global>^MRi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>MR_Diagnos.MRDIA_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>ALLOC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"APPT"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ALLOC_Appointment_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MR_Diagnos.MRDIA_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ALLOC_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTransaction">
<Global>^MRi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>MR_Diagnos.MRDIA_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>ALLOC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TRANS"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ALLOC_Transaction_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MR_Diagnos.MRDIA_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ALLOC_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ALLOC_RowId</SqlRowIdName>
<StreamLocation>^User.MRDiagnosisAllocationS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
