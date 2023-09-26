/// Creator: 李明忠
/// CreatDate: 2010-10-21
/// Description: 绩效系统指标数据导入
Class dhc.pa.udata.uDataLoad Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator：李明忠
/// CreatDate：2010-10-21
/// Description: 从HIS中导入相关指标数据到绩效系统的临时Global中
/// Table：
/// Input：sDate-起始日期;eDate-终止日期
/// Output：
/// Return：取出所需要的月份数据
/// Others：w ##class(dhc.pa.udata.uDataLoad).LoadHISData("2010-05-01","2010-05-31")
/// Others: 住院：d OutPutIPWorkload^DHCWLInPutCAData("2010-01-01","2010-01-31")
/// Others: 门诊：d OutPutOP^DHCWLInPutCAData("2010-01-01","2010-01-31")
ClassMethod LoadHISData(sDate, eDate) As %String
{
	n (sDate,eDate)
	
	k ^TEMPDHCPA("dhc","pa","inter","his")
	
	//需要处理的指标
	;;1.门诊人次 								HIS 全院、科室、个人
	;;2.住院床日(在院人数) 					HIS 全院、科室、个人
	;;3.床位使用率=在院人数/床数 				HIS 全院、科室
	;;4.出院病人数 							HIS 全院、科室
	;5.手术例数(有的没上手术申请)				HIS 全院、科室、个人
	;6.住院病人增长率 						HIS 全院、科室
	;7.出院病人增长率 						HIS 全院、科室
	;;8.平均住院天数=出院病人总天数/出院病人 	HIS 全院、科室
	;9.复诊率(复诊人数和总门诊数) 			HIS 全院、科室、个人
	
	//执行住院方法
	zn "meddata"    //"DHC-DATA"
	d OutPutIPWorkload^DHCWLInPutCAData(sDate,eDate)
	zn "websrc"     //"DHC-APP"
	//从临时Global中取出数据
	//^DHCCJXPATEMP("dhc","ca","hisdataIP",$j,row)=日期^病人科室代码^病人科室名称^床位数^出院人数^出院人数住院天数^在院人数
	//^DHCCJXPATEMP("dhc","ca","hisdataIP",$j,Num)=$zd(day,3)_"^"_locdr_"^"_locdesc_"^"_bednum_"^"_cyrs_"^"_days_"^"_zyrs
	i $d(^DHCCJXPATEMP("dhc","ca","hisdataIP",$j)) d
	.s row=0
	.f  s row=$O(^DHCCJXPATEMP("dhc","ca","hisdataIP",$j,row)) q:row=""  d
	..s Curr=$G(^DHCCJXPATEMP("dhc","ca","hisdataIP",$j,row))
	..i Curr'="" d ;每天的记录
	...s date=$P(Curr,"^",1) ;取日期并处理成月份的形式
	...i date'="" d
	....s monthCode=$P(date,"-",1)_$P(date,"-",2)
	....s locName=$P(Curr,"^",3) ;取病人科室名称
	....s bedNum=$P(Curr,"^",4) ;取床位数
	....s cyrs=$P(Curr,"^",5) ;取出院人数(出院病人数)
	....s cyrDays=$P(Curr,"^",6) ;取出院人数住院天数
	....s zyrs=$P(Curr,"^",7) ;取在院人数
	....i $D(^TEMPDHCPA("dhc","pa","inter","his",monthCode,locName)) d
	.....s tempCurr=$G(^TEMPDHCPA("dhc","pa","inter","his",monthCode,locName))
	.....s ^TEMPDHCPA("dhc","pa","inter","his",monthCode,locName)=(bedNum+$P(tempCurr,"^",1))_"^"_(cyrs+$P(tempCurr,"^",2))_"^"_(cyrDays+$P(tempCurr,"^",3))_"^"_(zyrs+$P(tempCurr,"^",4))
	....e  d
	.....s ^TEMPDHCPA("dhc","pa","inter","his",monthCode,locName)=bedNum_"^"_cyrs_"^"_cyrDays_"^"_zyrs
	
	//执行门诊方法
	zn "meddata"   //"DHC-DATA"
	d OutPutOP^DHCWLInPutCAData(sDate,eDate)
	zn "websrc"    //"DHC-APP"
	//^DHCCJXPATEMP("dhc","ca","hisdatain",$j,Num)=日期^病人科室代码^病人科室名称^数量(门诊人次)
	//^DHCCJXPATEMP("dhc","ca","hisdatain",$j,Num)=$zd(day,3)_"^"_locdr_"^"_locdesc_"^"_$g(^tempDHCWL($j,"Loc",locdr,"Counts"))
	i $D(^DHCCJXPATEMP("dhc","ca","hisdatain")) d
	.s row=0
	.f  s row=$O(^DHCCJXPATEMP("dhc","ca","hisdatain",$j,row)) q:row=""  d
	..s Curr=$G(^DHCCJXPATEMP("dhc","ca","hisdatain",$j,row))
	..i Curr'="" d ;每天的记录
	...s date=$P(Curr,"^",1) ;取日期并处理成月份的形式
	...i date'="" d
	....s monthCode=$P(date,"-",1)_$P(date,"-",2)
	....s locName=$P(Curr,"^",3) ;取病人科室名称
	....s count=$P(Curr,"^",4) ;取门诊人次
	....i $D(^TEMPDHCPA("dhc","pa","inter","his",monthCode,locName)) d
	.....s tempCurr=$G(^TEMPDHCPA("dhc","pa","inter","his",monthCode,locName))
	....e  d
	.....s tempCurr="^^^"
	....s ^TEMPDHCPA("dhc","pa","inter","his",monthCode,locName)=tempCurr_"^"_count
	
	//k ^TEMPDHCPA("dhc","pa","inter","his")
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.uDataLoadS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
