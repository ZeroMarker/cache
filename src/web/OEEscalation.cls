/// Log 37260 - AI - 21-08-2003 : Class created to List and Update Result Escalations.
Class web.OEEscalation Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 369;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "OEESC_RowId";

Parameter SQLDESCRIPTION = "OEESC_RowId";

Parameter SQLROWID = "OEESC_RowId";

Property dummy As %String(TRUNCATE = 1);

/// Simply returns if the Patient has a Result that has been Escalated.
ClassMethod FindIfEpisodeHasEscalatedResult(EpisodeID As %Library.String) As %Library.Integer
{
}

ClassMethod Escalate(time As %Library.Time) As %Library.Integer
{
}

ClassMethod FindByEpisodeClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindByEpisodeExecute ]
{
}

ClassMethod FindByEpisodeExecute(ByRef QHandle As %Binary, EpisodeID As %String) As %Status
{
}

ClassMethod FindByEpisodeFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindByEpisodeExecute ]
{
}

Query FindByEpisode(EpisodeID As %String) As %Query(ROWSPEC = "ID:%String,OEESCOrderItemDR:%String")
{
}

/// The EpisodeID travels OEEscalation->OEOrdItem->OEOrder->PAAdm
Query Find(EpisodeID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,OEESCEscalationDate:%Date,OEESCEscalationTime:%Time,ESCDesc:%String,OEESCContactMethod:%String,CTPCPDesc:%String,HeadOfDeptGroup:%String")
{
SELECT OEESC_RowId,
 OEESC_EscalationDate, 
 OEESC_EscalationTime,
 OEESC_EscalationLevel_DR->ESC_Code,
 OEESC_ContactMethod,
 OEESC_MainCareProvider_DR->CTPCP_Desc,
 OEESC_HeadOfDeptGroup_DR->CTPCP_Desc
FROM SQLUser.OE_Escalation
WHERE (OEESC_OrderItem_DR->OEORI_OEORD_ParRef->OEORD_Adm_DR->PAADM_RowID = :EpisodeID)
}

Query FindByOrderID(OrderID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,OEESCEscalationDate:%Date,OEESCEscalationTime:%Time,ESCDesc:%String,OEESCContactMethod:%String,CTPCPDesc:%String,OEESCHeadOfDeptDR:%String,OEESCHeadOfDivisionDR:%String,OEESCMedicalSuperintendentDR:%String,OEESCServiceProvider:%String,OEESCHeadOfDeptGroup:%String")
{
SELECT OEESC_RowId,
 OEESC_EscalationDate, 
 OEESC_EscalationTime,
 OEESC_EscalationLevel_DR->ESC_Code,
 OEESC_ContactMethod,
 OEESC_MainCareProvider_DR->CTPCP_Desc,
 OEESC_HeadOfDept_DR->SSUSR_Name,
 OEESC_HeadOfDivision_DR->CTPCP_Desc,
 OEESC_MedicalSuperintendent_DR->CTPCP_Desc,
 OEESC_ServiceProvider,
 OEESC_HeadOfDeptGroup_DR->CTPCP_Desc
FROM SQLUser.OE_Escalation
WHERE (OEESC_OrderItem_DR = :OrderID)
}

}
