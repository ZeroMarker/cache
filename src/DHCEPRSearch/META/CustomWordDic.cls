Class DHCEPRSearch.META.CustomWordDic Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 词
Property Word As %String(TRUNCATE = 1);

/// 是否废词
Property IsAvailable As %String(TRUNCATE = 1);

/// 加入本表格日期
Property DateInput As %Date;

/// 加入本表格时间
Property TimeInput As %Time;

/// 词频
Property WordFrequency As %Integer;

/// 词频更新日期
Property DateUpdate As %Date;

/// 词频更新时间
Property TimeUpdate As %Time;

/// 是否加入词库
Property InputLexicon As %String(TRUNCATE = 1);

/// 加入词库日期
Property DateLexicon As %Date;

/// 加入词库时间
Property TimeLexicon As %Time;

Index IdxWord On Word;

Storage Default
{
<Data name="CustomWordDicDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Word</Value>
</Value>
<Value name="3">
<Value>IsAvailable</Value>
</Value>
<Value name="4">
<Value>DateInput</Value>
</Value>
<Value name="5">
<Value>TimeInput</Value>
</Value>
<Value name="6">
<Value>WordFrequency</Value>
</Value>
<Value name="7">
<Value>DateUpdate</Value>
</Value>
<Value name="8">
<Value>TimeUpdate</Value>
</Value>
<Value name="9">
<Value>InputLexicon</Value>
</Value>
<Value name="10">
<Value>DateLexicon</Value>
</Value>
<Value name="11">
<Value>TimeLexicon</Value>
</Value>
</Data>
<DataLocation>^DHCEPRSearch.META.CustomWordDicD</DataLocation>
<DefaultData>CustomWordDicDefaultData</DefaultData>
<IdLocation>^DHCEPRSearch.META.CustomWordDicD</IdLocation>
<IndexLocation>^DHCEPRSearch.META.CustomWordDicI</IndexLocation>
<StreamLocation>^DHCEPRSearch.META.CustomWordDicS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
