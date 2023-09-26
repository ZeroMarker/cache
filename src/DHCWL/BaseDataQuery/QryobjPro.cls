Class DHCWL.BaseDataQuery.QryobjPro Extends %Persistent
{

Property BaseObjName As %String(COLLATION = "EXACT");

Property proCode As %String(COLLATION = "EXACT");

Property proName As %String;

Property proDesc As %String;

Property proExeCode As %String;

Index InxQryobjCode On (BaseObjName, proCode) [ Unique ];

ClassMethod Insert(ByRef inParam, ByRef outParam) As %String
{
	s $zt="SQLErr"
	s ret=""
	//s ID=inParam("ID")
	s queryObj=inParam("queryObj")
	s proCode=inParam("proCode")
	s proName=inParam("proName")
	s proDesc=inParam("proDesc")
	s proExeCode=inParam("proExeCode")
	
	if $d(^DHCWL.BaseDataQuery.QryobjProI("InxQryobjCode",queryObj,proCode)) {
		s ret="维度代码重复！"
		q ret
	}
	
	s newObj=##class(DHCWL.BaseDataQuery.QryobjPro).%New()
	s newObj.BaseObjName=queryObj
	s newObj.proCode=proCode
	s newObj.proName=proName
	s newObj.proDesc=proDesc
	s newObj.proExeCode=proExeCode
	s sc=newObj.%Save()
	If $$$ISERR(sc) {
		s ret="Insert 'QryobjPro'对象失败:"_$System.Status.GetErrorText(sc)
		q ret
 	}
	d newObj.%Close()
	q ret
	
SQLErr
	if ret="" s ret="Insert 'ReportCfg'对象失败:未知错误!"
	q ret
}

ClassMethod Update(ByRef inParam, ByRef outParam) As %String
{
	s $zt="SQLErr"
	s ret=""
	s ID=inParam("ID")
	s queryObj=inParam("queryObj")
	s proCode=inParam("proCode")
	s proName=inParam("proName")
	s proDesc=inParam("proDesc")
	s proExeCode=inParam("proExeCode")
	
	if $d(^DHCWL.BaseDataQuery.QryobjProI("InxQryobjCode",queryObj,proCode)) {
		s rowid=$o(^DHCWL.BaseDataQuery.QryobjProI("InxQryobjCode",queryObj,proCode,""))
		if rowid'=ID {
			s ret="维度代码重复！"
			q ret
		}
	}
	
	s newObj=##class(DHCWL.BaseDataQuery.QryobjPro).%OpenId(ID)
	s newObj.BaseObjName=queryObj
	s newObj.proCode=proCode
	s newObj.proName=proName
	s newObj.proDesc=proDesc
	s newObj.proExeCode=proExeCode
	s sc=newObj.%Save()
	If $$$ISERR(sc) {
		s ret="Insert 'QryobjPro'对象失败:"_$System.Status.GetErrorText(sc)
		q ret
 	}
	d newObj.%Close()
	q ret
	
SQLErr
	if ret="" s ret="Insert 'ReportCfg'对象失败:未知错误!"
	q ret
}

Storage Default
{
<Data name="QryobjProDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BaseObjName</Value>
</Value>
<Value name="3">
<Value>proCode</Value>
</Value>
<Value name="4">
<Value>proName</Value>
</Value>
<Value name="5">
<Value>proDesc</Value>
</Value>
<Value name="6">
<Value>proExeCode</Value>
</Value>
</Data>
<DataLocation>^DHCWL.BaseDataQuery.QryobjProD</DataLocation>
<DefaultData>QryobjProDefaultData</DefaultData>
<IdLocation>^DHCWL.BaseDataQuery.QryobjProD</IdLocation>
<IndexLocation>^DHCWL.BaseDataQuery.QryobjProI</IndexLocation>
<StreamLocation>^DHCWL.BaseDataQuery.QryobjProS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
