Class dhc.ca.cache.data.UnitMeasDev Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = UnitMeasDev_rowid, SqlTableName = UnitMeasDev, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildMeasDevDepts As dhc.ca.cache.data.MeasDevDepts [ Cardinality = children, Inverse = MeasDevDeptsparRef ];

/// UnitMeasureDevice_unitDr
Property UnitMeasDevunitDr As dhc.ca.cache.data.Units [ SqlColumnNumber = 2, SqlFieldName = UnitMeasDev_unitDr ];

/// UnitMeasDev_dataItemDr
Property UnitMeasDevdataItemDr As dhc.ca.cache.data.AllDataItems [ SqlColumnNumber = 3, SqlFieldName = UnitMeasDev_dataItemDr ];

/// UnitMeasDev_order
Property UnitMeasDevorder As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = UnitMeasDev_order ];

/// UnitMeasDev_code
Property UnitMeasDevcode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = UnitMeasDev_code ];

/// UnitMeasDev_remark
Property UnitMeasDevremark As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = UnitMeasDev_remark ];

/// UnitMeasDev_start
Property UnitMeasDevstart As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = UnitMeasDev_start ];

/// UnitMeasDev_stop
Property UnitMeasDevstop As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = UnitMeasDev_stop ];

/// UnitMeasDev_active
Property UnitMeasDevactive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = UnitMeasDev_active ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCAUNITMEASDEV(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="UnitMeasDev_active">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="UnitMeasDev_code">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="UnitMeasDev_dataItemDr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="UnitMeasDev_order">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="UnitMeasDev_remark">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="UnitMeasDev_start">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="UnitMeasDev_stop">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="UnitMeasDev_unitDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCCAUNITMEASDEV</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>UnitMeasDev_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{UnitMeasDev_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexUnit">
<Global>^DHCCAUNITMEASDEV</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>UnitMeasDev_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Unit"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UnitMeasDev_unitDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UnitMeasDev_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUnitActive">
<Global>^DHCCAUNITMEASDEV</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>UnitMeasDev_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"UnitActive"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UnitMeasDev_unitDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UnitMeasDev_active}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{UnitMeasDev_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUnitDataitem">
<Global>^DHCCAUNITMEASDEV</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>UnitMeasDev_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"UnitDataitem"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UnitMeasDev_unitDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UnitMeasDev_dataItemDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{UnitMeasDev_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUnitDataitemActive">
<Global>^DHCCAUNITMEASDEV</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>UnitMeasDev_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"UnitDataitemActive"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UnitMeasDev_unitDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UnitMeasDev_dataItemDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{UnitMeasDev_active}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{UnitMeasDev_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUnitDataitemCode">
<Global>^DHCCAUNITMEASDEV</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>UnitMeasDev_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"UnitDataitemCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UnitMeasDev_unitDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UnitMeasDev_dataItemDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{UnitMeasDev_code}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{UnitMeasDev_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUnitDataitemOrder">
<Global>^DHCCAUNITMEASDEV</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>UnitMeasDev_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"UnitDataitemOrder"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UnitMeasDev_unitDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UnitMeasDev_dataItemDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{UnitMeasDev_order}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{UnitMeasDev_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.ca.c.UnitMeasDevS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
