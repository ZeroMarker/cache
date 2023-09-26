/// 名称:手术和过程-手术/过程实体类
/// 编写者:基础平台组 - 陈莹
/// 编写日期:2012-9-19
Class web.Entity.CT.ORCOperation Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.ORCOperation";

Property OPERRowId As %String;

// 代码

Property OPERCode As %String;

// 手术/过程

Property OPERDesc As %String;

// 默认医嘱项

Property OPERARCIMDR As %String;

// 开始日期

Property OPERDateActiveFrom As %String;

// 结束日期

Property OPERActiveDateTo As %String;

// 手术分类

Property OPERDefaultCategoryDR As %String;

// 从年龄

Property OPERAgeFrom As %String;

// 到年龄

Property OPERAgeTo As %String;

// 限制性别

Property OPERSexDR As %String;

// ICD10 Code

Property OPERICD10 As %String;

// ICD9 Code

Property OPERICD9Map As %String;

// 有效性

Property OPERValid As %String;

// 从限制年龄

Property OPERAgeFrom1 As %String;

// 到限制年龄

Property OPERAgeTo1 As %String;

// 详细描述 

Property OPERLongDescription As %String;

// 日间手术  2017-3-8

Property OPERDaySurgery As %String;

// 国家医保编码

Property OPERInsuCode As %String;

// 国家医保名称

Property OPERInsuDesc As %String;

// 是否医保灰码 ^33

Property OPERGrayCodeFlag As %String;

// 版本号 ^41 add@2022-12-27

Property OPERVersionDictDR As %String;

/// 国家标准分级 ^42 2023-3-2
Property OPERStandardClassDR As %String;

}
