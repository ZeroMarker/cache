Class web.DHCPE.ResultDiagnosisNew Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod OutBaseInfo()
{
    w "<TABLE width=100% border=0.5><TR><TD>"
    w "ID号：<input id='RegNo' style='width:10%'></input>"
    w "姓名：<input id='Name' style='width:10%'></input>"
    w "性别：<input id='Sex' style='width:6%'></input>"
    w "年龄：<input id='Age' style='width:6%'></input>"
    w "检查记录："
    w "<select name='Record' id='Record' style='width:12%' HEIGHT=0>",!
    
    w "</select>",!
    w "证号：<input id='ZJNo' style='width:10%'></input>"
    w "团体名称：<input id='Group' style='width:10%'></input>"
    w "</TD></TR></TABLE>"
}

ClassMethod GetAuditInfo(PAADM, GSID)
{
        q:GSID="" ""
        s (AuditUser,AuditDate,MainUser,MainDate)=""
        s AuditUser=$P($G(^DHCPEGS(GSID,1)),"^",5)
        i AuditUser'="" d
        .s AuditUser=$P(^SSU("SSUSR",AuditUser),"^",2)
        .s AuditDate=$P(^DHCPEGS(GSID,1),"^",6)
        .s:AuditDate'="" AuditDate=##class(websys.Conversions).DateLogicalToHtml(AuditDate)
        .s MainInfo=$G(^DHCPEDataEx("DHCPEGeneralSummarize","MainDoctor",PAADM))
        .s MainUser=$P(MainInfo,"^",1)
        .s:MainUser'="" MainUser=$P(^SSU("SSUSR",MainUser),"^",2)
        .s MainDate=$P(MainInfo,"^",2)
        .s:MainDate'="" MainDate=##class(websys.Conversions).DateLogicalToHtml(MainDate)
        
        q AuditUser_"^"_AuditDate_"^"_MainUser_"^"_MainDate
}

/// Description: 显示总检界面信息
/// debug: w ##class(web.DHCPE.ResultDiagnosisNew).OutMainHISUI()
ClassMethod OutMainHISUI(PAADM, MainDoctorFlag, OnlyRead As %String = "N")
{
    
    if PAADM="" q ""
    d ##class(web.DHCPE.TransResult).TransMain(PAADM)
    if $d(%session) {
        set langId=%session.Get("LOGON.LANGID")
    }
    else
    { s langId=""}
    s CurUser=%session.Get("LOGON.USERID")
    s OrderID=$O(^OEORD(0,"Adm",PAADM,0))
    q:OrderID="" ""
    s LocID=$P($g(^PAADM(PAADM)),"^",4)
    
    s SendPisInterface=$G(^DHCPESetting("DHCPE","SendPisInterface",LocID))
    s OtherStation=$G(^DHCPESetting("DHCPE","StationId_Other",LocID))
    s MedicalStation=$G(^DHCPESetting("DHCPE","StationId_Medical",LocID))
    s OtherStation="^"_OtherStation_"^"_MedicalStation_"^"

    s AdmDate=$P($g(^PAADM(PAADM)),"^",6)
    s HFlag=0
    s:$P($g(^PAADM(PAADM)),"^",2)="H" HFlag=1
    
    s VIPDesc=""
    s VIPStr=##class(web.DHCPE.PreCommon).GetVIPLevel("PAADM",PAADM)
    i VIPStr'="" s VIPLevel=$p(VIPStr,"^",1),VIPDesc=$p(VIPStr,"^",2)
    i VIPDesc="职业病"  s Hidden=""
    e  s Hidden="style='display:none;'"
    
    i SendPisInterface="Y" d
    .s HiddenPis="style='display:none;'"
    e  d 
    .s HiddenPis=""
    
    s Job=$J
    k ^TempDHCPEResultDiagnosisNew(Job)
    k ^TempDHCPEResultDiagnosisNewRefuse(Job)
    k ^TempDHCPEResultDiagnosisNewAdvice(Job)
    k ^TempDHCPEResultDiagnosisRisStudyNo(Job)
    
    s OrderSub=0
    f  s OrderSub=$O(^OEORD(OrderID,"I",OrderSub)) q:OrderSub=""  d
    .s ArcimID=$P($g(^OEORD(OrderID,"I",OrderSub,1)),"^",2)
    .q:ArcimID=""
    .s Stat=$P($g(^OEORD(OrderID,"I",OrderSub,1)),"^",13)
    .q:(Stat'="1")&(Stat'="6")
    .s SpecNo=$P($g(^OEORD(OrderID,"I",OrderSub,3)),"^",20)
    .;s STID=$O(^DHCPEST(0,"STORD_ARCIM",ArcimID,0))
    .;q:STID=""
    .s ADMLocID=$P($g(^PAADM(PAADM)),"^",4)
    .s StatOrderID=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ArcimID,ADMLocID)
    .q:StatOrderID=""
    .s STID=+StatOrderID
    .q:OtherStation[("^"_STID_"^")
    .s StatSetID=$o(^CF.PE.StationSetI("IdxOfLocStation"," "_ADMLocID,STID,""))
    .q:StatSetID=""
    .
    .//顺序显示：站点顺序——站点分类顺序——项目顺序
    .//站点顺序
    .s STSort=""
    .s STSort=$lg($g(^CF.PE.StationSetD(StatSetID)),5)
    .;s STSort=$P(^DHCPEST(STID),"^",4)
    .i STSort="" s STSort="9999"
    .//项目顺序
    .s StatOrdSetID=$o(^CF.PE.StationOrderSetI("IdxOfLocOrder"," "_LocID,StatOrderID,""))
    .s OrderSort=""
    .i StatOrdSetID'="" s OrderSort=$lg($g(^CF.PE.StationOrderSetD(StatOrdSetID)),8)
    .;s STOSub=$O(^DHCPEST(0,"STORD_ARCIM",ArcimID,STI;D,0))
    .;s OrderSort=$P(^DHCPEST(STID,"O",STOSub),"^",7)
    .s:OrderSort="" OrderSort="999999999"
    .//站点分类顺序
    .s LocInfo="",SortID=""
    .s STOrdCatSortID=$o(^CF.PE.StationOrdSortI("ORD","IdxOfOrderDR",StatOrderID,0))
    .i STOrdCatSortID'="" d
    ..s STOrdSortID=$o(^CF.PE.StationOrdSortI("ORD","IdxOfOrderDR",StatOrderID,STOrdCatSortID,0))
    ..s SortID=STOrdCatSortID_"||"_STOrdSortID
    .i SortID'="" d
    ..s SOSLocPowerFlg = ##class(User.DHCPEStationOrderSort).GetLocShowDataFlag(SortID,LocID)  //站点分类项目显示有效授权
    ..q:SOSLocPowerFlg'="Y"
    ..s LocInfo=$g(^CF.PE.StationOrdSortD($p(SortID,"||",1),"ORD",$p(SortID,"||",2)))
    .;s LocInfo=$G(^DHCPEStationOrder("Loc",ArcimID))
    .i LocInfo="" d
    ..s LocCatID="999999999"
    ..s LocSort="999999999"
    .e  d
    ..s LocCatID=$lg($g(^CF.PE.StationOrdSortD($p(SortID,"||",1))),2)
    ..s LocSort=$lg($g(^CF.PE.StationOrdSortD($p(SortID,"||",1))),3)
    ..i LocSort="" s LocSort="999999999"
    .
    .s OrderItemID=OrderID_"||"_OrderSub
    .s QFlag=0
    .s RARRowId=$o(^DHCPACRegInfoi("OEORI",OrderItemID,0))
    .i RARRowId'="" d
    ..s RisStudyNo=$p($g(^DHCPACRegInfo(RARRowId)),"^",2)
    ..s:$D(^TempDHCPEResultDiagnosisRisStudyNo(Job,RisStudyNo)) QFlag=1
    ..s ^TempDHCPEResultDiagnosisRisStudyNo(Job,RisStudyNo)=""
    .q:QFlag=1
    .s CrmOrder=$O(^DHCPECRMO(0,"OEORI",OrderItemID,0))
    .q:(CrmOrder="")&&(HFlag=1)
    .i '$D(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OrderItemID)) d
    ..s ^TempDHCPEResultDiagnosisNewRefuse(Job,STSort,STID,LocSort,LocCatID)=1
    .s ^TempDHCPEResultDiagnosisNewOrder(Job,STSort,STID,LocSort,LocCatID)=OrderID_"||"_OrderSub
    .s Sort=$I(^TempDHCPEResultDiagnosisNew(Job,STSort,STID,LocSort,LocCatID))
    .s ^TempDHCPEResultDiagnosisNew(Job,STSort,STID,LocSort,LocCatID,OrderSort,Sort)=OrderID_"||"_OrderSub_"^"_ArcimID
    k ^TempDHCPEResultDiagnosisRisStudyNo(Job)
    
    s GSID=##class(web.DHCPE.ResultDiagnosis).GetSSId(PAADM)
    w "<TABLE id='NewDiagnosis' height=100% width=100% cellspacing='0' cellpadding='0' style='border=0; white-space:normal; word-break:break-all;'>"
    i OnlyRead'="Y"
    {
        i GSID="" d
        .w "<TR height=20 bgcolor='' style='white-space:normal; word-break:break-all;'><td><button class='hisui-linkbutton' plain=true iconCls='icon-checkin' onclick='SumResult_click()' id="_PAADM_"^Auto>"_##class(websys.Translation).Get("dhcpenewdiagnosis.diagnosis.hisui.csp","获取结果",langId)_"</button></td></tr>"
        
        e  d
        .;w "初审:"
        .s (AuditUser,AuditDate,MainUser,MainDate)=""
        .s AuditUser=$P($G(^DHCPEGS(GSID,1)),"^",5)
        .i AuditUser'="" d
        ..s AuditUser=$P($g(^SSU("SSUSR",AuditUser)),"^",2)
        ..s AuditDate=$P($g(^DHCPEGS(GSID,1)),"^",6)
        ..s:AuditDate'="" AuditDate=##class(websys.Conversions).DateLogicalToHtml(AuditDate)
        .;w "<input id='AuditUser' style='width:8%' value='"_AuditUser_"'>"
        .;w "<input style='width:8%' value='"_AuditDate_"'>"
        .;w "复审:"
        .s MainInfo=$G(^DHCPEDataEx("DHCPEGeneralSummarize","MainDoctor",PAADM))
        .s MainUser=$P(MainInfo,"^",1)
        .s:MainUser'="" MainUser=$P(^SSU("SSUSR",MainUser),"^",2)
        .s MainDate=$P(MainInfo,"^",2)
        .s:MainDate'="" MainDate=##class(websys.Conversions).DateLogicalToHtml(MainDate)
        .;w "<input id='AuditUser' style='width:8%' value='"_MainUser_"'>"
        .;w "<input style='width:8%' value='"_MainDate_"'>"
        .//复审
        .w "<tr style='height:40px;'>"
        .w "<td style='padding-left:10px'><button class='hisui-linkbutton' plain=true iconCls='icon-submit' onclick='HighRiskReport()' id="_PAADM_"^HighRisk>高危上报</button></td>"
        .w "<td><button class='hisui-linkbutton' plain=true iconCls='icon-emr-cri' onclick='Conclusion()' "_Hidden_"  id="_PAADM_"^Conc>检查结论</button></td>"
        .w "<td><button class='hisui-linkbutton' plain=true iconCls='icon-other-yellow' onclick='GSSDetail()' id="_PAADM_"^GSSDetail>总检日志</button></td>"
        .w "<td><button class='hisui-linkbutton' plain=true iconCls='icon-arrow-right-top' onclick='QMManager()' id="_PAADM_"^QM>质量上报</button></td>"
        .i (MainDoctorFlag="Y") d
        ..i AuditUser="" d
        ...w "<td><font color=red>"_##class(websys.Translation).Get("dhcpenewdiagnosis.diagnosis.hisui.csp","未初审",langId)_"</font></td>"
        ..e  d
        ...i MainUser'="" d
        ....;已复审
        ....w "<td><font color=red>"_##class(websys.Translation).Get("dhcpenewdiagnosis.diagnosis.hisui.csp","已复审",langId)_"</font></td>"
        ...e  d
        ....;未复审
        ....w "<td><button class='hisui-linkbutton' plain=true iconCls='icon-checkin' style='white-space:normal; word-break:break-all;' onclick='SelectAdvice()' id="_PAADM_"^Select>全选建议</button></td>"
        ....w "<td><button class='hisui-linkbutton' plain=true iconCls='icon-save' style='white-space:normal; word-break:break-all;' onclick='SaveAdviceApp()' id="_PAADM_"^SaveAP>保存建议</button></td>"
        ....w "<td><button class='hisui-linkbutton' plain=true iconCls='icon-reload' style='white-space:normal; word-break:break-all;' onclick='ShowUnite_click()' id="_PAADM_"^ShowUnite>合并建议</button></td>"
        .e  d
        
        ..//初审
        ..i MainUser'="" d
        ...//已复审
        ...w "<td><font color=red>"_##class(websys.Translation).Get("dhcpenewdiagnosis.diagnosis.hisui.csp","已复审",langId)_"</font></td>"
        
        ..e  d
        ...//未复审
        ...i AuditUser="" d
        ....w "<td><button style='white-space:normal; word-break:break-all;' onclick='Save_click()' id="_PAADM_"^SaveD class='hisui-linkbutton' plain=true iconCls='icon-save'>保存建议</button></td>"
        ....w "<td><button style='white-space:normal; word-break:break-all;' onclick='ShowUnite_click()' id="_PAADM_"^ShowUnite class='hisui-linkbutton' plain=true iconCls='icon-reload'>合并建议</button></td>"
        ...e  d
        ....w "<td><font color=red>"_##class(websys.Translation).Get("dhcpenewdiagnosis.diagnosis.hisui.csp","已初审",langId)_"</font></td>"
        
            
        .w "</tr>"
        w "<TR>"
    }
    else
    {/*
        w "<TR width=100px>"
        s ComNum=##class(web.DHCPE.FetchReport).GetComNumByDate(+$H,CurUser)
        w:HFlag="1" "<td align='left'><button class='hisui-linkbutton' plain=true onclick='SendAudit()' id="_PAADM_"^SendAudit iconCls='icon-print'>粘贴("_ComNum_")</button></td>"
        w "</TR>"   
     */
    }
    
    
    
    w "<TR width=100% height=100%><TD colspan=12 valign='top' ><div style='overflow-y:auto;width:100%;height:100%;'><TABLE height=99% width=99% cellspacing='0' cellpadding='0' style='border:1px solid #ccc; white-space:normal; word-break:break-all;'>"
    
    i OnlyRead="Y"
    {   w "<TR width=100px height=34px>"
        s ComNum=##class(web.DHCPE.FetchReport).GetComNumByDate(+$H,CurUser)
        w:HFlag="1" "<td align='left' colspan=3 style='border-radius:4px 4px 0px 0px;'><button class='hisui-linkbutton' plain=true onclick='SendAudit()' id="_PAADM_"^SendAudit iconCls='icon-print'>核对完成("_ComNum_")</button></td>"
       w "</TR>"
    }
    //w "<thead><TR height=20 align='center' bgcolor='' style='white-space:normal; word-break:break-all;'><th width=20% style='white-space:normal; word-break:break-all;'>科室</th><th width=50% style='white-space:normal; word-break:break-all;'>检查结果</th><th width=30%>建议</th><TR></thead>"
    w "<TR class='panel-header-gray' height=34px><td width=10% style='border-right:1px solid #ccc;border-top:1px solid #ccc;padding:0px 0px 0px 10px;color:#000000;'>"_##class(websys.Translation).Get("dhcpenewdiagnosis.diagnosis.hisui.csp","科室",langId)_"</td><td width=50% style='border-right:1px solid #ccc;border-top:1px solid #ccc;padding:0px 0px 0px 10px;color:#000000;'>"_##class(websys.Translation).Get("dhcpenewdiagnosis.diagnosis.hisui.csp","检查结果",langId)_"</td><td width=40% style='border-right:1px solid #ccc;border-top:1px solid #ccc;padding:0px 0px 0px 10px;color:#000000;'>"_##class(websys.Translation).Get("dhcpenewdiagnosis.diagnosis.hisui.csp","建议",langId)_"</td></tr>"



    s NoHPItem=..GetNoHPItem(PAADM)
    /*
    i NoHPItem'=""
    {
        w "<TR height=20 bgcolor='' style='white-space:normal; word-break:break-all;'><TD width=10% style='white-space:normal; word-break:break-all;'>非体检项目</TD><TD colspan=2 style='white-space:normal; word-break:break-all;'>"_NoHPItem_"</TD><TR>"
        
    }
    */
    s STSort=""
    f  s STSort=$O(^TempDHCPEResultDiagnosisNew(Job,STSort)) q:STSort=""  d
    .s STID=""
    .f  s STID=$O(^TempDHCPEResultDiagnosisNew(Job,STSort,STID)) q:STID=""  d
    ..s SSID=##class(web.DHCPE.ResultEdit).GetSSId(PAADM, STID)
    ..s AuditFlag=0
    ..i SSID'="" d
    ...s Status=$P($g(^DHCPESS(SSID,1)),"^",7)
    ...q:Status="NA"
    ...s AuditFlag=1
    ..s LocSort=""
    ..f  s LocSort=$O(^TempDHCPEResultDiagnosisNew(Job,STSort,STID,LocSort)) q:LocSort=""  d
    ...s LocID=""
    ...f  s LocID=$O(^TempDHCPEResultDiagnosisNew(Job,STSort,STID,LocSort,LocID)) q:LocID=""  d
    ....s OrderItemID=$G(^TempDHCPEResultDiagnosisNewOrder(Job,STSort,STID,LocSort,LocID))
    ....s RowsNum=$G(^TempDHCPEResultDiagnosisNew(Job,STSort,STID,LocSort,LocID))
    ....s STDesc=$P(^DHCPEST(STID),"^",2)
    ....s STDesc=##class(User.DHCPEStation).GetTranByDesc("STDesc",STDesc,langId) 
    ....;q:(STDesc["检验科")&&(OnlyRead="Y")&&(AdmDate=+$H)
    ....s LocFlag=0
    ....i $L(LocID,"||")>1 d
    .....q:'$D(^DHCPEST(+LocID,"STLOC",$P(LocID,"||",2)))
    .....s LocFlag=1
    .....s STDesc=$P($G(^DHCPEST(+LocID,"STLOC",$P(LocID,"||",2))),"^",1)
    ....i $G(^TempDHCPEResultDiagnosisNewRefuse(Job,STSort,STID,LocSort,LocID))="" d
    .....s STDesc=STDesc_"(放弃)"
    
    ....s:AuditFlag="0" STDesc="<font color=red>"_STDesc_"</font>"
    ....w "<TR bgcolor='' style='border: 1px solid #ccc; white-space:normal; word-break:break-all;'><TD style='border:1px solid #ccc;border-radius:0px 0px 0px 4px;padding-left:10px;cursor:hand;white-space:normal; word-break:break-all;'' id='"_OrderItemID_"^"_STDesc_"' onclick='ShowEDInfo(this)'>"_STDesc_"</TD>"
    ....s OrderNum=1
    ....s OrderSort=""
    ....f  s OrderSort=$O(^TempDHCPEResultDiagnosisNew(Job,STSort,STID,LocSort,LocID,OrderSort)) q:OrderSort=""  d
    .....s Sort=""
    .....f  s Sort=$O(^TempDHCPEResultDiagnosisNew(Job,STSort,STID,LocSort,LocID,OrderSort,Sort)) q:Sort=""  d
    ......q:OrderNum>1
    ......s ItemInfo=$G(^TempDHCPEResultDiagnosisNew(Job,STSort,STID,LocSort,LocID,OrderSort,Sort))
    ......s OrderInfo=$P(ItemInfo,"^",1)
    ......s Item=$P(ItemInfo,"^",2)
    ......;s ARCDesc=##class(web.DHCPE.DHCPECommon).GetArcDesc(Item)
    ......s ARCDesc=..GetOEItemDesc(OrderInfo)
    ......s:'$D(^DHCPERLT(0,"OEORI",OrderInfo)) ARCDesc="<font color=red>"_ARCDesc_"</font>"
    ......;w "<TD style='cursor:hand;white-space:normal; word-break:break-all;' onclick='ShowOneResult(this)' id='"_OrderInfo_"'>"_ARCDesc_"</TD>"
    ......i $L(LocID,"||")>1 d
    .......s ResultLocID=LocID
    ......e  d
    .......s ResultLocID=STID
    ......w "<TD align='left' valign='top' ondblclick='ShowLocResult(this)' id='"_OrderItemID_"' style='border: 1px solid #ccc;padding-left:10px;white-space:normal; word-break:break-all;'>"_##class(web.DHCPE.MainDiagnosisNew).GetResultByLocID(PAADM, ResultLocID,0,"N")_"</TD>"
    ......s CurStation=STID
    ......s:LocFlag=1 CurStation=LocID
    ......w:OrderNum=1 "<TD align='left' valign='top' id="_CurStation_" valign='top' style='border: 1px solid #ccc; white-space:normal; word-break:break-all;border-radius:0px 0px 4px 0px;'><label id="_CurStation_" style='white-space:normal; word-break:break-all;'>"_..GetAdviceInfoHISUI(GSID,CurStation,MainDoctorFlag,Job,OnlyRead)_"</label></TD>"  
    ......;w:OrderNum<RowsNum "</TR><TR bgcolor=''>"
    ......s OrderNum=OrderNum+1
    ....w "</TR>"
    w "</TABLE></div></TD></TR>"
    k ^TempDHCPEResultDiagnosisNewOrder(Job)
    k ^TempDHCPEResultDiagnosisNew(Job)
    k ^TempDHCPEResultDiagnosisNewAdvice(Job)
    w "</TABLE>"
}

ClassMethod OutMain(PAADM, MainDoctorFlag, OnlyRead As %String = "N")
{
    if PAADM="" q ""
     s LocID=$P($G(^PAADM(PAADM)),"^",4)
    //S SendPisInterface=$G(^DHCPESetting("DHCPE","SendPisInterface"))
    S SendPisInterface=$G(^DHCPESetting("DHCPE","SendPisInterface",LocID))

    I SendPisInterface="Y" d
    .s HiddenPis="style='display:none;'"
    e  d 
    .s HiddenPis=""

    s AdmDate=$P(^PAADM(PAADM),"^",6)
    s HFlag=0
    s:$P(^PAADM(PAADM),"^",2)="H" HFlag=1
    s CurUser=%session.Get("LOGON.USERID")
    s OrderID=$O(^OEORD(0,"Adm",PAADM,0))
    //s OtherStation=$G(^DHCPESetting("DHCPE","StationId_Other"))
   //s MedicalStation=$g(^DHCPESetting("DHCPE","StationId_Medical"))
    s OtherStation=$G(^DHCPESetting("DHCPE","StationId_Other",LocID))
    s MedicalStation=$g(^DHCPESetting("DHCPE","StationId_Medical",LocID))

    q:OrderID="" ""
    s Job=$J
    k ^TempDHCPEResultDiagnosisNew(Job)
    k ^TempDHCPEResultDiagnosisNewRefuse(Job)
    k ^TempDHCPEResultDiagnosisNewAdvice(Job)
    k ^TempDHCPEResultDiagnosisRisStudyNo(Job)
    s OrderSub=0
    f  s OrderSub=$O(^OEORD(OrderID,"I",OrderSub)) q:OrderSub=""  d
    .s Stat=$P($g(^OEORD(OrderID,"I",OrderSub,1)),"^",13)
    .;q:Stat="4" //删除
    .q:(Stat'="1")&(Stat'="6")
    .s SpecNo=$P($G(^OEORD(OrderID,"I",OrderSub,3)),"^",20)
    .s ArcimID=$P($g(^OEORD(OrderID,"I",OrderSub,1)),"^",2)
    .q:ArcimID=""
    .s STID=$O(^DHCPEST(0,"STORD_ARCIM",ArcimID,0))
    .q:STID=""
    .q:STID=OtherStation
    .q:STID=MedicalStation
    .s STSort=$P(^DHCPEST(STID),"^",4)
    .i STSort="" s STSort="9999"
    .s STOSub=$O(^DHCPEST(0,"STORD_ARCIM",ArcimID,STID,0))
    .s OrderSort=$P(^DHCPEST(STID,"O",STOSub),"^",7)
    .s:OrderSort="" OrderSort="999999999"
    .s LocInfo=$G(^DHCPEStationOrder("Loc",ArcimID))
    .i LocInfo="" d
    ..s LocID="999999999"
    ..s LocSort="999999999"
    .e  d
    ..s LocID=$P(LocInfo,"^",1)
    ..s LocSort=$P($G(^DHCPEST(+LocID,"STLOC",$P(LocID,"||",2))),"^",2)
    ..i LocSort="" s LocSort="999999999"
    .s OrderItemID=OrderID_"||"_OrderSub
    .s QFlag=0
    .s RARRowId=$o(^DHCPACRegInfoi("OEORI",OrderItemID,0))
    .i RARRowId'="" d
    ..s RisStudyNo=$p(^DHCPACRegInfo(RARRowId),"^",2)
    ..s:$D(^TempDHCPEResultDiagnosisRisStudyNo(Job,RisStudyNo)) QFlag=1
    ..s ^TempDHCPEResultDiagnosisRisStudyNo(Job,RisStudyNo)=""
    .q:QFlag=1
    .s CrmOrder=$O(^DHCPECRMO(0,"OEORI",OrderItemID,0))
    .q:(CrmOrder="")&&(HFlag=1)
    .i '$D(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OrderItemID)) d
    ..s ^TempDHCPEResultDiagnosisNewRefuse(Job,STSort,STID,LocSort,LocID)=1
    .s ^TempDHCPEResultDiagnosisNewOrder(Job,STSort,STID,LocSort,LocID)=OrderID_"||"_OrderSub
    .s Sort=$I(^TempDHCPEResultDiagnosisNew(Job,STSort,STID,LocSort,LocID))
    .s ^TempDHCPEResultDiagnosisNew(Job,STSort,STID,LocSort,LocID,OrderSort,Sort)=OrderID_"||"_OrderSub_"^"_ArcimID
    k ^TempDHCPEResultDiagnosisRisStudyNo(Job)
    
    s GSID=##class(web.DHCPE.ResultDiagnosis).GetSSId(PAADM)
    w "<TABLE id='NewDiagnosis' height=100% width=100% border=0 cellspacing='0' cellpadding='0' style='white-space:normal; word-break:break-all;'>"
    i OnlyRead'="Y"
    {
        w "<TR height=20 bgcolor='' style='white-space:normal; word-break:break-all;'>"
        i GSID="" d
        .w "<td><button onclick='SumResult_click()' id="_PAADM_"^Auto  class='i-btn'>获取结果</button></td>"
        e  d
        .w "初审:"
        .s (AuditUser,AuditDate,MainUser,MainDate)=""
        .s AuditUser=$P($G(^DHCPEGS(GSID,1)),"^",5)
        .i AuditUser'="" d
        ..s AuditUser=$P(^SSU("SSUSR",AuditUser),"^",2)
        ..s AuditDate=$P(^DHCPEGS(GSID,1),"^",6)
        ..s:AuditDate'="" AuditDate=##class(websys.Conversions).DateLogicalToHtml(AuditDate)
        .w "<input id='AuditUser' style='width:8%' value='"_AuditUser_"'>"
        .w "<input style='width:8%' value='"_AuditDate_"'>"
        .w "复审:"
        .s MainInfo=$G(^DHCPEDataEx("DHCPEGeneralSummarize","MainDoctor",PAADM))
        .s MainUser=$P(MainInfo,"^",1)
        .s:MainUser'="" MainUser=$P(^SSU("SSUSR",MainUser),"^",2)
        .s MainDate=$P(MainInfo,"^",2)
        .s:MainDate'="" MainDate=##class(websys.Conversions).DateLogicalToHtml(MainDate)
        .w "<input id='AuditUser' style='width:8%' value='"_MainUser_"'>"
        .w "<input style='width:8%' value='"_MainDate_"'>"
        .//复审
        .w "<tr>"
        .i (MainDoctorFlag="Y") d
        ..i AuditUser="" d
        ...w "<font color=red>未初审</font>"
        ..e  d
        ...i MainUser'="" d
        ....;已复审
        ....w "<td><button class='i-btn' style='white-space:normal; word-break:break-all;' onclick='StationSCancelSub()' id="_PAADM_"^Cancel><B>取消复审</B></button></td>"
        ...e  d
        ....;未复审
        ....w "<td><button class='i-btn' style='white-space:normal; word-break:break-all;' onclick='Audit_click()' id="_PAADM_"^Save><B>复审提交</B></button></td>"
        ....w "<td><button class='i-btn' style='white-space:normal; word-break:break-all;' onclick='SelectAdvice()' id="_PAADM_"^Select>全选建议</button></td>"
        ....w "<td><button class='i-btn' style='white-space:normal; word-break:break-all;' onclick='SaveAdviceApp()' id="_PAADM_"^SaveAP>保存建议</button></td>"
        ....w "<td><button class='i-btn' style='white-space:normal; word-break:break-all;' onclick='ShowUnite_click()' id="_PAADM_"^ShowUnite>建议合并</button></td>"
        .e  d
        
        ..//初审
        ..i MainUser'="" d
        ...//已复审
        ...w "<font color=red>已复审</font>"
        ...w "<td><button class='i-btn' style='white-space:normal; word-break:break-all;' onclick='ShowResult_click()' id="_PAADM_"^Look>查看小结</button></td>"
        
        ..e  d
        ...//未复审
        ...i AuditUser="" d
        
        ....w "<td><button style='white-space:normal; word-break:break-all;' onclick='Audit_click()' id="_PAADM_"^Save class='i-btn'><B>初审提交</B></button></td>"
        ....w "<td><button style='white-space:normal; word-break:break-all;' onclick='SumResult_click()' id="_PAADM_"^Auto class='i-btn'>重新总检</button></td>"
        ....w "<td><button style='white-space:normal; word-break:break-all;' onclick='Save_click()' id="_PAADM_"^SaveD class='i-btn'>建议保存</button></td>"
        ....w "<td><button style='white-space:normal; word-break:break-all;' onclick='ShowUnite_click()' id="_PAADM_"^ShowUnite class='i-btn'>建议合并</button></td>"
        ...e  d
        ....w "<font color=red>已初审</font>"
        ....w "<td><button style='white-space:normal; word-break:break-all;' onclick='StationSCancelSub()' id="_PAADM_"^Cancel class='i-btn'><B>取消初审</B></button></td>"
        ....w "<td><button style='white-space:normal; word-break:break-all;' onclick='ShowResult_click()' id="_PAADM_"^Look class='i-btn'>查看小结</button></td>"
        ....w "<td><button style='white-space:normal; word-break:break-all;' onclick='ShowUnite_click()' id="_PAADM_"^ShowUnite class='i-btn'>建议合并</button></td>"
        
        .w "<td><button style='white-space:normal; word-break:break-all;' onclick='PreviewReport()' id="_PAADM_"^Report class='i-btn'>报告预览</button></td>"
        .w:HFlag="1" "<td><button style='white-space:normal; word-break:break-all;' onclick='GetContrastWithLast()' id="_PAADM_"^History class='i-btn'>历史结果</button></td>"
        .w "<td><button class='i-btn' onclick='HighRiskReport()' id="_PAADM_"^HighRisk >高危</button></td>"
        .w "<td><button class='i-btn' onclick='ShowCheckResult()' id="_PAADM_"^CheckResult>检查报告</button></td>"
        .w "<td><button class='i-btn' onclick='ShowCheckPISResult()' id="_PAADM_"^CheckPISResult "_HiddenPis_">病理报告</button></td>"
        .w "<td><button class='i-btn' onclick='Conclusion()' id="_PAADM_"^Conc>检查结论</button></td>"
        .w "<td><button class='i-btn' onclick='QMManager()' id="_PAADM_"^QM>质量上报</button></td>"
        .w "</tr>"
        w "<TR>"
    }
    else
    {
        w "<TR style='white-space:normal; word-break:break-all;'>"
        w "<td><button style='white-space:normal; word-break:break-all;' onclick='PreviewAllReport()' id="_PAADM_"^Report class='i-btn';>报告预览</button></td>"
        w:HFlag="1" "<td><button style='white-space:normal; word-break:break-all;' onclick='PreviewDirect()' id="_PAADM_"^PreviewDirect class='i-btn';>指引单预览</button></td>"
        s ComNum=##class(web.DHCPE.FetchReport).GetComNumByDate(+$H,CurUser)
        w:HFlag="1" "<td><button style='white-space:normal; word-break:break-all;' onclick='SendAudit()' id="_PAADM_"^SendAudit class='i-btn';>粘贴("_ComNum_")</button></td>"
        w "<td><button class='i-btn'; onclick='ShowCheckResult()' id="_PAADM_"^CheckResult>检查报告<tton></td>"
        w "<td><button class='i-btn'; onclick='QMManager()' id="_PAADM_"^QM>质量上报</button></td>"
        
        w "</TR>"
    }
    w "<TR width=100% height=100% style='white-space:normal; word-break:break-all;'><TD  colspan=12 valign='top' style='white-space:normal; word-break:break-all;'><div style='overflow-y:auto;width:100%;height:100%;white-space:normal; word-break:break-all;'><TABLE height=100% width=100% border=1 cellspacing='0' cellpadding='0' style='white-space:normal; word-break:break-all;'>"
    
    w "<TR height=20 align='center' bgcolor='' style='white-space:normal; word-break:break-all;'><TD width=20% style='white-space:normal; word-break:break-all;'>科室</TD><TD width=50% style='white-space:normal; word-break:break-all;'>检查结果</TD><TD width=30%>建议</TD><TR>"
    s NoHPItem=..GetNoHPItem(PAADM)
    /*
    i NoHPItem'=""
    {
        w "<TR height=20 bgcolor='' style='white-space:normal; word-break:break-all;'><TD width=10% style='white-space:normal; word-break:break-all;'>非体检项目</TD><TD colspan=2 style='white-space:normal; word-break:break-all;'>"_NoHPItem_"</TD><TR>"
        
    }
    */
    s STSort=""
    f  s STSort=$O(^TempDHCPEResultDiagnosisNew(Job,STSort)) q:STSort=""  d
    .s STID=""
    .f  s STID=$O(^TempDHCPEResultDiagnosisNew(Job,STSort,STID)) q:STID=""  d
    ..s SSID=##class(web.DHCPE.ResultEdit).GetSSId(PAADM, STID)
    ..s AuditFlag=0
    ..i SSID'="" d
    ...s Status=$P(^DHCPESS(SSID,1),"^",7)
    ...q:Status="NA"
    ...s AuditFlag=1
    ..s LocSort=""
    ..f  s LocSort=$O(^TempDHCPEResultDiagnosisNew(Job,STSort,STID,LocSort)) q:LocSort=""  d
    ...s LocID=""
    ...f  s LocID=$O(^TempDHCPEResultDiagnosisNew(Job,STSort,STID,LocSort,LocID)) q:LocID=""  d
    ....s OrderItemID=$G(^TempDHCPEResultDiagnosisNewOrder(Job,STSort,STID,LocSort,LocID))
    ....s RowsNum=$G(^TempDHCPEResultDiagnosisNew(Job,STSort,STID,LocSort,LocID))
    ....s STDesc=$P(^DHCPEST(STID),"^",2)
    ....q:(STDesc["检验科")&&(OnlyRead="Y")&&(AdmDate=+$H)
    ....s LocFlag=0
    ....i $L(LocID,"||")>1 d
    .....q:'$D(^DHCPEST(+LocID,"STLOC",$P(LocID,"||",2)))
    .....s LocFlag=1
    .....s STDesc=$P($G(^DHCPEST(+LocID,"STLOC",$P(LocID,"||",2))),"^",1)
    ....i $G(^TempDHCPEResultDiagnosisNewRefuse(Job,STSort,STID,LocSort,LocID))="" d
    .....s STDesc=STDesc_"(放弃)"
    
    ....s:AuditFlag="0" STDesc="<font color=red>"_STDesc_"</font>"
    ....w "<TR bgcolor='' style='white-space:normal; word-break:break-all;'><TD style='cursor:hand;white-space:normal; word-break:break-all;'' id='"_OrderItemID_"' onclick='ShowEDInfo(this)'>"_STDesc_"</TD>"
    ....s OrderNum=1
    ....s OrderSort=""
    ....f  s OrderSort=$O(^TempDHCPEResultDiagnosisNew(Job,STSort,STID,LocSort,LocID,OrderSort)) q:OrderSort=""  d
    .....s Sort=""
    .....f  s Sort=$O(^TempDHCPEResultDiagnosisNew(Job,STSort,STID,LocSort,LocID,OrderSort,Sort)) q:Sort=""  d
    ......q:OrderNum>1
    ......s ItemInfo=$G(^TempDHCPEResultDiagnosisNew(Job,STSort,STID,LocSort,LocID,OrderSort,Sort))
    ......s OrderInfo=$P(ItemInfo,"^",1)
    ......s Item=$P(ItemInfo,"^",2)
    ......;s ARCDesc=##class(web.DHCPE.DHCPECommon).GetArcDesc(Item)
    ......s ARCDesc=..GetOEItemDesc(OrderInfo)
    ......s:'$D(^DHCPERLT(0,"OEORI",OrderInfo)) ARCDesc="<font color=red>"_ARCDesc_"</font>"
    ......;w "<TD style='cursor:hand;white-space:normal; word-break:break-all;' onclick='ShowOneResult(this)' id='"_OrderInfo_"'>"_ARCDesc_"</TD>"
    ......i $L(LocID,"||")>1 d
    .......s ResultLocID=LocID
    ......e  d
    .......s ResultLocID=STID
    ......w "<TD align='left' valign='top' ondblclick='ShowLocResult(this)' id='"_OrderItemID_"' style='white-space:normal; word-break:break-all;'>"_##class(web.DHCPE.MainDiagnosisNew).GetResultByLocID(PAADM, ResultLocID,0,"N")_"</TD>"
    ......s CurStation=STID
    ......s:LocFlag=1 CurStation=LocID
    ......w:OrderNum=1 "<TD align='left' valign='top' id="_CurStation_" valign='top' style='white-space:normal; word-break:break-all;'><label id="_CurStation_" style='white-space:normal; word-break:break-all;'>"_..GetAdviceInfo(GSID,CurStation,MainDoctorFlag,Job,OnlyRead)_"</label></TD>"  // rowspan="_RowsNum_"
    ......w:OrderNum<RowsNum "</TR><TR bgcolor=''>"
    ......s OrderNum=OrderNum+1
    ....w "</TR>"
    w "</TABLE></div></TD></TR>"
    k ^TempDHCPEResultDiagnosisNewOrder(Job)
    k ^TempDHCPEResultDiagnosisNew(Job)
    k ^TempDHCPEResultDiagnosisNewAdvice(Job)
    w "</TABLE>"
}

/// Debug:w ##class(web.DHCPE.ResultDiagnosisNew).GetOrderResult2("3970629||1")
ClassMethod GetOrderResult2(OrderItemID, Job)
{
    if $d(%session) {
        set langId=%session.Get("LOGON.LANGID")
    }
    else
    { s langId=""}
    s curLoc=$p($G(^OEORD($p(OrderItemID,"||",1),"I",$p(OrderItemID,"||",2),1)),"^",3)
    i curLoc="" s curLoc=%session.Get("LOGON.CTLOCID")
    
    s LabStation=$g(^DHCPESetting("DHCPE","StationId_Lab",curLoc))
    s RisStation=$g(^DHCPESetting("DHCPE","StationId_Ris",curLoc))
    s LisMerge=$G(^DHCPESetting("DHCPE","LisReportMerge",curLoc))
    
    s ArcimID=$P($g(^OEORD(+OrderItemID,"I",$P(OrderItemID,"||",2),1)),"^",2)
    s ArcimShortDesc=..GetOEItemDesc(OrderItemID)
     
    s LabSpec=$P(^OEORD(+OrderItemID,"I",$P(OrderItemID,"||",2),3),"^",20)
    i (LabSpec'="")&&(LisMerge="Y") s ArcimShortDesc=##class(web.DHCPE.ResultDiagnosis).GetAllNameBySpecNo(LabSpec)
  
    s StatOrderID=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ArcimID,curLoc)
    q:StatOrderID="" 
    s STID=+StatOrderID
    //s STID=$O(^DHCPEST(0,"STORD_ARCIM",ArcimID,0))
    s StatSetID=$o(^CF.PE.StationSetI("IdxOfLocStation"," "_curLoc,STID,""))
    
    //站点分类顺序
    s LocInfo=""
    s SortID=$o(^CF.PE.StationOrdSortI("IdxOfOrderDR",StatOrderID,0))
    i SortID'="" s LocInfo=$lg(^CF.PE.StationOrdSortD($p(SortID,"||",1),"ORD",$p(SortID,"||",2)))
    //s LocInfo=$G(^DHCPEStationOrder("Loc",ArcimID))
    i LocInfo="" d
    .s LocSort="999999999"
    .s LocID=""
    e  d
    .s LocID=$P(LocInfo,"^",1)
    .s LocSort=$lg($g(^CF.PE.StationOrdSortD($p(SortID,"||",1))),3)
    .;s LocSort=$P($g(^DHCPEST(+LocID,"STLOC",$P(LocID,"||",2))),"^",2)
    .i LocSort="" s LocSort="999999999"
    
    //项目顺序
    s ItemSort=""
    s StatOrdSetID=$o(^CF.PE.StationOrderSetI("IdxOfLocOrder"," "_curLoc,StatOrderID,""))
    i StatOrdSetID'="" s ItemSort=$lg($g(^CF.PE.StationOrderSetD(StatOrdSetID)),8)
    
    s STSub=$O(^DHCPEST(0,"STORD_ARCIM",ArcimID,+STID,0))
    //s ItemSort=$P(^DHCPEST(+STID,"O",STSub),"^",7)
    s:ItemSort="" ItemSort="999999999"
    
    ;q:$D(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OrderItemID)) ArcimShortDesc_$C(2)_"<font color=red>已放弃</font>"_$C(2)_OrderItemID_"^"_""_"^"_STID
    ;q:'$D(^DHCPERLT(0,"OEORI",OrderItemID)) ArcimShortDesc_$C(2)_"<font color=red>未检</font>"_$C(2)_OrderItemID_"^"_""_"^"_STID
    
    i $D(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OrderItemID)) d
    .s ^TempOrderResultSort(Job,"999999999","999999999",OrderItemID,"999999999","999999999")=ArcimShortDesc_$C(2)_"<font color=red>已放弃</font>"_$C(2)_OrderItemID_"^"_""_"^"_STID
    q:$D(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OrderItemID)) 0
     s Stat=$P($g(^OEORD(+OrderItemID,"I",$p(OrderItemID,"||",2),1)),"^",13)
    i Stat=1 d
    .s ^TempOrderResultSort(Job,"999999999","999999999",OrderItemID,"999999999","999999999")=ArcimShortDesc_$C(2)_"<font color=red>未检</font>"_$C(2)_OrderItemID_"^"_""_"^"_STID
    
    i ('$D(^DHCPERLT(0,"OEORI",OrderItemID)))&&(Stat=6) d
    .s ^TempOrderResultSort(Job,"999999999","999999999",OrderItemID,"999999999","999999999")=ArcimShortDesc_$C(2)_"<font color=red>已检未出结果</font>"_$C(2)_OrderItemID_"^"_""_"^"_STID
    s YQID=$o(^User.DHCPEDelayRecordI("OEORIIndex"," "_OrderItemID,0))
    i YQID'=""{
        if ($lg(^User.DHCPEDelayRecordD(YQID),4)="Y"){
            s YQDate=##class(websys.Conversions).DateLogicalToHtml($lg(^User.DHCPEDelayRecordD(YQID),8))
            s ^TempOrderResultSort(Job,"999999999","999999999",OrderItemID,"999999999","999999999")=ArcimShortDesc_$C(2)_"<font color=red>已延期到"_YQDate_"</font>"_$C(2)_OrderItemID_"^"_""_"^"_STID
   
            
        }
        }
    q:'$D(^DHCPERLT(0,"OEORI",OrderItemID)) 0
   
    s EpisodeID=$P(^OEORD(+OrderItemID),"^",1)
    s myStr=##class(web.DHCPE.ResultEdit).GetAgeSex(EpisodeID)
    s myAge=$p(myStr,"^",1)
    s mySex=$p(myStr,"^",2)
    s LabSpec=$P(^OEORD(+OrderItemID,"I",$P(OrderItemID,"||",2),3),"^",20)
    s ret=""
    i LabSpec'="" d
    .i $D(^DHCPERLT("LabSpecNo",LabSpec)) d
    ..;w $G(^DHCPERLT("LabSpecNo",LabSpec)),!
    ..s ret="备注"_$C(2)_$G(^DHCPERLT("LabSpecNo",LabSpec))_$C(2)_""
    ..q:$D(^TempOrderResultSortComment(Job,LabSpec))
    ..s ^TempOrderResultSortComment(Job,LabSpec)=""
    ..s ^TempOrderResultSort(Job,LocSort,ItemSort,"999999999||1","999999999","999999999")=ret
    k ^TempDHCPEOD(Job)
    s RLTID=0
    f  s RLTID=$O(^DHCPERLT(0,"OEORI",OrderItemID,RLTID)) q:RLTID=""  d
    .s NormalFlag=$P(^DHCPERLT(RLTID),"^",7)
    .s AllResultShow=$lg($g(^CF.PE.StationSetD(StatSetID)),10) //总检显示所有结果
    .q:(NormalFlag="1")&&(AllResultShow'="Y")
    .;q:(NormalFlag="1")&&($g(^DHCPECTDataEx("DHCPEStation",STID,"AllResultShow",curLoc))'="Y")
    .s ODID=$P(^DHCPERLT(RLTID),"^",3)
    .q:ODID=""
    .//进入小结（细项）
    .s NeedFlag="Y"
    .S OrderDetailSet=$o(^CF.PE.OrderDetailSetI("IdxOfLocOrdDtl"," "_curLoc,ODID,""))
    .i OrderDetailSet'="" s NeedFlag=$lg($g(^CF.PE.OrderDetailSetD(OrderDetailSet)),4)
    .;s NeedFlag=$P($g(^DHCPEST(+ODID,"OD",$P(ODID,"||",2))),"^",5)
    .q:NeedFlag="N"
    .q:$D(^TempDHCPEOD(Job,ODID))
    .s ^TempDHCPEOD(Job,ODID)=""
    
    .s ODType="T"
    .s ODUnit=""
    .i ODID="" d
    ..s Result="详见报告"
    ..s ODType="T"
    ..s ODDesc=""
    ..s HighRisk=""
    ..s ODUnit=""
    .e  d
    ..s Result=$P(^DHCPERLT(RLTID),"^",4)
    ..s Result=##class(web.DHCPE.Public.Setting).Replace(Result,"@@","<br>")
    ..s Result=##class(web.DHCPE.Public.Setting).Replace(Result,"<","&lt")
    ..s Result=##class(web.DHCPE.Public.Setting).Replace(Result,">","&gt")
    ..i $L(Result,";诊断意见:")>1 d
    ...s Other=$P(Result,";诊断意见:",1)
    ...s ZDYJ=$P(Result,";诊断意见:",2)
    ...s JCSJ=$p(Other,";检查所见:",2)
    ...s Other=$p(Other,";检查所见:",1)
    ...s LCZD=$p(Other,"临床诊断:",2)
    ...s:LCZD'="" LCZD="临床诊断:"_LCZD
    ...s:JCSJ'="" JCSJ="检查所见:"_JCSJ
    ...;s:ZDYJ'="" ZDYJ="诊断意见:"_ZDYJ
    ...s Result=""
    ...;s:LCZD'="" Result=LCZD_"<br>"
    ...;s:JCSJ'="" Result=Result_JCSJ_"<br>"
    ...;s:ZDYJ'="" Result=Result_ZDYJ
    ...s:ZDYJ="" ZDYJ=JCSJ
    ...s Result=ZDYJ
    ..s HighRisk=$p($g(^DHCPERLT(RLTID)),"^",12)
    ..s ODDesc=$P($G(^DHCPEST(+ODID,"OD",$P(ODID,"||",2))),"^",1)
    ..q:ODDesc=""
    ..s ODDesc=##class(User.DHCPEOrderDetail).GetTranByDesc("ODDesc",ODDesc,langId)
    ..s:ODDesc="tx4(t7,t8,t11,t12,t14)" ODDesc="tx4(白栎,美洲榆,英国梧桐树,柳树,美洲黑杨)"
    ..s:ODDesc="tx10(t2,t3,t4,t15)" ODDesc="tx10(灰桤木,疣皮桦,欧洲榛,美国白蜡)"
    
    ..s ODUnit=$P($g(^DHCPEST(+ODID,"OD",$P(ODID,"||",2))),"^",4)
    ..s ODType=$P($g(^DHCPEST(+ODID,"OD",$P(ODID,"||",2))),"^",2)
    ..i LabStation=+ODID d
    ...s NormalResult=$g(^DHCPEDataEx("DHCPEResult",RLTID,"Ranges"))
    ...s ODUnit=$g(^DHCPEDataEx("DHCPEResult",RLTID,"Unit"))
    ..e  d
    ...s NormalResult=##class(web.DHCPE.ResultEdit).GetNormal(ODID,mySex,myAge)
    ...s ODUnit=$P($g(^DHCPEST(+ODID,"OD",$P(ODID,"||",2))),"^",4)
    .s TSInfo="1"
    .s:(ODType="N")||(ODType="C") TSInfo=##class(web.DHCPE.TransResult).GetLabResultArrowNew(RLTID)
    .s:TSInfo="2" TSInfo="↑"
    .s:TSInfo="0" TSInfo="↓"
    .s:TSInfo'="1" Result=Result_" "_TSInfo
    .s ResultFormat=##class(web.DHCPE.ResultNew).GetResultFormat(+ODID,curLoc)
    .s:ODUnit'="" Result=Result_" "_ODUnit
    .s:((ODType="N")||(ODType="C"))&&(NormalResult'="")&&(NormalResult'[("阴性")) Result=Result_"【"_NormalResult_"】"
    .s Result=Result
    .i ResultFormat'=3 d
    ..i LabStation=STID  d
    ...s Desc=ArcimShortDesc_" "_ODDesc
    ..e  s Desc=ODDesc
    .e  d
    ..s Desc=ArcimShortDesc
    .s ElementID=OrderItemID_"^"_ODID_"^"_STID
    .q:Result=""
    .s Result=##class(web.DHCPE.Public.Setting).Replace(Result,$C(13,10),"<br>")
    .s ret=Desc_$C(2)_Result_$C(2)_ElementID
    .s ShowSort=$P(^DHCPERLT(RLTID),"^",14)
    .s:ShowSort="" ShowSort="9999999"
    .//检查的按检查号走
    .s RisMerge=$G(^DHCPESetting("DHCPE","RisReportMerge",curLoc))
    .s RisStudyNo=##class(web.DHCPE.HISUICommon).GetStudyNoByOEORI(OrderItemID)
    .i (RisMerge="Y")&&(RisStudyNo'="") s ^TempOrderResultSort(Job,LocSort,ItemSort,RisStudyNo,ShowSort,RLTID)=ret
    .e  s ^TempOrderResultSort(Job,LocSort,ItemSort,OrderItemID,ShowSort,RLTID)=ret
    k ^TempDHCPEOD(Job)
    //q:ret="" ArcimShortDesc_$C(2)_"未见明显异常"_$C(2)_OrderItemID_"^"_""_"^"_STID
    q 0
}

ClassMethod GetOrderResult(OrderItemID)
{
    //w ##class(web.DHCPE.ResultDiagnosisNew).GetOrderResult("3970629||14")
   
    s LocID=$p($G(^OEORD($p(OrderItemID,"||",1),"I",$p(OrderItemID,"||",2),1)),"^",3) 
    //s LabStation=$g(^DHCPESetting("DHCPE","StationId_Lab"))
    //s RisStation=$g(^DHCPESetting("DHCPE","StationId_Ris"))
    s LabStation=$g(^DHCPESetting("DHCPE","StationId_Lab",LocID))
    s RisStation=$g(^DHCPESetting("DHCPE","StationId_Ris",LocID))

    s ArcimID=$P(^OEORD(+OrderItemID,"I",$P(OrderItemID,"||",2),1),"^",2)
    s ArcimShortDesc=##class(web.DHCPE.DHCPECommon).GetArcDesc(ArcimID)
    
    //根据医嘱项获取站点ID
    s StatOrderID=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ArcimID,LocID)
    q:StatOrderID="" 
    s STID=+StatOrderID 
    //s STID=$O(^DHCPEST(0,"STORD_ARCIM",ArcimID,0))
    
    q:$D(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OrderItemID)) ArcimShortDesc_$C(2)_"<font color=red>已放弃</font>"_$C(2)_OrderItemID_"^"_""_"^"_STID
    q:'$D(^DHCPERLT(0,"OEORI",OrderItemID)) ArcimShortDesc_$C(2)_"<font color=red>没有结果</font>"_$C(2)_OrderItemID_"^"_""_"^"_STID
    
    s EpisodeID=$P(^OEORD(+OrderItemID),"^",1)
    s myStr=##class(web.DHCPE.ResultEdit).GetAgeSex(EpisodeID)
    s myAge=$p(myStr,"^",1)
    s mySex=$p(myStr,"^",2)
    s ret=""
    s RLTID=0
    f  s RLTID=$O(^DHCPERLT(0,"OEORI",OrderItemID,RLTID)) q:RLTID=""  d
    .s NormalFlag=$P(^DHCPERLT(RLTID),"^",7)
    .q:(NormalFlag="1")&&(STID'="1")
    .s ODID=$P(^DHCPERLT(RLTID),"^",3)
    .s ODType="T"
    .s ODUnit=""
    .i ODID="" d
    ..s Result="详见报告"
    ..s ODType="T"
    ..s ODDesc=""
    ..s HighRisk=""
    ..s ODUnit=""
    .e  d
    ..s Result=$P(^DHCPERLT(RLTID),"^",4)
    ..s Result=##class(web.DHCPE.Public.Setting).Replace(Result,"@@","<br>")
    ..i $L(Result,";诊断意见:")>1 d
    ...s Other=$P(Result,";诊断意见:",1)
    ...s ZDYJ=$P(Result,";诊断意见:",2)
    ...s JCSJ=$p(Other,";检查所见:",2)
    ...s Other=$p(Other,";检查所见:",1)
    ...s LCZD=$p(Other,"临床诊断:",2)
    ...s:LCZD'="" LCZD="临床诊断:"_LCZD
    ...s:JCSJ'="" JCSJ="检查所见:"_JCSJ
    ...;s:ZDYJ'="" ZDYJ="诊断意见:"_ZDYJ
    ...s Result=""
    ...;s:LCZD'="" Result=LCZD_"<br>"
    ...;s:JCSJ'="" Result=Result_JCSJ_"<br>"
    ...;s:ZDYJ'="" Result=Result_ZDYJ
    ...s Result=ZDYJ
    ..s HighRisk=$p($g(^DHCPERLT(RLTID)),"^",12)
    ..s ODDesc=$P($G(^DHCPEST(+ODID,"OD",$P(ODID,"||",2))),"^",1)
    ..q:ODDesc=""
    ..s ODUnit=$P(^DHCPEST(+ODID,"OD",$P(ODID,"||",2)),"^",4)
    ..s ODType=$P(^DHCPEST(+ODID,"OD",$P(ODID,"||",2)),"^",2)
    ..i LabStation=+ODID d
    ...s NormalResult=$G(^DHCPEDataEx("DHCPEResult",RLTID,"Ranges"))
    ...s ODUnit=$G(^DHCPEDataEx("DHCPEResult",RLTID,"Unit"))
    ..e  d
    ...s NormalResult=##class(web.DHCPE.ResultEdit).GetNormal(ODID,mySex,myAge)
    ...s ODUnit=$P($g(^DHCPEST(+ODID,"OD",$P(ODID,"||",2))),"^",4)
    .s TSInfo="1"
    .s:(ODType="N")||(ODType="C") TSInfo=##class(web.DHCPE.TransResult).GetLabResultArrowNew(RLTID)
    .s:TSInfo="2" TSInfo="↑"
    .s:TSInfo="0" TSInfo="↓"
    .s:TSInfo'="1" Result=Result_" "_TSInfo
    .s ResultFormat=##class(web.DHCPE.ResultNew).GetResultFormat(+ODID,LocID)
    .s:ODUnit'="" Result=Result_" "_ODUnit
    .s:((ODType="N")||(ODType="C"))&&(NormalResult'="") Result=Result_"("_NormalResult_")"
    .i ResultFormat'=3 d
    ..s Desc=ODDesc
    .e  d
    ..s Desc=ArcimShortDesc
    .s ElementID=OrderItemID_"^"_ODID_"^"_STID
    .q:Result=""
    .i ret="" d
    ..s ret=Desc_$C(2)_Result_$C(2)_ElementID
    .e  d
    ..s ret=ret_$C(1)_Desc_$C(2)_Result_$C(2)_ElementID
   
    //q:ret="" ArcimShortDesc_$C(2)_"未见明显异常"_$C(2)_OrderItemID_"^"_""_"^"_STID
    q ret
}

/// debug: d ##class(web.DHCPE.ResultDiagnosisNew).GetAdviceInfoHISUI()
ClassMethod GetAdviceInfoHISUI(GSID, StationID, MainDoctorFlag, Job, OnlyRead As %String = "N")
{

    q:GSID="" ""
    ;if (StationID["||") s StationID=$p(StationID,"||",1)
    i '$D(^TempDHCPEResultDiagnosisNewAdvice(Job)) d
    .s Sort=0
    .f  s Sort=$o(^DHCPEGS(0,"GSDSort",GSID,Sort)) q:Sort=""  d
    ..s gSub=0
    ..f  s gSub=$o(^DHCPEGS(0,"GSDSort",GSID,Sort,gSub)) q:gSub=""  d
    ...;q:'$D(^DHCPEDataEx("DHCPEGeneralSummarize","ReCheckDetail",GSID_"||"_gSub))&&(MainDoctorFlag="Y")
    ...s Flag=0
    ...s:$D(^DHCPEDataEx("DHCPEGeneralSummarize","ReCheckDetail",GSID_"||"_gSub)) Flag=1
    ...s Status=$p($g(^DHCPEGS(GSID,"Diagnosis",gSub)),"^",11)
    ...q:Status'=0
    ...s EDID=$p($g(^DHCPEGS(GSID,"Diagnosis",gSub)),"^",1)
    ...q:EDID=""
    ...s EDDesc=$p($g(^DHCPEGS(GSID,"Diagnosis",gSub)),"^",9)
    ...s EDDesc=##class(web.DHCPE.ReportGetInfor).ReplaceXH(EDDesc)
    ...s DiagnoseConclusion=$p($g(^DHCPEED(EDID,"1")),"^",1)
    ...
    ...s CurSTID=$p($g(^DHCPEGS(GSID,"Diagnosis",gSub)),"^",13)
    ...s:(CurSTID="") CurSTID=$p($g(^DHCPEED(EDID,"1")),"^",7)
    ...s LocID=$p($g(^DHCPEED(EDID,"1")),"^",10) //站点分组ID
    ...i LocID'="" s CurSTID=LocID
    ...s CurSTLocID=$p($g(^DHCPEGS(GSID,"Diagnosis",gSub)),"^",14)
    ...i CurSTLocID'="" s CurSTID=CurSTLocID
    ...;w CurSTID_"CurSTID"
    ...q:(CurSTID="")
    ...
    ...s GSDRowId=GSID_"||"_gSub
    ...
    ...// 增加乙肝标志 add
    ...s YGFlag=$p($g(^DHCPEGS(GSID,"Diagnosis",gSub)),"^",12)
    ...// 增加乙肝标志 end
    ...
    ...i $d(^DHCPEDataEx("DHCPEGSDiagnosis","DisplayDesc",GSDRowId))'=0 d
    ....s DiagnoseConclusion=$g(^DHCPEDataEx("DHCPEGSDiagnosis","DisplayDesc",GSDRowId))
    ...
    ...// 修改乙肝标志 mod
    ...s ^TempDHCPEResultDiagnosisNewAdvice(Job,CurSTID,Sort,GSDRowId)=DiagnoseConclusion_"^"_EDDesc_"^"_Flag_"^"_GSDRowId_"^"_YGFlag
    ...;s ^TempDHCPEResultDiagnosisNewAdvice(Job,CurSTID,Sort,GSDRowId)=DiagnoseConclusion_"^"_EDDesc_"^"_Flag_"^"_GSDRowId
    ...// 修改乙肝标志 end
    
    s HadMainFlag=0
    s IADM=$P($G(^DHCPEGS(GSID,1)),"^",1)
    s AuditUser=$P($G(^DHCPEGS(GSID,1)),"^",5)
    i IADM="" d
    .s PAADM=$P($G(^DHCPEGS(GSID,1)),"^",8)
    e  d
    .s PAADM=$P($g(^DHCPEIADM(IADM)),"^",1)
    i PAADM'="" s LocID=$p($g(^PAADM(PAADM)),"^",4)
    s:$D(^DHCPEDataEx("DHCPEGeneralSummarize","MainDoctor",PAADM)) HadMainFlag=1
    s ret=""
    s i=1
    i (OnlyRead="Y")
    {
        ;只读
        s AuditUser="a"
        s HadMainFlag="1"
    }
    
    // 增加乙肝标志 add
    s YGItemFlag=##class(web.DHCPE.ResultDiagnosis).GetYGItemFlag(GSID,"GSID")
    // 增加乙肝标志 end
    
    ;w HadMainFlag_"^"_AuditUser,!
    s Sort=""
    
    s ret="<DIV id='addiagnosisdiv'><Table width=98% border=0 cellspacing='0' cellpadding='0' style='white-space:normal; word-break:break-all;'>"
    ;q:(StationID="")
    f  s Sort=$O(^TempDHCPEResultDiagnosisNewAdvice(Job,StationID,Sort)) q:Sort=""  d
    .s ID=""
    .f  s ID=$O(^TempDHCPEResultDiagnosisNewAdvice(Job,StationID,Sort,ID)) q:ID=""  d
    ..s Info=$G(^TempDHCPEResultDiagnosisNewAdvice(Job,StationID,Sort,ID))
    ..s Flag=$P(Info,"^",3)
    ..s CheckInfo=""
    ..i i=1 d
    ...q:HadMainFlag="1"
    ...q:(MainDoctorFlag="N")&&(AuditUser'="")
    ...;s:OnlyRead'="Y" CheckInfo="<button onclick='ModifyAdvice(this)' id="_StationID_">编辑</button>"
    ..s CheckInfo=CheckInfo_"<input  type='checkbox' name='MainFlag' id="_ID
    ..s:Flag="1" CheckInfo=CheckInfo_" checked"
    ..//初检权限或者已复检不允许修改复检标志
    ..s:(MainDoctorFlag'="Y")||(HadMainFlag="1") CheckInfo=CheckInfo_" disabled='disabled'"
    ..s CheckInfo=CheckInfo_">"
    ..s OneInfo="<TR style='white-space:normal; word-break:break-all;'>"
    ..
    ..// 增加乙肝标志 add
    ..i $P(Info,"^",5)="Y" d
    ...s YGImgsrc="../scripts_lib/hisui-0.1.0/dist/css/icons/virus.png"
    ...s YGTitle="乙肝建议"
    ...s YGID="YGFlag^"_ID
    ..e  d
    ...s YGImgsrc="../scripts_lib/hisui-0.1.0/dist/css/icons/stethoscope.png"
    ...s YGTitle="正常建议"
    ...s YGID="ZCFlag^"_ID
    ..// 增加乙肝标志 end
    ..
    ..i AuditUser'="" d
    ...;s:HadMainFlag'=1 OneInfo="<TD width=5% style='white-space:normal; word-break:break-all;'><button onclick='DeleteAdvice(this,1)' name='DeleteButton' id='"_ID_"'><font color=red>×</font></button></TD>"
    ...s OneInfo="<TD width=30>"_CheckInfo_"</TD>"
    ...i (MainDoctorFlag'="Y")||(HadMainFlag="1") d
    ....s OneInfo=OneInfo_"<TD width=45% style='white-space:normal; word-break:break-all;'><B>"_..ReplaceKey($P(Info,"^",1),LocID)_"</B></TD>"
    ....s OneInfo=OneInfo_"<TD style='white-space:normal; word-break:break-all;'>"_$P(Info,"^",2)_"</TD>"
    ...e  d
    ....// 修改乙肝标志 mod
    ....i YGItemFlag="3" d
    .....s OneInfo=OneInfo_"<TD width=47 style='white-space:normal; word-break:break-all;'><button id='"_ID_"' name='DeleteButton' onclick='DeleteAdvice(this,1)' class='hisui-linkbutton' plain=true iconCls='icon-cancel'></button><a href='javascript:void(0);' onclick='SetYGFlag(this,1)' title='"_YGTitle_"' class='hisui-tooltip' data-options=""position:'top'"" name='YGFlag' id='"_YGID_"' style='padding-left:7px;'><img src='"_YGImgsrc_"' border=0/></a></TD>"
    .....s OneInfo=OneInfo_"<TD width=5% style='white-space:normal; word-break:break-all;'><button id='"_ID_"' name='SaveButton' onclick='SaveOneAdvice(this)' class='hisui-linkbutton' plain=true iconCls='icon-save-to'></button></TD>"
    .....s OneInfo=OneInfo_"<TD width=200 style='white-space:normal; word-break:break-all;'><textarea id='"_ID_"^JL' onpropertychange='setTareaAutoHeight(this)' style='width:100%; word-break:break-all;'>"_$P(Info,"^",1)_"</textarea></TD>"
    .....s OneInfo=OneInfo_"<TD width=2% style='white-space:normal; word-break:break-all;'>&nbsp;</TD>"
    .....s OneInfo=OneInfo_"<TD style='white-space:normal; word-break:break-all;'><textarea id='"_ID_"^JY' onpropertychange='setTareaAutoHeight(this)' style='width:100%;'>"_$P(Info,"^",2)_"</textarea></TD>"
    .....s OneInfo=OneInfo_"<TD width=5% style='display:none;white-space:normal; word-break:break-all;' id='"_ID_"^Sort'>"_Sort_"</TD>"
    ....e  d
    .....s OneInfo=OneInfo_"<TD width=30 style='white-space:normal; word-break:break-all;'><button id='"_ID_"' name='DeleteButton' onclick='DeleteAdvice(this,1)' class='hisui-linkbutton' plain=true iconCls='icon-cancel'></button></TD>"
    .....s OneInfo=OneInfo_"<TD width=5% style='white-space:normal; word-break:break-all;'><button id='"_ID_"' name='SaveButton' onclick='SaveOneAdvice(this)' class='hisui-linkbutton' plain=true iconCls='icon-save-to'></button></TD>"
    .....s OneInfo=OneInfo_"<TD width=200 style='white-space:normal; word-break:break-all;'><textarea id='"_ID_"^JL' onpropertychange='setTareaAutoHeight(this)' style='width:200; word-break:break-all;'>"_$P(Info,"^",1)_"</textarea></TD>"
    .....s OneInfo=OneInfo_"<TD width=2% style='white-space:normal; word-break:break-all;'>&nbsp;</TD>"
    .....s OneInfo=OneInfo_"<TD width=95% style='white-space:normal; word-break:break-all;'><textarea id='"_ID_"^JY' onpropertychange='setTareaAutoHeight(this)' style='width:100%;'>"_$P(Info,"^",2)_"</textarea></TD>"
    .....s OneInfo=OneInfo_"<TD  width=5% style='display:none;white-space:normal; word-break:break-all;' id='"_ID_"^Sort'>"_Sort_"</TD>"
    ....// 修改乙肝标志 end
    
    ..e  d
    ...// 修改乙肝标志 mod
    ...i YGItemFlag="3" d
    ....s OneInfo=OneInfo_"<TD width=47 style='white-space:normal; word-break:break-all;'><button id='"_ID_"' name='DeleteButton' onclick='DeleteAdvice(this,1)' class='hisui-linkbutton' plain=true iconCls='icon-cancel'></button><a href='javascript:void(0);' onclick='SetYGFlag(this,1)' title='"_YGTitle_"' class='hisui-tooltip' data-options=""position:'top'"" name='YGFlag' id='"_YGID_"' style='padding-left:7px;'><img src='"_YGImgsrc_"' border=0/></a></TD>"
    ....s OneInfo=OneInfo_"<TD width=5% style='white-space:normal; word-break:break-all;'><button id='"_ID_"' name='SaveButton' onclick='SaveOneAdvice(this)' class='hisui-linkbutton' plain=true iconCls='icon-save-to'></button></TD>"
    ....s OneInfo=OneInfo_"<TD width=200 style='white-space:normal; word-break:break-all;'><textarea id='"_ID_"^JL' onpropertychange='setTareaAutoHeight(this)' style='width:100%; word-break:break-all;'>"_$P(Info,"^",1)_"</textarea></TD>"
    ....s OneInfo=OneInfo_"<TD width=2% style='white-space:normal; word-break:break-all;'>&nbsp;</TD>"
    ....s OneInfo=OneInfo_"<TD style='white-space:normal; word-break:break-all;'><textarea id='"_ID_"^JY' onpropertychange='setTareaAutoHeight(this)' style='width:100%;'>"_$P(Info,"^",2)_"</textarea></TD>"
    ....s OneInfo=OneInfo_"<TD width=5% style='display:none;white-space:normal; word-break:break-all;' id='"_ID_"^Sort'>"_Sort_"</TD>"
    ...e  d
    ....s OneInfo=OneInfo_"<TD width=5% style='white-space:normal; word-break:break-all;'><button id='"_ID_"' name='DeleteButton' onclick='DeleteAdvice(this,1)' class='hisui-linkbutton' plain=true iconCls='icon-cancel'></button></TD>"
    ....s OneInfo=OneInfo_"<TD width=5% style='white-space:normal; word-break:break-all;'><button id='"_ID_"' name='SaveButton' onclick='SaveOneAdvice(this)' class='hisui-linkbutton' plain=true iconCls='icon-save-to'></button></TD>"
    ....s OneInfo=OneInfo_"<TD width=45% style='white-space:normal; word-break:break-all;'><textarea id='"_ID_"^JL' onpropertychange='setTareaAutoHeight(this)' style='width:100%; word-break:break-all;'>"_$P(Info,"^",1)_"</textarea></TD>"
    ....s OneInfo=OneInfo_"<TD width=2% style='white-space:normal; word-break:break-all;'>&nbsp;</TD>"
    ....s OneInfo=OneInfo_"<TD style='white-space:normal; word-break:break-all;'><textarea id='"_ID_"^JY' onpropertychange='setTareaAutoHeight(this)' style='width:100%;'>"_$P(Info,"^",2)_"</textarea></TD>"
    
    ....s OneInfo=OneInfo_"<TD width=5% style='display:none;white-space:normal; word-break:break-all;' id='"_ID_"^Sort'>"_Sort_"</TD>"
    ...// 修改乙肝标志 end
    ..s OneInfo=OneInfo_"</TR>"
    ..s ret=ret_OneInfo
    ..s i=i+1
    s ret=ret_"</Table></DIV>"
    q ret
}

ClassMethod GetAdviceInfo(GSID, StationID, MainDoctorFlag, Job, OnlyRead As %String = "N")
{
    
    q:GSID="" ""
    if (StationID["||") s StationID=$p(StationID,"||",1)
    i '$D(^TempDHCPEResultDiagnosisNewAdvice(Job)) d
    .s Sort=0
    .f  s Sort=$o(^DHCPEGS(0,"GSDSort",GSID,Sort)) q:Sort=""  d
    ..
    ..s gSub=0
    ..f  s gSub=$o(^DHCPEGS(0,"GSDSort",GSID,Sort,gSub)) q:gSub=""  d
    ...;q:'$D(^DHCPEDataEx("DHCPEGeneralSummarize","ReCheckDetail",GSID_"||"_gSub))&&(MainDoctorFlag="Y")
    ...s Flag=0
    ...s:$D(^DHCPEDataEx("DHCPEGeneralSummarize","ReCheckDetail",GSID_"||"_gSub)) Flag=1
    ...s Status=$p(^DHCPEGS(GSID,"Diagnosis",gSub),"^",11)
    ...
    ...q:Status'=0
    ...s EDID=$p(^DHCPEGS(GSID,"Diagnosis",gSub),"^",1)
    ...
    ...q:EDID=""
    ...s EDDesc=$p(^DHCPEGS(GSID,"Diagnosis",gSub),"^",9)
    ...s EDDesc=##class(web.DHCPE.ReportGetInfor).ReplaceXH(EDDesc)
    ...s DiagnoseConclusion=$p($g(^DHCPEED(EDID,"1")),"^",1)
    ...s CurSTID=$p($g(^DHCPEED(EDID,"1")),"^",7)
    ...s LocID=$p($g(^DHCPEED(EDID,"1")),"^",10)
    ...i LocID'="" s CurSTID=+LocID
    ...s GSDRowId=GSID_"||"_gSub
    ...
    ...i $d(^DHCPEDataEx("DHCPEGSDiagnosis","DisplayDesc",GSDRowId))'=0 d
    ....s DiagnoseConclusion=$g(^DHCPEDataEx("DHCPEGSDiagnosis","DisplayDesc",GSDRowId))
    ...
    ...s ^TempDHCPEResultDiagnosisNewAdvice(Job,CurSTID,Sort,GSDRowId)=DiagnoseConclusion_"^"_EDDesc_"^"_Flag_"^"_GSDRowId
    s HadMainFlag=0
    s IADM=$P($G(^DHCPEGS(GSID,1)),"^",1)
    s AuditUser=$P($G(^DHCPEGS(GSID,1)),"^",5)
    i IADM="" d
    .s PAADM=$P($G(^DHCPEGS(GSID,1)),"^",8)
    e  d
    .s PAADM=$P(^DHCPEIADM(IADM),"^",1)
    s:$D(^DHCPEDataEx("DHCPEGeneralSummarize","MainDoctor",PAADM)) HadMainFlag=1
    s ret=""
    s i=1
    
    i (OnlyRead="Y")
    {
        ;只读
        s AuditUser="a"
        s HadMainFlag="1"
    }
    ;w HadMainFlag_"^"_AuditUser,!
    s Sort=""
    s ret="<Table width=100% border=0 cellspacing='0' cellpadding='0' style='white-space:normal; word-break:break-all;'>"
    ;q:(StationID="")
    f  s Sort=$O(^TempDHCPEResultDiagnosisNewAdvice(Job,StationID,Sort)) q:Sort=""  d
    .
    .s ID=""
    .f  s ID=$O(^TempDHCPEResultDiagnosisNewAdvice(Job,StationID,Sort,ID)) q:ID=""  d
    ..s Info=$G(^TempDHCPEResultDiagnosisNewAdvice(Job,StationID,Sort,ID))
    ..s Flag=$P(Info,"^",3)
    ..
    ..s CheckInfo=""
    ..i i=1 d
    ...q:HadMainFlag="1"
    ...q:(MainDoctorFlag="N")&&(AuditUser'="")
    ...;s:OnlyRead'="Y" CheckInfo="<button onclick='ModifyAdvice(this)' id="_StationID_">编辑</button>"
    ..s CheckInfo=CheckInfo_"<input type='checkbox' name='MainFlag' id="_ID
    ..s:Flag="1" CheckInfo=CheckInfo_" checked"
    ..//初检权限或者已复检不允许修改复检标志
    ..s:(MainDoctorFlag'="Y")||(HadMainFlag="1") CheckInfo=CheckInfo_" disabled='disabled'"
    ..s CheckInfo=CheckInfo_">"
    ..s OneInfo="<TR style='white-space:normal; word-break:break-all;'>"
    ..i AuditUser'="" d
    ...;s:HadMainFlag'=1 OneInfo="<TD width=5% style='white-space:normal; word-break:break-all;'><button onclick='DeleteAdvice(this,1)' name='DeleteButton' id='"_ID_"'><font color=red>×</font></button></TD>"
    ...s OneInfo="<TD width=30>"_CheckInfo_"</TD>"
    ...i (MainDoctorFlag'="Y")||(HadMainFlag="1") d
    ....s OneInfo=OneInfo_"<TD width=45% style='white-space:normal; word-break:break-all;'><B>"_..ReplaceKey($P(Info,"^",1))_"</B></TD>"
    ....s OneInfo=OneInfo_"<TD style='white-space:normal; word-break:break-all;'>"_$P(Info,"^",2)_"</TD>"
    ...e  d
    ....s OneInfo=OneInfo_"<TD width=200 style='white-space:normal; word-break:break-all;'><textarea id='"_ID_"^JL' onpropertychange='setTareaAutoHeight(this)' style='width:200;white-space:normal; word-break:break-all;'>"_$P(Info,"^",1)_"</textarea></TD>"
    ....s OneInfo=OneInfo_"<TD width=95% style='white-space:normal; word-break:break-all;'><textarea id='"_ID_"^JY' onpropertychange='setTareaAutoHeight(this)' style='width:100%;white-space:normal;'>"_$P(Info,"^",2)_"</textarea></TD>"
    ....s OneInfo=OneInfo_"<TD  width=5% style='display:none;white-space:normal; word-break:break-all;' id='"_ID_"^Sort'>"_Sort_"</TD>"
    ....s OneInfo=OneInfo_"<TD width=30 style='white-space:normal; word-break:break-all;'><button onclick='DeleteAdvice(this,1)' name='DeleteButton' id='"_ID_"'><font color=red>×</font></button></TD>"
    ..e  d
    ...s OneInfo=OneInfo_"<TD width=5% style='white-space:normal; word-break:break-all;'><button onclick='DeleteAdvice(this,1)' name='DeleteButton' id='"_ID_"'><font color=red>×</font></button></TD>"
    ...s OneInfo=OneInfo_"<TD width=45% style='white-space:normal; word-break:break-all;'><textarea id='"_ID_"^JL' onpropertychange='setTareaAutoHeight(this)' style='width:100%;white-space:normal; word-break:break-all;'>"_$P(Info,"^",1)_"</textarea></TD>"
    ...s OneInfo=OneInfo_"<TD style='white-space:normal; word-break:break-all;'><textarea id='"_ID_"^JY' onpropertychange='setTareaAutoHeight(this)' style='width:100%;white-space:normal;'>"_$P(Info,"^",2)_"</textarea></TD>"
    ...s OneInfo=OneInfo_"<TD  width=5% style='display:none;white-space:normal; word-break:break-all;' id='"_ID_"^Sort'>"_Sort_"</TD>"
    ..s OneInfo=OneInfo_"</TR>"
    ..s ret=ret_OneInfo
    ..s i=i+1
    s ret=ret_"</Table>"
    q ret
}

ClassMethod ISSaveMainCheck(ID)
{
    s flag=0
    i $d(^DHCPEDataEx("DHCPEGeneralSummarize","ReCheckDetail",ID)) d
    .s flag=1
    q flag
}

ClassMethod SaveMainCheck(UseStr, NoUseStr, UserID)
{
    //^DHCPEDataEx("DHCPEGeneralSummarize","ReCheckDetail",ID)=$H_"^"_UserID
    s Date=$H
    s UseLength=$L(UseStr,"^")
    
    f i=1:1:UseLength
    {
        s ID=$P(UseStr,"^",i)
        continue:ID=""
        s ^DHCPEDataEx("DHCPEGeneralSummarize","ReCheckDetail",ID)=Date_"^"_UserID
    }
    
    s NoUseLength=$L(NoUseStr,"^")
    f i=1:1:NoUseLength
    {
        s ID=$P(NoUseStr,"^",i)
        continue:ID=""
        k ^DHCPEDataEx("DHCPEGeneralSummarize","ReCheckDetail",ID)
    }
    
    q 0
}

ClassMethod OutAdviceToHtmlHISUI(GSID, StationID, MainDoctor, DivFlag As %String = "N")
{
    
    s PAAdmRowid=$p($g(^DHCPEGS(GSID,1)),"^",8)
    s ADMLocID=$P($g(^PAADM(PAAdmRowid)),"^",4)
    
    s Job=$J
    s Sort=0
    s AuditUser=$P($g(^DHCPEGS(GSID,1)),"^",5)
    s SortFlag=$g(^DHCPEGS(GSID,"SortFlag"))
    f  s Sort=$o(^DHCPEGS(0,"GSDSort",GSID,Sort)) q:Sort=""  d
    .s gSub=0
    .f  s gSub=$o(^DHCPEGS(0,"GSDSort",GSID,Sort,gSub)) q:gSub=""  d
    ..;q:'$D(^DHCPEDataEx("DHCPEGeneralSummarize","ReCheckDetail",GSID_"||"_gSub))&&(MainDoctorFlag="Y")
    ..s Flag=0
    ..s:$D(^DHCPEDataEx("DHCPEGeneralSummarize","ReCheckDetail",GSID_"||"_gSub)) Flag=1
    ..s Status=$p($g(^DHCPEGS(GSID,"Diagnosis",gSub)),"^",11)
    ..q:Status'="0"
    ..s EDID=$p($g(^DHCPEGS(GSID,"Diagnosis",gSub)),"^",1)
    ..q:EDID=""
    ..s EDDesc=$p($g(^DHCPEGS(GSID,"Diagnosis",gSub)),"^",9)
    ..;s EDDesc=##class(web.DHCPE.ReportGetInfor).ReplaceXH(EDDesc)
    ..s DiagnoseConclusion=$p($g(^DHCPEED(EDID,"1")),"^",1)
    ..s CurSTID=$p($g(^DHCPEED(EDID,"1")),"^",7)     //站点ID
    ..s CurSTLocID=$p($g(^DHCPEED(EDID,"1")),"^",10) //站点分类ID
    ..s:CurSTLocID'="" CurSTID=CurSTLocID
    ..q:(StationID'="")&&(StationID'=CurSTID)
    ..;s CurSTSort=$P($G(^DHCPEST(CurSTID)),"^",4)
    ..s STSetID=$o(^CF.PE.StationSetI("IdxOfLocStation"," "_ADMLocID,CurSTID,"")) //站点详情ID
    ..s CurSTSort=""
    ..i STSetID'="" s CurSTSort=$lg($g(^CF.PE.StationSetD(STSetID)),5)      
    ..s:CurSTSort="" CurSTSort="999999"
    ..s GSDRowId=GSID_"||"_gSub
    ..i $d(^DHCPEDataEx("DHCPEGSDiagnosis","DisplayDesc",GSDRowId))'=0 d
    ...s DiagnoseConclusion=$g(^DHCPEDataEx("DHCPEGSDiagnosis","DisplayDesc",GSDRowId))
    ..s ^TempDHCPEResultDiagnosis(Job,1,1,Sort,GSDRowId)=DiagnoseConclusion_"^"_EDDesc_"^"_Flag_"^"_GSDRowId
   
    w "<TABLE border=1 cellspacing='0' cellpadding='0' width=99% height=10% style='white-space:normal; word-break:break-all;'>"
    w "<tr></tr>"
    w "<tr> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color=red>注: 拖动建议可进行任意排序</font></tr>"
    w "<tr></tr>"
    
    s SAHidden=""
    s:(MainDoctor'="Y") SAHidden="style='display:none;'"
    
    w "<TR bgcolor='' border=1 style='white-space:normal; word-break:break-all;'>"
    w "<TD><button onclick=SetSort() class='hisui-linkbutton' plain=true iconCls='icon-reload'>按级别、站点排序</button></TD>"
    w:DivFlag="N" "<td><button onclick='SaveAdvice()' class='hisui-linkbutton' plain=true iconCls='icon-save'>确定</button></td>"
    w "<TD id='UniteAdvice'><button onclick='UniteAdvice_click()' class='hisui-linkbutton' plain=true iconCls='icon-reload'>合并</button></TD>"
    w:DivFlag="N" "<td><button id='UnitRecord' onclick='UnitRecord()' class='hisui-linkbutton' plain=true iconCls='icon-emr-cri'>合并记录</button></td>"
    w "<TD id='AllSelectAdvice'"_SAHidden_"><button onclick= AllSelectAdvice() class='hisui-linkbutton' plain=true iconCls='icon-reload'>审核</button></TD>"
    w "</TR>"
    
    w "</TABLE>"
    
    /***翻译 start***/
    s TSortEng=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpeneweditadvice.hisui.csp","序号")
    s TAuditEng=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpeneweditadvice.hisui.csp","审核")
    s TMergerEng=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpeneweditadvice.hisui.csp","合并")
    s TOperateEng=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpeneweditadvice.hisui.csp","操作")
    s TConclusionEng=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpeneweditadvice.hisui.csp","结论")
    s TAdviceEng=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpeneweditadvice.hisui.csp","建议")
    /***翻译 end***/
    
    w:DivFlag="Y" "<div style='overflow-y:auto;width:99%;height:90%'>"
    w "<TABLE id='EditAdvice' border=1 cellspacing='0' cellpadding='0' width=99% style='white-space:normal; word-break:break-all;'>"
    i MainDoctor="Y" w "<TR align='center' bgcolor='' style='white-space:normal; word-break:break-all;'><TD width=5% style='white-space:normal; word-break:break-all;'>"_TSortEng_"</TD><TD width=5% style='white-space:normal; word-break:break-all;'>"_TAuditEng_"</TD><TD width=5% style='white-space:normal; word-break:break-all;'>"_TMergerEng_"</TD><TD width=5% style='white-space:normal; word-break:break-all;'>"_TOperateEng_"</TD><TD width=30% style='white-space:normal; word-break:break-all;'>"_TConclusionEng_"</TD><TD width=50%>"_TAdviceEng_"</TD></TR>"
    e  w "<TR align='center' bgcolor='' style='white-space:normal; word-break:break-all;'><TD width=5% style='white-space:normal; word-break:break-all;'>"_TSortEng_"</TD><TD width=5% style='white-space:normal; word-break:break-all;'>"_TMergerEng_"</TD><TD width=5% style='white-space:normal; word-break:break-all;'>"_TOperateEng_"</TD><TD width=30% style='white-space:normal; word-break:break-all;'>"_TConclusionEng_"</TD><TD width=50%>"_TAdviceEng_"</TD></TR>"
    s i=0
    s STSort=""
    f  s STSort=$O(^TempDHCPEResultDiagnosis(Job,STSort)) q:STSort=""  d
    .s STID=""
    .f  s STID=$O(^TempDHCPEResultDiagnosis(Job,STSort,STID)) q:STID=""  d
    ..s Sort=""
    ..f  s Sort=$O(^TempDHCPEResultDiagnosis(Job,STSort,STID,Sort)) q:Sort=""  d
    ...s GSDID=""
    ...f  s GSDID=$O(^TempDHCPEResultDiagnosis(Job,STSort,STID,Sort,GSDID)) q:GSDID=""  d
    ....s Info=$G(^TempDHCPEResultDiagnosis(Job,STSort,STID,Sort,GSDID))
    ....s GSDID=$P(Info,"^",4)
    ....s i=i+1
    ....w "<TR bgcolor='' style='white-space:normal; word-break:break-all;'>"
    ....w "<TD width=5% style='white-space:normal; word-break:break-all;'>"_i_"</TD>"
    ....i MainDoctor="Y" d
    .....w "<TD width=5% style='white-space:normal; word-break:break-all;'>" 
    .....s CheckInfo="<input name='SelectAdvice' type='checkbox' id="_GSDID_"^MD"
    .....s:$P(Info,"^",3)="1" CheckInfo=CheckInfo_" checked"
    .....//初检权限或者已复检不允许修改复检标志
    .....s:(MainDoctor'="Y") CheckInfo=CheckInfo_" disabled='disabled'"
    .....s CheckInfo=CheckInfo_">"
    .....w CheckInfo
    .....w "</TD>"
    ....w "<TD style='white-space:normal; word-break:break-all;'><input type='checkbox' name='Unite' id='"_GSDID_"^HB'></TD>"
    ....w "<TD style='white-space:normal; word-break:break-all;'><button id='"_GSDID_"' name='DeleteButton' onclick='DeleteAdvice(this,1)' class='hisui-linkbutton' plain=true iconCls='icon-cancel'></button></TD>"
    ....w "<TD style='white-space:normal; word-break:break-all;'><textarea onpropertychange='setTareaAutoHeight(this)' style='width:98%;white-space:normal; word-break:break-all;' id='"_GSDID_"^JL'>"_$P(Info,"^",1)_"</textarea></TD>"
    ....w "<TD style='white-space:normal; word-break:break-all;'><textarea onpropertychange='setTareaAutoHeight(this)' style='width:98%;white-space:normal; word-break:break-all;' id='"_GSDID_"^JY'>"_$P(Info,"^",2)_"</textarea></TD>"
    
    ....w "</TR>"
    w "</TABLE>"
    w:DivFlag="Y" "</div>"
    k ^TempDHCPEResultDiagnosis(Job)
    q
}

ClassMethod OutAdviceToHtml(GSID, StationID, MainDoctor, DivFlag As %String = "N")
{
    s Job=$J
    s Sort=0
    s AuditUser=$P(^DHCPEGS(GSID,1),"^",5)
    s SortFlag=$G(^DHCPEGS(GSID,"SortFlag"))
    f  s Sort=$o(^DHCPEGS(0,"GSDSort",GSID,Sort)) q:Sort=""  d
    .s gSub=0
    .f  s gSub=$o(^DHCPEGS(0,"GSDSort",GSID,Sort,gSub)) q:gSub=""  d
    ..;q:'$D(^DHCPEDataEx("DHCPEGeneralSummarize","ReCheckDetail",GSID_"||"_gSub))&&(MainDoctorFlag="Y")
    ..s Flag=0
    ..s:$D(^DHCPEDataEx("DHCPEGeneralSummarize","ReCheckDetail",GSID_"||"_gSub)) Flag=1
    ..s Status=$p(^DHCPEGS(GSID,"Diagnosis",gSub),"^",11)
    ..q:Status'="0"
    ..s EDID=$p(^DHCPEGS(GSID,"Diagnosis",gSub),"^",1)
    ..q:EDID=""
    ..s EDDesc=$p(^DHCPEGS(GSID,"Diagnosis",gSub),"^",9)
    ..;s EDDesc=##class(web.DHCPE.ReportGetInfor).ReplaceXH(EDDesc)
    ..s DiagnoseConclusion=$p($g(^DHCPEED(EDID,"1")),"^",1)
    ..s CurSTID=$p($g(^DHCPEED(EDID,"1")),"^",7)
    ..s CurSTLocID=$p($g(^DHCPEED(EDID,"1")),"^",10)
    ..s:CurSTLocID'="" CurSTID=CurSTLocID
    ..q:(StationID'="")&&(StationID'=CurSTID)
    ..s CurSTSort=$P($G(^DHCPEST(CurSTID)),"^",4)
    ..s:CurSTSort="" CurSTSort="999999"
    ..s GSDRowId=GSID_"||"_gSub
    ..i $d(^DHCPEDataEx("DHCPEGSDiagnosis","DisplayDesc",GSDRowId))'=0 d
    ...s DiagnoseConclusion=$g(^DHCPEDataEx("DHCPEGSDiagnosis","DisplayDesc",GSDRowId))
    ..s ^TempDHCPEResultDiagnosis(Job,1,1,Sort,GSDRowId)=DiagnoseConclusion_"^"_EDDesc_"^"_Flag_"^"_GSDRowId
    /*
    ..i SortFlag="Y" d
    ...s ^TempDHCPEResultDiagnosis(Job,1,1,Sort,GSDRowId)=DiagnoseConclusion_"^"_EDDesc_"^"_Flag_"^"_GSDRowId
    ..e  d
    ...s ^TempDHCPEResultDiagnosis(Job,CurSTSort,CurSTID,Sort,GSDRowId)=DiagnoseConclusion_"^"_EDDesc_"^"_Flag_"^"_GSDRowId
    */
    w "<TABLE border=0 cellspacing='0' cellpadding='0' width=100% height=10% style='white-space:normal; word-break:break-all;'>"
    w "<tr></tr>"
    w "<tr> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color=red>注: 拖动建议可进行任意排序</font></tr>"
    w "<tr></tr>"

    w "<TR bgcolor='' border=1 style='white-space:normal; word-break:break-all;'>"
    
    w:DivFlag="N" "<td><button onclick='SaveAdvice()' class='i-btn'>确定</button></td>"
    w:DivFlag="N" "<td><button id='CancelAdvice' onclick='CancelAdvice()' class='i-btn'>关闭</button></td>"
    w:DivFlag="N" "<td><button id='UnitRecord' onclick='UnitRecord()' class='i-btn'>合并记录</button></td>"
    
    s SAHidden=""
    s:(MainDoctor'="Y") SAHidden="style='display:none;'"

    w "</TR>"
    w "<TR align='center' bgcolor='' style='white-space:normal; word-break:break-all;'><TD width=5% style='white-space:normal; word-break:break-all;'><button onclick=SetSort() class='i-btn'>按级别、站点排序</button></TD><TD id='AllSelectAdvice'"_SAHidden_" width=5% style='cursor:hand;white-space:normal; word-break:break-all;'><button onclick= AllSelectAdvice() class='i-btn'>审核</button></TD><TD id='UniteAdvice' width=5% style='white-space:normal; word-break:break-all;'><button onclick='UniteAdvice()' class='i-btn'>合并</button></TD><TD width=35% style='white-space:normal; word-break:break-all;'>结论</TD><TD style='white-space:normal; word-break:break-all;'>建议</TD><TD width=5%>删除</TD></TR>"

    w "</TABLE>"
    w:DivFlag="Y" "<div style='overflow-y:auto;width:100%;height:90%'>"
    w "<TABLE id='EditAdvice' border=0 cellspacing='0' cellpadding='0' width=100% style='white-space:normal; word-break:break-all;'>"
 
    s i=0
    s STSort=""
    f  s STSort=$O(^TempDHCPEResultDiagnosis(Job,STSort)) q:STSort=""  d
    .s STID=""
    .f  s STID=$O(^TempDHCPEResultDiagnosis(Job,STSort,STID)) q:STID=""  d
    ..s Sort=""
    ..f  s Sort=$O(^TempDHCPEResultDiagnosis(Job,STSort,STID,Sort)) q:Sort=""  d
    ...s GSDID=""
    ...f  s GSDID=$O(^TempDHCPEResultDiagnosis(Job,STSort,STID,Sort,GSDID)) q:GSDID=""  d
    ....s Info=$G(^TempDHCPEResultDiagnosis(Job,STSort,STID,Sort,GSDID))
    ....s GSDID=$P(Info,"^",4)
    ....s i=i+1
    ....w "<TR bgcolor='' style='white-space:normal; word-break:break-all;'>"
    ....w "<TD width=5% style='white-space:normal; word-break:break-all;'>"_i_"</TD>"
    ....w "<TD width=5% style='white-space:normal; word-break:break-all;'>" //<check>"_$P(Info,"^",3)_"</TD>
    ....s CheckInfo="<input name='SelectAdvice' type='checkbox' id="_GSDID_"^MD"
    ....s:$P(Info,"^",3)="1" CheckInfo=CheckInfo_" checked"
    ....//初检权限或者已复检不允许修改复检标志
    ....s:(MainDoctor'="Y") CheckInfo=CheckInfo_" disabled='disabled'"
    ....s CheckInfo=CheckInfo_">"
    ....w CheckInfo
    ....w "</TD>"
    ....w "<TD style='white-space:normal; word-break:break-all;'><input type='checkbox' name='Unite' id='"_GSDID_"^HB'></TD>"
    
    ....w "<TD style='white-space:normal; word-break:break-all;'><textarea onpropertychange='setTareaAutoHeight(this)' style='width:100%;white-space:normal; word-break:break-all;' id='"_GSDID_"^JL'>"_$P(Info,"^",1)_"</textarea></TD>"
    ....w "<TD style='white-space:normal; word-break:break-all;'><textarea onpropertychange='setTareaAutoHeight(this)' style='width:100%;white-space:normal; word-break:break-all;' id='"_GSDID_"^JY'>"_$P(Info,"^",2)_"</textarea></TD>"
    ....w "<TD style='white-space:normal; word-break:break-all;'><button onclick='DeleteAdvice(this,1)' name='DeleteButton' id='"_GSDID_"'><font color=red>×</font></button></TD>"
    ....w "</TR>"
    w "</TABLE>"
    w:DivFlag="Y" "</div>"
    k ^TempDHCPEResultDiagnosis(Job)
    q
}

/// debug:d ##class(web.DHCPE.ResultDiagnosisNew).GetAdviceInfoByStation()
ClassMethod GetAdviceInfoByStation(GSID, OEID, MainDoctorFlag, StationFlag As %String = "N")
{
    s Job=$J
    s ret=""
    q:OEID="" ret
    i StationFlag="N" d
    .s ArcimID=$P($g(^OEORD(+OEID,"I",$P(OEID,"||",2),1)),"^",2)
    .q:ArcimID=""
    .s PAADM=$p($g(^OEORD(+OEID)),"^",1)
    .s LocID=$p($g(^PAADM(PAADM)),"^",4)
    .;s STID=$O(^DHCPEST(0,"STORD_ARCIM",ArcimID,0))
    .s StatOrder=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ArcimID, LocID)
    .s STID=$p(StatOrder,"||",1)
    .s LocInfo=##class(web.DHCPE.CT.HISUICommon).GetStatCatIDBySTOrderID(StatOrder, LocID)
    .;s LocInfo=$G(^DHCPEStationOrder("Loc",ArcimID))
    .i LocInfo'="" d
    ..s STID=$P(LocInfo,"^",1)
    e  d
    .s STID=OEID
    s ret=..GetAdviceInfoHISUI(GSID,STID,MainDoctorFlag,Job)
    k ^TempDHCPEResultDiagnosisNewAdvice(Job)
    q STID_$C(1)_ret
}

/// Description: 建议关键字颜色显示
/// Debug: w ##class(web.DHCPE.ResultDiagnosisNew).ReplaceKey()
ClassMethod ReplaceKey(EDDesc, LocID)
{
    s ID=0
    f  s ID=$O(^User.DHCPEEDKeyD(ID)) q:ID=""  d
    .s Desc=$LG(^User.DHCPEEDKeyD(ID),2)
    .s Color=$LG(^User.DHCPEEDKeyD(ID),3)
    .s LocShowDFlag=##class(User.DHCPEEDKey).GetLocShowDataFlag(ID,LocID)
    .i LocShowDFlag="Y" d
    ..s ReplaceDesc="<font color="_Color_">"_Desc_"</font>"
    ..s EDDesc=##class(web.DHCPE.Public.Setting).Replace(EDDesc,Desc,ReplaceDesc)
    q EDDesc
}

// 生成总的建议信息

ClassMethod CreateGSSDetail(GSID, MainDoctor As %String = "N", LocID As %String = "")
{
    ;w ##class(web.DHCPE.ResultDiagnosisNew).CreateGSSDetail(1007)
    s Job=$J
    s AuditUser=$P(^DHCPEGS(GSID,1),"^",5)
    s IADM=$P($g(^DHCPEGS(GSID,1)),"^",1)
    i IADM'="" d
    .S PAADM=$p($g(^DHCPEIADM(IADM)),"^",1)
    .s LocID=$P($g(^PAADM(PAADM)),"^",4)


    s VIPFlag=0
    s VIPLevel=##class(web.DHCPE.PreCommon).GetVIPLevel("IADM",IADM)
    s:VIPLevel["VIP" VIPFlag=1
    /*
    i (MainDoctor="Y")&&(VIPFlag=0)
    {
        d ##class(web.DHCPE.MainDiagnosisNew).SetSort(GSID)
    }
    */
    
    d ##class(web.DHCPE.MainDiagnosisNew).SetSort(GSID,1)
    
    /// 增加global 用于诊断建议的分开
    k ^DHCPEDataEx(GSID,"GSumDisplay")
    s SplitSummary="N"
    s:LocID'="" SplitSummary=$g(^DHCPESetting("DHCPE","SplitSummary",LocID))

    s Sort=0
    f  s Sort=$o(^DHCPEGS(0,"GSDSort",GSID,Sort)) q:Sort=""  d
    .s gSub=0
    .f  s gSub=$o(^DHCPEGS(0,"GSDSort",GSID,Sort,gSub)) q:gSub=""  d
    ..;q:'$D(^DHCPEDataEx("DHCPEGeneralSummarize","ReCheckDetail",GSID_"||"_gSub))&&(MainDoctorFlag="Y")
    ..s Flag=0
    ..s:$D(^DHCPEDataEx("DHCPEGeneralSummarize","ReCheckDetail",GSID_"||"_gSub)) Flag=1
    ..s Status=$p(^DHCPEGS(GSID,"Diagnosis",gSub),"^",11)
    ..q:Status'="0"
    ..s EDID=$p(^DHCPEGS(GSID,"Diagnosis",gSub),"^",1)
    ..q:EDID=""
    ..s EDDesc=$p(^DHCPEGS(GSID,"Diagnosis",gSub),"^",9)
    ..
    ..// 增加乙肝标志 add
    ..s YGFlag=$p(^DHCPEGS(GSID,"Diagnosis",gSub),"^",12)
    ..// 增加乙肝标志 end
    ..
    ..;s EDDesc=##class(web.DHCPE.ReportGetInfor).ReplaceXH(EDDesc)
    ..q:(MainDoctor="Y")&&('$D(^DHCPEDataEx("DHCPEGeneralSummarize","ReCheckDetail",GSID_"||"_gSub)))
    ..s DiagnoseConclusion=$p($g(^DHCPEED(EDID,"1")),"^",1)
    ..s CurSTID=$p($g(^DHCPEED(EDID,"1")),"^",7)
    ..s CurSTLocID=$p($g(^DHCPEED(EDID,"1")),"^",10)
    ..s CurSTLocSort="999999999"
    ..s:CurSTLocID'="" CurSTLocSort=$P($G(^DHCPEST(+CurSTLocID,"STLOC",$P(CurSTLocID,"||",2))),"^",2)
    ..s:CurSTLocID="" CurSTLocSort="999999999"
    ..s CurSTSort=$P($G(^DHCPEST(CurSTID)),"^",4)
    ..s:CurSTSort="" CurSTSort="999999"
    ..s GSDRowId=GSID_"||"_gSub
    ..i $d(^DHCPEDataEx("DHCPEGSDiagnosis","DisplayDesc",GSDRowId))'=0 d
    ...s DiagnoseConclusion=$g(^DHCPEDataEx("DHCPEGSDiagnosis","DisplayDesc",GSDRowId))
    ..s DiagnoseConclusion=##class(web.DHCPE.Public.Setting).Replace(DiagnoseConclusion,"]"_$C(13,10)_"[","]"_$C(13)_"       [")
    ..//i (AuditUser'="")&&((VIPFlag=1)||(MainDoctor="Y")) d
    ..//s ^TempDHCPEResultDiagnosis(Job,1,1,1,Sort,GSDRowId)=DiagnoseConclusion_"^"_EDDesc_"^"_Flag_"^"_GSDRowId
    ..//e  d
    ..//s ^TempDHCPEResultDiagnosis(Job,CurSTSort,CurSTID,CurSTLocSort,Sort,GSDRowId)=DiagnoseConclusion_"^"_EDDesc_"^"_Flag_"^"_GSDRowId
    ..// 修改乙肝标志 mod
    ..s ^TempDHCPEResultDiagnosis(Job,1,1,1,Sort,GSDRowId)=DiagnoseConclusion_"^"_EDDesc_"^"_Flag_"^"_GSDRowId_"^"_YGFlag
    ..// 修改乙肝标志 end
    
    // 修改乙肝标志 mod
    s YGItemFlag=##class(web.DHCPE.ResultDiagnosis).GetYGItemFlag(GSID,"GSID")
    // 修改乙肝标志 end
    
    s ret="",YGret=""
    s i=0,j=0,k=0
    s STSort=""
    f  s STSort=$O(^TempDHCPEResultDiagnosis(Job,STSort)) q:STSort=""  d
    .s STID=""
    .f  s STID=$O(^TempDHCPEResultDiagnosis(Job,STSort,STID)) q:STID=""  d
    ..s STLocSort=""
    ..f  s STLocSort=$O(^TempDHCPEResultDiagnosis(Job,STSort,STID,STLocSort)) q:STLocSort=""  d
    ...s Sort=""
    ...f  s Sort=$O(^TempDHCPEResultDiagnosis(Job,STSort,STID,STLocSort,Sort)) q:Sort=""  d
    ....s GSDID=""
    ....f  s GSDID=$O(^TempDHCPEResultDiagnosis(Job,STSort,STID,STLocSort,Sort,GSDID)) q:GSDID=""  d
    .....s Info=$G(^TempDHCPEResultDiagnosis(Job,STSort,STID,STLocSort,Sort,GSDID))
    .....s GSDID=$P(Info,"^",4)
    .....s i=i+1
    .....i (MainDoctor'="Y")&&(VIPFlag=0) d
    ......&SQL(Update Sqluser.DHC_PE_GSDiagnosis Set GSD_Sort=:i where GSD_RowID=:GSDID)
    .....
    .....// 修改乙肝标志 mod
    .....i ((YGItemFlag="3")&&($P(Info,"^",5)="Y")) d
    ......s k=k+1
    ......i k<10 s Index=" "_k
    ......e  s Index=k
    
    ....../// 增加global 用于诊断建议的分开
    ......s:SplitSummary="Y" ^DHCPEDataEx(GSID,"GSumDisplay",k,"YGDiagnosis")=$P(Info,"^",1) // 乙肝诊断
    ......s:SplitSummary="Y" ^DHCPEDataEx(GSID,"GSumDisplay",k,"YGAdvice")=$P(Info,"^",2) // 乙肝建议

    .....e  d
    ......s j=j+1
    ......i j<10 s Index=" "_j
    ......e  s Index=j
    
    ....../// 增加global 用于诊断建议的分开
    ......s:SplitSummary="Y" ^DHCPEDataEx(GSID,"GSumDisplay",j,"GSDiagnosis")=$P(Info,"^",1) // 诊断
    ......s:SplitSummary="Y" ^DHCPEDataEx(GSID,"GSumDisplay",j,"GSAdvice")=$P(Info,"^",2) // 建议

    .....
    .....;i i<10 d
    .....;.s Index=" "_i
    .....;e  d
    .....;.s Index=i
    .....;i $P(Info,"^",1)'["[" s $P(Info,"^",1)="["_$P(Info,"^",1)_"]"
    .....;i $g(^DHCPESetting("DHCPE","ShowEDDiagnosisSign"))="Y" d
    .....i $g(^DHCPESetting("DHCPE","ShowEDDiagnosisSign",LocID))="Y" d
    ......i $P(Info,"^",1)'["[" s $P(Info,"^",1)="["_$P(Info,"^",1)_"]"
    .....s OneInfo=Index_"、"_$P(Info,"^",1)_""_$C(13,10)_"       "_$P(Info,"^",2)
    .....
    .....i ((YGItemFlag="3")&&($P(Info,"^",5)="Y")) d
    ......i YGret="" d
    .......s YGret=OneInfo
    ......e  d
    .......s YGret=YGret_$C(13,10)_$C(13,10)_OneInfo
    .....e  d
    ......i ret="" d
    .......s ret=OneInfo
    ......e  d
    .......s ret=ret_$C(13,10)_$C(13,10)_OneInfo
    .....// 修改乙肝标志 end
    
    ;s ret=##class(web.DHCPE.Public.Setting).Replace(ret,$C(13)_$C(13),$C(13))
    ;s ret=##class(web.DHCPE.Public.Setting).Replace(ret,$C(13),$C(13)_"       ")
    k ^TempDHCPEResultDiagnosis(Job)
    s ID=$O(^User.DHCPEGSSumI("IndexParref",GSID,0))
    i ID="" d
    .s obj=##class(User.DHCPEGSSum).%New()
    .d obj.GSSParrefSetObjectId(GSID)
    e  d
    .s obj=##class(User.DHCPEGSSum).%OpenId(ID)
    s Stream=##class(%Stream.GlobalCharacter).%New()
    d Stream.Write(ret)
    i (ret="")&&(MainDoctor="Y") d
    .
    e  s obj.GSSDetail=Stream
    
    // 增加乙肝标志 add
    s YGStream=##class(%Stream.GlobalCharacter).%New()
    d YGStream.Write(YGret)
    s obj.GSSYGDetail=YGStream
    // 增加乙肝标志 end
    
    s sc=obj.%Save()
    d obj.%Close()
    If ($System.Status.IsError(sc)) 
    {
        q "-1^"_$System.Status.GetErrorText(sc)
    }else{
        q obj.%Id()
    }
    //q ret
}

ClassMethod UpdateGSSDetail(GSID, GSSDetail, GSSYGDetail As %String = "")
{
    ;w ##class(web.DHCPE.ResultDiagnosisNew).UpdateGSSDetail(1007,"aaa")
    s ID=$O(^User.DHCPEGSSumI("IndexParref",GSID,0))
    q:ID="" ""
    s obj=##class(User.DHCPEGSSum).%OpenId(ID)
    s Stream=##class(%Stream.GlobalCharacter).%New()
    b ;Stream
    d Stream.Write(GSSDetail)
    s obj.GSSDetail=Stream
    
    s YGStream=##class(%Stream.GlobalCharacter).%New()
    b ;Stream
    d YGStream.Write(GSSYGDetail)
    s obj.GSSYGDetail=YGStream
    
    s sc=obj.%Save()
    d obj.%Close()
    If ($System.Status.IsError(sc)) 
    {
        q "-1^"_$System.Status.GetErrorText(sc)
    }else{
        q obj.%Id()
    }
}

ClassMethod OutGSSDetail1(GSID, ButtonFlag As %String = "1")
{
    s ret=""
    s ID=$O(^User.DHCPEGSSumI("IndexParref",GSID,0))
    i ID'="" d
    .s obj=##class(User.DHCPEGSSum).%OpenId(ID)
    .s Stream=obj.GSSDetail
    .s len=Stream.SizeGet()
    .d Stream.Rewind()
    .s ret=Stream.Read(len)
    //s ret=##class(web.DHCPE.Public.Setting).Replace(ret,"&nbsp;"," ")
    q ret
}

ClassMethod OutGSSDetailHISUI(GSID, ButtonFlag As %String = "1", MainDoctor As %String = "Y")
{
    
    if $d(%session) {
        set langId=%session.Get("LOGON.LANGID")
    }
    else
    { s langId=""}
    
    
    S PAAdmRowid=$p($g(^DHCPEGS(GSID,1)),"^",8)
    s CurLoc=$P($G(^PAADM(PAAdmRowid)),"^",4)
    
    s GroupID=%session.Get("LOGON.GROUPID")
    i CurLoc="" s CurLoc=%session.Get("LOGON.CTLOCID")
    //s:GroupID=$G(^DHCPESetting("DHCPE","SuperGroup")) ButtonFlag="1"
    s:GroupID=$G(^DHCPESetting("DHCPE","SuperGroup",CurLoc)) ButtonFlag="1"

    s SplitSummary=$g(^DHCPESetting("DHCPE","SplitSummary",CurLoc))  // 结论建议分开
    s NeedReCheck=$G(^DHCPESetting("DHCPE","MainDoctorGroup",CurLoc)) //该科室是否需求复检
    S PAAdmRowid=$p($g(^DHCPEGS(GSID,1)),"^",8)
    s csdisabled="",color="",bgcolor=""
    //if ((MainDoctor="N")&&(NeedReCheck="Y")){
    if ((MainDoctor="N")&&(NeedReCheck="Y"))||(SplitSummary="Y") {
         s csdisabled="readonly='readonly'"
         s color="color: #999999;"
         s bgcolor="background-color: #f7f7f7;"
    }
    
    s YGItemFlag=##class(web.DHCPE.ResultDiagnosis).GetYGItemFlag(GSID,"GSID")
    if (YGItemFlag="3") {
        w "<div class='hisui-layout' fit='true'>"
        
        w "<div id='GSSDetailDIV' data-options='region:""north"",headerCls:""panel-header-gray"",border:false' style='height:200px;padding:0 10px 0 0;'>"
        w "<div class='hisui-panel' fit='true' title='结论建议' style='padding-top:10px; overflow-x:hidden; overflow-y:hidden;"_bgcolor_"' data-options='headerCls:""panel-header-card-gray""'>"
        
        w "<textarea id='GSSDetail' onkeydown=GSSDetailKeyDown() style='FONT-SIZE: 14px; TEXT-ALIGN: LIFT; width:100%; height:100%; border:none; overflow:auto; padding-right:unset;"_color_bgcolor_"' "_csdisabled_">"
        s ID=$O(^User.DHCPEGSSumI("IndexParref",GSID,0))
        
        i ID'="" d
        .s obj=##class(User.DHCPEGSSum).%OpenId(ID)
        .s Stream=obj.GSSDetail
        .s len=Stream.SizeGet()
        .d Stream.Rewind()
        .w ##class(websys.Translation).Get("dhcpenewgssdetail.hisui.csp",Stream.Read(len),langId)
        w "</textarea>"
        
        w "</div>"
        w "</div>"
        
        w "<div data-options='region:""center"",headerCls:""panel-header-gray"",border:false' style='height:200px;padding:0 10px 0 0;'>"
        w "<div class='hisui-panel' fit='true' title='乙肝建议' style='padding-top:10px; overflow-x:hidden; overflow-y:hidden;"_bgcolor_"' data-options='headerCls:""panel-header-card-gray""'>"
         
        w "<textarea id='YGGSSDetail' onkeydown=GSSDetailKeyDown() style='FONT-SIZE: 14px; TEXT-ALIGN: LIFT; width:100%; height:100%; border:none; overflow:auto; padding-right:unset;"_color_bgcolor_"' "_csdisabled_">"
        s ID=$O(^User.DHCPEGSSumI("IndexParref",GSID,0))
        
        i ID'="" d
        .s obj=##class(User.DHCPEGSSum).%OpenId(ID)
        .s YGStream=obj.GSSYGDetail
        .s len=YGStream.SizeGet()
        .d YGStream.Rewind()
        .w ##class(websys.Translation).Get("dhcpenewgssdetail.hisui.csp",YGStream.Read(len),langId)
        w "</textarea>"
        
        w "</div>"
        w "</div>"
        
        w "<div id='GSSDetailBTN' data-options='region:""south"",headerCls:""panel-header-gray"",border:false' style='height:30px; text-align:center; margin:0 auto;'>"
        w "<button id='OK' name='OK' class='hisui-linkbutton' iconCls='icon-w-ok'>确定</button>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<button id='Cancel' name='Cancel' class='hisui-linkbutton' iconCls='icon-w-close' onclick=Close()>取消</button>"
        w "</div>"
        
        w "</div>"
    } else {
        /*
        w "<div style='overflow-y:auto;width:100%;height:100%'>"
        w "<TABLE width=100% border=0 style='white-space:normal; word-break:break-all;'>"
        w "<TR><TD valign='top' align='center'>"
        w "<textarea id='GSSDetail' onkeydown=GSSDetailKeyDown() style='FONT-SIZE: 14px; TEXT-ALIGN: LIFT;width:640px;height:490px;' "_csdisabled_">"
        s ID=$O(^User.DHCPEGSSumI("IndexParref",GSID,0))
        
        i ID'="" d
        .s obj=##class(User.DHCPEGSSum).%OpenId(ID)
        .s Stream=obj.GSSDetail
        .s len=Stream.SizeGet()
        .d Stream.Rewind()
        .w Stream.Read(len)
        w "</textarea></TD></TR>"
        w "<TR style='height:10px;'></TR>"
        w:ButtonFlag=1 "<TR height=20><TD><button id='OK' name='OK' class='hisui-linkbutton' iconCls='icon-ok'>确定</button>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<button id='Cancel' name='Cancel' class='hisui-linkbutton' iconCls='icon-cancel' onclick=Close()>取消</button></TD></TR>"
        
            
        w "</TABLE>"
        w "</div>"
        */
         w "<div class='hisui-layout' fit='true'>"
         w "<div id='GSSDetailDIV' data-options='region:""north"",headerCls:""panel-header-gray"",border:false' style='height:450px;;padding:0 10px 0 0;'>"
         w "<div class='hisui-panel' fit='true' title='结论建议' style='padding-top:10px; overflow-x:hidden; overflow-y:hidden;"_bgcolor_"' data-options='headerCls:""panel-header-card-gray""'>"
         w "<textarea id='GSSDetail' onkeydown=GSSDetailKeyDown() style='FONT-SIZE: 14px; TEXT-ALIGN: LIFT; width:100%; height:95%; border:none; overflow:auto; padding-right:unset;"_color_bgcolor_"' "_csdisabled_">"
     
        s ID=$O(^User.DHCPEGSSumI("IndexParref",GSID,0))
        i ID'="" d
        .s obj=##class(User.DHCPEGSSum).%OpenId(ID)
        .s Stream=obj.GSSDetail
        .s len=Stream.SizeGet()
        .d Stream.Rewind()
        .w ##class(websys.Translation).Get("dhcpenewgssdetail.hisui.csp",Stream.Read(len),langId)
        w "</textarea>"
        w "</div>"
        w "</div>"
        w "<div id='GSSDetailBTN' data-options='region:""south"",headerCls:""panel-header-gray"",border:false' style='height:30px; text-align:center; margin:0 auto;'>"
        w "<button id='OK' name='OK' class='hisui-linkbutton' iconCls='icon-w-ok'>确定</button>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<button id='Cancel' name='Cancel' class='hisui-linkbutton' iconCls='icon-w-close' onclick=Close()>取消</button>"
        w "</div>"
        w "</div>"

    }
}

ClassMethod OutGSSDetail(GSID, ButtonFlag As %String = "1")
{
    ;w ##class(web.DHCPE.ResultDiagnosisNew).OutGSSDetail(133)
     S PAAdmRowid=$p($g(^DHCPEGS(GSID,1)),"^",8)
    s CurLoc=$P($G(^PAADM(PAAdmRowid)),"^",4)
    s GroupID=%session.Get("LOGON.GROUPID")
    //s:GroupID=$G(^DHCPESetting("DHCPE","SuperGroup")) ButtonFlag="1"
   s:GroupID=$G(^DHCPESetting("DHCPE","SuperGroup",CurLoc)) ButtonFlag="1"


    w "<div style='overflow-y:auto;width:100%;height:100%'>"
    w "<TABLE width=100% style='white-space:normal; word-break:break-all;'>"
    w "<TR><TD valign='top' align='center'>"
    w "<textarea id='GSSDetail' onkeydown=GSSDetailKeyDown() style='FONT-SIZE: 14px; TEXT-ALIGN: LIFT;width:665;height:100%;'>"
    s ID=$O(^User.DHCPEGSSumI("IndexParref",GSID,0))
    i ID'="" d
    .s obj=##class(User.DHCPEGSSum).%OpenId(ID)
    .s Stream=obj.GSSDetail
    .s len=Stream.SizeGet()
    .d Stream.Rewind()
    .w Stream.Read(len)
    w "</textarea></TD></TR>"
    w:ButtonFlag=1 "<TR height=20><TD><button id='OK' name='OK' style='width:8%'>确定</button><button id='Cancel' name='Cancel' onclick=Close() style='width:8%'>取消</button></TD></TR>"
    
    ;w "<TR height=20><TD><button id='OK' onclick=SaveGSSDetail() style='width:8%'>确定</button><button onclick=Close() style='width:8%'>取消</button></TD></TR>"
    
    w "</TABLE>"
    w "</div>"
}

ClassMethod GetStatus(PAADM)
{
    q:PAADM="" ""
    s MainInfo=$G(^DHCPEDataEx("DHCPEGeneralSummarize","MainDoctor",PAADM))
    s MainUser=$P(MainInfo,"^",1)
    q:MainUser'="" 2 ;已复审
    s GSID=##class(web.DHCPE.ResultDiagnosis).GetSSId(PAADM)
    q:GSID="" "" ;没有小结
    s AuditUser=$P($G(^DHCPEGS(GSID,1)),"^",5)
    q:AuditUser'="" 1 ;初审
    q 0
}

ClassMethod AutoSumResult(PAADM)
{
    
    ;d ##class(web.DHCPE.ResultDiagnosisNew).AutoSumResult()
    q:PAADM="" ""
    s GSID=##class(web.DHCPE.ResultDiagnosis).GetSSId(PAADM)
    q:GSID="" ""
    q ""
    //q:GSID<2470 ""
    s AuditUser=$P(^DHCPEGS(GSID,1),"^",5)
    q:AuditUser'="" ""
    q ##class(web.DHCPE.ResultDiagnosis).UpdateStationS(PAADM,0,"")
}

/// Description: 总检提交时获取未检的项目
/// Input:       EpisodeID:就诊ID 
/// debug:  w ##class(web.DHCPE.ResultDiagnosisNew).GetNoResultItem(4186930)
ClassMethod GetNoResultItem(EpisodeID)
{
    q:EpisodeID="" ""
    
    s LocID=$P($G(^PAADM(EpisodeID)),"^",4)
    s OtherStation=$g(^DHCPESetting("DHCPE","StationId_Other",LocID))
    s MedicalStation=$g(^DHCPESetting("DHCPE","StationId_Medical",LocID))
    s IDs=""
    s Descs=""
   
    s PEIAdmId=$o(^DHCPEIADM(0,"PAADM",EpisodeID,""))
    s OEOrder=$O(^OEORD(0,"Adm",EpisodeID,0))
    
    s OEOrdItem=0
    f  s OEOrdItem=$O(^OEORD(OEOrder,"I",OEOrdItem))  q:(OEOrdItem="")  d
    .s ORIStat=$p($g(^OEORD(OEOrder,"I",OEOrdItem,1)),"^",13)
    .q:ORIStat=4
    .s OEORIRowId=OEOrder_"||"_OEOrdItem
    .s CRMOId=$o(^DHCPECRMO(0,"OEORI",OEORIRowId,0))
    .q:CRMOId=""
    .s CRMOrI=$p($g(^DHCPECRMO(CRMOId)),"^",2)
    .q:CRMOrI=""
    .s ItemMastId=$p($G(^DHCPEPreIADM($p(CRMOrI,"||",1),"ORDITEM",$p(CRMOrI,"||",2))),"^",1)
    .q:ItemMastId=""
    .q:$D(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OEORIRowId)) //过滤谢绝检查的项目
    ./***延期项目处理 start***/
    .s YAFlag=0
    .s YQID=$o(^User.DHCPEDelayRecordI("OEORIIndex"," "_OEORIRowId,0))
    .i YQID'="" d
    ..s DRNoGenFlag=$lg(^User.DHCPEDelayRecordD(YQID),4)  //延期的有效标记
    ..s DRIfComplateAll=$lg(^User.DHCPEDelayRecordD(YQID),6) //是否全部做完再总检  
    ..i ((DRNoGenFlag="Y")&&(DRIfComplateAll="N"))  s YAFlag=1
    .q:YAFlag=1
    ./***延期项目处理 end***/
    .s Station=0
    .;s Station=$o(^DHCPEST(0,"STORD_ARCIM",ItemMastId,Station))
    .s StatOrderID=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ItemMastId,LocID) 
    .q:StatOrderID=""
    .s Station=$p(StatOrderID,"||",1)
    .q:Station=""
    .q:OtherStation=Station    //过滤其他站点
    .q:Station=MedicalStation  //过滤药品站点
    .q:$D(^DHCPERLT(0,"ADMOD", EpisodeID, OEORIRowId))
    .s Desc=##class(web.DHCPE.DHCPECommon).GetArcDesc(ItemMastId,"A",LocID)
    .i IDs'="" d
    ..s IDs=IDs_"^"_OEORIRowId
    ..s Descs=Descs_"^"_Desc
    .e  d
    ..s IDs=OEORIRowId
    ..s Descs=Desc
    i IDs'="" q IDs_$C(1)_Descs
    q ""
}

ClassMethod RefuseItems(IDs)
{
    s ItemLength=$L(IDs,"^")
    for i=1:1:ItemLength d
    .s OrderID=$P(IDs,"^",i)
    .d ##class(web.DHCPE.ResultEdit).RefuseCheck(OrderID)
    q 0
}

/// 根据paadm获取哪些项目不存在体检站点中
ClassMethod GetNoHPItem(PAADM) As %String
{
    s Ret=""
    k ^TempDHCPENoHPItem(PAADM)
    s OEOrder=$O(^OEORD(0,"Adm",PAADM,0))
    s OEOrdItem=0
    f  s OEOrdItem=$O(^OEORD(OEOrder,"I",OEOrdItem))  q:(OEOrdItem="")  d
    .s ARCIMID=$p($G(^OEORD(OEOrder,"I",OEOrdItem,1)),"^",2)
    .q:ARCIMID=""
    .s ORIStat=$p($G(^OEORD(OEOrder,"I",OEOrdItem,1)),"^",13)
    .q:ORIStat=4
    .q:$D(^TempDHCPENoHPItem(PAADM,ARCIMID))
    .s ^TempDHCPENoHPItem(PAADM,ARCIMID)=""
    .s STID=$o(^DHCPEST(0,"STORD_ARCIM",ARCIMID,""))
    .q:STID'=""
    .s ARCIMDesc=$P(^ARCIM(+ARCIMID,1,1),"^",2)
    .i Ret="" d
    ..s Ret=ARCIMDesc
    .e  d
    ..s Ret=Ret_","_ARCIMDesc
    k ^TempDHCPENoHPItem(PAADM)
    q Ret
}

ClassMethod GetOEItemDesc(OEItemID)
{
    s curLoc=$p($G(^OEORD($p(OEItemID,"||",1),"I",$p(OEItemID,"||",2),1)),"^",3)
    s PAADM=$P($G(^OEORD(+OEItemID)),"^",1)
    s AdmLocID=$P($G(^PAADM(PAADM)),"^",4)
    s RisMerge=$G(^DHCPESetting("DHCPE","RisReportMerge",AdmLocID))
    q:RisMerge'="Y" ##class(web.DHCPE.DHCPECommon).GetArcDesc(OEItemID,"O",curLoc)
    s RisStudyNo=##class(web.DHCPE.HISUICommon).GetStudyNoByOEORI(OEItemID)
    q:RisStudyNo="" ##class(web.DHCPE.DHCPECommon).GetArcDesc(OEItemID,"O",curLoc)
    /*
    s ret=""
    s RegID=0
    f  s RegID=$O(^DHCPACRegInfoi("StudyNo",RisStudyNo,RegID)) q:RegID=""  d
    .s OEItemID=$P($G(^DHCPACRegInfo(RegID)),"^",11)
    .s ORIStat=$p($G(^OEORD(+OEItemID,"I",$P(OEItemID,"||",2),1)),"^",13)
    .q:ORIStat="4"
    .s ArcDesc=##class(web.DHCPE.DHCPECommon).GetArcDesc(OEItemID,"O",curLoc)
    .i ret="" d
    ..s ret=ArcDesc
    .e  d
    ..s ret=ret_"、"_ArcDesc
    */
    s ret=""
    i RisMerge="Y"
    {
    s Order=$O(^OEORD(0,"Adm",PAADM,0))
    s OrderSub="0"
    f  s OrderSub=$O(^OEORD(Order,"I",OrderSub)) q:OrderSub=""  d
    .s OrderID=Order_"||"_OrderSub
    .s ArcimID=$P($g(^OEORD(+OrderID,"I",$P(OrderID,"||",2),1)),"^",2)
    .q:ArcimID=""
    .s Stat=$P($g(^OEORD(Order,"I",OrderSub,1)),"^",13)
    .q:Stat="4" //删除
    .s OneRisStudyNo=##class(web.DHCPE.HISUICommon).GetStudyNoByOEORI(OrderID)
    .q:OneRisStudyNo=""
    .q:((RisStudyNo'=OneRisStudyNo)&&(RisStudyNo'=""))
    .s ArcDesc=##class(web.DHCPE.DHCPECommon).GetArcDesc(OrderID,"O",curLoc)
    .i ret="" d
    ..s ret=ArcDesc
    .e  d
    ..s ret=ret_"、"_ArcDesc
    }
    q ret
}

ClassMethod SaveSortInfo(GSID, value)
{
    q:GSID="" ""
    s ^DHCPEDataEx("SaveSortInfo",GSID)=value
    q ""
}

ClassMethod GetPatientIDByPaadm(Paadm)
{
    q:Paadm="" ""
    s PatientID=$p($g(^PAADM(Paadm)),"^",1)
    q PatientID
}

ClassMethod SetCheckingInfo(PAADM, UserID)
{
    s:UserID="" UserID=%session.Get("LOGON.USERID")
    q:##class(web.DHCPE.ResultPermission).GetGeneAdviserStatus(PAADM)="Audited" ""
    d ..DeleteChceckingInfo(PAADM)
    s PrePAADM=$G(^DHCPEDataExI("AuditRecord",UserID))
    k:PrePAADM'="" ^DHCPEDataEx("AuditRecord",PrePAADM)
    s ^DHCPEDataEx("AuditRecord",PAADM)=UserID_"^"_$H
    s ^DHCPEDataExI("AuditRecord",UserID)=PAADM
    q ""
}

// w ##Class(web.DHCPE.ResultDiagnosisNew).GetCheckingInfo(4996969)

ClassMethod GetCheckingInfo(PAADM)
{
    i $D(^DHCPEDataEx("AuditRecord",PAADM)){
            s User=$P(^DHCPEDataEx("AuditRecord",PAADM),"^",1)
            s DateTime=$P(^DHCPEDataEx("AuditRecord",PAADM),"^",2)
            s:DateTime'="" DateTime=$ZDT(DateTime,3)
            s User=$P(^SSU("SSUSR",User),"^",2)
            q "此人于'"_DateTime_"'被'"_User_"'总检，是否继续。"
    }
    q ""
}

// w ##Class(web.DHCPE.ResultDiagnosisNew).DeleteChceckingInfo(4996969)

ClassMethod DeleteChceckingInfo(PAADM)
{
    k ^DHCPEDataEx("AuditRecord",PAADM)
    q ""
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.ResultDiagnosisNew","FindGSIllness",57)
Query FindGSIllness(GSID As %String = "") As websys.Query(ROWSPEC = "GSIll,GSIllnessID,IllnessDesc,IllnessDetail,GSIType:%String") [ SqlProc ]
{
}

ClassMethod FindGSIllnessExecute(ByRef qHandle As %Binary, GSID As %String = "") As %Status
{
    Set ind=1
    Set repid=$I(^CacheTemp)
    
    if $d(%session) {
        set langId=%session.Get("LOGON.LANGID")
    }
    else
    { s langId=""}
    
    if (GSID="")
    {
        Set qHandle=$lb(0,repid,0)
        Quit $$$OK
        
    }
    s GSIll=0
    f  s GSIll=$o(^User.DHCPEGSIllnessI("IndexParref",GSID,GSIll)) q:GSIll=""  d
    .s GSIllnessID=$lg(^User.DHCPEGSIllnessD(GSIll),3)
    .s GSIStatus=$lg(^User.DHCPEGSIllnessD(GSIll),8)
    .q:GSIStatus'=0
    .s GSIType=$lg(^User.DHCPEGSIllnessD(GSIll),4)
    .s IllnessDesc=$p(^DHCPEILLS(GSIllnessID),"^",2)
    .s IllnessDesc=##class(User.DHCPEIllnessStandard).GetTranByDesc("ILLSDesc",IllnessDesc,langId) 
    .s IllnessDetail=$p(^DHCPEILLS(GSIllnessID),"^",3)
    .d OutGSIlless
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
    
OutGSIlless
    Set Data=$LB(GSIll,GSIllnessID,IllnessDesc,IllnessDetail,GSIType)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    Quit
}

/// w ##Class(web.DHCPE.ResultDiagnosisNew).UpdateGSIllness("^24^57^11849^D")
ClassMethod UpdateGSIllness(Instring, op)
{
    s GSIID=$p(Instring,"^",1)
    s IllID=$p(Instring,"^",2)
    s GSID=$p(Instring,"^",3)
    s User=$p(Instring,"^",4)
    s GSIType=$p(Instring,"^",5)
    
    if (op=2)
    {
        q:GSIID="" ""
        s obj=##class(User.DHCPEGSIllness).%OpenId(GSIID)
        s obj.GSIUpdateDate=+$H
        s obj.GSIUpdateTime=$P($H,",",2)
        d obj.GSIUserDRSetObjectId(User)
        s obj.GSIStatus=op
        s sc=obj.%Save()
        d obj.%Close()
        If ($System.Status.IsError(sc)) 
        {
            q "-1^"_$System.Status.GetErrorText(sc)
        }else{
            q obj.%Id()
        }
    }
    s count=0
    &sql(select count(*) into :count  from SQLUser.DHC_PE_GSIllness where GSI_Parref=:GSID and GSI_IllndessDR=:IllID and GSI_Status='0' and ID<>:GSIID)
    q:count'=0 "-1^疾病不允许重复！"
    if GSIID="" s obj=##class(User.DHCPEGSIllness).%New()
    else  s obj=##class(User.DHCPEGSIllness).%OpenId(GSIID)
    s obj.GSIUpdateDate=+$H
    s obj.GSIUpdateTime=$P($H,",",2)
    d obj.GSIParrefSetObjectId(GSID)
    d obj.GSIIllndessDRSetObjectId(IllID)
    s obj.GSIType=GSIType
    d obj.GSIUserDRSetObjectId(User)
    s obj.GSIStatus=op
    s sc=obj.%Save()
    d obj.%Close()
    If ($System.Status.IsError(sc)) 
    {
        q "-1^"_$System.Status.GetErrorText(sc)
    }else{
        q obj.%Id()
    }
}

/// Description: 生成总的疾病信息
/// Debug: w ##Class(web.DHCPE.ResultDiagnosisNew).CreateGSIDetail(57,11849)
ClassMethod CreateGSIDetail(GSID, User)
{
    s PAADM=$p($g(^DHCPEGS(GSID,1)),"^",8)
    s LocID=$P($g(^PAADM(PAADM)),"^",4)
    &sql(delete from SQLUser.DHC_PE_GSIllness where GSI_Parref=:GSID and GSI_Type='S')
    s Sort=0
    f  s Sort=$o(^DHCPEGS(0,"GSDSort",GSID,Sort)) q:Sort=""  d
    .s gSub=0
    .f  s gSub=$o(^DHCPEGS(0,"GSDSort",GSID,Sort,gSub)) q:gSub=""  d
    ..s Status=$p($g(^DHCPEGS(GSID,"Diagnosis",gSub)),"^",11)
    ..q:Status'="0"
    ..s EDID=$p($g(^DHCPEGS(GSID,"Diagnosis",gSub)),"^",1)
    ..q:EDID=""
    ..s IDRID=0
    ..f  s IDRID=$o(^DHCPEIDR(0,"EDDR",EDID,IDRID)) q:IDRID=""  d
    ...s ILLDR=$p($g(^DHCPEIDR(IDRID)),"^",2)
    ...q:ILLDR=""
    ...;s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("ED",EDID)
    ...;q:LocFlag=1
    ...s LocShowDFlag=##class(User.DHCPEExpertDiagnosis).GetLocShowDataFlag(EDID,LocID)
    ...q:LocShowDFlag'="Y"
    ...s Str="^"_ILLDR_"^"_GSID_"^"_User_"^S"
    ...d ..UpdateGSIllness(Str,0)
    q 0
}

/// Descript:业务加锁
/// Input:
///                 EpisodeID:  就诊ID
///                 MainDoctor：复审标记
/// Return:     ""：成功   非空：失败  
/// Creater:    wangguoying
/// CreateDate: 2020-08-12
/// Debug: w ##class(web.DHCPE.ResultDiagnosisNew).LockAuditByPAADM(4245,"N")
ClassMethod LockAuditByPAADM(EpisodeID, MainDoctor)
{
    s bType="AR"
    s:MainDoctor="Y" bType="MAR"
    s sessinId=%session.SessionId
    //先释放本session下同业务的锁
    d ##class(web.DHCPE.Lock).LockClearTypeAndSession(bType,sessinId)
    // 释放同一科室  同一用户  同一类型  同一业务ID 的锁
    d ##class(web.DHCPE.Lock).LockClearLast(EpisodeID,bType)
    q ##class(web.DHCPE.Lock).Lock(EpisodeID,bType,sessinId)
}

/*
ClassMethod SaveOneED(GSDRowID, Advice, EDConclusion)
{
    //Code+"^"+DiagnoseConclusion+"^"+Detail+"^"+Illness+"^"+CommonIllness+"^"+UserId+"^"+InsertType+"^"+EDAlias+"^"+StationID+"^"+Active+"^"+LevelID+"^"+IllRowID+"^"+HighRisk+"^"+Sort+"^"+StationLocID
    q:GSDRowID="" ""
    s EDDR=$p(^DHCPEGS(+GSDRowID,"Diagnosis",$p(GSDRowID,"||",2)),"^",1)
    s Station=$p(^DHCPEED(EDDR,1),"^",7)
    s Code=##class(web.DHCPE.DHCPEExpertDiagnosis).GetMaxCode()
    s UserID=%session.Get("LOGON.USERID")
    i EDConclusion[":" s EDAConclusion=$p(EDConclusion,":",1)
    e  i EDConclusion["：" s EDAConclusion=$p(EDConclusion,"：",1)    //add 20201202  
    e  s EDAConclusion=EDConclusion
    i (EDConclusion["[")&&(EDConclusion["]") d
    .s EDConclusion=$p(EDConclusion,"[",2)
    .s EDConclusion=$p(EDConclusion,"]",1)
    s EDAlias=##class(web.DHCINSUPort).GetCNCODE(EDConclusion,4,"")
    s Instring=Code_"^"_EDConclusion_"^"_Advice_"^N^N^"_UserID_"^^"_EDAlias_"^"_Station_"^Y^^^N^^"
    s EDRowID=""
    &SQL(Select ED_RowId Into :EDRowID from SQLUser.DHC_PE_ExpertDiagnosis Where ED_DiagnoseConclusion=:EDConclusion and ED_Detail=:Advice and ED_Station_DR=:Station)
    q:EDRowID'="" "1"
    s Info=##class(web.DHCPE.DHCPEExpertDiagnosis).InsertED(Instring)
    s SQLCODE=$p(Info,"^",1)
    q SQLCODE
}
*/
/// Description: 保存建议到专家建议表中(多院区)
/// Debug:  w ##class(web.DHCPE.ResultDiagnosisNew).SaveOneED()
ClassMethod SaveOneED(GSDRowID, Advice, EDConclusion, UserID As %String = "", LocID As %String = "")
{
    s ^tempdhcpe("SaveOneED")=$lb(GSDRowID, Advice, EDConclusion,UserID,LocID)
    q:GSDRowID="" ""
    i (UserID="") {
        s:$D(%session) UserID = %session.Get("LOGON.USERID")
    }
    i (LocID=""){
        s:$D(%session) LocID = %session.Get("LOGON.CTLOCID")
    }
    
    s EDDR=$p($g(^DHCPEGS(+GSDRowID,"Diagnosis",$p(GSDRowID,"||",2))),"^",1)
    s Station=$p($g(^DHCPEED(EDDR,1)),"^",7)
    s Code=##class(web.DHCPE.DHCPEExpertDiagnosis).GetMaxCode() //获取建议编码
    i EDConclusion[":" s EDAConclusion=$p(EDConclusion,":",1)
    e  i EDConclusion["：" s EDAConclusion=$p(EDConclusion,"：",1)   
    e  s EDAConclusion=EDConclusion
    i (EDConclusion["[")&&(EDConclusion["]") d
    .s EDConclusion=$p(EDConclusion,"[",2)
    .s EDConclusion=$p(EDConclusion,"]",1)
   
    s EDAlias=##class(web.DHCINSUPort).GetCNCODE(EDConclusion,4,"") //建议别名
   
    s EDRowID=""
    &SQL(Select ED_RowId Into :EDRowID from SQLUser.DHC_PE_ExpertDiagnosis Where ED_DiagnoseConclusion=:EDConclusion and ED_Detail=:Advice and ED_Station_DR=:Station)
    q:EDRowID'="" "1"
 
    s Illness="N",CommonIllness="N",Active="Y",LevelID="",SexDR="",EDCRID=""
    s ExpStr="N^^^N^"_LocID_"^"_EDAlias_"^N"
    s Info=##class(web.DHCPE.CT.ExpertDiagnosis).UpdateED("",Code,EDConclusion,Advice,Illness,CommonIllness,UserID,Station,Active,LevelID,EDCRID,SexDR,ExpStr)
 
    s SQLCODE=$p(Info,"^",1)
    q SQLCODE
}

}
