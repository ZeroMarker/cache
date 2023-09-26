Class User.DHCSpecLocDiagItem Extends %Persistent [ SqlTableName = DHC_SpecLocDiagItem ]
{

Index IndexCat On CatDR;

Index IndexCode On (CatDR, Code) [ Unique ];

/// 分类指向
Property CatDR As DHCSpecLocDiagCat;

/// 项目代码
Property Code As %String(TRUNCATE = 1);

/// 项目名称
Property Name As %String(TRUNCATE = 1);

/// 项目是否有效
Property Active As %String(TRUNCATE = 1);

/// 项目在表单中显示顺序
Property Sequence As %Float;

/// 项目控件类型(combobox,textbox,numberbox,...)
Property Type As %String(TRUNCATE = 1);

/// 项目控件属性
Property Options As %String(MAXLEN = 999, TRUNCATE = 1);

/// 项目CSS属性
Property Style As %String(MAXLEN = 500, TRUNCATE = 1);

Storage Default
{
<Data name="DHCSpecLocDiagItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CatDR</Value>
</Value>
<Value name="3">
<Value>Code</Value>
</Value>
<Value name="4">
<Value>Name</Value>
</Value>
<Value name="5">
<Value>Active</Value>
</Value>
<Value name="6">
<Value>Sequence</Value>
</Value>
<Value name="7">
<Value>Type</Value>
</Value>
<Value name="8">
<Value>Options</Value>
</Value>
<Value name="9">
<Value>Style</Value>
</Value>
</Data>
<DataLocation>^User.DHCSpecLocDiagItemD</DataLocation>
<DefaultData>DHCSpecLocDiagItemDefaultData</DefaultData>
<IdLocation>^User.DHCSpecLocDiagItemD</IdLocation>
<IndexLocation>^User.DHCSpecLocDiagItemI</IndexLocation>
<StreamLocation>^User.DHCSpecLocDiagItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
