/// Description： 医用知识库医为百科和医嘱对照表
/// Creator：谷雪萍
/// Date： 2020-03-18
Class User.MKBOrderContrast Extends (%Persistent, User.Abstract)
{

/// 医用知识库属性内容表ID
Property MKBDetailDr As User.MKBTermProDetail;

/// 医嘱项DR
Property MKBOrderDr As User.ARCItmMast;

/// 医用知识库属性DR
Property MKBPropertyDr As User.MKBTermProperty;

Index DetailDrIndex On MKBDetailDr;

Index OrderDrIndex On (MKBOrderDr, MKBDetailDr As Exact);

Index PropertyDrIndex On (MKBPropertyDr, MKBOrderDr As Exact);

Storage Default
{
<Data name="MKBOrderContrastDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MKBDetailDr</Value>
</Value>
<Value name="3">
<Value>MKBOrderDr</Value>
</Value>
<Value name="4">
<Value>MKBPropertyDr</Value>
</Value>
</Data>
<DataLocation>^User.MKBOrderContrastD</DataLocation>
<DefaultData>MKBOrderContrastDefaultData</DefaultData>
<IdLocation>^User.MKBOrderContrastD</IdLocation>
<IndexLocation>^User.MKBOrderContrastI</IndexLocation>
<StreamLocation>^User.MKBOrderContrastS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
