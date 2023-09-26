/// creator: xbl
/// createDate: 2018-01-12
/// description: 护士长夜查房复查表
Class DHCNMG.Arg.MgNHTrackReviewSub Extends %Persistent
{

Relationship Parref As DHCNMG.Arg.MgNurHeadCheck [ Cardinality = parent, Inverse = ChildRVSub ];

/// 病区
Property TrackWardDR As DHCNMG.DB.MgWard [ SqlColumnNumber = 2, SqlFieldName = Track_WardDR ];

/// 存在问题
Property TrackProblem As %String(MAXLEN = 1000) [ SqlColumnNumber = 3, SqlFieldName = Track_Problem ];

/// 责任人
Property DutyPerson As list Of %String [ SqlColumnNumber = 4, SqlFieldName = Duty_Person ];

/// 加减分
Property TrackScore As %String [ SqlColumnNumber = 5, SqlFieldName = Track_Score ];

/// 备注
Property TrackRemark As %String [ SqlColumnNumber = 6, SqlFieldName = Track_Remark ];

Index Ward On TrackWardDR;

Storage Default
{
<Data name="MgNHTrackReviewSubDefaultData">
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
<DataLocation>^DHCNMG.Arg.MgNHTrackReviewSubD</DataLocation>
<DefaultData>MgNHTrackReviewSubDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ChildRVSub")</IdLocation>
<IndexLocation>^DHCNMG.Arg.MgNHTrackReviewSubI</IndexLocation>
<StreamLocation>^DHCNMG.Arg.MgNHTrackReviewSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
