Class web.PAAdmInsurance Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 475;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "INS_AuthorizationCode";

Parameter SQLDESCRIPTION = "INS_RowId";

Parameter SQLROWID = "INS_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

/// CJB 30/05/2003 - 35806: Dates for account variations overlap
ClassMethod CheckDates(compref As %String, id As %String)
{
}

ClassMethod FindIfLinksDataPAAdmInsEdit(InsuranceID As %Library.String)
{
}

/// CJB 24/03/2003 - 29244
ClassMethod GetAdmissionPayor(EpisodeID As %Library.String)
{
}

/// CJB 22/09/2003 38852
ClassMethod GetAllPayors(EpisodeID As %Library.String)
{
}

ClassMethod GetByEpisodeIDClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = GetByEpisodeIDFetch ]
{
}

ClassMethod GetByEpisodeIDExecute(ByRef QHandle As %Library.Binary, EpisodeID As %Library.String) As %Library.Status
{
}

ClassMethod GetByEpisodeIDFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = GetByEpisodeIDExecute ]
{
}

/// CJB 08/04/2003 - log 32231
ClassMethod GetCompensable(EpisodeID As %Library.String, cats As %Library.String = "")
{
}

/// cjb 11/11/2004 46893 - re-written method, catering for the Episode Payor Configuration
/// this method is called from the payorCategory (hidden) item on PAAdm.Edit only.  If other items call it, it will screw up...
ClassMethod GetDetails(EpisodeID As %Library.String)
{
}

ClassMethod GetPatientInsDetails(PatientID As %Library.String = "")
{
}

/// CJB 08/04/2003 - log 32231
/// this method is called from the payorCategory (hidden) item on PAAdm.Edit only.  If other items call it, it will screw up...
ClassMethod GetDetailsOLD(EpisodeID As %Library.String)
{
}

/// cjb 21/10/2004 46893 - get the PayorConfig (sys params / billing / Episode Payor Config) from the admission type
/// w ##class(web.PAAdmInsurance).GetEpisodePayorConfig(1)
/// BLC_PatientInsSettings
ClassMethod GetEpisodePayorConfig(EpisodeID As %Library.String)
{
	n PayConfig,inspat,admobj,admType
	s PayConfig=""
	s admobj=##class(User.PAAdm).%OpenId(EpisodeID)

	if $IsObject(admobj) {
		s admType=admobj.PAADMType
		s inspat=$O(^BLC("INSPAT",0,"PatType",admType,0))
		if inspat'="" {
			s PayConfig=$P($g(^BLC("INSPAT",inspat)),"^",2)
		}
		d admobj.%Close()
		s admobj=""
	}
	Quit PayConfig
}

ClassMethod GetPayorForEpisode(EpisodeID As %Library.String)
{
}

ClassMethod GetPlansByEpisodeIDClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = GetPlansByEpisodeIDFetch ]
{
}

ClassMethod GetPlansByEpisodeIDExecute(ByRef QHandle As %Library.Binary, PlanDesc As %Library.String, EpisodeID As %Library.String) As %Library.Status
{
}

ClassMethod GetPlansByEpisodeIDFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = GetPlansByEpisodeIDExecute ]
{
}

ClassMethod GetPlansByEpisodeIDBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", EpisodeID As %Library.String) As %Library.Boolean
{
}

ClassMethod GetPayorsByEpisodeIDBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", EpisodeID As %Library.String = "") As %Library.Boolean
{
}

ClassMethod GetPayorsByEpisodeIDClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = GetPayorsByEpisodeIDFetch ]
{
}

ClassMethod GetPayorsByEpisodeIDExecute(ByRef QHandle As %Library.Binary, val As %Library.String, EpisodeID As %Library.String) As %Library.Status
{
}

ClassMethod GetPayorsByEpisodeIDFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = GetPayorsByEpisodeIDExecute ]
{
}

ClassMethod UpdateRank(id As %Library.String, rank As %Library.String)
{
}

/// CJB 15/09/2003 38747
ClassMethod PatientPaymentAgreement(PatientID As %Library.String)
{
}

/// cjb 01/02/2005 46824
ClassMethod CopyPreviousDetails(PatientID As %Library.String)
{
}

/// JW:23/10/02
/// 
/// not presently used.
ClassMethod setPreviousDetails(prevadm As %Library.String, EpisodeID As %Library.String)
{
}

ClassMethod ValidateCodeTableDates(compid As %String, id As %String = "") As %String
{
}

/// CJB 16/06/2003 - 32871: QH Billing 5.34: Admission Type / Payor check
ClassMethod ValidateIPAdmType(compref As %String, id As %String)
{
}

/// Invoked after websysSave - can be used to provide extra websysSave functionality while keeping the default websysSave behaviour.
ClassMethod websysAfterSave(compref As %String, ByRef id As %String, new As %Boolean) As %Library.Boolean
{
}

/// Invoked before websysSave - can be used to cancel the save.<br>
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

ClassMethod Copy(compref As %String, insrowid As %Library.String, EpisodeID As %Library.String)
{
}

/// 1/10/02 Log#28049 HP: Changed from standard query due to addition of insurance contacts
/// Log 64663 - 27.09.2007 - 2 new out parameters INSTimeFrom and INSTimeTo
Query GetByEpisodeID(EpisodeID As %Library.String) As %Library.Query(CONTAINID = 1, ROWSPEC = "ID,InsurPayorID:%String,InsurPayor:%String,InsurPlanID:%String,InsurPlan:%String,InsurOffice:%String,InsurDateValFr:%Date,InsurDateValTo:%Date,InsurCardNo:%String,InsurCardType:%String,assignBill:%String,SafetyNetCardNo:%String,SafetyNetCardExpDate:%String,ConcessionCardNo:%String,ConcessionCardExpDate:%String,DVAnumber:%String,payorCategory:%String,INSExcess,INSPayFrom,INSPayUntill,INSPayorShare,INSFixedPatShare,INSTotalChargeCover,INSStampDutyPercentage,INSCardholderName,INSDailyCover,INSDailyICUCover,INSDateTypeFrom,INSDateTypeTo,INSDailyCopaymentAmt,INSMaxCopaymentAmt,InsurPayorCode,INSRank,insurContacts:%String,INSPayorVariationComments:%String,INSCardInitDate,CTPMDesc:%String,INSAuthorizationCode:%String,INSCoPaymentPercentage:%String,INSMaxAmountPercentage:%String,INSSurmountingAmount:%String,INSSurmountingLimit:%String,INSSurmountingPercentage:%String,INSMinSurmountAmt:%String,INSVCFeeRate:%String,INSAccomRate:%String,INSApplyShareTotalAmount:%String,INSTimeFrom:%Time,INSTimeTo:%Time")
{
}

Query GetIDByEpisode(EpisodeID As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ID")
{
	SELECT INS_Rowid
	FROM SQLUser.PA_AdmInsurance
	WHERE INS_ParRef = :EpisodeID
}

Query GetPlansByEpisodeID(Desc, EpisodeID) As %Library.Query(CONTAINID = 0, ROWSPEC = "InsurPlan,HIDDEN,Code")
{
}

Query GetPayorsByEpisodeID(Desc, EpisodeID) As %Library.Query(CONTAINID = 0, ROWSPEC = "Description,HIDDEN,Code")
{
}

}
