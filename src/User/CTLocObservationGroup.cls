/// CT Loc Observation Group(1716)
Class User.CTLocObservationGroup Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CT_Loc_ObservationGroup, StorageStrategy = SQLStorage ]
{

/// Childsub
Property OBSChildsub As %Float [ InitialExpression = {$i(^CTLOC($p(%d(0),$c(1)),"OBS",0))}, SqlColumnNumber = 2, SqlFieldName = OBS_Childsub ];

/// Des Ref Obs Group
Property OBSObsGroupDR As MRCObservationGroup [ SqlColumnNumber = 3, SqlFieldName = OBS_ObsGroup_DR ];

/// CT_Loc Parent Reference
Relationship OBSParRef As CTLoc [ Cardinality = parent, Inverse = ChildCTLocObservationGroup, Required, SqlFieldName = OBS_ParRef ];

Index RowIDBasedIDKeyIndex On OBSChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 41;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTLocObservationGroup).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTLocObservationGroup","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTLocObservationGroup).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTLocObservationGroup","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTLocObservationGroup).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTLocObservationGroup","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTLocObservationGroup).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTLocObservationGroup","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTLocObservationGroup).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTLocObservationGroup","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>41</ExtentSize>
<Property name="OBSChildsub">
<Selectivity>16.6667%</Selectivity>
</Property>
<Property name="OBSObsGroupDR">
<Selectivity>10.0000%</Selectivity>
</Property>
<Property name="OBSParRef">
<Selectivity>6.6667%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="OBS_ObsGroup_DR">
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
<Field>OBS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{CT_Loc.CTLOC_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OBS"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OBS_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexGroup">
<Global>^CTLOC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CT_Loc.CTLOC_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>OBS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{CT_Loc.CTLOC_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OBS"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"Group"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OBS_ObsGroup_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OBS_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>OBS_RowId</SqlRowIdName>
<StreamLocation>^User.CTLocObservationGroupS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
