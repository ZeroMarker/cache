Class DHCExternalService.BillInterface.DHCEntity.RecLoc Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

//Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

//=1 导入时忽略不存在的属性；=0 导入时有不存在的属性会报错。

Parameter XMLIGNOREINVALIDTAG = 1;

//=0 导入时有不存在的元素会报错；=1 导入时忽略不存在的元素。

//Parameter XMLIGNORENULL = 1;

//Parameter XMLSEQUENCE = 0;

/// MobileNo	手机/电话号码
Property RecLocCode As %String(TRUNCATE = 1);

Property RecLocDesc As %String(TRUNCATE = 1);

/// PayAmt	扣款总金额
Property RecLocAddress As %String(TRUNCATE = 1);

Property Items As list Of DHCExternalService.BillInterface.DHCEntity.OEOrdItem(XMLITEMNAME = "OEOrdItem", XMLPROJECTION = "ELEMENT");

Storage Default
{
<Data name="RecLocDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RecLocDesc</Value>
</Value>
<Value name="3">
<Value>RecLocAddress</Value>
</Value>
<Value name="4">
<Value>Items</Value>
</Value>
</Data>
<DataLocation>^DHCExternalServiceD9A8.RecLocD</DataLocation>
<DefaultData>RecLocDefaultData</DefaultData>
<IdLocation>^DHCExternalServiceD9A8.RecLocD</IdLocation>
<IndexLocation>^DHCExternalServiceD9A8.RecLocI</IndexLocation>
<StreamLocation>^DHCExternalServiceD9A8.RecLocS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
