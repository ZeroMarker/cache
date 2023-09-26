/// RBC Reason for cancel(1732)
Class User.RBCReasonForCancel Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RBC_ReasonForCancel, StorageStrategy = SQLStorage ]
{

/// Code
Property RFCCode As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = RFC_Code ];

/// Description
Property RFCDesc As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = RFC_Desc ];

/// Initiator
Property RFCInitiator As %String(DISPLAYLIST = ",Hospital,Patient,Purchase", MAXLEN = 8, TRUNCATE = 1, VALUELIST = ",H,P,PU") [ SqlColumnNumber = 5, SqlFieldName = RFC_Initiator ];

/// Date From
Property RFCDateFrom As %Date [ SqlColumnNumber = 6, SqlFieldName = RFC_DateFrom ];

/// Date To
Property RFCDateTo As %Date [ SqlColumnNumber = 7, SqlFieldName = RFC_DateTo ];

/// Default
Property RFCDefault As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = RFC_Default ];

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.RBCReasonForCancel).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBCReasonForCancel","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.RBCReasonForCancel).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBCReasonForCancel","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.RBCReasonForCancel).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBCReasonForCancel","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.RBCReasonForCancel).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBCReasonForCancel","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBCReasonForCancel","OnBeforeInsert")
}

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.RBCReasonForCancel).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBCReasonForCancel","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^RBC("RFC",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="RFC_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RFC_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="RFC_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="RFC_Default">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="RFC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RFC_Initiator">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^RBC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>RFC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RFC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RFC_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^RBC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RFC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RFC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({RFC_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RFC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^RBC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RFC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RFC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({RFC_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RFC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>RFC_RowId</SqlRowIdName>
<StreamLocation>^User.RBCReasonForCancelS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
