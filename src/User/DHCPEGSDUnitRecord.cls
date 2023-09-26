/// 总检建议合并记录
Class User.DHCPEGSDUnitRecord Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_GSDUnitRecord ]
{

Parameter ClassName = "User.DHCPEGSDUnitRecord";

/// 总检小结的ID
Property URGSDDR As User.DHCPEGeneralSummarize [ SqlFieldName = UR_GSD_DR ];

/// 保留建议ID
Property URHoldSource As %String [ SqlFieldName = UR_HoldSource ];

/// 取消建议ID串
Property URCancelSource As %String [ SqlFieldName = UR_CancelSource ];

/// 保留建议结论
Property URHoldSourceConclusion As %String(MAXLEN = 500) [ SqlFieldName = UR_HoldSourceConclusion ];

/// 保留建议内容
Property URHoldSourceDetail As %String(MAXLEN = 900) [ SqlFieldName = UR_HoldSourceDetail ];

/// 合并人
Property URUserDR As User.SSUser [ SqlFieldName = UR_User_DR ];

/// 合并日期
Property URDate As %Date [ SqlFieldName = UR_Date ];

/// 合并时间
Property URTime As %Time [ SqlFieldName = UR_Time ];

Index GSDIndex On URGSDDR;

Storage Default
{
<Data name="DHCPEGSDUnitRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>URGSDDR</Value>
</Value>
<Value name="3">
<Value>URHoldSource</Value>
</Value>
<Value name="4">
<Value>URCancelSource</Value>
</Value>
<Value name="5">
<Value>URHoldSourceConclusion</Value>
</Value>
<Value name="6">
<Value>URHoldSourceDetail</Value>
</Value>
<Value name="7">
<Value>URUserDR</Value>
</Value>
<Value name="8">
<Value>URDate</Value>
</Value>
<Value name="9">
<Value>URTime</Value>
</Value>
</Data>
<DataLocation>^User.DHCPEGSDUnitRecordD</DataLocation>
<DefaultData>DHCPEGSDUnitRecordDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPEGSDUnitRecordD</IdLocation>
<IndexLocation>^User.DHCPEGSDUnitRecordI</IndexLocation>
<StreamLocation>^User.DHCPEGSDUnitRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
