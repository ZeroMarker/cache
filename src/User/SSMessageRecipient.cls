/// SS Message Recipient(2019)
Class User.SSMessageRecipient Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_MessageRecipient, StorageStrategy = SQLStorage ]
{

/// Des Ref Message
Property MESSRECMessageDR As SSMessage [ SqlColumnNumber = 2, SqlFieldName = MESSREC_Message_DR ];

/// Des Ref User
Property MESSRECUserDR As SSUser [ SqlColumnNumber = 3, SqlFieldName = MESSREC_User_DR ];

/// Date Read
Property MESSRECDateRead As %Date [ SqlColumnNumber = 4, SqlFieldName = MESSREC_DateRead ];

/// Time Read
Property MESSRECTimeRead As %Time [ SqlColumnNumber = 5, SqlFieldName = MESSREC_TimeRead ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSMessageRecipient).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ClassName","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSMessageRecipient).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSMessageRecipient","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSMessageRecipient).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSMessageRecipient","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSMessageRecipient).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSMessageRecipient","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSMessageRecipient).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSMessageRecipient","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^SST("MESSREC",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MESSREC_DateRead">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MESSREC_Message_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MESSREC_TimeRead">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MESSREC_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^SST</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>MESSREC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"MESSREC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MESSREC_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDateRead">
<Global>^SST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>MESSREC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"MESSREC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DateRead"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MESSREC_DateRead}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MESSREC_TimeRead}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{MESSREC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexNotRead">
<Condition>'{MESSREC_DateRead}</Condition>
<ConditionFields>MESSREC_DateRead,MESSREC_User_DR</ConditionFields>
<Global>^SST</Global>
<PopulationPct>10</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MESSREC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"MESSREC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"NotRead"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MESSREC_User_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MESSREC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUser">
<Global>^SST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>MESSREC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"MESSREC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"User"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MESSREC_User_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MESSREC_DateRead}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{MESSREC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUserAll">
<Global>^SST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MESSREC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"MESSREC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"UserAll"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MESSREC_User_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MESSREC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>MESSREC_RowId</SqlRowIdName>
<StreamLocation>^User.SSMessageRecipientS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
