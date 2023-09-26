Import SQLUser

Class web.DHCSTPIVAUPDATEBAT Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

Parameter BATNOSTR [ Final ] = "1^2#2^3#3^4#4^5";

//例如："1^2#3^4#6^7",判断1、3、6批,1批次移到2批,3批移到4批,6批移到7批

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

ClassMethod DispExecute(ByRef qHandle As %Binary, displocrowid As %String, tWardID As %String, tStartDate As %String, tEndDate As %String, tAdmID As %String, tBatNo As %String, tOecprID As %String, tItmID As %String, tNoQty As %String, tNotAudit As %String, tPType As %String, tOecType As %String) As %Status
{
	S repid=$I(^CacheTemp)
	S qHandle=$lb(0,repid,0)
	S ind=1
	//w displocrowid_","_tWardID_","_tStartDate_","_tEndDate_","_tAdmID_","_tBatNo_","_tOecprID_","_tItmID_","_tNoQty_","_tNotAudit_","_tPType_","_tOecType
	s ^ligao("DispExecute")=displocrowid_","_tWardID_","_tStartDate_","_tEndDate_","_tAdmID_","_tBatNo_","_tOecprID_","_tItmID_","_tNoQty_","_tNotAudit_","_tPType_","_tOecType
	Q:displocrowid="" $$$OK
	Q:tStartDate="" $$$OK
	Q:tEndDate="" $$$OK
	Q:(tWardID="")&(tAdmID="") $$$OK
	Q:$O(^PIVAA(0))="" $$$OK /// 没有维护医嘱类型
	S PID=""
	I tAdmID="" D //按病区检索
	.S PID=..CollWard(displocrowid, tWardID, tStartDate, tEndDate, tBatNo, tOecprID, tItmID, tNoQty,tNotAudit,tPType,tOecType)
	E  D //按登记号检索
	.S PID=..CollAdm(displocrowid, tAdmID, tStartDate, tEndDate, tBatNo, tOecprID, tItmID, tNoQty,tNotAudit,tPType,tOecType)
	//w PID,!
	Q:PID="" $$$OK
	S jj=""
	s lipno=""
	s colortype="W"
	F  S jj=$O(^TMP("PIVA",PID,"D","ADM",jj)) Q:jj=""  D
	.S ii=""
	.F  S ii=$O(^TMP("PIVA",PID,"D","ADM",jj,ii)) Q:ii=""  D
	..S Data=..GetData(PID,jj,ii,lipno,colortype)
	..S ^CacheTemp(repid,ind)=Data	
 	..S ind=ind+1
 	Q $$$OK
}

Query Disp(displocrowid As %String, tWardID As %String, tStartDate As %String, tEndDate As %String, tAdmID As %String, tBatNo As %String, tOecprID As %String, tItmID As %String, tNoQty As %String, tNotAudit As %String, tPType As %String, tOecType As %String) As %Query(ROWSPEC = "tbPID:%String,tbBatNo:%String,tbSeqNo:%String,tbItmDesc:%String,tbRegNo:%String,tbBedNo:%String,tbName:%String,tbFreq:%String,tbQty:%String,tbPrice:%String,tbOeStatus:%String,tbDosage:%String,tbSpec:%String,tbInst:%String,tbDura:%String,tbPresc:%String,tbOecpr:%String,tbDoctor:%String,tbOexeDate:%String,tbOexeTime:%String,tbCompare:%String,tbSign:%String,tbDSP:%String,tbGrpNo:%String,tbPrintNum:%String,tbMOeori:%String,tbUom:%String,tbNurAudit:%String,tbPass:%String,tbOrdDate:%String,tbOrdTime:%String,tremark:%String,tbDrugcatdr:%String,tbDrugcatdesc:%String,tbMdodis:%String,tbColorType:%String,TEncryptLevel:%String,TPatLevel:%String")
{
}

ClassMethod CollWard(displocrowid As %String, tWardID As %String, tStartDate As %String, tEndDate As %String, tBatNo As %String, tOecpr As %String, tItmID As %String, tNoQty As %String, tNotAudit As %String, tPType As %String, tOecType As %String) As %Integer
{
	N (displocrowid, tWardID, tStartDate, tEndDate, tBatNo, tOecpr, tItmID, tNoQty,tNotAudit,tPType,tOecType,%session)
	S PID=..NewPid()
	Q:displocrowid="" ""
	Q:tWardID="" ""
	Q:tStartDate="" ""
	Q:tEndDate="" ""
	Q:$O(^PIVAA(0))="" ""	/// 配液的医嘱子分类没有维护
	Q:$O(^PIVAO(0,"OECPR",displocrowid,""))="" ""	/// 科室配液的医嘱优先级没有维护
	Q:$O(^PIVABT(0,"TIME",displocrowid,""))="" ""	/// 科室配液的时间段分批没有维护
	D ..ClearAllTmp(PID)
	S cnumber=10  /// 10固定为打签状态
	s type="I"
	S ^TMP("PIVA",PID,"M")=displocrowid_"^"_tWardID_"^"_tStartDate_"^"_tEndDate
	s HospID=$p($g(^CTLOC(displocrowid)),"^",22)
	s LastMainOrd=""
	s WardLocDr=$p(^PAWARD(tWardID),"^",5)
	S i=0,pno=0
	F date=tStartDate:1:tEndDate D
	.S DspId=""
	.F  s DspId=$O(^DHCOEDISQTY(0,"REC",displocrowid,date,"TC",WardLocDr,0,DspId)) q:DspId=""  d
	..S AdmDr=$p(^DHCOEDISQTY(DspId),"^",26)
	..Q:AdmDr=""
	..Q:'$D(^PAADM(AdmDr))
	..S admward=$P(^PAADM(AdmDr),"^",70) /// 病人所在病房
	..Q:##Class(web.DHCSTPIVA).IfQuitAdmStatusD(AdmDr)=1	//已经结算退出
	..i '$d(setbat(displocrowid,AdmDr,date,PID)) d
	...S RetBat=##Class(web.DHCSTPIVA).SetOeBatFreqNo(displocrowid,AdmDr,date,PID)	//设置批次//增加根据液体总量修改批次2012-08-02
	...s setbat(displocrowid,AdmDr,date,PID)=RetBat
	../// 床号
 	..S bedid=$P(^PAADM(AdmDr),"^",73)
 	..S bed="*"
 	..I bedid'="" D
 	...S wardid=$P(bedid,"||",1)
 	...S bedsub=$P(bedid,"||",2)
 	...I $D(^PAWARD(wardid,"BED",bedsub)) S bed=$P(^PAWARD(wardid,"BED",bedsub),"^",1)
	..s OrdItmRowid=$p(^DHCOEDISQTY(DspId),"^",1)     ;OE_OrdItem表指针
    ..s OrdExeRowid=$p(^DHCOEDISQTY(DspId),"^",3)     ;OE_OrdExec表指针
    ..s ord=$p(OrdItmRowid,"||",1)
    ..s chl=$p(OrdItmRowid,"||",2)
	..S oeori=ord_"||"_chl
	..Q:##Class(web.DHCSTPIVA).IfQuitPIVA(oeori)=1 //是否可配液
	../// 非执行医嘱
	..//Q:$O(^OEORD(ord,"I",chl,"X",0))=""
	..s remark=##class(web.DHCSTPIVA).GetOrdItmRemark(oeori)
	..///配液分类
	..Q:(tPType'="")&(remark'[tPType) 
	..S moeori=##class(web.DHCSTPIVA).GetMainOeori(oeori)	/// 主医嘱
	..i LastMainOrd'=moeori d
	...s ptypestr=##class(web.DHCSTPIVA).GetAuditedType(moeori)
	...s typeID=$p(ptypestr,"^",1)
	..Q:(tOecType'="")&(tOecType'=$g(typeID))
	../// 医嘱状态
 	..s ChkOrdState=##class(web.DHCSTCOMMONSRV).GetOrdState(OrdExeRowid)
	..q:ChkOrdState'=1
 	../// 配伍审核
 	..S chstr=##class(web.DHCSTPIVA).GetPassResult(moeori)
 	..//Q:chstr=""	/// 未审核
	..Q:$p(chstr,",",4)="SHJJ" /// 配伍审核拒绝
	../// 医嘱优先级
	..S pri=##class(web.DHCSTPIVA).GetOePriority(moeori)
	..S pridr=$P(pri,"^",1)
	..Q:pridr=""
	..Q:$O(^PIVAO(0,"OECPR",displocrowid,pridr,""))=""  	/// 没有维护科室配液的医嘱优先级
	..Q:(tOecpr'="")&(tOecpr'=pridr)				/// 与选择优先级不一致
	..S pricode=$P(pri,"^",2)
	..S pricode=$ZCVT(pricode,"U")
	../// 护士审核
	..S Audited=##class(web.DHCSTCOMMONSRV).IfAuditByPriority(DspId)
	..//Q:(tNotAudit'="on")&(Audited=0) /// 护士未审核
	../// 皮试
	../// Q:##class(web.DHCSTPIVA).SkinTest(oeori)<0
	../// 取维护的“空”批次数量
	..S knum=##class(web.DHCSTPIVA).GetKBatNum()
	../// 关联医嘱标志
	..S seqflag=##class(web.DHCSTPIVA).GetOISeqFlag(oeori)
	..Q:(knum>0)&(seqflag=1)&(tBatNo["空")
 	..Q:(knum>0)&(seqflag=0)&(tBatNo'="")&(tBatNo'["空")
 	../// 医嘱子分类
 	..S arccat=##class(web.DHCSTPIVA).GetArcItmCat(oeori)
 	..S arccatid=$P(arccat,"^",1)
 	..Q:arccatid=""
 	..Q:$O(^PIVAA(0,"ARCIC",arccatid,""))=""	/// 配液医嘱子分类没有维护
 	../// 频率代码
 	..S freqstr=##class(web.DHCSTPIVA).GetFreq(oeori)
 	..S freq=$P(freqstr,"^",1)
 	..S freqcode=$P(freqstr,"^",2)
 	..S freqcode2=$ZCVT(freqcode,"U")
 	..Q:freq=""
 	..S incitm=##class(web.DHCSTPIVA).GetIncItm(oeori)
 	..S inci=$P(incitm,"^",1)
 	..S qflag=0
 	..I tItmID'="" D
 	...S qflag=##class(web.DHCSTPIVA).ChkExItm(oeori,tItmID)
 	..Q:(tItmID'="")&(qflag=0) 
 	..//S sttdate=$P(^OEORD(ord,"I",chl,1),"^",9)	/// 执行日期
 	..//S stttime=$P(^OEORD(ord,"I",chl,1),"^",10)	/// 执行时间
 	..S sttdate=date
 	..s stttime=$p(^DHCOEDISQTY(DspId),"^",20)  ;分发时间
 	..i stttime'="" S stttime=$zt(stttime,1) 	/// 执行时间
 	..S sttdate2=$zd(sttdate,3)  //_" "_stttime
 	..S seqno=$P(^OEORD(ord,"I",chl,3),"^",4)		/// 关联医嘱号
 	..s exStr=oeori_"^"_DspId
 	..s price=##class(web.DHCSTPRICE).GetSp(inci,sttdate,"",HospID,"",exStr)
 	..//s price=##class(web.DHCSTCOMMONSRV).GetPriceElse(inci,sttdate,"")
 	..S grpno=$p(^DHCOEDISQTY(DspId),"^",4)
 	..S mdodis=##class(web.DHCSTPIVA).GetMainOEDispID(DspId,grpno)
 	..S nextnumber=cnumber
 	..S specstate=""
 	..S pogi=##class(web.DHCSTPIVA).GetOGrpI(DspId)
 	..I pogi'="" D
 	...S psdr=$P(^PIVA(+pogi),"^",6)
 	...S nextstr=##class(web.DHCSTPIVA).GetNextStat(psdr,displocrowid,type)	 ///下一个状态
 	...S nextnumber=$P(nextstr,"^",2)
 	...S specstate=$P(^PIVA(+pogi),"^",8)
 	..Q:nextnumber'=cnumber
 	..Q:(specstate="C")!(specstate="R")
 	../// 护士审核
 	..S stttime=$p(^DHCOEDISQTY(DspId),"^",20)
 	..I mdodis'="" D
 	...I $D(^DHCOEDISQTY(mdodis)) S stttime=$p(^DHCOEDISQTY(mdodis),"^",20)	/// 执行时间
 	..S batno=##class(web.DHCSTPIVA).GetUpBatNo(mdodis,grpno)	/// 修改过的批次，如没有修改过再正常取
 	..S:batno="" batno=##class(web.DHCSTPIVA).GetBatNo(displocrowid,stttime,seqflag)
 	..//S:batno="" batno=1
 	..S batno=##class(web.DHCSTPIVA).GetOeBatFreqNo(mdodis,PID) //根据规则取批次
 	..Q:batno=""
 	..Q:(tBatNo'="")&(tBatNo'=batno)
 	..I '$D(^TMP("PIVA",PID,"PNO",mdodis,grpno)) D
 	...S pno=pno+1
 	...S ^TMP("PIVA",PID,"PNO",mdodis,grpno)=pno
 	..s LastMainOrd=moeori
 	..S papmi=$p(^PAADM(AdmDr),"^",1) 
	..S paname=$P(^PAPER(papmi,"ALL"),"^",1)
	..S ipno=$P(^PAPER(papmi,"PAT",1),"^",1)
 	..S i=i+1
 	..//S j=sttdate2_"||"_bed_"||"_batno_"||"_grpno_"||"_seqno
 	..S j=sttdate2_"||"_bed_"||"_ipno_"||"_batno_"||"_grpno_"||"_mdodis //zhouyg 20140226
 	..S ^TMP("PIVA",PID,"D","ADM",j,i)=AdmDr
 	..S ^TMP("PIVA",PID,"D","OEORI",j,i)=oeori
 	..S ^TMP("PIVA",PID,"D","DODIS",j,i)=DspId
 	..S ^TMP("PIVA",PID,"D","PRICE",j,i)=price
 	..S ^TMP("PIVA",PID,"D","GRPNO",j,i)=grpno
 	..S ^TMP("PIVA",PID,"D","PTYPE",j,i)=ptypestr
 	..S ^TMP("PIVA",PID,"D","EXDATE",j,i)=sttdate2
 	..S ^TMP("PIVA",PID,"D","BED",j,i)=bed
 	..S ^TMP("PIVA",PID,"D","BATNO",j,i)=batno
 	
 	..
	I i>0 S ^TMP("PIVA",PID,"DSUM")=i_"^"_pno
	Q:i>0 PID
	Q ""
}

ClassMethod CollAdm(displocrowid As %String, tAdmID As %String, tStartDate As %String, tEndDate As %String, tBatNo As %String, tOecpr As %String, tItmID As %String, tNoQty As %String, tNotAudit As %String, tPType As %String, tOecType As %String) As %Integer
{
	N (displocrowid, tAdmID, tStartDate, tEndDate, tBatNo, tOecpr, tItmID, tNoQty,tNotAudit,tPType,tOecType)	
	S PID=..NewPid()
	Q:displocrowid="" ""
	Q:tAdmID="" ""
	Q:tStartDate="" ""
	Q:tEndDate="" ""
	Q:$O(^PIVAA(0))="" ""	/// 配液的医嘱子分类没有维护
	Q:$O(^PIVAO(0,"OECPR",displocrowid,""))="" ""	/// 科室配液的医嘱优先级没有维护
	Q:$O(^PIVABT(0,"TIME",displocrowid,""))="" ""	/// 科室配液的时间段分批没有维护
	D ..ClearAllTmp(PID)
	S cnumber=10  /// 10固定为打签状态
	s pstype="I"  ///住院
	S ord=$o(^OEORD(0,"Adm",tAdmID,""))
 	Q:ord="" ""
 	Q:##Class(web.DHCSTPIVA).IfQuitAdmStatusD(tAdmID)=1 ""	//已经结算退出
 	S admward=$P(^PAADM(tAdmID),"^",70) /// 病人所在病房
 	/// 床号
 	S bedid=$P(^PAADM(tAdmID),"^",73)
 	S bed="*",wardid="*"
 	I bedid'="" D
 	.S wardid=$P(bedid,"||",1)
 	.S bedsub=$P(bedid,"||",2)
 	.I $D(^PAWARD(wardid,"BED",bedsub)) S bed=$P(^PAWARD(wardid,"BED",bedsub),"^",1)
 	S ^TMP("PIVA",PID,"M")=displocrowid_"^"_admward_"^"_tStartDate_"^"_tEndDate
	s HospID=$p($g(^CTLOC(displocrowid)),"^",22)
	S i=0,pno=0
	s LastMainOrd=""
	F date=tStartDate:1:tEndDate D
	.S DspId=""
	.f  s DspId=$o(^DHCOEDISQTY(0,"ADM",displocrowid,date,"TC",tAdmID,DspId)) q:DspId=""  d
	..s OrdItmRowid=$p(^DHCOEDISQTY(DspId),"^",1)     ;OE_OrdItem表指针
    ..s OrdExeRowid=$p(^DHCOEDISQTY(DspId),"^",3)     ;OE_OrdExec表指针
    ..s ord=$p(OrdItmRowid,"||",1)
    ..s chl=$p(OrdItmRowid,"||",2)
	..S oeori=ord_"||"_chl
	..i '$d(setbat(displocrowid,tAdmID,date,PID)) d
	...S RetBat=##Class(web.DHCSTPIVA).SetOeBatFreqNo(displocrowid,tAdmID,date,PID)	//设置批次//增加根据液体总量修改批次2012-08-02
	...s setbat(displocrowid,tAdmID,date,PID)=RetBat
	..Q:##Class(web.DHCSTPIVA).IfQuitPIVA(oeori)=1 //是否可配液
	..///配液分类
	..s remark=##class(web.DHCSTPIVA).GetOrdItmRemark(oeori)
	..S moeori=##class(web.DHCSTPIVA).GetMainOeori(oeori)	/// 主医嘱
	..i LastMainOrd'=moeori d
	...s ptypestr=##class(web.DHCSTPIVA).GetAuditedType(moeori)
	...s typeID=$p(ptypestr,"^",1)
	..Q:(tOecType'="")&(tOecType'=$g(typeID))
	..
	../// 医嘱状态
	..S ChkOrdState=##class(web.DHCSTCOMMONSRV).GetOrdState(OrdExeRowid)
 	..Q:ChkOrdState'=1
 	../// 配伍审核
 	..S chstr=##class(web.DHCSTPIVA).GetPassResult(moeori)
 	..//Q:chstr=""	/// 未审核
	..Q:$p(chstr,",",4)="SHJJ" /// 配伍审核拒绝
	../// 医嘱优先级
	..S pri=##class(web.DHCSTPIVA).GetOePriority(moeori)
	..//
	..S pridr=$P(pri,"^",1)
	..Q:pridr=""
	..Q:$O(^PIVAO(0,"OECPR",displocrowid,pridr,""))=""  	/// 没有维护科室配液的医嘱优先级
	..Q:(tOecpr'="")&(tOecpr'=pridr)				/// 与选择优先级不一致
	..S pricode=$P(pri,"^",2)
	..S pricode=$ZCVT(pricode,"U")
	../// 护士审核
	..S Audited=##class(web.DHCSTCOMMONSRV).IfAuditByPriority(DspId)
	..//Q:(Audited=0) /// 护士未审核
	../// 皮试
	../// Q:##class(web.DHCSTPIVA).SkinTest(oeori)<0
	../// 取维护的“空”批次数量
	..S knum=##class(web.DHCSTPIVA).GetKBatNum()
	../// 关联医嘱标志
	..S seqflag=##class(web.DHCSTPIVA).GetOISeqFlag(oeori)
	..//Q:(knum>0)&(seqflag=1)&(tBatNo["空")
 	..//Q:(knum>0)&(seqflag=0)&(tBatNo'="")&(tBatNo'["空")
 	../// 医嘱子分类
 	..S arccat=##class(web.DHCSTPIVA).GetArcItmCat(oeori)
 	..S arccatid=$P(arccat,"^",1)
 	..Q:arccatid=""
 	..Q:$O(^PIVAA(0,"ARCIC",arccatid,""))=""	/// 配液医嘱子分类没有维护
 	../// 频率代码
 	..S freqstr=##class(web.DHCSTPIVA).GetFreq(oeori)
 	..S freq=$P(freqstr,"^",1)
 	..S freqcode=$P(freqstr,"^",2)
 	..S freqcode2=$ZCVT(freqcode,"U")
 	..Q:freq=""
 	..S qflag=0
 	..I tItmID'="" D
 	...S qflag=##class(web.DHCSTPIVA).ChkExItm(oeori,tItmID)
 	..Q:(tItmID'="")&(qflag=0)
 	..///
 	..S incitm=##class(web.DHCSTPIVA).GetIncItm(oeori)
 	..S inci=$P(incitm,"^",1)
 	..S sttdate=date //$P(^OEORD(ord,"I",chl,1),"^",9)	/// 执行日期
 	..S sttdate2=$zd(sttdate,3)
 	..S seqno=$P(^OEORD(ord,"I",chl,3),"^",4)		/// 关联医嘱号
 	..s exStr=oeori_"^"_DspId
 	..s price=##class(web.DHCSTPRICE).GetSp(inci,sttdate,"",HospID,"",exStr)
 	..//S price=##class(web.DHCSTCOMMONSRV).GetPriceElse(inci,sttdate,"")
 	..S nextnumber=cnumber
 	..S specstate=""
 	..S grpno=$p(^DHCOEDISQTY(DspId),"^",4)
 	..S mdodis=##class(web.DHCSTPIVA).GetMainOEDispID(DspId,grpno)
 	..S pogi=##class(web.DHCSTPIVA).GetOGrpI(DspId)
 	..I pogi'="" D
 	...S psdr=$P(^PIVA(+pogi),"^",6)
 	...S nextstr=##class(web.DHCSTPIVA).GetNextStat(psdr,displocrowid,pstype)	 ///下一个状态
 	...S nextnumber=$P(nextstr,"^",2)
 	...S specstate=$P(^PIVA(+pogi),"^",8)
 	..Q:nextnumber'=cnumber
 	..Q:(specstate="C")!(specstate="R")
 	../// 护士审核
 	..I mdodis'="" D
 	...I $D(^DHCOEDISQTY(mdodis)) S stttime=$p(^DHCOEDISQTY(mdodis),"^",20)	/// 执行时间
 	...E  S stttime=$p(^DHCOEDISQTY(DspId),"^",20)
 	..S batno=##class(web.DHCSTPIVA).GetUpBatNo(mdodis,grpno)	/// 修改过的批次，如没有修改过再正常取
 	..S:batno="" batno=##class(web.DHCSTPIVA).GetBatNo(displocrowid,stttime,seqflag)
 	..//S:batno="" batno=1
 	..S batno=##class(web.DHCSTPIVA).GetOeBatFreqNo(mdodis,PID)
 	..Q:batno=""
 	..Q:(tBatNo'="")&(tBatNo'=batno)
 	..I '$D(^TMP("PIVA",PID,"PNO",mdodis,grpno)) D
 	...S pno=pno+1
 	...S ^TMP("PIVA",PID,"PNO",mdodis,grpno)=pno
 	..s LastMainOrd=moeori
 	..S papmi=$p(^PAADM(tAdmID),"^",1) 
	..S paname=$P(^PAPER(papmi,"ALL"),"^",1)
	..S ipno=$P(^PAPER(papmi,"PAT",1),"^",1)
 	..S i=i+1
 	..//S j=sttdate2_"||"_bed_"||"_batno_"||"_grpno_"||"_seqno
 	..S j=sttdate2_"||"_bed_"||"_ipno_"||"_batno_"||"_grpno_"||"_mdodis	//zhouyg 20140226
 	..S ^TMP("PIVA",PID,"D","ADM",j,i)=tAdmID
 	..S ^TMP("PIVA",PID,"D","OEORI",j,i)=oeori
 	..S ^TMP("PIVA",PID,"D","DODIS",j,i)=DspId
 	..S ^TMP("PIVA",PID,"D","PRICE",j,i)=price
 	..S ^TMP("PIVA",PID,"D","GRPNO",j,i)=grpno
 	..S ^TMP("PIVA",PID,"D","PTYPE",j,i)=ptypestr
 	..S ^TMP("PIVA",PID,"D","EXDATE",j,i)=sttdate2
 	..S ^TMP("PIVA",PID,"D","BED",j,i)=bed
 	..S ^TMP("PIVA",PID,"D","BATNO",j,i)=batno
	I i>0 S ^TMP("PIVA",PID,"DSUM")=i_"^"_pno
	Q:i>0 PID
	Q ""
}

ClassMethod GetData(pid As %String, jj As %String, ii As %String, lipno As %String, colortype As %String) As %String
{
	N (pid,jj,ii,lipno,colortype)
	S adm=^TMP("PIVA",pid,"D","ADM",jj,ii)
	S oeori=^TMP("PIVA",pid,"D","OEORI",jj,ii)
	S dodis=^TMP("PIVA",pid,"D","DODIS",jj,ii)
	S price=^TMP("PIVA",pid,"D","PRICE",jj,ii)
	S grpno=^TMP("PIVA",pid,"D","GRPNO",jj,ii)
	S ptypestr=^TMP("PIVA",pid,"D","PTYPE",jj,ii)
	S drugcatdr=$p(ptypestr,"^",1) //药学分类(或子类)rowid
	S drugcatdesc=$p(ptypestr,"^",2) //药学分类(或子类)描述
	S stdate=^TMP("PIVA",pid,"D","EXDATE",jj,ii)
	S bed=^TMP("PIVA",pid,"D","BED",jj,ii)
	S batno=^TMP("PIVA",pid,"D","BATNO",jj,ii)
	S ord=$P(oeori,"||",1)
	S itm=$P(oeori,"||",2)
	S seqno=$P(^OEORD(ord,"I",itm,3),"^",4)		/// 关联医嘱号
	S papmi=$p(^PAADM(adm),"^",1) 
	S paname=$P(^PAPER(papmi,"ALL"),"^",1)
	S ipno=$P(^PAPER(papmi,"PAT",1),"^",1)
	I dodis="" S qty="*"
	E  S qty=$P(^DHCOEDISQTY(dodis),"^",11)
	S uomdr=$P(^DHCOEDISQTY(dodis),"^",6)
	S uomdesc="*"
	S:$D(^CT("UOM",uomdr)) uomdesc=$P(^CT("UOM",uomdr),"^",2)
	S oestate=##class(web.DHCSTPIVA).GetOeState(oeori)
	S oestate=$P(oestate,"^",2)
	S pristr=##class(web.DHCSTPIVA).GetOePriority(oeori)
	S pridr=$P(pristr,"^",1)
	S pridesc=$P(pristr,"^",3)
	S incitm=##class(web.DHCSTPIVA).GetIncItm(oeori)
 	S inci=$P(incitm,"^",1)
 	S incidesc=$P(incitm,"^",3)
	S spec=##class(web.DHCSTCOMINC).GetSpec(inci)
	S dosage=##class(web.DHCSTPIVA).GetDosage(oeori)
	S freq=##class(web.DHCSTPIVA).GetFreq(oeori)
	S freq=$P(freq,"^",2)
	S instruc=##class(web.DHCSTPIVA).GetInstruc(oeori)	/// 用法
	S dura=##class(web.DHCSTPIVA).GetDura(oeori)	/// 疗程
	S presc=$P(^OEORD(ord,"I",itm,1),"^",14)	/// 处方号
	S doctor=##class(web.DHCSTPIVA).GetDoctor(oeori)	/// 医生
	S moeori=##class(web.DHCSTPIVA).GetMainOeori(oeori)
	S mdodis=##class(web.DHCSTPIVA).GetMainOEDispID(dodis,grpno)
	S batupno=##class(web.DHCSTPIVA).GetUpBatNo(mdodis,grpno)	/// 修改的批次
 	I mdodis'="" D
 	.I $D(^DHCOEDISQTY(mdodis)) S stttime=$p(^DHCOEDISQTY(mdodis),"^",20)	/// 执行时间
 	E  S stttime=$p(^DHCOEDISQTY(dodis),"^",20)
 	S:stttime'="" stttime=$ZT(stttime,1)
 	S sign=##class(web.DHCSTPIVA).GetPrintSign(oeori)	/// 打印标志
 	S comp=##class(web.DHCSTPIVA).GetCompFlag(oeori)	/// 剂量是否整包装	
 	//S nuraudited="" /// 是否护士审核
 	S nuraudited=##class(web.DHCSTCOMMONSRV).GetNurAuditStr(dodis)
 	s nuraudited=$s(nuraudited'="":"已审核",1:"未审核")
 	S phstr=$P(^OEORD(ord,"I",itm,7),"^",3)
 	S phaudituser=$P(phstr,",",1)
 	I phaudituser'="" D
 	.I $D(^SSU("SSUSR",phaudituser)) S phaudituser=$P(^SSU("SSUSR",phaudituser),"^",2)
 	S phauditflag=$P(phstr,",",4)
 	S pno=^TMP("PIVA",pid,"PNO",mdodis,grpno)
 	S chstr=##class(web.DHCSTPIVA).GetPassResult(oeori)
	S passresult=$p(chstr,",",4)
	S orddate=$P(^OEORD(ord,"I",itm,3),"^",7)
 	S ordtime=$P(^OEORD(ord,"I",itm,1),"^",17)
 	i orddate'="" s orddate=$zd(orddate,3)
	i ordtime'="" s ordtime=$zt(ordtime,1)
	s remark=##class(web.DHCSTPIVA).GetOrdItmRemark(oeori)
	S freqcode2=$ZCVT(freq,"U")
	s colortype=##class(web.DHCSTPIVA).GetColorType(ipno,lipno,oestate,passresult,colortype,"")
	s ^TMP("PIVA",pid,"D","COLOR",jj,ii)=colortype
	S EncryptLevelInfo=""
	s EncryptLevel=""
	s PatLevel=""
	s HospID=""
    s EncryptFlag=##Class(web.DHCSTCOMMPARA).GetEncryptLevelFlag(HospID)
    i EncryptFlag=1 d
	.s EncryptLevelInfo=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(papmi,"")
 	.s EncryptLevel=$p(EncryptLevelInfo,"^",1)
 	.s PatLevel=$p(EncryptLevelInfo,"^",2)
 	S data=$LB(pid,batno,seqno,incidesc,ipno,bed,paname,freq,qty,price,oestate,dosage,spec,instruc,dura,presc,pridesc,doctor,stdate,stttime,comp,sign,dodis,grpno,pno,moeori,uomdesc,nuraudited,passresult,orddate,ordtime,remark,drugcatdr,drugcatdesc,mdodis,colortype,EncryptLevel,PatLevel)
 	Q data
}

ClassMethod NewPid() As %String
{
 	Q $I(^DHCSTPIVA("COLL"))
}

ClassMethod ClearAllTmp(pid As %String) As %String
{
	D ..CLEARTMP(pid,"D")
	D ..CLEARTMP(pid,"D2")
	D ..CLEARTMP(pid,"PNO")
	D ..CLEARTMP(pid,"M")
	D ..CLEARTMP(pid,"DSUM")
	D ..CLEARTMP(pid,"NOQTY")
	//D ..CLEARTMP(pid,"FBATNO")
}

ClassMethod CLEARTMP(pid As %String, PAR As %String) As %String
{
	K ^TMP("PIVA",pid,PAR)
}

/// 检查所在批次是否超过最大袋数
ClassMethod ChkBeforeUpdBat(mdodis As %String, grp As %String = "", bat As %String, ploc As %String = "", dsp, PID)
{
	n (mdodis, grp, bat, ploc, dsp,PID)
	s MaxNum=3 //每个批次最大数量
	Q:mdodis="" -1
	s:grp="" grp=$p(^DHCOEDISQTY(moeori),"^",4)
	Q:grp="" -2
	Q:bat="" -3
	S bat=$ZCVT(bat,"U")
	S chk=##class(web.DHCSTPIVA).CheckPLocBatNo(bat,ploc)
	Q:chk=1 -5
	Q:dsp="" -6
	s ret=##class(web.DHCSTPIVA).GetPogValid(mdodis,grp)
	q:+ret=1 -7 //已经打签
	S madmdr=$p(^DHCOEDISQTY(mdodis),"^",26)
	S admdr=$p(^DHCOEDISQTY(dsp),"^",26)
	q:admdr'=madmdr -8
	Q:admdr="" -9
	Q:'$D(^PAADM(admdr)) -12
	S exdate=$p(^DHCOEDISQTY(mdodis),"^",21)
	S recloc=$p(^DHCOEDISQTY(mdodis),"^",24)
	s num=+$g(^TMP("PIVA",PID,"FBATNUM",recloc,admdr,exdate,bat))
	q:num>=MaxNum -10 //超过批次袋数限制
	s oldbat=##class(web.DHCSTPIVA).GetOeBatFreqNo(mdodis, PID)
	q:oldbat="" -11
	s oldnum=+$g(^TMP("PIVA",PID,"FBATNUM",recloc,admdr,exdate,oldbat))
	q:oldnum<=0
	q 0
}

/// 更新/移动 批次 
/// input:mdodis 主打包表id ,grp 轮次 ,bat 批号 , ploc发药科室 ,PID 进程号 ,NumChk 是否检查(1 需要检查批次数量,0 无需检查批数量)
ClassMethod UpdBat(mdodis As %String, grp As %String, bat As %String, ploc As %String, dsp, PID, NumChk = 1)
{
	n (mdodis, grp, bat, ploc , dsp, PID,%session ,NumChk)
	Set $ZT="ERROR"
	s ret=0
	s:NumChk=1 ret=..ChkBeforeUpdBat(mdodis, grp, bat, ploc, dsp,PID) 
	q:ret'=0 ret
	s ret=##class(web.DHCSTPIVA).GetPogValid(mdodis,grp)
	q:+ret=1 -7 //已经打签
	//s ret=##class(web.DHCSTPIVAPRINTLABEL).UpdBat(mdodis, grp, bat, ploc, dsp) //修改批次和分发时间
	s ret=..OnlyUpdBatNotDodis(mdodis, grp, bat, ploc, dsp) //仅修改批次,没修改分发时间
	q:ret'=0 ret
	//更新临时global
	S admdr=$p(^DHCOEDISQTY(mdodis),"^",26)
	S exdate=$p(^DHCOEDISQTY(mdodis),"^",21)
	S recloc=$p(^DHCOEDISQTY(mdodis),"^",24)
	s oldbat=##class(web.DHCSTPIVA).GetOeBatFreqNo(mdodis, PID)
	s ^TMP("PIVA",PID,"FBATNUM",recloc,admdr,exdate,oldbat)=$g(^TMP("PIVA",PID,"FBATNUM",recloc,admdr,exdate,oldbat))-1
	s ^TMP("PIVA",PID,"FBATNUM",recloc,admdr,exdate,bat)=$g(^TMP("PIVA",PID,"FBATNUM",recloc,admdr,exdate,bat))+1
	s TMP("PIVA",PID,"FBATNO",recloc,admdr,exdate,mdodis)=bat
	q ret
ERROR
    Tro
    L //释放同一进程下的所有锁    
    s ErrorMsg=$ZE
    s ^TMPLIGAO("ErrorMsg","web.DHCSTPIVAUPDATEBAT.UpdBat",PID,mdodis,bat,$h)=mdodis_","_grp_","_ bat_","_ ploc _","_ dsp_","_ PID_","_NumChk_","_ErrorMsg
    q ErrorMsg
}

/// 仅修改批次,没修改分发时间
ClassMethod OnlyUpdBatNotDodis(moeori As %String, grp As %String = "", bat As %String, ploc As %String = "", dsp) As %String
{
	N (moeori,grp,bat,ploc,dsp,%session)
	Q:moeori="" -1
	s:grp="" grp=$p(^DHCOEDISQTY(moeori),"^",4)
	Q:grp="" -2
	Q:bat="" -3
	S puser=##class(web.DHCSTCOMWEB).GetUserID()
	Q:puser="" -4
	s:ploc="" ploc=$p(^DHCOEDISQTY(moeori),"^",24)
	q:ploc="" -5
	S bat=$ZCVT(bat,"U")
	S chk=##class(web.DHCSTPIVA).CheckPLocBatNo(bat,ploc)
	Q:chk=1 -5
	S grpno=$p(^DHCOEDISQTY(dsp),"^",4)
    S oeori=##class(web.DHCSTPIVA).GetMainOEDispID(dsp,grpno)
	Q:oeori'=moeori -6
	K PLIST
	S PLIST(2)=moeori
	S PLIST(3)=grp
	S PLIST(4)=bat
	S PLIST(5)=puser
	S PLIST(6)=+$H
	S PLIST(7)=$P($H,",",2)
	&SQL(Insert Into PIVA_BatUp Values :PLIST())
	Q SQLCODE
}

}
