/// 类名：web.DHCENS.STBLL.OPERATION.Model.OperationSchedule
/// 描述：手术排班申请信息Model
/// 编写者：WuXianPu
/// 编写日期：2012-10-31
Class web.DHCENS.STBLL.OPERATION.Model.OperationSchedule Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "OperationSchedule";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 病人ID
Property PatientID As %String(MAXLEN = 32767, XMLNAME = "PatientID");

/// 病案号
Property DocumentID As %String(MAXLEN = 32767, XMLNAME = "DocumentID");

/// 病人姓名
Property PatientName As %String(MAXLEN = 32767, XMLNAME = "PatientName");

/// 性别代码
Property SexCode As %String(MAXLEN = 32767, XMLNAME = "SexCode");

/// 性别描述
Property SexDesc As %String(MAXLEN = 32767, XMLNAME = "SexDesc");

/// 证件类型
Property CredentialType As %String(MAXLEN = 32767, XMLNAME = "CredentialNo");

/// 证件号
Property CredentialNo As %String(MAXLEN = 32767, XMLNAME = "CredentialNo");

/// 年龄
Property Age As %String(MAXLEN = 32767, XMLNAME = "Age");

/// 就诊类型代码
Property AdmTypeCode As %String(MAXLEN = 32767, XMLNAME = "AdmTypeCode");

/// 就诊类型描述
Property AdmTypeDesc As %String(MAXLEN = 32767, XMLNAME = "AdmTypeDesc");

/// 费别代码
Property FeeTypeCode As %String(MAXLEN = 32767, XMLNAME = "FeeTypeCode");

/// 费别描述
Property FeeTypeDesc As %String(MAXLEN = 32767, XMLNAME = "FeeTypeDesc");

/// 病人住院唯一标识
Property AdmNo As %String(MAXLEN = 32767, XMLNAME = "AdmNo");

/// 病人所在科室代码
Property DeptStayCode As %String(MAXLEN = 32767, XMLNAME = "DeptStayCode");

/// 病人所在科室名称
Property DeptStayDesc As %String(MAXLEN = 32767, XMLNAME = "DeptStayDesc");

/// 病人所在病房代码
Property WardStayCode As %String(MAXLEN = 32767, XMLNAME = "WardStayCode");

/// 病人所在病房名称
Property WardStayDesc As %String(MAXLEN = 32767, XMLNAME = "WardStayDesc");

/// 病人所在床号
Property BedNO As %String(MAXLEN = 32767, XMLNAME = "BedNO");

/// 手术名称代码
Property OperationNO As %String(MAXLEN = 32767, XMLNAME = "OperationNO");

/// 手术名称
Property Operation As %String(MAXLEN = 32767, XMLNAME = "Operation");

/// 手术申请号
Property ScheduleID As %String(MAXLEN = 32767, XMLNAME = "ScheduleID");

/// 手术日期及时间
Property ScheduledDateTime As %String(MAXLEN = 32767, XMLNAME = "ScheduledDateTime");

/// 手术室代码
Property OperatingRoomNo As %String(MAXLEN = 32767, XMLNAME = "OperatingRoomNo");

/// 手术室
Property OperatingRoom As %String(MAXLEN = 32767, XMLNAME = "OperatingRoom");

/// 手术台次
Property Sequence As %String(MAXLEN = 32767, XMLNAME = "Sequence");

/// 术前主要诊断代码
Property DiagBeforeOperationCode As %String(MAXLEN = 32767, XMLNAME = "DiagBeforeOperationCode");

/// 术前主要诊断描述
Property DiagBeforeOperationDesc As %String(MAXLEN = 32767, XMLNAME = "DiagBeforeOperationDesc");

/// 病情说明
Property PatientCondition As %String(MAXLEN = 32767, XMLNAME = "PatientCondition");

/// 手术等级编码
Property OperationScaleCode As %String(MAXLEN = 32767, XMLNAME = "OperationScaleCode");

/// 手术等级名称
Property OperationScaleDesc As %String(MAXLEN = 32767, XMLNAME = "OperationScaleDesc");

/// 急诊标志代码
Property EmergencyIndicatorCode As %String(MAXLEN = 32767, XMLNAME = "EmergencyIndicatorCode");

/// 急诊标志
Property EmergencyIndicator As %String(MAXLEN = 32767, XMLNAME = "EmergencyIndicator");

/// 隔离标志
Property IsolationIndicator As %String(MAXLEN = 32767, XMLNAME = "IsolationIndicator");

/// 手术科室代码
Property OperatingDeptCode As %String(MAXLEN = 32767, XMLNAME = "OperatingDeptCode");

/// 手术科室
Property OperatingDeptDesc As %String(MAXLEN = 32767, XMLNAME = "OperatingDeptDesc");

/// 手术者代码
Property SurgeonCode As %String(MAXLEN = 32767, XMLNAME = "SurgeonCode");

/// 手术者名称
Property SurgeonDesc As %String(MAXLEN = 32767, XMLNAME = "SurgeonDesc");

/// 第一手术助手代码
Property FirstAssistantCode As %String(MAXLEN = 32767, XMLNAME = "FirstAssistantCode");

/// 第一手术助手名称
Property FirstAssistantDesc As %String(MAXLEN = 32767, XMLNAME = "FirstAssistantDesc");

/// 第二手术助手代码
Property SecondAssistantCode As %String(MAXLEN = 32767, XMLNAME = "SecondAssistantCode");

/// 第二手术助手名称
Property SecondAssistantDesc As %String(MAXLEN = 32767, XMLNAME = "SecondAssistantDesc");

/// 第三手术助手代码
Property ThirdAssistantCode As %String(MAXLEN = 32767, XMLNAME = "ThirdAssistantCode");

/// 第三手术助手名称
Property ThirdAssistantDesc As %String(MAXLEN = 32767, XMLNAME = "ThirdAssistantDesc");

/// 第四手术助手代码
Property FourthAssistantCode As %String(MAXLEN = 32767, XMLNAME = "FourthAssistantCode");

/// 第四手术助手名称
Property FourthAssistantDesc As %String(MAXLEN = 32767, XMLNAME = "FourthAssistantDesc");

/// 备注
Property NotesOnOperation As %String(MAXLEN = 32767, XMLNAME = "NotesOnOperation");

/// 申请日期及时间
Property ReqDateTime As %String(MAXLEN = 32767, XMLNAME = "ReqDateTime");

/// 录入者代码
Property EnteredByCode As %String(MAXLEN = 32767, XMLNAME = "EnteredByCode");

/// 录入者名称
Property EnteredByDesc As %String(MAXLEN = 32767, XMLNAME = "EnteredByDesc");

/// 录入申请时间
Property EnteredByDateTime As %String(MAXLEN = 32767, XMLNAME = "EnteredByDateTime");

/// 手术状态
Property OperStatus As %String(MAXLEN = 32767, XMLNAME = "OperStatus");

/// 麻醉方式代码
Property AnesthesiaMethodCode As %String(MAXLEN = 32767, XMLNAME = "AnesthesiaMethodCode");

/// 麻醉方式名称
Property AnesthesiaMethodDesc As %String(MAXLEN = 32767, XMLNAME = "AnesthesiaMethodDesc");

/// 麻醉医生代码
Property AnesthesiaDoctorCode As %String(MAXLEN = 32767, XMLNAME = "AnesthesiaDoctorCode");

/// 麻醉医生名称
Property AnesthesiaDoctorDesc As %String(MAXLEN = 32767, XMLNAME = "AnesthesiaDoctorDesc");

/// 第二麻醉医生代码
Property SecondAnesthesiaDoctorCode As %String(MAXLEN = 32767, XMLNAME = "SecondAnesthesiaDoctorCode");

/// 第二麻醉医生名称
Property SecondAnesthesiaDoctorDesc As %String(MAXLEN = 32767, XMLNAME = "SecondAnesthesiaDoctorDesc");

/// 第三麻醉医生代码
Property ThirdAnesthesiaDoctorCode As %String(MAXLEN = 32767, XMLNAME = "ThirdAnesthesiaDoctorCode");

/// 第三麻醉医生名称
Property ThirdAnesthesiaDoctorDesc As %String(MAXLEN = 32767, XMLNAME = "ThirdAnesthesiaDoctorDesc");

/// 麻醉助手代码
Property AnesthesiaAssistantCode As %String(MAXLEN = 32767, XMLNAME = "AnesthesiaAssistantCoede");

/// 麻醉助手名称
Property AnesthesiaAssistantDesc As %String(MAXLEN = 32767, XMLNAME = "AnesthesiaAssistantDesc");

/// 麻醉助手代码(二)
Property SecondAnesthesiaAssistantCode As %String(MAXLEN = 32767, XMLNAME = "SecondAnesthesiaAssistantCode");

/// 麻醉助手名称(二)
Property SecondAnesthesiaAssistantDesc As %String(MAXLEN = 32767, XMLNAME = "SecondAnesthesiaAssistantDesc");

/// 麻醉助手代码(三)
Property ThirdAnesthesiaAssistantCode As %String(MAXLEN = 32767, XMLNAME = "ThirdAnesthesiaAssistantCode");

/// 麻醉助手名称(三)
Property ThirdAnesthesiaAssistantDesc As %String(MAXLEN = 32767, XMLNAME = "ThirdAnesthesiaAssistantDesc");

/// 麻醉助手代码(四)
Property FourthAnesthesiaAssistantCode As %String(MAXLEN = 32767, XMLNAME = "FourthAnesthesiaAssistantCode");

/// 麻醉助手名称(四)
Property FourthAnesthesiaAssistantDesc As %String(MAXLEN = 32767, XMLNAME = "FourthAnesthesiaAssistantDesc");

Property BloodTranDoctorCode As %String(MAXLEN = 32767, XMLNAME = "BloodTranDoctorCode");

Property BloodTranDoctorDesc As %String(MAXLEN = 32767, XMLNAME = "BloodTranDoctorDesc");

/// 第一供应护士代码
Property FirstOperationNurseCode As %String(MAXLEN = 32767, XMLNAME = "FirstOperationNurseCode");

/// 第一供应护士名称
Property FirstOperationNurseDesc As %String(MAXLEN = 32767, XMLNAME = "FirstOperationNurseDesc");

/// 第二供应护士代码
Property SecondOperationNurseCode As %String(MAXLEN = 32767, XMLNAME = "SecondOperationNurseCode");

/// 第二供应护士名称
Property SecondOperationNurseDesc As %String(MAXLEN = 32767, XMLNAME = "SecondOperationNurseDesc");

/// 第一台上护士代码
Property FirstSupplyNurseCode As %String(MAXLEN = 32767, XMLNAME = "FirstSupplyNurseCode");

/// 第一台上护士名称
Property FirstSupplyNurseDesc As %String(MAXLEN = 32767, XMLNAME = "FirstSupplyNurseDesc");

/// 第二台上护士代码
Property SecondSupplyNurseCode As %String(MAXLEN = 32767, XMLNAME = "SecondSupplyNurseCode");

/// 第二台上护士名称
Property SecondSupplyNurseDesc As %String(MAXLEN = 32767, XMLNAME = "SecondSupplyNurseDesc");

/// 第三台上护士代码
Property ThirdSupplyNurseCode As %String(MAXLEN = 32767, XMLNAME = "ThirdSupplyNurseCode");

/// 第三台上护士名称
Property ThirdSupplyNurseDesc As %String(MAXLEN = 32767, XMLNAME = "ThirdSupplyNurseDesc");

/// 手术部位
Property OperationPosition As %String(MAXLEN = 32767, XMLNAME = "OperationPosition");

}
