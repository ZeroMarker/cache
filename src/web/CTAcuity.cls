Class web.CTAcuity Extends (%Library.Persistent, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 133;

Parameter SQLDATEFROM = "CTACU_DateFrom";

Parameter SQLDATETO = "CTACU_DateTo";

Parameter SQLCODE = "CTACU_Code";

Parameter SQLDESCRIPTION = "CTACU_Desc";

Parameter SQLROWID = "CTACU_RowId";

Parameter SQLFILTER = "((CTACU_DateFrom <= CURRENT_DATE OR CTACU_DateFrom IS NULL) AND (CTACU_DateTo >= CURRENT_DATE OR CTACU_DateTo IS NULL))";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod GetEmergencyColours(ByRef dataList As %Library.String)
{
}

/// ab 7.04.05 46451 - returns colour code for priority
ClassMethod GetColour(cat As %String = "")
{
}

ClassMethod GetEpisodeColour(ID As %Library.String, ByRef priorityCTColourLIST As %Library.String)
{
}

/// KM 4-Sept-2002: Changed from following code so that it now works with the new IconProfile stuff.
/// 	n obj,str
/// 	s str=""
/// 	q:ID="" str
/// 	
/// 	s obj=##Class(User.CTAcuity).%OpenId(ID,0)
/// 	i obj {
/// 		s image=obj.CTACUIconName
/// 		s description=obj.CTACUDesc
/// 		s priority="!"  ;highest priority
/// 		i image'="" s str=image_"^"_description_"^"_priority
/// 	}
/// 	q str
/// 
ClassMethod GetImage(ID As %Library.String, PARAMS As %Library.String, ByRef imgLIST As %Library.String)
{
}

/// KM 13-Nov-2001: Called From component PACBedAdm.Edit
ClassMethod GetTriageDetails(EpisodeID As %Library.String, ByRef TriageDate As %Library.Date, ByRef TriageTime As %Library.Time, ByRef PriorityID As %Library.String, ByRef PriorityCode As %Library.String, ByRef PriorityDesc As %Library.String) As %Library.String
{
}

/// Basic query returning description from a partial description, ordered by description.
/// Compiled will attempt to derive the 'description' property from available properties unless it is explicity
/// set in the SQLDESCRIPTION parameter.
/// SQLROWID may be used to specify the field name to be used as rowid.
Query LookUpWithDate(desc As %String, date As %String) As %SQLQuery(CONTAINID = 2, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT CTACU_Desc,CTACU_RowID,CTACU_Code
FROM SQLUser.CT_Acuity
WHERE ((%ALPHAUP CTACU_Desc %STARTSWITH %ALPHAUP :desc) OR (%ALPHAUP CTACU_Code = %ALPHAUP :desc))
AND ((:date IS NULL) OR ((CTACU_DateFrom <= :date OR CTACU_DateFrom IS NULL) AND  (CTACU_DateTo IS NULL OR CTACU_DateTo >= :date)))
ORDER   BY CTACU_Desc
}

ClassMethod LookUpBrokerWithDate(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %String = "", date As %String = "") As %Boolean
{
}

Query LookUpWithDateNC(desc As %String, date As %String) As %SQLQuery(CONTAINID = 2, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String,HIDDEN:%String")
{
SELECT CTACU_Desc,CTACU_RowID,CTACU_Code,CTACU_NationalCode
FROM SQLUser.CT_Acuity
WHERE ((%ALPHAUP CTACU_Desc %STARTSWITH %ALPHAUP :desc) OR (%ALPHAUP CTACU_Code = %ALPHAUP :desc))
AND ((:date IS NULL) OR ((CTACU_DateFrom <= :date OR CTACU_DateFrom IS NULL) AND  (CTACU_DateTo IS NULL OR CTACU_DateTo >= :date)))
ORDER   BY CTACU_Desc
}

ClassMethod LookUpBrokerWithDateNC(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %String = "", date As %String = "") As %Boolean
{
}

Query LookUpDescCode(desc As %String) As %SQLQuery(CONTAINID = 2, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String,HIDDEN:%String")
{
SELECT CTACU_Desc,CTACU_RowID,CTACU_Code,CTACU_NationalCode
FROM SQLUser.CT_Acuity
WHERE ((%ALPHAUP CTACU_Desc %STARTSWITH %ALPHAUP :desc) OR (%ALPHAUP CTACU_Code = %ALPHAUP :desc))
AND ((:date IS NULL) OR ((CTACU_DateFrom <= :date OR CTACU_DateFrom IS NULL) AND  (CTACU_DateTo IS NULL OR CTACU_DateTo >= :date)))
ORDER   BY CTACU_Code
}

}
