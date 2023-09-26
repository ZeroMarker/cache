/// Creator: wjt
/// CreatDate: 2014-04-23
/// Description: 
Class dhc.bonus.report.uBonusUnit Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

Query GetUnit() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
    select %ID, BonusUnitName From dhc_bonus_data.BonusUnit WHERE IsValid =1 AND LastStage=0 AND UnitFlag=1
}

/// 主报表
/// 科室工作量单项奖月报
ClassMethod GetBonusUnitExecute(ByRef qHandle As %Binary, itemid As %Binary, ym As %Binary, code As %Binary) As %Status
{
	
	n (qHandle,itemid,ym,code)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
    
    s ym1=$p(ym,"-",1)_$p(ym,"-",2)
    
	s strSql="select CAST(a.BonusYear||substring(a.BonusPeriod,2,3) AS INT) as yearmonth,b.BonusUnitName,d.WorkItemName,a.ItemNum,a.ItemPrice from dhc_bonus_module.WorkItemResult a,dhc_bonus_data.BonusUnit b,dhc_bonus_data.BonusEmployeeUnit c"
             _",dhc_bonus_module.BonusWorkItem d Where a.BonusUnitCode = b.BonusUnitCode and b.BonusUnitID='"_itemid_"' and  CAST(a.BonusYear||substring(a.BonusPeriod,2,3) AS INT)='"_ym1_"'"
             _" And  a.DataType=1 And b.%ID=c.BonusUnitID AND d.BonusWorkItemID=a.BonusWorkItemID  and c.BonusEmployeeID->EmployeeCode='"_code_"'"
            

    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(strSql)
	d result.Execute()
		
 While(result.Next()){
	  
	  s bonusyear=result.Data("yearmonth")
	  s name=result.Data("BonusUnitName")
	  s workitem=result.Data("WorkItemName")
	  s itemnum=result.Data("ItemNum")
	  s price=result.Data("ItemPrice")
	  s totalprice=itemnum*price
     
	 d OutputRow3
	  
	} 
   	  
  	q $$$OK
OutputRow3
  	s Data=$lb(bonusyear,name,workitem,itemnum,price,totalprice)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
}

ClassMethod GetBonusUnitFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBonusAnalysisExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetBonusUnitClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBonusAnalysisExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:wjt
/// CreatDate:2014-04-23
/// Description:查询报表数据记录
/// Table: 
/// others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uBonusUnit","GetBonusUnit","47","201403","192") 
Query GetBonusUnit(itemid As %Binary, ym As %Binary, code As %Binary) As %Query(ROWSPEC = "bonusyear:%String,name:%String,workitem:%String,itemnum:%String,price:%String,totalprice:%String") [ SqlProc ]
{
}

Storage Default
{
<StreamLocation>^dhc.bonus.report.uBonusUnitS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
