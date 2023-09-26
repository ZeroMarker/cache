/// Desc: 病历修改历史
/// Creator: Candyxu
/// CreateDate: 2021-7-26
Class EMRinstance.RevisionLog Extends %Persistent
{

Index IdxMain On (InstanceID, RevisionID) [ Unique ];

Index IdxDateTime On (RevisionDate, RevisionTime);

/// 实例ID	
Property InstanceID As EMRinstance.InstanceData [ SqlColumnNumber = 2 ];

/// 修改历史ID	
Property RevisionID As %Integer [ SqlColumnNumber = 3 ];

/// 修改日期	
Property RevisionDate As %Date [ SqlColumnNumber = 4 ];

/// 修改时间	
Property RevisionTime As %Time [ SqlColumnNumber = 5 ];

/// 修改人	
Property UserID As User.SSUser [ SqlColumnNumber = 6 ];

/// 病历数据（RevisionID对应变更病历内容）
Property InstanceData As %GlobalCharacterStream(LOCATION = "^DHCEMRI.RevisionLogS") [ SqlColumnNumber = 7 ];

/// 时间戳	
Property TimeStamp As %Integer [ SqlColumnNumber = 8 ];

Storage Default
{
<Data name="RevisionLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>InstanceID</Value>
</Value>
<Value name="3">
<Value>RevisionID</Value>
</Value>
<Value name="4">
<Value>RevisionDate</Value>
</Value>
<Value name="5">
<Value>RevisionTime</Value>
</Value>
<Value name="6">
<Value>UserID</Value>
</Value>
<Value name="7">
<Value>InstanceData</Value>
</Value>
<Value name="8">
<Value>TimeStamp</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.RevisionLogD</DataLocation>
<DefaultData>RevisionLogDefaultData</DefaultData>
<IdLocation>^DHCEMRI.RevisionLogD</IdLocation>
<IndexLocation>^DHCEMRI.RevisionLogI</IndexLocation>
<StreamLocation>^DHCEMRI.RevisionLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
