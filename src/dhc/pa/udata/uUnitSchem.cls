/// Creator: 李明忠
/// CreatDate: 2010-07-30
/// Description: 绩效单元考核方案
Class dhc.pa.udata.uUnitSchem Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 李明忠
/// CreatDate: 2010-08-4
/// Description: 查询符合条件的记录
/// Table: dhc.pa.data.Schem
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;period-考核期间类型
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.pa.udata.uUnitSchem).SchemList("Y","","","rowid","DESC",0,25,"M")
ClassMethod SchemList(active, searchField, searchValue, sortField, sortDir, start, limit, period) As %String
{
		n (active,searchField, searchValue, sortField, sortDir, start, limit, period)
		
		s Stratagem = ""
		s curreStratagemDr = ""
		f  s Stratagem=$o(^DHCCJXPASTRATAGEM(Stratagem)) q:Stratagem=""  d
		.i $D(^DHCCJXPASTRATAGEM(Stratagem)) d
		..i $G(^DHCCJXPASTRATAGEM(Stratagem))'="" d
		...s curreStratagem = $p(^DHCCJXPASTRATAGEM(Stratagem),"^",14)
		...i curreStratagem="Y" d
		....s curreStratagemDr = Stratagem
		
		s sqlStr="SELECT Schem_rowid,Schem_parRef,Schem_code,Schem_name,Schem_shortcut,Schem_appSysDr,Schem_frequency,Schem_KPIDr,Schem_desc,Schem_active,Schem_level FROM dhc_pa_data.Schem WHERE Schem_childSub>0 and Schem_parRef="_curreStratagemDr_" and Schem_appSysDr=2 and Schem_frequency='"_period_"'"

		s sortStr=""
		s sortField1=""
		
		i sortField'="" d
		.i sortField="rowid" s sortField1="Schem_rowid"
		.i sortField="parRef" s sortField1="Schem_parRef"
		.i sortField="code" s sortField1="Schem_code"
		.i sortField="name" s sortField1="Schem_name"
		.i sortField="shortcut" s sortField1="Schem_shortcut"
		.i sortField="appSysDr" s sortField1="Schem_appSysDr"
		.i sortField="frequency" s sortField1="Schem_frequency"
		.i sortField="KPIDr" s sortField1="Schem_KPIDr"
		.i sortField="desc" s sortField1="Schem_desc"
		.i sortField="active" s sortField1="Schem_active"
		.i sortField="level" s sortField1="Schem_level"
	
			
		i sortField1'="" d
		.s sortDir=$ZCONVERT(sortDir,"u")
		.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
		.e  s sortStr=" ORDER BY "_sortField1_" ASC"
		e  s sortStr=" ORDER BY %ID DESC"
		
		s sqlStr=sqlStr_sortStr
		s result=##class(%Library.ResultSet).%New()
		d result.Prepare(sqlStr)
		d result.Execute()
		
		s count=0
		s resultString=""
		s end=start+limit
		
		s json=##class(dhc.pa.comm.JsonObj).%New()
		s jsonTitle="rowid^parRef^code^name^shortcut^appSysDr^frequency^KPIDr^KPIName^desc^level^appSys^quency"
		
		While(result.Next())
		{	
			s rowid=result.Data("Schem_rowid")
			s parRef=result.Data("Schem_parRef")
			s code=result.Data("Schem_code")
			s name=result.Data("Schem_name")
			s shortcut=result.Data("Schem_shortcut")
			s appSysDr=result.Data("Schem_appSysDr")
			s appSys = appSysDr
			i appSysDr="1" s appSysDr="全院"
			i appSysDr="2" s appSysDr="科室"
			i appSysDr="3" s appSysDr="护理"
			i appSysDr="4" s appSysDr="医疗"
			i appSysDr="5" s appSysDr="个人"
			s frequency=result.Data("Schem_frequency")
			s quency = frequency
			i frequency="M" s frequency="月份"
			i frequency="Q" s frequency="季度"
			i frequency="Y" s frequency="年度"
			i frequency="H" s frequency="半年"
			
			s KPIDr=result.Data("Schem_KPIDr")
			s KPIName=""
			i KPIDr'="" d
			.i $D(^DHCCJXPAKPIINDEX1(KPIDr)) d
			..i $G(^DHCCJXPAKPIINDEX1(KPIDr))'="" d
			...s KPIName = $p($g(^DHCCJXPAKPIINDEX1(KPIDr)),"^",2)
			
			s desc=result.Data("Schem_desc")
			s level=result.Data("Schem_level")
			s tmp=rowid_"^"_parRef_"^"_code_"^"_name_"^"_shortcut_"^"_appSysDr_"^"_frequency_"^"_KPIDr_"^"_KPIName_"^"_desc_"^"_level_"^"_appSys_"^"_quency
			s count=count+1
			i searchValue'="" d
			.q:(searchField="code")&(code'[searchValue)
			.q:(searchField="name")&(name'[searchValue)
			.q:(searchField="shortcut")&(shortcut'[searchValue)
			.q:(searchField="desc")&(desc'[searchValue)
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

/// Creator：李明忠
/// CreatDate：2010-7-30
/// Description: 查询符合条件的绩效单元记录
/// Table：dhc_pa_data.UnitSchem
/// Input：schemDr-绩效方案ID;searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.pa.udata.uUnitSchem).JXUnitList("","","rowid","DESC",0,25,"1||28")
ClassMethod JXUnitList(searchField, searchValue, sortField, sortDir, start, limit, schemDr) As %String
{
	n (searchField, searchValue, sortField, sortDir, start, limit, schemDr)
	
	s sqlStr="select UnitSchem_parRef,UnitSchem_rowid,UnitSchem_childSub,UnitSchem_schemDr from dhc_pa_data.UnitSchem"
	s whereStr=" where UnitSchem_childSub>0"
	s whereStr=whereStr_" and UnitSchem_schemDr ='"_schemDr_"'"
	
	s sortStr="",sortField1=""
	i sortField'="" d
	.i sortField="parRefCode" s sortField1="UnitSchem_parRef"
	.i sortField="parRefName" s sortField1="UnitSchem_parRef"
	.i sortField="rowid" s sortField1="UnitSchem_rowid"
	.i sortField="childSub" s sortField1="UnitSchem_childSub"
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="desc")||(sortDir="asc") s sortStr=" order by "_sortField1_" "_sortDir
	.e  s sortStr=" order by "_sortField1_" asc"
	e  s sortStr=" order by %ID desc"
	
	s sqlStr=sqlStr_whereStr_sortStr
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="parRef^parRefCode^parRefName^jxLocTypeDr^jxLocTypeName^rowid^childSub^schemDr"
	
	While(result.Next()){
		//集体初始化
		s parRefCode="",parRefName="",jxLocTypeDr="",jxLocTypeName=""
		//绩效单元
		s parRef=result.Data("UnitSchem_parRef")
		i parRef'="" d
		.i $D(^DHCCJXPAJXUNIT(parRef)) d
		..i $G(^DHCCJXPAJXUNIT(parRef))'="" d
		...s parRefCode=$P($G(^DHCCJXPAJXUNIT(parRef)),"^",2)
		...s parRefName=$P($G(^DHCCJXPAJXUNIT(parRef)),"^",3)
		...s jxLocTypeDr=$P($G(^DHCCJXPAJXUNIT(parRef)),"^",7)
		...i jxLocTypeDr'="" d
		....i $D(^DHCCJXPAJXLOCTYPE(jxLocTypeDr)) d
		.....i $G(^DHCCJXPAJXLOCTYPE(jxLocTypeDr))'="" d
		......s jxLocTypeName=$P($G(^DHCCJXPAJXLOCTYPE(jxLocTypeDr)),"^",2)
		s rowid=result.Data("UnitSchem_rowid")
		s childSub=result.Data("UnitSchem_childSub")
		s schemDr=result.Data("UnitSchem_schemDr")
		
		s tmp=parRef_"^"_parRefCode_"^"_parRefName_"^"_jxLocTypeDr_"^"_jxLocTypeName_"^"_rowid_"^"_childSub_"^"_schemDr
		
		i searchValue'="" d
		.q:(searchField = "parRefCode")&(parRefCode'[searchValue)
		.q:(searchField = "parRefName")&(parRefName'[searchValue)
		.q:(searchField = "jxLocTypeName")&(jxLocTypeName'[searchValue)
		.i (count>=start)&(count<=end) d
		..d json.InsertRowData(tmp)
		.s count=count+1
		e  d
		.i (count>=start)&(count<=end) d
		..d json.InsertRowData(tmp)
		.s count=count+1
	}
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator:李明忠
/// CreatDate:2010-7-30
/// Description:删除绩效单元下的考核方案记录
/// Table:dhc_pa_data.UnitSchem
/// Input:rowid-考核方案记录ID
/// Output: 
/// Return:返回执行删除语句后的SQLCODE
/// Others:w ##class(dhc.pa.udata.uUnitSchem).Delete(4)
ClassMethod Delete(rowid) As %String
{
	n (rowid)
	
	&SQL(delete from dhc_pa_data.UnitSchem where UnitSchem_rowid=:rowid)
	q SQLCODE
}

/// Creator：李明忠
/// CreatDate：2010-7-30
/// Description: 判断同一绩效单元下是否存在同一绩效方案记录
/// Table：dhc_pa_data.UnitSchem
/// Input：parRef-绩效单元ID;schemDr-绩效方案ID
/// Output：
/// Return：返回childSub
/// Others：w ##class(dhc.pa.udata.uUnitSchem).IfRepRecode()
ClassMethod IfRepRecode(parRef, schemDr) As %String
{
	n (parRef,schemDr)
	
	s childSub="" 
	s childSub = $O(^DHCCJXPAJXUNIT(0,"UnitSchemSchem",parRef,schemDr,childSub))
	q childSub
}

/// Creator：李明忠
/// CreatDate：2010-12-2(修改)
/// Description: 为给定的绩效单元添加绩效方案记录
/// Table：dhc_pa_data.UnitSchem
/// Input：schemDr-绩效方案ID;jxUnitStr-绩效单元ID字符串
/// Output：
/// Return：返回SQLCODE
/// Others：w ##class(dhc.pa.udata.uUnitSchem).Insert("1||4","10-1")
ClassMethod Insert(schemDr, jxUnitStr) As %String
{
	n (schemDr,jxUnitStr)
	
	k PLIST
	
	s str1=""
	s str2=""
	s Len=$L(jxUnitStr,"-")
	f k=1:1:Len d
	.s jxUnitDr=$P(jxUnitStr,"-",k)
	.i jxUnitDr'="" d
	..s tmpRow=..IfRepRecode(jxUnitDr,schemDr)
	..i tmpRow'="" d
	...i str1="" s str1=tmpRow
	...e  s str1=str1_"-"_tmpRow
	..e  d
	...i jxUnitDr'="" s PLIST(0)=jxUnitDr  //绩效单元
	...i schemDr'="" s PLIST(3)=schemDr    //绩效考核方案
	...&SQL(insert into dhc_pa_data.UnitSchem VALUES PLIST())
	...s str2=SQLCODE
	
	q:str1="" str2
	q:str1'="" str1_"^"_str2
}

/// Creator：李明忠
/// CreatDate：2010-8-4
/// Description: 更新绩效方案下的绩效单元记录
/// Table：dhc_pa_data.UnitSchem
/// Input：rowid-所在行号;schemDr-绩效方案ID;jxUnitDr-绩效单元ID
/// Output：
/// Return：返回执行更新语句后的SQLCODE
/// Others：w ##class(dhc.pa.udata.uUnitSchem).Update("10||10","1||28","52")
ClassMethod Update(rowid, schemDr, jxUnitDr) As %String
{
	n (rowid,schemDr,jxUnitDr)
	
	q:rowid="" "rowidEmpt"					//错误数据
	k PLIST
				
	i jxUnitDr'="" s PLIST(0)=jxUnitDr  //绩效单元
				
	i schemDr'="" s PLIST(3)=schemDr    //绩效考核方案
	
	s childSub=..IfRepRecode(jxUnitDr,schemDr)
	q:(childSub'="")&((jxUnitDr_"||"_childSub)'=rowid) "RepRecode"
    
	&sql(update dhc_pa_data.UnitSchem values PLIST() where %ID=:rowid)
	q SQLCODE
}

/// Creator：李明忠
/// CreatDate：2010-12-2(修改)
/// Description: 获取用户所拥有权限的绩效单元
/// Table：dhc_pa_data.UnitSchem
/// Input：userCode-用户代码;start:开始记录位置;limit:单页记录条数
/// Output：
/// Return：返回绩效单元
/// Others：w ##class(dhc.pa.udata.uUnitSchem).GetJXUnit("Demo")
ClassMethod GetJXUnit(userCode) As %String
{
	n (userCode)
	q:userCode="" "NoData"
	
	s userCode=$$ALPHAUP^SSUTIL4(userCode)
	//根据用户Code查找用户ID
	s userId=0
	s userId=$O(^SSU("SSUSR",0,"SSUSR_Initials",userCode,userId))
	q:userId="" "NoData"
	
	s result = ##class(%Library.ResultSet).%New()
	//s sqlStr = "select JXUnitAudit_jxUnitDr from dhc_pa_data.JXUnitAudit where %ID>0 and JXUnitAudit_userDr="_userId

	s sqlStr="select JXUnit_rowid,JXUnit_code,JXUnit_name from dhc_pa_data.JXUnit where JXUnit_rowid in (select JXUnitAudit_jxUnitDr from dhc_pa_data.JXUnitAudit where JXUnitAudit_rowid>0 and JXUnitAudit_userDr="_userId_")"_" and JXUnit_isEnd='Y'"
	 
	;w sqlStr,!
	 
	d result.Prepare(sqlStr)
	d result.Execute()

	s count = 0
	s resultString = ""
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	While(result.Next()){
		s jxUnitDr = result.Data("JXUnit_rowid")
		s jxUnitCode = result.Data("JXUnit_code")
		s jxUnitName = result.Data("JXUnit_name")
		i jxUnitDr'="" d 
		.s tmp=jxUnitDr_"^"_jxUnitCode_"^"_jxUnitName
		.s count = count+1
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("jxUnitDr^jxUnitCode^jxUnitName",count)
 	k json
	q resultString
}

/// Creator：wang ying
/// CreatDate：2014-12-10
/// Description: 获取用户所拥有权限的绩效单元
/// Table：dhc_pa_data.UnitSchem
/// Input：userCode-用户代码;start:开始记录位置;limit:单页记录条数
/// Output：
/// Return：返回绩效单元
/// Others：w ##class(dhc.pa.udata.uUnitSchem).GetJXUnitNew(0,10,"Demo","消化")
ClassMethod GetJXUnitNew(start, limit, userCode, str) As %String
{
	n (start,limit,userCode,str)
	q:userCode="" "NoData"
	
	s userCode=$$ALPHAUP^SSUTIL4(userCode)
	//根据用户Code查找用户ID
	s userId=0
	s userId=$O(^SSU("SSUSR",0,"SSUSR_Initials",userCode,userId))
	q:userId="" "NoData"

	s end=start+limit-1
	s result = ##class(%Library.ResultSet).%New()
	//s sqlStr = "select JXUnitAudit_jxUnitDr from dhc_pa_data.JXUnitAudit where %ID>0 and JXUnitAudit_userDr="_userId

	s sqlStr="select JXUnit_rowid,JXUnit_code,JXUnit_name,JXUnit_jxLocTypeDr from dhc_pa_data.JXUnit where JXUnit_rowid in (select JXUnitAudit_jxUnitDr from dhc_pa_data.JXUnitAudit where JXUnitAudit_rowid>0 and JXUnitAudit_userDr="_userId_")"_" and JXUnit_isEnd='Y'"
	i str'=""  s sqlStr=sqlStr_" and JXUnit_name like '%"_str_"%'"
	;w sqlStr,!
	 
	d result.Prepare(sqlStr)
	d result.Execute()

	s count = 0
	s resultString = ""
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	While(result.Next()){
		s jxUnitDr = result.Data("JXUnit_rowid")
		s jxUnitCode = result.Data("JXUnit_code")
		s jxUnitName = result.Data("JXUnit_name")
		//绩效单元类别(所属科室类别)
        s jxLocTypeDr = result.Data("JXUnit_jxLocTypeDr")
        s jxLocTypeName =""
        i jxLocTypeDr'="" d
        .i $D(^DHCCJXPAJXLOCTYPE(jxLocTypeDr)) d
        ..i $G(^DHCCJXPAJXLOCTYPE(jxLocTypeDr)) d
        ...s jxLocTypeName=$P(^DHCCJXPAJXLOCTYPE(jxLocTypeDr),"^",2)
        
		i jxUnitDr'="" d 
		.s tmp=jxUnitDr_"^"_jxUnitCode_"^"_jxUnitName_"^"_jxLocTypeName
		.s count = count+1
		.i (count>=start)&(count<=end) d
		..d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("jxUnitDr^jxUnitCode^jxUnitName^jxLocTypeName",count)
 	k json
	q resultString
}

/// Creator：wang ying
/// CreatDate：2010-12-16
/// Description: 获取用户所拥有权限并不在绩效单元方案中的绩效单元
/// Table：dhc_pa_data.UnitSchem
/// Input：userCode-用户代码;start:开始记录位置;limit:单页记录条数
/// Output：
/// Return：返回绩效单元
/// Others：w ##class(dhc.pa.udata.uUnitSchem).GetJXUnitNoUnitSchem("","","zhuangyan")
ClassMethod GetJXUnitNoUnitSchem(start, limit, userCode) As %String
{
	n (start,limit,userCode)
	q:userCode="" "NoData"
	
	s currstragem=##class(dhc.pa.report.uDeptReport).GetCurrStratagemDr()
	q:currstragem="" "Nocurrstragem"
	s userCode=$$ALPHAUP^SSUTIL4(userCode)
	//根据用户Code查找用户ID
	s userId=0
	s userId=$O(^SSU("SSUSR",0,"SSUSR_Initials",userCode,userId))
	q:userId="" "NoData"
	
	s count=0
	s unitList=##class(%Library.ListOfDataTypes).%New()
	i (start'=""&&limit'="") s end=start+limit-1
	//绩效单元方案中存在的绩效单元
	s unitResult=0
	s unitAduit=0
	f  s unitAduit=$o(^DHCCJXPASTRATAGEM(0,"UnitResultJXUnit",currstragem,unitAduit)) q:unitAduit=""  d
	.d unitList.Insert(unitAduit)
	s resultString = ""
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	s unitAduit=0
	f  s unitAduit=$o(^DHCCJXPAJXUNITAUDIT(0,"User",userId,unitAduit)) q:unitAduit=""  d
	.i $d(^DHCCJXPAJXUNITAUDIT(unitAduit)) d
	..s unitAduitAll=$g(^DHCCJXPAJXUNITAUDIT(unitAduit))
	..s isWrite=$p(unitAduitAll,"^",4)
	..s jxUnitDr=$p(unitAduitAll,"^",1)
	..i (isWrite="Y")&&(jxUnitDr'="") d
	...i $d(^DHCCJXPAJXUNIT(jxUnitDr)) d
	....s str=unitList.Find(jxUnitDr,1)
	....i str="" d
	.....s jxUnitAll=$g(^DHCCJXPAJXUNIT(jxUnitDr))
	.....s jxUnitCode=$p(jxUnitAll,"^",2)
	.....s jxUnitName=$p(jxUnitAll,"^",3)
	.....s jxLocTypeDr=$p(jxUnitAll,"^",7)
	.....s jxLocTypeName=""
	.....i $D(^DHCCJXPAJXLOCTYPE(jxLocTypeDr)) d
	......i $G(^DHCCJXPAJXLOCTYPE(jxLocTypeDr))'="" d
	.......s jxLocTypeName=$P(^DHCCJXPAJXLOCTYPE(jxLocTypeDr),"^",2)
	.....s tmp=jxUnitDr_"^"_jxUnitCode_"^"_jxUnitName_"^"_jxLocTypeName
	.....i (start'="")&&(limit'="") d
	......i (count>=start)&(count<=end) d
	.......d json.InsertRowData(tmp)
	......s count = count+1
	.....e  d
	......d json.InsertRowData(tmp)
	......s count = count+1
	
	s resultString = json.getJsonData("jxUnitDr^jxUnitCode^jxUnitName^jxLocTypeName",count)
 	k json
	q resultString
}

/// Creator：李明忠
/// CreatDate：2010-8-18
/// Description: 获取绩效方案下的方案明细
/// Table：dhc_pa_data.SchemDetail
/// Input：parent-父级节点;schemDr:绩效方案Dr;searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向
/// Output：
/// Return：返回返回parent下方案明细
/// Others：w ##class(dhc.pa.udata.uUnitSchem).GetSchemDetail("roo","1||6","","","","")
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
		s KPIIndexName="",KPICode="",method="",Flag="false",methodCode="",calUnitDr="",calUnitName="",colDeptDr="",colDeptName="",target="",extreMumName="",extreMum=""
		
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
		....s extreMum =  $P(^DHCCJXPAKPIINDEX1(KPI),"^",9)
		....i extreMum="H" s extreMumName="趋高"
		....i extreMum="M" s extreMumName="趋中"
		....i extreMum="L" s extreMumName="趋低"
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
		
		
		s unitDr=0
		
		//收集单位
		i colDeptDr'="" d
		.i $D(^DHCCJXPAJXUNIT(colDeptDr)) d
		..i $G(^DHCCJXPAJXUNIT(colDeptDr))'="" d
		...s colDeptName=$P(^DHCCJXPAJXUNIT(colDeptDr),"^",3)
		
		s resultString=resultString_"{id:'"_KPI_"',detailid:'"_rowid_"',code:'"_KPICode_"',name:'"_KPIIndexName_"',scoreMethodCode:'"_methodCode_"',scoreMethodName:'"_method_"',order:'"_order_"',rate:'"_rate_"',isTarget:'"_isTarget_"',colDeptName:'"_colDeptName_"',target:'"_target_"',extreMum:'"_extreMum_"',extreMumName:'"_extreMumName_"',calUnitName:'"_calUnitName_"',leaf:"_Flag_",uiProvider:'col'},"
	}
		
	s resultString=resultString_"]"
	d result.Close()
	q resultString
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.uUnitSchemS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
