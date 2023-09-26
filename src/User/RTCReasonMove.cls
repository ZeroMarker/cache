/// RTC Reason for Move(1502)
Class User.RTCReasonMove Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RTC_Reason_Move, StorageStrategy = SQLStorage ]
{

/// Code
Property MOVECode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = MOVE_Code ];

/// Description
Property MOVEDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = MOVE_Desc ];

/// Active
Property MOVEActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = MOVE_Active ];

/// DateFrom
Property MOVEDateFrom As %Date [ SqlColumnNumber = 5, SqlFieldName = MOVE_DateFrom ];

/// DateTo
Property MOVEDateTo As %Date [ SqlColumnNumber = 6, SqlFieldName = MOVE_DateTo ];

Index MOVECodeUnqIdx1 On MOVECode [ Unique ];

Index MOVEDescUnqIdx2 On MOVEDesc [ Unique ];

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.RTCReasonMove).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RTCReasonMove","OnAfterDelete")
}

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.RTCReasonMove).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RTCReasonMove","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.RTCReasonMove).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RTCReasonMove","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.RTCReasonMove).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RTCReasonMove","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.RTCReasonMove).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RTCReasonMove","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RTCReasonMove","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>3</ExtentSize>
<Property name="MOVEActive">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="MOVECode">
<Selectivity>1</Selectivity>
</Property>
<Property name="MOVEDateFrom">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="MOVEDateTo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="MOVEDesc">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^RTC("MOVE",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MOVE_Active">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MOVE_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MOVE_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MOVE_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MOVE_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^RTC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>MOVE_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"MOVE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MOVE_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^RTC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MOVE_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"MOVE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({MOVE_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MOVE_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^RTC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MOVE_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"MOVE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({MOVE_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MOVE_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>MOVE_RowId</SqlRowIdName>
<StreamLocation>^User.RTCReasonMoveS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
