Import SQLUser

/// 复核
Class web.DHCSTPIVARECHECK Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
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

/// w ##class(%ResultSet).RunQuery("web.DHCSTPIVARECHECK","Disp")
ClassMethod DispExecute(ByRef qHandle As %Binary, tPLocID As %String, tWardID As %String, tStartDate As %String, tEndDate As %String, tRegNo As %String, tBatNo As %String, tOecprID As %String, tItmID As %String, tPrintNo As %String, tPassAudit As %String, tOrdStDate As %String, tOrdEndDate As %String, tOecType As %String) As %Status
{
	S repid=$I(^CacheTemp)
	S qHandle=$lb(0,repid,0)
	S ind=1
	Q:tPLocID="" $$$OK
	Q:tStartDate="" $$$OK
	Q:tEndDate="" $$$OK
	S PID=""	
	S PID=..CollData(tPLocID, tWardID, tRegNo, tStartDate, tEndDate, tBatNo, tOecprID, tItmID, tPrintNo,tPassAudit,tOrdStDate,tOrdEndDate,tOecType)
	Q:PID="" $$$OK
	S jj=""
	s lipno=""
	s colortype="W"
	F  S jj=$O(^TMP("PIVA",PID,"RC","ADM",jj)) Q:jj=""  D
	.S ii=""
	.F  S ii=$O(^TMP("PIVA",PID,"RC","ADM",jj,ii)) Q:ii=""  D
	..S Data=..GetData(PID,jj,ii,lipno,colortype)
	..S lipno=^TMP("PIVA",PID,"RC","IPNO",jj,ii)
	..s colortype=^TMP("PIVA",PID,"RC","COLOR",jj,ii)
	..///S ^TMP("PIVA",PID,"RC2",ind)=Data
	..S ^CacheTemp(repid,ind)=Data	
 	..S ind=ind+1
 	Q $$$OK
}

Query Disp(tPLocID As %String, tWardID As %String, tStartDate As %String, tEndDate As %String, tRegNo As %String, tBatNo As %String, tOecprID As %String, tItmID As %String, tPrintNo As %String, tPassAudit As %String, tOrdStDate As %String, tOrdEndDate As %String, tOecType As %String) As %Query(ROWSPEC = "tbPID:%String,tbBatNo:%String,tbSeqNo:%String,tbItmDesc:%String,tbRegNo:%String,tbBedNo:%String,tbName:%String,tbFreq:%String,tbQty:%String,tbPrice:%String,tbOeStatus:%String,tbDosage:%String,tbSpec:%String,tbInst:%String,tbDura:%String,tbPresc:%String,tbOecpr:%String,tbDoctor:%String,tbOexeDate:%String,tbOexeTime:%String,tbCompare:%String,tbSign:%String,tbDSP:%String,tbGrpNo:%String,tbPrintNum:%String,tbMOeori:%String,tbUom:%String,tbPassResult:%String,tbPrintNo:%String,tbWard:%String,tbPUser:%String,tbPDate:%String,tbPTime:%String,tbPogID:%String,tbState:%String,tbSpecStat:%String,tdrugcatdr:%String,tdrugcatdesc:%String,tbMdodis:%String,tbColorType:%String,TEncryptLevel:%String,TPatLevel:%String,tbNurAudit:%String")
{
}

ClassMethod CollData(tPLocID As %String, tWardID As %String, tRegNo As %String, tStartDate As %String, tEndDate As %String, tBatNo As %String, tOecprID As %String, tItmID As %String, tPrintNo As %String, tPassAudit As %String, tOrdStDate As %String, tOrdEndDate As %String, tOecType As %String) As %Integer
{
	N (tPLocID, tWardID, tRegNo, tStartDate, tEndDate, tBatNo, tOecprID, tItmID, tPrintNo,tPassAudit,tOrdStDate,tOrdEndDate,tOecType)
	Q:tPLocID="" ""
	Q:tStartDate="" ""
	Q:tEndDate="" ""
	S cnumber=60	/// 当前状态号
	s pstype="I"
	S PID=..NewPid()
	D ..ClearAllTmp(PID)
	s HospID=$p($g(^CTLOC(tPLocID)),"^",22)
	//S ^TMP("PIVA",PID,"CM")=tPLocID_"^"_tWardID_"^"_tStartDate_"^"_tEndDate
	S i=0,pno=0
	s LastMainOrd=""
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
	...//s ^lq(moeori)=tOecprID_"^"_pridr
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
	...q:ChkOrdState'=1
	...q:##class(web.DHCSTCOMMONSRV).IfAuditByPriority(moedisp)=0  ;需要审核但是配药记录未审核则不发药
	...q:##class(web.DHCSTPCHCOLLS2).HaveBeenRefused(moedisp)>0   ; 拒发药控制
 	.../// 特殊状态,已经取消或拒绝的去掉
 	...S spestat=$P(pdata,"^",8)
 	...Q:spestat'="N"
 	...///当前配药状态
 	...S cstat=##class(web.DHCSTPIVA).GetPSName(pog)
 	...///下一个配药状态
 	...S psdr=$P(pdata,"^",6)
 	...S nextstr=##class(web.DHCSTPIVA).GetNextStat(psdr,tPLocID,pstype)
 	...S nextnumber=$P(nextstr,"^",2)
 	...Q:nextnumber'=cnumber
 	...i LastMainOrd'=moeori d
	....s ptypestr=##class(web.DHCSTPIVA).GetAuditedType(moeori)
	....s typeID=$p(ptypestr,"^",1)
	...Q:(tOecType'="")&(tOecType'=$g(typeID))
	...s LastMainOrd=moeori
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
	...I '$D(^TMP("PIVA",PID,"RCPNO",moedisp,grpno)) D
 	....S pno=pno+1
 	....S ^TMP("PIVA",PID,"RCPNO",moedisp,grpno)=pno
	...///
	...S pogsub=""
	...F  S pogsub=$O(^PIVA(pog,"I",pogsub)) Q:pogsub=""  D
	....S dodis=$P(^PIVA(pog,"I",pogsub),"^",1)
	....Q:dodis=""
	....Q:'$D(^DHCOEDISQTY(dodis))
 	....S dspstatus=$p(^DHCOEDISQTY(dodis),"^",7)
 	....Q:dspstatus'="TC"	/// 已经确认
 	....S oeori=$p(^DHCOEDISQTY(dodis),"^",1)
 	....S ord=$P(oeori,"||",1)
 	....S chl=$P(oeori,"||",2)
 	....//s OrdExeRowid=$p(^DHCOEDISQTY(dodis),"^",3)
    ....//S ChkOrdState=##class(web.DHCSTCOMMONSRV).GetOrdState(OrdExeRowid)
    ....//q:ChkOrdState'=1
 	....//S oestate=##class(web.DHCSTPIVA).GetOeState(oeori)
	....//S oestcode=$P(oestate,"^",1)
 	....//Q:(oestcode'="V")&(oestcode'="E")	/// 去掉停止的医嘱
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
 	....//S nuraudited=##class(web.DHCSTPIVA).IfAuditByPriority(oeori,pridr)	/// 是否护士审核
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
 	....S ^TMP("PIVA",PID,"RC","ADM",j,i)=adm
 	....S ^TMP("PIVA",PID,"RC","OEORI",j,i)=oeori
 	....S ^TMP("PIVA",PID,"RC","DODIS",j,i)=dodis
 	....S ^TMP("PIVA",PID,"RC","PRICE",j,i)=price ;_"**"_moeori_"**"_pog
 	....S ^TMP("PIVA",PID,"RC","GRPNO",j,i)=grpno
 	....S ^TMP("PIVA",PID,"RC","ITMNAME",j,i)=itmdesc
 	....S ^TMP("PIVA",PID,"RC","IPNO",j,i)=ipno
 	....S ^TMP("PIVA",PID,"RC","PANAME",j,i)=paname
 	....S ^TMP("PIVA",PID,"RC","QTY",j,i)=qty
 	....S ^TMP("PIVA",PID,"RC","UOM",j,i)=uomdesc
 	....S ^TMP("PIVA",PID,"RC","OESTAT",j,i)=oestdesc
 	....S ^TMP("PIVA",PID,"RC","PRI",j,i)=pridesc
 	....S ^TMP("PIVA",PID,"RC","SPEC",j,i)=spec
 	....S ^TMP("PIVA",PID,"RC","DOSAGE",j,i)=dosage
 	....S ^TMP("PIVA",PID,"RC","FREQ",j,i)=freqcode
 	....S ^TMP("PIVA",PID,"RC","DURA",j,i)=dura
 	....S ^TMP("PIVA",PID,"RC","INSTRUC",j,i)=instruc
 	....S ^TMP("PIVA",PID,"RC","PRESC",j,i)=presc
 	....S ^TMP("PIVA",PID,"RC","DOCTOR",j,i)=doctor
 	....S ^TMP("PIVA",PID,"RC","STTIME",j,i)=sttime
 	....S ^TMP("PIVA",PID,"RC","SIGN",j,i)=sign
 	....S ^TMP("PIVA",PID,"RC","COMP",j,i)=comp
 	....S ^TMP("PIVA",PID,"RC","NURAUDIT",j,i)=nuraudited
 	....S ^TMP("PIVA",PID,"RC","PASS",j,i)=passre
 	....S ^TMP("PIVA",PID,"RC","MOEORI",j,i)=moeori
 	....S ^TMP("PIVA",PID,"RC","PNO",j,i)=printno			/// 打印单号
 	....S ^TMP("PIVA",PID,"RC","PNUMBER",j,i)=printnumber	/// 打印序号
 	....S ^TMP("PIVA",PID,"RC","PUSER",j,i)=printuser
 	....S ^TMP("PIVA",PID,"RC","PDATE",j,i)=printdate
 	....S ^TMP("PIVA",PID,"RC","PTIME",j,i)=printtime
 	....S ^TMP("PIVA",PID,"RC","POG",j,i)=pog
 	....S ^TMP("PIVA",PID,"RC","STAT",j,i)=cstat
 	....S ^TMP("PIVA",PID,"RC","SPESTAT",j,i)=spestat
 	....S ^TMP("PIVA",PID,"RC","CATDR",j,i)=drugcatdr
 	....S ^TMP("PIVA",PID,"RC","CATDESC",j,i)=drugcatdesc
	I i>0 S ^TMP("PIVA",PID,"RCSUM")=i_"^"_pno
	Q:i>0 PID
	Q ""
}

ClassMethod GetData(PID As %String, j As %String, i As %String, lipno As %String, patcolor As %String) As %String
{
	N (PID,j,i,lipno,patcolor)
	S stdate=$P(j,"||",1)
	S ward=$P(j,"||",2)
	S bed=$P(j,"||",3)
	S batno=$P(j,"||",4)
	S seqno=$P(j,"||",6)
	S adm=^TMP("PIVA",PID,"RC","ADM",j,i)
	S oeori=^TMP("PIVA",PID,"RC","OEORI",j,i)
	S dodis=^TMP("PIVA",PID,"RC","DODIS",j,i)
	S price=^TMP("PIVA",PID,"RC","PRICE",j,i)
	S grpno=^TMP("PIVA",PID,"RC","GRPNO",j,i)
	S itmdesc=^TMP("PIVA",PID,"RC","ITMNAME",j,i)
 	S ipno=^TMP("PIVA",PID,"RC","IPNO",j,i)
 	S paname=^TMP("PIVA",PID,"RC","PANAME",j,i)
 	S uomdesc=^TMP("PIVA",PID,"RC","UOM",j,i)
 	S qty=^TMP("PIVA",PID,"RC","QTY",j,i)
 	S oestate=^TMP("PIVA",PID,"RC","OESTAT",j,i)
 	S pridesc=^TMP("PIVA",PID,"RC","PRI",j,i)
 	S spec=^TMP("PIVA",PID,"RC","SPEC",j,i)
 	S dosage=^TMP("PIVA",PID,"RC","DOSAGE",j,i)
 	S freqcode=^TMP("PIVA",PID,"RC","FREQ",j,i)
 	S dura=^TMP("PIVA",PID,"RC","DURA",j,i)
 	S instruc=^TMP("PIVA",PID,"RC","INSTRUC",j,i)
 	S presc=^TMP("PIVA",PID,"RC","PRESC",j,i)
 	S doctor=^TMP("PIVA",PID,"RC","DOCTOR",j,i)
 	S sttime=^TMP("PIVA",PID,"RC","STTIME",j,i)
 	S sign=^TMP("PIVA",PID,"RC","SIGN",j,i)
 	S comp=^TMP("PIVA",PID,"RC","COMP",j,i)
 	S nuraudited=^TMP("PIVA",PID,"RC","NURAUDIT",j,i)
 	S passre=^TMP("PIVA",PID,"RC","PASS",j,i)
 	S moeori=^TMP("PIVA",PID,"RC","MOEORI",j,i)
 	S printno=^TMP("PIVA",PID,"RC","PNO",j,i)
 	S printnumber=^TMP("PIVA",PID,"RC","PNUMBER",j,i)
 	S printuser=^TMP("PIVA",PID,"RC","PUSER",j,i)
 	S printdate=^TMP("PIVA",PID,"RC","PDATE",j,i)
 	S printtime=^TMP("PIVA",PID,"RC","PTIME",j,i)
 	S pog=^TMP("PIVA",PID,"RC","POG",j,i)
 	S cstat=^TMP("PIVA",PID,"RC","STAT",j,i)
 	S spestat=^TMP("PIVA",PID,"RC","SPESTAT",j,i)
 	S drugcatdr=^TMP("PIVA",PID,"RC","CATDR",j,i)
 	S drugcatdesc=^TMP("PIVA",PID,"RC","CATDESC",j,i)
 	S mdodis=##class(web.DHCSTPIVA).GetMainOEDispID(dodis,grpno)
 	s colortypeStr=##class(web.DHCSTPIVA).GetColorType(ipno,lipno,oestate,passre,patcolor,spestat)
 	s colortype=$p(colortypeStr,"^",1)
 	s patcolor=$p(colortypeStr,"^",2)
 	s ^TMP("PIVA",PID,"RC","COLOR",j,i)=patcolor
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
 	S data=$LB(PID,batno,seqno,itmdesc,ipno,bed,paname,freqcode,qty,price,oestate,dosage,spec,instruc,dura,presc,pridesc,doctor,stdate,sttime,comp,sign,dodis,grpno,printnumber,moeori,uomdesc,passre,printno,ward,printuser,printdate,printtime,pog,cstat,spestat,drugcatdr,drugcatdesc,mdodis,colortype,EncryptLevel,PatLevel,nuraudited)
 	Q data
}

ClassMethod GetRecordSum(pid As %String) As %String
{
	Q $G(^TMP("PIVA",pid,"RCSUM"))
}

/// 复核通过,1-更新 PIVA_OrdGrp ,2-插入 PIVA_OrdGrpState ,3-更新DHC_PHACollected,插入DHC_PHACollectItm ,4-库存处理
/// w ##class(web.DHCSTPIVARECHECK).SaveCheckOK(181544,128721,60)
ClassMethod SaveCheckOK(pid As %String, pog As %String, psnumber) As %String
{
	N (pid,pog,psnumber,%session)
	Q:pid="" -2
	Q:pog="" -3
	Q:'$D(^PIVA(pog)) -4
	S puser=##class(web.DHCSTCOMWEB).GetUserID()
	Q:puser="" -5
	S phac=$P(^PIVA(pog),"^",10)
 	Q:phac="" -6
 	S plocdr=$P(^PIVA(pog),"^",7) 
 	S dispconfig=##class(web.DHCSTPIVA).GetPSNumberProByLoc(plocdr,psnumber)
 	Q:dispconfig'="Y" -101
	L +^PIVA(pog):30  E  Q -100
	s pstype="I"
	s locid=$g(%session.Data("LOGON.CTLOCID"))
 	s HospID=""
 	i locid'="" d
 	.s HospID=$p($g(^CTLOC(locid)),"^",22)
	s RuleFlag=##Class(web.DHCSTCOMMPARA).GetRpRule(HospID)	//进价规则
	TSTART
	s itmcount=0   ////2015-03-04 ws
	S quitflag=0
	I '$D(^TMP("PIVA",pid,"RCSAVE",pog)) D
	.S ^TMP("PIVA",pid,"RCSAVE",pog)=""
	.S cnumber=psnumber //复核状态
	.S ps=##class(web.DHCSTPIVA).GetPivaStateId(locid,"I",cnumber)
 	.I ps="" S quitflag=1
 	.Q:quitflag'=0
	.S psdr=$P(^PIVA(pog),"^",6) /// pog的当前状态
	.S nextstr=##class(web.DHCSTPIVA).GetNextStat(psdr,locid,pstype)
 	.S nextnumber=$P(nextstr,"^",2)
 	.S plocdr=$P(^PIVA(pog),"^",7) 
 	.I (nextnumber'=cnumber)&(cnumber'=10) S quitflag=2   ///如果是打签计费则忽略
 	.Q:quitflag'=0	/// 不应该进行此状态
 	.S ret=..UpdPog(pog,ps,puser)	//1 处理 PIVA_OrdGrp系列表
 	.I ret'=0 S quitflag=3
 	.Q:quitflag'=0
 	.S ret=..InsOrder(pog,puser,pid)	/// 插入注射器医嘱
 	.I ret'=0 S quitflag=4
 	.Q:quitflag'=0
 	.S sub=0,err=0
 	.s itmcount=0   ////2015-03-04 ws
 	.F  S sub=$O(^PIVA(pog,"I",sub)) Q:(sub="")!(sub=0)!(quitflag'=0)  D
 	..S dsp=$P(^PIVA(pog,"I",sub),"^",1)
 	..Q:dsp=""
 	..Q:'$D(^DHCOEDISQTY(dsp))
 	..s oeori=$P(^DHCOEDISQTY(dsp),"^",1)
	..Q:oeori=""
	..S pri=##class(web.DHCSTPIVA).GetOePriority(oeori)
	..S pricode=$P(pri,"^",2)
	..S pricode=$ZCVT(pricode,"U")
	..s itmcount=itmcount+1  ////2015-03-04 ws
	..Q:##class(web.DHCSTCOMMONSRV).ChkOrdPriority(oeori)=0
	..S OrdExeRowid=$p(^DHCOEDISQTY(dsp),"^",3)
	..//S oestate=##class(web.DHCSTPIVA).GetOeState(oeori)
	..S oestate=##class(web.DHCSTPIVA).GetOrdExeState(OrdExeRowid)
	..S oestcode=$P(oestate,"^",1)
	..S ChkOrdState=##class(web.DHCSTCOMMONSRV).GetOrdState(OrdExeRowid)
	..I ChkOrdState=0 D
	...S ^DHCSTTMP("SAVECHECK",dsp)=oestcode
	...s quitflag=9	    //zhouyg 20110711
 	..Q:quitflag'=0	/// 去掉停止的医嘱
 	..//S err=..Dispensing(phac,dsp,puser)
 	..i RuleFlag=3 d
 	...S err=##class(web.DHCSTPCHCOLLS).DispensingByBatch(phac,dsp,oeori)
 	..e  d
 	...S err=##class(web.DHCSTPCHCOLLS).Dispensing(phac,dsp,oeori) //2 处理发药及库存系列表
 	..I err="" S quitflag=8
 	..//I err>0 S quitflag=5
 	..I err'=0 S quitflag=5
 	..I err=9 S quitflag=6
 	..I err=4 S quitflag=7
 	..i err=7 S quitflag=6
 	//更新发药表状态
 	I quitflag=0 D
 	.S err=..UpdPhac(phac,puser)
 	.I err'=0 S quitflag=8
 	S incdesc=$g(^tmp("DHCSTPIVANOQTY"))
 	i itmcount=0 d  ////2015-03-04 ws
 	.TROLLBACK      ////2015-03-04 ws
 	.L -^PIVA(pog)  ////2015-03-04 ws
 	q:itmcount=0 -16  ////2015-03-04 ws
 	I quitflag'=0 TROLLBACK
 	
 	L -^PIVA(pog)
 	
 	S ^tmp("DHCSTPIVANOQTY")=incdesc
 	Q:quitflag=1 -7
 	Q:quitflag=2 -8
 	Q:quitflag=3 -9
	Q:quitflag=4 -10
	Q:quitflag=5 -11
	Q:quitflag=6 -12
	Q:quitflag=7 -13
	Q:quitflag=8 -14
	Q:quitflag=9 -15
	Q:quitflag'=0 -99
 	TCOMMIT
 	s ret=..MakeBill(pog) //账单,yunhaibao21060112
 	Q 0
}

ClassMethod UpdPhac(phacrowid, puser) As %String
{
	N (phacrowid,puser)
	K PLIST
	&SQL(Select * Into :PLIST() From DHC_PHACollected Where DHC_PHACollect_RowID=:phacrowid)
	S PLIST(3)=+$H
	S PLIST(4)=$P($H,",",2)
	S PLIST(7)="Collect"
	S PLIST(14)=puser
	&SQL(Update DHC_PHACollected Values :PLIST() Where DHC_PHACollect_RowID=:phacrowid)
	Q SQLCODE
}

ClassMethod GetNoQtyItmDesc() As %String
{
	Q $G(^tmp("DHCSTPIVANOQTY"))
}

ClassMethod Dispensing(phac As %String, dhcoedis As %String, puser As %String) As %String
{
 
 ;根据dhc_oedispensing记录处理发药
 ;1 找批次
 ;2 生成发药记录
 ;3 处理该发药记录的库存
 ;3.1 处理INC_ItmLcBt和INC_ItmLoc
 ;3.2 处理dhc_locdailytotal,dhc_locbtdailytotal,dhc_intrans
 N (phac,dhcoedis,puser)
 s status=$p(^DHCOEDISQTY(dhcoedis),"^",7) q:status'="TC" "" ;并非发药状态时退出
 s oeori=$p(^DHCOEDISQTY(dhcoedis),"^",1) q:oeori="" ""
 s confqty=$p(^DHCOEDISQTY(dhcoedis),"^",11) q:confqty'>0 ""
 s ord=$p(oeori,"||",1),itm=$p(oeori,"||",2)
 q:'$d(^OEORD(ord,"I",itm)) ""
 s ordstatus=$p(^OEC("OSTAT",$p(^OEORD(ord,"I",itm,1),"^",13)),"^",1)          ;医嘱核实、未核实、停止状态
 q:ordstatus="D" ""     ;医嘱已停
 s arcim=$p(^OEORD(ord,"I",itm,1),"^",2) q:arcim="" ""
 s recloc=$p(^OEORD(ord,"I",itm,3),"^",6) q:recloc="" ""
 s inci=$o(^INCI(0,"ARCIM_DR",$p(arcim,"||",1),"")) q:inci="" ""
 s ch=$o(^INCI("IL_LOC",recloc,inci,"")) q:ch="" ""
 s incil=inci_"||"_ch
 l +^DHCOEDISPENSING(dhcoedis):5  e  q -100   ;加锁
 s status=$p(^DHCOEDISQTY(dhcoedis),"^",7)
 i status'="TC" l -^DHCOEDISPENSING(dhcoedis) q -102 ;并非发药状态时退出(再次判断)
 s ordstatus=$p(^OEC("OSTAT",$p(^OEORD(ord,"I",itm,1),"^",13)),"^",1)          ;医嘱核实、未核实、停止状态
 i ordstatus="D"  l -^DHCOEDISPENSING(dhcoedis)  q -103     ;医嘱已停(再次判断)
 s incdesc=$P(^INCI(inci,1),"^",2)
 ;
 s err=0
 s pid=..GetInclbCounter(recloc,inci)
 i pid<0 d Unlock
 q:pid<0 -104
 ;s cnt=$$SelClbQty(incil,confqty)
 s cnt=##CLASS(web.DHCSTSTKQTY).GetInclbQty(inci,confqty,recloc,pid) 
 i cnt>0 d  ;数量够用
 . ///tstart
 . S ret=$$UpdPhac(phac,puser) /// 0 更新DHC_PHACollected
 . I ret'=0 S err=7
 . Q:ret'=0
 . ;f i=1:1:cnt q:err>0  d
 . s newclb=""
 . f  s newclb=$o(^TMPGETINCLB(pid,newclb)) q:(newclb="")!(err>0)  d
 . . ;s inclb=xINCLB(i)
 . . ;s qty=xQTY(i)
 . . s inclb=newclb
 . . s qty=$p(^TMPGETINCLB(pid,newclb),"^",1)
 . . s phaci=$$InsPhacItm(phac,ord,itm,inclb,qty,dhcoedis) ;生成发药记录
 . . i phaci="" s err=1  
 . . q:phaci="" 
 . . s ret=..HandlePhaResQty(phaci)
 . . i ret<0 s err=2 
 . . q:ret<0
 . . s resultstk=##class(web.DHCSTPCHCOLLS2).DhcStkTab(phaci)
 . . ;s resultstk=..DhcStkTab(phaci,puser)  ;处理该笔发药记录的台帐库存
 . . i resultstk<0 s err=3 
 . . q:resultstk<0
 . . ;
 . . ;s ret=##class(web.DHCST01).UPDINV1(inclb,-qty)  ;处理该笔发药批次和总库存
 . . ;i ret=0 s err=4
 . . ;S:ret=0 ^TMP("PIVA","UPDINV",phac,dhcoedis,inclb)=qty
 . . ;q:ret=0
 . . ;修改dhc_oedispensing的字段内容
 . . s dd=$p(^DHCPHAC(phac),"^",2)
 . . S tt=$p(^DHCPHAC(phac),"^",3)  ;日期、时间
 . . s user=$p(^DHCPHAC(phac),"^",13)
 . . s type="P"
 . . s pointer=phaci
 . . s formerPointer=$p(^DHCOEDISQTY(dhcoedis),"^",14)
 . . i formerPointer'="" s pointer=formerPointer_","_pointer
 . . &sql(update DHC_OEDispensing set dsp_status='C',dsp_date=:dd,dsp_time=:tt,
     dsp_user=:user,dsp_type=:type,dsp_pointer=:pointer where dsp_rowid=:dhcoedis)
 . . i SQLCODE s err=5
 . . Q:SQLCODE
 . . ;消掉保留数量(INC_ItmLoc.INCIL_ReservedQty)
 . . s ret=##class(web.DHCST01).UPDINVRESQTY(inci,recloc,-qty)
 . . i ret<0  s err=6 
 . . q:ret<0
 . S:err>0 ^TMP("PIVA","DSP",dhcoedis)=phac_"^"_dhcoedis
 . q:err>0
 . ;&SQL(Update OE_OrdItem Set OEORI_Billed='TB' Where OEORI_Rowid=:oeori)
 . ;I SQLCODE s err=8
 . ;I SQLCODE s ^TMP("PIVA","TB",oeori)=SQLCODE
 E  D
 .S err=9  ;即库存不够的情况
 .s ^tmp("DHCSTPIVANOQTY")=incdesc
 ;l -^DHCINCIL(incil)   ;incil去锁
 ;l -^DHCOEDISPENSING(dhcoedis)  ;去锁
 d Unlock
 q err
 
SelClbQty(incil, dspqty)
 ;按照发药数选择批次,PDELIM="!"
 n cnum,i,sumdqty,clbqty,k
 l +^DHCINCIL(incil):10  e  q 0
 s cnum=$$GetClbQtyObExp(incil)
 i cnum=0  l -^DHCINCIL(incil) q 0  
 s k=0
 s sumdqty=0
 s clbqty=dspqty
 k xINCLB,xQTY
 f i=1:1:cnum q:clbqty'>0   d
 . i Eqty(i)'<clbqty d
 . .s k=k+1
 . .s xINCLB(k)=CLB(i)
 . .s xQTY(k)=clbqty
 . .s clbqty=clbqty-xQTY(k)
 . .s sumdqty=$g(sumdqty)+xQTY(k)
 . e  d
 . .s k=k+1
 . .s xINCLB(k)=CLB(i)
 . .s xQTY(k)=Eqty(i)
 . .s clbqty=clbqty-xQTY(k)
 . .s sumdqty=$g(sumdqty)+xQTY(k)
 i sumdqty<dspqty q 0  //当所查到的可发批次库存之和<发药总数量,不予发药 2008-07-16
 q k
GetClbQtyObExp(incil) 
 ;INCLB按效期排序
 n num,tclb,tqty
 k CLB,Eqty 
 &sql(DECLARE CurrExp CURSOR FOR
 SELECT INCLB_ROWID,INCLB_PHYQTY-nvl(INCLB_DirtyQty,0) FROM INC_ITMLCBT 
 WHERE INCLB_INCIL_PARREF=:incil order by INCLB_INCIB_DR->INCIB_EXPDATE )
 &sql(open CurrExp)
 s num=0
 f  &sql(fetch CurrExp INTO :tclb,:tqty) q:SQLCODE  d                                                                            
 .;s tqty=$$CurQtyINCLB^DHCSTSTKQTY(tclb)
 .;s tqty=$$CuyInclbAvaQty^DHCSTSTKQTY(tclb,"")
 .i tqty>0 d
 ..s num=num+1
 ..s CLB(num)=tclb
 ..s Eqty(num)=tqty
 &sql(close CurrExp)
 q num
InsPhacItm(phacrowid,ord,itm,inclb,qty,dhcoedis) 
 n (phacrowid,ord,itm,inclb,qty,dhcoedis)
 s phaciadm=$P(^OEORD(ord),"^",1) ;adm_dr
 s phacipresc=$p(^OEORD(ord,"I",itm,1),"^",14)   ;处方号
 s phaciinci=inclb
 s PhcLocID=$p($g(^DHCPHAC(phacrowid)),"^",1)
 s CustStr=##Class(web.DHCSTCOMMO).GetLocCust(PhcLocID)
 s HospID=$p(CustStr,"^",5)
 s CustID=$p(CustStr,"^",1)
 s exStr=ord_"||"_itm_"^"_dhcoedis
 S price=##class(web.DHCSTPRICE).GetSp(phaciinci,+$h,"",HospID,"",exStr)
 //s phaciprice=##class(web.DHCSTCOMMONSRV).GetPriceElse(+phaciinci,+$h,"",HospID)
 s phacistatus=$p(^OEC("OSTAT",$p(^OEORD(ord,"I",itm,1),"^",13)),"^",1)
 s phaciloc=$p(^PAADM(phaciadm),"^",4)   ;admloc
 s phacibed=$p(^PAADM(phaciadm),"^",4)  ;bedno
 s phaciqty=qty   ;发药数
 s j=$o(^DHCPHAC(phacrowid,"I",""),-1)+1   ;child sub
 s bedid=$p(^PAADM(phaciadm),"^",73)                                             ;PA_Beds RowId
 i bedid="" s phacibed=""
 e  s phacibed=$p(^PAWARD($p(bedid,"||",1),"BED",$p(bedid,"||",2)),"^",1)        ;病人床号
 s SpAmt=phaciprice*phaciqty
 S CatGrpStr=##Class(web.DHCSTCOMINC).GetIncStkCatGrp(+phaciinci)
 S StkTypeDesc=$P(CatGrpStr,"^",4)
 S Perv="^^^"_StkTypeDesc_"^"_CustID_"^DHC"
 s SpAmt=##Class(web.DHCSTCOMMPARA).GetNumbDec(SpAmt,Perv,"FmtSA",1)
 s PLIST(0)=$g(phacrowid)
 s PLIST(2)=$g(phaciadm)
 s PLIST(3)=$g(phacipresc)
 s PLIST(4)=$g(phaciinci)
 s PLIST(5)=$g(phaciqty)
 s PLIST(6)=ord_"||"_itm      ;$g(phacidis)   ;oe_orditem
 s PLIST(7)=j
 s PLIST(10)=$g(phacibed)
 s PLIST(11)=$g(phaciprice)
 s PLIST(12)=$g(phacistatus)
 s PLIST(13)=$g(phaciloc)
 s PLIST(15)=$g(dhcoedis)
 s PLIST(17)=+SpAmt
 &sql(INSERT INTO DHC_PHACollectItm VALUES PLIST())
 q:SQLCODE ""
 q %ROWID
 
UpdPhac(phacrowid,puser)
	N (phacrowid,puser)
	K PLIST
	&SQL(Select * Into :PLIST() From DHC_PHACollected Where DHC_PHACollect_RowID=:phacrowid)
	S PLIST(3)=+$H
	S PLIST(4)=$P($H,",",2)
	S PLIST(7)="Collect"
	S PLIST(14)=puser
	&SQL(Update DHC_PHACollected Values :PLIST() Where DHC_PHACollect_RowID=:phacrowid)
	Q SQLCODE
	
Unlock
	;l -^DHCINCIL(incil)   ;incil去锁
	l -^DHCINCIL(recloc,inci)
	l -^DHCOEDISPENSING(dhcoedis)  ;去锁
	k ^TMPGETINCLB(pid)
	Q
}

ClassMethod HandlePhaResQty(phaci As %String) As %String
{
	N (phaci)
 	s phac=$P(phaci,"||",1)
 	s ch=$p(phaci,"||",2)
 	s ward=$p(^DHCPHAC(phac),"^",4)
 	q:ward="" ""
 	s wardloc=$p(^PAWARD(ward),"^",5  )
 	q:wardloc="" ""
 	s phaloc=$p(^DHCPHAC(phac),"^",1)
 	s qty=$p(^DHCPHAC(phac,"I",ch),"^",6)
 	s inci=+$p(^DHCPHAC(phac,"I",ch),"^",4)
 	s pres=$o(^DHCPRES(0,"LOCINCIWARD",phaloc,inci,ward,"")  )	
 	q:pres="" ""
 	s resqty=$p(^DHCPRES(pres),"^",4)
 	;
 	i resqty>qty d
 	.s $p(^DHCPHAC(phac,"I",ch),"^",12)=qty
 	.s newResqty=resqty-qty
 	e  d
 	.s $p(^DHCPHAC(phac,"I",ch),"^",12)=resqty
 	.s newResqty=0
 	;
 	s $p(^DHCPRES(pres),"^",4)=newResqty
 	q 1
}

ClassMethod DhcStkTab(phaci As %String, puser As %String) As %String
{
	;Insert into DHC_Intrans accroding to rowid of Dhc_Phacollectitm
	n (phaci,puser)
	s pha=$p(phaci,"||",1)
	s ch=$p(phaci,"||",2)   
	q:pha="" -20
	q:ch="" -21
	q:'$d(^DHCPHAC(pha)) -22
	q:'$d(^DHCPHAC(pha,"I",ch)) -23
	s inclb=$p(^DHCPHAC(pha,"I",ch),"^",4)
	Q:'$D(^INCI(+inclb,1)) -25
	s buom=$p(^INCI(+inclb,1),"^",10)
	q:buom="" -26
	S dspno=$p(^DHCPHAC(pha),"^",14)
	s qty=+$p(^DHCPHAC(pha,"I",ch),"^",6)
	s qty=-qty 			 ;the qty must be negative
	s sprice=+$p(^DHCPHAC(pha,"I",ch),"^",9)
	S lstr="P"_"^"_dspno_"^"_inclb_"^"_qty_"^"_buom_"^"_sprice_"^"_puser_"^"_phaci
	S ret=##class(web.DHCSTLOCDTOTAL).UpdQtyAndTrans(lstr)
	Q ret
}

/// 复核不通过,1-更新 PIVA_OrdGrp ,2-插入 PIVA_OrdGrpState
ClassMethod SaveCheckNo(pog As %String) As %String
{
	N (pog,%session)
	Q:pog="" -1
	Q:'$D(^PIVA(pog)) -2
	S cnumber=70	/// 复核状态
	S number=5		/// 复核不通过
	s pstype="I"
	s locid=%session.Data("LOGON.CTLOCID")
	S psdr=$P(^PIVA(pog),"^",6)
	S nextstr=##class(web.DHCSTPIVA).GetNextStat(psdr,locid,pstype)
 	S nextnumber=$P(nextstr,"^",2)
 	Q:nextnumber'=cnumber -3
	S ps=##class(web.DHCSTPIVA).GetPivaStateId(locid,"I",number)
	Q:ps="" -4
	S puser=##class(web.DHCSTCOMWEB).GetUserID()
	Q:puser="" -5
	L +^DHCSTLOCK("PIVARC",pog):10 E  Q -100
	TSTART
	S ret=..UpdPog(pog,ps,puser)	//1 
	I ret'=0 TROLLBACK
	I ret'=0 L -^DHCSTLOCK("PIVARC",pog)
	Q:ret'=0 -6
	TCOMMIT
	L -^DHCSTLOCK("PIVARC",pog)
	Q 0
}

ClassMethod UpdPog(pog As %String, ps As %String, puser As %String) As %String
{
	N (pog,ps,puser)
	K PLIST
	&SQL(Select * Into :PLIST() From PIVA_OrdGrp Where pog_rowid=:pog)
	S PLIST(7)=ps
	&SQL(Update PIVA_OrdGrp Values :PLIST() Where pog_rowid=:pog)
	Q:SQLCODE -1
	S ret=..InsOrdGrpState(pog,puser,ps)
	Q ret
}

/// parref + 状态 = 唯一记录
ClassMethod InsOrdGrpState(parref As %String, user As %String, ps As %String) As %String
{
	N (parref,user,ps)
	Q:parref="" -1
	Q:user="" -2
	Q:ps="" -3
	q:$d(^PIVA(0,"PS",ps,parref)) 0 
	//S pogs=..GetOrdGrpStateID(parref,psdr)
	//Q:pogs'="" pogs
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

/// w ##class(web.DHCSTPIVARECHECK).InsOrder(100000031,711,174972)
ClassMethod InsOrder(pog, user, pid) As %String
{
	N (pog,user,pid)
	q 0
	S dspid=$P(^PIVA(pog),"^",1)
	s oeori=$p(^DHCOEDISQTY(dspid),"^",1)
	S ord=$P(oeori,"||",1)
	S itm=$P(oeori,"||",2)
	s priority=$p(^OECPR($p(^OEORD(ord,"I",itm,1),"^",8)),"^",1) ;
	Q:priority="ONE" 0 //取药嘱则不加收费用
	S recdeptdr=$P(^OEORD(ord,"I",itm,3),"^",6)
	S admid=$P(^OEORD(ord),"^",1)
	S admreason=$P($g(^PAADM(admid,1)),"^",7)
	S admdept=$P(^PAADM(admid),"^",70)
	///s retstr=..GetOrdLink(oeori,pid)
	s retstr=##class(web.DHCSTPIVA).GetPivaOrdLink(oeori)
	q:retstr="" 0 
	s OrderPriorRowid=$o(^OECPR(0,"Code","NORM",""))
	s cnt=$l(retstr,"^")
	s exit=0
	f piv=1:1:cnt d
	.q:exit=-1
	.S onestr=$p(retstr,"^",piv)
	.S arcimid=$p(onestr,"@",1)
	.s qty=$p(onestr,"@",2)
	.s ArcSubs=$p(arcimid,"||",1)
	.s ArcVer=$p(arcimid,"||",2)
	.s ItemCat=$p(^ARCIM(ArcSubs,ArcVer,1),"^",10)
	.s OrderType=""
	.i ItemCat'="" s OrderType=$p($g(^ARC("IC",ItemCat)),"^",7)
	.s OrderStartDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(+$h,"PIVA")
	.s OrderStartTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml($p($h,",",2),"PIVA")
	.s OrderRecDepRowid=recdeptdr
	.s BillTypeRowid=admreason
	.s OrderSeqNo=piv
	.s OrderPackQty=qty
	.Set OrderItemStr=arcimid_"^"_OrderType_"^"_OrderPriorRowid_"^"_OrderStartDate_"^"_OrderStartTime_"^"_OrderPackQty_"^"_""
	.Set OrderItemStr=OrderItemStr_"^"_OrderRecDepRowid_"^"_BillTypeRowid_"^"_""_"^"_""
	.Set OrderItemStr=OrderItemStr_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""
	.Set OrderItemStr=OrderItemStr_"^"_""_"^"_""_"^"_OrderSeqNo_"^"_""_"^"_""_"^"_""
	.Set OrderItemStr=OrderItemStr_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""
	.//s ordstr=arcimid_"^"_qty_"^"_recdeptdr_"^"_0_"^"_""_"^"_admreason_"^"_$P($H,",",1)_"^"_$P($H,",",2)
	.//S ResValue=##Class(web.DHCOPCashier).CashierInsertOrdItem(admid,ordstr,user,recdeptdr,"","")
	.s ResValue=##Class(web.DHCOEOrdItem).SaveOrderItems(admid,OrderItemStr,user,recdeptdr,"","")	//zhouyg 20150119
	.S ret=$P(ResValue,"^",1)
	.//i ret'=0 s exit=-1
	.i ret=100 s exit=-1
	Q exit
}

ClassMethod NewPid() As %String
{
 	Q $I(^DHCSTPIVA("COLL"))
}

ClassMethod ClearAllTmp(pid As %String) As %String
{
	D ..CLEARTMP(pid,"RC")
	D ..CLEARTMP(pid,"RCPNO")
	D ..CLEARTMP(pid,"RCSUM")
}

ClassMethod CLEARTMP(pid As %String, PAR As %String) As %String
{
	K ^TMP("PIVA",pid,PAR)
}

ClassMethod GetNewPid() As %String
{
	S PID=..NewPid()
	D ..ClearRCSAVE(PID)
	Q PID
}

ClassMethod ClearRCSAVE(PID) As %String
{
	D ..CLEARTMP(PID,"RCSAVE")
}

/// Creator:Liang Qiang
/// CreatDate:2010-01-15
/// Description:
/// 1.根据主医嘱取配置主表的Rowid连接串，可能是多个以"^"分隔
/// 2.根据配置主表的Rowid取到收费医嘱串，可能是多个以"^"分隔
/// Table:PIVA_OrderLink
/// Input:oe_orditm
/// Ouput:收费医嘱串
/// w ##class(web.DHCSTPIVARECHECK).GetOrdLink("1879||13","987414997")
ClassMethod GetOrdLink(moeori, pid) As %String
{
	 n (moeori,pid)
	 s ord=$P(moeori,"||")
	 S chl=$P(moeori,"||",2)
	 //1.化疗，普通收费
	 s pivatype=""
	 s remark=##class(web.DHCSTPCHCOLLS2).GetOrdItmRemark(moeori)
	 //配液分类
	 s ptypestr=##class(web.DHCSTPIVA).GetAuditedType(moeori)
	 s typeID=$p(ptypestr,"^",1)
	 i typeID'="" s remark="PT"
	 i typeID="TPN" s remark="TPN"
	 i typeID=7 s remark="HL"  //抗肿瘤
	 //
	 i remark["HL" d
	 .s pivatype="HL"
     .s ret=$$GetPolbyDesc(pivatype)
     i (remark'["HL")&(remark'["TPN") d
	 .s pivatype="PT"
     .s ret=$$GetPolbyDesc(pivatype)
     ;s ^lq(3,moeori)=$g(ret)_"^"_pivatype
     Q:(pivatype="PT")||(pivatype="HL") $g(ret)
     //2.TPN收费
	 S arc=$P(^OEORD(ord,"I",chl,1),"^",2)
	 D SetLinkarr(arc,pid)
	 S oeori=moeori
	 S gchl=""
	 F  S gchl=$o(^OEORDi(0,"OEORI",ord,oeori,gchl)) Q:gchl=""  D
	 .S goeori=ord_"||"_gchl
	 .S garc=$P(^OEORD(ord,"I",gchl,1),"^",2)
	 .D SetLinkarr(garc,pid)
	 S pol="",ret="",num=0,subcnt=0
	 F  S pol=$O(^TMP("pololist",pid,pol)) q:pol=""  D
	 .S polnum=$O(^TMP("pololist",pid,pol,""),-1)
	 .Q:polnum=0
	 .s subnum=$$GetSubnum(pol)
	 .;w !,polnum_"^"_subnum_"^"_pol_"-------"
	 .;Q:polnum'=subnum
	 .;i ret="" d
	 .;.s ret=pol
	 .;e  d
	 .;.s ret=ret_"^"_pol
	 . 
	 .Q:subnum=0
	 .I (polnum=num)&(subnum=subcnt) D ;主表rowid出现次数相同+主表下药品明细个数相同
	 ..s ret=ret_"^"_pol
	 ..s num=polnum
	 ..s subcnt=subnum 
	 .Else  If polnum>num D
	 ..q:subnum'=polnum
	 ..s ret=pol
	 ..s num=polnum
	 ..s subcnt=subnum
	 .Else  If (polnum=num)&(subnum<subcnt) D
	 ..s ret=pol
	 ..s subcnt=subnum
	 .
	 k ^TMP("pololist",pid)
	 q:ret="" ""
	 s ret=$$GetOrdfees(ret,pid)
	 k ^TMP("checkpolo",pid)
	 ;s ^lq(4,moeori)=$g(ret)
	 Q ret
SetLinkarr(arcim,pid)
     s i=0
	 S pol=""
	 F  S pol=$O(^POLI(0,"ARCIM",arcim,pol)) Q:pol=""  D
	 .s poldesc=$p(^POLI(pol),"^",1)
	 .q:poldesc'["TPN"
	 .s i=$O(^TMP("pololist",pid,pol,""),-1)+1
	 .S ^TMP("pololist",pid,pol,i)=arcim
	 q 
GetSubnum(pol)
     s x=0
     s sub=""
     f  s sub=$o(^POLI(pol,"G",sub)) q:sub=""  d
     .s x=x+1
     q x
GetOrdfees(pollist,pid)
     s cnt=$l(pollist,"^")
     f h=1:1:cnt d
     .s pol=$p(pollist,"^",h)
     .s sub=""
     .f  s sub=$o(^POLI(pol,"M",sub)) q:sub=""  d
     ..s arci=$p(^POLI(pol,"M",sub),"^",1)
     ..;q:$D(^TMP("checkpolo",pid,arci))
     ..s qty=$p(^POLI(pol,"M",sub),"^",4)
     ..s:+$g(qty)=0 qty=1
     ..;s ^lq(moeori,pol,sub)=""
     ..i $d(^TMP("checkpolo",pid,arci)) d
     ...s tmpqty=^TMP("checkpolo",pid,arci)
     ...i qty>tmpqty d
     ....s ^TMP("checkpolo",pid,arci)=qty
     ..e  d
     ...s ^TMP("checkpolo",pid,arci)=qty
     ..
     .
     s arci=""
     s polstr=""
     f  s arci=$o(^TMP("checkpolo",pid,arci)) q:arci=""  d
     .s tempdesc=$p(^ARCIM(+arci,$p(arci,"||",2),1),"^",2)
     .;w !,tempdesc
     .s qty=^TMP("checkpolo",pid,arci)
     .s onestr=arci_"@"_qty
     .i polstr="" d
     ..s polstr=onestr
     .e  d
     ..s polstr=polstr_"^"_onestr
     q polstr
GetPolbyDesc(tmpdesc)
     s retpol=""
     s retstr=""
     s pol="0"
	 f  s pol=$o(^POLI(pol)) q:pol=""  d
	 .s tpoldesc=$p(^POLI(pol),"^",1)
	 .q:tpoldesc'[tmpdesc
	 .s mainpol=pol
	 q:$g(mainpol)="" ""
	 s sub=""
	 f  s sub=$o(^POLI(mainpol,"M",sub)) q:sub=""  d
     .s arci=$p(^POLI(mainpol,"M",sub),"^",1)
     .s qty=$p(^POLI(mainpol,"M",sub),"^",4)
     .s:+$g(qty)=0 qty=1
     .i retstr="" d
     ..s retstr=arci_"@"_qty
     .e  d
     ..s retstr=retstr_"^"_arci_"@"_qty
	 q retstr
}

ClassMethod DllSaveCheckOK(LabelNo As %String, UserID As %String) As %String
{
	N (LabelNo,UserID)
	;s LabelNo="5-157-125312"
	;s UserID="1"
	Q:LabelNo="" -1_"^条码为空^"
    Q:UserID="" -2_"^条码为空用户ID为空^"
	S ord=$p(LabelNo,"-",1)
	S itm=$p(LabelNo,"-",2)
	s exe=$p(LabelNo,"-",3)
	s grpno=$p(LabelNo,"-",4)
	S orditm=ord_"||"_itm
	s OrdExeRowid=ord_"||"_itm_"||"_exe
	s dspID=$o(^DHCOEDISQTY(0,"OEORE",OrdExeRowid,""))
	s pog=$o(^PIVA(0,"OEGRP",dspID,grpno,""))
	//S pog=$p(LabelNo,"-",3)
	Q:'$D(^PIVA(pog)) -3_"^标签信息不存在^"
	S puser=UserID
	S phac=$P(^PIVA(pog),"^",10)
 	Q:phac="" -4_"^取打印标签错误^"
 	s locid=$P(^PIVA(pog),"^",7)
 	S ward=$P(^DHCPHAC(phac),"^",4)
 	S:$d(^PAWARD(ward)) warddesc=$p(^PAWARD(ward),"^",2)
 	i $f(warddesc,"-") s warddesc=$p(warddesc,"-",2)
	L +^PIVAInterface(LabelNo):30  E  Q -5_"^加锁失败"_"^"_warddesc
	TSTART
	S quitflag=0
	S cnumber=60	/// 配置状态
	S ps=##class(web.DHCSTPIVA).GetPivaStateId(locid,"I",cnumber)
 	I ps="" S quitflag=1
 	Q:quitflag'=0 -6_"^取标签状态错误"_"^"_warddesc
	S psdr=$P(^PIVA(pog),"^",6) /// pog的当前状态
	S nextstr=##class(web.DHCSTPIVA).GetNextStat(psdr)
 	S nextnumber=$P(nextstr,"^",2)
 	I nextnumber'=cnumber S quitflag=2
 	Q:quitflag'=0 -7_"^不应该进行此状态"_"^"_warddesc
 	S moeori=##class(web.DHCSTPIVA).GetMainOeori(orditm)
 	S ChkOrdState=##class(web.DHCSTCOMMONSRV).GetOrdState(OrdExeRowid)
 	q:ChkOrdState'=1 -8_"^停医嘱"_"^"_warddesc
 	//S oestate=##class(web.DHCSTPIVA).GetOeState(moeori)
 	//S oestcode=$P(oestate,"^",1)
 	//Q:(oestcode'="V")&(oestcode'="E") -8_"^停医嘱"_"^"_warddesc
 	
 	S ret=..UpdPog(pog,ps,puser)	//1 处理 PIVA_OrdGrp系列表
 	I ret'=0 S quitflag=3
 	Q:quitflag'=0 -9_"^更新标签状态失败"_"^"_warddesc
 	//S ret=..InsOrder(pog,puser,pid)	/// 插入注射器医嘱
 	;I ret'=0 S quitflag=4
 	;Q:quitflag'=0
 	S PHLoc=$P(^PIVA(pog),"^",7)
 	s HospID=""
 	i PHLoc'="" d
 	.s HospID=$p($g(^CTLOC(PHLoc)),"^",22)
 	s RuleFlag=##Class(web.DHCSTCOMMPARA).GetRpRule(HospID)	//进价规则
 	S sub=0,err=0
 	F  S sub=$O(^PIVA(pog,"I",sub)) Q:(sub="")!(sub=0)!(quitflag'=0)  D
 	.S dsp=$P(^PIVA(pog,"I",sub),"^",1)
 	.Q:dsp=""
 	.Q:'$D(^DHCOEDISQTY(dsp))
 	.s oeori=$P(^DHCOEDISQTY(dsp),"^",1)
	.Q:oeori=""
	.S pri=##class(web.DHCSTPIVA).GetOePriority(oeori)
	.S pricode=$P(pri,"^",2)
	.S pricode=$ZCVT(pricode,"U")
	.Q:(pricode="OM")!(pricode="OMST")
	.//S oestate=##class(web.DHCSTPIVA).GetOeState(oeori)
	.//S oestcode=$P(oestate,"^",1)
 	.//Q:(oestcode'="V")&(oestcode'="E")	/// 去掉停止的医嘱
 	.i RuleFlag=3 d
 	..S err=##class(web.DHCSTPCHCOLLS).DispensingByBatch(phac,dsp,oeori)
 	.e  d
 	..S err=##class(web.DHCSTPCHCOLLS).Dispensing(phac,dsp,oeori) //2 处理发药及库存系列表
 	.//S err=..Dispensing(phac,dsp,puser) //2 处理发药及库存系列表
 	.I err>0 S quitflag=5
 	.I err=9 S quitflag=6
 	.I err=4 S quitflag=7
 	S incidesc=^tmp("DHCSTPIVANOQTY")
 	L -^PIVAInterface(LabelNo)
 	I quitflag'=0 TROLLBACK
	Q:quitflag=5 -10_"^发药失败"_"^"_warddesc
	Q:quitflag=6 -11_"^库存不足:"+incidesc_"^"_warddesc
	Q:quitflag=7 -12_"^库存处理失败"_"^"_warddesc
	I quitflag'=0 -13_"^其它"_"^"_warddesc
 	TCOMMIT
 	Q 0_"^成功"_"^"_warddesc
}

ClassMethod GetWardListExecute(ByRef qHandle As %Binary, tPLocID As %String, tWardID As %String, tStartDate As %String, tEndDate As %String, tBatNo As %String, tOecprID As %String, tOrdStDate As %String, tOrdEndDate As %String, tOecType As %String) As %Status
{

    S repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    S ind=1
    Q:tStartDate="" $$$OK
    Q:tEndDate="" $$$OK
	S PID=..NewPid()
	S i=0,pno=0
	S cnumber=60
	s pstype="I"
	s LastMainOrd=""
	F date=tStartDate:1:tEndDate D
	.S pha=""
	.F  S pha=$O(^DHCPHAC(0,"PHP",tPLocID,"DATE",date,pha)) Q:pha=""  D
	..Q:($D(^DHCPHAC(pha))=0)!($D(^DHCPHAC(pha))=10)
	../// 病区
	..S ward=$P(^DHCPHAC(pha),"^",4)
	..;Q:(tWardID'="")&(tWardID'=ward)
	..Q:##class(web.DHCSTPIVA).CheckWard(tWardID,ward)=0
	../// 打印单号
	..//S printno=$P(^DHCPHAC(pha),"^",14)
	..//Q:(tPrintNo'="")&(tPrintNo'=printno)
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
	...//Q:(tRegNo'="")&(tRegNo'=ipno)
	.../// 优先级
	...S pri=##class(web.DHCSTPIVA).GetOePriority(moeori)
	...S pridr=$P(pri,"^",1)
	...Q:(tOecprID'="")&(tOecprID'=pridr)
	.../// S pridesc=$P(pri,"^",3)
	.../// 关联医嘱是否包含此药品
	...//S qflag=0
 	...//I tItmID'="" D
 	...//.S qflag=##class(web.DHCSTPIVA).ChkExItm(moeori,tItmID)
 	...//Q:(tItmID'="")&(qflag=0)
 	.../// pass审核
 	...//S chstr=##class(web.DHCSTPIVA).GetPassResult(moeori)
	...//S passre=$p(chstr,",",4) /// 配伍审核结果
 	...//Q:(tPassAudit'="")&(tPassAudit'=passre)
 	.../// 医嘱状态
	...//S oestate=##class(web.DHCSTPIVA).GetOeState(moeori)
	...S oestate=##class(web.DHCSTPIVA).GetOrdExeState(moeori)
	...S oestcode=$P(oestate,"^",1)
 	...//Q:(oestcode'="V")&(oestcode'="E")
 	...S oestdesc=$P(oestate,"^",2)
 	...S OrdExeRowid=$p(^DHCOEDISQTY(moedisp),"^",3) 
 	...S ChkOrdState=##class(web.DHCSTCOMMONSRV).GetOrdState(OrdExeRowid)
	...q:ChkOrdState'=1
	...q:##class(web.DHCSTCOMMONSRV).IfAuditByPriority(moedisp)=0  ;需要审核但是配药记录未审核则不发药
	...q:##class(web.DHCSTPCHCOLLS2).HaveBeenRefused(moedisp)>0   ; 拒发药控制
 	.../// 特殊状态,已经取消或拒绝的去掉
 	...S spestat=$P(pdata,"^",8)
 	...Q:spestat'="N"
 	...///当前配药状态
 	...S cstat=##class(web.DHCSTPIVA).GetPSName(pog)
 	...///下一个配药状态
 	...S psdr=$P(pdata,"^",6)
 	...S nextstr=##class(web.DHCSTPIVA).GetNextStat(psdr,tPLocID,pstype)
 	...S nextnumber=$P(nextstr,"^",2)
 	...Q:nextnumber'=cnumber
 	...i LastMainOrd'=moeori d
	....s ptypestr=##class(web.DHCSTPIVA).GetAuditedType(moeori)
	....s typeID=$p(ptypestr,"^",1)
	...Q:(tOecType'="")&(tOecType'=$g(typeID))
	...s LastMainOrd=moeori
	...S pogsub=""
	...F  S pogsub=$O(^PIVA(pog,"I",pogsub)) Q:pogsub=""  D
	....S dodis=$P(^PIVA(pog,"I",pogsub),"^",1)
	....Q:dodis=""
	....Q:'$D(^DHCOEDISQTY(dodis))
 	....S dspstatus=$p(^DHCOEDISQTY(dodis),"^",7)
 	....Q:dspstatus'="TC"	/// 已经确认
 	....S oeori=$p(^DHCOEDISQTY(dodis),"^",1)
 	....S ord=$P(oeori,"||",1)
 	....S chl=$P(oeori,"||",2)
 	....//S oestate=##class(web.DHCSTPIVA).GetOeState(oeori)
	....//S oestcode=$P(oestate,"^",1)
 	....//Q:(oestcode'="V")&(oestcode'="E")	/// 去掉停止的医嘱
	....S ^TMP("PIVA",PID,"RCWARD","LIST",ward)=""
	S i=0
	S warddr=""
	F  S warddr=$o(^TMP("PIVA",PID,"RCWARD","LIST",warddr)) q:warddr=""  d
	.S ward=$p(^PAWARD(warddr),"^",2)
	.i $F(ward,"-") s ward=$p(ward,"-",2)
	.S i=i+1
    .d OutRowWard
    .
    D KillTMP
    D GetRowsCount
	Quit $$$OK
OutRowWard
	set Data=$lb(ward,warddr)   
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
KillTMP
    k ^TMP("PIVA",PID,"RCWARD")
    quit
GetRowsCount
    Write !,"<SCRIPT language=""Javascript"">",!
    w "RowsCount="_i_";",!
	w "</SCRIPT>"
	quit
}

ClassMethod GetWardListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetWardListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
	}
	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query GetWardList(tPLocID As %String, tWardID As %String, tStartDate As %String, tEndDate As %String, tBatNo As %String, tOecprID As %String, tOrdStDate As %String, tOrdEndDate As %String, tOecType As %String) As %Query(ROWSPEC = "tbWard:%String,tbWardDr:%String")
{
}

ClassMethod GetWardListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetWardListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetInclbCounter(recloc, inci) As %String
{
	 l +^DHCINCIL(recloc,inci):10  e  q -1   ;加锁
     s pid=##CLASS(web.DHCSTKUTIL).GetInclbCounter()
     q pid
}

ClassMethod CheckDataBeforeSave(dsprowidstr)
{
	s retstr=""
	S pid=..NewPid()
	//wyx 增加loclog取自登录科室session里的科室
	s loclog=%session.Data("LOGON.CTLOCID")
	//s loclog=101
	s cnt=$l(dsprowidstr,"^")
	f num=1:1:cnt d
	.//add wyx 2015-02-28 急诊留观病人增加欠费控制
    .s dsprowid=$p(dsprowidstr,"^",num)
    .s Oeori=$p(^DHCOEDISQTY(dsprowid),"^",1)
    .s ord=+Oeori
    .s itm=$p(Oeori,"||",2)
    .S patadm=$P(^OEORD(ord),"^",1)	/// 病人 PAADM_Rowid
    .S Papmi=$p(^PAADM(patadm),"^",1)
    .s patname=$p(^PAPER(Papmi,"ALL"),"^",1)
    .q:$d(^TMP("web","DHCSTPIVARECHECK","CheckDataBeforeSave",pid,Papmi))
    .s DspQty=$p(^DHCOEDISQTY(dsprowid),"^",11)   					//本顿发药数
    .s orditemqty=Oeori_$c(2)_DspQty
    .s AmtRet=##class(web.DHCSTPCHCOLLS2).CheckArrearsNew("",patadm,orditemqty,loclog)
    .i AmtRet="N" d 
    ..s ^TMP("web","DHCSTPIVARECHECK","CheckDataBeforeSave",pid,Papmi)=patname
    .
  	s Papmit=""
	f  s Papmit=$o(^TMP("web","DHCSTPIVARECHECK","CheckDataBeforeSave",pid,Papmit)) q:Papmit=""  d
	.s name=^TMP("web","DHCSTPIVARECHECK","CheckDataBeforeSave",pid,Papmit)
	.i retstr="" s retstr=name
	.e  s retstr=retstr_","_name
	.
	k ^TMP("web","DHCSTPIVARECHECK","CheckDataBeforeSave",pid)
	q retstr
}

/// creator:yunhaibao
/// createdate:20160112
/// description:配液配置后调用账单程序,一次打签adm必然一样
ClassMethod MakeBill(pog) As %String
{
	n (pog,%session)
	s ret=0
	q:pog="" ""
	q:'$d(^PIVA(pog)) ""
	s puser=##class(web.DHCSTCOMWEB).GetUserID()
	s adm="",oeorestr=""
	s pogsub=""
	.F  S sub=$O(^PIVA(pog,"I",pogsub)) Q:pogsub=""  D
 	..S dsp=$P(^PIVA(pog,"I",pogsub),"^",1)
 	..Q:dsp=""
 	..Q:'$D(^DHCOEDISQTY(dsp))
 	..s oeori=$P(^DHCOEDISQTY(dsp),"^",1)
	..Q:oeori=""
	..s adm=$p($g(^OEORD(+oeori)),"^",1)
	..q:adm=""
	..q:$P(^DHCOEDISQTY(dsp),"^",1)'="C" //未发药不调用
	..S OrdExeRowid=$p(^DHCOEDISQTY(dsp),"^",3)
	..i oeorestr="" s oeorestr=OrdExeRowid
	..e  s oeorestr=oeorestr_"^"_OrdExeRowid
	i (adm'="")&&(oeorestr'="") s ret=##Class(web.UDHCJFBILL).BILLN(adm,puser,oeorestr,1)
	q ret
}

}
