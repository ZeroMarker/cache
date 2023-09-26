/// 名称: 病人类型(新框架)
/// 描述: 在模板权限中，如果一个科室有多套模板，那么需要增加一个病人类型来控制，本表保存选中的病人类型
/// 编写者：chenwenjun
/// 编写日期: 09/08/12
Class EPRinstance.AdmPatType Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index EpisodeIDIdx On EpisodeID [ Unique ];

/// 病人就诊号
Property EpisodeID As %String(TRUNCATE = 1);

/// 指定到科室
Property PatType As %String(TRUNCATE = 1);

/// 指定病人类型的医生ID
Property AppointUserID As %String(TRUNCATE = 1);

/// 患者关联的疾病种类
Property EPRKBDiagnosID As %String(TRUNCATE = 1);

Storage Default
{
<Data name="AdmPatTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AppointUserID</Value>
</Value>
<Value name="3">
<Value>EpisodeID</Value>
</Value>
<Value name="4">
<Value>PatType</Value>
</Value>
<Value name="5">
<Value>EPRKBDiagnosID</Value>
</Value>
</Data>
<DataLocation>^DHCEPRI.AdmPatTypeD</DataLocation>
<DefaultData>AdmPatTypeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRI.AdmPatTypeD</IdLocation>
<IndexLocation>^DHCEPRI.AdmPatTypeI</IndexLocation>
<StreamLocation>^DHCEPRI.AdmPatTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
