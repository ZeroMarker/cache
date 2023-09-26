Class dhc.ca.cache.report.uMedicalTechnologyGains Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// Creator: wang ying
/// CreatDate: 2009-04-16
/// Description: 收益数据
/// Table：
/// Input:costDistSetDr-成本分摊套id，month-月份
/// Output: 
/// Others: w ##class(dhc.ca.cache.report.uMedicalTechnologyGains).Gains(1,1,6,1,1)
ClassMethod Gains(repid, ind, deptType, costDistSetDr, month) As %String
{
  ;w $zt($p($h,",",2)),!
  
  ;n (repid, ind,deptType,costDistSetDr,month)
  
  k ^DHCCATECHGAINS($j)
  k ^tmpdhccadeptleveltree($j)
  
  s deptNum= ##class(dhc.ca.cache.report.comm.deptLevelSetTree).getDeptlevelSetSortedTree(1,0)
  s deptType = deptType_##class(dhc.ca.cache.report.comm.deptLevelSetTree).getOffspringUnleaf(6)
  
  s comDeptDr = "3,192"
  Set comDeptList = ##class(%ListOfDataTypes).%New()
  s num = 1
  f  s comDept = $p(comDeptDr,",",num) q:comDept=""  d
  .d comDeptList.Insert(comDept)
  .s num = num + 1
  
  d ..costData(costDistSetDr,month,comDeptList)
  d ..incomeData(month)
  For i=$l(deptType,"^"):-1:1 {
  s dept=$p(deptType,"^",i)
  i i'=1 d
  .s deptId = $p(deptType,"^",i)
  .s ind = ..deptParent(repid, ind,deptId,"income",month)
  .s ind = ..deptParent(repid, ind,deptId,"cost",month)
  s deptDr=""
  f  s deptDr = $o(^DHCCADEPTLEVELSETS(0,"Dept",dept,deptDr)) q:deptDr=""  d
  .i $d(^tmpdhccadeptleveltree($j,"leaf",deptDr))  d
  ..s deptTree = ^tmpdhccadeptleveltree($j,"leaf",deptDr)
  ..s order = $p(deptTree,"||",1)
  ..s parentAll = $p(deptTree,"||",2)
  ..s level = $l(parentAll,"^")-1
  ..i $d(^DHCCATECHGAINS($j,"cost",deptDr,order,level)) d
  ...s fee = ^DHCCATECHGAINS($j,"cost",deptDr,order,level)
  ...s ind =..save(repid, ind,deptDr, fee,"成本",order,level,"leaf",month)
  ..e  d
  ...s fee = 0
  ...s ind =..save(repid, ind,deptDr, fee,"成本",order,level,"leaf",month)
  ..i $d(^DHCCATECHGAINS($j,"income",deptDr,order,level)) d
  ...s fee = ^DHCCATECHGAINS($j,"income",deptDr,order,level)
  ...s ind = ..save(repid, ind,deptDr, fee,"收入",order,level,"leaf",month)
  ..e  d
  ...s fee = 0
  ...s ind = ..save(repid, ind,deptDr, fee,"收入",order,level,"leaf",month)
  }
  
 
  ;w $zt($p($h,",",2)),!
}

/// Creator: wang ying
/// CreatDate: 2009-04-16
/// Description: 成本数据
/// Table：CostResultData
/// Input:costDistSetDr-成本分摊套id，month-月份
/// Output: 
/// Others: w ##class(dhc.ca.cache.report.uMedicalTechnologyGains).costData(1,5)
ClassMethod costData(costDistSetDr, month, comDeptList) As %String
{
  ;w $zt($p($h,",",2)),!
  ;n (costDistSetDr,month)
  
  s costDistResultDr = ""
  s fee = 0
  f  s costDistResultDr = $o(^DHCCACOSTDISTSETS(0,"DInterval",costDistSetDr,month,costDistResultDr)) q:costDistResultDr=""  d
  .s deptDr = $p($g(^DHCCACOSTDISTSETS(costDistSetDr,"CostResultData",costDistResultDr)),"^",3)
  .s flag = $p($g(^DHCCACOSTDISTSETS(costDistSetDr,"CostResultData",costDistResultDr)),"^",6)
  .s deptdistDr = $p($g(^DHCCACOSTDISTSETS(costDistSetDr,"CostResultData",costDistResultDr)),"^",2)
  .i flag = "self" {
  .s fee = $p($g(^DHCCACOSTDISTSETS(costDistSetDr,"CostResultData",costDistResultDr)),"^",5)
  .i $d(^tmpdhccadeptleveltree($j,"leaf",deptDr))  d
  ..s order = $p(^tmpdhccadeptleveltree($j,"leaf",deptDr),"||",1)
  ..s level = ..addDeptPar(deptDr,fee,"cost")
  ..i $d(^DHCCATECHGAINS($j,"cost",deptDr,order,level))  d
  ...s ^DHCCATECHGAINS($j,"cost",deptDr,order,level) = fee + ^DHCCATECHGAINS($j,"cost",deptDr,order,level)
  ..e  d
  ...s ^DHCCATECHGAINS($j,"cost",deptDr,order,level) = fee
  .}
  .i flag = "dist"{
  .s deptStr = comDeptList.Find(deptdistDr,1)
  .i deptStr'="" {
  .s fee = $p($g(^DHCCACOSTDISTSETS(costDistSetDr,"CostResultData",costDistResultDr)),"^",5)
  .i $d(^tmpdhccadeptleveltree($j,"leaf",deptDr))  d
  ..s order = $p(^tmpdhccadeptleveltree($j,"leaf",deptDr),"||",1)
  ..s level = ..addDeptPar(deptDr,fee,"cost")
  ..i $d(^DHCCATECHGAINS($j,"cost",deptDr,order,level))  d
  ...s ^DHCCATECHGAINS($j,"cost",deptDr,order,level) = fee + ^DHCCATECHGAINS($j,"cost",deptDr,order,level)
  ..e  d
  ...s ^DHCCATECHGAINS($j,"cost",deptDr,order,level) = fee
  .}
  .}
  ;w $zt($p($h,",",2)),!
}

/// Creator: wang ying
/// CreatDate: 2009-04-16
/// Description: 收入数据
/// Table：IncomeDatas
/// Input:deptDr:科室码表id, fee:金额,month-月份
/// Output: 
/// Others: w ##class(dhc.ca.cache.report.uMedicalTechnologyGains).incomeData(1)
ClassMethod incomeData(month As %String) As %String
{
  ;n (month)
  
  s incomeDr=""
  f  s incomeDr = $o(^DHCCAINCOMEDATAS(0,"Interval",month,incomeDr)) q:incomeDr=""  d
  .s tdeptDr = $p($g(^DHCCAINCOMEDATAS(incomeDr)),"^",14)
  .s fee = $p($g(^DHCCAINCOMEDATAS(incomeDr)),"^",7)
  .i $d(^tmpdhccadeptleveltree($j,"leaf",tdeptDr))  d
  ..s order = $p($g(^tmpdhccadeptleveltree($j,"leaf",tdeptDr)),"||",1)
  ..s level = ..addDeptPar(tdeptDr,fee,"income")
  ..i $d(^DHCCATECHGAINS($j,"income",tdeptDr,order,level))  d
  ...s ^DHCCATECHGAINS($j,"income",tdeptDr,order,level) = fee + ^DHCCATECHGAINS($j,"income",tdeptDr,order,level)
  ..e  d
  ...s ^DHCCATECHGAINS($j,"income",tdeptDr,order,level) = fee
}

/// Creator: wang ying
/// CreatDate: 2009-04-16
/// Description: 添加父级科室数据
/// Table：DeptLevelSets 
/// Input:deptDr:科室码表id, fee:金额, type-收入/成本
/// Output: 
/// Others: w ##class(dhc.ca.cache.report.uMedicalTechnologyGains).addDeptPar(28,257,"income")
ClassMethod addDeptPar(deptDr, fee, type) As %String
{
   ;n (deptDr,fee,type)
   i $d(^tmpdhccadeptleveltree($j,"leaf",deptDr)) d
   .s deptTree = ^tmpdhccadeptleveltree($j,"leaf",deptDr)
   .s parentAll = $p(deptTree,"||",2)
   .s len = $l(parentAll,"^")-1
   .s count = 1
   .FOR reps=len:-1:2 {
   .s parentId = $p(parentAll,"^",count)
   .s level = reps-1
   .i $d(^tmpdhccadeptleveltree($j,"trunk",parentId)) d
   ..s order = $p(^tmpdhccadeptleveltree($j,"trunk",parentId),"||",1)
   ..i $d(^DHCCATECHGAINS($j,type,"trunk$"_parentId,order,level))  d
   ...s ^DHCCATECHGAINS($j,type,"trunk$"_parentId,order,level) = fee + ^DHCCATECHGAINS($j,type,"trunk$"_parentId,order,level)
   ..e  d
   ...s ^DHCCATECHGAINS($j,type,"trunk$"_parentId,order,level) = fee
   ..s count = count + 1
   .}
   q len
}

/// Creator: wang ying
/// CreatDate: 2009-04-16
/// Description: 保存数据到对象中
/// Table：DeptLevelSets 
/// Input:deptDr:科室码表id, fee:金额, type-收入/成本
/// Output: 
/// Others: w ##class(dhc.ca.cache.report.uMedicalTechnologyGains).addDeptPar(28,257,"income")
ClassMethod save(repid, ind, deptDr, fee, type, order, level, node, month) As %String
{
  ;n (repid, ind,deptDr, fee, type, order, level,node,month)
  s reportData = ##class(dhc.ca.cache.report.MedicalTechnologyGains).%New()
  s reportData.money = fee
  s reportData.deptOrder = order
  s reportData.deptLevel = level
  s reportData.type = type
  s deptName=""
  i node="leaf" d
  .i $d(^DHCCAUNITDEPTS(deptDr)) d
  ..s deptName = $p(^DHCCAUNITDEPTS(deptDr),"^",2)
  e  d
  .i $d(^DHCCADEPTLEVELSETS(deptDr))  d
  ..s deptName = $p(^DHCCADEPTLEVELSETS(deptDr),"^",2)
  For reps=level:-1:1 {
   s deptName = "  "_deptName
  }
  s reportData.deptName = deptName
  s reportData.month = month
  i deptName'="" d 
  .s ind = ..OutputReportRow(repid, ind, reportData)
  q ind
}

/// Creator: wang ying
/// CreatDate: 2009-04-16
/// Description: 添加父级科室数据
/// Table：DeptLevelSets 
/// Input:deptDr:科室码表id, fee:金额, type-收入/成本
/// Output: 
/// Others: w ##class(dhc.ca.cache.report.uMedicalTechnologyGains).addDeptPar(28,257,"income")
ClassMethod addDeptParent(repid, ind, parentAll, fee, type, month) As %String
{
  ;n (repid, ind,parentAll, fee, type,month)
  s parentLen = $l(parentAll,"^")-2
  s count = 1
  For reps=parentLen:-1:1 {
	 s parentId = $p(parentAll,"^",count)
	 i $d(^tmpdhccadeptleveltree($j,"trunk",parentId))  d
	 .s order = $p(^tmpdhccadeptleveltree($j,"trunk",parentId),"||",1)
	 .s level = reps
	 .i $d(^DHCCATECHGAINS($j,type,"trunk$"_parentId,order,level)) d
	 ..s fee = ^DHCCATECHGAINS($j,type,"trunk$"_parentId,order,level)
	 ..i type="income"  d
	 ...s ind =  ..save(repid, ind,parentId, fee,"收入",order,level,"trunk",month)
	 ..e  d
	 ...s ind =  ..save(repid, ind,parentId, fee,"成本",order,level,"trunk",month)
	 .e  d
	 ..s fee = 0
	 ..i type="income"  d
	 ...s ind =  ..save(repid, ind,parentId, fee,"收入",order,level,"trunk",month)
	 ..e  d
	 ...s ind =  ..save(repid, ind,parentId, fee,"成本",order,level,"trunk",month)
	 s count = count + 1
  }
  q ind
}

/// Creator: wang ying
/// CreatDate: 2009-04-16
/// Description: 添加父级科室数据
/// Table：DeptLevelSets 
/// Input:deptDr:科室码表id, fee:金额, type-收入/成本
/// Output: 
/// Others: w ##class(dhc.ca.cache.report.uMedicalTechnologyGains).addDeptPar(28,257,"income")
ClassMethod deptParent(repid, ind, dept, type, month) As %String
{
  ;n (repid, ind,parentAll, fee, type,month)
 
	 i $d(^tmpdhccadeptleveltree($j,"trunk",dept))  d
	 .s tree = ^tmpdhccadeptleveltree($j,"trunk",dept)
	 .s order = $p(tree,"||",1)
	 .s reps = $l($p(tree,"||",2),"^")-2
	 .s level = reps
	 .i $d(^DHCCATECHGAINS($j,type,"trunk$"_dept,order,level)) d
	 ..s fee = ^DHCCATECHGAINS($j,type,"trunk$"_dept,order,level)
	 ..i type="income"  d
	 ...s ind =  ..save(repid, ind,dept, fee,"收入",order,level,"trunk",month)
	 ..e  d
	 ...s ind =  ..save(repid, ind,dept, fee,"成本",order,level,"trunk",month)
	 .e  d
	 ..s fee = 0
	 ..i type="income"  d
	 ...s ind =  ..save(repid, ind,dept, fee,"收入",order,level,"trunk",month)
	 ..e  d
	 ...s ind =  ..save(repid, ind,dept, fee,"成本",order,level,"trunk",month)
     q ind
}

/// Creator：wang ying
/// CreatDate：2009-04-20
/// Description: 输出一条报表数据
/// Table：data.CostResultData
/// Input：reportDataRow 临时对象
/// Output：
/// Return：返回查询状态
/// Others：
ClassMethod OutputReportRow(repid, ind, reportDataRow) As %String
{

	;n (repid, ind, reportDataRow)
	;w "Data="_repid, ind,reportDataRow.deptName,reportDataRow.month,reportDataRow.deptLevel,reportDataRow.deptOrder,reportDataRow.money,reportDataRow.type,!
	set Data=$lb(reportDataRow.deptName,reportDataRow.month,reportDataRow.deptLevel,reportDataRow.deptOrder,reportDataRow.money,reportDataRow.type) ;按顺序对应Query的传出参数
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit ind
}

ClassMethod MedicalTechnologyGainsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MedicalTechnologyGainsExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	
	Quit $$$OK
}

ClassMethod MedicalTechnologyGainsExecute(ByRef qHandle As %Binary, deptType As %String, costDistSetDr As %String, month As %String) As %Status
{
	;w $zt($p($h,",",2)),!
	Set repid=$I(^CacheTemp)
	s ind=1
	////////////此处添加程序内容///////////////
	//若在入口处需要判断参数是否为空，需要如下格式
	//i billNo=”” s qHandle=$lb(0,repid,0) q $$$OK
	
	// 生成临时global
	
	set ind = ..Gains(repid, ind,deptType,costDistSetDr,month)
	s qHandle=$lb(0,repid,0)
	 
	k ^DHCCATECHGAINS($j)
    k ^tmpdhccadeptleveltree($j)
    ;w $zt($p($h,",",2)),!
	Quit $$$OK
}

ClassMethod MedicalTechnologyGainsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MedicalTechnologyGainsExecute ]
{
	// This fetch method should never have to change.
	// repid - Report ID
	// ind - sequence index which represents each row
	// Restore QHandle
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {			// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else {				// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	// Save Qhandle
	s qHandle=$lb(AtEnd,repid,ind)
	
	Quit $$$OK
}

//d ##class(%ResultSet).RunQuery("dhc.ca.cache.report.uMedicalTechnologyGains","MedicalTechnologyGains","6","1","1")

Query MedicalTechnologyGains(deptType As %String, costDistSetDr As %String, month As %String) As %Query(ROWSPEC = "deptName:%String,month:%String,deptLevel:%String,deptOrder:%String,money:%Float,type:%String")
{
}

Storage Default
{
<Data name="uMedicalTechnologyGainsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^dhc.ca.cach70D.uMedicalTech932D</DataLocation>
<DefaultData>uMedicalTechnologyGainsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhc.ca.cach70D.uMedicalTech932D</IdLocation>
<IndexLocation>^dhc.ca.cach70D.uMedicalTech932I</IndexLocation>
<StreamLocation>^dhc.ca.cach70D.uMedicalTech932S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
