/// Description: 医嘱发药状态查询
/// Creator：    pushuangcai
/// CreatDate：  2019-01-28
Class web.DHCINPHA.DispOrdItmStatus Extends %RegisteredObject [ ProcedureBlock ]
{

/// Description: 医嘱发药状态查询,供项目查询医嘱不能发药原因使用
/// Creator：    pushuangcai
/// CreatDate：  2019-01-30
/// Table：      OE_OrdItem、OE_OrdExec
/// Input：      医嘱明细ID（可选）、执行日期（可选）、执行记录ID（可选）、登记号、药品。
///                  医嘱ID+执行日期，登记号+药品+执行日期，执行记录ID这三个必须成组录入，至少选择一组条件
/// Output：     医嘱ID、执行ID、计划执行日期、药房、病区、领药审核时间、计费状态、执行状态、是否需皮试、
///                  皮试结果、打包发药状态、医嘱优先级、医嘱紧急标志、开医嘱医生科室、是否特殊科室、计费点、
///                  发药类别、医嘱项截止日期、当前在院状态、是否欠费（计算本医嘱即可）、药师审核时间、药师审核结果、
///                  发药单号、发药时间、医嘱数量、当前库存数量、当前价格规则、打包子表是否为空（批次价判断）、医嘱名称
/// Return：     
/// Others：  d ##class(%ResultSet).RunQuery("web.DHCINPHA.DispOrdItmStatus","CheckOrdDispStatus",^PHATMP("MYQ","web.DHCINPHA.DispOrdItmStatus","CheckOrdDispStatus"))
Query CheckOrdDispStatus(InputStr = "") As websys.Query(ROWSPEC = "OrdItem,OrdExec,ExStDate,PhaLoc,Ward,NurseAudit,BillStatus,ExecStatus,SkinTestFlag,SkinTest,DispStatus,Priority,Exigence,DeptLoc,SpeLocFlag,BillPoint,DispType,ArcMastEdDate,InHospFlag,ArrearsFlag,PhAuditDate,PhAudit,DispNo,DispDate,OrdQty,AvailQty,PriceRule,HasDspChl,ArcItmDesc,OrdPreXDateTime,NurseDealOrd,DispRefuse,WarnFlagStr,InciDesc")
{
}

ClassMethod CheckOrdDispStatusExecute(ByRef qHandle As %Binary, InputStr = "") As %Status
{
    #; s %zPhaLangCode="EN"
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s ind=1
    q:InputStr="" $$$OK
    //s $zt="ThorwException"
    s PatNo=$p(InputStr,"^",1)
    s InciID=$p(InputStr,"^",2)
    s OrdItm=$p(InputStr,"^",3)
    s OrdExeDate=$p(InputStr,"^",4)
    s OrdExeDr=$p(InputStr,"^",5)
    s PaOrdExeDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(OrdExeDate)
    s Ord=""
    s Itm=""
    if (OrdExeDr'=""){
        s Ord=+$p(OrdExeDr,"||",1)
        s Itm=+$p(OrdExeDr,"||",2)
        s OrdExe=+$p(OrdExeDr,"||",3)
        d GetOrdDispData
    }elseif ((OrdItm'="")&&(PaOrdExeDate'="")){
        s Ord=+$p(OrdItm,"||",1)
        s Itm=+$p(OrdItm,"||",2)
        s OrdExe=""
        f  s OrdExe=$o(^OEORDi(0,"OrdItem",Ord,Itm,PaOrdExeDate,OrdExe)) q:OrdExe=""  d
        .d GetOrdDispData
    }elseif ((PatNo'="")&&(InciID'="")&&(PaOrdExeDate'="")){
        s ArcItmMast=$p(^INCI(InciID,1),"^",3)
        s Papmi=+$o(^PAPERi("PAPMI_PatNo",PatNo,""))
        s Adm=+$o(^PAPERdr(Papmi,"ADM","I",""),-1)
        s Ord=+$o(^OEORD(0,"Adm",Adm,""))
        s Itm=$o(^OEORDi(0,"ARCIM",Ord,ArcItmMast,PaOrdExeDate,""))
        s Itm=""
        f  s Itm=$o(^OEORDi(0,"DateARCIM",PaOrdExeDate,ArcItmMast,Ord,Itm)) q:Itm=""  d
        .s OrdExe=""
        .f  s OrdExe=$o(^OEORDi(0,"DateARCIM",PaOrdExeDate,ArcItmMast,Ord,Itm,OrdExe)) q:OrdExe=""  d
        ..d GetOrdDispData
    }
    s qHandle=$lb(0,repid,0)
    Quit $$$OK
GetOrdDispData
    s WarnFlagStr=""
    s Adm=$p(^OEORD(Ord),"^",1)
    s Oeori=Ord_"||"_Itm
    s OrdExec=Ord_"||"_Itm_"||"_OrdExe
    q:+OrdExe=0
    q:'$d(^OEORD(Ord,"I",Itm,"X",OrdExe)) 
    s visitStatus = $p($g(^PAADM(Adm)), "^", 20)        // 在院状态
    s DspId=+$o(^DHCOEDISQTY(0,"OEORE",OrdExec,"")) 
    s TmpOrdExeDate=$p(^OEORD(Ord,"I",Itm,"X",OrdExe),"^",1)
    s TmpOrdExeTime=$p(^OEORD(Ord,"I",Itm,"X",OrdExe),"^",2)
    s OrdExeTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(TmpOrdExeTime)
    s OrdExeDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(TmpOrdExeDate)
    s OrdExeDate=OrdExeDate_" "_OrdExeTime
    s PhaLocDr=$p($g(^DHCOEDISQTY(DspId)),"^",24)
    q:PhaLocDr="" 
    s PhaLoc=##class(PHA.COM.Data.Base).LocDesc(PhaLocDr)
    s Hosp=$p(^CTLOC(PhaLocDr),"^",22)
    s WardDr=$p($g(^DHCOEDISQTY(DspId)),"^",22)
    s Ward=##class(PHA.COM.Data.Base).LocDesc(WardDr)
    s NurseAudit=..GetNurAudit(DspId)
    s NurseDealOrd=..GetNurDealOrd(Oeori)
    s DispRefuse=..GetDispRefuse(DspId)
    s PhAudit=..GetPhaAuditOrd(Oeori,PhaLocDr)
    s DispRefuse=..GetDispRefuse(DspId)
    s TmpBilled=$p(^OEORD(Ord,"I",Itm,"X",OrdExe),"^",6)
    s BillStatus=$s(TmpBilled="TB":"未计费",TmpBilled="B":"已计费",TmpBilled="R":"已退费",1:"")
    s SkinTestFlag=$p(^OEORD(Ord,"I",Itm,5),"^",2)
    s SkinTestStr=##class(web.DHCSTCOMMONORDER).OeoriSkinTest(Oeori)        ;备注(皮试结果)
    s SkinTestValue=$p(SkinTestStr,"^",1)
    s SkinTest=$p(SkinTestStr,"^",2)
    s ExecStatusDr=+$p(^OEORD(Ord,"I",Itm,"X",OrdExe),"^",16)       ;护士执行状态
    s ExecStatus=$p($g(^OEC("STAT",ExecStatusDr)),"^",2)  
    s:(ExecStatus="") ExecStatus="未执行"
    s TmpDispStatus=$p($g(^DHCOEDISQTY(DspId)),"^",7)
    s DispStatus=$s(TmpDispStatus="TC":"待发",TmpDispStatus="C":"已发",1:"")
    s PriorityDr=+$p(^OEORD(Ord,"I",Itm,1),"^",8)
    s PriorityCode=$p($g(^OECPR(PriorityDr)),"^",1) 
    s Priority=##class(PHA.COM.Data.Base).OrdPriDesc(PriorityDr)
    s Exigence=""                                                   ;医嘱紧急标志,todo
    s DeptLocDr=$p(^OEORD(Ord,"I",Itm,7),"^",2)
    s DeptLoc=##class(PHA.COM.Data.Base).LocDesc(DeptLocDr)
    s TmpSpeLocFlag=##class(web.DHCSTCOMMONSRV).DoctorLocRefuse(PhaLocDr,DeptLocDr)     ;特殊科室
    s SpeLocFlag=$s(TmpSpeLocFlag="1":"是",TmpSpeLocFlag="0":"否",1:"")
    s ArcItmMast=$p(^OEORD(Ord,"I",Itm,1),"^",2)
    s ArcitemCat=$p($g(^ARCIM(+$p(ArcItmMast,"||",1),+$p(ArcItmMast,"||",2),1)),"^",10)
    s TmpBillPoint=##class(web.DHCSTCOMMONSRV).GetFeePoint(ArcitemCat_"^"_PriorityCode_"^"_Oeori)
    s BillPoint=$s(TmpBillPoint="0":"开医嘱计费",TmpBillPoint="1":"发药计费",1:"")
    s DispCatCode=$p(^DHCOEDISQTY(DspId),"^",27)
    i DispCatCode'=0  d
    .//s DispCatDr=+$o(^DHCSTDRUGGRP(0,"Code",$zcvt(DispCatCode,"U"),""))
    .//s DispCat=$p($g(^DHCSTDRUGGRP(DispCatDr)),"^",2)
    .s DispCat=##class(web.DHCINPHA.Disp.Print).GetTypeDescByCode($zcvt(DispCatCode,"U"),Hosp)
    e  s DispCat="静配"
    s TmpArcMastEdDate=$p($g(^ARCIM(+$p(ArcItmMast,"||",1),+$p(ArcItmMast,"||",2),7)),"^",1)
    s ArcItmDesc=##class(PHA.COM.Data.Base).ArcimDesc(ArcItmMast)
    s ArcMastEdDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(TmpArcMastEdDate)
    i (TmpArcMastEdDate<+$h)&(TmpArcMastEdDate'="") s ArcMastEdDate=ArcMastEdDate_"(截止)"
    s TmpAdmStatus=##class(web.DHCSTCOMMONSRV).GetCurrentAdmStatus(Adm)
    s AdmStatus=$s(TmpAdmStatus="1":"在院",TmpAdmStatus="0":"出院",1:"")
    i ((TmpAdmStatus = 0)&&(TmpBillPoint = 1)&&(TmpDispStatus = "TC")) s $p(WarnFlagStr,"#",8)="Y"      //在院状态
    s ArrearsFlag=""
    s OrdQty=$p(^OEORD(Ord,"I",Itm,"X",OrdExe),"^",4)
    s dspQty=$p($g(^DHCOEDISQTY(DspId)),"^",5)
    s OrdUomDr=$p(^OEORD(Ord,"I",Itm,"X",OrdExe),"^",17)
    s OexIdQty=OrdExec_$c(2)_dspQty
    s TmpArrearsFlag=##class(web.DHCSTPCHCOLLS2).CheckArrearsNew("",Adm,OexIdQty,PhaLocDr)      
    i TmpArrearsFlag="N" s ArrearsFlag="Y"                          ;是否可以发药
    e  s ArrearsFlag="N"
    s Phaci=$p(^DHCOEDISQTY(DspId),"^",14)
    s DispNo="",DispDate=""
    i (Phaci'="") d
    .s DispNo=$p($g(^DHCPHAC(+Phaci)),"^",14)
    .s DispDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml($p($g(^DHCPHAC(+Phaci)),"^",7))
    .s DispTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml($p($g(^DHCPHAC(+Phaci)),"^",8),"IP")
    .s DispDate=DispDate_" "_DispTime
    s HospID=$p(^CTLOC(PhaLocDr),"^",22)
    s PriceRule=##Class(web.DHCSTCOMMPARA).GetRpRule(HospID)        ;价格规则
    s PriceRule=$case(PriceRule,1:"入库进价",2:"统一价",3:"批次价",:"")
    s DspChl=$o(^DHCOEDISQTY(DspId,"I",""),-1)
    // 预停时间
    s OrdPreXDate=$p($g(^OEORD(Ord,"I",Itm,9)),"^",9)
    s OrdPreXTime=$p($g(^OEORD(Ord,"I",Itm,9)),"^",10)  
    s OrdPreXDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(OrdPreXDate)
    s OrdPreXTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(OrdPreXTime,"IP")
    s OrdPreXDateTime=OrdPreXDate_" "_OrdPreXTime
    s lgStrParam="^"_PhaLocDr_"^^"_HospID
    // 取住院药房配置
    s PhaLocation=$o(^DHCPL(0,"Loc",PhaLocDr,""))
    i (PriorityCode'["OM")&&(PhaLocation'="") d
    .s DealOrdFlag=$p($g(^DHCPL(+PhaLocation)),"^",37)  // 医嘱处理
    .s OweFlag=$p($g(^DHCPL(+PhaLocation)),"^",22)      // 欠费发药控制
    .i (NurseDealOrd'="")&&(NurseDealOrd'["接受")&&(NurseDealOrd'["完成") s $p(WarnFlagStr,"#",2)="Y"
    .i (DealOrdFlag="Y")&&(NurseDealOrd="") s $p(WarnFlagStr,"#",2)="Y"
    .i ##class(web.DHCSTCOMMONSRV).IfAuditByPriority(DspId)'=1 s $p(WarnFlagStr,"#",1)="Y"
    .i PhAudit["拒绝" s $p(WarnFlagStr,"#",3)="Y"
    .//i ##class(web.DHCSTKUTIL).GetOrdAuditResult(DspId)'="Y" s $p(WarnFlagStr,"#",3)="Y"
    .i ##class(PHA.IP.COM.Method).GetPhaAuditFlagByDsp(DspId)'="Y" s $p(WarnFlagStr,"#",3)="Y"
    ./* 住院配液的配伍审核不走住院药房科室维护的是否需药师审核配置 */
    .i DispCatCode=0  d
    ..s result=$p(^OEORD(Ord,"I",Itm,7),"^",3)
    ..s result=$p(result,",",4) 
    ..i result'="SHTG" d
    ...s $p(WarnFlagStr,"#",3)="Y"
    .i (OweFlag="Y")&&(TmpArrearsFlag="N") s $p(WarnFlagStr,"#",4)="Y"
    .// 医生科室不判断
    .i TmpSpeLocFlag=1 s $p(WarnFlagStr,"#",1)="",$p(WarnFlagStr,"#",2)=""
    ./* 基数药、医生科室的医嘱不判断护士处理医嘱以及领药审核  预住院患者也不做此判断*/
    .i ($lg(##class(PHA.IP.COM.Method).GetOrderDispWay(Oeori),1)="BASEDISP")||(visitStatus = "P") d
    ..s $p(WarnFlagStr,"#",1)="",$p(WarnFlagStr,"#",2)=""
    .i ($lg(##class(PHA.IP.COM.Method).GetOrderDispWay(Oeori),1)="BASEDISP") d
    ..s BaseMedNeedPhaAudit = ##class(web.DHCST.Common.AppCommon).GetAppPropValue("DHCSTCOMMON","BaseMedNeedPhaAudit",lgStrParam)
    ..i (BaseMedNeedPhaAudit '= "Y") d
    ...s $p(WarnFlagStr,"#",3)=""
    s LocSkTFlag=##class(web.DHCST.Common.AppCommon).GetAppPropValue("DHCSTORDDISP", "SKINTESTFLAG", lgStrParam)
    i (+SkinTestValue<0)&&(LocSkTFlag="Y") s $p(WarnFlagStr,"#",7)="Y"      //增加判断科室皮试发药标志
    /* 当患者所在病区与接收科室一致时，不判断护士处理医嘱、药师审核、护士领药审核状态 */
    i (PhaLocDr = WardDr) d
    .s $p(WarnFlagStr,"#",1)=""
    .s $p(WarnFlagStr,"#",2)=""
    .s $p(WarnFlagStr,"#",3)=""
    // 库存判断
    s DspInciCombo=$p($g(^DHCOEDISQTY(DspId,"EXP")),"^",1) // 空就是医嘱改造前
    i DspInciCombo="" d
    .s DspQty=$p(^DHCOEDISQTY(DspId),"^",5)
    .s Inci=$o(^INCI(0,"ARCIM_DR",+$p(ArcItmMast,"||",1),""))
    .s InciQtyStr=Inci_"!"_DspQty
    e  d
    .s InciQtyStr=DspInciCombo // $c(1)
    s InciLen=$l(InciQtyStr,$c(1))
    f InciNum=1:1:InciLen d
    .s DspInciStr=$p(InciQtyStr,$c(1),InciNum)
    .q:DspInciStr="" 
    .s DspInci=$p(DspInciStr,"!",1)
    .s DspInciQty=$p(DspInciStr,"!",2)
    .s DspInciQty=$fn(DspInciQty, "N")
    .s HasDspChl="正常"
    .i (DspInciCombo'="")&&(+DspChl="0") d
    ..s $p(WarnFlagStr,"#",6)="Y",HasDspChl="空"
    .s AvailQty="",InciDesc=""
    .i DspInci'="" d
    ..s AvailQty=##CLASS(web.DHCSTSTKQTY).GetIncilValidQty(DspInci,PhaLocDr,1)
    ..i AvailQty<DspInciQty  s $p(WarnFlagStr,"#",5)="Y"
    ..e  s $p(WarnFlagStr,"#",5)=""
    ..s InciDesc=##class(PHA.COM.Data.Base).InciDesc(DspInci)
    .
    .s OutputData1=Oeori_"^"_OrdExec_"^"_OrdExeDate_"^"_PhaLoc_"^"_Ward
    .s OutputData2=NurseAudit_"^"_BillStatus_"^"_ExecStatus_"^"_SkinTestFlag_"^"_SkinTest
    .s OutputData3=DispStatus_"^"_Priority_"^"_Exigence_"^"_DeptLoc_"^"_SpeLocFlag
    .s OutputData4=BillPoint_"^"_DispCat_"^"_ArcMastEdDate_"^"_AdmStatus_"^"_ArrearsFlag
    .s outputData5=PhAudit_"^"_PhAudit_"^"_DispNo_"^"_DispDate_"^"_DspInciQty
    .s OutputData6=AvailQty_"^"_PriceRule_"^"_HasDspChl_"^"_ArcItmDesc_"^"_OrdPreXDateTime
    .s OutputData7=NurseDealOrd_"^"_DispRefuse_"^"_WarnFlagStr_"^"_InciDesc
    .s OutputData=OutputData1_"^"_OutputData2_"^"_OutputData3_"^"_OutputData4_"^"_outputData5_"^"_OutputData6_"^"_OutputData7
    .s Data=$lfs(OutputData,"^")
    .s ^CacheTemp(repid,ind)=Data    
    .s ind=ind+1
    q
ThorwException
    s qHandle=$lb(0,repid,0)
    Quit $$$OK
}

/// Description: 取护士医嘱处理
/// w ##class(web.DHCINPHA.DispOrdItmStatus).GetNurDealOrd("265||141")
ClassMethod GetNurDealOrd(Oeori)
{
    s OEORDINUR=$g(^OEORD(+Oeori,"I",+$p(Oeori,"||",2),"NUR"))
    q:OEORDINUR="" ""
    s userId=$p(OEORDINUR,"^",4)
    s userName=##class(PHA.COM.Data.Base).UserName(userId)
    s date=$p(OEORDINUR,"^",5)
    s date=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(date)
    s time=$p(OEORDINUR,"^",6)
    s time=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(time)
    s dealFlag=$p(OEORDINUR,"^",7)
    s dealFlag=$case(dealFlag,"A":"接受","F":"完成","R":"拒绝",:"")
    q:dealFlag="" ""
    q date_" "_time_"</br>"_userName_" "_dealFlag
}

/// Description: 取医嘱审核
/// w ##class(web.DHCINPHA.DispOrdItmStatus).GetPhaAuditOrd("265||141",246)
ClassMethod GetPhaAuditOrd(Oeori, LocId)
{

    if ($d(^oddCOM("PHA.IP.COM.Method", "m", "GetPhaAuditFlagByDsp"))){
        #; 新产品组的审方结果
        s mOeori=##class(web.DHCSTCOMMONORDER).GetMainOeori(Oeori)
        q:mOeori="" ""
        s mDsp=$o(^DHCOEDISQTY(0,"OEORI",mOeori,0))
        s auditRet = ##class(PHA.IP.COM.Method).GetPhaAuditFlagByDsp(mDsp)
        q:(auditRet="N") "未通过"
        q:(auditRet="Y") "通过"
        q ""
        
    }
    s mOeori=##class(web.DHCSTCOMMONORDER).GetMainOeori(Oeori)
    q:mOeori="" ""
    s phaOrdId=""
    s tmpPhaOrdId=""
    f  s tmpPhaOrdId=$o(^DHCPHORDM(0,"OrdItem",mOeori,tmpPhaOrdId),-1) q:(tmpPhaOrdId="")||(phaOrdId'="")  d
    .s cancelUser=$p(^DHCPHORDM(tmpPhaOrdId),"^",12)
    .q:(cancelUser'="")
    .q:LocId'=$p(^DHCPHORDM(tmpPhaOrdId),"^",5)
    .s phaOrdId=tmpPhaOrdId
    .
    q:phaOrdId="" ""
    s DHCPHORDM=$g(^DHCPHORDM(phaOrdId))
    s resultFlag=$p(DHCPHORDM,"^",2)
    s userId=$p(DHCPHORDM,"^",1)
    s date=$p(DHCPHORDM,"^",3)
    s time=$p(DHCPHORDM,"^",4)
    s userName=##class(PHA.COM.Data.Base).UserName(userId)
    s date=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(date)
    s time=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(time)
    s result=""
    i resultFlag="Y" s result="通过"
    e  i resultFlag="N" s result="拒绝"
    e  s result=""
    q date_" "_time_"</br>"_userName_" "_result
}

/// Description: 取领药审核
/// w ##class(web.DHCINPHA.DispOrdItmStatus).GetNurAudit(10477)
ClassMethod GetNurAudit(DspId)
{
    s DHCOEDISQTY=$g(^DHCOEDISQTY(DspId))
    s conFlag=$p(DHCOEDISQTY,"^",17)
    q:conFlag'="Y" ""
    s conFlag=$case(conFlag,"Y":"已审核",:"未审核")
    s userId=$p(DHCOEDISQTY,"^",12)
    s userName=##class(PHA.COM.Data.Base).UserName(userId)
    s date=$p(DHCOEDISQTY,"^",18)
    s date=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(date)
    s time=$p(DHCOEDISQTY,"^",19)
    s time=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(time)
    q date_" "_time_"</br>"_userName_" "_conFlag
}

/// Description: 取拒绝发药
/// w ##class(web.DHCINPHA.DispOrdItmStatus).GetDispRefuse(10477)
ClassMethod GetDispRefuse(DspId)
{
    q:DspId="" ""
    s warnInfo=""
    s DispCatCode=$p(^DHCOEDISQTY(DspId),"^",27)
    if (DispCatCode=0) {
        s grpNo=$p(^DHCOEDISQTY(DspId),"^",4)
        s mDsp=##class(web.DHCSTPIVAS.Common).GetMainDspId(DspId,grpNo)
        s pogId=$o(^PIVA(0,"OEGRP",mDsp,grpNo,""))
        q:pogId="" ""
        s pogOper=$p(^PIVA(pogId),"^",8)
        q:pogOper'="R" ""
        s operReasonId=$p(^PIVA(pogId),"^",9)
        s operReason=$p($g(^PIVAOR(+operReasonId)),"^",2)
        s warnInfo="配液拒绝"_":"_operReason
    }else{
        s stdfId=$o(^STDF("DODIS",DspId,""))
        q:stdfId="" ""
        s STDF=$g(^STDF(stdfId))
        q:STDF="" ""
        s userId=$p(STDF,"^",6)
        s userName=##class(PHA.COM.Data.Base).UserName(userId)
        s date=$p(STDF,"^",4)
        s date=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(date)
        s time=$p(STDF,"^",5)
        s time=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(time)
        s warnInfo=date_" "_time_"</br>"_userName
    }
    q warnInfo
}

}
