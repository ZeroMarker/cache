Class User.DHCTaritemFieldConfig Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = Con_RowID, SqlTableName = DHC_TaritemFieldConfig, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// Con_FieldName
Property ConFieldName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = Con_FieldName ];

/// Con_Plist
Property ConPlist As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = Con_Plist ];

/// Con_Desc
Property ConDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = Con_Desc ];

/// Con_TableName
Property ConTableName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = Con_TableName ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCTARITEMFIELDCONFIG)</SqlIdExpression>
<SQLMap name="datamaster">
<Data name="Con_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="Con_FieldName">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="Con_Plist">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="Con_TableName">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCTARITEMFIELDCONFIG</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>Con_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{Con_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexFieldName">
<Global>^DHCTARITEMFIELDCONFIG</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Con_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Field"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Con_FieldName}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Con_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexplist">
<Global>^DHCTARITEMFIELDCONFIG</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>Con_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Plist"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Con_TableName}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Con_Plist}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{Con_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCTaritemFieldConfigS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
