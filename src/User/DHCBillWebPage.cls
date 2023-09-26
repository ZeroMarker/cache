/// 名称: User.DHCBillWebPage.cls
/// 描述: 页面
/// 编写者: ZhYW
/// 编写日期: 2019-04-16
Class User.DHCBillWebPage Extends (%Library.Persistent, User.Abstract) [ SqlRowIdName = WP_RowID, SqlTableName = DHC_BillWebPage, StorageStrategy = SQLStorage ]
{

Relationship ChildDHCBillPageConf As User.DHCBillPageConf [ Cardinality = children, Inverse = PCWPParRef ];

/// WP_CSPName
Property WPCSPName As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ Required, SqlColumnNumber = 2, SqlFieldName = WP_CSPName ];

/// WP_PageName
Property WPPageName As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = WP_PageName ];

/// WP_ConfURL(配置界面URL)
Property WPConfURL As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = WP_ConfURL ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCBillWP)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="WP_CSPName">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="WP_ConfURL">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="WP_PageName">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCBillWP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>WP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{WP_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCSPName">
<Global>^DHCBillWP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CSPName"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WP_CSPName}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>WP_RowID</SqlRowIdName>
<StreamLocation>^User.DHCBillWebPageS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
