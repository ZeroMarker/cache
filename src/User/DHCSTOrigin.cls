/// DHC_STOrigin
Class User.DHCSTOrigin Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = Orig_RowId, SqlTableName = DHC_STOrigin, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// Orig_Code
Property OrigCode As %String(COLLATION = "AlphaUp", MAXLEN = 12, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = Orig_Code ];

/// Orig_Name
Property OrigName As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = Orig_Name ];

/// Orig_Type
Property OrigType As %Library.String(DISPLAYLIST = ",Drug,Material,Others", MAXLEN = 8, SELECTIVITY = "25.0000%", VALUELIST = ",G,M,O") [ SqlColumnNumber = 4, SqlFieldName = Orig_Type ];

/// Orig_Hosp_Dr
Property OrigHospDr As User.CTHospital [ SqlColumnNumber = 5, SqlFieldName = Orig_Hosp_Dr ];

/// Orig_Alias
Property OrigAlias As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = Orig_Alias ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCSTORI(0))</SqlIdExpression>
<SQLMap name="IndexAlias">
<Global>^DHCSTORI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Orig_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"ALIAS"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{Orig_Alias}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{Orig_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCSTORI</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Orig_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({Orig_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Orig_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexName">
<Global>^DHCSTORI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Orig_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Name"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({Orig_Name})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Orig_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="Orig_Alias">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="Orig_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="Orig_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="Orig_Name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="Orig_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCSTORI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>Orig_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{Orig_Rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>Orig_RowId</SqlRowIdName>
<StreamLocation>^User.DHCSTOriginS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
