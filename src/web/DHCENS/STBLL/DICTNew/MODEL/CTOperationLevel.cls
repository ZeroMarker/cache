Class web.DHCENS.STBLL.DICTNew.MODEL.CTOperationLevel Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "CT_OperationLevel";

Parameter XMLIGNOREINVALIDTAG = 1;

/// 手术级别代码
Property CTOLCode As %Library.String(MAXLEN = 50, XMLNAME = "CTOL_Code");

/// 手术级别名称
Property CTOLDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTOL_Desc");

/// 系统代码表类型
Property CTOLCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTOL_CodesystemCode");

/// 状态（1启用,0停用,-1删除）
Property CTOLStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTOL_Status");

/// 备注
Property CTOLRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTOL_Remarks");

/// 最后更新日期
Property CTCTUpdateDate As %Library.Date(XMLNAME = "CTOL_UpdateDate");

/// 最后更新时间
Property CTOLUpdateTime As %Library.Time(XMLNAME = "CTOL_UpdateTime");

/// 最后更新人编码
Property CTOLUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTOL_UpdateUserCode");

/// 以下字段为2018.9新增,根据<主数据表结构说明V1.4.doc>
/// 原代码
Property CTOLOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTOL_OriginalCode");

/// 原描述
Property CTOLOriginalDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTOL_OriginalDesc");

/// 有效开始日期
Property CTOLStartDate As %Library.Date(XMLNAME = "CTOL_StartDate");

/// 有效结束日期
Property CTOLEndDate As %Library.Date(XMLNAME = "CTOL_EndDate");

/// 创建日期
Property CTOLCreatDate As %Library.Date(XMLNAME = "CTOL_CreatDate");

/// 创建时间
Property CTOLCreatTime As %Library.Time(XMLNAME = "CTOL_CreatTime");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
