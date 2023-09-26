Import SQLUser

Class web.DHCPE.BarPrint Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 193;

ClassMethod GetPrintBarVersion()
{
    Q $G(^DHCPESetting("DHCPE","IsPrintBarNurseXML"))
}

ClassMethod GetPatOrdItemInfoNew(InString As %Library.String = "", AllowUnPayed As %Library.String = "", BDFlag As %Library.String = "", OrderFlag As %Library.String = "")
{
    s AdmId=$P(InString,"^",1)
    s PEIADM=$o(^DHCPEIADM(0,"PAADM",AdmId,0))
    s CurLocID=$P(^PAADM(AdmId),"^",4)
    s CurUserID=""
    s:$D(%session) CurUserID=%session.Get("LOGON.USERID")
    s ArrStatus=$p($G(^DHCPEIADM(PEIADM)),"^",8)
    
    q:(ArrStatus'="ARRIVED")&&(ArrStatus'="REGISTERED") ""
    s OEOriId=$P(InString,"^",2) 
    i OEOriId="" d
    .s Flag=##class(web.DHCPE.DHCPEIAdm).HaveNoPayedItem(PEIADM)
    e  d
    .s Flag=0
    .s PaiedFlag=$P(^OEORD(+OEOriId,"I",$P(OEOriId,"||",2),3),"^",5)
    .s PIADM=$P(^DHCPEIADM(PEIADM),"^",4)
    .s LocID=$P(^DHCPEPreIADM(PIADM),"^",26)
    .if $G(^DHCPESetting("DHCPE","AllowPrint",LocID))="Y" d
    ..s Flag="0"
    .e  d 
    ..i PaiedFlag'="P" s Flag=1

    q:Flag="1" "NoPayed"
    s Date=+$H
    s Time=$P($H,",",2)
    ///打印条码时如果是登记状态自动到达
    s AutoArrived=$G(^DHCPESetting("DHCPE","AutoArrived",CurLocID))
    s AutoArrived=$p(AutoArrived,"^",2)
    i AutoArrived="Y" d
    .s PreIADM=$p($G(^DHCPEIADM(PEIADM)),"^",4)
    .d ##class(web.DHCPE.DHCPEIAdm).IAdmArrived(PreIADM) 
    s OEORDRowId=0 
    s OEORDRowId=$O(^OEORD(0,"Adm",AdmId,OEORDRowId)) //oe_order表
    Q:(""=OEORDRowId) ""
    
    S OEORERowIDStr="",OEORILabEpisodeNoStr=""
    s Job=$J
    k ^TempDHCPEBarPrint(Job)
    s SpecNo=$P(InString,"^",3)
    if (OEOriId="") {
    s OEORIChildsub=0
    f  s OEORIChildsub=$O(^OEORD(OEORDRowId,"I",OEORIChildsub)) Q:(""=OEORIChildsub)  d
    .s OEORIRowId=OEORDRowId_"||"_OEORIChildsub  
    .s OEORIItemStatDR=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",13) //检验医嘱状态
    .s OEORIItmMastDR=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",2) //医嘱ID
    .Q:"4"=OEORIItemStatDR
    .q:$d(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OEORIRowId))
    .s OEORILabEpisodeNo=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,3)),"^",20)
    .i OEORILabEpisodeNo=$c(0) s OEORILabEpisodeNo=""
    .Q:(""=OEORILabEpisodeNo)
    .s ARCIMDesc=..GetARCIMDesc(OEORILabEpisodeNo,OEORDRowId)
    .s SpecimenType=..GetSpecName(OEORDRowId_"||"_OEORIChildsub)
    .s Level=3
    .s:SpecimenType[("血") Level=5
    .s:SpecimenType[("便") Level=1
    .s:SpecimenType[("尿") Level=2
    .i (ARCIMDesc[("糖化血红蛋白"))||(ARCIMDesc[("HbA1C")) s Level=4
    .;q:(((Level=2)||(Level=1))&&(OrderFlag="2"))
    .;q:(((Level=4)||(Level=3)||(Level=5))&&(OrderFlag="1"))
    .s ^TempDHCPEBarPrint(Job,Level,OEORILabEpisodeNo,OEORIRowId)=""
    }
    if (SpecNo'="")&&(OEOriId'=""){
    s OEORDRowId=""
    f  s OEORDRowId=$o(^OEORD(0,"EpisNo",SpecNo,OEORDRowId)) q:OEORDRowId=""  d
    .s OEORIChildsub=""
    .f  s OEORIChildsub=$O(^OEORD(0,"EpisNo",SpecNo,OEORDRowId,OEORIChildsub)) q:OEORIChildsub=""  d
    ..s OEORIItemStatDR=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",13) //检验医嘱状态
    ..s OEORIItmMastDR=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",2) //医嘱ID
    ..Q:"4"=OEORIItemStatDR
    ..q:$d(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OEORDRowId_"||"_OEORIChildsub))
    ..s OEORILabEpisodeNo=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,3)),"^",20)
    ..i OEORILabEpisodeNo=$c(0) s OEORILabEpisodeNo=""
    ..Q:(""=OEORILabEpisodeNo)
    ..s ARCIMDesc=..GetARCIMDesc(OEORILabEpisodeNo,OEORDRowId)
    ..s SpecimenType=..GetSpecName(OEORDRowId_"||"_OEORIChildsub)
    ..s Level=3
    ..s:SpecimenType[("血") Level=5
    ..s:SpecimenType[("便") Level=1
    ..s:SpecimenType[("尿") Level=2
    ..;q:(((Level=2)||(Level=1))&&(OrderFlag="2"))
    ..;q:(((Level=4)||(Level=3)||(Level=5))&&(OrderFlag="1"))
    ..s ^TempDHCPEBarPrint(Job,Level,OEORILabEpisodeNo,OEORDRowId_"||"_OEORIChildsub)=""
        
    }
    s Level=""
    f  s Level=$O(^TempDHCPEBarPrint(Job,Level)) q:Level=""   d
    .s OEORILabEpisodeNo=""
    .f  s OEORILabEpisodeNo=$O(^TempDHCPEBarPrint(Job,Level,OEORILabEpisodeNo)) q:OEORILabEpisodeNo=""   d
    ..s OEOrdItemID=""
    ..f  s OEOrdItemID=$O(^TempDHCPEBarPrint(Job,Level,OEORILabEpisodeNo,OEOrdItemID)) q:OEOrdItemID=""  d
    ...S OEOREChildsub=$O(^OEORD(+OEOrdItemID,"I",$P(OEOrdItemID,"||",2),"X",""),-1)
    ...S OEORERowID=OEOrdItemID_"||"_OEOREChildsub
    ...i OEORERowIDStr="" d
    ....s OEORERowIDStr=OEORERowID
    ....s OEORILabEpisodeNoStr=OEORILabEpisodeNo
    ...e  d
    ....S OEORERowIDStr=OEORERowIDStr_"^"_OEORERowID
    ....s OEORILabEpisodeNoStr=OEORILabEpisodeNoStr_"^"_OEORILabEpisodeNo
    
    ..s HadStr=$G(^DHCPETempLabEpisodeNo(OEORILabEpisodeNo))
    ..i HadStr'="" d
    ...s HadDate=+HadStr
    ...s HadTime=$p(HadStr,"^",2)
    ...i ((HadDate'="")&&(HadTime'="")) k ^DHCPETempLabEpisodeNo("Date",HadDate,HadTime,OEORILabEpisodeNo)
    ..s ^DHCPETempLabEpisodeNo(OEORILabEpisodeNo)=Date_"^"_Time_"^"_$G(CurUserID)
    ..s ^DHCPETempLabEpisodeNo("Date",Date,Time,OEORILabEpisodeNo)=""   
    d ##class(web.DHCPE.AdmRecordManager).Insert(AdmId,"A","PrintBar","","")
    Q OEORERowIDStr_"&"_OEORILabEpisodeNoStr
}

ClassMethod GetPatOrdItemInfo(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "", AllowUnPayed As %Library.String = "", BDFlag As %Library.String = "", OrderFlag As %Library.String = "")
{
    
    s AdmId=$P(InString,"^",1)
    s PEIADM=$o(^DHCPEIADM(0,"PAADM",AdmId,0))
    s ArrStatus=$p($G(^DHCPEIADM(PEIADM)),"^",8)
    q:(ArrStatus'="ARRIVED")&&(ArrStatus'="REGISTERED") ""
    s PIADM=$P(^DHCPEIADM(PEIADM),"^",4)
    s LocID=$P(^DHCPEPreIADM(PIADM),"^",26)
    s OEOriId=$P(InString,"^",2) 
    i OEOriId="" d
    .s Flag=##class(web.DHCPE.DHCPEIAdm).HaveNoPayedItem(PEIADM)
    e  d
    .s Flag=0
    .s PaiedFlag=$P(^OEORD(+OEOriId,"I",$P(OEOriId,"||",2),3),"^",5)
    .s PIADM=$P(^DHCPEIADM(PEIADM),"^",4)
    .s LocID=$P(^DHCPEPreIADM(PIADM),"^",26)
    .if $G(^DHCPESetting("DHCPE","AllowPrint",LocID))="Y" d
    ..s Flag="0"
    .e  d 
    ..i PaiedFlag'="P" s Flag=1

    q:Flag="1" "NoPayed"
    
   //s HospCode=$G(^DHCPESetting("DHCPE","HospitalCode"))
	s HospCode=$G(^DHCPESetting("DHCPE","HospitalCode",LocID))

    
    ///打印条码时如果是登记状态自动到达
    s AutoArrived=$G(^DHCPESetting("DHCPE","AutoArrived",LocID))
    s AutoArrived=$p(AutoArrived,"^",2)
    i AutoArrived="Y" d
    .s PreIADM=$p($G(^DHCPEIADM(PEIADM)),"^",4)
    .d ##class(web.DHCPE.DHCPEIAdm).IAdmArrived(PreIADM) 
    /*
    i HospCode="SYYD" d
    .s PreIADM=$p($G(^DHCPEIADM(PEIADM)),"^",4)
    .d ##class(web.DHCPE.DHCPEIAdm).IAdmArrived(PreIADM)
    */
    s ParInfo=..GetPatientInfo(AdmId) 
    s RegNo=$P(ParInfo,"^",1)       // 登记号
    s PatName = $P(ParInfo,"^",5)   // 姓名
    s PatAge = $P(ParInfo,"^",8)    // 年龄
    s BedCode = $P(ParInfo,"^",7)   // 床号
    s Sex = $P(ParInfo,"^",4)       // 性别
    s PatLoc = $P(ParInfo,"^",2)    // 部门   
    
    //      登记号 0       姓名 1        年龄 2    性别 3        病区 4        床号 5
    s ParInfo=RegNo_"^"_PatName_"^"_PatAge_"^"_Sex_"^"_PatLoc_"^"_BedCode

    s OEOrdItems=..GetOEOrdItem(AdmId,OEOriId,AllowUnPayed,BDFlag,OrderFlag) 
    i HospCode="SHHS" d
    .s Num=$p(OEOrdItems,"$$",2)
    .s OEOrdItems=$p(OEOrdItems,"$$",1)
    s ret=""
    i HospCode="SHDF"  {
    f i=1:1:($L(OEOrdItems,"@@")-1) d
    .                                      //                   标本号 6   标本类型 7  检验项目名称 8
    .s Item=ParInfo_"^"_$P(OEOrdItems,"@@",i)
    .s ret=ret_"@@"_Item
    }
    else {  
    f i=1:1:($L(OEOrdItems,";")-1) d
    .s Item=ParInfo_"^"_$P(OEOrdItems,";",i)
    .s ret=ret_";"_Item
      }
    i HospCode="SHHS" s ret=ret_"$$"_Num
    d ##class(web.DHCPE.AdmRecordManager).Insert(AdmId,"A","PrintBar","","")
    Q ret
    
    // w $$GetPatientInfo^DHCPEBarPrint("8890")
    // 参考 web.DHCLCNUREXCUTE.PatInfo ，为了和此类方法兼容保留其返回值的参数格式
}

/// debug: w ##class(web.DHCPE.BarPrint).GetPatientInfo(1319)
ClassMethod GetPatientInfo(IAdmId)
{
    s PapmiId=+^PAADM(IAdmId)

    // 登记号 PA_PatMas.{PAPMI_IPNo}
    s RegNo=$p($g(^PAPER(PapmiId,"PAT",1)),"^",1)

    // 患者姓名 PA_PatMas.{PAPMI_Name}
    s PatName=$p($g(^PAPER(PapmiId,"ALL")),"^",1)
    
    // 病案号 PA_PatMas.{PAPMI_SafetyNetCardNo}
    if $D(^PAPER(PapmiId,"PAT",3)) s Bah=$P(^PAPER(PapmiId,"PAT",3),"^",4)
   
    // 性别 PA_PatMas.{PAPMI_Sex_DR}(CT_Sex)
    s Sex=$p($g(^CT("SEX",$p($g(^PAPER(PapmiId,"ALL")),"^",7))),"^",2)
    s Sex=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.CTSex",Sex,"CTSEXDesc","cls")
    
    q:$g(^PAPER(PapmiId,"ALL"))=""
    // 住址
    S homeaddres=$G(^PAPER(PapmiId,"PER","ADD")) 
    
    // 家庭电话
    s hometel=$p($g(^PAPER(PapmiId,"PER",1)),"^",11)

    //工作电话
    s worktel=$p($g(^PAPER(PapmiId,"PER",1)),"^",9)
    
    // 手机 PA_PatMas.{PAPMI_MobPhone}
    s handtel=$p($g(^PAPER(PapmiId,"PER",4)),"^",21)  
    
    // PA_ADM.{PAADM_CurrentBed_DR}(PAC_Bed)
    s BedSub=$p($p($g(^PAADM(IAdmId)),"^",73),"||",2)
    
    // PA_ADM.{PAADM_CurrentWard_DR}(PAC_Ward)
    s curWardId=$p($g(^PAADM(IAdmId)),"^",70)  
    if curWardId'="" s WardDes=$P(^PAWARD(curWardId),"^",1)
    if (BedSub'="")&(curWardId'="") s BedCode=$p($g(^PAWARD(curWardId,"BED",BedSub)),"^",1)
    e  s BedCode=""
    
    //年龄 PA_PatMas.{PAPMI_DOB}
    s Birth=$p($g(^PAPER(PapmiId,"ALL")),"^",6)
    //s Age=##class(web.DHCLCNUREXCUTE).CalAge(Birth,+$h)
    //s Age=$P(Age,"Y",1)
    //s Age=##class(web.DHCBillInterface).GetPapmiAge(PapmiId,IAdmId)
    
    s HospID=##class(web.UDHCHospitalGroup).GetHospitalByAdm(IAdmId) //获取当前客户所在院区
    
     // 病区 PAADM_DepCode_DR(CT_Loc)
    s CtlocDr=$P(^PAADM(IAdmId),"^",4)
     if CtlocDr'="" s Ctloc=$P(^CTLOC(CtlocDr),"^",2)
    s Ctloc1=$P(Ctloc,"-",2)
    i Ctloc1'="" s Ctloc=Ctloc1
    
    //s Age=##class(web.DHCPE.DHCPECommon).GetPapmiAge(PapmiId,HospID,CtlocDr)
	s Age=##class(web.DHCBillInterface).GetPapmiAge(PapmiId,IAdmId,HospID)
   
    
    // 医师 PAADM_AdmDocCodeDR(CT_CareProv)
    s Doc=$P(^PAADM(IAdmId),"^",9)
    if ""'=Doc  s Docdes=$P($g(^CTPCP(Doc,1)),"^",2)
    
    // PAADM_CurrentRoom_DR(PAC_Room)
    s Roomdr=$P(^PAADM(IAdmId),"^",69)
    if (Roomdr'="") s Room=$P(^PAROOM(Roomdr),"^",2)

    //    登记号 1     部门 2        病房号 3       性别 4        姓名 5            病案号 6       病床号 7           年龄 8            病区 9        住址 10       家庭电话 11 工作电话 11.1       手机 11.2 医师12                        
    s ret=RegNo_"^"_$G(Ctloc)_"^"_$G(Room)_"^"_$G(Sex)_"^"_$G(PatName)_"^"_$G(Bah)_"^"_$G(BedCode)_"^"_$G(Age)_"^"_$G(WardDes)_"^"_homeaddres_"^"_hometel_"  "_worktel_"  "_handtel_"^"_$g(Docdes)_"^"_$g(PapmiId)
    q ret
}

// w ##class(web.DHCPE.BarPrint).GetPersonInfo("120^CRM")

ClassMethod GetPersonInfo(AdmId As %String)
{
    s Type=$p(AdmId,"^",2)
    s AdmId=$p(AdmId,"^",1)
    s (SortNo,PatName,PatAge,Sex,PatLoc,BedCode,RegNo,GroupDesc)=""
    i Type=""
    {
        s ParInfo=..GetPatInfo(AdmId)
        //Name_"^"_Age_"^"_SexDRName_"^"_PAPMINo_"^"_DepLoc_"^"_GName_"^"_AdmDate_"^"_$G(SortNo)
        s RegNo=$P(ParInfo,"^",4)       // 登记号
        s PatName = $P(ParInfo,"^",1)   // 姓名
        s PatAge = $P(ParInfo,"^",2)    // 年龄
        s BedCode = ""  // 床号
        s Sex = $P(ParInfo,"^",3)       // 性别
        s SortNo=$P(ParInfo,"^",8)
        s PatLoc = $P(ParInfo,"^",5)    // 部门   
        s GroupDesc=$P(ParInfo,"^",6)
        s GroupDesc=$p(GroupDesc,"  分组",1)
        s GroupDesc=$p(GroupDesc,"单位:",2)
        s IADMDR=$O(^DHCPEIADM(0,"PAADM",AdmId,0))
        s PreIADM=$p($g(^DHCPEIADM(IADMDR)),"^",4)
    }
    elseif Type="CRM"
    {//SortNo,PatName,PatAge,Sex,PatLoc,BedCode,RegNo,GroupDesc
        s CurData=$p(^DHCPEPreIADM(AdmId),"^",1)
        s PIBIDR=$P(CurData,"^",1)
        s PreIADM=AdmId
        s GADM=$P(CurData,"^",2)
        s GTeam=$P(CurData,"^",3)
        i PIBIDR'="" d
        .s CurData=$G(^DHCPEPreIBI(PIBIDR))
        .// PIBI_PAPMINo        登记号
        .s RegNo=$p(CurData,"^",1)
        .s Position=$P(CurData,"^",11)
        .i Position'="" s Position="("_Position_")"
        i GADM'="" d
        .s GBaseInfo=$P(^DHCPEPreGADM(GADM),"^",1)
        .i GBaseInfo'="" d
        ..s GroupDesc=$p(^DHCPEPreGBI(GBaseInfo),"^",2)
        ..s GName="单位:"_GroupDesc_Position
        i GTeam'="" d
        .s Char=##class(web.DHCPE.PreIADM).NumToChar($p(GTeam,"||",2))
        .s SortNo=Char_$G(^DHCPEDataEx("DHCPEPreIADM","GTEAM","IADM",PIADMDR))
        .s GTeam=$p(^DHCPEPreGADM(+GTeam,"Team",$p(GTeam,"||",2)),"^",1)
        .s GTeam="  分组:"_GTeam
        .s GName=GName_GTeam
        i PIBIDR'="" d
        
        .// PIBI_Name   姓名
        .s PatName=$p(CurData,"^",2)
    
        .// PIBI_Sex_DR = CT_Sex.{} 性别
        .s SexDR=$p(CurData,"^",3)
        .s:(""'=SexDR) Sex=$p(^CT("SEX",SexDR),"^",2)
    
        .// PIBI_DOB        出生日期
        .s Dob=$p(CurData,"^",4)
        .i Dob'="" s PAPERDob=$ZD(Dob,3)
    
        .// 年龄 
        .s Age=""
        .s:(""'=Dob) PatAge=##class(web.DHCLCNUREXCUTE).CalAge(Dob,+$h)
        .s PatAge=$P(Age,"Y")
        .s PatAgee=PatAge_"岁"
        s DepLoc=%session.Get("LOGON.CTLOCID")
        i DepLoc'="" d
        .s DepLoc=$P(^CTLOC(DepLoc),"^",2)
        s PatLoc=$p(DepLoc,"-",2)
    }
    
    
    s Diet=##class(web.DHCPE.PreIADM).GetDietType(PreIADM,"") 
    //      登记号 0       姓名 1        年龄 2    性别 3        病区 4        床号 5
    s ParInfo=SortNo_"^"_PatName_"^"_PatAge_"^"_Sex_"^"_PatLoc_"^"_BedCode_"^"_RegNo_"^"_GroupDesc_"^"_Diet
    
    q ParInfo
}

/// Type Lis
ClassMethod GetOEOrdItemStat(Type, OEOriId)
{
    s StatDR=""
    i Type="Lis" d
    .s StatDR=$p($G(^OEORD(+OEOriId,"I",$P(OEOriId,"||",2),1)),"^",13)
    q StatDR
}

// w ##class(web.DHCPE.BarPrint).GetOEOrdItem(435977,"434624||12","Y","Y")

ClassMethod GetOEOrdItem(AdmId, OEOriId, AllowUnPayed As %Library.String = "N", BDFlag, OrderFlag)
{
   
    s quitflag=0
    i ""'=$G(OEOriId) s quitflag=1
    
    s LocID=$P($g(^PAADM(AdmId)),"^",4)
	I LocID="" s LocID=%session.Get("LOGON.CTLOCID")
	
	s HospCode=$G(^DHCPESetting("DHCPE","HospitalCode",LocID))

    s ARCIMId=""
    i OEOriId'="" s ARCIMId=$p($g(^OEORD(+OEOriId,"I",$p(OEOriId,"||",2),1)),"^",2)
    s NoCodeItem="^"_$g(^DHCPESetting("DHCPE","NoCodeLabItem"))_"^"
    
    s OEORDRowId=0 
    s OEORDRowId=$O(^OEORD(0,"Adm",AdmId,OEORDRowId))  
    Q:(""=OEORDRowId) ""
    
    s Date=+$H
    s Time=$P($H,",",2)
    
    // OE_OrdItem   医嘱项表
    s OEORIChildsub=0
    s Num=0   //不是自动回传得标本个数
    s ret=""
    s Job=$J
    k ^DHCPETemp(Job,"BarOrdItems")
    k ^xwmTemp("BarOrdItems")
    s Strings=""
    f  s OEORIChildsub=$O(^OEORD(OEORDRowId,"I",OEORIChildsub)) Q:(""=OEORIChildsub)  d
    .s OEORIRowId=OEORDRowId_"||"_OEORIChildsub  //oe_order表 ID
    .s OEORIItemStatDR=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",13)  //检验医嘱状态
    .s OEORIItmMastDR=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",2)  //医嘱ID
    .q:(ARCIMId'="")&&(ARCIMId'=OEORIItmMastDR)
    .Q:(4=OEORIItemStatDR)
    .Q:(quitflag=0)&((1'=OEORIItemStatDR)&(AllowUnPayed'="N"))      // 是否有效医嘱  不管是否接收均可以打印条码 cuilp 2012.2.9
    .S PayFlag="Y"
    .s OEORILabEpisodeNo=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,3)),"^",20)
    .i OEORILabEpisodeNo=$c(0) s OEORILabEpisodeNo=""
    .Q:(""=OEORILabEpisodeNo)   // 只打印有标本号的检验医嘱
    .Q:("1"=$G(^xwmTemp("BarOrdItems",OEORILabEpisodeNo))) 
    .s ^xwmTemp("BarOrdItems",OEORILabEpisodeNo)="1" // 已获取此标本号的项目
    .s ARCIMDesc=""
    .s OEpisNoid=0
    .s ARCIMDesc=..GetARCIMDesc(OEORILabEpisodeNo,OEORDRowId)
    .s PrintNum=$P(ARCIMDesc,$C(1),2)
    .s ARCIMDesc=$P(ARCIMDesc,$C(1),1)
    .s RecLocID=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,3)),"^",6)
    .s RecLoc=""
    .i RecLocID'="" d
    ..s RecLoc=$p($g(^CTLOC(RecLocID)),"^",2)
    ..i $l(RecLoc,"-")>1 s RecLoc=$p(RecLoc,"-",2)
    .s SpecimenType=..GetSpecName(OEORIRowId)
    .s Level=3
    .s:SpecimenType[("血") Level=5
    .s:SpecimenType[("便") Level=1
    .s:SpecimenType[("尿") Level=2
    .i (ARCIMDesc[("糖化血红蛋白"))||(ARCIMDesc[("HbA1C")) s Level=4
    .i HospCode="SYYD" s SpecimenType=##class(web.DHCNurCom).GetLabelDesc(OEORIRowId)
    .i HospCode="BJZYY" d
    ..s SpecimenType=##class(web.DHCPE.OEOrdItem).GetColor(OEORIRowId)
    ..s SpecimenType=SpecimenType_" "_$ZD(+$H,3)
    .;Q:((BDFlag="N")&&($d(^DHCPEDataEx("OEOrderItem","PrintLisRequest",OEORILabEpisodeNo))))  //add by zl
    .Q:((BDFlag="Y")&&('$d(^DHCPEDataEx("OEOrderItem","PrintLisRequest",OEORILabEpisodeNo))))  //add by zl
    .q:ARCIMDesc=""
    .q:(((Level=2)||(Level=1))&&(OrderFlag="2"))
    .q:(((Level=4)||(Level=3)||(Level=5))&&(OrderFlag="1"))
    .;s StationID=$o(^DHCPEST(0,"STORD_ARCIM",OEORIItmMastDR,0))
    .;q:StationID=""
    .;s Sub=$o(^DHCPEST(0,"STORD_ARCIM",OEORIItmMastDR,StationID,0))
    .;s AutoReturn=$p($G(^DHCPEST(StationID,"O",Sub)),"^",6)
    .;s:AutoReturn="N" Num=Num+1
    .s StatOrderDR=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(OEORIItmMastDR,LocID)
    .s StationID=$p(StatOrderDR,"||",1)            //站点ID
    .q:StationID=""
    .s StatOrdSetID=$o(^CF.PE.StationOrderSetI("IdxOfLocOrder"," "_LocID,StatOrderDR,0))
    .i StatOrdSetID'="" s AutoReturn=$lg($g(^CF.PE.StationOrderSetD(StatOrdSetID)),7)
    .q:(AutoReturn="N")&&(HospCode="SHHS")
    .S ^DHCPEDataEx("OEOrderItem","PrintLisRequest",OEORILabEpisodeNo)="Y"  
    .i HospCode'="SHHS" d
    ..s HadStr=$G(^DHCPETempLabEpisodeNo(OEORILabEpisodeNo))
    ..i HadStr'="" d
    ...s HadDate=+HadStr
    ...s HadTime=$p(HadStr,"^",2)
    ...i ((HadDate'="")&&(HadTime'="")) k ^DHCPETempLabEpisodeNo("Date",HadDate,HadTime,OEORILabEpisodeNo)
    ..s ^DHCPETempLabEpisodeNo(OEORILabEpisodeNo)=Date_"^"_Time_"^"_%session.Get("LOGON.USERID")
    ..s ^DHCPETempLabEpisodeNo("Date",Date,Time,OEORILabEpisodeNo)=""
    ..;s ^DHCPETempLabEpisodeScan(OEORILabEpisodeNo)=Date_"^"_Time_"^"_%session.Get("LOGON.USERID")    //add by lxl 20121121
    ..;s ^DHCPETempLabEpisodeScan("Date",Date,Time,OEORILabEpisodeNo)=""         //add by lxl 20121121
    .s placerCode=..GetplacerCode(OEORIRowId)
    .s placerCode=$P(placerCode,"^",2)
    .//s placerCode=..GerExeLocId(OEORIRowId)
    .//i placerCode'=""  s SpecimenType=placerCode
    .s SpecimenType=SpecimenType_"%%"_placerCode_"%%"_placerCodeDesc
    .i HospCode="SHDF"  d
    ..s OneRet=OEORILabEpisodeNo_"^"_SpecimenType_"\!"_ARCIMDesc_"\!"_RecLoc_"@@"
    .e  d
    ..S OneRet=OEORILabEpisodeNo_"^"_SpecimenType_"\!"_ARCIMDesc_"\!"_RecLoc_";"
    .;s iLoop=$I(^DHCPETemp(Job,"BarOrdItems",Level))
    .;s ^DHCPETemp(Job,"BarOrdItems",Level,iLoop)=OneRet
    .f i=1:1:PrintNum  d
    ..s iLoop=$I(^DHCPETemp(Job,"BarOrdItems",Level))
    ..s ^DHCPETemp(Job,"BarOrdItems",Level,iLoop)=OneRet
    
    s Level=0
    f  s Level=$O(^DHCPETemp(Job,"BarOrdItems",Level)) q:Level=""  d
    .s iLoop=0
    .f  s iLoop=$O(^DHCPETemp(Job,"BarOrdItems",Level,iLoop)) q:iLoop=""  d
    ..s OneRet=$G(^DHCPETemp(Job,"BarOrdItems",Level,iLoop))
    ..s ret=ret_OneRet
    
    k ^xwmTemp("BarOrdItems")
    k ^DHCPETemp(Job,"BarOrdItems")
    i HospCode="SHHS" Q ret_"$$"_Num
    q ret
}

ClassMethod GetplacerCode(OEORIRowId)
{
    s placerStr=##Class(web.DHCNurCom).GetSpecContainerCode(OEORIRowId)
    ;s placerCode=$p(placerStr,"^",1)
    s placerColor=$p(placerStr,"^",5) //颜色 
    s placerVolumn=$p(placerStr,"^",4) //容量
    s placerCodeDesc=$p(placerStr,"^",3) //名称 
    i placerVolumn'="" s placerCodeDesc=placerVolumn_"ml"_placerCodeDesc
    q placerColor_"^"_placerCodeDesc

    /*
    s placerCodeDesc=""
    i placerCode="A" s placerCodeDesc="紫管"
    i placerCode="B" s placerCodeDesc="蓝管"
    i placerCode="C" s placerCodeDesc="灰管"
    i placerCode="G" s placerCodeDesc="绿管"
    i placerCode="H" s placerCodeDesc="黑管"
    i placerCode="O" s placerCodeDesc="褐管"
    i placerCode="P" s placerCodeDesc="粉管"
    i placerCode="Q" s placerCodeDesc="橙管"
    i placerCode="R" s placerCodeDesc="红管"
    i placerCode="W" s placerCodeDesc="白管"
    i placerCode="Y" s placerCodeDesc="黄管"
    q placerCode_"^"_placerCodeDesc
    */
}

ClassMethod GerExeLocId(oeoriId) As %String
{
   
    n (oeoriId)
    s retno=""
    s oeordId=$p(oeoriId,"||",1),oeoriSub=$p(oeoriId,"||",2)
    q:oeordId="" retno
    q:'$d(^OEORD(oeordId,"I",oeoriSub,1)) retno
    s arcimId=$p(^OEORD(oeordId,"I",oeoriSub,1),"^",2)
    q:arcimId="" retno
    s arcsub=$p(arcimId,"||",2)
    q:arcsub="" retno
    b ;01
    s excode=""
    s chl="" f  s chl=$o(^ARCIM(+arcimId,arcsub,"EXT",chl)) q:chl=""  d
     .s tod=$p(^ARCIM(+arcimId,arcsub,"EXT",chl),"^",2)
     .q:(tod'="")&(tod<+$h)
     .s excode=$p(^ARCIM(+arcimId,arcsub,"EXT",chl),"^",4)
   q:excode="" retno
   q $e(excode,1,1)
}

/*
ClassMethod GetARCIMDesc(LabNo, OEORDID, LinkStr As %String = "^")
{
    ;w ##class(web.DHPCE.BarPrint).GetARCIMDesc(8010000324,"3363458",",")
    s NoCodeItem="^"_$G(^DHCPESetting("DHCPE","NoCodeLabItem"))_"^"
    s Job=$J
    k ^TempDHCPEArcDesc(Job)
    s ARCIMDesc=""
    s OEpisNoid=0
    s PrintNum=1
   
    f  s OEpisNoid=$O(^OEORD(0,"EpisNo",LabNo,OEORDID,OEpisNoid)) Q:(""=OEpisNoid)  d
    .s OEORIItmMastDR=$p($G(^OEORD(OEORDID,"I",OEpisNoid,1)),"^",2)
    .i $P($G(^OEORD(OEORDID,"I",OEpisNoid,3)),"^",5)'="P"  s PayFlag="N"
    .q:NoCodeItem[OEORIItmMastDR
    .s Stat=$p($G(^OEORD(OEORDID,"I",OEpisNoid,1)),"^",13)
    .q:(4=Stat)
    .s ADMLocDR=$p($G(^OEORD(OEORDID,"I",OEpisNoid,9)),"^",2)
    .;Q:$D(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OEORDID_"||"_OEpisNoid))
    .s ARCIMSubscript=$P(OEORIItmMastDR,"||",1)
    .s ARCIMVersion=$P(OEORIItmMastDR,"||",2)
    .s OneARCIMDesc=##class(web.DHCPE.DHCPECommon).GetArcDesc(OEORIItmMastDR,"A",ADMLocDR)
    .;i OneARCIMDesc["C13"  s PrintNum=2
    .i $d(^DHCPECTDataEx("DHCPEStationOrder","BarPrintNum",OEORIItmMastDR)) d
    ..s PrintNum=$g(^DHCPECTDataEx("DHCPEStationOrder","BarPrintNum",OEORIItmMastDR))

    
    .s STID=$O(^DHCPEST(0,"STORD_ARCIM",OEORIItmMastDR,0))
    .s SortIndex=""
    .i STID'="" d
    ..s Sub=$O(^DHCPEST(0,"STORD_ARCIM",OEORIItmMastDR,STID,0))
    ..s SortIndex=$P(^DHCPEST(STID,"O",Sub),"^",7)
    .s:SortIndex="" SortIndex="999999999"
    
    .s LocInfo=$G(^DHCPEStationOrder("Loc",OEORIItmMastDR))
    .i LocInfo="" d
    ..s LocSort="999999999"
    .e  d
    ..s LocID=$P(LocInfo,"^",1)
    ..s LocSort=$P($g(^DHCPEST(+LocID,"STLOC",$P(LocID,"||",2))),"^",2)
    ..i LocSort="" s LocSort="999999999"
    ..s SortIndex=$P(LocInfo,"^",2)
    .s ^TempDHCPEArcDesc(Job,LocSort,SortIndex,OEORDID_"||"_OEpisNoid)=OneARCIMDesc
    s LocSort=""
    f  s LocSort=$O(^TempDHCPEArcDesc(Job,LocSort)) q:LocSort=""  d
    .s SortIndex=""
    .f  s SortIndex=$O(^TempDHCPEArcDesc(Job,LocSort,SortIndex)) q:SortIndex=""  d
    ..s OEORDItemID=""
    ..f  s OEORDItemID=$O(^TempDHCPEArcDesc(Job,LocSort,SortIndex,OEORDItemID)) q:OEORDItemID=""  d
    ...s OneDesc=$G(^TempDHCPEArcDesc(Job,LocSort,SortIndex,OEORDItemID))
    ...i ARCIMDesc=""  d
    ....s ARCIMDesc=OneDesc
    ....//i ARCIMDesc["C13"   s PrintNum=2
    ...else  d
    ....s ARCIMDesc=ARCIMDesc_LinkStr_OneDesc
    k ^TempDHCPEArcDesc(Job)
    //s ARCIMDesc=$E(ARCIMDesc,1,15)
  
    Q ARCIMDesc_$C(1)_PrintNum
}
*/
ClassMethod GetARCIMDesc(LabNo, OEORDID, LinkStr As %String = "^")
{
    ;w ##class(web.DHPCE.BarPrint).GetARCIMDesc(8010000324,"3363458",",")
    s NoCodeItem="^"_$G(^DHCPESetting("DHCPE","NoCodeLabItem"))_"^"
    s Job=$J
    k ^TempDHCPEArcDesc(Job)
    s ARCIMDesc=""
    s OEpisNoid=0
    s PrintNum=1
   
    f  s OEpisNoid=$O(^OEORD(0,"EpisNo",LabNo,OEORDID,OEpisNoid)) Q:(""=OEpisNoid)  d
    .s OEORIItmMastDR=$p($G(^OEORD(OEORDID,"I",OEpisNoid,1)),"^",2)
    .i $P($G(^OEORD(OEORDID,"I",OEpisNoid,3)),"^",5)'="P"  s PayFlag="N"
    .q:NoCodeItem[OEORIItmMastDR
    .s Stat=$p($G(^OEORD(OEORDID,"I",OEpisNoid,1)),"^",13)
    .q:"4"=Stat
    .s ADMLocDR=$p($G(^OEORD(OEORDID,"I",OEpisNoid,9)),"^",2)
    .;Q:$D(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OEORDID_"||"_OEpisNoid))
    .s ARCIMSubscript=$P(OEORIItmMastDR,"||",1)
    .s ARCIMVersion=$P(OEORIItmMastDR,"||",2)
    .s OneARCIMDesc=##class(web.DHCPE.DHCPECommon).GetArcDesc(OEORIItmMastDR,"A",ADMLocDR)
    .s StatOrderDR=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(OEORIItmMastDR,ADMLocDR)
    .q:StatOrderDR=""
    .s STID=$p(StatOrderDR,"||",1)            //站点ID
    .q:STID=""
    .s StatOrdSetID=$o(^CF.PE.StationOrderSetI("IdxOfLocOrder"," "_ADMLocDR,StatOrderDR,0))
    .i StatOrdSetID'="" d
    ..s PrintNum=$lg($g(^CF.PE.StationOrderSetD(StatOrdSetID)),25)  //打印条码数量
    ..i PrintNum="" s PrintNum=1
    .q:'$d(^DHCPEST(0,"STORD_ARCIM",OEORIItmMastDR,STID))
    .s SOSID=$o(^CF.PE.StationOrderSetI("IdxOfLocOrder"," "_ADMLocDR,StatOrderDR,""))
    .s SortIndex=""
    .//项目顺序
    .i SOSID'="" s SortIndex=$lg($g(^CF.PE.StationOrderSetD(SOSID)),8)
    .s:SortIndex="" SortIndex="999999999"
    .//站点分类顺序
    .s LocSort="999999999"
    .s StatCatID=##class(web.DHCPE.CT.HISUICommon).GetStatCatIDBySTOrderID(StatOrderDR,ADMLocDR)  //站点分类ID
    .i StatCatID'="" d
    ..s StatCatSortID=$o(^CF.PE.StationOrdSortI("IdxOfOrdCatDR",StatCatID,0)) //站点分类顺序ID
    ..i StatCatSortID'="" d
    ...s LocSort=$lg($g(^CF.PE.StationOrdSortD(StatCatSortID)),3) //站点分类顺序
    ...s Sub=$o(^CF.PE.StationOrdSortI("ORD","IdxOfOrderDR",StatOrderDR,StatCatSortID,0))
    ...i Sub'="" s SortIndex=$lg($g(^CF.PE.StationOrdSortD(StatCatSortID,"ORD",Sub)),3) //站点分类项目顺序
    ..e  s SortIndex="999999999"
    .
    .s ^TempDHCPEArcDesc(Job,LocSort,SortIndex,OEORDID_"||"_OEpisNoid)=OneARCIMDesc
    
    s LocSort=""
    f  s LocSort=$O(^TempDHCPEArcDesc(Job,LocSort)) q:LocSort=""  d
    .s SortIndex=""
    .f  s SortIndex=$O(^TempDHCPEArcDesc(Job,LocSort,SortIndex)) q:SortIndex=""  d
    ..s OEORDItemID=""
    ..f  s OEORDItemID=$O(^TempDHCPEArcDesc(Job,LocSort,SortIndex,OEORDItemID)) q:OEORDItemID=""  d
    ...s OneDesc=$G(^TempDHCPEArcDesc(Job,LocSort,SortIndex,OEORDItemID))
    ...i ARCIMDesc=""  d
    ....s ARCIMDesc=OneDesc
    ...else  d
    ....s ARCIMDesc=ARCIMDesc_LinkStr_OneDesc
    k ^TempDHCPEArcDesc(Job)
  
    Q ARCIMDesc_$C(1)_PrintNum
}

/// w ##class(web.DHCPE.BarPrint).GetLisItemInfo("200735","","Ris","N")
ClassMethod GetLisItemInfo(AdmIds, OEOriId, Type As %String = "Lis", BDFlag As %String = "N")
{

    q:AdmIds="" ""
    s Length=$l(AdmIds,"^")
    s Return=""
    s ret=""
    s ARCIMId=""
    s RecLoc=""
    i OEOriId'=""
    {
        s ARCIMId=$p(^OEORD(+OEOriId,"I",$p(OEOriId,"||",2),1),"^",2)
        s RecLoc=$p(^OEORD(+OEOriId,"I",$p(OEOriId,"||",2),3),"^",6)
    }
    i Type="Lis"{
        f j=1:1:Length
        {
            s Flag=0
            s AdmId=$p(AdmIds,"^",j)
            s OEORDRowId=0 
        
            s OEORDRowId=$O(^OEORD(0,"Adm",AdmId,OEORDRowId))
            s PatInfo=..GetPatInfo(AdmId)
            s $p(PatInfo,"^",7)=$ZD(+$H,3)
            Q:(""=OEORDRowId)
            s Oneret=""
            k ^DHCPETemp("GetLisData",$j)
            s OEORIChildsub=0
            f  s OEORIChildsub=$O(^OEORD(OEORDRowId,"I",OEORIChildsub)) Q:(""=OEORIChildsub)  d
            .s OneString=""
            .s OEORIRowId=OEORDRowId_"||"_OEORIChildsub
            .q:(OEOriId'="")&&(OEOriId'=OEORIRowId)
            .;Q:((""'=OEOriId)&(OEOriId'=OEORIRowId))
            .s OEORIItemStatDR=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",13)
            .Q:(1'=OEORIItemStatDR)     // 是否有效医嘱
            .//OEORI_LabEpisodeNo
            .s OEORILabEpisodeNo=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,3)),"^",20)
            .i OEORILabEpisodeNo=$c(0) s OEORILabEpisodeNo=""
            .Q:(""=OEORILabEpisodeNo)   // 只打印有标本号的检验医嘱
            .q:$D(^DHCPETemp("GetLisData",$j,OEORILabEpisodeNo))
            .s OEpisNoid=""
            .s ARCIMDesc=""
            .s OEpisNoid=0
            .f  s OEpisNoid=$O(^OEORD(0,"EpisNo",OEORILabEpisodeNo,OEORDRowId,OEpisNoid)) q:OEpisNoid=""  d
            ..s OEORIRowId=OEORDRowId_"||"_OEpisNoid
            
            ..q:(BDFlag="Y")&&('$d(^DHCPEDataEx("OEOrderItem","PrintRequest",OEORIRowId)))
            ..q:(BDFlag="N")&&($d(^DHCPEDataEx("OEOrderItem","PrintRequest",OEORIRowId)))
            ..s OEORIItmMastDR=$p($G(^OEORD(OEORDRowId,"I",OEpisNoid,1)),"^",2)
            ..s Stat=$p($G(^OEORD(OEORDRowId,"I",OEpisNoid,1)),"^",13)
            ..Q:(1'=Stat)       // 是否有效医嘱
            ..q:(ARCIMId'="")&&(OEORIItmMastDR'=ARCIMId)
            ..s Price=..GetFactAmountByOEID(OEORIRowId)
            ..//##class(web.DHCPE.Handle.ARCItmMast).GetItmPrice(OEORIItmMastDR)
            ..// ARC_ItmMast.{ARCIM_Desc}
            ..s ARCIMSubscript=$P(OEORIItmMastDR,"||",1)
            ..s ARCIMVersion=$P(OEORIItmMastDR,"||",2)
            ..s FeeType=..GetFeeTypeByOEItem(OEORIRowId)
            ..s ARCIMDesc=$P($G(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)
            ..s ARCIMDesc="("_FeeType_")"_ARCIMDesc
            ..s StationID=$o(^DHCPEST(0,"STORD_ARCIM",OEORIItmMastDR,0))
            ..q:StationID=""
            ..s Sub=$o(^DHCPEST(0,"STORD_ARCIM",OEORIItmMastDR,StationID,0))
            ..s AutoReturn=$p($G(^DHCPEST(StationID,"O",Sub)),"^",6)
            ..;q:AutoReturn="Y"
            ..s RecLocID=$p($G(^OEORD(OEORDRowId,"I",OEpisNoid,3)),"^",6)
            ..s RecLoc=""
            ..i RecLocID'="" d
            ...s RecLoc=$p(^CTLOC(RecLocID),"^",2)
            ..s RecLoc=$p(RecLoc,"-",2)
            ..s SpecimenType=..GetSpecName(OEORDRowId_"||"_OEpisNoid)
            ..i OneString="" d
            ...s OneString=OEORILabEpisodeNo_"^"_SpecimenType_"^"_ARCIMDesc_"^"_RecLoc_"^"_Price
            ..e  d
            ...s OneString=OneString_$C(3)_OEORILabEpisodeNo_"^"_SpecimenType_"^"_ARCIMDesc_"^"_RecLoc_"^"_Price
            ..s ^DHCPEDataEx("OEOrderItem","PrintRequest",OEORIRowId)="Y"
            .q:OneString=""
            .s ^DHCPETemp("GetLisData",$j,OEORILabEpisodeNo)=""
            .i Oneret ="" d
            ..s Oneret=OneString
            .e  d
            ..s Oneret=Oneret_$C(1)_OneString
            i Oneret '="" d
            .s Oneret=PatInfo_$C(4)_Oneret
            i Oneret '="" d
            .i ret="" d
            ..s ret=Oneret
            .e  d
            ..s ret=ret_$C(2)_Oneret
            
            k ^DHCPETemp("GetLisData",$j)
            //q:ret=""
            //i Return="" d
            //.s Return=ret
            //e  d
            //.s Return=Return_"&&"_ret
            
        }
    }
    elseif Type="PrintBJ"
    {
        s LabStations="^"_$G(^DHCPESetting("DHCPE","StationId_Other"))_"^"
        f j=1:1:Length
        {
            s AdmId=$p(AdmIds,"^",j)
            s PatInfo=..GetPatInfo(AdmId)
            s $p(PatInfo,"^",7)=$ZD(+$H,3)
            s IAdm=$o(^DHCPEIADM(0,"PAADM",AdmId,0))
            continue:IAdm=""
            s PreIAdm=$p(^DHCPEIADM(IAdm),"^",4)
            continue:PreIAdm=""
            s OEORDRowId=0 
    
            s OEORDRowId=$O(^OEORD(0,"Adm",AdmId,OEORDRowId))
            Q:(""=OEORDRowId)
            s Oneret=""
            
            s OEORIChildsub=0
            f  s OEORIChildsub=$O(^OEORD(OEORDRowId,"I",OEORIChildsub)) Q:(""=OEORIChildsub)  d
            .s OEORIRowId=OEORDRowId_"||"_OEORIChildsub
            .
            .s OEORIItemStatDR=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",13)
            .Q:(1'=OEORIItemStatDR)     // 是否有效医嘱
            .//OEORI_LabEpisodeNo
            .s OEORILabEpisodeNo=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,3)),"^",20)
            .i OEORILabEpisodeNo=$c(0) s OEORILabEpisodeNo=""
            .s OEORIItmMastDR=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",2)
            .q:((OEORILabEpisodeNo'="")&&($G(^DHCPETempLabEpisodeNo(OEORILabEpisodeNo))'=""))
            .s Price=..GetFactAmountByOEID(OEORIRowId)
            .//##class(web.DHCPE.Handle.ARCItmMast).GetItmPrice(OEORIItmMastDR)
            .s Station="^"_$o(^DHCPEST(0,"STORD_ARCIM",OEORIItmMastDR,0))_"^"
            .q:(LabStations[Station)||(Station="^^")
            .// ARC_ItmMast.{ARCIM_Desc}
            .s ARCIMSubscript=$P(OEORIItmMastDR,"||",1)
            .s ARCIMVersion=$P(OEORIItmMastDR,"||",2)
            .s ARCIMDesc=$P($G(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)
            .s OneItemRet=ARCIMDesc_"^"_OEORILabEpisodeNo_"^"_Price
            .i Oneret=""  d
            ..s Oneret=OneItemRet
            .e  d
            ..s Oneret=Oneret_$C(2)_OneItemRet
            i Oneret'=""  d
            .s Oneret=PatInfo_$C(1)_Oneret
            i Oneret'="" d
            .i ret="" d
            ..s ret=Oneret
            .e  d
            ..s ret=ret_$C(0)_Oneret
            
        }
    }
    else
    {
        i Type="Ris" d
        .s LabStations="^"_$G(^DHCPESetting("DHCPE","StationId_Ris"))_"^"
        e  d
        .s LabStations="^"_$G(^DHCPESetting("DHCPE","StationId_Other"))_"^"
                
        f j=1:1:Length
        {   
            s AdmId=$p(AdmIds,"^",j)
            k ^TempDHCPERisRequest("RecLocID",AdmId)
            s PatInfo=..GetPatInfo(AdmId)
            s $p(PatInfo,"^",7)=$ZD(+$H,3)
            s IAdm=$o(^DHCPEIADM(0,"PAADM",AdmId,0))
            continue:IAdm=""
            s PreIAdm=$p(^DHCPEIADM(IAdm),"^",4)
            continue:PreIAdm=""
            s OEORDRowId=0 
    
            s OEORDRowId=$O(^OEORD(0,"Adm",AdmId,OEORDRowId))
            Q:(""=OEORDRowId)
            s RecLocID=0
            s OneRet=""
            f  s RecLocID=$o(^OEORDi(0,"RecDepOrd",OEORDRowId,RecLocID)) q:RecLocID=""  d
            .q:((RecLoc'="")&&(RecLoc'=RecLocID))
            .s RecLocDesc=$p(^CTLOC(RecLocID),"^",2)
            .s RecLocDesc=$p(RecLocDesc,"-",2)
            .s Sub=0
            .s ARCIMStrs=""
            .f  s Sub=$o(^OEORDi(0,"RecDepOrd",OEORDRowId,RecLocID,Sub)) q:Sub=""  d
            ..s OEORIRowId=OEORDRowId_"||"_Sub
            ..//w !,OEORIRowId
            ..s Type=0
            ..q:(BDFlag="Y")&&('$d(^DHCPEDataEx("OEOrderItem","PrintRequest",OEORIRowId)))
            ..q:(BDFlag="N")&&($d(^DHCPEDataEx("OEOrderItem","PrintRequest",OEORIRowId)))
            ..Q:((""'=OEOriId)&(OEOriId'=OEORIRowId))
            ..s OEORIItemStatDR=$p($G(^OEORD(OEORDRowId,"I",Sub,1)),"^",13)
            ..Q:(1'=OEORIItemStatDR)        // 是否有效医嘱
            ..s ARCIMID=$p(^OEORD(+OEORDRowId,"I",Sub,1),"^",2)
            ..s ARCIMDesc=$P($G(^ARCIM(+ARCIMID,$p(ARCIMID,"||",2),1)),"^",2)
            ..s FeeType=..GetFeeTypeByOEItem(OEORIRowId)
            ..;S FeeType=##class(web.DHCPE.Query.PreItemList).judgeFeeType(PreIAdm,OEORDRowId,Sub)
            ..s ARCIMDesc="("_FeeType_")"_""_ARCIMDesc
            ..s Price=..GetFactAmountByOEID(OEORIRowId)
            ..//##class(web.DHCPE.Handle.ARCItmMast).GetItmPrice(ARCIMID)
            ..s Station="^"_$o(^DHCPEST(0,"STORD_ARCIM",ARCIMID,0))_"^"
            ..q:(LabStations'[Station)||(Station="^^")
            ..//i (ARCIMID="12||1")||(ARCIMID="12||2")  s Type=1
            ..s ^TempDHCPERisRequest("RecLocID",AdmId,RecLocID,Type)=$G(^TempDHCPERisRequest("RecLocID",AdmId,RecLocID,Type))_$C(4)_ARCIMDesc_"^"_Price
            ..s ^DHCPEDataEx("OEOrderItem","PrintRequest",OEORIRowId)="Y"
            
            s RecLocID=0
            f  s RecLocID=$O(^TempDHCPERisRequest("RecLocID",AdmId,RecLocID))  q:RecLocID=""  d
            .s RecLocDesc=$p(^CTLOC(RecLocID),"^",2)
            .s RecLocDesc=$p(RecLocDesc,"-",2)
            .s Type=""
            .f  s Type=$O(^TempDHCPERisRequest("RecLocID",AdmId,RecLocID,Type)) q:Type=""  d
            ..s Data=$G(^TempDHCPERisRequest("RecLocID",AdmId,RecLocID,Type))
            ..//w !,RecLocID_"^"_Type_"^"_Data
            ..i OneRet="" d
            ...s OneRet=RecLocDesc_$C(3)_Data
            ..e  d
            ...s OneRet=OneRet_$C(2)_RecLocDesc_$C(3)_Data
            ..//w !,OneRet
            
            i OneRet'="" d
            .s OneRet=PatInfo_$C(1)_OneRet
            i OneRet'="" d
            .i ret="" d
            ..s ret=OneRet
            .e  d
            ..s ret=ret_$c(5)_OneRet
            
        }
    }
    
    Q ret
}

ClassMethod GetPatInfo(PAAdmRowid)
{
    new ret
    s (Name,Age,SexDRName,PAPMINo,DepLoc,GName,AdmDate)=""
    // DHC_PE_IADM.{ IADM_RowId }
    s IADMDR=$O(^DHCPEIADM(0,"PAADM",PAAdmRowid,0))
    i IADMDR'="" d
    .s CurData=$G(^DHCPEIADM(IADMDR))
    .// DHC_PE_IADM.{ IADM_AdmDate } 体检日期
    .s AdmDate=$P(CurData,"^",5)
    .s:(""'=AdmDate) AdmDate=$ZD(AdmDate,3)
    
    .// DHC_PE_IADM.{ IADM_CRMADM } = DHC_PE_PreIADM.{ PIADM_RowId }
    .s PIADMDR=$P(CurData,"^",4)
    .i PIADMDR'="" d
    ..s CurData=$G(^DHCPEPreIADM(PIADMDR))
    ..// DHC_PE_PreIADM.{ PIADM_PIBI_DR } = DHC_PE_PreIBaseInfo.{  }
    ..s PIBIDR=$P(CurData,"^",1)
    ..s GADM=$P(CurData,"^",2)
    ..s GTeam=$P(CurData,"^",3)
    ..i PIBIDR'="" d
    ...s CurData=$G(^DHCPEPreIBI(PIBIDR))
    ...// PIBI_PAPMINo      登记号
    ...s PAPMINo=$p(CurData,"^",1)
    ...s Position=$P(CurData,"^",11)
    ...i Position'="" s Position="("_Position_")"
    ..i GADM'="" d
    ...s GBaseInfo=$P(^DHCPEPreGADM(GADM),"^",1)
    ...i GBaseInfo'="" d
    ....s GName=$p(^DHCPEPreGBI(GBaseInfo),"^",2)
    ....s GName="单位:"_GName_Position
    ..i GTeam'="" d
    ...s Char=##class(web.DHCPE.PreIADM).NumToChar($p(GTeam,"||",2))
    ...s SortNo=Char_$G(^DHCPEDataEx("DHCPEPreIADM","GTEAM","IADM",PIADMDR))
    ...s GTeam=$p(^DHCPEPreGADM(+GTeam,"Team",$p(GTeam,"||",2)),"^",1)
    ...s GTeam="  分组:"_GTeam
    ...s GName=GName_GTeam
    ..i PIBIDR'="" d
        
    ...// PIBI_Name 姓名
    ...s Name=$p(CurData,"^",2)
    
    ...// PIBI_Sex_DR = CT_Sex.{}   性别
    ...s SexDR=$p(CurData,"^",3)
    ...s:(""'=SexDR) SexDRName=$p(^CT("SEX",SexDR),"^",2)
    
    ...// PIBI_DOB      出生日期
    ...s Dob=$p(CurData,"^",4)
    ...i Dob'="" s PAPERDob=$ZD(Dob,3)
    ...// 年龄 
    ...s Age=""
    ...s:(""'=Dob) Age=##class(web.DHCLCNUREXCUTE).CalAge(Dob,+$h)
    ...s Age=$P(Age,"Y")
    ...s Age=Age_"岁"
    s DepLoc=%session.Get("LOGON.CTLOCID")
    i DepLoc'="" d
    .s DepLoc=$P(^CTLOC(DepLoc),"^",2)
    s DepLoc=$p(DepLoc,"-",2)
    s ret=Name_"^"_Age_"^"_SexDRName_"^"_PAPMINo_"^"_DepLoc_"^"_GName_"^"_AdmDate_"^"_$G(SortNo)
    q ret
}

/*
ClassMethod GetSpecName(OeorId)
{
    //取标本类型
    s namespaceLab=^DHCPESetting("NAMESPACE","LABDATA")
    s paorder=$P(OeorId,"||",1) // OE_Order.{OEORD_RowId}
    s itemsub=$P(OeorId,"||",2) // OE_OrdItem.{OEORI_Childsub}
    s SPECChildsub=0
    s SPECDesc="",tempSPECCode="",tempSPECDesc=""
    i $d(^OEORD(paorder,"I",itemsub,"SPEC",SPECChildsub))'=0 d
    s SPECChildsub=0 f  s SPECChildsub=$o(^OEORD(paorder,"I",itemsub,"SPEC",SPECChildsub)) q:SPECChildsub=""  d
    .s tempSPECCode=$g(^OEORD(paorder,"I",itemsub,"SPEC",SPECChildsub))
    .s tempSPECCode=$p(tempSPECCode,"^",1)
    .s tempSPECDesc=$p($G(^[namespaceLab]TTAB("SPEC",tempSPECCode)),"\",1)
    .i SPECDesc="" s SPECDesc=tempSPECDesc
    .e  s SPECDesc=SPECDesc_","_tempSPECDesc
    
    q $G(SPECDesc)
}*/
/// ##class(web.DHCPE.BarPrint).GetSpecName(OeorId)
ClassMethod GetSpecName(OeorId)
{
    //取标本类型
    s PAADM=$p($g(^OEORD($P(OeorId,"||",1))),"^",1)
	s LocID=$P($g(^PAADM(PAADM)),"^",4)
	
	s HOSPID=##class(web.DHCPE.CT.DHCPEMappingLoc).GetHospIDByLocID(LocID) //根据科室找院区
 	s HOSPCode=$p($g(^CT("HOSP",HOSPID)),"^",1)
 	S HOSPCode=$$ALPHAUP^SSUTIL4(HOSPCode)
 	//s btHOSPID=$o(^dbo.BTHospitalI("IndexCode"," "_HOSPCode,0))
    s btHOSPID=$o(^dbo.BTHospitalI("IndexCode",##class(web.DHCPE.DHCPECommon).LisIndexData(HOSPCode),0))
	
	//取标本类型
	s LisNewVersion=$g(^DHCPESetting("DHCPE","LisNewVersion",LocID))
	s namespaceLab=$g(^DHCPESetting("NAMESPACE","LABDATA",LocID))

    s paorder=$P(OeorId,"||",1)
    s itemsub=$P(OeorId,"||",2) 
    s SPECChildsub=0
    s SPECDesc="",tempSPECCode="",tempSPECDesc=""
    
    s SPECChildsub=0 
    f  s SPECChildsub=$o(^OEORD(paorder,"I",itemsub,"SPEC",SPECChildsub)) q:SPECChildsub=""  d
    .s tempSPECCode=$g(^OEORD(paorder,"I",itemsub,"SPEC",SPECChildsub))
    .s tempSPECCode=$p(tempSPECCode,"^",1)
    .s tempSPECDesc=""
    .i LisNewVersion="Y" d
    ..;s SpecID=$O(^dbo.BTSpecimenI("IndexCode",1," "_tempSPECCode,0))
    ..;S SpecID=$O(^dbo.BTSpecimenI("IndexCode",btHOSPID," "_tempSPECCode,0)) //索引按照检验的院区区分
    ..S SpecID=$O(^dbo.BTSpecimenI("IndexCode",btHOSPID,##class(web.DHCPE.DHCPECommon).LisIndexData(tempSPECCode),0)) //索引按照检验的院区区分
    ..q:SpecID=""
    ..s tempSPECDesc=$LG(^dbo.BTSpecimenD(SpecID),3)
    .e  d
    ..s tempSPECDesc=$p($g(^[namespaceLab]TTAB("SPEC",tempSPECCode)),"\",1)
    .i SPECDesc="" d
    ..s SPECDesc=tempSPECDesc
    .e  d
    ..s SPECDesc=SPECDesc_","_tempSPECDesc
    
    q $G(SPECDesc)
}

ClassMethod SerchSpecNameClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SerchSpecNameExecute ]
{
    Set repid=$LIST(qHandle,2)
     Kill ^CacheTemp(repid)
     Quit $$$OK
}

ClassMethod SerchSpecNameExecute(ByRef qHandle As %Binary, arcim As %String = "", LocID As %String = "") As %Status
{
    
    Set repid=$I(^CacheTemp)
    s ind=1
    if ($g(arcim)="")
    {
        Set qHandle=$lb(0,repid,0)
        Quit $$$OK
    }
  
    s LisNewVersion=$g(^DHCPESetting("DHCPE","LisNewVersion",LocID))
    s arcos=##class(web.DHCPE.PEApp).GetArcSets("", arcim)
    
    s TrakVerison=$g(^DHCPESetting("DHCPE","TrakVerison"))
    i TrakVerison="" s TrakVerison="TrakCare"

	s LabData=$G(^DHCPESetting("NAMESPACE","LABDATA",LocID))
    s ExtCode=""
    
    i TrakVerison="TrakCare" d
    .Quit:$g(arcim)=""
    .Quit:'$d(^ARCIM(+arcim,1,"EXT"))
    .Set Ext=$o(^ARCIM(+arcim,1,"EXT",0))
    .Quit:$g(Ext)=""
    .Set ExtCode=$p(^ARCIM(+arcim,1,"EXT",Ext),"^",4)
 
    i "MedTrak"=TrakVerison d
    .Quit:$g(arcos)=""
    .s ExtCode=$P($G(^ARCOS(arcos)), "^", 11)
        b ;ExtCode
    if ($g(ExtCode)="")
    {
        Set qHandle=$lb(0,repid,0)
        Quit $$$OK
    }
 
    if (LisNewVersion="Y"){
        s ret=##class(web.DHCDocOrderCommon).GetSpecimenByTestset(ExtCode,"")
        s lenthArr=$L(ret,$C(2))
        for i=1:1:lenthArr d
        .s Specimendr=$p($P(ret,$C(2),i),$c(3),1)
        .s SPECDesc=$p($P(ret,$C(2),i),$c(3),2)
        .s Specimenflag=""
        .d FindBuild
        
    }ELSE{
    Set Specimendr=""
    For  Set Specimendr=$o(^[LabData]TTAB("TS",ExtCode,1,Specimendr)) Q:(Specimendr="")  Do
    .Set Container=$o(^TTAB("TS",ExtCode,1,Specimendr,""))
    .i Container="" d
    ..Set Specimenflag=$p(^TTAB("TS",ExtCode,1,Specimendr),"\",1)
    .e  d
    ..Set Specimenflag=$g(^TTAB("TS",ExtCode,1,Specimendr,Container))
    .s SPECDesc=$p(^[LabData]TTAB("SPEC",Specimendr),"\",1)
    .d FindBuild
    
    }
        
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
FindBuild      
    set Data=$lb(Specimendr,SPECDesc,Specimenflag)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

ClassMethod SerchSpecNameFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SerchSpecNameExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    //
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

/// d ##class(%ResultSet).RunQuery("web.DHCPE.BarPrint","SerchSpecName","3060||1")
Query SerchSpecName(ItemID As %String = "", LocID As %String = "") As %Query(ROWSPEC = "TSpecCode:%String:代码,TSpceName:%String:名称,TDefault:%String:默认")
{
}

/// 获得体检报告封面信息  前台调用
/// w ##class(web.DHCPE.BarPrint).GetReportCover("310076")
ClassMethod GetReportCover(IADMDR As %Library.String = "")
{
   q:IADMDR=""
    s ret="" 
    S PAADM=$p($G(^DHCPEIADM(IADMDR)),"^",1)
	s LocID=$P($G(^PAADM(PAADM)),"^",4)
	//s HosCode=$G(^DHCPESetting("DHCPE","HospitalCode"))
	s HosCode=$G(^DHCPESetting("DHCPE","HospitalCode",LocID))

    s (AddItem,OrdSetsDesc,Name,PAPMINo,AdmDate,Tel,Company,SexName,GDesc,ReportDate,MedicalCode)=""
    i IADMDR'="" d
    .s CurData=$G(^DHCPEIADM(IADMDR))
    .s AdmDate=$P(CurData,"^",5)
    .s:(""'=AdmDate) AdmDate=$ZD(AdmDate,3)
    .s PIADMDR=$P(CurData,"^",4)
    .i PIADMDR'="" d
    ..s OrdSetsDesc=##class(web.DHCPE.Query.IAdmItemStatus).GetArcSetDesc(PIADMDR)
    ..s ReportDate=$G(^DHCPEDataEx("DHCPEPreIADM","GetReportDateTime","I",PIADMDR))
    ..i ReportDate'="" s ReportDate=$ZD(+ReportDate,3)
    ..s CurData=$G(^DHCPEPreIADM(PIADMDR))
    ..s GADM=$p(CurData,"^",2)
    ..s Position=$p(^DHCPEPreIBI($p(CurData,"^",1)),"^",11)
    ..s TAge=$p(^DHCPEPreIBI($p(CurData,"^",1)),"^",4)
    ..i TAge'="" s TAge=$P(##class(web.DHCLCNUREXCUTE).CalAge(TAge,+$H),"Y",1) //$P(##class(web.DHCLCNUREXCUTE))
    ..i GADM'=""  d 
    ...s GBIDR=$P(^DHCPEPreGADM(GADM),"^",1)
    ...s GDesc=$p(^DHCPEPreGBI(GBIDR),"^",2)
    ...s GDesc="团体:"_GDesc
    ...s ReportDate="统取"
    ..e  d
    ...s GDesc="单位:个人"
    ..s PIBIDR=$p(CurData,"^",1)
    ..i PIBIDR'="" d
    ...s CurData=$G(^DHCPEPreIBI(PIBIDR))
    ...s PAPMINo=$p(CurData,"^",1)
    ...
    ...i ""'=PAPMINo  s PAPMINo=##class(web.DHCPE.DHCPECommon).RegNoMask(PAPMINo) //$Extract("00000000",1,8-$LENGTH(PAPMINo))_PAPMINo
    ...s Name=$p(CurData,"^",2)
    ...s SexDR=$p(CurData,"^",3)
    ...If (""'=SexDR)  Do       
    ....s SexName=$p($G(^CT("SEX",SexDR)),"^",2)
    ...i HosCode="AZ"  do
    ....s Name=Name_"   "_SexName_"  "_PAPMINo
    ...s Tel1=$p(CurData,"^",6)
    ...s:(""'=Tel1) Tel=Tel1
    ...s Mobile=$p(CurData,"^",8)
    ...s:(""'=Mobile) Tel=Mobile               //5     6          7             8           9        10
    ..s ItemSub=""
    ..f  s ItemSub=$O(^DHCPEPreIADM(PIADMDR,"ORDITEM",ItemSub)) q:ItemSub=""  d
    ...s Stat=$p($g(^DHCPEPreIADM(PIADMDR,"ORDITEM",ItemSub)),"^",16)
    ...q:Stat'="1"
    ...s ARCIMDR=$p(^DHCPEPreIADM(PIADMDR,"ORDITEM",ItemSub),"^",1)
    ...s STRowId=$O(^DHCPEST(0,"STORD_ARCIM",ARCIMDR, 0))
    ...Q:(""=STRowId)
    ...s ARCIMDesc=##class(web.DHCPE.DHCPECommon).GetArcDesc(ARCIMDR)
    ...s ARCIMDesc=$p(ARCIMDesc,"(",1)
    ...;Q:STRowId=$G(^DHCPESetting("DHCPE","StationId_Other"))
    ...Q:STRowId=$G(^DHCPESetting("DHCPE","StationId_Other",LocID))
    ...s CrmSets=$p(^DHCPEPreIADM(PIADMDR,"ORDITEM",ItemSub),"^",2)
    ...i CrmSets="" d
    ....i AddItem=""  d
    .....s AddItem=ARCIMDesc
    ....e  d
    .....s AddItem=AddItem_"、"_ARCIMDesc
    ..s paadm=$p($G(^DHCPEIADM(IADMDR)),"^",1)
    ..s pttype=$P($g(^PAADM(paadm)),"^",2)
    ..;s MedicalCode=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(paadm,pttype,.ErrMsg)
    
    s PatMasID=$O(^PAPERi("PAPMI_PatNo",PAPMINo,0))
    s:PatMasID'="" MedicalCode=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(PatMasID,"O","",.ErrMsg)  // $P(^PAPER(PatMasID,"PAT",1),"^",22)
    s ret="^"_Name_"^"_PAPMINo_"^"_AdmDate_"^"_Tel_"^"_SexName_"^"_GDesc_"^"_ReportDate_"^"_TAge_"^"_Position_"^"_OrdSetsDesc_"^"_AddItem_"^"_MedicalCode
    q ret
}

ClassMethod GetIADM(PAAdmRowid As %Library.String = "")
{
   s ret=""
    q:PAAdmRowid=""
    s len=$l(PAAdmRowid,"^")
    for i=1:1:len d
    .s PAAdm=$p(PAAdmRowid,"^",i)
    .s IADMDR=""
    .s IADMDR=$O(^DHCPEIADM(0,"PAADM",PAAdm,0))
    .i ret=""  s ret=IADMDR
    .e   s ret=ret_"^"_IADMDR

    q ret
}

// 打印心电图

ClassMethod GetInfo(Instring)
{
   
   s name=$p(Instring,"^",2)
   s paadm=$p(Instring,"^",1)
   s ret=""
   s str=""
   s date=+$h
   i date'=""  s date=$zd(date,3)
   s PAPMIDR=$p($g(^PAADM(paadm)),"^",1 )
   s sexdr=$p(^PAPER(PAPMIDR,"ALL"),"^",7)
   if (""'=sexdr)  do
   .s CTSEXdesc=$p(^CT("SEX",sexdr),"^",2) 
   s IADMDR=0
   f  s IADMDR=$o(^DHCPEIADM(0,"PAADM",paadm,IADMDR))  q:IADMDR=""  d 
    .s CurData=$G(^DHCPEIADM(IADMDR))
    .s AdmDate=$P(CurData,"^",5)
    .s:(""'=AdmDate) AdmDate=$ZD(AdmDate,3)
    .s PIADMDR=$P(CurData,"^",4)
    .i PIADMDR'="" d
    ..s CurData=$G(^DHCPEPreIADM(PIADMDR))
    ..s PIBIDR=$P(CurData,"^",1)
    ..i PIBIDR'="" d
    ...s CurData=$G(^DHCPEPreIBI(PIBIDR))
    ...s PAPMINo=$p(CurData,"^",1)
    ...i ""'=PAPMINo  s PAPMINo=##class(web.DHCPE.DHCPECommon).RegNoMask(PAPMINo)
    ...s str="^"_name_"^"_PAPMINo_"^"_AdmDate
    q str
}

ClassMethod CheckHasPayed(OEORIRowId)
{
    s CrmOrdRowid=$o(^DHCPECRMO(0,"OEORI",OEORIRowId,0))
    if CrmOrdRowid="" q "NP"
    q $p($g(^DHCPECRMO(CrmOrdRowid)),"^",4)
}

/// w ##class(web.DHCPE.BarPrint).SaveSpecCollect("L00032117")
ClassMethod SaveSpecCollect(SpecNo, UserId, LogLocID)
{
    
    s OEORD=$o(^OEORD(0,"EpisNo",SpecNo,0))
    q:OEORD="" "输入的检验号不正确"
    s Date=+$H
    s Time=$p($H,",",2)
    s PAADM=$P($G(^OEORD(OEORD)),"^",1)
    q:PAADM="" "不是体检的检验号"
    s HadDate=""
    s HadTime=""
    s HadStr=$G(^DHCPETempLabEpisodeScan(SpecNo)) 
    i HadStr'="" d
    .s HadDate=+HadStr
    .s HadTime=$p(HadStr,"^",2)
    .//i ((HadDate'="")&&(HadTime'="")) k ^DHCPETempLabEpisodeScan("Date",HadDate,HadTime,SpecNo) 
    q:((HadDate'="")&&(HadTime'="")) "该标本已采集"
    s ^DHCPETempLabEpisodeScan(SpecNo)=Date_"^"_Time_"^"_UserId
    s ^DHCPETempLabEpisodeScan("Date",Date,Time,SpecNo)=""
    d ..SaveCollectInfo(SpecNo,UserId, LogLocID)
    d ##class(web.DHCPE.AdmRecordManager).Insert(PAADM,"A","SpecCollect",UserId,SpecNo)
    q 0
}

// 记录采样时间、采样人   

/*
ClassMethod SaveCollectInfo(SpecNo, UserId)
{
    s $ZT="SaveCollectInfoErr"
    s OrdRowIdStr=##class(web.DHCNurSpecerNo).GetOrderStr(SpecNo)
    q:OrdRowIdStr="" "未获取到该标本号对应的医嘱信息"
    s ret=##class(web.DHCNurSpecerNo).UpdateSpacer(OrdRowIdStr,UserId)
    d ##class(web.DHCPE.CRM.RisGateway).SendRequestInfo(OrdRowIdStr)
    q ""
SaveCollectInfoErr
    q ""
}
*/
/// 记录采样时间、采样人   
/// d ##class(web.DHCPE.BarPrint).SaveCollectInfo("68",1)
ClassMethod SaveCollectInfo(SpecNo, UserId, LocID)
{
    n (SpecNo,UserId,LocID)
    s $ZT="SaveCollectInfoErr"
    
    s Date=+$H
    s Time=$P($H,",",2)
    s SQLCODE=0
    s OEORD=""
    f  s OEORD=$o(^OEORD(0,"EpisNo",SpecNo,OEORD))  q:(OEORD="")||(SQLCODE'=0)  d
    .s OESub=0
    .f  s OESub=$o(^OEORD(0,"EpisNo",SpecNo,OEORD,OESub))  q:(OESub="")||(SQLCODE'=0)  d
    ..s ESub=$o(^OEORD(OEORD,"I",OESub,"X",0))
    ..s OrdID=OEORD_"||"_OESub
    ..i ESub="" d
    ...k PLIST
    ...s PLIST(0)=OrdID
    ...s PLIST(26)=$p($g(^OEORD(OEORD,"I",OESub,1)),"^",9)  ;OEORE_ExStDate
    ...s PLIST(27)=$p($g(^OEORD(OEORD,"I",OESub,1)),"^",10) ;OEORE_ExStTime
    ...s PLIST(41)=0
    ...s PLIST(43)="TB"
    ...&sql(insert into Sqluser.OE_OrdExec Values PLIST())
    ...q:SQLCODE'=0
    ...&SQL(Update SQLUser.OE_OrdExecExt set OEORE_SpecCollUser_DR=:UserId,OEORE_SpecCollDate=:Date,OEORE_SpecCollTime=:Time where OEORE_OEORI_ParRef=:OrdID)
    ..e  d
    ...&SQL(Update SQLUser.OE_OrdExecExt set OEORE_SpecCollUser_DR=:UserId,OEORE_SpecCollDate=:Date,OEORE_SpecCollTime=:Time where OEORE_OEORI_ParRef=:OrdID)
    ..q:SQLCODE'=0
    ..s flag=##class(web.DHCPE.Service.DHCPEOutInterface).UpdatePTBloodInfo(OrdID,LocID)
    ..i flag'="" goto SaveCollectInfoErr
    
    ;b ;SQLCODE
    //s ret=##class(web.DHCNurSpecerNo).UpdateSpacer(OrdRowIdStr,UserId)
    //d ##class(web.DHCPE.CRM.RisGateway).SendRequestInfo(OrdRowIdStr)
    q SQLCODE
SaveCollectInfoErr
    q ""
}

/// function:判断待更新的标本号是不是本人没执行过医嘱的标本号
/// d ##class(web.DHCPE.BarPrint).IsUpdateSpec()
ClassMethod IsUpdateSpec(AdmId, To, OEORIRowID)
{
    s flag=0
    s OEORDRowId=$O(^OEORD(0,"Adm",AdmId,0))
    Q:(""=OEORDRowId) "0"
    
     s SourceRecDepDR=$P($G(^OEORD($p(OEORIRowID,"||",1),"I",$p(OEORIRowID,"||",2),3)),"^",6) 
     s SourceSpecimenType=..GetSpecName(OEORIRowID)
    s OEORIChildsub=0
    f  s OEORIChildsub=$O(^OEORD(OEORDRowId,"I",OEORIChildsub)) Q:(""=OEORIChildsub)||(flag=1)||(flag=2)||(flag=3)  d
    .s OEORIRowId=OEORDRowId_"||"_OEORIChildsub
    .s CRMID=$o(^DHCPECRMO(0,"OEORI",OEORIRowId,""))
    .q:CRMID=""     
    .s PreItemID=$p($G(^DHCPECRMO(CRMID)),"^",2)
    .q:PreItemID=""
    .s OEORIItemStatDR=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",13)
    .q:(OEORIItemStatDR="4")||(OEORIItemStatDR="6")||$d(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OEORIRowId))
    .s OEORILabEpisodeNo=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,3)),"^",20)
    .q:OEORILabEpisodeNo=""
    .i OEORILabEpisodeNo=To s flag=1
    .i flag=1 d
    ..s ToSpecimenType=..GetSpecName(OEORDRowId_"||"_OEORIChildsub)
    ..b ;SourceSpecimenType ToSpecimenType
    ..i SourceSpecimenType'=ToSpecimenType s flag=3 //样本不一致
    ..q:flag=3
    ..s ToRecDepDR=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,3)),"^",6)
    ..i ToRecDepDR'=SourceRecDepDR s flag=2 //接受科室不一致
   
    q flag
}

/// Description:  更新标本号
/// Input:        Source（原标本号）, To（新标本号）, UserID（操作人ID）, OEORIRowID（医嘱ID)
/// Dubug:  d ##class(web.DHCPE.BarPrint).UpdateSpec()
ClassMethod UpdateSpec(Source, To, UserID, OEORIRowID)
{
    
    i To="" d
    .i $D(^PEEPIS(0)) d
    ..s To=$I(^PEEPIS(0))
    .e  d
    ..s To=$I(^EPIS(0))
    &SQL(Update Sqluser.OE_OrdItem set OEORI_LabEpisodeNo=:To where OEORI_LabEpisodeNo=:Source)
    if SQLCODE=100 s SQLCODE=0
	if (SQLCODE=0){
		s Paadm=$p($g(^OEORD(+OEORIRowID)),"^",1)
        s IADMRowId=$o(^DHCPEIADM(0,"PAADM",Paadm,0))
        s crmAdmId=$p($g(^DHCPEIADM(IADMRowId)),"^",4)
        s Remark="更新标本号：从 "_Source_" 到 "_To
        //修改标本号日志
        d ##class(web.DHCPE.AdmRecordManager).Insert(crmAdmId,"P","UpdateEpisodeNo",UserID,Remark)
		
	}

    s OrdRowIdStr=##class(web.DHCNurSpecerNo).GetOrderStr(To)
    d ##class(web.DHCPE.CRM.RisGateway).SendRequestInfo(OrdRowIdStr)
    q ""
}

ClassMethod GetBaseInfo(RegNo, SpecNo, HospID As %String = "", CTLocID As %String = "")
{
    i (RegNo="")&&(SpecNo="") q "^^^^^^^^^^^^^^^^^^^^^^"
    s Flag=0
    i (RegNo="")&&(SpecNo'="") d
    .s OEORD=$o(^OEORD(0,"EpisNo",SpecNo,0))
    .s:OEORD="" Flag=1
    .q:Flag=1
    .s PAADM=$P($G(^OEORD(OEORD)),"^",1)
    .s:PAADM="" Flag=1
    .q:Flag=1
    .s IADMDR=$o(^DHCPEIADM(0,"PAADM",PAADM,0))
    .s:IADMDR="" Flag=1
    .q:Flag=1
    .s PIADMDR=$p($G(^DHCPEIADM(IADMDR)),"^",4)
    .s:PIADMDR="" Flag=1
    .q:Flag=1
    .s PIBIDR=$p($G(^DHCPEPreIADM(PIADMDR)),"^",1)
    .s:PIBIDR="" Flag=1
    .q:Flag=1
    .s RegNo=$p($G(^DHCPEPreIBI(PIBIDR)),"^",1)
    q:Flag=1 "^^^^^^^^^^^^^^^^^^^^^^"
    s RegNo=##class(web.DHCPE.DHCPECommon).RegNoMask(RegNo,CTLocID)
    S PAPMI=$O(^PAPERi("PAPMI_PatNo",RegNo,0))
    s PIBI=$o(^DHCPEPreIBI(0,"PAPMINo",RegNo,0))
    i PIBI="" q "^^^^^^^^^^^^^^^^^^^^^^"
    s Name=$p($G(^DHCPEPreIBI(PIBI)),"^",2)
    s Sex=$p($G(^DHCPEPreIBI(PIBI)),"^",3)
    i Sex'="" d
    .s Sex=$p(^CT("SEX",Sex),"^",2)
    s Dob=$p($G(^DHCPEPreIBI(PIBI)),"^",4)
    s Age=""
    /*i Dob'="" d
    .s Age=+##class(web.DHCLCNUREXCUTE).CalAge(Dob,+$H)
    */
    I PAPMI'="" d
    .;s Age=##class(web.DHCBillInterface).GetPapmiAge(PAPMI)
    .s Age=##class(web.DHCPE.DHCPECommon).GetPapmiAge(PAPMI,HospID)
    s IDCard=$p($G(^DHCPEPreIBI(PIBI)),"^",9)
   
    /***翻译 start***/
	s Sex=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.CTSex",Sex,"CTSEXDesc","cls")
    /***翻译 end***/
    q Name_"^"_Sex_"^"_IDCard_"^"_RegNo_"^"_Age
}

ClassMethod GetGZDInfo(IADM, OEOrdItemID)
{
    s ARCIMId=""
    i OEOrdItemID'="" s ARCIMId=$p(^OEORD(+OEOrdItemID,"I",$p(OEOrdItemID,"||",2),1),"^",2)
    
    s OEORDRowId=0
    s OEORDRowId=$O(^OEORD(0,"Adm",IADM,OEORDRowId))  //oe_order表
    Q:(""=OEORDRowId) ""
    
    s OEORIChildsub=0
    k ^DHCPETEMPTemp($J,"GZDTemp")
    s Strings=""
    f  s OEORIChildsub=$O(^OEORD(OEORDRowId,"I",OEORIChildsub)) Q:(""=OEORIChildsub)  d
    .s OEORIRowId=OEORDRowId_"||"_OEORIChildsub  //oe_order表 ID
    .//OEORI_ItemStat_DR(OEC_OrderStatus)
    .s OEORIItemStatDR=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",13)  //检验医嘱状态
    .Q:(1'=OEORIItemStatDR)     // 是否有效医嘱
    .s OEORIItmMastDR=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",2)
    .q:(ARCIMId'="")&&(OEORIItmMastDR'=ARCIMId)
    .s TempName=$G(^DHCPECTDataEx("DHCPEStationOrder","TempName",OEORIItmMastDR))
    .q:TempName=""
    .s ARCIMSubscript=$P(OEORIItmMastDR,"||",1)
    .s ARCIMVersion=$P(OEORIItmMastDR,"||",2)
    .s ARCIMDesc=$P($G(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)
    .s ^DHCPETEMPTemp($J,"GZDTemp",TempName)=$G(^DHCPETEMPTemp($J,"GZDTemp",TempName))_"、"_ARCIMDesc
    s StrInfo=""
    s TempName=""
    f  s TempName=$o(^DHCPETEMPTemp($J,"GZDTemp",TempName)) q:TempName=""  d
    .s Str=TempName_"^"_$p($G(^DHCPETEMPTemp($J,"GZDTemp",TempName)),"、",2,$l($G(^DHCPETEMPTemp($J,"GZDTemp",TempName)),"、"))
    .i StrInfo="" d
    ..s StrInfo=Str
    .e  d
    ..s StrInfo=StrInfo_"%%"_Str
    q:StrInfo="" ""
    
    s IADMDR=$o(^DHCPEIADM(0,"PAADM",IADM,0))
    q:IADMDR="" ""
    s PIADMDR=$p($G(^DHCPEIADM(IADMDR)),"^",4)
    q:PIADMDR="" ""
    s PIBI=$p($G(^DHCPEPreIADM(PIADMDR)),"^",1)
    q:PIBI="" ""
    s RegNo=$p($G(^DHCPEPreIBI(PIBI)),"^",1)
    s Name=$p($G(^DHCPEPreIBI(PIBI)),"^",2)
    s Sex=$p($G(^DHCPEPreIBI(PIBI)),"^",3)
    i Sex'="" d
    .s Sex=$p(^CT("SEX",Sex),"^",2)
    s Dob=$p($G(^DHCPEPreIBI(PIBI)),"^",4)
    s Age=""
    i Dob'="" d
    .s Age=+##class(web.DHCLCNUREXCUTE).CalAge(Dob,+$H)
    s IDCard=$p($G(^DHCPEPreIBI(PIBI)),"^",9)
    q Name_"^"_Sex_"^"_IDCard_"^"_RegNo_"^"_Age_"$$"_StrInfo
}

ClassMethod GetSaveSpecInfo(SpecNo As %Library.String = "", RoomRecordID As %String = "", RoomID As %String = "", PAADM As %String = "", SpecNoType As %String = "")
{
    q:(""=SpecNo)&&(RoomRecordID="")&&(PAADM="") ""
    
    i SpecNoType=""  s SpecNoType="血"
    
    s AdmId=""
    i SpecNo'="" d
    .s OEORDRowId=$o(^OEORD(0,"EpisNo",SpecNo,0))
    .q:OEORDRowId=""
    .s AdmId=$P($G(^OEORD(OEORDRowId)),"^",1)
    e  i RoomRecordID'="" d
    .s obj=##class(User.DHCPEAdmRoomRecord).%OpenId(RoomRecordID)
    .s AdmId=obj.ARRAdmDR
    e  d
    .s AdmId=PAADM
    Q:(""=AdmId) ""
    s AdmType=$P(^PAADM(AdmId),"^",2)
    i AdmType'="H"{
	    s value=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpesavecollectspec.hisui.csp","不是体检人员")
        q value
        
    }
    s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PAADM",AdmId)
    i LocFlag="1"
    {
	    s value=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpesavecollectspec.hisui.csp","不是本科室人员,不能采集")
        q value
        
    }
    s OEORD=$O(^OEORD(0,"Adm",AdmId,0))
    i OEORD=""{
	    s value=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpesavecollectspec.hisui.csp","没有项目信息")
        q value
    }
    
    s SpecStr=""
    i RoomID'="" s SpecStr=##class(web.DHCPE.RoomManager).GetAllSpec(RoomID)
    s SpecStr="^"_SpecStr_"^"
    s NoPayedItem="",OneItem=""
    s LabEpisodeNo=""
    s RoomSpecInfo=""
    
    s OESub=0
    f  s OESub=$O(^OEORD(OEORD,"I",OESub)) q:OESub=""  d
    .s LabEpisodeNo=$p($G(^OEORD(OEORD,"I",OESub,3)),"^",20)
    .q:LabEpisodeNo=""
    .s ItemStat=$p($G(^OEORD(OEORD,"I",OESub,1)),"^",13)
    .q:(ItemStat="4")||(ItemStat="6")
    .s PayedFlag=$p($G(^OEORD(OEORD,"I",OESub,3)),"^",5)
    .s ItemDesc=""
    .s tempSPECCode=""
    .s tempSPECDesc=""
    .s OEORIRowId=""
    .s OEORIItmMastDR=$p($G(^OEORD(OEORD,"I",OESub,1)),"^",2)
    .s ItemDesc=..GetARCIMDesc(LabEpisodeNo,OEORD,",")
    .s ItemDesc=$P(ItemDesc,$C(1),1)
    .s OEORIRowId=OEORD_"||"_OESub
    .s CRMID=$o(^DHCPECRMO(0,"OEORI",OEORIRowId,""))
    .s PreItemID=$P($g(^DHCPECRMO(CRMID)),"^",2)
    .s CurSpec=$G(^DHCPEDataEx("DHCPEPreIOrdItem","PERSON",PreItemID))
    .s tempSPECDesc=$P(CurSpec,"^",2)
    .s tempSPECCode=$P(CurSpec,"^",1)
    .q:OEORIRowId=""
    .i (RoomID'="")&&(SpecStr'[("^"_tempSPECCode_"^"))&&(SpecNoType="血")&&(tempSPECDesc["血") s RoomSpecInfo="该诊室没维护相应的标本类型"
    .;i (RoomID'="")&&(SpecStr'[("^"_tempSPECCode_"^")) s RoomSpecInfo="该诊室没维护相应的标本类型"
    .;q:(RoomID'="")&&(SpecStr'[("^"_tempSPECCode_"^"))&&(SpecNoType="血")&&(tempSPECDesc'["血")  //只有血的标本才分诊
    .s SpecimenDesc=..GetSpecName(OEORIRowId)
    .;q:(RoomID="")&&(("^"_SpecimenDesc_"^")'[("血"))
    .s SpecNoFlag=0
    .s SpecNoTypeLength=$l(SpecNoType,"^")
    .f SpecNoTypeNum=1:1:SpecNoTypeLength  d
    ..s SpecNoTypeOne=$p(SpecNoType,"^",SpecNoTypeNum)
    ..i (("^"_SpecimenDesc_"^")[SpecNoTypeOne) s SpecNoFlag=1
    .q:(SpecNoFlag=0)&&(RoomID="")
    .
    .s RoomFlag=0
    .i RoomID'="" d
    ..i SpecNoType="血" d
    ...i SpecStr[("^"_tempSPECCode_"^")&&(SpecNoFlag=1) s RoomFlag=1
    ..e  i SpecNoFlag=1 s RoomFlag=1
    .q:(RoomID'="")&&(RoomFlag=0)
    .
    .s OEORILabEpisodeNo=LabEpisodeNo
    .i PayedFlag'="P" d
    ..s OneItem=OEORILabEpisodeNo_"("_ItemDesc_")"
    .I NoPayedItem="" d
    ..s NoPayedItem=OneItem
    .e  d
    ..s NoPayedItem=NoPayedItem_","_OneItem
    
    i NoPayedItem'=""{
	    s value=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpesavecollectspec.hisui.csp","未付费项目信息:")
        q value_NoPayedItem
    }
    i RoomSpecInfo'="" {
	     s value=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpesavecollectspec.hisui.csp","该诊室没维护相应的标本类型")
         q value
    }
    
    Set qHandle=$lb(0,repid,0)
    s VIPInfo=##class(web.DHCPE.PreCommon).GetVIPLevel("PAADM",AdmId)
    i VIPInfo'="" d
    .s VIPDesc=$P(VIPInfo,"^",2)
    s VIPDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEVIPLevel",VIPDesc,"VLDesc","cls")
    q VIPDesc
}

/*
Query FindOItemStatusForSpecNo(SpecNo As %Library.String = "", RoomRecordID As %String = "", RoomID As %String = "", PAADM As %String = "", RegNo As %String = "") As %Query(ROWSPEC = "TOEORIRowId:%String, TOEORIItmMastDR:%String, TItemName:%String, TSpecNo:%String,TSpecName:%String,TDate:%String,TTime:%String,TUserName:%String,TOSTATDesc:%String,TPlacerCode:%String,TAdmId:%String,Tid:%String,TCurInfo:%String,TPlacerColor:%String")
{
}

// d ##class(%ResultSet).RunQuery("web.DHCPE.BarPrint", "FindOItemStatusForSpecNo","2000690715","","")

ClassMethod FindOItemStatusForSpecNoExecute(ByRef qHandle As %Binary, SpecNo As %Library.String = "", RoomRecordID As %String = "", RoomID As %String = "", PAADM As %String = "", RegNo As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s ind=1
    Q:(""=SpecNo)&&(RoomRecordID="")&&(PAADM="") $$$OK
    s AdmId=""
    i SpecNo'="" d
    .s OEORDRowId=$o(^OEORD(0,"EpisNo",SpecNo,0))
    .q:OEORDRowId=""
    .s AdmId=$P($G(^OEORD(OEORDRowId)),"^",1)
    e  i RoomRecordID'="" d
    .s obj=##class(User.DHCPEAdmRoomRecord).%OpenId(RoomRecordID)
    .s AdmId=obj.ARRAdmDR
    e  d
    .s AdmId=PAADM
    Q:(""=AdmId) $$$OK
    s AdmType=$P(^PAADM(AdmId),"^",2)
    i AdmType'="H"{
        w "<font color=red>不是体检信息</font>"
        q $$$OK
    }
    s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PAADM",AdmId)
    i LocFlag="1"
    {
        w "<font color=red>不是本科室人员,不能采集</font>"
        q $$$OK
    }
    s OEORD=$O(^OEORD(0,"Adm",AdmId,0))
    i OEORD=""{
        w "没有项目信息"
        q $$$OK
    }
    s VIPInfo=##class(web.DHCPE.PreCommon).GetVIPLevel("PAADM",AdmId)
    i VIPInfo'="" d
    .s VIPDesc=$P(VIPInfo,"^",2)
    .w "<font color=red size=6>"_VIPDesc_"</font>"
    s Job=$J
    s sub=0
    f  s sub=$O(^OEORD(OEORD,"I",sub)) q:sub=""  d
    .s LabEpisodeNo=$p($G(^OEORD(OEORD,"I",sub,3)),"^",20)
    .q:LabEpisodeNo=""
    .q:$D(^TempDHCPEBarPrint(Job,LabEpisodeNo))
    .s ItemStat=$p($G(^OEORD(OEORD,"I",sub,1)),"^",13)
    .;q:ItemStat="4"
    .q:(ItemStat="4")||(ItemStat="6")
    .s PayedFlag=$p($G(^OEORD(OEORD,"I",sub,3)),"^",5)
    .s ^TempDHCPEBarPrint(Job,LabEpisodeNo)=PayedFlag
    s SpecStr=""
    i RoomID'="" s SpecStr=##class(web.DHCPE.RoomManager).GetAllSpec(RoomID)
    
    s SpecStr="^"_SpecStr_"^"
    s NoPayedItem=""
    s LabEpisodeNo=""
    s RoomSpecInfo=""
    b ;^TempDHCPEBarPrint(Job)
    f  s LabEpisodeNo=$O(^TempDHCPEBarPrint(Job,LabEpisodeNo)) q:LabEpisodeNo=""  d
    .s sub=0
    .s PayedFlag=$G(^TempDHCPEBarPrint(Job,LabEpisodeNo))
    .s ItemDesc=""
    .s tempSPECCode=""
    .s tempSPECDesc=""
    .s OSTATDesc="核实"
    .s OEORIRowId=""
    .f  s sub=$O(^OEORD(0,"EpisNo",LabEpisodeNo,OEORD,sub)) q:sub=""  d
    ..s ItemStat=$p($G(^OEORD(OEORD,"I",sub,1)),"^",13)
    ..q:ItemStat="4"
    ..s:ItemStat="6" OSTATDesc="执行"
    ..s OEORIItmMastDR=$p($G(^OEORD(OEORD,"I",sub,1)),"^",2)
    ..;s ARCIMDesc=$P($G(^ARCIM(+OEORIItmMastDR,1,1)),"^",3)
    ..;i ItemDesc=""  d
    ..;.s ItemDesc=ARCIMDesc
    ..;e  d
    ..;.s ItemDesc=ItemDesc_","_ARCIMDesc
    ..s ItemDesc=..GetARCIMDesc(LabEpisodeNo,OEORD,",")
    ..s ItemDesc=$P(ItemDesc,$C(1),1)
    ..s OEORIRowId=OEORD_"||"_sub
    ..s CRMID=$o(^DHCPECRMO(0,"OEORI",OEORIRowId,""))
    ..s PreItemID=$P(^DHCPECRMO(CRMID),"^",2)
    ..s CurSpec=$G(^DHCPEDataEx("DHCPEPreIOrdItem","PERSON",PreItemID))
    ..s tempSPECDesc=$P(CurSpec,"^",2)
    ..s tempSPECCode=$P(CurSpec,"^",1)
    .q:OEORIRowId=""
    .i (RoomID'="")&&(SpecStr'[("^"_tempSPECCode_"^")) s RoomSpecInfo="该诊室没维护相应的标本类型"
    .q:(RoomID'="")&&(SpecStr'[("^"_tempSPECCode_"^"))
    .s SpecimenDesc=..GetSpecName(OEORIRowId)
    .q:(RoomID="")&&(("^"_SpecimenDesc_"^")'[("血"))
    .s ARCIMDesc=ItemDesc
    .s OEORILabEpisodeNo=LabEpisodeNo
    .//s placerCode=..GerExeLocId(OEORIRowId)
    .s placerCode=..GetplacerCode(OEORIRowId)
    .s PlacerColor=$P(placerCode,"^",1)
    .s placerCode=$P(placerCode,"^",2)
    .s SpecName=tempSPECDesc
    .s (Date,Time,User)=""
    .i '$D(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OEORIRowId)) d
    ..i '$D(^DHCPETempLabEpisodeScan(OEORILabEpisodeNo)) d
    ...d:PayedFlag="P" ..SaveSpecCollect(OEORILabEpisodeNo)
    .e  d
    ..s OSTATDesc="谢绝检查"
    .i $D(^DHCPETempLabEpisodeScan(OEORILabEpisodeNo)) d
    ..s Str=$G(^DHCPETempLabEpisodeScan(OEORILabEpisodeNo))
    ..q:Str=""
    ..s Date=$p(Str,"^",1)
    ..s Time=$p(Str,"^",2)
    ..s User=$p(Str,"^",3)
    .i Date'="" s Date=##class(websys.Conversions).DateLogicalToHtml(Date)
    .i Time'="" s Time=$ZT(Time)
    .i User'="" s User=$P($G(^SSU("SSUSR",User)),"^",2)
    .s (OEORIRowId,OEORIItmMastDR)=""
    .i PayedFlag'="P" d
    ..s OneItem=OEORILabEpisodeNo_"("_ARCIMDesc_")"
    ..i NoPayedItem="" d
    ...s NoPayedItem=OneItem
    ..e  d
    ...s NoPayedItem=NoPayedItem_","_OneItem
    .e  d
    ..d OutOItemStatusForAdm
    k ^TempDHCPEBarPrint(Job)
    i NoPayedItem'="" d
    .w "<font color =red>未付费项目信息:"_NoPayedItem_"</font>"
    i RoomSpecInfo'="" d
    .w "<font color=red size=4> 该诊室没维护相应的标本类型</font>"
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutOItemStatusForAdm
    s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PAADM",AdmId)
    q:LocFlag=1
    s obj=##class(User.PAAdm).%OpenId(AdmId)
    s CurRegNo=obj.PAADMPAPMIDR.PAPMINo
    s CurInfo=..GetBaseInfo(CurRegNo,"")
    
    s Level=3
    s:SpecName[("血") Level=5
    s:SpecName[("便") Level=1
    s:SpecName[("尿") Level=2
    i (ARCIMDesc[("糖化血红蛋白"))||(ARCIMDesc[("HbA1C")) s Level=4
    s indSort=Level*100+ind
    
    set Data=$lb(OEORIRowId, OEORIItmMastDR, ARCIMDesc, OEORILabEpisodeNo,SpecName,Date,Time,User,OSTATDesc,placerCode,AdmId,ind,CurInfo,PlacerColor)
    Set ^CacheTemp(repid,indSort)=Data
    Set ind=ind+1
    q
}
*/
/// debug: d ##class(%ResultSet).RunQuery("web.DHCPE.BarPrint", "FindOItemStatusForSpecNo","1000005310","","")
Query FindOItemStatusForSpecNo(SpecNo As %Library.String = "", RoomRecordID As %String = "", RoomID As %String = "", PAADM As %String = "", RegNo As %String = "", HospID As %String = "", SpecNoType As %String = "", SessionStr) As %Query(ROWSPEC = "TOEORIRowId:%String, TOEORIItmMastDR:%String, TItemName:%String, TSpecNo:%String,TSpecName:%String,TDate:%String,TTime:%String,TUserName:%String,TOSTATDesc:%String,TPlacerCode:%String,TAdmId:%String,Tid:%String,TCurInfo:%String,TPlacerColor:%String,TName:%String,TRegNo:%String,TSex:%String,TRefuse:%String,TAge:%String,TPlacesNo::%String")
{
}

ClassMethod FindOItemStatusForSpecNoExecute(ByRef qHandle As %Binary, SpecNo As %Library.String = "", RoomRecordID As %String = "", RoomID As %String = "", PAADM As %String = "", RegNo As %String = "", HospID As %String = "", SpecNoType As %String = "", SessionStr) As %Status
{
	k ^tempdhcpe("OItemStatusForSpecNo")
    s ^tempdhcpe("OItemStatusForSpecNo")=$lb(SpecNo,RoomRecordID,RoomID,PAADM,RegNo,HospID,SpecNoType,SessionStr)

    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s ind=1
    
    Q:(""=SpecNo)&&(RoomRecordID="")&&(PAADM="") $$$OK
    
    s LogUserId=$p(SessionStr,"^",1)
    s LogLocID=$p(SessionStr,"^",2)
    
    s AdmId=""
    i SpecNo'="" d
    .s OEORDRowId=$o(^OEORD(0,"EpisNo",SpecNo,0))
    .q:OEORDRowId=""
    .s AdmId=$P($G(^OEORD(OEORDRowId)),"^",1)
    e  i RoomRecordID'="" d
    .s obj=##class(User.DHCPEAdmRoomRecord).%OpenId(RoomRecordID)
    .s AdmId=obj.ARRAdmDR
    e  d
    .s AdmId=PAADM
    Q:(""=AdmId) $$$OK
    s AdmType=$P(^PAADM(AdmId),"^",2)
    s UserLoc=$P($G(^PAADM(AdmId)),"^",4)
    i AdmType'="H"{
        //w "<font color=red>不是体检信息</font>"
        q $$$OK
    }
    s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PAADM",AdmId)
   
    i LocFlag="1"
    {
        //w "<font color=red>不是本科室人员,不能采集</font>"
        q $$$OK
    }
    s OEORD=$O(^OEORD(0,"Adm",AdmId,0))
    i OEORD=""{
        //w "没有项目信息"
        q $$$OK
    }
    s VIPInfo=##class(web.DHCPE.PreCommon).GetVIPLevel("PAADM",AdmId)
    i VIPInfo'="" d
    .s VIPDesc=$P(VIPInfo,"^",2)
    .//w "<font color=red size=6>"_VIPDesc_"</font>"
    s Job=$J
    s Refuse="启用"
    s Refuse=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpesavecollectspec.hisui.csp",Refuse)
    s sub=0
    f  s sub=$O(^OEORD(OEORD,"I",sub)) q:sub=""  d
    .s LabEpisodeNo=$p($G(^OEORD(OEORD,"I",sub,3)),"^",20)
    .q:LabEpisodeNo=""
    .q:$D(^TempDHCPEBarPrint(Job,LabEpisodeNo))
    .s ItemStat=$p($G(^OEORD(OEORD,"I",sub,1)),"^",13)
    .;q:ItemStat="4"
    .q:(ItemStat="4")||(ItemStat="6")
    .s PayedFlag=$p($G(^OEORD(OEORD,"I",sub,3)),"^",5)
    .s ^TempDHCPEBarPrint(Job,LabEpisodeNo)=PayedFlag
    s SpecStr=""
    i RoomID'="" s SpecStr=##class(web.DHCPE.RoomManager).GetAllSpec(RoomID)
    
    s SpecStr="^"_SpecStr_"^"
    s NoPayedItem=""
    s LabEpisodeNo=""
    s RoomSpecInfo=""
    b ;^TempDHCPEBarPrint(Job)
    f  s LabEpisodeNo=$O(^TempDHCPEBarPrint(Job,LabEpisodeNo)) q:LabEpisodeNo=""  d
    .s OEORDSub=0
    .s PayedFlag=$G(^TempDHCPEBarPrint(Job,LabEpisodeNo))
    .s ItemDesc=""
    .s tempSPECCode=""
    .s tempSPECDesc=""
    .s OSTATDesc="核实"
    .s OEORIRowId=""
    .f  s OEORDSub=$O(^OEORD(0,"EpisNo",LabEpisodeNo,OEORD,OEORDSub)) q:OEORDSub=""  d
    ..s OEORIItmMastDR=$p($G(^OEORD(OEORD,"I",OEORDSub,1)),"^",2)
    ..q:OEORIItmMastDR=""
    ..s ItemStat=$p($G(^OEORD(OEORD,"I",OEORDSub,1)),"^",13)
    ..q:ItemStat="4"
    ..s:ItemStat="6" OSTATDesc="执行"
    ..s ItemDesc=..GetARCIMDesc(LabEpisodeNo,OEORD,",")
    ..s ItemDesc=$P(ItemDesc,$C(1),1)
    ..s OEORIRowId=OEORD_"||"_OEORDSub
    ..s CRMOEORIRowIdID=$o(^DHCPECRMO(0,"OEORI",OEORIRowId,""))
    ..s PreItemID=$P($g(^DHCPECRMO(CRMOEORIRowIdID)),"^",2)
    ..s CurSpec=$g(^DHCPEDataEx("DHCPEPreIOrdItem","PERSON",PreItemID))
    ..s tempSPECDesc=$P(CurSpec,"^",2)
    ..s tempSPECCode=$P(CurSpec,"^",1)
    .q:OEORIRowId=""
    .i SpecNoType="" s SpecNoType="血"
    .i (RoomID'="")&&(SpecStr'[("^"_tempSPECCode_"^"))&&(SpecNoType="血")&&(tempSPECDesc["血") s RoomSpecInfo="该诊室没维护相应的标本类型"
    .;i (RoomID'="")&&(SpecStr'[("^"_tempSPECCode_"^")) s RoomSpecInfo="该诊室没维护相应的标本类型"
    .;q:(RoomID'="")&&(SpecStr'[("^"_tempSPECCode_"^"))&&(SpecNoType="血")&&(tempSPECDesc'["血")  //只有血的标本才分诊
    .s SpecimenDesc=..GetSpecName(OEORIRowId)
    .s SpecNoFlag=0
    .s SpecNoTypeLength=$l(SpecNoType,"^")
    .f SpecNoTypeNum=1:1:SpecNoTypeLength  d
    ..s SpecNoTypeOne=$p(SpecNoType,"^",SpecNoTypeNum)
    ..i (("^"_SpecimenDesc_"^")[SpecNoTypeOne) s SpecNoFlag=1
    .q:(SpecNoFlag=0)&&(RoomID="")
    .;q:(RoomID="")&&(("^"_SpecimenDesc_"^")'[("血"))
    .s RoomFlag=0
    .i RoomID'="" d
    ..i SpecNoType="血" d
    ...i SpecStr[("^"_tempSPECCode_"^")&&(SpecNoFlag=1) s RoomFlag=1
    ..e  i SpecNoFlag=1 s RoomFlag=1
    .q:(RoomID'="")&&(RoomFlag=0)

    .s ARCIMDesc=ItemDesc
    .s OEORILabEpisodeNo=LabEpisodeNo
    .//s placerCode=..GerExeLocId(OEORIRowId)
    .s placerCode=..GetplacerCode(OEORIRowId)
    .s PlacerColor=$P(placerCode,"^",1)
    .s placerCode=$P(placerCode,"^",2)
    .s SpecName=tempSPECDesc
    .s (Date,Time,User)=""
    .s PlacesNo=""
    .s PlacesNo=##class(web.DHCNurCom).GetPlacerNo(OEORIRowId) //预制容器号

    .i $D(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OEORIRowId)) d
    ..s Refuse="取消"
    ..s Refuse=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpesavecollectspec.hisui.csp",Refuse)
    ..s OSTATDesc="谢绝检查"
    
    .i '$D(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OEORIRowId)) d
    ..s ItemStat=$p($G(^OEORD(+OEORIRowId,"I",$p(OEORIRowId,"||",1),1)),"^",13)
    ..i ItemStat="1" s OSTATDesc="核实"
    ..i ItemStat="6" s OSTATDesc="执行"
    ..s Refuse="启用"
    ..s Refuse=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpesavecollectspec.hisui.csp",Refuse)
    ..i '$D(^DHCPETempLabEpisodeScan(OEORILabEpisodeNo)) d
    ...
    ...i PayedFlag="P" d
    ....i ($g(^DHCPESetting("DHCPE","CollectSpecOne",UserLoc))="Y")&&(SpecNo'="") d ..SaveSpecCollect(SpecNo,LogUserId,LogLocID)
    ....e  d ..SaveSpecCollect(OEORILabEpisodeNo,LogUserId,LogLocID)
    .s Date="",Time="",User=""
    .i $D(^DHCPETempLabEpisodeScan(OEORILabEpisodeNo)) d
    ..s Str=$G(^DHCPETempLabEpisodeScan(OEORILabEpisodeNo))
    ..q:Str=""
    ..s Date=$p(Str,"^",1)
    ..s Time=$p(Str,"^",2)
    ..s User=$p(Str,"^",3)
    .i Date'="" s Date=##class(websys.Conversions).DateLogicalToHtml(Date)
    .i Time'="" s Time=$ZT(Time)
    .i User'="" s User=$P($G(^SSU("SSUSR",User)),"^",2)
    .i PayedFlag'="P" d
    ..s OneItem=OEORILabEpisodeNo_"("_ARCIMDesc_")"
    ..i NoPayedItem="" d
    ...s NoPayedItem=OneItem
    ..e  d
    ...s NoPayedItem=NoPayedItem_","_OneItem
    .e  d
    ..d OutOItemStatusForAdm
    k ^TempDHCPEBarPrint(Job)
    
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutOItemStatusForAdm
    s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PAADM",AdmId)
    q:LocFlag=1
    s obj=##class(User.PAAdm).%OpenId(AdmId)
    s CurRegNo=obj.PAADMPAPMIDR.PAPMINo
    s CurInfo=..GetBaseInfo(CurRegNo,"",HospID)
    s Name=$p(CurInfo,"^",1)
    s Sex=$p(CurInfo,"^",2)
    s RegNo=$p(CurInfo,"^",4)
    S Age=$p(CurInfo,"^",5)
    s Level=3
    s:SpecName[("血") Level=5
    s:SpecName[("便") Level=1
    s:SpecName[("尿") Level=2
    i (ARCIMDesc[("糖化血红蛋白"))||(ARCIMDesc[("HbA1C")) s Level=4
    s indSort=Level*100+ind
    
    /*** 翻译start ***/
    s ARCIMDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.ARCItmMast",ARCIMDesc,"ARCIMDesc","cls")
    s OSTATDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpesavecollectspec.hisui.csp",OSTATDesc)
    /*** 翻译 end ***/
    
    set Data=$lb(OEORIRowId, OEORIItmMastDR, ARCIMDesc, OEORILabEpisodeNo,SpecName,Date,Time,User,OSTATDesc,placerCode,AdmId,ind,CurInfo,PlacerColor,Name,RegNo,Sex,Refuse,Age,PlacesNo)
    Set ^CacheTemp(repid,indSort)=Data
    Set ind=ind+1
    q
}

ClassMethod FindOItemStatusForSpecNoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOItemStatusForSpecNoExecute ]
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

ClassMethod FindOItemStatusForSpecNoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOItemStatusForSpecNoExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 判断一个项目是否为公费
ClassMethod GetFeeTypeByOEItem(OEORDItemID)
{
    s AddOrdItem=""
    q:OEORDItemID="" AddOrdItem
    s CRMOrderID=$o(^DHCPECRMO(0,"OEORI",OEORDItemID,0))
    q:CRMOrderID="" AddOrdItem
    s myRowId=$p(^DHCPECRMO(CRMOrderID),"^",2)
    q:myRowId="" AddOrdItem
    s ItemType="Item"
    s TwoFeeRecord=##class(web.DHCPE.PreIADM).IsHaveTwoFeeRecord(myRowId,"ORDITEM")
    i TwoFeeRecord>0 d
    .s AddOrdItem="公+自"
    .s gFeeId=##class(web.DHCPE.PreAudit).GetPartItemFeeID(myRowId,"G")
    .s AuditID=$p(^DHCPEPreIADM($p(gFeeId,"||",1),"ORDITEM",$p(gFeeId,"||",2),"FEE",$p(gFeeId,"||",3)),"^",5)
    e  d
    .s gFeeId=$o(^DHCPEPreIADM($p(myRowId,"||",1),"ORDITEM",$p(myRowId,"||",2),"FEE",0))
    .i gFeeId'="" d
    ..s gFeeId=myRowId_"||"_gFeeId
    ..s AuditID=$p(^DHCPEPreIADM($p(gFeeId,"||",1),"ORDITEM",$p(gFeeId,"||",2),"FEE",$p(gFeeId,"||",3)),"^",5)
    ..s AddOrdItem=$p(^DHCPEPreA(AuditID),"^",1)
    ..s:AddOrdItem="G" AddOrdItem="公费"
    ..s:AddOrdItem="I" AddOrdItem="自费"
    q AddOrdItem
}

ClassMethod GetPatLisItem(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
    

    s AdmId=$P(InString,"^",1)
    s PEIADM=$o(^DHCPEIADM(0,"PAADM",AdmId,0))
    s PreIADM=$p($G(^DHCPEIADM(PEIADM)),"^",4)
    s ArrStatus=$p($G(^DHCPEIADM(PEIADM)),"^",8)
    q:(ArrStatus'="ARRIVED")&&(ArrStatus'="REGISTERED") ""
    
    s ParInfo=..GetPatientInfo(AdmId)
    s RegNo=$P(ParInfo,"^",1)       // 登记号
    s PatName = $P(ParInfo,"^",5)   // 姓名
    s PatAge = $P(ParInfo,"^",8)    // 年龄
    s Sex = $P(ParInfo,"^",4)       // 性别
    s PatLoc = $P(ParInfo,"^",2)    // 部门   
    s ParInfo=RegNo_"^"_PatName_"^"_PatAge_"^"_Sex_"^"_PatLoc_"^"_BedCode

    s OEOrdItems=..GetLisOEOrdItem(PreIADM,AdmId)
    s Item=ParInfo_"!"_OEOrdItems
    Q Item
}

ClassMethod GetLisOEOrdItem(PreIADM, AdmId)
{
   k ^DHCPEDateEx("BarOrdItems")
    s ret=""
    s OEORIPlacerNo=""
    s OEORILabEpisodeNo=""
    s OEORDRowId=0 
    s OEORDRowId=$O(^OEORD(0,"Adm",AdmId,OEORDRowId))  //oe_order表
    Q:(""=OEORDRowId) ""
    s OEORIChildsub=0
    f  s OEORIChildsub=$O(^OEORD(OEORDRowId,"I",OEORIChildsub)) Q:(""=OEORIChildsub)  d
    .s OEORIRowId=OEORDRowId_"||"_OEORIChildsub  //oe_order表 ID
    .s OEORIItemStatDR=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",13)  //检验医嘱状态
    .Q:(1'=OEORIItemStatDR)     // 是否有效医嘱
    .s OEORILabEpisodeNo=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,3)),"^",20)
    .s OEORIPlacerNo=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,3)),"^",36)
    .i OEORILabEpisodeNo=$c(0) s OEORILabEpisodeNo=""
    .Q:(""=OEORILabEpisodeNo)   // 只打印有标本号的检验医嘱
    .Q:("1"=$G(^DHCPEDateEx("BarOrdItems",OEORILabEpisodeNo))) 
    .s ^DHCPEDateEx("BarOrdItems",OEORILabEpisodeNo)="1" // 已获取此标本号的项目
    .s OEORIItmMastDR=""
    .s OEORIItmMastDR=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",2)
    .s ARCIMSubscript=$P(OEORIItmMastDR,"||",1)
    .s ARCIMVersion=$P(OEORIItmMastDR,"||",2)
    .s ARCIMDesc=$P($G(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)
    .i ret=""  s ret=ARCIMDesc_"^"_OEORILabEpisodeNo_"^"_OEORIPlacerNo
    .e  s ret=ret_";"_ARCIMDesc_"^"_OEORILabEpisodeNo_"^"_OEORIPlacerNo
    k ^DHCPEDateEx("BarOrdItems")
    Q ret
}

ClassMethod GetFactAmountByOEID(OEID)
{
    s CRMOID=$O(^DHCPECRMO(0,"OEORI",OEID,""))
    q:CRMOID="" 0
    s CRMID=$P($G(^DHCPECRMO(CRMOID)),"^",2)
    q:CRMID="" 0
    q ##class(web.DHCPE.HandlerPreOrds).GetFactAmountByItem(CRMID,"","")
}

//  ..q:(BDFlag="Y")&&('$d(^DHCPEDataEx("OEOrderItem","PrintRequest",OEORIRowId)))

//  ..q:(BDFlag="N")&&($d(^DHCPEDataEx("OEOrderItem","PrintRequest",OEORIRowId)))

/*
ClassMethod GetRisItemInfo(Instring, FrontFlag, BDFlag)
{
 
   s CTLOCID=%session.Get("LOGON.CTLOCID")
   s LabStation=$g(^DHCPESetting("DHCPE","StationId_Lab"))
   s RisStation=$g(^DHCPESetting("DHCPE","StationId_Ris"))
   s PAAdm=$p(Instring,"^",1)
   s OEItemID=$p(Instring,"^",5)
   s HosCode=$g(^DHCPESetting("DHCPE","HospitalCode"))
   i HosCode="YY"{
   
   s flag=1
   s ret=""
   s str=""
   s IADMDR=0
   s OrdEntDR=""
   s ARCOSDesc=""
   s Abbrev=""
   s str="^^^^^"
   f  s IADMDR=$o(^DHCPEIADM(0,"PAADM",PAAdm,IADMDR))  q:IADMDR=""  d 
    .s CurData=$G(^DHCPEIADM(IADMDR))
    .s AdmDate=$P(CurData,"^",5)
    .s ArrDate=+AdmDate
    .s:(""'=AdmDate) AdmDate=$ZD(AdmDate,3)
    .s PreIADMDR=$P(CurData,"^",4)
    .Q:(""=PreIADMDR) 
    .s CurData=$G(^DHCPEPreIADM(PreIADMDR))
    .s PIBIDR=$P(CurData,"^",1)
    .Q:(""=PIBIDR) 
    .s CurData=$G(^DHCPEPreIBI(PIBIDR))
    .s PAPMINo=$p(CurData,"^",1)
    .i ""'=PAPMINo  s PAPMINo=$Extract("00000000",1,8-$LENGTH(PAPMINo))_PAPMINo
    .s Name=""
    .s Name=$p(CurData,"^",2)
    .s SexDR=$p(CurData,"^",3)
    .s:(""'=SexDR) SexDRName=$p(^CT("SEX",SexDR),"^",2)
    .s Dob=$p(CurData,"^",4)
    .i Dob'="" s PAPERDob=$ZD(Dob,3)
    .i ArrDate=0 s ArrDate=+$h
    .s Age=""
    .s:(""'=Dob) Age=##class(web.DHCLCNUREXCUTE).CalAge(Dob,ArrDate)
    .s Age=$P(Age,"Y")
    .s Age=Age_""_"岁"
    .s VIPDesc=""
    .i PreIADMDR'=""  s VIPID=$p($g(^DHCPEPreIADM(PreIADMDR)),"^",18)
    .i VIPID'=""   d
    ..s VIPStr=$g(^DHCPEVIPLevel("VIP",VIPID))
    ..s VIPDesc=$p(VIPStr,"^",2)
    ..i VIPDesc="特需"  s VIPDesc="T"
    ..i VIPDesc="干部"  s VIPDesc="G"
    .s PreiordID=0
    .i OEItemID=""  d
    ..f  s PreiordID=$o(^DHCPEPreIADM(PreIADMDR,"ORDITEM",PreiordID))  Q:(PreiordID="")||(QuitFlag=1)  d
    ...s PIOIItemStat=$p($g(^DHCPEPreIADM(PreIADMDR,"ORDITEM",PreiordID)),"^",16)
    ...q:PIOIItemStat=4
    ...s ItmMastDR=$p($g(^DHCPEPreIADM(PreIADMDR,"ORDITEM",PreiordID)),"^",1)
    ...s OrdEntDR=$p($g(^DHCPEPreIADM(PreIADMDR,"ORDITEM",PreiordID)),"^",2)
    ...s STID=0
    ...s STID=$o(^DHCPEST(0,"STORD_ARCIM",ItmMastDR,0))
    ...Q:(("^"_^DHCPESetting("DHCPE","StationId_Ris")_"^")'[("^"_STID_"^"))
    ...s Subscript=$p(ItmMastDR,"||",1)
    ...s Version=$p(ItmMastDR,"||",2)
    ...s ItmMastDesc=$p($g(^ARCIM(Subscript,Version,1)),"^",2) 
    ...s Abbrev=$p($g(^ARCIM(Subscript,Version,1)),"^",3) 
    ...i (Abbrev="")||(Abbrev="1")  s Abbrev=ItmMastDesc
    ...s QUITStr="^"
    ...s EntDR=$P(myStr,"^",2)
    ...i EntDR'=""  s ARCOSDR=$p($g(^DHCPEPreIADM($p(EntDR,"||",1),"ORDENT",$p(EntDR,"||",2))),"^",1)
    ...//i ARCOSDR'=""  s QUITStr=..GetOrdSetsFlag(ARCOSDR,OEORIItmMastDR)
    ...//i $p(QUITStr,"^",1)=1 s QuitFlag=1
    ...//q:QuitFlag=1
    ...//i ARCOSDR'="" S ^zl("ItemID",OEORIItmMastDR,ARCOSDR,1)=QUITStr
    ...//i $p(QUITStr,"^",2)'=""  s ARCIMDesc=$p(QUITStr,"^",2)
    ...i OrdEntDR'=""  d 
    ....s flag=OrdEntDR
    ....s PIADMRowId=$p(OrdEntDR,"||",1)
    ....s PIOEChildSub=$p(OrdEntDR,"||",2)
    ....s OrderSetsDR=$p(^DHCPEPreIADM(PIADMRowId,"ORDENT", PIOEChildSub),"^",1)
    ....i OrderSetsDR'=""  s ARCOSDesc=$p($g(^ARCOS(OrderSetsDR)),"^",2)
    ....i ((ARCOSDesc="胸部正侧位(FSK)")||(ARCOSDesc="颈椎正侧位(FSK)")||(ARCOSDesc="胸部正位(FSK)")||(ARCOSDesc="腰椎正侧位(FSK)")||(ARCOSDesc="颈椎双斜位(FSK)")||(ARCOSDesc="双乳腺钼靶照像拍片(FSK)")) s Abbrev=ARCOSDesc
    ....i ARCOSDesc="彩超1(妇科120元)"  s Abbrev="妇科憋尿B超"
    ....i ARCOSDesc="彩超2(妇科180元)"  s Abbrev="妇科阴道B超" 
    ...i str=""  s str=Abbrev_"^"_PAPMINo_"^"_ SexDRName_"^"_Age_"^"_ Name_"^"_ VIPDesc
    ...e  s str=str_";"_Abbrev_"^"_PAPMINo_"^"_ SexDRName_"^"_Age_"^"_ Name_"^"_ VIPDesc

    .e  d        //当打印单个检查标签
    ..s OEORDRowId= $p(OEItemID,"||",1)
    ..s OEORIChildsub=$p(OEItemID,"||",2)
    ..s ItmMastDR=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",2)
    ..s Subscript=$p(ItmMastDR,"||",1)
    ..s Version=$p(ItmMastDR,"||",2)
    ..s STID=0
    ..s STID=$o(^DHCPEST(0,"STORD_ARCIM",ItmMastDR,0))
    ..//q:STID<=LabStation
    ..//Q:(("^"_^DHCPESetting("DHCPE","StationId_Ris")_"^")'[("^"_STID_"^"))
    
    ..s OrdEntDR=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",1)
    ..s ItmMastDesc=$p($g(^ARCIM(Subscript,Version,1)),"^",2) 
    ..s Abbrev=$p($g(^ARCIM(Subscript,Version,1)),"^",3) 
    ..i (Abbrev="")||(Abbrev="1")  s Abbrev=ItmMastDesc
    ..i OrdEntDR'=""  d  //如果下的是医嘱套
    ...s OEORDRowId=$p(OrdEntDR,"||",1)
    ...s OEORNChildsub=$p(OrdEntDR,"||",2)
    ...s OrderSetsDR=$p($g(^OEORD(OEORDRowId,"N",OEORNChildsub)),"^",1)
    ...i OrderSetsDR'=""  s ARCOSDesc=$p($g(^ARCOS(OrderSetsDR)),"^",2)  
    ...i ((ARCOSDesc="胸部正侧位(FSK)")||(ARCOSDesc="颈椎正侧位(FSK)")||(ARCOSDesc="胸部正位(FSK)")||(ARCOSDesc="腰椎正侧位(FSK)")||(ARCOSDesc="颈椎双斜位(FSK)")||(ARCOSDesc="双乳腺钼靶照像拍片(FSK)")) s Abbrev=ARCOSDesc
    ...i ARCOSDesc="彩超1(妇科120元)"  s Abbrev="妇科憋尿B超"
    ...i ARCOSDesc="彩超2(妇科180元)"  s Abbrev="妇科阴道B超" 
    ..i str=""  s str=Abbrev_"^"_PAPMINo_"^"_ SexDRName_"^"_Age_"^"_ Name_"^"_VIPDesc
  }
  else{

   s PIOIFPAuditDR="",PreIADM="", str="",ItmMastDesc="",PAPMINo="",SexDRName="",Age="", Name="",GroupFlag=""
   if FrontFlag="N"{
   s InvPrt=PAAdm
   s PAADMDR=$P(^DHCPEINVPRT(InvPrt),"^",2)
   s IADM=$O(^DHCPEIADM(0,"PAADM",PAADMDR,0))
   q:IADM=""
   s PreIADM=$P(^DHCPEIADM(IADM),"^",4)
   }
   else {
   s IADM=$O(^DHCPEIADM(0,"PAADM",PAAdm,0))
   q:IADM=""  }
   s c=$c(2)
   s CurData=$G(^DHCPEIADM(IADM))
   s AdmDate=$P(CurData,"^",5)
   s ArrDate=+AdmDate
   s:(""'=AdmDate) AdmDate=$ZD(AdmDate,3)
   s PreIADMDR=$P(CurData,"^",4)
   Q:(""=PreIADMDR) 
   s CurData=$G(^DHCPEPreIADM(PreIADMDR))
   s PGADMDR=$P(CurData,"^",2)
   i PGADMDR'=""  s GroupFlag="团体"
   else  s GroupFlag="个人" 
   s PIBIDR=$P(CurData,"^",1)
   Q:(""=PIBIDR) 
   s CurData=$G(^DHCPEPreIBI(PIBIDR))
   s PAPMINo=$p(CurData,"^",1)
   i ""'=PAPMINo  s PAPMINo=$Extract("00000000",1,8-$LENGTH(PAPMINo))_PAPMINo
   s BarRegNo="*"_PAPMINo_"*"
   s Name=$p(CurData,"^",2)
   s SexDR=$p(CurData,"^",3)
   s:(""'=SexDR) SexDRName=$p(^CT("SEX",SexDR),"^",2)
   s Dob=$p(CurData,"^",4)
   i Dob'="" s PAPERDob=$ZD(Dob,3)
   i ArrDate=0 s ArrDate=+$h
    s Age=""
    s:(""'=Dob) Age=##class(web.DHCLCNUREXCUTE).CalAge(Dob,ArrDate)
    s Age=$P(Age,"Y")
    s Age=Age_""_"岁"
   i CTLOCID="64"  s CTLOCDesc="特诊部体检"
   i CTLOCID="124"  s CTLOCDesc="体检中心"
   s Patstr="RegNo"_c_+PAPMINo_"^"_"Sex"_c_ SexDRName_"^"_"Age"_c_Age_"^"_"Name"_c_ Name_"^"_"GroupFlag"_c_ GroupFlag_"^"_"BarRegNo"_c_BarRegNo_"^"_"CTLOCDesc"_c_CTLOCDesc
   
   if FrontFlag="N"{
   s PBRowId=$P(^DHCPEINVPRT(InvPrt),"^",3)
   S PAPBRowId=0
   f  s PAPBRowId=$o(^DHCPEPAPBR(0,"PBDR",PBRowId,PAPBRowId)) q:PAPBRowId=""  d
   .s PIOIFPAuditDR=$p(^DHCPEPAPBR(PAPBRowId),"^",1)
   .s PIOIFPAuditDR=$p(^DHCPEPAPBR(PAPBRowId),"^",1)
   .i $d(^DHCPEPreIADM(0,"PAORDITEM",PIOIFPAuditDR,PreIADM))  d  //医嘱项
   ..s PIOIChildSub=0
   ..f  s PIOIChildSub=$o(^DHCPEPreIADM(0,"PAORDITEM",PIOIFPAuditDR,PreIADM,PIOIChildSub)) q:PIOIChildSub=""  d
   ...s ItmMastDR=$P($G(^DHCPEPreIADM(PreIADM,"ORDITEM",PIOIChildSub)),"^",1)
   ...s PIOIItemStat=$p($g(^DHCPEPreIADM(PreIADM,"ORDITEM",PIOIChildSub)),"^",16)
   ...q:PIOIItemStat=4
   ...s CRMOID=$O(^DHCPECRMO(0,"CRMORI",PreIADM_"||"_PIOIChildSub,0))
   ...Q:CRMOID="" 
   ...S OEOrderID=$P(^DHCPECRMO(CRMOID),"^",1)
   ...s STID=0
   ...s STID=$o(^DHCPEST(0,"STORD_ARCIM",ItmMastDR,0))
   ...Q:(""=STID)
   ...s STORDChildSub="0"
   ...s STORDChildSub=$O(^DHCPEST(0,"STORD_ARCIM",ItmMastDR,STID,STORDChildSub))
   ...Q:(""=STORDChildSub)
   ...//检验和材料医嘱退出
   ...q:("^"_RisStation_"^")'[("^"_STID_"^")
   ...//q:((LabStation=STID)||("^"_^DHCPESetting("DHCPE","StationId_Other")_"^"[("^"_STID_"^")))
   ...Q:$o(^DHCPEST(STID,"O",STORDChildSub,"STORDL",0))=""
   ...Q:($D(^DHCPECTDataEx("DHCPEStationOrderLoc","NoPrint",STID_"||"_STORDChildSub))&&('$d(^DHCPECTDataEx("DHCPEStationOrderLoc","NoPrint",STID_"||"_STORDChildSub,CTLOCID))))
   ...Q:$g(^DHCPECTDataEx("DHCPEStationOrderLoc","NoPrint",STID_"||"_STORDChildSub,CTLOCID))="N"
   ...s Subscript=$p(ItmMastDR,"||",1)
   ...s Version=$p(ItmMastDR,"||",2)
   ...s ItmMastDesc=$p($g(^ARCIM(Subscript,Version,1)),"^",2) 
   ...i str=""  s str=ItmMastDesc
   ...e  s str=str_";"_ItmMastDesc
   ...s ^DHCPEDataEx("OEOrderItem","PrintRisRequest",OEOrderID)="Y"
    
  .i $d(^DHCPEPreIADM(0,"PAORDENT",PIOIFPAuditDR,PreIADM))  d
  ..s Flag=0
  ..s PIOEChildSub=0
  ..s PIOEChildSub=$o(^DHCPEPreIADM(0,"PAORDENT",PIOIFPAuditDR,PreIADM,PIOEChildSub))  q:PIOEChildSub=""  d
  ..s OrdEntDR=PreIADM_"||"_PIOEChildSub
  ..q:OrdEntDR=""
  ..s ChildSub=0
  ..f  s ChildSub=$o(^DHCPEPreIADM(0,"OrdEnt",OrdEntDR,PreIADM,ChildSub)) q:(ChildSub="")||(Flag=1)  d
  ...s ItmMastDR=$P($G(^DHCPEPreIADM(PreIADM,"ORDITEM",ChildSub)),"^",1)
  ...s PIOIItemStat=$p($g(^DHCPEPreIADM(PreIADM,"ORDITEM",ChildSub)),"^",16)
  ...q:PIOIItemStat=4
  ...s CRMOID=$O(^DHCPECRMO(0,"CRMORI",PreIADM_"||"_ChildSub,0))
  ...Q:CRMOID="" 
  ...S OEOrderID=$P(^DHCPECRMO(CRMOID),"^",1)
  ...s STID=0
  ...s STID=$o(^DHCPEST(0,"STORD_ARCIM",ItmMastDR,0))
   ...Q:(""=STID)
   ...s STORDChildSub="0"
   ...s STORDChildSub=$O(^DHCPEST(0,"STORD_ARCIM",ItmMastDR,STID,STORDChildSub))
   ...Q:(""=STORDChildSub)
   ...//检验和材料医嘱退出
   ...Q:$o(^DHCPEST(STID,"O",STORDChildSub,"STORDL",0))=""
   ...q:("^"_RisStation_"^")'[("^"_STID_"^")
   ...Q:($D(^DHCPECTDataEx("DHCPEStationOrderLoc","NoPrint",STID_"||"_STORDChildSub))&&('$d(^DHCPECTDataEx("DHCPEStationOrderLoc","NoPrint",STID_"||"_STORDChildSub,CTLOCID))))
   ...Q:$g(^DHCPECTDataEx("DHCPEStationOrderLoc","NoPrint",STID_"||"_STORDChildSub,CTLOCID))="N"
   ...s Subscript=$p(ItmMastDR,"||",1)
   ...s Version=$p(ItmMastDR,"||",2)
   ...s ItmMastDesc=$p($g(^ARCIM(Subscript,Version,1)),"^",2) 
   ...i str=""  s str=ItmMastDesc
   ...e  s str=str_";"_ItmMastDesc
   ...s ^DHCPEDataEx("OEOrderItem","PrintRisRequest",OEOrderID)="Y"
    
   }
   else
   { 
    s PreiordID=0
    i OEItemID=""  d
    .f  s PreiordID=$o(^DHCPEPreIADM(PreIADMDR,"ORDITEM",PreiordID))  Q:PreiordID=""  d
    ..s PIOIItemStat=$p($g(^DHCPEPreIADM(PreIADMDR,"ORDITEM",PreiordID)),"^",16)
    ..q:PIOIItemStat=4
    ..s ItmMastDR=$p($g(^DHCPEPreIADM(PreIADMDR,"ORDITEM",PreiordID)),"^",1)
    ..s OrdEntDR=$p($g(^DHCPEPreIADM(PreIADMDR,"ORDITEM",PreiordID)),"^",2)
    ..s CRMOID=$O(^DHCPECRMO(0,"CRMORI",PreIADMDR_"||"_PreiordID,0))
    ..Q:CRMOID="" 
    ..S OEOrderID=$P(^DHCPECRMO(CRMOID),"^",1)
    ..Q:$P($G(^OEORD($P(OEOrderID,"||",1),"I",$P(OEOrderID,"||",2),3)),"^",5)'="P"
    ..s STID=0
    ..s STID=$o(^DHCPEST(0,"STORD_ARCIM",ItmMastDR,0))
    ..Q:(("^"_^DHCPESetting("DHCPE","StationId_Ris")_"^")'[("^"_STID_"^"))
    ..s STORDChildSub="0"
    ..s STORDChildSub=$O(^DHCPEST(0,"STORD_ARCIM",ItmMastDR,STID,STORDChildSub))
    ..Q:(""=STORDChildSub)
    ..q:(BDFlag="Y")&&('$d(^DHCPEDataEx("OEOrderItem","PrintRisRequest",OEOrderID)))
    ..q:(BDFlag="N")&&($d(^DHCPEDataEx("OEOrderItem","PrintRisRequest",OEOrderID)))
    ..Q:$o(^DHCPEST(STID,"O",STORDChildSub,"STORDL",0))=""
    ..Q:($D(^DHCPECTDataEx("DHCPEStationOrderLoc","NoPrint",STID_"||"_STORDChildSub))&&('$d(^DHCPECTDataEx("DHCPEStationOrderLoc","NoPrint",STID_"||"_STORDChildSub,CTLOCID))))
    ..Q:$g(^DHCPECTDataEx("DHCPEStationOrderLoc","NoPrint",STID_"||"_STORDChildSub,CTLOCID))="N"
    ..s Subscript=$p(ItmMastDR,"||",1)
    ..s Version=$p(ItmMastDR,"||",2)
    ..s ItmMastDesc=$p($g(^ARCIM(Subscript,Version,1)),"^",2) 
    ..i str=""  s str=ItmMastDesc
    ..e  s str=str_";"_ItmMastDesc
    ..s ^DHCPEDataEx("OEOrderItem","PrintRisRequest",OEOrderID)="Y"

    e  d        //当打印单个检查标签
    .s OEORDRowId= $p(OEItemID,"||",1)
    .s OEORIChildsub=$p(OEItemID,"||",2)
    .Q:$P($G(^OEORD($P(OEItemID,"||",1),"I",$P(OEItemID,"||",2),3)),"^",5)'="P"
    .s ItmMastDR=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",2)
    .s Subscript=$p(ItmMastDR,"||",1)
    .s Version=$p(ItmMastDR,"||",2)
    .s STID=0
    .s STID=$o(^DHCPEST(0,"STORD_ARCIM",ItmMastDR,0))
    .s STORDChildSub="0"
    .s STORDChildSub=$O(^DHCPEST(0,"STORD_ARCIM",ItmMastDR,STID,STORDChildSub))
    .Q:(""=STORDChildSub)
    .Q:(BDFlag="Y")&&('$d(^DHCPEDataEx("OEOrderItem","PrintRisRequest",OEItemID)))
    .Q:(BDFlag="N")&&($d(^DHCPEDataEx("OEOrderItem","PrintRisRequest",OEItemID)))
    .Q:$o(^DHCPEST(STID,"O",STORDChildSub,"STORDL",0))=""
    .Q:($D(^DHCPECTDataEx("DHCPEStationOrderLoc","NoPrint",STID_"||"_STORDChildSub))&&('$d(^DHCPECTDataEx("DHCPEStationOrderLoc","NoPrint",STID_"||"_STORDChildSub,CTLOCID))))
    .Q:$g(^DHCPECTDataEx("DHCPEStationOrderLoc","NoPrint",STID_"||"_STORDChildSub,CTLOCID))="N"
    .s OrdEntDR=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",1)
    .s ItmMastDesc=$p($g(^ARCIM(Subscript,Version,1)),"^",2) 
    .i str=""  s str=ItmMastDesc
    .s ^DHCPEDataEx("OEOrderItem","PrintRisRequest",OEItemID)="Y"
    }
  }

 s str=str_"%"_Patstr
 q str
}
*/
ClassMethod GetAsChangedFlag(AdmId)
{
   q:AdmId="" "0"
    s PEIADM=$o(^DHCPEIADM(0,"PAADM",AdmId,0))
    s PreIADM=$p($G(^DHCPEIADM(PEIADM)),"^",4)
    s AsCharged=""                                                               
    s AsCharged=$P(^DHCPEPreIADM(PreIADM),"^",9)
}

ClassMethod GetOneRisItemInfo(ItmMastDR)
{
	s:$d(%session) CTLOCID=%session.Get("LOGON.CTLOCID")
    q:ItmMastDR="" ""
    s str=""
    //s RisStation=$g(^DHCPESetting("DHCPE","StationId_Ris"))
    //s LabStation=$g(^DHCPESetting("DHCPE","StationId_Lab"))
    s RisStation=$g(^DHCPESetting("DHCPE","StationId_Ris",CTLOCID))
    s LabStation=$g(^DHCPESetting("DHCPE","StationId_Lab",CTLOCID))

    s STID=0
      s STID=$o(^DHCPEST(0,"STORD_ARCIM",ItmMastDR,0))
      s str=STID_";"_LabStation_";"_RisStation
      q str
}

// 

ClassMethod GetGRisItemInfo(InvPrt, PAADM)
{
  
   k ^DHCPERisInfoTMP("PreIADM")
   s IADM=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
   q:IADM="" ""
   s PreIADM=$P(^DHCPEIADM(IADM),"^",4)
   Q:PreIADM="" ""
   do GetPatInfo
   s GroupStr=""
   s CTLOCID=$P($G(^PAADM(PAADM)),"^",4)

   i CTLOCID="" s CTLOCID=%session.Get("LOGON.CTLOCID")
   /*
   s LabStation=$g(^DHCPESetting("DHCPE","StationId_Lab"))
   s RisStation=$g(^DHCPESetting("DHCPE","StationId_Ris"))
   s HosCode=$g(^DHCPESetting("DHCPE","HospitalCode"))
   */
    s LabStation=$g(^DHCPESetting("DHCPE","StationId_Lab",CTLOCID))
   s RisStation=$g(^DHCPESetting("DHCPE","StationId_Ris",CTLOCID))
   s HosCode=$g(^DHCPESetting("DHCPE","HospitalCode",CTLOCID))
 

   s PBRowId=$P(^DHCPEINVPRT(InvPrt),"^",3)
   S PAPBRowId=0
   f  s PAPBRowId=$o(^DHCPEPAPBR(0,"PBDR",PBRowId,PAPBRowId)) q:PAPBRowId=""  d
   .s PIOIFPAuditDR=$p(^DHCPEPAPBR(PAPBRowId),"^",1)
   .s PIOIChildSub=0
   .f  s PIOIChildSub=$o(^DHCPEPreIADM(0,"PAORDITEM",PIOIFPAuditDR,PreIADM,PIOIChildSub)) q:PIOIChildSub=""  d
   ..s ItmMastDR=$P($G(^DHCPEPreIADM(PreIADM,"ORDITEM",PIOIChildSub)),"^",1)
   ..s PIOIItemStat=$p($g(^DHCPEPreIADM(PreIADM,"ORDITEM",PIOIChildSub)),"^",16)
   ..q:PIOIItemStat=4
   ..s STID=0
   ..s STID=$o(^DHCPEST(0,"STORD_ARCIM",ItmMastDR,0))
   ..Q:(""=STID)
   ..s STORDChildSub="0"
   ..s STORDChildSub=$O(^DHCPEST(0,"STORD_ARCIM",ItmMastDR,STID,STORDChildSub))
   ..Q:(""=STORDChildSub)
   ..//检验和材料医嘱退出
   ..q:((LabStation=STID)||("^"_^DHCPESetting("DHCPE","StationId_Other")_"^"[("^"_STID_"^")))
   ..Q:($D(^DHCPECTDataEx("DHCPEStationOrderLoc","NoPrint",STID_"||"_STORDChildSub))&&('$d(^DHCPECTDataEx("DHCPEStationOrderLoc","NoPrint",STID_"||"_STORDChildSub,CTLOCID))))
   ..Q:$g(^DHCPECTDataEx("DHCPEStationOrderLoc","NoPrint",STID_"||"_STORDChildSub,CTLOCID))="N"
   ..s Subscript=$p(ItmMastDR,"||",1)
   ..s Version=$p(ItmMastDR,"||",2)
   ..s ItmMastDesc=$p($g(^ARCIM(Subscript,Version,1)),"^",2) 
   ..s ^DHCPERisInfoTMP("PreIADM",PreIADM,ItmMastDR)=ItmMastDesc
  
   .S PIOEChildSub=""
   .F  s PIOEChildSub=$o(^DHCPEPreIADM(0,"PAORDENT",PIOIFPAuditDR,PreIADM,PIOEChildSub))  q:PIOEChildSub=""  d
   ..s OrdEntDR=PreIADM_"||"_PIOEChildSub
   ..s ChildSub=0
   ..f  s ChildSub=$o(^DHCPEPreIADM(0,"OrdEnt",OrdEntDR,PreIADM,ChildSub)) q:(ChildSub="")||(Flag=1)  d
   ...s ItmMastDR=$P($G(^DHCPEPreIADM(PreIADM,"ORDITEM",ChildSub)),"^",1)
   ...s PIOIItemStat=$p($g(^DHCPEPreIADM(PreIADM,"ORDITEM",PIOIChildSub)),"^",16)
   ...q:PIOIItemStat=4
   ...s STID=0
   ...s STID=$o(^DHCPEST(0,"STORD_ARCIM",ItmMastDR,0))
   ...Q:(""=STID)
   ...s STORDChildSub="0"
   ...s STORDChildSub=$O(^DHCPEST(0,"STORD_ARCIM",ItmMastDR,STID,STORDChildSub))
   ...Q:(""=STORDChildSub)
   ...//检验和材料医嘱退出
   ...q:((LabStation=STID)||("^"_^DHCPESetting("DHCPE","StationId_Other")_"^"[("^"_STID_"^")))
   ...Q:($D(^DHCPECTDataEx("DHCPEStationOrderLoc","NoPrint",STID_"||"_STORDChildSub))&&('$d(^DHCPECTDataEx("DHCPEStationOrderLoc","NoPrint",STID_"||"_STORDChildSub,CTLOCID))))
   ...Q:$g(^DHCPECTDataEx("DHCPEStationOrderLoc","NoPrint",STID_"||"_STORDChildSub,CTLOCID))="N"
   ...s Subscript=$p(ItmMastDR,"||",1)
   ...s Version=$p(ItmMastDR,"||",2)
   ...s ItmMastDesc=$p($g(^ARCIM(Subscript,Version,1)),"^",2) 
   ...s ^DHCPERisInfoTMP("PreIADM",PreIADM,ItmMastDR)=ItmMastDesc
   
   s Str="",ItemStr="",IADMBaseInfo=""
   s IADMBaseInfo=$g(^DHCPERisInfoTMP("BaseInfo"))
   s PIADM=0
   f  s PIADM=$o(^DHCPERisInfoTMP("PreIADM",PIADM))  q:PIADM=""  d
   .s ItmMastDR=0
   .f  s ItmMastDR=$o(^DHCPERisInfoTMP("PreIADM",PIADM,ItmMastDR))  q:ItmMastDR=""  d
   ..s ItmMastDesc=$g(^DHCPERisInfoTMP("PreIADM",PIADM,ItmMastDR))
   ..i ItemStr=""  s ItemStr=ItmMastDesc
   ..else  s ItemStr=ItemStr_";"_ItmMastDesc
   
   s Str=ItemStr_"%"_IADMBaseInfo

 q Str
GetPatInfo
   s PAPMINo="",SexDRName="",Age="",Name="",GroupFlag="",BarRegNo="",Patstr=""
   s CurData=$G(^DHCPEPreIADM(PreIADM))
   s IADM=$O(^DHCPEIADM(0,"CRMADM",PreIADM,0))
   S IADMPAADMDR=$P(^DHCPEIADM(IADM),"^",1)
   Q:IADMPAADMDR'=PAADM
   s PGADMDR=$P(CurData,"^",2)
   s c=$c(2)
   i PGADMDR'=""  s GroupFlag="团体"
   else  s GroupFlag="个人" 
   s PIBIDR=$P(CurData,"^",1)
   Q:(""=PIBIDR) 
   s CurData=$G(^DHCPEPreIBI(PIBIDR))
   s PAPMINo=$p(CurData,"^",1)
   i ""'=PAPMINo  s PAPMINo=##class(web.DHCPE.DHCPECommon).RegNoMask(PAPMINo) //$Extract("00000000",1,8-$LENGTH(PAPMINo))_PAPMINo
   s BarRegNo="*"_PAPMINo_"*"
   s Name=$p(CurData,"^",2)
   s SexDR=$p(CurData,"^",3)
   s:(""'=SexDR) SexDRName=$p(^CT("SEX",SexDR),"^",2)
   s Dob=$p(CurData,"^",4)
   i Dob'="" s PAPERDob=$ZD(Dob,3)
   s ArrDate=+$h
   s Age=""
   s:(""'=Dob) Age=##class(web.DHCLCNUREXCUTE).CalAge(Dob,ArrDate)
   s Age=$P(Age,"Y")
   s Age=Age_""_"岁"
   s Patstr="RegNo"_c_PAPMINo_"^"_"Sex"_c_ SexDRName_"^"_"Age"_c_Age_"^"_"Name"_c_ Name_"^"_"GroupFlag"_c_ GroupFlag_"^"_"BarRegNo"_c_BarRegNo
   S ^DHCPERisInfoTMP("BaseInfo")=Patstr
}

// w ##class(web.DHCPE.BarPrint).GetRisItemInfo("1063^982||3")

ClassMethod GetRisItemInfo(Instring)
{

   s c=$c(2)
     s PAAdm=$p(Instring,"^",1)
    s CTLOCID=$P($G(^PAADM(PAAdm)),"^",4)
   /*
   s LabStation=$g(^DHCPESetting("DHCPE","StationId_Lab"))
   s RisStation=$g(^DHCPESetting("DHCPE","StationId_Ris"))
   s OtherStation=$g(^DHCPESetting("DHCPE","StationId_Other"))
  */
  s LabStation=$g(^DHCPESetting("DHCPE","StationId_Lab",CTLOCID))
   s RisStation=$g(^DHCPESetting("DHCPE","StationId_Ris",CTLOCID))
   s OtherStation=$g(^DHCPESetting("DHCPE","StationId_Other",CTLOCID))

   s PAAdm=$p(Instring,"^",1)
   s OEItemID=$p(Instring,"^",2)
   s flag=1
   s ret=""
   s str=""
   s IADMDR=0
   s OrdEntDR=""
   s ARCOSDesc=""
   s Abbrev=""
   s str=""
   f  s IADMDR=$o(^DHCPEIADM(0,"PAADM",PAAdm,IADMDR))  q:IADMDR=""  d 
    .s CurData=$G(^DHCPEIADM(IADMDR))
    .s AdmDate=$P(CurData,"^",5)
    .s ArrDate=+AdmDate
    .s:(""'=AdmDate) AdmDate=$ZD(AdmDate,3)
    .s PreIADMDR=$P(CurData,"^",4)
    .Q:(""=PreIADMDR) 
    .s CurData=$G(^DHCPEPreIADM(PreIADMDR))
    .s PIBIDR=$P(CurData,"^",1)
    .Q:(""=PIBIDR) 
    .s CurData=$G(^DHCPEPreIBI(PIBIDR))
    .s PAPMINo=$p(CurData,"^",1)
    .i ""'=PAPMINo  s PAPMINo=##class(web.DHCPE.DHCPECommon).RegNoMask(PAPMINo) //$Extract("00000000",1,8-$LENGTH(PAPMINo))_PAPMINo
    .s Name=""
    .s Name=$p(CurData,"^",2)
    .s SexDR=$p(CurData,"^",3)
    .s:(""'=SexDR) SexDRName=$p(^CT("SEX",SexDR),"^",2)
    .s Dob=$p(CurData,"^",4)
    .i Dob'="" s PAPERDob=$ZD(Dob,3)
    .i ArrDate=0 s ArrDate=+$h
    .s Age=""
    .s:(""'=Dob) Age=##class(web.DHCLCNUREXCUTE).CalAge(Dob,ArrDate)
    .s Age=$P(Age,"Y")
    .s Age=Age_""_"岁"
    .s PreiordID=0
    .i OEItemID=""  d
    ..f  s PreiordID=$o(^DHCPEPreIADM(PreIADMDR,"ORDITEM",PreiordID))  Q:PreiordID=""  d
    ...s PIOIItemStat=$p($g(^DHCPEPreIADM(PreIADMDR,"ORDITEM",PreiordID)),"^",16)
    ...q:PIOIItemStat'=1
    ...s ItmMastDR=$p($g(^DHCPEPreIADM(PreIADMDR,"ORDITEM",PreiordID)),"^",1)
    ...s OrdEntDR=$p($g(^DHCPEPreIADM(PreIADMDR,"ORDITEM",PreiordID)),"^",2)
    ...s STID=0
    ...s STID=$o(^DHCPEST(0,"STORD_ARCIM",ItmMastDR,0))
    ...Q:(("^"_OtherStation_"^")[("^"_STID_"^"))
    ...s Subscript=$p(ItmMastDR,"||",1)
    ...s Version=$p(ItmMastDR,"||",2)
    ...s ItmMastDesc=$p($g(^ARCIM(Subscript,Version,1)),"^",2) 
    ...s Abbrev=$p($g(^ARCIM(Subscript,Version,1)),"^",3) 
    ...i (Abbrev="")||(Abbrev="1")  s Abbrev=ItmMastDesc
    ...s QUITStr="^",ARCOSDR=""
    ...i OrdEntDR'=""  s ARCOSDR=$p($g(^DHCPEPreIADM($p(OrdEntDR,"||",1),"ORDENT",$p(OrdEntDR,"||",2))),"^",1)
    ...i ARCOSDR'=""  s QUITStr=..GetOrdSetsFlag(ARCOSDR,ItmMastDR)
    ...q:$p(QUITStr,"^",1)=1
    ...i $p(QUITStr,"^",2)'=""  s Abbrev=$p(QUITStr,"^",2)
    ...i str=""  s str="ItemDesc"_c_Abbrev_"^"_"RegNo"_c_PAPMINo_"^"_ "Sex"_c_ SexDRName_"^"_"Age"_c_Age_"^"_"Name"_c_  Name_"^"_"BarRegNo"_c_  PAPMINo
    ...e  s str=str_";"_"ItemDesc"_c_Abbrev_"^"_"RegNo"_c_PAPMINo_"^"_ "Sex"_c_ SexDRName_"^"_"Age"_c_Age_"^"_"Name"_c_  Name_"^"_"BarRegNo"_c_  PAPMINo

    .e  d        //当打印单个检查标签
    ..s OEORDRowId= $p(OEItemID,"||",1)
    ..s OEORIChildsub=$p(OEItemID,"||",2)
    ..s ItmMastDR=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",2)
    ..s Subscript=$p(ItmMastDR,"||",1)
    ..s Version=$p(ItmMastDR,"||",2)
    ..s STID=0
    ..s STID=$o(^DHCPEST(0,"STORD_ARCIM",ItmMastDR,0))
    ..Q:(("^"_OtherStation_"^")[("^"_STID_"^"))
    ..s OrdEntDR=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",1)
    ..s ItmMastDesc=$p($g(^ARCIM(Subscript,Version,1)),"^",2) 
    ..s Abbrev=$p($g(^ARCIM(Subscript,Version,1)),"^",3) 
    ..i (Abbrev="")||(Abbrev="1")  s Abbrev=ItmMastDesc
    ..s QUITStr="^",ARCOSDR=""
    ..i OrdEntDR'=""  s ARCOSDR=$p($g(^DHCPEPreIADM($p(OrdEntDR,"||",1),"ORDENT",$p(OrdEntDR,"||",2))),"^",1)
    ..i ARCOSDR'=""  s QUITStr=..GetOrdSetsFlag(ARCOSDR,ItmMastDR)
    ..q:$p(QUITStr,"^",1)=1
    ..i $p(QUITStr,"^",2)'=""  s Abbrev=$p(QUITStr,"^",2)
    ..i str=""  s str="ItemDesc"_c_Abbrev_"^"_"RegNo"_c_PAPMINo_"^"_ "Sex"_c_ SexDRName_"^"_"Age"_c_Age_"^"_"Name"_c_  Name_"^"_"BarRegNo"_c_  PAPMINo
    q str
}

/* 友谊
ClassMethod GetRisItemInfo(Instring)
{
   k ^DHCPETMPOrdSets("HasPrint")
   //s LocID=%session.Get("LOGON.CTLOCID")969
   s LabStation=$g(^DHCPESetting("DHCPE","StationId_Lab"))
   s RisStation=$g(^DHCPESetting("DHCPE","StationId_Ris"))
   s ^Vickytest("GetRisItemInfo","Instring")=Instring
   s PAAdm=$p(Instring,"^",1)
   s OEItemID=$p(Instring,"^",5)
   s flag=1
   s ret=""
   s str=""
   s IADMDR=0
   s OrdEntDR=""
   s ARCOSDesc=""
   s Abbrev=""
   s str=""
   f  s IADMDR=$o(^DHCPEIADM(0,"PAADM",PAAdm,IADMDR))  q:IADMDR=""  d 
    .s CurData=$G(^DHCPEIADM(IADMDR))
    .s AdmDate=$P(CurData,"^",5)
    .s ArrDate=+AdmDate
    .s:(""'=AdmDate) AdmDate=$ZD(AdmDate,3)
    .s PreIADMDR=$P(CurData,"^",4)
    .Q:(""=PreIADMDR) 
    .s CurData=$G(^DHCPEPreIADM(PreIADMDR))
    .s PIBIDR=$P(CurData,"^",1)
    .Q:(""=PIBIDR) 
    .s CurData=$G(^DHCPEPreIBI(PIBIDR))
    .s PAPMINo=$p(CurData,"^",1)
    .i ""'=PAPMINo  s PAPMINo=$Extract("00000000",1,8-$LENGTH(PAPMINo))_PAPMINo
    .s Name=""
    .s Name=$p(CurData,"^",2)
    .s SexDR=$p(CurData,"^",3)
    .s:(""'=SexDR) SexDRName=$p(^CT("SEX",SexDR),"^",2)
    .s Dob=$p(CurData,"^",4)
    .i Dob'="" s PAPERDob=$ZD(Dob,3)
    .i ArrDate=0 s ArrDate=+$h
    .s Age=""
    .s:(""'=Dob) Age=##class(web.DHCLCNUREXCUTE).CalAge(Dob,ArrDate)
    .s Age=$P(Age,"Y")
    .s Age=Age_""_"岁"
    .s VIPDesc=""
    .i PreIADMDR'=""  s VIPID=$p($g(^DHCPEPreIADM(PreIADMDR)),"^",18)
    .i VIPID'=""   d
    ..s VIPStr=$g(^DHCPEVIPLevel("VIP",VIPID))
    ..s VIPDesc=$p(VIPStr,"^",2)
    ..i VIPDesc="特需"  s VIPDesc="T"
    ..i VIPDesc="干部"  s VIPDesc="G"
    .s PreiordID=0
    .i OEItemID=""  d
    ..f  s PreiordID=$o(^DHCPEPreIADM(PreIADMDR,"ORDITEM",PreiordID))  Q:PreiordID=""  d
    ...s PIOIItemStat=$p($g(^DHCPEPreIADM(PreIADMDR,"ORDITEM",PreiordID)),"^",16)
    ...q:PIOIItemStat=4
    ...s ItmMastDR=$p($g(^DHCPEPreIADM(PreIADMDR,"ORDITEM",PreiordID)),"^",1)
    ...s OrdEntDR=$p($g(^DHCPEPreIADM(PreIADMDR,"ORDITEM",PreiordID)),"^",2)
    ...s STID=0
    ...s STID=$o(^DHCPEST(0,"STORD_ARCIM",ItmMastDR,0))
    ...Q:(("^"_^DHCPESetting("DHCPE","StationId_Ris")_"^")'[("^"_STID_"^"))
    ...s Subscript=$p(ItmMastDR,"||",1)
    ...s Version=$p(ItmMastDR,"||",2)
    ...s ItmMastDesc=$p($g(^ARCIM(Subscript,Version,1)),"^",2) 
    ...s Abbrev=$p($g(^ARCIM(Subscript,Version,1)),"^",3) 
    ...i (Abbrev="")||(Abbrev="1")  s Abbrev=ItmMastDesc
    ...s QUITStr="^",ARCOSDR=""
    ...i OrdEntDR'=""  s ARCOSDR=$p($g(^DHCPEPreIADM($p(OrdEntDR,"||",1),"ORDENT",$p(OrdEntDR,"||",2))),"^",1)
    ...i ARCOSDR'=""  s QUITStr=..GetOrdSetsFlag(ARCOSDR,ItmMastDR)
    ...q:$p(QUITStr,"^",1)=1
    ...i $p(QUITStr,"^",2)'=""  s Abbrev=$p(QUITStr,"^",2)
    ...i str=""  s str=Abbrev_"^"_PAPMINo_"^"_ SexDRName_"^"_Age_"^"_ Name_"^"_ VIPDesc
    ...e  s str=str_";"_Abbrev_"^"_PAPMINo_"^"_ SexDRName_"^"_Age_"^"_ Name_"^"_ VIPDesc

    .e  d        //当打印单个检查标签
    ..s OEORDRowId= $p(OEItemID,"||",1)
    ..s OEORIChildsub=$p(OEItemID,"||",2)
    ..s ItmMastDR=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",2)
    ..s Subscript=$p(ItmMastDR,"||",1)
    ..s Version=$p(ItmMastDR,"||",2)
    ..s STID=0
    ..s STID=$o(^DHCPEST(0,"STORD_ARCIM",ItmMastDR,0))
    ..Q:(("^"_^DHCPESetting("DHCPE","StationId_Ris")_"^")'[("^"_STID_"^"))
    ..s OrdEntDR=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",1)
    ..s ItmMastDesc=$p($g(^ARCIM(Subscript,Version,1)),"^",2) 
    ..s Abbrev=$p($g(^ARCIM(Subscript,Version,1)),"^",3) 
    ..i (Abbrev="")||(Abbrev="1")  s Abbrev=ItmMastDesc
    ..s QUITStr="^",ARCOSDR=""
    ..i OrdEntDR'=""  s ARCOSDR=$p($g(^DHCPEPreIADM($p(OrdEntDR,"||",1),"ORDENT",$p(OrdEntDR,"||",2))),"^",1)
    ..i ARCOSDR'=""  s QUITStr=..GetOrdSetsFlag(ARCOSDR,ItmMastDR)
    ..q:$p(QUITStr,"^",1)=1
    ..i $p(QUITStr,"^",2)'=""  s Abbrev=$p(QUITStr,"^",2)
    ..i str=""  s str=Abbrev_"^"_PAPMINo_"^"_ SexDRName_"^"_Age_"^"_ Name_"^"_VIPDesc

    q str
}
*/
/// [Previously private]
ClassMethod GetOrdSetsFlag(ParARCOSID, ItemID)
{
 s ARCOSRowId=0,OSEOrdSetsDRName="",HasFlag=0
 f  s ARCOSRowId=$o(^DHCPETMPOrdSets(ParARCOSID,ItemID,ARCOSRowId))  q:ARCOSRowId=""  d
 .i $d(^DHCPETMPOrdSets("HasPrint",ARCOSRowId))  s HasFlag=1
 .q:HasFlag=1 
 .s OSEOrdSetsDRName=$g(^DHCPEDataEx("OrdSetsEx","OrdSetsOEItemAbbre",ARCOSRowId))
 .s ^DHCPETMPOrdSets("HasPrint",ARCOSRowId)="Y"

 
 Q HasFlag_"^"_OSEOrdSetsDRName
}

// w ##class(web.DHCPE.BarPrint).GetECGExistFlag("1103")

/// 得到心电图信息 for复兴
ClassMethod GetECGExistFlag(AdmId)
{
    S ParInfo="",RegNo="",PatName="",PatAge="",PatSexName="",PatGroupName=""
    q:AdmId="" ""
    s IADMDR=$O(^DHCPEIADM(0,"PAADM",AdmId,0))
    q:IADMDR="" 0
    s PreAdmId=$P(^DHCPEIADM(IADMDR),"^",4)
    s ItemFlag=0
    s ChildSub=0
    f  s ChildSub=$o(^DHCPEPreIADM(PreAdmId,"ORDITEM",ChildSub)) q:ChildSub=""  d
    .s ItmMastDR=$p($g(^DHCPEPreIADM(PreAdmId,"ORDITEM",ChildSub)),"^",1)
    .s ItmStat=$p($g(^DHCPEPreIADM(PreAdmId,"ORDITEM",ChildSub)),"^",16)
    .//i ((ItmMastDR="4212||1")&&(ItmStat="1")) s ItemFlag=1
    //q:ItemFlag=0 ""
    s ParInfo=..GetPatInfo(AdmId)
    s RegNo=$P(ParInfo,"^",4)       // 登记号
    s PatName = $P(ParInfo,"^",1)   // 姓名
    s PatAge = $P(ParInfo,"^",2)    // 年龄
    s PatMarry = $P(ParInfo,"^",9)  // 婚姻
    s PatGroup = $P(ParInfo,"^",6) //单位
    s PatSexName = $P(ParInfo,"^",3) //性别
    i PatGroup'=""  d
     .s Group=$p(PatGroup,"分组:",1)
     .s PatGroupName=$p(Group,"单位:",2)
    s PatAge=$tr(PatAge," ")
    s ParInfo=RegNo_"^"_PatName_"^"_PatAge_"^"_PatSexName_"^"_PatGroupName
    q ParInfo
}

/*
/// 2008-07-01  zhouli
/// 个人预约查询界面打印检查标签
/// d ##class(web.DHCPE.BarPrint).GetPreRisItemInfo("398")
ClassMethod GetPreRisItemInfo(PreIADM)
{
   k ^DHCPETMPOrdSets("HasPrint")
   //Set LocID=%session.Get("LOGON.CTLOCID")
   s flag=1
   s OrdEntDR=""
   s RisStation=$g(^DHCPESetting("DHCPE","StationId_Ris"))
   s LabStation=$g(^DHCPESetting("DHCPE","StationId_Lab"))
   s str=""
   s PIBIDR=$P($g(^DHCPEPreIADM(PreIADM)),"^",1)
  // w !,PIBIDR
   q:PIBIDR=""
   s CurData=$G(^DHCPEPreIBI(PIBIDR))
   s PAPMINo=$p(CurData,"^",1)
   i ""'=PAPMINo  s PAPMINo=$Extract("00000000",1,8-$LENGTH(PAPMINo))_PAPMINo
   s SexDR=$p(CurData,"^",3)
   s Name=$p(CurData,"^",2)
   s:(""'=SexDR) SexDRName=$p(^CT("SEX",SexDR),"^",2)
   s Dob=$p(CurData,"^",4)
   i Dob'="" s PAPERDob=$ZD(Dob,3)
   s ArrDate=+$h
   s Age=""
   s:(""'=Dob) Age=##class(web.DHCLCNUREXCUTE).CalAge(Dob,ArrDate)
   s Age=$P(Age,"Y")
   s Age=Age_""_"岁"
    s VIPDesc=""
    i PreIADM'=""  s VIPID=$p($g(^DHCPEPreIADM(PreIADM)),"^",18)
    i VIPID'=""   d
    .s VIPStr=$g(^DHCPEVIPLevel("VIP",VIPID))
    .s VIPDesc=$p(VIPStr,"^",2)
    .i VIPDesc="特需"  s VIPDesc="T"
    .i VIPDesc="干部"  s VIPDesc="G"
    s PreiordID=0
    f  s PreiordID=$o(^DHCPEPreIADM(PreIADM,"ORDITEM",PreiordID))  Q:PreiordID=""  d
    .s PIOIItemStat=$p($g(^DHCPEPreIADM(PreIADM,"ORDITEM",PreiordID)),"^",16)
    .q:PIOIItemStat=4
    .s ItmMastDR=$p($g(^DHCPEPreIADM(PreIADM,"ORDITEM",PreiordID)),"^",1)
    .s OrdEntDR=$p($g(^DHCPEPreIADM(PreIADM,"ORDITEM",PreiordID)),"^",2)
    .s STID=0
    .s STID=$o(^DHCPEST(0,"STORD_ARCIM",ItmMastDR,0))
    .Q:(("^"_^DHCPESetting("DHCPE","StationId_Ris")_"^")'[("^"_STID_"^"))
    .s Subscript=$p(ItmMastDR,"||",1)
    .s Version=$p(ItmMastDR,"||",2)
    .s ItmMastDesc=$p($g(^ARCIM(Subscript,Version,1)),"^",2) 
    .s Abbrev=$p($g(^ARCIM(Subscript,Version,1)),"^",3) 
    .i (Abbrev="")||(Abbrev="1")  s Abbrev=ItmMastDesc
    .s QUITStr="^",ARCOSDR=""
    .i OrdEntDR'=""  s ARCOSDR=$p($g(^DHCPEPreIADM($p(OrdEntDR,"||",1),"ORDENT",$p(OrdEntDR,"||",2))),"^",1)
    .i ARCOSDR'=""  s QUITStr=..GetOrdSetsFlag(ARCOSDR,ItmMastDR)
    .q:$p(QUITStr,"^",1)=1
    .i $p(QUITStr,"^",2)'=""  s Abbrev=$p(QUITStr,"^",2)
    .i str=""  s str=Abbrev_"^"_PAPMINo_"^"_ SexDRName_"^"_Age_"^"_ Name_"^"_VIPDesc
    .e  s str=str_";"_Abbrev_"^"_PAPMINo_"^"_ SexDRName_"^"_Age_"^"_ Name_"^"_VIPDesc
    q str
}
*/

// 用于采集标本菜单

/// added by xy 20201014
/// function:根据就诊ID查找信息
/// w ##class(web.DHCPE.BarPrint).IsCurDateByPAADM()
ClassMethod IsCurDateByPAADM(PAADM)
{
    s Flag=""
    Q:PAADM="" ""
    s IADM=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
    q:IADM="" "0^没有对应的就诊信息"
    q ..GetStatusInfoByIADM(PAADM,"1")
}

/// added by xy 20201014 
/// function:根据标本号查找信息
/// w ##class(web.DHCPE.BarPrint).IsCurDateBySpecNo()
ClassMethod IsCurDateBySpecNo(SpecNo)
{
    s Flag=""
    s OEORD=$o(^OEORD(0,"EpisNo",SpecNo,0))
    q:OEORD="" "0^输入的检验号不正确"
    s PAADM=$p(^OEORD(OEORD),"^",1)
    q:PAADM="" "0^该标本号没有对应的就诊信息"
    s IADM=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
    q:IADM="" "0^该标本号没有对应的就诊信息"
    q ..GetStatusInfoByIADM(PAADM,"0")
}

ClassMethod GetStatusInfoByIADM(PAADM, RegNoFlag)
{
    s IADM=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
    s Status=$p($g(^DHCPEIADM(IADM)),"^",8)
    i Status="REGISTERED"
    {
        //第一个为医生界面自动到达\第二个为打印条码自动到达\第三个是标本采集
        s AutoArrived=$G(^DHCPESetting("DHCPE","AutoArrived",%session.Get("LOGON.CTLOCID")))
        s AutoArrived=$p(AutoArrived,"^",3)
        i AutoArrived="Y" d
        .s PreIADM=$p(^DHCPEIADM(IADM),"^",4)
        .d ##class(web.DHCPE.DHCPEIAdm).IAdmArrived(PreIADM)
    }
    
    s IADMDate=$p(^DHCPEIADM(IADM),"^",5)
    s CurRoomInfo=$P(##class(web.DHCPE.RoomManager).GetAdmCurRoom(PAADM,"ADM",""),"^",1)
    s Status=""
    s DetailStatus=""
    i CurRoomInfo'="" d
    .s Status=$LG(^User.DHCPEAdmRoomRecordD(CurRoomInfo),7)
    .s DetailStatus=$LG(^User.DHCPEAdmRoomRecordD(CurRoomInfo),9)
    i IADMDate'=+$H  q "1^"_CurRoomInfo_"^"_PAADM_"^"_RegNoFlag_"^"_Status_"^"_DetailStatus
    q Flag_"^"_CurRoomInfo_"^"_PAADM_"^"_RegNoFlag_"^"_Status_"^"_DetailStatus
}

/// added by xy 20201014 
/// function:根据登记号查找可以可以采集标本的记录
/// w ##class(web.DHCPE.BarPrint).GetSaveCollectRecord()
ClassMethod GetSaveCollectRecord(RegNo)
{
    Q:RegNo="" ""
    
    s PIBI=$o(^DHCPEPreIBI(0,"PAPMINo",RegNo,0))
    q:PIBI="" "-1^无该人员的基本信息!"
    S PAADMStr=""
    s PIADM="" 
    f  s PIADM=$o(^DHCPEPreIADM(0,"PIBI",PIBI,PIADM),-1) q:(PIADM="")  d
    .s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PreADM",PIADM) 
    .q:LocFlag=1 
    .s Status=$P(^DHCPEPreIADM(PIADM),"^", 8)
    .q:(Status'="REGISTERED")&&((Status'="ARRIVED"))
    .S IADM=""
    .s IADM=$O(^DHCPEIADM(0,"CRMADM",PIADM,0))
    .q:IADM="" 
    .s PAADM=$P(^DHCPEIADM(IADM),"^",1)
    .i PAADMStr="" s PAADMStr=PAADM_"$"
    .e  s PAADMStr=PAADMStr_PAADM_"$"
    q "0^"_PAADMStr
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.BarPrint","FindPAADMInfo","")
Query FindPAADMInfo(RegNo As %String = "", HospID As %String = "") As websys.Query(ROWSPEC = "PAADM:%String,RegNo:%String,Name:%String,HPNo:%String,AdmDate:%String,StatusDesc:%String,GName:%String,TeamName:%String")
{
}

ClassMethod FindPAADMInfoExecute(ByRef qHandle As %Binary, RegNo As %String = "", HospID As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 

    s PIBI=$o(^DHCPEPreIBI(0,"PAPMINo",RegNo,0)) 
    if (""=PIBI) {
        Set qHandle=$lb(0,repid,0)
        Quit $$$OK
    }
    s PIADM="" 
    f  s PIADM=$o(^DHCPEPreIADM(0,"PIBI",PIBI,PIADM),-1) q:(PIADM="")  d
    .s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PreADM",PIADM) 
    .q:LocFlag=1 
    .s Status=$P(^DHCPEPreIADM(PIADM),"^", 8)
    .q:(Status'="REGISTERED")&&((Status'="ARRIVED"))
    .S IADM=""
    .s IADM=$O(^DHCPEIADM(0,"CRMADM",PIADM,0))
    .q:IADM="" 
    .s GAAuditedFlag=##class(web.DHCPE.ResultEdit).GeneralAdviceAudited(PIADM,"CRM")
    .q:GAAuditedFlag="1" //总检建议已经审核
    .S AdmDate=$P(^DHCPEIADM(IADM),"^",5)
    .i AdmDate'="" s AdmDate=##class(websys.Conversions).DateLogicalToHtml(AdmDate)
    .s PAADM=$P(^DHCPEIADM(IADM),"^",1)
    .S PAPMIRowId=$o(^PAPERi("PAPMI_PatNo",RegNo,0))
    .i PAPMIRowId'="" d
    ..s TAge=##class(web.DHCPE.DHCPECommon).GetPapmiAge(PAPMIRowId,HospID)
    .s Sex=""
    .s SexDR=$p($g(^DHCPEPreIBI(PIBI)),"^",3)
    .i SexDR'="" s Sex=$P(^CT("SEX",SexDR),"^",2)
    .s Name=$p($g(^DHCPEPreIBI(PIBI)),"^",2)
   .s HPNo=$P(^DHCPEPreIADM(PIADM),"^", 27)
   .s StatusDesc=""
   .s StatusDesc=##Class(web.DHCPE.PreCommon).TransStatus(Status)
   .s GName="",TeamName=""
   .s PreGADM=$P(^DHCPEPreIADM(PIADM),"^", 2)
   .i ""'=PreGADM  d
   ..s PGADMPGBIDR=$p($g(^DHCPEPreGADM(PreGADM)),"^",1)
   ..i ""'=PGADMPGBIDR s GName=$p($g(^DHCPEPreGBI(PGADMPGBIDR)),"^",2)
   .s PreTeam=$P(^DHCPEPreIADM(PIADM),"^", 3)
   .i PreTeam'="" s TeamName=$P($g(^DHCPEPreGADM($p(PreTeam,"||",1),"Team",$p(PreTeam,"||",2))),"^",1)
    
    .s ^CacheTemp(repid,ind)=$lb(PAADM,RegNo,Name,HPNo,AdmDate,StatusDesc,GName,TeamName)
    .s ind=ind+1
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

ClassMethod IsCurDate(SpecNo)
{
    s Flag=""
    //是否登记号的判断  20130730
    s BaseInfoID=$O(^DHCPEPreIBI(0,"PAPMINo",SpecNo,0))
    if (BaseInfoID'="")
    {
        s IADM=""
        s PreID=""
        f  s PreID=$O(^DHCPEPreIADM(0,"PIBI",BaseInfoID,PreID),-1) q:(PreID="")||(IADM'="")  d
        .s Status=$P(^DHCPEPreIADM(PreID),"^",8)
        .q:(Status'="REGISTERED")&&((Status'="ARRIVED"))
        .s IADM=$O(^DHCPEIADM(0,"CRMADM",PreID,0))
        //q:IADM="" "0^后台数据IADM出错"
        q:IADM="" "0^获取不到对应的就诊信息"
        s PAADM=$P(^DHCPEIADM(IADM),"^",1)
        s RegNoFlag=1
    }
    else
    {
        s OEORD=$o(^OEORD(0,"EpisNo",SpecNo,0))
        q:OEORD="" "0^输入的检验号不正确"
        s PAADM=$p(^OEORD(OEORD),"^",1)
        //q:PAADM="""0^后台数据PAADM出错"
        q:PAADM="" "0^该标本号没有对应的就诊信息"
        s IADM=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
        //q:IADM="" "0^后台数据IADM出错"
        q:IADM="" "0^该标本号没有对应的就诊信息"
        s RegNoFlag=0
    }
    s Status=$p(^DHCPEIADM(IADM),"^",8)
    i Status="REGISTERED"
    {
        //第一个为医生界面自动到达\第二个为打印条码自动到达\第三个是标本采集
        s AutoArrived=$G(^DHCPESetting("DHCPE","AutoArrived",%session.Get("LOGON.CTLOCID")))
        s AutoArrived=$p(AutoArrived,"^",3)
        i AutoArrived="Y" d
        .s PreIADM=$p(^DHCPEIADM(IADM),"^",4)
        .d ##class(web.DHCPE.DHCPEIAdm).IAdmArrived(PreIADM)
    }
    
    s IADMDate=$p(^DHCPEIADM(IADM),"^",5)
    s CurRoomInfo=$P(##class(web.DHCPE.RoomManager).GetAdmCurRoom(PAADM,"ADM",""),"^",1)
    s Status=""
    s DetailStatus=""
    i CurRoomInfo'="" d
    .s Status=$LG(^User.DHCPEAdmRoomRecordD(CurRoomInfo),7)
    .s DetailStatus=$LG(^User.DHCPEAdmRoomRecordD(CurRoomInfo),9)
    i IADMDate'=+$H  q "1^"_CurRoomInfo_"^"_PAADM_"^"_RegNoFlag_"^"_Status_"^"_DetailStatus
    q Flag_"^"_CurRoomInfo_"^"_PAADM_"^"_RegNoFlag_"^"_Status_"^"_DetailStatus
}

ClassMethod OutRefuseItemButton(SpecNo)
{
    q:SpecNo=""
    s Flag=0
    s OEORD=0
    s OEORIRowId=""
    f  s OEORD=$O(^OEORD(0,"EpisNo",SpecNo,OEORD)) q:(OEORD="")||(Flag=1)  d
    .s sub=0
    .f  s sub=$O(^OEORD(0,"EpisNo",SpecNo,OEORD,sub)) q:(sub="")||(Flag=1)  d
    ..s ItemStat=$p($G(^OEORD(OEORD,"I",sub,1)),"^",13)
    ..q:ItemStat="4"
    ..s:ItemStat="6" Flag="1"
    ..s OEORIRowId=OEORD_"||"_sub
    q:Flag=1
    w "<table><tr><td>"
    i $D(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OEORIRowId)) d
    .w "<input type='button' id='"_SpecNo_"' name='RefuseButton' value='启用' onclick='RefuseItem();'>"
    e  d
    .w "<input type='button' id='"_SpecNo_"' name='RefuseButton' value='取消' onclick='RefuseItem();'>"
    w "<input type='checkbox' name='TSelect' id='"_SpecNo_"^C'>"
    w "</td></tr></table>"
    
    Quit $$$OK
}

/*
ClassMethod RefuseItemBySpecNo(SpecNo)
{
    s OEORD=0
    s OEORIRowId=""
    f  s OEORD=$O(^OEORD(0,"EpisNo",SpecNo,OEORD)) q:(OEORD="")  d
    .s sub=0
    .f  s sub=$O(^OEORD(0,"EpisNo",SpecNo,OEORD,sub)) q:(sub="")  d
    ..s ItemStat=$p($G(^OEORD(OEORD,"I",sub,1)),"^",13)
    ..q:ItemStat'="1"
    ..s OEORIRowId=OEORD_"||"_sub
    ..i '$D(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OEORIRowId)) d
    ...i $D(^DHCPETempLabEpisodeScan(SpecNo)) d
    ....s HadStr=$G(^DHCPETempLabEpisodeScan(SpecNo)) 
    ....s HadDate=+HadStr
    ....s HadTime=$p(HadStr,"^",2)
    ....k ^DHCPETempLabEpisodeScan("Date",HadDate,HadTime,SpecNo)
    ....k ^DHCPETempLabEpisodeScan(SpecNo) 
    ..e  d
    ...d ..SaveSpecCollect(SpecNo)
    ..d ##class(web.DHCPE.ResultEdit).RefuseCheck(OEORIRowId)
}
*/
ClassMethod RefuseItemBySpecNo(SpecNo, SessionStr)
{
	s LogUserId=$p(SessionStr,"^",1)
	s LogLocID=$p(SessionStr,"^",2)
	
    s OEORD=0
    s OEORIRowId=""
    f  s OEORD=$O(^OEORD(0,"EpisNo",SpecNo,OEORD)) q:(OEORD="")  d
    .s sub=0
    .f  s sub=$O(^OEORD(0,"EpisNo",SpecNo,OEORD,sub)) q:(sub="")  d
    ..s ItemStat=$p($G(^OEORD(OEORD,"I",sub,1)),"^",13)
    ..q:ItemStat'="1"
    ..s OEORIRowId=OEORD_"||"_sub
    ..i '$D(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OEORIRowId)) d
    ...i $D(^DHCPETempLabEpisodeScan(SpecNo)) d
    ....s HadStr=$G(^DHCPETempLabEpisodeScan(SpecNo)) 
    ....s HadDate=+HadStr
    ....s HadTime=$p(HadStr,"^",2)
    ....k ^DHCPETempLabEpisodeScan("Date",HadDate,HadTime,SpecNo)
    ....k ^DHCPETempLabEpisodeScan(SpecNo) 
    ..e  d
    ...d ..SaveSpecCollect(SpecNo,LogUserId,LogLocID)
    ..d ##class(web.DHCPE.ResultEdit).RefuseCheck(OEORIRowId)
    q 0
}

/// 根据标本号得到PAADM
ClassMethod GetPAADMBySpec(Spec)
{
    s OEORD=$o(^OEORD(0,"EpisNo",Spec,0))
    q:OEORD="" ""
    q $P(^OEORD(OEORD),"^",1)
}

/// Description: 根据标本号得到OEORDID
/// Input:      SpecNo:标本号
/// debug:w ##class(web.DHCPE.BarPrint).GetOEORDBySpecNo()
ClassMethod GetOEORDBySpecNo(SpecNo)
{
	s flag=0
    s OEORD=0
    s OEORIRowId=""
    f  s OEORD=$O(^OEORD(0,"EpisNo",SpecNo,OEORD)) q:(OEORD="")||(flag=1)  d
    .s sub=0
    .f  s sub=$O(^OEORD(0,"EpisNo",SpecNo,OEORD,sub)) q:(sub="")||(flag=1)  d
    ..s ItemStat=$p($G(^OEORD(OEORD,"I",sub,1)),"^",13)
    ..q:ItemStat'="1"
    ..s OEORIRowId=OEORD_"||"_sub
    ..q:$D(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OEORIRowId)) 
    ..s flag=1
    q OEORIRowId
}

/// Creator：     xy 
/// CreatDate：   20220506
/// Description: 根据标本号判断是不是采集界面维护的标本
/// Input:       SpecNo:标本号,SpecNoType：菜单上维护的标本类型
/// debug: w ##class(web.DHCPE.BarPrint).IsCanSaveSpec()
ClassMethod IsCanSaveSpec(SpecNo, SpecNoType As %String = "")
{
	//s ^tempdhccpe("IsCanSaveSpec")=$lb(SpecNo,SpecNoType)
	q:SpecNo="" "标本号不能为空！"
	i SpecNoType=""  s SpecNoType="血"
    s OEORIRowId=##class(web.DHCPE.BarPrint).GetOEORDBySpecNo(SpecNo)
    q:OEORIRowId="" "该标本号没有对应有效地医嘱！"
    s SpecimenDesc=##class(web.DHCPE.BarPrint).GetSpecName(OEORIRowId)
    s SpecNoFlag=0
    s SpecNoTypeLength=$l(SpecNoType,"^")
    f SpecNoTypeNum=1:1:SpecNoTypeLength  d
    .s SpecNoTypeOne=$p(SpecNoType,"^",SpecNoTypeNum)
    .i (("^"_SpecimenDesc_"^")[SpecNoTypeOne) s SpecNoFlag=1
    q SpecNoFlag
}

Storage Default
{
<Data name="BarPrintDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCP.BarPrintD</DataLocation>
<DefaultData>BarPrintDefaultData</DefaultData>
<IdLocation>^web.DHCP.BarPrintD</IdLocation>
<IndexLocation>^web.DHCP.BarPrintI</IndexLocation>
<StreamLocation>^web.DHCP.BarPrintS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
