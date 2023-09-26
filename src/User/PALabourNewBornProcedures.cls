/// PA Lab NewBorn Procedures(1953)
Class User.PALabourNewBornProcedures Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_LabourNewBornProcedures, StorageStrategy = SQLStorage ]
{

/// Childsub
Property PROCChildsub As %Float [ InitialExpression = {$i(^PAADM($p(%d(0),"||"),"ALB",$p(initvalue,"||",2),"LNB",$p(initvalue,"||",3),"PROC",0))}, SqlColumnNumber = 2, SqlFieldName = PROC_Childsub ];

/// PA_LabourNewBorn Parent Reference
Relationship PROCParRef As PALabourNewBorn [ Cardinality = parent, Inverse = ChildPALabourNewBornProcedures, Required, SqlFieldName = PROC_ParRef ];

/// Des Ref Procedure
Property PROCProcedureDR As ORCOperation [ SqlColumnNumber = 3, SqlFieldName = PROC_Procedure_DR ];

Index RowIDBasedIDKeyIndex On PROCChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PALabourNewBornProcedures).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PALabourNewBornProcedures","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PALabourNewBornProcedures).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PALabourNewBornProcedures","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PALabourNewBornProcedures).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PALabourNewBornProcedures","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PALabourNewBornProcedures).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PALabourNewBornProcedures","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PALabourNewBornProcedures).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PALabourNewBornProcedures","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="PROC_Procedure_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PAADM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Adm.PAADM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PA_AdmLab.ALB_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>PA_LabourNewBorn.LNB_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L7}</Expression>
<Field>PROC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Adm.PAADM_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ALB"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_AdmLab.ALB_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"LNB"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_LabourNewBorn.LNB_ChildSub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>"PROC"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{PROC_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PROC_RowId</SqlRowIdName>
<StreamLocation>^User.PALabourNewBornProceduresS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
