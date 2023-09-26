/// Creator: 李明忠
/// CreatDate: 2010-9-8
/// Description: 绩效审核
Class dhc.pa.udata.uPAAudit Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 李明忠
/// CreatDate: 2010-9-8
/// Description: 查询符合条件的方案记录
/// Table: dhc.pa.data.Schem
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;dataFinish-数据采集标志;treatFinish-数据处理标志;tieOff-扎帐标志;periodType-期间类型
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.pa.udata.uPAAudit).ListRec("Y","","","","",0,25,"Q")
ClassMethod ListRec(active, searchField, searchValue, sortField, sortDir, start, limit, periodType, userCode) As %String
{
		n (active,searchField,searchValue,sortField,sortDir,start,limit,periodType,userCode)
		
		s userCode=$$ALPHAUP^SSUTIL4(userCode)
		//根据用户Code查找用户ID
		s userId=0
		s userId=$O(^SSU("SSUSR",0,"SSUSR_Initials",userCode,userId))
		
		
		s Stratagem = ""
		s curreStratagemDr = ""
		f  s Stratagem=$o(^DHCCJXPASTRATAGEM(Stratagem)) q:Stratagem=""  d
		.i $D(^DHCCJXPASTRATAGEM(Stratagem)) d
		..i $g(^DHCCJXPASTRATAGEM(Stratagem))'="" d
		...s curreStratagem = $p(^DHCCJXPASTRATAGEM(Stratagem),"^",14)
		...if curreStratagem="Y" d
		....s curreStratagemDr = Stratagem
		
		//s sqlStr="SELECT Schem_rowid,Schem_parRef,Schem_code,Schem_name,Schem_shortcut,Schem_appSysDr,Schem_frequency,Schem_KPIDr,Schem_desc,Schem_active,Schem_level FROM dhc_pa_data.Schem WHERE Schem_childSub>0 and Schem_parRef="_curreStratagemDr_" and Schem_frequency='"_periodType_"'"
		
		//2011-12-20修改 添加方案访问权限  
		s sqlStr="SELECT Schem_rowid,Schem_parRef,Schem_code,Schem_name,Schem_shortcut,Schem_appSysDr,Schem_frequency,Schem_KPIDr,Schem_desc,Schem_active,Schem_level FROM dhc_pa_data.Schem , dhc_pa_data.SchemAudit WHERE Schem_childSub>0  and SAudit_SchemDr=Schem_rowid  and  SAudit_userDr ="_userId_"  and Schem_parRef="_curreStratagemDr_" and Schem_frequency='"_periodType_"'"
		
		s sortStr="",sortField1=""
		
		s sortField="shortcut" 
		
		
		i sortField'="" d
		.i sortField="rowid" s sortField1="Schem_rowid"
		.i sortField="shortcut" s sortField1="Schem_shortcut"
		.i sortField="frequency" s sortField1="Schem_frequency"
		
		s sortDir="ASC"
		
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
/// CreatDate:2010-9-8
/// Description:查询绩效考核方案下的绩效单元
/// Table:dhc_pa_data.UnitSchem
/// Input:schemDr-绩效方案Dr
/// Output:
/// Return:返回绩效考核方案下的绩效单元Dr字符串
/// Others:w ##class(dhc.pa.udata.uPAAudit).GetJXUnitOfSchem("1||2")
ClassMethod GetJXUnitOfSchem(schemDr) As %String
{
	n (schemDr)
	
	s jxUnitDrStr=""
	q:schemDr="" jxUnitDrStr
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select UnitSchem_parRef from dhc_pa_data.UnitSchem where UnitSchem_childSub>0"
	s whereStr=" and UnitSchem_schemDr='"_schemDr_"'"
	
	s sqlStr=sqlStr_whereStr
	d result.Prepare(sqlStr)
	d result.Execute()
	
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
/// CreatDate:2010-9-8
/// Description:查询绩效单元的根节点
/// Table:dhc_pa_data.JXUnit
/// Input:jxUnitDr-绩效单元Dr
/// Output:
/// Return:返回绩效单元根节点Dr
/// Others:w ##class(dhc.pa.udata.uPAAudit).GetRootNodeDr(15)
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
/// CreatDate：2010-9-8(需要修改)
/// Description: 根据方案查询符合条件的绩效单元根节点记录
/// Table：dhc_pa_data.JXUnit
/// Input：cycleDr-年度Dr;period-期间;schemDr-方案Dr;searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.pa.udata.uPAAudit).GetDeptTreeRoo("1||2","","","","",0,25)
ClassMethod GetDeptTreeRoo(cycleDr, period, schemDr, searchField, searchValue, sortField, sortDir, start, limit) As %String
{
	n (cycleDr,period,schemDr,searchField,searchValue,sortField,sortDir,start,limit)
	
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
		//集体初始化
		s userId="",userName="",auditDate="",auditState="",auditStateName=""
		//绩效单元ID
		s rowid = result.Data("JXUnit_rowid")
		s name = result.Data("JXUnit_name")
		//末端标志
		s isEnd = result.Data("JXUnit_isEnd")
		i isEnd="Y" d
		.s auditState="-1",auditStateName="未审核"
		.s Flag="true"
		.;根据jxUnitDr、cycleDr、period、schemDr查询审核情况
		.s auditInfo=..FindAuditStateInfo(cycleDr,period,schemDr,rowid)
		.i auditInfo'="NoData" d
		..s userId=$P(auditInfo,"^",1)
		..s userName=$P(auditInfo,"^",2)
		..s auditDate=$P(auditInfo,"^",3)
		..s auditState=$P(auditInfo,"^",4)
		..i auditState=-1 s auditStateName="未审核"
		..i auditState=0 s auditStateName="审核中"
		..i auditState=1 s auditStateName="审核通过"
		i isEnd="N" d
		.s Flag="false"
	
		s resultString=resultString_"{id:'"_rowid_"',name:'"_name_"',isEnd:'"_isEnd_"',userId:'"_userId_"',userName:'"_userName_"',auditDate:'"_auditDate_"',auditState:'"_auditState_"',auditStateName:'"_auditStateName_"',leaf:"_Flag_",uiProvider:'col'},"
	}
		
	s resultString=resultString_"]"
	d result.Close()
	q resultString
}

/// Creator：李明忠
/// CreatDate：2010-9-8
/// Description: 查询符合条件的绩效单元设置记录
/// Table：dhc_pa_data.JXUnit
/// Input：cycleDr-年度Dr;period-期间;schemDr-方案Dr;parent-父节点;searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.pa.udata.uPAAudit).GetDeptTreeList("deptRoo","","","","",0,25)
ClassMethod GetDeptTreeList(cycleDr, period, schemDr, parent, searchField, searchValue, sortField, sortDir, start, limit) As %String
{
	n (cycleDr,period,schemDr,parent,searchField,searchValue,sortField,sortDir,start,limit)
	
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
		//集体初始化
		s userId="",userName="",auditDate="",auditState="",auditStateName=""
		s rowid = result.Data("JXUnit_rowid")
		s name = result.Data("JXUnit_name")
		
		//末端标志
		s isEnd = result.Data("JXUnit_isEnd")
		i isEnd="Y" d
		.s Flag="true"
		.s auditState="-1",auditStateName="未审核"
		.;根据jxUnitDr、cycleDr、period、schemDr查询审核情况
		.s auditInfo=..FindAuditStateInfo(cycleDr,period,schemDr,rowid)
		.i auditInfo'="NoData" d
		..s userId=$P(auditInfo,"^",1)
		..s userName=$P(auditInfo,"^",2)
		..s auditDate=$P(auditInfo,"^",3)
		..s auditState=$P(auditInfo,"^",4)
		..i auditState=-1 s auditStateName="未审核"
		..i auditState=0 s auditStateName="审核中"
		..i auditState=1 s auditStateName="审核通过"
		.i List.Find(rowid,1)'="" d
		..s resultString=resultString_"{id:'"_rowid_"',name:'"_name_"',isEnd:'"_isEnd_"',userId:'"_userId_"',userName:'"_userName_"',auditDate:'"_auditDate_"',auditState:'"_auditState_"',auditStateName:'"_auditStateName_"',leaf:"_Flag_",uiProvider:'col'},"
		
		i isEnd="N" d
		.s Flag="false"
		.s resultString=resultString_"{id:'"_rowid_"',name:'"_name_"',isEnd:'"_isEnd_"',userId:'"_userId_"',userName:'"_userName_"',auditDate:'"_auditDate_"',auditState:'"_auditState_"',auditStateName:'"_auditStateName_"',leaf:"_Flag_",uiProvider:'col'},"
	}
		
	s resultString=resultString_"]"
	d result.Close()
	q resultString
}

/// Creator：李明忠
/// CreatDate：2010-9-8
/// Description: 查询总数据的相关ID
/// Table：dhc_pa_data.UnitResult
/// Input：stratagemDr-当前战略Dr,schemDr-方案Dr,jxUnitDr-绩效单元Dr,newPeriod-新的期间
/// Output：
/// Return：总数据的相关ID
/// Others：w ##class(dhc.pa.udata.uPAAudit).GetURRowid(1,"1||2",1,"201001")
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
/// CreatDate：2010-9-8
/// Description: 获取绩效单元考核方案下的方案明细
/// Table：dhc_pa_data.UnitResultDetail
/// Input：cycleID-考核周期Dr;period-期间;parent-父级节点;schemDr-绩效方案Dr;jxUnitDr-绩效部门ID;searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向
/// Output：
/// Return：返回parent下方案明细
/// Others：w ##class(dhc.pa.udata.uPAAudit).GetKPITreeList(1,"M",1,-1,"1||2",1,"","","","")
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
		.....i targetValue="" d
		......s targetValue=0
		.....s targetValue=$fn(targetValue,"",2)
		.....;获取指标值
		.....s actValue = result.Data("UnitResultDetail_actValue")
		.....i actValue="" d
		......s actValue=0
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
/// CreatDate：2010-9-8
/// Description: 审核
/// Table：dhc_pa_data.UnitResult
/// Input：cycleDr-年度Dr,period-期间,schemDr-方案Dr,jxUnitDr-绩效单元Dr,userCode-用户Code
/// Output：
/// Return：SQLCODE
/// Others：w ##class(dhc.pa.udata.uPAAudit).ExeAudit(1,1,"1||2",1,"fhq")
ClassMethod ExeAudit(cycleDr, period, schemDr, jxUnitDr, userCode) As %String
{
	n (cycleDr,period,schemDr,jxUnitDr,userCode)
	
	q:cycleDr="" "NoCycle"
	q:period="" "NoPeriod"
	q:schemDr="" "NoSchem"
	q:jxUnitDr="" "NoJXUnit"
	q:userCode="" "NoUserCode"
	
	s stratagemDr=$P(schemDr,"||",1) 
	q:stratagemDr="" "NoStratagem"
	
	//获取方案的报告频率、当前月份、应用系统号、考核年度
	s currMonth="",cycleId=""
	i $D(^DHCCJXPASTRATAGEM(stratagemDr)) d
	.i $G(^DHCCJXPASTRATAGEM(stratagemDr))'="" d
	..s currMonth=$P($G(^DHCCJXPASTRATAGEM(stratagemDr)),"^",8)
	..i currMonth'="" d
	...s cycleId=$P($G(^DHCCJXPASTRATAGEM(stratagemDr)),"^",2)
	
	q:cycleId'=cycleDr "ErrCycle"
	q:currMonth="" "NoMonth"
	
	//获取年度代码
	s cycleCode=""
	i $D(^DHCCJXPACYCLE(cycleDr)) d
	.i $G(^DHCCJXPACYCLE(cycleDr))'="" s cycleCode=$P($G(^DHCCJXPACYCLE(cycleDr)),"^",1)
	q:cycleCode="" "NoCycleCode"
	s newPeriod=""
	i period'="00" d
	.i period<10 s newPeriod=cycleCode_"0"_period
	.e  s newPeriod=cycleCode_period
	e  s newPeriod=cycleCode_period
	q:newPeriod="" "NoPeriod"
	
	//审核状态
	s auditState=1 
	//应用系统号
	s appSysDr=2 
	//用户信息
	s userCode=$$ALPHAUP^SSUTIL4(userCode)
	//根据用户Code查找用户ID
	s userId=0
	s userId=$O(^SSU("SSUSR",0,"SSUSR_Initials",userCode,userId))
	q:(userId=""||userId=0) "NoUserId"
	//审核日期
	s auditDate=$P($h,",",1)
	
	TSTART
	s rs=0
	&SQL(update dhc_pa_data.UnitResult set UnitResult_auditState=:auditState,UnitResult_auditDr=:userId,UnitResult_auditDate=:auditDate where UnitResult_schemDr=:schemDr and UnitResult_appSysDr=:appSysDr and UnitResult_jxUnitDr=:jxUnitDr and UnitResult_period=:newPeriod)
	i SQLCODE'=0 d
	.s rs=1
	e  d
	.s month=1
	.i currMonth=12 d
	..s month=currMonth
	.e  d
	..s month=currMonth+1
	.&SQL(update dhc_pa_data.Stratagem set Stratagem_month=:month where Stratagem_rowid=:stratagemDr)
	.i SQLCODE'=0 
	..s rs=1

	i rs'=0 d
	.TRollBack
	e  d
	.TCOMMIT

	q rs
}

/// Creator：李明忠
/// CreatDate：2010-9-8
/// Description: 根据条件查询审核情况
/// Table：dhc_pa_data.UnitResult
/// Input：cycleDr-年度Dr,period-期间,schemDr-方案Dr,jxUnitDr-绩效单元Dr
/// Output：
/// Return：审核信息字符串
/// Others：w ##class(dhc.pa.udata.uPAAudit).FindAuditStateInfo(1,1,"1||2",1)
ClassMethod FindAuditStateInfo(cycleDr, period, schemDr, jxUnitDr) As %String
{
	n (cycleDr,period,schemDr,jxUnitDr)
	
	q:cycleDr="" "NoData"
	q:period="" "NoData"
	q:schemDr="" "NoData"
	q:jxUnitDr="" "NoData"
	
	s stratagemDr=$P(schemDr,"||",1) 
	q:stratagemDr="" "NoData"
	
	//获取方案的报告频率、当前月份、应用系统号、考核年度
	s currMonth="",cycleId=""
	i $D(^DHCCJXPASTRATAGEM(stratagemDr)) d
	.i $G(^DHCCJXPASTRATAGEM(stratagemDr))'="" d
	..s currMonth=$P($G(^DHCCJXPASTRATAGEM(stratagemDr)),"^",8)
	..i currMonth'="" d
	...s cycleId=$P($G(^DHCCJXPASTRATAGEM(stratagemDr)),"^",2)
	
	q:cycleId'=cycleDr "NoData"
	q:currMonth="" "NoData"
	
	//获取年度代码
	s cycleCode=""
	i $D(^DHCCJXPACYCLE(cycleDr)) d
	.i $G(^DHCCJXPACYCLE(cycleDr))'="" s cycleCode=$P($G(^DHCCJXPACYCLE(cycleDr)),"^",1)
	q:cycleCode="" "NoData"
	s newPeriod=""
	i period'="00" d
	.i period<10 s newPeriod=cycleCode_"0"_period
	.e  s newPeriod=cycleCode_period
	e  s newPeriod=cycleCode_period
	q:newPeriod="" "NoData"
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select UnitResult_auditDr,UnitResult_auditDate,UnitResult_auditState from dhc_pa_data.UnitResult where UnitResult_childSub>0 and UnitResult_appSysDr=2"
	s whereStr=" and UnitResult_schemDr='"_schemDr_"'"
	s whereStr=whereStr_" and UnitResult_jxUnitDr="_jxUnitDr
	s whereStr=whereStr_" and UnitResult_period='"_newPeriod_"'"
	
	s sqlStr=sqlStr_whereStr
	
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s auditInfo="",userId="",auditDate="",userName="",auditState=""

	While(result.Next()){
		s auditState = result.Data("UnitResult_auditState")
		s userId = result.Data("UnitResult_auditDr")
		i userId'="" d
		.i $D(^SSU("SSUSR",userId)) d
		..i $G(^SSU("SSUSR",userId))'="" d
		...s userName=$P(^SSU("SSUSR",userId),"^",2)
		s auditDate = result.Data("UnitResult_auditDate")
		s auditDate=$ZD(auditDate,3)
		
		s auditInfo=userId_"^"_userName_"^"_auditDate_"^"_auditState
	}
	
	q auditInfo
}

/// Creator：李明忠
/// CreatDate：2010-9-8
/// Description: 取消审核
/// Table：dhc_pa_data.UnitResult
/// Input：cycleDr-年度Dr,period-期间,schemDr-方案Dr,jxUnitDr-绩效单元Dr
/// Output：
/// Return：SQLCODE
/// Others：w ##class(dhc.pa.udata.uPAAudit).ExeCancelAudit(1,1,"1||2",1)
ClassMethod ExeCancelAudit(cycleDr, period, schemDr, jxUnitDr) As %String
{
	n (cycleDr,period,schemDr,jxUnitDr)
	
	q:cycleDr="" "NoCycle"
	q:period="" "NoPeriod"
	q:schemDr="" "NoSchem"
	q:jxUnitDr="" "NoJXUnit"
	
	s stratagemDr=$P(schemDr,"||",1) 
	q:stratagemDr="" "NoStratagem"
	
	//获取方案的报告频率、当前月份、应用系统号、考核年度
	s currMonth="",cycleId=""
	i $D(^DHCCJXPASTRATAGEM(stratagemDr)) d
	.i $G(^DHCCJXPASTRATAGEM(stratagemDr))'="" d
	..s currMonth=$P($G(^DHCCJXPASTRATAGEM(stratagemDr)),"^",8)
	..i currMonth'="" d
	...s cycleId=$P($G(^DHCCJXPASTRATAGEM(stratagemDr)),"^",2)
	
	q:cycleId'=cycleDr "ErrCycle"
	q:currMonth="" "NoMonth"
	
	//获取年度代码
	s cycleCode=""
	i $D(^DHCCJXPACYCLE(cycleDr)) d
	.i $G(^DHCCJXPACYCLE(cycleDr))'="" s cycleCode=$P($G(^DHCCJXPACYCLE(cycleDr)),"^",1)
	q:cycleCode="" "NoCycleCode"
	s newPeriod=""
	i period'="00" d
	.i period<10 s newPeriod=cycleCode_"0"_period
	.e  s newPeriod=cycleCode_period
	e  s newPeriod=cycleCode_period
	q:newPeriod="" "NoPeriod"
	
	//审核状态
	s auditState=-1 
	//应用系统号
	s appSysDr=2
	//根据用户Code查找用户ID
	s userId=""
	//审核日期
	s auditDate=""
	
	TSTART
	s rs=0
	&SQL(update dhc_pa_data.UnitResult set UnitResult_auditState=:auditState,UnitResult_auditDr=:userId,UnitResult_auditDate=:auditDate where UnitResult_schemDr=:schemDr and UnitResult_appSysDr=:appSysDr and UnitResult_jxUnitDr=:jxUnitDr and UnitResult_period=:newPeriod)
	i SQLCODE'=0 
	.s rs=1
	e  d
	.s month=1
	.i currMonth=1 d
	..s month=currMonth
	.e  d
	..s month=currMonth-1
	.&SQL(update dhc_pa_data.Stratagem set Stratagem_month=:month where Stratagem_rowid=:stratagemDr)
	.i SQLCODE'=0 d
	..s rs=1

	i rs'=0 d
	.TRollBack
	e  d
	.TCOMMIT

	q rs
}

/// Creator：李明忠
/// CreatDate：2010-12-14
/// Description: 获取年度
/// Table：dhc_pa_data.Cycle
/// Input：start:开始记录位置;limit:单页记录条数;schemDr-方案ID
/// Output：
/// Return：有效绩效单位字符串
/// Others：w ##class(dhc.pa.udata.uPAAudit).GetCycle("Y",0,10,"")
ClassMethod GetCycle(active, start, limit, str) As %String
{
	n (active,start,limit,str)
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select Cycle_rowid,Cycle_code,Cycle_name,Cycle_shortcut,Cycle_desc,Cycle_active from dhc_pa_data.Cycle where Cycle_rowid>0 and Cycle_active='"_active_"'"
	s whereStr=""
	;i str'="" s whereStr=" and Cycle_name='"_str_"'"
	s sqlStr=sqlStr_whereStr
	
	d result.Prepare(sqlStr)
	d result.Execute()

	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("Cycle_rowid")
		s code = result.Data("Cycle_code")
		s name = result.Data("Cycle_name")
		s shortcut = result.Data("Cycle_shortcut")
		s desc = result.Data("Cycle_desc")
		s active = result.Data("Cycle_active")
		s tmp=rowid_"^"_code_"^"_name_"^"_shortcut_"^"_desc_"^"_active
		s count = count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("rowid^code^name^shortcut^desc^active",count)
 	k json
	q resultString
}

/// Creator：李明忠
/// CreatDate：2010-12-14
/// Description: 获取年度
/// Table：dhc_pa_data.Cycle
/// Input：start:开始记录位置;limit:单页记录条数;schemDr-方案ID
/// Output：
/// Return：有效绩效单位字符串
/// Others：w ##class(dhc.pa.udata.uPAAudit).GetCycle2("Y",1)
ClassMethod GetCycle2(active, cycleDr) As %String
{
	n (active,cycleDr)
	
	s result = ##class(%Library.ResultSet).%New()
	;s sqlStr = "select Cycle_rowid,Cycle_code,Cycle_name,Cycle_shortcut,Cycle_desc,Cycle_active from dhc_pa_data.Cycle where Cycle_rowid='"_cycleDr_"' and Cycle_active='"_active_"'"
	//20120206 
	s sqlStr = "select Cycle_rowid,Cycle_code,Cycle_name,Cycle_shortcut,Cycle_desc,Cycle_active from dhc_pa_data.Cycle where Cycle_active='Y' "
	
	d result.Prepare(sqlStr)
	d result.Execute()

	s count = 1
	s resultString = ""
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("Cycle_rowid")
		s code = result.Data("Cycle_code")
		s name = result.Data("Cycle_name")
		s shortcut = result.Data("Cycle_shortcut")
		s desc = result.Data("Cycle_desc")
		s active = result.Data("Cycle_active")
		s tmp=rowid_"^"_code_"^"_name_"^"_shortcut_"^"_desc_"^"_active
		d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("rowid^code^name^shortcut^desc^active",count)
 	k json
	q resultString
}

/// Creator：李明忠
/// CreatDate：2010-12-14
/// Description: 获取年度
/// Table：dhc_pa_data.Cycle
/// Input：start:开始记录位置;limit:单页记录条数;schemDr-方案ID
/// Output：
/// Return：有效绩效单位字符串
/// Others：w ##class(dhc.pa.udata.uPAAudit).GetSchem2("Y","","M","demo")
ClassMethod GetSchem2(active, str, periodType, userCode) As %String
{
	n (active,str,periodType,userCode)
	
	s userCode=$$ALPHAUP^SSUTIL4(userCode)
	//根据用户Code查找用户ID
	s userId=0
	s userId=$O(^SSU("SSUSR",0,"SSUSR_Initials",userCode,userId))
	
	
	s result = ##class(%Library.ResultSet).%New()
	//s sqlStr = "select Schem_rowid,Schem_shortcut,Schem_frequency from dhc_pa_data.Schem where Schem_childSub>0 and Schem_active='"_active_"' and Schem_frequency='"_periodType_"'"
	
	//2012-12-20修改 添加方案访问权限
	s sqlStr = "select distinct(Schem_rowid),Schem_shortcut,Schem_frequency from dhc_pa_data.Schem , dhc_pa_data.SchemAudit   where Schem_childSub>0 and  SAudit_SchemDr=Schem_rowid  and  SAudit_userDr ="_userId_"  and Schem_active='"_active_"' and Schem_frequency='"_periodType_"'"
	
	s whereStr=""
	i str'="" s whereStr=" and Schem_shortcut  like '%"_str_"%'   "
	s sortStr=" order by Schem_shortcut "
	s sqlStr=sqlStr_whereStr_sortStr
	;w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()

	s count = 0
	s resultString = ""
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("Schem_rowid")
		s shortcut = result.Data("Schem_shortcut")
		s frequency = result.Data("Schem_frequency")
		//s shortCutFreQuency=shortcut_"!"_frequency
		s shortCutFreQuency=shortcut
		s tmp=rowid_"^"_shortCutFreQuency
		s count=count+1
		d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("rowid^shortCutFreQuency",count)
 	k json
	q resultString
}

/// Creator：李明忠
/// CreatDate：2010-12-14
/// Description: 获取年度
/// Table：dhc_pa_data.Cycle
/// Input：start:开始记录位置;limit:单页记录条数;schemDr-方案ID
/// Output：
/// Return：有效绩效单位字符串
/// Others：w ##class(dhc.pa.udata.uPAAudit).GetSchem3("Y","M","demo")
ClassMethod GetSchem3(active, periodType, userCode) As %String
{
	n (active,periodType,userCode)
	
	
	s userCode=$$ALPHAUP^SSUTIL4(userCode)
	//根据用户Code查找用户ID
	s userId=0
	s userId=$O(^SSU("SSUSR",0,"SSUSR_Initials",userCode,userId))
	
	s result = ##class(%Library.ResultSet).%New()
	//s sqlStr = "select Schem_rowid,Schem_shortcut,Schem_frequency from dhc_pa_data.Schem , dhc_pa_data.SchemAudit  where Schem_rowid>0 and Schem_active='"_active_"' and Schem_frequency='"_periodType_"'"
	
	//2011-12-20修改  添加方案访问权限
	s sqlStr = "select Schem_rowid,Schem_shortcut,Schem_frequency from dhc_pa_data.Schem , dhc_pa_data.SchemAudit   where Schem_rowid>0 and Schem_active='"_active_"' and  SAudit_SchemDr=Schem_rowid  and  SAudit_userDr ="_userId_"  and Schem_frequency='"_periodType_"'  order by Schem_shortcut"
	;w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()

	s count = 1
	s resultString = ""
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("Schem_rowid")
		s shortcut = result.Data("Schem_shortcut")
		s frequency = result.Data("Schem_frequency")
		//s shortCutFreQuency=shortcut_"!"_frequency
		s shortCutFreQuency=shortcut
		s tmp=rowid_"^"_shortCutFreQuency
		d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("rowid^shortCutFreQuency",count)
 	k json
	q resultString
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.uPAAuditS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
