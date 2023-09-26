/// Creator: 李明忠
/// CreatDate: 2010-8-6
/// Description: 基本数据查询
Class dhc.pa.udata.uBaseDataView Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator：李明忠
/// CreatDate：2010-8-6
/// Description: 获取指标分组
/// Table：dhc_pa_data.JXGroup
/// Input：start:开始记录位置;limit:单页记录条数;str-模糊查询字符串
/// Output：
/// Return：分组字符串
/// Others：w ##class(dhc.pa.udata.uBaseDataView).GetGroup(0,10,"")
ClassMethod GetGroup(start, limit, str) As %String
{
	n (start, limit, str)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select JXGroup_rowid,JXGroup_code,JXGroup_name from dhc_pa_data.JXGroup where %ID>0 and JXGroup_type=1"
	i str'="" s sqlStr = sqlStr_" and JXGroup_name like '%"_str_"%'"
	
	d result.Prepare(sqlStr)
	d result.Execute()
    
    ;w sqlStr,!
	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("JXGroup_rowid")
		s code = result.Data("JXGroup_code")
		s name = result.Data("JXGroup_name")
		s tmp=rowid_"^"_code_"^"_name
		s count = count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("rowid^code^name",count)
 	k json
	q resultString
}

/// Creator：李明忠
/// CreatDate：2010-12-17
/// Description: 获取指标分组
/// Table：dhc_pa_data.JXGroup
/// Input：groupDr:分组Dr
/// Output：
/// Return：分组字符串
/// Others：w ##class(dhc.pa.udata.uBaseDataView).GetGroup2(1)
ClassMethod GetGroup2(groupDr) As %String
{
	n (groupDr)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select JXGroup_rowid,JXGroup_code,JXGroup_name from dhc_pa_data.JXGroup where JXGroup_rowid="_groupDr
	
	d result.Prepare(sqlStr)
	d result.Execute()

	s count = 1
	s resultString = ""
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("JXGroup_rowid")
		s code = result.Data("JXGroup_code")
		s name = result.Data("JXGroup_name")
		s tmp=rowid_"^"_code_"^"_name
		d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("rowid^code^name",count)
 	k json
	q resultString
}

/// Creator：李明忠
/// CreatDate：2010-8-6
/// Description: 获取表头信息
/// Table：dhc_pa_data.JXGroup
/// Input：GroupDr:分组ID
/// Output：
/// Return：表头信息字符串
/// Others：w ##class(dhc.pa.udata.uBaseDataView).GetGridTitle(7)
ClassMethod GetGridTitle(GroupDr) As %String
{
	n (GroupDr)
	q:GroupDr="" "NoDatas"
	
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	s rowid=1,title="绩效单元ID",name="jxUnitDr"
	s tmp=rowid_"^"_title_"^"_name
	d json.InsertRowData(tmp)
	s rowid=1,title="绩效单元代码",name="jxUnitCode"
	s tmp=rowid_"^"_title_"^"_name
	d json.InsertRowData(tmp)
	s rowid=2,title="绩效单元名称",name="jxUnitName"
	s tmp=rowid_"^"_title_"^"_name
	d json.InsertRowData(tmp)
	
	i $D(^DHCCJXPAJXGROUP(GroupDr)) d
	.i $G(^DHCCJXPAJXGROUP(GroupDr))'="" d
	..s IDSet=$P($G(^DHCCJXPAJXGROUP(GroupDr)),"^",3)
	..s type=$P($G(^DHCCJXPAJXGROUP(GroupDr)),"^",5)
	..s Length=$L(IDSet,"-")
	..i type=1 d //指标
	...f k=1:1:Length d
	....s ID=$P(IDSet,"-",k)
	....i ID'="" d
	.....i $D(^DHCCJXPAKPIINDEX1(ID)) d
	......i $G(^DHCCJXPAKPIINDEX1(ID))'="" d
	.......s KPIName=$P($G(^DHCCJXPAKPIINDEX1(ID)),"^",2)
	.......s rowid=rowid+1
	.......s title=KPIName
	.......s name="KPIName"_ID
	.......s tmp=rowid_"^"_title_"^"_name
	.......d json.InsertRowData(tmp)
	
	s resultString = ""
	s resultString = json.getJsonData("rowid^title^name",rowid)
 	k json
	q resultString
}

/// Creator：李明忠
/// CreatDate：2010-8-6
/// Description: 获取数据
/// Table：dhc_pa_data.JXGroup
/// Input：CycleDr-年度;PeriodType-期间类型;Period-期间;GroupDr-分组ID;PublicName-指标分组名称
/// Output：
/// Return：数据字符串
/// Others：w ##class(dhc.pa.udata.uBaseDataView).GetData(1,"Q",2,9,"jxUnitName")
ClassMethod GetData(CycleDr, PeriodType, Period, GroupDr, PublicName) As %String
{
	n (CycleDr,PeriodType,Period,GroupDr,PublicName)
	
	k ^TEMPDHCCJXPA("dhc","pa","bdview")
	
	//取年
	q:CycleDr="" "NoData"
	i $D(^DHCCJXPACYCLE(CycleDr)) d
	.i $G(^DHCCJXPACYCLE(CycleDr))'="" d
	..s CycleCode=$P($G(^DHCCJXPACYCLE(CycleDr)),"^",1)
	q:CycleCode="" "NoData"
	
	//取指标ID集合
	s KPIDrList=##class(%Library.ListOfDataTypes).%New()
	q:GroupDr="" "NoData"
	i $D(^DHCCJXPAJXGROUP(GroupDr)) d
	.i $G(^DHCCJXPAJXGROUP(GroupDr))'="" d
	..s IDSet=$P($G(^DHCCJXPAJXGROUP(GroupDr)),"^",3)
	..i IDSet'="" d
	...s Length=$L(IDSet,"-")
	...f k=1:1:Length d
	....s KPIDr=$P(IDSet,"-",k)
	....i KPIDr'="" d
	.....d KPIDrList.Insert(KPIDr)
	
	//1.按月份归集数据
	i PeriodType="M" d  
	.i Period<10 d
	..s Period="0"_Period
	.s Period=CycleCode_Period
	.s unitDr=0
	.f  s unitDr=$O(^DHCCJXPAJXUNIT(0,"JXBDPeriodKPI",unitDr)) q:unitDr=""  d
	..i $D(^DHCCJXPAJXUNIT(0,"JXBDPeriodKPI",unitDr,Period,PeriodType)) d
	...s KPIDr=0
	...f  s KPIDr=$O(^DHCCJXPAJXUNIT(0,"JXBDPeriodKPI",unitDr,Period,PeriodType,KPIDr)) q:KPIDr=""  d
	....i KPIDrList.Find(KPIDr,1)'="" d
	.....s childSub=0
	.....f  s childSub=$O(^DHCCJXPAJXUNIT(0,"JXBDPeriodKPI",unitDr,Period,PeriodType,KPIDr,childSub)) q:childSub=""  d
	......i $D(^DHCCJXPAJXUNIT(unitDr,"JXBaseData",childSub)) d
	.......i $G(^DHCCJXPAJXUNIT(unitDr,"JXBaseData",childSub))'="" d
	........s actualValue=$fn($P($G(^DHCCJXPAJXUNIT(unitDr,"JXBaseData",childSub)),"^",4),"",2)
	........i $D(^TEMPDHCCJXPA("dhc","pa","bdview",PeriodType,unitDr,Period,KPIDr)) d
	.........s ^TEMPDHCCJXPA("dhc","pa","bdview",PeriodType,unitDr,Period,KPIDr)=^TEMPDHCCJXPA("dhc","pa","bdview",PeriodType,unitDr,Period,KPIDr)+actualValue
	........e  d
	.........s ^TEMPDHCCJXPA("dhc","pa","bdview",PeriodType,unitDr,Period,KPIDr)=actualValue
	
	/*
	//2.按季度归集数据(按照月份归集季度数据)
	i PeriodType="Q" d 
	.f newPeriod=(3*Period-2):1:3*Period d
	..i newPeriod<10 d
	...s newPeriod="0"_newPeriod
	..s NamePeriod=CycleCode_newPeriod
	..s unitDr=0
	..f  s unitDr=$O(^DHCCJXPAJXUNIT(0,"JXBDPeriodKPI",unitDr)) q:unitDr=""  d
	...i $D(^DHCCJXPAJXUNIT(0,"JXBDPeriodKPI",unitDr,NamePeriod,PeriodType)) d
	....s KPIDr=0
	....f  s KPIDr=$O(^DHCCJXPAJXUNIT(0,"JXBDPeriodKPI",unitDr,NamePeriod,PeriodType,KPIDr)) q:KPIDr=""  d
	.....i KPIDrList.Find(KPIDr,1)'="" d
	......s childSub=0
	......f  s childSub=$O(^DHCCJXPAJXUNIT(0,"JXBDPeriodKPI",unitDr,NamePeriod,PeriodType,KPIDr,childSub)) q:childSub=""  d
	.......i $D(^DHCCJXPAJXUNIT(unitDr,"JXBaseData",childSub)) d
	........i $G(^DHCCJXPAJXUNIT(unitDr,"JXBaseData",childSub))'="" d
	.........s actualValue=$fn($P($G(^DHCCJXPAJXUNIT(unitDr,"JXBaseData",childSub)),"^",4),"",2)
	.........i $D(^TEMPDHCCJXPA("dhc","pa","bdview",PeriodType,unitDr,Period,KPIDr)) d
	..........s ^TEMPDHCCJXPA("dhc","pa","bdview",PeriodType,unitDr,Period,KPIDr)=^TEMPDHCCJXPA("dhc","pa","bdview",PeriodType,unitDr,Period,KPIDr)+actualValue
	.........e  d
	..........s ^TEMPDHCCJXPA("dhc","pa","bdview",PeriodType,unitDr,Period,KPIDr)=actualValue
	*/
	
	//2.按季度归集数据(直接按照季取数据)
	i PeriodType="Q" d
	.s newPeriod="0"_Period
	.s NamePeriod=CycleCode_newPeriod
	.s unitDr=0
	.f  s unitDr=$O(^DHCCJXPAJXUNIT(0,"JXBDPeriodKPI",unitDr)) q:unitDr=""  d
	..i $D(^DHCCJXPAJXUNIT(0,"JXBDPeriodKPI",unitDr,NamePeriod,PeriodType)) d
	...s KPIDr=0
	...f  s KPIDr=$O(^DHCCJXPAJXUNIT(0,"JXBDPeriodKPI",unitDr,NamePeriod,PeriodType,KPIDr)) q:KPIDr=""  d
	....i KPIDrList.Find(KPIDr,1)'="" d
	.....s childSub=0
	.....f  s childSub=$O(^DHCCJXPAJXUNIT(0,"JXBDPeriodKPI",unitDr,NamePeriod,PeriodType,KPIDr,childSub)) q:childSub=""  d
	......i $D(^DHCCJXPAJXUNIT(unitDr,"JXBaseData",childSub)) d
	.......i $G(^DHCCJXPAJXUNIT(unitDr,"JXBaseData",childSub))'="" d
	........s actualValue=$fn($P($G(^DHCCJXPAJXUNIT(unitDr,"JXBaseData",childSub)),"^",4),"",2)
	........i $D(^TEMPDHCCJXPA("dhc","pa","bdview",PeriodType,unitDr,Period,KPIDr)) d
	.........s ^TEMPDHCCJXPA("dhc","pa","bdview",PeriodType,unitDr,Period,KPIDr)=^TEMPDHCCJXPA("dhc","pa","bdview",PeriodType,unitDr,Period,KPIDr)+actualValue
	........e  d
	.........s ^TEMPDHCCJXPA("dhc","pa","bdview",PeriodType,unitDr,Period,KPIDr)=actualValue
	
	
	//3.按半年归集数据
	i PeriodType="H" d
	.f newPeriod=(6*Period-5):1:6*Period d
	..i newPeriod<10 d
	...s newPeriod="0"_newPeriod
	..s NamePeriod=CycleCode_newPeriod
	..s unitDr=0
	..f  s unitDr=$O(^DHCCJXPAJXUNIT(0,"JXBDPeriodKPI",unitDr)) q:unitDr=""  d
	...i $D(^DHCCJXPAJXUNIT(0,"JXBDPeriodKPI",unitDr,NamePeriod,PeriodType)) d
	....s KPIDr=0
	....f  s KPIDr=$O(^DHCCJXPAJXUNIT(0,"JXBDPeriodKPI",unitDr,NamePeriod,PeriodType,KPIDr)) q:KPIDr=""  d
	.....i KPIDrList.Find(KPIDr,1)'="" d
	......s childSub=0
	......f  s childSub=$O(^DHCCJXPAJXUNIT(0,"JXBDPeriodKPI",unitDr,NamePeriod,PeriodType,KPIDr,childSub)) q:childSub=""  d
	.......i $D(^DHCCJXPAJXUNIT(unitDr,"JXBaseData",childSub)) d
	........i $G(^DHCCJXPAJXUNIT(unitDr,"JXBaseData",childSub))'="" d
	.........s actualValue=$fn($P($G(^DHCCJXPAJXUNIT(unitDr,"JXBaseData",childSub)),"^",4),"",2)
	.........i $D(^TEMPDHCCJXPA("dhc","pa","bdview",PeriodType,unitDr,Period,KPIDr)) d
	..........s ^TEMPDHCCJXPA("dhc","pa","bdview",PeriodType,unitDr,Period,KPIDr)=^TEMPDHCCJXPA("dhc","pa","bdview",PeriodType,unitDr,Period,KPIDr)+actualValue
	.........e  d
	..........s ^TEMPDHCCJXPA("dhc","pa","bdview",PeriodType,unitDr,Period,KPIDr)=actualValue
	
	//4.按年归集数据
	i PeriodType="Y" d
	.s NamePeriod=CycleCode_"00"
	.s unitDr=0
	.f  s unitDr=$O(^DHCCJXPAJXUNIT(0,"JXBDPeriodKPI",unitDr)) q:unitDr=""  d
	..i $D(^DHCCJXPAJXUNIT(0,"JXBDPeriodKPI",unitDr,NamePeriod,PeriodType)) d
	...s KPIDr=0
	...f  s KPIDr=$O(^DHCCJXPAJXUNIT(0,"JXBDPeriodKPI",unitDr,NamePeriod,PeriodType,KPIDr)) q:KPIDr=""  d
	....i KPIDrList.Find(KPIDr,1)'="" d
	.....s childSub=0
	.....f  s childSub=$O(^DHCCJXPAJXUNIT(0,"JXBDPeriodKPI",unitDr,NamePeriod,PeriodType,KPIDr,childSub)) q:childSub=""  d
	......i $D(^DHCCJXPAJXUNIT(unitDr,"JXBaseData",childSub)) d
	.......i $G(^DHCCJXPAJXUNIT(unitDr,"JXBaseData",childSub))'="" d
	........s actualValue=$fn($P($G(^DHCCJXPAJXUNIT(unitDr,"JXBaseData",childSub)),"^",4),"",2)
	........i $D(^TEMPDHCCJXPA("dhc","pa","bdview",PeriodType,unitDr,Period,KPIDr)) d
	.........s ^TEMPDHCCJXPA("dhc","pa","bdview",PeriodType,unitDr,Period,KPIDr)=^TEMPDHCCJXPA("dhc","pa","bdview",PeriodType,unitDr,Period,KPIDr)+actualValue
	........e  d
	.........s ^TEMPDHCCJXPA("dhc","pa","bdview",PeriodType,unitDr,Period,KPIDr)=actualValue

	//定义JSON和表头Info
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle=""
	s resultString=""
	s count=0
	//取展现数据
	i $D(^TEMPDHCCJXPA("dhc","pa","bdview",PeriodType)) d
	.s jxUnitDr=0
	.f  s jxUnitDr=$O(^TEMPDHCCJXPA("dhc","pa","bdview",PeriodType,jxUnitDr)) q:jxUnitDr=""  d
	..s tmp="",jxUnitCode="",jxUnitName=""
	..s tmp=jxUnitDr_"^"_jxUnitCode_"^"_jxUnitName
	..s jsonTitle="jxUnitDr^jxUnitCode^jxUnitName"
	..i $D(^DHCCJXPAJXUNIT(jxUnitDr)) d
	...i $G(^DHCCJXPAJXUNIT(jxUnitDr))'="" d
	....s jxUnitCode=$P(^DHCCJXPAJXUNIT(jxUnitDr),"^",2)
	....s jxUnitName=$P(^DHCCJXPAJXUNIT(jxUnitDr),"^",3)
	....s tmp=jxUnitDr_"^"_jxUnitCode_"^"_jxUnitName
	..i $D(^TEMPDHCCJXPA("dhc","pa","bdview",PeriodType,jxUnitDr,Period)) d
	...s Num=KPIDrList.Count()
	...f k=1:1:Num d
	....s KPIDr=KPIDrList.GetAt(k)
	....i KPIDr'="" d
	.....i $D(^TEMPDHCCJXPA("dhc","pa","bdview",PeriodType,jxUnitDr,Period,KPIDr)) d
	......s actualValue=^TEMPDHCCJXPA("dhc","pa","bdview",PeriodType,jxUnitDr,Period,KPIDr)
	......s tmp=tmp_"^"_actualValue
	......s KPIName="KPIName"_KPIDr
	......s jsonTitle=jsonTitle_"^"_KPIName
	.....e  d
	......s actualValue=0.00
	......s tmp=tmp_"^"_actualValue
	......s KPIName="KPIName"_KPIDr
	......s jsonTitle=jsonTitle_"^"_KPIName
	..s count=count+1
	..d json.InsertRowData(tmp)
	
	k ^TEMPDHCCJXPA("dhc","pa","bdview")

	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator：李明忠
/// CreatDate：2010-8-9
/// Description: 审核基础数据
/// Table：dhc_pa_data.JXBaseData
/// Input：userCode-用户代码;CycleDr-年度;PeriodType-期间类型;Period-期间;GroupDr-分组ID
/// Output：
/// Return：返回成功标志符号
/// Others：w ##class(dhc.pa.udata.uBaseDataView).Audit("fhq",1,"Q",1,7)
ClassMethod Audit(userCode, CycleDr, PeriodType, Period, GroupDr) As %String
{
	n (userCode,CycleDr,PeriodType,Period,GroupDr)
	
	//取年
	q:CycleDr="" "NoData"
	i $D(^DHCCJXPACYCLE(CycleDr)) d
	.i $G(^DHCCJXPACYCLE(CycleDr))'="" d
	..s CycleCode=$P($G(^DHCCJXPACYCLE(CycleDr)),"^",1)
	q:CycleCode="" "NoData"
	
	//获取要审核的指标
	s KPIDrList=##class(%Library.ListOfDataTypes).%New()
	q:GroupDr="" "NoData"
	i $D(^DHCCJXPAJXGROUP(GroupDr)) d
	.i $G(^DHCCJXPAJXGROUP(GroupDr))'="" d
	..s IDSet=$P($G(^DHCCJXPAJXGROUP(GroupDr)),"^",3)
	..i IDSet'="" d
	...s Length=$L(IDSet,"-")
	...f k=1:1:Length d
	....s KPIDr=$P(IDSet,"-",k)
	....i KPIDr'="" d
	.....d KPIDrList.Insert(KPIDr)
	
	q:userCode="" "NoData"
	//获取用户ID
	s userCode=$$ALPHAUP^SSUTIL4(userCode)
	//根据用户Code查找用户ID
	s userId=0
	s userId=$O(^SSU("SSUSR",0,"SSUSR_Initials",userCode,userId))
	q:userId="" "NoData"
	
	TSTART
	s rs=0
	
	//1.按月份审核数据
	i PeriodType="M" d  
	.i Period<10 d
	..s Period="0"_Period
	.s Period=CycleCode_Period
	.s unitDr=0
	.f  s unitDr=$O(^DHCCJXPAJXUNIT(0,"JXBDPeriodKPI",unitDr)) q:unitDr=""  d
	..i $D(^DHCCJXPAJXUNIT(0,"JXBDPeriodKPI",unitDr,Period,PeriodType)) d
	...s Length=KPIDrList.Count()
	...f k=1:1:Length d
	....s KPIDr=KPIDrList.GetAt(k)
	....i KPIDr'="" d
	.....i $D(^DHCCJXPAJXUNIT(0,"JXBDPeriodKPI",unitDr,Period,PeriodType,KPIDr)) d
	......s childSub=0
	......f  s childSub=$O(^DHCCJXPAJXUNIT(0,"JXBDPeriodKPI",unitDr,Period,PeriodType,KPIDr,childSub)) q:childSub=""  d
	.......s rowid=unitDr_"||"_childSub
	.......s dataState=1
	.......s auditData=$P($h,",",1)
	.......&SQL(update dhc_pa_data.JXBaseData set JXBaseData_auditDate=:auditData,JXBaseData_auditUserDr=:userId,JXBaseData_dataState=:dataState where JXBaseData_rowid=:rowid)
	.......i SQLCODE'=0 s rs=1
	
	/*
	//2.按季度审核数据
	i PeriodType="Q" d  
	.f newPeriod=(3*Period-2):1:3*Period d
	..i newPeriod<10 d
	...s newPeriod="0"_newPeriod
	..s NamePeriod=CycleCode_newPeriod
	..s unitDr=0
	..f  s unitDr=$O(^DHCCJXPAJXUNIT(0,"JXBDPeriodKPI",unitDr)) q:unitDr=""  d
	...i $D(^DHCCJXPAJXUNIT(0,"JXBDPeriodKPI",unitDr,NamePeriod,PeriodType)) d
	....s Length=KPIDrList.Count()
	....f k=1:1:Length d
	.....s KPIDr=KPIDrList.GetAt(k)
	.....i KPIDr'="" d
	......i $D(^DHCCJXPAJXUNIT(0,"JXBDPeriodKPI",unitDr,NamePeriod,PeriodType,KPIDr)) d
	.......s childSub=0
	.......f  s childSub=$O(^DHCCJXPAJXUNIT(0,"JXBDPeriodKPI",unitDr,NamePeriod,PeriodType,KPIDr,childSub)) q:childSub=""  d
	........s rowid=unitDr_"||"_childSub
	........w rowid,!
	........s dataState=1
	........s auditData=$P($h,",",1)
	........&SQL(update dhc_pa_data.JXBaseData set JXBaseData_auditDate=:auditData,JXBaseData_auditUserDr=:userId,JXBaseData_dataState=:dataState where JXBaseData_rowid=:rowid)
	........i SQLCODE'=0 s rs=1
	*/
	
	//2.按季度审核数据
	i PeriodType="Q" d  
	.s newPeriod="0"_Period
	.s NamePeriod=CycleCode_newPeriod
	.s unitDr=0
	.f  s unitDr=$O(^DHCCJXPAJXUNIT(0,"JXBDPeriodKPI",unitDr)) q:unitDr=""  d
	..i $D(^DHCCJXPAJXUNIT(0,"JXBDPeriodKPI",unitDr,NamePeriod,PeriodType)) d
	...s Length=KPIDrList.Count()
	...f k=1:1:Length d
	....s KPIDr=KPIDrList.GetAt(k)
	....i KPIDr'="" d
	.....i $D(^DHCCJXPAJXUNIT(0,"JXBDPeriodKPI",unitDr,NamePeriod,PeriodType,KPIDr)) d
	......s childSub=0
	......f  s childSub=$O(^DHCCJXPAJXUNIT(0,"JXBDPeriodKPI",unitDr,NamePeriod,PeriodType,KPIDr,childSub)) q:childSub=""  d
	.......s rowid=unitDr_"||"_childSub
	.......s dataState=1
	.......s auditData=$P($h,",",1)
	.......&SQL(update dhc_pa_data.JXBaseData set JXBaseData_auditDate=:auditData,JXBaseData_auditUserDr=:userId,JXBaseData_dataState=:dataState where JXBaseData_rowid=:rowid)
	.......i SQLCODE'=0 s rs=1

	//3.按半年审核数据
	i PeriodType="H" d
	.f newPeriod=(6*Period-5):1:6*Period d
	..i newPeriod<10 d
	...s newPeriod="0"_newPeriod
	..s NamePeriod=CycleCode_newPeriod
	..s unitDr=0
	..f  s unitDr=$O(^DHCCJXPAJXUNIT(0,"JXBDPeriodKPI",unitDr)) q:unitDr=""  d
	...i $D(^DHCCJXPAJXUNIT(0,"JXBDPeriodKPI",unitDr,NamePeriod,PeriodType)) d
	....s Length=KPIDrList.Count()
	....f k=1:1:Length d
	.....s KPIDr=KPIDrList.GetAt(k)
	.....i KPIDr'="" d
	......i $D(^DHCCJXPAJXUNIT(0,"JXBDPeriodKPI",unitDr,NamePeriod,PeriodType,KPIDr)) d
	.......s childSub=0
	.......f  s childSub=$O(^DHCCJXPAJXUNIT(0,"JXBDPeriodKPI",unitDr,NamePeriod,PeriodType,KPIDr,childSub)) q:childSub=""  d
	........s rowid=unitDr_"||"_childSub
	........s dataState=1
	........s auditData=$P($h,",",1)
	........&SQL(update dhc_pa_data.JXBaseData set JXBaseData_auditDate=:auditData,JXBaseData_auditUserDr=:userId,JXBaseData_dataState=:dataState where JXBaseData_rowid=:rowid)
	........i SQLCODE'=0 s rs=1
	
	//4.按年审核数据
	i PeriodType="Y" d
	.s NamePeriod=CycleCode_"00"
	.s unitDr=0
	.f  s unitDr=$O(^DHCCJXPAJXUNIT(0,"JXBDPeriodKPI",unitDr)) q:unitDr=""  d
	..i $D(^DHCCJXPAJXUNIT(0,"JXBDPeriodKPI",unitDr,NamePeriod,PeriodType)) d
	...s Length=KPIDrList.Count()
	...f k=1:1:Length d
	....s KPIDr=KPIDrList.GetAt(k)
	....i KPIDr'="" d
	.....i $D(^DHCCJXPAJXUNIT(0,"JXBDPeriodKPI",unitDr,NamePeriod,PeriodType,KPIDr)) d
	......s childSub=0
	......f  s childSub=$O(^DHCCJXPAJXUNIT(0,"JXBDPeriodKPI",unitDr,NamePeriod,PeriodType,KPIDr,childSub)) q:childSub=""  d
	.......s rowid=unitDr_"||"_childSub
	.......s dataState=1
	.......s auditData=$P($h,",",1)
	.......&SQL(update dhc_pa_data.JXBaseData set JXBaseData_auditDate=:auditData,JXBaseData_auditUserDr=:userId,JXBaseData_dataState=:dataState where JXBaseData_rowid=:rowid)
	.......i SQLCODE'=0 s rs=1
	
	i rs'=0 d
	.TRollBack
	e  d
	.TCOMMIT
	
	q rs
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.uBaseDataViewS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
