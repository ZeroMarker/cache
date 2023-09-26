Class dhc.pa.data.IndexMap Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = IndexMap_rowid, SqlTableName = IndexMap, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// IndexMap_KPIDr
Property IndexMapKPIDr As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = IndexMap_KPIDr ];

/// IndexMap_isLoad
Property IndexMapisLoad As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 3, SqlFieldName = IndexMap_isLoad ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCJXPAINDEXMAP)</SqlIdExpression>
<SQLMap name="Master">
<Data name="IndexMap_KPIDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="IndexMap_isLoad">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCCJXPAINDEXMAP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>IndexMap_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{IndexMap_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^dhc.pa.data.IndexMapS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
