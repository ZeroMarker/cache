Import sqluser

/// creator:    yunhaibao
/// createdate: 2018-09-26
/// description:对应各界面的图标类,床位图,医生站的图标等
Class web.DHCSTInterfaceIcon Extends %RegisteredObject
{

/// description: 床位图-配液拒绝
/// 			 涉及床位图加载速度问题,仅判断昨日,今日,明日用药数据
/// return:		 1-床位图显示(被拒绝),0-不显示(未拒绝)
/// w ##class(web.DHCSTInterfaceIcon).PivasRefuseByAdm()
/// s img=##class(web.DHCSTInterfaceIcon).PivasRefuseByAdm($g(EpisodeID))
ClassMethod PivasRefuseByAdm(admId)
{
	s retFlag=0
	q:admId="" 0
	s stDate=+$h-1
	s edDate=+$h+1
	s ctLoc=""
	f  s ctLoc=$o(^PIVAS(0,"LOCTYPENUMBER",ctLoc)) q:ctLoc=""  d
	.s ctLocDesc=$p(^CTLOC(ctLoc),"^",2)
	.q:(ctLocDesc["停")||(ctLocDesc["废")
	.q:'$d(^PIVAS(0,"LOCTYPENUMBER",ctLoc,"I"))   //过滤掉 门诊静配的配置
	.s PivasLocData(ctLoc)=""
	q:'$d(PivasLocData) 0
	// 需判断已发,减库后可能会拒绝
	s dspStatusStr="C^TC"
	s dspStatusLen=$l(dspStatusStr,"^")
	s recLocId=""
	f  s recLocId=$o(PivasLocData(recLocId)) q:recLocId=""  d
 	.s calcuDate=""
 	.f calcuDate=stDate:1:edDate q:retFlag=1  d
 	..s dspI=""
 	..f dspI=1:1:dspStatusLen d
 	...s dspStatus=$p(dspStatusStr,"^",dspI)
 	...s dspId=""
 	...f  s dspId=$o(^DHCOEDISQTY(0,"ADM",recLocId,calcuDate,dspStatus,admId,dspId)) q:(dspId="")||(retFlag=1)  d
 	....q:+dspId=0
 	....s dspData=^DHCOEDISQTY(dspId)
 	....s pogId=$o(^PIVA(0,"DSP",dspId,""))
 	....q:pogId=""
 	....s oeore=$p(dspData,"^",3)
 	....s chkOeoreState=##class(web.DHCSTCOMMONSRV).GetOrdState(oeore)
 	....q:chkOeoreState'=1   // 过滤-执行记录停止
 	....i $p(^PIVA(pogId),"^",8)="R" s retFlag=1
 	q retFlag
}

}
