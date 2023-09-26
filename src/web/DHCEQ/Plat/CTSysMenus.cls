Class web.DHCEQ.Plat.CTSysMenus Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query GetMenu(ModuleType As %String = "", Name As %String = "") As %Query(ROWSPEC = "TRowID:%String,TName:%String,TCaption:%String,TClientTypeDR:%String,TClientType:%String")
{
}

ClassMethod GetMenuExecute(ByRef qHandle As %Binary, ModuleType As %String = "", Name As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s RowID=0
	f  s RowID=$o(^DHCEQCCode("DHCEQCSysMenus",RowID))  quit:RowID=""  d
	.d ResetVariablesGetMenu
	.s TModule=$p($g(^DHCEQCCode("DHCEQCSysMenus",RowID)),"^",1)
	.q:(ModuleType'="")&&(TModule'=ModuleType)
	.s TName = $p($g(^DHCEQCCode("DHCEQCSysMenus",RowID)),"^",3)
	.q:(Name'="")&&(TName'=Name)
	.s TCaption=$p($g(^DHCEQCCode("DHCEQCSysMenus",RowID)),"^",4)
	.s TClientTypeDR=$p($g(^DHCEQCCode("DHCEQCSysMenus",RowID)),"^",6)
	.s TClientType=$Case(TClientTypeDR,"":"","6":"PC端菜单","7":"移动端菜单")
	.s TRowID=RowID
	.d OutputRowGetMenu
	quit $$$OK
OutputRowGetMenu
	s Data=$lb(TRowID,TName,TCaption,TClientTypeDR,TClientType)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetMenu
	s (TRowID,TName,TCaption,TClientTypeDR,TClientType,TModule)=""
	quit
}

ClassMethod GetMenuFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMenuExecute ]
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

ClassMethod GetMenuClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMenuExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetModuleMenu(ModuleType As %String = "", BussType As %String = "", Name As %String = "", Caption As %String = "", MenuType As %String = "", ClientType As %String = "", ParentMenuDR As %String = "", ShortCutKey As %String = "", ShowInnewWindow As %String = "", Image As %String = "", Linkurl As %String = "", Sequence As %String = "") As %Query(ROWSPEC = "TRowID:%String,TModuleTypeDR:%String,TModuleType:%String,TBussTypeDR:%String,TBussType:%String,TName:%String,TCaption:%String,TMenuType:%String,TClientTypeDR:%String,TClientType:%String,TParentMenuDR:%String,TParentMenu:%String,TImage:%String,TLinkurl:%String,TSequence:%String,TShortCutKey:%String,TShowInnewWindow:%String,TRemark:%String,TDate:%String,TTime:%String,TUserDR:%String,TUser:%String")
{
}

ClassMethod GetModuleMenuExecute(ByRef qHandle As %Binary, ModuleType As %String = "", BussType As %String = "", Name As %String = "", Caption As %String = "", MenuType As %String = "", ClientType As %String = "", ParentMenuDR As %String = "", ShortCutKey As %String = "", ShowInnewWindow As %String = "", Image As %String = "", Linkurl As %String = "", Sequence As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s Name=$ZCONVERT(Name,"U")
	s index=1
	s RowID=0
	f  s RowID=$o(^DHCEQCCode("DHCEQCSysMenus",RowID))  quit:RowID=""  d
	.d ResetVariablesGetModuleMenu
	.s TModuleTypeDR=$p($g(^DHCEQCCode("DHCEQCSysMenus",RowID)),"^",1)
	.q:(ModuleType'="")&&(TModuleTypeDR'=ModuleType)
	.s TModuleType=$Case(TModuleTypeDR,"":"","1":"设备管理","2":"维修管理","3":"效益分析","4":"移动盘点","5":"移动维修","6":"移动验收","7":"移动报废") //Modified By QW20200116 begin增加移动验收及报废 
	.s TBussTypeDR=$p($g(^DHCEQCCode("DHCEQCSysMenus",RowID)),"^",2)
	.q:(BussType'="")&&(TBussTypeDR'=BussType)
	.i TBussTypeDR'="" s TBussType=$p($g(^DHCEQCCode("DHCEQCBussType",TBussTypeDR)),"^",2)  /// Modefied by zc 2015-07-28 zc 0026 
	.s TName=$ZCONVERT($p($g(^DHCEQCCode("DHCEQCSysMenus",RowID)),"^",3),"U")
	.q:(Name'="")&&(TName'[Name) 
	.s TCaption=$p($g(^DHCEQCCode("DHCEQCSysMenus",RowID)),"^",4)
	.q:(Caption'="")&&(TCaption'=Caption)
	.s TMenuType=$p($g(^DHCEQCCode("DHCEQCSysMenus",RowID)),"^",5)
	.q:(MenuType'="")&&(TMenuType'=MenuType)
	.s TClientTypeDR=$p($g(^DHCEQCCode("DHCEQCSysMenus",RowID)),"^",6)
	.q:(ClientType'="")&&(TClientTypeDR'=ClientType)
	.s TClientType=$Case(TClientTypeDR,"":"","6":"PC端菜单","7":"移动端菜单")  //..GetClientType(clienttype)
	.s TParentMenuDR=$p($g(^DHCEQCCode("DHCEQCSysMenus",RowID)),"^",7)
	.q:(ParentMenuDR'="")&&(TParentMenuDR'[ParentMenuDR)
	.i TParentMenuDR'="" s TParentMenu=$p($g(^DHCEQCCode("DHCEQCSysMenus",TParentMenuDR)),"^",3)
	.s TImage=$p($g(^DHCEQCCode("DHCEQCSysMenus",RowID)),"^",8)
	.q:(Image'="")&&(TImage'[Image)        //modified by czf 518867
	.s TLinkurl=$p($g(^DHCEQCCode("DHCEQCSysMenus",RowID)),"^",9)
	.q:(Linkurl'="")&&(TLinkurl'[Linkurl)    //modified by czf 518870
	.s TSequence=$p($g(^DHCEQCCode("DHCEQCSysMenus",RowID)),"^",10)
	.q:(Sequence'="")&&(TSequence'[Sequence)   //modified by czf 518981
	.s TShortCutKey=$p($g(^DHCEQCCode("DHCEQCSysMenus",RowID)),"^",11)
	.q:(ShortCutKey'="")&&(TShortCutKey'=ShortCutKey)
	.s TShowInnewWindow=$p($g(^DHCEQCCode("DHCEQCSysMenus",RowID)),"^",12)
	.q:(ShowInnewWindow'="")&&(TShowInnewWindow'=ShowInnewWindow)
	.s TShowInnewWindow=$CASE(TShowInnewWindow,"0":"否","1":"是","":"")    //add by czf 518845
	.s TRemark=$p($g(^DHCEQCCode("DHCEQCSysMenus",RowID)),"^",13)
	.s TDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQCCode("DHCEQCSysMenus",RowID)),"^",14),"date")
	.s TTime=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQCCode("DHCEQCSysMenus",RowID)),"^",15),"date")
	.s TUserDR=$p($g(^DHCEQCCode("DHCEQCSysMenus",RowID)),"^",16)
	.i TUserDR '=""  d
	..s TUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TUserDR)
	.s TRowID=RowID
	.d OutputRow
	Quit $$$OK
OutputRow
	set Data=$lb(TRowID,TModuleTypeDR,TModuleType,TBussTypeDR,TBussType,TName,TCaption,TMenuType,TClientTypeDR,TClientType,TParentMenuDR,TParentMenu,TImage,TLinkurl,TSequence,TShortCutKey,TShowInnewWindow,TRemark,TDate,TTime,TUserDR,TUser)
 	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetModuleMenu
	Set (TRowID,TModuleTypeDR,TModuleType,TBussTypeDR,TBussType,TName,TCaption,TMenuType,TClientTypeDR,TClientType,TParentMenuDR,TParentMenu,TImage,TLinkurl,TSequence,TShortCutKey,TShowInnewWindow,TRemark,TDate,TTime,TUserDR,TUser)=""
	Quit
}

ClassMethod GetModuleMenuFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetModuleMenuExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetModuleMenuClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetModuleMenuExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod DeleteModulemenu(OPRRowid As %String)
{
	i OPRRowid'="" d
	.s grrowid=$o(^DHCEQCCode("DHCEQCSysGroupMenu",0,"GMMenuDR",OPRRowid,-1))
	.i grrowid'="" d
	..s ID="此项已分配" 
	.e  d
	..s rowid=$o(^DHCEQCCode("DHCEQCSysMenus",0,"MParentMenuDR",OPRRowid,-1))
	..i rowid'="" d
	...s ID="此项为父菜单"
	..e  d
	...s ID=1                     //modify hly 20190717
	...k ^DHCEQCCode("DHCEQCSysMenus",OPRRowid)
	q ID
}

ClassMethod SaveData(val, User)
{
	k PLIST,rowid
	i User="" s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s rowid=$p(val,"^",1)
	s PLIST(2)=$p(val,"^",2)
	s PLIST(3)=$p(val,"^",3)
	s PLIST(4)=$p(val,"^",4)
	s PLIST(5)=$p(val,"^",5)
	s PLIST(6)=$p(val,"^",6)
	s PLIST(7)=$p(val,"^",7)
	s PLIST(8)=$p(val,"^",8)
	s PLIST(9)=$p(val,"^",9)
	s PLIST(10)=$p(val,"^",10)
	s PLIST(11)=$p(val,"^",11)
	s PLIST(12)=$p(val,"^",12)
	s PLIST(13)=$p(val,"^",13)
	s PLIST(14)=$p(val,"^",14)
	s PLIST(15)=+$H
	s PLIST(16)=$p($H,",",2)
	s PLIST(17)=User


	s tmpid=""
	&SQL(select M_RowID into :tmpid from sqluser.DHC_EQCSysMenus where M_ModuleType=:PLIST(2) and M_BussTypeDR=:PLIST(3) and M_Name=:PLIST(4) and M_Caption=:PLIST(5) and M_ClientType=:PLIST(7) and M_ShowInNewWindow=:PLIST(13))
	if ((tmpid'="")&&(tmpid'=rowid)) q -3003	
	i (rowid="")
	{
		&SQL(Insert Into sqluser.DHC_EQCSysMenus Values :PLIST())
	} 
	else
	{
		&SQL(Update sqluser.DHC_EQCSysMenus Values :PLIST() where M_RowID = :rowid)
	}
	if SQLCODE  q -3001
	Set ID=$g(%ROWID)
	q ID
}

ClassMethod GetOneSysMenus(rowid As %Library.String = "")
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQCCode("DHCEQCSysMenus",rowid)
	s resultex=resultex_"^"	
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$Case($p(result,"^",1),"":"","1":"设备管理","2":"维修管理","3":"效益分析","4":"移动盘点","5":"移动维修","6":"移动验收","7":"移动报废") //Modified By QW20200116 BUG:QW0039增加移动验收及报废 
	s resultex=resultex_"^"	
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCBussType",$p(result,"^",2))),"^",2) 
	s resultex=resultex_"^"	
	i $p(result,"^",6)'=""  d
	.s resultex=resultex_$Case($p(result,"^",6),"":"","6":"PC端菜单","7":"移动端菜单")
	s resultex=resultex_"^"	
	i $p(result,"^",7)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCSysMenus",$p(result,"^",7))),"^",3) 
	s resultex=resultex_"^"	
	i $p(result,"^",12)'=""  d
	.s resultex=resultex_$Case($p(result,"^",12),"":"","0":"否","1":"是","":"")
	q result_resultex
}

}
