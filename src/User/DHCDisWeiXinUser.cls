Class User.DHCDisWeiXinUser Extends (%Persistent, %XML.Adaptor) [ SqlTableName = DHC_DisWeiXinUser, StorageStrategy = NewStorage1 ]
{

Property HisUserId As %String [ SqlColumnNumber = 2, SqlFieldName = His_UserId ];

Property WeiXinUserId As %String [ SqlColumnNumber = 3, SqlFieldName = WeiXin_UserId ];

Property HisLoc As %String [ SqlColumnNumber = 4, SqlFieldName = His_Loc ];

Property HisGroup As %String [ SqlColumnNumber = 5, SqlFieldName = His_Group ];

Storage NewStorage1
{
<SqlIdExpression>$i(^DHCDISWEIXINUSER)</SqlIdExpression>
<SQLMap name="IndexUser">
<Global>^DHCDISWEIXINUSER</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"UserId"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{His_UserId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{His_Group}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WXU_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexWeiXIn">
<Global>^DHCDISWEIXINUSER</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"WeiXin"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WeiXin_UserId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WXU_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MapData">
<Data name="His_Group">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="His_Loc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="His_UserId">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="WeiXin_UserId">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCDISWEIXINUSER</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>WXU_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{WXU_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>WXU_RowId</SqlRowIdName>
<StreamLocation>^User.DHCDisWeiXinUserS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
