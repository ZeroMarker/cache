/// AR Batch(1663)
Class User.ARBatch Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = AR_Batch, StorageStrategy = SQLStorage ]
{

/// Batch Number
Property BATNumber As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = BAT_Number ];

/// Date Created
Property BATDateCreated As %Date [ SqlColumnNumber = 3, SqlFieldName = BAT_DateCreated ];

/// Time Created
Property BATTimeCreated As %Time [ SqlColumnNumber = 4, SqlFieldName = BAT_TimeCreated ];

/// Des Ref User
Property BATUserCreatedDR As SSUser [ SqlColumnNumber = 5, SqlFieldName = BAT_UserCreated_DR ];

/// Date Printed
Property BATDatePrinted As %Date [ SqlColumnNumber = 6, SqlFieldName = BAT_DatePrinted ];

/// Time Printed
Property BATTimePrinted As %Time [ SqlColumnNumber = 7, SqlFieldName = BAT_TimePrinted ];

/// Des Ref UserPrinted
Property BATUserPrintedDR As SSUser [ SqlColumnNumber = 8, SqlFieldName = BAT_UserPrinted_DR ];

/// Invoice Number
Property BATInvoiceNumber As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = BAT_InvoiceNumber ];

/// Des Ref InsType
Property BATInsTypeDR As ARCInsuranceType [ SqlColumnNumber = 10, SqlFieldName = BAT_InsType_DR ];

/// Des Ref AuxInsType
Property BATAuxInsTypeDR As ARCAuxilInsurType [ SqlColumnNumber = 11, SqlFieldName = BAT_AuxInsType_DR ];

/// Bill Date From
Property BATBillDateFrom As %Date [ SqlColumnNumber = 12, SqlFieldName = BAT_BillDateFrom ];

/// Bill Date To
Property BATBillDateTo As %Date [ SqlColumnNumber = 13, SqlFieldName = BAT_BillDateTo ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARBatch).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARBatch","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARBatch).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARBatch","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARBatch).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARBatch","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARBatch).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARBatch","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARBatch).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARBatch","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^ARB(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="BAT_AuxInsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="BAT_BillDateFrom">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="BAT_BillDateTo">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="BAT_DateCreated">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="BAT_DatePrinted">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="BAT_InsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="BAT_InvoiceNumber">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="BAT_Number">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BAT_TimeCreated">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="BAT_TimePrinted">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="BAT_UserCreated_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="BAT_UserPrinted_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^ARB</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>BAT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{BAT_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDateBillTo">
<Global>^ARB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BAT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DateTo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BAT_BillDateTo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BAT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateCreated">
<Global>^ARB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BAT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DateCreated"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BAT_DateCreated}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BAT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDatePrint">
<Global>^ARB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BAT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DatePrint"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BAT_DatePrinted}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BAT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInvoiceNumber">
<Global>^ARB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BAT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Invoice"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({BAT_InvoiceNumber})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BAT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexNotInvoiced">
<Condition>{BAT_InvoiceNumber}=""</Condition>
<ConditionFields>BAT_InvoiceNumber</ConditionFields>
<Global>^ARB</Global>
<PopulationPct>30</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>BAT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"NotInv"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BAT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexNumber">
<Global>^ARB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BAT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Number"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({BAT_Number})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BAT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPayor">
<Global>^ARB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BAT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Payor"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BAT_InsType_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BAT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPayorPlan">
<Global>^ARB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>BAT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PayorPlan"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BAT_AuxInsType_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BAT_InsType_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{BAT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>BAT_RowId</SqlRowIdName>
<StreamLocation>^User.ARBatchS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
