Import SQLUser

Class DHCBP.Account Extends web.DHCClinicCom
{

ClassMethod LogOn(userInitials, password, locId As %String = "")
{
	
	// userId,userName,locId,groupId,userType,careProvId
	// w ##class(DHCBP.Account).LogOn("2970","med%(","197")
	//s ^tmpdebug("xx")=userInitials_" "_password_" "_locId
	s rowId=""
	s configId=##class(DHCBP.InDialysis).GetIdBylocId(locId)
	b
	q:configId="" "no BPConfiguration"_locId_".xml"
	s rowId=$O(^SSU("SSUSR",0,"SSUSR_Initials",userInitials,rowId))
	i rowId="" s rowId=$O(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(userInitials),rowId))
	i rowId="" s response="-1:UnknowUser"
	q:rowId="" response
	s userObj=##class(User.SSUser).%OpenId(rowId)
	s locObj=##class(User.CTLoc).%OpenId(locId)
	
	s response=""
	//s json={}
	s json=##class(%Library.ArrayOfDataTypes).%New()
	s password=$$ENCR^SSUTIL2(password)
	i (userObj.SSUSRPassword=password +rowId) d
	.d Add(rowId)
	.d Add(userObj.SSUSRName)
	.d Add(userObj.SSUSREMailName)
	.d Add(userInitials)
	.d Add(userObj.SSUSRDefaultDeptDR.CTLOCDesc)
	.d Add(userObj.SSUSRCareProvDR.CTPCPCarPrvTpDR.CTCPTDesc)
	.d Add(userObj.SSUSRCareProvDR.CTPCPCarPrvTpDR.CTCPTInternalType)
	.d json.SetAt(rowId,"RowId")
	.d json.SetAt(userInitials,"UserInitials")
	.d json.SetAt(userObj.SSUSRDefaultDeptDR.CTLOCDesc,"DefaultLoction")
	.d json.SetAt(userObj.SSUSRCareProvDR.CTPCPCarPrvTpDR.CTCPTDesc,"CTCPTDesc")
	.d json.SetAt(userObj.SSUSRName,"Name")
	.d json.SetAt(userObj.SSUSRCareProvDR.CTPCPCarPrvTpDR.CTCPTInternalType,"Role")
	.d json.SetAt($p(^SSU("SSUSR",rowId),"^",14),"CareProvDR")
	.d json.SetAt($h,"Tag")
	.d json.SetAt(locId,"LocId")
	.d json.SetAt(locObj.CTLOCDesc,"LocDesc")
	.;s json.UserName=userName
	.;s json.DefaultLoction=userObj.SSUSRDefaultDeptDR.CTLOCDesc
	.;s json.Name=userObj.SSUSRCareProvDR.CTPCPCarPrvTpDR.CTCPTDesc
	.;s json.CareProvDR=$p(^SSU("SSUSR",rowId),"^",14)
	.;s json.Tag=$h
	.;s json.LocId=locId
	.;i userObj.SSUSRIsThisDoctor="Y" d Add("Doctor") s json.Role="Doctor"
	.;e  i userObj.SSUSRNurseFlag="Y" d Add("Nurse") s json.Role="Nurse"
	.b
	e  d
	.s response="-2"
	.d json.SetAt($h,"Tag")
	s ^TempBPLogInfo("Session",json.GetAt("Tag"),"UserInitials")=json.GetAt("UserInitials")
	s ^TempBPLogInfo("Session",json.GetAt("Tag"),"LogInfo")=##class(Nur.JSON).Encode(json)

	s ^tmpdebug("response")=##class(Nur.JSON).Encode(json)
	q ##class(Nur.JSON).Encode(json)
Add(item)
	i response="" s response=item
	e  s response=response_"^"_item
	q response
}

// w ##class(DHCBP.Account).GetLocList("2907")

// w ##class(DHCBP.Account).GetLocList("3213")

ClassMethod GetLocList(userInitials As %String) As %GlobalBinaryStream
{
	//s ^tempby("111")=userInitials
	s userId=""
	&sql(SELECT SSUSR_RowId into:userId FROM SS_User WHERE SSUSR_Initials=:userInitials)
	q:userId="" "Unknown userInitials"
	s id="",defaultLocId=""
	&sql(DECLARE c CURSOR FOR 
	SELECT OTHLL_CTLOC_DR into :locId FROM SQLUser.SS_UserOtherLogonLoc 
	WHERE OTHLL_ParRef=:userId AND OTHLL_UserGroup_DR IN (SELECT groupId FROM DHC_BP_AuthorizationItem GROUP BY parentId))
	&sql(OPEN c)
	
    FOR { &sql(FETCH c)
        QUIT:SQLCODE 
        s obj=##class(User.CTLoc).%OpenId(locId)
        s Array(locId,"Id")=locId
        s Array(locId,"Code")=obj.CTLOCCode
        s Array(locId,"Desc")=obj.CTLOCDesc
        
    }
    &sql(CLOSE c)
	&sql(SELECT SSUSR_DefaultDept_DR into :defaultLocId
	FROM ss_USER  
	WHERE SSUSR_Initials=:userInitials AND SSUSR_Group IN (SELECT groupId FROM DHC_BP_AuthorizationItem GROUP BY parentId))
	if (defaultLocId){
	    s obj=##class(User.CTLoc).%OpenId(defaultLocId)
	    s Array(defaultLocId,"Id")=defaultLocId
        s Array(defaultLocId,"Code")=obj.CTLOCCode
        s Array(defaultLocId,"Desc")=obj.CTLOCDesc
	}
	B
	s stream=..ToJson(.Array)
	q stream
}

ClassMethod GetLogonLoc(userName As %String)
{
	s userId=""
}

/// D ##class(%ResultSet).RunQuery("DHCBP.Account","FindLocList","doctor")
Query FindLocList(userName As %String) As %Query(ROWSPEC = "UserId,LocDr,LocCode,LocDesc,GroupDr,GroupDesc")
{
}

ClassMethod FindLocListExecute(ByRef qHandle As %Binary, userName As %String) As %Status
{
	
  	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s userId=""
	&sql(SELECT SSUSR_RowId into:userId FROM SS_User WHERE SSUSR_Initials=:userName)
	if (userId="")
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s defLocDr=$p(^SSU("SSUSR",userId),"^",4)
	s defGroupDr=$p(^SSU("SSUSR",userId),"^",5)
	s defLocDesc="",defLocCode="",defGroupDesc=""
	s:defLocDr'="" defLocCode=$p(^CTLOC(defLocDr),"^",1)
	s:defLocDr'="" defLocDesc=$p(^CTLOC(defLocDr),"^",2)
	s:defGroupDr'="" defGroupDesc=$p(^SSU("SSGRP",defGroupDr),"^",1)
	Set ^CacheTemp(repid,ind)=$lb(userId,defLocDr,defLocCode,defLocDesc,defGroupDr,defGroupDesc)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=ind+1
 	i $d(^SSU("SSUSR",userId,"OTHLL"))>0 d
	.s otherChild=0
	.f  s otherChild=$o(^SSU("SSUSR",userId,"OTHLL",otherChild)) q:otherChild=""  d
	..s curLocDr=$p(^SSU("SSUSR",userId,"OTHLL",otherChild),"^",1)
	..s curGroupDr=$p(^SSU("SSUSR",userId,"OTHLL",otherChild),"^",2)
	..s curLocDesc="",curLocCode="",curGroupDesc=""
	..s:curLocDr'="" curLocCode=$p(^CTLOC(curLocDr),"^",1)
	..s:curLocDr'="" curLocDesc=$p(^CTLOC(curLocDr),"^",2)
	..s:curGroupDr'="" curGroupDesc=$p(^SSU("SSGRP",curGroupDr),"^",1)
	..Set ^CacheTemp(repid,ind)=$lb(userId,curLocDr,curLocCode,curLocDesc,curGroupDr,curGroupDesc)
 	..Set qHandle=$lb(0,repid,0)
 	..Set ind=ind+1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod FindLocListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBPArrangeSummaryExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindLocListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBPArrangeSummaryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetAppVersion()
{
	//s ^tmpdebug("GetAppVersion")=$h
	s ret="{""version"":"""_"2.0"_""",""url"":"""_"http://172.18.162.143/dthealth/web/service/DHCClinic/App/BPMobile/BP2.1.apk"_"""}"
	q ret
}

}
