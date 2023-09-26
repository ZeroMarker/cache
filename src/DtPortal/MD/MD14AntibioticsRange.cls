Class DtPortal.MD.MD14AntibioticsRange Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// MD14.01.01查询本院一段时间内住院科室使用抗菌药物排名
/// /d ##class(%ResultSet).RunQuery("DtPortal.MD.MD14AntibioticsRange","MD140101InPatRanges","2017-07-01","2017-09-26")
/// /d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.MKPIQuery","KpiQueryGrideShow","2017-07-01","2017-07-26","byMonth","KP1261:disWard,KP1259:disWard,KP1247:disWard","","R","")
Query MD140101InPatRanges(startDate As %String, endDate As %String, hospitalId As %String = "") As DtPortal.Query(ROWSPEC = "wardId,wardDesc,antStrength,usage") [ SqlProc ]
{
}

ClassMethod MD140101InPatRangesExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, hospitalId As %String = "") As %Status
{
	n (qHandle,startDate,endDate, hospitalId)
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	//s ^bmz("222")=startDate_"^"_endDate
	//KP1261出院人数
	//kp1259出院使用抗菌药物人数
	//KP1247出院病人抗菌药物DDD
	s dateType=""
	s kpiRule="KP1261:disWard,KP1259:disWard,KP1247:disWard,KP1248:disWard"
	S filterRule=""
	i hospitalId'="" S filterRule="KP1261:({disWard.HospIdByWard}="_hospitalId_"),KP1259:({disWard.HospIdByWard}="_hospitalId_"),KP1247:({disWard.HospIdByWard}="_hospitalId_"),KP1248:({disWard.HospIdByWard}="_hospitalId_")"
	
	S mode="H"
	S contract=""
	k ^tempMD140101($j)
	s rs=##class(DHCWL.util.UniteQueryData).GetQueryDateRef("DHCWL.MKPIService.MKPIQuery:KpiQueryGrideShow",startDate,endDate,dateType,kpiRule,filterRule,mode,contract)
	While rs.Next(.sc) {
		If $$$ISERR(sc) Quit
		;b ;001
		if +$g(rs.Data("kpiValueCol2"))=0 continue
		s wardId=rs.Data("dimIdCol1")
		i wardId="" continue
		s ^tempMD140101($j,wardId,"ipnum")=$g(^tempMD140101($j,wardId,"ipnum"))+rs.Data("kpiValueCol1")      ;出院人次
		s ^tempMD140101($j,wardId,"antnum")=$g(^tempMD140101($j,wardId,"antnum"))+rs.Data("kpiValueCol2")	;抗菌药物使用人次
		s ^tempMD140101($j,wardId,"DDDs")=$g(^tempMD140101($j,wardId,"DDDs"))+rs.Data("kpiValueCol3")		;抗菌药物DDD
		s ^tempMD140101($j,wardId,"days")=$g(^tempMD140101($j,wardId,"days"))+rs.Data("kpiValueCol4")	;住院天数
		
	}
	
	s wardId=0
	for {
		s wardId=$o(^tempMD140101($j,wardId))
		quit:wardId=""
		s ipnum=$g(^tempMD140101($j,wardId,"ipnum"))
		s antnum=$g(^tempMD140101($j,wardId,"antnum"))
		s DDDs=$g(^tempMD140101($j,wardId,"DDDs"))
		s days=$g(^tempMD140101($j,wardId,"days"))
		s wardDesc=$p($g(^PAWARD(wardId)),"^",2)
		i wardDesc["-" s wardDesc=$p(wardDesc,"-",2)
		s antStrength=(DDDs/days)*100             ;抗菌药使用强度
		s antStrength=$fn(antStrength,"",2)
		s usage=""
		i (+ipnum'=0) {
			s usage=(antnum/ipnum)*100
			s usage=$fn(usage,"",2)_"%"
		}
		s ^||CacheTemp(repid,ind)=$lb(wardId,wardDesc,antStrength,usage)
 		s ind=ind+1
	}
	
	k ^tempMD140302($j)
	Quit $$$OK
}

/// MD14.02.01	查询本院一段时间内门诊科室使用抗菌药物排名
/// /d ##class(%ResultSet).RunQuery("DtPortal.MD.MD14AntibioticsRange","MD140201OutPatRanges","2018-03-01","2018-03-30")
/// /d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.MKPIQuery","KpiQueryGrideShow","2014-11-14","2014-11-14","byMonth","KP1234:patLoc,KP1232:patLoc","KP1234:({admType.P001}=门诊),KP1232:({admType.P001}=门诊)","R","")
Query MD140201OutPatRanges(startDate As %String, endDate As %String, hospitalId As %String = "") As DtPortal.Query(ROWSPEC = "locDesc,locId,usage") [ SqlProc ]
{
}

ClassMethod MD140201OutPatRangesExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, hospitalId As %String = "") As %Status
{
	n (qHandle,startDate,endDate,dateType,kpiRule,filterRule,mode,contract, hospitalId)
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	k ^tempMD140201($j)
	//KP1234门急诊人次
	//kp1232门急诊使用抗菌药物人次
	s dateType=""
	s kpiRule="KP1234:patLoc,KP1232:patLoc"
	;S filterRule="KP1234:({admType.P001}=门诊),KP1232:({admType.P001}=门诊)"
	i hospitalId="" S filterRule="KP1234:({admType.P001}=门诊),KP1232:({admType.P001}=门诊)"
	e  S filterRule="KP1234:([{admType.P001}=门诊]&&[{patLoc.LocHospid}="_hospitalId_"]),KP1232:([{admType.P001}=门诊]&&[{patLoc.LocHospid}="_hospitalId_"])"
	
	S mode="H"
	S contract=""
	s num=0
	s rs=##class(DHCWL.util.UniteQueryData).GetQueryDateRef("DHCWL.MKPIService.MKPIQuery:KpiQueryGrideShow",startDate,endDate,dateType,kpiRule,filterRule,mode,contract)
	While rs.Next(.sc) {
		If $$$ISERR(sc) Quit
		w !,rs.Data("month")_"&"_rs.Data("kpiValueCol2")_"&"_rs.Data("kpiValueCol1")
		if +$g(rs.Data("kpiValueCol2"))=0 continue
		s locId=(rs.Data("dimIdCol1"))
		if (+locId=0) continue
		
		s loc=rs.Data("dimDesCol1")
		s ipnum=+$g(rs.Data("kpiValueCol1"))      ;门诊人次
		s antnum=+$G(rs.Data("kpiValueCol2"))      ;门诊抗菌药物使用人次

		
		s ^tempMD140201($j,locId,"opnum")=$g(^tempMD140201($j,locId,"opnum"))+rs.Data("kpiValueCol1")      ;出院人次
		s ^tempMD140201($j,locId,"opantnum")=$g(^tempMD140201($j,locId,"opantnum"))+rs.Data("kpiValueCol2")	;抗菌药物使用人次
		

	}
	
	s locId=0
	for {
		s locId=$o(^tempMD140201($j,locId))
		quit:locId=""
		s opnum=$g(^tempMD140201($j,locId,"opnum"))
		s opantnum=$g(^tempMD140201($j,locId,"opantnum"))
		s usage=""
		i (+opnum'=0) {
			s usage=(opantnum/opnum)*100
			s usage=$fn(usage,"",2)_"%"
		}
		s locDesc=$p($g(^CTLOC(locId)),"^",2)
		i locDesc["-" s locDesc=$p(locDesc,"-",2)
		s ^||CacheTemp(repid,ind)=$lb(locDesc,locId,usage)
 		s ind=ind+1
	}
	k ^tempMD140201($j)
	Quit $$$OK
}

/// MD14.03.01	查询本院一段时间内门诊医生使用抗菌药物排名
/// /d ##class(%ResultSet).RunQuery("DtPortal.MD.MD14AntibioticsRange","MD140301OPDoctorRanges","2018-03-01","2018-04-30","")
/// /d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.MKPIQuery","KpiQueryGrideShow","2014-11-01","2014-11-12","byMonth","KP1234:PatDoc,KP1232:PatDoc","KP1234:({admType.P001}=门诊),KP1232:({admType.P001}=门诊)","R","")
Query MD140301OPDoctorRanges(startDate As %String, endDate As %String, hospitalId As %String = "") As DtPortal.Query(ROWSPEC = "docDesc,docId,usage,userCode") [ SqlProc ]
{
}

ClassMethod MD140301OPDoctorRangesExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, hospitalId As %String = "") As %Status
{
	n (qHandle,startDate,endDate,hospitalId)
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	k ^tempMD140301($j)
	//KP1234门急诊人次
	//kp1232门急诊使用抗菌药物人次
	s dateType=""
	s kpiRule="KP1234:PatDoc,KP1232:PatDoc"
	i hospitalId="" S filterRule="KP1234:({admType.P001}=门诊),KP1232:({admType.P001}=门诊)"
	e  S filterRule="KP1234:([{admType.P001}=门诊]&&[{patLoc.LocHospid}="_hospitalId_"]),KP1232:([{admType.P001}=门诊]&&[{patLoc.LocHospid}="_hospitalId_"])"
	S mode="H"
	S contract=""
	s num=0
	s rs=##class(DHCWL.util.UniteQueryData).GetQueryDateRef("DHCWL.MKPIService.MKPIQuery:KpiQueryGrideShow",startDate,endDate,dateType,kpiRule,filterRule,mode,contract)
	While rs.Next(.sc) {
		If $$$ISERR(sc) Quit
		s docid=(rs.Data("dimIdCol1"))
		if docid="" continue
		s doc=rs.Data("dimDesCol1")
		s ^tempMD140301($j,docid,"opnum")=$g(^tempMD140301($j,docid,"opnum"))+rs.Data("kpiValueCol1")      ;门诊人次
		s ^tempMD140301($j,docid,"opantnum")=$g(^tempMD140301($j,docid,"opantnum"))+rs.Data("kpiValueCol2")	;门诊抗菌药物使用人次
		

	}
	
	s docId=0
	for {
		s docId=$o(^tempMD140301($j,docId))
		quit:docId=""
		s opnum=$g(^tempMD140301($j,docId,"opnum"))
		s opantnum=$g(^tempMD140301($j,docId,"opantnum"))
		continue:opantnum=0   //抗菌药人数为0过滤
		s usage=""
		i (+opnum'=0) {
			s usage=(opantnum/opnum)*100
			s usage=$fn(usage,"",2)_"%"
		}
		
		s userCode=..GetJobNumber(docId)
		
		s docDesc=$P($g(^CTPCP(docId,1)),"^",2)
		
		s ^||CacheTemp(repid,ind)=$lb(docDesc,docId,usage,userCode)
 		s ind=ind+1
	}
	Quit $$$OK
}

/// 通过DocId获取用户工号
/// w ##class("DtPortal.MD.MD14AntibioticsRange").GetJobNumber(292)
ClassMethod GetJobNumber(ctpcpid) As %String
{
	q:+$g(ctpcpid)=0 ""
	
	s ssuserid=$o(^SSU("SSUSR",0,"CTPCP",ctpcpid,0))
	q:ssuserid="" ""
	w ssuserid 
	s jobNum=$p(^SSU("SSUSR",ssuserid),"^",1)
	q jobNum
}

/// MD14.03.02查询本院一段时间内住院医生使用抗菌药物排名
/// /d ##class(%ResultSet).RunQuery("DtPortal.MD.MD14AntibioticsRange","MD140302IPDoctorRanges","2018-03-01","2018-04-30")
/// /d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.MKPIQuery","KpiQueryGrideShow","2014-08-01","2014-08-31","byMonth","KP1261:admDoc,KP1259:admDoc,KP1247:admDoc","","R","")
Query MD140302IPDoctorRanges(startDate As %String, endDate As %String, hospitalId As %String = "") As DtPortal.Query(ROWSPEC = "docDesc,docId,usage,userCode,antStrength") [ SqlProc ]
{
}

ClassMethod MD140302IPDoctorRangesExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, hospitalId As %String = "") As %Status
{
	n (qHandle,startDate,endDate,hospitalId)
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	k ^tempMD140302
	//KP1261出院人数
	//kp1259出院使用抗菌药物人数
	//KP1247出院病人抗菌药物DDD
	s dateType=""
	s kpiRule="KP1261:admDoc,KP1259:admDoc,KP1247:admDoc,KP1248:admDoc"
	S filterRule=""
	
	i hospitalId'="" S filterRule="KP1261:({disWard.HospIdByWard}="_hospitalId_"),KP1259:({disWard.HospIdByWard}="_hospitalId_"),KP1247:({disWard.HospIdByWard}="_hospitalId_"),KP1248:({disWard.HospIdByWard}="_hospitalId_")"
	
	S mode="H"
	S contract=""
	s num=0
	s rs=##class(DHCWL.util.UniteQueryData).GetQueryDateRef("DHCWL.MKPIService.MKPIQuery:KpiQueryGrideShow",startDate,endDate,dateType,kpiRule,filterRule,mode,contract)
	While rs.Next(.sc) {
		If $$$ISERR(sc) Quit
		s docid=(rs.Data("dimIdCol1"))
		if docid=0 continue

		s ^tempMD140302($j,docid,"ipnum")=$g(^tempMD140302($j,docid,"ipnum"))+rs.Data("kpiValueCol1")      ;出院人次
		s ^tempMD140302($j,docid,"antnum")=$g(^tempMD140302($j,docid,"antnum"))+rs.Data("kpiValueCol2")	;抗菌药物使用人次
		s ^tempMD140302($j,docid,"DDDs")=$g(^tempMD140302($j,docid,"DDDs"))+rs.Data("kpiValueCol3")		;抗菌药物DDD
		s ^tempMD140302($j,docid,"days")=$g(^tempMD140302($j,docid,"days"))+rs.Data("kpiValueCol4")	;住院天数
		

	}
	
	
	s docId=0
	for {
		s docId=$o(^tempMD140302($j,docId))
		quit:docId=""
		s ipnum=$g(^tempMD140302($j,docId,"ipnum"))
		s antnum=$g(^tempMD140302($j,docId,"antnum"))
		continue:antnum=0   //抗菌药人数为0过滤
		s DDDs=$g(^tempMD140302($j,docId,"DDDs"))
		s days=$g(^tempMD140302($j,docId,"days"))

		s antStrength=(DDDs/days)*100             ;抗菌药使用强度
		s antStrength=$fn(antStrength,"",2)
		s usage=""
		i (+ipnum'=0) {
			s usage=(antnum/ipnum)*100
			s usage=$fn(usage,"",2)_"%"
		}

		s userCode=..GetJobNumber(docId)
		
		s docDesc=$P($g(^CTPCP(docId,1)),"^",2)
		
		s ^||CacheTemp(repid,ind)=$lb(docDesc,docId,usage,userCode,antStrength)
 		s ind=ind+1
	}
	
	
	Quit $$$OK
}

/// MD14.04.01	查询本院一段时间内门诊、住院抗菌药物使用排名
/// findType   I-住院   O-门诊
/// /d ##class(%ResultSet).RunQuery("DtPortal.MD.MD14AntibioticsRange","MD140401OPMedicalRanges","2018-03-01","2018-05-01","","I")
/// /d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.MKPIQuery","KpiQueryGrideShow","2016-04-01","2016-04-30","","KP1242:arcimId.P001","","R","")
Query MD140401OPMedicalRanges(startDate As %String, endDate As %String, hospitalId As %String = "", findType As %String = "") As DtPortal.Query(ROWSPEC = "arcimDesc,arcimID,DDDs,money,qty,spec") [ SqlProc ]
{
}

ClassMethod MD140401OPMedicalRangesExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, hospitalId As %String = "", findType As %String = "") As %Status
{
	n (qHandle,startDate,endDate,hospitalId,findType)
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	q:(findType'="I")&&(findType'="O") $$$OK
	
	k ^tempMD140401($j)
	//KP1242  门急诊药物消耗DDD数
	//KP1240  门急诊药品消耗金额
	//KP1241  门急诊药物消耗数量
	
	//KP1243住院抗菌药物消耗DDD数
	//KP1244住院药品消耗金额
	//KP1245住院药物消耗数量
	
	s dateType="byMonth"
	
	s kpiRule="",filterRule=""
	if (findType="O"){
		s kpiRule="KP1242:arcimId.P009,KP1240:arcimId.P009,KP1241:arcimId.P009"
		i hospitalId="" S filterRule="KP1242:({arcimId.P002}=1)&&({admType.P001}=门诊),KP1240:({arcimId.P002}=1)&&({admType.P001}=门诊),KP1241:({arcimId.P002}=1)&&({admType.P001}=门诊)"
		e  s filterRule="KP1242:({arcimId.P002}=1)&&({admType.P001}=门诊)&&({ordLoc.LocHospid}="_hospitalId_"),KP1240:({arcimId.P002}=1)&&({admType.P001}=门诊)&&({ordLoc.LocHospid}="_hospitalId_"),KP1241:({arcimId.P002}=1)&&({admType.P001}=门诊)&&({ordLoc.LocHospid}="_hospitalId_")"
	}elseif(findType="I"){
		s kpiRule="KP1243:arcimId.P009,KP1244:arcimId.P009,KP1245:arcimId.P009"
		i hospitalId="" S filterRule="KP1243:({arcimId.P002}=1),KP1244:({arcimId.P002}=1),KP1245:({arcimId.P002}=1)"
		e  s filterRule="KP1243:({arcimId.P002}=1)&&({ordLoc.LocHospid}="_hospitalId_"),KP1244:({arcimId.P002}=1)&&({ordLoc.LocHospid}="_hospitalId_"),KP1245:({arcimId.P002}=1)&&({ordLoc.LocHospid}="_hospitalId_")"

	}

	S mode="H"
	S contract=""
	s num=0
	s rs=##class(DHCWL.util.UniteQueryData).GetQueryDateRef("DHCWL.MKPIService.MKPIQuery:KpiQueryGrideShow",startDate,endDate,dateType,kpiRule,filterRule,mode,contract)
	While rs.Next(.sc) {
		If $$$ISERR(sc) Quit 
		s arcimID=(rs.Data("dimIdCol1"))
		if arcimID="" continue
	
		
		s ^tempMD140401($j,arcimID,"DDDs")=$g(^tempMD140401($j,arcimID,"DDDs"))+rs.Data("kpiValueCol1")      ;门急诊药物消耗DDD数
		s ^tempMD140401($j,arcimID,"money")=$g(^tempMD140401($j,arcimID,"money"))+rs.Data("kpiValueCol2")	;门急诊药品消耗金额
		s ^tempMD140401($j,arcimID,"qty")=$g(^tempMD140401($j,arcimID,"qty"))+rs.Data("kpiValueCol3")	;门急诊药物消耗数量

	}
	
	
	s arcimID=0
	for {
		s arcimID=$o(^tempMD140401($j,arcimID))
		quit:arcimID=""
		s arcimDesc=##class(DtPortal.Common.PublicService).GetArcimDesc(arcimID)
		s DDDs=$g(^tempMD140401($j,arcimID,"DDDs"))
		s DDDs=$fn(DDDs,"",2)
		s money=$g(^tempMD140401($j,arcimID,"money"))
		s money=$fn(money,"",2)
		s qty=$g(^tempMD140401($j,arcimID,"qty"))
		s spec=##class(DtPortal.Common.PublicService).GetSpec(arcimID)
		s ^||CacheTemp(repid,ind)=$lb(arcimDesc,arcimID,DDDs,money,qty,spec)
 		s ind=ind+1
	}
	
	Quit $$$OK
}

}
