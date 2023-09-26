/// 下收下送线路时间控制
Class User.CSSDSendRoadLineControl Extends (%Persistent, User.Abstract) [ SqlTableName = CSSD_SendRoadLineControl ]
{

/// 主表id
Property CSSDSRLCRoadLineDR As User.CSSDSendRoadLineMain [ SqlColumnNumber = 2, SqlFieldName = CSSDSRLC_RoadLineDR ];

/// 开始时间
Property CSSDSRLCStartTime As %Time [ SqlColumnNumber = 3, SqlFieldName = CSSDSRLC_StartTime ];

/// 结束时间
Property CSSDSRLCEndTime As %Time [ SqlColumnNumber = 4, SqlFieldName = CSSDSRLC_EndTime ];

Index RoadLine On CSSDSRLCRoadLineDR As Exact;

Storage Default
{
<Data name="CSSDSendRoadLineControlDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CSSDSRLCRoadLineDR</Value>
</Value>
<Value name="3">
<Value>CSSDSRLCStartTime</Value>
</Value>
<Value name="4">
<Value>CSSDSRLCEndTime</Value>
</Value>
</Data>
<DataLocation>^User.CSSDSendRoadLineControlD</DataLocation>
<DefaultData>CSSDSendRoadLineControlDefaultData</DefaultData>
<IdLocation>^User.CSSDSendRoadLineControlD</IdLocation>
<IndexLocation>^User.CSSDSendRoadLineControlI</IndexLocation>
<StreamLocation>^User.CSSDSendRoadLineControlS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
