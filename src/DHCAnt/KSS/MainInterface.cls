/// CTOR: QP
/// DATE: 2016-08-7
/// VERN: V4.1.4
/// DESC: 医生站主界面方法类
Class DHCAnt.KSS.MainInterface Extends (DHCDoc.Util.RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2016-08-14
/// DESC: 使用目的
/// IN  : 
/// OUT : id,text
/// EXEC: d ##Class(%ResultSet).RunQuery("DHCAnt.KSS.MainInterface","QryUseAim")
Query QryUseAim() As %Query(ROWSPEC = "id:%String,text:%String")
{
}

ClassMethod QryUseAimExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1 
    Set qHandle=$lb(0,repid,0)
    k ^DHCANTDATA("TEMP",$j)
    s langid=..%LanguageID()
    s DTAUPId=""
    f  s DTAUPId=$o(^DHCAntBasePurposeDataConfigI("PDCType","AIM",DTAUPId)) q:DTAUPId=""  d
    .s ActiveFlag=$p(^DHCAntBasePurposeDataConfigD(DTAUPId),"^",5)
    .q:ActiveFlag'=1
    .s DTAUPCode=$p(^DHCAntBasePurposeDataConfigD(DTAUPId),"^",4)
    .s seqno=$p(^DHCAntBasePurposeDataConfigD(DTAUPId),"^",8)
    .i seqno="" s seqno="999"
    .s DTAUPDesc=$p(^DHCAntBasePurposeDataConfigD(DTAUPId),"^",3)
    .s DTAUPDesc= ##class(DHCAnt.Base.PurposeDataConfig).GetTranByDesc("PDCValue",DTAUPDesc,langid)
    .s ^DHCANTDATA("TEMP",$j,seqno,DTAUPId)=DTAUPId_$C(1)_DTAUPDesc
    
    s seqno=""
    f  s seqno=$o(^DHCANTDATA("TEMP",$j,seqno)) q:seqno=""  d
    .s DTAUPId=""
    .f  s DTAUPId=$o(^DHCANTDATA("TEMP",$j,seqno,DTAUPId)) q:DTAUPId=""  d
    ..s DTAUPId=$p(^DHCANTDATA("TEMP",$j,seqno,DTAUPId),$C(1),1)
    ..s DTAUPDesc=$p(^DHCANTDATA("TEMP",$j,seqno,DTAUPId),$C(1),2)
    ..s DTAUPDesc= ##class(DHCAnt.Base.PurposeDataConfig).GetTranByDesc("PDCValue",DTAUPDesc,langid)
    ..d OutputRow1
    
    k ^DHCANTDATA("TEMP",$j)
    
    Quit $$$OK
OutputRow1
    set Data=$lb(DTAUPId,DTAUPDesc)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1   
    quit
}

ClassMethod QryUseAimClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryUseAimExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QryUseAimFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryUseAimExecute ]
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

/// CTOR: QP
/// DATE: 2016-08-14
/// DESC: 指征
/// IN  : 
/// OUT : id,text
/// EXEC: d ##Class(%ResultSet).RunQuery("DHCAnt.KSS.MainInterface","QryUseDrugIndication",2)
Query QryUseDrugIndication(dtaupId As %String) As %Query(ROWSPEC = "id:%String,text:%String")
{
}

ClassMethod QryUseDrugIndicationExecute(ByRef qHandle As %Binary, dtaupId As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    Set qHandle=$lb(0,repid,0)
    ;q:($g(dtaupId)="") $$$OK
    s langid=..%LanguageID()
    i dtaupId'="" d
    .s AURRowid=$p(^DHCAntBasePurposeDataConfigD(dtaupId),"^",6)
    .s DAINDId=""
    .f  s DAINDId=$o(^DHCAntBasePurposeDataConfigI("PDCParentOBJTYPE",AURRowid,"IND",DAINDId)) q:DAINDId=""  d
    ..s ActiveFlag=$p(^DHCAntBasePurposeDataConfigD(DAINDId),"^",5)
    ..q:ActiveFlag'=1
    ..s specialFlag=$p(^DHCAntBasePurposeDataConfigD(DAINDId),"^",8)
    ..q:specialFlag=1
    ..s DAINDDesc=$p(^DHCAntBasePurposeDataConfigD(DAINDId),"^",3)
    ..s DAINDDesc= ##class(DHCAnt.Base.PurposeDataConfig).GetTranByDesc("PDCValue",DAINDDesc,langid)
    ..s DAINDCode=$p(^DHCAntBasePurposeDataConfigD(DAINDId),"^",4)
    ..d OutputRow2
    
    e  d
    .s DAINDId=""
    .f  s DAINDId=$o(^DHCAntBasePurposeDataConfigI("PDCType","IND",DAINDId)) q:DAINDId=""  d
    ..s ActiveFlag=$p(^DHCAntBasePurposeDataConfigD(DAINDId),"^",5)
    ..q:ActiveFlag'=1
    ..s specialFlag=$p(^DHCAntBasePurposeDataConfigD(DAINDId),"^",8)
    ..q:specialFlag=1
    ..s DAINDCode=$p(^DHCAntBasePurposeDataConfigD(DAINDId),"^",4)
    ..s DAINDDesc=$p(^DHCAntBasePurposeDataConfigD(DAINDId),"^",3)
    ..s DAINDDesc= ##class(DHCAnt.Base.PurposeDataConfig).GetTranByDesc("PDCValue",DAINDDesc,langid)
    ..d OutputRow2
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow2
    set Data=$lb(DAINDId,DAINDDesc)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1   
    quit
}

ClassMethod QryUseDrugIndicationClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryUseDrugIndicationExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QryUseDrugIndicationFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryUseDrugIndicationExecute ]
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

/// CTOR: QP
/// DATE: 2016-08-14
/// DESC: 特抗药指征
/// IN  : 
/// OUT : id,text
/// EXEC: d ##Class(%ResultSet).RunQuery("DHCAnt.KSS.MainInterface","QryKSS3Indication")
Query QryKSS3Indication() As %Query(ROWSPEC = "id:%String,text:%String")
{
}

ClassMethod QryKSS3IndicationExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1 
    Set qHandle=$lb(0,repid,0)
    s langid=..%LanguageID()
    s DTAUPId=""
    f  s DTAUPId=$o(^DHCAntBasePurposeDataConfigI("PDCType","IND",DTAUPId)) q:DTAUPId=""  d
    .s ActiveFlag=$p(^DHCAntBasePurposeDataConfigD(DTAUPId),"^",5)
    .q:ActiveFlag'=1
    .s speFlag=$p(^DHCAntBasePurposeDataConfigD(DTAUPId),"^",8)
    .q:(speFlag'=1)
    .s DTAUPCode=$p(^DHCAntBasePurposeDataConfigD(DTAUPId),"^",4)
    .s DTAUPDesc=$p(^DHCAntBasePurposeDataConfigD(DTAUPId),"^",3)
    .s DTAUPDesc= ##class(DHCAnt.Base.PurposeDataConfig).GetTranByDesc("PDCValue",DTAUPDesc,langid)
    .d OutputRow10
    
    Quit $$$OK
OutputRow10
    set Data=$lb(DTAUPId,DTAUPDesc)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1   
    quit
}

ClassMethod QryKSS3IndicationClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryKSS3IndicationExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QryKSS3IndicationFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryKSS3IndicationExecute ]
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

/// CTOR: QP
/// DATE: 2016-08-14
/// DESC: 感染部位
/// IN  : 
/// OUT : id,text
/// EXEC: d ##Class(%ResultSet).RunQuery("DHCAnt.KSS.MainInterface","QryInfectionSite")
Query QryInfectionSite() As %Query(ROWSPEC = "id:%String,text:%String")
{
}

ClassMethod QryInfectionSiteExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    Set qHandle=$lb(0,repid,0)
    s langid=..%LanguageID()
    s INFSId=""
    f  s INFSId=$o(^DHCAntBasePurposeDataConfigI("PDCType","SITE",INFSId)) q:INFSId=""  d
    .s ActiveFlag=$p(^DHCAntBasePurposeDataConfigD(INFSId),"^",5)
    .q:ActiveFlag'=1
    .s INFSCode=$p(^DHCAntBasePurposeDataConfigD(INFSId),"^",4)
    .s INFSDesc=$p(^DHCAntBasePurposeDataConfigD(INFSId),"^",3)
    .s INFSDesc= ##class(DHCAnt.Base.PurposeDataConfig).GetTranByDesc("PDCValue",INFSDesc,langid)
    .d OutputRow3
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow3
    set Data=$lb(INFSId,INFSDesc)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1   
    quit
}

ClassMethod QryInfectionSiteClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfectionSiteExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QryInfectionSiteFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfectionSiteExecute ]
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

/// CTOR: QP
/// DATE: 2016-08-14
/// DESC: 预防用药时机
/// IN  : 
/// OUT : id,text
/// EXEC: d ##Class(%ResultSet).RunQuery("DHCAnt.KSS.MainInterface","QryUseDrugTime")
Query QryUseDrugTime() As %Query(ROWSPEC = "id:%String,text:%String")
{
}

ClassMethod QryUseDrugTimeExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    Set qHandle=$lb(0,repid,0)
    s langid=..%LanguageID()
    s UDTId=""
    f  s UDTId=$o(^DHCAntBasePurposeDataConfigI("PDCType","TIME",UDTId)) q:UDTId=""  d
    .s ActiveFlag=$p(^DHCAntBasePurposeDataConfigD(UDTId),"^",5)
    .q:ActiveFlag'=1
    .s UDTCode=$p(^DHCAntBasePurposeDataConfigD(UDTId),"^",4)
    .s UDTDesc=$p(^DHCAntBasePurposeDataConfigD(UDTId),"^",3)
    .s UDTDesc= ##class(DHCAnt.Base.PurposeDataConfig).GetTranByDesc("PDCValue",UDTDesc,langid)
    .d OutputRow4
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow4
    set Data=$lb(UDTId,UDTDesc)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1   
    quit
}

ClassMethod QryUseDrugTimeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryUseDrugTimeExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QryUseDrugTimeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryUseDrugTimeExecute ]
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

/// CTOR: QP
/// DATE: 2016-08-14
/// DESC: 会诊科室
/// IN  : 
/// OUT : id,text
/// EXEC: d ##Class(%ResultSet).RunQuery("DHCAnt.KSS.MainInterface","QryConsultationLoc",16)
Query QryConsultationLoc(selfId As %String = "", InHosp = "") As %Query(ROWSPEC = "id:%String,text:%String,code:%String")
{
}

ClassMethod QryConsultationLocExecute(ByRef qHandle As %Binary, selfId As %String = "", InHosp = "") As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    Set qHandle=$lb(0,repid,0)
    i InHosp="" s InHosp=%session.Get("LOGON.HOSPID")
    s langid=..%LanguageID()
    s curSelfCfg=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("NOSELFCONLOC",InHosp)
    s ConLocId=""
    f  s ConLocId=$o(^DHCAntBasePurposeDataConfigI("PDCType","CONLOC",ConLocId)) q:ConLocId=""  d
    .s ActiveFlag=$p(^DHCAntBasePurposeDataConfigD(ConLocId),"^",5)
    .s hospDr=$p(^DHCAntBasePurposeDataConfigD(ConLocId),"^",11)
    .q:hospDr=""
    .q:ActiveFlag'=1
    .s CTLOCRowid=$p(^DHCAntBasePurposeDataConfigD(ConLocId),"^",3)
    .q:(curSelfCfg=1)&&(selfId=CTLOCRowid)
    .s CTLocDesc=$P(^CTLOC(CTLOCRowid),"^",2)
    .s CTLocDesc= ##class(User.CTLoc).GetTranByDesc("CTLOCDesc",CTLocDesc,langid)
    .s code=$p(^CTLOC(CTLOCRowid),"^",43)
    .q:(InHosp'="")&&(InHosp'=hospDr)
    .;s CTLocDesc=$p(^DHCAntBasePurposeDataConfigD(ConLocId),"^",4)
    .d OutputRow5
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow5
    set Data=$lb(CTLOCRowid,CTLocDesc,code)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1   
    quit
}

ClassMethod QryConsultationLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryConsultationLocExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QryConsultationLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryConsultationLocExecute ]
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

/// CTOR: QP
/// DATE: 2016-08-14
/// DESC: 会诊医生
/// IN  : 
/// OUT : id,text
/// EXEC: d ##Class(%ResultSet).RunQuery("DHCAnt.KSS.MainInterface","QryConsultationDoc",56)
Query QryConsultationDoc(ctLocId As %String) As %Query(ROWSPEC = "id:%String,text:%String")
{
}

ClassMethod QryConsultationDocExecute(ByRef qHandle As %Binary, ctLocId As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    Set qHandle=$lb(0,repid,0)
    q:$g(ctLocId)="" $$$OK
    s langid=..%LanguageID()
    s ConDocId=""
    f  s ConDocId=$o(^DHCAntBasePurposeDataConfigI("PDCParentOBJTYPE",ctLocId,"CONDOC",ConDocId)) q:ConDocId=""  d
    .s ActiveFlag=$p(^DHCAntBasePurposeDataConfigD(ConDocId),"^",5)
    .q:ActiveFlag'=1
    .s CTPCPId=$p(^DHCAntBasePurposeDataConfigD(ConDocId),"^",3)
    .s CTPCPDesc=$p(^CTPCP(CTPCPId,1),"^",2)
    .s CTPCPDesc= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",CTPCPDesc,langid)
    .d OutputRow6
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow6
    set Data=$lb(CTPCPId,CTPCPDesc)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1   
    quit
}

ClassMethod QryConsultationDocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryConsultationDocExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QryConsultationDocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryConsultationDocExecute ]
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

/// CTOR: QP
/// DATE: 2016-08-14
/// DESC: 药敏结果
/// OUT :   rowid   序号     报告日期    样本号                   编码  细菌名[中文]     耐药机制    细菌名英文名   抗生素名  备注  whonet     检验项目   标本     送检日期
///         Rowid   SeqNo   ReportDate   SampleNo  SpecResource   code  BacterialNameC  Resistance  BacterialNameE  AntName   Note  whonet      TSName   SPName    RecDate
/// EXEC: d ##Class(%ResultSet).RunQuery("DHCAnt.KSS.MainInterface","QrySensitiveList",6)
Query QrySensitiveList(admId As %String, aaid = "") As %Query(ROWSPEC = "id:%String,SeqNo:%String,ReportDate:%String,SampleNo:%String,SpecResource:%String,code:%String,BacterialNameC:%String,Resistance:%String,BacterialNameE:%String,AntName:%String,Note:%String,whoNet:%String,TSName:%String,SPName:%String,RecDate:%String,Selected")
{
}

ClassMethod QrySensitiveListExecute(ByRef qHandle As %Binary, admId As %String, aaid = "") As %Status
{
   
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	s IDS=""
	i aaid'="" {
		s IDS=##class(DHCAnt.KSS.Extend.ModePrj).GetDaupJson(aaid,.TList)
		s IDS=TList("ym")
	}
	q:$g(admId)="" $$$OK
	
	s PatientID=$P(^PAADM(admId),"^",1)
	s AdmType=""
	for {
		s AdmType=$o(^PAPERdr(PatientID,"ADM",AdmType))
		q:AdmType=""
		continue:"IOE"'[AdmType
		s cid=""
		for {
			s cid=$o(^PAPERdr(PatientID,"ADM",AdmType,cid))
			q:cid=""
			Set SusceptStr=##class(web.DHCLabGerm).GetAllSenResbyEpisID(cid)
			continue:SusceptStr=""
			Set len=$l(SusceptStr,"!")
			for i=1:1:len {
				Set Suscept=$p(SusceptStr,"!",i)
				continue:Suscept=""                     ;2012-1-14
				Set Rowid=$p(Suscept,"^",1)
				Set SeqNo=$p(Suscept,"^",2)
				Set ReportDate=$p(Suscept,"^",3)
				Set ReportDate=##class(DHCAnt.KSS.Common.Method).ComStrToDate(ReportDate)
				set ReportDate=##class(DHCAnt.KSS.Common.Method).DateLogicalToHtml(ReportDate)
				Set SampleNo=$p(Suscept,"^",4)
				Set SpecResource=$p(Suscept,"^",5)
				Set code=$p(Suscept,"^",6)
				Set BacterialNameC=$p(Suscept,"^",7)
				Set Resistance=$p(Suscept,"^",8)
				continue:(Resistance'["耐药")&&(Resistance'["敏感")&&(Resistance'["药敏")
				Set BacterialNameE=$p(Suscept,"^",9)
				Set AntName=$p(Suscept,"^",10)
				Set Note=$p(Suscept,"^",11)
				set whoNet=$p(Suscept,"^",12)  ;
				set TSName=$p(Suscept,"^",13)     ;检验项目
				set SPName=$p(Suscept,"^",14)      ;标本
				set RecDate=$p(Suscept,"^",15)     ;送检日期
				set RecDate=##class(DHCAnt.KSS.Common.Method).ComStrToDate(RecDate)
				set RecDate=##class(DHCAnt.KSS.Common.Method).DateLogicalToHtml(RecDate)
				set Selected=0
				if IDS'="" {
					if ##class(DHCAnt.KSS.Common.Method).InArray(IDS,Rowid)=1 s Selected=1
				}
				Do OutwardRow7
			}
		}
	}
	
    Quit $$$OK
OutwardRow7
    set Data=$lb(Rowid,SeqNo,ReportDate,SampleNo,SpecResource,code,BacterialNameC,Resistance,BacterialNameE,AntName,Note,whoNet,TSName,SPName,RecDate,Selected)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod QrySensitiveListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySensitiveListExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QrySensitiveListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySensitiveListExecute ]
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

/// CTOR: QP
/// DATE: 2016-08-14
/// DESC: 手术申请记录
/// IN  : EpisodeID - PA_Adm(表id)
/// OUT : opaId - 手术申请表id，opName - 手术名称，StartDateStr - 手术开始时间，EndDateStr - 手术结束时间，operLocDesc - 手术室
/// EXEC: d ##Class(%ResultSet).RunQuery("DHCAnt.KSS.MainInterface","QryOperationList",75)
Query QryOperationList(EpisodeID As %String, aaid = "") As %Query(ROWSPEC = "id,OpName,StartDateStr,EndDateStr,OperLocDesc,operCut,OPAStatus,Selected")
{
}

ClassMethod QryOperationListExecute(ByRef qHandle As %Binary, EpisodeID As %String, aaid = "") As %Status
{
     
    Set repid=$I(^CacheTemp)
 	s ind=1
 	Set qHandle=$lb(0,repid,0)
 	/*
 	f i=1:1:10 d
 	.s (opaId,opName,StartDateStr,EndDateStr,operLocDesc,operCut)=i
 	.Do OutwardRow8
	Quit $$$OK
	*/
	s IDS=""
    i aaid'="" {
		s IDS=##class(DHCAnt.KSS.Extend.ModePrj).GetDaupJson(aaid,.TList)
		s IDS=TList("oper")
    }
   	q:$g(EpisodeID)="" $$$OK
 	s opaId=0
 	//Set EpisodeID=594
 	s langid=..%LanguageID()
 	Set opaAdmDr=EpisodeID
	f  s opaId=$O(^DHCANOPArrange(0,"Adm",EpisodeID,opaId)) q:opaId=""  d
	.s anaId=$P(^DHCANOPArrange(opaId),"^",2) ;手术麻醉Id
	.s OPAStatus=$P(^DHCANOPArrange(opaId),"^",27)
	.q:((OPAStatus="D")||(OPAStatus="C"))
	.S OPAStatus=##class(DHCAnt.KSS.Common.Func).GetOPStatus(OPAStatus)
	.s OPAStatus= ##class(DHCAnt.Base.PurposeDataConfig).GetTranByDesc("PDCValue",OPAStatus,langid)
	.s anaSub=$P(anaId,"||",2)
	.s anaopSub=0 
	.Set opName="",operCut=""  //手术名称
	.Set operLocId=""
	.f  s anaopSub=$O(^OR(opaAdmDr,"ANA",anaSub,"OP",anaopSub)) q:(anaopSub="")  d  
	..s curOperId=$P(^OR(opaAdmDr,"ANA",anaSub,"OP",anaopSub),"^",6)       ;ANAOP_Type_DR；手术名称
	..q:curOperId=""
	..s operCutId=$P($g(^OR(opaAdmDr,"ANA",anaSub,"OP",anaopSub)),"^",9)
	..i operCutId'="" d
	...s tmpCut=$p($g(^ORC("BLDTP",operCutId)),"^",2)
	...s tmpCut= ##class(User.ORCBladeType).GetTranByDesc("BLDTPDesc",tmpCut,langid)
	...i operCut="" s operCut=tmpCut
	...e  s operCut=$G(operCut)_","_tmpCut
	
	..if $D(^ORC("OPER",curOperId)) d
	...s tmpName=$P(^ORC("OPER",curOperId),"^",2)
	...s tmpName=##class(User.ORCOperation).GetTranByDesc("OPERDesc",tmpName,langid)
	...i opName="" s opName=tmpName
	...e  s opName=$G(opName)_","_tmpName
	..s operLocId1=$P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",10) 
	..if operLocId1'=""  Set operLocId=operLocId1 
	.s opStartDate=$P(^OR(opaAdmDr,"ANA",anaSub),"^",39)
	.s opsttime=$P(^OR(opaAdmDr,"ANA",anaSub),"^",40)
	.i opStartDate="" s opStartDate=$P(^DHCANOPArrange(opaId),"^",14),opsttime=$P(^DHCANOPArrange(opaId),"^",15) ;手术开始日期
	.i opStartDate'="" s opStartDate=##class(DHCAnt.KSS.Common.Method).DateLogicalToHtml(opStartDate)	//$ZD(opStartDate,3)
	.i opsttime'=""  s opsttime=$ZT(opsttime,2)
	.s openddate=$P(^OR(opaAdmDr,"ANA",anaSub),"^",41)
	.s opendtime=$P(^OR(opaAdmDr,"ANA",anaSub),"^",42)
	.i openddate="" s openddate=$P(^DHCANOPArrange(opaId),"^",16),opendtime=$P(^DHCANOPArrange(opaId),"^",17)
	.i openddate'="" s openddate=##class(DHCAnt.KSS.Common.Method).DateLogicalToHtml(openddate)	//$zd(openddate,3)	
	.i opendtime'="" s opendtime=$zt(opendtime,2)
	.Set StartDateStr=opStartDate_" "_opsttime
	.Set EndDateStr=openddate_" "_opendtime
	.Set operLocDesc=""
	.if operLocId'="" do
	..Set operLocDesc=$p(^CTLOC(operLocId),"^",2)  //手术科室
	.set Selected=0
	.if IDS'="" d
	..if ##class(DHCAnt.KSS.Common.Method).InArray(IDS,opaId)=1 s Selected=1
   	.Do OutwardRow8
   	/*
   	f i=1:1:10 d
   	.s (opaId,opName,StartDateStr,EndDateStr,operLocDesc,operCut)=i
   	.d OutwardRow8*/
	Quit $$$OK
	
OutwardRow8
	set Data=$lb(opaId,opName,StartDateStr,EndDateStr,operLocDesc,operCut,OPAStatus,Selected)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QryOperationListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOperationListExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QryOperationListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOperationListExecute ]
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

/// CTOR: QP
/// DATE: 2016-08-14
/// DESC: 致病菌
/// IN  : 
/// OUT : id,text
/// EXEC: d ##Class(%ResultSet).RunQuery("DHCAnt.KSS.MainInterface","QryZBacterium")
Query QryZBacterium() As %Query(ROWSPEC = "id,text")
{
}

ClassMethod QryZBacteriumExecute(ByRef qHandle As %Binary) As %Status
{
     
   	Set repid=$I(^CacheTemp)
 	s ind=1
 	Set qHandle=$lb(0,repid,0)
 	s langid=..%LanguageID()
 	s INFSId=""
    f  s INFSId=$o(^DHCAntBasePurposeDataConfigI("PDCType","ZBJ",INFSId)) q:INFSId=""  d
    .s ActiveFlag=$p(^DHCAntBasePurposeDataConfigD(INFSId),"^",5)
    .q:ActiveFlag'=1
    .s INFSCode=$p(^DHCAntBasePurposeDataConfigD(INFSId),"^",4)
    .s INFSDesc=$p(^DHCAntBasePurposeDataConfigD(INFSId),"^",3)
    .s INFSDesc= ##class(DHCAnt.Base.PurposeDataConfig).GetTranByDesc("PDCValue",INFSDesc,langid)
    .d OutputRow9
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow9
    set Data=$lb(INFSId,INFSDesc)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1   
    quit
}

ClassMethod QryZBacteriumClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryZBacteriumExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QryZBacteriumFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryZBacteriumExecute ]
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

/// CTOR:  QP
/// DATE: 2016-08-11
/// DESC:  得到药品信息
/// input: 就诊id、医嘱项id
/// TABLE: 剂型表：PHC_FORM,PHC_DrgFormExt 药学项的附加表 phcdf_whoddd,phcdf_whoddduom_dr-->ct_uom
/// output: myrtn:医嘱项描述、剂型描述、DDD
/// w ##class(DHCAnt.KSS.MainInterface).GetDrugDetail("883||1")
ClassMethod GetDrugDetail(arcimRowid As %String) As %String
{
	n (arcimRowid,%session)
	Q:arcimRowid="" ""
	s langid=##class(DHCAnt.KSS.Common.Method).%LanguageID()
	s mRtn="",drugDesc="",drugForm="",drugDDD="",phoDesc=""
	s KSSID=##class(DHCAnt.KSS.Common.Method).GetKssPoisonId(arcimRowid)
	s phoDesc=$p(^PHCPO(KSSID),"^",2)
	s phoDesc= ##class(User.PHCPoison).GetTranByDesc("PHCPODesc",phoDesc,langid)
	s drugDesc=$p(^ARCIM(+arcimRowid,1,1),"^",2)
	s drugDesc= ##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",drugDesc,langid)
	s phcdf=$p($g(^ARCIM(+arcimRowid,1,1)),"^",12)
	s PHCFiD=$p($g(^PHCD(+phcdf,"DF",$p(phcdf,"||",2),1)),"^",1) ;PHCDF_PHCF_DR指向PHC_FORM
	i PHCFiD'="" {
		s drugForm=$p(^PHCF(PHCFiD),"^",2)
		s drugForm= ##class(User.PHCForm).GetTranByDesc("PHCFDesc",drugForm,langid)
	}
	s drugDDD=$P(^PHCD(+phcdf,"DF",$p(phcdf,"||",2),"DHC"),"^",11)	//WHODDD
	s dddUom=$P(^PHCD(+phcdf,"DF",$p(phcdf,"||",2),"DHC"),"^",12)	//
	i dddUom'="" {
		s dddUomDesc=$p(^CT("UOM",dddUom),"^",2)
		s dddUomDesc= ##class(User.CTUOM).GetTranByDesc("CTUOMDesc",dddUomDesc,langid)
		s drugDDD=drugDDD_" "_dddUomDesc
	}
	s mRtn="{""drugDesc"":"""_drugDesc_""",""phoDesc"":"""_phoDesc_""",""drugForm"":"""_drugForm_""",""drugDDD"":"""_drugDDD_"""}"
	Q mRtn
}

/// CTOR:  QP
/// DATE:  2016-08-11
/// DESC:  得到医生信息
/// input: 
/// TABLE: 
/// output: docName:医生姓名,ctCarPrvTpDesc:医生职称
/// exec: w ##class(DHCAnt.KSS.MainInterface).GetDocDetail("12262")
ClassMethod GetDocDetail(ssid As %String) As %String
{
	n (ssid,%session)
	s langid=##class(DHCAnt.KSS.Common.Method).%LanguageID()
	s mRtn="",ctCarPrvTpDesc=""
	s docName=$p(^SSU("SSUSR",ssid),"^",2)	//
	s ctCareProvId=$p(^SSU("SSUSR",ssid),"^",14)	//CTCareProv
	s ctCarPrvTpId=$p(^CTPCP(ctCareProvId,1),"^",4)	//CTCarPrvTp
	s ctCarPrvTpDesc=$p(^CT("CPT",ctCarPrvTpId),"^",2)
	s docName= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",docName,langid)
	s ctCarPrvTpDesc= ##class(User.CTCarPrvTp).GetTranByDesc("CTCPTDesc",ctCarPrvTpDesc,langid)
	s mRtn="{""docName"":"""_docName_""",""ctCarPrvTpDesc"":"""_ctCarPrvTpDesc_"""}"
	Q mRtn
}

/// CTOR: QP
/// DATE: 2016-08-06
/// DESC: INIT DHCANT CONFIG
/// 
/// EXEC: d ##class(DHCAnt.KSS.MainInterface).InitSettings(9)
ClassMethod InitSettings() As %String
{
	//统一去读写配置
	//目前只有6个：多科会诊个数、是否启用特殊抗菌药物指征、是否启用致病菌、是否启用预防用药时间控制||是否启用治疗用药时间控制
	//DEFAULTCONDEP：如果为1,则不需要显示会诊科室
	//CONDEPNUM、SKSS3IND、SBJ、SYFDRUGTIME、SZLDRUGTIME、DEFAULTCONDEP
	s HOSPID=%session.Get("LOGON.HOSPID")
	s ^TEMP("dd")=HOSPID
	//读取流程配置：A-F
	w $$$cspStrictJavaScriptStart,!
	w "var KSSConfig={};",!
	
	//读取所有的有效配置
	s mcgCode="",mcgLen=0,mRtn=""
	f  s mcgCode=$o(^DHCAntBaseMainConfigI("MCGCode",mcgCode)) q:mcgCode=""  d
	.s mcgId=""
	.f  s mcgId=$o(^DHCAntBaseMainConfigI("MCGCode",mcgCode,mcgId)) q:mcgId=""  d
	..;s mcgId=$o(^DHCAntBaseMainConfigI("MCGCode",mcgCode,mcgId))
	..q:'$d(^DHCAntBaseMainConfigD(mcgId))
	..s mcgActive=$p(^DHCAntBaseMainConfigD(mcgId),"^",5)
	..s mcgHosp=$p(^DHCAntBaseMainConfigD(mcgId),"^",14)
	..q:mcgHosp'=HOSPID
	..q:mcgActive'=1
	..s mcgLen=mcgLen+1
	..s mcgValue=$p(^DHCAntBaseMainConfigD(mcgId),"^",9)
	..i mcgValue="" s mcgValue=0
	..w "KSSConfig."_mcgCode_" = " _""""_mcgValue_""";",!
	..s mcgLen=mcgLen+1
	w $$$cspJavaScriptEnd
	q ""
}

/// CTOR: QP
/// DATE: 2016-08-14
/// DESC: 抗菌药物申请列表
/// IN  : 
/// OUT : 
/// EXEC: d ##Class(%ResultSet).RunQuery("DHCAnt.KSS.MainInterface","QryAntApplyInfo","470","12175","9")
Query QryAntApplyInfo(EpisodeId As %String, UserId As %String, InHosp = "") As %Query(ROWSPEC = "id:%String,ArcimName:%String,ArcimId:%String,AppUserName:%String,AppDT:%String,AppStatus:%String,AppStatusDesc:%String,AuditUserName:%String,AuditDT:%String,ProcessInfo:%String,ConsultDoc1:%String,ConsultDT1:%String,ConsultDoc2:%String,ConsultDT2:%String,ConsultDoc3:%String,ConsultDT3:%String,checkboxok:%String,EmergencyDesc:%String,cOeori:%String")
{
}

ClassMethod QryAntApplyInfoExecute(ByRef qHandle As %Binary, EpisodeId As %String, UserId As %String, InHosp = "") As %Status
{
    //n (qHandle,EpisodeId,UserId,InHosp)
    s ^TEMP("QP",1)=$lb(EpisodeId,UserId,InHosp)
    s langid=..%LanguageID()
    Set repid=$I(^CacheTemp)
 	s ind=1
 	Set qHandle=$lb(0,repid,0)
 	
 	q:($g(EpisodeId)="")||(InHosp="") $$$OK
 	
 	s AARowid="",seqno=0
	f  s AARowid=$o(^DHCDAAi("AdmDR",EpisodeId,AARowid),-1)  q:AARowid=""  d
	.s AppUserDr=$p(^DHCDAA("ANT",AARowid),"^",9)
	.s APPONESELF=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("APPONESELF",InHosp)
	.q:(APPONESELF=1)&&(AppUserDr'=UserId)
	.s ArcimId=$p(^DHCDAA("ANT",AARowid),"^",2)
	.s ArcimName=$p(^ARCIM(+ArcimId,$p(ArcimId,"||",2),1),"^",2)  //医嘱名称
	.s ArcimName= ##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",ArcimName,langid)
	.s AppUserName=$p(^SSU("SSUSR",AppUserDr),"^",2) //申请医生
	.s AppUserName= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",AppUserName,langid)
	.s AppDate=$p(^DHCDAA("ANT",AARowid),"^",10)
	.s AppTime=$p(^DHCDAA("ANT",AARowid),"^",11)
	.s AppDT=##class(DHCAnt.KSS.Common.Method).DateLogicalToHtml(AppDate)_" "_$zt(AppTime,2) //申请时间		//$zd(AppDate,3)_" "_$zt(AppTime,2) //申请时间
	.s IsEmergency=$p(^DHCDAA("ANT",AARowid,1),"^",23)
	.s cOeori=$p(^DHCDAA("ANT",AARowid,1),"^",6) 
	.q:(cOeori="")&&(IsEmergency=1)
	.s oeoriStatus="",oeoriStatusDr=""
	.i cOeori'="" s oeoriStatusDr=$p(^OEORD(+cOeori,"I",$p(cOeori,"||",2),1),"^",13)	//OEC_OrderStatus
	.i oeoriStatusDr'="" s oeoriStatus=$p(^OEC("OSTAT",oeoriStatusDr),"^",1)
	.q:(oeoriStatus="U")&&(IsEmergency=1)	;医嘱状态为撤销
	.i IsEmergency=1 s EmergencyDesc="是"
	.e  s EmergencyDesc="否"   //越级情况
	.s EmergencyDesc=##class(websys.Translation).Get("oeorder.oplistcustom.new.csp",EmergencyDesc)
	.s currentAuditInfo=##class(DHCAnt.KSS.Common.Method).GetCurrentAuditInfo(AARowid)
	.s AuditUserName="",AuditDT="",ConsultDoc1="",ConsultDoc2="",ConsultDoc3="",ConsultDT1="",ConsultDT2="",ConsultDT3=""
	.s checkboxok=0
	.s ProcessCode=$p(^DHCDAA("ANT",AARowid,1),"^",33)
	.s ProcessCode="KSS3APPNOA"
	.s ProcessInfo=$p(^DHCDAA("ANT",AARowid,1),"^",36)
	.;s EndProcessCode=$p(ProcessInfo,"^",-1) //流程最后一个状态Code
	.
	.s AppStatus=$p(^DHCDAA("ANT",AARowid),"^",12)
	.q:AppStatus="C"	//过滤撤销
	.s AppStatusDesc=##class(DHCAnt.Base.MainConfigExcute).GetOSDesc("PSTATUS"_AppStatus)
	.s AppStatusDesc= ##class(DHCAnt.Base.PurposeDataConfig).GetTranByDesc("PDCValue",AppStatusDesc,langid)
	.s AuditUserId=$p(^DHCDAA("ANT",AARowid,1),"^",10)     //审核人
	.i AuditUserId'="" s AuditUserName=$p(^SSU("SSUSR",AuditUserId),"^",2)
	.s AuditDate=$p(^DHCDAA("ANT",AARowid,1),"^",11)       //审核日期
	.s AuditTime=$p(^DHCDAA("ANT",AARowid,1),"^",12)       //时间
	.i AuditDate'="" s AuditD=##class(DHCAnt.KSS.Common.Method).DateLogicalToHtml(AuditDate)	//$zd(AuditDate,3)
	.i AuditTime'="" s AuditT=$zt(AuditTime,2)
	.i AuditDate'="" s AuditDT=AuditD_" "_AuditT  //审核时间
	.i AuditUserName="" d
	..s curAuditStatus=$p(currentAuditInfo,"^",4)
	..q:curAuditStatus="A"
	..s curAuditUser=$p(currentAuditInfo,"^",1),curAuditDate=$p(currentAuditInfo,"^",2)
	..s curAuditTime=$zt($p(currentAuditInfo,"^",3),2)
	..s curAuditDate=##class(DHCAnt.KSS.Common.Method).DateLogicalToHtml(curAuditDate)
	..s AuditUserName=$p(^SSU("SSUSR",curAuditUser),"^",2)
	..s AuditDT=curAuditDate_" "_curAuditTime
	.i AppStatus="U" d
	..s AuditFinisDT=##class(DHCAnt.KSS.Common.Method).GetAbsTime(AuditDate_","_AuditTime)
	..s CurDT=##class(DHCAnt.KSS.Common.Method).GetAbsTime($h) 
	..s EmAgain=0
	..s LimTime=##class(DHCAnt.Base.MainConfigExcute).GetOSValueByCode("APPTIME")
	..s EmAgain=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("EMAGAIN",InHosp)	//是否控制越级也不让开：0 - 不让，1 - 让
	..i ((CurDT-AuditFinisDT) < (LimTime*3600))&&(IsEmergency'=1) s checkboxok=1 //checkboxok 为1时代表在 APPTIME内
	..i ((CurDT-AuditFinisDT) < (LimTime*3600))&&(IsEmergency=1)&&(EmAgain=1) s checkboxok=1
	.s ConsultDoc1=$p($g(^DHCDAA("ANT",AARowid,1)),"^",5)
	.s ConsultDoc2=$p($g(^DHCDAA("ANT",AARowid,1)),"^",28)
	.s ConsultDoc3=$p($g(^DHCDAA("ANT",AARowid,1)),"^",31)
	.i ConsultDoc1'="" s ConsultDoc1=$p(^CTPCP(ConsultDoc1,1),"^",2)
	.i ConsultDoc2'="" s ConsultDoc2=$p(^CTPCP(ConsultDoc2,1),"^",2)
	.i ConsultDoc3'="" s ConsultDoc3=$p(^CTPCP(ConsultDoc3,1),"^",2)
	.s ConsultDoc1= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",ConsultDoc1,langid)
	.s ConsultDoc2= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",ConsultDoc2,langid)
	.s ConsultDoc3= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",ConsultDoc3,langid)
	
	.//会诊医生1
	.s ConsultDR1=$p(^DHCDAA("ANT",AARowid,1),"^",22)
	.s (ConsultD1,ConsultD2,ConsultD3,ConsultT1,ConsultT2,ConsultT3)=""
	.i ConsultDR1'="" d
	..s conInfo=##Class(web.DHCEMConsInterface).GetAntiConsultInfo(ConsultDR1)
	..s ConsultDocDr1=$p(conInfo,"^",2)
	..i ConsultDocDr1'="" d
	...s ConsultDoc1=$p(^SSU("SSUSR",ConsultDocDr1),"^",2)		//$P(^CTPCP(ConsultDocDr1,1),"^",2) //会诊医生1
	...s ConsultDoc1= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",ConsultDoc1,langid)
	..s ConsultDate1=$p(conInfo,"^",4)
	..s ConsultTime1=$p(conInfo,"^",5)
	..i ConsultDate1'="" s ConsultD1=##class(DHCAnt.KSS.Common.Method).DateLogicalToHtml(ConsultDate1)	//$zd(ConsultDate1,3)
	..i ConsultTime1'="" s ConsultT1=$zt(ConsultTime1,2)
	..s ConsultDT1=ConsultD1_" "_ConsultT1
	
	.//会诊医生2
	.s ConsultDR2=$p(^DHCDAA("ANT",AARowid,1),"^",26)
	.i ConsultDR2'="" d
	..s conInfo=##Class(web.DHCEMConsInterface).GetAntiConsultInfo(ConsultDR2)
	..s ConsultDocDr2=$p(conInfo,"^",2)
	..i ConsultDocDr2'="" d
	...s ConsultDoc2=$p(^SSU("SSUSR",ConsultDocDr2),"^",2)		//$P(^CTPCP(ConsultDocDr1,1),"^",2) //会诊医生1
	...s ConsultDoc2= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",ConsultDoc2,langid)
	..s ConsultDate2=$p(conInfo,"^",4)
	..s ConsultTime2=$p(conInfo,"^",5)
	..i ConsultDate2'="" s ConsultD2=##class(DHCAnt.KSS.Common.Method).DateLogicalToHtml(ConsultDate2)	//$zd(ConsultDate1,3)
	..i ConsultTime2'="" s ConsultT2=$zt(ConsultTime1,2)
	..s ConsultDT2=ConsultD2_" "_ConsultT2
	
	.//会诊医生3
	.s ConsultDR3=$p(^DHCDAA("ANT",AARowid,1),"^",29)
	.i ConsultDR3'="" d
	..s conInfo=##Class(web.DHCEMConsInterface).GetAntiConsultInfo(ConsultDR3)
	..s ConsultDocDr3=$p(conInfo,"^",2)
	..i ConsultDocDr3'="" d
	...s ConsultDoc3=$p(^SSU("SSUSR",ConsultDocDr3),"^",2)		//$P(^CTPCP(ConsultDocDr1,1),"^",2) //会诊医生1
	...s ConsultDoc3= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",ConsultDoc3,langid)
	..s ConsultDate3=$p(conInfo,"^",4)
	..s ConsultTime3=$p(conInfo,"^",5)
	..i ConsultDate3'="" s ConsultD3=##class(DHCAnt.KSS.Common.Method).DateLogicalToHtml(ConsultDate3)	//$zd(ConsultDate1,3)
	..i ConsultTime3'="" s ConsultT3=$zt(ConsultTime1,2)
	..s ConsultDT3=ConsultD3_" "_ConsultT3
	
	.d OutwardRow10
   	
	Quit $$$OK
	
OutwardRow10
	s AuditUserName= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",AuditUserName,langid)
	set Data=$lb(AARowid,ArcimName,ArcimId,AppUserName,AppDT,AppStatus,AppStatusDesc,AuditUserName,AuditDT,ProcessInfo,ConsultDoc1,ConsultDT1,ConsultDoc2,ConsultDT2,ConsultDoc3,ConsultDT3,checkboxok,EmergencyDesc,cOeori)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QryAntApplyInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAntApplyInfoExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QryAntApplyInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAntApplyInfoExecute ]
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

/// CTOR: QP
/// DATE: 2016-08-14
/// DESC: 抗菌药物申请列表点击确定后加载到医嘱录入的方法
/// IN  :   itmjs: AddCopyItemToList  	
/// 			itmjsex: ''
/// 			EpisodeId - PA_Adm表Id
/// 			AARowidStr - DHC_Doc_AntibioticApply表ID
/// OUT : 
/// Note: 以前: web.DHCDocAntibioticReason.GetAddToListArcimInfo
/// EXEC: d ##class(DHCAnt.KSS.MainInterface).GetAddToListArcimInfo("","",25,"614||1")
ClassMethod GetAddToListArcimInfo(itmjs As %Library.String = "", itmjsex As %Library.String = "", EpisodeID As %String, AARowidStr As %String, CQMXid As %String = "") As %String
{
	n (itmjs,itmjsex,EpisodeID,AARowidStr,CQMXid)
	;AddCopyItemToList!!683!1133^
	;s ^TEMP("QP",1)=itmjs_"!"_itmjsex_"!"_EpisodeID_"!"_AARowidStr
	q:$g(EpisodeID)="" ""
	q:$g(AARowidStr)="" ""
	s jsval=""
	s PAAdmType=$p(^PAADM(EpisodeID),"^",2)
	s len=$length(AARowidStr,"^")
	for i=1:1:len {
		s AARowid=$p(AARowidStr,"^",i)
		continue:AARowid=""
		s arcim=$p(^DHCDAA("ANT",AARowid),"^",2)
		s AppDate=$p(^DHCDAA("ANT",AARowid),"^",10)
		s AppTime=$p(^DHCDAA("ANT",AARowid),"^",11)
		s ConsultDR=$p(^DHCDAA("ANT",AARowid,1),"^",22)
		S curdate=+$H,curtime=$P($h,",",2)
		s curTime=##class(DHCAnt.KSS.Common.Method).GetAbsTime($h)
		s applyTime=##class(DHCAnt.KSS.Common.Method).GetAbsTime(AppDate_","_AppTime)
		;q:curTime>(applyTime+86400)             
		;if ConsultDR'=""  d
		;.Set ConResult=##class(web.DHCConsult).checktsyhzrowid(arcim,EpisodeID,curdate,curTime)
		;.Q:ConResult'=1         ;未同意的会诊 退出
		S InstrucDR=$p(^DHCDAA("ANT",AARowid),"^",8)
		s Instruc="",FormDurDesc="",FormDurRowid="",FormDurFactor=""
		if InstrucDR'="" S Instruc=$p(^PHCIN(InstrucDR),"^",2)    //用法
		s UseReasonID=$p(^DHCDAA("ANT",AARowid,1),"^",20)         //使用目的ID
		s oeori=$p(^DHCDAA("ANT",AARowid,1),"^",6) 
		;抗菌药物申请列表中开过一次的申请，在录入的时候是复制列表中的使用目的   
		;if oeori'=""  d 
		;.s ret=##class(DHCAnt.KSS.MainInterface).CopyAntUsePurpose(oeori)                                /////
		;.s rtn=$p(ret,"^",1)
		;.if rtn=0  d
		;..s UseReasonID=$p(ret,"^",2)
		;..s AARowid=""
		s ret=##class(DHCAnt.KSS.MainInterface).CopyAntUsePurposeNew(UseReasonID)	//QP 处理抗菌药物申请列表选择记录导致使用目的相同bug
		s rtn=$p(ret,"^",1)
		if rtn=0  d
		.s UseReasonID=$p(ret,"^",2)
		.if oeori'="" s AARowid=""  
		.if CQMXid'="" s mResult=##class(DHCAnt.KSS.Extend.CQMX).ChangeUseAimDR(CQMXid,UseReasonID,AARowid) 
		
		s FormDoseQty="",FormDoseUOMRowid="",FormDoseUOMDesc=""
		s FormFreqRowid="",FormFreqDesc="",FormFreqFactor="",FormFreqInterval=""
		s DrgformRowid=##class(web.DHCDocOrderEntry).GetDrgForm(arcim)
		i DrgformRowid'=""   d
		.s PHCDRowid=$P(DrgformRowid,"||",1)
	  	.s ChildSub=$P(DrgformRowid,"||",2)
		.s FormDoseQty=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,2)),"^",5) ;Pharmacy base UOM
	  	.s FormDoseUOMRowid=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,2)),"^",4)
	  	.;添加取等效单位及默认值
	  	.s eqSub=$o(^PHCD(PHCDRowid,"DF",ChildSub,"EQ",0))
	  	.i eqSub'="" d
	  	..s FormDoseUOMRowid=$p(^PHCD(PHCDRowid,"DF",ChildSub,"EQ",eqSub),"^",1)
	  	..s FormDoseQty=$p(^PHCD(PHCDRowid,"DF",ChildSub,"EQ",eqSub),"^",3)
	  	..s FormDoseQty=##class(DHCAnt.KSS.Common.Method).ComDealToNum(FormDoseQty)
	  	..s FormDoseQty=..GetFormDoseQty(DrgformRowid)
	  	.s FormDoseUOMDesc=##class(web.DHCDocOrderCommon).GetUOMDesc(FormDoseUOMRowid)
	  	.;添加默认疗程 20130106
	  	.s FormDurRowid=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,1)),"^",8)
	  	.i FormDurRowid'=""  d
		..s FormDurDesc=$P($g(^PHCDU(FormDurRowid)),"^",3)
		..s FormDurFactor=$P($g(^PHCDU(FormDurRowid)),"^",2)
		.;频率
	  	.s FormFreqRowid=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,1)),"^",4)
	    .i FormFreqRowid'=""  d
		..s FormFreqDesc=$P($g(^PHCFR(FormFreqRowid)),"^",3)
		..s FormFreqFactor=$P($g(^PHCFR(FormFreqRowid)),"^",2)
		..s FormFreqInterval=$P($g(^PHCFR(FormFreqRowid)),"^",5)
		s OrderActionRowid="",OrderAction="",OrderSkinTest="N"
		;跟医生站的默认走，只要有一个标志勾上，就表示皮试
		s PSFlag=##class(DHCAnt.KSS.Common.Method).GetPSFlag(arcim)
		i PSFlag=1 s OrderSkinTest="Y"
		s YYInfo=##class(DHCAnt.KSS.Common.Method).GetOrderActionYY()
		s YYFlag=##class(DHCAnt.KSS.Common.Method).GetOrderActionFlag(arcim,PAAdmType)
		i YYFlag=1 d
		.s OrderSkinTest="Y"
		.s OrderActionRowid=$p(YYInfo,"^",1)
		.s OrderAction=$p(YYInfo,"^",2)
		
		s ItemData=FormDoseQty_$C(1)_FormDoseUOMDesc_$C(1)_FormDoseUOMRowid
		s ItemData=ItemData_"^"_FormFreqDesc_$C(1)_FormFreqRowid_$C(1)_FormFreqFactor_$C(1)_FormFreqInterval
		s ItemData=ItemData_"^"_Instruc_$C(1)_InstrucDR
		s ItemData=ItemData_"^"_FormDurDesc_$C(1)_FormDurRowid_$C(1)_FormDurFactor
		s ItemData=ItemData_"^"_""_$C(1)_""_$C(1)_""
		s ItemData=ItemData_"^"_""_$C(1)_""_$C(1)_""
		s ItemData=ItemData_"^^^^^"
		s ItemData=ItemData_"^"_AARowid_$C(1)_UseReasonID	//12
		s ItemData=ItemData_"^^^^^^^"_OrderActionRowid_"^"_OrderAction_"^"_OrderSkinTest	//21
		
		s OrderType="",OrderSeqNo="",ID=""
		s SubCatRowId=$p(^ARCIM(+arcim,$p(arcim,"||",2),1),"^",10)
		if SubCatRowId'="" s OrderType=$p(^ARC("IC",SubCatRowId),"^",7)
		s jsval=jsval_"Copyary[Copyary.length]="""_arcim_"!"_OrderSeqNo_"!"_ItemData_"!"_OrderType_"!!!!"_"KSS"_""";"
		 
	}
	if (itmjs'="")&&(jsval'="") {
		s jsval="var Copyary=new Array();"_jsval_itmjs_"(Copyary);"
		;s ^TEMP("DHCAnt",323)=jsval
		&javascript<#(jsval)#>
	}
	q 0
}

/// CTOR: QP
/// DATE: 2016-08-14
/// DESC: 复制医嘱时同时复制使用目的
/// IN  : 
/// OUT : 
/// EXEC: d ##class(DHCAnt.KSS.MainInterface).CopyAntUsePurpose("24||8")
ClassMethod CopyAntUsePurpose(oeori As %String, arcim As %String = "")
{
	n (oeori,arcim)
	quit:$g(oeori)="" 100_"^"
	quit:'$d(^DAUP("OEORI",$g(oeori))) 101_"^"
	s UseReasonID=$o(^DAUP("OEORI",oeori,""))
	quit:$g(UseReasonID)="" 102_"^"
	s Obj=##class(User.DHCAntUsePurpose).%OpenId(UseReasonID)
	if $ISObject(Obj){
		;s date=Obj.DAUPDate+1
		;s time=Obj.DAUPTime
		;s H=date_","_time
		;s OldH=..GetAbsTime(H)
		;s CurH=..GetAbsTime($h)
		;q:CurH>OldH 103_"^"
		TS
		s ObjNew=##class(User.DHCAntUsePurpose).%New()
		if $ISObject(ObjNew){
			
			s ObjNew.DAUPAdmdr = Obj.DAUPAdmdr
			s ObjNew.DAUPUser = Obj.DAUPUser
			s ObjNew.DAUPLastUpdateUser = Obj.DAUPLastUpdateUser
			i arcim'="" do ObjNew.DAUPItmMastDRSetObjectId(arcim)	//Quinn	
			e  s ObjNew.DAUPItmMastDR = Obj.DAUPItmMastDR
			s ObjNew.DAUPDTAUPDR = Obj.DAUPDTAUPDR
			s ObjNew.DAUPOPerInd = Obj.DAUPOPerInd
			s ObjNew.DAUPBodyPart = Obj.DAUPBodyPart
			s ObjNew.DAUPOperaYFTimeDR = Obj.DAUPOperaYFTimeDR
			s ObjNew.DAUPSubmission = Obj.DAUPSubmission  
			S ObjNew.DAUPSusceptDR = Obj.DAUPSusceptDR
			S ObjNew.DAUPOperationDR = Obj.DAUPOperationDR
			s ObjNew.DAUPPatDR = Obj.DAUPPatDR  //病人ID
			s ObjNew.DAUPKSS3Indication = Obj.DAUPKSS3Indication   //新增特抗药指征
			s ObjNew.DAUPZBJ = Obj.DAUPZBJ    //新增致病菌
			s ObjNew.DAUPPreUseDrugTime = Obj.DAUPPreUseDrugTime  //新增预防用药天数
			s ObjNew.DAUPExtendUseReason = Obj.DAUPExtendUseReason  //新增延长用药原因
			s ObjNew.DAUPDate = +$h
			s ObjNew.DAUPTime = $p($h,",",2)
			s ObjNew.DAUPLastUpdateDate = +$h
			s ObjNew.DAUPLastUpdateTime = $p($h,",",2)
			s ObjNew.DAUPCopy = UseReasonID
			set sc=ObjNew.%Save()
			;b  ;insert finish
			if $$$ISERR(sc){
				Trollback
				quit 200_"^"
				}
			set daupRowid=ObjNew.%Id()
			TC
			S rtn=0
		}
		do Obj.%Close()
	}
	quit rtn_"^"_daupRowid
}

/// CTOR: QP
/// DATE: 2016-08-14
/// DESC: 复制医嘱时同时复制使用目的
/// IN  : 
/// OUT : 
/// EXEC: d ##class(DHCAnt.KSS.MainInterface).CopyAntUsePurposeNew("24||8")
ClassMethod CopyAntUsePurposeNew(UseReasonID As %String)
{
	n (UseReasonID)
	quit:$g(UseReasonID)="" 102_"^"
	s Obj=##class(User.DHCAntUsePurpose).%OpenId(UseReasonID)
	if $ISObject(Obj){
		;s date=Obj.DAUPDate+1
		;s time=Obj.DAUPTime
		;s H=date_","_time
		;s OldH=..GetAbsTime(H)
		;s CurH=..GetAbsTime($h)
		;q:CurH>OldH 103_"^"
		TS
		s ObjNew=##class(User.DHCAntUsePurpose).%New()
		if $ISObject(ObjNew){
			
			s ObjNew.DAUPAdmdr = Obj.DAUPAdmdr
			s ObjNew.DAUPUser = Obj.DAUPUser
			s ObjNew.DAUPLastUpdateUser = Obj.DAUPLastUpdateUser
			s ObjNew.DAUPItmMastDR = Obj.DAUPItmMastDR
			s ObjNew.DAUPDTAUPDR = Obj.DAUPDTAUPDR
			s ObjNew.DAUPOPerInd = Obj.DAUPOPerInd
			s ObjNew.DAUPBodyPart = Obj.DAUPBodyPart
			s ObjNew.DAUPOperaYFTimeDR = Obj.DAUPOperaYFTimeDR
			s ObjNew.DAUPSubmission = Obj.DAUPSubmission  
			S ObjNew.DAUPSusceptDR = Obj.DAUPSusceptDR
			S ObjNew.DAUPOperationDR = Obj.DAUPOperationDR
			s ObjNew.DAUPPatDR = Obj.DAUPPatDR  //病人ID
			s ObjNew.DAUPKSS3Indication = Obj.DAUPKSS3Indication   //新增特抗药指征
			s ObjNew.DAUPZBJ = Obj.DAUPZBJ    //新增致病菌
			s ObjNew.DAUPPreUseDrugTime = Obj.DAUPPreUseDrugTime  //新增预防用药天数
			s ObjNew.DAUPExtendUseReason = Obj.DAUPExtendUseReason  //新增延长用药原因
			s ObjNew.DAUPDate = +$h
			s ObjNew.DAUPTime = $p($h,",",2)
			s ObjNew.DAUPLastUpdateDate = +$h
			s ObjNew.DAUPLastUpdateTime = $p($h,",",2)
			s ObjNew.DAUPCopy = UseReasonID
			set sc=ObjNew.%Save()
			;b  ;insert finish
			if $$$ISERR(sc){
				Trollback
				quit 200_"^"
				}
			set daupRowid=ObjNew.%Id()
			TC
			S rtn=0
		}
		do Obj.%Close()
	}
	quit rtn_"^"_daupRowid
}

/// CTOR: QP
/// DATE: 2017-06-19
/// DESC: 手术预防控制
/// IN  : 
/// OUT : 
/// EXEC: d ##class(DHCAnt.KSS.MainInterface).ContrlOPYf("24||8")
ClassMethod ContrlOPYf(EpisodeID, OperationNum, ArcimRowid)
{
    n (EpisodeID, OperationNum, ArcimRowid)
    S ^TEMP("DHCAnt","KSS","Quinn",1)=EpisodeID_"^"_OperationNum_"^"_ArcimRowid
	s flag=0,CheckFlag=0
    s anaId=$P(^DHCANOPArrange(OperationNum),"^",2) ;手术麻醉Id
    s anaSub=$P(anaId,"||",2)
    s anaopSub=0
    f  s anaopSub=$O(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)) q:(anaopSub="")  d  
    .s curOperIdStr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",24)       ;部位代码
    .q:$g(curOperIdStr)=""
    .s curOperlen=$l(curOperIdStr,"|")
    .f i=1:1:curOperlen d
    ..s curOperId=$p(curOperIdStr,"|",i)
    ..q:$g(curOperId)=""
    ..;s CheckFlag=CheckFlag+curOperId
    ..q:'$d(^DHCANC("SPA",0,"BodySite",curOperId))
    ..s DHCANCRowid=0
    ..f  s DHCANCRowid=$O(^DHCANC("SPA",0,"BodySite",curOperId,DHCANCRowid)) q:DHCANCRowid=""  d
    ...s DHCANCRArcimid=$list(^DHCANC("SPA",DHCANCRowid),2)
    ...s Activation=$list(^DHCANC("SPA",DHCANCRowid),3)
    ...q:Activation="N"
    ...i DHCANCRArcimid[ArcimRowid s flag=1
    ;i CheckFlag=0 s flag=0
    q flag
	
	/*
	s DHCANCROpNum="",DHCANCRArcimid="",Activation=""
	s flag=0,DHCANCRArcimidlen=0,DHCANCRArcimidStr="",anaId="",anaSub=""
	s DHCANCRowid=0  f  s DHCANCRowid=$o(^DHCANC("SPA",DHCANCRowid)) q:DHCANCRowid=""  d
	.s DHCANCROpNum=$list(^DHCANC("SPA",DHCANCRowid),1)
	.s anaId=$P(^DHCANOPArrange(OperationNum),"^",2) ;手术麻醉Id
	.s anaSub=$P(anaId,"||",2)
	.s anaopSub=0
	.f  s anaopSub=$O(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)) q:(anaopSub="")  d  
	..s curOperId=$P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",24)       ;部位代码
	..i DHCANCROpNum=+curOperId d
	...s DHCANCRArcimidStr=$list(^DHCANC("SPA",DHCANCRowid),2)
	...s Activation=$list(^DHCANC("SPA",DHCANCRowid),3)
	...q:Activation="N"
	...s DHCANCRArcimidlen=$l(DHCANCRArcimidStr,"~")
	...f i=1:1:DHCANCRArcimidlen d
	....b  ;1
	....s DHCANCRArcimid=$p(DHCANCRArcimidStr,"~",i)
	....i (DHCANCRArcimid=ArcimRowid)&&(flag=0) d
	.....s flag=1

	q flag
	*/
}

/// Creator:tanjishan
/// CreatDate:2019-06-12
/// 获取超过48小时未停止的、使用目的预防类的抗菌药物,提醒医生尽快做停止处理
/// w ##Class(DHCAnt.KSS.MainInterface).GetAntOverTimeOrdList()
ClassMethod GetAntOverTimeOrdList(EpisodeID, InHosp = "") As %String
{
	q:(EpisodeID="")||(InHosp="") ""
	//预防用药时间控制天数
	s maxusedays=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("YFDRUGTIME",InHosp)
	q:(maxusedays="") ""
	s Msg=""
	s DAUPRowid=""
	for{
		s DAUPRowid=$O(^DAUP("NEWADM",EpisodeID,DAUPRowid))
		q:(DAUPRowid="")
		s DTAUPDR=$P($G(^DAUP("DAUP",DAUPRowid)),"^",20)
		continue:(DTAUPDR="")
		s AURDR=$p(^DHCAntBasePurposeDataConfigD(DTAUPDR),"^",6)
		continue:(AURDR="")
		s AURCode=$P($G(^DHCAntBasePurposeDataConfigD(AURDR)),"^",4)
		//预防用药
		continue:(AURCode'="YF")
		s DAUPOEORIDR=$P($G(^DAUP("DAUP",DAUPRowid)),"^",3)
		continue:(DAUPOEORIDR="")
		//w DAUPOEORIDR,!
		s OEORDRowId=+DAUPOEORIDR
		s OEORIChildsub=$P(DAUPOEORIDR,"||",2)
		s str1=$G(^OEORD(OEORDRowId,"I",OEORIChildsub,1))
		s PriorRowid=$p(str1,"^",8)
		s LongPriorFlag=##class(appcom.OEOrdItem).ISLongOrderPrior(PriorRowid)
		continue:(LongPriorFlag=0)
		s statcode=""
		s Stat=$P(str1,"^",13)
		s:Stat'="" statcode=$p($g(^OEC("OSTAT",Stat)),"^",1)
		continue:(statcode'="V")
		s ArcimRowid=$P(str1,"^",2)
		s SttDate=$p(str1,"^",9)
		s SttDate=$O(^OEORDi(0,"OrdItem",OEORDRowId,OEORIChildsub,0))
		i SttDate="" s SttDate=$p(str1,"^",9)
		
		if (maxusedays<=(+$H-SttDate)){
			s OrderName=##Class(web.DHCDocOrderCommon).GetFormateOrderName(ArcimRowid)
			if (Msg=""){
				s Msg=OrderName
			}else{
				s Msg=Msg_"、"_OrderName
			}
		}
		
	}
	if (Msg'=""){
		s Msg="【"_Msg_"】以上抗菌药物长期预防用药限制用药时间为"_maxusedays_"天,请尽快处理！"
	}
	q Msg
}

/// CTOR: QP
/// DATE: 2019-08-08
/// DESC: 
/// IN  : 申请ID
/// OUT : 
/// TABL: PHC_Poison
/// EXEC: w ##class(DHCAnt.KSS.MainInterface).FindApplyDetail(2381)
ClassMethod FindApplyDetail(aaid As %String)
{
	n (aaid)
	s mRtn=""
	Q:aaid="" ""
	s APPOBJ=##class(User.DHCDocAntibioticApply).%OpenId(aaid)
	s USEAimOBJ=APPOBJ.AAPurposeDR
	s usePurposeDr=USEAimOBJ.DAUPDTAUPDR,usePurpose=""
	i usePurposeDr'="" s usePurpose=$p(^DHCAntBasePurposeDataConfigD(usePurposeDr),"^",3)
	s drugIndicationDr=USEAimOBJ.DAUPOPerInd,drugIndication=""
	i drugIndicationDr'="" s drugIndication=$p(^DHCAntBasePurposeDataConfigD(drugIndicationDr),"^",3)	
	s bodyPartDr=USEAimOBJ.DAUPBodyPart,bodyPart=""
	i bodyPartDr'="" s bodyPart=$p(^DHCAntBasePurposeDataConfigD(bodyPartDr),"^",3)	
	s useTimeDr=USEAimOBJ.DAUPOperaYFTimeDR,useTime=""
	i useTimeDr'="" s useTime=$p(^DHCAntBasePurposeDataConfigD(useTimeDr),"^",3)
	s kss3IndicationDr=USEAimOBJ.DAUPKSS3Indication,kss3Indication=""
	i kss3IndicationDr'="" s kss3Indication=$p(^DHCAntBasePurposeDataConfigD(kss3IndicationDr),"^",3)
	s isLab=USEAimOBJ.DAUPSubmission
	I isLab=1 s isLab="是" 
	e  s isLab="否"
	s emergency=APPOBJ.AAisEmergency
	I emergency=1 s emergency="是" 
	e  s emergency="否"
	s emergencyReason=APPOBJ.AAEmergecyReason
	//病历摘要
	//s BLInfo=$g(^DHCDAA("ANT","ExtendPara",aaid))
	
	s (CDT1,CDT2,CDT3,CNote1,CNote2,CNote3)=""
	s (CDoc1,CDoc2,CDoc3,CLoc1,CLoc2,CLoc3)=""
	s (CAgree1,CAgree2,CAgree3)=""
	
	//会诊医生1
	s CLoc1=$p(^DHCDAA("ANT",aaid,1),"^",4)
	i CLoc1'="" s CLoc1=$p(^CTLOC(CLoc1),"^",2)
	s CDoc1=$p($g(^DHCDAA("ANT",aaid,1)),"^",5)
	i CDoc1'="" s CDoc1=$p(^CTPCP(CDoc1,1),"^",2)
	
	s ConsultDR1=$p(^DHCDAA("ANT",aaid,1),"^",22)
	i ConsultDR1'="" d
	.s conInfo=##Class(web.DHCEMConsInterface).GetAntiConsultInfo(ConsultDR1)
	.s CNote1=$p(conInfo,"^",3)
	.s ConsultDate1=$p(conInfo,"^",4)
	.s ConsultTime1=$p(conInfo,"^",5)
	.i ConsultDate1'="" s ConsultD1=##class(DHCAnt.KSS.Common.Method).DateLogicalToHtml(ConsultDate1)	//$zd(ConsultDate1,3)
	.i ConsultTime1'="" s ConsultT1=$zt(ConsultTime1,2)
	.s CDT1=ConsultD1_" "_ConsultT1
	.s agreeInfo=##Class(web.DHCEMConsInterface).GetConsentAnti(ConsultDR1)
	.i agreeInfo="Y" s CAgree1="同意"
	.i agreeInfo="N" s CAgree1="拒绝"
	
	//会诊医生2
	s ConsultDR2=$p(^DHCDAA("ANT",aaid,1),"^",26)
	s CLoc2=$p(^DHCDAA("ANT",aaid,1),"^",27)
	i CLoc2'="" s CLoc2=$p(^CTLOC(CLoc2),"^",2)
	s CDoc2=$p($g(^DHCDAA("ANT",aaid,1)),"^",28)
	i CDoc2'="" s CDoc2=$p(^CTPCP(CDoc2,1),"^",2)
	i ConsultDR2'="" d
	.s conInfo=##Class(web.DHCEMConsInterface).GetAntiConsultInfo(ConsultDR2)
	.s CNote2=$p(conInfo,"^",3)
	.s ConsultDate2=$p(conInfo,"^",4)
	.s ConsultTime2=$p(conInfo,"^",5)
	.i ConsultDate2'="" s ConsultD2=##class(DHCAnt.KSS.Common.Method).DateLogicalToHtml(ConsultDate2)	//$zd(ConsultDate1,3)
	.i ConsultTime2'="" s ConsultT2=$zt(ConsultTime2,2)
	.s CDT2=ConsultD2_" "_ConsultT2
	.s agreeInfo=##Class(web.DHCEMConsInterface).GetConsentAnti(ConsultDR2)
	.i agreeInfo="Y" s CAgree2="同意"
	.i agreeInfo="N" s CAgree3="拒绝"
	
	//会诊医生3
	s ConsultDR3=$p(^DHCDAA("ANT",aaid,1),"^",29)
	s CLoc3=$p(^DHCDAA("ANT",aaid,1),"^",30)
	i CLoc3'="" s CLoc3=$p(^CTLOC(CLoc3),"^",2)
	s CDoc3=$p($g(^DHCDAA("ANT",aaid,1)),"^",31)
	i CDoc3'="" s CDoc3=$p(^CTPCP(CDoc3,1),"^",2)
	i ConsultDR3'="" d
	.s conInfo=##Class(web.DHCEMConsInterface).GetAntiConsultInfo(ConsultDR3)
	.s CNote3=$p(conInfo,"^",3)
	.s ConsultDate3=$p(conInfo,"^",4)
	.s ConsultTime3=$p(conInfo,"^",5)
	.i ConsultDate3'="" s ConsultD3=##class(DHCAnt.KSS.Common.Method).DateLogicalToHtml(ConsultDate3)	//$zd(ConsultDate1,3)
	.i ConsultTime3'="" s ConsultT3=$zt(ConsultTime3,2)
	.s CDT3=ConsultD3_" "_ConsultT3
	.s agreeInfo=##Class(web.DHCEMConsInterface).GetConsentAnti(ConsultDR3)
	.i agreeInfo="Y" s CAgree3="同意"
	.i agreeInfo="N" s CAgree3="拒绝"
	
	//医嘱信息
	s oeori=$p(^DHCDAA("ANT",aaid,1),"^",6)
	s (instruc,freq)=""
	i oeori'="" d
	.q:(##class(DHCAnt.KSS.Common.Method).FilterOrdStatus(oeori)=1)
	.s ord=+oeori,sub=$p(oeori,"||",2)
	.s instrucDr=$p(^OEORD(ord,"I",sub,2),"||",7)
	.s instruc=$p(^PHCIN(instrucDr),"^",2)
	.s freqDr=$p(^OEORD(ord,"I",sub,2),"||",4)
	.s freq=$p(^PHCFR(freqDr),"^",3)
	
	s webDto=##class(DHCAnt.Base.Dto.ApplyDetail).%New()
	s webDto.usePurpose=usePurpose
	s webDto.drugIndication=drugIndication
	s webDto.bodyPart=bodyPart
	s webDto.useTime=useTime
	s webDto.kss3Indication=kss3Indication
	s webDto.isLab=isLab
	s webDto.emergency=emergency
	s webDto.emergencyReason=emergencyReason
	s webDto.CLoc1=CLoc1
	s webDto.CDoc1=CDoc1
	s webDto.CAgree1=CAgree1
	s webDto.CNote1=CNote1
	s webDto.CDT1=CDT1
	s webDto.CLoc2=CLoc2
	s webDto.CDoc2=CDoc2
	s webDto.CAgree2=CAgree2
	s webDto.CNote2=CNote2
	s webDto.CDT2=CDT2
	s webDto.CLoc3=CLoc3
	s webDto.CDoc3=CDoc3
	s webDto.CAgree3=CAgree3
	s webDto.CNote3=CNote3
	s webDto.CDT3=CDT3
	s webDto.instruc=instruc
	s webDto.freq=freq
	
	s BSNoramlEntity=##class(DHCAnt.Util.Common).GetClassPropertyList("DHCAnt.Base.Dto.ApplyDetail")
	s Len=$l(BSNoramlEntity,"^")
	s mRtn="[{"
	f i=2:1:Len {
		s cName=$p(BSNoramlEntity,"^",i)
		s cValue=$ZOBJPROPERTY(webDto, cName)
		i i=2 s mRtn=mRtn_""""_cName_""":"""_cValue_""""
		e  s mRtn=mRtn_","""_cName_""":"""_cValue_""""
			
	}
	s mRtn=mRtn_"}]"
	d APPOBJ.%Close()
	d webDto.%Close()
	q mRtn
}

/// CTOR: QP
/// DATE: 2019-08-21
/// DESC: 
/// IN  : 获取病历摘要
/// OUT : 
/// TABL: PHC_Poison
/// EXEC: w ##class(DHCAnt.KSS.MainInterface).GetBLInfo(2381)
ClassMethod GetBLInfo(aaid As %String)
{
	n (aaid)
	//病历摘要
	s BLInfo=$g(^DHCDAA("ANT","ExtendPara",aaid))
	
	q BLInfo
}

/// CTOR: QP
/// DATE: 2019-12-11
/// DESC: 
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCAnt.KSS.MainInterface).GetFormDoseQty(2381)
ClassMethod GetFormDoseQty(DrgformRowid As %String)
{
	n (DrgformRowid)
	
	s mRtn=""
	Q:DrgformRowid="" mRtn
	s PHCDRowid=$P(DrgformRowid,"||",1)
	s ChildSub=$P(DrgformRowid,"||",2)
	
	s PHUseEqQty=##Class(web.DHCDocConfig).GetConfigNode("PHUseEqQty")
	s FormDoseQty=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,2)),"^",5) ;Pharmacy base UOM
	s FormDoseUOMRowid=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,2)),"^",4)
	s FormDoseUOMDesc=##class(web.DHCDocOrderCommon).GetUOMDesc(FormDoseUOMRowid)
	s OrderDoseStr=FormDoseQty_$C(1)_FormDoseUOMDesc_$C(1)_FormDoseUOMRowid
	s PHCDoseStr=FormDoseQty_$C(1)_FormDoseUOMDesc_$C(1)_FormDoseUOMRowid
	 
	s leq=0  f  s leq=$o(^PHCD(PHCDRowid,"DF",ChildSub,"EQ",leq)) q:leq=""  d
	.s eqrec=^PHCD(PHCDRowid,"DF",ChildSub,"EQ",leq)
	.s FormDoseUOMRowid=$p(eqrec,"^"),eqqty=$p(eqrec,"^",2),eqdefaultqty=$p(eqrec,"^",3)
	.if eqdefaultqty'="" s FormDoseQty=eqdefaultqty
	.e  d
	..i PHUseEqQty=1 s FormDoseQty=eqqty
	..e  s FormDoseQty=""
	.s FormDoseUOMDesc=##class(web.DHCDocOrderCommon).GetUOMDesc(FormDoseUOMRowid)
	.i (FormDoseQty'="")&(FormDoseQty<1)&(FormDoseQty'=0) s FormDoseQty="0"_FormDoseQty
	
	Q FormDoseQty
}

/// Desc: 通过抗生素申请ID获取申请信息
/// 2021-09-06 lx
/// debug: w ##class(DHCAnt.KSS.MainInterface).GetAntUsePurposeByApplyId(2381)</Description>
ClassMethod GetAntUsePurposeByApplyId(ApplyId) As %String
{
	n (ApplyId)
	s PurposeId=$p($g(^DHCDAA("ANT",ApplyId,1)),"^",20)
	q:(PurposeId="") "{}"
	
	s AdmId=$p($g(^DAUP("DAUP",PurposeId)),"^",2)
	s BodyPartId=$p($g(^DAUP("DAUP",PurposeId)),"^",6)		;感染部位
	s OperationId=$p($g(^DAUP("DAUP",PurposeId)),"^",9)		;手术记录
	s DrugInd=$p($g(^DAUP("DAUP",PurposeId)),"^",10)		;用药指征
	s AntSusceptId=$p($g(^DAUP("DAUP",PurposeId)),"^",11)	;药敏记录
	s ReasonId=$p($g(^DAUP("DAUP",PurposeId)),"^",20)		;使用目的ID
	s YFTimeId=$p($g(^DAUP("DAUP",PurposeId)),"^",22)		;预防用药时间
	s KSS3Ind=$p($g(^DAUP("DAUP",PurposeId)),"^",23)		;使用特抗药指征
	s ZBacterium=$p($g(^DAUP("DAUP",PurposeId)),"^",27)		;致病菌
	;过敏信息
	s ModeId=$o(^BS.ANT.DHCAntModePrjI("ApplyDr",ApplyId,""))
	i ModeId'="" d
	.s HasGMis=$p(^BS.ANT.DHCAntModePrjD(ModeId),"^",3)
	.s GMDrug=$p(^BS.ANT.DHCAntModePrjD(ModeId),"^",4)
	.s GMClassify=$p(^BS.ANT.DHCAntModePrjD(ModeId),"^",5)
	
	s Obj={}
	s Obj.AdmId=AdmId
	s Obj.BodyPartId=BodyPartId
	s Obj.OperationId=OperationId
	s Obj.DrugInd=DrugInd
	s Obj.AntSusceptId=AntSusceptId
	s Obj.ReasonId=ReasonId
	s Obj.YFTimeId=YFTimeId
	s Obj.KSS3Ind=KSS3Ind
	s Obj.ZBacterium=ZBacterium
	s Obj.HasGMis=$g(HasGMis)
	s Obj.GMDrug=$g(GMDrug)
	s Obj.GMClassify=$g(GMClassify)
	q Obj.%ToJSON()
}

/// Desc: 通过就诊ID获取抗生素申请信息
/// 2021-09-06 lx
/// debug: w ##class(DHCAnt.KSS.MainInterface).GetApplyInfoByAdmId(195,"12175^113^29^2")
ClassMethod GetApplyInfoByAdmId(EpisodeID, SessionStr, StDate, EndDate, Flag = "All") As %String
{
	n (EpisodeID,SessionStr,StDate,EndDate,Flag)
	s UserId=$p(SessionStr,"^",1)
	s LocId=$p(SessionStr,"^",2)
	s GroupId=$p(SessionStr,"^",3)
	s HospId=$p(SessionStr,"^",4)
	s StDate=##class(DHCAnt.KSS.Common.Method).DateHtmlToLogical(StDate)
	s EndDate=##class(DHCAnt.KSS.Common.Method).DateHtmlToLogical(EndDate)
	q:(EpisodeID="") "[]"
	
	s List=[]
	s AARowid=""
	f  s AARowid=$o(^DHCDAAi("AdmDR",EpisodeID,AARowid),-1)  q:AARowid=""  d
	.s AppUserId=$p(^DHCDAA("ANT",AARowid),"^",9)
	.q:(AppUserId'=UserId)&&(Flag="User")
	.d ApplyInfoOut
	q List.%ToJSON()	
	
ApplyInfoOut
	s (OrdStatus,AuditT,AuditDT,AuditUserName,ApplyStatus,ApplyStatusDesc,PatName,KSSDesc,ArcimDesc,ApplyLoc,AppUser,AppDate,UsePurpseDesc,OPerIndDesc,BodyPartdesc,YFtime)=""
	s (Conresult1,ConSuggestion1,Consultdep1,Consultdoc1,Conresult2,ConSuggestion2,Consultdep2,Consultdoc2,Conresult3,ConSuggestion3,Consultdep3,Consultdoc3)=""
	s (Emergency,EmergecyReason,Predictdays,ExtendEason,Process,AuditDT,AuditUserName,KSSCode,ApplyAdmId,ArcimId,PAAdmType)=""

	s ApplyAdmId=$p(^DHCDAA("ANT",AARowid),"^",1)
	s PAAdmType=$p(^PAADM(ApplyAdmId),"^",2)
	s PatientId=$p(^PAADM(ApplyAdmId),"^",1)
	s PatName=$p(^PAPER(PatientId,"ALL"),"^",1)	
	s ArcimId=$p(^DHCDAA("ANT",AARowid),"^",2)
	s KSSCode=##class(DHCAnt.KSS.Common.Method).GetKssCate(ArcimId)
	s KSSDesc=$case(KSSCode,"KSS1":"非限制级","KSS2":"特殊级","KSS3":"限制级",:"")
	s PoisonRowid=##class(DHCAnt.KSS.Common.Method).GetKssPoisonId(ArcimId)              
	s ArcimDesc=$p(^ARCIM(+ArcimId,$p(ArcimId,"||",2),1),"^",2)	;药品名称
	s ApplyStatus=$p($g(^DHCDAA("ANT",AARowid)),"^",12)
	q:ApplyStatus="C"		;过滤撤销
	s ApplyStatusDesc=##class(DHCAnt.Base.MainConfigExcute).GetOSDesc("PSTATUS"_ApplyStatus)
	s ProcessCode=$p($g(^DHCDAA("ANT",AARowid),1),"^",33)	;流程类型
	s Process=$p($g(^DHCDAA("ANT",AARowid,1)),"^",36)		;当前流程
	s AppUserId=$p(^DHCDAA("ANT",AARowid),"^",9)   
	s AppUser=$p(^SSU("SSUSR",AppUserId),"^",2)	
	s ApplyLocId=$p(^DHCDAA("ANT",AARowid,1),"^",25)  
	s ApplyLoc=$p(^CTLOC(ApplyLocId),"^",2)	
	s OrderId=$p(^DHCDAA("ANT",AARowid,1),"^",6)  
	i OrderId'="" d
	.s OrdStatusId=$p(^OEORD(+OrderId,"I",$p(OrderId,"||",2),1),"^",13)
	.s OrdStatus=$p(^OEC("OSTAT",OrdStatusId),"^",1)
	q:(OrdStatus="U")||(OrdStatus="C") 						;医嘱状态为撤销或作废
	s AppDate=$P(^DHCDAA("ANT",AARowid),"^",10)  ;申请日期
	s AppTime=$P(^DHCDAA("ANT",AARowid),"^",11)  ;申请时间
	q:(StDate'="")&&(StDate>AppDate)
	q:(EndDate'="")&&(EndDate<AppDate)
	s AppDate=##class(DHCAnt.KSS.Common.Method).DateLogicalToHtml(AppDate)
	s AppTime=$zt(AppTime,2)
	s AppDate=AppDate_" "_AppTime
	s AuditUserId=$p(^DHCDAA("ANT",AARowid,1),"^",10)     ;审核人	
	s AuditDate=$p(^DHCDAA("ANT",AARowid,1),"^",11)       ;审核日期
	s AuditTime=$p(^DHCDAA("ANT",AARowid,1),"^",12)       ;审核时间
	s AuditD=##class(DHCAnt.KSS.Common.Method).DateLogicalToHtml(AuditDate)
	s:AuditTime'="" AuditT=$zt(AuditTime,1)
	i AuditDate'="" s AuditDT=AuditD_" "_AuditT  
	i AuditUserId'="" d
	.s AuditUserName=$p(^SSU("SSUSR",AuditUserId),"^",2)
	e  d
	.s CurrentAuditInfo=##class(DHCAnt.KSS.Common.Method).GetCurrentAuditInfo(AARowid)
	.s CurAuditStatus=$p(CurrentAuditInfo,"^",4)
	.q:CurAuditStatus="A"
	.s CurAuditUserId=$p(CurrentAuditInfo,"^",1)
	.s AuditUserName=$p(^SSU("SSUSR",CurAuditUserId),"^",2)
	.s CurAuditDate=$p(CurrentAuditInfo,"^",2)
	.s CurAuditDate=##class(DHCAnt.KSS.Common.Method).DateLogicalToHtml(CurAuditDate)
	.s CurAuditTime=$zt($p(CurrentAuditInfo,"^",3),1)
	.s AuditDT=CurAuditDate_" "_CurAuditTime
	s UseReasonID=$p($g(^DHCDAA("ANT",AARowid,1)),"^",20)  				;使用目的业务表id
	s ReasonID=$P(^DAUP("DAUP",UseReasonID),"^",20)
	s UsePurpseDesc=$p(^DHCAntBasePurposeDataConfigD(ReasonID),"^",3)  	;使用目的
	s OPerIndDr=$P($g(^DAUP("DAUP",UseReasonID)),"^",10)
	s OPerIndDesc=$p(^DHCAntBasePurposeDataConfigD(OPerIndDr),"^",3)  	;指征
	s BodyPartDr=$p($g(^DAUP("DAUP",UseReasonID)),"^",6)      
	s BodyPartdesc=$p(^DHCAntBasePurposeDataConfigD(BodyPartDr),"^",3) 	;身体部位
	s YFtimedr=$p($g(^DAUP("DAUP",UseReasonID)),"^",22),YFtime="" 
	s:YFtimedr'="" YFtime=$p($g(^DHCAntBasePurposeDataConfigD(YFtimedr)),"^",3)     ;预防用药时间
	s IsEmergency=$p(^DHCDAA("ANT",AARowid,1),"^",23)  		;是否越级
	s Emergency=$case(IsEmergency,"1":"是",:"否")
	s EmergecyReason=$p(^DHCDAA("ANT",AARowid,1),"^",32)	;越级使用原因
	s Predictdays=$p($G(^DAUP("DAUP",UseReasonID)),"^",24)				;预计用药天数
	s ExtendEason=$p($G(^DAUP("DAUP",UseReasonID)),"^",25)				;延长用药原因
		
	s Consultdep1=$p($g(^DHCDAA("ANT",AARowid,1)),"^",4)
	s Consultdep2=$p($g(^DHCDAA("ANT",AARowid,1)),"^",27)
	s Consultdep3=$p($g(^DHCDAA("ANT",AARowid,1)),"^",30)
	s Consultdoc1=$p($g(^DHCDAA("ANT",AARowid,1)),"^",5)
	s Consultdoc2=$p($g(^DHCDAA("ANT",AARowid,1)),"^",28)
	s Consultdoc3=$p($g(^DHCDAA("ANT",AARowid,1)),"^",31)
	i Consultdep1'="" s Consultdep1=$p(^CTLOC(Consultdep1),"^",2)
	i Consultdep2'="" s Consultdep2=$p(^CTLOC(Consultdep2),"^",2)
	i Consultdep3'="" s Consultdep3=$p(^CTLOC(Consultdep3),"^",2)
	i Consultdoc1'="" s Consultdoc1=$p(^CTPCP(Consultdoc1,1),"^",2)
	i Consultdoc2'="" s Consultdoc2=$p(^CTPCP(Consultdoc2,1),"^",2)
	i Consultdoc3'="" s Consultdoc3=$p(^CTPCP(Consultdoc3,1),"^",2)
	s ConsultationID1=$p($g(^DHCDAA("ANT",AARowid,1)),"^",22)
	i ConsultationID1'=""    d
	.s conInfo=##Class(web.DHCEMConsInterface).GetAntiConsultInfo(ConsultationID1)
	.s conInfoDoc=$p(conInfo,"^",2),conInfoDep=$p(conInfo,"^",1),conInfoNote=$p(conInfo,"^",3)
	.q:conInfoDoc=""
	.s ConSuggestion1=conInfoNote
	.s agreeInfo=##Class(web.DHCEMConsInterface).GetConsentAnti(ConsultationID1)
	.s Conresult1=$case(agreeInfo,"Y":"同意","N":"拒绝",:"")
	s ConsultationID2=$p($g(^DHCDAA("ANT",AARowid,1)),"^",26)
	i ConsultationID2'=""    d
	.s conInfo=##Class(web.DHCEMConsInterface).GetAntiConsultInfo(ConsultationID2)
	.s conInfoDoc=$p(conInfo,"^",2),conInfoDep=$p(conInfo,"^",1),conInfoNote=$p(conInfo,"^",3)
	.q:conInfoDoc=""
	.s ConSuggestion2=conInfoNote
	.s agreeInfo=##Class(web.DHCEMConsInterface).GetConsentAnti(ConsultationID2)
	.s Conresult2=$case(agreeInfo,"Y":"同意","N":"拒绝",:"")
	
	s ConsultationID3=$p($g(^DHCDAA("ANT",AARowid,1)),"^",29)
	i ConsultationID3'=""    d
	.s conInfo=##Class(web.DHCEMConsInterface).GetAntiConsultInfo(ConsultationID3)
	.s conInfoDoc=$p(conInfo,"^",2),conInfoDep=$p(conInfo,"^",1),conInfoNote=$p(conInfo,"^",3)
	.q:conInfoDoc=""
	.s ConSuggestion3=conInfoNote
	.s agreeInfo=##Class(web.DHCEMConsInterface).GetConsentAnti(ConsultationID3)
	.s Conresult3=$case(agreeInfo,"Y":"同意","N":"拒绝",:"")
	
	s Data=$lb(AARowid,ApplyStatus,ApplyStatusDesc,PatName,KSSDesc,ArcimDesc,ApplyLoc,AppUser,AppDate,UsePurpseDesc,OPerIndDesc,BodyPartdesc,YFtime,Conresult1,ConSuggestion1,Consultdep1,Consultdoc1,Conresult2,ConSuggestion2,Consultdep2,Consultdoc2,Conresult3,ConSuggestion3,Consultdep3,Consultdoc3,Emergency,EmergecyReason,Predictdays,ExtendEason,Process,AuditDT,AuditUserName,KSSCode,ApplyAdmId,ArcimId,PAAdmType)
	s OutData="id^ApplyStatus^ApplyStatusDesc^PatName^kssjb^arcimDesc^ApplyLoc^AppUser^Appdate^UsePurpseDesc^OPerIndDesc^BodyPartdesc^YFtime^Conresult1^ConSuggestion1^Consultdep1^Consultdoc1^Conresult2^ConSuggestion2^Consultdep2^Consultdoc2^Conresult3^ConSuggestion3^Consultdep3^Consultdoc3^Emergency^EmergecyReason^Predictdays^ExtendEason^process^AuditDT^AuditUserName^KssCode^ApplyAdmDR^arcim^PAAdmType"
	s Obj={}
	d ..SetOutObjByList(.Obj,Data,OutData)
	d List.%Push(Obj)
	q ""
}

/// Desc: 把字符串按分隔符解析为对象
/// 2021-09-06 lx
/// debug: s a={}
/// 	   w ##class(DHCAnt.KSS.MainInterface).SetOutObjByList(.a,$lb(1,2,3),"a^b^c")
ClassMethod SetOutObjByList(ByRef Obj, Data, DataStr)
{
	n (Obj, Data,DataStr)
	f len=1:1:$l(DataStr,"^") d
	.s key=$p(DataStr,"^",len)
	.s val=$lg(Data,len)
	.s ObjStr="s Obj."""_key_"""="""_val_""""
	.XECUTE ObjStr
	
	q Obj
}

}
