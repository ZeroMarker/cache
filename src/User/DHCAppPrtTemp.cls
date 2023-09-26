Class User.DHCAppPrtTemp Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = APT_RowID, SqlTableName = DHC_AppPrtTemp, StorageStrategy = SQLStorage ]
{

/// 分类代码 APT_Cat_Dr
Property APTCatDr As User.DHCAppArcCat [ SqlColumnNumber = 2, SqlFieldName = APT_Cat_Dr ];

/// 分类描述 APT_TempText
Property APTTempText As %Text(MAXLEN = 100) [ SqlColumnNumber = 3, SqlFieldName = APT_TempText ];

/// 病人类型
Property APTType As %String [ SqlColumnNumber = 4, SqlFieldName = APT_Type ];

/// 性别
Property APTSex As User.CTSex [ SqlColumnNumber = 5, SqlFieldName = APT_Sex ];

/// 分类描述 APT_TempText
Property APTInfomation As %String [ SqlColumnNumber = 6, SqlFieldName = APT_Infomation ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCAPPPRT)</SqlIdExpression>
<SQLMap name="IndexArc">
<Global>^DHCAPPPRT</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>APT_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Arc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{APT_Cat_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{APT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="APT_Cat_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="APT_Infomation">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="APT_Sex">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="APT_TempText">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="APT_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCAPPPRT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>APT_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{APT_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAppPrtTempS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
