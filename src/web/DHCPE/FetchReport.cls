Class web.DHCPE.FetchReport Extends %Persistent
{

/// function :判断是否粘贴
/// debug:w ##class(web.DHCPE.FetchReport).IsExistSendAudit()
ClassMethod IsExistSendAudit(PAADM As %String = "")
{
	s flag=0
	q:PAADM="" flag
	i $D(^User.DHCPESendAuditI("AdmIndex",PAADM)) s flag=1
	e  s flag=0
	q flag
}

ClassMethod IsSendAudit(RegNo, UserID, CheckFlag As %String = "0", vPAADM)
{
    s ID=""
    i vPAADM'="" s ID=$o(^User.DHCPEOtherPatientToHPI("OTHPAADMDRIndex",vPAADM,0))
    i ID'="" Q "-4^住院体检不需黏贴"
    I UserID="" s UserID=%session.Get("LOGON.USERID")
    i RegNo'=""
    {
        s PIADM=##class(web.DHCPE.DHCPEIAdm).GetPIADMByRegNo(RegNo)
        s Flag=$P(PIADM,"^",1)
        q:Flag'=0 PIADM_"^"
        s PIADM=$P(PIADM,"^",2)
        s IADM=$O(^DHCPEIADM(0,"CRMADM",PIADM,0))
        q:IADM="" "-1^没有到达^"
        s PAADM=$P(^DHCPEIADM(IADM),"^",1)
    }
    else
    {
        s PAADM=vPAADM
        s IADM=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
        s PIADM=$P(^DHCPEIADM(IADM),"^",4)
    }
    
    
    q:$D(^User.DHCPESendAuditI("AdmIndex",PAADM)) "-1^已经粘贴，不需要再次粘贴^"
    
    //q:'$D(^DHCPEDataEx("ConfirmRecPaper",PIADM)) "-1^还未收表，不允许粘贴^"
    
    i CheckFlag="0"{
        s ConfirmRecPaper=""
        i '$D(^DHCPEDataEx("ConfirmRecPaper",PIADM)) d
        .s ConfirmRecPaper="此人还未收表"
        s UnDoItems=##class(web.DHCPE.ResultEdit).GetUnAppedItems("",PAADM)
        s UnDoItems=$P(UnDoItems,"^",2)
        i ConfirmRecPaper'="" d
        .i UnDoItems'="" d
        ..s UnDoItems=ConfirmRecPaper_$C(13)_"未完成项目为"_$C(13)_UnDoItems
        e  d
        .s:UnDoItems'="" UnDoItems="未完成项目为"_$C(13)_UnDoItems
        i $D(^User.DHCPESendAuditI("AdmIndex",PAADM)){
            q "-2^"_UnDoItems_"^"_PAADM
        }
        i UnDoItems'=""{
            q "-3^"_UnDoItems_"^"_PAADM
        }
    }
    q "0^"_PAADM
}

ClassMethod SendAuditNew(UserID, CheckFlag As %String = "0", vPAADM)
{
    I UserID="" s UserID=%session.Get("LOGON.USERID")
    
    s PAADM=vPAADM
    s IADM=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
    s PIADM=$P(^DHCPEIADM(IADM),"^",4)
    
    s obj=##class(User.DHCPESendAudit).%New()
    d obj.SAPAAdmDRSetObjectId(PAADM)
    s obj.SASendDate=+$H
    s obj.SASendTime=$P($H,",",2)
    d obj.SASendUserDRSetObjectId(UserID)
    s sc=obj.%Save()
    d obj.%Close()
    If ($System.Status.IsError(sc)) 
    {
        q "-1^"_$System.Status.GetErrorText(sc)
    }else{
        d ##class(web.DHCPE.AdmRecordManager).Insert(PIADM,"P","SendAudit",UserID,"")
        //d ##class(web.DHCPE.HighRisk).GenAdmHighRisk(PAADM)
        q "0^"
    }
}

/// w ##class(web.DHCPE.FetchReport).UserAddBackToSpecial("32051||1")
ClassMethod UserAddBackToSpecial(arcid)
{
    ;select * from arc_itmmast where ARCIM_Desc like '%C14尿素呼气试验%'  ;20515||1
    ;select * from arc_itmmast where ARCIM_Desc like '%乳腺超声检查(特需)%' ;22219||1
    s ArcItmId=""
    f  s ArcItmId=$O(^DHCPECTDataEx("DHCPEStationOrder","SignItem",ArcItmId)) q:ArcItmId=""  d
    .q:$G(^DHCPECTDataEx("DHCPEStationOrder","SignItem",ArcItmId))'="Y"
    .q:(""'=arcid)&(arcid'=ArcItmId)
    .w !,"go"
    .s RltId=0
    .f  s RltId=$O(^DHCPERLT(0,"ARCIM",ArcItmId,RltId)) q:RltId=""  d
    ..s (CurInfo,BtnUser)=""
    ..s CurInfo=$G(^DHCPERLT(RltId))
    ..s BtnComDate=$P(CurInfo,"^",6)
    ..;q:63134'=BtnComDate
    ..s Result=$P(CurInfo,"^",4)
    ..;q:"临床诊断:;检查所见:;诊断意见:详见报告"'=Result
    ..s paadmid=$P(CurInfo,"^",1)
    ..s patmasid=$P(^PAADM(paadmid),"^",1)
    ..s patname=$P(^PAPER(patmasid,"ALL"),"^",1)
    ..s arcdesc=$P(^ARCIM(+ArcItmId,$P(ArcItmId,"||",2),1),"^",2)
    ..s OeOriId=$P(CurInfo,"^",9)
    ..s OeOriStatus=$P(^OEORD(+OeOriId,"I",$P(OeOriId,"||",2),1),"^",13)
    ..w !,patname_" "_arcdesc_" "_OeOriStatus
    ..w !,"Status"_" "_OeOriStatus
    ..q:6'=OeOriStatus
    ..s BtnUser=+$P(CurInfo,"^",5)
    ..q:BtnUser=""
    ..s user=$g(^DHCPESpecial("DHCPE","UserID",OeOriId))
    ..i user="" d
    ...s ^DHCPESpecial("DHCPE","UserID",OeOriId)=BtnUser
    ...s arcdesc="OK"_arcdesc
    ..e  d
    ...s arcdesc="History"_arcdesc
    ..s username=$p($g(^SSU("SSUSR",BtnUser)),"^",2)
    ..w !,patname_" "_arcdesc_" "_username_" "_$zd(BtnComDate,3)
    q 0
}

ClassMethod FetchReportByHPNo(HPNo, NewStatus As %String = "S")
{
    ;d ##class(web.DHCPE.FetchReport).FetchReport("40693660")
    s HPNo=$ZCVT(HPNo,"U")
    s PIADM=$O(^DHCPEPreIADM(0,"HPNo",HPNo,0))
    q:PIADM="" "-1^体检号不存在"
    //s PIADM=$P(PIADM,"^",2)
    s IADM=$O(^DHCPEIADM(0,"CRMADM",PIADM,0))
    q:IADM="" "-1^没有到达"
    s RPTID=$O(^DHCPERPT(0,"IADM",IADM,0))
    b ;
    q:RPTID="" "-1^没有报告"
    s Status=$P(^DHCPERPT(RPTID),"^",2)
    q:Status="NA" "-1^报告没有审核"
    q:Status="A" "-1^报告没有打印"
    q:((Status="C")||(Status="S"))&&(NewStatus="C") "-1^报告已经扫描过"
    q:(Status="S")&&(NewStatus="S") "-1^报告已经取走"
    s InStr=RPTID_"^"_NewStatus_"^"
    b ;InStr
    s ret=##class(web.DHCPE.Report).SetReportStatus("","",InStr)
    
    i ret=0{
        s UserID=%session.Get("LOGON.USERID")
        s DetailType="Complete"
        i NewStatus="S" s DetailType="FetchReport"
        d ##class(web.DHCPE.AdmRecordManager).Insert(PIADM,"P",DetailType,UserID,"")
        q "0^OVER"
        
    }
    q "-1^没有更新成功"_ret
}

/// d ##class(web.DHCPE.FetchReport).GetSRPIADMSByRegNo("0000000026")
ClassMethod GetSRPIADMSByRegNo(RegNo)
{

    i RegNo'="" s RegNo=##class(web.DHCPE.DHCPECommon).RegNoMask(RegNo) 
    q:('($L(RegNo)>0)) "-1^请输入正确的登记号"
    s PIBI=$o(^DHCPEPreIBI(0,"PAPMINo",RegNo,0))
    q:PIBI="" "_1^无该人员的基本信息!"
    s PIADM="",PIADMStr="" 
    f  s PIADM=$o(^DHCPEPreIADM(0,"PIBI",PIBI,PIADM),-1) q:(PIADM="")  d
    .s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PreADM",PIADM) 
    .q:LocFlag=1 
    .s PIADMStutas=$P(^DHCPEPreIADM(PIADM),"^", 8)
    .q:"ARRIVED"'=PIADMStutas
    .s ReCheck=$P(^DHCPEPreIADM(PIADM),"^", 28)
    .q:ReCheck="Y"
    .S IADM=""
    .s IADM=$O(^DHCPEIADM(0,"CRMADM",PIADM,0))
    .q:IADM="" 
    .s PAADM=$P(^DHCPEIADM(IADM),"^",1)
    .s RPTID=$O(^DHCPERPT(0,"IADM",IADM,0))
    .q:RPTID="" 
    .s Status=$P(^DHCPERPT(RPTID),"^",2)
    .q:Status="NA" 
    .q:Status="A" 
    .s SSID=##class(web.DHCPE.ResultDiagnosis).GetSSId(PAADM)
    .q:SSID="" 
    .s SSStatus=$p($G(^DHCPEGS(SSID,1)),"^",5)
    .q:SSStatus="" 
    .s LocID=$P(^DHCPEPreIADM(PIADM),"^",26)
    .;q:'$d(^DHCPEDataEx("ConfirmRecPaper",PIADM)) //过滤没有收表的记录
    .s MainDoctorFlag=$G(^DHCPESetting("DHCPE","MainDoctorGroup",LocID))
    .q:(MainDoctorFlag="Y")&&('$D(^DHCPEDataEx("DHCPEGeneralSummarize","MainDoctor",PAADM))) 
    
    .i PIADMStr="" s PIADMStr=PIADM
    .e  s PIADMStr=PIADMStr_"$"_PIADM
    q "0^"_PIADMStr
}

/// d ##class(web.DHCPE.FetchReport).FetchReportHisui(12831)
ClassMethod FetchReportHisui(PIADM, NewStatus As %String = "S", Instring = "")
{
    s IADM=$O(^DHCPEIADM(0,"CRMADM",PIADM,0))
    q:IADM="" "-1^没有到达"
    s RPTID=$O(^DHCPERPT(0,"IADM",IADM,0))
    q:RPTID="" "-1^没有报告"
    //判断是否总检
    s PAADM=$P(^DHCPEIADM(IADM),"^",1)
    s SSID=##class(web.DHCPE.ResultDiagnosis).GetSSId(PAADM)
    q:SSID="" "-1^没有总检记录"
    s SSStatus=$p($G(^DHCPEGS(SSID,1)),"^",5)
    q:SSStatus="" "-1^总检还未审核"
    s LocID=$P(^DHCPEPreIADM(PIADM),"^",26)
    s MainDoctorFlag=$G(^DHCPESetting("DHCPE","MainDoctorGroup",LocID))
    q:(MainDoctorFlag="Y")&&('$D(^DHCPEDataEx("DHCPEGeneralSummarize","MainDoctor",PAADM))) "-1^复检还未审核"
    
    s Status=$P(^DHCPERPT(RPTID),"^",2)
    q:Status="NA" "-1^报告没有审核"
    q:Status="A" "-1^报告没有打印"
    
    q:(Status="C")&&(NewStatus="C") "-1^报告已经完成"
    q:(Status="S")&&(NewStatus="S") "-1^报告已经取走"
    q:(Status="S")&&(NewStatus="C") "-1^报告已经取走"

    s InStr=RPTID_"^"_NewStatus_"^"
    
    s ret=##class(web.DHCPE.Report).SetReportStatus("","",InStr)
    
    i ret=0{
        d:Instring'="" ..UpdateFetchReportInfo(Instring,"1")
        s UserID=%session.Get("LOGON.USERID")
        s DetailType="Complete"
        i NewStatus="S" s DetailType="FetchReport"
        d ##class(web.DHCPE.AdmRecordManager).Insert(PIADM,"P",DetailType,UserID,"")
        q "0^OVER"
    }
    q "-1^没有更新成功"_ret
}

ClassMethod FetchReport(RegNo, NewStatus As %String = "S")
{
    ;d ##class(web.DHCPE.FetchReport).FetchReport("40693660")
    s PIADM=##class(web.DHCPE.DHCPEIAdm).GetPIADMByRegNo(RegNo)
    s Flag=$P(PIADM,"^",1)
    q:Flag'=0 PIADM
    s PIADM=$P(PIADM,"^",2)
    q:PIADM="" "-1^没有预约"
    s IADM=$O(^DHCPEIADM(0,"CRMADM",PIADM,0))
    q:IADM="" "-1^没有到达"
    s RPTID=$O(^DHCPERPT(0,"IADM",IADM,0))
    q:RPTID="" "-1^没有报告"
    //判断是否总检
    s PAADM=$P(^DHCPEIADM(IADM),"^",1)
    s SSID=##class(web.DHCPE.ResultDiagnosis).GetSSId(PAADM)
    q:SSID="" "-1^没有总检记录"
    s SSStatus=$p($G(^DHCPEGS(SSID,1)),"^",5)
    q:SSStatus="" "-1^总检还未审核"
    s LocID=$P(^DHCPEPreIADM(PIADM),"^",26)
    s MainDoctorFlag=$G(^DHCPESetting("DHCPE","MainDoctorGroup",LocID))
    q:(MainDoctorFlag="Y")&&('$D(^DHCPEDataEx("DHCPEGeneralSummarize","MainDoctor",PAADM))) "-1^复检还未审核"
    //End
    s Status=$P(^DHCPERPT(RPTID),"^",2)
    q:Status="NA" "-1^报告没有审核"
    q:Status="A" "-1^报告没有打印"
    /*
    q:(Status="C")&&(NewStatus="C") "-1^报告已经完成,状态为"_Status
    q:(Status="S")&&(NewStatus="C") "-1^报告已经取走,状态为"_Status
    q:(Status="S")&&(NewStatus="S") "-1^报告已经取走,状态为"_Status
    ;q:(Status="P")&&(NewStatus="S") "-1^报告还未完成"_Status
    */
    q:(Status="C")&&(NewStatus="C") "-1^报告已经完成"
    q:(Status="S")&&(NewStatus="C") "-1^报告已经取走"
    q:(Status="S")&&(NewStatus="S") "-1^报告已经取走"

    s InStr=RPTID_"^"_NewStatus_"^"
    b ;InStr
    s ret=##class(web.DHCPE.Report).SetReportStatus("","",InStr)
    
    i ret=0{
        s UserID=%session.Get("LOGON.USERID")
        s DetailType="Complete"
        i NewStatus="S" s DetailType="FetchReport"
        d ##class(web.DHCPE.AdmRecordManager).Insert(PIADM,"P",DetailType,UserID,"")
        q "0^OVER"
        
    }
    q "-1^没有更新成功"_ret
}

ClassMethod CancelFetchReport(ID, CurStatus As %String = "S")
{
    q:ID="" "-1^无法获取记录"
    s Status=$P(^DHCPERPT(ID),"^",2)
    i CurStatus="S"
    {
        q:Status'="S" "-1^报告不是已取状态"
        s NewStatus="C"
        s CompleteDate=$P(^DHCPERPT(ID),"^",11)
        s:CompleteDate="" NewStatus="P"

        &sql(Update Sqluser.DHC_PE_Report set RPT_SendUser_DR=null,RPT_SendDate=null,RPT_SendTime=null,RPT_Status=:NewStatus where RPT_RowID=:ID)
    }
    else
    {
        q:Status'="C" "-1^报告不是已完成状态"
        &sql(Update Sqluser.DHC_PE_Report set RPT_CompleteDate=null,RPT_CompleteTime=null,RPT_CompleteUser_DR=null,RPT_Status='P' where RPT_RowID=:ID)
    }
    k ^DHCPEDataEx("FetchReport","Detail",ID)
    q SQLCODE_"^"_SQLCODE
}

ClassMethod CancelFetchButton(ID, CurStatus As %String = "S")
{
    q:ID="" ""
    s Status=$P(^DHCPERPT(ID),"^",2)
    q:Status'=CurStatus ""
    w "<button onclick=CancelFetch(this) id='"_ID_"'>撤销</button>"
}

/*
ClassMethod GetContent(IFOLD, VIP)
{
     S HOSPID=%session.Get("LOGON.HOSPID")
     S HospitalName=##class(web.DHCPE.DHCPECommon).GetHospitalName(HOSPID)
     I HospitalName["[" s HospitalName=$p(HospitalName,"[",1)

    s Contentstr="",ID=""
    i IFOLD'="" d
    .s ID=$O(^User.DHCPENewMessageTempletI("TypeDefaultIndex","老年短信",1,""))
    e  i VIP=2 d
    .s ID=$O(^User.DHCPENewMessageTempletI("TypeDefaultIndex","VIP短信",1,""))
    e  d
    .s ID=$O(^User.DHCPENewMessageTempletI("TypeDefaultIndex","普通短信",1,""))
    i ID'="" d
    .s Contentstr=$LG(^User.DHCPENewMessageTempletD(ID),4)
    e  d
    .;s Contentstr="尊敬的[Name]您好！这里是协和医院健康医学部。请您于周一至周五下午1:30-4:00前来九层领取体检报告(节假日除外)。咨询电话:69159840"
    .s Contentstr="尊敬的[Name]您好！这里是"_HospitalName_"。请您于周一至周五下午1:30-4:00前来九层领取体检报告(节假日除外)。咨询电话:69159840。"
    q Contentstr
}
*/
ClassMethod GetContent(IFOLD As %String = "", VIP As %String = "", LocID As %String = "")
{
    s HOSPID=%session.Get("LOGON.HOSPID")
    s HospitalName=##class(web.DHCPE.DHCPECommon).GetHospitalName(HOSPID)
    s HospitalName=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.CTHospital",HospitalName,"HOSPDesc","cls")
    i HospitalName["[" s HospitalName=$p(HospitalName,"[",1)
 
    //^User.DHCPENewMessageTempletI("IdxOfLocTypeVIP",LocID,短信类型,VIP等级,ID) ？
    s Contentstr="",ID=""
    i IFOLD'="" d
    .s ID=$O(^User.DHCPENewMessageTempletI("IdxOfLocTypeVIP",LocID,"老年短信",1,""))
    e  i VIP=2 d
    .s ID=$O(^User.DHCPENewMessageTempletI("IdxOfLocTypeVIP",LocID,"VIP短信",1,""))
    e  d
    .s ID=$O(^User.DHCPENewMessageTempletI("IdxOfLocTypeVIP",LocID,"普通短信",1,""))
    i ID'="" d
    .s Contentstr=$LG(^User.DHCPENewMessageTempletD(ID),4)
    .s Contentstr= ##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPENewMessageTemplet",Contentstr,"NMTTemplet","cls")
    e  d
    .;s Contentstr="尊敬的[Name]您好！这里是"_HospitalName_"。请您于周一至周五下午1:30-4:00前来九层领取体检报告(节假日除外)。咨询电话:69159840。"
    .s Contentstr1=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpesendreportmessage.hiui.csp","尊敬的[Name]您好！这里是")
    .s Contentstr2=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpesendreportmessage.hiui.csp","。请您于周一至周五下午1:30-4:00前来九层领取体检报告(节假日除外)。咨询电话:69159840。")
    .s Contentstr=Contentstr1_HospitalName_Contentstr2
    q Contentstr
}

ClassMethod Test(str, strs)
{
    s res=str_"hahaha"_strs
    q res
    q "a"
}

ClassMethod CacleSendAudit(vPAADM)
{
        ;s ^sxt("aaz")=vPAADM
        s PAADM=vPAADM
        s UserID=%session.Get("LOGON.USERID")
        ;s User=%session.Get("LOGON.USERID")
        ;s IADM=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
        ;s PIADM=$P(^DHCPEIADM(IADM),"^",4)
        
        q:('$D(^User.DHCPESendAuditI("AdmIndex",PAADM))) "不存在记录"
        &sql(delete from sqluser.DHC_PE_SendAudit where SA_PAAdm_DR=:PAADM)
        i 'SQLCODE  d
        .d ##class(web.DHCPE.AdmRecordManager).Insert(PAADM,"A","CacleSendAudit",UserID,"") 
        q SQLCODE
}

ClassMethod SendAudit(RegNo, UserID, CheckFlag As %String = "0", vPAADM)
{
    s ID=""
    i vPAADM'="" s ID=$o(^User.DHCPEOtherPatientToHPI("OTHPAADMDRIndex",vPAADM,0))
    i ID'="" Q "-4^住院体检不需黏贴"
    I UserID="" s UserID=%session.Get("LOGON.USERID")
    i RegNo'=""
    {
        s PIADM=##class(web.DHCPE.DHCPEIAdm).GetPIADMByRegNo(RegNo)
        s Flag=$P(PIADM,"^",1)
        q:Flag'=0 PIADM_"^"
        s PIADM=$P(PIADM,"^",2)
        s IADM=$O(^DHCPEIADM(0,"CRMADM",PIADM,0))
        q:IADM="" "-1^没有到达^"
        s PAADM=$P(^DHCPEIADM(IADM),"^",1)
    }
    else
    {
        s PAADM=vPAADM
        s IADM=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
        s PIADM=$P(^DHCPEIADM(IADM),"^",4)
    }
    q:$D(^User.DHCPESendAuditI("AdmIndex",PAADM)) "-1^已经粘贴，不需要再次粘贴^"
    
    //q:'$D(^DHCPEDataEx("ConfirmRecPaper",PIADM)) "-1^还未收表，不允许粘贴^"
    
    i CheckFlag="0"{
        s ConfirmRecPaper=""
        i '$D(^DHCPEDataEx("ConfirmRecPaper",PIADM)) d
        .s ConfirmRecPaper="此人还未收表"
        s UnDoItems=##class(web.DHCPE.ResultEdit).GetUnAppedItems("",PAADM)
        s UnDoItems=$P(UnDoItems,"^",2)
        i ConfirmRecPaper'="" d
        .i UnDoItems'="" d
        ..s UnDoItems=ConfirmRecPaper_$C(13)_"未完成项目为"_$C(13)_UnDoItems
        e  d
        .s:UnDoItems'="" UnDoItems="未完成项目为"_$C(13)_UnDoItems
        i $D(^User.DHCPESendAuditI("AdmIndex",PAADM)){
            q "-2^"_UnDoItems
        }
        i UnDoItems'=""{
            q "-3^"_UnDoItems
        }
    }
    s obj=##class(User.DHCPESendAudit).%New()
    d obj.SAPAAdmDRSetObjectId(PAADM)
    s obj.SASendDate=+$H
    s obj.SASendTime=$P($H,",",2)
    d obj.SASendUserDRSetObjectId(UserID)
    s sc=obj.%Save()
    d obj.%Close()
    If ($System.Status.IsError(sc)) 
    {
        q "-1^"_$System.Status.GetErrorText(sc)
    }else{
        d ##class(web.DHCPE.AdmRecordManager).Insert(PIADM,"P","SendAudit",UserID,"")
        //d ##class(web.DHCPE.HighRisk).GenAdmHighRisk(PAADM)
        q "0^"
    }
}

/// 查询取报告记录  NoFetchReport Y 未取记录（到达时间）    N 已取记录（取报告时间）
/// d ##class(%ResultSet).RunQuery("web.DHCPE.FetchReport","SearchFetchReport","11/02/2020","11/03/2020","00000000","","Y","","","","")
Query SearchFetchReport(StartDate As %String, EndDate As %String, RegNo As %String, HPNo As %String, NoFetchReport As %String = "N", VIPLevel As %String = "", Name As %String = "", GroupID As %String = "", DepartName As %String = "", CredNo As %String = "") As %Query(ROWSPEC = "ReportID:%String,PreIADM:%String,TRegNo:%String,TName:%String,TSex:%String,TBirth:%String,TAge:%String,TIDCard:%String,TVIPLevel:%String,PreGBI:%String,TGroupName:%String,TDepartName:%String,ReportStatus:%String,TReportStatus:%String,RepoerSend:%String,TRepoerSend:%String,TAppDate:%String,TSendUser:%String,TSendDate:%String,TSendTime:%String,THPNo:%String,TCardType:%String,Address:%String")
{
}

ClassMethod SearchFetchReportExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, RegNo As %String, HPNo As %String = "", NoFetchReport As %String = "N", VIPLevel As %String = "", Name As %String = "", GroupID As %String = "", DepartName As %String = "", CredNo As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind=1
    
    i ((RegNo="")&&(HPNo="")&&(StartDate=""||EndDate="")) {
        Set qHandle=$lb(0,repid,0) 
        Quit $$$OK 
    }
    
    i StartDate'="" s StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
    i EndDate'="" s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
    
    i NoFetchReport="" s NoFetchReport="N"
    
    i ((StartDate'="")&&(StartDate>EndDate)) {
        Set qHandle=$lb(0,repid,0) 
        Quit $$$OK 
    }
    s Date=EndDate+1
    i NoFetchReport="Y" {
        i RegNo'="" d
        .s RegNo=##class(web.DHCPE.DHCPECommon).RegNoMask(RegNo)
        .s PreIBI=0
        .f  s PreIBI=$o(^DHCPEPreIBI(0,"PAPMINo",RegNo,PreIBI)) q:PreIBI=""  d
        ..s PreIADM=""
        ..f  s PreIADM=$o(^DHCPEPreIADM(0,"PIBI",PreIBI,PreIADM),-1) q:((PreIADM="")||(PreIADM=0))  d
        ...s IADM=$o(^DHCPEIADM(0,"CRMADM",PreIADM,0))
        ...q:IADM=""
        ...s ReportID=$o(^DHCPERPT(0,"IADM",IADM,0))
        ...q:ReportID=""
        ...d Clear
        ...d GetPersonInfo
        e  i HPNo'="" d
        .s PreIADM=0
        .f  s PreIADM=$o(^DHCPEPreIADM(0,"HPNo",HPNo,PreIADM)) q:(PreIADM="")  d
        ..s IADM=$o(^DHCPEIADM(0,"CRMADM",PreIADM,0))
        ..q:IADM=""
        ..s ReportID=$o(^DHCPERPT(0,"IADM",IADM,0))
        ..q:ReportID=""
        ..d Clear
        ..d GetPersonInfo
        e  d
        .f  s Date=$o(^DHCPERPT(0,"SendDate",Date),-1) q:(Date="")||(Date<StartDate)  d
        ..s Time=""
        ..f  s Time=$o(^DHCPERPT(0,"SendDate",Date,Time),-1) q:(Time="")  d
        ...s ReportID=0
        ...f  s ReportID=$O(^DHCPERPT(0,"SendDate",Date,Time,ReportID)) q:(ReportID="")  d
        ....s IADM=$P(^DHCPERPT(ReportID),"^",1)
        ....q:IADM=""
        ....d Clear
        ....d GetPersonInfo
    }else{
        i RegNo'="" d
        .s RegNo=##class(web.DHCPE.DHCPECommon).RegNoMask(RegNo)
        .s PreIBI=0
        .f  s PreIBI=$o(^DHCPEPreIBI(0,"PAPMINo",RegNo,PreIBI)) q:PreIBI=""  d
        ..s PreIADM=""
        ..f  s PreIADM=$o(^DHCPEPreIADM(0,"PIBI",PreIBI,PreIADM),-1) q:((PreIADM="")||(PreIADM=0))  d
        ...s IADM=$o(^DHCPEIADM(0,"CRMADM",PreIADM,0))
        ...q:IADM=""
        ...s ReportID=$o(^DHCPERPT(0,"IADM",IADM,0))
        ...q:ReportID=""
        ...d Clear
        ...d GetPersonInfo
        e  i HPNo'="" d
        .s PreIADM=0
        .f  s PreIADM=$o(^DHCPEPreIADM(0,"HPNo",HPNo,PreIADM)) q:(PreIADM="")  d
        ..s IADM=$o(^DHCPEIADM(0,"CRMADM",PreIADM,0))
        ..q:IADM=""
        ..s ReportID=$o(^DHCPERPT(0,"IADM",IADM,0))
        ..q:ReportID=""
        ..d Clear
        ..d GetPersonInfo
        e  d
        .f  s Date=$o(^DHCPEIADM(0,"AdmDateTime",Date),-1) q:(Date="")||(Date<StartDate)  d
        ..s Time=""
        ..f  s Time=$o(^DHCPEIADM(0,"AdmDateTime",Date,Time)) q:(Time="")  d
        ...s IADM=0
        ...f  s IADM=$o(^DHCPEIADM(0,"AdmDateTime",Date,Time,IADM)) q:(IADM="")  d
        ....s ReportID=$o(^DHCPERPT(0,"IADM",IADM,0))
        ....q:ReportID=""
        ....d Clear
        ....d GetPersonInfo
    }
    
    Set qHandle=$lb(0,repid,0) 
    Quit $$$OK
    
GetPersonInfo
  
    s PAADM=$p($g(^DHCPEIADM(IADM)),"^",1)
    q:PAADM=""
    s PreIADM=$p($g(^DHCPEIADM(IADM)),"^",4)
    q:PreIADM=""
    s PreIBI=$p($g(^DHCPEPreIADM(PreIADM)),"^",1)
    q:PreIBI=""
    s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PreADM",PreIADM)
    q:LocFlag=1
    s Status=$p($g(^DHCPEPreIADM(PreIADM)),"^",8)
    q:Status'="ARRIVED"
    s CurBaseInfo=$g(^DHCPEPreIBI(PreIBI))
    s TRegNo=$p(CurBaseInfo,"^",1)
    q:((RegNo'="")&&(RegNo'=TRegNo))
    s THPNo=$P(^DHCPEPreIADM(PreIADM),"^",27)
    q:((HPNo'="")&&(HPNo'=THPNo))
    /*
    s TVIP=$P($g(^DHCPEPreIADM(PreIADM)),"^",18)
    q:TVIP=""
    q:((VIPLevel'="")&&(VIPLevel'=TVIP))
    s TVIPLevel=$p($g(^DHCPEVIPLevel("VIP",TVIP)),"^",2)
    */
    s PIADMVIP = ##class(web.DHCPE.PreCommon).GetVIPLevel("Pre",PreIADM)
	s TVIPLevelID=$P(PIADMVIP,"^",1)
	q:(VIPLevel'="")&&(VIPLevel'=TVIPLevelID)
	s TVIPLevel=$P(PIADMVIP,"^",2)
	
    s TName=$p(CurBaseInfo,"^",2)
    q:((Name'="")&&(TName'[Name))
    s PreGADM=$P(^DHCPEPreIADM(PreIADM),"^",2)
    s GADM=$P($g(^DHCPEIADM(IADM)),"^",2)
    q:("0"'=+GroupID)&(GroupID'=GADM) 
    q:("ALLI"=GroupID)&(""'=GADM)
    q:("ALLG"=GroupID)&(""=GADM)
   
    s TDepartName=##class(web.DHCPE.PreCommon).GetPosition("PreADM",PreIADM)
    q:((DepartName'="")&&(TDepartName'[DepartName))
    
    i PreGADM'="" d
    .s PreGBI=$p($g(^DHCPEPreGADM(PreGADM)),"^",1)
    .s TGroupName=$p($g(^DHCPEPreGBI(PreGBI)),"^",2)
    s ReportStatus=$p($g(^DHCPERPT(ReportID)),"^",2)
    
    q:((NoFetchReport'="N")&&(ReportStatus'="S"))
    q:((NoFetchReport="N")&&(ReportStatus'="P")&&(ReportStatus'="C"))
    s TReportStatus=##Class(web.DHCPE.Report).GetStatusDesc(ReportStatus,PAADM)
    
    s PAPMI=$p($g(^PAADM(PAADM)),"^",1)
    s SexDR=$p(CurBaseInfo,"^",3)
    s TSex=$p($g(^CT("SEX",SexDR)),"^",2)
    s Birth=$p(CurBaseInfo,"^",4) 
    ;s:Birth'="" TAge=$P(##class(web.DHCLCNUREXCUTE).CalAge(Birth,+$H),"Y",1)
    ;s TAge=##class(web.DHCBillInterface).GetPapmiAge(PAPMI,PAADM)
    s:Birth'="" TBirth=##class(websys.Conversions).DateLogicalToHtml(Birth)
    i PAPMI'="" s TAge=##class(web.DHCBillInterface).GetPapmiAge(PAPMI)
    //s TIDCard=$p(CurBaseInfo,"^",9)
    s PACCardDesc=""
    S PACCardTypeDR=$P($G(^PAPER(PAPMI,"PAT",3)),"^",7)
    I PACCardTypeDR'=""  S PACCardDesc=$p($g(^PAC("CARD",PACCardTypeDR)),"^",2)
    s TIDCard=$P($G(^PAPER(PAPMI,"PAT",3)),"^",6)
    q:(CredNo'="")&&((CredNo'=TIDCard)||(PACCardDesc'["身份证"))
    
    s TelNo=$p(CurBaseInfo,"^",6)
    s:TelNo="" TelNo=$p(CurBaseInfo,"^",7)
    s:TelNo="" TelNo=$p(CurBaseInfo,"^",8)
    
    s TAppDate=$G(^DHCPEDataEx("DHCPEPreIADM","GetReportDateTime","I",PreIADM))
    s:TAppDate'="" TAppDate=##class(websys.Conversions).DateLogicalToHtml(+TAppDate)
    
    s RepoerSend=$p($g(^DHCPEPreIADM(PreIADM)),"^",16)
    s:RepoerSend="AC" TRepoerSend="挂帐取"
    s:RepoerSend="DC" TRepoerSend="结帐取"
    s:RepoerSend="GS" TRepoerSend="统取"
    s:RepoerSend="IS" TRepoerSend="自取"
    s RepoerSend=$g(^DHCPEDataEx("ConfirmRecPaper","SendReport",PreIADM))
    
    i RepoerSend="ZQ" s TRepoerSend="自取"
    i RepoerSend="TQ" s TRepoerSend="统取"
    i RepoerSend="KD" s TRepoerSend="快递"
    i RepoerSend="DZB" s TRepoerSend="电子版"
    s Address=$g(^DHCPEDataEx("ConfirmRecPaper","Remark",PreIADM))
    i NoFetchReport="Y" d
    .s TSendUser=$p($g(^DHCPERPT(ReportID)),"^",8)
    .i TSendUser'="" s TSendUser=$P(^SSU("SSUSR",TSendUser),"^",2)
    .s TSendDate=$p($g(^DHCPERPT(ReportID)),"^",9)
    .s:TSendDate'="" TSendDate=##class(websys.Conversions).DateLogicalToHtml(TSendDate)
    .s TSendTime=$p($g(^DHCPERPT(ReportID)),"^",16)
    .s:TSendTime'="" TSendTime=##class(websys.Conversions).TimeLogicalToHtml(TSendTime)
    d OutPut
    
    q
Clear
    s (TRegNo,TName,TSex,TBirth,TAge,TIDCard,TVIPLevel,PreGBI,TGroupName,TDepartName,ReportStatus,TReportStatus,RepoerSend,TRepoerSend,TAppDate,TSendUser,TSendDate,TSendTime,THPNo,PACCardDesc,Address)=""
    q 
OutPut
    set Data=$lb(ReportID,PreIADM,TRegNo,TName,TSex,TBirth,TAge,TIDCard,TVIPLevel,PreGBI,TGroupName,TDepartName,ReportStatus,TReportStatus,RepoerSend,TRepoerSend,TAppDate,TSendUser,TSendDate,TSendTime,THPNo,PACCardDesc,Address)  
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

ClassMethod SearchFetchReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchFetchReportExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             
        Set AtEnd=1
        Set Row=""
    } Else {            
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind) 
    Quit $$$OK
}

ClassMethod SearchFetchReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchFetchReportExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetRowData(User, rownum)
{
    s DataStr=$g(^DHCPETMPFetchReport(User,"FetchReport","List",rownum))
    q DataStr
}

ClassMethod GetRowLength(User)
{
    s ind=""
    s ind=$o(^DHCPETMPFetchReport(User,"FetchReport","List",ind),-1)
    q ind
}

Query SearchCmopleteReport(StartDate As %String, EndDate As %String, RegNo As %String, NoFetchReport As %String = "", HadSendMessage As %String = "", IFOLD As %String = "", VIPLevel As %String = "", Name As %String = "", GroupID As %String = "", GroupName As %String = "") As %Query(ROWSPEC = "TRegNo:%String,TName:%String,TSex:%String,TBirth:%String,TSendUser:%String,TSendDate:%String,TSendTime:%String,TReportStatus:%String,TAppDate:%String,TTel:%String,THadSendMessage:%String,TSendMessage:%String,TID:%String,TVIPLevel:%String,RptPrtDate:%String,TGroupName:%String,TMessageDate:%String")
{
}

ClassMethod SearchCmopleteReportExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, RegNo As %String, NoFetchReport As %String = "", HadSendMessage As %String = "", IFOLD As %String = "", VIPLevel As %String = "", Name As %String = "", GroupID As %String = "", GroupName As %String = "") As %Status
{


    ;s ^tempdhcpe("CmopleteReport")="StartDate"_StartDate_"  EndDate"_EndDate_"   RegNo"_RegNo_"   NoFetchReport"_NoFetchReport_"  HadSendMessage"_HadSendMessage_"  IFOLD"_IFOLD_"  VIPLevel"_VIPLevel
    Set repid=$I(^CacheTemp)
    s Job=$J
    s ind=1
    
    i StartDate'="" s StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate) 
    i EndDate'="" s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
      
    i StartDate="" s StartDate=+$h
    i EndDate="" s EndDate=+$h 
    i (StartDate>EndDate)
    {
        Set qHandle=$lb(0,repid,0) 
        Quit $$$OK 
    }
    i NoFetchReport'="" d
    .s NoFetchReport="Y"
    e  d
    .s NoFetchReport="N"
    
    i HadSendMessage'="" d
    .s HadSendMessage="1"
    e  d
    .s HadSendMessage="0"
    s Date=EndDate+1
    f  s Date=$O(^DHCPERPT(0,"CompleteDate",Date),-1) q:(Date="")||(Date<StartDate)  d
    .s TSendDate=##class(websys.Conversions).DateLogicalToHtml(Date)
    .s Time=""
    .f  s Time=$O(^DHCPERPT(0,"CompleteDate",Date,Time),-1) q:(Time="")  d
    ..s ID=0
    ..f  s ID=$O(^DHCPERPT(0,"CompleteDate",Date,Time,ID)) q:(ID="")  d
    ...s IADM=$P(^DHCPERPT(ID),"^",1)
    ...q:IADM=""
    ...s Status=$P(^DHCPERPT(ID),"^",2)
    ...q:(Status="A")||(Status="NA")||(Status="P")
    ...q:(NoFetchReport="N")&&(Status="S")
    ...q:(NoFetchReport="Y")&&(Status'="S")
    ...s PIADM=$P(^DHCPEIADM(IADM),"^",4)
    ...s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PEADM",IADM)
    ...q:LocFlag=1 
    ...s TSendUser=$P(^DHCPERPT(ID),"^",12)
    ...i TSendUser'="" s TSendUser=$P(^SSU("SSUSR",TSendUser),"^",2)
    ...s TSendTime=""
    ...s TReportStatus=""
    ...s:Status="S" TReportStatus="已取"
    ...s:Status="C" TReportStatus="已完成"
    ...s TAppDate=$G(^DHCPEDataEx("DHCPEPreIADM","GetReportDateTime","I",PIADM))
    ...s:TAppDate'="" TAppDate=##class(websys.Conversions).DateLogicalToHtml(+TAppDate)
    ...s PIBIDR=$P(^DHCPEPreIADM(PIADM),"^",1)
    ...s PreGAdm=$P(^DHCPEPreIADM(PIADM),"^",2)
    ...q:(GroupID="ALLI")&&(PreGAdm'="")
    ...q:(GroupID="ALLG")&&(PreGAdm="")
    ...q:(GroupID'="")&&(PreGAdm'=GroupID)&&(GroupID'="ALLG")&&(GroupID'="ALLI")
    ...s IFOLDFlag=""
    ...s TGroupName=""
    ...i PreGAdm'="" d
    ....s PreGBaseInfo=$P(^DHCPEPreGADM(PreGAdm),"^",1)
    ....s TGroupName=$P(^DHCPEPreGBI(PreGBaseInfo),"^",2)
    ...s EntDR=##class(web.DHCPE.Query.IAdmItemStatus).GetArcSetDr(PIADM)
    ...s:EntDR'="" IFOLDFlag=$g(^DHCPEDataEx("OrdSetsEx","IFOLD",EntDR))
    ...q:(IFOLDFlag'="Y")&&(IFOLD="on")
    ...
    ...;s TVIPLevel=$p($g(^DHCPEPreIADM(PIADM)),"^",18)
    ...;s:TVIPLevel="" TVIPLevel=$G(^DHCPEVIPLevel("VIPapprove"))
    ...;q:(VIPLevel'="")&&(VIPLevel'=TVIPLevel)
    ...;s TVIPLevel=$P($G(^DHCPEVIPLevel("VIP",TVIPLevel)),"^",2)
    ...s PIADMVIP = ##class(web.DHCPE.PreCommon).GetVIPLevel("Pre",PIADM)
	...s TVIPLevelID=$P(PIADMVIP,"^",1)
	...q:(VIPLevel'="")&&(VIPLevel'=TVIPLevelID)
	...s TVIPLevel=$P(PIADMVIP,"^",2)
    ...
    ...i $D(^User.DHCPENewSendMessageI("TypeSourceIndex","RP",ID)) d
    ....s MessageID=$O(^User.DHCPENewSendMessageI("TypeSourceIndex","RP",ID,""),-1)
    ....s MessageStatus=$LG(^User.DHCPENewSendMessageD(MessageID),13)
    ....s THadSendMessage2="1"
    ....s:MessageStatus=0 THadSendMessage="待发送"
    ....s:MessageStatus=2 THadSendMessage="已发送"
    ....s:MessageStatus=3 THadSendMessage="发送失败"
    ....s TSendMessage="0"
    ....s TDate=$LG(^User.DHCPENewSendMessageD(MessageID),10)
    ....s:TDate'="" TDate=##class(websys.Conversions).DateLogicalToHtml(TDate)
    ....s TTime=$LG(^User.DHCPENewSendMessageD(MessageID),11)
    ....s:TTime'="" TTime=##class(websys.Conversions).TimeLogicalToHtml(TTime)
    ....s TMessageDate=TDate_" "_TTime
    ...e  d
    ....s THadSendMessage="未发送"
    ....s THadSendMessage2="0"
    ....s TSendMessage="1"
    ...q:(HadSendMessage'="0")&(HadSendMessage'=THadSendMessage2)
    ...s RptPrtDate=$P($G(^DHCPERPT(ID)),"^",7)
    ...s RptPrtDate=##class(websys.Conversions).DateLogicalToHtml(RptPrtDate)
    ...d GetPersonInfo4
    
    Set qHandle=$lb(0,repid,0) 
    Quit $$$OK
GetPersonInfo4
    s TRegNo=$p($g(^DHCPEPreIBI(PIBIDR)),"^",1)
    q:(RegNo'="")&&(TRegNo'=RegNo)
    s TName=$p($g(^DHCPEPreIBI(PIBIDR)),"^",2)
    s SexDR=$p($g(^DHCPEPreIBI(PIBIDR)),"^",3)
    s TSex=$p($g(^CT("SEX",SexDR)),"^",2)
    s Age=$p($g(^DHCPEPreIBI(PIBIDR)),"^",4)
    s:Age'="" TBirth=##class(websys.Conversions).DateLogicalToHtml(Age)
    ;s:Age'="" Age=$P(##class(web.DHCLCNUREXCUTE).CalAge(Age,+$H),"Y",1) 
    s Age=""
    s PAPMIRowId=$o(^PAPERi("PAPMI_PatNo",TRegNo,0)) 
    i PAPMIRowId='"" s Age=##class(web.DHCBillInterface).GetPapmiAge(PAPMIRowId)
    s TelNo=$p($g(^DHCPEPreIBI(PIBIDR)),"^",8)
    s:TelNo="" TelNo=$p($g(^DHCPEPreIBI(PIBIDR)),"^",6)
    s:TelNo="" TelNo=$p($g(^DHCPEPreIBI(PIBIDR)),"^",7)

    d OutPut4
    q
Clear4
    s (TRegNo,TName,TSex,TBirth,TSendUser,TSendDate,TSendTime,TReportStatus,TAppDate,RptPrtDate,TMessageDate)=""
    q 
OutPut4
    q:(Name'="")&&(TName'[Name)
    set Data=$lb(TRegNo,TName,TSex,TBirth,TSendUser,TSendDate,TSendTime,TReportStatus,TAppDate,TelNo,THadSendMessage,TSendMessage,ID,TVIPLevel,RptPrtDate,TGroupName,TMessageDate)  
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

ClassMethod SearchCmopleteReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchCmopleteReportExecute ]
{
    
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             
        Set AtEnd=1
        Set Row=""
    }
    Else{           
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind) 
    Quit $$$OK
}

ClassMethod SearchCmopleteReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchCmopleteReportExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query SearchSendAudit(StartDate As %String, EndDate As %String, DoRegNo As %String, NoSend As %String = "", VIPLevel, AutoSend As %String = "", Sex As %String = "", GID As %String = "") As %Query(ROWSPEC = "TRegNo:%String,TName:%String,TSex:%String,TBirth:%String,TSendUser:%String,TSendDate:%String,TSendTime:%String,TReportDate:%String,TAppDate:%String,TNoResultItem:%String,TPAADM:%String,TVIPLevel:%String,TGDesc:%String,TNum:%String,THadRec:%String,TSendAudit:%String,TReportAudit:%String,TMainAudit:%String,TReportPrint:%String,TFetchReport:%String")
{
}

ClassMethod SearchSendAuditExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, DoRegNo As %String, NoSend As %String = "", VIPLevel As %String, AutoSend As %String = "", Sex As %String = "", GID As %String = "") As %Status
{
    s num=0
    Set repid=$I(^CacheTemp)
    s Job=$J
    If $g(ind)="" Set ind=2000
    i StartDate'="" s StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate) 
    i EndDate'="" s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate) 
    
    i StartDate="" s StartDate=+$h
    i EndDate="" s EndDate=+$h 
    
    i (StartDate>EndDate)
    {
        Set qHandle=$lb(0,repid,0) 
        Quit $$$OK 
    }
    
    i NoSend'="" d
    .s NoSend="Y"
    e  d
    .s NoSend="N"
    //s Date=StartDate-1
    
    s Date=StartDate-1
    //e  s Date=0
    
    i NoSend="N"{
    f  s Date=$O(^User.DHCPESendAuditI("SendDateIndex",Date)) q:(Date="")||(Date>EndDate)  d
    .s TSendDate=##class(websys.Conversions).DateLogicalToHtml(Date)
    .s ID=0
    .f  s ID=$O(^User.DHCPESendAuditI("SendDateIndex",Date,ID)) q:(ID="")  d
    ..s PAADM=$LG(^User.DHCPESendAuditD(ID),2)
    ..s TSendUser=$LG(^User.DHCPESendAuditD(ID),3)
    ..i TSendUser'="" s TSendUser=$P(^SSU("SSUSR",TSendUser),"^",2)
    ..s TSendTime=$LG(^User.DHCPESendAuditD(ID),5)
    ..s:TSendTime'="" TSendTime=##class(websys.Conversions).TimeLogicalToHtml(TSendTime)
    ..;s TNoResultItem=##class(web.DHCPE.ResultEdit).GetUnAppedItems("",PAADM)
    ..;s TNoResultItem=$P(TNoResultItem,"^",2)
    ..s TNoResultItem=##class(web.DHCPE.DHCPEIAdm).OutNoCheckItemByPAADMNew(PAADM)
    ..s IADM=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
    ..q:IADM=""
    ..s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PEADM",IADM)
    ..q:LocFlag=1
    ..s PIADM=$P($g(^DHCPEIADM(IADM)),"^",4)
    ..q:PIADM=""
    ..s TReportDate="",TAppDate=""
    ..s TReportDate=$P($G(^DHCPEDataEx("DHCPEPreIADM","GetReportDateTime","I",PIADM)),"^",1)
    ..s:TReportDate'="" TReportDate=##class(websys.Conversions).DateLogicalToHtml(TReportDate)
    ..s TAppDate=$P($G(^DHCPEDataEx("ConfirmRecPaper",PIADM)),"^",1)
    ..s:TAppDate'="" TAppDate=##class(websys.Conversions).DateLogicalToHtml(TAppDate)
    ..s PIBIDR=$P($g(^DHCPEPreIADM(PIADM)),"^",1)
    ..d GetPersonInfo2
    }else{
        //^DHCPEDataEx("ConfirmRecPaper","DateTime",KData,KTime,PIADM)
        f  s Date=$O(^DHCPEDataEx("ConfirmRecPaper","DateTime",Date)) q:(Date="")||(Date>EndDate)  d
        .s TAppDate=##class(websys.Conversions).DateLogicalToHtml(Date)
        .s TSendDate=""
        .s TSendUser=""
        .s TSendTime=""
        .s Time=""
        .f  s Time=$O(^DHCPEDataEx("ConfirmRecPaper","DateTime",Date,Time)) q:(Time="")  d
        ..s PIADM=0
        ..f  s PIADM=$O(^DHCPEDataEx("ConfirmRecPaper","DateTime",Date,Time,PIADM)) q:(PIADM="")  d
        ...s TReportDate=$P($G(^DHCPEDataEx("DHCPEPreIADM","GetReportDateTime","I",PIADM)),"^",1)
        ...s:TReportDate'="" TReportDate=##class(websys.Conversions).DateLogicalToHtml(TReportDate)
        ...s IADM=$O(^DHCPEIADM(0,"CRMADM",PIADM,0))
        ...q:IADM=""
        ...s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PEADM",IADM)
        ...q:LocFlag=1
        ...s PAADM=$P($g(^DHCPEIADM(IADM)),"^",1)
        ...q:$D(^User.DHCPESendAuditI("AdmIndex",PAADM))
        
        ...;s TNoResultItem=##class(web.DHCPE.ResultEdit).GetUnAppedItems("",PAADM)
        ...;s TNoResultItem=$P(TNoResultItem,"^",2)
        ...s TNoResultItem=##class(web.DHCPE.DHCPEIAdm).OutNoCheckItemByPAADMNew(PAADM)
        ...s PIBIDR=$P($g(^DHCPEPreIADM(PIADM)),"^",1)
        ...d GetPersonInfo2
    }
    
    s num=""
    s Name=""
    f  s Name=$O(^TempDHCPESendAudit(Job,Name)) q:Name=""  d
    .d Clear2
    .s TName=Name
    .s TotalEng=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpesendaudit.hisui.csp","合计：")
    .s TRegNo=TotalEng_$G(^TempDHCPESendAudit(Job,Name))
    .d OutPut2
    k ^TempDHCPESendAudit(Job)
    Set qHandle=$lb(0,repid,0) 
    Quit $$$OK
GetPersonInfo2
    s TRegNo=$p($g(^DHCPEPreIBI(PIBIDR)),"^",1)
    
    q:(DoRegNo'="")&&(TRegNo'=DoRegNo)
    /*
    s TVIPLevel=$P($g(^DHCPEPreIADM(PIADM)),"^",18)
    s:TVIPLevel="" TVIPLevel=$G(^DHCPEVIPLevel("VIPapprove"))
    q:(VIPLevel'="")&&(VIPLevel'=TVIPLevel)
    s:TVIPLevel'="" TVIPLevel=$P($g(^DHCPEVIPLevel("VIP",TVIPLevel)),"^",2)
    */
    s PIADMVIP = ##class(web.DHCPE.PreCommon).GetVIPLevel("Pre",PIADM)
	s TVIPLevelID=$P(PIADMVIP,"^",1)
	q:(VIPLevel'="")&&(VIPLevel'=TVIPLevelID)
	s TVIPLevel=$P(PIADMVIP,"^",2)
	s TVIPLevel=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEVIPLevel",TVIPLevel,"VLDesc","cls")
    s TName=$p($g(^DHCPEPreIBI(PIBIDR)),"^",2)
    s SexDR=$p($g(^DHCPEPreIBI(PIBIDR)),"^",3)
    q:(Sex'="")&&(SexDR'=Sex)
    s TSex=$p($g(^CT("SEX",SexDR)),"^",2)
    s TSex=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.CTSex",TSex,"CTSEXDesc","cls")
    s Age=$p($g(^DHCPEPreIBI(PIBIDR)),"^",4) 
    s:Age'="" TBirth=##class(websys.Conversions).DateLogicalToHtml(Age)
    //s:Age'="" Age=$P(##class(web.DHCLCNUREXCUTE).CalAge(Age,+$H),"Y",1) 
    i TRegNo'="" s PAPMIDR=$O(^PAPERi("PAPMI_PatNo",TRegNo,0))
    s:PAPMIDR'="" Age=##class(web.DHCBillInterface).GetPapmiAge(PAPMIDR)
    s TelNo=$p($g(^DHCPEPreIBI(PIBIDR)),"^",6)
    s:TelNo="" TelNo=$p($g(^DHCPEPreIBI(PIBIDR)),"^",7)
    s:TelNo="" TelNo=$p($g(^DHCPEPreIBI(PIBIDR)),"^",8)
    s GName=""
    s PGADMID=$P($g(^DHCPEPreIADM(PIADM)),"^",2)
    q:(GID'="")&&(GID'="ALLI")&&(GID'="ALLG")&&(GID'=PGADMID)
    q:(GID="ALLI")&&(PGADMID'="")
    q:(GID="ALLG")&&(PGADMID="")
    //GADMID="ALLI"
    
    i PGADMID'="" d 
    .s GNameDR=$p($g(^DHCPEPreGADM(PGADMID)),"^",1)
    .s GName=$p($g(^DHCPEPreGBI(GNameDR)),"^",2) 
    //q:(GDesc'="")&&('(GName[GDesc)) 
    //s ReportStatus=..GetReportStatusNew(PAADM)
    s TReportStatus=##class(web.DHCPE.FetchReport).GetReportStatus(PAADM)
    s THadRec=$p(TReportStatus,"^",1)
    s TSendAudit=$p(TReportStatus,"^",2)
    s TReportAudit=$p(TReportStatus,"^",3)
    s TMainAudit=$p(TReportStatus,"^",4)
    s TReportPrint=$p(TReportStatus,"^",5)
    s TFetchReport=$p(TReportStatus,"^",6)

    S num=num+1
    i GName="" d
    .s PersonEng=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpesendaudit.hisui.csp","个人")
    .s ^TempDHCPESendAudit(Job,PersonEng)=$G(^TempDHCPESendAudit(Job,PersonEng))+1
    e  d
    .s ^TempDHCPESendAudit(Job,GName)=$G(^TempDHCPESendAudit(Job,GName))+1
    
    
    d OutPut2
    q
Clear2
    s (TRegNo,TName,TSex,TBirth,TSendUser,TSendDate,TSendTime,TReportDate,TAppDate,TNoResultItem,PAADM,TVIPLevel,GName,THadRec,TSendAudit,TReportAudit,TMainAudit,TReportPrint,TFetchReport)=""
    q 
OutPut2
    set Data=$lb(TRegNo,TName,TSex,TBirth,TSendUser,TSendDate,TSendTime,TReportDate,TAppDate,TNoResultItem,PAADM,TVIPLevel,GName,num,THadRec,TSendAudit,TReportAudit,TMainAudit,TReportPrint,TFetchReport) 
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

ClassMethod SearchSendAuditFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchSendAuditExecute ]
{
    
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             
        Set AtEnd=1
        Set Row=""
    }
    Else{           
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind) 
    Quit $$$OK
}

ClassMethod SearchSendAuditClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchSendAuditExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod OutPutSpecial(StartDate As %String, EndDate As %String, Item As %String, Status As %String = "", ShowCollect As %String = "", PreDate As %String = "", VIPLevel As %String = "", RegNo As %String = "", StationID As %String = "") As %Status
{

    ;Set repid=$I(^CacheTemp)
    s Job=$J
    ;If $g(ind)="" Set ind=2000
    s Datas=""
    s UserID=%session.Get("LOGON.USERID")
    i RegNo'="" s RegNo=##class(web.DHCPE.DHCPECommon).RegNoMask(RegNo)
    If (RegNo'="")&&(+RegNo'=0)  d
    .Set PIBI=$o(^DHCPEPreIBI(0,"PAPMINo",RegNo,0))
    .Quit:PIBI=""
    .Set PIADM=""
    .For  Set PIADM=$o(^DHCPEPreIADM(0,"PIBI",PIBI,PIADM),-1)  Quit:PIADM=""  Do
    ..Set IAdmId=""
    ..For  Set IAdmId=$o(^DHCPEIADM(0,"CRMADM",PIADM,IAdmId),-1)  Quit:IAdmId=""  Do
    ...Do GetIADMInfo
    e  d
    .
    .d GetInfoBYDate
    .
    s CurStatus=""
    f  s CurStatus=$O(^TempDHCPESpecialItem(Job,CurStatus)) q:CurStatus=""  d
    .s:CurStatus=0 StatusDesc="未登记"
    .s:CurStatus=1 StatusDesc="未完成"
    .s:CurStatus=3 StatusDesc="谢绝检查"
    .s:CurStatus=6 StatusDesc="已完成"
    .d Clear3
    .s TItem=StatusDesc
    .d OutPut3
    .s ItemMastID=""
    .f  s ItemMastID=$O(^TempDHCPESpecialItem(Job,CurStatus,ItemMastID)) q:ItemMastID=""  d
    ..//判断特殊项目是否有权限
    ..q:($g(^DHCPESpecialContral("DHCPEXH",UserID,ItemMastID))'="Y")
    ..q:(StationID'="")&&($o(^DHCPEST(0,"STORD_ARCIM",ItemMastID,0))'=StationID)
    ..d Clear3
    ..s Total=$O(^TempDHCPESpecialItem(Job,CurStatus,ItemMastID,""),-1)
    ..s TItem=##class(web.DHCPE.DHCPECommon).GetArcDesc(ItemMastID)
    ..s TRegNo=Total
    ..; 
    ..i ShowCollect="Y"   d         
    ...d OutPut3  
    ..;update by sun 20131019
    ..q:ShowCollect="Y"
    ..s Sort=""
    ..f  s Sort=$O(^TempDHCPESpecialItem(Job,CurStatus,ItemMastID,Sort)) q:Sort=""  d
    ...s Info=$G(^TempDHCPESpecialItem(Job,CurStatus,ItemMastID,Sort))
    ...s TArrivedDate=$P(Info,"^",2)
    ...s OIID=$P(Info,"^",1)
    ...i OIID'="" d
    ....s PAADM=$P(^OEORD(+OIID),"^",1)
    ....s RLTID=$O(^DHCPERLT(0,"OEORI",OIID,0))
    ....i RLTID'="" d
    .....s TCheckDate=$P(^DHCPERLT(RLTID),"^",6)
    .....s:TCheckDate'="" TCheckDate=$ZD(TCheckDate,3)
    ....d GetPersonInfo3
    ...e  d
    ....s PreItemID=$P(Info,"^",3)
    ....d GetPersonInfoByPre
    k ^TempDHCPESpecialItem(Job)
    q Datas
    ;Set qHandle=$lb(0,repid,0) 
    ;Quit $$$OK

GetInfoBYDate
    i StartDate="" s StartDate=+$h
    i EndDate="" s EndDate=+$h 
    i (StartDate>EndDate)  d
    .q
    
    /*{
        Set qHandle=$lb(0,repid,0) 
        Quit $$$OK 
    }*/
    
    ;s ^sxt("ddd")=RegNo
    i ShowCollect'="" d
    .s ShowCollect="Y"
    e  d
    .s ShowCollect="N"
    s Job=$J
    s Date=StartDate-1
    i PreDate=""
    {
        f  s Date=$O(^User.DHCPECurDateAdmInfoI("DateAdmIndex",Date)) q:(Date="")||(Date>EndDate)  d
        .s ArriveDate=$ZD(Date,3)
        .s Adm=""
        .f  s Adm=$O(^User.DHCPECurDateAdmInfoI("DateAdmIndex",Date,Adm)) q:(Adm="")  d
        ..s IADM=$O(^DHCPEIADM(0,"PAADM",Adm,0))
        ..s AdmStatus=$P(^DHCPEIADM(IADM),"^",8)
        ..q:AdmStatus'="ARRIVED"
        ..s PADM=$P(^DHCPEIADM(IADM),"^",4)
        ..s TVIPLevel=$P(^DHCPEPreIADM(PADM),"^",18)
        ..q:(VIPLevel'="")&&(TVIPLevel'=VIPLevel)
        
        ..s Order=""
        ..s Order=$O(^OEORD(0,"Adm",Adm,0))
        ..q:Order=""
        ..s Sub="0"
        ..f  s Sub=$O(^OEORD(Order,"I",Sub)) q:Sub=""  d
        ...q:'$D(^OEORD(Order,"I",Sub,1))
        ...s CurStatus=$P(^OEORD(Order,"I",Sub,1),"^",13)
        ...q:CurStatus="4"
        ...s ItemMastID=$P(^OEORD(Order,"I",Sub,1),"^",2)
        ...s Flag=$G(^DHCPECTDataEx("DHCPEStationOrder","SignItem",ItemMastID))
        ...q:Flag'="Y"
        ...q:(Item'="")&&(ItemMastID'=Item)
        ...s OrdItemID=Order_"||"_Sub
        ...i CurStatus=1 d ;核实
        ....s:$D(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OrdItemID)) CurStatus="3" ;谢绝检查
        ...q:(CurStatus'=Status)&&(Status'="")
        ...s Sort=$I(^TempDHCPESpecialItem(Job,CurStatus,ItemMastID))
        ...s ^TempDHCPESpecialItem(Job,CurStatus,ItemMastID,Sort)=OrdItemID_"^"_ArriveDate
    }
    else
    {
        f  s Date=$O(^DHCPEPreIADM(0,"BookDateTime",Date)) q:(Date="")||(Date>EndDate)  d
        .s ArriveDate=$ZD(Date,3)
        .s EDate=""
        .f  s EDate=$O(^DHCPEPreIADM(0,"BookDateTime",Date,EDate)) q:(EDate="")  d
        ..s Time=""
        ..f  s Time=$O(^DHCPEPreIADM(0,"BookDateTime",Date,EDate,Time)) q:(Time="")  d
        ...s PADM=""
        ...f  s PADM=$O(^DHCPEPreIADM(0,"BookDateTime",Date,EDate,Time,PADM)) q:(PADM="")  d
        ....s ADMStatus=$P(^DHCPEPreIADM(PADM),"^",8)
        ....q:ADMStatus="CANCELPE"
        ....//q:AdmStatus'="ARRIVED"
        ....s TVIPLevel=$P(^DHCPEPreIADM(PADM),"^",18)
        ....q:(VIPLevel'="")&&(TVIPLevel'=VIPLevel)
        ....s Sub=0
        ....f  s Sub=$O(^DHCPEPreIADM(PADM,"ORDITEM",Sub)) q:Sub=""  d
        .....s Stat=$P($g(^DHCPEPreIADM(PADM,"ORDITEM",Sub)),"^",16)
        .....q:Stat'="1"
        .....s ItemMastID=$P(^DHCPEPreIADM(PADM,"ORDITEM",Sub),"^",1)
        .....s Flag=$G(^DHCPECTDataEx("DHCPEStationOrder","SignItem",ItemMastID))
        .....q:Flag'="Y"
        .....q:(Item'="")&&(ItemMastID'=Item)
        .....s CurStatus=0
        .....s PItemID=PADM_"||"_Sub
        .....s CRMItemID=$O(^DHCPECRMO(0,"CRMORI",PItemID,0))
        .....s OEID=""
        .....s:CRMItemID'="" OEID=$P(^DHCPECRMO(CRMItemID),"^",1)
        .....i OEID'=""  d
        ......s CurStatus=$P(^OEORD(+OEID,"I",$P(OEID,"||",2),1),"^",13)
        ......i CurStatus=1 d ;核实
        .......s:$D(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OEID)) CurStatus="3" ;谢绝检查
        .....q:(CurStatus'=Status)&&(Status'="")
        .....s Sort=$I(^TempDHCPESpecialItem(Job,CurStatus,ItemMastID))
        .....s ^TempDHCPESpecialItem(Job,CurStatus,ItemMastID,Sort)=OEID_"^"_ArriveDate_"^"_PItemID
    }
    q

GetIADMInfo
    q:(IAdmId="")
    s PAADM=$P(^DHCPEIADM(IAdmId),"^",1)
    s Info=##class(web.DHCPE.AdmRecordManager).GetBaseInfo(PAADM)
    s PADM=$P(^DHCPEIADM(IAdmId),"^",4)
    
    s ArriveDate=$zd($p(^DHCPEPreIADM(PADM),"^",4))
    s TVIPLevel=$P(^DHCPEPreIADM(PADM),"^",18)
    ;TItem,TRegNo,TName,TGroup,TTel,TArrivedDate,TCheckDate
    s TRegNo=$p(Info,"^",5)
    s TName=$p(Info,"^",1)
    s TTel=$p(Info,"^",6)
    s TGroup=$p(Info,"^",7)
    s Sub=0
    f  s Sub=$O(^DHCPEPreIADM(PADM,"ORDITEM",Sub)) q:Sub=""  d
    .s Stat=$P($G(^DHCPEPreIADM(PADM,"ORDITEM",Sub)),"^",16)
    .q:Stat'="1"
    .s ItemMastID=$P(^DHCPEPreIADM(PADM,"ORDITEM",Sub),"^",1)
    .s Flag=$G(^DHCPECTDataEx("DHCPEStationOrder","SignItem",ItemMastID))
    .q:Flag'="Y"
    .q:(Item'="")&&(ItemMastID'=Item)
    .q:(StationID'="")&&($o(^DHCPEST(0,"STORD_ARCIM",ItemMastID,0))'=StationID)
    .s CurStatus=0
    .s PItemID=PADM_"||"_Sub
    .s CRMItemID=$O(^DHCPECRMO(0,"CRMORI",PItemID,0))
    .s OEID=""
    .s:CRMItemID'="" OEID=$P(^DHCPECRMO(CRMItemID),"^",1)
    .i OEID'=""  d
    ..s CurStatus=$P(^OEORD(+OEID,"I",$P(OEID,"||",2),1),"^",13)
    ..i CurStatus=1 d ;核实
    ...s:$D(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OEID)) CurStatus="3" ;谢绝检查
    .q:(CurStatus'=Status)&&(Status'="")
    .s Sort=$I(^TempDHCPESpecialItem(Job,CurStatus,ItemMastID))
    .s ^TempDHCPESpecialItem(Job,CurStatus,ItemMastID,Sort)=OEID_"^"_ArriveDate_"^"_PItemID
    ;d OutPut3
    

GetPersonInfo3
    s Flag=0
    ;PatName_"^"_Sex_"^"_Birth_"^"_IDCard_"^"_RegNo_"^"_Tel
    
    s Info=##class(web.DHCPE.AdmRecordManager).GetBaseInfo(PAADM)
    s IADM=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
    s PADM=$P(^DHCPEIADM(IADM),"^",4)
    s AdmID=$P(^DHCPEIADM(IADM),"^",1)
    s TVIPLevel=$P(^DHCPEPreIADM(PADM),"^",18)
    ;s ^sxt("dd")=PADM
    i (TVIPLevel'="")&&(+TVIPLevel'=0)  d
    .s:($P($g(^DHCPEVIPLevel("VIP",TVIPLevel)),"^",2)[("VIP")) Flag=1
    s AsCharged=$P(^DHCPEPreIADM(PADM),"^", 9)
    
    i ((AsCharged'="Y")&&(Flag'=1))  d
    .s AuditID=0
    .f  s AuditID=$O(^DHCPEPreA(0,"CRMADM","I",PADM,AuditID)) q:(AuditID="")||(Flag=1)  d
    ..s Amount=+$P(^DHCPEPreA(AuditID),"^",9)
    ..q:Amount=0
    ..s UseFlag=$P(^DHCPEPreA(AuditID),"^",21)
    ..q:UseFlag="NU"
    ..s ChargeFlag=$P(^DHCPEPreA(AuditID),"^",14)
    ..q:ChargeFlag="CHARGED"
    ..s Flag=1
    s:(Flag=1) TPosition=""
    s:(Flag=0) TPosition=##class(web.DHCPE.RoomManager).GetAdmCurRoom(AdmID,"ADM","")
    
    s TPosition=$p(TPosition,"^",2)
    ;TItem,TRegNo,TName,TGroup,TTel,TArrivedDate,TCheckDate
    s TRegNo=$p(Info,"^",5)
    s TName=$p(Info,"^",1)
    s TTel=$p(Info,"^",6)
    s TGroup=$p(Info,"^",7)
    d OutPut3
    q
GetPersonInfoByPre
    s PADM=+PreItemID
    s Obj=##class(User.DHCPEPreIADM).%OpenId(PADM)
    s TRegNo=Obj.PIADMPIBIDR.PIBIPAPMINo
    s TName=Obj.PIADMPIBIDR.PIBIName
    s TTel=Obj.PIADMPIBIDR.PIBIMobilePhone
    s:TTel="" TTel=Obj.PIADMPIBIDR.PIBITel1
    s:TTel="" TTel=Obj.PIADMPIBIDR.PIBITel2
    s TGroup=Obj.PIADMPGADMDR.PGADMPGBIDR.PGBIDesc
    s TVIPLevel=Obj.PIADMVip
    d OutPut3
    q
Clear3
    s (TItem,TRegNo,TName,TGroup,TTel,TArrivedDate,TCheckDate,OIID,TVIPLevel,TReCheck,TPosition)=""
    q 
OutPut3
    q:((RegNo'="")&&(RegNo'=TRegNo))
    i OIID'="" s OIID=OIID_"^"_CurStatus
    s:TVIPLevel'="" TVIPLevel=$P(^DHCPEVIPLevel("VIP",TVIPLevel),"^",2)
    s TReCheck=""
    s:PADM'="" TReCheck=##class(web.DHCPE.PreCommon).IsReCheck(PADM,"Pre")
    s:TReCheck="1" TReCheck="是"
    s:TReCheck="0" TReCheck="否"
    s:TName="" TReCheck=""
    ;w:TName'="" TReCheck
    set Data=TItem_"^"_TRegNo_"^"_TName_"^"_TGroup_"^"_TTel_"^"_TArrivedDate_"^"_TCheckDate_"^"_TVIPLevel_"^"_TReCheck 
    ;Set ^CacheTemp(repid,ind)=Data
    ;Set ind=ind+1
    s Datas=Datas_"$$"_Data
    q
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.FetchReport","SearchSpecialItem","2022-02-01","2022-02-18","","","","","","","")
Query SearchSpecialItem(StartDate As %String, EndDate As %String, Item As %String, Status As %String = "", VIPLevel As %String = "", RegNo As %String = "", StationID As %String = "", UserNo As %String = "", Name As %String = "", LocID As %String = "", UserID As %String = "") As %Query(ROWSPEC = "TItem:%String,TRegNo:%String,TName:%String,TGroup:%String,TTel:%String,TArrivedDate:%String,TCheckDate:%String,TOIID:%String,TVIPLevel:%String,TReCheck:%String,TPosition:%String,TReCheck:%String,TAge:%String,PIADMPIBIDRSEX:%String,CardID:%String,UserName:%String,THPNo:%String,TBirth:%String,TReportDate:%String,Feestatus:%String,PACCardDesc:%String")
{
}

ClassMethod SearchSpecialItemExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, Item As %String, Status As %String = "", VIPLevel As %String = "", RegNo As %String = "", StationID As %String = "", UserNo As %String = "", Name As %String = "", LocID As %String = "", UserID As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=2000
    
    s ^tempdhcpe("Specail")=$lb(StartDate,EndDate,Item,Status,VIPLevel,RegNo,StationID,UserNo,Name,LocID,UserID)
   
    i StartDate'="" s StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
    i EndDate'=""   s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
    i StartDate="" s StartDate=+$h
    i EndDate="" s EndDate=+$h
    i (StartDate>EndDate) {
        Set qHandle=$lb(0,repid,0) 
        Quit $$$OK 
    }
    i UserID="" {
    	s:'$d(%session) UserID=11849
    	s:$d(%session) UserID=%session.Get("LOGON.USERID")
    }
    
    s ExportName="DHCPESpecial"
    k ^TempDHCPEExportCommon(UserID,ExportName)
    s Job=$J
    k ^TempDHCPESpecialItem(Job)
    
    if ((RegNo'="")&&(+RegNo'=0)) {
        s PIBI=$o(^DHCPEPreIBI(0,"PAPMINo",RegNo,0))
        q:PIBI=""
        s PIADM=""
        f  s PIADM=$o(^DHCPEPreIADM(0,"PIBI",PIBI,PIADM),-1) q:PIADM=""  d
        .s IADM=""
        .f  s IADM=$o(^DHCPEIADM(0,"CRMADM",PIADM,IADM),-1) q:IADM=""  d
        ..d GetIADMInfo
    } elseif (Name'="") {
        s Name=$$ALPHAUP^SSUTIL4(Name)
        s NameIndex=$O(^DHCPEPreIBI(0,"Name",Name),-1)
        f  s NameIndex=$O(^DHCPEPreIBI(0,"Name",NameIndex)) q:(NameIndex="")||(NameIndex'[Name)  d
        .s PIBI=""
        .f  s PIBI=$o(^DHCPEPreIBI(0,"Name",NameIndex,PIBI),-1) q:PIBI=""  d
        ..s PIADM=""
        ..f  s PIADM=$o(^DHCPEPreIADM(0,"PIBI",PIBI,PIADM),-1) q:PIADM=""  d
        ...s IADM=""
        ...f  s IADM=$o(^DHCPEIADM(0,"CRMADM",PIADM,IADM),-1) q:IADM=""  d
        ....d GetIADMInfo
    } else {
        s Date=StartDate-1
        
        f  s Date=$O(^DHCPEIADM(0,"AdmDateTime",Date)) q:(Date="")||(Date>EndDate)  d
        .s ArriveDate=##class(websys.Conversions).DateLogicalToHtml(Date)
        .s Time=""
        .f  s Time=$O(^DHCPEIADM(0,"AdmDateTime",Date,Time)) q:(Time="")  d
        ..s IADM=""
        ..f  s IADM=$O(^DHCPEIADM(0,"AdmDateTime",Date,Time,IADM)) q:(IADM="")  d
        ...d GetIADMInfo
    }
    
    
    s CurStatus1=""
    f  s CurStatus1=$o(^TempDHCPESpecialItem(Job,CurStatus1)) q:CurStatus1=""  d
    .s:CurStatus1=0 StatusDesc="未登记"
    .s:CurStatus1=1 StatusDesc="未完成"
    .s:CurStatus1=3 StatusDesc="谢绝检查"
    .s:CurStatus1=6 StatusDesc="已完成"
    .;q:CurStatus1="3"
    .d Clear3
    .s TItem=StatusDesc
    .d OutPut3
    .s STSort=""
    .f  s STSort=$O(^TempDHCPESpecialItem(Job,CurStatus1,STSort)) q:STSort=""  d
    ..s ItemMastID=""
    ..f  s ItemMastID=$O(^TempDHCPESpecialItem(Job,CurStatus1,STSort,ItemMastID)) q:ItemMastID=""  d
    ...;q:($g(^DHCPESpecialContral("DHCPEXH",UserID,ItemMastID))'="Y")  // 判断特殊项目是否有权限
    .../***多院区 start***/
    ...s StatOrderID=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ItemMastID,LocID)
    ...q:StatOrderID="" 
    ...s SPecID=$o(^CF.PE.SpecialContralI("IdxOfLocUserOrder"," "_LocID," "_UserID,StatOrderID,""))
	...q:SPecID=""
	...s SCActive=$lg($g(^CF.PE.SpecialContralD(SPecID)),5)
	...q:SCActive'="Y"
	.../***多院区 end***/
    ...d Clear3
    ...s Total=$G(^TempDHCPESpecialItem(Job,CurStatus1,ItemMastID))
    ...s TItem=##class(web.DHCPE.DHCPECommon).GetArcDesc(ItemMastID,"A",LocID)
    ...s TRegNo="合计: "_Total _" 人"  
    ...d OutPut3
    ...s Sort=""
    ...f  s Sort=$O(^TempDHCPESpecialItem(Job,CurStatus1,STSort,ItemMastID,Sort)) q:Sort=""  d
    ....s Info=$G(^TempDHCPESpecialItem(Job,CurStatus1,STSort,ItemMastID,Sort))
    ....s OIID=$P(Info,"^",1)
    ....s TArrivedDate=$P(Info,"^",2)
    ....s PreItemID=$P(Info,"^",3)
    ....s TItem=##class(web.DHCPE.DHCPECommon).GetArcDesc(ItemMastID)
    ....
    ....s TCheckDate=""
    ....i OIID'="" d
    .....s PAADM=$P($g(^OEORD(+OIID)),"^",1)
    .....s RLTID=$O(^DHCPERLT(0,"OEORI",OIID,0))
    .....s TCheckDate=""
    .....i RLTID'="" d
    ......s TCheckDate=$P($g(^DHCPERLT(RLTID)),"^",6)
    ......s:TCheckDate'="" TCheckDate=##class(websys.Conversions).DateLogicalToHtml(TCheckDate)
    ....d GetAdmInfo3
    
    k ^TempDHCPESpecialItem(Job)
    
    Set qHandle=$lb(0,repid,0) 
    Quit $$$OK
    
GetIADMInfo
   
    s PreIADM=$p($g(^DHCPEIADM(IADM)),"^",4)
    s LocID=$P($g(^DHCPEPreIADM(PreIADM)),"^",26) //就诊科室ID
    s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PreADM",PreIADM)
    ;q:LocFlag=1
    s TVIPLevel=$P($g(^DHCPEPreIADM(PreIADM)),"^",18)
    q:(VIPLevel'="")&&(TVIPLevel'=VIPLevel)
    s AdmStatus=$P($g(^DHCPEIADM(IADM)),"^",8)
    q:AdmStatus'="ARRIVED"
    s PIBI=$p($g(^DHCPEPreIADM(PreIADM)),"^",1)
    q:((RegNo'="")&&(RegNo'=$p($g(^DHCPEPreIBI(PIBI)),"^",1)))
    q:((Name'="")&&($$ALPHAUP^SSUTIL4($p($g(^DHCPEPreIBI(PIBI)),"^",2))'[$$ALPHAUP^SSUTIL4(Name)))
    s AdmDate=$p($g(^DHCPEIADM(IADM)),"^",5)
    q:((AdmDate'="")&&((AdmDate<StartDate)||(AdmDate>EndDate)))
    s ArriveDate=##class(websys.Conversions).DateLogicalToHtml(AdmDate)
    s Sub=0
    f  s Sub=$o(^DHCPEPreIADM(PreIADM,"ORDITEM",Sub)) q:Sub=""  d
    .s Stat=$p($g(^DHCPEPreIADM(PreIADM,"ORDITEM",Sub)),"^",16)
    .q:Stat'="1"
    .s ItemMastID=$p($g(^DHCPEPreIADM(PreIADM,"ORDITEM",Sub)),"^",1)
    .q:((Item'="")&&(ItemMastID'=Item))
    .;s STID=$O(^DHCPEST(0,"STORD_ARCIM",ItemMastID,0))
    .
    ./***多院区  start***/
	.S StatOrderID=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ItemMastID,LocID)
	.q:StatOrderID=""
	.s STID=$p(StatOrderID,"||",1)
	./***多院区  end***/
	.
    .q:STID=""
    .q:((StationID'="")&&(STID'=StationID))
    .;s SignItem=$g(^DHCPECTDataEx("DHCPEStationOrder","SignItem",ItemMastID))
    .
    ./***多院区  start***/
    .s SOSID=$o(^CF.PE.StationOrderSetI("IdxOfLocOrder"," "_LocID,StatOrderID,0))
    .s SignItem=""
    .i SOSID'="" s SignItem=$lg($g(^CF.PE.StationOrderSetD(SOSID)),20) //特殊检查
    ./***多院区  end***/
    .
    .q:SignItem'="Y"
    .s CurStatus=0
    .s PItemID=PreIADM_"||"_Sub
    .s CRMItemID=$o(^DHCPECRMO(0,"CRMORI",PItemID,0))
    .s OEID=""
    .s:CRMItemID'="" OEID=$p($g(^DHCPECRMO(CRMItemID)),"^",1)
    .i OEID'=""  d
    ..s CurStatus=$P($g(^OEORD(+OEID,"I",$P(OEID,"||",2),1)),"^",13)
    ..i CurStatus=1 d ;核实
    ...s:$d(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OEID)) CurStatus="3" ;谢绝检查
    .q:(CurStatus'=Status)&&(Status'="")
    .
    .s (UserName,UserInit)=""
    .i OEID'=""  d
    ..s user=+$g(^DHCPESpecial("DHCPE","UserID",OEID))
    ..i (user'="") d
    ...s UserName=$p($g(^SSU("SSUSR",user)),"^",2)
    ...s UserInit=$p($g(^SSU("SSUSR",user)),"^",1)

    .;q:(UserName'="")&&(UserNo'="")&&(UserName'[UserNo)&&(UserInit'[UserNo)
    .q:(UserNo'="")&&(UserName'[UserNo)&&(UserInit'[UserNo)
    .
    .;s STSort=$P($g(^DHCPEST(STID)),"^",9)
    .
    ./***多院区 start***/
	.s STSetID=$o(^CF.PE.StationSetI("IdxOfLocStation"," "_LocID,STID,0))
	.q:STSetID=""
    .s STSort=$lg($g(^CF.PE.StationSetD(STSetID)),9) //报告顺序
	./***多院区 end***/
	.
    .s:STSort="" STSort="999999999"
    .s Sort=$I(^TempDHCPESpecialItem(Job,CurStatus,ItemMastID))
   
    .s ^TempDHCPESpecialItem(Job,CurStatus,STSort,ItemMastID,Sort)=OEID_"^"_ArriveDate_"^"_PItemID
    
    q
GetAdmInfo3
    s PADM=+PreItemID
    s PreIBI=$p($g(^DHCPEPreIADM(PADM)),"^",1)
    s BaseInfo=$g(^DHCPEPreIBI(PreIBI))
    s TRegNo=$p(BaseInfo,"^",1)
    s TName=$p(BaseInfo,"^",2)
    s TSex=$p(BaseInfo,"^",1)
    s:TSex'="" TSex=$p($g(^CT("SEX",TSex)),"^",2)
    s TDOB=$p(BaseInfo,"^",4),TAge=""
    s:(TDOB'="") TAge=$P(##class(web.DHCLCNUREXCUTE).CalAge(TDOB,+$H),"Y",1)
    s:(TDOB'="") TAge=##class(websys.Conversions).DateLogicalToHtml(TDOB)
    s TTel=$p(BaseInfo,"^",8)
    s:TTel="" TTel=$p(BaseInfo,"^",6)
    s:TTel="" TTel=$p(BaseInfo,"^",7)
    s TVIPLevel=$p($g(^DHCPEPreIADM(PADM)),"^",18)
    ;s:TVIPLevel'="" TVIPLevel=$P(^DHCPEVIPLevel("VIP",TVIPLevel),"^",2)
    s:TVIPLevel'="" TVIPLevel=$lg($g(^CT.PE.VIPLevelD(TVIPLevel)),3)
    s THPNo=$p($g(^DHCPEPreIADM(PADM)),"^",27)
    s GIADM=$P($g(^DHCPEPreIADM(PADM)),"^",2)
    i GIADM'="" d
    .s GBID=$P($g(^DHCPEPreGADM(GIADM)),"^",1)
    .s TGroup=$P($g(^DHCPEPreGBI(GBID)),"^",2)
    e  d
    .s TGroup=""
    
    // 获取 当前诊室
    s TPosition=""
    i OIID'=""  d
    .s Flag=0
    .s PAADM=$P($g(^OEORD(+OIID)),"^",1)
    .s AsCharged=$P($g(^DHCPEPreIADM(PADM)),"^", 9)
    .i ((AsCharged'="Y")&&(Flag'=1))  d
    ..s AuditID=0
    ..f  s AuditID=$O(^DHCPEPreA(0,"CRMADM","I",PADM,AuditID)) q:(AuditID="")||(Flag=1)  d
    ...s Amount=+$P($g(^DHCPEPreA(AuditID)),"^",9)
    ...q:Amount=0
    ...s UseFlag=$P($g(^DHCPEPreA(AuditID)),"^",21)
    ...q:UseFlag="NU"
    ...s ChargeFlag=$P($g(^DHCPEPreA(AuditID)),"^",14)
    ...q:ChargeFlag="CHARGED"
    ...s Flag=1
    .s:(Flag=1) TPosition=""
    .s:(Flag=0) TPosition=##class(web.DHCPE.RoomManager).GetAdmCurRoom(PAADM,"ADM","")
    .s TPosition=$p(TPosition,"^",2)
    
    s UserName="",UserInit="",TReportDate="",Feestatus=""
    i OIID'=""  d
    .s user=+$g(^DHCPESpecial("DHCPE","UserID",OIID))
    .i (user'="") d
    ..s UserName=$p($g(^SSU("SSUSR",user)),"^",2)
    ..s UserInit=$p($g(^SSU("SSUSR",user)),"^",1)
    .i $D(^DHCPESpecial("DHCPE","Report",OIID)) d
    ..s TReportDate=$P(^DHCPESpecial("DHCPE","Report",OIID),"^",2)
    ..s:TReportDate'="" TReportDate=##class(websys.Conversions).DateLogicalToHtml(TReportDate)
    .s CRMORowId=$o(^DHCPECRMO(0,"OEORI",OIID,0))
    .s Feestatus=$p($g(^DHCPECRMO(CRMORowId)),"^",4)
    .s TCheckDate=$P($g(^DHCPESpecial("DHCPE","UserID",OIID)),"^",2)
    .s:TCheckDate'="" TCheckDate=##class(websys.Conversions).DateLogicalToHtml(TCheckDate)
    .s OIID=OIID_"^"_CurStatus1
    
    s TReCheck=##class(web.DHCPE.PreCommon).IsReCheck(PADM,"Pre")
    s:TReCheck="1" TReCheck="是"
    s:TReCheck="0" TReCheck="否"
    
    //证件类型 证件号
    s CardID="",PACCardDesc="",PACCardTypeDR=""
    i TRegNo'="" d
    .S PACCardTypeDR=$P($G(^PAPER($o(^PAPERi("PAPMI_PatNo",TRegNo,0)),"PAT",3)),"^",7)
    .I PACCardTypeDR'=""  S PACCardDesc=$p($g(^PAC("CARD",PACCardTypeDR)),"^",2)
    .s CardID=$P($G(^PAPER($o(^PAPERi("PAPMI_PatNo",TRegNo,0)),"PAT",3)),"^",6)
    ;s CardID=$p($g(^DHCPEPreIBI(PIBIID)),"^",9)
    
    s:TName="" TReCheck=""
    d OutPut3

Clear3
    s (TItem,TRegNo,TName,TGroup,TTel,TArrivedDate,TCheckDate,OIID,TVIPLevel,TReCheck,TPosition,TAge,TSex,CardID,PADM,THPNo,TCheckDate,TReportDate,Feestatus,PACCardDesc)=""
    
    q
OutPut3 
    set Data=$lb(TItem,TRegNo,TName,TGroup,TTel,TArrivedDate,TCheckDate,OIID,TVIPLevel,TReCheck,TPosition,TReCheck,TAge,TSex,CardID,UserName,THPNo,TAge,TReportDate,Feestatus,PACCardDesc)  
    s ^TempDHCPEExportCommon(UserID,ExportName,ind)=TItem_"^"_TRegNo_"^"_TName_"^"_TReCheck_"^"_TVIPLevel_"^"_TGroup_"^"_TTel_"^"_TArrivedDate_"^"_TCheckDate_"^"_TReportDate
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

ClassMethod SearchSpecialItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchSpecialItemExecute ]
{
    
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             
        Set AtEnd=1
        Set Row=""
    }
    Else{           
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind) 
    Quit $$$OK
}

ClassMethod SearchSpecialItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchSpecialItemExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod OutStatusToHTML(ContrlWidth As %String = "") As %String
{
    ;d ##Class(web.DHCPE.FetchReport).OutStatusToHTML("130")
    s:(""=ContrlWidth) ContrlWidth="155"
    //下拉列表
    w "<select name='Status' id='Status' style='width:"_ContrlWidth_"' HEIGHT=0  tabIndex=2>",!
    w "<option value=''></option>",!
    w "<option value='0'>预约</option>",!
    w "<option value='1'>未完成</option>",!
    w "<option value='3'>谢绝检查</option>",!
    w "<option value='6'>已完成</option>",!
    w "</select>",!
    Quit $$$OK
}

ClassMethod OutItemToHTML(ContrlWidth As %String = "") As %String
{
    ;d ##Class(web.DHCPE.FetchReport).OutItemToHTML("130")
    s:(""=ContrlWidth) ContrlWidth="155"
    //下拉列表
    s UserID=%session.Get("LOGON.USERID")
    w "<select name='Item' id='Item' style='width:"_ContrlWidth_"' HEIGHT=0  tabIndex=2>",!
    w "<option value=''></option>",!
    
    s Job=$J
    k ^TempDHCPESpecialItem(Job)
    s ItemID=""
    f  s ItemID=$O(^DHCPECTDataEx("DHCPEStationOrder","SignItem",ItemID)) q:ItemID=""  d
    .q:$G(^DHCPECTDataEx("DHCPEStationOrder","SignItem",ItemID))'="Y"
    .q:$g(^DHCPESpecialContral("DHCPEXH",UserID,ItemID))'="Y"
    .s STID=$O(^DHCPEST(0,"STORD_ARCIM",ItemID,0))
    .s STSort=$P(^DHCPEST(STID),"^",9)
    .s:STSort="" STSort="999999999"
    .s ^TempDHCPESpecialItem(Job,STSort,ItemID)=""
    
    s STSort=""
    f  s STSort=$O(^TempDHCPESpecialItem(Job,STSort)) q:STSort=""  d
    .s ItemID=""
    .f  s ItemID=$O(^TempDHCPESpecialItem(Job,STSort,ItemID)) q:ItemID=""  d
    ..s Desc=##class(web.DHCPE.DHCPECommon).GetArcDesc(ItemID)
    ..w "<option value='"_ItemID_"'>"_Desc_"</option>",!
    w "</select>",!
    
    k ^TempDHCPESpecialItem(Job)
    Quit $$$OK
}

Query GetSpecialItem(StationID As %String = "", Item As %String = "", Type As %String = "", LocID As %String = "", hospId As %String = "") As %Query(ROWSPEC = "ItemDesc:%String:项目名称,ItemID:%String")
{
}

ClassMethod GetSpecialItemExecute(ByRef qHandle As %Binary, StationID As %String = "", Item As %String = "", Type As %String = "", LocID As %String = "", hospId As %String = "") As %Status
{
    
    s ind=1
    Set repid=$I(^CacheTemp)
    s UserID=%session.Get("LOGON.USERID")
    s ItemID=""
    f  s ItemID=$O(^DHCPECTDataEx("DHCPEStationOrder","SignItem",ItemID)) q:ItemID=""  d
    .q:$G(^DHCPECTDataEx("DHCPEStationOrder","SignItem",ItemID))'="Y"
    .;q:$g(^DHCPESpecialContral("DHCPEXH",UserID,ItemID))'="Y"
    .s STID=$O(^DHCPEST(0,"STORD_ARCIM",ItemID,0))
    .q:(StationID'="")&&(StationID'=STID)
    .s DateShowFlag=##class(web.DHCPE.HISUICommon).GetDateShowDataFlag("ARC_ItmMast",ItemID,Type,LocID)
    .q:DateShowFlag="Y"
    .s HOSPshowFlag=##class(web.DHCPE.HISUICommon).GetHospShowDataFlag("ARC_ItmMast",ItemID,hospId)
    .q:(HOSPshowFlag="N")
    .s STSort=$P(^DHCPEST(STID),"^",9)
    .s ItemDesc=##class(web.DHCPE.DHCPECommon).GetArcDesc(ItemID)
    .q:ItemDesc'[Item
    
    .d FindBuild    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
FindBuild      
    set Data=$lb(ItemDesc,ItemID)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

ClassMethod GetSpecialItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSpecialItemExecute ]
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

ClassMethod GetSpecialItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSpecialItemExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod OutCompleteButton(OEID)
{
    ;d ##class(web.DHCPE.FetchReport).OutCompleteButton(OEID)
    s CurStatus=$P(OEID,"^",2)
    s OEID=$P(OEID,"^",1)
    q:OEID=""
    
    s CRMORowId=$o(^DHCPECRMO(0,"OEORI",OEID,0))
    s status=$p(^DHCPECRMO(CRMORowId),"^",4)
    s StatusDesc=CurStatus
    //s:CurStatus=1 StatusDesc="核实"
    //s:CurStatus=6 StatusDesc="执行"
    q:CurStatus="3" 
    s CheckDate=""
    i '$D(^DHCPESpecial("DHCPE","UserID",OEID)) d
    .//s CurStatus="1"
    .;s CheckDate=$ZD(+$H,3)
    e  d
    .s CheckDate=$P(^DHCPESpecial("DHCPE","UserID",OEID),"^",2)
    .s:CheckDate'="" CheckDate=##class(websys.Conversions).DateLogicalToHtml(CheckDate)
    .s CheckTime=$P(^DHCPESpecial("DHCPE","UserID",OEID),"^",3)
    .s CheckTime=$ZT(CheckTime,1)
    .;s:CheckDate'="" CheckDate=CheckDate_" "_CheckTime
    i (%session.Get("LOGON.GROUPDESC"))[("特殊")  d
    .i (CurStatus="1")&&((status="OC")||(status="P")) d
    ..w "<Table><tr><td>"
    ..w "<input type='button' id='"_OEID_"' name='ActiveButton' value='完成("_StatusDesc_")' onclick='CompleteItem();'>"
    ..w "<input size=10 id='D"_OEID_"' value="_CheckDate_">"
    ..w "</td></tr></Table>"
    .e  i (status="OC")||(status="P")  d
    ..w "<Table><tr><td>"
    ..w "<input type='button' id='"_OEID_"' name='ActiveButton' value='取消完成' onclick='UnCompleteItem();'>"
    ..w "<input size=10 disabled id='D"_OEID_"' value="_CheckDate_">"
    ..w "</td></tr></Table>"
    
    e  d
    .i (CurStatus="1")&&((status="OC")||(status="P")) d
    ..w "未完成 "_CheckDate
    .e  i (status="OC")||(status="P")  d
    ..w "已完成 "_CheckDate
    
    Quit $$$OK
}

ClassMethod OutReportButton(OEID)
{
    ;d ##class(web.DHCPE.FetchReport).OutCompleteButton(OEID)
    s CurStatus=$P(OEID,"^",2)
    s OEID=$P(OEID,"^",1)
    w:OEID="" "医嘱ID为空"
    q:OEID="" 
    
    s CRMORowId=$o(^DHCPECRMO(0,"OEORI",OEID,0))
    s status=$p(^DHCPECRMO(CRMORowId),"^",4)
    s StatusDesc=CurStatus
    w:CurStatus="3" "医嘱已谢绝检查"
    q:CurStatus="3" 
    s CheckDate=""
    i $D(^DHCPESpecial("DHCPE","Report",OEID)) d
    .s CheckDate=$P(^DHCPESpecial("DHCPE","Report",OEID),"^",2)
    .s:CheckDate'="" CheckDate=##class(websys.Conversions).DateLogicalToHtml(CheckDate)
    i (%session.Get("LOGON.GROUPDESC"))[("特殊")  d
    .i '$D(^DHCPESpecial("DHCPE","Report",OEID)) d
    ..w "<Table><tr><td>"
    ..w "<input type='button' id='"_OEID_"' name='ReportButton' value='报告' onclick='ReportItem();'>"
    ..w "<input size=10 id='R"_OEID_"' value="_CheckDate_">"
    ..w "</td></tr></Table>"
    .e  d
    ..w "<Table><tr><td>"
    ..w "<input type='button' id='"_OEID_"' name='ReportButton' value='取消报告' onclick='UnReportItem();'>"
    ..w "<input size=10 disabled id='R"_OEID_"' value="_CheckDate_">"
    ..w "</td></tr></Table>"
    e  d
    .i '$D(^DHCPESpecial("DHCPE","Report",OEID)) d
    ..w "无报告"_CheckDate
    .e  d
    ..w "已报告"_CheckDate
    
    Quit $$$OK
}

ClassMethod ChangeDate(ComDate)
{
    s $ZT="DateErr"
    //q $ZDH(ComDate,3)
    q ##class(websys.Conversions).DateHtmlToLogical(ComDate) 
DateErr
    q ""
}

// d ##class(web.DHCPE.FetchReport).UpdateComplete("","")

ClassMethod UpdateComplete(OEID, Type)
{
    s curUser=%session.Get("LOGON.USERID")
    s ComDate=$P(OEID,"^",2)
    s OEID=$P(OEID,"^",1)
    s EpisodeID=$P(^OEORD(+OEID),"^",1)
    s arcimId=$p(^OEORD(+OEID,"I",$p(OEID,"||",2),1),"^",2)
    s ODRID=$o(^DHCPEODR(0,"ARCIM",arcimId,0))
    s ODID=""
    i ODRID'="" s ODID=$p(^DHCPEODR(ODRID),"^",2)
    i ODID="" s ODID="a||b"
    s ResultStr="临床诊断:"
    s Result="详见报告"
    s:Type="0" Result=""
    s ResultStr=ResultStr_";检查所见:"
    s ResultStr=ResultStr_";诊断意见:"_Result
    i ComDate="" d
    .s CurDate=+$H
    e  d
    .s CurDate=..ChangeDate(ComDate)
    q:CurDate="" "日期格式不正确,应该为'YYYY-MM-DD'"
    s CurTime=$P($H,",",2)
    s ret=##class(web.DHCPE.ResultEdit).UpdateRisResult(EpisodeID, OEID, ResultStr, curUser)
    ;s CurDate=+$H
    s CurTime=$P($H,",",2)
    i (Type="1")  d
    .s ^DHCPESpecial("DHCPE","UserID",OEID)=curUser_"^"_CurDate_"^"_CurTime
    .s ^DHCPESpecial("DHCPE","DateIndex",CurDate,CurTime,OEID)=""
    i Type="0"  d
    .s Info=$G(^DHCPESpecial("DHCPE","UserID",OEID))
    .i Info'="" d
    ..s Date=$P(Info,"^",2)
    ..i Date'="" d
    ...s Time=$P(Info,"^",3)
    ...k ^DHCPESpecial("DHCPE","DateIndex",Date,Time,OEID)
    .k ^DHCPESpecial("DHCPE","UserID",OEID) 
    q ""
}

// d ##class(web.DHCPE.FetchReport).UpdateComplete("","")

ClassMethod UpdateReport(OEID, Type)
{
    s curUser=%session.Get("LOGON.USERID")
    s ComDate=$P(OEID,"^",2)
    s OEID=$P(OEID,"^",1)
    s EpisodeID=$P(^OEORD(+OEID),"^",1)
    i ComDate="" d
    .s CurDate=+$H
    e  d
    .s CurDate=..ChangeDate(ComDate)
    q:CurDate="" "日期格式不正确,应该为'YYYY-MM-DD'"
    s CurTime=$P($H,",",2)
    i (Type="1")  d
    .s ^DHCPESpecial("DHCPE","Report",OEID)=curUser_"^"_CurDate_"^"_CurTime
    .s ^DHCPESpecial("DHCPE","ReportDateIndex",CurDate,CurTime,OEID)=""
    i Type="0"  d
    .s Info=$G(^DHCPESpecial("DHCPE","Report",OEID))
    .i Info'="" d
    ..s Date=$P(Info,"^",2)
    ..i Date'="" d
    ...s Time=$P(Info,"^",3)
    ...k ^DHCPESpecial("DHCPE","ReportDateIndex",Date,Time,OEID)
    .k ^DHCPESpecial("DHCPE","Report",OEID) 
    q ""
}

ClassMethod GetReportStatusNew(PAADM)
{
    ;##class(web.DHCPE.FetchReport)GetReportStatusNew(PAADM)
    q:PAADM="" "" 
    s IADM=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
    q:IADM="" "0&收表^0&粘贴^0&初检^0&复检^0&打印^0&已取"
    
    s PIADM=$P(^DHCPEIADM(IADM),"^",4)
    s RecFlag=0
    s:$D(^DHCPEDataEx("DHCPEPreIADM","GetReportDateTime","I",PIADM)) RecFlag=1
    s SendAudit=0
    s:$D(^User.DHCPESendAuditI("AdmIndex",PAADM)) SendAudit=1
    s GSID=$O(^DHCPEGS(0,"IADM",IADM,0))
    s AuditUser=""
    i GSID'="" d
    .s AuditUser=$P(^DHCPEGS(GSID,1),"^",5)
    s ReportAudit=0
    s:AuditUser'="" ReportAudit=1
    s MainAudit=0
    s:$D(^DHCPEDataEx("DHCPEGeneralSummarize","MainDoctor",PAADM)) MainAudit=1
    s PrintFlag=""
    s SendFlag=0
    s ReportID=$O(^DHCPERPT(0,"IADM",IADM,0))
    i ReportID'="" d
    .s Status=$P(^DHCPERPT(ReportID),"^",2)
    .i Status="S" d
    ..s PrintFlag="1"
    ..s SendFlag="1"
    .e  i Status="P" d
    ..s PrintFlag="1"
    .e  i Status="C" d
    ..s PrintFlag="1"
    s:PrintFlag="1" PrintFlag=$P(^DHCPERPT(ReportID),"^",7)
    s:PrintFlag'="" PrintFlag=##class(websys.Conversions).DateLogicalToHtml(PrintFlag)   
    q RecFlag_"&收表"_"^"_SendAudit_"&粘贴"_"^"_ReportAudit_"&初检"_"^"_MainAudit_"&复检"_"^"_PrintFlag_"&打印"_"^"_SendFlag_"&已取"
}

ClassMethod GetReportStatus(PAADM)
{
    ;##class(web.DHCPE.FetchReport).GetReportStatus(PAADM)
    q:PAADM="" ""
    s IADM=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
    q:IADM="" "0^0^0^0^0^0^0^0^0^0^0^0"
    s PIADM=$P(^DHCPEIADM(IADM),"^",4)
    s RecFlag=0
    s:$D(^DHCPEDataEx("DHCPEPreIADM","GetReportDateTime","I",PIADM)) RecFlag=1
    s SendAudit=0
    s:$D(^User.DHCPESendAuditI("AdmIndex",PAADM)) SendAudit=1
    s GSID=$O(^DHCPEGS(0,"IADM",IADM,0))
    s AuditUser=""
    i GSID'="" d
    .s AuditUser=$P(^DHCPEGS(GSID,1),"^",5)
    s ReportAudit=0
    s:AuditUser'="" ReportAudit=1
    s MainAudit=0
    s:$D(^DHCPEDataEx("DHCPEGeneralSummarize","MainDoctor",PAADM)) MainAudit=1
    s PrintFlag=""
    s SendFlag=0
    s ReportID=$O(^DHCPERPT(0,"IADM",IADM,0))
    i ReportID'="" d
    .s Status=$P(^DHCPERPT(ReportID),"^",2)
    .i Status="S" d
    ..s PrintFlag="1"
    ..s SendFlag="1"
    .e  i Status="P" d
    ..s PrintFlag="1"
    .e  i Status="C" d
    ..s PrintFlag="1"
    s:PrintFlag="1" PrintFlag=$P(^DHCPERPT(ReportID),"^",7)
    s:PrintFlag'="" PrintFlag=##class(websys.Conversions).DateLogicalToHtml(PrintFlag)
    q RecFlag_"^"_SendAudit_"^"_ReportAudit_"^"_MainAudit_"^"_PrintFlag_"^"_SendFlag
}

ClassMethod OutReportStatus(PAADM)
{
    q:PAADM="" ""
    s ReportStatus=..GetReportStatus(PAADM)
    w "<table><TR>"
    i $P(ReportStatus,"^",1)=1 d
    .s checked="checked"
    e  d
    .s checked=""
    w "<TD><label>收表</label><input type='checkbox' disabled "_checked_"></TD>"
    
    i $P(ReportStatus,"^",2)=1 d
    .s checked="checked"
    e  d
    .s checked=""
    w "<TD><label>&nbsp;&nbsp;&nbsp;&nbsp;粘贴</label><input type='checkbox' disabled "_checked_"></TD>"
    
    i $P(ReportStatus,"^",3)=1 d
    .s checked="checked"
    e  d
    .s checked=""
    w "<TD><label>总检</label><input type='checkbox' disabled "_checked_"></TD>"
    
    i $P(ReportStatus,"^",4)=1 d
    .s checked="checked"
    e  d
    .s checked=""
    w "</TR><TR><TD><label>复检</label><input type='checkbox' disabled "_checked_"></TD>"
    i $P(ReportStatus,"^",5)'="" d
    .s checked="checked"
    e  d
    .s checked=""
    w "<TD><label>已打印</label><input type='checkbox' disabled "_checked_"></TD>"
    i $P(ReportStatus,"^",6)=1 d
    .s checked="checked"
    e  d
    .s checked=""
    w "<TD><label>已取</label><input type='checkbox' disabled "_checked_"></TD>"
    w "</TR></table>"
}

ClassMethod OutResultLink(PAADM)
{
    q:PAADM=""
    s lnk="../csp/websys.default.csp?WEBSYS.TCOMPONENT=DHCPENewDiagnosis&EpisodeID="_PAADM_"&OnlyRead=Y"
    w "<a href="_lnk_" target='_blank' >结果预览</a><br>"
    s lnk="../csp/dhcpeireport.normal.csp?PatientID="_PAADM_"&OnlyRead=Y"
    w "<a href="_lnk_" target='_blank' >报告预览</a><br>"
    s lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEContrastWithLast&PAADM="_PAADM
    w "<a href="_lnk_" target='_blank' >结果比对</a>"
}

ClassMethod GetComNumByDate(Date, User)
{
    //s Date=EndDate+1
    ;w ##class(web.DHCPE.FetchReport).GetComNumByDate(+$H-1,"")
    s ComNum=0
    s ID=0
    f  s ID=$O(^User.DHCPESendAuditI("SendDateIndex",Date,ID)) q:(ID="")  d
    .s CurPAADM=$LG(^User.DHCPESendAuditD(ID),2)
    .s CurIADM=$O(^DHCPEIADM(0,"PAADM",CurPAADM,0))
    .q:CurIADM=""
    .s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PEADM",CurIADM)
    .q:LocFlag=1
    .s TSendUser=$LG(^User.DHCPESendAuditD(ID),3)
    .q:(User'="")&&(TSendUser'=User)
    .s ComNum=ComNum+1
    q ComNum
}

/// 更新领取人信息
ClassMethod UpdateFetchReportInfo(Instring, Flag)
{
    
    s User=%session.Get("LOGON.USERID")
    s Date=+$H
    s Time=$P($H,",",2)
    i Flag="1"  d
    .s ReportID=$P(Instring,"^",1)
    .s Name=$P(Instring,"^",2)
    .s Tel=$P(Instring,"^",3)
    .s IDCard=$P(Instring,"^",4)
    .s ExpressNo=$P(Instring,"^",5)
    .s Address=$P(Instring,"^",6)
    .s IADMDR=$P($g(^DHCPERPT(ReportID)) ,"^",1)
    .S PreIADM=$p($G(^DHCPEIADM(IADMDR)),"^",4)
    .i Address'=""  s ^DHCPEDataEx("ConfirmRecPaper","Remark",PreIADM)=Address
    .s ^DHCPEDataEx("FetchReport","Detail",ReportID)=Name_"^"_Tel_"^"_IDCard_"^"_User_"^"_Date_"^"_Time_"^"_ExpressNo
    i Flag="0"  d
    .k ^DHCPEDataEx("FetchReport","Detail",ReportID)
    Q 0
}

/// 获取领取人信息
ClassMethod GetFetchReportInfo(ReportID)
{
    q:ReportID="" "{}"
    q:'$d(^DHCPEDataEx("FetchReport","Detail",ReportID)) "{}"
    s Data=$g(^DHCPEDataEx("FetchReport","Detail",ReportID))
    s Name=$p(Data,"^",1), IDCard=$p(Data,"^",2), Tel=$p(Data,"^",3)
    s User=$p(Data,"^",4), Date=$p(Data,"^",5), Time=$p(Data,"^",6),ExpressNo=$p(Data,"^",7)
    q "{""Name"":"""_Name_""",""Tel"":"""_Tel_""",""IDCard"":"""_IDCard_""",""User"":"""_User_""",""Date"":"""_Date_""",""Time"":"""_Time_""",""ExpressNo"":"""_ExpressNo_"""}"
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.FetchReport","SearchFetchReportDetail","4746")
Query SearchFetchReportDetail(ReportID As %String = "") As %Query(ROWSPEC = "TReportID:%String,TName:%String,TTel:%String,TIDCard:%String")
{
}

ClassMethod SearchFetchReportDetailExecute(ByRef qHandle As %Binary, ReportID As %String = "") As %Status
{
   
    Set repid=$I(^CacheTemp)
    s ind=1
    s ID="",Name="",Tel="",IDCard=""
    if ($d(^DHCPEDataEx("FetchReport","Detail",ReportID))) d
    .s Data=$g(^DHCPEDataEx("FetchReport","Detail",ReportID))
    .s Name=$P(Data,"^",1)
    .s Tel=$P(Data,"^",2)
    .s IDCard=$P(Data,"^",3)
    .s ID=ReportID
    .d OutPutDetail
    
    Set qHandle=$lb(0,repid,0) 
    Quit $$$OK

OutPutDetail
    set Data=$lb(ID,Name,Tel,IDCard) 
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

ClassMethod SearchFetchReportDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchFetchReportDetailExecute ]
{
    
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             
        Set AtEnd=1
        Set Row=""
    }
    Else{           
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind) 
    Quit $$$OK
}

ClassMethod SearchFetchReportDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchFetchReportDetailExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetCompleteDate(OEID)
{
    // d ##class(web.DHCPE.FetchReport).GetCompleteDate("")
    q:'$D(^DHCPESpecial("DHCPE","UserID",OEID)) ""  
    s CheckDate=$P(^DHCPESpecial("DHCPE","UserID",OEID),"^",2)
    s:CheckDate'="" CheckDate=##class(websys.Conversions).DateLogicalToHtml(CheckDate)
    q CheckDate
}

ClassMethod GetReportDate(OEID)
{
    q:'$D(^DHCPESpecial("DHCPE","Report",OEID)) ""  
    s CheckDate=$P(^DHCPESpecial("DHCPE","Report",OEID),"^",2)
    s:CheckDate'="" CheckDate=##class(websys.Conversions).DateLogicalToHtml(CheckDate)
    q CheckDate
}

ClassMethod IsExistReport(OEID)
{
  s flag=0
  q:'$D(^DHCPESpecial("DHCPE","Report",OEID)) "0"
  i $D(^DHCPESpecial("DHCPE","Report",OEID)) s flag=1
  q flag
}

Storage Default
{
<Data name="FetchReportDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCPE.FetchReportD</DataLocation>
<DefaultData>FetchReportDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCPE.FetchReportD</IdLocation>
<IndexLocation>^web.DHCPE.FetchReportI</IndexLocation>
<StreamLocation>^web.DHCPE.FetchReportS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
