Class web.DHCENS.STBLL.DICTNew.MODEL.CTOperation Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLNAME = "CT_Operation";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 手术代码
Property CTOCode As %Library.String(MAXLEN = 50, XMLNAME = "CTO_Code");

/// 代码表类型
Property CTOCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTO_CodesystemCode");

/// 手术名称
Property CTODesc As %Library.String(MAXLEN = 128, XMLNAME = "CTO_Desc");

/// ICD代码
Property CTOICDCode As %Library.String(MAXLEN = 50, XMLNAME = "CTO_ICDCode");

/// 备注
Property CTORemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTO_Remarks");

/// 最后更新日期
Property CTOUpdateDate As %Library.Date(XMLNAME = "CTO_UpdateDate");

/// 最后更新时间
Property CTOUpdateTime As %Library.Time(XMLNAME = "CTO_UpdateTime");

/// 最后更新人编码
Property CTOUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTO_UpdateUserCode");

/// 创建日期
Property CTOCreatDate As %Library.Date(XMLNAME = "CTO_CreatDate");

/// 创建时间
Property CTOCreatTime As %Library.Time(XMLNAME = "CTO_CreatTime");

/// 原代码
Property CTOOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTO_OriginalCode");

/// 原描述
Property CTOOriginalDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTO_OriginalDesc");

/// 有效开始日期
Property CTOStartDate As %Library.Date(XMLNAME = "CTO_StartDate");

/// 有效结束日期
Property CTOEndDate As %Library.Date(XMLNAME = "CTO_EndDate");

/// 级别代码
Property CTOLevelCode As %Library.String(MAXLEN = 50, XMLNAME = "CTO_LevelCode");

/// 状态
Property CTOStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTO_Status");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
