Class web.PAWaitingListRB Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 188;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

ClassMethod SetWLStatusToDone(WaitingListID As %Library.String)
{
}

ClassMethod WaitListRBChangeStatus(WaitingListID As %Library.String, OEOrdItemID As %Library.String, OrdItemStatus As %Library.String)
{
}

ClassMethod WaitListRBSetAppt(OEOrdItemID As %Library.String)
{
}

ClassMethod WebSysSaveRBList(TEvent As %Library.String, WaitingListID As %Library.String, RBRowID As %Library.String, RBAuxInsType As %Library.String, RBCTLOC As %Library.String, RBInsType As %Library.String, RBService As %Library.String, RBServKey As %Library.String, RBStatus As %Library.String, RBType As %Library.String)
{
}

ClassMethod checkservicesExist(WaitingListId As %Library.String) As %Library.Boolean
{
}

ClassMethod websysSaveOEOrdItemList(WaitingListID As %Library.String, OEOrdItemID As %Library.String)
{
}

ClassMethod websysSaveWaitingListRB(WaitingListID As %Library.String, rbflag As %Library.String)
{
}

Parameter SQLCODE = "RB_RowId";

Parameter SQLDESCRIPTION = "RB_RowId";

Parameter SQLROWID = "RB_RowId";

Query GetDetailsByWaitingListID(WaitingListID As %String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,AuxInsType,Childsub,CTLOC,InsType,ServiceKey,Service,Status,RBType,RBOEORIDR,OEORIItmMastDR")
{
SELECT RB_RowId,RB_AuxInsType_DR->AUXIT_Desc,RB_Childsub,RB_CTLOC_DR->CTLOC_Desc,RB_InsType_DR->INST_Desc,RB_ServiceKey,RB_Service_DR->SER_Desc,RB_Status_DR->WLS_Desc,RB_Type_DR->WLT_Desc,RB_OEORI_DR,RB_OEORI_DR->OEORI_ItmMast_DR->ARCIM_RowId
FROM SQLUser.PA_WaitingListRB
WHERE RB_ParRef = :WaitingListID
}

}
