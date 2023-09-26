/// Desc:角色出院日期资源
Class DHCEPRFS.META.ResourceDisDate Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 起始日期
Property StartDate As %Date;

/// 截至日期
Property EndDate As %Date;

/// 永不过期标志
Property NoExpireFlag As %String(TRUNCATE = 1);

/// 有效标志
Property IsValid As %String(TRUNCATE = 1);

Storage Default
{
<Data name="ResourceDisDateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>StartDate</Value>
</Value>
<Value name="3">
<Value>EndDate</Value>
</Value>
<Value name="4">
<Value>NoExpireFlag</Value>
</Value>
<Value name="5">
<Value>IsValid</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.META.ResourceDisDateD</DataLocation>
<DefaultData>ResourceDisDateDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.META.ResourceDisDateD</IdLocation>
<IndexLocation>^DHCEPRFS.META.ResourceDisDateI</IndexLocation>
<StreamLocation>^DHCEPRFS.META.ResourceDisDateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
