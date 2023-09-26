/// JXBaseData
Class dhc.pa.data.JXBaseData Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = JXBaseData_rowid, SqlTableName = JXBaseData, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On JXBaseDatachildSub [ IdKey, PrimaryKey, Unique ];

/// JXBaseData_parRef
Relationship JXBaseDataparRef As dhc.pa.data.JXUnit [ Cardinality = parent, Inverse = ChildJXBaseData, Required, SqlFieldName = JXBaseData_parRef ];

/// JXBaseData_childSub
Property JXBaseDatachildSub As %Library.Float [ InitialExpression = {$i(^DHCCJXPAJXUNIT($p(%d(0),$c(1),1),"JXBaseData",0))}, SqlColumnNumber = 2, SqlFieldName = JXBaseData_childSub ];

/// JXBaseData_period
Property JXBaseDataperiod As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = JXBaseData_period ];

/// JXBaseData_periodType
Property JXBaseDataperiodType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = JXBaseData_periodType ];

/// JXBaseData_KPIDr
Property JXBaseDataKPIDr As dhc.pa.data.KPIIndex1 [ SqlColumnNumber = 5, SqlFieldName = JXBaseData_KPIDr ];

/// JXBaseData_actualValue
Property JXBaseDataactualValue As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = JXBaseData_actualValue ];

/// JXBaseData_auditDate
Property JXBaseDataauditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = JXBaseData_auditDate ];

/// JXBaseData_auditUserDr
Property JXBaseDataauditUserDr As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = JXBaseData_auditUserDr ];

/// JXBaseData_dataState
Property JXBaseDatadataState As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = JXBaseData_dataState ];

/// JXBaseData_desc
Property JXBaseDatadesc As %Library.String(COLLATION = "Exact", MAXLEN = 30000, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = JXBaseData_desc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMast">
<Data name="JXBaseData_KPIDr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="JXBaseData_actualValue">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="JXBaseData_auditDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="JXBaseData_auditUserDr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="JXBaseData_dataState">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="JXBaseData_desc">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="JXBaseData_period">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="JXBaseData_periodType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCCJXPAJXUNIT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>JXUnit.JXUnit_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>JXBaseData_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{JXUnit.JXUnit_rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"JXBaseData"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{JXBaseData_childSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPeriodKPI">
<Global>^DHCCJXPAJXUNIT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>JXUnit.JXUnit_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>JXBaseData_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"JXBDPeriodKPI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{JXBaseData_parRef}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{JXBaseData_period}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{JXBaseData_periodType}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{JXBaseData_KPIDr}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{JXBaseData_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.pa.data.JXBaseDataS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
