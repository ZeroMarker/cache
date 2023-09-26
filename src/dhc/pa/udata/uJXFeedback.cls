Class dhc.pa.udata.uJXFeedback Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator：wang ying
/// CreatDate：2010-09-17
/// Description: 查询符合条件的指标记录
/// Table：dhc_pa_data.UnitResultDetail
/// Input：parent-父节点;searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.pa.udata.uJXFeedback).List("","","","",0,25,"1||1","roo",1,1,6)
ClassMethod List(searchField, searchValue, sortField, sortDir, start, limit, schemDr, parent, cycleID, period, jxUnitDr) As %String
{
	n (searchField, searchValue, sortField, sortDir, start, limit,schemDr, parent,cycleID,period,jxUnitDr)
	
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
    
    ;w stratagemDr,schemDr,jxUnitDr,newPeriod,!
	s parRef=..GetURRowid(stratagemDr,schemDr,jxUnitDr,newPeriod)
	
	s unitschem = $p(parRef,"||",1)
	s unitschemSub = $p(parRef,"||",2)
	s parRef = "'"_parRef_"'"
	
	//规整查询条件
	s tmpEnd=""
	i parent="roo" s parent=0
	s tmpID = ""
	i parent'="" d
	.i $D(^DHCCJXPASTRATAGEM(0,"URDParent",unitschem,parent,unitschemSub)) d
	..s tmpID = $o(^DHCCJXPASTRATAGEM(0,"URDParent",unitschem,parent,unitschemSub,tmpID))
	..i $G(^DHCCJXPASTRATAGEM(unitschem,"URDetail",unitschemSub,tmpID))'="" s tmpEnd=$P(^DHCCJXPASTRATAGEM(unitschem,"URDetail",unitschemSub,tmpID),"^",25)
	..e  s tmpEnd="N"
	
	//SQL
	s sqlStr="SELECT UnitResultDetail_rowid,UnitResultDetail_parRef,UnitResultDetail_sDetailDr,"
	_"UnitResultDetail_KPIDr,UnitResultDetail_order,UnitResultDetail_isTarget,"
	_"UnitResultDetail_baseValue,UnitResultDetail_tValue,UnitResultDetail_bValue,"
	_"UnitResultDetail_tValueUp,UnitResultDetail_bValueUp,UnitResultDetail_rate,"
	_"UnitResultDetail_actValue,UnitResultDetail_score,UnitResultDetail_lastValue,"
	_"UnitResultDetail_distRate,UnitResultDetail_flag,UnitResultDetail_estDesc,"
	_"UnitResultDetail_estUserDr,UnitResultDetail_estAUserDr,UnitResultDetail_estADate,"
	_"UnitResultDetail_fBDesc,UnitResultDetail_fBUserDr,UnitResultDetail_estDate,"
	_"UnitResultDetail_fBDate,UnitResultDetail_isSubmit,UnitResultDetail_parent,"
	_"UnitResultDetail_distMethodDr,UnitResultDetail_isSubmit FROM dhc_pa_data.UnitResultDetail"
	s whereStr=" WHERE UnitResultDetail_childSub>0 and UnitResultDetail_parRef="_parRef
	s whereStr=whereStr_" AND UnitResultDetail_parent ='"_parent_"'"
	
	
	s sortStr="",sortField1=""
	i sortField'="" d
	.i sortField="rowid" s sortField1="UnitResultDetail_rowid"
	.i sortField="order" s sortField1="UnitResultDetail_order"
	.i sortField="name" s sortField1="UnitResultDetail_KPIDr"
	.i sortField="actValue" s sortField1="UnitResultDetail_actValue"
	.i sortField="tValue" s sortField1="UnitResultDetail_tValue"
	.i sortField="score" s sortField1="UnitResultDetail_score"
	.i sortField="isTarget" s sortField1="UnitResultDetail_isTarget"
	.i sortField="rate" s sortField1="UnitResultDetail_rate"
	.i sortField="parent" s sortField1="UnitResultDetail_parent"
	
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  s sortStr=" ORDER BY UnitResultDetail_order ASC"
	
	s sqlStr=sqlStr_whereStr_sortStr
	;w sqlStr,!
	s resultString="["
	
	s result=##class(%Library.ResultSet).%New()
	i (tmpEnd'="N")||(parent=0) d
	.d result.Prepare(sqlStr)
	.d result.Execute()
	//取结构
	While(result.Next()){
		//集体初始化
		s KPIIndexName="",estDateName="",attentionName="",userName="",tValue="",actValue="",score="",attention="",fbdesc="",fbuser="",estdesc="",estDate="", KPICode="",method="",Flag="",methodeCode="",calUnitDr="",calUnitName="",expName="",expression="",colDeptDr="",colDeptName="",target=""
		
		s rowid = result.Data("UnitResultDetail_rowid")
		s order = result.Data("UnitResultDetail_order")
		s isTarget = result.Data("UnitResultDetail_isTarget")
		s KPI = result.Data("UnitResultDetail_KPIDr")
		s score = result.Data("UnitResultDetail_score")
		s rate = result.Data("UnitResultDetail_rate")
		s parent = result.Data("UnitResultDetail_parent")
		s attention = result.Data("UnitResultDetail_flag") //关注度
		s fbdesc = result.Data("UnitResultDetail_fBDesc") //反馈信息
		s fbuser = result.Data("UnitResultDetail_fBUserDr") //反馈人
		s estdesc = result.Data("UnitResultDetail_estDesc") //考核点评
		s estDate = result.Data("UnitResultDetail_estDate") //点评时间
		s submit = result.Data("UnitResultDetail_isSubmit") //是否提交
		i attention="1" s attentionName="重点"
		i attention="0"  s attentionName="一般"
		;e  s attentionName="一般"
		i fbuser'="" s userName=$p($g(^SSU("SSUSR",fbuser)),"^",2)
		i estDate'="" s estDateName = $zd(estDate,3)
		
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
		....s methodeCode = $P(^DHCCJXPAKPIINDEX1(KPI),"^",13)
		....s expression = $P(^DHCCJXPAKPIINDEX1(KPI),"^",10)
		....s calUnitDr = $P(^DHCCJXPAKPIINDEX1(KPI),"^",8)
		....s target =  $P(^DHCCJXPAKPIINDEX1(KPI),"^",6)
		....s colDeptDr = $P(^DHCCJXPAKPIINDEX1(KPI),"^",14)
		....s isEnd = $P(^DHCCJXPAKPIINDEX1(KPI),"^",24)
		....i isEnd = "Y"  d
		.....s Flag = "true"
		.....s tValue = result.Data("UnitResultDetail_tValue")
		.....i tValue="" s tValue=0
		.....s actValue = result.Data("UnitResultDetail_actValue")
		.....i actValue="" s actValue=0
		....i isEnd = "N" s Flag = "false"
		
		;w KPI,KPIIndexName,tValue,!
		//评分方法
		i methodeCode = "I" s method = "区间法"
		i methodeCode = "C" s method = "比较法"
		i methodeCode = "D" s method = "扣分法"
	    i methodeCode = "A" s method = "加分法"
		i methodeCode = "M" s method = "目标参照法"
		i methodeCode = "K" s method = "实际值法"
		//表达式解析
		i expression'="" d
		.s expression=$E(expression,2,$L(expression)-1)
		.s expName=##class(dhc.pa.udata.uKPIIndex).TransStr(expression) //解析表达式(用于显示)
		
		
        //计量单位
		i calUnitDr'="" d
		.i $D(^DHCCJXPACALUNIT(calUnitDr)) d
		..i $G(^DHCCJXPACALUNIT(calUnitDr)) d
		...s calUnitName=$P(^DHCCJXPACALUNIT(calUnitDr),"^",2)
		
		//收集单位
		i colDeptDr'="" d
		.i $D(^DHCCJXPAJXUNIT(colDeptDr)) d
		..i $G(^DHCCJXPAJXUNIT(colDeptDr))'="" d
		...s colDeptName=$P(^DHCCJXPAJXUNIT(colDeptDr),"^",3)
		
		;w "rowid="_rowid,"order="_order," KPICode="_KPICode," submit，KPIIndexName="_KPIIndexName,"method="_method,estdesc"rate="_rate,"isTarget="_isTarget,"colDeptName="_colDeptName,!
		s resultString=resultString_"{id:'"_KPI_"',detailid:'"_rowid_"',code:'"_KPICode_"',name:'"_KPIIndexName_"',submit:'"_submit_"',tValue:'"_$fn(tValue,"",2)_"',actValue:'"_$fn(actValue,"",2)_"',score:'"_$fn(score,"",2)_"',estDateName:'"_estDateName_"',estdesc:'"_estdesc_"',attentionName:'"_attentionName_"',fbdesc:'"_fbdesc_"',method:'"_method_"',userName:'"_userName_"',order:'"_order_"',rate:'"_rate_"',isTarget:'"_isTarget_"',colDeptName:'"_colDeptName_"',par:'"_parent_"',target:'"_target_"',expName:'"_expName_"',calUnitName:'"_calUnitName_"',leaf:"_Flag_",uiProvider:'col'},"
	}
		
	s resultString=resultString_"]"
	d result.Close()
	q resultString
}

/// Creator: wang ying
/// CreatDate:  2010-09-13
/// Description: 插入新记录
/// Table: dhc.pa.data.Schem
/// Input: data-待插入的数据(code^name^desc)
/// Output: 
/// Return: 代码为空,返回"EmptyCode";代码存在,返回"RepCode";名称为空,返回"EmptyName";名称存在,返回"RepName";收入支出标志都选中,返回"InOut";执行SQL语句返回SQLCODE
/// Others: w ##class(dhc.pa.udata.uJXFeedback).update("1||88||3","default^demo^Y")
ClassMethod update(rowid, data) As %String
{
		n (rowid,data)
		
		k PLIST
		q:data="" "EmptyRecData"
		
		s fbdesc=$p(data,"^",1)
		s fbuserCode = $p(data,"^",2)
		s fbuserCode = $$ALPHAUP^SSUTIL4(fbuserCode)
		s userId =""
		;s userId = $o(^SSU("SSUSR",0,"SSUSR_Name",fbuserCode,userId))
		s userId=$O(^SSU("SSUSR",0,"SSUSR_Initials",fbuserCode,userId))
 		
		s submit = $p(data,"^",3)
		
	     s nowTime=$P($h,",",1)
		;i curreStratagemDr'="" s PLIST(0)=curreStratagemDr
		 s PLIST(22)=fbdesc
		 s PLIST(23)=userId
		 s PLIST(25)=nowTime
		 s PLIST(26)=submit
		&sql(update dhc_pa_data.UnitResultDetail values PLIST() where %ID=:rowid)
		q SQLCODE
}

/// Creator：wang ying
/// CreatDate：2010-9-21
/// Description: 获取绩效单位
/// Table：dhc_pa_data.UnitSchem
/// Input：start:开始记录位置;limit:单页记录条数;schemDr-方案ID
/// Output：
/// Return：有效绩效单位字符串
/// Others：w ##class(dhc.pa.udata.uJXFeedback).GetDept(0,10,"1||3",1)
ClassMethod GetDept(start, limit, schemDr, userCode) As %String
{
	n (start, limit, schemDr,userCode)
		
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select distinct UnitSchem_parRef,UnitSchem_rowid from dhc_pa_data.UnitSchem where UnitSchem_childSub>0 and UnitSchem_schemDr='"_schemDr_"'"
	i userCode'="" d
	.s sqlStr = "select distinct UnitSchem_parRef,UnitSchem_rowid from dhc_pa_data.UnitSchem,dhc_pa_data.JXUnitAudit where JXUnitAudit_jxUnitDr=JXUnitAudit_jxUnitDr and UnitSchem_childSub>0 and UnitSchem_schemDr='"_schemDr_"' and JXUnitAudit_userDr='"_userCode_"'"
	d result.Prepare(sqlStr)
	d result.Execute()
    s schem = $p(schemDr,"||",1)
	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	While(result.Next()){
		//集体初始化
		s jxUnitName="",shortCut=""
		s rowid = result.Data("UnitSchem_rowid")
		s jxUnitDr = result.Data("UnitSchem_parRef")
		s unitSchem = schem_"||"_jxUnitDr
		i jxUnitDr'="" d
		.i $D(^DHCCJXPAJXUNIT(jxUnitDr)) d
		..i $G(^DHCCJXPAJXUNIT(jxUnitDr))'="" d
		...s jxUnitName=$P(^DHCCJXPAJXUNIT(jxUnitDr),"^",3)
		...s shortCut=$P(^DHCCJXPAJXUNIT(jxUnitDr),"^",5)
		.s tmp=unitSchem_"^"_jxUnitDr_"^"_jxUnitName_"^"_shortCut
		.s count = count+1
		.i (count>start)&(count<=end) d
		..d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("rowid^jxUnitDr^jxUnitName^shortCut",count)
 	k json
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

/// Creator：wang ying
/// CreatDate：2010-11-17
/// Description: 查询符合条件的指标记录
/// Table：dhc_pa_data.UnitResult
/// Input：parent-父节点;searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.pa.udata.uJXFeedback).getTotalSorce("1||3",1,1,17)
ClassMethod getTotalSorce(schemDr, cycleID, period, jxUnitDr) As %String
{
	n (schemDr, cycleID,period,jxUnitDr)
	
	
	q:schemDr="" "NoDatas"
	q:jxUnitDr="" "NoDatas"
	q:cycleID="" "NoDatas"
	q:period="" "NoDatas"
	
	//获取当前战略ID
	s stratagemDr=$P(schemDr,"||",1)
	s schemSub=$P(schemDr,"||",2) 
	q:stratagemDr="" "NoDatas"
	s fre=""
	s count =0
	
	//获取方案的报告频率、当前月份、应用系统号、考核年度
	s currMonth="",cycleDr=""
	i $D(^DHCCJXPASTRATAGEM(stratagemDr)) d
	.i $G(^DHCCJXPASTRATAGEM(stratagemDr))'="" d
	..s currMonth=$P($G(^DHCCJXPASTRATAGEM(stratagemDr)),"^",8)
	..i currMonth'="" d
	...s fre=$P($G(^DHCCJXPASTRATAGEM($P(schemDr,"||",1),"Schem",$P(schemDr,"||",2))),"^",5)
	...s schemName=$P($G(^DHCCJXPASTRATAGEM($P(schemDr,"||",1),"Schem",$P(schemDr,"||",2))),"^",2)
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
    s json=##class(dhc.pa.comm.JsonObj).%New()
    s jsonTitle="rowid^schemName^total"
    s unitResult=0
    f  s unitResult=$o(^DHCCJXPASTRATAGEM(0,"UnitResultSchem",stratagemDr,schemDr,jxUnitDr,unitResult)) q:unitResult=""  d
    .i $d(^DHCCJXPASTRATAGEM(stratagemDr,"UnitResult",unitResult)) d
    ..s unitResultAll = $g(^DHCCJXPASTRATAGEM(stratagemDr,"UnitResult",unitResult))
    ..s periodTmp = $p(unitResultAll,"^",4)
    ..i (newPeriod=periodTmp) d
    ...s total=$fn($p(unitResultAll,"^",8),"",2)
    ...s tmp = stratagemDr_"||"_unitResult_"^"_schemName_"^"_total
    ...s count = count+1
    ...d json.InsertRowData(tmp)
    
    s resultString = json.getJsonData(jsonTitle,count)
	k json
	q resultString
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.uJXFeedbackS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
