/// Operation Scrub Nurse(1014)
Class User.ORAnOperScrubNurse Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = OR_An_Oper_Scrub_Nurse, StorageStrategy = SQLStorage ]
{

/// Childsub
Property OPSCNChildsub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^OR($p(%d(0),"||"),"ANA",$p(%d(0),"||",2),"OP",$p(%d(0),"||",3),"SCN",0))}, Required, SqlColumnNumber = 2, SqlFieldName = OPSCN_Childsub ];

/// OR_Anaest_Operation Parent Reference
Relationship OPSCNParRef As ORAnaestOperation [ Cardinality = parent, Inverse = ChildORAnOperScrubNurse, Required, SqlFieldName = OPSCN_ParRef ];

/// Scrub Nurse Des Ref to CTCP
Property OPSCNScrubNurseDR As CTCareProv [ Required, SqlColumnNumber = 3, SqlFieldName = OPSCN_Scrub_Nurse_DR ];

Index RowIDBasedIDKeyIndex On OPSCNChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ORAnOperScrubNurse).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ORAnOperScrubNurse","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ORAnOperScrubNurse).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ORAnOperScrubNurse","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ORAnOperScrubNurse).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ORAnOperScrubNurse","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ORAnOperScrubNurse).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ORAnOperScrubNurse","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ORAnOperScrubNurse).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ORAnOperScrubNurse","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="OPSCN_Scrub_Nurse_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^OR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Adm.PAADM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>OR_Anaesthesia.ANA_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>OR_Anaest_Operation.ANAOP_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L7}</Expression>
<Field>OPSCN_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Adm.PAADM_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ANA"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OR_Anaesthesia.ANA_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"OP"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OR_Anaest_Operation.ANAOP_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>"SCN"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{OPSCN_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>OPSCN_RowId</SqlRowIdName>
<StreamLocation>^User.ORAnOperScrubNurseS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
