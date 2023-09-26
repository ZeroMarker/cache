Class CIS.AN.DTO.ENS.Message.Content Extends (CIS.AN.DTO.Abstract.Model, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLNAME = "﻿MsgSendRt";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 消息内容，不可为空
Property Context As %String(MAXLEN = 500);

/// 消息动作代码，不可为空
Property ActionTypeCode As %String;

/// 就诊号，可以为空
Property PAADMVisitNumber As %String;

/// 发送消息的用户ID，不可为空，如果ID为空，可以传入姓名
Property FromUserRowId As %String;

/// 医嘱ID，可以为空
Property OEORIOrderItemID As %String;

/// 接收消息的用户ID，可以为空，为空时走配置；可以为用户ID字符串，以^分隔
Property ToUserRowId As %String;

/// 其他业务相关对象，可以为空，Json格式字符串
Property OtherInfoJson As %String(MAXLEN = 200);

/// 接收消息的科室ID，可以为空
Property ToLocRowId As %String;

/// 有效天数，可以为空
Property EffectiveDays As %String;

/// 消息创建科室，可以为空
Property CreateLoc As %String;

}
