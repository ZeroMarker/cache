Class web.DHCHM.Menu Extends %Persistent [ ClassType = "", LegacyInstanceContext, ProcedureBlock ]
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
	.q:value=""
	.s value=..GetOtherObj(prop,value)
	.s $ZOBJPROPERTY(..MenuHandle,prop)=value
	s menuSaveStatus=..MenuHandle.%Save()
	s ..MenuId=..MenuHandle.%Id()
	
	q menuSaveStatus
}

Method GetMenu() As %Status
{
	f num=1:1:..MenuProp.Count() d
	.s prop=..MenuProp.GetAt(num)
	.s value=..GetOtherDesc(prop)
	.s ^DHCPEMenu(..MenuName,"Menu",prop)=value
}

Method GetMenuId() As %ObjectIdentity
{
	q ..MenuId
}

Method GetOtherDesc(prop)
{
	s value=$ZOBJPROPERTY(..MenuHandle,prop)
	i (prop="SubMenuOf") s value=..MenuHandle.SubMenuOf.Name
	i (prop="LinkComponent") s value=..MenuHandle.LinkComponent.Name
	i (prop="Chart") s value=..MenuHandle.Chart.Name
	i (prop="ChartBook") s value=..MenuHandle.ChartBook.Description
	i (prop="LinkReport") s value=..MenuHandle.LinkReport.Description
	i (prop="WorkFlow") s value=..MenuHandle.WorkFlow.Name
	i (prop="Worklist") s value=..MenuHandle.Worklist.Name
	q value
}

//w ##class(web.DHCPE.Menu).GetOtherObj("WorkFlow","病案系统维护")

ClassMethod GetOtherObj(prop, value)
{
	i (prop="SubMenuOf") d
	.s menuObj=$zobjclassmethod("web.DHCPE.Menu","%New",value)
	.s value=menuObj.MenuHandle
	e  i (prop="LinkComponent") d
	.s comObj=$zobjclassmethod("web.DHCPE.Component","%New",value)
	.s value=comObj.ComponentHandle
	e  i (prop="Chart") d
	.&sql(SELECT ID into :value FROM epr.Chart WHERE Name = :value)
	.q:value=""
	.s value=$zobjclassmethod("epr.Chart","%OpenId",value)
	e  i (prop="ChartBook") d
	.s Desc=$ZCVT(value,"U")
	.s value=$O(^epr.ChartBookI("UniqueDescriptionIndex",Desc,0))
	.q:value=""
	.s value=$zobjclassmethod("epr.ChartBook","%OpenId",value)
	e  i (prop="LinkReport") d
	.&sql(select ID into :value from websys.Report where Description=:value)
	.q:value=""
	.s value=$zobjclassmethod("websys.Report","%OpenId",value)
	e  i (prop="WorkFlow") d
	.s Desc=$ZCVT(value,"U")
	.s value=$O(^websys.WorkFlowI("UniqueNameIndex"," "_Desc,0))
	.q:value=""
	.s value=$zobjclassmethod("websys.WorkFlow","%OpenId",value)
	e  i (prop="Worklist") d
	.s Desc=$ZCVT(value,"U")
	.s value=$O(^epr.WorklistI("NameIndex",Desc,0))
	.q:value=""
	.s value=$zobjclassmethod("epr.Worklist","%OpenId",value)
	q value
}

}
