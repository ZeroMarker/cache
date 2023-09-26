/// creator:lulin
/// createdate:2021-04-15
/// description:系统自动获取院感数据表
Class DHCNS.Config.NsAutoInf Extends %Persistent
{

/// 感染类型：PICC:PICC，CVC：CVC, UC:导尿管，VAP:呼吸机
Property InfType As %String [ SqlColumnNumber = 2, SqlFieldName = InfType ];

/// 感染日期：
Property InfDate As %Date [ SqlColumnNumber = 3, SqlFieldName = InfDate ];

/// 上报日期
Property RepDate As %Date [ SqlColumnNumber = 4, SqlFieldName = RepDate ];

/// 上报时间
Property RepTime As %Time [ SqlColumnNumber = 5, SqlFieldName = RepTime ];

/// 唯一编码
Property ReportID As %String [ SqlColumnNumber = 6, SqlFieldName = ReportID ];

/// 1保存,2提交,3审核,4删除,5退回,6取消审核；3审核是最终有效状态
Property RepStatus As %String [ SqlColumnNumber = 7, SqlFieldName = RepStatus ];

/// 发生病人就诊号
Property EpisodeID As %String [ SqlColumnNumber = 8, SqlFieldName = EpisodeID ];

/// 发生病人病案号
Property PaRecord As %String [ SqlColumnNumber = 9, SqlFieldName = PaRecord ];

/// 发生病人姓名
Property PaName As %String [ SqlColumnNumber = 10, SqlFieldName = PaName ];

/// 发生病人性别
Property PaSex As %String [ SqlColumnNumber = 11, SqlFieldName = PaSex ];

/// 病区-CTLOCID
Property RepWard As %String [ SqlColumnNumber = 12, SqlFieldName = RepWard ];

/// 上报人姓名
Property RepUserName As %String [ SqlColumnNumber = 13, SqlFieldName = RepUserName ];

/// 上报人工号
Property RepUserCode As %String [ SqlColumnNumber = 14, SqlFieldName = RepUserCode ];

/// 归档日期
Property InfXDate As %Date [ SqlColumnNumber = 15, SqlFieldName = InfXDate ];

/// 感染诊断类型
Property InfEffect As %String [ SqlColumnNumber = 16, SqlFieldName = InfEffect ];

/// 更新日期
Property UpdateDate As %Date [ SqlColumnNumber = 17, SqlFieldName = UpdateDate ];

/// 科室名称
Property CtLocDesc As %String [ SqlColumnNumber = 18, SqlFieldName = CtLocDesc ];

/// 入院日期
Property AdmDate As %Date [ SqlColumnNumber = 19, SqlFieldName = AdmDate ];

/// 性别
Property SexDesc As %String [ SqlColumnNumber = 20, SqlFieldName = SexDesc ];

/// 出生日期
Property PerBirth As %Date [ SqlColumnNumber = 21, SqlFieldName = PerBirth ];

/// 留置导管主要原因CVC/PICC/UC
Property InfReason As %String [ SqlColumnNumber = 22, SqlFieldName = InfReason ];

/// 置管位置CVC/PICC
Property InfPosition As %String [ SqlColumnNumber = 23, SqlFieldName = InfPosition ];

/// 导管类型CVC/PICC/UC/VAP
Property InfIntubationType As %String [ SqlColumnNumber = 24, SqlFieldName = InfIntubationType ];

/// 是否为抗菌导管CVC/PICC
Property AntibiosisFlag As %String [ SqlColumnNumber = 25, SqlFieldName = AntibiosisFlag ];

/// 发生时留置时长(天)CVC/PICC/UC/VAP
Property LienTime As %String [ SqlColumnNumber = 26, SqlFieldName = LienTime ];

/// PICC置管方式PICC
Property IntubationMode As %String [ SqlColumnNumber = 27, SqlFieldName = IntubationMode ];

/// 导尿管型号UC
Property IntubationNum As %String [ SqlColumnNumber = 28, SqlFieldName = IntubationNum ];

/// 导管材质UC
Property IntubationQuality As %String [ SqlColumnNumber = 29, SqlFieldName = IntubationQuality ];

/// 是否使用抗返流集尿装置UC
Property DeviceFlag As %String [ SqlColumnNumber = 30, SqlFieldName = DeviceFlag ];

/// 发生CAUTI前是否有膀胱冲洗UC
Property RinsingFlag As %String [ SqlColumnNumber = 31, SqlFieldName = RinsingFlag ];

/// 人工气道类型VAP
Property ETTType As %String [ SqlColumnNumber = 32, SqlFieldName = ETTType ];

/// 湿化装置VAP
Property Humidification As %String [ SqlColumnNumber = 33, SqlFieldName = Humidification ];

/// 吸痰方式VAP
Property Endotracheal As %String [ SqlColumnNumber = 34, SqlFieldName = Endotracheal ];

/// 口腔护理方式VAP
Property OralCareType As %String [ SqlColumnNumber = 35, SqlFieldName = OralCareType ];

/// 每天口腔护理次数VAP
Property OralCareNum As %String [ SqlColumnNumber = 36, SqlFieldName = OralCareNum ];

/// 口腔护理液选择VAP
Property OralCareLiquid As %String [ SqlColumnNumber = 37, SqlFieldName = OralCareLiquid ];

/// 经人工气道通气的同时，是否有经鼻胃管肠内营养VAP
Property NutritionFlag As %String [ SqlColumnNumber = 38, SqlFieldName = NutritionFlag ];

Index Index On ReportID;

Index DateType On (InfDate, InfType);

Index TypeDate On (InfType, InfDate);

Storage Default
{
<Data name="NsAutoInfDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>InfType</Value>
</Value>
<Value name="3">
<Value>InfDate</Value>
</Value>
<Value name="4">
<Value>RepDate</Value>
</Value>
<Value name="5">
<Value>RepTime</Value>
</Value>
<Value name="6">
<Value>ReportID</Value>
</Value>
<Value name="7">
<Value>RepStatus</Value>
</Value>
<Value name="8">
<Value>EpisodeID</Value>
</Value>
<Value name="9">
<Value>PaRecord</Value>
</Value>
<Value name="10">
<Value>PaName</Value>
</Value>
<Value name="11">
<Value>PaSex</Value>
</Value>
<Value name="12">
<Value>RepWard</Value>
</Value>
<Value name="13">
<Value>RepUserName</Value>
</Value>
<Value name="14">
<Value>RepUserCode</Value>
</Value>
<Value name="15">
<Value>InfXDate</Value>
</Value>
<Value name="16">
<Value>InfEffect</Value>
</Value>
<Value name="17">
<Value>UpdateDate</Value>
</Value>
<Value name="18">
<Value>CtLocDesc</Value>
</Value>
<Value name="19">
<Value>AdmDate</Value>
</Value>
<Value name="20">
<Value>SexDesc</Value>
</Value>
<Value name="21">
<Value>PerBirth</Value>
</Value>
<Value name="22">
<Value>InfReason</Value>
</Value>
<Value name="23">
<Value>InfPosition</Value>
</Value>
<Value name="24">
<Value>InfIntubationType</Value>
</Value>
<Value name="25">
<Value>AntibiosisFlag</Value>
</Value>
<Value name="26">
<Value>LienTime</Value>
</Value>
<Value name="27">
<Value>IntubationMode</Value>
</Value>
<Value name="28">
<Value>IntubationNum</Value>
</Value>
<Value name="29">
<Value>IntubationQuality</Value>
</Value>
<Value name="30">
<Value>DeviceFlag</Value>
</Value>
<Value name="31">
<Value>RinsingFlag</Value>
</Value>
<Value name="32">
<Value>ETTType</Value>
</Value>
<Value name="33">
<Value>Humidification</Value>
</Value>
<Value name="34">
<Value>Endotracheal</Value>
</Value>
<Value name="35">
<Value>OralCareType</Value>
</Value>
<Value name="36">
<Value>OralCareNum</Value>
</Value>
<Value name="37">
<Value>OralCareLiquid</Value>
</Value>
<Value name="38">
<Value>NutritionFlag</Value>
</Value>
</Data>
<DataLocation>^DHCNS.Config.NsAutoInfD</DataLocation>
<DefaultData>NsAutoInfDefaultData</DefaultData>
<IdLocation>^DHCNS.Config.NsAutoInfD</IdLocation>
<IndexLocation>^DHCNS.Config.NsAutoInfI</IndexLocation>
<StreamLocation>^DHCNS.Config.NsAutoInfS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
