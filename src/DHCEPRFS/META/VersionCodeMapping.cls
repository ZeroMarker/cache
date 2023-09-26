Class DHCEPRFS.META.VersionCodeMapping Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 版本号
Property Version As %String(TRUNCATE = 1);

/// 版本号代码
Property VersionCode As %String(TRUNCATE = 1);

/// 版本号描述
Property VersionDesc As %String(TRUNCATE = 1);

Index IdxVersion On Version [ Unique ];

Index IdxVersionCode On VersionCode [ Unique ];

Storage Default
{
<Data name="VersionCodeMappingDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Version</Value>
</Value>
<Value name="3">
<Value>VersionCode</Value>
</Value>
<Value name="4">
<Value>VersionDesc</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.META.VersionCodeD</DataLocation>
<DefaultData>VersionCodeMappingDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.META.VersionCodeD</IdLocation>
<IndexLocation>^DHCEPRFS.META.VersionCodeI</IndexLocation>
<StreamLocation>^DHCEPRFS.META.VersionCodeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
