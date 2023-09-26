/// SS Message(2018)
Class User.SSMessage Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_Message, StorageStrategy = SQLStorage ]
{

/// Date Created
Property MESSDateCreated As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 2, SqlFieldName = MESS_DateCreated ];

/// Time Created
Property MESSTimeCreated As %Time [ InitialExpression = {+$p($h,",",2)}, SqlColumnNumber = 3, SqlFieldName = MESS_TimeCreated ];

/// Des Ref UserCreated
Property MESSUserCreatedDR As SSUser [ SqlColumnNumber = 4, SqlFieldName = MESS_UserCreated_DR ];

/// Message
Property MESSMessage As list Of %String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = MESS_Message, SqlListType = SUBNODE ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSMessage).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSMessage","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSMessage).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSMessage","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSMessage).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSMessage","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSMessage).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSMessage","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSMessage).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSMessage","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^SST("MESS",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MESS_DateCreated">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MESS_Message">
<Node>"TXT"</Node>
</Data>
<Data name="MESS_TimeCreated">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MESS_UserCreated_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^SST</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>MESS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"MESS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MESS_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^SST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>MESS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"MESS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MESS_DateCreated}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MESS_TimeCreated}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{MESS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>MESS_RowId</SqlRowIdName>
<StreamLocation>^User.SSMessageS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
