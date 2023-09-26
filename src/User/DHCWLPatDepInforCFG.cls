Class User.DHCWLPatDepInforCFG Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PDI_Rowid, SqlTableName = DHCWLPatDepInforCFG, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PDI_Desc
Property PDIDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PDI_Desc ];

/// PDI_Code
Property PDICode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PDI_Code ];

/// PDI_DateFlag
Property PDIDateFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PDI_DateFlag ];

/// PDI_Type
Property PDIType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PDI_Type ];

/// PDI_InterFlag
Property PDIInterFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PDI_InterFlag ];

/// PDI_Function
Property PDIFunction As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = PDI_Function ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCWLPDICFG)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="PDI_Code">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PDI_DateFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PDI_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PDI_Function">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PDI_InterFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PDI_Rowid">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PDI_Type">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCWLPDICFG</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PDI_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PDI_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPDICode">
<Global>^DHCWLPDICFG</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PDI_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDI_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PDI_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPDIDateFlag">
<Global>^DHCWLPDICFG</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PDI_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DateFlag"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDI_DateFlag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PDI_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPDIDateInterFlag">
<Global>^DHCWLPDICFG</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PDI_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DateInterFlag"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDI_DateFlag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PDI_InterFlag}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PDI_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPDIDesc">
<Global>^DHCWLPDICFG</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PDI_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDI_Desc}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PDI_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPDIInterFlag">
<Global>^DHCWLPDICFG</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PDI_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"InterFlag"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDI_InterFlag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PDI_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCWLPatDepInforCFGS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
