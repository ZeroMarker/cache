Class DHCNMG.Arg.MgNHTrackSub Extends %Persistent
{

Relationship Parref As DHCNMG.Arg.MgNurHeadTrack [ Cardinality = parent, Inverse = SubParref ];

/// 病区
Property TrackWardDR As DHCNMG.DB.MgWard [ SqlColumnNumber = 5, SqlFieldName = Track_WardDR ];

/// 存在问题
Property TrackProblem As %String(MAXLEN = 1000) [ SqlColumnNumber = 6, SqlFieldName = Track_Problem ];

/// 责任人
Property DutyPerson As list Of %String [ SqlColumnNumber = 7, SqlFieldName = Duty_Person ];

/// 加减分
Property TrackScore As %String [ SqlColumnNumber = 8, SqlFieldName = Track_Score ];

/// 备注
Property TrackRemark As %String [ SqlColumnNumber = 9, SqlFieldName = Track_Remark ];

Index Ward On TrackWardDR;

Storage Default
{
<Data name="MgNHTrackSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TrackWardDR</Value>
</Value>
<Value name="3">
<Value>TrackProblem</Value>
</Value>
<Value name="4">
<Value>DutyPerson</Value>
</Value>
<Value name="5">
<Value>TrackScore</Value>
</Value>
<Value name="6">
<Value>TrackRemark</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Arg.MgNHTrackSubD</DataLocation>
<DefaultData>MgNHTrackSubDefaultData</DefaultData>
<IdLocation>{%%PARENT}("SubParref")</IdLocation>
<IndexLocation>^DHCNMG.Arg.MgNHTrackSubI</IndexLocation>
<StreamLocation>^DHCNMG.Arg.MgNHTrackSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
