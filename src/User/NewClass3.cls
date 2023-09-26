Class User.NewClass3 Extends %RegisteredObject
{

ClassMethod GetStudent() As %String
{
    s result=""
    s StuRowId=0
    for
    {
        s StuRowId=$o(^DHCFSTUDENT(StuRowId)) q:StuRowId=""
        s StuCode=$p(^DHCFSTUDENT(StuRowId),"^",1)
        s StuName=$p(^DHCFSTUDENT(StuRowId),"^",2)
        s StuSexDR=$p(^DHCFSTUDENT(StuRowId),"^",3)
        s SexDesc=$p(^CT("SEX",StuSexDR),"^",2)
        s StuDob=$p(^DHCFSTUDENT(StuRowId),"^",4)
        s Date=$zd(StuDob,3)
        w "姓名:"_StuName_" 学号"_StuCode_" 性别"_SexDesc_" 出生日期"_Date ,!
    }
    q result
}

}
