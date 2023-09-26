/// CashShiftCancReason(2728)
Class User.ARCCashShiftCancReason Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_CashShiftCancReason, StorageStrategy = SQLStorage ]
{

/// Code
Property CSCRCode As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = CSCR_Code ];

/// Description
Property CSCRDesc As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = CSCR_Desc ];

/// Date From
Property CSCRDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = CSCR_DateFrom ];

/// Date To
Property CSCRDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = CSCR_DateTo ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCCashShiftCancReason).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCCashShiftCancReason","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCCashShiftCancReason).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCCashShiftCancReason","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCCashShiftCancReason).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCCashShiftCancReason","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCCashShiftCancReason).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCCashShiftCancReason","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCCashShiftCancReason).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCCashShiftCancReason","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>2</ExtentSize>
<Property name="CSCRCode">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="CSCRDateFrom">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="CSCRDateTo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="CSCRDesc">
<Selectivity>50.0000%</Selectivity>
</Property>
<SqlIdExpression>$i(^ARC("CSCR",0))</SqlIdExpression>
<SQLMap name="Datamaster">
<Data name="CSCR_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CSCR_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CSCR_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CSCR_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^ARC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CSCR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CSCR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CSCR_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CSCR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CSCR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({CSCR_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CSCR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CSCR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CSCR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({CSCR_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CSCR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CSCR_RowId</SqlRowIdName>
<StreamLocation>^User.ARCCashShiftCancReasonS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
