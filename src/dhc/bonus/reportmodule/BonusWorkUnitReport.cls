/// Creator: zhaoliguo
/// CreatDate: 2015-12-02
/// Description: 
Class dhc.bonus.reportmodule.BonusWorkUnitReport Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

Query GetUnit() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
    select %ID, BonusUnitName From dhc_bonus_data.BonusUnit WHERE IsValid =1 AND LastStage=0 AND UnitFlag=1
}

Query GetWorkItem() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
    SELECT BonusWorkItemID AS rowID, WorkItemCode , WorkItemName , WorkItemTypeID 
FROM dhc_bonus_module.BonusWorkItem
ORDER BY WorkItemTypeID,workItemCode
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
    
	s strSql="select CAST(a.BonusYear||substring(a.BonusPeriod,2,3) AS INT) as yearmonth,b.BonusUnitName,d.WorkItemName,a.ItemNum,a.ItemPrice"
	_",d.WorkItemTypeID->ItemTypeName"
	 _" from dhc_bonus_module.WorkItemResult a,dhc_bonus_data.BonusUnit b,dhc_bonus_data.BonusEmployeeUnit c"
     _",dhc_bonus_module.BonusWorkItem d Where a.BonusUnitID = b.BonusUnitID and b.BonusUnitID='"_itemid_"' "
     _" and  CAST(a.BonusYear||substring(a.BonusPeriod,2,3) AS INT)='"_ym1_"'"
     _" And  a.DataTypeID=1 And b.%ID=c.BonusUnitID AND d.BonusWorkItemID=a.BonusWorkItemID  and c.BonusEmployeeID->EmployeeCode='"_code_"'"
           
	;s ^zlg11=strSql
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(strSql)
	d result.Execute()
	s sno=0	
 While(result.Next()){
	  
	  s bonusyear=result.Data("yearmonth")
	  s name=result.Data("BonusUnitName")
	  s workitem=result.Data("WorkItemName")
	  s itemnum=result.Data("ItemNum")
	  s price=result.Data("ItemPrice")
	  s ItemTypeName=result.Data("ItemTypeName")
	  
	  s totalprice=itemnum*price
      s sno=sno+1	
	 d OutputRow3
	  
	} 
   	  
  	q $$$OK
OutputRow3
  	s Data=$lb(bonusyear,name,workitem,itemnum,price,totalprice,sno,ItemTypeName)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
}

ClassMethod GetBonusUnitFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBonusUnitExecute ]
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

ClassMethod GetBonusUnitClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBonusUnitExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:wjt
/// CreatDate:2014-04-23
/// Description:查询报表数据记录
/// Table: 
/// others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uBonusUnit","GetBonusUnit","571","201508","demo") 
Query GetBonusUnit(itemid As %Binary, ym As %Binary, code As %Binary) As %Query(ROWSPEC = "bonusyear:%String,name:%String,workitem:%String,itemnum:%Float,price:%Float,totalprice:%Float,sno:%Integer,ItemTypeName:%String") [ SqlProc ]
{
}

/// 主报表
/// 科室工作量单项奖月报
ClassMethod GetUnitWorkItemExecute(ByRef qHandle As %Binary, itemid As %Binary, ym As %Binary, code As %Binary) As %Status
{
	
	n (qHandle,itemid,ym,code)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
    s ^zlg12=itemid_"^"_ym_"^"_code
    s ym1=$p(ym,"-",1)_$p(ym,"-",2)
  
	s strSql="select CAST(a.BonusYear||substring(a.BonusPeriod,2,3) AS INT) as yearmonth,b.BonusUnitName,d.WorkItemName,a.ItemNum,a.ItemPrice"
	_",d.WorkItemTypeID->ItemTypeName,c.code1"
	 _" from dhc_bonus_module.WorkItemResult a,dhc_bonus_data.BonusUnit b"
     _",dhc_bonus_module.BonusWorkItem d ,dhc_sync_data.sync_loc c"
     _"  Where a.BonusUnitID = b.BonusUnitID and b.BonusUnitCode =c.Code0"
     _" and  CAST(a.BonusYear||substring(a.BonusPeriod,2,3) AS INT)='"_ym1_"'"
     _" And  a.DataTypeID=1  AND d.BonusWorkItemID=a.BonusWorkItemID "
     _" and d.BonusWorkItemID in ("_itemid_")"
           
	s ^zlg11=strSql
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(strSql)
	d result.Execute()
	s sno=0	
 While(result.Next()){
	  
	  s bonusyear=result.Data("yearmonth")
	  s UnitCode=result.Data("Code1")
	  s Unitname=result.Data("BonusUnitName")
	  s workitem=result.Data("WorkItemName")
	  s itemnum=result.Data("ItemNum")
	  s price=result.Data("ItemPrice")
	  s ItemTypeName=result.Data("ItemTypeName")
	  
	  s totalprice=itemnum*price
      s sno=sno+1	
	 d OutputRow31
	  
	} 
   	  
  	q $$$OK
OutputRow31
  	s Data=$lb(bonusyear,UnitCode,Unitname,workitem,itemnum,price,totalprice,sno,ItemTypeName)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
}

ClassMethod GetUnitWorkItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUnitWorkItemExecute ]
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

ClassMethod GetUnitWorkItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUnitWorkItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:wjt
/// CreatDate:2014-04-23
/// Description:查询报表数据记录
/// Table:  "13,14,15,16,17^2015-08^demo"
/// others:d ##class(%ResultSet).RunQuery("dhc.bonus.reportmodule.BonusWorkUnitReport","GetUnitWorkItem","13,14,15,16,17","2015-08","demo") 
Query GetUnitWorkItem(itemid As %Binary, ym As %Binary, code As %Binary) As %Query(ROWSPEC = "bonusyear:%String,UnitCode:%String,Unitname:%String,workitem:%String,itemnum:%Float,price:%Float,totalprice:%Float,sno:%Integer,ItemTypeName:%String") [ SqlProc ]
{
}

Storage Default
{
<StreamLocation>^dhc.bonusD87E.BonusWorkUnA232S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
