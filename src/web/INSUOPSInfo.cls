Class web.INSUOPSInfo Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "SSMXBG";

//此对象节点名称,可根据实际情况修改

//注意：如果有XMLNAME属性，生成XML或XML转为本对象时以XMLNAME名称为准,

//SQLUSER.OR_Anaesthesia.ANA_SourceType 急诊(E)/择期(B)

Property JzStat As %String(CONTENT = "急诊(E)/择期(B)");

// 登记号

Property RegNo As %String(CONTENT = "登记号");

// 就诊号

Property EpisodeID As %String(CONTENT = "就诊号");

Property OPAAdmDr As %String(CONTENT = "就诊号");

// 病案号

Property MedCareNo As %String(CONTENT = "病案号");

// 病人姓名

Property PatName As %String(CONTENT = "病人姓名");

// 病人出生日期

Property Birthday As %String(CONTENT = "病人出生日期");

// 病人年龄

Property Age As %String(CONTENT = "病人年龄");

// 病人性别

Property Sex As %String(CONTENT = "病人性别");

// 病人类型（O门诊，E急诊，I住院）

Property PaAdmType As %String(CONTENT = "就诊类型");

// 病人病区

Property Ward As %String(CONTENT = "病人病区");

// 病人床位

Property Bed As %String(CONTENT = "病人床位");

// 病人所在房间

Property BedRoom As %String(CONTENT = "病人所在房间");

// 病人所在科室Id

Property OPAPatDeptDr As %String(CONTENT = "病人所在科室Id");

// 病人所在科室描述

Property PatLoc As %String(CONTENT = "病人所在科室描述");

// 乙肝

Property OPAPATestHBsAg As %String(CONTENT = "乙肝");

// 丙肝

Property OPAPATestHCVAb As %String(CONTENT = "丙肝");

// HIV

Property OPAPATestHivAb As %String(CONTENT = "HIV");

// 梅毒

Property OPAPATestTPAb As %String(CONTENT = "梅毒");

// 其它

Property OPAPATestOther As %String(CONTENT = "其它");

// 特殊感染

Property OPALabResult As %String(CONTENT = "特殊感染");

// 手术排班表Id

Property OpaId As %String(CONTENT = "手术排班表Id");

// 麻醉表Id

Property AnaesthesiaID As %String(CONTENT = "麻醉表Id");

// 手术状态 A申请，R安排，D取消，I术中，L离室，P恢复室，F完成

Property OPAStatus As %String(CONTENT = "手术状态");

// 状态代码

Property StatCode As %String(CONTENT = "状态代码");

// 手术申请医生

Property OPAAppLocDr As %String(CONTENT = "手术申请医生");

// 手术申请日期

Property OPAAppDate As %String(CONTENT = "手术申请日期");

// 手术安排用户

Property OPAArrangeUser As %String(CONTENT = "手术安排用户");

// 手术安排日期

Property OPAArrangeDate As %String(CONTENT = "手术安排日期");

// 手术安排时间

Property OPAArrangeTime As %String(CONTENT = "手术安排时间");

// 手术开始日期时间（术前时为计划值）

Property OPAStartDateTime As %String(CONTENT = "手术开始日期时间（术前时为计划值）");

// 手术结束日期时间

Property OPAEndDateTime As %String(CONTENT = "手术结束日期时间");

// 计划手术开始日期时间

Property PlanOPAStartDateTime As %String(CONTENT = "计划手术开始日期时间");

// 计划手术结束日期时间

Property PlanOPAEndDateTime As %String(CONTENT = "计划手术结束日期时间");

// 手术日期

Property OpDate As %String(CONTENT = "手术日期");

// 手术时间

Property OpTime As %String(CONTENT = "手术时间");

// 入室时间

Property InRoomTime As %String(CONTENT = "入室时间");

// 离室时间

Property LeaveRoomTime As %String(CONTENT = "离室时间");

// 麻醉开始日期

Property ANAStartDate As %String(CONTENT = "麻醉开始日期");

// 麻醉开始时间

Property ANAStartTime As %String(CONTENT = "麻醉开始时间");

// 麻醉结束日期

Property ANAEndDate As %String(CONTENT = "麻醉结束日期");

// 麻醉结束时间

Property ANAEndTime As %String(CONTENT = "麻醉结束时间");

// 手术医生开始手术日期

Property SurgeonStartDate As %String(CONTENT = "手术医生开始手术日期");

// 手术医生开始手术时间

Property SurgeonStartTime As %String(CONTENT = "手术医生开始手术时间");

// 手术医生结束日期

Property SurgeonEndDate As %String(CONTENT = "手术医生结束日期");

// 手术医生结束时间

Property SurgeonEndTime As %String(CONTENT = "手术医生结束时间");

// 手术结束

Property OPAFinishTime As %String(CONTENT = "手术结束");

// 入恢复室时间

Property OPAPACUInTime As %String(CONTENT = "入恢复室时间");

// 离开恢复室时间

Property OPAPACUOutTime As %String(CONTENT = "离开恢复室时间");

// 手术类型（择期，急诊）

Property ANASourceTypeDesc As %String(CONTENT = "手术类型（择期，急诊）");

// 手术码表Id

Property OperId As %String(CONTENT = "手术码表Id");

// 麻醉方法

Property AnaMethod As %String(CONTENT = "麻醉方法");

// ASA分级

Property ASA As %String(CONTENT = "ASA分级");

// 手术代码

Property OpCode As %String(CONTENT = "手术代码");

// 手术名称

Property OpName As %String(CONTENT = "手术名称");

// 切口类型Id

Property ANAOPBladeTypeId As %String(CONTENT = "切口类型Id");

// 切口类型

Property ANAOPBladeType As %String(CONTENT = "切口类型");

// 手术部位

Property BodsDesc As %String(CONTENT = "手术部位");

// 手术体位

Property OperPosition As %String(CONTENT = "手术体位");

// 术前诊断ID

Property ANAOPPreopDiagDR As %String(CONTENT = "术前诊断ID");

// 术前诊断

Property ANAOPPreopDiag As %String(CONTENT = "术前诊断");

//

Property Prediag As %String(CONTENT = "Prediag");

// 手术科室Id

Property OPAOperLocDr As %String(CONTENT = "手术科室Id");

// 手术间Id

Property OPAOpRoomDr As %String(CONTENT = "手术间Id");

// 手术间

Property OPAOpRoom As %String(CONTENT = "手术间");

// 手术台次

Property OPASeq As %String(CONTENT = "手术台次");

// 手术医师Id

Property ANAOPSurgeonDR As %String(CONTENT = "手术医师Id");

Property OpDocCtcpId As %String(CONTENT = "OpDocCtcpId");

// 手术医师

Property ANAOPSurgeon As %String(CONTENT = "手术医师");

Property OpDoctor As %String(CONTENT = "备注信息");

// 一助Id

Property AssistantFirstCtcpId As %String(CONTENT = "一助Id");

// 一助

Property AssistantFirstCtcp As %String(CONTENT = "一助");

// 一助Code

Property AssistantFirstCtcpCode As %String(CONTENT = "一助Code");

// 二助Id

Property AssistantSecondCtcpId As %String(CONTENT = "二助Id");

// 二助

Property AssistantSecondCtcp As %String(CONTENT = "二助");

// 二助Code

Property AssistantSecondCtcpCode As %String(CONTENT = "二助Code");

// 三助Id

Property AssistantThirdCtcpId As %String(CONTENT = "三助Id");

// 三助

Property AssistantThirdCtcp As %String(CONTENT = "三助");

// 三助Code

Property AssistantThirdCtcpCode As %String(CONTENT = "三助Code");

//其他助手Id

Property AssOtherCtcpStrId As %String(CONTENT = "其他助手Id");

//其他助手

Property AssOtherCtcpStr As %String(CONTENT = "其他助手");

// 麻醉医生Id

Property AnaDocCtcpId As %String(CONTENT = "麻醉医生Id");

// 麻醉医生

Property AnaDoctor As %String(CONTENT = "麻醉医生");

// 麻醉医生Code

Property AnaDoctorCode As %String(CONTENT = "麻醉医生Code");

// 器械护士一Id

Property ScrubNurFirstCtcpId As %String(CONTENT = "器械护士一Id");

Property OPSCNScrubNurseDR As %String(CONTENT = "OPSCNScrubNurseDR");

// 器械护士一

Property ScrubNurFirstCtcp As %String(CONTENT = "器械护士一");

// 器械护士二Id

Property ScrubNurSecondCtcpId As %String(CONTENT = "器械护士二Id");

// 器械护士二

Property ScrubNurSecondCtcp As %String(CONTENT = "器械护士二");

// 器械护士三Id

Property ScrubNurThirdCtcpId As %String(CONTENT = "器械护士三Id");

// 器械护士三

Property ScrubNurThirdCtcp As %String(CONTENT = "器械护士三");

// 巡回护士一Id

Property CirculNurFirstCtcpId As %String(CONTENT = "巡回护士一Id");

Property ANAOPCirculNurseDR As %String(CONTENT = "ANAOPCirculNurseDR");

// 巡回护士一

Property CirculNurFirstCtcp As %String(CONTENT = "巡回护士一");

// 巡回护士二Id

Property CirculNurSecondCtcpId As %String(CONTENT = "巡回护士二Id");

// 巡回护士二

Property CirculNurSecondCtcp As %String(CONTENT = "巡回护士二");

// 巡回护士三Id

Property CirculNurThirdCtcpId As %String(CONTENT = "巡回护士三Id");

// 巡回护士三

Property CirculNurThirdCtcp As %String(CONTENT = "巡回护士三");

Property OPAStartDate As %String(CONTENT = "OPAStartDate");

// 手术分类

Property opLevelId As %String(CONTENT = "手术分类Id");

// 手术分类

Property opLevelDesc As %String(CONTENT = "手术分类描述");

// 血型

Property bloodType As %String(CONTENT = "血型");

// 自体血回输

Property OPAUseSelfBlood As %String(CONTENT = "自体血回输");

// 体外循环

Property OPAExCirculation As %String(CONTENT = "体外循环");

// 重返手术

Property returnOpe As %String(CONTENT = "重返手术");

// 拒绝原因

Property RejectReason As %String(CONTENT = "拒绝原因");

// 常规器械

Property NorInstrument As %String(CONTENT = "常规器械");

// 特殊器械

Property SpeInstrument As %String(CONTENT = "特殊器械");

// 术后镇痛

Property Analgesia As %String(CONTENT = "术后镇痛");

// Steward评分

Property StewardScore As %String(CONTENT = "Steward评分");

// 心功能分级

Property PRKillip As %String(CONTENT = "心功能分级");

// 手术医师Code

Property ANAOPSurgeonCode As %String(CONTENT = "手术医师Code");

//医保相对手麻组增加的字段

//手术明细流水号	

Property SSMXLSH As %String(CONTENT = "手术明细流水号");

//日间手术标志	1是；0否

Property RJSSBZ As %String(CONTENT = "日间手术标志");

//手术后诊断	按规定的ICD10字典执行，请填报完整代码（含扩展附加编码）

Property SSHZD As %String(CONTENT = "手术后诊断");

//手术序号	指本条记录表述的是第几个手术

Property SSXH As %String(CONTENT = "手术序号");

//指导医师编码

Property ZDYS As %String(CONTENT = "指导医师编码");

//医源性手术	指由于医院原因导致该手术。1：是；2：否

Property YYXSU As %String(CONTENT = "医源性手术");

//手术来源  指是否源于本院的手术。1：是；2：否

Property SSLY As %String(CONTENT = "手术来源");

//麻醉反应	1:无麻醉，2：有反应，3:无反应

Property MZFY As %String(CONTENT = "麻醉反应");

//手术并发症	以西医诊断代码ICD-10填写

Property SSBFZ As %String(CONTENT = "手术并发症");

//手术组号	用以标记同时做的手术

Property SSZH As %String(CONTENT = "手术组号");

//主次标志。	若有主次手术的情况下。1：主手术；2：非主手术。

Property ZCBZ As %String(CONTENT = "主次标志。");

//手术过程	最大长度2048字节

Property SSGC As %String(CONTENT = "手术过程");

}
