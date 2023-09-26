/// 名称: ICD诊断代码 
/// 描述: 实体类
/// 编写者：基础数据平台组 、李森
/// 编写日期: 2012-12-17
Class web.Entity.CT.MRCICDDx Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.MRCICDDx";

/// DelFormId 用于合并时删除项id
Property DelFormId As %String;

/// RowId
Property MRCIDRowId As %String;

/// 代码
Property MRCIDCode As %String;

/// 描述
Property MRCIDDesc As %String;

/// ICD10 Code
Property MRCIDICD9CMCode As %String;

/// 开始日期
Property MRCIDDateActiveFrom As %String;

/// 结束日期
Property MRCIDDateActiveTo As %String;

/// 从年龄
Property MRCIDAgeFrom As %String;

/// 到年龄
Property MRCIDAgeTo As %String;

/// 限制性别
Property MRCIDSexDR As %String;

/// 有效 Y/N
Property MRCIDValid As %String;

/// ICD9 Code
Property MRCIDICD9Map As %String;

/// 副编码
Property MRCID2ndCodeInPair As %String;

/// 注释
Property MRCIDLongDescription As %String;

/// 别名 在User.MRCICDAlias表里
/// Property ALIASText As %String;
/// 肿瘤形态学编码标志 Y/N
Property MRCIDMetastaticSite As %String;

/// 损伤中毒外部原因标志 Y/N
Property MRCIDInjuryPoisoningCode As %String;

/// 中医诊断标志 Y/N
Property MRCIDBillFlag3 As %String;

/// 中医证型标志 Y/N
Property MRCIDBillFlag1 As %String;

/// 别名（用于导入） 2017-2-23 chenying
Property DataAlias As %String;

/// 2019-03-29 ICD诊断分类
Property MRCIDTypeDR As %String;

/// 2020-01-13  就诊类型
Property MRCIDClinicType As %String;

/// 就诊类型 门诊
Property MRCIDClinicTypeO As %String;

/// 就诊类型 急诊
Property MRCIDClinicTypeE As %String;

/// 就诊类型 住院
Property MRCIDClinicTypeI As %String;

/// 就诊类型 体检
Property MRCIDClinicTypeH As %String;

/// 就诊类型 新生儿
Property MRCIDClinicTypeN As %String;

/// 无效主诊断标识（Y时不能作为主诊断来开） 2020-12-22
Property MRCIDInvalidMainFlag As %String;

/// 国家标准名称 2020-12-22
Property MRCIDNationalDesc As %String;

/// 国家标准编码
Property MRCIDNationalCode As %String;

/// 国家医保编码
Property MRCIDInsuCode As %String;

/// 国家医保名称
Property MRCIDInsuDesc As %String;

/// 从年龄类型 （岁/月/日） ^53
Property MRCIDAgeFromType As %String;

/// 到年龄类型 （岁/月/日） ^54
Property MRCIDAgeToType As %String;

/// 医保灰码  
Property MRCIDGrayCodeFlag As %String;

/// 版本号 ^56 add@2022-12-28
Property MRCIDVersionDictDR As %String;

/// 诊断类型 ^57 add@2023-3-7  中医，西医，证型
Property MRCIDDiagnosticType As %String;

/// 罕见病标志  ^58
Property MRCIDRareDiseaseFlag As %String;

}
