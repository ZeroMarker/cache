Class User.DHCPHLibFuntions Extends (%Persistent, User.Abstract) [ SqlRowIdName = PLF_RowId, SqlTableName = DHC_PHLibFuntions, StorageStrategy = NewStorage1 ]
{

Property PLFCode As %String [ SqlColumnNumber = 2, SqlFieldName = PLF_Code ];

Property PLFDesc As %String [ SqlColumnNumber = 3, SqlFieldName = PLF_Desc ];

Property PLFFuntions As %String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PLF_Funtions ];

Property PLFReturn As %String [ SqlColumnNumber = 5, SqlFieldName = PLF_Return ];

Property PLFRemark As %String [ SqlColumnNumber = 6, SqlFieldName = PLF_Remark ];

Property PLFActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = PLF_ActiveFlag ];

Property PLFCatDr As User.DHCPHFunCatFeild [ SqlColumnNumber = 8, SqlFieldName = PLF_Cat_Dr ];

Storage NewStorage1
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCPHLFUNS)</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCPHLFUNS</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PLF_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PLF_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PLF_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="PLF_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PLF_Cat_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PLF_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PLF_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PLF_Funtions">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PLF_Remark">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PLF_Return">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCPHLFUNS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PLF_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PLF_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHLibFuntionsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
