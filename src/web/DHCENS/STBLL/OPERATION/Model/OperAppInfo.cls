Class web.DHCENS.STBLL.OPERATION.Model.OperAppInfo Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "OperationArrangeRt";

/// 患者主索引
Property PATPatientID As %Library.String(MAXLEN = 30, XMLNAME = "PATPatientID");

/// 就诊号码
Property PAADMVisitNumber As %Library.String(MAXLEN = 30, XMLNAME = "PAADMVisitNumber");

/// 手术申请单号
Property SCHEDULEID As %Library.String(MAXLEN = 20, XMLNAME = "SCHEDULE_ID");

Property OPERATIONS As list Of web.DHCENS.STBLL.OPERATION.Model.OperDetail(XMLNAME = "OPERATIONS", XMLPROJECTION = "ELEMENT");

/// 病人所在科室的科室代码
Property DEPTSTAYED As %Library.String(MAXLEN = 30, XMLNAME = "DEPT_STAYED");

/// 手术申请时所在床号
Property BEDNO As %Library.String(MAXLEN = 30, XMLNAME = "BED_NO");

/// 预约进行该次手术的日期及时间
Property SCHEDULEDDATETIME As %Library.String(MAXLEN = 30, XMLNAME = "SCHEDULED_DATE_TIME");

/// 手术室科室代码
Property OPERATINGROOM As %Library.String(MAXLEN = 30, XMLNAME = "OPERATING_ROOM");

/// 手术间号
Property OPERATINGROOMNO As %Library.String(MAXLEN = 30, XMLNAME = "OPERATING_ROOM_NO");

/// 手术台次
Property SEQUENCE As %Library.String(MAXLEN = 30, XMLNAME = "SEQUENCE");

/// 诊断描述
Property DIAGBEFOREOPERATION As %Library.String(MAXLEN = 100, XMLNAME = "DIAG_BEFORE_OPERATION");

/// 对病人体征、病情等进一步说明
Property PATIENTCONDITION As %Library.String(MAXLEN = 200, XMLNAME = "PATIENT_CONDITION");

/// 指一次手术的综合等级
Property OPERATIONSCALE As %Library.String(MAXLEN = 2, XMLNAME = "OPERATION_SCALE");

/// 紧急状态代码
Property EMERGENCYINDICATOR As %Library.String(MAXLEN = 8, XMLNAME = "EMERGENCY_INDICATOR");

/// 手术是否需要隔离
Property ISOLATIONINDICATOR As %Library.String(MAXLEN = 8, XMLNAME = "ISOLATION_INDICATOR");

/// 实施手术的医生所在的科室代码
Property OPERATINGDEPT As %Library.String(MAXLEN = 30, XMLNAME = "OPERATING_DEPT");

/// 手术医师工号
Property SURGEON As %Library.String(MAXLEN = 30, XMLNAME = "SURGEON");

/// 第一手术助手工号
Property FIRSTASSISTANT As %Library.String(MAXLEN = 30, XMLNAME = "FIRST_ASSISTANT");

/// 第二手术助手工号
Property SECONDASSISTANT As %Library.String(MAXLEN = 30, XMLNAME = "SECOND_ASSISTANT");

/// 第三手术助手工号
Property THIRDASSISTANT As %Library.String(MAXLEN = 30, XMLNAME = "THIRD_ASSISTANT");

/// 第四手术助手工号
Property FOURTHASSISTANT As %Library.String(MAXLEN = 30, XMLNAME = "FOURTH_ASSISTANT");

/// 麻醉方法：使用规范汉字名称
Property ANESTHESIAMETHOD As %Library.String(MAXLEN = 100, XMLNAME = "ANESTHESIA_METHOD");

/// 麻醉医师工号 
Property ANESTHESIADOCTOR As %Library.String(MAXLEN = 30, XMLNAME = "ANESTHESIA_DOCTOR");

/// 麻醉医师工号2
Property SECONDANESTHESIADOCTOR As %Library.String(MAXLEN = 30, XMLNAME = "SECOND_ANESTHESIA_DOCTOR");

/// 麻醉医师工号3 
Property THIRDANESTHESIADOCTOR As %Library.String(MAXLEN = 30, XMLNAME = "THIRD_ANESTHESIA_DOCTOR");

/// 麻醉助手1
Property ANESTHESIAASSISTANT As %Library.String(MAXLEN = 30, XMLNAME = "ANESTHESIA_ASSISTANT");

/// 麻醉助手2
Property SECONDANESTHESIAASSISTANT As %Library.String(MAXLEN = 30, XMLNAME = "SECOND_ANESTHESIA_ASSISTANT");

/// 麻醉助手3
Property THIRDANESTHESIAASSISTANT As %Library.String(MAXLEN = 30, XMLNAME = "THIRD_ANESTHESIA_ASSISTANT");

/// 麻醉助手4
Property FOURTHANESTHESIAASSISTANT As %Library.String(MAXLEN = 30, XMLNAME = "FOURTH_ANESTHESIA_ASSISTANT");

/// 输血医师工号
Property BLOODTRANDOCTOR As %Library.String(MAXLEN = 30, XMLNAME = "BLOOD_TRAN_DOCTOR");

/// 第一台上护士
Property FIRSTOPERATIONNURSE As %Library.String(MAXLEN = 30, XMLNAME = "FIRST_OPERATION_NURSE");

/// 第二台上护士
Property SECONDOPERATIONNURSE As %Library.String(MAXLEN = 30, XMLNAME = "SECOND_OPERATION_NURSE");

/// 第一供应护士
Property FIRSTSUPPLYNURSE As %Library.String(MAXLEN = 30, XMLNAME = "FIRST_SUPPLY_NURSE");

/// 第二供应护士
Property SECONDSUPPLYNURSE As %Library.String(MAXLEN = 30, XMLNAME = "SECOND_SUPPLY_NURSE");

/// 第三供应护士
Property THIRDSUPPLYNURSE As %Library.String(MAXLEN = 30, XMLNAME = "THIRD_SUPPLY_NURSE");

/// 手术申请时指定的手术准备条件等
Property NOTESONOPERATION As %Library.String(MAXLEN = 30, XMLNAME = "NOTES_ON_OPERATION");

/// 提出手术申请的日期及时间
Property REQDATETIME As %Library.String(MAXLEN = 30, XMLNAME = "REQ_DATE_TIME");

/// 录入预约申请的医生或护士工号
Property ENTEREDBY As %Library.String(MAXLEN = 30, XMLNAME = "ENTERED_BY");

/// 手术状态
Property STATUS As %Library.String(MAXLEN = 2, XMLNAME = "STATUS");

/// 就诊类型代码
Property AdmTypeCode As %Library.String(MAXLEN = 2, XMLNAME = "AdmTypeCode");

/// 就诊类型描述
Property AdmTypeDesc As %Library.String(MAXLEN = 2, XMLNAME = "AdmTypeDesc");

/// 就诊状态代码
Property AdmStatusCode As %Library.String(MAXLEN = 2, XMLNAME = "AdmStatusCode");

/// 就诊状态描述
Property AdmStatusDesc As %Library.String(MAXLEN = 2, XMLNAME = "AdmStatusDesc");

}
