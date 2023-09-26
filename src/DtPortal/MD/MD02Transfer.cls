/// 名称: DtPortal.MD.MD02Transfer
/// 描述: 出入转	
/// 编写者：yupeng
/// 编写日期:2019-01-17
/// 
Class DtPortal.MD.MD02Transfer Extends %RegisteredObject [ Not ProcedureBlock ]
{

// MD02.01.01查询指定时间内出入转病人科室分布	

// d ##class(%ResultSet).RunQuery("DtPortal.MD.MD02Transfer","MD020101","2019-01-01","2019-01-17","")

Query MD020101(startDate As %String, endDate As %String, hospitalId As %String = "") As DtPortal.Query(ROWSPEC = "dep:%String,RYRS:%Float,CYRS:%Float,ZRRS:%Float,ZCRS:%Float,QCRS:%Float,QMRS:%Float,CWSYL:%Float") [ SqlProc ]
{
}

ClassMethod MD020101Execute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, hospitalId As %String = "") As %Status
{
	n (qHandle,startDate,endDate,hospitalId)
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	k ^TEMPDHCWL($j)
	s QiChuDate=$zd(($zdh(startDate,3)-1),3)  //期初日期
	s QiMoDate=$zd($zdh(endDate,3),3)  //期末日期
	s dateType="byDay"
	set RYRS=0,CYRS=0,ZRRS=0,ZCRS=0,XYRS=0,QCRS=0,QCMS=0,CWS=0
	//实有床位（SK0143:PatLoc），现有人数（SK0142:PatLoc),入院人数（SK0137:PatLoc），
	//转入人数（SK0138:PatLoc）,转出人数（SK0139:PatLoc）,出院人数（SK0224:PatLoc）
	s kpiRule="SK0143:PatLoc,SK0142:PatLoc,SK0137:PatLoc,SK0138:PatLoc,SK0139:PatLoc,SK0224:PatLoc"
	S filterRule=""
	i hospitalId'="" S filterRule="SK0143:({PatLoc.HospIdByLoc}="_hospitalId_"),"_"SK0142:({PatLoc.HospIdByLoc}="_hospitalId_"),"_"SK0137:({PatLoc.HospIdByLoc}="_hospitalId_"),"_"SK0138:({PatLoc.HospIdByLoc}="_hospitalId_"),"_"SK0139:({PatLoc.HospIdByLoc}="_hospitalId_"),"_"SK0224:({PatLoc.HospIdByLoc}="_hospitalId_")"
	s mode="H"
	s contract=""
	s rs=##class(DHCWL.util.UniteQueryData).GetQueryDateRef("DHCWL.MKPIService.MKPIQuery:KpiQueryGrideShow",startDate,endDate,dateType,kpiRule,filterRule,mode,contract)
	While rs.Next(.sc) {
		If $$$ISERR(sc) Quit
		s depdesc=rs.Data("dimDesCol1")
		s ^TEMPDHCWL($j,depdesc,"RYRS")=$g(^TEMPDHCWL($j,depdesc,"RYRS"))+$g(rs.Data("kpiValueCol3")) //入院人数
		s ^TEMPDHCWL($j,depdesc,"CYRS")=$g(^TEMPDHCWL($j,depdesc,"CYRS"))+$g(rs.Data("kpiValueCol6")) //出院人数
		s ^TEMPDHCWL($j,depdesc,"ZRRS")=$g(^TEMPDHCWL($j,depdesc,"ZRRS"))+$g(rs.Data("kpiValueCol4")) //转入人数
		s ^TEMPDHCWL($j,depdesc,"ZCRS")=$g(^TEMPDHCWL($j,depdesc,"ZCRS"))+$g(rs.Data("kpiValueCol5")) //转出人数
		s ^TEMPDHCWL($j,depdesc,"XYRS")=$g(^TEMPDHCWL($j,depdesc,"XYRS"))+$g(rs.Data("kpiValueCol2")) //现有人数
		s ^TEMPDHCWL($j,depdesc,"CWS")=$g(^TEMPDHCWL($j,depdesc,"CWS"))+$g(rs.Data("kpiValueCol1")) //实有床位
	
	}
	s kpiRule="SK0142:PatLoc" //现有人数
	i hospitalId'="" S filterRule="SK0142:({PatLoc.HospIdByLoc}="_hospitalId_")"
	s rs=##class(DHCWL.util.UniteQueryData).GetQueryDateRef("DHCWL.MKPIService.MKPIQuery:KpiQueryGrideShow",QiChuDate,QiChuDate,dateType,kpiRule,filterRule,mode,contract)
	While rs.Next(.sc) {
		If $$$ISERR(sc) Quit
		s depdesc=rs.Data("dimDesCol1")
		s ^TEMPDHCWL($j,depdesc,"QCRS")=rs.Data("kpiValueCol1") //期初人数
	}
	s rs=##class(DHCWL.util.UniteQueryData).GetQueryDateRef("DHCWL.MKPIService.MKPIQuery:KpiQueryGrideShow",QiMoDate,QiMoDate,dateType,kpiRule,filterRule,mode,contract)
	While rs.Next(.sc) {
		If $$$ISERR(sc) Quit
		s depdesc=rs.Data("dimDesCol1")
		s ^TEMPDHCWL($j,depdesc,"QMRS")=rs.Data("kpiValueCol1") //期末人数
	}
	s dep="" f  s dep=$o(^TEMPDHCWL($j,dep)) q:dep=""  d
	.s RYRS=$g(^TEMPDHCWL($j,dep,"RYRS")) //入院人数
	.i RYRS="" s RYRS=0
	.s CYRS=$g(^TEMPDHCWL($j,dep,"CYRS")) //出院人数
	.i CYRS="" s CYRS=0
	.s ZRRS=$g(^TEMPDHCWL($j,dep,"ZRRS")) //转入人数
	.i ZRRS="" s ZRRS=0
	.s ZCRS=$g(^TEMPDHCWL($j,dep,"ZCRS")) //转出人数
	.i ZCRS="" s ZCRS=0
	.s XYRS=$g(^TEMPDHCWL($j,dep,"XYRS")) //现有人数
	.i XYRS="" s XYRS=0
	.s QCRS=$g(^TEMPDHCWL($j,dep,"QCRS")) //期初人数
	.i QCRS="" s QCRS=0
	.s QMRS=$g(^TEMPDHCWL($j,dep,"QMRS")) //期末人数
	.i QMRS="" s QMRS=0
	.q:(RYRS=0)&&(CYRS=0)&&(ZRRS=0)&&(ZCRS=0)&&(XYRS=0)&&(QCRS=0)&&(QMRS=0)
	.s CWS=$g(^TEMPDHCWL($j,dep,"CWS")) //实有床位
	.i (CWS'="")&&(CWS'=0) s CWSYL=$fn(XYRS/CWS*100,"",2)_"%"
	.e  s CWSYL="0.00%"
	.s ^||CacheTemp(repid,ind)=$lb(dep,RYRS,CYRS,ZRRS,ZCRS,QCRS,QMRS,CWSYL)
	.s ind=ind+1
	
	k ^TEMPDHCWL($j)
	Quit $$$OK
}

}
