Class User.DHCBillCheckTreeNode Extends %Library.Persistent [ ClassType = persistent, LegacyInstanceContext, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DHCBT_Rowid, SqlTableName = DHC_BillCheckTreeNode, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DHCBT_Text
Property DHCBTText As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DHCBT_Text ];

/// DHCBT_Code
Property DHCBTCode As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DHCBT_Code ];

/// DHCBT_Href
Property DHCBTHref As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DHCBT_Href ];

/// DHCBT_Leaf
Property DHCBTLeaf As %Library.String(DISPLAYLIST = ",true,false", MAXLEN = 5, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",true,false") [ SqlColumnNumber = 5, SqlFieldName = DHCBT_Leaf ];

/// DHCBT_HrefTarget
Property DHCBTHrefTarget As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = DHCBT_HrefTarget ];

/// DHCBT_UserClass
Property DHCBTUserClass As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = DHCBT_UserClass ];

/// DHCBT_Note1
Property DHCBTNote1 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = DHCBT_Note1 ];

/// DHCBT_Note2
Property DHCBTNote2 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = DHCBT_Note2 ];

/// DHCBT_ParrentNode_Dr
Property DHCBTParrentNodeDr As User.DHCBillCheckTreeNode [ SqlColumnNumber = 10, SqlFieldName = DHCBT_ParrentNode_Dr ];

/// DHCBT_NewHref
Property DHCBTNewHref As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = DHCBT_NewHref ];

/// DHCBT_ClassName
Property DHCBTClassName As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = DHCBT_ClassName ];

/// DHCBT_MethodName
Property DHCBTMethodName As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = DHCBT_MethodName ];

/// DHCBT_Param
Property DHCBTParam As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = DHCBT_Param ];

/// DHCBT_ParamNum
Property DHCBTParamNum As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = DHCBT_ParamNum ];

Method ToJson()
{
	s leaf="false"
	s href=i%DHCBTHref
	s rtnJson = "{"
	if (%this)  d
	.s:i%DHCBTLeaf="true" leaf="true"
	.s:($l($ZCVT(i%DHCBTHref,"U"),".CSP")=1)&&($l($zcvt(i%DHCBTHref,"U"),".HTML")=1)&&($l($zcvt(i%DHCBTHref,"U"),".HTM")=1) href=""
	.s rtnJson = rtnJson_"id:'"_i%DHCBTCode_"-"_ %this.%Id()_"',text:'"_i%DHCBTText_"',leaf:"_leaf_",href:'"_href_"',hrefTarget:'"_i%DHCBTHrefTarget_"',iconCls:'dotClass'"
	;s rtnJson="{"_"id:'bookMealMenuTree-2',text:'你好',leaf:true,href:'www.baidu.com'"
	q rtnJson_"}"
}

Method ToCheckJson()
{
	s leaf="false"
	s rtnJson = "{"
	if (%this)  d
	.s:i%DHCBTLeaf="true" leaf="true"
	.s rtnJson = rtnJson_"id:'"_i%DHCBTCode_"-"_ %this.%Id()_"',text:'"_i%DHCBTText_"',leaf:"_leaf_",checked:false"
	q rtnJson_"}"
}

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCBILLCHECKTREENODE)</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCBILLCHECKTREENODE</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCBT_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DHCBT_Code}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCBT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexParrentNodeDr">
<Global>^DHCBILLCHECKTREENODE</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCBT_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DHCBT_ParrentNode_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ParrentNode"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCBT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexText">
<Global>^DHCBILLCHECKTREENODE</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCBT_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DHCBT_Text}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Text"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCBT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="DHCBT_ClassName">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DHCBT_Code">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHCBT_Href">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DHCBT_HrefTarget">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DHCBT_Leaf">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DHCBT_MethodName">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DHCBT_NewHref">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DHCBT_Note1">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DHCBT_Note2">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DHCBT_Param">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DHCBT_ParamNum">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DHCBT_ParrentNode_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DHCBT_Text">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHCBT_UserClass">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCBILLCHECKTREENODE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHCBT_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHCBT_Rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCBillCheckTreeNodeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
