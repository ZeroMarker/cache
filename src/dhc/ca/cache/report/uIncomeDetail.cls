Class dhc.ca.cache.report.uIncomeDetail Extends (%Persistent, %Populate, %XML.Adaptor) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

/// Creator: wang ying
/// CreatDate: 2009-03-31
/// Description: 绩效核算收入明细表生成临时global
/// Table：DeptLevelSets,DataLevelSets  
/// Input:month：核算区间, costSetDr：分摊层id, itemSetDr：数据分层套id, deptTypeDr：部门分层套id
/// Output: 
/// Others: w ##class(dhc.ca.cache.report.uIncomeDetail).incomeReportData(1,1,"2","7")
ClassMethod incomeReportData(month, costSetDr, itemSetDr, deptTypeDr) As %String
{
  //^DHCCAINCOMEDATAS(0,"Interval",{IncomeDatas_intervalDr},{IncomeDatas_rowid})
  n (month, costSetDr, itemSetDr, deptTypeDr)
  s count = 1
  s incomeDr = ""
  f  s incomeDr = $o(^DHCCAINCOMEDATAS(0,"Interval",month,incomeDr)) q:incomeDr=""  d
  .s itemDr = $p($g(^DHCCAINCOMEDATAS(incomeDr)),"^",6)
  .s fee = $p($g(^DHCCAINCOMEDATAS(incomeDr)),"^",7)
  .s fdept = $p($g(^DHCCAINCOMEDATAS(incomeDr)),"^",11)
  .d ..addParData(fdept,itemDr,fee,"from")
  .s tdept = $p($g(^DHCCAINCOMEDATAS(incomeDr)),"^",14)
  .d ..addParData(tdept,itemDr,fee,"to")
  .s deptDr = "from"_"$"_fdept
  .i ($d(^DHCCAINCOMEDETAIL($j,deptDr,itemDr)))  d
  ..s ^DHCCAINCOMEDETAIL($j,deptDr,itemDr) = fee + ^DHCCAINCOMEDETAIL($j,deptDr,itemDr)
  .e  d
  ..s ^DHCCAINCOMEDETAIL($j,deptDr,itemDr) = fee
  .s deptDr = "to"_"$"_tdept
  .i ($d(^DHCCAINCOMEDETAIL($j,deptDr,itemDr)))  d
  ..s ^DHCCAINCOMEDETAIL($j,deptDr,itemDr) = fee + ^DHCCAINCOMEDETAIL($j,deptDr,itemDr)
  .e  d
  ..s ^DHCCAINCOMEDETAIL($j,deptDr,itemDr) = fee
}

/// Creator: wang ying
/// CreatDate: 2009-05-18
/// Description: 绩效核算收入明细表生成加入父级科室临时global
/// Table：DeptLevelSets,DataLevelSets  
/// Input:deptDr：末层科室id, itemDr：项目id, fee:金额, type：科室收入类型（开单收入，接收收入）
/// Output: 
/// Others: w ##class(dhc.ca.cache.report.uIncomeDetail).addPar(1,1,"2","7")
ClassMethod addParData(deptDr, itemDr, fee, type) As %String
{
	n (deptDr, itemDr, fee, type)
	;w "deptDr ="_deptDr,!
	i $d(^tmpdhccadeptleveltree($j,"leaf",deptDr)) d
	.s deptTree = ^tmpdhccadeptleveltree($j,"leaf",deptDr)
	.s allParrent = $p(deptTree,"||",2)
	.;w "allParrent = "_allParrent,!
	.s len =$l(allParrent,"^")
	.;w "len="_len,!
	.f rep=len-1:-1:1 d
	..s parDept = $p(allParrent,"^",rep)
	..;w "parDept="_parDept,!
	..i $d(^DHCCAINCOMEDETAIL($j,"trunk"_"||"_type_"$"_parDept,itemDr)) d
	...s ^DHCCAINCOMEDETAIL($j,"trunk"_"||"_type_"$"_parDept,itemDr) = fee + ^DHCCAINCOMEDETAIL($j,"trunk"_"||"_type_"$"_parDept,itemDr)
	..e  d
	...s ^DHCCAINCOMEDETAIL($j,"trunk"_"||"_type_"$"_parDept,itemDr) = fee
}

/// Creator: wang ying
/// CreatDate: 2009-04-01
/// Description: 绩效核算收入明细表
/// Table：DeptLevelSets,DataLevelSets  
/// Input:month：核算区间, costSetDr：分摊层id, itemSetDr：数据分层套id, deptTypeDr：部门分层套id
/// Output: 
/// Others: w ##class(dhc.ca.cache.report.uIncomeDetail).addZero(1,1,2,"7")
ClassMethod addZero(month, costSetDr, itemSetDr, deptTypeDr) As %String
{
  //^DHCCAINCOMEDATAS(0,"Interval",{IncomeDatas_intervalDr},{IncomeDatas_rowid})
  n (month, costSetDr, itemSetDr, deptTypeDr)
  ;w $zt($p($h,",",2)),!
  k ^DHCCAINCOMEDETAIL($j)
  d ##class(dhc.ca.cache.udata.uReportResult).Delete("jxhssrmx",month,costSetDr,itemSetDr)
  s sortNum = ##class(dhc.ca.cache.report.comm.deptLevelSetTree).getDeptTreeAddLeaf(1,0)
  d ##class(dhc.ca.cache.report.uIncomeDetail).incomeReportData(month, costSetDr, itemSetDr,deptTypeDr)
  s count = 1
  Set list=##class(%ListOfDataTypes).%New()
  s num = 1
  s sort = num-1
  f  s deptType = $p(deptTypeDr,",",num) q:deptType=""  d
  .;w "deptType="_deptType,!
  .s deptDr=""
  .f  s deptDr = $o(^tmpdhccadeptleveltree($j,"leaf",deptDr)) q:deptDr=""  d
  ..s tmpTree = ^tmpdhccadeptleveltree($j,"leaf",deptDr)
  ..s tmpLen = $l($p(tmpTree,"||",2),"^")
  ..s tmpType = $p($p(tmpTree,"||",2),"^",tmpLen-1)
  ..i tmpType = deptType {
  ..d ..addParZero(deptDr,month,costSetDr,itemSetDr,"from")
  ..d ..addParZero(deptDr,month,costSetDr,itemSetDr,"to")
  ..;w "deptDr="_deptDr,!
  ..i $d(^DHCCAUNITDEPTS(deptDr)) d
  ...s deptName = $p(^DHCCAUNITDEPTS(deptDr),"^",2)
  ...i $d(^tmpdhccadeptleveltree($j,"leaf",deptDr))  d
  ....s deptTree = ^tmpdhccadeptleveltree($j,"leaf",deptDr)
  ....s deptOrder = $p(deptTree,"||",1)
  ....s deptNum = $l($p(deptTree,"||",2),"^")-1
  ....s space = ..addSpace(deptNum)
  ....s deptName = space_deptName
  ...i $d(^DHCCAINCOMEDETAIL($j,"from$"_deptDr)) d
  ....s itemDr = ""
  ....f  s itemDr = $o(^DHCCAINCOMEDETAIL($j,"from$"_deptDr,itemDr)) q:itemDr=""  d
  .....i $d(^DHCCAALLDATAITEMS(itemDr)) d
  ......s itemName = $p(^DHCCAALLDATAITEMS(itemDr),"^",3)
  ......s fee = ^DHCCAINCOMEDETAIL($j,"from$"_deptDr,itemDr)
  ......s data = fee_"^"_deptName_"^"_deptNum_"^"_deptOrder_"^^"_itemName_"^^^^"_"开单收入"_"^"_"from$"_deptDr_"^"_itemDr_"^^^^^"
  ......;w data,!
  ......d ##class(dhc.ca.cache.udata.uReportResult).Insert("jxhssrmx",month,costSetDr,itemSetDr,data)
  ...i $d(^DHCCAINCOMEDETAIL($j,"to$"_deptDr))  d
  ....s itemDr = ""
  ....f  s itemDr = $o(^DHCCAINCOMEDETAIL($j,"to$"_deptDr,itemDr)) q:itemDr=""  d
  .....i $d(^DHCCAALLDATAITEMS(itemDr)) d
  ......s itemName = $p(^DHCCAALLDATAITEMS(itemDr),"^",3)
  ......s fee = ^DHCCAINCOMEDETAIL($j,"to$"_deptDr,itemDr)
  ......s data = fee_"^"_deptName_"^"_deptNum_"^"_deptOrder_"^^"_itemName_"^^^^"_"接收收入"_"^"_"to$"_deptDr_"^"_itemDr_"^^^^^"
  ......d ##class(dhc.ca.cache.udata.uReportResult).Insert("jxhssrmx",month,costSetDr,itemSetDr,data)
  ...e  d
  ...s dept =""
  ...s dept = $o(^DHCCAINCOMEDETAIL($j,dept))
  ...s item = ""
  ...s item = $o(^DHCCAINCOMEDETAIL($j,dept,item))
  ...s tmpItemName = $p(^DHCCAALLDATAITEMS(item),"^",3)
  ...s data = 0_"^"_deptName_"^"_deptNum_"^"_deptOrder_"^^"_tmpItemName_"^^^^"_"开单收入"_"^"_"from$"_deptDr_"^"_item_"^^^^^"
  ...d ##class(dhc.ca.cache.udata.uReportResult).Insert("jxhssrmx",month,costSetDr,itemSetDr,data)
  ...s data = 0_"^"_deptName_"^"_deptNum_"^"_deptOrder_"^^"_tmpItemName_"^^^^"_"接收收入"_"^"_"to$"_deptDr_"^"_item_"^^^^^"
  ...d ##class(dhc.ca.cache.udata.uReportResult).Insert("jxhssrmx",month,costSetDr,itemSetDr,data)
  ..}
  .s num = num + 1
  k ^tmpdhccadeptleveltree($j)
  ;w $zt($p($h,",",2)),!
}

/// Creator: wang ying
/// CreatDate: 2009-05-18
/// Description: 生成加入父级科室插入到报表数据中
/// Table：DeptLevelSets,DataLevelSets  
/// Input:deptDr：末层科室id, itemDr：项目id, fee:金额, type：科室收入类型（开单收入，接收收入）
/// Output: 
/// Others: w ##class(dhc.ca.cache.report.uIncomeDetail).addParZero(1,1,"2","7")
ClassMethod addParZero(deptDr, month, costSetDr, itemSetDr, type) As %String
{
	n (deptDr,month,costSetDr,itemSetDr,type)
	;w "deptDr="_deptDr,!
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
	...s space = ..addSpace(deptNum)
	...s deptName = space_deptName
	...;w "deptName ="_deptName
	...i $d(^DHCCAINCOMEDETAIL($j,"trunk||"_type_"$"_deptPar)) d
	....s itemDr = ""
	....f  s itemDr=$o(^DHCCAINCOMEDETAIL($j,"trunk||"_type_"$"_deptPar,itemDr)) q:itemDr=""  d
	.....i $d(^DHCCAALLDATAITEMS(itemDr)) d
	......s itemName = $p(^DHCCAALLDATAITEMS(itemDr),"^",3)
	......s fee = ^DHCCAINCOMEDETAIL($j,"trunk||"_type_"$"_deptPar,itemDr)
	......i type = "from" d
	.......s data = fee_"^"_deptName_"^"_deptNum_"^"_deptOrder_"^^"_itemName_"^^^^"_"开单收入"_"^"_type_"$"_deptPar_"^"_itemDr_"^^^^^"
	......e  d
	.......s data = fee_"^"_deptName_"^"_deptNum_"^"_deptOrder_"^^"_itemName_"^^^^"_"接收收入"_"^"_type_"$"_deptPar_"^"_itemDr_"^^^^^"
	......d ##class(dhc.ca.cache.udata.uReportResult).Insert("jxhssrmx",month,costSetDr,itemSetDr,data)
	...e  d
	...s dept = ""
	...s dept = $o(^DHCCAINCOMEDETAIL($j,dept))
	...s item = ""
	...s item = $o(^DHCCAINCOMEDETAIL($j,dept,item))
	...s tmpItemName = $p($g(^DHCCAALLDATAITEMS(item)),"^",3)
	...s data = 0_"^"_deptName_"^"_deptNum_"^"_deptOrder_"^^"_tmpItemName_"^^^^"_"开单收入"_"^"_"from$"_deptDr_"^"_item_"^^^^^"
	...d ##class(dhc.ca.cache.udata.uReportResult).Insert("jxhssrmx",month,costSetDr,itemSetDr,data)
 	...s data = 0_"^"_deptName_"^"_deptNum_"^"_deptOrder_"^^"_tmpItemName_"^^^^"_"接收收入"_"^"_"to$"_deptDr_"^"_item_"^^^^^"
  	...d ##class(dhc.ca.cache.udata.uReportResult).Insert("jxhssrmx",month,costSetDr,itemSetDr,data)
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
<Data name="uIncomeDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^dhc.ca.cache70D.uIncomeDetailD</DataLocation>
<DefaultData>uIncomeDetailDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhc.ca.cache70D.uIncomeDetailD</IdLocation>
<IndexLocation>^dhc.ca.cache70D.uIncomeDetailI</IndexLocation>
<StreamLocation>^dhc.ca.cache70D.uIncomeDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
