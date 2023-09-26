/// Description: control W/R permission of result input and summarize.
/// -------------
/// Description: add function 
/// 
Class web.DHCPE.ResultPermission Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Parameter BUILD = 1;

/// Parameter:
/// 				ModelType: 0-"StationInput", 1-"GeneralSummarize"
/// Return:  	"":none, "R":read, "W":write
/// Description: 
/// 				GeneralPermission :  ->have chart Permission-> IsAGeneralSummarize User -> Status is not Audit
/// 				StationResult:		 ->have chart Permission->have Write permission (hasn;t exit) -> just the Status and whether user is a generalSummerizeUser.
/// Test: 		w ##class(web.DHCPE.ResultPermission).GetPermission(2873,433345,0,62)
ClassMethod GetPermission1(UserId As %String, PAAdmId As %String, ModelType As %Integer, ChartId As %String) As %String
{

	s groupId="", readable="", writable="", stationId="", statusVal="",myCount=0
	&sql(select SSUSR_Group into :groupId from SQLUSER.ss_user where ssusr_Rowid=:UserId)
	&sql(select count(*), max(GC_Read), max(GC_Write) into :myCount ,:readable, :writable 
			from SQLUSER.DHC_PE_GroupChart 
			where gc_ssgrp_dr=:groupId and gc_chart_dr=:ChartId)
	b:(($g(groupId)="")||(myCount=0))
	q:(writable="N") "R"
	q:PAAdmId="" "R"
	s IAdmId=$o(^DHCPEIADM(0,"PAADM",PAAdmId,""))
	q:IAdmId="" ""
	s CurLoc=$P($G(^PAADM(PAADM)),"^",4)
	s GSGrpIds=^DHCPESetting("DHCPE","SSGroup_SummarizeAudit",GSGrpIds)
	//s GSGrpIds=^DHCPESetting("DHCPE","SSGroup_SummarizeAudit")

	if (ModelType=0){

		s stationId=##class(web.DHCPE.ResultEdit).GetPEStation(ChartId)
		q:($g(stationId)="") ""
		Set StationType=##class(web.DHCPE.Public.Setting).GetStationType(stationId)
		Quit:StationType="Lab" "R"
		s statusVal=""
		&sql(select ss_Status into :statusVal from sqluser.DHC_PE_StationSummarize where ss_IADM_dr=:IAdmId and ss_ST_dr=:stationId)
		Q:((statusVal="SA")&&(GSGrpIds'[(","_groupId_","))) "R"  //已科室审核，用户又不是总检医生
		
		s GStatus=..GetGeneAdviserStatus(PAAdmId)
		q:(GStatus="Audited") "R"	//已总检审核	
		s ^lisatest("20080320","groupId")=groupId_"^"_myCount
		q:(($g(groupId)="")||(myCount=0)) ""	
		q "W"
	}
	if (ModelType=1){
		q:(GSGrpIds'[(","_groupId_",")) "R"
		
		s GStatus=..GetGeneAdviserStatus(PAAdmId)
		q:(GStatus="Audited") "R"
		q:(($g(groupId)="")||(myCount=0)) ""	
		q "W"
	}	
	q "R"
}

ClassMethod GetPermission(UserId As %String, PAAdmId As %String, ModelType As %Integer, ChartId As %String, MainDoctor As %String = "") As %String
{
	s:PAAdmId="" PAAdmId=%request.Get("EpisodeID")
	q:$G(^DHCPEDataEx("DHCPEGeneralSummarize","MainDoctor",PAAdmId))'="" "R"
	s LocID=$P($G(^PAADM(PAADM)),"^",4)
	i LocID="" s LocID=%session.Get("LOGON.CTLOCID")

	s UserID=%session.Get("LOGON.USERID")
	s groupId=%session.Get("LOGON.GROUPID")
	//358^152^179^128"
	i ChartId="" s ChartId="NULL"
	s WriteFlag=$G(^DHCPECFDataEx("ChartAssign",UserID,LocID,groupId,"Write",ChartId))
	q:(WriteFlag="N") "R"
	q:PAAdmId="" "R"
	s IAdmId=0
	s IAdmId=$o(^DHCPEIADM(0,"PAADM",PAAdmId,IAdmId))
	q:IAdmId="" ""
	//s GSGrpIds=^DHCPESetting("DHCPE","SSGroup_SummarizeAudit")
	s GSGrpIds=^DHCPESetting("DHCPE","SSGroup_SummarizeAudit",LocID)
	if (ModelType=0){

		s stationId=##class(web.DHCPE.ResultEdit).GetPEStation(ChartId)
		q:($g(stationId)="") ""
		Set StationType=##class(web.DHCPE.Public.Setting).GetStationType(stationId)
		Quit:StationType="Lab" "R"
		s statusVal=""
		&sql(select ss_Status into :statusVal from sqluser.DHC_PE_StationSummarize where ss_IADM_dr=:IAdmId and ss_ST_dr=:stationId)
		//Q:((statusVal="SA")&&(GSGrpIds'[(","_groupId_","))) "R"  //已科室审核，用户又不是总检医生
		q:statusVal="SA" "R"
		s GStatus=..GetGeneAdviserStatus(PAAdmId)
		q:(GStatus="Audited") "R"	//已总检审核	
		q:$g(groupId)="" ""	
		q "W"
	}
	if (ModelType=1){
		
		s MainGroup=$g(^DHCPESetting("DHCPE","MainDoctorGroup"))
		s GStatus=..GetGeneAdviserStatus(PAAdmId)
		;q:(groupId'=MainGroup)&&(GStatus="Audited") "R"
		q:("Y"'=MainDoctor)&&(GStatus="Audited") "R"
		;q:(groupId=MainGroup)&&(GStatus'="Audited") "R"
		q:("Y"=MainDoctor)&&(GStatus'="Audited") "R"
		q:$g(groupId)="" ""	
		q "W"
	}	
	q "R"
}

/// Description: 取总检的状态
/// return: "Audited"-has been audited;  ""-has not been audit.
/// test: w ##class(web.DHCPE.ResultPermission).GetGeneAdviserStatus(5748123)
ClassMethod GetGeneAdviserStatus(PAAdmId As %String)
{
	s peIAdmId=$o(^DHCPEIADM(0,"PAADM",PAAdmId,"0"))
	//q:peIAdmId="" "Audited"
	q:peIAdmId="" ""
	s generalAdvisorId=$o(^DHCPEGS(0,"IADM",peIAdmId,0))
	q:generalAdvisorId="" ""
	s auditUserId=$p($g(^DHCPEGS(generalAdvisorId,1)),"^",5)
	q:(auditUserId'="") "Audited"
	q ""
}

ClassMethod GetReportStatus(PAAdmId As %String)
{
	s peIAdmId=$o(^DHCPEIADM(0,"PAADM",PAAdmId,"0"))
	q:peIAdmId="" ""
	s generalAdvisorId=$o(^DHCPEGS(0,"IADM",peIAdmId,0))
	q:generalAdvisorId="" ""
	s auditUserId=$p($g(^DHCPEGS(generalAdvisorId,1)),"^",5)
	q:(auditUserId'="") "Audited"
	q ""
}

Query GetCheckList(StartDate As %String = "", EndDate As %String = "", RegNo As %String = "") As %Query(ROWSPEC = "TPAADM:%String,TRegNo:%String,TName:%String,TAgeSex:%String,TCheckDate:%String,TGroupName:%String")
{
}

ClassMethod GetCheckListExecute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "", RegNo As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCPE.RoomManager", "GetCheckList","1")
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s id=0
 	f  s id=$o(^User.DHCPEAreaD(Parref,"ChildRoom",id)) q:id=""  d
	.;s Str=..GetOneRoomInfo(Parref_"||"_id)
	.d GetCheckListBuild	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetCheckListBuild 
	;										Code_"^"_Desc_"^"_Sort_"^"_Sex_"^"_SexDesc_"^"_DietFlag_"^"_DietDesc_"^"_EmictionFlag_"^"_EmictionDesc_"^"_StationDR_"^"_StationDesc_"^"_Remark_"^"_Minute_"^"_TDoctorDesc_"^"_TActiveFlag_"^"_TShowNum
	set Data=$lb(TPAADM,TRegNo,TName,TAgeSex,TCheckDate,TGroupName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod GetCheckListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCheckListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {		
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetCheckListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCheckListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
