/// SS Notice Board(1729)
Class User.SSNoticeBoard Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_NoticeBoard, StorageStrategy = SQLStorage ]
{

/// Date
Property NBDate As %Date [ SqlColumnNumber = 2, SqlFieldName = NB_Date ];

/// Message
Property NBMessage As list Of %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = NB_Message, SqlListType = SUBNODE ];

/// Time
Property NBTime As %Time [ SqlColumnNumber = 3, SqlFieldName = NB_Time ];

/// Des Ref User
Property NBUserDR As SSUser [ SqlColumnNumber = 4, SqlFieldName = NB_User_DR ];

Parameter EXTENTSIZE = 1;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSNoticeBoard).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSNoticeBoard","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSNoticeBoard).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSNoticeBoard","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSNoticeBoard).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSNoticeBoard","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSNoticeBoard).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSNoticeBoard","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSNoticeBoard).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSNoticeBoard","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>1</ExtentSize>
<Property name="NBDate">
<Selectivity>1</Selectivity>
</Property>
<Property name="NBMessage">
<Selectivity>1</Selectivity>
</Property>
<Property name="NBTime">
<Selectivity>1</Selectivity>
</Property>
<Property name="NBUserDR">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^SST("NB",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="NB_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="NB_Message">
<Node>"TXT"</Node>
</Data>
<Data name="NB_Time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="NB_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^SST</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>NB_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"NB"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{NB_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^SST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>NB_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"NB"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{NB_Date}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{NB_Time}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{NB_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>NB_RowId</SqlRowIdName>
<StreamLocation>^User.SSNoticeBoardS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
