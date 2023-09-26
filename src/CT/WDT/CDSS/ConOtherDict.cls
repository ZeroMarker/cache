/// Creator:谷雪萍
/// CreatDate:2020-10-26
/// Description：实施综合管理平台-字典对照-对接方其他字典表
/// Table：CT.WDT.CDSS.ConOtherDict
Class CT.WDT.CDSS.ConOtherDict Extends (%Persistent, User.Abstract)
{

/// 代码
Property ProDictCode As %String [ Required ];

/// 描述
Property ProDictName As %String(MAXLEN = "") [ Required ];

/// 类型（除了药品、诊断、检验、检查、手术、护理以外的其他类型）
Property ProDictType As CT.WDT.CDSS.ConClassDict;

/// 来源（住院/门诊/急诊）
Property Source As %String;

/// 医院
Property HospitalDR As CT.WDT.CDSS.CustomerHosp;

/// 备注
Property Remarks As %String;

/// 状态（未关联/已关联/已确认/已删除）
Property State As %String;

/// 创建时间（药品数据导入或者手动新增的时间）
Property CreateDate As %TimeStamp;

/// 创建人
Property CreateUser As %String;

/// 修改时间（对应的就是所有操作时间,包括删除,确认,关联,取消关联）
Property UpdateDate As %TimeStamp;

/// 修改人
Property UpdateUser As %String;

/// 开始日期	2021-9-3 阚延新 增加开始日期以及结束日期
Property StartDate As %Date;

/// 结束日期
Property EndDate As %Date;

// Index HospCodeIndex On (ProDictType As Exact, HospitalDR As Exact, ProDictCode As Exact);

// Index HospNameIndex On (ProDictType As Exact, HospitalDR As Exact, ProDictName As Exact);

Index HospCNIndex On (ProDictType As Exact, HospitalDR As Exact, ProDictCode As Exact, ProDictName As Exact);

Index HospStateIndex On (ProDictType As Exact, HospitalDR, State As Exact);

Index CreateDateIndex On (ProDictType As Exact, HospitalDR, CreateDate As Exact);

Index UpdateDateIndex On (ProDictType As Exact, HospitalDR, UpdateDate As Exact);

Index StateDescIndex On (ProDictType As Exact, State As Exact, ProDictName As Exact);

Storage Default
{
<Data name="ConOtherDictDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ProDictCode</Value>
</Value>
<Value name="3">
<Value>ProDictName</Value>
</Value>
<Value name="4">
<Value>ProDictType</Value>
</Value>
<Value name="5">
<Value>Source</Value>
</Value>
<Value name="6">
<Value>HospitalDR</Value>
</Value>
<Value name="7">
<Value>Remarks</Value>
</Value>
<Value name="8">
<Value>State</Value>
</Value>
<Value name="9">
<Value>CreateDate</Value>
</Value>
<Value name="10">
<Value>CreateUser</Value>
</Value>
<Value name="11">
<Value>UpdateDate</Value>
</Value>
<Value name="12">
<Value>UpdateUser</Value>
</Value>
<Value name="13">
<Value>StartDate</Value>
</Value>
<Value name="14">
<Value>EndDate</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.ConOtherDictD</DataLocation>
<DefaultData>ConOtherDictDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.ConOtherDictD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.ConOtherDictI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.ConOtherDictS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
