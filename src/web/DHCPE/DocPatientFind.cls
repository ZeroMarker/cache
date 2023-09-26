Class web.DHCPE.DocPatientFind Extends %Persistent
{

/// debug: w ##class(web.DHCPE.DocPatientFind).GetPatientInfo(40695337,"","","")
ClassMethod GetPatientInfo(RegNo, StartDate, EndDate, HadCheck)
{
    //n (RegNo, StartDate, EndDate, HadCheck)
    s:StartDate'="" StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
    i StartDate="" s StartDate=0
    s:EndDate'="" EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
    i EndDate="" s EndDate=+$H
    s RegNo=##class(web.DHCPE.DHCPECommon).RegNoMask(RegNo)
    s RegNoIndex=RegNo
    s RegNoIndex=$ZCVT(RegNoIndex,"U")
    s PaPatID=$O(^PAPERi("PAPMI_PatNo",RegNoIndex,0))
    q:PaPatID="" "-1^登记号不存在"
    s RecordInfo=..GetRecordInfo(PaPatID)
    q:RecordInfo="" "-1^不存在体检记录"
    s BaseInfo=..GetBaseInfo(PaPatID)
    q BaseInfo_$C(1)_RecordInfo
}

ClassMethod GetRecordInfo(PaPatID, DefaultPAADM As %String = "")
{
    s RecordInfo=""
    s ArriveFlag=0
    s LocID=%session.Get("LOGON.CTLOCID")
    s PaadmID=""
    f  s PaadmID=$O(^PAPERdr(PaPatID,"ADM","H",PaadmID),-1) q:PaadmID=""  d
    .s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PAADM",PaadmID)
    .q:(LocFlag=1)&&($D(^DHCPESetting("DHCPE","DefaultPAADM",LocID)))
    .s PIADM=$O(^DHCPEIADM(0,"PAADM",PaadmID,0))
    .q:PIADM=""
    .s PreIADM=$P(^DHCPEIADM(PIADM),"^",4)
    .//第一个为医生界面自动到达\第二个为打印条码自动到达
    .s AutoArrived=$G(^DHCPESetting("DHCPE","AutoArrived",%session.Get("LOGON.CTLOCID"))) ;
    .s AutoArrived=$p(AutoArrived,"^",1)
    .i AutoArrived="Y" d
    ..d:ArriveFlag=0 ##class(web.DHCPE.DHCPEIAdm).IAdmArrived(PreIADM)
    .s ArriveFlag=1
    .q:##class(web.DHCPE.ResultEdit).IsArrivedStatu(PaadmID)="0"
    .s AdmDate=$P(^PAADM(PaadmID),"^",6)
    .;q:(AdmDate<StartDate)||(AdmDate>EndDate)
    .s AdmDate=##class(websys.Conversions).DateLogicalToHtml(AdmDate)
    .;d ##class(web.DHCPE.TransResult).TransMain(PaadmID)
    .s OneInfo=PaadmID_"^"_AdmDate
    .i RecordInfo="" d
    ..s RecordInfo=OneInfo
    .e  d
    ..s RecordInfo=RecordInfo_$C(2)_OneInfo
    i (RecordInfo="")&&(DefaultPAADM'="") d
    .s AdmDate=$P(^PAADM(DefaultPAADM),"^",6)
    .s AdmDate=##class(websys.Conversions).DateLogicalToHtml(AdmDate)
    .s RecordInfo=DefaultPAADM_"^"_AdmDate
    q RecordInfo
}

ClassMethod GetBaseInfo(PaPatID, HospID As %Library.String = "")
{
    ;w ##class(web.DHCPE.DocPatientFind).GetBaseInfo("4548744")
    s RegNo=$P($g(^PAPER(PaPatID,"PAT",1)),"^",1)
    s BaseID=$O(^DHCPEPreIBI(0,"PAPMINo",RegNo,0))
    s Name=$P($g(^PAPER(PaPatID,"ALL")),"^",1)
    s Sex=$P($g(^PAPER(PaPatID,"ALL")),"^",7)
    s:Sex'="" Sex=$P($g(^CT("SEX",Sex)),"^",2)
    s IDCard=$P($g(^PAPER(PaPatID,"PAT",3)),"^",6)
    ;s Name=Name_" "_Sex
    s Dob=$P($g(^PAPER(PaPatID,"ALL")),"^",6)
    i Dob'="" s Age=##class(web.DHCDocCommon).GetAgeDescNew($zd(Dob,3),"")
    s Dob=$ZD(Dob,3)
    //s Age=##class(web.DHCPE.DHCPECommon).GetPapmiAge(PaPatID,HospID)
    s Age=##class(web.DHCBillInterface).GetPapmiAge(PaPatID,"",HospID)
    s Tel=""
    i BaseID'="" d
    .s Tel=$P($g(^DHCPEPreIBI(BaseID)),"^",8)
    .s:Tel="" Tel=$P($g(^DHCPEPreIBI(BaseID)),"^",6)
    .s:Tel="" Tel=$P($g(^DHCPEPreIBI(BaseID)),"^",7)

    s:Tel="" Tel=$P($g(^PAPER(PaPatID,"PER",4)),"^",21)
    //s:Tel="" Tel=$P(^PAPER(PaPatID,"PER",4),"^",18)
    s:Tel="" Tel=$P($g(^PAPER(PaPatID,"PER",1)),"^",11)
    s:Tel="" Tel=$P($g(^PAPER(PaPatID,"PER",1)),"^",9)
    
    s Postion=""
    s BaseInfo=RegNo_"^"_Name_"^"_IDCard_"^"_Dob_"^"_Tel_"^"_Age_"^"_Postion_"^"_Sex
    q BaseInfo
}

ClassMethod GetInfoByPAADM(PAADM)
{
    ;##class(web.DHCPE.DocPatientFind).GetInfoByPAADM(PAADM)
    q:PAADM="" ""
    s PaPatID=$P($g(^PAADM(PAADM)),"^",1)
    s LocID=$P($g(^PAADM(PAADM)),"^",4)
    s HospID=##class(web.DHCPE.CT.DHCPEMappingLoc).GetHospIDByLocID(LocID) //根据科室找院区
    s BaseInfo=..GetBaseInfo(PaPatID,HospID)
    s RecordInfo=..GetRecordInfo(PaPatID,PAADM)
    q BaseInfo_$C(1)_RecordInfo
}

/*
ClassMethod GetDefaultStation()
{
    
    s UserID=%session.Get("LOGON.USERID")
    s LocID=%session.Get("LOGON.CTLOCID")
    s GroupID=%session.Get("LOGON.GROUPID")
    s Station=""
    s ChartId=0
    f  s ChartId=$O(^DHCPEST(ChartId)) q:ChartId=""  d
    .s Chart=$P(^DHCPEST(ChartId),"^",2)
    .Set UseFlag=+$G(^DHCPECFDataEx("ChartAssign",UserID,LocID,GroupID,"Detail",ChartId))
    .Set WriteFlag=$G(^DHCPECFDataEx("ChartAssign",UserID,LocID,GroupID,"Write",ChartId))
    .Set Default=$G(^DHCPECFDataEx("ChartAssign",UserID,LocID,GroupID,"Default",ChartId))
    .s WriteWay=$G(^DHCPECFDataEx("ChartAssign",UserID,LocID,GroupID,"WriteWay",ChartId))
    .i Default="Y" s Station=Chart
    q Station
}
*/

/*
/// w ##class(web.DHCPE.DocPatientFind).GetStationList("3711")
ClassMethod GetStationList(PAADM)
{
    q:PAADM=""
    s Job=$J
    s RetStr=""
    s curUser=%session.Get("LOGON.USERID")
    s curLoc=$P($G(^PAADM(PAADM)),"^",4)
    i curLoc="" s curLoc=%session.Get("LOGON.CTLOCID")

    s curGroup=%session.Get("LOGON.GROUPID")
    
    
    
    s Stations=##class(web.DHCPE.ResultDiagnosis).AdmNeedStation(PAADM)
    
    s i=$L(Stations,"^")
    For j = 1:1:i {
                s Station=$P(Stations,"^",j)
                q:Station=""
                s Sort=$P($g(^DHCPEST(Station)),"^",4)
                s:Sort="" Sort=Station
                s ^TempDHCPESort(Job,Sort,Station)=Station
    }
    
        //s RisStation=$g(^DHCPESetting("DHCPE","StationId_Ris"))
        s RisStation=$g(^DHCPESetting("DHCPE","StationId_Ris",curLoc))
        s Sort=0
        f  s Sort=$O(^TempDHCPESort(Job,Sort)) q:Sort=""  d
        .s Station=""
        .f  s Station=$O(^TempDHCPESort(Job,Sort,Station)) q:Station=""  d
        ..s StationDesc=$P(^DHCPEST(Station),"^",2)
        ..q:+$G(^DHCPECFDataEx("ChartAssign",curUser,curLoc,curGroup,"Detail",Station))=0
        ..s Auditstatus=##class(web.DHCPE.ResultEdit).GetStationSubmitStatus(PAADM, Station)
        ..i RetStr="" d
        ...s RetStr=Station_"^"_StationDesc_"^"_Auditstatus
        ..e  d
        ...s RetStr=RetStr_","_Station_"^"_StationDesc_"^"_Auditstatus
        
        k ^TempDHCPESort(Job)
    
    
    q RetStr
}
*/
/// Creator：      xy
/// CreatDate：    20210824
/// Description:  获取医生对应科室安全组下的默认站点
/// Table：       科室体检医生维护 DHC_PE_ChartAssign,科室体检医生站点权限 DHC_PE_ChartAssignDtl
/// Input:        UserID(登录用户ID),LocID(登录科室ID),GroupID(安全组ID)
/// Return：      return=默认站点ID
/// debug：  w ##class(web.DHCPE.DocPatientFind).GetDefaultStation("12187","152","164")
ClassMethod GetDefaultStation(UserID As %String = "", LocID As %String = "", GroupID As %String = "")
{
    s ^tempdhcpe("GetDefaultStation")=$lb(UserID,LocID,GroupID)
    i UserID=""  s UserID=%session.Get("LOGON.USERID")
    i LocID=""   s LocID=%session.Get("LOGON.CTLOCID")
    i GroupID="" s GroupID=%session.Get("LOGON.GROUPID")
        
    s DefStation=""
    
    s StationDR=""
    f  s StationDR=$o(^CF.PE.StationSetI("IdxOfLocStation"," "_LocID,StationDR))  q:(StationDR="")||(DefStation'="")  d
    .s SSID=""
    .f  s SSID=$o(^CF.PE.StationSetI("IdxOfLocStation"," "_LocID,StationDR,SSID))  q:(SSID="")||(DefStation'="")  d
    ..s SSActive=$lg($g(^CF.PE.StationSetD(SSID)),11)
    ..q:SSActive'="Y"
    ..s StationID=$lg($g(^CF.PE.StationSetD(SSID)),2)
    ..s ParRef=$o(^CF.PE.ChartAssignI("IdxOfLocDocSSGrp"," "_LocID," "_UserID," "_GroupID,0))
    ..q:ParRef=""
    ..s CANoActive=$lg($g(^CF.PE.ChartAssignD(ParRef)),6)
    ..q:CANoActive="N"
    ..s Sub=$o(^CF.PE.ChartAssignI("DTL","IdxOfStation",ParRef,StationID,0)) 
    ..q:Sub=""
    ..s Default=$lg($g(^CF.PE.ChartAssignD(ParRef,"DTL",Sub)),5)
    ..s CADStationID=$lg($g(^CF.PE.ChartAssignD(ParRef,"DTL",Sub)),2)   
    ..i Default="Y" s DefStation=CADStationID
    
    q DefStation
}

/// Creator：      xy
/// CreatDate：    20210824
/// Description:  获取对应就诊记录的所有站点      
/// Input:        PAADM(就诊ID),UserID(登录用户ID),LocID(登录科室ID),GroupID(安全组ID)
/// Return：      return=站点1^站点描述1^提交状态,站点2^站点描述2^提交状态
/// debug：  w ##class(web.DHCPE.DocPatientFind).GetStationList("4791","12187","152","164")
ClassMethod GetStationList(PAADM As %String = "", UserID As %String = "", LocID As %String = "", GroupID As %String = "")
{
    s ^tempdhcpe("GetStationList")=$lb(PAADM,UserID,LocID,GroupID)
    q:PAADM="" ""
    s Job=$J
    s RetStr=""
    
    i UserID=""  s UserID=%session.Get("LOGON.USERID")
    i LocID=""   s LocID=%session.Get("LOGON.CTLOCID")
    i GroupID="" s GroupID=%session.Get("LOGON.GROUPID")
    
    s RisStation=$g(^DHCPESetting("DHCPE","StationId_Ris",LocID))
    
    s Stations=##class(web.DHCPE.ResultDiagnosis).AdmNeedStation(PAADM)
    
    
    s i=$L(Stations,"^")
    for j = 1:1:i {
        s Station=$P(Stations,"^",j)
        continue:Station=""
        s SSID=$o(^CF.PE.StationSetI("IdxOfLocStation"," "_LocID,Station,""))
        continue:SSID=""
        s Sort=$lg($g(^CF.PE.StationSetD(SSID)),5) //总检顺序
        s:Sort="" Sort=Station
        s ^TempDHCPESort(Job,Sort,Station)=Station
    }
    
    s Sort=0
    f  s Sort=$o(^TempDHCPESort(Job,Sort)) q:Sort=""  d
    .s Station=""
    .f  s Station=$o(^TempDHCPESort(Job,Sort,Station)) q:Station=""  d
    ..s StationDesc=$p($g(^DHCPEST(Station)),"^",2)
    ..s ParRef=$o(^CF.PE.ChartAssignI("IdxOfLocDocSSGrp"," "_LocID," "_UserID," "_GroupID,0))
    ..q:ParRef=""
    ..s CANoActive=$lg($g(^CF.PE.ChartAssignD(ParRef)),6)
    ..q:CANoActive="N"
    ..s Sub=$o(^CF.PE.ChartAssignI("DTL","IdxOfStation",ParRef,Station,0)) 
    ..q:Sub=""
    ..s Detail=$lg(^CF.PE.ChartAssignD(ParRef,"DTL",Sub),3) //可写权限
    ..q:Detail'="Y"
    ..s Auditstatus=##class(web.DHCPE.ResultEdit).GetStationSubmitStatus(PAADM,Station)
    ..s StationDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEStation",StationDesc,"STDesc","cls")
    ..i RetStr="" d
    ...s RetStr=Station_"^"_StationDesc_"^"_Auditstatus
    ..e  d
    ...s RetStr=RetStr_","_Station_"^"_StationDesc_"^"_Auditstatus
    
    /// 症状
    s PreIADM="",VIPLevel=""
    s IADM=$o(^DHCPEIADM(0,"PAADM",PAADM,0))
    s:IADM'="" PreIADM=$p($g(^DHCPEIADM(IADM)),"^",4)
    s:PreIADM'="" VIPLevel=$p($g(^DHCPEPreIADM(PreIADM)),"^",18)
    if (VIPLevel'="") {
        s ID=$o(^CF.PE.LocVIPLevelI("IdxOfLocVIP"," "_LocID,VIPLevel,0))
        if (ID'="") {
            s VIPType=$lg($g(^CF.PE.LocVIPLevelD(ID)),14)
            s SaveFlag=0
            if RetStr="" {
                s:VIPType="ZYJK" RetStr="SYMPTOM"_"^"_"症状^"_SaveFlag_","_"OCCINFO"_"^"_"职业健康信息^"_SaveFlag
            } else {
                s:VIPType="ZYJK" RetStr=RetStr_","_"SYMPTOM"_"^"_"症状^"_SaveFlag_","_"OCCINFO"_"^"_"职业健康信息^"_SaveFlag
            }
        }
    }
    
    k ^TempDHCPESort(Job)   
    q RetStr
}

ClassMethod GetTreeStr(StationID, PAADM, MainDoctorFlag As %String = "")
{
    
    ;w ##class(web.DHCPE.DocPatientFind).GetTreeStr("21^1","5176")
    q:PAADM=""
    s Job=$J
    s HadCheckImage="../images/dhcpe/hadcheck.gif"
    s RefuseImage="../images/dhcpe/refuse.gif"
    s NoCheckImage=""
    s OneStr="{'id': 'LocID','text':'LocDesc','leaf':TrueOrFalse,'icon':'Image'}"
    s RetStr=""
    s ID=$P(StationID,"^",1)
    s Type=$P(StationID,"^",2)
    s curLoc=$P($G(^PAADM(PAADM)),"^",4)
    s curUser=%session.Get("LOGON.USERID")
    i curLoc="" s curLoc=%session.Get("LOGON.CTLOCID")
    s curGroup=%session.Get("LOGON.GROUPID")
        
    i Type=0{
        
        //i ((","_%session.Get("LOGON.GROUPID")_",")=$G(^DHCPESetting("DHCPE","SSGroup_SummarizeAudit")))||((%session.Get("LOGON.GROUPID"))=$G(^DHCPESetting("DHCPE","MainDoctorGroup")))
        //{
        i MainDoctorFlag'=""
        {
            s Station=""
            s Desc="总检"
            s ChartID="NULL" ;$G(^DHCPECTDataEx("DHCPEStation","NULL"))
            i $G(^DHCPECFDataEx("ChartAssign",curUser,curLoc,curGroup,"Detail",ChartID))="1"
            {
            s Str=##class(web.DHCPE.Public.Setting).Replace(OneStr,"LocID",Station_"^4^"_ChartID)
            s Str=##class(web.DHCPE.Public.Setting).Replace(Str,"LocDesc",Desc)
            s Str=##class(web.DHCPE.Public.Setting).Replace(Str,"TrueOrFalse","true")
            
            s Str=##class(web.DHCPE.Public.Setting).Replace(Str,"Image",NoCheckImage)
            
            i RetStr="" d
            .s RetStr=Str
            e  d
            .s RetStr=RetStr_","_Str
            }
        }
        else
        {
            //}
            s Stations=##class(web.DHCPE.ResultDiagnosis).AdmNeedStation(PAADM)
            
            s i=$L(Stations,"^")
            For j = 1:1:i {
                s Station=$P(Stations,"^",j)
                s Sort=$P(^DHCPEST(Station),"^",4)
                s:Sort="" Sort=Station
                s ^TempDHCPESort(Job,Sort,Station)=Station
            }
        }
        //s RisStation=$g(^DHCPESetting("DHCPE","StationId_Ris"))
        s RisStation=$g(^DHCPESetting("DHCPE","StationId_Ris",curLoc))
        s Sort=0
        f  s Sort=$O(^TempDHCPESort(Job,Sort)) q:Sort=""  d
        .s Station=""
        .f  s Station=$O(^TempDHCPESort(Job,Sort,Station)) q:Station=""  d
        ..s ChartID=Station //$G(^DHCPEDataEx("DHCPEStationChart",Station))
        ..q:ChartID=""
        ..q:+$G(^DHCPECFDataEx("ChartAssign",curUser,curLoc,curGroup,"Detail",ChartID))=0
        ..s Type=1
        ..i ("^"_RisStation_"^")[("^"_Station_"^") s Type=9
        ..s Desc=$P(^DHCPEST(Station),"^",2)
        ..s Str=##class(web.DHCPE.Public.Setting).Replace(OneStr,"LocID",Station_"^"_Type)
        ..s Str=##class(web.DHCPE.Public.Setting).Replace(Str,"LocDesc",Desc)
        ..s Str=##class(web.DHCPE.Public.Setting).Replace(Str,"TrueOrFalse","true") //false
        ..s SSID=##class(web.DHCPE.ResultEdit).GetSSId(PAADM, Station)
        ..s Status="NA"
        ..s:SSID'="" Status=$P(^DHCPESS(SSID,1),"^",7)
        ..i Status="NA" d
        ...s Str=##class(web.DHCPE.Public.Setting).Replace(Str,"Image",NoCheckImage)
        ..e  d
        ...s Str=##class(web.DHCPE.Public.Setting).Replace(Str,"Image",HadCheckImage)
        ..i RetStr="" d
        ...s RetStr=Str
        ..e  d
        ...s RetStr=RetStr_","_Str
        k ^TempDHCPESort(Job)
    }
    /*
    i (Type=1)||(Type=9){
        s Station=ID
        s ChartID=Station //$G(^DHCPEDataEx("DHCPEStationChart",Station))
        s RisStation=$g(^DHCPESetting("DHCPE","StationId_Ris"))
        s LabStation=$g(^DHCPESetting("DHCPE","StationId_Lab"))
        s Type=2
        i ("^"_RisStation_"^")[("^"_Station_"^") s Type=3
        b ;11
        i LabStation=Station s Type=5
        s OEORD=$O(^OEORD(0,"Adm",PAADM,0))
        s sub=0
        f  s sub=$O(^OEORD(OEORD,"I",sub)) q:sub=""  d
        .s ArcimID=$P($G(^OEORD(OEORD,"I",sub,1)),"^",2)
        .q:ArcimID=""
        .q:'$D(^DHCPEST(0,"STORD_ARCIM",ArcimID,Station))
        .s Stat=$P(^OEORD(OEORD,"I",sub,1),"^",13)
        .q:Stat="4"
        .s Desc=$p($G(^ARCIM($p(ArcimID,"||",1),$p(ArcimID,"||",2),1)),"^",2)
        .s Desc=$E(Desc,1,6)
        .s Str=##class(web.DHCPE.Public.Setting).Replace(OneStr,"LocID",OEORD_"||"_sub_"^"_Type_"^"_ChartID)
        .s Str=##class(web.DHCPE.Public.Setting).Replace(Str,"LocDesc",Desc)
        .s Str=##class(web.DHCPE.Public.Setting).Replace(Str,"TrueOrFalse","true")
        .i $D(^DHCPERLT(0,"OEORI",OEORD_"||"_sub)) d
        ..s Str=##class(web.DHCPE.Public.Setting).Replace(Str,"Image",HadCheckImage)
        .e  d
        ..i $D(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OEORD_"||"_sub)) d
        ...s Str=##class(web.DHCPE.Public.Setting).Replace(Str,"Image",RefuseImage)
        ..d  d
        ...s Str=##class(web.DHCPE.Public.Setting).Replace(Str,"Image",NoCheckImage)
        .i RetStr="" d
        ..s RetStr=Str
        .e  d
        ..s RetStr=RetStr_","_Str
        
    }
    */
    i RetStr'="" s RetStr="["_RetStr_"]"
    q RetStr
}

ClassMethod GetOrdInfo(PAADM, MainDoctorFlag As %String = "")
{
    ;w ##class(web.DHCPE.DocPatientFind).GetOrdInfo("3151468")
    s Info=""
    s Job=$J
    s curLoc=$P($G(^PAADM(PAADM)),"^",4)
    s curUser=%session.Get("LOGON.USERID")
    i curLoc="" s curLoc=%session.Get("LOGON.CTLOCID")
    s curGroup=%session.Get("LOGON.GROUPID")
    i MainDoctorFlag'=""
    {
        s ChartID="NULL"
        i $G(^DHCPECFDataEx("ChartAssign",curUser,curLoc,curGroup,"Detail",ChartID))="1"
        {
            i $G(^DHCPECFDataEx("ChartAssign",curUser,curLoc,curGroup,"Default",ChartID))="Y" d
            s Sort=1
            s ^TempDHCPEOrderSort(Job,Sort)=ChartID     
            //s Info="^4^"_ChartID
        }
    }
    else{
        s Stations=##class(web.DHCPE.ResultDiagnosis).AdmNeedStation(PAADM)
        s i=$L(Stations,"^")
        For j = 1:1:i {
            s Station=$P(Stations,"^",j)
            continue:Station=""
            s Sort=$P(^DHCPEST(Station),"^",4)+100
            i $G(^DHCPECFDataEx("ChartAssign",curUser,curLoc,curGroup,"Default",Station))="Y" d
            .s Sort=1
            s ^TempDHCPEOrderSort(Job,Sort)=Station
        }
    }
    //s RisStation=$g(^DHCPESetting("DHCPE","StationId_Ris"))
    //s LabStation=$g(^DHCPESetting("DHCPE","StationId_Lab"))
    s RisStation=$g(^DHCPESetting("DHCPE","StationId_Ris",curLoc))
    s LabStation=$g(^DHCPESetting("DHCPE","StationId_Lab",curLoc))

    s OEORD=$O(^OEORD(0,"Adm",PAADM,0))     
    b ;^TempDHCPESort(Job)
    s Sort=0
    f  s Sort=$O(^TempDHCPEOrderSort(Job,Sort)) q:Sort=""  d
    .s Station=^TempDHCPEOrderSort(Job,Sort)
    .s ChartID=Station //$G(^DHCPEDataEx("DHCPEStationChart",Station))
    .q:ChartID=""
    .q:$G(^DHCPECFDataEx("ChartAssign",curUser,curLoc,curGroup,"Write",ChartID))'="Y"
    .i ChartID="NULL" d
    ..s OneInfo="^4^"_ChartID
    .e  d
    ..;s Type=2
    ..;i ("^"_RisStation_"^")[("^"_Station_"^") s Type=3
    ..;i LabStation=Station s Type=5
    ..s Type=1
    ..i ("^"_RisStation_"^")[("^"_Station_"^") s Type=9
    ..s OneInfo=Station_"^"_Type
    .i Info="" d
    ..s Info=OneInfo
    .e  d
    ..s Info=Info_$C(1)_OneInfo
    /*
    .s sub=0
    .f  s sub=$O(^OEORD(OEORD,"I",sub)) q:sub=""  d
    ..s ArcimID=$P($G(^OEORD(OEORD,"I",sub,1)),"^",2)
    ..q:ArcimID=""
    ..q:'$D(^DHCPEST(0,"STORD_ARCIM",ArcimID,Station))
    ..s Stat=$P(^OEORD(OEORD,"I",sub,1),"^",13)
    ..q:Stat="4"
    ..s OneInfo=OEORD_"||"_sub_"^"_Type_"^"_ChartID
    ..i Info="" d
    ...s Info=OneInfo
    ..e  d
    ...s Info=Info_$C(1)_OneInfo
    */
    k ^TempDHCPEOrderSort(Job)
    s IADM=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
    i IADM'=""{
        s PIADM=$P(^DHCPEIADM(IADM),"^",4)
        s GADM=$P(^DHCPEPreIADM(PIADM),"^",2)
        s GroupDesc="个人"
        i GADM'="" d
        .s GBaseInfo=$P(^DHCPEPreGADM(GADM),"^",1)
        .s GroupDesc=$P(^DHCPEPreGBI(GBaseInfo),"^",2)
    }else{
        s GroupDesc="个人"
    }
    q Info_$C(2)_GroupDesc
}

// 根据姓名得到基本信息个数

ClassMethod GetPersonCountByName(Name)
{
    q:Name="" "0^"
    s Count=0
    s CurID=""
    s ID=0
    f  s ID=$O(^DHCPEPreIBI(0,"Name",Name,ID)) q:ID=""  d
    .s PID=""
    .s Flag=0
    .f  s PID=$O(^DHCPEPreIADM(0,"PIBI",ID,PID),-1) q:(PID="")||(Flag=1)  d
    ..s Status=$P(^DHCPEPreIADM(PID),"^",8)
    ..q:Status'="ARRIVED"
    ..s Flag=1
    .i Flag=1 d
    ..s Count=Count+1
    ..s CurID=ID
    i Count=1 d
    .s CurID=$P(^DHCPEPreIBI(CurID),"^",1)
    q Count_"^"_CurID
}

// d ##Class(%ResultSet).RunQuery("web.DHCPE.DocPatientFind","GetRegNoByName","辛云章")

ClassMethod GetRegNoByNameExecute(ByRef qHandle As %Binary, vName As %Library.String) As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    i (vName=""){
        Set qHandle=$lb(0,repid,0)
        Quit $$$OK
    }
    s ID=0
    f  s ID=$O(^DHCPEPreIBI(0,"Name",vName,ID)) q:ID=""  d
    .s PID=""
    .s Flag=0
    .f  s PID=$O(^DHCPEPreIADM(0,"PIBI",ID,PID),-1) q:(PID="")||(Flag=1)  d
    ..s Status=$P(^DHCPEPreIADM(PID),"^",8)
    ..q:Status'="ARRIVED"
    ..s Flag=1
    .i Flag=1 d
    ..d Clear
    ..s RegNo=$P(^DHCPEPreIBI(ID),"^",1)
    ..s Name=$P(^DHCPEPreIBI(ID),"^",2)
    ..s Sex=$P(^DHCPEPreIBI(ID),"^",3)
    ..s:Sex'="" Sex=$P(^CT("SEX",Sex),"^",2)
    ..s Dob=$P(^DHCPEPreIBI(ID),"^",4)
    ..s Age=+##class(web.DHCPE.DHCPECommon).GetCurAge(Dob)
    ..s:Dob'="" Dob=$ZD(Dob,3)
    ..s Tel=$P(^DHCPEPreIBI(ID),"^",6)
    ..s:Tel="" Tel=$P(^DHCPEPreIBI(ID),"^",7)
    ..s:Tel="" Tel=$P(^DHCPEPreIBI(ID),"^",8)
    ..s IDCard=$P(^DHCPEPreIBI(ID),"^",9)
    
    ..d QueryOut
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
Clear
    s (RegNo,Name,Sex,Dob,Age,Tel,IDCard)=""
    q
QueryOut
    ;体检ID，姓名，性别，年龄，单位，体检日期，tel，IDCard   
    set Data=$lb(RegNo,Name,Sex,Dob_"("_Age_")",Tel,IDCard)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

ClassMethod GetRegNoByNameFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRegNoByNameExecute ]
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

Query GetRegNoByName(Name As %Library.String) As %Query(ROWSPEC = "RegNo:%String,Name:%String,Sex:%String,Dob:%String,Tel:%String,IDCard:%String")
{
}

ClassMethod GetRegNoByNameClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRegNoByNameExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetPADMByPAADM(PAADM, ExpStr As %String = "0")
{
    ;w ##class(web.DHCPE.DocPatientFind).GetPADMByPAADM2(4041646,1)
    q:PAADM="" ""
    s PIADM=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
    q:PIADM="" ""
    s Date=$P(^PAADM(PAADM),"^",6)
    
    s:ExpStr="1" DateStr=$ZD(Date,8)
    s PreIADM=$P(^DHCPEIADM(PIADM),"^",4)
    i ExpStr="1"{ //体检号
        q $P(^DHCPEPreIADM(PreIADM),"^",27)
    }
    
    
    s VIPLevel=$P(^DHCPEPreIADM(PreIADM),"^",18)
    s VIPType=""
    s:VIPLevel="2" VIPType="V"
    s:VIPLevel="3" VIPType="VV"
    s PAPMIID=$P(^PAADM(PAADM),"^",1)
    s RegNo=$P(^PAPER(PAPMIID,"PAT",1),"^",1)
    q:ExpStr="1" VIPType_RegNo_"-"_DateStr
    q PreIADM
}

ClassMethod GetPADMByPAADM2(PAADM, ExpStr As %String = "0")
{
    ;w ##class(web.DHCPE.DocPatientFind).GetPADMByPAADM2(4041646,1)
    q:PAADM="" ""
    s PIADM=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
    q:PIADM="" ""
    s Date=$P(^PAADM(PAADM),"^",6)
    s:ExpStr="1" DateStr=$ZD(Date,8)
    s PreIADM=$P(^DHCPEIADM(PIADM),"^",4)
    s VIPLevel=$P(^DHCPEPreIADM(PreIADM),"^",18)
    s VIPType=""
    s:VIPLevel="2" VIPType="V"
    s:VIPLevel="3" VIPType="VV"
    s PAPMIID=$P(^PAADM(PAADM),"^",1)
    s RegNo=$P(^PAPER(PAPMIID,"PAT",1),"^",1)
    q:ExpStr="1" VIPType_RegNo_"-"_DateStr
    q PreIADM
}

/// Debug: w ##class(web.DHCPE.DocPatientFind).OutEDInfoForHISUI("3","","4800","1")
ClassMethod OutEDInfoForHISUI(StationID, LocID As %String = "", PAADM As %String = "", IsAudit As %String = "1")
{
    s ^tempdhcpe("OutEDInfoForHISUI")=$lb(StationID,LocID,PAADM,IsAudit)
    
    if $d(%session) {
        set langId=%session.Get("LOGON.LANGID")
    }
    else
    { s langId=""}
    
    
    i IsAudit="1"
    {
        ;q:$G(^DHCPEShowEDInfo(%session.Get("LOGON.USERID")))'="1"
        
        s SSID=##class(web.DHCPE.ResultEdit).GetSSId(PAADM,StationID)
        i SSID'=""
        {
            s Status=$P(^DHCPESS(SSID,1),"^",7)
            q:Status="SA"
            q:Status="GA"
        }
    }
    s RetStr=""
    s Job=$J
    s AdmLoc=$P(^PAADM(PAADM),"^",4)
    s loc=##class(web.DHCPE.DHCPECommon).GetEDloc(AdmLoc)
    
    s ageSexStr=##class(web.DHCPE.ResultEdit).GetAgeSex(PAADM)
    s sexStr=$P(ageSexStr,"^",3)
    
    /*
    s EDRowId=""
    f  s EDRowId=$o(^DHCPEED(0,"EDLOC",loc,EDRowId)) q:EDRowId=""  d
    .s activeFlag=$G(^DHCPECTDataEx("BaseData","DHCPEExpertDiagnosis","Active",EDRowId))
    .q:activeFlag="N"
    .s HighRisk=$P(^DHCPEED(EDRowId,1),"^",8)
    .q:HighRisk="Y"
    .s EDSex=$G(^DHCPECTDataEx("BaseData","DHCPEExpertDiagnosis","Sex",EDRowId))
    .q:(EDSex'="")&&(EDSex'=sexStr)
    .s CurStation=$P(^DHCPEED(EDRowId,1),"^",7)
    .s:CurStation="" CurStation="99999999"
    .q:(StationID'="")&&(StationID'=CurStation)
    .s CurLocID=$P(^DHCPEED(EDRowId,1),"^",10)
    .q:(LocID'="")&&(CurLocID'=LocID)
    .s:CurLocID="" CurLocID="99999999"
    .s Desc=$P(^DHCPEED(EDRowId,1),"^",1)
    .q:$D(^TempDHCPEDesc(Job,Desc))
    .s ^TempDHCPEDesc(Job,Desc)=""
    .s StationSort=$P($G(^DHCPEST(CurStation)),"^",4)
    .s:StationSort="" StationSort="99999999"
    .s EDSort=$p(^DHCPEED(EDRowId,1),"^",9)
    .s:EDSort="" EDSort="99999999"
    .s ^TempDHCPE(Job,StationSort,CurStation,CurLocID,EDSort,Desc)=""
    */
    
 
    s EDRowId=""
    f  s EDRowId=$o(^DHCPEED(EDRowId)) q:EDRowId=""  d
    .q:'$D(^DHCPEED(EDRowId,1))
    .s LocShowDFlag=##class(User.DHCPEExpertDiagnosis).GetLocShowDataFlag(EDRowId,loc)
    .q:LocShowDFlag'="Y" //过滤不是本科室的建议
    .s EDEffPowerFlag=##class(User.DHCPEExpertDiagnosis).GetLocShowDataFlag(EDRowId,loc)
    .s EDEffPowerFlag=$s(EDEffPowerFlag="Y":"Y",1:"N")
    .q:EDEffPowerFlag'="Y"  //过滤本科室未授权的建议
    .s Active=$p($g(^DHCPEED(EDRowId,1)),"^",13)
    .s:Active="" Active="Y"
    .q:Active'="Y" //过滤未激活的建议
    .s HighRisk=$P($g(^DHCPEED(EDRowId,1)),"^",8)
    .q:HighRisk="Y" //过滤高危建议
    .s EDSex=$p($g(^DHCPEED(EDRowId,1)),"^",11)
    .q:(EDSex'="")&&(EDSex'=sexStr) //过滤性别不一致的建议
    .s CurStation=$P($g(^DHCPEED(EDRowId,1)),"^",7)
    .s:CurStation="" CurStation="99999999"
    .q:(StationID'="")&&(StationID'=CurStation) //过滤站点不一致的建议
    .s StatEffPowerFlag=##class(User.DHCPEStation).GetLocShowDataFlag(CurStation,loc)
    .s StatEffPowerFlag=$s(StatEffPowerFlag="Y":"Y",1:"N")
    .q:StatEffPowerFlag'="Y"  //过滤未授权的站点
    .s CurLocID=$P($g(^DHCPEED(EDRowId,1)),"^",10)
    .q:(LocID'="")&&(CurLocID'=LocID)  //过滤分组不一致的建议
    .s:CurLocID="" CurLocID="99999999"
    .s Desc=$P($g(^DHCPEED(EDRowId,1)),"^",1) //建议描述
    .s Desc=##class(User.DHCPEExpertDiagnosis).GetTranByDesc("EDDiagnoseConclusion",Desc,langId)
    .q:$D(^TempDHCPEDesc(Job,Desc))
    .s ^TempDHCPEDesc(Job,Desc)=""
    .s StationSetID=$o(^CF.PE.StationSetI("IdxOfLocStation"," "_loc,CurStation,""))
    .s StationSort= $lg($g(^CF.PE.StationSetD(StationSetID)),5) //站点顺序
    .s:StationSort="" StationSort="99999999"
    .s EDSort=$p($g(^DHCPEED(EDRowId,1)),"^",9) //建议顺序
    .s:EDSort="" EDSort="99999999"
    .s ^TempDHCPE(Job,StationSort,CurStation,CurLocID,EDSort,Desc)=$P($g(^DHCPEED(EDRowId,1)),"^",1)
    
    k ^TempDHCPEDesc(Job)
    s StationSort=""
    s i=0
    w "<div id='edprefix' style='border:0; overflow-y:auto; white-space:normal; word-break:break-all;'>" 
    
    
    w "<Table id='EDTable' style='border:0; white-space:normal; word-break:break-all;'>"
    w "<tr style='border:0;height:6px;'><td style='border:0;width=40px;'></td><td style='border:0;width=255px;'></td></tr>"
    
    w "<tr style='border:0;'><td style='border:0;' colspan=2>"_##class(websys.Translation).Get("dhcpedocpatient.station.hisui.csp","模糊查询",langId)_"<input id='QueryED' style='width:120px;white-space:normal; word-break:break-all;' onkeydown='QueryED_KeyDown(this,"_StationID_","_PAADM_")'></td></tr>"
    
     w "<tr style='border:0;height:10px;'><td style='border:0;width=40px;'></td><td style='border:0;width=255px;'></td></tr>"
    
    s Sort=0
    f  s StationSort=$O(^TempDHCPE(Job,StationSort)) q:StationSort=""  d
    .s CurStation=""
    .f  s CurStation=$O(^TempDHCPE(Job,StationSort,CurStation)) q:CurStation=""  d
    ..s CurLocID=""
    ..f  s CurLocID=$O(^TempDHCPE(Job,StationSort,CurStation,CurLocID)) q:CurLocID=""  d
    ...s EDSort=""
    ...f  s EDSort=$O(^TempDHCPE(Job,StationSort,CurStation,CurLocID,EDSort)) q:EDSort=""  d
    ....s Desc=""
    ....f  s Desc=$O(^TempDHCPE(Job,StationSort,CurStation,CurLocID,EDSort,Desc)) q:Desc=""  d
    .....s Sort=Sort+1
    .....s RealDesc=$G(^TempDHCPE(Job,StationSort,CurStation,CurLocID,EDSort,Desc))
    .....w:i=0 "<TR bgcolor='' style='white-space:normal; word-break:break-all;'>"
    .....w "<TD width=10%>"_Sort_"</TD><TD style='cursor:hand;white-space:normal; word-break:break-all;' oncontextmenu='contextmenu()' ondblclick='EDDEscOnDBLClick(this);' onmouseup='AllEDDescDBLClick(this);' onclick=EDClick() id='"_CurStation_"^"_Desc_"^^"_RealDesc_"'>"_Desc_"</TD>",!
    .....s i=i+1
    .....w:i=1 "<TR>"
    .....s:i=1 i=0
    w "</Table>",!
    w "<Table id='EDTableDown' border=0 style='height:150px;white-space:normal; word-break:break-all;'>"
    w "</Table>",!
    w "</div>",! 
    k ^TempDHCPE(Job)
    q RetStr
}

/*
ClassMethod OutEDInfoHISUI(StationID, LocID As %String = "", PAADM As %String = "", IsAudit As %String = "1")
{
    
    i IsAudit="1"
    {
        q:$G(^DHCPEShowEDInfo(%session.Get("LOGON.USERID")))'="1"
        
        s SSID=##class(web.DHCPE.ResultEdit).GetSSId(PAADM,StationID)
        i SSID'=""
        {
            s Status=$P(^DHCPESS(SSID,1),"^",7)
            q:Status="SA"
            q:Status="GA"
        }
    }
    s RetStr=""
    s Job=$J
    s AdmLoc=$P(^PAADM(PAADM),"^",4)
    s loc=##class(web.DHCPE.DHCPECommon).GetEDloc(AdmLoc)
    
    s EDRowId=""
    f  s EDRowId=$o(^DHCPEED(0,"EDLOC",loc,EDRowId)) q:EDRowId=""  d
    .s activeFlag=$G(^DHCPECTDataEx("BaseData","DHCPEExpertDiagnosis","Active",EDRowId))
    .q:activeFlag="N"
    .s HighRisk=$P(^DHCPEED(EDRowId,1),"^",8)
    .q:HighRisk="Y"
    .s CurStation=$P(^DHCPEED(EDRowId,1),"^",7)
    .s:CurStation="" CurStation="99999999"
    .q:(StationID'="")&&(StationID'=CurStation)
    .s CurLocID=$P(^DHCPEED(EDRowId,1),"^",10)
    .q:(LocID'="")&&(CurLocID'=LocID)
    .s:CurLocID="" CurLocID="99999999"
    .s Desc=$P(^DHCPEED(EDRowId,1),"^",1)
    .q:$D(^TempDHCPEDesc(Job,Desc))
    .s ^TempDHCPEDesc(Job,Desc)=""
    .s StationSort=$P($G(^DHCPEST(CurStation)),"^",4)
    .s:StationSort="" StationSort="99999999"
    .s EDSort=$p(^DHCPEED(EDRowId,1),"^",9)
    .s:EDSort="" EDSort="99999999"
    .s ^TempDHCPE(Job,StationSort,CurStation,CurLocID,EDSort,Desc)=""
    k ^TempDHCPEDesc(Job)
    s StationSort=""
    s i=0
    
    
    
    
    
    
    s RetStr="<div id='edprefix' style='border: 1px solid #ccc;'>" 
    s RetStr=RetStr_"<Table id='EDTable' style='border: 1px solid #ccc; white-space:normal; word-break:break-all;'>"
    
    
    s RetStr=RetStr_"<tr><td colspan=2>模糊查询<input id='QueryED' style='width:120px;white-space:normal; word-break:break-all;' onkeydown='QueryED_KeyDown(this,"_StationID_","_PAADM_")'></td></tr>"

    s Sort=0
    f  s StationSort=$O(^TempDHCPE(Job,StationSort)) q:StationSort=""  d
    .s CurStation=""
    .f  s CurStation=$O(^TempDHCPE(Job,StationSort,CurStation)) q:CurStation=""  d
    ..s CurLocID=""
    ..f  s CurLocID=$O(^TempDHCPE(Job,StationSort,CurStation,CurLocID)) q:CurLocID=""  d
    ...s EDSort=""
    ...f  s EDSort=$O(^TempDHCPE(Job,StationSort,CurStation,CurLocID,EDSort)) q:EDSort=""  d
    ....s Desc=""
    ....f  s Desc=$O(^TempDHCPE(Job,StationSort,CurStation,CurLocID,EDSort,Desc)) q:Desc=""  d
    .....s Sort=Sort+1
    .....s:i=0 RetStr=RetStr_"<TR bgcolor='' style='border: 1px solid #ccc;white-space:normal; word-break:break-all;'>"
    .....s RetStr=RetStr_"<TD style='width:40px;border: 1px solid #ccc;white-space:normal; word-break:break-all;'>"_Sort_"</TD><TD style='width:260px;cursor:hand;white-space:normal; word-break:break-all;' oncontextmenu='contextmenu()' ondblclick='EDDEscOnDBLClick(this);' onmouseup='AllEDDescDBLClick(this);' onclick=EDClick() id='"_CurStation_"^"_Desc_"^"_CurLocID_"'>"_Desc_"</TD>"
    .....s i=i+1
    .....s:i=1 RetStr=RetStr_"<TR>"
    .....s:i=1 i=0
    s RetStr=RetStr_"</Table>"
    s RetStr=RetStr_"<Table id='EDTableDown' border=0 style='height:150px;white-space:normal; word-break:break-all;'>"
    s RetStr=RetStr_"</Table>"
    s RetStr=RetStr_"</div>"
    k ^TempDHCPE(Job)
    q RetStr
}
*/
/// Description: 获取站点或分类建议（多院区）
/// Input: StationID(站点ID), LocID(站点分类ID),PAADM(就诊ID)
/// Debug: w ##class(web.DHCPE.DocPatientFind).OutEDInfoHISUI()
ClassMethod OutEDInfoHISUI(StationID, LocID As %String = "", PAADM As %String = "", IsAudit As %String = "1")
{
    s ^tempdhcpe("OutEDInfoHISUI")=$lb(StationID,LocID,PAADM,IsAudit)
    
    if $d(%session) {
        set langId=%session.Get("LOGON.LANGID")
    }
    else
    { s langId=""}
    
    
    i IsAudit="1"
    {
        q:$G(^DHCPEShowEDInfo(%session.Get("LOGON.USERID")))'="1"
        
        s SSID=##class(web.DHCPE.ResultEdit).GetSSId(PAADM,StationID)
        i SSID'=""
        {
            s Status=$P($g(^DHCPESS(SSID,1)),"^",7)
            q:Status="SA"
            q:Status="GA"
        }
    }
    s RetStr=""
    s Job=$J
    s AdmLoc=$P($g(^PAADM(PAADM)),"^",4)  //就诊科室ID
    s loc=##class(web.DHCPE.DHCPECommon).GetEDloc(AdmLoc)

    s EDRowId=""
    f  s EDRowId=$o(^DHCPEED(EDRowId)) q:EDRowId=""  d
    .q:'$d(^DHCPEED(EDRowId))
    .s LocShowDFlag=##class(User.DHCPEExpertDiagnosis).GetLocShowDataFlag(EDRowId,AdmLoc)
    .q:LocShowDFlag'="Y" //过滤不是本科室的建议
    .s EDEffPowerFlag=##class(User.DHCPEExpertDiagnosis).GetLocShowDataFlag(EDRowId,AdmLoc)
    .s EDEffPowerFlag=$s(EDEffPowerFlag="Y":"Y",1:"N")
    .q:EDEffPowerFlag'="Y"  //过滤本科室未授权的建议
    .s activeFlag=$p($g(^DHCPEED(EDRowId,"1")),"^",13)  //激活
    .q:activeFlag'="Y"
    .s HighRisk=$P($g(^DHCPEED(EDRowId,1)),"^",8)
    .q:HighRisk="Y"
    .s CurStation=$P($g(^DHCPEED(EDRowId,1)),"^",7)
    .s:CurStation="" CurStation="99999999"
    .q:(StationID'="")&&(StationID'=CurStation)
    .s CurLocID=$P($g(^DHCPEED(EDRowId,1)),"^",10)
    .q:CurLocID'=LocID
    .s:CurLocID="" CurLocID="99999999"
    .s Desc=$P($g(^DHCPEED(EDRowId,1)),"^",1)
    .s Desc=##class(User.DHCPEExpertDiagnosis).GetTranByDesc("EDDiagnoseConclusion",Desc,langId)
    .q:$D(^TempDHCPEDesc(Job,Desc))
    .s ^TempDHCPEDesc(Job,Desc)=""
    .s StationSort=""
    .s StatSetID=$o(^CF.PE.StationSetI("IdxOfLocStation"," "_AdmLoc,CurStation,0))
    .i StatSetID'=""  s StationSort=$lg($g(^CF.PE.StationSetD(StatSetID)),5) //站点顺序
    .s:StationSort="" StationSort="99999999"
    .s EDSort=$p($g(^DHCPEED(EDRowId,1)),"^",9)
    .s:EDSort="" EDSort="99999999"
    .s ^TempDHCPE(Job,StationSort,CurStation,CurLocID,EDSort,Desc)=$P($g(^DHCPEED(EDRowId,1)),"^",1)
    k ^TempDHCPEDesc(Job)
    s StationSort=""
    s i=0
    
    s RetStr="<div id='edprefix' style='border: 1px solid #ccc;'>" 
    s RetStr=RetStr_"<Table id='EDTable' style='border: 1px solid #ccc; white-space:normal; word-break:break-all;'>"
    s RetStr=RetStr_"<tr><td colspan=2>"_##class(websys.Translation).Get("dhcpedocpatient.station.hisui.csp","模糊查询",langId)_"<input id='QueryED' style='width:120px;white-space:normal; word-break:break-all;' onkeydown='QueryED_KeyDown(this,"_StationID_","_PAADM_","""_LocID_""")'></td></tr>"

    s Sort=0
    f  s StationSort=$O(^TempDHCPE(Job,StationSort)) q:StationSort=""  d
    .s CurStation=""
    .f  s CurStation=$O(^TempDHCPE(Job,StationSort,CurStation)) q:CurStation=""  d
    ..s CurLocID=""
    ..f  s CurLocID=$O(^TempDHCPE(Job,StationSort,CurStation,CurLocID)) q:CurLocID=""  d
    ...s EDSort=""
    ...f  s EDSort=$O(^TempDHCPE(Job,StationSort,CurStation,CurLocID,EDSort)) q:EDSort=""  d
    ....s Desc=""
    ....f  s Desc=$O(^TempDHCPE(Job,StationSort,CurStation,CurLocID,EDSort,Desc)) q:Desc=""  d
    .....s RealDesc=$G(^TempDHCPE(Job,StationSort,CurStation,CurLocID,EDSort,Desc))
    .....s Sort=Sort+1
    .....s:i=0 RetStr=RetStr_"<TR bgcolor='' style='border: 1px solid #ccc;white-space:normal; word-break:break-all;'>"
    .....s RetStr=RetStr_"<TD style='width:40px;border: 1px solid #ccc;white-space:normal; word-break:break-all;'>"_Sort_"</TD><TD style='width:260px;cursor:hand;white-space:normal; word-break:break-all;' oncontextmenu='contextmenu()' ondblclick='EDDEscOnDBLClick(this);' onmouseup='AllEDDescDBLClick(this);' onclick=EDClick() id='"_CurStation_"^"_Desc_"^"_CurLocID_"^"_RealDesc_"'>"_Desc_"</TD>"
    .....s i=i+1
    .....s:i=1 RetStr=RetStr_"<TR>"
    .....s:i=1 i=0
    s RetStr=RetStr_"</Table>"
    s RetStr=RetStr_"<Table id='EDTableDown' border=0 style='height:150px;white-space:normal; word-break:break-all;'>"
    s RetStr=RetStr_"</Table>"
    s RetStr=RetStr_"</div>"
    k ^TempDHCPE(Job)
    q RetStr
}

ClassMethod OutEDInfo(StationID, LocID As %String = "", PAADM As %String = "", IsAudit As %String = "1")
{
    ;w ##class(web.DHCPE.DocPatientFind).OutEDInfo("7^^^0")
    i IsAudit="1"
    {
        q:$G(^DHCPEShowEDInfo(%session.Get("LOGON.USERID")))'="1"
        /*
        s IADM=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
        q:IADM=""
        s SSID=$O(^DHCPESS(0,"IADM",IADM,StationID,0))
        */
        s SSID=##class(web.DHCPE.ResultEdit).GetSSId(PAADM,StationID)
        i SSID'=""
        {
            s Status=$P(^DHCPESS(SSID,1),"^",7)
            q:Status="SA"
            q:Status="GA"
        }
    }
    s RetStr=""
    s Job=$J
    s AdmLoc=$P(^PAADM(PAADM),"^",4)
    s loc=##class(web.DHCPE.DHCPECommon).GetEDloc(AdmLoc)
    //s loc=##class(web.DHCPE.DHCPECommon).GetEDloc()
    s EDRowId=""
    f  s EDRowId=$o(^DHCPEED(0,"EDLOC",loc,EDRowId)) q:EDRowId=""  d
    .s activeFlag=$G(^DHCPECTDataEx("BaseData","DHCPEExpertDiagnosis","Active",EDRowId))
    .q:activeFlag="N"
    .s HighRisk=$P(^DHCPEED(EDRowId,1),"^",8)
    .q:HighRisk="Y"
    .s CurStation=$P(^DHCPEED(EDRowId,1),"^",7)
    .s:CurStation="" CurStation="99999999"
    .q:(StationID'="")&&(StationID'=CurStation)
    .s CurLocID=$P(^DHCPEED(EDRowId,1),"^",10)
    .q:(LocID'="")&&(CurLocID'=LocID)
    .s:CurLocID="" CurLocID="99999999"
    .s Desc=$P(^DHCPEED(EDRowId,1),"^",1)
    .q:$D(^TempDHCPEDesc(Job,Desc))
    .s ^TempDHCPEDesc(Job,Desc)=""
    .s StationSort=$P($G(^DHCPEST(CurStation)),"^",4)
    .s:StationSort="" StationSort="99999999"
    .s EDSort=$p(^DHCPEED(EDRowId,1),"^",9)
    .s:EDSort="" EDSort="99999999"
    .s ^TempDHCPE(Job,StationSort,CurStation,CurLocID,EDSort,Desc)=""
    k ^TempDHCPEDesc(Job)
    s StationSort=""
    s i=0
    //w:IsAudit="1" "<div style='overflow-y:auto;width:100%;height:100%;white-space:normal; word-break:break-all;'>"
    w "<div id='edprefix'  style='overflow-y:auto;width:100%;height:100%;white-space:normal; word-break:break-all;'>" 
    w "<Table id='EDTable' border=0.1 style='white-space:normal; word-break:break-all;'>"
    s Sort=0
    f  s StationSort=$O(^TempDHCPE(Job,StationSort)) q:StationSort=""  d
    .s CurStation=""
    .f  s CurStation=$O(^TempDHCPE(Job,StationSort,CurStation)) q:CurStation=""  d
    ..s CurLocID=""
    ..f  s CurLocID=$O(^TempDHCPE(Job,StationSort,CurStation,CurLocID)) q:CurLocID=""  d
    ...s EDSort=""
    ...f  s EDSort=$O(^TempDHCPE(Job,StationSort,CurStation,CurLocID,EDSort)) q:EDSort=""  d
    ....s Desc=""
    ....f  s Desc=$O(^TempDHCPE(Job,StationSort,CurStation,CurLocID,EDSort,Desc)) q:Desc=""  d
    .....s Sort=Sort+1
    .....w:i=0 "<TR bgcolor='' style='white-space:normal; word-break:break-all;'>"
    .....;w "<TD width=8%>"_Sort_"</TD><TD style='cursor:hand;white-space:normal; word-break:break-all;' oncontextmenu='contextmenu()' ondblclick='EDDEscOnDBLClick(this);' onclick=EDClick() id='"_CurStation_"^"_Desc_"'>"_Desc_"</TD>",!
    .....w "<TD width=8%>"_Sort_"</TD><TD style='cursor:hand;white-space:normal; word-break:break-all;' oncontextmenu='contextmenu()' ondblclick='EDDEscOnDBLClick(this);' onmouseup='AllEDDescDBLClick(this);' onclick=EDClick() id='"_CurStation_"^"_Desc_"^"_CurLocID_"'>"_Desc_"</TD>",!
    .....s i=i+1
    .....w:i=1 "<TR>"
    .....s:i=1 i=0
    w "</Table>",!
    w "</div>",! 
    //w:IsAudit="1" "</div>",!
    k ^TempDHCPE(Job)
    q RetStr
}

/// Description:  模糊查询各个站点下的建议
/// Input:        StationID(站点ID), LocID (站点分类ID),PAADM(就诊ID)
/// Debug:  w ##class(web.DHCPE.DocPatientFind).OutEDInfobyPrefix("3","","4800","0","乳腺")
ClassMethod OutEDInfobyPrefix(StationID, LocID As %String = "", PAADM As %String = "", IsAudit As %String = "1", Prefix As %String = "")
{
    
    s ^tempdhcpe("OutEDInfobyPrefix")=$lb(StationID,LocID,PAADM,IsAudit,Prefix )
    if $d(%session) {
        set langId=%session.Get("LOGON.LANGID")
    }
    else
    { s langId=""}
    i IsAudit="1"
    {
        //q:$G(^DHCPEShowEDInfo(%session.Get("LOGON.USERID")))'="1" "没有显示权限"
        s IADM=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
        q:IADM="" ""
        s SSID=$O(^DHCPESS(0,"IADM",IADM,StationID,0))
        i SSID'=""
        {
            q:SSID=""
            s Status=$P(^DHCPESS(SSID,1),"^",7)
            q:Status="SA" "科室已提交"
            q:Status="GA" "总检已提交"
        }
    }
    s ageSexStr=##class(web.DHCPE.ResultEdit).GetAgeSex(PAADM)
    s sexStr=$P(ageSexStr,"^",3)
    

    s RetStr=""
    s Job=$J
    //s loc=##class(web.DHCPE.DHCPECommon).GetEDloc(LocID)
    /*
    s EDRowId=""
    f  s EDRowId=$o(^DHCPEED(0,"EDLOC",loc,EDRowId)) q:EDRowId=""  d
    .s activeFlag=$G(^DHCPECTDataEx("BaseData","DHCPEExpertDiagnosis","Active",EDRowId))
    .q:activeFlag'="Y"
    .s HighRisk=$P(^DHCPEED(EDRowId,1),"^",8)
    .q:HighRisk="Y"
    .s EDSex=$G(^DHCPECTDataEx("BaseData","DHCPEExpertDiagnosis","Sex",EDRowId))
    .q:(EDSex'="")&&(EDSex'=sexStr)
    .s CurStation=$P(^DHCPEED(EDRowId,1),"^",7)
    .s:CurStation="" CurStation="99999999"
    .//q:(StationID'="")&&(StationID'=CurStation)
    .s CurLocID=$P(^DHCPEED(EDRowId,1),"^",10)
    .q:(LocID'="")&&(CurLocID'=LocID)
    .s:CurLocID="" CurLocID="99999999"
    */
    s AdmLoc=$P($g(^PAADM(PAADM)),"^",4)
    s EDRowId=""
    f  s EDRowId=$o(^DHCPEED(EDRowId)) q:EDRowId=""  d
    .q:'$D(^DHCPEED(EDRowId,1))
    .s LocShowDFlag=##class(User.DHCPEExpertDiagnosis).GetLocShowDataFlag(EDRowId,AdmLoc)
    .q:LocShowDFlag'="Y" //过滤不是本科室的建议
    .s EDEffPowerFlag=##class(User.DHCPEExpertDiagnosis).GetLocShowDataFlag(EDRowId,AdmLoc)
    .s EDEffPowerFlag=$s(EDEffPowerFlag="Y":"Y",1:"N")
    .q:EDEffPowerFlag'="Y"  //过滤本科室未授权的建议
    .s Active=$p($g(^DHCPEED(EDRowId,1)),"^",13)
    .s:Active="" Active="Y"
    .q:Active'="Y" //过滤未激活的建议
    .s HighRisk=$P($g(^DHCPEED(EDRowId,1)),"^",8)
    .q:HighRisk="Y" //过滤高危建议
    .s EDSex=$p($g(^DHCPEED(EDRowId,1)),"^",11)
    .q:(EDSex'="")&&(EDSex'=sexStr) //过滤性别不一致的建议
    .s CurStation=$P($g(^DHCPEED(EDRowId,1)),"^",7)
    .s:CurStation="" CurStation="99999999"
    .//q:(StationID'="")&&(StationID'=CurStation) //过滤站点不一致的建议  模糊查询需查询所有站点下的建议
    .s StatEffPowerFlag=##class(User.DHCPEStation).GetLocShowDataFlag(CurStation,AdmLoc)
    .s StatEffPowerFlag=$s(StatEffPowerFlag="Y":"Y",1:"N")
    .q:StatEffPowerFlag'="Y"  //过滤未授权的站点
    .s CurLocID=$P($g(^DHCPEED(EDRowId,1)),"^",10)
    .;q:(AdmLoc'="")&&(CurLocID'=AdmLoc)  //过滤分组不一致的建议
    .s:CurLocID="" CurLocID="99999999"
    .s Desc=$P($g(^DHCPEED(EDRowId,1)),"^",1)
    .s Desc=##class(User.DHCPEExpertDiagnosis).GetTranByDesc("EDDiagnoseConclusion",Desc,langId)
    .s DescPY=##class(web.DHCINSUPort).GetCNCODE(Desc,4,"")
    .i Prefix'="" s Prefix=$ZCVT(Prefix,"U") 
    .s ISLetter=##class(web.DHCPE.DHCPECommon).IsLetter(Prefix)
    .q:(ISLetter="1")&&(""'=Prefix)&&(DescPY'[Prefix)
    .q:(ISLetter="0")&&(""'=Prefix)&&(Desc'[Prefix)
    .;q:(""'=Prefix)&&(DescPY'[Prefix)
    .q:$D(^TempDHCPEDesc(Job,Desc))
    .s ^TempDHCPEDesc(Job,Desc)=""
    .;s StationSort=$P($G(^DHCPEST(CurStation)),"^",4)
    .s StationSort=""
    .s StationSetID=$o(^CF.PE.StationSetI("IdxOfLocStation"," "_AdmLoc,CurStation,""))
    .i StationSetID'="" s StationSort= $lg($g(^CF.PE.StationSetD(StationSetID)),5) //站点顺序
    .s:StationSort="" StationSort="99999999"
    .s EDSort=""
    .s EDSort=$p($g(^DHCPEED(EDRowId,1)),"^",9) //建议顺序
    .s:EDSort="" EDSort="99999999"
    .s:(StationID'="") CurStation=StationID
    .s ^TempDHCPE(Job,StationSort,CurStation,CurLocID,EDSort,Desc)=$P($g(^DHCPEED(EDRowId,1)),"^",1)
    k ^TempDHCPEDesc(Job)
    s StationSort=""
    s i=0


    s ret="<div id='edprefix' style='style='border:0; overflow-y:auto; white-space:normal; word-break:break-all;'>" 
    
    
     
    s ret=ret_"<Table id='EDTable' style='border:0; white-space:normal; word-break:break-all;'>"
    s ret=ret_"<tr style='border:0;height:6px;'><td style='border:0;width=40px;'></td><td style='border:0;width=255px;'></td></tr>"
    
    s ret=ret_"<tr style='border:0;'><td style='border:0;' colspan=2>"_##class(websys.Translation).Get("dhcpedocpatient.station.hisui.csp","模糊查询",langId)_"<input id='QueryED' style='width:120px;white-space:normal; word-break:break-all;' onkeydown='QueryED_KeyDown(this,"_StationID_","_PAADM_","""_LocID_""")'></td></tr>"
    
    s ret=ret_"<tr style='border:0;height:10px;'><td style='border:0;width=40px;'></td><td style='border:0;width=255px;'></td></tr>"
    
  
    s Sort=0
    f  s StationSort=$O(^TempDHCPE(Job,StationSort)) q:StationSort=""  d
    .s CurStation=""
    .f  s CurStation=$O(^TempDHCPE(Job,StationSort,CurStation)) q:CurStation=""  d
    ..s CurLocID=""
    ..f  s CurLocID=$O(^TempDHCPE(Job,StationSort,CurStation,CurLocID)) q:CurLocID=""  d
    ...s EDSort=""
    ...f  s EDSort=$O(^TempDHCPE(Job,StationSort,CurStation,CurLocID,EDSort)) q:EDSort=""  d
    ....s Desc=""
    ....f  s Desc=$O(^TempDHCPE(Job,StationSort,CurStation,CurLocID,EDSort,Desc)) q:Desc=""  d
    .....s Sort=Sort+1
    .....s RealDesc=$G(^TempDHCPE(Job,StationSort,CurStation,CurLocID,EDSort,Desc))
    .....s:i=0 ret=ret_"<TR bgcolor='' style='border: 1px solid #ccc;white-space:normal; word-break:break-all;'>"
    .....s ret=ret_"<TD style='width:40px;border: 1px solid #ccc;white-space:normal; word-break:break-all;'>"_Sort_"</TD><TD style='width:260px;cursor:hand;white-space:normal; word-break:break-all;' oncontextmenu='contextmenu()' ondblclick='EDDEscOnDBLClick(this);' onmouseup='AllEDDescDBLClick(this);' onclick=EDClick() id='"_CurStation_"^"_Desc_"^"_LocID_"^"_RealDesc_"'>"_Desc_"</TD>"
    .....s i=i+1
    .....s:i=1 ret=ret_"<TR>"
    .....s:i=1 i=0
    s ret=ret_"</Table>"
    s ret=ret_"<Table id='EDTableDown' border=0 style='height:150px;white-space:normal; word-break:break-all;'>"
    s ret=ret_"</Table>"
    s ret=ret_"</div>"
    
    
    
    k ^TempDHCPE(Job)
    q ret
}

ClassMethod GetGroupNameByPAADM(PAADM)
{
    q:PAADM="" ""
     s GDesc=""
     s IADMRowId=$O(^DHCPEIADM(0,"PAADM",PAADM,""))
     s PIADM=$P($G(^DHCPEIADM(IADMRowId)),"^",4)
     S PGADM=$P($G(^DHCPEPreIADM(PIADM)),"^",2)
     I PGADM'="" d
     .s PGBI=$p($g(^DHCPEPreGADM(PGADM)),"^",1)
     .s GDesc=$p($g(^DHCPEPreGBI(PGBI)),"^",2)
     q GDesc
}

Storage Default
{
<Data name="DocPatientFindDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCPE.DocPatientFindD</DataLocation>
<DefaultData>DocPatientFindDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCPE.DocPatientFindD</IdLocation>
<IndexLocation>^web.DHCPE.DocPatientFindI</IndexLocation>
<StreamLocation>^web.DHCPE.DocPatientFindS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
