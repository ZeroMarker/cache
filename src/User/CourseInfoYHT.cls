Class User.CourseInfoYHT Extends %Persistent [ SqlTableName = DHC_CourseDefaultYHT ]
{

/// 课程编号
Property CrsCode As %String [ SqlColumnNumber = 2, SqlFieldName = Crs_Code ];

/// 课程名称
Property CrsDesc As %String [ SqlColumnNumber = 3, SqlFieldName = Crs_Desc ];

/// 课程是否有效
Property CrsActiveFlag As %String(DISPLAYLIST = ",Yes,No", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = Crs_ActiveFlag ];

/// 课程编号索引
Index CodeIndex On CrsCode;

/// 课程名称索引
Index DescIndex On CrsDesc;

Storage Default
{
<Data name="CourseInfoYHTDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CrsCode</Value>
</Value>
<Value name="3">
<Value>CrsDesc</Value>
</Value>
<Value name="4">
<Value>CrsActiveFlag</Value>
</Value>
</Data>
<DataLocation>^User.CourseInfoYHTD</DataLocation>
<DefaultData>CourseInfoYHTDefaultData</DefaultData>
<IdLocation>^User.CourseInfoYHTD</IdLocation>
<IndexLocation>^User.CourseInfoYHTI</IndexLocation>
<StreamLocation>^User.CourseInfoYHTS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
