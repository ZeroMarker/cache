/// WaitingTimeStandard(2736)
Class User.PACWaitingTimeStandard Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_WaitingTimeStandard, StorageStrategy = SQLStorage ]
{

/// Code
Property WTSTCode As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = WTST_Code ];

/// Description
Property WTSTDesc As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = WTST_Desc ];

/// DateFrom
Property WTSTDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = WTST_DateFrom ];

/// DateTo
Property WTSTDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = WTST_DateTo ];

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.PACWaitingTimeStandard).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACWaitingTimeStandard","OnAfterDelete")
}

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.PACWaitingTimeStandard).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACWaitingTimeStandard","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.PACWaitingTimeStandard).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACWaitingTimeStandard","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.PACWaitingTimeStandard).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACWaitingTimeStandard","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.PACWaitingTimeStandard).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACWaitingTimeStandard","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^PAC("WTST",0))</SqlIdExpression>
<SQLMap name="Datamaster">
<Data name="WTST_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="WTST_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="WTST_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="WTST_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>WTST_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"WTST"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{WTST_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WTST_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"WTST"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({WTST_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WTST_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WTST_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"WTST"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({WTST_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WTST_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>WTST_RowId</SqlRowIdName>
<StreamLocation>^User.PACWaitingTimeStandardS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
