Class CHSS.PersonHealthEventDetail Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = DetailRowId, SqlTableName = PersonHealthEventDetail ]
{

/// EventRowId
Property EventRowId As %Library.Integer;

/// 卫生事件明细类别
Property DetailEventType As %Library.Integer;

/// 卫生事件明细名称
Property DetailEventName As %Library.String(MAXLEN = 60, TRUNCATE = 1);

/// 卫生事件明细日期
Property DetailEventDate As %Library.Date;

/// 备注
Property Remak As %Library.String(MAXLEN = 100, TRUNCATE = 1);

Storage Default
{
<Data name="PersonHealthEventDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DetailEventDate</Value>
</Value>
<Value name="3">
<Value>DetailEventName</Value>
</Value>
<Value name="4">
<Value>DetailEventType</Value>
</Value>
<Value name="5">
<Value>EventRowId</Value>
</Value>
<Value name="6">
<Value>Remak</Value>
</Value>
</Data>
<DataLocation>^CHSS.PersonHealthEventDetailD</DataLocation>
<DefaultData>PersonHealthEventDetailDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.PersonHealthEventDetailD</IdLocation>
<IndexLocation>^CHSS.PersonHealthEventDetailI</IndexLocation>
<StreamLocation>^CHSS.PersonHealthEventDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
