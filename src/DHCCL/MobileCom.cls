Class DHCCL.MobileCom Extends %RegisteredObject
{

ClassMethod LogOn(userName, password)
{
	//w ##class(DHCCL.MobileCom).LogOn("demo","1")
	s ^tmpdebug("xx")=userName_" "_password
	s rowId=""
	
	s rowId=$O(^SSU("SSUSR",0,"SSUSR_Initials",userName,rowId))
	i rowId="" s rowId=$O(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(userName),rowId))
	i rowId="" s response="-1:UnknowUser"
	q:rowId="" response
	s userObj=##class(User.SSUser).%OpenId(rowId)
	
	s response=""
	s password=$$ENCR^SSUTIL2(password)
	i (userObj.SSUSRPassword=password) d
	.b ;密码正确
	.d Add(rowId)
	.d Add(userObj.SSUSRName)
	.d Add(userObj.SSUSREMailName)
	.d Add(userName)
	.d Add(userObj.SSUSRDefaultDeptDR.CTLOCDesc)
	.d Add(userObj.SSUSRCareProvDR.CTPCPCarPrvTpDR.CTCPTDesc)
	.i userObj.SSUSRIsThisDoctor="Y" d Add("Doctor")
	.e  i userObj.SSUSRNurseFlag="Y" d Add("Nurse")
	e  s response="-2:Invalid Password"
	s ^tmpdebug("response")=response
	q response
Add(item)
	i response="" s response=item
	e  s response=response_"^"_item
	q response
}

ClassMethod CheckAutoLogin(userName)
{
	s ^tmpdebug("userName")=userName
	s userId=$g(^dhcAnMobileAutoLogin("LOGON.USERCODE"))
	k ^dhcAnMobileAutoLogin("LOGON.USERCODE")
	q:userName="" 0
	i userId=userName q 1
	e  q 0
}

ClassMethod GetUserInfo(userName)
{
	// w ##class(DHCCL.MobileCom).GetUserInfo("demo")
	s rowId=""
	s rowId=$O(^SSU("SSUSR",0,"SSUSR_Initials",userName,rowId))
	i rowId="" s rowId=$O(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(userName),rowId))
	s response=""
	s userObj=##class(User.SSUser).%OpenId(rowId)
	d Add(rowId)
	d Add(userObj.SSUSRName)
	d Add(userObj.SSUSREMailName)
	d Add(userName)
	d Add(userObj.SSUSRDefaultDeptDR.CTLOCDesc)
	d Add(userObj.SSUSRCareProvDR.CTPCPCarPrvTpDR.CTCPTDesc)
	i userObj.SSUSRIsThisDoctor="Y" d Add("Doctor")
	e  i userObj.SSUSRNurseFlag="Y" d Add("Nurse")
	q response
Add(item)
	i response="" s response=item
	e  s response=response_"^"_item
	q response
}

/// 查询血透先项
/// eg. D ##class(%ResultSet).RunQuery("DHCCL.MobileCom","FindOptions","BodySite")
Query FindOptions(type, queryRowId, locId = "") As %Query(ROWSPEC = "rowId:%Integer,code,desc") [ SqlProc ]
{
}

ClassMethod FindOptionsExecute(ByRef qHandle As %Binary, type As %String, queryRowId = "", locId = "") As %Status
{
	Set repid=$I(^CacheTemp)
	//s queryRowId=""
	s ^tmpdebug("xxxxxxx")="FindOptions:"_type_","_queryRowId
	s locIdList=""
	if (locId '= "") s locIdList=##Class(web.DHCBPCom).GetLinkLocByLocId(locId) //科室关联
	b
	If $g(ind)="" Set ind=1
	//i queryRowId=$c(0) s queryRowId=""
	i type'="" d Find	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
Find
	s tRowId="" f  s tRowId=$o(^DHCCLC("BodySite",tRowId)) q:tRowId=""  d
	.s item=$g(^DHCCLC("BodySite",tRowId))
	.q:item=""
	.s rowId=tRowId
	.q:((queryRowId'="")&&(rowId'=queryRowId))
	.s code=$lg(item,1)
	.s desc=$lg(item,2)
	.s tlocDr=$lg(item,3)
	.q:(tlocDr'="")&&(locIdList'="")&&(("^"_locIdList_"^")'[("^"_tlocDr_"^"))
	.d OutputRow
	
	/*s sub="" f  s sub=$O(^DHCCLComCode(type,sub)) q:sub=""  d
	.q:((queryRowId'="")&&(sub'=queryRowId))
	.s rowId=sub
	.s item=$g(^DHCCLComCode(type,sub))
	.
	.s code=$p(item,"^",1)
	.s desc=$p(item,"^",2)
	.d OutputRow
	*/
	q 
OutputRow          
	set Data=$lb(rowId,code,desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindOptionsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOptionsExecute ]
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

ClassMethod FindOptionsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOptionsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod ExportTask(taskName, path = "C:\")
{
	// w ##class(DHCCL.MobileCom).ExportTask("EveryHourTask")
	s taskId=##class(%SYSTEM.Task).FindId(taskName)
	s fileName=taskName_".xml"
	d ##class(%SYSTEM.Task).ExportTasks($lb(taskId),path_fileName)
	
    q "Over"
}

ClassMethod ImportTask(taskName, path = "C:\")
{
	// w ##class(DHCCL.MobileCom).ImportTask("EveryHourTask")
	s fileName=taskName_".xml"
	d ##class(%SYSTEM.Task).ImportTasks(path_fileName)
	
    q "Over"
}

}
