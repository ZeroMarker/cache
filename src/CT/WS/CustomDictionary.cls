Class CT.WS.CustomDictionary Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index IdxCtmDictType On CtmDictType;

Index IdxCtmDictCode On CtmDictCode;

Index IdxCtmDictDesc On CtmDictDesc;

Index IdxCtmTypeCode On (CtmDictType, CtmDictCode);

///   	字典代码列
Property CtmDictCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 	字典描述列
Property CtmDictDesc As %String(TRUNCATE = 1);

/// 	字典别名列
Property CtmDictAlias As %String(TRUNCATE = 1);

/// 	值域代码表标示符
Property CtmDictType As %String(TRUNCATE = 1);

/// 	字典名称
Property CtmDictName As %String(TRUNCATE = 1);

/// 	开始日期
Property StartDate As %Date;

/// 	开始时间
Property StartTime As %Time;

/// 	截止日期
Property EndDate As %Date;

/// 	截止时间
Property EndTime As %Time;

//Property CtmDictID As %String(TRUNCATE = 1);

//Property CtmDictStatus As %String(TRUNCATE = 1);

//Property CtmDictLinkCode As %String(TRUNCATE = 1);

//Property CtmDictComment As %String(TRUNCATE = 1);

//Property CtmDictOther As %String(TRUNCATE = 1);

//Property CtmDictRef As %String(MAXLEN = 32767, TRUNCATE = 1);

//Property CtmDictLink As %String(TRUNCATE = 1);

/*
ClassMethod GetCtmDictLinkByCode(parCtmDictCode As %String) As %String
{
 &sql(SELECT CtmDictLink
 into :Result
 FROM CT_WS.CustomDictionary
 WHERE CtmDictCode = :parCtmDictCode)
 
 s:(SQLCODE'=0) Result=""
 
 QUIT Result
}


///  	字段标识号
///  	数据状态	Y启用	N停止
///  对照代码
///  字段备注
///  其他
///  关联
///  对照
*/
Storage Default
{
<Data name="CustomDictionaryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CtmDictID</Value>
</Value>
<Value name="3">
<Value>CtmDictCode</Value>
</Value>
<Value name="4">
<Value>CtmDictDesc</Value>
</Value>
<Value name="5">
<Value>CtmDictAlias</Value>
</Value>
<Value name="6">
<Value>CtmDictStatus</Value>
</Value>
<Value name="7">
<Value>CtmDictType</Value>
</Value>
<Value name="8">
<Value>CtmDictName</Value>
</Value>
<Value name="9">
<Value>CtmDictLinkCode</Value>
</Value>
<Value name="10">
<Value>CtmDictComment</Value>
</Value>
<Value name="11">
<Value>CtmDictOther</Value>
</Value>
<Value name="12">
<Value>CtmDictRef</Value>
</Value>
<Value name="13">
<Value>CtmDictLink</Value>
</Value>
<Value name="14">
<Value>StartDate</Value>
</Value>
<Value name="15">
<Value>StartTime</Value>
</Value>
<Value name="16">
<Value>EndDate</Value>
</Value>
<Value name="17">
<Value>EndTime</Value>
</Value>
</Data>
<DataLocation>^DHCCTWS.CustomDictionaryD</DataLocation>
<DefaultData>CustomDictionaryDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCTWS.CustomDictionaryD</IdLocation>
<IndexLocation>^DHCCTWS.CustomDictionaryI</IndexLocation>
<StreamLocation>^DHCCTWS.CustomDictionaryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
