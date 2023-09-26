/// RBC Transfer Appt Reason(1523)
Class User.RBCTransferApptReason Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RBC_TransferApptReason, StorageStrategy = SQLStorage ]
{

/// Code
Property APTRANCode As %String(COLLATION = "AlphaUp", MAXLEN = 5, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = APTRAN_Code ];

/// Description
Property APTRANDesc As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = APTRAN_Desc ];

/// Date From
Property APTRANDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = APTRAN_DateFrom ];

/// Date To
Property APTRANDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = APTRAN_DateTo ];

/// Initiator
Property APTRANInitiator As %String(DISPLAYLIST = ",Hospital,Patient,Purchase", MAXLEN = 8, TRUNCATE = 1, VALUELIST = ",H,P,PU") [ SqlColumnNumber = 6, SqlFieldName = APTRAN_Initiator ];

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.RBCTransferApptReason).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBCTransferApptReason","OnAfterDelete")
}

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.RBCTransferApptReason).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBCTransferApptReason","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.RBCTransferApptReason).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBCTransferApptReason","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.RBCTransferApptReason).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBCTransferApptReason","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBCTransferApptReason","OnBeforeInsert")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.RBCTransferApptReason).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBCTransferApptReason","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^RBC("APTRAN",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="APTRAN_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="APTRAN_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="APTRAN_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="APTRAN_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="APTRAN_Initiator">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^RBC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>APTRAN_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"APTRAN"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{APTRAN_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^RBC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>APTRAN_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"APTRAN"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({APTRAN_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{APTRAN_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^RBC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>APTRAN_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"APTRAN"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({APTRAN_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{APTRAN_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>APTRAN_RowId</SqlRowIdName>
<StreamLocation>^User.RBCTransferApptReasonS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
