/// 名称: DHCWL.MKPIService.MKPIQuery
/// 描述: 指标区间数据的查询
/// 编写者：mgl
/// 编写日期:2015-8-4
/// 
Class DtPortal.OD.OD07VisitTotal Extends %RegisteredObject [ Not ProcedureBlock ]
{

// OD07.01.01查询指标数据的明细信息	

// 入参 type  1-查询只输出全院信息 2-输出科室信息

// 出参 per1-复诊率 per2-单纯开药率   per3-输液率   per4-抗菌药使用率

// d ##class(%ResultSet).RunQuery("DtPortal.OD.OD07VisitTotal","OD070101","2019-02-01","2019-02-28","1")

Query OD070101(startDate As %String, endDate As %String, type As %String, filterType As %String = "", hospitalID As %String = "") As DtPortal.Query(ROWSPEC = "locdesc,per1,per2,per3,per4") [ SqlProc ]
{
}

ClassMethod OD070101Execute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, type As %String, filterType As %String = "", hospitalID As %String = "") As %Status
{
	n (qHandle,startDate,endDate,type,filterType,hospitalID)
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	k ^||TEMPOD070101($j)
	//SK0211:PatLoc-门诊人次
	//SK0217:PatLoc-复诊人数
	//SK0239:PatLoc-单纯开药
	//KP1235:patLoc^admType-门急诊输液人数
	//KP1232:patLoc^admType-门急诊抗菌药物人次
	
	//默认只查询门诊
	i filterType="" s filterType="O"
	s kpiRule="SK0211:PatLoc,SK0217:PatLoc,SK0239:PatLoc,KP1235:patLoc,KP1232:patLoc"
	s filterRule=""
	i hospitalID="" s filterRule="SK0211:({AdmType.Node}="_filterType_"),SK0217:({AdmType.Node}="_filterType_"),SK0239:({AdmType.Node}="_filterType_"),KP1235:({admType.Node}="_filterType_"),KP1232:({admType.Node}="_filterType_")"
	e  s filterRule="SK0211:([{AdmType.Node}="_filterType_"]&&[{PatLoc.HospIdByLoc} ="_hospitalID_"]),SK0217:({AdmType.Node}="_filterType_"]&&[{PatLoc.HospIdByLoc} ="_hospitalID_"]),SK0239:({AdmType.Node}="_filterType_"]&&[{PatLoc.HospIdByLoc} ="_hospitalID_"]),KP1235:({admType.Node}="_filterType_"]&&[{PatLoc.HospIdByLoc} ="_hospitalID_"]),KP1232:({admType.Node}="_filterType_"]&&[{PatLoc.HospIdByLoc} ="_hospitalID_"])"

	s contract=""
	s mode="H"
	s dateType=""	

	s rs=##class(DHCWL.util.UniteQueryData).GetQueryDateRef("DHCWL.MKPIService.MKPIQuery:KpiQueryGrideShow",startDate,endDate,dateType,kpiRule,filterRule,mode,contract)
	
	if type=1 {
		While rs.Next(.sc) {
			If $$$ISERR(sc) Quit
			set locid="all"
			set locdesc="全院"

			set ^||TEMPOD070101($j,locid,"desc")=locdesc

			set ^||TEMPOD070101($j,locid,"OutPatients")=$g(^||TEMPOD070101($j,locid,"OutPatients"))+rs.Data("kpiValueCol1")
			set ^||TEMPOD070101($j,locid,"OPRevisit")=$g(^||TEMPOD070101($j,locid,"OPRevisit"))+rs.Data("kpiValueCol2")
			set ^||TEMPOD070101($j,locid,"medicine")=$g(^||TEMPOD070101($j,locid,"medicine"))+rs.Data("kpiValueCol3")
			set ^||TEMPOD070101($j,locid,"outpTrans")=$g(^||TEMPOD070101($j,locid,"outpTrans"))+rs.Data("kpiValueCol4")
			set ^||TEMPOD070101($j,locid,"ant")=$g(^||TEMPOD070101($j,locid,"ant"))+rs.Data("kpiValueCol5")

		}
	}
	
	if type=2 {
		While rs.Next(.sc) {
			If $$$ISERR(sc) Quit
			set locid=rs.Data("dimIdCol1") 
			set locdesc=rs.Data("dimDesCol1")

			set ^||TEMPOD070101($j,locid,"OutPatients")=$g(^||TEMPOD070101($j,locid,"OutPatients"))+rs.Data("kpiValueCol1")
			set ^||TEMPOD070101($j,locid,"OPRevisit")=$g(^||TEMPOD070101($j,locid,"OPRevisit"))+rs.Data("kpiValueCol2")
			set ^||TEMPOD070101($j,locid,"medicine")=$g(^||TEMPOD070101($j,locid,"medicine"))+rs.Data("kpiValueCol3")
			set ^||TEMPOD070101($j,locid,"outpTrans")=$g(^||TEMPOD070101($j,locid,"outpTrans"))+rs.Data("kpiValueCol4")
			set ^||TEMPOD070101($j,locid,"ant")=$g(^||TEMPOD070101($j,locid,"ant"))+rs.Data("kpiValueCol5")

		}

		
	}
	
	
	s locid=0 f  s locid=$o(^||TEMPOD070101($j,locid)) q:locid=""  d
	.s OutPatientsnub=$g(^||TEMPOD070101($j,locid,"OutPatients"))
	.q:+OutPatientsnub=0
	.s OPRevisitnub=$g(^||TEMPOD070101($j,locid,"OPRevisit"))
	.i OPRevisitnub="" s OPRevisitnub=0
	.s medicinenub=$g(^||TEMPOD070101($j,locid,"medicine"))
	.i medicinenub="" s medicinenub=0
	.s outpTransnub=$g(^||TEMPOD070101($j,locid,"outpTrans"))
	.i outpTransnub="" s outpTransnub=0
	.s antnub=$g(^||TEMPOD070101($j,locid,"ant"))
	.i antnub="" s antnub=0
	.q:OPRevisitnub+medicinenub+outpTransnub+antnub=0
	.s per1=$fn(OPRevisitnub/OutPatientsnub*100,"",2)
	.s per1=per1_"%"
	.s per2=$fn(medicinenub/OutPatientsnub*100,"",2)
	.s per2=per2_"%"
	.s per3=$fn(outpTransnub/OutPatientsnub*100,"",2)
	.s per3=per3_"%"
	.s per4=$fn(antnub/OutPatientsnub*100,"",2)
	.s per4=per4_"%"
	.i locid="all" s locdesc="汇总"
	.e  s locdesc=##class(DtPortal.Common.PublicService).getLocDesc(locid)
	.s ^||CacheTemp(repid,ind)=$lb(locdesc,per1,per2,per3,per4)
 	.s ind=ind+1
	
	
	k ^||TEMPOD070101($j)
	Quit $$$OK
}

}
