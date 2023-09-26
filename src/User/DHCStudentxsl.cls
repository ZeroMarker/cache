/// 学生表（默认存储）
/// creator:夏双玲
Class User.DHCStudentxsl Extends %Persistent [ SqlTableName = DHC_Studentxsl ]
{

Property StCode As %String [ SqlColumnNumber = 2, SqlFieldName = St_Code ];

Property StName As %String [ SqlColumnNumber = 3, SqlFieldName = St_Name ];

Property StSexDR As User.CTSex [ SqlColumnNumber = 4, SqlFieldName = St_SexDR ];

Property StDob As %Date [ SqlColumnNumber = 5, SqlFieldName = St_Dob ];

Index NameInx On StName As EXACT;

Index CodeInx On StCode As EXACT;

ClassMethod GetStudent() As %String
{
    s result=""
    s StuRowId=0
    for
    {
        s StuRowId=$o(^DHCSudentxsl(StuRowId)) q:StuRowId=""
        s StuCode=$p(^DHCSudentxsl(StuRowId),"^",1)
        s StuName=$p(^DHCSudentxsl(StuRowId),"^",2)
        s StuSexDR=$p(^DHCSudentxsl(StuRowId),"^",3)
        s SexDesc=$p(^CT("SEX",StuSexDR),"^",2)
        s StuDob=$p(^DHCSudentxsl(StuRowId),"^",4)
        s Date=$zd(StuDob,3)
        w "姓名:"_StuName_" 学号"_StuCode_" 性别"_SexDesc_" 出生日期"_Date ,!
    }
    q result
}

Storage Default
{
<Data name="DHCStudentxslDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>StCode</Value>
</Value>
<Value name="3">
<Value>StName</Value>
</Value>
<Value name="4">
<Value>StSexDR</Value>
</Value>
<Value name="5">
<Value>StDob</Value>
</Value>
</Data>
<DataLocation>^User.DHCStudentxslD</DataLocation>
<DefaultData>DHCStudentxslDefaultData</DefaultData>
<IdLocation>^User.DHCStudentxslD</IdLocation>
<IndexLocation>^User.DHCStudentxslI</IndexLocation>
<StreamLocation>^User.DHCStudentxslS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
