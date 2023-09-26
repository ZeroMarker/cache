Import SQLUser

/// 拒绝/取消
Class web.DHCSTPIVAREFUSE Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
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

ClassMethod DispExecute(ByRef qHandle As %Binary, tPLocID As %String, tWardID As %String, tStartDate As %String, tEndDate As %String, tRegNo As %String, tBatNo As %String, tOecprID As %String, tItmID As %String, tPrintNo As %String, tPassAudit As %String, tOrdStDate As %String, tOrdEndDate As %String, tSpecStat As %String, tOecType As %String) As %Status
{
	S repid=$I(^CacheTemp)
	S qHandle=$lb(0,repid,0)
	S ind=1
	Q:tPLocID="" $$$OK
	Q:tStartDate="" $$$OK
	Q:tEndDate="" $$$OK
	S PID=""
	S PID=..CollData(tPLocID, tWardID, tRegNo, tStartDate, tEndDate, tBatNo, tOecprID, tItmID, tPrintNo,tPassAudit,tOrdStDate,tOrdEndDate,tSpecStat,tOecType)
	Q:PID="" $$$OK
	S jj=""
	F  S jj=$O(^TMP("PIVA",PID,"RF","ADM",jj)) Q:jj=""  D
	.S ii=""
	.F  S ii=$O(^TMP("PIVA",PID,"RF","ADM",jj,ii)) Q:ii=""  D
	..S Data=..GetData(PID,jj,ii)
	..///S ^TMP("PIVA",PID,"RC2",ind)=Data
	..S ^CacheTemp(repid,ind)=Data	
 	..S ind=ind+1
 	Q $$$OK
}

Query Disp(tPLocID As %String, tWardID As %String, tStartDate As %String, tEndDate As %String, tRegNo As %String, tBatNo As %String, tOecprID As %String, tItmID As %String, tPrintNo As %String, tPassAudit As %String, tOrdStDate As %String, tOrdEndDate As %String, tSpecStat As %String, tOecType As %String) As %Query(ROWSPEC = "tbPID:%String,tbBatNo:%String,tbSeqNo:%String,tbItmDesc:%String,tbRegNo:%String,tbBedNo:%String,tbName:%String,tbFreq:%String,tbQty:%String,tbPrice:%String,tbOeStatus:%String,tbDosage:%String,tbSpec:%String,tbInst:%String,tbDura:%String,tbPresc:%String,tbOecpr:%String,tbDoctor:%String,tbOexeDate:%String,tbOexeTime:%String,tbCompare:%String,tbSign:%String,tbDSP:%String,tbGrpNo:%String,tbPrintNum:%String,tbMOeori:%String,tbUom:%String,tbPassResult:%String,tbPrintNo:%String,tbWard:%String,tbPUser:%String,tbPDate:%String,tbPTime:%String,tbPogID:%String,tbState:%String,tbSpecStat:%String,tdrugcatdr:%String,tdrugcatdesc:%String,tbMdodis:%String,tbNurAudit:%String,TEncryptLevel:%String,TPatLevel:%String")
{
}

ClassMethod CollData(tPLocID As %String, tWardID As %String, tRegNo As %String, tStartDate As %String, tEndDate As %String, tBatNo As %String, tOecprID As %String, tItmID As %String, tPrintNo As %String, tPassAudit As %String, tOrdStDate As %String, tOrdEndDate As %String, tSpecStat As %String, tOecType As %String) As %Integer
{
	N (tPLocID, tWardID, tRegNo, tStartDate, tEndDate, tBatNo, tOecprID, tItmID, tPrintNo,tPassAudit,tOrdStDate,tOrdEndDate,tSpecStat,tOecType)
	Q:tPLocID="" ""
	Q:tStartDate="" ""
	Q:tEndDate="" ""
	S cnumber=70	/// 当前状态号
	s dispnum=+##class(web.DHCSTPIVA).GetDispNumberByLoc(tPLocID)
	S PID=..NewPid()
	D ..ClearAllTmp(PID)
	//S ^TMP("PIVA",PID,"CM")=tPLocID_"^"_tWardID_"^"_tStartDate_"^"_tEndDate
	s HospID=$p($g(^CTLOC(tPLocID)),"^",22)
	S i=0,pno=0
	S LastMainOrd=""
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
	..S:printdate'="" printdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(printdate,"PIVA")
	..S printtime=$P(^DHCPHAC(pha),"^",8)
	..S:printtime'="" printtime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(printtime,"PIVA")
	..S printuser=$P(^DHCPHAC(pha),"^",5)
	..I printuser'="" S:$D(^SSU("SSUSR",printuser)) printuser=$P(^SSU("SSUSR",printuser),"^",2)
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
	...S moeori=$P(^DHCOEDISQTY(moedisp),"^",3) 
	...S mord=$P(moeori,"||",1)
	.../// 登记号
	...S adm=$P(^OEORD(mord),"^",1)	/// 病人 PAADM_Rowid
	...Q:##Class(web.DHCSTPIVA).IfQuitAdmStatusD(adm)=1	//已经结算退出
	...S pat=##class(web.DHCSTPIVA).GetPat(adm)
	...S ipno=$P(pat,"^",1)
	...S paname=$P(pat,"^",2)
	...Q:(tRegNo'="")&(tRegNo'=ipno)
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
 	...S OrdExeRowid=$p(^DHCOEDISQTY(moedisp),"^",3) 
 	.../// 医嘱状态
	...//S oestate=##class(web.DHCSTPIVA).GetOeState(moeori)
	...S oestate=##class(web.DHCSTPIVA).GetOrdExeState(OrdExeRowid)
	...S oestcode=$P(oestate,"^",1)
 	...//Q:(oestcode'="V")&(oestcode'="E")
 	...S oestdesc=$P(oestate,"^",2)
 	...S ChkOrdState=##class(web.DHCSTCOMMONSRV).GetOrdState(OrdExeRowid)
 	...Q:(ChkOrdState'=1)&(tSpecStat="N")
 	...Q:(ChkOrdState=1)&(tSpecStat="D")  //只查停止状态
 	...//Q:(tSpecStat="D")&(oestcode'=tSpecStat)
 	...//Q:(tSpecStat="N")&(oestcode="D")
 	.../// 特殊状态,已经取消或拒绝的去掉
 	...S spestat=$P(pdata,"^",8)
 	...Q:(tSpecStat'="")&(tSpecStat'="D")&(tSpecStat'=spestat)
 	...
 	...///当前配药状态
 	...S psdr=$P(pdata,"^",6)
 	...S pstatnum=$P($g(^PIVAS(psdr)),"^",1)
 	...Q:pstatnum'<cnumber
 	...Q:pstatnum'<dispnum //yunhaibao20160407,减库后不允许拒绝
 	...S cstat=##class(web.DHCSTPIVA).GetPSName(pog)
 	...///配液分类
 	...i LastMainOrd'=moeori d
	....s ptypestr=##class(web.DHCSTPIVA).GetAuditedType(moeori)
	....s typeID=$p(ptypestr,"^",1)
	...Q:(tOecType'="")&(tOecType'=$g(typeID))
 	...S LastMainOrd=moeori
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
	...S grpno=$P(pdata,"^",2)	/// 循环轮次
	...S pogsub=""
	...F  S pogsub=$O(^PIVA(pog,"I",pogsub)) Q:pogsub=""  D
	....S dodis=$P(^PIVA(pog,"I",pogsub),"^",1)
	....Q:dodis=""
	....Q:'$D(^DHCOEDISQTY(dodis))
 	....S dspstatus=$p(^DHCOEDISQTY(dodis),"^",7)
 	....Q:dspstatus'="TC"	/// 已经确认
 	....S oeori=$p(^DHCOEDISQTY(dodis),"^",1)
 	....//S Audited=##class(web.DHCSTPIVA).IfAuditByPriority(oeori,pridr)
 	....//i Audited<0 s Audited="N"
 	....//e  s Audited="Y"
 	....S nuraudited=##class(web.DHCSTCOMMONSRV).GetNurAuditStr(dodis)
 	....s nuraudited=$s(nuraudited'="":"已审核",1:"未审核")
 	....S ord=$P(oeori,"||",1)
 	....S chl=$P(oeori,"||",2)
 	....S seqno=$P(^OEORD(ord,"I",chl,3),"^",4)		/// 关联医嘱号
 	....S incitm=##class(web.DHCSTPIVA).GetIncItm(oeori)
 	....S inci=$P(incitm,"^",1)
 	....S itmdesc=$P(incitm,"^",3)
 	....s exStr=oeori_"^"_dodis
 	....S price=##class(web.DHCSTPRICE).GetSp(inci,stdate,"",HospID,"",exStr)
 	....//S price=##class(web.DHCSTCOMMONSRV).GetPriceElse(inci,stdate,"")
 	....S qty=$P(^DHCOEDISQTY(dodis),"^",11)
 	....S uomdr=$P(^DHCOEDISQTY(dodis),"^",6)
 	....S uomdesc="*"
 	....S:$D(^CT("UOM",uomdr)) uomdesc=$P(^CT("UOM",uomdr),"^",2)
 	....S spec=##class(web.DHCSTCOMINC).GetSpec(inci)		/// 规格
 	....S dosage=##class(web.DHCSTPIVA).GetDosage(oeori)	/// 剂量
 	....S sign=##class(web.DHCSTPIVA).GetPrintSign(oeori)	/// 打印标志
 	....S comp=##class(web.DHCSTPIVA).GetCompFlag(oeori)	/// 剂量是否整包装
 	....//S nuraudited="" //##class(web.DHCSTPIVA).IfAuditByPriority(oeori,pridr)	/// 是否护士审核
 	....S nuraudited=##class(web.DHCSTCOMMONSRV).GetNurAuditStr(dodis)	//zhouyg 20141220
 	....s nuraudited=$s(nuraudited'="":"已审核",1:"未审核")
 	....S oepri=##class(web.DHCSTPIVA).GetOePriority(oeori)
	....S pridesc=$P(oepri,"^",3)
 	....S presc=$P(^OEORD(ord,"I",chl,1),"^",14)
 	....S drugcatdr=$p(ptypestr,"^",1) //药学分类(或子类)rowid
	....S drugcatdesc=$p(ptypestr,"^",2) //药学分类(或子类)描述
 	....///
 	....S i=i+1
 	....S j=sttdate2_"||"_ward_"||"_bed_"||"_batno_"||"_grpno_"||"_seqno
 	....S ^TMP("PIVA",PID,"RF","ADM",j,i)=adm
 	....S ^TMP("PIVA",PID,"RF","OEORI",j,i)=oeori
 	....S ^TMP("PIVA",PID,"RF","DODIS",j,i)=dodis
 	....S ^TMP("PIVA",PID,"RF","PRICE",j,i)=price
 	....S ^TMP("PIVA",PID,"RF","GRPNO",j,i)=grpno
 	....S ^TMP("PIVA",PID,"RF","ITMNAME",j,i)=itmdesc
 	....S ^TMP("PIVA",PID,"RF","IPNO",j,i)=ipno
 	....S ^TMP("PIVA",PID,"RF","PANAME",j,i)=paname
 	....S ^TMP("PIVA",PID,"RF","QTY",j,i)=qty
 	....S ^TMP("PIVA",PID,"RF","UOM",j,i)=uomdesc
 	....S ^TMP("PIVA",PID,"RF","OESTAT",j,i)=oestdesc
 	....S ^TMP("PIVA",PID,"RF","PRI",j,i)=pridesc
 	....S ^TMP("PIVA",PID,"RF","SPEC",j,i)=spec
 	....S ^TMP("PIVA",PID,"RF","DOSAGE",j,i)=dosage
 	....S ^TMP("PIVA",PID,"RF","FREQ",j,i)=freqcode
 	....S ^TMP("PIVA",PID,"RF","DURA",j,i)=dura
 	....S ^TMP("PIVA",PID,"RF","INSTRUC",j,i)=instruc
 	....S ^TMP("PIVA",PID,"RF","PRESC",j,i)=presc
 	....S ^TMP("PIVA",PID,"RF","DOCTOR",j,i)=doctor
 	....S ^TMP("PIVA",PID,"RF","STTIME",j,i)=sttime
 	....S ^TMP("PIVA",PID,"RF","SIGN",j,i)=sign
 	....S ^TMP("PIVA",PID,"RF","COMP",j,i)=comp
 	....S ^TMP("PIVA",PID,"RF","NURAUDIT",j,i)=nuraudited
 	....S ^TMP("PIVA",PID,"RF","PASS",j,i)=passre
 	....S ^TMP("PIVA",PID,"RF","MOEORI",j,i)=moeori
 	....S ^TMP("PIVA",PID,"RF","PNO",j,i)=printno			/// 打印单号
 	....S ^TMP("PIVA",PID,"RF","PNUMBER",j,i)=printnumber	/// 打印序号
 	....S ^TMP("PIVA",PID,"RF","PUSER",j,i)=printuser
 	....S ^TMP("PIVA",PID,"RF","PDATE",j,i)=printdate
 	....S ^TMP("PIVA",PID,"RF","PTIME",j,i)=printtime
 	....S ^TMP("PIVA",PID,"RF","POG",j,i)=pog
 	....S ^TMP("PIVA",PID,"RF","STAT",j,i)=cstat
 	....S ^TMP("PIVA",PID,"RF","SPESTAT",j,i)=spestat
 	....S ^TMP("PIVA",PID,"RF","CATDR",j,i)=drugcatdr
 	....S ^TMP("PIVA",PID,"RF","CATDESC",j,i)=drugcatdesc
 	....S ^TMP("PIVA",PID,"RF","AUDIT",j,i)=nuraudited
 	....I '$D(^TMP("PIVA",PID,"RFPNO",moedisp,grpno)) D
 	.....S pno=pno+1
 	.....S ^TMP("PIVA",PID,"RFPNO",moedisp,grpno)=pno
 	....//S ^TMP("PIVA",PID,"RF","AUDIT",j,i)=Audited
	I i>0 S ^TMP("PIVA",PID,"RFSUM")=i_"^"_pno
	Q:i>0 PID
	Q ""
}

ClassMethod GetData(PID As %String, j As %String, i As %String) As %String
{
	N (PID,j,i)
	S stdate=$P(j,"||",1)
	S ward=$P(j,"||",2)
	S bed=$P(j,"||",3)
	S batno=$P(j,"||",4)
	S seqno=$P(j,"||",6)
	S adm=^TMP("PIVA",PID,"RF","ADM",j,i)
	S oeori=^TMP("PIVA",PID,"RF","OEORI",j,i)
	S dodis=^TMP("PIVA",PID,"RF","DODIS",j,i)
	S price=^TMP("PIVA",PID,"RF","PRICE",j,i)
	S grpno=^TMP("PIVA",PID,"RF","GRPNO",j,i)
	S itmdesc=^TMP("PIVA",PID,"RF","ITMNAME",j,i)
 	S ipno=^TMP("PIVA",PID,"RF","IPNO",j,i)
 	S paname=^TMP("PIVA",PID,"RF","PANAME",j,i)
 	S uomdesc=^TMP("PIVA",PID,"RF","UOM",j,i)
 	S qty=^TMP("PIVA",PID,"RF","QTY",j,i)
 	S oestate=^TMP("PIVA",PID,"RF","OESTAT",j,i)
 	S pridesc=^TMP("PIVA",PID,"RF","PRI",j,i)
 	S spec=^TMP("PIVA",PID,"RF","SPEC",j,i)
 	S dosage=^TMP("PIVA",PID,"RF","DOSAGE",j,i)
 	S freqcode=^TMP("PIVA",PID,"RF","FREQ",j,i)
 	S dura=^TMP("PIVA",PID,"RF","DURA",j,i)
 	S instruc=^TMP("PIVA",PID,"RF","INSTRUC",j,i)
 	S presc=^TMP("PIVA",PID,"RF","PRESC",j,i)
 	S doctor=^TMP("PIVA",PID,"RF","DOCTOR",j,i)
 	S sttime=^TMP("PIVA",PID,"RF","STTIME",j,i)
 	S sign=^TMP("PIVA",PID,"RF","SIGN",j,i)
 	S comp=^TMP("PIVA",PID,"RF","COMP",j,i)
 	S nuraudited=^TMP("PIVA",PID,"RF","NURAUDIT",j,i)
 	S passre=^TMP("PIVA",PID,"RF","PASS",j,i)
 	S moeori=^TMP("PIVA",PID,"RF","MOEORI",j,i)
 	S printno=^TMP("PIVA",PID,"RF","PNO",j,i)
 	S printnumber=^TMP("PIVA",PID,"RF","PNUMBER",j,i)
 	S printuser=^TMP("PIVA",PID,"RF","PUSER",j,i)
 	S printdate=^TMP("PIVA",PID,"RF","PDATE",j,i)
 	S printtime=^TMP("PIVA",PID,"RF","PTIME",j,i)
 	S pog=^TMP("PIVA",PID,"RF","POG",j,i)
 	S cstat=^TMP("PIVA",PID,"RF","STAT",j,i)
 	S spestat=^TMP("PIVA",PID,"RF","SPESTAT",j,i)
 	S drugcatdr=^TMP("PIVA",PID,"RF","CATDR",j,i)
 	S drugcatdesc=^TMP("PIVA",PID,"RF","CATDESC",j,i)
 	S Audited=^TMP("PIVA",PID,"RF","AUDIT",j,i)
 	S mdodis=##class(web.DHCSTPIVA).GetMainOEDispID(dodis,grpno)
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
 	S data=$LB(PID,batno,seqno,itmdesc,ipno,bed,paname,freqcode,qty,price,oestate,dosage,spec,instruc,dura,presc,pridesc,doctor,stdate,sttime,comp,sign,dodis,grpno,printnumber,moeori,uomdesc,passre,printno,ward,printuser,printdate,printtime,pog,cstat,spestat,drugcatdr,drugcatdesc,mdodis,Audited,EncryptLevel,PatLevel)
 	Q data
}

ClassMethod GetRecordSum(pid As %String) As %String
{
	Q $G(^TMP("PIVA",pid,"RFSUM"))
}

/// 配液拒绝
ClassMethod SaveRefuse(pog As %String, reasondr As %String) As %String
{
	N (pog,reasondr,%session)
	Q:pog="" -1
	Q:reasondr="" -2
	Q:'$D(^PIVA(pog)) -4
	S puser=##class(web.DHCSTCOMWEB).GetUserID()
	Q:puser="" -5
	q:$p(^PIVA(pog),"^",8)="R" -8
	S ret=0
	S cnumber=70	/// 复核状态
	S psdr=$P(^PIVA(pog),"^",6) /// pog的当前状态
	S pstate=$P(^PIVAS(psdr),"^",1)
	Q:pstate'<cnumber -6	/// 复核过的退出
	//S oeori=$P(^PIVA(pog),"^",1)
	//S oest=##class(web.DHCSTPIVA).GetOeState(oeori)
	//Q:oest="D" -7	/// 停止的医嘱退出
	S dspID=$P(^PIVA(pog),"^",1)
	S OrdExeRowid=$p(^DHCOEDISQTY(dspID),"^",3)
	S ChkOrdState=##class(web.DHCSTCOMMONSRV).GetOrdState(OrdExeRowid)
	q:ChkOrdState'=1 -7	/// 停止的医嘱退出
	L +^PIVA(pog):5 E  Q -100
	TSTART
 	S ret=..UpdPog(pog,puser,"R",reasondr)
 	I ret'=0 TROLLBACK
 	Q:ret'=0 -8
 	L -^PIVA(pog)
 	TCOMMIT
 	Q 0
}

/// 取消配液拒绝
ClassMethod SaveNoRefuse(pog As %String) As %String
{
	N (pog,%session)
	Q:pog="" -1
	Q:'$D(^PIVA(pog)) -4
	S puser=##class(web.DHCSTCOMWEB).GetUserID()
	Q:puser="" -5
	S ret=0
	S cnumber=70	/// 复核状态
	S psdr=$P(^PIVA(pog),"^",6) /// pog的当前状态
	S pstate=$P(^PIVAS(psdr),"^",1)
	Q:pstate'<cnumber -6	/// 复核过的退出
	//S oeori=$P(^PIVA(pog),"^",1)
	//S oest=##class(web.DHCSTPIVA).GetOeState(oeori)
	//Q:oest="D" -7	/// 停止的医嘱退出
	S dspID=$P(^PIVA(pog),"^",1)
	S OrdExeRowid=$p(^DHCOEDISQTY(dspID),"^",3)
	S ChkOrdState=##class(web.DHCSTCOMMONSRV).GetOrdState(OrdExeRowid)
	q:ChkOrdState'=1 -7	/// 停止的医嘱退出
	L +^PIVA(pog):5 E  Q -100
	TSTART
 	S ret=..UpdPog(pog,puser,"N","")
 	I ret'=0 TROLLBACK
 	Q:ret'=0 -8
 	L -^PIVA(pog)
 	TCOMMIT
 	Q 0
}

/// 配液取消
ClassMethod SaveCancel(pog As %String, reasondr As %String) As %String
{
	N (pog,reasondr,%session)
	Q:pog="" -1
	Q:reasondr="" -2
	Q:'$D(^PIVA(pog)) -4
	S puser=##class(web.DHCSTCOMWEB).GetUserID()
	Q:puser="" -5
	S ret=0
	S cnumber=70	/// 复核状态
	S psdr=$P(^PIVA(pog),"^",6) /// pog的当前状态
	S pstate=$P(^PIVAS(psdr),"^",1)
	Q:pstate'<cnumber -6
	//S oeori=$P(^PIVA(pog),"^",1)
	//S oest=##class(web.DHCSTPIVA).GetOeState(oeori)
	//Q:oest="D" -7	/// 停止的医嘱退出
	S dspID=$P(^PIVA(pog),"^",1)
	S OrdExeRowid=$p(^DHCOEDISQTY(dspID),"^",3)
	S ChkOrdState=##class(web.DHCSTCOMMONSRV).GetOrdState(OrdExeRowid)
	q:ChkOrdState'=1 -7	/// 停止的医嘱退出
	L +^PIVA(pog):5 E  Q -100
	TSTART
 	S ret=..UpdPog(pog,puser,"C",reasondr)
 	I ret'=0 TROLLBACK
 	Q:ret'=0 -7
 	L -^PIVA(pog)
 	TCOMMIT
 	Q 0
}

ClassMethod UpdPog(pog As %String, puser As %String, operstate As %String, reasondr As %String) As %String
{
	N (pog,puser,operstate,reasondr)
	K PLIST
	&SQL(Select * Into :PLIST() From PIVA_OrdGrp Where pog_rowid=:pog)
	S PLIST(9)=operstate
	S PLIST(10)=reasondr
	S PLIST(13)=puser
	S PLIST(14)=+$H
	S PLIST(15)=$P($H,",",2)
	&SQL(Update PIVA_OrdGrp Values :PLIST() Where pog_rowid=:pog)
	Q SQLCODE
}

ClassMethod NewPid() As %String
{
 	Q $I(^DHCSTPIVA("COLL"))
}

ClassMethod ClearAllTmp(pid As %String) As %String
{
	D ..CLEARTMP(pid,"RF")
	D ..CLEARTMP(pid,"RFPNO")
	D ..CLEARTMP(pid,"RFSUM")
}

ClassMethod CLEARTMP(pid As %String, PAR As %String) As %String
{
	K ^TMP("PIVA",pid,PAR)
}

}
