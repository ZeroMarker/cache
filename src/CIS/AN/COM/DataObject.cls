/// 数据对象
Class CIS.AN.COM.DataObject Extends %RegisteredObject
{

Property KeyValuePairs As list Of CIS.AN.COM.KeyValuePair;

Method GetValue(key As %String) As %String
{
	set result=""
	for i=1:1:(..KeyValuePairs).Size
	{
		set keyValuePair=(..KeyValuePairs).GetAt(i)
		if (key=keyValuePair.Key)
		{
			set result=keyValuePair.Value
		}	
	}	
	quit result
}

Method GetKeyValuePair(key As %String) As CIS.AN.COM.KeyValuePair
{
	set result=""
	for i=1:1:(..KeyValuePairs).Size
	{
		set keyValuePair=(..KeyValuePairs).GetAt(i)
		if (key=keyValuePair.Key)
		{
			set result=keyValuePair
		}	
	}	
	quit result
}

Method SetValue(key As %String, value As %String)
{
	for i=1:1:(..KeyValuePairs).Size
	{
		set keyValuePair=(..KeyValuePairs).GetAt(i)
		if (key=keyValuePair.Key)
		{
			set keyValuePair.Value=value
		}	
	}
}

Method ExistsKey(key As %String) As %Boolean
{
	set result=0
	for i=1:1:..KeyValuePairs.Size
	{
		set keyValuePair=..KeyValuePairs.GetAt(i)
		if (key=keyValuePair.Key)
		{
			set result=1
		}	
	}	
	quit result
}

}
