Import SQLUser

/// 打签前预统计药品数量
Class web.DHCSTPIVAPRESTAT Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 10;

ClassMethod PStatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PStatExecute ]
{
	S AtEnd=$LIST(qHandle,1)
 	S repid=$LIST(qHandle,2)
 	S ind=$LIST(qHandle,3)
 	S ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		S AtEnd=1
 		S Row=""
 	}
 	Else {
 		S Row=^CacheTemp(repid,ind)
 	}
 	S qHandle=$lb(AtEnd,repid,ind)
	Q $$$OK
}

ClassMethod PStatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PStatExecute ]
{
	S repid=$LIST(qHandle,2)
 	K ^CacheTemp(repid)
 	Q $$$OK
}

ClassMethod PStatExecute(ByRef qHandle As %Binary, tPLocID As %String, tWardID As %String, tStartDate As %String, tEndDate As %String, tBatNo As %String, tOecprID As %String) As %Status
{
	S repid=$I(^CacheTemp)
	S qHandle=$lb(0,repid,0)
	S ind=1
	Q:tPLocID="" $$$OK
	Q:tStartDate="" $$$OK
	Q:tEndDate="" $$$OK
	Q:tWardID="" $$$OK
	Q:$O(^PIVAA(0))="" $$$OK /// 没有维护医嘱类型
	S PID=""
	S PID=..CollWard(tPLocID, tWardID, tStartDate, tEndDate, tBatNo, tOecprID)
	Q:PID="" $$$OK
	S jj=""
	F  S jj=$O(^TMP("PIVA",PID,"PRESTAT",jj)) Q:jj=""  D
	.S Data=..GetData(PID,jj)
	.S ^CacheTemp(repid,ind)=Data	
 	.S ind=ind+1
 	//D ..ClearAllTmp(PID)
 	Q $$$OK
}

Query PStat(tPLocID As %String, tWardID As %String, tStartDate As %String, tEndDate As %String, tBatNo As %String, tOecprID As %String) As %Query(ROWSPEC = "tbPID:%String,tbItmDesc:%String,tbQty:%String,tbUom:%String")
{
}

ClassMethod CollWard(tPLocID As %String, tWardID As %String, tStartDate As %String, tEndDate As %String, tBatNo As %String, tOecprID As %String) As %Integer
{
	N (tPLocID, tWardID, tStartDate, tEndDate, tBatNo, tOecprID,%session)
	S PID=..NewPid()
	Q:tPLocID="" ""
	Q:tWardID="" ""
	Q:tStartDate="" ""
	Q:tEndDate="" ""
	Q:$O(^PIVAA(0))="" ""	/// 配液的医嘱子分类没有维护
	Q:$O(^PIVAO(0,"OECPR",tPLocID,""))="" ""	/// 科室配液的医嘱优先级没有维护
	Q:$O(^PIVABT(0,"TIME",tPLocID,""))="" ""	/// 科室配液的时间段分批没有维护
	D ..ClearAllTmp(PID)
	S cnumber=10  /// 10固定为打签状态
	S i=0,pno=0
	F date=tStartDate:1:tEndDate D
	.S WardLocDr=""
	.F  s WardLocDr=$O(^DHCOEDISQTY(0,"REC",tPLocID,date,"TC",WardLocDr)) q:WardLocDr=""  d
	..S WardDr=$o(^PAWARD(0,"WARD_LocationDR",WardLocDr,""))
	..Q:WardDr'=tWardID
	..S DspId=""
	..F  s DspId=$O(^DHCOEDISQTY(0,"REC",tPLocID,date,"TC",WardLocDr,0,DspId)) q:DspId=""  d
	...s OrdExeRowid=$p(^DHCOEDISQTY(DspId),"^",3) 
	...s oeori=$p(^DHCOEDISQTY(DspId),"^",1)  
	...s ord=$p(oeori,"||",1)
	...s chl=$p(oeori,"||",2)
	...S adm=$P(^OEORD(+oeori),"^",1)	/// 病人 PAADM_Rowid
	...Q:adm=""
	...Q:'$D(^PAADM(adm))
	...//S admward=$P(^PAADM(adm),"^",70) /// 病人所在病房
	...//Q:admward'=tWardID
	...Q:##Class(web.DHCSTPIVA).IfQuitAdmStatusD(adm)=1	//已经结算退出
	.../// 非执行医嘱
	...//Q:$O(^OEORD(ord,"I",chl,"X",0))=""
	...S moeori=##class(web.DHCSTPIVA).GetMainOeori(oeori)	/// 主医嘱
	.../// 医嘱状态
	...//S oestate=##class(web.DHCSTPIVA).GetOeState(oeori)
	...//S oestate=$P(oestate,"^",1)
 	...//Q:(oestate'="V")&(oestate'="E")
 	...s ChkOrdState=##class(web.DHCSTCOMMONSRV).GetOrdState(OrdExeRowid)
	...q:ChkOrdState'=1
 	.../// 配伍审核
 	...S chstr=##class(web.DHCSTPIVA).GetPassResult(moeori)
 	...Q:chstr=""	/// 未审核
	...Q:$p(chstr,",",4)="SHJJ" /// 配伍审核拒绝
	.../// 医嘱优先级
	...S pri=##class(web.DHCSTPIVA).GetOePriority(moeori)
	...S pridr=$P(pri,"^",1)
	...Q:pridr=""
	...Q:$O(^PIVAO(0,"OECPR",tPLocID,pridr,""))=""  	/// 没有维护科室配液的医嘱优先级
	...Q:(tOecprID'="")&(tOecprID'=pridr)				/// 与选择优先级不一致
	...S pricode=$P(pri,"^",2)
	...S pricode=$ZCVT(pricode,"U")
	.../// 取维护的“空”批次数量
	...S knum=##class(web.DHCSTPIVA).GetKBatNum()
	.../// 关联医嘱标志
	...S seqflag=##class(web.DHCSTPIVA).GetOISeqFlag(oeori)
	...//Q:(knum>0)&(seqflag=1)&(tBatNo["空") //yunhaibao20160518注释,没啥用
 	...//Q:(knum>0)&(seqflag=0)&(tBatNo'="")&(tBatNo'["空")
 	.../// 医嘱子分类
 	...S arccat=##class(web.DHCSTPIVA).GetArcItmCat(oeori)
 	...S arccatid=$P(arccat,"^",1)
 	...Q:arccatid=""
 	...Q:$O(^PIVAA(0,"ARCIC",arccatid,""))=""	/// 配液医嘱子分类没有维护
 	.../// 频率代码
 	...S freqstr=##class(web.DHCSTPIVA).GetFreq(oeori)
 	...S freq=$P(freqstr,"^",1)
 	...S freqcode=$P(freqstr,"^",2)
 	...S freqcode2=$ZCVT(freqcode,"U")
 	...Q:freq=""
 	...S incitm=##class(web.DHCSTPIVA).GetIncItm(oeori)
 	...S inci=$P(incitm,"^",1)
 	...S incidesc=$P(incitm,"^",3)
 	...Q:inci=""
 	...Q:'$D(^INCI(inci,1))
 	...S buom=$P(^INCI(inci,1),"^",10)
 	...Q:buom=""
 	...Q:'$D(^CT("UOM",buom))
 	...S buomdesc=$P(^CT("UOM",buom),"^",2)
 	.../// 
 	...S grpno=$p(^DHCOEDISQTY(DspId),"^",4)
 	...S moedisp=##class(web.DHCSTPIVA).GetMainOEDispID(DspId,grpno)
 	...S sttdate2=$zd(date,3) /// 执行日期
 	...S seqno=$P(^OEORD(ord,"I",chl,3),"^",4)		/// 关联医嘱号
 	...S nextnumber=cnumber
 	...S specstate=""
 	...S pogi=##class(web.DHCSTPIVA).GetOGrpI(moedisp)
 	...I pogi'="" D
 	....S psdr=$P(^PIVA(+pogi),"^",6)
 	....//S nextstr=##class(web.DHCSTPIVA).GetNextStat(psdr)	zhouyg 20151104
 	....S nextstr=##class(web.DHCSTPIVA).GetNextStat(psdr,tPLocID,"I")	 ///下一个状态
 	....S nextnumber=$P(nextstr,"^",2)
 	....S specstate=$P(^PIVA(+pogi),"^",8)
 	...Q:nextnumber'=cnumber
 	...Q:(specstate="C")!(specstate="R")
    ...S stttime=$p(^DHCOEDISQTY(moedisp),"^",20)	/// 执行时间
 	...S batno=##class(web.DHCSTPIVA).GetUpBatNo(moedisp,grpno)	/// 修改过的批次，如没有修改过再正常取
 	...S:batno="" batno=##class(web.DHCSTPIVA).GetBatNo(tPLocID,stttime,seqflag,WardDr)
 	...Q:batno=""
 	...Q:(tBatNo'="")&(tBatNo'=batno)
 	...S dspqty=$p(^DHCOEDISQTY(DspId),"^",11)
 	...S i=i+1
 	...I '$D(^TMP("PIVA",PID,"PRESTAT",inci)) D
 	....S ^TMP("PIVA",PID,"PRESTAT",inci)=incidesc_"^"_buomdesc_"^"_dspqty
 	...E  D
 	....S $P(^TMP("PIVA",PID,"PRESTAT",inci),"^",3)=$P(^TMP("PIVA",PID,"PRESTAT",inci),"^",3)+dspqty
	Q:i>0 PID
	Q ""
}

ClassMethod GetData(pid As %String, inci As %String) As %String
{
	N (pid,inci)
	S str=^TMP("PIVA",pid,"PRESTAT",inci)
	S itmdesc=$P(str,"^",1)
	s uomdesc=$P(str,"^",2)
	s qty=$P(str,"^",3)
 	S data=$LB(pid,itmdesc,qty,uomdesc)
 	Q data
}

ClassMethod NewPid() As %String
{
 	Q $I(^DHCSTPIVA("COLL"))
}

ClassMethod ClearAllTmp(pid As %String) As %String
{
	D ..CLEARTMP(pid,"PRESTAT")
}

ClassMethod CLEARTMP(pid As %String, PAR As %String) As %String
{
	K ^TMP("PIVA",pid,PAR)
}

}
