/// 迟归生成项目配置表
Class DHCEPRFS.META.LateToCreate Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 迟归生成类型
Property CreateType As %String(MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 2 ];

/// 生成项目
Property MRItems As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 3 ];

/// 添加到生成队列的接口地址
Property Interface As %String(MAXLEN = 50000, TRUNCATE = 1) [ SqlColumnNumber = 4 ];

Index IdxCreateType On CreateType;

Index IdxMRItem On MRItems;

Storage Default
{
<Data name="LateToCreateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CreateType</Value>
</Value>
<Value name="3">
<Value>MRItems</Value>
</Value>
<Value name="4">
<Value>Interface</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.META.LateToCreateD</DataLocation>
<DefaultData>LateToCreateDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.META.LateToCreateD</IdLocation>
<IndexLocation>^DHCEPRFS.META.LateToCreateI</IndexLocation>
<StreamLocation>^DHCEPRFS.META.LateToCreateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
