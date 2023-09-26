/// 名称: DHCMed.DPCustom.Stat.AutoTask
/// 描述: 数据池数据抽取自动任务
/// 编写者：zhufei
/// 编写日期: 2014-03-20
Class DHCMed.DPCustom.Stat.AutoTask Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Not ProcedureBlock ]
{

/// d ##Class(DHCMed.DPCustom.Stat.AutoTask).MainTask()
ClassMethod MainTask(aDateFrom As %String, aDateTo As %String) As %String
{
	new (aDateFrom,aDateTo)
	set return=0
	quit:(aDateFrom="")||(aDateTo="") return
	
	set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	
	set ErrMsg=""
	set flg=..GetIPAntiUsage(aDateFrom,aDateTo,.ErrMsg)
	if flg<0 {
		write ErrMsg,!
	}
	
	quit return
}

/// 取住院患者抗生素使用率相关数据
ClassMethod GetIPAntiUsage(aDateFrom As %String, aDateTo As %String, ByRef aErrMsg As %String) As %String
{
	new (aDateFrom,aDateTo,aErrMsg)
	set return=0
	set aErrMsg="参数为空!"
	quit:(aDateFrom="")||(aDateTo="") return
	
	set $ZT="GetIPAntiUsageErr"
	
	set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	
	set DefinedQuery=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("DPDat-QryIPAntiUsage","")
	if DefinedQuery="" {
		set DefinedQuery="DHCMed.DPCustom.Stat.IPAntiUsage:QryIPAntiUsage"
	}
	set ds = ##class(%Library.ResultSet).%New(DefinedQuery)
	
	for sttDate=aDateFrom:3:aDateTo {
		set endDate=sttDate+3
		set:endDate>aDateTo endDate=aDateTo
		do ds.Execute(sttDate,endDate)
		while(ds.Next())
		{
			set EpisodeID   = ds.Data("EpisodeID")     //就诊号
			set DataType    = ds.Data("DataType")      //数据类型（D出院、A在院）
			set ActDept     = ds.Data("ActDept")       //科室
			set ActWard     = ds.Data("ActWard")       //病区
			set ActDate     = ds.Data("ActDate")       //日期
			set ActTime     = ds.Data("ActTime")       //时间
			set AntiUseFlag = ds.Data("AntiUseFlag")   //是否使用抗生素
			set AntiObject  = ds.Data("AntiObject")    //用药目的 预防/治疗
			set AntiDDDs    = ds.Data("AntiDDDs")      //抗菌药物DDD频数
			set SubmitFlag  = ds.Data("SubmitFlag")    //是否送检
			set KSS1UseFlag = ds.Data("KSS1UseFlag")   //是否使用抗生素（非限制使用抗菌药物）
			set KSS1Object  = ds.Data("KSS1Object")    //用药目的 预防/治疗
			set KSS1DDDs    = ds.Data("KSS1DDDs")      //抗菌药物DDD频数
			set KSS2UseFlag = ds.Data("KSS2UseFlag")   //是否使用抗生素（限制使用抗菌药物）
			set KSS2Object  = ds.Data("KSS2Object")    //用药目的 预防/治疗
			set KSS2DDDs    = ds.Data("KSS2DDDs")      //抗菌药物DDD频数
			set KSS3UseFlag = ds.Data("KSS3UseFlag")   //是否使用抗生素（特殊使用抗菌药物）
			set KSS3Object  = ds.Data("KSS3Object")    //用药目的 预防/治疗
			set KSS3Object  = ds.Data("KSS3DDDs")      //抗菌药物DDD频数
			
			set inputStr=""
			set inputStr=inputStr_$c(1)_EpisodeID_$c(1)_DataType_$c(1)_ActDept_$c(1)_ActWard_$c(1)_ActDate_$c(1)_ActTime
			set inputStr=inputStr_$c(1)_AntiUseFlag_$c(1)_AntiObject_$c(1)_AntiDDDs_$c(1)_SubmitFlag
			set inputStr=inputStr_$c(1)_KSS1UseFlag_$c(1)_KSS1Object_$c(1)_KSS1DDDs
			set inputStr=inputStr_$c(1)_KSS2UseFlag_$c(1)_KSS2Object_$c(1)_KSS2DDDs
			set inputStr=inputStr_$c(1)_KSS3UseFlag_$c(1)_KSS3Object_$c(1)_KSS3DDDs
			set flg=##Class(DHCMed.DP.Stat.IPAntiUsage).Update(inputStr,$c(1))
		}
	}
	do ds.Close()
	
	Quit return
	
GetIPAntiUsageErr
	set aErrMsg=$ZError
	Quit -999
}

}
