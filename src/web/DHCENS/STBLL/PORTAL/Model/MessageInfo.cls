Class web.DHCENS.STBLL.PORTAL.Model.MessageInfo Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "Request";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 就诊id
Property EpisodeID As %String(MAXLEN = 32767, XMLNAME = "EpisodeID");

/// 病区id
Property WardID As %String(MAXLEN = 32767, XMLNAME = "WardID");

/// 科室id
Property DepID As %String(MAXLEN = 32767, XMLNAME = "DepID");

/// 主管医生
Property AttendDoc As %String(MAXLEN = 32767, XMLNAME = "AttendDoc");

/// 主管护士
Property NurseCode As %String(MAXLEN = 32767, XMLNAME = "NurseCode");

/// 申请医生
Property ApplyDoc As %String(MAXLEN = 32767, XMLNAME = "ApplyDoc");

/// 业务id
Property PKID As %String(MAXLEN = 32767, XMLNAME = "PKID");

/// 业务类型
Property Type As %String(MAXLEN = 32767, XMLNAME = "Type");

/// 信息内容
Property Info As %String(MAXLEN = 32767, XMLNAME = "Info");

/// 创建时间
Property CreateTime As %String(MAXLEN = 32767, XMLNAME = "CreateTime");

/// 更新时间
Property UpdateTime As %String(MAXLEN = 32767, XMLNAME = "UpdateTime");

/// 状态 (1:新增；2:删除)
Property State As %String(MAXLEN = 32767, XMLNAME = "State");

/// 进程号
Property ProcessID As %String(MAXLEN = 32767, XMLNAME = "ProcessID");

}
