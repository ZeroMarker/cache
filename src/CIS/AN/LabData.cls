/// 检验数据
Class CIS.AN.LabData Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = LabData ]
{

/// 病人就诊ID
Property EpisodeID As %String [ Required, SqlColumnNumber = 2 ];

/// 检验结果的唯一标识
Property LabResultNo As %String [ SqlColumnNumber = 3 ];

/// 检验项目代码
Property TestCode As %String [ SqlColumnNumber = 4 ];

/// 检验项目名称
Property TestCodeDesc As %String(MAXLEN = 500) [ SqlColumnNumber = 5 ];

/// 检验标本号
Property LabNo As %String [ SqlColumnNumber = 6 ];

/// 医嘱标识
Property OeoriCode As %String [ SqlColumnNumber = 7 ];

/// 标本类型代码
Property SpecimenCode As %String [ SqlColumnNumber = 8 ];

/// 采样日期
Property CollectDate As %Date [ SqlColumnNumber = 9 ];

/// 采样时间
Property CollectTime As %Time [ SqlColumnNumber = 10 ];

/// 接收标本日期
Property ReceivedDate As %Date [ SqlColumnNumber = 11 ];

/// 接收标本时间
Property ReceivedTime As %Time [ SqlColumnNumber = 12 ];

/// 检验报告日期
Property ResultDate As %Date [ SqlColumnNumber = 13 ];

/// 检验报告时间
Property ResultTime As %Time [ SqlColumnNumber = 14 ];

/// 检验结果
Property TestResult As %String(MAXLEN = 2000) [ SqlColumnNumber = 15 ];

/// 检验结果单位代码
Property TestResultUnitCode As %String [ SqlColumnNumber = 16 ];

/// 检验结果正常值范围
Property TestResultRange As %String(MAXLEN = 500) [ SqlColumnNumber = 17 ];

/// 检验结论
Property TestConclusion As %String(MAXLEN = 500) [ SqlColumnNumber = 18 ];

/// 检验科室代码
Property LabLocCode As %String [ SqlColumnNumber = 19 ];

Property MedcareNo As %String [ SqlColumnNumber = 20 ];

/// 检验医嘱名称
Property TestClassName As %String(MAXLEN = 500) [ SqlColumnNumber = 21 ];

/// 就诊ID索引
Index IEpisodeID On EpisodeID;

/// 住院号索引
Index IMedcareNo On MedcareNo;

/// 就诊ID，检验项目代码索引
Index IAdmCode On (EpisodeID, TestCode);

/// 就诊ID，检验项目代码名称索引
Index IAdmDesc On (EpisodeID, TestCodeDesc);

/// 住院号、检验项目代码索引
Index IMedCode On (MedcareNo, TestCode);

/// 住院号、检验项目名称索引
Index IMedDesc On (MedcareNo, TestCodeDesc);

/// 住院号、检验项目分类索引
Index IMedClassName On (MedcareNo, TestClassName);

/// 外部系统ID索引
Index IExt On LabResultNo;

/// 检验报告日期索引
Index IResultDate On ResultDate;

Storage Default
{
<Data name="LabDataDefaultData">
<Value name="1">
<Value>EpisodeID</Value>
</Value>
<Value name="2">
<Value>LabResultNo</Value>
</Value>
<Value name="3">
<Value>TestCode</Value>
</Value>
<Value name="4">
<Value>TestCodeDesc</Value>
</Value>
<Value name="5">
<Value>LabNo</Value>
</Value>
<Value name="6">
<Value>OeoriCode</Value>
</Value>
<Value name="7">
<Value>SpecimenCode</Value>
</Value>
<Value name="8">
<Value>CollectDate</Value>
</Value>
<Value name="9">
<Value>CollectTime</Value>
</Value>
<Value name="10">
<Value>ReceivedDate</Value>
</Value>
<Value name="11">
<Value>ReceivedTime</Value>
</Value>
<Value name="12">
<Value>ResultDate</Value>
</Value>
<Value name="13">
<Value>ResultTime</Value>
</Value>
<Value name="14">
<Value>TestResult</Value>
</Value>
<Value name="15">
<Value>TestResultUnitCode</Value>
</Value>
<Value name="16">
<Value>TestResultRange</Value>
</Value>
<Value name="17">
<Value>TestConclusion</Value>
</Value>
<Value name="18">
<Value>LabLocCode</Value>
</Value>
<Value name="19">
<Value>MedcareNo</Value>
</Value>
<Value name="20">
<Value>TestClassName</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.LabDataD</DataLocation>
<DefaultData>LabDataDefaultData</DefaultData>
<IdLocation>^CIS.AN.LabDataD</IdLocation>
<IndexLocation>^CIS.AN.LabDataI</IndexLocation>
<StreamLocation>^CIS.AN.LabDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
