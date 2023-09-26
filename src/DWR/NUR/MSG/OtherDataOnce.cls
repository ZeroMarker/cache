/// 其他每天一次的数据
Class DWR.NUR.MSG.OtherDataOnce Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ Inheritance = right ]
{

Parameter XMLNAME = "OtherDataOnce";

/// 项目名称
Property ItemName As %String(MAXLEN = 50, TRUNCATE = 1);

/// 项目数据      
Property ItemValue As %String(MAXLEN = 50, TRUNCATE = 1);

Storage Default
{
<Data name="OtherDataOnceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ItemName</Value>
</Value>
<Value name="3">
<Value>ItemValue</Value>
</Value>
</Data>
<DataLocation>^DWR.NUR.MSG.OtherDataOnceD</DataLocation>
<DefaultData>OtherDataOnceDefaultData</DefaultData>
<IdLocation>^DWR.NUR.MSG.OtherDataOnceD</IdLocation>
<IndexLocation>^DWR.NUR.MSG.OtherDataOnceI</IndexLocation>
<StreamLocation>^DWR.NUR.MSG.OtherDataOnceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
