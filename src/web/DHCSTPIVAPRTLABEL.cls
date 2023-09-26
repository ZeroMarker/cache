Import SQLUser

/// 配液打签
Class web.DHCSTPIVAPRTLABEL Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:Liang Qiang
/// CreatDate:2015-12-01
/// Description:取配液待打签病区列表
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
	s LocGrpDr=$p(Input,"^",6)
	s InisID=$p(Input,"^",7)
	s batNoList=$p(Input,"^",8)
	s PrtedFlag=$p(Input,"^",9)
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
    ...q:##class(web.DHCSTPIVABATUPDATE).GetSysUpdBatNo(mdodis,grpno)="" //未排批
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
 	...///用法
 	...s InstruDr=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),2),"^",7)
 	...Q:(InisID'="")&(InstruDr'=InisID)
 	.../// 执行日期
 	...S sttdate=date	
 	...S sttdate2=$zd(sttdate,3)
 	...///配液分类
 	...S nextnumber=cnumber
    ...s psnumber=""
 	...S specstate=""
 	...S pogi=##class(web.DHCSTPIVA).GetOGrpI(DspId)
 	...I pogi'="" D
 	....S psdr=$P(^PIVA(+pogi),"^",6)
 	....S psnumber=$P(^PIVAS(psdr),"^",1)
 	....S nextstr=##class(web.DHCSTPIVA).GetNextStat(psdr,PLocID,pstype)	 ///下一个状态
 	....S nextnumber=$P(nextstr,"^",2)
 	....S specstate=$P(^PIVA(+pogi),"^",8)
 	...Q:(nextnumber'=cnumber)&(PrtedFlag'="Y")
 	...Q:(psnumber'=cnumber)&(PrtedFlag="Y")
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
	s WardIDStr=$p(Input,"^",4)
	s StDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StDate)
	s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	
	s LocGrpDr=$p(Input,"^",6)
	s InisID=$p(Input,"^",7)
	s batNoList=$p(Input,"^",8)
	s PrtedFlag=$p(Input,"^",9)
	S PID=##class(web.DHCSTPIVAPRINTLABEL).NewPid()

	Q:$O(^PIVAA(0))="" ""	/// 配液的医嘱子分类没有维护
	Q:$O(^PIVAO(0,"OECPR",PLocID,""))="" ""	/// 科室配液的医嘱优先级没有维护
	Q:$O(^PIVABT(0,"TIME",PLocID,""))="" ""	/// 科室配液的时间段分批没有维护
	
	
	s x=0
	S cnumber=10  /// 10固定为打签状态
	s type="I"
	s HospID=$p($g(^CTLOC(PLocID)),"^",22)
	s LastMainOrd=""
	
	S i=0,pno=0
	F date=StDate:1:EndDate D
	.s WLen=$l(WardIDStr,",")
	.f l=1:1:WLen d
	..s WardID=$p(WardIDStr,",",l)
	..q:##class(web.DHCSTPIVABATUPDATE).CheckWardByLocGrp(LocGrpDr,WardID)=0
	..s WardLocDr=$p(^PAWARD(WardID),"^",5)
	..S DspId=""
	..F  s DspId=$O(^DHCOEDISQTY(0,"REC",PLocID,date,"TC",WardLocDr,0,DspId)) q:DspId=""  d
	...S AdmDr=$p(^DHCOEDISQTY(DspId),"^",26)
	...Q:AdmDr=""
	...Q:'$D(^PAADM(AdmDr))
	...S admward=$P(^PAADM(AdmDr),"^",70) /// 病人所在病房
	...Q:##Class(web.DHCSTPIVA).IfQuitAdmStatusD(AdmDr)=1	//已经结算退出
	.../// 床号
 	...S bedid=$P(^PAADM(AdmDr),"^",73)
 	...S bed="*"
 	...I bedid'="" D
 	....S wardid=$P(bedid,"||",1)
 	....S bedsub=$P(bedid,"||",2)
 	....I $D(^PAWARD(wardid,"BED",bedsub)) S bed=$P(^PAWARD(wardid,"BED",bedsub),"^",1)
 	...s WardLocId=$p(^DHCOEDISQTY(DspId),"^",22)
    ...s wardid=$o(^PAWARD(0,"WARD_LocationDR",WardLocId,""))
	...//
 	...S papmi=$p(^PAADM(AdmDr),"^",1) 
	...S ipno=$P(^PAPER(papmi,"PAT",1),"^",1)
	...//索引
	...S index=date_"||"_admward_"||"_bed_"||"_ipno_"||"_PLocID
	...//
	...s OrdItmRowid=$p(^DHCOEDISQTY(DspId),"^",1)     ;OE_OrdItem表指针
    ...s OrdExeRowid=$p(^DHCOEDISQTY(DspId),"^",3)     ;OE_OrdExec表指针
    ...s ord=$p(OrdItmRowid,"||",1)
    ...s chl=$p(OrdItmRowid,"||",2)
	...S oeori=ord_"||"_chl
	...//Q:##Class(web.DHCSTPIVA).IfQuitPIVA(oeori)=1 //是否可配液
	.../// 非执行医嘱
	...//Q:$O(^OEORD(ord,"I",chl,"X",0))=""
	...s remark=##class(web.DHCSTPIVA).GetOrdItmRemark(oeori)
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
	.../// 护士审核
	...S Audited=##class(web.DHCSTCOMMONSRV).IfAuditByPriority(DspId)
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
 	...///用法
 	...s InstruDr=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),2),"^",7)
 	...Q:(InisID'="")&(InstruDr'=InisID)
 	...S incitm=##class(web.DHCSTPIVA).GetIncItm(oeori)
 	...S inci=$P(incitm,"^",1)
 	...//S sttdate=$P(^OEORD(ord,"I",chl,1),"^",9)	/// 执行日期
 	...//S stttime=$P(^OEORD(ord,"I",chl,1),"^",10)	/// 执行时间
 	...S sttdate=date
 	...s stttime=$p(^DHCOEDISQTY(DspId),"^",20)  ;分发时间
 	...i stttime'="" S stttime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(stttime) 	/// 执行时间
 	...S sttdate2=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(sttdate)  //_" "_stttime
 	...S seqno=$P(^OEORD(ord,"I",chl,3),"^",4)		/// 关联医嘱号
 	...s exStr=oeori_"^"_DspId
 	...s price=##class(web.DHCSTPRICE).GetSp(inci,sttdate,"",HospID,"",exStr)
 	...
 	...S grpno=$p(^DHCOEDISQTY(DspId),"^",4)
 	...S mdodis=##class(web.DHCSTPIVA).GetMainOEDispID(DspId,grpno)
 	...q:##class(web.DHCSTPIVABATUPDATE).GetSysUpdBatNo(mdodis,grpno)="" //未排批
 	...S nextnumber=cnumber
 	...s psnumber=""
 	...s specstate=""
 	...S pogi=##class(web.DHCSTPIVA).GetOGrpI(DspId)
 	...I pogi'="" D
 	....S psdr=$P(^PIVA(+pogi),"^",6)
 	....S psnumber=$P(^PIVAS(psdr),"^",1)
 	....S nextstr=##class(web.DHCSTPIVA).GetNextStat(psdr,PLocID,type)	 ///下一个状态
 	....S nextnumber=$P(nextstr,"^",2)
 	....S specstate=$P(^PIVA(+pogi),"^",8)
 	...Q:(nextnumber'=cnumber)&(PrtedFlag'="Y")
 	...Q:(psnumber'=cnumber)&(PrtedFlag="Y")
 	...Q:(specstate="C")!(specstate="R")
 	.../// 护士审核
 	...S stttime=$p(^DHCOEDISQTY(DspId),"^",20)
 	...I mdodis'="" D
 	....I $D(^DHCOEDISQTY(mdodis)) S stttime=$p(^DHCOEDISQTY(mdodis),"^",20)	/// 执行时间
 	...s batno=##class(web.DHCSTPIVABATUPDATE).GetDspBatNo(mdodis) //批号
 	...q:##class(web.DHCSTPIVABATUPDATE).ChkOrdItmBatNo(batNoList,batno)=0
 	...S j=sttdate2_"||"_bed_"||"_batno_"||"_grpno_"||"_mdodis
 	...s tmpbat=batno
 	...
 	...i '$d(^TMP("PIVA",PID,"D","DATA",j)) d
 	....s x=x+1
    ...s ^TMP("PIVA",PID,"D","DATA",j,DspId)=""    
     s ^TMP("PIVA",PID,"D","DATAS",x)="" 
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
	s batNoList=$p(Input,"^",8)
	s InisID=$p(Input,"^",7)
	s PrtedFlag=$p(Input,"^",9)
	S PID=##class(web.DHCSTPIVAPRINTLABEL).NewPid()
		
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
 	...///用法
 	...s InstruDr=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),2),"^",7)
 	...Q:(InisID'="")&(InstruDr'=InisID)
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
 	...q:##class(web.DHCSTPIVABATUPDATE).GetSysUpdBatNo(mdodis,grpno)="" //未排批
 	...S pogi=##class(web.DHCSTPIVA).GetOGrpI(DspId)
 	...s psnumber=""
 	...I pogi'="" D
 	....S psdr=$P(^PIVA(+pogi),"^",6)
 	....S psnumber=$P(^PIVAS(psdr),"^",1)
 	....S nextstr=##class(web.DHCSTPIVA).GetNextStat(psdr,PLocID,pstype)	 ///下一个状态
 	....S nextnumber=$P(nextstr,"^",2)
 	....S specstate=$P(^PIVA(+pogi),"^",8)
 	...//Q:(nextnumber'=cnumber)&(AllFlag'="1")
 	...//Q:((specstate="C")!(specstate="R"))&(AllFlag'="1")
 	...Q:(nextnumber'=cnumber)&(PrtedFlag'="Y")
 	...Q:(psnumber'=cnumber)&(PrtedFlag="Y")
 	...Q:(specstate="C")!(specstate="R")
 	...S stttime=$p(^DHCOEDISQTY(mdodis),"^",20)
 	...I mdodis'="" D
 	....I $D(^DHCOEDISQTY(mdodis)) S stttime=$p(^DHCOEDISQTY(mdodis),"^",20)	/// 执行时间
 	...S batno=##class(web.DHCSTPIVABATUPDATE).GetDspBatNo(mdodis) //批号
 	...q:##class(web.DHCSTPIVABATUPDATE).ChkOrdItmBatNo(batNoList,batno)=0
    ...S j=sttdate2_"||"_bed_"||"_batno_"||"_grpno_"||"_mdodis
 	...
 	...i '$d(^TMP("PIVA",PID,"D","DATA",j)) d
 	....s x=x+1
    ...s ^TMP("PIVA",PID,"D","DATA",j,DspId)=""
    
    s ^TMP("PIVA",PID,"D","DATAS",x)="" 
    q PID
}

/// w ##class(web.DHCSTPIVAPRTLABEL).GetPrtWardDetail(1,1,"101^2016-02-01^2016-04-25^54^^^^^Y")
ClassMethod GetPrtWardDetail(rows, page, Input) As %Integer
{
	n (rows, page,Input)
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行	
	s StDate=$p(Input,"^",2)
	s EndDate=$p(Input,"^",3)
	s StDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StDate)
	s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	s wardid=$p(Input,"^",4)
	s adm=$p(Input,"^",5)
    s PrtedFlag=$p(Input,"^",9)  
	i wardid'="" s PID=..CollWardItm(Input)	
	i adm'="" s PID=..CollAdmItm(Input)	
	q:$g(PID)="" ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	q:'$d(^TMP("PIVA",PID,"D","DATA")) ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	
 	s sum=$o(^TMP("PIVA",PID,"D","DATAS",""))

	s maxrow=sum
	i endpage>maxrow s endpage=maxrow
	
	s admnum=1  //adm计数
	s lastadm=""
	s count=0
	s j=""
	f  s j=$o(^TMP("PIVA",PID,"D","DATA",j)) q:j=""  d
	.s oedispstr=""
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
 	.S incidescSub=$P(incitm,"^",3) 
 	.S qty=$P(^DHCOEDISQTY(moedisp),"^",11)
 	.S buom=$P(^INCI(inci,1),"^",10)
 	.S buomdesc=$P(^CT("UOM",buom),"^",2)
 	.//打签数据
	.s WardLocId=$p(^DHCOEDISQTY(moedisp),"^",22)
    .s wardid=$o(^PAWARD(0,"WARD_LocationDR",WardLocId,""))
    .s phalocdr=$p(^DHCOEDISQTY(moedisp),"^",24)
	.s tmpdsp=""
    .f  s tmpdsp=$o(^TMP("PIVA",PID,"D","DATA",j,tmpdsp)) q:tmpdsp=""  d
    ..i oedispstr="" s oedispstr=tmpdsp
    ..e  s oedispstr=oedispstr_"!!"_tmpdsp
    ..s ^TMP("DHCST","DHCSTPIVAPRTLABEL","GetPrtWardDetail",PID,"SAVE",wardid,j,tmpdsp)=""
	..//汇总grid数据
	..s tmpoeori=$P(^DHCOEDISQTY(tmpdsp),"^",1)
	..S tmparcimid=$P(^OEORD(+tmpoeori,"I",$p(tmpoeori,"||",2),1),"^",2)
 	..S tmparcimm=$p(tmparcimid,"||",1)
 	..S tmpinci=$O(^INCI(0,"ARCIM_DR",tmparcimm,""))
 	..Q:'$D(^INCI(tmpinci,1)) 
 	..S tmpitmdesc=$P(^INCI(tmpinci,1),"^",2)
	..s tmpqty=$P(^DHCOEDISQTY(tmpdsp),"^",11)
	..S tmpbuom=$P(^INCI(tmpinci,1),"^",10)
 	..S tmpbuomdesc=$P(^CT("UOM",tmpbuom),"^",2)
 	..i '$d(^TMP("DHCST","DHCSTPIVAPRTLABEL","GetPrtWardDetail",PID,"INCI",tmpinci)) d
 	...s ^TMP("DHCST","DHCSTPIVAPRTLABEL","GetPrtWardDetail",PID,"INCI",tmpinci)=tmpitmdesc_"^"_tmpqty_"^"_tmpbuomdesc
 	..e  d
 	...s $p(^TMP("DHCST","DHCSTPIVAPRTLABEL","GetPrtWardDetail",PID,"INCI",tmpinci),"^",2)=$p(^TMP("DHCST","DHCSTPIVAPRTLABEL","GetPrtWardDetail",PID,"INCI",tmpinci),"^",2)+tmpqty
	.S ^TMP("DHCST","DHCSTPIVAPRTLABEL","GetPrtWardDetail",PID,"SAVE",wardid)=phalocdr_"^"_wardid_"^"_StDate_"^"_EndDate
	.//补打签数据
	.i PrtedFlag="Y" d
	..S pogi=##class(web.DHCSTPIVA).GetOGrpI(moedisp)
 	..I pogi'="" D
 	...S phac=$P(^PIVA(+pogi),"^",10)
 	...s ^TMP("DHCST","DHCSTPIVAPRTLABEL","GetPrtWardDetail",PID,"SAVEED",phac)=""
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
 	.s packstatestr=##class(web.DHCSTPIVA).GetPlogFlag(moedisp)
    .s packstate=$p(packstatestr,"^",2) 
    .s count=count+1
    .q:count<stpage
    .q:count>endpage
    .i lastadm="" s admcolor=0
    .i (lastadm'=papmi)&(lastadm'="") d
    ..s admnum=admnum+1
    ..i admnum#2=0 s admcolor=1 
    ..i admnum#2'=0 s admcolor=0
    .s lastadm=papmi
    .s TbPatNo=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("TbPatNo",patno)
    .s TbBatNo=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("TbBatNo",batno)
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
	.s TbPackState=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("TbPackState",packstate)
	.s TbDspStr=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("TbDspStr",oedispstr)
	.s TbPID=##class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("TbPID",PID)
	.s tmpstr=TbPatNo_TbBatNo_TbSttD_TbBedNo_TbName_TbMDsp_TbItmDesc_TbItmDescSub_TbDosage_TbFreq_TbInstruc_TbDoctor_TbQty_TbUomdesc_TbAdmcolor_TbPackState_TbDspStr_TbPID
	.
    .s startString=##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTJQUERYCOMMON).GetJsonLastRow(tmpstr)
	.
    .i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
	.
    k ^TMP("PIVA",PID,"D","DATA")
    k ^TMP("PIVA",PID,"D","DATAS")
    q ""
}

/// Creator:Liang Qiang
/// CreatDate:2015-12-29
/// Description:打签前预统计
/// Table:
/// Input:
/// Retrun:
ClassMethod GetPreStatData(rows, page, PID) As %Integer
{
	n (rows, page,PID)
	
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行

    q:'$d(^TMP("DHCST","DHCSTPIVAPRTLABEL","GetPrtWardDetail",PID,"INCI")) ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	
	s n=0
	s inci=""
	f  s inci=$o(^TMP("DHCST","DHCSTPIVAPRTLABEL","GetPrtWardDetail",PID,"INCI",inci)) q:inci=""  d
	.s data=^TMP("DHCST","DHCSTPIVAPRTLABEL","GetPrtWardDetail",PID,"INCI",inci)
	.s n=n+1
	.s ^TMP("DHCST","DHCSTPIVAPRTLABEL","GetPreStatData",PID,"INCITM",n)=data
	.
	
	s maxrow=$o(^TMP("DHCST","DHCSTPIVAPRTLABEL","GetPreStatData",PID,"INCITM",""),-1)
	i endpage>maxrow s endpage=maxrow
	
	s count=0
	s j=""
	f  s j=$o(^TMP("DHCST","DHCSTPIVAPRTLABEL","GetPreStatData",PID,"INCITM",j)) q:j=""  d
	.s data=^TMP("DHCST","DHCSTPIVAPRTLABEL","GetPreStatData",PID,"INCITM",j)
	.S desc=$p(data,"^",1) 
	.S qty=$p(data,"^",2)
	.S uom=$p(data,"^",3) 
    .s count=count+1
    .q:count<stpage
    .q:count>endpage
    .
    .s TbDesc=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("TbDesc",desc)
    .s TbQty=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("TbQty",qty)
	.s TbUom=##class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("TbUom",uom)
	.s tmpstr=TbDesc_TbQty_TbUom
    .s startString=##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTJQUERYCOMMON).GetJsonLastRow(tmpstr)
	.
    .i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
	.
 
    k ^TMP("DHCST","DHCSTPIVAPRTLABEL","GetPreStatData",PID,"INCITM")
    q ""
}

/// Creator:Liang Qiang
/// CreatDate:2015-12-29
/// Description:清除TMP
/// Input:PID
/// Retrun:
ClassMethod ClearTMP(PID) As %Integer
{
	n (PID)
	k ^TMP("DHCST","DHCSTPIVAPRTLABEL","GetPrtWardDetail",PID)
	q ""
}

/// Creator:Liang Qiang
/// CreatDate:2015-12-29
/// Description:保存打签数据
/// Table:
/// Input:
/// Retrun:w ##class(web.DHCSTPIVAPRTLABEL).SaveDisp("173014^711")
ClassMethod SaveDisp(input) As %Integer
{
	N (input,%session)
	s pid=$p(input,"^",1)
	s userid=$p(input,"^",2)
	S puser=userid
	Q:puser="" -1
	s ret=""
	s dex=""
	f  s dex=$o(^TMP("DHCST","DHCSTPIVAPRTLABEL","GetPrtWardDetail",pid,"SAVE",dex)) q:dex=""  d 
	.s str=^TMP("DHCST","DHCSTPIVAPRTLABEL","GetPrtWardDetail",pid,"SAVE",dex)
	.S pdatef=$P(str,"^",3)
	.S pdatet=$P(str,"^",4)
	.S ploc=$P(str,"^",1)
	.S pward=$P(str,"^",2)
	./// 1 保存发药主表
	.S:$g(pharowid)="" pharowid=##class(web.DHCSTPIVAPRINTLABEL).InsPhaCollected(ploc,pward,puser,pdatef,pdatet)
	.q:+pharowid'>0
	.S index="",h=0
	.F  S index=$O(^TMP("DHCST","DHCSTPIVAPRTLABEL","GetPrtWardDetail",pid,"SAVE",dex,index)) Q:index=""  D
    ..S Err=..SaveData(pid,dex,index,pharowid,puser,h)
    ..Q:Err'>0
    ..S h=h+1
	.i h=0 &sql(delete from  DHC_PHACollected where DHC_PHACollect_RowID=:pharowid )
    .i h>0 d
    ..i ret=""  d
    ...s ret=pharowid
    ..e  d
    ...s ret=ret_"^"_pharowid
   
	Q ret
}

/// 保存子表过程
ClassMethod SaveData(pid, dex, index, pharowid, puser, h) As %String
{
	N (pid,dex,index,pharowid,puser,h,%session)
	S sdate=$p(index,"||",1)
	S batno=$p(index,"||",3)
	S grpno=$p(index,"||",4)
	S moeori=$p(index,"||",5)
	S ploc=$p(^DHCOEDISQTY(moeori),"^",24)
	S PSNumber="10"
	S dispconfig=##class(web.DHCSTPIVA).GetPSNumberProByLoc(ploc,PSNumber)
	TSTART
	L +^DHCSTLOCK("PIVA",sdate,moeori,grpno):5  E  Q -100
	S quitflag=0
	S dodis=""
	F  S dodis=$O(^TMP("DHCST","DHCSTPIVAPRTLABEL","GetPrtWardDetail",pid,"SAVE",dex,index,dodis)) Q:(dodis="")||(quitflag'=0)  D
	.S stdate=$p(^DHCOEDISQTY(dodis),"^",21)
	.S sttime=$p(^DHCOEDISQTY(dodis),"^",20)
	.S pno=h+1
	./// 2 保存医嘱组主表
	.S moedisp=##class(web.DHCSTPIVA).GetMainOEDispID(dodis,grpno)
	.S pogid=##class(web.DHCSTPIVAPRINTLABEL).GetOrdGrpID(moedisp,grpno)
	.I pogid="" D
	..S pogid=##class(web.DHCSTPIVAPRINTLABEL).InsOrdGrp(ploc,moedisp,grpno,batno,stdate,sttime,pharowid,pno,puser)
	.E  D
	..S pogid=##class(web.DHCSTPIVAPRINTLABEL).UpdOrdGrp(pogid,ploc,batno,stdate,sttime,pharowid,pno,puser)
	.I +pogid<0 S quitflag=-1
	.Q:quitflag'=0
	./// 3 保存医嘱组子表
	.S pogiid=##class(web.DHCSTPIVAPRINTLABEL).InsOrdGrpItm(pogid,dodis)
	.I +pogiid<0 S quitflag=-2
	.Q:quitflag'=0
	/// 4 根据配置,即刻配液,减库存
	i (dispconfig="Y")&(quitflag=0) S quitflag=##class(web.DHCSTPIVARECHECK).SaveCheckOK(pid,pogid,PSNumber)
	
	I quitflag'=0 TROLLBACK
	L -^DHCSTLOCK("PIVA",sdate,moeori,grpno)
	I quitflag'=0 Q -3
	S h=h+1
	TCOMMIT
 	Q h
}

/// Creator:Liang Qiang
/// CreatDate:2015-12-29
/// Description:整理打签数据
/// Input:发药主表id
/// Retrun:
ClassMethod GetPrintItm(phacstr As %String) As %String
{
	N (phacstr)
	Q:phacstr="" ""
	S pid=##class(web.DHCSTPIVAPRINTLABEL).NewPid()

    s len=$l(phacstr,"^")
    f l=1:1:len d
    .s phac=$p(phacstr,"^",l)
	.S pog=""
	.F  S pog=$O(^PIVA(0,"PHAC",phac,pog)) Q:pog=""  D
	..S moedisp=$P(^PIVA(pog),"^",1)
	..S moeori=$P(^DHCOEDISQTY(moedisp),"^",3) /// 主医嘱ID
	..S batno=$P(^PIVA(pog),"^",3)	/// 批次
	..S mincitm=##class(web.DHCSTPIVA).GetIncItm(moeori)
 	..S minci=$P(mincitm,"^",1)
 	..S mincidesc=$P(mincitm,"^",3)
	..S pogsub=$O(^PIVA(pog,"I",""))
	..S nextpogsub=$O(^PIVA(pog,"I",pogsub))
	..i nextpogsub'="" s pogsub=nextpogsub
	..S dsp=$P(^PIVA(pog,"I",pogsub),"^",1)
	..S oeori=$P(^DHCOEDISQTY(dsp),"^",1) 
	..S incitm=##class(web.DHCSTPIVA).GetIncItm(oeori)
 	..S inci=$P(incitm,"^",1)
    ..S incidesc=$P(incitm,"^",3)
    ..s index=batno_","_inci_","_minci
	..S ^TMP("DHCST","DHCSTPIVAPRTLABEL","GetPrintItm",pid,"PrtIndex",index,pog)=phac  //批号+主+第一子药排序
    ..//汇总排序代数
    ..i '$d(^TMP("DHCST","DHCSTPIVAPRTLABEL","GetPrintItm",pid,"PrtGrpNum",index)) d
    ...s ^TMP("DHCST","DHCSTPIVAPRTLABEL","GetPrintItm",pid,"PrtGrpNum",index)=1
    ...s ^TMP("DHCST","DHCSTPIVAPRTLABEL","GetPrintItm",pid,"PrtGrpLev",1,index)=""
    ...s ^TMP("DHCST","DHCSTPIVAPRTLABEL","GetPrintItm",pid,"PrtGrp",index,1)=""
    ..e  d
    ...s $p(^TMP("DHCST","DHCSTPIVAPRTLABEL","GetPrintItm",pid,"PrtGrpNum",index),"^",1)=$p(^TMP("DHCST","DHCSTPIVAPRTLABEL","GetPrintItm",pid,"PrtGrpNum",index),"^",1)+1
    ...s lasnum=$o(^TMP("DHCST","DHCSTPIVAPRTLABEL","GetPrintItm",pid,"PrtGrp",index,""),-1)
    ...k ^TMP("DHCST","DHCSTPIVAPRTLABEL","GetPrintItm",pid,"PrtGrpLev",lasnum,index)
    ...k ^TMP("DHCST","DHCSTPIVAPRTLABEL","GetPrintItm",pid,"PrtGrp",index,lasnum)
    ...;
    ...s num=^TMP("DHCST","DHCSTPIVAPRTLABEL","GetPrintItm",pid,"PrtGrpNum",index)
    ...s ^TMP("DHCST","DHCSTPIVAPRTLABEL","GetPrintItm",pid,"PrtGrpLev",num,index)=""
    ...s ^TMP("DHCST","DHCSTPIVAPRTLABEL","GetPrintItm",pid,"PrtGrp",index,num)=""
    ...
   
    //先打出现次数最多的
    s i=0
    s num=""
    f  s num=$o(^TMP("DHCST","DHCSTPIVAPRTLABEL","GetPrintItm",pid,"PrtGrpLev",num),-1) q:num=""  d
    .s index=""
    .f  s index=$o(^TMP("DHCST","DHCSTPIVAPRTLABEL","GetPrintItm",pid,"PrtGrpLev",num,index)) q:index=""  d
    ..s pog=""
    ..f  s pog=$o(^TMP("DHCST","DHCSTPIVAPRTLABEL","GetPrintItm",pid,"PrtIndex",index,pog)) q:pog=""  d
    ...S phac=^TMP("DHCST","DHCSTPIVAPRTLABEL","GetPrintItm",pid,"PrtIndex",index,pog)
    ...S warddr=$P(^DHCPHAC(phac),"^",4)	/// 病区
	...S ward=$P(^PAWARD(warddr),"^",2)
	...S pnumber=$P(^PIVA(pog),"^",11)	/// 打印序号
    ...S pno="" /// 打印单号-序号
	...S moedisp=$P(^PIVA(pog),"^",1)
	...S moeori=$P(^DHCOEDISQTY(moedisp),"^",3) /// 主医嘱ID
	...S batno=$P(^PIVA(pog),"^",3)	/// 批次
	...S pcp=$P(^PIVA(pog),"^",15)		/// 取消打印表ID
	...S plocdr=$P(^PIVA(pog),"^",7)
	...S cpno=""
	...I pcp'="" D
	....S:$D(^PIVACP(pcp)) cpno=$P(^PIVACP(pcp),"^",1)
	...S cpnumber=$P(^PIVA(pog),"^",16)	/// 取消打印的序号
	...s notes=##class(web.DHCSTPIVA).GetNotes(moeori)      ///备注
	...i $l(notes)>10 d
	....s notes=$e(notes,1,10)_"…"
	...
	...S instruc=##class(web.DHCSTPIVA).GetInstruc(moeori)	/// 用法
	...S pri=##class(web.DHCSTPIVA).GetOePriority(moeori)	/// 优先级
	...S pri=$P(pri,"^",3)	
	...S freq=##class(web.DHCSTPIVA).GetFreq(moeori)	/// 频率
	...S freq=$P(freq,"^",2)
	...S patstr=##class(web.DHCSTPIVA).GetOeInfoByMoeori(moeori)	/// 病人信息
	...S odate=$P(^PIVA(pog),"^",4)
	...S printdate=$P(^DHCPHAC(phac),"^",7)
	...S pdate=$P(^DHCOEDISQTY(moedisp),"^",21) //##class(web.DHCSTPIVA).GetPyDate(moeori,batno,pri,printdate,odate,freq,plocdr)
	...S printdate=$P(^DHCPHAC(phac),"^",7)
	...S:printdate'="" printdate=$ZD(printdate,3)
	...S printtime=$P(^DHCPHAC(phac),"^",8)
	...S:printtime'="" printtime=$ZT(printtime,1)
	...S prtdt=printdate_" "_printtime
	...S:odate'="" odate=$ZD(odate,3)
	...S otime=$P(^PIVA(pog),"^",5)
	...S:otime'="" otime=$ZT(otime,1)
	...S dt=odate_" "_otime
	...S:pdate'="" pdate=$ZD(pdate,3)
	...S pdate=pdate_" "_otime
	...S bttime=##class(web.DHCSTPIVA).GetTimeByBatNo(phac,batno)
	...i bttime'="" s bttime=$ZT(bttime,1)
	...S dt=odate_" "_bttime
	...S pdate=pdate_" "_bttime
	...S TotalLiquid=##class(web.DHCSTPIVA).GetTotalLiquid(pog)
	...S adm=$P(^OEORD(+moeori),"^",1)
	...S pasts=##class(web.DHCSTPIVAPRINTLABEL).GetPasts(pid,phac,adm)
	...S pastno=##class(web.DHCSTPIVAPRINTLABEL).GetPastNo(pid,pog)
	...S grpno=$P(^PIVA(pog),"^",2)
	...S stype=""
	...S weight=##class(web.DHCSTPIVA).GetPatWeight(adm)
	...S chstr=##class(web.DHCSTPIVA).GetPassResult(moeori)
	...S passuser=$p(chstr,",",1) /// 配伍审核人
 	...S passuname=""
 	...I passuser'="" D
 	....I $D(^SSU("SSUSR",passuser)) D
 	.....S passuname=$P(^SSU("SSUSR",passuser),"^",1)
 	...S papmi=$p(^PAADM(adm),"^",1) 
 	...S PAAllergy=##class(web.DHCSTPIVA).GetPAAllergyStr(papmi,"")
 	...I PAAllergy'="" S PAAllergy="药物过敏:"_PAAllergy
 	...S doctor=##class(web.DHCSTPIVA).GetDoctor(moeori)	/// 医生
 	...S BatNums="",BatNN=""
 	...s prescno=$P(^OEORD(+moeori,"I",$p(moeori,"||",2),1),"^",14)
 	...;
 	...S skintest=##class(web.DHCSTPIVA).SkinTest(moeori)
 	...I skintest>0 S $P(patstr,"^",3)=$P(patstr,"^",3)_" "_"(皮试 — )"
 	...I skintest<0 S $P(patstr,"^",3)=$P(patstr,"^",3)_" "_"(皮试 + )"
 	...I skintest=-5 S $P(patstr,"^",3)=$P(patstr,"^",3)_" "_"(皮试   )"
 	...s packflag=$p(^DHCOEDISQTY(moedisp),"^",28) //静配打包状态
 	...i (packflag'="")&&(packflag'="N") s packflag="打包"
	...S i=i+1
	...S ^TMP("PIVA",pid,"POG",i)=pog_"^"_moeori_"^"_grpno_"^"_ward_"^"_pno_"^"_pnumber_"^"_batno_"^"_cpno_"^"_cpnumber_"^"_pri_"^"_freq_"^"_instruc_"^"_prtdt_"^"_TotalLiquid_"^"_pasts_"^"_pastno_"^"_patstr_"^"_stype_"^"_weight_"^"_passuname_"^"_prescno_"^"_pdate_"^"_doctor_"^"_packflag
	...S pogsub="",pogistr=""
	...F  S pogsub=$O(^PIVA(pog,"I",pogsub)) Q:pogsub=""  D
	....S dsp=$P(^PIVA(pog,"I",pogsub),"^",1)
	....Q:'$D(^DHCOEDISQTY(dsp))
	....S oeori=$P(^DHCOEDISQTY(dsp),"^",1) Q:oeori=""
	....S incitm=##class(web.DHCSTPIVA).GetIncItm(oeori)
 	....S inci=$P(incitm,"^",1)
 	....S incidesc=$P(incitm,"^",3)
	....S spec=##class(web.DHCSTCOMINC).GetSpec(inci)
	....S dosage=##class(web.DHCSTPIVA).GetDosage(oeori)
	....S dosageml=##class(web.DHCSTPIVA).GetDosageML(oeori)
	....i dosageml'="" s dosage=dosageml
	....S sign=##class(web.DHCSTPIVA).GetPrintSign(oeori)
	....S incidesc=sign_incidesc
	....S comp=##class(web.DHCSTPIVA).GetCompFlag(oeori)	/// 剂量是否整包装
	....;S qty=##Class(web.DHCSTPIVA).GetDspQty(oeori)
	....;s qty=0      //测试用，待修改
	....S BuomQtyStr=##Class(web.DHCSTPIVA).GetDosageBUom(oeori)
	....S BQty=$P(BuomQtyStr,"^",1)
	....S BUom=$P(BuomQtyStr,"^",2)
	....I pogistr="" S pogistr=incidesc_"^"_dosage_"^"_spec_"^"_comp_"^"_BQty_"^"_BUom
	....E  S pogistr=pogistr_"||"_incidesc_"^"_dosage_"^"_spec_"^"_comp_"^"_BQty_"^"_BUom
	...S ^TMP("PIVA",pid,"POGI",i)=pogistr


    k ^TMP("DHCST","DHCSTPIVAPRTLABEL","GetPrintItm",pid)
    q pid_"^"_i
}

/// Creator:Liang Qiang
/// CreatDate:2015-12-29
/// Description:整理打签数据
/// Input:发药主表id
/// Retrun:
ClassMethod GetPhacForRePrt(pid As %String) As %String
{
	n (pid)
	s phacstr=""
	s phac=""
	f  s phac=$o(^TMP("DHCST","DHCSTPIVAPRTLABEL","GetPrtWardDetail",pid,"SAVEED",phac)) q:phac=""  d
	.i phacstr="" d
	..s phacstr=phac
	.e  d
	..s phacstr=phacstr_"^"_phac
	q phacstr
}

/// Description:新配液打签更新打包状态
/// Creator:	yunhaibao
/// CreateDate:	2016-05-11
/// Table:      dhc_oedispensing
/// Input:      mdispid-打包表的主id,plogfalg-正常打包的状态标志	
/// Return：    0-更新成功,大于0-失败
/// w ##class(web.DHCSTPIVAPRTLABEL).UpdPogFlag("8556","Y")
ClassMethod UpdPogFlag(dspstr As %String, plogflag As %String) As %String
{
	n (dspstr,plogflag)
	s Err=0
	q:dspstr="" "打包id为空"
	s dspi=""
	s error=""
	s $zt="ERROR^DHCSTERROR"
	ts
	f dspi=1:1:$l(dspstr,"!!") q:error'=""  d
	.s dsprowid=$p(dspstr,"!!",dspi)
	.s ret=##class(web.DHCSTPIVAPRINTLABEL).UpdPogFlag(dsprowid,plogflag)
	.i ret'=0 d
	..i ret=3
	...s error="当前状态为护士打包状态,无需再次打包!"
	..e  i ret=4 d
	...s error="当前状态为二次打包状态,无需再次打包!"
	i error'="" tro
	q:error'="" error
	tc
	q 0
}

}
