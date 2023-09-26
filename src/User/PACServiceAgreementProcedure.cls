/// ServiceAgreementProcedure(2138)
Class User.PACServiceAgreementProcedure Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_ServiceAgreementProcedure, StorageStrategy = SQLStorage ]
{

/// Childsub
Property PROCChildsub As %Float [ InitialExpression = {$i(^PAC("SLA",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"PROC",0))}, SqlColumnNumber = 2, SqlFieldName = PROC_Childsub ];

/// PAC_ServiceAgreement Parent Reference
Relationship PROCParRef As PACServiceAgreement [ Cardinality = parent, Inverse = ChildPACServiceAgreementProcedu, Required, SqlFieldName = PROC_ParRef ];

/// Des Ref Procedure
Property PROCProcedureDR As ORCOperation [ SqlColumnNumber = 3, SqlFieldName = PROC_Procedure_DR ];

Index RowIDBasedIDKeyIndex On PROCChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 7;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACServiceAgreementProcedure).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACServiceAgreementProcedure","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACServiceAgreementProcedure).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACServiceAgreementProcedure","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACServiceAgreementProcedure).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACServiceAgreementProcedure","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACServiceAgreementProcedure).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACServiceAgreementProcedure","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACServiceAgreementProcedure).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACServiceAgreementProcedure","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>7</ExtentSize>
<Property name="PROCChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="PROCParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="PROCProcedureDR">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="PROC_Procedure_DR">
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
<Field>PROC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SLA"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAC_ServiceAgreement.SLA_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"PROC"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PROC_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PROC_RowId</SqlRowIdName>
<StreamLocation>^User.PACServiceAgreementProcedS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
