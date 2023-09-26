Class EMRmeta.Data.DHCANInterface Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "OperInfo";

/// 	手麻手术申请ID
Property OPSID As %String(TRUNCATE = 1);

/// 	就诊ID
Property EpisodeID As %String(TRUNCATE = 1);

/// 	患者姓名
Property PatName As %String(TRUNCATE = 1);

/// 	患者性别
Property PatGender As %String(TRUNCATE = 1);

/// 	患者年龄
Property PatAge As %String(TRUNCATE = 1);

/// 	患者出生日期
Property PatDOB As %String(TRUNCATE = 1);

/// 	患者登记号
Property RegNo As %String(TRUNCATE = 1);

/// 	患者病案号
Property MedcareNo As %String(TRUNCATE = 1);

/// 	患者Id
Property PatientID As %String(TRUNCATE = 1);

/// 	患者就诊号
Property MRAdmID As %String(TRUNCATE = 1);

/// 	费别
Property AdmReason As %String(TRUNCATE = 1);

/// 	患者身份证号
Property PatCardID As %String(TRUNCATE = 1);

/// 	患者信息
Property Patient As %String(TRUNCATE = 1);

/// 	患者科室Id
Property PatDeptID As %String(TRUNCATE = 1);

/// 	患者科室描述
Property PatDeptDesc As %String(TRUNCATE = 1);

/// 	患者病区Id
Property PatWardID As %String(TRUNCATE = 1);

/// 	患者病区描述
Property PatWardDesc As %String(TRUNCATE = 1);

/// 	患者床位Id
Property PatBedID As %String(TRUNCATE = 1);

/// 	患者床位
Property PatBedCode As %String(TRUNCATE = 1);

/// 	手术申请科室Id
Property AppDeptID As %String(TRUNCATE = 1);

/// 	手术申请科室描述
Property AppDeptDesc As %String(TRUNCATE = 1);

/// 	申请医护人员Id
Property AppCareProvID As %String(TRUNCATE = 1);

/// 	申请医护人员描述
Property AppCareProvDesc As %String(TRUNCATE = 1);

/// 	手术科室Id
Property OperDeptID As %String(TRUNCATE = 1);

/// 	手术科室描述
Property OperDeptDesc As %String(TRUNCATE = 1);

/// 	麻醉科室Id
Property AnaDept As %String(TRUNCATE = 1);

/// 	麻醉科室描述
Property AnaDeptDesc As %String(TRUNCATE = 1);

/// 	手术类型代码
Property SourceType As %String(TRUNCATE = 1);

/// 	手术类型描述(急诊，择期)
Property SourceTypeDesc As %String(TRUNCATE = 1);

/// 	手术状态id
Property Status As %String(TRUNCATE = 1);

/// 	手术状态代码
Property StatusCode As %String(TRUNCATE = 1);

/// 	手术日期
Property OperDate As %String(TRUNCATE = 1);

/// 	手术时间
Property OperTime As %String(TRUNCATE = 1);

/// 	手术时长
Property OperDuration As %String(TRUNCATE = 1);

/// 	是否二次手术
Property ReentryOperation As %String(TRUNCATE = 1);

/// 	拟施麻醉方法Id
Property PrevAnaMethod As %String(TRUNCATE = 1);

/// 	拟施麻醉方法描述
Property PrevAnaMethodDesc As %String(TRUNCATE = 1);

/// 	预计手术台次
Property PlanSeq As %String(TRUNCATE = 1);

/// 	术前诊断
Property PrevDiagnosis As %String(TRUNCATE = 1);

/// 	拟施手术描述
Property PlanOperDesc As %String(TRUNCATE = 1);

/// 	拟施手术说明
Property PlanOperNote As %String(TRUNCATE = 1);

/// 	拟施手术术者
Property PlanSurgeonDesc As %String(TRUNCATE = 1);

/// 	手术描述
Property OperDesc As %String(TRUNCATE = 1);

/// 	手术说明
Property OperNote As %String(TRUNCATE = 1);

/// 	主刀医师名称
Property SurgeonDesc As %String(TRUNCATE = 1);

/// 	手术助手描述
Property AsstDesc As %String(TRUNCATE = 1);

/// 	手术部位Id
Property BodySite As %String(TRUNCATE = 1);

/// 	手术体位Id
Property OperPosition As %String(TRUNCATE = 1);

/// 	实习进修人员
Property SurIntership As %String(TRUNCATE = 1);

/// 	参观人员
Property SurVisitors As %String(TRUNCATE = 1);

/// 	手术医生代码
Property SurgeonCode As %String(TRUNCATE = 1);

/// 	仪器器械
Property SurgicalMaterials As %String(TRUNCATE = 1);

/// 	特殊情况
Property SpecialConditions As %String(TRUNCATE = 1);

/// 	高值耗材
Property HighConsume As %String(TRUNCATE = 1);

/// 	是否隔离手术
Property IsoOperation As %String(TRUNCATE = 1);

/// 	是否体外循环
Property ECC As %String(TRUNCATE = 1);

/// 	是否自体血回输
Property TransAutoblood As %String(TRUNCATE = 1);

/// 	是否备血
Property PrepareBlood As %String(TRUNCATE = 1);

/// 	是否感染手术
Property InfectionOper As %String(TRUNCATE = 1);

/// 	是否微创手术
Property MIS As %String(TRUNCATE = 1);

/// 	是否使用抗生素
Property Antibiosis As %String(TRUNCATE = 1);

/// 	手术要求
Property OperRequirement As %String(TRUNCATE = 1);

/// 	血型
Property BloodType As %String(TRUNCATE = 1);

/// 	RH血型
Property RHBloodType As %String(TRUNCATE = 1);

/// 	HbsAg
Property HbsAg As %String(TRUNCATE = 1);

/// 	HcvAb
Property HcvAb As %String(TRUNCATE = 1);

/// 	HivAb
Property HivAb As %String(TRUNCATE = 1);

/// 	梅毒
Property Syphilis As %String(TRUNCATE = 1);

/// 	手术间id
Property OperRoom As %String(TRUNCATE = 1);

/// 	手术间描述
Property RoomDesc As %String(TRUNCATE = 1);

/// 	手术间代码
Property RoomCode As %String(TRUNCATE = 1);

/// 	手术台次
Property OperSeq As %String(TRUNCATE = 1);

/// 	器械护士id
Property ScrubNurse As %String(TRUNCATE = 1);

/// 	器械护士描述
Property ScrubNurseDesc As %String(TRUNCATE = 1);

/// 	巡回护士id
Property CircualNurse As %String(TRUNCATE = 1);

/// 	入手术间日期时间
Property TheatreInDT As %String(TRUNCATE = 1);

/// 	离手术间日期时间
Property TheatreOutDT As %String(TRUNCATE = 1);

/// 	手术开始日期时间
Property OperStartDT As %String(TRUNCATE = 1);

/// 	手术结束日期时间
Property OperFinishDT As %String(TRUNCATE = 1);

/// 	麻醉开始日期时间
Property AnaStartDT As %String(TRUNCATE = 1);

/// 	麻醉结束日期时间
Property AnaFinishDT As %String(TRUNCATE = 1);

/// 	插管日期时间
Property TubeInDT As %String(TRUNCATE = 1);

/// 	拔管日期时间
Property TubeOutDT As %String(TRUNCATE = 1);

/// 	入恢复室日期时间
Property PACUInDT As %String(TRUNCATE = 1);

/// 	出恢复室日期时间
Property PACUOutDT As %String(TRUNCATE = 1);

/// 	实施麻醉方法Id
Property AnaMethod As %String(TRUNCATE = 1);

/// 	实施麻醉方法描述
Property AnaMethodDesc As %String(TRUNCATE = 1);

/// 	麻醉指导Id
Property AnaExpert As %String(TRUNCATE = 1);

/// 	麻醉指导描述
Property AnaExpertDesc As %String(TRUNCATE = 1);

/// 	麻醉医师Id
Property Anesthesiologist As %String(TRUNCATE = 1);

/// 	麻醉医师描述
Property AnesthesiologistDesc As %String(TRUNCATE = 1);

/// 	麻醉助手Id
Property AnaAssistant As %String(TRUNCATE = 1);

/// 	麻醉助手描述
Property AnaAssistantDesc As %String(TRUNCATE = 1);

/// 	麻醉实习进修医生
Property AnaStaff As %String(TRUNCATE = 1);

/// 	日间手术标志，为Y则是日间手术
Property DaySurgery As %String(TRUNCATE = 1);

/// 	麻醉ASA分级
Property ASAClass As %String(TRUNCATE = 1);

/// 	麻醉ASA分级描述
Property ASAClassDesc As %String(TRUNCATE = 1);

///     手术操作部位描述
Property BodySiteDesc As %String(TRUNCATE = 1);

/// 主刀医师 术者
Property Surgeon As %String(TRUNCATE = 1);

}
