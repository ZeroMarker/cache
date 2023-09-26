Class web.DHCENS.STBLL.DICTNew.MODEL.CTBodyArea Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_BodyArea";

/// 代码
Property CTBACode As %Library.String(MAXLEN = 50, XMLNAME = "CTBA_Code");

/// 代码表类型
Property CTBACodesystemCode As %Library.String(MAXLEN = 100, XMLNAME = "CTBA_CodesystemCode");

/// 名称
Property CTBADesc As %Library.String(MAXLEN = 100, XMLNAME = "CTBA_Desc");

/// 备注
Property CTBARemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTBA_Remarks");

/// 状态（1启用0停用-1删除）
Property CTBAStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTBA_Status");

/// 最后更新日期
Property CTBAUpdateDate As %Library.Date(XMLNAME = "CTBA_UpdateDate");

/// 最后更新时间
Property CTBAUpdateTime As %Library.Time(XMLNAME = "CTBA_UpdateTime");

/// 最后更新人编码
Property CTBAUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTBA_UpdateUserCode");

/// 以下字段为2018.9新增,根据<主数据表结构说明V1.4.doc>
/// 原代码
Property CTBAOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTBA_OriginalCode");

/// 原描述
Property CTBAOriginalDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTBA_OriginalDesc");

/// 有效开始日期
Property CTBAStartDate As %Library.Date(XMLNAME = "CTBA_StartDate");

/// 有效结束日期
Property CTBAEndDate As %Library.Date(XMLNAME = "CTBA_EndDate");

/// 创建日期
Property CTBACreatDate As %Library.Date(XMLNAME = "CTBA_CreatDate");

/// 创建时间
Property CTHCreatTime As %Library.Time(XMLNAME = "CTH_CreatTime");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
