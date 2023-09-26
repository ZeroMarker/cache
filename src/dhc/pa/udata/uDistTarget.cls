/// Creator: 李明忠
/// CreatDate: 2010-08-10
/// Description: 目标分解设置
Class dhc.pa.udata.uDistTarget Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: wang ying
/// CreatDate: 2010-07-26
/// Description: 查询符合条件的记录
/// Table: dhc.pa.data.Schem
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;dataFinish-数据采集标志;treatFinish-数据处理标志;tieOff-扎帐标志;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.pa.udata.uDistTarget).ListRec("Y","name","妇产","","",0,10)
ClassMethod ListRec(active, searchField, searchValue, sortField, sortDir, start, limit) As %String
{
		n (active,searchField, searchValue, sortField, sortDir, start, limit)
		
		s Stratagem = ""
		s curreStratagemDr = ""
		f  s Stratagem=$o(^DHCCJXPASTRATAGEM(Stratagem)) q:Stratagem=""  d
		.i $D(^DHCCJXPASTRATAGEM(Stratagem)) d
		..i $g(^DHCCJXPASTRATAGEM(Stratagem))'="" d
		...s curreStratagem = $P(^DHCCJXPASTRATAGEM(Stratagem),"^",14)
		...if curreStratagem="Y" d
		....s curreStratagemDr = Stratagem
		
		s sqlStr="SELECT Schem_rowid,Schem_parRef,Schem_code,Schem_name,Schem_shortcut,Schem_appSysDr,Schem_frequency,Schem_KPIDr,Schem_desc,Schem_active,Schem_level FROM dhc_pa_data.Schem WHERE Schem_childSub>0 and Schem_parRef="_curreStratagemDr
			s sqlStr=sqlStr_"  and Schem_active='Y' "  //2016-8-10 add	
		s sortStr=""
		s sortField1=""
		s sortField="shortcut" 
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
		e  d
		.s sortStr="ORDER BY %ID DESC"
		
		s sqlStr=sqlStr_sortStr
		
		s result=##class(%Library.ResultSet).%New()
		
		d result.Prepare(sqlStr)
		d result.Execute()
		
		s count=0
		s resultString=""
		s end=start+limit
		
		s json=##class(dhc.pa.comm.JsonObj).%New()
		s jsonTitle="rowid^parRef^code^name^shortcut^appSysDr^frequency^KPIDr^KPIName^desc^level^appSys^quency^shortCutFreQuency"
		
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
			s shortCutFreQuency=shortcut_"!"_frequency
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
			...s KPIName = $P($G(^DHCCJXPAKPIINDEX1(KPIDr)),"^",2)
			s desc=result.Data("Schem_desc")
			s level=result.Data("Schem_level")
			
			s tmp=rowid_"^"_parRef_"^"_code_"^"_name_"^"_shortcut_"^"_appSysDr_"^"_frequency_"^"_KPIDr_"^"_KPIName_"^"_desc_"^"_level_"^"_appSys_"^"_quency_"^"_shortCutFreQuency
			
			i searchValue'="" d
			.q:(searchField="code")&(code'[searchValue)
			.q:(searchField="name")&(name'[searchValue)
			.q:(searchField="shortcut")&(shortcut'[searchValue)
			.q:(searchField="desc")&(desc'[searchValue)
			.s count=count+1
			.i (count>start)&(count<=end) d
			..d json.InsertRowData(tmp)
			e  d
			.s count=count+1
			.i (count>start)&(count<=end) d
			..d json.InsertRowData(tmp)
		}
	
		d result.Close()
		s resultString = json.getJsonData(jsonTitle,count)
	 	k json
		q resultString
}

/// Creator: wang ying
/// CreatDate: 2010-07-26
/// Description: 查询符合条件的记录
/// Table: dhc.pa.data.Schem
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;dataFinish-数据采集标志;treatFinish-数据处理标志;tieOff-扎帐标志;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.pa.udata.uDistTarget).ListRec("Y","name","妇产","","",0,10)
ClassMethod SchemList(active, searchField, searchValue, sortField, sortDir, start, limit, type) As %String
{
		n (active,searchField, searchValue, sortField, sortDir, start, limit,type)
		
		s Stratagem = ""
		s curreStratagemDr = ""
		f  s Stratagem=$o(^DHCCJXPASTRATAGEM(Stratagem)) q:Stratagem=""  d
		.i $D(^DHCCJXPASTRATAGEM(Stratagem)) d
		..i $g(^DHCCJXPASTRATAGEM(Stratagem))'="" d
		...s curreStratagem = $P(^DHCCJXPASTRATAGEM(Stratagem),"^",14)
		...if curreStratagem="Y" d
		....s curreStratagemDr = Stratagem
		
		s sqlStr="SELECT Schem_rowid,Schem_parRef,Schem_code,Schem_name,Schem_shortcut,Schem_appSysDr,Schem_frequency,Schem_KPIDr,Schem_desc,Schem_active,Schem_level FROM dhc_pa_data.Schem WHERE Schem_childSub>0 and Schem_parRef="_curreStratagemDr
			s sqlStr=sqlStr_"  and Schem_active='Y' "  //2016-8-10 add	
		i type'="" s sqlStr=sqlStr_" and Schem_frequency='"_type_"'" 
		s sortStr=""
		s sortField1=""
		s sortField="shortcut" 
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
		e  d
		.s sortStr="ORDER BY %ID DESC"
		
		s sqlStr=sqlStr_sortStr
		;w sqlStr,!
		s result=##class(%Library.ResultSet).%New()
		
		d result.Prepare(sqlStr)
		d result.Execute()
		
		s count=0
		s resultString=""
		s end=start+limit
		
		s json=##class(dhc.pa.comm.JsonObj).%New()
		s jsonTitle="rowid^parRef^code^name^shortcut^appSysDr^frequency^KPIDr^KPIName^desc^level^appSys^quency^shortCutFreQuency"
		
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
			s shortCutFreQuency=shortcut_"!"_frequency
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
			...s KPIName = $P($G(^DHCCJXPAKPIINDEX1(KPIDr)),"^",2)
			s desc=result.Data("Schem_desc")
			s level=result.Data("Schem_level")
			
			s tmp=rowid_"^"_parRef_"^"_code_"^"_name_"^"_shortcut_"^"_appSysDr_"^"_frequency_"^"_KPIDr_"^"_KPIName_"^"_desc_"^"_level_"^"_appSys_"^"_quency_"^"_shortCutFreQuency
			
			i searchValue'="" d
			.q:(searchField="code")&(code'[searchValue)
			.q:(searchField="name")&(name'[searchValue)
			.q:(searchField="shortcut")&(shortcut'[searchValue)
			.q:(searchField="desc")&(desc'[searchValue)
			.s count=count+1
			.i (count>start)&(count<=end) d
			..d json.InsertRowData(tmp)
			e  d
			.s count=count+1
			.i (count>start)&(count<=end) d
			..d json.InsertRowData(tmp)
		}
	
		d result.Close()
		s resultString = json.getJsonData(jsonTitle,count)
	 	k json
		q resultString
}

/// Creator：李明忠
/// CreatDate：2010-8-10
/// Description: 获取绩效单位
/// Table：dhc_pa_data.UnitSchem
/// Input：start:开始记录位置;limit:单页记录条数;schemDr-方案ID
/// Output：
/// Return：有效绩效单位字符串
/// Others：w ##class(dhc.pa.udata.uDistTarget).GetDept(0,10,"1||6")
ClassMethod GetDept(start, limit, schemDr) As %String
{
	n (start, limit, schemDr)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select distinct UnitSchem_parRef from dhc_pa_data.UnitSchem where UnitSchem_childSub>0 and UnitSchem_schemDr='"_schemDr_"'"
	
	d result.Prepare(sqlStr)
	d result.Execute()

	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	While(result.Next()){
		//集体初始化
		s jxUnitName="",shortCut=""
		s jxUnitDr = result.Data("UnitSchem_parRef")
		i jxUnitDr'="" d
		.i $D(^DHCCJXPAJXUNIT(jxUnitDr)) d
		..i $G(^DHCCJXPAJXUNIT(jxUnitDr))'="" d
		...s jxUnitName=$P(^DHCCJXPAJXUNIT(jxUnitDr),"^",3)
		...s shortCut=$P(^DHCCJXPAJXUNIT(jxUnitDr),"^",5)
		.s tmp=jxUnitDr_"^"_jxUnitName_"^"_shortCut
		.s count = count+1
		.i (count>start)&(count<=end) d
		..d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("jxUnitDr^jxUnitName^shortCut",count)
 	k json
	q resultString
}

/// Creator：李明忠
/// CreatDate：2010-8-10
/// Description: 获取KPI
/// Table：dhc_pa_data.KPIIndex1
/// Input：start:开始记录位置;limit:单页记录条数;schemDr-方案ID
/// Output：
/// Return：有效KPI字符串
/// Others：w ##class(dhc.pa.udata.uDistTarget).GetKPI(0,10,"1||6","demo")
ClassMethod GetKPI(start, limit, schemDr, userCode) As %String
{
	n (start, limit, schemDr ,userCode)
	
	s userCode=$$ALPHAUP^SSUTIL4(userCode)
	//根据用户Code查找用户ID
	s userId=0
	s userId=$O(^SSU("SSUSR",0,"SSUSR_Initials",userCode,userId))
	
	
	s result = ##class(%Library.ResultSet).%New()
	;s sqlStr = "SELECT KPIIndex1_rowid,KPIIndex1_name FROM dhc_pa_data.KPIIndex1 where %ID>0 and KPIIndex1_isKPI='Y' and KPIIndex1_isEnd='Y'and EXISTS (SELECT SchemDetail_KPIDr FROM dhc_pa_data.SchemDetail where dhc_pa_data.KPIIndex1.KPIIndex1_rowid =dhc_pa_data.SchemDetail.SchemDetail_KPIDr and SchemDetail_parRef='"_schemDr_"')"
	
	//2011-12-07修改  增加指标按用户权限筛选
	s sqlStr = "SELECT KPIIndex1_rowid,KPIIndex1_name FROM dhc_pa_data.KPIIndex1 ,dhc_pa_data.KPIAudit where KPIAudit_rowid>0  and KPIIndex1_isKPI='Y' and KPIIndex1_isEnd='Y' and KPIAudit_userDr="_userId_"  and KPIAudit_KPIDr=KPIIndex1_rowid  and EXISTS (SELECT SchemDetail_KPIDr FROM dhc_pa_data.SchemDetail where dhc_pa_data.KPIIndex1.KPIIndex1_rowid =dhc_pa_data.SchemDetail.SchemDetail_KPIDr and SchemDetail_parRef='"_schemDr_"')"
	;q sqlStr
	d result.Prepare(sqlStr)
	d result.Execute()

	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("KPIIndex1_rowid")
		s name = result.Data("KPIIndex1_name")
		s tmp=rowid_"^"_name
		s count = count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("rowid^name",count)
 	k json
	q resultString
}

/// Creator：李明忠
/// CreatDate：2010-8-11
/// Description: 查询方案对应的绩效单元
/// Table：dhc_pa_data.UnitSchem
/// Input：schemDr-当前方案
/// Output：
/// Return：绩效单元字符串
/// Others：w ##class(dhc.pa.udata.uDistTarget).GetJXUnitOfSchem("1||3")
ClassMethod GetJXUnitOfSchem(schemDr) As %String
{
	n (schemDr)
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select UnitSchem_parRef from dhc_pa_data.UnitSchem where UnitSchem_childSub>0 and UnitSchem_schemDr='"_schemDr_"'"

	d result.Prepare(sqlStr)
	d result.Execute()
	s resultString = ""
	
	While(result.Next()){
		s parRef = result.Data("UnitSchem_parRef")
		i parRef'="" d
		.i resultString="" s resultString=parRef
		.e  s resultString=resultString_"^"_parRef
	}
	
	d result.Close()
	q resultString
}

/// Creator:李明忠
/// CreatDate:2010-8-11
/// Description:查询绩效考核方案下的指标Dr字符串
/// Table:dhc_pa_data.UnitSchem
/// Input:schemDr-绩效方案Dr
/// Output:
/// Return:返回绩效考核方案下的指标Dr字符串
/// Others:w ##class(dhc.pa.udata.uDistTarget).GetKPIOfSchem("1||21")
ClassMethod GetKPIOfSchem(schemDr) As %String
{
	n (schemDr)
	
	s KPIDrStr=""
	q:schemDr="" KPIDrStr
	
	s result = ##class(%Library.ResultSet).%New()
	;s sqlStr = "SELECT KPIIndex1_rowid FROM dhc_pa_data.KPIIndex1 where %ID>0 and KPIIndex1_isKPI='Y' and KPIIndex1_isEnd='Y' and EXISTS (SELECT SchemDetail_KPIDr FROM dhc_pa_data.SchemDetail where dhc_pa_data.KPIIndex1.KPIIndex1_rowid =dhc_pa_data.SchemDetail.SchemDetail_KPIDr and SchemDetail_isTarget=2 and SchemDetail_parRef='"_schemDr_"')"
	s sqlStr = "SELECT KPIIndex1_rowid FROM dhc_pa_data.KPIIndex1 where %ID>0 and KPIIndex1_isKPI='Y'  and EXISTS (SELECT SchemDetail_KPIDr FROM dhc_pa_data.SchemDetail where dhc_pa_data.KPIIndex1.KPIIndex1_rowid =dhc_pa_data.SchemDetail.SchemDetail_KPIDr and SchemDetail_isTarget=2 and SchemDetail_parRef='"_schemDr_"')"
	;w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()
	
	While(result.Next()){
		s rowid = result.Data("KPIIndex1_rowid")
		i rowid'="" d
		.s KPIDr=rowid
		.i KPIDrStr="" s KPIDrStr=KPIDr
		.e  s KPIDrStr=KPIDrStr_"^"_KPIDr
	}
	
	q KPIDrStr
}

/// Creator：李明忠
/// CreatDate：2010-8-13
/// Description: 根据当前月获取生成季度数量的Count
/// Table：
/// Input：currMonth-当前月
/// Output：
/// Return：返回数量Count
/// Others：w ##class(dhc.pa.udata.uDistTarget).GetCount(4)
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
/// CreatDate：2010-9-13
/// Description: 获取当前战略Dr
/// Table：dhc_pa_data.Stratagem
/// Input：
/// Output：
/// Return：当前战略DR
/// Others：w ##class(dhc.pa.udata.uDistTarget).GetCurrStratagemDr()
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
/// Description: 判断当前战略下的方案等是否已经初始化
/// Table：
/// Input：
/// Output：
/// Return：判断标志"Copyed"或者当前战略DR
/// Others：w ##class(dhc.pa.udata.uDistTarget).JudgeInit()
ClassMethod JudgeInit(SchemDr) As %String
{
	n (SchemDr)
	
	s tmpStr=..GetCurrStratagemDr()
	//表示没有当前战略记录
	q:tmpStr="NoCurrRecord" tmpStr 
	//表示有多条当前战略记录
	q:tmpStr="RepCurrRecord" tmpStr 
	//如果当前战略的数据已经复制了,则退出
	q:$D(^DHCCJXPASTRATAGEM(0,"UnitResultSchem",tmpStr,SchemDr)) "Copyed"
	
	q tmpStr
}

/// Creator：李明忠
/// CreatDate：2010-8-11
/// Description: 数据初始化
/// Table：
/// Input：CycleDr-战略年度Dr,SchemDr-方案Dr
/// Output：
/// Return：成功或失败标志
/// Others：w ##class(dhc.pa.udata.uDistTarget).Init(3,"1||1")
ClassMethod Init(CycleDr, SchemDr) As %String
{
	n (CycleDr,SchemDr)
	;w $zt($p($h,",",2)),!
	q:CycleDr="" "NoCycle" //表示没有选择年度
	q:SchemDr="" "NoSchem" //表示没有选择方案
	
	
	s rs=0,flag="true",cycleCode="" //定义返回值标志,SQL执行标志,年度代码
	
	s currStratagemDr=..GetCurrStratagemDr()
	q:currStratagemDr="NoCurrRecord" currStratagemDr //表示没有当前战略记录
	q:currStratagemDr="RepCurrRecord" currStratagemDr //表示有多条当前战略记录
	q:$P(^DHCCJXPASTRATAGEM(currStratagemDr),"^",2)'=CycleDr "ErrCycle" //获取年度,如果不传入参数年度不符,则退出

	i CycleDr'="" d
	.i $D(^DHCCJXPACYCLE(CycleDr)) d
	..i $G(^DHCCJXPACYCLE(CycleDr))'="" s cycleCode=$P(^DHCCJXPACYCLE(CycleDr),"^",1)
	q:cycleCode="" "ErrCycle" //没有年度将不复制记录
	
	
	s flag=..CopySchems(cycleCode,SchemDr) //复制绩效方案
	i flag'="true" s rs=1
	q:flag="nullUnit" "nullUnit" //该方案下没有科室
	q:flag="false" "false1"
	
	;w "1",!
	s flag=..CopySchemDetailData(currStratagemDr,SchemDr)
	i flag'="true" s rs=1
	q:flag="NoSchem" "NoSchem2" //没有方案
	q:flag="false" "false2"
	;w "Detail",!
	s flag=..CopySchemDetailAddData(SchemDr)
	i flag'="true" s rs=1
	q:flag="NoSchem" "NoSchem3" //没有方案
	q:flag="false" "false3"
	;w "add",!
	s flag=..CopySchemDetailDistData(SchemDr)
	;w SchemDr,!
	i flag'="true" s rs=1
	q:flag="NoSchem" "NoSchem4" //没有方案
	q:flag="false" "false4"
	
    ;w $zt($p($h,",",2)),!
	q flag
}

/// Creator：李明忠
/// CreatDate：2010-8-11
/// Description: 复制方案
/// Table：dhc_pa_data.Schem
/// Input：cycleCode-年度代码;schemDr-方案Dr
/// Output：
/// Return：成功或失败标志
/// Others：w ##class(dhc.pa.udata.uDistTarget).CopySchems("2010",1)
ClassMethod CopySchems(cycleCode, schemDr) As %String
{
	n (cycleCode,schemDr)
	
	q:cycleCode="" "false" 
	q:schemDr="" "false" 
	
	s flag="true"
	
	;查询方案的绩效单元
	s jxUnitStr=..GetJXUnitOfSchem(schemDr)
	q:jxUnitStr="" "nullUnit"
	
	s childSub=$P(schemDr,"||",2)
	s currStratagemDr=$P(schemDr,"||",1)
	i $G(^DHCCJXPASTRATAGEM(currStratagemDr,"Schem",childSub))'="" d
	.s frequency=$P($G(^DHCCJXPASTRATAGEM(currStratagemDr,"Schem",childSub)),"^",5)
	.i frequency'="" d
	..s flag=..CopySchemData(cycleCode,frequency,currStratagemDr,schemDr,jxUnitStr)
	
	q flag
}

/// Creator：李明忠
/// CreatDate：2010-8-11
/// Description: 按照报告复制绩效方案
/// Table：dhc_pa_data.UnitResult
/// Input：cycleCode-年度;frequency-报告频率;currStratagemDr-当前战略;schemDr-方案;jxUnitStr-绩效单元
/// Output：
/// Return：成功标志
/// Others：w ##class(dhc.pa.udata.uDistTarget).CopySchemData(2015,"Q",1,"1||1","4")
ClassMethod CopySchemData(cycleCode, frequency, currStratagemDr, schemDr, jxUnitStr) As %String
{
	n (cycleCode,frequency,currStratagemDr,schemDr,jxUnitStr)
	
	TSTART
	s rs=0,flag="true"
	
	i frequency="M" d //按月复制数据
	.;获取应用系统号
	.s appSysDr=$P(^DHCCJXPASTRATAGEM($P(schemDr,"||",1),"Schem",$P(schemDr,"||",2)),"^",4)
	.i appSysDr'="" d
	..s auditState=-1
	..;获取当前月份
	..s currMonth=$P(^DHCCJXPASTRATAGEM(currStratagemDr),"^",8)
	..i currMonth'="" d
	...;生成当前月份至12月数据数量Count
	...s Count=13-currMonth
	...s Length=$L(jxUnitStr,"^")
	...f k=1:1:Length d
	....s jxUnitDr=$P(jxUnitStr,"^",k)
	....i jxUnitDr'="" d
	.....;首先添加一条年度00记录
	.....s period=cycleCode_"00"
	.....s SQLCODE=..CopySchemToPeridRec(currStratagemDr,appSysDr,schemDr,period)
	.....i $D(^DHCCJXPASTRATAGEM(0,"PUSA",currStratagemDr,period,jxUnitDr,schemDr,appSysDr)) d //什么也不做
	.....e  d
	......&SQL(Insert into dhc_pa_data.UnitResult(UnitResult_parRef,UnitResult_schemDr,UnitResult_appSysDr,UnitResult_jxUnitDr,UnitResult_period,UnitResult_auditState) values(:currStratagemDr,:schemDr,:appSysDr,:jxUnitDr,:period,:auditState))
	......i SQLCODE'=0 d
	.......s rs=1
	.....f i=1:1:Count d
	......s month=currMonth+i-1
	......i month<10 d
	.......s month="0"_month
	......s period=cycleCode_month
	......s SQLCODE=..CopySchemToPeridRec(currStratagemDr,appSysDr,schemDr,period)
	......i $D(^DHCCJXPASTRATAGEM(0,"PUSA",currStratagemDr,period,jxUnitDr,schemDr,appSysDr)) d //什么也不做
	......e  d
	.......&SQL(Insert into dhc_pa_data.UnitResult(UnitResult_parRef,UnitResult_schemDr,UnitResult_appSysDr,UnitResult_jxUnitDr,UnitResult_period,UnitResult_auditState) values(:currStratagemDr,:schemDr,:appSysDr,:jxUnitDr,:period,:auditState))
	.......i SQLCODE'=0 d
	........s rs=1
	
	i frequency="Q" d //按季度复制数据
	.;获取应用系统号
	.s appSysDr=$P(^DHCCJXPASTRATAGEM($P(schemDr,"||",1),"Schem",$P(schemDr,"||",2)),"^",4)
	.i appSysDr'="" d
	..s auditState=-1
	..;获取当前月份
	..s currMonth=$P(^DHCCJXPASTRATAGEM(currStratagemDr),"^",8)
	..i currMonth'="" d
	...;生成当前季度至第四季度数据数量Count
	...s Count=..GetCount(currMonth)
	...;根据当前月份获取起始季度
	...s startQuarter=..GetStartQuarter(currMonth)
	...s Length=$L(jxUnitStr,"^")
	...f k=1:1:Length d
	....s jxUnitDr=$P(jxUnitStr,"^",k)
	....i jxUnitDr'="" d
	.....;首先添加一条年度00记录
	.....s period=cycleCode_"00"
	.....s SQLCODE=..CopySchemToPeridRec(currStratagemDr,appSysDr,schemDr,period)
	.....i $D(^DHCCJXPASTRATAGEM(0,"PUSA",currStratagemDr,period,jxUnitDr,schemDr,appSysDr)) d //什么也不做
	.....e  d
	......&SQL(Insert into dhc_pa_data.UnitResult(UnitResult_parRef,UnitResult_schemDr,UnitResult_appSysDr,UnitResult_jxUnitDr,UnitResult_period,UnitResult_auditState) values(:currStratagemDr,:schemDr,:appSysDr,:jxUnitDr,:period,:auditState))
	......i SQLCODE'=0 d
	.......s rs=1
	.....f i=1:1:Count d
	......s Quarter="0"_(startQuarter+i-1)
	......s period=cycleCode_Quarter
	......s SQLCODE=..CopySchemToPeridRec(currStratagemDr,appSysDr,schemDr,period)
	......i $D(^DHCCJXPASTRATAGEM(0,"PUSA",currStratagemDr,period,jxUnitDr,schemDr,appSysDr)) d //什么也不做
	......e  d
	.......&SQL(Insert into dhc_pa_data.UnitResult(UnitResult_parRef,UnitResult_schemDr,UnitResult_appSysDr,UnitResult_jxUnitDr,UnitResult_period,UnitResult_auditState) values(:currStratagemDr,:schemDr,:appSysDr,:jxUnitDr,:period,:auditState))
	.......i SQLCODE'=0 d
	........s rs=1
	
	i frequency="H" d //按半年复制数据
	.;获取应用系统号
	.s appSysDr=$P(^DHCCJXPASTRATAGEM($P(schemDr,"||",1),"Schem",$P(schemDr,"||",2)),"^",4)
	.i appSysDr'="" d
	..s auditState=-1
	..;获取当前月份
	..s currMonth=$P(^DHCCJXPASTRATAGEM(currStratagemDr),"^",8)
	..i currMonth'="" d
	...;生成当前所属半年至下半年数据数量Count
	...i currMonth<7 s Count=2
	...e  s Count=1
	...;根据当前月份获取起始半年期间
	...s startHalfYear=..GetStartHalfYear(currMonth)
	...s Length=$L(jxUnitStr,"^")
	...f k=1:1:Length d
	....s jxUnitDr=$P(jxUnitStr,"^",k)
	....i jxUnitDr'="" d
	.....;首先添加一条年度00记录
	.....s period=cycleCode_"00"
	.....s SQLCODE=..CopySchemToPeridRec(currStratagemDr,appSysDr,schemDr,period)
	.....i $D(^DHCCJXPASTRATAGEM(0,"PUSA",currStratagemDr,period,jxUnitDr,schemDr,appSysDr)) d //什么也不做
	.....e  d
	......&SQL(Insert into dhc_pa_data.UnitResult(UnitResult_parRef,UnitResult_schemDr,UnitResult_appSysDr,UnitResult_jxUnitDr,UnitResult_period,UnitResult_auditState) values(:currStratagemDr,:schemDr,:appSysDr,:jxUnitDr,:period,:auditState))

	......i SQLCODE'=0 d
	.......s rs=1
	.....f i=1:1:Count d
	......s HalfYear="0"_(startHalfYear+i-1)
	......s period=cycleCode_HalfYear
	......s SQLCODE=..CopySchemToPeridRec(currStratagemDr,appSysDr,schemDr,period)
	......i $D(^DHCCJXPASTRATAGEM(0,"PUSA",currStratagemDr,period,jxUnitDr,schemDr,appSysDr)) d //什么也不做
	......e  d
	.......&SQL(Insert into dhc_pa_data.UnitResult(UnitResult_parRef,UnitResult_schemDr,UnitResult_appSysDr,UnitResult_jxUnitDr,UnitResult_period,UnitResult_auditState) values(:currStratagemDr,:schemDr,:appSysDr,:jxUnitDr,:period,:auditState))

	.......i SQLCODE'=0 d
	........s rs=1
	
	i frequency="Y" d //按年复制数据
	.;获取应用系统号
	.s appSysDr=$P(^DHCCJXPASTRATAGEM($P(schemDr,"||",1),"Schem",$P(schemDr,"||",2)),"^",4)
	.i appSysDr'="" d
	..s Length=$L(jxUnitStr,"^")
	..f k=1:1:Length d
	...s jxUnitDr=$P(jxUnitStr,"^",k)
	...i jxUnitDr'="" d
	....s period=cycleCode_"00"
	....s auditState=-1
	....s SQLCODE=..CopySchemToPeridRec(currStratagemDr,appSysDr,schemDr,period)
	....i $D(^DHCCJXPASTRATAGEM(0,"PUSA",currStratagemDr,period,jxUnitDr,schemDr,appSysDr)) d //什么也不做
	....e  d
	.....&SQL(Insert into dhc_pa_data.UnitResult(UnitResult_parRef,UnitResult_schemDr,UnitResult_appSysDr,UnitResult_jxUnitDr,UnitResult_period,UnitResult_auditState) values(:currStratagemDr,:schemDr,:appSysDr,:jxUnitDr,:period,:auditState))

	.....i SQLCODE'=0 d
	......s rs=1

	i rs'=0 d
	.TRollBack
	.s flag="false"
	e  d
	.TCOMMIT
	
	q flag
}

/// Creator：李明忠
/// CreatDate：2010-8-11
/// Description: 获取起始季度
/// Table：
/// Input：currMonth-当前月份
/// Output：
/// Return：起始季度
/// Others：w ##class(dhc.pa.udata.uDistTarget).GetStartQuarter(4)
ClassMethod GetStartQuarter(currMonth) As %String
{
	n (currMonth)
	
	i $L(currMonth/3)=1 s startQuarter=currMonth/3
	e  d
	.i $E(currMonth/3,1)="." s startQuarter=1
	.e  s startQuarter=$E(currMonth/3,1)+1
	
	q startQuarter
}

/// Creator：李明忠
/// CreatDate：2010-8-12
/// Description: 获取起始半年期间
/// Table：
/// Input：currMonth-当前月份
/// Output：
/// Return：起始半年期间
/// Others：w ##class(dhc.pa.udata.uDistTarget).GetStartHalfYear(4)
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
/// CreatDate：2010-8-12
/// Description: 复制单元方案明细
/// Table：dhc_pa_data.UnitResultDetail
/// Input：currStratagemDr-当前战略Dr;schemDr-方案
/// Output：
/// Return：成功或失败标志
/// Others：w ##class(dhc.pa.udata.uDistTarget).CopySchemDetailData(1,"1||1")
ClassMethod CopySchemDetailData(currStratagemDr, schemDr) As %String
{
	n (currStratagemDr,schemDr)
	
	TSTART
	s rs=0,flag="true"
	
	//根据方案查询绩效单元考核方案
	s unitResultChildSub=0,count=0,jxUnitDr=0
	f  s jxUnitDr=$O(^DHCCJXPASTRATAGEM(0,"UnitResultSchem",currStratagemDr,schemDr,jxUnitDr)) q:jxUnitDr=""  d
	.f  s unitResultChildSub=$O(^DHCCJXPASTRATAGEM(0,"UnitResultSchem",currStratagemDr,schemDr,jxUnitDr,unitResultChildSub)) q:unitResultChildSub=""  d
	..s unitResultRowid=currStratagemDr_"||"_unitResultChildSub
	..;按照绩效单元方案逐个复制绩效单元方案明细
	..i $D(^DHCCJXPASTRATAGEM(currStratagemDr,"SchemDetail",$P(schemDr,"||",2))) d
	...s schemDetailChildSub=0
	...f  s schemDetailChildSub=$O(^DHCCJXPASTRATAGEM(currStratagemDr,"SchemDetail",$P(schemDr,"||",2),schemDetailChildSub)) q:schemDetailChildSub=""  d
	....s Curr=$G(^DHCCJXPASTRATAGEM(currStratagemDr,"SchemDetail",$P(schemDr,"||",2),schemDetailChildSub))
	....s schemDetailRowid=currStratagemDr_"||"_$P(schemDr,"||",2)_"||"_schemDetailChildSub
	....i Curr'="" d
	.....s count=count+1
	.....s Order=$P(Curr,"^",1)
	.....s KPIDr=$P(Curr,"^",2)
	.....s IsTarget=$P(Curr,"^",3)
	.....s Rate=$P(Curr,"^",4)
	.....s Parent=$P(Curr,"^",5)
	.....i $D(^DHCCJXPASTRATAGEM(0,"URDetailRecord",currStratagemDr,unitResultChildSub,schemDetailRowid,KPIDr)) d 
	......;w count_"^"_unitResultRowid_"^"_schemDetailRowid_"^"_KPIDr_"^"_Order_"^"_IsTarget_"^"_Rate_"^"_Parent,! 
	......&SQL(update dhc_pa_data.UnitResultDetail set UnitResultDetail_rate=:Rate,UnitResultDetail_parent=:Parent where UnitResultDetail_parRef=:unitResultRowid and UnitResultDetail_sDetailDr=:schemDetailRowid and UnitResultDetail_KPIDr=:KPIDr and UnitResultDetail_isTarget=:IsTarget ) 
	......i SQLCODE'=0 s rs=1 
	.....e  d 
	......&SQL(Insert into dhc_pa_data.UnitResultDetail(UnitResultDetail_parRef,UnitResultDetail_sDetailDr,UnitResultDetail_KPIDr,UnitResultDetail_order,UnitResultDetail_isTarget,UnitResultDetail_rate,UnitResultDetail_parent) values(:unitResultRowid,:schemDetailRowid,:KPIDr,:Order,:IsTarget,:Rate,:Parent)) 
	......i SQLCODE'=0 s rs=1
	
	i rs'=0 d
	.TRollBack
	.s flag="false"
	e  d
	.TCOMMIT
	
	q flag
}

/// Creator：李明忠
/// CreatDate：2010-8-12
/// Description: 复制绩效方案加减法评分标准
/// Table：dhc_pa_data.URDetailAdd
/// Input：SchemDr-方案Dr
/// Output：
/// Return：成功或失败标志
/// Others：w ##class(dhc.pa.udata.uDistTarget).CopySchemDetailAddData("1||1")
ClassMethod CopySchemDetailAddData(SchemDr) As %String
{
	n (SchemDr)
	;w $zt($p($h,",",2)),!
	q:SchemDr="" "true"
	s currStratagemDr=$P(SchemDr,"||",1)
	
	
	s rs=0,flag="true",count=0
	
	i $D(^DHCCJXPASTRATAGEM(currStratagemDr,"URDetail")) d
	.s unitResultChildSub=0
	.f  s unitResultChildSub=$O(^DHCCJXPASTRATAGEM(currStratagemDr,"URDetail",unitResultChildSub)) q:unitResultChildSub=""  d
	..s unitResultDetailChildSub=0
	..f  s unitResultDetailChildSub=$O(^DHCCJXPASTRATAGEM(currStratagemDr,"URDetail",unitResultChildSub,unitResultDetailChildSub)) q:unitResultDetailChildSub=""  d
	...s Curr=$G(^DHCCJXPASTRATAGEM(currStratagemDr,"URDetail",unitResultChildSub,unitResultDetailChildSub))
	...i Curr'="" d
	....s sDetailDr=$P(Curr,"^",1)
	....s schem=$P(sDetailDr,"||",1)_"||"_$P(sDetailDr,"||",2)
	....i schem=SchemDr d
	.....s isTarget = $P(Curr,"^",4)
	.....i isTarget'="1" d
	......s KPIDr = $P(Curr,"^",2) 
	......s KPIMethod = $P($G(^DHCCJXPAKPIINDEX1(KPIDr)),"^",13)  //考核方法
	......;w KPIMethod,!
	......i (KPIMethod="A")||(KPIMethod="D") d
	.......;w count_"^"_currStratagemDr_"||"_unitResultChildSub_"||"_unitResultDetailChildSub_"^"_KPIMethod,!
	.......s unitResultDetailRowid=currStratagemDr_"||"_unitResultChildSub_"||"_unitResultDetailChildSub
	.......s SchemDetailRowid=$P(Curr,"^",1)
	.......;根据方案明细Rowid查询SchemDetailAdd
	.......i SchemDetailRowid'="" d
	........s Length=$L(SchemDetailRowid,"||")
	........s schemDetailAddChildSub=0
	........f  s schemDetailAddChildSub=$O(^DHCCJXPASTRATAGEM($P(SchemDetailRowid,"||",1),"SchemDetailAdd",$P(SchemDetailRowid,"||",2),$P(SchemDetailRowid,"||",3),schemDetailAddChildSub)) q:schemDetailAddChildSub=""  d
	.........s AddCurr=$G(^DHCCJXPASTRATAGEM($P(SchemDetailRowid,"||",1),"SchemDetailAdd",$P(SchemDetailRowid,"||",2),$P(SchemDetailRowid,"||",3),schemDetailAddChildSub))
	.........;w SchemDetailRowid_"!!!"_AddCurr,!
	.........i AddCurr'="" d
	..........s count=count+1
	..........s Flag=$P(AddCurr,"^",1)
	..........s changeValue=$P(AddCurr,"^",2)
	..........s score=$P(AddCurr,"^",3)
	..........;w count_"^"_unitResultDetailRowid_"^"_Flag_"^"_changeValue_"^"_score,!
	..........TSTART
	..........i $D(^DHCCJXPASTRATAGEM(0,"URDA",currStratagemDr,unitResultChildSub,unitResultDetailChildSub,KPIMethod)) d
	...........&SQL(update dhc_pa_data.URDetailAdd set URDetailAdd_changeValue=:changeValue,URDetailAdd_score=:score where URDetailAdd_parRef=:unitResultDetailRowid and URDetailAdd_flag=:KPIMethod)
	...........i SQLCODE'=0 d
	............s rs=1
	..........e  d
	...........&SQL(Insert into dhc_pa_data.URDetailAdd(URDetailAdd_parRef,URDetailAdd_flag,URDetailAdd_changeValue,URDetailAdd_score) values(:unitResultDetailRowid,:Flag,:changeValue,:score))
	...........i SQLCODE'=0 d
	............s rs=1
	..........i rs'=0 TRollBack  d
    ...........;s ^TMPDHCCJXPA($J,0,"pa","uradd")=unitResultDetailRowid_"^"_KPIDr  
    ...........s flag="false"
	..........e  TCOMMIT

    /*
	i rs'=0 d
	.TRollBack
	.s flag="false"
	e  d
	.TCOMMIT
	*/
	;w $zt($p($h,",",2)),!
	q flag
}

/// Creator：李明忠
/// CreatDate：2010-8-12
/// Description: 复制绩效方案区间法评分标准
/// Table：dhc_pa_data.URDetailDist
/// Input：currStratagemDr-当前战略Dr
/// Output：
/// Return：成功或失败标志
/// Others：w ##class(dhc.pa.udata.uDistTarget).CopySchemDetailDistData("1||1")
ClassMethod CopySchemDetailDistData(SchemDr) As %String
{
	n (SchemDr)
	
	q:SchemDr="" "true"
	s currStratagemDr=$P(SchemDr,"||",1)
	
	
	s rs=0,flag="true",count=0
	
	i $D(^DHCCJXPASTRATAGEM(currStratagemDr,"URDetail")) d
	.s unitResultChildSub=0
	.f  s unitResultChildSub=$O(^DHCCJXPASTRATAGEM(currStratagemDr,"URDetail",unitResultChildSub)) q:unitResultChildSub=""  d
	..s unitResultDetailChildSub=0
	..f  s unitResultDetailChildSub=$O(^DHCCJXPASTRATAGEM(currStratagemDr,"URDetail",unitResultChildSub,unitResultDetailChildSub)) q:unitResultDetailChildSub=""  d
	...s Curr=$G(^DHCCJXPASTRATAGEM(currStratagemDr,"URDetail",unitResultChildSub,unitResultDetailChildSub))
	...i Curr'="" d
	....s sDetailDr=$P(Curr,"^",1)
	....s schem=$P(sDetailDr,"||",1)_"||"_$P(sDetailDr,"||",2)
	....i schem=SchemDr d
	.....s isTarget = $P(Curr,"^",4)
	.....i isTarget'=1 d
	......s KPIDr = $P(Curr,"^",2) 
	......s KPIMethod = $P($G(^DHCCJXPAKPIINDEX1(KPIDr)),"^",13)  //考核方法
	......i KPIMethod="I" d
	.......s unitResultDetailRowid=currStratagemDr_"||"_unitResultChildSub_"||"_unitResultDetailChildSub
	.......s SchemDetailRowid=$P(Curr,"^",1)
	.......;根据方案明细Rowid查询SchemDetailDist
	.......i SchemDetailRowid'="" d
	........s Length=$L(SchemDetailRowid,"||")
	........s schemDetailDistChildSub=0
	........f  s schemDetailDistChildSub=$O(^DHCCJXPASTRATAGEM($P(SchemDetailRowid,"||",1),"SchemDetailDist",$P(SchemDetailRowid,"||",2),$P(SchemDetailRowid,"||",3),schemDetailDistChildSub)) q:schemDetailDistChildSub=""  d
	.........s DistCurr=$G(^DHCCJXPASTRATAGEM($P(SchemDetailRowid,"||",1),"SchemDetailDist",$P(SchemDetailRowid,"||",2),$P(SchemDetailRowid,"||",3),schemDetailDistChildSub))
	.........i DistCurr'="" d
	..........;s count=count+1
	..........s Order=$P(DistCurr,"^",1)
	..........;w Order,!
	..........s ValueLower=$P(DistCurr,"^",2)
	..........s ValueUp=$P(DistCurr,"^",3)
	..........s ScoreLower=$P(DistCurr,"^",4)
	..........s ScoreUp=$P(DistCurr,"^",5)
	..........s RangeDr=$P(DistCurr,"^",6)
	..........;w unitResultDetailRowid_"^"_Order_"^"_ValueLower_"^"_ValueUp_"^"_ScoreLower_"^"_ScoreUp_"^"_RangeDr,!
	..........TSTART
	..........i $D(^DHCCJXPASTRATAGEM(0,"URDD",currStratagemDr,unitResultChildSub,unitResultDetailChildSub,RangeDr)) d
	...........&SQL(update dhc_pa_data.URDetailDist set URDetailDist_valueLower=:ValueLower,URDetailDist_valueUp=:ValueUp,URDetailDist_scoreLower=:ScoreLower,URDetailDist_scoreUp=:ScoreUp where URDetailDist_rangeDr=:RangeDr and URDetailDist_parRef=:unitResultDetailRowid)
	...........;w SQLCODE,!
	...........i SQLCODE'=0 d
	............s rs=1
	..........e  d
	...........;w unitResultDetailRowid_"^"_Order_"^"_ValueLower_"^"_ValueUp_"^"_ScoreLower_"^"_ScoreUp_"^"_RangeDr,!
	...........&SQL(Insert into dhc_pa_data.URDetailDist(URDetailDist_parRef,URDetailDist_order,URDetailDist_valueLower,URDetailDist_valueUp,URDetailDist_scoreLower,URDetailDist_scoreUp,URDetailDist_rangeDr) values(:unitResultDetailRowid,:Order,:ValueLower,:ValueUp,:ScoreLower,:ScoreUp,:RangeDr))
	...........i SQLCODE'=0 d
	............s rs=1
	..........i rs'=0  TRollBack  s flag="false"
	..........e  TCOMMIT
	
	q flag
}

/// Creator：李明忠
/// CreatDate：2010-8-12
/// Description: 获取表头信息
/// Table：dhc_pa_data.UnitResultDetail
/// Input：cycleDr-战略年度Dr,schemDr-方案Dr
/// Output：
/// Return：表头信息字符串
/// Others：w ##class(dhc.pa.udata.uDistTarget).GetGridTitle(2,"1||6")
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
	s rowid=1,title="科室Dr",name="jxUnitDr"
	s tmp=rowid_"^"_title_"^"_name
	d json.InsertRowData(tmp)
	s rowid=2,title="科室名称",name="jxUnitName"
	s tmp=rowid_"^"_title_"^"_name
	d json.InsertRowData(tmp)
	s rowid=3,title="指标Dr",name="KPIDr"
	s tmp=rowid_"^"_title_"^"_name
	d json.InsertRowData(tmp)
	s rowid=4,title="指标名称",name="KPIName"
	s tmp=rowid_"^"_title_"^"_name
	d json.InsertRowData(tmp)
	s rowid=5,title="分解方法Dr",name="DistDr"
	s tmp=rowid_"^"_title_"^"_name
	d json.InsertRowData(tmp)
	s rowid=6,title="分解方法名称",name="DistName"
	s tmp=rowid_"^"_title_"^"_name
	d json.InsertRowData(tmp)
	
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
/// CreatDate：2010-8-12
/// Description: 获取考核期间表头信息
/// Table：dhc_pa_data.UnitResultDetail
/// Input：json-数据格式类;rowid-计数器;cycleCode-考核年度code;currMonth-月份,frequency-期间类型
/// Output：
/// Return：表头考核期间信息字符串
/// Others：w ##class(dhc.pa.udata.uDistTarget).GetPeriodTitle(4,"M")
ClassMethod GetPeriodTitle(json, rowid, cycleCode, currMonth, frequency) As %String
{
	n (json,rowid,cycleCode,currMonth,frequency)
	
	i frequency="M" d //月份
	.;生成当前月份至12月数据数量Count
	.s Count=13-currMonth
	.f i=1:1:Count d
	..s rowid=rowid+1
	..s title=(currMonth+i-1)_"月"
	..s name="month"_(currMonth+i-1)
	..s tmp=rowid_"^"_title_"^"_name
	..d json.InsertRowData(tmp)
	
	i frequency="Q" d //季度
	.;获取当前季度至第四季度数据数量Count
	.s Count=..GetCount(currMonth)
	.;根据当前月份获取起始季度
	.s startQuarter=..GetStartQuarter(currMonth)
	.f i=1:1:Count d
	..s rowid=rowid+1
	..s title="第"_(startQuarter+i-1)_"季度"
	..s name="Quarter"_(startQuarter+i-1)
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
	..i (startHalfYear+i-1)=2 s title=cycleCode_"下半年"
	..e  s title=cycleCode_"上半年"
	..s name="HYear"_(startHalfYear+i-1)
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
/// CreatDate：2010-8-13
/// Description: 获取数据
/// Table：dhc_pa_data.UnitResultDetail
/// Input：cycleDr-战略年度Dr,schemDr-方案Dr;KPIDr-指标Dr;deptDr-科室Dr,start-记录起始位置;limit-页面记录限制条数
/// Output：
/// Return：数据字符串
/// Others：w ##class(dhc.pa.udata.uDistTarget).GetData(1,"1||1","7","5",0,30)
ClassMethod GetData(cycleDr, schemDr, kpiDr, deptDr, start, limit) As %String
{
	n (cycleDr,schemDr,kpiDr,deptDr,start,limit)
	
	k ^TEMPDHCCJXPA("dhc","pa","distMethod")
	k ^TEMPDHCCJXPA("dhc","pa","distTarget")
	
	q:cycleDr="" "NoDatas"
	q:schemDr="" "NoDatas"
	
	//获取年度代码
	s cycleCode=""
	i $D(^DHCCJXPACYCLE(cycleDr)) d
	.i $G(^DHCCJXPACYCLE(cycleDr))'="" s cycleCode=$P($G(^DHCCJXPACYCLE(cycleDr)),"^",1)
	q:cycleCode="" "NoDatas"
	//获取方案的报告频率、当前月份、应用系统号
	s currMonth="",frequency="",appSysDr=""
	s stratagemDr=$P(schemDr,"||",1)
	i $D(^DHCCJXPASTRATAGEM(stratagemDr)) d
	.i $G(^DHCCJXPASTRATAGEM(stratagemDr))'="" d
	..s currMonth=$P($G(^DHCCJXPASTRATAGEM(stratagemDr)),"^",8)
	..i currMonth'="" d
	...s frequency=$P($G(^DHCCJXPASTRATAGEM($P(schemDr,"||",1),"Schem",$P(schemDr,"||",2))),"^",5)
	...s appSysDr=$P(^DHCCJXPASTRATAGEM($P(schemDr,"||",1),"Schem",$P(schemDr,"||",2)),"^",4)
	
	q:currMonth="" "NoDatas1"
	q:frequency="" "NoDatas2"
	q:appSysDr="" "NoDatas3"
	
	//定义公共变量
	s jxUnitDr="",jxUnitName="",KPIName="",DistDr="",DistName="",tmp="",jxUnitDrStr="",kpiDrStr=""
	
	i deptDr="" d
	.;查询绩效单元
	.s jxUnitDrStr=..GetJXUnitOfSchem(schemDr)
	e  s jxUnitDrStr=deptDr
	
	i kpiDr="" d
	.;查询指标
	.s kpiDrStr=..GetKPIOfSchem(schemDr)
	e  s kpiDrStr=kpiDr
	
	q:jxUnitDrStr="" "NoDatas4"
	q:kpiDrStr="" "NoDatas5"
	
	//取长度
	s jxUnitLength=$L(jxUnitDrStr,"^")
	s kpiDrLength=$L(kpiDrStr,"^")
	
	//生成数据
	f i=1:1:jxUnitLength d
	.s jxUnitDr=$P(jxUnitDrStr,"^",i)
	.i jxUnitDr'="" d
	..i $D(^DHCCJXPAJXUNIT(jxUnitDr)) d
	...i $G(^DHCCJXPAJXUNIT(jxUnitDr))'=""
	....s jxUnitName=$P(^DHCCJXPAJXUNIT(jxUnitDr),"^",3)
	..f k=1:1:kpiDrLength d
	...s kpiDr=$P(kpiDrStr,"^",k)
	...i kpiDr'="" d
	....i $D(^DHCCJXPAKPIINDEX1(kpiDr)) d
	.....i $G(^DHCCJXPAKPIINDEX1(kpiDr))'=""
	......s KPIName=$P(^DHCCJXPAKPIINDEX1(kpiDr),"^",2)
	....;当绩效单元和指标都不为空时开始执行
	....d ..GetUnitResultDetailData(frequency,cycleCode,currMonth,jxUnitDr,stratagemDr,schemDr,appSysDr,kpiDr)
	
	//取出数据并返回
	s resultString= ..ViewData(schemDr,start,limit)
	k ^TEMPDHCCJXPA("dhc","pa","distMethod")
	k ^TEMPDHCCJXPA("dhc","pa","distTarget")
	q resultString
}

/// Creator：李明忠
/// CreatDate：2010-8-13
/// Description: 根据期间类型获取被生成的不同数据
/// Table：
/// Input：frequency-期间类型;deptDr-绩效单元Dr;stratagemDr-当前战略,schemDr-当前方案,appSysDr-应用系统号,cycleCode-年度代码,currMonth-当前月份,kpiDr-指标
/// Output：
/// Return：
/// Others：w ##class(dhc.pa.udata.uDistTarget).GetUnitResultDetailData(frequency, cycleCode, currMonth, deptDr, stratagemDr, schemDr, appSysDr, kpiDr)
ClassMethod GetUnitResultDetailData(frequency, cycleCode, currMonth, deptDr, stratagemDr, schemDr, appSysDr, kpiDr) As %String
{
	n (frequency,cycleCode,currMonth,deptDr,stratagemDr,schemDr,appSysDr,kpiDr)
	
	//按照月份查询数据
	i frequency="M" d 
	.;生成当前月份至12月数据
	.d ..GetMonthData(cycleCode,currMonth,deptDr,stratagemDr,schemDr,appSysDr,kpiDr)
	//按照季度查询数据
	i frequency="Q" d 
	.;生成当前季度至第四季度数据
	.d ..GetQuarterData(cycleCode,currMonth,deptDr,stratagemDr,schemDr,appSysDr,kpiDr)
	//按照半年查询数据
	i frequency="H" d 
	.;生成当前所属半年至下半年数据
	.d ..GetHalfYearData(cycleCode,currMonth,deptDr,stratagemDr,schemDr,appSysDr,kpiDr)
	//按照年查询数据
	i frequency="Y" d 
	.;生成年数据
	.d ..GetYearData(cycleCode,currMonth,deptDr,stratagemDr,schemDr,appSysDr,kpiDr)
}

/// Creator：李明忠
/// CreatDate：2010-8-13
/// Description: 生成月份数据
/// Table：
/// Input：deptDr-绩效单元Dr;stratagemDr-当前战略,schemDr-当前方案,appSysDr-应用系统号,cycleCode-年度代码,currMonth-当前月份,kpiDr-指标
/// Output：
/// Return：
/// Others：w ##class(dhc.pa.udata.uDistTarget).GetMonthData("2010",1,1,1,"1||2",2,21)
ClassMethod GetMonthData(cycleCode, currMonth, deptDr, stratagemDr, schemDr, appSysDr, kpiDr) As %String
{
	n (cycleCode,currMonth,deptDr,stratagemDr,schemDr,appSysDr,kpiDr)
	
	s order=0
	
	s Count=14-currMonth
	f i=1:1:Count d
	.s title=(currMonth+i-2)_"月"
	.s order=order+1
	.s name="month"_(currMonth+i-2)
	.s month=currMonth+i-2
	.i month<10 s period=cycleCode_"0"_month
	.e  s period=cycleCode_month
	.d ..ProductData(deptDr,stratagemDr,period,schemDr,appSysDr,order,title,name,kpiDr)
}

/// Creator：李明忠
/// CreatDate：2010-8-13
/// Description: 生成季度数据
/// Table：
/// Input：deptDr-绩效单元Dr;stratagemDr-当前战略,schemDr-当前方案,appSysDr-应用系统号,cycleCode-年度代码,currMonth-当前月份,kpiDr-指标
/// Output：
/// Return：
/// Others：w ##class(dhc.pa.udata.uDistTarget).GetQuarterData("2010",1,1,1,"1||3",2,21)
ClassMethod GetQuarterData(cycleCode, currMonth, deptDr, stratagemDr, schemDr, appSysDr, kpiDr) As %String
{
	n (cycleCode,currMonth,deptDr,stratagemDr,schemDr,appSysDr,kpiDr)
	
	s order=0
	
	s Count=..GetCount(currMonth)
	;根据当前月份获取起始季度
	s startQuarter=..GetStartQuarter(currMonth)
	
	f i=0:1:Count d
	.s order=order+1
	.s title="第"_(startQuarter+i-1)_"季度"
	.s name="Quarter"_(startQuarter+i-1)
	.s Quarter="0"_(startQuarter+i-1)
	.s period=cycleCode_Quarter
	.d ..ProductData(deptDr,stratagemDr,period,schemDr,appSysDr,order,title,name,kpiDr)
}

/// Creator：李明忠
/// CreatDate：2010-8-13
/// Description: 生成半年数据
/// Table：
/// Input：deptDr-绩效单元Dr;stratagemDr-当前战略,schemDr-当前方案,appSysDr-应用系统号,cycleCode-年度代码,currMonth-当前月份,kpiDr-指标
/// Output：
/// Return：
/// Others：w ##class(dhc.pa.udata.uDistTarget).GetHalfYearData(cycleCode, currMonth, deptDr, stratagemDr, schemDr, appSysDr, kpiDr)
ClassMethod GetHalfYearData(cycleCode, currMonth, deptDr, stratagemDr, schemDr, appSysDr, kpiDr) As %String
{
	n (cycleCode,currMonth,deptDr,stratagemDr,schemDr,appSysDr,kpiDr)
	
	s order=0
	
	i currMonth<7 s Count=2
	e  s Count=1
	;根据当前月份获取起始半年期间
	s startHalfYear=..GetStartHalfYear(currMonth)
	f i=0:1:Count d
	.s order=order+1
	.s HalfYear="0"_(startHalfYear+i-1)
	.i (startHalfYear+i-1)=2 s title=cycleCode_"下半年"
	.i (startHalfYear+i-1)=1 s title=cycleCode_"上半年"
	.s name="HYear"_(startHalfYear+i-1)
	.s period=cycleCode_HalfYear
	.d ..ProductData(deptDr,stratagemDr,period,schemDr,appSysDr,order,title,name,kpiDr)
}

/// Creator：李明忠
/// CreatDate：2010-8-13
/// Description: 生成年数据
/// Table：
/// Input：deptDr-绩效单元Dr;stratagemDr-当前战略,schemDr-当前方案,appSysDr-应用系统号,cycleCode-年度代码,currMonth-当前月份,kpiDr-指标
/// Output：
/// Return：
/// Others：w ##class(dhc.pa.udata.uDistTarget).GetYearData(cycleCode, currMonth, deptDr, stratagemDr, schemDr, appSysDr, kpiDr)
ClassMethod GetYearData(cycleCode, currMonth, deptDr, stratagemDr, schemDr, appSysDr, kpiDr) As %String
{
	n (cycleCode,currMonth,deptDr,stratagemDr,schemDr,appSysDr,kpiDr)
	
	s order=0
	
	s order=order+1
	s title=cycleCode_"年"
	s name="Year"
	s period=cycleCode_"00"
	d ..ProductData(deptDr,stratagemDr,period,schemDr,appSysDr,order,title,name,kpiDr)
}

/// Creator：李明忠
/// CreatDate：2010-11-18
/// Description: 获取方法
/// Table：dhc_pa_data.UnitResultDetail
/// Input：stratagemDr-当前战略;schemDr-方案DR;deptDr-绩效单元Dr;period-区间;kpiDr-KPI指标Dr
/// Output：
/// Return：方法
/// Others：w ##class(dhc.pa.udata.uDistTarget).GetWay(2,"2||2",13,20,"01")
ClassMethod GetWay(stratagemDr, schemDr, deptDr, kpiDr, period) As %String
{
	n (stratagemDr,schemDr,deptDr,kpiDr,period)
	
	s distMethodDr=""
	
	q:stratagemDr="" distMethodDr
	q:schemDr="" distMethodDr
	q:deptDr="" distMethodDr
	q:period="" distMethodDr
	q:kpiDr="" distMethodDr
	
	s urRowid=..GetUnitResultRowid(stratagemDr,schemDr,deptDr,period)
	
	s result = ##class(%Library.ResultSet).%New()
	
	s sqlStr = "select UnitResultDetail_distMethodDr from dhc_pa_data.UnitResultDetail where UnitResultDetail_parRef='"_urRowid_"' and UnitResultDetail_isTarget=2 and UnitResultDetail_childSub>0 and UnitResultDetail_KPIDr='"_kpiDr_"'"
	;w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()
	
	
	While(result.Next()){
		s distMethodDr = result.Data("UnitResultDetail_distMethodDr")
	}
	q distMethodDr
}

/// Creator：李明忠
/// CreatDate：2010-11-18
/// Description: 获取UnitResultRowid
/// Table：dhc_pa_data.UnitResult
/// Input：stratagemDr-当前战略;schemDr-方案DR;deptDr-绩效单元Dr;period-区间
/// Output：
/// Return：UnitResultRowid
/// Others：w ##class(dhc.pa.udata.uDistTarget).GetWay()
ClassMethod GetUnitResultRowid(stratagemDr, schemDr, deptDr, period) As %String
{
	n (stratagemDr,schemDr,deptDr,period)
	
	s rowid=""
	q:stratagemDr="" rowid
	q:schemDr="" rowid
	q:deptDr="" rowid
	q:period="" rowid
	
	s period=period_"00"
	
	s result = ##class(%Library.ResultSet).%New()
	
	s sqlStr = "select UnitResult_rowid from dhc_pa_data.UnitResult where UnitResult_parRef="_stratagemDr_" and UnitResult_childSub>0 and UnitResult_schemDr='"_schemDr_"' and UnitResult_jxUnitDr="_deptDr_" and UnitResult_period='"_period_"'"
	
	d result.Prepare(sqlStr)
	d result.Execute()
	
	
	While(result.Next()){
		s rowid = result.Data("UnitResult_rowid")
	}
	q rowid
}

/// Creator：李明忠
/// CreatDate：2010-8-13
/// Description: 根据传入的参数生成临时Global
/// Table：
/// Input：deptDr-绩效单元Dr;stratagemDr-当前战略,period-期间,schemDr-当前方案,appSysDr-应用系统号,order-顺序号,title-表头,name-表头Index,kpiDr-指标
/// Output：
/// Return：
/// Others：w ##class(dhc.pa.udata.uDistTarget).ProductData(1,1,"201000","1||2",2,title,name,kpiDr)
ClassMethod ProductData(deptDr, stratagemDr, period, schemDr, appSysDr, order, title, name, kpiDr) As %String
{
	n (deptDr,stratagemDr,period,schemDr,appSysDr,order,title,name,kpiDr)
		
	q:deptDr=""
	q:stratagemDr=""
	q:period=""
	q:schemDr=""
	q:appSysDr=""
	q:order=""
	q:title=""
	q:name=""
	q:kpiDr=""
	
	i $D(^TEMPDHCCJXPA("dhc","pa","distMethod","distTarget",stratagemDr,schemDr,deptDr,kpiDr)) d
	e  d
	.s distMethodDr=..GetWay(stratagemDr,schemDr,deptDr,kpiDr,$E(period,0,4))
	.s ^TEMPDHCCJXPA("dhc","pa","distMethod","distTarget",stratagemDr,schemDr,deptDr,kpiDr)=distMethodDr
	
	s unitResultChildSub=0
	f  s unitResultChildSub=$O(^DHCCJXPASTRATAGEM(0,"PUSA",stratagemDr,period,deptDr,schemDr,appSysDr,unitResultChildSub)) q:unitResultChildSub=""  d
	.i unitResultChildSub'="" d
	..s URDetailChildSub=0
	..f  s URDetailChildSub=$O(^DHCCJXPASTRATAGEM(stratagemDr,"URDetail",unitResultChildSub,URDetailChildSub)) q:URDetailChildSub=""  d
	...s Curr=$G(^DHCCJXPASTRATAGEM(stratagemDr,"URDetail",unitResultChildSub,URDetailChildSub))
	...i Curr'="" d
	....;取区分标志isTarget
	....s isTarget=$P(Curr,"^",4)
	....i isTarget=2 d
	.....;取KPI指标
	.....s KPIID=$P(Curr,"^",2)
	.....i KPIID=kpiDr d
	......;取分配系数
	......s distRate=$P(Curr,"^",14)
	......i $D(^TEMPDHCCJXPA("dhc","pa","distTarget",stratagemDr,order,title,name,deptDr,kpiDr)) d
	.......s ^TEMPDHCCJXPA("dhc","pa","distTarget",stratagemDr,order,title,name,deptDr,kpiDr)=^TEMPDHCCJXPA("dhc","pa","distTarget",stratagemDr,order,title,name,deptDr,kpiDr)+distRate
	......e  d
	.......s ^TEMPDHCCJXPA("dhc","pa","distTarget",stratagemDr,order,title,name,deptDr,kpiDr)=distRate
}

/// Creator：李明忠
/// CreatDate：2010-8-13
/// Description: 根据传入的参数遍历临时Global
/// Table：
/// Input：schemDr-方案rowid;start-记录起始位置;limit-页面记录限制条数
/// Output：
/// Return：返回结果字符串
/// Others：w ##class(dhc.pa.udata.uDistTarget).ViewData("1||1",0,5)
ClassMethod ViewData(schemDr, start, limit) As %String
{
	n (schemDr,start,limit)
	
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	s count=0
	s jsonTitle=""
	s end=start+limit-1
	
	;^TEMPDHCCJXPA("dhc","pa","distMethod","distTarget",stratagemDr,schemDr,deptDr,kpiDr)
	i $D(^TEMPDHCCJXPA("dhc","pa","distMethod","distTarget")) d
	.s stratagemDr=0
	.f  s stratagemDr=$O(^TEMPDHCCJXPA("dhc","pa","distMethod","distTarget",stratagemDr)) q:stratagemDr=""  d
	..s jxUnitDr=0,jxUnitName=""
	..i $D(^TEMPDHCCJXPA("dhc","pa","distMethod","distTarget",stratagemDr,schemDr)) d
	...f  s jxUnitDr=$O(^TEMPDHCCJXPA("dhc","pa","distMethod","distTarget",stratagemDr,schemDr,jxUnitDr)) q:jxUnitDr=""  d
	....i $D(^DHCCJXPAJXUNIT(jxUnitDr)) d
	.....i $G(^DHCCJXPAJXUNIT(jxUnitDr))'="" d
	......s jxUnitName=$P(^DHCCJXPAJXUNIT(jxUnitDr),"^",3)
	....s kpiDr=0,KPIName=""
	....f  s kpiDr=$O(^TEMPDHCCJXPA("dhc","pa","distMethod","distTarget",stratagemDr,schemDr,jxUnitDr,kpiDr)) q:kpiDr=""  d 
	.....i $D(^DHCCJXPAKPIINDEX1(kpiDr)) d
	......i $G(^DHCCJXPAKPIINDEX1(kpiDr))'="" d
	.......s KPIName=$P(^DHCCJXPAKPIINDEX1(kpiDr),"^",2)
	.....s DistDr=^TEMPDHCCJXPA("dhc","pa","distMethod","distTarget",stratagemDr,schemDr,jxUnitDr,kpiDr)
	.....i DistDr="" s DistName=""
	.....i DistDr=1 s DistName="全面贯彻"
	.....i DistDr=2 s DistName="比例贯彻"
	.....i DistDr=3 s DistName="比例系数"
	.....i DistDr=4 s DistName="不分解"
	.....;已经取得绩效单元和指标
	.....s tmp=jxUnitDr_"^"_jxUnitName_"^"_kpiDr_"^"_KPIName_"^"_DistDr_"^"_DistName
	.....;^TEMPDHCCJXPA("dhc","pa","distTarget",stratagemDr,order,title,name,deptDr,kpiDr)
	.....s titleStr="jxUnitDr^jxUnitName^KPIDr^KPIName^DistDr^DistName"
	.....s order=0
	.....f  s order=$O(^TEMPDHCCJXPA("dhc","pa","distTarget",stratagemDr,order)) q:order=""  d
	......s title=""
	......f  s title=$O(^TEMPDHCCJXPA("dhc","pa","distTarget",stratagemDr,order,title)) q:title=""  d
	.......s name="" 
	.......f  s name=$O(^TEMPDHCCJXPA("dhc","pa","distTarget",stratagemDr,order,title,name)) q:name=""  d
	........i $D(^TEMPDHCCJXPA("dhc","pa","distTarget",stratagemDr,order,title,name,jxUnitDr,kpiDr)) d
	.........s distRate=^TEMPDHCCJXPA("dhc","pa","distTarget",stratagemDr,order,title,name,jxUnitDr,kpiDr)
	.........i distRate="" d
	..........s tmp=tmp_"^"_distRate
	.........e  d
	..........s tmp=tmp_"^"_$fn(distRate,"",2)
	.........s titleStr=titleStr_"^"_name
	.....;w titleStr,!
	.....s jsonTitle=titleStr
	.....;w tmp,!
	.....i (count>=start)&(count<=end) d
	......d json.InsertRowData(tmp)
	.....s count=count+1
	
	s resultString = ""
	s resultString = json.getJsonData(jsonTitle,count)
	k json
	q resultString
}

/// Creator：李明忠
/// CreatDate：2010-8-16
/// Description: 设置分解方法
/// Table：
/// Input：infoStr-方法信息字符串
/// Output：
/// Return：返回rs
/// Others：w ##class(dhc.pa.udata.uDistTarget).SetDistMethod()
ClassMethod SetDistMethod(infoStr) As %String
{
	n (infoStr)
	
	q:infoStr="" "NoDatas"
	
	s Length=$L(infoStr,"!")
	
	TSTART
	s rs=0
	s flag="true"
	
	f i=1:1:Length d
	.s info=$P(infoStr,"!",i)
	.i info'="" d
	..s schemDr=$P(info,"^",4)
	..s frequency=$P($G(^DHCCJXPASTRATAGEM($P(schemDr,"||",1),"Schem",$P(schemDr,"||",2))),"^",5)
	..s appSysDr=$P(^DHCCJXPASTRATAGEM($P(schemDr,"||",1),"Schem",$P(schemDr,"||",2)),"^",4)
	..s stratagemDr=$P(schemDr,"||",1)
	..i $D(^DHCCJXPASTRATAGEM(stratagemDr)) d
	...i $G(^DHCCJXPASTRATAGEM(stratagemDr))'="" d
	....s cycleDr=""
	....s cycleDr=$P($G(^DHCCJXPASTRATAGEM(stratagemDr)),"^",2)
	....q:cycleDr=""
	....s cycleCode=""
	....i $D(^DHCCJXPACYCLE(cycleDr)) d
	.....i $G(^DHCCJXPACYCLE(cycleDr))'="" d
	......s cycleCode=$P($G(^DHCCJXPACYCLE(cycleDr)),"^",1)
	....q:cycleCode=""
	....s period=cycleCode_"00"
	....s deptDr=$P(info,"^",1)
	....s distMethodDr=$P(info,"^",2)
	....s kpiDr=$P(info,"^",3)
	....i ((deptDr'="")&&(distMethodDr'="")&&(kpiDr'="")) d
	.....s rs=..SetDistMethodOfUnit(distMethodDr, deptDr, schemDr, kpiDr, frequency, stratagemDr, period, appSysDr)
	.....i rs'=0 d
	......s flag="false"
	
	i flag'="true" d
	.TRollBack
	e  d
	.TCOMMIT
	
	q rs
}

/// Creator：李明忠
/// CreatDate：2010-8-13
/// Description: 设置分解方法
/// Table：dhc_pa_data.UnitResultDetail
/// Input：distMethodDr-方法Dr,deptDr-绩效单元Dr,schemDr-当前方案,kpiDr-指标,frequency-报告频率,stratagemDr-当前战略,period-周期,appSysDr-应用系统号
/// Output：
/// Return：返回rs
/// Others：w ##class(dhc.pa.udata.uDistTarget).SetDistMethodOfUnit(1,1,"1||6",21)
ClassMethod SetDistMethodOfUnit(distMethodDr, deptDr, schemDr, kpiDr, frequency, stratagemDr, period, appSysDr) As %String
{
	n (distMethodDr,deptDr,schemDr,kpiDr,frequency,stratagemDr,period,appSysDr)
	
	q:deptDr="" "NoDatas"
	q:schemDr="" "NoSchem"
	q:kpiDr="" "NoKPIDr"
	q:distMethodDr="" "NoMethod"
	q:stratagemDr="" "NoDatas"
	q:period="" "NoDatas"
	
	s rs=0
	
	//查找单位考核主表和明细记录
	s unitResultChildSub=0
	s unitResultChildSub=$O(^DHCCJXPASTRATAGEM(0,"PUSA",stratagemDr,period,deptDr,schemDr,appSysDr,unitResultChildSub))
	i unitResultChildSub'="" d
	.s URDetailChildSub=0
	.f  s URDetailChildSub=$O(^DHCCJXPASTRATAGEM(stratagemDr,"URDetail",unitResultChildSub,URDetailChildSub)) q:URDetailChildSub=""  d
	..s URDetailRowid=stratagemDr_"||"_unitResultChildSub_"||"_URDetailChildSub
	..s Curr=$G(^DHCCJXPASTRATAGEM(stratagemDr,"URDetail",unitResultChildSub,URDetailChildSub))
	..i Curr'="" d
	...;取区分标志isTarget
	...s isTarget=$P(Curr,"^",4)
	...i isTarget=2 d
	....;取KPI指标
	....s KPIID=$P(Curr,"^",2)
	....i KPIID=kpiDr d
	.....&SQL(Update dhc_pa_data.UnitResultDetail set UnitResultDetail_distMethodDr=:distMethodDr where UnitResultDetail_rowid=:URDetailRowid)
	.....i SQLCODE'=0 d
	......s rs=1
	
	q rs
}

/// Creator：李明忠
/// CreatDate：2010-8-17
/// Description: 设置比例系数
/// Table：
/// Input：jxUnitDrStr-绩效单元Dr字符串;num-比例系数,schemDr-当前方案,kpiDr-指标
/// Output：
/// Return：返回rs
/// Others：w ##class(dhc.pa.udata.uDistTarget).SetRates("1!10","1||6",21,0.2)
ClassMethod SetRates(jxUnitDrStr, schemDr, kpiDr, num) As %String
{
	n (jxUnitDrStr,schemDr,kpiDr,num)
	
	q:jxUnitDrStr="" "NoData"
	q:schemDr="" "NoYear"
	q:kpiDr="" "NoKPIDr"
	q:num="" "NoNum"
	
	s Length=$L(jxUnitDrStr,"!")	
	
	//获取方案的报告频率
	s frequency=$P($G(^DHCCJXPASTRATAGEM($P(schemDr,"||",1),"Schem",$P(schemDr,"||",2))),"^",5)
	s appSysDr=$P(^DHCCJXPASTRATAGEM($P(schemDr,"||",1),"Schem",$P(schemDr,"||",2)),"^",4)
	
	s currMonth=""
	s stratagemDr=$P(schemDr,"||",1)
	q:stratagemDr="" "NoData"
	
	i $D(^DHCCJXPASTRATAGEM(stratagemDr)) d
	.i $G(^DHCCJXPASTRATAGEM(stratagemDr))'="" d
	..s cycleDr=$P($G(^DHCCJXPASTRATAGEM(stratagemDr)),"^",2)
	..s currMonth=$P($G(^DHCCJXPASTRATAGEM(stratagemDr)),"^",8) //获取当前月份
	
	q:currMonth="" "ErrMonth"
	q:cycleDr="" "ErrCycle"
	//获取年度代码
	s cycleCode=""
	i $D(^DHCCJXPACYCLE(cycleDr)) d
	.i $G(^DHCCJXPACYCLE(cycleDr))'="" s cycleCode=$P($G(^DHCCJXPACYCLE(cycleDr)),"^",1)
	q:cycleCode="" "ErrCycle"
	
	TSTART
	s rs=0
	
	f k=1:1:Length q:rs'=0  d
	.s deptDr=$P(jxUnitDrStr,"!",k)
	.i deptDr'="" d
	..s rs=..SetRateOfUnit(currMonth, cycleCode, num, deptDr, schemDr, kpiDr, frequency, stratagemDr, appSysDr)
	
	i rs'=0 d
	.TRollBack
	e  d
	.TCOMMIT
	q rs
}

/// Creator：李明忠
/// CreatDate：2010-8-17
/// Description: 设置绩效单元比例系数
/// Table：
/// Input：currMonth-当前月份,cycleCode-考核周期,num-比例系数,deptDr-绩效单元Dr,schemDr-当前方案,kpiDr-指标,frequency-报告频率,stratagemDr-当前战略,appSysDr-应用系统号
/// Output：
/// Return：返回rs
/// Others：w ##class(dhc.pa.udata.uDistTarget).SetRateOfUnit(1,1,"1||6",21)
ClassMethod SetRateOfUnit(currMonth, cycleCode, num, deptDr, schemDr, kpiDr, frequency, stratagemDr, appSysDr) As %String
{
	n (currMonth,cycleCode,num,deptDr,schemDr,kpiDr,frequency,stratagemDr,appSysDr)

	q:appSysDr="" "NoData"
	q:frequency="" "NoData"
	
	s rs=0
	
	//根据区间类型决定考核周期
	i frequency="M" d //月
	.s Count=13-currMonth
	.f i=1:1:Count q:rs'=0  d
	..s month=currMonth+i-1
	..i month<10 s period=cycleCode_"0"_month
	..e  s period=cycleCode_month
	..s rs=..SetRate(num,stratagemDr,period,deptDr,schemDr,kpiDr,appSysDr)
	
	i frequency="Q" d //季度
	.s Count=..GetCount(currMonth)
	.;根据当前月份获取起始季度
	.s startQuarter=..GetStartQuarter(currMonth)
	.f i=1:1:Count q:rs'=0  d
	..s order=order+1
	..s Quarter="0"_(startQuarter+i-1)
	..s period=cycleCode_Quarter
	..s rs=..SetRate(num,stratagemDr,period,deptDr,schemDr,kpiDr,appSysDr)
	
	i frequency="H" d //半年
	.i currMonth<7 s Count=2
	.e  s Count=1
	.;根据当前月份获取起始半年期间
	.s startHalfYear=..GetStartHalfYear(currMonth)
	.f i=1:1:Count q:rs'=0  d
	..s order=order+1
	..s HalfYear="0"_(startHalfYear+i-1)
	..s period=cycleCode_HalfYear
	..s rs=..SetRate(num,stratagemDr,period,deptDr,schemDr,kpiDr,appSysDr)
	
	i frequency="Y" d //年
	.s period=cycleCode_"00"
	.s rs=..SetRate(num,stratagemDr,period,deptDr,schemDr,kpiDr,appSysDr)
	
	q rs
}

/// Creator：李明忠
/// CreatDate：2010-8-17
/// Description: 设置比例系数
/// Table：dhc_pa_data.UnitResultDetail
/// Input：period-考核周期,num-比例系数,deptDr-绩效单元Dr,schemDr-当前方案,kpiDr-指标,stratagemDr-当前战略,appSysDr-应用系统号
/// Output：
/// Return：返回rs
/// Others：w ##class(dhc.pa.udata.uDistTarget).SetRate(1,1,"1||6",21)
ClassMethod SetRate(num, stratagemDr, period, deptDr, schemDr, kpiDr, appSysDr) As %String
{
	n (num,stratagemDr,period,deptDr,schemDr,kpiDr,appSysDr)
	
	s rs=0
	
	//查找单位考核主表和明细记录
	s unitResultChildSub=0
	s unitResultChildSub=$O(^DHCCJXPASTRATAGEM(0,"PUSA",stratagemDr,period,deptDr,schemDr,appSysDr,unitResultChildSub))
	i unitResultChildSub'="" d
	.s URDetailChildSub=0
	.f  s URDetailChildSub=$O(^DHCCJXPASTRATAGEM(stratagemDr,"URDetail",unitResultChildSub,URDetailChildSub)) q:URDetailChildSub=""  d
	..s URDetailRowid=stratagemDr_"||"_unitResultChildSub_"||"_URDetailChildSub
	..s Curr=$G(^DHCCJXPASTRATAGEM(stratagemDr,"URDetail",unitResultChildSub,URDetailChildSub))
	..i Curr'="" d
	...;取区分标志isTarget
	...s isTarget=$P(Curr,"^",4)
	...i isTarget=2 d
	....;取KPI指标
	....s KPIID=$P(Curr,"^",2)
	....i KPIID=kpiDr d
	.....&SQL(Update dhc_pa_data.UnitResultDetail set UnitResultDetail_distRate=:num where UnitResultDetail_rowid=:URDetailRowid)
	.....i SQLCODE'=0 d
	......s rs=1
	
	q rs
}

/// Creator：李明忠
/// CreatDate：2010-8-17
/// Description: 更新比例系数
/// Table：dhc_pa_data.UnitResultDetail
/// Input：dataInfo-即将被修改的数据信息
/// Output：
/// Return：返回rs
/// Others：w ##class(dhc.pa.udata.uDistTarget).Update("5^1||1^7^12.00^12.00^12.00^12.00^12.00^12.00^12.00^12.00^12.00^12.00^12.00^12.00^2%M")
ClassMethod Update(dataInfo) As %String
{
	n (dataInfo)
	
	q:dataInfo="" "NoData"
	;w dataInfo,!
	s frequery=$P(dataInfo,"%",2)
	s data=$P(dataInfo,"%",1)
	s dataLength=$L(data,"!")
	
	TSTART
	s rs=0
	s flag="true"
	
	f k=1:1:dataLength d
	.s dataSub=$P(data,"!",k)
	.;w frequery_"!"_dataSub,!
	.s schemDr=$P(dataSub,"^",2)
	.s appSysDr=$P(^DHCCJXPASTRATAGEM($P(schemDr,"||",1),"Schem",$P(schemDr,"||",2)),"^",4)
	.s stratagemDr=$P(schemDr,"||",1)
	.q:stratagemDr=""
	.s cycleDr=""
	.i $D(^DHCCJXPASTRATAGEM(stratagemDr)) d
	..i $G(^DHCCJXPASTRATAGEM(stratagemDr))'="" d
	...s cycleDr=$P($G(^DHCCJXPASTRATAGEM(stratagemDr)),"^",2)
	.q:cycleDr=""
	.s cycleCode=""
	.i $D(^DHCCJXPACYCLE(cycleDr)) d
	..i $G(^DHCCJXPACYCLE(cycleDr))'="" d
	...s cycleCode=$P($G(^DHCCJXPACYCLE(cycleDr)),"^",1)
	.q:cycleCode=""
	.s jxUnitDr=$P(dataSub,"^",1)
	.i frequery="M" d //月数据修改
	..s kpiDr=$P(dataSub,"^",3)
	..i kpiDr'="" d
	...f i=4:1:($L(dataSub,"^")-1) d
	....s num=$P(dataSub,"^",i)
	....s month=i-3
	....i month<10 s month="0"_month
	....s period=cycleCode_month
	....;w appSysDr,!
	....s rs=..SetRate(num,stratagemDr,period,jxUnitDr,schemDr,kpiDr,appSysDr)
	....;w i_"^"_222_"^"_rs,!
	....i rs'=0 d
	.....s flag="false"
	...s DistDr=$P(dataSub,"^",$L(dataSub,"^"))
	...i DistDr'="" d
	....s newPeriod=cycleCode_"00"
	....s rs=..SetDistMethodOfUnit(DistDr,jxUnitDr,schemDr,kpiDr,frequery,stratagemDr,newPeriod,appSysDr)
	....;w i_"^"_333_"^"_rs,!
	....i rs'=0 d
	.....s flag="false" 
	.i frequery="Q" d //季度数据修改
	..s kpiDr=$P(dataSub,"^",3)
	..i kpiDr'="" d
	...f i=4:1:($L(dataSub,"^")-1) d
	....s num=$P(dataSub,"^",i)
	....s Quarter=i-3
	....s period=cycleCode_"0"_Quarter
	....;w jxUnitDr_"^"_kpiDr_"^"_period_"^"_num,!
	....s rs=..SetRate(num,stratagemDr,period,jxUnitDr,schemDr,kpiDr,appSysDr)
	....i rs'=0 d
	.....s flag="false"
	...s DistDr=$P(dataSub,"^",$L(dataSub,"^"))
	...i DistDr'="" d
	....s newPeriod=cycleCode_"00"
	....s rs=..SetDistMethodOfUnit(DistDr,jxUnitDr,schemDr,kpiDr,frequery,stratagemDr,newPeriod,appSysDr)
	....i rs'=0 d
	.....s flag="false"
	.i frequery="H" d //半年数据修改
	..s kpiDr=$P(dataSub,"^",3)
	..i kpiDr'="" d
	...f i=4:1:($L(dataSub,"^")-1) d
	....s num=$P(dataSub,"^",i)
	....s HYear=i-3
	....s period=cycleCode_"0"_HYear
	....;w jxUnitDr_"^"_kpiDr_"^"_period_"^"_num,!
	....s rs=..SetRate(num,stratagemDr,period,jxUnitDr,schemDr,kpiDr,appSysDr)
	....i rs'=0 d
	.....s flag="false"
	...s DistDr=$P(dataSub,"^",$L(dataSub,"^"))
	...i DistDr'="" d
	....s newPeriod=cycleCode_"00"
	....s rs=..SetDistMethodOfUnit(DistDr,jxUnitDr,schemDr,kpiDr,frequery,stratagemDr,newPeriod,appSysDr)
	....i rs'=0 d
	.....s flag="false"
	.i frequery="Y" d //年度数据修改
	..s kpiDr=$P(dataSub,"^",3)
	..i kpiDr'="" d
	...s num=$P(dataSub,"^",4)
	...s period=cycleCode_"00"
	...;w jxUnitDr_"^"_kpiDr_"^"_period_"^"_num,!
	...s rs=..SetRate(num,stratagemDr,period,jxUnitDr,schemDr,kpiDr,appSysDr)
	...i rs'=0 d
	....s flag="false"
	...s DistDr=$P(dataSub,"^",5)
	...i DistDr'="" d
	....s newPeriod=period
	....s rs=..SetDistMethodOfUnit(DistDr,jxUnitDr,schemDr,kpiDr,frequery,stratagemDr,newPeriod,appSysDr)
	....i rs'=0 d
	.....s flag="false"
	
	i flag'="true" d
	.TRollBack
	e  d
	.TCOMMIT
	
	q rs
}

/// Creator: 李明忠
/// CreatDate: 2010-12-17
/// Description: 根据方案rowid查询符合条件的记录
/// Table: dhc_pa_data.Schem
/// Input:schemDr-方案rowid,active-有效标志;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.pa.udata.uDistTarget).GetSchemOfRowid("Y","1||1")
ClassMethod GetSchemOfRowid(active, schemDr) As %String
{
		n (active,schemDr)
		
		s sqlStr="SELECT Schem_rowid,Schem_parRef,Schem_code,Schem_name,Schem_shortcut,Schem_appSysDr,Schem_frequency,Schem_KPIDr,Schem_desc,Schem_active,Schem_level FROM dhc_pa_data.Schem WHERE Schem_childSub>0 and Schem_rowid='"_schemDr_"' and Schem_active='"_active_"'"
		
		s result=##class(%Library.ResultSet).%New()
		
		d result.Prepare(sqlStr)
		d result.Execute()
		
		s count=1
		s resultString=""
		
		s json=##class(dhc.pa.comm.JsonObj).%New()
		s jsonTitle="rowid^parRef^code^name^shortcut^appSysDr^frequency^KPIDr^KPIName^desc^level^appSys^quency^shortCutFreQuency"
		
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
			s shortCutFreQuency=shortcut_"!"_frequency
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
			...s KPIName = $P($G(^DHCCJXPAKPIINDEX1(KPIDr)),"^",2)
			s desc=result.Data("Schem_desc")
			s level=result.Data("Schem_level")
			
			s tmp=rowid_"^"_parRef_"^"_code_"^"_name_"^"_shortcut_"^"_appSysDr_"^"_frequency_"^"_KPIDr_"^"_KPIName_"^"_desc_"^"_level_"^"_appSys_"^"_quency_"^"_shortCutFreQuency
		
			d json.InsertRowData(tmp)
		}
	
		d result.Close()
		s resultString = json.getJsonData(jsonTitle,count)
	 	k json
		q resultString
}

/// Creator：李明忠
/// CreatDate：2010-12-17
/// Description: 获取绩效单位
/// Table：dhc_pa_data.jxUnit
/// Input：deptDr-绩效单位ID
/// Output：
/// Return：有效绩效单位字符串
/// Others：w ##class(dhc.pa.udata.uDistTarget).GetDept2(5)
ClassMethod GetDept2(deptDr) As %String
{
	n (deptDr)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select JXUnit_rowid,JXUnit_name,JXUnit_shortcut from dhc_pa_data.jxUnit where JXUnit_rowid="_deptDr
	
	d result.Prepare(sqlStr)
	d result.Execute()

	s count = 1
	s resultString = ""
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	While(result.Next()){
		s jxUnitDr = result.Data("JXUnit_rowid")
		s jxUnitName = result.Data("JXUnit_name")
		s shortCut = result.Data("JXUnit_shortcut")
		s tmp=jxUnitDr_"^"_jxUnitName_"^"_shortCut
		d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("jxUnitDr^jxUnitName^shortCut",count)
 	k json
	q resultString
}

/// Creator：李明忠
/// CreatDate：2010-12-17
/// Description: 获取指标
/// Table：dhc_pa_data.KPIIndex1
/// Input：kpiDr-指标ID
/// Output：
/// Return：有效指标字符串
/// Others：w ##class(dhc.pa.udata.uDistTarget).GetKPI2(34)
ClassMethod GetKPI2(kpiDr) As %String
{
	n (kpiDr)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select KPIIndex1_rowid,KPIIndex1_name from dhc_pa_data.KPIIndex1 where KPIIndex1_rowid="_kpiDr
	
	d result.Prepare(sqlStr)
	d result.Execute()

	s count = 1
	s resultString = ""
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("KPIIndex1_rowid")
		s name = result.Data("KPIIndex1_name")
		s tmp=rowid_"^"_name
		d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("rowid^name",count)
 	k json
	q resultString
}

/// Creator：李明忠
/// CreatDate：2011-3-3
/// Description: 清理初始化造成的冗余数据
/// Table：dhc_pa_data.UnitResult,dhc_pa_data.UnitResultDetail,dhc_pa_data.URDetailAdd,dhc_pa_data.URDetailDist
/// Input：schemDr-绩效方案ID
/// Output：
/// Return：返回成功与否的标志
/// Others：w ##class(dhc.pa.udata.uDistTarget).Clean(1,"1||5")
ClassMethod Clean(cycleDr, schemDr) As %String
{
	n (cycleDr,schemDr)
	
	s jxUnitList=##class(%Library.ListOfDataTypes).%New() //定义集合List
	s newUnitList=##class(%Library.ListOfDataTypes).%New() //定义集合List
	s newRowidList=##class(%Library.ListOfDataTypes).%New() //定义集合List
	
	s jxUnitStr=..GetJXUnitOfSchem(schemDr) //获取该方案下的所有科室
	s jxUnitLen=$L(jxUnitStr,"^")
	f k=1:1:jxUnitLen d
	.d jxUnitList.Insert($P(jxUnitStr,"^",k))
	
	//从UnitResult获取科室、方案、ID记录
	//过滤科室
	s urUnitStr=..GetUnitOfURRecordOfSchem(schemDr)
	s urUnitLen=$L(urUnitStr,"^")
	f j=1:1:urUnitLen d
	.i jxUnitList.Find($P(urUnitStr,"^",j),0)="" d
	..d newUnitList.Insert($P(urUnitStr,"^",j))
	
	//从获取的所有记录过滤UnitResult表记录的rowid
	s allRecord=..GetURRecordOfSchem(schemDr)
	s Len=$L(allRecord,"!")
	f n=1:1:Len d
	.s newStr=$P(allRecord,"!",n)
	.s unitDr=$P(newStr,"^",3)
	.i newUnitList.Find(unitDr,0)'="" d
	..d newRowidList.Insert($P(newStr,"^",1)) //要被删除的UnitResult表记录的rowid集合
	
	//要删除它们必须先删除它们的子表和孙子表记录
	s urdList=##class(%Library.ListOfDataTypes).%New() //定义集合List
	s count=newRowidList.Count()
	f m=1:1:count d
	.s urRowid=newRowidList.GetAt(m)
	.s urdList=..GetURDRecord(urdList,urRowid)
	//加分法、区间法
	s urdaddList=##class(%Library.ListOfDataTypes).%New() //定义集合List
	s urddistList=##class(%Library.ListOfDataTypes).%New() //定义集合List
	s count2=urdList.Count()
	f h=1:1:count2 d
	.s urdRowid=urdList.GetAt(h)
	.s urdaddList=..GetURDAddRecord(urdaddList,urdRowid)
	.s urddistList=..GetURDDistRecord(urddistList,urdRowid)
	
	//首先删除加分法rowid
	f t=1:1:urdaddList.Count() d
	.s rowid=urdaddList.GetAt(t)
	.&SQL(delete from dhc_pa_data.URDetailAdd where URdetailAdd_rowid=:rowid)
	
	//删除区间法rowid
	f t2=1:1:urddistList.Count() d
	.s rowid=urddistList.GetAt(t2)
	.&SQL(delete from dhc_pa_data.URDetailDist where URdetailDist_rowid=:rowid)
	
	//删除单元绩效明细表
	f t3=1:1:urdList.Count() d
	.s rowid=urdList.GetAt(t3)
	.&SQL(delete from dhc_pa_data.UnitResultDetail where UnitResultDetail_rowid=:rowid)
	
	//删除单元绩效表
	f t4=1:1:newRowidList.Count() d
	.s rowid=newRowidList.GetAt(t4)
	.&SQL(delete from dhc_pa_data.UnitResult where UnitResult_rowid=:rowid)
	
	q "true"
}

/// Creator：李明忠
/// CreatDate：2011-3-3
/// Description: 获取单元绩效方案记录
/// Table：dhc_pa_data.UnitResult
/// Input：schemDr-绩效方案ID
/// Output：
/// Return：有效单元绩效方案字符串
/// Others：w ##class(dhc.pa.udata.uDistTarget).GetUnitOfURRecordOfSchem("1||5")
ClassMethod GetUnitOfURRecordOfSchem(schemDr) As %String
{
	n (schemDr)
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select distinct(UnitResult_jxUnitDr) from dhc_pa_data.UnitResult where UnitResult_childSub>0 and UnitResult_schemDr='"_schemDr_"'"
	d result.Prepare(sqlStr)
	d result.Execute()

	s resultString = ""
	While(result.Next()){
		s jxUnitDr = result.Data("UnitResult_jxUnitDr")
		
		s tmp=jxUnitDr
		i resultString="" s resultString=tmp
		e  s resultString=resultString_"^"_tmp
	}
	d result.Close()
	q resultString
}

/// Creator：李明忠
/// CreatDate：2011-3-3
/// Description: 获取单元绩效方案记录
/// Table：dhc_pa_data.UnitResult
/// Input：schemDr-绩效方案ID
/// Output：
/// Return：有效单元绩效方案字符串
/// Others：w ##class(dhc.pa.udata.uDistTarget).GetURRecordOfSchem("1||5")
ClassMethod GetURRecordOfSchem(schemDr) As %String
{
	n (schemDr)
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select UnitResult_rowid,UnitResult_schemDr,UnitResult_jxUnitDr from dhc_pa_data.UnitResult where UnitResult_childSub>0 and UnitResult_schemDr='"_schemDr_"'"
	d result.Prepare(sqlStr)
	d result.Execute()

	s resultString = ""
	While(result.Next()){
		s rowid = result.Data("UnitResult_rowid")
		s schemId = result.Data("UnitResult_schemDr")
		s jxUnitDr = result.Data("UnitResult_jxUnitDr")
		
		s tmp=rowid_"^"_schemId_"^"_jxUnitDr
		i resultString="" s resultString=tmp
		e  s resultString=resultString_"!"_tmp
	}
	d result.Close()
	q resultString
}

/// Creator：李明忠
/// CreatDate：2011-3-3
/// Description: 获取单元绩效方案明细的rowid记录
/// Table：dhc_pa_data.UnitResultDetail
/// Input：urRowid-单元绩效方案ID
/// Output：
/// Return：单元绩效方案明细的rowid记录
/// Others：w ##class(dhc.pa.udata.uDistTarget).GetURDRecord("1||5")
ClassMethod GetURDRecord(list, urRowid) As %String
{
	n (list,urRowid)
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select UnitResultDetail_parRef,UnitResultDetail_rowid from dhc_pa_data.UnitResultDetail where UnitResultDetail_childSub>0 and UnitResultDetail_parRef='"_urRowid_"'"
	d result.Prepare(sqlStr)
	d result.Execute()

	While(result.Next()){
		s rowid = result.Data("UnitResultDetail_rowid")
		d list.Insert(rowid)
	}
	d result.Close()
	q list
}

/// Creator：李明忠
/// CreatDate：2011-3-3
/// Description: 获取单元绩效方案明细的rowid记录(加分法)
/// Table：dhc_pa_data.URDetailAdd
/// Input：urRowid-单元绩效方案ID
/// Output：
/// Return：单元绩效方案明细的rowid记录(加分法)
/// Others：w ##class(dhc.pa.udata.uDistTarget).GetURDAddRecord("1||5")
ClassMethod GetURDAddRecord(list, urdRowid) As %String
{
	n (list,urdRowid)
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select URDetailAdd_parRef,URDetailAdd_rowid from dhc_pa_data.URDetailAdd where URDetailAdd_childSub>0 and URDetailAdd_parRef='"_urdRowid_"'"
	d result.Prepare(sqlStr)
	d result.Execute()

	While(result.Next()){
		s rowid = result.Data("URDetailAdd_rowid")
		d list.Insert(rowid)
	}
	d result.Close()
	q list
}

/// Creator：李明忠
/// CreatDate：2011-3-3
/// Description: 获取单元绩效方案明细的rowid记录(区间法)
/// Table：dhc_pa_data.URDetailAdd
/// Input：urRowid-单元绩效方案ID
/// Output：
/// Return：单元绩效方案明细的rowid记录(加分法)
/// Others：w ##class(dhc.pa.udata.uDistTarget).GetURDDistRecord("1||5")
ClassMethod GetURDDistRecord(list, urdRowid) As %String
{
	n (list,urdRowid)
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select URDetailDist_parRef,URDetailDist_rowid from dhc_pa_data.URDetailDist where URDetailDist_childSub>0 and URDetailDist_parRef='"_urdRowid_"'"
	d result.Prepare(sqlStr)
	d result.Execute()

	While(result.Next()){
		s rowid = result.Data("URDetailDist_rowid")
		d list.Insert(rowid)
	}
	d result.Close()
	q list
}

/// Others：w ##class(dhc.pa.udata.uDistTarget).Test()
ClassMethod Test() As %String
{
	s tr="56^57^58^59^60^61^62^63^64^65^66^67^68^69^70^71^72^73^74^75^76^77"
	s jxUnitList=##class(%Library.ListOfDataTypes).%New() //定义集合List
	
	//s jxUnitStr=..GetJXUnitOfSchem(schemDr) //获取该方案下的所有科室
	s jxUnitLen=$L(tr,"^")
	f k=1:1:jxUnitLen d
	.d jxUnitList.Insert($P(tr,"^",k))
	 
	/*
	......
	......i num=0 d
	.......&SQL(INSERT INTO dhc_pa_data.Schem_Perid_Rec (SPR_parRef, SPR_appSysDr, SPR_schemDr, SPR_period, SPR_auditDate) VALUES (:currStratagemDr, :appSysDr, :schemDr,:period,  0))

	
	*/
	w jxUnitList.Find(56,0),!
}

ClassMethod CopySchemToPeridRec(currStratagemDr, appSysDr, schemDr, period) As %String
{
	s sqlcode=0
	s num=0
	&SQL(select count(%ID) into :num from dhc_pa_data.Schem_Perid_Rec where SPR_parRef=:currStratagemDr AND SPR_appSysDr=:appSysDr and SPR_schemDr=:schemDr and SPR_period=:period)
	i num=0 d
	.&SQL(INSERT INTO dhc_pa_data.Schem_Perid_Rec (SPR_parRef, SPR_appSysDr, SPR_schemDr, SPR_period, SPR_auditState) VALUES (:currStratagemDr, :appSysDr, :schemDr,:period,0))
    q sqlcode
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.uDistTargetS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
