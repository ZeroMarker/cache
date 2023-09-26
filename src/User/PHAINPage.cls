/// 页面维护
Class User.PHAINPage Extends (%Persistent, User.Abstract) [ SqlTableName = PHAIN_Page, StorageStrategy = CacheSQLStorage ]
{

Relationship ChildPHAINPageItm As User.PHAINPageItm [ Cardinality = children, Inverse = PageItmParref ];

/// 页面名称
Property PageDesc As %String(MAXLEN = 150) [ Required, SqlColumnNumber = 2, SqlFieldName = Page_Desc ];

/// 链接全称,含后缀 
Property PageLink As %String(MAXLEN = 150) [ Required, SqlColumnNumber = 3, SqlFieldName = Page_Link ];

/// 产品线指向
Property PageProDR As User.DHCStkSysPro [ SqlColumnNumber = 4, SqlFieldName = Page_Pro_DR ];

Storage CacheSQLStorage
{
<SqlIdExpression>$i(^CF.PHA.IN.Page)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="Page_Desc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="Page_Link">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="Page_Pro_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^CF.PHA.IN.Page</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>Page_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{Page_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPageLink">
<Global>^CF.PHA.IN.Pagei</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>Page_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PageLink"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{Page_Link}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Page_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPageProDR">
<Global>^CF.PHA.IN.Pagei</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>Page_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PageProDR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{Page_Pro_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Page_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>Page_RowId</SqlRowIdName>
<StreamLocation>^User.PHAINPageS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
