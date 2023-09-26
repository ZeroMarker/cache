/// CTOR: QP
/// DATE: 2019-04-18
/// DESC: 抗菌药物常规设置DTO
Class DHCAnt.Base.Dto.BSNoraml Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 1启用门诊抗菌药物管理
Property OSKJ As %Library.String(TRUNCATE = 1);

/// 2启用急诊抗菌药物管理
Property ESKJ As %Library.String(TRUNCATE = 1);

/// 3启用住院抗菌药物管理
Property ISKJ As %Library.String(TRUNCATE = 1);

/// 4启用联合用药控制
Property SCKJ As %Library.String(TRUNCATE = 1);

/// 5启用消息提示
Property MSGTIP As %Library.String(TRUNCATE = 1);

/// 6启用特抗药物指征
Property SKSS3IND As %Library.String(TRUNCATE = 1);

/// 7启用致病菌
Property SBJ As %Library.String(TRUNCATE = 1);

/// 8是否所有权限到医生
Property AUTHTODOC As %Library.String(TRUNCATE = 1);

/// 9自动获取上一次使用目的
Property AUTOAIM As %Library.String(TRUNCATE = 1);

/// 10是否自动弹出申请列表
Property AUTOOPEN As %Library.String(TRUNCATE = 1);

/// 11越级是否可以从申请列表选择
Property EMAGAIN As %Library.String(TRUNCATE = 1);

/// 12一次目的
Property SAMEKSSONCE As %Library.String(TRUNCATE = 1);

/// 13越级控制  
Property EOE As %Library.String(TRUNCATE = 1);

/// 14权限个数
Property DOCAUTHNUM As %Library.String(TRUNCATE = 1);

/// 15启用多科会诊
Property SMANYCONSULT As %Library.String(TRUNCATE = 1);

/// 16非本科室会诊
Property NOSELFCONLOC As %Library.String(TRUNCATE = 1);

/// 17科室个数
Property CONDEPNUM As %Library.String(TRUNCATE = 1);

/// 18默认科室
Property DEFAULTCONDEP As %Library.String(TRUNCATE = 1);

/// 19默认医生
Property DEFAULTCONDOC As %Library.String(TRUNCATE = 1);

/// 20送检方式
Property LABWAY As %Library.String(TRUNCATE = 1);

/// 21医嘱子类
Property LABOECATE As %Library.String(TRUNCATE = 1);

/// 22本地模式
Property LOCALMODEL As %Library.String(TRUNCATE = 1);

/// 23启用碳青霉烯类及替加环素
Property SCQMX As %Library.String(TRUNCATE = 1);

/// 24碳青霉烯类及替加环素业务模式
Property MCQMX As %Library.String(TRUNCATE = 1);

/// 25长期医嘱类型
Property OETYPE As %Library.String(TRUNCATE = 1);

/// 26预防使用目的控制开关
Property UPMYF As %Library.String(TRUNCATE = 1);

/// 27治疗使用目的控制开关
Property UPMZL As %Library.String(TRUNCATE = 1);

/// 30预防使用目的控制项
Property UPMYFVAL As %Library.String(TRUNCATE = 1);

/// 31治疗使用目的控制项
Property UPMZLVAL As %Library.String(TRUNCATE = 1);

/// 28预防控制层级
Property UPMYFLEVEL As %Library.String(TRUNCATE = 1);

/// 29治疗控制层级
Property UPMZLLEVEL As %Library.String(TRUNCATE = 1);

/// 32预防用药时间限制天数
Property YFDRUGTIME As %Library.String(TRUNCATE = 1);

/// 33预防用药时间限制天数
Property EMNUM As %Library.String(TRUNCATE = 1);

/// 34预防用药时间限制天数
Property EMLEVEL As %Library.String(TRUNCATE = 1);

/// 35预防用药时间限制天数
Property TWOAPP As %Library.String(TRUNCATE = 1);

/// 36启用门诊抗肿瘤药物管理
Property OATD As %Library.String(TRUNCATE = 1);

/// 37启用急诊抗肿瘤药物管理
Property EATD As %Library.String(TRUNCATE = 1);

/// 38启用住院抗肿瘤药物管理
Property IATD As %Library.String(TRUNCATE = 1);

/// 39申请列表是否仅有本人可以开具
Property APPONESELF As %Library.String(TRUNCATE = 1);

/// 40默认会诊科室1
Property DEFAULTCONDEP1 As %Library.String(TRUNCATE = 1);

/// 41默认会诊医生1
Property DEFAULTCONDOC1 As %Library.String(TRUNCATE = 1);

/// 42默认会诊科室2
Property DEFAULTCONDEP2 As %Library.String(TRUNCATE = 1);

/// 43默认会诊医生2
Property DEFAULTCONDOC2 As %Library.String(TRUNCATE = 1);

/// 44默认会诊科室3
Property DEFAULTCONDEP3 As %Library.String(TRUNCATE = 1);

/// 45默认会诊医生3
Property DEFAULTCONDOC3 As %Library.String(TRUNCATE = 1);

}
