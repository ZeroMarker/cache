/// Creator: 李明忠
/// CreatDate: 2010-11-12
/// Description: 接口数据导入
Class dhc.bonus.udata.uInterData Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator：李明忠
/// CreatDate：2010-11-26
/// Description: 获取接口套
/// Table：dhc_pa_inter.InterLocSet
/// Input：start:开始记录位置;limit:单页记录条数;str-模糊查询字符串
/// Output：
/// Return：有效接口套字符串
/// Others：w ##class(dhc.bonus.udata.uInterData).LocSet(0,10,"")
ClassMethod LocSet(start, limit, str) As %String
{
	n (start, limit, str)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select InterLocSet_rowid,InterLocSet_name from dhc_bouns_inter.InterLocSet where %ID>0 and InterLocSet_active='Y'"
	i str'="" s sqlStr = sqlStr_" and InterLocSet_shortcut like '"_str_"%'"
	
	d result.Prepare(sqlStr)
	d result.Execute()

	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.bonus.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("InterLocSet_rowid")
		s name = result.Data("InterLocSet_name")
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

/// Creator:李明忠
/// CreatDate: 2010-11-12
/// Description: 将外部系统数据导入至指标数据采集表
/// Table：dhc.bonus.inter.OutKPIData
/// Input：CycleDr-年度Dr,Freq-考核期间类别,Period-考核期间,LocSetDr-接口套Dr
/// Output: 
/// Return: 
/// Others: w ##class(dhc.bonus.udata.uInterData).Import(1,"Y",0,1)
ClassMethod Import(CycleDr, Freq, Period, LocSetDr) As %String
{
	n (CycleDr,Freq,Period,LocSetDr)
	
	q:CycleDr="" "NoCycle"
	q:Freq="" "NoFreq"
	q:Period="" "NoPeriod"
	q:LocSetDr="" "NoLocSet"
	
	//判断该接口系统数据是否是通过系统直接对接而导入
	//^DHCCJXPAINTERLOCSET
	s periodType=0
	i $D(^DHCCJXPAINTERLOCSET(LocSetDr)) d
	.i $G(^DHCCJXPAINTERLOCSET(LocSetDr))'="" d
	..s periodType=$P(^DHCCJXPAINTERLOCSET(LocSetDr),"^",11)
	;w periodType,!
	q:(periodType'=1)&&(periodType'=2) "NoPeriodType"
	
	//查询新期间
	s newPeriod=##class(dhc.bonus.udata.uCalculator).GetCycle(CycleDr,Period)
	;w newPeriod,!
	q:newPeriod="" "NoNewPeriod"
	
	//开始分阶段执行
	;1.生成临时Global
	s flag="true"
	s infoStr=..FindInterPeriod(LocSetDr,newPeriod,Freq)
	;w infoStr,!
	i infoStr'="" d
	.s flag=..ImportData(newPeriod,Freq,infoStr)
	
	q flag
}

/// Creator：李明忠
/// CreatDate：2010-11-15
/// Description: 查询接口期间
/// Table：dhc_nca_inter.InterPeriod
/// Input：locSetDr-接口套;newPeriod-绩效期间;Freq-期间类型
/// Output：
/// Return：有效接口期间字符串
/// Others：w ##class(dhc.bonus.udata.uInterData).FindInterPeriod(2,"201001","M")
ClassMethod FindInterPeriod(locSetDr, newPeriod, Freq) As %String
{
	n (locSetDr,newPeriod,Freq)
	
	s infoStr=""
	
	s rowid=0
	f  s rowid = $O(^DHCCJXPAINTERPERIOD(0,"PTPLocSet",newPeriod,Freq,locSetDr,rowid)) q:rowid=""  d
	.i $D(^DHCCJXPAINTERPERIOD(rowid)) d
	..i $G(^DHCCJXPAINTERPERIOD(rowid))'="" d
	...s corrType=$P($G(^DHCCJXPAINTERPERIOD(rowid)),"^",9)
	...i corrType="R" d //rowid对照
	....s quoteStr=$P($G(^DHCCJXPAINTERPERIOD(rowid)),"^",4)
	....s infoStr=corrType_"^"_locSetDr_"^"_quoteStr
	...i corrType="I" d //区间对照
	....s startDate=$P($G(^DHCCJXPAINTERPERIOD(rowid)),"^",5)
	....s endDate=$P($G(^DHCCJXPAINTERPERIOD(rowid)),"^",6)
	....s infoStr=corrType_"^"_locSetDr_"^"_startDate_"^"_endDate
	
	q infoStr
}

/// Creator：李明忠
/// CreatDate：2010-11-15
/// Description: 为导入数据做准备,生成有效的临时Global
/// Table：
/// Input：newPeriod-期间,Freq-期间类型,infoStr-基础信息(包括：对照类别,系统rowid,ID对照或区间对照的期间)
/// Output：
/// Return：返回rs,判断是否执行成功,不成功即回滚
/// Others：w ##class(dhc.bonus.udata.uInterData).ImportData("201000","Y","I^1^61727^62091")
ClassMethod ImportData(newPeriod, Freq, infoStr) As %String
{
	n (newPeriod,Freq,infoStr)
	
	q:newPeriod=""
	q:Freq=""
	q:infoStr=""
	
	s locSetDr=$P(infoStr,"^",2)
	q:locSetDr=""
	
	//获取接口系统的指标字符串
	s ItemCodeStr=""
	i $D(^DHCCJXPAOUTKPIRULE(0,"LocSetKPI",locSetDr)) d
	.s kpiCode=""
	.f  s kpiCode=$O(^DHCCJXPAOUTKPIRULE(0,"LocSetKPI",locSetDr,kpiCode)) q:kpiCode=""  d
	..i ItemCodeStr="" s ItemCodeStr=kpiCode
	..e  s ItemCodeStr=ItemCodeStr_"^"_kpiCode
	//获取接口系统的科室字符串
	s UnitCodeStr="",count=0
	i $D(^DHCCJXPAINTERLOC(0,"LocSetLoc",locSetDr)) d
	.s unitCode=""
	.f  s unitCode=$O(^DHCCJXPAINTERLOC(0,"LocSetLoc",locSetDr,unitCode)) q:unitCode=""  d
	..;s count=count+1
	..i UnitCodeStr="" s UnitCodeStr=unitCode
	..e  s UnitCodeStr=UnitCodeStr_"^"_unitCode
	
	;w count_"!"_UnitCodeStr,!
	
	s flag="true"
	s corrType=$P(infoStr,"^",1) //取对照类别
	
	//ID对照
	i corrType="R" d 
	.s quote=$P(infoStr,"^",3)
	.i (quote'="")&&(ItemCodeStr'="") d
	..;w newPeriod_"^"_Freq_"^"_locSetName_"^"_ItemCodeStr_"^"_quote,!
	..s flag= ..ImportQuoteData(newPeriod,Freq,locSetDr,ItemCodeStr,UnitCodeStr,quote)
	
	//区间对照
	i corrType="I" d 
	.s startDate=$P(infoStr,"^",3)
	.s endDate=$P(infoStr,"^",4)
	.i (startDate'="")&&(endDate'="")&&(ItemCodeStr'="") d
	..d ..ImportInterValData(newPeriod,Freq,locSetDr,ItemCodeStr,UnitCodeStr,startDate,endDate)
	
	q flag
}

/// Creator：李明忠
/// CreatDate：2010-11-15
/// Description: 从以日期区间为对照的系统为导入数据做准备
/// Table：
/// Input：newPeriod-期间,Freq-期间类型,locSetDr-外部系统ID,ItemCodeStr-需要从接口系统获取的指标字符串,UnitCodeStr-需要从接口系统获取的科室字符串,startDate-区间的起始日期,endDate-区间对照的结束日期
/// Output：
/// Return：返回rs,判断是否执行成功,不成功即回滚
/// Others：w ##class(dhc.bonus.udata.uInterData).ImportInterValData("HIS系统",62041,62042)
ClassMethod ImportInterValData(newPeriod, Freq, locSetDr, ItemCodeStr, UnitCodeStr, startDate, endDate) As %String
{
	n (newPeriod,Freq,locSetDr,ItemCodeStr,UnitCodeStr,startDate,endDate)
	
	//=========当新增加以区间对照为准的接口系统时，只需要添加如下语句=================================
	;i locSetDr=？ d 
	;.d ..XXXX(newPeriod,Freq,ItemCodeStr,UnitCodeStr,startDate,endDate)
	//接口系统码：“？”表示接口系统页面上的数据库码
	//接口方法：XXXX----表示接口系统页面上的数据库码所对应的接口方法名称
	//============================================================================================
	
	i locSetDr=1 d //HIS系统
	.d ..ImportHISData(newPeriod,Freq,ItemCodeStr,UnitCodeStr,startDate,endDate)
}

/// Creator：李明忠
/// CreatDate：2010-11-15
/// Description: 从以ID为对照的系统为导入数据做准备
/// Table：
/// Input：newPeriod-期间,Freq-期间类型,locSetDr-外部系统ID,ItemCodeStr-需要从接口系统获取的指标字符串,UnitCodeStr-需要从接口系统获取的科室字符串,quote-ID对照(格式：1-2-3)
/// Output：
/// Return：返回rs,判断是否执行成功,不成功即回滚
/// Others：w ##class(dhc.bonus.udata.uInterData).ImportQuoteData("成本核算系统","1-2-3")
ClassMethod ImportQuoteData(newPeriod, Freq, locSetDr, ItemCodeStr, UnitCodeStr, Quote) As %String
{
	n (newPeriod,Freq,locSetDr,ItemCodeStr,UnitCodeStr,Quote)
	
	s flag="true"
	
	//=========当新增加以ID对照为准的接口系统时，只需要添加如下语句=================================
	;i locSetDr=? d 
	;.s flag= ..XXXX(newPeriod,Freq,ItemCodeStr,UnitCodeStr,Quote)
	//接口系统码：“？”表示接口系统页面上的数据库码
	//接口方法：XXXX----表示接口系统页面上的数据库码所对应的接口方法名称
	//============================================================================================
	
	i locSetDr=2 d //成本核算系统
	.s flag= ..ImportCAData(newPeriod,Freq,ItemCodeStr,UnitCodeStr,Quote)
	
	q flag
}

/// Creator：李明忠
/// CreatDate：2010-11-15
/// Description: 从HIS系统为导入数据做准备,生成有效的临时Global
/// Table：
/// Input：newPeriod-期间,Freq-期间类型,ItemCodeStr-需要从HIS系统获取的指标字符串,UnitCodeStr-需要从HIS系统获取的科室字符串,startDate-区间的起始日期,endDate-区间对照的结束日期
/// Output：
/// Return：返回rs,判断是否执行成功,不成功即回滚
/// Others：w ##class(dhc.bonus.udata.uInterData).ImportHISData(62041,62042)
ClassMethod ImportHISData(newPeriod, Freq, ItemCodeStr, UnitCodeStr, startDate, endDate) As %String
{
	n (newPeriod,Freq,ItemCodeStr,UnitCodeStr,startDate,endDate)
	
	k ^TEMPDHCCJXPA("dhc","pa","inter","his")
	k ^DHCCJXPATEMPHIS("dhc","pa","hisdatain",$j)
	k ^DHCCJXPATEMPHIS("dhc","pa","hisdataIP",$j)
	
	//数据格式要求提供如下信息：
	//1.科室Code、Name
	//2.项目Code、Name、Count
	
	//需要处理的指标
	;;1.门诊人次 								HIS 全院、科室、个人
	;;2.住院床日(在院人数) 						HIS 全院、科室、个人
	;;3.床位使用率=在院人数/床数 				HIS 全院、科室
	;;4.出院病人数 								HIS 全院、科室
	;5.手术例数(有的没上手术申请)				HIS 全院、科室、个人
	;6.住院病人增长率 							HIS 全院、科室
	;7.出院病人增长率 							HIS 全院、科室
	;;8.平均住院天数=出院病人总天数/出院病人 	HIS 全院、科室
	;9.复诊率(复诊人数和总门诊数) 				HIS 全院、科室、个人
	
	//执行住院方法
	zn "meddata"    //"DHC-DATA"
	d OutPutIPWorkload^DHCWLInPutCAData(startDate,endDate)
	zn "websrc"     //"DHC-APP"
	//从临时Global中取出数据
	//^DHCCJXPATEMP("dhc","ca","hisdataIP",$j,row)=日期^病人科室代码^病人科室名称^床位数^出院人数^出院人数住院天数^在院人数
	//^DHCCJXPATEMP("dhc","ca","hisdataIP",$j,Num)=$zd(day,3)_"^"_locdr_"^"_locdesc_"^"_bednum_"^"_cyrs_"^"_days_"^"_zyrs
	i $d(^DHCCJXPATEMPHIS("dhc","pa","hisdataIP",$j)) d
	.s row=0
	.f  s row=$O(^DHCCJXPATEMPHIS("dhc","pa","hisdataIP",$j,row)) q:row=""  d
	..s Curr=$G(^DHCCJXPATEMPHIS("dhc","pa","hisdataIP",$j,row))
	..i Curr'="" d ;每天的记录
	...s date=$P(Curr,"^",1) ;取日期并处理成月份的形式
	...i date'="" d
	....s monthCode=$P(date,"-",1)_$P(date,"-",2)
	....s locName=$P(Curr,"^",3) ;取病人科室名称
	....s bedNum=$P(Curr,"^",4) ;取床位数
	....s cyrs=$P(Curr,"^",5) ;取出院人数(出院病人数)
	....s cyrDays=$P(Curr,"^",6) ;取出院人数住院天数
	....s zyrs=$P(Curr,"^",7) ;取在院人数
	....i $D(^TEMPDHCCJXPA("dhc","pa","inter","his",monthCode,locName)) d
	.....s tempCurr=$G(^TEMPDHCCJXPA("dhc","pa","inter","his",monthCode,locName))
	.....s ^TEMPDHCCJXPA("dhc","pa","inter","his",monthCode,locName)=(bedNum+$P(tempCurr,"^",1))_"^"_(cyrs+$P(tempCurr,"^",2))_"^"_(cyrDays+$P(tempCurr,"^",3))_"^"_(zyrs+$P(tempCurr,"^",4))
	....e  d
	.....s ^TEMPDHCCJXPA("dhc","pa","inter","his",monthCode,locName)=bedNum_"^"_cyrs_"^"_cyrDays_"^"_zyrs
	
	//执行门诊方法
	zn "meddata"   //"DHC-DATA"
	d OutPutOP^DHCWLInPutCAData(startDate,endDate)
	zn "websrc"    //"DHC-APP"
	//^DHCCJXPATEMP("dhc","ca","hisdatain",$j,Num)=日期^病人科室代码^病人科室名称^数量(门诊人次)
	//^DHCCJXPATEMP("dhc","ca","hisdatain",$j,Num)=$zd(day,3)_"^"_locdr_"^"_locdesc_"^"_$g(^tempDHCWL($j,"Loc",locdr,"Counts"))
	i $D(^DHCCJXPATEMPHIS("dhc","pa","hisdatain")) d
	.s row=0
	.f  s row=$O(^DHCCJXPATEMPHIS("dhc","pa","hisdatain",$j,row)) q:row=""  d
	..s Curr=$G(^DHCCJXPATEMPHIS("dhc","pa","hisdatain",$j,row))
	..i Curr'="" d ;每天的记录
	...s date=$P(Curr,"^",1) ;取日期并处理成月份的形式
	...i date'="" d
	....s monthCode=$P(date,"-",1)_$P(date,"-",2)
	....s locName=$P(Curr,"^",3) ;取病人科室名称
	....s count=$P(Curr,"^",4) ;取门诊人次
	....i $D(^TEMPDHCCJXPA("dhc","pa","inter","his",monthCode,locName)) d
	.....s tempCurr=$G(^TEMPDHCCJXPA("dhc","pa","inter","his",monthCode,locName))
	....e  d
	.....s tempCurr="^^^"
	....s ^TEMPDHCCJXPA("dhc","pa","inter","his",monthCode,locName)=tempCurr_"^"_count
	
	k ^TEMPDHCCJXPA("dhc","pa","inter","his")
	k ^DHCCJXPATEMPHIS("dhc","pa","hisdatain",$j)
	k ^DHCCJXPATEMPHIS("dhc","pa","hisdataIP",$j)
}

/// Creator：李明忠
/// CreatDate：2010-11-15
/// Description: 从成本系统为导入数据做准备,生成有效的临时Global
/// Table：
/// Input：newPeriod-期间,Freq-期间类型,ItemCodeStr-需要从成本核算系统获取的指标字符串,UnitCodeStr-需要从成本系统获取的科室字符串,quote-ID对照(格式：1-2-3)
/// Output：
/// Return：返回rs,判断是否执行成功,不成功即回滚
/// Others：w ##class(dhc.bonus.udata.uInterData).ImportCAData("1-2-3")
ClassMethod ImportCAData(newPeriod, Freq, ItemCodeStr, UnitCodeStr, quote) As %String
{
	n (newPeriod,Freq,ItemCodeStr,UnitCodeStr,quote)
	
	s itemLen=$L(ItemCodeStr,"^")
	
	s itemList=##class(%Library.ListOfDataTypes).%New() //定义一个项目集合List
	f k=1:1:itemLen d
	.s ItemCode=$P(ItemCodeStr,"^",k)
	.i ItemCode'="" d
	..d itemList.Insert(ItemCode)
	
	k ^TEMPDHCALXY("dhc","ca","jxzbjk",$j)
	
	TSTART
	s rs=0
	s flag="true"
	
	d ##class(web.RunqianQueryZgydZj).GetPAJxJkZb(quote)

	;s ^TEMPDHCALXY("dhc","ca","jxzbjk",$j,deptcode,type)=deptcode_"^"_deptname_"^"_type_"^"_itemname_"^"_$fn($g(outdata),"",2)
	i $D(^TEMPDHCALXY("dhc","ca","jxzbjk",$j)) d
	.s deptcode=""
	.f  s deptcode=$O(^TEMPDHCALXY("dhc","ca","jxzbjk",$j,deptcode)) q:deptcode=""  d
	..s type=""
	..f  s type=$O(^TEMPDHCALXY("dhc","ca","jxzbjk",$j,deptcode,type)) q:type=""  d
	...i itemList.Find(type,1)'="" d
	....s deptname=$P(^TEMPDHCALXY("dhc","ca","jxzbjk",$j,deptcode,type),"^",2)
	....s itemname=$P(^TEMPDHCALXY("dhc","ca","jxzbjk",$j,deptcode,type),"^",4)
	....s actValue=$P(^TEMPDHCALXY("dhc","ca","jxzbjk",$j,deptcode,type),"^",5)
	....s period=newPeriod
	....s periodType=Freq
	....s unitType="L"
	....s active="Y"
	....s handFlag="N"
	....;w deptcode_"^"_deptname_"^"_unitType_"^"_type_"^"_itemname_"^"_period_"^"_periodType_"^"_actValue_"^"_active_"^"_handFlag,!
	....&SQL(Insert into dhc_bonus_inter.OutKPIData(OutKPIData_outUnitCode,OutKPIData_outUnitName,OutKPIData_unitType,OutKPIData_outKpiCode,OutKPIData_outKpiName,OutKPIData_period,OutKPIData_periodType,OutKPIData_actValue,OutKPIData_active,OutKPIData_handFlag) values(:deptcode,:deptname,:unitType,:type,:itemname,:period,:periodType,:actValue,:active,:handFlag))
	....i SQLCODE'=0 d
	.....s rs=1
	
	k ^TEMPDHCALXY("dhc","ca","jxzbjk",$j)
	
	i rs'=0 d
	.TRollBack
	.s flag="false"
	e  d
	.TCOMMIT
	
	q flag
}

Storage Default
{
<StreamLocation>^dhc.bonus.udata.uInterDataS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
