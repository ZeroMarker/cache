/// Creator: 李明忠
/// CreatDate: 2010-9-6
/// Description: 计算结果查询
Class dhc.pa.udata.uResultQuery Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 李明忠
/// CreatDate: 2010-9-7
/// Description: 查询符合条件的方案记录
/// Table: dhc.pa.data.Schem
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;dataFinish-数据采集标志;treatFinish-数据处理标志;tieOff-扎帐标志;periodType-期间类型
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.pa.udata.uResultQuery).ListRec("Y","","","","",0,25,"M")
ClassMethod ListRec(active, searchField, searchValue, sortField, sortDir, start, limit, periodType) As %String
{
		n (active,searchField,searchValue,sortField,sortDir,start,limit,periodType)
		
		s Stratagem = ""
		s curreStratagemDr = ""
		f  s Stratagem=$o(^DHCCJXPASTRATAGEM(Stratagem)) q:Stratagem=""  d
		.i $D(^DHCCJXPASTRATAGEM(Stratagem)) d
		..i $g(^DHCCJXPASTRATAGEM(Stratagem))'="" d
		...s curreStratagem = $p(^DHCCJXPASTRATAGEM(Stratagem),"^",14)
		...if curreStratagem="Y" d
		....s curreStratagemDr = Stratagem
		
		s sqlStr="SELECT Schem_rowid,Schem_parRef,Schem_code,Schem_name,Schem_shortcut,Schem_appSysDr,Schem_frequency,Schem_KPIDr,Schem_desc,Schem_active,Schem_level FROM dhc_pa_data.Schem WHERE Schem_childSub>0 and Schem_parRef="_curreStratagemDr_" and Schem_frequency='"_periodType_"'"
		s sortStr="",sortField1=""
		
		s sortField="shortcut"
		
		i sortField'="" d
		.i sortField="rowid" s sortField1="Schem_rowid"
		.i sortField="shortcut" s sortField1="Schem_shortcut"
		.i sortField="frequency" s sortField1="Schem_frequency"
		
		i sortField1'="" d
		.s sortDir=$ZCONVERT(sortDir,"u")
		.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
		.e  s sortStr=" ORDER BY "_sortField1_" ASC"
		e  s sortStr="ORDER BY %ID DESC"
		
		s sqlStr=sqlStr_sortStr
		s result=##class(%Library.ResultSet).%New()
		d result.Prepare(sqlStr)
		d result.Execute()
		
		s count=0
		s resultString=""
		s end=start+limit
		s json=##class(dhc.pa.comm.JsonObj).%New()
		s jsonTitle="rowid^shortCutFreQuency"
		
		While(result.Next())
		{
			s rowid=result.Data("Schem_rowid")
			s shortcut=result.Data("Schem_shortcut")
			s frequency=result.Data("Schem_frequency")
			s shortCutFreQuency=shortcut_"!"_frequency
			s tmp=rowid_"^"_shortCutFreQuency
			s count=count+1
			i searchValue'="" d
			.i (count>start)&(count<=end) d
			..d json.InsertRowData(tmp)
			e  d
			.i (count>start)&(count<=end) d
			..d json.InsertRowData(tmp)
		}
	
		d result.Close()
		s resultString = json.getJsonData(jsonTitle,count)
	 	k json
		q resultString
}

/// Creator:李明忠
/// CreatDate:2010-9-6
/// Description:查询绩效考核方案下的绩效单元
/// Table:dhc_pa_data.UnitSchem
/// Input:schemDr-绩效方案Dr
/// Output:
/// Return:返回绩效考核方案下的绩效单元Dr字符串
/// Others:w ##class(dhc.pa.udata.uResultQuery).GetJXUnitOfSchem("1||2")
ClassMethod GetJXUnitOfSchem(schemDr) As %String
{
	n (schemDr)
	q:schemDr="" "NoDeal"
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select UnitSchem_parRef from dhc_pa_data.UnitSchem where UnitSchem_childSub>0"
	s whereStr=" and UnitSchem_schemDr='"_schemDr_"'"
	
	s sqlStr=sqlStr_whereStr
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s jxUnitDrStr=""

	While(result.Next()){
		s parRef = result.Data("UnitSchem_parRef")
		i parRef'="" d
		.s jxUnitDr = parRef
		.i jxUnitDrStr="" s jxUnitDrStr=jxUnitDr
		.e  s jxUnitDrStr=jxUnitDrStr_"^"_jxUnitDr
	}
	
	q jxUnitDrStr
}

/// Creator:李明忠
/// CreatDate:2010-9-6
/// Description:查询绩效单元的根节点
/// Table:dhc_pa_data.JXUnit
/// Input:jxUnitDr-绩效单元Dr
/// Output:
/// Return:返回绩效单元根节点Dr
/// Others:w ##class(dhc.pa.udata.uResultQuery).GetRootNodeDr(15)
ClassMethod GetRootNodeDr(jxUnitDr) As %String
{
	
	n (jxUnitDr)
	
	s parentDr=""
	i $D(^DHCCJXPAJXUNIT(jxUnitDr)) d
	.i $G(^DHCCJXPAJXUNIT(jxUnitDr))'="" d
	..s parentDr=$P(^DHCCJXPAJXUNIT(jxUnitDr),"^",11)
	q:parentDr=0 jxUnitDr
	q:parentDr="" ""
	s parentDr=..GetRootNodeDr(parentDr)
	q parentDr
}

/// Creator：李明忠
/// CreatDate：2010-9-6
/// Description: 根据方案查询符合条件的绩效单元根节点记录
/// Table：dhc_pa_data.JXUnit
/// Input：schemDr-方案Dr;searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.pa.udata.uResultQuery).GetDeptTreeRoo("1||1","","","","","","")
ClassMethod GetDeptTreeRoo(schemDr, searchField, searchValue, sortField, sortDir, start, limit) As %String
{
	n (schemDr,searchField,searchValue,sortField,sortDir,start,limit)
	
	q:schemDr="" "NoData"
	
	//获取执行该方案记录的绩效单元记录字符串
	s jxUnitDrStr=..GetJXUnitOfSchem(schemDr)
	s Len=$L(jxUnitDrStr,"^")
	
	s rootNodeDrStr=""
	f k=1:1:Len d
	.s jxUnitDr=$P(jxUnitDrStr,"^",k)
	.i jxUnitDr'="" d
	..;获取该绩效单元的根Dr
	..s rootNodeDr=..GetRootNodeDr(jxUnitDr)
	..i rootNodeDr'="" d
	...i rootNodeDrStr="" s rootNodeDrStr=rootNodeDr
	...e  s rootNodeDrStr=rootNodeDrStr_","_rootNodeDr
	
	s rootNodeDrStr="("_rootNodeDrStr_")"

	s sqlStr="select JXUnit_rowid,JXUnit_appSysDr,JXUnit_code,JXUnit_name,JXUnit_py,JXUnit_shortcut,JXUnit_type,JXUnit_jxLocTypeDr,JXUnit_isEnd from dhc_pa_data.JXUnit"
	s whereStr=" where %ID>0 and JXUnit_appSysDr=2"
	s whereStr=whereStr_" and JXUnit_rowid in"_rootNodeDrStr_""
	
	s sortStr="",sortField1=""
	i sortField'="" d
	.i sortField="rowid" s sortField1="JXUnit_rowid"
	.i sortField="name" s sortField1="JXUnit_name"
	.i sortField="end" s sortField1="JXUnit_isEnd"
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="desc")||(sortDir="asc") s sortStr=" order by "_sortField1_" "_sortDir
	.e  s sortStr=" order by "_sortField1_" asc"
	e  s sortStr=" order by %ID desc"
	s sqlStr=sqlStr_whereStr_sortStr
	
	s resultString="["
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	//取结构
	While(result.Next()){
		s rowid = result.Data("JXUnit_rowid")
		s name = result.Data("JXUnit_name")
		//末端标志
		s isEnd = result.Data("JXUnit_isEnd")
		i isEnd="Y" s Flag="true"
		i isEnd="N" s Flag="false"
	
		s resultString=resultString_"{id:'"_rowid_"',name:'"_name_"',isEnd:'"_isEnd_"',leaf:"_Flag_",uiProvider:'col'},"
	}
		
	s resultString=resultString_"]"
	d result.Close()
	q resultString
}

/// Creator：李明忠
/// CreatDate：2010-9-6
/// Description: 查询符合条件的绩效单元设置记录
/// Table：dhc_pa_data.JXUnit
/// Input：schemDr-方案Dr;parent-父节点;searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.pa.udata.uResultQuery).GetDeptTreeList("1||4","deptRoo","","","","",0,25)
ClassMethod GetDeptTreeList(schemDr, parent, searchField, searchValue, sortField, sortDir, start, limit) As %String
{
	n (schemDr,parent,searchField,searchValue,sortField,sortDir,start,limit)
	
	
	//获取执行该方案记录的绩效单元记录字符串
	s List=##class(%Library.ListOfDataTypes).%New()
	s jxUnitDrStr=..GetJXUnitOfSchem(schemDr)
	s Len=$L(jxUnitDrStr,"^")
	f i=1:1:Len d
	.s jxUnitDr=$P(jxUnitDrStr,"^",i)
	.d List.Insert(jxUnitDr)
	
	
	//规整查询条件
	s tmpEnd=""
	i parent="deptRoo" s parent=0
	i parent'="" d
	.i $D(^DHCCJXPAJXUNIT(parent)) d
	..i $G(^DHCCJXPAJXUNIT(parent))'="" s tmpEnd=$P(^DHCCJXPAJXUNIT(parent),"^",8)
	..e  s tmpEnd="N"
	
	//SQL
	s sqlStr="select JXUnit_rowid,JXUnit_name,JXUnit_isEnd from dhc_pa_data.JXUnit"
	s whereStr=" where %ID>0 and JXUnit_appSysDr=2"
	s whereStr=whereStr_" and JXUnit_parent ='"_parent_"'"
	
	s sortStr="",sortField1=""
	i sortField'="" d
	.i sortField="rowid" s sortField1="JXUnit_rowid"
	.i sortField="name" s sortField1="JXUnit_name"
	.i sortField="end" s sortField1="JXUnit_isEnd"
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="desc")||(sortDir="asc") s sortStr=" order by "_sortField1_" "_sortDir
	.e  s sortStr=" order by "_sortField1_" asc"
	e  s sortStr=" order by %ID desc"
	
	s sqlStr=sqlStr_whereStr_sortStr
	s resultString="["
	
	s result=##class(%Library.ResultSet).%New()
	i (tmpEnd="N")||(parent=0) d
	.d result.Prepare(sqlStr)
	.d result.Execute()
	//取结构
	While(result.Next()){
		s rowid = result.Data("JXUnit_rowid")
		s name = result.Data("JXUnit_name")
		
		//末端标志
		s isEnd = result.Data("JXUnit_isEnd")
		i isEnd="Y" d
		.s Flag="true"
		.i List.Find(rowid,1)'="" d
		..s resultString=resultString_"{id:'"_rowid_"',name:'"_name_"',isEnd:'"_isEnd_"',leaf:"_Flag_",uiProvider:'col'},"
	
		i isEnd="N" d
		.s Flag="false"
		.s resultString=resultString_"{id:'"_rowid_"',name:'"_name_"',isEnd:'"_isEnd_"',leaf:"_Flag_",uiProvider:'col'},"
	}
		
	s resultString=resultString_"]"
	d result.Close()
	q resultString
}

/// Creator：李明忠
/// CreatDate：2010-9-7
/// Description: 查询总数据的相关ID
/// Table：dhc_pa_data.UnitResult
/// Input：stratagemDr-当前战略Dr,schemDr-方案Dr,jxUnitDr-绩效单元Dr,newPeriod-新的期间
/// Output：
/// Return：总数据的相关ID
/// Others：w ##class(dhc.pa.udata.uResultQuery).GetURRowid(1,"1||2",1,"201001")
ClassMethod GetURRowid(stratagemDr, schemDr, jxUnitDr, newPeriod) As %String
{
	n (stratagemDr,schemDr,jxUnitDr,newPeriod)
	
	q:stratagemDr="" "NoDatas"
	q:schemDr="" "NoDatas"
	q:jxUnitDr="" "NoDatas"
	
	//查询绩效单元考核主表UnitResult
	s sqlStr="select UnitResult_rowid from dhc_pa_data.UnitResult"
	s whereStr=" where UnitResult_childSub>0 and UnitResult_schemDr='"_schemDr_"'"
	s whereStr=whereStr_" and UnitResult_parRef ='"_stratagemDr_"'"
	s whereStr=whereStr_" and UnitResult_jxUnitDr ='"_jxUnitDr_"'"
	s whereStr=whereStr_" and UnitResult_period ='"_newPeriod_"'"

	s sqlStr=sqlStr_whereStr
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s urRowid=""
	//取结构
	While(result.Next()){
		//单位考核主表方案
		s urRowid=result.Data("UnitResult_rowid")
	}
	
	q urRowid
}

/// Creator：李明忠
/// CreatDate：2010-9-7
/// Description: 获取绩效单元考核方案下的方案明细
/// Table：dhc_pa_data.UnitResultDetail
/// Input：cycleID-考核周期Dr;period-期间;parent-父级节点;schemDr-绩效方案Dr;jxUnitDr-绩效部门ID;searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向
/// Output：
/// Return：返回parent下方案明细
/// Others：w ##class(dhc.pa.udata.uResultQuery).GetKPITreeList(1,1,"roo","1||2",25,"","","","")
ClassMethod GetKPITreeList(cycleID, period, parent, schemDr, jxUnitDr, searchField, searchValue, sortField, sortDir) As %String
{
	n (cycleID,period,parent,schemDr,jxUnitDr,searchField,searchValue,sortField,sortDir)
	
	q:parent="" "NoDatas"
	q:schemDr="" "NoDatas"
	q:jxUnitDr="" "NoDatas"
	q:cycleID="" "NoDatas"
	q:period="" "NoDatas"
	
	//获取当前战略ID
	s stratagemDr=$P(schemDr,"||",1) 
	q:stratagemDr="" "NoDatas"
	
	//获取方案的报告频率、当前月份、应用系统号、考核年度
	s currMonth="",cycleDr=""
	i $D(^DHCCJXPASTRATAGEM(stratagemDr)) d
	.i $G(^DHCCJXPASTRATAGEM(stratagemDr))'="" d
	..s currMonth=$P($G(^DHCCJXPASTRATAGEM(stratagemDr)),"^",8)
	..i currMonth'="" d
	...;s frequency=$P($G(^DHCCJXPASTRATAGEM($P(schemDr,"||",1),"Schem",$P(schemDr,"||",2))),"^",5)
	...;s appSysDr=$P(^DHCCJXPASTRATAGEM($P(schemDr,"||",1),"Schem",$P(schemDr,"||",2)),"^",4)
	...s cycleDr=$P($G(^DHCCJXPASTRATAGEM(stratagemDr)),"^",2)
	
	q:cycleID'=cycleDr "NoDatas"
	q:currMonth="" "NoDatas"
	
	//获取年度代码
	s cycleCode=""
	i $D(^DHCCJXPACYCLE(cycleDr)) d
	.i $G(^DHCCJXPACYCLE(cycleDr))'="" s cycleCode=$P($G(^DHCCJXPACYCLE(cycleDr)),"^",1)
	q:cycleCode="" "NoDatas"
	s newPeriod=""
	i period'="00" d
	.i period<10 s newPeriod=cycleCode_"0"_period
	.e  s newPeriod=cycleCode_period
	e  s newPeriod=cycleCode_period
	
	s urRowid=..GetURRowid(stratagemDr,schemDr,jxUnitDr,newPeriod)
	
	//先决定数据结构
	//规整查询条件
	s tmpEnd=""
	i parent="roo" s parent=0
	
	s sqlStr="select UnitResultDetail_parRef,UnitResultDetail_rowid,UnitResultDetail_childSub,UnitResultDetail_KPIDr,UnitResultDetail_order,UnitResultDetail_isTarget,UnitResultDetail_tValue,UnitResultDetail_score,UnitResultDetail_actValue,UnitResultDetail_rate from dhc_pa_data.UnitResultDetail"
	s whereStr=" where UnitResultDetail_childSub>0 and UnitResultDetail_parRef='"_urRowid_"'"
	s whereStr=whereStr_" and UnitResultDetail_parent ='"_parent_"'"
	s sqlStr=sqlStr_whereStr
	
	s resultString="["
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	//取结构
	While(result.Next()){
		//集体初始化
		s KPIIndexName="",KPICode="",isEnd="",Flag="false",calUnitDr="",calUnitName="",target="",methodeCode="",methodName="",targetValue="",score="",actValue="",rate=0
		
		s rowid = result.Data("UnitResultDetail_rowid")
		s order = result.Data("UnitResultDetail_order")
		s isTarget = result.Data("UnitResultDetail_isTarget")
		s KPI = result.Data("UnitResultDetail_KPIDr")
		i isTarget=1 d
		.i KPI'="" d
		..i $d(^DHCCJXPADIMENSTYPE(KPI)) d
		...i $g(^DHCCJXPADIMENSTYPE(KPI)) d
		....s KPIIndexName = $P(^DHCCJXPADIMENSTYPE(KPI),"^",2)
		....s KPICode = $P(^DHCCJXPADIMENSTYPE(KPI),"^",1)
		....s KPI = "-"_KPI
		....s Flag = "false"
		i isTarget=2 d
		.i KPI'="" d
		..i $d(^DHCCJXPAKPIINDEX1(KPI)) d
		...i $g(^DHCCJXPAKPIINDEX1(KPI)) d
		....s KPIIndexName = $P(^DHCCJXPAKPIINDEX1(KPI),"^",2)
		....s KPICode = $P(^DHCCJXPAKPIINDEX1(KPI),"^",1)
		....s calUnitDr = $P(^DHCCJXPAKPIINDEX1(KPI),"^",8)
		....;计量单位
		....i calUnitDr'="" d
		.....i $D(^DHCCJXPACALUNIT(calUnitDr)) d
		......i $G(^DHCCJXPACALUNIT(calUnitDr))'="" d
		.......s calUnitName=$P(^DHCCJXPACALUNIT(calUnitDr),"^",2)
		....;评测目标
		....s target = $P(^DHCCJXPAKPIINDEX1(KPI),"^",6)
		....;考核方法
		....s methodeCode = $P(^DHCCJXPAKPIINDEX1(KPI),"^",13)
		....i methodeCode = "I" s methodName = "区间法"
		....i methodeCode = "C" s methodName = "比较法"
		....i methodeCode = "D" s methodName = "扣分法"
	    ....i methodeCode = "A" s methodName = "加分法"
		....i methodeCode = "M" s methodName = "目标参照法"
		....i methodeCode = "K" s methodName = "实际值法"
		....s isEnd = $P(^DHCCJXPAKPIINDEX1(KPI),"^",24)
		....i isEnd = "Y" d
		.....s Flag = "true"
		.....;获取目标值
		.....s targetValue = result.Data("UnitResultDetail_tValue")
		.....i targetValue="" s targetValue=0
		.....s targetValue=$fn(targetValue,"",2)
		.....;获取指标值
		.....s actValue = result.Data("UnitResultDetail_actValue")
		.....i actValue="" s actValue=0
		.....s actValue=$fn(actValue,"",2)
		....i isEnd = "N" s Flag = "false"
		;获取分数
		s score = result.Data("UnitResultDetail_score")
		i score="" s score=0
		s score=$fn(score,"",2)
		s rate = result.Data("UnitResultDetail_rate")
		s rate=$fn(rate,"",2)_"%"
			
		s resultString=resultString_"{id:'"_KPI_"',detailid:'"_rowid_"',KPIDr:'"_KPI_"',KPICode:'"_KPICode_"',KPIName:'"_KPIIndexName_"',order:'"_order_"',isTarget:'"_isTarget_"',jxUnitDr:'"_jxUnitDr_"',calUnitDr:'"_calUnitDr_"',calUnitName:'"_calUnitName_"',target:'"_target_"',methodeCode:'"_methodeCode_"',methodName:'"_methodName_"',targetValue:'"_targetValue_"',score:'"_score_"',actValue:'"_actValue_"',rate:'"_rate_"',leaf:"_Flag_",uiProvider:'col'},"
	}
		
	s resultString=resultString_"]"
	d result.Close()
	q resultString
}

/// Creator：李明忠
/// CreatDate：2010-11-17
/// Description: 获取绩效单元考核方案下的总分数
/// Table：dhc_pa_data.UnitResult
/// Input：cycleDr-考核周期Dr;period-期间;schemDr-绩效方案Dr;jxUnitDr-绩效部门ID
/// Output：
/// Return：返回parent下方案明细
/// Others：w ##class(dhc.pa.udata.uResultQuery).GetTotal()
ClassMethod GetTotal(jxUnitDr, cycleDr, period, schemDr) As %String
{
	n (jxUnitDr,cycleDr,period,schemDr)
	
	q:jxUnitDr="" "NoDatas"
	q:cycleDr="" "NoDatas"
	q:period="" "NoDatas"
	q:schemDr="" "NoDatas"
	
	//获取当前战略ID
	s stratagemDr=$P(schemDr,"||",1) 
	q:stratagemDr="" "NoDatas"
	
	//获取方案的报告频率、当前月份、应用系统号、考核年度
	s currMonth="",cycleID=""
	i $D(^DHCCJXPASTRATAGEM(stratagemDr)) d
	.i $G(^DHCCJXPASTRATAGEM(stratagemDr))'="" d
	..s currMonth=$P($G(^DHCCJXPASTRATAGEM(stratagemDr)),"^",8)
	..i currMonth'="" d
	...s frequency=$P($G(^DHCCJXPASTRATAGEM($P(schemDr,"||",1),"Schem",$P(schemDr,"||",2))),"^",5)
	...s appSysDr=$P(^DHCCJXPASTRATAGEM($P(schemDr,"||",1),"Schem",$P(schemDr,"||",2)),"^",4)
	...s cycleID=$P($G(^DHCCJXPASTRATAGEM(stratagemDr)),"^",2)
	
	q:cycleID'=cycleDr "NoDatas"
	q:currMonth="" "NoDatas"
	
	//获取年度代码
	s cycleCode=""
	i $D(^DHCCJXPACYCLE(cycleDr)) d
	.i $G(^DHCCJXPACYCLE(cycleDr))'="" s cycleCode=$P($G(^DHCCJXPACYCLE(cycleDr)),"^",1)
	q:cycleCode="" "NoDatas"
	
	s newPeriod=""
	i period'="00" d
	.i period<10 s newPeriod=cycleCode_"0"_period
	.e  s newPeriod=cycleCode_period
	e  s newPeriod=cycleCode_period
	
	
	s sqlStr="select UnitResult_totalScore from dhc_pa_data.UnitResult"
	s whereStr=" where UnitResult_childSub>0 and UnitResult_parRef='"_stratagemDr_"'"
	s whereStr=whereStr_" and UnitResult_schemDr ='"_schemDr_"'"
	s whereStr=whereStr_" and UnitResult_jxUnitDr ='"_jxUnitDr_"'"
	s whereStr=whereStr_" and UnitResult_appSysDr ='"_appSysDr_"'"
	s whereStr=whereStr_" and UnitResult_period ='"_newPeriod_"'"
	s sqlStr=sqlStr_whereStr
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s totalScore=0
	While(result.Next()){
		s totalScore = result.Data("UnitResult_totalScore")
		s totalScore=$fn(totalScore,"",2)
	
	}
	
	q totalScore
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.uResultQueryS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
