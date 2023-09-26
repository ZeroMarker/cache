Class EMRinstance.InstanceDataCompressInfo Extends %Persistent
{

/// 文档ID
Property InstanceID As %String;

/// 压缩标识（TRUE 插件压缩，FALSE或空 未压缩）
Property IsCompress As %String;

/// 后端压缩标识（1 后台压缩，0 后台未压缩）
Property IsBKCompress As %String;

Index IdxInstanceID On InstanceID;

Index IdxInstanceCompress On (InstanceID, IsCompress);

Index IdxInstanceBKCompress On (InstanceID, IsBKCompress);

Storage Default
{
<Data name="InstanceDataCompressInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>InstanceID</Value>
</Value>
<Value name="3">
<Value>IsCompress</Value>
</Value>
<Value name="4">
<Value>IsBKCompress</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.InstanceDataCompressD</DataLocation>
<DefaultData>InstanceDataCompressInfoDefaultData</DefaultData>
<IdLocation>^DHCEMRI.InstanceDataCompressD</IdLocation>
<IndexLocation>^DHCEMRI.InstanceDataCompressI</IndexLocation>
<StreamLocation>^DHCEMRI.InstanceDataCompressS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
