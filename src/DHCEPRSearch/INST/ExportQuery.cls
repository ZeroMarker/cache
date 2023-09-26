Class DHCEPRSearch.INST.ExportQuery Extends %Persistent
{

/// 用户ID
Property UserID As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

/// 归档就诊号
Property MREpisodeIDS As %String(TRUNCATE = 1) [ SqlColumnNumber = 3 ];

/// 病案号
Property MedRecordNoS As %String(TRUNCATE = 1) [ SqlColumnNumber = 4 ];

/// 出院开始时间
Property StartDisDate As %Date [ SqlColumnNumber = 5 ];

/// 出院结束时间
Property EndDisDate As %Date [ SqlColumnNumber = 6 ];

/// 出院科室
Property DisLocID As %String(TRUNCATE = 1) [ SqlColumnNumber = 7 ];

/// 多条件
Property Conditions As %String(TRUNCATE = 1) [ SqlColumnNumber = 8 ];

/// 结果列
Property ResultColumns As %String(TRUNCATE = 1) [ SqlColumnNumber = 9 ];

/// 结果列名称
Property ResultColumnsName As %String(TRUNCATE = 1) [ SqlColumnNumber = 10 ];

/// 搜索结果
Property ResultXMLStream As %GlobalCharacterStream(LOCATION = "^DHCEPRSearch.INST.ExportQueryS") [ SqlColumnNumber = 11 ];

/// 导出日期
Property ExportDate As %Date [ SqlColumnNumber = 12 ];

/// 导出时间
Property ExportTime As %Time [ SqlColumnNumber = 13 ];

/// 是否被用户使用
Property Used As %String [ SqlColumnNumber = 14 ];

Index IdxUserID On UserID;

Index IdxUserIDAndUsed On (UserID, Used);

Index IdxUserIDAndExportDateTime On (UserID, ExportDate, ExportTime);

Storage Default
{
<Data name="ExportQueryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>UserID</Value>
</Value>
<Value name="3">
<Value>MedRecordNo</Value>
</Value>
<Value name="4">
<Value>StartDisDate</Value>
</Value>
<Value name="5">
<Value>EndDisDate</Value>
</Value>
<Value name="6">
<Value>DisLocID</Value>
</Value>
<Value name="7">
<Value>Conditions</Value>
</Value>
<Value name="8">
<Value>ResultColumns</Value>
</Value>
<Value name="9">
<Value>ResultColumnsName</Value>
</Value>
<Value name="10">
<Value>ResultXMLStream</Value>
</Value>
<Value name="11">
<Value>ExportDate</Value>
</Value>
<Value name="12">
<Value>ExportTime</Value>
</Value>
<Value name="13">
<Value>MREpisodeID</Value>
</Value>
<Value name="14">
<Value>Used</Value>
</Value>
<Value name="15">
<Value>MREpisodeIDS</Value>
</Value>
<Value name="16">
<Value>MedRecordNoS</Value>
</Value>
</Data>
<DataLocation>^DHCEPRSearch.INST.ExportQueryD</DataLocation>
<DefaultData>ExportQueryDefaultData</DefaultData>
<IdLocation>^DHCEPRSearch.INST.ExportQueryD</IdLocation>
<IndexLocation>^DHCEPRSearch.INST.ExportQueryI</IndexLocation>
<StreamLocation>^DHCEPRSearch.INST.ExportQueryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
