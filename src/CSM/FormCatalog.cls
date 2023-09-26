Class CSM.FormCatalog Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 所在项目的ID
Property ProjectID As %Integer [ Required ];

/// 名称
Property Name As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 名称
Property Description As %String(MAXLEN = 500, TRUNCATE = 1);

Storage Default
{
<Data name="FormCatalogDefaultData">
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
<Value>ProjectID</Value>
</Value>
</Data>
<DataLocation>^CSM.FormCatalogD</DataLocation>
<DefaultData>FormCatalogDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CSM.FormCatalogD</IdLocation>
<IndexLocation>^CSM.FormCatalogI</IndexLocation>
<StreamLocation>^CSM.FormCatalogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
