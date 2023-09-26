Class web.INSUOEORDInfo Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "root";

// 此对象节点名称,可根据实际实际情况修改

// 注意：如果有XMLNAME属性，生成XML或XML转为本对象时以XMLNAME名称为准,

// 医嘱明细ID

Property OEORIRowid As %String(CONTENT = "医嘱明细表ID", XMLNAME = "Rowid", XMLPROJECTION = "ELEMENT");

// PBO_RowId 

Property PBORowId As %String(CONTENT = "PBORowId");

// 医嘱类型(长期、临时...)

Property OEORIType As %String(CONTENT = "医嘱类型");

// 医嘱类别(西药、中药...)

Property OEORICatType As %String(CONTENT = "医嘱费用类别");

// 医嘱子分类代码(0001：西药、0002：中药...)

Property OEORIArcItmCatCode As %String(CONTENT = "医嘱子分类");

// 医嘱代码

Property OEORICode As %String(CONTENT = "医嘱代码");

// 医嘱名称

Property OEORIDesc As %String(CONTENT = "医嘱名称");

// 医嘱日期

Property OEORIDATE As %String(CONTENT = "医嘱日期");

// 医嘱时间

Property OEORITIME As %String(CONTENT = "医嘱时间");

// 医嘱停止日期

Property OEORIStopDATE As %String(CONTENT = "医嘱停止日期");

// 医嘱停止时间

Property OEORIStopTIME As %String(CONTENT = "医嘱停止时间");

// 医嘱停止医生-Dsh 20160516

Property OEORIStopDoctor As %String(CONTENT = "医嘱停止医生姓名");

// 医嘱停止医生-Dsh 20160516

Property OEORIStopDoctorCode As %String(CONTENT = "医嘱停止医生编码");

// 开医嘱医生姓名

Property OEORIDoctor As %String(CONTENT = "开医嘱医生姓名");

// 开医嘱医生编码

Property OEORIDoctorCode As %String(CONTENT = "开医嘱医生编码");

// 开医嘱科室

Property OEORIOrdDeptCode As %String(CONTENT = "开医嘱科室代码");

// 开医嘱科室

Property OEORIOrdDeptDesc As %String(CONTENT = "开医嘱科室名称");

// 总剂量1.如果是非药品，记录的是总数量，2.如果是药品，记录的剂量*频次*疗程量

Property PhQtyOrd As %String(CONTENT = "总剂量");

// 剂量

Property DoseQty As %String(CONTENT = "剂量");

// 剂量单位

Property DoseQtyUom As %String(CONTENT = "剂量单位");

// 用法

Property Instr As %String(CONTENT = "用法代码");

// 用法

Property InstrDesc As %String(CONTENT = "用法描述");

// 疗程

Property Durat As %String(CONTENT = "疗程");

// 频率

Property PHFreq As %String(CONTENT = "频率");

// 规格

Property GG As %String(CONTENT = "规格");

// 包装规格

Property BZGG As %String(CONTENT = "包装规格");

// 备注信息

Property NOTE As %String(CONTENT = "备注信息");

// 执行记录列表

Property OEORIExe As list Of web.INSUOEORDInfoSub;

// 收费项目列表,移到执行记录列表中 

// Property OEORITar As list Of web.INSUOEORDTarInfoSub;

// 扩展字段

Property XString1 As %String(CONTENT = "疾病编码");

// 扩展字段

Property XString2 As %String(CONTENT = "扩展字段");

// 扩展字段

Property XString3 As %String(CONTENT = "扩展字段");

// 扩展字段

Property XString4 As %String(CONTENT = "扩展字段");

// 扩展字段

Property XString5 As %String(CONTENT = "扩展字段");

}
