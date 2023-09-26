/// SS User Defined Function(1538)
Class User.SSUserDefinedFunction Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_UserDefinedFunction, StorageStrategy = SQLStorage ]
{

/// Description
Property VALDesc As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = VAL_Desc ];

/// Program Name
Property VALProgramName As %String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = VAL_ProgramName ];

Index VALDescUnqIdx1 On VALDesc [ Unique ];

Parameter EXTENTSIZE = 102;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSUserDefinedFunction).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSUserDefinedFunction","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSUserDefinedFunction).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSUserDefinedFunction","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSUserDefinedFunction).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSUserDefinedFunction","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSUserDefinedFunction).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSUserDefinedFunction","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSUserDefinedFunction).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSUserDefinedFunction","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>102</ExtentSize>
<Property name="VALDesc">
<Selectivity>1</Selectivity>
</Property>
<Property name="VALProgramName">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^SS("VAL",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="VAL_Desc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="VAL_ProgramName">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^SS</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>VAL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"VAL"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{VAL_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^SS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>VAL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"VAL"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({VAL_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{VAL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>VAL_RowId</SqlRowIdName>
<StreamLocation>^User.SSUserDefinedFunctionS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
