/// RTC Transaction Type(1556)
Class User.RTCTransactionType Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RTC_TransactionType, StorageStrategy = SQLStorage ]
{

/// Code
Property TTCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = TT_Code ];

/// Description
Property TTDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = TT_Desc ];

Index TTCodeUnqIdx1 On TTCode [ Unique ];

Parameter EXTENTSIZE = 19;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RTCTransactionType).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RTCTransactionType","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RTCTransactionType).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RTCTransactionType","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RTCTransactionType).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RTCTransactionType","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.RTCTransactionType).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RTCTransactionType","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RTCTransactionType).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RTCTransactionType","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>19</ExtentSize>
<Property name="TTCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="TTDesc">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^RTC("TT",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="TT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^RTC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>TT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"TT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{TT_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^RTC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>TT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"TT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({TT_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^RTC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>TT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"TT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({TT_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>TT_RowId</SqlRowIdName>
<StreamLocation>^User.RTCTransactionTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
