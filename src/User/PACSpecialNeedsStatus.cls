/// SpecialNeedsStatus(2768)
Class User.PACSpecialNeedsStatus Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_SpecialNeedsStatus, StorageStrategy = SQLStorage ]
{

/// Code
Property SNSCode As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = SNS_Code ];

/// Description
Property SNSDesc As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = SNS_Desc ];

/// DateFrom
Property SNSDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = SNS_DateFrom ];

/// DateTo
Property SNSDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = SNS_DateTo ];

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.PACSpecialNeedsStatus).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACSpecialNeedsStatus","OnAfterDelete")
}

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.PACSpecialNeedsStatus).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACSpecialNeedsStatus","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.PACSpecialNeedsStatus).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACSpecialNeedsStatus","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.PACSpecialNeedsStatus).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACSpecialNeedsStatus","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.PACSpecialNeedsStatus).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACSpecialNeedsStatus","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACSpecialNeedsStatus","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^PAC("SNS",0))</SqlIdExpression>
<SQLMap name="Datamaster">
<Data name="SNS_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SNS_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SNS_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SNS_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SNS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SNS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SNS_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SNS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SNS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({SNS_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SNS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SNS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SNS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({SNS_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SNS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>SNS_RowId</SqlRowIdName>
<StreamLocation>^User.PACSpecialNeedsStatusS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
