Class User.DHCANTimeLine Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = ANTL_RowId, SqlTableName = DHC_AN_TimeLine, StorageStrategy = TimeLineStorage ]
{

/// 手术申请排班ID
Property ANTLOPADR As DHCANOPArrange [ Required, SqlColumnNumber = 2, SqlFieldName = ANTL_OPA_DR ];

Index OPA On ANTLOPADR;

/// 缩放时间段的开始日期
Property ANTLStartDate As %Date [ Required, SqlColumnNumber = 3, SqlFieldName = ANTL_StartDate ];

/// 缩放时间段的开始时间
Property ANTLStartTime As %Time [ Required, SqlColumnNumber = 4, SqlFieldName = ANTL_StartTime ];

/// 缩放时间段的结束日期
Property ANTLEndDate As %Date [ SqlColumnNumber = 5, SqlFieldName = ANTL_EndDate ];

/// 缩放时间段的结束时间
Property ANTLEndTime As %Time [ SqlColumnNumber = 6, SqlFieldName = ANTL_EndTime ];

/// 缩放时间段每列表示多少分钟
Property ANTLMinutesPerColumn As %Integer [ Required, SqlColumnNumber = 7, SqlFieldName = ANTL_MinutesPerColumn ];

/// 缩放时间段的更新日期
Property ANTLUpdateDate As %Date [ SqlColumnNumber = 8, SqlFieldName = ANTL_UpdateDate ];

/// 缩放时间段的更新时间
Property ANTLUpdateTime As %Time [ SqlColumnNumber = 9, SqlFieldName = ANTL_UpdateTime ];

/// 缩放时间段的编辑标志
Property ANTLEditFlag As %String [ SqlColumnNumber = 10, SqlFieldName = ANTL_EditFlag ];

/// 缩放时间段关联的文档类型(代码)
Property ANTLDocumentType As %String [ SqlColumnNumber = 11, SqlFieldName = ANTL_DocumentType ];

/// 缩放时间段操作用户ID
Property ANTLUserDR As %String [ SqlColumnNumber = 12, SqlFieldName = ANTL_User_DR ];

Storage TimeLineStorage
{
<Data name="DHCANTimeLineDefaultData">
<Subscript>"1"</Subscript>
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<Data name="DataMaster">
<Value name="1">
<Value>ANTLOPADR</Value>
</Value>
<Value name="2">
<Value>ANTLStartDate</Value>
</Value>
<Value name="3">
<Value>ANTLStartTime</Value>
</Value>
<Value name="4">
<Value>ANTLEndDate</Value>
</Value>
<Value name="5">
<Value>ANTLEndTime</Value>
</Value>
<Value name="6">
<Value>ANTLMinutesPerColumn</Value>
</Value>
<Value name="7">
<Value>ANTLEditFlag</Value>
</Value>
<Value name="8">
<Value>ANTLDocumentType</Value>
</Value>
<Value name="9">
<Value>ANTLUserDR</Value>
</Value>
<Value name="10">
<Value>ANTLUpdateDate</Value>
</Value>
<Value name="11">
<Value>ANTLUpdateTime</Value>
</Value>
</Data>
<DataLocation>^DHCANTimeLine</DataLocation>
<DefaultData>DHCANTimeLineDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCANTimeLine</IdLocation>
<IndexLocation>^DHCANTimeLine(0)</IndexLocation>
<SqlRowIdName>ANTL_RowId</SqlRowIdName>
<StreamLocation>^User.DHCANTimeLineS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
