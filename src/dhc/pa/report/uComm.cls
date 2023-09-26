/// Creator: 李明忠
/// CreatDate: 2010-9-14
/// Description: 部分公用Query类文件
Class dhc.pa.report.uComm Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator:李明忠
/// CreatDate:2010-9-9
/// Description:年度Query
/// Table:dhc_pa_data.Cycle
/// Others:d ##class(%ResultSet).RunQuery("dhc.pa.report.uComm","GetCycle")
Query GetCycle() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	select Cycle_rowid,Cycle_code from dhc_pa_data.Cycle where Cycle_rowid>0 and Cycle_active='Y' order by Cycle_code Asc
}

ClassMethod GetPeriodExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	s Freq="",PeriodDr="",PeriodName=""
	
	s FreqLen=4
	f k=1:1:FreqLen d
	.i k=1 d
	..s Freq="M"
	..f m=1:1:12 d
	...s PeriodDr=m
	...i m<10 s PeriodName="0"_m_"月"
	...e  s PeriodName=m_"月"
	...d OutputRowPeriod 
	.i k=2 d
	..s Freq="Q"
	..f n=1:1:4 d
	...s PeriodDr=n
	...s PeriodName="0"_n_"季度"
	...d OutputRowPeriod 
	.i k=3 d
	..s Freq="H"
	..f l=1:1:2 d
	...s PeriodDr=l
	...i PeriodDr=1 s PeriodName="上半年"
	...i PeriodDr=2 s PeriodName="下半年"
	...d OutputRowPeriod
	.i k=4 d
	..s Freq="Y"
	..s PeriodDr=0
	..s PeriodName="全年"
	..d OutputRowPeriod
 
 	q $$$OK
OutputRowPeriod
	
 	s Data=$lb(Freq,PeriodDr,PeriodName)
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod GetPeriodFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPeriodExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetPeriodClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPeriodExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:李明忠
/// CreatDate:2010-9-14
/// Description:期间Query
/// Table:
/// Others:d ##class(%ResultSet).RunQuery("dhc.pa.report.uComm","GetPeriod")
Query GetPeriod() As %Query(ROWSPEC = "Freq:%String,PeriodDr:%String,PeriodName:%String") [ SqlProc ]
{
}

/// Creator:李明忠
/// CreatDate:2010-9-9
/// Description:查询当前战略下的方案
/// Table:dhc_pa_data.Schem
/// Input:cycleDr-战略年度Dr,frequency-报告频率
/// Output:
/// Return:返回查询到的记录的Json串
/// Others:w ##class(dhc.pa.report.uComm).GetSchems()
ClassMethod GetSchems(USERCODE) As %String
{
	n (USERCODE)
   
	/*
	s count=0
	s stratagemDr="",cycleDr=""
	s curreStratagemDr = ""
	f  s stratagemDr=$o(^DHCCJXPASTRATAGEM(stratagemDr)) q:stratagemDr=""  d
	.i $D(^DHCCJXPASTRATAGEM(stratagemDr)) d
	..i $g(^DHCCJXPASTRATAGEM(stratagemDr))'="" d
	...s curreStratagem = $p(^DHCCJXPASTRATAGEM(stratagemDr),"^",14)
	...i curreStratagem="Y" d
	....s cycleDr=$p(^DHCCJXPASTRATAGEM(stratagemDr),"^",2)
	....i cycleDr'="" d
	.....s curreStratagemDr = stratagemDr
	.....s count=count+1
	
	q:count>1 schemStr
	*/
	s active="Y"
	
	s sqlStr="select Stratagem_cycleDr,Schem_rowid,Schem_shortcut,Schem_frequency,Schem_appSysDr from dhc_pa_data.Schem,dhc_pa_data.Stratagem where Schem_childSub>0 and Stratagem_rowid = Schem_parRef and Schem_active='"_active_"'"
	;w sqlStr,!
	s result = ##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s schemStr=""
	While(result.Next()){
		s schemDr = result.Data("Schem_rowid")
		s shortcut = result.Data("Schem_shortcut")
		s frequency = result.Data("Schem_frequency")
		s appSysDr = result.Data("Schem_appSysDr")
		s cycleDr = result.Data("Stratagem_cycleDr")
		s tmp=cycleDr_"^"_frequency_"^"_schemDr_"^"_shortcut_"^"_appSysDr
	
		// 方案权限  20140224 add
		s userCode=""
		s userCode=$$ALPHAUP^SSUTIL4(USERCODE)
	    //根据用户Code查找用户ID
	    s userDr=0
	    s userDr=$O(^SSU("SSUSR",0,"SSUSR_Initials",userCode,userDr))
		
	  
	    s rowid="" 
	    i userDr'=0  s rowid=$o(^DHCCJXPASCHEMAUDIT(0,"SchemUser",schemDr,userDr,rowid))
	   	
		i rowid'="" d
	    .i schemStr="" s schemStr=tmp
		.e  s schemStr=schemStr_"!"_tmp
		
		
		
		;i schemStr="" s schemStr=tmp
		;e  s schemStr=schemStr_"!"_tmp
	}
	
	q schemStr
}

/// Creator:wang ying
/// CreatDate:2011-2-16
/// Description:查询当前战略下的方案
/// Table:dhc_pa_data.Schem
/// Input:cycleDr-战略年度Dr,frequency-报告频率
/// Output:
/// Return:返回查询到的记录的Json串
/// Others:w ##class(dhc.pa.report.uComm).GetSchem()
ClassMethod GetSchem() As %String
{
	/*
	s count=0
	s stratagemDr="",cycleDr=""
	s curreStratagemDr = ""
	f  s stratagemDr=$o(^DHCCJXPASTRATAGEM(stratagemDr)) q:stratagemDr=""  d
	.i $D(^DHCCJXPASTRATAGEM(stratagemDr)) d
	..i $g(^DHCCJXPASTRATAGEM(stratagemDr))'="" d
	...s curreStratagem = $p(^DHCCJXPASTRATAGEM(stratagemDr),"^",14)
	...i curreStratagem="Y" d
	....s cycleDr=$p(^DHCCJXPASTRATAGEM(stratagemDr),"^",2)
	....i cycleDr'="" d
	.....s curreStratagemDr = stratagemDr
	.....s count=count+1
	
	q:count>1 schemStr
	*/
	s active="Y"
	
	s sqlStr="select Stratagem_cycleDr,Schem_rowid,Schem_shortcut,Schem_frequency,Schem_appSysDr,Schem_level from dhc_pa_data.Schem,dhc_pa_data.Stratagem where Schem_childSub>0 and Stratagem_rowid = Schem_parRef and Schem_active='"_active_"'"
	
	s result = ##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s schemStr=""
	While(result.Next()){
		s schemDr = result.Data("Schem_rowid")
		s shortcut = result.Data("Schem_shortcut")
		s frequency = result.Data("Schem_frequency")
		s appSysDr = result.Data("Schem_appSysDr")
		s cycleDr = result.Data("Stratagem_cycleDr")
		s level = result.Data("Schem_level")
		s tmp=cycleDr_"^"_frequency_"^"_schemDr_"^"_shortcut_"^"_appSysDr_"^"_level
		i schemStr="" s schemStr=tmp
		e  s schemStr=schemStr_"!"_tmp
	}
	
	q schemStr
}

ClassMethod GetSchemRecordExecute(ByRef qHandle As %Binary, USERCODE As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
	q:USERCODE="" $$$OK
	s schemStr=..GetSchems(USERCODE)
	
	s Len=$L(schemStr,"!")
	s cycleDr="",frequency="",schemDr="",schemName=""
	f k=1:1:Len d
	.s schemInfo=$P(schemStr,"!",k)
	.s cycleDr=$P(schemInfo,"^",1)
	.s frequency=$P(schemInfo,"^",2)
	.s schemDr=$P(schemInfo,"^",3)
	.s schemName=$P(schemInfo,"^",4)
	.s appSysDr=$P(schemInfo,"^",5)
	.d OutputRowSchem
 
 	q $$$OK
OutputRowSchem
	
 	s Data=$lb(cycleDr,frequency,schemDr,schemName,appSysDr)
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod GetSchemRecordFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSchemRecordExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetSchemRecordClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSchemRecordExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:李明忠
/// CreatDate:2010-9-9
/// Description:方案Query
/// Table:
/// Others:d ##class(%ResultSet).RunQuery("dhc.pa.report.uComm","GetSchemRecord")
Query GetSchemRecord(USERCODE As %String) As %Query(ROWSPEC = "cycleDr:%Integer,frequency:%String,schemDr:%String,schemName:%String,appSysDr:%Integer") [ SqlProc ]
{
}

ClassMethod GetUserInfoExecute(ByRef qHandle As %Binary, userCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	q:userCode="" $$$OK
	
	s userDr="",userName="",userDeptName="中国石油中心医院"
	//用户信息
	s userCode=$$ALPHAUP^SSUTIL4(userCode)
	//根据用户Code查找用户ID
	s userId=0
	s userDr=$O(^SSU("SSUSR",0,"SSUSR_Initials",userCode,userDr))
	i userDr'="" d
	.i $D(^SSU("SSUSR",userDr)) d
	..i $G(^SSU("SSUSR",userDr))'="" d
	...s userName=$P(^SSU("SSUSR",userDr),"^",2)
	d OutputRowUserInfo
 
 	q $$$OK
OutputRowUserInfo
	
 	s Data=$lb(userDr,userName,userDeptName)
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod GetUserInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUserInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetUserInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUserInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:李明忠
/// CreatDate:2010-9-15
/// Description:用户信息Query
/// Input:userCode-用户代码
/// Others:d ##class(%ResultSet).RunQuery("dhc.pa.report.uComm","GetUserInfo","demo")
Query GetUserInfo(userCode As %String) As %Query(ROWSPEC = "userDr:%Integer,userName:%String,userDeptName:%String") [ SqlProc ]
{
}

/// Creator:李明忠
/// CreatDate:2010-9-21
/// Description:查询当前战略的绩效考核方案
/// Table:dhc_pa_data.Schem
/// Input:CurrStratagemDr-当前战略
/// Output:
/// Return:返回当前战略的绩效考核方案Dr字符串
/// Others:w ##class(dhc.pa.report.uComm).GetSchemOfCurrStratagemDr(1)
ClassMethod GetSchemOfCurrStratagemDr(CurrStratagemDr) As %String
{
	n (CurrStratagemDr)
	
	s SchemDrStr=""
	q:CurrStratagemDr="" SchemDrStr
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select Schem_rowid from dhc_pa_data.Schem,dhc_pa_data.Stratagem where Schem_childSub>0 and Schem_appSysDr=2 and Schem_active='Y' and Schem_parRef=Stratagem_rowid"
	
	d result.Prepare(sqlStr)
	d result.Execute()

	While(result.Next()){
		s rowid = result.Data("Schem_rowid")
		i rowid'="" d
		.s SchemDr = rowid
		.i SchemDrStr="" s SchemDrStr=SchemDr
		.e  s SchemDrStr=SchemDrStr_"^"_SchemDr
	}
	
	q SchemDrStr
}

/// Creator:李明忠
/// CreatDate:2010-9-21
/// Description:查询绩效考核方案下的绩效单元
/// Table:dhc_pa_data.UnitSchem
/// Input:schemDr-绩效方案Dr
/// Output:
/// Return:返回绩效考核方案下的绩效单元Dr字符串
/// Others:w ##class(dhc.pa.report.uComm).GetJXUnitOfSchem("1||2")
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

ClassMethod GetJXUnitExecute(ByRef qHandle As %Binary, USERCODE As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
	s Stratagem=0
	s curreStratagemDr=0
	f  s Stratagem=$o(^DHCCJXPASTRATAGEM(Stratagem)) q:Stratagem=""  d
	.i $D(^DHCCJXPASTRATAGEM(Stratagem)) d
	..i $g(^DHCCJXPASTRATAGEM(Stratagem))'="" d
	...s curreStratagem = $p(^DHCCJXPASTRATAGEM(Stratagem),"^",14)
	...i curreStratagem="Y" d
	....s curreStratagemDr = Stratagem
	
	q:curreStratagemDr=0 $$$OK
	
	;q:USERCODE="" $$$OK
	
	s schemDr="",jxUnitDr=""
	
	//获取战略下的方案
	s schemDrStr=..GetSchemOfCurrStratagemDr(curreStratagemDr)
	s Len=$L(schemDrStr,"^")
	f k=1:1:Len d
	.s schemDr=$P(schemDrStr,"^",k)
	.i schemDr'="" d
	..;获取方案下的绩效单元
	..s jxUnitDrStr=..GetJXUnitOfSchem(schemDr)
	..s Length=$L(jxUnitDrStr,"^")
	..f m=1:1:Length d
	...s jxUnitDr=$P(jxUnitDrStr,"^",m)
	...i jxUnitDr'="" d
	....s jxUnitName=""
	....i $D(^DHCCJXPAJXUNIT(jxUnitDr)) d
	.....i $G(^DHCCJXPAJXUNIT(jxUnitDr))'="" d
	......s jxUnitName=$P(^DHCCJXPAJXUNIT(jxUnitDr),"^",3)


	......s userCode=""     //方案权限   20140224 add
	......s userCode=$$ALPHAUP^SSUTIL4(USERCODE)
	......s userDr=0
    ......s userDr=$O(^SSU("SSUSR",0,"SSUSR_Initials",userCode,userDr))	  
	......s rowid="" 
	......i userDr'=0  s rowid=$o(^DHCCJXPAJXUNITAUDIT(0,"JXUnitUser",jxUnitDr,userDr,rowid))
	......i rowid'="" d
	.......d OutputRowJXUnit  


	......;d OutputRowJXUnit
	

	
 	q $$$OK
OutputRowJXUnit
	
 	s Data=$lb(schemDr,jxUnitDr,jxUnitName)
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod GetJXUnitFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetJXUnitExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetJXUnitClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetJXUnitExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:李明忠
/// CreatDate:2010-9-21
/// Description:获取绩效方案下科室Query
/// Others:d ##class(%ResultSet).RunQuery("dhc.pa.report.uComm","GetJXUnit","demo")
Query GetJXUnit(USERCODE As %String) As %Query(ROWSPEC = "schemDr:%String,jxUnitDr:%Integer,jxUnitName:%String") [ SqlProc ]
{
}

/// Creator:李明忠
/// CreatDate:2010-9-21
/// Description:查询绩效考核方案下的指标Dr字符串
/// Table:dhc_pa_data.UnitSchem
/// Input:schemDr-绩效方案Dr
/// Output:
/// Return:返回绩效考核方案下的指标Dr字符串
/// Others:w ##class(dhc.pa.report.uComm).GetKPIOfSchem("1||2")
ClassMethod GetKPIOfSchem(schemDr) As %String
{
	n (schemDr)
	
	s KPIDrStr=""
	q:schemDr="" KPIDrStr
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT KPIIndex1_rowid FROM dhc_pa_data.KPIIndex1 where %ID>0 and KPIIndex1_isKPI='Y' and KPIIndex1_isEnd='Y'and EXISTS (SELECT SchemDetail_KPIDr FROM dhc_pa_data.SchemDetail where dhc_pa_data.KPIIndex1.KPIIndex1_rowid =dhc_pa_data.SchemDetail.SchemDetail_KPIDr and SchemDetail_parRef='"_schemDr_"')"
	
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

ClassMethod GetKPIExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
	s Stratagem=0
	s curreStratagemDr=0
	f  s Stratagem=$o(^DHCCJXPASTRATAGEM(Stratagem)) q:Stratagem=""  d
	.i $D(^DHCCJXPASTRATAGEM(Stratagem)) d
	..i $g(^DHCCJXPASTRATAGEM(Stratagem))'="" d
	...s curreStratagem = $p(^DHCCJXPASTRATAGEM(Stratagem),"^",14)
	...i curreStratagem="Y" d
	....s curreStratagemDr = Stratagem
	
	q:curreStratagemDr=0 $$$OK
	
	s schemDr="",KPIDr=""
	
	//获取战略下的方案
	s schemDrStr=..GetSchemOfCurrStratagemDr(curreStratagemDr)
	s Len=$L(schemDrStr,"^")
	f k=1:1:Len d
	.s schemDr=$P(schemDrStr,"^",k)
	.i schemDr'="" d
	..;获取方案下的KPI明细
	..s KPIDrStr=..GetKPIOfSchem(schemDr)
	..s Length=$L(KPIDrStr,"^")
	..f m=1:1:Length d
	...s KPIDr=$P(KPIDrStr,"^",m)
	...i KPIDr'="" d
	....s KPIName=""
	....i $D(^DHCCJXPAKPIINDEX1(KPIDr)) d
	.....i $G(^DHCCJXPAKPIINDEX1(KPIDr))'="" d
	......s KPIName=$P(^DHCCJXPAKPIINDEX1(KPIDr),"^",3)
	......d OutputRowKPI
	
 	q $$$OK
OutputRowKPI
	
 	s Data=$lb(schemDr,KPIDr,KPIName)
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod GetKPIFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetKPIExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetKPIClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetKPIExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:李明忠
/// CreatDate:2010-9-21
/// Description:获取绩效方案下KPI明细Query
/// Others:d ##class(%ResultSet).RunQuery("dhc.pa.report.uComm","GetKPI")
Query GetKPI() As %Query(ROWSPEC = "schemDr:%String,KPIDr:%Integer,KPIName:%String") [ SqlProc ]
{
}

/// Creator:李明忠
/// CreatDate:2010-9-21
/// Description:分组设置Query
/// Table:dhc_pa_data.JXGroup
/// Others:d ##class(%ResultSet).RunQuery("dhc.pa.report.uComm","GetJXGroup")
Query GetJXGroup() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	select JXGroup_rowid,JXGroup_name,JXGroup_type from dhc_pa_data.JXGroup where JXGroup_rowid>0 order by JXGroup_rowid desc
}

/// Creator:wang ying
/// CreatDate:2011-01-29
/// Description:根据权限取科室
/// Table:dhc_pa_data.JXGroup
/// Others:d ##class(%ResultSet).RunQuery("dhc.pa.report.uComm","GetJXUnitByAduit","LLZZ","134")
Query GetJXUnitByAduit(USERCODE As %String) As %Query(ROWSPEC = "schemDr:%String,unitName:%String,unitDr:%String") [ SqlProc ]
{
}

ClassMethod GetJXUnitByAduitExecute(ByRef qHandle As %Binary, USERCODE As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
	s Stratagem=0
	s curreStratagemDr=0
	f  s Stratagem=$o(^DHCCJXPASTRATAGEM(Stratagem)) q:Stratagem=""  d
	.i $D(^DHCCJXPASTRATAGEM(Stratagem)) d
	..i $g(^DHCCJXPASTRATAGEM(Stratagem))'="" d
	...s curreStratagem = $p(^DHCCJXPASTRATAGEM(Stratagem),"^",14)
	...i curreStratagem="Y" d
	....s curreStratagemDr = Stratagem
	
	q:curreStratagemDr=0 $$$OK
	
	s schemDr="",jxUnitDr=""
	
	q:USERCODE="" "NoData"
	
	s USERCODE=$$ALPHAUP^SSUTIL4(USERCODE)
	//根据用户Code查找用户ID
	s userId=0
	s userId=$O(^SSU("SSUSR",0,"SSUSR_Initials",USERCODE,userId))
	q:userId="" "NoData"
	
	s newUnitList=##class(%Library.ListOfDataTypes).%New()
	
	s aduit=0
	f  s aduit=$o(^DHCCJXPAJXUNITAUDIT(0,"User",userId,aduit)) q:aduit=""  d
	.i $d(^DHCCJXPAJXUNITAUDIT(aduit)) d
	..s unit=$p($g(^DHCCJXPAJXUNITAUDIT(aduit)),"^",1)
	..d newUnitList.Insert(unit)
	//获取战略下的方案
	s schemDrStr=..GetSchemOfCurrStratagemDr(curreStratagemDr)
	s Len=$L(schemDrStr,"^")
	f k=1:1:Len d
	.s schemDr=$P(schemDrStr,"^",k)
	.i schemDr'="" d
	..;获取方案下的绩效单元
	..s jxUnitDrStr=..GetJXUnitOfSchem(schemDr)
	..s Length=$L(jxUnitDrStr,"^")
	..f m=1:1:Length d
	...s jxUnitDr=$P(jxUnitDrStr,"^",m)
	...s str=newUnitList.Find(jxUnitDr)
	...i (jxUnitDr'="")&&(str'="") d
	....;w jxUnitDr,!
	....s jxUnitName=""
	....i $D(^DHCCJXPAJXUNIT(jxUnitDr)) d
	.....i $G(^DHCCJXPAJXUNIT(jxUnitDr))'="" d
	......s jxUnitName=$P(^DHCCJXPAJXUNIT(jxUnitDr),"^",3)
	......d OutputRowJXUnitByAduit
	
 	q $$$OK

OutputRowJXUnitByAduit
	
 	s Data=$lb(schemDr,jxUnitName,jxUnitDr)
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod GetJXUnitByAduitFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetJXUnitByAduitExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetJXUnitByAduitClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetJXUnitByAduitExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:wang ying
/// CreatDate:2011-11-29
/// Description:绩效单元Query
/// Table:
/// Others:d ##class(%ResultSet).RunQuery("dhc.pa.report.uComm","GetCycle")
Query JXunit1() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	select JXUnit_rowid,JXUnit_name,JXUnit_parent from dhc_pa_data.JXUnit where %ID>0 and JXUnit_level=1
}

/// Creator:wang ying
/// CreatDate:2011-11-29
/// Description:绩效单元Query
/// Table:
/// Others:d ##class(%ResultSet).RunQuery("dhc.pa.report.uComm","GetCycle")
Query JXunit2() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	select JXUnit_rowid,JXUnit_name,JXUnit_parent from dhc_pa_data.JXUnit where %ID>0 and JXUnit_level=2
}

/// Creator:wang ying
/// CreatDate:2011-11-29
/// Description:绩效单元Query
/// Table:
/// Others:d ##class(%ResultSet).RunQuery("dhc.pa.report.uComm","JXunitEnd")
Query JXunitEnd() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	select DISTINCT (JXUnit_rowid),JXUnit_name,JXUnit_parent,UnitResult_SchemDr from dhc_pa_data.JXUnit,dhc_pa_data.UnitResult where  JXUnit_level=3 and UnitResult_jxUnitDr=JXUnit_rowid
}

/// Creator:wang ying
/// CreatDate:2012-2-16
/// Description:方案Query
/// Table:
/// Others:d ##class(%ResultSet).RunQuery("dhc.pa.report.uComm","GetSchem")
Query GetSchem() As %Query(ROWSPEC = "cycleDr:%Integer,frequency:%String,schemDr:%String,schemName:%String,appSysDr:%String,level:%String") [ SqlProc ]
{
}

ClassMethod GetSchemExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	s schemStr=..GetSchem()
	
	s Len=$L(schemStr,"!")
	s cycleDr="",frequency="",schemDr="",schemName=""
	f k=1:1:Len d
	.s schemInfo=$P(schemStr,"!",k)
	.s cycleDr=$P(schemInfo,"^",1)
	.s frequency=$P(schemInfo,"^",2)
	.s schemDr=$P(schemInfo,"^",3)
	.s schemName=$P(schemInfo,"^",4)
	.s appSysDr=$P(schemInfo,"^",5)
	.s level=$P(schemInfo,"^",6)
	.d OutputRowSchems
 
 	q $$$OK
OutputRowSchems
	
 	s Data=$lb(cycleDr,frequency,schemDr,schemName,appSysDr,level)
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod GetSchemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSchemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetSchemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSchemExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

//w ##class(dhc.pa.report.uComm).getUserInfo("demo")

ClassMethod getUserInfo(userCode As %String) As %String
{
	n (userCode)
	s userDr=0
	//用户信息
	s userCode=$$ALPHAUP^SSUTIL4(userCode)
	//根据用户Code查找用户ID
	s userDr=$O(^SSU("SSUSR",0,"SSUSR_Initials",userCode,userDr))
	q:userDr'="" userDr
}

//w ##class(dhc.pa.report.uComm).getJXUnitInfo(13,"demo")

ClassMethod getJXUnitInfo(JXUnitDr As %String, userCode As %String) As %String
{
	n (JXUnitDr,userCode)
	s flag=""
	//用户信息
	s sqlStr="select JXUnitAudit_rowid,JXUnitAudit_jxUnitDr,JXUnitAudit_userDr,JXUnitAudit_isRead,JXUnitAudit_isWrite from dhc_pa_data.JXUnitAudit"
	s whereStr=" where %ID>0 and JXUnitAudit_jxUnitDr='"_JXUnitDr_"' and JXUnitAudit_userDr='"_userCode_"'"
    s sqlStr=sqlStr_whereStr
	;w sqlStr,!
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s rowid=0
	While(result.Next()){
		//集体初始化
		s rowid=result.Data("JXUnitAudit_rowid")
		
	}
	d result.Close()
    q:rowid'="" rowid
}

//w ##class(dhc.pa.report.uComm).getKPIInfo(1,"demo")

ClassMethod getKPIInfo(KPIDr As %String, userCode As %String) As %String
{
	n (KPIDr,userCode)
	s flag=""
	//用户信息
	s sqlStr="select * from dhc_pa_data.KPIAudit"
	s whereStr=" where %ID>0 and KPIAudit_KPIDr='"_KPIDr_"' and KPIAudit_userDr='"_userCode_"'"
    s sqlStr=sqlStr_whereStr
	;w sqlStr,!
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s rowid=0
	While(result.Next()){
		//集体初始化
		s rowid=result.Data("KPIAudit_rowid")
		
	}
	d result.Close()
    q:rowid'="" rowid
}

Query getKPIInfo() As %Query(ROWSPEC = "KPIDr:%String,KPICode:%String,KPIExpName:%String") [ SqlProc ]
{
}

ClassMethod getKPIInfoExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
	s KPIDr=""
	
	
	......d OutputRowKPIInfo
	
 	q $$$OK
OutputRowKPIInfo
	
 	s Data=$lb(schemDr,jxUnitDr,jxUnitName)
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod getKPIInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = getKPIInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod getKPIInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = getKPIInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:wang ying
/// CreatDate:2014-3-19
/// Description:方案下的指标
/// Table:dhc_pa_data.Cycle
/// Others:d ##class(%ResultSet).RunQuery("dhc.pa.report.uComm","GetSchemKPI")
Query GetSchemKPI() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	select KPIIndex1_rowid as id,KPIIndex1_code as code,KPIIndex1_name as name,SchemDetail_parRef,SchemDetail_isTarget from dhc_pa_data.schemDetail,dhc_pa_data.KPIIndex1 where SchemDetail_KPIDr=KPIIndex1_rowid and SchemDetail_isTarget=2  
    union all
    select DimensType_rowid as id,DimensType_code as code,DimensType_name as name,SchemDetail_parRef,SchemDetail_isTarget from dhc_pa_data.schemDetail,dhc_pa_data.DimensType where SchemDetail_KPIDr=DimensType_rowid  and SchemDetail_isTarget=1
}

Storage Default
{
<StreamLocation>^dhc.pa.report.uCommS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
