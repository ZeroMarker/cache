Import SQLUser

/// 配液排批
Class web.DHCSTPIVABATUPDATE Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:Liang Qiang
/// CreatDate:2015-12-01
/// Description:取配液待排批病区列表
/// Table:
/// Input:记录数,页码,入参
/// Retrun:
ClassMethod CollWard(rows, page, Input) As %Integer
{
	N (rows,page,Input)
	
	s PLocID=$p(Input,"^",1)
	s StDate=$p(Input,"^",2)
	s EndDate=$p(Input,"^",3)
	s StDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StDate)
	s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	s LocGrpDr=$p(Input,"^",7)
	S PID=##class(web.DHCSTPIVAPRINTLABEL).NewPid()
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
	S cnumber=10  /// 10固定为打签状态
	s pstype="I"
	S h=0
	S LastMainOrd=""
	F date=StDate:1:EndDate D
	.S WardLocDr=""
	.F  S WardLocDr=$O(^DHCOEDISQTY(0,"REC",PLocID,date,"TC",WardLocDr)) q:WardLocDr=""  d
	..S flag=0
    ..S DspId=""
    ..F  s DspId=$O(^DHCOEDISQTY(0,"REC",PLocID,date,"TC",WardLocDr,0,DspId)) q:(DspId="")||(flag=1)  d
    ...S grpno=$p(^DHCOEDISQTY(DspId),"^",4)
    ...S mdodis=##class(web.DHCSTPIVA).GetMainOEDispID(DspId,grpno)
    ...//已排批
    ...q:..GetSysUpdBatNo(mdodis,grpno)'="" 
    ...S WardDr=$o(^PAWARD(0,"WARD_LocationDR",WardLocDr,""))
    ...//科室组
    ...q:##class(web.DHCSTPIVABATUPDATE).CheckWardByLocGrp(LocGrpDr,WardDr)=0
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
	...//Q:##class(web.DHCSTPIVA).CheckWard(WardID,WardDr)=0
	...Q:##Class(web.DHCSTPIVA).IfQuitAdmStatusD(AdmDr)=1	//已经结算退出
	...S oeori=OEOrdItem
	...S moeori=##class(web.DHCSTPIVA).GetMainOeori(oeori)	/// 主医嘱 
	.../// 医嘱状态
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
	...Q:$O(^PIVAO(0,"OECPR",PLocID,pridr,""))=""  	/// 没有维护科室配液的医嘱优先级
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
 	.../// 执行日期
 	...S sttdate=date	
 	...S sttdate2=$zd(sttdate,3)
 	...///配液分类
 	...;S nextnumber=cnumber
 	...S specstate=""
 	...S pogi=##class(web.DHCSTPIVA).GetOGrpI(DspId)
 	...I pogi'="" D
 	....S psdr=$P(^PIVA(+pogi),"^",6)
 	....S nextstr=##class(web.DHCSTPIVA).GetNextStat(psdr,PLocID,pstype)	 ///下一个状态
 	....S nextnumber=$P(nextstr,"^",2)
 	....S specstate=$P(^PIVA(+pogi),"^",8)
 	...;Q:nextnumber'=cnumber
 	...Q:(specstate="C")!(specstate="R")
 	...S grpno=$p(^DHCOEDISQTY(DspId),"^",4)
 	...S stttime=$p(^DHCOEDISQTY(DspId),"^",20)
 	...S mdodis=##class(web.DHCSTPIVA).GetMainOEDispID(DspId,grpno)
    ...s WardIndex=WardDesc_"||"_WardDr
 	...i '$D(^TMP("DHCST","DHCSTPIVABATUPDATE","CollWard",PID,"WardList",WardIndex)) d
 	....S h=h+1
 	...S ^TMP("DHCST","DHCSTPIVABATUPDATE","CollWard",PID,"WardList",WardIndex)=$G(^TMP("DHCST","DHCSTPIVABATUPDATE","CollWard",PID,"WardList",WardIndex))+1

	q:h=0 ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	
	s maxrow=h
	i endpage>maxrow s endpage=maxrow
	s count=0
    s h=""
    f  s h=$o(^TMP("DHCST","DHCSTPIVABATUPDATE","CollWard",PID,"WardList",h)) q:h=""  d
    .s data=^TMP("DHCST","DHCSTPIVABATUPDATE","CollWard",PID,"WardList",h)
    .s WardDesc=$p(h,"||",1)
    .s WardDr=$p(h,"||",2)
    .
    .s count=count+1
    .q:count<stpage
    .q:count>endpage
    .
    .s WardDesc=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("WardDesc",WardDesc)
    .s WardID=##class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("WardID",WardDr)
	.
	.s tmpstr=WardDesc_WardID
	.
    .s startString=##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTJQUERYCOMMON).GetJsonLastRow(tmpstr)
	.
    .i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
	.
 
	
    k ^TMP("DHCST","DHCSTPIVABATUPDATE","CollWard",PID)
    q ""
}

/// Creator:Liang Qiang
/// CreatDate:2015-12-01
/// Description:取配液待排批病区列表
/// Table:
/// Input:记录数,页码,入参
/// Retrun:
ClassMethod CollWardItm(Input) As %Integer
{
	
	N (Input)
	s PLocID=$p(Input,"^",1)
	s StDate=$p(Input,"^",2)
	s EndDate=$p(Input,"^",3)
	s WardID=$p(Input,"^",4)
	s StDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StDate)
	s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	s LocGrpDr=$p(Input,"^",7)
	S PID=##class(web.DHCSTPIVAPRINTLABEL).NewPid()

	Q:$O(^PIVAA(0))="" ""	/// 配液的医嘱子分类没有维护
	Q:$O(^PIVAO(0,"OECPR",PLocID,""))="" ""	/// 科室配液的医嘱优先级没有维护
	Q:$O(^PIVABT(0,"TIME",PLocID,""))="" ""	/// 科室配液的时间段分批没有维护
	
	
	s ret=..SetLocBatGolbal(PLocID, PID) //获取参加计算的批次列表
	s x=0
	S cnumber=10  /// 10固定为打签状态
	s type="I"
	s HospID=$p($g(^CTLOC(PLocID)),"^",22)
	s LastMainOrd=""
	s WardLocDr=$p(^PAWARD(WardID),"^",5)
	S i=0,pno=0
	F date=StDate:1:EndDate D
	.S DspId=""
	.F  s DspId=$O(^DHCOEDISQTY(0,"REC",PLocID,date,"TC",WardLocDr,0,DspId)) q:DspId=""  d
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
 	..s WardLocId=$p(^DHCOEDISQTY(DspId),"^",22)
    ..s wardid=$o(^PAWARD(0,"WARD_LocationDR",WardLocId,""))
    ..//科室组
    ..q:##class(web.DHCSTPIVABATUPDATE).CheckWardByLocGrp(LocGrpDr,wardid)=0
 	..S papmi=$p(^PAADM(AdmDr),"^",1) 
	..S ipno=$P(^PAPER(papmi,"PAT",1),"^",1)
	..//索引
	..S index=date_"||"_admward_"||"_bed_"||"_ipno_"||"_PLocID
	..s OrdItmRowid=$p(^DHCOEDISQTY(DspId),"^",1)     ;OE_OrdItem表指针
    ..s OrdExeRowid=$p(^DHCOEDISQTY(DspId),"^",3)     ;OE_OrdExec表指针
    ..s ord=$p(OrdItmRowid,"||",1)
    ..s chl=$p(OrdItmRowid,"||",2)
	..S oeori=ord_"||"_chl
	..//Q:##Class(web.DHCSTPIVA).IfQuitPIVA(oeori)=1 //是否可配液
	../// 非执行医嘱
	..//Q:$O(^OEORD(ord,"I",chl,"X",0))=""
	..s remark=##class(web.DHCSTPIVA).GetOrdItmRemark(oeori)
	..S moeori=##class(web.DHCSTPIVA).GetMainOeori(oeori)	/// 主医嘱
	..///准备已打印的标签
	..d ..SetPrintedFlag(index, PID, DspId) 
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
	..Q:$O(^PIVAO(0,"OECPR",PLocID,pridr,""))=""  	/// 没有维护科室配液的医嘱优先级
	..S pricode=$P(pri,"^",2)
	..S pricode=$ZCVT(pricode,"U")
	../// 护士审核
	..S Audited=##class(web.DHCSTCOMMONSRV).IfAuditByPriority(DspId)
	../// 皮试
	../// Q:##class(web.DHCSTPIVA).SkinTest(oeori)<0
	../// 取维护的“空”批次数量
	..S knum=##class(web.DHCSTPIVA).GetKBatNum()
	../// 关联医嘱标志
	..S seqflag=##class(web.DHCSTPIVA).GetOISeqFlag(oeori)
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
 	..//S sttdate=$P(^OEORD(ord,"I",chl,1),"^",9)	/// 执行日期
 	..//S stttime=$P(^OEORD(ord,"I",chl,1),"^",10)	/// 执行时间
 	..S sttdate=date
 	..s stttime=$p(^DHCOEDISQTY(DspId),"^",20)  ;分发时间
 	..i stttime'="" S stttime=$zt(stttime,1) 	/// 执行时间
 	..S sttdate2=$zd(sttdate,3)  //_" "_stttime
 	..S seqno=$P(^OEORD(ord,"I",chl,3),"^",4)		/// 关联医嘱号
 	..s exStr=oeori_"^"_DspId
 	..s price=##class(web.DHCSTPRICE).GetSp(inci,sttdate,"",HospID,"",exStr)
 	..
 	..S grpno=$p(^DHCOEDISQTY(DspId),"^",4)
 	..S mdodis=##class(web.DHCSTPIVA).GetMainOEDispID(DspId,grpno)
 	..q:..GetSysUpdBatNo(mdodis,grpno)'="" //已排批
 	..S nextnumber=cnumber
 	..S specstate=""
 	..;d ..SetPrintedFlag(index, PID, DspId) //设置已打签的记录
 	..S pogi=##class(web.DHCSTPIVA).GetOGrpI(DspId)
 	..I pogi'="" D
 	...S psdr=$P(^PIVA(+pogi),"^",6)
 	...S nextstr=##class(web.DHCSTPIVA).GetNextStat(psdr,PLocID,type)	 ///下一个状态
 	...S nextnumber=$P(nextstr,"^",2)
 	...S specstate=$P(^PIVA(+pogi),"^",8)
 	..;Q:nextnumber'=cnumber
 	..Q:(specstate="C")!(specstate="R")
 	../// 护士审核
 	..S stttime=$p(^DHCOEDISQTY(DspId),"^",20)
 	..I mdodis'="" D
 	...I $D(^DHCOEDISQTY(mdodis)) S stttime=$p(^DHCOEDISQTY(mdodis),"^",20)	/// 执行时间
 	..s batno=..GetDspBatNo(mdodis) //批号
 	..S j=sttdate2_"||"_bed_"||"_batno_"||"_grpno_"||"_mdodis
 	..s tmpbat=batno
 	..
 	..//计算总量
 	..i '$d(^TMP("DHCST","DHCSTPIVAPRINTLABEL","CollWard","TotalMl",PID,mdodis,tmpbat)) d
    ...S TotalML=##class(web.DHCSTPIVA).GetTotalLiquidOe(moeori)
    ...S TotalML=$p(TotalML,"ml")
 	...S ^TMP("DHCST","DHCSTPIVAPRINTLABEL","CollWard",PID,index,tmpbat)=+$g(^TMP("DHCST","DHCSTPIVAPRINTLABEL","CollWard",PID,index,tmpbat))+TotalML
 	...S OrdDataIndex=..SetOrdDataIndex(index, mdodis, PID, wardid, tmpbat_"^"_grpno,TotalML)
 	...S ^TMP("DHCST","DHCSTPIVAPRINTLABEL","CollWard","TotalMl",PID,mdodis,tmpbat)=""
 	..//
 	..i '$d(^TMP("PIVA",PID,"D","DATA",j)) d
 	...s x=x+1
    ..s ^TMP("PIVA",PID,"D","DATA",j)="" //输出
    b
     q PID
}

ClassMethod CollAdmItm(Input, AllFlag = "") As %Integer
{
	N (Input,AllFlag)	 
	
	s PLocID=$p(Input,"^",1)
	s StDate=$p(Input,"^",2)
	s EndDate=$p(Input,"^",3)
	s StDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StDate)
	s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	s AdmID=$p(Input,"^",5)
	S PID=##class(web.DHCSTPIVAPRINTLABEL).NewPid()
	
	s ret=..SetLocBatGolbal(PLocID, PID) //获取参加计算的批次列表
	
	Q:$O(^PIVAA(0))="" ""	/// 配液的医嘱子分类没有维护
	Q:$O(^PIVAO(0,"OECPR",PLocID,""))="" ""	/// 科室配液的医嘱优先级没有维护
	Q:$O(^PIVABT(0,"TIME",PLocID,""))="" ""	/// 科室配液的时间段分批没有维护
	
	S cnumber=10  /// 10固定为打签状态
	s pstype="I"  ///住院
	S ord=$o(^OEORD(0,"Adm",AdmID,""))
 	Q:ord="" ""
 	Q:##Class(web.DHCSTPIVA).IfQuitAdmStatusD(AdmID)=1 ""	//已经结算退出
 	S admward=$P(^PAADM(AdmID),"^",70) /// 病人所在病房
 	/// 床号
 	S bedid=$P(^PAADM(AdmID),"^",73)
 	S bed="*",wardid="*"
 	I bedid'="" D
 	.S wardid=$P(bedid,"||",1)
 	.S bedsub=$P(bedid,"||",2)
 	.I $D(^PAWARD(wardid,"BED",bedsub)) S bed=$P(^PAWARD(wardid,"BED",bedsub),"^",1)

    s dspstatusStr="TC"
    i AllFlag="1" s dspstatusStr="TC^C"
	s HospID=$p($g(^CTLOC(PLocID)),"^",22)
	s x=0
	F date=StDate:1:EndDate D
	.s cnt=$l(dspstatusStr,"^")
	.f i=1:1:cnt d
	..s dspstatus=$p(dspstatusStr,"^",i)
	..S DspId=""
	..f  s DspId=$o(^DHCOEDISQTY(0,"ADM",PLocID,date,dspstatus,AdmID,DspId)) q:DspId=""  d
	...s OrdItmRowid=$p(^DHCOEDISQTY(DspId),"^",1)     ;OE_OrdItem表指针
    ...s OrdExeRowid=$p(^DHCOEDISQTY(DspId),"^",3)     ;OE_OrdExec表指针
    ...s ord=$p(OrdItmRowid,"||",1)
    ...s chl=$p(OrdItmRowid,"||",2)
	...S oeori=ord_"||"_chl
	...Q:##Class(web.DHCSTPIVA).IfQuitAdmStatusD(AdmID)=1	//已经结算退出
	...//Q:##Class(web.DHCSTPIVA).IfQuitPIVA(oeori)=1 //是否可配液
	...s remark=##class(web.DHCSTPIVA).GetOrdItmRemark(oeori)
	...S moeori=##class(web.DHCSTPIVA).GetMainOeori(oeori)	/// 主医嘱
	.../// 床号
 	...S bedid=$P(^PAADM(AdmID),"^",73)
 	...S bed="*"
 	...I bedid'="" D
 	....S wardid=$P(bedid,"||",1)
 	....S bedsub=$P(bedid,"||",2)
 	....I $D(^PAWARD(wardid,"BED",bedsub)) S bed=$P(^PAWARD(wardid,"BED",bedsub),"^",1)
 	...s WardLocId=$p(^DHCOEDISQTY(DspId),"^",22)
    ...s wardid=$o(^PAWARD(0,"WARD_LocationDR",WardLocId,""))
 	...S papmi=$p(^PAADM(AdmID),"^",1) 
	...S ipno=$P(^PAPER(papmi,"PAT",1),"^",1)
	...S index=date_"||"_admward_"||"_bed_"||"_ipno_"||"_PLocID
	...///准备已打印的标签
	...d ..SetPrintedFlag(index, PID, DspId)
	.../// 医嘱状态
	...S ChkOrdState=##class(web.DHCSTCOMMONSRV).GetOrdState(OrdExeRowid)
 	...Q:(ChkOrdState'=1)&(AllFlag'="1")
 	.../// 配伍审核
 	...S chstr=##class(web.DHCSTPIVA).GetPassResult(moeori)
 	...Q:chstr=""	/// 未审核
	...Q:$p(chstr,",",4)="SHJJ" /// 配伍审核拒绝
	.../// 医嘱优先级
	...S pri=##class(web.DHCSTPIVA).GetOePriority(moeori)
	...//
	...S pridr=$P(pri,"^",1)
	...Q:pridr=""
	...Q:$O(^PIVAO(0,"OECPR",PLocID,pridr,""))=""  	/// 没有维护科室配液的医嘱优先级
	...S pricode=$P(pri,"^",2)
	...S pricode=$ZCVT(pricode,"U")
	.../// 护士审核
	...S Audited=##class(web.DHCSTCOMMONSRV).IfAuditByPriority(DspId)
	...Q:Audited=0 /// 护士未审核
	.../// 皮试
	.../// Q:##class(web.DHCSTPIVA).SkinTest(oeori)<0
	.../// 取维护的“空”批次数量
	...S knum=##class(web.DHCSTPIVA).GetKBatNum()
	.../// 关联医嘱标志
	...S seqflag=##class(web.DHCSTPIVA).GetOISeqFlag(oeori)
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
 	...S incitm=##class(web.DHCSTPIVA).GetIncItm(oeori)
 	...S inci=$P(incitm,"^",1)
 	...S sttdate=$P(^OEORD(ord,"I",chl,1),"^",9)	/// 执行日期
 	...S sttdate2=$zd(sttdate,3)
 	...S seqno=$P(^OEORD(ord,"I",chl,3),"^",4)		/// 关联医嘱号
 	...s exStr=oeori_"^"_DspId
 	...S nextnumber=cnumber
 	...S specstate=""
 	...S grpno=$p(^DHCOEDISQTY(DspId),"^",4)
 	...S mdodis=##class(web.DHCSTPIVA).GetMainOEDispID(DspId,grpno)
 	...q:..GetSysUpdBatNo(mdodis,grpno)'="" //已排批
 	...S pogi=##class(web.DHCSTPIVA).GetOGrpI(DspId)
 	...I pogi'="" D
 	....S psdr=$P(^PIVA(+pogi),"^",6)
 	....S nextstr=##class(web.DHCSTPIVA).GetNextStat(psdr,PLocID,pstype)	 ///下一个状态
 	....S nextnumber=$P(nextstr,"^",2)
 	....S specstate=$P(^PIVA(+pogi),"^",8)
 	...;Q:(nextnumber'=cnumber)&(AllFlag'="1")
 	...Q:((specstate="C")!(specstate="R"))&(AllFlag'="1")
 	...S stttime=$p(^DHCOEDISQTY(mdodis),"^",20)
 	...I mdodis'="" D
 	....I $D(^DHCOEDISQTY(mdodis)) S stttime=$p(^DHCOEDISQTY(mdodis),"^",20)	/// 执行时间
 	...S batno=..GetDspBatNo(mdodis) //批号
    ...S j=sttdate2_"||"_bed_"||"_batno_"||"_grpno_"||"_mdodis
 	...s tmpbat=batno
 	...//计算总量
 	...i '$d(^TMP("DHCST","DHCSTPIVAPRINTLABEL","CollWard","TotalMl",PID,mdodis,tmpbat)) d
    ....S TotalML=##class(web.DHCSTPIVA).GetTotalLiquidOe(moeori)
    ....S TotalML=$p(TotalML,"ml")
 	....S ^TMP("DHCST","DHCSTPIVAPRINTLABEL","CollWard",PID,index,tmpbat)=+$g(^TMP("DHCST","DHCSTPIVAPRINTLABEL","CollWard",PID,index,tmpbat))+TotalML
 	....S OrdDataIndex=..SetOrdDataIndex(index, mdodis, PID, wardid, tmpbat_"^"_grpno,TotalML)
 	....S ^TMP("DHCST","DHCSTPIVAPRINTLABEL","CollWard","TotalMl",PID,mdodis,tmpbat)=""
 	...//
 	...i '$d(^TMP("PIVA",PID,"D","DATA",j)) d
 	....s x=x+1
    ...s ^TMP("PIVA",PID,"D","DATA",j)="" //输出
    q PID
}

/// w ##class(web.DHCSTPIVABATUPDATE).GetAdtWardDetail(10,1,"101^2017-02-23^2017-02-24^14^^^")
ClassMethod GetAdtWardDetail(rows, page, Input) As %Integer
{
	n (rows, page,Input)
	///s ^yunhaibao("GetAdtWardDetail")=Input
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
	s wardid=$p(Input,"^",4)
	s adm=$p(Input,"^",5)
	s batNoList=$p(Input,"^",6)
	i wardid'="" s PID=..CollWardItm(Input)	
	i adm'="" s PID=..CollAdmItm(Input)	
	q:$g(PID)="" ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	q:'$d(^TMP("PIVA",PID,"D","DATA")) ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	
    ///生产新批次liangqiang
 	s ret=..ChangeOrdBatNo(PID)
 	s sum=0
	s x=""
 	f  s x=$o(^TMP("PIVA",PID,"D","DATA",x)) q:x=""  d
	.s mdodis=$p(x,"||",5) 
	.S grpno=$p(x,"||",4)
	.s batno=$p(x,"||",3)
 	.s newbatno=$g(^TMP("DHCST","DHCSTPIVAPRINTLABEL","ChangeOrdBatNo",PID,"BATRET",mdodis,grpno))
 	.i newbatno'="" s batno=newbatno
    .q:..ChkOrdItmBatNo(batNoList,batno)=0
    .s tmp=$p(x,"||",1)_"||"_$p(x,"||",2)_"||"_batno_"||"_$p(x,"||",4)_"||"_$p(x,"||",5)
    .s ^TMP("DHCST","DHCSTPIVABATUPDATE","UPD",PID,"ADMBAT",mdodis,grpno)=batno
    .s ^TMP("DHCST","DHCSTPIVABATUPDATE",PID,"ITM",tmp)=""
    .s sum=sum+1
    ///清空
    k ^TMP("PIVA",PID,"D","DATA")
    k ^TMP("DHCST","DHCSTPIVAPRINTLABEL","CollWard","TotalMl",PID)
    k ^TMP("DHCST","DHCSTPIVAPRINTLABEL","CollWard",PID)
	k ^TMP("DHCST","DHCSTPIVAPRINTLABEL","SetLocBatGolbal",PID)
	k ^TMP("DHCST","DHCSTPIVAPRINTLABEL","SetOrdDataIndex",PID)
	k ^TMP("DHCST","DHCSTPIVAPRINTLABEL","ChangeOrdBatNo",PID)
	k ^TMP("DHCST","DHCSTPIVAPRINTLABEL","SetPrintedFlag",PID)
	k ^TMP("DHCST","DHCSTPIVAPRINTLABEL","GetOrdSpecBatNo",PID)
	
	
	q:$g(sum)=0 ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s maxrow=sum
	i endpage>maxrow s endpage=maxrow
	
	s admnum=1  //adm计数
	s lastadm=""
	s count=0
	s j=""
	f  s j=$o(^TMP("DHCST","DHCSTPIVABATUPDATE",PID,"ITM",j)) q:j=""  d
	.s moedisp=$p(j,"||",5)
	.S oeori=$P(^DHCOEDISQTY(moedisp),"^",1) /// 主医嘱ID
	.s adm=$p(^OEORD(+oeori),"^",1) 
	.S grpno=$p(j,"||",4)
	.s batno=$p(j,"||",3)
	.S papmi=$p(^PAADM(adm),"^",1) 
	.S paname=$P(^PAPER(papmi,"ALL"),"^",1)
	.S patno=$P(^PAPER(papmi,"PAT",1),"^",1)
	.S bedid=$P(^PAADM(adm),"^",73)
	.S bed="*"
 	.I bedid'="" D
 	..I $D(^PAWARD(+bedid,"BED",$p(bedid,"||",2))) S bed=$P(^PAWARD(+bedid,"BED",$p(bedid,"||",2)),"^",1)
	.S incitm=##class(web.DHCSTPIVA).GetIncItm(oeori)
 	.S inci=$P(incitm,"^",1)
 	.S incidescSub=$P(incitm,"^",3) //
	.S spec=##class(web.DHCSTCOMINC).GetSpec(inci)
	.S dosage=##class(web.DHCSTPIVA).GetDosage(oeori)
	.S freqstr=##class(web.DHCSTPIVA).GetFreq(oeori)
	.S freq=$p(freqstr,"^",2)
	.S instruc=##class(web.DHCSTPIVA).GetInstruc(oeori)	/// 用法
	.S doctor=##class(web.DHCSTPIVA).GetDoctor(oeori)	/// 医生
	.S stttime=$p(^DHCOEDISQTY(moedisp),"^",20)
	.S:stttime'="" stttime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(stttime)
	.S sttdate=$p(^DHCOEDISQTY(moedisp),"^",21)
	.S:sttdate'="" sttdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(sttdate)
	.S sttdate=sttdate_" "_stttime
	.S qty=$P(^DHCOEDISQTY(moedisp),"^",11)
	.S uomdr=$P(^DHCOEDISQTY(moedisp),"^",6)
	.S uomdesc="*"
	.S:$D(^CT("UOM",uomdr)) uomdesc=$P(^CT("UOM",uomdr),"^",2)
	.s incidesc=""
	.s gchl=""
	.f  S gchl=$o(^OEORDi(0,"OEORI",+oeori,oeori,gchl)) q:(gchl="")||(incidesc'="")  d
	..i +gchl'=0 d
 	...S toeori=+oeori_"||"_gchl
 	...s toeore=toeori_"||"_grpno
 	...s ChkOrdState=##class(web.DHCSTCOMMONSRV).GetOrdState(toeore)
 	...q:ChkOrdState'=1 //因医生站可以根据配置单独停子医嘱
 	...S incitmSub=##class(web.DHCSTPIVA).GetIncItm(toeori)
 	...S incidesc=$P(incitmSub,"^",3) //子药
 	.i incidesc="" s incidesc=incidescSub,incidescSub=""
    .s count=count+1
    .q:count<stpage
    .q:count>endpage
    .i lastadm="" s admcolor=0
    .i (lastadm'=papmi)&(lastadm'="") d
    ..s admnum=admnum+1
    ..i admnum#2=0 s admcolor=1 
    ..i admnum#2'=0 s admcolor=0
    .s lastadm=papmi
    .
    .s TbPatNo=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("TbPatNo",patno)
    .s TbBatNo=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("TbBatNo",batno)
    .s TbBatNoId=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("TbBatNoId",batno)
    .s TbSttD=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("TbSttD",sttdate)
    .s TbBedNo=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("TbBedNo",bed)
    .s TbName=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("TbName",paname)
	.s TbMDsp=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("TbMDsp",moedisp)
	.s TbItmDesc=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("TbItmDesc",incidesc)
	.s TbItmDescSub=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("TbItmDescSub",incidescSub)
	.s TbDosage=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("TbDosage",dosage)
	.s TbFreq=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("TbFreq",freq)
	.s TbInstruc=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("TbInstruc",instruc)
	.s TbDoctor=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("TbDoctor",doctor)
	.s TbQty=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("TbQty",qty)
	.s TbUomdesc=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("TbUomdesc",uomdesc)
	.s TbAdmcolor=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("TbAdmcolor",admcolor)
	.s TbPID=##class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("TbPID",PID)
	.s tmpstr=TbPatNo_TbBatNo_TbBatNoId_TbSttD_TbBedNo_TbName_TbMDsp_TbItmDesc_TbItmDescSub_TbDosage_TbFreq_TbInstruc_TbDoctor_TbQty_TbUomdesc_TbAdmcolor_TbPID
	.
    .s startString=##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTJQUERYCOMMON).GetJsonLastRow(tmpstr)
	.
    .i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
	.
    ///清空
    k ^TMP("DHCST","DHCSTPIVABATUPDATE",PID)
    q ""
}

/// Description:验证批号
/// Input:批号串,当前批号
/// Return:1有 0无
/// Creator:LiangQiang
/// CreatDate:2015-12-02
ClassMethod ChkOrdItmBatNo(batNoList, batno) As %String
{
	n (batNoList,batno)
	q:batNoList="" 1
	s ret=0
	s batnoListCnt=$l(batNoList,",")
	f y=1:1:batnoListCnt q:ret=1  d
	.s tmp=$p(batNoList,",",y)
	.s tmpno=$p(^PIVABT(tmp),"^",3)
	.i tmpno=batno d
	..s ret=1
	q ret
}

/// Description:获取当前签的信息
/// Input:主打包表id
/// Return:病人信息||所有药品
/// Creator:LiangQiang
/// CreatDate:2015-12-02
ClassMethod GetCurBatInfo(moedisp) As %String
{
	
	S oeori=$P(^DHCOEDISQTY(moedisp),"^",1) /// 主医嘱ID
	s adm=$p(^OEORD(+oeori),"^",1) 
	S papmi=$p(^PAADM(adm),"^",1) 
	S paname=$P(^PAPER(papmi,"ALL"),"^",1)
	s bed=""
	S incitm=##class(web.DHCSTPIVA).GetIncItm(oeori)
 	S inci=$P(incitm,"^",1)
 	S incidesc=$P(incitm,"^",3)
	S spec=##class(web.DHCSTCOMINC).GetSpec(inci)
	S dosage=##class(web.DHCSTPIVA).GetDosage(oeori)
	S freqstr=##class(web.DHCSTPIVA).GetFreq(oeori)
	S freq=$p(freqstr,"^",2)
	S instruc=##class(web.DHCSTPIVA).GetInstruc(oeori)	/// 用法
	S doctor=##class(web.DHCSTPIVA).GetDoctor(oeori)	/// 医生
	S stttime=$p(^DHCOEDISQTY(moedisp),"^",20)
	S:stttime'="" stttime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(stttime)
	S sttdate=$p(^DHCOEDISQTY(moedisp),"^",21)
	S:sttdate'="" sttdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(sttdate)
	S sttdate=sttdate_" "_stttime
	S qty=$P(^DHCOEDISQTY(moedisp),"^",11)
	S uomdr=$P(^DHCOEDISQTY(moedisp),"^",6)
	S uomdesc="*"
	S:$D(^CT("UOM",uomdr)) uomdesc=$P(^CT("UOM",uomdr),"^",2)
	s perno=$p(^PAPER(papmi,"PAT",1),"^",2) 
    s sexdr=$p(^PAPER(papmi,"ALL"),"^",7)
    s patsex=$p(^CT("SEX",sexdr),"^",2)
    S patAge=##class(web.DHCSTKUTIL).GetAge(papmi)
    s patw=##class(web.DHCSTPIVA).GetPatWeight(adm)
    S bedid=$P(^PAADM(adm),"^",73)
 	S bed="*"
 	I bedid'="" D
 	.I $D(^PAWARD(+bedid,"BED",$p(bedid,"||",2))) S bed=$P(^PAWARD(+bedid,"BED",$p(bedid,"||",2)),"^",1)
 	s WardLocId=$p(^DHCOEDISQTY(moedisp),"^",22)
    s wardid=$o(^PAWARD(0,"WARD_LocationDR",WardLocId,""))
    s ward=$p(^PAWARD(wardid),"^",2)
    i $f(ward,"-") s ward=$p(ward,"-",2)
    
    s maindata=ward_"^"_bed_"^"_paname_"^"_patsex_"^"_patAge_"^"_patw_"^"_perno_"^"_sttdate
    
    /*
    s tmpdesc=""
	s gchl=""
	f  S gchl=$o(^OEORDi(0,"OEORI",+oeori,oeori,gchl)) q:gchl=""  d
 	.S toeori=+oeori_"||"_gchl
 	.Q:'$d(^DHCOEDISQTY(0,"OEORI",toeori))
 	.S incitmSub=##class(web.DHCSTPIVA).GetIncItm(toeori)
 	.S incidescSub=$P(incitmSub,"^",3)
 	.q:incidescSub=""
 	.i tmpdesc="" d
 	..s tmpdesc=incidescSub
 	.e  d
 	..s tmpdesc=tmpdesc_"^"_incidescSub
 	
 	s tmpdesc=incidesc_"^"_tmpdesc
 	*/
 	q maindata  //_"||"_tmpdesc
}

/// Description:获取当前病人所有签的信息
/// Input:开始日期,结束日期,药房ID,主医嘱ID
/// Output:所有批次
/// Creator:LiangQiang
/// CreatDate:2015-12-08
/// w ##class(web.DHCSTPIVABATUPDATE).GetCurPatBatInfo("10","1","32805^173876")
ClassMethod GetCurPatBatInfo(rows, page, Input) As %String
{
	n (rows, page, Input)
	//s ^yunhaibao("GetCurPatBatInfo",Input)=Input
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
	
	s moedisp=$p(Input,"^",1)
	s paramsPid=$p(Input,"^",2)
	s phalocdr=$p(^DHCOEDISQTY(moedisp),"^",24)
	s stdate=$p(^DHCOEDISQTY(moedisp),"^",21)
	s stdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(stdate)
	S oeori=$P(^DHCOEDISQTY(moedisp),"^",1)
	s adm=$p(^OEORD(+oeori),"^",1)
	s Input=phalocdr_"^"_stdate_"^"_stdate_"^"_""_"^"_adm
	s PID=..CollAdmItm(Input,"1")
	s count=0
	s j=""
	f  s j=$o(^TMP("PIVA",PID,"D","DATA",j)) q:j=""  d
	.s moedisp=$p(j,"||",5)
	.s grpno=$p(j,"||",4)
	.S dspdate=$p(^DHCOEDISQTY(moedisp),"^",21)
	.s count=count+1
	.S oeori=$P(^DHCOEDISQTY(moedisp),"^",1)
	.S incitm=##class(web.DHCSTPIVA).GetIncItm(oeori)
 	.S incidesc=$P(incitm,"^",3)
 	.q:incidesc=""
 	.S dosage=##class(web.DHCSTPIVA).GetDosage(oeori)
	.S freqstr=##class(web.DHCSTPIVA).GetFreq(oeori)
	.S freq=$p(freqstr,"^",2)
	.s batno=..GetDspBatNo(moedisp) //..GetCurPatBatNo(moedisp,paramsPid) //
	.S data=batno_"^"_incidesc_"^"_dosage_"^"_freq_"^"_moedisp
	.s index=batno_","_count
	.s ^TMP("DHCST","DHCSTPIVABATUPDATE","GetCurPatBatInfo",PID,"ADMITM",index)=data
	.;
	.S oeori=$P(^DHCOEDISQTY(moedisp),"^",1) /// 主医嘱ID
	.s adm=$p(^OEORD(+oeori),"^",1) 
	.S grpno=$p(j,"||",4)
	.s gchl=""
	.f  S gchl=$o(^OEORDi(0,"OEORI",+oeori,oeori,gchl)) q:gchl=""  d  //关联医嘱
 	..S toeori=+oeori_"||"_gchl
 	..Q:'$d(^DHCOEDISQTY(0,"OEORI",toeori))
 	..S incitmSub=##class(web.DHCSTPIVA).GetIncItm(toeori)
 	..S incidesc=$P(incitmSub,"^",3)
 	..q:incidesc=""
 	..S dosage=##class(web.DHCSTPIVA).GetDosage(toeori)
 	..q:dosage=""
	..S freqstr=##class(web.DHCSTPIVA).GetFreq(toeori)
	..S freq=$p(freqstr,"^",2)
	..S moedisp=$o(^DHCOEDISQTY(0,"SEQNO",toeori,dspdate,grpno,""))
	..s count=count+1
	..S data=batno_"^"_incidesc_"^"_dosage_"^"_freq_"^"_moedisp
	..s index=batno_","_count
	..s ^TMP("DHCST","DHCSTPIVABATUPDATE","GetCurPatBatInfo",PID,"ADMITM",index)=data
	q:count=0 ##class(web.DHCSTJQUERYCOMMON).GetNoJson()

	s maxrow=count
	i endpage>maxrow s endpage=maxrow
	
	s count=0
	s h=""
	f  s h=$o(^TMP("DHCST","DHCSTPIVABATUPDATE","GetCurPatBatInfo",PID,"ADMITM",h)) q:h=""  d
	.s data=^TMP("DHCST","DHCSTPIVABATUPDATE","GetCurPatBatInfo",PID,"ADMITM",h)
	.s batno=$p(data,"^",1) 
 	.s incidesc=$p(data,"^",2) 
 	.s dosage=$p(data,"^",3) 
 	.s freq=$p(data,"^",4) 
 	.s moedisp=$p(data,"^",5)
 	.s print=""
 	.s pogi=##class(web.DHCSTPIVA).GetOGrpI(moedisp)
 	.i pogi'="" s print="已打"
 	.s oestatus=""
 	.s ordexerowid=$p(^DHCOEDISQTY(moedisp),"^",3)
 	.s oestatusflag=##class(web.DHCSTCOMMONSRV).GetOrdState(ordexerowid)
 	.i oestatusflag'="1" s oestatus="停止"
 	.s xdate=$p(^OEORD(+ordexerowid,"I",$p(ordexerowid,"||",2),"X",$p(ordexerowid,"||",3)),"^",12)
 	.i xdate'="" s xdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(xdate)
 	.s xtime=$p(^OEORD(+ordexerowid,"I",$p(ordexerowid,"||",2),"X",$p(ordexerowid,"||",3)),"^",14)
 	.i xtime'="" s xtime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(xtime)
 	.s oestatusflag=##class(web.DHCSTCOMMONSRV).GetOrdState(ordexerowid)
 	.i oestatusflag'="1" s oestatus="停止"
 	.s xuserdr=$p(^OEORD(+ordexerowid,"I",$p(ordexerowid,"||",2),"X",$p(ordexerowid,"||",3)),"^",15)
 	.i xuserdr'="" s xusername=$p($g(^CTPCP(xuserdr,1)),"^",2)
 	.i oestatusflag="1" s xusername=""
    .s count=count+1
    .q:count<stpage
    .q:count>endpage
    .
    .s print=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("print",print)
    .s batno=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("batno",batno)
    .s incidesc=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("incidesc",incidesc)
	.s dosage=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("dosage",dosage)
	.s freq=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("freq",freq)
	.s oestatus=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("oestatus",oestatus)
	.s xdate=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("xdate",xdate)
	.s xtime=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("xtime",xtime)
	.s xusername=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("xusername",xusername)
	.s oestatusflag=##class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("oestatusflag",oestatusflag)
	.
	.s tmpstr=print_batno_incidesc_dosage_freq_oestatus_xdate_xtime_xusername_oestatusflag
	.
    .s startString=##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTJQUERYCOMMON).GetJsonLastRow(tmpstr)
	.
    .i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
	.
 
    s ret=..ClearTMP(PID)

    q ""
}

/// Description:获取当前签的信息
/// Input:开始日期,结束日期,主医嘱ID
/// Output:所有批次
/// Creator:LiangQiang
/// CreatDate:2015-12-08
/// w ##class(web.DHCSTPIVABATUPDATE).GetCurPatBatDs(100,1,"13424")
ClassMethod GetCurPatBatDs(rows, page, Input) As %String
{
	n (rows, page, Input)
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
	s moedisp=$p(Input,"^",1)
	S oeori=$P(^DHCOEDISQTY(moedisp),"^",1)
	s seqno=$P(^DHCOEDISQTY(moedisp),"^",4)
	s count=0
	S PID=##class(web.DHCSTPIVAPRINTLABEL).NewPid()
	S incitm=##class(web.DHCSTPIVA).GetIncItm(oeori)
 	S incidesc=$P(incitm,"^",3)
 	S dosage=##class(web.DHCSTPIVA).GetDosage(oeori)
	S freqstr=##class(web.DHCSTPIVA).GetFreq(oeori)
	S freq=$p(freqstr,"^",2)
	s oeorestat=##class(web.DHCSTCOMMONSRV).GetOrdState(oeori_"||"_seqno)
	s count=count+1
	S data=incidesc_"^"_dosage_"^"_freq_"^"_oeorestat
	s ^TMP("DHCST","DHCSTPIVABATUPDATE","GetCurPatBatDs",PID,count)=data
	s tmpdesc=""
	s gchl=""
	f  S gchl=$o(^OEORDi(0,"OEORI",+oeori,oeori,gchl)) q:gchl=""  d
 	.S toeori=+oeori_"||"_gchl
 	.Q:'$d(^DHCOEDISQTY(0,"OEORI",toeori))
 	.S incitmSub=##class(web.DHCSTPIVA).GetIncItm(toeori)
 	.q:incitmSub=""
 	.S incidescSub=$P(incitmSub,"^",3)
 	.S dosage=##class(web.DHCSTPIVA).GetDosage(toeori)
 	.q:dosage=""
	.S freqstr=##class(web.DHCSTPIVA).GetFreq(toeori)
	.S freq=$p(freqstr,"^",2)
	.s oeorestat=##class(web.DHCSTCOMMONSRV).GetOrdState(toeori_"||"_seqno)
	.s count=count+1
	.s batno=""
	.S data=incidescSub_"^"_dosage_"^"_freq_"^"_oeorestat
	.s ^TMP("DHCST","DHCSTPIVABATUPDATE","GetCurPatBatDs",PID,count)=data	
	q:count=0 ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s maxrow=count
	i endpage>maxrow s endpage=maxrow
	
	s count=0
	s h=""
	f  s h=$o(^TMP("DHCST","DHCSTPIVABATUPDATE","GetCurPatBatDs",PID,h)) q:h=""  d
	.s data=^TMP("DHCST","DHCSTPIVABATUPDATE","GetCurPatBatDs",PID,h) 
 	.s incidesc=$p(data,"^",1) 
 	.s dosage=$p(data,"^",2) 
 	.s freq=$p(data,"^",3) 
    .s oeorestat=$p(data,"^",4)
    .s count=count+1
    .q:count<stpage
    .q:count>endpage
    .
    .s incidesc=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("drug",incidesc)
    .s freq=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("freq",freq)
    .s oeorestat=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("oeorestat",oeorestat)
    .s dosage=##class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("dose",dosage)
	.
	.s tmpstr=incidesc_freq_oeorestat_dosage
	.
    .s startString=##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTJQUERYCOMMON).GetJsonLastRow(tmpstr)
	.
    .i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
	.
 
	k ^TMP("DHCST","DHCSTPIVABATUPDATE","GetCurPatBatDs",PID)
    
    q ""
}

/// 获取病人登记号长度
ClassMethod GetPatRegNoLen()
{
	 s PatLen=$p(^CF("PATCF",1,3),"^",5)
	 q PatLen
}

/// Description:获取当前病人就诊列表
/// Input:登记号
/// Output:就诊列表
/// Creator:LiangQiang
/// CreatDate:2015-12-16
ClassMethod GetAdmDs(RegNo As %String) As %Integer
{
	 s page="1"
	 s rows="100"
	 s End = page*rows
	 s Start=(page-1)*rows+1
	
	 S pid=##class(web.DHCSTPIVAPRINTLABEL).NewPid()
	 s n=0
	 s papmi=$o(^PAPERi("PAPMI_PatNo",RegNo,""))
	 q:papmi="" ##class(web.DHCSTJQUERYCOMMON).GetNoJson() //输出空的json串
	 s adm="" 
	 f  s adm=$o(^PAPERdr(papmi,"ADM","I",adm),-1) q:adm=""  d
	 .q:$p(^PAADM(adm),"^",2)'="I"  
	 .s depDesc=""    
	 .s depcodedr=$p(^PAADM(adm),"^",4) 
	 .i depcodedr'="" s depDesc=$p(^CTLOC(depcodedr),"^",2)
	 .i depDesc["-" s depDesc=$p(depDesc,"-",2)
	 .s admdate=$p(^PAADM(adm),"^",6) 
	 .i +admdate>0 s admdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(admdate) 
	 .s admtime=$p(^PAADM(adm),"^",7) 
	 .i +admtime>0 s admtime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(admtime)
	 .s curWardDesc=""
	 .s curWard=$p(^PAADM(adm),"^",70) 
	 .i curWard'="" s curWardDesc=$p(^PAWARD(+curWard),"^",2)
	 .i curWardDesc["-" s curWardDesc=$p(curWardDesc,"-",2)
	 .s curBedcode=""
	 .s curBed=$p(^PAADM(adm),"^",73) i curBed'="" d
	 ..s w=+curBed,b=$p(curBed,"||",2) q:(w="")!(b="")
	 ..s curBedcode=$p(^PAWARD(w,"BED",b),"^",1)
	 .s doctor=$p(^PAADM(adm),"^",9)
	 .i doctor'=""  s doctor=$p(^CTPCP(doctor,1),"^",2 )
	 .s n=n+1
	 .s data=$g(adm)_"^"_$g(depDesc)_"^"_$g(admdate)_"^"_$g(admtime)_"^"_$g(curWardDesc)_"^"_$g(curBedcode)_"^"_$g(doctor)_"^"_+$g(curWard)_"^"_RegNo
	 .s ^TMP("DHCST","DHCSTPIVABATUPDATE","GetAdmDs",pid,n)=data
     q:n=0 ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign() //输出空的json串
     w ##class(web.DHCSTJQUERYCOMMON).getJsonStartSign(n) //输出json前缀串
     s maxrow=n
     s count=0
     s h=""
     f  s h=$o(^TMP("DHCST","DHCSTPIVABATUPDATE","GetAdmDs",pid,h)) q:h=""  d
     .s mdata=^TMP("DHCST","DHCSTPIVABATUPDATE","GetAdmDs",pid,h)
     .s count = count+1
	 .s Title="Adm^AdmLoc^AdmDate^AdmTime^CurrWard^CurrBed^CurrDoc^CurrWardID^RegNo"
	 .q:(count<Start)||(count>End)
	 .I count=Start d
	 ..w ##class(web.DHCSTJQUERYCOMMON).getJsonData(Title,mdata)
	 .e  d
	 ..w ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(Title,mdata)
	
	 w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign() //输出json结尾符
	 k ^TMP("DHCST","DHCSTPIVABATUPDATE","GetAdmDs",pid)
     q ""
}

/// 生成科室批次字典集合(空批次除外)
/// Input:科室id,进程号
/// Output:生成Global
/// Creator:LiangQiang
/// CreatDate:2014-04-02
ClassMethod SetLocBatGolbal(ctlocdr, pid) As %String
{
	n (ctlocdr,pid)
	s pbtr=0
	f  s pbtr=$o(^PIVABT(pbtr)) q:(pbtr=0)||(pbtr="")  d
	.s pbtctlocdr=$p(^PIVABT(pbtr),"^",4)
	.q:pbtctlocdr'=ctlocdr
	.s batno=$p(^PIVABT(pbtr),"^",3)
	.q:batno'=+batno
	.s ^TMP("DHCST","DHCSTPIVAPRINTLABEL","SetLocBatGolbal",pid,batno)=""
	.
	q 0
}

/// 按人生成同批次的优先级数据:1药品2固定批次3频次4剂量
/// Creator:LiangQiang
/// CreatDate:2015-12-02
/// w ##class(web.DHCSTPIVAPRINTLABEL).SetOrdDataIndex
ClassMethod SetOrdDataIndex(Index, mdodis, PID, Wardid, TmpBat, TotalML) As %String
{
	n (Index, mdodis, PID, Wardid, TmpBat,TotalML)
	
	s ret=..GetOrdSpecBatNo(PID,Wardid,mdodis) 
	s BatNo=$p(TmpBat,"^",1)
	s GrpNo=$p(TmpBat,"^",2)
	s TotalML=+TotalML
	s Moeori=$p(^DHCOEDISQTY(mdodis),"^",1)
 	s indexlev=+$o(^TMP("DHCST","DHCSTPIVAPRINTLABEL","GetOrdSpecBatNo",PID,"ItmBt",mdodis,""))
 	i indexlev=0 s indexlev=899 //没有维护的药品忽略
 	s indexlev=100+indexlev  //药品优先级高
 	s batnolev=$o(^TMP("DHCST","DHCSTPIVAPRINTLABEL","GetOrdSpecBatNo",PID,"ItmBLev",mdodis,"")) //固定批次
 	i batnolev'="" s indexlev=indexlev_","_1  //固定批次优先
 	i batnolev="" s indexlev=indexlev_","_2
 	S freq=$P(^OEORD(+Moeori,"I",$p(Moeori,"||",2),2),"^",4)
 	;S freqcode=$P(^PHCFR(freq),"^",2)
 	;s freqcode=10
 	;s freqr=$o(^PIVAFREQR(0,"Freq",freq,""))
 	;i freqr'="" d
 	;.s freqcode=$p(^PIVAFREQR(freqr),"^",2)
 	;s freqlev=freqcode+10  //频次优先规则
 	//s freqlev=100-freqcode  //大批次优先
 	s freqlev=..GetPhaFreqPri(mdodis,freq)
 	s indexlev=indexlev_","_freqlev
 	
 	s phalocdr=$p(^DHCOEDISQTY(mdodis),"^",24)
 	s coninfo=..GetOthConfigData(phalocdr)
 	s bigflag=$p(coninfo,"^",1)
 	s mllev=TotalML+10000  //小剂量优先
 	i bigflag="Y" s mllev=10000-TotalML  //大剂量优先
 	s indexlev=indexlev_","_mllev
 	//有配置优先级
	s ^TMP("DHCST","DHCSTPIVAPRINTLABEL","SetOrdDataIndex",PID,Index,BatNo,indexlev_"^"_mdodis_"^"_TotalML_"^"_GrpNo)=batnolev
  
	i batnolev'="" d
	.//强制批号
	.s ^TMP("DHCST","DHCSTPIVAPRINTLABEL","SetOrdDataIndexBat",PID,mdodis)=batnolev
	
	k ^TMP("DHCST","DHCSTPIVAPRINTLABEL","GetOrdSpecBatNo",PID,"ItmBt")
	k ^TMP("DHCST","DHCSTPIVAPRINTLABEL","GetOrdSpecBatNo",PID,"ItmBLev")
	q 0
}

/// 药品固定批次
ClassMethod GetOrdSpecBatNo(PID, Wardid, mdodis) As %String
{
	n (PID,Wardid,mdodis)
	
	s moeori=$p(^DHCOEDISQTY(mdodis),"^",1) 
	s wardlev=##class(web.DHCSTPIVA).GetWardLevNo(Wardid, moeori)
	s batnolev=$p(wardlev,"^",2)
	i batnolev'="" d
	.s ^TMP("DHCST","DHCSTPIVAPRINTLABEL","GetOrdSpecBatNo",PID,"ItmBLev",mdodis,batnolev)=""
	s itmlev=+$p(wardlev,"^",1)
	i itmlev>0 d
	.s itmlev=itmlev+100
	.s ^TMP("DHCST","DHCSTPIVAPRINTLABEL","GetOrdSpecBatNo",PID,"ItmBt",mdodis,itmlev)=""
	
	s ord=+moeori
	S gchl=0
	F  S gchl=$o(^OEORDi(0,"OEORI",ord,moeori,gchl)) Q:gchl=""  D
 	.S toeori=ord_"||"_gchl
 	.Q:'$d(^DHCOEDISQTY(0,"OEORI",toeori))
 	.S dosage=##class(web.DHCSTPIVA).GetDosage(toeori)
 	.q:dosage=""
 	.s wardlev=##class(web.DHCSTPIVA).GetWardLevNo(Wardid, toeori)
	.s batnolev=$p(wardlev,"^",2)
	.;s desc=$P(##class(web.DHCSTPIVA).GetIncItm(toeori),"^",3)
	.;s inci=$P(##class(web.DHCSTPIVA).GetIncItm(toeori),"^",1)
	.;w !,desc_"^"_inci
	.;i batnolev'="" s batnolev=9
	.i batnolev'="" d
	..s ^TMP("DHCST","DHCSTPIVAPRINTLABEL","GetOrdSpecBatNo",PID,"ItmBLev",mdodis,batnolev)=""
	.s itmlev=+$p(wardlev,"^",1)
	.i itmlev>0 d
	..s itmlev=itmlev+100
	..s ^TMP("DHCST","DHCSTPIVAPRINTLABEL","GetOrdSpecBatNo",PID,"ItmBt",mdodis,itmlev)=""
	q ""
}

/// 自动生成配液批次规则介绍:
/// Input:进程号
/// Output:生成批次Global
/// Creator:LiangQiang
/// CreatDate:2015-12-17
/// w ##class(web.DHCSTPIVAPRINTLABEL).ChangeOrdBatNo("130206")
ClassMethod ChangeOrdBatNo(PID) As %String
{
	n (PID)
	s index=""
	f  s index=$o(^TMP("DHCST","DHCSTPIVAPRINTLABEL","CollWard",PID,index)) q:index=""  d
	.q:..CheckAutoCreateBatNo(index,PID)=0  //不具备计算生成批次条件
	.s wardid=$p(index,"||",2)
	.s phaloc=$p(index,"||",5)
	.s coninfo=..GetOthConfigData(phaloc)
	.s conflag=$p(coninfo,"^",2)  //持续输液量
	.s resnextml=0 //占用下一批次上限的量
	.s batno=""
	.f  s batno=$o(^TMP("DHCST","DHCSTPIVAPRINTLABEL","SetLocBatGolbal",PID,batno)) q:batno=""  d   //循环批次字典
	..s wardmlstr=##class(web.DHCSTPIVA).GetWardCubage(wardid,batno,phaloc)
	..s wardmin=$p(wardmlstr,"^",1)
	..s wardmax=$p(wardmlstr,"^",2)
	..q:wardmax="" //没有启用容量规则退出
	..i conflag="Y" s wardmax=wardmax-resnextml //上一批总容量多出上限的量要占用了下一批的上限量)
	..i wardmax'>0 s wardmax=0
	..s maxml=+$G(^TMP("DHCST","DHCSTPIVAPRINTLABEL","CollWard",PID,index,batno))
	..s tmpmaxml=maxml
	..s curml=maxml
    ..//如果容量小于上限,上移
    ..i maxml<wardmax d
    ...Q:$G(BSY)=""
    ...s nextbat=batno
    ...f  s nextbat=$o(^TMP("DHCST","DHCSTPIVAPRINTLABEL","SetOrdDataIndex",PID,index,nextbat)) q:(nextbat="")||(maxml'<wardmax)  d   
	....s lev="" 
	....f  s lev=$o(^TMP("DHCST","DHCSTPIVAPRINTLABEL","SetOrdDataIndex",PID,index,nextbat,lev)) q:(lev="")||(maxml'<wardmax)  d
	.....s mdodis=$p(lev,"^",2)
	.....q:$d(^TMP("DHCST","DHCSTPIVAPRINTLABEL","SetOrdDataIndexBat",PID,mdodis))  //有强制的不移动
	.....q:maxml'<wardmax  //如果上移后超上限,则停止上移
	.....s oneml=$p(lev,"^",3) //一代的容量
	.....s grpno=$p(lev,"^",4)
	.....s maxml=maxml+oneml
	.....s ^TMP("DHCST","DHCSTPIVAPRINTLABEL","ChangeOrdBatNo",PID,"BATRET",mdodis,grpno)=batno
	.....k ^TMP("DHCST","DHCSTPIVAPRINTLABEL","SetOrdDataIndex",PID,index,nextbat,lev)  //避免重复
	.....s ^TMP("DHCST","DHCSTPIVAPRINTLABEL","CollWard",PID,index,nextbat)=^TMP("DHCST","DHCSTPIVAPRINTLABEL","CollWard",PID,index,nextbat)-oneml
	....
	..//如果容量大于上限,下移,倒序
	..s maxml=tmpmaxml
    ..i maxml>wardmax d
    ...s lev="" 
	...f  s lev=$o(^TMP("DHCST","DHCSTPIVAPRINTLABEL","SetOrdDataIndex",PID,index,batno,lev),-1) q:(lev="")||(maxml'>wardmax)  d
	....s mdodis=$p(lev,"^",2)
	....q:$d(^TMP("DHCST","DHCSTPIVAPRINTLABEL","SetOrdDataIndexBat",PID,mdodis))  //有强制的不移动
	....//q:maxml'>wardmax  //如果下移小于上限,则停止下移
	....s oneml=$p(lev,"^",3) //一代的容量
	....s grpno=$p(lev,"^",4)
	....s maxml=maxml-oneml
	....s curml=maxml  //当前批次的最终总量
	....i maxml<wardmax s curml=maxml+oneml
	....q:maxml<wardmax  //如果下移后小于上限,则停止下移
	....s nextbat=$o(^TMP("DHCST","DHCSTPIVAPRINTLABEL","SetLocBatGolbal",PID,batno))
	....q:nextbat=""
	....k ^TMP("DHCST","DHCSTPIVAPRINTLABEL","SetOrdDataIndex",PID,index,batno,lev)  //避免重复
	....s ^TMP("DHCST","DHCSTPIVAPRINTLABEL","ChangeOrdBatNo",PID,"BATRET",mdodis,grpno)=nextbat
	....S OrdDataIndex=..SetOrdDataIndex(index, mdodis, PID, wardid, nextbat_"^"_grpno,oneml)
	....s ^TMP("DHCST","DHCSTPIVAPRINTLABEL","CollWard",PID,index,nextbat)=+$G(^TMP("DHCST","DHCSTPIVAPRINTLABEL","CollWard",PID,index,nextbat))+oneml
	...
	..
	..i wardmax'=0 s resnextml=curml-wardmax
	..i wardmax=0 s resnextml=resnextml-$p(wardmlstr,"^",2)
	.
    
	q 0
}

/// 检查是否可以自动计算批次
/// 1－可以,0－不可以
/// Creator:LiangQiang
/// CreatDate:2014-04-02
ClassMethod CheckAutoCreateBatNo(index, pid) As %String
{
	n (index, pid)  
	q:$d(^TMP("DHCST","DHCSTPIVAPRINTLABEL","SetPrintedFlag",pid,index,1)) 0	
	q 1
}

/// 判断某人当天医嘱是否已打过瓶签
/// Flag=1 已打过签
/// Creator:LiangQiang
/// CreatDate:2014-04-02
ClassMethod SetPrintedFlag(index, pid, dodis) As %String
{
	n (index,pid,dodis)
	S pogi=##class(web.DHCSTPIVA).GetOGrpI(dodis)
	i pogi'="" d
	.s flag=1
	.S ^TMP("DHCST","DHCSTPIVAPRINTLABEL","SetPrintedFlag",pid,index,1)="" 
	q
}

/// 获取科室下所有批次信息
/// Input:科室ID
/// Output:所有批次信息
/// Creator:LiangQiang
/// CreatDate:2015-12-17
/// Last Update By HaiBaoYun ,添加批次号的排序
/// w ##class(web.DHCSTPIVABATUPDATE).GetPhaLocBatInfo(101)
ClassMethod GetPhaLocBatInfo(PLocID) As %String
{
	n (PLocID)
	s pbtr=0
	f  s pbtr=$o(^PIVABT(pbtr)) q:(pbtr=0)||(pbtr="")  d
	.s pbtctlocdr=$p(^PIVABT(pbtr),"^",4)
	.q:pbtctlocdr'=PLocID
	.s warddr=$p(^PIVABT(pbtr),"^",6)
	.q:warddr'=""
	.s batno=$p(^PIVABT(pbtr),"^",3)
	.s batno=$$ALPHAUP^SSUTIL4(batno)
	.s batid=+pbtr
	.s GetPhaLocBatInfo(batno,batid)=""
	s ret=""
	s outputi=""
	f  s outputi=$o(GetPhaLocBatInfo(outputi)) q:outputi=""  d
	.s outputj=""
	.f  s outputj=$o(GetPhaLocBatInfo(outputi,outputj)) q:outputj=""  d
	..s tmp=outputj_","_outputi
	..i ret="" d
	...s ret=tmp
	..e  d
	...s ret=ret_"^"_tmp
	q ret
}

/// 完整取批次方法
/// Input:打包表id
/// Output:批号
/// Creator:LiangQiang
/// CreatDate:2015-12-18
/// w ##class(web.DHCSTPIVABATUPDATE).GetDspBatNo(3160)
ClassMethod GetDspBatNo(DspId) As %String
{
	 n (DspId)
 	 s batno=..GetDspCompBatNo(DspId)
 	 i batno="" s batno=..GetDspUpBatNo(DspId)
 	 i batno="" s batno=..GetDspWardLevBatNo(DspId)
 	 i batno="" s batno=..GetDspTimeBatNo(DspId)
 	 i batno="" s batno=1
 	 q batno
}

/// 取分发时间批号
/// Input:打包表id
/// Output:批号
/// Creator:LiangQiang
/// CreatDate:2015-12-18
ClassMethod GetDspTimeBatNo(DspId) As %String
{
	 n (DspId)
	 s oeori=$p(^DHCOEDISQTY(DspId),"^",1)
	 s PLocID=$p(^DHCOEDISQTY(DspId),"^",24)
     S stttime=$p(^DHCOEDISQTY(DspId),"^",20)
 	 S seqflag=##class(web.DHCSTPIVA).GetOISeqFlag(oeori)
 	 s batno=##class(web.DHCSTPIVA).GetBatNo(PLocID,stttime,seqflag)
 	 q batno
}

/// 取病区强型的批号
/// Input:打包表id
/// Output:批号
/// Creator:LiangQiang
/// CreatDate:2015-12-18
ClassMethod GetDspWardLevBatNo(DspId) As %String
{
	 n (DspId)
 	 s PID=##class(web.DHCSTPIVAPRINTLABEL).NewPid()
 	 s WardLocId=$p(^DHCOEDISQTY(DspId),"^",22)
     s wardid=$o(^PAWARD(0,"WARD_LocationDR",WardLocId,""))
 	 s ret=..GetOrdSpecBatNo(PID,wardid,DspId) 
 	 s wardbatno=$o(^TMP("DHCST","DHCSTPIVAPRINTLABEL","GetOrdSpecBatNo",PID,"ItmBLev",DspId,"")) //固定批次
 	 k ^TMP("DHCST","DHCSTPIVAPRINTLABEL","GetOrdSpecBatNo",PID)
 	 q wardbatno
}

/// 取手工修改后的批号
/// Input:打包表id
/// Output:批号
/// Creator:LiangQiang
/// CreatDate:2015-12-18
ClassMethod GetDspUpBatNo(DspId) As %String
{
	 n (DspId)
 	 S grpno=$p(^DHCOEDISQTY(DspId),"^",4)
 	 S batno=##class(web.DHCSTPIVA).GetUpBatNo(DspId,grpno)	
 	 q batno
}

/// 取排批后的批号
/// Input:打包表id
/// Output:批号
/// Creator:LiangQiang
/// CreatDate:2015-12-18
ClassMethod GetDspCompBatNo(DspId) As %String
{
	 n (DspId)
	 q ""
 	 S grpno=$p(^DHCOEDISQTY(DspId),"^",4)
 	 S batno=##class(web.DHCSTPIVA).GetUpBatNo(DspId,grpno)	
 	 q batno
}

/// 获取频次优先级
/// Input:打包表id,频次id
/// Output:批号
/// Creator:LiangQiang
/// CreatDate:2015-12-18
ClassMethod GetPhaFreqPri(DspId, freqdr) As %String
{
	n (DspId,freqdr)
    s ordnum=99
	s phalocdr=$p(^DHCOEDISQTY(DspId),"^",24)
	s pfr=$o(^PIVAFREQR(0,"Freq",phalocdr,freqdr,""))
	i (pfr'="")&&($d(^PIVAFREQR(pfr))) d
	.s ordnum=$p(^PIVAFREQR(pfr),"^",2)
	.s ordnum=ordnum+10
	q ordnum
}

/// 获取其它规则信息
/// Input:科室id
/// Output:
/// Creator:LiangQiang
/// CreatDate:2015-12-18
ClassMethod GetOthConfigData(phalocdr) As %String
{
	n (phalocdr)
    s data=""
	s pfr=$o(^PIVAOTHR(0,"Loc",phalocdr,""))
	i pfr'="" d
	.s bigflag=$p(^PIVAOTHR(pfr),"^",1)
	.s conflag=$p(^PIVAOTHR(pfr),"^",2)
	.s data=bigflag_"^"_conflag
	q data
}

/// 获取科室维护的科室组列表
/// Input:科室id
/// Output:
/// Creator:LiangQiang
/// CreatDate:2015-12-29
ClassMethod GetLocListByGrp(phalocdr) As %String
{
	n (phalocdr)
	s h=0
	S PID=##class(web.DHCSTPIVAPRINTLABEL).NewPid()
	s slgr=""
	f  s slgr=$o(^DHCSLG(0,"Type","G",slgr)) q:slgr=""  d
	.s tmplocdr=$p(^DHCSLG(slgr),"^",5)
	.s slgdesc=$p(^DHCSLG(slgr),"^",2)
	.q:tmplocdr'=phalocdr
	.s h=h+1
	.s data=slgdesc_"^"_slgr
	.s ^TMP("DHCST","DHCSTPIVABATUPDATE","GetLocListByGrp",PID,"Data",h)=data

	s count=0
	w "["
	s h=""
	f  s h=$o(^TMP("DHCST","DHCSTPIVABATUPDATE","GetLocListByGrp",PID,"Data",h)) q:h=""  d
	.s data=^TMP("DHCST","DHCSTPIVABATUPDATE","GetLocListByGrp",PID,"Data",h)
	.s RowId = $p(data,"^",2)
	.s Desc = $p(data,"^",1)
	.s tmp=RowId_"^"_Desc
	.s count = count+1
	.I count=1 d
	..W ##class(web.DHCSTJQUERYCOMMON).getJsonData("rowId^Desc",tmp)
	.e  d
	..W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData("rowId^Desc",tmp)
	
	w "]"
	q ""
}

/// 生成排批
/// Input:PID,用户ID
/// Output:
/// Creator:LiangQiang
/// CreatDate:2015-12-29
ClassMethod UpdBatData(input) As %String
{
	N (input)
	s n=0
    s PID=$p(input,"^",1)
    s UserID=$p(input,"^",2)
	s mdsp=""
	f  s mdsp=$o(^TMP("DHCST","DHCSTPIVABATUPDATE","UPD",PID,"ADMBAT",mdsp)) q:mdsp=""  d
	.s grpno=""
	.f  s grpno=$o(^TMP("DHCST","DHCSTPIVABATUPDATE","UPD",PID,"ADMBAT",mdsp,grpno)) q:grpno=""  d
	..s batno=^TMP("DHCST","DHCSTPIVABATUPDATE","UPD",PID,"ADMBAT",mdsp,grpno)
	..q:..GetSysUpdBatNo(mdsp,grpno)'="" //已排批
	..s tmpb=..GetDspUpBatNo(mdsp)
	..i tmpb'="" s batno=tmpb  //以最后手工更新的为准
	..K PLIST
	..S PLIST(2)=mdsp
	..S PLIST(3)=grpno
	..S PLIST(4)=batno
	..S PLIST(5)=UserID
	..S PLIST(6)=+$H
	..S PLIST(7)=$P($H,",",2)
	..S PLIST(8)="Y"
	..&SQL(Insert Into PIVA_BatUp Values :PLIST())
	..i SQLCODE=0 s n=n+1
	..;s ^lq(mdsp)=batno
	Q n
}

/// 获取系统生成的批次
/// Input:PID,用户ID
/// Output:
/// Creator:LiangQiang
/// CreatDate:2015-12-29
ClassMethod GetSysUpdBatNo(dsp As %String, grpno As %String) As %String
{
	n (dsp,grpno)
	q:dsp="" ""
	s updflag=""
	s bupddr=$o(^PIVABU(0,"OEGRP",dsp,grpno,""),-1)
	i bupddr'="" d
	.s updflag=$p(^PIVABU(bupddr),"^",7)
	q updflag
}

/// 获取用法列表
/// Output:
/// Creator:LiangQiang
/// CreatDate:2015-12-29
ClassMethod GetPhInstList() As %String
{

	s h=0
	S PID=##class(web.DHCSTPIVAPRINTLABEL).NewPid()
	s phcinr=""
	f  s phcinr=$o(^PHCIN(phcinr)) q:phcinr=""  d
	.s desc=$p(^PHCIN(phcinr),"^",2)
	.s h=h+1
	.s data=desc_"^"_phcinr
	.s ^TMP("DHCST","DHCSTPIVABATUPDATE","GetPhInstList",PID,"Data",h)=data
	s count=0
	w "["
	s h=""
	f  s h=$o(^TMP("DHCST","DHCSTPIVABATUPDATE","GetPhInstList",PID,"Data",h)) q:h=""  d
	.s data=^TMP("DHCST","DHCSTPIVABATUPDATE","GetPhInstList",PID,"Data",h)
	.s RowId = $p(data,"^",2)
	.s Desc = $p(data,"^",1)
	.s tmp=RowId_"^"_Desc
	.s count = count+1
	.I count=1 d
	..W ##class(web.DHCSTJQUERYCOMMON).getJsonData("rowId^Desc",tmp)
	.e  d
	..W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData("rowId^Desc",tmp)
	
	w "]"
	k ^TMP("DHCST","DHCSTPIVABATUPDATE","GetPhInstList",PID,"Data")
	q ""
}

/// Creator: LiangQiang
/// CreatDate: 2015-12-29
/// Description: 验证该病区是否属于该科室组
/// Input: 科室组Rowid, ward病区rowid
/// Output: 1-真,0-假
ClassMethod CheckWardByLocGrp(slg As %String, ward As %String) As %String
{
	n (slg,ward)
	s ret=0
	q:slg="" 1
	q:ward="" 1 
    s ret=0
    s sub=""
    f  s sub=$o(^DHCSLG(slg,"I",sub)) q:(sub="")||(ret=1)  d
    .s tmplocdr=$p(^DHCSLG(slg,"I",sub),"^",1)
    .s tmpwardr=$o(^PAWARD(0,"WARD_LocationDR",tmplocdr,""))
    .i tmpwardr=ward d
    ..s ret=1
    q ret
}

/// Creator:Liang Qiang
/// CreatDate:2015-12-29
/// Description:清除TMP
/// Input:PID
/// Retrun:
ClassMethod ClearTMP(PID) As %Integer
{
	n (PID)
	k ^TMP("DHCST","DHCSTPIVABATUPDATE","UPD",PID,"ADMBAT")
    s ret=..ClearTMPG(PID)
	q ""
}

/// Creator:Liang Qiang
/// CreatDate:2015-12-29
/// Description:清除TMP
/// Input:PID
/// Retrun:
ClassMethod ClearTMPG(PID) As %Integer
{
	n (PID)
	k ^TMP("PIVA",PID,"D","DATA")
    k ^TMP("DHCST","DHCSTPIVAPRINTLABEL","CollWard","TotalMl",PID)
    k ^TMP("DHCST","DHCSTPIVAPRINTLABEL","CollWard",PID)
	k ^TMP("DHCST","DHCSTPIVAPRINTLABEL","SetLocBatGolbal",PID)
	k ^TMP("DHCST","DHCSTPIVAPRINTLABEL","SetOrdDataIndex",PID)
	k ^TMP("DHCST","DHCSTPIVAPRINTLABEL","ChangeOrdBatNo",PID)
	k ^TMP("DHCST","DHCSTPIVAPRINTLABEL","SetPrintedFlag",PID)
	k ^TMP("DHCST","DHCSTPIVAPRINTLABEL","GetOrdSpecBatNo",PID)
	k ^TMP("DHCST","DHCSTPIVABATUPDATE","GetCurPatBatInfo",PID)
	q ""
}

/// Creator:Liang Qiang
/// CreatDate:2015-12-31
/// Description:取打包表的批次(计算后的批次)
/// Input:打包表id
/// Retrun:w ##class(web.DHCSTPIVABATUPDATE).GetCurPatBatNo(31745,154381)
ClassMethod GetCurPatBatNo(DspId, PID) As %Integer
{
	n (DspId,PID)
	s grpno=$p(^DHCOEDISQTY(DspId),"^",4)
	s batno=$g(^TMP("DHCST","DHCSTPIVABATUPDATE","UPD",PID,"ADMBAT",DspId,grpno))
	q:$d(^TMP("DHCST","DHCSTPIVABATUPDATE","UPD",PID,"ADMBAT",DspId,grpno)) batno
	i batno="" s batno=..GetDspBatNo(DspId)
	q batno
}

/// Creator:Liang Qiang
/// CreatDate:2015-12-31
/// Description:获取科室批次combox
/// Input:科室id
/// Retrun:
/// w ##CLASS(web.DHCSTPIVABATUPDATE).GetLocBatNoCombo(101)
ClassMethod GetLocBatNoCombo(PLocID) As %Integer
{
	
	n (PLocID)
	s ret=""
	s h=0
	S PID=##class(web.DHCSTPIVAPRINTLABEL).NewPid()
	s pbtr=0
	f  s pbtr=$o(^PIVABT(pbtr)) q:(pbtr=0)||(pbtr="")  d
	.s pbtctlocdr=$p(^PIVABT(pbtr),"^",4)
	.q:pbtctlocdr'=PLocID
	.s warddr=$p(^PIVABT(pbtr),"^",6)
	.q:warddr'=""
	.s batno=$p(^PIVABT(pbtr),"^",3)
	.s h=h+1
	.s data=batno_"^"_pbtr
	.s index=batno_"^"_pbtr_"^"_h
	.s ^TMP("DHCST","DHCSTPIVABATUPDATE","GetLocBatNoCombo",PID,"Data",index)=data
	s count=0
	w "["
	s h=""
	f  s h=$o(^TMP("DHCST","DHCSTPIVABATUPDATE","GetLocBatNoCombo",PID,"Data",h)) q:h=""  d
	.s data=^TMP("DHCST","DHCSTPIVABATUPDATE","GetLocBatNoCombo",PID,"Data",h)
	.s RowId = $p(data,"^",2)
	.s Desc = $p(data,"^",1)
	.s tmp=RowId_"^"_Desc
	.s count = count+1
	.I count=1 d
	..W ##class(web.DHCSTJQUERYCOMMON).getJsonData("value^text",tmp)
	.e  d
	..W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData("value^text",tmp)
	
	w "]"
	k ^TMP("DHCST","DHCSTPIVABATUPDATE","GetLocBatNoCombo",PID,"Data")
	q ""
}

/// Creator:Liang Qiang
/// CreatDate:2015-12-31
/// Description:更新批次
/// Input:科室id,打包id,批号
/// Retrun:
ClassMethod UpdCurBatNo(UserId, PhLocDr, DspId, BatNo) As %Integer
{
	n (UserId,PhLocDr,DspId,BatNo)
	s GrpNo=$p(^DHCOEDISQTY(DspId),"^",4)
	S BatNo=$ZCVT(BatNo,"U")
	S chk=##class(web.DHCSTPIVA).CheckPLocBatNo(BatNo,PhLocDr)
	Q:chk=1 -5

	K PLIST
	S PLIST(2)=DspId
	S PLIST(3)=GrpNo
	S PLIST(4)=BatNo
	S PLIST(5)=UserId
	S PLIST(6)=+$H
	S PLIST(7)=$P($H,",",2)
	&SQL(Insert Into PIVA_BatUp Values :PLIST())
	Q:SQLCODE SQLCODE
	S ret=##class(web.DHCSTPIVAPRINTLABEL).UpdDspTimeDo(DspId,GrpNo,BatNo,PhLocDr)
	Q ret
}

}
