/// Creator:
/// Descriptions:综合参数
/// Date:
Class CT.DHCINM.Set.MgArgParamSet Extends %Persistent
{

/// 排班周期
Property ArgPeriod As %String [ SqlColumnNumber = 2, SqlFieldName = Arg_Periond ];

/// 统计单位
Property ArgCountUnit As %String [ SqlColumnNumber = 3, SqlFieldName = Arg_CountUnit ];

/// 跨天统计
Property ArgCrossDay As %String [ SqlColumnNumber = 4, SqlFieldName = Arg_CrossDay ];

/// 夏令夜班开始时间
Property NightStTime1 As %Time [ SqlColumnNumber = 5, SqlFieldName = Night_StTime1 ];

/// 夏令夜班结束时间
Property NightEndTime1 As %Time [ SqlColumnNumber = 6, SqlFieldName = Night_EndTime1 ];

/// 夏令白班时长
Property DayHour1 As %Float [ SqlColumnNumber = 7, SqlFieldName = Day_Hour1 ];

/// 夏令上午时长
Property AMHour1 As %Float [ SqlColumnNumber = 8, SqlFieldName = AM_Hour1 ];

/// 夏令下午时长
Property PMHour1 As %Float [ SqlColumnNumber = 9, SqlFieldName = PM_Hour1 ];

/// 冬令夜班开始时间
Property NightStTime2 As %Time [ SqlColumnNumber = 10, SqlFieldName = Night_StTime2 ];

/// 冬令夜班结束时间
Property NightEndTime2 As %Time [ SqlColumnNumber = 11, SqlFieldName = Night_EndTime2 ];

/// 冬令白班时长
Property DayHour2 As %Float [ SqlColumnNumber = 12, SqlFieldName = Day_Hour2 ];

/// 冬令上午时长
Property AMHour2 As %Float [ SqlColumnNumber = 13, SqlFieldName = AM_Hour2 ];

/// 冬令下午时长
Property PMHour2 As %Float [ SqlColumnNumber = 14, SqlFieldName = PM_Hour2 ];

/// 排班修改时限
Property ArgUpdateDay As %Integer [ SqlColumnNumber = 15, SqlFieldName = Arg_UpdateDay ];

/// 全院床护比参数
Property BedBR As %String [ SqlColumnNumber = 16, SqlFieldName = Bed_BR ];

/// 标准时长
Property ArgStandardTime As %String [ SqlColumnNumber = 17, SqlFieldName = Arg_StandardTime ];

/// 时段修改标识
Property ArgTimeSlot As %String [ SqlColumnNumber = 18, SqlFieldName = Arg_TimeSlot ];

/// 默认列数
Property InsertColumn As %String [ SqlColumnNumber = 19, SqlFieldName = Insert_Column ];

/// 默认轮转开始日期
Property RotStDate As %Date [ SqlColumnNumber = 20, SqlFieldName = Rot_StDate ];

/// 默认轮转周期
Property RotCycle As %String [ SqlColumnNumber = 21, SqlFieldName = Rot_Cycle ];

/// 护管接口
Property NurMgInter As %String [ Required, SqlColumnNumber = 22, SqlFieldName = NurMgInter ];

/// 不良事件
Property AdvInter As %String [ Required, SqlColumnNumber = 23, SqlFieldName = AdvInter ];

/// 敏感指标是否嵌入：Y:是，N:否
Property SenFlag As %String [ SqlColumnNumber = 24, SqlFieldName = SenFlag ];

/// 是否为高级版：Y/"":是，N:否
Property IsAdvanced As %String [ SqlColumnNumber = 25, SqlFieldName = IsAdvanced ];

/// 敏感指标院感接口：D/"":东华，O:第三方
Property InfInter As %String [ SqlColumnNumber = 26, SqlFieldName = InfInter ];

/// 工作台:通知超期时间限制
Property NoticeDay As %String [ SqlColumnNumber = 27, SqlFieldName = NoticeDay ];

/// 工作台:通知显示时间限制
Property NoticeShowDay As %String [ SqlColumnNumber = 28, SqlFieldName = NoticeShowDay ];

/// 第三方护管Server
Property NurMgOtherSever As %String [ SqlColumnNumber = 29, SqlFieldName = NurMgOtherSever ];

/// 第三方护管Port
Property NurMgOtherPort As %String [ SqlColumnNumber = 30, SqlFieldName = NurMgOtherPort ];

/// 第三方护管Url
Property NurMgOtherUrl As %String [ SqlColumnNumber = 31, SqlFieldName = NurMgOtherUrl ];

/// 登记号位数
Property RegNoLength As %String [ SqlColumnNumber = 32, SqlFieldName = RegNoLength ];

/// 是否显示工作台""/Y:是，N:否
Property PlatFlag As %String [ SqlColumnNumber = 33, SqlFieldName = PlatFlag ];

/// 工作台通讯录是否检索全院，N:所辖病区，Y/""：全院
Property MailFlag As %String [ SqlColumnNumber = 34, SqlFieldName = MailFlag ];

/// 排班人员类型
Property ArgPerType As %String [ SqlColumnNumber = 35, SqlFieldName = ArgPerType ];

/// 文件预览方式
Property FilePreviewType As %String [ InitialExpression = "1", SqlColumnNumber = 36, SqlFieldName = FilePreviewType ];

/// 组长符号
Property ArgGroupIcon As %String [ SqlColumnNumber = 37, SqlFieldName = ArgGroupIcon ];

/// 实习生符号
Property ArgInternIcon As %String [ SqlColumnNumber = 38, SqlFieldName = ArgInternIcon ];

/// 进修生符号
Property ArgComeIcon As %String [ SqlColumnNumber = 39, SqlFieldName = ArgComeIcon ];

/// 符号优先级
Property ArgIconSort As list Of %String [ SqlColumnNumber = 40, SqlFieldName = ArgIconSort ];

/// 是否推送至HR
Property IsPostToHR As %String [ SqlColumnNumber = 41, SqlFieldName = IsPostToHR ];

/// HRServer
Property HRSever As %String [ SqlColumnNumber = 42, SqlFieldName = HRSever ];

/// HRPort
Property HRPort As %String [ SqlColumnNumber = 43, SqlFieldName = HRPort ];

/// HRUrl
Property HRUrl As %String [ SqlColumnNumber = 44, SqlFieldName = HRUrl ];

Storage Default
{
<Data name="MgArgParamSetDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ArgPeriod</Value>
</Value>
<Value name="3">
<Value>ArgCountUnit</Value>
</Value>
<Value name="4">
<Value>ArgCrossDay</Value>
</Value>
<Value name="5">
<Value>NightStTime1</Value>
</Value>
<Value name="6">
<Value>NightEndTime1</Value>
</Value>
<Value name="7">
<Value>DayHour1</Value>
</Value>
<Value name="8">
<Value>AMHour1</Value>
</Value>
<Value name="9">
<Value>PMHour1</Value>
</Value>
<Value name="10">
<Value>NightStTime2</Value>
</Value>
<Value name="11">
<Value>NightEndTime2</Value>
</Value>
<Value name="12">
<Value>DayHour2</Value>
</Value>
<Value name="13">
<Value>AMHour2</Value>
</Value>
<Value name="14">
<Value>PMHour2</Value>
</Value>
<Value name="15">
<Value>ArgUpdateDay</Value>
</Value>
<Value name="16">
<Value>BedBR</Value>
</Value>
<Value name="17">
<Value>ArgStandardTime</Value>
</Value>
<Value name="18">
<Value>ArgTimeSlot</Value>
</Value>
<Value name="19">
<Value>InsertColumn</Value>
</Value>
<Value name="20">
<Value>RotStDate</Value>
</Value>
<Value name="21">
<Value>RotCycle</Value>
</Value>
<Value name="22">
<Value>NurMgInter</Value>
</Value>
<Value name="23">
<Value>AdvInter</Value>
</Value>
<Value name="24">
<Value>SenFlag</Value>
</Value>
<Value name="25">
<Value>IsAdvanced</Value>
</Value>
<Value name="26">
<Value>InfInter</Value>
</Value>
<Value name="27">
<Value>NoticeDay</Value>
</Value>
<Value name="28">
<Value>NoticeShowDay</Value>
</Value>
<Value name="29">
<Value>NurMgOtherSever</Value>
</Value>
<Value name="30">
<Value>NurMgOtherPort</Value>
</Value>
<Value name="31">
<Value>NurMgOtherUrl</Value>
</Value>
<Value name="32">
<Value>RegNoLength</Value>
</Value>
<Value name="33">
<Value>PlatFlag</Value>
</Value>
<Value name="34">
<Value>MailFlag</Value>
</Value>
<Value name="35">
<Value>ArgPerType</Value>
</Value>
<Value name="36">
<Value>FilePreviewType</Value>
</Value>
<Value name="37">
<Value>ArgGroupIcon</Value>
</Value>
<Value name="38">
<Value>ArgInternIcon</Value>
</Value>
<Value name="39">
<Value>ArgComeIcon</Value>
</Value>
<Value name="40">
<Value>ArgIconSort</Value>
</Value>
<Value name="41">
<Value>IsPostToHR</Value>
</Value>
<Value name="42">
<Value>HRSever</Value>
</Value>
<Value name="43">
<Value>HRPort</Value>
</Value>
<Value name="44">
<Value>HRUrl</Value>
</Value>
</Data>
<DataLocation>^CT.DHCINM.Set.MgArgParamSetD</DataLocation>
<DefaultData>MgArgParamSetDefaultData</DefaultData>
<IdLocation>^CT.DHCINM.Set.MgArgParamSetD</IdLocation>
<IndexLocation>^CT.DHCINM.Set.MgArgParamSetI</IndexLocation>
<StreamLocation>^CT.DHCINM.Set.MgArgParamSetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
