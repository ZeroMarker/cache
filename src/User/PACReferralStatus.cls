/// PAC Referral Status(2049)
Class User.PACReferralStatus Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_ReferralStatus, StorageStrategy = SQLStorage ]
{

Relationship ChildPACReferralStatusReason As PACReferralStatusReason [ Cardinality = children, Inverse = REAParRef ];

/// Code
Property RSTCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = RST_Code ];

/// Description
Property RSTDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = RST_Desc ];

/// National Code
Property RSTNationalCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = RST_NationalCode ];

/// Icon Name
Property RSTIcanName As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = RST_IcanName ];

/// Icon Priority
Property RSTIconPriority As %Numeric(MAXVAL = 100, MINVAL = 1, SCALE = 0) [ SqlColumnNumber = 6, SqlFieldName = RST_IconPriority ];

/// Date From
Property RSTDateFrom As %Date [ SqlColumnNumber = 7, SqlFieldName = RST_DateFrom ];

/// Date To
Property RSTDateTo As %Date [ SqlColumnNumber = 8, SqlFieldName = RST_DateTo ];

/// VisitStatus
Property RSTVisitStatus As %String(DISPLAYLIST = ",Booked,Cancelled,Not Accepted,Pending,Waiting,Discharge", MAXLEN = 12, TRUNCATE = 1, VALUELIST = ",B,C,N,P,W,D") [ SqlColumnNumber = 9, SqlFieldName = RST_VisitStatus ];

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.PACReferralStatus).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACReferralStatus","OnAfterDelete")
}

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.PACReferralStatus).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACReferralStatus","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.PACReferralStatus).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACReferralStatus","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.PACReferralStatus).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACReferralStatus","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.PACReferralStatus).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACReferralStatus","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACReferralStatus","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^PAC("RST",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="RST_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RST_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="RST_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="RST_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RST_IcanName">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="RST_IconPriority">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="RST_NationalCode">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RST_VisitStatus">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>RST_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RST"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RST_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RST_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RST"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({RST_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RST_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RST_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RST"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({RST_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RST_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>RST_RowId</SqlRowIdName>
<StreamLocation>^User.PACReferralStatusS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
