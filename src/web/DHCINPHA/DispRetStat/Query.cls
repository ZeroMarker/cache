Import sqluser

/// creator:	yunhaibao
/// createdate: 2018-10-25
/// description:病区发退药统计数据
Class web.DHCINPHA.DispRetStat.Query Extends %RegisteredObject
{

/// description: 统计数据入口
/// ^TMP("DHCST","web.DHCINPHA.DispRetStat.Query","GetDispRetData")
/// w ##class(web.DHCINPHA.DispRetStat.Query).GetDispRetData("2018-01-01|@|2018-09-01|@|98")
ClassMethod GetDispRetData(InputStr)
{
	q:InputStr="" ""
	s CS="|@|"
	s StartDate=$p(InputStr,CS,1)
	s EndDate=$p(InputStr,CS,2)
	s PhaLocId=$p(InputStr,CS,3)
	q:PhaLocId="" ""
	s pid=..NewPid()
	s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	s trTypeStr="P^Y"
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
	...s pointer=$p(intrData,"^",9)
	...s inclb=$p(intrData,"^",7)
	...s spAmt=$p(intrData,"^",8)
	...s qty=$p(intrData,"^",6)
	...s wardDesc="" // 病区或者医生科室
	...i trType="P" d
	....s wardId=$p($g(^DHCPHAC(+pointer)),"^",4)
	....i wardId="" d
	.....s wardLocId=$p($g(^DHCPHAC(+pointer,1)),"^",10)
	.....// 病区为空取医生科室
	.....//s oeori=$p($g(^DHCPHAC(+pointer,"I",+$p(pointer,"||",2))),"^",7)
	.....//s wardLocId=$p($g(^OEORD(+oeori,"I",+$p(oeori,"||",2),7)),"^",2)
	....e  s wardLocId=$p($g(^PAWARD(wardId)),"^",5)
	...e  i trType="Y" d
	....s wardLocId=$p($g(^PHARET(+pointer)),"^",6)
	...s wardLocDesc=$p($g(^CTLOC(+wardLocId)),"^",2)
	...i wardLocDesc="" s wardLocDesc="不详",wardLocId="99999"
	...d SetWardTotal
	...d SetWardDetail
	k GetDispRetDataData
	q pid
SetWardTotal
	s sortIndex="1"
	s totalAmt=0 // 输出时计算
	i '$d(^TMP("DHCST",$ClassName(),"GetDispRetData","WardStat",pid,sortIndex,wardLocId)) d
	.s data=""
	.i trType="P" d
	..s data=spAmt_"^"_0
	.e  i trType="Y" d
	..s data=0_"^"_spAmt
	.q:data=""
	.s data=data_"^"_wardLocDesc_"^"_totalAmt_"^"_wardLocId
	.s ^TMP("DHCST",$ClassName(),"GetDispRetData","WardStat",pid,sortIndex,wardLocId)=data
	e  d
	.i trType="P" d
	..s $p(^TMP("DHCST",$ClassName(),"GetDispRetData","WardStat",pid,sortIndex,wardLocId),"^",1)=spAmt+$p(^TMP("DHCST",$ClassName(),"GetDispRetData","WardStat",pid,sortIndex,wardLocId),"^",1)
	.e  i trType="Y" d
	..s $p(^TMP("DHCST",$ClassName(),"GetDispRetData","WardStat",pid,sortIndex,wardLocId),"^",2)=spAmt+$p(^TMP("DHCST",$ClassName(),"GetDispRetData","WardStat",pid,sortIndex,wardLocId),"^",2)
	q
SetWardDetail
	s pointTime=$p(intrData,"^",3)
	s GetDispRetDataData(+pointer)=pointTime
	s pointTime=GetDispRetDataData(+pointer)	// 一个单据,以一个时间为准
	s dtIndex=calcuDate_"^"_pointTime
	s pointerIndex=trType_"^"_+pointer
	s incId=+inclb
	i '$d(^TMP("DHCST",$ClassName(),"GetDispRetData","WardStatDetail",pid,wardLocId,dtIndex,pointerIndex,incId)) d
	.s data=spAmt_"^"_qty_"^"_calcuDate_"^"_pointTime_"^"_pointer_"^"_trType
	.s ^TMP("DHCST",$ClassName(),"GetDispRetData","WardStatDetail",pid,wardLocId,dtIndex,pointerIndex,incId)=data
	e  d
	.s $p(^TMP("DHCST",$ClassName(),"GetDispRetData","WardStatDetail",pid,wardLocId,dtIndex,pointerIndex,incId),"^",1)=spAmt+$p(^TMP("DHCST",$ClassName(),"GetDispRetData","WardStatDetail",pid,wardLocId,dtIndex,pointerIndex,incId),"^",1)
	.s $p(^TMP("DHCST",$ClassName(),"GetDispRetData","WardStatDetail",pid,wardLocId,dtIndex,pointerIndex,incId),"^",2)=qty+$p(^TMP("DHCST",$ClassName(),"GetDispRetData","WardStatDetail",pid,wardLocId,dtIndex,pointerIndex,incId),"^",2)
	q
}

/// description: 进程号
ClassMethod NewPid()
{
	q ##class(web.DHCSTKUTIL).NewPid($ClassName(),"IP")
}

}
