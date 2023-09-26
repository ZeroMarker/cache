Class web.DHCENS.STBLL.DICTNew.MODEL.CTCareProvPosition Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

/// 代码
Property CTCPPCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCPP_Code");

/// 代码表类型 
Property CTCPPCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCPP_CodesystemCode");

/// 描述
Property CTCPPDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTCPP_Desc");

/// 备注
Property CTCPPRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTCPP_Remarks");

/// 状态（1启用,0停用,-1删除）
Property CTCPPStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTCPP_Status");

/// 最后更新日期
Property CTCPPUpdateDate As %Library.Date(XMLNAME = "CTCPP_UpdateDate");

/// 最后更新时间
Property CTCPPUpdateTime As %Library.Time(XMLNAME = "CTCPP_UpdateTime");

/// 最后更新人编码
Property CTCPPUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCPP_UpdateUserCode");

/// 以下字段为2018.9新增,根据<主数据表结构说明V1.4.doc>
/// 创建日期
Property CTCPPCreatDate As %Library.Date(XMLNAME = "CTCPP_CreatDate");

/// 创建时间
Property CTCPPCreatTime As %Library.Time(XMLNAME = "CTCPP_CreatTime");

/// 原代码
Property CTCPPOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCPP_OriginalCode");

/// 原描述
Property CTCPPOriginalDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTCPP_OriginalDesc");

/// 有效开始日期
Property CTCPPStartDate As %Library.String(XMLNAME = "CTCPP_StartDate");

/// 有效结束日期
Property CTCPPEndDate As %Library.String(XMLNAME = "CTCPP_EndDate");

/// 医院代码
Property CTCPPHosCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCPP_HosCode");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "CT_CareProvPosition";

}
