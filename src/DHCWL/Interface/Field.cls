Class DHCWL.Interface.Field Extends %RegisteredObject
{

Property Name As %String;

Property Value As %String;

Method SetName(Name As %String)
{
	s ..Name=Name
}

Method GetName() As %String
{
	q ..Name
}

Method SetValue(Value As %String)
{
	s ..Value=Value
}

Method GetValue() As %String
{
	q ..Value
}

}
