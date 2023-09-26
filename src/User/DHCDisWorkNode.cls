Class User.DHCDisWorkNode Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = WN_RowID, SqlTableName = DHC_DisWorkNode, StorageStrategy = SQLStorage ]
{

Relationship ChildDHCDISWORKNODEITM As User.DHCDisWorkNodeItm [ Cardinality = children, Inverse = WNParRef ];

/// 代码  WN_NodeCode
Property WNNodeCode As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = WN_NodeCode ];

/// 描述  WN_NodeName
Property WNNodeName As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = WN_NodeName ];

/// 描述  WN_NodePerNum
Property WNNodePerNum As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = WN_NodePerNum ];

/// 岗位类型  WN_NodeType
Property WNNodeType As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = WN_NodeType ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCDISWN)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="WN_NodeCode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="WN_NodeName">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="WN_NodePerNum">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="WN_NodeType">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCDISWN</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>WN_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{WN_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCDISWN</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WN_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({WN_NodeCode})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WN_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexName">
<Global>^DHCDISWN</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WN_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Name"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({WN_NodeName})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WN_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCDisWorkNodeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
