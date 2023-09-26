Class web.DHCPE.Menu Extends %Persistent [ ClassType = "", LegacyInstanceContext, ProcedureBlock ]
{

Parameter Menu = "websys.Menu";

Property MenuName As %String(TRUNCATE = 1) [ Private ];

Property MenuHandle As websys.Menu [ Private ];

Property ChildMenuHandle As websys.Menu [ Private ];

Property MenuId As %ObjectIdentity [ Private ];

Property MenuProp As %ListOfDataTypes [ Private ];

ClassMethod GetMenuByName(menuName) As %ObjectIdentity
{
	q:menuName="" 0
	s obj=..%New(menuName)
	d obj.GetMenu()
	s id=obj.GetMenuId()
	d obj.%Close()
	q id
}

ClassMethod ImportMenuByName(menuName) As %ObjectIdentity
{
	q:menuName="" 0
	s obj=..%New(menuName)
	d obj.ImportMenu()
	s id=obj.GetMenuId()
	d obj.%Close()
	q id
}

Method %OnNew(menuName) As %Status
{
	i '$d(menuName) k %this q 0
	s ..MenuName=menuName
	s ..MenuId=..GetMenuIdByName()
	d ..SetMenuHandle()
	s ..MenuProp=##class(web.DHCPE.Component).GetAllPropertiesByCls(..#Menu)
	q 1
}

Method %OnClose() As %Status
{
	k %this 
	q 1
}

Method GetMenuIdByName() As %ObjectIdentity [ Private ]
{
	s menuName=$ZCVT(..MenuName,"U")
	s id=0
	s id=+$o(^websys.MenuI("UniqueNameIndex"," "_menuName,0))
	q id
}

Method SetMenuHandle() As %Status [ Private ]
{
	s id=..MenuId
	i (id=0)||(+$zobjclassmethod(..#Menu,"%ExistsId",id)=0) d
	.s ..MenuHandle=$zobjclassmethod(..#Menu,"%New")
	e  d
	.s ..MenuHandle=$zobjclassmethod(..#Menu,"%OpenId",id)
	q 1
}

Method ImportMenu() As %Status
{
	f num=1:1:..MenuProp.Count() d
	.s prop=..MenuProp.GetAt(num)
	.s value=$g(^DHCPEMenu(..MenuName,"Menu",prop))
	.i (prop="SubMenuOf") d
	..q:value=""
	..s menuObj=$zobjclassmethod("web.DHCPE.Menu","%New",value)
	..s value=menuObj.MenuHandle
	.e  i (prop="LinkComponent") d
	..q:value=""
	..s comObj=$zobjclassmethod("web.DHCPE.Component","%New",value)
	..s value=comObj.ComponentHandle
	.;i prop="Type" w value,!
	.s $ZOBJPROPERTY(..MenuHandle,prop)=value
	s menuSaveStatus=..MenuHandle.%Save()
	s ..MenuId=..MenuHandle.%Id()
	
	q menuSaveStatus
}

Method GetMenu() As %Status
{
	f num=1:1:..MenuProp.Count() d
	.s prop=..MenuProp.GetAt(num)
	.s value=$ZOBJPROPERTY(..MenuHandle,prop)
	.i (prop="SubMenuOf") s value=..MenuHandle.SubMenuOf.Name
	.i (prop="LinkComponent") s value=..MenuHandle.LinkComponent.Name
	.s ^DHCPEMenu(..MenuName,"Menu",prop)=value
}

Method GetMenuId() As %ObjectIdentity
{
	q ..MenuId
}

}
