/// 工程相关类
/// 20130628
Class web.DHCTT Extends %RegisteredObject
{

/// w ##class(web.DHCTT).Deploy("d:/Temp/cachett",.outList)
ClassMethod Deploy(FilePath As %String, ByRef SuccList)
{
	s $ze="DeployError",SuccList=0
	;d $SYSTEM.OBJ.Load(##Class(%File).NormalizeFilename(FilePath_"/DHCTT2013.xml"),"c",.err)
	;w "导入DHCTT2013工程成功"
	d $system.OBJ.MakeClassDeployed("websys.Query")
	TS 
	s rtn = ##class(web.Util.MenuService).Import(##Class(%File).NormalizeFilename(FilePath_"/dhctt.menu.xml"),0,.MenuSuccList)
	i rtn=$$$OK {
		s SuccList($i(SuccList))="导入菜单成功"
	}ELSE{
		TRO
		Q "import menu error!"
	}
	Set SSGroupId = ##class(web.SSGroup).GetIdFromCodeOrDescription("dhctt")
	if (SSGroupId'>0){
		s SSGroupObj = ##class(User.SSGroup).%New()
		s SSGroupObj.SSGRPDesc = "dhctt"
		s sc = SSGroupObj.%Save()
		if $SYSTEM.Status.IsError(sc) tro  q -1_$SYSTEM.Status.GetErrorText(sc)
		Set SSGroupId = SSGroupObj.%Id()
		do SSGroupObj.%Close()
		Set SSGroupObj=""
		s SuccList($i(SuccList))="增加dhctt安全组"
	}else{
		s SuccList($i(SuccList))="找到dhctt安全组"
	}
	
	if '##class(websys.WorkFlowItemDefinition).UniqueNameIndexExists("dhcttwfft",.wfidId){	
		Set WorkFlowItemObj = ##class(websys.WorkFlowItemDefinition).%New()
		Set WorkFlowItemObj.Name = "dhcttwfft"
		Set WorkFlowItemObj.Description="dhctt workflow find table"
		Do WorkFlowItemObj.UrlSet("dhctt.findtablestructure.csp")
		Set sc = WorkFlowItemObj.%Save()
		If $SYSTEM.Status.IsError(sc) tro  q -1_$SYSTEM.Status.GetErrorText(sc)
		Do WorkFlowItemObj.%Close()
		Set WorkFlowItemObj=""
	}
	if ##class(websys.WorkFlow).UniqueNameIndexExists("dhctt",.WorkFlowId){
		s SuccList($i(SuccList))="找到dhctt工作流"
	}else{
		Set WorkFlowObj = ##class(websys.WorkFlow).%New()
		Set WorkFlowObj.Name="dhctt"		
		Set sc = WorkFlowObj.%Save()
		If $SYSTEM.Status.IsError(sc) tro  q -1_$SYSTEM.Status.GetErrorText(sc)
		Set WorkFlowId = WorkFlowObj.%Id()
		Do WorkFlowObj.%Close()
		Set WorkFlowObj=""
		s SuccList($i(SuccList))="增加dhctt工作流"
	}
	if ##class(websys.WorkFlowItemDefinition).UniqueNameIndexExists("dhcttwfft",.wfidId),##class(websys.WorkFlow).UniqueNameIndexExists("dhctt",.WorkFlowId){
		set WorkFlowObj = ##class(websys.WorkFlow).%OpenId(WorkFlowId)
		do WorkFlowObj.WorkFlowItemsAdd("dhctt workflow find table","","")
		Set sc = WorkFlowObj.%Save()
		If $SYSTEM.Status.IsError(sc) tro  q -1_$SYSTEM.Status.GetErrorText(sc)
		Do WorkFlowObj.%Close()
		Set WorkFlowObj=""
	}
	Set GroupSettingsId = ##class(epr.GroupSettings).GetIdFromGroupId(SSGroupId)
	if GroupSettingsId>0{
		Set GroupSettingsObj = ##class(epr.GroupSettings).%OpenId(GroupSettingsId)
	}else{
		Set GroupSettingsObj = ##class(epr.GroupSettings).%New()
		Do GroupSettingsObj.GroupDRSetObjectId(SSGroupId)
	}
	Do GroupSettingsObj.StartPageDRSetObjectId(WorkFlowId) 	;workflow
	if ##class(websys.Menu).UniqueNameIndexExists("dhc.dhctt.header",.dhcttHeaderMenuId){
		Do GroupSettingsObj.MainMenuDRSetObjectId(dhcttHeaderMenuId)
	}			
	set MaxMenuId=$o(^websys.MenuD(""),-1)
	set MenuSecurity=$zbitstr(MaxMenuId,0)	
	s grantMenu=""
	f  s grantMenu = $o(MenuSuccList(grantMenu)) q:grantMenu=""  d	
	.if ##class(websys.Menu).UniqueNameIndexExists(grantMenu,.dhcttMenuId) d
	..s MenuSecurity = $zbitset(MenuSecurity,dhcttMenuId,1)
	Set GroupSettingsObj.MenuSecurity = MenuSecurity
	set sc = GroupSettingsObj.%Save()
	If $SYSTEM.Status.IsError(sc) tro  q -1_$SYSTEM.Status.GetErrorText(sc)
	do GroupSettingsObj.%Close()
	Set GroupSettingsObj=""
	s SuccList($i(SuccList))="成功分配菜单给dhctt"
	if ##class(User.SSUser).SSUSRInitialsUnqIdx1Exists("dhctt",.SSUserId){
		Set SSUserObj = ##class(User.SSUser).%OpenId(SSUserId)
	}else{
		Set SSUserObj = ##class(User.SSUser).%New()
		Set SSUserObj.SSUSRInitials = "dhctt"
	}
	Do SSUserObj.SSUSRGroupSetObjectId(SSGroupId)
	Set SSUserObj.SSUSRName = "dhctt"
	Set SSUserObj.SSUSRPassword = "U&dDF1,""7k7k"
	Set SSUserObj.SSUSRDateFrom = +$h-2
	Set locid = $o(^CTLOC(1))
	Do SSUserObj.SSUSRDefaultDeptDRSetObjectId(locid)
	s sc = SSUserObj.%Save()
	If $SYSTEM.Status.IsError(sc) tro  q -1_$SYSTEM.Status.GetErrorText(sc)
	d SSUserObj.%Close()
	s SSUserObj = ""
	s SuccList($i(SuccList))="成功增加用户"
	tc	
	q $$$OK
	
DeployError
	TRO	
	q -1_" "_$ze
}

}
