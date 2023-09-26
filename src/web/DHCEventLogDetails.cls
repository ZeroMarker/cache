Class web.DHCEventLogDetails Extends websys.Abstract
{

/// d ##class(%ResultSet).RunQuery("web.DHCEventLogDetails","Find","48")
Query Find(DetLogParref) As websys.Query(CONTAINID = 1, ROWSPEC = "DetRowId:%String,DetComputerIP:%String,DetComputerMac:%String,DetComputerName:%String,DetConditions:%String,DetContent:%String,DetGroupDr:%String,DetGroupDesc:%String,DetLocDr:%String,DetLocDesc:%String,DetLoginDr:%String,DetSecretLevelDr:%String,DetSecretLevelDesc:%String,DetDate:%String,DetTime:%String,DetUserDr:%String,DetUserName:%String")
{
}

ClassMethod FindExecute(ByRef QHandle As %Library.Binary, LogDetParref) As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set QHandle=$lb(0,repid,0)
	if LogDetParref="" Set QHandle=$lb(0,repid,0) Quit $$$OK
	Set Sub =0
	for {
		Set Sub = $Order(^DHCEVENTLOG(LogDetParref,"D",Sub))
		Quit:Sub=""
		Set DetRowId = LogDetParref_"||"_Sub
		If $d(^DHCEVENTLOG(LogDetParref,"D",Sub),g){
			Set (DetComputerIP,DetComputerMac,DetComputerName,DetConditions,DetContent,DetGroupDr,DetGroupDesc,DetLocDr,DetLocDesc,DetLoginDr,DetSecretLevelDr,DetSecretLevelDesc,DetDate,DetTime,DetUserDr,DetUserName)=""
			&sql(SELECT Det_ComputerIP,Det_ComputerMac,Det_ComputerName,Det_Conditions,Det_Content,Det_Group_Dr,Det_Group_Dr->SSGRP_Desc,Det_Loc_Dr,Det_Loc_Dr->CTLOC_Desc,Det_Login_Dr,Det_SecretLevel_Dr,Det_SecretLevel_Dr->Level_Desc,Det_Date,Det_Time,Det_User_Dr,Det_User_Dr->SSUSR_Name
			 into :DetComputerIP,:DetComputerMac,:DetComputerName,:DetConditions,:DetContent,:DetGroupDr,:DetGroupDesc,:DetLocDr,:DetLocDesc,:DetLoginDr,:DetSecretLevelDr,:DetSecretLevelDesc,:DetDate,:DetTime,:DetUserDr,:DetUserName
			 FROM SQLUser.DHC_EventLogDetails Where Det_RowId=:DetRowId)
			Set DetDate=##Class(websys.Conversions).DateLogicalToHtml(DetDate)
			Set DetTime = $zt(DetTime,2)
			Set DetContent = $tr(DetContent,$c(0),"")
			Set ^CacheTemp(repid,ind)=$lb(DetRowId,DetComputerIP,DetComputerMac,DetComputerName,DetConditions,DetContent,DetGroupDr,DetGroupDesc,DetLocDr,DetLocDesc,DetLoginDr,DetSecretLevelDr,DetSecretLevelDesc,DetDate,DetTime,DetUserDr,DetUserName)
			Set ind=ind+1
		}
	}
	Set QHandle=$lb(0,repid,0)
	quit $$$OK
}

ClassMethod Insert(Parref, Content, Conditions, SecretLevelId, UserId, LocId, GroupId, LoginId, IP, Mac, ComputerName)
{
		Q:$d(^DHCEVENTLOG(Parref))=0 "-100^Event Log :"_Parref_" Is Not Exist"
		Set DetObj = ##class(User.DHCEventLogDetails).%New(Parref)
		Set nowDate = +$h
		Do DetObj.DetLogParRefSetObjectId(Parref)
		Do DetObj.DetUserDrSetObjectId(UserId)
		Do DetObj.DetLoginDrSetObjectId(LoginId)
		Do DetObj.DetLocDrSetObjectId(LocId)
		Do DetObj.DetGroupDrSetObjectId(GroupId)
		Do DetObj.DetSecretLevelDrSetObjectId(SecretLevelId)
		Set DetObj.DetComputerIP = IP
		Set DetObj.DetComputerMac = Mac
		Set DetObj.DetComputerName = ComputerName
		Set DetObj.DetConditions = Conditions
		Set DetObj.DetContent = Content
		Set DetObj.DetDate = +$h
		Set DetObj.DetTime = $p($h,",",2)
		Set sc = DetObj.%Save()
		if $$$ISERR(sc) Set DetObj = "" Quit "-100^"_$SYSTEM.Status.GetErrorCodes(sc)
		Set DetId = DetObj.%Id()
		Set DetObj =""
		if (Conditions'=""){
			Set ModelDr = $p(^DHCEVENTLOG(Parref),"^",2)
			Set AuditFlag = $p(^DHCEVENTLOG(Parref),"^",6)
			;用于失败登录判断
			Set ^DHCEVENTLOGI(0,"DetDate",nowDate,"Model",ModelDr,"Conditions",Conditions,Parref)=AuditFlag
			;用于重复打印判断
			Set ^DHCEVENTLOGI(0,"Model",ModelDr,"Conditions",Conditions,"User",UserId,Parref)=AuditFlag
		}
		Quit DetId
}

/// d ##class(%ResultSet).RunQuery("web.DHCEventLogDetails","FindParAndDet","2019-05-28","2019-05-29")
Query FindParAndDet(StDate, EndDate, User = "", AuditFlag = "N", Model = "", Type = "L") As websys.Query(CONTAINID = 1, ROWSPEC = "LogRowId:%String,LogStDate:%String,LogStTime:%String,LogEndDate:%String,LogEndTime:%String,LogSuccess:%String,LogTimes:%String,LogUserDr:%String,LogUserName:%String,LogModelDr:%String,LogModelDesc:%String,LogAuditFlag:%String,LogAuditDr:%String,LogAuditStatusDesc:%String,LogAuditUserName:%String,LogAuditNote:%String,DetRowId:%String,DetComputerIP:%String,DetComputerMac:%String,DetComputerName:%String,DetConditions:%String,DetContent:%String,DetGroupDr:%String,DetGroupDesc:%String,DetLocDr:%String,DetLocDesc:%String,DetLoginDr:%String,DetSecretLevelDr:%String,DetSecretLevelDesc:%String,DetDate:%String,DetTime:%String,DetUserDr:%String,DetUserName:%String")
{
}

ClassMethod FindParAndDetExecute(ByRef QHandle As %Library.Binary, StDate, EndDate, User = "", AuditFlag = "N", Model = "", Type = "L") As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
	Set repid3=$I(^CacheTemp)
	Set ind3=1
	Set QHandle=$lb(0,repid3,0)
	Set rs = ##class(%ResultSet).%New("web.DHCEventLog:Find")
	Set sc = rs.Execute(StDate,EndDate,User,AuditFlag,Model,Type)
	Set parColumns = rs.GetColumnCount()

	while(rs.Next()){
		Set DetLogParref =  rs.GetData(1)
		Set subRS = ##class(%ResultSet).%New("web.DHCEventLogDetails:Find")
		Set subSc = subRS.Execute(DetLogParref)
		Set subColumns = subRS.GetColumnCount()
		while(subRS.Next()){
			For i=1:1:parColumns Set $list(^CacheTemp(repid3,ind3),i) = rs.GetData(i)
			For j=1:1:subColumns Set $list(^CacheTemp(repid3,ind3),parColumns+j)=subRS.GetData(j)
			Set ind3 = ind3+1
		}
		
		do subRS.Close()
		Set subRS=""
	}
	
	quit $$$OK
}

}
