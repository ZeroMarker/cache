Class DHCWL.VerManagement.VerManagement Extends DHCWL.VerManagement.VerData
{

///  pl
///  2016-02-02
///  向版本管理中插入版本信息
///  DHCWL.VerManagement.VerData
///  select * from DHCWL_VerManagement.VerData  
Parameter VMDName;

Parameter VMDCode;

Parameter VMDTSName;

Parameter VMDUpDate;

Parameter VMDremarks;

//s VM=##class(DHCWL.VerManagement.VerManagement).%New()

//d VM.Insert()

Method %OnNew() As %Status
{
 s ..VMDName = "版本管理"

 s ..VMDCode = "V1.0.0"

 s ..VMDTSName = "潘磊"

 s ..VMDUpDate = "2016-02-01"
 
 s ..VMDremarks=""

 q 1
}

Storage Default
{
<Data name="VerManagementDefaultData">
<Subscript>"VerManagement"</Subscript>
<Value name="1">
<Value>Note</Value>
</Value>
</Data>
<DefaultData>VerManagementDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

Storage Storage
{
<Type>%Storage.Persistent</Type>
}

}
