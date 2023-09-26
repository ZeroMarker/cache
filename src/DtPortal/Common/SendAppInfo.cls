Class DtPortal.Common.SendAppInfo Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "Request";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 姓名
Property PatName As %String(MAXLEN = 32767, XMLNAME = "PatName");

/// 患者性别
Property Sex As %String(MAXLEN = 32767, XMLNAME = "Sex");

/// 身份证
Property CredNo As %String(MAXLEN = 32767, XMLNAME = "CredNo");

/// 手机号
Property Tel As %String(MAXLEN = 32767, XMLNAME = "Tel");

/// 地址
Property Address As %String(MAXLEN = 32767, XMLNAME = "Address");

/// 医生
Property DocCode As %String(MAXLEN = 32767, XMLNAME = "DocCode");

/// 开始时间
Property StartDate As %String(MAXLEN = 32767, XMLNAME = "StartDate");

/// 结束时间
Property EndDate As %String(MAXLEN = 32767, XMLNAME = "EndDate");

/// 业务类型
Property Type As %String(MAXLEN = 32767, XMLNAME = "Type");

/// 预约id
Property RBAppId As %String(MAXLEN = 32767, XMLNAME = "RBAppId");

/// 标题
Property Info As %String(MAXLEN = 32767, XMLNAME = "Info");

/// 是否全天事件
Property AllDay As %String(MAXLEN = 32767, XMLNAME = "AllDay");

/// 状态 (1:新增；2:删除)
Property State As %String(MAXLEN = 32767, XMLNAME = "State");

}
