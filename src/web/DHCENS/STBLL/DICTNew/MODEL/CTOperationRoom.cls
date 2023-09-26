/// 手术间
Class web.DHCENS.STBLL.DICTNew.MODEL.CTOperationRoom Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLNAME = "CT_OperationRoom";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 代码
Property CTORCode As %Library.String(MAXLEN = 50, XMLNAME = "CTOR_Code");

/// 代码表类型
Property CTORCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTOR_CodesystemCode");

/// 描述
Property CTORDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTOR_Desc");

/// 备注
Property CTORRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTOR_Remarks");

/// 最后更新人编码
Property CTORUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTOR_UpdateUserCode");

/// 最后更新日期
Property CTORUpdateDate As %Library.String(XMLNAME = "CTOR_UpdateDate");

/// 最后更新时间
Property CTORUpdateTime As %Library.String(XMLNAME = "CTOR_UpdateTime");

/// 以下字段为2018.9新增,根据<主数据表结构说明V1.4.doc>
/// 创建日期
Property CTORCreatDate As %Library.String(XMLNAME = "CTOR_CreatDate");

/// 创建时间
Property CTORCreatTime As %Library.String(XMLNAME = "CTOR_CreatTime");

/// 原代码
Property CTOROriginalCode As %Library.String(XMLNAME = "CTOR_OriginalCode");

/// 原描述
Property CTOROriginalDesc As %Library.String(XMLNAME = "CTOR_OriginalDesc");

/// 有效开始日期
Property CTORStartDate As %Library.String(XMLNAME = "CTOR_StartDate");

/// 有效结束日期
Property CTOREndDate As %Library.String(XMLNAME = "CTOR_EndDate");

/// 医院编号
Property CTORHosCode As %Library.String(MAXLEN = 50, XMLNAME = "CTOR_HosCode");

/// 状态（1启用0停用-1删除）
Property CTORStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTOR_Status");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
