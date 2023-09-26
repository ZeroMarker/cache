Class User.EnsStatus Extends (%Persistent, %XML.Adaptor) [ SqlTableName = Ens_Status ]
{

/// 医嘱号
Property ESOrdItemID As %String(MAXLEN = 32767) [ SqlFieldName = ES_OrdItemID ];

/// 检查号（检验条码号、病理条码号
Property ESExamID As %String(MAXLEN = 32767) [ SqlFieldName = ES_ExamID ];

/// 检查部位描述（仅对于检查来说
Property ESExamPart As %String(MAXLEN = 32767) [ SqlFieldName = ES_ExamPart ];

/// 操作员工号
Property ESOperatorID As %String(MAXLEN = 32767) [ SqlFieldName = ES_OperatorID ];

/// 操作员描述
Property ESOperatorName As %String(MAXLEN = 32767) [ SqlFieldName = ES_OperatorName ];

/// 操作日期时间
Property ESOperateDate As %Date [ SqlFieldName = ES_OperateDate ];

/// 操作时间
Property ESOperateTime As %Time [ SqlFieldName = ES_OperateTime ];

/// 当前状态代码 对应表：Ens_StatusCode
Property ESStatusCode As %String(MAXLEN = 32767) [ SqlFieldName = ES_StatusCode ];

/// 系统代码 对应表：User.EnsSystem
Property ESSystemCode As %String(MAXLEN = 32767) [ SqlFieldName = ES_SystemCode ];

/// 是否正流程 Y是 N否
Property ESProcess As %String(MAXLEN = 32767) [ SqlFieldName = ES_Process ];

/// 有效标志（Y:启用；N:停用）
Property ESEffectiveFlag As %String [ SqlFieldName = ES_EffectiveFlag ];

/// 备注
Property ESNotes As %String(MAXLEN = 32767) [ SqlFieldName = ES_Notes ];

/// 操作科室代码
Property ESOperateDeptCode As %String(MAXLEN = 50) [ SqlFieldName = ES_OperateDeptCode ];

/// 操作科室代码
Property ESOperateDept As %String(MAXLEN = 200) [ SqlFieldName = ES_OperateDept ];

/// 报告ID
Property ESReportID As %String(COLLATION = "EXACT", MAXLEN = 50) [ SqlFieldName = ES_ReportID ];

Index IndexESOrdItemID On ESOrdItemID;

Index IndexESOrdItemIDExamID On (ESOrdItemID, ESExamID);

Index IndexESOrdItemIDPartID On (ESOrdItemID, ESExamPart);

Index IndexESOrdItemIDExamIDPartID On (ESOrdItemID, ESExamID, ESExamPart);

Index IndexESOrdItemIDExamIDRepID On (ESOrdItemID, ESExamID, ESReportID);

Index IndexESOrdItemIDExamIDRepPartID On (ESOrdItemID, ESExamID, ESReportID, ESExamPart);

Storage Default
{
<Data name="EnsStatusDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ESOrdItemID</Value>
</Value>
<Value name="3">
<Value>ESExamID</Value>
</Value>
<Value name="4">
<Value>ESExamPart</Value>
</Value>
<Value name="5">
<Value>ESOperatorID</Value>
</Value>
<Value name="6">
<Value>ESOperatorName</Value>
</Value>
<Value name="7">
<Value>ESOperateDate</Value>
</Value>
<Value name="8">
<Value>ESOperateTime</Value>
</Value>
<Value name="9">
<Value>ESStatusCode</Value>
</Value>
<Value name="10">
<Value>ESSystemCode</Value>
</Value>
<Value name="11">
<Value>ESProcess</Value>
</Value>
<Value name="12">
<Value>ESEffectiveFlag</Value>
</Value>
<Value name="13">
<Value>ESNotes</Value>
</Value>
<Value name="14">
<Value>ESOperateDeptCode</Value>
</Value>
<Value name="15">
<Value>ESOperateDept</Value>
</Value>
<Value name="16">
<Value>ESReportID</Value>
</Value>
</Data>
<DataLocation>^Busi.ENS.EnsStatusD</DataLocation>
<DefaultData>EnsStatusDefaultData</DefaultData>
<IdLocation>^Busi.ENS.EnsStatusD</IdLocation>
<IndexLocation>^Busi.ENS.EnsStatusI</IndexLocation>
<StreamLocation>^Busi.ENS.EnsStatusS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
