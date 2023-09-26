Class User.DHCWLBaseInforCFG Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = BIC_Rowid, SqlTableName = DHCWLBaseInforCFG, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// BIC_Desc
Property BICDesc As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = BIC_Desc ];

/// BIC_Code
Property BICCode As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = BIC_Code ];

/// BIC_DateFlag
Property BICDateFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = BIC_DateFlag ];

/// BIC_InterFlag
Property BICInterFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = BIC_InterFlag ];

/// BIC_Nature
Property BICNature As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = BIC_Nature ];

/// BIC_Function
Property BICFunction As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = BIC_Function ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCWLBIC(0))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="BIC_Code">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="BIC_DateFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="BIC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="BIC_Function">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="BIC_InterFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="BIC_Nature">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="BIC_Rowid">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCWLBIC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>BIC_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{BIC_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBICCode">
<Global>^DHCWLBIC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BIC_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BIC_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BIC_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexBICDateFlag">
<Global>^DHCWLBIC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BIC_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DateFlag"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BIC_DateFlag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BIC_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexBICDesc">
<Global>^DHCWLBIC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BIC_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BIC_Desc}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BIC_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexBICInterFlag">
<Global>^DHCWLBIC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BIC_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"InterFlag"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BIC_InterFlag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BIC_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexBICNature">
<Global>^DHCWLBIC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BIC_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Nature"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BIC_Nature}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BIC_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCWLBaseInforCFGS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
