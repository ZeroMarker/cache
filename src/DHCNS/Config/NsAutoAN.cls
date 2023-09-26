/// creator:lulin
/// createdate:2021-07-22
/// description:手术表
Class DHCNS.Config.NsAutoAN Extends %Persistent
{

/// 手术id【唯一值】
Property DataId As %String [ SqlColumnNumber = 2, SqlFieldName = DataId ];

/// 手术病人所在病区
Property CTLocID As %String [ SqlColumnNumber = 3, SqlFieldName = CTLocID ];

/// 手术患者就诊号
Property EpisodeID As %String [ SqlColumnNumber = 4, SqlFieldName = EpisodeID ];

/// 手术患者姓名
Property PatName As %String [ SqlColumnNumber = 5, SqlFieldName = PatName ];

/// 手术开始日期
Property OPAStartDate As %Date [ SqlColumnNumber = 6, SqlFieldName = OPAStartDate ];

/// 手术开始时间
Property OPAStartTime As %Time [ SqlColumnNumber = 7, SqlFieldName = OPAStartTime ];

/// 手术结束日期
Property OPAEndDate As %Date [ SqlColumnNumber = 8, SqlFieldName = OPAEndDate ];

/// 手术开始时间
Property OPAEndTime As %Time [ SqlColumnNumber = 9, SqlFieldName = OPAEndTime ];

/// 手术字典ID
Property ANAOPTypeDR As %String [ SqlColumnNumber = 10, SqlFieldName = ANAOPTypeDR ];

/// 手术名称
Property OPERDesc As %String [ SqlColumnNumber = 11, SqlFieldName = OPERDesc ];

/// 手术代码
Property OPERCode As %String [ SqlColumnNumber = 12, SqlFieldName = OPERCode ];

/// 手术状态【A-申请,D-拒绝,R-安排,I-入室,O-术中, L-离开,F-完成,N-非预约】
Property OPAStatus As %String [ SqlColumnNumber = 13, SqlFieldName = OPAStatus ];

/// 手术申请日期
Property OPAAppDate As %Date [ SqlColumnNumber = 14, SqlFieldName = OPAAppDate ];

/// 手术申请时间
Property OPAAppTime As %Time [ SqlColumnNumber = 15, SqlFieldName = OPAAppTime ];

/// 排班ID
Property ArrangeID As %Time [ SqlColumnNumber = 16, SqlFieldName = ArrangeID ];

/// 更新日期
Property UpdateDate As %Date [ SqlColumnNumber = 17, SqlFieldName = UpdateDate ];

Index status On OPAStatus;

Index WardDateOp On (CTLocID, OPAStartDate, ANAOPTypeDR);

Index Index On DataId;

Storage Default
{
<Data name="NsAutoANDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DataId</Value>
</Value>
<Value name="3">
<Value>CTLocID</Value>
</Value>
<Value name="4">
<Value>EpisodeID</Value>
</Value>
<Value name="5">
<Value>PatName</Value>
</Value>
<Value name="6">
<Value>OPAStartDate</Value>
</Value>
<Value name="7">
<Value>OPAStartTime</Value>
</Value>
<Value name="8">
<Value>OPAEndDate</Value>
</Value>
<Value name="9">
<Value>OPAEndTime</Value>
</Value>
<Value name="10">
<Value>ANAOPTypeDR</Value>
</Value>
<Value name="11">
<Value>OPERDesc</Value>
</Value>
<Value name="12">
<Value>OPERCode</Value>
</Value>
<Value name="13">
<Value>OPAStatus</Value>
</Value>
<Value name="14">
<Value>OPAAppDate</Value>
</Value>
<Value name="15">
<Value>OPAAppTime</Value>
</Value>
<Value name="16">
<Value>ArrangeID</Value>
</Value>
<Value name="17">
<Value>UpdateDate</Value>
</Value>
</Data>
<DataLocation>^DHCNS.Config.NsAutoAND</DataLocation>
<DefaultData>NsAutoANDefaultData</DefaultData>
<IdLocation>^DHCNS.Config.NsAutoAND</IdLocation>
<IndexLocation>^DHCNS.Config.NsAutoANI</IndexLocation>
<StreamLocation>^DHCNS.Config.NsAutoANS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
