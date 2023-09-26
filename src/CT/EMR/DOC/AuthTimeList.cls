/// 名称:	CT.EMR.DOC.AuthTimeList
/// 描述:	申请授权时间列表
/// 编写者:	yejian
/// 编写日期: 2023-5-16
/// 产品组：电子病历产品组
Class CT.EMR.DOC.AuthTimeList Extends %Persistent
{

Index IdxCode On Code;

/// 编码(ONEH/TWOH/FIVEH/TENH/ONED/TOWD/THREED/ONEW)
Property Code As %String(TRUNCATE = 1);

/// 名称(1小时/2小时/5小时/10小时/24小时/48小时/72小时/1周)
Property Name As %String(TRUNCATE = 1);

Storage Default
{
<Data name="AuthTimeListDefaultData">
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
<DataLocation>^CT.EMR.DOC.AuthTimeListD</DataLocation>
<DefaultData>AuthTimeListDefaultData</DefaultData>
<IdLocation>^CT.EMR.DOC.AuthTimeListD</IdLocation>
<IndexLocation>^CT.EMR.DOC.AuthTimeListI</IndexLocation>
<StreamLocation>^CT.EMR.DOC.AuthTimeListS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
