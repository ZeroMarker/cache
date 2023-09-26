/// 名称:	EMR.DB.DocumentPrintRecord
/// 描述:	电子病历-打印记录表
/// 编写者：yejian
/// 编写日期: 2020-9-29
/// 产品组：电子病历产品组
Class EMR.DB.DocumentPrintRecord Extends %Persistent
{

Index IdxHappenDateTime On (HappenDate, HappenTime);

Index IdxDocumentID On DocumentID;

Index IdxTypeID On (PrintType, DocumentID);

Index IdxDocumentIDType On (DocumentID, PrintType);

Index IdxDOCCodePrintDT On (EpisodeID, DOCCategoryCode, PrintDate, PrintTime);

Index IdxDOCCodeHappenDT On (EpisodeID, DOCCategoryCode, HappenDate, HappenTime);

/// 实例ID
Property DocumentID As EMR.DB.DocumentData;

/// 顺序号
Property ListNo As %Integer;

/// 打印者ID
Property PrintUserID As User.SSUser;

/// 打印日期
Property PrintDate As %Date;

/// 打印时间
Property PrintTime As %Time;

/// 发生日期
Property HappenDate As %Date;

/// 发生时间
Property HappenTime As %Time;

/// 打印状态 Printed
Property PrintStatus As %String(TRUNCATE = 1);

/// 打印模板ID
Property PrintTemplateID As CF.EMR.DOC.Template;

/// 打印模板版本
Property PrintTemplateVersion As %String(TRUNCATE = 1);

/// 打印类型（SELFPRINT 自助打印/EMR 病历打印/FS 归档打印/PATCH 补打/）
Property PrintType As %String(TRUNCATE = 1);

/// 打印类型编码()
Property PrintCode As %String(TRUNCATE = 1);

/// 操作IP
Property OperateMachineIP As %String(TRUNCATE = 1);

/// 自助机名称
Property CreateName As %String(TRUNCATE = 1);

/// 病历类型（WORD，PDF）
Property RecordType As %String(TRUNCATE = 1);

/// 就诊号
Property EpisodeID As User.PAAdm;

/// 业务活动记录分类编码
Property DOCCategoryCode As %String(TRUNCATE = 0);

/// 业务活动记录编码(标题代码)
Property DOCCode As %String(TRUNCATE = 0);

/// 打印后修改的文档ID集合^分隔
Property ModifyDocumentIDs As %String(TRUNCATE = 0);

Storage Default
{
<Data name="DocumentPrintRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DocumentID</Value>
</Value>
<Value name="3">
<Value>ListNo</Value>
</Value>
<Value name="4">
<Value>PrintUserID</Value>
</Value>
<Value name="5">
<Value>PrintDate</Value>
</Value>
<Value name="6">
<Value>PrintTime</Value>
</Value>
<Value name="7">
<Value>HappenDate</Value>
</Value>
<Value name="8">
<Value>HappenTime</Value>
</Value>
<Value name="9">
<Value>PrintStatus</Value>
</Value>
<Value name="10">
<Value>PrintTemplateID</Value>
</Value>
<Value name="11">
<Value>PrintTemplateVersion</Value>
</Value>
<Value name="12">
<Value>PrintType</Value>
</Value>
<Value name="13">
<Value>PrintCode</Value>
</Value>
<Value name="14">
<Value>OperateMachineIP</Value>
</Value>
<Value name="15">
<Value>CreateName</Value>
</Value>
<Value name="16">
<Value>RecordType</Value>
</Value>
<Value name="17">
<Value>EpisodeID</Value>
</Value>
<Value name="18">
<Value>DOCCategoryCode</Value>
</Value>
<Value name="19">
<Value>DOCCode</Value>
</Value>
<Value name="20">
<Value>ModifyDocumentIDs</Value>
</Value>
</Data>
<DataLocation>^EMR.DB.DocumentPrintRecordD</DataLocation>
<DefaultData>DocumentPrintRecordDefaultData</DefaultData>
<IdLocation>^EMR.DB.DocumentPrintRecordD</IdLocation>
<IndexLocation>^EMR.DB.DocumentPrintRecordI</IndexLocation>
<StreamLocation>^EMR.DB.DocumentPrintRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
