/// 名称: 		web.Util.Menu
/// 描述: 		导入导出iMedical的菜单(websys.Menu)
/// 编写者：	周志强
/// 编写日期:	2013-02-21
/// 
/// 导出菜单方法：将以MenuNameAlias开头的菜单导出到指定文件夹，菜单列表存在menus.txt中
/// w ##class(web.Util.Menu).DownLoadMenus("MenuNameAlias","d:\tmp\")
/// 导出菜单方法：将指定安全组的菜单导出到指定文件夹，菜单列表存在menus.txt中
/// w ##class(web.Util.Menu).DownLoadMenusByGroup(1,"d:\tmp\")
/// 
/// 导入菜单方法：导入指定路径下menus.txt文件中的菜单
/// w ##class(web.Util.Menu).UpLoadMenus("d:\tmp\",0)        //不覆盖已有的同名菜单
/// w ##class(web.Util.Menu).UpLoadMenus("d:\menus\",1)        //覆盖已有同名菜单
/// 
Class web.Util.Menu Extends (%RegisteredObject, %XML.Adaptor) [ LegacyInstanceContext, Not ProcedureBlock ]
{

Property Caption As %String(TRUNCATE = 1);

Property Chart As epr.Chart;

Property ChartBook As epr.ChartBook;

Property ConditionalExpression As %Library.String(MAXLEN = "", TRUNCATE = 1);

Property Image As %String(MAXLEN = "", TRUNCATE = 1);

/// filename of where the JavascriptFunction resides. 
/// Should only be set for custom site menus, expects file to sit in relation to custom/SITECODE/scripts folder
Property JavascriptFileName As %String(TRUNCATE = 1);

Property JavascriptFunction As %Library.String(TRUNCATE = 1);

/// Used in conjunction with LinkUrl of websysDefault.asp.
/// If this property is set then LinkLinkUrl is assumes to be websysDefault.ASP
Property LinkComponent As websys.Component;

Property LinkReport As websys.Report;

Property LinkUrl As %String(MAXLEN = "", TRUNCATE = 1);

Property Method As %String(MAXLEN = "", TRUNCATE = 1);

Property Name As %String(MAXLEN = 99, TRUNCATE = 1);

Property PrintPreview As %Library.Boolean;

Property PrintLocal As %Library.Boolean;

Property Sequence As %String(TRUNCATE = 1);

Property ShortcutKey As %String(TRUNCATE = 1);

Property ShowInNewWindow As %Library.String(MAXLEN = "", TRUNCATE = 1);

Property SubMenuOf As websys.Menu;

/// name of browser window frame to send the link
Property Target As %Library.String(TRUNCATE = 1);

/// a value of either: SideMenu, ComponentMenu, HeaderMenu
/// this will be automatically calculated on update
Property Type As %Library.String(TRUNCATE = 1);

Property UpdateDate As %Library.Date;

Property UpdateTime As %Library.Time;

Property UpdateUser As User.SSUser;

Property ValueExpression As %String(MAXLEN = "", TRUNCATE = 1);

/// Name of workflow
Property WorkFlow As websys.WorkFlow;

Property Worklist As epr.Worklist;

Property ChartName As %String;

/// As epr.Chart;
Property ChartBookName As %String;

/// As epr.ChartBook;
Property LinkComponentName As %String;

/// As websys.Component;
Property LinkReportName As %String;

/// As websys.Report;
Property SubMenuOfName As %String;

/// As websys.Menu;
Property UpdateUserName As %String;

/// As User.SSUser;
Property WorkFlowName As %String;

/// As websys.WorkFlow;
Property WorklistName As %String;

Property HelpCode As %String;

/// 帮助提示层位置
Property HelpStyle As %String [ InitialExpression = "bottom:10px;right:10px;" ];

Property MenuGroup As websys.MenuGroup;

/// 界面显示菜单组
Property MenuGroupName As %String;

/// 是否局部刷新
Property IsXhrRefresh As %String;

/// 名称: 		web.Util.Menu
/// 描述: 		按照安全组导出相关的菜单信息到数组中
/// 编写者：	汪会财
/// 编写日期:	2013-01-14
/// @param GroupId
/// @param SS_language->Rowid
/// @param 侧菜单 arytxt
/// @param 组件菜单 aryvalCmp
/// @param 头菜单 aryvalHdr
/// @date 2013-01-14
ClassMethod ToListByGroup(groupid As %String, SessionLangId As %String, ByRef sort)
{
}

ClassMethod AllMenuToListByGroup(groupid, SessionLangId, ByRef ary)
{
}

/// 导出安全组所拥有的菜单到指定目录下
/// @param groupid 安全组id SS_Group->SSGRP_RowId
/// @param fileDir 导出文件的目录
ClassMethod ExportByGroup(groupid, fileDir As %String) As %Status
{
}

/// @param fileDir 导出文件的目录
/// 所有group导成一个txt
ClassMethod TotalExportGroup(fileDir As %String)
{
}

/// Creator：     wuqk
/// CreatDate：   2012-09-26
/// Description:  将iMedical系统菜单导出为xml文件
/// Table：       websys.Menu
/// Input：       nameprefix : 菜单名称的开头字母
///               path       ：导出文件的路径
/// Return：      
/// w ##class(web.Util.Menu).DownLoadMenus("DHCWMR","d:\tmp\")
ClassMethod DownLoadMenus(nameprefix As %String, path As %String)
{
}

/// 描述: 导出安全组所拥有的菜单xml文件到指定目录下
/// @param GroupId 安全组id SS_Group->SSGRP_RowId
/// @param Path 导出文件的目录
/// w ##class(web.Util.Menu).DownLoadMenusByGroup(1,"d:\tmp\")
ClassMethod DownLoadMenusByGroup(GroupId As %String, Path As %String) As %Boolean
{
}

ClassMethod ExportMenuToXML(MenuId, Path As %String)
{
}

/// Creator：     wuqk
/// CreatDate：   2012-09-26
/// Description:  从xml文件夹中导入iMedical系统菜单
/// Table：       websys.Menu
/// Input：       
///         path       ：导入文件的路径
///         overload   ：是否覆盖同名菜单，1：覆盖，0：不覆盖
/// Return：      
/// w ##class(web.Util.Menu).UpLoadMenus("d:\tmp\",0)
ClassMethod UpLoadMenus(path As %String, overload As %Integer)
{
}

/// w ##class(web.Util.Menu).LoadMenusFromXML("d:\temp\","DHC.CARDCPP.POS",1)
ClassMethod LoadMenusFromXML(path As %String, menuname As %String, overload As %Integer)
{
}

Method CopyTo(ByRef po As websys.Menu)
{
}

Method CopyFrom(ByRef po As websys.Menu)
{
}

Method Export(ByRef file As %File = "") As %String
{
}

ClassMethod MenuJson(menuid)
{
}

/// @author: wanghc 
/// @date : 20140415
/// @param: menuid  websys.Menu表的Id 
/// @param: groupid SS_group表的Id
/// @desc: 把rowid为menuid的菜单转成easyui的html并输出
ClassMethod Easyui(MenuId, GroupId)
{
}

/// d ##class(%ResultSet).RunQuery("web.Util.Menu","SelectSubMenu",1)
/// @param: MenuId 	websys.Menu表的Id 
/// @param: GroupId SS_group表的Id
/// @param: Authorize 1 显示已授权的, 0显示未授权与已授权. 默认为1
Query SelectSubMenu(MenuId, GroupId = "", Authorize = 1) As websys.Query(ROWSPEC = "SubMenuId:%String")
{
}

ClassMethod SelectSubMenuExecute(ByRef qHandle As %Binary, MenuId, GroupId = "", Authorize = 1) As %Status
{
}

/// d ##class(%ResultSet).RunQuery("web.Util.Menu","SelectGroupMenu","",1)
/// @param: MenuId 	websys.Menu表的Id 
/// @param: GroupId SS_group表的Id
/// @param: Authorize 1 显示已授权的, 0显示未授权与已授权. 默认为1
Query SelectGroupMenu(GroupId = "") As websys.Query(ROWSPEC = "SubMenuId:%String:序号,MenuCaption:%String:菜单名")
{
}

ClassMethod SelectGroupMenuExecute(ByRef qHandle As %Binary, GroupId = "") As %Status
{
}

}
