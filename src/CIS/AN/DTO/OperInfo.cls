/// 手术信息类
Class CIS.AN.DTO.OperInfo Extends %RegisteredObject
{

/// 手术申请ID
Property OPSID As %String;

/// 患者就诊ID
Property EpisodeID As %String;

/// 麻醉申请ID
Property ExtAnaestID As %String;

/// 患者姓名
Property PatName As %String;

/// 患者性别
Property PatGender As %String;

/// 患者年龄
Property PatAge As %String;

/// 患者出生日期
Property PatDOB As %String;

/// 登记号
Property RegNo As %String;

/// 住院号
Property MedcareNo As %String;

/// 患者ID
Property PatientID As %String;

/// 患者诊断ID
Property MRAdmID As %String;

/// 就诊类型
Property AdmReason As %String;

/// 身份证号
Property PatCardID As %String;

/// 患者信息
Property Patient As %String;

/// 患者科室ID
Property PatDeptID As %String;

/// 患者科室名称
Property PatDeptDesc As %String;

/// 患者病区ID
Property PatWardID As %String;

/// 患者病区名称
Property PatWardDesc As %String;

/// 患者床位ID
Property PatBedID As %String;

/// 患者床位代码
Property PatBedCode As %String;

/// 手术申请科室ID
Property AppDeptID As %String;

/// 手术申请科室名称
Property AppDeptDesc As %String;

/// 手术申请医生ID
Property AppCareProvID As %String;

/// 手术申请医生姓名
Property AppCareProvDesc As %String;

/// 手术室ID
Property OperDeptID As %String;

/// 手术室名称
Property OperDeptDesc As %String;

/// 手术类型
Property SourceType As %String;

/// 手术类型名称
Property SourceTypeDesc As %String;

/// 手术状态
Property Status As %String;

/// 手术状态名称
Property StatusDesc As %String;

/// 手术状态颜色
Property StatusColor As %String;

/// 手术状态代码
Property StatusCode As %String;

/// 手术开始日期
Property OperDate As %String;

/// 手术预计开始时间
Property OperTime As %String;

/// 手术预计持续时长
Property OperDuration As %String;

/// 非计划二次手术
Property ReentryOperation As %String;

/// 是否麻醉
Property Anaesthesia As %String;

/// 是否麻醉描述
Property AnaesthesiaDesc As %String;

/// 拟施麻醉
Property PrevAnaMethod As %String;

/// 拟施麻醉描述
Property PrevAnaMethodDesc As %String;

/// 计划台次
Property PlanSeq As %String;

/// 台次类型
Property SeqType As %String;

/// 台次类型描述
Property SeqTypeDesc As %String;

/// 术前诊断
Property PrevDiagnosis As %String;

/// 拟施手术描述
Property PlanOperDesc As %String;

/// 拟施手术备注
Property PlanOperNote As %String;

/// 拟施手术手术医生描述
Property PlanSurgeonDesc As %String;

/// 拟施手术手术助手描述
Property PlanAsstDesc As %String;

/// 实施手术描述
Property OperDesc As %String;

/// 实施手术备注
Property OperNote As %String;

/// 实施手术手术医生描述
Property SurgeonDesc As %String;

/// 实施手术手术助手描述
Property AsstDesc As %String;

/// 手术部位
Property BodySite As %String;

/// 手术体位
Property OperPosition As %String;

/// 手术实习进修医生
Property SurIntership As %String;

/// 手术参观人员
Property SurVisitors As %String;

/// 手术器械
Property SurgicalMaterials As %String;

/// 特殊情况
Property SpecialCondition As %String;

/// 高值耗材
Property HighConsume As %String;

/// 隔离手术
Property IsoOperation As %String;

/// 体外循环手术
Property ECC As %String;

/// 自体血回输
Property TransAutoBlood As %String;

/// 术前备血
Property PrepareBlood As %String;

/// 感染手术
Property InfectionOper As %String;

/// 微创手术
Property MIS As %String;

/// 使用抗生素标志
Property Antibiosis As %String;

/// 手术其他要求
Property OperRequirement As %String;

/// ABO血型
Property BloodType As %String;

/// RH血型
Property RHType As %String;

Property HbsAg As %String;

Property HcvAb As %String;

Property HivAb As %String;

Property Syphilis As %String;

/// 手术间
Property OperRoom As %String;

/// 手术间描述
Property RoomDesc As %String;

/// 手术间代码
Property RoomCode As %String;

/// 手术台次
Property OperSeq As %String;

/// 器械护士
Property ScrubNurse As %String;

/// 器械护士描述
Property ScrubNurseDesc As %String;

/// 巡回护士
Property CircualNurse As %String;

/// 巡回护士描述
Property CircualNurseDesc As %String;

/// 实习进修护士
Property InternshipNurse As %String;

/// 第一器械护士
Property FirstScrubNurse As %String;

/// 第一器械护士描述
Property FirstScrubNurseDesc As %String;

/// 第二器械护士
Property SecScrubNurse As %String;

/// 第二器械护士描述
Property SecScrubNurseDesc As %String;

/// 第一巡回护士
Property FirstCircualNurse As %String;

/// 第一巡回护士描述
Property FirstCircualNurseDesc As %String;

/// 第二巡回护士
Property SecCircualNurse As %String;

/// 第二巡回护士描述
Property SecCircualNurseDesc As %String;

/// 病区床位
Property WardBed As %String;

/// 患者入手术间日期时间
Property TheatreInDT As %String;

/// 患者离手术间日期时间
Property TheatreOutDT As %String;

/// 手术开始日期时间
Property OperStartDT As %String;

/// 手术结束日期时间
Property OperFinishDT As %String;

/// 麻醉开始日期时间
Property AnaStartDT As %String;

/// 麻醉结束日期时间
Property AnaFinishDT As %String;

/// 插管日期时间
Property TubeInDT As %String;

/// 拔管日期时间
Property TubeOutDT As %String;

/// 入手术室日期时间
Property AreaInDT As %String;

/// 离手术室日期时间
Property AreaOutDT As %String;

/// 入PACU日期时间
Property PACUInDT As %String;

/// 离PACU日期时间
Property PACUOutDT As %String;

/// 手术预计日期时间
Property OperDateTime As %String;

/// 麻醉申请ID
Property AnaestID As %String;

/// 实施麻醉方法
Property AnaMethod As %String;

/// 实施麻醉方法描述
Property AnaMethodDesc As %String;

/// 麻醉专家
Property AnaExpert As %String;

/// 麻醉专家描述
Property AnaExpertDesc As %String;

/// 麻醉医生
Property Anesthesiologist As %String;

/// 麻醉医生描述
Property AnesthesiologistDesc As %String;

/// 麻醉助手
Property AnaAssistant As %String;

/// 麻醉助手描述
Property AnaAssistantDesc As %String;

/// 麻醉实习进修医生
Property AnaStaff As %String;

/// 手术部位描述
Property BodySiteDesc As %String;

/// 手术体位描述
Property OperPositionDesc As %String;

/// PACU时长(离PACU时间-入PACU时间)，单位：小时
Property PACUDuration As %String;

/// 等待时长(麻醉开始时间-入手术室时间)，单位：分钟
Property WaitDuration As %String;

/// 实施手术时长(手术结束时间-手术开始时间)，单位：小时
Property ROperDuration As %String;

/// 术前住院日
Property PreopAdmDays As %String;

/// 手术申请日期时间
Property AppDateTime As %String;

/// 日间手术标志，为Y则是日间手术
Property DaySurgery As %String;

}
