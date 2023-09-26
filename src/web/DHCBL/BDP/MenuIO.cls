/// 菜单导出、导入功能
Class web.DHCBL.BDP.MenuIO Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：zhaocz
/// CreatDate: 2012-10-18
/// Description：批量导出类，每个类生产一个文件
/// Table：
/// Input：
ClassMethod BatchOut(FileName As %String) As %String
{
	;d ##class(web.DHCBL.BDP.MenuIO).BatchOut("E:\MenuTest.XML")
	n (FileName)
	
	k myMnuAry
	q:(FileName="")
	d ..SetOutMenuAry(.myMnuAry)
	d ##class(web.BDP.manager.Menu).ExportListByName(.myMnuAry, FileName)
	q ""
}

/// Creator：zhaocz
/// CreatDate: 2012-10-18
/// Description：批量导出类，每个类生产一个文件
/// Table：
/// Input：
ClassMethod BatchIn(FileName As %String) As %String
{
	n (FileName)
	d ##class(web.BDP.manager.Menu).Import(FileName)
	q ""
}

/// Creator：zhaocz
/// CreatDate: 2012-10-18
/// Description：传入数组格式：  s ClassAry(classname)=""
/// Table：
/// Input：
ClassMethod SetOutMenuAry(ByRef MenuAry As %String) As %String
{
	n (MenuAry)
	;s MenuAry("")=""
	s MenuAry("System.MainMenu")=""
	s MenuAry("Main.Home")=""
	s MenuAry("Main.Close")=""
	
	q ""
}

}
