/// 页面
Class User.DHCDocOrderPage Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DOP_RowId, SqlTableName = DHC_DocOrderPage, StorageStrategy = SQLStorage ]
{

Relationship ChildDHCDocOrderGrid As User.DHCDocOrderGrid [ Cardinality = children, Inverse = DOGDOPParRef ];

Relationship ChildDHCDocOrderMessage As User.DHCDocOrderMessage [ Cardinality = children, Inverse = DOMDOPParRef ];

Relationship ChildDHCDocShortCutKey As User.DHCDocShortCutKey [ Cardinality = children, Inverse = DSKDOPParRef ];

Relationship ChildDHCDocPageDom As User.DHCDocPageDom [ Cardinality = children, Inverse = PDParRef ];

/// 代码
Property DOPCode As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DOP_Code ];

/// 描述
Property DOPDesc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DOP_Desc ];

/// 产品线
Property DOPProductLine As %String [ SqlColumnNumber = 4, SqlFieldName = DOP_ProductLine ];

/// 主页面cspCode
Property DOPMainCSPCode As %String [ SqlColumnNumber = 5, SqlFieldName = DOP_MainCSPCode ];

/// 主页面cspname
Property DOPMainCSPDesc As %String [ SqlColumnNumber = 6, SqlFieldName = DOP_MainCSPDesc ];

/// 主页面是否为链接页面
Property DOPMainCSPIsLink As %String(COLLATION = "EXACT", DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = DOP_MainCSPIsLink ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCDocOP)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="DOP_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DOP_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DOP_MainCSPCode">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DOP_MainCSPDesc">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DOP_MainCSPIsLink">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DOP_ProductLine">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCDocOP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>OP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DOP_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCDocOPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>OP_Code</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>OP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{DOP_Code}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DOP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCDocOPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>OP_Desc</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{l4}</Expression>
<Field>OP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DOP_Desc}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DOP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCDocOrderPageS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
