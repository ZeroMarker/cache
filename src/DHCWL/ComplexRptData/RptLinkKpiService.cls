Import SQLUser

Class DHCWL.ComplexRptData.RptLinkKpiService Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// hetong
/// 2015-11-30
/// 更新报表关联指标等相关内容
/// d ##class(DHCWL.ComplexRptData.RptLinkKpiService).SaveRptLinkKpi("1")
ClassMethod SaveRptLinkKpi(rpt As %String, pool As %String) As %Status
{
	n (rpt,pool)
	q:(pool="")!(rpt="") 1
	s rptCfgId=$o(^DHCWL.ComplexRpt.RowsColCfgI("RCRptDr",rpt,""))
	q:rptCfgId="" 1
	s contentStr=$lg(^DHCWL.ComplexRpt.RowsColCfgD(rptCfgId),4)
	q:$l(contentStr,",")'=$l(pool,",") 2
	TSTART
	s res=0
	&sql(delete from DHCWL_ComplexRpt.RptLinkMkpi where RptLink_Rpt=:rpt) 
	i SQLCODE'=0 {
		TROLLBACK
		q 1
	}
	s len=$l(pool,",")
	f i=1:1:len {
		s kpi=$P(pool,",",i)
		&sql(insert into DHCWL_ComplexRpt.RptLinkMkpi (RptLink_Kpi,RptLink_Rpt) values (:kpi,:rpt))
		i SQLCODE'=0 {
			s res=1  q
		}
	}
	i (res'=0){
		TROLLBACK
	}else{
		TCOMMIT
	}
	q res
}

/// hetong
/// 2015-11-30
/// 获取指定报表ID所关联的指标等相关内容
/// d ##class(%ResultSet).RunQuery("DHCWL.ComplexRptData.RptLinkKpiService","GetRptLinkKpi","5")
Query GetRptLinkKpi(rptDr As %String) As %Query(ROWSPEC = "rKpiType:%String,rKpiCode:%String,rKpiName:%String,rKpi:%String") [ SqlProc ]
{
}

ClassMethod GetRptLinkKpiExecute(ByRef qHandle As %Binary, rptDr As %String) As %Status
{
	n (qHandle,rptDr)
 	s repid=$I(^CacheTemp)
 	s qHandle=$lb(0,repid,0)
    s ind=1
    
	q:(rptDr="") $$$OK
	q:'$d(^DHCWL.ComplexRpt.RptCfgD(rptDr)) $$$OK
	
	s linkPoolKpi=0
	f {
		s linkPoolKpi=$o(^DHCWL.ComplexRpt.RptLinkMkpiI("LinkRptKpi",rptDr,linkPoolKpi))
		q:linkPoolKpi=""
		s mkpi=$lg(^DHCWL.ComplexRpt.MKpiD(linkPoolKpi),2) ;指标ID
		continue:'$d(^DHCWL.MKPI.MKPID(+mkpi))
		s kpiDesc=$lg(^DHCWL.MKPI.MKPID(mkpi),3)
		s kpiCode=$lg(^DHCWL.MKPI.MKPID(mkpi),2)
		s content=$lg(^DHCWL.ComplexRpt.MKpiD(linkPoolKpi),4) ;统计内容
		&sql(SELECT St_Desc INTO :pContent FROM DHCWL_ComplexRpt.StatItem WHERE St_Code=:content)
		s dimString=$lg(^DHCWL.ComplexRpt.MKpiD(linkPoolKpi),5) ;维度串
		d OutPutRow
	}
	
	s qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutPutRow
	s Data=$lb(pContent,dimString,kpiCode,linkPoolKpi)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	q
}

ClassMethod GetRptLinkKpiClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRptLinkKpiExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetRptLinkKpiFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRptLinkKpiExecute ]
{
	n (AtEnd,qHandle,Row)
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
