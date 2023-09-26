/// ServiceAgreementSpecialty(2135)
Class User.PACServiceAgreementSpecialty Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_ServiceAgreementSpecialty, StorageStrategy = SQLStorage ]
{

/// Des Ref CTLOC
Property SPECCTLOCDR As CTLoc [ SqlColumnNumber = 3, SqlFieldName = SPEC_CTLOC_DR ];

/// Childsub
Property SPECChildsub As %Float [ InitialExpression = {$i(^PAC("SLA",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"SPEC",0))}, SqlColumnNumber = 2, SqlFieldName = SPEC_Childsub ];

/// PAC_ServiceAgreement Parent Reference
Relationship SPECParRef As PACServiceAgreement [ Cardinality = parent, Inverse = ChildPACServiceAgreementSpecial, Required, SqlFieldName = SPEC_ParRef ];

Index RowIDBasedIDKeyIndex On SPECChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 39;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACServiceAgreementSpecialty).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACServiceAgreementSpecialty","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACServiceAgreementSpecialty).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACServiceAgreementSpecialty","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACServiceAgreementSpecialty).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACServiceAgreementSpecialty","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACServiceAgreementSpecialty).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACServiceAgreementSpecialty","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACServiceAgreementSpecialty).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACServiceAgreementSpecialty","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>39</ExtentSize>
<Property name="SPECCTLOCDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="SPECChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="SPECParRef">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="Datamaster">
<Data name="SPEC_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PAC_ServiceAgreement.SLA_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>SPEC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SLA"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAC_ServiceAgreement.SLA_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"SPEC"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SPEC_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>SPEC_RowId</SqlRowIdName>
<StreamLocation>^User.PACServiceAgreementSpeciaS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
