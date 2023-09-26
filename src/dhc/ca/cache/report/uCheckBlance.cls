Class dhc.ca.cache.report.uCheckBlance Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// Creator: wang ying
/// CreatDate: 2009-04-06
/// Description: 绩效核算结余汇总
/// Table：DeptLevelSets,DataLevelSets  
/// Input:
/// Output: 
/// Others: w ##class(dhc.ca.cache.report.uCheckBlance).checkBlance(1,1,"29,30","189,190","3,9","165,170,167,155,162,179","7")
ClassMethod checkBlance(month, costSetDr, inItemDr, costItemDr, comDeptDr, comItemDr, deptTypeDr) As %String
{
  //^DHCCAINCOMEDATAS(0,"Interval",{IncomeDatas_intervalDr},{IncomeDatas_rowid})
  n (month, costSetDr, inItemDr, costItemDr, comDeptDr, comItemDr,deptTypeDr)
  ;w $zt($p($h,",",2)),!
 
  d ##class(dhc.ca.cache.udata.uReportResult).Delete("jxhsjyhz",month,costSetDr,"2")
  s deptNum= ##class(dhc.ca.cache.report.comm.deptLevelSetTree).getDeptTreeAddLeaf(1,0)
  s count = 1
  Set comDeptList = ##class(%ListOfDataTypes).%New()
  Set comItemList = ##class(%ListOfDataTypes).%New()
  Set inItemList = ##class(%ListOfDataTypes).%New()
  Set costItemList =  ##class(%ListOfDataTypes).%New()
  
 
  s num = 1
  f  s comDept = $p(comDeptDr,",",num) q:comDept=""  d
  .d comDeptList.Insert(comDept)
  .s num = num + 1
  ;w comDeptList.Count(),!
  
  s count = 1
  f  s comItem = $p(comItemDr,",",count) q:comItem=""  d
  .d comItemList.Insert(comItem)
  .s count = count + 1
  ;w comItemList.Count(),!
  
  s costNum = 1
  f  s costItem = $p(costItemDr,",",costNum) q:costItem=""  d
  .d costItemList.Insert(costItem)
  .s costNum = costNum + 1
  ;w costItemList.Count(),!
  
  s incomeNum = 1
  f  s incomeItem = $p(inItemDr,",",incomeNum) q:incomeItem=""  d
  .d inItemList.Insert(incomeItem)
  .s incomeNum = incomeNum + 1
  ;w inItemList.Count(),!
  
  d ..costReportData(month, costSetDr, comItemList, comDeptList, costItemList)
  d ..incomeReportData(month, costSetDr,inItemList)
  
  
  
  s num = 1
  s deptType = ""
  f  s deptType = $p(deptTypeDr,",",num) q:deptType=""  d
  .s deptDr=""
  .f  s deptDr = $o(^tmpdhccadeptleveltree($j,"leaf",deptDr)) q:deptDr=""  d
  ..;Do list.Insert(deptDr)
  ..s tmpTree = ^tmpdhccadeptleveltree($j,"leaf",deptDr)
  ..s tmpLen = $l($p(tmpTree,"||",2),"^")
  ..s tmpType = $p($p(tmpTree,"||",2),"^",tmpLen-1)
  ..i tmpType = deptType {
  ..i $d(^DHCCAUNITDEPTS(deptDr)) d
  ...s deptName = $p(^DHCCAUNITDEPTS(deptDr),"^",2)
  ...i $d(^tmpdhccadeptleveltree($j,"leaf",deptDr))  d
  ....s deptTree = ^tmpdhccadeptleveltree($j,"leaf",deptDr)
  ....s deptOrder = $p(deptTree,"||",1)
  ....s deptNum = $l($p(deptTree,"||",2),"^")-1
  ....s space = ..addSpace(deptNum)
  ....s deptName = space_deptName
  ....;w "deptName="_deptName,!
  ....;w check.deptName,!
  ...i $d(^DHCCACHECKBLANCE($j,"cost",deptDr)) d
  ....s checkCost = ^DHCCACHECKBLANCE($j,"cost",deptDr)
  ...e  d
  ....s checkCost = 0.00
  ...i $d(^DHCCACHECKBLANCE($j,"income",deptDr))  d
  ....s checkIncome = ^DHCCACHECKBLANCE($j,"income",deptDr)
  ...e  d
  ....s checkIncome = 0.00
  ...s checkBlance = checkIncome - checkCost
  ...s data = checkBlance_"^"_deptName_"^"_checkIncome_"^"_checkCost_"^"_deptNum_"^^"_deptOrder
  ...d ##class(dhc.ca.cache.udata.uReportResult).Insert("jxhsjyhz",month,costSetDr,"2",data)
  ...d ..addDeptParData(deptDr)
  ..}
  .s num = num + 1
  k ^DHCCACHECKBLANCE($j)
  k ^tmpdhccadeptleveltree($j)
  ;w $zt($p($h,",",2)),!
}

/// Creator: wang ying
/// CreatDate: 2009-05-18
/// Description: 绩效核算收入明细表加入父级科室数据
/// Table：DeptLevelSets,DataLevelSets  
/// Input:deptDr:末层科室id
/// Output: 
/// Others: w ##class(dhc.ca.cache.report.uCheckBlance).addDeptPar(46,55,"cost")
ClassMethod addDeptParData(deptDr) As %String
{
	i $d(^tmpdhccadeptleveltree($j,"leaf",deptDr)) d
	.s deptTree = ^tmpdhccadeptleveltree($j,"leaf",deptDr)
	.s allParent = $p(deptTree,"||",2)
	.s len = $l(deptTree,"^")
	.;w "deptTree="_deptTree,!
	.f rep=1:1:len-1 d
	..s deptPar = $p(allParent,"^",rep)
	..;w "deptPar="_deptPar,!
	..s deptParTree = $g(^tmpdhccadeptleveltree($j,"trunk",deptPar))
	..s deptOrder = $p(deptParTree,"||",1)
	..;w "deptParTree="_deptParTree
	..s deptNum = $l($p(deptParTree,"||",2),"^")-2
	..;w "deptNum="_deptNum,!
	..i $d(^DHCCADEPTLEVELSETS(deptPar)) d
	...s deptName = $p(^DHCCADEPTLEVELSETS(deptPar),"^",2)
	...s active = $p(^DHCCADEPTLEVELSETS(deptPar),"^",6)
	...i active = "Y" {
	...s space = ..addSpace(deptNum)
	...s deptName = space_deptName
	...i $d(^DHCCACHECKBLANCE($j,"cost","trunk$"_deptPar)) d
	....s checkCost = ^DHCCACHECKBLANCE($j,"cost","trunk$"_deptPar)
	...e  d
	....s checkCost = 0.0
	...i $d(^DHCCACHECKBLANCE($j,"income","trunk$"_deptPar)) d
	....s checkIncome = ^DHCCACHECKBLANCE($j,"income","trunk$"_deptPar)
	...e  d
	....s checkIncome = 0.0
	...s blance = checkIncome - checkCost
	...s data = blance_"^"_deptName_"^"_checkIncome_"^"_checkCost_"^"_deptNum_"^^"_deptOrder
  	...d ##class(dhc.ca.cache.udata.uReportResult).Insert("jxhsjyhz",month,costSetDr,"2",data)
  	...}
}

/// Creator: wang ying
/// CreatDate: 2009-04-02
/// Description: 绩效核算收入明细表
/// Table：DeptLevelSets,DataLevelSets  
/// Input:
/// Output: 
/// Others: w ##class(dhc.ca.cache.report.uIncomeDetail).addZero(1,1,2,"3,4,5,6")
ClassMethod costReportData(month, costSetDr, comItemList, comDeptList, costItemDr) As %String
{
	 n (month, costSetDr, comItemList, comDeptList, costItemDr)
	 ;w "m="_month, "cost="_costSetDr,"comitem="_comItemList,"comdept="_comDeptList,"costitem="_costItemDr,!
	 ;w $zt($p($h,",",2)),!
	 s Count=0
	 s distRusult = ""
	 f  s distRusult = $o(^DHCCACOSTDISTSETS(0,"DInterval",costSetDr,month,distRusult)) q:distRusult=""  d
	 .i $d(^DHCCACOSTDISTSETS(costSetDr,"CostResultData",distRusult))  d
	 ..s Curr=$G(^DHCCACOSTDISTSETS(costSetDr,"CostResultData",distRusult))
	 ..s itemDr = $p(Curr,"^",4)
	 ..s deptDr = $p(Curr,"^",3)
	 ..s distedDeptDr = $p(Curr,"^",2)
	 ..s fee = $p(Curr,"^",5)
	 ..s flag = $p(Curr,"^",6)
	 ..s Count=Count+1
	 ..;w itemDr_"^"_deptDr_"^"_distedDeptDr_"^"_flag,!
	 ..i flag = "self"  d
	 ...s costStr = costItemDr.Find(itemDr)
	 ...;w "costStr="_costStr,!
	 ...i (costStr="")  d
	 ....;b
	 ....d ..addDeptPar(deptDr, fee, "cost")
	 ....i $d(^DHCCACHECKBLANCE($j,"cost",deptDr))  d
	 .....s ^DHCCACHECKBLANCE($j,"cost",deptDr) = fee +^DHCCACHECKBLANCE($j,"cost",deptDr)
	 ....e  d
	 .....s ^DHCCACHECKBLANCE($j,"cost",deptDr) = fee
	 ..i flag = "dist"  d
	 ...s deptStr = comDeptList.Find(distedDeptDr,1)
	 ...s itemStr = comItemList.Find(itemDr,1)
	 ...;w "deptStr="_deptStr,"itemStr="_itemStr,"costStr="_costStr,!
	 ...i (deptStr'="")&&(costStr="")  d
	 ....;b
	 ....d ..addDeptPar(deptDr, fee, "cost")
	 ....i $d(^DHCCACHECKBLANCE($j,"cost",deptDr))  d
	 .....s ^DHCCACHECKBLANCE($j,"cost",deptDr) = fee +^DHCCACHECKBLANCE($j,"cost",deptDr)
	 ....e  d
	 .....s ^DHCCACHECKBLANCE($j,"cost",deptDr) = fee
	 ;w Count,!
	 ; w $zt($p($h,",",2)),!
}

/// Creator: wang ying
/// CreatDate: 2009-04-02
/// Description: 绩效核算收入明细表
/// Table：DeptLevelSets,DataLevelSets  
/// Input:
/// Output: 
/// Others: w ##class(dhc.ca.cache.report.uCheckBlance).incomeReportData(1,1,2,"29,30")
ClassMethod incomeReportData(month, costSetDr, inItemDr) As %String
{
	 n (month, costSetDr,inItemDr)
	 s indistResult = ""
	 f  s indistResult = $o(^DHCCAINDISTDATA(0,"Int",month,indistResult)) q:indistResult=""  d
	 .s itemDr = $p(^DHCCAINDISTDATA(indistResult),"^",4)
	 .;w "itemDr="_itemDr,!
	 .s deptDr = $p(^DHCCAINDISTDATA(indistResult),"^",3)
	 .;w "deptDr="_deptDr,!
	 .s fee = $p(^DHCCAINDISTDATA(indistResult),"^",5)
	 .s str = inItemDr.Find(itemDr)
	 .i (str="") d
	 ..d ..addDeptPar(deptDr,fee,"income")
	 ..i $d(^DHCCACHECKBLANCE($j,"income",deptDr))  d
	 ...s ^DHCCACHECKBLANCE($j,"income",deptDr) = fee + ^DHCCACHECKBLANCE($j,"income",deptDr)
	 ..e  d
	 ...s ^DHCCACHECKBLANCE($j,"income",deptDr) = fee
}

/// Creator: wang ying
/// CreatDate: 2009-04-08
/// Description: 绩效核算收入明细表
/// Table：DeptLevelSets,DataLevelSets  
/// Input:
/// Output: 
/// Others: w ##class(dhc.ca.cache.report.uCheckBlance).addDeptPar(46,55,"cost")
ClassMethod addDeptPar(deptDr, fee, type) As %String
{
   n (deptDr,fee,type)
   i $d(^tmpdhccadeptleveltree($j,"leaf",deptDr)) d
   .s deptTree = ^tmpdhccadeptleveltree($j,"leaf",deptDr)
   .s parentAll = $p(deptTree,"||",2)
   .;w "parentAll="_parentAll,!
   .s num = 1
   .f  s parentId = $p(parentAll,"^",num) q:parentId=""  d
   ..;w "parentId="_parentId,!
   ..i $d(^DHCCACHECKBLANCE($j,type,"trunk$"_parentId))  d
   ...s ^DHCCACHECKBLANCE($j,type,"trunk$"_parentId) = fee + ^DHCCACHECKBLANCE($j,type,"trunk$"_parentId)
   ..e  d
   ...s ^DHCCACHECKBLANCE($j,type,"trunk$"_parentId) = fee
   ..s num = num + 1
}

/// Creator: wang ying
/// CreatDate: 2010-02-05
/// Description: 根据传过来的数值返回空格，显示出科室或数据项的树状结构
/// Table：
/// Input:tmpNum:级别数
/// Output: 
/// Others: w ##class(dhc.ca.cache.report.uDeptStatistic).addSpace()
ClassMethod addSpace(tmpNum) As %String
{
 n (tmpNum)
 s num=1
 s space=""
 f  q:num>tmpNum  d
 .s space="  "_space
 .s num=num+1
 q space
}

Storage Default
{
<Data name="uCheckBlanceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^dhc.ca.cache.r70D.uCheckBlanceD</DataLocation>
<DefaultData>uCheckBlanceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhc.ca.cache.r70D.uCheckBlanceD</IdLocation>
<IndexLocation>^dhc.ca.cache.r70D.uCheckBlanceI</IndexLocation>
<StreamLocation>^dhc.ca.cache.r70D.uCheckBlanceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
