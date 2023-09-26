/// SS Group Stock Locations(1600)
Class User.SSGroupStockLocations Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlTableName = SS_GroupStockLocations, StorageStrategy = SQLStorage ]
{

/// Des Ref CTLOC
Property STCTLOCDR As CTLoc [ SqlColumnNumber = 3, SqlFieldName = ST_CTLOC_DR ];

/// Childsub
Property STChildsub As %Float [ InitialExpression = {$i(^SSU("SSGRP",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"ST",0))}, SqlColumnNumber = 2, SqlFieldName = ST_Childsub ];

/// SS_Group Parent Reference
Relationship STParRef As SSGroup [ Cardinality = parent, Inverse = ChildSSGroupStockLocations, Required, SqlFieldName = ST_ParRef ];

/// 激活标志 add2020-09-02  注意：空和Y为激活，N为不激活
Property STActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "Y", SqlColumnNumber = 4, SqlFieldName = ST_ActiveFlag ];

Index RowIDBasedIDKeyIndex On STChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 1000000;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSGroupStockLocations).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSGroupStockLocations","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSGroupStockLocations).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSGroupStockLocations","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSGroupStockLocations).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSGroupStockLocations","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSGroupStockLocations).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSGroupStockLocations","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSGroupStockLocations).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSGroupStockLocations","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>1000000</ExtentSize>
<Property name="STCTLOCDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="STChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="STParRef">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="ST_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ST_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^SSU</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SS_Group.SSGRP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>ST_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSGRP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_Group.SSGRP_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ST"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ST_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLoc">
<Global>^SSU</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SS_Group.SSGRP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>ST_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSGRP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_Group.SSGRP_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ST"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"Loc"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ST_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ST_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ST_RowId</SqlRowIdName>
<StreamLocation>^User.SSGroupStockLocationsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
