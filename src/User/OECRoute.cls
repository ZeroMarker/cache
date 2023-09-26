/// Route(2490)
Class User.OECRoute Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = OEC_Route, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 7;

Relationship ChildOECRouteAdmin As OECRouteAdmin [ Cardinality = children, Inverse = ADMParRef ];

/// Code
Property ROUTECode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = ROUTE_Code ];

/// Description
Property ROUTEDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = ROUTE_Desc ];

/// Date From
Property ROUTEDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = ROUTE_DateFrom ];

/// Date To
Property ROUTEDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = ROUTE_DateTo ];

/// IVType
Property ROUTEIVType As %String(DISPLAYLIST = ",Continuous IV,Mini-bag,IV Push", MAXLEN = 13, TRUNCATE = 1, VALUELIST = ",C,M,P") [ SqlColumnNumber = 6, SqlFieldName = ROUTE_IVType ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.OECRoute).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECRoute","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.OECRoute).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECRoute","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.OECRoute).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECRoute","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.OECRoute).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECRoute","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.OECRoute).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECRoute","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>7</ExtentSize>
<Property name="ROUTECode">
<Selectivity>14.2857%</Selectivity>
</Property>
<Property name="ROUTEDateFrom">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="ROUTEDateTo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="ROUTEDesc">
<Selectivity>14.2857%</Selectivity>
</Property>
<Property name="ROUTEIVType">
<Selectivity>25.0000%</Selectivity>
</Property>
<SqlIdExpression>$i(^OEC("ROUTE",0))</SqlIdExpression>
<SQLMap name="Datamaster">
<Data name="ROUTE_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ROUTE_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ROUTE_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ROUTE_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ROUTE_IVType">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^OEC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ROUTE_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ROUTE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ROUTE_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^OEC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ROUTE_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ROUTE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({ROUTE_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ROUTE_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^OEC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ROUTE_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ROUTE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({ROUTE_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ROUTE_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ROUTE_RowId</SqlRowIdName>
<StreamLocation>^User.OECRouteS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
