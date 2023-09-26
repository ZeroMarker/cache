/// 安全组字典表
Class web.DHCENS.STBLL.DICTNew.MODEL.CTSecurityGroup Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_SecurityGroup";

/// 代码
Property CTSGCode As %Library.String(MAXLEN = 50, XMLNAME = "CTSG_Code");

/// 代码表类型
Property CTSGCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTSG_CodesystemCode");

/// 描述
Property CTSGDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTSG_Desc");

/// 备注
Property CTSGRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTSG_Remarks");

/// 最后更新日期
Property CTSGUpdateDate As %Library.Date(XMLNAME = "CTSG_UpdateDate");

/// 最后更新时间
Property CTSGUpdateTime As %Library.Time(XMLNAME = "CTSG_UpdateTime");

/// 最后更新人编码
Property CTSGUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTSG_UpdateUserCode");

/// 创建日期
Property CTSGCreatDate As %Library.Date(XMLNAME = "CTSG_CreatDate");

/// 创建时间
Property CTSGCreatTime As %Library.Time(XMLNAME = "CTSG_CreatTime");

/// 原代码
Property CTSGOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTSG_OriginalCode");

/// 原描述
Property CTSGOriginalDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTSG_OriginalDesc");

/// 有效开始日期
Property CTSGStartDate As %Library.Date(XMLNAME = "CTSG_StartDate");

/// 有效结束日期
Property CTSGEndDate As %Library.Date(XMLNAME = "CTSG_EndDate");

/// 医院所属院区rowid
Property CTSGHosCode As %Library.String(MAXLEN = 50, XMLNAME = "CTSG_HosCode");

/// 状态
Property CTSGStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTSG_Status");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

/// 上级安全组rowid
Property CTSGParentCode As %Library.String(MAXLEN = 10, XMLNAME = "CTSG_ParentCode");

}
