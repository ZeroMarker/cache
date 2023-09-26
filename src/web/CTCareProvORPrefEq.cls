Class web.CTCareProvORPrefEq Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 617;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "EQ_RowId";

Parameter SQLDESCRIPTION = "EQ_RowId";

Parameter SQLROWID = "EQ_RowId";

ClassMethod DeleteAll(idstring As %String)
{
}

ClassMethod RetainValues()
{
}

ClassMethod KickValues()
{
}

ClassMethod GetOrdItemDesc(OpPrefEqID As %String) As %String
{
}

ClassMethod UpdateSeqNo(prefeqid As %String, seqNo As %String, direction As %String)
{
}

/// Delete an instance - this is provided as a wrapper for %DeleteId functionality.
ClassMethod websysDelete(id As %String)
{
}

ClassMethod websysSaveOrdItem(compref As %String, id As %String, orditemidlist As %String)
{
}

ClassMethod websysSaveEquip(compref As %String, id As %String, equipidlist As %String)
{
}

ClassMethod websysSaveStaff(compref As %String, id As %String, staffidlist As %String)
{
}

ClassMethod websysSaveAddOrdItem(compref As %String, lstofids As %String = "", NEQARCIMDR As %String = "", NEQARCOSDR As %String = "", Qnty As %String = "")
{
}

ClassMethod IsExistAsActive(NEQARCIMDR As %String = "", NEQARCOSDR As %String = "", parref As %String) As %Library.Boolean
{
}

ClassMethod AddAllForSearchList(compref As %String, EQARCIMDR As %String = "", EQARCOSDR As %String = "", ORPParRef As %String = "", CareProvParRef As %String = "", SPPPParRef As %String = "", NEQARCIMDR As %String = "", NEQARCOSDR As %String = "", Qnty As %String = "", ANMETParRef As %String = "", rsttp As %String = "")
{
}

ClassMethod GetEntriesForSearchList(compref As %String, EQARCIMDR As %String = "", EQARCOSDR As %String = "", ORPParRef As %String = "", CareProvParRef As %String = "", SPPPParRef As %String = "", lstofids As %String = "", NEQARCIMDR As %String = "", NEQARCOSDR As %String = "", Qnty As %String = "", ANMETParRef As %String = "", rsttp As %String = "")
{
}

ClassMethod websysSaveReplaceOrdItem(compref As %String, lstofids As %String = "", NEQARCIMDR As %String = "", NEQARCOSDR As %String = "", Qnty As %String = "")
{
}

Query LookUpOrderItemsReq(PARREF As %String, keeepcurrent As %String) As %Library.SQLQuery(CONTAINID = 2, ROWSPEC = "OpPrefEqID:%String,ARCIMID:%String,ARCOSID:%String,OrdItemQty:%String,SequenceNo:%String,DateActiveFrom:%String,DateActiveTo:%String,UpdateDate:%String,UpdateTime:%String,UpdateUser:%String")
{
SELECT EQ_RowId,EQ_ARCIM_DR,EQ_ARCOS_DR,EQ_Qty,EQ_SequenceNo,EQ_DateActiveFrom,EQ_DateActiveTo,EQ_UpdateDate,EQ_UpdateTime,EQ_UpdateUser_DR->SSUSR_Initials 
FROM SQLUser.CT_CareProvORPrefEq
WHERE EQ_ParRef =:PARREF
AND ((EQ_ARCIM_DR IS NOT NULL) OR (EQ_ARCOS_DR IS NOT NULL))
AND (
		(
		(:keeepcurrent IS NULL)
		AND
 		((EQ_DateActiveFrom  <= CURRENT_DATE) OR (EQ_DateActiveFrom  IS NULL)) 
		AND
		((EQ_DateActiveTo > CURRENT_DATE) OR (EQ_DateActiveTo  IS NULL))
		)
	OR
	   (
       (:keeepcurrent IS NOT NULL)
       AND
       ((EQ_DateActiveFrom  > CURRENT_DATE) OR (EQ_DateActiveTo <= CURRENT_DATE))))
ORDER BY EQ_SequenceNo
}

Query LookUpOrderItemsReqADV(PARREF As %String, keeepcurrent As %String) As %Library.SQLQuery(CONTAINID = 2, ROWSPEC = "OpPrefEqID:%String,ARCIMID:%String,ARCOSID:%String,OrdItemQty:%String,SequenceNo:%String,DateActiveFrom:%String,DateActiveTo:%String,UpdateDate:%String,UpdateTime:%String,UpdateUser:%String")
{
SELECT EQ_RowId,EQ_ARCIM_DR,EQ_ARCOS_DR,EQ_Qty,EQ_SequenceNo,EQ_DateActiveFrom,EQ_DateActiveTo,EQ_UpdateDate,EQ_UpdateTime,EQ_UpdateUser_DR->SSUSR_Initials 
FROM SQLUser.CT_CareProvORPrefEq
WHERE EQ_ParRef = :PARREF
AND ((EQ_ARCIM_DR IS NOT NULL) OR (EQ_ARCOS_DR IS NOT NULL))
AND ((EQ_DateActiveFrom  <= CURRENT_DATE) OR (EQ_DateActiveFrom  IS NULL))
AND((EQ_DateActiveTo > CURRENT_DATE) OR (EQ_DateActiveTo  IS NULL))
UNION
SELECT EQ_RowId,EQ_ARCIM_DR,EQ_ARCOS_DR,EQ_Qty,EQ_SequenceNo,EQ_DateActiveFrom,EQ_DateActiveTo,EQ_UpdateDate,EQ_UpdateTime,EQ_UpdateUser_DR->SSUSR_Initials 
FROM SQLUser.CT_CareProvORPrefEq
WHERE EQ_ParRef = :PARREF
AND (:keeepcurrent IS NOT NULL)
AND ((EQ_ARCIM_DR IS NOT NULL) OR (EQ_ARCOS_DR IS NOT NULL))
AND ((EQ_DateActiveFrom  > CURRENT_DATE) OR (EQ_DateActiveTo <= CURRENT_DATE))
}

Query LookUpForMod(EQARCIMDR As %String, EQARCOSDR As %String, ORPParRef As %String, CareProvParRef As %String, SPPPParRef As %String) As %Library.SQLQuery(CONTAINID = 2, ROWSPEC = "EQ_RowId:%String,EQ_Qty:%String,EQ_SequenceNo:%String,OPER_Desc:%String,CTPCP_Desc:%String,SPPP_Desc:%String,ARCIM_DR,ARCOS_DR")
{
SELECT EQ_RowId,EQ_Qty,EQ_SequenceNo,EQ_ParRef->ORP_Operation_DR->OPER_Desc,EQ_ParRef->ORP_ParRef->CTPCP_Desc,EQ_ParRef->ORP_RecovStatePPP_DR->SPPP_Desc,EQ_ARCIM_DR,EQ_ARCOS_DR
FROM SQLUser.CT_CareProvORPrefEq
WHERE 
(({fn CONCAT( '^', {fn CONCAT((:CareProvParRef ),'^')})} [ {fn CONCAT( '^', {fn CONCAT((EQ_ParRef->ORP_ParRef),'^')})}) OR (:CareProvParRef IS NULL))
AND
(({fn CONCAT( '^', {fn CONCAT((:ORPParRef),'^')})} [ {fn CONCAT( '^', {fn CONCAT((EQ_ParRef->ORP_Operation_DR),'^')})}) OR (:ORPParRef IS NULL))
AND
(({fn CONCAT( '^', {fn CONCAT((:SPPPParRef),'^')})} [ {fn CONCAT( '^', {fn CONCAT((EQ_ParRef->ORP_RecovStatePPP_DR),'^')})}) OR (:SPPPParRef IS NULL))
AND
(((:EQARCIMDR IS  NULL) OR (EQ_ARCIM_DR=:EQARCIMDR)))
AND (((:EQARCOSDR IS  NULL) OR (EQ_ARCOS_DR=:EQARCOSDR)))
}

Query LookUpEquipmentReq(PARREF As %String) As %Library.SQLQuery(CONTAINID = 2, ROWSPEC = "OpPrefEqID:%String,EquipID:%String,EquipQty:%String")
{
SELECT EQ_RowId,EQ_Equip_DR,EQ_EquipQty 
FROM SQLUser.CT_CareProvORPrefEq
WHERE EQ_ParRef =:PARREF
AND EQ_Equip_DR IS NOT NULL
}

Query LookUpStaffReq(PARREF As %String) As %Library.SQLQuery(CONTAINID = 2, ROWSPEC = "OpPrefEqID:%String,CTPCPID:%String,CarPrvTyp:%String,StaffQty:%String")
{
SELECT EQ_RowId,EQ_CTPCP_DR,EQ_CareProvType,EQ_StaffQty  
FROM SQLUser.CT_CareProvORPrefEq
WHERE EQ_ParRef =:PARREF
AND ((EQ_CTPCP_DR IS NOT NULL) OR (EQ_CareProvType IS NOT NULL))
}

ClassMethod LookUpEqReqClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = LookUpEqReqFetch ]
{
}

ClassMethod LookUpEqReqExecute(ByRef QHandle As %Binary, EQARCIMDR As %String, EQARCOSDR As %String, ORPParRef As %String, CareProvParRef As %String, SPPPParRef As %String, ANMETParRef As %String, rsttp As %String) As %Status
{
}

ClassMethod LookUpEqReqFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpEqReqExecute ]
{
}

Query LookUpEqReq(EQARCIMDR As %String, EQARCOSDR As %String, ORPParRef As %String, CareProvParRef As %String, SPPPParRef As %String, ANMETParRef As %String, rsttp As %String) As %Query(ROWSPEC = "EQRowId:%String,EQQty:%String,EQSequenceNo:%String,OPERDR:%String,CTPCPDesc:%String,SPPPDR:%String,ARCIMDR,ARCOSDR,OperPARRF,AnaestMethodDR,RecovStatePPPDR,RecovOperationDR")
{
}

/// wanghc 先这样写,keeepcurrent? ,History:%String??
Query GetTotal(PARREF As %String, keeepcurrent As %String) As %Library.SQLQuery(CONTAINID = 2, ROWSPEC = "OpPrefEqID:%String,ARCIMID:%String,ARCOSID:%String,OrdItemQty:%String,SequenceNo:%String,DateActiveFrom:%String,DateActiveTo:%String,UpdateDate:%String,UpdateTime:%String,UpdateUser:%String,History:%String")
{
	SELECT EQ_Equip_DR,EQ_ARCIM_DR,EQ_ARCOS_DR,EQ_EquipQty,EQ_SequenceNo,EQ_DateActiveFrom,EQ_DateActiveTo,EQ_UpdateDate,EQ_UpdateTime,EQ_UpdateUser_DR->SSUSR_Name,EQ_CTPCP_DR 
	FROM SQLUSER.CT_CareProvORPrefEq 
	WHERE (EQ_ParRef=:PARREF) OR (:PARREF='')
}

Query FindBulkPrefs(TSRTITM, EQARCIMDR As %String, EQARCOSDR As %String, ORPParRef As %String, CareProvParRef As %String, SPPPParRef As %String, ANMETParRef As %String, RecOperT As %String, OpsOnlyT As %String, recspppT As %String) As %Query(ROWSPEC = "EQRowId:%String,EQQty:%String,EQSequenceNo:%String,OPERDR:%String,CTPCPDesc:%String,SPPPDR:%String,ARCIMDR:%String,ARCOSDR:%String,OperPARRF:%String,AnaestMethodDR:%String,RecovStatePPPDR:%String,RecovOperationDR:%String,CarePDr:%String")
{
}

ClassMethod FindBulkPrefsExecute(ByRef QHandle As %Binary, TSRTITM As %Library.String = "", EQARCIMDR As %String, EQARCOSDR As %String, ORPParRef As %String, CareProvParRef As %String, SPPPParRef As %String, ANMETParRef As %String, RecOperT As %String, OpsOnlyT As %String, recspppT As %String) As %Status
{
}

ClassMethod FindBulkPrefsFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBulkPreferencesExecute ]
{
}

ClassMethod FindBulkPrefsClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindBulkPreferencesFetch ]
{
}

ClassMethod BPRemoveItms(compref As %String, selectedids As %String = "")
{
}

ClassMethod BPReplaceOrdItm(compref As %String, selectedids As %String, NEQARCIMDR As %String, NEQARCOSDR As %String, Qnty As %String)
{
}

ClassMethod BPAddOrdItmToAll(compref As %String, NEQARCIMDR As %String = "", NEQARCOSDR As %String = "", CareProvParRef As %String = "", SPPPParRef As %String = "", ANMETParRef As %String = "", RecOperT As %String = "", OpsOnlyT As %String = "", recspppT As %String = "", Qnty As %String = "", ORPParRef As %String = "")
{
}

ClassMethod BPReplaceAllOrdItm(compref As %String, NEQARCIMDR As %String = "", NEQARCOSDR As %String = "", CurEQARCIMDR As %String, CurEQARCOSDR As %String, CareProvParRef As %String = "", SPPPParRef As %String = "", ANMETParRef As %String = "", RecOperT As %String = "", OpsOnlyT As %String = "", recspppT As %String = "", Qnty As %String = "", ORPParRef As %String = "")
{
}

ClassMethod BPRemoveAllOrdItm(compref As %String, CurEQARCIMDR As %String, CurEQARCOSDR As %String, CareProvParRef As %String = "", SPPPParRef As %String = "", ANMETParRef As %String = "", RecOperT As %String = "", OpsOnlyT As %String = "", recspppT As %String = "", ORPParRef As %String = "")
{
}

ClassMethod BPAddOrdItem(compref As %String, selectedids As %String, NEQARCIMDR As %String, NEQARCOSDR As %String, Qnty As %String)
{
}

ClassMethod BPperformAction(compref As %String)
{
}

ClassMethod NotChangedMessage(NotChangedOpPrefs As %String, actPerformed As %String, NEQARCIMDR As %String = "", NEQARCOSDR As %String = "", CurEQARCIMDR As %String = "", CurEQARCOSDR As %String = "")
{
}

}
