/// ServiceAgreementAdminCateg(2136)
Class User.PACServiceAgreementAdminCateg Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_ServiceAgreementAdminCateg, StorageStrategy = SQLStorage ]
{

/// Childsub
Property INSChildsub As %Float [ InitialExpression = {$i(^PAC("SLA",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"INS",0))}, SqlColumnNumber = 2, SqlFieldName = INS_Childsub ];

/// Des Ref InsType
Property INSInsTypeDR As ARCInsuranceType [ SqlColumnNumber = 3, SqlFieldName = INS_InsType_DR ];

/// PAC_ServiceAgreement Parent Reference
Relationship INSParRef As PACServiceAgreement [ Cardinality = parent, Inverse = ChildPACServiceAgreementAdminCa, Required, SqlFieldName = INS_ParRef ];

Index RowIDBasedIDKeyIndex On INSChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 13;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACServiceAgreementAdminCateg).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACServiceAgreementAdminCateg","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACServiceAgreementAdminCateg).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACServiceAgreementAdminCateg","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACServiceAgreementAdminCateg).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACServiceAgreementAdminCateg","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACServiceAgreementAdminCateg).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACServiceAgreementAdminCateg","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACServiceAgreementAdminCateg).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACServiceAgreementAdminCateg","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>13</ExtentSize>
<Property name="INSChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="INSInsTypeDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="INSParRef">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="INS_InsType_DR">
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
<Field>INS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SLA"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAC_ServiceAgreement.SLA_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"INS"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INS_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>INS_RowId</SqlRowIdName>
<StreamLocation>^User.PACServiceAgreementAdminCS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
