/// CDSS后台数据统一输出类
/// Creator:WangQingyong
/// CreateDate:2020-07-13
Class DHCDoc.Interface.Inside.CDSS Extends %RegisteredObject
{

ClassMethod GetPatInfo(EpisodeID, UserID = "", LogonLocID = "", LogonHospID = "")
{
    Q ..GetPatInfoObj(EpisodeID, UserID, LogonLocID, LogonHospID).%ToJSON()
}

ClassMethod GetPatInfoObj(EpisodeID, UserID = "", LogonLocID = "", LogonHospID = "")
{
    if UserID=""{
        if $D(%session) s UserID=$G(%session.Data("LOGON.USERID"))
    }
    if LogonLocID=""{
        if $D(%session) s LogonLocID=$G(%session.Data("LOGON.CTLOCID"))
    }
    if LogonHospID=""{
        if $D(%session) s LogonHospID=$G(%session.Data("LOGON.HOSPID"))
    }
    s PatientID=$P(^PAADM(EpisodeID),"^",1)
    s PAAdmType=$P(^PAADM(EpisodeID),"^",2)
    s AdmType=$CASE(PAAdmType,"E":1,"O":2,"I":3,:"")
    s AdmObj={}
    s AdmObj.IDNO=EpisodeID ;$P(^PAPER(PatientID,"PAT",1),"^",1)
    s AdmObj.PatientDR=$P(^PAPER(PatientID,"PAT",1),"^",1)
    s AdmObj.VisitID=..GetAdmTimes(EpisodeID)
    s AdmObj.VisitType=AdmType              ;1急诊，2门诊，3住院
    s AdmObj.Name=$P(^PAPER(PatientID,"ALL"),"^",1)
    s AdmObj.UserID=UserID
    s AdmObj.UserName=$P(^SSU("SSUSR",UserID),"^",2)
    s AdmObj.DeptCode=$P(^CTLOC(LogonLocID),"^",1)
    s AdmObj.DeptName=$P(^CTLOC(LogonLocID),"^",2)
    s AdmObj.HospCode=$P(^CT("HOSP",LogonHospID),"^",1)
    s AdmObj.HospName=$P(^CT("HOSP",LogonHospID),"^",2)
    s AdmObj.PageSource=AdmType
    s AdmObj.PatientInfo={}
    s SexCode=$P(^CT("SEX",$P(^PAPER(PatientID,"ALL"),"^",7)),"^",1)
    s AdmObj.PatientInfo.Gender=$CASE(SexCode,1:1,2:0,:2)
    s AdmObj.PatientInfo.BirthDate=..DateLogicalToHtml($P(^PAPER(PatientID,"ALL"),"^",6))
    s AdmObj.PatientInfo.PregnancyStatus=0              ;妊娠状况   1:怀孕    0：未怀孕   
    Q AdmObj
}

ClassMethod GetDiagnosInfo(EpisodeID, DiagRowIdStr, UserID = "", LogonLocID = "", LogonHospID = "")
{
    s RetObj=..GetPatInfoObj(EpisodeID, UserID, LogonLocID, LogonHospID)
    s RetObj.DiagnosisList=[]
    s DoctorID=##class(web.SSUser).GetDefaultCareProvider(UserID)
    for i=1:1:$L(DiagRowIdStr,"^"){
        s oneRowIDStr=$P(DiagRowIdStr,"^",i)
        continue:(oneRowIDStr="")||(oneRowIDStr=0)
        s DiagID=$P(oneRowIDStr,$C(1),1)
        s Type=$P(oneRowIDStr,$C(1),3)
        d RetObj.DiagnosisList.%Push(..GetOneDiagJSON(DiagID,DoctorID,Type))
    }
    Q RetObj.%ToJSON()
}

ClassMethod GetAllDiagnos(EpisodeID, UserID = "", LogonLocID = "", LogonHospID = "")
{
    s RetObj=..GetPatInfoObj(EpisodeID, UserID, LogonLocID, LogonHospID)
    s RetObj.DiagnosisList=[]
    s DoctorID=##class(web.SSUser).GetDefaultCareProvider(UserID)
    s MRAdm=$P(^PAADM(EpisodeID),"^",61)
    s MRSub=0 for{
        s MRSub=$O(^MR(MRAdm,"DIA",MRSub)) Q:MRSub=""
        d RetObj.DiagnosisList.%Push(..GetOneDiagJSON(MRAdm_"||"_MRSub,DoctorID))
    }
    Q RetObj.%ToJSON()
}

ClassMethod GetOneDiagJSON(DiagID, DoctorID, Type = "")
{
    s DiagObj={}
    //新增与删除的区分
    if $D(^MR(+DiagID,"DIA",$P(DiagID,"||",2))){
	    s ICDRowid=$P($G(^MR(+DiagID,"DIA",$P(DiagID,"||",2))),"^",1)
        s BillFlag1=$P($G(^MRC("ID",+ICDRowid)),"^",13)
	    s BillFlag3=$P($G(^MRC("ID",+ICDRowid)),"^",15)
	    s DiagObj.DiagnosisId=DiagID
	    s DiagObj.DiagnosisCode=$P($G(^MRC("ID",+ICDRowid)),"^",1)
	    s DiagObj.DiagnosisName=$P($G(^MRC("ID",+ICDRowid)),"^",2)
	    s DiagTypeID=$P($G(^MR(+DiagID,"DIA",$P(DiagID,"||",2),"TYP",1)),"^",1)
	    s DiagTypeCode=$P($G(^MRC("DTYP",+DiagTypeID)),"^",1)
	    //诊断类型：1 入院诊断（type为空时默认为入院诊断）2 初步诊断3 更正诊断4 补充诊断5 出院诊断6 死亡诊断7 留观诊断8 门诊诊断
	    s DiagObj.DiagnosisType=$CASE(DiagTypeCode,"DIS":5,"PRE":2,"C008":1,"OP":8,"COR":3,"MOD":3,"SUPP":4,:"") 
	    s DiagObj.DiagnosisDoctorType=$CASE(BillFlag3,"Y":2,:1)                                 ;1.西医诊断。2.中医诊断
        s DiagObj.DiagnosisClass=$SELECT((BillFlag1="Y")&&(BillFlag3="Y"):"证型",BillFlag3="Y":"中医",1:"西医")
	    s MainDiagFlag=$p($g(^MR($P(DiagID,"||",1),"DIA",$P(DiagID,"||",2),1)),"^",20)
	    s DiagObj.IsMainDiagnosis=MainDiagFlag="Y"                                  ;是否主诊断
	    s DiagObj.DiagnosisSequence=$P($G(^MR(+DiagID,"DIA",$P(DiagID,"||",2),"EPR")),"^",2)    ;诊断顺序
	    s DiagDate=..DateLogicalToHtml($P($G(^MR(+DiagID,"DIA",$P(DiagID,"||",2))),"^",7))
	    s:DiagDate["/" DiagDate=$zd($P($G(^MR(+DiagID,"DIA",$P(DiagID,"||",2))),"^",7),3)
	    s DiagTime=..TimeLogicalToHtml($P($G(^MR(+DiagID,"DIA",$P(DiagID,"||",2))),"^",8))
	    s DiagObj.RecordTime=DiagDate_" "_DiagTime
	    s DiagObj.DiagnosisDoctorId=DoctorID
	    s DiagObj.DiagnosisDoctorName=$P($G(^CTPCP(+DiagObj.DiagnosisDoctorId,1)),"^",2)
	    s DiagObj.DiagFlag=$CASE(Type,"U":3,:1)
    }else{
		m DataList=^MRDelLog(+DiagID,"Sub",$P(DiagID,"||",2),"Data")
		s ICDRowid=$P(DataList,"^",1)
        s BillFlag1=$P($G(^MRC("ID",+ICDRowid)),"^",13)
	    s BillFlag3=$P($G(^MRC("ID",+ICDRowid)),"^",15)
	    s DiagObj.DiagnosisId=DiagID
	    s DiagObj.DiagnosisCode=$P($G(^MRC("ID",+ICDRowid)),"^",1)
	    s DiagObj.DiagnosisName=$P($G(^MRC("ID",+ICDRowid)),"^",2)
	    s DiagTypeID=$P($G(DataList("TYP",1)),"^",1)
	    s DiagTypeCode=$P($G(^MRC("DTYP",+DiagTypeID)),"^",1)
	    //诊断类型：1 入院诊断（type为空时默认为入院诊断）2 初步诊断3 更正诊断4 补充诊断5 出院诊断6 死亡诊断7 留观诊断6 门诊诊断
	    s DiagObj.DiagnosisType=$CASE(DiagTypeCode,"DIS":5,"PRE":2,"C008":1,"OP":8,"COR":3,"MOD":3,"SUPP":4,:"") 
	    s DiagObj.DiagnosisDoctorType=$CASE(BillFlag3,"Y":2,:1)                                 ;1.西医诊断。2.中医诊断
        s DiagObj.DiagnosisClass=$SELECT((BillFlag1="Y")&&(BillFlag3="Y"):"证型",BillFlag3="Y":"中医",1:"西医")
	    s MainDiagFlag=$p($g(DataList(1)),"^",20)
	    s DiagObj.IsMainDiagnosis=MainDiagFlag="Y"                                       ;是否主诊断
	    s DiagObj.DiagnosisSequence=$P($G(DataList("EPR")),"^",2)    ;诊断顺序
	    s DiagDate=..DateLogicalToHtml($P(DataList,"^",7))
	    s:DiagDate["/" DiagDate=$zd($P($G(DataList),"^",7),3)
	    s DiagTime=..TimeLogicalToHtml($P($G(DataList),"^",8))
	    s DiagObj.RecordTime=DiagDate_" "_DiagTime
	    s DiagObj.DiagnosisDoctorId=DoctorID
	    s DiagObj.DiagnosisDoctorName=$P($G(^CTPCP(+DiagObj.DiagnosisDoctorId,1)),"^",2)
	    s DiagObj.DiagFlag=2
	}
    Q DiagObj
}

ClassMethod GetDiagStrInfo(EpisodeID, DiagItemStr, UserID = "", LogonLocID = "", LogonHospID = "")
{
	s RetObj=..GetPatInfoObj(EpisodeID, UserID, LogonLocID, LogonHospID)
    s DoctorID=##class(web.SSUser).GetDefaultCareProvider(UserID)
    s RetObj.DiagnosisList=[]
    for i=1:1:$l(DiagItemStr,$c(1)){
		s DiagItem=$p(DiagItemStr,$c(1),i)
		continue:DiagItem=""
		d RetObj.DiagnosisList.%Push(..GetOneDiagStrInfo(DiagItem,DoctorID))
    }
    Q RetObj.%ToJSON()
}

ClassMethod GetOneDiagStrInfo(DiagItem, DoctorID)
{
	s DiagObj={}
	s MRDIARowId=$p(DiagItem,"^",1)
	if MRDIARowId'=""{	;更新诊断与新增诊断数据位置不一样
	    s ICDRowid=$p(DiagItem,"^",11)
	    s BillFlag3=$P($G(^MRC("ID",+ICDRowid)),"^",15)
	    s DiagObj.DiagnosisId=MRDIARowId
	    s DiagObj.DiagnosisCode=$P($G(^MRC("ID",+ICDRowid)),"^",1)
	    s DiagObj.DiagnosisName=$P($G(^MRC("ID",+ICDRowid)),"^",2)
	    s DiagTypeID=$p(DiagItem,"^",3)
	    s DiagTypeCode=$P($G(^MRC("DTYP",+DiagTypeID)),"^",1)
	    //诊断类型：1 入院诊断（type为空时默认为入院诊断）2 初步诊断3 更正诊断4 补充诊断5 出院诊断6 死亡诊断7 留观诊断6 门诊诊断
	    s DiagObj.DiagnosisType=$CASE(DiagTypeCode,"DIS":5,"PRE":2,"C008":1,"OP":6,"COR":3,:"") 
	    s DiagObj.DiagnosisDoctorType=$CASE(BillFlag3,"Y":2,:1)                                 ;1.西医诊断。2.中医诊断
	    s MainDiagFlag=$p(DiagItem,"^",4)
	    s DiagObj.IsMainDiagnosis=MainDiagFlag="Y"                                                ;是否主诊断
	    s DiagObj.DiagnosisSequence=$P($G(^MR(+MRDIARowId,"DIA",$P(MRDIARowId,"||",2),"EPR")),"^",2)    ;诊断顺序
	    s DiagDate=..DateLogicalToHtml($P($G(^MR(+MRDIARowId,"DIA",$P(MRDIARowId,"||",2))),"^",7))
	    s:DiagDate["/" DiagDate=$zd($P($G(^MR(+MRDIARowId,"DIA",$P(MRDIARowId,"||",2))),"^",7),3)
	    s DiagTime=..TimeLogicalToHtml($P($G(^MR(+MRDIARowId,"DIA",$P(MRDIARowId,"||",2))),"^",8))
	    s DiagObj.RecordTime=DiagDate_" "_DiagTime
	    s DiagObj.DiagnosisDoctorId=$P($G(^MR(+MRDIARowId,"DIA",$P(MRDIARowId,"||",2))),"^",4)
	    s DiagObj.DiagnosisDoctorName=$P($G(^CTPCP(+DiagObj.DiagnosisDoctorId,1)),"^",2)
	    s DiagObj.DiagFlag=3
	}else{
	    s ICDRowid=$p(DiagItem,"^",3)
	    s BillFlag3=$P($G(^MRC("ID",+ICDRowid)),"^",15)
	    s DiagObj.DiagnosisId=MRDIARowId
	    s DiagObj.DiagnosisCode=$P($G(^MRC("ID",+ICDRowid)),"^",1)
	    s DiagObj.DiagnosisName=$P($G(^MRC("ID",+ICDRowid)),"^",2)
	    s DiagTypeID=$p(DiagItem,"^",4)
	    s DiagTypeCode=$P($G(^MRC("DTYP",+DiagTypeID)),"^",1)
	    //诊断类型：1 入院诊断（type为空时默认为入院诊断）2 初步诊断3 更正诊断4 补充诊断5 出院诊断6 死亡诊断7 留观诊断6 门诊诊断
	    s DiagObj.DiagnosisType=$CASE(DiagTypeCode,"DIS":5,"PRE":2,"C008":1,"OP":6,"COR":3,:"") 
	    s DiagObj.DiagnosisDoctorType=$CASE(BillFlag3,"Y":2,:1)                                 ;1.西医诊断。2.中医诊断
	    s MainDiaType=$p(DiagItem,"^",5)
	    s DiagObj.IsMainDiagnosis=(MainDiaType="Y")                                                ;是否主诊断
	    s DiagObj.DiagnosisSequence=""    ;诊断顺序
	    s DiagDate=..DateLogicalToHtml($p(DiagItem,"^",11))
	    s DiagTime=..TimeLogicalToHtml($P($H,",",2))
	    s DiagObj.RecordTime=DiagDate_" "_DiagTime
	    s DiagObj.DiagnosisDoctorId=DoctorID
	    s DiagObj.DiagnosisDoctorName=$P($G(^CTPCP(+DiagObj.DiagnosisDoctorId,1)),"^",2)
	    s DiagObj.DiagFlag=1
	}
    Q DiagObj
}

ClassMethod GetOrderInfo(EpisodeID, OrdItemStr, UserID = "", LogonLocID = "", LogonHospID = "")
{
    s PAAdmType=$P(^PAADM(EpisodeID),"^",2)
    s OrdItemType=$CASE(PAAdmType,"I":1,"O":2,"E":3,:0)
    s RetObj=..GetPatInfoObj(EpisodeID, UserID, LogonLocID, LogonHospID)
    s RetObj.OrderEntry=[]
    for i=1:1:$L(OrdItemStr,"^"){
        s OrdItemID=$p(OrdItemStr,"^",i)
        s OrdItemID=$P(OrdItemID,$C(1))
        s:OrdItemID["*" OrdItemID=$p(OrdItemID,"*",2)
        continue:OrdItemID=""
        d RetObj.OrderEntry.%Push(..GetOneOrdInfo(OrdItemID,OrdItemType))
    }
    Q RetObj.%ToJSON()
}

ClassMethod GetAllOrderInfo(EpisodeID, UserID = "", LogonLocID = "", LogonHospID = "")
{
    s PAAdmType=$P(^PAADM(EpisodeID),"^",2)
    s OrdItemType=$CASE(PAAdmType,"I":1,"O":2,"E":3,:0)
    s RetObj=..GetPatInfoObj(EpisodeID, UserID, LogonLocID, LogonHospID)
    s RetObj.OrderEntry=[]
    s Ord=$O(^OEORD(0,"Adm",EpisodeID,0))
    s Sub=0 for{
        s Sub=$O(^OEORD(+Ord,"I",Sub)) Q:Sub=""
        s StatusDr=$P(^OEORD(+Ord,"I",Sub,1),"^",13)
        s StatusCode=$P(^OEC("OSTAT",StatusDr),"^",1)
        continue:(("VE")'[StatusCode)||((PAAdmType'="I")&&(StatusCode="D"))
        d RetObj.OrderEntry.%Push(..GetOneOrdInfo(Ord_"||"_Sub,OrdItemType))
    }
    Q RetObj.%ToJSON()
}

ClassMethod GetReqOrdInfo(EpisodeID, ReqIDStr, Type = "", UserID = "", LogonLocID = "", LogonHospID = "")
{
    s PAAdmType=$P(^PAADM(EpisodeID),"^",2)
    s OrdItemType=$CASE(PAAdmType,"I":1,"O":2,"E":3,:0)
    s RetObj=..GetPatInfoObj(EpisodeID, UserID, LogonLocID, LogonHospID)
    s RetObj.OrderEntry=[]
    for i=1:1:$L(ReqIDStr,"^"){
        s ReqID=$p(ReqIDStr,"^",i)
        continue:ReqID=""
        if Type="P"{
            s CH="" for{
                s CH=$o(^DHCAPPPM(ReqID,"A",CH)) Q:CH=""
	            s OrdItemID=$p(^DHCAPPPM(ReqID,"A",CH),"^",3)
                 continue:OrdItemID=""
                d RetObj.OrderEntry.%Push(..GetOneOrdInfo(OrdItemID,OrdItemType))
            }
        }else{
            s CH="" for{
                s CH=$o(^DHCAPREP(ReqID,"AR",CH)) Q:CH=""
                s OrdItemID=$p(^DHCAPREP(ReqID,"AR",CH),"^",3)
                continue:OrdItemID=""
                d RetObj.OrderEntry.%Push(..GetOneOrdInfo(OrdItemID,OrdItemType))
            }
        }
    }
    Q RetObj.%ToJSON()
}

ClassMethod GetReqItemInfo(EpisodeID, ReqItmID, Type = "", UserID = "", LogonLocID = "", LogonHospID = "")
{
    s PAAdmType=$P(^PAADM(EpisodeID),"^",2)
    s OrdItemType=$CASE(PAAdmType,"I":1,"O":2,"E":3,:0)
    s RetObj=..GetPatInfoObj(EpisodeID, UserID, LogonLocID, LogonHospID)
    s RetObj.OrderEntry=[]
    if Type="P"{
        s OrdItemID=$p(^DHCAPPPM(+ReqItmID,"A",$P(ReqItmID,"||",2)),"^",3)
        if OrdItemID'=""{
            d RetObj.OrderEntry.%Push(..GetOneOrdInfo(OrdItemID,OrdItemType))
        }
    }else{
        s OrdItemID=$p(^DHCAPREP(+ReqItmID,"AR",$P(ReqItmID,"||",2)),"^",3)
        if OrdItemID'=""{
            d RetObj.OrderEntry.%Push(..GetOneOrdInfo(OrdItemID,OrdItemType))
        }
    }
    Q RetObj.%ToJSON()
}

ClassMethod GetOneOrdInfo(OrdItemID, OrdItemType)
{
    s OrdObj={}
    s ARCIMRowid=$P(^OEORD(+OrdItemID,"I",$P(OrdItemID,"||",2),1),"^",2)
    s OrdObj.OrderID=OrdItemID
    s PriorID=$P(^OEORD(+OrdItemID,"I",$P(OrdItemID,"||",2),1),"^",8)
    s PriorCode=$P(^OECPR(PriorID),"^",1) 
    s OrdObj.PriorType=$CASE(##class(appcom.OEOrdItem).ISLongOrderPrior(PriorID),1:"Long",:"Short")
    s OrdObj.OrderClass=$CASE(PriorCode["OUT",1:4,:OrdItemType) ;1住院医嘱2 门诊医嘱3 急诊医嘱4 出院医嘱0 门诊医嘱
    s OrdObj.OrderFlag=1                ;1 新增 2 取消  3删除 4停止
    s StatusDR=$P(^OEORD(+OrdItemID,"I",$P(OrdItemID,"||",2),1),"^",13)
    s StatusCode=$P(^OEC("OSTAT",StatusDR),"^",1)
    if (OrdObj.PriorType="Long")&&(StatusCode="D") s OrdObj.OrderFlag=4
    else  if ("UCD"[StatusCode) s OrdObj.OrderFlag=2
    s OrdObj.OrderType=..GetOrderType(ARCIMRowid)
    s InsertDate=..DateLogicalToHtml($P(^OEORD(+OrdItemID,"I",$P(OrdItemID,"||",2),1),"^",19))
    s InsertTime=..TimeLogicalToHtml($P(^OEORD(+OrdItemID,"I",$P(OrdItemID,"||",2),1),"^",20))
    s OrdObj.CreatTime=InsertDate_" "_InsertTime
    if OrdObj.OrderFlag=2{
        s StatusSub=$O(^OEORD(+OrdItemID,"I",$P(OrdItemID,"||",2),"ST",""),-1)
        s StatusDate=..DateLogicalToHtml($P(^OEORD(+OrdItemID,"I",$P(OrdItemID,"||",2),"ST",StatusSub),"^",1))
        s StatusTime=..TimeLogicalToHtml($P(^OEORD(+OrdItemID,"I",$P(OrdItemID,"||",2),"ST",StatusSub),"^",2))
        s OrdObj.StopTime=StatusDate_" "_StatusTime
    }else{
        s OrdObj.StopTime=""
    }
    s OrdObj.DoctorId=$P(^OEORD(+OrdItemID,"I",$P(OrdItemID,"||",2),1),"^",11)
    s OrdObj.DoctorName=$P($G(^CTPCP(+OrdObj.DoctorId,1)),"^",2)
    s OrdDepDR=$P($G(^OEORD(+OrdItemID,"I",$P(OrdItemID,"||",2),7)),"^",2)
    s OrdObj.CreateDeptCode=$P($G(^CTLOC(+OrdDepDR)),"^",1)
    s OrdObj.CreatDeptName=$P($G(^CTLOC(+OrdDepDR)),"^",2)
    s OrdObj.GroupSequence=$P($G(^OEORD(+OrdItemID,"I",$P(OrdItemID,"||",2),3)),"^",4)
    s OrdObj.OrderCode=$P(^ARCIM(+ARCIMRowid,1,1),"^",1)
    s OrdObj.OrderContent=$P(^ARCIM(+ARCIMRowid,1,1),"^",2)
    s OrdObj.Dosage=$P($G(^OEORD(+OrdItemID,"I",$P(OrdItemID,"||",2),2)),"^",1)
    s OrdObj.Unit=$P($G(^OEORD(+OrdItemID,"I",$P(OrdItemID,"||",2),2)),"^",3)
    s:OrdObj.Unit'="" OrdObj.Unit=$P(^CT("UOM",OrdObj.Unit),"^",2)
    s OrdObj.Frequency=$P($G(^OEORD(+OrdItemID,"I",$P(OrdItemID,"||",2),2)),"^",4)
    s:OrdObj.Frequency'="" OrdObj.Frequency=$P(^PHCFR(OrdObj.Frequency),"^",3)
    s InciId=##class(web.DHCDocOrderEntry).GetINCI(+ARCIMRowid)
    if InciId'=""{
        s OrdObj.Specification=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",InciId)
    }else{
        s OrdObj.Specification=""
    }
    s OrdObj.Pathway=$P($G(^OEORD(+OrdItemID,"I",$P(OrdItemID,"||",2),2)),"^",7)
    s:OrdObj.Pathway'="" OrdObj.Pathway=$P(^PHCIN(OrdObj.Pathway),"^",1)
    s OrdObj.Sample=##class(web.DHCOEOrdItem).GetLabSpec(OrdItemID)
    s OrdObj.Position=##Class(web.DHCAPPInterface).GetExaReqPartDesc(OrdItemID)
    s OrdObj.Level=""                   ;手术级别
    s OrdObj.IncisionType=""            ;切口类型
    s OrdObj.Anesthesia=""              ;麻醉方式
    s OrdObj.PreoperativeDiagnose=""    ;术前诊断
    Q OrdObj
}

ClassMethod GetOrdItemStrInfo(EpisodeID, OrdItemStr, UserID = "", LogonLocID = "", LogonHospID = "")
{
	s PAAdmType=$P(^PAADM(EpisodeID),"^",2)
    s OrdItemType=$CASE(PAAdmType,"I":1,"O":2,"E":3,:0)
    s RetObj=..GetPatInfoObj(EpisodeID, UserID, LogonLocID, LogonHospID)
    s DoctorID=##class(web.SSUser).GetDefaultCareProvider(UserID)
    s RetObj.OrderEntry=[]
    for i=1:1:$L(OrdItemStr,$C(1)){
        s OrdItem=$p(OrdItemStr,$C(1),i)
        continue:OrdItem=""
        d RetObj.OrderEntry.%Push(..GetOneItemStrInfo(OrdItem,OrdItemType, DoctorID, LogonLocID,LogonHospID))
    }
    Q RetObj.%ToJSON()
}

ClassMethod GetOneItemStrInfo(OrdItem, OrdItemType, DoctorID, LocID, HospitalId)
{
	s OrdObj={}
    s ARCIMRowid=$p(OrdItem,"^",1)
    s OrdObj.OrderID=$p(OrdItem,"^",20)
    s:OrdObj.OrderID="" OrdObj.OrderID=1
    s PriorID=$p(OrdItem,"^",3)
    s:PriorID="" PriorID=$O(^OECPR(0,"Code","NORM",0))
    s PriorCode=$P(^OECPR(PriorID),"^",1) 
    s OrdObj.PriorType=$CASE(##class(appcom.OEOrdItem).ISLongOrderPrior(PriorID),1:"Long",:"Short")
    s OrdObj.OrderClass=$CASE(PriorCode["OUT",1:4,:OrdItemType) ;1住院医嘱2 门诊医嘱3 急诊医嘱4 出院医嘱0 门诊医嘱
    s OrdObj.OrderFlag=1                ;1 新增 2 取消  
    s OrdObj.OrderType=..GetOrderType(ARCIMRowid)
    s InsertDate=..DateLogicalToHtml(+$H)
    s InsertTime=..TimeLogicalToHtml($P($H,",",2))
    s OrdObj.CreatTime=InsertDate_" "_InsertTime
    s OrdObj.StopTime=""
    s OrdObj.DoctorId=DoctorID
    s OrdObj.DoctorName=$P($G(^CTPCP(+DoctorID,1)),"^",2)
    s OrdObj.CreateDeptCode=$P($G(^CTLOC(+LocID)),"^",1)
    s OrdObj.CreatDeptName=$P($G(^CTLOC(+LocID)),"^",2)
    s OrdObj.GroupSequence=$p(OrdItem,"^",19)
    s OrdObj.OrderCode=$P(^ARCIM(+ARCIMRowid,1,1),"^",1)
    s OrdObj.OrderContent=$P(^ARCIM(+ARCIMRowid,1,1),"^",2)
    s OrdObj.Dosage=$p(OrdItem,"^",12)
    s OrdObj.Unit=$p(OrdItem,"^",13)
    s:OrdObj.Unit'="" OrdObj.Unit=$P(^CT("UOM",OrdObj.Unit),"^",2)
    s OrdObj.Frequency=$p(OrdItem,"^",15)
    s:OrdObj.Frequency'="" OrdObj.Frequency=$P(^PHCFR(OrdObj.Frequency),"^",3)
    s InciId=##class(web.DHCDocOrderEntry).GetINCI(+ARCIMRowid)
    if InciId'=""{
        s OrdObj.Specification=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",InciId)
    }else{
        s OrdObj.Specification=""
    }
    s OrdObj.Pathway=$p(OrdItem,"^",17)
    s:OrdObj.Pathway'="" OrdObj.Pathway=$P(^PHCIN(OrdObj.Pathway),"^",1)
    s SpecCode=$p(OrdItem,"^",28)
    i SpecCode'="" d
    .s HospitalCode=##class(web.DHCDocOrderCommon).GetCurrentSYSHospitalCode(HospitalId)
	.s OrdObj.Sample=$p(##Class(DHCLIS.DHCCommon).GetSpecimen(SpecCode,$g(HospitalCode)),$c(2),2)
	e  d
	.s OrdObj.Sample=""
    s OrdObj.Position=""
    s OrdObj.Level=""                   ;手术级别
    s OrdObj.IncisionType=""            ;切口类型
    s OrdObj.Anesthesia=""              ;麻醉方式
    s OrdObj.PreoperativeDiagnose=""    ;术前诊断
    Q OrdObj
}

/// w ##class(DHCDoc.Interface.Inside.CDSS).GetAllergyInfo(3870898)
ClassMethod GetAllergyInfo(EpisodeID)
{
	s RetObj={}
	s PatientID=$P(^PAADM(EpisodeID),"^",1)
    s RetObj.IDNO=EpisodeID     ;$P(^PAPER(PatientID,"ALL"),"^",9)
    s RetObj.PatientDR=$P(^PAPER(PatientID,"PAT",1),"^",1)
    s RetObj.children=[]
	s ALGSub=0 for{
		s ALGSub=$O(^PAPER(PatientID,"ALG",ALGSub)) Q:ALGSub=""
		s Status=$P(^PAPER(PatientID,"ALG",ALGSub),"^",8)
		continue:Status'="A"
		s ALGTypeDR=$P(^PAPER(PatientID,"ALG",ALGSub),"^",9)
		s ALGType=$P($G(^PAC("ALG",+ALGTypeDR)),"^",2)
		s CatID=$P($G(^PAC("ALG",+ALGTypeDR)),"^",3)
		s Cat=$P($G(^MRC("AT",+CatID)),"^",2)
		s ALGItemID=$P(^PAPER(PatientID,"ALG",ALGSub),"^",4)
		s ALGItem=$P($G(^PHCGE("GE",+ALGItemID)),"^",2)
		s ALGDate=..DateLogicalToHtml($P(^PAPER(PatientID,"ALG",ALGSub),"^",14))
		s ALGTime=..TimeLogicalToHtml($P(^PAPER(PatientID,"ALG",ALGSub),"^",15))
		s UpdateUserDR=$P(^PAPER(PatientID,"ALG",ALGSub),"^",16)
		s UpdateUser=$P($G(^SSU("SSUSR",+UpdateUserDR)),"^",2)
		s UpdateDate=..DateLogicalToHtml($P(^PAPER(PatientID,"ALG",ALGSub),"^",23))
		s ExternalID=$P(^PAPER(PatientID,"ALG",ALGSub),"^",30)
		if ExternalID["||" s ALGItem=$P(^ARCIM(+ExternalID,1,1),"^",2)
		s obj={}
		s obj.AllergySourceType=Cat
		s obj.AllergySourceName=ALGType
		s obj.AllergyItem=ALGItem
		s obj.StartTime=ALGDate_" "_ALGTime
		s obj.EndTime=""
		s obj.RiskLevel=""
		s obj.TreatmentEffect=""
		s obj.RegisterData=UpdateDate
		s obj.RegisterUser=UpdateUser
		s obj.Remarks=$G(^PAPER(PatientID,"ALG",ALGSub,"CMT",1))
		s obj.PassFlag=0
		d RetObj.children.%Push(obj)
		
	}
	Q RetObj.%ToJSON()
}

/// 1 药品 2检查 3 检验 4 手术 5 护理 6 处置 7 膳食 8 会诊 9 麻醉 10其他
ClassMethod GetOrderType(ARCIMRowid)
{
    s ServerMaterial=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),7)),"^",6)
    Q:(ServerMaterial="Service")||(ServerMaterial="S") 2
    s ItemCatDR=$P(^ARCIM(+ARCIMRowid,1,1),"^",10)
    s ItemType=$P(^ARC("IC",ItemCatDR),"^",7)
    Q:ItemType="R" 1
    Q:ItemType="L" 3
    s ItemCat=$P(^ARC("IC",ItemCatDR),"^",2)
    Q:ItemCat["手术" 4
    Q:ItemCat["护理" 5
    Q:ItemCat["处置" 6
    Q:ItemCat["膳食" 7
    Q:ItemCat["会诊" 8
    Q:ItemCat["麻醉" 9
    Q 10
}

ClassMethod GetAdmTimes(EpisodeID)
{
    s AdmTimes=0
    s AdmType=$P(^PAADM(EpisodeID),"^",2)
    s PatientID=$P(^PAADM(EpisodeID),"^",1)
    s AdmID=0 for{
        s AdmID=$O(^PAPERdr(PatientID,"ADM",AdmType,AdmID)) Q:AdmID=""
        s VisitStatus=$P(^PAADM(AdmID),"^",20)
        if "AD"[VisitStatus{
            s AdmTimes=AdmTimes+1
        }
        Q:EpisodeID=AdmID
    }
    Q AdmTimes
}

ClassMethod GetICDRowidByCode(Code)
{
	s ID=""
	&SQL(SELECT MRCID_RowId INTO :ID FROM SQLUser.MRC_ICDDx WHERE MRCID_ICD9CM_Code=:Code AND (MRCID_DateActiveTo IS NULL OR MRCID_DateActiveTo>+$H))
	Q ID
}

ClassMethod GetARCIMRowidByCode(Code)
{
	s ID=""
	&SQL(SELECT ARCIM_RowId INTO :ID FROM SQLUser.ARC_ItmMast WHERE ARCIM_Code=:Code)
	Q ID
}

/// w ##class(DHCDoc.Interface.Inside.CDSS).CheckOrderEntry("502","6745||1","12175","113","2")
ClassMethod CheckOrderEntry(EpisodeID, ARCIMRowid, UserID, LogonLocID, LogonHospID)
{
	;s ^Wqy("CheckOrderEntry")=$LB(EpisodeID, ARCIMRowid, UserID, LogonLocID, LogonHospID)
	s AdmObj=..GetPatInfoObj(EpisodeID,UserID,LogonLocID ,LogonHospID)
	s Arg1=AdmObj.IDNO_"^"_AdmObj.PatientDR_"^"_AdmObj.VisitID_"^"_AdmObj.VisitType_"^"_AdmObj.UserID_"^"_AdmObj.UserName_"^"_AdmObj.DeptCode_"^"_AdmObj.DeptName
	s Arg2=$P(^ARCIM(+ARCIMRowid,1,1),"^",2)
	s Arg3=..GetOrderType(ARCIMRowid)
	s str="web.CDSS.WarnDecision.SingleOrderWarning[A]GetOrderWarningByRule[A]"_Arg1_"[A]"_Arg2_"[A]"_Arg3
	s CDSSRet=##class(web.CDSS.Public.MethodForWebservice).CallMethod(str)
	Q:CDSSRet="" ""
	s CDSSRet=[].%FromJSON(CDSSRet)
	Q:'CDSSRet.%Size() ""
	Q CDSSRet.%Get(0).ControlMode_"^"_CDSSRet.%Get(0).WarningTip
}

ClassMethod DateLogicalToHtml(Date)
{
	Q:Date="" ""
	Q $ZD(Date,3)
}

ClassMethod TimeLogicalToHtml(Time)
{
	Q:Time="" ""
	Q $ZT(Time)
}

}
