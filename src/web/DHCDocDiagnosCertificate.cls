Class web.DHCDocDiagnosCertificate Extends DHCDoc.Util.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 删除医生书写的诊断证明记录
ClassMethod DeleteDiagnosCertificate(DDCRowId As %String) As %String
{
	s DDCStatus=$p($g(^DHCDOCDiagnosCertificate(DDCRowId)),"^",7)
	Q:(DDCStatus="P") "该诊断证明书已打印！"
	&sql(delete SQLUser.DHC_DocDiagnosCertificate where DDC_RowId=:DDCRowId)
	Q SQLCODE
}

/// 保存医生书写的诊断证明记录
/// w ##class(web.DHCDocDiagnosCertificate).SaveDiagnosCertificate("","3018||1","10/11/2020",10,"dd","3018^12175")
ClassMethod SaveDiagnosCertificate(DDCRowId As %String, DiagnosIDStr As %String, DiagConfirmDate As %String, DaysOff As %String, DocNotes As %String, ExpStr As %String) As %String
{
	s EpisodeID=$p(ExpStr,"^",1)
	s LogonUserID=$p(ExpStr,"^",2)
	s count=0
	if (DDCRowId="") {
		&sql(select DDC_RowId into :count from SQLUser.DHC_DocDiagnosCertificate where DDC_Adm_Dr=:EpisodeID and DDC_DiagnosIDStr=:DiagnosIDStr)
	}else {
		&sql(select DDC_RowId into :count from SQLUser.DHC_DocDiagnosCertificate where DDC_Adm_Dr=:EpisodeID and DDC_DiagnosIDStr=:DiagnosIDStr and DDC_RowId<>:DDCRowId)
	}
	Q:count>0 "repeat"
	k PLIST
	s PLIST(2)=EpisodeID
	s PLIST(3)=DiagnosIDStr
	s PLIST(4)=..%ZDH(DiagConfirmDate)
	s PLIST(5)=DaysOff
	s PLIST(6)=DocNotes
	if (DDCRowId="") {
		s PLIST(8)="UnP"
		s PLIST(9)=LogonUserID
		s PLIST(10)=..%SysDate()
		s PLIST(11)=..%SysTime()
		s PLIST(12)=$P(^PAADM(EpisodeID),"^",1) //PatientID
		&sql(insert into SQLUser.DHC_DocDiagnosCertificate values :PLIST())
	}else{
		&sql(update SQLUser.DHC_DocDiagnosCertificate values :PLIST() where DDC_RowId=:DDCRowId)
	}
	b //45
	Q SQLCODE
}

/// 获取诊断json
/// w ##class(web.DHCDocDiagnosCertificate).GetAdmDiagJson(3018)
ClassMethod GetAdmDiagJson(EpisodeID As %String) As %String
{
	s JsonObj=[]
	s MRADMID=$P(^PAADM(EpisodeID),"^",61)
	s rs=##class(%ResultSet).%New("web.DHCDocDiagnosEntryV8:DiagnosList")
	d rs.Execute(MRADMID)
	while rs.Next(){
		s MainMRDiagnoeRowId=rs.GetDataByName("MRDIAMRDIADR")
		continue:MainMRDiagnoeRowId'=""
		s DiagnosRowId=rs.GetDataByName("MRDIARowId")
		s MRDiagnosDate=rs.GetDataByName("DiagnosOnsetDate")
		s DiagnosDesc=##class(DHCDoc.Diagnos.Common).GetDiagDesc(DiagnosRowId)
		s DiagSubRowIdStr=""
		s sub=0 for{
			s sub=$o(^MR(MRADMID,"DIA",0,"Link",DiagnosRowId,sub)) Q:sub=""  d
			i DiagSubRowIdStr="" s DiagSubRowIdStr=MRADMID_"||"_sub
			e  s DiagSubRowIdStr=DiagSubRowIdStr_$C(1)_MRADMID_"||"_sub
		}
		s OneJson={}
		d OneJson.%Set("DiagnosDesc",DiagnosDesc)
		d OneJson.%Set("DiagnosRowId",DiagnosRowId)
		d OneJson.%Set("DiagSubRowIdStr",DiagSubRowIdStr)
		d OneJson.%Set("MRDiagnosDate",MRDiagnosDate)
		do JsonObj.%Push(OneJson,"")
	}
	s obj=##class(%Stream.GlobalCharacter).%New()
	do JsonObj.%ToJSON(obj)
	s JsonStr=""
	While 'obj.AtEnd { 
		s JsonStr=JsonStr_obj.ReadLine(,.sc,.eol)
	}
	Q JsonStr
}

Query GetDiagnosCertificateList(EpisodeID As %String) As websys.Query(ROWSPEC = "DDCRowId:%String,DDCDiagnosIDStr:%String,DiagnosDescStr:%String,DDCDiagConfirmDate:%String,DDCDaysOff:%String,DDCDocNotes:%String,DDCStatus:%String,DDCStatusDesc:%String")
{
}

ClassMethod GetDiagnosCertificateListExecute(ByRef qHandle As %Binary, EpisodeID As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCDocDiagnosCertificate","GetDiagnosCertificateList")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s DDCRowId=0
    for {
	    s DDCRowId=$o(^DHCDOCDiagnosCertificate("AdmDr",EpisodeID,DDCRowId)) Q:DDCRowId=""
	    s Data=$g(^DHCDOCDiagnosCertificate(DDCRowId))
	    s DDCStatus=$p(Data,"^",7)
	    continue:DDCStatus="U"
	    s DDCDiagnosIDStr=$p(Data,"^",2)
	    s DiagnosDescStr=""
	    for i=1:1:$l(DDCDiagnosIDStr,","){
		    s DiagnosRowId=$p(DDCDiagnosIDStr,",",i)
		    continue:DiagnosRowId=""
		    s DiagnosDesc=##class(DHCDoc.Diagnos.Common).GetDiagDesc(DiagnosRowId)
		    i DiagnosDescStr="" s DiagnosDescStr=DiagnosDesc
		    else  s DiagnosDescStr=DiagnosDescStr_","_DiagnosDesc
		}
	    s DDCDiagConfirmDate=..%ZD($p(Data,"^",3))
	    s DDCDaysOff=$p(Data,"^",4)
	    s DDCDocNotes=$p(Data,"^",5)
	    s DDCStatusDesc=$case(DDCStatus,"P":"已打印","UnP":"未打印","U":"已作废")
		s DDCStatusDesc=##class(websys.Translation).Get("dhcdoc.diagnoscertificate.csp",DDCStatusDesc)
	    Do OutputRow
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(DDCRowId,DDCDiagnosIDStr,DiagnosDescStr,DDCDiagConfirmDate,DDCDaysOff,DDCDocNotes,DDCStatus,DDCStatusDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

/// 
/// w ##class(web.DHCDocDiagnosCertificate).GetDiagCertificatePrintDataJson("",+$h,+$h)
ClassMethod GetDiagCertificatePrintDataJson(PatNo As %String = "", SearchStartDate As %String = "", SearchEndDate As %String = "", AdmLocId As %String = "", AdmDocId As %String = "") As %String
{
	s HospID=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId("")
	s SearchStartDate=..%ZDH(SearchStartDate)
	s SearchEndDate=..%ZDH(SearchEndDate)
	s SearchDate=$case(SearchStartDate,"":0,:(SearchStartDate-1))
	Set langid=..%LanguageID()
	/*
	^DHCDOCDiagnosCertificate(0)=1
	^DHCDOCDiagnosCertificate(1)="3018^3018||1,3018||2^65694^10^医生建议^^UnP^12175^65694^35290^12"
	^DHCDOCDiagnosCertificate("AddDate",65694,1)=""
	^DHCDOCDiagnosCertificate("AdmDr",3018,1)=""
	^DHCDOCDiagnosCertificate("PatAddDate",12,65694,1)=""
	*/
	k DDCDataList
	if (PatNo'="") s PatientID=$o(^PAPERi("PAPMI_PatNo",PatNo,""))
	if ($g(PatientID)) {
		for {
			s SearchDate=$o(^DHCDOCDiagnosCertificate("PatAddDate",PatientID,SearchDate)) Q:SearchDate=""
			s DDCRowId=0
			for {
				s DDCRowId=$o(^DHCDOCDiagnosCertificate("PatAddDate",PatientID,SearchDate,DDCRowId)) Q:DDCRowId=""
				s DDCAdmDr=$p(^DHCDOCDiagnosCertificate(DDCRowId),"^",1)
				continue:'$$CheckValid(DDCRowId)
				s DDCDataList(DDCAdmDr,DDCRowId)=1
			}
		}
	}else{
		for {
			s SearchDate=$o(^DHCDOCDiagnosCertificate("AddDate",SearchDate)) Q:SearchDate=""
			s DDCRowId=0
			for {
				s DDCRowId=$o(^DHCDOCDiagnosCertificate("AddDate",SearchDate,DDCRowId)) Q:DDCRowId=""
				s DDCAdmDr=$p(^DHCDOCDiagnosCertificate(DDCRowId),"^",1)
				continue:'$$CheckValid(DDCRowId)
				s DDCDataList(DDCAdmDr,DDCRowId)=1
			}
		}
	}
	s index=0
	s JsonObj=[]
	s Adm=0
	for {
		s Adm=$o(DDCDataList(Adm)) Q:Adm=""
		s oneAdmobj = ##class(%DynamicObject).%New() 
		s oneAdmobj.MyList= ##class(%DynamicArray).%New()
		s DDCRowId=0
		for {
			s DDCRowId=$o(DDCDataList(Adm,DDCRowId)) Q:DDCRowId=""
			s oneDDCDataJson=$$GetDDCData(DDCRowId)
			s index=index+1
			do oneDDCDataJson.%Set("index",index)
			d oneAdmobj.MyList.%Push(oneDDCDataJson)
		}
		s index=index+1
		s oneObj={}
		do oneObj.%Set("index",index)
		do oneObj.%Set("name",$$GetPatInfo(Adm,HospID,langid))
		do oneObj.%Set("children",oneAdmobj.MyList)
		do JsonObj.%Push(oneObj)
	}
	s JsonInfo=""
	s obj=##class(%Stream.GlobalCharacter).%New()
	do JsonObj.%ToJSON(obj)
	While 'obj.AtEnd { 
		s JsonInfo=JsonInfo_obj.ReadLine(,.sc,.eol)
	}
	q JsonInfo
GetDDCData(DDCRowId)
	s tmpDataJson={}
	s Data=$g(^DHCDOCDiagnosCertificate(DDCRowId))
    s DDCDiagnosIDStr=$p(Data,"^",2)
    s DiagnosDescStr=""
    for i=1:1:$l(DDCDiagnosIDStr,","){
	    s DiagnosRowId=$p(DDCDiagnosIDStr,",",i)
	    continue:DiagnosRowId=""
	    s DiagnosDesc=##class(DHCDoc.Diagnos.Common).GetDiagDesc(DiagnosRowId)
	    i DiagnosDescStr="" s DiagnosDescStr=DiagnosDesc
	    else  s DiagnosDescStr=DiagnosDescStr_","_DiagnosDesc
	}
    s DDCDiagConfirmDate=..%ZD($p(Data,"^",3))
    s DDCDaysOff=$p(Data,"^",4)
    s DDCDocNotes=$p(Data,"^",5)
    s DDCNotes=$p(Data,"^",6)
    s DDCStatus=$p(Data,"^",7)
    s DDCStatusDesc=$case(DDCStatus,"P":"已打印","UnP":"未打印","U":"已作废")
    s DDCStatusDesc=##class(websys.Translation).Get("dhcdoc.diagnoscertificate.print.csp",DDCStatusDesc)
    s DDCPatientDr=$p(Data,"^",11)
    s DDCCompany=$p(Data,"^",12)
    if DDCCompany="" s DDCCompany=$p($g(^PAPER(DDCPatientDr,"PER",4)),"^",18)
    do tmpDataJson.%Set("name","")
    do tmpDataJson.%Set("DDCRowId",DDCRowId)
    do tmpDataJson.%Set("DDCDiagnosIDStr",DDCDiagnosIDStr)
    do tmpDataJson.%Set("DiagnosDescStr",DiagnosDescStr)
    do tmpDataJson.%Set("DDCDiagConfirmDate",DDCDiagConfirmDate)
    do tmpDataJson.%Set("DDCDaysOff",DDCDaysOff)
    do tmpDataJson.%Set("DDCDocNotes",DDCDocNotes)
    do tmpDataJson.%Set("DDCStatus",DDCStatus)
    do tmpDataJson.%Set("DDCNotes",DDCNotes)
    do tmpDataJson.%Set("DDCStatusDesc",DDCStatusDesc)
    do tmpDataJson.%Set("DDCCompany",DDCCompany)
    Q tmpDataJson
GetPatInfo(EpisodeID,HospID,langid)
	s PatientID=$P(^PAADM(EpisodeID),"^",1)
 	s PatNo1=##Class(web.PAPatMas).GetRegistration(PatientID)
 	s PatName=$P($G(^PAPER(PatientID,"ALL")),"^",1)
 	s PatSexDr=$P($G(^PAPER(PatientID,"ALL")),"^",7)
 	if PatSexDr'="" s PatSex=$P($G(^CT("SEX",PatSexDr)),"^",2)
 	s PatSex=##class(User.CTSex).GetTranByDesc("CTSEXDesc",PatSex,langid)
	s PatAge=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.reg.GetPapmiAge",PatientID,"",HospID)
	s PAAdmDate=..%ZD($P($g(^PAADM(EpisodeID)),"^",6))_" "_..%ZT($P($g(^PAADM(EpisodeID)),"^",7),1)
	s AdmLocDr=$P($g(^PAADM(EpisodeID)),"^",4)
	s AdmLoc=$P($g(^CTLOC(AdmLocDr)),"^",2)
	s AdmLoc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",AdmLoc,langid)
	s PAAdmDoc=""
	s Doctor=$P($g(^PAADM(EpisodeID)),"^",9)
	If Doctor'="" Set PAAdmDoc=$P($g(^CTPCP(Doctor,1)),"^",2)
	Set PAAdmDoc= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",PAAdmDoc,langid)
	s TPAPMICardTypeDR=$p($g(^PAPER(PatientID,"PAT",3)),"^",7)
    s TPAPMICardType=$s(+$p($g(^PAPER(PatientID,"PAT",3)),"^",7)'=0:$p($g(^PAC("CARD",$p($g(^PAPER(PatientID,"PAT",3)),"^",7))),"^",2),1:"")
    Set TPAPMICardType= ##class(User.DHCCredType).GetTranByDesc("CRTDesc",TPAPMICardType,langid)
	s TPAPMIDVAnumber =$p($g(^PAPER(PatientID,"PAT",3)),"^",6)
 	Q PatName_" / "_$g(PatSex)_" / "_PatAge_##class(websys.Translation).Get("dhcdoc.diagnoscertificate.print.csp"," 登记号：")_PatNo1_##class(websys.Translation).Get("dhcdoc.diagnoscertificate.print.csp"," 证件类型：")_TPAPMICardType_##class(websys.Translation).Get("dhcdoc.diagnoscertificate.print.csp"," 证件号码：")_TPAPMIDVAnumber_" "_AdmLoc_" "_$g(PAAdmDoc)_" "_PAAdmDate
CheckValid(DDCRowId)
	s DDCAdmDr=$p(^DHCDOCDiagnosCertificate(DDCRowId),"^",1)
	s DDCStatus=$p(^DHCDOCDiagnosCertificate(DDCRowId),"^",7)
	Q:DDCStatus="U" 0
	s AdmLocDr=$P($g(^PAADM(DDCAdmDr)),"^",4)
	s AdmDoctorDr=$P($g(^PAADM(DDCAdmDr)),"^",9)
	Q:(AdmLocId'="")&&(AdmLocId'=AdmLocDr) 0
	Q:(AdmDocId'="")&&(AdmDocId'=AdmDoctorDr) 0
	Q:(HospID'=$p(^CTLOC(AdmLocDr),"^",22)) 0
	Q 1
}

ClassMethod GetPrintDDCJson(DDCDataJson As %String, ExpStr As %String) As %String
{
	s UserID=$p(ExpStr,"^",1)
	s JsonObj=[]
	k DDCDataArr
	d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(DDCDataJson,.DDCDataArr)
	s count=0
	for {
		s count=$o(DDCDataArr(count)) Q:count=""
		s DDCRowId=$G(DDCDataArr(count,"DDCRowId"))
		s DDCAdmDr=$p(^DHCDOCDiagnosCertificate(DDCRowId),"^",1)
		s AdmLocDr=$P($g(^PAADM(DDCAdmDr)),"^",4)
		s AdmLoc=$P($g(^CTLOC(AdmLocDr)),"^",2)
		s Doctor=$P($g(^PAADM(DDCAdmDr)),"^",9)
		If Doctor'="" s PAAdmDoc=$P($g(^CTPCP(Doctor,1)),"^",2)
		s PatientID=$P(^PAADM(DDCAdmDr),"^",1)
	 	s PatNo=##Class(web.PAPatMas).GetRegistration(PatientID)
	 	s PatName=$P($G(^PAPER(PatientID,"ALL")),"^",1)
	 	s PatSexDr=$P($G(^PAPER(PatientID,"ALL")),"^",7)
	 	if PatSexDr'="" s PatSex=$P($G(^CT("SEX",PatSexDr)),"^",2)
	 	s HospId=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(DDCAdmDr)
		s PatAge=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.reg.GetPapmiAge",PatientID,"",HospId)
		s DiagnosDesc=$G(DDCDataArr(count,"DiagnosDescStr"))
		k TmpDiagnosDescArr
	    D ##Class(web.DHCAPPExaRepCom).splitString(DiagnosDesc, "58", "10", .TmpDiagnosDescArr)  /// 拆分字符串
		D ##class(web.DHCAPPPrintCom).TrsTmpArrNew("DiagnosDesc", .TmpDiagnosDescArr)
		s DDCDiagConfirmDate=$G(DDCDataArr(count,"DDCDiagConfirmDate"))
	    s DDCDaysOff=$G(DDCDataArr(count,"DDCDaysOff"))
	    s DDCDocNotes=$G(DDCDataArr(count,"DDCDocNotes"))
	    k TmpDDCDocNotesArr
	    D ##Class(web.DHCAPPExaRepCom).splitString(DDCDocNotes, "58", "10", .TmpDDCDocNotesArr)  /// 拆分字符串
		D ##class(web.DHCAPPPrintCom).TrsTmpArrNew("DDCDocNotesArr", .TmpDDCDocNotesArr)
	    s DDCNotes=$G(DDCDataArr(count,"DDCNotes"))
	    k TmpDDCNotesArr
	    D ##Class(web.DHCAPPExaRepCom).splitString(DDCNotes, "58", "10", .TmpDDCNotesArr)  /// 拆分字符串
		D ##class(web.DHCAPPPrintCom).TrsTmpArrNew("DDCNotesArr", .TmpDDCNotesArr)
	    s DDCCompany=$G(DDCDataArr(count,"DDCCompany"))
	    s PrintDate=..%ZD(+$h)_" "_..%ZT(..%SysTime(),1)
		s DDCDaysRange=..%ZDH(DDCDiagConfirmDate)+DDCDaysOff-1
		s DDCDaysRange=DDCDiagConfirmDate_" 至" _..%ZD(DDCDaysRange)
		s OneJson={}
		s HospName=$p(^CT("HOSP",HospId),"^",2)
		d OneJson.%Set("HospName",HospName_"病情诊断证明书")
		d OneJson.%Set("AdmLoc",AdmLoc)
		d OneJson.%Set("PatNo",PatNo)
		d OneJson.%Set("PatName",PatName)
		d OneJson.%Set("PatSex",PatSex)
		d OneJson.%Set("PatAge",PatAge)
		d OneJson.%Set("DDCCompany",DDCCompany)
		//d OneJson.%Set("DiagnosDesc",DiagnosDesc)
		//d OneJson.%Set("DDCDocNotes",DDCDocNotes)
		s DDCDocNotesArrKey=$G(TmpDDCDocNotesArr("DDCDocNotesArrKey"))
	    s DDCDocNotesArrVal=$G(TmpDDCDocNotesArr("DDCDocNotesArrVal"))
		s DiagnosDescArrKey=$G(TmpDiagnosDescArr("DiagnosDescKey"))
		s DiagnosDescArrVal=$G(TmpDiagnosDescArr("DiagnosDescVal"))
		 for i=1:1:$l(DiagnosDescArrKey,$C(4)){
		    d OneJson.%Set($p(DiagnosDescArrKey,$C(4),i),$p(DiagnosDescArrVal,$C(4),i))
		}
	    for i=1:1:$l(DDCDocNotesArrKey,$C(4)){
		    d OneJson.%Set($p(DDCDocNotesArrKey,$C(4),i),$p(DDCDocNotesArrVal,$C(4),i))
		}
		d OneJson.%Set("DDCDaysOff",DDCDaysOff)
		d OneJson.%Set("DDCDaysRange",DDCDaysRange)
		//d OneJson.%Set("DDCNotes",DDCNotes)
		s DDCNotesArrKey=$G(TmpDDCNotesArr("DDCNotesArrKey"))
	    s DDCNotesArrVal=$G(TmpDDCNotesArr("DDCNotesArrVal"))
	    for i=1:1:$l(DDCNotesArrKey,$C(4)){
		    d OneJson.%Set($p(DDCNotesArrKey,$C(4),i),$p(DDCNotesArrVal,$C(4),i))
		}
		d OneJson.%Set("PAAdmDoc",PAAdmDoc)
		d OneJson.%Set("PrintDate",PrintDate)
		d ..UpdateDDCPrintData(DDCRowId,DDCNotes,DDCCompany)
		s PrintDataJson=""
		s obj=##class(%Stream.GlobalCharacter).%New()
		do OneJson.%ToJSON(obj)
		While 'obj.AtEnd { 
			s PrintDataJson=PrintDataJson_obj.ReadLine(,.sc,.eol)
		}
		s PrintDataJson=$replace(PrintDataJson,"""","'")
		s PrtSerialNumber=##Class(User.DHCDocDiagCertificatePrtSerial).InsertPrtSerial(DDCRowId,PrintDataJson,UserID)
		d OneJson.%Set("PrtSerialNumber",PrtSerialNumber)
		do JsonObj.%Push(OneJson,"")
	}
	s obj=##class(%Stream.GlobalCharacter).%New()
	do JsonObj.%ToJSON(obj)
	s JsonStr=""
	While 'obj.AtEnd { 
		s JsonStr=JsonStr_obj.ReadLine(,.sc,.eol)
	}
	Q JsonStr
}

ClassMethod UpdateDDCPrintData(DDCRowId As %String, DDCNotes As %String, DDCCompany As %String) As %String
{
	&sql(update SQLUser.DHC_DocDiagnosCertificate set DDC_Status="P",DDC_Notes=:DDCNotes,DDC_Company=:DDCCompany where DDC_RowId=:DDCRowId)
	Q SQLCODE
}

// ^DHCDOCDiagnosCertificate("AdmDr",3018,1)=""

ClassMethod UnuseDiagnosCertificate(EpisodeID As %String, DelMRDiagnosRowidStr As %String) As %String
{
	k DelMRDiagnosRowidArr
	for delIndex=1:1:$l(DelMRDiagnosRowidStr,"$"){
		s oneMRDiagnosRowid=$p(DelMRDiagnosRowidStr,"$",delIndex)
		continue:oneMRDiagnosRowid=""
		s DelMRDiagnosRowidArr(oneMRDiagnosRowid)=1
	}
	s DDCRowId=0
	for {
		s DDCRowId=$o(^DHCDOCDiagnosCertificate("AdmDr",EpisodeID,DDCRowId)) Q:DDCRowId=""
		s DDCStatus=$p($g(^DHCDOCDiagnosCertificate(DDCRowId)),"^",7)
		continue:(DDCStatus'="UnP")
    	s DDCDiagnosIDStr=$p($g(^DHCDOCDiagnosCertificate(DDCRowId)),"^",2)
    	for DDCIndex=1:1:$l(DDCDiagnosIDStr,","){
	    	s oneDDCDiagnosID=$p(DDCDiagnosIDStr,",",DDCIndex)
	    	continue:oneDDCDiagnosID=""
	    	if $d(DelMRDiagnosRowidArr(oneDDCDiagnosID)) {
		    	&sql(update SQLUser.DHC_DocDiagnosCertificate set DDC_Status="U" where DDC_RowId=:DDCRowId)
		    }
	    }
	}
	Q 0
}

/// 判断本次删除的诊断是否已在诊断证书上打印
/// w ##class(web.DHCDocDiagnosCertificate).CheckDiagnosCertificatePrint(3099,"3099||1^3099||3")
ClassMethod CheckDiagnosCertificatePrint(EpisodeID As %String, DelMRDiagnosRowidStr As %String)
{
	s PrintFlag="N"
	k DelMRDiagnosRowidArr
	for delIndex=1:1:$l(DelMRDiagnosRowidStr,"^"){
		s oneMRDiagnosRowid=$p(DelMRDiagnosRowidStr,"^",delIndex)
		continue:oneMRDiagnosRowid=""
		s DelMRDiagnosRowidArr(oneMRDiagnosRowid)=1
	}
	s DDCRowId=0
	for {
		s DDCRowId=$o(^DHCDOCDiagnosCertificate("AdmDr",EpisodeID,DDCRowId)) Q:DDCRowId=""
		s DDCStatus=$p($g(^DHCDOCDiagnosCertificate(DDCRowId)),"^",7)
		continue:(DDCStatus="U")
    	s DDCDiagnosIDStr=$p($g(^DHCDOCDiagnosCertificate(DDCRowId)),"^",2)
    	if (DDCStatus="P") {
	    	for DDCIndex=1:1:$l(DDCDiagnosIDStr,","){
		    	s oneDDCDiagnosID=$p(DDCDiagnosIDStr,",",DDCIndex)
		    	continue:oneDDCDiagnosID=""
		    	if $d(DelMRDiagnosRowidArr(oneDDCDiagnosID)) s PrintFlag="Y" Q 
		    }
	    }
	    Q:PrintFlag="Y"
	}
	Q PrintFlag
}

}
