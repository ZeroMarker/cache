Class DHCWL.MKPIIO.CreatDataTaskSevice Extends DHCWL.MKPIIO.Service [ Not ProcedureBlock ]
{

/// d ##class(DHCWL.MKPIIO.CreatDataTaskSevice).FindObjectById(16)
ClassMethod FindObjectById(id) As %List
{
	n (id)
	q:id="" ""
	s list=##Class(%Library.ListOfObjects).%New() ;.ListOfPersistentChildObjects).%New()
	s activeId="" f  s activeId=$o(^DHCWL.MKPI.CreatDataTaskI("KPI",id,activeId)) q:activeId=""  d
	.s taskId="" f  s taskId=$o(^DHCWL.MKPI.CreatDataTaskI("KPI",id,activeId,taskId)) q:taskId=""  d
	..d list.Insert(##class(DHCWL.MKPI.CreatDataTask).%OpenId(taskId))
	q list
}

}
