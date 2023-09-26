Class dhc.ca.cache.data.BudgetData Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = BudgetData_rowid, SqlTableName = BudgetData, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// BudgetData_intervalDr
Property BudgetDataintervalDr As dhc.ca.cache.data.AccountMonths [ SqlColumnNumber = 2, SqlFieldName = BudgetData_intervalDr ];

/// BudgetData_deptDr
Property BudgetDatadeptDr As dhc.ca.cache.data.UnitDepts [ SqlColumnNumber = 3, SqlFieldName = BudgetData_deptDr ];

/// BudgetData_itemDr
Property BudgetDataitemDr As dhc.ca.cache.data.AllDataItems [ SqlColumnNumber = 4, SqlFieldName = BudgetData_itemDr ];

/// BudgetData_amount
Property BudgetDataamount As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = BudgetData_amount ];

/// BudgetData_price
Property BudgetDataprice As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = BudgetData_price ];

/// BudgetData_fee
Property BudgetDatafee As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = BudgetData_fee ];

/// BudgetData_remark
Property BudgetDataremark As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = BudgetData_remark ];

/// BudgetData_type
Property BudgetDatatype As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = BudgetData_type ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCABUDGETDATA(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="BudgetData_amount">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="BudgetData_deptDr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="BudgetData_fee">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="BudgetData_intervalDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BudgetData_itemDr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="BudgetData_price">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="BudgetData_remark">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="BudgetData_type">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^DHCCABUDGETDATA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>BudgetData_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{BudgetData_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexIntDeptItem">
<Global>^DHCCABUDGETDATA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>BudgetData_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IntDeptItem"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BudgetData_intervalDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BudgetData_deptDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{BudgetData_itemDr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{BudgetData_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexIntItemDept">
<Global>^DHCCABUDGETDATA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>BudgetData_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IntItemDept"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BudgetData_intervalDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BudgetData_itemDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{BudgetData_deptDr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{BudgetData_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.ca.c.BudgetDataS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
