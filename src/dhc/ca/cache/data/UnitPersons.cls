Class dhc.ca.cache.data.UnitPersons Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = UnitPersons_rowid, SqlTableName = UnitPersons, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildPersonDepts As dhc.ca.cache.data.PersonDepts [ Cardinality = children, Inverse = PersonDeptsparRef ];

/// UnitPersons_code
Property UnitPersonscode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = UnitPersons_code ];

/// UnitPersons_name
Property UnitPersonsname As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = UnitPersons_name ];

/// UnitPersons_shortcut
Property UnitPersonsshortcut As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = UnitPersons_shortcut ];

/// UnitPersons_gender
Property UnitPersonsgender As %Library.String(COLLATION = "Exact", MAXLEN = 2, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = UnitPersons_gender ];

/// UnitPersons_birthday
Property UnitPersonsbirthday As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = UnitPersons_birthday ];

/// UnitPersons_national
Property UnitPersonsnational As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = UnitPersons_national ];

/// UnitPersons_birthPlace
Property UnitPersonsbirthPlace As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = UnitPersons_birthPlace ];

/// UnitPersons_education
Property UnitPersonseducation As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = UnitPersons_education ];

/// UnitPersons_title
Property UnitPersonstitle As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = UnitPersons_title ];

/// UnitPersons_duty
Property UnitPersonsduty As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = UnitPersons_duty ];

/// UnitPersons_state
Property UnitPersonsstate As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = UnitPersons_state ];

/// UnitPersons_preparation
Property UnitPersonspreparation As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = UnitPersons_preparation ];

/// UnitPersons_phone
Property UnitPersonsphone As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = UnitPersons_phone ];

/// UnitPersons_remark
Property UnitPersonsremark As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = UnitPersons_remark ];

/// UnitPersons_start
Property UnitPersonsstart As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 16, SqlFieldName = UnitPersons_start ];

/// UnitPersons_stop
Property UnitPersonsstop As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 17, SqlFieldName = UnitPersons_stop ];

/// UnitPersons_unitDr
Property UnitPersonsunitDr As dhc.ca.cache.data.Units [ SqlColumnNumber = 18, SqlFieldName = UnitPersons_unitDr ];

/// UnitPersons_active
Property UnitPersonsactive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 19, SqlFieldName = UnitPersons_active ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCAUNITPERSONS(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="UnitPersons_active">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="UnitPersons_birthPlace">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="UnitPersons_birthday">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="UnitPersons_code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="UnitPersons_duty">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="UnitPersons_education">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="UnitPersons_gender">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="UnitPersons_name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="UnitPersons_national">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="UnitPersons_phone">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="UnitPersons_preparation">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="UnitPersons_remark">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="UnitPersons_shortcut">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="UnitPersons_start">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="UnitPersons_state">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="UnitPersons_stop">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="UnitPersons_title">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="UnitPersons_unitDr">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Global>^DHCCAUNITPERSONS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>UnitPersons_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{UnitPersons_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexActive">
<Global>^DHCCAUNITPERSONS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>UnitPersons_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Active"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UnitPersons_active}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UnitPersons_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCCAUNITPERSONS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>UnitPersons_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UnitPersons_code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UnitPersons_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexName">
<Global>^DHCCAUNITPERSONS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>UnitPersons_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Name"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UnitPersons_name}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UnitPersons_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexShortcut">
<Global>^DHCCAUNITPERSONS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>UnitPersons_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Shortcut"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UnitPersons_shortcut}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UnitPersons_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUnit">
<Global>^DHCCAUNITPERSONS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>UnitPersons_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Unit"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UnitPersons_unitDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UnitPersons_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUnitActive">
<Global>^DHCCAUNITPERSONS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>UnitPersons_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"UnitActive"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UnitPersons_unitDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UnitPersons_active}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{UnitPersons_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUnitCode">
<Global>^DHCCAUNITPERSONS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>UnitPersons_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"UnitCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UnitPersons_unitDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UnitPersons_code}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{UnitPersons_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUnitName">
<Global>^DHCCAUNITPERSONS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>UnitPersons_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"UnitName"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UnitPersons_unitDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UnitPersons_name}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{UnitPersons_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.ca.c.UnitPersonsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
