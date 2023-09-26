/// Stratagem
Class dhc.pa.data.Stratagem Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = Stratagem_rowid, SqlTableName = Stratagem, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildAdjust As dhc.pa.data.Adjust [ Cardinality = children, Inverse = AdjustparRef ];

Relationship ChildSchem As dhc.pa.data.Schem [ Cardinality = children, Inverse = SchemparRef ];

Relationship ChildUnitResult As dhc.pa.data.UnitResult [ Cardinality = children, Inverse = UnitResultparRef ];

/// Stratagem_unitDr
Property StratagemunitDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = Stratagem_unitDr ];

/// Stratagem_cycleDr
Property StratagemcycleDr As dhc.pa.data.Cycle [ SqlColumnNumber = 3, SqlFieldName = Stratagem_cycleDr ];

/// Stratagem_code
Property Stratagemcode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = Stratagem_code ];

/// Stratagem_name
Property Stratagemname As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = Stratagem_name ];

/// Stratagem_shortcut
Property Stratagemshortcut As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = Stratagem_shortcut ];

/// Stratagem_isVFlag
Property StratagemisVFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = Stratagem_isVFlag ];

/// Stratagem_stateFlag
Property StratagemstateFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, SELECTIVITY = "33.3333%", TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = Stratagem_stateFlag ];

/// Stratagem_month
Property Stratagemmonth As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = Stratagem_month ];

/// Stratagem_desc
Property Stratagemdesc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = Stratagem_desc ];

/// Stratagem_linkFile
Property StratagemlinkFile As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = Stratagem_linkFile ];

/// Stratagem_nurFlag
Property StratagemnurFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = Stratagem_nurFlag ];

/// Stratagem_medFlag
Property StratagemmedFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = Stratagem_medFlag ];

/// Stratagem_postFlag
Property StratagempostFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = Stratagem_postFlag ];

/// Stratagem_currStratagem
Property StratagemcurrStratagem As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 15, SqlFieldName = Stratagem_currStratagem ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCJXPASTRATAGEM(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="Stratagem_code">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="Stratagem_currStratagem">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="Stratagem_cycleDr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="Stratagem_desc">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="Stratagem_isVFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="Stratagem_linkFile">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="Stratagem_medFlag">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="Stratagem_month">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="Stratagem_name">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="Stratagem_nurFlag">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="Stratagem_postFlag">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="Stratagem_shortcut">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="Stratagem_stateFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="Stratagem_unitDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCCJXPASTRATAGEM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>Stratagem_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{Stratagem_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCCJXPASTRATAGEM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Stratagem_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Stratagem_code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Stratagem_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCycle">
<Global>^DHCCJXPASTRATAGEM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Stratagem_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Cycle"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Stratagem_cycleDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Stratagem_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexName">
<Global>^DHCCJXPASTRATAGEM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Stratagem_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Name"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Stratagem_name}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Stratagem_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexShortCut">
<Global>^DHCCJXPASTRATAGEM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Stratagem_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Shortcut"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Stratagem_shortcut}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Stratagem_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUnitCycle">
<Global>^DHCCJXPASTRATAGEM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>Stratagem_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"UnitCycle"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Stratagem_unitDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Stratagem_cycleDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{Stratagem_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.pa.data.StratagemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
