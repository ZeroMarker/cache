Import sqluser

/// creator:	yunhaibao
/// createdate: 2018-10-26
/// description:病区发药特定查询(最终按病人+库存项合计显示)
Class web.DHCINPHA.WardIncStat.Query Extends %RegisteredObject
{

/// description: 统计数据入口
/// ^TMP("DHCST","web.DHCINPHA.WardIncStat.Query","GetWardPatIncData")
/// w ##class(web.DHCINPHA.WardIncStat.Query).GetWardPatIncData("2018-01-01|@|2018-09-01|@|98")
ClassMethod GetWardPatIncData(InputStr)
{
	q:InputStr="" ""
	s CS="|@|"
	s StartDate=$p(InputStr,CS,1)
	s EndDate=$p(InputStr,CS,2)
	s StartTime=$p(InputStr,CS,3)
	s EndTime=$p(InputStr,CS,4)
	s IncId=$p(InputStr,CS,5)
	s PatNo=$p(InputStr,CS,6)
	s WardId=$p(InputStr,CS,7)
	s PhaLocId=$p(InputStr,CS,8)
	q:PhaLocId="" ""
	s CatCodeStr=$p(InputStr,CS,9)
	s CatCodeList=$lfs(CatCodeStr,",")
	s PoisonId=$p(InputStr,CS,10)
	s PatName=$p(InputStr,CS,11)
	s pid=..NewPid()
	s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	s StartTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(StartTime)
	s EndTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(EndTime)
	s trTypeStr="P"
	s trLen=$l(trTypeStr,"^")
	s trI=0
	f trI=1:1:trLen d
	.s trType=$p(trTypeStr,"^",trI)
	.q:trType=""
	.s calcuDate=""
	.f calcuDate=StartDate:1:EndDate d
	..s intr=0
	..f  s intr=$o(^DHCINTR(0,"LOCTYPEDATE",PhaLocId,trType,calcuDate,intr)) q:intr=""  d 
	...s intrData=$g(^DHCINTR(intr))
	...q:intrData=""
	...s quitFlag=""
	...s pointer=$p(intrData,"^",9)
	...q:$d(GetWardPatIncDataArr("PhacId",+pointer))
	...s inclb=$p(intrData,"^",7)
	...s incId=+inclb
	...s spAmt=$p(intrData,"^",8)
	...s qty=$p(intrData,"^",6)
	...s wardId=$p($g(^DHCPHAC(+pointer)),"^",4)
	...// 过滤条件-时间
	...s intrTime=$p(intrData,"^",3)
	...q:(calcuDate=StartDate)&&(intrTime<StartTime)
	...q:(calcuDate=EndDate)&&(intrTime>EndTime)
	...// 过滤条件-病区
	...i (WardId'="")&&(WardId'=wardId) s GetWardPatIncDataArr("PhacId",+pointer)="",quitFlag=1 q
	...s oeori=$p($g(^DHCPHAC(+pointer,"I",+$p(pointer,"||",2))),"^",7)
	...s admId=$p($g(^OEORD(+oeori)),"^",1)
	...s patId=$p($g(^PAADM(+admId)),"^",1)
	...s patNo=$p($g(^PAPER(+patId,"PAT",1)),"^",1)
	...// 过滤条件-登记号
	...q:(PatNo'="")&&(PatNo'=patNo)
	...s patName=$p(^PAPER(patId,"ALL"),"^",1)
	...// 过滤条件-姓名
	...q:(PatName'="")&&(patName'[PatName)
	...// 过滤条件-发药类别
	...i CatCodeStr'="" d
	....s catCode=$p(^DHCPHAC(+pointer),"^",12)
	....i $lf(CatCodeList,catCode)=0 d
	.....s GetWardPatIncDataArr("PhacId",+pointer)="",quitFlag=1
	...q:quitFlag'=""
	...// 过滤条件-管制分类
	...i PoisonId'="" d
	....i $d(GetWardPatIncDataData("IncPoison",incId)) s poisonId=GetWardPatIncDataData("IncPoison",incId)
	....e  d
	.....s poisonId=$p(##class(web.DHCST.Common.DrugInfoCommon).GetMangerDrug(incId),"^",2)
	.....s GetWardPatIncDataData("IncPoison",incId)=poisonId
	....i poisonId'=PoisonId s quitFlag=1 q
	...q:quitFlag'=""
	...// 过滤条件-药品
	...q:(IncId'="")&&(IncId'=incId)
	...s sortIndex=wardId_"^"_patNo
	...i '$d(^TMP("DHCST",$ClassName(),"GetWardPatIncData",pid,sortIndex,incId)) d
	....s data=spAmt_"^"_qty_"^"_patNo_"^"_patName
	....s ^TMP("DHCST",$ClassName(),"GetWardPatIncData",pid,sortIndex,incId)=data
	...e  d
	....s $p(^TMP("DHCST",$ClassName(),"GetWardPatIncData",pid,sortIndex,incId),"^",1)=spAmt+$p(^TMP("DHCST",$ClassName(),"GetWardPatIncData",pid,sortIndex,incId),"^",1)
	....s $p(^TMP("DHCST",$ClassName(),"GetWardPatIncData",pid,sortIndex,incId),"^",2)=qty+$p(^TMP("DHCST",$ClassName(),"GetWardPatIncData",pid,sortIndex,incId),"^",2)
	k GetWardPatIncDataArr
	k GetWardPatIncDataData
	q pid
}

/// description: 进程号
ClassMethod NewPid()
{
	q ##class(web.DHCSTKUTIL).NewPid($ClassName(),"IP")
}

}
