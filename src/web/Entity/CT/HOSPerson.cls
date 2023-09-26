/// Function: HOS人员基本信息表
/// CreateDate:2022-11-10
/// Creator:gaoshanshan
Class web.Entity.CT.HOSPerson Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ Not ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.HOSPerson";

Property ID As %String;

/// 唯一标识码
Property PAPersonID As %String;

/// 姓名
Property PAName As %String;

/// 曾用名
Property PAFormerName As %String;

/// 性别代码-外键
Property PAGenderCode As %String;

/// 出生日期
Property PABirthDate As %String;

/// 出生时间	
Property PABirthTime As %String;

/// 国籍-外键
Property PANationalityCode As %String;

/// 第一语言
Property PALanguageCode1 As %String;

/// 第二语言
Property PALanguageCode2 As %String;

/// 身份证号
Property PAIdentityID As %String;

/// 身份证件类型
Property PAIdentityType As %String;

/// 民族代码-外键
Property PANationCode As %String;

/// 学历代码-外键
Property PAEducationCode As %String;

/// 学位代码-外键
Property PADegreeCode As %String;

/// 职业代码-外键
Property PAOccupationCode As %String;

/// 婚姻状态-外键
Property PAMarriedCode As %String;

/// 宗教-外键
Property PAReligionCode As %String;

/// 籍贯（国家）-外键
Property PANPCountryCode As %String;

/// 籍贯（省）-外键
Property PANPPROVCode As %String;

/// 籍贯（市）-外键
Property PANPCITYCode As %String;

/// 籍贯（县区）-外键
Property PANPDISTRCode As %String;

/// 现住址（国家）-外键
Property PAAddrCountryCode As %String;

/// 现住址（省）-外键
Property PAAddrPROVCode As %String;

/// 现住址（市）-外键
Property PAAddrCITYCode As %String;

/// 现住址（县区）-外键
Property PAAddrDISTRCode As %String;

/// 现住址（详细地址）	
Property PAAddress As %String;

/// 照片
Property PAPhoto As %String;

/// 手机号码	
Property PAMobile As %String;

/// 邮箱	
Property PAEmail As %String;

/// 状态 外键？
Property PAPersonStatus As %String;

/// 是否有效(Y/N)
Property PAActivity As %String;

/// 开始日期
Property PAStartDate As %String;

/// 结束日期
Property PAEndDate As %String;

/// 系统创建日期
Property PACreateDate As %String;

/// 系统创建时间
Property PACreateTime As %String;

/// 系统创建人
Property PACreateUser As %String;

/// 系统排序号
Property PASeqNo As %String;

/// 系统最后更新日期
Property PALastUpdateDate As %String;

/// 系统最后更新时间
Property PALastUpdateTime As %String;

/// 系统最新更新人
Property PALastUpdateUser As %String;

/// 拼音码
Property PAPYCode As %String;

/// 五笔码
Property PAWBCode As %String;

/// 备注
Property PAMark As %String;

}
