Class User.PHAINClientOpts Extends (%Persistent, User.Abstract) [ SqlRowIdName = PICO_RowId, SqlTableName = PHAIN_ClientOpts ]
{

Index SendCode On PICOSendCode As Exact;

Index PCIDSendCode On (PICOPCID As Exact, PICOSendCode As Exact);

/// 客户端唯一代码
Property PICOPCID As %String [ Required, SqlColumnNumber = 2, SqlFieldName = PICO_PCID ];

/// 客户端IP
Property PICOIP As %String [ Required, SqlColumnNumber = 3, SqlFieldName = PICO_IP ];

/// 推送代码
Property PICOSendCode As %String [ Required, SqlColumnNumber = 4, SqlFieldName = PICO_SendCode ];

/// 客户端所有配置
Property PICOOptions As %String(MAXLEN = 9999) [ Required, SqlColumnNumber = 5, SqlFieldName = PICO_Options ];

/// 是否可用
Property PICOActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ Required, SqlColumnNumber = 6, SqlFieldName = PICO_ActiveFlag ];

/// 最后登录日期
Property PICODate As %Date [ Required, SqlColumnNumber = 7, SqlFieldName = PICO_Date ];

/// 最后登录时间
Property PICOTime As %Time [ Required, SqlColumnNumber = 8, SqlFieldName = PICO_Time ];

Storage Default
{
<Data name="PHAINClientOptsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PICOPCID</Value>
</Value>
<Value name="3">
<Value>PICOIP</Value>
</Value>
<Value name="4">
<Value>PICOSendCode</Value>
</Value>
<Value name="5">
<Value>PICOOptions</Value>
</Value>
<Value name="6">
<Value>PICOActiveFlag</Value>
</Value>
<Value name="7">
<Value>PICODate</Value>
</Value>
<Value name="8">
<Value>PICOTime</Value>
</Value>
</Data>
<DataLocation>^CF.PHA.IN.ClientOpts</DataLocation>
<DefaultData>PHAINClientOptsDefaultData</DefaultData>
<IdLocation>^CF.PHA.IN.ClientOpts</IdLocation>
<IndexLocation>^CF.PHA.IN.ClientOptsI</IndexLocation>
<StreamLocation>^User.PHAINClientOptsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
