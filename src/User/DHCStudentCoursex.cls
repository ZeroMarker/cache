Class User.DHCStudentCoursex Extends (%Persistent, User.Abstract) [ SqlTableName = DHC_StudentCoursex ]
{

Relationship ParRef As DHCStudentz [ Cardinality = parent, Inverse = ChildCourse, SqlFieldName = DHC_St_ParRef ];

Property DHCScCourseDR As DHCCoursex [ SqlColumnNumber = 2, SqlFieldName = Course_Num ];

Property DHCScScore As %Integer [ SqlColumnNumber = 3, SqlFieldName = Score ];

Index Course On DHCScCourseDR As Exact;

Storage Default
{
<Data name="DHCStudentCoursexDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DHCScCourseDR</Value>
</Value>
<Value name="3">
<Value>DHCScScore</Value>
</Value>
<Value name="4">
<Value>CrsActiveFlag</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildCourse")</DataLocation>
<DefaultData>DHCStudentCoursexDefaultData</DefaultData>
<IdLocation>^User.DHCStudentCYWC("ChildCourse")</IdLocation>
<IndexLocation>^User.DHCStudentCoursexI</IndexLocation>
<StreamLocation>^User.DHCStudentCoursexS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
