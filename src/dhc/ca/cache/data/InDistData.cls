Class dhc.ca.cache.data.InDistData Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = InDistData_rowid, SqlTableName = InDistData, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// InDistData_intervalDr
Property InDistDataintervalDr As dhc.ca.cache.data.AccountMonths [ SqlColumnNumber = 2, SqlFieldName = InDistData_intervalDr ];

/// InDistData_flag
Property InDistDataflag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = InDistData_flag ];

/// InDistData_deptDr
Property InDistDatadeptDr As dhc.ca.cache.data.UnitDepts [ SqlColumnNumber = 4, SqlFieldName = InDistData_deptDr ];

/// InDistData_itemDr
Property InDistDataitemDr As dhc.ca.cache.data.AllDataItems [ SqlColumnNumber = 5, SqlFieldName = InDistData_itemDr ];

/// InDistData_fee
Property InDistDatafee As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = InDistData_fee ];

/// InDistData_inType
Property InDistDatainType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = InDistData_inType ];

/// InDistData_remark
Property InDistDataremark As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = InDistData_remark ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCAINDISTDATA(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="InDistData_deptDr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="InDistData_fee">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="InDistData_flag">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="InDistData_inType">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="InDistData_intervalDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="InDistData_itemDr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="InDistData_remark">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCCAINDISTDATA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>InDistData_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{InDistData_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexInt">
<Global>^DHCCAINDISTDATA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>InDistData_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Int"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InDistData_intervalDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{InDistData_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexIntDept">
<Global>^DHCCAINDISTDATA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>InDistData_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IntDept"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InDistData_intervalDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{InDistData_deptDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{InDistData_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexIntItem">
<Global>^DHCCAINDISTDATA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>InDistData_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IntItem"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InDistData_intervalDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{InDistData_itemDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{InDistData_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.ca.c.InDistDataS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
