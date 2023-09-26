Class User.TestLYZ02 Extends %RegisteredObject
{

// 插入数据

/// w #class(webstudy.day3.InsetCourse("003","物理","P")
ClassMethod InsetCourse(CrsCode As %String, CrsDesc As %String, CrsActiveFlag As %String) As %String
{
	s result=""
	q:CrsCode="" "CrsCode为空"
	q:($d(^DHCSTUDENT(0,"Code", CrsCode))) "编号重复"
	q:CrsDesc="" "CrsDesc为空"
	&SQL(insert into DHC_Course_LYZ values(:CrsCode,:CrsDesc,:CrsActiveFlag))
	if (SQLCODE=0){
		s result="插入成功"
	}else {
		s result="插入失败"_%msg
		}
	q result
}

// 查询数据

ClassMethod GetSQLList() As %String
{
	s StrSql ="select Crs_Code,Crs_Desc,Crs_ActiveFlag from DHC_Course_LYZ"
	s result = ##class(%Library.ResultSet).%New()
	d result.Prepare(StrSql)
	s sc=result.Execute0
	While (result.Next()){
		s CrsCode=result.Data("Crs Code'")
		s CrsDesc=result.Data("Crs. Desc")
		s CrsActiveFlag=result.Data("Crs. ActiveFlag")
		W CrsCode_""_CrsDesc_""_CrsActiveFlag,!
	}
}

// 更新数据

ClassMethod UpdateCourse(CrsCode As %String, CrsDesc As %String, CrsActiveFlag As %String) As %String
{
	s result=""
	q:CrsCode="" "CrsCode为空"

	q:'($d(^DHCCOURE(0,"Code",CrsCode))) "该课程不存在"
	&SQL(UPDATE DHC_Course_LYZ SET Crs_Desc=:CrsDesc, Crs_ActiveFlag=:CrsActiveFlag where Crs_Code=:CrsCode)
	if (SQLCODE=0)
	{s result= "更新成功"}
	else
	{ s result="更新失败"_%msg }
	q result
}

// 删除数据

/// w #lass(web.study.day3).DeleteCourse("002")
ClassMethod DeleteCourse(CrsCode As %String) As %String
{
	s result=""
	q:CrsCode="" "CrsCode为空"
	q:($d(^DHCCOURE(0,"Code",CrsCode))) "该课程不存在"
	&SQL(delete from DHC_Course_LYZ where Crs_Code=:CrsCode)
	if (SQLCODE=0)
	{
		s result="删除成功"
	}
	else
	{
		s result="删除失败"_%msg
	}
	q result
}

}
