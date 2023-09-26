/// 基础数据平台配置
/// 2014-08-29 caihaozhe
Class User.BDPConfig Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlTableName = BDP_Config ]
{

/// 配置项代码
Property ConfigCode As %String(MAXLEN = "") [ Required ];

/// 配置项描述
Property ConfigDesc As %String(MAXLEN = "") [ Required ];

/// 配置项值 2020-02-04不限制长度
Property ConfigValue As %String(MAXLEN = "");

/// 配置项类型
Property ConfigType As %String(DISPLAYLIST = ",String,Number,Date,Html,Radio,CheckBox,Combox", VALUELIST = ",S,N,D,H,R,C,CB");

/// 配置项说明
Property ConfigExplain As %String(MAXLEN = "");

/// 是否激活
Property ConfigActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "Y" ];

/// 是否可修改
Property ConfigEdit As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "Y" ];

/// 初始值（用于恢复默认时取值，add@2020-09-28）
Property ConfigInitialvalue As %String(MAXLEN = "");

/// 根据代码查询rowid的索引
Index ConfigCodeI On ConfigCode [ Unique ];

Index ConfigDescI On ConfigDesc [ Unique ];

Storage Default
{
<Data name="BDPConfigClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="BDPConfigDefaultData">
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
<Value name="8">
<Value>ConfigInitialvalue</Value>
</Value>
</Data>
<DataLocation>^User.BDPConfigD</DataLocation>
<DefaultData>BDPConfigDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.BDPConfigD</IdLocation>
<IndexLocation>^User.BDPConfigI</IndexLocation>
<StreamLocation>^User.BDPConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
