/// Creator:谷雪萍
/// CreatDate:2022-08-03
/// Description：实施综合管理平台-字典对照-对接方中药字典表
/// Table：CT_WDT_CDSS.ConTCMDict
Class CT.WDT.CDSS.ConTCMDict Extends (%Persistent, User.Abstract)
{

/// 代码
Property TCMCode As %String [ Required ];

/// 通用名
Property TCMName As %String(MAXLEN = "");

/// 商品名
Property TCMTradeName As %String(MAXLEN = "") [ Required ];

/// 别名
Property TCMAlias As %String(MAXLEN = "");

/// 来源（住院/门诊/急诊）
Property Source As %String;

/// 厂家
Property Manufacturers As %String(MAXLEN = "");

/// 成分
Property TCMComposition As %String;

/// 剂型
Property DosageForm As %String;

/// 规格
Property Specification As %String;

/// 医院
Property HospitalDR As CT.WDT.CDSS.CustomerHosp;

/// 备注（医院自制药品/药监局未报批药品/非药品/原料药/药品名称不明确/中药饮片/耗材）
Property Remarks As %String;

/// 状态（未关联/已关联/已确认/已删除）
Property State As %String;

/// 创建时间（药品数据导入或者手动新增的时间）
Property CreateDate As %TimeStamp;

/// 创建人
Property CreateUser As %String;

/// 修改时间（对应的就是所有操作时间 包括删除 确认 关联 取消关联）
Property UpdateDate As %TimeStamp;

/// 修改人
Property UpdateUser As %String;

/// 开始日期	2021-9-3 阚延新 增加开始日期以及结束日期
Property StartDate As %Date;

/// 结束日期
Property EndDate As %Date;

/// 是否院方常用（1是，0否）
Property IsCommon As %Integer;

Index StateDescIndex On (State As Exact, TCMName As Exact);

Index HospCNIndex On (HospitalDR, TCMCode As Exact, TCMTradeName As Exact);

Index HospStateIndex On (HospitalDR, State As Exact);

Index CreateDateIndex On (HospitalDR, CreateDate As Exact);

Index UpdateDateIndex On (HospitalDR, UpdateDate As Exact);

Storage Default
{
<Data name="ConTCMDictDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TCMCode</Value>
</Value>
<Value name="3">
<Value>TCMName</Value>
</Value>
<Value name="4">
<Value>TCMTradeName</Value>
</Value>
<Value name="5">
<Value>TCMAlias</Value>
</Value>
<Value name="6">
<Value>Source</Value>
</Value>
<Value name="7">
<Value>Manufacturers</Value>
</Value>
<Value name="8">
<Value>TCMComposition</Value>
</Value>
<Value name="9">
<Value>DosageForm</Value>
</Value>
<Value name="10">
<Value>Specification</Value>
</Value>
<Value name="11">
<Value>HospitalDR</Value>
</Value>
<Value name="12">
<Value>Remarks</Value>
</Value>
<Value name="13">
<Value>State</Value>
</Value>
<Value name="14">
<Value>CreateDate</Value>
</Value>
<Value name="15">
<Value>CreateUser</Value>
</Value>
<Value name="16">
<Value>UpdateDate</Value>
</Value>
<Value name="17">
<Value>UpdateUser</Value>
</Value>
<Value name="18">
<Value>StartDate</Value>
</Value>
<Value name="19">
<Value>EndDate</Value>
</Value>
<Value name="20">
<Value>IsCommon</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.ConTCMDictD</DataLocation>
<DefaultData>ConTCMDictDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.ConTCMDictD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.ConTCMDictI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.ConTCMDictS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
