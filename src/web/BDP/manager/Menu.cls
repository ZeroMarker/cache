/// 菜单管理功能
/// 名称: DtHealth 菜单管理功能
/// 描述: 为了使用方便：编写导出、导入功能，其他的增删改查等功能不提供，
/// 编写者：  zhaocz
/// 编写日期: 2012-10-16
Class web.BDP.manager.Menu Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// 
/// 
/// Creator：zhaocz
/// CreatDate: 2012-10-16
/// Description：导出菜单列表功能
/// 		按照列表
/// Table：websys.Menu
/// Input：RowIDList 菜单RowID列表, 例子：  1^2^100^
/// 			FileName 输出的文件名称,  例子 BDPCodeTable.xml
ClassMethod ExportList(RowIDList As %String, FileName As %String) As %String
{
	;w ##class(web.BDP.manager.Menu).ExportList("1^2^3^4^5^6^7^8^9^10","C:\menulist.xml")
	n (RowIDList, FileName)
	q:(RowIDList="") -100_"^没有选择菜单错误！"
	q:(FileName="") -101_"^没有导出的文件名称错误!"
	
	k ^TMPBDP.TempExport
	s myRowID=""
	s myRowLen = $l(RowIDList,"^")
	s myIdx=1
	for myIdx=1:1:myRowLen {
		s myRowID = $p(RowIDList,"^", myIdx)
		
		q:(myRowID="")
		
		s menuobj = ##class(websys.Menu).%OpenId(myRowID)
		;b	;
		s myMnuPath=""
		if ($IsObject(menuobj)){
			
			s munparobj = menuobj.SubMenuOf
			for {
				q:('$IsObject(munparobj))
				
				s:(myMnuPath'="") myMnuPath = $c(1)_"/"_myMnuPath
				s myMnuPath = munparobj.Name_myMnuPath
				s munparobj = munparobj.SubMenuOf
				
			}
			
			if (myMnuPath["/"){
				;w "菜单路径Menu Path==  "_myMnuPath,!
				;b	;;path
			}
			s ^TMPBDP.TempExport(myRowID)=$lb(menuobj.Caption, menuobj.Image, menuobj.Method, menuobj.Name,	menuobj.Sequence, menuobj.ShortcutKey,
				menuobj.ShowInNewWindow, menuobj.Type, menuobj.LinkUrl, menuobj.ValueExpression, "", 
				$s($IsObject(menuobj.SubMenuOf):$lb(menuobj.SubMenuOf.Name,myMnuPath),1:$lb("")), 
				"",	"", 
				$s($IsObject(menuobj.LinkComponent):$lb(menuobj.LinkComponent.Name), 1:$lb("")), 
				$lb(menuobj.WorkFlow), menuobj.JavascriptFunction,  
				$lb(menuobj.LinkReport), 
				menuobj.ConditionalExpression, menuobj.Target, 
				$lb(menuobj.Chart), 
				$lb(menuobj.ChartBook), 
				menuobj.PrintPreview, menuobj.UpdateDate, menuobj.UpdateTime, menuobj.UpdateUser, "",
				$lb(menuobj.Worklist), 	
				menuobj.JavascriptFileName, menuobj.PrintLocal)
			
			s myInfo = "Last UpdateDate = "_$zd(menuobj.UpdateDate,3)_"   "
			s myInfo = myInfo_"UpdateTime = "_$zt(menuobj.UpdateTime)_"   "
			s myInfo = myInfo_"UpdateUser = "_menuobj.UpdateUser
			s ^TMPBDP.TempExport(myRowID,"UpdateInfo")=myInfo
			;%%CLASSNAME,
			;<Value name="27">
			;<Value>;%%CLASSNAME,</Value>
			;</Value>
		}
		
		k menuobj
		
	}
	;b	;;
	;导出Global，,"GBL"
	d $SYSTEM.OBJ.Export("TMPBDP.TempExport.GBL",FileName)
	;b	;;
	;删除Global，
	k ^TMPBDP.TempExport
	
	q $$$OK
}

/// 菜单导出测试
ClassMethod ExportTest()
{
	;d ##class(web.BDP.manager.Menu).ExportTest()
	n (a)
	s mylist=""
	s myRowID=""
	for {
		s myRowID = $o(^websys.MenuD(myRowID))
		q:(myRowID="")
		s:(mylist'="") mylist=mylist_"^"
		s mylist = mylist_myRowID
		
	}
	b	;;mylist
	d ##class(web.BDP.manager.Menu).ExportList(mylist, "C:\menulist.xml")
}

ClassMethod ExportListByName(ByRef NameArray As %String, FileName As %String) As %String
{
	n (NameArray, FileName)
	s myMenuName = ""
	s myMnuRowIDList = ""
	for {
		s myMenuName = $o(NameArray(myMenuName))
		q:(myMenuName="")
		
		s myCurMenuRowID = $o(^websys.MenuI("UniqueNameIndex",$zu(28,myMenuName,7,32768),0))
		
		s:(myMnuRowIDList'="") myMnuRowIDList = myMnuRowIDList_"^"
		s myMnuRowIDList = myMnuRowIDList_myCurMenuRowID
	}
	
	d ..ExportList(myMnuRowIDList, FileName)
	
	q ""
}

/// 
/// Creator：zhaocz
/// CreatDate: 2012-10-17
/// Description：导入菜单列表功能
/// 		按照列表
/// Table：websys.Menu
/// Input：RowIDList 菜单RowID列表, 例子：  1^2^100^
/// 			FileName 输出的文件名称,  例子 BDPCodeTable.xml
ClassMethod Import(FileName As %String) As %String
{
	;d ##class(web.BDP.manager.Menu).Import("C:\menulist.xml")
	n (FileName)
	
	k ^TMPBDP.TempExport
	
	d $SYSTEM.OBJ.Load(FileName)
	s myRowID = ""
	for {
		s myRowID = $o(^TMPBDP.TempExport(myRowID))
		q:(myRowID="")
		;b	;load
		s myMnuInfo = $g(^TMPBDP.TempExport(myRowID))
		
		s myCaption = $lg(myMnuInfo,1)
		s myImage = $lg(myMnuInfo,2)
		s myMethod = $lg(myMnuInfo,3)
		s myName = $lg(myMnuInfo,4)
		s mySequence = $lg(myMnuInfo,5)
		s myShortcutKey = $lg(myMnuInfo,6)
		s myShowInNewWindow = $lg(myMnuInfo,7)
		s myType  = $lg(myMnuInfo,8)
		s myLinkUrl = $lg(myMnuInfo,9)
		s myValueExpression = $lg(myMnuInfo,10)
		;b	;;
		;"",  11
		;$s($IsObject(menuobj.SubMenuOf):$lb(menuobj.SubMenuOf.Name,myMnuPath),1:$lb("")), 12
		;如果没有找到路径，需要建立路径自动建立
		s mySubMenuOf = ""
		s myMnuPathInfo = $lg(myMnuInfo,12)
		if ($lg(myMnuPathInfo,1)'=""){
			s myMnuPath = $lg(myMnuPathInfo, 2)
			;获取路径的对象 SubMenuOf
			
			s mySubMenuOf = ..GetParentMenu($lg(myMnuPathInfo, 1),myMnuPath)
			;b	;;MenuStr
		}
		;"",	13
		;"", 	14
		;$s($IsObject(menuobj.LinkComponent):$lb(menuobj.LinkComponent.Name), 1:$lb("")), 15
		s myCmpObj = ""
		s myLinkCompInfo = $lg(myMnuInfo,15)
		if ($lg(myLinkCompInfo,1)'=""){
			s myCompName = $lg(myLinkCompInfo,1)
			s myCompName = $zu(28,myCompName,6)
			
			s myCompRowID = $o(^websys.ComponentI("UniqueNameIndex", myCompName, 0))
			
			if (+myCompRowID>0){
				s myCmpObj = ##class(websys.Component).%OpenId(myCompRowID)
			}
		}
		;$lb(menuobj.WorkFlow), 16
		;menuobj.JavascriptFunction,  17
		s myJavascriptFunction = $lg(myMnuInfo,17)
		;	$lb(menuobj.LinkReport), 18
		
		;	menuobj.ConditionalExpression, 19
		s myConditionalExpression = $lg(myMnuInfo, 19)
		;	menuobj.Target, 	20
		s myTarget = $lg(myMnuInfo, 20)
		;	$lb(menuobj.Chart), 	21
		;	$lb(menuobj.ChartBook), 	22
		;	menuobj.PrintPreview, 		23
		s myPrintPreview = $lg(myMnuInfo, 23)
		;	menuobj.UpdateDate, 		24
		;	menuobj.UpdateTime, 		25
		;	menuobj.UpdateUser, 		26
		;	"",							27
		;	$lb(menuobj.Worklist), 		28
		;	menuobj.JavascriptFileName, 29
		s myJavascriptFileName = $lg(myMnuInfo, 29)
		;	menuobj.PrintLocal)			30
		s myPrintLocal = $lg(myMnuInfo, 30)
		
		i '($IsObject($g(%session))) {
			s %session = ##class(%CSP.Session).%New($j)
		}
		
		;判断菜单是否存在
		s myCurMenuRowID = $o(^websys.MenuI("UniqueNameIndex",$zu(28,myName,7,32768),0))
		s myMenuObj = ""
		if (+myCurMenuRowID>0){
			if (+myCurMenuRowID>10000){
				s myMenuObj = ##class(websys.Menu).%OpenId(myCurMenuRowID)
			}
		}else{
			s myMenuObj = ##class(websys.Menu).%New()
		}
		
		i $IsObject(myMenuObj) {
			;myMenuObj
			s myMenuObj.Caption = myCaption
			s myMenuObj.Image = myImage
			s myMenuObj.Method = myMethod
			s myMenuObj.Name = myName
			s myMenuObj.Sequence = mySequence
			s myMenuObj.ShortcutKey = myShortcutKey
			s myMenuObj.ShowInNewWindow = myShowInNewWindow
			s myMenuObj.Type  = myType
			s myMenuObj.LinkUrl = myLinkUrl
			s:(($e(myValueExpression, 1, 1)'="""")&&(myValueExpression'="")) myValueExpression=""""_myValueExpression_""""
			s myMenuObj.ValueExpression = myValueExpression
			;"",  11
			;$s($IsObject(menuobj.SubMenuOf):$lb(menuobj.SubMenuOf.Name,myMnuPath),1:$lb("")), 12
			;如果没有找到路径，需要建立路径自动建立
			s myMenuObj.SubMenuOf = mySubMenuOf
			;"",	13
			;"", 	14
			;$s($IsObject(menuobj.LinkComponent):$lb(menuobj.LinkComponent.Name), 1:$lb("")), 15
			s myMenuObj.LinkComponent = myCmpObj
			;$lb(menuobj.WorkFlow), 16
			;menuobj.JavascriptFunction,  17
			s myMenuObj.JavascriptFunction = myJavascriptFunction
			;	$lb(menuobj.LinkReport), 18
			
			;	menuobj.ConditionalExpression, 19
			s myMenuObj.ConditionalExpression = myConditionalExpression
			;	menuobj.Target, 	20
			s myMenuObj.Target = myTarget
			;	$lb(menuobj.Chart), 	21
			;	$lb(menuobj.ChartBook), 	22
			;	menuobj.PrintPreview, 		23
			s myMenuObj.PrintPreview = myPrintPreview
			;	menuobj.UpdateDate, 		24
			s myMenuObj.UpdateDate = +$h
			;	menuobj.UpdateTime, 		25
			s myMenuObj.UpdateTime = $p($h,",",2)
			;	menuobj.UpdateUser, 		26
			;	"",							27
			;	$lb(menuobj.Worklist), 		28
			;	menuobj.JavascriptFileName, 29
			s myMenuObj.JavascriptFileName = myJavascriptFileName
			;	menuobj.PrintLocal)			30
			s myMenuObj.PrintLocal = myPrintLocal
			;b	;;Before Save
			s mysc = myMenuObj.%Save()
		}
		
	}
	
	k ^TMPBDP.TempExport
	;$lb(menuobj.Caption, menuobj.Image, menuobj.Method, menuobj.Name,	menuobj.Sequence, menuobj.ShortcutKey,
	;	menuobj.ShowInNewWindow, menuobj.Type, menuobj.LinkUrl, menuobj.ValueExpression, "", 
	;	$s($IsObject(menuobj.SubMenuOf):$lb(menuobj.SubMenuOf.Name,myMnuPath),1:$lb("")), 
	;	"",	"", 
	;	$s($IsObject(menuobj.LinkComponent):$lb(menuobj.LinkComponent.Name), 1:$lb("")), 
	;	$lb(menuobj.WorkFlow), menuobj.JavascriptFunction,  
	;	$lb(menuobj.LinkReport), 
	;	menuobj.ConditionalExpression, menuobj.Target, 
	;	$lb(menuobj.Chart), 
	;	$lb(menuobj.ChartBook), 
	;	menuobj.PrintPreview, menuobj.UpdateDate, menuobj.UpdateTime, menuobj.UpdateUser, "",
	;	$lb(menuobj.Worklist), 	
	;	menuobj.JavascriptFileName, menuobj.PrintLocal)
	
	q $$$OK
}

ClassMethod GetParentMenu(MenuName As %String, MenuPath As %String) As %ObjectHandle
{
	n (MenuName, MenuPath)
	s pmenuobj=""
	s splitstr=$c(1)_"/"
	s exitflag=0
	s mylen = $l(MenuPath,splitstr)
	;验证对应的目录是否存在
	for myIdx = mylen:-1:1 {
		
	}
	;$zu(28,"aaa",7,32768)
	s myCurMenuRowID = $o(^websys.MenuI("UniqueNameIndex",$zu(28,MenuName,7,32768),0))
	
	if (+myCurMenuRowID'=0) {
		s pmenuobj = ##class(websys.Menu).%OpenId(myCurMenuRowID)
		;b	;;Menu Obj
	}
	
	q pmenuobj
}

}
