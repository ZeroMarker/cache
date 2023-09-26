/// Creator:阚延新
/// CreatDate:2020-10-10
/// Description：实施综合管理平台-记录类型字典表
/// Table：User.DHCDSSRecordType
Class CT.WDT.CDSS.RecordType Extends (%Persistent, User.Abstract)
{

/// 记录类型名称
Property RecordTypeCode As %String;

/// 记录类型名称
Property RecordTypeName As %String;

/// 使用标志（0在用，1停用）
Property UseFlag As %String;

/// 备注
Property Remarks As %String;

/// d ##class(User.DHCDSSRecordType).%BuildIndices()
Index RecordTypeCodeIndex On RecordTypeCode;

Index RecordTypeNameIndex On RecordTypeName;

Storage Default
{
<Data name="RecordTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RecordTypeCode</Value>
</Value>
<Value name="3">
<Value>RecordTypeName</Value>
</Value>
<Value name="4">
<Value>UseFlag</Value>
</Value>
<Value name="5">
<Value>Remarks</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.RecordTypeD</DataLocation>
<DefaultData>RecordTypeDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.RecordTypeD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.RecordTypeI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.RecordTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
