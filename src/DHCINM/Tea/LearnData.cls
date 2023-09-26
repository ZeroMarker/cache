/// Creator:lulin
/// Descriptions:学习资料库
/// Date:2020-07-28
Class DHCINM.Tea.LearnData Extends %Persistent
{

/// 类型
Property MaterialType As CT.DHCINM.DB.MgSetCodeSub [ SqlColumnNumber = 2, SqlFieldName = MaterialType ];

/// 名称
Property MaterialDesc As %String(MAXLEN = 1000) [ SqlColumnNumber = 3, SqlFieldName = MaterialDesc ];

/// 文件路径
Property MaterialUrl As list Of %String(MAXLEN = 200) [ SqlColumnNumber = 4, SqlFieldName = MaterialUrl ];

/// 适用病区
Property MaterialWard As %String(MAXLEN = 500) [ SqlColumnNumber = 5, SqlFieldName = MaterialWard ];

/// 不适用病区
Property MaterialNoWard As %String(MAXLEN = 500) [ SqlColumnNumber = 6, SqlFieldName = MaterialNoWard ];

/// 状态N：保存\S:提交\Y:审核
Property Status As %String [ SqlColumnNumber = 7, SqlFieldName = Status ];

/// 上传人
Property Creator As %String [ SqlColumnNumber = 8, SqlFieldName = Creator ];

/// 保存(上传)日期
Property CreateDate As %Date [ SqlColumnNumber = 9, SqlFieldName = CreateDate ];

/// 保存(上传)时间
Property CreateTime As %Time [ SqlColumnNumber = 10, SqlFieldName = CreateTime ];

/// 审核人
Property Submitor As %String [ SqlColumnNumber = 11, SqlFieldName = Submitor ];

/// 审核(发布)日期
Property SubmitDate As %Date [ SqlColumnNumber = 12, SqlFieldName = SubmitDate ];

/// 审核(发布)时间
Property SubmitTime As %Time [ SqlColumnNumber = 13, SqlFieldName = SubmitTime ];

/// 下载次数
Property UploadNum As %String [ SqlColumnNumber = 14, SqlFieldName = UploadNum ];

/// 文件大小
Property FileSize As %String [ SqlColumnNumber = 15, SqlFieldName = FileSize ];

Storage Default
{
<Data name="LearnDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MaterialType</Value>
</Value>
<Value name="3">
<Value>MaterialDesc</Value>
</Value>
<Value name="4">
<Value>MaterialUrl</Value>
</Value>
<Value name="5">
<Value>MaterialWard</Value>
</Value>
<Value name="6">
<Value>MaterialNoWard</Value>
</Value>
<Value name="7">
<Value>Status</Value>
</Value>
<Value name="8">
<Value>Creator</Value>
</Value>
<Value name="9">
<Value>CreateDate</Value>
</Value>
<Value name="10">
<Value>CreateTime</Value>
</Value>
<Value name="11">
<Value>Submitor</Value>
</Value>
<Value name="12">
<Value>SubmitDate</Value>
</Value>
<Value name="13">
<Value>SubmitTime</Value>
</Value>
<Value name="14">
<Value>UploadNum</Value>
</Value>
<Value name="15">
<Value>FileSize</Value>
</Value>
</Data>
<DataLocation>^DHCINM.Tea.LearnDataD</DataLocation>
<DefaultData>LearnDataDefaultData</DefaultData>
<IdLocation>^DHCINM.Tea.LearnDataD</IdLocation>
<IndexLocation>^DHCINM.Tea.LearnDataI</IndexLocation>
<StreamLocation>^DHCINM.Tea.LearnDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
