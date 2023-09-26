Class DHCCPMWeb.CPMSysFun.QueryMetaInfo Extends %RegisteredObject
{

Query LookupQueryInPara(ClassName As %String, QueryName As %String) As %Query(ROWSPEC = "ParaName:%String,ParaType:%String,DefaultValue:%String") [ SqlProc ]
{
}

ClassMethod LookupQueryInParaExecute(ByRef qHandle As %Binary, ClassName As %String, QueryName As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCCPMWeb.CPMSysFun.DHCCPMSysQuery","LookupQueryInPara", "web.DHCOPAdmFind", "AdmQuery")
	;d ##class(%ResultSet).RunQuery("DHCCPMWeb.CPMSysFun.DHCCPMSysQuery","LookupQueryInPara","web.DHCLONGTIMEORD","GetLongOrd")
	Set repid=$I(^CacheTemp)
	s ind=1
	s ret=0
	
	d ResetVariablesIN
	
	if ((QueryName="")||(ClassName="")){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
	s myOutStr=..GetQInParaList(ClassName,QueryName,"")	
	
	s myColLen=$ll(myOutStr)
	s:(myOutStr="") myColLen=0
	f myIdx=1:3:myColLen {
		s myParaName=$lg(myOutStr,myIdx)
		s myParaType=$lg(myOutStr,myIdx+1)
		s defalutValue=$lg(myOutStr,myIdx+2)
		Do OutputRowIN
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowIN
	set Data=$lb(myParaName, myParaType,defalutValue)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
ResetVariablesIN
	s (No,DataType)=""
	s (myParaName, myParaType)=""
	q
}

ClassMethod LookupQueryInParaClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookupQueryInParaExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod LookupQueryInParaFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookupQueryInParaExecute ]
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

/// / 统一获取Query入参程序
ClassMethod GetQInParaList(ClassName As %String = "", QueryName As %String = "", ExpStr As %String) As %List
{
	/// 变成统一的参数名称:参数类型:默认值
	;w ##class(DHCCPMWeb.CPMBL.DHCBLCommFunLib).GetQInParaListBack("web.DHCOPAdmFind","AdmQuery","")
	;w ##class(DHCCPMWeb.CPMBL.DHCBLCommFunLib).GetQInParaList("web.DHCLONGTIMEORD","GetLongOrd","")
	
	s myrtn=""
	
	q:((ClassName="")!(QueryName)) myrtn
	
	s myIsVal=##class(DHCCPMWeb.CPMBL.DHCBLCommFunLib).IsValidClassName(ClassName)
	q:('myIsVal) myrtn
	s myIsVal=##class(DHCCPMWeb.CPMBL.DHCBLCommFunLib).IsValidQueryName(ClassName,QueryName)
	q:('myIsVal) myrtn
	
	s myCID=ClassName_"||"_QueryName
	s myobj=##class(%Dictionary.QueryDefinition).%OpenId(myCID,0)
	
	q:('$IsObject(myobj)) myrtn
	
	s myrtn=..ParseInParaByFormalSpec(myobj.FormalSpec)
	
	d myobj.%Close()
	
	q myrtn
}

/// 把函数、query的入参统一规整一下生成一个统一的字符串返回
/// ;变成统一的参数名称:参数类型:默认值:类型
ClassMethod ParseInParaByFormalSpec(fs As %String) As %List
{
	
	q:(fs="") ""
	
	s mynewfs=""
	s list=$lb()
	s listIndx=1
	s myName=""
	s myType=""
	s myDefault=""
	s myPassBy=""
	
	s mylen=$l(fs,",")
	for myIdx=1:1:mylen {
		s:(mynewfs'="") mynewfs=mynewfs_","
		s myPassBy="Value"
		s myDefault=""
		s myCurpara=$p(fs,",",myIdx)
		i $e(myCurpara,1)="&"{
			s myPassBy="Reference"
			s myCurpara=$p(myCurpara,"&",2)
		}
		
		s myName=$p(myCurpara,":",1)
		s myType=$p(myCurpara,":",2)
		s:(myType="") myType="%String"
		i (myType["="){
			s myDefault=$p(myType,"=",2)
			s myType=$p(myType,"=",1)
		}
		i (myName["="){
			s myDefault=$p(myName,"=",2)
			s myName=$p(myName,"=",1)
		}
		s $list(list,listIndx)=myName
		s $list(list,listIndx+1)=myType
		s $list(list,listIndx+2)=myDefault
		s listIndx=listIndx+3
	}
	q list
}

}
