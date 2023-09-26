/// PAC WL Type MR Requirements(2020)
Class User.PACWLTypeMRRequirements Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_WLTypeMRRequirements, StorageStrategy = SQLStorage ]
{

/// All Volumes
Property MRAllVolumes As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = MR_AllVolumes ];

/// Childsub
Property MRChildsub As %Float [ InitialExpression = {$i(^PAC("WLT",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"MR",0))}, SqlColumnNumber = 2, SqlFieldName = MR_Childsub ];

/// Last Two Volumes
Property MRLastTwoVolumes As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = MR_LastTwoVolumes ];

/// Latest Volume Only
Property MRLatestVolumeOnly As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = MR_LatestVolumeOnly ];

/// Lead Time
Property MRLeadTime As %Float [ SqlColumnNumber = 6, SqlFieldName = MR_LeadTime ];

/// PAC_WaitingListType Parent Reference
Relationship MRParRef As PACWaitingListType [ Cardinality = parent, Inverse = ChildPACWLTypeMRRequirements, Required, SqlFieldName = MR_ParRef ];

/// Des Ref RecordType
Property MRRecordTypeDR As RTCMRecordType [ SqlColumnNumber = 3, SqlFieldName = MR_RecordType_DR ];

Index RowIDBasedIDKeyIndex On MRChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 7;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACWLTypeMRRequirements).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACWLTypeMRRequirements","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACWLTypeMRRequirements).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACWLTypeMRRequirements","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACWLTypeMRRequirements).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACWLTypeMRRequirements","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACWLTypeMRRequirements).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACWLTypeMRRequirements","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACWLTypeMRRequirements).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACWLTypeMRRequirements","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>7</ExtentSize>
<Property name="MRAllVolumes">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="MRChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="MRLastTwoVolumes">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="MRLatestVolumeOnly">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="MRLeadTime">
<Selectivity>1</Selectivity>
</Property>
<Property name="MRParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="MRRecordTypeDR">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="MR_AllVolumes">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MR_LastTwoVolumes">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MR_LatestVolumeOnly">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MR_LeadTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MR_RecordType_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PAC_WaitingListType.WLT_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>MR_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"WLT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAC_WaitingListType.WLT_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"MR"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MR_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>MR_RowId</SqlRowIdName>
<StreamLocation>^User.PACWLTypeMRRequirementsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
