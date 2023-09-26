/// 名称 : DHCMed.DC.HDIS.Hemodialysis
/// 说明 : 血液透析病人登记表
Class DHCMed.DC.HDIS.Hemodialysis Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 记录ID
Property ResultID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 就诊号/住院号
Property EpisodeID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 病人ID
Property PatientID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 身份证号，唯一标示
Property ID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 姓名
Property PatName As %String(MAXLEN = 100, TRUNCATE = 1);

/// 性别
Property Sex As %String(MAXLEN = 100, TRUNCATE = 1);

/// 出生日期
Property BirthDay As %String(MAXLEN = 100, TRUNCATE = 1);

/// 联系电话
Property Telephone As %String(MAXLEN = 100, TRUNCATE = 1);

/// 家庭住址
Property Address As %String(MAXLEN = 100, TRUNCATE = 1);

/// 诊断
Property Diagnos As %String(MAXLEN = 100, TRUNCATE = 1);

/// 首次透析时间
Property FirthDate As %String(MAXLEN = 100, TRUNCATE = 1);

/// 传染病病原学指标检测
Property EpdTest As list Of DHCMed.DC.HDIS.EpidemicTest;

/// 透析号
Property HDNo As %String(MAXLEN = 100, TRUNCATE = 1);

/// 登记日期
Property RegDate As %Date;

/// 登记时间
Property RegTime As %Time;

/// 登记人
Property RegUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否有效（1有效、0无效）
Property IsActive As %Boolean;

/// 更新日期
Property UpdateDate As %Date;

/// 更新时间
Property UpdateTime As %Time;

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ResultID</Value>
</Value>
<Value name="3">
<Value>EpisodeID</Value>
</Value>
<Value name="4">
<Value>PatientID</Value>
</Value>
<Value name="5">
<Value>ID</Value>
</Value>
<Value name="6">
<Value>PatName</Value>
</Value>
<Value name="7">
<Value>Sex</Value>
</Value>
<Value name="8">
<Value>BirthDay</Value>
</Value>
<Value name="9">
<Value>Telephone</Value>
</Value>
<Value name="10">
<Value>Address</Value>
</Value>
<Value name="11">
<Value>Diagnos</Value>
</Value>
<Value name="12">
<Value>FirthDate</Value>
</Value>
<Value name="13">
<Value>EpdTest</Value>
</Value>
<Value name="14">
<Value>HDNo</Value>
</Value>
<Value name="15">
<Value>RegDate</Value>
</Value>
<Value name="16">
<Value>RegTime</Value>
</Value>
<Value name="17">
<Value>RegUser</Value>
</Value>
<Value name="18">
<Value>IsActive</Value>
</Value>
<Value name="19">
<Value>UpdateDate</Value>
</Value>
<Value name="20">
<Value>UpdateTime</Value>
</Value>
</Data>
<DataLocation>^DHCMed.DC.HDIS.HemodialysisD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.DC.HDIS.HemodialysisD</IdLocation>
<IndexLocation>^DHCMed.DC.HDIS.HemodialysisI</IndexLocation>
<StreamLocation>^DHCMed.DC.HDIS.HemodialysisS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
