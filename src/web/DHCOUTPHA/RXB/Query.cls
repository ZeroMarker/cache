Import sqluser

/// creator:	yunhaibao
/// createdate: 2018-11-06
/// description:门诊日消耗统计
Class web.DHCOUTPHA.RXB.Query Extends %RegisteredObject
{

/// description: 查询
/// 发退药的台账对应基本单位
/// w ##class(web.DHCOUTPHA.RXB.Query).GetRXBStat("100|@|2017-01-01|@|2018-10-10")
ClassMethod GetRXBStat(InputStr)
{
	k GetRXBStatArr
	q:InputStr="" ""
	s CS="|@|"
	s PhaLocId=$p(InputStr,CS,1)
	s StartDate=$p(InputStr,CS,2)
	s EndDate=$p(InputStr,CS,3)
	s FyPersonId=$p(InputStr,CS,4)	// 发药人,ssuser
	s IncId=$p(InputStr,CS,5)
	s StkCatId=$p(InputStr,CS,6)
	s Sp=$p(InputStr,CS,7)
	s ManaFlag=$p(InputStr,CS,8)	// 是否管理药
	s ManaGrpId=$p(InputStr,CS,9)	// 管理组
	s StartTime=$p(InputStr,CS,10)
	s EndTime=$p(InputStr,CS,11)
	s PhcCatId=$p(InputStr,CS,12)
	q:PhaLocId="" ""
	s Incil=""
	i IncId'="" d
	.s IncCh=$o(^INCI("IL_LOC",PhaLocId,IncId,""))
	.q:IncCh=""
	.s Incil=IncId_"||"_IncCh
	s pid=..NewPid()
	s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	s StartTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(StartTime)
	s EndTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(EndTime)
	s trTypeStr="F^H"
	s trLen=$l(trTypeStr,"^")
	s trI=0
	f trI=1:1:trLen d
	.s trType=$p(trTypeStr,"^",trI)
	.q:trType=""
	.s calcuDate=""
	.f calcuDate=StartDate:1:EndDate d
	..i Incil'="" d
	...s intr=0
	...f  s intr=$o(^DHCINTR(0,"ILTYPEDATE",Incil,trType,calcuDate,intr)) q:intr=""  d 
	....d CalcuData
	..e  d
	...s intr=0
	...f  s intr=$o(^DHCINTR(0,"LOCTYPEDATE",PhaLocId,trType,calcuDate,intr)) q:intr=""  d 
	....d CalcuData
	q pid
CalcuData
	s intrData=$g(^DHCINTR(intr))
	q:intrData=""
	s intrTime=$p(intrData,"^",3)
	// 过滤条件-时间
	q:(StartTime'="")&&(StartDate=calcuDate)&&(intrTime<StartTime)
	q:(EndTime'="")&&(EndDate=calcuDate)&&(intrTime>EndTime)
	s pointer=$p(intrData,"^",9)
	s inclb=$p(intrData,"^",7)
	s incId=+inclb
	s quitFlag=""
	// 过滤条件-药学分类
	i PhcCatId'="" d
	.i $d(GetRXBStatArr(incId))&&(GetRXBStatArr(incId)'=1) s quitFlag=1 q 
	.s phcCatAllStr=##class(web.DHCST.Common.DrugInfoCommon).GetPhaCatAll(incId)
	.s phcCatAllId=$p(phcCatAllStr,"^",1)
	.s chkFlag=##class(web.DHCST.Common.DrugInfoCommon).CheckNewCatId(PhcCatId,phcCatAllId)
	.i chkFlag'=1 s quitFlag=1
	.s GetRXBStatArr(incId)=chkFlag
	// 过滤条件-管理组,管理药
	i (ManaGrpId'="")||(ManaFlag="Y") d
	.s incCh=$o(^INCI("IL_LOC",PhaLocId,incId,""))
	.s incil=incId_"||"_incCh
	.i $d(^DHCINCIL(0,"INCIL",incil)) d //管理药,管理组用DHC_IncItmLoc维护,yunhaibao20160526
	..s dhcIncil=$o(^DHCINCIL(0,"INCIL",incil,""))
	..i dhcIncil="" s quitFlag=1 q
	..s manaFlag=$p(^DHCINCIL(dhcIncil),"^",9)
	..s manaGrpId=$p(^DHCINCIL(dhcIncil),"^",7)
	..i ManaGrpId'=manaGrpId s quitFlag=1 q
	..i (ManaFlag="Y")&&(manaFlag'=1) s quitFlag=1 q
	.e  s quitFlag=1 
	//q:quitFlag'=""
	// 过滤条件-发药人
	i FyPersonId'="" d
	.i trType="F" d  //门诊发药
	..s fyPersonId=+$p(^DHCPHDISP(+pointer,1),"^",2)
	..i fyPersonId'=FyPersonId s quitFlag=1 q
	.i trType="H" d  //门诊退药
	..s fyPersonId=+$p(^DHCPHRET(+pointer),"^",8)
	..i fyPersonId'=FyPersonId s quitFlag=1 q
	q:quitFlag'=""
	// 过滤条件-库存分类
	q:(StkCatId'="")&&(StkCatId'=$p(^INCI(incId,2),"^",2))
	s spAmt=$p(intrData,"^",8)
	s rpAmt=$p(intrData,"^",17)
	s qty=$p(intrData,"^",6)
	s sp=$p(intrData,"^",14)
	s rp=$p(intrData,"^",16)
	s incIndex=incId
	s priceIndex=sp_"^"_rp
	i '$d(^TMP("DHCST",$ClassName(),"GetRXBStat",pid,incIndex,priceIndex)) d
	.s incCode=$p(^INCI(incId,1),"^",1)
	.s incDesc=$p(^INCI(incId,1),"^",2)
	.s manfDesc=$p(##class(web.DHCST.Common.DrugInfoCommon).GetManf(incId),"^",3)
	.s uomDesc=""
	.s ^TMP("DHCST",$ClassName(),"GetRXBStat",pid,incIndex,priceIndex)=qty_"^"_spAmt_"^"_rpAmt_"^"_incId_"^"_incCode_"^"_incDesc_"^"_manfDesc_"^"_rp_"^"_sp_"^"_uomDesc_"^"_pid
	e  d
	.s $p(^TMP("DHCST",$ClassName(),"GetRXBStat",pid,incIndex,priceIndex),"^",1)=qty+$p(^TMP("DHCST",$ClassName(),"GetRXBStat",pid,incIndex,priceIndex),"^",1)
	.s $p(^TMP("DHCST",$ClassName(),"GetRXBStat",pid,incIndex,priceIndex),"^",2)=spAmt+$p(^TMP("DHCST",$ClassName(),"GetRXBStat",pid,incIndex,priceIndex),"^",2)
	.s $p(^TMP("DHCST",$ClassName(),"GetRXBStat",pid,incIndex,priceIndex),"^",3)=rpAmt+$p(^TMP("DHCST",$ClassName(),"GetRXBStat",pid,incIndex,priceIndex),"^",3)
	q
}

/// description: 进程号
ClassMethod NewPid()
{
	q ##class(web.DHCSTKUTIL).NewPid($ClassName(),"IP")
}

}
