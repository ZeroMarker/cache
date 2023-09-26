Class dhc.ca.cache.data.LargCost Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = LargCost_rowid, SqlTableName = LargCost, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildLargCostDetail As dhc.ca.cache.data.LargCostDetail [ Cardinality = children, Inverse = LargCostDetailparRef ];

/// LargCost_vouchDate
Property LargCostvouchDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 2, SqlFieldName = LargCost_vouchDate ];

/// LargCost_vouchNum
Property LargCostvouchNum As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = LargCost_vouchNum ];

/// LargCost_abstract
Property LargCostabstract As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = LargCost_abstract ];

/// LargCost_deptDr
Property LargCostdeptDr As dhc.ca.cache.data.UnitDepts [ SqlColumnNumber = 5, SqlFieldName = LargCost_deptDr ];

/// LargCost_itemDr
Property LargCostitemDr As dhc.ca.cache.data.AllDataItems [ SqlColumnNumber = 6, SqlFieldName = LargCost_itemDr ];

/// LargCost_fee
Property LargCostfee As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = LargCost_fee ];

/// LargCost_calFlag
Property LargCostcalFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = LargCost_calFlag ];

/// LargCost_cycles
Property LargCostcycles As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = LargCost_cycles ];

/// LargCost_inPersonDr
Property LargCostinPersonDr As dhc.ca.cache.data.UnitPersons [ SqlColumnNumber = 10, SqlFieldName = LargCost_inPersonDr ];

/// LargCost_inDate
Property LargCostinDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = LargCost_inDate ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCALARGCOST("0"))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="LargCost_abstract">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="LargCost_calFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="LargCost_cycles">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="LargCost_deptDr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="LargCost_fee">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="LargCost_inDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="LargCost_inPersonDr">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="LargCost_itemDr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="LargCost_vouchDate">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="LargCost_vouchNum">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCCALARGCOST</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>LargCost_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{LargCost_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDeptItem">
<Global>^DHCCALARGCOST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>LargCost_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DeptItem"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LargCost_deptDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LargCost_itemDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{LargCost_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInDate">
<Global>^DHCCALARGCOST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>LargCost_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"InDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LargCost_inDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LargCost_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexItemDept">
<Global>^DHCCALARGCOST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>LargCost_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ItemDept"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LargCost_itemDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LargCost_deptDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{LargCost_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexVouchDate">
<Global>^DHCCALARGCOST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>LargCost_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"VouchDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LargCost_vouchDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LargCost_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexVouchNum">
<Global>^DHCCALARGCOST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>LargCost_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"VouchNum"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LargCost_vouchNum}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LargCost_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.ca.c.LargCostS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
