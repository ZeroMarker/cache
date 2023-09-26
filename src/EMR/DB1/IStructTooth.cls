/// 名称:	EMR.DB1.IStructTooth
/// 描述:	牙位图打散
/// 编写者：yejian
/// 编写日期: 2022-11-3
/// 产品组：电子病历产品组
Class EMR.DB1.IStructTooth Extends %Persistent
{

Index IdxForUpdate On (DocumentID, SectionCode, ToothImageCode) [ Unique ];

Index IdxForLink On (EpisodeID, TemplateID, SectionCode, ToothImageCode, DocumentID) [ Unique ];

/// 就诊号
Property EpisodeID As User.PAAdm;

/// 实例ID
Property DocumentID As EMR.DB1.DocumentData;

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

/// 业务编码
Property EMRCode As %String(TRUNCATE = 1);

/// 牙位图编码
Property ToothImageCode As %String(TRUNCATE = 1);

/// 名称(十字牙位图)
Property ToothImageName As %String(TRUNCATE = 1);

/// 牙位图表示法(PALMER，UNIVERSAL)
Property CodeSystem As %String(TRUNCATE = 1);

/// 牙位图表示法名称(帕尔默牙位表示法,通用记录表示法)
Property CodeSystemName As %String(TRUNCATE = 1);

/// 牙位表示法(PALMER，UNIVERSAL)
Property SurfaceCodeSystem As %String(TRUNCATE = 1);

/// 牙位表示法名称(帕尔默牙位表示法,通用记录表示法)
Property SurfaceCodeSystemName As %String(TRUNCATE = 1);

/// 编码(片段维护编码)
Property SourceCode As %String(TRUNCATE = 1);

/// 文本(包含上下标等信息)
Property Text As %GlobalCharacterStream(LOCATION = "^EMR.DB1.IStructToothS");

/// 牙类型（Permanent,Deciduous,ToothAll）
Property ToothType As %String(TRUNCATE = 1);

/// 展示类型（image/text）
Property ShowType As %String(TRUNCATE = 1);

/// 牙位表示法
Property ToothREP As %String(TRUNCATE = 1);

Storage Default
{
<Data name="IStructToothDefaultData">
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
<Value>EMRCode</Value>
</Value>
<Value name="11">
<Value>ToothImageCode</Value>
</Value>
<Value name="12">
<Value>ToothImageName</Value>
</Value>
<Value name="13">
<Value>CodeSystem</Value>
</Value>
<Value name="14">
<Value>CodeSystemName</Value>
</Value>
<Value name="15">
<Value>SurfaceCodeSystem</Value>
</Value>
<Value name="16">
<Value>SurfaceCodeSystemName</Value>
</Value>
<Value name="17">
<Value>SourceCode</Value>
</Value>
<Value name="18">
<Value>Text</Value>
</Value>
<Value name="19">
<Value>ToothType</Value>
</Value>
<Value name="20">
<Value>ShowType</Value>
</Value>
<Value name="21">
<Value>ToothREP</Value>
</Value>
</Data>
<DataLocation>^EMR.DB1.IStructToothD</DataLocation>
<DefaultData>IStructToothDefaultData</DefaultData>
<IdLocation>^EMR.DB1.IStructToothD</IdLocation>
<IndexLocation>^EMR.DB1.IStructToothI</IndexLocation>
<StreamLocation>^EMR.DB1.IStructToothS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
