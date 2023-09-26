/// Output Messages
Class User.SSMessages Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_Messages, StorageStrategy = SQLStorage ]
{

/// Korean Translation
Property SSMSGKoreanMessageTranslation As %String(COLLATION = "Exact", MAXLEN = 75, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = SSMSG_KoreanMessageTranslation ];

/// Message Number
Property SSMSGMessageNumber As %Numeric(SCALE = 0) [ InitialExpression = {$i(^SS("MESG"))}, Required, SqlFieldName = SSMSG_MessageNumber ];

/// Message Text
Property SSMSGMessageText As %String(COLLATION = "Exact", MAXLEN = 76, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = SSMSG_MessageText ];

Index RowIDBasedIDKeyIndex On SSMSGMessageNumber [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSMessages).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSMessages","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSMessages).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSMessages","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSMessages).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSMessages","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSMessages).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSMessages","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSMessages).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSMessages","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^SS("MESG"))</SqlIdExpression>
<SQLMap name="MasterMessages">
<Data name="SSMSG_KoreanMessageTranslation">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>1</Piece>
</Data>
<Data name="SSMSG_MessageText">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^SS</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SSMSG_MessageNumber</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"MESG"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{SSMSG_MessageNumber}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>SSMSG_MessageNumber</SqlRowIdName>
<StreamLocation>^User.SSMessagesS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
