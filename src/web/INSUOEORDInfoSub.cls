Class web.INSUOEORDInfoSub Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "Details";

//此对象节点名称,可根据实际实际情况修改

//注意：如果有XMLNAME属性，生成XML或XML转为本对象时以XMLNAME名称为准,

//医嘱明细ID

Property OEExecDr As %String(CONTENT = "执行记录ID", XMLNAME = "OEExeRowid", XMLPROJECTION = "ELEMENT");

//医嘱日期

Property OEExecDATE As %String(CONTENT = "医嘱执行日期");

//医嘱时间

Property OEExecTIME As %String(CONTENT = "医嘱执行时间");

//执行医嘱人

Property OEExecDoctor As %String(CONTENT = "执行医嘱人姓名");

//执行医嘱人Code

Property OEExecDoctorCode As %String(CONTENT = "执行医嘱人编码");

Property OEExecNOTE As %String(CONTENT = "备注信息");

//收费项目列表

Property OEORITar As list Of web.INSUOEORDTarInfoSub;

}
