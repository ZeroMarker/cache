Class User.DHCANOPPostOpAnalgesia Extends %Persistent [ Owner = {_PUBLIC}, SqlTableName = DHC_AN_OPPostOpAnalgesia ]
{

Property ArrangeId As DHCANOPArrange [ Required ];

Property Type As %String [ SqlColumnNumber = 2 ];

Property DataDate As %Date;

Property DataTime As %Time;

Property UpdateDate As %Date;

Property UpdateTime As %Time;

// VAS评分

Property VAS As %String;

// 镇痛效果

Property AnalgesiaEffect As %String;

// 副作用

Property SideEffect As %String;

// 镇痛类型

Property AnalgesiaType As %String;

// 恶心呕吐

Property NauseaAndVomiting As %String;

// 双下肢感觉、运动

Property LegsFeelAndMotion As %String;

// 呼吸抑制

Property RDepress As %String;

// 运动时VAS

Property VASMove As %String;

// 呕吐

Property Vomit As %String;

// 皮肤瘙痒

Property SkinItch As %String;

Index arrangeIdIndex On ArrangeId;

Index typeIndex On (Type, ArrangeId);

Index DateTimeIndex On (DataDate, DataTime, ArrangeId);

Index TypeDateTimeIndex On (Type, DataDate, DataTime, ArrangeId);

Storage Default
{
<Data name="DHCANOPPostOpAnalgesiaDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>VAS</Value>
</Value>
<Value name="3">
<Value>Effect</Value>
</Value>
<Value name="4">
<Value>SideEffec</Value>
</Value>
<Value name="5">
<Value>AnalgesiaType</Value>
</Value>
<Value name="6">
<Value>NauseaAndVomiting</Value>
</Value>
<Value name="7">
<Value>LegsFeelAndMotion</Value>
</Value>
<Value name="8">
<Value>RDepress</Value>
</Value>
<Value name="9">
<Value>ArrangeId</Value>
</Value>
<Value name="10">
<Value>Type</Value>
</Value>
<Value name="11">
<Value>DataDate</Value>
</Value>
<Value name="12">
<Value>DataTime</Value>
</Value>
<Value name="13">
<Value>UpdateDate</Value>
</Value>
<Value name="14">
<Value>UpdateTime</Value>
</Value>
<Value name="15">
<Value>AnalgesiaEffect</Value>
</Value>
<Value name="16">
<Value>SideEffect</Value>
</Value>
<Value name="17">
<Value>VASMove</Value>
</Value>
<Value name="18">
<Value>Vomit</Value>
</Value>
<Value name="19">
<Value>SkinItch</Value>
</Value>
</Data>
<DataLocation>^User.DHCANOPPostOpAnalgesiaD</DataLocation>
<DefaultData>DHCANOPPostOpAnalgesiaDefaultData</DefaultData>
<IdLocation>^User.DHCANOPPostOpAnalgesiaD</IdLocation>
<IndexLocation>^User.DHCANOPPostOpAnalgesiaI</IndexLocation>
<StreamLocation>^User.DHCANOPPostOpAnalgesiaS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
