/// Creator: 李明忠
/// CreatDate: 2010-8-19
/// Description: 方案明细审核管理
Class dhc.pa.udata.uSchemAudit Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator：李明忠
/// CreatDate：2010-8-19
/// Description: 获取绩效方案下的方案明细
/// Table：dhc_pa_data.SchemDetail
/// Input：parent-父级节点;schemDr:绩效方案Dr;searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向
/// Output：
/// Return：返回parent下方案明细
/// Others：w ##class(dhc.pa.udata.uSchemAudit).GetSchemDetail("roo","1||6","","","","")
ClassMethod GetSchemDetail(parent, schemDr, searchField, searchValue, sortField, sortDir) As %String
{
	n (parent,schemDr,searchField,searchValue,sortField,sortDir)
	
	s stratagemDr=$P(schemDr,"||",1)
	s schemChildSub=$P(schemDr,"||",2)
	
	//规整查询条件
	s tmpEnd=""
	i parent="roo" s parent=0
	
	//SQL
	s sqlStr="select SchemDetail_parRef,SchemDetail_rowid,SchemDetail_childSub,SchemDetail_order,SchemDetail_KPIDr,SchemDetail_isTarget,SchemDetail_rate,SchemDetail_parent FROM dhc_pa_data.SchemDetail"
	s whereStr=" WHERE SchemDetail_childSub>0 and SchemDetail_parRef='"_schemDr_"'"
	s whereStr=whereStr_" AND SchemDetail_parent ='"_parent_"'"
	
	s sortStr="",sortField1=""
	i sortField'="" d
	.i sortField="rowid" s sortField1="SchemDetail_rowid"
	.i sortField="order" s sortField1="SchemDetail_order"
	.i sortField="name" s sortField1="SchemDetail_KPIDr"
	.i sortField="isTarget" s sortField1="SchemDetail_isTarget"
	.i sortField="rate" s sortField1="SchemDetail_rate"
	.i sortField="parent" s sortField1="SchemDetail_parent"
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  s sortStr=" ORDER BY %ID DESC"
	
	s sqlStr=sqlStr_whereStr_sortStr
	s resultString="["
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	//取结构
	While(result.Next()){
		//集体初始化
		s KPIIndexName="",KPICode="",method="",Flag="false",methodCode="",calUnitDr="",calUnitName="",colDeptDr="",colDeptName="",target="",expression="",expName=""
		
		s rowid = result.Data("SchemDetail_rowid")
		s order = result.Data("SchemDetail_order")
		s isTarget = result.Data("SchemDetail_isTarget")
		s KPI = result.Data("SchemDetail_KPIDr")
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
		....s methodCode = $P(^DHCCJXPAKPIINDEX1(KPI),"^",13)
		....s calUnitDr = $P(^DHCCJXPAKPIINDEX1(KPI),"^",8)
		....s target =  $P(^DHCCJXPAKPIINDEX1(KPI),"^",6)
		....;表达式解析
		....s expression = $P(^DHCCJXPAKPIINDEX1(KPI),"^",10)
		....i expression'="" d
		.....s expression=$E(expression,2,$L(expression)-1)
		.....i expression'="" d
		......s expName=##class(dhc.pa.udata.uKPIIndex).TransStr(expression) //解析表达式(用于显示)
		....s colDeptDr = $P(^DHCCJXPAKPIINDEX1(KPI),"^",14)
		....s isEnd = $P(^DHCCJXPAKPIINDEX1(KPI),"^",24)
		....i isEnd = "Y" s Flag = "true"
		....i isEnd = "N" s Flag = "false"
		
		
		s rate = result.Data("SchemDetail_rate")
		s parent = result.Data("SchemDetail_parent")
		
		
		
		//考核方法
		i methodCode = "I" s method = "区间法"
		i methodCode = "C" s method = "比较法"
		i methodCode = "D" s method = "扣分法"
	    i methodCode = "A" s method = "加分法"
		i methodCode = "M" s method = "目标参照法"
		i methodCode = "K" s method = "实际值法"
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
		
		s resultString=resultString_"{id:'"_KPI_"',detailid:'"_rowid_"',code:'"_KPICode_"',name:'"_KPIIndexName_"',scoreMethodCode:'"_methodCode_"',scoreMethodName:'"_method_"',order:'"_order_"',rate:'"_rate_"',isTarget:'"_isTarget_"',colDeptName:'"_colDeptName_"',target:'"_target_"',expression:'"_expression_"',expName:'"_expName_"',calUnitName:'"_calUnitName_"',leaf:"_Flag_",uiProvider:'col'},"
	}
		
	s resultString=resultString_"]"
	d result.Close()
	q resultString
}

/// Creator：李明忠
/// CreatDate：2010-8-20
/// Description: 获取绩效方案下的方案明细
/// Table：dhc_pa_data.SchemDetail
/// Input：parent-父级节点;schemDr:绩效方案Dr;searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向
/// Output：
/// Return：返回parent下方案明细
/// Others：w ##class(dhc.pa.udata.uSchemAudit).GetMethodDetail("1||6")
ClassMethod GetMethodDetail(schemDr) As %String
{
	n (schemDr)
	
	//根据方案查询绩效单元
	s jxUnitDrStr=..GetUnits(schemDr)
	//获取当前站率的ID
	s currStratagemDr=$P(schemDr,"||",1)
	//根据单元和当前战略查询绩效单元考核主表
}

/// Creator：李明忠
/// CreatDate：2010-8-20
/// Description: 获取绩效方案下的绩效单元
/// Table：dhc_pa_data.UnitSchem
/// Input：schemDr:绩效方案Dr
/// Output：
/// Return：返回schemDr下的绩效单元字符串
/// Others：w ##class(dhc.pa.udata.uSchemAudit).GetUnits("1||6")
ClassMethod GetUnits(schemDr) As %String
{
	n (schemDr)
	
	//根据方案查询绩效单元
	s jxUnitDrStr=""
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select distinct UnitSchem_parRef from dhc_pa_data.UnitSchem where UnitSchem_childSub>0 and UnitSchem_schemDr='"_schemDr_"'"
	
	d result.Prepare(sqlStr)
	d result.Execute()
	
	While(result.Next()){
		s jxUnitDr = result.Data("UnitSchem_parRef")
		i jxUnitDr'="" d
		.i jxUnitDrStr="" s jxUnitDrStr=jxUnitDr
		.e  s jxUnitDrStr=jxUnitDrStr_"^"_jxUnitDr
	}
	d result.Close()
	
	q jxUnitDrStr
}

/// Creator：李明忠
/// CreatDate：2010-9-13
/// Description: 获取当前战略Dr
/// Table：dhc_pa_data.Stratagem
/// Input：
/// Output：
/// Return：当前战略DR
/// Others：w ##class(dhc.pa.udata.uSchemAudit).GetCurrStratagemDr()
ClassMethod GetCurrStratagemDr() As %String
{
	//获取当前战略
	s stratagemDr = 0 //定义并初始化战略Dr
	s count=0 //定义并初始化当前战略记录数量
	s currStratagemDr = 0 //定义并初始化当前战略Dr
	f  s stratagemDr=$O(^DHCCJXPASTRATAGEM(stratagemDr)) q:stratagemDr=""  d
	.i $D(^DHCCJXPASTRATAGEM(stratagemDr)) d
	..i $G(^DHCCJXPASTRATAGEM(stratagemDr))'="" d
	...s currStratagemFlag = $P(^DHCCJXPASTRATAGEM(stratagemDr),"^",14)
	...i currStratagemFlag="Y" d
	....s currStratagemDr = stratagemDr
	....s count=count+1

	q:count=0 "NoCurrRecord" //表示没有当前战略记录
	q:count>1 "RepCurrRecord" //表示有多条当前战略记录
	
	q currStratagemDr
}

/// Creator：李明忠
/// CreatDate：2010-9-13
/// Description: 审核、初始化区间、上下限值
/// Table：dhc_pa_data.URDetailDist
/// Input：
/// Output：
/// Return：返回SQLCODE
/// Others：w ##class(dhc.pa.udata.uSchemAudit).Audit()
ClassMethod Audit() As %String
{
	//获取当前战略
	s tmpStr=..GetCurrStratagemDr()
	
	q:tmpStr="NoCurrRecord" tmpStr //表示没有当前战略记录
	q:tmpStr="RepCurrRecord" tmpStr //表示有多条当前战略记录
	
	s currStratagemDr=tmpStr
	s flag="true"
	
	TSTART
	
	s flag=..InsertDistParaMain(currStratagemDr)
	
	i flag="false" d
	.TRollBack
	e  d
	.TCOMMIT
	
	q flag
}

/// Creator：张学燕
/// CreatDate：2010-9-13
/// Description: 审核、初始化区间、上下限值
/// Table：dhc_pa_data.URDetailDist
/// Input：
/// Output：
/// Return：返回SQLCODE
/// Others：w ##class(dhc.pa.udata.uSchemAudit).InsertDistParaMain(1)
ClassMethod InsertDistParaMain(currStratagemDr) As %String
{
 	new (currStratagemDr)
 	set unitResultChildSub=0,flag="true"	
 	for  set unitResultChildSub=$O(^DHCCJXPASTRATAGEM(currStratagemDr,"UnitResult",unitResultChildSub)) q:unitResultChildSub=""  d
 	.set Curr=$G(^DHCCJXPASTRATAGEM(currStratagemDr,"UnitResult",unitResultChildSub))
 	.if Curr'="" d
 	..s rs=..InsertDistPara(currStratagemDr,unitResultChildSub)
 	..i rs'=0 d
 	...s flag="false"
 	
 	q flag
}

/// Creator：张学燕
/// CreatDate：2010-9-13
/// Description: 审核、初始化区间、上下限值
/// Table：dhc_pa_data.URDetailDist
/// Input：
/// Output：
/// Return：返回SQLCODE
/// Others：w ##class(dhc.pa.udata.uSchemAudit).InsertDistPara(1,1)
ClassMethod InsertDistPara(currStratagemDr, unitResultChildSub) As %String
{
		new (currStratagemDr,unitResultChildSub)
		
		s rs=0
		
  	   	set URDSub=0
  		for  set URDSub=$O(^DHCCJXPASTRATAGEM(currStratagemDr,"URDetail",unitResultChildSub,URDSub)) q:URDSub=""  d
		.set Curr =""
		.set Curr=$G(^DHCCJXPASTRATAGEM(currStratagemDr,"URDetail",unitResultChildSub,URDSub))
		.if Curr'="" do 
		..set isTarget 	 = $P(Curr,"^",4)
		..i isTarget=2 d
		...set KPIDr 	 = $P(Curr,"^",2) 
		...set baseValue	 = $P(Curr,"^",5)   //	基准值
		...set tValue	 = $P(Curr,"^",6)   //	目标值
		...set bValue	 = $P(Curr,"^",7)   //	最佳值
		...set tValueUp	 = $P(Curr,"^",8)   //	目标值上限
		...set bValueUp	 = $P(Curr,"^",9)   //	基准值上限
	    ...set KPIMethod	 = $P($G(^DHCCJXPAKPIINDEX1(KPIDr)),"^",13)  //考核方法
		...set KPIExtreMum= $P($G(^DHCCJXPAKPIINDEX1(KPIDr)),"^",9)   //获得极值
		...set unitResultDetailRowid=currStratagemDr_"||"_unitResultChildSub_"||"_URDSub
		...;'I':区间法---------------------------------------------------------
		...if (KPIMethod="I")  do
		....;//趋高H--------------------------
		....if (KPIExtreMum="H")  do
		.....;w unitResultDetailRowid_"^"_KPIMethod_"^"_KPIExtreMum,!
		.....set OrderNo=0
		.....for  set OrderNo=OrderNo+1 q:OrderNo>4  do 
		......set valueLower = 0
		......set valueUp    = 0
		......;Write "1-", KPIDr,"-OrdNO-",OrderNo, "-",baseValue,"-",tValue,"-",bValue,"jz-",KPIExtreMum,"-id-",URDSub,!
		......if (OrderNo = 1) do
		.......set valueLower = 0
		.......set valueUp    = baseValue 
		......if (OrderNo = 2) do
		.......set valueLower = baseValue
		.......set valueUp    = tValue
		.......;Write "3-", KPIDr,"-valueLower-",valueLower, ";valueUp-",valueUp,!
		......if (OrderNo = 3) do
		.......set valueLower = tValue
		.......set valueUp    = bValue  
		......if (OrderNo = 4) do
		.......set valueLower = bValue
		.......set valueUp    = 0
		......&sql(Update dhc_pa_data.URDetailDist set URDetailDist_valueLower=:valueLower,URDetailDist_valueUp=:valueUp where URDetailDist_parRef=:unitResultDetailRowid and URDetailDist_rangeDr=:OrderNo )
		......;w unitResultDetailRowid_"^"_SQLCODE,!
		......i SQLCODE'=0 s rs=1
		....;//趋中M--------------------------
		....if (KPIExtreMum="M") do 
		.....set OrderNo=0
		.....for  set OrderNo=OrderNo+1 q:OrderNo>6  do 
		......set valueLower = 0
		......set valueUp    = 0
		......if (OrderNo=1) do
		.......set valueLower = 0
		.......set valueUp    = baseValue 
		......if (OrderNo=2) do
		.......set valueLower = baseValue
		.......set valueUp    = tValue 
		......if (OrderNo=3) do
		.......set valueLower = tValue
		.......set valueUp    = bValue
		......if (OrderNo=4) do
		.......set valueLower = bValue
		.......set valueUp    = tValueUp  
		......if (OrderNo=5) do
		.......set valueLower = tValueUp
		.......set valueUp    = bValueUp
		......if (OrderNo=6) do
		.......set valueLower = bValueUp
		.......set valueUp    = 0
		......&sql(Update dhc_pa_data.URDetailDist set  URDetailDist_valueLower= :valueLower,URDetailDist_valueUp= :valueUp  where URDetailDist_parRef = :unitResultDetailRowid  and URDetailDist_rangeDr =:OrderNo )
		......;w unitResultDetailRowid_"^"_SQLCODE,!
		......i SQLCODE'=0 s rs=1
		....;//趋低L----------------- 
		....if (KPIExtreMum="L") do 
		.....set OrderNo=0
		.....for  set OrderNo=OrderNo+1 q:OrderNo>4  do 
		......set valueLower = 0
		......set valueUp    = 0 
		......if (OrderNo=1) do
		.......set valueLower = 0
		.......set valueUp    = bValue 
		......if (OrderNo=2) do
		.......set valueLower = bValue
		.......set valueUp    = tValue
		......if (OrderNo=3) do
		.......set valueLower = tValue
		.......set valueUp    = baseValue  
		......if (OrderNo=4) do
		.......set valueLower = baseValue
		.......set valueUp    = 0
		......&sql(Update dhc_pa_data.URDetailDist set  URDetailDist_valueLower= :valueLower,URDetailDist_valueUp= :valueUp  where URDetailDist_parRef = :unitResultDetailRowid  and URDetailDist_rangeDr =:OrderNo )
		......;w unitResultDetailRowid_"^"_SQLCODE,!
		......i SQLCODE'=0 s rs=1
		
		q rs
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.uSchemAuditS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
