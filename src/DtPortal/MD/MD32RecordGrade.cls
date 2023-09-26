/// ClassName:    DtPortal.MD.MD32RecordGrade
/// Description:  病历等级相关服务
/// Creator：     chengpeng
/// CreatDate:    2017-08-29
Class DtPortal.MD.MD32RecordGrade Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Creator：     chengpeng
/// CreatDate：   2017-08-29
/// Description:  MD32.01.01 查询某月全院病历等级分布
/// Input		:	StarDate  开始日期(格式:2018-01-01)
/// 			:	EndDate  结束日期(格式:2018-01-31)
/// 			:	HospitalId  院区ID
/// Return：      DtPortal.OutPut
/// set obj=##class(DtPortal.MD.MD32RecordGrade).MD320101("2019-01-01","2019-01-14",2)
/// do $System.OBJ.Dump(obj)
ClassMethod MD320101(StarDate As %String, EndDate As %String, HospitalId As %String = "") As DtPortal.OutPut
{

	Set return=##Class(DtPortal.OutPut).%New()
	
	k ^||TMPPortalMD320101
	Set $ZT="MD320101"
	
	set dateType="byMonth"	
	set kpiRule="DtPortal0011"
	set filterRule=""
	set mode="H"
	set contract=""
	
	set startDate=StarDate
	set endDate=EndDate
	set:$l(StarDate,"-")=3 startDate=$p(StarDate,"-",1)_"-"_$p(StarDate,"-",2)
	set:$l(EndDate,"-")=3 endDate=$p(EndDate,"-",1)_"-"_$p(EndDate,"-",2)
	
	s rs=##class(DHCWL.util.UniteQueryData).GetQueryDateRef("DHCWL.MKPIService.MKPIQuery:KpiQueryGrideShow",startDate,endDate,dateType,kpiRule,filterRule,mode,contract)
	
	
	While rs.Next(.sc) {
		If $$$ISERR(sc) Quit
		set mDate=rs.Data("month")
		set mounth=$p($p(mDate,"年",2),"月",1)
		if mounth<10 s mounth=$p(mounth,"0",2)
		set locID=rs.Data("dimIdCol1")
		s HospID=$P($g(^CTLOC(locID)),"^",22)
		if HospitalId'=""
		{
			continue:HospitalId'=HospID
		}
		set grade=rs.Data("dimIdCol3")
		set value=rs.Data("kpiValueCol1")
		if '$d(^||TMPPortalMD320101(grade))
		{
			set ^||TMPPortalMD320101(grade)=value
		}else
		{
			set ^||TMPPortalMD320101(grade)=+^||TMPPortalMD320101(grade)+value
		}
		
	 	
	}
	
	set ret="["
	set gradeIndex=""
	for
	{
		set gradeIndex=$o(^||TMPPortalMD320101(gradeIndex))
		quit:gradeIndex=""
		
		set value=^||TMPPortalMD320101(gradeIndex)
		set name=""
		set name=gradeIndex_"级"
	
		set jsonObj = ##class(DtPortal.Common.JsonObject).%New()
		d jsonObj.Put("name",name)
		d jsonObj.Put("value",value)
		set:ret'="[" ret=ret_","_jsonObj.Json()
		set:ret="[" ret=ret_jsonObj.Json()
		
	}
	set ret=ret_"]"
	Set return.status = 1
	Set return.errMSG = ""
	Set return.data = ret
	
	k ^||TMPPortalMD320101
	Quit return
	
MD320101

	k ^||TMPPortalMD320101
	Set return.status = -1
	Set return.errMSG = $ZE
	b ;err
	Set return.data = ""
	Quit return
}

/// Description	:	MD32.01.02 查询某月各个科室各个病历等级的数量
/// Input		:	StarDate  开始日期(格式:2018-01-01)
/// 			:	EndDate  结束日期(格式:2018-01-31)
/// 			:	HospitalId  院区ID
/// Return		:	
/// 	改为指标出数据
/// do ##class(%Library.ResultSet).RunQuery("DtPortal.MD.MD32RecordGrade","MD320102","2019-01-01","2019-01-14",2)
Query MD320102(StarDate As %String, EndDate As %String, HospitalId As %String = "") As DtPortal.Query(ROWSPEC = "locID,locDesc,value1,value2,value3") [ SqlProc ]
{
}

ClassMethod MD320102Execute(ByRef qHandle As %Binary, StarDate As %String, EndDate As %String, HospitalId As %String = "") As %Status
{
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	k ^||TMPPortalMD320102
			
	s dateType="byMonth"	
	s kpiRule="DtPortal0011"
	s filterRule=""
	s mode="H"
	s contract=""

	s startDate=StarDate
	s endDate=EndDate
	
	s rs=##class(DHCWL.util.UniteQueryData).GetQueryDateRef("DHCWL.MKPIService.MKPIQuery:KpiQueryGrideShow",startDate,endDate,dateType,kpiRule,filterRule,mode,contract)
	
	
	set itemStr=""
	While rs.Next(.sc) {
		If $$$ISERR(sc) Quit
		set mDate=rs.Data("month")
		set mounth=$p($p(mDate,"年",2),"月",1)
		if mounth<10 s mounth=$p(mounth,"0",2)
		set locID=rs.Data("dimIdCol1")
		s HospID=$P($g(^CTLOC(locID)),"^",22)
		if HospitalId'=""
		{
			continue:HospitalId'=HospID
		}
		set grade=rs.Data("dimIdCol3")
		set value=rs.Data("kpiValueCol1")
		if '$d(^||TMPPortalMD320102(locID,grade))
		{
			set ^||TMPPortalMD320102(locID,grade)=value
		}else
		{
			set ^||TMPPortalMD320102(locID,grade)=+^||TMPPortalMD320102(locID,grade)+value
		}
		
	 	
	}
	
	set locID=""
	for
	{
		set locID=$o(^||TMPPortalMD320102(locID))
		quit:locID=""
		
		set value1=$g(^||TMPPortalMD320102(locID,"甲"))
		set value2=$g(^||TMPPortalMD320102(locID,"乙"))
		set value3=$g(^||TMPPortalMD320102(locID,"丙"))
		
		set:value1="" value1=0
		set:value2="" value2=0
		set:value3="" value3=0
		
		set locDesc=$p(^CTLOC(locID),"^",2)
		set:locDesc["-" locDesc=$p(locDesc,"-",2)
		s ^||CacheTemp(repid,ind)=$lb(locID,locDesc,value1,value2,value3)
	 	s ind=ind+1
	}
	
	k ^||TMPPortalMD320102
	Quit $$$OK
}

/// Description	:	MD32.01.03 查询某月某科室各个主管医生病历等级的数量
/// Input		:	StarDate  开始日期(格式:2018-01-01)
/// 			:	EndDate  结束日期(格式:2018-01-31)
/// 			:	HospitalId  院区ID
/// Return		:	
/// 	改为指标出数据
/// do ##class(%Library.ResultSet).RunQuery("DtPortal.MD.MD32RecordGrade","MD320103","2019-01-01","2019-01-14",110)
Query MD320103(StarDate As %String, EndDate As %String, LocID As %String) As DtPortal.Query(ROWSPEC = "admDoc,docCode,docDesc,value1,value2,value3") [ SqlProc ]
{
}

ClassMethod MD320103Execute(ByRef qHandle As %Binary, StarDate As %String, EndDate As %String, LocID As %String) As %Status
{
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	k ^||TMPPortalMD320103
			
	s dateType="byMonth"	
	s kpiRule="DtPortal0011"
	s filterRule=""
	s mode="H"
	s contract=""

	s startDate=StarDate
	s endDate=EndDate
	
	s rs=##class(DHCWL.util.UniteQueryData).GetQueryDateRef("DHCWL.MKPIService.MKPIQuery:KpiQueryGrideShow",startDate,endDate,dateType,kpiRule,filterRule,mode,contract)
	
	
	set itemStr=""
	While rs.Next(.sc) {
		If $$$ISERR(sc) Quit
		set mDate=rs.Data("month")
		set mounth=$p($p(mDate,"年",2),"月",1)
		if mounth<10 s mounth=$p(mounth,"0",2)
		set locID=rs.Data("dimIdCol1")
		continue:LocID'=locID
	
		set admDoc=rs.Data("dimIdCol2")
		set grade=rs.Data("dimIdCol3")
		
		continue:(admDoc="")||(grade="")
		
		set value=rs.Data("kpiValueCol1")
		if '$d(^||TMPPortalMD320103(admDoc,grade))
		{
			set ^||TMPPortalMD320103(admDoc,grade)=value
		}else
		{
			set ^||TMPPortalMD320103(admDoc,grade)=+^||TMPPortalMD320103(admDoc,grade)+value
		}
		
	 	
	}
	
	set admDoc=""
	for
	{
		set admDoc=$o(^||TMPPortalMD320103(admDoc))
		quit:admDoc=""
		
		set value1=$g(^||TMPPortalMD320103(admDoc,"甲"))
		set value2=$g(^||TMPPortalMD320103(admDoc,"乙"))
		set value3=$g(^||TMPPortalMD320103(admDoc,"丙"))
		
		set:value1="" value1=0
		set:value2="" value2=0
		set:value3="" value3=0
		
		set docCode=$p(^CTPCP(admDoc,1),"^",1)
		set docDesc=$p(^CTPCP(admDoc,1),"^",2)
		s ^||CacheTemp(repid,ind)=$lb(admDoc,docCode,docDesc,value1,value2,value3)
	 	s ind=ind+1
	}
	
	k ^||TMPPortalMD320103
	Quit $$$OK
}

}
