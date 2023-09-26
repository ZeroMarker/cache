/// creator:lulin
/// createdate:2019-12-15
/// description:系统自动获取数据-护理管理
Class DHCNS.Config.NsAutoMgData Extends %Persistent
{

/// 数据时间
Property DataDate As %Date [ SqlColumnNumber = 2, SqlFieldName = DataDate ];

/// 人员
Property DataKey As %String [ SqlColumnNumber = 3, SqlFieldName = DataKey ];

/// CTLocDR,>
Property CTLocDR As %String [ SqlColumnNumber = 4, SqlFieldName = CTLocDR ];

/// NurseID
Property NurseID As %String [ SqlColumnNumber = 5, SqlFieldName = NurseID ];

/// his工号
Property HISNo As %String [ SqlColumnNumber = 6, SqlFieldName = HISNo ];

/// 性别
Property Sex As %String [ SqlColumnNumber = 7, SqlFieldName = Sex ];

/// 学历
Property AdcaDR As %String [ SqlColumnNumber = 8, SqlFieldName = AdcaDR ];

/// 职称
Property AppDutyDR As %String [ SqlColumnNumber = 9, SqlFieldName = AppDutyDR ];

/// 职务
Property HeadShipDR As %String [ SqlColumnNumber = 10, SqlFieldName = HeadShipDR ];

/// 白班工作时长
Property DayCount As %String [ SqlColumnNumber = 11, SqlFieldName = DayCount ];

/// 夜班工作时长
Property NightCount As %String [ SqlColumnNumber = 12, SqlFieldName = NightCount ];

/// 来院日期
Property ComeDate As %String [ SqlColumnNumber = 13, SqlFieldName = ComeDate ];

/// 开始工作日期
Property WorkDate As %String [ SqlColumnNumber = 14, SqlFieldName = WorkDate ];

/// CTLocDR,前一个病区
Property NurBeforWard As %String [ SqlColumnNumber = 15, SqlFieldName = NurBeforWard ];

/// 姓名
Property PersonName As %String [ SqlColumnNumber = 16, SqlFieldName = PersonName ];

/// 更新日期
Property UpdateDate As %Date [ SqlColumnNumber = 17, SqlFieldName = UpdateDate ];

/// 是否执业护士Y\N
Property IsRegister As %String [ SqlColumnNumber = 18, SqlFieldName = IsRegister ];

/// 责班白班工作时长
Property DayCountDuty As %String [ SqlColumnNumber = 19, SqlFieldName = DayCountDuty ];

/// 责班夜班工作时长
Property NightCountDuty As %String [ SqlColumnNumber = 20, SqlFieldName = NightCountDuty ];

/// 0-0工作时长
Property AllDayCount As %String [ SqlColumnNumber = 21, SqlFieldName = AllDayCount ];

/// 责0-0工作时长
Property AllDayCountDuty As %String [ SqlColumnNumber = 22, SqlFieldName = AllDayCountDuty ];

/// 本病区执业工作年限--天
Property WardWorkDay As %String [ SqlColumnNumber = 23, SqlFieldName = WardWorkDay ];

Index key On (DataDate, DataKey);

Storage Default
{
<Data name="NsAutoMgDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DataDate</Value>
</Value>
<Value name="3">
<Value>DataKey</Value>
</Value>
<Value name="4">
<Value>CTLocDR</Value>
</Value>
<Value name="5">
<Value>NurseID</Value>
</Value>
<Value name="6">
<Value>HISNo</Value>
</Value>
<Value name="7">
<Value>Sex</Value>
</Value>
<Value name="8">
<Value>AdcaDR</Value>
</Value>
<Value name="9">
<Value>AppDutyDR</Value>
</Value>
<Value name="10">
<Value>HeadShipDR</Value>
</Value>
<Value name="11">
<Value>DayCount</Value>
</Value>
<Value name="12">
<Value>NightCount</Value>
</Value>
<Value name="13">
<Value>ComeDate</Value>
</Value>
<Value name="14">
<Value>WorkDate</Value>
</Value>
<Value name="15">
<Value>NurBeforWard</Value>
</Value>
<Value name="16">
<Value>PersonName</Value>
</Value>
<Value name="17">
<Value>UpdateDate</Value>
</Value>
<Value name="18">
<Value>IsRegister</Value>
</Value>
<Value name="19">
<Value>DayCountDuty</Value>
</Value>
<Value name="20">
<Value>NightCountDuty</Value>
</Value>
<Value name="21">
<Value>AllDayCount</Value>
</Value>
<Value name="22">
<Value>AllDayCountDuty</Value>
</Value>
<Value name="23">
<Value>WardWorkDay</Value>
</Value>
</Data>
<DataLocation>^DHCNS.Config.NsAutoMgDataD</DataLocation>
<DefaultData>NsAutoMgDataDefaultData</DefaultData>
<IdLocation>^DHCNS.Config.NsAutoMgDataD</IdLocation>
<IndexLocation>^DHCNS.Config.NsAutoMgDataI</IndexLocation>
<StreamLocation>^DHCNS.Config.NsAutoMgDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
