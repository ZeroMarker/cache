Class web.DHCEQCSysMenus Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCEQCSysMenus","GetModulemenu","","","","","","","","","")
/// modified by czf 518867,518867,518981 增加入参Image,Linkurl,Sequence
Query GetModulemenu(ModuleType As %String = "", BussType As %String = "", Name As %String = "", Caption As %String = "", MenuType As %String = "", ClientType As %String = "", ParentMenuDR As %String = "", ShortCutKey As %String = "", ShowInnewWindow As %String = "", Image As %String = "", Linkurl As %String = "", Sequence As %String = "") As %Query(ROWSPEC = "rowid:%String,moduledr:%String,moduletype:%String,busstypedr:%String,busstype:%String,name:%String,caption:%String,menutype:%String,clienttypedr:%String,clienttype:%String,parentmenudr:%String,parentmenu:%String,image:%String,linkurl:%String,sequence:%String,shortcutkey:%String,showinnew:%String,remark:%String,date:%String,time:%String,user:%String")
{
}

ClassMethod GetModulemenuExecute(ByRef qHandle As %Binary, ModuleType As %String = "", BussType As %String = "", Name As %String = "", Caption As %String = "", MenuType As %String = "", ClientType As %String = "", ParentMenuDR As %String = "", ShortCutKey As %String = "", ShowInnewWindow As %String = "", Image As %String = "", Linkurl As %String = "", Sequence As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s Name=$ZCONVERT(Name,"U")
	s index=1
	s RowID=0
	f  s RowID=$o(^DHCEQCCode("DHCEQCSysMenus",RowID))  quit:RowID=""  d
	.d ResetVariablesGetModulemenu
	.s rowid=RowID
	.s moduledr=$p($g(^DHCEQCCode("DHCEQCSysMenus",RowID)),"^",1)
	.q:(ModuleType'="")&&(moduledr'=ModuleType)
	.s moduletype=$Case(moduledr,"":"","1":"设备管理","2":"维修管理","3":"效益分析","4":"移动盘点","5":"移动维修")  //..GetModuleType(module)
	.s busstypedr=$p($g(^DHCEQCCode("DHCEQCSysMenus",RowID)),"^",2)
	.q:(BussType'="")&&(busstypedr'=BussType)
	.i busstypedr'="" s busstype=$p($g(^DHCEQCCode("DHCEQCBussType",busstypedr)),"^",2)  /// Modefied by zc 2015-07-28 zc 0026 
	.s name=$ZCONVERT($p($g(^DHCEQCCode("DHCEQCSysMenus",RowID)),"^",3),"U")
	.q:(Name'="")&&(name'[Name) 
	.s caption=$p($g(^DHCEQCCode("DHCEQCSysMenus",RowID)),"^",4)
	.q:(Caption'="")&&(caption'=Caption)
	.s menutype=$p($g(^DHCEQCCode("DHCEQCSysMenus",RowID)),"^",5)
	.q:(MenuType'="")&&(menutype'=MenuType)
	.s clienttypedr=$p($g(^DHCEQCCode("DHCEQCSysMenus",RowID)),"^",6)
	.q:(ClientType'="")&&(clienttypedr'=ClientType)
	.s clienttype=$Case(clienttypedr,"":"","6":"PC端菜单","7":"移动端菜单")  //..GetClientType(clienttype)
	.s parentmenudr=$p($g(^DHCEQCCode("DHCEQCSysMenus",RowID)),"^",7)
	.q:(ParentMenuDR'="")&&(parentmenudr'[ParentMenuDR)
	.i parentmenudr'="" s parentmenu=$p($g(^DHCEQCCode("DHCEQCSysMenus",parentmenudr)),"^",3)
	.s image=$p($g(^DHCEQCCode("DHCEQCSysMenus",RowID)),"^",8)
	.q:(Image'="")&&(image'[Image)        //modified by czf 518867
	.s linkurl=$p($g(^DHCEQCCode("DHCEQCSysMenus",RowID)),"^",9)
	.q:(Linkurl'="")&&(linkurl'[Linkurl)    //modified by czf 518870
	.s sequence=$p($g(^DHCEQCCode("DHCEQCSysMenus",RowID)),"^",10)
	.q:(Sequence'="")&&(sequence'[Sequence)   //modified by czf 518981
	.s shortcutkey=$p($g(^DHCEQCCode("DHCEQCSysMenus",RowID)),"^",11)
	.q:(ShortCutKey'="")&&(shortcutkey'=ShortCutKey)
	.s showinnew=$p($g(^DHCEQCCode("DHCEQCSysMenus",RowID)),"^",12)
	.q:(ShowInnewWindow'="")&&(showinnew'=ShowInnewWindow)
	.s showinnew=$CASE(showinnew,"0":"否","1":"是","":"")    //add by czf 518845
	.s remark=$p($g(^DHCEQCCode("DHCEQCSysMenus",RowID)),"^",13)
	.s date=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQCCode("DHCEQCSysMenus",RowID)),"^",14),"date")
	.s time=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQCCode("DHCEQCSysMenus",RowID)),"^",15),"date")
	.s userdr=$p($g(^DHCEQCCode("DHCEQCSysMenus",RowID)),"^",16)
	.i userdr '=""  d
	..s uer = ##class(web.DHCEQCommon).GetTrakNameByID("user",userdr)
	.d OutputRow
	Quit $$$OK
OutputRow
	set Data=$lb(rowid,moduledr,moduletype,busstypedr,busstype,name,caption,menutype,clienttypedr,clienttype,parentmenudr,parentmenu,image,linkurl,sequence,shortcutkey,showinnew,remark,date,time,user)
 	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetModulemenu
	Set (rowid,moduledr,moduletype,busstypedr,busstype,name,caption,menutype,clienttypedr,clienttype,parentmenudr,parentmenu,image,linkurl,sequence,shortcutkey,showinnew,remark,date,time,user)=""
	Quit
}

ClassMethod GetModulemenuFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetModulemenuExecute ]
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

ClassMethod GetModulemenuClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetModulemenuExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// w ##Class(web.DHCEQCSysMenus).SaveModulemenu("","1","","设备入库","入库单","一般","6","","","","","","","","","") 

/// Modefied by zc 2015-07-28 zc 0026
/// 描述:新增与保存方法分开，此部分为更新
ClassMethod SaveModulemenu(RowId As %String, ModuleType As %String, BussType As %String, Name As %String, Caption As %String, MenuType As %String, ClientType As %String, ParentMenuDR As %String, Image As %String, LinkUrl As %String, Sequence As %String, ShortCutKey As %String, ShowInnewWindow As %String, Remark As %String, Date As %String, Time As %String, User As %String)
{
	s user=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	k PLIST,rowid
	s rowid=RowId
	s PLIST(2)=ModuleType
	s PLIST(3)=BussType
	s PLIST(4)=Name
	s PLIST(5)=Caption
	s PLIST(6)=MenuType
	s PLIST(7)=ClientType
	s PLIST(8)=ParentMenuDR
	s PLIST(9)=Image
	s PLIST(10)=LinkUrl
	s PLIST(11)=Sequence
	s PLIST(12)=ShortCutKey
	s PLIST(13)=ShowInnewWindow
	s PLIST(14)=Remark
	s PLIST(15)=+$H
	s PLIST(16)=$p($H,",",2)
	s PLIST(17)=user
	s tmpid=""
	&SQL(select M_RowID into :tmpid from sqluser.DHC_EQCSysMenus where M_ModuleType=:ModuleType and M_Name=:Name and M_Caption=:Caption)
	if ((tmpid'="")&&(tmpid'=rowid)) q "数据有重复"	;重复记录
	&SQL(Update sqluser.DHC_EQCSysMenus Values :PLIST() where M_RowID = :rowid)
	q SQLCODE
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
	...s ID=0
	...k ^DHCEQCCode("DHCEQCSysMenus",OPRRowid)
	q ID
}

/// Modefied by zc 2015-07-28 zc 0026
/// 描述:添加输出列clienttypedr及clienttype
/// d ##class(%ResultSet).RunQuery("web.DHCEQCSysMenus","GetMenu")
Query GetMenu(ModuleType As %String = "", Name As %String = "") As %Query(ROWSPEC = "rowid:%String,name:%String,caption:%String,clienttypedr:%String,clienttype:%String")
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
	.s rowid = RowID
	.s module=$p($g(^DHCEQCCode("DHCEQCSysMenus",rowid)),"^",1)
	.q:(ModuleType'="")&&(module'=ModuleType)
	.s name = $p($g(^DHCEQCCode("DHCEQCSysMenus",rowid)),"^",3)
	.q:(Name'="")&&(name'=Name)
	.s caption=$p($g(^DHCEQCCode("DHCEQCSysMenus",rowid)),"^",4)
	.s clienttypedr=$p($g(^DHCEQCCode("DHCEQCSysMenus",rowid)),"^",6)
	.s clienttype=$Case(clienttypedr,"":"","6":"PC端菜单","7":"移动端菜单")
	.d OutputRowGetMenu
	quit $$$OK
OutputRowGetMenu
	s Data=$lb(rowid,name,caption,clienttypedr,clienttype)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetMenu
	s (rowid,name,caption,clienttypedr,clienttype)=""
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

/// w ##Class(web.DHCEQCSysMenus).GetName()
ClassMethod GetName(ModuleType As %String = "", start = 0, limit = 40)
{
	n ( ModuleType, start, limit)
	
	s sqlStr="SELECT * FROM DHC_EQCSysMenus"
	i ModuleType'="" s sqlStr=sqlStr_"where M_ModuleType=:"_ModuleType
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s count=0
	s resultString=""
	
	s json=##class(Code.JsonObj).%New()
	s jsonTitle="rowid^name"
	
	s end = start+limit-1
	
	While(result.Next())
	{
		s rowid = result.Data("M_RowID")
		s name = result.Data("M_Name")
		s tmp=rowid_"^"_name
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1

	}
	d result.Close()
	s resultString = json.getJson(jsonTitle,count)
 	k json
	q resultString
}

/// w ##Class(web.DHCEQCSysMenus).GetNameType()
ClassMethod GetNameType(ModuleType As %String = "", Start = 0, Limit = 40)
{
	s json = ##class(Code.JsonObj).%New()
	s count = 0
	s end = Start+Limit

	
	s RowID=0
	f  s RowID=$o(^DHCEQCCode("DHCEQCSysMenus",RowID))  quit:RowID=""  d
	.d ResetVariables
	.s TRowId = RowID
	.s module=$p($g(^DHCEQCCode("DHCEQCSysMenus",RowID)),"^",1)
	.q:(ModuleType'="")&&(module'=ModuleType)
	.s TName=$p($g(^DHCEQCCode("DHCEQCSysMenus",RowID)),"^",3)
	.d OutputRowName
		
	s resultString = json.getJson("rowid^name",count)
    k json
    q resultString
	Quit $$$OK

OutputRowName
	Set Data=TRowId_"^"_TName
	s count = count+1
	i (count>Start)&(count<=end) d
	.d json.InsertRowData(Data)
	Quit
ResetVariables
	Set (TRowId,TName)=""
	Quit
}

/// Modefied by zc 2015-07-28 zc 0026
/// 描述:新增与保存方法分开，此部分为新增
ClassMethod AddModulemenu(ModuleType As %String, BussType As %String, Name As %String, Caption As %String, MenuType As %String, ClientType As %String, ParentMenuDR As %String, Image As %String, LinkUrl As %String, Sequence As %String, ShortCutKey As %String, ShowInnewWindow As %String, Remark As %String, Date As %String, Time As %String, User As %String)
{
	s user=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	k PLIST
	s PLIST(2)=ModuleType
	s PLIST(3)=BussType
	s PLIST(4)=Name
	s PLIST(5)=Caption
	s PLIST(6)=MenuType
	s PLIST(7)=ClientType
	s PLIST(8)=ParentMenuDR
	s PLIST(9)=Image
	s PLIST(10)=LinkUrl
	s PLIST(11)=Sequence
	s PLIST(12)=ShortCutKey
	s PLIST(13)=ShowInnewWindow
	s PLIST(14)=Remark
	s PLIST(15)=+$H
	s PLIST(16)=$p($H,",",2)
	s PLIST(17)=user
	s tmpid=""
	&SQL(select M_RowID into :tmpid from sqluser.DHC_EQCSysMenus where M_ModuleType=:ModuleType and M_Name=:Name and M_Caption=:Caption)
	if (tmpid'="")  q "数据有重复"	;重复记录
	&SQL(Insert into sqluser.DHC_EQCSysMenus Values :PLIST())
	if SQLCODE  q "更新失败"
	Set ID=$g(%ROWID)
	q ID
}

}
