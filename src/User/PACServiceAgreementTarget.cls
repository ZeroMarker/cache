/// ServiceAgreementTarget(2141)
Class User.PACServiceAgreementTarget Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_ServiceAgreementTarget, StorageStrategy = SQLStorage ]
{

/// Des Ref AdminCateg
Property TARAdminCategDR As PACServiceAgreementAdminCateg [ SqlColumnNumber = 9, SqlFieldName = TAR_AdminCateg_DR ];

/// Childsub
Property TARChildsub As %Float [ InitialExpression = {$i(^PAC("SLA",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"TAR",0))}, SqlColumnNumber = 2, SqlFieldName = TAR_Childsub ];

/// Comment
Property TARComment As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = TAR_Comment ];

/// Cost
Property TARCost As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = TAR_Cost ];

/// Name
Property TARName As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = TAR_Name ];

/// PAC_ServiceAgreement Parent Reference
Relationship TARParRef As PACServiceAgreement [ Cardinality = parent, Inverse = ChildPACServiceAgreementTarget, Required, SqlFieldName = TAR_ParRef ];

/// Des Ref SLAEpis
Property TARSLAEpisDR As PACServiceAgreementEpisodeType [ SqlColumnNumber = 7, SqlFieldName = TAR_SLAEpis_DR ];

/// Des Ref SLAGP
Property TARSLAGPDR As PACServiceAgreementGP [ SqlColumnNumber = 10, SqlFieldName = TAR_SLAGP_DR ];

/// Des Ref SLAHAR
Property TARSLAHARDR As PACServiceAgreementHAR [ SqlColumnNumber = 12, SqlFieldName = TAR_SLAHAR_DR ];

/// Des Ref SLAHRG
Property TARSLAHRGDR As PACServiceAgreementHRG [ SqlColumnNumber = 13, SqlFieldName = TAR_SLAHRG_DR ];

/// Des Ref SLAProc
Property TARSLAProcDR As PACServiceAgreementProcedure [ SqlColumnNumber = 11, SqlFieldName = TAR_SLAProc_DR ];

/// Des Ref SLASpec
Property TARSLASpecDR As PACServiceAgreementSpecialty [ SqlColumnNumber = 8, SqlFieldName = TAR_SLASpec_DR ];

/// Target
Property TARTarget As %Float [ SqlColumnNumber = 4, SqlFieldName = TAR_Target ];

Index RowIDBasedIDKeyIndex On TARChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 4;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACServiceAgreementTarget).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACServiceAgreementTarget","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACServiceAgreementTarget).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACServiceAgreementTarget","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACServiceAgreementTarget).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACServiceAgreementTarget","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACServiceAgreementTarget).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACServiceAgreementTarget","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACServiceAgreementTarget).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACServiceAgreementTarget","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>4</ExtentSize>
<Property name="TARAdminCategDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="TARChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="TARComment">
<Selectivity>1</Selectivity>
</Property>
<Property name="TARCost">
<Selectivity>1</Selectivity>
</Property>
<Property name="TARName">
<Selectivity>1</Selectivity>
</Property>
<Property name="TARParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="TARSLAEpisDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="TARSLAGPDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="TARSLAHARDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="TARSLAHRGDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="TARSLAProcDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="TARSLASpecDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="TARTarget">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="TAR_AdminCateg_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="TAR_Comment">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="TAR_Cost">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="TAR_Name">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TAR_SLAEpis_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="TAR_SLAGP_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="TAR_SLAHAR_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="TAR_SLAHRG_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="TAR_SLAProc_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="TAR_SLASpec_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="TAR_Target">
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
<Field>TAR_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SLA"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAC_ServiceAgreement.SLA_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"TAR"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TAR_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>TAR_RowId</SqlRowIdName>
<StreamLocation>^User.PACServiceAgreementTargetS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
