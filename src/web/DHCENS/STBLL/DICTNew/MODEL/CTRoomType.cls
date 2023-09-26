/// 房间类型
Class web.DHCENS.STBLL.DICTNew.MODEL.CTRoomType Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLNAME = "CT_RoomType";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 代码
Property CTRTCode As %Library.String(MAXLEN = 50, XMLNAME = "CTRT_Code");

/// 代码表类型
Property CTRTCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTRT_CodesystemCode");

/// 描述
Property CTRTDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTRT_Desc");

/// 备注
Property CTRTRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTRT_Remarks");

/// 最后更新人编码
Property CTRTUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTRT_UpdateUserCode");

/// 最后更新日期
Property CTRTUpdateDate As %Library.String(XMLNAME = "CTRT_UpdateDate");

/// 最后更新时间
Property CTRTUpdateTime As %Library.String(XMLNAME = "CTRT_UpdateTime");

/// 以下字段为2018.9新增,根据<主数据表结构说明V1.4.doc>
/// 创建日期
Property CTRTCreatDate As %Library.String(XMLNAME = "CTRT_CreatDate");

/// 创建时间
Property CTRTCreatTime As %Library.String(XMLNAME = "CTRT_CreatTime");

/// 原代码
Property CTRTOriginalCode As %Library.String(XMLNAME = "CTRT_OriginalCode");

/// 原描述
Property CTRTOriginalDesc As %Library.String(XMLNAME = "CTRT_OriginalDesc");

/// 有效开始日期
Property CTRTStartDate As %Library.String(XMLNAME = "CTRT_StartDate");

/// 有效结束日期
Property CTRTEndDate As %Library.String(XMLNAME = "CTRT_EndDate");

/// 医院编号
Property CTRTHosCode As %Library.String(MAXLEN = 10, XMLNAME = "CTRT_HosCode");

/// 状态（1启用0停用-1删除）
Property CTRTStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTRT_Status");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
