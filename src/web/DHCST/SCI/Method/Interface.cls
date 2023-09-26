Import sqluser

/// creator:	yunhaibao
/// createdate: 2017-04-24
/// description:与SCI接口处理数据统一类
Class web.DHCST.SCI.Method.Interface Extends (%RegisteredObject, %XML.Adaptor)
{

/// SCI用户名
Parameter SCIUser = "dhcctest";

/// SCI用户密码
Parameter SCIPassWord = 1;

/// 每次上传xml明细记录数
Parameter SCICount = 1000;

/// 每次上传xml明细记录数
Parameter AppName = "DHCSTSCIINTERFACE";

Parameter wsuser = "dhwebservice";

Parameter wsps = "dhwebservice";

/// description:同步科室
/// tables:		User.CTLoc
/// others:如为测试,请检查连接是否为测试...
/// w ##class(web.DHCST.SCI.Method.Interface).SynLoc()
ClassMethod SynLoc() As %String
{
	s $zt="ErrorSynLoc"
	s SCIErrInfo=""
	s operateResultObj=##class(web.DHCST.SCI.tns.operateResult).%New()
    s serviceSoapObj=##class(web.DHCST.SCI.DHCSTSCIServiceSoap).%New()
   
    s hisLocWebObj=##class(web.DHCST.SCI.tns.hisLocWeb).%New()
    s hisLocWebObj.userName=..%GetParameter("SCIUser")
    s hisLocWebObj.passWord=..%GetParameter("SCIPassWord")
    s SCICount=..%GetParameter("SCICount")
    s count=0
    s loc=0
    f  s loc=$O(^CTLOC(loc)) q:loc=""  d
    .s code=$p(^CTLOC(loc),"^",1)
    .s desc=$p(^CTLOC(loc),"^",2)
    .s type=$p(^CTLOC(loc),"^",13)
    .s hisLocItmWebObj=##class(web.DHCST.SCI.tns.hisLocItmWeb).%New()
    .s hisLocItmWebObj.code=code
    .s hisLocItmWebObj.name=desc
    .s hisLocItmWebObj.id=loc
    .d hisLocWebObj.hisLocItmWebs.Insert(hisLocItmWebObj)
    .s count=count+1
    .i count=SCICount d SendData
    i count'=0 d SendData
    q:SCIErrInfo'="" -1_"|@|"_SCIErrInfo
 	q 0
SendData
	s count=0
	s serviceSoapObj.Username=..#wsuser // 访问前置机的用户与密码
	s serviceSoapObj.Password=..#wsps
	s operateResultObj=serviceSoapObj.getHopLoc(hisLocWebObj)
	d hisLocWebObj.hisLocItmWebs.Clear()
	s resultCode=operateResultObj.resultCode
 	s retContent=operateResultObj.resultContent
 	i resultCode'=0 d
 	.s resultinfo="resultCode:"_resultCode_",retContent:"_retContent
 	.d ErrorRecord^DHCSTERROR(..%GetParameter("AppName"),"同步SCI科室",resultinfo)
 	.s SCIErrInfo=$s(SCIErrInfo="":resultinfo,1:SCIErrInfo_"</br>"_resultinfo)
ErrorSynLoc
	s Error=$$Error^DHCSTERROR()
	q -10_"|@|"_Error
}

/// description:同步药品供应商
/// tables:		User.APCVendor,User.DHCSTVendor
/// others:如为测试,请检查连接是否为测试...
/// w ##class(web.DHCST.SCI.Method.Interface).SynVendor()
ClassMethod SynVendor() As %String
{
	s $zt="ErrorSynVendor"
	s SCIErrInfo=""
	s operateResultObj=##class(web.DHCST.SCI.tns.operateResult).%New()
	s serviceSoapObj=##class(web.DHCST.SCI.DHCSTSCIServiceSoap).%New()
	
    s hisVendorWebObj=##class(web.DHCST.SCI.tns.hisVendorWeb).%New()
    s hisVendorWebObj.userName=..%GetParameter("SCIUser")
    s hisVendorWebObj.passWord=..%GetParameter("SCIPassWord")
    s SCICount=..%GetParameter("SCICount")
    s count=0
	s vendor=0
	f  s vendor=$O(^APC("APCVM",vendor)) q:vendor=""  d
	.q:$P($g(^APC("APCVM",vendor)),"^",9)'="G"
	.s code=$p(^APC("APCVM",vendor),"^",2)
	.s desc=$p(^APC("APCVM",vendor),"^",3)
	.s dhcstv=$o(^DHCSTV(0,vendor,""))
	.s businessRegNo="未知"
	.i dhcstv'=""  d
	..s businessRegNo=$p($g(^DHCSTV(dhcstv)),"^",1)     ;工商执照
	.i businessRegNo="" s businessRegNo="未知"
	.s hisVendorItmWebObj=##class(web.DHCST.SCI.tns.hisVendorItmWeb).%New()
	.s hisVendorItmWebObj.code=vendor  //此处传code? 
	.s hisVendorItmWebObj.name=desc
	.s hisVendorItmWebObj.businessRegNo=businessRegNo
	.d hisVendorWebObj.hisVendorItmWebs.Insert(hisVendorItmWebObj)
	.s count=count+1
	.i count=SCICount d SendData
	i count'=0 d SendData
    q:SCIErrInfo'="" -1_"|@|"_SCIErrInfo
 	q 0
SendData
	s count=0
	s serviceSoapObj.Username=..#wsuser // 访问前置机的用户与密码
	s serviceSoapObj.Password=..#wsps
	s operateResultObj=serviceSoapObj.getHopVendor(hisVendorWebObj)
	d hisVendorWebObj.hisVendorItmWebs.Clear()
 	s resultCode=operateResultObj.resultCode
 	s retContent=operateResultObj.resultContent
 	i resultCode'=0 d
 	.s resultinfo="resultCode:"_resultCode_",retContent:"_retContent
 	.d ErrorRecord^DHCSTERROR(..%GetParameter("AppName"),"同步SCI供应商",resultinfo)
 	.s SCIErrInfo=$s(SCIErrInfo="":resultinfo,1:SCIErrInfo_"</br>"_resultinfo)
ErrorSynVendor
	s Error=$$Error^DHCSTERROR()
	q -10_"|@|"_Error
}

/// description:同步药品字典
/// tables:		User.INCItm 
/// others:如为测试,请检查连接是否为测试...
/// w ##class(web.DHCST.SCI.Method.Interface).SynInc()
ClassMethod SynInc(HospId = "") As %String
{
	//s $zt="ErrorSynInc"
	s SCIErrInfo=""
	s operateResultObj=##class(web.DHCST.SCI.tns.operateResult).%New()
	s serviceSoapObj=##class(web.DHCST.SCI.DHCSTSCIServiceSoap).%New()
	
	s hisIncWebObj=##class(web.DHCST.SCI.tns.hisIncWeb).%New()
    s hisIncWebObj.userName=..%GetParameter("SCIUser")
    s hisIncWebObj.passWord=..%GetParameter("SCIPassWord")
    s SCICount=..%GetParameter("SCICount")
    s count=0
    s inci=0
    f  s inci=$o(^INCI(inci)) q:inci=""  d
    .q:+inci=0
    .q:$p(^INCI(inci,2),"^",9)="Y"
    .s catgrpstr=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
    .q:$p(catgrpstr,"^",3)'="G"
    .s hisIncItmWebObj=..GetInciInfo(inci)
    .q:hisIncItmWebObj=""
    .d hisIncWebObj.incItmWebs.Insert(hisIncItmWebObj)
    .s count=count+1
	.i count=100 d SendData
	i count'=0 d SendData
	q:SCIErrInfo'="" -1_"|@|"_SCIErrInfo
 	q 0
SendData
	s count=0
	s serviceSoapObj.Username=..#wsuser // 访问前置机的用户与密码
	s serviceSoapObj.Password=..#wsps
	s operateResultObj=serviceSoapObj.getHopInc(hisIncWebObj)
	d hisIncWebObj.incItmWebs.Clear()
 	s resultCode=operateResultObj.resultCode
 	s retContent=operateResultObj.resultContent
 	i resultCode'=0 d
 	.s resultinfo="resultCode:"_resultCode_",retContent:"_retContent
 	.d ErrorRecord^DHCSTERROR(..%GetParameter("AppName"),"同步SCI药品字典",resultinfo)
 	.s SCIErrInfo=$s(SCIErrInfo="":resultinfo,1:SCIErrInfo_"</br>"_resultinfo)
 	q
ErrorSynInc
	s Error=$$Error^DHCSTERROR()
	q -10_"|@|"_Error
}

/// description:同步单条药品字典数据
/// tables:		User.INCItm 
/// others:如为测试,请检查连接是否为测试...
/// w ##class(web.DHCST.SCI.Method.Interface).SynOneInc(514)
ClassMethod SynOneInc(Inci, HospId = "") As %String
{
	s $zt="ErrorSynOneInc"
	s operateResultObj=##class(web.DHCST.SCI.tns.operateResult).%New()
	s serviceSoapObj=##class(web.DHCST.SCI.DHCSTSCIServiceSoap).%New()
	s serviceSoapObj.Username=..#wsuser // 访问前置机的用户与密码
	s serviceSoapObj.Password=..#wsps
    s serviceSoapObj.OpenTimeout=10
	s hisIncWebObj=##class(web.DHCST.SCI.tns.hisIncWeb).%New()
    s hisIncWebObj.userName=..%GetParameter("SCIUser")
    s hisIncWebObj.passWord=..%GetParameter("SCIPassWord")
    s hisIncItmWebObj=..GetInciInfo(Inci)
    q:hisIncItmWebObj="" -1_"|@|"_"HIS数据获取为空"
    d hisIncWebObj.incItmWebs.Insert(hisIncItmWebObj)
    s operateResultObj=serviceSoapObj.getHopInc(hisIncWebObj)
 	s resultCode=operateResultObj.resultCode
 	s retContent=operateResultObj.resultContent
 	q:+resultCode'=0 -1_"|@|"_retContent
 	q 0
ErrorSynOneInc
	s Error=$$Error^DHCSTERROR()
	q -10_"|@|"_Error
}

/// description:根据inci获取药品信息
/// w ##class(web.DHCST.SCI.Method.Interface).GetInciInfo(118258)
ClassMethod GetInciInfo(Inci, HospId = "") As %String
{
	q:Inci="" ""
	q:'$d(^INCI(Inci,1)) ""
	s incicode=$p(^INCI(Inci,1),"^",1)
	s incidesc=$p(^INCI(Inci,1),"^",2)
	s incipuom=$p(^INCI(Inci,3),"^",6)
	s incipuomdesc=$p($g(^CT("UOM",+incipuom)),"^",2)
	s incibarcode=$p(^INCI(Inci,3),"^",9) ; 条码
	s infoid=$o(^DHCITMINFO(0,"INCI",Inci,0))
	i infoid'="" s incibarcode=$p($g(^DHCITMINFO(infoid)),"^",44) ;benweima
	e  s incibarcode=""
	i incibarcode="" s incibarcode=incicode
	q:incibarcode="" ""
	s incicatdr=$p(^INCI(Inci,2),"^",2)
	s incicatdesc=$p($g(^INC("SC",+incicatdr)),"^",2)
	s incisp=##class(web.DHCSTPRICE).GetSp(Inci,+$h,incipuom,HospId) 
	s incirp=##Class(web.DHCSTPRICE).GetRp(Inci,+$h,incipuom,HospId)
	s incispec=##Class(web.DHCST.Common.DrugInfoCommon).GetSpec("",Inci)
	s incimanfinfo=##Class(web.DHCST.Common.DrugInfoCommon).GetManf(Inci)
	s incimanf=$p(incimanfinfo,"^",1)
	s incimanfdesc=$p(incimanfinfo,"^",3)
	s inciobj=##class(web.DHCST.SCI.tns.hisIncItmWeb).%New()
	s inciobj.venIncCode=incicode
	s inciobj.venIncName=incidesc
	s inciobj.venIncUom=incipuomdesc
	s inciobj.venIncPrice=incirp
	s inciobj.venIncSp=incisp
	s inciobj.venIncSpec=incispec
	s inciobj.venIncCat=incicatdesc
	s inciobj.venIncManf=$e(incimanfdesc,1,20)
	s inciobj.barCode=incibarcode  
	s inciobj.form=""
	q inciobj
}

/// description:同步科室库存上下限信息
/// tables:		User.INCItmLoc 
/// others:如为测试,请检查连接是否为测试...
/// w ##class(web.DHCST.SCI.Method.Interface).SynLocQty(100)
ClassMethod SynLocQty(LocRowId = "") As %String
{
	s $zt="ErrorSynLocQty"
	s operateResultObj=##class(web.DHCST.SCI.tns.operateResult).%New()
	s serviceSoapObj=##class(web.DHCST.SCI.DHCSTSCIServiceSoap).%New()
	s hisIncLocQtyWebObj=##class(web.DHCST.SCI.tns.hisIncLocQtyWeb).%New()
    s hisIncLocQtyWebObj.userName=..%GetParameter("SCIUser")
    s hisIncLocQtyWebObj.passWord=..%GetParameter("SCIPassWord")
    s SCICount=..%GetParameter("SCICount")
    s count=0
    s loc=0
    f  s loc=$o(^CTLOC(loc)) q:loc=""  d
    .q:+loc=0
    .q:(LocRowId'="")&&(LocRowId'=loc)
    .s inci=0
    .f  s inci=$O(^INCI("IL_LOC",loc,inci)) q:inci=""  d
    ..s stkgrpstr=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
    ..q:$p(stkgrpstr,"^",3)'="G"
    ..s incich=$o(^INCI("IL_LOC",loc,inci,""),-1)
    ..s hisIncLocQtyItmWebObj=..GetLocInciQtyInfo(inci_"||"_incich)
    ..d hisIncLocQtyWebObj.hisIncLocQtyItmWebs.Insert(hisIncLocQtyItmWebObj)
    ..s count=count+1
    ..i count=SCICount d SendData
    //q ..ReadXml(hisIncLocQtyWebObj)
    i count'=0 d SendData
 	q 0
SendData
	s count=0
	s serviceSoapObj.Username=..#wsuser // 访问前置机的用户与密码
	s serviceSoapObj.Password=..#wsps
    s operateResultObj=serviceSoapObj.getHopLocIncQty(hisIncLocQtyWebObj)
    d hisIncLocQtyWebObj.hisIncLocQtyItmWebs.Clear()
 	s resultCode=operateResultObj.resultCode
 	s retContent=operateResultObj.resultContent
  	s ^DHCSTDataExchangeErrLog($this,"SynLocQty",$zd(+$h,3),$zt($p($h,",",2),3),"retContent:"_retContent)="resultCode:"_resultCode   
ErrorSynLocQty
	s Error=$$Error^DHCSTERROR()
	q -10_"|@|"_Error
}

/// description:根据incil获取科室药品库存信息
/// input:		科室库存项id
/// w ##class(web.DHCST.SCI.Method.Interface).GetLocInciQtyInfo("1002||5")
ClassMethod GetLocInciQtyInfo(Incil) As %String
{
	q:+Incil="0" ""
	s Inci=+Incil
	s InciCh=$p(Incil,"||",2)
	q:'$d(^INCI(Inci,1)) ""
	s incicode=$p(^INCI(Inci,1),"^",1)
	s incidesc=$p(^INCI(Inci,1),"^",2)
	s incipuom=$p(^INCI(Inci,3),"^",6)
	s incibuom=$p(^INCI(Inci,1),"^",10)
	s incibarcode=$p(^INCI(Inci,3),"^",9) ; 条码
	s inciloc=$p(^INCI(Inci,"IL",InciCh),"^",1)
	s inciloccode=$p(^CTLOC(inciloc),"^",1)
	s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(incipuom,incibuom)
	s incilmaxqty=$p(^INCI(Inci,"IL",InciCh),"^",7)
	s incilmaxqty=incilmaxqty/fac
	s incilminqty=$p(^INCI(Inci,"IL",InciCh),"^",4)
	s incilminqty=incilminqty/fac
	s incilstandqty=$p(^INCI(Inci,"IL",InciCh),"^",6) ; 标准库存
	s incilstandqty=incilstandqty/fac
	s incilqty=##class(web.DHCST.Common.DrugStkCommon).IL(Inci,inciloc,+$h)
	s incilqty=incilqty/fac
	s locinciobj=##class(web.DHCST.SCI.tns.hisIncLocQtyItmWeb).%New()
    s locinciobj.locCode=inciloc
    s locinciobj.locIncCode=incicode
    s locinciobj.locIncMaxQty=incilmaxqty
    s locinciobj.locIncMinQty=incilminqty
    s locinciobj.locIncQty=incilqty
    s locinciobj.locIncStandQty=incilstandqty
	q locinciobj
}

/// description:发送订单数据
/// tables:		User.INPO,User.INPOItm
/// input:		采购订单ID
/// others:		如为测试,请检查连接是否为测试...
/// w ##class(web.DHCST.SCI.Method.Interface).SendINPO(67)
ClassMethod SendINPO(INPO) As %String
{
	q:+INPO=0 -10
	s $zt="ErrorSendINPO"
	s SCIErrInfo=""
	s operateResultObj=##class(web.DHCST.SCI.tns.operateResult).%New()
	s serviceSoapObj=##class(web.DHCST.SCI.DHCSTSCIServiceSoap).%New()
	s hisOrderWebObj=##class(web.DHCST.SCI.tns.hisOrderWeb).%New()
    s hisOrderWebObj.userName=..%GetParameter("SCIUser")
    s hisOrderWebObj.passWord=..%GetParameter("SCIPassWord")
    s SCICount=..%GetParameter("SCICount")
    s count=0
    s vendor=$P(^INPO(INPO),"^",2)
    s inpodate=$P(^INPO(INPO),"^",3)
    i inpodate'="" s inpodate=$zd(inpodate,3)_" "_"00:00:00"
    s inponeeddate=$P(^INPO(INPO),"^",13)
    i inponeeddate'="" s inponeeddate=$zd(inponeeddate,3)_" "_"00:00:00" ; 
    s dhcinpo=$o(^DHCINPO(0,"INPO",INPO,""),-1)
    i +dhcinpo>0 d
    .s inpoloc=$p(^DHCINPO(dhcinpo),"^",2)   ; 订单科室
    .s reqloc=$p(^DHCINPO(dhcinpo),"^",5)   
    e  d
    .s (inpoloc,reqloc)=""
    i reqloc="" s reqloc=inpoloc
    s INPOI=0
    f  s INPOI=$O(^INPO(INPO,"POI",INPOI)) q:INPOI=""  d
    .q:+INPOI=0
    .s inci=$p(^INPO(INPO,"POI",INPOI),"^",1)
    .s inpoqty=$p(^INPO(INPO,"POI",INPOI),"^",7)
    .s inpouomdr=$p(^INPO(INPO,"POI",INPOI),"^",3)
    .s inporp=$p(^INPO(INPO,"POI",INPOI),"^",4)
    .s puomdr=$p(^INCI(inci,3),"^",6)
    .s barcode=$p(^INCI(inci,3),"^",9) //暂时用药品代码
   	.s infoid=$o(^DHCITMINFO(0,"INCI",inci,0))
	.i infoid'="" s barcode=$p($g(^DHCITMINFO(infoid)),"^",44) ;benweima
	.e  s barcode=""
	.i barcode="" s barcode=$p(^INCI(inci,1),"^",1)
    .i inpouomdr'=puomdr d
    ..s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(puomdr,inpouomdr)
    ..s inpoqty=inpoqty/fac
    ..s inporp=inporp*fac 
    .s incich=$o(^INCI("IL_LOC",inpoloc,inci,""))
    .s incil=inci_"||"_incich
	.s stkbinret=##class(web.DHCST.Common.DrugInfoCommon).GetInciBinStr(incil,",","","") 
    .s stkbinstr=$p(stkbinret,":",2)
    .s hisOrderWebItmObj=##class(web.DHCST.SCI.tns.hisOrderWebItm).%New()
    .s hisOrderWebItmObj.desction=reqloc
    .s hisOrderWebItmObj.emflag=1  				; 加急
    .s hisOrderWebItmObj.hisId=INPO_"||"_INPOI  ; rowid
    .s hisOrderWebItmObj.hisno=INPO
    .s hisOrderWebItmObj.hopBarCode=barcode  ///benweima
    .s hisOrderWebItmObj.planDate=inpodate
    .s hisOrderWebItmObj.purloc=inpoloc
    .s hisOrderWebItmObj.qty=inpoqty
    .s hisOrderWebItmObj.recloc=reqloc
    .s hisOrderWebItmObj.remark=""
    .s hisOrderWebItmObj.rp=inporp
    .s hisOrderWebItmObj.vendorBarCode=vendor //businessRegNo
    .s hisOrderWebItmObj.demandDate=inponeeddate
    .s hisOrderWebItmObj.location=stkbinstr
    .d hisOrderWebObj.hisOrderWebItms.Insert(hisOrderWebItmObj)
    .s count=count+1
    .i count=SCICount d SendData
    //q ..ReadXml(hisOrderWebObj)
    i count'=0 d SendData
    d ..CheckInPoSend(INPO)
    q:SCIErrInfo'="" -1_"|@|"_SCIErrInfo
    //全部成功
    &SQL(UPDATE DHC_INPO SET PO_SendStat='F' WHERE PO_INPO_DR=:INPO)
    q 0
SendData
	s count=0
	s serviceSoapObj.Username=..#wsuser // 访问前置机的用户与密码
	s serviceSoapObj.Password=..#wsps
    s operateResultObj=serviceSoapObj.getHopOrder(hisOrderWebObj)
    d hisOrderWebObj.hisOrderWebItms.Clear()
 	s resultCode=operateResultObj.resultCode
 	s retContent=operateResultObj.resultContent
 	i resultCode'=0 d
 	.s resultinfo="resultCode:"_resultCode_",retContent:"_retContent
 	.i retContent["^" d
    ..s retContentNew=$p(retContent,"^",2)
    ..i retContentNew["||" d
    ...&SQL(UPDATE DHC_INPO SET PO_SendStat='P' WHERE PO_INPO_DR=:INPO)
 	.d ErrorRecord^DHCSTERROR(..%GetParameter("AppName"),"发送SCI订单",resultinfo)
 	.s SCIErrInfo=$s(SCIErrInfo="":resultinfo,1:SCIErrInfo_"</br>"_resultinfo)
 	d ..UpdatePoItmSendFlag(retContent)
ErrorSendINPO	
	s Error=$$Error^DHCSTERROR()
	q -10_"|@|"_Error
}

/// description:获取SCI入库数据
/// input:		SCI打印的随行单号
/// others:		如为测试,请检查连接是否为测试...
/// w ##class(web.DHCST.SCI.Method.Interface).GetRecData("ORD201704287",1)
ClassMethod GetRecData(SXNo, UserId) As %String
{
	
	q:SXNo="" -10_"|@|"_"随行单号为空!"
	s $zt="ErrorGetRecData"
	s operateResultObj=##class(web.DHCST.SCI.tns.operateResult).%New()
	s serviceSoapObj=##class(web.DHCST.SCI.DHCSTSCIServiceSoap).%New()
	s serviceSoapObj.Username=..#wsuser // 访问前置机的用户与密码
	s serviceSoapObj.Password=..#wsps
	s getOrderDetailXml=serviceSoapObj.getOrderDetail(SXNo)
	s getOrderDetailStream=##class(%GlobalCharacterStream).%New()
	d getOrderDetailXml.XMLExportToStream(getOrderDetailStream)
	//s ^web.DHCST.SCI.Method.Interface("GetRecData",SXNo)=getOrderDetailStream.Read()
	s RecPid=..AnalysisRecXML(getOrderDetailStream)
	q:'$d(^TMP("DHCST",$this,"AnalysisRecXML",RecPid)) -10_"|@|"_"云平台暂无数据!"
	// 获取数据需全部成功,否则回滚
	ts
	s HHRet=..InsertSCIToHH(RecPid,UserId)
	k ^TMP("DHCST",$this,"AnalysisRecXML",RecPid)
	i $p(HHRet,"|@|",1)<0 tro  q HHRet
	tc
	q 0
ErrorGetRecData
	i $d(RecPid) k ^TMP("DHCST",$this,"AnalysisRecXML",RecPid)
	s Error=$$Error^DHCSTERROR()
	q -10_"|@|"_Error
}

/// description:获取SCI微信入库记录
/// input:		user 
/// others:		如为测试,请检查连接是否为测试...
/// w ##class(web.DHCST.SCI.Method.Interface).GetWeChatRecData(1)
ClassMethod GetWeChatRecData(UserId) As %String
{
	//s ^yunhaibao($this,"GetWeChatRecData")=UserId
	s $zt="ErrorGetWeChatRecData"
	s operateResultObj=##class(web.DHCST.SCI.tns.operateResult).%New()
	s serviceSoapObj=##class(web.DHCST.SCI.DHCSTSCIServiceSoap).%New()
	s serviceSoapObj.Username=..#wsuser // 访问前置机的用户与密码
	s serviceSoapObj.Password=..#wsps
	s usename=..%GetParameter("SCIUser")
    s password=..%GetParameter("SCIPassWord")
	s listInGdRecXml=serviceSoapObj.listInGdRec(usename,password)
	s listInGdRecStream=##class(%GlobalCharacterStream).%New()
	d listInGdRecXml.XMLExportToStream(listInGdRecStream)
	s RecPid=..AnalysisRecXML(listInGdRecStream)
	q:'$d(^TMP("DHCST",$this,"AnalysisRecXML",RecPid)) -10_"|@|"_"云平台暂无数据!"
	// 获取数据需全部成功,否则回滚
	ts
	s HHRet=..InsertSCIToHH(RecPid,UserId,"WeChat")
	k ^TMP("DHCST",$this,"AnalysisRecXML",RecPid)
	i $p(HHRet,"|@|",1)<0 tro  q HHRet
	tc
	q 0
ErrorGetWeChatRecData
	i $d(RecPid) k ^TMP("DHCST",$this,"AnalysisRecXML",RecPid)
	s Error=$$Error^DHCSTERROR()
	q -10_"|@|"_Error
}

/// description:解析入库数据
ClassMethod AnalysisRecXML(recstream As %GlobalCharacterStream) As %String
{
	
	s pid=..NewPid()
	k ^TMP("DHCST",$this,"AnalysisRecXML",pid)
	s reader=##class(%XML.Reader).%New()
	s sc=reader.OpenStream(recstream)  
	Do reader.Correlate("hisInGdRec","web.DHCST.SCI.tns.hisInGdRec")
	While reader.Next(.obj,.sc) {
		s recItmLen=obj.inGdRecItms.Count()
		f reci=1:1:recItmLen {
			s recItmObj=obj.inGdRecItms.GetAt(reci)
			s batno=recItmObj.batNo				;批号
			s expdate=recItmObj.expdate			;效期
			s qty=recItmObj.qty					;入库数量
			s rp=recItmObj.rp					;进价		
			s incibarcode=recItmObj.incBarCode	;药品HIS条码
			continue:incibarcode=""
			s invdate=recItmObj.invDate			;发票日期
			s invno=recItmObj.invNo				;发票号
			s incilabels=recItmObj.labels		;药品包装条码
			s recloccode=recItmObj.recLocCode 	;收货科室id
			s vendorcode=recItmObj.vendorCode 	;供应商id
			continue:recloccode=""
			s purloccode=recItmObj.purLocCode	;his订单科室id
			s inpoi=recItmObj.hisNo				;his订单子表id
			s sciorderno=recItmObj.orderno		;SCI订单号
			s sciordersub=recItmObj.orderDetailSubId ;SCI订单子表id
			s sciarrivedate=recItmObj.arriveDate     ;SCI预计到达日期
			s ingdrecId=recItmObj.ingdrecId     ;SCI入库子表id
			s index=recloccode_"^"_vendorcode_"^"_purloccode_"^"_sciorderno_"^"_+inpoi
			s recdata1=incibarcode_"^"_qty_"^"_batno_"^"_expdate_"^"_invno
			s recdata2=invdate_"^"_incilabels_"^"_inpoi_"^"_sciordersub_"^"_rp
			s recdata3=ingdrecId
			s recdata=recdata1_"^"_recdata2_"^"_recdata3
			s ^TMP("DHCST",$this,"AnalysisRecXML",pid,index,reci)=recdata
		}
	}
	q pid
}

/// description:汇总数据插入海虹表
/// tables:	   User.DHCHHImport,User.DHC_HHYTImportItm
ClassMethod InsertSCIToHH(RecPid, UserId, SCIRecType = "") As %String
{
	s hherr=0
	s index1=""
	f  s index1=$o(^TMP("DHCST",$this,"AnalysisRecXML",RecPid,index1)) q:(index1="")||(hherr<0)  d
	.s loccode=$p(index1,"^",1)
	.s locid=loccode //..LocCodeToRowID(loccode)
	.s vendorcode=$p(index1,"^",2) ;sci的供应商名称,传id
	.s purloccode=$p(index1,"^",3)
	.s purlocid=purloccode //..LocCodeToRowID(purloccode) 科室传的id
	.s sciorderno=$p(index1,"^",4)
	.s inpoid=$p(index1,"^",5)
	.s vendorid=$P(^INPO(inpoid),"^",2)
	.i purlocid="" s purlocid=locid
	.s hhmaindata=inpoid_"^"_locid_"^"_vendorid_"^"_purlocid_"^"_sciorderno
	.s hhmain=##class(web.DHCST.HHImport).InsertHHImport(hhmaindata,UserId)
	.i +hhmain'>0 s hherr=-100 q
	.s index2=""
	.f  s index2=$o(^TMP("DHCST",$this,"AnalysisRecXML",RecPid,index1,index2)) q:(index2="")||(hherr<0)  d
	..s detaildata=^TMP("DHCST",$this,"AnalysisRecXML",RecPid,index1,index2)
	..s detaildata=$tr(detaildata,$c(0),"")
	..s incibarcode=$p(detaildata,"^",1) //本位码
	..s dhcitmadd=..GetInciByStandardCode(incibarcode)
	..i dhcitmadd="" s inci=##class(web.DHCSTCOMMONSRV).ItemCodeToID(incibarcode)  //药品基础数据传递时,本位码为空传的药品ID
	..e  s inci=$p(^DHCITMINFO(dhcitmadd),"^",1)
	..q:inci=""
	..s incicode=$p(^INCI(inci,1),"^",1)
	..s qty=$p(detaildata,"^",2)
	..s batno=$p(detaildata,"^",3)
	..s expdate=$p(detaildata,"^",4)
	..i (expdate'="")&&(expdate["-") s expdate=$zdh(expdate,3)
	..s invno=$p(detaildata,"^",5)
	..s invdate=$p(detaildata,"^",6)
	..i (invdate'="")&&(invdate["-") s invdate=$zdh(invdate,3)
	..s incilabels=$p(detaildata,"^",7)
	..s inpoi=$p(detaildata,"^",8)
	..s inpoiqty=$p($g(^INPO(+inpoi,"POI",+$p(inpoi,"||",2))),"^",7)
	..s sciordsubs=$p(detaildata,"^",9)
	..s rp=$p(detaildata,"^",10)
	..s uomid=""
	..i uomid="" s uomid=$p(^INCI(inci,3),"^",6)
	..s uomdesc=$p($g(^CTUOM(+uomid)),"^",2)
	..s ingdrecid=$p(detaildata,"^",11)
	..i SCIRecType="WeChat" s sciordsubs=ingdrecid
	..s hhitmdata1=incicode_"^"_incibarcode_"^"_qty_"^"_batno_"^"_expdate_"^"_invno_"^"_invdate_"^"_incilabels_"^"_inpoi_"^"_rp
	..s hhitmdata2=uomid_"^"_uomdesc_"^"_sciordsubs_"^"_inpoiqty_"^"_vendorcode
	..s hhitmdata=hhitmdata1_"^"_hhitmdata2
	..s hhitm=##class(web.DHCST.HHImport).InsertHHImportItm(hhmain,hhitmdata)
	..i +hhitm'>0 s hherr=-101 q
	.q:hherr<0
    .i SCIRecType="WeChat" s synsciorder="" //..SynSCIIngdRecStat(hhmain)
	.e  i SCIRecType="" s synsciorder=..SynSCIOrderStat(hhmain,"F")
	q:hherr=-100 -10_"|@|"_"插入User.DHCHHImport数据失败!"
	q:hherr=-101 -10_"|@|"_"插入User.HHYTImportItm数据失败!"
	q 0
}

/// description:同步SCI订单状态
/// F:完成,Y:取消完成
/// w ##class(web.DHCST.SCI.Method.Interface).SynSCIOrderStat("100000079","F")
ClassMethod SynSCIOrderStat(DHCHHID, Status)
{
	s userName=..%GetParameter("SCIUser")
    s passWord=..%GetParameter("SCIPassWord")
	s operateResultObj=##class(web.DHCST.SCI.tns.operateResult).%New()
	s serviceSoapObj=##class(web.DHCST.SCI.DHCSTSCIServiceSoap).%New()
	s serviceSoapObj.Username=..#wsuser // 访问前置机的用户与密码
	s serviceSoapObj.Password=..#wsps
	s stringArrayObj=##class(web.DHCST.SCI.ns1.stringArray).%New()
	s DHCHHSUB=""
	f  s DHCHHSUB=$o(^DHCHI(DHCHHID,"I",DHCHHSUB)) q:DHCHHSUB=""  d
	.q:+DHCHHSUB=0
	.s sciordsub=$p(^DHCHI(DHCHHID,"I",DHCHHSUB),"^",25)
	.d stringArrayObj.item.Insert(sciordsub)
 	s operateResultObj=serviceSoapObj.cmpOrder(userName,passWord,stringArrayObj,Status)
 	q 0
}

/// description:更新SCI入库状态
/// F:完成,Y:取消完成
/// w ##class(web.DHCST.SCI.Method.Interface).SynSCIOrderStat("100000079","F")
ClassMethod SynSCIIngdRecStat(DHCHHID)
{
	s userName=..%GetParameter("SCIUser")
    s passWord=..%GetParameter("SCIPassWord")
	s operateResultObj=##class(web.DHCST.SCI.tns.operateResult).%New()
	s serviceSoapObj=##class(web.DHCST.SCI.DHCSTSCIServiceSoap).%New()
	s serviceSoapObj.Username=..#wsuser // 访问前置机的用户与密码
	s serviceSoapObj.Password=..#wsps
	s DHCHHSUB=""
	f  s DHCHHSUB=$o(^DHCHI(DHCHHID,"I",DHCHHSUB)) q:DHCHHSUB=""  d
	.q:+DHCHHSUB=0
	.s ingdrecId=$p(^DHCHI(DHCHHID,"I",DHCHHSUB),"^",25)
 	.s operateResultObj=serviceSoapObj.cmpInGdRec(userName,passWord,ingdrecId)
 	q 0
}

/// description: 唯一进程号
ClassMethod NewPid(method = "") As %String
{
	q:method'="" $i(^DHCST($this,method))
	q $i(^DHCST($this))
}

/// description: 科室code获取id
ClassMethod LocCodeToRowID(TmpLoc As %String) As %String
{
 s PP=""
 &sql( SELECT CTLOC_ROWID INTO :PP FROM CT_LOC WHERE CTLOC_Code=:TmpLoc)
 q $g(PP)
}

/// description: 根据本位码获取药品id
ClassMethod GetInciByStandardCode(StandardCode) As %String
{
	q:StandardCode="" ""
	s InciRowId=$o(^DHCITMINFO(0,"STANDCODE",StandardCode,""))
	q InciRowId
}

/// description: 根据sci返回值更新订单子表发送状态
ClassMethod UpdatePoItmSendFlag(inputString) As %String
{
	q:inputString="" ""
	q:inputString'["^" ""
	s poitmstr=$p(inputString,"^",2)
	s poitmlen=$l(poitmstr,",")
	s poi=0
	f poi=1:1:poitmlen d
	.s poitm=$p(poitmstr,",",poi)
	.q:poitm'["||"
	.q:+$p(poitm,"||",2)=0
	.q:'$d(^INPO(+poitm,"POI",+$p(poitm,"||",2)))
	.s dhcpoitm=$o(^DHCINPOI(0,"INPOI",poitm,""))
	.i dhcpoitm="" d
	..&SQL(insert into DHC_INPOItm (POI_INPOI_DR,POI_PlatSentFlag) values (:poitm,'Y'))
	.e  d
	..&SQL(UPDATE DHC_INPOItm SET POI_PlatSentFlag='Y' WHERE POI_RowId=:dhcpoitm)
	q 0
}

/// description: 检查订单字表是否全部为发送
ClassMethod CheckInPoSend(InPoId)
{
	s PoCnt=0,DHCPoCnt=0
	s InPoI=0
    f  s InPoI=$O(^INPO(InPoId,"POI",InPoI)) q:InPoI=""  d
    .q:+InPoI=0
    .s PoCnt=PoCnt+1
    .s InPoIRowId=InPoId_"||"_InPoI
    .s DHCPoItm=$o(^DHCINPOI(0,"INPOI",InPoIRowId,""))
    .q:DHCPoItm=""
    .s PoItmSend=$p($g(^DHCINPOI(DHCPoItm)),"^",3)
    .q:PoItmSend'="Y"
    .s DHCPoCnt=DHCPoCnt+1
    i PoCnt=DHCPoCnt d
    .&SQL(UPDATE DHC_INPO SET PO_SendStat='F' WHERE PO_INPO_DR=:InPoId)
    q 0
}

/// description:解析数据用,仅测试使用
/// w ##class(web.DHCST.SCI.Method.Interface).ReadXml(^yunhaibao("ccc"))
ClassMethod ReadXml(inputXmlObj)
{
	s NewXml=##class(%GlobalCharacterStream).%New()
	d inputXmlObj.XMLExportToStream(.NewXml)
	s NewXmlSize=NewXml.Size
	s OneSize=32000
	s NewXmlCount=NewXmlSize/OneSize
	i NewXmlCount["." s NewXmlCount=+$p(NewXmlCount,".",1)+1
	f NewI=1:1:NewXmlCount d
	.w NewXml.Read()
	q ""
}

/// description: 批量插入订单
/// w ##class(web.DHCST.SCI.Method.Interface).InsertINPOData()
ClassMethod InsertINPOData()
{
	s i=0,poid=1925
	f i=1:1:500 d
	.w ##class(web.DHCST.INPOItm).Save(1925,"^529^26^19^"_i_"^"_2223)
	q "finish"
}

}
