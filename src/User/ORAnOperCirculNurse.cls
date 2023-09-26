/// Operation Circulat Nurse(1383)
Class User.ORAnOperCirculNurse Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = OR_An_Oper_Circul_Nurse, StorageStrategy = SQLStorage ]
{

/// Des Ref to CTCP
Property CIRNCTCPDR As CTCareProv [ SqlColumnNumber = 3, SqlFieldName = CIRN_CTCP_DR ];

/// Childsub
Property CIRNChildsub As %Float [ InitialExpression = {$i(^OR($p(%d(0),"||"),"ANA",$p(%d(0),"||",2),"OP",$p(%d(0),"||",3),"CIRN",0))}, SqlColumnNumber = 2, SqlFieldName = CIRN_Childsub ];

/// OR_Anaest_Operation Parent Reference
Relationship CIRNParRef As ORAnaestOperation [ Cardinality = parent, Inverse = ChildORAnOperCirculNurse, Required, SqlFieldName = CIRN_ParRef ];

Index RowIDBasedIDKeyIndex On CIRNChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ORAnOperCirculNurse).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ORAnOperCirculNurse","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ORAnOperCirculNurse).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ORAnOperCirculNurse","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ORAnOperCirculNurse).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ORAnOperCirculNurse","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ORAnOperCirculNurse).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ORAnOperCirculNurse","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ORAnOperCirculNurse).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ORAnOperCirculNurse","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="CIRN_CTCP_DR">
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
<Field>CIRN_Childsub</Field>
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
<Expression>"CIRN"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{CIRN_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>CIRN_RowId</SqlRowIdName>
<StreamLocation>^User.ORAnOperCirculNurseS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
