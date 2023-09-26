Class User.DHCMatCatSpecial Extends (%Persistent, User.Abstract) [ SqlRowIdName = MCS_Rowid, SqlTableName = DHC_MatCatSpecial, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Property MCSCode As %Library.String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = MCS_Code ];

Property MCSDesc As %Library.String(COLLATION = "AlphaUp", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = MCS_Desc ];

Property MCSUplevelDR As User.DHCMatCatSpecial [ SqlColumnNumber = 4, SqlFieldName = MCS_Uplevel_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCMCS(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MCS_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MCS_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MCS_Uplevel_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCMCS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MCS_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{MCS_Rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCMCS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MCS_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({MCS_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MCS_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCMCS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MCS_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({MCS_Desc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MCS_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>MCS_Rowid</SqlRowIdName>
<StreamLocation>^User.DHCMatCatSpecialS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
