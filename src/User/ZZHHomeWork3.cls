/// Description: 	课程表Sql操作
/// Creator:		赵子豪
/// CreateDate:	2023年9月13日
Class User.ZZHHomeWork3 Extends %RegisteredObject
{

/// Description:	插入一条课程信息(PLIST版)
/// Table:		DHC_CourseZZH
/// Input:  		Crs_Code, Crs_Desc, Crs_ActiveFlag
/// Output: 		success:1, fail:0
/// Creator:		赵子豪
/// CreateDate:	2023年9月13日
/// Debug:		w ##class(User.ZZHHomeWork3).InsertOneCourse("3", "门诊业务", “N”)
ClassMethod InsertOneCourse(CrsCode As %String, CrsDesc As %String, CrsActiveFlag As %String) As %String
{
    Quit:CrsCode="" "CrsCode不能为空"
    Quit:CrsDesc="" "CrsDesc不能为空"
    Quit:CrsActiveFlag="" "CrsActiveFlag不能为空"
    Quit:$DATA(^DHCCOURSEZZH("0","Code",CrsCode)) "课程编号重复"
	Kill PLIST
	Set PLIST(2) = CrsCode
    	Set PLIST(3) = CrsDesc
    	Set PLIST(4) = CrsActiveFlag
    	&SQL(
       	 INSERT INTO DHC_CourseZZH VALUES :PLIST()
    	)
    	If (SQLCODE=0) { Set result = 1_"^"_PLIST(3) }
    	Else { Set result = 0_"^"_%msg }

    	Quit result
}

/// Description:修改课程信息
/// Table:DHC_CourseZZH
/// Input:Crs_RowID, CrsCode, CrsDesc, CrsActiveFlag
/// Output:
/// Creator:赵子豪
/// CreateDate:2023年9月13日
/// Debug:w ##class(User.ZZHHomeWork3).UpdateOneCourse("6","4", "住院业务", "Y")
ClassMethod UpdateOneCourse(CrsRowID As %String, CrsCode As %String, CrsDesc As %String, CrsActiveFlag As %String) As %String
{
    Quit:CrsRowID="" "^RowID不能为空"
    Quit:CrsCode="" "^CrsCode不能为空"
    Quit:CrsDesc="" "^CrsDesc不能为空"
    Quit:CrsActiveFlag="" "^CrsActiveFlag不能为空"
    Set PLIST(2) = CrsCode
    Set PLIST(3) = CrsDesc
    Set PLIST(4) = CrsActiveFlag
    &SQL(
        UPDATE DHC_CourseZZH VALUES :PLIST() WHERE Crs_RowID = :CrsRowID
    )

    If (SQLCODE=0) { Set result = 1_"^"_"修改成功" }
    Else { Set result = 0_"^"_"失败"_%msg }

    Quit result
}

/// Description:查询课程信息
/// Table:DHC_CourseZZH
/// Input:Crs_RowID
/// Output:CrsCode, CrsDesc, CrsActiveFlag
/// Creator:赵子豪
/// CreateDate:2023年9月13日
/// Debug:w ##class(User.ZZHHomeWork3).GetOneCourse(3)
ClassMethod GetOneCourse(CrsRowID As %String) As %String
{
    Quit:CrsRowID="" "^CrsRowID不能为空"
    Set code = ""
    Set desc = ""
    Set activeFlag = ""
    &SQL(
        SELECT Crs_Code, Crs_Desc, Crs_ActiveFlag INTO :code, :desc, :activeFlag
        FROM DHC_CourseZZH WHERE Crs_RowID = :CrsRowID
    )

    Quit "代码："_code_"   | 名称："_desc_"    | 激活："_activeFlag
}

/// Description:删除课程信息
/// Table:DHC_CourseZZH
/// Input:Crs_RowID
/// Output:
/// Creator:赵子豪
/// CreateDate:2023年9月13日
/// Debug:w ##class(User.ZZHHomeWork3).DeleteOneCourse(2)
ClassMethod DeleteOneCourse(CrsRowID As %String) As %String
{
    Quit:CrsRowID="" "^CrsRowID不能为空"

    &SQL(
        DELETE FROM DHC_CourseZZH WHERE Crs_RowID = :CrsRowID
    )

    If (SQLCODE=0) { Set result = 1_"^操作成功" }
    Else { Set result = 0_"^操作失败"_%msg }

    Quit result
}

}
