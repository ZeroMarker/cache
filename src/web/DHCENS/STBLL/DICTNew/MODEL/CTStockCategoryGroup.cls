Class web.DHCENS.STBLL.DICTNew.MODEL.CTStockCategoryGroup Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLNAME = "CT_StockCategoryGroup";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 库存类组代码
Property CTSCGCode As %Library.String(MAXLEN = 50, XMLNAME = "CTSCG_Code");

/// 库存类组描述
Property CTSCGDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTSCG_Desc");

/// 类别
Property CTSCGType As %Library.String(MAXLEN = 50, XMLNAME = "CTSCG_Type");

/// 代码表类型
Property CTSCGCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTSCG_CodesystemCode");

/// 最后更新人编码
Property CTSCGUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTSCG_UpdateUserCode");

/// 最后更新日期
Property CTSCGUpdateDate As %Library.Date(XMLNAME = "CTSCG_UpdateDate");

/// 最后更新时间
Property CTSCGUpdateTime As %Library.Time(XMLNAME = "CTSCG_UpdateTime");

/// 备注
Property CTSCGRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTSCG_Remarks");

/// 医院代码
Property CTSCGHosCode As %Library.String(MAXLEN = 50, XMLNAME = "CTSCG_HosCode");

/// 状态
Property CTSCGStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTSCG_Status");

/// 以下字段为2018.9新增,根据<主数据表结构说明V1.4.doc>
/// 原代码
Property CTSCGOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTSCG_OriginalCode");

/// 原描述
Property CTSCGOriginalDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTSCG_OriginalDesc");

/// 有效开始日期
Property CTSCGStartDate As %Library.Date(XMLNAME = "CTSCG_StartDate");

/// 有效结束日期
Property CTSCGEndDate As %Library.Date(XMLNAME = "CTSCG_EndDate");

/// 创建日期
Property CTSCGCreatDate As %Library.Date(XMLNAME = "CTSCG_CreatDate");

/// 创建时间
Property CTSCGCreatTime As %Library.Time(XMLNAME = "CTSCG_CreatTime");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
