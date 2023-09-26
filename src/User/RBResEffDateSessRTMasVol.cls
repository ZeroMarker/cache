/// RB Res Eff Date Sess RTMasVol(1580
Class User.RBResEffDateSessRTMasVol Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RB_ResEffDateSessRTMasVol, StorageStrategy = SQLStorage ]
{

/// All Volumes
Property RTMAVAllVolumes As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = RTMAV_AllVolumes ];

/// Childsub
Property RTMAVChildsub As %Float [ InitialExpression = {$i(^RB("RES",$p($s($d(initvalue):initvalue,1:%d(0)),"||"),"DATE",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"SESS",$p($s($d(initvalue):initvalue,1:%d(0)),"||",3),"RTMAV",0))}, SqlColumnNumber = 2, SqlFieldName = RTMAV_Childsub ];

/// Last Two Volumes
Property RTMAVLastTwoVolumes As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = RTMAV_LastTwoVolumes ];

/// Latest Volume Only
Property RTMAVLatestVolumeOnly As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = RTMAV_LatestVolumeOnly ];

/// Lead Time
Property RTMAVLeadTime As %Float [ SqlColumnNumber = 7, SqlFieldName = RTMAV_LeadTime ];

/// RB_ResEffDateSession Parent Reference
Relationship RTMAVParRef As RBResEffDateSession [ Cardinality = parent, Inverse = ChildRBResEffDateSessRTMasVol, Required, SqlFieldName = RTMAV_ParRef ];

/// Des Ref RecordType
Property RTMAVRecordTypeDR As RTCMRecordType [ SqlColumnNumber = 4, SqlFieldName = RTMAV_RecordType_DR ];

/// Des Ref RTC_MRTypeVol_DR
Property RTMAVTypeVolDR As RTCMRecordTypeVolumes [ SqlColumnNumber = 3, SqlFieldName = RTMAV_TypeVol_DR ];

Index RowIDBasedIDKeyIndex On RTMAVChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 412;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RBResEffDateSessRTMasVol).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBResEffDateSessRTMasVol","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RBResEffDateSessRTMasVol).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBResEffDateSessRTMasVol","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RBResEffDateSessRTMasVol).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBResEffDateSessRTMasVol","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.RBResEffDateSessRTMasVol).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBResEffDateSessRTMasVol","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RBResEffDateSessRTMasVol).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBResEffDateSessRTMasVol","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>412</ExtentSize>
<Property name="RTMAVAllVolumes">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="RTMAVChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="RTMAVLastTwoVolumes">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="RTMAVLatestVolumeOnly">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="RTMAVLeadTime">
<Selectivity>1</Selectivity>
</Property>
<Property name="RTMAVParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="RTMAVRecordTypeDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="RTMAVTypeVolDR">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="RTMAV_AllVolumes">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RTMAV_LastTwoVolumes">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="RTMAV_LatestVolumeOnly">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="RTMAV_LeadTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="RTMAV_RecordType_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RTMAV_TypeVol_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^RB</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>RB_Resource.RES_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>RB_ResEffDate.DATE_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>RB_ResEffDateSession.SESS_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L8}</Expression>
<Field>RTMAV_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RES"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RB_Resource.RES_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DATE"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RB_ResEffDate.DATE_Childsub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"SESS"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RB_ResEffDateSession.SESS_Childsub}</Expression>
</Subscript>
<Subscript name="7">
<Expression>"RTMAV"</Expression>
</Subscript>
<Subscript name="8">
<Expression>{RTMAV_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexRTMAV">
<Global>^RB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>RB_Resource.RES_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>RB_ResEffDate.DATE_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>RB_ResEffDateSession.SESS_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L11}</Expression>
<Field>RTMAV_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RES"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RB_Resource.RES_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DATE"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RB_ResEffDate.DATE_Childsub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"SESS"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RB_ResEffDateSession.SESS_Childsub}</Expression>
</Subscript>
<Subscript name="7">
<Expression>"RTMAV"</Expression>
</Subscript>
<Subscript name="8">
<Expression>0</Expression>
</Subscript>
<Subscript name="9">
<Expression>"Type"</Expression>
</Subscript>
<Subscript name="10">
<Expression>{RTMAV_TypeVol_DR}</Expression>
</Subscript>
<Subscript name="11">
<Expression>{RTMAV_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>RTMAV_RowId</SqlRowIdName>
<StreamLocation>^User.RBResEffDateSessRTMasVolS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
