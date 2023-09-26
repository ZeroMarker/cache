Class web.DHCCKBHosMain Extends %RegisteredObject
{

/// Description：获取菜单树
/// Table：
/// Input：
/// Ohter: w ##class(web.DHCCKBHosMain).GetHtmlMenu()
ClassMethod GetHtmlMenu() As %String
{
	w "<ul id=""navmenu"" class=""nav nav-list"">",!

	k TmpArr
	d ..GetMenuList(.TmpArr)
	
	s index = ""
	f  s index = $o(TmpArr(index))  q:index=""  d
	.s dataList = $g(TmpArr(index))
	.s myCaptionID = $p(dataList,"^",1)
	.s myCaption = $p(dataList,"^",2)
	.s myLinkUrl = $p(dataList,"^",3)
	.s menuIcon="desktop"
	.s:myCaption["药品目录" menuIcon="gears"
	.s:myCaption["结构化知识" menuIcon="book"
	.s:myCaption["药品规则管理" menuIcon="warning"
	.s:myCaption["审查能力管理" menuIcon="wrench"
	.s:myCaption["接入授权管理" menuIcon="puzzle-piece"	
	.s:myCaption["药品知识检索" menuIcon="search-plus"
	.s:myCaption["监测中心" menuIcon="play-circle"
	.s:myCaption["药品知识" menuIcon="play-circle"

	
	.w "<li class="""">",! 
	.//w "    <a RowID='"_mySMRowID2_"' id='"_mySMRowID2_"'  href=""#""  onclick=""showNavTab("_mySMRowID2_",'"_myCaption2_"','"_myLinkUrl2_"','"_ParentMenuDr2_"','"_myImage2_"')"">",!
  	.if myCaption="药品知识检索HOS" w "    <a RowID='"_myCaptionID_"' id='"_myCaptionID_"' onclick=""openHosIndex('"_myLinkUrl_"')"" href=""#"" class=""dropdown-toggle"">",!
	.else  w "    <a RowID='"_myCaptionID_"' id='"_myCaptionID_"' onclick=""showNavTab("_myCaptionID_",'"_myCaption_"','"_myLinkUrl_"','')"" href=""#"" class=""dropdown-toggle"">",!
	.w "        <i class=""menu-icon fa fa-"_menuIcon_"""></i>",!
	.w "        <span class=""menu-text"">"_myCaption_"</span>",!
	.w "        <b class=""arrow fa fa-angle-down""></b>",!
	.w "    </a>",!
	.w "    <b class=""arrow""></b>",!
	.//d ..GetHtmlLevel(mySMRowID,SessionStr,desc)
	.w "</li>",!
	 
	w "</ul>",!
	
	q ""
}

/// Description：获取菜单树
/// Table：
/// Input：
/// Ohter: w ##class(web.DHCCKBHosMain).GetHtmlMenu()
ClassMethod GetMenuList(TmpArr) As %String
{
	s TmpArr(1) = "1^药品目录^dhcckb.dictionary.csp"
	s TmpArr(2) = "2^结构化知识^dhcckb.editprop.csp"
	s TmpArr(3) = "3^药品规则管理^dhcckb.rule.index0.csp"
	s TmpArr(4) = "4^审查能力管理^dhcckb.rule.priority.csp"
	s TmpArr(5) = "5^接入授权管理^dhcckb.grantauth.csp"
	s TmpArr(6) = "6^药品知识检索^dhcckb.index.csp"
	s TmpArr(7) = "7^监测中心^dhcckb.intrevmonitor.csp"

	q ""
}

/// Description：获取菜单树
/// Table：
/// Input：
/// Ohter: w ##class(web.DHCCKBHosMain).GetMenu("")
ClassMethod GetMenu(desc) As %String
{

	k TmpArr
	d ..GetMenuList(.TmpArr)
	
	s menuArr = ##class(DHCNewPro.COM.Array).%New()
	s index = ""
	f  s index = $o(TmpArr(index))  q:index=""  d
	.s dataList = $g(TmpArr(index))
	.s myCaptionID = $p(dataList,"^",1)
	.s myCaption = $p(dataList,"^",2)
	.s myLinkUrl = $p(dataList,"^",3)
	.q:(desc'="")&&(myCaption'[desc)
	.s dataObj = ##class(DHCNewPro.COM.Object).%New()
	.s dataObj.id = myCaptionID
	.s dataObj.text = myCaption
	.s dataObj.url = myLinkUrl
	.d menuArr.Push(dataObj)

	
	q menuArr.ToJSON()
}

}
