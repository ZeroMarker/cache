/// Description:	关于学生表和课程表的相关方法
/// Creator:		赵子豪
/// CreateDate:	2023年9月12日
Class User.ZZHHomeWork2 Extends %RegisteredObject
{

/// Description:	获取学生表信息
/// Creator:		赵子豪
/// CreateDate:	2023年9月12日
/// Debug: 		d ##class(User.ZZHHomeWork2).GetStudentInfo()
ClassMethod GetStudentInfo()
{
	Set stRowId = 0
	
	for {
		Set stRowId = $Order(^DHCStudentZZH(stRowId))
		q:(stRowId = "")
		Set code = $Piece($Get(^DHCStudentZZH(stRowId)), "^", 1)
		Set name = 	$Piece($Get(^DHCStudentZZH(stRowId)), "^", 2)
		Set sexDR = $Piece($Get(^DHCStudentZZH(stRowId)), "^", 3)
		if (sexDR = "") {
			w "Code为"_code_"的学生性别为空", !
			continue	
		}
		Set sexDesc  = $Piece($Get(^CT("SEX", sexDR)), "^", 2)
		Set stDob = $Piece($Get(^DHCStudentZZH(stRowId)), "^", 4)
		Set stDob = ##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(stDob)
		w "学号："_code_"	| 姓名："_name_"	| 性别："_sexDesc_"	| 出生日期： "_stDob, !
	}
}

/// Description:	获取课程信息
/// Creator:		赵子豪
/// CreateDate:	2023年9月12日
/// Debug: 		d ##class(User.ZZHHomeWork2).GetCourseInfo()
ClassMethod GetCourseInfo()
{
	Set crsRowId = 0
	
	for {
		Set crsRowId = $Order(^DHCCOURSEZZH(crsRowId))
		q:(crsRowId = "")
		Set code = $Piece($Get(^DHCCOURSEZZH(crsRowId)), "^", 1)
		Set desc = 	$Piece($Get(^DHCCOURSEZZH(crsRowId)), "^", 2)
		Set activeFlag = $Piece($Get(^DHCCOURSEZZH(crsRowId)), "^", 3)

		w "编号："_code_"	| 课程名："_desc_"	| 激活状态："_activeFlag, !
	}
}

/// Description:新增学生信息
/// Table:DHC_StudentZZH
/// Input:
/// Output:
/// Creator:赵子豪
/// CreateDate:2023年9月14日
/// Debug: w ##class(User.ZZHHomeWork2).AddStudentObj("4", "盖伦", "1", "2000-08-08")
ClassMethod AddStudentObj(StCode As %String, StName As %String, StSexDR As %String, StDob As %String) As %String
{
	Quit:StCode="" "^学号为空"
	Quit:$DATA(^DHCStudentZZH("Code", StCode)) "^学号重复"
	Quit:StName="" "^姓名为空"
	Quit:StSexDR="" "^性别为空"
	Quit:StDob'="" StDob = ##class(websys.Conversions).DateHtmlToLogical(StDob)
	Set result = "^未执行"
	Set stuObj = ##class(User.DHCStudentZZH).%NEW()
	If (stuObj) {
		Set stuObj.StCode = StCode
		Set stuObj.StName = StName
		Set stuObj.StSexDR = ##class(User.CTSex).%OpenId(StSexDR)
		Set stuObj.StDob = StDob
		Tstart
		Set sc=stuObj.%Save() Break
		// If ($$$ISERR(sc)) {  
		If (sc = 1) {
			Tcommit
			Set StRowId = stuObj.%Id()
			Set result = 1_"^成功"_StRowId
		}
		Else {
			Trollback
			Set result = 0_"^失败"_$SYSTEM.OBJ.DisplayError(sc)
		}
		Do stuObj.%Close()
	}
	Quit result
}

}
