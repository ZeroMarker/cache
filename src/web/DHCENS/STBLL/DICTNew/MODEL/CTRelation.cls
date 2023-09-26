Class web.DHCENS.STBLL.DICTNew.MODEL.CTRelation Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_Relation";

/// 代码
Property CTRCode As %Library.String(COLLATION = "EXACT", MAXLEN = 50, XMLNAME = "CTR_Code");

/// 代码表类型 CT_CodeSystem.CTCSCode
Property CTRCodesystemCode As %Library.String(COLLATION = "EXACT", MAXLEN = 50, XMLNAME = "CTR_CodesystemCode");

/// 描述
Property CTRDesc As %Library.String(COLLATION = "EXACT", MAXLEN = 100, XMLNAME = "CTR_Desc");

/// 备注
Property CTRRemarks As %Library.String(COLLATION = "EXACT", MAXLEN = 100, XMLNAME = "CTR_Remarks");

/// 状态（1启用,0停用,-1删除）
Property CTRStatus As %Library.String(COLLATION = "EXACT", MAXLEN = 2, XMLNAME = "CTR_Status");

/// 最后更新日期
Property CTRUpdateDate As %Library.Date(XMLNAME = "CTR_UpdateDate");

/// 最后更新时间
Property CTRUpdateTime As %Library.Time(XMLNAME = "CTR_UpdateTime");

/// 最后更新人编码
Property CTRUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTR_UpdateUserCode");

/// 以下字段为2018.9新增,根据<主数据表结构说明V1.4.doc>
/// 原代码
Property CTROriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTR_OriginalCode");

/// 原描述
Property CTROriginalDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTR_OriginalDesc");

/// 有效开始日期
Property CTRStartDate As %Library.Date(XMLNAME = "CTR_StartDate");

/// 有效结束日期
Property CTREndDate As %Library.Date(XMLNAME = "CTR_EndDate");

/// 创建日期
Property CTRCreatDate As %Library.Date(XMLNAME = "CTR_CreatDate");

/// 创建时间
Property CTRCreatTime As %Library.Time(XMLNAME = "CTR_CreatTime");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
