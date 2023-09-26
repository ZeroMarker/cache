/// 交叉质控抽查信息
Class EPRinstance.Quality.ExtractInfo Extends %Persistent
{

// 患者类型索引

Index IdxAdmType On AdmType;

// 开始时间

Property StartDate As %String;

// 结束时间

Property EndDate As %String;

// 病历类型，有门诊病历O、环节病历IA、终末病历ID

Property AdmType As %String;

// 科室Id

Property LocId As %String;

// 抽取比率

Property Ratio As %String;

// 抽取数量

Property ExtractNumber As %String;

// 重点患者类型，如抢救患者、输血患者、手术患者等

Property SpecialAdmType As %String;

Storage Default
{
<Data name="ExtractInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>StartDate</Value>
</Value>
<Value name="3">
<Value>EndDate</Value>
</Value>
<Value name="4">
<Value>AdmType</Value>
</Value>
<Value name="5">
<Value>LocId</Value>
</Value>
<Value name="6">
<Value>Ratio</Value>
</Value>
<Value name="7">
<Value>ExtractNumber</Value>
</Value>
<Value name="8">
<Value>SpecialAdmType</Value>
</Value>
</Data>
<DataLocation>^DHCEPRQ.ExtractInfoD</DataLocation>
<DefaultData>DHCEPRQ.ExtractInfoD</DefaultData>
<IdLocation>^DHCEPRQ.ExtractInfoD</IdLocation>
<IndexLocation>^DHCEPRQ.ExtractInfoI</IndexLocation>
<StreamLocation>^DHCEPRQ.ExtractInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
