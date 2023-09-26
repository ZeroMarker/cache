/// 名称: DHCWMR.Service
/// 描述: 病案系统公共服务
/// 编写者：zhufei
/// 编写日期: 2014-08-26
Class DHCWMR.Service Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// 获取模板文件存放目录
/// w ##class(DHCWMR.Service).GetTemplatePath()
ClassMethod GetTemplatePath() As %String
{
	New
	Set strPath=##class(DHCWMR.SSService.ConfigSrv).GetValueByKeyHosp("SSTemplatePath")
	If strPath="" {
		Set objConfig=##class(websys.Configuration).%OpenId(1)
		Do objConfig.%Close()
		Set strPath=objConfig.PathToReports
	} Else {
		Set strPath=$tr(strPath,"/","\")
	}
	Quit strPath
}

/// 字符串替换
/// w ##class(DHCWMR.Service).ReplaceString()
ClassMethod ReplaceString(Str, OldStr, NewStr)
{
	n (Str, OldStr, NewStr)
	set intCounter = 1
	while (1)
	{
		set tmp =$e(Str, intCounter, intCounter + $l(OldStr) - 1) 
		if (tmp = OldStr)
		{
			 set $e(Str, intCounter, intCounter + $l(OldStr) - 1) = NewStr
			 set intCounter = intCounter + $l(NewStr) - $l(OldStr)
		}
		quit:intCounter>=$l(Str)
		set intCounter = intCounter + 1
	}
	quit Str
}

/// 说明：合并病人
/// 参数：FromPatientID:源病人ID
///       ToPatientID:目标病人ID
///       UserId:操作用户ID
/// 功能：将病人ID从FromPatientID转到ToPatientID下
/// w ##class(DHCWMR.Service).MergePatient(142721,112582,1)
ClassMethod MergePatient(FromPatientID As %String, ToPatientID As %String, UserId As %String) As %Integer
{
	new (FromPatientID,ToPatientID,UserId)
	
	quit ret
}

/// 说明：取消合并病人
/// 参数：FromPatientID:源病人ID
///       ToPatientID:目标病人ID
///       UserId:操作用户ID
/// 功能：将曾经从FromPatientID转到ToPatientID下的病人ID还原
/// w ##class(DHCWMR.Service).CancelMerge(142721,112582,1)
ClassMethod CancelMerge(FromPatientID As %String, ToPatientID As %String, UserId As %String) As %Integer
{
	n (FromPatientID,ToPatientID,UserId)
	
	quit ret
}

/// w ##Class(DHCWMR.Service).KillBusinessData()
ClassMethod KillBusinessData()
{
	//处理医院院区
	;Kill ^DHCWMR.SS.HospitalD
	;Kill ^DHCWMR.SS.HospitalI
	
	//处理病案号
	Kill ^DHCWMR.SS.MrNoC	
	Kill ^DHCWMR.SS.MrNoD
	Kill ^DHCWMR.SS.MrNoI
	//处理主表
	Kill ^DHCWMR.SS.MainD
	Kill ^DHCWMR.SS.MainI
	//处理卷表
	Kill ^DHCWMR.SS.VolumeD
	Kill ^DHCWMR.SS.VolumeI
	//流程业务
	Kill ^DHCWMR.SS.OperationD
	Kill ^DHCWMR.SS.OperationI
	Kill ^DHCWMR.SS.ReceiptLogD
	Kill ^DHCWMR.SS.ReceiptLogI
	Kill ^DHCWMR.SS.RequestD
	Kill ^DHCWMR.SS.RequestI
	Kill ^DHCWMR.SS.RsRquestD
	Kill ^DHCWMR.SS.RsRquestI
	Kill ^DHCWMR.SS.MergerLogD
	Kill ^DHCWMR.SS.MergerLogI
	Kill ^DHCWMR.SS.WorkList
	Kill ^DHCWMR.SS.BatchNumber
	//处理编目对照
	Kill ^DHCWMR.FP.FPMappingD
	Kill ^DHCWMR.FP.FPMappingI
	Kill ^DHCWMR.FP.FrontPageD
	Kill ^DHCWMR.FP.FrontPageI
	kill ^DHCWMR.FP.PathologRepD 
	kill ^DHCWMR.FP.PathologRepI
	//病案独立突发复印
	Kill ^DHCWMR.MO.CopyRecordD
	Kill ^DHCWMR.MO.CopyRecordI
	kill ^DHCWMR.MO.CopyRecordC
	kill ^DHCWMR.MO.LendBarD 
	kill ^DHCWMR.MO.LendBarI 
	Kill ^DHCWMR.MO.LendRecordD
	Kill ^DHCWMR.MO.LendRecordI
	Kill ^DHCWMR.MO.SealRecordD
	Kill ^DHCWMR.MO.SealRecordI
	Kill ^DHCWMR.MF.FeeRecordD
	Kill ^DHCWMR.MF.FeeRecordI
	//门诊病案
	kill ^DHCWMR.VP.VolumeD 
	kill ^DHCWMR.VP.VolumeI 
	//病案综合查询
	Kill ^DHCWMR.MQ.Arg 
	Kill ^DHCWMR.MQ.CondConfigD
	Kill ^DHCWMR.MQ.CondConfigI
	Kill ^DHCWMR.MQ.DataMasterD 
	Kill ^DHCWMR.MQ.DataMasterI
	//首页结构化存储1.0
	kill ^DHCWMR.MR.FPErrCodeD
	kill ^DHCWMR.MR.FPErrCodeI
	kill ^DHCWMR.MR.FPRangeD
	kill ^DHCWMR.MR.FPRangeI
	kill ^DHCWMR.MR.FPVersionD
	kill ^DHCWMR.MR.FPVersionI
	kill ^DHCWMR.MR.FrontPageD
	kill ^DHCWMR.MR.FrontPageI

	Quit "OK"
}

/// w ##Class(DHCWMR.Service).KillBaseData()
ClassMethod KillBaseData()
{
	Kill ^DHCWMR.SS.HospitalD
	Kill ^DHCWMR.SS.HospitalI
	Kill ^DHCWMR.SS.LocGroupD
	Kill ^DHCWMR.SS.LocGroupI
	Kill ^DHCWMR.SS.PrintLocD
	Kill ^DHCWMR.SS.PrintLocI
	
	Kill ^DHCWMR.MF.FeeItemI
	Kill ^DHCWMR.MF.FeeItemD
	Quit "OK"
}

}
