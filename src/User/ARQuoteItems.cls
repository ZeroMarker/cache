/// QuoteItems(2598)
Class User.ARQuoteItems Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = AR_QuoteItems, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On ITMChildsub [ IdKey, PrimaryKey, Unique ];

/// AR_Quote Parent Reference
Relationship ITMParRef As ARQuote [ Cardinality = parent, Inverse = ChildARQuoteItems, Required, SqlFieldName = ITM_ParRef ];

/// Childsub
Property ITMChildsub As %Float [ InitialExpression = {$i(^AR("QUOTE",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"ITM",0))}, SqlColumnNumber = 2, SqlFieldName = ITM_Childsub ];

/// Type
Property ITMType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = ITM_Type ];

/// Des Ref ARCIM
Property ITMARCIMDR As ARCItmMast [ SqlColumnNumber = 4, SqlFieldName = ITM_ARCIM_DR ];

/// Qty
Property ITMQty As %Float [ SqlColumnNumber = 5, SqlFieldName = ITM_Qty ];

/// PayorKey
Property ITMPayorKey As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = ITM_PayorKey ];

/// PayorDesc
Property ITMPayorDesc As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = ITM_PayorDesc ];

/// PatientDesc
Property ITMPatientDesc As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = ITM_PatientDesc ];

/// Bills Total Amt
Property ITMBillsTotalAmt As %Float [ SqlColumnNumber = 9, SqlFieldName = ITM_BillsTotalAmt ];

/// Price
Property ITMPrice As %Float [ SqlColumnNumber = 10, SqlFieldName = ITM_Price ];

/// PatientAmt
Property ITMPatientAmt As %Float [ SqlColumnNumber = 11, SqlFieldName = ITM_PatientAmt ];

/// PayorAmt
Property ITMPayorAmt As %Float [ SqlColumnNumber = 12, SqlFieldName = ITM_PayorAmt ];

/// BillItemKey
Property ITMBillItemKey As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = ITM_BillItemKey ];

/// PrintDate
Property ITMPrintDate As %Date [ SqlColumnNumber = 14, SqlFieldName = ITM_PrintDate ];

/// PrintTime
Property ITMPrintTime As %Time [ SqlColumnNumber = 15, SqlFieldName = ITM_PrintTime ];

/// ServiceTax
Property ITMServiceTax As %Float [ SqlColumnNumber = 16, SqlFieldName = ITM_ServiceTax ];

/// PriceBeforeDiscount
Property ITMPriceBeforeDiscount As %Float [ SqlColumnNumber = 17, SqlFieldName = ITM_PriceBeforeDiscount ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARQuoteItems).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARQuoteItems","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARQuoteItems).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARQuoteItems","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARQuoteItems).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARQuoteItems","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARQuoteItems).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARQuoteItems","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARQuoteItems).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARQuoteItems","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ITM_ARCIM_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ITM_BillItemKey">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ITM_BillsTotalAmt">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ITM_PatientAmt">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ITM_PatientDesc">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ITM_PayorAmt">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ITM_PayorDesc">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ITM_PayorKey">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ITM_Price">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ITM_PriceBeforeDiscount">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="ITM_PrintDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ITM_PrintTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ITM_Qty">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ITM_ServiceTax">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="ITM_Type">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^AR</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>AR_Quote.QT_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>ITM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"QUOTE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{AR_Quote.QT_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ITM"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ITM_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexType">
<Global>^AR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>AR_Quote.QT_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>ITM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"QUOTE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{AR_Quote.QT_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ITM"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"Type"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ITM_Type}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ITM_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ITM_RowId</SqlRowIdName>
<StreamLocation>^User.ARQuoteItemsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
