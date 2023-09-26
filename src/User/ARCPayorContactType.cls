/// ARC PayorContact Type(1903)
Class User.ARCPayorContactType Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_PayorContactType, StorageStrategy = SQLStorage ]
{

/// Code
Property PCTCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = PCT_Code ];

/// Date From
Property PCTDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = PCT_DateFrom ];

/// Date To
Property PCTDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = PCT_DateTo ];

/// Description
Property PCTDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = PCT_Desc ];

Parameter EXTENTSIZE = 12;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCPayorContactType).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCPayorContactType","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCPayorContactType).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCPayorContactType","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCPayorContactType).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCPayorContactType","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCPayorContactType).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCPayorContactType","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCPayorContactType).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCPayorContactType","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>12</ExtentSize>
<Property name="PCTCode">
<Selectivity>8.3333%</Selectivity>
</Property>
<Property name="PCTDateFrom">
<Selectivity>16.6667%</Selectivity>
</Property>
<Property name="PCTDateTo">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="PCTDesc">
<Selectivity>8.3333%</Selectivity>
</Property>
<SqlIdExpression>$i(^ARC("PCT",0))</SqlIdExpression>
<SQLMap name="Datamaster">
<Data name="PCT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PCT_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PCT_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PCT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^ARC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PCT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PCT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PCT_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PCT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PCT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({PCT_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PCT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PCT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PCT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({PCT_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PCT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PCT_RowId</SqlRowIdName>
<StreamLocation>^User.ARCPayorContactTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
