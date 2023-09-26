/// MRC Observation Group(1714)
Class User.MRCObservationGroup Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MRC_ObservationGroup, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 23;

Relationship ChildMRCObservationGroupItems As MRCObservationGroupItems [ Cardinality = children, Inverse = ITMParRef ];

/// Code
Property GRPCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = GRP_Code ];

/// Description
Property GRPDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = GRP_Desc ];

/// Y Axis 1 Min Value
Property GRPYAxis1Min As %Float [ SqlColumnNumber = 4, SqlFieldName = GRP_YAxis1Min ];

/// Y Axis 1 Max
Property GRPYAxis1Max As %Float [ SqlColumnNumber = 5, SqlFieldName = GRP_YAxis1Max ];

/// Y Axis 2 Min Value
Property GRPYAxis2Min As %Float [ SqlColumnNumber = 6, SqlFieldName = GRP_YAxis2Min ];

/// Y Axis 2 Max Value
Property GRPYAxis2Max As %Float [ SqlColumnNumber = 7, SqlFieldName = GRP_YAxis2Max ];

/// Table IV Drugs
Property GRPTableIVDrugs As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = GRP_TableIVDrugs ];

/// Y Axis1 Interval
Property GRPYAxis1Interval As %Float [ SqlColumnNumber = 9, SqlFieldName = GRP_YAxis1Interval ];

/// Y Axis 2 Interval
Property GRPYAxis2Interval As %Float [ SqlColumnNumber = 10, SqlFieldName = GRP_YAxis2Interval ];

/// MarkSize
Property GRPMarkSize As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = GRP_MarkSize ];

/// Des Ref ObsStatus
Property GRPObsStatusDR As MRCObservationStatus [ SqlColumnNumber = 12, SqlFieldName = GRP_ObsStatus_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.MRCObservationStatus).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCObservationStatus","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.MRCObservationStatus).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCObservationStatus","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.MRCObservationStatus).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCObservationStatus","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.MRCObservationStatus).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCObservationStatus","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.MRCObservationStatus).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCObservationStatus","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>23</ExtentSize>
<Property name="GRPCode">
<Selectivity>4.3478%</Selectivity>
</Property>
<Property name="GRPDesc">
<Selectivity>4.3478%</Selectivity>
</Property>
<Property name="GRPMarkSize">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="GRPObsStatusDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="GRPTableIVDrugs">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="GRPYAxis1Interval">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="GRPYAxis1Max">
<Selectivity>14.2857%</Selectivity>
</Property>
<Property name="GRPYAxis1Min">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="GRPYAxis2Interval">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="GRPYAxis2Max">
<Selectivity>16.6667%</Selectivity>
</Property>
<Property name="GRPYAxis2Min">
<Selectivity>20.0000%</Selectivity>
</Property>
<SqlIdExpression>$i(^MRC("OBGRP",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="GRP_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="GRP_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="GRP_MarkSize">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="GRP_ObsStatus_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="GRP_TableIVDrugs">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="GRP_YAxis1Interval">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="GRP_YAxis1Max">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="GRP_YAxis1Min">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="GRP_YAxis2Interval">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="GRP_YAxis2Max">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="GRP_YAxis2Min">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^MRC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>GRP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"OBGRP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{GRP_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^MRC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>GRP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"OBGRP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({GRP_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{GRP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^MRC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>GRP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"OBGRP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({GRP_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{GRP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>GRP_RowId</SqlRowIdName>
<StreamLocation>^User.MRCObservationGroupS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
