Include webimport

IncludeGenerator webimport

Class web.ARCInsuranceType Extends (%Library.RegisteredObject, websys.Abstract) [ Not Abstract, ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 490;

Parameter SQLCODE = "INST_Code";

Parameter SQLDATEFROM = "INST_DateFrom";

Parameter SQLDESCRIPTION = "INST_Desc";

Parameter SQLDATETO = "INST_DateTo";

Parameter SQLROWID = "INST_RowId";

Property dummy As %String(TRUNCATE = 1);

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod LookUpBrokerAOld(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

ClassMethod LookUpBrokerA(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

ClassMethod LookUpBrokerAll3(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", val3 As %Library.String = "", accflag As %Library.String = "", PanelType As %Library.String = "") As %Library.Boolean
{
}

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod LookUpBrokerByCategoryOld(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", date As %Date = "") As %Library.Boolean
{
}

ClassMethod LookUpBrokerByCategory(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", date As %Date = "") As %Library.Boolean
{
}

ClassMethod LookUpBrokerWLOld(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

ClassMethod LookUpBrokerWL(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

/// KK 16/Sep/2002 Log 28251 Lookup Query for Payor Group(Inst_code3) for St.Andrews
ClassMethod LookUpBrokerInstCode3(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "")
{
}

/// KK 09/Oct/2002 Log 28251 Lookup Broker for Payor
ClassMethod LookUpBrokerPayorInstCode3Old(itmjs As %Library.String = "", itmjsex As %Library.String = "", desc As %Library.String, val As %Library.String = "")
{
}

ClassMethod LookUpBrokerPayorInstCode3(itmjs As %Library.String = "", itmjsex As %Library.String = "", desc As %Library.String, val As %Library.String = "")
{
}

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod LookUpBySGroupBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", userid As %Library.String = "", locid As %Library.String = "", PayorRestriction As %Library.String = "", admType As %Library.String = "", PanelTypeRestriction As %Library.String = "", Rank As %Library.String = "", InpatAdmType As %Library.String = "", date As %Date = "") As %Library.Boolean
{
}

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod LookUpBrokerPanelType2Old(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", PanelType As %Library.String = "") As %Library.Boolean
{
}

ClassMethod LookUpBrokerPanelType2(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", PanelType As %Library.String = "") As %Library.Boolean
{
}

ClassMethod LookUpBySecurityGroupClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpBySecurityGroupFetch ]
{
}

ClassMethod LookUpBySecurityGroupExecute(ByRef QHandle As %Library.Binary, desc As %Library.String, userid As %Library.String, locid As %Library.String, PayorRestriction As %Library.String = "", admType As %Library.String = "", PanelTypeRestriction As %Library.String = "", Rank As %Library.String = "", InpatAdmType As %Library.String = "", date As %Library.String = "") As %Library.Status
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
ClassMethod LookUpWithPanelTypeExecute(ByRef QHandle As %Library.Binary, val As %Library.String, Rank As %Library.String = "", InpatAdmType As %Library.String = "", date As %Date = "") As %Library.Status
{
}

/// Default implementation of LookUp Query.
ClassMethod LookUpWithPanelTypeFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpWithPanelTypeExecute ]
{
}

ClassMethod getCodeFromDesc(desc As %Library.String) As %Library.String
{
}

/// KM 3-Aug-2001: Query was changed (from below) to include LookUps by Code as well as Description.
/// SELECT	 INST_Desc,INST_Code
/// FROM	   ARC_InsuranceType
/// WHERE	  (INST_Category = "Private") AND (INST_Desc %STARTSWITH :desc)
/// 
Query LookUpByCategory(desc As %String, date As %Date = "") As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "Payor:%String,HIDDEN:%String,Code:%String")
{
	SELECT  INST_Desc,INST_RowId,INST_Code
	FROM    ARC_InsuranceType
	WHERE   (INST_Category = 'Private')
	AND ((INST_Desc %STARTSWITH :desc) OR (INST_Code= :desc))
	AND ((INST_DateFrom <= :date OR INST_DateFrom IS NULL) AND (INST_DateTo >= :date OR INST_DateTo IS NULL))
}

Query LookUpByCodeOrDesc(val As %String, date As %Date = "") As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "payor,payorID,code,HIDDEN,HIDDEN")
{
	SELECT  INST_Desc, INST_RowId,INST_Code,INST_Category,INST_PayMode_DR->CTPM_Desc
	FROM    SQLUser.ARC_InsuranceType
	WHERE    ((INST_Desc %STARTSWITH :val) OR (INST_Code %STARTSWITH :val))
	AND (((INST_DateFrom  <= :date) OR (INST_DateFrom  IS NULL)) 
	AND ((INST_DateTo >= :date) OR (INST_DateTo  IS NULL)))
	ORDER BY INST_Desc
}

/// KK 16/Sep/2002 Log 28251 Lookup Query for Payor Group(Inst_code3) for St.Andrews
Query LookUpByInstCode3(val As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "code:%String")
{
SELECT  DISTINCT INST_Code3
FROM  SQLUser.ARC_InsuranceType
WHERE  (%UPPER INST_Code3 %STARTSWITH %UPPER :val)
}

Query LookUpByPayor(val As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "payor:%String,code:%String")
{
SELECT  INST_Desc,INST_Code
FROM  SQLUser.ARC_InsuranceType
WHERE  ((%UPPER INST_Desc %STARTSWITH %UPPER :val) OR (%UPPER INST_Code %STARTSWITH %UPPER :val))
AND	(INST_AccountClass IS NOT NULL)
}

/// A specialised search requested by Austin & Repat
/// 
/// LOG 25584
Query LookUpByResCodeOrDesc(val As %String, date As %Date = "") As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "payor,payorID,code,HIDDEN,HIDDEN")
{
	SELECT  INST_Desc, INST_RowId,INST_Code,INST_Category,INST_PayMode_DR->CTPM_Desc
	FROM    SQLUser.ARC_InsuranceType
	WHERE    ((INST_Desc %STARTSWITH :val) OR (INST_Code %STARTSWITH :val))
	AND 	(INST_AccountClass is not NULL)
	AND (((INST_DateFrom  <= :date) OR (INST_DateFrom  IS NULL)) 
	AND ((INST_DateTo >= :date) OR (INST_DateTo  IS NULL)))
	ORDER BY INST_Desc
}

Query LookUpBySecurityGroup(desc As %String, userid As %String, locid As %String, PayorRestriction, PAADMType, PanelTypeRestriction, Rank As %String, InpatAdmType As %String, date As %String = "") As %Library.Query(CONTAINID = 2, ROWSPEC = "payor:%String,HIDDEN,code:%String,HIDDEN,HIDDEN")
{
}

/// KK 09/Oct/2002 Log 28251 Lookup Query for Payor Group(Inst_code3) for St.Andrews
Query LookUpPayorByInstCode3(desc As %String, val As %String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT INST_Desc, INST_RowId,INST_Code
FROM ARC_InsuranceType
WHERE ((%UPPER INST_Code3 = %UPPER :val)  OR (:val IS NULL))
AND ((INST_Desc %STARTSWITH :desc) OR (INST_Code= :desc))
}

Query LookUpWithPanelType(val As %String, Rank As %String, InpatAdmType As %Library.String = "", date As %Date = "") As %Library.Query(CONTAINID = 0, ROWSPEC = "payor,payorID,code,category,mode")
{
}

Query LookUpWithPanelType2(val As %String, accflag As %Library.String = "", val3 As %Library.String = "", PanelType As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT	INST_Desc,INST_RowId,INST_Code
FROM	SQLUser.ARC_InsuranceType
WHERE ((%UPPER INST_Desc %STARTSWITH %UPPER :val) OR (%UPPER INST_Code %STARTSWITH %UPPER :val) OR (:val IS NULL))
AND ((:PanelType[INST_Category) OR (:PanelType IS NULL))
}

Query LookUpWL(desc As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "Payor:%String,Code:%String")
{
	SELECT	INST_Desc,INST_Code
	FROM	SQLUser.ARC_InsuranceType
	WHERE	((%UPPER INST_Desc %STARTSWITH %UPPER :desc) OR (%UPPER INST_Code %STARTSWITH %UPPER :desc))
	AND 	(INST_Code3 IS NOT NULL) AND ((CURRENT_DATE < INST_DateTo) OR (INST_DateTo IS NULL))
}

}
