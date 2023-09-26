Class DHCWL.MKPIService.ExcCodeService Extends %RegisteredObject [ Not ProcedureBlock ]
{

ClassMethod Insert(kpi, kpiTaskSecId, status, kpiTaskSection, exeCodeId) As %String
{
	n (kpi,kpiTaskSecId,status,kpiTaskSection,exeCodeId)
	q:$d(^DHCWL.MKPI.CreatDataTaskI("SectionKPI",kpiTaskSecId,kpi)) "该指标任务已经存在！"
	k PLIST
	s PLIST(2)=kpi
	s PLIST(3)=kpiTaskSecId
	s PLIST(5)=status
	s PLIST(6)=kpiTaskSection
	s PLIST(7)=exeCodeId
	&sql(insert into DHCWL_MKPI.DHCWLCreatDataTask values PLIST())
	q $g(SQLCODE)
}

ClassMethod Update(kpi, kpiTaskSecId, status, kpiTaskSection, exeCodeId) As %String
{
	n (kpi,kpiTaskSecId,status,kpiTaskSection,exeCodeId)
	q:'$d(^DHCWL.MKPI.CreatDataTaskI("SectionKPI",kpiTaskSecId,kpi)) "该指标任务不存在！"
	s activeFlag=$o(^DHCWL.MKPI.CreatDataTaskI("SectionKPI",kpiTaskSecId,kpi,""))
	s id=$o(^DHCWL.MKPI.CreatDataTaskI("SectionKPI",kpiTaskSecId,kpi,activeFlag,""))
	&sql(update DHCWL_MKPI.DHCWLCreatDataTask SET DTask_KPI_DR=:kpi,DTask_Section_DR=:kpiTaskSecId,DTask_ActiveFlag=:status,DTask_MonthExcuteCode=:kpiTaskSection,DTask_ExcuteCode_DR=:exeCodeId where ID=:id)
	q $g(SQLCODE)
}

/// w ##class(DHCWL.MKPIService.ExcCodeService).InsertExeCode(""ExeCodeType=TAS&ExeCodeWrite=CreatYesterdayData^DHCWLAutoCreatMKPIData&ExeCodeCall=s monthId=$$CreatYesterdayData^DHCWLAutoCreatMKPIData()&ExeCodeVersion=1.0&ExcCodeApplicable=指标日区间任务，返回昨天的日期区间&ExcCodeDescription=指标日区间任务，返回昨天的日期区间")
ClassMethod InsertExeCode(props, oprate = "I") As %String
{
	n (props,oprate)
	q ##class(DHCWL.util.GetSetService).SetPropertyByStr("DHCWL.MKPI.ExecuteCode",props,,oprate)
}

// d ##class(DHCWL.MKPIService.ExcCodeService).InstalledDefaultExcode()

ClassMethod InstalledDefaultExcode()
{
	s writeCode="CreatYesterdayData^DHCWLAutoCreatMKPIData"
	s appAli="指标日区间任务，返回昨天的日期区间"
	s pros="ExeCodeType=TAS&ExeCodeWrite="_writeCode_"&ExeCodeCall=s monthId=$$"_writeCode_"()&ExeCodeVersion=1.0&ExcCodeApplicable="_appAli_"&ExcCodeDescription="_appAli
	s pros=pros_"&ExcCodeSubType=D&ExcCodeDefaultFlag=Y"
	if (('$d(^DHCWL.MKPI.ExecuteCodeI("ExcCodeTypeI","TAS",""_(writeCode))))){
		d ..InsertExeCode(pros,"I")
	}
	s writeCode="CreatLastMonDataAt1^DHCWLAutoCreatMKPIData"
	s appAli="指标月区间任务，每月的1号返回上月的月区间日期"
	s pros="ExeCodeType=TAS&ExeCodeWrite="_writeCode_"&ExeCodeCall=s monthId=$$"_writeCode_"()&ExeCodeVersion=1.0&ExcCodeApplicable="_appAli_"&ExcCodeDescription="_appAli
	s pros=pros_"&ExcCodeSubType=M&ExcCodeDefaultFlag=Y"
	if (('$d(^DHCWL.MKPI.ExecuteCodeI("ExcCodeTypeI","TAS",""_(writeCode))))){
		d ..InsertExeCode(pros,"I")
	}
	s writeCode="CreatLastQuaDateAt1^DHCWLAutoCreatMKPIData"
	s appAli="指标季区间任务，每季的1号，返回上一季度的区间日期"
	s pros="ExeCodeType=TAS&ExeCodeWrite="_writeCode_"&ExeCodeCall=s monthId=$$"_writeCode_"()&ExeCodeVersion=1.0&ExcCodeApplicable="_appAli_"&ExcCodeDescription="_appAli
	s pros=pros_"&ExcCodeSubType=Q&ExcCodeDefaultFlag=Y"
	if (('$d(^DHCWL.MKPI.ExecuteCodeI("ExcCodeTypeI","TAS",""_(writeCode))))){
		d ..InsertExeCode(pros,"I")
	}
	s writeCode="CreatLastYearDataAt0101^DHCWLAutoCreatMKPIData"
	s appAli="指标年区间任务，每年的1月1号返回上年的区间日期"
	s pros="ExeCodeType=TAS&ExeCodeWrite="_writeCode_"&ExeCodeCall=s monthId=$$"_writeCode_"()&ExeCodeVersion=1.0&ExcCodeApplicable="_appAli_"&ExcCodeDescription="_appAli
	s pros=pros_"&ExcCodeSubType=Y&ExcCodeDefaultFlag=Y"
	if (('$d(^DHCWL.MKPI.ExecuteCodeI("ExcCodeTypeI","TAS",""_(writeCode))))){
		d ..InsertExeCode(pros,"I")
	}
	s writeCode="CreatLastMonDataAt2^DHCWLAutoCreatMKPIData"
	s appAli="指标月任务执行代码,每月2号运行返回上月的区间Id"
	s pros="ExeCodeType=TAS&ExeCodeWrite="_writeCode_"&ExeCodeCall=s monthId=$$"_writeCode_"()&ExeCodeVersion=1.0&ExcCodeApplicable="_appAli_"&ExcCodeDescription="_appAli
	s pros=pros_"&ExcCodeSubType=M"
	if (('$d(^DHCWL.MKPI.ExecuteCodeI("ExcCodeTypeI","TAS",""_(writeCode))))){
		d ..InsertExeCode(pros,"I")
	}
	s writeCode="CreatLastMonDataAt3^DHCWLAutoCreatMKPIData"
	s appAli="指标月任务执行代码,每月3号运行返回上月的区间Id"
	s pros="ExeCodeType=TAS&ExeCodeWrite="_writeCode_"&ExeCodeCall=s monthId=$$"_writeCode_"()&ExeCodeVersion=1.0&ExcCodeApplicable="_appAli_"&ExcCodeDescription="_appAli
	s pros=pros_"&ExcCodeSubType=M"
	if (('$d(^DHCWL.MKPI.ExecuteCodeI("ExcCodeTypeI","TAS",""_(writeCode))))){
		d ..InsertExeCode(pros,"I")
	}
	s writeCode="CreatLastMonDataAt31^DHCWLAutoCreatMKPIData"
	s appAli="指标月任务执行代码,每月31号运行返回上月的区间Id"
	s pros="ExeCodeType=TAS&ExeCodeWrite="_writeCode_"&ExeCodeCall=s monthId=$$"_writeCode_"()&ExeCodeVersion=1.0&ExcCodeApplicable="_appAli_"&ExcCodeDescription="_appAli
	s pros=pros_"&ExcCodeSubType=M"
	if (('$d(^DHCWL.MKPI.ExecuteCodeI("ExcCodeTypeI","TAS",""_(writeCode))))){
		d ..InsertExeCode(pros,"I")
	}
	s writeCode="CreatLastYearDataAt0102^DHCWLAutoCreatMKPIData"
	s appAli="指标年任务执行代码,每年1月2号运行返回去年的区间Id"
	s pros="ExeCodeType=TAS&ExeCodeWrite="_writeCode_"&ExeCodeCall=s monthId=$$"_writeCode_"()&ExeCodeVersion=1.0&ExcCodeApplicable="_appAli_"&ExcCodeDescription="_appAli
	s pros=pros_"&ExcCodeSubType=Y"
	if (('$d(^DHCWL.MKPI.ExecuteCodeI("ExcCodeTypeI","TAS",""_(writeCode))))){
		d ..InsertExeCode(pros,"I")
	}
}

}
