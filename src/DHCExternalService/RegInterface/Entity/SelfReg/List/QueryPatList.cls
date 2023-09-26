Class DHCExternalService.RegInterface.Entity.SelfReg.List.QueryPatList Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "QueList";

/// 诊区名称
Property CallArea As %String(TRUNCATE = 1, XMLNAME = "CallArea");

/// 诊区位置
Property CallAreaAddress As %String(TRUNCATE = 1, XMLNAME = "CallAreaAddress");

/// 诊间名称
/// Property CallRoom As %String(TRUNCATE = 1, XMLNAME = "CallRoom");
/// 呼叫计算机IP地址
/// Property IPaddress As %String(TRUNCATE = 1, XMLNAME = "IPaddress");
/// 号别级别
Property DoctorTitle As %String(TRUNCATE = 1, XMLNAME = "DoctorTitle");

/// 号别名称
Property DoctorCallName As %String(TRUNCATE = 1, XMLNAME = "DoctorCallName");

/// 科室名称
Property DeptName As %String(TRUNCATE = 1, XMLNAME = "DeptName");

/// 科室位置
Property DeptAddress As %String(TRUNCATE = 1, XMLNAME = "DeptAddress");

/// 呼叫序号
Property CallNo As %String(TRUNCATE = 1, XMLNAME = "CallNo");

/// 就诊序号
Property WaitCallNo As %String(TRUNCATE = 1, XMLNAME = "WaitCallNo");

/// 前边等候人数
Property QueueWaitNum As %String(TRUNCATE = 1, XMLNAME = "QueueWaitNum");

/// 就诊状态
Property QueueWaitStatus As %String(TRUNCATE = 1, XMLNAME = "QueueWaitStatus");

Property WaitPAPMIName As %String(TRUNCATE = 1, XMLNAME = "WaitPAPMIName");

Property Remark As %String(TRUNCATE = 1, XMLNAME = "Remark");

Property CurrentCallNo As %String(TRUNCATE = 1, XMLNAME = "CurrentCallNo");

Property ScheduleItemCode As %String(TRUNCATE = 1, XMLNAME = "ScheduleItemCode");

Property TimeRange As %String(TRUNCATE = 1, XMLNAME = "TimeRange");

///   Property PatentListS As list Of DHCExternalService.RegInterface.Entity.SelfReg.List.PatList(XMLITEMNAME = "PatentList", XMLNAME = "PatentLists", XMLPROJECTION = "COLLECTION");

}
