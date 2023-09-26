/// MRC Observation Group Items(1715)
Class User.MRCObservationGroupItems Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MRC_ObservationGroupItems, StorageStrategy = SQLStorage ]
{

/// Childsub
Property ITMChildsub As %Float [ InitialExpression = {$i(^MRC("OBGRP",$p(%d(0),$c(1)),"ITM",0))}, SqlColumnNumber = 2, SqlFieldName = ITM_Childsub ];

/// Graphing Mark Size
Property ITMGraphingMarkSize As %Float [ SqlColumnNumber = 4, SqlFieldName = ITM_GraphingMarkSize ];

/// Not In Use
Property ITMNotInUse As %Float [ SqlColumnNumber = 5, SqlFieldName = ITM_NotInUse ];

/// Des Ref Observ Item
Property ITMObsItemDR As MRCObservationItem [ SqlColumnNumber = 7, SqlFieldName = ITM_ObsItem_DR ];

/// MRC_ObservationGroup Parent Reference
Relationship ITMParRef As MRCObservationGroup [ Cardinality = parent, Inverse = ChildMRCObservationGroupItems, Required, SqlFieldName = ITM_ParRef ];

/// Row Position in Table
Property ITMRowPosition As %Float [ SqlColumnNumber = 3, SqlFieldName = ITM_RowPosition ];

/// Y Axis On Graph
Property ITMYAxisOnGraph As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = ITM_YAxisOnGraph ];

Index RowIDBasedIDKeyIndex On ITMChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 176;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.MRCObservationGroupItems).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCObservationGroupItems","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.MRCObservationGroupItems).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCObservationGroupItems","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.MRCObservationGroupItems).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCObservationGroupItems","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.MRCObservationGroupItems).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCObservationGroupItems","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.MRCObservationGroupItems).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCObservationGroupItems","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>176</ExtentSize>
<Property name="ITMChildsub">
<Selectivity>2.7778%</Selectivity>
</Property>
<Property name="ITMGraphingMarkSize">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="ITMNotInUse">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="ITMObsItemDR">
<Selectivity>0.7407%</Selectivity>
</Property>
<Property name="ITMParRef">
<Selectivity>4.7619%</Selectivity>
</Property>
<Property name="ITMRowPosition">
<Selectivity>3.5714%</Selectivity>
</Property>
<Property name="ITMYAxisOnGraph">
<Selectivity>33.3333%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="ITM_GraphingMarkSize">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ITM_NotInUse">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ITM_ObsItem_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ITM_RowPosition">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ITM_YAxisOnGraph">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^MRC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>MRC_ObservationGroup.GRP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>ITM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"OBGRP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MRC_ObservationGroup.GRP_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ITM"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ITM_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexItem">
<Global>^MRC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>MRC_ObservationGroup.GRP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>ITM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"OBGRP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MRC_ObservationGroup.GRP_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ITM"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"Item"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ITM_ObsItem_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ITM_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ITM_RowId</SqlRowIdName>
<StreamLocation>^User.MRCObservationGroupItemsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
