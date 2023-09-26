Import SQLUser

/// 打印标签 10固定为打签的顺序号
Class web.DHCSTPIVAPRINTLABEL Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 293;

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

ClassMethod DispExecute(ByRef qHandle As %Binary, tPLocID As %String, tWardID As %String, tStartDate As %String, tEndDate As %String, tAdmID As %String, tBatNo As %String, tOecprID As %String, tItmID As %String, tNoQty As %String, tNotAudit As %String, tPType As %String, tOecType As %String, IfPlogFlag As %String) As %Status
{
	S repid=$I(^CacheTemp)
	S qHandle=$lb(0,repid,0)
	S ind=1
	Q:tPLocID="" $$$OK
	Q:tStartDate="" $$$OK
	Q:tEndDate="" $$$OK
	Q:(tWardID="")&(tAdmID="") $$$OK
	Q:$O(^PIVAA(0))="" $$$OK /// 没有维护医嘱类型
	
	S PID=""
	I tAdmID="" D //按病区检索
	.S PID=..CollWard(tPLocID, tWardID, tStartDate, tEndDate, tBatNo, tOecprID, tItmID, tNoQty,tNotAudit,tPType,tOecType,IfPlogFlag)
	E  D //按登记号检索
	.S PID=..CollAdm(tPLocID, tAdmID, tStartDate, tEndDate, tBatNo, tOecprID, tItmID, tNoQty,tNotAudit,tPType,tOecType,IfPlogFlag)
	Q:PID="" $$$OK
	S jj=""
	s lipno=""
	s colortype="W"
	F  S jj=$O(^TMP("PIVA",PID,"D","ADM",jj)) Q:jj=""  D
	.S sdate=$p(jj,"||",1)
	.S bed=$p(jj,"||",2)
	.S batno=$p(jj,"||",3)
	.S grp=$p(jj,"||",4)
	.
	.S ii=""
	.F  S ii=$O(^TMP("PIVA",PID,"D","ADM",jj,ii)) Q:ii=""  D
	..S Data=..GetData(PID,jj,ii,lipno,colortype)
	..S adm=^TMP("PIVA",PID,"D","ADM",jj,ii)
	..S papmi=$p(^PAADM(adm),"^",1)
	..S lipno=$P(^PAPER(papmi,"PAT",1),"^",1)
	..s colortype=^TMP("PIVA",PID,"D","COLOR",jj,ii)
	..S dodis=$LI(Data,"23")
	..S moeori=$LI(Data,"26")
	..S index1=sdate_"^"_bed_"^"_batno_"^"_grp_"^"_moeori  //打签顺序
	..S ^TMP("PIVA",PID,"D2",index1,dodis)=Data
	..S ^CacheTemp(repid,ind)=Data	
 	..S ind=ind+1
 	Q $$$OK
}

Query Disp(tPLocID As %String, tWardID As %String, tStartDate As %String, tEndDate As %String, tAdmID As %String, tBatNo As %String, tOecprID As %String, tItmID As %String, tNoQty As %String, tNotAudit As %String, tPType As %String, tOecType As %String, IfPlogFlag As %String) As %Query(ROWSPEC = "tbPID:%String,tbBatNo:%String,tbSeqNo:%String,tbItmDesc:%String,tbRegNo:%String,tbBedNo:%String,tbName:%String,tbFreq:%String,tbQty:%String,tbPrice:%String,tbOeStatus:%String,tbDosage:%String,tbSpec:%String,tbInst:%String,tbDura:%String,tbPresc:%String,tbOecpr:%String,tbDoctor:%String,tbOexeDate:%String,tbOexeTime:%String,tbCompare:%String,tbSign:%String,tbDSP:%String,tbGrpNo:%String,tbPrintNum:%String,tbMOeori:%String,tbUom:%String,tbNurAudit:%String,tbPass:%String,tbOrdDate:%String,tbOrdTime:%String,tremark:%String,tbDrugcatdr:%String,tbDrugcatdesc:%String,tbMdodis:%String,tbColorType:%String,TEncryptLevel:%String,TPatLevel:%String,tbPackState:%String,TNewOrdFlag:%String")
{
}

ClassMethod CollWard(tPLocID As %String, tWardID As %String, tStartDate As %String, tEndDate As %String, tBatNo As %String, tOecpr As %String, tItmID As %String, tNoQty As %String, tNotAudit As %String, tPType As %String, tOecType As %String, IfPlogFlag As %String) As %Integer
{
	N (tPLocID, tWardID, tStartDate, tEndDate, tBatNo, tOecpr, tItmID, tNoQty,tNotAudit,tPType,tOecType,%session,IfPlogFlag)
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
	s type="I"
	S ^TMP("PIVA",PID,"M")=tPLocID_"^"_tWardID_"^"_tStartDate_"^"_tEndDate
	s HospID=$p($g(^CTLOC(tPLocID)),"^",22)
	s LastMainOrd=""
	s WardLocDr=$p(^PAWARD(tWardID),"^",5)
	S i=0,pno=0
	F date=tStartDate:1:tEndDate D
	.S DspId=""
	.F  s DspId=$O(^DHCOEDISQTY(0,"REC",tPLocID,date,"TC",WardLocDr,0,DspId)) q:DspId=""  d
	..S AdmDr=$p(^DHCOEDISQTY(DspId),"^",26)
	..Q:AdmDr=""
	..Q:'$D(^PAADM(AdmDr))
	..S admward=$P(^PAADM(AdmDr),"^",70) /// 病人所在病房
	..Q:##Class(web.DHCSTPIVA).IfQuitAdmStatusD(AdmDr)=1	//已经结算退出
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
	..//Q:##Class(web.DHCSTPIVA).IfQuitPIVA(oeori)=1 //是否可配液 //zhouyg 20150624注释 SDG=0的就是配液的
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
 	..Q:chstr=""	/// 未审核
	..Q:$p(chstr,",",4)="SHJJ" /// 配伍审核拒绝
	../// 医嘱优先级
	..S pri=##class(web.DHCSTPIVA).GetOePriority(moeori)
	..S pridr=$P(pri,"^",1)
	..Q:pridr=""
	..Q:$O(^PIVAO(0,"OECPR",tPLocID,pridr,""))=""  	/// 没有维护科室配液的医嘱优先级
	..Q:(tOecpr'="")&(tOecpr'=pridr)				/// 与选择优先级不一致
	..S pricode=$P(pri,"^",2)
	..S pricode=$ZCVT(pricode,"U")
	../// 护士审核
	..S Audited=##class(web.DHCSTCOMMONSRV).IfAuditByPriority(DspId)
	..Q:(tNotAudit'="on")&(Audited=0) /// 护士未审核
	../// 打包过滤20160126
	..S PogFlag=##class(web.DHCSTPIVA).GetPlogFlag(DspId)   //是否正常打包
 	..S PogFlag=$p(PogFlag,"^",2)
 	..Q:(IfPlogFlag'="")&&(PogFlag="")
	../// 皮试
	../// Q:##class(web.DHCSTPIVA).SkinTest(oeori)<0
	../// 取维护的“空”批次数量
	..S knum=##class(web.DHCSTPIVA).GetKBatNum()
	../// 关联医嘱标志
	..S seqflag=##class(web.DHCSTPIVA).GetOISeqFlag(oeori)
	..//Q:(knum>0)&(seqflag=1)&(tBatNo["空")
 	..//Q:(knum>0)&(seqflag=0)&(tBatNo'="")&(tBatNo'["空")  //注释,不用,20160119,yunhaibao
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
 	...S nextstr=##class(web.DHCSTPIVA).GetNextStat(psdr,tPLocID,type)	 ///下一个状态
 	...S nextnumber=$P(nextstr,"^",2)
 	...S specstate=$P(^PIVA(+pogi),"^",8)
 	..Q:nextnumber'=cnumber
 	..Q:(specstate="C")!(specstate="R")
 	../// 护士审核
 	..S stttime=$p(^DHCOEDISQTY(DspId),"^",20)
 	..I mdodis'="" D
 	...I $D(^DHCOEDISQTY(mdodis)) S stttime=$p(^DHCOEDISQTY(mdodis),"^",20)	/// 执行时间
 	..S batno=##class(web.DHCSTPIVA).GetUpBatNo(mdodis,grpno)	/// 修改过的批次，如没有修改过再正常取
 	..S:batno="" batno=##class(web.DHCSTPIVA).GetBatNo(tPLocID,stttime,seqflag,$g(admward))
 	..S:batno="" batno=1
 	..Q:batno=""
 	..Q:(tBatNo'="")&(tBatNo'=batno)
 	..I '$D(^TMP("PIVA",PID,"PNO",mdodis,grpno)) D
 	...S pno=pno+1
 	...S ^TMP("PIVA",PID,"PNO",mdodis,grpno)=pno
 	..s LastMainOrd=moeori
 	..S i=i+1
 	..//S j=sttdate2_"||"_bed_"||"_batno_"||"_grpno_"||"_seqno
 	..S j=sttdate2_"||"_bed_"||"_batno_"||"_grpno_"||"_mdodis //zhouyg 20140226
 	..S ^TMP("PIVA",PID,"D","ADM",j,i)=AdmDr
 	..//s ^xuantmp("pidlabel")=PID
 	..S ^TMP("PIVA",PID,"D","OEORI",j,i)=OrdExeRowid	//zhouyg 20151110 oeori改为OrdExeRowid
 	..S ^TMP("PIVA",PID,"D","DODIS",j,i)=DspId
 	..S ^TMP("PIVA",PID,"D","PRICE",j,i)=price
 	..S ^TMP("PIVA",PID,"D","GRPNO",j,i)=grpno
 	..S ^TMP("PIVA",PID,"D","PTYPE",j,i)=ptypestr
 	..S ^TMP("PIVA",PID,"D","PACKSTATE",j,i)=PogFlag
	I i>0 S ^TMP("PIVA",PID,"DSUM")=i_"^"_pno
	Q:i>0 PID
	Q ""
}

ClassMethod CollAdm(tPLocID As %String, tAdmID As %String, tStartDate As %String, tEndDate As %String, tBatNo As %String, tOecpr As %String, tItmID As %String, tNoQty As %String, tNotAudit As %String, tPType As %String, tOecType As %String, IfPlogFlag As %String) As %Integer
{
	N (tPLocID, tAdmID, tStartDate, tEndDate, tBatNo, tOecpr, tItmID, tNoQty,tNotAudit,tPType,tOecType,IfPlogFlag)	
	S PID=..NewPid()
	Q:tPLocID="" ""
	Q:tAdmID="" ""
	Q:tStartDate="" ""
	Q:tEndDate="" ""
	Q:$O(^PIVAA(0))="" ""	/// 配液的医嘱子分类没有维护
	Q:$O(^PIVAO(0,"OECPR",tPLocID,""))="" ""	/// 科室配液的医嘱优先级没有维护
	Q:$O(^PIVABT(0,"TIME",tPLocID,""))="" ""	/// 科室配液的时间段分批没有维护
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
 	S ^TMP("PIVA",PID,"M")=tPLocID_"^"_admward_"^"_tStartDate_"^"_tEndDate
	s HospID=$p($g(^CTLOC(tPLocID)),"^",22)
	S i=0,pno=0
	s LastMainOrd=""
	F date=tStartDate:1:tEndDate D
	.S DspId=""
	.f  s DspId=$o(^DHCOEDISQTY(0,"ADM",tPLocID,date,"TC",tAdmID,DspId)) q:DspId=""  d
	..s OrdItmRowid=$p(^DHCOEDISQTY(DspId),"^",1)     ;OE_OrdItem表指针
    ..s OrdExeRowid=$p(^DHCOEDISQTY(DspId),"^",3)     ;OE_OrdExec表指针
    ..s ord=$p(OrdItmRowid,"||",1)
    ..s chl=$p(OrdItmRowid,"||",2)
	..S oeori=ord_"||"_chl
	..s SDG=$p(^DHCOEDISQTY(DspId),"^",27)	//zhouyg 20150624  SDG=0的才是配液的
	..q:SDG'=0
	..//Q:##Class(web.DHCSTPIVA).IfQuitPIVA(oeori)=1 //是否可配液
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
 	..Q:chstr=""	/// 未审核
	..Q:$p(chstr,",",4)="SHJJ" /// 配伍审核拒绝
	../// 医嘱优先级
	..S pri=##class(web.DHCSTPIVA).GetOePriority(moeori)
	..//
	..S pridr=$P(pri,"^",1)
	..Q:pridr=""
	..Q:$O(^PIVAO(0,"OECPR",tPLocID,pridr,""))=""  	/// 没有维护科室配液的医嘱优先级
	..Q:(tOecpr'="")&(tOecpr'=pridr)				/// 与选择优先级不一致
	..S pricode=$P(pri,"^",2)
	..S pricode=$ZCVT(pricode,"U")
	../// 护士审核
	..S Audited=##class(web.DHCSTCOMMONSRV).IfAuditByPriority(DspId)
	..Q:(Audited=0) /// 护士未审核
	../// 打包过滤,20160126
	..S PogFlag=##class(web.DHCSTPIVA).GetPlogFlag(DspId)   //是否正常打包
 	..S PogFlag=$p(PogFlag,"^",2)
 	..Q:(IfPlogFlag'="")&&(PogFlag="") 
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
 	...S nextstr=##class(web.DHCSTPIVA).GetNextStat(psdr,tPLocID,pstype)	 ///下一个状态
 	...S nextnumber=$P(nextstr,"^",2)
 	...S specstate=$P(^PIVA(+pogi),"^",8)
 	..Q:nextnumber'=cnumber
 	..Q:(specstate="C")!(specstate="R")
 	../// 护士审核
 	..I mdodis'="" D
 	...I $D(^DHCOEDISQTY(mdodis)) S stttime=$p(^DHCOEDISQTY(mdodis),"^",20)	/// 执行时间
 	...E  S stttime=$p(^DHCOEDISQTY(dodis),"^",20)
 	..S batno=##class(web.DHCSTPIVA).GetUpBatNo(mdodis,grpno)	/// 修改过的批次，如没有修改过再正常取
 	..//w moeori
 	..S:batno="" batno=##class(web.DHCSTPIVA).GetBatNo(tPLocID,stttime,seqflag,$g(admward))
 	..S:batno="" batno=1
 	..Q:batno=""
 	..Q:(tBatNo'="")&(tBatNo'=batno)
 	..I '$D(^TMP("PIVA",PID,"PNO",mdodis,grpno)) D
 	...S pno=pno+1
 	...S ^TMP("PIVA",PID,"PNO",mdodis,grpno)=pno
 	..s LastMainOrd=moeori
 	..S i=i+1
 	..//S j=sttdate2_"||"_bed_"||"_batno_"||"_grpno_"||"_seqno
 	..S j=sttdate2_"||"_bed_"||"_batno_"||"_grpno_"||"_mdodis	//zhouyg 20140226
 	..S ^TMP("PIVA",PID,"D","ADM",j,i)=tAdmID
 	..S ^TMP("PIVA",PID,"D","OEORI",j,i)=OrdExeRowid	//20151110 zhouyg oeori改为OrdExeRowid
 	..S ^TMP("PIVA",PID,"D","DODIS",j,i)=DspId
 	..S ^TMP("PIVA",PID,"D","PRICE",j,i)=price
 	..S ^TMP("PIVA",PID,"D","GRPNO",j,i)=grpno
 	..S ^TMP("PIVA",PID,"D","PTYPE",j,i)=ptypestr
 	..S ^TMP("PIVA",PID,"D","PACKSTATE",j,i)=PogFlag
	I i>0 S ^TMP("PIVA",PID,"DSUM")=i_"^"_pno
	Q:i>0 PID
	Q ""
}

ClassMethod GetData(pid As %String, jj As %String, ii As %String, lipno As %String, patcolor As %String) As %String
{
	N (pid,jj,ii,lipno,patcolor)
	S adm=^TMP("PIVA",pid,"D","ADM",jj,ii)
	S oeori=^TMP("PIVA",pid,"D","OEORI",jj,ii)
	S dodis=^TMP("PIVA",pid,"D","DODIS",jj,ii)
	S price=^TMP("PIVA",pid,"D","PRICE",jj,ii)
	S grpno=^TMP("PIVA",pid,"D","GRPNO",jj,ii)
	S ptypestr=^TMP("PIVA",pid,"D","PTYPE",jj,ii)
	S drugcatdr=$p(ptypestr,"^",1) //药学分类(或子类)rowid
	S drugcatdesc=$p(ptypestr,"^",2) //药学分类(或子类)描述
	s PackState=^TMP("PIVA",pid,"D","PACKSTATE",jj,ii)
	s oeoreID=oeori	//zhouyg 20151110 临时global已经保存为执行id
	S stdate=$P(jj,"||",1)
	S bed=$P(jj,"||",2)
	S batno=$P(jj,"||",3)
	//S seqno=$P(jj,"||",5)
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
	//S oestate=##class(web.DHCSTPIVA).GetOeState(oeori)
	S oestate=##class(web.DHCSTPIVA).GetOrdExeState(oeoreID)	//zhouyg 20151110 改为取执行状态
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
	s colortypeStr=##class(web.DHCSTPIVA).GetColorType(ipno,lipno,oestate,passresult,patcolor,"")
	s colortype=$p(colortypeStr,"^",1)
 	s patcolor=$p(colortypeStr,"^",2)
	s ^TMP("PIVA",pid,"D","COLOR",jj,ii)=patcolor
	s firstdodis=$o(^DHCOEDISQTY(0,"OEORI",$p(oeori,"||",1,2),""))
	s dodisdate=$p(^DHCOEDISQTY(firstdodis),"^",21)
	i dodisdate=+$h s NewOrdFlag="Y" //yunhaibao20160315,新医嘱标志,首条用药日期等于今天
	e  s NewOrdFlag=""
	S EncryptLevelInfo=""
	s EncryptLevel=""
	s PatLevel=""
	s HospID=""
    s EncryptFlag=##Class(web.DHCSTCOMMPARA).GetEncryptLevelFlag(HospID)
    i EncryptFlag=1 d
	.s EncryptLevelInfo=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(papmi,"")
 	.s EncryptLevel=$p(EncryptLevelInfo,"^",1)
 	.s PatLevel=$p(EncryptLevelInfo,"^",2)
 	S data=$LB(pid,batno,seqno,incidesc,ipno,bed,paname,freq,qty,price,oestate,dosage,spec,instruc,dura,presc,pridesc,doctor,stdate,stttime,comp,sign,dodis,grpno,pno,moeori,uomdesc,nuraudited,passresult,orddate,ordtime,remark,drugcatdr,drugcatdesc,mdodis,colortype,EncryptLevel,PatLevel,PackState,NewOrdFlag)
 	Q data
}

/// 保存打签数据分1-2-3-4
ClassMethod SaveDispOld(pid As %String) As %String
{
	N (pid,%session)
	S puser=##class(web.DHCSTCOMWEB).GetUserID()
	Q:puser="" -1
	S pdatef=$P(^TMP("PIVA",pid,"M"),"^",3)
	S pdatet=$P(^TMP("PIVA",pid,"M"),"^",4)
	S ploc=$P(^TMP("PIVA",pid,"M"),"^",1)
	S pward=$P(^TMP("PIVA",pid,"M"),"^",2)
	Q:ploc="" -2
	L +^DHCSTLOCK("PIVA",pid):5  E  Q -100
	S pharowid=""
	S i=0,quitflag=0
	TSTART
	F  S i=$O(^TMP("PIVA",pid,"D2",i)) Q:(i="")!(quitflag'=0)  D
	.S tstr=^TMP("PIVA",pid,"D2",i)
	.Q:$LL(tstr)=0	/// list number is zero
	./// 1 保存发药主表
	.S:pharowid="" pharowid=..InsPhaCollected(ploc,pward,puser,pdatef,pdatet)
	.I pharowid<0 S quitflag=-3
	.Q:quitflag<0
	..//$LB(pid,batno,seqno,arcimdesc,ipno,bed,paname,freq,qty,price,oestate,dosage,spec,instruc,dura,presc,pridesc,doctor,stdate,stttime,comp,sign,dodis,grpno,pno,moeori,uomdesc)
	.S batno=$LI(tstr,2)
	.S grpno=$LI(tstr,24)
	.S stdate=$LI(tstr,19)
	.S sttime=$LI(tstr,20)
	.S dodis=$LI(tstr,23)
	.S pno=$LI(tstr,25)
	.S moeori=$LI(tstr,26)
	.S:stdate'="" stdate=$ZDH(stdate,3)
	.S:sttime'="" sttime=$ZTH(sttime,1)
	./// 2 保存医嘱组主表
	.S pogid=..GetOrdGrpID(moeori,grpno)
	.S:pogid="" pogid=..InsOrdGrp(ploc,moeori,grpno,batno,stdate,sttime,pharowid,pno,puser)
	.I pogid<0 S quitflag=-4
	.Q:quitflag<0
	./// 3 保存医嘱组子表
	.S pogiid=..InsOrdGrpItm(pogid,dodis)
	.I +pogiid<0 S quitflag=-5
	.Q:quitflag<0
	.
	/// 4 根据配置,即刻配液,减库存
	S PSNumber="10"
	S dispconfig=##class(web.DHCSTPIVA).GetPSNumberProByLoc(ploc,PSNumber)
	i (dispconfig="Y")&(quitflag=0) S quitflag=##class(web.DHCSTPIVARECHECK).SaveCheckOK(pid,pogid,PSNumber)
	
	L -^DHCSTLOCK("PIVA",pid)
	I quitflag'=0 TROLLBACK
	Q:quitflag'=0 quitflag
	TCOMMIT
	Q pharowid
}

/// 保存打签数据分1-2-3-4
ClassMethod SaveDisp(pid As %String) As %String
{
	N (pid,%session)
	S puser=##class(web.DHCSTCOMWEB).GetUserID()
	;s puser=578
	Q:puser="" -1
	S pdatef=$P(^TMP("PIVA",pid,"M"),"^",3)
	S pdatet=$P(^TMP("PIVA",pid,"M"),"^",4)
	S ploc=$P(^TMP("PIVA",pid,"M"),"^",1)
	S pward=$P(^TMP("PIVA",pid,"M"),"^",2)
	Q:ploc="" -2
	/// 1 保存发药主表
	S:$g(pharowid)="" pharowid=..InsPhaCollected(ploc,pward,puser,pdatef,pdatet)
	S index="",h=0
	F  S index=$O(^TMP("PIVA",pid,"D2",index)) Q:index=""  D
    .S Err=..SaveData(pid,index,pharowid,puser,h)
    .Q:Err'>0
    .S h=h+1
	i h=0 &sql(delete from  DHC_PHACollected where DHC_PHACollect_RowID=:pharowid )
    i h=0 Q -3
   
	Q pharowid
}

/// 保存子表过程
ClassMethod SaveData(pid As %String, index As %String, pharowid, puser, h) As %String
{
	N (pid,index,pharowid,puser,h,%session)
	S sdate=$p(index,"^",1)
	S batno=$p(index,"^",3)
	S grpno=$p(index,"^",4)
	S moeori=$p(index,"^",5)
	S ploc=$p(^OEORD(+moeori,"I",$p(moeori,"||",2),3),"^",6)
	S PSNumber="10"
	S dispconfig=##class(web.DHCSTPIVA).GetPSNumberProByLoc(ploc,PSNumber)
	
	TSTART
	L +^DHCSTLOCK("PIVA",sdate,moeori,grpno):5  E  Q -100
	S quitflag=0
	S dodis=""
	F  S dodis=$O(^TMP("PIVA",pid,"D2",index,dodis)) Q:(dodis="")||(quitflag'=0)  D
	.S tstr=^TMP("PIVA",pid,"D2",index,dodis)
	.Q:$LL(tstr)=0	/// list number is zero
	.S stdate=$LI(tstr,19)
	.S sttime=$LI(tstr,20)
	.S pno=$LI(tstr,25)
	.S:stdate'="" stdate=$ZDH(stdate,3)
	.S:sttime'="" sttime=$ZTH(sttime,1)
	./// 2 保存医嘱组主表
	.S moedisp=##class(web.DHCSTPIVA).GetMainOEDispID(dodis,grpno)
	.s upBatno=##class(web.DHCSTPIVA).GetUpBatNo(moedisp,grpno)	/// 20150107 zhouyg 如果有修改过的批次，按修改后的批次保存，避免打签界面改批次之后立即打印导致批次错误
	.i upBatno'="" s batno=upBatno
	.S pogid=..GetOrdGrpID(moedisp,grpno)
	.I pogid="" D
	..S pogid=..InsOrdGrp(ploc,moedisp,grpno,batno,stdate,sttime,pharowid,pno,puser)
	.E  D
	..S pogid=..UpdOrdGrp(pogid,ploc,batno,stdate,sttime,pharowid,pno,puser)
	.I +pogid<0 S quitflag=-1
	.Q:quitflag'=0
	./// 3 保存医嘱组子表
	.S pogiid=..InsOrdGrpItm(pogid,dodis)
	.I +pogiid<0 S quitflag=-2
	.Q:quitflag'=0
	.
	/// 4 根据配置,即刻配液,减库存
	i (dispconfig="Y")&(quitflag=0) S quitflag=##class(web.DHCSTPIVARECHECK).SaveCheckOK(pid,pogid,PSNumber)
	
	I quitflag'=0 TROLLBACK
	L -^DHCSTLOCK("PIVA",sdate,moeori,grpno)
	I quitflag'=0 Q -3
	S h=h+1
	TCOMMIT
 	Q h
}

/// 判断配液状态是否合法 1 -非法 0 -合法
ClassMethod ChkPogState(pog As %String, locid As %String) As %String
{
	N (pog,locid)
	S cnumber="10"
	s pstype="I"
	S psdr=$P(^PIVA(+pog),"^",6)
 	S nextstr=##class(web.DHCSTPIVA).GetNextStat(psdr,locid,pstype)	 ///下一个状态
 	S nextnumber=$P(nextstr,"^",2)
 	S specstate=$P(^PIVA(+pog),"^",8)
 	Q:nextnumber'=cnumber 1
 	Q 0
}

ClassMethod UpdOrdGrp(pogid As %String, ploc As %String, batno As %String, stdate As %String, sttime As %String, pharowid As %String, pno As %String, puser As %String) As %String
{
	N (pogid,ploc,batno,stdate,sttime,pharowid,pno,puser)
	Q:..ChkPogState(pogid,ploc)=1 pogid
	K PLIST
	&SQL(Select * Into :PLIST() From PIVA_OrdGrp Where POG_RowId=:pogid)
	S PLIST(4)=batno
	S PLIST(5)=stdate
	S PLIST(6)=sttime
	S PLIST(7)=##class(web.DHCSTPIVA).GetPivaStateId(ploc,"I",10)	
	S PLIST(8)=ploc
	S PLIST(9)="N"
	S PLIST(11)=pharowid
	S PLIST(12)=pno
	&SQL(Update PIVA_OrdGrp Values :PLIST() Where POG_RowId=:pogid)
	Q:SQLCODE'=0 -99999
 	S pogid=$P(%ROWID,$C(1))
 	/// 保存医嘱组执行状态表3
	S pogsid=..InsOrdGrpState(pogid,puser)
	Q:+pogsid<0 -1
	Q pogid
}

ClassMethod InsPhaCollected(ploc As %String, pward As %String, puser As %String, pdfrom As %String, pdto As %String) As %String
{
	N (ploc,pward,puser,pdfrom,pdto)
	K PLIST
	S PLIST(2)=ploc
	S PLIST(5)=pward
	S PLIST(6)=puser
	S PLIST(7)="Print"
	S PLIST(8)=+$H
	S PLIST(9)=$P($H,",",2)
	S PLIST(11)=pdfrom
	S PLIST(12)=pdto
	S PLIST(13)="PIVA"
	S PLIST(15)=..GetDispNo(ploc)
	&sql(INSERT INTO DHC_PHACollected VALUES :PLIST())
	Q:SQLCODE'=0 -99999
 	Q $P(%ROWID,$C(1))
}

ClassMethod GetDispNo(phaloc As %String) As %String
{
	N (phaloc)
	S phalocset=$O(^DHCPL(0,"Loc",phaloc,""))
	Q:phalocset="" ""
	L +^DHCPL(phalocset):3
	S prefix=$P(^DHCPL(phalocset),"^",13)   
	S finaldate=$P(^DHCPL(phalocset),"^",15)   
	S countnum=$P(^DHCPL(phalocset),"^",12) 	
	I finaldate'=+$h d
	.s $P(^DHCPL(phalocset),"^",15)=+$h
	.s countnum=0
	S finaldate=$P(^DHCPL(phalocset),"^",15) 
	S countnum=countnum+1
	S $P(^DHCPL(phalocset),"^",12)=+countnum
	S dispno=prefix_$E($ZD(finaldate,8),3,8)_$tr($j(countnum,4)," ","0")
	L -^DHCPL(phalocset)
	Q dispno
}

/// 取PIVA_OrdGrp对应记录RowID
ClassMethod GetOrdGrpID(moeori As %String, grpno As %String) As %String
{
	N (moeori,grpno)
	Q:moeori="" ""
	Q:grpno="" ""
	Q $O(^PIVA(0,"OEGRP",moeori,grpno,""))
}

ClassMethod InsOrdGrp(ploc As %String, moedisp As %String, grpno As %String, batno As %String, stdate As %String, sttime As %String, pharowid As %String, pno As %String, puser As %String) As %String
{
	N (ploc,moedisp,grpno,batno,stdate,sttime,pharowid,pno,puser)
	K PLIST
	S PLIST(2)=moedisp  //关联dhc_oedispensing
	S PLIST(3)=grpno
	S PLIST(4)=batno
	S PLIST(5)=stdate
	S PLIST(6)=sttime
	S PLIST(7)=##class(web.DHCSTPIVA).GetPivaStateId(ploc,"I",10)  /// 10固定为打签的顺序号,yunhaibao20160413,按科室以及类型取
	S PLIST(8)=ploc
	S PLIST(9)="N"
	S PLIST(11)=pharowid
	S PLIST(12)=pno
	&SQL(Insert Into PIVA_OrdGrp Values :PLIST())
	Q:SQLCODE'=0 -99999
 	S pogid=$P(%ROWID,$C(1))
 	/// 保存医嘱组执行状态表
	S pogsid=..InsOrdGrpState(pogid,puser)
	Q:+pogsid<0 -1
	Q pogid
}

ClassMethod GetOrdGrpItmID(parref As %String, dodis As %String) As %String
{
	N (parref,dodis)
	Q:parref="" ""
	Q:dodis="" ""
	S sub=$O(^PIVA(0,"DSP",dodis,parref,""))
	Q:sub="" ""
	Q parref_"||"_sub
}

ClassMethod InsOrdGrpItm(parref As %String, dodis As %String) As %String
{
	N (parref,dodis)
	Q:parref="" -1
	Q:dodis="" -2
	S pogi=..GetOrdGrpItmID(parref,dodis)
	//Q:pogi'="" pogi
	Q:pogi'="" -3
	K PLIST
	S PLIST(0)=parref
	S PLIST(2)=$O(^PIVA(parref,"I",""),-1)+1
	S PLIST(3)=dodis
	&SQL(Insert Into PIVA_OrdGrpItm Values :PLIST())
	Q:SQLCODE'=0 -99999
 	Q $P(%ROWID,$C(1))
}

ClassMethod GetOrdGrpStateID(parref As %String, psdr As %String) As %String
{
	N (parref,psdr)
	Q:parref="" ""
	Q:psdr="" ""
	S sub=$O(^PIVA(0,"PS",psdr,parref,""))
	Q:sub="" ""
	Q parref_"||"_sub
}

ClassMethod InsOrdGrpState(parref As %String, user As %String) As %String
{
	N (parref,user)
	Q:parref="" -1
	Q:user="" -2
	s pivaloc=$p(^PIVA(parref),"^",7)
	S psdr=##class(web.DHCSTPIVA).GetPivaStateId(pivaloc,"I",10)  /// 10固定为打签的顺序号
	Q:psdr="" -3
	//S pogs=..GetOrdGrpStateID(parref,psdr)
	//Q:pogs'="" pogs
	K PLIST
	S PLIST(0)=parref
	S PLIST(2)=$O(^PIVA(parref,"S",""),-1)+1
	S PLIST(3)=psdr
	S PLIST(4)=user
	S PLIST(5)=+$H
	S PLIST(6)=$P($H,",",2)
	&SQL(Insert Into PIVA_OrdGrpState Values :PLIST())
	Q:SQLCODE'=0 -99999
 	Q $P(%ROWID,$C(1))
}

ClassMethod GetRecordSum(pid As %String) As %String
{
	Q $G(^TMP("PIVA",pid,"DSUM"))
}

/// 取打印首页数据
ClassMethod GetPrintHData(phac As %String) As %String
{
	N (phac)
	Q:phac="" ""
	Q:'$D(^DHCPHAC(phac)) ""
	S str=^DHCPHAC(phac)
	S ploc=$P(str,"^",1)
	I ploc'="" D
	.S:$D(^CTLOC(ploc)) ploc=$P(^CTLOC(ploc),"^",2)
	S ward=$P(str,"^",4)
	I ward'="" D
	.S:$D(^PAWARD(ward)) ward=$P(^PAWARD(ward),"^",2)
	S user=$P(str,"^",5)
	I user'="" D
	S:$D(^SSU("SSUSR",user)) user=$P(^SSU("SSUSR",user),"^",2)
	S pdate=$P(str,"^",7)
	S:pdate'="" pdate=$ZD(pdate,3)
	S ptime=$P(str,"^",8)
	S:ptime'="" ptime=$ZT(ptime,1)
	S pdt=pdate_" "_ptime
	S pno=$P(str,"^",14)
	S ret=ploc_"^"_ward_"^"_user_"^"_pdt_"^"_pno
	Q ret
}

/// 某一张配药单打印的批次种类和数量列表
ClassMethod GetPhBatList(phac As %String) As %String
{
	N (phac)
	Q:phac="" ""
	S pid=..NewPid()
	K ^TMP("PIVA",pid,"PHACBAT")
	S bat="",sum=0
	F  S bat=$O(^PIVA(0,"PHACBAT",phac,bat)) Q:bat=""  D
	.S pog=""
	.F  S pog=$O(^PIVA(0,"PHACBAT",phac,bat,pog)) Q:pog=""  D
	..S ^TMP("PIVA",pid,"PHACBAT",bat)=$G(^TMP("PIVA",pid,"PHACBAT",bat))+1
	..S sum=sum+1
	S bb="",ret=""
	F  S bb=$O(^TMP("PIVA",pid,"PHACBAT",bb)) Q:bb=""  D
	.S str="第"_bb_"批："_^TMP("PIVA",pid,"PHACBAT",bb)_"袋"
	.I ret="" S ret=str
	.E  S ret=ret_"^"_str
	S strsum="合计："_sum_"袋"
	I ret'="" S ret=ret_"^"_strsum
	K ^TMP("PIVA",pid,"PHACBAT")
	Q ret
}

ClassMethod GetPrintItm(phac As %String) As %String
{
	N (phac,%session)
	Q:phac="" ""
	S pid=..NewPid()
	K ^TMP("PIVA",pid,"POG")
	K ^TMP("PIVA",pid,"POGI")
	S pno=$P(^DHCPHAC(phac),"^",14)	/// 打印单号
	S ward=$P(^DHCPHAC(phac),"^",4)	/// 病区
	S printdate=$P(^DHCPHAC(phac),"^",7)
	;S:printdate'="" printdate=$ZD(printdate,3)
	S printtime=$P(^DHCPHAC(phac),"^",8)
	S:printtime'="" printtime=$ZT(printtime,1)
	;S prtdt=printdate_" "_printtime
	I ward'="" D
	.S:$D(^PAWARD(ward)) ward=$P(^PAWARD(ward),"^",2)
	S pog="",i=0,j=0
	F  S pog=$O(^PIVA(0,"PHAC",phac,pog)) Q:pog=""  D
	.S pnumber=$P(^PIVA(pog),"^",11)	/// 打印序号
	.F hh=1:1:(3-$l(pnumber)) D
	..S pnumber=0_pnumber
	.S pno=$P(^DHCPHAC(phac),"^",14)
	.S pno=pno_"-"_pnumber  /// 打印单号-序号
	.S moedisp=$P(^PIVA(pog),"^",1)
	.S moeori=$P(^DHCOEDISQTY(moedisp),"^",3) /// 主医嘱ID
	.S batno=$P(^PIVA(pog),"^",3)	/// 批次
	.S pcp=$P(^PIVA(pog),"^",15)		/// 取消打印表ID
	.S plocdr=$P(^PIVA(pog),"^",7)
	.S cpno=""
	.I pcp'="" D
	..S:$D(^PIVACP(pcp)) cpno=$P(^PIVACP(pcp),"^",1)
	.S cpnumber=$P(^PIVA(pog),"^",16)	/// 取消打印的序号
	.s notes=##class(web.DHCSTPIVA).GetNotes(moeori)      ///备注
	.i $l(notes)>10 d
	..s notes=$e(notes,1,10)_"…"
	..
	.S instruc=##class(web.DHCSTPIVA).GetInstruc(moeori)	/// 用法
	.S pri=##class(web.DHCSTPIVA).GetOePriority(moeori)	/// 优先级
	.S pri=$P(pri,"^",3)	
	.S freq=##class(web.DHCSTPIVA).GetFreq(moeori)	/// 频率
	.S freq=$P(freq,"^",2)
	.S patstr=##class(web.DHCSTPIVA).GetOeInfoByMoeori(moeori)	/// 病人信息
	.S odate=$P(^PIVA(pog),"^",4)
	.S printdate=$P(^DHCPHAC(phac),"^",7)
	.S pdate=$P(^DHCOEDISQTY(moedisp),"^",21) //##class(web.DHCSTPIVA).GetPyDate(moeori,batno,pri,printdate,odate,freq,plocdr)
	.S printdate=$P(^DHCPHAC(phac),"^",7)
	.S:printdate'="" printdate=$ZD(printdate,3)
	.S prtdt=printdate_" "_printtime
	.S:odate'="" odate=$ZD(odate,3)
	.S otime=$P(^PIVA(pog),"^",5)
	.S:otime'="" otime=$ZT(otime,1)
	.S dt=odate_" "_otime
	.S:pdate'="" pdate=$ZD(pdate,3)
	.S pdate=pdate_" "_otime
	.S bttime=##class(web.DHCSTPIVA).GetTimeByBatNo(phac,batno)
	.i bttime'="" s bttime=$ZT(bttime,1)
	.S dt=odate_" "_bttime
	.S pdate=pdate_" "_bttime
	.S TotalLiquid=##class(web.DHCSTPIVA).GetTotalLiquid(pog)
	.S adm=$P(^OEORD(+moeori),"^",1)
	.S pasts=..GetPasts(pid,phac,adm)
	.S pastno=..GetPastNo(pid,pog)
	.S grpno=$P(^PIVA(pog),"^",2)
	.S stype=""
	.S weight=##class(web.DHCSTPIVA).GetPatWeight(adm)
	.S chstr=##class(web.DHCSTPIVA).GetPassResult(moeori)
	.S passuser=$p(chstr,",",1) /// 配伍审核人
 	.S passuname=""
 	.I passuser'="" D
 	..I $D(^SSU("SSUSR",passuser)) D
 	...S passuname=$P(^SSU("SSUSR",passuser),"^",1)
 	.S papmi=$p(^PAADM(adm),"^",1) 
 	.S PAAllergy=##class(web.DHCSTPIVA).GetPAAllergyStr(papmi,"")
 	.I PAAllergy'="" S PAAllergy="药物过敏:"_PAAllergy
 	.S doctor=##class(web.DHCSTPIVA).GetDoctor(moeori)	/// 医生
 	.S BatNums="",BatNN=""
 	.s prescno=$P(^OEORD(+moeori,"I",$p(moeori,"||",2),1),"^",14)
 	.;
 	.S skintest=##class(web.DHCSTPIVA).SkinTest(moeori)
 	.I skintest>0 S $P(patstr,"^",3)=$P(patstr,"^",3)_" "_"(皮试 — )"
 	.I skintest<0 S $P(patstr,"^",3)=$P(patstr,"^",3)_" "_"(皮试 + )"
 	.I skintest=-5 S $P(patstr,"^",3)=$P(patstr,"^",3)_" "_"(皮试   )"
 	.s packflag=$p(^DHCOEDISQTY(moedisp),"^",28) //静配打包状态
 	.i (packflag'="")&&(packflag'="N") s packflag="打包"
	.S i=i+1
	.S ^TMP("PIVA",pid,"POG",i)=pog_"^"_moeori_"^"_grpno_"^"_ward_"^"_pno_"^"_pnumber_"^"_batno_"^"_cpno_"^"_cpnumber_"^"_pri_"^"_freq_"^"_instruc_"^"_prtdt_"^"_TotalLiquid_"^"_pasts_"^"_pastno_"^"_patstr_"^"_stype_"^"_weight_"^"_passuname_"^"_prescno_"^"_pdate_"^"_doctor_"^"_packflag
	.S pogsub="0",pogistr=""
	.F  S pogsub=$O(^PIVA(pog,"I",pogsub)) Q:pogsub=""  D
	..S dsp=$P(^PIVA(pog,"I",pogsub),"^",1)
	..Q:'$D(^DHCOEDISQTY(dsp))
	..S oeori=$P(^DHCOEDISQTY(dsp),"^",1) Q:oeori=""
	..S incitm=##class(web.DHCSTPIVA).GetIncItm(oeori)
 	..S inci=$P(incitm,"^",1)
 	..S incidesc=$P(incitm,"^",3)
	..S spec=##class(web.DHCSTCOMINC).GetSpec(inci)
	..S dosage=##class(web.DHCSTPIVA).GetDosage(oeori)
	..S dosageml=##class(web.DHCSTPIVA).GetDosageML(oeori)
	..i dosageml'="" s dosage=dosageml
	..S sign=##class(web.DHCSTPIVA).GetPrintSign(oeori)
	..S incidesc=sign_incidesc
	..S comp=##class(web.DHCSTPIVA).GetCompFlag(oeori)	/// 剂量是否整包装
	..;S qty=##Class(web.DHCSTPIVA).GetDspQty(oeori)
	..s qty=0      //测试用，待修改
	..I pogistr="" S pogistr=incidesc_"^"_dosage_"^"_spec_"^"_comp_"^"_qty
	..E  S pogistr=pogistr_"||"_incidesc_"^"_dosage_"^"_spec_"^"_comp_"^"_qty
	
	.s EncryptLevelInfo=""
    .s EncryptLevel=""
    .s PatLevel="" 
    .s EncryptFlag=##Class(web.DHCSTCOMMPARA).GetEncryptLevelFlag("")
    .i EncryptFlag=1 d
	..s condition=##class(web.DHCSTCOMMONSRV).ChangeToJson("打印单号^病区^打印日期",pno_"^"_ward_"^"_printdate)
 	..s content=##class(web.DHCSTCOMMONSRV).ChangeToJson("床号^姓名^登记号",patstr)
 	..s EncryptLevelInfo=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(papmi,"")
 	..s EncryptCode=$p(EncryptLevelInfo,"^",3)
 	..s ^tmpeve=condition_"^"_content_"^"_EncryptCode
 	..s eventlogret=##class(web.DHCSTCOMMONSRV).CreateEventLog("DHCDISPPIVAPRT",condition,content,EncryptCode)
	.S ^TMP("PIVA",pid,"POGI",i)=pogistr
	K ^TMP("PIVA",pid,"PAST")
	Q pid_"^"_i
}

ClassMethod GetPasts(pid As %String, phac As %String, adm As %String) As %String
{
	N (pid,phac,adm)
	K ^TMP("PIVA",pid,"PAST")
	S pog="",pnums=0
	F  S pog=$O(^PIVA(0,"PHAC",phac,pog)) Q:pog=""  D
	.S dspID=$P(^PIVA(pog),"^",1)
	.q:dspID=""
	.S oeori=$P($g(^DHCOEDISQTY(dspID)),"^",1)	//zhouyg 20151104 7.0版本之后应该如此修改
	.S ord=$P(oeori,"||",1)
	.Q:ord=""
	.Q:'$D(^OEORD(ord))
	.Q:$P(^OEORD(ord),"^",1)'=adm
	.S pnums=pnums+1
	.S ^TMP("PIVA",pid,"PAST",pog)=pnums
	Q pnums
}

ClassMethod UpdBat(moeori As %String, grp As %String, bat As %String, ploc As %String, dsp) As %String
{
	N (moeori,grp,bat,ploc,dsp,%session)
	//s ^yunhaibao("UpdBat")=moeori_"^"_grp_"^"_bat_"^"_ploc_"^"_dsp
	Q:moeori="" -1
	Q:grp="" -2
	Q:bat="" -3
	S puser=##class(web.DHCSTCOMWEB).GetUserID()
	Q:puser="" -4
	S bat=$ZCVT(bat,"U")
	S chk=##class(web.DHCSTPIVA).CheckPLocBatNo(bat,ploc)
	Q:chk=1 -5
	//S oeori=$p(^DHCOEDISQTY(dsp),"^",1)
	S grpno=$p(^DHCOEDISQTY(dsp),"^",4)
	s dspstatus=$p(^DHCOEDISQTY(dsp),"^",7)
	q:dspstatus="C" -8
    S oeori=##class(web.DHCSTPIVA).GetMainOEDispID(dsp,grpno)
	Q:oeori'=moeori -6
	s psstatenum=0,pog=""
	i $d(^PIVA(0,"OEGRP",oeori,grpno)) d //配置前允许修改,yunhaibao20160310
	.s pog=$o(^PIVA(0,"OEGRP",oeori,grpno,""))
	.s psstatenum=+##class(web.DHCSTPIVA).GetPSNumber(pog)
	q:psstatenum>50 -7
	K PLIST
	S PLIST(2)=moeori
	S PLIST(3)=grp
	S PLIST(4)=bat
	S PLIST(5)=puser
	S PLIST(6)=+$H
	S PLIST(7)=$P($H,",",2)
	&SQL(Insert Into PIVA_BatUp Values :PLIST())
	Q:SQLCODE SQLCODE
	S ret=..UpdDspTimeDo(moeori,grp,bat,ploc)
	I pog'="" d
	.&SQL(update PIVA_OrdGrp set POG_BatNo=:bat where POG_RowId=:pog)
	Q ret
}

ClassMethod UpdDspTimeDo(mdodis As %String, grp As %String, bat As %String, ploc As %String) As %String
{
	N (mdodis,grp,bat,ploc)
	S stime=""
	s flag="TC"
	s grp=+grp
	&SQL(Select PBT_TimeTo Into :stime from PIVA_BatTime Where PBT_Ctloc_Dr=:ploc And PBT_BatNo=:bat)
	Q:stime="" 0
	;&SQL(select DSP_SeqNo Into :tstime from DHC_OEDispensing Where DSP_OEORI_DR=:moeori And DSP_Status=:flag  And DSP_SeqNo=:grp)
	;&SQL(update DHC_OEDispensing Set DSP_TimeDosing=:stime Where DSP_OEORI_DR=:moeori And DSP_Status=:flag And trim(DSP_SeqNo)=:grp )
	&SQL(update DHC_OEDispensing Set DSP_TimeDosing=:stime Where DSP_RowId=:mdodis )

	Q SQLCODE
}

ClassMethod GetPastNo(pid As %String, pog As %String) As %String
{
	Q $G(^TMP("PIVA",pid,"PAST",pog))
}

ClassMethod GetPogList(pid As %String, i As %String) As %String
{
	Q ^TMP("PIVA",pid,"POG",i)
}

ClassMethod GetPogItmList(pid As %String, i As %String) As %String
{
	Q ^TMP("PIVA",pid,"POGI",i)
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
}

ClassMethod ClearPrintTmp(pid As %String) As %String
{
	D ..CLEARTMP(pid,"POG")
	D ..CLEARTMP(pid,"POGI")
}

ClassMethod CLEARTMP(pid As %String, PAR As %String) As %String
{
	K ^TMP("PIVA",pid,PAR)
}

/// Description:   更新界面选择的执行记录的正常的打包标志
/// Creater:	hulihua
/// CreateDate:	2015-07-13
/// Table:      dhc_oedispensing
/// Input:      dispid-打包表的id,plogfalg-正常打包的状态标志
/// Output:		
/// Return：    0-更新成功,大于0-失败
/// Others: yunhaibao,2016-03-01,静配打签界面正常打包按钮仅可修改打包状态为空或者P的
/// w ##class(web.DHCSTPIVAPRINTLABEL).UpdPogFlag("8556","Y")
ClassMethod UpdPogFlag(dispid As %String, plogfalg As %String) As %String
{
	n (dispid,plogfalg)
	s Err=0
	q:dispid="" 1
	s pivapogflag=$p(^DHCOEDISQTY(dispid),"^",28) //护士执行打包状态
	q:pivapogflag="Y" 3 //护士打包
	q:pivapogflag="E" 4	//二次打包
	&SQL(update dhc_oedispensing set DSP_PogFlag=:plogfalg where DSP_RowId=:dispid)
	i SQLCODE'=0  d
 	.s Err=2
	q Err
}

Storage Default
{
<Data name="DHCSTPIVAPRINTLABELDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCSTPIVAPRINTLABELD</DataLocation>
<DefaultData>DHCSTPIVAPRINTLABELDefaultData</DefaultData>
<IdLocation>^web.DHCSTPIVAPRINTLABELD</IdLocation>
<IndexLocation>^web.DHCSTPIVAPRINTLABELI</IndexLocation>
<StreamLocation>^web.DHCSTPIVAPRINTLABELS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
