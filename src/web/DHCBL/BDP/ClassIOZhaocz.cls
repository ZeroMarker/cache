Class web.DHCBL.BDP.ClassIOZhaocz Extends web.DHCBL.BDP.ClassCheckIO [ Not ProcedureBlock ]
{

/// d ##class(web.DHCBL.BDP.ClassIOZhaocz).CreatIndex()
ClassMethod CreatIndex()
{
	k ^User.BDPAliasI
	d ##class(User.BDPAlias).%BuildIndices()

	k ^User.BDPBaseDataMapI
	d ##class(User.BDPBaseDataMap).%BuildIndices()
	k ^User.BDPBaseDataMapDetailI
	d ##class(User.BDPBaseDataMapDetail).%BuildIndices()
	k ^User.BDPConfigI
	d ##class(User.BDPConfig).%BuildIndices()
	k ^User.BDPDataDictionaryI
	d ##class(User.BDPDataDictionary).%BuildIndices()
	k ^User.BDPEIMenuI
	d ##class(User.BDPEIMenu).%BuildIndices()
	k ^User.BDPEXConfigI
	d ##class(User.BDPEXConfig).%BuildIndices()
	k ^User.BDPEXFieldConfigI
	d ##class(User.BDPEXFieldConfig).%BuildIndices()
	
	
	k ^User.BDPExecutablesI
	d ##class(User.BDPExecutables).%BuildIndices()
	
	k ^User.BDPExtExecItemI
	d ##class(User.BDPExtExecItem).%BuildIndices()
	k ^User.BDPIMConfigI
	d ##class(User.BDPIMConfig).%BuildIndices()
	k ^User.BDPIMFieldConfigI
	d ##class(User.BDPIMFieldConfig).%BuildIndices()
	k ^User.BDPMappingHospI
	d ##class(User.BDPMappingHosp).%BuildIndices()
	k ^User.BDPMenuI
	d ##class(User.BDPMenu).%BuildIndices()
	
	k ^User.BDPTableListI
	d ##class(User.BDPTableList).%BuildIndices()
	k ^User.BDPTableFieldI
	d ##class(User.BDPTableField).%BuildIndices()
}

ClassMethod Out()
{
	;
	;d ##class(web.DHCBL.BDP.ClassIOZhaocz).Out()
	s mypath = "E:\公司SVNClientServer\CPMCTClientServer\developer\源代码\基础平台\Class"
	d ..BatchOut(mypath)
	;d ..BatchOut("E:\公司SVNClientServer\CPMCTClientServer\SVN\")
	w mypath,!
}

/// 调试：d ##class(web.DHCBL.BDP.ClassIOZhaocz).SetGlobal()
ClassMethod SetGlobal() As %String
{
	///d ##class(web.DHCBL.BDP.ClassIOZhaocz).SetGlobal()
	K ^CF.DOC.ASR.CommandSetD
	K ^CF.DOC.ASR.CommandSetI
	K ^CF.DOC.ASR.CommandParamsD
	K ^CF.DOC.ASR.CommandParamsI

	s ^CF.DOC.ASR.CommandSetD(0)=1
	s ^CF.DOC.ASR.CommandSetD(1)="语音录入^云知声语音厂商^1.1^^云知声^^65301^"
	s ^CF.DOC.ASR.CommandSetD(1,"Scenes",0)=6
	s ^CF.DOC.ASR.CommandSetD(1,"Scenes",1)="全场景^全场景^Y^备注哈"
	s ^CF.DOC.ASR.CommandSetD(1,"Scenes",1,"Cmd",0)=1
	s ^CF.DOC.ASR.CommandSetD(1,"Scenes",1,"Cmd",1)="Y^closeMsgWindow^关闭消息框^^^Link^"
	s ^CF.DOC.ASR.CommandSetD(1,"Scenes",2)="病人列表^病人列表^Y^"
	s ^CF.DOC.ASR.CommandSetD(1,"Scenes",2,"Cmd",0)=3
	s ^CF.DOC.ASR.CommandSetD(1,"Scenes",2,"Cmd",1)="Y^selPatient^选择患者就诊^^^JSFun^SelectPatient"
	s ^CF.DOC.ASR.CommandSetD(1,"Scenes",2,"Cmd",2)="Y^nextPage^下一页^^^JSFun^NextPage"
	s ^CF.DOC.ASR.CommandSetD(1,"Scenes",2,"Cmd",3)="Y^prevPage^上一页^^^JSFun^PrevPage"
	s ^CF.DOC.ASR.CommandSetD(1,"Scenes",3)="诊疗^诊疗^Y^"
	s ^CF.DOC.ASR.CommandSetD(1,"Scenes",3,"Cmd",0)=1
	s ^CF.DOC.ASR.CommandSetD(1,"Scenes",3,"Cmd",1)="Y^openOrderEntry^打开医嘱录入^^^Focus^"
	s ^CF.DOC.ASR.CommandSetD(1,"Scenes",4)="HeaderMenu^头菜单^Y^"
	s ^CF.DOC.ASR.CommandSetD(1,"Scenes",4,"Cmd",0)=4
	s ^CF.DOC.ASR.CommandSetD(1,"Scenes",4,"Cmd",1)="Y^openOrderDoc^打开医嘱单^^^JSFun^soundOpenOrderDoc"
	s ^CF.DOC.ASR.CommandSetD(1,"Scenes",4,"Cmd",2)="Y^openEMR^打开病历浏览^^^JSFun^soundOpenEMR"
	s ^CF.DOC.ASR.CommandSetD(1,"Scenes",4,"Cmd",3)="Y^openMsgWindow^打开消息^^^JSFun^soundOpenMsgWindow"
	s ^CF.DOC.ASR.CommandSetD(1,"Scenes",4,"Cmd",4)="Y^closeMsgWindow^关闭消息^^^JSFun^soundCloseMsgWindow"
	s ^CF.DOC.ASR.CommandSetD(1,"Scenes",5)="orderMenuGroup^诊疗与病历^Y^"
	s ^CF.DOC.ASR.CommandSetD(1,"Scenes",5,"Cmd",0)=3
	s ^CF.DOC.ASR.CommandSetD(1,"Scenes",5,"Cmd",1)="Y^openOrderEntry^打开医嘱录入^^^JSFun^soundOpenOrderEntry"
	s ^CF.DOC.ASR.CommandSetD(1,"Scenes",5,"Cmd",2)="Y^openDiagnosEntry^打开诊断录入^^^JSFun^soundOpenDiagnosEntry"
	s ^CF.DOC.ASR.CommandSetD(1,"Scenes",5,"Cmd",3)="N^openPatientList^打开病人列表^^^JSFun^soundOpenPatientList"
	s ^CF.DOC.ASR.CommandSetD(1,"Scenes",6)="chartbook^图表^Y^"
	s ^CF.DOC.ASR.CommandSetD(1,"Scenes",6,"Cmd",0)=1
	s ^CF.DOC.ASR.CommandSetD(1,"Scenes",6,"Cmd",1)="Y^closeEMR^关闭病历浏览^^^JSFun^soundCloseEMR"

	s ^CF.DOC.ASR.CommandSetI("CommandName",1,1,"closeMsgWindow",1)=""
	s ^CF.DOC.ASR.CommandSetI("CommandName",1,2,"nextPage",2)=""
	s ^CF.DOC.ASR.CommandSetI("CommandName",1,2,"prevPage",3)=""
	s ^CF.DOC.ASR.CommandSetI("CommandName",1,2,"selPatient",1)=""
	s ^CF.DOC.ASR.CommandSetI("CommandName",1,3,"openOrderEntry",1)=""
	s ^CF.DOC.ASR.CommandSetI("CommandName",1,4,"closeMsgWindow",4)=""
	s ^CF.DOC.ASR.CommandSetI("CommandName",1,4,"openEMR",2)=""
	s ^CF.DOC.ASR.CommandSetI("CommandName",1,4,"openMsgWindow",3)=""
	s ^CF.DOC.ASR.CommandSetI("CommandName",1,4,"openOrderDoc",1)=""
	s ^CF.DOC.ASR.CommandSetI("CommandName",1,5,"openDiagnosEntry",2)=""
	s ^CF.DOC.ASR.CommandSetI("CommandName",1,5,"openOrderEntry",1)=""
	s ^CF.DOC.ASR.CommandSetI("CommandName",1,5,"openPatientList",3)=""
	s ^CF.DOC.ASR.CommandSetI("CommandName",1,6,"closeEMR",1)=""
	s ^CF.DOC.ASR.CommandSetI("Company","云知声","语音录入",1.1,1)=""
	s ^CF.DOC.ASR.CommandSetI("Scenes","HeaderMenu",1,4)=""
	s ^CF.DOC.ASR.CommandSetI("Scenes","chartbook",1,6)=""
	s ^CF.DOC.ASR.CommandSetI("Scenes","orderMenuGroup",1,5)=""
	s ^CF.DOC.ASR.CommandSetI("Scenes","全场景",1,1)=""
	s ^CF.DOC.ASR.CommandSetI("Scenes","病人列表",1,2)=""
	s ^CF.DOC.ASR.CommandSetI("Scenes","诊疗",1,3)=""


	s ^CF.DOC.ASR.CommandParamsD(0)=1
	s ^CF.DOC.ASR.CommandParamsD(1)="1||2^p1^床号^04^床号"

	s ^CF.DOC.ASR.CommandParamsI("CustomCommandName","p1",1)=""
	s ^CF.DOC.ASR.CommandParamsI("ScenesCmd","1||2","p1",1)=""
}

/// 需要导入开发的类
ClassMethod In()
{
	;d ##class(web.DHCBL.BDP.ClassIOZhaocz).In()
	;b	;;
	;d ..BatchIn("E:\公司SVNClientServer\CPMCTClientServer\SVN\")
	d ..BatchIn("E:\公司SVNClientServer\CPMCTClientServer\developer\源代码\基础维护\class")
	b	;;
	d $SYSTEM.OBJ.CompilePackage("web.Entity.CT","ck1")
	d $SYSTEM.OBJ.CompilePackage("web.DHCBL.Authorize","ck1")
	;d $SYSTEM.OBJ.CompilePackage("web.DHCBL.BDP","ck1")
	d $SYSTEM.OBJ.CompilePackage("web.DHCBL.CT","ck1")
}

/// Creator：zhaocz
/// CreatDate: 2012-10-18
/// Description：传入数组格式：  s ClassAry(classname)=""
/// Table：
/// Input：d ##class(web.DHCBL.BDP.ClassIOZhaocz).BatchOut("E:\")
ClassMethod SetClassAry(ByRef ClassAry As %String) As %String
{
	n (ClassAry)
	
	;超类列表
	s ClassAry("web.DHCEntity.ELAbstract")=""
	
	s ClassAry("web.BDP.manager.CheckInOutClass")=""
	s ClassAry("web.BDP.manager.Menu")=""
	s ClassAry("web.DHCBL.BDP.ClassCheckIO")=""
	s ClassAry("web.DHCBL.BDP.ClassIOZhaocz")=""
	s ClassAry("web.DHCBL.BDP.MenuIO")=""
	s ClassAry("web.DHCBL.BDP.MenuIOZhaocz")=""
	s ClassAry("web.DHCBL.BDP.ClassDefine")=""
	
	;系统类列表
	;BDP/ext/entity
	s ClassAry("web.BDP.ext.entity.ColumnModel")=""
	s ClassAry("web.BDP.ext.entity.ColumnModels")=""
	s ClassAry("web.BDP.ext.entity.Component")=""
	s ClassAry("web.BDP.ext.entity.Contanier")=""
	s ClassAry("web.BDP.ext.entity.Field")=""
	s ClassAry("web.BDP.ext.entity.Grid")=""
	s ClassAry("web.BDP.ext.entity.GridData")=""
	s ClassAry("web.BDP.ext.entity.GridModal")=""
	s ClassAry("web.BDP.ext.entity.MenuItem")=""
	s ClassAry("web.BDP.ext.entity.Tree")=""
	s ClassAry("web.BDP.ext.entity.TreeNode")=""
	
	; 新增系统管理类
	s ClassAry("User.BDPExecutables")=""
	s ClassAry("User.BDPExtExecItem")=""
	s ClassAry("User.BDPDataChangeLog")=""
	s ClassAry("User.BDPMenu")=""
	s ClassAry("User.BDPPreferences")=""
	s ClassAry("User.BDPAlias")=""
	
	;BDP.ext.sys
	s ClassAry("web.BDP.sys.Broker")=""
	s ClassAry("web.BDP.sys.Configuration")=""
	s ClassAry("web.BDP.sys.Conversions")=""
	s ClassAry("web.BDP.sys.EntityBroker")=""
	s ClassAry("web.BDP.sys.EntityBroker")=""
	s ClassAry("web.BDP.sys.QueryBroker")=""
	s ClassAry("web.BDP.sys.QueryReadBroker")=""
	s ClassAry("web.BDP.sys.ExtLib")=""
	s ClassAry("web.BDP.sys.ExtPreferences")=""
	s ClassAry("web.BDP.sys.ExtPreferencesSubKey")=""
	s ClassAry("web.BDP.sys.Menu")=""
	s ClassAry("web.BDP.sys.Preferences")=""
	s ClassAry("web.BDP.sys.PreferencesSubKey")=""
	s ClassAry("web.BDP.sys.String")=""
	s ClassAry("web.BDP.util.String")=""
	;b	;;SetClass
	s ClassAry("csp.web.csp.dhc.bdp.ext.default")=""
	s ClassAry("csp.web.csp.dhc.bdp.ext.querydatatrans")=""
	s ClassAry("csp.web.csp.dhc.bdp.ext.datatrans")=""
	s ClassAry("csp.web.csp.dhc.bdp.ext.entitydatatrans")=""
	s ClassAry("csp.web.csp.dhc.bdp.ext.sys")=""
	
	s ClassAry("csr.csp.EXTHEALTH.EXTFILENAME")=""
	s ClassAry("csr.csp.EXTHEALTH.BDPHEAD")=""
	s ClassAry("csr.csp.EXTHEALTH.BDPEXT321")=""
	
	;授权
	;s ClassAry("web.DHCBL.Authorize.Menu")=""
	;s ClassAry("web.Entity.Authorize.Menu")=""
	
	s ClassAry("web.Entity.BDP.ObjectPreferences")=""
	;s ClassAry("web.DHCBL.Authorize.Executables")=""
	
	;s ClassAry("web.Entity.Authorize.Executables")=""
	;s ClassAry("web.Entity.Authorize.Menu")=""
	
	q ""
}

/// d ##class(web.DHCBL.BDP.ClassIOGuxueping).ExportMKBGlobal()
ClassMethod ExportSYMGlobal()
{
	k CList
	k myIdx
	
	//症状
	s CList($i(CList))= "DHCSYMFEI.GBL"  ;症状
    s CList($i(CList))= "User.DHCSymptomLevD.GBL"
    s CList($i(CList))= "User.DHCSymptomLevI.GBL"  ;症状分级
    s CList($i(CList))= "DHCSYMCON.GBL"
    s CList($i(CList))= "DHCSYMCONi.GBL"  ;关联表
   
	
	s items = ""
	f {
		s myIdx = $i(myIdx)
		q:(myIdx>$g(CList))
		s:((items'="")&&(CList(myIdx)'="")) items= items_","

		s items = items_CList(myIdx)
	}

	d $SYSTEM.OBJ.Export(items, "D:\SYMData0705.gof", "", .log)
}

/// d ##class(web.DHCBL.BDP.ClassIOZhaocz).ExportGlobal()
/// w ##class(web.DHCBL.BDP.BDPMenuImport).ExportGof("C:\TMPMENU.gof")    //导出
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
	s CList($i(CList))= "User.BDPIconManageD.GBL"
	s CList($i(CList))= "User.BDPIconManageI.GBL"


	;国家标准编码
	;s CList($i(CList))= "BDPDATADOMAIN.GBL"
	;s CList($i(CList))= "BDPDOMAINTYPE.GBL"

	
	;导入导出的global——BDPDataIMEX
	/*s CList($i(CList))= "User.BDPEILinkD.GBL"
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
	s CList($i(CList))= "User.BDPEIMenuI.GBL"*/
	
	//菜单和功能大表的global——Menu.gof
	/*s CList($i(CList))= "User.BDPExecutablesC.GBL"
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
    ;d $SYSTEM.OBJ.Export(items, "D:\BDPDATADOMAIN.gof", "", .log)
	;d $SYSTEM.OBJ.Export(items, "D:\BDPDOMAINTYPE.gof", "", .log)
	;d $SYSTEM.OBJ.Export(items, "D:\BDPDataIMEX.gof", "", .log)
	;d $SYSTEM.OBJ.Export(items, "D:\Menu.gof", "", .log)
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

/// d ##class(web.DHCBL.BDP.ClassIOZhaocz).ExportData("D:\BDPEXConfig.gof")
ClassMethod ExportData(dir)
{
	n (dir)
	k CList
	k myIdx
	
	s CList($i(CList))= "User.BDPEXConfigC.GBL"
	s CList($i(CList))= "User.BDPEXConfigD.GBL"
	s CList($i(CList))= "User.BDPEXConfigI.GBL"
	s CList($i(CList))= "User.BDPEXFieldConfigI.GBL"
	
	s items = ""
	f {
		s myIdx = $i(myIdx)
		q:(myIdx>$g(CList))
		s:((items'="")&&(CList(myIdx)'="")) items= items_","

		s items = items_CList(myIdx)
	}

	d $SYSTEM.OBJ.Export(items, dir, "", .log)
	q 1
}

}
