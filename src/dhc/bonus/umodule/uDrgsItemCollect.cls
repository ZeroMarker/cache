/// Creator: lxw
/// CreatDate: 2015-06-19
/// Description:Drgs项目数据采集
Class dhc.bonus.umodule.uDrgsItemCollect Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator：lxw
/// CreatDate：2015-06-19
/// Description: 查询符合条件的Drgs项目
/// Table：dhc_bonus_module.DrgsItemCollect
/// Input：parent-父节点;searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.umodule.uDrgsItemCollect).ListRec("","","","","",0,25)
ClassMethod ListRec(data, searchField, searchValue, sortField, sortDir, start, limit) As %String
{
  n (data,searchField,searchValue,sortField,sortDir,start,limit)
  
  s SqlStr="SELECT DrgsItemCollectID,BonusYear,BonusPeriod,BonusUnitCode,BonusUnitName,ItemCode,ItemName,ItemNum,ItemRate,CostRate,CollectDate,State,CheckDate FROM dhc_bonus_module.DrgsItemCollect "
          _" WHERE 1=1 "
         
  s yearmonth= $p(data,"^",1)
  s drgscode = $p(data,"^",2)
 
  i yearmonth '= "" d
  .s years = $E(yearmonth,1,4)
  .s periods= "M"_$E(yearmonth,6,7)
  .s SqlStr = SqlStr_" AND BonusYear='"_years_"' AND BonusPeriod='"_periods_"' "
  
  i drgscode '= "" s SqlStr = SqlStr_" AND ItemCode='"_drgscode_"' "
  
  i sortField'="" d
  .i sortField = "YearMonth" s sortField =" CAST(BonusYear AS INT),CAST(SUBSTRING(BonusPeriod,2) AS INT ) "
  .e  i sortField = "DeptName" s sortField = "BonusUnitName"
  .e  i sortField = "DragName" s sortField = "ItemName"
  .e  i sortField = "NumDiseases" s sortField = "ItemNum"
  .e  i sortField = "CMI" s sortField = "ItemRate"
  .e  i sortField = "CostFactor" s sortField = "CostRate"
  .e  i sortField = "CollectDate" s sortField = "CollectDate"
  .e  i sortField = "State" s sortField = "State"
  .e  i sortField = "CheckDate" s sortField = "CheckDate"
  .e  s sortField = "DrgsItemCollectID"
  .s SqlStr = SqlStr_"ORDER BY "_sortField_" "_sortDir_" "
  
  s result=##class(%Library.ResultSet).%New()
  d result.Prepare(SqlStr)
  d result.Execute()

  s count=0 
  s resultString=""
  s end=start+limit-1
  ;w SqlStr,!
  s json=##class(dhc.bonus.comm.JsonObj).%New()
  s jsonTitle="rowid^YearMonth^DeptName^DrgsName^NumDiseases^CMI^CostFactor^CollectDate^State^CheckDate"
  While(result.Next()){
		
    s rowid= result.Data("DrgsItemCollectID")
	s YearMonth = result.Data("BonusYear")_"年"_$E(result.Data("BonusPeriod"),2,2) _ "月"
	s DeptName = result.Data("BonusUnitName")
	s DrgsName = result.Data("ItemName")
	s NumDiseases = result.Data("ItemNum")
	s CMI = $fn(result.Data("ItemRate"),"",3)
	s CostFactor = $fn(result.Data("CostRate"),"",3)	
	s CollectDate= result.Data("CollectDate")
    s State = result.Data("State")	
    s CheckDate= result.Data("CheckDate")
    
    i State =0 s State="采集"
    e  s State="审核"
    
	i (count>=start)&(count<=end) d
	.s tmp=rowid_"^"_YearMonth_"^"_DeptName_"^"_DrgsName_"^"_NumDiseases_"^"_CMI_"^"_CostFactor_"^"_CollectDate_"^"_State_"^"_CheckDate
	.d json.InsertRowData(tmp)
	s count=count+1
	}
		
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator：lxw
/// CreatDate：2015-06-19
/// Description: 数据审核
/// Table：dhc_bonus_module.DrgsItemCollect
/// Input：要审核的数据ID或所属年月
/// Return：SQL返回值
/// Others:w ##class(dhc.bonus.umodule.uDrgsItemCollect).Check("1")
ClassMethod Check(data) As %String
{
  n (data)
  
  s Type = $p(data,"||",1)
  s Checker=$p(data,"||",2)
  s rtn = 0
  s date = $p($h,",",1)
  i Type = "A" d
  .s yearmonth= $p(data,"||",3)
  .i yearmonth '= "" d
  ..s years = $E(yearmonth,1,4)
  ..s periods= "M"_$E(yearmonth,6,7)
  ..&SQL(UPDATE dhc_bonus_module.DrgsItemCollect SET State=1,CheckMan=:Checker,CheckDate=:date WHERE BonusYear=:years  AND BonusPeriod=:periods)
  ..s rtn =SQLCODE
  i Type = "B" 
  {
   s data = $p(data,"||",3)
   f i=1:1 {
	s rowid = ""
	s rowid = $p(data,"^",i)  
	q:rowid=""
	&SQL(UPDATE dhc_bonus_module.DrgsItemCollect SET State=2,CheckMan=:Checker,CheckDate=:date WHERE DrgsItemCollectID=:rowid)
	i SQLCODE=100 s SQLCODE=0
	i SQLCODE'=0 s rtn =SQLCODE
    } 
  }
 q rtn
}

Storage Default
{
<StreamLocation>^dhc.bonus866B.uDrgsItemCo20B9S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
