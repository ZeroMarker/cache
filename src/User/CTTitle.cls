/// CT Title(1872)
Class User.CTTitle Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CT_Title, StorageStrategy = SQLStorage ]
{

/// Code
Property TTLCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = TTL_Code ];

/// Date From
Property TTLDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = TTL_DateFrom ];

/// Date To
Property TTLDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = TTL_DateTo ];

/// Description
Property TTLDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = TTL_Desc ];

Parameter EXTENTSIZE = 13;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTTitle).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTTitle","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTTitle).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTTitle","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTTitle).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTTitle","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTTitle).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTTitle","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTTitle).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTTitle","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>13</ExtentSize>
<Property name="TTLCode">
<Selectivity>7.6923%</Selectivity>
</Property>
<Property name="TTLDateFrom">
<Selectivity>16.6667%</Selectivity>
</Property>
<Property name="TTLDateTo">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="TTLDesc">
<Selectivity>7.6923%</Selectivity>
</Property>
<SqlIdExpression>$i(^CT("TTL",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="TTL_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TTL_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="TTL_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="TTL_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>TTL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"TTL"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{TTL_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>TTL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"TTL"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({TTL_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TTL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>TTL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"TTL"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({TTL_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TTL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>TTL_RowId</SqlRowIdName>
<StreamLocation>^User.CTTitleS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
