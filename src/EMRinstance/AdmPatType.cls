/// 名称: 病人类型(新框架)
/// 描述: 在模板权限中，如果一个科室有多套模板，那么需要增加一个病人类型来控制，本表保存选中的病人类型
/// 编写者：gouzongtao
/// 编写日期: 2014-01-07
Class EMRinstance.AdmPatType Extends %Persistent
{

Index EpisodeIDIdx On EpisodeID [ Unique ];

Index IdxEpisodeID On EpisodeID [ Unique ];

/// 病人就诊号
Property EpisodeID As %String(TRUNCATE = 1);

/// 指定到科室
Property PatType As %String(TRUNCATE = 1);

/// 指定病人类型的医生ID
Property AppointUserID As %String(TRUNCATE = 1);

/// 患者关联的疾病种类
Property EPRKBDiagnosID As %String(TRUNCATE = 1);

/// 患者关联的疾病种类New
Property DiseaseCode As %String(TRUNCATE = 1);

Storage Default
{
<Data name="AdmPatTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>PatType</Value>
</Value>
<Value name="4">
<Value>AppointUserID</Value>
</Value>
<Value name="5">
<Value>EPRKBDiagnosID</Value>
</Value>
<Value name="6">
<Value>DiseaseCode</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.AdmPatTypeD</DataLocation>
<DefaultData>AdmPatTypeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRI.AdmPatTypeD</IdLocation>
<IndexLocation>^DHCEMRI.AdmPatTypeI</IndexLocation>
<StreamLocation>^DHCEMRI.AdmPatTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
