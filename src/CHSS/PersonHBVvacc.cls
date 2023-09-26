Class CHSS.PersonHBVvacc Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = VaccRowId, SqlTableName = PersonHBVvacc ]
{

/// 个人档案主键
Property PersonRowId As CHSS.PersonHealthRecordMain;

/// 接种岁数
Property YearOfVacc As %Float;

/// 接种针数
Property TimesOfVaccination As %String(MAXLEN = 10, TRUNCATE = 1);

/// 接种后监测时间
Property TimeOfMonitor As %Date;

/// 接种方案
Property VaccPlan As %String(MAXLEN = 100, TRUNCATE = 1);

/// 抗HBs定性
Property HBsQuality As %String(MAXLEN = 10, TRUNCATE = 1);

/// 抗HBs定量
Property HBsRation As %String(MAXLEN = 10, TRUNCATE = 1);

/// 接种地点
Property VaccPlace As %String(MAXLEN = 50, TRUNCATE = 1);

/// 疫苗产地
Property VaccinationPlace As %String(MAXLEN = 50, TRUNCATE = 1);

/// 疫苗剂量
Property DosageOfVaccination As %String(MAXLEN = 10, TRUNCATE = 1);

Storage Default
{
<Data name="PersonHBVvaccDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DosageOfVaccination</Value>
</Value>
<Value name="3">
<Value>HBsQuality</Value>
</Value>
<Value name="4">
<Value>HBsRation</Value>
</Value>
<Value name="5">
<Value>PersonRowId</Value>
</Value>
<Value name="6">
<Value>TimeOfMonitor</Value>
</Value>
<Value name="7">
<Value>TimesOfVaccination</Value>
</Value>
<Value name="8">
<Value>VaccPlace</Value>
</Value>
<Value name="9">
<Value>VaccPlan</Value>
</Value>
<Value name="10">
<Value>VaccinationPlace</Value>
</Value>
<Value name="11">
<Value>YearOfVacc</Value>
</Value>
</Data>
<DataLocation>^CHSS.PersonHBVvaccD</DataLocation>
<DefaultData>PersonHBVvaccDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.PersonHBVvaccD</IdLocation>
<IndexLocation>^CHSS.PersonHBVvaccI</IndexLocation>
<StreamLocation>^CHSS.PersonHBVvaccS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
