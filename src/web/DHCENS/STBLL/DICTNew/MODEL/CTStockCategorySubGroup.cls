Class web.DHCENS.STBLL.DICTNew.MODEL.CTStockCategorySubGroup Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLNAME = "CT_StockCategorySubGroup";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 库存类组子类代码
Property CTSCSGCode As %Library.String(MAXLEN = 50, XMLNAME = "CTSCSG_Code");

/// 库存类组子类描述
Property CTSCSGDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTSCSG_Desc");

/// 代码表类型
Property CTSCSGCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTSCSG_CodesystemCode");

/// 库存类组代码
Property CTSCSGGroupCode As %Library.String(MAXLEN = 50, XMLNAME = "CTSCSG_GroupCode");

/// 最后更新人编码
Property CTSCSGUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTSCSG_UpdateUserCode");

/// 最后更新日期
Property CTSCSGUpdateDate As %Library.Date(XMLNAME = "CTSCSG_UpdateDate");

/// 最后更新时间
Property CTSCSGUpdateTime As %Library.Time(XMLNAME = "CTSCSG_UpdateTime");

/// 备注
Property CTSCSGRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTSCSG_Remarks");

/// 创建日期
Property CTSCSGCreatDate As %Library.Date(XMLNAME = "CTSCSG_CreatDate");

/// 创建时间
Property CTSCSGCreatTime As %Library.Time(XMLNAME = "CTSCSG_CreatTime");

/// 原代码
Property CTSCSGOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTSCSG_OriginalCode");

/// 原描述
Property CTSCSGOriginalDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTSCSG_OriginalDesc");

/// 有效开始日期
Property CTSCSGStartDate As %Library.Date(XMLNAME = "CTSCSG_StartDate");

/// 有效结束日期
Property CTSCSGEndDate As %Library.Date(XMLNAME = "CTSCSG_EndDate");

/// 医院代码
Property CTSCSGHosCode As %Library.String(MAXLEN = 50, XMLNAME = "CTSCSG_HosCode");

/// 状态
Property CTSCSGStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTSCSG_Status");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
