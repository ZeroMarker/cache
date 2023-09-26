Class web.INSULISReport Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "LISReport";

//此对象节点名称,可根据实际实际情况修改

//注意：如果有XMLNAME属性，生成XML或XML转为本对象时以XMLNAME名称为准,

//明细表ID

//Property MRCRowid As %String(CONTENT = "明细表ID", XMLNAME = "Rowid", XMLPROJECTION = "ELEMENT");

//LISService.entity.ReportData

//Property ReportData As LISService.entity.ReportData;

//-------------------------------------------------报告内容------------------------//

/// 检验号
Property labno As %String(CONTENT = "检验号");

/// 报告ID
Property TSRowId As %String(CONTENT = "报告ID");

/// 报告TS
Property TSCode As %String(CONTENT = "标本代码");

/// 登记号
Property RegisterNo As %String(CONTENT = "登记号");

/// 姓名
Property PatientName As %String(CONTENT = "姓名");

/// 性别
Property Speceis As %String(CONTENT = "性别");

/// 年龄
Property Age As %String(CONTENT = "年龄");

/// 出生日期
Property DOB As %String(CONTENT = "出生日期");

/// 诊断
Property Diag As %String(CONTENT = "诊断");

/// 申请科室
Property Location As %String(CONTENT = "申请科室");

/// 申请医生代码
Property DoctorCode As %String(CONTENT = "申请医生代码");

/// 申请医生
Property Doctor As %String(CONTENT = "申请医生");

/// 申请时间
Property RequestDT As %String(CONTENT = "申请时间");

/// 申请病区
Property Ward As %String(CONTENT = "申请病区");

/// 床号
Property Bed As %String(CONTENT = "床号");

/// 医嘱明细ID
Property OEITEMID As %String(CONTENT = "医嘱明细ID");

/// 医嘱名称
Property TSName As %String(CONTENT = "医嘱名称");

/// 收费项
Property TarDetails As list Of web.INSUUploadTarInfo;

/// 标本类型代码
Property specode As %String(CONTENT = "标本类型代码");

/// 标本类型
Property Specimen As %String(CONTENT = "标本类型");

/// 采样时间
Property CollectionDT As %String(CONTENT = "采样时间");

/// 接收时间
Property ReceiveDT As %String(CONTENT = "接收时间");

/// 接收人code
Property ReceiveCode As %String(CONTENT = "接收人代码");

/// 接收人
Property ReceiveUser As %String(CONTENT = "接收人");

/// 初审时间
Property EntryDT As %String(CONTENT = "初审时间");

/// 初审人Code
Property EntryUserCode As %String(CONTENT = "初审人代码");

/// 初审人
Property EntryUser As %String(CONTENT = "初审人");

/// 报告时间/打印日期
Property AuthDT As %String(CONTENT = "报告时间");

/// 报告人CODE
Property AuthUserCode As %String(CONTENT = "报告人代码");

/// 报告人
Property AuthUser As %String(CONTENT = "报告人");

/// 检测仪器
Property Machine As %String(CONTENT = "检测仪器");

/// 流水号
Property Episode As %String(CONTENT = "流水号");

/// 检测科室电话
Property DepartPhone As %String(CONTENT = "检测科室电话");

/// 结果状态
Property Status As %String(CONTENT = "结果状态");

/// 就诊ROWID
Property AdmID As %String(CONTENT = "就诊ROWID");

/// 就诊号
Property AdmNo As %String(CONTENT = "就诊号");

/// 病人ROWID(病人基本信息表ID)
Property PatRowID As %String(CONTENT = "病人ROWID");

/// 检测结果,也叫检验结果,
Property ResultDetails As list Of web.INSULISReportResult;

/// 细菌结果(包括药敏)
Property ResultDetailsGerm As list Of web.INSULISReportResultGerm;

/// 返回代码
Property ReturnValue As %String(CONTENT = "返回代码");

//---------------------------------------------------------------------------------------------------//

}
