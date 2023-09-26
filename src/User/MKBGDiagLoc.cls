Class User.MKBGDiagLoc Extends %Persistent
{

/// 从生到死诊断表指针
Property DiaDR As User.MKBGlobal [ Required ];

/// 专业科室
Property ProfDeptDR As User.MKBTerm;

/// 科室频次
Property Frequency As %String;

Index DiaDRIndex On DiaDR;

Index ProfDeptDRIndex On (DiaDR, ProfDeptDR);

Storage Default
{
<Data name="MKBGDiagLocDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DiaDR</Value>
</Value>
<Value name="3">
<Value>ProfDeptDR</Value>
</Value>
<Value name="4">
<Value>Frequency</Value>
</Value>
</Data>
<DataLocation>^User.MKBGDiagLocD</DataLocation>
<DefaultData>MKBGDiagLocDefaultData</DefaultData>
<IdLocation>^User.MKBGDiagLocD</IdLocation>
<IndexLocation>^User.MKBGDiagLocI</IndexLocation>
<StreamLocation>^User.MKBGDiagLocS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
