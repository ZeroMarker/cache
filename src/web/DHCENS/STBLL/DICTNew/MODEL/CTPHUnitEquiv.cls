Class web.DHCENS.STBLL.DICTNew.MODEL.CTPHUnitEquiv Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_PHUnitEquiv";

/// 关联id
Property CTUELinkId As %Library.String(MAXLEN = 50, XMLNAME = "CTUE_LinkId");

/// 代码表类型
Property CTUECodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTUE_CodesystemCode");

/// 药品代码
Property CTUEDrgCode As %Library.String(MAXLEN = 50, XMLNAME = "CTUE_DrgCode");

/// 单位代码
Property CTUEUnitCode As %Library.String(MAXLEN = 50, XMLNAME = "CTUE_UnitCode");

/// 等效剂量
Property CTUEEqQty As %Library.String(MAXLEN = 50, XMLNAME = "CTUE_EqQty");

/// 默认剂量
Property CTUEDefaultQty As %Library.String(MAXLEN = 50, XMLNAME = "CTUE_DefaultQty");

/// 备注
Property CTUERemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTUE_Remarks");

/// 最后更新人编码
Property CTUEUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTUE_UpdateUserCode");

/// 最后更新日期
Property CTUEUpdateDate As %Library.Date(XMLNAME = "CTUE_UpdateDate");

/// 最后更新时间
Property CTUEUpdateTime As %Library.Time(XMLNAME = "CTUE_UpdateTime");

/// 状态
Property CTUEStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTUE_Status");

/// 医院编号
Property CTUEHosCode As %Library.String(MAXLEN = 50, XMLNAME = "CTUE_HosCode");

/// 以下字段为2018.9新增,根据<主数据表结构说明V1.4.doc>
/// 原代码
Property CTUEOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTUE_OriginalCode");

/// 原描述
Property CTUEOriginalDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTUE_OriginalDesc");

/// 有效开始日期
Property CTUEStartDate As %Library.Date(XMLNAME = "CTUE_StartDate");

/// 有效结束日期
Property CTUEEndDate As %Library.Date(XMLNAME = "CTUE_EndDate");

/// 创建日期
Property CTUECreatDate As %Library.Date(XMLNAME = "CTUE_CreatDate");

/// 创建时间
Property CTUECreatTime As %Library.Time(XMLNAME = "CTUE_CreatTime");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
