Class web.DHCAdmOrderTree Extends DHCDoc.Util.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod FindDocCurrentAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDocCurrentAdmExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod FindDocCurrentAdmExecute(ByRef qHandle As %Binary, PatientID As %String, PatientNo As %String) As %Status
{
	Set LocID=%session.Get("LOGON.CTLOCID")
	Set UserID=%session.Get("LOGON.USERID")
	If LocID="" Quit $$$OK
	If UserID="" Quit $$$OK
	s LogonHospID=%session.Get("LOGON.HOSPID")
	//
 Set DocId=$p($g(^SSU("SSUSR",UserID)),"^",14)
 If $g(DocId)="" Quit $$$OK
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
OutPAPMI
	Set AdmType=""
	For  Set AdmType=$O(^PAPERdr(PAPMI,"ADM",AdmType)) Quit:AdmType=""  Do
	.Set PAAdm=""
	.For  Set PAAdm=$O(^PAPERdr(PAPMI,"ADM",AdmType,PAAdm)) Quit:PAAdm=""  Do
	..s DeptDr=$P($g(^PAADM(PAAdm)),"^",4)
	..s CTLocHospDr=$p(^CTLOC(DeptDr),"^",22)
	..q:(LogonHospID'="")&&(CTLocHospDr'=LogonHospID)
	..Do OutputRow
	Quit
OutputRow
	Do ResetVariables
	//PatientID,EpisodeID,mradm
	Set PatientID=$P(^PAADM(PAAdm),"^",1)
	Set EpisodeID=PAAdm
	Set mradm=$P(^PAADM(PAAdm),"^",61)
	//PAPMINO,PAPMIName,PAPMIDOB,PAPMISex
	Set PAPMINO=$P(^PAPER(PatientID,"PAT",1),"^",1)
	Set PAPMIName=$P(^PAPER(PatientID,"ALL"),"^",1)
	Set PAPMIDOB=..%ZD($P(^PAPER(PatientID,"ALL"),"^",6)) //$ZD($P(^PAPER(PatientID,"ALL"),"^",6),3)
	Set Sex=$P(^PAPER(PatientID,"ALL"),"^",7)
	Set PAPMISex=$P($g(^CT("SEX",Sex)),"^",2)
	set PAPMISex=##class(DHCDoc.Common.Translate).GetTransSex(PAPMISex)
	s PatEncryptLevel=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(PatientID,.ErrMsg)
	i PatEncryptLevel'="" {
		s TPoliticalLevel=$p(PatEncryptLevel,"^",2)
		s TSecretLevel=$p(PatEncryptLevel,"^",4)
	}
	//PAAdmDate,PAAdmTime,PAAdmNo,PAAdmDepCodeDR,PAAdmDocCodeDR,PAAdmType,Hospital,PAAdmWard,PAAdmBed
	Set PAAdmDate=..%ZD($P($g(^PAADM(PAAdm)),"^",6)) //$ZD($P($g(^PAADM(PAAdm)),"^",6),3)
	Set PAAdmTime=..%ZT($P($g(^PAADM(PAAdm)),"^",7),3)
	//
	Set PAAdmNo=$P($g(^PAADM(PAAdm)),"^",81)
	Set Loc=$P($g(^PAADM(PAAdm)),"^",4)
	Set PAAdmDepCodeDR=$P($g(^CTLOC(Loc)),"^",2)
	set PAAdmDepCodeDR=##class(DHCDoc.Common.Translate).GetTransLoc(PAAdmDepCodeDR)
	Set PAAdmDepCodeDR=##class(web.DHCOPAdmReg).LocDescFormate(PAAdmDepCodeDR)
	Set Doctor=$P($g(^PAADM(PAAdm)),"^",9)
	If Doctor'="" Set PAAdmDocCodeDR=$P($g(^CTPCP(Doctor,1)),"^",2)
	Else  Set PAAdmDocCodeDR=""
	set PAAdmDocCodeDR=##class(DHCDoc.Common.Translate).GetTransDoc(PAAdmDocCodeDR)
	Set PAAdmTypeGet=$P($g(^PAADM(PAAdm)),"^",2)
	set PAAdmType=##class(DHCDoc.Common.Translate).GetTransAdmType(PAAdm,"doc.admlistquery.hui.csp")
	set Hospital=""
	Set Hosp=$P($g(^CTLOC(Loc)),"^",22)
	If Hosp'="" Set Hospital=$P($g(^CT("HOSP",Hosp)),"^",2)
	set Hospital=##class(DHCDoc.Common.Translate).GetTransHosp(Hospital)
	Set WardDr=$P($g(^PAADM(PAAdm)),"^",70)
	if WardDr'="" Set PAAdmWard=$P($g(^PAWARD(WardDr)),"^",2)
	else  Set PAAdmWard=""
	set PAAdmWard=##class(DHCDoc.Common.Translate).GetTransWard(PAAdmWard)
	set PAAdmWard=##class(web.DHCOPAdmReg).LocDescFormate(PAAdmWard)
	Set BedId=$P($g(^PAADM(PAAdm)),"^",73)
	if BedId'="" Set PAAdmBed=$P($g(^PAWARD(+BedId,"BED",$P(BedId,"||",2))),"^",1)
	else  Set PAAdmBed="" 
	//FinancialDischargeFlag,MedicalDischargeFlag,FinalDischargeFlag,PAAdmReason,DischargeDate,Diagnosis
	Set FinancialDischargeFlag=$P($g(^PAADM(PAAdm)),"^",45)
	Set MedicalDischargeFlag=$P($g(^PAADM(PAAdm)),"^",63)
	Set PAAdmStatus=$P($g(^PAADM(PAAdm)),"^",20)
	if (PAAdmStatus'="") d
	.if PAAdmTypeGet="I"  d
	..s PAAdmStatus=$case(PAAdmStatus,"A":"在院","C":"退院","D":"出院","P":"预住院",:"其他")
	.else  d
	..s PAAdmStatus=$case(PAAdmStatus,"A":"正常","C":"退号","D":"出院",:"其他")
	set PAAdmStatus=##class(DHCDoc.Common.Translate).GetTransAdmStat(PAAdm,"doc.admlistquery.hui.csp")
	
	Set FinalDischargeFlag=$S($g(PAAdmStatus)="D":"Y",1:"N")
	Set AdmReason=$P($g(^PAADM(PAAdm,1)),"^",7)
	If AdmReason'="" Set PAAdmReason=$P($g(^PAC("ADMREA",AdmReason)),"^",2)
	Else  Set PAAdmReason=""
	set PAAdmReason=##class(DHCDoc.Common.Translate).GetTransAdmReason(PAAdmReason)
	Set DischargeDate=$P($g(^PAADM(PAAdm)),"^",17)
	i $g(^DHCDishChargeSet("Disch","ifGetDischgDateTimeByDoc"))="Y"{
		s DischargeDate=$p($g(^PAADM(PAAdm,"DHC")),"^",29)
	}
	if DischargeDate'="" s DischargeDate=..%ZD(DischargeDate)
	If $g(mradm)'="" Set Diagnosis=..GetMRAdmDiagnosis(mradm)
	Else  Set Diagnosis=""
	Set Ord=$O(^OEORD(0,"Adm",PAAdm,""))
	Set Select=""
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

ClassMethod GetDiagDesc(mradm As %String) As %String
{
 Quit:mradm="" ""
 Set Diag=0
 Set DiagStr=""
 For  Set Diag=$O(^MR(mradm,"DIA",Diag)) Quit:Diag=""  Do
 .;
 Quit DiagStr
}

ClassMethod GetDocRowIdByCode(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "")
{
 Set val=$$ALPHAUP^SSUTIL4(val)
 Set DocRowId=$O(^CTPCP(0,"Decs",val,""))
 If DocRowId'="" Set DocCode=$P($g(^CTLOC(DocRowId)),"^",1)
 Quit DocRowId_"^"_$g(DocCode)_"^"_val
}

ClassMethod GetLocRowIdByCode(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "")
{
 Set val=$$ALPHAUP^SSUTIL4(val)
 Set LocRowId=$O(^CTLOC(0,"Code",val,""))
 If LocRowId'="" Set LocDesc=$P($g(^CTLOC(LocRowId)),"^",2)
 Quit LocRowId_"^"_val_"^"_$g(LocDesc)
}

ClassMethod GetLocRowIdByDesc(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "")
{
 Set val=$$ALPHAUP^SSUTIL4(val)
 Set LocRowId=$O(^CTLOC(0,"Desc",val,""))
 If LocRowId'="" Set LocDesc=$P($g(^CTLOC(LocRowId)),"^",2)
 Quit LocRowId_"^"_val_"^"_$g(LocDesc)
}

ClassMethod GetMRAdmDiagnosis(MRAdm As %String) As %String
{
	Quit:$g(MRAdm)="" ""
	s EpisodeID=$p($G(^MR(MRAdm,"PRO",1)),"^",9)
	Q ##class(DHCDoc.Diagnos.Common).GetAdmDiagDesc(EpisodeID)
}

ClassMethod GetOrdCateStr(Desc As %String) As %String
{
 Set ParamStr=..GetProfileParams(Desc)
 Set CateStr=$P(ParamStr,"|",1)
 Set CateStr=$TR(CateStr,",","^")
 Quit "||^"_CateStr_"^"
}

ClassMethod GetOrdStatStr(Desc As %String) As %String
{
 Set ParamStr=..GetProfileParams(Desc)
 Set StatStr=$P(ParamStr,"|",2)
 Set StatStr=$TR(StatStr,",","^")
 Quit "|^"_StatStr_"^"
}

ClassMethod GetOrdSubCateStr(Desc As %String) As %String
{
 Set ParamStr=..GetProfileParams(Desc)
 Set SubCate=$P(ParamStr,"|",5)
 Quit $P(SubCate,"*",2)
}

ClassMethod GetProfileParams(Desc As %String) As %String
{
 Set Desc=$$ALPHAUP^SSUTIL4(Desc)
 Quit:Desc="" ""
 Set ID=$O(^epr.CTProfileParamsI("UniquePPDescIndex",Desc,""))
 Quit:ID="" ""
 Quit $LIST($g(^epr.CTProfileParamsD(ID)),2)
}

ClassMethod GetWardRowIdByCode(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "")
{
 Set val=$$ALPHAUP^SSUTIL4(val)
 Set WardRowId=$O(^PAWARD(0,"WARD_Desc",val,""))
 If WardRowId'="" Do
 .Set WardCode=$P($g(^PAWARD(WardRowId)),"^",1)
 .Set WardDesc=$P($g(^PAWARD(WardRowId)),"^",2) 	
 Quit WardRowId_"^"_$g(WardCode)_"^"_$g(WardDesc)
}

ClassMethod GetWorkflowID(Workflow As %String) As %String
{
 Quit ##Class(websys.WorkFlow).GetIdFromCodeOrDescription(Workflow)
}

ClassMethod ProfileListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ProfileListExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod ProfileListExecute(ByRef qHandle As %Library.Binary, TSRTITM As %Library.String = "", TSRTORD As %Library.String = "", par As %String = "", dfrom As %String = "", dto As %String = "", categ As %String = "", stat As %String = "", result As %String = "", vis As %String = "", dsfrom As %String = "", dsto As %String = "", cptype As %String = "", hospitallist As %String = "", EpisodeAll As %String = "", OrderSubcategories As %String = "", ExcludeCurrentEpisode As %String = "") As %Library.Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1

	
	Set ^SMLProfile($j,1)=$g(TSRTITM)
	Set ^SMLProfile($j,2)=TSRTORD
	Set ^SMLProfile($j,3)=par
	Set ^SMLProfile($j,4)=dfrom
	Set ^SMLProfile($j,5)=dto
	Set ^SMLProfile($j,6)=categ
	Set ^SMLProfile($j,7)=stat
	Set ^SMLProfile($j,8)=result
	Set ^SMLProfile($j,9)=vis
	Set ^SMLProfile($j,10)=dsfrom
	Set ^SMLProfile($j,11)=dsto
	Set ^SMLProfile($j,12)=cptype
	Set ^SMLProfile($j,13)=hospitallist
	Set ^SMLProfile($j,14)=EpisodeAll
	Set ^SMLProfile($j,15)=OrderSubcategories
	Set ^SMLProfile($j,16)=ExcludeCurrentEpisode
	;
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod ProfileListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ProfileListExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 //
 //TSRTITM, TSRTORD, par As %String, dfrom As %String, dto As %String, categ As %String, stat As %String, result As %String, vis As %String, dsfrom As %String, dsto As %String, cptype As %String, hospitallist As %String, EpisodeAll As %String, OrderSubcategories As %String = "", ExcludeCurrentEpisode As %String = ""
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

Query FindDocCurrentAdm(PatientID As %String, PatientNo As %String) As %Query(ROWSPEC = "PatientID:%String,EpisodeID:%String,mradm:%String,PAPMINO:%String,PAPMIName:%String,PAPMIDOB:%String,PAPMISex:%String,PAAdmDate:%Date,PAAdmTime:%Time,PAAdmNo:%String,PAAdmDepCodeDR:%String,PAAdmDocCodeDR:%String,PAAdmType:%String,Hospital:%String,PAAdmWard:%String,PAAdmBed:%String,FinancialDischargeFlag:%String,MedicalDischargeFlag:%String,FinalDischargeFlag:%String,PAAdmReason:%String,DischargeDate:%String,Diagnosis:%String,Ord:%String,Select:%String,PAAdmStatus:%String,TPoliticalLevel:%String,TSecretLevel:%String,TAdmLocDr:%String")
{
}

Query ProfileList(TSRTITM As %Library.String = "", TSRTORD As %Library.String = "", par As %String = "", dfrom As %String = "", dto As %String = "", categ As %String = "", stat As %String = "", result As %String = "", vis As %String = "", dsfrom As %String = "", dsto As %String = "", cptype As %String = "", hospitallist As %String = "", EpisodeAll As %String = "", OrderSubcategories As %String = "", ExcludeCurrentEpisode As %String = "") As %Library.Query(CONTAINID = 1, ROWSPEC = "ID,Dosage,Duration,Frequency,FullDetails,OrderName,Instruction,Priority,SequenceNumber,Status,StatusCode,StartDate,Notes,UnitOfMeasure,Paid,PathwayStep,DCDate,DCTime,PatientShare,ExecutionTimes,Specimens,LabEpisNo,OrderType,OrderCat,OrderMsg,DefDurID,OEItemMstID,OrderDoc,ReceivLoc,Group,DateOrdered,TimeOrdered,SpecimenCDate,SpecimenCTime,LabRecDate,LabRecTime,LUUser,LUTime,LUDate,MealTime,Modifiers,RadStatus,RefDoctor:%String,MealType:%String,SpecimenADate,SpecimenATime,StartTime,DayBookAccNums,DayBookSpecs,EpisodeID,LinkedTo,LinkedToItmID,LinkedArcimID,OrdItmEpisodeID,RadSeriesNo:%String,VarianceReason:%String,OrdEndDate:%String,OrdEndTime:%String,Alerts:%String,ReasonForOverride:%String,AuthorisingClinician:%String, PAADMDEpisDate, PAADMEpisType, PAPMIName, PAPMIName2,PAPMIName3,PAPMIDOB,PAPMISex,PatRegNo,MRN,PAADMConsDR,PAADMUnit,PAADMWard, PAADMBed, PAADMClinic, OrderCode, OrderLink, intMRN, TotalDosage, Hospital, Specialty, CollectedBy:%String,StartHour,ExeTime,ExeDate,DCUser,Quantity,PAADMRoom,DocumentList:%String,mradmdr,ResultAvailableDate:%Date,Ingredients,PharmacyStatus,PrescriptionNo,ToothLocation,drugDESC,OrderNotes:%String,OrderSet:%String,PAADMEpisNo:%String,DiscClasDesc,GenDrugDetails,Payor,Plan,Price,OverrideRowID,PrioColour,PAPMIName4,PAPMIName5,PAPMIName6,PAPMIName7,PAPMIName8,NoResultReas,MaxRep")
{
}

}
