Class DHCEPRSearch.INST.CustomWordDicLog Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 用户ID
Property UserID As %String(TRUNCATE = 1);

/// 科室ID
Property CTLocID As %String(TRUNCATE = 1);

/// 安全组
Property SSGroupID As %String(TRUNCATE = 1);

/// 词
Property Word As %String(TRUNCATE = 1);

/// 加入日期
Property DateInput As %Date;

/// 加入时间
Property TimeInput As %Time;

/// 表CustomWordDic的rowID
Property CustomWordDicID As %String(TRUNCATE = 1);

Index IdxWord On Word;

Storage Default
{
<Data name="CustomWordDicLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>UserID</Value>
</Value>
<Value name="3">
<Value>CTLocID</Value>
</Value>
<Value name="4">
<Value>SSGroupID</Value>
</Value>
<Value name="5">
<Value>Word</Value>
</Value>
<Value name="6">
<Value>DateInput</Value>
</Value>
<Value name="7">
<Value>TimeInput</Value>
</Value>
<Value name="8">
<Value>CustomWordDicID</Value>
</Value>
</Data>
<DataLocation>^DHCEPRSearch.INST.WordDicLogD</DataLocation>
<DefaultData>CustomWordDicLogDefaultData</DefaultData>
<IdLocation>^DHCEPRSearch.INST.WordDicLogD</IdLocation>
<IndexLocation>^DHCEPRSearch.INST.WordDicLogI</IndexLocation>
<StreamLocation>^DHCEPRSearch.INST.WordDicLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
