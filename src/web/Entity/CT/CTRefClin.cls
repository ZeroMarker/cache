/// 名称:医疗机构实体类
/// 编写者：基础数据平台-sunfengchao
/// 创建日期: 2016-2-17
Class web.Entity.CT.CTRefClin Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.CTRefClin";

/// RowId
Property CTRFCRowId As %String;

/// 代码
Property CTRFCCode As %String;

/// 名称
Property CTRFCDesc As %String;

/// 是否有效
Property CTRFCActiveFlag As %String;

Property CTRFCVEMD As %String;

/// 开始日期
Property CTRFCDateFrom As %String;

/// 结束时间
Property CTRFCDateTo As %String;

/// 类别编码
Property CTRFCCategoryCode As %String;

/// 级别  
Property CTRFCLevel As %String;

/// 行政区划(市)
Property CTRFCCityDR As %String;

/// 行政区划(县)
Property CTRFCCityAreaDR As %String;

/// ********子表信息**2020-12-10*********/
/// 医疗机构地址  
Property CTRFCAddress As %String;

/// 法人姓名
Property CTRFCPersonName As %String;

/// 社会信用代码
Property CTRFCSociaCreditCode As %String;

/// 组织机构代码-外键 add@20220923
Property CTRFCORGCode As %String;

/// 医疗机构执业许可证号
Property CTRFCBusinessClicenseCode As %String;

/// 医疗机构执业许可证效期开始日期
Property CTRFCBusinessClicenseFrom As %String;

/// 医疗机构执业许可证效期结束日期
Property CTRFCBusinessClicenseTo As %String;

/// 编制床位数
Property CTRFCBeds As %String;

/// 医院等级代码-外键
Property CTRFCGradeCode As %String;

/// 医院物价标准
Property CTRFCChargeStandard As %String;

/// 医院医保代码
Property CTRFCInsuCode As %String;

/// 系统创建日期
Property CTRFCCreateDate As %String;

/// 系统创建时间
Property CTRFCCreateTime As %String;

/// 系统创建人
Property CTRFCCreateUser As %String;

/// 系统排序号
Property CTRFCSeqNo As %String;

/// 系统最后更新日期
Property CTRFCLastUpdateDate As %String;

/// 系统最后更新时间
Property CTRFCLastUpdateTime As %String;

/// 系统最新更新人
Property CTRFCLastUpdateUser As %String;

/// 拼音码
Property CTRFCPYCode As %String;

/// 五笔码
Property CTRFCWBCode As %String;

/// 备注
Property CTRFCMark As %String;

}
