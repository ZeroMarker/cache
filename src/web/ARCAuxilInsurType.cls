Include webimport

IncludeGenerator webimport

Class web.ARCAuxilInsurType Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 399;

Parameter SQLCODE = "AUXIT_Code";

Parameter SQLDATEFROM = "AUXIT_DateFrom";

Parameter SQLDESCRIPTION = "AUXIT_Desc";

Parameter SQLDATETO = "AUXIT_DateTo";

Parameter SQLROWID = "AUXIT_RowId";

Property dummy As %String(TRUNCATE = 1);

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod LookUpBrokerByPayorA(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", payor As %Library.String = "", patientID As %Library.String = "") As %Library.Boolean
{
}

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod LookUpBrokerByPayorB(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", payor As %Library.String = "", patientID As %Library.String = "", userid As %Library.String = "", locid As %Library.String = "", PanelTypeRestriction As %Library.String = "", Rank As %Library.String = "", InpatAdmType As %Library.String = "", date As %Library.Date = "", payorid As %Library.String = "") As %Library.Boolean
{
}

/// md Log 54405 add criteria INST_Category = "Private"
ClassMethod LookUpBrokerPlan(itmjs As %Library.String = "", itmjsex As %Library.String = "", planDesc As %Library.String = "", payorDesc As %Library.String = "", date As %Date = "")
{
}

/// Default implementation of LookUp Query.
ClassMethod LookUpByPayorAClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpByPayorAFetch ]
{
}

ClassMethod LookUpByPayorAExecute(ByRef QHandle As %Library.Binary, desc As %Library.String, payor As %Library.String, patientID As %Library.String) As %Library.Status
{
}

ClassMethod LookUpByPayorAFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpByPayorAExecute ]
{
}

/// Default implementation of LookUp Query.
ClassMethod LookUpByPayorBOLDClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpByPayorBOLDFetch ]
{
}

ClassMethod LookUpByPayorBOLDExecute(ByRef QHandle As %Library.Binary, desc As %Library.String, payor As %Library.String, patientID As %Library.String, userid As %Library.String, locid As %Library.String, date As %Date = "", hpayorid As %Library.String = "") As %Library.Status
{
}

ClassMethod LookUpByPayorBOLDFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpByPayorBOLDExecute ]
{
}

ClassMethod LookUpByPayorBClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpByPayorBFetch ]
{
}

/// Default implementation of LookUp Query.
ClassMethod LookUpByPayorBExecute(ByRef QHandle As %Library.Binary, desc As %Library.String, payor As %Library.String, patientID As %Library.String, userid As %Library.String, locid As %Library.String, date As %Date = "", hpayorid As %Library.String = "") As %Library.Status
{
}

/// Default implementation of LookUp Query.
ClassMethod LookUpByPayorBFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpByPayorBExecute ]
{
}

ClassMethod LookUpBySecurityGroupClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpBySecurityGroupFetch ]
{
}

ClassMethod LookUpBySecurityGroupExecute(ByRef QHandle As %Library.Binary, desc As %Library.String, payor As %Library.String, PatientID As %Library.String, userid As %Library.String = "", locid As %Library.String = "", PanelTypeRestriction As %Library.String = "", Rank As %Library.String = "", InpatAdmType As %Library.String = "", date As %Library.Date = "", payorid As %String = "") As %Library.Status
{
}

ClassMethod LookUpBySecurityGroupFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpBySecurityGroupExecute ]
{
}

/// Default implementation of LookUp Query.
ClassMethod LookUpWithPanelTypeClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpWithPanelTypeFetch ]
{
}

/// Default implementation of LookUp Query.
ClassMethod LookUpWithPanelTypeExecute(ByRef QHandle As %Library.Binary, desc As %Library.String, payor As %Library.String = "", patientID As %Library.String, userid As %Library.String, locid As %Library.String, Rank As %Library.String, InpatAdmType As %Library.String = "", date As %Library.Date = "", payorid As %String = "") As %Library.Status
{
}

/// Default implementation of LookUp Query.
ClassMethod LookUpWithPanelTypeFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpWithPanelTypeExecute ]
{
}

ClassMethod GetIdFromPlanAndPayor(plan As %String = "", payor As %String = "")
{
}

/// md Log 54405 add criteria INST_Category = "Private"
Query LookUpByPayor(desc As %String, payor As %String, date As %Date = "") As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "Plan:%String,Payor:%String,HIDDEN:%String,HIDDEN:%String")
{
	SELECT AUXIT_Desc, AUXIT_InsType_DR->INST_Desc, AUXIT_RowId, AUXIT_InsType_DR->INST_RowId
	FROM ARC_AuxilInsurType
	WHERE (AUXIT_Desc %STARTSWITH :desc) AND (AUXIT_InsType_DR->INST_Desc %STARTSWITH :payor)
	AND (AUXIT_InsType_DR->INST_Category = 'Private')
	AND (((AUXIT_DateFrom  <= :date) OR (AUXIT_DateFrom  IS NULL)) 
	AND ((AUXIT_DateTo >= :date) OR (AUXIT_DateTo  IS NULL)))
}

Query LookUpByPayorA(desc As %String, payor As %String, patientID As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "Plan:%String,Payor:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String")
{
}

/// This query looks up the Plan limited by the Payor and by the security group
/// of the user
Query LookUpByPayorB(desc As %String, payor As %String, patientID As %String, userid As %String, locid As %String, date As %Date = "", payorid As %String = "") As %Library.Query(CONTAINID = 0, ROWSPEC = "Plan:%String,Payor:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String")
{
}

Query LookUpBySecurityGroup(desc As %String, payor As %String, patientID As %String, userid As %String, locid As %String, PanelTypeRestriction As %String = "", Rank As %String = "", InpatAdmType As %String = "", date As %Date = "", payorid As %String = "") As %Library.Query(CONTAINID = 0, ROWSPEC = "Plan:%String,Payor:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String")
{
}

Query LookUpWithPanelType(desc As %String, payor As %String, patientID As %String, userid As %String, locid As %String, Rank As %String, InpatAdmType As %String = "", date As %Date = "", payorid As %String = "") As %Library.Query(CONTAINID = 0, ROWSPEC = "payor,payorID,code,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String")
{
}

}
