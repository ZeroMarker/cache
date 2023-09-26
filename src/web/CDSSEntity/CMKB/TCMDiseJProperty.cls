/// Creator:胡宜良
/// CreatDate:2022-02-10
/// Description：中医疾病关联属性表
Class web.CDSSEntity.CMKB.TCMDiseJProperty Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.TCMDiseJProperty";

Property RowId As %String;

/// 中医疾病表DR
Property TCMDiseDR As %String;

/// 性别限制（无，男，女）
Property SexLimit As %String;

/// 高发性别（无，男，女）
Property PopuSex As %String;

/// 年龄限制（0无，1有）
Property AgeLimit As %String;

/// 年龄限制最小值
Property AgeLimitMin As %String;

/// 年龄限制最小值单位（天，月，岁）
Property AgeLimitMinUnit As %String;

/// 是否包含年龄限制最小值（0否，1是）
Property IsIncludeAgeLimitMin As %String;

/// 年龄限制最大值
Property AgeLimitMax As %String;

/// 年龄限制最大值单位（天，月，岁）
Property AgeLimitMaxUnit As %String;

/// 是否包含年龄限制最大值（0否，1是）
Property IsIncludeAgeLimitMax As %String;

/// 高发年龄段（0无，1有）
Property PopuAge As %String;

/// 高发年龄段最小值
Property PopuAgeMin As %String;

/// 高发年龄段最小值单位（天，月，岁）
Property PopuAgeMinUnit As %String;

/// 是否包含高发年龄段最小值（0否，1是）
Property IsIncludePopuAgeMin As %String;

/// 高发年龄段最大值
Property PopuAgeMax As %String;

/// 高发年龄段最大值单位（天，月，岁）
Property PopuAgeMaxUnit As %String;

/// 是否包含高发年龄段最大值（0否，1是）
Property IsIncludePopuAgeMax As %String;

/// 常见科室（科室id串）User.DHCDSSDiseaseDeptDict
Property CommonDept As %String;

/// 是否急危重症（0否，1是）
Property IsEmergency As %String;

/// 高发种族（找到实例之后再说，目前是文本）
Property PopuNation As %String;

/// 高发地区（找到实例之后再说，目前是文本）
Property PopuRegion As %String;

/// 部位（部位id串）User.DHCDSSBodyParDict
Property Parts As %String;

/// 流行季节最小值
Property PopuSeasonMin As %String;

/// 流行季节最大值
Property PopuSeasonMax As %String;

/// 应用版本（全部、住院、门诊）
Property AppliVersion As %String;

/// 最后操作时间（诊断因子与属性新增修改时自动更新时间）
Property UpdateDate As %String;

/// 责任人（针对诊断因子与属性）
Property ResponUser As %String;

/// 审核人（针对诊断因子与属性）
Property ReviewUser As %String;

/// 状态（初始、编辑中、待审核、不通过、上线、已下线，默认初始）
Property Status As %String;

/// 备注
Property Remarks As %String;

/// 常见科室多选
Property CommonDepts As %String;

/// 部位多选
Property Partss As %String;

/// 前台传的操作人
Property OperationUser As %String;

/// 疾病关联诊断因子必要条件个数
Property NumOfNConditions As %Integer;

/// 年龄限制最小值（天）
Property AgeLimitMinDays As %String;

/// 年龄限制最大值（天）
Property AgeLimitMaxDays As %String;

/// 高发年龄段最小值（天）
Property PopuAgeMinDays As %String;

/// 高发年龄段最大值（天）
Property PopuAgeMaxDays As %String;

}
