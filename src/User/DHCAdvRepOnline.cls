Class User.DHCAdvRepOnline Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = RON_RowID, SqlTableName = DHC_AdvRepOnline, StorageStrategy = NewStorage1 ]
{

Property RONDate As %Date [ SqlColumnNumber = 2, SqlFieldName = RON_Date ];

Property RONTime As %Time [ SqlColumnNumber = 3, SqlFieldName = RON_Time ];

Property RONUser As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = RON_User ];

Property RONContent As %Library.String(COLLATION = "Exact", MAXLEN = 30000, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = RON_Content ];

Property RONOnlineDr As User.DHCAdvRepOnline [ SqlColumnNumber = 6, SqlFieldName = RON_Online_Dr ];

Property RONAcceptFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = RON_AcceptFlag ];

Property RONOkNum As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = RON_OkNum ];

Property RONShareDr As %Library.String [ SqlColumnNumber = 9, SqlFieldName = RON_Share_Dr ];

Storage NewStorage1
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCADVRON)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="RON_AcceptFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="RON_Content">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="RON_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RON_OkNum">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="RON_Online_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="RON_Share_Dr">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="RON_Time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RON_User">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCADVRON</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RON_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{RON_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexOnlineDr">
<Global>^DHCADVRON</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RON_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Online"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RON_Online_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RON_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexShare">
<Global>^DHCADVRON</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RON_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SHA"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RON_Share_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RON_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCAdvRepOnlineS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
