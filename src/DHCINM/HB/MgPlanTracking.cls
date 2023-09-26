/// Creater:wangpf
/// Descriptions:计划、重点追踪
/// Date:2020-07-07
Class DHCINM.HB.MgPlanTracking Extends %Persistent
{

/// 追踪来源 月计划:DHCINM.HB.MgPlan 周重点:DHCINM.HB.MgPlanKey
Property TrackingSource As %String [ SqlColumnNumber = 2, SqlFieldName = Tracking_Source ];

/// 追踪类型 M:月计划 W:周重点
Property TrackingType As %String(DISPLAYLIST = ",月计划,周重点", MAXLEN = 1, TRUNCATE = 1, VALUELIST = ",M,W") [ SqlColumnNumber = 3, SqlFieldName = Tracking_Type ];

/// 追踪原因
Property TrackingReason As %String(MAXLEN = 500) [ SqlColumnNumber = 4, SqlFieldName = Tracking_Reason ];

/// 状态 N:未完成 Y:已完成
Property TrackingStatus As %String(DISPLAYLIST = ",未完成,已完成", MAXLEN = 1, TRUNCATE = 1, VALUELIST = ",N,Y") [ SqlColumnNumber = 5, SqlFieldName = Tracking_Status ];

/// 创建人
Property Creator As %String [ SqlColumnNumber = 6, SqlFieldName = Creator ];

/// 创建日期
Property CreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 7, SqlFieldName = Create_Date ];

/// 创建时间
Property CreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 8, SqlFieldName = Create_Time ];

Index Source On (TrackingType, TrackingSource);

Storage Default
{
<Data name="MgPlanTrackingDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TrackingSource</Value>
</Value>
<Value name="3">
<Value>TrackingType</Value>
</Value>
<Value name="4">
<Value>TrackingReason</Value>
</Value>
<Value name="5">
<Value>TrackingStatus</Value>
</Value>
<Value name="6">
<Value>Creator</Value>
</Value>
<Value name="7">
<Value>CreateDate</Value>
</Value>
<Value name="8">
<Value>CreateTime</Value>
</Value>
</Data>
<DataLocation>^DHCINM.HB.MgPlanTrackingD</DataLocation>
<DefaultData>MgPlanTrackingDefaultData</DefaultData>
<IdLocation>^DHCINM.HB.MgPlanTrackingD</IdLocation>
<IndexLocation>^DHCINM.HB.MgPlanTrackingI</IndexLocation>
<StreamLocation>^DHCINM.HB.MgPlanTrackingS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
