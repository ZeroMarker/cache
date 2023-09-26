/// 麻醉方式
Class web.DHCENS.STBLL.DICTNew.MODEL.CTAnaesthesiaType Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLNAME = "CT_ORCAnaestType";

Parameter XMLIGNAMEINVALIDTAG = 1;

Parameter XMLIGNAMENULL = 1;

/// 代码
Property CTATCode As %Library.String(MAXLEN = 50, XMLNAME = "CTAT_Code");

/// 代码表类型
Property CTATCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTAT_CodesystemCode");

/// 描述
Property CTATDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTAT_Desc");

/// 备注
Property CTATRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTAT_Remarks");

/// 最后更新人编码
Property CTATUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTAT_UpdateUserCode");

/// 最后更新日期
Property CTATUpdateDate As %Library.Date(XMLNAME = "CTAT_UpdateDate");

/// 最后更新时间
Property CTATUpdateTime As %Library.Time(XMLNAME = "CTAT_UpdateTime");

/// 以下字段为2018.9新增,根据<主数据表结构说明V1.4.doc>
/// 创建日期
Property CTATCreatDate As %Library.Date(XMLNAME = "CTAT_CreatDate");

/// 创建时间
Property CTATCreatTime As %Library.Time(XMLNAME = "CTAT_CreatTime");

/// 原代码
Property CTATOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTAT_OriginalCode");

/// 原描述
Property CTATOriginalDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTAT_OriginalDesc");

/// 有效开始日期
Property CTATStartDate As %Library.Date(XMLNAME = "CTAT_StartDate");

/// 有效结束日期
Property CTATEndDate As %Library.Date(XMLNAME = "CTAT_EndDate");

/// 医院编号
Property CTATHosCode As %Library.String(MAXLEN = 50, XMLNAME = "CTAT_HosCode");

/// 状态（1启用0停用-1删除）
Property CTATStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTAT_Status");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
