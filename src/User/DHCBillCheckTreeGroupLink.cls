Class User.DHCBillCheckTreeGroupLink Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DHCBCT_Rowid, SqlTableName = DHC_BillCheckTreeGroupLink, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DHCBCT_Group_Dr
Property DHCBCTGroupDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = DHCBCT_Group_Dr ];

/// DHCBCT_TreeNode_Dr
Property DHCBCTTreeNodeDr As User.DHCBillCheckTreeNode [ SqlColumnNumber = 3, SqlFieldName = DHCBCT_TreeNode_Dr ];

/// DHCBCT_UseRight
Property DHCBCTUseRight As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = DHCBCT_UseRight ];

/// DHCBCT_note1
Property DHCBCTnote1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DHCBCT_note1 ];

/// DHCBCT_note2
Property DHCBCTnote2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = DHCBCT_note2 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCBILLCHECKTREEGROUP)</SqlIdExpression>
<SQLMap name="indexgroupTree">
<Global>^DHCBILLCHECKTREEGROUP</Global>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>DHCBCT_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DHCBCT_Group_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"GroupTree"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCBCT_TreeNode_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"TreeGroup"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DHCBCT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexgroupdr">
<Global>^DHCBILLCHECKTREEGROUP</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCBCT_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DHCBCT_Group_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Group"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCBCT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indextree">
<Global>^DHCBILLCHECKTREEGROUP</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCBCT_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DHCBCT_TreeNode_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"TreeNode"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCBCT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="masterTreeGroup">
<Data name="DHCBCT_Group_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHCBCT_TreeNode_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHCBCT_UseRight">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DHCBCT_note1">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DHCBCT_note2">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCBILLCHECKTREEGROUP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHCBCT_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHCBCT_Rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCBillCheckTreeGroupLinkS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
