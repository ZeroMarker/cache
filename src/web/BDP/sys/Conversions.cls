Class web.BDP.sys.Conversions Extends %RegisteredObject
{

/// Check if query exists for a class
ClassMethod IsValidMethodName(classname As %Library.String, methodname As %Library.String) As %Library.Boolean
{
	q $s(+$$$comMemberDefined(classname,$$$cCLASSmethod,methodname):1, 1:0)
}

}
