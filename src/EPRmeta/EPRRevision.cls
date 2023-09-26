/// Desc: 留痕功能支持指定模板以指定状态开始留痕功能。比如，可以配置会诊记录在保存完成之后即开启留痕功能，未配置的记录则按照默认规则留痕（即提交之后开启留痕功能）。
/// 		配置方式：insert into eprmeta.eprrevision values ('会诊记录','709','|finished|commited|attendingChecked|chiefChecked|')
/// 		三个参数分别为：描述，打印模板DocID,开启留痕的状态（多个状态之间以|分割），如上所示为：会诊记录在完成、提交、主治医师审核、主任医师审核状态下均开启留痕。
Class EPRmeta.EPRRevision Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property Description As %String(TRUNCATE = 1) [ Required, SqlColumnNumber = 2 ];

Property EPRDocID As %String(TRUNCATE = 1) [ Required, SqlColumnNumber = 3 ];

Property EPRStatus As %String(MAXLEN = 100, TRUNCATE = 1) [ Required, SqlColumnNumber = 4 ];

Index IdxEPRDocID On EPRDocID [ Unique ];

Index IdxEPRDocIDAndEPRStatus On (EPRDocID, EPRStatus);

Storage Default
{
<Data name="EPRRevisionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>EPRDocID</Value>
</Value>
<Value name="4">
<Value>EPRStatus</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.EPRRevisionD</DataLocation>
<DefaultData>EPRRevisionDefaultData</DefaultData>
<IdLocation>^DHCEPRM.EPRRevisionD</IdLocation>
<IndexLocation>^DHCEPRM.EPRRevisionI</IndexLocation>
<StreamLocation>^DHCEPRM.EPRRevisionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
