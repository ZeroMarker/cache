Class web.ORAnaestOperation Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 413;

Parameter SQLCODE = "ANAOP_RowId";

Parameter SQLDATEFROM = "ANAOP_TorniquetDateFrom";

Parameter SQLDATETO = "ANAOP_TorniquetDateTo";

Parameter SQLDESCRIPTION = "ANAOP_RowId";

Parameter SQLROWID = "ANAOP_RowId";

ClassMethod GetSurgPref(id As %Library.String) As %Boolean
{
}

ClassMethod ReverseStatus(id As %Library.String)
{
}

ClassMethod DiscontinueOrder(id As %String = "")
{
}

/// Invoked before websysSave - can be used to cancel the save.<br>
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

/// Default save method used for updating the database for Components of type Edit.<br>
/// <br>
/// The compref is the  component reference which is the string from which we can deduce the instance of<BR>
/// websysComponent<BR>
/// websysComponentItem<BR>
/// id is the id for the instance of class we wish to update.
ClassMethod websysSave(compref As %String = "", id As %String = "")
{
}

ClassMethod addorder(id As %String = "", oper As %String = "", stdate As %String = "", loc As %String = "", opbill As %String = "", opstime As %String = "", opedate As %String = "", opetime As %String = "", surg As %String = "")
{
}

Query XGetOperationDetails(ParRef, EpisodeID) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ID,ANAOPParRef,ANAOPNo,ANAOPDeptOp,ANAOPOpEndDate,ANAOPOpEndTime,ANAOPOpStartDate,ANAOPOpStartTime,ANAOPSurgeon,ANAOPType,ANAOPEffectiveElective,ANAOPConsultant,ANAOPHospital,ANAOPAnaesthetic")
{
SELECT ANAOP_RowId,ANAOP_Par_Ref,ANAOP_No,ANAOP_Depar_Oper_DR->CTLOC_Desc,ANAOP_OpEndDate,ANAOP_OpEndTime,ANAOP_OpStartDate,ANAOP_OpStartTime,ANAOP_Surgeon_DR->CTPCP_Desc,ANAOP_Type_DR->OPER_Desc,ANAOP_EffectiveElective,ANAOP_Surgeon_DR->CTPCP_Desc,ANAOP_CTLOC_DR->CTLOC_Desc,ANAOP_Par_Ref->ANA_Anaesthetist_DR->CTPCP_Desc
FROM SQLUser.OR_Anaest_Operation
WHERE ((ANAOP_Par_Ref=:ParRef) AND (:ParRef IS NOT NULL)) 
OR 	((ANAOP_Par_Ref->ANA_PAADM_ParRef=:EpisodeID) AND (:EpisodeID IS NOT NULL))
ORDER BY ANAOP_No
}

ClassMethod GetOperationDetailsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = GetOperationDetailsFetch ]
{
}

ClassMethod GetOperationDetailsExecute(ByRef QHandle As %Library.Binary, PARREF As %String, EpisodeID As %Library.String) As %Library.Status
{
}

ClassMethod GetOperationDetailsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = GetOperationDetailsExecute ]
{
}

Query GetOperationDetails(PARREF, EpisodeID) As %Library.Query(CONTAINID = 0, ROWSPEC = "ID,ANAOPParRef,ANAOPNo,ANAOPDeptOp,ANAOPOpEndDate,ANAOPOpEndTime,ANAOPOpStartDate,ANAOPOpStartTime,ANAOPSurgeon,ANAOPType,ANAOPEffectiveElective,ANAOPConsultant,ANAOPHospital,ANAOPAnaesthetic,ANAOPMethod,ANAOPStatus,ANAOPOperType,SPPPDesc,ANAOPProcedure,ANARBOperatingRoomDR,ANAOPPostOperInstructions")
{
}

/// Returns a 0 or 1 depending on if there is data in the child tables
ClassMethod FindLinksStatus(id As %Library.String)
{
}

ClassMethod GetNextOperation(AnaOperID As %Library.String, RBOperRoomID As %Library.String) As %Library.String
{
}

ClassMethod GetPrevOperation(AnaOperID As %Library.String) As %Library.String
{
}

}
