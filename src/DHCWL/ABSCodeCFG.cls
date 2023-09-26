Import SQLUser

Class DHCWL.ABSCodeCFG Extends %Persistent [ LegacyInstanceContext, Not ProcedureBlock ]
{

Method GetDataStr() As %String
{
	s clsName=..%ClassName(1)
	s clsObj=##class(%Library.ClassDefinition).%OpenId(clsName)
	s proList=clsObj.Properties
	s retStr="Rowid:"""_..%Id()
	f num=1:1:proList.Count()  d
	.s proData=""
	.s proObj=proList.GetAt(num)
	.s proName=proObj.Name
	.s proDesc=proObj.Description
	.s proType=proObj.Type 
	.i proDesc="" s proOutName=proName
	.e  s proOutName=proDesc
	.;s dataStr="s proData=obj."_proName 
	.;x dataStr
	.;w $ZOBJPROPERTY(%this,proName)
	.s porData=$ZOBJPROPERTY(%this,proName)
	.i (proType="%Date")||(proType="%%Library.Date") s porData=$zd(porData,3)
	.i (proType="%Time")||(proType="%%Library.Time") s porData=$zt(porData,3)
	.s retStr=retStr_""","_proOutName_":"""_porData
	.
	q "{"_retStr_"""}"
}

ClassMethod GetOneDateStrById(id) As %String
{
	s thisObj=..%OpenId(id)
	s retValue=thisObj.GetDataStr()
	q retValue
}

Method InsLog(type, retJson, retJsonOld = "") As %String
{
	//s retJson=..GetDataStr()
	//s ^yxtest("retJson")=type_"   "_retJson
	s ret=""
	s clsObj=##class(%Library.ClassDefinition).%OpenId(..%ClassName(1))
	s tableName=clsObj.SqlTableName 
	i tableName="" s tableName=..%ClassName(1)
	e  s tableName=..%PackageName()_"."_tableName
	s tableName=$p(tableName,".",1)_"_"_$p(tableName,".",2,$l(tableName))
	s clsDesc=clsObj.Description
	s id=$p($p(retJson,","),":",2)
	//s ret= ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther(tableName,..%ClassName(1),clsDesc,id,clsDesc,type,retJson,retJsonOld)
	
	q ret
}

Storage Default
{
<Data name="ABSCodeCFGDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCWL.ABSCodeCFGD</DataLocation>
<DefaultData>ABSCodeCFGDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWL.ABSCodeCFGD</IdLocation>
<IndexLocation>^DHCWL.ABSCodeCFGI</IndexLocation>
<StreamLocation>^DHCWL.ABSCodeCFGS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
