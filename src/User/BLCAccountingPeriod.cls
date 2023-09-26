/// Accounting Period(2491)
Class User.BLCAccountingPeriod Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = BLC_AccountingPeriod, StorageStrategy = SQLStorage ]
{

/// Code
Property PERCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = PER_Code ];

/// Description
Property PERDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = PER_Desc ];

/// Date From
Property PERDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = PER_DateFrom ];

/// Date To
Property PERDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = PER_DateTo ];

/// Status
Property PERStatus As %String(DISPLAYLIST = ",Open,Closed", MAXLEN = 6, TRUNCATE = 1, VALUELIST = ",O,C") [ SqlColumnNumber = 6, SqlFieldName = PER_Status ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.BLCAccountingPeriod).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.BLCAccountingPeriod","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.BLCAccountingPeriod).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.BLCAccountingPeriod","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.BLCAccountingPeriod).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.BLCAccountingPeriod","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.BLCAccountingPeriod).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.BLCAccountingPeriod","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.BLCAccountingPeriod).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.BLCAccountingPeriod","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^BLC("PER",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PER_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PER_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PER_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PER_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PER_Status">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^BLC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PER_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PER"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PER_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^BLC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PER_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PER"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({PER_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PER_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^BLC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PER_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PER"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({PER_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PER_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PER_RowId</SqlRowIdName>
<StreamLocation>^User.BLCAccountingPeriodS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
