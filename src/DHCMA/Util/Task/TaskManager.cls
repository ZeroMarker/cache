/// 名称: DHCMA.Util.Task.TaskManager
/// 描述: 医政组自动任务管理（iMedical8.3+所有相关自动任务都从这个类出去）
/// 编写者：pylian
/// 编写日期: 2020-04-20
Class DHCMA.Util.Task.TaskManager Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Do ##Class(DHCMA.Util.Task.TaskManager).AutoTask("2020-01-01","2020-04-15")
ClassMethod AutoTask(aDateFrom As %String, aDateTo As %String)
{
	New (aDateFrom,aDateTo)
	Set $ZT="AutoTaskErr"
	
	Set aDateFrom=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Quit:(aDateFrom="")||(aDateTo="") "OK"
	//记录执行任务日志
	Set Date=$zd(+$h,3),Time=$zt($p($h,",",2),1)
	Set YY=$p(Date,"-",1)
	Set MM=$p(Date,"-",2)
	Set DD=$p(Date,"-",3)
	Set NUM=$i(^DHCMA.Util.Task.TaskManager(YY_"-"_MM,DD))
	Set ^DHCMA.Util.Task.TaskManager(YY_"-"_MM,DD,NUM,"命令")="AutoTask("_aDateFrom_","_aDateTo_")"
	Set ^DHCMA.Util.Task.TaskManager(YY_"-"_MM,DD,NUM,"开始")=$zd(+$h,3)_" "_$zt($p($h,",",2),1)

	//同步基础信息
	Set ret= ##Class(DHCMA.Util.Task.SyncHisBaseDic).SyncBaseData("HIS01",aDateFrom,aDateTo)
	//出院患者队列
	Set ret= ##Class(DHCMA.Util.Task.SyncEpisQueue).CreateDischQueue("HIS01","",aDateFrom,aDateTo)
	//同步出院患者数据
	Set ret= ##Class(DHCMA.Util.Task.ExecuteQueue).AutoTask("Disch")
	
	//传染病
	Set Flg = ##class(DHCMA.Util.BT.Config).GetValueByCode("SYSIsSupportEPDTask")
	If (Flg=1) {
		Set ret=##class(DHCMed.EPDService.AutoTask).AutoTask(aDateFrom,aDateTo)
	}
	//重点患者
	Set Flg = ##class(DHCMA.Util.BT.Config).GetValueByCode("SYSIsSupportSPETask")
	If (Flg=1) {
		;Set ret=##class(DHCMed.SPEService.CaseXCtl).CtrlDischCaseX(aDateFrom,aDateTo)
		Set retAll=##class(DHCMA.IMP.Task.IMPScreeningSrv).ScrKeyPatientsAll()
		Set ret=##class(DHCMA.IMP.Task.IMPScreeningSrv).ScrKeyPatientsByDate(aDateFrom,aDateTo)
	}
	//临床路径
	Set Flg = ##class(DHCMA.Util.BT.Config).GetValueByCode("SYSIsSupportCPWTask")
	If (Flg=1) {
		
		//住院临床路径是否自动确认阶段，不处理签名，按配置处理变异
		Set retFlg = ##class(DHCMA.Util.BT.Config).GetValueByCode("CPWIsAutoConfirmEpis")
		If (retFlg="Y") {
			Set ret=##class(DHCMA.CPW.CPS.ImplementSrv).AutoConfirmStep()			//此处可传入指定院区
		}

		//临床路径月报表生成数据
		Set ret= ##class(DHCMA.CPW.STAS.CreateData).SyncDataByMonth(aDateFrom,aDateTo)   //加错误保护
	}
	//门诊路径 路径状态自动处理任务
	Set Flg = ##class(DHCMA.Util.BT.Config).GetValueByCode("SYSIsSupportOPCPWTask")
	If (Flg=1) {
		Set ret= ##class(DHCMA.CPW.OPCPS.OPCPWTaskManager).AutoHandlePathStatusTask()
	}
	
	//单病种
	Set Flg = ##class(DHCMA.Util.BT.Config).GetValueByCode("SYSIsSupportSDTask")
	If (Flg=1) {
		//筛查单病种病例任务
		Set ret= ##class(DHCMA.CPW.SDS.QCTask).AutoTaskForMrList(aDateFrom,aDateTo)
	}
	
	//食源性疾病
	Set Flg = ##class(DHCMA.Util.BT.Config).GetValueByCode("SYSIsSupportFBDTask")
	If (Flg=1) {
		Set ret= ##class(DHCMed.SSService.AutoTask).StartTask(aDateFrom,aDateTo,"","FBD")
	}
	
	//非重大传染性疾病
	Set Flg = ##class(DHCMA.Util.BT.Config).GetValueByCode("SYSIsSupportCDTask")
	If (Flg=1) {
		Set ret= ##class(DHCMed.SSService.AutoTask).StartTask(aDateFrom,aDateTo,"","CD")
	}
	
	//记录执行任务日志（成功标记）
	Set ^DHCMA.Util.Task.TaskManager(YY_"-"_MM,DD,NUM,"结束")=$zd(+$h,3)_" "_$zt($p($h,",",2),1)
	
	Quit "OK"
	
AutoTaskErr
	Quit "Error"
}

}
