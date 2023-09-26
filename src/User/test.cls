Class User.test Extends %Persistent [ SqlTableName = test, StorageStrategy = NewStorage1 ]
{

/// Drug Name (field CN in MIMS)
Property PHCDName As %String(MAXLEN = 120, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = PHCD_Name ];

/// Drug Code
Property PHCDCode As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ Required, SqlColumnNumber = 15, SqlFieldName = PHCD_Code ];

Method PHCDNameGet() As %Library.String
{
	Q "okok"
}

Storage NewStorage1
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCTest(0))</SqlIdExpression>
<SQLMap name="Map1">
<ConditionalWithHostVars></ConditionalWithHostVars>
<Data name="PHCD_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHCD_Name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCTest</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHCD_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHCD_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PHCD_RowId</SqlRowIdName>
<StreamLocation>^User.testS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
