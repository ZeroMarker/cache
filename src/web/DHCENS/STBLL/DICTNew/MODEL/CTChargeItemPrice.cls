/// 收费项目价格
Class web.DHCENS.STBLL.DICTNew.MODEL.CTChargeItemPrice Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLNAME = "CT_ChargeItemPrice";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 流水号
Property CTCIPRowId As %Library.String(XMLNAME = "CTCIP_RowId");

/// 价格
Property CTCIPPrice As %Library.String(MAXLEN = 50, XMLNAME = "CTCIP_Price");

/// 有效日期（开始）
Property CTCIPStartDate As %Library.Date(XMLNAME = "CTCIP_StartDate");

/// 有效日期（结束）
Property CTCIPEndDate As %Library.Date(XMLNAME = "CTCIP_EndDate");

/// 代码表类型
Property CTCIPCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCIP_CodesystemCode");

/// 以下字段为2018.9新增,根据<主数据表结构说明V1.4.doc>
/// 收费项目代码
Property CTCIPChargeItemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCIP_ChargeItemCode");

/// 患者费别代码
Property CTCIPCostCategoryCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCIP_CostCategoryCode");

/// 备注
Property CTCIPRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTCIP_Remarks");

/// 最后更新人编码
Property CTCIPUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCIP_UpdateUserCode");

/// 最后更新日期
Property CTCIPUpdateDate As %Library.Date(XMLNAME = "CTCIP_UpdateDate");

/// 最后更新时间
Property CTCIPUpdateTime As %Library.Time(XMLNAME = "CTCIP_UpdateTime");

/// 创建日期
Property CTCIPCreatDate As %Library.Date(XMLNAME = "CTCIP_CreatDate");

/// 创建时间
Property CTCIPCreatTime As %Library.Time(XMLNAME = "CTCIP_CreatTime");

/// 原ID
Property CTCIPOriginalRowId As %Library.String(XMLNAME = "CTCIP_OriginalRowId");

/// 医院代码
Property CTCIPHosCode As %Library.String(XMLNAME = "CTCIP_HosCode");

/// 状态（1启用0停用-1删除）
Property CTCIPStatus As %Library.String(XMLNAME = "CTCIP_Status");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
