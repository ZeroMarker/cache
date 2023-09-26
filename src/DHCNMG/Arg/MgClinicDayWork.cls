/// 
/// 
/// 临床工作量项目日报数据
Class DHCNMG.Arg.MgClinicDayWork Extends %Persistent [ Owner = {dhpm1} ]
{

/// 病区
Property ClinicWard As %String [ SqlColumnNumber = 2, SqlFieldName = Clinic_Ward ];

/// 日期
Property ClinicDate As %Date [ SqlColumnNumber = 3, SqlFieldName = Clinic_Date ];

/// 病危
Property ClinicCriticaly As %Integer [ SqlColumnNumber = 4, SqlFieldName = Clinic_Criticaly ];

/// 病重
Property ClinicSick As %Integer [ SqlColumnNumber = 5, SqlFieldName = Clinic_Sick ];

/// 一级护理
Property ClinicFirstCare As %Integer [ SqlColumnNumber = 6, SqlFieldName = Clinic_FirstCare ];

/// 二级护理
Property ClinicSecondCare As %Integer [ SqlColumnNumber = 7, SqlFieldName = Clinic_SecondCare ];

/// 手术
Property ClinicSurgery As %Integer [ SqlColumnNumber = 8, SqlFieldName = Clinic_Surgery ];

/// 科内手术
Property ClinicInSurgery As %Integer [ SqlColumnNumber = 9, SqlFieldName = Clinic_InSurgery ];

/// 压疮护理
Property ClinicPressCare As %Integer [ SqlColumnNumber = 10, SqlFieldName = Clinic_PressCare ];

/// 换药
Property ClinicDresse As %Integer [ SqlColumnNumber = 11, SqlFieldName = Clinic_Dresse ];

/// 换引流瓶（袋）
Property ClinicDrainage As %Integer [ SqlColumnNumber = 12, SqlFieldName = Clinic_Drainage ];

/// 口腔护理
Property ClinicOralCare As %Integer [ SqlColumnNumber = 13, SqlFieldName = Clinic_OralCare ];

/// 雾化吸入
Property ClinicInhalation As %Integer [ SqlColumnNumber = 14, SqlFieldName = Clinic_Inhalation ];

/// 床边洗头
Property ClinicShampoo As %Integer [ SqlColumnNumber = 15, SqlFieldName = Clinic_Shampoo ];

/// 床上浴
Property ClinicBedBath As %Integer [ SqlColumnNumber = 16, SqlFieldName = Clinic_BedBath ];

/// 剪指（趾）甲
Property ClinicCutNail As %Integer [ SqlColumnNumber = 17, SqlFieldName = Clinic_CutNail ];

/// 导尿
Property ClinicCatherize As %Integer [ SqlColumnNumber = 18, SqlFieldName = Clinic_Catherize ];

/// 会阴擦洗（冲洗）
Property ClinicScrub As %Integer [ SqlColumnNumber = 19, SqlFieldName = Clinic_Scrub ];

/// 膀胱冲洗
Property ClinicBladderClean As %Integer [ SqlColumnNumber = 20, SqlFieldName = Clinic_BladderClean ];

/// 灌肠
Property ClinicClyster As %Integer [ SqlColumnNumber = 21, SqlFieldName = Clinic_Clyster ];

/// 各种注射
Property ClinicInjection As %Integer [ SqlColumnNumber = 22, SqlFieldName = Clinic_Injection ];

/// 静脉抽血
Property ClinicVenousBlood As %Integer [ SqlColumnNumber = 23, SqlFieldName = Clinic_VenousBlood ];

/// 动脉抽血
Property ClinicArterialBlood As %Integer [ SqlColumnNumber = 24, SqlFieldName = Clinic_ArterialBlood ];

/// 测微量血糖
Property ClinicBloodSugar As %Integer [ SqlColumnNumber = 25, SqlFieldName = Clinic_BloodSugar ];

Index date On (ClinicDate, ClinicWard);

Storage Default
{
<Data name="MgClinicDayWorkDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ClinicWard</Value>
</Value>
<Value name="3">
<Value>ClinicDate</Value>
</Value>
<Value name="4">
<Value>ClinicCriticaly</Value>
</Value>
<Value name="5">
<Value>ClinicSick</Value>
</Value>
<Value name="6">
<Value>ClinicFirstCare</Value>
</Value>
<Value name="7">
<Value>ClinicSecondCare</Value>
</Value>
<Value name="8">
<Value>ClinicSurgery</Value>
</Value>
<Value name="9">
<Value>ClinicInSurgery</Value>
</Value>
<Value name="10">
<Value>ClinicPressCare</Value>
</Value>
<Value name="11">
<Value>ClinicDresse</Value>
</Value>
<Value name="12">
<Value>ClinicDrainage</Value>
</Value>
<Value name="13">
<Value>ClinicOralCare</Value>
</Value>
<Value name="14">
<Value>ClinicInhalation</Value>
</Value>
<Value name="15">
<Value>ClinicShampoo</Value>
</Value>
<Value name="16">
<Value>ClinicBedBath</Value>
</Value>
<Value name="17">
<Value>ClinicCutNail</Value>
</Value>
<Value name="18">
<Value>ClinicCatherize</Value>
</Value>
<Value name="19">
<Value>ClinicScrub</Value>
</Value>
<Value name="20">
<Value>ClinicBladderClean</Value>
</Value>
<Value name="21">
<Value>ClinicClyster</Value>
</Value>
<Value name="22">
<Value>ClinicInjection</Value>
</Value>
<Value name="23">
<Value>ClinicVenousBlood</Value>
</Value>
<Value name="24">
<Value>ClinicArterialBlood</Value>
</Value>
<Value name="25">
<Value>ClinicBloodSugar</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Arg.MgClinicDayWorkD</DataLocation>
<DefaultData>MgClinicDayWorkDefaultData</DefaultData>
<IdLocation>^DHCNMG.Arg.MgClinicDayWorkD</IdLocation>
<IndexLocation>^DHCNMG.Arg.MgClinicDayWorkI</IndexLocation>
<StreamLocation>^DHCNMG.Arg.MgClinicDayWorkS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
