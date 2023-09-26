/// 名称:	CT.MA.QC.QualityOrderInfo
/// 描述:	医嘱项目维护
/// 编写者：whb
/// 编写日期: 2021-05-24
Class CT.MA.QC.QualityOrderInfo Extends (%Persistent, User.Abstract)
{

Index IdxDictionaryID On DictionaryID;

Index IdxOrderDictionaryID On (OrderID, DictionaryID) [ Unique ];

/// 医嘱ID
Property OrderID As %String(TRUNCATE = 1);

/// 医嘱名称
Property OrderName As %String(TRUNCATE = 1);

/// 所属分类
Property DictionaryID As %String(TRUNCATE = 1);

/// 是否有效
Property IsActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N");

/// 备注文本
Property ResumeText As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0);

Storage Default
{
<Data name="QualityOrderInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OrderID</Value>
</Value>
<Value name="3">
<Value>OrderName</Value>
</Value>
<Value name="4">
<Value>DictionaryID</Value>
</Value>
<Value name="5">
<Value>IsActive</Value>
</Value>
<Value name="6">
<Value>ResumeText</Value>
</Value>
</Data>
<DataLocation>^CT.MA.QC.QualityOrderInfoD</DataLocation>
<DefaultData>QualityOrderInfoDefaultData</DefaultData>
<IdLocation>^CT.MA.QC.QualityOrderInfoD</IdLocation>
<IndexLocation>^CT.MA.QC.QualityOrderInfoI</IndexLocation>
<StreamLocation>^CT.MA.QC.QualityOrderInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
