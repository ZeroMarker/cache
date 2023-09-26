/// Creator: 刘小伟
/// CreatDate: 2015-04-20
/// Description:科室工作量维护业务类
Class dhc.bonus.umodule.uMainteDepWork Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 科室工作量数据显示
/// w ##class(dhc.bonus.umodule.uMainteDepWork).ListRec("2015年04月^LCFW1^1","","","WorkItem","DESC",0,25)
ClassMethod ListRec(data, searchField, searchValue, sortField, sortDir, start, limit) As %String
{
  n (data,searchField,searchValue,sortField,sortDir,start,limit)
  
  s SqlStr= "SELECT WorkItemCollectID,BonusYear,BonusPeriod,BonusUnitCode,BonusUnitName,ItemName,b.WorkItemTypeID->ItemTypeName WorkItemName,"
           _"CollectDate, CheckMan, CheckDate,ItemNum,a.State"
           _" FROM dhc_bonus_module.WorkItemCollect  a,dhc_bonus_module.BonusWorkItem b"
           _" where a.ItemCode = b.WorkItemCode   "
  s ^zlgmmm=data
  
  s yearmonth= $p(data,"^",1)
  s deptcode = $p(data,"^",2)
  s workitem = $p(data,"^",3)
  i yearmonth '= "" d
  .s years = $E(yearmonth,1,4)
  .s periods= "M"_$E(yearmonth,6,7)
  .s SqlStr = SqlStr_" AND BonusYear = '"_years_"' AND BonusPeriod = '"_periods_"' "
  
  i deptcode '= "" s SqlStr = SqlStr_" AND BonusUnitCode = '"_deptcode_"' "
  i workitem '= "" s SqlStr = SqlStr_" AND a.ItemCode = '"_workitem_"' "
  
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
  k ^zlgtem
  s ^zlgtem=SqlStr
  s result=##class(%Library.ResultSet).%New()
  d result.Prepare(SqlStr)
  d result.Execute()
	
  s count=0
  s resultString=""
  s end=start+limit-1

  s json=##class(dhc.bonus.comm.JsonObj).%New()
  s jsonTitle="rowid^YearMonths^Dept^ProjectClass^WorkItem^Counts^DataState^Checker^CheckDate^CollectDate"
  While(result.Next()){
	//根据核算单元标志判断核算单元是人员还是科室，此处认为flag=3是人员,不是人员的都是科室	
	s UnitCode =result.Data("BonusUnitCode")
	s flag = ##class(dhc.bonus.umodule.uMainteDepWork).GetUnitFlag(UnitCode)
	i flag=3 continue	
		
    s rowid= result.Data("WorkItemCollectID")
	s Year = result.Data("BonusYear")
	s Dept = result.Data("BonusUnitName")
	
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
	s YearMonths =Year_"年"_$E(Period,2,3)_"月" 	
     
	i (count>=start)&(count<=end) d
	.s tmp=rowid_"^"_YearMonths_"^"_Dept_"^"_ProjectClass_"^"_WorkItem_"^"_Counts_"^"_DataState_"^"_Checker_"^"_CheckDate_"^"_CollectDate
	.d json.InsertRowData(tmp)
	s count=count+1
	}
	
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// w ##class(dhc.bonus.umodule.uMainteDepWork).check("B||Demo Group||2015年04月")
/// w ##class(dhc.bonus.umodule.uMainteDepWork).check("A||Demo Group||6^7^8")
ClassMethod check(data) As %String
{
  n (data)
  
  s flag = $p(data,"||",1)
  s checker =$p(data,"||",2)
  s condition=$p(data,"||",3)
  s date = $p($h,",",1)
  /*
  i flag="A" 
  {
	for i=1:1{
	 s rowid = $p(condition,"^",i)
	 q:rowid=""
	 &SQL(UPDATE  dhc_bonus_module.WorkItemCollect SET State =1,CheckDate=:date,CheckMan=:checker WHERE WorkItemCollectID =:rowid)
	}
  }
  */
 i flag="B"{
  s yearmonth=$p(condition,"^",1)
  s unitcode =$p(condition,"^",2)
  i yearmonth '= "" d
  .s years = $E(yearmonth,1,4)
  .s periods= "M"_$E(yearmonth,6,7)
  i unitcode = "" d
  .&SQL(UPDATE  dhc_bonus_module.WorkItemCollect SET State =1,CheckDate=:date,CheckMan=:checker WHERE BonusYear =:years and BonusPeriod=:periods)
  e  d
  .&SQL(UPDATE  dhc_bonus_module.WorkItemCollect SET State =1,CheckDate=:date,CheckMan=:checker WHERE BonusYear =:years and BonusPeriod=:periods and BonusUnitCode=:unitcode)
  }
  q 0
}

/// 通过接口采集数据
/// w ##class(dhc.bonus.umodule.uMainteDepWork).collect("2015年04月^8")
ClassMethod collect(data) As %String
{
  n (data)
  s yearmonth=$p(data,"^",1)
  s Inter =$p(data,"^",2)
  i yearmonth '= "" d
  .s years = $E(yearmonth,1,4)
  .s periods= $E(yearmonth,6,7)	
  s rtn = ##class(dhc.bonus.uinter.uInterMain).InterMain(years,periods,Inter)
  q rtn
}

/// 科室下拉框数据
/// w ##class(dhc.bonus.umodule.uMainteDepWork).GetDept("",0,25)
ClassMethod GetDept(str, start, limit) As %String
{
  n (str,start,limit)
  s SqlStr= "SELECT BonusUnitID, BonusUnitCode, BonusUnitName  FROM dhc_bonus_data.BonusUnit "
           _"where IsValid =1"
  
  i str '= ""  s SqlStr = SqlStr_ "and (BonusUnitName like '%"_str_"%' or BonusUnitCode like '%"_str_"%') "
  s result=##class(%Library.ResultSet).%New()
  d result.Prepare(SqlStr)
  d result.Execute()
	
  s count=0
  s resultString=""
  s end=start+limit-1

  s json=##class(dhc.bonus.comm.JsonObj).%New()
  s jsonTitle="rowid^DeptCode^DeptName"
  While(result.Next()){
		
    s rowid= result.Data("BonusUnitID")
	s DeptCode = result.Data("BonusUnitCode")
	s DeptName = result.Data("BonusUnitName")	
     
	i (count>=start)&(count<=end) d
	.s tmp=rowid_"^"_DeptCode_"^"_DeptName
	.d json.InsertRowData(tmp)
	s count=count+1
	}
		
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// 科室下拉框数据 zlg11
/// w ##class(dhc.bonus.umodule.uMainteDepWork).GetWorkItem("",15,25)
ClassMethod GetWorkItem(str, start, limit) As %String
{
  n (str,start,limit)
  s SqlStr= "SELECT BonusWorkItemID,WorkItemCode,WorkItemName,WorkItemTypeID->ItemTypeName FROM dhc_bonus_module.BonusWorkItem  "
           _"WHERE IsValid=1"
  
  i str '= ""  s SqlStr = SqlStr_ "and (WorkItemName like '%"_str_"%' or WorkItemCode like '%"_str_"%') "
  s SqlStr = SqlStr_ " order by WorkItemTypeID,WorkItemCode"
  s result=##class(%Library.ResultSet).%New()
  d result.Prepare(SqlStr) 
  d result.Execute()
	
  s count=0
  s resultString=""
  s end=start+limit-1

  s json=##class(dhc.bonus.comm.JsonObj).%New()
  s jsonTitle="rowid^WorkItemCode^WorkItemName"
  While(result.Next()){
		
    s rowid= result.Data("BonusWorkItemID")
	s WorkItemCode = result.Data("WorkItemCode")
		
    s ItemTypeName = result.Data("ItemTypeName")
    s WorkItemName =ItemTypeName_"_"_ result.Data("WorkItemName")
     
	i (count>=start)&(count<=end) d
	.s tmp=rowid_"^"_WorkItemCode_"^"_WorkItemName
	.d json.InsertRowData(tmp)
	s count=count+1
	}
		
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// 数据接口下拉框数据
/// w ##class(dhc.bonus.umodule.uMainteDepWork).GetInterf("",0,25)
ClassMethod GetInterf(str, start, limit) As %String
{
  n (str,start,limit)
  s SqlStr= "SELECT InterLocMethod_rowid, InterLocMethod_methodName FROM dhc_bonus_inter.InterLocMethod "
           _"WHERE 1=1"
  
  i str '= ""  s SqlStr = SqlStr_ "and (WorkItemName like '%"_str_"%' or WorkItemCode like '%"_str_"%') "
  s result=##class(%Library.ResultSet).%New()
  d result.Prepare(SqlStr)
  d result.Execute()
	
  s count=0
  s resultString=""
  s end=start+limit-1

  s json=##class(dhc.bonus.comm.JsonObj).%New()
  s jsonTitle="rowid^DataInter"
  While(result.Next()){
		
    s rowid= result.Data("InterLocMethod_rowid")
	s DataInter= result.Data("InterLocMethod_methodName")	
     
	i (count>=start)&(count<=end) d
	.s tmp=rowid_"^"_DataInter
	.d json.InsertRowData(tmp)
	s count=count+1
	}
		
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// 根据核算单元代码获取上级单元名称
/// w ##class(dhc.bonus.umodule.uMainteDepWork).GetUserDept("0701")
ClassMethod GetUserDept(usercode) As %String
{
	n (usercode)
 	; BonusUnitCode ^dhcbsBonusUnitI
    s name = ""
 	s rowid= ""
 	s rowid= $O(^dhcbsBonusUnitI("BonusUnitCode",usercode,""))
 	i rowid '= "" d
 	.s suprowid = ""
 	.s suprowid =$List(^dhcbsBonusUnitD(rowid),6)
 	.i (suprowid '="")&(suprowid '=0) d
 	..s name = $List(^dhcbsBonusUnitD(suprowid),3)
 	q name
}

/// 根据核算单元代码获核算单元类型
/// w ##class(dhc.bonus.umodule.uMainteDepWork).GetUnitFlag("0701")
ClassMethod GetUnitFlag(usercode) As %String
{
	n (usercode)
 	s unitflag = ""
    s name = ""
 	s rowid= ""
 	s rowid= $O(^dhcbsBonusUnitI("BonusUnitCode",usercode,""))
 	i rowid '= "" d
 	.s unitflag = ""
 	.s unitflag =$List(^dhcbsBonusUnitD(rowid),5)
 	q unitflag
}

Storage Default
{
<StreamLocation>^dhc.bonus.u866B.uMainteDepWorkS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
