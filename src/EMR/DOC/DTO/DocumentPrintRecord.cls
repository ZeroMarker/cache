/// 名称:	EMR.DOC.DTO.DocumentPrintRecord
/// 描述:	门诊病历 文档打印传输对象
/// 编写者：	yejian
/// 编写日期: 	2021-7-29
/// 产品组：电子病历产品组
Class EMR.DOC.DTO.DocumentPrintRecord Extends %RegisteredObject
{

/// rowID
Property ID As %String;

/// 实例ID
Property DocumentID As %String;

/// 顺序号
Property ListNo As %Integer;

/// 打印者ID
Property PrintUserID As %String;

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
Property PrintTemplateID As %String;

/// 打印模板版本
Property PrintTemplateVersion As %String(TRUNCATE = 1);

/// 打印类型（SELFPRINT 自助打印/EMR 病历打印/FS 归档打印）
Property PrintType As %String(TRUNCATE = 1);

/// 打印类型编码()
Property PrintCode As %String(TRUNCATE = 1);

/// 操作IP
Property OperateMachineIP As %String(TRUNCATE = 1);

/// 自助机名称
Property CreateName As %String(TRUNCATE = 1);

/// 文档类型(WORD/PDF)
Property RecordType As %String(TRUNCATE = 1);

/// 就诊号
Property EpisodeID As %String;

/// 业务活动记录分类编码
Property DOCCategoryCode As %String(TRUNCATE = 1);

/// 业务活动记录编码(标题代码)
Property DOCCode As %String(TRUNCATE = 1);

/// 打印后修改的文档ID集合^分隔
Property ModifyDocumentIDs As %String(TRUNCATE = 1);

/// 项目标识
Property Product As %String(TRUNCATE = 1);

/// 语言ID
Property LangID As %String(TRUNCATE = 1);

}
