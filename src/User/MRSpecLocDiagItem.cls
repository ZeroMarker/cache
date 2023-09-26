Class User.MRSpecLocDiagItem Extends %Persistent [ SqlTableName = MR_SpecLocDiagItem ]
{

Index IndexItem On (ParRefDR, ItemDR) [ Unique ];

/// 指向表单分类填写表
Property ParRefDR As User.MRSpecLocDiag;

/// 指向表单项目配置表
Property ItemDR As User.DHCSpecLocDiagItem;

/// 表单项目填写值
Property Value As %String(MAXLEN = 99999, TRUNCATE = 1);

Storage Default
{
<Data name="MRSpecLocDiagItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ParRefDR</Value>
</Value>
<Value name="3">
<Value>ItemDR</Value>
</Value>
<Value name="4">
<Value>Value</Value>
</Value>
</Data>
<DataLocation>^User.MRSpecLocDiagItemD</DataLocation>
<DefaultData>MRSpecLocDiagItemDefaultData</DefaultData>
<IdLocation>^User.MRSpecLocDiagItemD</IdLocation>
<IndexLocation>^User.MRSpecLocDiagItemI</IndexLocation>
<StreamLocation>^User.MRSpecLocDiagItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
