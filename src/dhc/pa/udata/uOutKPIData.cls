Class dhc.pa.udata.uOutKPIData Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: wang ying
/// CreatDate: 2010-11-08
/// Description: 查询符合条件的记录
/// Table: dhc.pa.data.Cycle
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;dataFinish-数据采集标志;treatFinish-数据处理标志;tieOff-扎帐标志;
/// Output: w ##class(dhc.pa.udata.uOutKPIData).ListRec("","","","","","","","1","1","M","1")
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.pa.udata.uOutKPIData).ListRec("","","","","",0,25,"1","1","M","1")
ClassMethod ListRec(active, searchField, searchValue, sortField, sortDir, start, limit, CycleDr, period, frequency, locSetDr) As %String
{
		n (active,searchField, searchValue, sortField, sortDir, start, limit,CycleDr,period,frequency,locSetDr)
		
		s newPeriod = ##class(dhc.pa.report.uLocKPIScoreAnlys).GetCycle(CycleDr,period)

		s sqlStr="SELECT OutKPIData_rowid,OutKPIData_outUnitCode,OutKPIData_outUnitName,OutKPIData_outUnitLocCode,OutKPIData_outUnitLocName,OutKPIData_unitType,OutKPIData_outKpiCode,OutKPIData_outKpiName,OutKPIData_period,OutKPIData_periodType,OutKPIData_actValue,OutKPIData_active,OutKPIData_handFlag ,InterKPI_kpiDr FROM dhc_pa_inter.OutKPIData WHERE %ID>0 and OutKPIData_period="_newPeriod_" and OutKPIData_periodType="_"'"_frequency_"'"
		
		i (active="Y")||(active="N") s sqlStr=sqlStr_" AND OutKPIData_active='"_active_"'"
		s sortStr=""
		s sortField1=""
		
		i sortField'="" d
		.i sortField="rowid" s sortField1="OutKPIData_rowid"
		.i sortField="outUnitCode" s sortField1="OutKPIData_outUnitCode"
		.i sortField="outUnitName" s sortField1="OutKPIData_outUnitName"
		.i sortField="outUnitLocCode" s sortField1="OutKPIData_outUnitLocCode"
		.i sortField="outUnitLocName" s sortField1="OutKPIData_outUnitLocName"
		.i sortField="unitType" s sortField1="OutKPIData_unitType"
		.i sortField="outKpiCode" s sortField1="OutKPIData_outKpiCode"
		.i sortField="outKpiName" s sortField1="OutKPIData_outKpiName"
		.i sortField="period" s sortField1="OutKPIData_period"
		.i sortField="periodType" s sortField1="OutKPIData_periodType"
		.i sortField="actValue" s sortField1="OutKPIData_actValue"
		.i sortField="active" s sortField1="OutKPIData_active"
		.i sortField="handFlag" s sortField1="OutKPIData_handFlag"
		.i sortField="kpiCode"  s sortField1="InterKPI_kpiDr "
		.i sortField="kpiName"  s sortField1="InterKPI_kpiDr "	
		i sortField1'="" d
		.s sortDir=$ZCONVERT(sortDir,"u")
		.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
		.e  s sortStr=" ORDER BY "_sortField1_" ASC"
		e  d
		.s sortStr=" ORDER BY %ID DESC"
		
		s sqlStr=sqlStr_sortStr
		
		;w sqlStr,!
		s result=##class(%Library.ResultSet).%New()
		
		d result.Prepare(sqlStr)
		d result.Execute()
		
		s count=0
		s resultString=""
		s end=start+limit
		
		s json=##class(dhc.pa.comm.JsonObj).%New()

		s jsonTitle="rowid^outUnitCode^outUnitName^outUnitLocCode^outUnitLocName^unitType^outKpiCode^outKpiName^period^periodType^actValue^active^handFlag^kpiCode^kpiName"
		
		While(result.Next())
		{
			s unitType=""
			s rowid=result.Data("OutKPIData_rowid")
			s outUnitCode=result.Data("OutKPIData_outUnitCode")
			s outUnitName=result.Data("OutKPIData_outUnitName")
			s outUnitLocCode=result.Data("OutKPIData_outUnitLocCode")
			s outUnitLocName=result.Data("OutKPIData_outUnitLocName")
			s Type=result.Data("OutKPIData_unitType")
			i Type="L" s unitType="科室"
			i Type="P" s unitType="个人"
			s outKpiCode=result.Data("OutKPIData_outKpiCode")
			s outKpiName=result.Data("OutKPIData_outKpiName")
			s period=result.Data("OutKPIData_period")
			s ptype=result.Data("OutKPIData_periodType")
			i ptype="M" s periodType="月"
			i ptype="Q" s periodType="季"
			i ptype="H" s periodType="半年"
			i ptype="Y" s periodType="年"
			s actValue=result.Data("OutKPIData_actValue")
			s active=result.Data("OutKPIData_active")
			s handFlag=result.Data("OutKPIData_handFlag")
			s kpiDr=result.Data("InterKPI_kpiDr")
			i kpiDr="" s kpiCode="",kpiName=""
			i kpiDr'="" s kpiCode=$p($g(^DHCCJXPAKPIINDEX1(kpiDr)),"^",1),kpiName=$p($g(^DHCCJXPAKPIINDEX1(kpiDr)),"^",2)

		
			s tmp=rowid_"^"_outUnitCode_"^"_outUnitName_"^"_outUnitLocCode_"^"_outUnitLocName_"^"_unitType_"^"_outKpiCode_"^"_outKpiName_"^"_period_"^"_periodType_"^"_actValue_"^"_active_"^"_handFlag_"^"_kpiCode_"^"_kpiName
			
			i searchValue'="" d
			.q:(searchField="outUnitCode")&(outUnitCode'[searchValue)
			.q:(searchField="outUnitName")&(outUnitName'[searchValue)
			.q:(searchField="outUnitLocCode")&(outUnitLocCode'[searchValue)
			.q:(searchField="outUnitLocName")&(outUnitLocName'[searchValue)
			.q:(searchField="unitType")&(unitType'[searchValue)
			.q:(searchField="outKpiCode")&(outKpiCode'[searchValue)
			.q:(searchField="outKpiName")&(outKpiName'[searchValue)
			.q:(searchField="period")&(period'[searchValue)
			.q:(searchField="periodType")&(periodType'[searchValue)
			.q:(searchField="actValue")&(actValue'[searchValue)
			.q:(searchField="handFlag")&(handFlag'[searchValue)
			.q:(searchField="kpiCode")&(kpiCode'[searchValue)
			.q:(searchField="kpiName")&(kpiName'[searchValue)
			
			.i (count>=start)&(count<end) d
			..d json.InsertRowData(tmp)
			.s count=count+1
			e  d
			.i (count>=start)&(count<end) d
			..d json.InsertRowData(tmp)
			.s count=count+1
		}
	
		d result.Close()
		s resultString = json.getJsonData(jsonTitle,count)
	 	k json
		q resultString
}

/// Creator: wang ying
/// CreatDate: 2010-11-8
/// Description: 删除期间类型对应的期间的数据
/// Table：dhc.pa.inter.OutKPIData
/// Input：rowid-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.pa.udata.uOutKPIData).Delete(1,1,"M",1)
ClassMethod Delete(CycleDr, period, frequency, locSetDr, kpiType) As %String
{
	n (CycleDr, period, frequency,locSetDr,kpiType )
	
	s newPeriod = ##class(dhc.pa.report.uLocKPIScoreAnlys).GetCycle(CycleDr,period)
	i kpiType'="" d
	.&SQL(DELETE FROM dhc_pa_inter.OutKPIData WHERE OutKPIData_period=:newPeriod and OutKPIData_periodType=:frequency and OutKpiRule_inLocSetDr=:locSetDr and OutKPIData_handFlag !='Y' and OutKPIData_kpiType=:kpiType )
	e  d
	.&SQL(DELETE FROM dhc_pa_inter.OutKPIData WHERE OutKPIData_period=:newPeriod and OutKPIData_periodType=:frequency and OutKpiRule_inLocSetDr=:locSetDr and OutKPIData_handFlag !='Y') 
	q SQLCODE
}

//w ##class(dhc.pa.udata.uOutKPIData).import(5,2,"Q",1,"")

ClassMethod import(CycleDr, period, frequency, locSetDr, kpiType) As %String
{
	n (CycleDr, period, frequency,locSetDr,kpiType)
	;w CycleDr_"^"_period_"^"_frequency_"^"_locSetDr_"^"_kpiType,!
	q:CycleDr="" "CycleDr"
	q:period="" "period"
	q:frequency="" "frequency"	
	q:locSetDr="" "locSetDr"
	s rowid=""
	s locSetCode=""
	i $d(^DHCCJXPAINTERLOCSET(locSetDr)) d
	.s locSetCode=$p($g(^DHCCJXPAINTERLOCSET(locSetDr)),"^",2)
	;导入数据前清空已有数据防止重复导入()
	s result=##class(dhc.pa.udata.uOutKPIData).Delete(CycleDr, period, frequency,locSetDr,kpiType)
	i (result'=0)&&(result'=100) d
	.d ##class(dhc.pa.udata.uPALogger).Insert("DeleteOutKPIData",period_"^"_periodType_"^"_locSetDr_"^"_CycleDr,result,"")
	q:(result'=0)&&(result'=100) "DELETE Error"
	s code = ##class(dhc.pa.report.uLocKPIScoreAnlys).GetCycle(CycleDr,period)
	s rowid=$o(^DHCCJXPAINTERPERIOD(0,"PTPLocSet",code,frequency,1,0))	
	q:rowid=""
	s start=$p(^DHCCJXPAINTERPERIOD(rowid),"^",5)
	s end=$p(^DHCCJXPAINTERPERIOD(rowid),"^",6)
	s startDate=$zd(start,3)                       //核算区间起始日期
	s endDate=$zd(end,3)                           //核算区间终止日期
	s info=code_"^"_period_"^"_frequency_"^"_locSetDr_"^"_kpiType
	s job=$j
	i locSetCode'=2 d
	.s result=..BuildKpiData(startDate,endDate,locSetDr,kpiType) //生成临时globle
	.;w result,!
	.i result=1 s result="INTERFACE ERROR"  //接口M有误，临时globle生成失败
    .s result=..DHCCPADataPre(info,job) //处理临时globle数据并组装数据
    i locSetCode=2 d
    .s result=..DHCCPADataByEBIV(info)
    &SQL(SELECT Count(*) into :flagNum FROM dhc_pa_inter.OutKPIData WHERE OutKPIData_handFlag = 'N' AND OutKpiRule_inLocSetDr =:locSetDr AND OutKPIData_period =:code AND OutKPIData_periodType =:frequency)
    i (flagNum=""||flagNum="0")  s result = "noData"
    q result
}

/// Creator: LY
/// CreatDate: 2013-08-07
/// Description: 导入接口指标任务调用类，本月导上一月的指标值
/// Table：dhc.pa.inter.OutKPIData
/// Input：
/// Output: 
/// Others: d ##class(dhc.pa.udata.uOutKPIData).importByTask()
ClassMethod importByTask() As %String
{
	;n (CycleDr, period, frequency,locSetDr,kpiType)
	
	s locSetDr=1,kpiType=1,frequency="M",CycleDr=""
	
	s cycleCode=$e($zd($h,8),1,4)
	
	s CycleDr=$o(^DHCCJXPACYCLE(0,"Code",cycleCode,CycleDr))	
	q:CycleDr="" "CycleDrNull"

	;s NowMon=$e($zd($h,8),1,5)
	s NowMonFirstDay=$e($zd($h,8),1,6)_"01"  //本月第一天
	
	s lastMonEndDay=  $zd(($zdh(NowMonFirstDay,8)-1),8)  //上月最后一天
	
	s MonthStr=$e(lastMonEndDay,5,5)
	
	i MonthStr=0 s period=$e(lastMonEndDay,6,6)
	i MonthStr=1 s period=$e(lastMonEndDay,5,6)
	
	;w CycleDr_"^"_period_"^"_frequency_"^"_locSetDr_"^"_kpiType,!

	s rowid=""
	;导入数据前清空已有数据防止重复导入(接口套只有一个的情况下)
	s result=##class(dhc.pa.udata.uOutKPIData).Delete(CycleDr, period, frequency,1,"")
	q:(result'=0)&&(result'=100) "DELETE Error"
	s code = ##class(dhc.pa.report.uLocKPIScoreAnlys).GetCycle(CycleDr,period)
	s rowid=$o(^DHCCJXPAINTERPERIOD(0,"PTPLocSet",code,frequency,1,0))	
	s start=$p(^DHCCJXPAINTERPERIOD(rowid),"^",5)
	s end=$p(^DHCCJXPAINTERPERIOD(rowid),"^",6)
	s startDate=$zd(start,3)                       //核算区间起始日期
	s endDate=$zd(end,3)                           //核算区间终止日期
	s info=code_"^"_period_"^"_frequency_"^"_locSetDr_"^"_kpiType
	s job=$j	
	s result=..BuildKpiData(startDate,endDate,locSetDr,kpiType) //生成临时globle
	q:result=1 "INTERFACE ERROR"  //接口M有误，临时globle生成失败
    s result=..DHCCPADataPre(info,job) //处理临时globle数据并组装数据
    q result
}

//生成存储KPI信息的临时globle

//w ##class(dhc.pa.udata.uOutKPIData).BuildKpiData("2013-01-01","2013-01-31",1,"")

ClassMethod BuildKpiData(stdate, endate, locSetDr, kpiType) As %String
{
   
    n (stdate,endate,locSetDr,kpiType)
  
	;zn "dhc-data"
	i locSetDr=1 d 
	.s result=$$BulidKPIDatas^DHCPAInterface(stdate,endate,kpiType)
	i locSetDr=2 d 
	.;
	
	;zn "dhc-app"
	q result
}

//数据处理

ClassMethod DHCCPADataPre(info, job) As %String
{
  n (info,job)
   s result=0,flag=0
    q:info="" "infoErr"
    s unitType="L",active="Y",handFlag="N"
    s str=unitType_"^"_active_"^"_handFlag
    s LocSetDr =$p(info,"^",4)  //接口套
	s Newperiod=$p(info,"^",1) //接口期间
    s periodType=$p(info,"^",3) //接口期间类型
    s kpiType=$p(info,"^",5) //导入指标的类型
    
	s DeptCode="" f  s DeptCode=$o(^tempDHCPAJX(job,"dhcpa",DeptCode)) q:DeptCode=""  d 
	.q:'$d(^CTLOC(DeptCode))
	.q:$g(^CTLOC(DeptCode))=""
	.s DeptName=$p(^CTLOC(DeptCode),"^",2)
	.s KpiCode=""  f  s KpiCode=$o(^tempDHCPAJX(job,"dhcpa",DeptCode,KpiCode)) q:KpiCode=""  d 
	..s KpiName=""  f  s KpiName=$o(^tempDHCPAJX(job,"dhcpa",DeptCode,KpiCode,KpiName)) q:KpiName=""  d 
	...s value=$g(^tempDHCPAJX(job,"dhcpa",DeptCode,KpiCode,KpiName))
	...i (value'="")&&(value'=0) d
	....s data=Newperiod_"^"_periodType_"^"_"his_"_DeptCode_"^"_DeptName_"^"_KpiCode_"^"_KpiName_"^"_value_"^"_str_"^"_LocSetDr_"^"_kpiType
    ....s result=..KpiDatasInsert(data)
    ....i result'=0 d
    .....d ##class(dhc.pa.udata.uPALogger).Insert("DHCCPADataPre",data,result,"")
	k ^tempDHCPAJX(job,"dhcpa")
	
	q result
}

/// Creator: wang ying
/// CreatDate: 2014-04-16
/// Description: 根据条件取集成可视化系统数据
/// Table: dhc.ebiv.data.EBIVIndexData
/// Input:info-期间、期间类型等
/// Output: result
/// Return: 返回插入状态
/// Others: w ##class(dhc.pa.udata.uOutKPIData).DHCCPADataByEBIV("201301^01^1^2^1")
ClassMethod DHCCPADataByEBIV(info) As %String
{
    n (info)
    ;w $zt($p($h,",",2)),!
    s result=0,flag=0
    q:info="" "infoErr"
    s unitType="L",active="Y",handFlag="N"
    s str=unitType_"^"_active_"^"_handFlag
    s LocSetDr =$p(info,"^",4)  //接口套
	s Newperiod=$p(info,"^",1) //接口期间
    s periodType=$p(info,"^",3) //接口期间类型
    s kpiType=$p(info,"^",5) //导入指标的类型
    
    s DeptCode="" f  s DeptCode=$o(^DHCCJXPAINTERLOC(0,"LocSetLoc",LocSetDr,DeptCode)) q:DeptCode=""  d
    .s DeptDr=""
    .i $d(^DHCEBIVUnitSetI("UnitType",DeptCode,4)) d
    ..s DeptDr=$o(^DHCEBIVUnitSetI("UnitType",DeptCode,4,DeptDr))
    ..s DeptCode="",DeptName=""
	..i $d(^DHCEBIVUnitSetD(DeptDr)) d
	...s DeptCode=$LIST($g(^DHCEBIVUnitSetD(DeptDr)),6)
	...s DeptName=$LIST($g(^DHCEBIVUnitSetD(DeptDr)),7)
    .q:DeptDr=""
    .s KpiCode=""  f  s KpiCode=$o(^DHCCJXPAOUTKPIRULE(0,"LocSetKPI",LocSetDr,KpiCode)) q:KpiCode=""  d
	..s KpiName=""
	..i $d(^DHCEBIVIndexDictI("IndexCode",KpiCode)) d
	...s index=0
	...s index=$o(^DHCEBIVIndexDictI("IndexCode",KpiCode,index))
	..q:index=""
	..q:'$d(^DHCEBIVIndexDictD(index))
	..s KpiName=$LIST($g(^DHCEBIVIndexDictD(index)),3)
	..i periodType="M" S periodType=1
    ..i periodType="Q" s periodType=2
    ..i periodType="H" s periodType=3
	..s indexRowid=0 
	..s indexRowid=$o(^DHCEBIVIndexDataI("UnitIndexCodePeriodFrequency",4,DeptDr,KpiCode,Newperiod,periodType,indexRowid)) 
	..q:indexRowid=""
	..q:'$d(^DHCEBIVIndexDataD(indexRowid))
	..s value=$LIST($g(^DHCEBIVIndexDataD(indexRowid)),3)
	..i (value'="")&&(value'=0) d
	...i periodType=1 S periodType="M"
    ...i periodType=2 s periodType="Q"
    ...i periodType=3 s periodType="H"
	...s data=Newperiod_"^"_periodType_"^"_DeptCode_"^"_DeptName_"^"_KpiCode_"^"_KpiName_"^"_value_"^"_str_"^"_LocSetDr_"^"_kpiType
	...s result=..KpiDatasInsert(data)
	...i result'=0 d
	....d ##class(dhc.pa.udata.uPALogger).Insert("DHCCPADataByEBIV",data,result,"")
	

	 
	;w $zt($p($h,",",2)),!
	q result
}

/// Creator：ZBP
/// CreatDate：2013-6-19
/// Description: 指标数据写入
/// Table：dhc_pa_inter.OutKPIData
/// Input：data-需要插入的数据
/// Output：
/// Return：SQLCODE
/// Others：d ##class(dhc.pa.udata.uOutKPIData).KpiDatasInsert("201301^M^10801^皮肤科^mzrc^门诊人次^10")
ClassMethod KpiDatasInsert(data) As %String
{
	n (data)
	q:data="" "dataErr"                   //准备插入的数据为空
		
	k PLIST
	s period=$p(data,"^",1)                  //考核区间Dr
	i period'="" s PLIST(9)=period
	s LocSetDr=$p(data,"^",11) 
	i LocSetDr'="" s PLIST(15)= LocSetDr
	s periodType=$p(data,"^",2)                    //区间类型
	i periodType'="" s PLIST(10)=periodType
	
	s deptCode=$p(data,"^",3)                    //单位代码
	i deptCode'="" s PLIST(2)=deptCode
	s jxUnitDr=##class(dhc.pa.udata.uJXBaseData).GetJXUnitOfOutLoc(LocSetDr,deptCode)
	s LocCode=$p(^DHCCJXPAJXUNIT(jxUnitDr),"^",2)
	s LocName=$p(^DHCCJXPAJXUNIT(jxUnitDr),"^",3)
	i LocCode'="" s PLIST(4)=LocCode
	i LocName'="" s PLIST(5)=LocName
	
	s deptName=$p(data,"^",4)                      //单位名称
	i deptName'="" s PLIST(3)=deptName
	
	s KpiCode=$p(data,"^",5)                //指标代码
	i KpiCode'="" s PLIST(7)=KpiCode
	
	s KpiName=$p(data,"^",6)                //指标名称
	i KpiName'="" s PLIST(8)=KpiName
	
	s value=$p(data,"^",7)                      //指标值
	i value'="" s PLIST(11)=value
	s unittype=$p(data,"^",8)
	i unittype'="" s PLIST(6)=unittype
	s active=$p(data,"^",9)
	i active'="" s PLIST(12)=active
    s handFlag=$p(data,"^",10)
    i handFlag'="" s PLIST(13)=handFlag
    s KpioutDr="",jxKpiDr=""
    //w "KpiCode:"_KpiCode,!
  
  	s kpiType=$p(data,"^",12) 
	i kpiType'="" s PLIST(16)= kpiType
  	
  	
  	
    s KpioutDr=##class(dhc.pa.udata.uJXBaseData).GetOutKPIRowid(KpiCode) //获取外部指标Dr  20130701LXF
   // w "KpioutDr:"_KpioutDr,!
    s jxKpiDr=##class(dhc.pa.udata.uJXBaseData).GetKPIOfOutKPI(KpioutDr)  //得到内部指标Dr 20130701LXF
     //w "jxKpiDr"_jxKpiDr,!
    i jxKpiDr'="" s PLIST(14) =jxKpiDr
	
		
		
	&SQL(INSERT INTO dhc_pa_inter.OutKPIData VALUES PLIST())
	
	q SQLCODE
}

/// Creator: ZBP
/// CreatDate: 2013-07-12
/// Description: 刷新采集的指标数据的部门及指标
/// Table: dhc.ca.inter.outkpidata
/// Input: CycleDr-年度, period-期间, frequency-期间类型
/// Output: 刷新成功返回 0，否则返回错误代码
/// Return: 
/// Others: w ##class(dhc.pa.udata.uOutKPIData).refreshRec(1,1,"M",1)
ClassMethod refreshRec(CycleDr, period, frequency, inLocSetDr) As %String
{
	n (CycleDr, period, frequency,inLocSetDr)

	q:inLocSetDr="" "inLocSetDr is null"
	TSTART

	s flag=0
	s NewPeriod = ##class(dhc.pa.report.uLocKPIScoreAnlys).GetCycle(CycleDr,period)
	
	s sqlStr="SELECT OutKPIData_rowid,OutKPIData_outUnitCode,OutKPIData_outKpiCode FROM dhc_pa_inter.outkpidata"
	s whereStr=" WHERE %ID>0 "
	s whereStr=whereStr_" AND OutKPIData_period='"_NewPeriod_"'"
	s whereStr=whereStr_" AND OutKPIData_periodType='"_frequency_"'"
	s sqlStr=sqlStr_whereStr

	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next())
	{  
		k PLIST
		s rowid=result.Data("OutKPIData_rowid")
		s UnitCode=result.Data("OutKPIData_outUnitCode")
		s KpiCode=result.Data("OutKPIData_outKpiCode")
	   
	    //根据接口科室代码取绩效单元dr
	    s jxUnitDr=##class(dhc.pa.udata.uJXBaseData).GetJXUnitOfOutLoc(inLocSetDr,UnitCode)
		s jxUnitCode=$p($g(^DHCCJXPAJXUNIT(jxUnitDr)),"^",2)
		s jxUnitName=$p($g(^DHCCJXPAJXUNIT(jxUnitDr)),"^",3)
		
		s KpioutDr=##class(dhc.pa.udata.uJXBaseData).GetOutKPIRowid(KpiCode) //获取外部指标Dr  20130701LXF

        s jxKpiDr=##class(dhc.pa.udata.uJXBaseData).GetKPIOfOutKPI(KpioutDr)  //得到内部指标Dr 20130701LXF
   
        i jxKpiDr'="" s PLIST(14) =jxKpiDr
		
		 s PLIST(4)=jxUnitCode
		 s PLIST(5)=jxUnitName
		&SQL(UPDATE dhc_pa_inter.outkpidata VALUES PLIST() where %ID=:rowid)
	    i SQLCODE'=0 s flag=SQLCODE
		
	}

	d result.Close()
	i flag=0 TCOMMIT
	i flag'=0  TROLLBACK
	q flag
}

/// Creator: wang ying
/// CreatDate: 2014-09-01
/// Description: 查询符合条件的记录
/// Table: dhc.pa.data.Cycle
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;dataFinish-数据采集标志;treatFinish-数据处理标志;tieOff-扎帐标志;
/// Output: w ##class(dhc.pa.udata.uOutKPIData).ListRec("","","","","","","","1","1","M","1")
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.pa.udata.uOutKPIData).List("","","","","",0,25,"","","","1")
ClassMethod List(active, searchField, searchValue, sortField, sortDir, start, limit, CycleDr, period, frequency, locSetDr) As %String
{
		n (active,searchField, searchValue, sortField, sortDir, start, limit,CycleDr,period,frequency,locSetDr)
		
		s newPeriod=""
		i (CycleDr'="")&&(period'="") d
		.s newPeriod = ##class(dhc.pa.report.uLocKPIScoreAnlys).GetCycle(CycleDr,period)
       
        s CycleCode=""
        i CycleDr'="" d
        .i $d(^DHCCJXPACYCLE(CycleDr)) d
        ..s CycleCode=$p($g(^DHCCJXPACYCLE(CycleDr)),"^",1)
        ..s CycleCode=$e(CycleCode,1,4)
        
		s sqlStr="SELECT * FROM dhc_pa_inter.OutKPIData WHERE %ID>0"
		i locSetDr'="" s sqlStr=sqlStr_" and OutKpiRule_inLocSetDr="_locSetDr
		i CycleCode'="" s sqlStr=sqlStr_" and OutKPIData_period like '"_CycleCode_"%'"
		i frequency'="" s sqlStr=sqlStr_" and OutKPIData_periodType="_"'"_frequency_"'"
		i newPeriod'="" s sqlStr=sqlStr_" and OutKPIData_period="_newPeriod
		i (active="Y")||(active="N") s sqlStr=sqlStr_" AND OutKPIData_active='"_active_"'"
		s sortStr=""
		s sortField1=""
		
		i sortField'="" d
		.i sortField="rowid" s sortField1="OutKPIData_rowid"
		.i sortField="outUnitCode" s sortField1="OutKPIData_outUnitCode"
		.i sortField="outUnitName" s sortField1="OutKPIData_outUnitName"
		.i sortField="outUnitLocCode" s sortField1="OutKPIData_outUnitLocCode"
		.i sortField="outUnitLocName" s sortField1="OutKPIData_outUnitLocName"
		.i sortField="unitType" s sortField1="OutKPIData_unitType"
		.i sortField="outKpiCode" s sortField1="OutKPIData_outKpiCode"
		.i sortField="outKpiName" s sortField1="OutKPIData_outKpiName"
		.i sortField="period" s sortField1="OutKPIData_period"
		.i sortField="periodType" s sortField1="OutKPIData_periodType"
		.i sortField="actValue" s sortField1="OutKPIData_actValue"
		.i sortField="active" s sortField1="OutKPIData_active"
		.i sortField="handFlag" s sortField1="OutKPIData_handFlag"
		.i sortField="kpiCode"  s sortField1="InterKPI_kpiDr "
		.i sortField="kpiName"  s sortField1="InterKPI_kpiDr "	
		i sortField1'="" d
		.s sortDir=$ZCONVERT(sortDir,"u")
		.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
		.e  s sortStr=" ORDER BY "_sortField1_" ASC"
		e  d
		.s sortStr=" ORDER BY %ID DESC"
		
		s sqlStr=sqlStr_sortStr
		
		;w sqlStr,!
		s result=##class(%Library.ResultSet).%New()
		
		d result.Prepare(sqlStr)
		d result.Execute()
		
		s count=0
		s resultString=""
		s end=start+limit
		
		s json=##class(dhc.pa.comm.JsonObj).%New()

		s jsonTitle="rowid^outUnitCode^outUnitName^outUnitLocCode^outUnitLocName^unitType^outKpiCode^outKpiName^period^periodType^actValue^active^handFlag^kpiCode^kpiName"
		
		While(result.Next())
		{
			s unitType=""
			s rowid=result.Data("OutKPIData_rowid")
			s outUnitCode=result.Data("OutKPIData_outUnitCode")
			s outUnitName=result.Data("OutKPIData_outUnitName")
			s outUnitLocCode=result.Data("OutKPIData_outUnitLocCode")
			s outUnitLocName=result.Data("OutKPIData_outUnitLocName")
			s Type=result.Data("OutKPIData_unitType")
			i Type="L" s unitType="科室"
			i Type="P" s unitType="个人"
			s outKpiCode=result.Data("OutKPIData_outKpiCode")
			s outKpiName=result.Data("OutKPIData_outKpiName")
			s period=result.Data("OutKPIData_period")
			s ptype=result.Data("OutKPIData_periodType")
			i ptype="M" s periodType="月"
			i ptype="Q" s periodType="季"
			i ptype="H" s periodType="半年"
			i ptype="Y" s periodType="年"
			s actValue=result.Data("OutKPIData_actValue")
			s active=result.Data("OutKPIData_active")
			s handFlag=result.Data("OutKPIData_handFlag")
			s kpiDr=result.Data("InterKPI_kpiDr")
			i kpiDr="" s kpiCode="",kpiName=""
			i kpiDr'="" s kpiCode=$p($g(^DHCCJXPAKPIINDEX1(kpiDr)),"^",1),kpiName=$p($g(^DHCCJXPAKPIINDEX1(kpiDr)),"^",2)

		
			s tmp=rowid_"^"_outUnitCode_"^"_outUnitName_"^"_outUnitLocCode_"^"_outUnitLocName_"^"_unitType_"^"_outKpiCode_"^"_outKpiName_"^"_period_"^"_periodType_"^"_actValue_"^"_active_"^"_handFlag_"^"_kpiCode_"^"_kpiName
			
			i searchValue'="" d
			.q:(searchField="outUnitCode")&(outUnitCode'[searchValue)
			.q:(searchField="outUnitName")&(outUnitName'[searchValue)
			.q:(searchField="outUnitLocCode")&(outUnitLocCode'[searchValue)
			.q:(searchField="outUnitLocName")&(outUnitLocName'[searchValue)
			.q:(searchField="unitType")&(unitType'[searchValue)
			.q:(searchField="outKpiCode")&(outKpiCode'[searchValue)
			.q:(searchField="outKpiName")&(outKpiName'[searchValue)
			.q:(searchField="period")&(period'[searchValue)
			.q:(searchField="periodType")&(periodType'[searchValue)
			.q:(searchField="actValue")&(actValue'[searchValue)
			.q:(searchField="handFlag")&(handFlag'[searchValue)
			.q:(searchField="kpiCode")&(kpiCode'[searchValue)
			.q:(searchField="kpiName")&(kpiName'[searchValue)
			
			.i (count>=start)&(count<end) d
			..d json.InsertRowData(tmp)
			.s count=count+1
			e  d
			.i (count>=start)&(count<end) d
			..d json.InsertRowData(tmp)
			.s count=count+1
		}
	
		d result.Close()
		s resultString = json.getJsonData(jsonTitle,count)
	 	k json
		q resultString
}

/// Creator: ban
/// CreatDate: 2015-08-11
/// Description: 判断指标数据采集中的 接口导入的期间是否存在
/// Table: from dhc_pa_inter.InterPeriod
/// Input: CycleDr-年度, period-期间, frequency-期间类型
/// Output: 存在返回 1，否则返回 0  提示要进行接口期间维护
/// Return: 
/// Others: w ##class(dhc.pa.udata.uOutKPIData).isExistPeriod(1,1,"Q")
ClassMethod isExistPeriod(CycleDr, period, frequency) As %String
{
	n (CycleDr, period,frequency)
	s newPeriod=""
	i (CycleDr'="")&&(period'="") d
	.s newPeriod = ##class(dhc.pa.report.uLocKPIScoreAnlys).GetCycle(CycleDr,period)
	i newPeriod = "UnCycleCode"  q "UnCycleCode"
	s sqlStr="SELECT count(*) as num from dhc_pa_inter.InterPeriod "
	s whereStr=" WHERE %ID>0 "
	s whereStr=whereStr_" AND InterPeriod_period='"_newPeriod_"'"
	s whereStr=whereStr_" AND InterPeriod_periodType='"_frequency_"'"
	s sqlStr=sqlStr_whereStr
	;w sqlStr,!
	s num=0
	s flag=0
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next())
	{  
		s num=result.Data("num")
	}

	d result.Close()
	i num >0  s flag=1
	q flag
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.uOutKPIDataS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
