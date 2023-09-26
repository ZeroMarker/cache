/// creator:llin
/// createdate:2018-08-02
/// description:排班提交后的修改记录
Class DHCNMG.Arg.MgArrangeLog Extends %Persistent
{

/// 排班记录 
Property ArrangeDR As DHCNMG.Arg.MgArrange [ SqlColumnNumber = 2, SqlFieldName = Arrange_DR ];

/// 护士
Property ArgLogPerDR As %String [ SqlColumnNumber = 3, SqlFieldName = ArgLog_PerDR ];

/// 排班日期
Property ArgLogArgDate As %Date [ SqlColumnNumber = 4, SqlFieldName = ArgLog_ArgDate ];

/// 修改前记录
Property ArgLogBefor As %String(MAXLEN = 1000) [ SqlColumnNumber = 5, SqlFieldName = ArgLog_Befor ];

/// 修改后记录
Property ArgLogAfter As %String(MAXLEN = 1000) [ SqlColumnNumber = 6, SqlFieldName = ArgLog_After ];

/// 修改备注
Property ArgLogRemark As %String(MAXLEN = 1000) [ SqlColumnNumber = 7, SqlFieldName = ArgLog_Remark ];

/// 操作
Property ArgLogCrt As %String [ SqlColumnNumber = 8, SqlFieldName = ArgLog_Crt ];

/// 操作日期
Property ArgLogCrtDate As %Date [ SqlColumnNumber = 9, SqlFieldName = ArgLog_CrtDate ];

/// 操作时间
Property ArgLogCrtTime As %Time [ SqlColumnNumber = 10, SqlFieldName = ArgLog_CrtItem ];

/// 修改原因说明
Property ArgLogReason As %String(MAXLEN = 1000) [ SqlColumnNumber = 11, SqlFieldName = ArgLog_Reason ];

Index Arrange On ArrangeDR;

Storage Default
{
<Data name="MgArrangeLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ArrangeDR</Value>
</Value>
<Value name="3">
<Value>ArgLogPerDR</Value>
</Value>
<Value name="4">
<Value>ArgLogArgDate</Value>
</Value>
<Value name="5">
<Value>ArgLogBefor</Value>
</Value>
<Value name="6">
<Value>ArgLogAfter</Value>
</Value>
<Value name="7">
<Value>ArgLogRemark</Value>
</Value>
<Value name="8">
<Value>ArgLogCrt</Value>
</Value>
<Value name="9">
<Value>ArgLogCrtDate</Value>
</Value>
<Value name="10">
<Value>ArgLogCrtTime</Value>
</Value>
<Value name="11">
<Value>ArgLogReason</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Arg.MgArrangeLogD</DataLocation>
<DefaultData>MgArrangeLogDefaultData</DefaultData>
<IdLocation>^DHCNMG.Arg.MgArrangeLogD</IdLocation>
<IndexLocation>^DHCNMG.Arg.MgArrangeLogI</IndexLocation>
<StreamLocation>^DHCNMG.Arg.MgArrangeLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
