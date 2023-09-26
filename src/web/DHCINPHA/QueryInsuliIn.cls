Class web.DHCINPHA.QueryInsuliIn Extends %RegisteredObject
{

/// description: 保留药累计查询(仅输出)
/// w ##class(web.DHCINPHA.QueryInsuliIn).JsInsulinResQty("50","0","12/12/2019^12/12/2019^^246")
ClassMethod JsInsulinResQty(rows, page, inputStr = "")
{
	s ^TMPDHCSTPARAMS("web.DHCINPHA.QueryInsuliIn","JsInsulinResQty")=$lb(rows,page, inputStr)
	i +page=0 s page=1
	q:inputStr="" ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s collRet=..GetInsulinResQty(rows,page, inputStr)
	s pid=$p(collRet,"^",1)
	s total=$p(collRet,"^",2)
	q:(pid="")||(+total=0) ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s title="rowid^locdesc^incidesc^accumqty^bUomDesc"
	s outputI="",count=0
	f  s outputI=$o(^||TMP("DHCST",$ClassName(),"GetInsulinResQty",pid,outputI)) q:outputI=""  d
	.s outputData=^||TMP("DHCST",$ClassName(),"GetInsulinResQty",pid,outputI)
	.s count=count+1
	.i count=1 d
	..w ##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(total)
	..w ##class(web.DHCSTJQUERYCOMMON).getJsonData(title,outputData,"^")
	.e  d
	..w ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(title,outputData,"^")
	i count>0   w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign()
	e  w ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	q ""
}

/// description: 保留药累计查询(仅输出)
/// w ##class(web.DHCINPHA.QueryInsuliIn).GetInsulinResQty("3","1","10/07/2019^10/07/2019^^246")
ClassMethod GetInsulinResQty(rows, page, inputStr)
{
	s enddate=$p(inputStr,"^",2)
	s enddate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(enddate)
	s pid=..CollectInsulinResQty(inputStr)
	q:pid="" ""
	s EndRow=page*rows  
	s StartRow=((page-1)*rows)+1 
	s recordCnt=0,total=0
	s sortIndex=""
	f  s sortIndex=$o(^||TMP("DHCST",$ClassName(),"CollectInsulinResQty",pid,sortIndex)) q:sortIndex=""  d
	.s pres=""
	.f  s pres=$o(^||TMP("DHCST",$ClassName(),"CollectInsulinResQty",pid,sortIndex,pres))  q:pres=""  d
	..// 主信息
	..s total=total+1
	..q:total<StartRow
    ..q:total>EndRow
    ..s presData=^DHCPRES(pres)
    ..s wardId=$p(presData,"^",3)
    ..s docLocId=$p(presData,"^",5)
    ..s ResQty=..GetQty(pres,enddate)
    ..s ResQty=$number(ResQty,3)
    ..i (ResQty<1)&(ResQty>0) s ResQty=0_""_ResQty
    ..s InciId=$p(presData,"^",2)
    ..i wardId'="" s locDesc=##class(PHA.COM.Data.Base).WardDesc(wardId)
    ..e  s locDesc=##class(PHA.COM.Data.Base).LocDesc(docLocId)
	..s incidesc=##class(PHA.COM.Data.Base).InciDesc(InciId)
	..s bUomId=$p(^INCI(InciId,1),"^",10)
	..s bUomDesc=##class(PHA.COM.Data.Base).UomDesc(+bUomId)
	..s data=pres_"^"_locDesc_"^"_incidesc_"^"_ResQty_"^"_bUomDesc
	..s recordCnt=recordCnt+1
	..s ^||TMP("DHCST",$ClassName(),"GetInsulinResQty",pid,recordCnt)=data
	k ^||TMP("DHCST",$ClassName(),"CollectInsulinResQty",pid)
	q pid_"^"_recordCnt
}

/// description: 保留药累计查询
/// Input : 日期范围,发药科室,病区ID
/// w ##class(web.DHCINPHA.QueryInsuliIn).CollectInsulinResQty("01/05/2013^25/05/2018^10^98")
ClassMethod CollectInsulinResQty(inputStr) As %String
{
	s stdate=$p(inputStr,"^",1)
	s enddate=$p(inputStr,"^",2)
	s wardrowid=$p(inputStr,"^",3)
	s displocrowid=$p(inputStr,"^",4)
	s doclocrowid=$p(inputStr,"^",5)
	s incirowid=$p(inputStr,"^",6)
	s stdate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(stdate) 
	s enddate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(enddate)
	s pid=..NewPid()
	s indexStr="LOCINCIWARD^LOCINCIDEPT"
	f i=1:1:$l(indexStr,"^") d
	.s index=$p(indexStr,"^",i)
	.s inci=""
    .f  s inci=$o(^DHCPRES(0,index,displocrowid,inci)) q:inci=""   d 
    ..q:(incirowid'="")&&(incirowid'=inci)
    ..s arcitm=$p(^INCI(inci,1),"^",3)
    ..s arcsub=+arcitm
    ..s arcver=$p(arcitm,"||",2)
    ..s arccatdr=$p(^ARCIM(arcsub,arcver,1),"^",10)
    ..s locId="" 
    ..f  s locId=$o(^DHCPRES(0,index,displocrowid,inci,locId)) q:locId=""  d
    ...q:(wardrowid'="")&&(index="LOCINCIDEPT")
    ...q:(doclocrowid'="")&&(index="LOCINCIWARD")
    ...q:(index="LOCINCIWARD")&&(wardrowid'="")&&(wardrowid'=locId)
    ...q:(index="LOCINCIDEPT")&&(doclocrowid'="")&&(doclocrowid'=locId)
    ...s pres="" 
    ...f  s pres=$o(^DHCPRES(0,index,displocrowid,inci,locId,pres)) q:pres=""  d 
	....s sortIndex=pres 
	....s ^||TMP("DHCST",$ClassName(),"CollectInsulinResQty",pid,sortIndex,pres)=""
	q pid
}

/// description: 保留药累计明细查询(仅输出)
/// w ##class(web.DHCINPHA.QueryInsuliIn).JsInsulinDetail("50","1","2019-01-28^2019-09-23^5")
ClassMethod JsInsulinDetail(rows, page, inputStr = "")
{
	i +page=0 s page=1
	q:inputStr="" ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s collRet=..GetInsulinDetail(rows,page, inputStr)
	s pid=$p(collRet,"^",1)
	s total=$p(collRet,"^",2)
	q:(pid="")||(+total=0) ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s title="predetilid^bustype^busqty^busavqty^busdate^bususer^type"
	s outputI="",count=0
	f  s outputI=$o(^||TMP("DHCST",$ClassName(),"GetInsulinDetail",pid,outputI)) q:outputI=""  d
	.s outputData=^||TMP("DHCST",$ClassName(),"GetInsulinDetail",pid,outputI)
	.s count=count+1
	.i count=1 d
	..w ##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(total)
	..w ##class(web.DHCSTJQUERYCOMMON).getJsonData(title,outputData,"^")
	.e  d
	..w ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(title,outputData,"^")
	i count>0   w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign()
	e  w ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	q ""
}

/// description: 保留药累计明细查询(仅输出)
/// w ##class(web.DHCINPHA.QueryInsuliIn).GetInsulinDetail("50","1","10/07/2019^10/07/2019^3")
ClassMethod GetInsulinDetail(rows, page, inputStr)
{
	s pid=..CollectInsulinDetail(inputStr)
	q:pid="" ""
	s EndRow=page*rows  
	s StartRow=((page-1)*rows)+1 
	s recordCnt=0,total=0
	s sortIndex=""
	f  s sortIndex=$o(^||TMP("DHCST",$ClassName(),"CollectInsulinDetail",pid,sortIndex)) q:sortIndex=""  d
	.s predetail=""
	.f  s predetail=$o(^||TMP("DHCST",$ClassName(),"CollectInsulinDetail",pid,sortIndex,predetail)) q:predetail=""  d
	..// 主信息
	..s total=total+1
	..q:total<StartRow
    ..q:total>EndRow
    ..s presid=$p(predetail,"||",1)
    ..s presub=$p(predetail,"||",2)
    ..s presData=^DHCPRES(presid,"DET",presub) 
    ..s type=$p(presData,"^",1)
    ..i type="P" s bustype=##class(PHA.COM.Base).Get("发药")
    ..i type="Y" s bustype=##class(PHA.COM.Base).Get("退药")
    ..i type="A" s bustype=##class(PHA.COM.Base).Get("清零")
    ..s busqty=$fn($number($p(presData,"^",3),3),"N")
    ..s busavqty=$fn($number($p(presData,"^",4),3),"N")
    ..i type="P" s busqty="-"_busqty
    ..s busdate=$p(presData,"^",5)
    ..s busdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(busdate)
    ..s bustime=$p(presData,"^",7)
    ..s bustime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(bustime)
    ..s busdate=busdate_" "_bustime
	..s bususer=$p(presData,"^",6)
    ..s bususer=##class(PHA.COM.Data.Base).UserName(bususer)
    ..//s InciId=$p(presData,"^",2)
    ..//s bUomId=$p(^INCI(InciId,1),"^",10)
	..//s bUomDesc=$p($g(^CT("UOM",+bUomId)),"^",2)
	..s data=predetail_"^"_bustype_"^"_busqty_"^"_busavqty_"^"_busdate_"^"_bususer_"^"_type
	..s recordCnt=recordCnt+1
	..s ^||TMP("DHCST",$ClassName(),"GetInsulinDetail",pid,recordCnt)=data
	k ^||TMP("DHCST",$ClassName(),"CollectInsulinDetail",pid)
	q pid_"^"_total
}

/// description: 保留药累计明细查询
/// Input : 日期范围,退药冲减主表Id
/// w ##class(web.DHCINPHA.QueryInsuliIn).CollectInsulinDetail("01/05/2013^25/05/2018^6")
ClassMethod CollectInsulinDetail(inputStr) As %String
{
	s stdate=$p(inputStr,"^",1)
	s enddate=$p(inputStr,"^",2)
	s presId=$p(inputStr,"^",3)
	q:presId=""
	s:stdate'="" stdate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(stdate) 
	s:enddate'="" enddate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(enddate)
	s pid=..NewPid()
	s distype=""
    f date=stdate:1:enddate d
    .s presub="" 
    .f  s presub=$o(^DHCPRES(0,"Date",presId,date,presub)) q:presub=""  d
    ..s predetail=presId_"||"_presub 
	..s sortIndex=$j(presId,10)_"||"_$j(presub,10)
	..s ^||TMP("DHCST",$ClassName(),"CollectInsulinDetail",pid,sortIndex,predetail)=""
	q pid
}

ClassMethod GetQty(pres, enddate) As %String
{
	s enddate=enddate+1
	s enddate=$o(^DHCPRES(0,"Date",pres,enddate),-1)
	q:enddate="" 0
	s chl=$o(^DHCPRES(0,"Date",pres,enddate,""),-1)
	s avqty=$p(^DHCPRES(pres,"DET",chl),"^",4)
	Q avqty
}

/// description: 进程号
ClassMethod NewPid()
{
	q ##class(web.DHCSTKUTIL).NewPid("web.DHCINPHA.QueryInsuliIn","IP")
}

}
