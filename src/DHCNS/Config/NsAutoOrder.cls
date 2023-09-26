/// creator:lulin
/// createdate:2020-06-05
/// description:医嘱表
Class DHCNS.Config.NsAutoOrder Extends %Persistent
{

Relationship ChildSub As DHCNS.Config.NsAutoOrderExec [ Cardinality = children, Inverse = Parref ];

/// 医嘱Id
Property OrderItemId As %String [ SqlColumnNumber = 2, SqlFieldName = OrderItemId ];

/// 开始日期
Property StartDate As %Date [ SqlColumnNumber = 3, SqlFieldName = StartDate ];

/// 开始时间
Property StartTime As %Time [ SqlColumnNumber = 4, SqlFieldName = StartTime ];

/// 停止日期
Property EndDate As %Date [ SqlColumnNumber = 5, SqlFieldName = EndDate ];

/// 停止时间
Property EndTime As %Time [ SqlColumnNumber = 6, SqlFieldName = EndTime ];

/// 病区（取开医嘱患者所在ctloc病区id）
Property OrderWard As %Integer [ SqlColumnNumber = 7, SqlFieldName = OrderWard ];

/// 患者EpisodeID
Property EpisodeID As %String [ SqlColumnNumber = 8, SqlFieldName = EpisodID ];

/// 患者姓名
Property PatName As %String [ SqlColumnNumber = 9, SqlFieldName = PatName ];

/// 医嘱子项Id
Property ArcimID As %String [ SqlColumnNumber = 10, SqlFieldName = ArcimID ];

/// 医嘱名称
Property ArcimDesc As %String [ SqlColumnNumber = 11, SqlFieldName = ArcimDesc ];

/// 下医嘱人姓名
Property OeordDoctorName As %String [ SqlColumnNumber = 12, SqlFieldName = OeordDoctorName ];

/// 下医嘱人id---CTCareProv
Property OeordDoctorId As %String [ SqlColumnNumber = 13, SqlFieldName = OeordDoctorId ];

/// 下医嘱人工号
Property OeordDoctorNo As %String [ SqlColumnNumber = 14, SqlFieldName = OeordDoctorNo ];

/// 停医嘱人姓名
Property XCTCPName As %String [ SqlColumnNumber = 15, SqlFieldName = XCTCPName ];

/// 停医嘱人id---CTCareProv
Property XCTCPId As %String [ SqlColumnNumber = 16, SqlFieldName = XCTCPId ];

/// 停医嘱人工号
Property XCTCPNo As %String [ SqlColumnNumber = 17, SqlFieldName = XCTCPNo ];

/// 医嘱状态code
Property OEORIItemStatCode As %String [ SqlColumnNumber = 18, SqlFieldName = OEORIItemStatCode ];

/// 是否停止 N:否,"Y":停止
Property EndFlag As %String [ SqlColumnNumber = 19, SqlFieldName = EndFlag ];

/// 更新日期
Property UpdateDate As %Date [ SqlColumnNumber = 20, SqlFieldName = UpdateDate ];

/// 患者出院日期
Property PatDisDate As %Date [ SqlColumnNumber = 21, SqlFieldName = PatDisDate ];

/// 停止医嘱日期，次日0点所在病区
Property XOrderCTLocID As %String [ SqlColumnNumber = 22, SqlFieldName = XOrderCTLocID ];

/// 母亲EpisodeID
Property MotherEpisodeID As %String [ SqlColumnNumber = 23, SqlFieldName = MotherEpisodeID ];

/// 剂量
Property OrderDoseQty As %String [ SqlColumnNumber = 24, SqlFieldName = OrderDoseQty ];

/// 剂量单位
Property OrderUnit As %String [ SqlColumnNumber = 25, SqlFieldName = OrderUnit ];

/// 剂用法
Property OrderInstrDR As %String [ SqlColumnNumber = 26, SqlFieldName = OrderInstrDR ];

/// 开始日期
Property StDate As %Date [ SqlColumnNumber = 27, SqlFieldName = StDate ];

/// 开始时间
Property StTime As %Time [ SqlColumnNumber = 28, SqlFieldName = StTime ];

/// 停止日期
Property XDate As %Date [ SqlColumnNumber = 29, SqlFieldName = XDate ];

/// 停止时间
Property XTime As %Time [ SqlColumnNumber = 30, SqlFieldName = XTime ];

/// 优先级
Property PriorDesc As %String [ SqlColumnNumber = 31, SqlFieldName = PriorDesc ];

Index Index On OrderItemId;

Index PatNum On (StartDate, ArcimID, EpisodeID);

Index ARCIM On (OrderWard, ArcimID, StartDate, EpisodeID);

Index End On EndFlag;

Index ARCIMDate On (OrderWard, ArcimID, EndDate, StartDate, EpisodeID);

Index PatEnd On (EpisodeID, ArcimID, EndDate);

Index Indexst On (OrderItemId, StartDate);

Storage Default
{
<Data name="NsAutoOrderDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OrderItemId</Value>
</Value>
<Value name="3">
<Value>StartDate</Value>
</Value>
<Value name="4">
<Value>StartTime</Value>
</Value>
<Value name="5">
<Value>EndDate</Value>
</Value>
<Value name="6">
<Value>EndTime</Value>
</Value>
<Value name="7">
<Value>OrderWard</Value>
</Value>
<Value name="8">
<Value>EpisodeID</Value>
</Value>
<Value name="9">
<Value>PatName</Value>
</Value>
<Value name="10">
<Value>ArcimID</Value>
</Value>
<Value name="11">
<Value>ArcimDesc</Value>
</Value>
<Value name="12">
<Value>OeordDoctorName</Value>
</Value>
<Value name="13">
<Value>OeordDoctorId</Value>
</Value>
<Value name="14">
<Value>OeordDoctorNo</Value>
</Value>
<Value name="15">
<Value>XCTCPName</Value>
</Value>
<Value name="16">
<Value>XCTCPId</Value>
</Value>
<Value name="17">
<Value>XCTCPNo</Value>
</Value>
<Value name="18">
<Value>OEORIItemStatCode</Value>
</Value>
<Value name="19">
<Value>EndFlag</Value>
</Value>
<Value name="20">
<Value>UpdateDate</Value>
</Value>
<Value name="21">
<Value>PatDisDate</Value>
</Value>
<Value name="22">
<Value>XOrderCTLocID</Value>
</Value>
<Value name="23">
<Value>MotherEpisodeID</Value>
</Value>
<Value name="24">
<Value>OrderDoseQty</Value>
</Value>
<Value name="25">
<Value>OrderUnit</Value>
</Value>
<Value name="26">
<Value>OrderInstrDR</Value>
</Value>
<Value name="27">
<Value>StDate</Value>
</Value>
<Value name="28">
<Value>StTime</Value>
</Value>
<Value name="29">
<Value>XDate</Value>
</Value>
<Value name="30">
<Value>XTime</Value>
</Value>
<Value name="31">
<Value>PriorDesc</Value>
</Value>
</Data>
<DataLocation>^DHCNS.Config.NsAutoOrderD</DataLocation>
<DefaultData>NsAutoOrderDefaultData</DefaultData>
<IdLocation>^DHCNS.Config.NsAutoOrderD</IdLocation>
<IndexLocation>^DHCNS.Config.NsAutoOrderI</IndexLocation>
<StreamLocation>^DHCNS.Config.NsAutoOrderS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
