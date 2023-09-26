/// Description: 对象操作课程信息表
/// CreateDate: 2023年9月14日
/// Creator: 赵子豪
Class User.ZZHHomeWork4 Extends %RegisteredObject
{

/// Description:	插入一条课程信息
/// Table:		DHC_CourseZZH
/// Input:  		Crs_Code, Crs_Desc, Crs_ActiveFlag
/// Output: 		success:1, fail:0
/// Creator:		赵子豪
/// CreateDate:	2023年9月14日
/// Debug:		w ##class(User.ZZHHomeWork4).InsertOneCourse("7", "后端框架", "Y")
ClassMethod InsertOneCourse(CrsCode As %String, CrsDesc As %String, CrsActiveFlag As %String) As %String
{
    Quit:CrsCode="" "CrsCode不能为空"
    Quit:CrsDesc="" "CrsDesc不能为空"
    Quit:CrsActiveFlag="" "CrsActiveFlag不能为空"
    Quit:$DATA(^DHCCOURSEZZH("0","Code",CrsCode)) "课程编号重复"
	
    Set course = ##class(User.DHCCourseZZH).%New()
    If (course) {
        Set course.CrsCode = CrsCode
        Set course.CrsDesc = CrsDesc
        Set course.CrsActiveFlag = CrsActiveFlag
        Set sc = course.%Save()
        Tstart
        If (sc=1) {
            Tcommit
            Set courseRowID = course.%Id()
            Set result = "^新增数据成功^"_courseRowID
        }
        Else {
            Trollback
            Set result = "^新增数据失败"_$SYSTEM.Status.GetErrorText(sc)
        }
        Do course.%Close()
        Quit result
    }
}

/// Description:	修改课程信息
/// Table:		DHC_CourseZZH
/// Input:		Crs_RowID, CrsCode, CrsDesc, CrsActiveFlag
/// Output:
/// Creator:		赵子豪
/// CreateDate:	2023年9月14日
/// Debug:		w ##class(User.ZZHHomeWork4).UpdateOneCourse("6","4", "住院流程", "Y")
ClassMethod UpdateOneCourse(CrsRowID As %String, CrsCode As %String, CrsDesc As %String, CrsActiveFlag As %String) As %String
{
    Quit:CrsRowID="" "^RowID不能为空"
    Quit:CrsCode="" "^CrsCode不能为空"
    Quit:CrsDesc="" "^CrsDesc不能为空"
    Quit:CrsActiveFlag="" "^CrsActiveFlag不能为空"

    Set course = ##class(User.DHCCourseZZH).%OpenId(CrsRowID)
    If (course) {
        Set course.CrsCode = CrsCode
        Set course.CrsDesc = CrsDesc
        Set course.CrsActiveFlag = CrsActiveFlag
        Tstart
        Set sc = course.%Save()
        If ($$$ISOK(sc)) {
            Tcommit
            Set result = "更新成功"
        }
        Else {
            Trollback
            Set result = "更新失败^"_$SYSTEM.status.GetErrorText()
        }
        Do course.%Close()
        Kill course
    }

    Quit result
}

/// Description:	删除课程信息
/// Table:		DHC_CourseZZH
/// Input:		Crs_RowID
/// Output:
/// Creator:		赵子豪
/// CreateDate:	2023年9月13日
/// Debug:		w ##class(User.ZZHHomeWork4).DeleteOneCourse(4)
ClassMethod DeleteOneCourse(CrsRowID As %String) As %String
{
    Quit:CrsRowID="" "^CrsRowID不能为空"

    Set course = ##class(User.DHCCourseZZH).%OpenId(CrsRowID)
    If (course) {
        Tstart
        Set sc = ##class(User.DHCCourseZZH).%DeleteId(CrsRowID)
        If ($$$ISOK(sc)) {
            Tcommit
            Set result = "删除成功^"_course.CrsDesc
        }
        Else {
            Trollback
            Set result = "删除失败^"_$SYSTEM.status.GetErrorText(sc)
        }
    }
    Else {
        Set result = "数据不存在"
    }
    Do course.%Close()
    Quit result
}

/// Description:	查询课程信息
/// Table:		DHC_CourseZZH
/// Input:		Crs_RowID
/// Output:		CrsCode, CrsDesc, CrsActiveFlag
/// Creator:		赵子豪
/// CreateDate:	2023年9月13日
/// Debug:		w ##class(User.ZZHHomeWork4).GetOneCourse(1)
ClassMethod GetOneCourse(CrsRowID As %String) As %String
{
    Quit:CrsRowID="" "^CrsRowID不能为空"
    
    Set course = ##class(User.DHCCourseZZH).%OpenId(CrsRowID)

    If (course) {
        Set code = course.CrsCode
        Set desc = course.CrsDesc
        Set avtiveFlag = course.CrsActiveFlag
        Set result = "代码: "_code_"|课程名称: "_desc_"|激活: "_avtiveFlag
    }
    Else {
        Set result = "没有对应数据"
    }

    Quit result
}

}
