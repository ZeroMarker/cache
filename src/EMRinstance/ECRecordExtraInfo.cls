/// Desc:       实例数据关联信息
/// Creator:    Candy
/// CreateDate: 2016-12-15
Class EMRinstance.ECRecordExtraInfo Extends %Persistent
{

Index IdxMain On ECRecordID [ Unique ];

/// 实例数据父ID
Property ECRecordID As %Integer;

/// 最后一次修位置
Property LastModifyPosition As %String;

Storage Default
{
<Data name="ECRecordExtraInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LastModifyPosition</Value>
</Value>
<Value name="3">
<Value>ECRecordID</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.ECRecordExtraInfoD</DataLocation>
<DefaultData>ECRecordExtraInfoDefaultData</DefaultData>
<IdLocation>^DHCEMRI.ECRecordExtraInfoD</IdLocation>
<IndexLocation>^DHCEMRI.ECRecordExtraInfoI</IndexLocation>
<StreamLocation>^DHCEMRI.ECRecordExtraInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
