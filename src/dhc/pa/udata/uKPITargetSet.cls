/// Creator: 李明忠
/// CreatDate: 2010-8-23
/// Description: KPI目标设置(包括:科室、指标、目标分解执行)
Class dhc.pa.udata.uKPITargetSet Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator：李明忠
/// CreatDate：2010-8-23
/// Description: 根据当前月获取生成季度数量的Count
/// Table：
/// Input：currMonth-当前月
/// Output：
/// Return：返回数量Count
/// Others：w ##class(dhc.pa.udata.uKPITargetSet).GetCount(4)
ClassMethod GetCount(currMonth) As %String
{
	n (currMonth)
	
	s Count=0
	
	q:currMonth="" Count
	
	i (currMonth=1)||(currMonth=2)||(currMonth=3) s Count=4
	i (currMonth=4)||(currMonth=5)||(currMonth=6) s Count=3
	i (currMonth=7)||(currMonth=8)||(currMonth=9) s Count=2
	i (currMonth=10)||(currMonth=11)||(currMonth=12) s Count=1
	
	q Count
}

/// Creator：李明忠
/// CreatDate：2010-8-23
/// Description: 获取表头信息
/// Table：dhc_pa_data.UnitResultDetail
/// Input：cycleDr-战略年度Dr,schemDr-方案Dr
/// Output：
/// Return：表头信息字符串
/// Others：w ##class(dhc.pa.udata.uKPITargetSet).GetGridTitle(1,"1||23")
ClassMethod GetGridTitle(cycleDr, schemDr) As %String
{
	n (cycleDr,schemDr)
	
	//获取年度Code
	s cycleCode=""
	i $D(^DHCCJXPACYCLE(cycleDr)) d
	.i $G(^DHCCJXPACYCLE(cycleDr))'="" d
	..s cycleCode=$P($G(^DHCCJXPACYCLE(cycleDr)),"^",1)
	q:cycleCode="" "NoDatas"
	
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	s rowid=1,title="维度/指标/根名称",name="KPIName"
	s tmp=rowid_"^"_title_"^"_name
	d json.InsertRowData(tmp)
	s rowid=2,title="维度/指标/根代码",name="KPICode"
	s tmp=rowid_"^"_title_"^"_name
	d json.InsertRowData(tmp)
	s rowid=3,title="指标Dr",name="KPIDr"
	s tmp=rowid_"^"_title_"^"_name
	d json.InsertRowData(tmp)
	s rowid=4,title="科室名称",name="jxUnitName"
	s tmp=rowid_"^"_title_"^"_name
	d json.InsertRowData(tmp)
	s rowid=5,title="科室Dr",name="jxUnitDr"
	s tmp=rowid_"^"_title_"^"_name
	d json.InsertRowData(tmp)
	/*  2016-8-23 edit cyl
	s rowid=6,title="年度目标",name="month00"
	s tmp=rowid_"^"_title_"^"_name
	d json.InsertRowData(tmp)
	*/
	s stratagemDr=$P(schemDr,"||",1)
	i $D(^DHCCJXPASTRATAGEM(stratagemDr)) d
	.i $G(^DHCCJXPASTRATAGEM(stratagemDr))'="" d
	..s currMonth=$P($G(^DHCCJXPASTRATAGEM(stratagemDr)),"^",8)
	..i currMonth'="" d
	...s frequency=$P($G(^DHCCJXPASTRATAGEM(stratagemDr,"Schem",$P(schemDr,"||",2))),"^",5)
	...;返回整个表头信息
	...s resultString=..GetPeriodTitle(json,rowid,cycleCode,currMonth,frequency)
 	k json
 	
 	q resultString
}

/// Creator：李明忠
/// CreatDate：2010-8-23
/// Description: 获取考核期间表头信息
/// Table：dhc_pa_data.UnitResultDetail
/// Input：json-数据格式类;rowid-计数器;cycleCode-考核年度code;currMonth-月份,frequency-期间类型
/// Output：
/// Return：表头考核期间信息字符串
/// Others：w ##class(dhc.pa.udata.uKPITargetSet).GetPeriodTitle(4,"M")
ClassMethod GetPeriodTitle(json, rowid, cycleCode, currMonth, frequency) As %String
{
	n (json,rowid,cycleCode,currMonth,frequency)
	
	i frequency="M" d //月份
	.;生成当前月份至12月数据数量Count
	.s Count=13-currMonth
	.f i=1:1:Count d
	..s rowid=rowid+1
	..s month=(currMonth+i-1)
	..s title=month_"月"
	..i month<10 d
	...s month=0_month
	..s name="month"_month
	..s tmp=rowid_"^"_title_"^"_name
	..d json.InsertRowData(tmp)
	
	i frequency="Q" d //季度
	.;获取当前季度至第四季度数据数量Count
	.s Count=..GetCount(currMonth)
	.;根据当前月份获取起始季度
	.s startQuarter=..GetStartQuarter(currMonth)
	.f i=1:1:Count d
	..s rowid=rowid+1
	..s Quarter=(startQuarter+i-1)
	..s title="第"_Quarter_"季度"
	..s name="Quarter"_0_(startQuarter+i-1)
	..s tmp=rowid_"^"_title_"^"_name
	..d json.InsertRowData(tmp)
	
	i frequency="H" d //半年
	.;生成当前所属半年至下半年数据数量Count
	.i currMonth<7 s Count=2
	.e  s Count=1
	.;根据当前月份获取起始半年期间
	.s startHalfYear=..GetStartHalfYear(currMonth)
	.f i=1:1:Count d
	..s rowid=rowid+1
	..s HalfYear=(startHalfYear+i-1)
	..i HalfYear=2 s title=cycleCode_"下半年"
	..e  s title=cycleCode_"上半年"
	..s name="HYear"_0_HalfYear
	..s tmp=rowid_"^"_title_"^"_name
	..d json.InsertRowData(tmp)
	
	i frequency="Y" d //年
	.s rowid=rowid+1
	.s title=cycleCode_"年"
	.s name="Year"
	.s tmp=rowid_"^"_title_"^"_name
	.d json.InsertRowData(tmp)
	
	s resultString = ""
	s resultString = json.getJsonData("rowid^title^name",rowid)
	q resultString
}

/// Creator：李明忠
/// CreatDate：2010-8-23
/// Description: 获取起始季度
/// Table：
/// Input：currMonth-当前月份
/// Output：
/// Return：起始季度
/// Others：w ##class(dhc.pa.udata.uKPITargetSet).GetStartQuarter(6)
ClassMethod GetStartQuarter(currMonth) As %String
{
	n (currMonth)
	
	i $L(currMonth/3)=1  s startQuarter=currMonth/3
	e  d
	.i $E(currMonth/3,1)="." s startQuarter=1 
	.e  s startQuarter=$E(currMonth/3,1)+1
	
	q startQuarter
}

/// Creator：李明忠
/// CreatDate：2010-8-23
/// Description: 获取起始半年期间
/// Table：
/// Input：currMonth-当前月份
/// Output：
/// Return：起始半年期间
/// Others：w ##class(dhc.pa.udata.uKPITargetSet).GetStartHalfYear(6)
ClassMethod GetStartHalfYear(currMonth) As %String
{
	n (currMonth)
	
	i $L(currMonth/6)=1 s startHalfYear=currMonth/6
	e  d
	.i $E(currMonth/6,1)="." s startHalfYear=1
	.e  s startHalfYear=$E(currMonth/6,1)+1
	
	q startHalfYear
}

/// Creator：李明忠
/// CreatDate：2010-8-30
/// Description: 获取绩效单元考核方案下的方案明细
/// Table：dhc_pa_data.UnitResultDetail
/// Input：parent-父级节点;schemDr-绩效方案Dr;jxUnitDr-绩效部门ID;searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向
/// Output：
/// Return：返回parent下方案明细
/// Others：w ##class(dhc.pa.udata.uKPITargetSet).GetSchemDetailOfUnit("roo","1||1",4,"","","","")
/// Others：w ##class(dhc.pa.udata.uKPITargetSet).GetSchemDetailOfUnit("-1","1||1",4,"","","","")
ClassMethod GetSchemDetailOfUnit(parent, schemDr, jxUnitDr, searchField, searchValue, sortField, sortDir) As %String
{
	n (parent,schemDr,jxUnitDr,searchField,searchValue,sortField,sortDir)
	
	q:parent="" "NoDatas"
	q:schemDr="" "NoDatas"
	q:jxUnitDr="" "NoDatas"
	
	//获取绩效单位名称
	s jxUnitName=""
	i $D(^DHCCJXPAJXUNIT(jxUnitDr)) d
	.i $G(^DHCCJXPAJXUNIT(jxUnitDr))'="" d
	..s jxUnitName=$P(^DHCCJXPAJXUNIT(jxUnitDr),"^",3)
	
	//获取当前战略ID
	s stratagemDr=$P(schemDr,"||",1) 
	q:stratagemDr="" "NoDatas"
	
	//获取方案的报告频率、当前月份、应用系统号、考核年度
	s currMonth="",frequency="",appSysDr=""
	i $D(^DHCCJXPASTRATAGEM(stratagemDr)) d
	.i $G(^DHCCJXPASTRATAGEM(stratagemDr))'="" d
	..s currMonth=$P($G(^DHCCJXPASTRATAGEM(stratagemDr)),"^",8)
	..i currMonth'="" d
	...s frequency=$P($G(^DHCCJXPASTRATAGEM($P(schemDr,"||",1),"Schem",$P(schemDr,"||",2))),"^",5)
	...s appSysDr=$P(^DHCCJXPASTRATAGEM($P(schemDr,"||",1),"Schem",$P(schemDr,"||",2)),"^",4)
	...s cycleDr=$P($G(^DHCCJXPASTRATAGEM(stratagemDr)),"^",2)
	
	q:currMonth="" "NoDatas"
	q:frequency="" "NoDatas"
	q:appSysDr="" "NoDatas"
	q:cycleDr="" "NoDatas"
	
	//获取年度代码
	s cycleCode=""
	i $D(^DHCCJXPACYCLE(cycleDr)) d
	.i $G(^DHCCJXPACYCLE(cycleDr))'="" s cycleCode=$P($G(^DHCCJXPACYCLE(cycleDr)),"^",1)
	
	q:cycleCode="" "NoDatas"
	
	s urRowidStr=..GetTotalDr(stratagemDr,schemDr,jxUnitDr)
	s urRowid=$P(urRowidStr,"^",1)
	
	//先决定数据结构
	//规整查询条件
	s tmpEnd=""
	i parent="roo" s parent=0

	i parent'=0 d
	.s sqlStr="select UnitResultDetail_parRef,UnitResultDetail_rowid,UnitResultDetail_childSub,UnitResultDetail_KPIDr,UnitResultDetail_order,UnitResultDetail_isTarget,UnitResultDetail_parent from dhc_pa_data.UnitResultDetail,dhc_pa_data.KPIIndex1"
	.s whereStr=" where UnitResultDetail_KPIDr=KPIIndex1_rowid and UnitResultDetail_parRef='"_urRowid_"'"
	.s whereStr=whereStr_" and UnitResultDetail_parent ='"_parent_"'"
	.s sortStr=" ORDER BY KPIIndex1_code ASC"
	e  d
	.s sqlStr="select UnitResultDetail_parRef,UnitResultDetail_rowid,UnitResultDetail_childSub,UnitResultDetail_KPIDr,UnitResultDetail_order,UnitResultDetail_isTarget,UnitResultDetail_parent from dhc_pa_data.UnitResultDetail,dhc_pa_data.DimensType "
	.s whereStr=" WHERE UnitResultDetail_KPIDr=DimensType_rowid  AND UnitResultDetail_parRef='"_urRowid_"'"
	.s whereStr=whereStr_" and UnitResultDetail_parent ='"_parent_"'"
	.s sortStr=" ORDER BY DimensType_code ASC"

	s sqlStr=sqlStr_whereStr_sortStr
	;w sqlStr,!
	s resultString="["
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	//取结构
	While(result.Next()){
		//集体初始化
		s KPIIndexName="",KPICode="",Flag="false",distMethodName="",allDataStr=""
		
		s rowid = result.Data("UnitResultDetail_rowid")
		s order = result.Data("UnitResultDetail_order")
		s isTarget = result.Data("UnitResultDetail_isTarget")
		s parent = result.Data("UnitResultDetail_parent")
		s KPI = result.Data("UnitResultDetail_KPIDr")
		i isTarget=1 d
		.i KPI'="" d
		..i $d(^DHCCJXPADIMENSTYPE(KPI)) d
		...i $g(^DHCCJXPADIMENSTYPE(KPI)) d
		....s KPIIndexName = $P(^DHCCJXPADIMENSTYPE(KPI),"^",2)
		....s KPICode = $P(^DHCCJXPADIMENSTYPE(KPI),"^",1)
		....s KPI = "-"_KPI
		....s Flag = "false"
		
		;i isTarget=2 d
		i isTarget'=1 d
		.i KPI'="" d
		..i $d(^DHCCJXPAKPIINDEX1(KPI)) d
		...i $g(^DHCCJXPAKPIINDEX1(KPI)) d
		....s KPIIndexName = $P(^DHCCJXPAKPIINDEX1(KPI),"^",2)
		....s KPICode = $P(^DHCCJXPAKPIINDEX1(KPI),"^",1)
		....s isEnd = $P(^DHCCJXPAKPIINDEX1(KPI),"^",24)
		....i isEnd = "Y" d
		.....s Flag = "true"
		.....s allDataStr=..GetAllData(cycleCode,frequency,currMonth,urRowidStr,KPI)
		.....;w "isTarget:"_isTarget,!
		.....;w "1111"_..GetMethod(cycleCode,schemDr,KPI),!
		.....s allDataStr=allDataStr_..GetMethod(cycleCode,schemDr,KPI,isTarget)
		....i isEnd = "N" s Flag = "false"
			
		i allDataStr="" s resultString=resultString_"{id:'"_KPI_"',detailid:'"_rowid_"',KPIDr:'"_KPI_"',KPICode:'"_KPICode_"',KPIName:'"_KPIIndexName_"',order:'"_order_"',isTarget:'"_isTarget_"',jxUnitDr:'"_jxUnitDr_"',jxUnitName:'"_jxUnitName_"',parent:'"_parent_"',leaf:"_Flag_",uiProvider:'col'},"
		e  s resultString=resultString_"{id:'"_KPI_"',detailid:'"_rowid_"',KPIDr:'"_KPI_"',KPICode:'"_KPICode_"',KPIName:'"_KPIIndexName_"',order:'"_order_"',isTarget:'"_isTarget_"',jxUnitDr:'"_jxUnitDr_"',jxUnitName:'"_jxUnitName_"',parent:'"_parent_"',"_allDataStr_"leaf:"_Flag_",uiProvider:'col'},"
	}
		
	s resultString=resultString_"]"
	d result.Close()
	q resultString
}

/// Creator：李明忠
/// CreatDate：2010-8-30
/// Description: 查询总数据的相关ID
/// Table：dhc_pa_data.UnitResult
/// Input：stratagemDr-当前战略Dr,schemDr-方案Dr,jxUnitDr-绩效单元Dr
/// Output：
/// Return：总数据的相关ID字符串
/// Others：w ##class(dhc.pa.udata.uKPITargetSet).GetTotalDr(1,"1||1",4)
ClassMethod GetTotalDr(stratagemDr, schemDr, jxUnitDr) As %String
{
	n (stratagemDr,schemDr,jxUnitDr)
	
	q:stratagemDr="" "NoDatas"
	q:schemDr="" "NoDatas"
	q:jxUnitDr="" "NoDatas"
	
	//查询绩效单元考核主表UnitResult
	s sqlStr="select UnitResult_rowid from dhc_pa_data.UnitResult"
	s whereStr=" where UnitResult_childSub>0 and UnitResult_schemDr='"_schemDr_"'"
	s whereStr=whereStr_" and UnitResult_parRef ='"_stratagemDr_"'"
	s whereStr=whereStr_" and UnitResult_jxUnitDr ='"_jxUnitDr_"'"

	s sqlStr=sqlStr_whereStr
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s urRowidStr=""
	//取结构
	While(result.Next()){
		//单位考核主表方案
		s urRowid=result.Data("UnitResult_rowid")
		i urRowidStr="" s urRowidStr=urRowid
		e  s urRowidStr=urRowidStr_"^"_urRowid
	}
	
	q urRowidStr
}

/// Creator：李明忠
/// CreatDate：2010-8-30
/// Description: 获取月数据
/// Table：
/// Input：currMonth-当前月份
/// Output：
/// Return：返回月数据字符串
/// Others：w ##class(dhc.pa.udata.uKPITargetSet).GetAllData(2010,"M",1,"1||14^1||15^1||16^1||17^1||18^1||19^1||20^1||21^1||22^1||23^1||24^1||25^1||26",22)
ClassMethod GetAllData(cycleCode, frequency, currMonth, urRowidStr, KPIDr) As %String
{
	n (cycleCode,frequency,currMonth,urRowidStr,KPIDr)
	
	;i KPIDr=4 d
	;.w cycleCode_"!"_frequency_"!"_currMonth_"!"_urRowidStr_"!"_KPIDr,!
	
	q:cycleCode="" "NoDatas"
	q:frequency="" "NoDatas"
	q:currMonth="" "NoDatas"
	q:urRowidStr="" "NoDatas"
	q:KPIDr="" "NoDatas"

	s periodStr=""
	
	i frequency="M" d //月份
	.;生成当前月份至12月数据数量Count
	.s Count=14-currMonth
	.f i=1:1:Count d
	..s month=(currMonth+i-2)
	..i month<10 d
	...s month=0_month
	..s period=cycleCode_month
	..i periodStr="" s periodStr=period
	..e  s periodStr=periodStr_"^"_period
	
	i frequency="Q" d //季度
	.s periodStr=cycleCode_"00"
	.;获取当前季度至第四季度数据数量Count
	.s Count=..GetCount(currMonth)
	.;根据当前月份获取起始季度
	.s startQuarter=..GetStartQuarter(currMonth)
	.f i=1:1:Count d
	..s Quarter=(startQuarter+i-1)
	..s period=cycleCode_0_Quarter
	..i periodStr="" s periodStr=period
	..e  s periodStr=periodStr_"^"_period
	
	i frequency="H" d //半年
	.s periodStr=cycleCode_"00"
	.;生成当前所属半年至下半年数据数量Count
	.i currMonth<7 s Count=2
	.e  s Count=1
	.;根据当前月份获取起始半年期间
	.s startHalfYear=..GetStartHalfYear(currMonth)
	.f i=1:1:Count d
	..s Year=(startHalfYear+i-1)
	..s period=cycleCode_0_Year
	..i periodStr="" s periodStr=period
	..e  s periodStr=periodStr_"^"_period
	
	i frequency="Y" d //年
	.s periodStr=cycleCode_"00"
	
	s dataStr=""
	;w frequency_"~"_urRowidStr_"~"_periodStr_"~"_KPIDr,!
	s dataStr=..GetDataStr(frequency,urRowidStr,periodStr,KPIDr)
	
	q dataStr
}

/// Creator：李明忠
/// CreatDate：2010-8-30
/// Description: 获取月数据
/// Table：
/// Input：frequency-报告频率;urRowidStr-绩效单元考核主表Dr字符串;periodStr-考核周期字符串;KPIDr-kpi指标Dr
/// Output：
/// Return：返回月数据字符串
/// Others：w ##class(dhc.pa.udata.uKPITargetSet).GetDataStr("M","1||14^1||15^1||16^1||17^1||18^1||19^1||20^1||21^1||22^1||23^1||24^1||25^1||26","201000^201001^201002^201003^201004^201005^201006^201007^201008^201009^201010^201011^201012",22)
ClassMethod GetDataStr(frequency, urRowidStr, periodStr, KPIDr) As %String
{
	n (frequency,urRowidStr,periodStr,KPIDr)
	
	q:frequency="" "NoDatas"
	q:urRowidStr="" "NoDatas"
	q:periodStr="" "NoDatas"
	q:KPIDr="" "NoDatas"
	
	i frequency="M" s titleName="month"
	i frequency="Q" s titleName="Quarter"
	i frequency="H" s titleName="HYear"
	i frequency="Y" s titleName="Year"

	s dataStr=""
	s Len=$L(urRowidStr,"^")
	f k=1:1:Len d
	.s urRowid=$P(urRowidStr,"^",k)
	.i $E(($P(periodStr,"^",k)),5,6)="00" d
	..s name="month"_$E(($P(periodStr,"^",k)),5,6)
	.e  d
	..s name=titleName_$E(($P(periodStr,"^",k)),5,6)
	.s str=..GetData(urRowid,name,KPIDr)
	.i dataStr="" s dataStr=str
	.e  s dataStr=dataStr_str
	
	q dataStr
}

/// Creator：李明忠
/// CreatDate：2010-8-30
/// Description: 获取指定月的KPI数据
/// Table：dhc_pa_data.UnitResultDetail
/// Input：urRowid-绩效单元考核主表Dr;titleName-动态表头名称;KPIDr-KPI指标Dr
/// Output：
/// Return：返回指定月的KPI数据
/// Others：w ##class(dhc.pa.udata.uKPITargetSet).GetData("1||14","month00",22)
ClassMethod GetData(urRowid, titleName, KPIDr) As %String
{
	n (urRowid,titleName,KPIDr)
	
	;w urRowid_"^"_titleName_"^"_KPIDr,!
	
	s isTarget=2
	
	q:urRowid="" "NoDatas"
	q:titleName="" "NoDatas"
	q:KPIDr="" "NoDatas"

	//查询绩效单元考核主表UnitResult
	s sqlStr="select UnitResultDetail_tValue from dhc_pa_data.UnitResultDetail"
	s whereStr=" where UnitResultDetail_childSub>0 and UnitResultDetail_parRef='"_urRowid_"'"
	s whereStr=whereStr_" and UnitResultDetail_KPIDr ='"_KPIDr_"'"
	s whereStr=whereStr_" and UnitResultDetail_isTarget ='"_isTarget_"'"

	s sqlStr=sqlStr_whereStr
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s kpiStr=""
	//取结构
	While(result.Next()){
		//单位考核主表方案
		s tValue=result.Data("UnitResultDetail_tValue")
		i tValue="" s tValue=0
		s tValue=$fn(tValue,"",2)
		s kpiStr=titleName_":'"_tValue_"',"
	}
	
	q kpiStr
}

/// Creator：李明忠
/// CreatDate：2010-8-31
/// Description: 获取KPI的分解方法所需条件
/// Table：dhc_pa_data.UnitResult
/// Input：cycleCode-考核周期Dr;schemDr-方案Dr;KPIDr-KPI指标Dr
/// Output：
/// Return：返回方法字符串
/// Others：w ##class(dhc.pa.udata.uKPITargetSet).GetMethod("2010","1||2",21)
ClassMethod GetMethod(cycleCode, schemDr, KPIDr, isTarget) As %String
{
	n (cycleCode,schemDr,KPIDr,isTarget)
	
	;w cycleCode_"^"_schemDr_"^"_KPIDr,!
	
	q:cycleCode="" "NoDatas"
	q:schemDr="" "NoDatas"
	q:KPIDr="" "NoDatas"
	
	s period=cycleCode_"00"

	//查询绩效单元考核主表UnitResult
	s sqlStr="select UnitResult_rowid from dhc_pa_data.UnitResult"
	;s whereStr=" where UnitResult_childSub>0 and UnitResult_period='"_period_"'"
	;s whereStr=whereStr_" and UnitResult_schemDr ='"_schemDr_"'"
	
	s whereStr=" where UnitResult_childSub>0  and  UnitResult_schemDr ='"_schemDr_"'"
	s whereStr=whereStr_"  and UnitResult_period='"_period_"'"


	s sqlStr=sqlStr_whereStr
	;w sqlStr,!
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s urRowid=""
	//取结构
	While(result.Next()){
		//单位考核主表方案
		s urRowid=result.Data("UnitResult_rowid")
	}
	
	q:urRowid="" "NoDatas"
	;w urRowid_"^"_KPIDr,!
	s methodStr=..GetMethodStr(urRowid,KPIDr,isTarget)
	
	q methodStr
}

/// Creator：李明忠
/// CreatDate：2010-8-31
/// Description: 获取KPI的分解方法
/// Table：dhc_pa_data.UnitResultDetail
/// Input：urRowid-父表Dr;schemDr-方案Dr;KPIDr-KPI指标Dr
/// Output：
/// Return：返回方法字符串
/// Others：w ##class(dhc.pa.udata.uKPITargetSet).GetMethodStr("2||1093",20)
ClassMethod GetMethodStr(urRowid, KPIDr, isTarget) As %String
{
	n (urRowid,KPIDr,isTarget)
	
	;w urRowid_"^"_KPIDr,!
	
	
	;s isTarget=2
	
	s sqlStr="select UnitResultDetail_distMethodDr from dhc_pa_data.UnitResultDetail"
	s whereStr=" where UnitResultDetail_childSub>0 and UnitResultDetail_parRef='"_urRowid_"'"
	s whereStr=whereStr_" and UnitResultDetail_KPIDr ='"_KPIDr_"'"
	s whereStr=whereStr_" and UnitResultDetail_isTarget ='"_isTarget_"'"

	s sqlStr=sqlStr_whereStr
	;w sqlStr,!
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s methodStr="",distMethodDrStr="distMethodDr",distMethodNameStr="distMethodName"
	//取结构
	While(result.Next()){
		//单位考核主表方案
		s distMethodDr=result.Data("UnitResultDetail_distMethodDr")
		i distMethodDr = "" s distMethodName = ""
		i distMethodDr = 4 s distMethodName = "不分解"
		i distMethodDr = 1 s distMethodName = "全面贯彻"
		i distMethodDr = 2 s distMethodName = "比例贯彻"
		i distMethodDr = 3 s distMethodName = "比例系数"
		
		s methodStr=distMethodDrStr_":'"_distMethodDr_"',"
		
		s methodStr=methodStr_distMethodNameStr_":'"_distMethodName_"',"
	}
	
	q methodStr
}

/// Creator：李明忠
/// CreatDate：2010-8-31
/// Description: 设置或修改年度目标数据
/// Table：
/// Input：CycleDr-年度Dr;SchemDr-方案Dr;KPIDr-KPI指标Dr;DeptDr-绩效单元Dr;YearData-年度目标值
/// Output：
/// Return：返回成功或失败标志
/// Others：w ##class(dhc.pa.udata.uKPITargetSet).SetYearData(2,"2||2",20,13,30)
ClassMethod SetYearData(CycleDr, SchemDr, KPIDr, DeptDr, YearData) As %String
{
	n (CycleDr,SchemDr,KPIDr,DeptDr,YearData)
	;2^2||2^20^13^3
	;s ^TMPLY(1)=CycleDr_"^"_SchemDr_"^"_KPIDr_"^"_DeptDr_"^"_YearData
	q:CycleDr="" "NoDatas"
	q:SchemDr="" "NoDatas"
	q:KPIDr="" "NoDatas"
	q:DeptDr="" "NoDatas"
	
	//获取当前战略ID
	s stratagemDr=$P(SchemDr,"||",1) 
	q:stratagemDr="" "NoDatas"
	
	//获取方案的报告频率、当前月份、应用系统号、考核年度
	s cycleDr=""
	i $D(^DHCCJXPASTRATAGEM(stratagemDr)) d
	.i $G(^DHCCJXPASTRATAGEM(stratagemDr))'="" d
	..s currMonth=$P($G(^DHCCJXPASTRATAGEM(stratagemDr)),"^",8)
	..i currMonth'="" d
	...s cycleDr=$P($G(^DHCCJXPASTRATAGEM(stratagemDr)),"^",2)

	q:CycleDr'=cycleDr "NoDatas"
	
	//获取年度代码
	s cycleCode=""
	i $D(^DHCCJXPACYCLE(cycleDr)) d
	.i $G(^DHCCJXPACYCLE(cycleDr))'="" s cycleCode=$P($G(^DHCCJXPACYCLE(cycleDr)),"^",1)
	
	q:cycleCode="" "NoDatas"
	
	//获取要设置的年度目标期间
	s period=cycleCode_"00"
	
	s urRowid=..GetUpdateRecoordRowid(stratagemDr,DeptDr,SchemDr,period)
	q:urRowid="" "NoDatas"
	
	s SQLCODE=..SetYearValue(urRowid,KPIDr,YearData)
	
	q SQLCODE
}

/// Creator：李明忠
/// CreatDate：2010-8-31
/// Description: 查询要设置的记录Rowid
/// Table：dhc_pa_data.UnitResult
/// Input：stratagemDr-当前战略Dr,SchemDr-方案Dr,DeptDr-绩效单元Dr,period-要设置的年度目标期间
/// Output：
/// Return：要设置的记录Rowid
/// Others：w ##class(dhc.pa.udata.uKPITargetSet).GetUpdateRecoordRowid(1,1,"1||2","201000")
ClassMethod GetUpdateRecoordRowid(stratagemDr, DeptDr, SchemDr, period) As %String
{
	n (stratagemDr,DeptDr,SchemDr,period)
	
	q:stratagemDr="" "NoDatas"
	q:SchemDr="" "NoDatas"
	q:DeptDr="" "NoDatas"
	q:period="" "NoDatas"
	
	//查询绩效单元考核主表UnitResult
	s sqlStr="select UnitResult_rowid from dhc_pa_data.UnitResult"
	s whereStr=" where UnitResult_childSub>0 and UnitResult_schemDr='"_SchemDr_"'"
	s whereStr=whereStr_" and UnitResult_parRef ='"_stratagemDr_"'"
	s whereStr=whereStr_" and UnitResult_jxUnitDr ='"_DeptDr_"'"
	s whereStr=whereStr_" and UnitResult_period ='"_period_"'"

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
/// CreatDate：2010-8-31
/// Description:设置年度目标值
/// Table：dhc_pa_data.UnitResultDetail
/// Input：urRowid-绩效单元考核主表Dr;KPIDr-KPI指标Dr;YearData-年度目标值
/// Output：
/// Return：SQLCODE
/// Others：w ##class(dhc.pa.udata.uKPITargetSet).SetYearValue("1||14",21,22.6)
ClassMethod SetYearValue(urRowid, KPIDr, YearData) As %String
{
	n (urRowid,KPIDr,YearData)
		
	s isTarget=2
	
	;w urRowid_"^"_KPIDr_"^"_YearData,!
		
	&SQL(update dhc_pa_data.UnitResultDetail set UnitResultDetail_tValue=:YearData where UnitResultDetail_KPIDr=:KPIDr and UnitResultDetail_parRef=:urRowid and UnitResultDetail_isTarget=:isTarget)
	q SQLCODE
}

/// Creator：李明忠
/// CreatDate：2010-8-31
/// Description: 执行指标分解
/// Table：
/// Input：CycleDr-年度Dr;SchemDr-方案Dr;KPIDr-KPI指标Dr;DeptDr-绩效单元Dr;YearData-年度目标值;DistMethodDr-分解方法
/// Output：
/// Return：返回成功或失败标志
/// Others：w ##class(dhc.pa.udata.uKPITargetSet).ExecDistKPI(1,"1||1",4,7,1500,3)
ClassMethod ExecDistKPI(CycleDr, SchemDr, KPIDr, DeptDr, YearData, DistMethodDr) As %String
{
	n (CycleDr,SchemDr,KPIDr,DeptDr,YearData,DistMethodDr)
	
	q:CycleDr="" "NoCycleDr"
	q:SchemDr="" "NoSchemDr"
	q:KPIDr="" "NoKPIDr"
	q:DeptDr="" "NoDeptDr"
	q:YearData="" "NoYearData"
	q:DistMethodDr="" "UnDistMethodDr"
	
	q:DistMethodDr=4 "UnDistMethodDr" //分解方法为"不分解",即退出程序
	
	//获取当前战略ID
	s stratagemDr=$P(SchemDr,"||",1) 
	q:stratagemDr="" "NoDatas"
	
	s urRowidStr=..GetTotalDr(stratagemDr,SchemDr,DeptDr) //带有年度
	q:urRowidStr="" "NoDatas"
	s Len=$L(urRowidStr,"^")
	
	TSTART
	s rs=0,flag="true"
	
	//全面贯彻,即:年度值完全复制到各个月份
	i DistMethodDr = 1 d 
	.f k=1:1:Len d
	..s urRowid=$P(urRowidStr,"^",k)
	..i urRowid'="" d
	...s period=..GetPeriod(urRowid)
	...i $E(period,5,6)'="00" d
	....s distValue=YearData
	....s rs=..SetDistData(urRowid, KPIDr, distValue)
		
	//比例贯彻,即:各月的目标值 =年度值×各月的比例系数
	i DistMethodDr = 2 d
	.f k=1:1:Len d
	..s urRowid=$P(urRowidStr,"^",k)
	..i urRowid'="" d
	...s period=..GetPeriod(urRowid)
	...i $E(period,5,6)'="00" d
	....s distRate=..GetDistRate(urRowid,KPIDr)
	....s distValue=YearData*distRate/100
	....s rs=..SetDistData(urRowid, KPIDr, distValue)
	....;i rs'=0 b
	//比例系数,即:各月的目标值 =年度值×各月系数值占全年系数值的的比例
	i DistMethodDr = 3 d
	.s newURRowidStr=""
	.f k=1:1:Len d
	..s urRowid=$P(urRowidStr,"^",k)
	..i urRowid'="" d
	...s period=..GetPeriod(urRowid)
	...i $E(period,5,6)'="00" d 
	....i newURRowidStr="" s newURRowidStr=urRowid
	....e  s newURRowidStr=newURRowidStr_"^"_urRowid
	.s totalDistRate=..GetTotalDistRate(newURRowidStr,KPIDr)
	.;w totalDistRate,!
	.f m=1:1:$L(newURRowidStr,"^") d
	..s urRowid=$P(newURRowidStr,"^",m)
	..i urRowid'="" d
	...s distRate=..GetDistRate(urRowid,KPIDr)
	...i totalDistRate'=0 d
	....s distValue=YearData*distRate/totalDistRate
	...e  d
	....s distValue=0
	...s rs=..SetDistData(urRowid, KPIDr, distValue)
	
	i rs'=0 d
	.TRollBack
	.s flag="false"
	e  d
	.TCOMMIT
	
	q flag
}

/// Creator：李明忠
/// CreatDate：2010-8-31
/// Description:设置年度目标值
/// Table：dhc_pa_data.UnitResultDetail
/// Input：urRowid-绩效单元考核主表Dr;KPIDr-KPI指标Dr;distValue-分解值
/// Output：
/// Return：SQLCODE
/// Others：w ##class(dhc.pa.udata.uKPITargetSet).SetYearValue("1||48||16",21,22.6)
ClassMethod SetDistData(urRowid, KPIDr, distValue) As %String
{
	n (urRowid,KPIDr,distValue)
	
	s isTarget=2
		
	&SQL(update dhc_pa_data.UnitResultDetail set UnitResultDetail_tValue=:distValue where UnitResultDetail_KPIDr=:KPIDr and UnitResultDetail_parRef=:urRowid and UnitResultDetail_isTarget=:isTarget)
	q SQLCODE
}

/// Creator：李明忠
/// CreatDate：2010-8-31
/// Description: 查询考核期间
/// Table：dhc_pa_data.UnitResult
/// Input：urRowid-绩效单元考核主表Dr
/// Output：
/// Return：考核期间
/// Others：w ##class(dhc.pa.udata.uKPITargetSet).GetPeriod("1||14")
ClassMethod GetPeriod(urRowid) As %String
{
	n (urRowid)
	
	q:urRowid="" "NoDatas"
	
	//查询绩效单元考核主表UnitResult
	s sqlStr="select UnitResult_period from dhc_pa_data.UnitResult"
	s whereStr=" where UnitResult_childSub>0 and UnitResult_rowid='"_urRowid_"'"

	s sqlStr=sqlStr_whereStr
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s period=""
	
	While(result.Next()){
		s period=result.Data("UnitResult_period")
	}
	
	q period
}

/// Creator：李明忠
/// CreatDate：2010-8-31
/// Description: 根据条件查询各考核期间的比例系数
/// Table：dhc_pa_data.UnitResultDetail
/// Input：urRowid-绩效单元考核主表Dr;KPIDr-KPI指标Dr
/// Output：
/// Return：各考核期间的比例系数
/// Others：w ##class(dhc.pa.udata.uKPITargetSet).GetDistRate("1||17",21)
ClassMethod GetDistRate(urRowid, KPIDr) As %String
{
	n (urRowid,KPIDr)
	
	q:urRowid="" "NoDatas"
	q:KPIDr="" "NoDatas"
	
	s isTarget=2
	
	s sqlStr="select UnitResultDetail_distRate from dhc_pa_data.UnitResultDetail"
	s whereStr=" where UnitResultDetail_childSub>0 and UnitResultDetail_parRef='"_urRowid_"'"
	s whereStr=whereStr_" and UnitResultDetail_KPIDr ='"_KPIDr_"'"
	s whereStr=whereStr_" and UnitResultDetail_isTarget ='"_isTarget_"'"

	s sqlStr=sqlStr_whereStr
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s distRate=""
	
	While(result.Next()){
		s distRate=result.Data("UnitResultDetail_distRate")
	}
	
	q distRate
}

/// Creator：李明忠
/// CreatDate：2010-8-31
/// Description: 根据条件查询考核期间的比例系数总和
/// Table：
/// Input：urRowid-绩效单元考核主表Dr;KPIDr-KPI指标Dr
/// Output：
/// Return：各考核期间的比例系数
/// Others：w ##class(dhc.pa.udata.uKPITargetSet).GetTotalDistRate("1||15^1||16^1||17^1||18^1||19^1||20^1||21^1||22^1||23^1||24^1||25^1||26",21)
ClassMethod GetTotalDistRate(newURRowidStr, KPIDr) As %String
{
	n (newURRowidStr,KPIDr)
	
	q:newURRowidStr="" "NoDatas"
	q:KPIDr="" "NoDatas"
	
	s Len=$L(newURRowidStr,"^")
	s totalDistRate=0
	
	f k=1:1:Len d
	.s urRowid=$P(newURRowidStr,"^",k)
	.i urRowid'="" d
	..s distRate=..GetDistRate(urRowid,KPIDr)
	..i distRate'="" d
	...s totalDistRate=totalDistRate+distRate
	
	q totalDistRate
}

/// Creator：李明忠
/// CreatDate：2010-8-31
/// Description: 根据方案查询所有绩效单元
/// Table：dhc_pa_data.UnitSchem
/// Input：schemDr-方案Dr
/// Output：
/// Return：返回绩效单元组合字符串
/// Others：w ##class(dhc.pa.udata.uKPITargetSet).GetAllJXUnitDr("1||2")
ClassMethod GetAllJXUnitDr(schemDr) As %String
{
	n (schemDr)
	
	q:schemDr="" "NoUnit"
	
	s sqlStr="select UnitSchem_parRef from dhc_pa_data.UnitSchem"
	s whereStr=" where UnitSchem_childSub>0 and UnitSchem_schemDr='"_schemDr_"'"

	s sqlStr=sqlStr_whereStr
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s jxUnitDrStr=""
	
	While(result.Next()){
		s jxUnitDr=result.Data("UnitSchem_parRef")
		i jxUnitDrStr="" s jxUnitDrStr=jxUnitDr
		e  s jxUnitDrStr=jxUnitDrStr_"^"_jxUnitDr
	}
	
	q jxUnitDrStr
}

/// Creator：李明忠
/// CreatDate：2010-9-1
/// Description: 批量执行指标分解
/// Table：
/// Input：CycleDr-年度Dr;SchemDr-方案Dr;KPIDr-KPI指标Dr;DeptDr-绩效单元Dr
/// Output：
/// Return：返回成功或失败标志
/// Others：w ##class(dhc.pa.udata.uKPITargetSet).ExecBatchDistKPI(1,"1||1","","")
ClassMethod ExecBatchDistKPI(CycleDr, SchemDr, KPIDr, DeptDr) As %String
{
	n (CycleDr,SchemDr,KPIDr,DeptDr)
	
	q:CycleDr="" "UnDist"
	q:SchemDr="" "UnDist"
	
	//获取当前战略ID
	s stratagemDr=$P(SchemDr,"||",1) 
	q:stratagemDr="" "NoDatas"
	
	s cycleDr=""
	i $D(^DHCCJXPASTRATAGEM(stratagemDr)) d
	.i $G(^DHCCJXPASTRATAGEM(stratagemDr))'="" d
	..s currMonth=$P($G(^DHCCJXPASTRATAGEM(stratagemDr)),"^",8)
	..i currMonth'="" d
	...s cycleDr=$P($G(^DHCCJXPASTRATAGEM(stratagemDr)),"^",2)
	q:cycleDr'=CycleDr "NoDatas"
	
	//获取年度代码
	s cycleCode=""
	i $D(^DHCCJXPACYCLE(cycleDr)) d
	.i $G(^DHCCJXPACYCLE(cycleDr))'="" s cycleCode=$P($G(^DHCCJXPACYCLE(cycleDr)),"^",1)
	q:cycleCode="" "NoDatas"
	
	//定义UnitResultRowid字符串使用全局变量
	s urRowidStr=""
	
	TSTART
	s rs=0,flag="true"
	
	//kpi指标和科室均不为空
	i ((KPIDr'="")&&(DeptDr'="")) d
	.s distMethodDr="",yearTarget=""
	.s urRowidStr=..GetTotalDr(stratagemDr,SchemDr,DeptDr) //带有年度
	.i urRowidStr'="" d
	..;获取指标分解方法
	..f k=1:1:$L(urRowidStr,"^") d
	...s urRowid=$P(urRowidStr,"^",k)
	...i urRowid'="" d
	....s period=..GetPeriod(urRowid)
	....i $E(period,5,6)="00" d
	.....;查询年度目标和指标分解方法
	.....s methodAndYearTarget=..GetMethodAndYearTarget(urRowid,KPIDr)
	.....;w methodAndYearTarget,!
	.....s distMethodDr=$P(methodAndYearTarget,"^",1)
	.....s yearTarget=$P(methodAndYearTarget,"^",2)
	.....i (distMethodDr'="")&&(yearTarget'="") d
	......s flag= ..ExecDistKPI(CycleDr, SchemDr, KPIDr, DeptDr, yearTarget, distMethodDr)
	......i flag'="true" s rs=1
	
	//kpi指标为空和科室不为空
	i ((KPIDr="")&&(DeptDr'="")) d
	.s distMethodDr="",yearTarget="",KPIDrStr=""
	.s urRowidStr=..GetTotalDr(stratagemDr,SchemDr,DeptDr) //带有年度
	.i urRowidStr'="" d
	..f k=1:1:$L(urRowidStr,"^") d
	...s urRowid=$P(urRowidStr,"^",k)
	...i urRowid'="" d
	....s period=..GetPeriod(urRowid)
	....i $E(period,5,6)="00" d
	.....;1.获取KPIDrStr
	.....s KPIDrStr=..GetKPIDrStr(urRowid)
	.....f i=1:1:$L(KPIDrStr,"^") d
	......s KPIDr=$P(KPIDrStr,"^",i)
	......i KPIDr'="" d
	.......;查询年度目标和指标分解方法
	.......s methodAndYearTarget=..GetMethodAndYearTarget(urRowid,KPIDr)
	.......s distMethodDr=$P(methodAndYearTarget,"^",1)
	.......s yearTarget=$P(methodAndYearTarget,"^",2)
	.......i (distMethodDr'="")&&(yearTarget'="") d
	........s flag= ..ExecDistKPI(CycleDr, SchemDr, KPIDr, DeptDr, yearTarget, distMethodDr)
	........i flag'="true" s rs=1
	
	//kpi指标不为空和科室为空
	i ((KPIDr'="")&&(DeptDr="")) d
	.s distMethodDr="",yearTarget="",jxUnitDrStr=""
	.;根据方案查询绩效单元
	.s jxUnitDrStr=..GetAllJXUnitDr(SchemDr)
	.f k=1:1:$L(jxUnitDrStr,"^") d
	..s DeptDr=$P(jxUnitDrStr,"^",k)
	..i DeptDr'="" d
	...s urRowidStr=..GetTotalDr(stratagemDr,SchemDr,DeptDr) //带有年度
	...i urRowidStr'="" d
	....f i=1:1:$L(urRowidStr,"^") d
	.....s urRowid=$P(urRowidStr,"^",i)
	.....i urRowid'="" d
	......s period=..GetPeriod(urRowid)
	......i $E(period,5,6)="00" d
	.......;查询年度目标和指标分解方法
	.......s methodAndYearTarget=..GetMethodAndYearTarget(urRowid,KPIDr)
	.......s distMethodDr=$P(methodAndYearTarget,"^",1)
	.......s yearTarget=$P(methodAndYearTarget,"^",2)
	.......i (distMethodDr'="")&&(yearTarget'="") d
	........s flag= ..ExecDistKPI(CycleDr, SchemDr, KPIDr, DeptDr, yearTarget, distMethodDr)
	........i flag'="true" s rs=1
	
	//kpi指标和科室均为空
	i ((KPIDr="")&&(DeptDr="")) d
	.s distMethodDr="",yearTarget="",KPIDrStr="",jxUnitDrStr=""
	.;首先获取绩效单元
	.s jxUnitDrStr=..GetAllJXUnitDr(SchemDr)
	.f k=1:1:$L(jxUnitDrStr,"^") d
	..s DeptDr=$P(jxUnitDrStr,"^",k)
	..i DeptDr'="" d
	...s urRowidStr=..GetTotalDr(stratagemDr,SchemDr,DeptDr) //带有年度
	...i urRowidStr'="" d
	....f i=1:1:$L(urRowidStr,"^") d
	.....s urRowid=$P(urRowidStr,"^",i)
	.....i urRowid'="" d
	......s period=..GetPeriod(urRowid)
	......i $E(period,5,6)="00" d
	.......s KPIDrStr=..GetKPIDrStr(urRowid)
	.......f m=1:1:$L(KPIDrStr,"^") d
	........s KPIDr=$P(KPIDrStr,"^",m)
	........i KPIDr'="" d
	.........;查询年度目标和指标分解方法
	.........s methodAndYearTarget=..GetMethodAndYearTarget(urRowid,KPIDr)
	.........s distMethodDr=$P(methodAndYearTarget,"^",1)
	.........s yearTarget=$P(methodAndYearTarget,"^",2)
	.........i (distMethodDr'="")&&(yearTarget'="") d
	..........s flag= ..ExecDistKPI(CycleDr, SchemDr, KPIDr, DeptDr, yearTarget, distMethodDr)
	..........i flag'="true" s rs=1
	
	i rs'=0 d
	.TRollBack
	.s flag="false"
	e  d
	.TCOMMIT
	
	q flag
}

/// Creator：李明忠
/// CreatDate：2010-9-1
/// Description: 获取KPI的分解方法和年度目标
/// Table：dhc_pa_data.UnitResultDetail
/// Input：urRowid-父表Dr;KPIDr-KPI指标Dr
/// Output：
/// Return：返回分解方法和年度目标字符串
/// Others：w ##class(dhc.pa.udata.uKPITargetSet).GetMethodAndYearTarget("1||14",21)
ClassMethod GetMethodAndYearTarget(urRowid, KPIDr) As %String
{
	n (urRowid,KPIDr)
	
	s isTarget=2
	
	s sqlStr="select UnitResultDetail_distMethodDr,UnitResultDetail_tValue from dhc_pa_data.UnitResultDetail"
	s whereStr=" where UnitResultDetail_childSub>0 and UnitResultDetail_parRef='"_urRowid_"'"
	s whereStr=whereStr_" and UnitResultDetail_KPIDr ='"_KPIDr_"'"
	s whereStr=whereStr_" and UnitResultDetail_isTarget ='"_isTarget_"'"

	s sqlStr=sqlStr_whereStr
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s methodAndYearTarget=""
	//取结构
	While(result.Next()){
		//单位考核主表方案
		s distMethodDr=result.Data("UnitResultDetail_distMethodDr")
		s tValue=result.Data("UnitResultDetail_tValue")
		s methodAndYearTarget=distMethodDr_"^"_tValue
	}
	
	q methodAndYearTarget
}

/// Creator：李明忠
/// CreatDate：2010-9-1
/// Description: 获取KPIDr
/// Table：dhc_pa_data.UnitResultDetail
/// Input：urRowid-父表Dr
/// Output：
/// Return：返回KPIDr字符串
/// Others：w ##class(dhc.pa.udata.uKPITargetSet).GetKPIDrStr("1||14")
ClassMethod GetKPIDrStr(urRowid) As %String
{
	n (urRowid)
	
	s sqlStr="select UnitResultDetail_KPIDr from dhc_pa_data.UnitResultDetail"
	s whereStr=" where UnitResultDetail_childSub>0 and UnitResultDetail_isTarget=2 and UnitResultDetail_parRef='"_urRowid_"'"
	
	s sqlStr=sqlStr_whereStr
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s KPIDrStr=""
	
	While(result.Next()){
		s KPIDr=result.Data("UnitResultDetail_KPIDr")
		i KPIDr'="" d
		.;i $D(^DHCCJXPAKPIINDEX1(KPIDr)) d  //2014-04-16 wy
		.;.i $G(^DHCCJXPAKPIINDEX1(KPIDr))'="" d
		.;..s isEnd=$P(^DHCCJXPAKPIINDEX1(KPIDr),"^",24)
		.;..i isEnd="Y" d
		.i KPIDrStr="" d
		..s KPIDrStr=KPIDr
		.e  d
		..s KPIDrStr=KPIDrStr_"^"_KPIDr
	}
	
	q KPIDrStr
}

/// Creator: wang ying
/// CreatDate：2011-02-21
/// Description: 查询总数据的相关ID
/// Table：dhc_pa_data.UnitResult
/// Input：stratagemDr-当前战略Dr,schemDr-方案Dr,jxUnitDr-绩效单元Dr
/// Output：
/// Return：总数据的相关ID字符串
/// Others：w ##class(dhc.pa.udata.uKPITargetSet).getTargetInfo("", "","rowid","DESC",0,25,"201302", "M", 5)
ClassMethod getTargetInfo(searchField, searchValue, sortField, sortDir, start, limit, period, frequency, KPIDr) As %String
{
	n (searchField, searchValue, sortField, sortDir, start, limit,period, frequency, KPIDr)
	
	q:period="" "NoDatas"
	q:frequency="" "NoDatas"
	q:KPIDr="" "NoDatas"
	
	//查询绩效单元考核主表UnitResult
	//2012-01-16 改 增加条件   UnitResultDetail_isTarget=2
	s sqlStr="SELECT UnitResult_rowid, UnitResult_jxUnitDr, JXUnit_name,JXUnit_code,UnitResultDetail_rowid,UnitResultDetail_tValue AS tValue,UnitResultDetail_bValue AS bValue,UnitResultDetail_baseValue AS baseValue FROM (dhc_pa_data.JXUnit INNER JOIN dhc_pa_data.UnitResult ON dhc_pa_data.JXUnit.JXUnit_rowid=dhc_pa_data.UnitResult.UnitResult_jxUnitDr) INNER JOIN dhc_pa_data.UnitResultDetail ON dhc_pa_data.UnitResult.UnitResult_rowid=dhc_pa_data.UnitResultDetail.UnitResultDetail_parRef WHERE UnitResultDetail_KPIDr="_KPIDr_" and UnitResultDetail_isTarget=2 and UnitResult_period="_"'"_period_"'"
	;w sqlStr,!
	s sortStr=""
	s sortField1=""
		
	i sortField'="" d
	.i sortField="rowid" s sortField1="UnitResultDetail_rowid"
	.i sortField="jxUnitDr" s sortField1="UnitResult_jxUnitDr"
	.i sortField="jxUnitName" s sortField1="JXUnit_name"
	.i sortField="JXUnitCode" s sortField1="JXUnit_code"
	.i sortField="tValue" s sortField1="UnitResultDetail_tValue"
			
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  d
	.s sortStr="ORDER BY %ID DESC"
		
	;s sqlStr=sqlStr_sortStr
	;w sqlStr,!
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="rowid^jxUnitDr^jxUnitName^tValue^jxUnitCode^bValue^baseValue"
	s jxUnitDr="",jxUnitName="",jxUnitCode="",tValue=0
	//取结构
	While(result.Next()){
		//单位考核主表方案
		s detailRowid=result.Data("UnitResultDetail_rowid")
		s jxUnitDr=result.Data("UnitResult_jxUnitDr")
		s jxUnitName=result.Data("JXUnit_name")
		s jxUnitCode=result.Data("JXUnit_code")
		s tValue=result.Data("tValue")
		s bValue=result.Data("bValue")
		s baseValue=result.Data("baseValue") 
		s tmp=detailRowid_"^"_jxUnitDr_"^"_jxUnitName_"^"_$fn(tValue,"",2)_"^"_jxUnitCode_"^"_$fn(bValue,"",2)_"^"_$fn(baseValue,"",2)
		s count=count+1
		i searchValue'="" d
		.q:(searchField="JXUnitCode")&(JXUnitCode'[searchValue)
		.q:(searchField="jxUnitName")&(jxUnitName'[searchValue)
		.q:(searchField="tValue")&(tValue'[searchValue)
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

/// Creator：wang ying
/// CreatDate：2010-11-25
/// Description: 根据指标id获取KPI指标
/// Table：dhc_pa_data.KPIIndex1
/// Input：start:开始记录位置;limit:单页记录条数;
/// Output：
/// Return：有效指标字符串
/// Others：w ##class(dhc.pa.udata.uKPITargetSet).GetKPIs("","",0,10,"")
ClassMethod GetKPIs(searchField, searchValue, start, limit, str) As %String
{
	n ( searchField, searchValue,start, limit, str)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT KPIIndex1_rowid,KPIIndex1_code,KPIIndex1_name,KPIIndex1_shortcut,KPIIndex1_desc FROM dhc_pa_data.KPIIndex1 where %ID>0 and KPIIndex1_isKPI='Y' "
	;i str'="" s sqlStr = sqlStr_" and KPIIndex1_shortcut LIKE '%"_str_"%'"
	i str'="" s sqlStr = sqlStr_" and KPIIndex1_name LIKE '%"_str_"%'"
	;w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()
   
	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("KPIIndex1_rowid")
		s name = result.Data("KPIIndex1_name")
		s code = result.Data("KPIIndex1_code")
		s desc = result.Data("KPIIndex1_shortcut")
		s tmp=rowid_"^"_name_"^"_code
		i searchValue'="" d
		.q:(searchField = "code")&(code'[searchValue)
		.q:(searchField = "name")&(name'[searchValue)
		.i (count>=start)&(count<=end) d
		..d json.InsertRowData(tmp)
		.s count=count+1
		e  d
		.i (count>=start)&(count<=end) d
		..d json.InsertRowData(tmp)
		.s count=count+1
	}
	d result.Close()
	s resultString = json.getJsonData("rowid^name^code^desc",count)
 	k json
	q resultString
}

/// Creator：李明忠
/// CreatDate：2010-8-31
/// Description:设置年度目标值
/// Table：dhc_pa_data.UnitResultDetail
/// Input：urRowid-绩效单元考核主表Dr;KPIDr-KPI指标Dr;distValue-分解值
/// Output：
/// Return：SQLCODE
/// Others：w ##class(dhc.pa.udata.uKPITargetSet).SetYearValue("1||48||16",21,22.6)
ClassMethod SetTvalue(urRowid, KPIDr, distValue) As %String
{
	n (urRowid,KPIDr,distValue)
	
	s isTarget=2
		
	&SQL(update dhc_pa_data.UnitResultDetail set UnitResultDetail_tValue=:distValue where UnitResultDetail_KPIDr=:KPIDr and UnitResultDetail_rowid=:urRowid and UnitResultDetail_isTarget=:isTarget)
	q SQLCODE
}

/// Creator：李明忠
/// CreatDate：2010-8-31
/// Description:设置年度目标值
/// Table：dhc_pa_data.UnitResultDetail
/// Input：urRowid-绩效单元考核主表Dr;KPIDr-KPI指标Dr;distValue-分解值
/// Output：
/// Return：SQLCODE
/// Others：w ##class(dhc.pa.udata.uKPITargetSet).SetYearValue("1||48||16",21,22.6)
ClassMethod SetValue(urRowid, KPIDr, tValue, bValue, baseValue) As %String
{
	n (urRowid, KPIDr, tValue,bValue,baseValue)
	
	s ^TMPLY(1)=urRowid_"^"_KPIDr
	q:urRowid="" "NourRowid"
	s isTarget=2
		
	&SQL(update dhc_pa_data.UnitResultDetail set UnitResultDetail_tValue=:tValue,UnitResultDetail_bValue=:bValue,UnitResultDetail_baseValue=:baseValue where UnitResultDetail_KPIDr=:KPIDr and UnitResultDetail_rowid=:urRowid and UnitResultDetail_isTarget=:isTarget)
	q SQLCODE
}

/// Creator：wang ying
/// CreatDate：2011-03-07
/// Description: 获取考核期间
/// Table：dhc_pa_data.UnitResult
/// Input：start:开始记录位置;limit:单页记录条数;str-模糊查询字符串
/// Output：
/// Return：有效考核期间字符串
/// Others：w ##class(dhc.pa.udata.uKPITargetSet).Period(0,10,"")
ClassMethod Period(start, limit, str) As %String
{
	n (start, limit, str)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select DISTINCT UnitResult_period from dhc_pa_data.UnitResult where UnitResult_childSub>0"
	i str'="" s sqlStr = sqlStr_" and UnitResult_period like '"_str_"%'"
	
	d result.Prepare(sqlStr)
	d result.Execute()

	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	While(result.Next()){
		s period = result.Data("UnitResult_period")
		s tmp=period
		s count = count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("period",count)
 	k json
	q resultString
}

/// Creator:ban
/// CreatDate:2016-04-25
/// Description:根据指标id获取target数据
/// Table:
/// Input:KPIDr
/// Output:
/// Return:^""^
/// Others:w ##class(dhc.pa.udata.uKPITargetSet).getKPITargetStr("1")
ClassMethod getKPITargetStr(KPIDr As %String) As %String
{
	n (KPIDr)
	s sqlStr="SELECT KPITarget_Name, KPITarget_Code, KPITarget_Coefficient, KPITarget_ChangeNum FROM dhc_pa_data.KPITarget"
	s whereStr=" where %ID>0 and KPITarget_KPIDr='"_KPIDr_"'"
    s sqlStr=sqlStr_whereStr
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s targetCode=0
	s targetCoefficient=""
	s changeNum =0
	While(result.Next()){
		s targetCode=result.Data("KPITarget_Code")
		s targetCoefficient=result.Data("KPITarget_Coefficient")
		s changeNum=result.Data("KPITarget_ChangeNum")
		
	}
	d result.Close()
    q targetCode_"^"_targetCoefficient_"^"_changeNum
}

/// Creator：wang ying
/// CreatDate：2014-7-25
/// update:  2016-04-25   ban  2016-5-25 cyl添加基准值和最佳值
/// Description: 导入数据
/// Table：dhc_pa_data.JXBaseData,dhc_pa_data.UnitReslutDetail
/// Input：period-考核期间,periodType-期间类型
/// Output：
/// Return：返回执行语句后的SQLCODE
/// Others：w ##class(dhc.pa.udata.uKPITargetSet).Import("6","1||1",4)
ClassMethod Import(cycleDr, schemDr, jxUnitDr) As %String
{
	n (cycleDr, schemDr,jxUnitDr)
	
	q:cycleDr="" ""
	q:schemDr="" ""
	q:jxUnitDr="" ""
	
	s currStrgem=$p(schemDr,"||",1)
	q:currStrgem="" "NocurrStrgem"
	s schemChild=$p(schemDr,"||",2)
	q:schemChild="" "NoschemChild"
	
	s MaxMinValue=""
    
	s chuValue=0 
	s SQLCODE=0
	//从指标基础数据表中获取数据进行对应，导入明显数据表
	s URRowid=0
	f  s URRowid=$o(^DHCCJXPASTRATAGEM(0,"UnitResultSchem",currStrgem,schemDr,jxUnitDr,URRowid)) q:URRowid=""  d
	.s URDetail=0
	.q:'$d(^DHCCJXPASTRATAGEM(currStrgem,"UnitResult",URRowid))
	.s URStr=$g(^DHCCJXPASTRATAGEM(currStrgem,"UnitResult",URRowid))
	.q:URStr=""
	.q:'$d(^DHCCJXPASTRATAGEM(currStrgem,"Schem",schemChild))
	.s periodType=$p($g(^DHCCJXPASTRATAGEM(currStrgem,"Schem",schemChild)),"^",5)
	.s period=$p(URStr,"^",4)
	.s CycleDr=0
	.s CycleDr=$o(^DHCCJXPACYCLE(0,"Code",$e(period,1,4),CycleDr))
	.q:CycleDr'=cycleDr //2015-01-20 add
	.f  s URDetail=$o(^DHCCJXPASTRATAGEM(currStrgem,"URDetail",URRowid,URDetail))  q:URDetail=""  d
	..s nSumAvgValues=0
	..s URDetailStr=$g(^DHCCJXPASTRATAGEM(currStrgem,"URDetail",URRowid,URDetail))
	..q:URDetailStr=""
	..s URDetailRowid=currStrgem_"||"_URRowid_"||"_URDetail
	..s KPIDr=$p(URDetailStr,"^",2)  //取到指标id
	..q:KPIDr=""
	..q:'$d(^DHCCJXPAKPIINDEX1(KPIDr))
	..s KPIStr=$g(^DHCCJXPAKPIINDEX1(KPIDr))
	..s KPITargetStr=..getKPITargetStr(KPIDr) //取目标值n年同期表数据
	..q:KPITargetStr=""
	..q:KPIStr=""
	..s order=$p(KPIStr,"^",25)
	..q:order'=1
	..s targetSource=$p(KPITargetStr,"^",1)
	..s nYears=$p(KPITargetStr,"^",2)
	..s changeNum=$p(KPITargetStr,"^",3)
	..s extremum=$p(KPIStr,"^",9)
	..s colTypeDr=$p(KPIStr,"^",12)
	..q:((targetSource'=1)&&(targetSource'=2))
	..i targetSource=1 d            //n年同期
	...s actValue=0,sanmn=0
	...//循环n年的
	...f mDate=1:1:nYears d
	....s samePeriod=$e(period,1,4)-mDate_$e(period,5,6)
	....i colTypeDr'=2 d
	.....i $d(^DHCCJXPAJXUNIT(0,"JXBDPeriodKPI",jxUnitDr,samePeriod,periodType,KPIDr)) d
	......s dataRowid=0
	......s getValue= ##class(dhc.pa.udata.uCalculator).GetActValueOfUKP(jxUnitDr,samePeriod,KPIDr,periodType) ;$fn($p($g(^DHCCJXPAJXUNIT(jxUnitDr,"JXBaseData",dataRowid)),"^",4),"",2)
	......i getValue'=0  d
	.......i calUnitName="百分比" s getValue=getValue*100
	.......s MaxMinValue=MaxMinValue_"^"_getValue
	.......s actValue=actValue+getValue
	.......s sanmn=sanmn+1
	....e  d
	.....s calUnitName=""
	.....s calUnitName=$P(^DHCCJXPACALUNIT($p(KPIStr,"^",8)),"^",2)
	.....s expression= ##class(dhc.pa.udata.uCalculator).GetKPIExpression(KPIDr) //获取该指标的计算公式
	.....i expression'="" d
	......;s isHasData=..howManyPeriod(expression,jxUnitDr,samePeriod,periodType)  //计算该期间的指标是否有数据
	......;i isHasData=0 s n=n+1
	......s expression=##class(dhc.pa.udata.uCalculator).TransStr2(##class(dhc.pa.udata.uCalculator).TransStr(expression,jxUnitDr,samePeriod,periodType)) //调用公式转换方法
	......s mark= $$Express^Calculator(expression) //需要对expression进行验证并求职
	......;i (mark="<DIVIDE>")&&(extremum="H")&&(calUnitName="百分比") d //分母为0  实际值默认值为100
	......;.s actValue=actValue+100
	......i (mark'="<SYNTAX>")&&(mark'="<DIVIDE>") d //mark可能是最终值、也可能是错误信息
	.......s actValue=actValue+0
	.......i $fn(mark,"",2)="" d
	........s actValue=actValue+0
	.......e  d
	........s actValue=actValue+mark
	........s sanmn=sanmn+1
	.......i calUnitName="百分比" d
	........s mark=mark*100
	......e  s mark=0
	......i mark'=0  d
	.......s MaxMinValue=MaxMinValue_"^"_mark
	...i (changeNum'="")&&(changeNum>=0)&&(sanmn'=0)  d
	....s actValue = actValue/sanmn*(1+$ZABS(changeNum))
	...i (changeNum'="")&&(changeNum<0)&&(sanmn'=0)  d
	....s actValue = actValue/sanmn*(1-$ZABS(changeNum))
	...i changeNum="" d
	....i sanmn'=0  d
	.....s actValue = actValue/sanmn
	...;s chuValue=chuValue_" ^ "_URDetailRowid_"#"_actValue
	...s getmaxmin=##class(dhc.pa.udata.uComm).getMaxMinValue(MaxMinValue)
	...i extremum="L" d
	....s baseValue=$p(getmaxmin,"^",1),bValue=$p(getmaxmin,"^",2)
	...e  d
	....s calUnitName=$P(^DHCCJXPACALUNIT($p(KPIStr,"^",8)),"^",2)
	....s baseValue=$p(getmaxmin,"^",2),bValue=$p(getmaxmin,"^",1)
	...i (calUnitName="百分比")&&(colTypeDr=2) s actValue=actValue*100
	...;w actValue_"^"_baseValue_"^"_bValue_"^"_URDetailRowid,!
	...&SQL(Update dhc_pa_data.UnitResultDetail set UnitResultDetail_tValue=:actValue,UnitResultDetail_baseValue=:baseValue,UnitResultDetail_bValue=:bValue  where UnitResultDetail_rowid=:URDetailRowid and UnitResultDetail_isTarget=2 )
	...s MaxMinValue=""
	...i SQLCODE'=0 d //2014-12-09 update
	....d ##class(dhc.pa.udata.uPALogger).Insert("updateURDetailSamePeriod",period_"^"_periodType_"^"_URDetailRowid_"^"_actValue,SQLCODE,"")
	..i targetSource=2 d              //n年平均值
	...s nSumAvgValues=0,nAvgValues =0,sanmn=0
	...f mDate2=1:1:nYears  d
	....s i=0,n=0
	....s sumValue=0,avgValue2=0,len=0,calUnitName=""
	....i periodType="M"  s len=12
	....i periodType="Q"  s len=4
	....i periodType="H"  s len=2
	....i periodType="Y"  s len=0
	....f  s i=i+1  q:i>len  d  //从01开始，201500这样的不参加计算
	.....s avgPeriod=0
	.....i i<10 d
	......s avgPeriod=$e(period,1,4)-mDate2_"0"_i
	.....e  s avgPeriod=$e(period,1,4)-mDate2_i
	.....i colTypeDr'=2 d
	......i $d(^DHCCJXPAJXUNIT(0,"JXBDPeriodKPI",jxUnitDr,avgPeriod,periodType,KPIDr)) d
	.......;i '((periodType'="Y")&&($e(avgPeriod,5,6)="00")) s n=n+1
	.......i $o(^DHCCJXPAJXUNIT(0,"JXBDPeriodKPI",jxUnitDr,avgPeriod,periodType,KPIDr,""))'="" d
	........s n=n+1
	.......s Value=##class(dhc.pa.udata.uCalculator).GetActValueOfUKP(jxUnitDr,avgPeriod,KPIDr,periodType) ;$p($g(^DHCCJXPAJXUNIT(jxUnitDr,"JXBaseData",dataAvg)),"^",4)
	.......s sumValue=sumValue+Value //2016-5-25 edit cyl
	.....e  d
	......s calUnitName="",actValue2=0
	......s calUnitName=$P(^DHCCJXPACALUNIT($p(KPIStr,"^",8)),"^",2)
	......s expression= ##class(dhc.pa.udata.uCalculator).GetKPIExpression(KPIDr) //获取该指标的计算公式
	......i expression'="" d
	.......s isHasData=..howManyPeriod(expression,jxUnitDr,avgPeriod,periodType)  //计算该期间的指标是否有数据
	.......i isHasData=0 s n=n+1
	.......s expression=##class(dhc.pa.udata.uCalculator).TransStr2(##class(dhc.pa.udata.uCalculator).TransStr(expression,jxUnitDr,avgPeriod,periodType)) //调用公式转换方法
	.......s mark= $$Express^Calculator(expression) //需要对expression进行验证并求职
	.......i (periodType'="Y")&&($e(avgPeriod,5,6)="00") s mark=0  //2015-01-20 add
	.......;i (mark="<DIVIDE>")&&(extremum="H")&&(calUnitName="百分比") d //分母为0  实际值默认值为100
	.......;.s actValue2=actValue2+1
	.......i (mark'="<SYNTAX>")&&(mark'="<DIVIDE>") d //mark可能是最终值、也可能是错误信息
	........s actValue2=actValue2+0
	........i $fn(mark,"",2)="" d
	.........s actValue2=actValue2+0
	........e  s actValue2=actValue2+mark
	.......e  s mark=0
	.......s sumValue=sumValue+actValue2
	....i n=0  d
	.....s avgValue2=sumValue
	.....i calUnitName="百分比" d
	......s avgValue2=avgValue2*100
	.....i avgValue2'=0 s MaxMinValue=MaxMinValue_"^"_avgValue2,sanmn=sanmn+1
	....e  d
	.....s avgValue2=sumValue/n
	.....i calUnitName="百分比" d
	......s avgValue2=avgValue2*100
	.....i avgValue2'=0 s MaxMinValue=MaxMinValue_"^"_avgValue2,sanmn=sanmn+1
	....s nSumAvgValues = nSumAvgValues+avgValue2  ;存每一年的平均值
	...i (changeNum'="")&&(changeNum>=0)&&(sanmn'=0)  d
	....s nAvgValues = nSumAvgValues/sanmn*(1+$ZABS(changeNum))
	...i (changeNum'="")&&(changeNum<0)&&(sanmn'=0)  d
	....s nAvgValues = nSumAvgValues/sanmn*(1-$ZABS(changeNum))
	...i changeNum="" d
	....i sanmn'=0  d
	.....s nAvgValues = nSumAvgValues/sanmn //2016-5-25 edit cyl
	...s getmaxmin=##class(dhc.pa.udata.uComm).getMaxMinValue(MaxMinValue)
	...i extremum="L" d
	....s baseValue=$p(getmaxmin,"^",1),bValue=$p(getmaxmin,"^",2)
	...e  d
	....s baseValue=$p(getmaxmin,"^",2),bValue=$p(getmaxmin,"^",1)
	...s upPeriod=$e(period,1,4)
	...&SQL(Update dhc_pa_data.UnitResultDetail set UnitResultDetail_tValue=:nAvgValues,UnitResultDetail_baseValue=:baseValue,UnitResultDetail_bValue=:bValue
			 where UnitResultDetail_parRef->UnitResult_period like :upPeriod_'%'
			 	and UnitResultDetail_parRef->UnitResult_period !=:upPeriod_'00'
			  	AND UnitResultDetail_parRef->UnitResult_schemDr->Schem_frequency=:periodType
				AND UnitResultDetail_KPIDr=:KPIDr
				AND UnitResultDetail_parRef->UnitResult_jxUnitDr=:jxUnitDr
				and UnitResultDetail_isTarget=2)
	...s MaxMinValue=""
	...i SQLCODE'=0 d //2014-12-09 update
	....d ##class(dhc.pa.udata.uPALogger).Insert("updateURDetailAvgPeriod",period_"^"_periodType_"^"_URDetailRowid_"^"_nAvgValues,SQLCODE,"")

	
	;i rs=0 s rs=..Total(period,periodType,rs)  //计算上级科室的数据
	;w MaxMinValue2,!
	;w getmaxmin,!
	;w chuValue,!
	q SQLCODE
}

/// Creator：wang ying
/// CreatDate：2014-7-25
/// Description: 导入数据
/// Table：dhc_pa_data.JXBaseData,dhc_pa_data.UnitReslutDetail
/// Input：period-考核期间,periodType-期间类型
/// Output：
/// Return：返回执行语句后的SQLCODE
/// Others：w ##class(dhc.pa.udata.uKPITargetSet).ImportTValue("2","1||1","")
ClassMethod ImportTValue(cycleDr, schemDr, jxUnitDr) As %String
{
	q:cycleDr="" ""
	q:schemDr="" ""
	;s ^TMPWY=cycleDr_"^"_schemDr
	s SQLCODE=0,rc=0
	i jxUnitDr'="" d
	.s SQLCODE=..Import(cycleDr, schemDr, jxUnitDr)
	e  d
	.s jxUnit=0
	.f  s jxUnit=$o(^DHCCJXPAJXUNIT(0,"UnitSchemSchem",jxUnit))  q:jxUnit=""  d
	..q:'$d(^DHCCJXPAJXUNIT(0,"UnitSchemSchem",jxUnit,schemDr))
	..s SQLCODE=..Import(cycleDr,schemDr,jxUnit)
	
	i SQLCODE'=0 d
	.d ##class(dhc.pa.udata.uPALogger).Insert("ImportTValue",cycleDr_"^"_schemDr,SQLCODE,"")
	q SQLCODE
}

/// Creator：ban
/// CreatDate：2016-04-25
/// Description: 导入数据  import（） 导入方法备份
/// Table：dhc_pa_data.JXBaseData,dhc_pa_data.UnitReslutDetail
/// Input：period-考核期间,periodType-期间类型
/// Output：
/// Return：返回执行语句后的SQLCODE
/// Others：w ##class(dhc.pa.udata.uKPITargetSet).ImportTarget("6","1||1","16")
ClassMethod ImportTarget(cycleDr, schemDr, jxUnitDr) As %String
{
	n (cycleDr, schemDr,jxUnitDr)
	
	
	q:cycleDr="" ""
	q:schemDr="" ""
	q:jxUnitDr="" ""
	
	s currStrgem=$p(schemDr,"||",1)
	q:currStrgem="" "NocurrStrgem"
	s schemChild=$p(schemDr,"||",2)
	q:schemChild="" "NoschemChild"
	

	s SQLCODE=0
	//从指标基础数据表中获取数据进行对应，导入明显数据表
	s URRowid=0
	f  s URRowid=$o(^DHCCJXPASTRATAGEM(0,"UnitResultSchem",currStrgem,schemDr,jxUnitDr,URRowid)) q:URRowid=""  d
	.s URDetail=0
	.q:'$d(^DHCCJXPASTRATAGEM(currStrgem,"UnitResult",URRowid))
	.s URStr=$g(^DHCCJXPASTRATAGEM(currStrgem,"UnitResult",URRowid))
	.q:URStr=""
	.q:'$d(^DHCCJXPASTRATAGEM(currStrgem,"Schem",schemChild))
	.s periodType=$p($g(^DHCCJXPASTRATAGEM(currStrgem,"Schem",schemChild)),"^",5)
	.s period=$p(URStr,"^",4)
	.s CycleDr=0
	.s CycleDr=$o(^DHCCJXPACYCLE(0,"Code",$e(period,1,4),CycleDr))
	.q:CycleDr'=cycleDr //2015-01-20 add
	.f  s URDetail=$o(^DHCCJXPASTRATAGEM(currStrgem,"URDetail",URRowid,URDetail))  q:URDetail=""  d
	..s URDetailStr=$g(^DHCCJXPASTRATAGEM(currStrgem,"URDetail",URRowid,URDetail))
	..q:URDetailStr=""
	..s URDetailRowid=currStrgem_"||"_URRowid_"||"_URDetail
	..s KPIDr=$p(URDetailStr,"^",2)
	..q:KPIDr=""
	..q:'$d(^DHCCJXPAKPIINDEX1(KPIDr))
	..s KPIStr=$g(^DHCCJXPAKPIINDEX1(KPIDr))
	..q:KPIStr=""
	..s order=$p(KPIStr,"^",25)
	..q:order'=1
	..s targetSource=$p(KPIStr,"^",15)
	..s extremum=$p(KPIStr,"^",9)
	..s colTypeDr=$p(KPIStr,"^",12)
	..q:((targetSource'=1)&&(targetSource'=2))
	..i targetSource=1 d            //去年同期
	...s samePeriod=$e(period,1,4)-1_$e(period,5,6),actValue=0
	...i colTypeDr'=2 d
	....i $d(^DHCCJXPAJXUNIT(0,"JXBDPeriodKPI",jxUnitDr,samePeriod,periodType,KPIDr)) d
	.....s dataRowid=0
	.....f  s dataRowid=$o(^DHCCJXPAJXUNIT(0,"JXBDPeriodKPI",jxUnitDr,samePeriod,periodType,KPIDr,dataRowid)) q:dataRowid=""  d
	......q:'$d(^DHCCJXPAJXUNIT(jxUnitDr,"JXBaseData",dataRowid))
	......s actValue=$p($g(^DHCCJXPAJXUNIT(jxUnitDr,"JXBaseData",dataRowid)),"^",4)
	...e  d
	....s calUnitName="",actValue=0
	....s calUnitName=$P(^DHCCJXPACALUNIT($p(KPIStr,"^",8)),"^",2)
	....s expression= ##class(dhc.pa.udata.uCalculator).GetKPIExpression(KPIDr) //获取该指标的计算公式
	....;i KPIDr=2 b 
	....i expression'="" d
	.....s expression=##class(dhc.pa.udata.uCalculator).TransStr2(##class(dhc.pa.udata.uCalculator).TransStr(expression,jxUnitDr,samePeriod,periodType)) //调用公式转换方法
	.....s mark= $$Express^Calculator(expression) //需要对expression进行验证并求职
	.....;i KPIDr=2 b
	.....i (mark="<DIVIDE>")&&(extremum="H")&&(calUnitName="百分比") d //分母为0  实际值默认值为100
	......s actValue=100
	.....i (mark'="<SYNTAX>")&&(mark'="<DIVIDE>") d //mark可能是最终值、也可能是错误信息
	......s actValue=0
	......i $fn(mark,"",2)="" d
	.......s actValue=0
	......e  s actValue=mark
	......i calUnitName="百分比" s actValue=actValue*100
	...&SQL(Update dhc_pa_data.UnitResultDetail set UnitResultDetail_tValue=:actValue where UnitResultDetail_rowid=:URDetailRowid)
	...i SQLCODE'=0 d //2014-12-09 update
	....d ##class(dhc.pa.udata.uPALogger).Insert("updateURDetailSamePeriod",period_"^"_periodType_"^"_URDetailRowid_"^"_actValue,SQLCODE,"")
	..i targetSource=2 d              //去年平均值
	...s i=-1,n=0
	...s sumValue=0,avgValue=0,len=0,calUnitName=""
	...i periodType="M"  s len=12
	...i periodType="Q"  s len=4
	...i periodType="H"  s len=2
	...i periodType="Y"  s len=0
	...f  s i=i+1  q:i>len  d
	....s avgPeriod=0
	....i i<10 d
	.....s avgPeriod=$e(period,1,4)-1_"0"_i
	....e  s avgPeriod=$e(period,1,4)-1_i
	....i colTypeDr'=2 d
	.....i $d(^DHCCJXPAJXUNIT(0,"JXBDPeriodKPI",jxUnitDr,avgPeriod,periodType,KPIDr)) d
	......s dataAvg=0
	......f  s dataAvg=$o(^DHCCJXPAJXUNIT(0,"JXBDPeriodKPI",jxUnitDr,avgPeriod,periodType,KPIDr,dataAvg)) q:dataAvg=""  d
	.......q:'$d(^DHCCJXPAJXUNIT(jxUnitDr,"JXBaseData",dataAvg))
	.......i '((periodType'="Y")&&($e(avgPeriod,5,6)="00")) s n=n+1
	.......s Value=$p($g(^DHCCJXPAJXUNIT(jxUnitDr,"JXBaseData",dataAvg)),"^",4)
	.......s sumValue=sumValue+Value
	....e  d
	.....s calUnitName="",actValue=0
	.....s calUnitName=$P(^DHCCJXPACALUNIT($p(KPIStr,"^",8)),"^",2)
	.....s expression= ##class(dhc.pa.udata.uCalculator).GetKPIExpression(KPIDr) //获取该指标的计算公式
	.....i expression'="" d
	......s expression=##class(dhc.pa.udata.uCalculator).TransStr2(##class(dhc.pa.udata.uCalculator).TransStr(expression,jxUnitDr,avgPeriod,periodType)) //调用公式转换方法
	......s mark= $$Express^Calculator(expression) //需要对expression进行验证并求职
	......i (periodType'="Y")&&($e(avgPeriod,5,6)="00") s mark=0 //2015-01-20 add
	......;i KPIDr=7 b
	......i (mark="<DIVIDE>")&&(extremum="H")&&(calUnitName="百分比") d //分母为0  实际值默认值为100
	.......s actValue=1
	......i (mark'="<SYNTAX>")&&(mark'="<DIVIDE>") d //mark可能是最终值、也可能是错误信息
	.......s actValue=0
	.......i $fn(mark,"",2)="" d
	........s actValue=0
	.......e  s actValue=mark
	......i '((periodType'="Y")&&($e(avgPeriod,5,6)="00")) s n=n+1  //2015-01-20 add
	......s sumValue=sumValue+actValue
	...i n=0 s avgValue=sumValue
	...e  s avgValue=sumValue/n
	...;i KPIDr=7 b
	...i calUnitName="百分比" s avgValue=avgValue*100
	...&SQL(Update dhc_pa_data.UnitResultDetail set UnitResultDetail_tValue=:avgValue where UnitResultDetail_rowid=:URDetailRowid)
	...i SQLCODE'=0 d //2014-12-09 update
	....d ##class(dhc.pa.udata.uPALogger).Insert("updateURDetailAvgPeriod",period_"^"_periodType_"^"_URDetailRowid_"^"_avgValue,SQLCODE,"")

	
	;i rs=0 s rs=..Total(period,periodType,rs)  //计算上级科室的数据
	
	q SQLCODE
}

/// Creator：wang ying
/// CreatDate：2015-1-15
/// Description: 导入固定目标数据
/// Table：dhc_pa_data.UnitResultDetail
/// Input：period-考核期间,periodType-期间类型
/// Output：
/// Return：返回执行语句后的SQLCODE
/// Others：w ##class(dhc.pa.udata.uKPITargetSet).ImportTValueInfo("2014","M")
ClassMethod ImportTValueInfo(period, periodType) As %String
{
	n (period,periodType)
	q:period="" "Noperiod"
	s SQLCODE=0
	q:period="" ""
	q:periodType="" ""
	s KPIVIRowid=0
	f  s KPIVIRowid=$o(^DHCCJXPATValueInfoD(KPIVIRowid)) q:KPIVIRowid=""  d
	.q:$g(^DHCCJXPATValueInfoD(KPIVIRowid))=""
	.s KPIDr=$LIST(^DHCCJXPATValueInfoD(KPIVIRowid),2)
	.s jxUnitDr=$LIST(^DHCCJXPATValueInfoD(KPIVIRowid),4)
	.s value=$LIST(^DHCCJXPATValueInfoD(KPIVIRowid),3)
	.s data=KPIDr_"^"_jxUnitDr_"^"_value
	.&SQL(update dhc_pa_data.UnitResultDetail set UnitResultDetail_tValue=:value where UnitResultDetail_isTarget=2 and UnitResultDetail_KPIDr=:KPIDr and UnitResultDetail_parRef 
	  in (select UnitResult_rowid from dhc_pa_data.UnitResult where UnitResult_jxUnitDr=:jxUnitDr and UnitResult_period>=:period_"01" and UnitResult_period<=:period_"12") )
	.i SQLCODE'=0 d
	..d ##class(dhc.pa.udata.uPALogger).Insert("ImportTValueInfo",data,SQLCODE,"")
	
	q SQLCODE
}

/// Creator：wang ying
/// CreatDate：2015-5-4
/// Description: 导入从系统采集的指标的目标值(去年同期、去年平均、n年同期均值、n年平均)
/// Table：dhc_pa_data.JXBaseData,dhc_pa_data.UnitReslutDetail
/// Input：period-考核期间,periodType-期间类型
/// Output：
/// Return：返回执行语句后的SQLCODE
/// Others：w ##class(dhc.pa.udata.uKPITargetSet).Import("2","1||1",16)
ClassMethod importSetTvalue(cycleDr, schemDr, jxUnitDr, inputPeriod) As %String
{
	n (cycleDr, schemDr,jxUnitDr)
	
	
	q:cycleDr="" ""
	q:schemDr="" ""
	q:jxUnitDr="" ""
	
	s currStrgem=$p(schemDr,"||",1)
	q:currStrgem="" "NocurrStrgem"
	s schemChild=$p(schemDr,"||",2)
	q:schemChild="" "NoschemChild"
	

	s SQLCODE=0
	//从指标基础数据表中获取数据进行对应，导入明细数据表
	s URRowid=0
	f  s URRowid=$o(^DHCCJXPASTRATAGEM(0,"UnitResultSchem",currStrgem,schemDr,jxUnitDr,URRowid)) q:URRowid=""  d
	.s URDetail=0
	.q:'$d(^DHCCJXPASTRATAGEM(currStrgem,"UnitResult",URRowid))
	.s URStr=$g(^DHCCJXPASTRATAGEM(currStrgem,"UnitResult",URRowid))
	.q:URStr=""
	.q:'$d(^DHCCJXPASTRATAGEM(currStrgem,"Schem",schemChild))
	.s periodType=$p($g(^DHCCJXPASTRATAGEM(currStrgem,"Schem",schemChild)),"^",5)
	.s period=$p(URStr,"^",4)
	.q:(inputPeriod'="")&&(inputPeriod'=period)
	.s CycleDr=0
	.s CycleDr=$o(^DHCCJXPACYCLE(0,"Code",$e(period,1,4),CycleDr))
	.q:CycleDr'=cycleDr //2015-01-20 add
	.f  s URDetail=$o(^DHCCJXPASTRATAGEM(currStrgem,"URDetail",URRowid,URDetail))  q:URDetail=""  d
	..s URDetailStr=$g(^DHCCJXPASTRATAGEM(currStrgem,"URDetail",URRowid,URDetail))
	..q:URDetailStr=""
	..s URDetailRowid=currStrgem_"||"_URRowid_"||"_URDetail
	..s KPIDr=$p(URDetailStr,"^",2)
	..q:KPIDr=""
	..q:'$d(^DHCCJXPAKPIINDEX1(KPIDr))
	..s KPIStr=$g(^DHCCJXPAKPIINDEX1(KPIDr))
	..q:KPIStr=""
	..s order=$p(KPIStr,"^",25)
	..q:order'=1
	..s targetSource=$p(KPIStr,"^",15)
	..s extremum=$p(KPIStr,"^",9)
	..s colTypeDr=$p(KPIStr,"^",12)
	..q:((targetSource'=1)&&(targetSource'=2))
	..i targetSource=1 d            //去年同期
	...s samePeriod=$e(period,1,4)-1_$e(period,5,6),actValue=0
	...s sqlcode=##class(dhc.pa.udata.uSetKPITarget).samePerion(samePeriod,jxUnitDr,periodType,KPIDr,colTypeDr,URDetailRowid,KPIStr)
	...i sqlcode'=0 d //2014-12-09 update
	....d ##class(dhc.pa.udata.uPALogger).Insert("importSetTvalueSamePeriod",period_"^"_periodType_"^"_URDetailRowid_"^"_actValue,sqlcode,"更新目标值-同期均值类型")
	..i targetSource=2 d              //去年平均值
	...s i=-1,n=0
	...s sumValue=0,avgValue=0,len=0,calUnitName=""
	...i periodType="M"  s len=12
	...i periodType="Q"  s len=4
	...i periodType="H"  s len=2
	...i periodType="Y"  s len=0
	...f  s i=i+1  q:i>len  d
	....s avgPeriod=0
	....i i<10 d
	.....s avgPeriod=$e(period,1,4)-1_"0"_i
	....e  s avgPeriod=$e(period,1,4)-1_i
	....i colTypeDr'=2 d
	.....i $d(^DHCCJXPAJXUNIT(0,"JXBDPeriodKPI",jxUnitDr,avgPeriod,periodType,KPIDr)) d
	......s dataAvg=0
	......f  s dataAvg=$o(^DHCCJXPAJXUNIT(0,"JXBDPeriodKPI",jxUnitDr,avgPeriod,periodType,KPIDr,dataAvg)) q:dataAvg=""  d
	.......q:'$d(^DHCCJXPAJXUNIT(jxUnitDr,"JXBaseData",dataAvg))
	.......i '((periodType'="Y")&&($e(avgPeriod,5,6)="00")) s n=n+1
	.......s Value=$p($g(^DHCCJXPAJXUNIT(jxUnitDr,"JXBaseData",dataAvg)),"^",4)
	.......s sumValue=sumValue+Value
	....e  d
	.....s calUnitName="",actValue=0
	.....s calUnitName=$P(^DHCCJXPACALUNIT($p(KPIStr,"^",8)),"^",2)
	.....s expression= ##class(dhc.pa.udata.uCalculator).GetKPIExpression(KPIDr) //获取该指标的计算公式
	.....i expression'="" d
	......s expression=##class(dhc.pa.udata.uCalculator).TransStr2(##class(dhc.pa.udata.uCalculator).TransStr(expression,jxUnitDr,avgPeriod,periodType)) //调用公式转换方法
	......s mark= $$Express^Calculator(expression) //需要对expression进行验证并求职
	......i (periodType'="Y")&&($e(avgPeriod,5,6)="00") s mark=0 //2015-01-20 add
	......;i KPIDr=7 b
	......i (mark="<DIVIDE>")&&(extremum="H")&&(calUnitName="百分比") d //分母为0  实际值默认值为100
	.......s actValue=1
	......i (mark'="<SYNTAX>")&&(mark'="<DIVIDE>") d //mark可能是最终值、也可能是错误信息
	.......s actValue=0
	.......i $fn(mark,"",2)="" d
	........s actValue=0
	.......e  s actValue=mark
	......i '((periodType'="Y")&&($e(avgPeriod,5,6)="00")) s n=n+1  //2015-01-20 add
	......s sumValue=sumValue+actValue
	...i n=0 s avgValue=sumValue
	...e  s avgValue=sumValue/n
	...;i KPIDr=7 b
	...i calUnitName="百分比" s avgValue=avgValue*100
	...&SQL(Update dhc_pa_data.UnitResultDetail set UnitResultDetail_tValue=:avgValue where UnitResultDetail_rowid=:URDetailRowid)
	...i SQLCODE'=0 d //2014-12-09 update
	....d ##class(dhc.pa.udata.uPALogger).Insert("updateURDetailAvgPeriod",period_"^"_periodType_"^"_URDetailRowid_"^"_avgValue,SQLCODE,"")

	
	;i rs=0 s rs=..Total(period,periodType,rs)  //计算上级科室的数据
	
	q SQLCODE
}

/// Creator：cyl
/// CreatDate：2016-5-27
/// Description: 用来计算有多少个期间有数据，
/// Table：
/// Input：period-考核期间,periodType-期间类型
/// Output：
/// Return：返回个数
/// Others：w ##class(dhc.pa.udata.uKPITargetSet).howManyPeriod("<35>/<83>","5","201501","Q")
ClassMethod howManyPeriod(expression, jxUnitDr, period, periodType) As %String
{
	/*取公式里的指标，只要这些指标中有一个指标在该期间有数据，则表示这个期间有数据。*/
	s kpiList=##class(dhc.pa.udata.uCalculator).GetStrList(expression) //得到公式中的KPI
	s kpiListSize=kpiList.Size
	k ^kpiPeriodTemp
	s ^kpiPeriodTemp(jxUnitDr,$e(period,1,4),periodType)=0
	for kpiLen=1:1:kpiListSize  d
	.s kpi=kpiList.GetAt(kpiLen)
	.s kpi=$ZSTRIP(kpi,"<>","<'>")
	.s rowid=""
	.i $o(^DHCCJXPAJXUNIT(0,"JXBDPeriodKPI",jxUnitDr,period,periodType,kpi,rowid))'=""  d
	..s ^kpiPeriodTemp(jxUnitDr,$e(period,1,4),periodType)=$g(^kpiPeriodTemp(jxUnitDr,$e(period,1,4),periodType))+1
	s resultStr=$g(^kpiPeriodTemp(jxUnitDr,$e(period,1,4),periodType))
	if kpiListSize=resultStr  s resultStr=0  //两值相等表示有数据
	e  s resultStr=1
	k ^kpiPeriodTemp
	q resultStr
}

/// Creator：wang ying
/// CreatDate：2016-6-12
/// Description: 导入固定目标数据
/// Table：dhc_pa_data.UnitResultDetail
/// Input：period-考核期间,periodType-期间类型
/// Output：
/// Return：返回执行语句后的SQLCODE
/// Others：w ##class(dhc.pa.udata.uKPITargetSet).ImportTValueInfo("2014","M")
ClassMethod SetTValueInfo(period, periodType) As %String
{
	n (period,periodType)
	q:period="" "Noperiod"
	s SQLCODE=0
	q:period="" ""
	q:periodType="" ""
	
	s sqlStr="SELECT UnitResultDetail_parRef->UnitResult_period AS period,UnitResultDetail_parRef->UnitResult_jxUnitDr AS jxUnitDr,"
			 _"UnitResultDetail_KPIDr AS KPIDr," 
			 _"UnitResultDetail_tValue AS tValue,UnitResultDetail_rowid,UnitResultDetail_parRef->UnitResult_schemDr as schemDr"
 			 _"FROM dhc_pa_data.UnitResultDetail"
			 _ " WHERE right(UnitResultDetail_parRef->UnitResult_period,2)!='00' "
			 _"AND UnitResultDetail_parRef->UnitResult_period LIKE '"_period_"%' " 
			 _"AND UnitResultDetail_parRef->UnitResult_schemDr->Schem_frequency='"_periodType_"' "
			 _"AND UnitResultDetail_isTarget=2 "
			 _"AND UnitResultDetail_KPIDr->KPIIndex1_dataSource NOT IN (1,2) "
			 _"AND UnitResultDetail_KPIDr->KPIIndex1_order=1"
	
	
	s result=##class(%Library.ResultSet).%New()
		
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next())
	{
		s KPIDr=result.Data("KPIDr")	
		s period=result.Data("period")
		s newPeriod=$e(period,1,4)-1_$e(period,5,6)
		s jxUnitDr=result.Data("jxUnitDr")
		s tValue=result.Data("tValue")
		s schemDr=result.Data("schemDr")
	}
	
	
	
	q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.uKPITargetSetS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
