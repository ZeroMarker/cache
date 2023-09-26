Class User.DHCTreeGroupLink Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = TGL_Rowid, SqlTableName = DHC_TreeGroupLink, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// TGL_Group_Dr
Property TGLGroupDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = TGL_Group_Dr ];

/// TGL_TreeNode_Dr
Property TGLTreeNodeDr As User.DHCTreeNode [ SqlColumnNumber = 3, SqlFieldName = TGL_TreeNode_Dr ];

/// TGL_UseRight
Property TGLUseRight As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = TGL_UseRight ];

/// TGL_note1
Property TGLnote1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = TGL_note1 ];

/// TGL_note2
Property TGLnote2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = TGL_note2 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCTREEGROUP)</SqlIdExpression>
<SQLMap name="indexgroupTree">
<Global>^DHCTREEGROUP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>TGL_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>{TGL_Group_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"GroupTree"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TGL_TreeNode_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"TreeGroup"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{TGL_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexgroupdr">
<Global>^DHCTREEGROUP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TGL_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>{TGL_Group_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Group"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TGL_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indextree">
<Global>^DHCTREEGROUP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TGL_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>{TGL_TreeNode_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"TreeNode"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TGL_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="masterTreeGroup">
<Data name="TGL_Group_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TGL_TreeNode_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TGL_UseRight">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="TGL_note1">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="TGL_note2">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCTREEGROUP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>TGL_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{TGL_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCTreeGroupLinkS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
