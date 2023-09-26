/// Creator: 刘小伟
/// CreatDate: 2015-04-20
/// Description:人员工作量维护业务类
Class dhc.bonus.umodule.uMainteUserWork Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 科室工作量数据显示
/// w ##class(dhc.bonus.umodule.uMainteUserWork).ListRec("2015年04月^LCFW1^1","","","WorkItem","DESC",0,25)
ClassMethod ListRec(data, searchField, searchValue, sortField, sortDir, start, limit) As %String
{
  n (data,searchField,searchValue,sortField,sortDir,start,limit)
  
  s SqlStr= "SELECT WorkItemCollectID,BonusYear,BonusPeriod,BonusUnitCode,BonusUnitName,ItemName,BonusSubItemID->WorkItemName,"
           _"CollectDate, CheckMan, CheckDate,ItemNum,State FROM dhc_bonus_module.WorkItemCollect where 1=1 "
  
  s yearmonth= $p(data,"^",1)
  s deptname = $p(data,"^",2)
  s workitem = $p(data,"^",3)
  i yearmonth '= "" d
  .s years = $E(yearmonth,1,4)
  .s periods= "M"_$E(yearmonth,6,7)
  .s SqlStr = SqlStr_" AND BonusYear = "_years_" AND BonusPeriod = '"_periods_"' "
 
  i workitem '= "" s SqlStr = SqlStr_" AND BonusSubItemID = "_workitem_" "
  
  i sortField'="" d
  .i sortField = "ProjectClass" s sortField = "WorkItemName"
  .e  i sortField = "Year" s sortField = "BonusYear"
  .e  i sortField = "Dept" s sortField = "BonusUnitName"
  .e  i sortField = "Period" s sortField = "BonusPeriod"
  .e  i sortField = "Counts" s sortField = "ItemNum"
  .e  i sortField = "Checker" s sortField = "CheckMan"
  .e  i sortField = "WorkItem" s sortField = "ItemName"
  .e  i sortField = "DataState" s sortField = "State"
  .e  i sortField = "CheckDate" s sortField = "CheckDate"
  .e  i sortField = "CollectDate" s sortField = "CollectDate"
  .e  s sortField = "WorkItemCollectID"
  .s SqlStr = SqlStr_"ORDER BY "_sortField_" "_sortDir_" "
  
  s result=##class(%Library.ResultSet).%New()
  d result.Prepare(SqlStr)
  d result.Execute()
	
  s count=0
  s resultString=""
  s end=start+limit-1

  s json=##class(dhc.bonus.comm.JsonObj).%New()
  s jsonTitle="rowid^YearMonths^Dept^ProjectClass^EmplyName^WorkItem^Counts^DataState^Checker^CheckDate^CollectDate"
  While(result.Next()){
	s UnitCode =result.Data("BonusUnitCode")
	//根据核算单元标志判断核算单元是人员还是科室，此处认为flag=3是人员
	s flag = ##class(dhc.bonus.umodule.uMainteDepWork).GetUnitFlag(UnitCode)
	i flag'=3 continue	
	s Dept = ##class(dhc.bonus.umodule.uMainteDepWork).GetUserDept(UnitCode)
	//处理界面上按科室查询
	i deptname '="" d
	.i '(Dept=deptname) continue
	
    s rowid= result.Data("WorkItemCollectID")
	s Year = result.Data("BonusYear")
	s EmplyName= result.Data("BonusUnitName")

	s Period = result.Data("BonusPeriod")
	s Counts = result.Data("ItemNum")
	s Checker= result.Data("CheckMan")
	
	s WorkItem = result.Data("ItemName")
	s DataState= result.Data("State")	
	s CheckDate= result.Data("CheckDate")
	i CheckDate '="" s CheckDate= $zd(CheckDate,3)
	
	s CollectDate = result.Data("CollectDate")
	s ProjectClass= result.Data("WorkItemName")
	
	i DataState = 0 s DataState="采集"
	e  i DataState = 1 s DataState="审核"
	e  s DataState="计算" 
	s YearMonths =Year_"年"_$E(Period,2,)_"月" 	
     
	i (count>=start)&(count<=end) d
	.s tmp=rowid_"^"_YearMonths_"^"_Dept_"^"_ProjectClass_"^"_EmplyName_"^"_WorkItem_"^"_Counts_"^"_DataState_"^"_Checker_"^"_CheckDate_"^"_CollectDate
	.d json.InsertRowData(tmp)
	s count=count+1
	}	
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

Storage Default
{
<StreamLocation>^dhc.bonus866B.uMainteUser8E0AS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
