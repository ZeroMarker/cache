Class dhc.ca.cache.report.uIncomeReportsQuery Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod ListCostResultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ListCostResultExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	
	Quit $$$OK
}

ClassMethod ListCostResultExecute(ByRef qHandle As %Binary, intervalDr As %String, patType As %String, itemDr As %String, fDeptDr As %String, tDeptDr As %String, patDeptDr As %String, incomeLayer As %String, deptLayer As %String, deptType As %String) As %Status
{
	///do ResetVariables
	Set repid=$I(^CacheTemp)
	s ind=1
	////////////此处添加程序内容///////////////
	//若在入口处需要判断参数是否为空，需要如下格式
	//i billNo=”” s qHandle=$lb(0,repid,0) q $$$OK
	
	// 生成临时global

	//set ind = ..OutputReportRow(repid,ind)
	set ind = ..CreateData(repid, ind, intervalDr, patType, itemDr, fDeptDr, tDeptDr, patDeptDr, incomeLayer, deptLayer, deptType)
	s qHandle=$lb(0,repid,0)

	Quit $$$OK
}

ClassMethod ListCostResultFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ListCostResultExecute ]
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

/// Creator: 杨旭
/// CreatDate: 2010-01-27
/// Description: 生成临时表IncomeReports数据
/// Table: dhc.ca.cache.report.IncomeReports
/// Input: intervalDr-月份区间; patType-病人类型; itemDr-业务项ID; fDeptDr-开单科室; tDeptDr-接收科室; patDeptDr-病人科室; incomeLayer-项目层; deptLayer-部门层; deptType-科室类型
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.ca.cache.report.uIncomeReportsQuery).CreateData(6,1,"1","","134","","","","","6","F")
ClassMethod CreateData(repid, ind, intervalDr, patType, itemDr, fDeptDr, tDeptDr, patDeptDr, incomeLayer, deptLayer, deptType)
{
	//w intervalDr_"[#]"_patType_"[#1]"_itemDr_"[#2]"_fDeptDr_"[#3]"_tDeptDr_"[#4]"_patDeptDr_"[#5]"_incomeLayer_"[#6]"_deptLayer_"[#7]"_deptType,!
	
	s sqlStr="SELECT IncomeDatas_inDate, IncomeDatas_rowid,IncomeDatas_intervalDr, IncomeDatas_feeDate, IncomeDatas_patType, IncomeDatas_itemCode, IncomeDatas_itemName, IncomeDatas_itemDr, IncomeDatas_fee, IncomeDatas_cost, IncomeDatas_fDeptCode, IncomeDatas_fDeptName, IncomeDatas_fDeptDr, IncomeDatas_tDeptCode, IncomeDatas_tDeptName, IncomeDatas_tDeptDr, IncomeDatas_patDeptCode, IncomeDatas_patDeptName, IncomeDatas_patDeptDr, IncomeDatas_inType, IncomeDatas_inPersonDr, IncomeDatas_remark FROM dhc_ca_cache_data.IncomeDatas "
	
	s whereStr=" WHERE %ID>0 "
	
	i intervalDr'="" s whereStr=whereStr_"AND IncomeDatas_intervalDr in ("_intervalDr_") "
	i patType'="" s whereStr=whereStr_"AND IncomeDatas_patType = '"_patType_"' "
	i itemDr'="" s whereStr=whereStr_"AND IncomeDatas_itemDr = '"_itemDr_"' "
	i fDeptDr'="" s whereStr=whereStr_"AND IncomeDatas_fDeptDr = '"_fDeptDr_"' "
	i tDeptDr'="" s whereStr=whereStr_"AND IncomeDatas_tDeptDr = '"_tDeptDr_"' "
	i patDeptDr'="" s whereStr=whereStr_"AND IncomeDatas_patDeptDr = '"_patDeptDr_"' "
	
	s sortStr=" ORDER BY %ID DESC"
	
	s sqlStr=sqlStr_whereStr_sortStr
	
	s result=##class(%Library.ResultSet).%New()

	d result.Prepare(sqlStr)
	d result.Execute()
	
	s resultString=0
	
	While(result.Next())
	{
		s rowid=result.Data("IncomeDatas_rowid")
		s intervalDr=result.Data("IncomeDatas_intervalDr")
		s intervalName=""
		i intervalDr'="" d
		.s intervalName=$p($g(^DHCCAACCOUNTMONTHS(intervalDr)),"^",2)
		
		s feeDate=result.Data("IncomeDatas_feeDate")
		i feeDate'="" s feeDate=$zd(feeDate,3)
		
		s patType=result.Data("IncomeDatas_patType")
		
		s itemCode=result.Data("IncomeDatas_itemCode")
		s itemName=result.Data("IncomeDatas_itemName")
		
		s itemDr=result.Data("IncomeDatas_itemDr")
		s inItemName=""
		s inItemCode=""
		i itemDr'="" d
		.s inItemCode=$p($g(^DHCCAALLDATAITEMS(itemDr)),"^",2)
		.s inItemName=$p($g(^DHCCAALLDATAITEMS(itemDr)),"^",3)
		
		s fee=result.Data("IncomeDatas_fee")
		s cost=result.Data("IncomeDatas_cost")
		s fDeptCode=result.Data("IncomeDatas_fDeptCode")
		s fDeptName=result.Data("IncomeDatas_fDeptName")
		
		s fDeptDr=result.Data("IncomeDatas_fDeptDr")
		s inFDeptCode=""
		s inFDeptName=""
		i fDeptDr'="" d
		.s inFDeptCode=$p($g(^DHCCAUNITDEPTS(fDeptDr)),"^",1)
		.s inFDeptName=$p($g(^DHCCAUNITDEPTS(fDeptDr)),"^",2)
		
		s tDeptCode=result.Data("IncomeDatas_tDeptCode")
		s tDeptName=result.Data("IncomeDatas_tDeptName")
		
		s tDeptDr=result.Data("IncomeDatas_tDeptDr")
		s inTDeptCode=""
		s inTDeptName=""
		i tDeptDr'="" d
		.s inTDeptCode=$p($g(^DHCCAUNITDEPTS(tDeptDr)),"^",1)
		.s inTDeptName=$p($g(^DHCCAUNITDEPTS(tDeptDr)),"^",2)
		
		s patDeptCode=result.Data("IncomeDatas_patDeptCode")
		s patDeptName=result.Data("IncomeDatas_patDeptName")
		
		s patDeptDr=result.Data("IncomeDatas_patDeptDr")
		s inPatDeptCode=""
		s inPatDeptName=""
		i patDeptDr'="" d
		.s inPatDeptCode=$p($g(^DHCCAUNITDEPTS(patDeptDr)),"^",1)
		.s inPatDeptName=$p($g(^DHCCAUNITDEPTS(patDeptDr)),"^",2)
		
		s inType=result.Data("IncomeDatas_inType")
		
		s personDr=result.Data("IncomeDatas_inPersonDr")
		s personName=""
		i personDr'="" d
		.s personName=$p($g(^DHCCAUNITPERSONS(personDr)),"^",2)
		
		s remark=result.Data("IncomeDatas_remark")
		s inDate=result.Data("IncomeDatas_inDate")
		i inDate'="" s inDate=$zd(inDate,3)
		//按项目分层
		//w "itemDr:"_itemDr,!
	
		i incomeLayer'="" d
		.i $d(^DHCCADATALEVELSETS(incomeLayer)) d
		..s tmpItemDr=""
		..//w "incomeLayer:"_incomeLayer,!
		..s tmpItemDr=##class(dhc.ca.cache.report.uIncomeReports).GetIdByItem(incomeLayer,itemDr)
		..//w "tmpItemDr:"_tmpItemDr,!
		..i tmpItemDr'="" s tmpItemDr=$p(tmpItemDr,"||",1)_"^"_$p(tmpItemDr,"||",2)
		..//w tmpItemDr,!
		..s tmpLayer=""
		..s tmpLayer=##class(dhc.ca.cache.report.comm.itemLevelSetTree).getItemClassInId(tmpItemDr)
		..//w tmpLayer_"||"_incomeLayer,!
		..i tmpLayer=incomeLayer d
		...//w 123,!
		...set Data=$lb(intervalDr,intervalName,patType,itemDr,inItemName,fee,cost,fDeptDr,inFDeptName,tDeptDr,inTDeptName,patDeptDr,inPatDeptName,inType) 
		...Set ^CacheTemp(repid,ind)=Data

		...Set ind=ind+1
		...//&SQL(INSERT INTO dhc_ca_cache_report.IncomeReports (IncomeDatas_intervalDr,IncomeDatas_intervalName,IncomeDatas_patType,IncomeDatas_itemDr,IncomeDatas_itemName,IncomeDatas_fee,IncomeDatas_cost,IncomeDatas_fDeptDr,IncomeDatas_fDeptName,IncomeDatas_tDeptDr,IncomeDatas_tDeptName,IncomeDatas_patDeptDr,IncomeDatas_patDeptName,IncomeDatas_inType) VALUES (:intervalDr,:intervalName,:patType,:itemDr,:inItemName,:fee,:cost,:fDeptDr,:inFDeptName,:tDeptDr,:inTDeptName,:patDeptDr,:inPatDeptName,:inType))
		...//i SQLCODE'=0 s resultString=SQLCODE
		e  i deptLayer'="" d
		.i $d(^DHCCADEPTLEVELSETS(deptLayer)) d
		..s deptLevelSetsDr=""
		..//没有返回他的套
		..s deptLevelSetsDr=##class(dhc.ca.cache.udata.uDeptLevelSets).FindSource(deptLayer)
		..s deptLayerName=""
		..s deptLayerName=$p($g(^DHCCADEPTLEVELSETS(deptLayer)),"^",2)
		..//w "deptType:"_deptType,!
		..s tmpDeptId=""
		..i deptType="F" s tmpDeptId=fDeptDr
		..i deptType="T" s tmpDeptId=tDeptDr
		..i deptType="Pat" s tmpDeptId=patDeptDr
		..s tmpString=""
		..//w deptLevelSetsDr_"||"_tmpDeptId,!
		..i tmpDeptId'="" d
		...//w deptLevelSetsDr_"||"_tmpDeptId,!
		...s tmpString=##class(dhc.ca.cache.report.comm.deptLevelSetTree).getDeptLevelNumAndClassInDept(deptLevelSetsDr,tmpDeptId)
		..//w tmpString,!
		..i deptLayerName=$p(tmpString,"||",2) d
		...set Data=$lb(intervalDr,intervalName,patType,itemDr,inItemName,fee,cost,fDeptDr,inFDeptName,tDeptDr,inTDeptName,patDeptDr,inPatDeptName,inType) 
		...Set ^CacheTemp(repid,ind)=Data
		...Set ind=ind+1
		...//&SQL(INSERT INTO dhc_ca_cache_report.IncomeReports (IncomeDatas_intervalDr,IncomeDatas_intervalName,IncomeDatas_patType,IncomeDatas_itemDr,IncomeDatas_itemName,IncomeDatas_fee,IncomeDatas_cost,IncomeDatas_fDeptDr,IncomeDatas_fDeptName,IncomeDatas_tDeptDr,IncomeDatas_tDeptName,IncomeDatas_patDeptDr,IncomeDatas_patDeptName,IncomeDatas_inType) VALUES (:intervalDr,:intervalName,:patType,:itemDr,:inItemName,:fee,:cost,:fDeptDr,:inFDeptName,:tDeptDr,:inTDeptName,:patDeptDr,:inPatDeptName,:inType))
		...//i SQLCODE'=0 s resultString=SQLCODE
		e  d
		.set Data=$lb(intervalDr,intervalName,patType,itemDr,inItemName,fee,cost,fDeptDr,inFDeptName,tDeptDr,inTDeptName,patDeptDr,inPatDeptName,inType) 
		.Set ^CacheTemp(repid,ind)=Data
		.Set ind=ind+1
		.//&SQL(INSERT INTO dhc_ca_cache_report.IncomeReports (IncomeDatas_intervalDr,IncomeDatas_intervalName,IncomeDatas_patType,IncomeDatas_itemDr,IncomeDatas_itemName,IncomeDatas_fee,IncomeDatas_cost,IncomeDatas_fDeptDr,IncomeDatas_fDeptName,IncomeDatas_tDeptDr,IncomeDatas_tDeptName,IncomeDatas_patDeptDr,IncomeDatas_patDeptName,IncomeDatas_inType) VALUES (:intervalDr,:intervalName,:patType,:itemDr,:inItemName,:fee,:cost,:fDeptDr,:inFDeptName,:tDeptDr,:inTDeptName,:patDeptDr,:inPatDeptName,:inType))
		.//i SQLCODE'=0 s resultString=SQLCODE
	}
	d result.Close()
	q resultString
}

//d ##class(%ResultSet).RunQuery("dhc.ca.cache.report.uIncomeReportsQuery","ListCostResult","5","","","","69","","23","","T")

//d ##class(%ResultSet).RunQuery("dhc.ca.cache.report.uIncomeReportsQuery","ListCostResult",1,"",55,"","","23","","","F")

Query ListCostResult(intervalDr As %String, patType As %String, itemDr As %String, fDeptDr As %String, tDeptDr As %String, patDeptDr As %String, incomeLayer As %String, deptLayer As %String, deptType As %String) As %Query(ROWSPEC = "IncomeReports_IncomeDatas_intervalDr:%String:核算区间ID,IncomeReports_IncomeDatas_intervalName:%String:核算区间,IncomeReports_IncomeDatas_patType:%String:病人类型,IncomeReports_IncomeDatas_itemDr:%String:数据项ID,IncomeReports_IncomeDatas_itemName:%String:业务项,IncomeReports_IncomeDatas_fee:%String:金额,IncomeReports_IncomeDatas_cost:%String:成本,IncomeReports_IncomeDatas_fDeptDr:%String:开单科室ID,IncomeReports_IncomeDatas_fDeptName:%String:开单科室名称,IncomeReports_IncomeDatas_tDeptDr:%String:接收科室ID,IncomeReports_IncomeDatas_tDeptName:%String:接收科室名称,IncomeReports_IncomeDatas_patDeptDr:%String:病人科室ID,IncomeReports_IncomeDatas_patDeptName:%String:病人科室,IncomeReports_IncomeDatas_inType:%String:倒入类型")
{
}

Storage Default
{
<Data name="uIncomeReportsQueryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^dhc.ca.c.uIncomeReportsQueryD</DataLocation>
<DefaultData>uIncomeReportsQueryDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhc.ca.c.uIncomeReportsQueryD</IdLocation>
<IndexLocation>^dhc.ca.c.uIncomeReportsQueryI</IndexLocation>
<StreamLocation>^dhc.ca.c.uIncomeReportsQueryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
