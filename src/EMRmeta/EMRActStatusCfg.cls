/// Desc:存储操作和状态的对应关系，用于判断处于某状态的病历能否执行某操作，以及由前状态和操作得到后状态
/// Creator: candy
/// createDate: 2014-3-19
Class EMRmeta.EMRActStatusCfg Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 操作Code(EMRmeta.EMRAction)
Property EMRAction As %String(TRUNCATE = 1);

/// 操作前状态Code(EMRmeta.EMRAction)
Property PreStatus As %String(TRUNCATE = 1);

/// 操作后状态Code(EMRmeta.EMRAction)
Property PostStatus As %String(TRUNCATE = 1);

Index IdxUnique On (PreStatus, EMRAction) [ Unique ];

Storage Default
{
<Data name="EMRActStatusCfgDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EMRAction</Value>
</Value>
<Value name="3">
<Value>PreStatus</Value>
</Value>
<Value name="4">
<Value>PostStatus</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.EMRActStatusCfgD</DataLocation>
<DefaultData>EMRActStatusCfgDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.EMRActStatusCfgD</IdLocation>
<IndexLocation>^DHCEMRM.EMRActStatusCfgI</IndexLocation>
<StreamLocation>^DHCEMRM.EMRActStatusCfgS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
