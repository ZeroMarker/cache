/// creator: xbl
/// createdate: 20180123
/// description: 护士长夜查房追踪记录表
Class DHCNMG.Arg.MgNurHeadTrack Extends %Persistent
{

Relationship PatChildSub As DHCNMG.Arg.MgNHTrackPat [ Cardinality = children, Inverse = Parref ];

Relationship SubParref As DHCNMG.Arg.MgNHTrackSub [ Cardinality = children, Inverse = Parref ];

/// 记录日期
Property TrackDate As %Date [ SqlColumnNumber = 2, SqlFieldName = Track_Date ];

/// 状态
Property TrackStatus As %String [ InitialExpression = "N", SqlColumnNumber = 3, SqlFieldName = Track_Status ];

/// 查房人
Property TrackUser As list Of %String [ SqlColumnNumber = 4, SqlFieldName = Track_User ];

/// 创建者
Property TrackCrtUser As DHCNMG.HR.MgPersons [ SqlColumnNumber = 5, SqlFieldName = Track_CrtUser ];

/// 创建日期
Property TrackCrtDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 6, SqlFieldName = Track_CrtDate ];

/// 创建时间
Property TrackCrtTime As %Time [ InitialExpression = {$P($h,",",2)}, SqlColumnNumber = 7, SqlFieldName = Track_CrtTime ];

/// 状态操作者
Property StatusUser As DHCNMG.HR.MgPersons [ SqlColumnNumber = 8, SqlFieldName = Status_User ];

/// 状态改变说明
Property StatusRemark As %String(MAXLEN = 1000) [ SqlColumnNumber = 9, SqlFieldName = Status_Remark ];

Index Date On TrackDate;

Storage Default
{
<Data name="MgNurHeadTrackDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TrackDate</Value>
</Value>
<Value name="3">
<Value>TrackStatus</Value>
</Value>
<Value name="4">
<Value>TrackUser</Value>
</Value>
<Value name="5">
<Value>TrackCrtUser</Value>
</Value>
<Value name="6">
<Value>TrackCrtDate</Value>
</Value>
<Value name="7">
<Value>TrackCrtTime</Value>
</Value>
<Value name="8">
<Value>StatusUser</Value>
</Value>
<Value name="9">
<Value>StatusRemark</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Arg.MgNurHeadTrackD</DataLocation>
<DefaultData>MgNurHeadTrackDefaultData</DefaultData>
<IdLocation>^DHCNMG.Arg.MgNurHeadTrackD</IdLocation>
<IndexLocation>^DHCNMG.Arg.MgNurHeadTrackI</IndexLocation>
<StreamLocation>^DHCNMG.Arg.MgNurHeadTrackS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
