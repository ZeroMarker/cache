Class DHCENS.LIS.Model.ResultMsg Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

/// 检验号
Property LabNo As %String(MAXLEN = 32767);

/// 项目代码
Property TestCode As %String(MAXLEN = 32767);

/// 项目名称
Property TestName As %String(MAXLEN = 32767);

/// 缩写
Property TestEngName As %String(MAXLEN = 32767);

/// 结果
Property Result As %String(MAXLEN = 32767);

/// 单位
Property Units As %String(MAXLEN = 32767);

/// 备注
Property Notes As %String(MAXLEN = 32767);

/// 结果异常标示
Property ResultFlag As %String(MAXLEN = 32767);

/// 范围
Property Ranges As %String(MAXLEN = 32767);

/// 显示顺序
Property Sequence As %String(MAXLEN = 32767);

/// 细菌标志
Property MICFlag As %String(MAXLEN = 32767);

/// 细菌名称
Property MICName As %String(MAXLEN = 32767);

/// 危急值说明
Property WarnDesc As %String(MAXLEN = 32767);

Property OrgResultMsgs As list Of DHCENS.LIS.Model.OrgResultMsg;

}
