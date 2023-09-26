/// Creator: 刘小伟
/// CreatDate: 2015-04-20
/// Description:3.2.12	工作量单项奖计算
Class dhc.bonus.umodule.uCalculateWork Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 2016-01^^,,,,,0,25
/// w ##class(dhc.bonus.umodule.uCalculateWork).ListRec("2016-01^^","","","","",0,25)
ClassMethod ListRec(data, searchField, searchValue, sortField, sortDir, start, limit) As %String
{
  n (data,searchField,searchValue,sortField,sortDir,start,limit)
  s ^zlgtmp=data_","_ searchField_","_ searchValue_","_ sortField_","_ sortDir_","_ start_","_ limit
  s yearmonth= $p(data,"^",1)
  s BonusUnitID = $p(data,"^",2)
  s workitem = $p(data,"^",3)
 
  s years = $E(yearmonth,1,4)
  s periods= "M"_$p(yearmonth,"-",2)
  s YearMonths =years_"-"_$p(yearmonth,"-",2)
  
   s SqlStr="SELECT %ID Rowid,BonusYear , BonusPeriod , BonusUnitID->BonusUnitName, BonusWorkItemID->WorkItemName, ItemNum, ItemPrice"
	_", CalDate , State, CheckMan , CheckDate , DataTypeID->ItemTypeName FROM dhc_bonus_module.WorkItemResult "
	_" WHERE BonusYear = '"_years_"' AND BonusPeriod ='"_periods_"' "
   
  i BonusUnitID '= "" s SqlStr = SqlStr_" AND BonusUnitID = '"_BonusUnitID_"' "
  i workitem '= "" s SqlStr = SqlStr_" AND BonusWorkItemID = "_workitem_" "
  
  i sortField'="" d
  .i sortField = "ProjectClass" s sortField = "DataTypeID->ItemTypeName"
  .e  i sortField = "Year" s sortField = "BonusYear"
  .e  i sortField = "Dept" s sortField = "BonusUnitID->BonusUnitName"
  .e  i sortField = "Period" s sortField = "BonusPeriod"
  .e  i sortField = "Counts" s sortField = "ItemNum"
  .e  i sortField = "Checker" s sortField = "CheckMan"
  .e  i sortField = "WorkItem" s sortField = "WorkItemName"
  .e  i sortField = "DataState" s sortField = "State"
  .e  i sortField = "CheckDate" s sortField = "CheckDate"
  .e  i sortField = "CollectDate" s sortField = "CalDate"
  .e  s sortField = "WorkItemResultID"
  .s SqlStr = SqlStr_"ORDER BY "_sortField_" "_sortDir_" "
  
  s ^zlgtm=SqlStr
  s result=##class(%Library.ResultSet).%New()
  d result.Prepare(SqlStr)
  d result.Execute()
	
  s count=0
  s resultString=""
  s end=start+limit-1

  s json=##class(dhc.bonus.comm.JsonObj).%New()
  s jsonTitle="rowid^YearMonths^Dept^ProjectClass^WorkItem^Counts^Price^Amount^DataState^Checker^CheckDate^CollectDate"
  While(result.Next()){
		
    s rowid= result.Data("Rowid")
	s Year = result.Data("BonusYear")
	s Dept = result.Data("BonusUnitName")
	s Price= result.Data("ItemPrice") 
	 
	s Period = result.Data("BonusPeriod")
	s Counts = result.Data("ItemNum")
	s Checker= result.Data("CheckMan")
	
	s WorkItem = result.Data("WorkItemName")
	s DataState= result.Data("State")	
	s CheckDate= result.Data("CheckDate")
	s Amount = Counts*Price
	;i CheckDate '="" s CheckDate= $zd(CheckDate,3)
	
	
	s CollectDate = result.Data("CalDate")
	s ProjectClass= result.Data("ItemTypeName")
	
	i DataState = 0 s DataState="未审核"
	e  i DataState = 1 s DataState="审核"
	e  s DataState="计算" 
	//s YearMonths =Year_"年"_$E(Period,2,)_"月" 	
     
	i (count>=start)&(count<=end) d
	.s tmp=rowid_"^"_YearMonths_"^"_Dept_"^"_ProjectClass_"^"_WorkItem_"^"_Counts_"^"_Price_"^"_Amount_"^"_DataState_"^"_Checker_"^"_CheckDate_"^"_CollectDate
	.d json.InsertRowData(tmp)
	s count=count+1
	}
		
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// 审核数据并汇总结果增加到指标采集表
/// w ##class(dhc.bonus.umodule.uCalculateWork).check("demo||2016-01")
ClassMethod check(data) As %String
{
  n (data)
  k ^zlg11
  s ^zlg11=data
  
  s checker =$p(data,"||",1)
  s condition=$p(data,"||",2)
  s date=$ZDate($P($H,",",1),3)_" "_$ZTime($P($H,",",2))
  s yearmonth=$p(condition,"^",1)
  s unitcode =$p(condition,"^",2)
  i yearmonth '= "" d
  .s years = $E(yearmonth,1,4)
  .s periods= "M"_$E(yearmonth,6,7) 
  
  ;w years_","_periods_","_date_","_checker,!
  
  //审核数据
  &SQL(UPDATE dhc_bonus_module.WorkItemResult SET State =1,CheckDate=:date,CheckMan=:checker WHERE BonusYear =:years and BonusPeriod=:periods) 
  i SQLCODE=100 s SQLCODE =0
  //添加之前删除已有同类数据
  &SQL(DELETE FROM dhc_bonus_data.BonusTargetCollect WHERE BonusYear=:years  AND BonusPeriod=:periods  AND DataSource=9 )
  i SQLCODE=100 s SQLCODE =0
  //添加数据
  
  &SQL(INSERT INTO dhc_bonus_data.BonusTargetCollect (BonusTargetID,BonusUnitID,InterLocMethodID,BonusYear,BonusPeriod,DataSource,TargetValue,UpdateDate)
  SELECT b.BonusTargetID,d.BonusUnitID,d.InterLocMethodRowid,d.BonusYear,d.BonusPeriod,9 
  ,sum(d.ItemNum*d.ItemPrice),:date
   FROM   dhc_bonus_module.WorkItemTargetMap a JOIN 
  dhc_bonus_data.bonustarget b ON a.BonusTargetID=b.BonusTargetID  
  JOIN dhc_bonus_module.BonusWorkItem c ON a.BonusWorkItemID=c.BonusWorkItemID  
  JOIN dhc_bonus_module.WorkItemResult d on c.BonusWorkItemID=d.BonusWorkItemID  
  WHERE 1=1 AND d.BonusYear=:years  AND d.BonusPeriod=:periods 
  GROUP BY b.BonusTargetID,d.BonusUnitID )
  
  i SQLCODE=100 s SQLCODE =0
  q SQLCODE
}

/// 计算
/// w ##class(dhc.bonus.umodule.uCalculateWork).Calculat("2015年04月^^^")
ClassMethod Calculat(data) As %String
{
  n (data)
  s ^zmb=data
  s yearmonth = $p(data,"^",1)
  i yearmonth '= "" d
  .s years = $E(yearmonth,1,4)
  .s periods= "M"_$E(yearmonth,6,7)
  s Inter= $p(data,"^",2)
  s dept = $p(data,"^",3)
  s workitem= $p(data,"^",4)
  
  &SQL(DELETE FROM dhc_bonus_module.WorkItemResult where BonusYear=:years and BonusPeriod=:periods)

  
 &SQL( INSERT INTO dhc_bonus_module.WorkItemResult
(InterLocMethodRowid,BonusYear ,BonusPeriod ,BonusUnitID,BonusWorkItemID ,ItemNum ,ItemPrice ,CalDate ,State ,	DataTypeID)
SELECT  InterLocMethod_rowid,BonusYear ,BonusPeriod ,c.BonusUnitID,b.BonusWorkItemID ,a.ItemNum ,b.ItemPrice 
,getdate() CalDate ,0 State ,b.WorkItemTypeID DataTypeID
FROM dhc_bonus_module.WorkItemCollect a,dhc_bonus_module.BonusWorkItem b,dhc_bonus_data.bonusUnit c 
WHERE a.ItemCode=b.WorkItemCode AND a.BonusUnitCode =c.BonusUnitCode  AND b.IsValid=1
and BonusYear=:years AND BonusPeriod=:periods)

  i SQLCODE=100 s SQLCODE =0
 Q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.bonus.u866B.uCalculateWorkS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
