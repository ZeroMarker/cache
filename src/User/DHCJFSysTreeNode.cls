Class User.DHCJFSysTreeNode Extends %Library.Persistent [ ClassType = persistent, LegacyInstanceContext, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DHCST_Rowid, SqlTableName = DHC_JFSysTreeNode, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DHCST_Text
Property DHCSTText As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DHCST_Text ];

/// DHCST_Code
Property DHCSTCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DHCST_Code ];

/// DHCST_Href
Property DHCSTHref As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DHCST_Href ];

/// DHCST_Leaf
Property DHCSTLeaf As %Library.String(DISPLAYLIST = ",true,false", MAXLEN = 5, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",true,false") [ SqlColumnNumber = 5, SqlFieldName = DHCST_Leaf ];

/// DHCST_HrefTarget
Property DHCSTHrefTarget As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = DHCST_HrefTarget ];

/// DHCST_UserClass
Property DHCSTUserClass As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = DHCST_UserClass ];

/// DHCST_Note1
Property DHCSTNote1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = DHCST_Note1 ];

/// DHCST_Note2
Property DHCSTNote2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = DHCST_Note2 ];

/// DHCST_ParrentNode_Dr
Property DHCSTParrentNodeDr As User.DHCJFSysTreeNode [ SqlColumnNumber = 10, SqlFieldName = DHCST_ParrentNode_Dr ];

/// DHCST_NewHref
Property DHCSTNewHref As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = DHCST_NewHref ];

Method ToJson()
{
	s leaf="false"
	s href=i%DHCSTHref
	s rtnJson = "{"
	if (%this)  d
	.s:i%DHCSTLeaf="true" leaf="true"
	.s:($l($ZCVT(i%DHCSTHref,"U"),".CSP")=1)&&($l($zcvt(i%DHCSTHref,"U"),".HTML")=1)&&($l($zcvt(i%DHCSTHref,"U"),".HTM")=1) href=""
	.s rtnJson = rtnJson_"id:'"_i%DHCSTCode_"-"_ %this.%Id()_"',text:'"_i%DHCSTText_"',leaf:"_leaf_",href:'"_href_"',hrefTarget:'"_i%DHCSTHrefTarget_"',iconCls:'dotClass'"
	;s rtnJson="{"_"id:'bookMealMenuTree-2',text:'你好',leaf:true,href:'www.baidu.com'"
	q rtnJson_"}"
}

Method ToCheckJson()
{
	s leaf="false"
	s rtnJson = "{"
	if (%this)  d
	.s:i%DHCSTLeaf="true" leaf="true"
	.s rtnJson = rtnJson_"id:'"_i%DHCSTCode_"-"_ %this.%Id()_"',text:'"_i%DHCSTText_"',leaf:"_leaf_",checked:false"
	q rtnJson_"}"
}

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCJFSYSTREENODE)</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCJFSYSTREENODE</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCST_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DHCST_Code}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCST_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexParrentNodeDr">
<Global>^DHCJFSYSTREENODE</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCST_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DHCST_ParrentNode_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ParrentNode"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCST_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexText">
<Global>^DHCJFSYSTREENODE</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCST_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DHCST_Text}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Text"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCST_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="DHCST_Code">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHCST_Href">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DHCST_HrefTarget">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DHCST_Leaf">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DHCST_NewHref">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DHCST_Note1">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DHCST_Note2">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DHCST_ParrentNode_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DHCST_Text">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHCST_UserClass">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCJFSYSTREENODE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHCST_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHCST_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCJFSysTreeNodeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
