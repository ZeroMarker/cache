Import SQLUser

Class web.DHCPAAdmDischarge Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod PAAdmFinalDischarge(EpisodeID As %String, userId As %String) As %String
{
	//-----------------------------------------------------------
	//
	//(1)	PA_Adm
	//		PAADM_VisitStatus="D"	"Discharged"
	//		PAADM_DischgDate
	//		PAADM_DischgTime
	//		PAADM_DischgDoc_DR
	//		//PAADM_DischCond_DR	PAC_DischCondit
	//(2)	MR_Adm
	//		MRADM_ConditAtDisch_DR	PAC_DischCondit
	//		MRADM_InfectType_DR		PAC_InfectionType
	//		MRADM_OtherInfectType
	//		MRADM_AutopsyType_DR	PAC_AutopsyType
	//		MRADM_DischDestin_DR	PAC_DischargeDestination
	//(3)	PA_PatMas
	//		PAPMI_Decesed
	//		PAPMI_Decesed_Date
	//		PAPMI_Decesed_Time
	//(4)	PAC_BedAdm //delete
	//(5)	PAC_WardAdm //deltete
	//(6)	PA_AdmTransaction //"T"->"D"
	//
	//------------------------------------------------------------
	q:EpisodeID="" "没有选择就诊病人!"
	s ctcpId=$p($g(^SSU("SSUSR",+userId)),"^",14)
	q:ctcpId="" "请用医护人员的身份操作!"
	s curDate=+$h,curTime=$p($h,",",2)
	s visitStatusCode="D"
	&sql(update PA_ADM set PAADM_VisitStatus=:visitStatusCode,
			PAADM_DischgDate=:curDate,PAADM_DischgTime=:curTime,PAADM_DischgDoc_DR=:ctcpId,
			PAADM_UpdateDate=:curDate,PAADM_UpdateTime=:curTime,PAADM_UpdateUser_DR=:useId 
			where PAADM_RowId=:EpisodeID)
	i SQLCODE q "修改病人结算状态错误!"
	s mrAdmId=##Class(web.PAAdm).GetMRAdm($g(EpisodeID)) 
	s disconId=$o(^PAC("DISCON",0,"Code","N",""))
	&sql(update MR_Adm set MRADM_ConditAtDisch_DR=:disconId	where MRADM_RowId=:mrAdmId)
	i SQLCODE q "修改病人出院状态错误!"
	
	//{PAC_Ward.WARD_RowID},"WADM",{WADM_Childsub}
	//0,"RADM",{WADM_PAADM_DR},{PAC_Ward.WARD_RowID},{WADM_Childsub}
	s transId=""
	s wardId=$o(^PAWARDA(0,"WADM",EpisodeID,""))
	i wardId'="" d
	    .s wardSub=$o(^PAWARDA(0,"WADM",EpisodeID,wardId,""))
	    .i wardSub'="" d
	        ..s wadmId=wardId_"||"_wardSub
	        ..s transId=$p(^PAWARDA(wardId,"WADM",wardSub),"^",3)
	        ..&sql(delete from PAC_WardAdm where WADM_RowId=:wadmId)
	s wardId=$o(^PAWARDA(0,"ADM",EpisodeID,""))
	i wardId'="" d
	    .s bedSub=$o(^PAWARDA(0,"ADM",EpisodeID,wardId,""))
	    .i bedSub'="" d
	        ..s admSub=$o(^PAWARDA(0,"ADM",EpisodeID,wardId,bedSub,""))
	        ..i admSub'="" d
	        	...s bedAdmId=wardId_"||"_bedSub_"||"_admSub
	        	...s transId=$p(^PAWARDA(wardId,"BED",bedSub,"ADM",admSub),"^",3)
	        	...&sql(delete from PAC_BedAdm where ADM_RowId=:bedAdmId)
	i SQLCODE q "修改病人病区位置错误!"
	i transId'="" d
		.s reqstId=$o(^PAC("REQST",0,"Code","D",""))
		.&sql(update PA_AdmTransaction set TRANS_Status_DR=:reqstId,TRANS_UpdateDate=:curDate,
		TRANS_UpdateTime=:curTime,TRANS_UpdateUser_DR=:userId where TRANS_RowId=:transId)
	i SQLCODE q "修改病人转科状态错误!"
	//^PAWARDA(0,"ADM",187380,114,9,1)
	//0,"ADM",{ADM_PAADM_DR},{PAC_Ward.WARD_RowID},{PAC_Bed.BED_Childsub},{ADM_Childsub}
	q SQLCODE
}

}
