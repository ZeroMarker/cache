Class web.DHCANCMenuItem Extends %RegisteredObject
{

/// Creator：      	陈长青
/// CreatDate：    	2015-07-30
/// Description： 	查找菜单项
/// Table：        	DHC_ANC_MenuItem
/// Input:			
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("web.DHCANCMenuItem","FindMenuItems")
Query FindMenuItems() As %Query(ROWSPEC = "Id,Code,Desc,PageRoute,Icon,MenuGroupId,MenuGroup,MainItemId,MainItem,SeqNo") [ SqlProc ]
{
}

ClassMethod FindMenuItemsExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	kill ^TMPAN("MENU",$j)
	
	set menuItemId=0
	if ($data(^DHCANC("MenuItem")))
	{
		for
		{
			set menuItemId=$order(^DHCANC("MenuItem",menuItemId))
			quit:(menuItemId="")
			set menuItemCode=$list(^DHCANC("MenuItem",menuItemId),1)
			set menuItemDesc=$list(^DHCANC("MenuItem",menuItemId),2)
			set menuItemPageRoute=$list(^DHCANC("MenuItem",menuItemId),3)
			set menuItemIcon=$list(^DHCANC("MenuItem",menuItemId),5)
			set menuGroupId=$list(^DHCANC("MenuItem",menuItemId),4)
			set menuGroup="",menuGroupSeqNo="",menuGroupCode=""
			if (##class(User.DHCANCMenuGroup).%ExistsId(menuGroupId))
			{
				set menuGroupCode=$listget(^DHCANC("MenuGroup",menuGroupId),1)
				set menuGroup=$listget(^DHCANC("MenuGroup",menuGroupId),2)	
				set menuGroupSeqNo=$listget(^DHCANC("MenuGroup",menuGroupId),4)
			}
			if (+menuGroupSeqNo<=0)
			{
				set menuGroupSeqNo=100000	
			}
			
			set mainItemId=$list(^DHCANC("MenuItem",menuItemId),6)
			set mainItem=""
			if (##class(User.DHCANCMenuItem).%ExistsId(mainItemId))
			{
				set mainItem=$list(^DHCANC("MenuItem",mainItemId),2)	
			}
			
			set seqNo=$listget(^DHCANC("MenuItem",menuItemId),7)
			if (+seqNo<=0)
			{
				set seqNo=100000	
			}
			
			set ^TMPAN("MENU",$j,menuGroupSeqNo,menuGroupId,seqNo,menuItemId)=$lb(menuItemId,menuItemCode,menuItemDesc,menuItemPageRoute,menuItemIcon,menuGroupId,menuGroup,mainItemId,mainItem,seqNo)
			
			;do OutputRow	
		}
		
		set menuGroupSeqNo=0
		for
		{
			set menuGroupSeqNo=$order(^TMPAN("MENU",$j,menuGroupSeqNo))
			quit:(menuGroupSeqNo="")
			set menuGroupId=0
			for
			{
				set menuGroupId=$order(^TMPAN("MENU",$j,menuGroupSeqNo,menuGroupId))
				quit:(menuGroupId="")
				set seqNo=0
				for
				{
					set seqNo=$order(^TMPAN("MENU",$j,menuGroupSeqNo,menuGroupId,seqNo))
					quit:(seqNo="")
					set menuItemId=0
					for
					{
						set menuItemId=$order(^TMPAN("MENU",$j,menuGroupSeqNo,menuGroupId,seqNo,menuItemId))	
						quit:(menuItemId="")
						do OutputRow
					}	
				}
			}	
		}
	}
	
	
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutputRow
 	;Set Data=$lb(menuItemId,menuItemCode,menuItemDesc,menuItemPageRoute,menuItemIcon,menuGroupId,menuGroup,mainItemId,mainItem,seqNo)
 	Set Data=^TMPAN("MENU",$j,menuGroupSeqNo,menuGroupId,seqNo,menuItemId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindMenuItemsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindMenuItemsExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 // Save QHandle
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindMenuItemsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindMenuItemsExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// Creator：      	陈长青
/// CreatDate：    	2015-09-29
/// Description： 	保存菜单
/// Table：        	DHC_ANC_MenuItem
/// Input:			itemId：菜单ID，code：菜单代码，desc：菜单名称，icon：菜单图标，pageRoute：菜单引用页面，menuGroupId：菜单组ID
/// Return：       	保存成功返回ID，失败返回错误原因
/// w ##class(web.DHCANCMenuItem).SaveMenuItem()
ClassMethod SaveMenuItem(itemId, code, desc, icon, pageRoute, menuGroupId, mainMenuItemId, seqNo, Output retVal As %String(MAXLEN=65535)) As %String [ SqlProc ]
{
	set menuItem=""
	if ('##class(User.DHCANCMenuItem).%ExistsId(itemId))
	{
		set menuItem=##class(User.DHCANCMenuItem).%New()	
	}
	else
	{
		set menuItem=##class(User.DHCANCMenuItem).%OpenId(itemId)	
	}	
	
	if ('##class(User.DHCANCMenuGroup).%ExistsId(menuGroupId))
	{
		set retVal="菜单组不存在，请创建好菜单组再添加菜单！"
		quit retVal	
	}
	
	set menuItem.ANCMICode=code
	set menuItem.ANCMIDesc=desc
	set menuItem.ANCMIIcon=icon
	set menuItem.ANCMIPageRoute=pageRoute
	if (+seqNo>0)
	{
		set menuItem.ANCMISeqNo=+seqNo	
	}
	
	set menuItem.ANCMIMenuGroupDR=##class(User.DHCANCMenuGroup).%OpenId(menuGroupId)
	if (##class(User.DHCANCMenuItem).%ExistsId(mainMenuItemId))
	{
		set menuItem.ANCMIMainMenuItem=##class(User.DHCANCMenuItem).%OpenId(mainMenuItemId)	
	}
	
	set status=menuItem.%Save()
	if ($System.Status.IsOK(status))
	{
		set retVal=menuItem.%Id()	
	}
	else
	{
		set retVal="保存菜单失败！原因："_$System.Status.GetErrorText(status)	
	}
	
	quit retVal
}

/// Creator：      	陈长青
/// CreatDate：    	2015-07-29
/// Description： 	删除菜单
/// Table：        	DHC_ANC_MenuItem
/// Input:			menuItemId:菜单ID
/// Return：       	删除成功返回0，失败返回错误原因
/// w ##class(web.DHCANCMenuItem).DeleteMenuItem()
ClassMethod DeleteMenuItem(menuItemId, Output retVal As %String) As %String [ SqlProc ]
{
	quit:('##class(User.DHCANCMenuItem).%ExistsId(menuItemId)) "不存在该菜单组，请选择正确的菜单组进行删除！"
	&sql(delete from sqluser.dhc_anc_menuitem where %ID=:menuItemId)
	set retVal=SQLCODE
	if (SQLCODE'=0)
	{
		set retVal="错误代码："_SQLCODE_"，错误信息："_$SYSTEM.SQL.SQLCODE(SQLCODE)	
	}
	
	quit retVal
}

}
