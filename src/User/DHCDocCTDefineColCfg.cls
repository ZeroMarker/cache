Class User.DHCDocCTDefineColCfg Extends %Persistent [ SqlTableName = DHCDoc_CT_DefineColCfg ]
{

Index IndexCode On (DefineDR, Code) [ Unique ];

Index IndexSequece On (DefineDR, Sequence) [ Unique ];

/// 指向代码表
Property DefineDR As DHCDocCTDefine;

/// 项目代码
Property Code As %String(TRUNCATE = 1);

/// 项目名称
Property Name As %String(TRUNCATE = 1);

/// 项目是否有效
Property Active As %String(TRUNCATE = 1);

/// 项目在表单中显示顺序
Property Sequence As %Integer;

/// 项目控件类型(combobox,textbox,numberbox,...)
Property Type As %String(TRUNCATE = 1);

/// 项目控件属性
Property Options As %String(MAXLEN = 999, TRUNCATE = 1);

/// 项目CSS属性
Property Style As %String(MAXLEN = 500, TRUNCATE = 1);

Storage Default
{
<Data name="DHCDocCTDefineColCfgDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DefineDR</Value>
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
<DataLocation>^User.DHCDocCTDefineColCfgD</DataLocation>
<DefaultData>DHCDocCTDefineColCfgDefaultData</DefaultData>
<IdLocation>^User.DHCDocCTDefineColCfgD</IdLocation>
<IndexLocation>^User.DHCDocCTDefineColCfgI</IndexLocation>
<StreamLocation>^User.DHCDocCTDefineColCfgS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
