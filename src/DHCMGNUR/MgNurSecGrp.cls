/// 
/// Class Description:安全组
/// Date:2015-01-05
Class DHCMGNUR.MgNurSecGrp Extends %Persistent
{

Property SecGrpDesc As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

Property SecGrpCode As %Library.String [ SqlColumnNumber = 3 ];

//Property SecGrp

Index SCode On SecGrpCode;

ClassMethod Save(parr As %String) As %String
{
	s ^TMP("g201501051654001")=parr
	//secGrpCode|nurse^secGrpDesc|护士^Par|
	s id=$P($P(parr,"^",3),"|",2)
	i id'="" s a=##class(DHCMGNUR.MgNurSecGrp).%OpenId(id)
	e  s a=##class(DHCMGNUR.MgNurSecGrp).%New()
	s a.SecGrpCode=$P($P(parr,"^",1),"|",2)
	s a.SecGrpDesc=$P($P(parr,"^",2),"|",2)
	d a.%Save()
	q 0
}

ClassMethod IsExist(str As %String) As %String
{
	s ^TMEP("g201501051656001")=str
	//str="secGrpCode|cs^secGrpDesc|测试^Par|7"
	s code=$ZConvert($P($P(str,"^",1),"|",2),"U")
	s rw=$P($P(str,"^",3),"|",2)
	s id=$O(^DHCMGNUR.MgNurSecGrpI("SCode"," "_code,""))
	q:id="" 0
	i id=rw q 0
	e  q 1
}

Storage Default
{
<Data name="MgNurSecGrpDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SecGrpDesc</Value>
</Value>
<Value name="3">
<Value>SecGrpCOde</Value>
</Value>
<Value name="4">
<Value>SecGrpCode</Value>
</Value>
</Data>
<DataLocation>^DHCMGNUR.MgNurSecGrpD</DataLocation>
<DefaultData>MgNurSecGrpDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMGNUR.MgNurSecGrpD</IdLocation>
<IndexLocation>^DHCMGNUR.MgNurSecGrpI</IndexLocation>
<StreamLocation>^DHCMGNUR.MgNurSecGrpS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
