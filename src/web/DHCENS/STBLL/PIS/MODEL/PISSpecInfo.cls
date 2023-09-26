Class web.DHCENS.STBLL.PIS.MODEL.PISSpecInfo Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "PISOrdInfo";

/// 申请单号
Property AppID As %String(MAXLEN = "");

/// 手术所见
Property OperationInfo As %String(MAXLEN = "");

/// 肿瘤信息
Property TumorInfo As %String(MAXLEN = "");

/// 妇科信息
Property GynecologyInfo As %String(MAXLEN = "");

/// 临床体征,病史等/临床病历
Property ClinicInfo As %String(MAXLEN = "");

/// 是否加急
Property IsUrgent As %String(MAXLEN = "");

/// 是否冰冻
Property IsFrozen As %String(MAXLEN = "");

/// 标本离体时间
Property SpecOffDateTime As %String(MAXLEN = "");

/// 开始固定时间
Property SpecFixedDateTime As %String(MAXLEN = "");

/// 取材科室代码
Property SamplingDeptCode As %String(MAXLEN = "");

/// 取材科室名称
Property SamplingDeptDesc As %String(MAXLEN = "");

/// 取材医生工号
Property SamplingDoctorCode As %String(MAXLEN = "");

/// 取材医生姓名
Property SamplingDoctorDesc As %String(MAXLEN = "");

/// 取材日期
Property SamplingDateTime As %String(MAXLEN = "");

/// 传染病史
Property InfectionInfo As %String(MAXLEN = "");

/// 病人病历
Property DocumentInfo As %String(MAXLEN = "");

///  首次发现人乳头瘤病毒时间
Property HumanPapillomavirusDateTime As %String(MAXLEN = "");

/// 检测方法
Property TestMethod As %String(MAXLEN = "");

/// 临床诊断
Property ClinicalDiagnosis As %String(MAXLEN = "");

/// 治疗方式
Property Treatment As %String(MAXLEN = "");

/// 大体标本检查所见
Property GeneralSpecExamination As %String(MAXLEN = "");

/// 会诊要求
Property ConsultationRequirements As %String(MAXLEN = "");

/// 会诊专家
Property ConsultationDoctor As %String(MAXLEN = "");

/// 取材部位
Property SamplingPosition As %String(MAXLEN = "");

/// 取材类型
Property SamplingType As %String(MAXLEN = "");

/// 自发病至死亡病程时日
Property DOTFOTD As %String(MAXLEN = "");

/// 病史及治疗过程
Property MedicalHistory As %String(MAXLEN = "");

/// 临床体格检查及化验检查
Property ClinicPhysicalExam As %String(MAXLEN = "");

/// 尸检目的或希望注意事项
Property AutopsyInfo As %String(MAXLEN = "");

/// 送检医生
Property TraDoctorCode As %String(MAXLEN = "");

/// 检查类别
Property ExamType As %String(MAXLEN = "");

/// 标本信息 标本信息字段以#分割；多个标本信息通过@符号分割。示例：标本序号#标本名称#标本部位#标本数量###标本离体时间#开始固定时间
/// Property SpecInfo As %String(MAXLEN = "");
Property SpecInfo As list Of web.DHCENS.STBLL.PIS.MODEL.PISSpecDetailInfo(XMLNAME = "SpecInfo", XMLPROJECTION = "ELEMENT");

/// 标本类型
Property PisCutBasType As %String(MAXLEN = "");

/// 医嘱项代码
Property OrdCode As %String(MAXLEN = "");

/// 医嘱ID 
Property OrdRowID As %String(MAXLEN = "");

/// 医嘱描述
Property OrdDesc As %String(MAXLEN = "");

/// 医嘱状态代码
Property OEORIStatusCode As %String(MAXLEN = "");

/// 生理周期代码
Property PhysiCycleCode As %String(MAXLEN = "");

/// 生理周期
Property PhysiCycle As %String(MAXLEN = "");

/// 接收科室代码
Property PISRRAcceptDeptCode As %String(MAXLEN = "");

/// 接收科室名称
Property PISRRAcceptDeptDesc As %String(MAXLEN = "");

/// 医嘱价格
Property PISRPrice As %String(MAXLEN = "");

/// 送检目的
Property Purpose As %String(MAXLEN = "");

/// 检查系统类型
Property RISRSystemType As %String(MAXLEN = "");

/// 分子病理申请单检测项目
Property TestItem As %String(MAXLEN = "");

/// 病理原诊断
Property OrignalDiag As %String(MAXLEN = "");

}
