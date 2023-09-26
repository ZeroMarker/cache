Class web.DHCENS.STBLL.EMPI.MODEL.PAAllergy Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "PAAllergy";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 过敏记录ID
Property PAALLAllergyID As %Library.String(MAXLEN = 30, XMLNAME = "PAALL_AllergyID");

/// 病人ID
Property PAALLPatientID As %Library.String(MAXLEN = 30, XMLNAME = "PAALL_PatientID");

/// 就诊号码
Property PAALLVisitNumber As %Library.String(MAXLEN = 30, XMLNAME = "PAALL_VisitNumber");

/// 过敏源描述
Property PAALLSourceDesc As %Library.String(MAXLEN = 100, XMLNAME = "PAALL_SourceDesc");

/// 过敏类别
Property PAALLCategoryCode As %Library.String(MAXLEN = 20, XMLNAME = "PAALL_CategoryCode");

/// 过敏反应描述
Property PAALLReactionDesc As %Library.String(MAXLEN = 100, XMLNAME = "PAALL_ReactionDesc");

/// 严重级别
Property PAALLSeverityCode As %Library.String(MAXLEN = 20, XMLNAME = "PAALL_SeverityCode");

/// 发病日期
Property PAALLDate As %Library.String(MAXLEN = 20, XMLNAME = "PAALL_Date");

/// 状态
Property PAALLStatus As %Library.String(MAXLEN = 1, XMLNAME = "PAALL_Status");

/// 最后更新日期
Property PAALLUpdateDate As %Library.String(MAXLEN = 20, XMLNAME = "PAALL_UpdateDate");

/// 最后更新时间
Property PAALLUpdateTime As %Library.String(MAXLEN = 20, XMLNAME = "PAALL_UpdateTime");

/// 最后更新人编码
Property PAALLUpdateUserCode As %Library.String(MAXLEN = 10, XMLNAME = "PAALL_UpdateUserCode");

}
