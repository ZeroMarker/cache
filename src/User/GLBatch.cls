/// GL Batch(1770)
Class User.GLBatch Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = GL_Batch, StorageStrategy = SQLStorage ]
{

/// Date
Property GLBDate As %Date [ SqlColumnNumber = 3, SqlFieldName = GLB_Date ];

/// Date From
Property GLBDateFrom As %Date [ SqlColumnNumber = 6, SqlFieldName = GLB_DateFrom ];

/// Date To
Property GLBDateTo As %Date [ SqlColumnNumber = 7, SqlFieldName = GLB_DateTo ];

/// Batch Number
Property GLBNumber As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = GLB_Number ];

/// Time
Property GLBTime As %Time [ SqlColumnNumber = 4, SqlFieldName = GLB_Time ];

/// Des Ref User
Property GLBUserDR As SSUser [ SqlColumnNumber = 5, SqlFieldName = GLB_User_DR ];

Parameter EXTENTSIZE = 1;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.GLBatch).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.GLBatch","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.GLBatch).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.GLBatch","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.GLBatch).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.GLBatch","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.GLBatch).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.GLBatch","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.GLBatch).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.GLBatch","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>1</ExtentSize>
<Property name="GLBDate">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="GLBDateFrom">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="GLBDateTo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="GLBNumber">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="GLBTime">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="GLBUserDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<SqlIdExpression>$i(^GLB(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="GLB_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="GLB_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="GLB_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="GLB_Number">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="GLB_Time">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="GLB_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^GLB</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>GLB_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{GLB_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^GLB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>GLB_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{GLB_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{GLB_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexNumber">
<Global>^GLB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>GLB_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Num"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({GLB_Number})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{GLB_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>GLB_RowId</SqlRowIdName>
<StreamLocation>^User.GLBatchS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
