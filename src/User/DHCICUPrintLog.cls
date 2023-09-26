/// DHC_ICU_PrintLog
Class User.DHCICUPrintLog Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = DHC_ICU_PrintLog ]
{

/// 重症ID
Property IcuaId As %String(MAXLEN = 200) [ Required, SqlColumnNumber = 2 ];

/// 打印模板代码
Property Code As %String(MAXLEN = 200) [ Required, SqlColumnNumber = 3 ];

/// 打印日期
Property PrintDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 4 ];

/// 打印时间
Property PrintTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 5 ];

/// 页码
Property PageNo As %String [ SqlColumnNumber = 6 ];

/// 打印用户
Property UserId As %String [ SqlColumnNumber = 7 ];

/// 重症Id索引
Index IIcuaId On IcuaId;

/// 按重症Id和日期索引
Index IDate On (IcuaId, PrintDate);

Storage Default
{
<Data name="DHCICUPrintLogDefaultData">
<Value name="1">
<Value>IcuaId</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>PrintDate</Value>
</Value>
<Value name="4">
<Value>PrintTime</Value>
</Value>
<Value name="5">
<Value>PageNo</Value>
</Value>
<Value name="6">
<Value>UserId</Value>
</Value>
</Data>
<DataLocation>^User.DHCICUPrintLogD</DataLocation>
<DefaultData>DHCICUPrintLogDefaultData</DefaultData>
<IdLocation>^User.DHCICUPrintLogD</IdLocation>
<IndexLocation>^User.DHCICUPrintLogI</IndexLocation>
<StreamLocation>^User.DHCICUPrintLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
