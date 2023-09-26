/// 患者收监信息记录
/// Creator：liushuang
/// date:2018-01-23
Class DHCEPRFS.Prison.INST.ImprisonInfo Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 监禁编号
Property PAINumber As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

/// 病人号
Property PatientID As %String(TRUNCATE = 1) [ SqlColumnNumber = 3 ];

/// 监狱code
Property EscortUnitCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 4 ];

/// 监区code
Property EscortUnitRegionCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 5 ];

/// 创建人
Property CreateUser As %String(TRUNCATE = 1) [ SqlColumnNumber = 6 ];

/// 创建日期
Property CreateDate As %Date [ SqlColumnNumber = 7 ];

/// 创建时间
Property CreateTime As %Time [ SqlColumnNumber = 8 ];

/// 入监日期
Property PAIInDate As %Date [ SqlColumnNumber = 9 ];

/// 入监时间
Property PAIInTime As %Time [ SqlColumnNumber = 10 ];

/// 出监日期
Property PAIOutDate As %Date [ SqlColumnNumber = 11 ];

/// 出监时间
Property PAIOutTime As %Time [ SqlColumnNumber = 12 ];

Index IdxPAINumber On PAINumber;

Storage Default
{
<Data name="ImprisonInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PAINumber</Value>
</Value>
<Value name="3">
<Value>PatientID</Value>
</Value>
<Value name="4">
<Value>EscortUnitCode</Value>
</Value>
<Value name="5">
<Value>EscortUnitRegionCode</Value>
</Value>
<Value name="6">
<Value>CreateUser</Value>
</Value>
<Value name="7">
<Value>CreateDate</Value>
</Value>
<Value name="8">
<Value>CreateTime</Value>
</Value>
<Value name="9">
<Value>PAIInDate</Value>
</Value>
<Value name="10">
<Value>PAIInTime</Value>
</Value>
<Value name="11">
<Value>PAIOutDate</Value>
</Value>
<Value name="12">
<Value>PAIOutTime</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.Prison.INST.IPD</DataLocation>
<DefaultData>ImprisonInfoDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.Prison.INST.IPD</IdLocation>
<IndexLocation>^DHCEPRFS.Prison.INST.IPI</IndexLocation>
<StreamLocation>^DHCEPRFS.Prison.INST.IPS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
