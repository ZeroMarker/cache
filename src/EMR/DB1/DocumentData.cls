/// 名称:	EMR.DB1.DocumentData
/// 描述:	电子病历-实例数据表
/// 编写者：yejian
/// 编写日期: 2020-9-29
/// 产品组：电子病历产品组
Class EMR.DB1.DocumentData Extends %Persistent
{

Index RowIDBasedIDKeyIndex On GlobalDataID [ IdKey, PrimaryKey, Unique ];

Index IdxMain On (EpisodeID, DOCCategoryCode, ListNo) [ Unique ];

Index IdxEpisodeDCCodeHDT On (EpisodeID, DOCCategoryCode, HappenDate, HappenTime);

Index IdxEpisodeDCodeHDT On (EpisodeID, DOCCode, HappenDate, HappenTime);

Index IdxModifyDT On (ModifyDate, ModifyTime);

Index IdxCreateDT On (CreateDate, CreateTime);

Index IdxHappenDT On (HappenDate, HappenTime);

Index IdxEpisodeStatusHDT On (EpisodeID, Status, HappenDate, HappenTime);

Index IdxEpisodeRecordCodeStatus On (EpisodeID, DOCCode, Status);

Index IdxEpisodeDCCodeStatus On (EpisodeID, DOCCategoryCode, DOCCode, Status);

Index IdxEpisodeDOCCCodeStatus On (EpisodeID, DOCCategoryCode, Status);

Index IdxEpisodeTemplateStatusHDT On (EpisodeID, TemplateID, Status, HappenDate, HappenTime);

Index IdxEpisodeTemplateStatus On (EpisodeID, TemplateID, Status);

Index IdxTemplateVStatus On (TemplateID, TemplateVersion, Status);

/// 全局ECRecordID
Property GlobalDataID As %String;

/// 就诊号
Property EpisodeID As User.PAAdm [ Required, SqlColumnNumber = 2 ];

/// 住院号
Property PatientID As User.PAPatMas [ Required, SqlColumnNumber = 3 ];

/// 模板ID
Property TemplateID As CF.EMR.DOC.Template [ Required, SqlColumnNumber = 4 ];

/// 版本
Property TemplateVersion As %Integer [ Required, SqlColumnNumber = 5 ];

/// 业务活动记录分类编码
Property DOCCategoryCode As %String(TRUNCATE = 0) [ Required, SqlColumnNumber = 6 ];

/// 业务活动记录编码(标题代码)
Property DOCCode As %String(TRUNCATE = 0) [ Required, SqlColumnNumber = 7 ];

/// 标题
Property DOCName As %String(TRUNCATE = 0) [ Required, SqlColumnNumber = 8 ];

/// 顺序号
Property ListNo As %Integer [ Required, SqlColumnNumber = 9 ];

/// 状态（保存 Save、删除 Delete)
Property Status As %String(TRUNCATE = 0) [ Required, SqlColumnNumber = 10 ];

/// 模板目录ID
Property TemplateCategoryID As CF.EMR.DOC.TemplateCategory [ Required, SqlColumnNumber = 11 ];

/// 模板目录名
Property TemplateCategoryName As %String(TRUNCATE = 0) [ SqlColumnNumber = 12 ];

/// 病历创建者
Property CreateUser As User.SSUser [ SqlColumnNumber = 13 ];

/// 病历创建日期
Property CreateDate As %Date [ Required, SqlColumnNumber = 14 ];

/// 病历创建时间
Property CreateTime As %Time [ Required, SqlColumnNumber = 15 ];

/// 病历对应的行为发生日期，一般来说等于CreateDate
Property HappenDate As %Date [ SqlColumnNumber = 16 ];

/// 发生时间
Property HappenTime As %Time [ SqlColumnNumber = 17 ];

/// 修改者
Property ModifyUser As User.SSUser [ SqlColumnNumber = 18 ];

/// 病历修改日期
Property ModifyDate As %Date [ SqlColumnNumber = 19 ];

/// 修改时间
Property ModifyTime As %Time [ SqlColumnNumber = 20 ];

/// 备注
Property Memo As %String(MAXLEN = 32767, TRUNCATE = 0) [ SqlColumnNumber = 21 ];

/// 文档源ID（模板ID/科室模板ID/个人模板ID/引用病历ID）
Property SourceID As %String(TRUNCATE = 0) [ SqlColumnNumber = 22 ];

/// 文档源类型（TEMPLATE(模板)/LOCTEMPLATE(科室模板)/PERSONTEMPLATE(个人模板ID)/REFREANCE(引用病历)
Property SourceType As %String(TRUNCATE = 0) [ SqlColumnNumber = 23 ];

/// 文档特性 0单文档显示 1多个文档连续显示
Property Serial As %String(TRUNCATE = 0) [ SqlColumnNumber = 24 ];

/// 流数据
Property DocumentStream As EMR.DB1.DocumentStream [ SqlColumnNumber = 25 ];

/// 病历目前最新状态Code
Property EMRStatus As CF.EMR.DOC.EMRStatus [ SqlColumnNumber = 26 ];

Storage Default
{
<Data name="DocumentDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>PatientID</Value>
</Value>
<Value name="4">
<Value>TemplateID</Value>
</Value>
<Value name="5">
<Value>TemplateVersion</Value>
</Value>
<Value name="6">
<Value>DOCCategoryCode</Value>
</Value>
<Value name="7">
<Value>DOCCode</Value>
</Value>
<Value name="8">
<Value>DOCName</Value>
</Value>
<Value name="9">
<Value>ListNo</Value>
</Value>
<Value name="10">
<Value>Status</Value>
</Value>
<Value name="11">
<Value>TemplateCategoryID</Value>
</Value>
<Value name="12">
<Value>TemplateCategoryName</Value>
</Value>
<Value name="13">
<Value>CreateUser</Value>
</Value>
<Value name="14">
<Value>CreateDate</Value>
</Value>
<Value name="15">
<Value>CreateTime</Value>
</Value>
<Value name="16">
<Value>HappenDate</Value>
</Value>
<Value name="17">
<Value>HappenTime</Value>
</Value>
<Value name="18">
<Value>ModifyUser</Value>
</Value>
<Value name="19">
<Value>ModifyDate</Value>
</Value>
<Value name="20">
<Value>ModifyTime</Value>
</Value>
<Value name="21">
<Value>Memo</Value>
</Value>
<Value name="22">
<Value>SourceID</Value>
</Value>
<Value name="23">
<Value>SourceType</Value>
</Value>
<Value name="24">
<Value>Serial</Value>
</Value>
<Value name="25">
<Value>DocumentStream</Value>
</Value>
<Value name="26">
<Value>EMRStatus</Value>
</Value>
</Data>
<DataLocation>^EMR.DB1.DocumentDataD</DataLocation>
<DefaultData>DocumentDataDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^EMR.DB1.DocumentDataD</IdLocation>
<IndexLocation>^EMR.DB1.DocumentDataI</IndexLocation>
<StreamLocation>^EMR.DB1.DocumentDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
