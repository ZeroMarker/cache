/// 名称: DHCWL.MKPIService.MKPIQuery
/// 描述: 指标区间数据的查询
/// 编写者：mgl
/// 编写日期:2015-8-4
/// 
Class DtPortal.DD.DD15MedicalRanges Extends %RegisteredObject [ ProcedureBlock ]
{

// DD15.01.01按月查询科室内门诊医生使用抗菌药物排名    	

// 	d ##class(%ResultSet).RunQuery("DtPortal.DD.DD15MedicalRanges","DD150101","ys01","I*110||O*7","2018-12-01","2019-12-01")

Query DD150101(userCode As %String, locGroupId As %String, startDate As %String, endDate As %String) As DtPortal.Query(ROWSPEC = "doctorNo:%String,doctor:%String,OPAntiPatPerc:%Float") [ SqlProc ]
{
}

ClassMethod DD150101Execute(ByRef qHandle As %Binary, userCode As %String, locGroupId As %String, startDate As %String, endDate As %String) As %Status
{
    
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	k ^||tempDD150101
	
	s dateType="",mode="H",contract=""
	
	set locIDStr=##class(DtPortal.DD.DD00PublicService).getDDloc(locGroupId,"O")
	q:locIDStr="" $$$OK
	s locIDStr=$tr(locIDStr,"^",",")
	
	s kpiRule="KP1234:PatDoc.DocName,KP1232:PatDoc.DocName"
	s filterRule="KP1234:([{admType.Node} = O] && [{patLoc} = "_locIDStr_"]),KP1232:([{admType.Node} = O] && [{patLoc} = "_locIDStr_"])"
	

	s rs=##class(DHCWL.util.UniteQueryData).GetQueryDateRef("DHCWL.MKPIService.MKPIQuery:KpiQueryGrideShow",startDate,endDate,dateType,kpiRule,filterRule,mode,contract)
   
	While rs.Next(.sc) {
		If $$$ISERR(sc) Quit
		set doctorId=rs.Data("dimIdCol1")
		continue:doctorId=""
		
		s ^||tempDD150101(doctorId,"OutPatients")=$g(^||tempDD150101(doctorId,"OutPatients"))+rs.Data("kpiValueCol1")
		s ^||tempDD150101(doctorId,"OPAntiPat")=$g(^||tempDD150101(doctorId,"OPAntiPat"))+rs.Data("kpiValueCol2")
	}

	s docId=0
	for {
		s docId=$o(^||tempDD150101(docId))
		q:docId=""
		s OPAntiPat=+$g(^||tempDD150101(docId,"OPAntiPat"))
		continue:OPAntiPat=0
		s OutPatients=+$g(^||tempDD150101(docId,"OutPatients"))
		s OPAntiPatPerc=""
	    i +OutPatients'=0 s OPAntiPatPerc=OPAntiPat/OutPatients
	    e  s OPAntiPatPerc=0
	    s userCodeTemp=""
	    s docDesc=$P($g(^CTPCP(docId,1)),"^",2)
	    if docId'="" {
		  s userid=$O(^SSU("SSUSR",0,"CTPCP",docId,0))
		  i userid'=""  s userCodeTemp=$p(^SSU("SSUSR",userid),"^",1)
		}
		set OPAntiPatPerc1=$fn(OPAntiPatPerc*100,"",2)_"%"
		set ^||CacheTemp(repid,ind)=$lb(userCodeTemp,docDesc,OPAntiPatPerc1)
 		set ind=ind+1
	}
	
	k ^||tempDD150101

	Quit $$$OK
}

// DD15.01.02按月查询科室内住院医生使用抗菌药物排名   	

// d ##class(%ResultSet).RunQuery("DtPortal.DD.DD15MedicalRanges","DD150102","ys01","I*110^3^93||O*7","2019-02-01","2019-02-28")

Query DD150102(userCode As %String, locGroupId As %String, startDate As %String, endDate As %String) As DtPortal.Query(ROWSPEC = "doctorNo:%String,doctor:%String,usage:%Float,DDD:%Float") [ SqlProc ]
{
}

ClassMethod DD150102Execute(ByRef qHandle As %Binary, userCode As %String, locGroupId As %String, startDate As %String, endDate As %String) As %Status
{
	
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	
	
	k ^||tempDD150102
	s dateType="",mode="H",contract=""
	set locIDStr=##class(DtPortal.DD.DD00PublicService).getDDloc(locGroupId,"I")
	q:locIDStr="" $$$OK
	s locIDStr=$tr(locIDStr,"^",",")
	//KP1261出院人数
	//kp1259出院使用抗菌药物人数
	//KP1247出院病人抗菌药物DDD
	//KP1248出院患者住院天数
	s kpiRule="KP1261:admDoc,KP1259:admDoc,KP1247:admDoc,KP1248:admDoc"
	s filterRule="KP1261:([{disLoc} = "_locIDStr_"]),KP1259:([{disLoc} = "_locIDStr_"]),KP1247:([{disLoc} = "_locIDStr_"]),KP1248:([{disLoc} = "_locIDStr_"])"	
	s rs=##class(DHCWL.util.UniteQueryData).GetQueryDateRef("DHCWL.MKPIService.MKPIQuery:KpiQueryGrideShow",startDate,endDate,dateType,kpiRule,filterRule,mode,contract)

	While rs.Next(.sc) {
		If $$$ISERR(sc) Quit
		set doctorId=rs.Data("dimIdCol1")
		continue:doctorId=""
		
		s ^||tempDD150102(doctorId,"ipnum")=$g(^||tempDD150102(doctorId,"ipnum"))+rs.Data("kpiValueCol1")  ;出院人次
		s ^||tempDD150102(doctorId,"antnum")=$g(^||tempDD150102(doctorId,"antnum"))+rs.Data("kpiValueCol2")	;抗菌药物使用人次
		s ^||tempDD150102(doctorId,"DDDs")=$g(^||tempDD150102(doctorId,"DDDs"))+rs.Data("kpiValueCol3")	;抗菌药物DDD
		s ^||tempDD150102(doctorId,"days")=$g(^||tempDD150102(doctorId,"days"))+rs.Data("kpiValueCol4")	;住院天数
	}
	
	b
	s docId=0
	for {
		s docId=$o(^||tempDD150102(docId))
		quit:docId=""
		s ipnum=$g(^||tempDD150102(docId,"ipnum"))
		s antnum=$g(^||tempDD150102(docId,"antnum"))
		continue:antnum=0   //抗菌药人数为0过滤
		s DDDs=$g(^||tempDD150102(docId,"DDDs"))
		s days=$g(^||tempDD150102(docId,"days"))

		s antStrength=(DDDs/days)*100             ;抗菌药使用强度
		s antStrength=$fn(antStrength,"",2)
		s usage=""
		i (+ipnum'=0) {
			s usage=(antnum/ipnum)*100
			s usage=$fn(usage,"",2)_"%"
		}

		s userCodeTemp=""
	    s docDesc=$P($g(^CTPCP(docId,1)),"^",2)
	    if docId'="" {
		  s userid=$O(^SSU("SSUSR",0,"CTPCP",docId,0))
		  i userid'=""  s userCodeTemp=$p(^SSU("SSUSR",userid),"^",1)
		}
		//antStrength抗菌药使用强度
		set ^||CacheTemp(repid,ind)=$lb(userCodeTemp,docDesc,usage,antStrength)
 		set ind=ind+1
	}
	
	
	k ^||tempDD150102

	Quit $$$OK
}

// DD15.02.01按月查询科室内门诊使用抗菌药物排名 	

// d ##class(%ResultSet).RunQuery("DtPortal.DD.DD15MedicalRanges","DD150201","0171","I*110||O*7","2018-12-01","2019-12-01","I")

/// findType   I-住院   O-门诊
Query DD150201(userCode As %String, locGroupId As %String, startDate As %String, endDate As %String, findType As %String = "") As DtPortal.Query(ROWSPEC = "name:%String,DDDs:%Float,income:%Float,num:%Float,spec:%String") [ SqlProc ]
{
}

ClassMethod DD150201Execute(ByRef qHandle As %Binary, userCode As %String, locGroupId As %String, startDate As %String, endDate As %String, findType As %String = "") As %Status
{
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	k ^||tempDD150201
	
	q:(findType'="I")&&(findType'="O") $$$OK
	
	s dateType="byMonth",mode="H",contract=""
	set locIDStr=##class(DtPortal.DD.DD00PublicService).getDDloc(locGroupId,findType)
	q:locIDStr="" $$$OK
	s locIDStr=$tr(locIDStr,"^",",")
	
	
	//KP1242  门急诊药物消耗DDD数
	//KP1240  门急诊药品消耗金额
	//KP1241  门急诊药物消耗数量
	
	//KP1243住院抗菌药物消耗DDD数
	//KP1244住院药品消耗金额
	//KP1245住院药物消耗数量
	
	s kpiRule="",filterRule=""
	if (findType="O"){
		s kpiRule="KP1242:arcimId.P009,KP1240:arcimId.P009,KP1241:arcimId.P009"  
		s filterRule="KP1242:({arcimId.P002}=1)&&({admType.Node} = O)&&({ordLoc}="_locIDStr_"),KP1240:({arcimId.P002}=1)&&({admType.Node} = O)&&({ordLoc}="_locIDStr_"),KP1241:({arcimId.P002}=1)&&({admType.Node} = O)&&({ordLoc}="_locIDStr_")"
	}elseif(findType="I"){
		s kpiRule="KP1243:arcimId.P009,KP1244:arcimId.P009,KP1245:arcimId.P009"
		s filterRule="KP1243:({arcimId.P002}=1)&&({ordLoc}="_locIDStr_"),KP1244:({arcimId.P002}=1)&&({ordLoc}="_locIDStr_"),KP1245:({arcimId.P002}=1)&&({ordLoc}="_locIDStr_")"

	}
	
	
	s rs=##class(DHCWL.util.UniteQueryData).GetQueryDateRef("DHCWL.MKPIService.MKPIQuery:KpiQueryGrideShow",startDate,endDate,dateType,kpiRule,filterRule,mode,contract)

	While rs.Next(.sc) {
		If $$$ISERR(sc) Quit
		s arcimID=(rs.Data("dimIdCol1"))
		if arcimID="" continue
	
		
		s ^||tempDD150201(arcimID,"DDDs")=$g(^||tempDD150201(arcimID,"DDDs"))+rs.Data("kpiValueCol1")      ;门急诊药物消耗DDD数
		s ^||tempDD150201(arcimID,"money")=$g(^||tempDD150201(arcimID,"money"))+rs.Data("kpiValueCol2")	;门急诊药品消耗金额
		s ^||tempDD150201(arcimID,"qty")=$g(^||tempDD150201(arcimID,"qty"))+rs.Data("kpiValueCol3")	;门急诊药物消耗数量
	}
	
	//b ;09f
	
	s arcimID=0
	for {
		s arcimID=$o(^||tempDD150201(arcimID))
		quit:arcimID=""
		s arcimDesc=##class(DtPortal.Common.PublicService).GetArcimDesc(arcimID)
		s DDDs=$g(^||tempDD150201(arcimID,"DDDs"))
		s DDDs=$fn(DDDs,"",2)
		s money=$g(^||tempDD150201(arcimID,"money"))
		s money=$fn(money,"",2)
		s qty=$g(^||tempDD150201(arcimID,"qty"))
		s spec=##class(DtPortal.Common.PublicService).GetSpec(arcimID)
		//s ^||CacheTemp(repid,ind)=$lb(arcimDesc,arcimID,DDDs,money,qty,spec)
		set ^||CacheTemp(repid,ind)=$lb(arcimDesc,DDDs,money,qty,spec)
 		s ind=ind+1
	}
	
	k ^||tempDD150201
	Quit $$$OK
}

}
