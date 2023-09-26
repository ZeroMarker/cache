Class web.DHCEkg.Interface.CLEAR.Dict.GetReport Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "Request";

/// 卡号
Property CardNo As %String;

/// 登记号
Property PatientID As %String;

/// 姓名
Property Name As %String;

/// 检查号（多个用英文逗号分隔）
Property StaccnumNo As %String;

/// 设备类型（CT、MR、US等）
Property ModalityType As %String;

/// 开始日期（YYYY-mm-dd）
Property StartTime As %String;

/// 结束日期（YYYY-mm-dd）
Property EndTime As %String;

/// 已打印报告是否显示（Y/N）
Property PrintedDisplay As %String;

/// 执行科室名称
Property ExecDept As %String;

}
