/// Function: HOS 组织机构树
/// CreateDate:2022-11-10
/// Creator:钟荣枫
Class web.Entity.CT.HOSOrganization Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ Not ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.HOSOrganization";

Property ID As %String;

/// 组织代码
Property ORGCode As %String;

/// 组织名称
Property ORGDesc As %String;

/// 统一社会信用代码
Property ORGUSCC As %String;

/// 组织简称
Property ORGAbbrev As %String;

/// 组织简介
Property ORGIntro As %String;

/// 组织法人
Property ORGLegalEntity As %String;

/// 组织负责人	
Property ORGHeader As %String;

/// 上级机构
Property ORGORGCode As %String;

/// 组织小类
Property ORGORGMCCode As %String;

/// 组织所在国家
Property ORGCountryCode As %String;

/// 组织所在省
Property ORGPROVCode As %String;

/// 组织所在市
Property ORGCITYCode As %String;

/// 组织所在区
Property ORGDISTRCode As %String;

/// 组织地址
Property ORGAddress As %String;

/// 组织邮编
Property ORGZipCode As %String;

/// 联系电话	
Property ORGTel As %String;

/// 传真
Property ORGFax As %String;

/// 邮件
Property ORGEmail As %String;

/// 官网
Property ORGWebSite As %String;

/// 建立日期
Property ORGFoundDate As %String;

/// 注销日期
Property ORGCancelDate As %String;

/// 是否有效(Y/N)
Property ORGActivity As %String;

/// 开始日期
Property ORGStartDate As %String;

/// 结束日期
Property ORGEndDate As %String;

/// 系统创建日期
Property ORGCreateDate As %String;

/// 系统创建时间
Property ORGCreateTime As %String;

/// 系统创建人
Property ORGCreateUser As %String;

/// 系统排序号
Property ORGSeqNo As %String;

/// 系统最后更新日期
Property ORGLastUpdateDate As %String;

/// 系统最后更新时间
Property ORGLastUpdateTime As %String;

/// 系统最新更新人
Property ORGLastUpdateUser As %String;

/// 拼音码
Property ORGPYCode As %String;

/// 五笔码
Property ORGWBCode As %String;

/// 备注
Property ORGMark As %String;

/// 标准编码
Property ORGStandardCode As %String;

/// 标准名称
Property ORGStandardDesc As %String;

/// 原系统编码
Property ORGCodeBefore As %String;

}
