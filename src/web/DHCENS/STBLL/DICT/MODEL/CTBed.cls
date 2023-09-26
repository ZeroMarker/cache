Class web.DHCENS.STBLL.DICT.MODEL.CTBed Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_Bed";

/// 代码
Property CTBCode As %Library.String(MAXLEN = 20, XMLNAME = "CTB_Code");

/// 描述
Property CTBDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTB_Desc");

/// 代码表类型
Property CTBCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTB_CodesystemCode");

/// 状态（1启用0停用-1删除）
Property CTBStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTB_Status");

/// 所属病区
Property CTBWardCode As %Library.String(MAXLEN = 50, XMLNAME = "CTB_WardCode");

/// 房间号
Property CTBRoomCode As %Library.String(MAXLEN = 50, XMLNAME = "CTB_RoomCode");

/// 床位类型
Property CTBBedType As %Library.String(MAXLEN = 10, XMLNAME = "CTB_BedType");

/// 最后更新人编码
Property CTBUpdateUserCode As %Library.String(MAXLEN = 10, XMLNAME = "CTB_UpdateUserCode");

/// 最后更新日期
Property CTBUpdateDate As %Library.Date(XMLNAME = "CTB_UpdateDate");

/// 最后更新时间
Property CTBUpdateTime As %Library.Time(XMLNAME = "CTB_UpdateTime");

/// 备注
Property CTBRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTB_Remarks");

/// 医院编号
Property CTBHosCode As %Library.String(MAXLEN = 10, XMLNAME = "CTB_HosCode");

}
