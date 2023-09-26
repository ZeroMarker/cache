/// 名称:	CT.EMR.DOC.AuthRequestReason
/// 描述:	申请授权原因码表
/// 编写者:	yejian
/// 编写日期: 2023-5-16
/// 产品组：电子病历产品组
Class CT.EMR.DOC.AuthRequestReason Extends %Persistent
{

Index IdxCode On Code;

/// 编码(1/2/3/4/5)
Property Code As %Integer;

/// 名称(原因)
Property Name As %String(TRUNCATE = 1);

Storage Default
{
<Data name="AuthRequestReasonDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
</Data>
<DataLocation>^CT.EMR.DOC.AuthRequestReasonD</DataLocation>
<DefaultData>AuthRequestReasonDefaultData</DefaultData>
<IdLocation>^CT.EMR.DOC.AuthRequestReasonD</IdLocation>
<IndexLocation>^CT.EMR.DOC.AuthRequestReasonI</IndexLocation>
<StreamLocation>^CT.EMR.DOC.AuthRequestReasonS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
