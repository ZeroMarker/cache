/// Creator:谷雪萍
/// CreatDate:2022-01-25
/// Description：中医疾病关联属性表
/// Table：CT_WDT_CDSS.TCMDiseJProperty
Class CT.WDT.CDSS.TCMDiseJProperty Extends (%Persistent, User.Abstract)
{

/// 中医疾病表DR
Property TCMDiseDR As CT.WDT.CDSS.TCMDisease [ Required ];

/// 性别限制（无，男，女）
Property SexLimit As %String;

/// 高发性别（无，男，女）
Property PopuSex As %String;

/// 年龄限制（0无，1有）
Property AgeLimit As %Integer;

/// 年龄限制最小值
Property AgeLimitMin As %Integer;

/// 年龄限制最小值单位（天，月，岁）
Property AgeLimitMinUnit As %String;

/// 是否包含年龄限制最小值（0否，1是）
Property IsIncludeAgeLimitMin As %Integer;

/// 年龄限制最大值
Property AgeLimitMax As %Integer;

/// 年龄限制最大值单位（天，月，岁）
Property AgeLimitMaxUnit As %String;

/// 是否包含年龄限制最大值（0否，1是）
Property IsIncludeAgeLimitMax As %Integer;

/// 高发年龄段（0无，1有）
Property PopuAge As %Integer;

/// 高发年龄段最小值
Property PopuAgeMin As %Integer;

/// 高发年龄段最小值单位（天，月，岁）
Property PopuAgeMinUnit As %String;

/// 是否包含高发年龄段最小值（0否，1是）
Property IsIncludePopuAgeMin As %Integer;

/// 高发年龄段最大值
Property PopuAgeMax As %Integer;

/// 高发年龄段最大值单位（天，月，岁）
Property PopuAgeMaxUnit As %String;

/// 是否包含高发年龄段最大值（0否，1是）
Property IsIncludePopuAgeMax As %Integer;

/// 常见科室（科室id串）User.DHCDSSDiseaseDeptDict
Property CommonDept As %String;

/// 是否急危重症（0否，1是）
Property IsEmergency As %Integer;

/// 高发种族（找到实例之后再说，目前是文本）
Property PopuNation As %String;

/// 高发地区（找到实例之后再说，目前是文本）
Property PopuRegion As %String;

/// 部位（部位id串）User.DHCDSSBodyParDict
Property Parts As %String;

/// 流行季节最小值
Property PopuSeasonMin As %Integer;

/// 流行季节最大值
Property PopuSeasonMax As %Integer;

/// 应用版本（全部、住院、门诊）
Property AppliVersion As %String;

/// 最后操作时间（诊断因子与属性新增修改时自动更新时间）
Property UpdateDate As %TimeStamp;

/// 责任人（针对诊断因子与属性）
Property ResponUser As %String;

/// 审核人（针对诊断因子与属性）
Property ReviewUser As %String;

/// 状态（初始、编辑中、待审核、审核不通过、已上线、已下线，默认初始）
Property Status As %String;

/// 备注
Property Remarks As %String(MAXLEN = "");

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

Index DiseDRIndex On TCMDiseDR;

Storage Default
{
<Data name="TCMDiseJPropertyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TCMDiseDR</Value>
</Value>
<Value name="3">
<Value>SexLimit</Value>
</Value>
<Value name="4">
<Value>PopuSex</Value>
</Value>
<Value name="5">
<Value>AgeLimit</Value>
</Value>
<Value name="6">
<Value>AgeLimitMin</Value>
</Value>
<Value name="7">
<Value>AgeLimitMinUnit</Value>
</Value>
<Value name="8">
<Value>IsIncludeAgeLimitMin</Value>
</Value>
<Value name="9">
<Value>AgeLimitMax</Value>
</Value>
<Value name="10">
<Value>AgeLimitMaxUnit</Value>
</Value>
<Value name="11">
<Value>IsIncludeAgeLimitMax</Value>
</Value>
<Value name="12">
<Value>PopuAge</Value>
</Value>
<Value name="13">
<Value>PopuAgeMin</Value>
</Value>
<Value name="14">
<Value>PopuAgeMinUnit</Value>
</Value>
<Value name="15">
<Value>IsIncludePopuAgeMin</Value>
</Value>
<Value name="16">
<Value>PopuAgeMax</Value>
</Value>
<Value name="17">
<Value>PopuAgeMaxUnit</Value>
</Value>
<Value name="18">
<Value>IsIncludePopuAgeMax</Value>
</Value>
<Value name="19">
<Value>CommonDept</Value>
</Value>
<Value name="20">
<Value>IsEmergency</Value>
</Value>
<Value name="21">
<Value>PopuNation</Value>
</Value>
<Value name="22">
<Value>PopuRegion</Value>
</Value>
<Value name="23">
<Value>Parts</Value>
</Value>
<Value name="24">
<Value>PopuSeasonMin</Value>
</Value>
<Value name="25">
<Value>PopuSeasonMax</Value>
</Value>
<Value name="26">
<Value>AppliVersion</Value>
</Value>
<Value name="27">
<Value>UpdateDate</Value>
</Value>
<Value name="28">
<Value>ResponUser</Value>
</Value>
<Value name="29">
<Value>ReviewUser</Value>
</Value>
<Value name="30">
<Value>Status</Value>
</Value>
<Value name="31">
<Value>Remarks</Value>
</Value>
<Value name="32">
<Value>NumOfNConditions</Value>
</Value>
<Value name="33">
<Value>AgeLimitMinDays</Value>
</Value>
<Value name="34">
<Value>AgeLimitMaxDays</Value>
</Value>
<Value name="35">
<Value>PopuAgeMinDays</Value>
</Value>
<Value name="36">
<Value>PopuAgeMaxDays</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.TCMDiseJPropertyD</DataLocation>
<DefaultData>TCMDiseJPropertyDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.TCMDiseJPropertyD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.TCMDiseJPropertyI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.TCMDiseJPropertyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
