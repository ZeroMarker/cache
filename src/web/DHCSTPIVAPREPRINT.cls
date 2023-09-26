Import SQLUser

/// 检索未打印
Class web.DHCSTPIVAPREPRINT Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod DispFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DispExecute ]
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

ClassMethod DispClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DispExecute ]
{
	S repid=$LIST(qHandle,2)
 	K ^CacheTemp(repid)
 	Q $$$OK
}

ClassMethod DispExecute(ByRef qHandle As %Binary, tPLocID As %String, tStartDate As %String, tEndDate As %String, tBatNo As %String, tOecprID As %String, tWardID As %String, TypeList) As %Status
{
	S repid=$I(^CacheTemp)
	S qHandle=$lb(0,repid,0)
	S ind=1
	Q:tPLocID="" $$$OK
	Q:tStartDate="" $$$OK
	Q:tEndDate="" $$$OK
    
	S PID=""
	S PID=..CollWard(tPLocID, tStartDate, tEndDate, tBatNo, tOecprID,tWardID,TypeList)
	Q:PID="" $$$OK
	S jj=""
	F  S jj=$O(^TMP("PIVA",PID,"PREP",jj)) Q:jj=""  D
	.S ii=""
	.F  S ii=$O(^TMP("PIVA",PID,"PREP",jj,ii)) Q:ii=""  D
	..S Data=..GetData(PID,jj,ii)
	..S ^CacheTemp(repid,ind)=Data	
 	..S ind=ind+1
 	D ..ClearAllTmp(PID)
 
 	Q $$$OK
}

Query Disp(tPLocID As %String, tStartDate As %String, tEndDate As %String, tBatNo As %String, tOecprID As %String, tWardID As %String, TypeList) As %Query(ROWSPEC = "tbPID:%String,tbWard:%String,tbBatNo:%String,tbPacks:%String,tbWardID:%String")
{
}

//d ##class(web.DHCSTPIVAPREPRINT).CollWard("101","62223","62224","","","","")

ClassMethod CollWard(tPLocID As %String, tStartDate As %String, tEndDate As %String, tBatNo As %String, tOecpr As %String, tWardID As %String, TypeList) As %Integer
{
	N (tPLocID,tStartDate, tEndDate, tBatNo, tOecpr,tWardID,TypeList)	
	S PID=..NewPid()
	Q:tPLocID="" ""
	Q:tStartDate="" ""
	Q:tEndDate="" ""
	D ..ClearAllTmp(PID)
	S cnumber=10  /// 10固定为打签状态
	s pstype="I"
	S pno=0
	S LastMainOrd=""
	F date=tStartDate:1:tEndDate D
	.S WardLocDr=""
	.F  S WardLocDr=$O(^DHCOEDISQTY(0,"REC",tPLocID,date,"TC",WardLocDr)) q:WardLocDr=""  d
	..S flag=0
    ..S DspId=""
    ..F  s DspId=$O(^DHCOEDISQTY(0,"REC",tPLocID,date,"TC",WardLocDr,0,DspId)) q:(DspId="")||(flag=1)  d
    ...S grpno=$p(^DHCOEDISQTY(DspId),"^",4)
    ...S mdodis=##class(web.DHCSTPIVA).GetMainOEDispID(DspId,grpno)
    ...S WardDr=$o(^PAWARD(0,"WARD_LocationDR",WardLocDr,""))
    ...s OEOrdItem=$p(^DHCOEDISQTY(DspId),"^",1)     ;OE_OrdItem表指针
    ...s OrdExeRowid=$p(^DHCOEDISQTY(DspId),"^",3)     ;OE_OrdExec表指针
	...s AdmDr=$p(^DHCOEDISQTY(DspId),"^",26)
	...S AdmType=$p($g(^PAADM(AdmDr)),"^",2)
	...Q:(AdmType'="I")						//非住院病人退出
	...s oeori=$p(^DHCOEDISQTY(DspId),"^",1)     ;OE_OrdItem表指针
    ...s OrdExeRowid=$p(^DHCOEDISQTY(DspId),"^",3)     ;OE_OrdExec表指针
	...Q:AdmDr=""
	...Q:'$D(^PAADM(AdmDr))
	...S WardDesc=$P(^PAWARD(WardDr),"^",2) /// 病人所在病房
	...Q:##class(web.DHCSTPIVA).CheckWard(tWardID,WardDr)=0
	...Q:##Class(web.DHCSTPIVA).IfQuitAdmStatusD(AdmDr)=1	//已经结算退出
	...S oeori=OEOrdItem
	...S moeori=##class(web.DHCSTPIVA).GetMainOeori(oeori)	/// 主医嘱
	.../// 医嘱状态
	...//S oestate=##class(web.DHCSTPIVA).GetOeState(oeori)
	...//S oestate=$P(oestate,"^",1)
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
	...Q:(tOecpr'="")&(tOecpr'=pridr)				/// 与选择优先级不一致
	...S pricode=$P(pri,"^",2)
	...S pricode=$ZCVT(pricode,"U")
	...///护士审核
	...S Audited=##class(web.DHCSTCOMMONSRV).IfAuditByPriority(DspId)
	...Q:Audited=0 /// 护士未审核
	.../// 皮试
	.../// Q:##class(web.DHCSTPIVA).SkinTest(oeori)<0
	.../// 取维护的“空”批次数量
	...S knum=##class(web.DHCSTPIVA).GetKBatNum()
	.../// 关联医嘱标志
	...S seqflag=##class(web.DHCSTPIVA).GetOISeqFlag(oeori)
	...//Q:(knum>0)&(seqflag=1)&(tBatNo["空")  //注释,不用,20160119,yunhaibao
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
 	.../// 
 	...S sttdate=date	/// 执行日期
 	...S sttdate2=$zd(sttdate,3)
 	...///配液分类
 	...i LastMainOrd'=moeori d
	....s ptypestr=##class(web.DHCSTPIVA).GetAuditedType(moeori)
	....s typeID=$p(ptypestr,"^",1)
 	...///
 	...Q:##class(web.DHCSTPIVA).CheckLimitType(TypeList,typeID)=0
 	...S nextnumber=cnumber
 	...S specstate=""
 	...S pogi=##class(web.DHCSTPIVA).GetOGrpI(DspId)
 	...I pogi'="" D
 	....S psdr=$P(^PIVA(+pogi),"^",6)
 	....S nextstr=##class(web.DHCSTPIVA).GetNextStat(psdr,tPLocID,pstype)	 ///下一个状态
 	....S nextnumber=$P(nextstr,"^",2)
 	....S specstate=$P(^PIVA(+pogi),"^",8)
 	...Q:nextnumber'=cnumber
 	...Q:(specstate="C")!(specstate="R")
 	...S grpno=$p(^DHCOEDISQTY(DspId),"^",4)
 	...S stttime=$p(^DHCOEDISQTY(DspId),"^",20)
 	...S mdodis=##class(web.DHCSTPIVA).GetMainOEDispID(DspId,grpno)
 	...I mdodis'="" D
 	....I $D(^DHCOEDISQTY(mdodis)) S stttime=$p(^DHCOEDISQTY(mdodis),"^",20)	/// 执行时间
 	...S batno=##class(web.DHCSTPIVA).GetUpBatNo(mdodis,grpno)	/// 修改过的批次，如没有修改过再正常取
 	...S:batno="" batno=##class(web.DHCSTPIVA).GetBatNo(tPLocID,stttime,seqflag,WardDr)
 	...S:batno="" batno=1
 	...Q:batno=""
 	...Q:(tBatNo'="")&(tBatNo'=batno)
 	...S remark=##class(web.DHCSTPIVA).GetOrdItmRemark(oeori)
 	...S LastMainOrd=moeori
 	...//S flag=1 //注释否则袋数不准
 	...I '$D(^TMP("PIVA",PID,"PREPNO",mdodis,grpno)) D
 	....S pno=pno+1
 	....S ^TMP("PIVA",PID,"PREPNO",mdodis,grpno)=pno
 	....S tmpbatno=1
 	....s batno=1 //yunhaiboa20160121,病区合并批次显示
 	....S ^TMP("PIVA",PID,"PREP",WardDr_"||"_WardDesc,batno)=$G(^TMP("PIVA",PID,"PREP",WardDr_"||"_WardDesc,batno))+1
	Q:pno>0 PID
	Q ""
}

ClassMethod GetData(pid As %String, jj As %String, ii As %String) As %String
{
	N (pid,jj,ii)
	S packs=^TMP("PIVA",pid,"PREP",jj,ii)
	S wardid=$P(jj,"||",1)
	S warddesc=$P(jj,"||",2)
 	S data=$LB(pid,warddesc,ii,packs,wardid)
 	Q data
}

ClassMethod NewPid() As %String
{
 	Q $I(^DHCSTPIVA("COLL"))
}

ClassMethod ClearAllTmp(pid As %String) As %String
{
	D ..CLEARTMP(pid,"PREPNO")
	D ..CLEARTMP(pid,"PREP")
}

ClassMethod CLEARTMP(pid As %String, PAR As %String) As %String
{
	K ^TMP("PIVA",pid,PAR)
}

}
