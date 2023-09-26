/// CTOR: QP
/// DATE: 2018-04-04
/// DESC: 潍坊市人民医院：CQMX / TGC 使用信息表
Class DHCAnt.Base.CQMX Extends %Persistent
{

/// 就诊id
Property admid As %String [ SqlColumnNumber = 2 ];

/// 科室id
Property locid As %String [ SqlColumnNumber = 3 ];

/// 医嘱项
Property arcim As %String [ SqlColumnNumber = 4 ];

/// 病人信息表id
Property patid As %String [ SqlColumnNumber = 5 ];

/// 用药主诊断
Property diagnosis As %String [ SqlColumnNumber = 6 ];

/// 用法
Property useid As %String [ SqlColumnNumber = 7 ];

/// 是否会诊
Property isConsult As %String [ SqlColumnNumber = 8 ];

/// 是否送检
Property isLab As %String [ SqlColumnNumber = 9 ];

/// 是否紧急使用
Property isEmergency As %String [ SqlColumnNumber = 10 ];

/// 处方医师
Property prescDoc As %String [ SqlColumnNumber = 11 ];

/// 处方日期
Property prescDate As %Date [ SqlColumnNumber = 12 ];

/// 处方时间
Property prescTime As %Time [ SqlColumnNumber = 13 ];

/// 病历号
Property ipNo As %String [ SqlColumnNumber = 14 ];

/// 类型：1代表CQMX 2代表TGC
Property type As %String [ SqlColumnNumber = 15 ];

/// 诊断描述
Property diagNosisDesc As %String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 16 ];

/// 使用目的
Property aimId As %String [ SqlColumnNumber = 17 ];

Index prescDate On prescDate As AlphaUp;

Index locid On locid As AlphaUp;

Index type On type As AlphaUp;

Storage Default
{
<Data name="CQMXDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>admid</Value>
</Value>
<Value name="3">
<Value>locid</Value>
</Value>
<Value name="4">
<Value>arcim</Value>
</Value>
<Value name="5">
<Value>patid</Value>
</Value>
<Value name="6">
<Value>diagnosis</Value>
</Value>
<Value name="7">
<Value>useid</Value>
</Value>
<Value name="8">
<Value>isConsult</Value>
</Value>
<Value name="9">
<Value>isLab</Value>
</Value>
<Value name="10">
<Value>isEmergency</Value>
</Value>
<Value name="11">
<Value>prescDoc</Value>
</Value>
<Value name="12">
<Value>prescDate</Value>
</Value>
<Value name="13">
<Value>prescTime</Value>
</Value>
<Value name="14">
<Value>ipNo</Value>
</Value>
<Value name="15">
<Value>type</Value>
</Value>
<Value name="16">
<Value>diagNosisDesc</Value>
</Value>
<Value name="17">
<Value>aimId</Value>
</Value>
</Data>
<DataLocation>^DHCAnt.Base.CQMXD</DataLocation>
<DefaultData>CQMXDefaultData</DefaultData>
<IdLocation>^DHCAnt.Base.CQMXD</IdLocation>
<IndexLocation>^DHCAnt.Base.CQMXI</IndexLocation>
<StreamLocation>^DHCAnt.Base.CQMXS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
