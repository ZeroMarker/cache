/// 名称: DHCWMR.TaskManager
/// 描述: 病案管理自动任务管理（所有相关自动任务都从这个类出去）
/// 编写者：zhufei
/// 编写日期: 2016-01-26
Class DHCWMR.TaskManager Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Do ##Class(DHCWMR.TaskManager).AutoTask("2013-11-01","2013-11-15")
ClassMethod AutoTask(FromDate As %String, ToDate As %String)
{
	New (FromDate,ToDate)
	
	Set $ZT="AutoTaskErr"
	
	Set:FromDate["-" FromDate=$zdh(FromDate,3)
	Set:FromDate["/" FromDate=$zdh(FromDate,4)
	Set:FromDate'="" FromDate=+FromDate
	Set:ToDate["-" ToDate=$zdh(ToDate,3)
	Set:ToDate["/" ToDate=$zdh(ToDate,4)
	Set:ToDate'="" ToDate=+ToDate
	Quit:(FromDate="")||(ToDate="") "OK"
	
	//记录执行任务日志
	Set Date=$zd(+$h,3),Time=$zt($p($h,",",2),1)
	Set YY=$p(Date,"-",1)
	Set MM=$p(Date,"-",2)
	Set DD=$p(Date,"-",3)
	Set ^DHCWMR.TaskManager(YY_"-"_MM,DD,Time)=""
	Set ^DHCWMR.TaskManager(YY_"-"_MM,DD,Time,"Arg")=FromDate_","_ToDate
	
	//同步东华住院病案首页结构化存储
	//Set flg=##class(DHCWMR.MRService.ImportDataByEmr).Task("",$h-10,$h-10)
	//发送病案迟归消息到消息平台
	Set flg=##class(DHCWMR.SSService.VolDischSrv).QryLateBackSendMsg()
	
	//记录执行任务日志（成功标记）
	Set ^DHCWMR.TaskManager(YY_"-"_MM,DD,Time)="OK"
	
	Quit "OK"
	
AutoTaskErr
	Quit "Error"
}

}
