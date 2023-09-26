Class User.EnsSystemLinkStatus Extends (%Persistent, %XML.Adaptor) [ SqlTableName = Ens_SystemLinkStatus ]
{

/// 系统代码 对应表:Ens_System
Property ESSSystemCode As %String(COLLATION = "EXACT", MAXLEN = 32767) [ Required, SqlFieldName = ESS_SystemCode ];

/// 状态代码 对应表:Ens_StatusCode
Property ESSStatusCode As %String(COLLATION = "EXACT", MAXLEN = 32767) [ Required, SqlFieldName = ESS_StatusCode ];

/// 有效标志（Y:启用；N:停用）
Property ESSEffectiveFlag As %String(COLLATION = "EXACT") [ SqlFieldName = ESS_EffectiveFlag ];

/// 状态顺序（当前状态对当前系统业务流程来说所处的位置
/// 以123顺序排列，逆流程为对应正流程状态书序的负数
/// 如登记顺序为2，取消登记顺序为-2）
Property ESSSequence As %String(COLLATION = "EXACT", MAXLEN = 32767) [ SqlFieldName = ESS_Sequence ];

Index IndexSysStatus On (ESSSystemCode, ESSStatusCode) [ PrimaryKey, Type = index, Unique ];

Index IndexSysStatusSequence On (ESSSystemCode, ESSStatusCode, ESSSequence);

Index IndexSysSequenceStatus On (ESSSystemCode, ESSSequence, ESSStatusCode);

Index IndexStatusSys On (ESSStatusCode, ESSSystemCode);

Storage Default
{
<Data name="EnsSystemLinkStatusDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ESSSystemCode</Value>
</Value>
<Value name="3">
<Value>ESSStatusCode</Value>
</Value>
<Value name="4">
<Value>ESSEffectiveFlag</Value>
</Value>
<Value name="5">
<Value>ESSSequence</Value>
</Value>
</Data>
<DataLocation>^Config.ENS.EnsSystemLinkStatusD</DataLocation>
<DefaultData>EnsSystemLinkStatusDefaultData</DefaultData>
<IdLocation>^Config.ENS.EnsSystemLinkStatusD</IdLocation>
<IndexLocation>^Config.ENS.EnsSystemLinkStatusI</IndexLocation>
<StreamLocation>^Config.ENS.EnsSystemLinkStatusS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
