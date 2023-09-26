/// SS Group RB Restrictions(1558)
Class User.SSGroupRBRestrictions Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_GroupRBRestrictions, StorageStrategy = SQLStorage ]
{

/// Des CTLOC
Property RBCTLOCDR As CTLoc [ SqlColumnNumber = 3, SqlFieldName = RB_CTLOC_DR ];

/// Childsub
Property RBChildsub As %Float [ InitialExpression = {$i(^SSU("SSGRP",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"RB",0))}, SqlColumnNumber = 2, SqlFieldName = RB_Childsub ];

/// LineCode
Property RBLineCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlComputeCode = { s {RB_LineCode}=$$CO10^at1558({RB_CTLOC_DR},{RB_Resource_DR},{RB_Service_DR},{RB_PatientType},{RB_RefHosp_DR})
}, SqlComputed, SqlFieldName = RB_LineCode, Transient ];

/// LineData
Property RBLineData As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlComputeCode = { s {RB_LineData}=$$CO11^at1558({RB_CTLOC_DR},{RB_Resource_DR},{RB_Service_DR},{RB_PatientType},{RB_RefHosp_DR})
}, SqlComputed, SqlFieldName = RB_LineData, Transient ];

/// Number Of Fields
Property RBNumberOfFields As %Float [ SqlColumnNumber = 9, SqlComputeCode = { s {RB_NumberOfFields}=$$CO09^at1558({RB_CTLOC_DR},{RB_Resource_DR},{RB_Service_DR},{RB_PatientType},{RB_RefHosp_DR})
}, SqlComputed, SqlFieldName = RB_NumberOfFields, Transient ];

/// SS_Group Parent Reference
Relationship RBParRef As SSGroup [ Cardinality = parent, Inverse = ChildSSGroupRBRestrictions, Required, SqlFieldName = RB_ParRef ];

/// PatientType
Property RBPatientType As %String(DISPLAYLIST = ",OutPatient,InPatient,Emergency,Health Promotion", MAXLEN = 16, TRUNCATE = 1, VALUELIST = ",O,I,E,H") [ SqlColumnNumber = 6, SqlFieldName = RB_PatientType ];

/// Des Ref Refer Hosp
Property RBRefHospDR As CTRefClin [ SqlColumnNumber = 7, SqlFieldName = RB_RefHosp_DR ];

/// Des Ref Resource
Property RBResourceDR As RBResource [ SqlColumnNumber = 4, SqlFieldName = RB_Resource_DR ];

/// Des Ref Service
Property RBServiceDR As RBCServices [ SqlColumnNumber = 5, SqlFieldName = RB_Service_DR ];

Index RowIDBasedIDKeyIndex On RBChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 1;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSGroupRBRestrictions).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSGroupRBRestrictions","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSGroupRBRestrictions).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSGroupRBRestrictions","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSGroupRBRestrictions).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSGroupRBRestrictions","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSGroupRBRestrictions).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSGroupRBRestrictions","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSGroupRBRestrictions).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSGroupRBRestrictions","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>1</ExtentSize>
<Property name="RBCTLOCDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="RBChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="RBLineCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="RBLineData">
<Selectivity>1</Selectivity>
</Property>
<Property name="RBNumberOfFields">
<Selectivity>1</Selectivity>
</Property>
<Property name="RBParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="RBPatientType">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="RBRefHospDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="RBResourceDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="RBServiceDR">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="RB_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RB_LineCode">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="RB_LineData">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="RB_NumberOfFields">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="RB_PatientType">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="RB_RefHosp_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="RB_Resource_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RB_Service_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^SSU</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SS_Group.SSGRP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>RB_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSGRP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_Group.SSGRP_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"RB"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RB_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDepartment">
<Global>^SSU</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SS_Group.SSGRP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>RB_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSGRP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_Group.SSGRP_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"RB"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"CTLOC"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RB_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{RB_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexParam">
<Global>^SSU</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SS_Group.SSGRP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L9}</Expression>
<Field>RB_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSGRP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_Group.SSGRP_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"RB"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"PAR"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RB_NumberOfFields}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{RB_LineCode}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{RB_LineData}</Expression>
</Subscript>
<Subscript name="9">
<Expression>{RB_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPatientType">
<Global>^SSU</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SS_Group.SSGRP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>RB_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSGRP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_Group.SSGRP_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"RB"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"PAT"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RB_PatientType}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{RB_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRefHosp">
<Global>^SSU</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SS_Group.SSGRP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>RB_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSGRP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_Group.SSGRP_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"RB"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"REFH"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RB_RefHosp_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{RB_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexResource">
<Global>^SSU</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SS_Group.SSGRP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>RB_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSGRP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_Group.SSGRP_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"RB"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"RES"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RB_Resource_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{RB_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexService">
<Global>^SSU</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SS_Group.SSGRP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>RB_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSGRP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_Group.SSGRP_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"RB"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"SER"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RB_Service_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{RB_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>RB_RowId</SqlRowIdName>
<StreamLocation>^User.SSGroupRBRestrictionsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
