Class web.DHCENS.STBLL.DICTNew.MODEL.CTNation Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

/// 代码
Property CTNCode As %Library.String(MAXLEN = 50, XMLNAME = "CTN_Code");

/// 代码表类型
Property CTNCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTN_CodesystemCode");

/// 描述
Property CTNDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTN_Desc");

/// 备注
Property CTNRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTN_Remarks");

/// 状态（1启用,0停用,-1删除）
Property CTNStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTN_Status");

/// 最后更新日期
Property CTNUpdateDate As %Library.Date(XMLNAME = "CTN_UpdateDate");

/// 最后更新时间
Property CTNUpdateTime As %Library.Time(XMLNAME = "CTN_UpdateTime");

/// 最后更新人编码
Property CTNUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTN_UpdateUserCode");

/// 以下字段为2018.9新增,根据<主数据表结构说明V1.4.doc>
/// 原代码
Property CTNOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTN_OriginalCode");

/// 原描述
Property CTNOriginalDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTN_OriginalDesc");

/// 有效开始日期
Property CTNStartDate As %Library.Date(XMLNAME = "CTN_StartDate");

/// 有效结束日期
Property CTNEndDate As %Library.Date(XMLNAME = "CTN_EndDate");

/// 创建日期
Property CTNCreatDate As %Library.Date(XMLNAME = "CTN_CreatDate");

/// 创建时间
Property CTNCreatTime As %Library.Time(XMLNAME = "CTN_CreatTime");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "CT_Nation";

}
