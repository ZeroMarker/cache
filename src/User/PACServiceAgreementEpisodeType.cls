/// Service Agreement Episode Type(2134
Class User.PACServiceAgreementEpisodeType Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_ServiceAgreementEpisodeType, StorageStrategy = SQLStorage ]
{

/// Childsub
Property EPChildsub As %Float [ InitialExpression = {$i(^PAC("SLA",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"EP",0))}, SqlColumnNumber = 2, SqlFieldName = EP_Childsub ];

/// Episode Type
Property EPEpisodeType As %String(DISPLAYLIST = ",Inpatients,Outpatients,Day Case,Ward Attender,WaitList", MAXLEN = 13, TRUNCATE = 1, VALUELIST = ",IP,OP,DC,WA,WL") [ SqlColumnNumber = 3, SqlFieldName = EP_EpisodeType ];

/// PAC_ServiceAgreement Parent Reference
Relationship EPParRef As PACServiceAgreement [ Cardinality = parent, Inverse = ChildPACServiceAgreementEpisode, Required, SqlFieldName = EP_ParRef ];

/// Des Ref ServiceGroup
Property EPServiceGroupDR As RBCServiceGroup [ SqlColumnNumber = 4, SqlFieldName = EP_ServiceGroup_DR ];

Index RowIDBasedIDKeyIndex On EPChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 28;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACServiceAgreementEpisodeType).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACServiceAgreementEpisodeType","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACServiceAgreementEpisodeType).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACServiceAgreementEpisodeType","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACServiceAgreementEpisodeType).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACServiceAgreementEpisodeType","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACServiceAgreementEpisodeType).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACServiceAgreementEpisodeType","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACServiceAgreementEpisodeType).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACServiceAgreementEpisodeType","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>28</ExtentSize>
<Property name="EPChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="EPEpisodeType">
<Selectivity>16.6667%</Selectivity>
</Property>
<Property name="EPParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="EPServiceGroupDR">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="EP_EpisodeType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EP_ServiceGroup_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PAC_ServiceAgreement.SLA_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>EP_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SLA"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAC_ServiceAgreement.SLA_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"EP"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EP_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>EP_RowId</SqlRowIdName>
<StreamLocation>^User.PACServiceAgreementEpisodS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
