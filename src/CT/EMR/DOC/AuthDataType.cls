/// 名称:	CT.EMR.DOC.AuthDataType
/// 描述:	申请授权数据类型表
/// 编写者:	yejian
/// 编写日期: 2023-5-16
/// 产品组：电子病历产品组
Class CT.EMR.DOC.AuthDataType Extends %Persistent
{

Index IdxCode On Code;

/// 编码(TEMPLATE/DOCUMENT/VIEW)
Property Code As %String(TRUNCATE = 1);

/// 名称(模板/病历/浏览)
Property Name As %String(TRUNCATE = 1);

Storage Default
{
<Data name="AuthDataTypeDefaultData">
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
<DataLocation>^CT.EMR.DOC.AuthDataTypeD</DataLocation>
<DefaultData>AuthDataTypeDefaultData</DefaultData>
<IdLocation>^CT.EMR.DOC.AuthDataTypeD</IdLocation>
<IndexLocation>^CT.EMR.DOC.AuthDataTypeI</IndexLocation>
<StreamLocation>^CT.EMR.DOC.AuthDataTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
