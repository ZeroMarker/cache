/// OR An Oper Anaest Assistant(1565)
Class User.ORAnOperAnaestAssistant Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = OR_An_Oper_Anaest_Assistant, StorageStrategy = SQLStorage ]
{

/// Des Ref CTCP
Property ANASSCTCPDR As CTCareProv [ SqlColumnNumber = 3, SqlFieldName = ANASS_CTCP_DR ];

/// Childsub
Property ANASSChildsub As %Float [ InitialExpression = {$i(^OR($p(%d(0),"||"),"ANA",$p(%d(0),"||",2),"OP",$p(%d(0),"||",3),"ANASS",0))}, SqlColumnNumber = 2, SqlFieldName = ANASS_Childsub ];

/// OR_Anaest_Operation Parent Reference
Relationship ANASSParRef As ORAnaestOperation [ Cardinality = parent, Inverse = ChildORAnOperAnaestAssistant, Required, SqlFieldName = ANASS_ParRef ];

Index RowIDBasedIDKeyIndex On ANASSChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ORAnOperAnaestAssistant).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ORAnOperAnaestAssistant","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ORAnOperAnaestAssistant).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ORAnOperAnaestAssistant","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ORAnOperAnaestAssistant).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ORAnOperAnaestAssistant","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ORAnOperAnaestAssistant).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ORAnOperAnaestAssistant","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ORAnOperAnaestAssistant).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ORAnOperAnaestAssistant","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ANASS_CTCP_DR">
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
<Field>ANASS_Childsub</Field>
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
<Expression>"ANASS"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ANASS_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>ANASS_RowId</SqlRowIdName>
<StreamLocation>^User.ORAnOperAnaestAssistantS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
