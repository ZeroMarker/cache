Class web.DHCDocIPBookPreAditu Extends DHCDoc.Util.RegisteredObject
{

Query PrePatientList(userID As %String, locID As %String, PatNo As %String, PatientName As %String, masterType As %String, DocType As %String, NurseType As %String, CashType As %String, HospID) As %Query(ROWSPEC = "PatientID,EpisodeID,mradm,PAPMINO,PAPMIName,PAPMISex,PAPMIAge,PAPMIDOB,Diagnosis,Exam1,Exam2,Exam3,Lab1,Lab2,Lab3,DocAduit,DocActive,DocRemark,DocReason,NurseAduit,NurseActive,NurseRemark,NurseReason,NurseBed,NurseBedDate,warddr,admloc")
{
}

// d ##class(%ResultSet).RunQuery("web.DHCDocIPBookPreAditu","PrePatientList",12177,114,"","","Nurse","","","")

ClassMethod PrePatientListExecute(ByRef QHandle As %Binary, userID As %String, locID As %String, PatNo As %String, PatientName As %String, masterType As %String, DocType As %String, NurseType As %String, CashType As %String, HospID) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s QHandle=$lb(0,repid,0)
	s ^tempqujian("PrePatientList")=userID_","_locID_","_PatNo_","_PatientName_","_masterType_","_DocType_","_NurseType_","_CashType _","_HospID
	s AllowLoc=##class(DHCDoc.DHCDocConfig.IPBook).GetDepConfigData("NeedtoPre",HospID)
	if (masterType="Doc"){
		s paadmdr=0
		f {
			s paadmdr=$O(^PAADMi("PAADM_VisitStatus","P",paadmdr)) 
			Q:((paadmdr=""))  
			s admloc=$P(^PAADM(paadmdr),"^",4)
			continue:(("^"_AllowLoc_"^")'[("^"_admloc_"^"))
			Continue:admloc'=locID
			s patid=$P(^PAADM(paadmdr),"^",1)
			s name=$P(^PAPER(patid,"ALL"),"^",1)
			Continue:(PatientName'="")&(PatientName'=$E(name,1,$L(PatientName)))
			s mradm=$P(^PAADM(paadmdr),"^",61)
			s papmino=$P(^PAPER(patid,"PAT",1),"^",1)
			Continue:(PatNo'="")&(PatNo'=papmino)
			d OutPutPrePatientList
		}
	}elseif(masterType="Nurse"){
		s WardStr=""
		Set WardStr=$O(^PAWARD(0,"WARD_LocationDR",locID,""))
		Set LocLink=""
		For {
			 Set LocLink=$O(^CTLOC(locID,"LINK",LocLink)) 
			 Quit:LocLink=""  
			 Set LocItem=$P($G(^CTLOC(locID,"LINK",LocLink)),"^",1)
			 Set LocEmerType=$P($G(^CTLOC(LocItem)),"^",13)
			 Set EmerWard=$O(^PAWARD(0,"WARD_LocationDR",LocItem,""))
			 Continue:EmerWard=""
			 If WardStr="" Set WardStr=EmerWard
			 Else  Set WardStr=WardStr_"^"_EmerWard	
		}
		s paadmdr=0
		For{
			s paadmdr=$O(^PAADMi("PAADM_VisitStatus","P",paadmdr)) 
			Q:((paadmdr="")) 
			s admloc=$P(^PAADM(paadmdr),"^",4)
			continue:(("^"_AllowLoc_"^")'[("^"_admloc_"^"))
			s patid=$P(^PAADM(paadmdr),"^",1)
			s PAPMIName=$P(^PAPER(patid,"ALL"),"^",1)
			Continue:(PatientName'="")&(PatientName'=$E(PAPMIName,1,$L(PatientName)))
			s mradm=$P(^PAADM(paadmdr),"^",61)
			s PAPMINO=$P(^PAPER(patid,"PAT",1),"^",1)
			Continue:(PatNo'="")&(PatNo'=PAPMINO)
			s warddr=$P($g(^PAADM(paadmdr)),"^",70)
			Continue:(("^"_WardStr_"^")'[("^"_warddr_"^"))
			d OutPutPrePatientList
		} 
	}elseif (masterType="Cash"){
		s paadmdr=0
		For{
			s paadmdr=$O(^PAADMi("PAADM_VisitStatus","P",paadmdr)) 
			Q:((paadmdr="")) 
			s admloc=$P(^PAADM(paadmdr),"^",4)
			continue:(("^"_AllowLoc_"^")'[("^"_admloc_"^"))
			s patid=$P(^PAADM(paadmdr),"^",1)
			s PAPMIName=$P(^PAPER(patid,"ALL"),"^",1)
			Continue:(PatientName'="")&(PatientName'=$E(PAPMIName,1,$L(PatientName)))
			s mradm=$P(^PAADM(paadmdr),"^",61)
			s PAPMINO=$P(^PAPER(patid,"PAT",1),"^",1)
			Continue:(PatNo'="")&(PatNo'=PAPMINO)
			d OutPutPrePatientList
		}
	}
	s QHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutPrePatientList
	Set langid=..%LanguageID()
	s patid=$P(^PAADM(paadmdr),"^",1)
	s PAPMIName=$P(^PAPER(patid,"ALL"),"^",1)
	s mradm=$P(^PAADM(paadmdr),"^",61)
	s PAPMINO=$P(^PAPER(patid,"PAT",1),"^",1)
	s sexdr=$P(^PAPER(patid,"ALL"),"^",7)
	s AdmDepHospId=$p(^CTLOC(locID),"^",22)
	s admloc=$P(^PAADM(paadmdr),"^",4)
	s PAPMISex=""
	s:sexdr'="" PAPMISex=$P($g(^CT("SEX",sexdr)),"^",2)
	s PAPMISex=##class(User.CTSex).GetTranByDesc("CTSEXDesc",PAPMISex,langid)
	s PAPMIDOB=$P($g(^PAPER(patid,"ALL")),"^",6)
	s PAPMIDOB=##class(EMRservice.Tools.Tool).GetHISStandardDateTimeFormat("ChangeToFormat","Date",PAPMIDOB)
	s PAPMIAge=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.reg.GetPapmiAge",patid,paadmdr,AdmDepHospId)
	s admdate=$p($g(^PAADM(paadmdr)),"^",6)
	s admdate=##class(EMRservice.Tools.Tool).GetHISStandardDateTimeFormat("ChangeToFormat","Date",admdate)
	s admtime=$p($g(^PAADM(paadmdr)),"^",7)
	s admtime=##class(EMRservice.Tools.Tool).GetHISStandardDateTimeFormat("ChangeToFormat","Time",admtime)
	s ward=""
	s warddr=$P($g(^PAADM(paadmdr)),"^",70)
	if warddr'=""  d
	.s ward = $P($g(^PAWARD(warddr)),"^",2)
	.s ward=##class(User.PACWard).GetTranByDesc("WARDDesc",ward,langid)
	.s:ward["-" ward = $P(ward,"-",2)
	s Diagnosis = ##class(web.DHCDocInPatientList).GetMRAdmDiagnosis(mradm,";") //##class(EMRservice.HISInterface.PatientInfoAssist).DiagnosInfo(paadmdr
	/*检查数量*/
	s EpisodeID=paadmdr
	s UserCode=$p(^SSU("SSUSR",userID),"^",1)
	s (Exam1,Exam2,Exam3)=0
	s rset=##Class(%ResultSet).%New("web.DHCAPPPisInterface.QryPatExaList")
	If rset.QueryIsValid() {
		Set Status=rset.Execute(EpisodeID,UserCode)
		If 'Status Quit
		Set columns = rset.GetColumnCount()
		if (columns=0) Quit
		While (rset.Next()) {
			s ItmStatus=rset.GetData(1)
			if (ItmStatus="申请"){
				s Exam1=Exam1+1
			}elseif (ItmStatus="报告"){
				s Exam3=Exam3+1
			}else{
				s Exam2=Exam2+1
			}
		}
	}
	s labrset=##Class(LabService.TSResult).GetSomeQtyInfoByAdmNo(EpisodeID)
	s Lab1=$P(labrset,"^",1)
	s Lab2=$P(labrset,"^",2)
	s Lab3=$P(labrset,"^",3)
	s DocAgreeStr=..ShowDocAgree(EpisodeID)
	s DocAduit=$P(DocAgreeStr,$C(1),2)
	s DocActive=""
	if ($P(DocAgreeStr,$C(1),3)="Y") s DocActive="通过"
	if ($P(DocAgreeStr,$C(1),3)="N") s DocActive="不通过"
	s DocRemark=$P(DocAgreeStr,$C(1),6)
	s DocReason=$P(DocAgreeStr,$C(1),7)
	if (DocType'=""){
		if (DocType=1){
			q:DocAgreeStr'="" $$$OK
		}elseif (DocType=2){
			if ((Lab3'=0)||(Exam3'=0))&&((Lab1=0)&&(Lab2=0)&&(Exam1=0)&&(Exam2=0)&&(DocAgreeStr="")){
			}else{
				Quit $$$OK 
			}
		}elseif (DocType=3){
			if ((Lab3'=0)||(Exam3'=0))&&(Lab1=0)&&(Lab2=0)&&(Exam1=0)&&(Exam2=0)&&(DocAgreeStr=""){
				Quit $$$OK
			}elseif (Lab3=0)&&(Exam3=0)&&(Lab1=0)&&(Lab2=0)&&(Exam1=0)&&(Exam2=0)&&(DocAgreeStr=""){
				Quit $$$OK
			}else{
				if (DocAgreeStr'="") Quit $$$OK
			}
		}elseif (DocType=4){
			q:DocAgreeStr="" $$$OK
		}elseif (DocType=5){}
	}
	s NurseAgreeStr=..ShowNurseAgree(EpisodeID)
	s NurseAduit=$P(NurseAgreeStr,$C(1),2)
	s NurseActive=""
	if ($P(NurseAgreeStr,$C(1),3)="Y") s NurseActive="通过"
	if ($P(NurseAgreeStr,$C(1),3)="N") s NurseActive="不通过"
	s NurseRemark=$P(NurseAgreeStr,$C(1),6)
	s NurseReason=$P(NurseAgreeStr,$C(1),7)
	s NurseBed=$P(NurseAgreeStr,$C(1),10)
	s NurseBedDate=$P(NurseAgreeStr,$C(1),8)
	if (NurseType'=""){
		if (NurseType=1){
			if (DocAgreeStr="") q $$$OK
			if (DocActive="不通过") q $$$OK
			if (NurseAgreeStr'="") q $$$OK
		}elseif (NurseType=2){
			if (DocAgreeStr'="") q $$$OK
		}elseif (NurseType=3){
			if ((DocAgreeStr="")||(NurseAgreeStr="")) q $$$OK
		}
	}
	if (CashType'=""){
		if (CashType=1){
			if ((DocAgreeStr="")||(DocActive="不通过")||(NurseAgreeStr="") ||(NurseActive="不通过") ) q $$$OK
		}elseif (CashType=2){
			if (DocAgreeStr="") q $$$OK
			if (DocActive="通过")&&((NurseAgreeStr="")||(NurseActive="通过"))  q $$$OK
		}elseif (CashType=3){
			if ((DocAgreeStr="")||(NurseAgreeStr="")) q $$$OK
		}
	}	
	s DocActive=##class(websys.Translation).Get("ipbook.preaduit.hui.csp",DocActive)
	s NurseAgreeStr=##class(websys.Translation).Get("ipbook.preaduit.hui.csp",NurseAgreeStr)
	s ^CacheTemp(repid,ind)=$lb(patid,paadmdr,mradm,PAPMINO,PAPMIName,PAPMISex,PAPMIAge,PAPMIDOB,Diagnosis,Exam1,Exam2,Exam3,Lab1,Lab2,Lab3,DocAduit,DocActive,DocRemark,DocReason,NurseAduit,NurseActive,NurseRemark,NurseReason,NurseBed,NurseBedDate,warddr,admloc)
	s ind=ind+1
	Quit $$$OK
}

ClassMethod PrePatientListClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = PrePatientListExecute ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod PrePatientListFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PrePatientListExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 保存医生审核
ClassMethod SaveDocAgree(EpisodeID, AdituDoc, Active, Reason = "", ReMark)
{
	q:EpisodeID="" ""
	s RowID=$O(^DHCDocIPBookPreAditui("INAdm",EpisodeID,0))
	s NowDate=..%SysDate()
	s NowTime=..%SysTime()
	s rtn=0
	if (RowID=""){
		&SQL(insert into SQLUser.DHCDocIPBookPreAditu(IPBookPreAdituINAdm,IPBookPreAdituDoc,IPBookPreAdituDocActive,IPBookPreAdituDocDate,
		IPBookPreAdituDocTime,IPBookPreAdituDocRemark,IPBookPreAdituDocReason) 
		Values(:EpisodeID,:AdituDoc,:Active,:NowDate,:NowTime,:ReMark,:Reason) )	
		s rtn=SQLCODE
	}else{
		&SQL(Update SQLUser.DHCDocIPBookPreAditu set IPBookPreAdituINAdm=:EpisodeID,IPBookPreAdituDoc=:AdituDoc,
		IPBookPreAdituDocActive=:Active,IPBookPreAdituDocDate=:NowDate,
		IPBookPreAdituDocTime=:NowTime,IPBookPreAdituDocRemark=:ReMark,
		IPBookPreAdituDocReason=:Reason
		 where RowID=:RowID)
		s rtn=SQLCODE
	}
	q rtn
}

/// 展示医生审核
/// w ##class(web.DHCDocIPBookPreAditu).ShowDocAgree(79)
ClassMethod ShowDocAgree(EpisodeID)
{
	Set langid=..%LanguageID()
	s RowID=$O(^DHCDocIPBookPreAditui("INAdm",EpisodeID,0))
	if RowID="" q ""
	s UserID=$P(^DHCDocIPBookPreAditu(RowID),"^",3)
	s UserDesc=$p($g(^SSU("SSUSR",UserID)),"^",2)  
	s UserDesc =##class(User.SSUser).GetTranByDesc("SSUSRName",UserDesc,langid)
	s Active=$P(^DHCDocIPBookPreAditu(RowID),"^",4)
	s Date=$P(^DHCDocIPBookPreAditu(RowID),"^",5)
	s Date=..%ZD(Date)
	s Time=$P(^DHCDocIPBookPreAditu(RowID),"^",6)
	s Time=##Class(websys.Conversions).TimeLogicalToHtml(Time)
	s ReMark=$P(^DHCDocIPBookPreAditu(RowID),"^",7)
	s Reason=$P(^DHCDocIPBookPreAditu(RowID),"^",8)
	b ;093
	s rtn=UserID_$C(1)_UserDesc_$C(1)_Active_$C(1)_Date_$C(1)_Time_$C(1)_ReMark_$C(1)_Reason
	q rtn
}

/// 批量医生审核
ClassMethod SaveDocAgreeMulit(EpisodeStr, AdituDoc, Active, Reason = "", ReMark)
{
	q:EpisodeStr="" ""
	s rtn=0
	for i=1:1:$L(EpisodeStr,"^"){
		s EpisodeID=$P(EpisodeStr,"^",i)
		s rtn=..SaveDocAgree(EpisodeID, AdituDoc, Active, Reason, ReMark)
		if rtn'=0 q
	}
	q rtn
}

/// 保存护士审核
ClassMethod SaveNurseAgree(EpisodeID, AdituNurse, Active, Reason = "", ReMark, BedID, PreInDate)
{
	q:EpisodeID="" ""
	s RowID=$O(^DHCDocIPBookPreAditui("INAdm",EpisodeID,0))
	s NowDate=..%SysDate()
	s NowTime=..%SysTime()
	i PreInDate'="" s PreInDate=..%ZDH(PreInDate) 
	s rtn=0
	if (RowID=""){
		q "请先医生审核"
		&SQL(insert into SQLUser.DHCDocIPBookPreAditu(IPBookPreAdituNurse,IPBookPreAdituNurseActive,IPBookPreAdituNurseDate,
		IPBookPreAdituNurseTime,IPBookPreAdituNurseRemark,IPBookPreAdituNurseReason,
		IPBookPreAdituInDate,IPBookPreAdituInBed) 
		Values(:AdituNurse,:Active,:NowDate,:NowTime,:ReMark,:Reason,:PreInDate,:BedID) )	
		s rtn=SQLCODE
	}else{
		if (($P(^DHCDocIPBookPreAditu(RowID),"^",4)="")||($P(^DHCDocIPBookPreAditu(RowID),"^",4)="N")){
			q "需要医生审核通过,才可以护士审批！"
		}
		&SQL(Update SQLUser.DHCDocIPBookPreAditu set IPBookPreAdituNurse=:AdituNurse,
		IPBookPreAdituNurseActive=:Active,IPBookPreAdituNurseDate=:NowDate,
		IPBookPreAdituNurseTime=:NowTime,IPBookPreAdituNurseRemark=:ReMark,
		IPBookPreAdituNurseReason=:Reason,
		IPBookPreAdituInDate=:PreInDate,IPBookPreAdituInBed=:BedID
		 where RowID=:RowID)
		s rtn=SQLCODE
	}
	q rtn
}

/// 展示护士审核
ClassMethod ShowNurseAgree(EpisodeID)
{
	Set langid=..%LanguageID()
	s RowID=$O(^DHCDocIPBookPreAditui("INAdm",EpisodeID,0))
	if RowID="" q ""
	s UserID=$P(^DHCDocIPBookPreAditu(RowID),"^",9)
	if UserID="" q ""
	s UserDesc=$p($g(^SSU("SSUSR",UserID)),"^",2)  
	 s UserDesc =##class(User.SSUser).GetTranByDesc("SSUSRName",UserDesc,langid)
	s Active=$P(^DHCDocIPBookPreAditu(RowID),"^",10)
	s Date=$P(^DHCDocIPBookPreAditu(RowID),"^",11)
	if Date'="" s Date=..%ZD(Date)
	s Time=$P(^DHCDocIPBookPreAditu(RowID),"^",12)
	if Time'="" s Time=##Class(websys.Conversions).TimeLogicalToHtml(Time)
	s ReMark=$P(^DHCDocIPBookPreAditu(RowID),"^",13)
	s Reason=$P(^DHCDocIPBookPreAditu(RowID),"^",14)
	s PreInDate=$P(^DHCDocIPBookPreAditu(RowID),"^",15)
	if PreInDate'="" s PreInDate=..%ZD(PreInDate)
	s BedID=$P(^DHCDocIPBookPreAditu(RowID),"^",16)
	s BedDesc=""
	if (BedID'="") s BedDesc=$P(^PAWARD(+BedID,"BED",$P(BedID,"||",2)),"^",1)_"床"
	s rtn=UserID_$C(1)_UserDesc_$C(1)_Active_$C(1)_Date_$C(1)_Time_$C(1)_ReMark_$C(1)_Reason_$C(1)_PreInDate_$C(1)_BedID_$C(1)_BedDesc
	q rtn
}

/// 批量护士审核
ClassMethod SaveNurseAgreeMulit(EpisodeStr, AdituNurse, Active, Reason = "", ReMark, BedID, PreInDate)
{
	q:EpisodeStr="" ""
	s rtn=0
	for i=1:1:$L(EpisodeStr,"^"){
		s EpisodeID=$P(EpisodeStr,"^",i)
		s rtn=..SaveNurseAgree(EpisodeID, AdituNurse, Active, Reason, ReMark, BedID, PreInDate)
		if rtn'=0 q
	}
	q rtn
}

/// w ##class(web.DHCDocIPBookPreAditu).GetLoacBed(132)
ClassMethod GetLoacBed(LocID)
{
	s obj=[]
	Set WardStr=$O(^PAWARD(0,"WARD_LocationDR",LocID,""))
	s BedID="0"
	for{
		s BedID=$O(^PAWARD(+WardStr,"BED",BedID))
		q:BedID=""
		s BEDRcFlag=$p(^PAWARD(+WardStr,"BED",BedID),"^",4)
		continue:BEDRcFlag'="Y"
		s BEDDateFrom=$p(^PAWARD(+WardStr,"BED",BedID),"^",21)
		continue:(BEDDateFrom'="")&&(BEDDateFrom>+$h)
		s BEDDateTo=$p(^PAWARD(+WardStr,"BED",BedID),"^",22)
		continue:(BEDDateTo'="")&&(BEDDateTo<=..%SysDate())
		s oneobj={}
		s oneobj.id=+WardStr_"||"_BedID
		s oneobj.desc=$P(^PAWARD(+WardStr,"BED",BedID),"^",1)_"床"
		d obj.%Push(oneobj)
	}
	Q obj.%ToJSON()
}

}
