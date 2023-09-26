Class dhc.ca.cache.data.ParamDatas Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ParamDatas_rowid, SqlTableName = ParamDatas, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// ParamDatas_intervalDr
Property ParamDatasintervalDr As dhc.ca.cache.data.AccountMonths [ SqlColumnNumber = 2, SqlFieldName = ParamDatas_intervalDr ];

/// ParamDatas_itemCode
Property ParamDatasitemCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ParamDatas_itemCode ];

/// ParamDatas_itemName
Property ParamDatasitemName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = ParamDatas_itemName ];

/// ParamDatas_itemDr
Property ParamDatasitemDr As dhc.ca.cache.data.AllDataItems [ SqlColumnNumber = 5, SqlFieldName = ParamDatas_itemDr ];

/// ParamDatas_servDeptCode
Property ParamDatasservDeptCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = ParamDatas_servDeptCode ];

/// ParamDatas_servDeptName
Property ParamDatasservDeptName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = ParamDatas_servDeptName ];

/// ParamDatas_servDeptDr
Property ParamDatasservDeptDr As dhc.ca.cache.data.UnitDepts [ SqlColumnNumber = 8, SqlFieldName = ParamDatas_servDeptDr ];

/// ParamDatas_servedDeptCode
Property ParamDatasservedDeptCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = ParamDatas_servedDeptCode ];

/// ParamDatas_servedDeptName
Property ParamDatasservedDeptName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = ParamDatas_servedDeptName ];

/// ParamDatas_servedDeptDr
Property ParamDatasservedDeptDr As dhc.ca.cache.data.UnitDepts [ SqlColumnNumber = 11, SqlFieldName = ParamDatas_servedDeptDr ];

/// ParamDatas_value
Property ParamDatasvalue As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = ParamDatas_value ];

/// ParamDatas_inType
Property ParamDatasinType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = ParamDatas_inType ];

/// ParamDatas_inPersonDr
Property ParamDatasinPersonDr As dhc.ca.cache.data.UnitPersons [ SqlColumnNumber = 14, SqlFieldName = ParamDatas_inPersonDr ];

/// ParamDatas_remark
Property ParamDatasremark As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = ParamDatas_remark ];

/// ParamDatas_inDate
Property ParamDatasinDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 16, SqlFieldName = ParamDatas_inDate ];

/// ParamDatas_fDocCode
Property ParamDatasfDocCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = ParamDatas_fDocCode ];

/// ParamDatas_fDocName
Property ParamDatasfDocName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = ParamDatas_fDocName ];

/// ParamDatas_fDocDr
Property ParamDatasfDocDr As dhc.ca.cache.data.UnitPersons [ SqlColumnNumber = 19, SqlFieldName = ParamDatas_fDocDr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCAPARAMDATAS(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="ParamDatas_fDocCode">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="ParamDatas_fDocDr">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="ParamDatas_fDocName">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="ParamDatas_inDate">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="ParamDatas_inPersonDr">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ParamDatas_inType">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ParamDatas_intervalDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ParamDatas_itemCode">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ParamDatas_itemDr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ParamDatas_itemName">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ParamDatas_remark">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="ParamDatas_servDeptCode">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ParamDatas_servDeptDr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ParamDatas_servDeptName">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ParamDatas_servedDeptCode">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ParamDatas_servedDeptDr">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ParamDatas_servedDeptName">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ParamDatas_value">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Global>^DHCCAPARAMDATAS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ParamDatas_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ParamDatas_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexInterval">
<Global>^DHCCAPARAMDATAS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ParamDatas_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Interval"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ParamDatas_intervalDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ParamDatas_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexIntervalIndate">
<Global>^DHCCAPARAMDATAS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ParamDatas_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IntervalIndate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ParamDatas_intervalDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ParamDatas_inDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ParamDatas_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexIntervalItem">
<Global>^DHCCAPARAMDATAS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ParamDatas_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IntervalItem"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ParamDatas_intervalDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ParamDatas_itemDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ParamDatas_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexIntervalPerson">
<Global>^DHCCAPARAMDATAS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ParamDatas_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IntervalPerson"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ParamDatas_intervalDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ParamDatas_inPersonDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ParamDatas_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexIntervalSerdep">
<Global>^DHCCAPARAMDATAS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ParamDatas_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IntervalSerdep"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ParamDatas_intervalDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ParamDatas_servDeptDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ParamDatas_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexIntervalSerdepItem">
<Global>^DHCCAPARAMDATAS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>ParamDatas_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IntervalSerdepItem"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ParamDatas_intervalDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ParamDatas_servDeptDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ParamDatas_itemDr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ParamDatas_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexIntervalSereddep">
<Global>^DHCCAPARAMDATAS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ParamDatas_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IntervalSereddep"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ParamDatas_intervalDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ParamDatas_servedDeptDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ParamDatas_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexIntervalSereddepItem">
<Global>^DHCCAPARAMDATAS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>ParamDatas_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IntervalSereddepItem"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ParamDatas_intervalDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ParamDatas_servedDeptDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ParamDatas_itemDr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ParamDatas_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.ca.c.ParamDatasS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
