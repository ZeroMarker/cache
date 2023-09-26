Import SQLUser

/// Description:配液状态执行：分签,贴签,排药,核对,配置,成品核查,
/// Creator: Liang Qiang
/// CreatDate:2010-03-31
Class web.DHCSTPIVAPROCESSCHECK Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
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

ClassMethod DispExecute(ByRef qHandle As %Binary, tPLocID As %String, tWardID As %String, tStartDate As %String, tEndDate As %String, tRegNo As %String, tBatNo As %String, tOecprID As %String, tItmID As %String, tPrintNo As %String, tPassAudit As %String, tOrdStDate As %String, tOrdEndDate As %String, tOecType As %String, tChecked As %String, tExeState As %String) As %Status
{
	S repid=$I(^CacheTemp)
	S qHandle=$lb(0,repid,0)
	S ind=1
	Q:tPLocID="" $$$OK
	Q:tStartDate="" $$$OK
	Q:tEndDate="" $$$OK
	IF tChecked="on" S tChecked=1
	S PID=""
	S PID=..CollData(tPLocID, tWardID, tRegNo, tStartDate, tEndDate, tBatNo, tOecprID, tItmID, tPrintNo,tPassAudit,tOrdStDate,tOrdEndDate,tOecType,tChecked,tExeState)
	Q:PID="" $$$OK
	S jj=""
	s lipno=""
	s colortype="W"
	F  S jj=$O(^TMP("PIVA",PID,"EXE","ADM",jj)) Q:jj=""  D
	.S ii=""
	.F  S ii=$O(^TMP("PIVA",PID,"EXE","ADM",jj,ii)) Q:ii=""  D
	..S Data=..GetData(PID,jj,ii,lipno,colortype)
	..S lipno=^TMP("PIVA",PID,"EXE","IPNO",jj,ii)
	..s colortype=^TMP("PIVA",PID,"EXE","COLOR",jj,ii)
	..S ^CacheTemp(repid,ind)=Data	
 	..S ind=ind+1
 	Q $$$OK
}

Query Disp(tPLocID As %String, tWardID As %String, tStartDate As %String, tEndDate As %String, tRegNo As %String, tBatNo As %String, tOecprID As %String, tItmID As %String, tPrintNo As %String, tPassAudit As %String, tOrdStDate As %String, tOrdEndDate As %String, tOecType As %String, tChecked As %String, tExeState As %String) As %Query(ROWSPEC = "tbPID:%String,tbBatNo:%String,tbSeqNo:%String,tbItmDesc:%String,tbRegNo:%String,tbBedNo:%String,tbName:%String,tbFreq:%String,tbQty:%String,tbPrice:%String,tbOeStatus:%String,tbDosage:%String,tbSpec:%String,tbInst:%String,tbDura:%String,tbPresc:%String,tbOecpr:%String,tbDoctor:%String,tbOexeDate:%String,tbOexeTime:%String,tbCompare:%String,tbSign:%String,tbDSP:%String,tbGrpNo:%String,tbPrintNum:%String,tbMOeori:%String,tbUom:%String,tbPassResult:%String,tbPrintNo:%String,tbWard:%String,tbPUser:%String,tbPDate:%String,tbPTime:%String,tbPogID:%String,tbState:%String,tbSpecStat:%String,tdrugcatdr:%String,tdrugcatdesc:%String,tpsUser:%String,tpsDt:%String,tbMdodis:%String,tbColorType:%String,TEncryptLevel:%String,TPatLevel:%String")
{
}

ClassMethod CollData(tPLocID As %String, tWardID As %String, tRegNo As %String, tStartDate As %String, tEndDate As %String, tBatNo As %String, tOecprID As %String, tItmID As %String, tPrintNo As %String, tPassAudit As %String, tOrdStDate As %String, tOrdEndDate As %String, tOecType As %String, tChecked As %String, tExeState As %String) As %Integer
{
	N (tPLocID, tWardID, tRegNo, tStartDate, tEndDate, tBatNo, tOecprID, tItmID, tPrintNo,tPassAudit,tOrdStDate,tOrdEndDate,tOecType,tChecked,tExeState)
	Q:tPLocID="" ""
	Q:tStartDate="" ""
	Q:tEndDate="" ""
	;S cnumber=75	/// 当前状态号
	S cnumber=tExeState
	s pstype="I"
	S PID=..NewPid()
	D ..ClearAllTmp(PID)
	s HospID=$p($g(^CTLOC(tPLocID)),"^",22)
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
 	.../// 医嘱状态
	...//S oestate=##class(web.DHCSTPIVA).GetOeState(moeori)
	...S oestate=##class(web.DHCSTPIVA).GetOrdExeState(moeori)	//zhouyg 20151110 改为取执行状态
	...S oestcode=$P(oestate,"^",1)
 	...Q:(oestcode'="V")&(oestcode'="E")
 	...S oestdesc=$P(oestate,"^",2)
 	.../// 特殊状态,已经取消或拒绝的去掉
 	...S spestat=$P(pdata,"^",8)
 	...Q:spestat'="N"
 	...///当前配药状态
 	...S cstat=##class(web.DHCSTPIVA).GetPSName(pog)
 	...///下一个配药状态
 	...S psdr=$P(pdata,"^",6)
 	...S pnumber=$P(^PIVAS(psdr),"^",1)
 	...Q:(tChecked="1")&(cnumber'=pnumber)
 	...S nextstr=##class(web.DHCSTPIVA).GetNextStat(psdr,tPLocID,pstype)
 	...S nextnumber=$P(nextstr,"^",2)
 	...;s ^lq(pog)=nextnumber_","_cnumber_","_tChecked_","_pnumber
 	...Q:(tChecked'="1")&(nextnumber'=cnumber)
 	...i LastMainOrd'=moeori d
	....s ptypestr=##class(web.DHCSTPIVA).GetAuditedType(moeori)
	....s typeID=$p(ptypestr,"^",1)
	...Q:(tOecType'="")&(tOecType'=$g(typeID))
	...s LastMainOrd=moeori
	...s psString=##class(web.DHCSTPIVA).GetPSUser(pog) //状态执行人与时间
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
	...I '$D(^TMP("PIVA",PID,"EXEPNO",moeori,grpno)) D
 	....S pno=pno+1
 	....S ^TMP("PIVA",PID,"EXEPNO",moeori,grpno)=pno
	...S pogsub=""
	...F  S pogsub=$O(^PIVA(pog,"I",pogsub)) Q:pogsub=""  D
	....S dodis=$P(^PIVA(pog,"I",pogsub),"^",1)
	....Q:dodis=""
	....Q:'$D(^DHCOEDISQTY(dodis))
	....s OrdExeRowid=$p(^DHCOEDISQTY(dodis),"^",3)
 	....S ChkOrdState=##class(web.DHCSTCOMMONSRV).GetOrdState(OrdExeRowid)
	....q:(ChkOrdState'=1)&(cnumber<70)
 	....S dspstatus=$p(^DHCOEDISQTY(dodis),"^",7)
 	....Q:(dspstatus'="TC")&(cnumber<70)	/// 已经确认(复核前的状态考虑此处)
 	....S oeori=$p(^DHCOEDISQTY(dodis),"^",1)
 	....S ord=$P(oeori,"||",1)
 	....S chl=$P(oeori,"||",2)
	....S oestate=##class(web.DHCSTPIVA).GetOrdExeState(OrdExeRowid)
	....S oestcode=$P(oestate,"^",1)
 	....//Q:(oestcode'="V")&(oestcode'="E")&(cnumber<70)	/// 去掉停止的医嘱 (复核前的状态考虑此处)
 	....S seqno=$P(^OEORD(ord,"I",chl,3),"^",4)		/// 关联医嘱号
 	....S incitm=##class(web.DHCSTPIVA).GetIncItm(oeori)
 	....S inci=$P(incitm,"^",1)
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
 	....//S nuraudited= "" //##class(web.DHCSTPIVA).IfAuditByPriority(oeori,pridr)	/// 是否护士审核
 	....S nuraudited=##class(web.DHCSTCOMMONSRV).GetNurAuditStr(dodis)	//zhouyg 20141220
 	....s nuraudited=$s(nuraudited'="":"已审核",1:"未审核")
 	....S oepri=##class(web.DHCSTPIVA).GetOePriority(oeori)
	....S pridesc=$P(oepri,"^",3)
	....s pricode=$p(oepri,"^",2) 
 	....S presc=$P(^OEORD(ord,"I",chl,1),"^",14)
 	....S drugcatdr=$p(ptypestr,"^",1) //药学分类(或子类)rowid
	....S drugcatdesc=$p(ptypestr,"^",2) //药学分类(或子类)描述
	....s ArcimId=$p(^OEORD(ord,"I",chl,1),"^",2)                                    ;医嘱 ARC_ItmMast ARCIM_RowId
 	....s ArcCatId=$p(^ARCIM($p(ArcimId,"||",1),$p(ArcimId,"||",2),1),"^",10)        ;医嘱子类RowId
 	....s AmtFlag=##Class(web.DHCSTCOMMONSRV).IfCollectDrugAllowed(adm,ArcCatId_"^"_pricode)  ;最终结算,不显示，yunhaibao20160314
 	....q:(tChecked'=1)&&(AmtFlag=0)
 	....;s ^lq(pog,oeori)=nextnumber_","_cnumber_","_tChecked_","_pnumber
 	....S i=i+1
 	....S j=sttdate2_"||"_ward_"||"_bed_"||"_batno_"||"_grpno_"||"_seqno
 	....S ^TMP("PIVA",PID,"EXE","ADM",j,i)=adm
 	....S ^TMP("PIVA",PID,"EXE","OEORI",j,i)=oeori
 	....S ^TMP("PIVA",PID,"EXE","DODIS",j,i)=dodis
 	....S ^TMP("PIVA",PID,"EXE","PRICE",j,i)=price ;_"*"_moeori_"*"_pog
 	....S ^TMP("PIVA",PID,"EXE","GRPNO",j,i)=grpno
 	....S ^TMP("PIVA",PID,"EXE","ITMNAME",j,i)=itmdesc
 	....S ^TMP("PIVA",PID,"EXE","IPNO",j,i)=ipno
 	....S ^TMP("PIVA",PID,"EXE","PANAME",j,i)=paname
 	....S ^TMP("PIVA",PID,"EXE","QTY",j,i)=qty
 	....S ^TMP("PIVA",PID,"EXE","UOM",j,i)=uomdesc
 	....S ^TMP("PIVA",PID,"EXE","OESTAT",j,i)=oestdesc
 	....S ^TMP("PIVA",PID,"EXE","PRI",j,i)=pridesc
 	....S ^TMP("PIVA",PID,"EXE","SPEC",j,i)=spec
 	....S ^TMP("PIVA",PID,"EXE","DOSAGE",j,i)=dosage
 	....S ^TMP("PIVA",PID,"EXE","FREQ",j,i)=freqcode
 	....S ^TMP("PIVA",PID,"EXE","DURA",j,i)=dura
 	....S ^TMP("PIVA",PID,"EXE","INSTRUC",j,i)=instruc
 	....S ^TMP("PIVA",PID,"EXE","PRESC",j,i)=presc
 	....S ^TMP("PIVA",PID,"EXE","DOCTOR",j,i)=doctor
 	....S ^TMP("PIVA",PID,"EXE","STTIME",j,i)=sttime
 	....S ^TMP("PIVA",PID,"EXE","SIGN",j,i)=sign
 	....S ^TMP("PIVA",PID,"EXE","COMP",j,i)=comp
 	....S ^TMP("PIVA",PID,"EXE","NURAUDIT",j,i)=nuraudited
 	....S ^TMP("PIVA",PID,"EXE","PASS",j,i)=passre
 	....S ^TMP("PIVA",PID,"EXE","MOEORI",j,i)=moeori
 	....S ^TMP("PIVA",PID,"EXE","PNO",j,i)=printno			/// 打印单号
 	....S ^TMP("PIVA",PID,"EXE","PNUMBER",j,i)=printnumber	/// 打印序号
 	....S ^TMP("PIVA",PID,"EXE","PUSER",j,i)=printuser
 	....S ^TMP("PIVA",PID,"EXE","PDATE",j,i)=printdate
 	....S ^TMP("PIVA",PID,"EXE","PTIME",j,i)=printtime
 	....S ^TMP("PIVA",PID,"EXE","POG",j,i)=pog
 	....S ^TMP("PIVA",PID,"EXE","STAT",j,i)=cstat
 	....S ^TMP("PIVA",PID,"EXE","SPESTAT",j,i)=spestat
 	....S ^TMP("PIVA",PID,"EXE","CATDR",j,i)=drugcatdr
 	....S ^TMP("PIVA",PID,"EXE","CATDESC",j,i)=drugcatdesc
 	....S ^TMP("PIVA",PID,"EXE","CATDESC",j,i)=drugcatdesc
 	....S ^TMP("PIVA",PID,"EXE","PSSTR",j,i)=psString
	I i>0 S ^TMP("PIVA",PID,"EXESUM")=i_"^"_pno
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
	S adm=^TMP("PIVA",PID,"EXE","ADM",j,i)
	S oeori=^TMP("PIVA",PID,"EXE","OEORI",j,i)
	S dodis=^TMP("PIVA",PID,"EXE","DODIS",j,i)
	S price=^TMP("PIVA",PID,"EXE","PRICE",j,i)
	S grpno=^TMP("PIVA",PID,"EXE","GRPNO",j,i)
	S itmdesc=^TMP("PIVA",PID,"EXE","ITMNAME",j,i)
 	S ipno=^TMP("PIVA",PID,"EXE","IPNO",j,i)
 	S paname=^TMP("PIVA",PID,"EXE","PANAME",j,i)
 	S uomdesc=^TMP("PIVA",PID,"EXE","UOM",j,i)
 	S qty=^TMP("PIVA",PID,"EXE","QTY",j,i)
 	S oestate=^TMP("PIVA",PID,"EXE","OESTAT",j,i)
 	S pridesc=^TMP("PIVA",PID,"EXE","PRI",j,i)
 	S spec=^TMP("PIVA",PID,"EXE","SPEC",j,i)
 	S dosage=^TMP("PIVA",PID,"EXE","DOSAGE",j,i)
 	S freqcode=^TMP("PIVA",PID,"EXE","FREQ",j,i)
 	S dura=^TMP("PIVA",PID,"EXE","DURA",j,i)
 	S instruc=^TMP("PIVA",PID,"EXE","INSTRUC",j,i)
 	S presc=^TMP("PIVA",PID,"EXE","PRESC",j,i)
 	S doctor=^TMP("PIVA",PID,"EXE","DOCTOR",j,i)
 	S sttime=^TMP("PIVA",PID,"EXE","STTIME",j,i)
 	S sign=^TMP("PIVA",PID,"EXE","SIGN",j,i)
 	S comp=^TMP("PIVA",PID,"EXE","COMP",j,i)
 	S nuraudited=^TMP("PIVA",PID,"EXE","NURAUDIT",j,i)
 	S passre=^TMP("PIVA",PID,"EXE","PASS",j,i)
 	S moeori=^TMP("PIVA",PID,"EXE","MOEORI",j,i)
 	S printno=^TMP("PIVA",PID,"EXE","PNO",j,i)
 	S printnumber=^TMP("PIVA",PID,"EXE","PNUMBER",j,i)
 	S printuser=^TMP("PIVA",PID,"EXE","PUSER",j,i)
 	S printdate=^TMP("PIVA",PID,"EXE","PDATE",j,i)
 	S printtime=^TMP("PIVA",PID,"EXE","PTIME",j,i)
 	S pog=^TMP("PIVA",PID,"EXE","POG",j,i)
 	S cstat=^TMP("PIVA",PID,"EXE","STAT",j,i)
 	S spestat=^TMP("PIVA",PID,"EXE","SPESTAT",j,i)
 	S drugcatdr=^TMP("PIVA",PID,"EXE","CATDR",j,i)
 	S drugcatdesc=^TMP("PIVA",PID,"EXE","CATDESC",j,i)
 	S psString=^TMP("PIVA",PID,"EXE","PSSTR",j,i)
 	S psUser=$p(psString,"^",1)
 	S psDt=$p(psString,"^",2)
 	S mdodis=##class(web.DHCSTPIVA).GetMainOEDispID(dodis,grpno)
 	s colortypeStr=##class(web.DHCSTPIVA).GetColorType(ipno,lipno,oestate,passre,patcolor,spestat)
 	s colortype=$p(colortypeStr,"^",1)
 	s patcolor=$p(colortypeStr,"^",2)
 	s ^TMP("PIVA",PID,"EXE","COLOR",j,i)=patcolor
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
 	S data=$LB(PID,batno,seqno,itmdesc,ipno,bed,paname,freqcode,qty,price,oestate,dosage,spec,instruc,dura,presc,pridesc,doctor,stdate,sttime,comp,sign,dodis,grpno,printnumber,moeori,uomdesc,passre,printno,ward,printuser,printdate,printtime,pog,cstat,spestat,drugcatdr,drugcatdesc,psUser,psDt,mdodis,colortype,EncryptLevel,PatLevel)
 	Q data
}

ClassMethod GetRecordSum(pid As %String) As %String
{
	Q $G(^TMP("PIVA",pid,"EXESUM"))
}

/// 审核通过,1-更新 PIVA_OrdGrp ,2-插入 PIVA_OrdGrpState 
ClassMethod SaveCheckOK(pid As %String, pog As %String, cnumber As %String) As %String
{
	N (pid,pog,cnumber,%session)
	Q:pid="" -2
	Q:pog="" -3
	Q:'$D(^PIVA(pog)) -4
	S puser=##class(web.DHCSTCOMWEB).GetUserID()
	Q:puser="" -5
	S phac=$P(^PIVA(pog),"^",10)
 	Q:phac="" -6
	L +^PIVA(pog):30  E  Q -7
	s pstype="I"
	s locid=$P(^PIVA(pog),"^",7)
	//判断出院结算,yunhaibao20160314
	S moedisp=$P(^PIVA(pog),"^",1)
	S moeori=$P(^DHCOEDISQTY(moedisp),"^",3) 
	S mord=$P(moeori,"||",1)
	S adm=$P(^OEORD(mord),"^",1)	/// 病人 PAADM_Rowid
	S oepri=##class(web.DHCSTPIVA).GetOePriority(moedisp)
	s pricode=$p(oepri,"^",2) 
	s ArcimId=$p(^OEORD(+moeori,"I",$p(moeori,"||",2),1),"^",2)                                    ;医嘱 ARC_ItmMast ARCIM_RowId
 	s ArcCatId=$p(^ARCIM($p(ArcimId,"||",1),$p(ArcimId,"||",2),1),"^",10)        ;医嘱子类RowId
 	s AmtFlag=##Class(web.DHCSTCOMMONSRV).IfCollectDrugAllowed(adm,ArcCatId_"^"_pricode)  ;最终结算,不显示，yunhaibao20160314
 	q:AmtFlag=0 -11
	TSTART
	;S cnumber=75	/// 配液状态
	S quitflag=0
	I '$D(^TMP("PIVA",pid,"EXESAVE",pog)) D
	.S ^TMP("PIVA",pid,"EXESAVE",pog)=""
	.S ps=##class(web.DHCSTPIVA).GetPivaStateId(locid,"I",cnumber)
 	.I ps="" S quitflag=1
 	.Q:quitflag'=0
	.S psdr=$P(^PIVA(pog),"^",6) /// pog的当前状态
	.S nextstr=##class(web.DHCSTPIVA).GetNextStat(psdr,locid,pstype)
 	.S nextnumber=$P(nextstr,"^",2)
 	.I nextnumber'=cnumber S quitflag=2
 	.Q:quitflag'=0	/// 不应该进行此状态
 	.S ret=..UpdPog(pog,ps,puser)	//1 处理 PIVA_OrdGrp系列表
 	.I ret'=0 S quitflag=3
 	.Q:quitflag'=0
 	.
 	L -^PIVA(pog)
 	I quitflag'=0 TROLLBACK
 	Q:quitflag=1 -8
 	Q:quitflag=2 -9
 	Q:quitflag=3 -10
 	TCOMMIT
 	Q 0
}

/// 审核不通过,1-更新 PIVA_OrdGrp ,2-插入 PIVA_OrdGrpState
ClassMethod SaveCheckNo(pog As %String) As %String
{
	N (pog,%session)
	Q:pog="" -1
	Q:'$D(^PIVA(pog)) -2
	S cnumber=75	/// 复核状态
	S number=5		/// 复核不通过
	S psdr=$P(^PIVA(pog),"^",6)
	s locid=$P(^PIVA(pog),"^",7)
	S nextstr=##class(web.DHCSTPIVA).GetNextStat(psdr)
 	S nextnumber=$P(nextstr,"^",2)
 	Q:nextnumber'=cnumber -3
	S ps=##class(web.DHCSTPIVA).GetPivaStateId(locid,"I",number)
	Q:ps="" -4
	S puser=##class(web.DHCSTCOMWEB).GetUserID()
	Q:puser="" -5
	L +^DHCSTLOCK("PIVAEXE",pog):10 E  Q -100
	TSTART
	S ret=..UpdPog(pog,ps,puser)	//1 
	I ret'=0 TROLLBACK
	I ret'=0 L -^DHCSTLOCK("PIVAEXE",pog)
	Q:ret'=0 -6
	TCOMMIT
	L -^DHCSTLOCK("PIVAEXE",pog)
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

ClassMethod NewPid() As %String
{
 	Q $I(^DHCSTPIVA("COLL"))
}

ClassMethod ClearAllTmp(pid As %String) As %String
{
	D ..CLEARTMP(pid,"EXE")
	D ..CLEARTMP(pid,"EXEPNO")
	D ..CLEARTMP(pid,"EXESUM")
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
	D ..CLEARTMP(PID,"EXESAVE")
}

/// 取消审核通过,1-更新 PIVA_OrdGrp ,2-插入 PIVA_OrdGrpState 
ClassMethod CancelCheckOK(pid As %String, pog As %String, cnumber As %String) As %String
{
	N (pid,pog,cnumber,%session)
	Q:pid="" -2
	Q:pog="" -3
	Q:'$D(^PIVA(pog)) -4
	S puser=##class(web.DHCSTCOMWEB).GetUserID()
	Q:puser="" -5
	S phac=$P(^PIVA(pog),"^",10)
	s locid=$P(^PIVA(pog),"^",7)
 	Q:phac="" -6
	L +^PIVA(pog):30  E  Q -7
	TSTART
	;S cnumber=75	/// 配液状态
	S quitflag=0
	I '$D(^TMP("PIVA",pid,"EXESAVE",pog)) D
	.S ^TMP("PIVA",pid,"EXESAVE",pog)=""
	.;S ps=$O(^PIVAS(0,"NUMBER",cnumber,""),-1)
	.S bnumber=$O(^PIVAS(0,"NUMBER",cnumber),-1)
	.S bps=##class(web.DHCSTPIVA).GetPivaStateId(locid,"I",bnumber)
	.S cps=##class(web.DHCSTPIVA).GetPivaStateId(locid,"I",cnumber) //将要取消状态Dr
 	.I bps="" S quitflag=1
 	.Q:quitflag'=0
	.S psdr=$P(^PIVA(pog),"^",6) /// pog的当前状态
	.S psnumber=$P(^PIVAS(psdr),"^",1)
	.I psnumber'=cnumber S quitflag=2 //当前状态未执行
	.Q:psnumber'=cnumber
 	.S ret=..UpdCPog(pog,bps,puser,cps)	//1 处理 PIVA_OrdGrp系列表
 	.s ret=0
 	.I ret'=0 S quitflag=4
 	.Q:quitflag'=0
 	.
 	L -^PIVA(pog)
 	I quitflag'=0 TROLLBACK
 	L -^PIVA(pog)
 	Q:quitflag=1 -8
 	Q:quitflag=2 -9
 	Q:quitflag=3 -10
 	Q:quitflag=4 -11
 	TCOMMIT
 	L -^PIVA(pog)
 	Q 0
}

ClassMethod UpdCPog(pog As %String, bps As %String, puser As %String, cps As %String) As %String
{
	N (pog,bps,puser,cps)
	K PLIST
	&SQL(Select * Into :PLIST() From PIVA_OrdGrp Where pog_rowid=:pog)
	S PLIST(7)=bps
	&SQL(Update PIVA_OrdGrp Values :PLIST() Where pog_rowid=:pog)
	Q:SQLCODE -1
	S ret=..DelOrdGrpState(pog,puser,cps)
	Q ret
}

ClassMethod DelOrdGrpState(parref As %String, user As %String, ps As %String) As %String
{
	N (parref,user,ps)
	Q:parref="" -1
	Q:user="" -2
	Q:ps="" -3
	&SQL(Delete from  PIVA_OrdGrpState where POGS_PS_Dr=:ps and POGS_POG_Parref=:parref)
	Q SQLCODE
}

ClassMethod tt() As %String
{
 //&SQL(update PIVA_OrdGrp set pog_ps_dr="8"  where pog_ps_dr="6")
 //&SQL(Delete from  PIVA_OrdGrpState where POGS_PS_Dr="6")
 q 0
}

Storage Default
{
<Data name="DHCSTPIVAPROCESSCHECKDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCSTPIVAPROCESSCHECKD</DataLocation>
<DefaultData>DHCSTPIVAPROCESSCHECKDefaultData</DefaultData>
<IdLocation>^web.DHCSTPIVAPROCESSCHECKD</IdLocation>
<IndexLocation>^web.DHCSTPIVAPROCESSCHECKI</IndexLocation>
<StreamLocation>^web.DHCSTPIVAPROCESSCHECKS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
