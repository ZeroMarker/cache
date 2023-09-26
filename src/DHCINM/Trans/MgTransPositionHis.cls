/// 院内调岗审批历史记录表
Class DHCINM.Trans.MgTransPositionHis Extends %Persistent
{

/// 申请记录ID
Property DepDR As DHCINM.Trans.MgTransPositionApp [ SqlColumnNumber = 2, SqlFieldName = Hist_DepDR ];

/// 审批意见
Property Reason As %String [ SqlColumnNumber = 3, SqlFieldName = Hist_Reason ];

/// 操作时间
Property OperDate As %Date [ SqlColumnNumber = 4, SqlFieldName = Hist_Date ];

/// 审批结果
Property Status As %String [ SqlColumnNumber = 5, SqlFieldName = Hist_Status ];

/// 操作人
Property Perdr As %String [ SqlColumnNumber = 6, SqlFieldName = Hist_Per ];

Index dep On DepDR;

Storage Default
{
<Data name="MgTransPositionHisDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DepDR</Value>
</Value>
<Value name="3">
<Value>Reason</Value>
</Value>
<Value name="4">
<Value>Date</Value>
</Value>
<Value name="5">
<Value>Status</Value>
</Value>
<Value name="6">
<Value>Perdr</Value>
</Value>
<Value name="7">
<Value>AppDate</Value>
</Value>
<Value name="8">
<Value>OperDate</Value>
</Value>
</Data>
<DataLocation>^DHCINM.Trans.MgTransPosiHisD</DataLocation>
<DefaultData>MgTransPositionHisDefaultData</DefaultData>
<IdLocation>^DHCINM.Trans.MgTransPosiHisD</IdLocation>
<IndexLocation>^DHCINM.Trans.MgTransPosiHisI</IndexLocation>
<StreamLocation>^DHCINM.Trans.MgTransPosiHisS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
