Class User.DHCEQCChartsColorScheme Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = CCS_RowID, SqlTableName = DHC_EQCChartsColorScheme, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// CCS_Name
Property CCSName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = CCS_Name ];

/// CCS_Sort
Property CCSSort As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = CCS_Sort ];

/// CCS_Color
Property CCSColor As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = CCS_Color ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCChartsColorScheme",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="CCS_Color">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CCS_Name">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CCS_Sort">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CCS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCChartsColorScheme"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{CCS_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexName">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>CCS_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DHCEQCChartsColorScheme"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"NameSort"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CCS_Name}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CCS_Sort}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{CCS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCChartsColorSchemeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
