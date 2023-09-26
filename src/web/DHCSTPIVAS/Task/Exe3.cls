/// creator:	 yunhaibao
/// createdate:  2019-01-10
/// description: 排批任务,所有未排参照昨日,用药
Class web.DHCSTPIVAS.Task.Exe3 Extends %RegisteredObject
{

/// w ##class(web.DHCSTPIVAS.Task.Exe3).Run()
ClassMethod Run()
{
	s userId=1
	s pid=..NewPid()
	s $zt="ThrowRun"
	s startDate=+$h
	s endDate=+$h+2
	s pivaLocId=""
	f  s pivaLocId=$o(^PIVAS(0,"LOCNUMBER",pivaLocId)) q:pivaLocId=""  d
	.q:'$d(^CTLOC(pivaLocId))
	.s auditTimes=##class(web.DHCSTPIVAS.Settings).GetAppParamProp("",pivaLocId,"OeAudit","AuditTimes")
	.s calcuDate=""
	.f calcuDate=startDate:1:endDate d
	..s wardLocId=""
	..f  s wardLocId=$O(^DHCOEDISQTY(0,"REC",pivaLocId,calcuDate,"TC",wardLocId)) q:wardLocId=""  d
	...q:+wardLocId=0
	...s dspId=""
	...f  s dspId=$O(^DHCOEDISQTY(0,"REC",pivaLocId,calcuDate,"TC",wardLocId,0,dspId)) q:dspId=""  d
	....q:+dspId=0
	....q:$d(^PIVA(0,"DSP",dspId))
	....s admId=$p(^DHCOEDISQTY(dspId),"^",26)
    ....s admType=$p($g(^PAADM(admId)),"^",2)
    ....// 过滤-住院
    ....q:admType'="I"  
    ....s grpNo=$p(^DHCOEDISQTY(dspId),"^",4)
	....s mDsp=##class(web.DHCSTPIVAS.Common).GetMainDspId(dspId,grpNo)
	....q:mDsp=""
	....q:$d(^TMPPIVAS("web.DHCSTPIVAS.Task.Exe3","Run",pid,mDsp))
	....s mOeori=$P(^DHCOEDISQTY(mDsp),"^",1)
	....s mOeore=$P(^DHCOEDISQTY(mDsp),"^",3)
    ....s freqId=$p(##class(web.DHCSTCOMMONORDER).OeoriFreq(mOeori),"^",1)
    ....q:freqId=""
    ....// 过滤-不需参照昨日
    ....q:$d(^PIVAFREQR(0,"Freq",pivaLocId,freqId))
	....s passStat=$p(##class(web.DHCSTPIVAS.Common).GetOrdPassState(mOeori,calcuDate,auditTimes,pivaLocId),"^",1)
	....// 过滤-配伍拒绝
	....q:(passStat="SHJJ")||(passStat="")
	....s ordPriStr=##Class(web.DHCSTPIVAS.Common).OrdPriority(mOeori)	
	....// 过滤-全自备 
	....q:ordPriStr["OM"
	....s lastBatNo=##class(web.DHCSTPIVAS.BatUpdate).BeforeBatch(mDsp)
	....// 过滤-上次无批次
	....q:lastBatNo="" 
	....s ^TMPPIVAS("web.DHCSTPIVAS.Task.Exe3","Run",pid,mDsp)=lastBatNo
	s succNo=0
	s mDsp=""
	f  s mDsp=$o(^TMPPIVAS("web.DHCSTPIVAS.Task.Exe3","Run",pid,mDsp)) q:mDsp=""  d
	.s errInfo=""
	.q:$d(^PIVA(0,"DSP",mDsp))
	.s grpNo=$p(^DHCOEDISQTY(mDsp),"^",4)
	.s batNo=^TMPPIVAS("web.DHCSTPIVAS.Task.Exe3","Run",pid,mDsp)
	.s lockRet=##class(web.DHCSTPIVAS.Common).Lock("DHCOEDispensing",mDsp)
	.q:lockRet'=0 
	.ts
 	.s insRet=##class(web.DHCSTPIVAS.BatUpdate).InsertPIVABatUp(mDsp, grpNo,batNo, userId, "Y")
 	.i +insRet'=0 d
 	..s errInfo=insRet
 	..d UnLockRun
 	..tro
	.q:errInfo'=""
	.s insRet=##class(web.DHCSTPIVAS.BatUpdate).SavePIVAOrdGrp(mDsp, batNo, userId)
 	.i +insRet'=0 d
 	..s errInfo=insRet
 	..d UnLockRun
 	..tro
	.q:errInfo'=""
	.tc
	.s succNo=succNo+1
	k ^TMPPIVAS("web.DHCSTPIVAS.Task.Exe3","Run",pid)
	q succNo
UnLockRun
	d ##class(web.DHCSTPIVAS.Common).UnLock("DHCOEDispensing",mDsp)
	q
ThrowRun
	i $d(mDsp) d UnLockRun
	i $d(pid) k ^TMPPIVAS("web.DHCSTPIVAS.Task.Exe3","Run",pid)
	s errMsgInfo="##class(web.DHCSTPIVAS.Task.Exe3).Run"
	d ErrorRecord^DHCSTERROR("DHCSTINPIVA",errMsgInfo,$ze)
	q "-2^"_$ze
}

ClassMethod NewPid()
{
	q ##class(web.DHCSTKUTIL).NewPid($ClassName(),"PIVA")
}

}
