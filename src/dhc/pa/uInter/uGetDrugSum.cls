Class dhc.pa.uInter.uGetDrugSum Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// creator:Zhao LiGuo
/// createdate:20141202
/// description:,药品报废率=报废药品金额/当前药品库存进价金额/10000
/// input:日期(2014-12-02)
/// w ##class(dhc.pa.uInter.uGetDrugSum).GetDrugBFL("2014-12")
ClassMethod GetDrugBFL(sDate)
{
	
	
	s startDate=sDate_"-01"
	s month=$p(sDate,"-",2)
	s year=$p(sDate,"-",1)
	s yearmonth=year_month
	i month<12 d
	.s month1=month+1
	.s endDate=year_"-"_month1_"-"_"01"
	e  d
	.s year=year+1
	.s endDate=year_"-01-01"
	
	s bDate =$zdh(startDate,3)
	s eDate=$zdh(endDate,3)-1
	s endDate=$zd(eDate,3)
	s zje=0,bfje=0
	;w "yearmonth"_yearmonth,!
	//取药品报废金额
	//w "bDate"_bDate_"^_^"_"eDate"_eDate,!
	&SQL(SELECT sum(b.DHCITI_PPAmount) into:bfje FROM sqluser.DHC_InIsTrf a,sqluser.DHC_InIsTrfItm b 
	WHERE a.INIT_RowId =b.INITI_INIT_ParRef AND  a.INIT_ToLoc_DR=504
	AND INIT_Date>=:bDate AND INIT_Date<:eDate )
	
	//w endDate,!
	//取下列库房当前库存进价金额合计
	s zje=zje+..GetSumInciSpRp(endDate,"zyyf-住院药房")
	s zje=zje+..GetSumInciSpRp(endDate,"mzxyf-门诊西药房")
	s zje=zje+..GetSumInciSpRp(endDate,"gryf-感染药房")
	s zje=zje+..GetSumInciSpRp(endDate,"zcy-中草药房")
	s zje=zje+..GetSumInciSpRp(endDate,"jzyf-急诊药房")
	s zje=zje+..GetSumInciSpRp(endDate,"xyk-西药库")
	s zje=zje+..GetSumInciSpRp(endDate,"zyk-中药库")
	s zje=zje+..GetSumInciSpRp(endDate,"jxypk-近效药品库")
	s zje=zje+..GetSumInciSpRp(endDate,"XSYPK-消杀药品库")
	s zje=zje+..GetSumInciSpRp(endDate,"bjyf-保健药房")
	//药品报废率，万分之一
	//w "zje"_zje,"bfje"_bfje,!
	//s bfl=bfje/zje/10000
	//q bfl
	&sql(INSERT INTO dhc_pa_data.JXBaseData(JXBaseData_parRef,JXBaseData_period,JXBaseData_periodType,JXBaseData_KPIDr,JXBaseData_actualValue)
	values( 54,:yearmonth,'M',66,:bfje)
	)
	;q:SQLCODE'=0 SQLCODE
	
	&sql(INSERT INTO dhc_pa_data.JXBaseData(JXBaseData_parRef,JXBaseData_period,JXBaseData_periodType,JXBaseData_KPIDr,JXBaseData_actualValue)
	values( 54,:yearmonth,'M',65,:zje)
	)
	;q:SQLCODE'=0 SQLCODE
	
	q SQLCODE
}

/// creator:yunhaibao
/// createdate:20141202
/// description:给绩效接口,获取指定日期库存进售价
/// input:日期(2014-12-02),科室(xyf-西药房)
/// w ##class(dhc.pa.uInter.uGetDrugSum).GetSumInciSpRp("2014-12-02","xyk-西药库")
ClassMethod GetSumInciSpRp(cacudate, locdesc)
{
	s locdesc="xyk-西药库"
	s rptotal=0,sptotal=0
	s spdate=$zdh(cacudate,3)
	&SQL(SELECT ctloc_rowid into:locDr FROM sqluser.CT_Loc WHERE CTLOC_Desc=:locdesc)
	s inci=""
	f  s inci=$o(^INCI("IL_LOC",locDr,inci)) Q:inci=""  d
	.s inciloc=""
	.f  s inciloc=$o(^INCI("IL_LOC",locDr,inci,inciloc)) q:inciloc=""  d
	..s incilb=""
	..f  s incilb=$o(^INCI(inci,"IL",inciloc,"LB",incilb)) q:incilb=""  d
	...s inclb=inci_"||"_inciloc_"||"_incilb
	...s puom=$p(^INCI(inci,3),"^",6)
	...s buom=$p(^INCI(inci,1),"^",10)
	...q:(+buom=0)||(+puom=0)
	...s curlbqty=##class(web.DHCSTSTKQTY).QtyINCLB(inclb,cacudate)
	...s fac=##class(web.DHCSTCOMMONSRV).UOMFac(puom,buom)  //转换系数
	...s puomqty=curlbqty/fac  //入库单位数量
	...s sp=##class(web.DHCSTCOMMONSRV).GetPriceElse(inci,spdate,puom)
	...s rp=##class(web.DHCSTPRICE).LastInPrice(inclb,puom)
	...s spamt=sp*puomqty
	...s rpamt=rp*puomqty
	...s rptotal=rptotal+rpamt ;进价金额
	...s sptotal=sptotal+spamt ;零售金额
	q rptotal ;_"^"_sptotal
}

Storage Default
{
<StreamLocation>^dhc.pa.uInter.uGetDrugSumS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
