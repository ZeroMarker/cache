Class web.DHCENS.STBLL.BOOKREG.METHOD.DictInfo Extends (%RegisteredObject, %XML.Adaptor)
{

/// w ##class(web.DHCENS.STBLL.BOOKREG.METHOD.DictInfo).SendDictInfo("")
ClassMethod SendDictInfo(Input As %String) As %String
{
	s $ztrap="ErrorMsg"
	//医院
	s hosDictResult=##class(web.DHCENS.STBLL.BOOKREG.METHOD.HospitalInfo).SendHospitalInfo("")
	//二级科室
	s deptDictResult=##class(web.DHCENS.STBLL.BOOKREG.METHOD.DeptDictInfo).GetLocInfo("")
	//医生
	s docDictResult=##class(web.DHCENS.STBLL.BOOKREG.METHOD.DoctorDictInfo).GetScheduleDoctorInfo("")
	//一级科室
	s deptParentResult=##class(web.DHCENS.STBLL.BOOKREG.METHOD.DeptParentDictInfo).GetLocParentInfo("")
	q 1
ErrorMsg
	q "-1^"_$ze
}

}
