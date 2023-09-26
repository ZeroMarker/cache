Class CHSS.PersonDeathInvest Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = InvestRowId, SqlTableName = PersonDeathInvest ]
{

/// 个人档案主键	
Property PersonRowId As CHSS.PersonHealthRecordMain [ Required ];

/// 死者生前病史及症状体征	
Property Symptom As %String(MAXLEN = 200, TRUNCATE = 1);

/// 被调查者姓名	
Property Informan As %String(MAXLEN = 50, TRUNCATE = 1);

/// 与死者关系	
Property Relationship As %String(MAXLEN = 30, TRUNCATE = 1);

/// 联系地址或工作单位	
Property InformanTAddr As %String(MAXLEN = 40, TRUNCATE = 1);

/// 被调查者电话号码	
Property InformanTTEL As %String(MAXLEN = 30, TRUNCATE = 1);

/// 死因推断	
Property DeathReason As %String(MAXLEN = 50, TRUNCATE = 1);

/// 调查者签名	
Property Investigator As %String(MAXLEN = 50, TRUNCATE = 1);

/// 调查日期	
Property InvestigateDate As %Date(FORMAT = 1);

/// 卡片状态	
Property Flage As CHSS.DictArchivesStatus;

/// 审核时间	
Property ValidDate As %Date(FORMAT = 1);

/// 录入时间	
Property InTime As %Date(FORMAT = 1);

Index PersonRowIdIndex On PersonRowId;

Storage Default
{
<Data name="PersonDeathInvestDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DeathReasonAs</Value>
</Value>
<Value name="3">
<Value>Flage</Value>
</Value>
<Value name="4">
<Value>InTime</Value>
</Value>
<Value name="5">
<Value>InformanAs</Value>
</Value>
<Value name="6">
<Value>InformanTAddrAs</Value>
</Value>
<Value name="7">
<Value>InformanTTELAs</Value>
</Value>
<Value name="8">
<Value>InvestigateDate</Value>
</Value>
<Value name="9">
<Value>InvestigatorAs</Value>
</Value>
<Value name="10">
<Value>PersonRowId</Value>
</Value>
<Value name="11">
<Value>RelationshipAs</Value>
</Value>
<Value name="12">
<Value>SymptomAs</Value>
</Value>
<Value name="13">
<Value>ValidDate</Value>
</Value>
<Value name="14">
<Value>DeathReason</Value>
</Value>
<Value name="15">
<Value>Informan</Value>
</Value>
<Value name="16">
<Value>InformanTAddr</Value>
</Value>
<Value name="17">
<Value>InformanTTEL</Value>
</Value>
<Value name="18">
<Value>Investigator</Value>
</Value>
<Value name="19">
<Value>Relationship</Value>
</Value>
<Value name="20">
<Value>Symptom</Value>
</Value>
</Data>
<DataLocation>^CHSS.PersonDeathInvestD</DataLocation>
<DefaultData>PersonDeathInvestDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.PersonDeathInvestD</IdLocation>
<IndexLocation>^CHSS.PersonDeathInvestI</IndexLocation>
<StreamLocation>^CHSS.PersonDeathInvestS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
