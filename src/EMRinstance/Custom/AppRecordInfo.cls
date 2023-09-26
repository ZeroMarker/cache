/// 名称:EMRinstance.Custom.AppRecordInfo
/// 描述:存储第三方推送病史信息，目前包括主诉、现病史、既往史、查体等，数据来源可能是疑难数据平台，患者APP，医生助手等
Class EMRinstance.Custom.AppRecordInfo Extends %Persistent
{

/// Adm就诊号
Property EpisodeID As %String;

/// 记录日期
Property RecordDate As %Date;

/// 记录时间
Property RecordTime As %Time;

/// 主诉
Property MainSuit As %String(MAXLEN = 999999, TRUNCATE = 0);

/// 现病史
Property NowHisInfo As %String(MAXLEN = 999999, TRUNCATE = 0);

/// 既往史
Property PrevHisInfo As %String(MAXLEN = 999999, TRUNCATE = 0);

/// 查体
Property PhyExam As %String(MAXLEN = 999999, TRUNCATE = 0);

/// 数据来源(DoctorEMR:第三方病历数据  PatientAPP:患者App填写  ObgynCDSS:疑难病平台   DoctorAssist:医生助手) 
Property DataSources As %String(MAXLEN = 50, TRUNCATE = 0, VALUELIST = ",DoctorEMR,PatientAPP,ObgynCDSS,DoctorAssist") [ Required ];

/// 个人史(目前存储三史相关信息，暂不需要获取值)
Property PersonalHisInfo As %String(MAXLEN = 999999, TRUNCATE = 0);

/// 创建日期
Property CreateDate As %Date;

/// 创建时间
Property CreateTime As %Time;

/// 过敏史
Property Allergy As %String(MAXLEN = 999999, TRUNCATE = 0);

/// 手术史
Property Surgery As %String(MAXLEN = 999999, TRUNCATE = 0);

/// 外伤史
Property Trauma As %String(MAXLEN = 999999, TRUNCATE = 0);

/// 输血史
Property BloodHisInfo As %String(MAXLEN = 999999, TRUNCATE = 0);

/// 家族史
Property FamillyHisInfo As %String(MAXLEN = 999999, TRUNCATE = 0);

/// 月经史
Property MenstrualHisInfo As %String(MAXLEN = 999999, TRUNCATE = 0);

/// 婚育史
Property MarritalHisInfo As %String(MAXLEN = 999999, TRUNCATE = 0);

/// 辅助检查
Property AdditionalExam As %String(MAXLEN = 999999, TRUNCATE = 0);

/// 专科检查
Property SpecialityExam As %String(MAXLEN = 999999, TRUNCATE = 0);

/// 诊断
Property Diag As %String(MAXLEN = 999999, TRUNCATE = 0);

/// 处理
Property Oeord As %String(MAXLEN = 999999, TRUNCATE = 0);

Index IdxEpisodeID On EpisodeID;

Index IdxEpisodeIDProduct On (EpisodeID, DataSources);

Index IdxCreateDateTime On (CreateDate, CreateTime);

Index IdxRecordDateTime On (RecordDate, RecordTime);

Storage Default
{
<Data name="AppRecordInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>RecordDate</Value>
</Value>
<Value name="4">
<Value>RecordTime</Value>
</Value>
<Value name="5">
<Value>MainSuit</Value>
</Value>
<Value name="6">
<Value>NowHisInfo</Value>
</Value>
<Value name="7">
<Value>PrevHisInfo</Value>
</Value>
<Value name="8">
<Value>PhyExam</Value>
</Value>
<Value name="9">
<Value>DataSources</Value>
</Value>
<Value name="10">
<Value>PersonalHisInfo</Value>
</Value>
<Value name="11">
<Value>CreateDate</Value>
</Value>
<Value name="12">
<Value>CreateTime</Value>
</Value>
<Value name="13">
<Value>Allergy</Value>
</Value>
<Value name="14">
<Value>Surgery</Value>
</Value>
<Value name="15">
<Value>Trauma</Value>
</Value>
<Value name="16">
<Value>BloodHisInfo</Value>
</Value>
<Value name="17">
<Value>FamillyHisInfo</Value>
</Value>
<Value name="18">
<Value>MenstrualHisInfo</Value>
</Value>
<Value name="19">
<Value>MarritalHisInfo</Value>
</Value>
<Value name="20">
<Value>AdditionalExam</Value>
</Value>
<Value name="21">
<Value>SpecialityExam</Value>
</Value>
<Value name="22">
<Value>Diag</Value>
</Value>
<Value name="23">
<Value>Oeord</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.Custom.AppRecordInfoD</DataLocation>
<DefaultData>AppRecordInfoDefaultData</DefaultData>
<IdLocation>^DHCEMRI.Custom.AppRecordInfoD</IdLocation>
<IndexLocation>^DHCEMRI.Custom.AppRecordInfoI</IndexLocation>
<StreamLocation>^DHCEMRI.Custom.AppRecordInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
