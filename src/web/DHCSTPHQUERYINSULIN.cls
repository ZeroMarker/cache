Import sqluser

/// Author : MYQ
/// CreatDate : 2015-07-17
/// Description : 胰岛素查询
Class web.DHCSTPHQUERYINSULIN Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter AppName [ Final ] = "DHCSTPHINSULIN";

/// 获取病区集合
/// w ##class(web.DHCSTPHQUERYINSULIN).GetWardDs(486)
ClassMethod GetWardStore(logonLoc, comboText = "") As %String
{
	s pid=..NewPid()
	s logonhosp=$p(^CTLOC(logonLoc),"^",22)
	s h=0
	s wardid=0
	f  s wardid=$o(^PAWARD(wardid)) q:wardid=""  d
	.q:+wardid'>0
	.s wardactive=$p(^PAWARD(wardid),"^",6) ;激活状态
	.q:wardactive'="Y"
	.s wardloc=$p(^PAWARD(wardid),"^",5)
	.s hospdr=$p(^CTLOC(wardloc),"^",22)
	.q:hospdr'=logonhosp
	.s ctlocconname=$$ALPHAUP^SSUTIL4($p(^CTLOC(wardloc),"^",43))
	.s warddesc=$p(^PAWARD(wardid),"^",2)
    .s warddesc=$p(warddesc,$c(13),1)
	.q:(comboText'="")&&(ctlocconname'[comboText)&&(warddesc'[comboText)
	.s data=warddesc_"^"_wardid
	.
	.s h=h+1
	.s ^TMP("DHCST","DHCSTPHQUERYINSULIN","GetWardStore",pid,h)=data
	.
	q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    s count=0
    s h=""
    f  s h=$o(^TMP("DHCST","DHCSTPHQUERYINSULIN","GetWardStore",pid,h)) q:h=""  d
    .s data=^TMP("DHCST","DHCSTPHQUERYINSULIN","GetWardStore",pid,h)
    .s WardDesc=$p(data,"^",1)
    .s WardID=$p(data,"^",2)
    .s WardDesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("WardDesc",WardDesc)
	.s WardID=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("WardID",WardID)
	.s tmpstr=WardDesc_WardID
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.s count=count+1
	.i count=1 w startString
    .i count<maxrow w firstrow
    .i count=maxrow w lastrow
    
    
    k ^TMP("DHCST","DHCSTPHQUERYINSULIN","GetWardStore",pid)
    q ""
}

/// 获取药房科室集合
/// w ##class(web.DHCSTPHQUERYINSULIN).GetPhaLocStore(486)
ClassMethod GetPhaLocStore(logonLoc, comboText = "") As %String
{
	s pid=..NewPid()
	s logonhosp=$p(^CTLOC(logonLoc),"^",22)
	s h=0
	s plrowid=0
	f  s plrowid=$o(^DHCPL(plrowid)) q:(plrowid=0)||(plrowid="")  d
	.s locdr=$p(^DHCPL(plrowid),"^",1)
	.q:locdr=""
	.s hospdr=$p(^CTLOC(locdr),"^",22)
	.q:hospdr'=logonhosp
	.s locdesc=$p(^CTLOC(locdr),"^",2)
	.s activedate=$p(^CTLOC(locdr),"^",25)
    .q:(activedate'="")&(activedate<+$h)
    .s locdr=$p(locdr,$c(13),1)
    .s locdesc=$p(locdesc,$c(13),1)
    .s ctlocconname=$$ALPHAUP^SSUTIL4($p(^CTLOC(locdr),"^",43))
	.q:(comboText'="")&&(ctlocconname'[comboText)&&(locdesc'[comboText)
	.s data=locdesc_"^"_locdr
	.
	.s h=h+1
	.s ^TMP("DHCST","DHCSTPHQUERYINSULIN","GetPhaLocStore",pid,h)=data
	.
	q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    s count=0
    s h=""
    f  s h=$o(^TMP("DHCST","DHCSTPHQUERYINSULIN","GetPhaLocStore",pid,h)) q:h=""  d
    .s data=^TMP("DHCST","DHCSTPHQUERYINSULIN","GetPhaLocStore",pid,h)
    .s phadesc=$p(data,"^",1)
    .s phadr=$p(data,"^",2)
    .s PhaLocDesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("PhaLocDesc",phadesc)
	.s PhaLocID=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("PhaLocID",phadr)
	.s tmpstr=PhaLocDesc_PhaLocID
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.s count=count+1
	.i count=1 w startString
    .i count<maxrow w firstrow
    .i count=maxrow w lastrow
    
    
    k ^TMP("DHCST","DHCSTPHQUERYINSULIN","GetPhaLocStore",pid)
    q ""
}

/// 查询病区胰岛素累计数信息
/// Author:MYQ
/// CreateDate:2015-07-20
/// 
/// w ##class(web.DHCSTPHQUERYINSULIN).jsQueryInsulinM(0,20,"2015-07-06^2015-07-08^484^")
ClassMethod jsQueryInsulinM(Start As %String, Limit As %String, StrPar As %String) As %String
{
 s StartDate=$P(StrPar,"^",1)  //起始日期
 s EndDate=$P(StrPar,"^",2)  //截止日期 
 s PhaLoc=$P(StrPar,"^",3)  //发药科室
 s Wardid=$P(StrPar,"^",4)    //病区
 
 s result=##class(%Library.ResultSet).%New("web.DHCSTPHQUERYINSULIN:GetInsulinResQty")
 s sc=result.Execute(EndDate,PhaLoc,Wardid)
 i $$$ISERR(sc) q ""
    
 s colNum=result.GetColumnCount()
 s colNameStr=""
 f i=1:1:colNum d
 .i colNameStr="" s colNameStr=result.GetColumnName(i)
 .e  s colNameStr=colNameStr_"^"_result.GetColumnName(i)

 s count = 0
 s resultString = ""
 s end = Start+Limit
 s json = ##class(Code.JsonObj).%New()
 While(result.Next())
 { 
  s ret=""
  f i=1:1:colNum d
  .i ret="" s ret=result.%GetData(i)
  .e   s ret=ret_"^"_result.%GetData(i)
  
  s tmp=ret
  s count = count+1

  CONTINUE:count<(Start+1)
  CONTINUE:count>end            
    
  d json.InsertRowData(tmp)
 }
 d result.Close()
 s resultString = json.getJsonData(colNameStr,count)
 k json
 Q resultString
}

/// 根据web.DHCSTRESERVEQUERY.cls中的GetReservedQty改写
/// Description : 统计病区胰岛素的累计数
/// Author : MYQ
/// CreateDate : 2015-07-20
/// Input : 日期范围,发药科室,病区ID
/// d ##class(%ResultSet).RunQuery("web.DHCSTPHQUERYINSULIN","GetInsulinResQty","2015-07-20",484,"")
ClassMethod GetInsulinResQtyExecute(ByRef qHandle As %Binary, enddate, displocrowid, wardrowid) As %Status
{

    s repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s ind=1

    q:displocrowid="" $$$OK
    q:enddate="" $$$OK
    s enddate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(enddate)
    s inci="" 
    f  s inci=$o(^DHCPRES(0,"LOCINCIWARD",displocrowid,inci)) q:inci=""  d 
    .s arcitm=$p(^INCI(inci,1),"^",3)
    .s arcsub=+arcitm
    .s arcver=$p(arcitm,"||",2)
    .s arccatdr=$p(^ARCIM(arcsub,arcver,1),"^",10)
    .;q:arccatdr'=164
    .s ward=""
    .f  s ward=$o(^DHCPRES(0,"LOCINCIWARD",displocrowid,inci,ward)) q:ward=""  d
    ..q:(wardrowid'=ward)&(wardrowid'="")
    ..s pres="" 
    ..f  s pres=$o(^DHCPRES(0,"LOCINCIWARD",displocrowid,inci,ward,pres)) q:pres=""  d 
    ...s qty=..GetQty(pres,enddate)
    ...s warddesc=$p(^PAWARD(ward),"^",2)
	...s incidesc=$p(^INCI(inci,1),"^", 2)
    ...d OutRow
	Quit $$$OK
OutRow
	set Data=$lb(pres,warddesc,incidesc,qty)   //所对应传出的列名
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod GetInsulinResQtyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInsulinResQtyExecute ]
{
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

Query GetInsulinResQty(enddate, displocrowid As %String, wardrowid As %String) As %Query(ROWSPEC = "pres:%String,warddesc:%String,incidesc:%String,accumqty:%String")
{
}

ClassMethod GetInsulinResQtyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInsulinResQtyExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetQty(pres, enddate) As %String
{
	n (pres,enddate)
	s enddate=enddate+1
	s enddate=$o(^DHCPRES(0,"Date",pres,enddate),-1)
	q:enddate="" 0
	s chl=$o(^DHCPRES(0,"Date",pres,enddate,""),-1)
	s avqty=$p(^DHCPRES(pres,"DET",chl),"^",4)
	Q avqty
}

/// 查询胰岛素业务明细记录数据串(json)
/// Author:MYQ
/// CreateDate:2015-07-21
/// 0,20,2014-11-21^2015-07-21^672
/// w ##class(web.DHCSTPHQUERYINSULIN).jsQueryInsulinD("0","20","2015-12-27^2016-01-29^4")
ClassMethod jsQueryInsulinD(Start As %String, Limit As %String, StrPar As %String)
{
	s pid=..NewPid()
	s StartDate=$P(StrPar,"^",1)  //起始日期
	s EndDate=$P(StrPar,"^",2)  //截止日期 
	s pres=$P(StrPar,"^",3)  //发药科室
	s result=##class(%Library.ResultSet).%New("web.DHCSTPHQUERYINSULIN:QueryInsulinD") 
	s sc=result.Execute(StartDate,EndDate,pres)
    s colNum=result.GetColumnCount()
    s colNameStr=""
    f i=1:1:colNum d
    .i colNameStr="" s colNameStr=result.GetColumnName(i)
    .e  s colNameStr=colNameStr_"^"_result.GetColumnName(i)
    s count=0
    While(result.Next())
    {
	   
	  s ret=""
      f i=1:1:colNum d
      .i ret="" s ret=result.%GetData(i)
      .e   s ret=ret_"^"_result.%GetData(i)
      s count = count+1      
      s ^TMP("DHCST","DHCSTPHQUERYINSULIN","jsQueryInsulinD",pid,count)=ret
	  
    }
   
    s maxrow=count
    i maxrow=0 w ##class(web.DHCSTEXTCOMMON).GetNoJson()
    q:maxrow=0 ""
    s endpage = Start+Limit
	s stpage = Start+1
    i endpage>maxrow s endpage=maxrow    
    s counter=0
    s h=""
    f  s h=$o(^TMP("DHCST","DHCSTPHQUERYINSULIN","jsQueryInsulinD",pid,h)) q:h=""  d
    .s data=^TMP("DHCST","DHCSTPHQUERYINSULIN","jsQueryInsulinD",pid,h)
    .s bustype=$p(data,"^",1)
    .s busqty=$p(data,"^",2)
    .s busavqty=$p(data,"^",3)
    .s busdate=$p(data,"^",4)
    .s bususer=$p(data,"^",5)
    .s counter=counter+1
    .
    .q:counter<stpage
    .q:counter>endpage
    .
    .s bustype=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("bustype",bustype)
	.s busqty=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("busqty",busqty)
	.s busavqty=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("busavqty",busavqty)
	.s busdate=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("busdate",busdate)
	.s bususer=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("bususer",bususer)
	.s tmpstr=bustype_busqty_busavqty_busdate_bususer
	.s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
    .i counter=stpage w startString
    .i counter<endpage w firstrow
    .i counter=endpage w lastrow
    
    k ^TMP("DHCST","DHCSTPHQUERYINSULIN","jsQueryInsulinD",pid)
    
    q ""
}

/// 检索医生请求单明细记录
/// Author:MYQ
/// CreateDate:2015-07-07
/// 
/// d ##class(%ResultSet).RunQuery("web.DHCSTPHQUERYINSULIN","QueryInsulinD",3)
Query QueryInsulinD(startdate As %String, enddate As %String, pres As %String) As %Query(ROWSPEC = "bustype:%String,busqty:%String,busavqty:%String,busdate:%String,bususer:%String") [ SqlProc ]
{
}

ClassMethod QueryInsulinDExecute(ByRef qHandle As %Binary, startdate As %String, enddate As %String, pres As %String) As %Status
{
	s repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	s ind=1
    q:pres="" $$$OK
    s:startdate'="" startdate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(startdate)
    s:enddate'="" enddate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(enddate)
    s distype=""
    f date=startdate:1:enddate d
    .s presub="" 
    .f  s presub=$o(^DHCPRES(0,"Date",pres,date,presub)) q:presub=""  d
    ..s type=$p(^DHCPRES(pres,"DET",presub),"^",1)
    ..i type="P" s distype="发药"
    ..i type="Y" s distype="退药"
    ..i type="A" s distype="清零"
    ..s qty=$p(^DHCPRES(pres,"DET",presub),"^",3)
    ..i type="P" s qty=-qty
    ..s avqty=$p(^DHCPRES(pres,"DET",presub),"^",4)
    ..s retdate=$p(^DHCPRES(pres,"DET",presub),"^",5)
    ..i retdate'="" s retdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(retdate,"IP")
    ..s retuser=$p(^DHCPRES(pres,"DET",presub),"^",6)
    ..i retuser'="" s retuser=$p(^SSU("SSUSR",retuser),"^",2)
    ..s rettime=$p(^DHCPRES(pres,"DET",presub),"^",7)
    ..i rettime'="" s rettime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(rettime,"IP")
    ..s retdate=retdate_" "_rettime
    ..d OutRowItm
	Quit $$$OK
OutRowItm
	set Data=$lb(distype,qty,avqty,retdate,retuser)   //所对应传出的列名
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod QueryInsulinDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryInsulinDExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryInsulinDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryInsulinDExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {                // if there are no more rows, finish fetching
    Set AtEnd=1
    Set Row=""
 }
 Else {         
        Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

/// 根据登陆科室获取科室类型
/// w ##class(web.DHCSTPHQUERYINSULIN).GetLocType(484)
ClassMethod GetLocType(logonloc) As %String
{
  q:logonloc="" ""
  s loctype=""
  s loctype=$p(^CTLOC(logonloc),"^",13)
  q loctype
}

ClassMethod NewPid() As %String
{
  q $I(^DHCSTPID("DHCSTPHINSULIN"))
}

}
