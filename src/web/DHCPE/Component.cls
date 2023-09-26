Class web.DHCPE.Component Extends %RegisteredObject [ ClassType = "", LegacyInstanceContext, ProcedureBlock ]
{

Parameter Component = "websys.Component";

Parameter ComponentItems = "websys.ComponentItems";

Parameter ComponentMessages = "websys.ComponentMessages";

Parameter ComponentTableItems = "websys.ComponentTableItems";

Property ComponentName As %String(TRUNCATE = 1) [ Private ];

Property ComponentHandle As websys.Component;

Property ComponentId As %ObjectIdentity [ Private ];

Property OldComponentId As %ObjectIdentity [ Private ];

Property ComponentProp As %ListOfDataTypes [ Private ];

Property ComponentItemsProp As %ListOfDataTypes [ Private ];

Property ComponentMessagesProp As %ListOfDataTypes [ Private ];

Property ComponentTableItemsProp As %ListOfDataTypes [ Private ];

Method GetComponentId() As %ObjectIdentity
{
	q ..ComponentId
}

Method ImportComponent() As %Status
{
	f num=1:1:..ComponentProp.Count() d
	.s prop=..ComponentProp.GetAt(num)
	.s value=$g(^DHCPEComponent(..ComponentName,"Component",prop))
	.i prop="Template" s Template=value
	.s $ZOBJPROPERTY(..ComponentHandle,prop)=value
	s compSaveStatus=..ComponentHandle.%Save()
	s ..ComponentId=..ComponentHandle.%Id()
	s oldId=$G(^DHCComponent(..ComponentName,"Component","ID"))
	s Template=##class(web.DHCPE.IMPMenuAndCompont).Replace(Template,oldId,..ComponentId)
	s newId=..ComponentId
	&SQL(Update websys.Component Set Template=:Template WHERE ID=:newId)
	i SQLCODE'=0 q "-2"
	s oldId=..OldComponentId
	&SQL(update websys.menu set linkcomponent=:newId where linkcomponent=:oldId)
	i SQLCODE=100 s SQLCODE=0
	i SQLCODE'=0 q "-3"
	&SQL(update websys.WorkFlowItemDefinition set Component=:newId where Component=:oldId)
	i SQLCODE=100 s SQLCODE=0
	i SQLCODE'=0 q "-3"
	q compSaveStatus
}

Method GetComponent() As %Status
{
	f num=1:1:..ComponentProp.Count() d
	.s prop=..ComponentProp.GetAt(num)
	.i prop="Template" d
	..s Sort=$G(^websys.ConfigurationD)
	..s SaveType=$LIST(^websys.ConfigurationD(1),14)
	..Set LayOut=##Class(websys.Preferences).GetData("SITE",SaveType,"LAYOUT",..ComponentId)
	..Set LayOut=$LIST(LayOut,1) 
	..s ^DHCPEComponent(..ComponentName,"Component",prop)=LayOut
	.e  d
	..s ^DHCPEComponent(..ComponentName,"Component",prop)=$ZOBJPROPERTY(..ComponentHandle,prop)
	s ^DHCPEComponent(..ComponentName,"Component","ID")=..ComponentId
	q 1
}

Method ImportComponentItems() As %Status
{
	s compName=..ComponentName
	&SQL(Delete From websys.ComponentItems Where parref->name=:compName )	
	
	s itemSub=0
	f  s itemSub=$o(^DHCPEComponent(..ComponentName,"Items",itemSub)) q:itemSub=""  d
	.s itemObj=$zobjclassmethod(..#ComponentItems,"%New")	
	.;s itemObj.ParRef=..ComponentHandle
	.s itemObj=..SetSubObject(itemObj)
	.f num=1:1:..ComponentItemsProp.Count() d
	..s prop=..ComponentItemsProp.GetAt(num)
	..s $ZOBJPROPERTY(itemObj,prop)=$g(^DHCPEComponent(..ComponentName,"Items",itemSub,prop))
	.s compSaveStatus=+itemObj.%Save()
	.;w itemObj.%Id()_" "_compSaveStatus,!
	.k itemObj
	q 1
}

Method GetComponentItems() As %Status
{
	s itemSub=0
	s i=0
	f  s itemSub=$o(^websys.ComponentItemsD(..ComponentId,itemSub)) q:itemSub=""  d
	.s i=i+1
	.s itemId=..ComponentId_"||"_itemSub
	.s itemObj=$zobjclassmethod(..#ComponentItems,"%OpenId",itemId)
	.f num=1:1:..ComponentItemsProp.Count() d
	..s prop=..ComponentItemsProp.GetAt(num)
	..;w prop,!
	..;s ^DHCPEComponent(..ComponentName,"Items",itemSub,prop)=$ZOBJPROPERTY(itemObj,prop)
	..s ^DHCPEComponent(..ComponentName,"Items",i,prop)=$ZOBJPROPERTY(itemObj,prop)
	q 1
}

Method ImportComponentMsg() As %Status
{
	s compName=..ComponentName
	&SQL(Delete From websys.ComponentMessages Where parref->name=:compName )
	s itemSub=0
	f  s itemSub=$o(^DHCPEComponent(..ComponentName,"Messages",itemSub)) q:itemSub=""  d
	.s itemObj=$zobjclassmethod(..#ComponentMessages,"%New")	
	.;s itemObj.ParRef=..ComponentHandle
	.s itemObj=..SetSubObject(itemObj)
	.f num=1:1:..ComponentMessagesProp.Count() d
	..s prop=..ComponentMessagesProp.GetAt(num)
	..s $ZOBJPROPERTY(itemObj,prop)=$g(^DHCPEComponent(..ComponentName,"Messages",itemSub,prop))
	.s compSaveStatus=+itemObj.%Save()
	.//w itemObj.%Id()_" "_compSaveStatus,!
	.k itemObj
	q 1
}

Method GetComponentMsg() As %Status
{
	s itemSub=0
	s i=0
	f  s itemSub=$o(^websys.ComponentD(..ComponentId,"Messages",itemSub)) q:itemSub=""  d
	.s i=i+1
	.s itemId=..ComponentId_"||"_itemSub
	.s itemObj=$zobjclassmethod(..#ComponentMessages,"%OpenId",itemId)
	.f num=1:1:..ComponentMessagesProp.Count() d
	..s prop=..ComponentMessagesProp.GetAt(num)
	..;s ^DHCPEComponent(..ComponentName,"Messages",itemSub,prop)=$ZOBJPROPERTY(itemObj,prop)
	..s ^DHCPEComponent(..ComponentName,"Messages",i,prop)=$ZOBJPROPERTY(itemObj,prop)
	q
}

Method ImportComponentTbl() As %Status
{
	s compName=..ComponentName
	&SQL(Delete From websys.ComponentTableItems Where parref->name=:compName )
	s itemSub=0
	f  s itemSub=$o(^DHCPEComponent(..ComponentName,"TableItems",itemSub)) q:itemSub=""  d
	.s itemObj=$zobjclassmethod(..#ComponentTableItems,"%New")	
	.;s itemObj.ParRef=..ComponentHandle
	.s itemObj=..SetSubObject(itemObj)
	.f num=1:1:..ComponentTableItemsProp.Count() d
	..s prop=..ComponentTableItemsProp.GetAt(num)
	..s $ZOBJPROPERTY(itemObj,prop)=$g(^DHCPEComponent(..ComponentName,"TableItems",itemSub,prop))
	.s compSaveStatus=+itemObj.%Save()
	.;w itemObj.%Id()_" "_compSaveStatus,!
	.k itemObj
	q 1
}

Method GetComponentTbl() As %Status
{
	s itemSub=0
	s i=0
	f  s itemSub=$o(^websys.ComponentTableItemsD(..ComponentId,itemSub)) q:itemSub=""  d
	.s i=i+1
	.s itemId=..ComponentId_"||"_itemSub
	.s itemObj=$zobjclassmethod(..#ComponentTableItems,"%OpenId",itemId)
	.f num=1:1:..ComponentTableItemsProp.Count() d
	..s prop=..ComponentTableItemsProp.GetAt(num)
	..;s ^DHCPEComponent(..ComponentName,"TableItems",itemSub,prop)=$ZOBJPROPERTY(itemObj,prop)
	..s ^DHCPEComponent(..ComponentName,"TableItems",i,prop)=$ZOBJPROPERTY(itemObj,prop)
	q
}

Method SetSubObject(o As %ObjectHandle) As %ObjectHandle [ Private ]
{
	s $zt="GetErr"
	s o.ParRef=..ComponentHandle
	q o
GetErr
	s $zt="GetErr1"	
	s o.ParRef=..ComponentHandle	
	q o
GetErr1
	q o
}

Method %OnNew(initValue, DeleteFlag As %String = "0") As %Status
{
	i '$d(initValue) k %this q 0
	s ..ComponentName=initValue
	s ..ComponentProp=..GetAllPropertiesByCls(..#Component)
	s ..ComponentItemsProp=..GetAllPropertiesByCls(..#ComponentItems)
	s ..ComponentMessagesProp=..GetAllPropertiesByCls(..#ComponentMessages)
	s ..ComponentTableItemsProp=..GetAllPropertiesByCls(..#ComponentTableItems)
	
	s ..ComponentId=..GetComponentIdByName()
	i ..ComponentId'=0 d
	.i DeleteFlag="1" d
	..s Id=..ComponentId
	..&SQL(delete from websys.component where id=:Id)
	..s ..OldComponentId=Id
	..s ..ComponentId=0
	;s ..NewComponentId=compId
	d ..AutoSetComponentHandle()
	q 1
}

Method %OnClose() As %Status
{
	k %this 
	q 1
}

//w ##class(web.DHCPE.Component).ImportComponentByName("DHCPEItemSequence")

ClassMethod GetAllPropertiesByCls(clsName As %String) As %ListOfDataTypes
{
	
	q:##class(%Library.ClassDefinition).%ExistsId(clsName)=0 0
	;s clsDef=##class(%Library.ClassDefinition).%OpenId(clsName)
	s clsDef=##class(%Library.CompiledClass).%OpenId(clsName)
	s ret=##class(%ListOfDataTypes).%New() 
	s retNumber=0 
	s clsProList=clsDef.Properties
	f Num=1:1:clsProList.Count()
	{
		s clsPro=clsProList.GetAt(Num)
		s proName=clsPro.Name
		;s sqlNumber=clsPro.SqlColumnNumber
		continue:proName["%"
		continue:clsPro.Private=1
		d ret.Insert(proName)
		s retNumber=retNumber+1
	}
	q ret
}

Method GetComponentIdByName() As %ObjectIdentity [ Private ]
{
	s id=0
	s ComponentName=..ComponentName
	q:ComponentName="" 0
	&SQL(SELECT ID INTO :id FROM websys.Component 
			WHERE Name=:ComponentName)
	q id
}

Method AutoSetComponentHandle() As %Status [ Private ]
{
	s id=..ComponentId
	i (id=0)||(+$zobjclassmethod(..#Component,"%ExistsId",id)=0) d
	.s ..ComponentHandle=$zobjclassmethod(..#Component,"%New")
	e  d
	.s ..ComponentHandle=$zobjclassmethod(..#Component,"%OpenId",id)
	q 1
}

ClassMethod ImportComponentByName(compName As %String) As %ObjectIdentity
{
	q:compName="" 0
	s obj=..%New(compName,"1")
	d obj.ImportComponent()
	d obj.ImportComponentItems()
	d obj.ImportComponentMsg()
	d obj.ImportComponentTbl()
	s id=obj.GetComponentId()
	d obj.%Close()
	q id
}

ClassMethod GetComponentByName(compName) As %ObjectIdentity
{
	q:compName="" 0
	s obj=..%New(compName)
	d obj.GetComponent()
	d obj.GetComponentItems()
	d obj.GetComponentMsg()
	d obj.GetComponentTbl()
	s id=obj.GetComponentId()
	d obj.%Close()
	q id
}

}
