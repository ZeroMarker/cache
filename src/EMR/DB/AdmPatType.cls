/// 名称: 病人类型(新框架)
/// 描述: 在模板权限中，如果一个科室有多套模板，那么需要增加一个病人类型来控制，本表保存选中的病人类型
/// 编写者：gouzongtao
/// 编写日期: 2014-01-07
Class EMR.DB.AdmPatType Extends %Persistent
{

Index IdxEpisodeID On EpisodeID [ Unique ];

/// 病人就诊号
Property EpisodeID As User.PAAdm;

/// 指定到科室
Property PatType As %String;

/// 指定病人类型的医生ID
Property AppointUserID As User.SSUser;

/// 患者关联的疾病种类
Property EMRDOCDiagnosID As CF.EMR.DOC.Diagnos;

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
<Value>EMRDOCDiagnosID</Value>
</Value>
</Data>
<DataLocation>^EMR.DB.AdmPatTypeD</DataLocation>
<DefaultData>AdmPatTypeDefaultData</DefaultData>
<IdLocation>^EMR.DB.AdmPatTypeD</IdLocation>
<IndexLocation>^EMR.DB.AdmPatTypeI</IndexLocation>
<StreamLocation>^EMR.DB.AdmPatTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
