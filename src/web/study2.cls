Class web.study2 Extends %RegisteredObject
{

/// function:
/// creator:黄欣然
/// others:d ##class(web.study2).GetStudentInfo()
ClassMethod GetStudentInfo()
{
	s StRowId = 0
	for{
		s StRowId = $o(^DHCSTUDENTA(StRowId))
		q:(StRowId="")
		s code = $p($g(^DHCSTUDENTA(StRowId)),"^",1)
		s name = $p($g(^DHCSTUDENTA(StRowId)),"^",2)
		s SexDR = $p($g(^DHCSTUDENTA(StRowId)),"^",3)
		if (SexDR = ""){
			w "学生:" _code_"性别为空",!
			continue
		}
		s SexDesc = $p($g(^CT("SEX",SexDR)),"^",2)
		s StDob = $p($g(^DHCSTUDENTA(StRowId)),"^",4)
		s StDob = $zd(StDob,3)
		w "编号:"_code_",姓名:"_name_",性别:"_SexDesc_",日期:"_StDob,!


	}
}

}
