/// Creator:钟荣枫
/// CreatDate:2020-06-03
/// Description：实施综合管理平台-医院字典表
/// Table：CT.WDT.CDSS.CustomerHosp
Class CT.WDT.CDSS.CustomerHosp Extends (%Persistent, User.Abstract)
{

Relationship ChildExt As CT.WDT.CDSS.CustomerHospArea [ Cardinality = children, Inverse = ParRef ];

/// 医院编码
Property HospitalCode As %String [ Required ];

/// 医院名称
Property HospitalName As %String;

/// 创建时间
Property CreateDate As %TimeStamp;

/// 创建人员
Property Creator As %String;

/// 备注
Property Remarks As %String;

Index CodeIndex On HospitalCode [ Unique ];

Index NameIndex On HospitalName;

Storage Default
{
<Data name="CustomerHospDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>HospitalCode</Value>
</Value>
<Value name="3">
<Value>HospitalName</Value>
</Value>
<Value name="4">
<Value>CreateDate</Value>
</Value>
<Value name="5">
<Value>Creator</Value>
</Value>
<Value name="6">
<Value>Remarks</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.CustomerHospD</DataLocation>
<DefaultData>CustomerHospDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.CustomerHospD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.CustomerHospI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.CustomerHospS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
