Import SQLUser

/// 配液排药汇总
Class web.DHCSTPIVAOUTSTATARRAGE Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 查询配液排药数据	
/// Creator:LiangQiang
/// CreatDate:2013-05-31
/// Input:登记号,开始行,限制行,参数串
/// Output:明细
ClassMethod QueryArrageData(RegNo, StPage, Limit, Input) As %String
{
	
	S cnumber=60  /// 60固定为打签状态
	s pid=##class(web.DHCSTPIVAOUTCOMMON).GetPIVAOUTPID()
	s stdate=$p(Input,"^",1)
	s stdate=$zdh(stdate,4)
	s enddate=$p(Input,"^",2)
	s enddate=$zdh(enddate,4)
    s phalocdr=$p(Input,"^",3)
    s patID=$p(Input,"^",4)
    
    s endpage=StPage+Limit  //结束行
	s stpage=StPage+1 //开始行
	s pogspsdr=$o(^PIVAS(0,"NUMBER",phalocdr,cnumber,""))
	s pogspsdr=1
	
	f date=stdate:1:enddate  d
	.s pogid=""
	.f  s pogid=$o(^PIVA(0,"DATELOC",phalocdr,date,pogspsdr,pogid)) q:pogid=""  d
 	..s psnumber=##class(web.DHCSTPIVAOUTCOMMON).GetPSNumber(pogid)
 	..q:psnumber'=cnumber /// 配药状态
 	../// 明细
	..s pogsub=""
	..F  s pogsub=$O(^PIVA(pogid,"I",pogsub)) Q:pogsub=""  D
	...S dodis=$P(^PIVA(pogid,"I",pogsub),"^",1)
	...Q:dodis=""
	...Q:'$D(^DHCOEDISQTY(dodis))
	...S oeori=$p(^DHCOEDISQTY(dodis),"^",1)
	...S pri=##class(web.DHCSTPIVAOUTCOMMON).GetOePriority(oeori)
	...S pricode=$P(pri,"^",2)
	...S pricode=$ZCVT(pricode,"U")
	...Q:pricode["OM"
	...S ord=$P(oeori,"||",1)
 	...S chl=$P(oeori,"||",2) 
 	...S incitm=##class(web.DHCSTPIVAOUTCOMMON).GetIncItm(oeori)
 	...S inci=$P(incitm,"^",1)
 	...S itmdesc=$P(incitm,"^",3)
 	...S qty=$P(^DHCOEDISQTY(dodis),"^",11)
 	...S stkbin=##class(web.DHCSTPIVAOUTCOMMON).GetStkBin(phalocdr,inci)
 	...S index=stkbin_"^"_inci_"^"_oeori
    ...s ^TMP("dhcpha","DHCSTPIVAOUTSTATARRAGE","QueryArrageData",pid,"Index",index)=+$g(^TMP("dhcpha","DHCSTPIVAOUTSTATARRAGE","QueryArrageData",pid,"Index",index))+qty
    
    s h=0
    s index=""
    f  s index=$o(^TMP("dhcpha","DHCSTPIVAOUTSTATARRAGE","QueryArrageData",pid,"Index",index)) q:index=""  d
    .s stkbin=$p(index,"^",1)
    .s inci=$p(index,"^",2)
    .s oeori=$p(index,"^",3)
    .S ord=$P(oeori,"||",1)
 	.S chl=$P(oeori,"||",2) 
    .s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2)  ;医嘱 ARC_ItmMast ARCIM_RowId
	.s itmmastid=$p(arcimid,"||",1)
	.s itmmastver=$p(arcimid,"||",2)
	.s inciDesc=$p(^INCI(inci,1),"^",2) //药品名称
	.s puomdr=$p(^ARCIM(itmmastid,itmmastver,8),"^",14)
	.s buomdr=+$p(^INCI(inci,1),"^",10)
	.s uomdr=buomdr
	.s fac=+##Class(web.DHCSTCOMMONSRV).UOMFac(puomdr,buomdr)
    .i (qty#fac)=0 d
	..s qty=qty/fac   //数量
	..s uomdr=puomdr 
	.s uomdesc=$p($g(^CT("UOM",uomdr)),"^",2) //单位
	.S h=h+1
	.s data=inciDesc_"^"_qty_"^"_uomdesc_"^"_stkbin
	.s ^TMP("dhcpha","DHCSTPIVAOUTSTATARRAGE","QueryArrageData",pid,"Itm",h)=data
    
 	q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
 	  
    s maxrow=h
    i endpage>maxrow s endpage=maxrow
    s count=0
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTPIVAOUTSTATARRAGE","QueryArrageData",pid,"Itm",h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTPIVAOUTSTATARRAGE","QueryArrageData",pid,"Itm",h)
    .s incidesc=$p(data,"^",1)
    .s qty=$p(data,"^",2)
    .s uomdesc=$p(data,"^",3)
    .s stkbin=$p(data,"^",4)
    .
    .s count=count+1
    .q:count<stpage
    .q:count>endpage
    .
    .s incidesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("inciname",incidesc)
	.s qty=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("qty",qty)
	.s uomdesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("uom",uomdesc)
	.s stkbin=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("stkbin",stkbin)
	.
	.s tmpstr=incidesc_qty_uomdesc_stkbin
	.
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.
    .
    .i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
    
    
    k ^TMP("dhcpha","DHCSTPIVAOUTSTATARRAGE","QueryArrageData",pid)
    q ""
}

}
