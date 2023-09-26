/// <H3>自动业务处理接口</H3>
/// <H4>创建者:李阳</H4>
Class DHCMed.CCService.AutoProcess.AutoWorkService Extends DHCMed.Abstract [ Not ProcedureBlock ]
{

/// <H3>功能：自动业务处理的主函数，可以通过Cache的自动业务定期执行此函数来实现自动监控</H3>
/// <H4>参数:</H4>
/// <OL>
/// <LI><B>FromDate</B>监控开始日期，支持日期格式：（1）Cache的日期格式，（2）YYYY-MM-DD格式 （3）DD/MM/YYYY</LI>
/// <LI><B>ToDate</B>监控结束日期，支持日期格式：（1）Cache的日期格式，（2）YYYY-MM-DD格式 （3）DD/MM/YYYY</LI>
/// </OL>
/// <H4>返回值:</H4>
/// 如果程序运行成功，返回字符串  OK
/// <H4>备注</H4>
/// 如果类库产生了运行异常，系统会将错误日志存储在类<B>DHCMed.CC.ErrorLog</B>中，管理员应该经常检查此实体类的内容。
/// <H4>实例</H4>
/// w ##class(DHCMed.CCService.AutoProcess.AutoWorkService).InpatientAutoWork("2016-05-01","2016-05-12")
ClassMethod InpatientAutoWork(FromDate As %String, ToDate As %String)
{
	New (FromDate,ToDate)
	
	Set $ZT="InpatientAutoWorkErr"
	
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
	
	//护理记录 (远卓数据同步到东华HIS中，安贞做特殊处理）
	//Do ##class(DHCMed.DCEns.NIS.ObResultTask).ProcBaseData("NIS01","V1")
	//Do ##class(DHCMed.DCEns.NIS.ObResultTask).SyncObsByDate(FromDate,ToDate,"NIS01","V1")
	
	//手术麻醉记录（麦迪斯顿数据同步到东华HIS中，安贞接口做的特殊处理）
	//Do ##class(DHCMed.DCEns.ORIS.OperationTask).ProcBaseData("ORIS01","V3")
	//Do ##class(DHCMed.DCEns.ORIS.OperationTask).SyncOperByDate(FromDate,ToDate,"ORIS01","V3")
	
	//监控主题任务
	Set SubjectID=""
	For {
		Set SubjectID=$o(^DHCMed.CC("Subject",SubjectID))	
		Quit:SubjectID=""
		
		Set objSubject=##class(DHCMed.CC.Subject).GetObjById(SubjectID)
		Continue:'$IsObject(objSubject)
		Continue:(+objSubject.IsActive=0)  //无效
		Continue:(+objSubject.IsAutoRun=0) //不是自动业务处理
		Set ret=##class(DHCMed.CCService.AutoProcess.CoreVMNew).Process(SubjectID, FromDate, ToDate,"","","")
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
	
InpatientAutoWorkErr
	Quit "Error"
}

/// Add By LiYang 2012-11-10
/// 自动监控前一天的数据 
/// w ##class(DHCMed.CCService.AutoProcess.AutoWorkService).InpatientAutoWorkYesterday()
ClassMethod InpatientAutoWorkYesterday()
{
	Set ctlDate=+$h-1
	Quit ..InpatientAutoWork(ctlDate,ctlDate)
}

}
