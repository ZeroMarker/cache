/// JXUnit
Class dhc.pa.data.JXUnit Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = JXUnit_rowid, SqlTableName = JXUnit, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildUnitSchem As dhc.pa.data.UnitSchem [ Cardinality = children, Inverse = UnitSchemparRef ];

Relationship ChildJXBaseData As dhc.pa.data.JXBaseData [ Cardinality = children, Inverse = JXBaseDataparRef ];

/// JXUnit_appSysDr
Property JXUnitappSysDr As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = JXUnit_appSysDr ];

/// JXUnit_code
Property JXUnitcode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = JXUnit_code ];

/// JXUnit_name
Property JXUnitname As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = JXUnit_name ];

/// JXUnit_py
Property JXUnitpy As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = JXUnit_py ];

/// JXUnit_shortcut
Property JXUnitshortcut As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = JXUnit_shortcut ];

/// JXUnit_type
Property JXUnittype As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = JXUnit_type ];

/// JXUnit_jxLocTypeDr
Property JXUnitjxLocTypeDr As dhc.pa.data.JXLocType [ SqlColumnNumber = 8, SqlFieldName = JXUnit_jxLocTypeDr ];

/// JXUnit_isEnd 是否参与核算
Property JXUnitisEnd As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = JXUnit_isEnd ];

/// JXUnit_level
Property JXUnitlevel As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = JXUnit_level ];

/// JXUnit_aDeptDr
Property JXUnitaDeptDr As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = JXUnit_aDeptDr ];

/// JXUnit_parent
Property JXUnitparent As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = JXUnit_parent ];

/// JXUnit_stratagemDr
Property JXUnitstratagemDr As dhc.pa.data.Stratagem [ SqlColumnNumber = 13, SqlFieldName = JXUnit_stratagemDr ];

/// JXUnit_End 末端
Property JXUnitEnd As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = JXUnit_End ];

/// JXUnit_LocCode
Property JXUnitLocCode As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = JXUnit_LocCode ];

/// JXUnit_isStop 是否参与核算
Property JXUnitisStop As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 16, SqlFieldName = JXUnit_isStop ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCJXPAJXUNIT(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="JXUnit_End">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="JXUnit_LocCode">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="JXUnit_aDeptDr">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="JXUnit_appSysDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="JXUnit_code">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="JXUnit_isEnd">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="JXUnit_isStop">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="JXUnit_jxLocTypeDr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="JXUnit_level">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="JXUnit_name">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="JXUnit_parent">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="JXUnit_py">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="JXUnit_shortcut">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="JXUnit_stratagemDr">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="JXUnit_type">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCCJXPAJXUNIT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>JXUnit_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{JXUnit_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAPP">
<Global>^DHCCJXPAJXUNIT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>JXUnit_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AppSys"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{JXUnit_appSysDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{JXUnit_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCCJXPAJXUNIT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>JXUnit_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{JXUnit_code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{JXUnit_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocType">
<Global>^DHCCJXPAJXUNIT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>JXUnit_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LocType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{JXUnit_jxLocTypeDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{JXUnit_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexName">
<Global>^DHCCJXPAJXUNIT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>JXUnit_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Name"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{JXUnit_name}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{JXUnit_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPY">
<Global>^DHCCJXPAJXUNIT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>JXUnit_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PY"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{JXUnit_py}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{JXUnit_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexParent">
<Global>^DHCCJXPAJXUNIT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>JXUnit_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Parent"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{JXUnit_parent}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{JXUnit_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.pa.data.JXUnitS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
