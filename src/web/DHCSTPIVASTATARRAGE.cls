Import SQLUser

/// 排药统计
Class web.DHCSTPIVASTATARRAGE Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
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

ClassMethod DispExecute(ByRef qHandle As %Binary, tPLocID As %String, tWardID As %String, tStartDate As %String, tEndDate As %String, tBatNo As %String, tOecprID As %String, tPrintNo As %String, tPassAudit As %String, tOrdStDate As %String, tOrdEndDate As %String, tStartTime As %String, tEndTime As %String, tOecType As %String, tColFlag, tPrintFlag) As %Status
{
	S repid=$I(^CacheTemp)
	S qHandle=$lb(0,repid,0)
	S ind=1
	Q:tPLocID="" $$$OK
	Q:tStartDate="" $$$OK
	Q:tEndDate="" $$$OK
	i tStartTime="" s tStartTime=0
	i tEndTime="" s tEndTime=86399
	S PID=""
	S PID=..CollData(tPLocID, tWardID, tStartDate, tEndDate, tBatNo, tOecprID,tPrintNo,tPassAudit,tOrdStDate,tOrdEndDate,tStartTime,tEndTime,tOecType,tColFlag,tPrintFlag)
	Q:PID="" $$$OK
	S jj=""
	F  S jj=$O(^TMP("PIVA",PID,"ARR",jj)) Q:jj=""  D
	.S Data=..GetData(PID,jj)
	.S ^CacheTemp(repid,ind)=Data	
 	.S ind=ind+1
 	D ..ClearAllTmp(PID)
 	Q $$$OK
}

Query Disp(tPLocID As %String, tWardID As %String, tStartDate As %String, tEndDate As %String, tBatNo As %String, tOecprID As %String, tPrintNo As %String, tPassAudit As %String, tOrdStDate As %String, tOrdEndDate As %String, tStartTime As %String, tEndTime As %String, tOecType As %String, tColFlag, tPrintFlag) As %Query(ROWSPEC = "tbPID:%String,tbItmDesc:%String,tbUom:%String,tbQty:%String,tbStkbin:%String")
{
}

ClassMethod CollData(tPLocID As %String, tWardID As %String, tStartDate As %String, tEndDate As %String, tBatNo As %String, tOecprID As %String, tPrintNo As %String, tPassAudit As %String, tOrdStDate As %String, tOrdEndDate As %String, tStartTime As %String, tEndTime As %String, tOecType As %String, tColFlag, tPrintFlag) As %Integer
{
	N (tPLocID, tWardID,tStartDate, tEndDate, tBatNo, tOecprID,tPrintNo,tPassAudit,tOrdStDate,tOrdEndDate,tStartTime,tEndTime,tOecType,tColFlag,tPrintFlag)
	Q:tPLocID="" ""
	Q:tStartDate="" ""
	Q:tEndDate="" ""
	S PID=..NewPid()
	D ..ClearAllTmp(PID)
	S i=0,cnumber=10 /// 当前统计的状态10-打签
	S pynumber="30"
	s type="I"
	S dispconfig=##class(web.DHCSTPIVA).GetPSNumberProByLoc(tPLocID,cnumber)  //打签流程减库标识
	S pyuseflag=##class(web.DHCSTPIVA).GetStatesUseFlag(tPLocID,pynumber) // 排药流程使用标识
	S LastMainOrd=""
	F date=tStartDate:1:tEndDate D
	.S pha=""
	.F  S pha=$O(^DHCPHAC(0,"PHP",tPLocID,"DATE",date,pha)) Q:pha=""  D
	..Q:($D(^DHCPHAC(pha))=0)!($D(^DHCPHAC(pha))=10)
	../// 病区
	..S ward=$P(^DHCPHAC(pha),"^",4)
	..Q:##class(web.DHCSTPIVA).CheckWard(tWardID,ward)=0
	../// 打印单号
	..S printno=$P(^DHCPHAC(pha),"^",14)
	..Q:(tPrintNo'="")&(tPrintNo'=printno)
	..//打印时间
	..S printtime=$P(^DHCPHAC(pha),"^",8)
	..Q:(tStartTime'="")&(printtime<tStartTime)&(date=tStartDate)
	..Q:(tEndTime'="")&(printtime>tEndTime)&(date=tEndDate)
	..S pog=""
	..F  S pog=$O(^PIVA(0,"PHAC",pha,pog)) Q:pog=""  D
	...S pdata=^PIVA(pog)
	.../// 医嘱日期
	...S orddate=$P(pdata,"^",4)
	...Q:(tOrdStDate'="")&(orddate<tOrdStDate)
	...Q:(tOrdEndDate'="")&(orddate>tOrdEndDate)
	.../// 批次
	...S batno=$P(pdata,"^",3)
	...Q:(tBatNo'="")&(tBatNo'=batno)
	...///
	...S moedisp=$P(pdata,"^",1)
	...S moeori=$P(^DHCOEDISQTY(moedisp),"^",3) /// 主医嘱ID
	...S mord=$P(moeori,"||",1)
	...S adm=$P(^OEORD(mord),"^",1)	/// 病人 PAADM_Rowid
	...Q:adm=""
	...Q:'$D(^PAADM(adm))
	...
	...S admstatuse=##Class(web.DHCSTPIVA).IfQuitAdmStatusD(adm) //已经结算退出
	...Q:(admstatuse=1)&(tColFlag'="on")&(tPrintFlag'="on")
	...
	...//Q:##Class(web.DHCSTPIVA).IfQuitAdmStatusD(adm)=1	//已经结算退出
	.../// 优先级
	...S pri=##class(web.DHCSTPIVA).GetOePriority(moeori)
	...S pridr=$P(pri,"^",1)
	...Q:(tOecprID'="")&(tOecprID'=pridr)
	.../// S pridesc=$P(pri,"^",3)
 	.../// pass审核
 	...S chstr=##class(web.DHCSTPIVA).GetPassResult(moeori)
	...S passre=$p(chstr,",",4) /// 配伍审核结果
 	...Q:(tPassAudit'="")&(tPassAudit'=passre)
 	.../// 停止签是否打印
 	...
 	...S pcp=$P(pdata,"^",15)
 	.../// 医嘱状态
	...//S oestate=##class(web.DHCSTPIVA).GetOeState(moeori)
	...//S oestcode=$P(oestate,"^",1)
	...//Q:(oestcode="D")&(pcp'="")&(tColFlag'="on")
	...S OrdExeRowid=$p(^DHCOEDISQTY(moedisp),"^",3) 
	...S ChkOrdState=##class(web.DHCSTCOMMONSRV).GetOrdState(OrdExeRowid)
	...Q:(ChkOrdState'=1)&(pcp'="")&(tColFlag'="on")  //已发药则忽略过滤
 	.../// 配药状态
 	...S psnumber=##class(web.DHCSTPIVA).GetPSNumber(pog)
 	...Q:(psnumber<cnumber)	
 	.../// 配液分类
 	...i LastMainOrd'=moeori d
	....s ptypestr=##class(web.DHCSTPIVA).GetAuditedType(moeori)
	....s typeID=$p(ptypestr,"^",1)
	...Q:(tOecType'="")&(tOecType'=$g(typeID))
 	...S LastMainOrd=moeori
 	.../// 明细
	...S pogsub=""
	...F  S pogsub=$O(^PIVA(pog,"I",pogsub)) Q:pogsub=""  D
	....S dodis=$P(^PIVA(pog,"I",pogsub),"^",1)
	....Q:dodis=""
	....Q:'$D(^DHCOEDISQTY(dodis))
 	....S dspstatus=$p(^DHCOEDISQTY(dodis),"^",7)
 	....//模式一,打签不发药,过滤已经确认,已发药则忽略过滤
 	....Q:(dspstatus'="TC")&(tColFlag'="on")&(dispconfig'="Y")&(tPrintFlag'="on")  //过滤非待发药
 	....Q:(dspstatus'="C")&(tColFlag="on")&(dispconfig'="Y")  //过滤非已发药 
 	....//模式二,打签发药	  
 	....Q:(dspstatus'="C")&(dispconfig="Y") //过滤非已发药
 	....//如果排药状态打勾,则需考虑状态
 	....S psdr=$P(^PIVA(pog),"^",6)
 	....S nextstr=##class(web.DHCSTPIVA).GetNextStat(psdr,tPLocID,type)  // 增加科室和类型
 	....S nextnumber=$P(nextstr,"^",2)
 	....Q:(pyuseflag="Y")&(nextnumber'=pynumber)&(tColFlag'="on")&(tPrintFlag'="on")
 	....
 	....S oeori=$p(^DHCOEDISQTY(dodis),"^",1)
 	....S pri=##class(web.DHCSTPIVA).GetOePriority(oeori)
	....S pricode=$P(pri,"^",2)
	....S pricode=$ZCVT(pricode,"U")
	....Q:##class(web.DHCSTCOMMONSRV).ChkOrdPriority(oeori)=0
 	....S ord=$P(oeori,"||",1)
 	....S chl=$P(oeori,"||",2)
 	....S incitm=##class(web.DHCSTPIVA).GetIncItm(oeori)
 	....S inci=$P(incitm,"^",1)
 	....S itmdesc=$P(incitm,"^",3)
 	....S qty=$P(^DHCOEDISQTY(dodis),"^",11)
 	....S uomdr=$P(^DHCOEDISQTY(dodis),"^",6)
 	....S uomdesc="*"
 	....S:$D(^CT("UOM",uomdr)) uomdesc=$P(^CT("UOM",uomdr),"^",2)
 	....S ^TMP("PIVA",PID,"ARRPOG",pog)=""
 	....S spec=##class(web.DHCSTCOMINC).GetSpec(inci)		/// 规格
 	....S stkbin=##class(web.DHCSTPIVA).GetStkBin(tPLocID,inci)
 	....///
 	....S i=i+1
 	....S jj=inci_"^"_itmdesc_"^"_uomdesc_"^"_stkbin
 	....S ^TMP("PIVA",PID,"ARR",jj)=$G(^TMP("PIVA",PID,"ARR",jj))+qty
 	...

	Q:i>0 PID
	Q ""
}

ClassMethod GetData(pid As %String, jj As %String) As %String
{
	N (pid,jj)
	S itmdesc=$P(jj,"^",2)
	S uomdesc=$P(jj,"^",3)
	S stkbin=$P(jj,"^",4)
	S qty=^TMP("PIVA",pid,"ARR",jj)
 	S data=$LB(pid,itmdesc,uomdesc,qty,stkbin)
 	Q data
}

ClassMethod NewPid() As %String
{
 	Q $I(^DHCSTPIVA("COLL"))
}

ClassMethod ClearAllTmp(pid As %String) As %String
{
	D ..CLEARTMP(pid,"ARR")
}

ClassMethod CLEARTMP(pid As %String, PAR As %String) As %String
{
	K ^TMP("PIVA",pid,PAR)
}

/// 得到构造的pog
ClassMethod GetArrData(pid As %String, pog As %String) As %String
{
	
	S pog=$o(^TMP("PIVA",pid,"ARRPOG",pog))
	Q pog
}

/// 准备打印数据
ClassMethod GetPrtArrData(PID As %String, pogstr As %String) As %String
{
	N (PID,pogstr)
	S cnt=$l(pogstr,"^")
	s h=0
	F i=1:1:cnt d
    .S pog=$p(pogstr,"^",i)
	.S pogsub=""
	.F  S pogsub=$O(^PIVA(pog,"I",pogsub)) Q:pogsub=""  D
	..S dodis=$P(^PIVA(pog,"I",pogsub),"^",1)
	..Q:dodis=""
	..Q:'$D(^DHCOEDISQTY(dodis))
 	..S dspstatus=$p(^DHCOEDISQTY(dodis),"^",7)
 	..//Q:dspstatus="TC"
 	..S oeori=$p(^DHCOEDISQTY(dodis),"^",1)
 	..S pri=##class(web.DHCSTPIVA).GetOePriority(oeori)
	..S pricode=$P(pri,"^",2)
	..S pricode=$ZCVT(pricode,"U")
	..Q:(pricode="OM")!(pricode="OMST")
 	..S ord=$P(oeori,"||",1)
 	..S chl=$P(oeori,"||",2)
 	..S incitm=##class(web.DHCSTPIVA).GetIncItm(oeori)
 	..S inci=$P(incitm,"^",1)
 	..S itmdesc=$P(incitm,"^",3)
 	..S qty=$P(^DHCOEDISQTY(dodis),"^",11)
 	..S uomdr=$P(^DHCOEDISQTY(dodis),"^",6)
 	..S uomdesc="*"
 	..S ploc=$p(^OEORD(ord,"I",chl,3),"^",6)
 	..S:$D(^CT("UOM",uomdr)) uomdesc=$P(^CT("UOM",uomdr),"^",2)
 	..S spec=##class(web.DHCSTCOMINC).GetSpec(inci)		/// 规格
 	..S stkbin=##class(web.DHCSTPIVA).GetStkBin(ploc,inci) ///货位
 	..///
 	..S h=h+1
 	..S jj=stkbin_"^"_inci_"^"_itmdesc_"^"_uomdesc
 	..S ^TMP("PIVA",PID,"PRTARR",jj)=$G(^TMP("PIVA",PID,"PRTARR",jj))+qty
 	..
 	S n=0
 	S ii=""
 	F  S ii=$o(^TMP("PIVA",PID,"PRTARR",ii)) q:ii=""  D
 	.S info=^TMP("PIVA",PID,"PRTARR",ii)
 	.S n=n+1
 	.S ^TMP("PIVA",PID,"PRTARRITM",n)=ii_"^"_info
 	k ^TMP("PIVA",PID,"PRTARR")
 	Q n
}

/// 得到构造的打印数据
ClassMethod ListPrtArrData(pid As %String, i As %String) As %String
{
	N (pid,i)
	S info=^TMP("PIVA",pid,"PRTARRITM",i)
	K ^TMP("PIVA",pid,"PRTARRITM",i)
	Q info
}

}
