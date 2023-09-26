Class User.DHCTreeNode Extends %Library.Persistent [ ClassType = persistent, LegacyInstanceContext, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = TN_Rowid, SqlTableName = DHC_TreeNode, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// TN_Text
Property TNText As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = TN_Text ];

/// TN_Code
Property TNCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = TN_Code ];

/// TN_Href
Property TNHref As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = TN_Href ];

/// TN_Leaf
Property TNLeaf As %Library.String(DISPLAYLIST = ",true,false", MAXLEN = 5, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",true,false") [ SqlColumnNumber = 5, SqlFieldName = TN_Leaf ];

/// TN_HrefTarget
Property TNHrefTarget As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = TN_HrefTarget ];

/// TN_UserClass
Property TNUserClass As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = TN_UserClass ];

/// TN_Note1
Property TNNote1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = TN_Note1 ];

/// TN_Note2
Property TNNote2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = TN_Note2 ];

/// TN_ParrentNode_Dr
Property TNParrentNodeDr As User.DHCTreeNode [ SqlColumnNumber = 10, SqlFieldName = TN_ParrentNode_Dr ];

Method ToJson()
{
	s leaf="false"
	s href=i%TNHref
	s rtnJson = "{"
	if (%this)  d
	.s:i%TNLeaf="true" leaf="true"
	.s:($l($ZCVT(i%TNHref,"U"),".CSP")=1)&&($l($zcvt(i%TNHref,"U"),".HTML")=1)&&($l($zcvt(i%TNHref,"U"),".HTM")=1) href=""
	.s rtnJson = rtnJson_"id:'"_i%TNCode_"-"_ %this.%Id()_"',text:'"_i%TNText_"',leaf:"_leaf_",href:'"_href_"',hrefTarget:'"_i%TNHrefTarget_"',iconCls:'dotClass'"
	;s rtnJson="{"_"id:'bookMealMenuTree-2',text:'你好',leaf:true,href:'www.baidu.com'"
	q rtnJson_"}"
}

Method ToCheckJson()
{
	s leaf="false"
	s rtnJson = "{"
	if (%this)  d
	.s:i%TNLeaf="true" leaf="true"
	.s rtnJson = rtnJson_"id:'"_i%TNCode_"-"_ %this.%Id()_"',text:'"_i%TNText_"',leaf:"_leaf_",checked:false"
	q rtnJson_"}"
}

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCTREENODE)</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCTREENODE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TN_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{TN_Code}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TN_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexParrentNodeDr">
<Global>^DHCTREENODE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TN_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{TN_ParrentNode_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ParrentNode"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TN_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexText">
<Global>^DHCTREENODE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TN_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{TN_Text}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Text"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TN_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="TN_Code">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TN_Href">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="TN_HrefTarget">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="TN_Leaf">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="TN_Note1">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="TN_Note2">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="TN_ParrentNode_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="TN_Text">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TN_UserClass">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCTREENODE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>TN_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{TN_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCTreeNodeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
