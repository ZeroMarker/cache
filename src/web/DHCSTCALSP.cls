Import SQLUser

Class web.DHCSTCALSP Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// ;Last Update:2006-10-17,2006-11-16,2006-12-04
ClassMethod CalSp(incicode, rp) As %String
{
 n (incicode,rp)
 s inci=##class(web.DHCSTCOMMONSRV).ItemCodeToID(incicode)
 q ..CalSpInci(inci,rp)
}

ClassMethod CalSpInci(inci, rp) As %String
{
 n (inci,rp)
 s type=..ItmType(inci)
 i type="M" d
 . s newsp=..CalSpMat(inci,rp)
 e  d
 . s newsp=..CalSpGrug(inci,rp)
 q +$g(newsp)
}

ClassMethod CalSpGrug(inci, rp) As %String
{
 ;如果sp<10按照  三七作五 二舍八入 原则 保留到5分
 ;'如果sp>10按照 四舍五入 原则 保留到角
 n (inci,rp)
 &sql(select info_mt_dr into :marktype From dhc_itmaddioninfo where info_inci_dr=:inci)
 q:'$g(marktype) 0 
 s onlyone=0
 &sql(declare xxxx cursor for select mr_minrp,mr_maxrp,mr_margin 
 from dhc_markrule where mr_mt_dr=:marktype )
 &sql(open xxxx)
 s mm=0
 f  &sql(fetch xxxx into :mmin,:mmax,:mmargin) q:SQLCODE!(onlyone=1)  d
 . i (+mmin=0)&(+mmax=0) s onlyone=1,mm=mmargin q
 . i (rp>=+mmin)&(rp<=+mmax) s onlyone=1,mm=mmargin q
 . i (rp>=mmin)&(+mmax=0) s onlyone=1,mm=mmargin q
 &sql(close xxxx)
 ;w +mm,!
 i +mm=0  d
 . s newsp=0 
 e   d
 . s newsp=rp*mm
 ;w mm,!
 s marktype=+marktype
 i (marktype=1)!(marktype=2) d
 . ;w "cal"
 . i newsp < 10 d
 . . s newsp = $fn(($fn(newsp*2,"",1)/2),"",2)
 . e  d
 . . s newsp = $fn(newsp,"",1)
 q $g(newsp)
}

ClassMethod CalSpMat(inci, rp) As %String
{
 n (inci,rp)
 s aa=""
 &sql(select info_mt_dr into :aa
 From dhc_itmaddioninfo where info_inci_dr=:inci)
 ;w mt,!
 i '$g(aa) d
 . s margin=1.15
 e   d
 . &sql(select mr_margin into :margin from dhc_markrule where mr_mt_dr=:aa) 
 q $fn(+rp*(+$g(margin)),"",4)
}

ClassMethod ItmType(inci) As %String
{
 n (inci)
 q:inci="" ""
 s inci=+inci
 q:'$d(^INCI(inci,2)) ""
 s incsc=+$p(^INCI(inci,2),"^",2)
 &sql(select scgr_scg_parref->scg_type into :aa From dhc_stkcatgrprelations where scgr_stkcat_dr=:incsc)
 q $p($g(aa),$c(1))
}

ClassMethod BatSp(inclb) As %String
{
 n (inclb)
 s ingri=##class(web.DHCSTPRICE).LastINGRI(inclb) q:ingri="" ""
 s DHCINGR=$p(ingri,"||",1) q:DHCINGR="" ""
 s DHCCH=$p(ingri,"||",2) q:DHCCH="" ""
 s newsp=$p(^DHCINGR(DHCINGR,"GRI",DHCCH),"^",45)
 s UOM=$p(^DHCINGR(DHCINGR,"GRI",DHCCH),"^",10)
 s buom=$p(^INCI(+inclb,1),"^",10)
 s fac=##class(web.DHCSTCOMMONSRV).UOMFac(UOM,buom)
 q $g(newsp)/fac
}

ClassMethod BatSpUom(inclb, uom) As %String
{
 n (inclb,uom)
 s ingri=##class(web.DHCSTPRICE).LastINGRI(inclb) q:ingri="" ""
 s DHCINGR=$p(ingri,"||",1) q:DHCINGR="" ""
 s DHCCH=$p(ingri,"||",2) q:DHCCH="" ""
 s newsp=+$p(^DHCINGR(DHCINGR,"GRI",DHCCH),"^",45)
 s RecUOM=$p(^DHCINGR(DHCINGR,"GRI",DHCCH),"^",10)
 s buom=$p(^INCI(+inclb,1),"^",10)
 s:uom="" uom=buom
 s fac1=##class(web.DHCSTCOMMONSRV).UOMFac(uom,buom)
 s fac2=##class(web.DHCSTCOMMONSRV).UOMFac(RecUOM,buom)
 s:RecUOM'=uom newsp=newsp/fac2*fac1
 q $g(newsp)
}

ClassMethod CalSpByMT(mtdesc, rp) As %String
{
 N (mtdesc,rp)
 Q:+rp=0 0
 //n mtdr,onlyone,maflag,newsp
 //n mrid,mmin,mmax,mmargin,mmaxmprice,mm,mDecimalLen,mPrice
 k PLIST
 //s mtdr=$$GetMtRowidBydesc^DHCSTCOMMONSRV2(mtdesc)  //zhwh 2010.12.26暂时屏蔽
 s mtdr=""   //zhwh 2010.12.26暂时屏蔽
 q:mtdr="" 0
 s onlyone=0,newsp=0,lmmaxp=0,lsddr="",maflag="",lmmaxm=0
 s yes="Y"
 &sql(declare curr cursor for select mr_rowid,mr_minrp,mr_maxrp,mr_margin,MR_MaxMPrice,MR_SD_Dr,MR_MPrice,MR_MaxMargin
  from dhc_markrule where mr_mt_dr=:mtdr and mr_useflag=:yes)
 &sql(open curr)
 f  &sql(fetch curr into :mrid,:mmin,:mmax,:mmargin,:mmaxmprice,:mSDDr,:mPrice,:mmaxmargin) q:SQLCODE!(onlyone=1)  d
 .s maflag=$o(^DHCINMRA(+mrid,"I","")) 
 .S mmargin=+mmargin
 .I mmargin=0 S mmargin=1
 .S mPrice=+mPrice
 .s lmmaxp=+mmaxmprice
 .S lmmaxm=+mmaxmargin
 .S lsddr=$P(mSDDr,$C(1))
 .///1 下限和上限都没有限制
 .i (+mmin=0)&(+mmax=0) d
 ..s onlyone=1
 ..i maflag="" S newsp=rp*mmargin+mPrice
 ..e  s newsp=..CalSpByMTAdd(mrid,rp)
 .q:onlyone=1
 .///2 上下限之间
 .i (rp>=+mmin)&(rp<=+mmax) d
 ..s onlyone=1
 ..s mm=+mmaxmprice
 ..i maflag="" S newsp=rp*mmargin+mPrice
 ..e  s newsp=..CalSpByMTAdd(mrid,rp)
 .q:onlyone=1
 .///3 上限没有限制
 .i (rp>=+mmin)&(+mmax=0) d
 ..s onlyone=1
 ..s mm=+mmaxmprice
 ..i maflag="" S newsp=rp*mmargin+mPrice
 ..e  D
 ...s newsp=..CalSpByMTAdd(mrid,rp)
 &sql(close curr)
 I lsddr'="" D //有小数规则维护
 .S newsp=..CalDecimal(newsp,lsddr)
 i (lmmaxp'=0)&((newsp-rp)> lmmaxp) s newsp=rp+lmmaxp
 i (lmmaxm'=0)&(newsp/rp>lmmaxm) S newsp=newsp*lmmaxm
 q newsp
}

ClassMethod CalSpByMTAdd(mrdr, rp) As %String
{
 q:mrdr="" 0
 q:+rp=0 0
 n amin,amax,amargin,newsp,i,lamax
 s newsp=0,i=0,onlyone=0,lamax=0
 s yes="Yes"
 &sql(declare curmra cursor for select mra_minrp,mra_maxrp,mra_margin
 from DHC_MarkRuleAdd where MRA_MR_Parref=:mrdr and MRA_UseFlag=:yes order by mra_minrp)
 &sql(open curmra)
 f  &sql(fetch curmra into :amin,:amax,:amargin) q:SQLCODE!(onlyone=1)  d
 .s amin=+amin,amax=+amax,amargin=+amargin
 .s i=i+1
 .i (rp>=amin)&((rp<=amax)!(amax=0)) D
 ..s onlyone=1
 ..S newsp=newsp+((rp-lamax)*amargin)
 .Q:onlyone=1
 .i (amax'=0)&(rp>amax) D
 ..s newsp=newsp+((amax-lamax)*amargin)
 .s lamax=amax
 &sql(close curmra)
 q newsp
}

/// Descript:	根据小数位数规则计算double类型数据
/// Creater:	zhouyg
/// CreateDate:	20090903
/// Input:		dPara-要计算的数值，SDdr-小数计算规则
/// Output:		Retvalue
/// Retvalue:	计算结果
ClassMethod CalDecimal(dPara, SDdr) As %String
{
 N (dPara,SDdr)
 Q:SDdr="" dPara
 Q:'$D(^DHCSD(SDdr)) dPara
 S UseFlag=$P(^DHCSD(SDdr),"^",3)
 Q:UseFlag'="Y" dPara
 S sub=0,uFlag=0
 F  S sub=$O(^DHCSD(SDdr,"I",sub)) Q:(sub="")!(sub=0)!(uFlag=1)  D
 .S sData=^(sub)
 .S Min=+$P(sData,"^",1)
 .S Max=+$P(sData,"^",2)
 .S Len=+$P(sData,"^",3)
 .I (Min=0)&(Max=0) D
 ..S uFlag=1
 ..S dPara=$FN(dPara,"",Len)
 .Q:uFlag=1
 .I (dPara>=Min)&((dPara<=Max)!(Max=0)) D
 ..S uFlag=1
 ..S dPara=$FN(dPara,"",Len)
 .Q:uFlag=1
 Q dPara
}

/// Descript:   根据医嘱项计算批次的售价
/// Creater:	zhouyg
/// CreateDate:	20100413
/// Input:		Arcim-医嘱项ID,Uomdr-单位ID,LocDr-药房科室ID,Qty-数量
/// Output:		Retvalue
/// Retvalue:	计算的售价
ClassMethod GetArcBatSp(Arcim, LocDr, Uomdr, Qty) As %String
{
 N (Arcim,LocDr,Uomdr,Qty)
 S RetSp=0
 Q:Arcim="" RetSp
 Q:+Qty=0 RetSp
 Q:LocDr="" RetSp
 S Arsub=$P(Arcim,"||")
 Q:Arsub="" RetSp
 S inci=$O(^INCI(0,"ARCIM_DR",Arsub,""))
 Q:inci="" RetSp
 Q:'$D(^INCI(inci)) RetSp
 S RetSp=..GetIncBatSp(inci,LocDr,Uomdr,Qty)
 Q RetSp
}

/// Descript: 根据库存项计算批次的售价
/// Creater:	zhouyg
/// CreateDate:	20100413
/// Input:		inci-库存项ID,Uomdr-单位ID,LocDr-药房科室ID,Qty-数量
/// Output:		Retvalue
/// Retvalue:	计算的售价
ClassMethod GetIncBatSp(inci, LocDr, Uomdr, Qty) As %String
{
 N (inci,LocDr,Uomdr,Qty)
 S RetSp=0
 Q:inci="" RetSp
 Q:+Qty=0 RetSp
 Q:LocDr="" RetSp
 Q:'$D(^INCI(inci)) RetSp
 Q:'$D(^CTLOC(LocDr)) RetSp
 S sptype=..GetSpType(inci)
 S Puomdr=$P(^INCI(inci,3),"^",6)
 S Buomdr=$P(^INCI(inci,1),"^",10)
 I Uomdr="" S Uomdr=Buomdr
 S Pfac=+##class(web.DHCSTCOMMONSRV).UOMFac(Puomdr,Buomdr)
 Q:Pfac=0 RetSp
 S Ufac=+##class(web.DHCSTCOMMONSRV).UOMFac(Uomdr,Buomdr)
 Q:Ufac=0 RetSp
 S bQty=Qty*Ufac
 S HospID=$P(^CTLOC(LocDr),"^",22)
 S clbstr=..GetInclbList(inci,LocDr,bQty)
 Q:clbstr="" 0
 S clbnum=$L(clbstr,"!")
 S TAmt=0
 F i=1:1:clbnum D
 .S curclb=$P(clbstr,"!",i)
 .S inclb=$P(curclb,"^",1)
 .S clbqty=$P(curclb,"^",2)
 .S Prp=##class(web.DHCSTPRICE).LastInPrice(inclb,Puomdr)
 .S Psp=..CalSpByMT(sptype,Prp)
 .S Bsp=Psp/Pfac
 .S TAmt=Bsp*clbqty+TAmt
 S sp=TAmt/bQty
 S Usp=sp*Ufac
 //S Asp=##class(web.DHCSTCOMMONSRV).GetPriceElse(inci,+$H,Uomdr,HospID)
 s Asp=##class(web.DHCSTPRICE).GetSp(+inci,+$h,Uomdr,HospID,"")	//zhouyg 20150113
 S RetSp=Usp
 I (Usp>Asp)&(Asp'=0) S RetSp=Asp
 Q RetSp
}

/// Descript:   按照规则取符合条件的批次列表
/// Creater:	zhouyg
/// CreateDate:	20100413
/// Input:		inci-库存项ID,LocDr-药房科室ID,bQty-基本单位数量
/// Output:		Retvalue
/// Retvalue:	inclb1^基本单位数量1!inclb2^基本单位数量2……
ClassMethod GetInclbList(inci, LocDr, bQty) As %String
{
 N (inci,LocDr,bQty)
 Q:inci="" ""
 Q:LocDr="" ""
 Q:+bQty="" ""
 Q:'$D(^INCI(inci)) ""
 S ILSub=$O(^INCI("IL_LOC",LocDr,inci,""))
 Q:ILSub="" ""
 S incil=inci_"||"_ILSub
 l +^DHCINCIL(incil):10  e  q RetStr
 //1 先取满足库存条件的最早的批次
 S clbstr=..GetInclbByQty(incil,bQty)
 //2 如果没有满足库存的批次，则按效期取多个批次
 I clbstr="" D
 .S clbstr=..GetInclbByExp(incil,bQty)
 l -^DHCINCIL(incil)
 Q clbstr
}

/// Descript:   取数量符合条件的批次
/// Creater:	zhouyg
/// CreateDate:	20100413
/// Input:		inci-库存项ID,bQty-基本单位数量
/// Output:		Retvalue
/// Retvalue:	inclb^基本单位数量
ClassMethod GetInclbByQty(incil, bQty) As %String
{
 N (incil,bQty)
 S inclb="",AvailQty=0
 &SQL(SELECT INCLB_ROWID,INCLB_PHYQTY-nvl(INCLB_DirtyQty,0) Into :inclb,:AvailQty FROM INC_ITMLCBT 
 WHERE INCLB_INCIL_PARREF=:incil And  (INCLB_PHYQTY-nvl(INCLB_DirtyQty,0))>:bQty order by INCLB_INCIB_DR->INCIB_EXPDATE)
 Q:inclb="" ""
 Q inclb_"^"_bQty
}

/// Descript:   按照效期和发药数量取批次
/// Creater:	zhouyg
/// CreateDate:	20100413
/// Input:		inci-库存项ID,bQty-基本单位数量
/// Output:		Retvalue
/// Retvalue:	inclb1^基本单位数量1!inclb2^基本单位数量2……
ClassMethod GetInclbByExp(incil, bQty) As %String
{
 n (incil,bQty)
 S RetStr=""
 s aclbstr=..GetAClbByExp(incil)
 i aclbstr=""  l -^DHCINCIL(incil) q RetStr
 S cnum=$L(aclbstr,"!")  
 s k=0
 s sumdqty=0
 s clbqty=bQty
 f i=1:1:cnum q:clbqty'>0  d
 .S tstr=$P(aclbstr,"!",i)
 .S inclb=$P(tstr,"^",1)
 .S Eqty=$P(tstr,"^",2)
 .i Eqty'<clbqty d
 ..s k=k+1
 ..S clbstr=inclb_"^"_clbqty
 ..s sumdqty=sumdqty+clbqty
 ..s clbqty=0
 .e  d
 ..s k=k+1
 ..S clbstr=inclb_"^"_Eqty
 ..s sumdqty=sumdqty+Eqty
 ..s clbqty=clbqty-Eqty
 .I RetStr="" S RetStr=clbstr
 .E  S RetStr=RetStr_"!"_clbstr
 Q:sumdqty<bQty "" //当所查到的可发批次库存之和<发药总数量
 q RetStr
}

/// Descript:   按照效期排序序取所有批次
/// Creater:	zhouyg
/// CreateDate:	20100413
/// Input:		incil-科室库存项ID(inc_itmloc)
/// Output:		Retvalue
/// Retvalue:	inclb1^基本单位数量1!inclb2^基本单位数量2……
ClassMethod GetAClbByExp(incil) As %String
{
 N (incil)
 S RetStr=""
 &sql(DECLARE CurrExp CURSOR FOR
 SELECT INCLB_ROWID,INCLB_PHYQTY-nvl(INCLB_DirtyQty,0) FROM INC_ITMLCBT 
 WHERE INCLB_INCIL_PARREF=:incil And (INCLB_PHYQTY-nvl(INCLB_DirtyQty,0))>0 order by INCLB_INCIB_DR->INCIB_EXPDATE)
 &sql(open CurrExp)
 s num=0
 f  &sql(fetch CurrExp INTO :tclb,:tqty) q:SQLCODE  d
 .s num=num+1
 .S clbstr=tclb_"^"_tqty
 .I RetStr="" S RetStr=clbstr
 .E  S RetStr=RetStr_"!"_clbstr
 &sql(close CurrExp)
 q RetStr
}

/// Descript:   取定价类型描述
/// Creater:	zhouyg
/// CreateDate:	20100413
/// Input:		inci-库存项ID
/// Output:		Retvalue
/// Retvalue:	定价类型描述
ClassMethod GetSpType(inci) As %String
{
 N (inci)
 q:inci="" ""
 q:'$d(^DHCITMINFO(0,"INCI",inci)) ""
 s DR=$o(^DHCITMINFO(0,"INCI",inci,""))
 q:DR="" ""
 Q:'$D(^DHCITMINFO(DR)) ""
 s tmpdatas=^DHCITMINFO(DR)
 S SPType=""
 s mtdr=$p(tmpdatas,"^",15)
 I mtdr'="" D
 .S:$D(^DHCINMT(mtdr)) SPType=$p(^DHCINMT(mtdr),"^",2)
 Q SPType
}

/// Descript: 根据医嘱ID计算批次的售价
/// Creater:	zhouyg
/// CreateDate:	20100521
/// Input:		Oeori-医嘱ID
/// Output:		Retvalue
/// Retvalue:	计算的售价(基本单位)
ClassMethod GetOeBatSp(Oeori, Uomdr) As %String
{
 N (Oeori,Uomdr)
 S RetSp=0
 Q:Oeori="" RetSp
 S Oeord=$P(Oeori,"||")
 S Oesub=$P(Oeori,"||",2)
 Q:'$D(^OEORD(Oeord,"I",Oesub,1)) RetSp
 S Arcim=$P(^OEORD(Oeord,"I",Oesub,1),"^",2)
 Q:Arcim="" RetSp
 S Arsub=$P(Arcim,"||")
 Q:Arsub="" RetSp
 S inci=$O(^INCI(0,"ARCIM_DR",Arsub,""))
 Q:inci="" RetSp
 Q:'$D(^INCI(inci)) RetSp
 S sptype=..GetSpType(inci)
 S Puomdr=$P(^INCI(inci,3),"^",6)
 Q:Puomdr="" RetSp
 S Buomdr=$P(^INCI(inci,1),"^",10)
 Q:Buomdr="" RetSp
 I Uomdr="" S Uomdr=Buomdr
 S Pfac=+##class(web.DHCSTCOMMONSRV).UOMFac(Puomdr,Buomdr)
 Q:Pfac=0 RetSp
 S Ufac=+##class(web.DHCSTCOMMONSRV).UOMFac(Uomdr,Buomdr)
 Q:Ufac=0 RetSp
 S HospID=""
 S LocDr=$P(^OEORD(Oeord,"I",Oesub,3),"^",6)
 I LocDr'="" D
 .I $D(^CTLOC(LocDr)) S HospID=$P(^CTLOC(LocDr),"^",22)
 S TAmt=0,bQty=0
 S phac=""
 F  S phac=$O(^DHCPHAC(0,"PHADSP",Oeori,phac)) Q:phac=""  D
 .S phacsub=""
 .F  S phacsub=$O(^DHCPHAC(0,"PHADSP",Oeori,phac,phacsub)) Q:phacsub=""  D
 ..Q:'$D(^DHCPHAC(phac,"I",phacsub))
 ..S inclb=$P(^DHCPHAC(phac,"I",phacsub),"^",4)	//inc_itmlcbt的rowid
 ..S clbqty=$P(^DHCPHAC(phac,"I",phacsub),"^",6)	//基本单位数量
 ..S Prp=##class(web.DHCSTPRICE).LastInPrice(inclb,Puomdr)
 ..S Psp=..CalSpByMT(sptype,Prp)
 ..S Bsp=Psp/Pfac
 ..S TAmt=Bsp*clbqty+TAmt
 ..S bQty=bQty+clbqty
 Q:bQty=0 RetSp
 S sp=TAmt/bQty
 S Usp=sp*Ufac
 //S Asp=##class(web.DHCSTCOMMONSRV).GetPriceElse(inci,+$H,Uomdr,HospID)
 s Asp=##class(web.DHCSTPRICE).GetSp(+inci,+$h,Uomdr,HospID,"")	//zhouyg 20150113
 S RetSp=Usp
 I (Usp>Asp)&(Asp'=0) S RetSp=Asp
 Q RetSp
}

}
