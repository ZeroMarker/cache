Class CIS.AN.PatTransData Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = PatTransData ]
{

/// 手术麻醉表单
Property RecordSheet As CIS.AN.RecordSheet [ Required, SqlColumnNumber = 2 ];

/// 病人位置
Property PatLocation As CT.AN.PatTransLocation [ Required, SqlColumnNumber = 3 ];

/// 扫码日期
Property ScanDate As %Date [ SqlColumnNumber = 4 ];

/// 扫码时间
Property ScanTime As %Time [ SqlColumnNumber = 5 ];

/// 数据更新用户ID
Property UpdateUserID As %String [ SqlColumnNumber = 6 ];

/// 交接类型
Property Type As %String [ SqlColumnNumber = 7 ];

/// 交接类型
Property Note As %String [ SqlColumnNumber = 8 ];

/// 按手术索引
Index RecordSheet On RecordSheet;

Storage Default
{
<Data name="PatTransDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RecordSheet</Value>
</Value>
<Value name="3">
<Value>PatLocation</Value>
</Value>
<Value name="4">
<Value>ScanDate</Value>
</Value>
<Value name="5">
<Value>ScanTime</Value>
</Value>
<Value name="6">
<Value>UpdateUserID</Value>
</Value>
<Value name="7">
<Value>Type</Value>
</Value>
<Value name="8">
<Value>Note</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.PatTransDataD</DataLocation>
<DefaultData>PatTransDataDefaultData</DefaultData>
<IdLocation>^CIS.AN.PatTransDataD</IdLocation>
<IndexLocation>^CIS.AN.PatTransDataI</IndexLocation>
<StreamLocation>^CIS.AN.PatTransDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
