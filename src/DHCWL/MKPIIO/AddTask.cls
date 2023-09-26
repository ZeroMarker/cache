Class DHCWL.MKPIIO.AddTask Extends %RegisteredObject
{

ClassMethod AddDataTask(kpiName, sectionName, excute, active = "N", monthExe)
{
	s task=##class(DHCWL.MKPI.CreatDataTask).%New()
	s task.DTaskKPIDR=##class(DHCWL.MKPIService.ConfigService).GetKPIByDes(kpiName)
	s task.DTaskSectionDR=##class(DHCWL.MKPI.Section).%OpenId($o(^DHCWL.MKPI.Section("SecName",sectionName,"")))
	s task.DTaskExcuteCode=excute
	s task.DTaskMonthExcuteCode=monthExe
	s task.DTaskActiveFlag=active
	q task.%Save()
}

}
