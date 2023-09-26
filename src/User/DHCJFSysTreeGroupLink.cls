Class User.DHCJFSysTreeGroupLink Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DHCJFTGL_Rowid, SqlTableName = DHC_JFSysTreeGroupLink, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DHCJFTGL_Group_Dr
Property DHCJFTGLGroupDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = DHCJFTGL_Group_Dr ];

/// DHCJFTGL_TreeNode_Dr
Property DHCJFTGLTreeNodeDr As User.DHCJFSysTreeNode [ SqlColumnNumber = 3, SqlFieldName = DHCJFTGL_TreeNode_Dr ];

/// DHCJFTGL_UseRight
Property DHCJFTGLUseRight As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = DHCJFTGL_UseRight ];

/// DHCJFTGL_note1
Property DHCJFTGLnote1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DHCJFTGL_note1 ];

/// DHCJFTGL_note2
Property DHCJFTGLnote2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = DHCJFTGL_note2 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCJFSYSTREEGROUP)</SqlIdExpression>
<SQLMap name="indexgroupTree">
<Global>^DHCJFSYSTREEGROUP</Global>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>DHCJFTGL_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DHCJFTGL_Group_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"GroupTree"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCJFTGL_TreeNode_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"TreeGroup"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DHCJFTGL_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexgroupdr">
<Global>^DHCJFSYSTREEGROUP</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCJFTGL_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DHCJFTGL_Group_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Group"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCJFTGL_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indextree">
<Global>^DHCJFSYSTREEGROUP</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCJFTGL_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DHCJFTGL_TreeNode_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"TreeNode"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCJFTGL_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="masterTreeGroup">
<Data name="DHCJFTGL_Group_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHCJFTGL_TreeNode_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHCJFTGL_UseRight">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DHCJFTGL_note1">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DHCJFTGL_note2">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCJFSYSTREEGROUP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHCJFTGL_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHCJFTGL_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCJFSysTreeGroupLinkS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
