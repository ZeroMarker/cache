Class User.HXRstudy4 Extends %RegisteredObject
{

/// Desc:插入一条课程信息
/// Creator:黄欣然
/// others: w ##class(User.HXRstudy4).InsertOneCourse("1", "web基础", "Y")
ClassMethod InsertOneCourse(Crscode As %String, CrsDesc As %String, CrsActiveFlag As %String) As %String
{
	s result=""
    q:Crscode="" "Crscode为空"
    q:CrsDesc="" "CrsDesc为空"
    q:$DATA(^DHCCOURSEHXRR("0","Code",Crscode)) "编号重复"
    S course = ##class(User.DHCcourseHXRR).%New()
    If (course) 
    {
        S course.CrsCode = Crscode
        s course.CrsDesc = CrsDesc
        s course.CrsActiveFlag = CrsActiveFlag
        s sc = course.%Save()
        Tstart
        if (sc=1) 
        {
            TCOMMIT
            s result = "^新增成功^"
        }
        Else 
        {
            Trollback
            s result = "^新增失败"
        }
        d course.%Close()
        q result
    }
}

/// Description:修改课程信息
/// Table:DHC_CourseHXRR
/// Creator:黄欣然
/// Debug:w ##class(User.HXRstudy4).UpdateOneCourse("9","01", "大学英语", "Y")
ClassMethod UpdateOneCourse(CrsRowId As %String, CrsCode As %String, CrsDesc As %String, CrsActiveFlag As %String) As %String
{
    q:CrsRowId="" "RowId为空"
    q:CrsCode="" "Crscode为空"
    q:CrsDesc="" "CrsDesc为空"
    S course = ##class(User.DHCcourseHXRR).%OpenId(CrsRowId)
    if (CrsRowId="")
    {
	    q:$d(^DHCcourseHXRR(0,"code",Crscode)) "编号重复"
    	s crs=##class(User.DHCcourseHXRR).%New()
    }
    else
    {
	    s crs=##class(User.DHCcourseHXRR).%OpenId(CrsRowId)
    }
    if (crs) {
        s crs.CrsCode = CrsCode
        s crs.CrsDesc = CrsDesc
        S crs.CrsActiveFlag = CrsActiveFlag
        Tstart
        s sc = course.%Save()
        if (sc=1) {
            Tcommit
            s result = "更新成功"
        }
       else {
            Trollback
            Set result = "更新失败^"
        }
        d course.%Close()
    }

    q result
}

/// Description:删除课程信息
/// Creator:黄欣然
/// Debug:w ##class(User.HXRstudy4).DeleteOneCourse(11)
ClassMethod DeleteOneCourse(CrsRowId As %String) As %String
{
    q:CrsRowId="" "^CrsRowID不能为空"

    s course = ##class(User.DHCcourseHXRR).%OpenId(CrsRowId)
    if (course) {
        Tstart
        s sc = ##class(User.DHCcourseHXRR).%DeleteId(CrsRowId)
        If (sc=1) {
            Tcommit
            s result = "删除成功^"
        }
        else {
            Trollback
            s result = "删除失败^"
        }
    }
    else {
        s result = "数据不存在"
    }
    d course.%Close()
    q result
}

/// Description:查询课程信息
/// Creator:黄欣然
/// others:w ##class(User.HXRstudy4).selectData(2)
ClassMethod selectData(CrsRowId As %String) As %String
{
    q:CrsRowId="" "^CrsRowID为空"
    
    S course = ##class(User.DHCcourseHXRR).%OpenId(CrsRowId)

    if (course) {
        s Crscode = course.CrsCode
        s CrsDesc = course.CrsDesc
        S CrsAvtiveFlag = course.CrsActiveFlag
        s result = "Crscode: "_Crscode_"CrsDesc: "_CrsDesc_"CrsActiveFlag: "_CrsAvtiveFlag
    	d course.%Close()
    }
    else {
        s result = "没有对应数据"
    }

    q result
}

}
