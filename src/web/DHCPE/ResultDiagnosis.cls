/// 总检建议以及结论使用
Class web.DHCPE.ResultDiagnosis Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 体检人所有需要检查的站点
/// w ##class(web.DHCPE.ResultDiagnosis).AdmNeedStation(476351)
ClassMethod AdmNeedStation(EpisodeID, IncludeRefuse As %String = 1)
{
    s AddItemStation=24  //协和特殊写死的加项超声算到站点里面
    s CSStation="9"  //超声站点
    s LocID=$p($g(^PAADM(EpisodeID)),"^",4)
    
    //s OtherStation=$G(^DHCPESetting("DHCPE","StationId_Other"))
    //s MedicalStation=$G(^DHCPESetting("DHCPE","StationId_Medical"))
    s OtherStation=$G(^DHCPESetting("DHCPE","StationId_Other",LocID))
    s MedicalStation=$G(^DHCPESetting("DHCPE","StationId_Medical",LocID))

    s OtherStation="^"_OtherStation_"^"_MedicalStation_"^"
    s StationIDs="",RefuseStations=""
    
    s VIPInfo=##class(web.DHCPE.PreCommon).GetVIPLevel("PAADM",EpisodeID)
    
    s OEOrder=0
    f  s OEOrder=$O(^OEORD(0,"Adm",EpisodeID,OEOrder))  q:(OEOrder="")  d
    .s OEOrdItem=0
    .f  s OEOrdItem=$O(^OEORD(OEOrder,"I",OEOrdItem))  q:(OEOrdItem="")  d
    ..s CurData=$g(^OEORD(OEOrder,"I",OEOrdItem,1))
    ..q:(""=CurData)
    ..s ORIStat=$p(CurData,"^",13)
    ..q:ORIStat=4
    ..s OEORIRowId=OEOrder_"||"_OEOrdItem
    ..s IADM=$O(^DHCPEIADM(0,"PAADM",EpisodeID,0))
    ..i IADM'="" d ;体检预约
    ...s CRMOId=$o(^DHCPECRMO(0,"OEORI",OEORIRowId,0))   //Modified by MLH
    ...q:CRMOId=""
    ...s CRMOrI=$p($g(^DHCPECRMO(CRMOId)),"^",2)
    ...q:CRMOrI=""
    ...s ItemMastId=$p($g(^DHCPEPreIADM($p(CRMOrI,"||",1),"ORDITEM",$p(CRMOrI,"||",2))),"^",1)
    ..e  d  ;非体检预约
    ...s ItemMastId=$p(CurData,"^",2)
    ..q:$g(ItemMastId)=""
    ..;s Station=$o(^DHCPEST(0,"STORD_ARCIM",ItemMastId,0))
    ../***根据医嘱项获取站点ID(多院区) start***/
    ..s StOrderDR=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ItemMastId,LocID)
    ..q:StOrderDR=""
    ..s Station=$p(StOrderDR,"||",1)
    ../***根据医嘱项获取站点ID(多院区) end***/
    ..q:Station=""
    ..q:OtherStation[("^"_Station_"^")
    ..q:(IncludeRefuse=0)&&$D(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OEOrder_"||"_OEOrdItem))
    ..i $d(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OEOrder_"||"_OEOrdItem))  d
    ...s StationDesc=$p($g(^DHCPEST(Station)),"^",2)
    ...i RefuseStations=""  s RefuseStations=StationDesc
    ...else  s RefuseStations=RefuseStations_","_StationDesc
    ..s ^DHCPEDataEx("DHCPEPreIOrdItem","RefuseStation",EpisodeID)=RefuseStations
    ..;i Station=CSStation d  //如果是超声、判断是否加项
    ..;.s OSID=$p($g(^DHCPEPreIADM($p(CRMOrI,"||",1),"ORDITEM",$p(CRMOrI,"||",2))),"^",2)
    ..;.i OSID="" d
    ..;..q:VIPInfo["VIP"
    ..;..q:%session.Get("LOGON.CTLOCID")=572
    ..;..s Station=AddItemStation
    ..//q:$d(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OEOrder_"||"_OEOrdItem))  //谢绝检查退出
    ..q:##class(web.DHCPE.PreAudit).StringIsInStrs(StationIDs,Station)
    ..i StationIDs="" d
    ...s StationIDs=Station
    ..e  d
    ...s StationIDs=StationIDs_"^"_Station
    q StationIDs
}

ClassMethod RefuseStations(EpisodeID)
{
    
   
    s RefuseStations=""
    q:EpisodeID=""""
    s RefuseStations=$g(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseStation",EpisodeID))
    q RefuseStations
}

// 

ClassMethod AuditStationS(EpisodeID, Type, QXType As %Library.String = "0", MainDoctor As %String = "", AppointMUser As %String = "")
{
    k PLIST
    s SSID=..GetSSId(EpisodeID)
    i SSID="" q "NoSS" 
    s IAdm=$o(^DHCPEIADM(0,"PAADM",EpisodeID,""))
    i IAdm'=""
    {
        s ReportID=$O(^DHCPERPT(0,"IADM",IAdm,0))
        s ReportStatus=$P(^DHCPERPT(ReportID),"^",2)
        if (Type="Cancel")
        {
            q:(ReportStatus="S") "ReportStatusSendErr"
            q:(ReportStatus'="A")&&(ReportStatus'="P") "ReportStatusErr"
        }
    }
    s User=$p(^DHCPEGS(SSID,1),"^",5)
    s curGroup=%session.Get("LOGON.GROUPID")
    s LocID=$P($G(^PAADM(EpisodeID)),"^",4)
    //s MainDoctorGroup=$G(^DHCPESetting("DHCPE","MainDoctorGroup"))
    s MainDoctorGroup=$G(^DHCPESetting("DHCPE","MainDoctorGroup",LocID))

    //i curGroup=MainDoctorGroup
    i MainDoctor="Y"
    {
        s SQLCODE=0
        s MainUser=%session.Get("LOGON.USERID")
        i (User="")&&(Type="Submit") q "NoAudit"
        i ((User'="")&&(Type="Submit")&&($D(^DHCPEDataEx("DHCPEGeneralSummarize","MainDoctor",EpisodeID)))) q "ReMainHadAudit"
        i (User'="")&&(Type="Submit")&&('$D(^DHCPEDataEx("DHCPEGeneralSummarize","MainDoctor",EpisodeID))) d
        .s ^DHCPEDataEx("DHCPEGeneralSummarize","MainDoctor",EpisodeID)=MainUser_"^"_$p($H,",",1)_"^"_$p($H,",",2)
        .s ^DHCPEDataEx("DHCPEGeneralSummarize","MainDate",+$H,$p($H,",",2),EpisodeID)=MainUser
        i ('$D(^DHCPEDataEx("DHCPEGeneralSummarize","MainDoctor",EpisodeID)))&&(Type="Cancel") q "ReMainNoAudit"
        i ($D(^DHCPEDataEx("DHCPEGeneralSummarize","MainDoctor",EpisodeID)))&&(Type="Cancel") d
        .s MainDate=$p($G(^DHCPEDataEx("DHCPEGeneralSummarize","MainDoctor",EpisodeID)),"^",2)
        .s MainTime=$p($G(^DHCPEDataEx("DHCPEGeneralSummarize","MainDoctor",EpisodeID)),"^",3)
        .k ^DHCPEDataEx("DHCPEGeneralSummarize","MainDate",MainDate,MainTime,EpisodeID)
        .k ^DHCPEDataEx("DHCPEGeneralSummarize","MainDoctor",EpisodeID)
        .;取消时不更新报告状态
        .&sql(update sqluser.DHC_PE_Report set RPT_Status='A', RPT_PrintUser_DR=NULL, RPT_PrintDate=NULL where ((RPT_IADM_DR=:IAdm)))
    
        i (SQLCODE=0)&&(Type="Submit") d
        .d ##class(web.DHCPE.NetReport.Main).Main(EpisodeID)
        .d ##class(web.DHCPE.AdmRecordManager).Insert(EpisodeID,"A","GMainAuditStationS",MainUser,"")
        .d ##Class(web.DHCPE.ResultDiagnosisNew).DeleteChceckingInfo(EpisodeID)
        .d ##class(web.DHCPE.OtherPatientToHP).UpdateStatus(EpisodeID,"2","")
        i (SQLCODE=0)&&(Type="Cancel") d
        .d ##class(web.DHCPE.NetReport.Main).CancelReportData(EpisodeID)
        .d ##class(web.DHCPE.AdmRecordManager).Insert(EpisodeID,"A","CaccelGMainAuditStationS",MainUser,"")
        .d ##Class(web.DHCPE.ResultDiagnosisNew).SetCheckingInfo(EpisodeID,MainUser)
        .d ##class(web.DHCPE.OtherPatientToHP).UpdateStatus(EpisodeID,"1","")
        q 0
    }
    i (User'="")&&(Type="Submit") q "HadAudit"
    i (User="")&&(Type="Cancel") q "NoAudit"
    i (Type="Cancel")&&($D(^DHCPEDataEx("DHCPEGeneralSummarize","MainDoctor",EpisodeID)))  q "ReMainHadAudit"
    s CurUser=%session.Get("LOGON.USERID")
    s PLIST(7)=CurUser
    d ##class(web.DHCPE.OtherPatientToHP).UpdateStatus(EpisodeID,"2","")
    i Type="Cancel" s PLIST(7)=""
    i Type="Cancel" d ##class(web.DHCPE.OtherPatientToHP).UpdateStatus(EpisodeID,"1","")
    s PLIST(8)=+$H
    s PLIST(9)=$p($H,",",2)
    s User=%session.Get("LOGON.USERID")
    s Date=+$H
    s Time=$p($H,",",2)
    
    s LocID=$P(^PAADM(EpisodeID),"^",4) ;就诊科室（开医嘱科室）
    i $D(^DHCPEOtherPatientToHPBase("GenConUser",LocID)) D
    .s DocUserID=$G(^DHCPEOtherPatientToHPBase("GenConUser",LocID))
    E  S DocUserID=User 

    i (Type="Cancel")&&(QXType="0")
    {
        i IAdm'=""
        {
            s rid=$o(^DHCPERPT(0,"IADM",IAdm,0))
            s status=$p(^DHCPERPT(rid),"^",2)
            ;i status="P" q "HadPrint"  
            ;i status="S" q "HadSend"
        }   
    }
    
    
    TSTART
    &SQL(update sqluser.DHC_PE_GeneralSummarize values :PLIST() where GS_RowId=:SSID)
    i SQLCODE
    {
        TROLLBACK
        q SQLCODE
    }
    i Type="Submit" d
    .d ##class(web.DHCPE.NetReport.Main).Main(EpisodeID)
    .i IAdm'="" d
    ..i ReportStatus="NA" d
    ...&sql(update sqluser.DHC_PE_Report set RPT_Status='A',RPT_AduitUser_DR=:User,RPT_AduitDate=:Date where ((RPT_IADM_DR=:IAdm)))
    
    .//指定复审医生
    .i AppointMUser'=""  d
    ..s ^DHCPEDataEx("AppointMUser",User)=AppointMUser
    ..d ##class(web.DHCPE.WorkDistribution).SaveTask(EpisodeID,"MAR",AppointMUser,User)
    
    i Type="Cancel" d
    .s User=""
    .;取消时不更新报告状态
    .i IAdm'="" d
    ..i ReportStatus="A" d
    ...&sql(update sqluser.DHC_PE_Report set RPT_Status='NA',RPT_AduitUser_DR=:User,RPT_AduitDate=:Date, RPT_PrintUser_DR=NULL, RPT_PrintDate=NULL where ((RPT_IADM_DR=:IAdm)))
    
    .;撤销指定的复审医生
    .i $D(^User.DHCPEWorkDistributionI("TypePAADMIndex","MAR",EpisodeID)) d
    ..s MDoctor=$O(^User.DHCPEWorkDistributionI("TypePAADMIndex","MAR",EpisodeID,""))
    ..d ##class(web.DHCPE.WorkDistribution).DeleteAdmDoc(EpisodeID,MDoctor,"MAR")
    
    
    i SQLCODE
    {
        TROLLBACK
        q SQLCODE
    }
    TCOMMIT
    i (SQLCODE=0)&&(Type="Submit") d
    .s LocID=%session.Get("LOGON.CTLOCID")
    .s MainDoctorFlag=$G(^DHCPESetting("DHCPE","MainDoctorGroup",LocID))
    .d:MainDoctorFlag'="Y" ##class(web.DHCPE.NetReport.Main).Main(EpisodeID)
    .d ##class(web.DHCPE.AdmRecordManager).Insert(EpisodeID,"A","GAuditStationS",User,"")
    .d ##Class(web.DHCPE.ResultDiagnosisNew).DeleteChceckingInfo(EpisodeID)
    .//d ##class(web.DHCPE.ResultDiagnosisNew).CreateGSSDetail(SSID)
    i (SQLCODE=0)&&(Type="Cancel") d
    .d ##class(web.DHCPE.AdmRecordManager).Insert(EpisodeID,"A","CaccelGAuditStationS",User,"")
    .d ##class(web.DHCPE.NetReport.Main).CancelReportData(EpisodeID)
    .d ##Class(web.DHCPE.ResultDiagnosisNew).SetCheckingInfo(EpisodeID,User)
    .d ##class(web.DHCPE.OtherPatientToHP).StopConOrder(EpisodeID, "",DocUserID)
    q SQLCODE
}

/// 获取总检医生id
ClassMethod GetAuditUserId(EpisodeID, MainDoctor As %String = "N")
{
    s SSID=..GetSSId(EpisodeID)
    q:SSID="" "" 
    //s curGroup=%session.Get("LOGON.GROUPID")
    //s MainDoctorGroup=$G(^DHCPESetting("DHCPE","MainDoctorGroup"))
    i MainDoctor="Y"
    {
        q $P($G(^DHCPEDataEx("DHCPEGeneralSummarize","MainDoctor",EpisodeID)),"^",1)
    }
    s User=$p(^DHCPEGS(SSID,1),"^",5) 
    q User
}

ClassMethod CreatEDCElement(EDCRowId As %String, ItemColName As %String, ItemValue As %String) As %String
{
    
    Quit:ItemColName="" ""
    set AddtionStr=""
    Do SelectBox
    Quit ""
    
SelectBox
    Write "<select id='"_ItemColName_"' name='"_ItemColName_"' size=1 style='WIDTH: 180px; HEIGHT: 24px'"_AddtionStr_">"
    Write "<option  value=''></option>"
    Set EDCRowId=0
    For  Set EDCRowId=$O(^DHCPEEDC(EDCRowId)) Quit:EDCRowId=""  Do
    .Set ListVal=$P(^DHCPEEDC(EDCRowId),"^",2)
    .If ListVal=ItemValue Write "<option value="_EDCRowId_" selected>"_ListVal_"</option>"
    .Else  Write "<option value="_EDCRowId_">"_ListVal_"</option>"
    Write "</select>"
    Quit
}

ClassMethod CreatEDCElement1(EDCRowId As %String, ItemColName As %String, ItemValue As %String) As %String
{
    s ^zl("CreatEDCElement1")=EDCRowId_"^"_ItemColName_"^"_ItemColName
    //Quit:ItemColName="" ""
    set AddtionStr=""
    Do SelectBox
    Quit ""
    
SelectBox
    Write "<select id='"_ItemColName_"' name='"_ItemColName_"' size=1 style='WIDTH: 180px; HEIGHT: 24px'"_AddtionStr_">"
    Write "<option  value=''></option>"
    Set EDCRowId=0
    For  Set EDCRowId=$O(^DHCPEEDC(EDCRowId)) Quit:EDCRowId=""  Do
    .Set ListVal=$P(^DHCPEEDC(EDCRowId),"^",2)
    .If ListVal=ItemValue Write "<option value="_EDCRowId_" selected>"_ListVal_"</option>"
    .Else  Write "<option value="_EDCRowId_">"_ListVal_"</option>"
    Write "</select>"
    Quit
}

/// ##class(web.DHCPE.ResultDiagnosis).GetRisResult(RLTResult)
ClassMethod GetRisResult(RLTResult)
{
 s RisString1=$p(RLTResult,";检查所见:",1)  
 s RisString2=$p(RLTResult,";检查所见:",2)
 s RisString12=$p(RisString1,"临床诊断:",2)
 i RisString12="" d
 .s RisString=""
 e  d
 .s RisString=RisString1_";"
 //s RisString21=$p(RisString2,";诊断意见:",1)
 //i RisString21'="" d
 //.s RisString=RisString_"检查所见:"_RisString21_";"
 s RisString22=$p(RisString2,";诊断意见:",2)
 i RisString22'="" d
 .//s RisString=RisString_"诊断意见:"_RisString22
 .i ""'=RisString12  s RisString=RisString_"诊断意见:"_RisString22
 .e  s RisString=RisString_RisString22
 s RLTResult=RisString
 q RLTResult
}

ClassMethod GetSSDiagnosisClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSSDiagnosisExecute ]
{
    Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetSSDiagnosisExecute(ByRef qHandle As %Binary, EpisodeID) As %Status
{

 Set repid=$I(^CacheTemp)
 s ind=1
 s id="0"
 q:EpisodeID="" $$$OK
 s SSID=..GetSSId(EpisodeID)
 s AuditDocName="",AuditDoc=""
 i SSID'="" s AuditDoc=$p($G(^DHCPEGS(SSID,1)),"^",5)
 i AuditDoc'="" s AuditDocName=$p($g(^SSU("SSUSR",AuditDoc)),"^",2)
 s Sub=0
 s Sort=""
 i SSID'=""  Do
 .f  s Sort=$o(^DHCPEGS(0,"GSDSort",SSID,Sort)) q:Sort=""  d
 ..s Sub=0
 ..f  s Sub=$o(^DHCPEGS(0,"GSDSort",SSID,Sort,Sub)) q:Sub=""  d
 ...//f  s Sub=$o(^DHCPEGS(SSID,"Diagnosis",Sub)) q:Sub=""  d
 ...s SSRId=SSID_"||"_Sub
 ...s RLID=$p(^DHCPEGS(SSID,"Diagnosis",Sub),"^",1)
 ...q:RLID=""
 ...s RIDDesc=$p(^DHCPEGS(SSID,"Diagnosis",Sub),"^",9)
 ...//$p($g(^DHCPEED(RLID,"Detail")),"^",1)
 ...s ItemDesc=$p($g(^DHCPEED(RLID,"1")),"^",1)
 ...s User=$p($g(^DHCPEED(RLID,1)),"^",4)
 ...i User'="" s User=$p($g(^SSU("SSUSR",User)),"^",2)
 ...s (Date)=""
 ...s Remark=$p(^DHCPEGS(SSID,"Diagnosis",Sub),"^",3)
 ...s SRLID=$p(^DHCPEGS(SSID,"Diagnosis",Sub),"^",2)
 ...s Station=""
 ...i SRLID'="" d
 ....S SSID1=+SRLID
 ....s StationID=$p($G(^DHCPESS(SSID1,1)),"^",2)
 ....s Station=$p($G(^DHCPEST(StationID)),"^",2)
 ...Set EDCDesc=""
 ...Set EDCDR=$g(^DHCPEDataEx("DHCPEGSDiagnosis","EDCDR",SSRId))
 ...If EDCDR'="" Set EDCDesc=$p($g(^DHCPEEDC(EDCDR)),"^",2)
 ...Set ItemColName="EDCDescz"_ind
 ...s DisplayDesc=$g(^DHCPEDataEx("DHCPEGSDiagnosis","DisplayDesc",SSRId))
 ...s UserID=$P($g(^DHCPEDataEx("DHCPEGeneralSummarize","MainDoctor",EpisodeID)),"^",1)
 ...s UserName=""
 ...i UserID'="" s UserName=$p($g(^SSU("SSUSR",UserID)),"^",2)
 ...s ReCheckDate="",ReCheckTime=""
 ...s ReCheckDate=$P($g(^DHCPEDataEx("DHCPEGeneralSummarize","MainDoctor",EpisodeID)),"^",2)
 ...i ReCheckDate'="" s ReCheckDate=$zd(ReCheckDate,3)
 ...s ReCheckTime=$P($g(^DHCPEDataEx("DHCPEGeneralSummarize","MainDoctor",EpisodeID)),"^",3)
 ...i ReCheckTime'=""  s ReCheckTime=$zt(ReCheckTime,3)
 ...s ReCheckDate=ReCheckDate_" "_ReCheckTime
 ...d Build 

    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
Build
    //          PGT_ParRef, PGT_RowId, PGT_ChildSub, PGT_ParRef_Name, PGT_Desc, PGT_Sex, PGT_UpperLimit, PGT_LowerLimit, PGT_Married, PGT_Married_Desc ,PGT_UpdateUser_DR, PGT_UpdateUser_DR_Name, PGT_UpdateDate
 set Data=$lb(SSRId, RLID, User, ItemDesc, Date, Remark,RIDDesc,Station,Sort,EDCDR,$g(EDCDesc),ItemColName,DisplayDesc,UserName,ReCheckDate,AuditDocName)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 q
}

ClassMethod GetSSDiagnosisFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSSDiagnosisExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {                // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {            
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

/// 根据PAADM?ChartID得到科室小结ID
ClassMethod GetSSId(EpisodeID)
{
    ;w ##class(web.DHCPE.ResultDiagnosis).GetSSId(158)
    Quit:$g(EpisodeID)="" ""
    //
    Set IAdm=$O(^DHCPEIADM(0,"PAADM",EpisodeID,0))
    //b ;IAdm
    i IAdm'="" d
    .s StationSummaryDr=$o(^DHCPEGS(0,"IADM",IAdm,0))
    e  d
    .s StationSummaryDr=$o(^DHCPEGS(0,"PAADM",EpisodeID,0))
    q StationSummaryDr
}

/// 得到总检建议的结论
ClassMethod GetSSRemark(PAADM)
{
    s SSID=..GetSSId(PAADM)
    q:SSID="" ""
    
    s Remark=$p($g(^DHCPEGS(SSID,"S")),"^",1)
    q Remark
}

ClassMethod GetSSResultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSSResultExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetSSResultExecute(ByRef qHandle As %Binary, EpisodeID, Include) As %Status
{
    Set repid=$I(^CacheTemp)
    s Job=$J
    /*
    s LabStation=$g(^DHCPESetting("DHCPE","StationId_Lab"))
    s RisStation=$g(^DHCPESetting("DHCPE","StationId_Ris"))
    */
    s ind=1
    s id="0"
    q:EpisodeID="" $$$OK
        s LocID=$P($g(^PAADM(EpisodeID)),"^",4)
     s LabStation=$g(^DHCPESetting("DHCPE","StationId_Lab",LocID))
    s RisStation=$g(^DHCPESetting("DHCPE","StationId_Ris",LocID))

    Set myStr=##class(web.DHCPE.ResultEdit).GetAgeSex(EpisodeID)
    Set myAge=$p(myStr,"^",1)
    Set mySex=$p(myStr,"^",2)

    s SSID=..GetSSId(EpisodeID)

 s Sub=0
 i SSID'=""{
 f  s Sub=$o(^DHCPEGS(SSID,"Result",Sub)) q:Sub=""  d
 .s User=""
 .s SSRId=SSID_"||"_Sub
 .s SRID=$p(^DHCPEGS(SSID,"Result",Sub),"^",1)
 .s RLID=$p($G(^DHCPESS($p(SRID,"||",1),"Result",$p(SRID,"||",2))),"^",1)
 .q:RLID=""
 .//协和高危
 .s HighRisk=$p($g(^DHCPERLT(RLID)),"^",12)
 .s FollowUpFlag=$p($g(^DHCPERLT(RLID)),"^",13)
 .i HighRisk="Y"  s HighRisk="1"
 .i FollowUpFlag="Y" s FollowUpFlag=1   
 .s RIDDesc=$p($g(^DHCPERLT(RLID)),"^",4)
 .s OrderDetailID=$p($g(^DHCPERLT(RLID)),"^",3)
 .i LabStation=+OrderDetailID d
 ..s TNormalResult=$G(^DHCPEDataEx("DHCPEResult",RLID,"Ranges"))
 .e  d
 ..s TNormalResult=##class(web.DHCPE.ResultEdit).GetNormal(OrderDetailID,mySex,myAge)
 .s UserCode=$p($g(^DHCPERLT(RLID)),"^",5)
 .s RLTOEORIDR=$p($g(^DHCPERLT(RLID)),"^",9)
 .;i $g(^DHCPESetting("DHCPE","LisInterface"))="Y"  d
  .i $g(^DHCPESetting("DHCPE","LisInterface",LocID))="Y"  d
 ..i UserCode'="" s User=$p($g(^SSU("SSUSR",UserCode)),"^",2)
 .s Arrow=""
 .s labFlag=0
 .i OrderDetailID'="" d
 ..s LabDetailCode=$p($G(^DHCPEST(+OrderDetailID,"OD",$p(OrderDetailID,"||",2))),"^",10)
 ..//q:LabDetailCode=""
 ..s Station=+OrderDetailID
 ..s StationDesc=$p(^DHCPEST(Station),"^",2)
 ..i Station=LabStation d
 ...s labFlag=1
 ...s Arrow=##class(web.DHCPE.TransResult).GetLabResultArrow(TNormalResult,RIDDesc)
 ...;s namespaceLab=^DHCPESetting("NAMESPACE","LABDATA")
 ...s namespaceLab=^DHCPESetting("NAMESPACE","LABDATA",LocID)
 ...i UserCode'="" s User=$p($g(^[namespaceLab]SSU("SSUSR",1,UserCode)),"^",2)
 ..e  d
 ...i UserCode'="" s User=$p($g(^SSU("SSUSR",UserCode)),"^",2)
 ...i ("^"_RisStation_"^")[("^"_Station_"^") d
 ....///检查结果太长总检看不到结果
 ....i RIDDesc="" d
 .....s arcimRowID=$p($g(^DHCPERLT(RLID)),"^",9)
 .....q:arcimRowID=""
 .....s RIDDesc=$g(^DHCPETempResult(arcimRowID))
 .....///End
 ....s RIDDesc=..GetRisResult(RIDDesc)
 .i RIDDesc="" d
 ..s arcimRowID=$p($g(^DHCPERLT(RLID)),"^",9)
 ..q:arcimRowID=""
 ..s RIDDesc=$g(^DHCPETempResult(arcimRowID))
 ..s RIDDesc=..GetRisResult(RIDDesc)
 .s TempDesc=$p($g(^DHCPERLT(RLID)),"^",10)
 .s ARCIM=$p($g(^DHCPERLT(RLID)),"^",3)
 .s LabSpecNo=""
 .i ARCIM'="" d
 ..s ItemDesc=$p($g(^DHCPEST(+ARCIM,"OD",$p(ARCIM,"||",2))),"^",1)
 ..i labFlag="1" d
 ...s arcimRowID=$p($g(^DHCPERLT(RLID)),"^",9)
 ...s LabSpecNo=$p($G(^OEORD(+arcimRowID,"I",$P(arcimRowID,"||",2),3)),"^",20)
 
 ...s ItemUOMDr=$G(^DHCPEDataEx("DHCPEResult",RLID,"Unit"))
 ..e  d
 ...s ItemUOMDr=$P($g(^DHCPEST(+ARCIM,"OD",$P(ARCIM,"||",2))),"^",4)
 .e  d
 ..s ItemDesc=""
 ..s ItemUOMDr=""
 .i $L(ItemDesc,"-检查结果")>1 s ItemDesc=$P(ItemDesc,"-",$L(ItemDesc,"-"))
 .q:RIDDesc=""
 .s RIDDesc=RIDDesc_" "_ItemUOMDr
 .s Date=$p($g(^DHCPERLT(RLID)),"^",6)
 .i Date'="" s Date=$ZD(Date,3)
 .s Time=$p($g(^DHCPERLT(RLID)),"^",11)
 .i Time'="" s Time=$ZT(Time,3)
 .s Date=Date_" "_Time
 .s Remark=$p(^DHCPEGS(SSID,"Result",Sub),"^",2)
 .s Report=$p(^DHCPEGS(SSID,"Result",Sub),"^",6)
 .q:(Report'="Y")&&(Include="")
 .//2007-07-30
 .s ARCID=$p($g(^DHCPERLT(RLID)),"^",2)
 
 .
 .i ARCID'="" d
 ..s myItemStr= $G(^ARCIM($p(ARCID,"||",1),$p(ARCID,"||",2),1))
 ..s ARCDesc=$P(myItemStr,"^",2)
 .e  d
 ..s ARCDesc=""
 .i labFlag="1" d
 ..s ARCDesc=..GetAllNameBySpecNo(LabSpecNo)
 .
 .s NormalFlag=""
 .s Arrow=1
 .s NormalFlag=$P($G(^DHCPERLT(RLID)),"^",7)
 .s Arrow=##class(web.DHCPE.TransResult).GetLabResultArrow(TNormalResult,$P($g(^DHCPERLT(RLID)),"^",4))
 .i (Arrow="1")&&(NormalFlag=0) s Arrow=3
 .s NormalFlag=Arrow
 .
 .d Build

 s stationID=""
 ;s Job=3596
 f  s stationID=$o(^TempDHCPE(Job,stationID)) q:stationID=""  d
 .q:stationID="SSResult"
 .s OEORIID="" 
 .f  s OEORIID=$o(^TempDHCPE(Job,stationID,OEORIID)) q:OEORIID=""  d
 ..s Sort=""
 ..f  s Sort=$o(^TempDHCPE(Job,stationID,OEORIID,Sort)) q:Sort=""  d
 ...s DetailID=""
 ...f  s DetailID=$o(^TempDHCPE(Job,stationID,OEORIID,Sort,DetailID)) q:DetailID=""  d
 ....s RLID=""
 ....f  s RLID=$o(^TempDHCPE(Job,stationID,OEORIID,Sort,DetailID,RLID)) q:RLID=""  d
 .....s Data=$G(^TempDHCPE(Job,stationID,OEORIID,Sort,DetailID,RLID))
 .....Set ^CacheTemp(repid,ind)=Data
 .....Set ind=ind+1
 k ^TempDHCPE(Job,"SSResult")
 k ^TempDHCPE(Job)
 }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
Build
    i TempDesc'="" s RIDDesc=RIDDesc_"("_TempDesc_")"
    //          PGT_ParRef, PGT_RowId, PGT_ChildSub, PGT_ParRef_Name, PGT_Desc, PGT_Sex, PGT_UpperLimit, PGT_LowerLimit, PGT_Married, PGT_Married_Desc ,PGT_UpdateUser_DR, PGT_UpdateUser_DR_Name, PGT_UpdateDate
    set Data=$lb(SSRId, RLID, User, ItemDesc, Date, Remark,RIDDesc,Report,TempDesc,TNormalResult,StationDesc,NormalFlag,ARCDesc,HighRisk,FollowUpFlag)
 i ARCID'=""  d
 .i OrderDetailID'="" d
 ..i LabStation'=+OrderDetailID d
 ...s ODRID=0
 ...f  s ODRID=$O(^DHCPEODR(0,"OD",OrderDetailID,ODRID)) q:ODRID=""  d
 ....s ARCIID=$P($G(^DHCPEODR(ODRID)),"^",1)
 ....q:ARCIID'=ARCID
 ....s Sort=$P($G(^DHCPEODR(ODRID)),"^",3)
 ....q:Sort=""
 ....s OEORIID=$p($g(^DHCPERLT(RLID)),"^",9)
 ....i Station'="" d
 .....Set ^TempDHCPE(Job,Station,OEORIID,Sort,ODRID,RLID)=Data
 ..e  d
 ...i Station'="" d
 ....s OEORIID=$p($g(^DHCPERLT(RLID)),"^",9)
 ....Set ^TempDHCPE(Job,Station,OEORIID,RLID,RLID,RLID)=Data

 q
}

ClassMethod GetSSResultFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSSResultExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {                // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {            
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod GetAllNameBySpecNo(LabEpisodeNo)
{
    s AItemDesc=""
    q:LabEpisodeNo="" AItemDesc
    s AOEORD=$O(^OEORD(0,"EpisNo",LabEpisodeNo,0))
    q:AOEORD="" AItemDesc
    s PAADM=$P($G(^OEORD(+AOEORD)),"^",1)
    s LocID=$P($G(^PAADM(PAADM)),"^",4)
    s Asub=0
    f  s Asub=$O(^OEORD(0,"EpisNo",LabEpisodeNo,AOEORD,Asub)) q:Asub=""  d
    .s AItemStat=$p($G(^OEORD(AOEORD,"I",Asub,1)),"^",13)
    .q:AItemStat="4"
    .s AOEORIItmMastDR=$p($G(^OEORD(AOEORD,"I",Asub,1)),"^",2)
    .s AARCIMDesc=##class(web.DHCPE.DHCPECommon).GetArcDesc(AOEORIItmMastDR,"A",LocID)
    .i AItemDesc=""  d
    ..s AItemDesc=AARCIMDesc
    .e  d
    ..s AItemDesc=AItemDesc_","_AARCIMDesc
    q AItemDesc
}

ClassMethod InsertGSDM(id, Type)
{
    k PLIST
    &sql(Select * Into :PLIST() From Sqluser.DHC_PE_GSDiagnosis Where GSD_RowId=:id)
    s PLIST(13)=PLIST(0)
    k PLIST(0)
    k PLIST(1)
    s PLIST(6)=Type
    s Advice=PLIST(11)
    &SQL(Insert Into Sqluser.DHC_PE_GSDModifiedRecords Values :PLIST())
    i SQLCODE=0 d
    .s $p(^DHCPEGSDM(%ROWID),"^",9)=Advice
}

ClassMethod IsCanSumResult(EpisodeID)
{
    s Flag=##class(web.DHCPE.ResultEdit).ItemHadApp("",EpisodeID)
    q:+Flag=2 "HadNoApp^"_$p(Flag,"^",2)
    q:+Flag=0 "NoItem^"_$p(Flag,"^",2)
    s Flag=..StationSHadSubmit(EpisodeID)
    q:Flag'=0 Flag
    
    q 0
}

ClassMethod OutOrderToHTML(ChartID, EpisodeID, SSID)
{
    
    s ContrlWidth="200"
    
    s val=$G(^DHCPEDataEx("GDiaginosis",SSID))
    //下拉列表
    w "<select name='LinkOrder' id='LinkOrder"_SSID_"' style='width:"_ContrlWidth_"' HEIGHT=0>",!
    w "<option value=''>  </option>",!
    
    s curStation=##class(web.DHCPE.ResultEdit).GetPEStation(ChartID)
    s OEORDRowId=$O(^OEORD(0,"Adm",EpisodeID,0))
    s OEORIChildsub=0
    f  s OEORIChildsub=$O(^OEORD(OEORDRowId,"I",OEORIChildsub)) Q:(""=OEORIChildsub)  d
    .s OEORIRowId=OEORDRowId_"||"_OEORIChildsub
    .s OEORIItemStatDR=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",13)
    .q:OEORIItemStatDR'=6
    .s OEORIItmMastDR=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",2)
    .s Station=$O(^DHCPEST(0,"STORD_ARCIM",OEORIItmMastDR,0))
    .q:(curStation'="")&&(curStation'=Station)
    .s ARCIMSubscript=$P(OEORIItmMastDR,"||",1)
    .s ARCIMVersion=$P(OEORIItmMastDR,"||",2)
    .s ARCIMDesc=$P($G(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)
    .i val=OEORIRowId d
    ..w "<option value="_OEORIRowId_" selected>"_ARCIMDesc_"</option>",!
    .e  d
    ..w "<option value='"_OEORIRowId_"'>"_ARCIMDesc_"</option>",!
    w "</select>",!
    Quit $$$OK
}

/// 所有非检查?检验项目站点小结是否已提交
ClassMethod StationSHadSubmit(EpisodeID)
{
   
    s StationIDs=..AdmNeedStation(EpisodeID,0)
    q:StationIDs="" "NoItem^"
      s LocID=$P($g(^PAADM(EpisodeID)),"^",4)
      /*
    s LabStation=$g(^DHCPESetting("DHCPE","StationId_Lab"))
    s RisStation=$g(^DHCPESetting("DHCPE","StationId_Ris"))
    s NoSubStation=$g(^DHCPESetting("DHCPE","StationId_NoSubmit"))
    s OtherStation=$g(^DHCPESetting("DHCPE","StationId_Other"))
    */
    s LabStation=$g(^DHCPESetting("DHCPE","StationId_Lab",LocID))
    s RisStation=$g(^DHCPESetting("DHCPE","StationId_Ris",LocID))
    s NoSubStation=$g(^DHCPESetting("DHCPE","StationId_NoSubmit",LocID))
    s OtherStation=$g(^DHCPESetting("DHCPE","StationId_Other",LocID))

    s Station="^"_RisStation_"^"_LabStation_"^"_NoSubStation_"^"_OtherStation_"^"
    
    s IAdm=$o(^DHCPEIADM(0,"PAADM",EpisodeID,""))
    s Flag=0
    s Stations=""
    s l=$l(StationIDs,"^")
    for i=1:1:l
    {
        s StationID=$p(StationIDs,"^",i)
        continue:Station[("^"_StationID_"^")
        s StationDesc=$p($g(^DHCPEST(StationID)),"^",2)
        s StationDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEStation",StationDesc,"STDesc","cls") //翻译
        s SSID=##class(web.DHCPE.ResultEdit).GetSSId(EpisodeID, StationID) //$O(^DHCPESS(0,"IADM",IAdm,StationID,0))
        i SSID=""
        {
            i Stations=""
            {
                s Stations=StationDesc
            }
            else
            {
                s Stations=Stations_","_StationDesc
            }
            continue
        }
        //s:SSID="" Flag="NoSub"
        //q:Flag'=0
        s Status=$p($g(^DHCPESS(SSID,1)),"^",7)
        i Status="NA"
        {
            i Stations=""
            {
                s Stations=StationDesc
            }
            else
            {
                s Stations=Stations_","_StationDesc
            }
        }
        //s:Status="NA" Flag="NoSub"
        //q:Flag'=0
    }
    i Stations'="" q "NoSub^"_Stations
    q 0
}

ClassMethod Test()
{
 s stationID=""
 s Job=3596
 f  s stationID=$o(^TempDHCPE(Job,stationID)) q:stationID=""  d
 .s OEORIID="" 
 .f  s OEORIID=$o(^TempDHCPE(Job,stationID,OEORIID)) q:OEORIID=""  d
 ..s Sort=""
 ..f  s Sort=$o(^TempDHCPE(Job,stationID,OEORIID,Sort)) q:Sort=""  d
 ...s DetailID=""
 ...f  s DetailID=$o(^TempDHCPE(Job,stationID,OEORIID,Sort,DetailID)) q:DetailID=""  d
 ....s RLID=""
 ....f  s RLID=$o(^TempDHCPE(Job,stationID,OEORIID,Sort,DetailID,RLID)) q:RLID=""  d
 .....s Data=$G(^TempDHCPE(Job,stationID,OEORIID,Sort,DetailID,RLID))
 .....Set ind=ind+1
}

ClassMethod GetDiagnosis(GSID)
{
   
    Quit:$g(GSID)="" ""
    s val=$p(^DHCPEGS($p(GSID,"||",1),"Diagnosis",$p(GSID,"||",2)),"^",9)
    Q val
}

/// Input:  StationType:(Lab/Ris), Type:(1:重新汇总)  
/// Debug:  w ##class(web.DHCPE.ResultDiagnosis).UpdateLabRisStationS("10","1576711","Lab","1")
ClassMethod UpdateLabRisStationS(StationID, EpisodeID, StationType, Type)
{
    s iAdm=$O(^DHCPEIADM(0,"PAADM",EpisodeID,0))
    s LocID=$P($g(^PAADM(EpisodeID)),"^",4)
    //s Flag=##class(web.DHCPE.ResultEdit).ItemHadApp(StationID,EpisodeID)
    //q:Flag=2 "HadNoApp"
    //q:Flag=0 "NoItem"
    q:StationID="" ""
    //s SSID=$O(^DHCPESS(0,"IADM",iAdm,StationID,0))
    s SSID=##class(web.DHCPE.ResultEdit).GetSSId(EpisodeID,StationID)
    s PLIST(2)=iAdm
    s PLIST(3)=StationID
    s User=%session.Get("LOGON.USERID")
    s Date=+$H
    s Time=$p($H,",",2)
    s PLIST(6)=User
    s PLIST(5)=Date
    s PLIST(7)=User
    s PLIST(8)=Date
    //s PLIST(9)="SA"
    s PLIST(10)=EpisodeID
    i SSID=""
    {
        &SQL(insert into sqluser.DHC_PE_StationSummarize values :PLIST())
    }
    else
    {
        &SQL(update sqluser.DHC_PE_StationSummarize values :PLIST() where SS_RowId=:SSID)
    }
    
    q:SQLCODE SQLCODE
    s SSID=%ROWID
    i Type="1"
    {
        &SQL(delete from sqluser.DHC_PE_SSResult where SSR_ParRef=:SSID)
    }
    i SQLCODE=100 s SQLCODE=0
    q:SQLCODE SQLCODE
    
    Set RLTOEORIDR=0
    f  s RLTOEORIDR=$o( ^DHCPERLT(0,"ADMOD",EpisodeID,RLTOEORIDR))  q:RLTOEORIDR=""  Do
    .s RLTODDR=0
    .s ARCIMRowId=$p(^OEORD(+RLTOEORIDR,"I",$P(RLTOEORIDR,"||",2),1),"^",2)
    .;s CurStation=$o(^DHCPEST(0,"STORD_ARCIM",ARCIMRowId,0))
    ./***根据医嘱项获取站点（多院区）start***/
    .s StOrderDR=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ARCIMRowId,LocID)
    .q:StOrderDR=""
    .s CurStation=$p(StOrderDR,"||",1)
    ./***根据医嘱项获取站点（多院区）end***/
    .
    .q:StationID'=(+CurStation)
    .S ARCIMDesc=##class(web.DHCPE.DHCPECommon).GetArcDesc(ARCIMRowId,"A",LocID)
    .f  s RLTODDR=$o( ^DHCPERLT(0,"ADMOD",EpisodeID,RLTOEORIDR,RLTODDR))  q:RLTODDR=""  Do
    ..q:+RLTODDR=0
    ..
    ..;s ODSummary=$p($g(^DHCPEST(+RLTODDR,"OD",$p(RLTODDR,"||",2))),"^",5)
    ..;q:(ODSummary="N")  //不进入小结
    ..s ODSummary=""
    ../***不进入小结（多院区）start***/
    ..s OrdDetailSetID=$o(^CF.PE.OrderDetailSetI("IdxOfLocOrdDtl"," "_LocID,RLTODDR,0) )
    ..i OrdDetailSetID'="" s ODSummary=$lg($g(^CF.PE.OrderDetailSetD(OrdDetailSetID)),4)
    ..q:ODSummary="N" 
    ../***不进入小结（多院区）end***/
    ..
    ..s RLTRowId=0
    ..f  s RLTRowId=$o( ^DHCPERLT(0,"ADMOD",EpisodeID,RLTOEORIDR,RLTODDR,RLTRowId)) q:(RLTRowId="")  d
    ...//q:StationID'=(+RLTODDR)  如果关联的细项不是本站点的就取不到了  wrz
    ...s Normal=$p($g(^DHCPERLT(RLTRowId)),"^",7)
    ...q:(Normal="1")&&(StationType="Lab")
    ...q:(Normal="1")&&(StationType="NoSubmit")
    ...s rlt=$p($g(^DHCPERLT(RLTRowId)),"^",4)
    ...s HadSum=$o(^DHCPESS(0,"RLT",RLTRowId,0))
    ...//s HadSum=$o(^DHCPESS(0,"RLT",RLTODDR,0))  应该是结果表rowid  wrz
    ...q:(HadSum'="")&&(Type'="1")
    ...&SQL(insert into sqluser.DHC_PE_SSResult (SSR_ParRef,SSR_RLT_DR,SSR_UpdateUser_DR,SSR_UpdateDate,SSR_UpdateTime) values (:SSID,:RLTRowId,:User,:Date,:Time))
    ...//w !,ARCIMDesc_":"_RLTRowId_":"_rlt_":"_SSID_":"_RLTODDR_":"_User_":"_Date_":"_Time
    
    q SQLCODE
}

/// debug: w ##class(web.DHCPE.ResultDiagnosis).UpdateSSDiagnosis(291,"164^2",0,N)
ClassMethod UpdateSSDiagnosis(SSID, SDID, isDel, MainDoctor As %String = "")
{
    s ^temp("DHCPE","UpdateSSDiagnosis")=$lb(SSID, SDID, isDel, MainDoctor)
    
    // add by sxt 诊断不判断站点
    s STID=$P(SDID,"^",2)
    s STLocID=$P(SDID,"^",3)
    s SDID=$P(SDID,"^",1)
    //s STLocID=""
    i $L(STID,"||")>1 d
    .s STLocID=STID
    .s STID=+STID
    // add by sxt 诊断不判断站点 end
    
    s Status=$p($g(^DHCPEGS(SSID,1)),"^",5)
    ;s curGroup=%session.Get("LOGON.GROUPID")
    q:(Status'="")&&(MainDoctor="") "HadAudit"
    q:(MainDoctor="Y")&&(Status="") "NoAudit"
    s User=%session.Get("LOGON.USERID")
    ;s User=1
    s Date=+$H
    s Time=$P($H,",",2)
    s IADM=$P(^DHCPEGS(SSID,1),"^",1)
    i IADM="" d
    .s PAADM=$P(^DHCPEGS(SSID,1),"^",8)
    e  d
    .s PAADM=$P(^DHCPEIADM(IADM),"^",1)
    s LocID=$P($G(^PAADM(PAADM)),"^",4)
    q:(MainDoctor="Y")&&($d(^DHCPEDataEx("DHCPEGeneralSummarize","MainDoctor",PAADM))) "ReMainHadAudit"
    ;i isDel=1
    i isDel>0  
    {
        s i=$L(SDID,"^")
        s j=1
        TSTART
        for j=1:1:i d
        .s ID=$p(SDID,"^",j)
        .s EDID=$P(^DHCPEGS(+ID,"Diagnosis",$P(ID,"||",2)),"^",1)
        .s StationDID=$P(^DHCPEGS(+ID,"Diagnosis",$P(ID,"||",2)),"^",2)
        .i StationDID="" d ;是否从科室过来
        ..i $D(^DHCPEED(EDID,"UseCount")) d
        ...s Sort=$G(^DHCPEED(EDID,"UseCount"))-1
        ...i Sort=0 d
        ....k ^DHCPEED(EDID,"UseCount")
        ...e  d
        ....s ^DHCPEED(EDID,"UseCount")=Sort
        .;&SQL(delete from sqluser.DHC_PE_GSDiagnosis where GSD_RowId=:ID)
        .&SQL(Update sqluser.DHC_PE_GSDiagnosis set GSD_Status=:isDel where GSD_RowId=:ID)
        .break:SQLCODE'=0
        i SQLCODE TROLLBACK
        i SQLCODE=0 TCOMMIT
        q SQLCODE
    }
    s EDDesc=$p(^DHCPEED(SDID,1),"^",1)
    if (EDDesc'[("详见报告"))&&(EDDesc'[("默认"))
    {
        &SQL(select GSD_ED_DR from sqluser.DHC_PE_GSDiagnosis where GSD_ParRef=:SSID and GSD_ED_DR=:SDID and GSD_Status='0' and GSD_ChildSub>0)
        q:SQLCODE=0 "HadDiagnosis"
    }
    s Sort=$o(^DHCPEGS(0,"GSDSort",SSID,""),-1)
    i Sort="" s Sort=0
    s Sort=Sort+1
    s Advice=$p(^DHCPEED(SDID,"Detail"),"^",1)
    s TableStr=" "_$ZCVT("User.DHCPEExpertDiagnosis","U")
    s FieldStr=" "_$ZCVT("EDDetail","U")
    s tansid=$o(^User.BDPTranslationI("TransIndex",TableStr,FieldStr," EN",Advice,0))
    i tansid'="" s Advice=$lg(^User.BDPTranslationD(tansid),6)
    ;s Advice=##class(web.DHCPE.DHCPEExpertDiagnosis).GetKeyReplaceStr(PAADM,SDID)
    s Advice=##class(web.DHCPE.DHCPEExpertDiagnosis).ReplactApp(PAADM,Advice)
    // 增加乙肝标志 add
    s YGFlag=$p($g(^DHCPEED(SDID,1)),"^",12)
    ;s YGFlag=$g(^DHCPECTDataEx("BaseData","DHCPEExpertDiagnosis","YGCheck",SDID))
    s:YGFlag'="Y" YGFlag="N"
    // 增加乙肝标志 end
    &SQL(insert into sqluser.DHC_PE_GSDiagnosis (GSD_ParRef,GSD_ED_DR,GSD_UpdateUser_DR,GSD_UpdateDate,GSD_UpdateTime,GSD_ReportPrint,GSD_GenType,GSD_Advice,GSD_Sort,GSD_Status,GSD_ST_DR,GSD_STloc_DR,GSD_YGFlag) values (:SSID,:SDID,:User,:Date,:Time,'Y','D',:Advice,:Sort,'0',:STID,:STLocID,:YGFlag))
    
    //&SQL(insert into sqluser.DHC_PE_GSDiagnosis (GSD_ParRef,GSD_ED_DR,GSD_UpdateUser_DR,GSD_UpdateDate,GSD_UpdateTime,GSD_ReportPrint,GSD_GenType,GSD_Advice,GSD_Sort,GSD_Status,GSD_YGFlag) values (:SSID,:SDID,:User,:Date,:Time,'Y','D',:Advice,:Sort,'0',:YGFlag))
    If 'SQLCODE Do
    .Set GSDRowId=%ROWID
    .s Sort=$I(^DHCPEED(SDID,"UseCount"))
    .s DisplayDesc=$p(^DHCPEED(SDID,1),"^",1)
    .s TableStr=" "_$ZCVT("User.DHCPEExpertDiagnosis","U")
    .s FieldStr=" "_$ZCVT("EDDiagnoseConclusion","U")
    .s tansid=$o(^User.BDPTranslationI("TransIndex",TableStr,FieldStr," EN",DisplayDesc,0))
    .i tansid'="" s DisplayDesc=$lg(^User.BDPTranslationD(tansid),6)
    .s DisplayDesc=##class(web.DHCPE.DHCPEExpertDiagnosis).ReplactApp(PAADM,DisplayDesc)
    .;s DisplayDesc="["_DisplayDesc_"]"
    .;i $g(^DHCPESetting("DHCPE","ShowEDDiagnosisSign"))="Y" s DisplayDesc="["_DisplayDesc_"]"
    .i $g(^DHCPESetting("DHCPE","ShowEDDiagnosisSign",LocID))="Y" s DisplayDesc="["_DisplayDesc_"]"
    .Set ResultInfo=##class(web.DHCPE.ReportGetInfor).GetAdviceResult(SDID,PAADM)
    .i ResultInfo'="" s DisplayDesc=DisplayDesc_ResultInfo
    .s:MainDoctor="Y" ^DHCPEDataEx("DHCPEGeneralSummarize","ReCheckDetail",GSDRowId)=$H_"^"_User
    .Set ^DHCPEDataEx("DHCPEGSDiagnosis","DisplayDesc",GSDRowId)=DisplayDesc   //Add 
    .;Set ^DHCPEDataEx("DHCPEGSDiagnosis","DisplayDesc",DisplayDesc,GSDRowId)=$h  //Add 
    .Set EDCDR=##class(web.DHCPE.ResultEdit).GetEDCDR(SDID)
    .d ..InsertGSDM(GSDRowId,"I")
    .If EDCDR'="" Do 
    ..Set ^DHCPEDataEx("DHCPEGSDiagnosis","EDCDR",GSDRowId)=EDCDR
    ..Set ^DHCPEDataEx("DHCPEGSDiagnosis","EDCDR",0,"EDCDR",SSID,EDCDR,GSDRowId)=""
    
    q SQLCODE_"^"_GSDRowId_"^"_DisplayDesc_"^"_Advice_"^"_Sort
}

ClassMethod UpdateStationDRemark(Strings, MainDoctor As %String = "", SortFlag As %String = "0")
{
    s SSID=+Strings
    s IADM=$P(^DHCPEGS(SSID,1),"^",1)
    i IADM="" d
    .s PAADM=$P(^DHCPEGS(SSID,1),"^",8)
    e  d 
    .s PAADM=$P($g(^DHCPEIADM(IADM)),"^",1)
    s LocID=$P($G(^PAADM(PAADM)),"^",4)
    s Status=$p($g(^DHCPEGS(SSID,1)),"^",5)
    s curGroup=%session.Get("LOGON.GROUPID")
    s MainDoctorGroup=$G(^DHCPESetting("DHCPE","MainDoctorGroup",LocID))
    ;q:(Status'="")&&(curGroup'=MainDoctorGroup) "HadAudit"
    
    //提交后不允许修改
    //q:(Status'="")&&(MainDoctor'="Y") "HadAudit"
    
    ;q:(curGroup=MainDoctorGroup)&&(Status="") "NoAudit"
    q:(MainDoctor="Y")&&(Status="") "NoAudit"
    ;q:(curGroup=MainDoctorGroup)&&($d(^DHCPEDataEx("DHCPEGeneralSummarize","MainDoctor",PAADM))) "ReMainHadAudit"
    q:(MainDoctor="Y")&&($d(^DHCPEDataEx("DHCPEGeneralSummarize","MainDoctor",PAADM))) "ReMainHadAudit"
    
    s UserID=%session.Get("LOGON.USERID")
    s j=$l(Strings,"^")
    s SQLCODE=0
    //TSTART
    f i=1:1:j
    {
        s String=$p(Strings,"^",i)
        s ID=$p(String,"&&",1)
        s Remark=$p(String,"&&",2)
        s Advice=$p(String,"&&",3)
        s Sort=$p(String,"&&",4)
        s EDCRowId=$p(String,"&&",5)
        s OEItemID=$p(String,"&&",6)
        S DisplayDesc=$p(String,"&&",7)
        s ReCheck=$p(String,"&&",8)
        //复检医生对诊断记录进行操作 start
        ;If curGroup=MainDoctorGroup  d
        //if MainDoctor="Y" d
        /*
        If ReCheck="Y"  d
        .s ^DHCPEDataEx("DHCPEGeneralSummarize","ReCheckDetail",ID)=$H_"^"_UserID
        else  d
        .i $d(^DHCPEDataEx("DHCPEGeneralSummarize","ReCheckDetail",ID))  d
        ..Kill ^DHCPEDataEx("DHCPEGeneralSummarize","ReCheckDetail",ID)
        */
        
        //复检医生对诊断记录进行操作 end
        
        //如果SortFlag为1，可以对建议排序；如果为0，建议不排序
        if (SortFlag="1"){
            &SQL(update sqluser.DHC_PE_GSDiagnosis set GSD_DiagnoseConclusion=:Remark,GSD_Sort=:Sort where GSD_RowId=:ID) 
        }else{
            &SQL(update sqluser.DHC_PE_GSDiagnosis set GSD_DiagnoseConclusion=:Remark where GSD_RowId=:ID) 
        
        }

        
        Set OldDisplay=$g(^DHCPEDataEx("DHCPEGSDiagnosis","DisplayDesc",ID))  
        If (OldDisplay'="") Do
        .;If ($D(^DHCPEDataEx("DHCPEGSDiagnosis","DisplayDesc",OldDisplay,ID))) d
        .;.k ^DHCPEDataEx("DHCPEGSDiagnosis","DisplayDesc",OldDisplay,ID)
        Set ^DHCPEDataEx("DHCPEGSDiagnosis","DisplayDesc",ID)=DisplayDesc
        ;If DisplayDesc'="" Set ^DHCPEDataEx("DHCPEGSDiagnosis","DisplayDesc",DisplayDesc,ID)=$h   //Add 20080728
        q:SQLCODE
        s $p(^DHCPEGS(+ID,"Diagnosis",$p(ID,"||",2)),"^",9)=Advice
        d ..InsertGSDM(ID,"U")
        i OEItemID="" d
        .k ^DHCPEDataEx("GDiaginosis",ID)
        e  d
        .s ^DHCPEDataEx("GDiaginosis",ID)=OEItemID
        Do UpdateGSEDC
    }
    i SQLCODE
    {
        //TROLLBACK
        q SQLCODE
    }
    //TCOMMIT
    q SQLCODE

UpdateGSEDC
    Set DelEDCRowId=$g(^DHCPEDataEx("DHCPEGSDiagnosis","EDCDR",ID))
    If DelEDCRowId'="" Do
    .k ^DHCPEDataEx("DHCPEGSDiagnosis","EDCDR",0,"EDCDR",+ID,DelEDCRowId,ID)
    If EDCRowId'="" Do
    .Set ^DHCPEDataEx("DHCPEGSDiagnosis","EDCDR",ID)=EDCRowId
    .Set ^DHCPEDataEx("DHCPEGSDiagnosis","EDCDR",0,"EDCDR",+ID,EDCRowId,ID)=""
    Else  Do
    .If DelEDCRowId'="" Do
    ..k ^DHCPEDataEx("DHCPEGSDiagnosis","EDCDR",ID)
}

ClassMethod UpdateSortOrder(Strings)
{
    s SSID=+Strings
    s IADM=$P($g(^DHCPEGS(SSID,1)),"^",1)
    s PAADM=$P($g(^DHCPEIADM(IADM)),"^",1)
    s Status=$p($g(^DHCPEGS(SSID,1)),"^",5)
    s curGroup=%session.Get("LOGON.GROUPID")
    s LocID=$P($g(^PAADM(PAADM)),"^",4)
    
    //s MainDoctorGroup=$G(^DHCPESetting("DHCPE","MainDoctorGroup"))
    s MainDoctorGroup=$G(^DHCPESetting("DHCPE","MainDoctorGroup",LocID))

    q:(Status'="")&&(curGroup'=MainDoctorGroup) "HadAudit"
    q:(curGroup=MainDoctorGroup)&&(Status="") "NoAudit"
    q:(curGroup=MainDoctorGroup)&&($d(^DHCPEDataEx("DHCPEGeneralSummarize","MainDoctor",PAADM))) "ReMainHadAudit"
    s UserID=%session.Get("LOGON.USERID")
    s j=$l(Strings,"^")
    s SQLCODE=0
    TSTART
    f i=1:1:j
    {
        s String=$p(Strings,"^",i)
        s ID=$p(String,"&&",1)
        s Remark=$p(String,"&&",2)
        s Advice=$p(String,"&&",3)
        s Sort=$p(String,"&&",4)
        s EDCRowId=$p(String,"&&",5)
        s OEItemID=$p(String,"&&",6)
        S DisplayDesc=$p(String,"&&",7)
        s ReCheck=$p(String,"&&",8)
        //复检医生对诊断记录进行操作 start
        If curGroup=MainDoctorGroup  d
        .If ReCheck="Y"  d
        ..s ^DHCPEDataEx("DHCPEGeneralSummarize","ReCheckDetail",ID)=$H_"^"_UserID
        .else  d
        ..i $d(^DHCPEDataEx("DHCPEGeneralSummarize","ReCheckDetail",ID))  d
        ...Kill ^DHCPEDataEx("DHCPEGeneralSummarize","ReCheckDetail",ID)
        //复检医生对诊断记录进行操作 end
        &SQL(update sqluser.DHC_PE_GSDiagnosis set GSD_DiagnoseConclusion=:Remark,GSD_Sort=:Sort where GSD_RowId=:ID) //,GSD_Advice=:Advice
        Set OldDisplay=$g(^DHCPEDataEx("DHCPEGSDiagnosis","DisplayDesc",ID))  //Add 20080728
        If (OldDisplay'="") Do   //Add 20080728
        .If ('$D(^DHCPEDataEx("DHCPEGSDiagnosis","DisplayDesc",OldDisplay,ID))) Kill ^DHCPEDataEx("DHCPEGSDiagnosis","DisplayDesc",OldDisplay,ID)  //Add 20080728
         Set ^DHCPEDataEx("DHCPEGSDiagnosis","DisplayDesc",ID)=DisplayDesc  //Add 20080728
         If DisplayDesc'="" Set ^DHCPEDataEx("DHCPEGSDiagnosis","DisplayDesc",DisplayDesc,ID)=$h   //Add 20080728
        q:SQLCODE
        //s $p(^DHCPEGS(+ID,"Diagnosis",$p(ID,"||",2)),"^",9)=Advice
        d ..InsertGSDM(ID,"U")
        i OEItemID="" d
        .k ^DHCPEDataEx("GDiaginosis",ID)
        e  d
        .s ^DHCPEDataEx("GDiaginosis",ID)=OEItemID
        Do UpdateGSEDC
    }
    i SQLCODE
    {
        TROLLBACK
        q SQLCODE
    }
    TCOMMIT
    q SQLCODE

UpdateGSEDC
    Set DelEDCRowId=$g(^DHCPEDataEx("DHCPEGSDiagnosis","EDCDR",ID))
    If DelEDCRowId'="" Do
    .k ^DHCPEDataEx("DHCPEGSDiagnosis","EDCDR",0,"EDCDR",+ID,DelEDCRowId,ID)
    If EDCRowId'="" Do
    .Set ^DHCPEDataEx("DHCPEGSDiagnosis","EDCDR",ID)=EDCRowId
    .Set ^DHCPEDataEx("DHCPEGSDiagnosis","EDCDR",0,"EDCDR",+ID,EDCRowId,ID)=""
    Else  Do
    .If DelEDCRowId'="" Do
    ..k ^DHCPEDataEx("DHCPEGSDiagnosis","EDCDR",ID)
}

/// Type 是否重新汇总原来的已经统计过的  1是
/// w ##class(web.DHCPE.ResultDiagnosis).UpdateStationS(158,0,"")
ClassMethod UpdateStationS(EpisodeID, Type, Remark)
{
    
    //s Flag=##class(web.DHCPE.ResultEdit).ItemHadApp("",EpisodeID)
    
    //q:+Flag=2 "HadNoApp^"_$p(Flag,"^",2)
    //q:+Flag=0 "NoItem^"_$p(Flag,"^",2)
    s LocID=$P($G(^PAADM(EpisodeID)),"^",4)
    /*  
    s LabStation=$g(^DHCPESetting("DHCPE","StationId_Lab"))
    s RisStation="^"_$g(^DHCPESetting("DHCPE","StationId_Ris"))_"^"
    s NoSubStation="^"_$g(^DHCPESetting("DHCPE","StationId_NoSubmit"))_"^"
    */
    s LabStation=$g(^DHCPESetting("DHCPE","StationId_Lab",LocID))
    s RisStation="^"_$g(^DHCPESetting("DHCPE","StationId_Ris",LocID))_"^"
    s NoSubStation="^"_$g(^DHCPESetting("DHCPE","StationId_NoSubmit",LocID))_"^"
    s iAdm=$O(^DHCPEIADM(0,"PAADM",EpisodeID,0))
    s SSID=..GetSSId(EpisodeID)
    s PLIST(2)=iAdm
    //s PLIST(3)=StationID
    s User=%session.Get("LOGON.USERID")
    s Date=+$H
    s Time=$p($H,",",2)
    s PLIST(5)=User
    s PLIST(4)=Date
    s PLIST(6)=Time
    //s PLIST(7)="NA"
    s PLIST(3)=Remark
    s PLIST(10)=EpisodeID
    //s Flag=..StationSHadSubmit(EpisodeID)
    //q:Flag'=0 Flag
    i SSID'=""
    {
        s Status=$p($g(^DHCPEGS(SSID,1)),"^",5)
        q:Status'="" "HadAudit"
    }
    ;d ##class(web.DHCPE.TransResult).TransMain(EpisodeID)  //Add by MLH20071024
    ;d ##Class(web.DHCPE.TransResult).LabResultLast(EpisodeID) 
    TSTART
    i SSID=""
    {
        &SQL(insert into sqluser.DHC_PE_GeneralSummarize values :PLIST())
        i SQLCODE
        {
            TROLLBACK
            q SQLCODE_"^gs"
        }
        s SSID=%ROWID
        s SQLCODE=##class(web.DHCPE.ResultEdit).GenAdmGeneralRecomm(EpisodeID,SSID)
        //s HighRiskFlag=##class(web.DHCPE.HighRisk).GetHighRiskFlag(EpisodeID)
    }
    else
    {
        &SQL(update sqluser.DHC_PE_GeneralSummarize values :PLIST() where GS_RowId=:SSID)
        i SQLCODE
        {
            TROLLBACK
            q SQLCODE_"^ugs"
        }
        i Type=1
        {
            &SQL(delete from sqluser.DHC_PE_GSDiagnosis where GSD_ParRef=:SSID) // and GSD_GenType='L'
            i SQLCODE=100 s SQLCODE=0
            i SQLCODE
            {
                TROLLBACK
                q SQLCODE_"^dgs"
            }
            ;S SQLCODE=##class(web.DHCPE.ResultEdit).GenAdmGeneralRecomm(EpisodeID,SSID)
            //s HighRiskFlag=##class(web.DHCPE.HighRisk).GetHighRiskFlag(EpisodeID)
        }else{
            ;S SQLCODE=##class(web.DHCPE.ResultEdit).GenAdmGeneralRecomm(EpisodeID,SSID)
        }
    }
    i SQLCODE
    {
        TROLLBACK
        q SQLCODE_"^gagr"
    }
    i Type="1"
    {
        &SQL(delete from sqluser.DHC_PE_GSResult where GSR_ParRef=:SSID)
    }
    i SQLCODE=100 s SQLCODE=0
    i SQLCODE
    {
        TROLLBACK
        q SQLCODE_"^gsr"
    }
    s StationIDs=..AdmNeedStation(EpisodeID)
    s l=$l(StationIDs,"^")
    for i=1:1:l
    {
        s StationID=$p(StationIDs,"^",i)
        continue:StationID=""
        i StationID=LabStation d
        .s SQLCODE=..UpdateLabRisStationS(StationID,EpisodeID,"Lab",Type)
        i RisStation[("^"_StationID_"^") d
        .s SQLCODE=..UpdateLabRisStationS(StationID,EpisodeID,"Ris",Type)
        q:SQLCODE'=0
        i NoSubStation[("^"_StationID_"^") d
        .s SQLCODE=..UpdateLabRisStationS(StationID,EpisodeID,"NoSubmit",Type)
        q:SQLCODE'=0
    }
    i SQLCODE
    {
        TROLLBACK
        q SQLCODE_"^gslr"
    }
    s NoIncludeDiagnosis=$G(^DHCPESetting("DHCPE","NoIncludeDiagnosis"))
    s StationDR=0
    i iAdm'="" d
    .f  s StationDR=$o(^DHCPESS(0,"IADM",iAdm,StationDR)) q:(StationDR="")||(SQLCODE'=0)  d
    ..s SSDR=0
    ..f  s SSDR=$o(^DHCPESS(0,"IADM",iAdm,StationDR,SSDR)) q:(SSDR="")||(SQLCODE'=0)  d
    ...d SetOneInfo
    e  d
    .f  s StationDR=$o(^DHCPESS(0,"PAADM",EpisodeID,StationDR)) q:(StationDR="")||(SQLCODE'=0)  d
    ..s SSDR=0
    ..f  s SSDR=$o(^DHCPESS(0,"PAADM",EpisodeID,StationDR,SSDR)) q:(SSDR="")||(SQLCODE'=0)  d
    ...d SetOneInfo
    
    
    i SQLCODE
    {
        TROLLBACK
        q SQLCODE_"^gss"
    }
    d ##class(web.DHCPE.ResultEdit).GenAdmGeneralRecomm(EpisodeID,SSID)
    TCOMMIT
    q SQLCODE_"^"
    
SetOneInfo
    s SSRSub=0
    f  s SSRSub=$o(^DHCPESS(SSDR,"Result",SSRSub)) q:(SSRSub="")||(SQLCODE'=0)  d
    .s SSRDR=SSDR_"||"_SSRSub
    .s HadSum=$o(^DHCPEGS(0,"SSRDR",SSRDR,0))
    .q:(HadSum'="")&&(Type'="1")
    .s RRemark=$p(^DHCPESS(SSDR,"Result",SSRSub),"^",2)
    .&SQL(insert into sqluser.DHC_PE_GSResult (GSR_ParRef,GSR_SSR_DR,GSR_Remark,GSR_UpdateUser_DR,GSR_UpdateDate,GSR_UpdateTime,GSR_SSPrint) values (:SSID,:SSRDR,:RRemark,:User,:Date,:Time,'Y'))
    q:SQLCODE'=0
    s SSDSub=0
    f  s SSDSub=$o(^DHCPESS(SSDR,"Diagnosis",SSDSub)) q:(SSDSub="")||(SQLCODE'=0)  d
    .s SSDDR=SSDR_"||"_SSDSub
    .;s HadSum=$o(^DHCPEGS(0,"SSDDR",SSDDR,0))
    .s HadSum=$D(^DHCPESS(SSDDR,"HadSum"))
    .q:(HadSum'="0")&&(Type'="1")
    .s DRemark=$p(^DHCPESS(SSDR,"Diagnosis",SSDSub),"^",2)
    .s EDId=$p(^DHCPESS(SSDR,"Diagnosis",SSDSub),"^",1)
    .q:(("^"_NoIncludeDiagnosis_"^")[("^"_EDId_"^"))
    .s Advice=$p(^DHCPESS(SSDR,"Diagnosis",SSDSub),"^",7)
    .s Sort=$o(^DHCPEGS(0,"GSDSort",SSID,""),-1)
    .i Sort="" s Sort=0
    .s Sort=Sort+1
    .
    .// 增加乙肝标志 add
    .s YGFlag=$p($g(^DHCPEED(EDId,1)),"^",12)
    .;s YGFlag=$g(^DHCPECTDataEx("BaseData","DHCPEExpertDiagnosis","YGCheck",EDId))
    .s:YGFlag'="Y" YGFlag="N"
    .// 增加乙肝标志 end
    .
    .Set SSDRowId=SSDR_"||"_SSDSub   //Add 20080728
    .Set DisplayDesc=$g(^DHCPEDataEx("DHCPESSDiagnosis","DisplayDesc",SSDRowId))  //Add 20080728
    .&SQL(insert into sqluser.DHC_PE_GSDiagnosis (GSD_ParRef,GSD_SSD_DR,GSD_DiagnoseConclusion,GSD_UpdateUser_DR,GSD_UpdateDate,GSD_UpdateTime,GSD_ED_DR,GSD_ReportPrint,GSD_GenType,GSD_Sort,GSD_Status,GSD_ST_DR,GSD_YGFlag) values (:SSID,:SSDDR,:DRemark,:User,:Date,:Time,:EDId,'Y','L',:Sort,'0',:StationDR,:YGFlag))  //GSD_Advice,  :Advice,
    .//&SQL(insert into sqluser.DHC_PE_GSDiagnosis (GSD_ParRef,GSD_SSD_DR,GSD_DiagnoseConclusion,GSD_UpdateUser_DR,GSD_UpdateDate,GSD_UpdateTime,GSD_ED_DR,GSD_ReportPrint,GSD_GenType,GSD_Sort,GSD_Status,GSD_YGFlag) values (:SSID,:SSDDR,:DRemark,:User,:Date,:Time,:EDId,'Y','L',:Sort,'0',:YGFlag))  //GSD_Advice,  :Advice,
    .Set GSDRowId=%ROWID   //Add 20080728
    .;i DisplayDesc'[("[") s DisplayDesc="["_DisplayDesc_"]"
    .;i $g(^DHCPESetting("DHCPE","ShowEDDiagnosisSign"))="Y" d
    .i $g(^DHCPESetting("DHCPE","ShowEDDiagnosisSign",LocID))="Y" d
    ..i DisplayDesc'[("[") s DisplayDesc="["_DisplayDesc_"]"
    .Set ^DHCPEDataEx("DHCPEGSDiagnosis","DisplayDesc",GSDRowId)=DisplayDesc  //Add 20080728
    .if $g(DisplayDesc)="" s DisplayDesc="空"
    .Set ^DHCPEDataEx("DHCPEGSDiagnosis","DisplayDesc",DisplayDesc,GSDRowId)=$h   //Add 20080728
    .s ^DHCPESS(SSDDR,"HadSum")=$H
    .If 'SQLCODE Do
    ..Set GSDRowId=%ROWID
    ..s OEItemID=$G(^DHCPEDataEx("SDiaginosis",SSDDR))
    ..i OEItemID'="" d
    ...s ^DHCPEDataEx("GDiaginosis",GSDRowId)=OEItemID
    ..s $p(^DHCPEGS(+GSDRowId,"Diagnosis",$p(GSDRowId,"||",2)),"^",9)=Advice
    ..d ..InsertGSDM(GSDRowId,"I")
    ..//总检时,诊断级别默认先取科室诊断上级别 20110901
    ..s SSEDCRowId=$g(^DHCPEDataEx("DHCPESSDiagnosis","EDCDR",SSDDR))
    ..Set EDCDR=##class(web.DHCPE.ResultEdit).GetEDCDR(EDId)
    ..i SSEDCRowId'=""  s EDCDR=SSEDCRowId
    ..If EDCDR'="" Do 
    ...Set ^DHCPEDataEx("DHCPEGSDiagnosis","EDCDR",GSDRowId)=EDCDR
    ...Set ^DHCPEDataEx("DHCPEGSDiagnosis","EDCDR",0,"EDCDR",SSID,EDCDR,GSDRowId)=""
    q
}

ClassMethod UpdateStationSRemark(Strings)
{
    s j=$l(Strings,"^")
    s SSID=+Strings
    s Status=$p($g(^DHCPEGS(SSID,1)),"^",5)
    q:Status'="" "HadAudit"
    s SQLCODE=0
    TSTART
    f i=1:1:j
    {
        s String=$p(Strings,"^",i)
        s ID=$p(String,"&&",1)
        s Remark=$p(String,"&&",2)
        s Report=$p(String,"&&",3)
        &SQL(update sqluser.DHC_PE_GSResult set GSR_Remark=:Remark,GSR_SSPrint=:Report where GSR_RowId=:ID)
        q:SQLCODE
    }
    i SQLCODE
    {
        TROLLBACK
        q SQLCODE
    }
    TCOMMIT
    q SQLCODE
}

Query GetSSDiagnosis(EpisodeID As %String = "") As %Query(ROWSPEC = "SSRId:%String, RLID:%String, User:%String, ItemDesc:%String, Date:%String, Remark:%String,RIDDesc:%String,TStation:%String,TSort:%String,TEDCDR:%String,TEDCDesc:%String,TItemColName:%String,DisplayDesc:%String,ReCheckUser:%String,ReCheckDate:%String,AuditDoc:%String")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.ResultDiagnosis","GetSSResult","718213")
Query GetSSResult(EpisodeID As %String = "", Include As %String = "") As %Query(ROWSPEC = "SSRId:%String, RLID:%String, User:%String, ItemDesc:%String, Date:%String, Remark:%String,RIDDesc:%String,TReport:%String,TemplateDesc:%String,TNormalResult:%String,TStationDesc:%String,NormalFlag:%String,TARCIMDesc:%String,THighRiskFlag:%String,THighRiskRemind:%String")
{
}

/// 显示诊断修改明细ReCheckUser:%String,ReCheckDate:%String,AuditDoc:%String
Query SearchDiagnosisLog(SSID As %String = "", IDs As %String = "") As %Query(ROWSPEC = "TEDRowId:%String, TMRType:%String, TMRUser:%String, TMRDate:%String")
{
}

ClassMethod SearchDiagnosisLogExecute(ByRef qHandle As %Binary, SSID As %String = "", IDs As %String = "") As %Status
{

    Set repid=$I(^CacheTemp)
    s ind=1
    q:SSID=""
    i IDs="" s IDs=SSID
    s j=$l(IDs,"^")
    f i=1:1:j
    {
        s ID=$p(IDs,"^",i)
        s SSID=+ID
        s SSUB=$p(ID,"||",2)
        s sub=0
        f  s sub=$o(^DHCPEGSDM(0,"GS",SSID,"GSDSub",sub)) q:sub=""  d
        .s mrrowid=0
        . f  s mrrowid=$o(^DHCPEGSDM(0,"GS",SSID,"GSDSub",sub,mrrowid)) q:(mrrowid="")||((SSUB'="")&&(SSUB'=sub))  d
        ..s edrowid=$p(^DHCPEGSDM(mrrowid),"^",1)
        ..i edrowid'="" s edrowid=$p(^DHCPEED(edrowid,1),"^",1)
        ..s mrtype=$p(^DHCPEGSDM(mrrowid),"^",4)
        ..i mrtype="I" s mrtype="新建"
        ..i mrtype="U" s mrtype="更改"
        ..i mrtype="D" s mrtype="删除"
        ..s mruser=$p(^DHCPEGSDM(mrrowid),"^",5)
        ..i mruser'="" s mruser=$p(^SSU("SSUSR",mruser),"^",2)
        ..s mrdate=$p(^DHCPEGSDM(mrrowid),"^",6)
        ..i mrdate'="" s mrdate=$zd(mrdate,3)
        ..s Data=$lb(edrowid,mrtype,mruser,mrdate)
        ..d GReportOutPut
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
GReportOutPut
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

ClassMethod SearchDiagnosisLogFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchDiagnosisLogExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
        Set AtEnd=1
        Set Row=""
    }
    Else      {         
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod SearchDiagnosisLogClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchDiagnosisLogExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query GetPEResult(EpisodeID As %String = "") As %Query(ROWSPEC = "TStation:%String,TARCIMDesc:%String,TOrderDetail:%String,TResult:%String,TNormalFlag:%String")
{
}

// d ##class(%ResultSet).RunQuery("web.DHCPE.BarPrintFind","QueryOrders")

ClassMethod GetPEResultExecute(ByRef qHandle As %Binary, EpisodeID As %String = "") As %Status
{
    
    Set repid=$I(^CacheTemp)
    s ind=1

    i ""=EpisodeID {    
        Set qHandle=$lb(0,repid,0)
        Quit $$$OK
    }
    s ARCIMDesc="",STDesc="",ODDesc="",RLTODDR=""
    s LocID=$P($G(^PAADM(EpisodeID)),"^",4)
    s RLTRowId=0
    f  s RLTRowId=$o(^DHCPERLT(0,"ADM",EpisodeID,RLTRowId))  q:RLTRowId=""  d 
    .s RLTARCIMDR=$p(^DHCPERLT(RLTRowId),"^",2)
    .s ARCIMSubscript=$P(RLTARCIMDR,"||",1)
    .s ARCIMVersion=$P(RLTARCIMDR,"||",2)
    .s ARCIMDesc=$P($G(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)
    .s STRowId="0"
    .s STRowId=$O(^DHCPEST(0,"STORD_ARCIM",RLTARCIMDR,STRowId))
    .s STDesc=$p(^DHCPEST(STRowId),"^",2)
    .s RLTODDR=$p($g(^DHCPERLT(RLTRowId)),"^",3)
    .q:RLTODDR=""
    .s ODDesc=$p($g(^DHCPEST($p(RLTODDR,"||",1),"OD",$p(RLTODDR,"||",2))),"^",1)
    .;i (("^"_^DHCPESetting("DHCPE","StationId_Ris")_"^")[("^"_STRowId_"^")) S ODDesc=""  
    .i (("^"_^DHCPESetting("DHCPE","StationId_Ris",LocID)_"^")[("^"_STRowId_"^"))    S ODDesc=""
    .s RLTResult=$p(^DHCPERLT(RLTRowId),"^",4)
    .s RLTNormalFlag=$p(^DHCPERLT(RLTRowId),"^",7)
    .s TemplateDesc=$p(^DHCPERLT(RLTRowId),"^",10)
    .i TemplateDesc'="" s RLTResult=RLTResult_"("_TemplateDesc_")"
    .d Find
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
Find
    set Data=$lb(STDesc,ARCIMDesc,ODDesc,RLTResult,RLTNormalFlag)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

ClassMethod GetPEResultFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPEResultExecute ]
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

ClassMethod GetPEResultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPEResultExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query GetILLExplainList(PAADM As %String = "") As %Query(ROWSPEC = "Print:%String,GSRowId:%String,ILLID:%String,ILLDesc:%String,ILLExplain:%String,ILLSportGuide:%String,ILLDietGuide:%String")
{
}

// d ##class(%ResultSet).RunQuery("web.DHCPE.ResultDiagnosis","GetILLExplainList","531")

ClassMethod GetILLExplainListExecute(ByRef qHandle As %Binary, PAADM As %String = "") As %Status
{
    
    Set repid=$I(^CacheTemp)
    s ind=1
    s GSRowId=..GetSSId(PAADM)
    i (""=PAADM)||(GSRowId="") {    
        Set qHandle=$lb(0,repid,0)
        Quit $$$OK
    }
   
    s ChildSub=0
    f  s ChildSub=$o(^DHCPEGS(GSRowId,"Diagnosis", ChildSub))  q:ChildSub=""  d
    .s EDDR=$P(^DHCPEGS(GSRowId,"Diagnosis", ChildSub),"^",1)
    .q:EDDR=""
    .s IDRRowId=0
    .f  s IDRRowId=$o(^DHCPEIDR(0,"EDDR",EDDR,IDRRowId)) q:IDRRowId=""  d
    ..s IllRowID=$P(^DHCPEIDR(IDRRowId),"^",2 )
    ..q:IllRowID=""
    ..s IllDesc=$p(^DHCPEILLS(IllRowID),"^",2)
    ..S PrintFlag="Y" 
    ..s Explain=$p($g(^DHCPECTDataEx("BaseData","IllnessStandard","IllExplain",IllRowID)),"@@",1)
    ..s SportGuide=$p($G(^DHCPECTDataEx("BaseData","IllnessStandard","SportGuide",IllRowID)),"@@",1)
    ..s DietGuide=$p($G(^DHCPECTDataEx("BaseData","IllnessStandard","DietGuide",IllRowID)),"@@",1)
    ..q:(Explain="")&&(SportGuide="")&&(DietGuide="")
    ..i $D(^DHCPEDataEx("BaseData","IllnessStandard","GeneralDiagnosis",PAADM,IllRowID))  d  //如果界面修改后则保存到此global
    ...s Explain=$p(^DHCPEDataEx("BaseData","IllnessStandard","GeneralDiagnosis",PAADM,IllRowID),"##",1)
    ...s SportGuide=$p(^DHCPEDataEx("BaseData","IllnessStandard","GeneralDiagnosis",PAADM,IllRowID),"##",2)
    ...s DietGuide=$p(^DHCPEDataEx("BaseData","IllnessStandard","GeneralDiagnosis",PAADM,IllRowID),"##",3)
    ...s PrintFlag=$p(^DHCPEDataEx("BaseData","IllnessStandard","GeneralDiagnosis",PAADM,IllRowID),"##",4)
    ..ELSE   d
    ...s ^DHCPEDataEx("BaseData","IllnessStandard","GeneralDiagnosis",PAADM,IllRowID)=Explain_"##"_SportGuide_"##"_DietGuide_"##"_PrintFlag
    
    ..d Find
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
Find
    
    set Data=$lb(PrintFlag ,GSRowId,IllRowID,IllDesc,Explain,SportGuide,DietGuide)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

ClassMethod GetILLExplainListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetILLExplainListExecute ]
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

ClassMethod GetILLExplainListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetILLExplainListExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod UpdateILLExplain(Strings)
{
   
    s j=$l(Strings,"^^")
    f i=1:1:j
    {   
        s String=$p(Strings,"^^",i)
    
        s PAADM=$p(String,"&&",1)
        s IllRowID=$p(String,"&&",2)
        s IllExplain=$p(String,"&&",3)
        s IllSportGuide=$p(String,"&&",4)
        s IllDietGuide=$p(String,"&&",5)
        s IllPrint=$p(String,"&&",6)
        
        s ^DHCPEDataEx("BaseData","IllnessStandard","GeneralDiagnosis",PAADM,IllRowID)=IllExplain_"##"_IllSportGuide_"##"_IllDietGuide_"##"_IllPrint
    }
}

ClassMethod GetDocNameByPAADM(PAADM)
{
    s GSRowId=..GetSSId(PAADM)
    q:GSRowId="" ""
    s UserID=$P(^DHCPEGS(GSRowId,1),"^",5)
    s:UserID'="" UserID=$P(^SSU("SSUSR",UserID),"^",2)
    s MainDoc=$P($G(^DHCPEDataEx("DHCPEGeneralSummarize","MainDoctor",PAADM)),"^",1)
    s:MainDoc'="" MainDoc=$P(^SSU("SSUSR",MainDoc),"^",2)
    q UserID_"^"_MainDoc
}

ClassMethod GetSSDiagnosisName(SSRID)
{
    q:SSRID="" ""
    s Sub=$P(SSRID,"||",2)
    s SSID=+SSRID
    s RLID=$p(^DHCPEGS(SSID,"Diagnosis",Sub),"^",1)
    q:RLID="" ""
    s RIDDesc=$p(^DHCPEGS(SSID,"Diagnosis",Sub),"^",9)
    s ItemDesc=$p($g(^DHCPEED(RLID,"1")),"^",1)
    s DisplayDesc=$g(^DHCPEDataEx("DHCPEGSDiagnosis","DisplayDesc",SSRID))  //Add 20080728
    q:DisplayDesc'="" DisplayDesc
    q ItemDesc
}

ClassMethod GetSSDiagnosisAdvice(SSRID)
{
    ;web.DHCPE.ResultDiagnosis.GetSSDiagnosisAdvice
    q:SSRID="" ""
    s Sub=$P(SSRID,"||",2)
    s SSID=+SSRID
    q:'$D(^DHCPEGS(SSID,"Diagnosis",Sub)) ""
    s RIDDesc=$p(^DHCPEGS(SSID,"Diagnosis",Sub),"^",9)
    s DisplayDesc=$g(^DHCPEDataEx("DHCPEGSDiagnosis","DisplayDesc",SSRID))
    i DisplayDesc="" d
    .s EDID=$p(^DHCPEGS(SSID,"Diagnosis",Sub),"^",1)
    .s DisplayDesc=$p($g(^DHCPEED(EDID,"1")),"^",1)
    //s RIDDesc=$ZCVT(RIDDesc,"O","UTF8")
    q RIDDesc_"^"_DisplayDesc
}

ClassMethod CreateResultElement(Result, Template, Flag)
{
    ;s:Template'="" Result=Result_"("_Template_")"
    i Flag=2 d
    .s Result=Result_" <font size=4px color=red>↑</font>"
    i Flag=0 d
    .s Result=Result_" <font size=4px color=red>↓</font>"
    Write "<label Style='WIDTH: 106px; HEIGHT: 24px'>"_Result_"</label>"
    quit
}

/// web.DHCPE.ResultDiagnosis
ClassMethod UpdateYGDiagnosisFlag(GSDRowId, Type)
{
    q:((GSDRowId="")||(Type="")) ""
    s imgUrl=""
    i Type="YGFlag" {
        s $p(^DHCPEGS(+GSDRowId,"Diagnosis",$p(GSDRowId,"||",2)),"^",12)="N"
        s imgUrl="../scripts_lib/hisui-0.1.0/dist/css/icons/stethoscope.png"
    } else {
        s $p(^DHCPEGS(+GSDRowId,"Diagnosis",$p(GSDRowId,"||",2)),"^",12)="Y"
        s imgUrl="../scripts_lib/hisui-0.1.0/dist/css/icons/virus.png"
    }
    d ..InsertGSDM(GSDRowId,"U")
    q imgUrl
}

/// Type:  PAADM 就诊号   GSID 总检ID   OEOrdItem 医嘱ID
/// 0 无乙肝项目  1 乙肝项目全部未检  2 乙肝项目全部弃检  3 乙肝项目部分已检  4 未检或弃检
/// w ##class(web.DHCPE.ResultDiagnosis).GetYGItemFlag(1014,"PAADM")
ClassMethod GetYGItemFlag(Id, Type)
{
    q:((Id="")||(Type="")) "0"
    
    if Type="PAADM" {
        s PAADM=Id
    } elseif Type="GSID" {
        s PAADM=$p($g(^DHCPEGS(Id,1)),"^",8)
    } elseif Type="OEOrdItem" {
        s PAADM=$p($g(^OEORD(+Id)),"^",1)
        s LocID=$P($g(^PAADM(PAADM)),"^",4)
        s IADM=$o(^DHCPEIADM(0,"PAADM",PAADM,0))
        q:IADM="" "0"
        s sub=$p(Id,"||",2)
        s ItemSta=$p($g(^OEORD(+Id,"I",sub,1)),"^",13)
        q:ItemSta="4" "0"
        s ARCIMRowId=$p($g(^OEORD(+Id,"I",sub,1)),"^",2)
        q:ARCIMRowId="" "0"
        /*
        s STID=$o(^DHCPEST(0,"STORD_ARCIM",ARCIMRowId,0))
        q:STID="" "0"
        s Sub=$o(^DHCPEST(0,"STORD_ARCIM",ARCIMRowId,STID,0))
        q:Sub="" "0"
        */
        s StatOrderID=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ARCIMRowId,LocID)
        s STID=$p(StatOrderID,"||",1)
        q:STID="" "0"
        s ordSetId=$o(^CF.PE.StationOrderSetI("IdxOfLocOrder"," "_LocID,StatOrderID,0))
        q:ordSetId="" "0"
        q:$lg($g(^CF.PE.StationOrderSetD(ordSetId)),19)'="Y" "0"
        //q:$g(^DHCPECTDataEx("YGFlag",ARCIMRowId))'="Y" "0"
        
        q:$d(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",Id)) "2"
        s ResultId=$o(^DHCPERLT(0,"OEORI",Id,0))
        q:ResultId>0 "3"
        q "1"
    } 
    s LocID=$P($g(^PAADM(PAADM)),"^",4)
    s IADM=$o(^DHCPEIADM(0,"PAADM",PAADM,0))
    q:IADM="" "0"
    s OEOrder=$o(^OEORD(0,"Adm",PAADM,0))
    q:OEOrder="" "0"
    s flag="0"
    s OEORDSub=0
    f  s OEORDSub=$o(^OEORD(OEOrder,"I",OEORDSub)) q:((OEORDSub="")||(flag="3"))  d
    .
    .s Sta=$p($g(^OEORD(OEOrder,"I",OEORDSub,1)),"^",13)
    .q:Sta="4"
    .s ARCIM=$p($g(^OEORD(OEOrder,"I",OEORDSub,1)),"^",2)
    .q:ARCIM=""
    .;s STID=$o(^DHCPEST(0,"STORD_ARCIM",ARCIM,0))
    .;q:STID=""
    .;s Sub=$o(^DHCPEST(0,"STORD_ARCIM",ARCIM,STID,0))
    .;q:Sub=""
    .s StatOrderID=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ARCIM,LocID)
    .s STID=$p(StatOrderID,"||",1)
    .q:STID=""
    .s ordSetId=$o(^CF.PE.StationOrderSetI("IdxOfLocOrder"," "_LocID,StatOrderID,0))
    .q:ordSetId=""
    .q:$lg($g(^CF.PE.StationOrderSetD(ordSetId)),19)'="Y"
    .//q:$g(^DHCPECTDataEx("YGFlag",ARCIM))'="Y"
    .
    .s temp=..GetYGItemFlag(OEOrder_"||"_OEORDSub,"OEOrdItem")
    .q:temp="0"
    .i temp="1" d
    ..i ((flag="2")||(flag="4")) s flag="4"
    ..e  s flag="1"
    .e  i temp="2" d
    ..i ((flag="1")||(flag="4")) s flag="4"
    ..e  s flag="2"
    .e  i temp="3" d
    ..s flag="3"
    
    q flag
}

/// Creator： xy
/// CreatDate： 2020-07-27
/// Description: 根据总检GSID得到就诊ID
/// Input: 总检GSID
/// Return： 就诊ID
/// dubug: w ##class(web.DHCPE.ResultDiagnosis).GetPAADMBySSId()
ClassMethod GetPAADMBySSId(GSID)
{
    q:GSID="" ""
    s PAADM=$p($g(^DHCPEGS(GSID,1)),"^",8)
    q PAADM
}

}
