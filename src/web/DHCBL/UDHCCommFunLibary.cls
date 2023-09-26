/// 通用的函数 库
Class web.DHCBL.UDHCCommFunLibary Extends (%RegisteredObject, %XML.Adaptor, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 28;

ClassMethod GetClassPropertyList(ClassName As %String) As %String
{
	n (ClassName)
	;w ##class(web.DHCBL.UDHCCommFunLibary).GetClassPropertyList("web.DHCEntity.PCA.PATMAS")
	
	s myItems=""
	
	s myobj=##class(%Dictionary.CompiledClass).%OpenId(ClassName)
	s myCount = myobj.Properties.Count()
	
	s mylist=$p(ClassName,".",$l(ClassName,"."))
	
	For i = 1:1:myCount {
		s myproperty=myobj.Properties.GetAt(i)
		s myName=myproperty.Name
		continue:myName="%%OID"	
		if (mylist="")
		{
			s mylist= myName
		}else
		{
	    	s mylist=mylist_"^"_myName
		}
	}
	
	q mylist
}

ClassMethod InitListObjectValueClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = InitListObjectValueExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod InitListObjectValueExecute(ByRef qHandle As %Binary, ClassName As %String, PropertyName As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s ret=0

	s myobj=##class(%Dictionary.CompiledClass).%OpenId(ClassName)
	
	s myCount = myobj.Properties.Count()
	
	s myParList=""
	f i=1:1:myCount q:(myParList'="")  d
	.s mypropobj=myobj.Properties.GetAt(i)
	.i (mypropobj.Name=PropertyName) d
	..s myParList=mypropobj.Parameters
	
	s myDisList=myParList.GetAt("DISPLAYLIST")
	s myValList=myParList.GetAt("VALUELIST")
	d mypropobj.%Close()
	d myobj.%Close()
	
	s mylistCount= $l(myDisList,",")
	f i=1:1:mylistCount  d
	.s myDisValue=$p(myDisList,",",i)
	.s myValue=$p(myValList,",",i)
	.Do OutputRowLObj
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowLObj
	set Data=$lb(myValue, myDisValue)
	Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
	quit
}

ClassMethod InitListObjectValueFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = InitListObjectValueExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else      {
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query InitListObjectValue(ClassName As %String, PropertyName As %String) As %Query(ROWSPEC = "ValueList:%String, DisplayValue:%String")
{
}

ClassMethod InitListObjectValueNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = InitListObjectValueNewExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod InitListObjectValueNewExecute(ByRef qHandle As %Binary, ClassName1 As %String, PropertyName As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s ret=0

	s myobj=##class(%Dictionary.CompiledClass).%OpenId(ClassName1)
	
	s myCount = myobj.Properties.Count()
	
	s myParList=""
	f i=1:1:myCount q:(myParList'="")  d
	.s mypropobj=myobj.Properties.GetAt(i)
	.i (mypropobj.Name=PropertyName) d
	..s myParList=mypropobj.Parameters
	
	s myDisList=myParList.GetAt("DISPLAYLIST")
	s myValList=myParList.GetAt("VALUELIST")
	d mypropobj.%Close()
	d myobj.%Close()
	
	s mylistCount= $l(myDisList,",")
	f i=1:1:mylistCount  d
	.s myDisValue=$p(myDisList,",",i)
	.Quit:myDisValue=""
	.s myValue=$p(myValList,",",i)
	.Do OutputRowLObj1
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowLObj1
	set Data=$lb(myValue, myDisValue)
	Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
	quit
}

ClassMethod InitListObjectValueNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = InitListObjectValueNewExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else      {
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query InitListObjectValueNew(ClassName1 As %String, PropertyName As %String) As %Query(ROWSPEC = "ValueList:%String, DisplayValue:%String")
{
}

/// 获取组件元素
Query ReadComponentItem(ComponentName As %String, DisType As %String, HiddenFlag As %String) As %SQLQuery(CONTAINID = 1)
{
	select Name, Caption, DataType, DisplayType  
	from websys.componentitems 
	where (ParRef->Name=:ComponentName)
		and (DisplayType %STARTSWITH  :DisType) and (Hidden %STARTSWITH :HiddenFlag)
}

ClassMethod GetComponentItemsList() As %String
{
	;d ##class(web.DHCBL.UDHCCommFunLibary).GetComponentItemsList()
	
	s myFormName=""
	s myMenuID=%request.Get("TMENU")
	;s myMenuID=50345
	i myMenuID'="" d
	.s mymenuobj=##class(websys.Menu).%OpenId(myMenuID)
	.s myFormName=mymenuobj.LinkComponent.Name
	.d mymenuobj.%Close()
	
	i myFormName="" d
	.s myFormName=%request.Get("TFORM")
	
	i myFormName="" d
	.s myFormName=%request.Get("WEBSYS.TCOMPONENT")

	i myFormName="" d
	.s myTEventName=%request.Get("TEVENT")
	.q:(myTEventName="")
	.s myTEventName=$p(myTEventName,"d",2)
	.s myCompID=$p(myTEventName,"i",1)
	.s myCompItemName=$e(myTEventName,($l(myCompID)+2),$l(myTEventName))
	.s myCompItemName=" "_$ZCONVERT(myCompItemName,"U")
	.;^websys.ComponentItemsI("Name",51039
	.s myCompItemRowID=$o(^websys.ComponentItemsI("Name", myCompID,myCompItemName,0))
	.q:(myCompItemRowID="")
	.s myCompItemObj=##class(websys.ComponentItems).%OpenId(myCompID_"||"_myCompItemRowID)
	.s myFormName=myCompItemObj.LinkComponent
	.d myCompItemObj.%Close()
	
	q:(myFormName="") ""
	s myItems=""
	
	s myCompID=""
	&sql(select ID into :myCompID from websys.component where Name=:myFormName)
	
	;打开组件类	
	s myComs=##class(websys.Component).%OpenId(myCompID)
	
	s myCount = myComs.Items.Count()
	s myTxtIdx=0
	s myListIdx = 0
	s myLookTxtIdx = 0
	
	Write !,"<SCRIPT language=""Javascript"">",!
	;JS 函数
		w "var m_ListItemName = new Array();", !
		w "var m_TextItemName = new Array();", !
		w "var m_LookUpTextItemName = new Array()",!
		w "var m_LookUpTextItemRowID = new Array()", !
		
		For i = 1:1:myCount {
			s myItemObj=myComs.Items.GetAt(i)
			s myDPType = myItemObj.DisplayType
			i ((myDPType="T")||(myDPType="L")||(myDPType="C")||(myDPType="TA")||(myDPType="B"))
			{
			    i ((('+myItemObj.Hidden)&&(myItemObj.LookupClassName="")&&(myItemObj.LookupQueryName=""))!(myDPType="L")){
				    i (myDPType="L"){
						w "  "_"m_ListItemName["_myListIdx_"]='"_myItemObj.Name_"';",!
						s myListIdx=+myListIdx+1
				    }else{
						w "  "_"m_TextItemName["_myTxtIdx_"]='"_myItemObj.Name_"';",!
						s myTxtIdx=+myTxtIdx+1
				    }
			    }elseif(('+myItemObj.Hidden)&&(myItemObj.LookupClassName'="")&&(myItemObj.LookupQueryName'="")){
					///对于Lookup的规则  显示数据的Name后面加上 RowID
					w "  "_"m_LookUpTextItemName["_myLookTxtIdx_"]='"_myItemObj.Name_"';",!
					w "  "_"m_LookUpTextItemRowID["_myLookTxtIdx_"]='"_myItemObj.Name_"LookUpRowID';",!
					s myLookTxtIdx = +myLookTxtIdx+1
			    }
			}
		}
	w "</SCRIPT>"
	w !
	
	d myComs.%Close()
	
	q ""
}

}
