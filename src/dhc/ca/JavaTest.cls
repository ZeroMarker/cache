Class dhc.ca.JavaTest Extends (%SerialObject, %Populate, %XML.Adaptor) [ ClassType = serial, Inheritance = right, Not ProcedureBlock ]
{

Projection JavaTest As %Projection.Java;

//w ##class(dhc.ca.JavaTest).DBConnTest("Xu")

ClassMethod DBConnTest(param) As %String
{
	n (param)
	s str="Hello,"_param_"!Connection is successfull.Good lucky! From Main Server."
	q str
}

Storage Default
{
<StreamLocation>^dhc.ca.JavaTestS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
