Import SQLUser

/// 查询
Class web.DHCSTPIVAQUERY Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
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

ClassMethod DispExecute(ByRef qHandle As %Binary, tStartDate As %String, tEndDate As %String, tRegNo As %String, tItmID As %String, tPassAudit As %String, tState As %String, tSpecStat As %String, tDlabPrint As %String, tOrdStDate As %String, tOrdEndDate As %String, tCPStr As %String) As %Status
{
	S repid=$I(^CacheTemp)
	S qHandle=$lb(0,repid,0)
	S ind=1
	Q:tStartDate="" $$$OK
	Q:tEndDate="" $$$OK
	S PID=""
	S PID=..CollData( tRegNo, tStartDate, tEndDate,  tItmID,tPassAudit,tState, tSpecStat,tDlabPrint,tOrdStDate,tOrdEndDate,tCPStr)
	Q:PID="" $$$OK
	S jj=""
	s lipno=""
	s patcolor="W"
	F  S jj=$O(^TMP("PIVA",PID,"Q","ADM",jj)) Q:jj=""  D
	.S ii=""
	.F  S ii=$O(^TMP("PIVA",PID,"Q","ADM",jj,ii)) Q:ii=""  D
	..S Data=..GetData(PID,jj,ii,lipno,patcolor)
	..S lipno=^TMP("PIVA",PID,"Q","IPNO",jj,ii)
	..s patcolor=^TMP("PIVA",PID,"Q","COLOR",jj,ii)
	..S ^CacheTemp(repid,ind)=Data	
 	..S ind=ind+1
 	Q $$$OK
}

Query Disp(tStartDate As %String, tEndDate As %String, tRegNo As %String, tItmID As %String, tPassAudit As %String, tState As %String, tSpecStat As %String, tDlabPrint As %String, tOrdStDate As %String, tOrdEndDate As %String, tCPStr As %String) As %Query(ROWSPEC = "tbPID:%String,tbBatNo:%String,tbSeqNo:%String,tbItmDesc:%String,tbRegNo:%String,tbBedNo:%String,tbName:%String,tbFreq:%String,tbQty:%String,tbPrice:%String,tbOeStatus:%String,tbDosage:%String,tbSpec:%String,tbInst:%String,tbDura:%String,tbPresc:%String,tbOecpr:%String,tbDoctor:%String,tbOexeDate:%String,tbOexeTime:%String,tbCompare:%String,tbSign:%String,tbDSP:%String,tbGrpNo:%String,tbPrintNum:%String,tbMOeori:%String,tbUom:%String,tbPassResult:%String,tbPrintNo:%String,tbWard:%String,tbPUser:%String,tbPDate:%String,tbPogID:%String,tbState:%String,tbSpecStat:%String,tbCPrintNo:%String,tbCPrintNum:%String,tbOrdDate:%String,tbCprintDateTime:%String,tbCDateTime:%String,tbCUser:%String,tbCReason:%String,tbOrdXDate:%String,tbCnumber:%String,tbVisitStatus:%String,tbBarCode:%String,tbOestateCode:%String,tbColorType:%String,tbNurAudit:%String,TEncryptLevel:%String,TPatLevel:%String,TExeLabel:%String")
{
}

ClassMethod CollData(tRegNo As %String, tStartDate As %String, tEndDate As %String, tItmID As %String, tPassAudit As %String, tState As %String, tSpecStat As %String, tDlabPrint As %String, tOrdStDate As %String, tOrdEndDate As %String, tCPStr As %String) As %Integer
{
	N (tRegNo, tStartDate, tEndDate, tItmID,tPassAudit,tState,tSpecStat,tDlabPrint,tOrdStDate,tOrdEndDate,tCPStr)
	S tPLocID=$P(tCPStr,"^",11)	
	Q:tPLocID="" ""
	Q:tStartDate="" ""
	Q:tEndDate="" ""
	S PID=..NewPid()
	D ..ClearAllTmp(PID)
	S i=0,pno=0
	//
	S tStartDateTime=$P(tCPStr,"^",5)
	S tEndDateTime=$P(tCPStr,"^",6)
	i tStartDateTime'="" S tStartDateTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(tStartDateTime)
	i tEndDateTime'="" S tEndDateTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(tEndDateTime)
	S tOecType=$P(tCPStr,"^",7)
	S tPrintNo=$P(tCPStr,"^",8)
	S tPrintNoStr =$P(tCPStr,"^",9)
	S tWardID =$P(tCPStr,"^",10)
	S tOecprID=$P(tCPStr,"^",12)
	S tBatNo=$P(tCPStr,"^",13)
	s tplogflag=$P(tCPStr,"^",14)
	s HospID=$p($g(^CTLOC(tPLocID)),"^",22)
	//
	s LastMainOrd=""
	s Lastpog=""
	F date=tStartDate:1:tEndDate D
	.S pha=""
	.F  S pha=$O(^DHCPHAC(0,"PHP",tPLocID,"DATE",date,pha)) Q:pha=""  D
	..Q:($D(^DHCPHAC(pha))=0)!($D(^DHCPHAC(pha))=10)
	../// 病区
	..S ward=$P(^DHCPHAC(pha),"^",4)
	..;Q:(tWardID'="")&(tWardID'=ward)
	..Q:##class(web.DHCSTPIVA).CheckWard(tWardID,ward)=0
	..S ward=$P(^PAWARD(ward),"^",2)
	../// 打印单号
	..S printno=$P(^DHCPHAC(pha),"^",14)
	..Q:(tPrintNo'="")&(tPrintNo'=printno)
	..S printdate=$P(^DHCPHAC(pha),"^",7)
	..S printtime=$P(^DHCPHAC(pha),"^",8)
	..S cpdateflag=0
	..I (tStartDateTime'="")&(printdate=tStartDate)&(printtime<tStartDateTime) S cpdateflag=-1
 	..I (tEndDateTime'="")&(printdate=tEndDate)&(printtime>tEndDateTime) S cpdateflag=-1
	..Q:cpdateflag=-1
	..S:printdate'="" printdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(printdate,"PIVA")
	..S:printtime'="" printtime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(printtime,"PIVA")
	..S printuser=$P(^DHCPHAC(pha),"^",5)
	..I printuser'="" S:$D(^SSU("SSUSR",printuser)) printuser=$P(^SSU("SSUSR",printuser),"^",2)
	..S pog=""
	..F  S pog=$O(^PIVA(0,"PHAC",pha,pog)) Q:pog=""  D
	...S pdata=^PIVA(pog)
	...S grpno=$P(pdata,"^",2)	/// 循环轮次
	.../// 医嘱日期
	...S orddate=$P(pdata,"^",4)
	...Q:(tOrdStDate'="")&(orddate<tOrdStDate)
	...Q:(tOrdEndDate'="")&(orddate>tOrdEndDate)
	.../// 批次
	...S batno=$P(pdata,"^",3)
	...///
    ...S moedisp=$P(pdata,"^",1)
    ...S OrdExeRowid=$p(^DHCOEDISQTY(moedisp),"^",3)
	...S moeori=$P(^DHCOEDISQTY(moedisp),"^",3)
	...s updbatno=##class(web.DHCSTPIVA).GetUpBatNo(moedisp,grpno)
	...s:updbatno'="" batno=updbatno
	...Q:(tBatNo'="")&(tBatNo'=batno)
	...S mord=$P(moeori,"||",1)
	.../// 登记号
	...S adm=$P(^OEORD(mord),"^",1)	/// 病人 PAADM_Rowid
	...//S visitstatus=$P(^PAADM(adm),"^",20)	//病人住院状态
	...S visitstatus=##class(web.DHCSTCOMMONSRV).GetCurrentAdmStatus(adm) //201600310 标准版开发
	...S pat=##class(web.DHCSTPIVA).GetPat(adm)
	...S ipno=$P(pat,"^",1)
	...S paname=$P(pat,"^",2)
	...Q:(tRegNo'="")&(tRegNo'=ipno)
	...///配液分类
	...i LastMainOrd'=moeori d
	....s ptypestr=##class(web.DHCSTPIVA).GetAuditedType(moeori)
	....s typeID=$p(ptypestr,"^",1)
	...Q:(tOecType'="")&(tOecType'=$g(typeID))
	.../// 优先级
	...S pri=##class(web.DHCSTPIVA).GetOePriority(moeori)
	...S pridr=$P(pri,"^",1)
	...Q:(tOecprID'="")&(tOecprID'=pridr)
	.../// S pridesc=$P(pri,"^",3)
	.../// 关联医嘱是否包含此药品
	...S qflag=0
 	...I tItmID'="" D
 	....S qflag=##class(web.DHCSTPIVA).ChkExItm(moeori,tItmID)
 	...Q:(tItmID'="")&(qflag=0)
 	.../// pass审核
 	...S chstr=##class(web.DHCSTPIVA).GetPassResult(moeori)
	...S passre=$p(chstr,",",4) /// 配伍审核结果
 	...Q:(tPassAudit'="")&(tPassAudit'=passre)
 	.../// 医嘱状态
	...//S oestate=##class(web.DHCSTPIVA).GetOeState(moeori)
	...S oestate=##class(web.DHCSTPIVA).GetOrdExeState(OrdExeRowid)
	...S oestcode=$P(oestate,"^",1)
 	...S oestdesc=$P(oestate,"^",2)
 	...S cstatnumber=##class(web.DHCSTPIVA).GetPSNumber(pog)	//状态Number
 	...//Q:(tSpecStat="D")&(oestcode'=tSpecStat)&('((visitstatus="D")&(cstatnumber=10)))
 	...//Q:(tSpecStat="N")&((oestcode="D")!((visitstatus="D")&(cstatnumber=10)))
 	...S ChkOrdState=##class(web.DHCSTCOMMONSRV).GetOrdState(OrdExeRowid)
 	...I ChkOrdState=0 S oestdesc="停止"
 	...I ChkOrdState=0 S oestcode="D"
	...//Q:(tSpecStat="D")&(ChkOrdState=1)&('((visitstatus="D")&(cstatnumber=10)))
	...Q:(tSpecStat="D")&(ChkOrdState=1)&('((visitstatus="0")&(cstatnumber=10)))
	...Q:(tSpecStat="N")&((ChkOrdState=0)!((ChkOrdState=0)&(cstatnumber=10)))
	...
 	.../// 特殊状态
 	...S spec=$P(pdata,"^",8)
 	...Q:(tSpecStat'="")&(tSpecStat'="D")&(tSpecStat'=spec)
 	.../// 配药状态
 	...S psdr=$P(pdata,"^",6)
 	...S cstat=##class(web.DHCSTPIVA).GetPSName(pog)
 	...
 	...Q:(tState'="")&(tState'=cstat)
 	.../// 拒绝配液/取消配液
 	...S creason=""
 	...S cuser=""
 	...S cdate=""
 	...s ctime=""
 	...I (spec="R")!(spec="C") D
 	....S cuser=$P(pdata,"^",12)
 	....S cdate=$P(pdata,"^",13)
 	....S ctime=$P(pdata,"^",14)
 	....S cpor=$P(pdata,"^",9)
 	....I cuser'="" S:$D(^SSU("SSUSR",cuser)) cuser=$P(^SSU("SSUSR",cuser),"^",2)
 	....I cdate'="" S cdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(cdate,"PIVA")
 	....I ctime'="" S ctime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(ctime,"PIVA")
 	....I cpor'="" S:$D(^PIVAOR(cpor)) creason=$P(^PIVAOR(cpor),"^",2)
 	.../// 取消打印表
 	...S pcp=$P(pdata,"^",15)
 	...Q:(tDlabPrint=1)&(pcp="")
 	...Q:(tDlabPrint=0)&(pcp'="")
 	...S cprintno=""
 	...S cprintnum=""
 	...S cprintdate=""
 	...S cprinttime=""
 	...S cprintdatetime=""
 	...S cpdateflag=0
 	...I pcp'="" D
 	....I $D(^PIVACP(pcp)) D
 	.....S cprintno=$P(^PIVACP(pcp),"^",1)	/// 取消打印单号
 	.....S cprintdate=$P(^PIVACP(pcp),"^",3)
 	.....S cprinttime=$P(^PIVACP(pcp),"^",4)
 	.....S tCPrintStartDate=$P(tCPStr,"^",1)
 	.....S tCPrintEndDate=$P(tCPStr,"^",2)
 	.....S tCPrintStartTime=$P(tCPStr,"^",3)
 	.....S tCPrintEndTime=$P(tCPStr,"^",4)
 	.....S:tCPrintStartDate'="" tCPrintStartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(tCPrintStartDate)
 	.....S:tCPrintEndDate'="" tCPrintEndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(tCPrintEndDate)
 	.....S:tCPrintStartTime'="" tCPrintStartTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(tCPrintStartTime)
 	.....S:tCPrintEndTime'="" tCPrintEndTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(tCPrintEndTime)
 	.....I (tCPrintStartDate'="")&(cprintdate<tCPrintStartDate) S cpdateflag=-1
 	.....I (tCPrintEndDate'="")&(cprintdate>tCPrintEndDate) S cpdateflag=-1
 	.....I (tCPrintStartDate'="")&(cprintdate=tCPrintStartDate)&(cprinttime<tCPrintStartTime) S cpdateflag=-1
 	.....I (tCPrintEndDate'="")&(cprintdate=tCPrintEndDate)&(cprinttime>tCPrintEndTime) S cpdateflag=-1
 	.....Q:cpdateflag=-1
 	.....S:cprintdate'="" cprintdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(cprintdate,"PIVA")
 	.....S:cprinttime'="" cprinttime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(cprinttime,"PIVA")
 	.....S cprintdatetime=cprintdate_" "_cprinttime
 	.....S cprintnum=$P(^PIVA(pog),"^",16)	/// 取消打印序号
 	...Q:cpdateflag=-1
 	.../// 明细
	.../// 床号
 	...S bedid=$P(^PAADM(adm),"^",73)
 	...S bed="*"
 	...I bedid'="" D
 	....S wardid=$P(bedid,"||",1)
 	....S bedsub=$P(bedid,"||",2)
 	....I $D(^PAWARD(wardid,"BED",bedsub)) S bed=$P(^PAWARD(wardid,"BED",bedsub),"^",1)
 	.../// 频率代码
 	...S freqstr=##class(web.DHCSTPIVA).GetFreq(moeori)
 	...S freqcode=$P(freqstr,"^",2)
 	...///日期
 	...S stdate=$P(pdata,"^",4)
 	...S:stdate'="" sttdate2=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(stdate,"PIVA")
 	...S sttime=$P(pdata,"^",5)
 	...S:sttime'="" sttime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(sttime,"PIVA")
 	...///
 	...S instruc=##class(web.DHCSTPIVA).GetInstruc(moeori)	/// 用法
	...S dura=##class(web.DHCSTPIVA).GetDura(moeori)		/// 疗程
	...S doctor=##class(web.DHCSTPIVA).GetDoctor(moeori)	/// 医生
	...S printnumber=$P(pdata,"^",11)	/// 打印序号
 	...S tStartNo=$p(tPrintNoStr,"-",1)
 	...i tStartNo'="" s tStartNo=+tStartNo
 	...i tPrintNoStr'["-" s tEndtNo=tStartNo
 	...e  S tEndtNo=$p(tPrintNoStr,"-",2)
 	...i tStartNo'="" s tEndtNo=+tEndtNo
 	...i (tStartNo'="")&(tPrintNo'="")&(printnumber<tStartNo) S cpdateflag=-1
	...i (tEndtNo'="")&(tPrintNo'="")&(printnumber>tEndtNo) S cpdateflag=-1
	...Q:cpdateflag=-1
	...I Lastpog'=pog  d ..GetPrtDetail(PID,pog) ///准备打印明细记录
	...S Lastpog=pog
	...S pogsub=""
	...F  S pogsub=$O(^PIVA(pog,"I",pogsub)) Q:pogsub=""  D
	....S dodis=$P(^PIVA(pog,"I",pogsub),"^",1)
	....Q:dodis=""
	....Q:'$D(^DHCOEDISQTY(dodis))
 	....S dspstatus=$p(^DHCOEDISQTY(dodis),"^",7)
 	....//Q:dspstatus'="TC"	/// 已经确认
 	....S oeori=$p(^DHCOEDISQTY(dodis),"^",1)
 	....S ord=$P(oeori,"||",1)
 	....S chl=$P(oeori,"||",2)
 	....S seqno=$P($G(^OEORD(ord,"I",chl,3)),"^",4)		/// 关联医嘱号
 	....S incitm=##class(web.DHCSTPIVA).GetIncItm(oeori)
 	....S inci=$P(incitm,"^",1)
 	....Q:inci=""
 	....S itmdesc=$P(incitm,"^",3)
 	....s exStr=oeori_"^"_dodis
 	....s price=##class(web.DHCSTPRICE).GetSp(inci,stdate,"",HospID,"",exStr)
 	....//S price=##class(web.DHCSTCOMMONSRV).GetPriceElse(inci,stdate,"")
 	....S qty=$P(^DHCOEDISQTY(dodis),"^",11)
 	....S uomdr=$P(^DHCOEDISQTY(dodis),"^",6)
 	....S uomdesc="*"
 	....S:$D(^CT("UOM",uomdr)) uomdesc=$P(^CT("UOM",uomdr),"^",2)
 	....S spec=##class(web.DHCSTCOMINC).GetSpec(inci)		/// 规格
 	....S dosage=##class(web.DHCSTPIVA).GetDosage(oeori)	/// 剂量
 	....S sign=##class(web.DHCSTPIVA).GetPrintSign(oeori)	/// 打印标志
 	....S comp=##class(web.DHCSTPIVA).GetCompFlag(oeori)	/// 剂量是否整包装
 	....//S nuraudited=##class(web.DHCSTPIVA).IfAuditByPriority(oeori,pridr)	/// 是否护士审核
 	....S nuraudited=##class(web.DHCSTCOMMONSRV).GetNurAuditStr(dodis)	//zhouyg 20141219
 	....//w dodis_"^"_nuraudited,!
 	....s nuraudited=$s(nuraudited'="":"已审核",1:"未审核")
 	....S oepri=##class(web.DHCSTPIVA).GetOePriority(oeori)
	....S pridesc=$P(oepri,"^",3)
 	....S spestat=$P(^PIVA(pog),"^",8)	/// 特殊状态
 	....S presc=$P(^OEORD(ord,"I",chl,1),"^",14)
 	....S orddate=$P(^OEORD(ord,"I",chl,3),"^",7)
 	....S ordtime=$P(^OEORD(ord,"I",chl,1),"^",17)
 	....i orddate'="" s orddate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(orddate,"PIVA")
	....i ordtime'="" s ordtime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(ordtime,"PIVA")
	....S ordxdate=$P(^OEORD(ord,"I",chl,3),"^",34)
 	....S ordxtime=$P(^OEORD(ord,"I",chl,2),"^",15)
 	....i ordxdate'="" s ordxdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ordxdate,"PIVA")
	....i ordxtime'="" s ordxtime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(ordxtime,"PIVA")
	....S mdodis=##class(web.DHCSTPIVA).GetMainOEDispID(dodis,grpno)
	....S PogFlag=##class(web.DHCSTPIVA).GetPlogFlag(mdodis)   //是否正常打包
	....S PogFlag=$p(PogFlag,"^",1)
	....Q:(tplogflag="A")&&(PogFlag="N")
	....Q:(tplogflag="A")&&(PogFlag="")
	....Q:(tplogflag'="A")&&(tplogflag'="")&&(tplogflag'=PogFlag)
 	....I '$D(^TMP("PIVA",PID,"QPNO",moedisp,grpno)) D
 	.....S pno=pno+1
 	.....S ^TMP("PIVA",PID,"QPNO",moedisp,grpno)=pno
 	....S i=i+1
 	....i $f(ward,"-") s ward=$p(ward,"-",2)
 	....S j=sttdate2_"||"_ward_"||"_bed_"||"_batno_"||"_grpno_"||"_seqno
 	....;S j=oeori
 	....;S ^TMP("PIVA",PID,"Q","STDATE",j,i)=sttdate2_"||"_ward_"||"_bed_"||"_batno_"||"_grpno_"||"_seqno
 	....S ^TMP("PIVA",PID,"Q","ADM",j,i)=adm
 	....S ^TMP("PIVA",PID,"Q","OEORI",j,i)=oeori
 	....S ^TMP("PIVA",PID,"Q","DODIS",j,i)=dodis
 	....S ^TMP("PIVA",PID,"Q","PRICE",j,i)=price
 	....S ^TMP("PIVA",PID,"Q","GRPNO",j,i)=grpno
 	....S ^TMP("PIVA",PID,"Q","ITMNAME",j,i)=itmdesc
 	....S ^TMP("PIVA",PID,"Q","IPNO",j,i)=ipno
 	....S ^TMP("PIVA",PID,"Q","PANAME",j,i)=paname
 	....S ^TMP("PIVA",PID,"Q","QTY",j,i)=qty
 	....S ^TMP("PIVA",PID,"Q","UOM",j,i)=uomdesc
 	....S ^TMP("PIVA",PID,"Q","OESTATCODE",j,i)=oestcode
 	....S ^TMP("PIVA",PID,"Q","OESTAT",j,i)=oestdesc
 	....S ^TMP("PIVA",PID,"Q","PRI",j,i)=pridesc
 	....S ^TMP("PIVA",PID,"Q","SPEC",j,i)=spec
 	....S ^TMP("PIVA",PID,"Q","DOSAGE",j,i)=dosage
 	....S ^TMP("PIVA",PID,"Q","FREQ",j,i)=freqcode
 	....S ^TMP("PIVA",PID,"Q","DURA",j,i)=dura
 	....S ^TMP("PIVA",PID,"Q","INSTRUC",j,i)=instruc
 	....S ^TMP("PIVA",PID,"Q","PRESC",j,i)=presc
 	....S ^TMP("PIVA",PID,"Q","DOCTOR",j,i)=doctor
 	....S ^TMP("PIVA",PID,"Q","STTIME",j,i)=sttime
 	....S ^TMP("PIVA",PID,"Q","SIGN",j,i)=sign
 	....S ^TMP("PIVA",PID,"Q","COMP",j,i)=comp
 	....S ^TMP("PIVA",PID,"Q","NURAUDIT",j,i)=nuraudited
 	....S ^TMP("PIVA",PID,"Q","PASS",j,i)=passre
 	....S ^TMP("PIVA",PID,"Q","MOEORI",j,i)=moeori
 	....S ^TMP("PIVA",PID,"Q","PNO",j,i)=printno			/// 打印单号
 	....S ^TMP("PIVA",PID,"Q","PNUMBER",j,i)=printnumber	/// 打印序号
 	....S ^TMP("PIVA",PID,"Q","PUSER",j,i)=printuser
 	....S ^TMP("PIVA",PID,"Q","PDATE",j,i)=printdate
 	....S ^TMP("PIVA",PID,"Q","PTIME",j,i)=printtime
 	....S ^TMP("PIVA",PID,"Q","POG",j,i)=pog
 	....S ^TMP("PIVA",PID,"Q","STAT",j,i)=cstat
 	....S ^TMP("PIVA",PID,"Q","SPESTAT",j,i)=spestat
 	....S ^TMP("PIVA",PID,"Q","CPNO",j,i)=cprintno
 	....S ^TMP("PIVA",PID,"Q","CPNUMBER",j,i)=cprintnum
 	....S ^TMP("PIVA",PID,"Q","ORDDATE",j,i)=orddate
 	....S ^TMP("PIVA",PID,"Q","ORDTIME",j,i)=ordtime
 	....S ^TMP("PIVA",PID,"Q","CPDATETIME",j,i)=cprintdatetime
 	....S ^TMP("PIVA",PID,"Q","CDATETIME",j,i)=cdate_" "_ctime
 	....S ^TMP("PIVA",PID,"Q","CUSER",j,i)=cuser
 	....S ^TMP("PIVA",PID,"Q","CREASON",j,i)=creason
 	....S ^TMP("PIVA",PID,"Q","ORDXDATE",j,i)=ordxdate
 	....S ^TMP("PIVA",PID,"Q","ORDXTIME",j,i)=ordxtime
 	....S ^TMP("PIVA",PID,"Q","CNUMBER",j,i)=cstatnumber
 	....S ^TMP("PIVA",PID,"Q","VISITSTATUS",j,i)=visitstatus
 	....S ^TMP("PIVA",PID,"Q","MDODIS",j,i)=mdodis
 	...s LastMainOrd=moeori
	I i>0 S ^TMP("PIVA",PID,"QSUM")=i_"^"_pno
	Q:i>0 PID
	Q ""
}

ClassMethod GetData(PID As %String, j As %String, i As %String, lipno As %String, patcolor As %String) As %String
{
	N (PID,j,i,lipno,patcolor)
	;S stdate=$P(^TMP("PIVA",PID,"Q","STDATE",j,i),"||",1)
	;S ward=$P(^TMP("PIVA",PID,"Q","STDATE",j,i),"||",2)
	;S bed=$P(^TMP("PIVA",PID,"Q","STDATE",j,i),"||",3)
	;S batno=$P(^TMP("PIVA",PID,"Q","STDATE",j,i),"||",4)
	;S seqno=$P(^TMP("PIVA",PID,"Q","STDATE",j,i),"||",6)
	
	S stdate=$P(j,"||",1)
	S ward=$P(j,"||",2)
	S bed=$P(j,"||",3)
	S batno=$P(j,"||",4)
	S seqno=+$P(j,"||",6)
	S adm=^TMP("PIVA",PID,"Q","ADM",j,i)
	S oeori=^TMP("PIVA",PID,"Q","OEORI",j,i)
	S dodis=^TMP("PIVA",PID,"Q","DODIS",j,i)
	S price=^TMP("PIVA",PID,"Q","PRICE",j,i)
	S grpno=^TMP("PIVA",PID,"Q","GRPNO",j,i)
	S itmdesc=^TMP("PIVA",PID,"Q","ITMNAME",j,i)
 	S ipno=^TMP("PIVA",PID,"Q","IPNO",j,i)
 	S paname=^TMP("PIVA",PID,"Q","PANAME",j,i)
 	S uomdesc=^TMP("PIVA",PID,"Q","UOM",j,i)
 	S qty=^TMP("PIVA",PID,"Q","QTY",j,i)
 	S oestatecode=^TMP("PIVA",PID,"Q","OESTATCODE",j,i)
 	S oestate=^TMP("PIVA",PID,"Q","OESTAT",j,i)
 	S pridesc=^TMP("PIVA",PID,"Q","PRI",j,i)
 	S spec=^TMP("PIVA",PID,"Q","SPEC",j,i)
 	S dosage=^TMP("PIVA",PID,"Q","DOSAGE",j,i)
 	S freqcode=^TMP("PIVA",PID,"Q","FREQ",j,i)
 	S dura=^TMP("PIVA",PID,"Q","DURA",j,i)
 	S instruc=^TMP("PIVA",PID,"Q","INSTRUC",j,i)
 	S presc=^TMP("PIVA",PID,"Q","PRESC",j,i)
 	S doctor=^TMP("PIVA",PID,"Q","DOCTOR",j,i)
 	S sttime=^TMP("PIVA",PID,"Q","STTIME",j,i)
 	S sign=^TMP("PIVA",PID,"Q","SIGN",j,i)
 	S comp=^TMP("PIVA",PID,"Q","COMP",j,i)
 	S nuraudited=^TMP("PIVA",PID,"Q","NURAUDIT",j,i)
 	//s nuraudited=$s(nuraudited="1":"已审核",1:"未审核")
 	S passre=^TMP("PIVA",PID,"Q","PASS",j,i)
 	S moeori=^TMP("PIVA",PID,"Q","MOEORI",j,i)
 	S printno=^TMP("PIVA",PID,"Q","PNO",j,i)
 	S printnumber=^TMP("PIVA",PID,"Q","PNUMBER",j,i)
 	S printuser=^TMP("PIVA",PID,"Q","PUSER",j,i)
 	S printdate=^TMP("PIVA",PID,"Q","PDATE",j,i)
 	S printtime=^TMP("PIVA",PID,"Q","PTIME",j,i)
 	S pog=^TMP("PIVA",PID,"Q","POG",j,i)
 	S stat=^TMP("PIVA",PID,"Q","STAT",j,i)
 	S spestat=^TMP("PIVA",PID,"Q","SPESTAT",j,i)
 	S cprintno=^TMP("PIVA",PID,"Q","CPNO",j,i)
 	S cprintnum=^TMP("PIVA",PID,"Q","CPNUMBER",j,i)
 	S orddate=^TMP("PIVA",PID,"Q","ORDDATE",j,i)
 	S ordtime=^TMP("PIVA",PID,"Q","ORDTIME",j,i)
 	S cpdatetime=^TMP("PIVA",PID,"Q","CPDATETIME",j,i)
 	S cdatetime=^TMP("PIVA",PID,"Q","CDATETIME",j,i)
 	S cuser=^TMP("PIVA",PID,"Q","CUSER",j,i)
 	S creason=^TMP("PIVA",PID,"Q","CREASON",j,i)
 	S ordxdate=^TMP("PIVA",PID,"Q","ORDXDATE",j,i)
 	S ordxtime=^TMP("PIVA",PID,"Q","ORDXTIME",j,i)
 	S orddate=orddate_" "_ordtime
 	S printdate=printdate_" "_printtime
 	S ordxdate=ordxdate_" "_ordxtime
 	S cnumber=^TMP("PIVA",PID,"Q","CNUMBER",j,i)
 	f hh=1:1:(3-$l(printnumber)) d
 	.S printnumber=0_printnumber
 	S visitstatus=^TMP("PIVA",PID,"Q","VISITSTATUS",j,i)
 	S mdodis=^TMP("PIVA",PID,"Q","MDODIS",j,i) 
 	s oeore=$p(^DHCOEDISQTY(mdodis),"^",3)
 	s exelabel=$P(oeore,"||")_"-"_$P(oeore,"||",2)_"-"_$P(oeore,"||",3)_"-"_grpno  //与扫描执行条码对应
	s BarCode=mdodis
 	s colortypeStr=##class(web.DHCSTPIVA).GetColorType(ipno,lipno,oestate,passre,patcolor,spestat)
 	s colortype=$p(colortypeStr,"^",1)
 	s patcolor=$p(colortypeStr,"^",2)
 	s ^TMP("PIVA",PID,"Q","COLOR",j,i)=patcolor
 	S EncryptLevelInfo=""
	s EncryptLevel=""
	s PatLevel=""
	s HospID=""
    s EncryptFlag=##Class(web.DHCSTCOMMPARA).GetEncryptLevelFlag(HospID)
    i EncryptFlag=1 d
    .S papmi=$p(^PAADM(adm),"^",1)
	.s EncryptLevelInfo=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(papmi,"")
 	.s EncryptLevel=$p(EncryptLevelInfo,"^",1)
 	.s PatLevel=$p(EncryptLevelInfo,"^",2)
 	S data=$LB(PID,batno,seqno,itmdesc,ipno,bed,paname,freqcode,qty,price,oestate,dosage,spec,instruc,dura,presc,pridesc,doctor,stdate,sttime,comp,sign,dodis,grpno,printnumber,moeori,uomdesc,passre,printno,ward,printuser,printdate,pog,stat,spestat,cprintno,cprintnum,orddate,cpdatetime,cdatetime,cuser,creason,ordxdate,cnumber,visitstatus,BarCode,oestatecode,colortype,nuraudited,EncryptLevel,PatLevel,exelabel)
 	Q data
}

/// 取标签主信息
/// w ##class(web.DHCSTPIVAQUERY).GetPrintPog(100000083)
ClassMethod GetPrintPog(pog As %String) As %String
{
	N (pog,%session)
	S phac=$P(^PIVA(pog),"^",10)
	S pno=""
	S ward=""
	I $D(^DHCPHAC(phac)) D
	.S printdate=$P(^DHCPHAC(phac),"^",7)
	.S printtime=$P(^DHCPHAC(phac),"^",8)
	.S:printtime'="" printtime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(printtime,"PIVA")
	.S pno=$P(^DHCPHAC(phac),"^",14)	/// 打印单号
	.S ward=$P(^DHCPHAC(phac),"^",4)	/// 病区
	.I ward'="" D
	..S:$D(^PAWARD(ward)) ward=$P(^PAWARD(ward),"^",2)
	S pnumber=$P(^PIVA(pog),"^",11)	/// 打印序号
	F hh=1:1:(3-$l(pnumber)) D
	.S pnumber=0_pnumber
	s pno=pno_"-"_pnumber  /// 打印单号-序号	
	S moedisp=$P(^PIVA(pog),"^",1)
	S moeori=$P(^DHCOEDISQTY(moedisp),"^",3) /// 主医嘱ID
	S batno=$P(^PIVA(pog),"^",3)	/// 批次
	S pcp=$P(^PIVA(pog),"^",15)		/// 取消打印表ID
	S plocdr=$P(^PIVA(pog),"^",7)
	S cpno=""
	I pcp'="" D
	.S:$D(^PIVACP(pcp)) cpno=$P(^PIVACP(pcp),"^",1)
	S cpnumber=$P(^PIVA(pog),"^",16)	/// 取消打印的序号
	s notes=##class(web.DHCSTPIVA).GetNotes(moeori)      ///备注
	i $l(notes)>10 d
	.s notes=$e(notes,1,10)_"…"
	.s ^tmpnotes=notes
	S instruc=##class(web.DHCSTPIVA).GetInstruc(moeori)	/// 用法
	S pri=##class(web.DHCSTPIVA).GetOePriority(moeori)	/// 优先级
	s prcode=$P(pri,"^",2)	
	S pri=$P(pri,"^",3)	
	S freq=##class(web.DHCSTPIVA).GetFreq(moeori)	/// 频率
	S freq=$P(freq,"^",2)
	S patstr=##class(web.DHCSTPIVA).GetOeInfoByMoeori(moeori)	/// 病人信息 bed_"^"_paname_"^"_ipno_"^"_age_"^"_sex
	S odate=$P(^PIVA(pog),"^",4) 
	;s pdate=odate 
    ;S ptypestr=##class(web.DHCSTPIVA).GetAuditedType(moeori)
	;S typedr=$P(ptypestr,"^",1)
	;s remark=""
	;I typedr="" s remark=##class(web.DHCSTPIVA).GetOrdItmRemark(moeori) //沈阳旧数据分类在医嘱备注存着
	;I remark["TPN" s typedr="TPN"
	;I (typedr'="TPN")&(prcode="S") s pdate=odate+1      //沈阳非TPN 长嘱执行时间+1=配制时间
	;I (prcode="S") s pdate=odate+1  //长嘱执行时间+1=配制时间
	//S pdate=##class(web.DHCSTPIVA).GetPyDate(moeori,batno,pri,printdate,odate,freq,plocdr)
	s pdate=$P(^DHCOEDISQTY(moedisp),"^",21) //yunhaibao20160606默认与用药日期一致
	S:printdate'="" printdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(printdate,"PIVA")
	S prtdt=printdate_" "_printtime
	s prtdt=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(+$h,"PIVA")_" "_##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml($p($h,",",2),"PIVA")
	S:odate'="" odate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(odate,"PIVA")
	S otime=$P(^PIVA(pog),"^",5)
	S:otime'="" otime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(otime,"PIVA")
	S dt=odate_" "_otime
	S:pdate'="" pdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(pdate,"PIVA")
	S pdate=pdate_" "_otime //配制时间
	s phalocdr=$P(^PIVA(pog),"^",7)
	S bttime=##class(web.DHCSTPIVA).GetTimeByBatNo(phalocdr,batno)
	i bttime'="" s bttime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(bttime,"PIVA")
	S dt=odate_" "_bttime
	;S pdate=pdate_" "_bttime
	S TotalLiquid=##class(web.DHCSTPIVA).GetTotalLiquid(pog)
	S adm=$P(^OEORD(+moeori),"^",1)
	S pasts=""
	S pastno=""
	/// S pasts=..GetPasts(pid,phac,adm)
	/// S pastno=..GetPastNo(pid,pog)
	S grpno=$P(^PIVA(pog),"^",2)
	S spest=$P(^PIVA(pog),"^",8) /// 取消 拒绝
	S stype=""
	I (spest'="")&(spest'="N") D
	.S:spest="C" stype="消"
	.S:spest="R" stype="拒"
	E  D
	.;S oest=##class(web.DHCSTPIVA).GetOeState(moeori)
	.;S oest=$P(oest,"^",1)
	.;I oest="D" S stype="停"
	.S moedisp=$P(^PIVA(pog),"^",1)
    .S OrdExeRowid=$p(^DHCOEDISQTY(moedisp),"^",3)
    .S ChkOrdState=##class(web.DHCSTCOMMONSRV).GetOrdState(OrdExeRowid)
 	.I ChkOrdState=0 S stype="停"
	S weight=##class(web.DHCSTPIVA).GetPatWeight(adm)
	S chstr=##class(web.DHCSTPIVA).GetPassResult(moeori)
	S passuser=$p(chstr,",",1) /// 配伍审核人
 	S passuname=""
 	I passuser'="" D
 	.I $D(^SSU("SSUSR",passuser)) D
 	..S passuname=$P(^SSU("SSUSR",passuser),"^",1)
 	///
 	S papmi=$p(^PAADM(adm),"^",1) 
 	S PAAllergy=##class(web.DHCSTPIVA).GetPAAllergyStr(papmi,"")
 	S doctor=##class(web.DHCSTPIVA).GetDoctor(moeori)	/// 医生
 	S BatNums="",BatNN=""
 	///
 	S prescno=$P(^OEORD(+moeori,"I",$p(moeori,"||",2),1),"^",14)	/// 处方号
 	//皮试
 	S skintest=##class(web.DHCSTPIVA).SkinTest(moeori)
 	I skintest>0 S $P(patstr,"^",3)=$P(patstr,"^",3)_" "_"(皮试 — )"
 	I skintest<0 S $P(patstr,"^",3)=$P(patstr,"^",3)_" "_"(皮试 + )"
 	I skintest=-5 S $P(patstr,"^",3)=$P(patstr,"^",3)_" "_"(皮试   )"
 	s packflag=$p(^DHCOEDISQTY(moedisp),"^",28) //静配打包状态
 	i (packflag'="")&&(packflag'="N") s packflag="打包"
 	s EncryptLevelInfo=""
    s EncryptLevel=""
    s PatLevel="" 
    s EncryptFlag=##Class(web.DHCSTCOMMPARA).GetEncryptLevelFlag("")
    i EncryptFlag=1 d
 	.s condition=##class(web.DHCSTCOMMONSRV).ChangeToJson("打印单号^病区^打印日期",pno_"^"_ward_"^"_printdate)
 	.s content=##class(web.DHCSTCOMMONSRV).ChangeToJson("床号^姓名^登记号",patstr)
 	.s EncryptLevelInfo=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(papmi,"")
 	.s EncryptCode=$p(EncryptLevelInfo,"^",3)
 	.//s ^tmpevent=condition_"^"_content_"^"_EncryptCode_"^"_%session
 	.s eventlogret=##class(web.DHCSTCOMMONSRV).CreateEventLog("DHCDISPPIVAPRT",condition,content,EncryptCode)
 	//
	;S retstr=pog_"^"_moeori_"^"_grpno_"^"_ward_"^"_pno_"^"_pnumber_"^"_batno_"^"_cpno_"^"_cpnumber_"^"_pri_"^"_freq_"^"_instruc_"^"_prtdt_"^"_TotalLiquid_"^"_pasts_"^"_pastno_"^"_patstr_"^"_stype_"^"_weight_"^"_passuname_"^"_prescno_"^"_pdate_"^"_notes
	;S retstr=pog_"^"_moeori_"^"_grpno_"^"_ward_"^"_pno_"^"_pnumber_"^"_batno_"^"_cpno_"^"_cpnumber_"^"_pri_"^"_freq_"^"_instruc_"^"_prtdt_"^"_TotalLiquid_"^"_pasts_"^"_pastno_"^"_patstr_"^"_stype_"^"_weight_"^"_passuname_"^"_PAAllergy_"^"_doctor_"^"_BatNums_"^"_BatNN_"^"_notes_"^"_""_"^"_""_"^"_""_"^"_""
	S retstr=pog_"^"_moeori_"^"_grpno_"^"_ward_"^"_pno_"^"_pnumber_"^"_batno_"^"_cpno_"^"_cpnumber_"^"_pri_"^"_freq_"^"_instruc_"^"_prtdt_"^"_TotalLiquid_"^"_pasts_"^"_pastno_"^"_patstr_"^"_stype_"^"_weight_"^"_passuname_"^"_prescno_"^"_pdate_"^"_doctor_"^"_packflag
	S ^TMP("pog","M")=retstr
	Q retstr
}

/// 取标签明细信息
ClassMethod GetPrintPogItm(pog As %String) As %String
{
	N (pog)
	S pogsub="0",pogistr=""
	F  S pogsub=$O(^PIVA(pog,"I",pogsub)) Q:pogsub=""  D
	.S dsp=$P(^PIVA(pog,"I",pogsub),"^",1)
	.Q:'$D(^DHCOEDISQTY(dsp))
	.S oeori=$P(^DHCOEDISQTY(dsp),"^",1) Q:oeori=""
	.S incitm=##class(web.DHCSTPIVA).GetIncItm(oeori)
 	.S inci=$P(incitm,"^",1)
 	.S incidesc=$P(incitm,"^",3)
	.S spec=##class(web.DHCSTCOMINC).GetSpec(inci)
	.S dosage=##class(web.DHCSTPIVA).GetDosage(oeori)
	.S dosageml=##class(web.DHCSTPIVA).GetDosageML(oeori)
	.i dosageml'="" s dosage=dosageml
	.S sign=##class(web.DHCSTPIVA).GetPrintSign(oeori)
	.S incidesc=sign_incidesc
	.S comp=##class(web.DHCSTPIVA).GetCompFlag(oeori)	/// 剂量是否整包装
	.S BuomQtyStr=##Class(web.DHCSTPIVA).GetDosageBUom(oeori)
	.S BQty=$P(BuomQtyStr,"^",1)
	.S BUom=$P(BuomQtyStr,"^",2)
	.I pogistr="" S pogistr=incidesc_"^"_dosage_"^"_spec_"^"_comp_"^"_BQty_"^"_BUom
	.E  S pogistr=pogistr_"||"_incidesc_"^"_dosage_"^"_spec_"^"_comp_"^"_BQty_"^"_BUom
	S ^TMP("pog","I")=pogistr
	Q pogistr
}

/// 取打印首页数据
ClassMethod GetPrintHData(PCPDr As %String) As %String
{
	N (PCPDr)
	Q:PCPDr="" ""
	Q:'$D(^PIVACP(PCPDr)) ""
	S str=^PIVACP(PCPDr)
	S pno=$P(str,"^",1)
	S user=$P(str,"^",2)
	I user'="" D
	S:$D(^SSU("SSUSR",user)) user=$P(^SSU("SSUSR",user),"^",2)
	S pdate=$P(str,"^",3)
	S:pdate'="" pdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(pdate,"PIVA")
	S ptime=$P(str,"^",4)
	S:ptime'="" ptime=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ptime,"PIVA")
	S pdt=pdate_" "_ptime
	S ret=user_"^"_pdt_"^"_pno
	Q ret
}

/// 某一张配药单打印的批次种类和数量列表
ClassMethod GetPhBatList(PCPDr As %String) As %String
{
	N (PCPDr)
	Q:PCPDr="" ""
	S pid=..NewPid()
	K ^TMP("PIVA",pid,"PCPBAT")
	S pog="",sum=0
	F  S pog=$O(^PIVA(0,"PCP",PCPDr,pog)) Q:pog=""  D
	.S bat=$P(^PIVA(pog),"^",3)
	.S ^TMP("PIVA",pid,"PCPBAT",bat)=$G(^TMP("PIVA",pid,"PCPBAT",bat))+1
	.S sum=sum+1
	S bb="",ret=""
	F  S bb=$O(^TMP("PIVA",pid,"PCPBAT",bb)) Q:bb=""  D
	.S str="第"_bb_"批："_^TMP("PIVA",pid,"PCPBAT",bb)_"袋"
	.I ret="" S ret=str
	.E  S ret=ret_"^"_str
	S strsum="合计："_sum_"袋"
	I ret'="" S ret=ret_"^"_strsum
	K ^TMP("PIVA",pid,"PCPBAT")
	Q ret
}

/// 插入取消打印表
ClassMethod InsCPrint() As %String
{
	N puser
	S puser=##class(web.DHCSTCOMWEB).GetUserID()
	Q:puser="" -1
	L +^DHCSTLOCK("PIVA","INCPNO"):5  E  Q -100
	K PLIST
	S PLIST(1)=""
	S PLIST(2)=..GetCprintNo()
	S PLIST(3)=puser
	S PLIST(4)=+$H
	S PLIST(5)=$P($H,",",2)
	&SQL(Insert Into PIVA_CPrint Values :PLIST())
	L -^DHCSTLOCK("PIVA","INCPNO")
	Q:SQLCODE -2
	Q $P(%ROWID,$C(1))
}

ClassMethod GetCprintNo() As %String
{
	N cpno,lno,maxno,da
	S cpno="C"
	S cpno=cpno_$E($ZD(+$H,8),3,8)
	S maxno=""
	S da=+$H
	&sql(Select Max(PCP_PrintNo) Into :maxno From  PIVA_CPrint Where PCP_Date=:da And %ALPHAUP(PCP_PrintNo) %STARTSWITH :cpno)
	S maxno=$E(maxno,10,12)+1
	S maxno=$J(maxno,3)
	S maxno=$TR(maxno," ","0")
	S cpno=cpno_maxno
	Q cpno
}

/// 打印取消停止医嘱时更新PIVA_OrdGrp
/// w ##class(web.DHCSTPIVAQUERY).SavePogCprint(100000026,100000005,1)
ClassMethod SavePogCprint(pog As %String, pcp As %String, num As %String) As %String
{
	N (pog,pcp,num,%session)
	Tstart
	S err=0
	L +^DHCSTLOCK("PIVA","DPRT",pog):5  E  Q -100
	S moedisp=$P(^PIVA(pog),"^",1)
    S OrdExeRowid=$p(^DHCOEDISQTY(moedisp),"^",3)
    s mainoeori=##class(web.DHCSTPIVA).GetMainOeori($p(OrdExeRowid,"||",1,2))  //主医嘱id
    S oest=##class(web.DHCSTPIVA).GetOrdExeState(OrdExeRowid)
	S oest=$P(oest,"^",1)
    S ChkOrdState=##class(web.DHCSTCOMMONSRV).GetOrdState(OrdExeRowid)
 	I ChkOrdState=0 S oest="D"
	S spst=$P(^PIVA(pog),"^",8)
	I (oest'="D")&(spst="N") L -^DHCSTLOCK("PIVA","DPRT",pog)
	Q:(oest'="D")&(spst="N") 0
	K PLIST
	&SQL(Select * Into :PLIST() From PIVA_OrdGrp Where POG_RowId=:pog)
	S PLIST(16)=pcp
	S PLIST(17)=num
	&SQL(Update PIVA_OrdGrp Values :PLIST() Where POG_RowId=:pog)
	I SQLCODE'=0 s err=SQLCODE
	S ctloc=$p(^OEORD(+mainoeori,"I",$p(mainoeori,"||",2),3),"^",6)
	S prtretflag=##class(web.DHCSTPIVA).IfExecRet(ctloc)
	I (SQLCODE=0)&(prtretflag="Y") S err=..ExecReturn(pog)
	i err["success" s err=0
	I err'=0 L -^DHCSTLOCK("PIVA","DPRT",pog) Trollback
	q:err'=0 -10
	Tcommit
	Q SQLCODE
}

/// 退药,yunhaibao20151113,按8.0修改
/// w ##class(web.DHCSTPIVAQUERY).ExecReturn(100000037)
ClassMethod ExecReturn(pog As %String) As %String
{
	n (pog,%session)
	S pogsub="",err=0,datastr=""
	F  S pogsub=$O(^PIVA(pog,"I",pogsub)) Q:(pogsub="")||(err'=0)  D
	.S dsp=$P(^PIVA(pog,"I",pogsub),"^",1)
	.Q:'$D(^DHCOEDISQTY(dsp))
	.S oeori=$P(^DHCOEDISQTY(dsp),"^",1)
	.Q:oeori=""
	.q:$P(^DHCOEDISQTY(dsp),"^",7)'="C"  //已发药才调用
	.S ord=$p(oeori,"||",1)
	.S itm=$p(oeori,"||",2)
	.S reclocdr=$p(^OEORD(ord,"I",itm,3),"^",6)
	.S retrqdr=""
	.S userdr=$g(%session.Data("LOGON.USERID"))
	.S qty=$p(^DHCOEDISQTY(dsp),"^",5)
	.s retedqty=##class(web.DHCSTPHARETURN).ReturnedQtyByDodis(dsp)
	.s exeqty=qty-retedqty
	.q:exeqty<=0
	.s data=dsp_"^"_qty_"^"_""
	.i datastr="" s datastr=data
	.e  s datastr=datastr_","_data
	q:datastr="" "success^"_0
	S err=##class(web.DHCSTPHARETURN).ExecReturn(reclocdr,userdr,"PIVARET",datastr)
	Q err
}

/// 重打标签的保存
ClassMethod SavePogState(pog As %String) As %String
{
	N (pog,%session)
	S cnumber=10
	s locid=%session.Data("LOGON.CTLOCID")
	s pstype="I"
	S moedisp=$P(^PIVA(pog),"^",1)
	s OrdExeRowid=$P(^DHCOEDISQTY(moedisp),"^",3)
	//S oest=##class(web.DHCSTPIVA).GetOeState(pog)
	S oest=##class(web.DHCSTPIVA).GetOrdExeState(OrdExeRowid)	//zhouyg 20151110
	S oest=$P(oest,"^",1)
	S spst=$P(^PIVA(pog),"^",8)
	Q:(oest="D")!(spst'="N") 0
	S psdr=$P(^PIVA(pog),"^",6)
	S nextnumber=##class(web.DHCSTPIVA).GetNextStat(psdr,locid,pstype)
	S nextnumber=$P(nextnumber,"^",2)
	Q:nextnumber'=cnumber 0
	S ps=$O(^PIVAS(0,"NUMBER",cnumber,""))
	Q:ps="" -1
	S puser=##class(web.DHCSTCOMWEB).GetUserID()
	Q:puser="" -2
	K PLIST
	&SQL(Select * Into :PLIST() From PIVA_OrdGrp Where pog_rowid=:pog)
	S PLIST(7)=ps
	&SQL(Update PIVA_OrdGrp Values :PLIST() Where pog_rowid=:pog)
	Q:SQLCODE -1
	S ret=..InsOrdGrpState(pog,puser,ps)
	Q ret
}

ClassMethod InsOrdGrpState(parref As %String, user As %String, ps As %String) As %String
{
	N (parref,user,ps)
	Q:parref="" -1
	Q:user="" -2
	Q:ps="" -3
	K PLIST
	S PLIST(0)=parref
	S PLIST(2)=$O(^PIVA(parref,"S",""),-1)+1
	S PLIST(3)=ps
	S PLIST(4)=user
	S PLIST(5)=+$H
	S PLIST(6)=$P($H,",",2)
	&SQL(Insert Into PIVA_OrdGrpState Values :PLIST())
	Q SQLCODE
}

ClassMethod GetRecordSum(pid As %String) As %String
{
	Q $G(^TMP("PIVA",pid,"QSUM"))
}

ClassMethod NewPid() As %String
{
 	Q $I(^DHCSTPIVA("COLL"))
}

ClassMethod ClearAllTmp(pid As %String) As %String
{
	D ..CLEARTMP(pid,"Q")
	D ..CLEARTMP(pid,"QPNO")
	D ..CLEARTMP(pid,"QSUM")
	D ..CLEARTMP(pid,"PrtDetail")
	Q 0
}

ClassMethod CLEARTMP(pid As %String, PAR As %String) As %String
{
	K ^TMP("PIVA",pid,PAR)
	Q 0
}

/// 取标签处方信息
ClassMethod GetPrescInfo(pog As %String, pid As %String) As %String
{
	N (pog,pid)
	S phac=$P(^PIVA(pog),"^",10)
	S moeori=$P(^PIVA(pog),"^",1)
	S pno=""
	S ward=""
	I $D(^DHCPHAC(phac)) D
	.S prtno=$P(^DHCPHAC(phac),"^",14)	/// 打印单号
	.S ward=$P(^DHCPHAC(phac),"^",4)	/// 病区
	.I ward'="" D
	..S:$D(^PAWARD(ward)) ward=$P(^PAWARD(ward),"^",2)
	S instruc=##class(web.DHCSTPIVA).GetInstruc(moeori)	/// 用法
	S patstr=##class(web.DHCSTPIVA).GetOeInfoByMoeori(moeori)	/// 病人信息 bed_"^"_paname_"^"_ipno_"^"_age_"^"_sex
	S doctor=##class(web.DHCSTPIVA).GetDoctor(moeori)	/// 医生
	S odate=$P(^PIVA(pog),"^",4)
	S:odate'="" odate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(odate,"PIVA")
	S otime=$P(^PIVA(pog),"^",5)
	S:otime'="" otime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(otime,"PIVA")
	S dt=odate_" "_otime
	S bed=$p(patstr,"^",1)
	S patname=$p(patstr,"^",2)
	S patno=$p(patstr,"^",3)
	S pogsub=""
	S i =0
	F  S pogsub=$O(^PIVA(pog,"I",pogsub)) Q:pogsub=""  D
	.S dsp=$P(^PIVA(pog,"I",pogsub),"^",1)
	.Q:'$D(^DHCOEDISQTY(dsp))
	.S oeori=$P(^DHCOEDISQTY(dsp),"^",1) Q:oeori=""
	.S incitm=##class(web.DHCSTPIVA).GetIncItm(oeori)
 	.S inci=$P(incitm,"^",1)
 	.S incidesc=$P(incitm,"^",3)
	.S spec=##class(web.DHCSTCOMINC).GetSpec(inci)
	.S dosage=##class(web.DHCSTPIVA).GetDosage(oeori)
	.S dosageml=##class(web.DHCSTPIVA).GetDosageML(oeori)
	.i dosageml'="" s dosage=dosageml
	.S i=i+1
	.i $f(ward,"-") s ward=$p(ward,"-",2)
	.S retstr=ward_"^"_patname_"^"_patno_"^"_bed_"(床)"_"^"_dt_"^"_prtno_"^"_incidesc_"^"_dosage_"^"_doctor
	.S ^TMP("PIVA",pid,"PRTPRESC",i)=retstr 
	Q i
}

/// 打印标签处方信息
ClassMethod ListPrescInfo(pid As %String, i As %String) As %String
{
	n (pid,i)
	S retstr=^TMP("PIVA",pid,"PRTPRESC",i)
	i retstr'="" k ^TMP("PIVA",pid,"PRTPRESC",i)
	Q retstr
}

ClassMethod GetPrtDetail(pid As %String, pog As %String) As %String
{
	N (pid,pog)
	S phac=$P(^PIVA(pog),"^",10)
	S moedisp=$P(^PIVA(pog),"^",1)
	S moeori=$P(^DHCOEDISQTY(moedisp),"^",3)
	S pno=""
	S ward=""
	I $D(^DHCPHAC(phac)) D
	.S prtno=$P(^DHCPHAC(phac),"^",14)	/// 打印单号
	.S ward=$P(^DHCPHAC(phac),"^",4)	/// 病区
	.I ward'="" D
	..S:$D(^PAWARD(ward)) ward=$P(^PAWARD(ward),"^",2)
	S instruc=##class(web.DHCSTPIVA).GetInstruc(moeori)	/// 用法
	S patstr=##class(web.DHCSTPIVA).GetOeInfoByMoeori(moeori)	/// 病人信息 bed_"^"_paname_"^"_ipno_"^"_age_"^"_sex
	S doctor=##class(web.DHCSTPIVA).GetDoctor(moeori)	/// 医生
	S batno=$P(^PIVA(pog),"^",3)
	S odate=$P(^PIVA(pog),"^",4)
	S:odate'="" odate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(odate,"PIVA")
	S otime=$P(^PIVA(pog),"^",5)
	S:otime'="" otime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(otime,"PIVA")
	S dt=odate_" "_otime
	S bed=$p(patstr,"^",1)
	S patname=$p(patstr,"^",2)
	S patno=$p(patstr,"^",3)
	S freq=##class(web.DHCSTPIVA).GetFreq(moeori)	/// 频率
	S freq=$P(freq,"^",2)
	S pogsub=""
	F  S pogsub=$O(^PIVA(pog,"I",pogsub)) Q:pogsub=""  D
	.S dsp=$P(^PIVA(pog,"I",pogsub),"^",1)
	.Q:'$D(^DHCOEDISQTY(dsp))
	.S oeori=$P(^DHCOEDISQTY(dsp),"^",1) Q:oeori=""
	.S incitm=##class(web.DHCSTPIVA).GetIncItm(oeori)
 	.S inci=$P(incitm,"^",1)
 	.S incidesc=$P(incitm,"^",3)
	.S spec=##class(web.DHCSTCOMINC).GetSpec(inci)
	.S dosage=##class(web.DHCSTPIVA).GetDosage(oeori)
	.S dosageml=##class(web.DHCSTPIVA).GetDosageML(oeori)
	.i dosageml'="" s dosage=dosageml
	.i $f(ward,"-") s ward=$p(ward,"-",2)
	.S retstr=ward_"^"_patname_"^"_patno_"^"_bed_"^"_dt_"^"_prtno_"^"_incidesc_"^"_dosage_"^"_doctor_"^"_batno_"^"_pog_"^"_pogsub_"^"_freq
	.S ^TMP("PIVA",pid,"PrtDetail",ward_"/"_bed_"/"_patno_"/"_batno_"/"_pog_"/"_pogsub)=retstr
	q
}

/// 打印标签明细信息
ClassMethod ListPrtDetail(pid As %String, str As %String) As %String
{
	n (pid,str)
	s retstr=""
	S tmp=$o(^TMP("PIVA",pid,"PrtDetail",str))
	q:tmp="" ""
	s retstr=^TMP("PIVA",pid,"PrtDetail",tmp)
	Q retstr
}

/// 清除标签明细信息
ClassMethod KillTmpPrint(pid As %String) As %String
{
	n (pid)
    k ^TMP("PIVA",pid,"PrtDetail")
}

ClassMethod GetCPrintList(pid As %String, i As %String) As %String
{
	Q ^TMP("PIVA",pid,"PCPL",i)
}

// Descritpt:	根据取消打印表的ID取医嘱详细信息

// Creater：		Zhouyg

// CreateDate:	20100318

// Input:		PCPDr-PIVA_CPrint表的ID

// Output:

// Return:		记录数

ClassMethod GetCPrintData(PCPDr As %String) As %String
{
	N (PCPDr)
	Q:PCPDr="" ""
	S pid=..NewPid()
	D ..CLEARTMP(pid,"PCPL")
	S pog="",Num=0
	F  S pog=$O(^PIVA(0,"PCP",PCPDr,pog)) Q:pog=""  D
	.S PogStr=..GetPrintPog(pog)
	.S PogIStr=..GetPrintPogItm(pog)
	.S Num=Num+1
	.S ^TMP("PIVA",pid,"PCPL",Num)=PogStr_"!"_PogIStr
	.s ward=$p(PogStr,"^",4)
	.s ^TMP("PIVA",pid,"WARD",ward,Num)=PogStr_"!"_PogIStr
	s ward=""
	s wardcnt=0   //病区数
	f  s ward=$o(^TMP("PIVA",pid,"WARD",ward)) q:ward=""  d
	.s num=""
	.s wardcnt=wardcnt+1
	.s wardnum=0      //各病区医嘱数
	.f  s num=$o(^TMP("PIVA",pid,"WARD",ward,num)) q:num=""  d
	..s wardnum=wardnum+1
	..s ^TMP("PIVA",pid,"WARDLIST",ward,wardnum)=^TMP("PIVA",pid,"WARD",ward,num)
	..i '$d(^TMP("PIVA",pid,"WARDNUM",ward)) s ^TMP("PIVA",pid,"WARDNUM",ward)=1
	..e  d
	...s ^TMP("PIVA",pid,"WARDNUM",ward)=^TMP("PIVA",pid,"WARDNUM",ward)+1
	;Q pid_"^"_Num
	q pid_"^"_wardcnt
}

// 获取某病区的医嘱数

ClassMethod GetWardNum(pid As %String, ward As %String) As %String
{
 
    q ^TMP("PIVA",pid,"WARDNUM",ward)
}

// 获取下一个病区

ClassMethod GetNextWard(pid As %String, ward As %String) As %String
{
 
	s ward=$o(^TMP("PIVA",pid,"WARDLIST",ward))
	q ward
}

ClassMethod GetListByWard(pid As %String, ward As %String, i As %String) As %String
{
	q ^TMP("PIVA",pid,"WARDLIST",ward,i)
}

ClassMethod GetPIVAInfoByOeExecute(ByRef qHandle As %Binary, tSDate As %String, tEDate As %String, tSTime As %String, tETime As %String, tWardID As %String, tRegNo As %String, EpisodeID) As %Status
{
	S repid=$I(^CacheTemp)
	S qHandle=$lb(0,repid,0)
	S ind=1
	S PID=""
	i tSTime="" s tSTime=0
	i tETime="" s tETime=86399
	;s ^lq(2)=tStartDate_","_tEndDate_","_tRegNo_","_tItmID_","_tPassAudit_","_tState_","_tSpecStat_","_tDlabPrint_","_tOrdStDate_","_tOrdEndDate_","_tCPStr 
	S PID=..CollDataNew(tSDate, tEDate,tSTime,tETime,tWardID,tRegNo)
	Q:PID="" $$$OK
	S jj=""
	F  S jj=$O(^TMP("PIVA",PID,"Q","ADM",jj)) Q:jj=""  D
	.S ii=""
	.F  S ii=$O(^TMP("PIVA",PID,"Q","ADM",jj,ii)) Q:ii=""  D
	..S Data=..GetData(PID,jj,ii,"","")
	..S ^CacheTemp(repid,ind)=Data	
 	..S ind=ind+1
 	Q $$$OK
}

Query GetPIVAInfoByOe(tSDate As %String, tEDate As %String, tSTime As %String, tETime As %String, tWardID As %String, tRegNo As %String, EpisodeID) As %Query(ROWSPEC = "tbPID:%String,tbBatNo:%String,tbSeqNo:%String,tbItmDesc:%String,tbRegNo:%String,tbBedNo:%String,tbName:%String,tbFreq:%String,tbQty:%String,tbPrice:%String,tbOeStatus:%String,tbDosage:%String,tbSpec:%String,tbInst:%String,tbDura:%String,tbPresc:%String,tbOecpr:%String,tbDoctor:%String,tbOexeDate:%String,tbOexeTime:%String,tbCompare:%String,tbSign:%String,tbDSP:%String,tbGrpNo:%String,tbPrintNum:%String,tbMOeori:%String,tbUom:%String,tbPassResult:%String,tbPrintNo:%String,tbWard:%String,tbPUser:%String,tbPDate:%String,tbPogID:%String,tbState:%String,tbSpecStat:%String,tbCPrintNo:%String,tbCPrintNum:%String,tbOrdDate:%String,tbCprintDateTime:%String,tbCDateTime:%String,tbCUser:%String,tbCReason:%String,tbOrdXDate:%String,tbCnumber:%String,tbVisitStatus:%String,tbBarCode:%String,tbOestateCode:%String,tbColorType:%String,tbNurAudit:%String,TEncryptLevel:%String,TPatLevel:%String,TExeLabel:%String")
{
}

ClassMethod GetPIVAInfoByOeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPIVAInfoByOeExecute ]
{
	S repid=$LIST(qHandle,2)
 	K ^CacheTemp(repid)
 	Q $$$OK
}

ClassMethod GetPIVAInfoByOeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPIVAInfoByOeExecute ]
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

ClassMethod CollDataNew(tStartDate As %String, tEndDate As %String, tSTime As %String, tETime As %String, tWardID As %String, tRegNo As %String) As %Integer
{
	S PID=..NewPid()
	D ..ClearAllTmp(PID)
	//S ^TMP("PIVA",PID,"CM")=tPLocID_"^"_tWardID_"^"_tStartDate_"^"_tEndDate
	S i=0,pno=0
    S DispStateNumber=60	//配置状态
    s DispStateID=$o(^PIVAS(0,"NUMBER",DispStateNumber,""))
	s LastMainOrd=""
	s tPLocID=""
	f  s tPLocID=$o(^DHCPHAC(0,"PHP",tPLocID)) q:tPLocID=""  d
	.s HospID=$p($g(^CTLOC(tPLocID)),"^",22)
	.s Param=""_"^"_tPLocID_"^"_""_"^"_$g(HospID)
    .s OnlyPIVALocFlag=##class(web.DHCST.Common.AppCommon).GetAppPropValue("DHCSTINPIVA","OnlyPIVALoc",Param)	//zhouyg 20150624 仅仅是配液中心科室
	.q:OnlyPIVALocFlag'="Y" 
	.F date=tStartDate:1:tEndDate D
	..S pha=""
	..F  S pha=$O(^DHCPHAC(0,"PHP",tPLocID,"DATE",date,pha)) Q:pha=""  D
	...Q:($D(^DHCPHAC(pha))=0)!($D(^DHCPHAC(pha))=10)
	.../// 病区
	...S ward=$P(^DHCPHAC(pha),"^",4)
	...Q:(tWardID'="")&(tWardID'=ward)
	...;Q:##class(web.DHCSTPIVA).CheckWard(tWardID,ward)=0
	...S ward=$P(^PAWARD(ward),"^",2)
	.../// 打印单号
	...S printno=$P(^DHCPHAC(pha),"^",14)
	...;Q:(tPrintNo'="")&(tPrintNo'=printno)&($e(tPrintNo,1)="P")
	...S printdate=$P(^DHCPHAC(pha),"^",7)
	...S printtime=$P(^DHCPHAC(pha),"^",8)
	...;S cpdateflag=0
	...;I (tStartDateTime'="")&(printdate=tStartDate)&(printtime<tStartDateTime) S cpdateflag=-1
 	...;I (tEndDateTime'="")&(printdate=tEndDate)&(printtime>tEndDateTime) S cpdateflag=-1
	...;Q:cpdateflag=-1
	...S:printdate'="" printdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(printdate,"PIVA")
	...S:printtime'="" printtime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(printtime,"PIVA")
	...S printuser=$P(^DHCPHAC(pha),"^",5)
	...I printuser'="" S:$D(^SSU("SSUSR",printuser)) printuser=$P(^SSU("SSUSR",printuser),"^",2)
    ...S pog=""
	...F  S pog=$O(^PIVA(0,"PHAC",pha,pog)) Q:pog=""  D
	....S pdata=^PIVA(pog)
	....S grpno=$P(pdata,"^",2)	/// 循环轮次
	..../// 医嘱日期
	....S orddate=$P(pdata,"^",4)
	....s ordtime=$p(pdata,"^",5)
	....q:(tSTime'="")&(ordtime<tSTime)
	....q:(tETime'="")&(ordtime>tETime)
	....;Q:(tOrdStDate'="")&(orddate<tOrdStDate)
	....;Q:(tOrdEndDate'="")&(orddate>tOrdEndDate)
	..../// 批次
	....S batno=$P(pdata,"^",3)
	....;Q:(tBatNo'="")&(tBatNo'=batno)
	....///
	....S moedisp=$P(pdata,"^",1)
    ....S OrdExeRowid=$p(^DHCOEDISQTY(moedisp),"^",3)
	....S moeori=$P(^DHCOEDISQTY(moedisp),"^",3)
	....S mord=$P(moeori,"||",1)
	....;S moeori=$P(pdata,"^",1)
	....;S mord=$P(moeori,"||",1)
	..../// 登记号
	....S adm=$P(^OEORD(mord),"^",1)	/// 病人 PAADM_Rowid
	....//S visitstatus=$P(^PAADM(adm),"^",20)	//病人住院状态
	....S visitstatus=##class(web.DHCSTCOMMONSRV).GetCurrentAdmStatus(adm)	//20160310 标准版开发
	....S pat=##class(web.DHCSTPIVA).GetPat(adm)
	....S ipno=$P(pat,"^",1)
	....S paname=$P(pat,"^",2)
	....Q:(tRegNo'="")&(tRegNo'=ipno)
	....///配液分类
	....i LastMainOrd'=moeori d
	.....s ptypestr=##class(web.DHCSTPIVA).GetAuditedType(moeori)
	.....s typeID=$p(ptypestr,"^",1)
	....;Q:(tOecType'="")&(tOecType'=$g(typeID))
	..../// 优先级
	....S pri=##class(web.DHCSTPIVA).GetOePriority(moeori)
	....S pridr=$P(pri,"^",1)
	....;Q:(tOecprID'="")&(tOecprID'=pridr)
	..../// S pridesc=$P(pri,"^",3)
	..../// 关联医嘱是否包含此药品
	....;S qflag=0
 	....;I tItmID'="" D
 	.....;S qflag=##class(web.DHCSTPIVA).ChkExItm(moeori,tItmID)
 	....;Q:(tItmID'="")&(qflag=0)
 	..../// pass审核
 	....S chstr=##class(web.DHCSTPIVA).GetPassResult(moeori)
	....S passre=$p(chstr,",",4) /// 配伍审核结果
 	....;Q:(tPassAudit'="")&(tPassAudit'=passre)
 	..../// 医嘱状态
	....//S oestate=##class(web.DHCSTPIVA).GetOeState(moeori)
	....S oestate=##class(web.DHCSTPIVA).GetOrdExeState(OrdExeRowid)
	....S oestcode=$P(oestate,"^",1)
 	....S oestdesc=$P(oestate,"^",2)
 	....S cstatnumber=##class(web.DHCSTPIVA).GetPSNumber(pog)	//状态Number
 	....;Q:(tSpecStat="D")&(oestcode'=tSpecStat)&('((visitstatus="D")&(cstatnumber<DispStateNumber)))
 	....;Q:(tSpecStat="N")&((oestcode="D")!((visitstatus="D")&(cstatnumber<DispStateNumber)))
 	....;Q:(tSpecStat="D")&(tDlabPrint=0)&(cstatnumber=DispStateNumber)	//选择停医嘱,未打印时不显示已经配置的
 	....;Q:(tSpecStat="R")&(tDlabPrint=0)&(cstatnumber=DispStateNumber)	//选择拒绝医嘱,未打印时不显示已经配置的
 	....//Q:(tSpecStat="D")&(oestcode'=tSpecStat)
 	....//Q:(tSpecStat="N")&(oestcode="D")
 	....//S oeexest=##class(web.DHCSTPIVA).GetOeoreStat(moeori,grpno) /// 是否已经执行
 	....//Q:(tSpecStat="D")&(oestcode=tSpecStat)&(oeexest=1)
 	....//Q:(tSpecStat="N")&(oestcode="D")&(oeexest=0)
 	....//I (oestcode="D")&(oeexest=1) D
 	....//.S oestdesc="核实"
 	..../// 特殊状态
 	....S spec=$P(pdata,"^",8)
 	....;Q:(tSpecStat'="")&(tSpecStat'="D")&(tSpecStat'=spec)
 	..../// 配药状态
 	....S psdr=$P(pdata,"^",6)
 	....S cstat=##class(web.DHCSTPIVA).GetPSName(pog)
 	....;Q:(tState'="")&(tState'=cstat)
 	..../// 拒绝配液/取消配液
 	....S creason=""
 	....S cuser=""
 	....S cdate=""
 	....s ctime=""
 	....I (spec="R")!(spec="C") D
 	.....S cuser=$P(pdata,"^",12)
 	.....S cdate=$P(pdata,"^",13)
 	.....S ctime=$P(pdata,"^",14)
 	.....S cpor=$P(pdata,"^",9)
 	.....I cuser'="" S:$D(^SSU("SSUSR",cuser)) cuser=$P(^SSU("SSUSR",cuser),"^",2)
 	.....I cdate'="" S cdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(cdate,"PIVA")
 	.....I ctime'="" S ctime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(ctime,"PIVA")
 	.....I cpor'="" S:$D(^PIVAOR(cpor)) creason=$P(^PIVAOR(cpor),"^",2)
 	..../// 取消打印表
 	....S pcp=$P(pdata,"^",15)
 	....;Q:(tDlabPrint=1)&(pcp="")
 	....;Q:(tDlabPrint=0)&(pcp'="")
 	....S cprintno=""
 	....S cprintnum=""
 	....S cprintdate=""
 	....S cprinttime=""
 	....S cprintdatetime=""
 	....S cpdateflag=0
 	....I pcp'="" D
 	.....I $D(^PIVACP(pcp)) D
 	......S cprintno=$P(^PIVACP(pcp),"^",1)	/// 取消打印单号
 	......;i (tPrintNo'="")&(tPrintNo'=cprintno)&($e(tPrintNo,1)="C") s cpdateflag=-1
 	......;q:cpdateflag=-1
 	......S cprintdate=$P(^PIVACP(pcp),"^",3)
 	......S cprinttime=$P(^PIVACP(pcp),"^",4)	
 	......S:cprintdate'="" cprintdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(cprintdate,"PIVA")
 	......S:cprinttime'="" cprinttime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(cprinttime,"PIVA")
 	......S cprintdatetime=cprintdate_" "_cprinttime
 	......S cprintnum=$P(^PIVA(pog),"^",16)	/// 取消打印序号
 	....;q:(tPrintNo'="")&(tPrintNo'=cprintno)&($e(tPrintNo,1)="C")
 	....;q:(tPrintNo'="")&(tPrintNo'=cprintno)&(tPrintNo'=printno)
 	....///打印序号
 	....S printnumber=$P(pdata,"^",11)
 	..../// 明细
	..../// 床号
 	....S bedid=$P(^PAADM(adm),"^",73)
 	....S bed="*"
 	....I bedid'="" D
 	.....S wardid=$P(bedid,"||",1)
 	.....S bedsub=$P(bedid,"||",2)
 	.....I $D(^PAWARD(wardid,"BED",bedsub)) S bed=$P(^PAWARD(wardid,"BED",bedsub),"^",1)
 	..../// 频率代码
 	....S freqstr=##class(web.DHCSTPIVA).GetFreq(moeori)
 	....S freqcode=$P(freqstr,"^",2)
 	....///日期
 	....S stdate=$P(pdata,"^",4)
 	....S:stdate'="" sttdate2=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(stdate,"PIVA")
 	....S sttime=$P(pdata,"^",5)
 	....S:sttime'="" sttime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(sttime,"PIVA")
 	....///
 	....S instruc=##class(web.DHCSTPIVA).GetInstruc(moeori)	/// 用法
	....S dura=##class(web.DHCSTPIVA).GetDura(moeori)		/// 疗程
	....S doctor=##class(web.DHCSTPIVA).GetDoctor(moeori)	/// 医生
	....///
	....I '$D(^TMP("PIVA",PID,"QPNO",moeori,grpno)) D
 	.....S pno=pno+1
 	.....S ^TMP("PIVA",PID,"QPNO",moeori,grpno)=pno
	....///取第一次配液确认人
	....s (DspUser,DspDateTime)=""
	....i DispStateID'="" d
	.....s pogsSub=$o(^PIVA(0,"PS",DispStateID,pog,""))
	.....q:pogsSub=""
	.....s DspUser=$p($g(^PIVA(pog,"S",pogsSub)),"^",3)
	.....i DspUser'="" s DspUser=$P($g(^SSU("SSUSR",DspUser)),"^",2)
	.....s pogsDate=$p($g(^PIVA(pog,"S",pogsSub)),"^",4)
	.....i pogsDate'="" s pogsDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(pogsDate,"PIVA")
	.....s pogsTime=$p($g(^PIVA(pog,"S",pogsSub)),"^",5)
	.....i pogsTime'="" s pogsTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(pogsTime,"PIVA")
	.....s DspDateTime=pogsDate_" "_pogsTime
	....e  d ///取各配液状态的操作人操作时间
	.....s pogsSub=$o(^PIVA(0,"PS",10,pog,""))
	.....q:pogsSub=""
	.....s DspUser=$p($g(^PIVA(pog,"S",pogsSub)),"^",3)
	.....i DspUser'="" s DspUser=$P($g(^SSU("SSUSR",DspUser)),"^",2)
	.....s pogsDate=$p($g(^PIVA(pog,"S",pogsSub)),"^",4)
	.....i pogsDate'="" s pogsDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(pogsDate,"PIVA")
	.....s pogsTime=$p($g(^PIVA(pog,"S",pogsSub)),"^",5)
	.....i pogsTime'="" s pogsTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(pogsTime,"PIVA")
	.....s DspDateTime=pogsDate_" "_pogsTime
	....;I Lastpog'=pog  d ..GetPrtDetail(PID,pog) ///准备打印明细记录
	....;S Lastpog=pog
	....S pogsub=""
	....F  S pogsub=$O(^PIVA(pog,"I",pogsub)) Q:pogsub=""  D
	.....S dodis=$P(^PIVA(pog,"I",pogsub),"^",1)
	.....Q:dodis=""
	.....Q:'$D(^DHCOEDISQTY(dodis))
 	.....S dspstatus=$p(^DHCOEDISQTY(dodis),"^",7)
 	.....//Q:dspstatus'="TC"	/// 已经确认
 	.....S oeori=$p(^DHCOEDISQTY(dodis),"^",1)
 	.....S ord=$P(oeori,"||",1)
 	.....S chl=$P(oeori,"||",2)
 	.....S seqno=$P($G(^OEORD(ord,"I",chl,3)),"^",4)		/// 关联医嘱号
 	.....S incitm=##class(web.DHCSTPIVA).GetIncItm(oeori)
 	.....S inci=$P(incitm,"^",1)
 	.....Q:inci=""
 	.....S itmdesc=$P(incitm,"^",3)
 	.....s exStr=oeori_"^"_dodis
 	.....s price=##class(web.DHCSTPRICE).GetSp(inci,stdate,"",HospID,"",exStr)
 	.....S qty=$P(^DHCOEDISQTY(dodis),"^",11)
 	.....s oeore=$P(^DHCOEDISQTY(dodis),"^",3)
 	.....q:##class(web.DHCSTPIVA).GetReturnedQtyByOeore(oeore)=qty ; 已退不需签收
 	.....S uomdr=$P(^DHCOEDISQTY(dodis),"^",6)
 	.....S uomdesc="*"
 	.....S:$D(^CT("UOM",uomdr)) uomdesc=$P(^CT("UOM",uomdr),"^",2)
 	.....S spec=##class(web.DHCSTCOMINC).GetSpec(inci)		/// 规格
 	.....S dosage=##class(web.DHCSTPIVA).GetDosage(oeori)	/// 剂量
 	.....S sign=##class(web.DHCSTPIVA).GetPrintSign(oeori)	/// 打印标志
 	.....S comp=##class(web.DHCSTPIVA).GetCompFlag(oeori)	/// 剂量是否整包装
 	.....//S nuraudited=##class(web.DHCSTPIVA).IfAuditByPriority(oeori,pridr)	/// 是否护士审核
 	.....//S nuraudited=##class(web.DHCSTCOMMONSRV).IfAuditByPriority(dodis)
 	.....S nuraudited=##class(web.DHCSTCOMMONSRV).GetNurAuditStr(dodis)  ///修改 bianshuai 2015-12-07
 	.....s nuraudited=$s(nuraudited'="":"已审核",1:"未审核")
 	.....S oepri=##class(web.DHCSTPIVA).GetOePriority(oeori)
	.....S pridesc=$P(oepri,"^",3)
 	.....S spestat=$P(^PIVA(pog),"^",8)	/// 特殊状态
 	.....S presc=$P(^OEORD(ord,"I",chl,1),"^",14)
 	.....S orddate=$P(^OEORD(ord,"I",chl,3),"^",7)
 	.....S ordtime=$P(^OEORD(ord,"I",chl,1),"^",17)
 	.....i orddate'="" s orddate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(orddate,"PIVA")
	.....i ordtime'="" s ordtime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(ordtime,"PIVA")
	.....S ordxdate=$P(^OEORD(ord,"I",chl,3),"^",34)
 	.....S ordxtime=$P(^OEORD(ord,"I",chl,2),"^",15)
 	.....i ordxdate'="" s ordxdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ordxdate,"PIVA")
	.....i ordxtime'="" s ordxtime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(ordxtime,"PIVA")
	.....s barcode=$P(^PIVA(pog),"^",17)
	.....S mdodis=##class(web.DHCSTPIVA).GetMainOEDispID(dodis,grpno)
 	.....///
 	.....S i=i+1
 	.....i $f(ward,"-") s ward=$p(ward,"-",2)
 	.....i seqno'["." s seqno=seqno_".0"
 	.....S j=sttdate2_"||"_ward_"||"_bed_"||"_batno_"||"_grpno_"||"_seqno_"||"_moeori
 	.....;S j=oeori
 	.....;S ^TMP("PIVA",PID,"Q","STDATE",j,i)=sttdate2_"||"_ward_"||"_bed_"||"_batno_"||"_grpno_"||"_seqno
 	.....S ^TMP("PIVA",PID,"Q","ADM",j,i)=adm
 	.....S ^TMP("PIVA",PID,"Q","OEORI",j,i)=oeori
 	.....S ^TMP("PIVA",PID,"Q","DODIS",j,i)=dodis
 	.....S ^TMP("PIVA",PID,"Q","PRICE",j,i)=price
 	.....S ^TMP("PIVA",PID,"Q","GRPNO",j,i)=grpno
 	.....S ^TMP("PIVA",PID,"Q","ITMNAME",j,i)=itmdesc
 	.....S ^TMP("PIVA",PID,"Q","IPNO",j,i)=ipno
 	.....S ^TMP("PIVA",PID,"Q","PANAME",j,i)=paname
 	.....S ^TMP("PIVA",PID,"Q","QTY",j,i)=qty
 	.....S ^TMP("PIVA",PID,"Q","UOM",j,i)=uomdesc
 	.....S ^TMP("PIVA",PID,"Q","OESTATCODE",j,i)=oestcode
 	.....S ^TMP("PIVA",PID,"Q","OESTAT",j,i)=oestdesc
 	.....S ^TMP("PIVA",PID,"Q","PRI",j,i)=pridesc
 	.....S ^TMP("PIVA",PID,"Q","SPEC",j,i)=spec
 	.....S ^TMP("PIVA",PID,"Q","DOSAGE",j,i)=dosage
 	.....S ^TMP("PIVA",PID,"Q","FREQ",j,i)=freqcode
 	.....S ^TMP("PIVA",PID,"Q","DURA",j,i)=dura
 	.....S ^TMP("PIVA",PID,"Q","INSTRUC",j,i)=instruc
 	.....S ^TMP("PIVA",PID,"Q","PRESC",j,i)=presc
 	.....S ^TMP("PIVA",PID,"Q","DOCTOR",j,i)=doctor
 	.....S ^TMP("PIVA",PID,"Q","STTIME",j,i)=sttime
 	.....S ^TMP("PIVA",PID,"Q","SIGN",j,i)=sign
 	.....S ^TMP("PIVA",PID,"Q","COMP",j,i)=comp
 	.....S ^TMP("PIVA",PID,"Q","NURAUDIT",j,i)=nuraudited
 	.....S ^TMP("PIVA",PID,"Q","PASS",j,i)=passre
 	.....S ^TMP("PIVA",PID,"Q","MOEORI",j,i)=moeori
 	.....S ^TMP("PIVA",PID,"Q","PNO",j,i)=printno			/// 打印单号
 	.....S ^TMP("PIVA",PID,"Q","PNUMBER",j,i)=printnumber	/// 打印序号
 	.....S ^TMP("PIVA",PID,"Q","PUSER",j,i)=printuser
 	.....S ^TMP("PIVA",PID,"Q","PDATE",j,i)=printdate
 	.....S ^TMP("PIVA",PID,"Q","PTIME",j,i)=printtime
 	.....S ^TMP("PIVA",PID,"Q","POG",j,i)=pog
 	.....S ^TMP("PIVA",PID,"Q","STAT",j,i)=cstat
 	.....S ^TMP("PIVA",PID,"Q","SPESTAT",j,i)=spestat
 	.....S ^TMP("PIVA",PID,"Q","CPNO",j,i)=cprintno
 	.....S ^TMP("PIVA",PID,"Q","CPNUMBER",j,i)=cprintnum
 	.....S ^TMP("PIVA",PID,"Q","ORDDATE",j,i)=orddate
 	.....S ^TMP("PIVA",PID,"Q","ORDTIME",j,i)=ordtime
 	.....S ^TMP("PIVA",PID,"Q","CPDATETIME",j,i)=cprintdatetime
 	.....S ^TMP("PIVA",PID,"Q","CDATETIME",j,i)=cdate_" "_ctime
 	.....S ^TMP("PIVA",PID,"Q","CUSER",j,i)=cuser
 	.....S ^TMP("PIVA",PID,"Q","CREASON",j,i)=creason
 	.....S ^TMP("PIVA",PID,"Q","ORDXDATE",j,i)=ordxdate
 	.....S ^TMP("PIVA",PID,"Q","ORDXTIME",j,i)=ordxtime
 	.....S ^TMP("PIVA",PID,"Q","CNUMBER",j,i)=cstatnumber
 	.....S ^TMP("PIVA",PID,"Q","VISITSTATUS",j,i)=visitstatus
 	.....S ^TMP("PIVA",PID,"Q","DSPUSER",j,i)=DspUser
 	.....S ^TMP("PIVA",PID,"Q","DSPDATETIME",j,i)=DspDateTime
 	.....S ^TMP("PIVA",PID,"Q","BARCODE",j,i)=barcode
 	.....S ^TMP("PIVA",PID,"Q","MDODIS",j,i)=mdodis
 	....s LastMainOrd=moeori
 	;s batno=""
	;f  s batno=$o(^TMP("PIVA",PID,"PrtDetailBat",batno)) q:batno=""  d
	;.s printnumber=""
	;.f  s printnumber=$o(^TMP("PIVA",PID,"PrtDetailBat",batno,printnumber)) q:printnumber=""  d
	;..s str=""
	;..f  s str=$o(^TMP("PIVA",PID,"PrtDetailBat",batno,printnumber,str)) q:str=""  d
	;...s ^TMP("PIVA",PID,"PrtDetail",str)=^TMP("PIVA",PID,"PrtDetailBat",batno,printnumber,str)    ///打印记录排序
	I i>0 S ^TMP("PIVA",PID,"QSUM")=i_"^"_pno
	Q:i>0 PID
	Q ""
}

ClassMethod GetDate() As %String
{
	q ##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(+$h)
}

ClassMethod GetAdmInfo(admId)
{
	n (admId)
	s curWardDr=$p(^PAADM(admId),"^",70)
	s curWardDesc=$p(^PAWARD(curWardDr),"^",2)	
	q curWardDr_"^"_curWardDesc
}

}
