Class web.DHCBL.BDP.MenuIOZhaocz Extends web.DHCBL.BDP.MenuIO [ Not ProcedureBlock ]
{

/// Creator：zhaocz
/// CreatDate: 2012-10-18
/// Description：批量导出类，每个类生产一个文件
/// Table：
/// Input：
ClassMethod Out() As %String
{
	;d ##class(web.DHCBL.BDP.MenuIOZhaocz).Out()
	d ..BatchOut("E:\AAA.xml")
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

ClassMethod In() As %String
{
	;d ##class(web.DHCBL.BDP.MenuIOZhaocz).In()
	d ..BatchIn("D:\tmpComp\MenuXMl\chenying.xml")
	d ..BatchIn("D:\tmpComp\MenuXMl\lisen.xml")
	d ..BatchIn("D:\tmpComp\MenuXMl\caihaozhe.xml")
}

/// d ##class(web.DHCBL.BDP.ClassIOZhaocz).ExportGlobal()
/// w ##class(web.DHCBL.BDP.BDPMenuImport).ExportGof("F:\备份\global\TMPMENU.gof")    //导出
ClassMethod ExportGlobal()
{
	k CList
	k myIdx
	
	//平台配置和表结构登记的global——BDPSystemData.gof
	s CList($i(CList))= "User.BDPConfigD.GBL"
	s CList($i(CList))= "User.BDPConfigI.GBL"
	s CList($i(CList))= "User.BDPMenuTableD.GBL"
	s CList($i(CList))= "User.BDPMenuTableI.GBL"
	s CList($i(CList))= "User.BDPTableFieldI.GBL"
	s CList($i(CList))= "User.BDPTableListD.GBL"
	s CList($i(CList))= "User.BDPTableListI.GBL"
	s CList($i(CList))= "User.BDPTableListC.GBL"


	;国家标准编码
	/*s CList($i(CList))= "BDPDATADOMAIN.GBL"
	s CList($i(CList))= "BDPDOMAINTYPE.GBL"

	
	;导入导出的global——BDPDataIMEX
	s CList($i(CList))= "User.BDPEILinkD.GBL"
	s CList($i(CList))= "User.BDPEILinkI.GBL"
	s CList($i(CList))= "User.BDPEXConfigC.GBL"
	s CList($i(CList))= "User.BDPEXConfigD.GBL"
	s CList($i(CList))= "User.BDPEXConfigI.GBL"
	s CList($i(CList))= "User.BDPEXFieldConfigI.GBL"
	s CList($i(CList))= "User.BDPIMConfigC.GBL"
	s CList($i(CList))= "User.BDPIMConfigD.GBL"
	s CList($i(CList))= "User.BDPIMConfigI.GBL"
	s CList($i(CList))= "User.BDPIMFieldConfigI.GBL"	
	s CList($i(CList))= "User.BDPEIMenuD.GBL"
	s CList($i(CList))= "User.BDPEIMenuI.GBL"
	
	//菜单和功能大表的global——Menu.gof
	s CList($i(CList))= "User.BDPExecutablesC.GBL"
	s CList($i(CList))= "User.BDPExecutablesD.GBL"
	s CList($i(CList))= "User.BDPExecutablesI.GBL"
	s CList($i(CList))= "User.BDPExtExecItemI.GBL"
	s CList($i(CList))= "User.BDPMenuD.GBL"
	s CList($i(CList))= "User.BDPMenuI.GBL"
	s CList($i(CList))= "User.BDPIconManageD.GBL"
	s CList($i(CList))= "User.BDPIconManageI.GBL"*/

	s items = ""
	f {
		s myIdx = $i(myIdx)
		q:(myIdx>$g(CList))
		s:((items'="")&&(CList(myIdx)'="")) items= items_","

		s items = items_CList(myIdx)
	}

	d $SYSTEM.OBJ.Export(items, "D:\BDPSystemData.gof", "", .log)
        /*d $SYSTEM.OBJ.Export(items, "D:\BDPDATADOMAIN.gof", "", .log)
	d $SYSTEM.OBJ.Export(items, "D:\BDPDOMAINTYPE.gof", "", .log)
	d $SYSTEM.OBJ.Export(items, "D:\BDPDataIMEX.gof", "", .log)
	d $SYSTEM.OBJ.Export(items, "D:\Menu.gof", "", .log)*/
}

ClassMethod KillGlobal()
{
	;d ##class(web.DHCBL.BDP.ClassIOZhaocz).KillGlobal()
	;d $SYSTEM.OBJ.ImportDir("D:\","BDPGlobal.gof")
	k ^User.BDPExecutablesC
	k ^User.BDPExecutablesD
	k ^User.BDPExecutablesI
	k ^User.BDPExtExecItemI
	k ^User.BDPMenuD
	k ^User.BDPMenuI
	
	k ^User.BDPConfigD
 	k ^User.BDPConfigI
 	k ^User.BDPMenuTableD
 	k ^User.BDPMenuTableI
 	k ^User.BDPTableFieldI
 	k ^User.BDPTableListC
 	k ^User.BDPTableListD
 	k ^User.BDPTableListI
 	;国家标准编码
 	k ^BDPDATADOMAIN
	k ^BDPDOMAINTYPE 
	;图标管理
	k ^User.BDPIconManageD
	k ^User.BDPIconManageI
		
 	//导入配置表和导出配置表
 	k ^User.BDPEILinkD
	k ^User.BDPEILinkI
 	k ^User.BDPIMConfigC
 	k ^User.BDPIMConfigD
 	k ^User.BDPIMConfigI
 	k ^User.BDPIMFieldConfigI
 	k ^User.BDPEXConfigC
 	k ^User.BDPEXConfigD
 	k ^User.BDPEXConfigI
 	k ^User.BDPEXFieldConfigI
 	k ^User.BDPEIMenuD
 	k ^User.BDPEIMenuI
 	
	q "ok"
}

}
