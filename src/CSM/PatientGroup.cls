/// 病人试验分组表
Class CSM.PatientGroup Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 描述
Property Description As %String(MAXLEN = 500, TRUNCATE = 1);

/// 父病人组ID(根节点组该值为0)
Property ParentID As %Integer [ Required ];

/// 名称
Property Name As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 所属项目ID
Property ProjectID As %Integer [ Required ];

/// 状态：正常1/取消0
Property Status As %String(MAXLEN = 1, TRUNCATE = 1) [ Required ];

Storage Default
{
<Data name="PatientGroupDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>ParentID</Value>
</Value>
<Value name="5">
<Value>ProjectID</Value>
</Value>
<Value name="6">
<Value>Status</Value>
</Value>
</Data>
<DataLocation>^CSM.PatientGroupD</DataLocation>
<DefaultData>PatientGroupDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CSM.PatientGroupD</IdLocation>
<IndexLocation>^CSM.PatientGroupI</IndexLocation>
<StreamLocation>^CSM.PatientGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
