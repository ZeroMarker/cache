Class web.CDSS.Demo.DocuTasksDetail Extends %RegisteredObject
{

/// Creator：赵文伟
/// CreatDate: 2022-09-13
/// Description: 获取触发结果，触发率[8/10]
/// Table： WDT.CDSS.DocTasksDetailDetail
/// Other: w ##class(web.CDSS.Demo.DocuTasksDetail).GetTriggerRate("11")
ClassMethod GetTriggerRate(TaskDR) As %String
{
	s HitNum=0
	s Total=0 
	&sql(SELECT COUNT(*) INTO:Total FROM WDT_CDSS.DocTasksDetail WHERE TaskDR=:TaskDR)

	&sql(SELECT COUNT(*) INTO:HitNum FROM WDT_CDSS.DocTasksDetail WHERE TaskDR=:TaskDR AND HitFlag="是")
	
	q HitNum_"/"_Total
}

/// Creator：赵文伟
/// CreatDate: 2022-09-20
/// Description：计算触发率[小数]
/// Table: WDT.CDSS.DocTasksDetailDetail
/// Input： TaskDR
/// Return：rate
/// Other: w ##class(web.CDSS.Demo.DocuTasksDetail).CountTriggerRate(11)
ClassMethod CountTriggerRate(TaskDR)
{
	s result=0
	s HitNum=0
	s Total=0 
	&sql(SELECT COUNT(*) INTO:Total FROM WDT_CDSS.DocTasksDetail WHERE TaskDR=:TaskDR)

	&sql(SELECT COUNT(*) INTO:HitNum FROM WDT_CDSS.DocTasksDetail WHERE TaskDR=:TaskDR AND HitFlag="是")
	s:(Total'=0) result=HitNum/Total
	q result
}

/// Creator：赵文伟
/// CreatDate: 2022-09-20
/// Description：查询任务集详情
/// Table： WDT.CDSS.DocTasksDetailDetail
/// Input：rowid, desc
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.Demo.DocuTasksDetail","GetList","","","11")
Query GetList(rowid As %String, desc As %String, taskDR As %String) As %Query(ROWSPEC = "RowId,TaskDR,SearchFields,TargetGuide,HitFlag")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, desc As %String, taskDR As %String) As %Status
{
	
 s repid=$I(^CacheTemp)
 if $g(ind)="" s ind=1
 if (rowid'="") //根据rowid返回该条记录
 {
	s RowId=rowid
	s TaskDR = $lg($g(^WDT.CDSS.DocTasksDetailD(RowId)),2) 		//任务集DR
	s SearchFields = $lg($g(^WDT.CDSS.DocTasksDetailD(RowId)),3) //检索字段
	s TargetGuide = $lg($g(^WDT.CDSS.DocTasksDetailD(RowId)),4) 	//目标指南
	s HitFlag = $lg($g(^WDT.CDSS.DocTasksDetailD(RowId)),5) 		//目标指南是否推出
	d OutputRowCmb
 }
 else
 {
	
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	if (taskDR'=""){
		s RowId=""
		for{  
			s RowId=$o(^WDT.CDSS.DocTasksDetailI("TaskIndex",taskDR,RowId)) q:RowId=""  
			s TaskDR = $lg($g(^WDT.CDSS.DocTasksDetailD(RowId)),2) 		//任务集DR
			s SearchFields = $lg($g(^WDT.CDSS.DocTasksDetailD(RowId)),3) //检索字段
			s TargetGuide = $lg($g(^WDT.CDSS.DocTasksDetailD(RowId)),4) 	//目标指南
			s HitFlag = $lg($g(^WDT.CDSS.DocTasksDetailD(RowId)),5) 		//目标指南是否推出
			
			if ($ZCONVERT(SearchFields,"U")[desc) {
				d OutputRowCmb
			}
		}
	}
	
 }
 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb
    set Data=$lb(RowId,TaskDR,SearchFields,TargetGuide,HitFlag)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
