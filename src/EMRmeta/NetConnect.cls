/// 保存提供给编辑器使用的网络链接
Class EMRmeta.NetConnect Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index IdxAddress On Address [ Unique ];

/// ECP的IP
Property Address As %String(TRUNCATE = 1);

/// 加密的链接串
Property DecryptConnect As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 秘钥KEY
Property DecryptKey As %String(TRUNCATE = 1);

Storage Default
{
<Data name="NetConnectDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Address</Value>
</Value>
<Value name="3">
<Value>DecryptConnect</Value>
</Value>
<Value name="4">
<Value>DecryptKey</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.NetConnectD</DataLocation>
<DefaultData>NetConnectDefaultData</DefaultData>
<IdLocation>^DHCEMRM.NetConnectD</IdLocation>
<IndexLocation>^DHCEMRM.NetConnectI</IndexLocation>
<StreamLocation>^DHCEMRM.NetConnectS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
