/// Clinical PathWays ICD(2128)
Class User.MRClinicalPathWaysICD Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MR_ClinicalPathWaysICD, StorageStrategy = SQLStorage ]
{

/// Childsub
Property ICDChildsub As %Float [ InitialExpression = {$i(^MR($p($s($d(initvalue):initvalue,1:%d(0)),"||"),"CPW",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"ICD",0))}, SqlColumnNumber = 2, SqlFieldName = ICD_Childsub ];

/// Des Ref ICD
Property ICDICDDR As MRCICDDx [ SqlColumnNumber = 3, SqlFieldName = ICD_ICD_DR ];

/// MR_ClinicalPathWays Parent Reference
Relationship ICDParRef As MRClinicalPathWays [ Cardinality = parent, Inverse = ChildMRClinicalPathWaysICD, Required, SqlFieldName = ICD_ParRef ];

Index RowIDBasedIDKeyIndex On ICDChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 531;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.MRClinicalPathWaysICD).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRClinicalPathWaysICD","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.MRClinicalPathWaysICD).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRClinicalPathWaysICD","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.MRClinicalPathWaysICD).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRClinicalPathWaysICD","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.MRClinicalPathWaysICD).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRClinicalPathWaysICD","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.MRClinicalPathWaysICD).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRClinicalPathWaysICD","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>531</ExtentSize>
<Property name="ICDChildsub">
<Selectivity>7.1429%</Selectivity>
</Property>
<Property name="ICDICDDR">
<Selectivity>2.7778%</Selectivity>
</Property>
<Property name="ICDParRef">
<Selectivity>0.3215%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="ICD_ICD_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^MR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>MR_ClinicalPathWays.CPW_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>ICD_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CPW"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MR_ClinicalPathWays.CPW_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"ICD"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ICD_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>ICD_RowId</SqlRowIdName>
<StreamLocation>^User.MRClinicalPathWaysICDS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
