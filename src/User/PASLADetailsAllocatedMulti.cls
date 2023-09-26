/// SLADetailsAllocatedMul(2151)
Class User.PASLADetailsAllocatedMulti Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_SLADetailsAllocatedMulti, StorageStrategy = SQLStorage ]
{

/// Childsub
Property MULTChildsub As %Float [ InitialExpression = {$i(^PASLA("DETALL",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"MULT",0))}, SqlColumnNumber = 2, SqlFieldName = MULT_Childsub ];

/// PA_SLADetailsAllocated Parent Reference
Relationship MULTParRef As PASLADetailsAllocated [ Cardinality = parent, Inverse = ChildPASLADetailsAllocatedMulti, Required, SqlFieldName = MULT_ParRef ];

/// Des REf ServAgreement
Property MULTServAgreementDR As PACServiceAgreement [ SqlColumnNumber = 3, SqlFieldName = MULT_ServAgreement_DR ];

Index RowIDBasedIDKeyIndex On MULTChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 14;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PASLADetailsAllocatedMulti).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PASLADetailsAllocatedMulti","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PASLADetailsAllocatedMulti).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PASLADetailsAllocatedMulti","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PASLADetailsAllocatedMulti).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PASLADetailsAllocatedMulti","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PASLADetailsAllocatedMulti).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PASLADetailsAllocatedMulti","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PASLADetailsAllocatedMulti).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PASLADetailsAllocatedMulti","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>14</ExtentSize>
<Property name="MULTChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="MULTParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="MULTServAgreementDR">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="MULT_ServAgreement_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PASLA</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PA_SLADetailsAllocated.SLAD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>MULT_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DETALL"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PA_SLADetailsAllocated.SLAD_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"MULT"</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="4">
<Expression>{MULT_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>MULT_RowId</SqlRowIdName>
<StreamLocation>^User.PASLADetailsAllocatedMultS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
