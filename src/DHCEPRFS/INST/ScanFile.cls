Class DHCEPRFS.INST.ScanFile Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 扫描类型 (I/O) 住院/门诊
Property Type As %String(TRUNCATE = 1);

/// 就诊号
Property EpisodeID As %String(TRUNCATE = 1);

/// 文件名
Property FileName As %String(MAXLEN = 100, TRUNCATE = 1);

/// FileMasterID
Property FileMasterID As %String(TRUNCATE = 1);

/// 扫描日期
Property ActDate As %Date;

/// 扫描时间
Property ActTime As %Time;

/// 操作员ID
Property ActUserID As %String(TRUNCATE = 1);

/// OCR已分类标志
Property OCRArrangeFlag As %String(TRUNCATE = 1);

/// OCR完成日期
Property OCRCompleteDate As %Date;

/// OCR完成时间
Property OCRCompleteTime As %Time;

/// OCR识别归档类型ID
Property OCRMRItemID As %String(TRUNCATE = 1);

/// OCR识别归档类型名称
Property OCRMRItemName As %String(TRUNCATE = 1);

/// OCR识别病案号
Property OCRMedRecordNo As %String(TRUNCATE = 1);

/// 分类标志
Property ArrangeFlag As %String(TRUNCATE = 1);

/// 分类操作员
Property ArrangeUserID As %String(TRUNCATE = 1);

/// 分类日期
Property ArrangeDate As %Date;

/// 分类时间
Property ArrangeTime As %Time;

Index IdxOnNeedOcr On (OCRArrangeFlag, Type);

Index IdxEpisodeMRItem On (EpisodeID, OCRMRItemID);

Storage Default
{
<Data name="ScanFileDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Type</Value>
</Value>
<Value name="3">
<Value>EpisodeID</Value>
</Value>
<Value name="4">
<Value>FileName</Value>
</Value>
<Value name="5">
<Value>FileMasterID</Value>
</Value>
<Value name="6">
<Value>ActDate</Value>
</Value>
<Value name="7">
<Value>ActTime</Value>
</Value>
<Value name="8">
<Value>ActUserID</Value>
</Value>
<Value name="9">
<Value>ActUserName</Value>
</Value>
<Value name="10">
<Value>OCRArrangeFlag</Value>
</Value>
<Value name="11">
<Value>OCRCompleteDate</Value>
</Value>
<Value name="12">
<Value>OCRCompleteTime</Value>
</Value>
<Value name="13">
<Value>OCRMRItemID</Value>
</Value>
<Value name="14">
<Value>OCRMRItemName</Value>
</Value>
<Value name="15">
<Value>OCRMedRecordNo</Value>
</Value>
<Value name="16">
<Value>ArrangeFlag</Value>
</Value>
<Value name="17">
<Value>ArrangeUserID</Value>
</Value>
<Value name="18">
<Value>ArrangeDate</Value>
</Value>
<Value name="19">
<Value>ArrangeTime</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.ScanFileD</DataLocation>
<DefaultData>ScanFileDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.INST.ScanFileD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.ScanFileI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.ScanFileS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
