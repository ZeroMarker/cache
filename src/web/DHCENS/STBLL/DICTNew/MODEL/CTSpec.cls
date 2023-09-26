Class web.DHCENS.STBLL.DICTNew.MODEL.CTSpec Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_Spec";

/// 代码
Property CTSPCCode As %Library.String(MAXLEN = 50, XMLNAME = "CTSPCCode");

/// 描述
Property CTSPCDesc As %Library.String(MAXLEN = 512, XMLNAME = "CTSPCDesc");

/// 代码表类型
Property CTSCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTSCodesystemCode");

/// 状态（1启用0停用-1删除）
Property CTSStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTSStatus");

/// 最后更新人编码
Property CTSUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTSUpdateUserCode");

/// 最后更新日期
Property CTSUpdateDate As %Library.Date(XMLNAME = "CTSUpdateDate");

/// 以下字段为2018.9新增,根据<主数据表结构说明V1.4.doc>
/// 原代码
Property CTSOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTS_OriginalCode");

/// 原描述
Property CTSOriginalDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTS_OriginalDesc");

/// 有效开始日期
Property CTSStartDate As %Library.Date(XMLNAME = "CTS_StartDate");

/// 有效结束日期
Property CTSEndDate As %Library.Date(XMLNAME = "CTS_EndDate");

/// 创建日期
Property CTSCreatDate As %Library.Date(XMLNAME = "CTS_CreatDate");

/// 创建时间
Property CTSCreatTime As %Library.Time(XMLNAME = "CTS_CreatTime");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
