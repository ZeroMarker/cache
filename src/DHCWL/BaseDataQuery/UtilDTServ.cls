Class DHCWL.BaseDataQuery.UtilDTServ Extends %RegisteredObject
{

Property data As %Library.ArrayOfDataTypes [ Private ];

Method SetValue(Name As %String, Value As %String) As %String
{
	d ..data.SetAt(Value,Name)
}

Method GetValue(Name As %String) As %String
{
	q ..data.GetAt(Name)
}

}
