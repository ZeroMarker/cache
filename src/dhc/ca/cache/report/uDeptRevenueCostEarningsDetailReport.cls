/// Creator: 王赢赢
/// CreatDate: 2009-1-7
/// Description: 科室收入成本收益明细表
Class dhc.ca.cache.report.uDeptRevenueCostEarningsDetailReport Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Projection uDetailReport As %Projection.Java(ROOTDIR = "c:\aaa");

/// Creator: 王赢赢
/// CreatDate: 2009-1-7
/// Description: 
/// Table：DeptLevelSets  
/// Input: rowid-id
/// Output: 
/// Others: w ##class(dhc.ca.cache.report.uDeptRevenueCostEarningsDetailReport).ListItemClass(0,20,1)
ClassMethod ListItemClass(Start, Limit, Parent)
{
	n (Start, Limit, Parent)
	Set Result = ##class(%Library.ResultSet).%New()
	Set SqlStr = "select DataLevelSets_rowid,DataLevelSets_name,DataLevelSets_shortcut from dhc_ca_cache_data.DataLevelSets where %ID>0 and DataLevelSets_parent='"_Parent_"'"
	s Count=0
	s ResultString=""	

	s SqlStr=SqlStr_" and DataLevelSets_active='Y'"
	;w SqlStr	
	d Result.Prepare(SqlStr)
	d Result.Execute()

	s Json = ##class(dhc.ca.cache.comm.JsonObj).%New()
	s End = Start+Limit
	
	While(Result.Next())
	{
		s rowid = Result.Data("DataLevelSets_rowid")
		s name = Result.Data("DataLevelSets_name")
		s desc = Result.Data("DataLevelSets_shortcut")
		s Tmp=rowid_"^"_name_"^"_desc
		s Count=Count+1
		
		i (Count>Start)&(Count<=End) d
		.d Json.InsertRowData(Tmp)
		
	}

	d Result.Close()
	s ResultString = Json.getJsonData("id^name^desc",Count)
 	k Json
	q ResultString
}

/// Creator: 王赢赢
/// CreatDate: 2009-1-7
/// Description: 
/// Table：DeptLevelSets  
/// Input: rowid-id
/// Output: 
/// Others: w ##class(dhc.ca.cache.report.uDeptRevenueCostEarningsDetailReport).ListDeptClass(0,20,1)
ClassMethod ListDeptClass(Start, Limit, Parent)
{
	n (Start, Limit, Parent)
	Set Result = ##class(%Library.ResultSet).%New()
	Set SqlStr = "select DeptLevelSets_rowid,DeptLevelSets_name,DeptLevelSets_shortcut from dhc_ca_cache_data.DeptLevelSets where %ID>0 and DeptLevelSets_parent='"_Parent_"'"
	s Count=0
	s ResultString=""	

	s SqlStr=SqlStr_" and DeptLevelSets_active='Y'"
			
	d Result.Prepare(SqlStr)
	d Result.Execute()

	s Json = ##class(dhc.ca.cache.comm.JsonObj).%New()
	s End = Start+Limit
	
	While(Result.Next())
	{
		s rowid = Result.Data("DeptLevelSets_rowid")
		s name = Result.Data("DeptLevelSets_name")
		s desc = Result.Data("DeptLevelSets_shortcut")
		s Tmp=rowid_"^"_name_"^"_desc
		s Count=Count+1
		
		i (Count>Start)&(Count<=End) d
		.d Json.InsertRowData(Tmp)
		
	}

	d Result.Close()
	s ResultString = Json.getJsonData("id^name^desc",Count)
 	k Json
	q ResultString
}

/// Creator: 王赢赢
/// CreatDate: 2009-1-7
/// Description: 
/// Table：DeptLevelSets  
/// Input: rowid-id
/// Output: 
/// Others: w ##class(dhc.ca.cache.report.uDeptRevenueCostEarningsDetailReport).genTree("tmp",6)
ClassMethod genTree(tmpTreeName, rowid) As %String
{
 n (tmpTreeName,rowid)
 d ##class(dhc.ca.cache.report.comm.deptLevelSetTree).genDeptTree(tmpTreeName,rowid)
 d ##class(dhc.ca.cache.report.deptsFrame).%DeleteExtent()
 d ##class(dhc.ca.cache.report.deptCost).%DeleteExtent()
 d ##class(dhc.ca.cache.report.deptRevenue).%DeleteExtent()
 s tmpOrder=""
 f  s tmpOrder=$o(^tmpDepts(tmpOrder)) q:tmpOrder=""  d
 .s deptsFrame = ##class(dhc.ca.cache.report.deptsFrame).%New() 
 .s deptsFrame.deptOrder=tmpOrder
 .s deptsFrame.deptName=$p(^tmpDepts(tmpOrder),"^",1)
 .s deptsFrame.num=$p(^tmpDepts(tmpOrder),"^",2)
 .s deptsFrame.leaf=$p(^tmpDepts(tmpOrder),"^",3)
 .s deptsFrame.par=$p(^tmpDepts(tmpOrder),"^",4)
 .s sc = deptsFrame.%Save()
 
 q "OK"
}

/// Creator: 王赢赢
/// CreatDate: 2009-1-7
/// Description: 
/// Table：DeptLevelSets
/// Input: rowid-id
/// Output: 
/// Others: w ##class(dhc.ca.cache.report.uDeptRevenueCostEarningsDetailReport).ListData("1","6","1","")
ClassMethod ListData(costDistSetId, deptClass, month, type) As %String
{
 n (costDistSetId,deptClass,month,type)
 
 Set start = $ZH 
 s tmpCount=0
 
 s tmpDeptLevelSet=$p(^DHCCACOSTDISTSETS(costDistSetId),"^",5)
 s tmpDepts=##class(dhc.ca.cache.report.comm.deptLevelSetTree).getCurrentClass(tmpDeptLevelSet,deptClass)

 s tmpDeptArray=##class(%ArrayOfDataTypes).%New()

 s tmpDeptId="" 
 s tmpCur=1
 f  s tmpDeptId=$p(tmpDepts,"||",tmpCur) q:tmpDeptId=""  d
 .s tmpCur=tmpCur+1
 .s tmpR=$p(tmpDeptId,"^",1)
 .s tmpS=$p(tmpDeptId,"^",2)
 .i tmpS'=0 d
 ..d tmpDeptArray.SetAt($p(^DHCCAUNITDEPTS($p(^DHCCADEPTLEVELSETS(tmpR,"Depts",tmpS),"^",1)),"^",2),$p(^DHCCADEPTLEVELSETS(tmpR,"Depts",tmpS),"^",1))
 
 i type="成本" d
 .s deptcost = ##class(dhc.ca.cache.report.deptCost).%New()
 .s tmpCostDistSetName=$p(^DHCCACOSTDISTSETS(costDistSetId),"^",3)
 .s tmpDeptClassName=$p(^DHCCADEPTLEVELSETS(deptClass),"^",2)
 .s tmpMonthName=$p(^DHCCAACCOUNTMONTHS(month),"^",2)
 .s deptcost.deptName=tmpDeptClassName
 .s deptcost.itemName=tmpCostDistSetName
 .s deptcost.itemAll=tmpMonthName
 .s sc = deptcost.%Save()
 
 d ..addCostZero(type)
 
 s rset = ##class(%ResultSet).%New("dhc.ca.cache.data.CostResultData:Extent")
 d rset.Execute()
 d rset.Next()
 ;w rset.Data("ID")
 ;b
 While (rset.Next()) {
	s tmpCostResultDataId=rset.Data("ID")
	s tmpCostResultDataparRef=$p(tmpCostResultDataId,"||",1)
	s tmpCostResultDatachildSub=$p(tmpCostResultDataId,"||",2)
	s tmpCostResultDataintervalDr=$p(^DHCCACOSTDISTSETS(tmpCostResultDataparRef,"CostResultData",tmpCostResultDatachildSub),"^",1)
	s tmpCostResultDatadistDeptDr=$p(^DHCCACOSTDISTSETS(tmpCostResultDataparRef,"CostResultData",tmpCostResultDatachildSub),"^",3)
	s tmpCostResultDatadistDeptName=tmpDeptArray.GetAt(tmpCostResultDatadistDeptDr)
	i (month=tmpCostResultDataintervalDr)&&(tmpCostResultDatadistDeptName'="") d
	.s deptcost = ##class(dhc.ca.cache.report.deptCost).%New() 
 	.s tmpCostResultDataitemDr=$p(^DHCCACOSTDISTSETS(tmpCostResultDataparRef,"CostResultData",tmpCostResultDatachildSub),"^",4)
	.s tmpCostResultDatafee=$p(^DHCCACOSTDISTSETS(tmpCostResultDataparRef,"CostResultData",tmpCostResultDatachildSub),"^",5)
	.s tmpCostResultDataitemName=$p(^DHCCAALLDATAITEMS(tmpCostResultDataitemDr),"^",3)
	.s deptcost.deptName=tmpCostResultDatadistDeptName
	.s tmpCur=""
	.f  s tmpCur=$o(^tmpDepts(tmpCur)) q:tmpCur=""  d
	..s tmpName=$p(^tmpDepts(tmpCur),"^",1)
	..s tmpLeaf=$p(^tmpDepts(tmpCur),"^",3)
	..i (tmpCostResultDatadistDeptName=tmpName)&&(tmpLeaf="leaf") d
	...s tmpNum=$p(^tmpDepts(tmpCur),"^",2)
	...s deptcost.orderNum=tmpCur
	...s deptcost.num=tmpNum
	...d ..addCostAncestors($p(^tmpDepts(tmpCur),"^",4),tmpCostResultDatafee,type)
	.s deptcost.itemName=tmpCostResultDataitemName
	.s deptcost.cost=tmpCostResultDatafee
	.s deptcost.itemAll=type
	.i type=""
	.s sc = deptcost.%Save()
}

 Set elap = $ZH - start  
 q elap
}

/// Others: w ##class(dhc.ca.cache.report.uDeptRevenueCostEarningsDetailReport).tmptest()
ClassMethod tmptest() As %String
{
 //s tt=""
 //s tm=0
 //f  s tt=$o(^DHCCACOSTDISTSETS(1,"CostResultData",tt)) q:tt=""  d
 //.i $p(^DHCCACOSTDISTSETS(1,"CostResultData",tt),"^",3)=5 d
 //..s tm=tm+$p(^DHCCACOSTDISTSETS(1,"CostResultData",tt),"^",5)
 //w tm
 //
 s sqlStr="select * from dhc_ca_cache_report.deptCost where deptName='院长办公室' and num=1"
 	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s m=0
	while(result.Next())
	{
		s m=m+ result.Data("cost")	
		
	}
	w m
}

/// Others: w ##class(dhc.ca.cache.report.uDeptRevenueCostEarningsDetailReport).addCostAncestors("9||4||0",33)
ClassMethod addCostAncestors(par, cost, type) As %String
{
 n (par,cost,type)
 s tmpCur=0
 f  s tmpCur=tmpCur+1 q:$p(par,"||",tmpCur)=0  d
 .s tmpPar=$p(par,"||",tmpCur)
 .s tmpDeptName=$p(^DHCCADEPTLEVELSETS(tmpPar),"^",2)
 .;w tmpDeptName
 .s tmpCur2=""
 .f  s tmpCur2=$o(^tmpDepts(tmpCur2)) q:tmpCur2=""  d
 ..s tmpName=$p(^tmpDepts(tmpCur2),"^",1)
 ..s tmpLeaf=$p(^tmpDepts(tmpCur2),"^",3)
 ..i (tmpName=tmpDeptName)&&(tmpLeaf="unLeaf") d
 ...;w $p(^tmpDepts(tmpCur2),"^",2)
 ...s deptcost = ##class(dhc.ca.cache.report.deptCost).%New()
 ...s deptcost.cost=cost
 ...s deptcost.deptName=tmpName
 ...s deptcost.itemAll=type
 ...s deptcost.num=$p(^tmpDepts(tmpCur2),"^",2)
 ...s deptcost.orderNum=tmpCur2
 ...s sc = deptcost.%Save()
}

/// Others: w ##class(dhc.ca.cache.report.uDeptRevenueCostEarningsDetailReport).addCostZero()
ClassMethod addCostZero(type) As %String
{
 n (type)
 s tmpCur2=""
 f  s tmpCur2=$o(^tmpDepts(tmpCur2)) q:tmpCur2=""  d
 .s deptcost = ##class(dhc.ca.cache.report.deptCost).%New()
 .s deptcost.cost=0
 .s deptcost.deptName=$p(^tmpDepts(tmpCur2),"^",1)
 .s deptcost.itemAll=type
 .s deptcost.num=$p(^tmpDepts(tmpCur2),"^",2)
 .s deptcost.orderNum=tmpCur2
 .s sc = deptcost.%Save()
}

/// Creator: 王赢赢
/// CreatDate: 2009-1-7
/// Description: 
/// Table：DeptLevelSets
/// Input: rowid-id
/// Output: 
/// Others: w ##class(dhc.ca.cache.report.uDeptRevenueCostEarningsDetailReport).ListRevenueData("1","6","1","","0","0")
ClassMethod ListRevenueData(costDistSetId, deptClass, month, type, tf, tf2) As %String
{
 n (costDistSetId,deptClass,month,type, tf,tf2)
 
 
 
 Set start = $ZH 
 s tmpCount=0
 
 s tmpDeptLevelSet=$p(^DHCCACOSTDISTSETS(costDistSetId),"^",5)
 s tmpDepts=##class(dhc.ca.cache.report.comm.deptLevelSetTree).getCurrentClass(tmpDeptLevelSet,deptClass)

 s tmpDeptArray=##class(%ArrayOfDataTypes).%New()

 s tmpDeptId="" 
 s tmpCur=1
 f  s tmpDeptId=$p(tmpDepts,"||",tmpCur) q:tmpDeptId=""  d
 .s tmpCur=tmpCur+1
 .s tmpR=$p(tmpDeptId,"^",1)
 .s tmpS=$p(tmpDeptId,"^",2)
 .i tmpS'=0 d
 ..d tmpDeptArray.SetAt($p(^DHCCAUNITDEPTS($p(^DHCCADEPTLEVELSETS(tmpR,"Depts",tmpS),"^",1)),"^",2),$p(^DHCCADEPTLEVELSETS(tmpR,"Depts",tmpS),"^",1))

 d ..addRevenueZero(type)

 s tmpRowid=""
 f  s tmpRowid=$o(^DHCCAINCOMEDATAS(0,"Interval",month,tmpRowid)) q:tmpRowid=""  d
 .;s tmpCount=tmpCount+1
 .s tmpIncome=^DHCCAINCOMEDATAS(tmpRowid)
 .s tmpIncomeTDeptDr=""
 .i tf2=0 d
 ..s tmpIncomeTDeptDr=$p(tmpIncome,"^",14)
 ..s tmpIncomeFDeptDr=$p(tmpIncome,"^",11)
 .e  d
 ..s tmpIncomeTDeptDr=$p(tmpIncome,"^",11)
 ..s tmpIncomeFDeptDr=$p(tmpIncome,"^",14)
 .i tmpIncomeTDeptDr'="" d
 ..s tmpIncomeTDeptName=tmpDeptArray.GetAt(tmpIncomeTDeptDr)
 ..i (tmpIncomeTDeptName'="")&&(tf||(tmpIncomeTDeptDr=tmpIncomeFDeptDr)) d
 ...s deptRevenue = ##class(dhc.ca.cache.report.deptRevenue).%New()
 ...s tmpIncomeMoney=$p(tmpIncome,"^",7)
 ...s tmpIncomeItemDr=$p(tmpIncome,"^",6)
 ...s tmpIncomeItemName=$p(^DHCCAALLDATAITEMS(tmpIncomeItemDr),"^",3)
 ...s deptRevenue.revenue=tmpIncomeMoney
 ...s deptRevenue.deptName=tmpIncomeTDeptName
 ...s tmpCur=""
 ...f  s tmpCur=$o(^tmpDepts(tmpCur)) q:tmpCur=""  d
 ....s tmpName=$p(^tmpDepts(tmpCur),"^",1)
 ....s tmpLeaf=$p(^tmpDepts(tmpCur),"^",3)
 ....i (tmpIncomeTDeptName=tmpName)&&(tmpLeaf="leaf") d
 .....s tmpNum=$p(^tmpDepts(tmpCur),"^",2)
 .....s deptRevenue.orderNum=tmpCur
 .....s deptRevenue.num=tmpNum
 .....d ..addRevenueAncestors($p(^tmpDepts(tmpCur),"^",4),tmpIncomeMoney,type)
 ...s deptRevenue.itemName=tmpIncomeItemName
 ...s deptRevenue.itemAll=type
 ...s sc = deptRevenue.%Save()
 ...s tmpCount=tmpCount+1
 Set elap = $ZH - start  
 q tmpCount
}

/// Others: w ##class(dhc.ca.cache.report.uDeptRevenueCostEarningsDetailReport).addRevenueAncestors("6||1||0",33)
ClassMethod addRevenueAncestors(par, revenue, type) As %String
{
 n (par,revenue,type)
 s tmpCur=0
 f  s tmpCur=tmpCur+1 q:$p(par,"||",tmpCur)=0  d
 .s tmpPar=$p(par,"||",tmpCur)
 .s tmpDeptName=$p(^DHCCADEPTLEVELSETS(tmpPar),"^",2)
 .;w tmpDeptName
 .s tmpCur2=""
 .f  s tmpCur2=$o(^tmpDepts(tmpCur2)) q:tmpCur2=""  d
 ..s tmpName=$p(^tmpDepts(tmpCur2),"^",1)
 ..s tmpLeaf=$p(^tmpDepts(tmpCur2),"^",3)
 ..i (tmpName=tmpDeptName)&&(tmpLeaf="unLeaf") d
 ...;w $p(^tmpDepts(tmpCur2),"^",2)
 ...s deptcost = ##class(dhc.ca.cache.report.deptRevenue).%New()
 ...s deptcost.revenue=revenue
 ...s deptcost.deptName=tmpName
 ...s deptcost.itemAll=type
 ...s deptcost.num=$p(^tmpDepts(tmpCur2),"^",2)
 ...s deptcost.orderNum=tmpCur2
 ...s sc = deptcost.%Save()
}

/// Others: w ##class(dhc.ca.cache.report.uDeptRevenueCostEarningsDetailReport).addRevenueZero()
ClassMethod addRevenueZero(type) As %String
{
 n (type)
 s tmpCur2=""
 f  s tmpCur2=$o(^tmpDepts(tmpCur2)) q:tmpCur2=""  d
 .s deptRevenue = ##class(dhc.ca.cache.report.deptRevenue).%New()
 .s deptRevenue.revenue=0
 .s deptRevenue.deptName=$p(^tmpDepts(tmpCur2),"^",1)
 .s deptRevenue.itemAll=type
 .s deptRevenue.num=$p(^tmpDepts(tmpCur2),"^",2)
 .s deptRevenue.orderNum=tmpCur2
 .s sc = deptRevenue.%Save()
}

Storage Default
{
<Data name="uDeptRevenueCostEarningsDetailReportDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^dhc.ca.c.uDeptRevenueCostEarniD</DataLocation>
<DefaultData>uDeptRevenueCostEarningsDetailReportDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhc.ca.c.uDeptRevenueCostEarniD</IdLocation>
<IndexLocation>^dhc.ca.c.uDeptRevenueCostEarniI</IndexLocation>
<StreamLocation>^dhc.ca.c.uDeptRevenueCostEarniS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
