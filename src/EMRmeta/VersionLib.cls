Class EMRmeta.VersionLib Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter VERSION [ Final ] = "EMR R9.0.0";

Parameter TEMP [ Final ] = 1;

ClassMethod GetVersion() As %String
{
		q "EMR R9.0.0"
}

}
