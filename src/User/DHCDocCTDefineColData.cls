Class User.DHCDocCTDefineColData Extends %Persistent [ SqlTableName = DHCDoc_CT_DefineColData ]
{

Index IndexDefData On (DefineDataDR, ColCfgDR) [ Unique ];

/// 指向代码子表
Property DefineDataDR As DHCDocCTDefineData;

/// 指向列配置表
Property ColCfgDR As DHCDocCTDefineColCfg;

/// 值
Property Value As %String(MAXLEN = 500, TRUNCATE = 1);

Storage Default
{
<Data name="DHCDocCTDefineColDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DefineDataDR</Value>
</Value>
<Value name="3">
<Value>ColCfgDR</Value>
</Value>
<Value name="4">
<Value>Value</Value>
</Value>
</Data>
<DataLocation>^User.DHCDocCTDefineColDataD</DataLocation>
<DefaultData>DHCDocCTDefineColDataDefaultData</DefaultData>
<IdLocation>^User.DHCDocCTDefineColDataD</IdLocation>
<IndexLocation>^User.DHCDocCTDefineColDataI</IndexLocation>
<StreamLocation>^User.DHCDocCTDefineColDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
