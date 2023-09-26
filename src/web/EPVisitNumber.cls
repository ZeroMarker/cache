Class web.EPVisitNumber Extends DHCDoc.Util.RegisteredObject [ ClassType = "" ]
{

Property dummy As %Library.String(TRUNCATE = 1);

/// Log 30565 - AI - 24-04-2003 : Called by web.EPVisitNumber - GetOrderItemDetails method to return 
/// Patient Age and Units at an Order's Collection Date.
ClassMethod CalculateAgeAndUnits(CollectionDate As %Library.Date = "", PatientDOB As %Library.Date = "") As %Library.String
{
}

/// Log 37263 - AI - 26-08-2003 : Called by OEOrdItem.TabularResultsEMR component, BoldLinks Item.
/// Returns whether links are bold or not. Used in OEOrdItem.TabularResultsEMR.js.
/// Also OEOrdItem.TabularTextResultsEMR and OEOrdItem.TabularWordResultsEMR and their .js files.
ClassMethod FindLinksData(OrderRowID As %Library.String) As %Library.Integer
{
}

ClassMethod FindUnVerifiedOrdersClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindUnVerifiedOrdersFetch ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod FindUnVerifiedOrdersExecute(QHandle As %Library.Binary, TSRTITM, TSRTORD) As %Library.Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s QHandle=$lb(0,repid,0)
	
	;new OERowIDs,PAPMIName,PAPMIName2,PAPMIName3,PatRegNo,MRN,DOB,EpisodeNo,LabEpisodeNo,RecLocation,Priority,OrderItem,OrderCode,PAPMIName4,PAPMIName5,PAPMIName6,PAPMIName7,PAPMIName8
	
	s ^CacheTemp(repid,ind)=$lb(OERowIDs,PAPMIName,PAPMIName2,PAPMIName3,PatRegNo,MRN,DOB,EpisodeNo,LabEpisodeNo,RecLocation,Priority,OrderItem,OrderCode,PAPMIName4,PAPMIName5,PAPMIName6,PAPMIName7,PAPMIName8)
	s ind=ind+1
	q $$$OK
}

ClassMethod FindUnVerifiedOrdersFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindUnVerifiedOrdersExecute ]
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

/// Author - Leon
/// Purpose - To return the patients which have non-excecuted orders with  receiving locaiton as the logon locationn
/// Used By - OEOrdItem.LabReceive
ClassMethod FindNonExecutedOrdersClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindNonExecutedOrdersFetch ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Author - Leon
/// Purpose - To return the patients which have non-excecuted orders with  receiving locaiton as the logon locationn
/// Log 61671 YC - Also to return Collected but Unreceived orders
/// Used By - OEOrdItem.LabReceive, EPVisitNumber.ListNonExecutedOrders, EPVisitNumber.ListCollUnreceivedOrders
ClassMethod FindNonExecutedOrdersExecute(ByRef QHandle As %Library.Binary, TSRTITM As %Library.String, TSRTORD As %Library.String, loc As %String, OrderType As %Library.String, PatientLoc As %Library.String, StartDate As %Library.String, EndDate As %Library.String, incomplete As %Library.String, Priority As %Library.String, LocationList As %Library.String, PAADMType As %Library.String, EpisodeLocation As %Library.String, EpisodeLocationList As %Library.String, PatientLocNow As %Library.String = "", RegistrationNo As %Library.String = "", UnreceivedList As %Library.String = "0") As %Library.Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s QHandle=$lb(0,repid,0)
	
	s ^CacheTemp(repid,ind)=$lb()
	s ind=ind+1
	q $$$OK
}

/// Author - Leon
/// Purpose - To return the patients which have non-excecuted orders with  receiving locaiton as the logon locationn
/// Used By - OEOrdItem.LabReceive
ClassMethod FindNonExecutedOrdersFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindNonExecutedOrdersExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
	Set repid=$LIST(QHandle,2)
	Set ind=$LIST(QHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else{				// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// The codes are :
/// KES = Kestral (Austin)
/// AUS = AusLab (QLD)
/// APX = Apex (RIE)
/// LAB = LabTrak
ClassMethod GetExternalSystem(orderitem As %Library.String = "") As %Library.String
{
}

/// Log 27734 - AI - 04/10/2002 : Created method to take in the 3-letter code of the External System, and the 
/// 		        Status of the Result, and return the Icon location as a string (/webemr/icon.gif).
/// 		        10/10/2002 : The IconLocation has now been named "ExtraValue".
/// 
ClassMethod GetExtraValue(StatusCode As %Library.String = "", ExtSystemCode As %Library.String = "") As %Library.String
{
	q $$$OK
}

ClassMethod GetLabMRN(PatientID As %Library.String = "") As %Library.String
{
}

/// Log 49901 YC - Rewrite OEOrdItem.Tabular*
/// Called from oeorditem.tabularresultsemr.csp 
ClassMethod GetResultDetails(ResultID As %String, OrderID As %String, ByRef ResultType As %String, ByRef HL7ResultType As %String)
{
}

/// Log 50701 Yvonne - Rewriting Save for OEOrdItemTabular*
/// Populates OEOrdItemTabular* pages with the ^TMP global
ClassMethod PopulateNextPrev()
{
}

/// Log 50701 Yvonne
/// Used by OEOrdItem.Tabular* components to return next and previous results - skips voice and dicom results
/// Called by oeorditem.tabularresultsemr.csp
/// Log 58881 YC - reworked - no longer using resultlist - replaced by TMP Global
ClassMethod GetNextPrevCounter(SessionId As %Library.String = "", Context As %Library.String = "", counter As %Library.String = "", ByRef prevcounter As %Library.String = "", ByRef nextcounter As %Library.String = "") As %Library.String
{
}

/// Used by OEOrdItem.TabularResultsEMR component to return some order details
ClassMethod GetOrderItemDetails(OrderID As %Library.String, TextResID As %Library.String = "", WordResID As %Library.String = "", ResultStatusList As %Library.String = "") As %Library.String
{
}

ClassMethod GetPatientHospital(EpisodeID As %Library.String = "", OERowID As %Library.String = "", ByRef hospdesc) As %Library.String
{
}

ClassMethod GetReceiveDetails(labepisodeno As %Library.String = "") As %Library.String
{
}

/// Author - John Hart
/// Purpose - To fetch the lab orders for a certain Lab Order Profile
/// Used by - EPR
/// Log 26715 - AI - 07-08-2002 : Added sorting capability of "Date" and "LabNumber".
ClassMethod GetResultDisplayStatus(LabStatusCode As %Library.String = "", OrderID As %Library.String = "") As %Library.String
{
	Q $$$OK
}

ClassMethod GetTextResultDisplayStatus(StatusCode As %String, OrderID As %String) As %String
{
}

ClassMethod HL7OrderCreate(OrderID As %Library.String = "", Module As %Library.String) As %Library.String
{
}

ClassMethod LabEpisodeExists(LabEpisodeNo As %Library.String = "") As %Library.Boolean
{
}

/// Author - John Hart
/// Purpose - To fetch the lab orders for a certain Lab Order Profile
/// Used by - EPR
ClassMethod LabEpisodeProfileListClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LabEpisodeProfileListFetch ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Author - John Hart
/// Purpose - To fetch the lab orders for a certain Lab Order Profile
/// Used by - EPR
/// Log 26715 - AI - 07-08-2002 : Added sorting capability of "Date" and "LabNumber".
ClassMethod LabEpisodeProfileListExecute(ByRef QHandle As %Library.Binary, TSRTITM As %Library.String = "", TSRTORD As %Library.String = "", patientid As %Library.String = "", episode As %Library.String = "", datefrom As %Library.String = "", EpisodesAll As %Library.String = "", category As %Library.String = "", test As %Library.String = "") As %Library.Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s QHandle=$lb(0,repid,0)
	
	s ^CacheTemp(repid,ind)=$lb()
	s ind=ind+1
	q $$$OK
}

/// Author - John Hart
/// Purpose - To fetch the lab orders for a certain Lab Order Profile
/// Used by - EPR
/// Log 26715 - AI - 07-08-2002 : Added sorting capability of "Date" and "LabNumber".
ClassMethod LabEpisodeProfileListFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LabEpisodeProfileListExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
	Set repid=$LIST(QHandle,2)
	Set ind=$LIST(QHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else{				// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Author - John Hart
/// Purpose - To fetch the lab orders for a certain Lab Order Profile
/// Used by - EPR
ClassMethod LabEpisodeTestListClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LabEpisodeTestListFetch ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Author - John Hart
/// Purpose - To fetch the lab orders for a certain Lab Order Profile
/// Used by - EPR
ClassMethod LabEpisodeTestListExecute(ByRef QHandle As %Library.Binary, LabOrder As %Library.String, OEOrdItem As %Library.String, TestSet As %Library.String, Dat As %Library.String, Tim As %Library.String, Sequence As %Library.String, markasread As %Library.String = "", userid As %Library.String = "") As %Library.Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s QHandle=$lb(0,repid,0)
	
	s ^CacheTemp(repid,ind)=$lb()
	s ind=ind+1
	q $$$OK
}

/// Author - John Hart
/// Purpose - To fetch the lab orders for a certain Lab Order Profile
/// Used by - EPR
ClassMethod LabEpisodeTestListFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LabEpisodeTestListExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
	Set repid=$LIST(QHandle,2)
	Set ind=$LIST(QHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else{				// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Author - John Hart
/// Purpose - To fetch the lab orders for a certain Lab Order Profile
/// Used by - EPR
ClassMethod LabProfileListClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LabProfileListFetch ]
{
	Set repid=$LIST(QHandle,2)
	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Author - John Hart
/// Purpose - To fetch the lab orders for a certain Lab Order Profile
/// Used by - EPR
ClassMethod LabProfileListExecute(ByRef QHandle As %Library.Binary, TSRTITM As %Library.String = "", TSRTORD As %Library.String = "", patientid As %Library.String = "", episode As %Library.String = "", datefrom As %Library.String = "", dateto As %Library.String = "", EpisodesAll As %Library.String = "", category As %Library.String = "", test As %Library.String = "", resultstatus As %Library.String = "", priority As %Library.String = "", ordercategory As %Library.String = "", orderitem As %Library.String = "", orderstatus As %Library.String = "", markasread As %Library.String = "") As %Library.Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s QHandle=$lb(0,repid,0)
	
	s ^CacheTemp(repid,ind)=$lb()
	s ind=ind+1
	q $$$OK
}

/// Author - John Hart
/// Purpose - To fetch the lab orders for a certain Lab Order Profile
/// Used by - EPR
ClassMethod LabProfileListFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LabProfileListExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
	Set repid=$LIST(QHandle,2)
	Set ind=$LIST(QHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else{				// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Log:58450 - PJC - 09/03/2006 - Method to get the Quantity Administered given order item row id.
ClassMethod GetQuanAdmin(OEOrdItemID As %Library.String = "") As %Library.String
{
	;n (OEOrdItemID)
	q:OEOrdItemID="" ""
	/*
	s ARCIMRowid=$p($g(^OEORD(+OEOrdItemID,"I",$p(OEOrdItemID,"||",2),1)),"^",2)
	s INCIRowid=##class(web.DHCDocOrderEntry).GetINCI(+ARCIMRowid)
	s Billuom=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),8)),"^",14) ; ARCIM_BillingUOM_DR
	s Baseuom=$p($g(^INCI(INCIRowid,1)),"^",10)                     ; INCI_CTUOM_DR  库存基本单位
	*/
	s myQty=""
	s PackQty=$p($g(^OEORD(+OEOrdItemID,"I",$p(OEOrdItemID,"||",2),9)),"^",4)
	s PhQtyOrd=$p(^OEORD(+OEOrdItemID,"I",$p(OEOrdItemID,"||",2),1),"^",12)
	i PackQty="" s myQty=PhQtyOrd
	e  s myQty=PackQty
	q myQty
}

ClassMethod MRNMatchesLabEpisode(LabEpisodeNo As %Library.String = "", PatientId As %Library.String = "") As %Library.Boolean
{
}

ClassMethod ProfileListClose(QHandle As %Library.Binary) As %Library.Status
{
	Set repid=$LIST(QHandle,2)
	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// see seloe1^MVBOEIT6 for the PLIST layout.
/// Log 41352 - AI - 16-02-2004 : Add the new subcategories data. Only passed in IDs List.
ClassMethod ProfileListExecute(ByRef QHandle As %Library.Binary, TSRTITM As %Library.String = "", TSRTORD As %Library.String = "", par As %String = "", dfrom As %String = "", dto As %String = "", categ As %String = "", stat As %String = "", result As %String = "", vis As %String = "", dsfrom As %String = "", dsto As %String = "", cptype As %String = "", hospitallist As %String = "", EpisodeAll As %String = "", OrderSubcategories As %String = "", ExcludeCurrentEpisode As %String = "") As %Library.Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	//s OrderType=%request.Get("OrderType")
	
	s OrdStatus = %request.Get("OrdStatus")
	s paramOrdStatusDr = ##class(web.OECOrderStatus).GetIdFromCodeOrDescription(OrdStatus)
	s OECPRDesc = %request.Get("OECPRDesc")
	s paramPriorityDr = ##class(web.OECPriority).GetIdFromCodeOrDescription(OECPRDesc)
	s SearchByOrdItem = %request.Get("SearchByOrdItem")
	s paramArcimDR = ##class(web.ARCItmMast).GetIdFromCodeOrDescription(SearchByOrdItem)
	s dateFrom = %request.Get("dateFrom")
	s paramDateFrom = ..%ZDH(dateFrom)
	s dateTo = %request.Get("dateTo")
	s paramDateTo = ..%ZDH(dateTo)
	s CTLOCDesc = %request.Get("CTLOCDesc")
	s paramCTLocDr = ##class(web.CTLoc).GetIdFromCodeDescriptionHosp(CTLOCDesc)
	s OrdCategory = %request.Get("OrdCategory")
	s paramOrdCategory = ##class(web.OECOrderCategory).GetIdFromCodeOrDescription(OrdCategory)
	s Doctor = %request.Get("Doctor")
	s paramDoctorDr = ##class(web.CTCareProv).GetIdFromCodeOrDescription(Doctor)
	Set langid=..%LanguageID()
	s sub=0
	for {
		s sub=$O(^OEORD(+par,"I",sub)) q:sub=""
		
		s (ID,Dosage,Duration,Frequency,FullDetails,OrderName,Instruction,Priority,SequenceNumber,Status)=""
		s (StatusCode,StartDate,Notes,UnitOfMeasure,Paid,PathwayStep,DCDate,DCTime,PatientShare,ExecutionTimes)=""
		s (Specimens,LabEpisNo,OrderType,OrderCat,OrderMsg,DefDurID,OEItemMstID,OrderDoc,ReceivLoc,Group,DateOrdered)=""
		s (TimeOrdered,SpecimenCDate,SpecimenCTime,LabRecDate,LabRecTime,LUUser,LUTime,LUDate,MealTime,Modifiers,RadStatus)=""
		s (RefDoctor,MealType,SpecimenADate,SpecimenATime,StartTime,DayBookAccNums,DayBookSpecs,EpisodeID,LinkedTo,LinkedToItmID)=""
		s (LinkedArcimID,OrdItmEpisodeID,RadSeriesNo,VarianceReason,OrdEndDate,OrdEndTime,Alerts,ReasonForOverride)=""
		s (AuthorisingClinician, PAADMDEpisDate, PAADMEpisType, PAPMIName, PAPMIName2,PAPMIName3,PAPMIDOB,PAPMISex,PatRegNo)=""
		s (MRN,PAADMConsDR,PAADMUnit,PAADMWard, PAADMBed, OrderCode, OrderLink, intMRN, TotalDosage, Hospital, Specialty, CollectedBy,StartHour,ExeTime,ExeDate,DCUser,Quantity,PAADMRoom,DocumentList,mradmdr,ResultAvailableDate,Ingredients,PharmacyStatus,PrescriptionNo,ToothLocation,drugDESC,OrderNotes,OrderSet,PAADMEpisNo,DiscClasDesc,GenDrugDetails,Payor,Plan,Price,OverrideRowID,PrioColour,PAPMIName4,PAPMIName5,PAPMIName6,PAPMIName7,PAPMIName8,TestItemResult,DateExecuted,TimeExecuted,PRNMaxDose,PRNTotalDoses,PRNIndication,CollByPatRep,TIAnaOperationNo,TIAnaestNo,NoResultReas,MaxRep,QuestionnaireID,AdmRoute,DrugRoute,ShowDispChangeLink,ExecDoctor,OEORIBilled,OEORIDSReportFlag,Repeat,OEOrdExecID,VIPStatus,lastPRN,HasNotes,AdminFlowRate,MODesc,MOColor,SingleAdmin,UserAddHosp,DrugForm,DrugStrength,ObservationGroupDR,AdminQuestionnDR,STATCode,AnnotationLink,IVType,LinkedDiag,PrescriptionNoLink,OkToAdminister,UserAdd)=""
	
		s ID=+par_"||"_sub
		f j=1:1:9 s str(j)=$g(^OEORD(+par,"I",sub,j))
		s oeent=$p(str(1),"^",1)
		s arcim=$p(str(1),"^",2)		
		if arcim="" continue
		s OrderStatusDr = $p(str(1),"^",13)
		continue:(""'=paramOrdStatusDr)&&(OrderStatusDr'=paramOrdStatusDr)	;参数查询 wanghc
		s OEItemMstID=arcim
		s OrdItmEpisodeID=$p(^OEORD(+par),"^",1)
		s ItemCatDR=""
		i arcim'="" {
			s OrderName=$p($g(^ARCIM(+arcim,$P(arcim,"||",2),1)),"^",2)
			s OrderName=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",OrderName,langid)
			s ReqPartDesc=##Class(BSP.IMP.PACS.Interface).GetExaReqPartDesc(+par_"||"_sub)
			if (ReqPartDesc'="") s OrderName=OrderName_" "_ReqPartDesc
			s ItemCatDR=$p($g(^ARCIM(+arcim,$P(arcim,"||",2),1)),"^",10)
		}
		continue:(""'=paramArcimDR)&&(arcim'=paramArcimDR)
		;s GenDrugDetails=##class(web.UDHCPrescript).GetDrugCommonNameByArcimId(arcim)
		;s GenDrugDetails=$$GetDrugCommonNameByArcimId(arcim)
		s GenDrugDetails=##class(web.UDHCJFCOMMON).GetDrugCommonNameByArcimId(arcim)
		s drugDESC=GenDrugDetails
		s DrgFormRowid=$p(^ARCIM(+arcim,$p(arcim,"||",2),1),"^",12)
		i DrgFormRowid=-1 s DrgFormRowid=""
		;s DrgformRowid=##class(web.DHCDocOrderEntry).GetDrgForm(arcim)
		i DrgFormRowid'="" {
	  		s PHCDRowid=$P(DrgFormRowid,"||",1)
	  		s ChildSub=$P(DrgFormRowid,"||",2)
	  		;剂型
	  		s FormRowid=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,1)),"^",1)
	  		i FormRowid'="" d
	  		.s DrugForm=$P($G(^PHCF(FormRowid)),"^",2)
	  		.s DrugForm=##class(User.PHCForm).GetTranByDesc("PHCFDesc",DrugForm,langid)
	  		
		}
		
		s OEORIUnitDR = $p(str(2),"^",3)
		i OEORIUnitDR '= "" s UnitOfMeasure = $p($g(^CT("UOM",OEORIUnitDR)),"^",2)
		s UnitOfMeasure=##class(User.CTUOM).GetTranByDesc("CTUOMDesc",UnitOfMeasure,langid)
		;s DosageDR=$p(str(2),"^",5)
		s PhQtyOrd=$p(str(1),"^",12)
		s OEORIItemStatDR = $p(str(1),"^",13)		;wanghc
		s:OEORIItemStatDR'="" OSTATCode = $p(^OEC("OSTAT",OEORIItemStatDR),"^",1) ;wanghc
		s Dosage = PhQtyOrd
		s DuratDR=$p(str(2),"^",6)
		i DuratDR'="" s Duration=$p($g(^PHCDU(DuratDR)),"^",3)
		s Duration=##class(User.PHCDuration).GetTranByDesc("PHCDUDesc1",Duration,langid)
		;s RealDuration=""
		;s RealDuration=##class(web.DHCDocOrderEntry).CalcDur(ID)
		/*s PHFreqDR=$p(str(2),"^",4)
		i PHFreqDR'="" {
			s Frequency=$p($g(^PHCFR(PHFreqDR)),"^",3)
			s WeekFlag=$P(^PHCFR(PHFreqDR),"^",9)
			i WeekFlag="Y" {
				s OrderFreqWeek=$p($g(^OEORD(+par,"I",sub,"DHC")),"^",55)
				s Frequency=Frequency_"-"_$TR(OrderFreqWeek,"|","")
			}
		}*/
		s OrdFreqInfo=##class(DHCDoc.Interface.Inside.ServiceOrd).GetOrdFreqInfo(ID,"^")
		s PHFreqDR=$List(OrdFreqInfo,1)
		s Frequency=$List(OrdFreqInfo,2)
		s Frequency=$REPLACE(Frequency,"^","-")
	
		s PriorityDR=$p(str(1),"^",8)
		i PriorityDR'="" s Priority=$p($g(^OECPR(PriorityDR)),"^",2)
		continue:(""'=paramPriorityDr)&&(PriorityDR'=paramPriorityDr)	;wanghc 参数查询
		s Priority=##class(User.OECPriority).GetTranByDesc("OECPRDesc",Priority,langid)
		s PrescriptionNoLink=$p(str(1),"^",14)
		s PrescriptionNo = PrescriptionNoLink
		
		s OEORIRecDepDR = $p(str(3),"^",6)
		if OEORIRecDepDR'="" s ReceivLoc = $p($g(^CTLOC(OEORIRecDepDR)),"^",2) 
		s ReceivLoc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",ReceivLoc,langid)
		s ReceivLoc=##class(web.DHCOPAdmReg).LocDescFormate(ReceivLoc)
		continue:(""'=paramCTLocDr)&&(OEORIRecDepDR'=paramCTLocDr)	;wanghc 参数查询
		s QtyPackUOM=$p(str(9),"^",4)
		
		s DCDate = $p(str(3),"^",34)
		s DCTime = $p(str(3),"^",35)
		s OEORIUserUpdate = $p(str(8),"^",12)
		if (OEORIUserUpdate '= ""),(OSTATCode="D")   s DCUser = $p($g(^SSU("SSUSR",OEORIUserUpdate)),"^",2)	;停止医生
		s DCUser =##class(User.SSUser).GetTranByDesc("SSUSRName",DCUser,langid)
		s ItemStatDR=$p(str(1),"^",13)
		i ItemStatDR'="" s Status=$p(^OEC("OSTAT",ItemStatDR),"^",2)
		s Status=##class(User.OECOrderStatus).GetTranByDesc("OSTATDesc",Status,langid)
		s LabEpisNo = $p(str(3),"^",20)
		s LoopOrderType=""
		i ItemCatDR'="" {
			s OrderCat=$p($g(^ARC("IC",ItemCatDR)),"^",8)
			s LoopOrderType=$p($g(^ARC("IC",ItemCatDR)),"^",7)
		}
		continue:(""'=paramOrdCategory)&&(OrderCat'=paramOrdCategory)
		s OrderDocDR=$p(str(1),"^",11)
		i OrderDocDR'="" s OrderDoc=$p($g(^CTPCP(OrderDocDR,1)),"^",2)
		s OrderDoc =##class(User.SSUser).GetTranByDesc("SSUSRName",OrderDoc,langid)
		s PharmacyStatus=$p(str(8),"^",11)
		s LUUserDR=$p(str(8),"^",12)
		i LUUserDR'="" s LUUser=$p($g(^SSU("SSUSR",LUUserDR)),"^",2)
		s LUUser =##class(User.SSUser).GetTranByDesc("SSUSRName",LUUser,langid)
		s StartDate=$p(str(1),"^",9)
		s StartTime=$p(str(1),"^",10)
		s DateOrdered = $p(str(3),"^",7)
		s TimeOrdered = $p(str(1),"^",17)
		s OrdEndDate = $p(str(9),"^",9)
		s OrdEndTime = $p(str(9),"^",10)
		s doctor=$p(str(1),"^",11)
		s stat=$p(str(1),"^",13)
		continue:(""'=paramDoctorDr)&&(paramDoctorDr'=doctor)
		continue:(paramDateTo'="")&&(DateOrdered>paramDateTo)
		continue:(paramDateFrom'="")&&(paramDateFrom>DateOrdered)
		s EpisodeID = ""
		s OEORDAdmDR = $p($g(^OEORD(+par)),"^",1)
		s PAADMPAPMIDR = $p($g(^PAADM(OEORDAdmDR)),"^",1)
		s PAADMEpisNo = $p($g(^PAADM(OEORDAdmDR)),"^",81)
		s PAPMIName = $p($g(^PAPER(PAADMPAPMIDR,"ALL")),"^",1)
		;
		s recdep=$p(str(3),"^",6)
		s labepis=$p(str(3),"^",20)
		s labts=$p(str(3),"^",35)
		;
		s timeexec=$p(str(6),"^",3)
		s userexec=$p(str(6),"^",4)
		s docexec=$p(str(6),"^",9)
		;        
		s useradd=$p(str(7),"^",1)
		s userupdate=$p(str(8),"^",12)
		s datetime=+$p(str(3),"^",7)_","_+$p(str(1),"^",17)
		;
		s desc=$p($g(^ARCIM(+arcim,1,1)),"^",2)
		s arcimcode=$p($g(^ARCIM(+arcim,1,1)),"^",1)
		s subcat=$p($g(^ARCIM(+arcim,1,1)),"^",10)
		s execcat=$p($g(^ARC("IC",+subcat)),"^",9)
		i execcat s execcat=$p($g(^ARC("EXEC",+execcat)),"^")
		i stat s statcod=$p($g(^OEC("OSTAT",+stat)),"^")
		i stat s statdes=$p($g(^OEC("OSTAT",+stat)),"^",2)
		s statdes=##class(User.OECOrderStatus).GetTranByDesc("OSTATDesc",statdes,langid)
		s resstat=""
		i $o(^OEORD(+par,"I",+sub,"RES",0)) s resstat="W"
		i $o(^OEORD(+par,"I",+sub,"TR",0)) s resstat="T"
		;条件查询
		s OCGrpDesc=""
		s OrdCatID=OrderCat
		i OrdCatID'="" s OCGroupdr=$P($g(^OEC("ORCAT",OrdCatID)),"^",15)
		i $g(OCGroupdr)'="" s OCGrpDesc=$P($g(^OEC("OCGRP",$g(OCGroupdr))),"^",2)
		/*i $g(OCGrpDesc)["检查" s LoopOrderType="E"
		s ARCIMRowId=$P($g(^OEORD(+ID,"I",$P(ID,"||",2),1)),"^",2)
		;s CureCatOrder=##class(web.DHCDocHardCoded).IsCureCatOrder(ARCIMRowId)
		s CureCatOrder=""
		i CureCatOrder=1 s LoopOrderType="C"
		;s ARCIMAbbrev=$P($g(^ARCIM(+ARCIMRowId,$P(ARCIMRowId,"||",2),1)),"^",3)
		;s $List(Data,6)=ARCIMAbbrev
		if (OrderType'="")&((" "_OrderType_" ")'[(" "_LoopOrderType_" ")) continue
		*/
		s InstrDr=$p(str(2),"^",7)
		i InstrDr'="" d
		.s Instruction=$p(^PHCIN(InstrDr),"^",2)
		.s Instruction=##class(User.PHCInstruc).GetTranByDesc("PHCINDesc1",Instruction,langid)
		s ItemCatDR=$p(^ARCIM(+arcim,$p(arcim,"||",2),1),"^",10)
		s ItemCatDesc=""
		i ItemCatDR'="" s ItemCatDesc=$p($g(^ARC("IC",ItemCatDR)),"^",2)
		s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
		i OrderType="R" {
			s QtyPackUOM=$p(str(9),"^",4)
		}else{
			s QtyPackUOM=$p(str(9),"^",4)
			i QtyPackUOM="" s QtyPackUOM=$p(str(1),"^",12)
		}
		s PackUOMDesc=""
		s BillingUOMDR=$p(^ARCIM(+arcim,$p(arcim,"||",2),8),"^",14)
		if BillingUOMDR'="" s PackUOMDesc=$p(^CT("UOM",BillingUOMDR),"^",2)
		;协议单位
		s ProtocolPackUOMDR=$p($g(^OEORD(+par,"I",sub,"DHC")),"^",13)
		i ProtocolPackUOMDR'="" {
			s ARCIMBillingUOM=ProtocolPackUOMDR
			s PackUOMDesc=$p($g(^CT("UOM",ARCIMBillingUOM)),"^",2)
			;s PackUOMDesc=##class(User.CTUOM).GetTranByDesc("CTUOMDesc",PackUOMDesc,langid)
		}
		s CheckCHNFlag=##class(web.DHCSTINTERFACE).GetStruModeFlag(arcim)
		if (CheckCHNFlag="Y") {
			S Phcdf=$P($g(^ARCIM(+arcim,$P(arcim,"||",2),1)),"^",12)
			if (Phcdf'=""){
				s ARCIMBillingUOM=$p(^PHCD(+Phcdf,"DF",$p(Phcdf,"||",2),2),"^",4)
				s PackUOMDesc=$p($g(^CT("UOM",ARCIMBillingUOM)),"^",2)
				;s PackUOMDesc=##class(User.CTUOM).GetTranByDesc("CTUOMDesc",PackUOMDesc,langid)
			}
		}
		s PackUOMDesc=##class(User.CTUOM).GetTranByDesc("CTUOMDesc",PackUOMDesc,langid)
		i QtyPackUOM'="" s Quantity=$j(QtyPackUOM,"",2)_" "_PackUOMDesc
		;通过转换系数转成基本单位
		s retPrice=##class(web.DHCDocOrderCommon).GetOEORIPrice(+par_"||"_sub,"")
		s Price=$p(retPrice,"^",1)
		i $e(Price,1,1)="." s Price="0"_Price
		s OrderNotes=$g(^OEORD(+par,"I",sub,"DEP",1))
		
		set Paid = $p(^OEORD(+ID,"I",$P(ID,"||",2),3),"^",5)
		do OutputRow
	}
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
 	Set ^CacheTemp(repid,ind)=$lb(ID,Dosage,Duration,Frequency,FullDetails,OrderName,Instruction,Priority,SequenceNumber,Status,StatusCode,StartDate,Notes,UnitOfMeasure,Paid,PathwayStep,DCDate,DCTime,PatientShare,ExecutionTimes,Specimens,LabEpisNo,OrderType,OrderCat,OrderMsg,DefDurID,OEItemMstID,OrderDoc,ReceivLoc,Group,DateOrdered,TimeOrdered,SpecimenCDate,SpecimenCTime,LabRecDate,LabRecTime,LUUser,LUTime,LUDate,MealTime,Modifiers,RadStatus,RefDoctor,MealType,SpecimenADate,SpecimenATime,StartTime,DayBookAccNums,DayBookSpecs,EpisodeID,LinkedTo,LinkedToItmID,LinkedArcimID,OrdItmEpisodeID,RadSeriesNo,VarianceReason,OrdEndDate,OrdEndTime,Alerts,ReasonForOverride,AuthorisingClinician, PAADMDEpisDate, PAADMEpisType, PAPMIName, PAPMIName2,PAPMIName3,PAPMIDOB,PAPMISex,PatRegNo,MRN,PAADMConsDR,PAADMUnit,PAADMWard, PAADMBed, OrderCode, OrderLink, intMRN, TotalDosage, Hospital, Specialty, CollectedBy,StartHour,ExeTime,ExeDate,DCUser,Quantity,PAADMRoom,DocumentList,mradmdr,ResultAvailableDate,Ingredients,PharmacyStatus,PrescriptionNo,ToothLocation,drugDESC,OrderNotes,OrderSet,PAADMEpisNo,DiscClasDesc,GenDrugDetails,Payor,Plan,Price,OverrideRowID,PrioColour,PAPMIName4,PAPMIName5,PAPMIName6,PAPMIName7,PAPMIName8,TestItemResult,DateExecuted,TimeExecuted,PRNMaxDose,PRNTotalDoses,PRNIndication,CollByPatRep,TIAnaOperationNo,TIAnaestNo,NoResultReas,MaxRep,QuestionnaireID,AdmRoute,DrugRoute,ShowDispChangeLink,ExecDoctor,OEORIBilled,OEORIDSReportFlag,Repeat,OEOrdExecID,VIPStatus,lastPRN,HasNotes,AdminFlowRate,MODesc,MOColor,SingleAdmin,UserAddHosp,DrugForm,DrugStrength,ObservationGroupDR,AdminQuestionnDR,STATCode,AnnotationLink,IVType,LinkedDiag,PrescriptionNoLink,OkToAdminister,UserAdd)
 	Set ind=ind+1
	Quit
GetDrugCommonNameByArcimId(arcim)
	s DrugCommonName=""
	i arcim'="" {
		s ItmCat=$p($g(^ARCIM($p(arcim,"||",1),$p(arcim,"||",2),1)),"^",10)
		quit:ItmCat="" DrugCommonName
		s OrdType=$p($g(^ARC("IC",ItmCat)),"^",7)	;ARCIC_OrderType
		Q:OrdType'="R" DrugCommonName
		s DrugCommonName =$p($g(^ARCIM($p(arcim,"||",1),$p(arcim,"||",2),8)),"^",21) ;ARCIM_GenericDesc 通用名 8 21
		
		;s incitmid=$o(^INCI(0,"ARCIM_DR",$p(arcim,"||",1),""))
	}
	Quit DrugCommonName
}

ClassMethod ProfileListFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status
{
	 Set AtEnd=$LIST(QHandle,1)
	 Set repid=$LIST(QHandle,2)
	 Set ind=$LIST(QHandle,3)
		//
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

ClassMethod GetResultProfileRow(str, ord, itm, ResultFormat, DisplayWordFormat)
{
}

ClassMethod GETPharmStatus(PrescNo As %String = "", OEOrdID As %String = "")
{
	/*s dstatus=""
	s dis=$O(^DHCOEDISQTY(0,"OEORI",OEOrdID,0))
	if $g(dis)'="" {
		s dstatus=$p(^DHCOEDISQTY(dis),"^",7)
	}
	s OrderType=""
	s ArcimID=$P($G(^OEORD(+OEOrdID,"I",$P(OEOrdID,"||",2),1)),"^",2)
	s ItemCatDr=$P(^ARCIM(+ArcimID,$P(ArcimID,"||",2),1),"^",10) 
	if ItemCatDr'="" d
	.s OrderType=$P(^ARC("IC",ItemCatDr),"^",7) ; 
	Q:OrderType'="R" ""
	i dstatus="C" s dstatus="已发"
	i dstatus="TC" s dstatus="未发"
	i dstatus=""  s dstatus="未打包"
	q dstatus*/
	s OrderType="",dstatus=""
	s ArcimID=$P($G(^OEORD(+OEOrdID,"I",$P(OEOrdID,"||",2),1)),"^",2)
	s ItemCatDr=$P(^ARCIM(+ArcimID,$P(ArcimID,"||",2),1),"^",10) 
	if ItemCatDr'="" d
	.s OrderType=$P(^ARC("IC",ItemCatDr),"^",7) ; 
	Q:OrderType'="R" ""
	s HaveDispensing=0,dstatus="",TotalQty=0
	//存储退药数量,发药数量
	s DspConfirmQty=0,ConfirmQty=0 
	s dis=0  f  s dis=$O(^DHCOEDISQTY(0,"OEORI",OEOrdID,dis)) Q:dis=""  d
	.s TotalQty=$p(^DHCOEDISQTY(dis),"^",2)
	.s dstatus=$p(^DHCOEDISQTY(dis),"^",7)
	.s HaveDispensing=1
	.//发药或退药数量
	.s dconfirmqty=$p(^DHCOEDISQTY(dis),"^",11)
	.i dstatus="R" d 
	..//退药数量
	..s DspConfirmQty=DspConfirmQty+dconfirmqty
	.i dstatus="C" d
	..s ConfirmQty=ConfirmQty+dconfirmqty
	i HaveDispensing=1 d
	.i dstatus="C" s dstatus="已发"
	.i dstatus="TC" s dstatus="未发"
	.i dstatus=""  s dstatus="未打包"
	.i (DspConfirmQty'=0) d
	..i DspConfirmQty=ConfirmQty s dstatus="已退药"
	..i DspConfirmQty<ConfirmQty s dstatus="部分退药"
	Q dstatus
}

/// This method is now also used for epr.SOAPPlanning (web.PAPersonConsultSetCons->ConsultOrders) in addition to Order profile and clinic worklist
ClassMethod GetOrderProfileRow(rowid, ByRef RemainingSpecimens, EpisodeID, ExtLabFlag, DisplayWordFormat, statusColourLIST, OrderEntry, ClinicWB, ShowPRN, lastPRN, CurrentOrdersOnly)
{
}

/*

ClassMethod GetNextRowID(QHandle As %Library.Binary, ByRef OrderItemIDs As %Library.String) As %Library.Status
{
	; given a sort column, calculate the quickest index
	; given the current rowID, calculate the next node
	q ""
	n (QHandle,%session,%request,OrderItemIDs)
	;
	;
	s AtEnd=$li(QHandle,1)
	s user=$li(QHandle,2)
	s work=$li(QHandle,3)
	;
	s TSRTITM=$li(user,1)
	s TSRTORD=$li(user,2)
	s ExtLabFlag=$li(user,3)
	s PatType=$li(user,4)
	; ordheadlist is a string - turn it into an array..
	s ordheadlist=$li(user,5)
	f ordpiece=1:1 s ordstr=$p(ordheadlist,"^",ordpiece) q:ordstr=""  s ordheadlist(ordstr)=""
	s dfrom=$li(user,6)
	s dto=$li(user,7)
	s categ=$li(user,8)
	s stat=$li(user,9)
	s result=$li(user,10)
	s vis=$li(user,11)
	s dsfrom=$li(user,12)
	s dsto=$li(user,13)
	s cptype=$li(user,14)
	s EpisodeID=$li(user,15)
	s SearchItemID=$li(user,16)
	s SearchCategoryID=$li(user,17)
	s SearchStatusID=$li(user,18)
	s SearchPriorityID=$li(user,19)
	s SearchLocationID=$li(user,20)
	s SearchDateFrom=$li(user,21)
	s SearchDateTo=$li(user,22)
	s PatientID=$li(user,23)
	s EpisodeAll=$li(user,24)
	s CanViewSensOrder=$li(user,25)
	s hospitallist=$li(user,26)
					
	s tryrow=$li(work,1)

	; go up, or down the index?
	i TSRTORD="A" s SortOrd="1"
	e  s SortOrd="-1"
	; check we're not going to $o onto to '0' node
	i TSRTORD="A",$p(tryrow,"||",2)="" s $p(tryrow,"||",2)=0

	s pass=0,end=0
	f  d  q:pass  q:end
	. ; keep looping until a valid Id is found that passes criteria
	. ; if it's now null - mark it as such!
	. ; if we get the RowID from order comms - assume it has passed the check - don't check it
	. i OrderItemIDs'="" d  s pass=1 q
	. . s tryrow=$p(OrderItemIDs,"^"),OrderItemIDs=$p(OrderItemIDs,"^",2,9999)
	. e  s tryrow=$$GetNext(tryrow)
	. i tryrow="" s end=1 q
	. s pass=$$RowOK($p(tryrow,"||",1,2))
	
	q tryrow
	
GetNext(lastrow)
	;n nextrow
	s nextrow=""
	i TSRTITM="Status" d
	. s statID=$p(lastrow,"||",3)
	. s count=$p(lastrow,"||",4)
	. i statID'="" s statID=$o(^TMP("web",$j,statID),(-1*SortOrd))
	. s found=0
	. f  s statID=$o(^TMP("web",$j,statID),SortOrd) q:statID=""  d  q:found
	. . s count=$o(^TMP("web",$j,statID,count),SortOrd) i count'="" d
	. . . s nextrow=^TMP("web",$j,statID,count)_"||"_statID_"||"_count,found=1	
	e  i TSRTITM="OrderName" d
	. s arcimID=$p(lastrow,"||",3)
	. s count=$p(lastrow,"||",4)
	. i arcimID'="" s arcimID=$o(^TMP("web",$j,arcimID),(-1*SortOrd))
	. s found=0
	. f  s arcimID=$o(^TMP("web",$j,arcimID),SortOrd) q:arcimID=""  d  q:found
	. . s count=$o(^TMP("web",$j,arcimID,count),SortOrd) i count'="" d
	. . . s nextrow=^TMP("web",$j,arcimID,count)_"||"_arcimID_"||"_count,found=1
	e  i TSRTITM="StartDate" d
	. s rowID=$p(lastrow,"||")
	. s itemID=$p(lastrow,"||",2)
	. s dateID=$p(lastrow,"||",3)
	. s timeID=$p(lastrow,"||",4)
	. i rowID'="" s rowID=$o(ordheadlist(rowID),(-1*SortOrd))	
	. f  s rowID=$o(ordheadlist(rowID),SortOrd) q:rowID=""  d  q:found
	. . i SearchDateFrom'="",dateID="" s dateID=SearchDateFrom
	. . ;  $o backwards so we can $o onto the location
	. . i dateID'="" s dateID=$o(^OEORDi(0,"StDtTm1",rowID,dateID),(-1*SortOrd))
	. . s found=0
	. . f  s dateID=$o(^OEORDi(0,"StDtTm1",rowID,dateID),SortOrd) q:dateID=""  d  q:found
	. . . i SearchDateTo'="",dateID>SearchDateTo s found=1 q
	. . . i timeID'="" s timeID=$o(^OEORDi(0,"StDtTm1",rowID,dateID,timeID),(-1*SortOrd))
	. . . f  s timeID=$o(^OEORDi(0,"StDtTm1",rowID,dateID,timeID),SortOrd) q:timeID=""  d  q:found
	. . . . ; check for the first item index - we don't want index '0'
	. . . . i itemID=0,(SortOrd="-1") s itemID=""
	. . . . s itemID=$o(^OEORDi(0,"StDtTm1",rowID,dateID,timeID,itemID),SortOrd) i +itemID'=0 s found=1
	. i itemID'="",itemID'=0 s nextrow=rowID_"||"_itemID_"||"_dateID_"||"_timeID	
	e  i TSRTITM="Priority" d
	. s rowID=$p(lastrow,"||")
	. s itemID=$p(lastrow,"||",2)
	. s prioID=$p(lastrow,"||",3)
	. i rowID'="" s rowID=$o(ordheadlist(rowID),(-1*SortOrd))	
	. f  s rowID=$o(ordheadlist(rowID),SortOrd) q:rowID=""  d  q:found
	. . i SearchPriorityID'="" s itemID=$o(^OEORDi(0,"Priority",rowid,SearchPriorityID,itemID),SortOrd)
	. . e  d
	. . . ; $o backwards so we can $o onto the prio
	. . . i prioID'="" s prioID=$o(^OEORDi(0,"Priority",rowID,prioID),(-1*SortOrd))
	. . . s found=0
	. . . f  s prioID=$o(^OEORDi(0,"Priority",rowID,prioID),SortOrd) q:prioID=""  d  q:found
	. . . . ; check for the first item index - we don't want index '0'
	. . . . i itemID=0,(SortOrd="-1") s itemID=""
	. . . . s itemID=$o(^OEORDi(0,"Priority",rowID,prioID,itemID),SortOrd) i +itemID'=0 s found=1
	. i itemID'="",itemID'=0 s nextrow=rowID_"||"_itemID_"||"_prioID	
	e  i TSRTITM="ReceivLoc" d
	. s rowID=$p(lastrow,"||")
	. s itemID=$p(lastrow,"||",2)
	. s locID=$p(lastrow,"||",3)
	. i rowID'="" s rowID=$o(ordheadlist(rowID),(-1*SortOrd))	
	. f  s rowID=$o(ordheadlist(rowID),SortOrd) q:rowID=""  d  q:found
	. . i SearchLocationID'="" s itemID=$o(^OEORDi(0,"RecDepOrd",rowID,SearchLocationID,itemID),SortOrd)
	. . e  d
	. . . ; $o backwards so we can $o onto the location
	. . . i locID'="" s locID=$o(^OEORDi(0,"RecDepOrd",rowID,locID),(-1*SortOrd))
	. . . s found=0
	. . . f  s locID=$o(^OEORDi(0,"RecDepOrd",rowID,locID),SortOrd) q:locID=""  d  q:found
	. . . . ; check for the first item index - we don't want index '0'
	. . . . i itemID=0,(SortOrd="-1") s itemID=""
	. . . . s itemID=$o(^OEORDi(0,"RecDepOrd",rowID,locID,itemID),SortOrd) i +itemID'=0 s found=1
	. i itemID'="",itemID'=0 s nextrow=rowID_"||"_itemID_"||"_locID	
	e  d
	. ; default, or sort is "DateOrdered"
	. s rowID=$p(lastrow,"||")
	. s itemID=$p(lastrow,"||",2)
	. i rowID'="" s rowID=$o(ordheadlist(rowID),(-1*SortOrd))	
	. s found=0
	. f  s rowID=$o(ordheadlist(rowID),SortOrd) q:rowID=""  d  q:found
	. . ; check for the first item index - we don't want index '0'
	. . i itemID=0,(SortOrd="-1") s itemID=""
	. . s itemID=$o(^OEORD(rowID,"I",itemID),SortOrd) i +itemID'=0 s found=1
	. i itemID'="",itemID'=0 s nextrow=rowID_"||"_itemID
	;
	q nextrow
	;
}
*/
ClassMethod websysSaveChangeLocation(id)
{
}

ClassMethod websysSaveVerifyAll(id)
{
}

/// Log 55973 - PC - 19-12-2005 : Save the selected rows as either "Include in DS Report" or "Exclude From DS Report".
ClassMethod IncludeExcludeDSReport(action As %Library.String = "E", RowIDs As %Library.String = "")
{
}

/// Author - Leon
/// Purpose - To return the patients which have non-excecuted orders with  receiving locaiton as the logon locationn
/// Used By - OEOrdItem.LabReceive
Query FindNonExecutedOrders(TSRTITM, TSRTORD, loc As %String, OrderType As %String, PatientLoc As %String, StartDate As %Date, EndDate As %Date, Incomplete As %String, Priority, LocationList, PAADMType, EpisodeLocation, EpisodeLocationList, PatientLocNow, RegistrationNo) As %Query(CONTAINID = 0, ROWSPEC = "ID,PAPMIName:%String,PAPMIName2:%String,PAPMIName3:%String,EpisodeDate:%Date,EpisodeDept:%String,PatRegNo:%String,DepRow:%String,DOB:%Date,EpisodeNo:%String,PatientDept:%String,OrderList:%String,ArrivalDate:%Date,ArrivalTime:%Time,LabEpisodeNo:%String,CollectionDate:%Date,CollectionTime:%Time,OERowIDs:%String,pat:%String,Room:%String,RecLocation,Priority,EpisLoc,OrderSpecimenID:%String,OrderItem:%String,OrderItemSpecimen:%String,ReasonNotYetCollected:%String,PatLocNow:%String,ResultAvailableDate:%Date,PAPMIName4:%String,PAPMIName5:%String,PAPMIName6:%String,PAPMIName7:%String,PAPMIName8:%String")
{
}

/// unverified and uncollected orders by patient
Query FindUnVerifiedOrders(TSRTITM, TSRTORD) As %Query(CONTAINID = 0, ROWSPEC = "OERowIDs,PAPMIName:%String,PAPMIName2:%String,PAPMIName3:%String,PatRegNo:%String,MRN,DOB:%Date,EpisodeNo:%String,LabEpisodeNo:%String,RecLocation,Priority,OrderItem:%String,OrderCode,PAPMIName4:%String,PAPMIName5:%String,PAPMIName6:%String,PAPMIName7:%String,PAPMIName8:%String")
{
}

/// Author - John Hart
/// Purpose - To fetch the lab orders for a certain Lab Order Profile
/// Used by - EPR
/// Log 43788 - AI - 02-08-2004 : Removed the following 3 ROWSPEC fields from before ResultAvailableDate. They were not being used :
/// 							  ,audittable:%String,auditfieldno:%String,OEORIDateRead:%String.
Query LabEpisodeProfileList(TSRTITM, TSRTORD, patientid As %String, episode As %String, datefrom As %String, EpisodesAll As %String, category As %String, test As %String) As %Library.Query(CONTAINID = 1, ROWSPEC = "ID:%String,LabEpisodeNo:%String,TestSets:%String,OEOrderIDs:%String,DatString:%String,TimString:%String,TestSetsDesc:%String,SequenceString:%String,FillerString:%String,episodeid:%String,LabEpDate:%String,Abnormal:%String,ResultAvailableDate:%Date")
{
}

/// Author - John Hart
/// Purpose - To fetch the lab orders for a certain Lab Order Profile
/// Used by - EPR
Query LabEpisodeTestList(LabOrder As %String, OEOrdItem As %String, TestSet As %String, Dat As %String, Tim As %String, Sequence As %String, markasread As %String, userid As %String) As %Library.Query(CONTAINID = 1, ROWSPEC = "ID:%String,OrderCode:%String,OrderName:%String,TestItem:%String,Flag:%String,Value:%String,Units:%String,RefRange:%String,Comments:%String,OrderTime:%Time,OrderDate:%Date,ResultsRead:%String,Status:%String,EpisodeID:%String,LabOrderCode:%String,TestItemCode:%String,Sensitive:%String,FillerNo:%String,audittable:%String,auditfieldno:%String,SpecimenCDate:%Date,SpecimenCTime:%Time,SpecimenADate:%Date,SpecimenATime:%Time,StartTime:%Time,StartDate:%Date,ResultDate:%Date,ResultTime:%Time,LabStatusCode:%String,ExternalSystemCode:%String,Counter:%String,OEORIDateRead:%String,TestItemStatus:%String,OtherFlags:%String,FlagValue,ResultAvailableDate:%Date")
{
}

/// Author - John Hart
/// Purpose - To fetch the lab orders for a certain Lab Order Profile
/// Used by - EPR
/// Log 27734 - AI - 04-10-2002 : Added icon definition, "icon", as output.
/// Log 32459 - AI - 07-02-2003 : Added field "PathogenDescription", the description of "Value".
/// Applicable only for pathogens.
Query LabProfileList(TSRTITM, TSRTORD, patientid As %String, episode As %String, datefrom As %String, dateto As %String, EpisodesAll As %String, category As %String, test As %String, resultstatus As %String, priority As %String, OrdCategory As %String, orderitem As %String, orderstatus As %String, markasread As %String) As %Library.Query(CONTAINID = 1, ROWSPEC = "ID:%String,OrderCode,OrderName,TestItem,Flag,Value,Units,RefRange:%String,Comments:%String,OrderTime:%Time,OrderDate:%Date,ResultsRead:%String,Status:%String,LabEpisodeID:%String,LabOrderCode:%String,TestItemCode:%String,Sensitive:%String,FillerNo:%String,audittable:%String,auditfieldno:%String,EpisodeID:%String,DateCollected:%Date,TimeCollected:%Time,StartDate:%Date,StartTime:%Time,ResultsDate:%Date,ResultsTime:%Time,ArrivedDate:%Date,ArrivedTime:%Time,LabStatusCode:%String,ExternalSystemCode:%String,ResultComment,ResultAction,OrderStatus,Counter,PathogenDescription:%String,OEORIDateRead:%String,TestItemStatus:%String,OtherFlags:%String,FlagValue,OEORITestSetComments:%String,ResultAvailableDate:%Date")
{
}

// note!!!!!!!!!!!!!!!!!!!!!!!!!!!!

// please add any extra rows you include to this query to 'clinicWorklist' query, below, as it also uses 'GetOrderProfileRow'

// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

/// List of orders to be shown in order profile
/// see seloe1^MVBOEIT6 for the PLIST layout.
/// Log 41352 - AI - 16-02-2004 : Add the new subcategories data. Only passed in IDs List.						
Query ProfileList(TSRTITM, TSRTORD, par As %String, dfrom As %String, dto As %String, categ As %String, stat As %String, result As %String, vis As %String, dsfrom As %String, dsto As %String, cptype As %String, hospitallist As %String, EpisodeAll As %String, OrderSubcategories As %String, ExcludeCurrentEpisode As %String) As %Library.Query(CONTAINID = 1, ROWSPEC = "ID,Dosage,Duration,Frequency,FullDetails,OrderName,Instruction,Priority,SequenceNumber,Status,StatusCode,StartDate,Notes,UnitOfMeasure,Paid,PathwayStep,DCDate,DCTime,PatientShare,ExecutionTimes,Specimens,LabEpisNo,OrderType,OrderCat,OrderMsg,DefDurID,OEItemMstID,OrderDoc,ReceivLoc,Group,DateOrdered,TimeOrdered,SpecimenCDate,SpecimenCTime,LabRecDate,LabRecTime,LUUser,LUTime,LUDate,MealTime,Modifiers,RadStatus,RefDoctor:%String,MealType:%String,SpecimenADate,SpecimenATime,StartTime,DayBookAccNums,DayBookSpecs,EpisodeID,LinkedTo,LinkedToItmID,LinkedArcimID,OrdItmEpisodeID,RadSeriesNo:%String,VarianceReason:%String,OrdEndDate:%String,OrdEndTime:%String,Alerts:%String,ReasonForOverride:%String,AuthorisingClinician:%String, PAADMDEpisDate, PAADMEpisType, PAPMIName, PAPMIName2,PAPMIName3,PAPMIDOB,PAPMISex,PatRegNo,MRN,PAADMConsDR,PAADMUnit,PAADMWard, PAADMBed, OrderCode, OrderLink, intMRN, TotalDosage, Hospital, Specialty, CollectedBy:%String,StartHour,ExeTime,ExeDate,DCUser,Quantity,PAADMRoom,DocumentList:%String,mradmdr,ResultAvailableDate:%Date,Ingredients,PharmacyStatus,PrescriptionNo,ToothLocation,drugDESC,OrderNotes:%String,OrderSet:%String,PAADMEpisNo:%String,DiscClasDesc,GenDrugDetails,Payor,Plan,Price,OverrideRowID,PrioColour,PAPMIName4,PAPMIName5,PAPMIName6,PAPMIName7,PAPMIName8,TestItemResult,DateExecuted,TimeExecuted,PRNMaxDose,PRNTotalDoses,PRNIndication,CollByPatRep,TIAnaOperationNo,TIAnaestNo,NoResultReas,MaxRep,QuestionnaireID,AdmRoute,DrugRoute,ShowDispChangeLink,ExecDoctor,OEORIBilled,OEORIDSReportFlag,Repeat,OEOrdExecID,VIPStatus,lastPRN,HasNotes,AdminFlowRate,MODesc,MOColor,SingleAdmin,UserAddHosp,DrugForm,DrugStrength,ObservationGroupDR,AdminQuestionnDR,STATCode,AnnotationLink,IVType,LinkedDiag,PrescriptionNoLink,OkToAdminister,UserAdd")
{
}

}
