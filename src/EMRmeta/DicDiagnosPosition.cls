/// Desc:       诊断部位字典
/// Creator:    Candy
/// CreateDate: 2017-9-8
Class EMRmeta.DicDiagnosPosition Extends (%Persistent, %XML.Adaptor, User.Abstract)
{

Index IdxCode On Code [ Unique ];

Index IdxSequence On Sequence;

/// 代码
Property Code As %String(TRUNCATE = 1);

/// 描述
Property Description As %String(TRUNCATE = 1);

/// 位置(在诊断描述的前面above\后面behind)
Property Location As %String(TRUNCATE = 1);

/// 顺序
Property Sequence As %Integer;

/// 是否有效
Property IsActive As %String(TRUNCATE = 1);

Storage Default
{
<Data name="DicDiagnosPositionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Description</Value>
</Value>
<Value name="4">
<Value>Location</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
<Value name="6">
<Value>IsActive</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.DicDiagnosPositionD</DataLocation>
<DefaultData>DicDiagnosPositionDefaultData</DefaultData>
<IdLocation>^DHCEMRM.DicDiagnosPositionD</IdLocation>
<IndexLocation>^DHCEMRM.DicDiagnosPositionI</IndexLocation>
<StreamLocation>^DHCEMRM.DicDiagnosPositionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
