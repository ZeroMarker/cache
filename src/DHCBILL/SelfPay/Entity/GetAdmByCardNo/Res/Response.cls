Class DHCBILL.SelfPay.Entity.GetAdmByCardNo.Res.Response Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 0;

/// ResultCode 结果标志
Property ResultCode As %String(TRUNCATE = 1);

/// ResultMsg 结果描述
Property ResultMsg As %String(TRUNCATE = 1);

/// AdmList	就诊信息列表
Property AdmList As list Of DHCBILL.SelfPay.Entity.GetAdmByCardNo.Res.AdmItem(XMLITEMNAME = "AdmItem", XMLPROJECTION = "COLLECTION");

Storage Default
{
<Data name="ResponseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCBILL.SelfPay.EDC1E.ResponseD</DataLocation>
<DefaultData>ResponseDefaultData</DefaultData>
<IdLocation>^DHCBILL.SelfPay.EDC1E.ResponseD</IdLocation>
<IndexLocation>^DHCBILL.SelfPay.EDC1E.ResponseI</IndexLocation>
<StreamLocation>^DHCBILL.SelfPay.EDC1E.ResponseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
