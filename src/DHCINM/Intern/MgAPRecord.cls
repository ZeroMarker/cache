Class DHCINM.Intern.MgAPRecord Extends %Persistent
{

/// 标题
Property Title As %String [ SqlColumnNumber = 2, SqlFieldName = Record_Title ];

/// 批次
Property Batch As DHCINM.Intern.MgTransPlan [ SqlColumnNumber = 3, SqlFieldName = Record_Batch ];

/// 小组
Property Group As DHCINM.Intern.MgTransPlanGroup [ SqlColumnNumber = 4, SqlFieldName = Record_Group ];

/// 病区
Property Ward As CF.DHCINM.DB.MgWard [ SqlColumnNumber = 5, SqlFieldName = Record_Ward ];

/// 实习生姓名
Property Name As CF.DHCINM.HR.Persons [ SqlColumnNumber = 6, SqlFieldName = Record_Name ];

/// 是否关联病人
Property isRelate As %String [ SqlColumnNumber = 7, SqlFieldName = Record_isRelate ];

/// 病人就诊号
Property episodeID As %String [ SqlColumnNumber = 8, SqlFieldName = Record_episodeID ];

/// 病人床号
Property Bed As %String [ SqlColumnNumber = 9, SqlFieldName = Record_Bed ];

/// 病人姓名
Property PatName As %String [ SqlColumnNumber = 10, SqlFieldName = Record_PatName ];

/// 记录人
Property Recorder As %String [ SqlColumnNumber = 11, SqlFieldName = Recorder ];

/// 记录日期
Property RecordDate As %Date [ InitialExpression = {+$p($h,",",1)}, SqlColumnNumber = 12, SqlFieldName = Record_Date ];

/// 记录时间
Property RecordTime As %Time [ InitialExpression = {+$p($h,",",2)}, SqlColumnNumber = 13, SqlFieldName = Record_Time ];

/// 附件 (,)逗号间隔
Property RecordRefer As %String(MAXLEN = 100000) [ SqlColumnNumber = 14, SqlFieldName = Record_Refer ];

/// 内容说明
Property RecordContent As %String(MAXLEN = 100000) [ SqlColumnNumber = 15, SqlFieldName = Record_Content ];

/// 状态 (N 保存 Y 提交)
Property RecordStatus As %String [ SqlColumnNumber = 16, SqlFieldName = Record_Status ];

/// 类型 (R 表扬  P 批评 T 投诉)
Property RecordType As %String [ SqlColumnNumber = 17, SqlFieldName = Record_Type ];

Storage Default
{
<Data name="MgAPRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Title</Value>
</Value>
<Value name="3">
<Value>Batch</Value>
</Value>
<Value name="4">
<Value>Group</Value>
</Value>
<Value name="5">
<Value>Ward</Value>
</Value>
<Value name="6">
<Value>Name</Value>
</Value>
<Value name="7">
<Value>isRelate</Value>
</Value>
<Value name="8">
<Value>episodeID</Value>
</Value>
<Value name="9">
<Value>Bed</Value>
</Value>
<Value name="10">
<Value>PatName</Value>
</Value>
<Value name="11">
<Value>Recorder</Value>
</Value>
<Value name="12">
<Value>RecordDate</Value>
</Value>
<Value name="13">
<Value>RecordTime</Value>
</Value>
<Value name="14">
<Value>RecordRefer</Value>
</Value>
<Value name="15">
<Value>RecordContent</Value>
</Value>
<Value name="16">
<Value>RecordStatus</Value>
</Value>
<Value name="17">
<Value>RecordType</Value>
</Value>
</Data>
<DataLocation>^DHCINM.Intern.MgAPRecordD</DataLocation>
<DefaultData>MgAPRecordDefaultData</DefaultData>
<IdLocation>^DHCINM.Intern.MgAPRecordD</IdLocation>
<IndexLocation>^DHCINM.Intern.MgAPRecordI</IndexLocation>
<StreamLocation>^DHCINM.Intern.MgAPRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
