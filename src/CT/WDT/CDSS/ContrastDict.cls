/// Creator:钟荣枫
/// CreatDate:2020-12-22
/// Description：实施综合管理平台-字典对照-字典对照表
/// Table：CT.WDT.CDSS.ContrastDict
Class CT.WDT.CDSS.ContrastDict Extends (%Persistent, User.Abstract)
{

/// 知识库字典代码
Property DictCode As %String(MAXLEN = "") [ Required ];

/// 知识库字典描述
Property DictName As %String(MAXLEN = "") [ Required ];

/// 对照类型(药品，诊断，检查检验，手术，护理）
Property ContrastType As %String [ Required ];

/// 对接方字典代码
Property ConDictCode As %String(MAXLEN = "") [ Required ];

/// 对接方字典描述
Property ConDictName As %String(MAXLEN = "") [ Required ];

/// 状态（未关联/已关联/已确认/已删除）
Property State As %String [ Required ];

/// 医院
Property HospitalDR As CT.WDT.CDSS.CustomerHosp [ Required ];

/// 备注
Property Remarks As %String;

/// CDSS字典DR	2021-5-31 zrf 增加知识库id和对接方id，以确定唯一
Property DictDR As %String(MAXLEN = "");

/// 对接方字典DR
Property IntDictDR As %String [ Required ];

Index IntDictDRIndex On (ContrastType As Exact, IntDictDR As Exact);

Index DictDRStateIndex On (HospitalDR As Exact, ContrastType As Exact, DictDR As Exact, State As Exact);

Index IntStateIndex On (HospitalDR As Exact, ContrastType As Exact, IntDictDR As Exact, State As Exact);

Index IntDictDescIndex On (HospitalDR As Exact, ContrastType As Exact, ConDictName As Exact);

Index IntDictCodeIndex On (HospitalDR As Exact, ContrastType As Exact, ConDictCode As Exact);

Index IntDictCDIndex On (HospitalDR As Exact, ContrastType As Exact, ConDictCode As Exact, ConDictName As Exact);

Index DictDRIndex On (HospitalDR As Exact, ContrastType As Exact, DictDR As Exact);

Index DictNameStateIndex On (HospitalDR As Exact, ContrastType As Exact, DictName As Exact, State As Exact);

Index HoapIntDictDRIndex On (HospitalDR As Exact, ContrastType As Exact, IntDictDR As Exact);

Index NameIndex On (ContrastType As Exact, IntDictDR As Exact, DictName As Exact);

Storage Default
{
<Data name="ContrastDictDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DictCode</Value>
</Value>
<Value name="3">
<Value>DictName</Value>
</Value>
<Value name="4">
<Value>ContrastType</Value>
</Value>
<Value name="5">
<Value>ConDictCode</Value>
</Value>
<Value name="6">
<Value>ConDictName</Value>
</Value>
<Value name="7">
<Value>State</Value>
</Value>
<Value name="8">
<Value>HospitalDR</Value>
</Value>
<Value name="9">
<Value>Remarks</Value>
</Value>
<Value name="10">
<Value>DictDR</Value>
</Value>
<Value name="11">
<Value>IntDictDR</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.ContrastDictD</DataLocation>
<DefaultData>ContrastDictDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.ContrastDictD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.ContrastDictI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.ContrastDictS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
