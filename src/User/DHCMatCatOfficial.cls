Class User.DHCMatCatOfficial Extends (%Persistent, User.Abstract) [ SqlRowIdName = MCO_Rowid, SqlTableName = DHC_MatCatOfficial, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Property MCOCode As %Library.String(COLLATION = "AlphaUp", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = MCO_Code ];

Property MCODesc As %Library.String(COLLATION = "AlphaUp", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = MCO_Desc ];

Property MCOUplevelDR As User.DHCMatCatOfficial [ SqlColumnNumber = 4, SqlFieldName = MCO_Uplevel_DR ];

Property MCOStkCatDR As User.INCStkCat [ SqlColumnNumber = 5, SqlFieldName = MCO_StkCat_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCMCO(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MCO_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MCO_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MCO_StkCat_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MCO_Uplevel_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCMCO</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MCO_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{MCO_Rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCMCO</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MCO_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({MCO_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MCO_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCMCO</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MCO_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({MCO_Desc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MCO_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>MCO_Rowid</SqlRowIdName>
<StreamLocation>^User.DHCMatCatOfficialS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
