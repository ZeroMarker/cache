Class web.DHCBL.CARD.PatInfoParse Extends (%RegisteredObject, %XML.Adaptor, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 48;

/// 此类专门解析Entity 对象
ClassMethod GetEntiyClassList(ClassName As %String) As %String
{
	;w ##class(web.DHCBL.CARD.PatInfoParse).GetEntiyClassList("web.DHCEntity.PCA.PATMAS")
	
	s myItems=""
	
	s myobj=##class(%Dictionary.CompiledClass).%OpenId(ClassName)
	s myCount = myobj.Properties.Count()
	
	
	Write !,"<SCRIPT language=""Javascript"">",!
	;JS 函数
		w "var m_CDEAry = new Array();", !
		w "var m_CDEDataTypeAry = new Array();", !
		
		For i = 1:1:myCount {
			s myproperty=myobj.Properties.GetAt(i)
		    s myIdx=i-1
			w "  "_"m_CDEAry["_myIdx_"]='"_myproperty.Name _"';",!
			w "  "_"m_CDEDataTypeAry["_myIdx_"]='"_myproperty.Type _"';",!
		}
	w "</SCRIPT>"
	w !
	
	q ""
}

ClassMethod InitListObjectValueClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = InitListObjectValueExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod SetListValue(ClassName, PropertyName, ItemName)
{
	;d ##class(web.DHCBL.CARD.PatInfoParse).SetListValue("User.DHCCardHardComGroup","CCGType","")
	
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

}
