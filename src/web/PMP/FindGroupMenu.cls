Class web.PMP.FindGroupMenu Extends %RegisteredObject
{

/// 
/// 
///  Desc:查询安全组菜单
/// Other: d ##class(%ResultSet).RunQuery("web.PMP.FindGroupMenu","FindMenu","","住院护士","")
Query FindMenu(MenuName As %String = "", GroupName = "", MenuGroupName As %String = "") As websys.Query(ROWSPEC = "id,Caption")
{
}

ClassMethod FindMenuExecute(ByRef qHandle As %Binary, MenuName As %String = "", GroupName = "", MenuGroupName = "") As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    s GroupName=%session.Data("LOGON.GROUPDESC")
    s GroupID = ##class(web.SSGroup).GetIdFromCodeOrDescription(GroupName)
    s myGroupMenuSecurity=""
    i GroupID'=""{
	    s myEprGSRowID=$o(^ooGroupSettingsI("GroupDRIndex", GroupID, 0))
		s myEGSObj=##class(epr.GroupSettings).%OpenId(myEprGSRowID, 0)
		s myGroupMenuSecurity = myEGSObj.MenuSecurity	
		d myEGSObj.%Close()   
    }
    s MenuGroupRowid = ##class(websys.Menu).GetIdFromCodeOrDescription(MenuGroupName)
    s Caption="",Name=""
    s id=""
    do{
		d getmenuid
		q:id=""				
		s ^CacheTemp(repid,ind)=$lb(id,Caption_"("_Name_")")
		s ind=ind+1
	}while(id'="")
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
 ;找到下一个满足条件的菜单ID
getmenuid	
	do{
		s id = $o(^websys.MenuD(id))
		q:id=""
		s Name = $lg(^websys.MenuD(id),4)
		s Caption = $lg(^websys.MenuD(id),1)
		s SubMenuOf = $lg(^websys.MenuD(id),12)
	    s MenuMatch=0,GroupMatch=0,MenuGroupMatch=0
	    s:MenuName="" MenuMatch=1
		s:(MenuName'="")&&($zcvt(Name,"U")[$zcvt(MenuName,"U")) MenuMatch=1
		s:(MenuName'="")&&($zcvt(Caption,"U")[$zcvt(MenuName,"U")) MenuMatch=1
		s:MenuGroupRowid="" MenuGroupMatch=1
		s:(MenuGroupRowid'="")&&(SubMenuOf=MenuGroupRowid) MenuGroupMatch=1
		s:GroupID="" GroupMatch=1
		s:(GroupID'="")&&($zbitlen(myGroupMenuSecurity)>=id)&&($zbitget(myGroupMenuSecurity,id)=1) GroupMatch=1 
		q:GroupMatch&&MenuMatch&&MenuGroupMatch
	}while(id'="")
	q
}

}
