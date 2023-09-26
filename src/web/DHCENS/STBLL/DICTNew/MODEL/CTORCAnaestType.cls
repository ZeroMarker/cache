Class web.DHCENS.STBLL.DICTNew.MODEL.CTORCAnaestType Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_ORCAnaestType1";

/// 时间戳日期
Property UpdateDate As %Library.Date [ InitialExpression = {$P($H,",",1)}, Required, SqlColumnNumber = 2, SqlFieldName = UpdateDate ];

/// 时间戳时间
Property UpdateTime As %Library.Time [ InitialExpression = {$P($H,",",2)}, Required, SqlColumnNumber = 3, SqlFieldName = UpdateTime ];

/// 代码
Property CTORCATCode As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ Required, SqlColumnNumber = 5, SqlFieldName = CTORCAT_Code ];

/// 代码表类型
Property CTORCATCodesystemCode As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ Required, SqlColumnNumber = 6, SqlFieldName = CTORCAT_CodesystemCode ];

/// 描述
Property CTORCATDesc As %Library.String(COLLATION = "EXACT", MAXLEN = 128) [ Required, SqlColumnNumber = 7, SqlFieldName = CTORCAT_Desc ];

/// 备注
Property CTORCATRemarks As %Library.String(COLLATION = "EXACT", MAXLEN = 100) [ SqlColumnNumber = 8, SqlFieldName = CTORCAT_Remarks ];

/// 最后更新日期
Property CTORCATUpdateDate As %Library.Date [ SqlColumnNumber = 9, SqlFieldName = CTORCAT_UpdateDate ];

/// 最后更新时间
Property CTORCATUpdateTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = CTORCAT_UpdateTime ];

/// 最后更新人编码
Property CTORCATUpdateUserCode As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 11, SqlFieldName = CTORCAT_UpdateUserCode ];

/// 创建日期
Property CTORCATCreatDate As %Library.Date [ SqlColumnNumber = 12, SqlFieldName = CTORCAT_CreatDate ];

/// 创建时间
Property CTORCATCreatTime As %Library.Time [ SqlColumnNumber = 13, SqlFieldName = CTORCAT_CreatTime ];

/// 原代码
Property CTORCATOriginalCode As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 14, SqlFieldName = CTORCAT_OriginalCode ];

/// 原描述
Property CTORCATOriginalDesc As %Library.String(COLLATION = "EXACT", MAXLEN = 128) [ SqlColumnNumber = 15, SqlFieldName = CTORCAT_OriginalDesc ];

/// 有效开始日期
Property CTORCATStartDate As %Library.Date [ SqlColumnNumber = 16, SqlFieldName = CTORCAT_StartDate ];

/// 有效结束日期
Property CTORCATEndDate As %Library.Date [ SqlColumnNumber = 17, SqlFieldName = CTORCAT_EndDate ];

/// 医院代码
Property CTORCATHosCode As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 18, SqlFieldName = CTORCAT_HosCode ];

/// 状态
Property CTORCATStatus As %Library.String(COLLATION = "EXACT", DISPLAYLIST = ",启用,停用,删除", MAXLEN = 2, TRUNCATE = 1, VALUELIST = ",1,0,-1") [ Required, SqlColumnNumber = 19, SqlFieldName = CTORCAT_Status ];

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
