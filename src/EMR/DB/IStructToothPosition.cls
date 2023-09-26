/// 名称:	EMR.DB.IStructToothPosition
/// 描述:	牙位图牙位打散表
/// 编写者：yejian
/// 编写日期: 2022-11-3
/// 产品组：电子病历产品组
Class EMR.DB.IStructToothPosition Extends %Persistent
{

Index IdxForUpdate On (DocumentID, SectionCode, ToothImageCode, ToothCode) [ Unique ];

Index IdxForLink On (EpisodeID, TemplateID, SectionCode, ToothImageCode, ToothCode, DocumentID) [ Unique ];

/// 就诊号
Property EpisodeID As User.PAAdm;

/// 实例ID
Property DocumentID As EMR.DB.DocumentData;

/// 住院号
Property PatientID As User.PAPatMas;

/// 业务活动记录编码(标题代码)
Property DOCCode As %String(TRUNCATE = 0);

/// 模板ID
Property TemplateID As CF.EMR.DOC.Template;

/// 版本
Property TemplateVersion As %Integer;

/// 片段id
Property KBNodeID As %String(TRUNCATE = 1);

/// 章节编码
Property SectionCode As %String(TRUNCATE = 1);

/// 牙位图编码
Property ToothImageCode As %String(TRUNCATE = 1);

/// 业务编码
Property EMRCode As %String(TRUNCATE = 1);

/// 牙编码
Property ToothCode As %String(TRUNCATE = 1);

/// 牙名称
Property ToothName As %String(TRUNCATE = 1);

/// 牙象限（A、B、C、D）
Property Quadrant As %String(TRUNCATE = 1);

/// 牙位定义
Property Define As %String(TRUNCATE = 1);

/// 数据
Property Text As %String(TRUNCATE = 1);

Storage Default
{
<Data name="IStructToothPositionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>DocumentID</Value>
</Value>
<Value name="4">
<Value>PatientID</Value>
</Value>
<Value name="5">
<Value>DOCCode</Value>
</Value>
<Value name="6">
<Value>TemplateID</Value>
</Value>
<Value name="7">
<Value>TemplateVersion</Value>
</Value>
<Value name="8">
<Value>KBNodeID</Value>
</Value>
<Value name="9">
<Value>SectionCode</Value>
</Value>
<Value name="10">
<Value>ToothImageCode</Value>
</Value>
<Value name="11">
<Value>EMRCode</Value>
</Value>
<Value name="12">
<Value>ToothCode</Value>
</Value>
<Value name="13">
<Value>ToothName</Value>
</Value>
<Value name="14">
<Value>Quadrant</Value>
</Value>
<Value name="15">
<Value>Define</Value>
</Value>
<Value name="16">
<Value>Text</Value>
</Value>
</Data>
<DataLocation>^EMR.DB.IStructToothPositionD</DataLocation>
<DefaultData>IStructToothPositionDefaultData</DefaultData>
<IdLocation>^EMR.DB.IStructToothPositionD</IdLocation>
<IndexLocation>^EMR.DB.IStructToothPositionI</IndexLocation>
<StreamLocation>^EMR.DB.IStructToothPositionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
