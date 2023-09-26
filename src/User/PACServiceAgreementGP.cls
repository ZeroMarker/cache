/// Service Agreement GP(2137)
Class User.PACServiceAgreementGP Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_ServiceAgreementGP, StorageStrategy = SQLStorage ]
{

/// Childsub
Property GPChildsub As %Float [ InitialExpression = {$i(^PAC("SLA",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"GP",0))}, SqlColumnNumber = 2, SqlFieldName = GP_Childsub ];

/// PAC_ServiceAgreement Parent Reference
Relationship GPParRef As PACServiceAgreement [ Cardinality = parent, Inverse = ChildPACServiceAgreementGP, Required, SqlFieldName = GP_ParRef ];

/// Des Ref RefDoc
Property GPRefDocDR As PACRefDoctor [ SqlColumnNumber = 3, SqlFieldName = GP_RefDoc_DR ];

Index RowIDBasedIDKeyIndex On GPChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 10;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACServiceAgreementGP).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACServiceAgreementGP","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACServiceAgreementGP).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACServiceAgreementGP","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACServiceAgreementGP).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACServiceAgreementGP","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACServiceAgreementGP).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACServiceAgreementGP","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACServiceAgreementGP).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACServiceAgreementGP","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>10</ExtentSize>
<Property name="GPChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="GPParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="GPRefDocDR">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="Datamaster">
<Data name="GP_RefDoc_DR">
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
<Field>GP_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SLA"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAC_ServiceAgreement.SLA_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"GP"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{GP_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>GP_RowId</SqlRowIdName>
<StreamLocation>^User.PACServiceAgreementGPS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
