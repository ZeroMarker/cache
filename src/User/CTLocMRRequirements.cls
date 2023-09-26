/// CT_Loc MR Requirements(2051)
Class User.CTLocMRRequirements Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CT_LocMRRequirements, StorageStrategy = SQLStorage ]
{

/// All Volumes
Property MRAllVolumes As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = MR_AllVolumes ];

/// Childsub
Property MRChildsub As %Float [ InitialExpression = {$i(^CTLOC($p(%d(0),$c(1)),"MR",0))}, SqlColumnNumber = 2, SqlFieldName = MR_Childsub ];

/// Last Two Volumes
Property MRLastTwoVolumes As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = MR_LastTwoVolumes ];

/// Latest Volume Only
Property MRLatestVolumeOnly As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = MR_LatestVolumeOnly ];

/// Lead Time
Property MRLeadTime As %Float [ SqlColumnNumber = 6, SqlFieldName = MR_LeadTime ];

/// CT_Loc Parent Reference
Relationship MRParRef As CTLoc [ Cardinality = parent, Inverse = ChildCTLocMRRequirements, Required, SqlFieldName = MR_ParRef ];

/// Des Ref RecordType
Property MRRecordTypeDR As RTCMRecordType [ SqlColumnNumber = 3, SqlFieldName = MR_RecordType_DR ];

Index RowIDBasedIDKeyIndex On MRChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 5;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTLocMRRequirements).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTLocMRRequirements","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTLocMRRequirements).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTLocMRRequirements","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTLocMRRequirements).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTLocMRRequirements","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTLocMRRequirements).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTLocMRRequirements","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTLocMRRequirements).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTLocMRRequirements","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>5</ExtentSize>
<Property name="MRAllVolumes">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="MRChildsub">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="MRLastTwoVolumes">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="MRLatestVolumeOnly">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="MRLeadTime">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="MRParRef">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="MRRecordTypeDR">
<Selectivity>25.0000%</Selectivity>
</Property>
<SQLMap name="Datamaster">
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
<Global>^CTLOC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CT_Loc.CTLOC_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>MR_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{CT_Loc.CTLOC_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"MR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MR_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>MR_RowId</SqlRowIdName>
<StreamLocation>^User.CTLocMRRequirementsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
