/// RT Mas Vol Location(1683)
Class User.RTMasVolLocation Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RT_MasVolLocation, StorageStrategy = SQLStorage ]
{

/// Des Ref CTLOC
Property LOCCTLOCDR As CTLoc [ SqlColumnNumber = 3, SqlFieldName = LOC_CTLOC_DR ];

/// Childsub
Property LOCChildsub As %Float [ InitialExpression = {$i(^RT($p(%d(0),"||"),"RTMAV",$p(%d(0),"||",2),"LOC",0))}, SqlColumnNumber = 2, SqlFieldName = LOC_Childsub ];

/// RT_MasVol Parent Reference
Relationship LOCParRef As RTMasVol [ Cardinality = parent, Inverse = ChildRTMasVolLocation, Required, SqlFieldName = LOC_ParRef ];

/// Record Number
Property LOCRecordNumber As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = LOC_RecordNumber ];

Index RowIDBasedIDKeyIndex On LOCChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 6;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RTMasVolLocation).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RTMasVolLocation","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RTMasVolLocation).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RTMasVolLocation","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RTMasVolLocation).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RTMasVolLocation","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.RTMasVolLocation).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RTMasVolLocation","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RTMasVolLocation).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RTMasVolLocation","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>6</ExtentSize>
<Property name="LOCCTLOCDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="LOCChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="LOCParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="LOCRecordNumber">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="Datamaster">
<Data name="LOC_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="LOC_RecordNumber">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^RT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RT_Master.RTMAS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>RT_MasVol.RTMAV_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>LOC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{RT_Master.RTMAS_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RTMAV"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RT_MasVol.RTMAV_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"LOC"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{LOC_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLoc">
<Global>^RT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RT_Master.RTMAS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>RT_MasVol.RTMAV_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L8}</Expression>
<Field>LOC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{RT_Master.RTMAS_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RTMAV"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RT_MasVol.RTMAV_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"LOC"</Expression>
</Subscript>
<Subscript name="5">
<Expression>0</Expression>
</Subscript>
<Subscript name="6">
<Expression>"Loc"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{LOC_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{LOC_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexNumber">
<Global>^RT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RT_Master.RTMAS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>RT_MasVol.RTMAV_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L8}</Expression>
<Field>LOC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{RT_Master.RTMAS_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RTMAV"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RT_MasVol.RTMAV_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"LOC"</Expression>
</Subscript>
<Subscript name="5">
<Expression>0</Expression>
</Subscript>
<Subscript name="6">
<Expression>"Num"</Expression>
</Subscript>
<Subscript name="7">
<Expression>$$ALPHAUP({LOC_RecordNumber})</Expression>
</Subscript>
<Subscript name="8">
<Expression>{LOC_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>LOC_RowId</SqlRowIdName>
<StreamLocation>^User.RTMasVolLocationS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
