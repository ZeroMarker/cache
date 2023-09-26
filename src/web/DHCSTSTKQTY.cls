Class web.DHCSTSTKQTY Extends %RegisteredObject
{

ClassMethod CurQty(incicode, locdesc As %String) As %String
{
	s inci=##class(web.DHCSTCOMMONSRV).ItemCodeToID(incicode)
	s loc=##class(web.DHCSTCOMMONSRV).LocToRowID(locdesc)
	s dd=+$h
	q ..IL(inci,loc,dd)
}

ClassMethod CurQtyU(incicode, locdesc, UOMDesc As %String) As %String
{
          ; Get the current qty according to item code and loc description
	q:incicode="" 0
	q:locdesc="" 0
	q:UOMDesc="" 0
	s inci=##class(web.DHCSTCOMMONSRV).ItemCodeToID(incicode)
	s loc=##class(web.DHCSTCOMMONSRV).LocToRowID(locdesc)
	s UOM=##class(web.DHCSTCOMMONSRV).CTUOMToID(UOMDesc) q:UOM="" 0    
	s BUOM=$p(^INCI(inci,1),"^",10) q:BUOM="" 0
	s fac=##class(web.DHCSTCOMMONSRV).UOMFac(UOM,BUOM)
	s dd=+$h
	s qty=..IL(inci,loc,dd)
	s qty=qty/fac
	q qty
}

ClassMethod Qty(incicode, locdesc, theday As %String) As %String
{
	s inci=##class(web.DHCSTCOMMONSRV).ItemCodeToID(incicode)
	s loc=##class(web.DHCSTCOMMONSRV).LocToRowID(locdesc)
	s dd=$zdh(theday,3)
	q ..IL(inci,loc,dd)
}

ClassMethod IL(inci, loc, dd As %String) As %String
{
	q:inci="" 0
	q:loc="" 0
	q:dd="" 0
	s nextdate=dd+1
	s rr=$o(^DHCLOCTOT(0,"LOCITMDATE",loc,inci,nextdate),-1)
	i rr="" q 0
	s rr=$o(^DHCLOCTOT(0,"LOCITMDATE",loc,inci,rr,""),-1)
	i rr="" q 0
	s qty=+$p(^DHCLOCTOT(rr),"^",4)
	q qty
}

ClassMethod CurQtyINCLBURid(INCLB, UOM As %String) As %String
{
	q:INCLB="" 0
	q:UOM="" 0
	s INCI=+INCLB q:INCI="" 0
	s BUOM=$p(^INCI(INCI,1),"^",10) q:BUOM="" 0
	s fac=##class(web.DHCSTCOMMONSRV).UOMFac(UOM,BUOM)
	s qty=..CurQtyINCLB(INCLB)
	s qty=qty/fac
	q qty
}

ClassMethod CurQtyINCLBU(INCLB, UOMDesc As %String) As %String
{
  	q:INCLB="" 0
	q:UOMDesc="" 0
	s UOM=##class(web.DHCSTCOMMONSRV).CTUOMToID(UOMDesc) q:UOM="" 0
	s qty=..CurQtyINCLBURid(INCLB,UOM)
	q qty
}

ClassMethod CurQtyINCLB(INCLB As %String) As %String
{
	q:INCLB="" 0
	s today=$zd(+$h,3)  ; convert time format into "3" 
	q ..QtyINCLB(INCLB,today)
}

ClassMethod QtyINCLB(INCLB, DA As %String) As %String
{
	s qty=""
	s DA=$zdh(DA,3)
	s DA=DA+1 q:DA="" 0
	s DD=$o(^DHCBTLOCTOT(0,"INCLBDATE",INCLB,DA),-1) q:DD="" 0
	s LCBTD=$o(^DHCBTLOCTOT(0,"INCLBDATE",INCLB,DD,""),-1)  q:LCBTD="" 0
	s LCBTCH=$o(^DHCBTLOCTOT(0,"INCLBDATE",INCLB,DD,LCBTD,""),-1) q:LCBTCH="" 0
	s qty=$p(^DHCBTLOCTOT(LCBTD,"I",LCBTCH),"^",3)
	q qty
}

/// Description: 判断科室库存项Rowid查找所有批次库存量是否>该发药量(住院) 
/// Creator:	 Liang Qiang
/// CreatDate:	 2009-08-07
/// Ouput:		 1 - 可发药 0 - 不可发药
/// Others:		 2018-10-22, 增加医嘱批次不可用是否允许发药的配置, hulihua
/// 			 2021-05-18, 批次效期判断调用公共
/// w ##class(web.DHCSTSTKQTY).GetPhaQty("2080||9||2","200")
ClassMethod GetPhaQty(incil, dspQty) As %String
{
	s inci = +$p(incil, "||", 1), il = +$p(incil, "||", 2)
	q:(inci = 0)&&(il = 0) 0
	s incilData = $g(^INCI(inci, "IL", il))
	s loc = $p(incilData, "^", 1)
	q:(loc = "") 0
	s sumQty = 0
	s inclb = ""
	for {
		s inclb = $o(^DHCINCLBi("ACISTKBT", "Y", loc, inci, inclb))
		q:(inclb = "")
		continue:(..ValidInclbForDisp(inclb) '= "Y")
		s lb = $p(inclb, "||", 3)
		s phyQty = ..CurQtyINCLB(inclb)
		s dirtyQty = $p(^INCI(inci, "IL", il, "LB", lb), "^", 3)
		if (dirtyQty < 0){
			s dirtyQty = 0
		}
		s qty = phyQty - dirtyQty
		s sumQty = sumQty + qty
	}
	q:(sumQty '< dspQty) 1
	q 0
}

ClassMethod GetPhaInclbQty(incil, dspqty) As %String
{
  q:dspqty=0 1
  s sumqty=0
  s num=0
  s chl=0
  s inci=+incil
  s incl=$p(incil,"||",2)
  f  s chl=$o(^INCI(inci,"IL",incl,"LB",chl)) q:chl=""  d
  .s incib=$p(^INCI(inci,"IL",incl,"LB",chl),"^",1)
  .s expdate=$p(^INCI(+incib,"IB",$p(incib,"||",2)),"^",2)
  .s phyqty=$p(^INCI(inci,"IL",incl,"LB",chl),"^",2)
  .s dirtyqty=$p(^INCI(inci,"IL",incl,"LB",chl),"^",3)
  .s phyqty=+phyqty
  .s dirtyqty=+dirtyqty
  .s tqty=phyqty-dirtyqty
  .q:tqty'>0
  .s num=num+1
  .;s CLB(num)=incil_"||"_chl
  .;s Eqty(num)=tqty
  .s Expdate(num)=expdate_"^"_incil_"||"_chl_"^"_tqty
  .
  q:num=0 0
  for j=1:1:num d 
  .for n=1:1:num-j d 
  ..if $p(Expdate(n),"^") > $p(Expdate(n+1),"^") d  
  ...set tmpExp = Expdate(n) ;
  ...set Expdate(n) = Expdate(n+1) 
  ...set Expdate(n+1) = tmpExp ;
  ..
  .
  s cnum=num
  i cnum=0  q 0  
  s k=0
  s sumdqty=0
  s clbqty=dspqty
  k xINCLB,xQTY
  f i=1:1:cnum q:clbqty'>0   d
  . s CLB(i)=$p(Expdate(i),"^",2)
  . s Eqty(i)=$p(Expdate(i),"^",3)
  . i Eqty(i)'<clbqty d
  . . s k=k+1
  . . s xINCLB(k)=CLB(i)
  . . s xQTY(k)=clbqty
  . . s clbqty=clbqty-xQTY(k)
  . . s sumdqty=$g(sumdqty)+xQTY(k)
  . e  d
  . . s k=k+1
  . . s xINCLB(k)=CLB(i)
  . . s xQTY(k)=Eqty(i)
  . . s clbqty=clbqty-xQTY(k)
  . . s sumdqty=$g(sumdqty)+xQTY(k)
  i sumdqty<dspqty q 0  
  q k
}

/// 取有效批次库存总数量
/// Update：20150105 zhouyg
ClassMethod GetStkQtyInclb(incil) As %String
{
  s sumqty=0
  s chl=0
  f  s chl=$o(^INCI(+incil,"IL",$p(incil,"||",2),"LB",chl)) q:chl=""  d
  .s inclb=incil_"||"_chl
  .s qty=..GetAvialQtyINCLB(inclb)
  .q:qty'>0
  .s sumqty=sumqty+qty
  q:sumqty=0 0
  q sumqty
}

/// Description: BS发药取批次库存ID, 批次价不能调这个
/// 			 统一价不考虑售价与厂家
/// Modify:		 2018-10-22, 增加是医嘱批次不可用是否允许发药的配置,hulihua
/// 			 2019-08-29, 修改排序同##class(web.DHCST01).GetInclbQty,yunhaibao
/// 			 2021-05-18, 批次可用效期判断等调用公共
/// 			 2021-12-30,增加门诊发药批次，找整包装批次 zhaozhiduan
/// Debug:		 w ##class(web.DHCSTSTKQTY).GetInclbQty(250,20,257,987414997)
ClassMethod GetInclbQty(inc As %Library.String = "", newqty As %Library.String = "", ctloc As %Library.String = "", pid, qtyType = "")
{
    q:'$d(^INCI("IL_LOC",ctloc,inc)) 0
    k GetInclbQtyDATA
    k ^TMPGETINCLB(pid)
    s DispActiveFlag=##class(web.DHCST.Common.AppCommon).GetParamOeoriBatActiveDisp(ctloc)
    s hospId=$p($g(^CTLOC(ctloc)),"^",22)
    s SelBatFlag=##Class(web.DHCSTCOMMPARA).GetSelBatRule(hospId)	
    i qtyType=1  d
	.s cfFlag=##class(PHA.COM.Drug).IsHerb(inc)
	.i cfFlag="Y" s qtyType=""
	s fac = 1 
	i qtyType=1  d
	.s minUomId = "" 
	.s minDispUomId = ..GetMinDispUom(inc, ctloc)
	.i (minDispUomId '= "") s minUomId = minDispUomId
	.e  d 
	..s outUomId=$p(^INCI(inc,1),"^",12) 
	..i outUomId="" s outUomId=$p(^INCI(inc,3),"^",6)
	..s minUomId = outUomId
	.s bUomId=$p(^INCI(inc,1),"^",10)
	.s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(minUomId,bUomId)

    s stkflag=0
	s inclb=""
	f  s inclb=$o(^DHCINCLBi("ACISTKBT","Y",ctloc,inc,inclb)) q:(inclb="")!(newqty=0)  d
    .q:+inclb=0
    .s incqty=0,cil=$p(inclb,"||",2),clb=$p(inclb,"||",3)
    .q:'$d(^INCI(inc,"IL",cil,"LB",clb))
    .q:..ValidInclbForDisp(inclb)'="Y"
    .s incibrowid=$P(^INCI(inc,"IL",cil,"LB",clb),"^",1)
    .s cib=$p(incibrowid,"||",2)
    .q:cib=""
    .s xqdate=+$p(^INCI(inc,"IB",cib),"^",2)
    .s incqty=##CLASS(web.DHCSTSTKQTY).GetCurQtyINCLB(inclb)
    .q:incqty'>0
    .// 20190829,yunhaibao+
	.s (DateAdd,TimeAdd,ManfID)="0"
	.s dhcincib=$o(^DHCINCIB(0,"INCIB",incibrowid,""))
	.i dhcincib'="" d
	..s DHCINCIB=$g(^DHCINCIB(dhcincib))
	..s DateAdd=+$p(DHCINCIB,"^",10)
	..s TimeAdd=+$p(DHCINCIB,"^",11)
	.i SelBatFlag=1 d
	..s index1=+xqdate	//有效期优先
	..s index2=DateAdd
	..s index3=TimeAdd
	.e  d
	..s index1=+DateAdd	//先进先出
	..s index2=TimeAdd
	..s index3=xqdate  
	.i qtyType=1 s incqty=(incqty\fac)*fac  // 门诊西药 取整包装数量()  zhaozhiduan 2021-12-29
	.s GetInclbQtyDATA(pid,index1,index2,index3,clb,inclb)=incqty_"^"_inclb
    q:'$d(GetInclbQtyDATA) stkflag
    s inclbCnt=0
    s index1=""
    f  s index1=$o(GetInclbQtyDATA(pid,index1)) q:(index1="")!(newqty=0)  d
   	.s index2=""
    .f  s index2=$o(GetInclbQtyDATA(pid,index1,index2)) q:(index2="")!(newqty=0)  d
    ..s index3=""
    ..f  s index3=$o(GetInclbQtyDATA(pid,index1,index2,index3)) q:(index3="")!(newqty=0)  d
    ...s clb=""
    ...f  s clb=$o(GetInclbQtyDATA(pid,index1,index2,index3,clb)) q:(clb="")!(newqty=0)  d
    ....s inclb=""
    ....f  s inclb=$o(GetInclbQtyDATA(pid,index1,index2,index3,clb,inclb)) q:(inclb="")!(newqty=0)  d
    .....s xqclbdata=$g(GetInclbQtyDATA(pid,index1,index2,index3,clb,inclb))
    .....s xqclbqty=$p(xqclbdata,"^",1)
    .....s xqinclb=$p(xqclbdata,"^",2)
    .....s inclbCnt=inclbCnt+1
    .....i xqclbqty'<newqty  d
    ......s $p(^TMPGETINCLB(pid,inclbCnt),"^",1)=newqty
	......s newqty=0  
	......s stkflag=1  
	.....e  d
	......s $p(^TMPGETINCLB(pid,inclbCnt),"^",1)=xqclbqty                                         
	......s newqty=newqty-xqclbqty
	.....s $p(^TMPGETINCLB(pid,inclbCnt),"^",2)=xqinclb
	k GetInclbQtyDATA
    q stkflag
}

/// 取批次库存数量
ClassMethod GetCurQtyINCLB(inclb) As %String
{
	s phyqty=..CurQtyINCLB(inclb)
	s dirtyqty=$p(^INCI(+inclb,"IL",$p(inclb,"||",2),"LB",$p(inclb,"||",3)),"^",3)	//出库占用数
	s phyqty=+phyqty
	s dirtyqty=+dirtyqty
	s qty=phyqty-dirtyqty
	q qty
}

/// Descript：	取批次库存可用数量(当前实际库存数-出库占用数-医嘱占用数),开医嘱用
/// Creater：	zhouyg
/// CreateDate：2014-12-24
/// Input：		inclb-inc_itmlcbt的ID
/// Return：	可用数量(基本单位)
ClassMethod GetAvialQtyINCLB(inclb) As %String
{
	s inci = +inclb, il = +$p(inclb, "||", 2), lb = +$p(inclb, "||", 3)
	s inclbData = $g(^INCI(inci, "IL", il, "LB", lb))
	s incib = $p(inclbData, "^", 1), ib = $p(incib, "||", 2)
	q:(..ValidInclbForOrder(inclb) '= "Y") 0
	s phyQty = ..CurQtyINCLB(inclb)
  	s dirtyQty = $p(inclbData, "^", 3)	//出库占用数
  	if (dirtyQty < 0){
		s dirtyQty = 0  
	}
  	s ordResQty = 0
  	s dhcInclb = $o(^DHCINCLB(0, "LB", inclb, ""))
  	if (dhcInclb '= ""){
		s ordResQty = +$p(^DHCINCLB(+dhcInclb), "^", 3)	
		if (ordResQty < 0){
			s ordResQty = 0
		}
	}
	q phyQty - dirtyQty - ordResQty
}

/// Descript： 	取库存数量、在途数
/// Creater：	zhouyg
/// CreateDate：	2015-01-19
/// Input：		incil-科室库存项ID,IfCheckStatue-是否检查批次状态
/// Return：		当前库存数^可用库存数^医嘱占用数^库存业务占用数
/// 仅供下医嘱
ClassMethod GetIncilQtyList(incil, IfCheckStatue) As %String
{
	s inci=$p(incil,"||",1)
	s ilSub=$p(incil,"||",2)
	q:(inci="")&(ilSub="") ""
	s locID=$p($g(^INCI(inci,"IL",ilSub)),"^",1)
	q:locID="" ""
	s HospID=$p($g(^CTLOC(locID)),"^",22)
	q:HospID="" ""
	s RuleFlag=##Class(web.DHCSTCOMMPARA).GetRpRule(HospID)  
	s lbSub=0,CurQty=0,oeResQty=0,trResQty=0,AvailQty=0
	i RuleFlag'=3 d
	.s oeResQty=$p(^INCI(inci,"IL",ilSub),"^",10)
	s inclb=""
	f  s inclb=$o(^DHCINCLBi("ACIBT","Y",locID,inci,inclb)) q:(inclb="")  d
	.s lbSub=$p(inclb,"||",3)
	.q:'$d(^INCI(inci,"IL",ilSub,"LB",lbSub))
    .s incib=$P(^INCI(inci,"IL",ilSub,"LB",lbSub),"^",1)
    .s cib=$p(incib,"||",2)
    .q:cib=""
	.s xqdate=+$p(^INCI(inci,"IB",cib),"^",2)
	.q:(IfCheckStatue="Y")&&(..ValidInclbExpDate(inclb) '= "Y") //yunhaibao,过滤效期 
	.q:'$d(^DHCINCLB(0,"LB",inclb))
	.s dhcinclb=$o(^DHCINCLB(0,"LB",inclb,""),-1)
    	.q:(IfCheckStatue="Y")&&($p($g(^DHCINCLB(+dhcinclb)),"^",4) '= "Y") // yunhaibao, 2023-05-29, 库存批次不可用
	.s sCurQty=..CurQtyINCLB(inclb)	//实库存数
	.s strResQty=+$p(^INCI(inci,"IL",ilSub,"LB",lbSub),"^",3)	//库存业务占用数
	.s soeResQty=0
	.i RuleFlag=3 d
	..s dhcinclb=$o(^DHCINCLB(0,"LB",inclb,""))
	..i dhcinclb'="" d
	...s soeResQty=+$p(^DHCINCLB(dhcinclb),"^",3)	//批次医嘱占用数
	.//
	.s CurQty=CurQty+sCurQty
	.s oeResQty=oeResQty+soeResQty
	.s trResQty=trResQty+strResQty
	s AvailQty=CurQty-oeResQty-trResQty
	s RetStr=CurQty_"^"_AvailQty_"^"_oeResQty_"^"_trResQty
	q RetStr
}

/// creator:yunhaibao
/// createdate:20160303
/// description:因8.0.1版本发药需过滤掉批次停用以及过期药品批次,此处用于获取科室库存项有效库存
/// BS发药取批次库存ID
/// Others:	hulihua2018-10-22增加CallType表示是否判断医嘱批次不可用是否允许发药的配置
/// w ##Class(web.DHCSTSTKQTY).GetIncilValidQty("2491","224",1)
ClassMethod GetIncilValidQty(inc As %Library.String, ctloc As %Library.String, calltype As %String = "")
{
    s clb="0",incilqty=0
    s cil=""
    q:'$d(^INCI("IL_LOC",ctloc,inc)) 0
	s inclb=""
	i calltype="1" d // 发药
	.f  s inclb=$o(^DHCINCLBi("ACISTKBT","Y",ctloc,inc,inclb)) q:(inclb="")  d
	..q:(..ValidInclbForDisp(inclb) '= "Y")
	..d CalcuGetIncilValidQty
	e  d			 // 开医嘱
	.f  s inclb=$o(^DHCINCLBi("ACIBT","Y",ctloc,inc,inclb)) q:(inclb="")  d
	..q:(..ValidInclbForOrder(inclb) '= "Y")
	..d CalcuGetIncilValidQty
	q incilqty
CalcuGetIncilValidQty
    s incqty=##CLASS(web.DHCSTSTKQTY).GetCurQtyINCLB(inclb)
    q:incqty'>0
    s incilqty=incilqty+incqty
    q
}

/// Description: 获取批次数量,用于批次价发药判断发药数量不算在途
/// Creator:	 yunhaibao
/// CreateDate:  2018-10-23
ClassMethod GetInclbQtyForDisp(Inclb) As %String
{
	q:(+Inclb = 0) 0
	q:(..ValidInclbForDisp(Inclb) '= "Y") 0
	q ..GetCurQtyINCLB(Inclb)
}

/// Description: 验证某批次药品是否允许开发
/// Debug:		 w ##Class(web.DHCSTSTKQTY).ValidInclbForOrder("3018||2||2")
ClassMethod ValidInclbForOrder(inclb)
{
	s dhcInclb = $o(^DHCINCLB(0, "LB", inclb, ""), -1)
	s data = $g(^DHCINCLB(dhcInclb))
	s stkActiveFlag = $p(data, "^", 4)
	s ordActiveFlag = $p(data, "^", 2)
	q:(ordActiveFlag '= "Y") "N"	
	q:(stkActiveFlag '= "Y") "N"
	q:(..ValidInclbExpDate(inclb) '= "Y") "N"	
	q "Y"
}

/// Description: 验证某批次药品是否允许发药
/// w ##Class(web.DHCSTSTKQTY).ValidInclbForDisp("3018||2||1")
ClassMethod ValidInclbForDisp(inclb)
{
	s dhcInclb = $o(^DHCINCLB(0, "LB", inclb, ""), -1)
	s data = $g(^DHCINCLB(dhcInclb))
	s loc = $p($g(^INCI(+inclb, "IL", $p(inclb, "||", 2))), "^", 1)
	/* 医嘱批次不可用的是否可发药 */
	s pDispActiveFlag = ##class(web.DHCST.Common.AppCommon).GetParamOeoriBatActiveDisp(loc)
	s stkActiveFlag = $p(data, "^", 4)
	s ordActiveFlag = $p(data, "^", 2)
	q:(pDispActiveFlag '= "Y")&&(ordActiveFlag '= "Y") "N"
	q:(stkActiveFlag '= "Y") "N"
	q:(..ValidInclbExpDate(inclb) '= "Y") "N"
	q "Y"
}

/// Description: 验证某批次药品是否符合效期要求
/// Return:		 Y - 符合
ClassMethod ValidInclbExpDate(inclb)
{
	s inci = +inclb
	s expReq = $p(^INCI(inci, 2), "^", 11)
	q:(expReq '= "R") "Y"
	s itmAdd = $o(^DHCITMINFO(0, "INCI", inci, ""))
	s expLen = $p($g(^DHCITMINFO(+itmAdd)), "^", 32)
	s incib = $P(^INCI(+inclb, "IL", $p(inclb, "||", 2), "LB", $p(inclb, "||", 3)), "^", 1)
	s expDate = $p(^INCI(+incib, "IB", +$p(incib, "||", 2)), "^", 2)
	q:(expDate = "") "Y"
	q:((expDate - expLen) >= +$h) "Y"
	q "N"
}

/// Creator		zhaozhiduan
/// CreatDate	2022年11月16日
/// Description 药品的科室发药单位
/// Debug		w ##class(web.DHCSTSTKQTY).GetMinDispUom({}).%ToJSON()
/// Input
/// OutPut		0/1
ClassMethod GetMinDispUom(inci, loc)
{
	q:(inci = "")||(loc = "") ""
	s il = $o(^INCI("IL_LOC", loc, inci,0))
	q:(il = "") ""
	s incil = inci _ "||" _il
	s bUomId = $p(^INCI(inci, 1), "^", 10) 
	s curDate = +$h
	s minFac = 0
	s minUomId = ""
	s ilduId = "" 
	for {
		s ilduId = $o(^DHCILDU(0,"INCIL",incil,ilduId))
		q:(ilduId = "")
		s frDate = $p(^DHCILDU(ilduId),"^",3)
		continue:(frDate '= "")&&(frDate > curDate)
		s endDate = $p(^DHCILDU(ilduId),"^",4)
		continue:(endDate '= "")&&(endDate < curDate)
		s uomId = $p(^DHCILDU(ilduId),"^",1)
		continue:(uomId = "")
		s fac =##class(PHA.COM.Method).UomFac(uomId, bUomId)
		s:(minFac > fac)||(minUomId = "") minFac = fac,minUomId= uomId  
		
	}
	q minUomId
}

}
