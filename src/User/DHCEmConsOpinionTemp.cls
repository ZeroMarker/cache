Class User.DHCEmConsOpinionTemp Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = COT_RowID, SqlTableName = DHC_EmConsOpinionTemp, StorageStrategy = SQLStorage ]
{

/// 会诊意见
Property COTText As %Library.String(COLLATION = "Exact", MAXLEN = 5000, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = COT_Text ];

/// 科室
Property COTLocDr As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = COT_Loc_Dr ];

/// 人员
Property COTUserDr As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = COT_User_Dr ];

/// 模板内容标志 ['r' 代表会诊理由 'o' 代表会诊意见]
Property COTTextFlag As %Library.String [ SqlColumnNumber = 5, SqlFieldName = COT_TextFlag ];

/// 会诊意见模板标题 guozizhu 2020-01-25
Property COTTitle As %Library.String [ SqlColumnNumber = 6, SqlFieldName = COT_Title ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEMCOT)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="COT_Loc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="COT_Text">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="COT_TextFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="COT_Title">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="COT_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCEMCOT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>COT_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{COT_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLoc">
<Global>^DHCEMCOT</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>COT_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Loc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{COT_Loc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{COT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUser">
<Global>^DHCEMCOT</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"USER"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{COT_User_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{COT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEmConsOpinionTempS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
