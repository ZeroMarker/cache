/// Creator: 李明忠
/// CreatDate: 2010-07-29
/// Description: 基本数字表维护
Class dhc.pa.udata.uJXBaseData Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator：李明忠
/// CreatDate：2010-7-29
/// Description: 查询符合条件的基本数据记录
/// Table：dhc_pa_data.JXBaseData
/// Input：period-考核期间;periodType-期间类型;parRef-绩效单元ID;searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.pa.udata.uJXBaseData).List("","","","",5,25,"201401","M",1)
ClassMethod List(searchField, searchValue, sortField, sortDir, start, limit, period, periodType, userID) As %String
{
	n (searchField, searchValue, sortField, sortDir, start, limit, period, periodType,userID)
	
	s sqlStr="select JXBaseData_parRef,JXBaseData_rowid,JXBaseData_childSub,JXBaseData_period,JXBaseData_periodType,JXBaseData_KPIDr,JXBaseData_KPIDr->KPIIndex1_calUnitDr,JXBaseData_actualValue,JXBaseData_auditDate,JXBaseData_auditUserDr,JXBaseData_dataState,JXBaseData_desc from dhc_pa_data.JXBaseData"
	s whereStr=" where JXBaseData_childSub>0"
	i period'="" s whereStr=whereStr_" and JXBaseData_period ='"_period_"'"
	i periodType'="" s whereStr=whereStr_" and JXBaseData_periodType ='"_periodType_"'"
	;s sortField="KPIName" 

	s sortStr="",sortField1=""
	i sortField'="" d
	.i sortField="parRefName" s sortField1="JXBaseData_parRef"
	.i sortField="rowid" s sortField1="JXBaseData_rowid"
	.i sortField="childSub" s sortField1="JXBaseData_childSub"
	.i sortField="period" s sortField1="JXBaseData_period"
	.i sortField="periodTypeName" s sortField1="JXBaseData_periodType"
	.i sortField="KPIName" s sortField1="JXBaseData_KPIDr"
	.i sortField="actualValue" s sortField1="JXBaseData_actualValue"
	.i sortField="auditDate" s sortField1="JXBaseData_auditDate"
	.i sortField="auditUserName" s sortField1="JXBaseData_auditUserDr"
	.i sortField="dataStateName" s sortField1="JXBaseData_dataState"

	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  d
	.s sortStr=" ORDER BY %ID DESC"
			
	s sqlStr=sqlStr_whereStr_sortStr
	
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	;w sqlStr,!
	s json=##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="parRef^parRefName^rowid^childSub^period^periodType^periodTypeName^KPIDr^KPIName^actualValue^auditDate^auditUserDr^auditUserName^dataState^dataStateName^desc^calUnitName"
	
	While(result.Next()){
		//集体初始化
		s parRefName="",dataStateName="",periodTypeName="",KPIName="",auditUserName="",dataStateName=""
		
		//绩效单元
		s parRef=result.Data("JXBaseData_parRef")
		
		
		i $d(^DHCCJXPAJXUNITAUDIT(0,"JXUnitUser",parRef,userID)) d
		.i parRef'="" d
		..i $D(^DHCCJXPAJXUNIT(parRef)) d
		...i $G(^DHCCJXPAJXUNIT(parRef))'="" d
		....s parRefName=$P(^DHCCJXPAJXUNIT(parRef),"^",3)
		
		
		s rowid=result.Data("JXBaseData_rowid")
		s childSub=result.Data("JXBaseData_childSub")
		s period=result.Data("JXBaseData_period")
		//期间类型
		s periodType=result.Data("JXBaseData_periodType")
		i periodType="M" s periodTypeName="月份"
		i periodType="Q" s periodTypeName="季度"
		i periodType="H" s periodTypeName="半年"
		i periodType="Y" s periodTypeName="年度"
		//指标
		s KPIDr=result.Data("JXBaseData_KPIDr")
		i KPIDr'="" d
		.i $d(^DHCCJXPAKPIAUDIT(0,"User",userID,KPIDr)) d
		..i $D(^DHCCJXPAKPIINDEX1(KPIDr)) d
		...i $G(^DHCCJXPAKPIINDEX1(KPIDr))'="" d
		....s KPIName=$P(^DHCCJXPAKPIINDEX1(KPIDr),"^",2)
		//实际值
		s actualValue=result.Data("JXBaseData_actualValue")
		s actualValue=$fn(actualValue,"",2)
		
		s auditDate=result.Data("JXBaseData_auditDate")
		if auditDate'="" s auditDate=$ZD(auditDate,3)
		//审核人员
		s auditUserDr=result.Data("JXBaseData_auditUserDr")
		i auditUserDr'="" d
		.i $D(^SSU("SSUSR",auditUserDr)) d
		..i $G(^SSU("SSUSR",auditUserDr))'="" d
		...s auditUserName=$P(^SSU("SSUSR",auditUserDr),"^",2)
		//数据状态
		s dataState=result.Data("JXBaseData_dataState")
		i dataState=-1 s dataStateName="未审核"
		i dataState=0 s dataStateName="审核中"
		i dataState=1 s dataStateName="审核通过"
		
		s desc=result.Data("JXBaseData_desc")
		
		//计量单位
		s calUnitDr = result.Data("KPIIndex1_calUnitDr")
		
		i calUnitDr'="" d
		.i $D(^DHCCJXPACALUNIT(calUnitDr)) d
		..i $G(^DHCCJXPACALUNIT(calUnitDr)) d
		...s calUnitName=$P(^DHCCJXPACALUNIT(calUnitDr),"^",2)
		
		
		
		s tmp=parRef_"^"_parRefName_"^"_rowid_"^"_childSub_"^"_period_"^"_periodType_"^"_periodTypeName_"^"_KPIDr_"^"_KPIName_"^"_actualValue_"^"_auditDate_"^"_auditUserDr_"^"_auditUserName_"^"_dataState_"^"_dataStateName_"^"_desc_"^"_calUnitName
		
		i searchValue'="" d
		.i $p(searchValue,"""",2)'="" s searchValue=$p(searchValue,"""",2)
		.q:(searchField = "period")&(period'[searchValue)
		.q:(searchField = "periodTypeName")&(periodTypeName'[searchValue)
		.;w " searchValue="_searchValue, " parRefName="_parRefName,parRefName'[searchValue,!
		.q:(searchField = "parRefName")&(parRefName'[searchValue)
		.q:(searchField = "KPIName")&(KPIName'[searchValue)
		.i $d(^DHCCJXPAJXUNITAUDIT(0,"JXUnitUser",parRef,userID))&&$d(^DHCCJXPAKPIAUDIT(0,"User",userID,KPIDr)) d
		..i (count>=start)&(count<=end) d
		...d json.InsertRowData(tmp)
		..s count=count+1
		e  d
		.i $d(^DHCCJXPAJXUNITAUDIT(0,"JXUnitUser",parRef,userID))&&$d(^DHCCJXPAKPIAUDIT(0,"User",userID,KPIDr)) d
		..i (count>=start)&(count<=end) d
		...d json.InsertRowData(tmp)
		..s count=count+1
	}
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator：李明忠
/// CreatDate：2010-7-29
/// Description: 获取考核期间
/// Table：dhc_pa_data.JXBaseData
/// Input：start:开始记录位置;limit:单页记录条数;str-模糊查询字符串
/// Output：
/// Return：有效考核期间字符串
/// Others：w ##class(dhc.pa.udata.uJXBaseData).GetPeriod(0,10,"")
ClassMethod GetPeriod(start, limit, str) As %String
{
	n (start, limit, str)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select DISTINCT JXBaseData_period from dhc_pa_data.JXBaseData where JXBaseData_childSub>0"
	i str'="" s sqlStr = sqlStr_" and JXBaseData_period like '"_str_"%'"
	
	d result.Prepare(sqlStr)
	d result.Execute()

	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	While(result.Next()){
		s period = result.Data("JXBaseData_period")
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

/// Creator：李明忠
/// CreatDate：2010-7-29
/// Description: 判断同一绩效单元下是否存在同一记录
/// Table：dhc_pa_data.JXBaseData
/// Input：jxUnitDr-绩效单元ID;period-考核期间;periodType-期间类型;kpidr-指标
/// Output：
/// Return：返回childSub
/// Others：w ##class(dhc.pa.udata.uJXBaseData).IfRepRecode(1,"200902",2,"M")
ClassMethod IfRepRecode(jxUnitDr, period, kpidr, periodType) As %String
{
	n (jxUnitDr,period,kpidr,periodType)
	
	s childSub=""
	s childSub = $O(^DHCCJXPAJXUNIT(0,"JXBDPeriodKPI",jxUnitDr,period,periodType,kpidr,childSub))
	q childSub
}

/// Creator：李明忠
/// CreatDate：2010-7-29
/// Description: 为给定的绩效单元添加基本数据记录
/// Table：dhc_pa_data.JXBaseData
/// Input：data-待插入数据(jxunitdr^period^periodType^kpidr^actualValue^state);
/// Output：
/// Return：返回SQLCODE
/// Others：w ##class(dhc.pa.udata.uJXBaseData).Insert("3^2012^M^17^1212^-1^")
ClassMethod Insert(data) As %String
{
	n (data)
	s ^TMPLY(1)=data
	q:data="" "dataEmpt"      				//空数据dataEmpt
	k PLIST
	
	s jxUnitDr=$p(data,"^",1)				//绩效单元
	i jxUnitDr'="" s PLIST(0)=jxUnitDr 
	
	s period=$p(data,"^",2)					//考核期间
	i period'="" s PLIST(3)=period
	
	s periodType=$p(data,"^",3)				//期间类型
	i periodType'="" s PLIST(4)=periodType 
	
	s kpidr=$p(data,"^",4)					//KPI指标
	i kpidr'="" s PLIST(5)=kpidr 
	
	q:(..IfRepRecode(jxUnitDr,period,kpidr,periodType))'="" "RepRecode" 
	
	s actualValue=$p(data,"^",5)			//实际值
	i actualValue'="" s PLIST(6)=actualValue
	
	s state=$p(data,"^",6)					//审核状态
	i state="" s state=-1
	i state'="" s PLIST(9)=state
	
	s desc=$p(data,"^",7)
	i desc'="" s PLIST(10)=desc
	&SQL(insert into dhc_pa_data.JXBaseData VALUES PLIST())
	
	
	;&SQL(insert into dhc_pa_data.JXBaseData (JXBaseData_parRef,JXBaseData_period,JXBaseData_periodType,JXBaseData_KPIDr,JXBaseData_actualValue) VALUES (:jxUnitDr,:period,:periodType,:KPIDr,:actValue))
	q SQLCODE
}

/// Creator:李明忠
/// CreatDate:2010-7-29
/// Description:删除绩效单元下的基本数据记录
/// Table:dhc_pa_data.JXBaseData
/// Input:rowid-基本数据记录ID
/// Output: 
/// Return:返回执行删除语句后的SQLCODE
/// Others:w ##class(dhc.pa.udata.uJXBaseData).Delete(4)
ClassMethod Delete(rowid) As %String
{
	n (rowid)
	
	&SQL(delete from dhc_pa_data.JXBaseData where JXBaseData_rowid=:rowid)
	q SQLCODE
}

/// Creator:LY
/// CreatDate:2013-7-17
/// Description:删除系统采集指标在JXBaseData表记录
/// Table:dhc_pa_data.JXBaseData
/// Input:rowid-基本数据记录ID
/// Output: 
/// Return:返回执行删除语句后的SQLCODE
/// Others:w ##class(dhc.pa.udata.uJXBaseData).DeleteByInter("201301","Q")
ClassMethod DeleteByInter(period, periodType) As %String
{
	n (period,periodType)
	
	&SQL(delete from dhc_pa_data.JXBaseData where JXBaseData_KPIDr  in (select  InterKPI_kpiDr  from   dhc_pa_inter.interkpi ) and JXBaseData_period =:period and JXBaseData_periodType=:periodType and JXBaseData_dataState !=1  )
	;&SQL(delete from dhc_pa_data.JXBaseData where JXBaseData_KPIDr  in (select  InterKPI_kpiDr  from   dhc_pa_inter.interkpi ) and JXBaseData_period =:period and JXBaseData_periodType=:periodType   )
	q SQLCODE
}

/// Creator:LY
/// CreatDate:2014-12-8
/// Description:删除固定指标值在JXBaseData表记录
/// Table:dhc_pa_data.JXBaseData
/// Input:rowid-基本数据记录ID
/// Output: 
/// Return:返回执行删除语句后的SQLCODE
/// Others:w ##class(dhc.pa.udata.uJXBaseData).DeleteByKPIValue("201301","Q")
ClassMethod DeleteByKPIValue(period, periodType) As %String
{
	n (period,periodType)
	
	&SQL(delete from dhc_pa_data.JXBaseData where JXBaseData_KPIDr  in (select distinct(KPIVI_KPIDr) from dhc_pa_inter.KPIValueInfo ) and JXBaseData_period =:period and JXBaseData_periodType=:periodType   )
	q SQLCODE
}

/// Creator:wang ying
/// CreatDate:2016-2-15
/// Description:删除JXBaseData表记录
/// Table:dhc_pa_data.JXBaseData
/// Input:rowid-基本数据记录ID
/// Output: 
/// Return:返回执行删除语句后的SQLCODE
/// Others:w ##class(dhc.pa.udata.uJXBaseData).DeleteByKPIValue("201301","Q")
ClassMethod DeleteValue(period, periodType) As %String
{
	n (period,periodType)
	
	&SQL(delete from dhc_pa_data.JXBaseData where  JXBaseData_period =:period and JXBaseData_periodType=:periodType  and JXBaseData_dataState!=1 )
	q SQLCODE
}

/// Creator：wang ying
/// CreatDate：2014-12-8
/// Description: 导入固定指标值数据
/// Table：dhc_pa_data.JXBaseData
/// Input：period-考核期间,periodType-期间类型
/// Output：
/// Return：返回执行语句后的SQLCODE
/// Others：w ##class(dhc.pa.udata.uJXBaseData).Import("201301","Q")
ClassMethod ImportKPIValue(period, periodType) As %String
{
	n (period,periodType)
	
	s SQLCODE=0
	q:period="" ""
	q:periodType="" ""
	s KPIVIRowid=0
	f  s KPIVIRowid=$o(^DHCCJXPAKPIValueInfoD(KPIVIRowid)) q:KPIVIRowid=""  d
	.q:$g(^DHCCJXPAKPIValueInfoD(KPIVIRowid))=""
	.s KPIDr=$LIST(^DHCCJXPAKPIValueInfoD(KPIVIRowid),2)
	.s jxUnitDr=$LIST(^DHCCJXPAKPIValueInfoD(KPIVIRowid),3)
	.s value=$LIST(^DHCCJXPAKPIValueInfoD(KPIVIRowid),4)
	.s dataState=1
	.s auditData=$p($h,",",1)
	.s data=jxUnitDr_"^"_period_"^"_periodType_"^"_KPIDr_"^"_value_"^1^"
	.&SQL(Insert into dhc_pa_data.JXBaseData(JXBaseData_parRef,JXBaseData_period,JXBaseData_periodType,JXBaseData_KPIDr,JXBaseData_actualValue,JXBaseData_dataState,JXBaseData_auditDate) 
	  values(:jxUnitDr,:period,:periodType,:KPIDr,:value,:dataState,:auditData))
	.i SQLCODE'=0 d
	..d ##class(dhc.pa.udata.uPALogger).Insert("ImportKPIValue",data,SQLCODE,"")
	
	q SQLCODE
}

/// Creator：李明忠
/// CreatDate：2011-1-7
/// Description: 导入数据
/// Table：dhc_pa_data.JXBaseData
/// Input：period-考核期间,periodType-期间类型
/// Output：
/// Return：返回执行语句后的SQLCODE
/// Others：w ##class(dhc.pa.udata.uJXBaseData).Import("201301","Q")
ClassMethod Import(period, periodType) As %String
{
	n (period,periodType)
	
	s SQLCODE=0
	q:period="" ""
	q:periodType="" ""
	;s ^TMPWY=period_"^"_periodType
	
	s SQLCODE=..DeleteValue(period, periodType)
	i (SQLCODE'=0)&&(SQLCODE'=100) d //2014-12-08 update
	.d ##class(dhc.pa.udata.uPALogger).Insert("DeleteValue",period_"^"_periodType,SQLCODE,"")
	q:(SQLCODE'=0)&&(SQLCODE'=100)
	
	/*
	s SQLCODE=..DeleteByInter(period, periodType)
	i (SQLCODE'=0)&&(SQLCODE'=100) d //2014-12-08 update
	.d ##class(dhc.pa.udata.uPALogger).Insert("DeleteByInter",period_"^"_periodType,SQLCODE,"")
	q:(SQLCODE'=0)&&(SQLCODE'=100)
	
	
	s SQLCODE=..DeleteByKPIValue(period, periodType) //2014-12-08 update
	i (SQLCODE'=0)&&(SQLCODE'=100) d 
	.d ##class(dhc.pa.udata.uPALogger).Insert("DeleteByKPIValue",period_"^"_periodType,SQLCODE,"")
	q:(SQLCODE'=0)&&(SQLCODE'=100)
	*/
	
	s SQLCODE=..ImportKPIValue(period, periodType) //2014-12-08 update
	i SQLCODE'=0 d 
	.d ##class(dhc.pa.udata.uPALogger).Insert("ImportKPIValueAfter",period_"^"_periodType,SQLCODE,"")

    s SQLCODE=..getQMData(period, periodType)
    i SQLCODE'=0 d 
	.d ##class(dhc.pa.udata.uPALogger).Insert("getQMData",period_"^"_periodType,SQLCODE,"")
    
    s SQLCODE=..getDeptFindData(period, periodType)
    i SQLCODE'=0 d 
	.d ##class(dhc.pa.udata.uPALogger).Insert("getQMData",period_"^"_periodType,SQLCODE,"")

	s rs=0
	//从指标数据采集表中获取数据进行对应，导入基础数据表
	s rowid=0
	i $D(^DHCCJXPAOUTKPIDATA(0,"PTPeriod",periodType)) d
	.i $D(^DHCCJXPAOUTKPIDATA(0,"PTPeriod",periodType,period)) d
	..f  s rowid=$O(^DHCCJXPAOUTKPIDATA(0,"PTPeriod",periodType,period,rowid)) q:rowid=""  d
	...s CurrRow=$G(^DHCCJXPAOUTKPIDATA(rowid))
	...i CurrRow'="" d
	....s unitType=$P(CurrRow,"^",5) //单位类别:科室、个人
	....s active=$P(CurrRow,"^",11) //数据有效性
	....i (unitType="L")&(active="Y") d
	.....s deptCode=$P(CurrRow,"^",1) //外部科室代码
	.....s kpiCode=$P(CurrRow,"^",6) //外部指标代码
	.....s handFlag=$P(CurrRow,"^",12) //处理标志
	.....;根据指标对照获取该指标所属接口套
	.....s inLocSetDr=..GetKPILocSet(kpiCode)
	.....i (inLocSetDr'=0)&(inLocSetDr'="") d
	......;根据接口套获取对应的绩效单元
	......s jxUnitDr=..GetJXUnitOfOutLoc(inLocSetDr,deptCode)
    ......;i kpiCode="his_mzzsr" b
	......i (jxUnitDr'=0)&(jxUnitDr'="") d
	.......;获取指标来源规则rowid
	.......s okrDr=..GetOutKPIRowid(kpiCode)
	.......i (okrDr'=0)&(okrDr'="") d
	........;对应接口指标
	........s KPIDr=..GetKPIOfOutKPI(okrDr)

	........i (KPIDr'=0)&(KPIDr'="") d
	.........s actValue=$P(CurrRow,"^",10) //指标实际值
	.........;w actValue,!
	.........;s dataState=-1 //数据状态
	.........s dataState=1 //接口导入的数据 直接审核
    .........s auditData=$P($h,",",1)
    .........i handFlag'="Y"  d
	..........&SQL(Insert into dhc_pa_data.JXBaseData(JXBaseData_parRef,JXBaseData_period,JXBaseData_periodType,JXBaseData_KPIDr,JXBaseData_actualValue,JXBaseData_dataState,JXBaseData_auditDate) values(:jxUnitDr,:period,:periodType,:KPIDr,:actValue,:dataState,:auditData))
	..........s handFlag="Y"
	..........&SQL(Update dhc_pa_inter.OutKPIData set OutKPIData_handFlag=:handFlag where OutKPIData_rowid=:rowid)
	..........i SQLCODE'=0 d //2014-12-08 update
	...........d ##class(dhc.pa.udata.uPALogger).Insert("ImportJXBaseData",period_"^"_periodType_"^"_jxUnitDr_"^"_KPIDr_"^"_actValue,SQLCODE,"")
	
	;i rs=0 s rs=..Total(period,periodType,rs)  //计算上级科室的数据
	

	
	q SQLCODE
}

/// Creator：李明忠
/// CreatDate：2011-1-7
/// Description: 导入数据
/// Table：dhc_pa_data.JXBaseData
/// Input：period-考核期间,periodType-期间类型
/// Output：
/// Return：返回执行语句后的SQLCODE
/// Others：w ##class(dhc.pa.udata.uJXBaseData).ImportSum("201301","Q")
ClassMethod ImportSum(period, periodType) As %String
{
	n (period,periodType)
	s Quarter=$e(period,5,6)
	s year=$e(period,1,4)
	i Quarter="01" s year=year-1,Speriod="12",Eperiod="02" 
	i Quarter="02" s Speriod="03",Eperiod="05"
	i Quarter="01" s Speriod="06",Eperiod="08"
	i Quarter="01" s Speriod="09",Eperiod="11" 
	
	s startPeriod=year_Speriod
	s endPeriod=year_Eperiod
	
	
	
	
	s SQLCODE=0
	q:period="" ""
	q:periodType="" ""
	;s ^TMPWY=period_"^"_periodType
		
	s SQLCODE=..DeleteByInter(period, periodType)
	i (SQLCODE'=0)&&(SQLCODE'=100) d //2014-12-08 update
	.d ##class(dhc.pa.udata.uPALogger).Insert("DeleteByInter",period_"^"_periodType,SQLCODE,"")
	q:(SQLCODE'=0)&&(SQLCODE'=100)
	
	
	s SQLCODE=..DeleteByKPIValue(period, periodType) //2014-12-08 update
	i (SQLCODE'=0)&&(SQLCODE'=100) d 
	.d ##class(dhc.pa.udata.uPALogger).Insert("DeleteByKPIValue",period_"^"_periodType,SQLCODE,"")
	q:(SQLCODE'=0)&&(SQLCODE'=100)
	
	s SQLCODE=..ImportKPIValue(period, periodType) //2014-12-08 update
	i SQLCODE'=0 d 
	.d ##class(dhc.pa.udata.uPALogger).Insert("ImportKPIValueAfter",period_"^"_periodType,SQLCODE,"")

	s rs=0
	//从指标数据采集表中获取数据进行对应，导入基础数据表
	s rowid=0
	i $D(^DHCCJXPAOUTKPIDATA(0,"PTPeriod",periodType)) d
	.i $D(^DHCCJXPAOUTKPIDATA(0,"PTPeriod",periodType,period)) d
	..f  s rowid=$O(^DHCCJXPAOUTKPIDATA(0,"PTPeriod",periodType,period,rowid)) q:rowid=""  d
	...s CurrRow=$G(^DHCCJXPAOUTKPIDATA(rowid))
	...i CurrRow'="" d
	....s unitType=$P(CurrRow,"^",5) //单位类别:科室、个人
	....s active=$P(CurrRow,"^",11) //数据有效性
	....i (unitType="L")&(active="Y") d
	.....s deptCode=$P(CurrRow,"^",1) //外部科室代码
	.....s kpiCode=$P(CurrRow,"^",6) //外部指标代码
	.....s handFlag=$P(CurrRow,"^",12) //处理标志
	.....;根据指标对照获取该指标所属接口套
	.....s inLocSetDr=..GetKPILocSet(kpiCode)
	.....i (inLocSetDr'=0)&(inLocSetDr'="") d
	......;根据接口套获取对应的绩效单元
	......s jxUnitDr=..GetJXUnitOfOutLoc(inLocSetDr,deptCode)
    ......;i kpiCode="his_mzzsr" b
	......i (jxUnitDr'=0)&(jxUnitDr'="") d
	.......;获取指标来源规则rowid
	.......s okrDr=..GetOutKPIRowid(kpiCode)
	.......i (okrDr'=0)&(okrDr'="") d
	........;对应接口指标
	........s KPIDr=..GetKPIOfOutKPI(okrDr)

	........i (KPIDr'=0)&(KPIDr'="") d
	.........s actValue=$P(CurrRow,"^",10) //指标实际值
	.........;w actValue,!
	.........;s dataState=-1 //数据状态
	.........s dataState=1 //接口导入的数据 直接审核
    .........s auditData=$P($h,",",1)
    .........i handFlag'="Y"  d
	..........&SQL(Insert into dhc_pa_data.JXBaseData(JXBaseData_parRef,JXBaseData_period,JXBaseData_periodType,JXBaseData_KPIDr,JXBaseData_actualValue,JXBaseData_dataState,JXBaseData_auditDate) values(:jxUnitDr,:period,:periodType,:KPIDr,:actValue,:dataState,:auditData))
	..........s handFlag="Y"
	..........&SQL(Update dhc_pa_inter.OutKPIData set OutKPIData_handFlag=:handFlag where OutKPIData_rowid=:rowid)
	..........i SQLCODE'=0 d //2014-12-08 update
	...........d ##class(dhc.pa.udata.uPALogger).Insert("ImportJXBaseData",period_"^"_periodType_"^"_jxUnitDr_"^"_KPIDr_"^"_actValue,SQLCODE,"")
	
	;i rs=0 s rs=..Total(period,periodType,rs)  //计算上级科室的数据
	

	
	q SQLCODE
}

/// Creator:wang ying
/// CreatDate:2015-4-28
/// Description:删除基础信息中未审核的记录
/// Table:dhc_pa_data.JXBaseData
/// Input:rowid-基本数据记录ID
/// Output: 
/// Return:返回执行删除语句后的SQLCODE
/// Others:w ##class(dhc.pa.udata.uJXBaseData).DeleteByInter("201301","Q")
ClassMethod DeleteByState(period, periodType) As %String
{
	n (period,periodType)
	
	&SQL(delete from dhc_pa_data.JXBaseData where  JXBaseData_period =:period and JXBaseData_periodType=:periodType and JXBaseData_dataState !=1  )
	;&SQL(delete from dhc_pa_data.JXBaseData where JXBaseData_KPIDr  in (select  InterKPI_kpiDr  from   dhc_pa_inter.interkpi ) and JXBaseData_period =:period and JXBaseData_periodType=:periodType   )
	q SQLCODE
}

//=======================================

/// Creator:李明忠
/// CreatDate:2011-1-12
/// Description:计算非末端大科指标数据
/// Table:
/// Input:newPeriod-新的期间;freq-期间类型
/// Output:
/// Return:返回成功或者失败的标志值
/// Others:w ##class(dhc.pa.udata.uJXBaseData).Total("201000","Y",0)
ClassMethod Total(newPeriod, freq, rs) As %String
{
	n (newPeriod,freq,rs)
	
	k ^DHCCJXPATOTALTMP("dhc","pa","okd",$j)
	
	i $D(^DHCCJXPAOUTKPIDATA(0,"PTPeriod",freq,newPeriod)) d
	.s rowid=0
	.f  s rowid=$O(^DHCCJXPAOUTKPIDATA(0,"PTPeriod",freq,newPeriod,rowid)) q:rowid=""  d
	..s Curr=$G(^DHCCJXPAOUTKPIDATA(rowid))
	..i Curr'="" d
	...;取单位类别
	...s unitType=$P(Curr,"^",5)
	...s active=$P(Curr,"^",11)
	...i ((unitType="L")&&(active="Y")) d
	....;取指标
	....s kpiCode=$P(Curr,"^",6)
	....;根据指标确定接口套
	....s interSetDrStr=..getInterSet(kpiCode)
	....i interSetDrStr'="" d
	.....;取指标规则ID
	.....s outKpiRuleRowid=$P(interSetDrStr,"^",2)
	.....;取对应指标
	.....s kpiDr=..getKpiDr(outKpiRuleRowid)
	.....;w kpiCode_"!"_interSetDrStr_"!"_outKpiRuleRowid_"!"_kpiDr,!
	.....i kpiDr'="" d
	......s isTotal=$P(^DHCCJXPAKPIINDEX1(kpiDr),"^",27)
	......;w outKpiRuleRowid_"^"_isTotal,!
	......;取科室
	......s locCode=$P(Curr,"^",1)
	......;取对应科室
	......s jxUnitDr=..getJXUnitDr($P(interSetDrStr,"^",1),locCode)
	......i jxUnitDr'=0 && jxUnitDr'="" d
	.......;取指标值
	.......s actValue=$P(Curr,"^",10)
	.......;取末端标志
	.......s end=$P(^DHCCJXPAJXUNIT(jxUnitDr),"^",13)
	.......i end="Y" d //找父节点
	........s parent=$P(^DHCCJXPAJXUNIT(jxUnitDr),"^",11)
	........i isTotal="Y" d //表示汇总
	.........i $D(^DHCCJXPATOTALTMP("dhc","pa","okd",$j,newPeriod,freq,parent,kpiDr)) d
	..........s ^DHCCJXPATOTALTMP("dhc","pa","okd",$j,newPeriod,freq,parent,kpiDr)=^DHCCJXPATOTALTMP("dhc","pa","okd",$j,newPeriod,freq,parent,kpiDr)+actValue
	.........e  d
	..........s ^DHCCJXPATOTALTMP("dhc","pa","okd",$j,newPeriod,freq,parent,kpiDr)=actValue
	........e  d
	.........s ^DHCCJXPATOTALTMP("dhc","pa","okd",$j,newPeriod,freq,parent,kpiDr)=actValue
	........s handFlag="Y"
	........&SQL(update dhc_pa_inter.outkpidata set outKPiData_handFlag=:handFlag where outkpidata_rowid=:rowid)
	
	s dataState=-1
	
	i $D(^DHCCJXPATOTALTMP("dhc","pa","okd",$j,newPeriod,freq)) d
	.s parent=0
	.f  s parent=$O(^DHCCJXPATOTALTMP("dhc","pa","okd",$j,newPeriod,freq,parent)) q:parent=""  d
	..s kpiDr=0
	..f  s kpiDr=$O(^DHCCJXPATOTALTMP("dhc","pa","okd",$j,newPeriod,freq,parent,kpiDr)) q:kpiDr=""  d
	...s actValue=^DHCCJXPATOTALTMP("dhc","pa","okd",$j,newPeriod,freq,parent,kpiDr)
	...&SQL(insert into dhc_pa_data.jxbasedata(JXBaseData_parRef,JXBaseData_period,JXBaseData_periodType,JXBaseData_KPIDr,JXBaseData_actualValue,JXBaseData_dataState) values(:parent,:newPeriod,:freq,:kpiDr,:actValue,:dataState))
	...i SQLCODE'=0 s rs=1
	
	
	k ^DHCCJXPATOTALTMP("dhc","pa","okd",$j)
	
	q rs
}

/// w ##class(dhc.pa.udata.uJXBaseData).getKpiDr(7)
ClassMethod getKpiDr(outKpiRuleRowid) As %String
{
	n (outKpiRuleRowid)
	s kpiDr=0
	
	q:outKpiRuleRowid="" kpiDr
	
	i $D(^DHCCJXPAINTERKPI(0,"OutKPI",outKpiRuleRowid)) d
	.s kpiDr=$O(^DHCCJXPAINTERKPI(0,"OutKPI",outKpiRuleRowid,kpiDr))
	
	q kpiDr
}

ClassMethod getInterSet(kpiCode) As %String
{
	n (kpiCode)
	
	s interSetDr=0,rowid=0
	
	q:kpiCode="" interSetDr_"^"_rowid
	
	i $D(^DHCCJXPAOUTKPIRULE(0,"OutKpiCode",kpiCode)) d
	.s rowid=$O(^DHCCJXPAOUTKPIRULE(0,"OutKpiCode",kpiCode,rowid))
	.s interSetDr=$P(^DHCCJXPAOUTKPIRULE(rowid),"^",3)
	
	q interSetDr_"^"_rowid
}

ClassMethod getJXUnitDr(interSetDr, locCode) As %String
{
	n (interSetDr,locCode)
	
	q:locCode="" 0
	q:interSetDr="" 0
	
	s jxUnitDr=0
	
	i $D(^DHCCJXPAINTERLOC(0,"LocSetLoc",interSetDr,locCode)) d
	.s jxUnitDr=$O(^DHCCJXPAINTERLOC(0,"LocSetLoc",interSetDr,locCode,jxUnitDr))
	
	q jxUnitDr
}

/// Creator:李明忠
/// CreatDate:2011-1-12
/// Description:计算非末端大科指标数据
/// Table:dhc_pa_data.JXBaseData
/// Input:newPeriod-新的期间;freq-期间类型
/// Output:
/// Return:返回成功或者失败的标志值
/// Others:w ##class(dhc.pa.udata.uCalculator).TotalKPI("201001","M")
ClassMethod TotalKPI(newPeriod, freq, BigUnit, kpiStr, SmollUnit) As %String
{
	n (newPeriod,freq,BigUnit,kpiStr,SmollUnit)
	
	s KPILen=$L(kpiStr,"^")
	s rs=0
	
	f i=1:1:KPILen d
	.s dataState=1
	.s KPIDr=$P(kpiStr,"^",i)
	.i KPIDr=99 w KPIDr,!
	.s isTotal=$P(^DHCCJXPAKPIINDEX1(KPIDr),"^",27)
	.s total=0
	.i isTotal="Y" d //需要汇总
	..;w BigUnit_"^"_KPIDr,!
	..s total= ..QIUHE(newPeriod,freq,BigUnit,KPIDr,SmollUnit)
	.e  d //直接赋值
	..s total= ..FUZHI(newPeriod,freq,BigUnit,KPIDr,SmollUnit)
	.&SQL(Insert into dhc_pa_data.JXBaseData(JXBaseData_parRef,JXBaseData_period,JXBaseData_periodType,JXBaseData_KPIDr,JXBaseData_actualValue,JXBaseData_dataState) values(:BigUnit,:newPeriod,:freq,:KPIDr,:total,:dataState))
	.i SQLCODE'=0 s rs=1
	
	q rs
}

ClassMethod QIUHE(newPeriod, freq, BigUnit, kpiDr, SmollUnit) As %String
{
	n (newPeriod,freq,BigUnit,kpiDr,SmollUnit)
	
	s SmollLen=$L(SmollUnit,"$")
	s total=0
	
	f i=1:1:SmollLen d
	.s Smoll=$P(SmollUnit,"$",i)
	.s actValue=..f(newPeriod,freq,BigUnit,kpiDr,Smoll)
	.s total=total+actValue
	
	q total
}

ClassMethod FUZHI(newPeriod, freq, BigUnit, kpiDr, SmollUnit) As %String
{
	n (newPeriod,freq,BigUnit,kpiDr,SmollUnit)
	
	s SmollLen=$L(SmollUnit,"$")
	s actValue=0
	
	f i=1:1:SmollLen d
	.s Smoll=$P(SmollUnit,"$",i)
	.s actValue=..f(newPeriod,freq,BigUnit,kpiDr,Smoll)
	
	q actValue
}

/// Others:w ##class(dhc.pa.udata.uJXBaseData).f("201000","Y",65,)
/// Others:w ##class(dhc.pa.udata.uJXBaseData).f("201000","Y",65,"",16)
/// Others:w ##class(dhc.pa.udata.uJXBaseData).f("201000","Y",65,,17)
ClassMethod f(newPeriod, freq, BigUnit, kpiDr, Smoll) As %String
{
	n (newPeriod,freq,BigUnit,kpiDr,Smoll)
	
	q:newPeriod="" 0
	q:freq="" 0
	q:BigUnit="" 0
	//q:kpiDr="" 0
	q:Smoll="" 0
	
	s childSub=0,actValue=0
	i $D(^DHCCJXPAJXUNIT(0,"JXBDPeriodKPI",Smoll)) d
	.i $D(^DHCCJXPAJXUNIT(0,"JXBDPeriodKPI",Smoll,newPeriod,freq,kpiDr)) d
	..f  s childSub=$O(^DHCCJXPAJXUNIT(0,"JXBDPeriodKPI",Smoll,newPeriod,freq,kpiDr,childSub)) q:childSub=""  d
	...s CurrRow=$G(^DHCCJXPAJXUNIT(Smoll,"JXBaseData",childSub))
	...i CurrRow'="" d
	....s actValue=$P(CurrRow,"^",4)
	
	q actValue
}

/// Creator:李明忠
/// CreatDate:2011-1-12
/// Description:获取科室信息
/// Table:dhc_pa_data.JXUnit
/// Input:
/// Output:
/// Return:返回科室信息字符串值
/// Others:w ##class(dhc.pa.udata.uCalculator).GetJXUnitInfo()
ClassMethod GetJXUnitInfo() As %String
{
	s rowid=0,count=0,jxUnitInfo=""
	f  s rowid=$O(^DHCCJXPAJXUNIT(rowid)) q:rowid=""  d
	.s CurrRow=$G(^DHCCJXPAJXUNIT(rowid))
	.i CurrRow'="" d
	..s appSysDr=$P(^DHCCJXPAJXUNIT(rowid),"^",1)
	..i appSysDr=2 d
	...s parent=$P(^DHCCJXPAJXUNIT(rowid),"^",11)
	...s end=$P(^DHCCJXPAJXUNIT(rowid),"^",13)
	...i (parent'=0)&&(parent'="")&&(end'="Y") d //选择非末端科室
	....s info=..GetChildNode(rowid)
	....i jxUnitInfo="" d
	.....s jxUnitInfo=info
	....e  d
	.....s jxUnitInfo=jxUnitInfo_"^"_info
	
	q jxUnitInfo
}

/// Creator:李明忠
/// CreatDate:2011-1-12
/// Description:获取科室信息
/// Table:dhc_pa_data.JXUnit
/// Input:Parent-父ID
/// Output:
/// Return:返回父ID及其子节点
/// Others:w ##class(dhc.pa.udata.uCalculator).GetChildNode(Parent)
ClassMethod GetChildNode(parent) As %String
{
	n (parent)
	
	s childNode=0,infoStr=parent,count=0
	f  s childNode=$O(^DHCCJXPAJXUNIT(0,"Parent",parent,childNode)) q:childNode=""  d
	.s count=count+1
	.i count>1 s infoStr=infoStr_"$"_childNode
	.e  s infoStr=infoStr_"!"_childNode
	
	q infoStr
}

/// Creator:李明忠
/// CreatDate:2011-1-12
/// Description:获取科室方案信息
/// Table:dhc_pa_data.JXUnit
/// Input:BigUnit-大科ID
/// Output:
/// Return:返回方案
/// Others:w ##class(dhc.pa.udata.uCalculator).GetSchemOfUnit(56)
ClassMethod GetSchemOfUnit(BigUnit) As %String
{
	n (BigUnit)
	
	s schemDr=""
	q $O(^DHCCJXPAJXUNIT(0,"UnitSchemSchem",BigUnit,schemDr))
}

/// Creator:李明忠
/// CreatDate:2010-9-2
/// Description:查询绩效考核方案下的指标Dr字符串
/// Table:dhc_pa_data.UnitSchem
/// Input:schemDr-绩效方案Dr
/// Output:
/// Return:返回绩效考核方案下的指标Dr字符串
/// Others:w ##class(dhc.pa.udata.uCalculator).GetKPIOfSchem("1||1")
ClassMethod GetKPIOfSchem(schemDr) As %String
{
	n (schemDr)
	
	s KPIDrStr=""
	q:schemDr="" KPIDrStr
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT KPIIndex1_rowid FROM dhc_pa_data.KPIIndex1 where %ID>0 and KPIIndex1_isKPI='Y' and KPIIndex1_isEnd='Y'and EXISTS (SELECT SchemDetail_KPIDr FROM dhc_pa_data.SchemDetail where dhc_pa_data.KPIIndex1.KPIIndex1_rowid =dhc_pa_data.SchemDetail.SchemDetail_KPIDr and SchemDetail_isTarget=2 and SchemDetail_parRef='"_schemDr_"')"
	
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

//=======================================

/// Creator：李明忠
/// CreatDate：2011-1-7
/// Description: 获取外部指标rowid
/// Table：dhc_pa_inter.OutKpiRule
/// Input：kpiCode:外部指标代码
/// Output：
/// Return：外部指标rowid
/// Others：w ##class(dhc.pa.udata.uJXBaseData).GetOutKPIRowid("yfsr")
ClassMethod GetOutKPIRowid(kpiCode) As %String
{
	n (kpiCode)
	
	s rowid=0
	i $D(^DHCCJXPAOUTKPIRULE(0,"OutKpiCode",kpiCode)) d
	.s rowid=$O(^DHCCJXPAOUTKPIRULE(0,"OutKpiCode",kpiCode,rowid))
	
	q rowid
}

/// Creator：李明忠
/// CreatDate：2011-1-7
/// Description: 获取对应的指标
/// Table：dhc_pa_inter.InterKPI
/// Input：okrDr:外部指标,inLocSetDr-接口套
/// Output：
/// Return：对应的指标
/// Others：w ##class(dhc.pa.udata.uJXBaseData).GetKPIOfOutKPI(3)
ClassMethod GetKPIOfOutKPI(okrDr) As %String
{
	n (okrDr)
		
	s KPIDr=""
	i $D(^DHCCJXPAINTERKPI(0,"OutKPI",okrDr)) d
	.s KPIDr=$O(^DHCCJXPAINTERKPI(0,"OutKPI",okrDr,KPIDr))
	
	
	q KPIDr
}

/// Creator：李明忠
/// CreatDate：2011-1-7
/// Description: 获取对应的绩效单元
/// Table：dhc_pa_inter.InterLoc
/// Input：deptCode:外部科室代码,inLocSetDr-接口套
/// Output：
/// Return：对应的绩效单元
/// Others：w ##class(dhc.pa.udata.uJXBaseData).GetJXUnitOfOutLoc(1,"his_52")
ClassMethod GetJXUnitOfOutLoc(inLocSetDr, deptCode) As %String
{
	n (inLocSetDr,deptCode)
		
	s jxUintDr=0
	i $D(^DHCCJXPAINTERLOC(0,"LocSetLoc",inLocSetDr)) d
	.i $D(^DHCCJXPAINTERLOC(0,"LocSetLoc",inLocSetDr,deptCode)) d
	..s jxUintDr=$O(^DHCCJXPAINTERLOC(0,"LocSetLoc",inLocSetDr,deptCode,jxUintDr))
	
	q jxUintDr
}

/// Creator：李明忠
/// CreatDate：2011-1-7
/// Description: 获取外部指标所属接口套
/// Table：dhc_pa_inter.OutKpiRule
/// Input：kpiCode:外部指标代码
/// Output：
/// Return：指标所属接口套
/// Others：w ##class(dhc.pa.udata.uJXBaseData).GetKPILocSet("his_mzzsr")
ClassMethod GetKPILocSet(kpiCode) As %String
{
	n (kpiCode)
	
	s rowid=0,inLocSetDr=0
	i $D(^DHCCJXPAOUTKPIRULE(0,"OutKpiCode",kpiCode)) d
	.s rowid=$O(^DHCCJXPAOUTKPIRULE(0,"OutKpiCode",kpiCode,rowid))
	
	i rowid>0 d
	.s inLocSetDr=$P(^DHCCJXPAOUTKPIRULE(rowid),"^",3)
	
	q inLocSetDr
}

/// Creator：李明忠
/// CreatDate：2010-8-4
/// Description: 获取绩效单元
/// Table：dhc_pa_data.JXUnit
/// Input：start:开始记录位置;limit:单页记录条数;str-模糊查询字符串;userCode-用户代码
/// Output：
/// Return：有效绩效单元字符串
/// Others：w ##class(dhc.pa.udata.uJXBaseData).GetJXUnit(0,10,"311","fhq")
ClassMethod GetJXUnit(start, limit, str, userCode) As %String
{
	n (start, limit, str, userCode)
	
	q:userCode="" "NoData"
	
	s userCode=$$ALPHAUP^SSUTIL4(userCode)
	//根据用户Code查找用户ID
	s userId=0
	s userId=$O(^SSU("SSUSR",0,"SSUSR_Initials",userCode,userId))
	q:userId="" "NoData"
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select JXUnitAudit_jxUnitDr,JXUnit_shortcut from dhc_pa_data.JXUnitAudit,dhc_pa_data.jxUnit where JXUnitAudit_rowid>0 and JXUnitAudit_userDr="_userId_" and JXUnitAudit_jxUnitDr=JXUnit_rowid and JXUnit_appSysDr=2"
	s whereStr=""
	i str'="" s whereStr=" and JXUnit_shortcut LIKE '%"_str_"%'"
	
	s sqlStr=sqlStr_whereStr
	d result.Prepare(sqlStr)
	d result.Execute()

	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	While(result.Next()){
		s jxUnitDr = result.Data("JXUnitAudit_jxUnitDr")
		s jxUnitShortCut = result.Data("JXUnit_shortcut")
		s tmp=jxUnitDr_"^"_jxUnitShortCut
		s count = count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("jxUnitDr^jxUnitShortCut",count)
 	k json
	q resultString
}

/// Creator：李明忠
/// CreatDate：2010-12-23
/// Description: 获取指标
/// Table：dhc_pa_data.KPIAudit
/// Input：start:开始记录位置;limit:单页记录条数;str-模糊查询字符串;userCode-用户代码
/// Output：
/// Return：有指标字符串
/// Others：w ##class(dhc.pa.udata.uJXBaseData).GetKPI(0,10,"","fhq")
ClassMethod GetKPI(start, limit, str, userCode) As %String
{
	n (start, limit, str, userCode)
	
	q:userCode="" "NoData"
	
	s userCode=$$ALPHAUP^SSUTIL4(userCode)
	//根据用户Code查找用户ID
	s userId=0
	s userId=$O(^SSU("SSUSR",0,"SSUSR_Initials",userCode,userId))
	q:userId="" "NoData"
	
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select KPIAudit_KPIDr,KPIIndex1_shortcut from dhc_pa_data.KPIAudit,dhc_pa_data.KPIIndex1 where KPIAudit_rowid>0 and KPIAudit_userDr="_userId_" and KPIAudit_KPIDr=KPIIndex1_rowid"
	s whereStr=""
	i str'="" s whereStr=" and KPIIndex1_shortcut LIKE '%"_str_"%'"
	
	s sqlStr=sqlStr_whereStr
	d result.Prepare(sqlStr)
	d result.Execute()

	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	While(result.Next()){
		s KPIDr = result.Data("KPIAudit_KPIDr")
		s shortCut=result.Data("KPIIndex1_shortcut")
		s tmp=KPIDr_"^"_shortCut
		s count = count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("KPIDr^shortCut",count)
 	k json
	q resultString
}

/// Creator: LY
/// CreatDate: 2013-02-24
/// Description: 审核记录
/// Table: dhc.pa.data.JXBaseData
/// Input：rowid-数据行号
/// Output: 
/// Return: 返回执行更新语句后的SQLCODE
/// Others: w ##class(dhc.pa.udata.uJXBaseData).Aduit("201602","Q","demo")
ClassMethod Aduit(period, periodType, userCode) As %String
{
	
	;n (period ,periodType,userCode,rowid)
	n (period ,periodType,userCode)
	q:userCode="" "NoData"
	
	s userCode=$$ALPHAUP^SSUTIL4(userCode)
	//根据用户Code查找用户ID
	s userId=0
	s userId=$O(^SSU("SSUSR",0,"SSUSR_Initials",userCode,userId))
	q:userId="" "NoData"
	s SQLCODE=0
	s kpiDr=""
	s auditData=$P($h,",",1)
	
	i userId'="" d
	.s state =0
	.f  s kpiDr=$o(^DHCCJXPAKPIAUDIT(0,"User",userId,kpiDr)) q:kpiDr=""  d
	..&SQL(Update dhc_pa_data.JXBaseData set JXBaseData_auditDate=:auditData,JXBaseData_auditUserDr=:userId,JXBaseData_dataState=1  WHERE JXBaseData_period=:period and JXBaseData_periodType=:periodType and  JXBaseData_KPIDr=:kpiDr and JXBaseData_dataState='-1' )
	i SQLCODE=100 s SQLCODE=0
	;&SQL(Update dhc_pa_data.JXBaseData set JXBaseData_auditDate=:auditData,JXBaseData_auditUserDr=:userId,JXBaseData_dataState=1  WHERE  JXBaseData_rowid=:rowid )
	q SQLCODE
}

/// Creator：wang ying
/// CreatDate：2011-8-29
/// Description: 导入数据-通过月份导入季度数据
/// Table：dhc_pa_data.JXBaseData
/// Input：period-考核期间,periodType-期间类型
/// Output：
/// Return：返回执行语句后的SQLCODE
/// Others：w ##class(dhc.pa.udata.uJXBaseData).Import2("201001","Q")
ClassMethod Import2(period, periodType) As %String
{
	n (period,periodType)
	
	k ^TMPDHCCJXPAJXBASEDATE(0,"data")
	q:period="" ""
	q:periodType="" ""
	s month=$e(period,5,$l(period))
	;w month,!
	i periodType="Q" d
	.i month="01" d
	..s startperiod=$e(period,1,4)-1_"12"
	..;s startperiod=$e(period,1,4)_"00"
	..s endperiod=$e(period,1,4)_"02"
	.i month="02" d
	..s startperiod=$e(period,1,4)_"03"
	..s endperiod=$e(period,1,4)_"05"
	.i month="03" d
	..s startperiod=$e(period,1,4)_"06"
	..s endperiod=$e(period,1,4)_"08"
	.i month="04" d
	..s startperiod=$e(period,1,4)_"09"
	..s endperiod=$e(period,1,4)_"11"
	
	TSTART
	s rs=0
	
	//从指标数据采集表中获取数据进行对应，导入基础数据表
	s rowid=0
	i $D(^DHCCJXPAOUTKPIDATA(0,"PTPeriod","M")) d
	.f  s startperiod=$o(^DHCCJXPAOUTKPIDATA(0,"PTPeriod","M",startperiod)) q:(startperiod=endperiod)||(startperiod="")  d
	..f  s rowid=$O(^DHCCJXPAOUTKPIDATA(0,"PTPeriod","M",startperiod,rowid)) q:rowid=""  d
	...s CurrRow=$G(^DHCCJXPAOUTKPIDATA(rowid))
	...i CurrRow'="" d
	....s unitType=$P(CurrRow,"^",5) //单位类别:科室、个人
	....s active=$P(CurrRow,"^",11) //数据有效性
	....i (unitType="L")&(active="Y") d
	.....s deptCode=$P(CurrRow,"^",1) //外部科室代码
	.....s kpiCode=$P(CurrRow,"^",6) //外部指标代码
	.....;根据指标对照获取该指标所属接口套
	.....s inLocSetDr=..GetKPILocSet(kpiCode)
	.....i (inLocSetDr'=0)&(inLocSetDr'="") d
	......;根据接口套获取对应的绩效单元
	......s jxUnitDr=..GetJXUnitOfOutLoc(inLocSetDr,deptCode)
	......i (jxUnitDr'=0)&(jxUnitDr'="") d
	.......;获取指标来源规则rowid
	.......s okrDr=..GetOutKPIRowid(kpiCode)
	.......i (okrDr'=0)&(okrDr'="") d
	........;对应接口指标
	........s KPIDr=..GetKPIOfOutKPI(okrDr)
	........i (KPIDr'=0)&(KPIDr'="") d
	.........s actValue=$P(CurrRow,"^",10) //指标实际值
	.........i '$d(^DHCCJXPAKPIPRO(0,"KPI",KPIDr)) d
	..........i $d(^TMPDHCCJXPAJXBASEDATE(0,"data",$j,jxUnitDr,KPIDr))  d
	...........s ^TMPDHCCJXPAJXBASEDATE(0,"data",$j,jxUnitDr,KPIDr)=^TMPDHCCJXPAJXBASEDATE(0,"data",$j,jxUnitDr,KPIDr)+actValue
	..........e  d 
	...........s ^TMPDHCCJXPAJXBASEDATE(0,"data",$j,jxUnitDr,KPIDr)=actValue
	..........s handFlag="Y"
	..........&SQL(Update dhc_pa_inter.OutKPIData set OutKPIData_handFlag=:handFlag where OutKPIData_rowid=:rowid)
	..........i SQLCODE'=0 d
	...........s rs=1
	.........e  d
	..........i $d(^TMPDHCCJXPAJXBASEDATE(0,"data",$j,jxUnitDr,KPIDr))  d
	...........s ^TMPDHCCJXPAJXBASEDATE(0,"data",$j,jxUnitDr,KPIDr)=$p(^TMPDHCCJXPAJXBASEDATE(0,"data",$j,jxUnitDr,KPIDr),"^",1)+actValue_"^"_($p(^TMPDHCCJXPAJXBASEDATE(0,"data",$j,jxUnitDr,KPIDr),"^",2)+1)
	..........e  d
	...........s ^TMPDHCCJXPAJXBASEDATE(0,"data",$j,jxUnitDr,KPIDr)=actValue_"^1"
	..........s handFlag="Y"
	...........&SQL(Update dhc_pa_inter.OutKPIData set OutKPIData_handFlag=:handFlag where OutKPIData_rowid=:rowid)
	..........i SQLCODE'=0 d
	...........s rs=1
	
	i rs=0 s rs=..Insert2(period, periodType)
	
	i rs'=0 d
	.TRollBack
	e  d
	.TCOMMIT
	k ^TMPDHCCJXPAJXBASEDATE(0,"data")
	q rs
}

/// Creator：wang ying
/// CreatDate：2011-8-29
/// Description: 插入要导入数据
/// Table：dhc_pa_data.JXBaseData
/// Input：period-考核期间,periodType-期间类型
/// Output：
/// Return：返回执行语句后的SQLCODE
/// Others：w ##class(dhc.pa.udata.uJXBaseData).Import2("201001","Q")
ClassMethod Insert2(period, periodType) As %String
{
	n (period, periodType)
	s rs=0
	s jxUnitDr=""
	f  s jxUnitDr=$o(^TMPDHCCJXPAJXBASEDATE(0,"data",$j,jxUnitDr)) q:jxUnitDr=""  d
	.s KPIDr=""
	.f  s KPIDr=$o(^TMPDHCCJXPAJXBASEDATE(0,"data",$j,jxUnitDr,KPIDr)) q:KPIDr=""  d
	..i $d(^DHCCJXPAKPIPRO(0,"KPI",KPIDr)) d
	...s actValue=$p(^TMPDHCCJXPAJXBASEDATE(0,"data",$j,jxUnitDr,KPIDr),"^",1)/$p(^TMPDHCCJXPAJXBASEDATE(0,"data",$j,jxUnitDr,KPIDr),"^",2)
	..e  s actValue=^TMPDHCCJXPAJXBASEDATE(0,"data",$j,jxUnitDr,KPIDr)
    ..s dataState=-1 //数据状态
	..&SQL(Insert into dhc_pa_data.JXBaseData(JXBaseData_parRef,JXBaseData_period,JXBaseData_periodType,JXBaseData_KPIDr,JXBaseData_actualValue,JXBaseData_dataState) values(:jxUnitDr,:period,:periodType,:KPIDr,:actValue,:dataState))
	..i SQLCODE'=0 d
	...s rs=1
	
	i rs=0 s rs=..Total(period,periodType,rs)
	
	q rs
}

/// Creator:刘洋
/// CreatDate:2012-3-12
/// Description:取消审核
/// Table:dhc_pa_data.JXBaseData
/// Input:rowid-基本数据记录ID
/// Output: 
/// Return:返回执行删除语句后的SQLCODE
/// Others:w ##class(dhc.pa.udata.uJXBaseData).Delete(4)
ClassMethod CancelAduit(rowid) As %String
{
	n (rowid)
	
	&SQL(UPDATE   dhc_pa_data.JXBaseData  set JXBaseData_auditDate=NULL,JXBaseData_auditUserDr=NULL, JXBaseData_dataState=-1   where JXBaseData_rowid=:rowid)
	q SQLCODE
}

/// Creator:刘洋
/// CreatDate:2012-3-12
/// Description:修改实际值
/// Table:dhc_pa_data.JXBaseData
/// Input:rowid-基本数据记录ID
/// Output: 
/// Return:返回执行删除语句后的SQLCODE
/// Others:w ##class(dhc.pa.udata.uJXBaseData).UpdateActValue(4)
ClassMethod UpdateActValue(date) As %String
{
	n (data)
	
	q:data="" "dataEmpt"      				//空数据dataEmpt
	k PLIST
	
	s rowid=$p(data,"^",1)				
	
	s actualValue=$p(data,"^",2)		//实际值
	s desc=$p(data,"^",3)				//描述

	
	&SQL(UPDATE dhc_pa_data.JXBaseData  set JXBaseData_actualValue=:actualValue,JXBaseData_desc=:desc   where JXBaseData_rowid=:rowid)
	q SQLCODE
}

/// Creator：LY
/// CreatDate：2013-06-23
/// Description: 手工录入指标初始化
/// Table：dhc_pa_data.KPIAudit
/// Input：start:开始记录位置;limit:单页记录条数;str-模糊查询字符串;userCode-用户代码
/// Output：
/// Return：有指标字符串
/// Others：w ##class(dhc.pa.udata.uJXBaseData).ManualEntryInit("201301","M","1")
ClassMethod ManualEntryInit(period, periodType, userID) As %String
{
	n (period, periodType, userID)
	
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select UnitSchem_parRef,KPIAudit_KPIDr,KPIAudit_KPIDr->KPIIndex1_colTypeDr  from dhc_pa_data.KPIAudit,dhc_pa_data.SchemDetail,dhc_pa_data.UnitSchem where KPIAudit_rowid>0 and KPIAudit_userDr="_userID_" and KPIAudit_KPIDr=SchemDetail_KPIDr and SchemDetail_parRef=UnitSchem_schemDr  "
	
	
	s sqlStr=sqlStr
	d result.Prepare(sqlStr)
	d result.Execute()
	;W sqlStr,!
	s count = 0
	s resultString = ""

	s json = ##class(dhc.pa.comm.JsonObj).%New()
	While(result.Next()){
		s KPIDr = result.Data("KPIAudit_KPIDr")
		s unitDr=result.Data("UnitSchem_parRef")
		s colTypeDr=result.Data("KPIIndex1_colTypeDr")
		s rowID=..GetRowIdOfKUP(KPIDr,unitDr,period, periodType)
		;w rowID,!
		i (rowID=0)&&(colTypeDr'=2)&&(colTypeDr'=4) d
		.&SQL(insert into  dhc_pa_data.JXBaseData  (JXBaseData_parRef,JXBaseData_period,JXBaseData_periodType,JXBaseData_KPIDr,JXBaseData_dataState) values(:unitDr,:period,:periodType,:KPIDr,-1))
		
		
		
	}
	d result.Close()
	q SQLCODE
}

/// Creator:LY
/// CreatDate:2013-06-23
/// Description:根据条件查询记录
/// Table:dhc_pa_data.JXBaseData
/// Input:
/// Output:
/// Return:返回记录ID
/// Others:w ##class(dhc.pa.udata.uJXBaseData).GetRowIdOfKUP("1","1","201301","M")
ClassMethod GetRowIdOfKUP(kpiDr, unitDr, period, periodType) As %String
{
	n (kpiDr,unitDr,period,periodType)
	
	
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select JXBaseData_rowid from   dhc_pa_data.JXBaseData where  JXBaseData_parRef="_unitDr_" and JXBaseData_period="_period_" and  JXBaseData_periodType='"_periodType_"' and JXBaseData_KPIDr="_kpiDr_" "
	;w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()
	s rowid=0
	While(result.Next()){
		
		
		s rowid = result.Data("JXBaseData_rowid")
		
	}
	
	q rowid
}

/// Creator:刘洋
/// CreatDate:2012-3-12
/// Description:修改数据
/// Table:dhc_pa_data.JXBaseData
/// Input:rowid-基本数据记录ID
/// Output: 
/// Return:返回执行删除语句后的SQLCODE
/// Others:w ##class(dhc.pa.udata.uJXBaseData).Update(4)
ClassMethod Update(rowid, aValue) As %String
{
	n (rowid,aValue)
	

	
	&SQL(UPDATE dhc_pa_data.JXBaseData  set JXBaseData_actualValue=:aValue   where JXBaseData_rowid=:rowid)
	q SQLCODE
}

/// Creator：wang ying
/// CreatDate：2015-5-13
/// Description: 导入数据-查JXBaseData通过月份生成季度、半年、年数据
/// Table：dhc_pa_data.JXBaseData
/// Input：period-考核期间,periodType-期间类型
/// Output：
/// Return：返回执行语句后的SQLCODE
/// Others：w ##class(dhc.pa.udata.uJXBaseData).InitSum("201402","Q",2)
ClassMethod InitSum(period, periodType, userId) As %String
{
	n (period,periodType,userId)
	
	q:period="" ""
	q:periodType="" ""
	s month=$e(period,5,$l(period))
	s rs=0
	;w month,!
	
	q:periodType="M" "re" 
	i periodType="Q" d
	.i month="01" d
	..s startperiod=$e(period,1,4)-1_"12"
	..;s startperiod=$e(period,1,4)_"00"
	..s endperiod=$e(period,1,4)_"02"
	.i month="02" d
	..s startperiod=$e(period,1,4)_"03"
	..s endperiod=$e(period,1,4)_"05"
	.i month="03" d
	..s startperiod=$e(period,1,4)_"06"
	..s endperiod=$e(period,1,4)_"08"
	.i month="04" d
	..s startperiod=$e(period,1,4)_"09"
	..s endperiod=$e(period,1,4)_"11"
	i periodType="H" d
	.i month="01" d
	..s startperiod=$e(period,1,4)_"01"
	..s endperiod=$e(period,1,4)_"06"
	.i month="02" d
	..s startperiod=$e(period,1,4)_"07"
	..s endperiod=$e(period,1,4)_"12"
	i periodType="Y" d
	.i month="00" d
	..s startperiod=$e(period,1,4)_"01"
	..s endperiod=$e(period,1,4)_"12"
	
	
	//从基础信息表中获取数据进行期间对应，生成新期间的数据导入基础数据表
	//月份数据生成季度数据
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT JXBaseData_parRef,JXBaseData_KPIDr,sum(JXBaseData_actualValue) as actualValue" 
              _" FROM dhc_pa_data.JXBaseData WHERE JXBaseData_periodType='M' AND JXBaseData_dataState=1" 
              _" AND JXBaseData_period>='"_startperiod_"' AND JXBaseData_period<='"_endperiod_"'"
              _" GROUP BY JXBaseData_parRef,JXBaseData_KPIDr"
	;w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()
	s rowid=0,rs=0
	While(result.Next()){
		s sqlcode=0,actValue=0,calUnitName="",periodNum=1
		s jxunitDr= result.Data("JXBaseData_parRef")
		i $d(^DHCCJXPAJXUNITAUDIT(0,"JXUnitUser",jxunitDr,userId)) d
		.s KPIDr = result.Data("JXBaseData_KPIDr")
		.i $d(^DHCCJXPAKPIAUDIT(0,"User",userId,KPIDr)) d
		..s actValue = result.Data("actualValue")
		..i $d(^DHCCJXPAKPIINDEX1(KPIDr)) d
		...s caunit=$p($g(^DHCCJXPAKPIINDEX1(KPIDr)),"^",8)
		...i caunit'="" d
		....q:'$d(^DHCCJXPACALUNIT(caunit))
		....s calUnitName=$p($g(^DHCCJXPACALUNIT(caunit)),"^",2)
		....i calUnitName="百分比" d
		.....&sql(SELECT count(JXBaseData_period) into :periodNum FROM dhc_pa_data.JXBaseData WHERE JXBaseData_period>=:startperiod AND JXBaseData_period<=:endperiod AND JXBaseData_periodType='M' AND JXBaseData_KPIDr=:KPIDr AND JXBaseData_parRef=:jxunitDr)
		.....s actValue=actValue/periodNum
		..i $d(^DHCCJXPAJXUNIT(0,"JXBDPeriodKPI",jxunitDr,period,periodType,KPIDr)) d
		...s child=0
		...s child=$o(^DHCCJXPAJXUNIT(0,"JXBDPeriodKPI",jxunitDr,period,periodType,KPIDr,child)) 
		...s rowid=jxunitDr_"||"_child
		...s sqlcode=..Update(rowid,actValue)
		...i sqlcode'=0 d
		....s rs=sqlcode
		....d ##class(dhc.pa.udata.uPALogger).Insert("InitSumUpdate",jxunitDr_"^"_KPIDr_"^"_period_"^"_periodType_"^"_actValue,sqlcode,"")
		..e  d
		...;3^2012^M^17^1212^-1^"
		...s data=jxunitDr_"^"_period_"^"_periodType_"^"_KPIDr_"^"_actValue_"^-1^"
		...s sqlcode=..Insert(data)
		...i sqlcode'=0 d
		....s rs=sqlcode
		....d ##class(dhc.pa.udata.uPALogger).Insert("InitSumInsert",data,sqlcode,"")

	}
	
	q rs
}

/// Creator：wang ying
/// CreatDate：2015-9-8
/// Description: 取自查系统数据
/// Table：dhc_pa_data.JXBaseData
/// Input：period-考核期间,periodType-期间类型
/// Output：
/// Return：返回执行语句后的SQLCODE
/// Others：w ##class(dhc.pa.udata.uJXBaseData).getDeptFindData("201501","M")
ClassMethod getDeptFindData(period, periodType) As %String
{
	   
	   n (period, periodType)
	   
	   s sqlStr="SELECT UDR_jxUnitDr, UDR_DschemDr,UDR_DschemDr->DSC_name , InterKPI_kpiDr FROM dhc_pa_data.UnitDeptResult,dhc_pa_inter.InterKPI"
				_" WHERE UDR_period='"_period_"'" 
				_" AND UDR_auditState=0"
				_" AND UDR_DschemDr->DSC_code=InterKPI_okrDr->OutKpiRule_outKpiCode" 
				_" AND InterKPI_okrDr->OutKpiRule_inLocSetDr->InterLocSet_code='dept'"
				
	
		
		s result=##class(%Library.ResultSet).%New()
		
		d result.Prepare(sqlStr)
		d result.Execute()
		s sqlcode=0
		s resultString=""
		;w sqlStr ,!
		While(result.Next())
		{
			s child=""
			s jxUnitDr=result.Data("UDR_jxUnitDr")
			s kpiDr=result.Data("InterKPI_kpiDr")
			s child=..IfRepRecode(jxUnitDr,period,kpiDr,periodType)
			i child="" d
			.s data=jxUnitDr_"^"_period_"^"_periodType_"^"_kpiDr_"^1^1^"
			.s sqlcode=..Insert(data)
			.i sqlcode'=0 d
			..d ##class(dhc.pa.udata.uPALogger).Insert("getDeptFindDataInsert",data,sqlcode,"插入科室自查数据")
			e  d
			.s sqlcode=..Update(jxUnitDr_"||"_child,"1")
			.i sqlcode'=0 d
			..d ##class(dhc.pa.udata.uPALogger).Insert("getDeptFindDataUpdate",jxUnitDr_"||"_child,sqlcode,"更新科室自查")
		}
	
		d result.Close()
		q sqlcode
}

/// Creator：wang ying
/// CreatDate：2016-2-17
/// Description: 取质量管理系统数据
/// Table：dhc_pa_data.JXBaseData
/// Input：period-考核期间,periodType-期间类型
/// Output：
/// Return：返回执行语句后的SQLCODE
/// Others：w ##class(dhc.pa.udata.uJXBaseData).getQMData("201602","Q")
ClassMethod getQMData(period, periodType) As %String
{
	   
	   n (period, periodType)
	   
	   s sqlStr="SELECT KPIIndex1_rowid,JXUnit_rowid,LocResultMain_period,sum(LocResultMain_failNum) as value FROM("
	            _"SELECT DISTINCT(LocResultMain_rowid),KPIIndex1.KPIIndex1_rowid,JXUnit_rowid," 
				_"LocResultMain_schemDr->QMSchem_Code,LocResultMain_schemDr->QMSchem_name,LocResultMain_departDr->DEP_Desc,"
				_"LocResultMain_departDr->DEP_Code,LocResultMain_rowid," 
				_"LocResultMain_departDr, LocResultMain_period, LocResultMain_wardDr, LocResultMain_failNum"
				_" FROM dhc_qm_data.LocResultMain,dhc_pa_data.KPIIndex1,dhc_pa_data.JXUnit" 
				_" WHERE LocResultMain_departDr->DEP_Code=JXUnit_code"
				_" AND KPIIndex1_code=LocResultMain_schemDr->QMSchem_Code"
				_" AND LocResultMain_period='"_period_"')"
				_" GROUP BY KPIIndex1_rowid, JXUnit_rowid"
				
	
		
		s result=##class(%Library.ResultSet).%New()
		
		d result.Prepare(sqlStr)
		d result.Execute()
		s sqlcode=0
		s resultString=""
		;w sqlStr ,!
		While(result.Next())
		{
			s child=""
			s jxUnitDr=result.Data("JXUnit_rowid")
			s kpiDr=result.Data("KPIIndex1_rowid")
			s value=result.Data("value")
			s child=..IfRepRecode(jxUnitDr,period,kpiDr,periodType)
			i child="" d
			.s data=jxUnitDr_"^"_period_"^"_periodType_"^"_kpiDr_"^"_value_"^1^"
			.s sqlcode=..Insert(data)
			.i sqlcode'=0 d
			..d ##class(dhc.pa.udata.uPALogger).Insert("getQMDataInsert",data,sqlcode,"插入医疗质量管理数据")
			e  d
			.s sqlcode=..Update(jxUnitDr_"||"_child,value)
			.i sqlcode'=0 d
			..d ##class(dhc.pa.udata.uPALogger).Insert("getQMDataUpdate",jxUnitDr_"||"_child_"^"_value,sqlcode,"更新医疗质量管理数据")
		}
	
		d result.Close()
		q sqlcode
}

/// Creator: wang ying
/// CreatDate:2016-03-28
/// Description: 调用drgs的接口统计drgs,cmi
/// Table: 
/// Input:year:年份, period：期间, type：期间类型
/// Output: 
/// Return: 
/// others:w ##class(dhc.pa.udata.uJXBaseData).getXHCMI("2016","01","Q") 
ClassMethod getXHCMI(year, period, periodType) As %String
{
	n ( year,period,periodType)
	
	 if ((year'="")&(period'="")){
		s period=year_period
    }
	q:period="" "Noperiod"
	q:periodType="" "NOperiodType"
	
	s periodStr=##class(dhc.qm.udata.uComm).getTime(period,periodType)
	q:periodStr=""
	
	s startDate=$e($p(periodStr,"^",1),1,7)
	s endDate=$e($p(periodStr,"^",2),1,7)
	
	q:startDate="" "NostartDate"
	q:endDate="" "NoendDate"
	;W startDate_"^"_endDate,!
	s sqlcode=0
	s XHCMI=##class(dhc.qm.service.DrgsServiceImplPort).%New()
	s XHCMIStr=XHCMI.depXHCMI("^"_startDate_"^"_endDate)
	s XMCMIResult=$p(XHCMIStr,"&",1)
	s result=$p(XMCMIResult,"^",1)
	;w XHCMIStr,!
	q:result'=1
	s XMCMILen=$l(XHCMIStr,"&")
	f i=2:1:XMCMILen  d
	.s XMCMIValue=$p(XHCMIStr,"&",i)
	.s deptCode=$p(XMCMIValue,"^",1)
	.s drgs=$p(XMCMIValue,"^",4)
	.s cmi=$p(XMCMIValue,"^",3)
	.s JXUnitDr=""
	.;w "deptCode="_deptCode,!
	.&sql(SELECT JXUnit_rowid into:JXUnitDr FROM dhc_pa_data.JXUnit WHERE JXUnit_code=:deptCode)
	.;w "JXUnitDr="_JXUnitDr,!
	.q:JXUnitDr=""
	.s child=..IfRepRecode(JXUnitDr,period,90,periodType)
	.i (child="")||(child=0) d
	..s data=JXUnitDr_"^"_period_"^"_periodType_"^"_90_"^"_drgs_"^1^"
	..s sqlcode=..Insert(data)
	..i sqlcode'=0 d
	...d ##class(dhc.pa.udata.uPALogger).Insert("getXHCMI90Insert",data,sqlcode,"插入drgs")
	.e  d
	..s sqlcode=..Update(JXUnitDr_"||"_child,drgs)
	..i sqlcode'=0 d
	...d ##class(dhc.pa.udata.uPALogger).Insert("getXHCMI90Update",JXUnitDr_"||"_child_"^"_drgs,sqlcode,"更新drgs")
	.s child=..IfRepRecode(JXUnitDr,period,91,periodType)
	.i (child="")||(child=0) d
	..s data=JXUnitDr_"^"_period_"^"_periodType_"^"_91_"^"_cmi_"^1^"
	..s sqlcode=..Insert(data)
	..i sqlcode'=0 d
	...d ##class(dhc.pa.udata.uPALogger).Insert("getXHCMI91Insert",data,sqlcode,"插入drgs")
	.e  d
	.s sqlcode=..Update(JXUnitDr_"||"_child,cmi)
	.i sqlcode'=0 d
	..d ##class(dhc.pa.udata.uPALogger).Insert("getXHCMI91Update",JXUnitDr_"||"_child_"^"_cmi,sqlcode,"更新drgs")

	q sqlcode
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.uJXBaseDataS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
