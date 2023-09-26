Class web.DHCENS.STBLL.DICTNew.MODEL.CTFreq Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_Freq";

/// 代码
Property CTFCode As %Library.String(MAXLEN = 50, XMLNAME = "CTF_Code");

/// 描述
Property CTFDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTF_Desc");

/// 原代码
Property CTFOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTF_OriginalCode");

/// 原描述
Property CTFOriginalDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTF_OriginalDesc");

/// 代码表类型
Property CTFCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTF_CodesystemCode");

/// 状态（1启用0停用-1删除）
Property CTFStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTF_Status");

/// 最后更新人编码
Property CTFUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTF_UpdateUserCode");

/// 最后更新日期
Property CTFUpdateDate As %Library.Date(XMLNAME = "CTF_UpdateDate");

/// 有效开始日期
Property CTFStartDate As %Library.Date(XMLNAME = "CTF_StartDate");

/// 最后更新时间
Property CTFUpdateTime As %Library.Time(XMLNAME = "CTF_UpdateTime");

/// 备注
Property CTFRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTF_Remarks");

/// 系数
Property CTFFactor As %Library.String(MAXLEN = 100, XMLNAME = "CTF_Factor");

/// 英文描述
Property CTFEngDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTF_EngDesc");

/// 创建日期
Property CTFCreatDate As %Library.Date(XMLNAME = "CTF_CreatDate");

/// 创建时间
Property CTFCreatTime As %Library.Time(XMLNAME = "CTF_CreatTime");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
