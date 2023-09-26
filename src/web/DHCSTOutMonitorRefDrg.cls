Import sqluser

/// Creator:   bianshuai
/// CreateDate:2014-08-14
Class web.DHCSTOutMonitorRefDrg Extends %Library.RegisteredObject [ Not Abstract, ClassType = "", Not ProcedureBlock ]
{

/// Descript:  获取门诊处方审核拒绝医嘱明细
/// w ##class(web.DHCSTOutMonitorRefDrg).getOutMonitorRefDrg("0","20","20/03/2017","20/03/2017","63","","600","")
ClassMethod getOutMonitorRefDrg(Start As %String, Limit As %String, StartDate As %String, EndDate As %String, LocID As %String, RegNo As %String, doctorID As %String, EpisodeID As %String = "") As %String
{
	 N (Start,Limit,StartDate,EndDate,LocID,RegNo,doctorID,EpisodeID)
	 //s ^yunhaibao("web.DHCSTOutMonitorRefDrg","getOutMonitorRefDrg")=LocID_"^"_doctorID
	 s $zt="ErrorgetOutMonitorRefDrg"
	 S StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate) //起始日期
	 S EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)  //结束日期
	 i EpisodeID'="" d
	 .s StartDate=$p(^PAADM(EpisodeID),"^",6)
	 .s Papmi=$p(^PAADM(EpisodeID),"^",1)
	 .s RegNo=$p(^PAPER(Papmi,"PAT",1),"^",1)
	 S EndRow=Start+Limit  //结束行
	 S StRow=Start //开始行
	 S pid=..NewPid()
	 d ..killTmpGlobal(pid)
	 ///1、取数据
	 S Num=0
	 F Date=StartDate:1:EndDate D
	 .S MonitorID=""
 	 .F  S MonitorID=$o(^DHCPHORDM(0,"DateResult",Date,"N",MonitorID),-1) Q:MonitorID=""  D
 	 ..s AppType=$p(^DHCPHORDM(MonitorID),"^",9)
 	 ..s LastMonitor=""
 	 ..i AppType="OA" d
 	 ...s MonitorItm=+$o(^DHCPHORDM(MonitorID,"I",""))
 	 ...q:+MonitorItm=0
 	 ...s PrescNo=$p(^DHCPHORDM(MonitorID,"I",MonitorItm),"^",4)
 	 ...s TmpLastMonitor=""
 	 ...f  s TmpLastMonitor=$o(^DHCPHORDM(0,"PrescNo",PrescNo,TmpLastMonitor),-1) q:(TmpLastMonitor="")||(LastMonitor'="")  d
 	 ....q:+TmpLastMonitor=0
 	 ....q:$p(^DHCPHORDM(TmpLastMonitor),"^",12)'=""
 	 ....s LastMonitor=TmpLastMonitor
 	 ..q:(LastMonitor'=MonitorID)&&(AppType="OA") 
 	 ..S UserID=$p(^DHCPHORDM(MonitorID),"^",1)  //操作人
 	 ..S UserCode=$P($G(^SSU("SSUSR",UserID)),"^",1)
 	 ..s UserName=$P($G(^SSU("SSUSR",UserID)),"^",2)
 	 ..S Result=$p(^DHCPHORDM(MonitorID),"^",2)  //结果
 	 ..Q:Result="Y"  //审核通过的不显示
 	 ..S OpDate=$p(^DHCPHORDM(MonitorID),"^",3)  //日期
 	 ..S OpDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(OpDate,"OP")
 	 ..S OpTime=$p(^DHCPHORDM(MonitorID),"^",4)  //时间
 	 ..S OpTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(OpTime,"OP")
 	 ..S RefTime=OpDate_" "_OpTime
 	 ..S PhNote=$p(^DHCPHORDM(MonitorID),"^",6)  //药师备注
 	 ..S DocNote=$p(^DHCPHORDM(MonitorID),"^",7) //医生备注
 	 ..S AgreeFlag=$p(^DHCPHORDM(MonitorID),"^",8) //同意标志
 	 ..Q:AgreeFlag="Y"  //已经同意的不显示
 	 ..s CancelUser=$p(^DHCPHORDM(MonitorID),"^",12) //撤销的不显示
 	 ..q:CancelUser'=""
 	 ..s IACancel=""
 	 ..i AppType="IA" d //判断住院医嘱是否撤销
 	 ...s MonitorSub=+$o(^DHCPHORDM(MonitorID,"I",""))
 	 ...s MonitorOeori=$p($g(^DHCPHORDM(MonitorID,"I",MonitorSub)),"^",2)
 	 ...//i $p($g(^OEORD(+MonitorOeori,"I",$p(MonitorOeori,"||",2),7)),"^",3)="" s IACancel="1"
 	 ...i MonitorID'=$o(^DHCPHORDM(0,"OrdItem",MonitorOeori,""),-1) s IACancel="1"
 	 ...i Result="N" s AppType="医嘱审核拒绝"
 	 ..q:(IACancel'="")||(AppType="IA")
 	 ..i AppType="OA" s AppType="处方审核拒绝"
 	 ..e  i AppType="OR" s AppType="发药拒绝"
 	 ..s tmpOeori="",reasonNum=0
 	 ..S Ch=""
 	 ..F  S Ch=$o(^DHCPHORDM(MonitorID,"I",Ch)) Q:Ch=""  D
 	 ...S Oeori=$p(^DHCPHORDM(MonitorID,"I",Ch),"^",2) //医嘱ID
 	 ...Q:Oeori=""
 	 ...S Ord=+Oeori
	 ...S Itm=$p(Oeori,"||",2)
	 ...s Reason=""
	 ...S AudReasonDr=$p(^DHCPHORDM(MonitorID,"I",Ch),"^",3) //审核原因
 	 ...S:AudReasonDr'="" Reason=$p(^DHCPCREASON(AudReasonDr),"^",2)
	 ...S doccaredr=$p($g(^OEORD(Ord,"I",Itm,1)),"^",11) //开医嘱医生 CT_CareProv
	 ...s docdr=$s(doccaredr'="":$o(^SSU("SSUSR",0,"CTPCP",doccaredr,"")),1:"") 
     ...Q:docdr=""
     ...Q:(EpisodeID="")&&(doctorID'="")&(docdr'=doctorID)  //非指定医生
 	 ...S PrescNo=$p(^DHCPHORDM(MonitorID,"I",Ch),"^",4) //处方号
 	 ...S AdmDr=$p(^DHCPHORDM(MonitorID,"I",Ch),"^",5) //Adm
 	 ...S AdmDr=$p(^OEORD(Ord),"^",1)
 	 ...S bedid=$p(^PAADM(AdmDr),"^",73)   //床号
     ...I bedid="" S AdmBed=""
     ...E  S AdmBed=$p(^PAWARD($p(bedid,"||",1),"BED",$p(bedid,"||",2)),"^",1)
     ...S Type=$p(^PAADM(AdmDr),"^",2)   //病人类型
 	 ...S AdmWardDr=$p(^PAADM(AdmDr),"^",70)  //病区
 	 ...Q:(EpisodeID="")&&(Type="I")&(..getLocWardIfLink(LocID,AdmWardDr)'=1)  //住院按照病人科室
 	 ...S ArcItm=$p(^OEORD(Ord,"I",Itm,1),"^",2)
     ...S Inci=$o(^INCI(0,"ARCIM_DR",$p(ArcItm,"||",1),""))
     ...Q:Inci=""
     ...S InciDesc=$p(^INCI(Inci,1),"^",2)
     ...S baseuom=$p(^INCI(Inci,1),"^",10)
	 ...S puruom=$p(^INCI(Inci,3),"^",6)
	 ...S Papmi=$p(^PAADM(AdmDr),"^",1)
	 ...S PatNo=$p(^PAPER(Papmi,"PAT",1),"^",2) //登记号
	 ...Q:(RegNo'="")&(RegNo'=PatNo)
	 ...S PatName=$p(^PAPER(Papmi,"ALL"),"^",1) //姓名
	 ...s dspid=$o(^DHCOEDISQTY(0,"OEORI",Oeori,""))
	 ...q:dspid=""
	 ...s qty=$p(^DHCOEDISQTY(dspid),"^",2) //基本单位医嘱数量
	 ...s buomdr=+$p(^INCI(Inci,1),"^",10)
	 ...s puomdr=+$p(^INCI(Inci,3),"^",6)
	 ...s billuomdr=$p(^ARCIM(+ArcItm,$p(ArcItm,"||",2),8),"^",14)
	 ...s dispuomdr=$p($g(^OEORD(Ord,"I",Itm,"DHC")),"^",13)
	 ...i (dispuomdr'="")&&(dispuomdr'=puomdr)&&(dispuomdr'=buomdr)  d
	 ....s dbillfac=##class(web.DHCSTCOMMONSRV).UOMFac(dispuomdr,buomdr)
	 ....s qty=qty/dbillfac
	 ....s uomdr=dispuomdr
	 ...e  d
	 ....i Type="I" d
	 .....s bpfac=##class(web.DHCSTCOMMONSRV).UOMFac(puomdr,buomdr)
	 .....i qty#bpfac=0 s qty=qty/bpfac,uomdr=puomdr
	 .....e  s uomdr=buomdr
	 ....e  d
	 .....s bbillfac=##class(web.DHCSTCOMMONSRV).UOMFac(billuomdr,buomdr)
	 .....i qty#bbillfac=0 s qty=qty/bbillfac,uomdr=billuomdr
	 .....e  s uomdr=buomdr
	 ...S uomdesc=$p($g(^CT("UOM",uomdr)),"^",2) //单位
	 ...s qty=$fn(qty,"",$l($p(qty,".",2)))
	 ...S QtyUom=qty_uomdesc
	 ...S instrdr=$p($G(^OEORD(Ord,"I",Itm,2)),"^",7)
	 ...I instrdr'="" S instr=$p($G(^PHCIN(instrdr)),"^",2)	//用法
	 ...S doseqty=+$p($g(^OEORD(Ord,"I",Itm,2)),"^",1)	    //处方量(剂量)
	 ...s:$p(doseqty,".")="" doseqty=0_doseqty              //数量前补0
 	 ...S Unit=$p($g(^OEORD(Ord,"I",Itm,2)),"^",3)
 	 ...i Unit'="" S Unit=$p(^CT("UOM",Unit),"^",2) 
 	 ...e  s doseqty="" 
 	 ...S freqdr=$p($g(^OEORD(Ord,"I",Itm,2)),"^",4)	//频率
 	 ...I freqdr'="" S Freq=$p($g(^PHCFR(freqdr)),"^",1)
 	 ...S phdur=$p(^OEORD(Ord,"I",Itm,2),"^",6)
     ...I phdur'="" S phdur=$p(^PHCDU(phdur),"^",3) //疗程
	 ...i tmpOeori=Oeori d
	 ....s reasonNum=reasonNum+1
	 ....s Reason=reasonNum_"."_Reason
	 ....i $d(^TMP("DHCST","web.DHCSTOutMonitorRefDrg","getOutMonitorRefDrg",pid,Num)) d
	 .....s $p(^TMP("DHCST","web.DHCSTOutMonitorRefDrg","getOutMonitorRefDrg",pid,Num),"^",9)=$p(^TMP("DHCST","web.DHCSTOutMonitorRefDrg","getOutMonitorRefDrg",pid,Num),"^",9)_"</br>"_Reason
	 ...q:tmpOeori=Oeori
	 ...s tmpOeori=Oeori
     ...I $d(^TMP("DHCST","web.DHCSTOutMonitorRefDrg","getOutMonitorRefDrg",pid,MonitorID)) D
     ....S PatNo="",PatName="",AdmBed=""
     ...S ^TMP("DHCST","web.DHCSTOutMonitorRefDrg","getOutMonitorRefDrg",pid,MonitorID)=""
     ...S Num=Num+1
     ...s reasonNum=1
     ...s Reason=reasonNum_"."_Reason
	 ...S Index=Papmi_"||"_Oeori
	 ...S mdata=MonitorID_"^"_PatNo_"^"_PatName_"^"_InciDesc_"^"_QtyUom_"^"_doseqty_Unit_"^"_instr_"^"_phdur_"^"_Reason_"^"_UserName_"^"_RefTime_"^"_AdmDr_"^"_AdmBed_"^"_AppType
	 ...S ^TMP("DHCST","web.DHCSTOutMonitorRefDrg","getOutMonitorRefDrg",pid,Num)=mdata
	 
	 Q:Num="0" ##Class(web.DHCSTExtJsJsonCommon).getJsonEmptySign()  //返回空串
	
	 ///2、数据输出
	 W ##Class(web.DHCSTExtJsJsonCommon).getJsonStartSign(Num) //Json起始符
	 S Num=0
	 S Title="MonitorID^PatNo^PatName^PhcDesc^Qty^DoseQty^Instruce^Durtion^RefReason^RefPharmacy^RefTime^AdmDr^Bed^AppType"
	 S Index=StRow //""
	 F  S Index=$o(^TMP("DHCST","web.DHCSTOutMonitorRefDrg","getOutMonitorRefDrg",pid,Index)) Q:(Index="")||(Index>EndRow)  D
	 .S mdata=$g(^TMP("DHCST","web.DHCSTOutMonitorRefDrg","getOutMonitorRefDrg",pid,Index))
	 .Q:mdata=""
	 .S Num=Num+1
	 .W ##Class(web.DHCSTExtJsJsonCommon).getJsonData(mdata,Title,"^",Num)
	 
	 W ##Class(web.DHCSTExtJsJsonCommon).getJsonEndSign() //Json结束符
	 d ..killTmpGlobal(pid)
 	 Q ""
ErrorgetOutMonitorRefDrg
	i $d(pid) d ..killTmpGlobal(pid)
	s Error=$$Error^DHCSTERROR()
	q "{Error:'"_Error_"'}"
}

/// Descript:k临时global
ClassMethod killTmpGlobal(pid) As %String
{
	k ^TMP("DHCST","web.DHCSTOutMonitorRefDrg","getOutMonitorRefDrg",pid)
	k ^TMP("DHCST","web.DHCSTOutMonitorRefDrg","OutPhPatAdmList",pid)
	k ^TMP("DHCST","web.DHCSTOutMonitorRefDrg","OutPhAdmOEDetail",pid)
	k ^TMP("DHCST","web.DHCSTOutMonitorRefDrg","OutPhPatAdmListNum",pid)
	k ^TMP("DHCST","web.DHCSTOutMonitorRefDrg","getAdmRefDrgItm",pid)
	k ^TMP("DHCST","web.DHCSTOutMonitorRefDrg","getMonitorDrgItm",pid)
}

/// Descript:更新同意标志
ClassMethod AgreeRefDrg(MonitorID) As %String
{
	N (MonitorID,%session)
	S flag="Y"
	&SQL(Update DHC_PHAORDMONITOR set PHAOM_AgreeFlag=:flag Where PHAOM_ROWID=:MonitorID)	
	//处理消息
	i SQLCODE=0 d ##class(web.DHCSTInterfaceMessage).SendRefuseOrderMonitor(MonitorID,"Exec")
    Q SQLCODE
    //Q:SQLCODE SQLCODE
    //d ..CancelOEAuditResult(MonitorID) //取消医嘱审核状态
    //Q 0
}

/// Descript:获取拒绝的医嘱信息
/// w ##class(web.DHCSTOutMonitorRefDrg).getOutMonitorOrdInfo(100000229)
ClassMethod getOutMonitorOrdInfo(MonitorID) As %String
{
	N (MonitorID)
	Q:'$d(^DHCPHORDM(MonitorID)) ""
	S Ch="",ListData=""
 	F  S Ch=$o(^DHCPHORDM(MonitorID,"I",Ch)) Q:Ch=""  D
 	.S Oeori=$p(^DHCPHORDM(MonitorID,"I",Ch),"^",2) //医嘱ID
 	.Q:Oeori=""
 	.S Ord=+Oeori
	.S Itm=$p(Oeori,"||",2)
 	.S PrescNo=$p(^DHCPHORDM(MonitorID,"I",Ch),"^",3) //处方号
 	.S ArcItm=$p(^OEORD(Ord,"I",Itm,1),"^",2)
    .S Inci=$o(^INCI(0,"ARCIM_DR",$p(ArcItm,"||",1),""))
    .Q:Inci=""
    .S InciDesc=$p(^INCI(Inci,1),"^",2)
    .Q:ListData[InciDesc
    .i ListData=""  S ListData=InciDesc
    .Else  S ListData=ListData_"<br>"_InciDesc
    Q ListData
}

/// Descript:获取拒绝原因[要不要于药品拼串显示???]
ClassMethod getOutMonitorReason(MonitorID) As %String
{
	N (MonitorID)
	Q:'$d(^DHCPHORDM(MonitorID)) ""
	S ListData=""
	S PhNote=$p(^DHCPHORDM(MonitorID),"^",6)  //药师备注
	S DocNote=$p(^DHCPHORDM(MonitorID),"^",7)  //医生备注
	S Ch=""
 	F  S Ch=$o(^DHCPHORDM(MonitorID,"I",Ch)) Q:Ch=""  D
 	.S Oeori=$p(^DHCPHORDM(MonitorID,"I",Ch),"^",2) //医嘱ID
 	.S Ord=+Oeori
	.S Itm=$p(Oeori,"||",2)
 	.S AudReasonDr=$p(^DHCPHORDM(MonitorID,"I",Ch),"^",3) //审核原因
 	.S:AudReasonDr'="" Reason=$p(^DHCPCREASON(AudReasonDr),"^",2)
 	.Q:ListData[Reason
 	.i ListData=""  S ListData="拒绝理由:"_Reason
    .Else  S ListData=ListData_"<br>"_Reason
    S:PhNote'="" ListData=ListData_"^药师备注:"_PhNote
    S:DocNote'="" ListData=ListData_"^医生备注:"_DocNote
    Q ListData
}

/// Descript:保存申诉理由
ClassMethod saveAppealReason(MonitorID, AppealStr, User = "") As %String
{
	N (MonitorID,AppealStr,User,%session)
	Q:'$d(^DHCPHORDM(MonitorID)) ""
	S DocNote=$p(^DHCPHORDM(MonitorID),"^",7)  //医生备注
	If DocNote'="" S AppealStr=DocNote_"/"_AppealStr
	S result="A"
	&SQL(Update DHC_PHAORDMONITOR set PHAOM_DocNote=:AppealStr,PHAOM_Result=:result Where PHAOM_ROWID=:MonitorID)
    Q:SQLCODE SQLCODE
    d ..CancelOEAuditResult(MonitorID) //取消医嘱审核状态
    s MonitorSub=$o(^DHCPHORDM(MonitorID,"I",""))
    q:+MonitorSub=0 0
    s oeori=$p(^DHCPHORDM(MonitorID,"I",MonitorSub),"^",2)
    q:+oeori=0 0
    s prescno=$p(^DHCPHORDM(MonitorID,"I",MonitorSub),"^",4)
    s adm=$p($g(^OEORD(+oeori)),"^",1)
    //发送申诉消息至基础平台,yunhaibao20170216
    d ##class(web.DHCSTInterfaceMessage).SendRefuseOrderMonitor(MonitorID,"Exec") //读取
    d ##class(web.DHCSTInterfaceMessage).SendAppealOrderMonitor(MonitorID,"Send",User) //发送
    Q 0
}

/// Descript:计数器
ClassMethod NewPid() As %String
{
	Q $I(^DHCST("OutMonitorRefDrg"))
}

/// Descript:申诉或接受的时候取消医嘱审核状态
/// d ##class(web.DHCSTOutMonitorRefDrg).CancelOEAuditResult("9852")
ClassMethod CancelOEAuditResult(ordmr) As %String
{

	n (ordmr)
	s agreeflag=$p(^DHCPHORDM(ordmr),"^",8) //接受标志
	s sub=""
 	f  S sub=$O(^DHCPHORDM(ordmr,"I",sub)) Q:sub=""  d
 	.s oeori=$p(^DHCPHORDM(ordmr,"I",sub),"^",2)
	.s prescno=$p(^DHCPHORDM(ordmr,"I",sub),"^",4)
	.i prescno=""  d
	..;如果处方号为空，即为住院
	..s $p(^OEORD($p(oeori,"||",1),"I",$p(oeori,"||",2),7),"^",3)=""
	.e  d
	..;如果处方号不为空，门诊
	..s phordm=$o(^DHCPHORDM(0,"PrescNo",prescno,""),-1)
	..q:phordm'=ordmr  //不是最后一次日志,不能撤消
	..
	..s ord=""
	..f  s ord=$o(^OEORD(0,"PrescNo",prescno,ord))  q:ord=""  d
	...s chl=""
    ...f  s chl=$o(^OEORD(0,"PrescNo",prescno,ord,chl)) q:chl=""  d
    ....s orditm=ord_"||"_chl
    ....q:(agreeflag="Y")&(orditm=oeori)
	....s $p(^OEORD(ord,"I",chl,7),"^",3)=""
	.
	Q 0
}

// ===========================================

/// Creator:bianshuai
/// CreateDate:2014-06-30
/// Descript:按照病人pmi显示就诊医嘱信息
/// w ##class(web.DHCSTOutMonitorRefDrg).OutPhPatAdmList("0","200","28/09/2014^28/09/2014^982^^true^^21672")
ClassMethod OutPhPatAdmList(Stpage, Limit, input) As %String
{
	S Endpage=Stpage+Limit  //结束行
	S Stpage=Stpage //开始行
	S pid=..NewPid()
	S StDate=$p(input,"^",1)  //开始日期
	S StDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StDate)   
	S EndDate=$p(input,"^",2) //结束日期
	S EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
    S recLoc=$p(input,"^",3)
    S PatID=$p(input,"^",4)
    S AuditFlag=$p(input,"^",5)
    S UserID=$p(input,"^",7)  //用户ID
    
	S AdmType="O^E"
    S AdmLen=$L(AdmType,"^")
    S h=0
    F dd=StDate:1:EndDate  D
    .Q:PatID'=""
    .F i=1:1:AdmLen D
    ..S Type=$p(AdmType,"^",i)
    ..S AdmDr=""
    ..F  s AdmDr=$o(^PAADMi("NNType",Type,dd,AdmDr)) Q:AdmDr=""  D
    ...D ..getAdmData(pid,AdmDr,recLoc,dd,UserID,AuditFlag)

    If PatID'="" D
    .S papmi=$o(^PAPERi("PAPMI_PatNo",PatID,""))
    .Q:papmi=""
    .S AdmType=""
	.F  S AdmType=$o(^PAPERdr(papmi,"ADM",AdmType)) Q:AdmType=""  D 
	..Q:AdmType="I" ;过滤住院
	..S AdmDr="",ExitFlag=""
	..F  S AdmDr=$o(^PAPERdr(papmi,"ADM",AdmType,AdmDr),-1) Q:(AdmDr="")||(ExitFlag="1")  D 
	...S AdmDate=$p(^PAADM(AdmDr),"^",6) //就诊日期
	...I (AdmDate>EndDate)||(AdmDate<StDate) S ExitFlag="1" Q   //就诊日期小于查询起始日期,不在遍历
	...F dd=StDate:1:EndDate  D
	....D ..getAdmData(pid,AdmDr,recLoc,dd,UserID,AuditFlag)

	S Num=0
    S index=""
    F  S index=$o(^TMP("DHCST","web.DHCSTOutMonitorRefDrg","OutPhPatAdmList",pid,index)) q:index=""  d
    .S mdata=$g(^TMP("DHCST","web.DHCSTOutMonitorRefDrg","OutPhPatAdmList",pid,index))
    .S papmi=$p(mdata,"^",1) //病人ID
    .S AdmDr=$p(mdata,"^",2) //就诊ID
    .S PrescStr=$p(mdata,"^",3) //处方串
	.S PatName=$p(^PAPER(papmi,"ALL"),"^", 1) //患者姓名
	.S SexID=$p(^PAPER(papmi,"ALL"),"^",7 ) //姓别
	.S PatSex=$p(^CT("SEX",SexID),"^",2)
	.S PatNo=$p(^PAPER(papmi,"PAT",1),"^",1) //登记号
	.S PatAge=##class(web.DHCSTKUTIL).GetAge(papmi)  //年龄
    .S AdmLoc=$p(^PAADM(AdmDr),"^",4)
	.s AdmLoc=$p($p(^CTLOC(AdmLoc),"^",2),"-",2)
    .S PatBilltType=""
    .S PatBilltTypedr=+$p(^PAPER(papmi,"PER",1),"^",10)
	.S:PatBilltTypedr'="" PatBilltType=$p(^CT("SS",PatBilltTypedr),"^",2) //病人费别
    .s Diag=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(AdmDr,",")
    .s PatW=##class(web.DHCSTCNTSCOMMON).GetPatWeight(AdmDr) //体重
    .s PatH=##class(web.DHCSTCNTSCOMMON).GetPatHeight(AdmDr) //身高
    .S AuditFlag=..CheckIfExitPrescAudited(AdmDr) //是否存在已审
    .S Appeal=..getAppealReason(AdmDr)  //申诉理由
    .S Num=Num+1
    .S dataList=PatNo_"^"_PatName_"^"_PatSex_"^"_PatAge_"^"_PatH_"^"_PatW_"^"_PatBilltType_"^"_Diag
    .S dataList=dataList_"^"_AdmLoc_"^"_AdmDr_"^"_papmi_"^"_PrescStr_"^"_AuditFlag_"^"_Appeal
    .S ^TMP("DHCST","web.DHCSTOutMonitorRefDrg","OutPhPatAdmListNum",pid,Num)=dataList

	Q:Num="0" ##Class(web.DHCSTExtJsJsonCommon).getJsonEmptySign()  //返回空串
	
	///2、数据输出
    W ##Class(web.DHCSTExtJsJsonCommon).getJsonStartSign(Num) //Json起始符
	S Num=0
	S Title="patid^patname^patsex^patage^path^patw^billtype^diag^patloc^adm^papmi^prescno^auditflag^appeal"	 
	S Index=Stpage //""
	F  S Index=$o(^TMP("DHCST","web.DHCSTOutMonitorRefDrg","OutPhPatAdmListNum",pid,Index)) Q:(Index="")||(Index>Endpage)  D
	.S mdata=$g(^TMP("DHCST","web.DHCSTOutMonitorRefDrg","OutPhPatAdmListNum",pid,Index))
	.Q:mdata=""
	.S Num=Num+1
	.W ##Class(web.DHCSTExtJsJsonCommon).getJsonData(mdata,Title,"^",Num)
	 
	W ##Class(web.DHCSTExtJsJsonCommon).getJsonEndSign() //Json结束符
    d ..killTmpGlobal(pid)
 	Q ""
}

/// Descript:获取就诊明细
ClassMethod getAdmData(pid As %String, AdmDr As %String, recLoc As %String, date As %String, UserID As %String, AuditFlag As %String) As %String
{
	N (pid,AdmDr,recLoc,date,UserID,AuditFlag)
    Q:AdmDr="" ""
    //Q:..CheckIfExitNoHeadlePresc(AdmDr) //是否存在未处理的拒绝医嘱
    S ord=$o(^OEORD(0,"Adm",AdmDr,"")) 
	Q:ord=""	 ;对应就诊日期下该病人ord
    S itm=""
    F  S itm=$o(^OEORDi(0,"LocStDtArr",recLoc,0,date,ord,itm)) Q:(itm="")||(itm="0")  D
	.S oeori=ord_"||"_itm
	.S prescno=$p(^OEORD(ord,"I",itm,1),"^",14) //处方
	.Q:prescno=""
	.S AuditResult=..CheckPrescIfAudited(prescno) //处方审核结果
	.Q:(AuditFlag="true")&(AuditResult'=1)
	.Q:(AuditFlag'="true")&(AuditResult=1)
	.S ostatid=$p(^OEORD(ord,"I",itm,1),"^",13) //医嘱状态
	.S oeflag=$p(^OEC("OSTAT",ostatid),"^",1) 
	.Q:(oeflag'="V")&(oeflag'="E")
	.S pri=$p(^OEORD(ord,"I",itm,1),"^",8)  //医嘱优先级
    .Q:pri="" 
    .S priority=$p(^OECPR(pri),"^",1)            
    .Q:priority["OM"  //自备药
    .S papmi=$p(^PAADM(AdmDr),"^",1)
    .S ExitFlag=0
    .S AdmLoc=$p(^PAADM(AdmDr),"^",4)
	.Q:##Class(web.DHCSTPHCMCOMMON).CheckUseIDAndLocID(UserID,AdmLoc)=0  //判断就诊科室是否和人员对应 bianshuai 2014-06-30
	.S prefix=..getAdmIndexPrefix(AdmDr)  //排序用
	.S index=prefix_"||"_papmi_"||"_AdmDr
	.S mdate=$g(^TMP("DHCST","web.DHCSTOutMonitorRefDrg","OutPhPatAdmList",pid,index))
	.i mdate'="" d
	..S:'$f($p(mdate,"^",3),prescno) $p(mdate,"^",3)=$p(mdate,"^",3)_"/"_prescno //处方列表
	..S ^TMP("DHCST","web.DHCSTOutMonitorRefDrg","OutPhPatAdmList",pid,index)=mdate
	..S ExitFlag=1
	.Q:ExitFlag=1 //存在,退出
	.S dataList=papmi_"^"_AdmDr_"^"_prescno
	.S ^TMP("DHCST","web.DHCSTOutMonitorRefDrg","OutPhPatAdmList",pid,index)=dataList
}

/// Creator:bianshuai
/// CreateDate:2014-06-30
/// Descript:显示就诊医嘱信息
/// w ##class(web.DHCSTOutMonitorRefDrg).OutPhAdmOEDetail(""O14092807071","0","200","")
ClassMethod OutPhAdmOEDetail(PrescNoList As %String, Stpage As %String, Limit As %String, Input As %String) As %String
{
	N (PrescNoList,Stpage,Limit,Input)
	s pid=..NewPid()
	S Endpage=Stpage+Limit  //结束行
	S Stpage=Stpage //开始行
	S findflag=1
	S Num=0
	S Len=$L(PrescNoList,"/")
	F i=1:1:Len D
	.S PrescNo=$p(PrescNoList,"/",i)
	.S ord=""
	.F  S ord=$o(^OEORD(0,"PrescNo",PrescNo,ord))  Q:ord=""  D
	..S chl=""
	..F  S chl=$o(^OEORD(0,"PrescNo",PrescNo,ord,chl)) Q:chl=""  D
	...S orditm=ord_"||"_chl
	...S presc=$p(^OEORD(ord,"I",chl,1),"^",14)  //处方号
	...S arcimid=$p(^OEORD(ord,"I",chl,1),"^",2) //医嘱 ARC_ItmMast ARCIM_RowId
	...S itmmastid=$p(arcimid,"||",1)
	...S itmmastver=$p(arcimid,"||",2)
	...S inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),""))  //q:inci=""  //医嘱名称
	...S inciDesc=$p(^INCI(inci,1),"^",2) //药品名称
	...S statdr=$p(^OEORD(ord,"I",chl,1),"^",13)
	...S oeflag=$p(^OEC("OSTAT",statdr),"^",1) 
	...Q:(oeflag'="V")&(oeflag'="E")
	...S priordr=$p(^OEORD(ord,"I",chl,1),"^",8) 
    ...Q:priordr="" 
    ...S priority=$p(^OECPR(priordr),"^",1) 			;医嘱优先级代码              
    ...Q:priority["OM" //自备药
    ...//S qty=$p(^OEORD(ord,"I",chl,1),"^",12) //医嘱数量
	...S:findflag=1 puomdr=$p(^ARCIM(itmmastid,itmmastver,8),"^",14)
	...S:findflag=2 puomdr=+$p(^INCI(inci,3),"^",6)
	...S buomdr=+$p(^INCI(inci,1),"^",10)
	...//S fac=+##Class(web.DHCSTCOMMONSRV).UOMFac(puomdr,buomdr)
	...//S uomdr=buomdr
	...//If (qty#fac)=0 D
	...//.S qty=qty/fac   //数量
	...//.S uomdr=puomdr
	...S qty=+$p(^OEORD(ord,"I",chl,9),"^",4) //整包装数量 bianshuai 2014-06-23
	...S uomdr=puomdr
	...S uomdesc=$p($g(^CT("UOM",uomdr)),"^",2) //单位
	...S dosage=+$p(^OEORD(ord,"I",chl,2),"^",1) //剂量
    ...S doseuom=""
	...S dosuomID=$p(^OEORD(ord,"I",chl,2),"^",3)
	...If dosuomID'="" D
	....S doseuom=$p($g(^CT("UOM",dosuomID)),"^",2) //剂量单位
	...S freq=""
	...S freqdr=$p($g(^OEORD(ord,"I",chl,2)),"^",4) //OEORI_PHFreq_DR
    ...If freqdr'="" s freq=$p($g(^PHCFR(freqdr)),"^",3)  //频率
    ...S instru=$p(^PHCIN($p(^OEORD(ord,"I",chl,2),"^",7)),"^",2)       //用法
	...S duration=$p(^PHCDU($p(^OEORD(ord,"I",chl,2),"^",6)),"^",3)     //用药疗程
	...S priorty=$p(^OECPR($p(^OEORD(ord,"I",chl,1),"^",8)),"^",2)   	//医嘱优先级
	...S doctor=##class(web.DHCSTCOMMONSRV).getOrdDoctor(orditm)        //医生
	...S skintest=##class(web.DHCSTCOMMONSRV).GetSkinTestResult(orditm) //皮试
	...S form=##class(web.DHCSTCOMMONSRV).GetForm(inci)  //剂型
	...If $F(form,$c(13)) s form=$p(form,$c(13))
	...S spec=##class(web.DHCSTCOMMONSRV).getBarcode(inci) //规格
	...S manf=##class(web.DHCSTITMDESC).GetManfNameByInci(inci) //厂家
	...S manf=$tr(manf,$c(13,10),"")
	...If $f(manf,"-") s manf=$p(manf,"-",2)
	...S remark=##class(web.DHCSTCOMMONSRV).GetOrdItmRemark(orditm) //备注
	...S realdura="" //##class(web.DHCSTCNTSCOMMON).GetRealDuration(orditm) //实际疗程
	...S basflag=""
	...S infor=$o(^DHCITMINFO(0,"INCI",inci,""))
	...If infor'="" s basflag=$p(^DHCITMINFO(infor),"^",4)
    ...S orddate=$p(^OEORD(ord,"I",chl,3),"^",7)  // bianshuai 2014-06-23 修改
    ...S ordtime=$p(^OEORD(ord,"I",chl,3),"^",15)
    ...If orddate'="" s orddate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(orddate,"OP")
    ...If ordtime'="" s ordtime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(ordtime,"OP")
    ...S orddatetime=orddate_" "_ordtime  ;开单日期
    ...S Num=Num+1
    ...S Adm=$p(^OEORD(ord),"^",1)  //病人Adm
    ...S AdmLoc=$p(^PAADM(Adm),"^",4)
	...S AdmLocDesc=$p(^CTLOC(AdmLoc),"^",2)  //就诊科室
    ...S data=skintest_" "_inciDesc_"^"_qty_"^"_uomdesc_"^"_dosage_doseuom_"^"_freq_"^"_spec_"^"_instru_"^"_duration_"^"_form
    ...S data=data_"^"_priorty_"^"_doctor_"^"_orddatetime_"^"_remark_"^"_manf_"^"_basflag_"^"_realdura_"^"_PrescNo_"^"_AdmLocDesc_"^"_orditm
    ...S ^TMP("DHCST","web.DHCSTOutMonitorRefDrg","OutPhAdmOEDetail",pid,Num)=data
	
	Q:Num="0" ##Class(web.DHCSTExtJsJsonCommon).getJsonEmptySign()  //返回空串
	
	///2、数据输出
    W ##Class(web.DHCSTExtJsJsonCommon).getJsonStartSign(Num) //Json起始符
	S Num=0
	S Title="incidesc^qty^uomdesc^dosage^freq^spec^instruc^dura^form^pri^doctor^orddate^remark"
	S Title=Title_"^manf^basflag^realdura^prescno^admloc^orditm"	 
	S Index=Stpage //""
	F  S Index=$o(^TMP("DHCST","web.DHCSTOutMonitorRefDrg","OutPhAdmOEDetail",pid,Index)) Q:(Index="")||(Index>Endpage)  D
	.S mdata=$g(^TMP("DHCST","web.DHCSTOutMonitorRefDrg","OutPhAdmOEDetail",pid,Index))
	.Q:mdata=""
	.S Num=Num+1
	.W ##Class(web.DHCSTExtJsJsonCommon).getJsonData(mdata,Title,"^",Num)
	 
	W ##Class(web.DHCSTExtJsJsonCommon).getJsonEndSign() //Json结束符
    d ..killTmpGlobal(pid)
 	Q ""
}

/// Descript:判断当前处方是否已经审核通过
/// w ##class(web.DHCSTOutMonitorRefDrg).CheckPrescIfAudited("O14092801941")
ClassMethod CheckPrescIfAudited(prescno As %String) As %String
{
	N (prescno)
	Q:prescno="" ""
	S MonitorID=$o(^DHCPHORDM(0,"PrescNo",prescno,""),-1)
	Q:MonitorID="" ""
	Q:$p(^DHCPHORDM(MonitorID),"^",3)'=+$h "" //审核日期
	Q:($p(^DHCPHORDM(MonitorID),"^",2)="A")||($p(^DHCPHORDM(MonitorID),"^",2)="") ""  //审核结果
	Q 1
}

/// Descript:获取病人排序前缀
ClassMethod getAdmIndexPrefix(AdmDr As %String) As %String
{
	S Prefix="B"
	S MonitorID=""
	F  S MonitorID=$o(^DHCPHORDM(0,"Adm",AdmDr,MonitorID),-1) Q:(MonitorID="")||(Prefix'="B")  D
	.Q:$P(^DHCPHORDM(MonitorID),"^",3)'=+$h //审核日期
	.Q:$P(^DHCPHORDM(MonitorID),"^",2)'="A" //审核结果
	.S Prefix="A"
	Q Prefix
}

/// Descript:检查病人当天是否存在审核通过的处方
ClassMethod CheckIfExitPrescAudited(AdmDr As %String) As %String
{
	N (AdmDr)
    Q:AdmDr="" ""
    S CheckFlag=0
	S MonitorID=""
	F  S MonitorID=$o(^DHCPHORDM(0,"Adm",AdmDr,MonitorID)) Q:(MonitorID="")||(CheckFlag=1)  D
	.Q:$P(^DHCPHORDM(MonitorID),"^",3)'=+$h //审核日期
	.Q:$P(^DHCPHORDM(MonitorID),"^",2)'="Y" //审核结果
	.S CheckFlag=1
	Q CheckFlag
}

/// Descript:申诉理由
ClassMethod getAppealReason(AdmDr As %String) As %String
{
	S AppealReason=""
	S MonitorID=""
	F  S MonitorID=$o(^DHCPHORDM(0,"Adm",AdmDr,MonitorID),-1) Q:(MonitorID="")||(AppealReason'="")  D
	.Q:$P(^DHCPHORDM(MonitorID),"^",3)'=+$h //审核日期
	.Q:$P(^DHCPHORDM(MonitorID),"^",2)'="A" //审核结果
	.S AppealReason=$P(^DHCPHORDM(MonitorID),"^",7) //申诉理由
	Q AppealReason
}

/// Descript:检查该医生是否存在未处理的拒绝医嘱信息
/// w ##class(web.DHCSTOutMonitorRefDrg).CheckIfExitUntreatedRefOE("960","5814")
ClassMethod CheckIfExitUntreatedRefOE(doctorlocID As %String, doctorID As %String) As %String
{
	N (doctorlocID,doctorID)
	S exitflag=0
	S MonitorID=""
	F  S MonitorID=$o(^DHCPHORDM(0,"DateResult",+$h,"N",MonitorID)) Q:(MonitorID="")||(exitflag'=0)  D
	.Q:$p(^DHCPHORDM(MonitorID),"^",2)'="N" //审核结果
	.Q:$p(^DHCPHORDM(MonitorID),"^",8)="Y"  //已接受
	.S ch=$o(^DHCPHORDM(MonitorID,"I",""))
	.Q:ch=""
	.S AdmDr=$p(^DHCPHORDM(MonitorID,"I",ch),"^",5) //就诊ID
	.S AdmLoc=$p(^PAADM(AdmDr),"^",4)
	.S AdmType=$p(^PAADM(AdmDr),"^",2)
	.Q:AdmType="I"
	.//Q:doctorlocID'=AdmLoc  //非指定就诊科室
	.S AdmLoc=$p(^PAADM(AdmDr),"^",4)
	.S oeori=$p($g(^DHCPHORDM(MonitorID,"I",ch)),"^",2) //医嘱ID
	.Q:oeori=""
 	.S docdr=$p($g(^OEORD(+oeori,"I",$p(oeori,"||",2),1)),"^",11) //开医嘱医生 CT_CareProv
    .Q:docdr=""
    .Q:docdr'=doctorID  //非指定医生
	.S exitflag=1
	Q exitflag
}

/// Descript:引用药师申请意见字典
/// w ##class(web.DHCSTOutMonitorRefDrg).JsQueryDrgSugDic(0,20)
ClassMethod JsQueryDrgSugDic(StPage, Limit) As %String
{
	n (StPage, Limit)
	S endpage=StPage+Limit  //结束行
	S stpage=StPage+1 //开始行
	S num=0
	S pid=..NewPid()
	S id=""
	F  S id=$o(^DHCPHDSD(id)) Q:id=""  D
	.S code=$P(^DHCPHDSD(id),"^",1)
	.S desc=$p(^DHCPHDSD(id),"^",2)
 	.S num=num+1
	.S ^TMP("DHCST","web.DHCSTPIVAOUTDISPREQ","JsQueryDrgSugDic",pid,num)=id_"^"_code_"^"_desc
	.
	
	Q:num=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    S maxrow=num
    If endpage>maxrow S endpage=maxrow
    S count=0
    S i=""
    F  S i=$o(^TMP("DHCST","web.DHCSTPIVAOUTDISPREQ","JsQueryDrgSugDic",pid,i)) Q:i=""  d
    .S listdata=^TMP("DHCST","web.DHCSTPIVAOUTDISPREQ","JsQueryDrgSugDic",pid,i)
    .S id=$p(listdata,"^",1)
    .S code=$p(listdata,"^",2)
    .S desc=$p(listdata,"^",3)
    .
    .S count=count+1
    .Q:count<stpage
    .Q:count>endpage
    .
    .S id=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("ID",id)
	.S code=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("Code",code)
	.S desc=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("Desc",desc)
	.
	.S tmpstr=id_code_desc
	.
    .S startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .S firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .S lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.
    .i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
    
    k ^TMP("DHCST","web.DHCSTPIVAOUTDISPREQ","JsQueryDrgSugDic",pid)
    Q ""
}

/// Descript:取处方对应审核记录[门诊发药界面调用]
ClassMethod ChkPrescIfAudit(PrescNo As %String) As %String
{
	N (PrescNo)
	S monitorID=$o(^DHCPHORDM(0,"PrescNo",PrescNo,""))
	Q monitorID
}

/// Descript:取处方对应审核人工号[门诊发药界面调用]
ClassMethod getPrescAuditUser(PrescNo As %String) As %String
{
	N (PrescNo)
	S monitorID=$o(^DHCPHORDM(0,"PrescNo",PrescNo,""),-1)
	Q:monitorID="" ""
	S auditUser=""
	S auditUserID=$p(^DHCPHORDM(monitorID),"^",1)
	i auditUserID'="" S auditUser=$p($g(^SSU("SSUSR",auditUserID)),"^",1)
	Q auditUser
}

/// Descript:检查病人当天是否有未处理的拒绝医嘱[门诊]
/// w ##class(web.DHCSTOutMonitorRefDrg).CheckAdmIfExitUntrMon("17782126")
ClassMethod CheckAdmIfExitUntrMon(admDrStr As %String) As %String
{
	n (admDrStr)
	s quitflag="",doctor=""
	s len=$L(admDrStr,"^")
	f i=1:1:len q:(quitflag'="")  d
	.s AdmDr=$p(admDrStr,"^",i)
	.s MonitorID=""
	.f  s MonitorID=$o(^DHCPHORDM(0,"Adm",AdmDr,MonitorID),-1) q:(MonitorID="")||(quitflag'="")  d
	..q:$p(^DHCPHORDM(MonitorID),"^",3)'=+$h //审核日期
	..q:$p(^DHCPHORDM(MonitorID),"^",2)'="N" //审核结果
	..q:$p(^DHCPHORDM(MonitorID),"^",8)="Y"  //已接受
	..s quitflag=1
 	.
	q quitflag
}

/// Descript:检查病人当天是否有未处理的拒绝医嘱[住院]
/// w ##class(web.DHCSTOutMonitorRefDrg).CheckAdmIfExitUntrMonIn("273")
ClassMethod CheckAdmIfExitUntrMonIn(admDrStr As %String) As %String
{
	n (admDrStr)
	s quitflag="",doctor=""
	s len=$L(admDrStr,"^")
	f i=1:1:len q:(quitflag'="")  d
	.s AdmDr=$p(admDrStr,"^",i)
	.s MonitorID=""
	.f  s MonitorID=$o(^DHCPHORDM(0,"Adm",AdmDr,MonitorID),-1) q:(MonitorID="")||(quitflag'="")  d
	..//q:$p(^DHCPHORDM(MonitorID),"^",3)<(+$h-2) //审核日期
	..q:$p(^DHCPHORDM(MonitorID),"^",2)'="N" //审核结果
	..q:$p(^DHCPHORDM(MonitorID),"^",8)="Y"  //已接受
	..s CancelUser=$p(^DHCPHORDM(MonitorID),"^",12) //撤销的不显示
	..q:CancelUser'=""
	..s AppType=$p(^DHCPHORDM(MonitorID),"^",9)
	..q:(AppType'="IA")&&(AppType'="PIVAS")
	..s MonitorSub=+$o(^DHCPHORDM(MonitorID,"I",""))
	..s MonitorOeori=$p($g(^DHCPHORDM(MonitorID,"I",MonitorSub)),"^",2)
	..q:MonitorID'=$o(^DHCPHORDM(0,"OrdItem",MonitorOeori,""),-1)
	..q:(AppType'="PIVAS")&&('..CheckOeoriStatus(MonitorID))
	..s quitflag=1
 	.
	q quitflag
}

/// Descript:检查医嘱状态
ClassMethod CheckOeoriStatus(monitorID As %String) As %String
{
	n (monitorID)
	s ch=$o(^DHCPHORDM(monitorID,"I",""))
 	q:ch="" ""
 	s oeori=$p(^DHCPHORDM(monitorID,"I",ch),"^",2) //拒绝医嘱
 	q:oeori="" ""
	s ord=$p(oeori,"||",1)
 	s itm=$p(oeori,"||",2)
 	s result=$p(^OEORD(ord,"I",itm,7),"^",3) //审核结果
	q:(result="")||(result["SHTG") ""
	q 1
}

/// Descript:获取拒绝药品信息
/// w ##class(web.DHCSTOutMonitorRefDrg).getAdmRefDrgItm("16315732^16294190")
ClassMethod getAdmRefDrgItm(admDrStr As %String) As %String
{
	n (admDrStr)
	s pid=..NewPid()
	d ..killTmpGlobal(pid)
	s tempstr=""
	s len=$L(admDrStr,"^")
	f i=1:1:len  d
	.s AdmDr=$p(admDrStr,"^",i)
	.q:AdmDr=""
	.s MonitorID=""
	.f  s MonitorID=$o(^DHCPHORDM(0,"Adm",AdmDr,MonitorID),-1) q:MonitorID=""  d
	..q:$p(^DHCPHORDM(MonitorID),"^",3)'=+$h //审核日期
	..q:$p(^DHCPHORDM(MonitorID),"^",2)'="N" //审核结果
	..q:$p(^DHCPHORDM(MonitorID),"^",8)="Y"  //已接受
	..s CH=""
 	..f  s CH=$o(^DHCPHORDM(MonitorID,"I",CH)) q:CH=""  d
 	...s oeori=$p(^DHCPHORDM(MonitorID,"I",CH),"^",2) //拒绝医嘱
 	...q:oeori=""
 	...s ord=+oeori
 	...s itm=$p(oeori,"||",2)
 	...s arcimid=$p(^OEORD(ord,"I",itm,1),"^",2) //医嘱 ARC_ItmMast ARCIM_RowId
	...s itmmastid=$p(arcimid,"||",1)
	...s itmmastver=$p(arcimid,"||",2)
	...s inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),""))  //q:inci=""  //医嘱名称
	...s inciDesc=$p(^INCI(inci,1),"^",2) //药品名称
	...s docloc=$p(^OEORD(ord,"I",itm,1),"^",3)  //医生科室
	...s:docloc'="" docloc=$p($p(^CTLOC(docloc),"^",2),"-",2)
	...s doctor=##class(web.DHCSTCOMMONSRV).getOrdDoctor(oeori)
	...s index=docloc_"^"_doctor
	...i $d(^TMP("DHCST","web.DHCSTOutMonitorRefDrg","getAdmRefDrgItm",pid,index))  d
	....s ^TMP("DHCST","web.DHCSTOutMonitorRefDrg","getAdmRefDrgItm",pid,index)=$g(^TMP("DHCST","web.DHCSTOutMonitorRefDrg","getAdmRefDrgItm",pid,index))_"^"_inciDesc
	...e  s ^TMP("DHCST","web.DHCSTOutMonitorRefDrg","getAdmRefDrgItm",pid,index)=inciDesc

	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCSTOutMonitorRefDrg","getAdmRefDrgItm",pid,index)) q:index=""  d
	.s mdata=$g(^TMP("DHCST","web.DHCSTOutMonitorRefDrg","getAdmRefDrgItm",pid,index))
	.i tempstr="" s tempstr=index_"#"_mdata
	.e  s tempstr=tempstr_"!"_index_"#"_mdata
	d ..killTmpGlobal(pid)
	q tempstr
}

/// Descript:检查科室是否和病区关联
ClassMethod getLocWardIfLink(LocID As %String, WardID As %String) As %String
{
	n (LocID,WardID)
	s ret="0"
	q:WardID="" ret
	s tmpLocID=""
	f  s tmpLocID=$o(^CTLOC(LocID,"LINK",0,"Loc",tmpLocID)) q:tmpLocID=""  d
	.s locType=$p(^CTLOC(tmpLocID),"^",13)  //科室类型
	.q:locType'="W"
	.q:'$d(^PAWARD(0,"WARD_LocationDR",tmpLocID,WardID))
	.s ret=1
	.
	q ret
}

/// Descript:  获取门诊/住院医嘱审核拒绝列表串
/// w ##class(web.DHCSTOutMonitorRefDrg).getPatRefuseList("","17782126")
ClassMethod getPatRefuseList(DoctorID As %String, EpisodeID As %String = "") As %String
{
	 N (DoctorID, EpisodeID)
	 S ListData=""
	 I EpisodeID="" D
	 .S ListData=##Class(web.DHCSTOutMonitorRefDrg).OutPatRefList(DoctorID) //门诊
	 E  D
	 .S ListData=##Class(web.DHCSTOutMonitorRefDrg).InPatRefList(EpisodeID) //住院
	 Q ListData
}

/// Descript:门诊拒绝列表
ClassMethod OutPatRefList(DoctorID As %String) As %String
{
     N (DoctorID)
	 Q:DoctorID=""
	 S ListData=""
	 S MonitorID=""
 	 F  S MonitorID=$o(^DHCPHORDM(0,"DateResult",+$H,"N",MonitorID)) Q:MonitorID=""  D
     .q:$p(^DHCPHORDM(MonitorID),"^",8)="Y"     //已接受
 	 .S quitflag=0
 	 .S Ch=""
 	 .F  S Ch=$o(^DHCPHORDM(MonitorID,"I",Ch)) Q:(Ch="")||(quitflag=1)  D
 	 ..S oeori=$p(^DHCPHORDM(MonitorID,"I",Ch),"^",2) //医嘱ID
 	 ..Q:oeori=""
	 ..S docdr=$p($g(^OEORD(+oeori,"I",$p(oeori,"||",2),1)),"^",11) //开医嘱医生 CT_CareProv
     ..Q:docdr=""
     ..Q:docdr'=DoctorID  //非指定医生
     ..S quitflag=1
     .q:quitflag=0
 	 .i ListData="" S ListData=MonitorID
 	 .E  S ListData=ListData_"^"_MonitorID
 	 Q ListData
}

/// Descript:住院拒绝列表
ClassMethod InPatRefList(EpisodeID As %String) As %String
{
     N (EpisodeID)
	 Q:EpisodeID="" ""
	 S ListData=""
	 s MonitorID=""
	 f  s MonitorID=$o(^DHCPHORDM(0,"Adm",EpisodeID,MonitorID)) q:MonitorID=""  d
	 .//q:$p(^DHCPHORDM(MonitorID),"^",3)<(+$h-2) //审核日期
 	 .q:$p(^DHCPHORDM(MonitorID),"^",2)="Y"     //结果
 	 .q:$p(^DHCPHORDM(MonitorID),"^",2)="A"     //结果
     .q:$p(^DHCPHORDM(MonitorID),"^",8)="Y"     //已接受
     .q:'..CheckOeoriStatus(MonitorID)
 	 .
 	 .i ListData="" S ListData=MonitorID
 	 .E  S ListData=ListData_"^"_MonitorID
 	 Q ListData
}

/// Descript:病人基本信息
/// w ##class(web.DHCSTOutMonitorRefDrg).getRefPatAdmInfo()
ClassMethod getRefPatAdmInfo(MonitorID As %String = "") As %String
{
	N (MonitorID)
	S Ch=$o(^DHCPHORDM(MonitorID,"I",""))
	Q:Ch="" ""
	S Oeori=$p(^DHCPHORDM(MonitorID,"I",Ch),"^",2) //医嘱ID
	Q:Oeori="" ""
	S EpisodeID=$p(^DHCPHORDM(MonitorID,"I",Ch),"^",5) //Adm
	D ##CLASS(web.DHCSTCNTANTIBACTERIAL).GetPatEssInfo("",EpisodeID)
	Q ""
}

/// Descript:  获取门诊/住院医嘱审核拒绝列表串
/// w ##class(web.DHCSTOutMonitorRefDrg).getPatRefuseListOLD("123","")
ClassMethod getPatRefuseListOLD(DoctorID As %String, EpisodeID As %String = "") As %String
{
	 N (DoctorID, EpisodeID)
	 Q:(DoctorID="")&(EpisodeID="") ""
	 S ListData=""
	 S MonitorID=""
 	 F  S MonitorID=$o(^DHCPHORDM(0,"DateResult",+$H,"N",MonitorID)) Q:MonitorID=""  D
 	 .S UserID=$p(^DHCPHORDM(MonitorID),"^",1)  //操作人
 	 .S User=$P($G(^SSU("SSUSR",UserID)),"^",2)
 	 .S Result=$p(^DHCPHORDM(MonitorID),"^",2)  //结果
 	 .//Q:Result'="N"  //审核不通过
 	 .S AgreeFlag=$p(^DHCPHORDM(MonitorID),"^",8) //同意标志
 	 .Q:AgreeFlag="Y"  //已经同意的不显示
 	 .i EpisodeID'="" Q:'$d(^DHCPHORDM(0,"Adm",EpisodeID,MonitorID))
 	 .I MonitorID="162078" B  ///AAA
 	 .S quitflag=0
 	 .S Ch=""
 	 .F  S Ch=$o(^DHCPHORDM(MonitorID,"I",Ch)) Q:(Ch="")||(quitflag=1)  D
 	 ..S oeori=$p(^DHCPHORDM(MonitorID,"I",Ch),"^",2) //医嘱ID
 	 ..Q:oeori=""
	 ..S docdr=$p($g(^OEORD(+oeori,"I",$p(oeori,"||",2),1)),"^",11) //开医嘱医生 CT_CareProv
     ..Q:docdr=""
     ..I MonitorID="162078" B  ///BBB
     ..Q:(DoctorID'="")&(docdr'=DoctorID)  //非指定医生
     ..S quitflag=1
     .Q:(EpisodeID="")&(quitflag=0)
 	 .i ListData="" S ListData=MonitorID
 	 .E  S ListData=ListData_"^"_MonitorID
 	 Q ListData
}

/// Descript:获取拒绝药品信息
/// w ##class(web.DHCSTOutMonitorRefDrg).getMonitorDrgItm("16315732")
ClassMethod getMonitorDrgItm(rows As %String, page As %String, MonitorID As %String) As %String
{
	n (rows, page, MonitorID)
	s pid=..NewPid()
	s EndPage=page*rows  //结束行
	s StPage=((page-1)*rows)+1 //开始行
	d ..killTmpGlobal(pid)
	
	s Num=0
	s CH=""
 	f  s CH=$o(^DHCPHORDM(MonitorID,"I",CH)) q:CH=""  d
 	.s oeori=$p(^DHCPHORDM(MonitorID,"I",CH),"^",2) //拒绝医嘱
 	.q:oeori=""
 	.s ord=+oeori
 	.s chl=$p(oeori,"||",2)
 	.s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2) //医嘱 ARC_ItmMast ARCIM_RowId
	.s itmmastid=$p(arcimid,"||",1)
	.s itmmastver=$p(arcimid,"||",2)
	.s inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),""))  //医嘱名称
	.q:inci=""
	.s inciDesc=$p(^INCI(inci,1),"^",2) //药品名称
	.s presc=$p(^OEORD(ord,"I",chl,1),"^",14)   //处方号
	.s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2)  //医嘱 ARC_ItmMast ARCIM_RowId
	.s itmmastid=$p(arcimid,"||",1)
	.s itmmastver=$p(arcimid,"||",2)
	.
	.s arcitmdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2) //医嘱项名称
	.s puomdr=+$p(^ARCIM(itmmastid,itmmastver,8),"^",14)
	.
	.s qty=$p(^OEORD(ord,"I",chl,1),"^",12) //医嘱数量
	.s buomdr=+$p($g(^INCI(inci,1)),"^",10)
	.s fac=+##Class(web.DHCSTCOMMONSRV).UOMFac(puomdr,buomdr)
	.s uomdr=buomdr
	.i (qty#fac)=0 d
	..s qty=qty/fac   //数量
	..s uomdr=puomdr
	.s uomdesc=$p($g(^CT("UOM",uomdr)),"^",2) //单位
	.s dosage=$p($g(^OEORD(ord,"I",chl,2)),"^",1) //剂量
    .s doseuom=""
	.s dosuomID=$p($g(^OEORD(ord,"I",chl,2)),"^",3)
	.i dosuomID'="" s doseuom=$p($g(^CT("UOM",dosuomID)),"^",2) //剂量单位
	.s freq=""
	.s freqdr=$p($g(^OEORD(ord,"I",chl,2)),"^",4) ;OEORI_PHFreq_DR
    .i freqdr'="" s freq=$p($g(^PHCFR(freqdr)),"^",3)  //频率
    .s instru=""
    .s instrudr=$p($g(^OEORD(ord,"I",chl,2)),"^",7)
    .s:instrudr'="" instru=$p(^PHCIN(instrudr),"^",2)  //用法
    .s duration=""
    .s durationdr=+$p($g(^OEORD(ord,"I",chl,2)),"^",6)
	.s:durationdr'=0 duration=$p(^PHCDU(durationdr),"^",1)  //用药疗程
	.s doctor=##class(web.DHCSTCOMMONSRV).getOrdDoctor(oeori)  //医生
	.s form=##class(web.DHCSTCOMMONSRV).GetForm(inci)  //剂型
	.i $F(form,$c(13)) s form=$p(form,$c(13))
	.s spec=##class(web.DHCSTCOMMONSRV).getBarcode(inci) //规格
	.s:spec'="" spec="["_spec_"]"
	.s orddate=$p(^OEORD(ord,"I",chl,3),"^",7)  //医嘱日期
    .s ordtime=$p(^OEORD(ord,"I",chl,1),"^",10) //医嘱时间
    .i orddate'="" s orddate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(orddate,"OP")
    .i ordtime'="" s ordtime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(ordtime,"OP")
    .s ordtime=orddate  //开单日期
    .s reasondesc=""
    .s audReasondr=$p(^DHCPHORDM(MonitorID,"I",CH),"^",3) //审核原因
 	.i audReasondr'="" s reasondesc=$p(^DHCPCREASON(audReasondr),"^",2)
	.
	.s ListData=inciDesc_"^"_form_"^"_spec_"^"_instru_"^"_dosage_doseuom_"^"_uomdesc_"^"_qty_"^"_freq_"^"_presc_"^"_doctor_"^"_ordtime_"^"_reasondesc
	.
	.s Num=Num+1
	.S ^TMP("DHCST"," web.DHCSTOutMonitorRefDrg","getMonitorDrgItm",pid,Num)=ListData
	.
	
	Q:Num="0" ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串

	S maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	S quitflag=0
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(Num) //输出json前缀串
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCST"," web.DHCSTOutMonitorRefDrg","getMonitorDrgItm",pid,index)) Q:(index="")||(quitflag=1)  D
	.S mdata=^TMP("DHCST"," web.DHCSTOutMonitorRefDrg","getMonitorDrgItm",pid,index)
	.S Title="inciDesc^form^spec^instru^dosage^uomdesc^qty^freq^prescno^doctor^ordtime^reasondesc"
	.S Num=Num+1
	.Q:Num<StPage
	.S:Num=EndPage quitflag=1
	.I Num=StPage d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid)
	q ""
}

/// Descript:药师拒绝理由及建议
ClassMethod getRefPatAdvise(MonitorID As %String = "") As %String
{
	N (MonitorID)
	q:MonitorID="" ""
	q:'$d(^DHCPHORDM(MonitorID)) ""
	s tmp1="一级不适宜处方：按处方管理办法规定请您进一步确认或重新开具处方方能调配药品；"
	s tmp2="二级不适宜处方：按处方管理办法36条规定该项为严重的不适宜用药，请您修改或重新开具处方；"
	s ListData=""
	s PhNote=$p(^DHCPHORDM(MonitorID),"^",6)  //药师备注
	s:PhNote'="" PhNote=PhNote_"；"
	s Ch=""
 	f  s Ch=$o(^DHCPHORDM(MonitorID,"I",Ch)) q:(Ch="")||(ListData'="")  d
 	.s oeori=$p(^DHCPHORDM(MonitorID,"I",Ch),"^",2) //医嘱ID
 	.//s ord=+oeori
 	.//s chl=$p(oeori,"||",2)
 	.//s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2) //医嘱 ARC_ItmMast ARCIM_RowId
	.//s itmmastid=$p(arcimid,"||",1)
	.//s itmmastver=$p(arcimid,"||",2)
	.//s inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),""))  //医嘱名称
	.//q:inci=""
	.//s inciDesc=$p(^INCI(inci,1),"^",2) //药品名称
 	.S AudReasonDr=$p(^DHCPHORDM(MonitorID,"I",Ch),"^",3) //审核原因
 	.q:AudReasonDr=""
 	.S reasoncode=$p(^DHCPCREASON(AudReasonDr),"^",1)
 	.S reasondesc=$p(^DHCPCREASON(AudReasonDr),"^",2)
 	.i $p(reasoncode,".")["1" S ListData=PhNote_tmp1
 	.i $p(reasoncode,".")["2" S ListData=PhNote_tmp2
 	.
 	.//i ListData=""  S ListData=Reason
    .//Else  S ListData=ListData_";"_Reason
    Q ListData
}

/// Descript:拒绝病人列表
ClassMethod jsQueryRefPatList(rows As %String, page As %String, input As %String) As %String
{
	N (rows,page,input)
	S pid=..NewPid()
	S EndPage=page*rows  	   //结束行
	S StPage=((page-1)*rows)+1 //开始行
	S StartDate=$p(input,"^",1)   //开始日期
	S EndDate=$p(input,"^",2)     //结束日期
	S WardID=$p(input,"^",3)      //病区
	S LocID=$p(input,"^",4)    //科室
	S RegNo=$p(input,"^",5)       //登记号
	S HospID=$p(input,"^",6)       //HospID
	d ..killTmpGlobal(pid)

	S StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	S EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)

	///1、取数据
	S Num=0
	F dd=StartDate:1:EndDate D
	.S MonitorID=""
	.F  S MonitorID=$o(^DHCPHORDM(0,"DateLoc",dd,LocID,MonitorID)) Q:MonitorID=""  D
	..S UserID=$p(^DHCPHORDM(MonitorID),"^",1)  //操作人
	..S UserCode=$P($G(^SSU("SSUSR",UserID)),"^",1)
	..S Result=$p(^DHCPHORDM(MonitorID),"^",2)  //结果
	..Q:(Result="Y")||(Result="")  //审核通过的不显示
	..S CurState=""
	..i Result="A" S CurState="申诉"
	..S OpDate=$p(^DHCPHORDM(MonitorID),"^",3)  //日期
	..S OpDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(OpDate,"OP")
	..S OpTime=$p(^DHCPHORDM(MonitorID),"^",4)  //时间
	..S OpTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(OpTime,"OP")
	..S RefTime=OpDate_" "_OpTime
	..S recLocDr=$p(^DHCPHORDM(MonitorID),"^",5)  //接收科室
	..Q:recLocDr=""
	..Q:$p(^CTLOC(recLocDr),"^",22)'=HospID
	..S PhNote=$p(^DHCPHORDM(MonitorID),"^",6)  //药师备注
	..S DocNote=$p(^DHCPHORDM(MonitorID),"^",7) //医生备注
	..S AgreeFlag=$p(^DHCPHORDM(MonitorID),"^",8) //同意标志
	..//Q:AgreeFlag="Y"
	..i AgreeFlag="Y" S CurState="接受"
	..S AdmDr=""
	..S Ch=""
	..F  S Ch=$o(^DHCPHORDM(MonitorID,"I",Ch)) Q:(Ch="")||(AdmDr'="")  D
	...S oeori=$p(^DHCPHORDM(MonitorID,"I",Ch),"^",2) //医嘱ID
	...Q:oeori=""
	...S AdmDr=$p(^DHCPHORDM(MonitorID,"I",Ch),"^",5)
	...S AudReasonDr=$p(^DHCPHORDM(MonitorID,"I",Ch),"^",3) //审核原因
	..S AdmDate=$p(^PAADM(AdmDr),"^",6)  //就诊日期
	..S AdmTime=$p(^PAADM(AdmDr),"^",7)  //就诊时间
	..I AdmDate'="" S AdmDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(AdmDate,"OP")
	..I AdmTime'="" S AdmTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(AdmTime,"OP")
	..S AdmTime=AdmTime //_" "_admtime
	..S AdmWard=""
	..S AdmWardDr=$p(^PAADM(AdmDr),"^",70)
	..Q:(WardID'="")&(WardID'=AdmWardDr)
	..I AdmWardDr'="" s AdmWard=$p($p(^PAWARD(AdmWardDr),"^",2),"-",2) //病区
	..S bedid=$p(^PAADM(AdmDr),"^",73) //床号
    ..I bedid="" S AdmBed=""
    ..E  S AdmBed=$p(^PAWARD($p(bedid,"||",1),"BED",$p(bedid,"||",2)),"^",1)
	..S Papmi=$p(^PAADM(AdmDr),"^",1)
	..S PatName=$p(^PAPER(Papmi,"ALL"),"^",1) //姓名
	..S PatNo=$p(^PAPER(Papmi,"PAT",1),"^",1) //登记号
	..Q:(RegNo'="")&(RegNo'=PatNo)
	..S InMedicare=$p($g(^PAPER(Papmi,"PAT",3)),"^",4) ;病案号
	..S SexID=$p(^PAPER(Papmi,"ALL"),"^",7 )  //姓别
	..S PatSex=$p(^CT("SEX",SexID),"^",2)
	..S PatAge=##class(web.DHCSTKUTIL).GetAge(Papmi)  //年龄
	..S PatDiag=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(AdmDr,",") //诊断
	..S PatW=##class(web.DHCSTCNTSCOMMON).GetPatWeight(AdmDr) //体重
	..S PatH=##class(web.DHCSTCNTSCOMMON).GetPatHeight(AdmDr) //身高
	..S AdmLoc=$p(^PAADM(AdmDr),"^",4) //科室
	..S:AdmLoc'="" AdmLoc=$p($p(^CTLOC(AdmLoc),"^",2),"-",2)
	..S AdmDoc=""
	..S AdmDocID=$p(^PAADM(AdmDr),"^",9) //医生
	..S:AdmDocID'="" AdmDoc=$p(^CTPCP(AdmDocID,1),"^",2)
	..S RefAduAdv="" //..getRefPatAdvise(MonitorID)
 	..i AudReasonDr'="" d
 	...S reasoncode=$p(^DHCPCREASON(AudReasonDr),"^",1)
 	...S reasondesc=$p(^DHCPCREASON(AudReasonDr),"^",2)
 	...i $p(reasoncode,".")["1" S RefAduAdv="一级不适宜处方:"_reasondesc
 	...i $p(reasoncode,".")["2" S RefAduAdv="二级不适宜处方:"_reasondesc
	..S ListData=MonitorID_"^"_AdmWard_"^"_AdmBed_"^"_PatNo_"^"_PatName_"^"_PatSex_"^"_PatAge_"^"_PatH_"^"_PatW_"^"_AdmDate_"^"_AdmLoc_"^"_AdmDoc_"^"_AdmDr_"^"_PatDiag_"^"_UserCode_"^"_RefAduAdv_"^"_CurState
	..
	..S Num=Num+1
	..S index=AdmWard_"^"_AdmBed_"^"_AdmDate_"^"_PatNo_"^"_MonitorID
	..S ^TMP("DHCST","web.DHCSTPHCMBLOODCONMONITOR","QueryInHosPatList",pid,index)=ListData
	.
	
	Q:Num="0" ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串

	S maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	S quitflag=0
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(Num) //输出json前缀串
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTPHCMBLOODCONMONITOR","QueryInHosPatList",pid,index)) Q:(index="")||(quitflag=1)  D
	.S mdata=^TMP("DHCST","web.DHCSTPHCMBLOODCONMONITOR","QueryInHosPatList",pid,index)
	.S Title="MonitorID^Ward^Bed^PatNo^PatName^PatSex^PatAge^PatHeight^PatWeight^AdmDate^AdmLoc^AdmDoc^AdmDr^PatDiag^UserCode^RefAduAdv^CurState"
	.S Num=Num+1
	.Q:Num<StPage
	.S:Num=EndPage quitflag=1
	.I Num=StPage d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid)
	q ""
}

/// Descript:接受状态
ClassMethod getAppFlag(oeori As %String) As %String
{
	N (oeori) 
	S reploc=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),3),"^",6) 
	///南区 长嘱取首次医嘱ID 
    I $p(^CTLOC(reploc),"^",22)=2 D
    .S FillerNo=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),9),"^",12) //OEORI_FillerNo
    .S:FillerNo'="" oeori=$p(FillerNo,"!!",1)
	Q:'$d(^DHCPHORDM(0,"OrdItem",oeori)) ""
	S monitordr=$o(^DHCPHORDM(0,"OrdItem",oeori,""),-1)
	S monitorstat=$p(^DHCPHORDM(monitordr),"^",7)
	S result=$p(^DHCPHORDM(monitordr),"^",2)
	I result="A" S monitorstat="医生已申诉"
	Q:monitorstat'="" monitorstat
	S monitorstat=$p(^DHCPHORDM(monitordr),"^",8)
	I monitorstat="Y" S monitorstat="医生已接受"
	Q monitorstat
}

/// Descript:判断医嘱是否可以发药
ClassMethod CheckOeIfDisp(oeori As %String) As %String
{
	N (oeori)
	Q:oeori="" ""
	S ord=+oeori
	S chl=$p(oeori,"||",2)
	S FillerNo=$p(^OEORD(ord,"I",chl,9),"^",12) //滚医嘱来源信息 OEORI_FillerNo
    S:FillerNo'="" FristOeori=$p(FillerNo,"!!",1)
    I FillerNo=""  S FristOeori=oeori
	S result=$p(^OEORD(+FristOeori,"I",$p(FristOeori,"||",2),7),"^",3) //首日医嘱状态
	Q:result="" "N"
	Q:result["SHTG" "Y"
	///审核拒绝后,判断拒绝接受状态
	Q:'$d(^DHCPHORDM(0,"OrdItem",oeori)) "N"
	S monitordr=$o(^DHCPHORDM(0,"OrdItem",oeori,""),-1)
	S monitorstat=$p(^DHCPHORDM(monitordr),"^",8)
	Q:monitorstat="Y" "N"
	Q "N"
}

}
