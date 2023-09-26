Class DHCEPRFS.META.MRAction Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 操作编码
Property ActionCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

/// 操作名称
Property ActionName As %String(TRUNCATE = 1) [ SqlColumnNumber = 3 ];

/// 操作编码
Property IsActive As %Boolean [ SqlColumnNumber = 4 ];

/// 类别编码 (PROCESS=病案处理、USE=病案使用 目前只有打印是病案使用，其他为病案处理)
Property CategoryCode As %String [ SqlColumnNumber = 5 ];

/// 类别名称 
Property CategoryName As %String [ SqlColumnNumber = 6 ];

Property OrderNo As %Integer [ SqlColumnNumber = 7 ];

Index IdxActiveAction On (IsActive, OrderNo);

Index IdxMain On ActionCode [ Unique ];

Storage Default
{
<Data name="MRActionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ActionCode</Value>
</Value>
<Value name="3">
<Value>ActionName</Value>
</Value>
<Value name="4">
<Value>IsActive</Value>
</Value>
<Value name="5">
<Value>CategoryCode</Value>
</Value>
<Value name="6">
<Value>CategoryName</Value>
</Value>
<Value name="7">
<Value>OrderNo</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.META.MRActionD</DataLocation>
<DefaultData>MRActionDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.META.MRActionD</IdLocation>
<IndexLocation>^DHCEPRFS.META.MRActionI</IndexLocation>
<StreamLocation>^DHCEPRFS.META.MRActionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
