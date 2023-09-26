Import SQLUser

Class web.FirstDay Extends %RegisteredObject
{

/// Function:获取指定rowid的就诊(PA_Adm)的病人(PA_PatMas)的性别描述.
/// CreateDate:2023-09-11
/// Creator:翁瑞珍
/// Table：PA_Adm
/// Input：rowid
/// Output：性别描述
/// Others:w ##class(web.FirstDay).GetPAAdmSexDesc(5)
ClassMethod GetPAAdmSexDesc(Admrowid As %String) As %String
{
         q:Admrowid=""
         s DateAdmStr= $g(^PAADM(1))
         s StPAADMPAPMIDRDate= $p(DateAdmStr,"^",1)
         s StPatMasDate= $g(^PAPER(StPAADMPAPMIDRDate,"ALL"))
         s PAPMISexDRDate= $p(StPatMasDate,"^",7)
         s StSexDate= $g(^CT("SEX",PAPMISexDRDate))
         s CTSEXDescDate= $p(StSexDate,"^",2)
         q "性别:" _CTSEXDescDate
}

/// Fountion：删除数据
/// CreateDate:2023-09-13
/// Creator:翁瑞珍
/// Table:DHCA_Course
/// Input:CrsRowid
/// Output:result
/// Others:w ##class(web.FirstDay).DeleteSqlDate(10)
ClassMethod DeleteSqlDate(CrsRowid As %String) As %String
{
	q:CrsRowid="" "CrsRowid为空"
	q:'$D(^User.DHCACourseD(CrsRowid)) "0^数据为空"
	&SQL(
	     DELETE  FROM DHCA_Course
         WHERE Crs_Rowid=:CrsRowid
	    )
	if (SQLCODE=0)
	{
		s result="删除成功"
	}
	else
	{
		s result="删除失败"
	}    
	q result
}

/// Fountion：新增数据
/// CreateDate:2023-09-13
/// Creator:翁瑞珍
/// Table:DHCA_Course
/// Input:CrsCode,CrsDesc,CrsActiveFlag,CrsDob
/// Output:result
/// Others:w ##class(web.FirstDay).InsertSqlDate("07","化学","Y","2000-11-20")
ClassMethod InsertSqlDate(CrsCode As %String, CrsDesc As %String, CrsActiveFlag As %String, CrsDob As %String) As %String
{
	q:CrsDesc="" "CrsDesc为空"
	q:CrsCode="" "CrsCode为空"
	s:CrsDob'="" CrsDob=$zdh(CrsDob,3)
	q:$Data(^User.DHCACourseD("Code",CrsCode)) "0^代码重复"
	&SQL(
	     INSERT INTO DHCA_Course (Crs_Code,Crs_Desc,Crs_ActiveFlag,Crs_Dob) 
	     VALUES (:CrsCode,:CrsDesc,:CrsActiveFlag,:CrsDob)
	    )
	if (SQLCODE=0)
	{
		s result="新增成功"
	}
	else
	{
		s result="新增失败"
	}    
	q result
}

/// Fountion：修改数据
/// CreateDate:2023-09-13
/// Creator:翁瑞珍
/// Table:DHCA_Course
/// Input:CrsRowid,CrsCode,CrsDesc,CrsActiveFlag,CrsDob
/// Output:result
/// Others:w ##class(web.FirstDay).UpdateSqlDate("11","美术","Y","1890-12-10")
ClassMethod UpdateSqlDate(CrsRowid As %String, CrsDesc As %String, CrsActiveFlag As %String, CrsDob As %String) As %String
{
	q:CrsRowid="" "CrsRowid为空"
	q:'$D(^User.DHCACourseD(CrsRowid)) "0^数据为空"
	s:CrsDob'="" CrsDob=$zdh(CrsDob,3)
	&SQL(
	     UPDATE DHCA_Course SET Crs_Desc=:CrsDesc,Crs_ActiveFlag=:CrsActiveFlag,Crs_Dob=:CrsDob
	     WHERE Crs_Rowid=:CrsRowid
	    )
	if (SQLCODE=0)
	{
		s result="修改成功"
	}
	else
	{
		s result="修改失败"
	}    
	q result
}

/// Fountion：查询数据
/// CreateDate:2023-09-13
/// Creator:翁瑞珍
/// Table:DHCA_Course
/// Others:d ##class(web.FirstDay).SelectSqlDate()
ClassMethod SelectSqlDate(CrsRowid As %String, CrsCode As %String, CrsDesc As %String, CrsActiveFlag As %String, CrsDob As %String) As %String
{
	s sqlstr="SELECT Crs_Code,Crs_Desc,Crs_ActiveFlag,Crs_Dob FROM DHCA_Course"
	s rs=##class(%ResultSet).%New()
	if (rs)
	{
		d rs.Prepare(sqlstr)
		d rs.Execute()
		While(rs.Next())
		{
			s CrsCode= $g(rs.Data("Crs_Code"))
			s CrsDesc= $g(rs.Data("Crs_Desc"))
			s CrsActiveFlag= $g(rs.Data("Crs_ActiveFlag"))
			s CrsDob = $g(rs.Data("Crs_Dob"))
			s:CrsDob'="" CrsDob=$zd(CrsDob,3)
			w CrsCode_" "_CrsDesc_" "_CrsActiveFlag_" "_CrsDob
			w !
		}
	}
}

/// Fountion：新增数据
/// CreateDate:2023-09-14
/// Creator:翁瑞珍
/// Table:DHCA_Course
/// Input:CrsCode,CrsDesc,CrsActiveFlag,CrsDob
/// Output:result
/// Others:w ##class(web.FirstDay).InsertDate("08","政治","Y","2019-09-18")
ClassMethod InsertDate(CrsCode As %String, CrsDesc As %String, CrsActiveFlag As %String, CrsDob As %String) As %String
{
	q:CrsDesc="" "CrsDesc为空"
	q:CrsCode="" "CrsCode为空"
	q:CrsActiveFlag="" "CrsActiveFlag为空"
	q:$D(^User.DHCACourseI("Code",CrsCode)) "0^代码重复"
	s:CrsDob'="" CrsDob=$zd(CrsDob,3)
	s obj=##class(User.DHCACourse).%New()
	s obj.CrsCode=CrsCode
	s obj.CrsDesc=CrsDesc
	s obj.CrsActiveFlag=CrsActiveFlag
	S obj.CrsDob=CrsDob
	s sc=obj.%Save()
	TSTART
	if (sc)
	{
		TCOMMIT 
		S CrsRowid=Obj.%ID()
		s result="新增成功^"_CrsRowid
	}
	else
	{
		TROLLBACK
		s result="新增失败"
	} 
	d obj.%Close()   
	q result
}

/// CreateDate:2023-09-14  Fountion：更新+新增数据  Creator:翁瑞珍  Table:DHCA_Course
/// Input:Crs_Rowid,CrsCode,CrsDesc,CrsActiveFlag,CrsDob   Output:result
/// Others:w ##class(web.FirstDay).SaveDate("","11","科学","Y","1995-12-20")
ClassMethod SaveDate(CrsRowid As %String, CrsCode As %String, CrsDesc As %String, CrsActiveFlag As %String, CrsDob As %String) As %String
{
	q:CrsCode="" "0^代码为空"
	q:$D(^User.DHCACourseI("Code",CrsCode)) "0^代码重复"
	q:CrsDesc="" "0^名称为空"
	q:CrsDob="" "0^日期为空"
	if (CrsRowid="")
	    {
		   s obj=##class(User.DHCACourse).%New() //新增数据
		}
	else
	    {
		   s obj=##class(User.DHCACourse).%OpenId(CrsRowid) //修改更新数据
		}
	if (obj)
	{
	   s obj.CrsCode=CrsCode
	   s obj.CrsDesc=CrsDesc
	   s obj.CrsActiveFlag=CrsActiveFlag
	   s:CrsDob'="" CrsDob=$zdh(CrsDob,3)
	   s obj.CrsDob=CrsDob
	   s sc=obj.%Save() 
       TSTART
	   if (sc=1)
       {
	      TCOMMIT 
	      s CrsRowid=obj.%Id()
	      s result="数据更新成功^"_CrsRowid
	   }
	   else
	   {
	      TROLLBACK
	      s result="数据更新失败"
	   }
	   d obj.%Close() 
	}
	else
	{
		s result="数据不存在"
	}   
	q result
}

/// Fountion：删除数据
/// CreateDate:2023-09-14
/// Creator:翁瑞珍
/// Table:DHCA_Course
/// Input:Crs_Rowid
/// Output:result
/// Others:w ##class(web.FirstDay).DeleteDate(16)
ClassMethod DeleteDate(CrsRowid As %String) As %String
{
	q:CrsRowid="" "CrsRowid为空"
	s obj=##class(User.DHCACourse).%OpenId(CrsRowid)
	if (obj)
	{
		s sc=##class(User.DHCACourse).%DeleteId(CrsRowid)
		///s sc=obj.%Save()
	    TSTART
	    if (sc)
	    {
		   TCOMMIT 
		   s result="删除成功"
	    }
	    else
	    {
		   TROLLBACK
		   s result="删除失败"
	    }
	    d obj.%Close()  
    }
    else
    {
	    s result="数据不存在" 
    }  
	q result
}

/// Fountion：查询数据
/// CreateDate:2023-09-14
/// Creator:翁瑞珍
/// Table:DHCA_Course
/// Input:Crs_Rowid
/// Output:result
/// Others:w ##class(web.FirstDay).SelectDate(18)
ClassMethod SelectDate(CrsRowid As %String) As %String
{
	q:CrsRowid="" "CrsRowid为空"
	s obj=##class(User.DHCACourse).%OpenId(CrsRowid)
	if (obj)
	{
		s CrsCode=obj.CrsCode
		s CrsDesc=obj.CrsDesc
		s CrsActiveFlag=obj.CrsActiveFlag
		s CrsDob=obj.CrsDob
		s:CrsDob'="" CrsDob=##class(websys.Conversions).CurrencyLogicalToHtml(CrsDob)
	    s result="代码:"_CrsCode_",名称:"_CrsDesc_",有效标志:"_CrsActiveFlag_",日期:"_CrsDob
	    d obj.%Close()
    }
    else
    {
	    s result="数据不存在" 
    }   
	q result
}

}
