Class dhc.pa.data.MedIncome Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MedIncome_rowid, SqlTableName = MedIncome, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// YearMonth
Property YearMonth As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

/// DeptDr
Property DeptDr As dhc.pa.data.JXUnit [ SqlColumnNumber = 3 ];

/// MedName
Property MedName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

/// Income
Property Income As %Library.Float [ SqlColumnNumber = 5 ];

/// KpiDr
Property KpiDr As dhc.pa.data.KPIIndex1 [ SqlColumnNumber = 6 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCJXPAMEDINCOME)</SqlIdExpression>
<SQLMap name="Master">
<Data name="DeptDr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="Income">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="KpiDr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MedName">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="YearMonth">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCCJXPAMEDINCOME</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MedIncome_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{MedIncome_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^dhc.pa.data.MedIncomeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
