Class DHCEPRFS.INST.MRMedRecord Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 02 病案号
Property MedRecordNo As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

/// 03 归档系统病人ID
Property MRPatientID As %String(TRUNCATE = 1) [ SqlColumnNumber = 3 ];

/// 04 系统标示
Property SysCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 4 ];

/// 05 创建日期
Property CreateDate As %Date [ SqlColumnNumber = 5 ];

/// 06 创建时间
Property CreateTime As %Time [ SqlColumnNumber = 6 ];

/// 07 最后修改日期
Property LastModifyDate As %Date [ SqlColumnNumber = 7 ];

/// 08 最后修改时间
Property LastModifyTime As %Time [ SqlColumnNumber = 8 ];

/// 09 是否HIS病案号
Property IsHISMedRecord As %String(TRUNCATE = 1) [ SqlColumnNumber = 9 ];

Index IdxMedRecordNo On (SysCode, MedRecordNo);

Index IdxMain On (SysCode, IsHISMedRecord, MedRecordNo) [ Unique ];

Index IdxMRPatientID On MRPatientID;

Index IdxCreateDate On CreateDate;

Storage Default
{
<Data name="MRMedRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MedRecordNo</Value>
</Value>
<Value name="3">
<Value>MRPatientID</Value>
</Value>
<Value name="4">
<Value>CreateDate</Value>
</Value>
<Value name="5">
<Value>CreateTime</Value>
</Value>
<Value name="6">
<Value>LastModifyDate</Value>
</Value>
<Value name="7">
<Value>LastModifyTime</Value>
</Value>
<Value name="8">
<Value>SysCode</Value>
</Value>
<Value name="9">
<Value>IsHISMedRecord</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.MRMedRecordD</DataLocation>
<DefaultData>MRMedRecordDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.INST.MRMedRecordD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.MRMedRecordI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.MRMedRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
