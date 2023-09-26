/// 科室
Class DWR.LOG.MSG.Department Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ Inheritance = right ]
{

Parameter XMLNAME = "Department";

/// 科室ID
Property DepartmentID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 科室名称
Property DepartmentName As %String(MAXLEN = 200, TRUNCATE = 1);

/// 安全组ID
Property GroupID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 安全组名称
Property GroupName As %String(MAXLEN = 100, TRUNCATE = 1);

/// 医院ID
Property HospitalID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 医院名称
Property HospitalName As %String(MAXLEN = 200, TRUNCATE = 1);

Storage Default
{
<Data name="DepartmentDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DepartmentCode</Value>
</Value>
<Value name="3">
<Value>DepartmentID</Value>
</Value>
<Value name="4">
<Value>DepartmentName</Value>
</Value>
<Value name="5">
<Value>GroupCode</Value>
</Value>
<Value name="6">
<Value>GroupID</Value>
</Value>
<Value name="7">
<Value>GroupName</Value>
</Value>
</Data>
<DataLocation>^DWR.LOG.MSG.DepartmentD</DataLocation>
<DefaultData>DepartmentDefaultData</DefaultData>
<IdLocation>^DWR.LOG.MSG.DepartmentD</IdLocation>
<IndexLocation>^DWR.LOG.MSG.DepartmentI</IndexLocation>
<StreamLocation>^DWR.LOG.MSG.DepartmentS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
