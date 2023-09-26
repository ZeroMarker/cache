Class DHCWL.MKPIIO.util.ClassType Extends %RegisteredObject [ Not ProcedureBlock ]
{

ClassMethod CheckClassType(classType) As %String
{
}

//w ##class(DHCWL.MKPIIO.util.ClassType).GetClassFullNameFromHandle()

ClassMethod GetClassFullNameFromHandle(handle As %ObjectHandle) As %String
{
	n (handle)
	s classFullName=handle.%PackageName()
	if (classFullName'="") s classFullName=classFullName_"."_handle.%ClassName()
	else  s classFullName=handle.%ClassName()
	q classFullName
}

ClassMethod GetPropertyType(handle As %ObjectHandle, propertyName) As %String
{
}

}
