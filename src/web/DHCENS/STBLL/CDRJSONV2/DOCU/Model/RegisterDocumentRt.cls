Class web.DHCENS.STBLL.CDRJSONV2.DOCU.Model.RegisterDocumentRt Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "HOS_Document";

/// 医疗机构编码
Property OrganizationCode As %Library.String(MAXLEN = 18, XMLNAME = "OrganizationCode");

/// 患者主索引
Property PATPatientID As %Library.String(MAXLEN = 30, XMLNAME = "PATPatientID");

/// 就诊号
Property PAADMVisitNumber As %Library.Integer(XMLNAME = "PAADMVisitNumber");

/// 检查号
Property RISRExamID As %Library.Integer(XMLNAME = "RISRExamID");

/// 样本号（条码号）
Property SpecimenID As %Library.Integer(XMLNAME = "SpecimenID");

/// 文件格式
Property DocumentFormat As %Library.Integer(XMLNAME = "DocumentFormat");

/// 医嘱号
Property OEORIOrderItemID As %Library.Integer(XMLNAME = "OEORIOrderItemID");

/// 文档类型代码
Property DocumentType As %Library.String(MAXLEN = 20, XMLNAME = "DocumentType");

/// RowID(文档ID)
Property DocumentID As %Library.Integer(XMLNAME = "DocumentID");

/// 文档内容
Property DocumentContent As %GlobalCharacterStream(XMLNAME = "HOSD_PatientName");

/// 文档路径
Property DocumentPath As %Library.String(MAXLEN = 32767, XMLNAME = "DocumentPath");

/// 最后更新人编码
Property UpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "UpdateUserCode");

/// 最后更新日期
Property UpdateDate As %Library.String(MAXLEN = 18, XMLNAME = "UpdateDate");

/// 最后更新时间
Property UpdateTime As %Library.String(MAXLEN = 4, XMLNAME = "UpdateTime");

}
