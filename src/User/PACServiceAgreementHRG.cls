/// ServiceAgreementHRG(2140)
Class User.PACServiceAgreementHRG Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_ServiceAgreementHRG, StorageStrategy = SQLStorage ]
{

/// Childsub
Property HRGChildsub As %Float [ InitialExpression = {$i(^PAC("SLA",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"HRG",0))}, SqlColumnNumber = 2, SqlFieldName = HRG_Childsub ];

/// Des Ref HRG
Property HRGHRGDR As PACHRGCodes [ SqlColumnNumber = 3, SqlFieldName = HRG_HRG_DR ];

/// PAC_ServiceAgreement Parent Reference
Relationship HRGParRef As PACServiceAgreement [ Cardinality = parent, Inverse = ChildPACServiceAgreementHRG, Required, SqlFieldName = HRG_ParRef ];

Index RowIDBasedIDKeyIndex On HRGChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 6;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACServiceAgreementHRG).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACServiceAgreementHRG","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACServiceAgreementHRG).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACServiceAgreementHRG","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACServiceAgreementHRG).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACServiceAgreementHRG","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACServiceAgreementHRG).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACServiceAgreementHRG","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACServiceAgreementHRG).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACServiceAgreementHRG","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>6</ExtentSize>
<Property name="HRGChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="HRGHRGDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="HRGParRef">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="HRG_HRG_DR">
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
<Field>HRG_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SLA"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAC_ServiceAgreement.SLA_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"HRG"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{HRG_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>HRG_RowId</SqlRowIdName>
<StreamLocation>^User.PACServiceAgreementHRGS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
