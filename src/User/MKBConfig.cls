Class User.MKBConfig Extends (%Persistent, User.Abstract) [ SqlTableName = MKB_Config ]
{

/// 配置项代码
Property ConfigCode As %String(MAXLEN = "") [ Required ];

/// 配置项描述
Property ConfigDesc As %String(MAXLEN = "") [ Required ];

/// 配置项值
Property ConfigValue As %String(MAXLEN = "");

/// 配置项类型
Property ConfigType As %String(DISPLAYLIST = ",String,Number,Date,Html,Radio,CheckBox,Combox", VALUELIST = ",S,N,D,H,R,CB,C");

/// 配置项说明
Property ConfigExplain As %String;

/// 是否激活
Property ConfigActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "Y" ];

/// 是否可修改
Property ConfigEdit As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "Y" ];

/// 根据代码查询rowid的索引
Index ConfigCodeI On ConfigCode [ Unique ];

Index ConfigDescI On ConfigDesc [ Unique ];

Storage Default
{
<Data name="MKBConfigClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="MKBConfigDefaultData">
<Value name="1">
<Value>ConfigCode</Value>
</Value>
<Value name="2">
<Value>ConfigDesc</Value>
</Value>
<Value name="3">
<Value>ConfigValue</Value>
</Value>
<Value name="4">
<Value>ConfigType</Value>
</Value>
<Value name="5">
<Value>ConfigExplain</Value>
</Value>
<Value name="6">
<Value>ConfigActive</Value>
</Value>
<Value name="7">
<Value>ConfigEdit</Value>
</Value>
</Data>
<DataLocation>^User.MKBConfigD</DataLocation>
<DefaultData>MKBConfigDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.MKBConfigD</IdLocation>
<IndexLocation>^User.MKBConfigI</IndexLocation>
<StreamLocation>^User.MKBConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
