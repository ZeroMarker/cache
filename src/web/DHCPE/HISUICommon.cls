Class web.DHCPE.HISUICommon Extends %RegisteredObject
{

/// 通过医嘱获取检查号
/// w ##class(web.DHCPE.HISUICommon).GetStudyNoByOEORI("")
ClassMethod GetStudyNoByOEORI(OEORI)
{
    s CheckNo=""
    s SpecNo=$p($G(^OEORD(+OEORI,"I",$p(OEORI,"||",2),3)),"^",20)
    q:SpecNo'="" "" //检验的过滤
    i SpecNo="" s CheckNo=##class(web.DHCAPPSeePatPacs).GetStudyNoByORORIAndPart(OEORI,"")
    i CheckNo="" d
    .s RARRowId=$o(^DHCPACRegInfoi("OEORI",OEORI,0))
    .i RARRowId'="" s CheckNo=$p(^DHCPACRegInfo(RARRowId),"^",2)
    
    q CheckNo
}

/// Description:：根据体检号获取预约ID
/// Debug: d ##class(web.DHCPE.HISUICommon).GetPreIDByHPNo()
ClassMethod GetPreIDByHPNo(HPNo As %String = "")
{
    q:HPNo="" ""
    s PID=""
    s PID=$O(^DHCPEPreIADM(0,"HPNo",HPNo,PID))
    q PID
}

/// Description:：根据登记号获取姓名
/// Debug: d ##class(web.DHCPE.HISUICommon).GetNameByRegNo()
ClassMethod GetNameByRegNo(RegNo As %String = "")
{
    q:RegNo="" ""
    s PIBI=$O(^DHCPEPreIBI(0,"PAPMINo",RegNo,""))
    s Name=$p($g(^DHCPEPreIBI(PIBI)),"^",2)
    q Name
}

ClassMethod GetClientName()
{
    s ClientName=""
    if $d(%session),$d(%session.Data("LOGON.SSUSERLOGINID"))
    {
        s LoginID=%session.Data("LOGON.SSUSERLOGINID")
        s ClientIP=$p(^SST("LOG",LoginID,"ADDR"),"^",1)
        s ClientName=$p(^SST("LOG",LoginID,"ADDR"),"^",4)
    }
    q ClientName
}

ClassMethod GetDefaultPAADM()
{
    
    q $G(^DHCPESetting("DHCPE","DefaultPAADM",%session.Get("LOGON.CTLOCID")))
}

/// function:查询前台配置
/// d ##class(%ResultSet).RunQuery("web.DHCPE.HISUICommon","FindPreSetting")
Query FindPreSetting() As websys.Query(ROWSPEC = "Loc,LocDesc,FeeTypeSuperGroup,AutoArrived,DefPrintType,AllowPrint,IsAddItem,IsPGetReportPT,IsPrintEItem,CardRelate,PreSurvey")
{
}

ClassMethod FindPreSettingExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 

    s id=0
    s LocList=$g(^DHCPESetting("DHCPE","PELoc"))
    s Length=$l(LocList,"^")
    
    f i=1:1:Length d
    .s Loc=$p(LocList,"^",i)
    .q:Loc=""
    .s LocDesc="" 
    .s LocDesc=$p($g(^CTLOC(Loc)),"^",2)
    .s FeeTypeSuperGroup=$g(^DHCPESetting("DHCPE","FeeTypeSuperGroup",Loc))
    .s AutoArrived=$g(^DHCPESetting("DHCPE","AutoArrived",Loc))
    .s DefPrintType=$g(^DHCPESetting("DHCPE","DefPrintType",Loc))
    .s AllowPrint=$g(^DHCPESetting("DHCPE","AllowPrint",Loc))
    .s AllowPrint=$tr(AllowPrint,"Y","是")
    .s AllowPrint=$tr(AllowPrint,"N","否")
    .s IsPrintEItem=$g(^DHCPESetting("DHCPE","IsAddItem",Loc))
    .s IsPrintEItem=$tr(IsPrintEItem,"Y","是")
    .s IsPrintEItem=$tr(IsPrintEItem,"N","否")
    .s IsPGetReportPT=$g(^DHCPESetting("DHCPE","IsPGetReportPT",Loc))
    .s IsPGetReportPT=$tr(IsPGetReportPT,"Y","是")
    .s IsPGetReportPT=$tr(IsPGetReportPT,"N","否")
    .s IsAddItem=$g(^DHCPESetting("DHCPE","IsAddItem",Loc))
    .s IsAddItem=$tr(IsAddItem,"Y","是")
    .s IsAddItem=$tr(IsAddItem,"N","否")
    .s CardRelate=$g(^DHCPESetting("DHCPE","CardRelate",Loc))
    .i CardRelate="Yes"  s CardRelate="是"
    .i CardRelate="No"  s CardRelate="否"
    .s PreSurvey=$g(^DHCPESetting("DHCPE","PreSurvey",Loc))
    .s PreSurvey=$tr(PreSurvey,"Y","是")
    .s PreSurvey=$tr(PreSurvey,"N","否")

    .s ^CacheTemp(repid,ind)=$lb(Loc,LocDesc,FeeTypeSuperGroup,AutoArrived,DefPrintType,AllowPrint,IsAddItem,IsPGetReportPT,IsPrintEItem,CardRelate,PreSurvey)
    .s ind=ind+1
    
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

/// function:查询基础配置
/// d ##class(%ResultSet).RunQuery("web.DHCPE.HISUICommon","FindPublicSetting")
Query FindPublicSetting() As websys.Query(ROWSPEC = "Loc,LocDesc,LabStation:%String,RisStationStr:%String,MedicalStation:%String,OtherStation,LABDATA:%String,MEDDATA:%String,PisNameSpace:%String,SuperGroup:%String,ItemAbridgeFlag:%String,LisInterface:%String,SendPisInterface:%String,IfRecommendItem:%String,SendPisFBWay:%String,InvDefaulltFee:%String,RoundingFee:%String,HPNo:%String")
{
}

ClassMethod FindPublicSettingExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 

    s id=0
    s LocList=$g(^DHCPESetting("DHCPE","PELoc"))
    s Length=$l(LocList,"^")
    
    f i=1:1:Length d
    .s Loc=$p(LocList,"^",i)
    .q:Loc=""
    .s LocDesc="" 
    .s LocDesc=$p($g(^CTLOC(Loc)),"^",2)
    .s InvDefaulltFee=$g(^DHCPESetting("DHCPE","InvDefaulltFee",Loc))
    .i InvDefaulltFee'="" s InvDefaulltFee=$p($g(^ARCIM($p(InvDefaulltFee,"||",1),$p(InvDefaulltFee,"||",2),1)),"^",3)
    .s RoundingFee=$g(^DHCPESetting("DHCPE","RoundingFee",Loc))
    .i RoundingFee'="" s RoundingFee=$p($g(^ARCIM($p(RoundingFee,"||",1),$p(RoundingFee,"||",2),1)),"^",3)
    .s HPNo=$g(^DHCPESetting("DHCPE","HPNo",Loc))
    .i HPNo'="" s HPNo=$p(HPNo,"^",2)
    .s LabStation=$g(^DHCPESetting("DHCPE","StationId_Lab",Loc))
    .i LabStation'="" s LabStation=$p($g(^DHCPEST(LabStation)),"^",2)
    .s RisStation=$g(^DHCPESetting("DHCPE","StationId_Ris",Loc))
    .s RisStationStr=""
    .i RisStation'="" d
    ..s RisLength=$l(RisStation,"^")
    ..f n=1:1:RisLength d
    ...s RisStationDesc=$p($g(^DHCPEST($p(RisStation,"^",n))),"^",2)
    ...i RisStationStr="" s RisStationStr=RisStationDesc
    ...e  s RisStationStr=RisStationStr_" "_RisStationDesc
    .s MedicalStation=$g(^DHCPESetting("DHCPE","StationId_Medical",Loc))
    .i MedicalStation'="" s MedicalStation=$p($g(^DHCPEST(MedicalStation)),"^",2)
    .s OtherStation=$g(^DHCPESetting("DHCPE","StationId_Other",Loc))
    .i OtherStation'="" s OtherStation=$p($g(^DHCPEST(OtherStation)),"^",2)
    .s LABDATA=$g(^DHCPESetting("DHCPE","LABDATA",Loc))
    .s MEDDATA=$g(^DHCPESetting("DHCPE","MEDDATA",Loc))
    .s PisNameSpace=$g(^DHCPESetting("DHCPE","PisNameSpace",Loc))
    .s SuperGroup=$g(^DHCPESetting("DHCPE","SuperGroup",Loc))
    .s ItemAbridgeFlag=$g(^DHCPESetting("DHCPE","ItemAbridgeFlag",Loc))
    .s ItemAbridgeFlag=$tr(ItemAbridgeFlag,"Y","是")
    .s ItemAbridgeFlag=$tr(ItemAbridgeFlag,"N","否")
    .s LisInterface=$g(^DHCPESetting("DHCPE","LisInterface",Loc))
    .s LisInterface=$tr(LisInterface,"Y","是")
    .s LisInterface=$tr(LisInterface,"N","否")
    .s SendPisInterface=$g(^DHCPESetting("DHCPE","SendPisInterface",Loc))
    .s SendPisInterface=$tr(SendPisInterface,"Y","是")
    .s SendPisInterface=$tr(SendPisInterface,"N","否")
    .s IfRecommendItem=$g(^DHCPESetting("DHCPE","RecommendItem",Loc))
    .s IfRecommendItem=$tr(IfRecommendItem,"Y","是")
    .s IfRecommendItem=$tr(IfRecommendItem,"N","否")
    .s SendPisFBWay=$g(^DHCPESetting("DHCPE","SendPisFBWay",Loc))
    .i SendPisFBWay="F"  s SendPisFBWay="前端"
    .i SendPisFBWay="B"  s SendPisFBWay="后台"

    .s ^CacheTemp(repid,ind)=$lb(Loc,LocDesc,LabStation,RisStationStr,MedicalStation,OtherStation,LABDATA,MEDDATA,PisNameSpace,SuperGroup,ItemAbridgeFlag,LisInterface,SendPisInterface,IfRecommendItem,SendPisFBWay,InvDefaulltFee,RoundingFee,HPNo)
    .s ind=ind+1
    
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

Query FindBaseSetting() As websys.Query(ROWSPEC = "Loc,LocDesc,AutoArrived,AutoAuditUserID,AutoAuditUser,CashierSystem,PhyExamDrId,PhyExamDr,OrderInterfaceType,DefPrintType,CallVoice,CancelPEType,AllowCharge,MainDoctorGroup,ReportCode,HPNo,NetReport,SendOrder,ItemAbridgeFlag,AllowPrint,OrderInterface:%String,NewVerReport:%String,IsAddItem:%String,IsPGetReportPT:%String,IfPrintMinusInv:%String,IfNetPre:%String,IfNetRegister:%String,IfNetCancelPE:%String,IfPreSurvey:%String,IfRecommendItem:%String,TransResult:%String,IsFeeLocFlag:%String,IsCardLocFlag:%String,CollectSpecOne:%String")
{
}

ClassMethod FindBaseSettingExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 

    s id=0
    s LocList=$g(^DHCPESetting("DHCPE","PELoc"))
    s Length=$l(LocList,"^")
    
    f i=1:1:Length d
    .s Loc=$p(LocList,"^",i)
    .q:Loc=""
    .s LocDesc=""
    .s LocDesc=$p($g(^CTLOC(Loc)),"^",2)
    .s AutoArrived=$g(^DHCPESetting("DHCPE","AutoArrived",Loc))
    .s AutoArrived=$p(AutoArrived,"^",1)_"^"_$p(AutoArrived,"^",2)_"^"_$p(AutoArrived,"^",4)
    .s AutoArrived=$tr(AutoArrived,"Y","是")
    .s AutoArrived=$tr(AutoArrived,"N","否")
    .s AutoAuditUserID=$g(^DHCPESetting("DHCPE","AutoAuditUser",Loc))
    .S AutoAuditUser=""
    .I AutoAuditUserID'="" s AutoAuditUser=$p($g(^SSU("SSUSR",AutoAuditUserID)),"^",2)
    .s CashierSystem=$g(^DHCPESetting("DHCPE","CashierSystem",Loc))
    .i CashierSystem="1" s CashierSystem="个人视同收费"
    .i CashierSystem="2" s CashierSystem="团体视同收费"
    .i CashierSystem="3" s CashierSystem="都视同收费"
    .s PhyExamDrId=$g(^DHCPESetting("DHCPE","PhyExamDrId",Loc))
    .s PhyExamDr=""
    .i PhyExamDrId'="" s PhyExamDr=$p($g(^CTPCP(PhyExamDrId,1)),"^",2)
    .s OrderInterfaceType=$g(^DHCPESetting("DHCPE","OrderInterfaceType",Loc))
    .i OrderInterfaceType="N" s OrderInterfaceType="类方法"
    .e  s OrderInterfaceType="M程序"
    .s DefPrintType=$g(^DHCPESetting("DHCPE","DefPrintType",Loc))
    .s DefPrintType=$tr(DefPrintType,"Y","是")
    .s DefPrintType=$tr(DefPrintType,"N","否")
    
    .s CallVoice=$g(^DHCPESetting("DHCPE","CallVoice",Loc))
    .s CallVoice=$tr(CallVoice,"Y","是")
    .s CallVoice=$tr(CallVoice,"N","否")
    .s CancelPEType=$g(^DHCPESetting("DHCPE","CancelPEType",Loc))
    .i CancelPEType=1 s CancelPEType="不删除"
    .e  s CancelPEType="删除"
    .s AllowCharge=$g(^DHCPESetting("DHCPE","AllowCharge",Loc))
    .i AllowCharge=1 s AllowCharge="需要"
    .e  s AllowCharge="不需要"
    .s MainDoctorGroup=$g(^DHCPESetting("DHCPE","MainDoctorGroup",Loc))
    .s MainDoctorGroup=$tr(MainDoctorGroup,"Y","是")
    .s MainDoctorGroup=$tr(MainDoctorGroup,"N","否")
    .s IsAddItem=$g(^DHCPESetting("DHCPE","IsAddItem",Loc))
    .s IsAddItem=$tr(IsAddItem,"Y","是")
    .s IsAddItem=$tr(IsAddItem,"N","否")
    .s ReportCode=$g(^DHCPESetting("DHCPE","ReportCode",Loc))
    .s HPNo=$g(^DHCPESetting("DHCPE","HPNo",Loc))
    .i HPNo'="" s HPNo=$p(HPNo,"^",2)
    .s NetReport=$g(^DHCPESetting("DHCPE","NetReport",Loc)) 
    .s NetReport=$tr(NetReport,"Y","是")
    .s NetReport=$tr(NetReport,"N","否") 
    .s SendOrder=$g(^DHCPESetting("DHCPE","SendOrder",Loc))
    .s SendOrder=$tr(SendOrder,"Y","是")
    .s SendOrder=$tr(SendOrder,"N","否") 
    .s ItemAbridgeFlag=$g(^DHCPESetting("DHCPE","ItemAbridgeFlag",Loc))
    .s AllowPrint=$g(^DHCPESetting("DHCPE","AllowPrint",Loc))
    .s AllowPrint=$tr(AllowPrint,"Y","是")
    .s AllowPrint=$tr(AllowPrint,"N","否")
    .s OrderInterface=$g(^DHCPESetting("DHCPE","OrderInterface",Loc))
    .s OrderInterface=$tr(OrderInterface,"Y","是")
    .s OrderInterface=$tr(OrderInterface,"N","否")
    .s NewVerReport=$g(^DHCPESetting("DHCPE","NewVerReport",Loc))
    .;s NewVerReport=$tr(NewVerReport,"Y","是")
    .;s NewVerReport=$tr(NewVerReport,"N","否")
    .s IsPGetReportPT=$g(^DHCPESetting("DHCPE","IsPGetReportPT",Loc))
    .s IsPGetReportPT=$tr(IsPGetReportPT,"Y","是")
    .s IsPGetReportPT=$tr(IsPGetReportPT,"N","否")
    .s IfPrintMinusInv=$g(^DHCPESetting("DHCPE","IfPrintMinusInv",Loc))
    .s IfPrintMinusInv=$tr(IfPrintMinusInv,"Y","是")
    .s IfPrintMinusInv=$tr(IfPrintMinusInv,"N","否")
    
    
    .s IfNetPre=$g(^DHCPESetting("DHCPE","NetPreLoc",Loc))
    .s IfNetPre=$tr(IfNetPre,"Y","是")
    .s IfNetPre=$tr(IfNetPre,"N","否")
    .s IfNetRegister=$g(^DHCPESetting("DHCPE","AutoNetRegister",Loc))
    .s IfNetRegister=$tr(IfNetRegister,"Y","是")
    .s IfNetRegister=$tr(IfNetRegister,"N","否")
    .s IfNetCancelPE=$g(^DHCPESetting("DHCPE","NetCancelPE",Loc))
    .s IfNetCancelPE=$tr(IfNetCancelPE,"Y","是")
    .s IfNetCancelPE=$tr(IfNetCancelPE,"N","否")
    .s IfPreSurvey=$g(^DHCPESetting("DHCPE","PreSurvey",Loc))
    .s IfPreSurvey=$tr(IfPreSurvey,"Y","是")
    .s IfPreSurvey=$tr(IfPreSurvey,"N","否")
    .s IfRecommendItem=$g(^DHCPESetting("DHCPE","RecommendItem",Loc))
    .s IfRecommendItem=$tr(IfRecommendItem,"Y","是")
    .s IfRecommendItem=$tr(IfRecommendItem,"N","否")
    .s TransResult=$g(^DHCPESetting("DHCPE","TransResult",Loc))
    .i TransResult="PT" s TransResult="调用平台"
    .i TransResult="PG" s TransResult="调用各产品组"
    .s IsFeeLocFlag=$g(^DHCPESetting("DHCPE","IsFeeLocFlag",Loc))
    .s IsFeeLocFlag=$tr(IsFeeLocFlag,"Y","是")
    .s IsFeeLocFlag=$tr(IsFeeLocFlag,"N","否")
    .s IsCardLocFlag=$g(^DHCPESetting("DHCPE","IsCardLocFlag",Loc))
    .s IsCardLocFlag=$tr(IsCardLocFlag,"Y","是")
    .s IsCardLocFlag=$tr(IsCardLocFlag,"N","否")

    .s CollectSpecOne=$g(^DHCPESetting("DHCPE","CollectSpecOne",Loc))
    .s CollectSpecOne=$tr(CollectSpecOne,"Y","是")
    .s CollectSpecOne=$tr(CollectSpecOne,"N","否")
    
    .s ^CacheTemp(repid,ind)=$lb(Loc,LocDesc,AutoArrived,AutoAuditUserID,AutoAuditUser,CashierSystem,PhyExamDrId,PhyExamDr,OrderInterfaceType,DefPrintType,CallVoice,CancelPEType,AllowCharge,MainDoctorGroup,ReportCode,HPNo,NetReport,SendOrder,ItemAbridgeFlag,AllowPrint,OrderInterface,NewVerReport,IsAddItem,IsPGetReportPT,IfPrintMinusInv,IfNetPre,IfNetRegister,IfNetCancelPE,IfPreSurvey,IfRecommendItem,TransResult,IsFeeLocFlag,IsCardLocFlag,CollectSpecOne)
    .s ind=ind+1
    
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

ClassMethod GetGADMByIADM(IADM)
{
    q:IADM="" ""
    
    q $p($G(^DHCPEPreIADM(+IADM)),"^",2)
}

/*
ClassMethod GetDefaultVIP(UserID)
{
    s VIPLevel=$g(^DHCPEDataEx("DefaultVIPLevel",UserID))
    i VIPLevel'="" s VIPLevel=$p($g(^DHCPEVIPLevel("VIP",VIPLevel)),"^",2)
    q VIPLevel
}
*/
/// Creator：      xy
/// CreatDate：    20210823
/// Description:  获取前台人员默认的VIP等级
/// debug: w ##class(web.DHCPE.HISUICommon).GetDefaultVIP()
ClassMethod GetDefaultVIP(UserID)
{
    s VIPLevel=$g(^DHCPEDataEx("DefaultVIPLevel",UserID))
    i VIPLevel'="" s VIPLevel=$lg($g(^CT.PE.VIPLevelD(VIPLevel)),3) //VIP描述
    s VIPLevel=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEVIPLevel",VIPLevel,"VLDesc","cls")
    q VIPLevel
}

/// debug:w ##class(web.DHCPE.HISUICommon).GetVIP()
ClassMethod GetVIP(UserID, LocID)
{
    s val=$G(^DHCPEDataEx("DefaultVIPLevel",UserID)) 
    //s:val="" val=$G(^DHCPEVIPLevel("VIPapprove"))
    s:val="" val=##class(web.DHCPE.CT.VIPLevel).GetDefaultVIP(LocID)
    q val
}

/// debug: w ##class(web.DHCPE.HISUICommon).GetSettingByLoc(105,"DefPrintType")
ClassMethod GetSettingByLoc(locid, parameter)
{
    //i (parameter="LABDATA")||(parameter="MEDDATA") q $g(^DHCPESetting("NAMESPACE",parameter))
    i (parameter="LABDATA")||(parameter="MEDDATA") q $g(^DHCPESetting("NAMESPACE",parameter,locid))
    //i (parameter="SendRisApplication") q $g(^DHCPESetting("DHCPE","StationId_Ris",parameter))
    i (parameter="SendRisApplication") q $g(^DHCPESetting("DHCPE","StationId_Ris",locid,parameter))
    s ret=""
    i (parameter="PhyExamDrId") d
    .s id=$g(^DHCPESetting("DHCPE",parameter,locid))
    .s code=""
    .i id'="" s code=$p($g(^CTPCP(id,1)),"^",1)
    .s ret=id_"^"_code
    i ret'="" q ret
    i $d(^DHCPESetting("DHCPE",parameter,locid)) q $g(^DHCPESetting("DHCPE",parameter,locid))
    q $g(^DHCPESetting("DHCPE",parameter))
}

ClassMethod SetSettingByLoc(locid, parameter, value)
{
    /*
    i ("^"_$g(^DHCPESetting("DHCPE","PELoc")))'[("^"_locid_"^") s ^DHCPESetting("DHCPE","PELoc")=locid_"^"_$g(^DHCPESetting("DHCPE","PELoc"))
    i parameter="HPNo" s value="^"_value
    s ^DHCPESetting("DHCPE",parameter,locid)=value
    */
    /*
    s ^DHCPESetting("DHCPE","DefADMFeeType",locid)=""
    s ^DHCPESetting("DHCPE","DefaultPAADM",locid)=""
    s ^DHCPESetting("DHCPE","OEItemPrint",locid)="OEItemPrintA4"
    s ^DHCPESetting("DHCPE","PageModel",locid)="A4" 
    s ^DHCPESetting("DHCPE","SetsDefaultTar",locid)=""
    s ^DHCPESetting("DHCPE","PreOrder",locid)="0"
    */
    i ("^"_$g(^DHCPESetting("DHCPE","PELoc")))'[("^"_locid_"^") s ^DHCPESetting("DHCPE","PELoc")=locid_"^"_$g(^DHCPESetting("DHCPE","PELoc"))
    i parameter="HPNo" s value="^"_value
    i (parameter="LABDATA")||(parameter="MEDDATA") d
    .s ^DHCPESetting("NAMESPACE",parameter,locid)=value 
    e  d
    .s ^DHCPESetting("DHCPE",parameter,locid)=value

    d ##class(web.DHCPE.Init).SetSettingNewByLocID(locid)
    q 0
}

ClassMethod SetSettingAllLoc(parameter, value)
{
    s ^DHCPESetting("DHCPE",parameter)=value
    /*
    s ^DHCPESetting("DHCPE","BilledMode")="New" 
    s ^DHCPESetting("DHCPE","BookDateLimit")="No"
    s ^DHCPESetting("DHCPE","CanChangePayModes")="1,2"
    s ^DHCPESetting("DHCPE","CashierMin")="100"
    s ^DHCPESetting("DHCPE","ClassName of CRMGateWay")="web.DHCPE.CRM.GatewayDHC"
    s ^DHCPESetting("DHCPE","GetHWOrder")=""
    s ^DHCPESetting("DHCPE","DefPatientType")="1^^2^1^20"
    s ^DHCPESetting("DHCPE","GroupPatNO_Begin")="00000000" 
    s ^DHCPESetting("DHCPE","GroupPatNO_CurNo")="" 
    s ^DHCPESetting("DHCPE","HospYBCode")="" 
    s ^DHCPESetting("DHCPE","HospitalCode")=""
    s ^DHCPESetting("DHCPE","HospitalName")=""
    s ^DHCPESetting("DHCPE","IAdmStatuses_Resultable")="^ARRIVED^CHARGED^COMPLETED^"
    s ^DHCPESetting("DHCPE","InvColSortType")="3"
    s ^DHCPESetting("DHCPE","InvFlag")="Y"
    s ^DHCPESetting("DHCPE","NoCodeLabItem")=""
    s ^DHCPESetting("DHCPE","NoReportStation")="" 
    s ^DHCPESetting("DHCPE","ODStr")=""
    s ^DHCPESetting("DHCPE","PAPMINo_GenModel")="NoGen"
    s ^DHCPESetting("DHCPE","PEItemCodePrefix")="PE"
    s ^DHCPESetting("DHCPE","PEPatType")="公费"
    s ^DHCPESetting("DHCPE","PESystemStartDate")=""
    s ^DHCPESetting("DHCPE","PatItemSort")=""
    s ^DHCPESetting("DHCPE","PatItemSortTemp")=""
    s ^DHCPESetting("DHCPE","PatNO_Begin")=""
    s ^DHCPESetting("DHCPE","PatOrdFlag")="0^0"
    s ^DHCPESetting("DHCPE","RegNoLength")="10"
    s ^DHCPESetting("DHCPE","ReportTitle")=""
    s ^DHCPESetting("DHCPE","RoundingFeeLimitMin")="50"
    s ^DHCPESetting("DHCPE","SSGroup_SummarizeAudit")=""
    s ^DHCPESetting("DHCPE","SalesDefaultDept")=""
    s ^DHCPESetting("DHCPE","SpecialPayModes")="1,2"
    s ^DHCPESetting("DHCPE","TarOCIsNew")="N"
    s ^DHCPESetting("DHCPE","StationId_NoAdvice")=""
    s ^DHCPESetting("DHCPE","StationId_NoSubmit")=""
    s ^DHCPESetting("DHCPE","TrakVerison")="TrakCare"
    s ^DHCPESetting("DHCPEBaseData","PEARCOS")=""
    s ^DHCPESetting("DHCPE","StationId_Ris","SendRisApplication")=""
    s ^DHCPESetting("DHCPE","AllowAddItem")=""
    */
    q 0
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.HISUICommon","FindCategory")
Query FindCategory() As websys.Query(ROWSPEC = "id:%String,Category:%String")
{
}

ClassMethod FindCategoryExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
    
    s id=0
    f  s id=$O(^User.DHCPEOMETypeD(id)) q:id=""  d
    .s Active=$LG(^User.DHCPEOMETypeD(id),4)
    .q:Active'="Y"
    .s VipLevel=$LG(^User.DHCPEOMETypeD(id),5)
    .s VIPDesc=""
    .i VipLevel'="" s VIPDesc=##class(web.DHCPE.PreCommon).GetVIPDescBYLevel(VipLevel)
    .q:VIPDesc'["职业病"
    .s Category=$LG(^User.DHCPEOMETypeD(id),3)
   
   

    .s ^CacheTemp(repid,ind)=$lb(id,Category)
    .s ind=ind+1
    
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.HISUICommon","FindTypeofwork")
Query FindTypeofwork() As websys.Query(ROWSPEC = "id:%String,Typeofwork:%String")
{
}

ClassMethod FindTypeofworkExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 

    s id=0
    f  s id=$O(^User.DHCPEWorkTypeD(id)) q:id=""  d
    .s Active=$LG(^User.DHCPEWorkTypeD(id),4)
    .q:Active'="Y"
    .s Typeofwork=$LG(^User.DHCPEWorkTypeD(id),3)
        
   
   

    .s ^CacheTemp(repid,ind)=$lb(id,Typeofwork)
    .s ind=ind+1
    
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.HISUICommon","ProtectiveMeasure")
Query FindProtectiveMeasure() As websys.Query(ROWSPEC = "id:%String,ProtectiveMeasure:%String")
{
}

ClassMethod FindProtectiveMeasureExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 

    s id=0
    f  s id=$O(^User.DHCPEProtectiveMeasuresD(id)) q:id=""  d

    .s Active=$LG(^User.DHCPEProtectiveMeasuresD(id),4)
    .q:Active'="Y"
    .s ProtectiveMeasure=$LG(^User.DHCPEProtectiveMeasuresD(id),3)
        
   
   

    .s ^CacheTemp(repid,ind)=$lb(id,ProtectiveMeasure)
    .s ind=ind+1
    
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.HISUICommon","FindIndustry")
Query FindIndustry() As websys.Query(ROWSPEC = "id:%String,Industry:%String")
{
}

ClassMethod FindIndustryExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
    
    s id=0
    f  s id=$O(^User.DHCPEIndustryD(id)) q:id=""  d
    .s Active=$LG(^User.DHCPEIndustryD(id),4)
    .q:Active'="Y"
    .s Industry=$LG(^User.DHCPEIndustryD(id),3)
   
   

    .s ^CacheTemp(repid,ind)=$lb(id,Industry)
    .s ind=ind+1
    
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

Query FindPatFeeTypeName() As websys.Query(ROWSPEC = "id:%String,Desc:%String")
{
}

ClassMethod FindPatFeeTypeNameExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
    
    s id=0
    f  s id=$O(^PAC("SUBT",id)) q:id=""  d
    .s Desc=$P($G(^PAC("SUBT",id)),"^",2)
    .s ^CacheTemp(repid,ind)=$lb(id,Desc)
    .s ind=ind+1
    
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.HISUICommon","FindSex")
Query FindSex() As websys.Query(ROWSPEC = "id:%String,sex:%String")
{
}

ClassMethod FindSexExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
    
    s id=0
    f  s id=$O(^CT("SEX",id)) q:id=""  d
    .s Active=$P($g(^CT("SEX",id)),"^",8)
    .q:Active'="Y"
    .s sex=$P($g(^CT("SEX",id)),"^",2)
    .s:sex'="" sex=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.CTSex",sex,"CTSEXDesc","cls")
    .s ^CacheTemp(repid,ind)=$lb(id,sex)
    .s ind=ind+1
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

Query FindPatFeeType() As websys.Query(ROWSPEC = "id:%String,desc:%String")
{
}

ClassMethod FindPatFeeTypeExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
    s id=0
    f  s id=$O(^PAC("SUBT",id)) q:id=""  d
    .s desc=$P($G(^PAC("SUBT",id)),"^",2)
    .s desc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.PACEpisodeSubType",desc,"SUBTDesc","cls")
    .s ^CacheTemp(repid,ind)=$lb(id,desc)
    .s ind=ind+1
    
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

Query FindIfInsert() As websys.Query(ROWSPEC = "id:%String,desc:%String")
{
}

ClassMethod FindIfInsertExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
    s ^CacheTemp(repid,ind)=$lb(0,"否")
    s ind=ind+1
    s ^CacheTemp(repid,ind)=$lb(1,"是")
    s ind=ind+1
    
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

Query FindRoomPlace(VIPLevel As %String = "", GIType As %String = "") As websys.Query(ROWSPEC = "id:%String,desc:%String")
{
}

ClassMethod FindRoomPlaceExecute(ByRef qHandle As %Binary, VIPLevel As %String = "", GIType As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
    s CurLoc=%session.Get("LOGON.CTLOCID")
    s id=0
    f  s id=$o(^DHCPECTDataEx("RoomPlace",id)) q:id=""  d
    .s locid=$p($g(^DHCPECTDataEx("RoomPlace",id)),"^",5)
    .q:locid'=CurLoc
    .s Str=$G(^DHCPECTDataEx("RoomPlace",id))
    .s TVIPLevelID=$P(Str,"^",3)
    .q:(VIPLevel'="")&&(VIPLevel'=TVIPLevelID)
    .s TGIType=$P(Str,"^",4)
    .q:(GIType'="")&&(TGIType'="N")&&(TGIType'="")&&(TGIType'=GIType)
    .s desc=$p($g(^DHCPECTDataEx("RoomPlace",id)),"^",2)
    .s ^CacheTemp(repid,ind)=$lb(id,desc)
    .s ind=ind+1
    
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

/// Description: 获取卡类型下对应的默认证件类型
/// Input:       Card:卡类型Id
/// Return：     默认证件类型
/// debug: w ##class(web.DHCPE.HISUICommon).GetDefCardType(1)
ClassMethod GetDefCardType(Card As %String = "")
{
	s DefCardTypeID=""
	i Card'="" s DefCardTypeID=$p(^DHCCARDTYPEDef(+Card),"^",44)
	q DefCardTypeID
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.HISUICommon","FindPAPMICardType",1)
Query FindPAPMICardType(Card As %String = "") As websys.Query(ROWSPEC = "id:%String,type:%String")
{
}

ClassMethod FindPAPMICardTypeExecute(ByRef qHandle As %Binary, Card As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
    s CardTStr=""
    i Card'="" s CardTStr=$p(^DHCCARDTYPEDef(+Card),"^",43)
    s id=0
    f  s id=$O(^PAC("CARD",id)) q:id=""  d
    .s active=$p($g(^PAC("CARD",id,"DHC")),"^",1)
    .q:active'="Y"
    .q:(CardTStr'="")&&((","_CardTStr_",")'[(","_id_","))
    .s type=$P($G(^PAC("CARD",id)),"^",2)  
    .s type=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCCredType",type,"CRTDesc","cls")
    .s ^CacheTemp(repid,ind)=$lb(id,type)
    .s ind=ind+1
    
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

Query FindVIP() As websys.Query(ROWSPEC = "id:%String,desc:%String") [ SqlProc ]
{
}

ClassMethod FindVIPExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
    
    s id=0
    f  s id=$o(^DHCPEVIPLevel("VIP",id)) q:id=""  d
    .s use=$p($g(^DHCPEVIPLevel("VIP",id)),"^",4)
    .q:use'="Y"
    .s desc=$p($g(^DHCPEVIPLevel("VIP",id)),"^",2)
    .s ^CacheTemp(repid,ind)=$lb(id,desc)
    .s ind=ind+1
    
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

Query FindRPFlag() As websys.Query(ROWSPEC = "id:%String,desc:%String")
{
}

ClassMethod FindRPFlagExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
    s ^CacheTemp(repid,1)=$lb("Y","是")
    s ^CacheTemp(repid,2)=$lb("N","否")
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

Query FindMarried() As websys.Query(ROWSPEC = "id:%String,married:%String")
{
}

ClassMethod FindMarriedExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
    
    s id=0
    f  s id=$O(^CT("MAR",id)) q:id=""  d
    .s Active=$P($g(^CT("MAR",id)),"^",6)
    .q:Active'="Y"
    .s married=$P($g(^CT("MAR",id)),"^",2)
    .s married=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.CTMarital",married,"CTMARDesc","cls")
    .s ^CacheTemp(repid,ind)=$lb(id,married)
    .s ind=ind+1
   
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.HISUICommon","FindCardType")
Query FindCardType() As websys.Query(ROWSPEC = "id:%String,cardtype:%String")
{
}

ClassMethod FindCardTypeExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
    
    s id=0
    f  s id=$O(^DHCCARDTYPEDef(id)) q:id=""  d
    .
    .s cardtype=$P($G(^DHCCARDTYPEDef(id)),"^",2)
    .S ActiveFlag=$P($G(^DHCCARDTYPEDef(id)),"^",11)
    .Q:ActiveFlag'="IE"
    .s dateto=$P($G(^DHCCARDTYPEDef(id)),"^",10)
    .q:(dateto'="")&&(dateto<+$h)
    .s ^CacheTemp(repid,ind)=$lb(id,cardtype)
    .s ind=ind+1
    
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

Query FindPayMode() As websys.Query(ROWSPEC = "id:%String,text:%String")
{
}

ClassMethod FindPayModeExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
    
    s id=0
    f  s id=$O(^CT("CTPM",id)) q:id=""  d
    .
    .s paymode=$P($G(^CT("CTPM",id)),"^",2)
    .
    .s ^CacheTemp(repid,ind)=$lb(id,paymode)
    .s ind=ind+1
    
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

///  extFlag=0   查询全部体检支付方式
///  extFlag=1   去除第三方支付方式
Query FindTJPayMode(extFlag As %String = "0", LocID As %String = "") As websys.Query(ROWSPEC = "id:%String,text:%String")
{
}

ClassMethod FindTJPayModeExecute(ByRef qHandle As %Binary, extFlag As %String = "0", LocID As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
    
    s id=0
    f  s id=$O(^CT("CTPM",id)) q:id=""  d
    .s payCode=$P($G(^CT("CTPM",id)),"^",1)
    .s paymode=$P($G(^CT("CTPM",id)),"^",2)
    .;q:$G(^DHCPESetting("DHCPE","CashierMode",id))'="Y"
    .;q:(extFlag=1)&&($G(^DHCPESetting("DHCPE","ExtPayModeCode"))[("^"_payCode_"^"))
    .q:$G(^DHCPESetting("DHCPE","CashierMode",LocID,id))'="Y"
    .q:(extFlag=1)&&($G(^DHCPESetting("DHCPE","ExtPayModeCode",LocID))[("^"_payCode_"^"))
    .s paymode=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.CTPayMode",paymode,"CTPMDesc","cls")
    .s ^CacheTemp(repid,ind)=$lb(id,paymode)
    .s ind=ind+1
    
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

Query FindTJCardPayMode(LocID As %String = "") As websys.Query(ROWSPEC = "id:%String,text:%String")
{
}

ClassMethod FindTJCardPayModeExecute(ByRef qHandle As %Binary, LocID As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
    
    s id=0
    f  s id=$O(^CT("CTPM",id)) q:id=""  d
    .s paymode=$P($G(^CT("CTPM",id)),"^",2)
    .;q:$G(^DHCPESetting("DHCPE","CardMode",id))'="Y"
    .q:$G(^DHCPESetting("DHCPE","CardMode",LocID,id))'="Y"
    .s paymode=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.CTPayMode",paymode,"CTPMDesc","cls")
    .s ^CacheTemp(repid,ind)=$lb(id,paymode)
    .s ind=ind+1
    
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

/// Description:  查询科室        
/// dubug: d ##class(%ResultSet).RunQuery("web.DHCPE.HISUICommon","FindUser")
Query FindUser(desc, Type As %String = "", LocID As %String = "", hospId As %String = "") As websys.Query(ROWSPEC = "id:%String,name:%String")
{
}

ClassMethod FindUserExecute(ByRef qHandle As %Binary, desc, Type As %String = "", LocID As %String = "", hospId As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
    
    s id=0
    f  s id=$O(^SSU("SSUSR",id)) q:id=""  d
    .s name=$p($g(^SSU("SSUSR",id)),"^",2)
    .S Initials=$p($g(^SSU("SSUSR",id)),"^",1)
    .s name=name_"("_Initials_")"
    .q:(desc'="")&&(name'[desc)
    .s DateShowFlag=##class(web.DHCPE.HISUICommon).GetDateShowDataFlag("SS_User",id,Type,LocID)
    .q:DateShowFlag="Y"
    .s HOSPshowFlag=##class(web.DHCPE.HISUICommon).GetHospShowDataFlag("SS_User",id,hospId)
    .q:(HOSPshowFlag="N")

    .s ^CacheTemp(repid,ind)=$lb(id,name)
    .s ind=ind+1
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

/// Creator:xy
/// CreateDate:20200916
/// Description:根据日期判断是否有权显示表里某一条数据
/// Input:tableName(表名称，格式如SS_User),dataid(对应表数据RowID,如用户id),Type(类型:B 业务,F 查询统计),LocID(科室ID)
/// Output:Y/N
/// w ##class(web.DHCPE.HISUICommon).GetDateShowDataFlag("SS_User",12187)
ClassMethod GetDateShowDataFlag(tableName As %String = "", dataid As %String = "", Type As %String = "", LocID As %String = "")
{
    if (dataid="") q "N"
    s Flag="N"
    s IsShowBusiness="N",IsShowFindStatistic="N"
    i LocID'="" d
    .S IsShowBusiness=$g(^DHCPESetting("DHCPE","Business","IsShow",LocID)) //业务数据是否显示
    .S IsShowFindStatistic=$g(^DHCPESetting("DHCPE","FindStatistic","IsShow",LocID)) //查询统计是否显示
    i IsShowBusiness="" s IsShowBusiness="N"
    i IsShowFindStatistic="" s IsShowFindStatistic="N"
    if (tableName="SS_User"){
        
        if (Type="F"){
            if (IsShowFindStatistic="N"){
                //用户：开始日期、截止日期、是否激活
                s SSUSRRowId=dataid
                s DateFrom=$p(^SSU("SSUSR",SSUSRRowId),"^",96)
                S today=$p($h,",",1)
                i (DateFrom'="")&&(DateFrom>today) s Flag="Y"
                s DateTo=$p(^SSU("SSUSR",SSUSRRowId),"^",97)
                i (DateTo'="")&&(DateTo<today) s Flag="Y"
                s Active=$p(^SSU("SSUSR",SSUSRRowId),"^",19)
                i Active'="Y" s Flag="Y"
            }else{
                s Flag="N"
            }
        }elseif(Type="B"){
            if (IsShowBusiness="N"){
                //用户：开始日期、截止日期、是否激活
                s SSUSRRowId=dataid
                s DateFrom=$p(^SSU("SSUSR",SSUSRRowId),"^",96)
                S today=$p($h,",",1)
                i (DateFrom'="")&&(DateFrom>today) s Flag="Y"
                s DateTo=$p(^SSU("SSUSR",SSUSRRowId),"^",97)
                i (DateTo'="")&&(DateTo<today) s Flag="Y"
                s Active=$p(^SSU("SSUSR",SSUSRRowId),"^",19)
                i Active'="Y" s Flag="Y"
            }else{
                s Flag="N"
            }       
        }   
        
    }
    if (tableName="CT_Loc"){
        
        if (Type="F"){
            if (IsShowFindStatistic="N"){
                //科室：开始日期、截止日期
                s CTLocId=dataid
                s DateFrom=$p(^CTLOC(CTLocId),"^",24)
                S today=$p($h,",",1)
                i (DateFrom'="")&&(DateFrom>today) s Flag="Y"
                s DateTo=$p(^CTLOC(CTLocId),"^",25)
                i DateTo="" s DateTo=+$H+1
                i (DateTo'="")&&(DateTo<today) s Flag="Y"
                
            
            }else{
                s Flag="N"
            }
        }elseif(Type="B"){
            if (IsShowBusiness="N"){
                //科室：开始日期、截止日期
                s CTLocId=dataid
                s DateFrom=$p(^CTLOC(CTLocId),"^",24)
                S today=$p($h,",",1)
                i (DateFrom'="")&&(DateFrom>today) s Flag="Y"
                s DateTo=$p(^CTLOC(CTLocId),"^",25)
                i (DateTo'="")&&(DateTo<today) s Flag="Y"
               
            }else{
                s Flag="N"
            }       
        }   
        
    }
    if (tableName="ARC_ItmMast"){
        if (Type="F"){  
            if (IsShowFindStatistic="N"){
                //医嘱项：开始日期、截止日期
                s ArcItemSub=$p(dataid,"||",1)
                s ArcItemVer=$p(dataid,"||",2)
                s DateFrom=$p($p($G(^ARCIM(ArcItemSub,ArcItemVer,1)),"^",13),"Z",1)
                S today=$p($h,",",1)
                i (DateFrom'="")&&(DateFrom>today) s Flag="Y"
                s DateTo=$p($g(^ARCIM(ArcItemSub,ArcItemVer,7)),"^",1)
                i DateTo="" s DateTo=+$H+1
                i (DateTo'="")&&(DateTo<today) s Flag="Y"   
            }else{
                s Flag="N"
            }
        }elseif(Type="B"){
            if (IsShowBusiness="N"){
                //医嘱项：开始日期、截止日期
                s ArcItemSub=$p(dataid,"||",1)
                s ArcItemVer=$p(dataid,"||",2)
                s DateFrom=$p($p($G(^ARCIM(ArcItemSub,ArcItemVer,1)),"^",13),"Z",1)
                S today=$p($h,",",1)
                i (DateFrom'="")&&(DateFrom>today) s Flag="Y"
                s DateTo=$p($g(^ARCIM(ArcItemSub,ArcItemVer,7)),"^",1)
                i (DateTo'="")&&(DateTo<today) s Flag="Y"   
            }else{
                s Flag="N"
            }       
        }   
        
    }

    if (tableName="CT_CareProv"){
        
        if (Type="F"){
            
            if (IsShowFindStatistic="N"){
                //医护人员：开始日期、截止日期、激活标记
                s CTPCPId=dataid
                s DateFrom=$p($G(^CTPCP(CTPCPId,2)),"^",14)
                S today=$p($h,",",1)
                i (DateFrom'="")&&(DateFrom>today) s Flag="Y"
                s DateTo=$p($G(^CTPCP(CTPCPId,2)),"^",15)
                i DateTo="" s DateTo=+$H+1
                i (DateTo'="")&&(DateTo<today) s Flag="Y"
                s Active=$p($G(^CTPCP(CTPCPId,1)),"^",9)
                i Active'="Y" s Flag="Y"
            
            }else{
                s Flag="N"
            }
        }elseif(Type="B"){
            if (IsShowBusiness="N"){
                //医护人员：开始日期、截止日期、激活标记
                s CTPCPId=dataid
                s DateFrom=$p($G(^CTPCP(CTPCPId,2)),"^",14)
                S today=$p($h,",",1)
                i (DateFrom'="")&&(DateFrom>today) s Flag="Y"
                s DateTo=$p($G(^CTPCP(CTPCPId,2)),"^",15)
                i DateTo="" s DateTo=+$H+1
                i (DateTo'="")&&(DateTo<today) s Flag="Y"
                s Active=$p($G(^CTPCP(CTPCPId,1)),"^",9)
                i Active'="Y" s Flag="Y"
               
            }else{
                s Flag="N"
            }       
        }   
        
    }
    

    q Flag
}

/// Creator:xy
/// CreateDate:20200916
/// Description:根据院区判断是否有权显示表里某一条数据
/// Input:tableName(表名称，格式如SS_User),dataid(对应表数据RowID,如用户id)
/// Output:Y/N
/// w ##class(web.DHCPE.HISUICommon).GetHospShowDataFlag("SS_User",12187)
ClassMethod GetHospShowDataFlag(tableName As %String, dataid As %String, HospID As %String)
{
    q ##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(tableName,dataid,HospID)
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.HISUICommon","FindAuditUser",1)
Query FindAuditUser(StationID) As websys.Query(ROWSPEC = "id:%String,name:%String")
{
}

ClassMethod FindAuditUserExecute(ByRef qHandle As %Binary, StationID) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
    s Job=$j
    
    k ^TempDHCPEDoc(Job)
    s UserID=%session.Get("LOGON.USERID")
    s LocID=%session.Get("LOGON.CTLOCID")
    s GroupID=%session.Get("LOGON.GROUPID")
    //s ^tempdhcpe("FindAuditUser")=StationID_"^"_UserID
    s UserID=""
    f  s UserID=$O(^DHCPECFDataEx("ChartAssign",UserID)) q:UserID=""  d
    .s GroupID=""
    .f  s GroupID=$O(^DHCPECFDataEx("ChartAssign",UserID,LocID,GroupID)) q:GroupID=""  d
    ..q:$G(^DHCPECFDataEx("ChartAssign",UserID,LocID,GroupID,"Write",StationID))'="Y"
    ..s ^TempDHCPEDoc(Job,UserID)=""
    
    s id=""
    f  s id=$O(^TempDHCPEDoc(Job,id)) q:id=""  d
    .s name=$P($G(^SSU("SSUSR",id)),"^",2)
    .
    .s ^CacheTemp(repid,ind)=$lb(id,name)
    .s ind=ind+1
    
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

/// Description:  按照院区查询安全组  
/// Input:        hospId(院区ID)   
/// dubug: d ##class(%ResultSet).RunQuery("web.DHCPE.HISUICommon","FindFeeTypeSuperGroup")
Query FindFeeTypeSuperGroup(hospId As %String = "") As websys.Query(ROWSPEC = "id:%String,desc:%String")
{
}

ClassMethod FindFeeTypeSuperGroupExecute(ByRef qHandle As %Binary, hospId As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
    
    s id=0
    f  s id=$O(^SSU("SSGRP",id)) q:id=""  d
    .s desc=$p($g(^SSU("SSGRP",id)),"^",1)
    .s HOSPshowFlag=##class(web.DHCPE.HISUICommon).GetHospShowDataFlag("SS_Group",id,hospId)
    .q:(HOSPshowFlag="N")
    .s ^CacheTemp(repid,ind)=$lb(id,desc)
    .s ind=ind+1
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

/// Description:  查询院区  
/// dubug: d ##class(%ResultSet).RunQuery("web.DHCPE.HISUICommon","FindHosp")
Query FindHosp() As websys.Query(ROWSPEC = "id:%String,desc:%String")
{
}

ClassMethod FindHospExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
    
    s id=0
    f  s id=$O(^CT("HOSP",id)) q:id=""  d
    .s desc=$p($g(^CT("HOSP",id)),"^",2)
    .s DateTo=$p($g(^CT("HOSP",id)),"^",10)
    .q:((DateTo'="")&&(DateTo<+$h))
    .s ^CacheTemp(repid,ind)=$lb(id,desc)
    .s ind=ind+1
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

/// Description:  查询科室        
/// dubug: d ##class(%ResultSet).RunQuery("web.DHCPE.HISUICommon","FindLoc")
Query FindLoc() As websys.Query(ROWSPEC = "id:%String,loc:%String")
{
}

ClassMethod FindLocExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
    
    s id=0
    f  s id=$O(^CTLOC(id)) q:id=""  d
    .s loc=$p($g(^CTLOC(id)),"^",2)
    .s ^CacheTemp(repid,ind)=$lb(id,loc)
    .s ind=ind+1
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

Query FindStation() As websys.Query(ROWSPEC = "id:%String,desc:%String")
{
}

ClassMethod FindStationExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
    s loc=%session.Get("LOGON.CTLOCID")
    
    //s LabStation=$g(^DHCPESetting("DHCPE","StationId_Lab"))
    s LabStation=$g(^DHCPESetting("DHCPE","StationId_Lab",loc))

    s id=0
    f  s id=$O(^DHCPEST(id)) q:id=""  d
    .s Active=$p($g(^DHCPEST(id)),"^",5)
    .q:Active'="Y"
    .q:LabStation=id
    .s desc=$P($G(^DHCPEST(id)),"^",2)
    .s ^CacheTemp(repid,ind)=$lb(id,desc)
    .s ind=ind+1
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

Query FindStationBase() As websys.Query(ROWSPEC = "id:%String,desc:%String")
{
}

ClassMethod FindStationBaseExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
    s LabStation=$g(^DHCPESetting("DHCPE","StationId_Lab"))
    s id=0
    f  s id=$O(^DHCPEST(id)) q:id=""  d
    .s Active=$p($g(^DHCPEST(id)),"^",5)
    .q:Active'="Y"
    .s desc=$P($G(^DHCPEST(id)),"^",2)
    .s ^CacheTemp(repid,ind)=$lb(id,desc)
    .s ind=ind+1
    
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

ClassMethod GetDefault(LocID As %String = "")
{
    i LocID="" s LocID=%session.Get("LOGON.CTLOCID")
    //s ret=$G(^DHCPESetting("DHCPE","DefPatientType"))
    s ret=$G(^DHCPESetting("DHCPE","DefPatientType",LocID))
    q "{""ret"":"""_ret_"""}"
}

ClassMethod GetOpenCharge(LocID, UserID)
{
    s ret=$G(^DHCPEDataEx("OpenCharge",LocID,UserID))
    q ret
}

ClassMethod SetOpenCharge(flag, LocID, UserID)
{
    s ^DHCPEDataEx("OpenCharge",LocID,UserID)=flag
    q 0
}

/// Description: 根据VIP等级显示危害因素
/// Input:       LocID(科室ID)
/// debug:w ##class(web.DHCPE.HISUICommon).GetHarmInfo()
ClassMethod GetHarmInfo(LocID As %String = "")
{
    s VIP="",VIPLevel=""
    /*
    f  s VIP=$o(^DHCPEVIPLevel("VIP",VIP)) q:VIP=""  d
    .s VIPDesc=$p(^DHCPEVIPLevel("VIP",VIP),"^",2)
    .s Active=$p(^DHCPEVIPLevel("VIP",VIP),"^",4)
    .q:Active'="Y"
    .if VIPDesc="职业病" d
    ..
    ..s VIPLevel=VIP
    */
    
    f  s VIP=$O(^CT.PE.VIPLevelD(VIP)) q:VIP=""  d
    .s VIPActive=$lg($g(^CT.PE.VIPLevelD(VIP)),4)
    .q:VIPActive'="Y"
    .s LocVIPLevel=$O(^CF.PE.LocVIPLevelI("IdxOfLocVIP"," "_LocID,VIP,0))
    .q:LocVIPLevel=""
    .s VIPLevelID=$lg($g(^CF.PE.LocVIPLevelD(LocVIPLevel)),3)
    .s LocVIPActive=$lg($g(^CF.PE.LocVIPLevelD(LocVIPLevel)),15)
    .i LocVIPActive="" s LocVIPActive="Y"
    .q:LocVIPActive'="Y"
    .s VIPDesc=$lg($g(^CT.PE.VIPLevelD(VIPLevelID)),3)
    .i VIPDesc="职业病" s VIPLevel=VIP
   
    q:VIPLevel="" ""
    
    s ETRowId=0,str=""
    f  s ETRowId=$o(^User.DHCPEEndangerTypeI("VIPLevelIndex",VIPLevel,ETRowId)) q:ETRowId=""  d
    .s ETDesc=$LG(^User.DHCPEEndangerTypeD(ETRowId),3)
    .s ETActive=$LG(^User.DHCPEEndangerTypeD(ETRowId),4)
    .q:ETActive'="Y"
    .s children=""
    .s EDRowId=0
    .f  s EDRowId=$o(^User.DHCPEEndangerI("EDTypeIndex",ETRowId,EDRowId)) q:EDRowId=""  d
    ..s EDDesc=$LG(^User.DHCPEEndangerD(EDRowId),3)
    ..s Active=$LG(^User.DHCPEEndangerD(EDRowId),4)
    ..q:Active'="Y"
    ..i children="" s children="{"_"""id"":"""_EDRowId_""","_"""text"":"""_EDDesc_"""}"
    ..e  s children=children_",{"_"""id"":"""_EDRowId_""","_"""text"":"""_EDDesc_"""}"
    .q:children=""
    .s:children'="" children="["_children_"]"
    .i str="" s str="{"_"""id"":""P"_ETRowId_""","_"""text"":"""_ETDesc_""","_"""children"":"_children_"}"
    .e  s str=str_","_"{"_"""id"":""P"_ETRowId_""","_"""text"":"""_ETDesc_""","_"""children"":"_children_"}"
    s str="["_str_"]"
    q str
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.HISUICommon","FindStationInfo")
Query FindStationInfo() As websys.Query(ROWSPEC = "StationID:%String,StationDesc:%String")
{
}

ClassMethod FindStationInfoExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
    
    s StationID=1
    s StationDesc=$p($g(^DHCPEST(StationID)),"^",2)         
    s ^CacheTemp(repid,ind)=$lb(StationID,StationDesc)
    s ind=ind+1
    
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

ClassMethod GetCashierPayMode()
{
    s PayMode=0,PayModeStr=""
    f  s PayMode=$o(^DHCPESetting("DHCPE","CashierMode",PayMode)) q:PayMode=""  d
    .i $g(^DHCPESetting("DHCPE","CashierMode",PayMode))="Y" d
    ..i PayModeStr="" s PayModeStr=PayMode
    ..e  s PayModeStr=PayModeStr_"^"_PayMode
    q PayModeStr
}

ClassMethod SetCashierPayMode(str)
{
    k ^DHCPESetting("DHCPE","CashierMode")
    s strlength=$L(str,"^")
    f i=1:1:strlength d
    .s paymode=$p(str,"^",i)
    .i paymode'="" s ^DHCPESetting("DHCPE","CashierMode",paymode)="Y"
    
    q 0
}

ClassMethod GetExtPayMode()
{
    s payModeStr=$G(^DHCPESetting("DHCPE","ExtPayModeCode"))
    q:payModeStr="" ""  
    q $E(payModeStr,2,$L(payModeStr)-1)
}

ClassMethod SetExtPayMode(str)
{
    i str="" 
    {
        k ^DHCPESetting("DHCPE","ExtPayModeCode")
    }else
    {
        s ^DHCPESetting("DHCPE","ExtPayModeCode")="^"_str_"^"
    }
    q 0
}

ClassMethod GetDHCScanCode()
{
    s payModeStr=$G(^DHCPESetting("DHCPE","DHCScanCode"))
    q:payModeStr="" ""  
    q $E(payModeStr,2,$L(payModeStr)-1)
}

ClassMethod SetDHCScanCode(str)
{
    i str="" 
    {
        k ^DHCPESetting("DHCPE","DHCScanCode")
    }else
    {
        s ^DHCPESetting("DHCPE","DHCScanCode")="^"_str_"^"
    }
    q 0
}

ClassMethod GetCardPayMode()
{
    s PayMode=0,PayModeStr=""
    f  s PayMode=$o(^DHCPESetting("DHCPE","CardMode",PayMode)) q:PayMode=""  d
    .i $g(^DHCPESetting("DHCPE","CardMode",PayMode))="Y" d
    ..i PayModeStr="" s PayModeStr=PayMode
    ..e  s PayModeStr=PayModeStr_"^"_PayMode
    q PayModeStr
}

ClassMethod SetCardPayMode(str)
{
    k ^DHCPESetting("DHCPE","CardMode")
    s strlength=$L(str,"^")
    f i=1:1:strlength d
    .s paymode=$p(str,"^",i)
    .i paymode'="" s ^DHCPESetting("DHCPE","CardMode",paymode)="Y"
    
    q 0
}

ClassMethod GetRefundPayMode()
{
    s PayMode=0,PayModeStr=""
    f  s PayMode=$o(^DHCPESetting("DHCPE","RefundMode",PayMode)) q:PayMode=""  d
    .i $g(^DHCPESetting("DHCPE","RefundMode",PayMode))="Y" d
    ..i PayModeStr="" s PayModeStr=PayMode
    ..e  s PayModeStr=PayModeStr_"^"_PayMode
    q PayModeStr
}

ClassMethod SetRefundPayMode(str)
{
    k ^DHCPESetting("DHCPE","RefundMode")
    s strlength=$L(str,"^")
    f i=1:1:strlength d
    .s paymode=$p(str,"^",i)
    .i paymode'="" s ^DHCPESetting("DHCPE","RefundMode",paymode)="Y"
    
    q 0
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.HISUICommon","FindOMEType")
Query FindOMEType(VIPLevel As %Library.String = "") As websys.Query(ROWSPEC = "id:%String,Desc:%String")
{
}

ClassMethod FindOMETypeExecute(ByRef qHandle As %Binary, VIPLevel As %Library.String = "") As %Status
{
    s ^tempdhcpe("VIPLevel")=VIPLevel
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
    
    s id=0
    f  s id=$o(^User.DHCPEOMETypeD(id)) q:id=""  d
    .s Desc=$LG($g(^User.DHCPEOMETypeD(id)),3)
    .s Active=$LG($g(^User.DHCPEOMETypeD(id)),4)
    .q:Active'="Y"
    .s VIP=$LG($g(^User.DHCPEOMETypeD(id)),5)
    .Q:(VIPLevel'="")&&(VIPLevel'=VIP)
    .s ^CacheTemp(repid,ind)=$lb(id,Desc)
    .s ind=ind+1 
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

ClassMethod GetAdmReason()
{
    s AdmReason=0,AdmReasonStr=""
    f  s AdmReason=$o(^DHCPESetting("DHCPE","AdmReason",AdmReason)) q:AdmReason=""  d
    .i $g(^DHCPESetting("DHCPE","AdmReason",AdmReason))="Y" d
    ..i AdmReasonStr="" s AdmReasonStr=AdmReason
    ..e  s AdmReasonStr=AdmReasonStr_"^"_AdmReason
    q AdmReasonStr
}

ClassMethod SetAdmReason(str)
{
    k ^DHCPESetting("DHCPE","AdmReason")
    s strlength=$L(str,"^")
    f i=1:1:strlength d
    .s AdmReason=$p(str,"^",i)
    .i AdmReason'="" s ^DHCPESetting("DHCPE","AdmReason",AdmReason)="Y"
    
    q 0
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.HISUICommon","SearchAdmReason")
Query SearchAdmReason(hospId As %String = "") As %Query(ROWSPEC = "TDesc:%String,TID:%String")
{
}

ClassMethod SearchAdmReasonExecute(ByRef qHandle As %Binary, hospId As %String = "") As %Status
{
   Set repid=$I(^CacheTemp)
   s ind=1
  
    s ID=0
    f  s ID=$O(^PAC("ADMREA",ID)) q:ID=""  d
    .s ReasonType=$P(^PAC("ADMREA",ID),"^",9)
    .q:ReasonType=""
    .s StartDate=$P(^PAC("ADMREA",ID),"^",3)
    .q:StartDate>+$H
    .s EndDate=$P(^PAC("ADMREA",ID),"^",4)
    .q:(EndDate'="")&&(EndDate<+$H)
    .s Desc=$P(^PAC("ADMREA",ID),"^",2)
    .s showflag =##class(web.DHCPE.HISUICommon).GetHospShowDataFlag("PAC_AdmReason",ID,hospId)
    .Q:showflag="N"

    .d OutAdmReason
    
   Set qHandle=$lb(0,repid,0)
   Quit $$$OK
OutAdmReason      
    set Data=$lb(Desc,ID)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

ClassMethod SearchAdmReasonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchAdmReasonExecute ]
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

ClassMethod SearchAdmReasonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchAdmReasonExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query FindType() As websys.Query(ROWSPEC = "id:%String,desc:%String")
{
}

ClassMethod FindTypeExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
    s ^CacheTemp(repid,1)=$lb("B","开户")
    s ^CacheTemp(repid,2)=$lb("R","交预缴金")
    s ^CacheTemp(repid,3)=$lb("RF","退预缴金")
    s ^CacheTemp(repid,4)=$lb("O","转出")
    s ^CacheTemp(repid,5)=$lb("I","转入")
    s ^CacheTemp(repid,6)=$lb("C","结算")
    s ^CacheTemp(repid,7)=$lb("CF","结算退费")
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

Query FindTJCardType() As websys.Query(ROWSPEC = "id:%String,desc:%String")
{
}

ClassMethod FindTJCardTypeExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
    s ^CacheTemp(repid,1)=$lb("R","预缴金")
    s ^CacheTemp(repid,2)=$lb("C","代金卡")
    
   
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

Query FindTJCType() As websys.Query(ROWSPEC = "id:%String,desc:%String")
{
}

ClassMethod FindTJCTypeExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
    s ^CacheTemp(repid,1)=$lb("C","代金卡")
    
   
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

Query FindTJCStatus() As websys.Query(ROWSPEC = "id:%String,desc:%String")
{
}

ClassMethod FindTJCStatusExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
    s ^CacheTemp(repid,1)=$lb("N","正常")
    s ^CacheTemp(repid,2)=$lb("A","作废")
    s ^CacheTemp(repid,3)=$lb("L","挂失")
    s ^CacheTemp(repid,4)=$lb("F","冻结")
   
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

/// w ##class(web.DHCPE.HISUICommon).GetInvListFlag()
ClassMethod GetInvListFlag(LocID As %String = "")
{
   //q:'$d(^DHCPESetting("DHCPE","InvListFlag")) 0
   // q $g(^DHCPESetting("DHCPE","InvListFlag"))
    i LocID="" s LocID=%session.Get("LOGON.CTLOCID")
    q:'$d(^DHCPESetting("DHCPE","InvListFlag",LocID)) 0
    q $g(^DHCPESetting("DHCPE","InvListFlag",LocID))
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.HISUICommon","FindHMService")
Query FindHMService() As websys.Query(ROWSPEC = "id:%String,desc:%String")
{
}

ClassMethod FindHMServiceExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
    s id=0
    f  s id=$o(^User.DHCHMCServiceClassD(id)) q:(id="")  d
    .s Code=$lg(^User.DHCHMCServiceClassD(id),3)
    .s Desc=$lg(^User.DHCHMCServiceClassD(id),4)
    .s Active=$lg(^User.DHCHMCServiceClassD(id),2)
    .q:Active="N"
    .s ^CacheTemp(repid,ind)=$lb(id,Desc)
    .s ind=ind+1 
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.HISUICommon","FindPatItem")
Query FindPatItem() As websys.Query(ROWSPEC = "id:%String,desc:%String")
{
}

ClassMethod FindPatItemExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
    s id=0
    f  s id=$o(^DHCPECTDataEx("PatItem",id)) q:(id="")  d
    .s Desc=$p($g(^DHCPECTDataEx("PatItem",id)),"^",1)
    .s ^CacheTemp(repid,ind)=$lb(id,Desc)
    .s ind=ind+1 
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.HISUICommon","FindPISCodeNew")
Query FindPISCodeNew(hospId As %String = "") As websys.Query(ROWSPEC = "id:%String,desc:%String")
{
}

ClassMethod FindPISCodeNewExecute(ByRef qHandle As %Binary, hospId As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
    s id=0
    f  s id=$o(^DHCAPPTS(id)) q:(id="")  d
    .s Desc=$P($G(^DHCAPPTS(id)),"^",2)
    .s ActiveFlag=$P($G(^DHCAPPTS(id)),"^",5)
    .q:ActiveFlag'="Y"
    .S HospDr=$P($G(^DHCAPPTS(id)),"^",4)
    .q:(HospDr'="")&&(HospDr'=hospId)
    .s Desc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCAppTestSpec",Desc,"ATSDesc","cls")
    .s ^CacheTemp(repid,ind)=$lb(id,Desc)
    .s ind=ind+1 
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.HISUICommon","OutPayMode")
Query OutPayMode(LocID As %String = "") As websys.Query(ROWSPEC = "id:%String,desc:%String")
{
}

ClassMethod OutPayModeExecute(ByRef qHandle As %Binary, LocID As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
    
    s CTPMRowId=0
    f  s CTPMRowId=$o(^CT("CTPM",CTPMRowId))  q:CTPMRowId=""  d
    .s CTPMDesc=$p(^CT("CTPM",CTPMRowId),"^",2)
    .s CTPMCode=$p(^CT("CTPM",CTPMRowId),"^",1)
    .;q:$g(^DHCPESetting("DHCPE","RefundMode",CTPMRowId))'="Y"
    .q:$g(^DHCPESetting("DHCPE","RefundMode",LocID,CTPMRowId))'="Y"
    
    .s ^CacheTemp(repid,ind)=$lb(CTPMRowId,CTPMDesc)
    .s ind=ind+1 
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

/// 功能:获取发票打印相关信息
/// 返回值:打印分类^打印明细
/// d ##class(web.DHCPE.HISUICommon).GetInvPrintInfo()
ClassMethod GetInvPrintInfo(LocID As %String = "")
{
    
    //q $G(^DHCPESetting("DHCPE","InvPrintCatInfo"))_"^"_$g(^DHCPESetting("DHCPE","InvListFlag"))
     i LocID="" s LocID=%session.Get("LOGON.CTLOCID")
     q $G(^DHCPESetting("DHCPE","InvPrintCatInfo",LocID))_"^"_$g(^DHCPESetting("DHCPE","InvListFlag",LocID))
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.HISUICommon","OutYLLB",2)
Query OutYLLB(AdmReason, HospID As %String = "") As websys.Query(ROWSPEC = "id:%String,desc:%String")
{
}

ClassMethod OutYLLBExecute(ByRef qHandle As %Binary, AdmReason, HospID As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
    
    q:AdmReason="" $$$OK
    
    s InsuType=##class(web.DHCINSUPort).GetDicByCodeAndInd("AdmReasonDrToTariType",AdmReason,6,HospID)  
    s Type="AKA130"_InsuType
    s OutString=$$Query^DHCINSUDicData(Type,"",HospID)  
    
    s JustId=+$p(OutString,"^",2)
    s Index=""
    f  s Index=$o(^CacheTemp("INSUDic",JustId,Index)) q:Index=""  d
    .s DataString=$g(^CacheTemp("INSUDic",JustId,Index))
    .s id=$p(DataString,"^",1)
    .s cType=$p(DataString,"^",2)
    .s cCode=$p(DataString,"^",3)
    .s cDesc=$p(DataString,"^",4)
    .s cDemo=$p(DataString,"^",5)
    .s cBill1=$p(DataString,"^",6)  
    .s cBill2=$p(DataString,"^",7)

    .d Build
    k ^CacheTemp("INSUDic",JustId)
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
Build
    set Data=$lb(id,cDesc)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.HISUICommon","OutAdmReason")
Query OutAdmReason(LocID As %String = "") As websys.Query(ROWSPEC = "id:%String,desc:%String")
{
}

ClassMethod OutAdmReasonExecute(ByRef qHandle As %Binary, LocID As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
     
    s ID=0
    f  s ID=$O(^PAC("ADMREA",ID)) q:ID=""  d
    .s ReasonType=$P($g(^PAC("ADMREA",ID)),"^",9)
    .q:ReasonType=""
    .s StartDate=$P($g(^PAC("ADMREA",ID)),"^",3)
    .q:StartDate>+$H
    .s EndDate=$P($g(^PAC("ADMREA",ID)),"^",4)
    .q:(EndDate'="")&&(EndDate<+$H)
    .s Desc=$P($g(^PAC("ADMREA",ID)),"^",2)
    .;q:$g(^DHCPESetting("DHCPE","AdmReason",ID))'="Y"
    .q:$g(^DHCPESetting("DHCPE","AdmReason",LocID,ID))'="Y"
    .s Desc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.PACAdmReason",Desc,"READesc","cls")
    .s ^CacheTemp(repid,ind)=$lb(ID,Desc)
    .s ind=ind+1 
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.HISUICommon","DiagnosisLevel")
Query DiagnosisLevel() As websys.Query(ROWSPEC = "id:%String,desc:%String")
{
}

ClassMethod DiagnosisLevelExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
    
    
    s EDCRowId="0"
    f  s EDCRowId=$o(^DHCPEEDC(EDCRowId)) q:EDCRowId=""  d  
    .s Desc=$P($g(^DHCPEEDC(EDCRowId)),"^",2)
    .s ^CacheTemp(repid,ind)=$lb(EDCRowId,Desc)
    .s ind=ind+1 
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

ClassMethod GetAuditById(auditid)
{
    s GIADM=$p(^DHCPEPreA(auditid),"^",3)
    s AdmType=$p(^DHCPEPreA(auditid),"^",1)
    q AdmType_"^"_GIADM
}

Query GetSpecimen(LocID As %String = "") As websys.Query(ROWSPEC = "id:%String,desc:%String")
{
}

ClassMethod GetSpecimenExecute(ByRef qHandle As %Binary, LocID As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
    
    //s LisNewVersion=$g(^DHCPESetting("DHCPE","LisNewVersion"))
    s LisNewVersion=$g(^DHCPESetting("DHCPE","LisNewVersion",LocID))
    i LisNewVersion="Y" D
    .S specid=0
    .f  s specid=$o(^dbo.BTSpecimenD(specid)) q:specid=""  d
    ..s id=$LG(^dbo.BTSpecimenD(specid),2)
    ..s Desc=$LG(^dbo.BTSpecimenD(specid),3)
    ..q:Desc'["血"
    ..s ^CacheTemp(repid,ind)=$lb(id,Desc)
    ..s ind=ind+1 
    e  d
    .s id=0
    .f  s id=$O(^TTAB("SPEC",id)) q:id=""  d
    ..s Desc=$P($G(^TTAB("SPEC",id)),"\",1)
    ..q:Desc'["血"
    ..s ^CacheTemp(repid,ind)=$lb(id,Desc)
    ..s ind=ind+1 
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

Query GetRoomPlace() As websys.Query(ROWSPEC = "id:%String,desc:%String")
{
}

ClassMethod GetRoomPlaceExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
    
    s id=0
    f  s id=$o(^DHCPECTDataEx("RoomPlace",id)) q:id=""  d
    .s locid=$p($g(^DHCPECTDataEx("RoomPlace",id)),"^",5)
    .s Desc=$p($g(^DHCPECTDataEx("RoomPlace",id)),"^",2)
    .s ^CacheTemp(repid,ind)=$lb(id,Desc)
    .s ind=ind+1 
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

/// d ##class(web.DHCPE.HISUICommon).GetRoomPlaceByID()
ClassMethod GetRoomPlaceByID(id)
{
    S Desc=""
    s Desc=$LG(^User.DHCPEAreaD($P(id,"||",1),"ChildRoom",$P(id,"||",2)),3)
    Q Desc
}

Query GetRoom() As websys.Query(ROWSPEC = "id:%String,desc:%String")
{
}

ClassMethod GetRoomExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
    s Parref=0
    f  s Parref=$O(^User.DHCPEAreaD(Parref)) q:Parref=""  d
    .s id=0
    .f  s id=$o(^User.DHCPEAreaD(Parref,"ChildRoom",id)) q:id=""  d
    ..s Str=##class(web.DHCPE.RoomManager).GetOneRoomInfo(Parref_"||"_id)
    ..s RoomDesc=$P(Str,"^",2)
    ..q:RoomDesc[("B")
    ..s RoomID=Parref_"||"_id
    ..s ^CacheTemp(repid,ind)=$lb(RoomID,RoomDesc)
    ..s ind=ind+1 
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

ClassMethod IsRecPaper(PIADM, LocId)
{
    q:PIADM="" ""
    q $d(^DHCPEDataEx("ConfirmRecPaper",PIADM))_"^"_$g(^DHCPESetting("DHCPE","IsAddItem",LocId))
}

/// 查询站点 "" 查询所有站点  L 检验站点  N 常规检查站点  X 接口检查站点  R 药品  O 其他  需要查询多个可以拼接 如 LNX 查询非药品和非其他的站点
/// d ##class(%ResultSet).RunQuery("web.DHCPE.HISUICommon","FindStationByType","")
Query FindStationByType(Type As %String = "") As websys.Query(ROWSPEC = "id:%String,desc:%String")
{
}

ClassMethod FindStationByTypeExecute(ByRef qHandle As %Binary, Type As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
     s loc=%session.Get("LOGON.CTLOCID")
     /* 
    s LabStation=$g(^DHCPESetting("DHCPE","StationId_Lab"))
    s RisStation=$g(^DHCPESetting("DHCPE","StationId_Ris"))
    s MedStation=$g(^DHCPESetting("DHCPE","StationId_Medical"))
    s OthStation=$g(^DHCPESetting("DHCPE","StationId_Other"))
    */
     s LabStation=$g(^DHCPESetting("DHCPE","StationId_Lab",loc))
    s RisStation=$g(^DHCPESetting("DHCPE","StationId_Ris",loc))
    s MedStation=$g(^DHCPESetting("DHCPE","StationId_Medical",loc))
    s OthStation=$g(^DHCPESetting("DHCPE","StationId_Other",loc))

    s id=0
    f  s id=$O(^DHCPEST(id)) q:id=""  d
    .s Active=$p($g(^DHCPEST(id)),"^",5)
    .q:Active'="Y"
    .q:((Type'="")&&(Type'["L")&&(("^"_LabStation_"^")[("^"_id_"^")))
    .q:((Type'="")&&(Type'["X")&&(("^"_RisStation_"^")[("^"_id_"^")))
    .q:((Type'="")&&(Type'["R")&&(("^"_MedStation_"^")[("^"_id_"^")))
    .q:((Type'="")&&(Type'["O")&&(("^"_OthStation_"^")[("^"_id_"^")))
    .q:((Type'="")&&(Type'["N")&&(("^"_LabStation_"^"_RisStation_"^"_MedStation_"^"_OthStation_"^")'[("^"_id_"^")))
    .s desc=$P($G(^DHCPEST(id)),"^",2)
    .s ^CacheTemp(repid,ind)=$lb(id,desc)
    .s ind=ind+1
    
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

/// 查询站点下的项目
/// d ##class(%ResultSet).RunQuery("web.DHCPE.HISUICommon","FindStationOrder",1)
Query FindStationOrder(Station As %String = "", Desc As %String = "", Type As %String = "", LocID As %String = "", hospId As %String = "") As websys.Query(ROWSPEC = "id:%String,Code:%String,desc:%String")
{
}

ClassMethod FindStationOrderExecute(ByRef qHandle As %Binary, Station As %String = "", Desc As %String = "", Type As %String = "", LocID As %String = "", hospId As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
    
    s STID=""
    s:Station'="" STID=$o(^DHCPEST(Station),-1)
    f  s STID=$o(^DHCPEST(STID)) q:STID=""  d
    .s STSub=0
    .f  s STSub=$o(^DHCPEST(STID,"O",STSub)) q:((STSub="")||((Station'="")&&(STID'=Station)))  d
    ..s id=$p($g(^DHCPEST(STID,"O",STSub)),"^",1)
    ..s Itemdesc=$p(^ARCIM($p(id,"||",1),$p(id,"||",2),1),"^",2)
    ..q:(Desc'="")&&(Itemdesc'[Desc)
    ..s Code=$p(^ARCIM($p(id,"||",1),$p(id,"||",2),1),"^",1)
    ..s DateShowFlag=##class(web.DHCPE.HISUICommon).GetDateShowDataFlag("ARC_ItmMast",id,Type,LocID)
    ..q:DateShowFlag="Y"
    ..s HOSPshowFlag=##class(web.DHCPE.HISUICommon).GetHospShowDataFlag("ARC_ItmMast",id,hospId)
    ..q:(HOSPshowFlag="N")

    ..s ^CacheTemp(repid,ind)=$lb(id,Code,Itemdesc)
    ..s ind=ind+1
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

/// w ##class(web.DHCPE.HISUICommon).IfPrintMinusInvFlag()
ClassMethod IfPrintMinusInvFlag(LocID As %String = "")
{
    i LocID="" s LocID=%session.Get("LOGON.CTLOCID")
    S flag="N"
    Q:'$d(^DHCPESetting("DHCPE","IfPrintMinusInv",LocID)) flag
    Q $g(^DHCPESetting("DHCPE","IfPrintMinusInv",LocID))
}

/// 体检医生信息
/// d ##class(%ResultSet).RunQuery("web.DHCPE.HISUICommon","FindDocUser")
Query FindDocUser(Desc As %String = "", Type As %String = "", LocID As %String = "", hospId As %String = "") As websys.Query(ROWSPEC = "UserID:%String,UserCode:%String,UserName:%String") [ SqlProc ]
{
}

ClassMethod FindDocUserExecute(ByRef qHandle As %Binary, Desc As %String = "", Type As %String = "", LocID As %String = "", hospId As %String = "") As %Status
{
    Set ind=1
    Set repid=$I(^CacheTemp)
    
    s UserID=0
    f  s UserID=$o(^DHCPERLT(0,"User",UserID)) q:UserID=""  d
    .s UserCode=$p($g(^SSU("SSUSR",UserID)),"^",1)  // 工号
    .s UserName=$p($g(^SSU("SSUSR",UserID)),"^",2)  // 姓名
    .q:(Desc'="")&&(UserName'[Desc)
    .s DateShowFlag=##class(web.DHCPE.HISUICommon).GetDateShowDataFlag("SS_User",UserID,Type,LocID)
    .q:DateShowFlag="Y"
    .s HOSPshowFlag=##class(web.DHCPE.HISUICommon).GetHospShowDataFlag("SS_User",UserID,hospId)
    .q:(HOSPshowFlag="N")
    .d OutChangedUserCode   
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
    
OutChangedUserCode
    Set Data=$LB(UserID,UserCode,UserName)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    Quit
}

ClassMethod GetStationFlag(Station, ItemID)
{
    s Flag=0
    q:(Station="")||(ItemID="") Flag
    s StationID=$o(^DHCPEST(0,"STORD_ARCIM",ItemID,0))
    i StationID=Station s Flag=1
    q Flag
}

ClassMethod SetPisNameSpace(str, LocID As %String = "")
{
   /*
    k ^DHCPESetting("DHCPE","PisNameSpace")
    i str'="" s ^DHCPESetting("DHCPE","PisNameSpace")=str
    */
    i LocID="" s LocID=%session.Get("LOGON.CTLOCID")

    k ^DHCPESetting("DHCPE","PisNameSpace",LocID)
    i str'="" s ^DHCPESetting("DHCPE","PisNameSpace",LocID)=str
    q 0
}

ClassMethod GetPisNameSpace(LocID As %String = "")
{
    i LocID="" s LocID=%session.Get("LOGON.CTLOCID")
    //Q $g(^DHCPESetting("DHCPE","PisNameSpace"))
    Q $g(^DHCPESetting("DHCPE","PisNameSpace",LocID))
}

/// 获取医护人员列表
Query FindCTPCP(Desc As %Library.String = "", Type As %String = "", LocID As %String = "", hospId As %String = "") As websys.Query(ROWSPEC = "DocName:%String:姓名,DocDr:%String:ID,Initials:%String:工号")
{
}

ClassMethod FindCTPCPExecute(ByRef qHandle As %Binary, Desc As %Library.String = "", Type As %String = "", LocID As %String = "", hospId As %String = "") As %Status
{
    //d ##class(%ResultSet).RunQuery("web.DHCPE.HISUICommon","FindCTPCP","")
    s ind=1
    Set repid=$I(^CacheTemp)
    
    s DocDR=0
    f  s DocDR=$o(^SSU("SSUSR",DocDR)) q:(DocDR="")  d
    .s CurData=$g(^SSU("SSUSR",DocDR))
    .s DocId=$P(CurData,"^",14)
    .q:DocId=""
    .s DocName=$p(CurData,"^",2)
    .q:(Desc'="")&&(DocName'[Desc)
    .s Initials=$p(CurData,"^",1)
    .s DateShowFlag=##class(web.DHCPE.HISUICommon).GetDateShowDataFlag("SS_User",DocDR,Type,LocID)
    .q:DateShowFlag="Y"
    .s HOSPshowFlag=##class(web.DHCPE.HISUICommon).GetHospShowDataFlag("SS_User",DocDR,hospId)
    .q:(HOSPshowFlag="N")

    .d OutCTPCP
    .s DocName="",CurData="",Initials=""
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
    
OutCTPCP
    s Data=$LB(DocName,DocDR,Initials)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

/// 查询疾病
/// d ##class(%ResultSet).RunQuery("web.DHCPE.HISUICommon","FindIllness","","")
Query FindIllness(Desc As %String = "", CommonIllness As %Library.String = "N", LocID) As websys.Query(ROWSPEC = "id:%String,Code:%String,desc:%String")
{
}

ClassMethod FindIllnessExecute(ByRef qHandle As %Binary, Desc As %String = "", CommonIllness As %Library.String = "N", LocID) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
    
    s alias=$ZCVT(Desc,"U")
    
    i alias="" d
    .s illID=0
    .f  s illID=$o(^DHCPEILLS(illID)) q:illID=""  d
    ..s RowId=illID
    ..d outIllData
    e  d
    .s TextDesc=$o(^DHCPEILLS(0,"Desc",alias),-1)
    .f  s TextDesc=$o(^DHCPEILLS(0,"Desc",TextDesc)) Q:(""=TextDesc)||(TextDesc'[alias)  d
    ..s illID=0
    ..f  s illID=$o(^DHCPEILLS(0,"Desc",alias,illID)) q:illID=""  d
    ...s RowId=illID
    ...d outIllData
    .s TextDesc=$o(^DHCPEILLSA(0,"Alias",alias),-1)
    .f  s TextDesc=$o(^DHCPEILLSA(0,"Alias",TextDesc)) Q:(""=TextDesc)||(TextDesc'[alias)  d
    ..s illAID=0
    ..f  s illAID=$o(^DHCPEILLSA(0,"Alias",alias,illAID)) q:illAID=""  d
    ...s illID=$P($g(^DHCPEILLSA(illAID)),"^",1)
    ...s RowId=illID
    ...d outIllData
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
    
outIllData  
    q:RowId=""
    s Code=$p($g(^DHCPEILLS(RowId)),"^",1)
    s Detail=$p($g(^DHCPEILLS(RowId)),"^",3)
    s DC=$p($g(^DHCPEILLS(RowId)),"^",2)
    s LocShowDFlag=##class(User.DHCPEIllnessStandard).GetLocShowDataFlag(RowId,LocID)
    q:LocShowDFlag'="Y"
    s NoActive=$P($g(^DHCPEILLS(RowId)),"^",12)
    i NoActive="" s NoActive="Y"
    q:(NoActive'="Y")
    S EDCommonIllness=$p($g(^DHCPEILLS(RowId)),"^",7)
    q:(CommonIllness="Y")&&(CommonIllness'=EDCommonIllness)
    d OUTDATA

    q
OUTDATA
    set Data=$lb(RowId,Code,DC)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

/// 获取血型
Query FindBlood() As websys.Query(ROWSPEC = "id:%String,desc:%String")
{
}

ClassMethod FindBloodExecute(ByRef qHandle As %Binary) As %Status
{
    //d ##class(%ResultSet).RunQuery("web.DHCPE.HISUICommon","FindBlood","")
    s ind=1
    Set repid=$I(^CacheTemp)
    
    s id=0
    f  s id=$O(^PAC("BLDT",id)) q:id=""  d
    .s Desc=""
    .s Desc=$P($G(^PAC("BLDT",id)),"^",2)
    .s Desc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.PACBloodType",Desc,"BLDTDesc","cls")
    .s ^CacheTemp(repid,ind)=$lb(id,Desc)
    .s ind=ind+1 
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

/// 获取类型
Query FindPatType(HospID) As websys.Query(ROWSPEC = "id:%String,desc:%String")
{
}

ClassMethod FindPatTypeExecute(ByRef qHandle As %Binary, HospID) As %Status
{
    //d ##class(%ResultSet).RunQuery("web.DHCPE.HISUICommon","FindPatType","")
    s ind=1
    Set repid=$I(^CacheTemp)
    
    s id=0
    f  s id=$O(^CT("SS",id)) q:id=""  d
    .s Desc=""
    .s Desc=$P($G(^CT("SS",id)),"^",2)
    .s HOSPshowFlag=##class(web.DHCPE.HISUICommon).GetHospShowDataFlag("CT_SocialStatus",id,HospID)
    .q:(HOSPshowFlag="N")
    .s:Desc'="" Desc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.CTSocialStatus",Desc,"SSDesc","cls")
    .s ^CacheTemp(repid,ind)=$lb(id,Desc)
    .s ind=ind+1 
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

/// 获取民族
Query FindNation() As websys.Query(ROWSPEC = "id:%String,desc:%String")
{
}

ClassMethod FindNationExecute(ByRef qHandle As %Binary) As %Status
{
    //d ##class(%ResultSet).RunQuery("web.DHCPE.HISUICommon","FindNation","")
    s ind=1
    Set repid=$I(^CacheTemp)
        
    s id=0
    f  s id=$o(^CT("NAT",id)) q:id=""  d
    .s Desc=""
    .s Desc=$p(^CT("NAT",id),"^",2)
    .s Desc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.CTNation",Desc,"CTNATDesc","cls")
    .s ^CacheTemp(repid,ind)=$lb(id,Desc)
    .s ind=ind+1 
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.HISUICommon","FindOccupation")
Query FindOccupation() As websys.Query(ROWSPEC = "id:%String,desc:%String")
{
}

ClassMethod FindOccupationExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
     
    s id=0
    f  s id=$O(^CT("OCC",id)) q:id=""  d
    .s desc=$P($G(^CT("OCC",id)),"^",2) 
    .s DateTo=$P($G(^CT("OCC",id)),"^",4) 
    .i DateTo="" s DateTo=+$H+1
    .q:DateTo<+$H
    .s DateFrom=$P($G(^CT("OCC",id)),"^",3) 
    .q:(DateFrom'="")&&(DateFrom>+$H) 
    .s desc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.CTOccupation",desc,"CTOCCDesc","cls")
    .s ^CacheTemp(repid,ind)=$lb(id,desc)
    .s ind=ind+1  
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

/// Creator: xueying
/// added by xy 20201020
/// function:获取医嘱项的接收科室
/// w ##class(web.DHCPE.HISUICommon).GetArcItemRecLoc("5251||1",152)
ClassMethod GetArcItemRecLoc(arcitem, ADMLoc) As %String
{
    
    s ItemCatDR=$p($g(^ARCIM($p(arcitem,"||",1),$p(arcitem,"||",2),1)),"^",10)
    s ARCIMDesc=$p($g(^ARCIM($p(arcitem,"||",1),$p(arcitem,"||",2),1)),"^",2)
    s flag=0
    
    //医嘱项 ARC_ItmMast  医嘱项接收科室 ARC_ItmRecLoc
    s ARCRLARCIMSub=$p(arcitem,"||",1)
    s ARCRLSub=0
    f  s ARCRLSub=$o(^ARCRL(ARCRLARCIMSub,ARCRLSub)) q:ARCRLSub=""  d
    .s ARCRLOrdLocDR=$P($G(^ARCRL(ARCRLARCIMSub,ARCRLSub)),"^",1) //病人科室
    .q:(ADMLoc'="")&&(ARCRLOrdLocDR'=ADMLoc)&&(ARCRLOrdLocDR'="")
    .S ARCRLDateFrom=$P($G(^ARCRL(ARCRLARCIMSub,ARCRLSub)),"^",8)
    .q:(ARCRLDateFrom'="")&&(ARCRLDateFrom>+$H) 
    .S ARCRLDateTo=$P($G(^ARCRL(ARCRLARCIMSub,ARCRLSub)),"^",9)
    .i ARCRLDateTo="" s ARCRLDateTo=+$H+1
    .q:ARCRLDateTo<+$H
    .s ARCRLRecLocDR=$P($G(^ARCRL(ARCRLARCIMSub,ARCRLSub)),"^",2) //接收科室
    .q:ARCRLRecLocDR=""
    .s flag=1
    
     q:flag=1 flag_"$"_ARCIMDesc
     
    //医嘱子分类 ARC_ItemCat   医嘱子分类接收科室 ARC_ItemCatRecLoc
    ;b ;ItemCatDR
    s RLsub=0
    f  s RLsub=$o(^ARC("IC",ItemCatDR,"RL",RLsub)) q:RLsub=""  d
    .s OrdLocDR=$p($g(^ARC("IC",ItemCatDR,"RL",RLsub)),"^",2) //病人科室
    .q:(ADMLoc'="")&&(OrdLocDR'=ADMLoc)&&(OrdLocDR'="")
    .s RecLocDR=$p($g(^ARC("IC",ItemCatDR,"RL",RLsub)),"^",3) //接收科室
    .q:RecLocDR=""
    .s DateFrom=$p($g(^ARC("IC",ItemCatDR,"RL",RLsub)),"^",8)
    .q:(DateFrom'="")&&(DateFrom>+$H) 
    .s DateTo=$p($g(^ARC("IC",ItemCatDR,"RL",RLsub)),"^",9)
    .i DateTo="" s DateTo=+$H+1
    .q:DateTo<+$H
    .s flag=1
     q:flag=1 flag_"$"_ARCIMDesc
    
    //医嘱大类OEC_OrderCategory   医嘱大类接收科室  OEC_OrdCatRecLoc
    s OECORCAT=$P($G(^ARC("IC",ItemCatDR)),"^",8)
    s RLsub=0
    f  s RLsub=$o(^OEC("ORCAT",OECORCAT,"RL",RLsub))  q:RLsub=""  d
    .s RLOrdLocDR=$p($g(^OEC("ORCAT",OECORCAT,"RL",RLsub)),"^",2) //病人科室
    .q:(ADMLoc'="")&&(RLOrdLocDR'=ADMLoc)&&(RLOrdLocDR'="")
    .s RLRecLocDR=$p($g(^OEC("ORCAT",OECORCAT,"RL",RLsub)),"^",3)  //接收科室
    .q:RLRecLocDR=""
    .s RLDateFrom=$p($g(^OEC("ORCAT",OECORCAT,"RL",RLsub)),"^",8)
    .q:(RLDateFrom'="")&&(RLDateFrom>+$H)
    .s RLDateTo=$p($g(^OEC("ORCAT",OECORCAT,"RL",RLsub)),"^",9)
    .i RLDateTo="" s RLDateTo=+$H+1
    .q:RLDateTo<+$H
    .s flag=1 
    q flag_"$"_ARCIMDesc
}

/// Description: 判断套餐中的项目是否有接收科室
/// Input: SetId：套餐ID ADMLoc：就诊科室ID
/// OTput: 0$医嘱项描述
/// debug: w ##class(web.DHCPE.HISUICommon).ExistRecLocByOrdSets("186","152")
ClassMethod ExistRecLocByOrdSets(SetId As %Library.String = "", ADMLoc As %Library.String = "")
{
    //s ^tempdhcpe("Recloc")=$lb(SetId,ADMLoc)
    //获取套餐中的项目
    s itemIds=##class(web.DHCPE.Handle.ARCOrdSets).GetItemIdsBySet(SetId)
    q:itemIds="" ""
    //b ;itemIds
    s ItemLength=$l(itemIds,"^") 
    for i=1:1:ItemLength
    {
        S ItemID=$P(itemIds,"^",i)
        s FlagStr=##class(web.DHCPE.HISUICommon).GetArcItemRecLoc(ItemID,ADMLoc)
        s RecLocFlag=$p(FlagStr,"$",1)
        s ARCIMDesc=$p(FlagStr,"$",2)
        q:RecLocFlag=0
        

    }
    q FlagStr
}

/// 获取体检医生
/// Type: RLT 结果表    RPT 报告
/// d ##class(%ResultSet).RunQuery("web.DHCPE.HISUICommon","FindPEUser","","RPT")
Query FindPEUser(Desc As %String = "", Type As %String) As websys.Query(ROWSPEC = "UserID:%String,UserCode:%String,UserName:%String") [ SqlProc ]
{
}

ClassMethod FindPEUserExecute(ByRef qHandle As %Binary, Desc As %String = "", Type As %String) As %Status
{
    Set ind=1
    Set repid=$I(^CacheTemp)
    
    s UserID=0
    if Type="RLT" {
        f  s UserID=$o(^DHCPERLT(0,"User",UserID)) q:UserID=""  d
        .d QueryUser
    } elseif Type="RPT" {
        f  s UserID=$o(^DHCPERPT(0,"PrintUser",UserID)) q:UserID=""  d
        .d QueryUser
    }
    s UserID=1
    d QueryUser
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK

QueryUser
    s UserCode=$p($g(^SSU("SSUSR",UserID)),"^",1)  // 工号
    s UserName=$p($g(^SSU("SSUSR",UserID)),"^",2)  // 姓名
    q:((Desc'="")&&(UserName'[Desc))
    d OutUser
    q
    
OutUser
    Set Data=$LB(UserID,UserCode,UserName)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    Quit
}

/// w ##class(web.DHCPE.HISUICommon).GetPaymodeDesc("1^2^3")
ClassMethod GetPaymodeDesc(PaymodeStr, Type As %String = "ID")
{
    q:PaymodeStr="" ""
    s ModeLength=$l(PaymodeStr,"^")
    s PaymodeDescStr=""
   f num=1:1:ModeLength d
   .s Paymode=$p(PaymodeStr,"^",num)
   .q:Paymode=""
   .i Type="ID" s PaymodeDesc=$p($g(^CT("CTPM",Paymode)),"^",2)
   .i Type="Code" d
   ..s CTPMRowId=$o(^CT("CTPM",0,"Code",Paymode,0)) 
   ..s PaymodeDesc=$p($g(^CT("CTPM",CTPMRowId)),"^",2)
   .i PaymodeDescStr="" s PaymodeDescStr=PaymodeDesc
   .e  s PaymodeDescStr=PaymodeDescStr_","_PaymodeDesc
   q PaymodeDescStr
}

/// w ##class(web.DHCPE.HISUICommon).GetPaymodeDesc("1^2^3")
ClassMethod GetAdmReasonDesc(AdmReasonStr)
{
    q:AdmReasonStr="" ""
    s AdmReasonLength=$l(AdmReasonStr,"^")
    s AdmReasonDescStr=""
   f num=1:1:AdmReasonLength d
   .s AdmReason=$p(AdmReasonStr,"^",num)
   .s AdmReasonDesc=$p($g(^PAC("ADMREA",AdmReason)),"^",2)
   .i AdmReasonDescStr="" s AdmReasonDescStr=AdmReasonDesc
   .e  s AdmReasonDescStr=AdmReasonDescStr_","_AdmReasonDesc
   q AdmReasonDescStr
}

/// w ##class(web.DHCPE.HISUICommon).GetAdmReasonNew(152)
ClassMethod GetAdmReasonNew(loc)
{
    s AdmReason=0,AdmReasonStr=""
    f  s AdmReason=$o(^DHCPESetting("DHCPE","AdmReason",loc,AdmReason)) q:AdmReason=""  d
    .i $g(^DHCPESetting("DHCPE","AdmReason",loc,AdmReason))="Y" d
    ..i AdmReasonStr="" s AdmReasonStr=AdmReason
    ..e  s AdmReasonStr=AdmReasonStr_"^"_AdmReason
    q AdmReasonStr
}

/// w ##class(web.DHCPE.HISUICommon).SetAdmReasonNew(152)
ClassMethod SetAdmReasonNew(str, loc)
{
    k ^DHCPESetting("DHCPE","AdmReason",loc)
    s strlength=$L(str,"^")
    f i=1:1:strlength d
    .s AdmReason=$p(str,"^",i)
    .i AdmReason'="" s ^DHCPESetting("DHCPE","AdmReason",loc,AdmReason)="Y"
    
    q 0
}

/// function:查询收费配置
/// d ##class(%ResultSet).RunQuery("web.DHCPE.HISUICommon","FindCashierSetting")
Query FindCashierSetting(HospID As %String = "", LocID As %String = "") As websys.Query(ROWSPEC = "Loc,LocDesc,CashierMode,CardMode,RefundMode,InvDefaultPayMode,ExtPayMode,DHCScanCode,AdmReason,InvListFlag,InvMaxListCount,InvCol,InvPrintCatInfo,AllowCharge,IfPrintMinusInv,RoundManager,IsCardPassWord")
{
}

ClassMethod FindCashierSettingExecute(ByRef qHandle As %Binary, HospID As %String = "", LocID As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 

    s id=0
    s LocList=$g(^DHCPESetting("DHCPE","PELoc"))
    s Length=$l(LocList,"^")
    
    f i=1:1:Length d
    .s Loc=$p(LocList,"^",i)
    .q:Loc=""
    .q:(LocID'="")&&(LocID'=Loc)
    .s LocDesc="" 
    .s LocDesc=$p($g(^CTLOC(Loc)),"^",2)
    .s HospitalDR=$p($g(^CTLOC(Loc)),"^",22)
    .q:(HospID'="")&&(HospID'=HospitalDR)

    .s CashierMode=""
    .s CashierModeID=..GetCashierPayModeNew(Loc)
    .i CashierModeID'="" s CashierMode=..GetPaymodeDesc(CashierModeID,"ID")
    .s CardMode=""
    .s CardModeID=..GetCardPayModeNew(Loc)
    .i CardModeID'="" s CardMode=..GetPaymodeDesc(CardModeID,"ID")
    .s RefundMode=""
    .s RefundModeID=..GetRefundPayModeNew(Loc)
    .i RefundModeID'="" s RefundMode=..GetPaymodeDesc(RefundModeID)
    .s InvDefaultPayMode=$g(^DHCPESetting("DHCPE","InvDefaultPayMode",Loc))
    .i InvDefaultPayMode'="" s InvDefaultPayMode=..GetPaymodeDesc(InvDefaultPayMode,"ID")
    .s ExtPayMode=..GetExtPayModeNew(Loc)
    .i ExtPayMode'="" s ExtPayMode=..GetPaymodeDesc(ExtPayMode,"Code")
    .s DHCScanCode=..GetDHCScanCodeNew(Loc)
    .i DHCScanCode'="" s DHCScanCode=..GetPaymodeDesc(DHCScanCode,"Code")
    .s AdmReason=..GetAdmReasonNew(Loc)
    .i AdmReason'="" s AdmReason=..GetAdmReasonDesc(AdmReason)
    .s InvListFlag=$g(^DHCPESetting("DHCPE","InvListFlag",Loc))
    .i InvListFlag="1" S InvListFlag="是"
    .e  S InvListFlag="否"
    .s InvMaxListCount=$g(^DHCPESetting("DHCPE","InvMaxListCount",Loc))
    .s InvCol=$g(^DHCPESetting("DHCPE","InvCol",Loc))
    .s InvPrintCatInfo=$g(^DHCPESetting("DHCPE","InvPrintCatInfo",Loc))
    .i InvPrintCatInfo="Y" S InvPrintCatInfo="是"
    .e  S InvPrintCatInfo="否"
    .s AllowCharge=$g(^DHCPESetting("DHCPE","AllowCharge",Loc))
    .i AllowCharge="1" S AllowCharge="是"
    .e  S AllowCharge="否"
    .s IfPrintMinusInv=$g(^DHCPESetting("DHCPE","IfPrintMinusInv",Loc))
    .i IfPrintMinusInv="Y" S IfPrintMinusInv="是"
    .e  S IfPrintMinusInv="否"
    .s RoundManager=$g(^DHCPESetting("DHCPE","RoundManager",Loc))
    .i RoundManager="0" S RoundManager="无"
    .i RoundManager="5" S RoundManager="四舍五入"
    .i RoundManager="6" S RoundManager="五舍六入"
    .s IsCardPassWord=$g(^DHCPESetting("DHCPE","IsCardPassWord",Loc))
    .i IsCardPassWord="Y" S IsCardPassWord="是"
    .e  S IsCardPassWord="否"
    .s ^CacheTemp(repid,ind)=$lb(Loc,LocDesc,CashierMode,CardMode,RefundMode,InvDefaultPayMode,ExtPayMode,DHCScanCode,AdmReason,InvListFlag,InvMaxListCount,InvCol,InvPrintCatInfo,AllowCharge,IfPrintMinusInv,RoundManager,IsCardPassWord)
    .s ind=ind+1  
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

/// function:体检报告配置
/// d ##class(%ResultSet).RunQuery("web.DHCPE.HISUICommon","FindReportSetting")
Query FindReportSetting(HospID As %String = "", LocID As %String = "") As websys.Query(ROWSPEC = "Loc,LocDesc,PhotoFTP,ReportFTP,NetReport,NewVerReport,ReportCode,MainReportPrint,LisReportMerge,ShowEDDiagnosisSign,SplitSummary,RisReportMerge")
{
}

ClassMethod FindReportSettingExecute(ByRef qHandle As %Binary, HospID As %String = "", LocID As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 

    s id=0
    s LocList=$g(^DHCPESetting("DHCPE","PELoc"))
    s Length=$l(LocList,"^")
    
    f i=1:1:Length d
    .s Loc=$p(LocList,"^",i)
    .q:Loc=""
    .q:(LocID'="")&&(LocID'=Loc)
    .s LocDesc="" 
    .s LocDesc=$p($g(^CTLOC(Loc)),"^",2)
    .s HospitalDR=$p($g(^CTLOC(Loc)),"^",22)
    .q:(HospID'="")&&(HospID'=HospitalDR)
    .s PhotoFTP=$g(^DHCPESetting("DHCPE","PhotoFTP",Loc))
    .s ReportFTP=$g(^DHCPESetting("DHCPE","ReportFTP",Loc))
    .s NetReport=$g(^DHCPESetting("DHCPE","NetReport",Loc))
    .s NetReport=$tr(NetReport,"Y","是")
    .s NetReport=$tr(NetReport,"N","否")
    .s NewVerReport=$g(^DHCPESetting("DHCPE","NewVerReport",Loc))
    .s ReportCode=$g(^DHCPESetting("DHCPE","ReportCode",Loc))
    .s MainReportPrint=$g(^DHCPESetting("DHCPE","MainReportPrint",Loc))
    .s MainReportPrint=$tr(MainReportPrint,"Y","是")
    .s MainReportPrint=$tr(MainReportPrint,"N","否")
    .s LisReportMerge=$g(^DHCPESetting("DHCPE","LisReportMerge",Loc))
    .s LisReportMerge=$tr(LisReportMerge,"Y","是")
    .s LisReportMerge=$tr(LisReportMerge,"N","否")
    .s RisReportMerge=$g(^DHCPESetting("DHCPE","RisReportMerge",Loc))
    .s RisReportMerge=$tr(RisReportMerge,"Y","是")
    .s RisReportMerge=$tr(RisReportMerge,"N","否")
    .s ShowEDDiagnosisSign=$g(^DHCPESetting("DHCPE","ShowEDDiagnosisSign",Loc))
    .s ShowEDDiagnosisSign=$tr(ShowEDDiagnosisSign,"Y","是")
    .s ShowEDDiagnosisSign=$tr(ShowEDDiagnosisSign,"N","否")
    .s SplitSummary=$g(^DHCPESetting("DHCPE","SplitSummary",Loc))
    .s SplitSummary=$tr(SplitSummary,"Y","是")
    .s SplitSummary=$tr(SplitSummary,"N","否")
    .s ^CacheTemp(repid,ind)=$lb(Loc,LocDesc,PhotoFTP,ReportFTP,NetReport,NewVerReport,ReportCode,MainReportPrint,LisReportMerge,ShowEDDiagnosisSign,SplitSummary,RisReportMerge)
    .s ind=ind+1
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

/// Description:  查询前台配置
/// debug:        d ##class(%ResultSet).RunQuery("web.DHCPE.HISUICommon","FindPreSetting")
Query FindPreSettingNew(HospID As %String = "", LocID As %String = "") As websys.Query(ROWSPEC = "Loc,LocDesc,FeeTypeSuperGroup,AutoArrived,DefPrintType,AllowPrint,IsAddItem,IsPGetReportPT,IsPrintEItem,CardRelate,CardType,PreSurvey,CollectSpecOne,GetCurrentPrice,ZeroIsASCharged,GCheckedFlag")
{
}

ClassMethod FindPreSettingNewExecute(ByRef qHandle As %Binary, HospID As %String = "", LocID As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 

    s id=0
    s LocList=$g(^DHCPESetting("DHCPE","PELoc"))
    s Length=$l(LocList,"^")
    
    f i=1:1:Length d
    .s Loc=$p(LocList,"^",i)
    .q:Loc=""
    .q:(LocID'="")&&(LocID'=Loc)
    .s LocDesc="" 
    .s LocDesc=$p($g(^CTLOC(Loc)),"^",2)
    .s HospitalDR=$p($g(^CTLOC(Loc)),"^",22)
    .q:(HospID'="")&&(HospID'=HospitalDR)
    .s FeeTypeSuperGroup=$g(^DHCPESetting("DHCPE","FeeTypeSuperGroup",Loc))
    .i FeeTypeSuperGroup'="" s FeeTypeSuperGroup=$p($g(^SSU("SSGRP",FeeTypeSuperGroup)),"^",1)
    .s AutoArrived=$g(^DHCPESetting("DHCPE","AutoArrived",Loc))
    .s AutoArrived=$tr(AutoArrived,"Y","是")
    .s AutoArrived=$tr(AutoArrived,"N","否")
    .s DefPrintType=$g(^DHCPESetting("DHCPE","DefPrintType",Loc))
    .s DefPrintType=$tr(DefPrintType,"Y","是")
    .s DefPrintType=$tr(DefPrintType,"N","否")
    .s AllowPrint=$g(^DHCPESetting("DHCPE","AllowPrint",Loc))
    .s AllowPrint=$tr(AllowPrint,"Y","是")
    .s AllowPrint=$tr(AllowPrint,"N","否")
    .s IsPrintEItem=$g(^DHCPESetting("DHCPE","IsAddItem",Loc))
    .s IsPrintEItem=$tr(IsPrintEItem,"Y","是")
    .s IsPrintEItem=$tr(IsPrintEItem,"N","否")
    .s IsPGetReportPT=$g(^DHCPESetting("DHCPE","IsPGetReportPT",Loc))
    .s IsPGetReportPT=$tr(IsPGetReportPT,"Y","是")
    .s IsPGetReportPT=$tr(IsPGetReportPT,"N","否")
    .s IsAddItem=$g(^DHCPESetting("DHCPE","IsAddItem",Loc))
    .s IsAddItem=$tr(IsAddItem,"Y","是")
    .s IsAddItem=$tr(IsAddItem,"N","否")
    .s CardRelate=$g(^DHCPESetting("DHCPE","CardRelate",Loc))
    .i CardRelate="Yes"  s CardRelate="是"
    .e  s CardRelate="否"
    .s CardType=$g(^DHCPESetting("DHCPE","CardType",Loc))
    .i CardType'="" s CardType=$P($G(^DHCCARDTYPEDef(CardType)),"^",2)
    .s PreSurvey=$g(^DHCPESetting("DHCPE","PreSurvey",Loc))
    .s PreSurvey=$tr(PreSurvey,"Y","是")
    .s PreSurvey=$tr(PreSurvey,"N","否")
    .s CollectSpecOne=$g(^DHCPESetting("DHCPE","CollectSpecOne",Loc))
    .s CollectSpecOne=$tr(CollectSpecOne,"Y","是")
    .s CollectSpecOne=$tr(CollectSpecOne,"N","否")
    .s GetCurrentPrice=$g(^DHCPESetting("DHCPE","GetCurrentPrice",Loc))
    .i GetCurrentPrice="Y" S GetCurrentPrice="His当前价格"
    .i GetCurrentPrice="N" S GetCurrentPrice="分组预约价格"
    .s ZeroIsASCharged=$g(^DHCPESetting("DHCPE","ZeroIsASCharged",Loc))
    .s ZeroIsASCharged=$tr(ZeroIsASCharged,"Y","是")
    .s ZeroIsASCharged=$tr(ZeroIsASCharged,"N","否")
    .s GCheckedFlag=$g(^DHCPESetting("DHCPE","GCheckedFlag",Loc))
    .i GCheckedFlag="E" s GCheckedFlag="医嘱执行"
    .i GCheckedFlag="R" s GCheckedFlag="结果表"
    .i GCheckedFlag="A" s GCheckedFlag="到达"
    .s ^CacheTemp(repid,ind)=$lb(Loc,LocDesc,FeeTypeSuperGroup,AutoArrived,DefPrintType,AllowPrint,IsAddItem,IsPGetReportPT,IsPrintEItem,CardRelate,CardType,PreSurvey,CollectSpecOne,GetCurrentPrice,ZeroIsASCharged,GCheckedFlag)
    .s ind=ind+1
    
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

/// Description:查询基础配置
/// d ##class(%ResultSet).RunQuery("web.DHCPE.HISUICommon","FindPublicSetting")
Query FindPublicSettingNew(HospID As %String = "", LocID As %String = "") As websys.Query(ROWSPEC = "Loc,LocDesc,LabStation:%String,RisStationStr:%String,MedicalStation:%String,OtherStation,LABDATA:%String,MEDDATA:%String,PisNameSpace:%String,SuperGroup:%String,ItemAbridgeFlag:%String,LisInterface:%String,LisNewVersion,SendPisInterface:%String,IfRecommendItem:%String,SendPisFBWay:%String,InvDefaulltFee:%String,RoundingFee:%String,HPNo:%String,OrderInterfaceType,CashierSystem,AutoAuditUser,PhyExamDr,OrderInterface,MainDoctorGroup,CancelPEType,MHospital,CallVoice,SendOrder,IsFeeLocFlag,IsCardLocFlag,NetPreLoc,AutoNetRegister,NetCancelPE,TransResult,PreOrder,PosAdvice,ReturnVisit,RecLocHospital,KBHospTagsCode,InvDefaulltFeeAbr,RoundingFeeAbr,ThirdPartyLIS,TIllItem,ConsultingRoom")
{
}

ClassMethod FindPublicSettingNewExecute(ByRef qHandle As %Binary, HospID As %String = "", LocID As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 

    s id=0
    s LocList=$g(^DHCPESetting("DHCPE","PELoc"))
    s Length=$l(LocList,"^")
    
    f i=1:1:Length d
    .s Loc=$p(LocList,"^",i)
    .q:Loc=""
    .q:(LocID'="")&&(LocID'=Loc)
    .s LocDesc="" 
    .s LocDesc=$p($g(^CTLOC(Loc)),"^",2)
    .s HospitalDR=$p($g(^CTLOC(Loc)),"^",22)
    .q:(HospID'="")&&(HospID'=HospitalDR)

    .s InvDefaulltFeeID=$g(^DHCPESetting("DHCPE","InvDefaulltFee",Loc))
    .i InvDefaulltFeeID'="" d
    ..s InvDefaulltFee=$p($g(^ARCIM($p(InvDefaulltFeeID,"||",1),$p(InvDefaulltFeeID,"||",2),1)),"^",2)
    ..s InvDefaulltFeeAbr=$p($g(^ARCIM($p(InvDefaulltFeeID,"||",1),$p(InvDefaulltFeeID,"||",2),1)),"^",3)
    .s RoundingFeeID=$g(^DHCPESetting("DHCPE","RoundingFee",Loc))
    .i RoundingFeeID'="" d 
    ..s RoundingFee=$p($g(^ARCIM($p(RoundingFeeID,"||",1),$p(RoundingFeeID,"||",2),1)),"^",2)
    ..s RoundingFeeAbr=$p($g(^ARCIM($p(RoundingFeeID,"||",1),$p(RoundingFeeID,"||",2),1)),"^",3)
    .s HPNo=$g(^DHCPESetting("DHCPE","HPNo",Loc))
    .i HPNo'="" s HPNo=$p(HPNo,"^",2)
    .s LabStation=$g(^DHCPESetting("DHCPE","StationId_Lab",Loc))
    .i LabStation'="" s LabStation=$p($g(^DHCPEST(LabStation)),"^",2)
    .s RisStation=$g(^DHCPESetting("DHCPE","StationId_Ris",Loc))
    .s RisStationStr=""
    .i RisStation'="" d
    ..s RisLength=$l(RisStation,"^")
    ..f n=1:1:RisLength d
    ...q:$p(RisStation,"^",n)=""
    ...s RisStationDesc=$p($g(^DHCPEST($p(RisStation,"^",n))),"^",2)
    ...i RisStationStr="" s RisStationStr=RisStationDesc
    ...e  s RisStationStr=RisStationStr_" "_RisStationDesc
    .s MedicalStation=$g(^DHCPESetting("DHCPE","StationId_Medical",Loc))
    .i MedicalStation'="" s MedicalStation=$p($g(^DHCPEST(MedicalStation)),"^",2)
    .s OtherStation=$g(^DHCPESetting("DHCPE","StationId_Other",Loc))
    .i OtherStation'="" s OtherStation=$p($g(^DHCPEST(OtherStation)),"^",2)
    .s LABDATA=$g(^DHCPESetting("NAMESPACE","LABDATA",Loc))
    .s MEDDATA=$g(^DHCPESetting("NAMESPACE","MEDDATA",Loc))
    .s PisNameSpace=$g(^DHCPESetting("DHCPE","PisNameSpace",Loc))
    .s SuperGroup=$g(^DHCPESetting("DHCPE","SuperGroup",Loc))
    .i SuperGroup'="" s SuperGroup=$p($g(^SSU("SSGRP",SuperGroup)),"^",1)
    .s ItemAbridgeFlag=$g(^DHCPESetting("DHCPE","ItemAbridgeFlag",Loc))
    .s ItemAbridgeFlag=$tr(ItemAbridgeFlag,"Y","是")
    .s ItemAbridgeFlag=$tr(ItemAbridgeFlag,"N","否")
    .s LisInterface=$g(^DHCPESetting("DHCPE","LisInterface",Loc))
    .s LisInterface=$tr(LisInterface,"Y","是")
    .s LisInterface=$tr(LisInterface,"N","否")
    .s LisNewVersion=$g(^DHCPESetting("DHCPE","LisNewVersion",Loc))
    .s LisNewVersion=$tr(LisNewVersion,"Y","是")
    .s LisNewVersion=$tr(LisNewVersion,"N","否")
    .s SendPisInterface=$g(^DHCPESetting("DHCPE","SendPisInterface",Loc))
    .s SendPisInterface=$tr(SendPisInterface,"Y","是")
    .s SendPisInterface=$tr(SendPisInterface,"N","否")
    .s IfRecommendItem=$g(^DHCPESetting("DHCPE","RecommendItem",Loc))
    .s IfRecommendItem=$tr(IfRecommendItem,"Y","是")
    .s IfRecommendItem=$tr(IfRecommendItem,"N","否")
    .s SendPisFBWay=$g(^DHCPESetting("DHCPE","SendPisFBWay",Loc))
    .i SendPisFBWay="F"  s SendPisFBWay="前端"
    .i SendPisFBWay="B"  s SendPisFBWay="后台"
    .s OrderInterfaceType=$g(^DHCPESetting("DHCPE","OrderInterfaceType",Loc))
    .i OrderInterfaceType="N" s OrderInterfaceType="类方法"
    .e  s OrderInterfaceType="M程序"
    .s CashierSystem=$g(^DHCPESetting("DHCPE","CashierSystem",Loc))
    .i CashierSystem="1" s CashierSystem="个人视同收费"
    .i CashierSystem="2" s CashierSystem="团体视同收费"
    .i CashierSystem="3" s CashierSystem="都视同收费"
    .s AutoAuditUserID=$g(^DHCPESetting("DHCPE","AutoAuditUser",Loc))
    .S AutoAuditUser=""
    .I AutoAuditUserID'="" s AutoAuditUser=$p($g(^SSU("SSUSR",AutoAuditUserID)),"^",2)
    .s PhyExamDrId=$g(^DHCPESetting("DHCPE","PhyExamDrId",Loc))
    .s PhyExamDr=""
    .i PhyExamDrId'="" s PhyExamDr=$p($g(^CTPCP(PhyExamDrId,1)),"^",2)
    .s OrderInterface=$g(^DHCPESetting("DHCPE","OrderInterface",Loc))
    .s OrderInterface=$tr(OrderInterface,"Y","是")
    .s OrderInterface=$tr(OrderInterface,"N","否")
    .s MainDoctorGroup=$g(^DHCPESetting("DHCPE","MainDoctorGroup",Loc))
    .s MainDoctorGroup=$tr(MainDoctorGroup,"Y","是")
    .s MainDoctorGroup=$tr(MainDoctorGroup,"N","否")
    .s CancelPEType=$g(^DHCPESetting("DHCPE","CancelPEType",Loc))
    .i CancelPEType="1"  s CancelPEType="是"
    .e  s CancelPEType="否"
    .s MHospital=$g(^DHCPESetting("DHCPE","MHospital",Loc))
    .s MHospital=$tr(MHospital,"Y","是")
    .s MHospital=$tr(MHospital,"N","否")
    .s CallVoice=$g(^DHCPESetting("DHCPE","CallVoice",Loc))
    .s CallVoice=$tr(CallVoice,"Y","是")
    .s CallVoice=$tr(CallVoice,"N","否")
    .s SendOrder=$g(^DHCPESetting("DHCPE","SendOrder",Loc))
    .s SendOrder=$tr(SendOrder,"Y","是")
    .s SendOrder=$tr(SendOrder,"N","否")
    .s IsFeeLocFlag=$g(^DHCPESetting("DHCPE","IsFeeLocFlag",Loc))
    .s IsFeeLocFlag=$tr(IsFeeLocFlag,"Y","是")
    .s IsFeeLocFlag=$tr(IsFeeLocFlag,"N","否")
    .s CardLoc=$g(^DHCPESetting("DHCPE","IsCardLocFlag",Loc))
    .;s IsCardLocFlag=$tr(IsCardLocFlag,"Y","是")
    .;s IsCardLocFlag=$tr(IsCardLocFlag,"N","否")
    .s CardLocStr=""
    .i CardLoc'="" d
    ..s CardLocLength=$l(CardLoc,"^")
    ..f CardLocLen=1:1:CardLocLength d
    ...q:$p(CardLoc,"^",CardLocLen)=""
    ...s CardLocDesc=$p($g(^CTLOC($p(CardLoc,"^",CardLocLen))),"^",2)
    ...i CardLocStr="" s CardLocStr=CardLocDesc
    ...e  s CardLocStr=CardLocStr_","_CardLocDesc
    .s IsCardLocFlag=CardLocStr
    .s NetPreLoc=$g(^DHCPESetting("DHCPE","NetPreLoc",Loc))
    .s NetPreLoc=$tr(NetPreLoc,"Y","是")
    .s NetPreLoc=$tr(NetPreLoc,"N","否")
    .s AutoNetRegister=$g(^DHCPESetting("DHCPE","AutoNetRegister",Loc))
    .s AutoNetRegister=$tr(AutoNetRegister,"Y","是")
    .s AutoNetRegister=$tr(AutoNetRegister,"N","否")
    .s NetCancelPE=$g(^DHCPESetting("DHCPE","NetCancelPE",Loc))
    .s NetCancelPE=$tr(NetCancelPE,"Y","是")
    .s NetCancelPE=$tr(NetCancelPE,"N","否") 
    .s TransResult=$g(^DHCPESetting("DHCPE","TransResult",Loc))
    .i TransResult="PT"  s TransResult="调用平台"
    .i TransResult="PG"  s TransResult="调用各产品组"
    .s PreOrder=$g(^DHCPESetting("DHCPE","PreOrder",Loc))
    .i PreOrder="1"  s PreOrder="是"
    .e  s PreOrder="否"
    .s PosAdvice=$g(^DHCPESetting("DHCPE","PosAdvice",Loc))
    .i PosAdvice="1"  s PosAdvice="是"
    .e  s PosAdvice="否"
    .s ReturnVisit=$g(^DHCPESetting("DHCPE","ReturnVisit",Loc))
    .i ReturnVisit="1"  s ReturnVisit="是"
    .e  s ReturnVisit="否"
    .s RecLocHospital=$g(^DHCPESetting("DHCPE","RecLocHospital",Loc))
    .i RecLocHospital="1"  s RecLocHospital="是"
    .e  s RecLocHospital="否"
    .s KBHospTagsCode=""  //知识库版本代码设置,按科室组设置 zf 20211209
    .s LGLocID=##class(web.DHCPE.CT.LocGrpConfig).GetLGLocIDByLoc(Loc)
    .s:LGLocID'="" KBHospTagsCode=$g(^DHCPESetting("DHCPE","KBHospTagsCode",LGLocID))
    .s ThirdPartyLIS=$g(^DHCPESetting("DHCPE","ThirdPartyLIS",Loc))
    .s ThirdPartyLIS=$tr(ThirdPartyLIS,"Y","是")
    .s ThirdPartyLIS=$tr(ThirdPartyLIS,"N","否")
    .s TIllItem=$g(^DHCPESetting("DHCPE","IllItem",Loc))
    .i TIllItem="1"  s TIllItem="是"
    .e  s TIllItem="否"
    .s ConsultingRoom=$g(^DHCPESetting("DHCPE","ConsultingRoom",Loc))
    .s ConsultingRoom=$tr(ConsultingRoom,"Y","是")
    .s ConsultingRoom=$tr(ConsultingRoom,"N","否")
    .s ^CacheTemp(repid,ind)=$lb(Loc,LocDesc,LabStation,RisStationStr,MedicalStation,OtherStation,LABDATA,MEDDATA,PisNameSpace,SuperGroup,ItemAbridgeFlag,LisInterface,LisNewVersion,SendPisInterface,IfRecommendItem,SendPisFBWay,InvDefaulltFee,RoundingFee,HPNo,OrderInterfaceType,CashierSystem,AutoAuditUser,PhyExamDr,OrderInterface,MainDoctorGroup,CancelPEType,MHospital,CallVoice,SendOrder,IsFeeLocFlag,IsCardLocFlag,NetPreLoc,AutoNetRegister,NetCancelPE,TransResult,PreOrder,PosAdvice,ReturnVisit,RecLocHospital,KBHospTagsCode,InvDefaulltFeeAbr,RoundingFeeAbr,ThirdPartyLIS,TIllItem,ConsultingRoom)
    .s ind=ind+1
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

ClassMethod GetCardPayModeNew(loc)
{
    s PayMode=0,PayModeStr=""
    f  s PayMode=$o(^DHCPESetting("DHCPE","CardMode",loc,PayMode)) q:PayMode=""  d
    .i $g(^DHCPESetting("DHCPE","CardMode",loc,PayMode))="Y" d
    ..i PayModeStr="" s PayModeStr=PayMode
    ..e  s PayModeStr=PayModeStr_"^"_PayMode
    q PayModeStr
}

ClassMethod SetCardPayModeNew(str, loc)
{
    k ^DHCPESetting("DHCPE","CardMode",loc)
    s strlength=$L(str,"^")
    f i=1:1:strlength d
    .s paymode=$p(str,"^",i)
    .i paymode'="" s ^DHCPESetting("DHCPE","CardMode",loc,paymode)="Y"
    
    q 0
}

ClassMethod GetCashierPayModeNew(loc)
{
    s PayMode=0,PayModeStr=""
    f  s PayMode=$o(^DHCPESetting("DHCPE","CashierMode",loc,PayMode)) q:PayMode=""  d
    .i $g(^DHCPESetting("DHCPE","CashierMode",loc,PayMode))="Y" d
    ..i PayModeStr="" s PayModeStr=PayMode
    ..e  s PayModeStr=PayModeStr_"^"_PayMode
    q PayModeStr
}

ClassMethod SetCashierPayModeNew(str, loc)
{
    k ^DHCPESetting("DHCPE","CashierMode",loc)
    s strlength=$L(str,"^")
    f i=1:1:strlength d
    .s paymode=$p(str,"^",i)
    .i paymode'="" s ^DHCPESetting("DHCPE","CashierMode",loc,paymode)="Y"
    
    q 0
}

ClassMethod GetRefundPayModeNew(loc)
{
    s PayMode=0,PayModeStr=""
    f  s PayMode=$o(^DHCPESetting("DHCPE","RefundMode",loc,PayMode)) q:PayMode=""  d
    .i $g(^DHCPESetting("DHCPE","RefundMode",loc,PayMode))="Y" d
    ..i PayModeStr="" s PayModeStr=PayMode
    ..e  s PayModeStr=PayModeStr_"^"_PayMode
    q PayModeStr
}

ClassMethod SetRefundPayModeNew(str, loc)
{
    k ^DHCPESetting("DHCPE","RefundMode",loc)
    s strlength=$L(str,"^")
    f i=1:1:strlength d
    .s paymode=$p(str,"^",i)
    .i paymode'="" s ^DHCPESetting("DHCPE","RefundMode",loc,paymode)="Y"
    
    q 0
}

ClassMethod SetDHCScanCodeNew(str, loc)
{
    i str="" 
    {
        k ^DHCPESetting("DHCPE","DHCScanCode",loc)
    }else
    {
        s ^DHCPESetting("DHCPE","DHCScanCode",loc)="^"_str_"^"
    }
    q 0
}

ClassMethod SetExtPayModeNew(str, loc)
{
    i str="" 
    {
        k ^DHCPESetting("DHCPE","ExtPayModeCode",loc)
    }else
    {
        s ^DHCPESetting("DHCPE","ExtPayModeCode",loc)="^"_str_"^"
    }
    q 0
}

ClassMethod GetExtPayModeNew(loc)
{
    s payModeStr=$G(^DHCPESetting("DHCPE","ExtPayModeCode",loc))
    q:payModeStr="" ""  
    q $E(payModeStr,2,$L(payModeStr)-1)
}

ClassMethod GetDHCScanCodeNew(loc)
{
    s payModeStr=$G(^DHCPESetting("DHCPE","DHCScanCode",loc))
    q:payModeStr="" ""  
    q $E(payModeStr,2,$L(payModeStr)-1)
}

/// 根据科室取科室对应知识库版本代码
/// w ##class(web.DHCPE.HISUICommon).GetHospTagsCode(152)
ClassMethod GetHospTagsCode(loc)
{
    s KBHospTagsCode=""
    s LGLocID=##class(web.DHCPE.CT.LocGrpConfig).GetLGLocIDByLoc(loc)
    s:LGLocID'="" KBHospTagsCode=$g(^DHCPESetting("DHCPE","KBHospTagsCode",LGLocID))
    q:KBHospTagsCode="" ""
    
    s KBHospTagsCodeList=""
    s arrHT=##class(HMS.IO.ToPESrv).GetHospitalTags()
    q:arrHT.Count()<1 ""
    s Cnt=arrHT.Count()
    f idxHT=1:1:Cnt {
        s objHT=arrHT.GetAt(idxHT)
        continue:'$IsObject(objHT)
        s tKBHospTagsCode=objHT.GetAt("Code")
        s KBHospTagsCodeList=KBHospTagsCodeList_$lb(tKBHospTagsCode)
    }
    q:KBHospTagsCodeList="" ""
    q:$listfind(KBHospTagsCodeList,KBHospTagsCode)<1 ""
    
    q KBHospTagsCode
}

/// Creator：    xy 
/// CreatDate：  20220727
/// Description: 根据医嘱项判断材料和药品是否有库存
/// Input:       ArcItmid(医嘱项ID), LocID(登录科室ID)
/// Return：     0-没有满足条件的批次,1-有满足条件的批次,<0表示错误
/// debug:   w ##class(web.DHCPE.HISUICommon).FindInventary()
ClassMethod FindInventary(ArcItmid, LocID)
{
    q 1
    q:ArcItmid="" ""
    s Cont=""
    ;S DrugFormRowid=$p($g(^ARCIM(+ArcItmid,$p(ArcItmid,"||",2),1)),"^",12)
    ;q:DrugFormRowid="" ""
    s ItemCatRowid=$p($g(^ARCIM(+ArcItmid,$p(ArcItmid,"||",2),1)),"^",10)
    s OrderType=$P($g(^ARC("IC",ItemCatRowid)),"^",7)
    q:(OrderType'="R")&&(OrderType'="M") ""  
    s ChildSub=0
    f  s ChildSub=$o(^ARC("IC",ItemCatRowid,"RL",ChildSub)) q:ChildSub=""  d
    .s OrdLoc=$p(^ARC("IC",ItemCatRowid,"RL",ChildSub),"^",2)
    .q:(OrdLoc'=LocID)&&(LocID'="")
    .s RecLoc=$p(^ARC("IC",ItemCatRowid,"RL",ChildSub),"^",3)
    .//##class(web.DHCSTINTERFACE).GetAvailQtyByArc(医嘱项Id，接收科室Id，基本单位数量，0)
    .s Ret=##class(web.DHCSTINTERFACE).GetAvailQtyByArc(ArcItmid,RecLoc,1,0)
    .i Cont="" s Cont=Ret
    q Cont
}

/// Creator：    xy 
/// CreatDate：  20220727
/// Description: 根据医嘱套获取材料和药品的医嘱项信息
/// Input:       SetId(套餐ID)
/// Return：     医嘱项1ID^医嘱项2描述%%医嘱项2ID^医嘱项2描述
/// debug:   w ##class(web.DHCPE.HISUICommon).GetRMItemByARCOS()
ClassMethod GetRMItemByARCOS(SetId)
{
    q:SetId="" ""
    s ret=""
    s dateChildId=""
    f  s dateChildId=$o(^ARCOS(SetId,"DATE",dateChildId)) q:dateChildId=""  d
    .s itemChildId="0"
    .f  s itemChildId=$o(^ARCOS(SetId,"DATE",dateChildId,"ITM",itemChildId)) q:itemChildId=""  d
    ..s strDataItm=$g(^ARCOS(SetId,"DATE",dateChildId,"ITM",itemChildId))
    ..s myItemId=$p(strDataItm,"^",1)
    ..s myItemStr=$G(^ARCIM($p(myItemId,"||",1),$p(myItemId,"||",2),1))
    ..;S DrugFormRowid=$p($g(^ARCIM(+myItemId,$p(myItemId,"||",2),1)),"^",12)
    ..;q:(DrugFormRowid="")
    ..s ItemCatRowid=$p($g(^ARCIM(+myItemId,$p(myItemId,"||",2),1)),"^",10)
    ..s OrderType=$P(^ARC("IC",ItemCatRowid),"^",7)
    ..q:(OrderType'="R")&&(OrderType'="M") 
    ..s ArcDesc=$P(myItemStr,"^",2)
    ..i ret="" d
    ...s ret=myItemId_"^"_ArcDesc
    ..e  d
    ...s ret=ret_"%%"_myItemId_"^"_ArcDesc
    q ret
}

Query FindComplainType() As websys.Query(ROWSPEC = "id:%String,desc:%String")
{
}

ClassMethod FindComplainTypeExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
    s ^CacheTemp(repid,1)=$lb("C","投诉")
    //s ^CacheTemp(repid,2)=$lb("S","建议")
    
   
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

/// 体检参数配置
/// Author:WZH 20210914
/// Param:appId
/// Debugger:d ##class(%ResultSet).RunQuery("web.DHCPE.HISUICommon","SearchByCode","PEComplain","CSource")
Query SearchByCode(appcode = "", Paramcode = "") As websys.Query(ROWSPEC = "SVID:%String,Type:%String,TypeDesc:%String,TypeValue:%String,ParamValue:%String")
{
}

ClassMethod SearchByCodeExecute(ByRef qHandle As %Binary, appcode = "", Paramcode = "") As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    if ((""=appcode) || (""=Paramcode) ){
        Set qHandle=$lb(0,repid,0)
        Quit $$$OK
    }
    
    
    s appId=$o(^DHCPESettingsApp(0,"Code",appcode,0))
    If appId=""{
        Set qHandle=$lb(0,repid,0)
        Quit $$$OK
    }
    
    s SPDR=$o(^DHCPESettingsParam(0,"APPCode",appId,Paramcode,0))
    If SPDR=""{
        Set qHandle=$lb(0,repid,0)
        Quit $$$OK
    }
    
    s Type=""
    f  s Type=$o(^DHCPESettingsValue(0,"ParamDr",SPDR,"Type",Type)) q:Type=""  d
    .s SVID=""
    .f  s SVID=$o(^DHCPESettingsValue(0,"ParamDr",SPDR,"Type",Type,SVID)) q:SVID=""  d
    ..d GetRowData
    
    Set qHandle=$LISTBUILD(0,repid,0)
    Quit $$$OK
GetRowData   
    s SVData=$g(^DHCPESettingsValue(SVID))
    s TypeDesc=##class(web.DHCPE.Settings.Value).GetTypeDesc(Type)
    s TypeValue=$p(SVData,"^",3)
    s ParamValue=$p(SVData,"^",4)

    Do OutCodePutRow
    
    q
OutCodePutRow
    /***翻译 start***/
    s TypeValue=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPESettingsValue",TypeValue,"SVTypeValue","cls")
    s ParamValue=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPESettingsValue",ParamValue,"SVParamValue","cls")
    /***翻译 end***/
    set Data=$lb(SVID,Type,TypeDesc,TypeValue,ParamValue)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    Quit
}

}
