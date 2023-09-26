Class web.DHCBillKPIOrder Extends %RegisteredObject [ LegacyInstanceContext ]
{

/// Creator: wangjian
/// CreatDate: 2017-08-03
/// Description: 根据任务类型执行此任务类型下的有效指标
/// Input:  Args(1) 任务类型Code   自动任务 门诊收费 住院收费   1
/// 	  	固定入参：StDate, StTime, EndDate, EndTime, HospId 2-6
/// 		自动任务: ExpStr 7
/// 		门诊住院结算：UserId, HISRowId 7-8
/// Debug: w ##class(web.DHCBillKPIOrder).KPIExecByTaskType("")
ClassMethod KPIExecByTaskType(Args...) As %String
{
	//01 自动任务 02 门诊结算 03 住院结算
	set TaskCode=$g(Args(1))
	set TaskCode=$zcvt(TaskCode,"U")
	set TaskTypeId=$o(^DHCBILLKPITASKTYPEi(0,"CODE",TaskCode,""))
	quit:(TaskTypeId="") 0
	
	set Rtn=0
	set ParCount=$zutil(141)
	if (ParCount=6) {
		set Rtn=..CallKPIClass6(TaskTypeId, $g(Args(2)), $g(Args(3)), $g(Args(4)), $g(Args(5)), $g(Args(6)))
	}elseif (ParCount=7) {
		set Rtn=..CallKPIClass7(TaskTypeId, $g(Args(2)), $g(Args(3)), $g(Args(4)), $g(Args(5)), $g(Args(6)), $g(Args(7)))
	}elseif (ParCount=8) {
		set Rtn=..CallKPIClass8(TaskTypeId, $g(Args(2)), $g(Args(3)), $g(Args(4)), $g(Args(5)), $g(Args(6)), $g(Args(7)), $g(Args(8)))
	}else {
	}
	
	quit Rtn
}

ClassMethod CallKPIClass6(TaskTypeId, StDate, StTime, EndDate, EndTime, HospId)
{
	set CallRtn=0
	set KPIRowID=0
	while($o(^DHCBILLKPISETTING(0,"TaskType",TaskTypeId,KPIRowID))&&(CallRtn=0)) {
		set KPIRowID=$o(^DHCBILLKPISETTING(0,"TaskType",TaskTypeId,KPIRowID))
		set KPIData=$g(^DHCBILLKPISETTING(KPIRowID))
		set ActiveFlag=$p(KPIData,"^",12)
		continue:(ActiveFlag'="Y")
		set ShowFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("Bill_Com_KPI", KPIRowID, HospId)
		continue:(ShowFlag="N")
		set ClassName=$p(KPIData,"^",6)
		set MethodName=$p(KPIData,"^",7)
		set CallRtn=$classmethod(ClassName, MethodName, StDate, StTime, EndDate, EndTime, HospId)
	}
	
	quit CallRtn
}

ClassMethod CallKPIClass7(TaskTypeId, StDate, StTime, EndDate, EndTime, HospId, ExpStr)
{
	set CallRtn=0
	set KPIRowID=0
	while($o(^DHCBILLKPISETTING(0,"TaskType",TaskTypeId,KPIRowID))&&(CallRtn=0)) {
		set KPIRowID=$o(^DHCBILLKPISETTING(0,"TaskType",TaskTypeId,KPIRowID))
		set KPIData=$g(^DHCBILLKPISETTING(KPIRowID))
		set ActiveFlag=$p(KPIData,"^",12)
		continue:(ActiveFlag'="Y")
		set ShowFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("Bill_Com_KPI", KPIRowID, HospId)
		continue:(ShowFlag="N")
		set ClassName=$p(KPIData,"^",6)
		set MethodName=$p(KPIData,"^",7)
		set CallRtn=$classmethod(ClassName, MethodName, StDate, StTime, EndDate, EndTime, HospId, ExpStr)
	}
	
	quit CallRtn
}

ClassMethod CallKPIClass8(TaskTypeId, StDate, StTime, EndDate, EndTime, HospId, UserId, HISRowId)
{
	set CallRtn=0
	set KPIRowID=0
	while($o(^DHCBILLKPISETTING(0,"TaskType",TaskTypeId,KPIRowID))&&(CallRtn=0)) {
		set KPIRowID=$o(^DHCBILLKPISETTING(0,"TaskType",TaskTypeId,KPIRowID))
		set KPIData=$g(^DHCBILLKPISETTING(KPIRowID))
		set ActiveFlag=$p(KPIData,"^",12)
		continue:(ActiveFlag'="Y")
		set ShowFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("Bill_Com_KPI", KPIRowID, HospId)
		continue:(ShowFlag="N")
		set ClassName=$p(KPIData,"^",6)
		set MethodName=$p(KPIData,"^",7)
		set CallRtn=$classmethod(ClassName, MethodName, StDate, StTime, EndDate, EndTime, HospId, UserId, HISRowId)
	}
	
	quit CallRtn
}

}
