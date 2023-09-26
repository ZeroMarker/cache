Class dhc.ca.cache.data.InDataCarding Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = InDataCarding_rowid, SqlTableName = InDataCarding, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildInDataCardRule As dhc.ca.cache.data.InDataCardRule [ Cardinality = children, Inverse = InDataCardRuleparRef ];

/// InDataCarding_priority
Property InDataCardingpriority As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = InDataCarding_priority ];

/// InDataCarding_code
Property InDataCardingcode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = InDataCarding_code ];

/// InDataCarding_name
Property InDataCardingname As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = InDataCarding_name ];

/// InDataCarding_shortcut
Property InDataCardingshortcut As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = InDataCarding_shortcut ];

/// InDataCarding_remark
Property InDataCardingremark As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = InDataCarding_remark ];

/// InDataCarding_Active
Property InDataCardingActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = InDataCarding_Active ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCAINDATACARDING(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="InDataCarding_Active">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="InDataCarding_code">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="InDataCarding_name">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="InDataCarding_priority">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="InDataCarding_remark">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="InDataCarding_shortcut">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCCAINDATACARDING</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>InDataCarding_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{InDataCarding_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCCAINDATACARDING</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>InDataCarding_rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InDataCarding_code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{InDataCarding_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPri">
<Global>^DHCCAINDATACARDING</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>InDataCarding_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Pri"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InDataCarding_priority}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{InDataCarding_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.ca.c.InDataCardingS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
