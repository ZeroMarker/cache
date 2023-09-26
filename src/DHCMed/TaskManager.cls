/// 名称: DHCMed.TaskManager
/// 描述: 医政组自动任务管理（所有相关自动任务都从这个类出去）
/// 编写者：zhufei
/// 编写日期: 2014-03-04
Class DHCMed.TaskManager Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Do ##Class(DHCMed.TaskManager).AutoTask("2013-11-01","2013-11-15")
ClassMethod AutoTask(FromDate As %String, ToDate As %String)
{
	New (FromDate,ToDate)
	
	Set $ZT="AutoTaskErr"
	
	Set:FromDate["-" FromDate=$zdh(FromDate,3)
	Set:FromDate["/" FromDate=$zdh(FromDate,4)
	Set:FromDate'="" FromDate=+FromDate
	Set:ToDate["-" ToDate=$zdh(ToDate,3)
	Set:ToDate["/" ToDate=$zdh(ToDate,4)
	Set:FromDate'="" ToDate=+ToDate
	Quit:(FromDate="")||(ToDate="") "OK"
	
	//记录执行任务日志
	Set Date=$zd(+$h,3),Time=$zt($p($h,",",2),1)
	Set YY=$p(Date,"-",1)
	Set MM=$p(Date,"-",2)
	Set DD=$p(Date,"-",3)
	Set ^DHCMed.TaskManager(YY_"-"_MM,DD,Time)=""
	Set ^DHCMed.TaskManager(YY_"-"_MM,DD,Time,"Arg")=FromDate_","_ToDate
	
	//在院患者（东华HIS）
	Do ##class(DHCMed.DCEns.HIS.InHospTask).SyncInHospByDate(FromDate,ToDate,"HIS01","V1")
	
	//检验系统（东华检验系统）
	Do ##class(DHCMed.DCEns.LIS.TSResultTask).ProcBaseData("LIS01","V2")
	Do ##class(DHCMed.DCEns.LIS.TSResultTask).SyncRepByDate(FromDate,ToDate,"LIS01","V2")
	
	//监控主题任务
	Set SubjectID=""
	For {
		Set SubjectID=$o(^DHCMed.CC("Subject",SubjectID))	
		Quit:SubjectID=""
		
		Set objSubject=##class(DHCMed.CC.Subject).GetObjById(SubjectID)
		Continue:'$IsObject(objSubject)
		Continue:(+objSubject.IsActive=0)  //无效
		Continue:(+objSubject.IsAutoRun=0) //不是自动业务处理
		Set ret=##class(DHCMed.CCService.AutoProcess.CoreVMNew).Process(SubjectID, FromDate, ToDate)
	}
	
	//处理转科记录
	Set flg=##Class(DHCMed.CC.CtlAdmTrans).ProAdmTrans(FromDate,ToDate)
	//疑似病例筛查
	Set flg=##Class(DHCMed.NINFService.BC.AutoTask).CasesXTask(FromDate,ToDate,"INTCCS")
	//感染暴发预警
	Set flg=##Class(DHCMed.NINFService.BC.AutoTask).WarningTask(FromDate,ToDate,"INFWARN")
	//传染病筛查
	Set flg=##Class(DHCMed.EPDService.AutoTask).CasesXTask(FromDate,ToDate,"EPDCC")
	
	//记录执行任务日志（成功标记）
	Set ^DHCMed.TaskManager(YY_"-"_MM,DD,Time)="OK"
	
	Quit "OK"
	
AutoTaskErr
	Quit "Error"
}

}
