/// CTOR: QP
/// DATE: 2020-09-16
/// DESC: 就诊记录
Class DHCDoc.GCPSW.BS.Adm Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2020-09-17
/// DESC: 查询就诊
/// IN  : 
/// OUT :    
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.GCPSW.BS.Adm","FindDocCurrentAdm",1)
Query FindDocCurrentAdm(PatientID = "", PatientNo = "") As %Query(ROWSPEC = "PatientID:%String,EpisodeID:%String,mradm:%String,PAPMINO:%String,PAPMIName:%String,PAPMIDOB:%String,PAPMISex:%String,PAAdmDate:%Date,PAAdmTime:%Time,PAAdmNo:%String,PAAdmDepCodeDR:%String,PAAdmDocCodeDR:%String,PAAdmType:%String,Hospital:%String,PAAdmWard:%String,PAAdmBed:%String,FinancialDischargeFlag:%String,MedicalDischargeFlag:%String,FinalDischargeFlag:%String,PAAdmReason:%String,DischargeDate:%String,Diagnosis:%String,Ord:%String,Select:%String,PAAdmStatus:%String,TPoliticalLevel:%String,TSecretLevel:%String,TAdmLocDr:%String")
{
}

ClassMethod FindDocCurrentAdmExecute(ByRef qHandle As %Binary, PatientID = "", PatientNo = "") As %Status
{
	/*Set LocID=%session.Get("LOGON.CTLOCID")
	Set UserID=%session.Get("LOGON.USERID")
	If LocID="" Quit $$$OK
	If UserID="" Quit $$$OK
	s LogonHospID=%session.Get("LOGON.HOSPID")
	//
 Set DocId=$p($g(^SSU("SSUSR",UserID)),"^",14)
 If $g(DocId)="" Quit $$$OK*/
	// 	
	Kill ^TMP("DHCDocWorkBench",$j)
	Set Count=0
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	//
	If $g(PatientID)'="" Do 
	.Set PAPMI=PatientID
	.Do OutPAPMI
	Else  Do
	.If ($g(PatientNo)'="") Do
	..Set PAPMI=$O(^PAPERi("PAPMI_PatNo",PatientNo,""))
	..Quit:$g(PAPMI)=""
	..Do OutPAPMI
	//Set ^TMP("DHCDocWorkBench",$j,tmpAdmDate,tmpAdmTime,Count)
	/*Set L1="" For  Set L1=$O(^TMP("DHCDocWorkBench",$j,L1)) Quit:L1=""  Do
	.Set ^CacheTemp(repid,ind)=^TMP("DHCDocWorkBench",$j,L1)
	.Set ind=ind+1 
	Set qHandle=$lb(0,repid,0)
	Kill ^TMP("DHCDocWorkBench",$j)
	Quit $$$OK*/
	Set L1="" For  Set L1=$O(^TMP("DHCDocWorkBench",$j,L1),-1) Quit:L1=""  Do
	.set L2="" for  set L2=$O(^TMP("DHCDocWorkBench",$j,L1,L2),-1) Quit:L2=""  Do
	..set L3=""  for  set L3=$O(^TMP("DHCDocWorkBench",$j,L1,L2,L3)) Quit:L3=""  Do
	...Set ^CacheTemp(repid,ind)=^TMP("DHCDocWorkBench",$j,L1,L2,L3)
	...Set ind=ind+1 
	Set qHandle=$lb(0,repid,0)
	Kill ^TMP("DHCDocWorkBench",$j)
	Quit $$$OK
	//
OutputRow
	Do ResetVariables
	//PatientID,EpisodeID,mradm
	Set PatientID=$P(^PAADM(PAAdm),"^",1)
	Set EpisodeID=PAAdm
	Set mradm=$P(^PAADM(PAAdm),"^",61)
	//PAPMINO,PAPMIName,PAPMIDOB,PAPMISex
	Set PAPMINO=$P(^PAPER(PatientID,"PAT",1),"^",1)
	Set PAPMIName=$P(^PAPER(PatientID,"ALL"),"^",1)
	Set PAPMIDOB=##class(websys.Conversions).DateLogicalToHtml($P(^PAPER(PatientID,"ALL"),"^",6)) //$ZD($P(^PAPER(PatientID,"ALL"),"^",6),3)
	Set Sex=$P(^PAPER(PatientID,"ALL"),"^",7)
	Set PAPMISex=$P($g(^CT("SEX",Sex)),"^",2)
	s PatEncryptLevel=""	//##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(PatientID,.ErrMsg)
	i PatEncryptLevel'="" {
		s TPoliticalLevel=$p(PatEncryptLevel,"^",2)
		s TSecretLevel=$p(PatEncryptLevel,"^",4)
	}
	//PAAdmDate,PAAdmTime,PAAdmNo,PAAdmDepCodeDR,PAAdmDocCodeDR,PAAdmType,Hospital,PAAdmWard,PAAdmBed
	Set PAAdmDate=##class(websys.Conversions).DateLogicalToHtml($P($g(^PAADM(PAAdm)),"^",6)) //$ZD($P($g(^PAADM(PAAdm)),"^",6),3)
	Set PAAdmTime=$ZT($P($g(^PAADM(PAAdm)),"^",7),3)
	//
	Set PAAdmNo=$P($g(^PAADM(PAAdm)),"^",81)
	Set Loc=$P($g(^PAADM(PAAdm)),"^",4)
	Set PAAdmDepCodeDR=$P($g(^CTLOC(Loc)),"^",2) s PAAdmDepCodeDR=##class(DHCDoc.GCPSW.COM.Func).LocDescFormate(PAAdmDepCodeDR)
	Set Doctor=$P($g(^PAADM(PAAdm)),"^",9)
	If Doctor'="" Set PAAdmDocCodeDR=$P($g(^CTPCP(Doctor,1)),"^",2)
	Else  Set PAAdmDocCodeDR=""
	Set PAAdmTypeGet=$P($g(^PAADM(PAAdm)),"^",2)
	s PAAdmType=PAAdmTypeGet
	If PAAdmType="I" Set PAAdmType="住院"
	If PAAdmType="O" Set PAAdmType="门诊"
	If PAAdmType="E" Set PAAdmType="急诊"	
	If PAAdmType="H" Set PAAdmType="体检"	
	Set Hosp=$P($g(^CTLOC(Loc)),"^",22)
	If Hosp'="" Set Hospital=$P($g(^CT("HOSP",Hosp)),"^",2)
	Set WardDr=$P($g(^PAADM(PAAdm)),"^",70)
	if WardDr'="" Set PAAdmWard=$P($g(^PAWARD(WardDr)),"^",2) s PAAdmWard=##class(DHCDoc.GCPSW.COM.Func).LocDescFormate(PAAdmWard)
	else  Set PAAdmWard=""
	Set BedId=$P($g(^PAADM(PAAdm)),"^",73)
	if BedId'="" Set PAAdmBed=$P($g(^PAWARD(+BedId,"BED",$P(BedId,"||",2))),"^",1)
	else  Set PAAdmBed="" 
	//FinancialDischargeFlag,MedicalDischargeFlag,FinalDischargeFlag,PAAdmReason,DischargeDate,Diagnosis
	Set FinancialDischargeFlag=$P($g(^PAADM(PAAdm)),"^",45)
	Set MedicalDischargeFlag=$P($g(^PAADM(PAAdm)),"^",63)
	Set PAAdmStatus=$P($g(^PAADM(PAAdm)),"^",20)
	if (PAAdmStatus'="") d
	.if PAAdmTypeGet="I"  d
	..if (PAAdmStatus="A") s PAAdmStatus="在院"
	..if (PAAdmStatus="C") s PAAdmStatus="退院"
	..if (PAAdmStatus="D") s PAAdmStatus="出院"
	..if (PAAdmStatus="P") s PAAdmStatus="预住院"
	.else  d
	..if (PAAdmStatus="A") s PAAdmStatus="正常"
	..if (PAAdmStatus="C") s PAAdmStatus="退号"
	..if (PAAdmStatus="D") s PAAdmStatus="出院"
	..if (PAAdmStatus="P") s PAAdmStatus="预住院"
	
	Set FinalDischargeFlag=$S($g(PAAdmStatus)="D":"Y",1:"N")
	Set AdmReason=$P($g(^PAADM(PAAdm,1)),"^",7)
	If AdmReason'="" Set PAAdmReason=$P($g(^PAC("ADMREA",AdmReason)),"^",2)
	Else  Set PAAdmReason=""
	Set DischargeDate=$P($g(^PAADM(PAAdm)),"^",17)
	i $g(^DHCDishChargeSet("Disch","ifGetDischgDateTimeByDoc"))="Y" d
	.s DischargeDate=$p($g(^PAADM(PAAdm,"DHC")),"^",29)
	if DischargeDate'="" s DischargeDate=##class(websys.Conversions).DateLogicalToHtml(DischargeDate) //$zd(DischargeDate,3)  ;shp
	If $g(mradm)'="" Set Diagnosis=..GetMRAdmDiagnosis(mradm)
	Else  Set Diagnosis=""
	//
	Set Ord=$O(^OEORD(0,"Adm",PAAdm,""))
	Set Select=""
	//
	Set Count=Count+1
	set Data=$LB(PatientID,EpisodeID,mradm,PAPMINO,PAPMIName,PAPMIDOB,PAPMISex,PAAdmDate,PAAdmTime,PAAdmNo,PAAdmDepCodeDR,PAAdmDocCodeDR,PAAdmType,Hospital,PAAdmWard,PAAdmBed,FinancialDischargeFlag,MedicalDischargeFlag,FinalDischargeFlag,PAAdmReason,DischargeDate,Diagnosis,Ord,Select,PAAdmStatus,TPoliticalLevel,TSecretLevel,Loc)
 	//Set ^TMP("DHCDocWorkBench",$j,Count)=Data
 	s tmpAdmDate=$P($g(^PAADM(PAAdm)),"^",6)
 	s tmpAdmTime=$P($g(^PAADM(PAAdm)),"^",7)
 	Set ^TMP("DHCDocWorkBench",$j,tmpAdmDate,tmpAdmTime,Count)=Data
	Quit
ResetVariables
	///Set (repid)=0
	Set (PatientID,EpisodeID,mradm,PAPMINO,PAPMIName,PAPMIDOB,PAPMISex,PAAdmDate,PAAdmTime,PAAdmNo,PAAdmDepCodeDR,PAAdmDocCodeDR,PAAdmType,Hospital,PAAdmWard,PAAdmBed,FinancialDischargeFlag,MedicalDischargeFlag,FinalDischargeFlag,PAAdmReason,DischargeDate,Diagnosis,Ord,Select,PAAdmStatus,TPoliticalLevel,TSecretLevel)=""
	Quit
OutPAPMI
	Set AdmType=""
	For  Set AdmType=$O(^PAPERdr(PAPMI,"ADM",AdmType)) Quit:AdmType=""  Do
	.Set PAAdm=""
	.For  Set PAAdm=$O(^PAPERdr(PAPMI,"ADM",AdmType,PAAdm)) Quit:PAAdm=""  Do
	..s DeptDr=$P($g(^PAADM(PAAdm)),"^",4)
	..s CTLocHospDr=$p(^CTLOC(DeptDr),"^",22)
	..;q:(LogonHospID'="")&&(CTLocHospDr'=LogonHospID)
	..Do OutputRow
	Quit
}

ClassMethod FindDocCurrentAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDocCurrentAdmExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 //
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod FindDocCurrentAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDocCurrentAdmExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// w ##class(DHCDoc.GCPSW.BS.Adm).GetMRAdmDiagnosis(27113722)
ClassMethod GetMRAdmDiagnosis(MRAdm As %String) As %String
{
 Quit:$g(MRAdm)="" ""
 Set DiagStr=""
 Set Diag=0
 For  Set Diag=$O(^MR(MRAdm,"DIA",Diag)) Quit:Diag=""  Do
 .Set DiagID=$P($g(^MR(MRAdm,"DIA",Diag)),"^",1)
 .//Quit:$g(DiagID)=""
 .i $g(DiagID)'="" d 
 ..Set DiagDesc=$P($g(^MRC("ID",DiagID)),"^",2)
 ..If DiagDesc["-" Set DiagDesc=$P(DiagDesc,"_",2)
 .e  d
 ..s DiagDesc=$g(^MR(MRAdm,"DIA",Diag,"DES",1))
 .If DiagStr="" Set DiagStr=DiagDesc
 .Else  Set DiagStr=DiagStr_","_DiagDesc
 .;b ;001
 Quit DiagStr
}

/// CTOR: QP
/// DATE: 2020-09-17
/// DESC: 获取患者最后一次就诊
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.BS.Adm).GetLastAdmInfo("1")
ClassMethod GetLastAdmInfo(PAPMI = "")
{
	s mRtn=""
	k MListArr
	s AdmType=""
	f  s AdmType=$O(^PAPERdr(PAPMI,"ADM",AdmType)) Quit:AdmType=""  Do
	.s PAAdm=""
	.f  s PAAdm=$O(^PAPERdr(PAPMI,"ADM",AdmType,PAAdm)) Quit:PAAdm=""  Do
	..s DeptDr=$P($g(^PAADM(PAAdm)),"^",4)
	..s tmpAdmDate=$P($g(^PAADM(PAAdm)),"^",6)
 	..s tmpAdmTime=$P($g(^PAADM(PAAdm)),"^",7)
 	..s Doctor=$P($g(^PAADM(PAAdm)),"^",9)
 	..s MListArr(tmpAdmDate,tmpAdmTime)=DeptDr_"^"_Doctor
 	
 	s tmpAdmDate=$o(MListArr(""),-1)
 	q:tmpAdmDate="" ""
 	s tmpAdmTime=$o(MListArr(tmpAdmDate,""),-1)
 	q:tmpAdmTime="" ""
 	s mRtn=tmpAdmDate_"^"_tmpAdmTime_"^"_$g(MListArr(tmpAdmDate,tmpAdmTime))
 	
 	k MListArr
 	
 	Q mRtn
}

}
