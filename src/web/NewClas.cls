/// 
Class web.NewClas Extends (%Persistent, %XML.Adaptor) [ Inheritance = right ]
{

Storage Default
{
<Data name="NewClasDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.NewClasD</DataLocation>
<DefaultData>NewClasDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.NewClasD</IdLocation>
<IndexLocation>^web.NewClasI</IndexLocation>
<StreamLocation>^web.NewClasS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
