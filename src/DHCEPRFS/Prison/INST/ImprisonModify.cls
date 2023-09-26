/// 转监信息记录表
/// Creator：liushuang
/// date:2018-01-23
Class DHCEPRFS.Prison.INST.ImprisonModify Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 监禁编号
Property PAINumber As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

/// 旧监狱code
Property OldEscortUnitCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 3 ];

/// 旧监区code
Property OldEscortUnitRegionCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 4 ];

/// 新监狱code
Property NewEscortUnitCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 5 ];

/// 新监区code
Property NewEscortUnitRegionCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 6 ];

/// 创建日期
Property CreateDate As %Date [ SqlColumnNumber = 7 ];

/// 创建时间
Property CreateTime As %Time [ SqlColumnNumber = 8 ];

Index IdxPAINumber On PAINumber;

Storage Default
{
<Data name="ImprisonModifyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PAINumber</Value>
</Value>
<Value name="3">
<Value>OldEscortUnitCode</Value>
</Value>
<Value name="4">
<Value>OldEscortUnitRegionCode</Value>
</Value>
<Value name="5">
<Value>NewEscortUnitCode</Value>
</Value>
<Value name="6">
<Value>NewEscortUnitRegionCode</Value>
</Value>
<Value name="7">
<Value>CreateDate</Value>
</Value>
<Value name="8">
<Value>CreateTime</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.Prison.INST.IPMD</DataLocation>
<DefaultData>ImprisonModifyDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.Prison.INST.IPMD</IdLocation>
<IndexLocation>^DHCEPRFS.Prison.INST.IPMI</IndexLocation>
<StreamLocation>^DHCEPRFS.Prison.INST.IPMS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
