/// Creator: wjt
/// CreatDate: 2014-04-23
/// Description: 
Class dhc.bonus.report.uBonusWorkItemUnit Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

Query GetWorkItem() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
    select %ID, WorkItemName From  dhc_bonus_module.BonusWorkItem
}

/// 主报表
/// 全院科室工作量单项奖排名
ClassMethod GetWorkItemUnitExecute(ByRef qHandle As %Binary, workitemid As %Binary, ymstart As %Binary, ymend As %Binary) As %Status
{
	
	n (qHandle,workitemid,ymstart,ymend)
	
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
    s stdate=$p(ymstart,"-",1)_$p(ymstart,"-",2)
    s eddate=$p(ymend,"-",1)_$p(ymend,"-",2)
  
	s strSql="SELECT b.BonusUnitName,a.ItemNum,a.ItemPrice,c.WorkItemName FROM dhc_bonus_module.WorkItemResult a,dhc_bonus_data.BonusUnit b,dhc_bonus_module.BonusWorkItem c WHERE a.BonusUnitID = b.BonusUnitCode" 
	         _" and c.BonusWorkItemID='"_workitemid_"' And a.BonusWorkItemID=c.BonusWorkItemID and a.DataTypeID=1 AND CAST(a.BonusYear||substring(a.BonusPeriod,2,3) AS INT) BETWEEN '"_stdate_"' AND '"_eddate_"' order by a.ItemPrice desc"
	
	k ^temp1
	s ^temp1=strSql
	;w strSql,!
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(strSql)
	d result.Execute()
	
 While(result.Next()){
	  
	  s deptname=result.Data("BonusUnitName")
	  s num=result.Data("ItemNum")
	  s price=result.Data("ItemPrice")
      s workitem=result.Data("WorkItemName")
      s totalprice=num*price
    
	 d OutputRow3
	  
	} 
   	  
  	q $$$OK
OutputRow3
   
  	s Data=$lb(deptname,num,price,workitem,totalprice)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
}

ClassMethod GetWorkItemUnitFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBonusAnalysisExecute ]
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

ClassMethod GetWorkItemUnitClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBonusAnalysisExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:wjt
/// CreatDate:2014-04-23
/// Description:查询报表数据记录
/// Table: 
/// others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uBonusWorkItemUnit","GetWorkItemUnit","47","201507","201509") 
Query GetWorkItemUnit(workitemid As %Binary, ymstart As %Binary, ymend As %Binary) As %Query(ROWSPEC = "deptname:%String,num:%Integer,price:%Integer,workitem:%String,totalprice:%Integer") [ SqlProc ]
{
}

Storage Default
{
<StreamLocation>^dhc.bonus7006.uBonusWorkIDE5ES</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
