Class User.DHCMatCatClinical Extends (%Persistent, User.Abstract) [ SqlRowIdName = MCC_Rowid, SqlTableName = DHC_MatCatClinical, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Property MCCCode As %Library.String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = MCC_Code ];

Property MCCDesc As %Library.String(COLLATION = "AlphaUp", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = MCC_Desc ];

Property MCCUplevelDR As User.DHCMatCatClinical [ SqlColumnNumber = 4, SqlFieldName = MCC_Uplevel_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCMCC(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MCC_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MCC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MCC_Uplevel_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCMCC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MCC_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{MCC_Rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCMCC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MCC_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({MCC_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MCC_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCMCC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MCC_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({MCC_Desc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MCC_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>MCC_Rowid</SqlRowIdName>
<StreamLocation>^User.DHCMatCatClinicalS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
