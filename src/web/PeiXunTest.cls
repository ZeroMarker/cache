Class web.PeiXunTest Extends %RegisteredObject
{

/// Function: 实现通过rowid来查询学生数据，第一种储存方式：DHC_Student
/// CreateDate: 2022-08-16
/// Creator: 周玉玲
/// Others: w ##class(web.PeiXunTest).GetDataById()
ClassMethod GetDataById(StRowId As %String) As %String
{
	q:StRowId="" "StRowId不能为空"
	;^web.DHCStudentD(1)=$lb("","01","小明",1,57977)
	q:$data(^web.DHCStudentD(StRowId))=0 "数据不存在"
	s StCode = $Lg($g(^web.DHCStudentD(StRowId)),2) /// 学号
	s StName = $Lg($g(^web.DHCStudentD(StRowId)),3) /// 姓名
	s StSexDR = $Lg($g(^web.DHCStudentD(StRowId)),4) /// 性别
	s SexDesc=""
	if (StSexDR'="") s SexDesc = $p(^CT("SEX",StSexDR),"^",2) /// 性别转换
	s StDob = $Lg($g(^web.DHCStudentD(StRowId)),5)
	if (StDob'="") s StDob = $zd(StDob,3) /// 转换出生日期
	s result = "学号:"_StCode_",姓名:"_StName_",性别:"_SexDesc_",出生日期:"_StDob
	q result
}

/// Function: 实现通过rowid来查询学生数据，第二种储存方式：DHCA_Student
/// CreateDate: 2022-08-16
/// Creator: 周玉玲
/// Others: w ##class(web.PeiXunTest).GetDataAById()
ClassMethod GetDataAById(StRowId As %String) As %String
{
	q:StRowId="" "StRowId不能为空"
	q:$data(^web.DHCAStudentD(StRowId))=0 "数据不存在"
	s StCode = $p($g(^web.DHCAStudentD(StRowId)),"^",1) /// 学号
	s StName = $p($g(^web.DHCAStudentD(StRowId)),"^",2) /// 姓名
	s StSexDR = $p($g(^web.DHCAStudentD(StRowId)),"^",3) /// 性别
	s SexDesc=""
	if (StSexDR'="") s SexDesc = $p(^CT("SEX",StSexDR),"^",2) /// 性别转换
	s StDob = $p($g(^web.DHCAStudentD(StRowId)),"^",4)
	if (StDob'="") s StDob = $zd(StDob,3) /// 转换出生日期
	s result = "学号:"_StCode_",姓名:"_StName_",性别:"_SexDesc_",出生日期:"_StDob
	q result
}

/// Function: 通过学号查找学生的姓名、性别和出生日期（无索引）
/// Others: d ##class(web.PeiXunTest).GetList1("")
ClassMethod GetList1(Code As %String) As %String
{
	s StRowId = 0
	for
	{
		s StRowId = $o(^DHCSTUDENTZHOUYL(StRowId))
		q:StRowId=""
		s DataStr = $g(^DHCSTUDENTZHOUYL(StRowId))
		continue:DataStr=""
		s StCode = $p(DataStr,"^",1)
		continue:(Code'="")&(StCode'=Code)
		s StName = $p(DataStr,"^",2)
		s StSexDR = $p(DataStr,"^",3)
		s SexDesc=""
		if (StSexDR'="") s SexDesc = $p(^CT("SEX",StSexDR),"^",2)
		s StDob = $p(DataStr,"^",4)
		s:StDob'="" StDob = $zd(StDob,3)
		s result=StCode_" "_StName_" "_SexDesc_" "_StDob
		w result ,!
	}
}

/// Function: 通过学号查找学生的姓名、性别和出生日期（有索引）
/// Others: d ##class(web.PeiXunTest).GetListByCode("")
ClassMethod GetListByCode(Code As %String) As %String
{
	q:Code="" ""
	;^DHCSTUDENTZHOUYL(0,"Code","05",5)=""
	if ($d(^DHCSTUDENTZHOUYL(0,"Code",Code))) /// 存在Code索引，通过索引去查找数据
	{
		s StRowId = $o(^DHCSTUDENTZHOUYL(0,"Code",Code,0)) /// 取到主键
		s DataStr = $g(^DHCSTUDENTZHOUYL(StRowId))
		s StCode = $p(DataStr,"^",1)
		s StName = $p(DataStr,"^",2)
		s StSexDR = $p(DataStr,"^",3)
		s SexDesc=""
		if (StSexDR'="") s SexDesc = $p(^CT("SEX",StSexDR),"^",2)
		s StDob = $p(DataStr,"^",4)
		s:StDob'="" StDob = $zd(StDob,3)
		s result=StCode_" "_StName_" "_SexDesc_" "_StDob
		w result ,!
	}
}

/// Function:   SQL Insert操作
/// CreateData: 2022-08-17
/// Creator:    zyl
/// Table:      DHC_Student_ZhouYuLing
/// Input:      StCode 学号 StName 姓名 StSexDR 性别 StDob 生日
/// Output:     新增成功 新增失败
/// Others:     w ##class(web.PeiXunTest).SQLInsert("27","huanhuan","1","1999-01-21")
ClassMethod SQLInsert(StCode As %String, StName As %String, StSexDR As %String, StDob As %String) As %String
{
	   q:(StCode="")||(StName="") "学号或者姓名不能为空!"
	   s result=""
	   TSTART
	   s StDob = $zdh(StDob,3)
	   &sql(
	       INSERT INTO SQLUser.DHC_Student_ZhouYuLing VALUES (:StCode,:StName,:StSexDR,:StDob)
	       )
	       if (SQLCODE=0)
	       {
		       s id =%ROWID
		       TCOMMIT
		       s result="新增数据成功,数据的id为:"_id
	       }
	       else
	       {
		       s ErrorInfo = %msg
		       TROLLBACK
		       s result="新增数据失败,失败原因:"_ErrorInfo
	       }
	       q result
}

/// Function:  PLIST数据新增
/// w ##class(web.PeiXunTest).PLISTInsert("19","倩倩","2","2002-10-08")
ClassMethod PLISTInsert(StCode As %String, StName As %String, StSexDR As %String, StDob As %String) As %String
{
	  k PLIST
	  q:(StCode="")||(StName="") "学号或者姓名不能为空!"
	  s result=""
	  TSTART
	  s StDob = $zdh(StDob,3)
	  s PLIST(2)=StCode
	  s PLIST(3)=StName
	  s PLIST(4)=StSexDR
	  s PLIST(5)=StDob
	  &sql(
	      INSERT INTO SQLUser.DHC_Student_ZhouYuLing VALUES :PLIST()
	  )
	  if (SQLCODE=0)
	       {
		       s id =%ROWID
		       TCOMMIT
		       s result="新增数据成功,数据的id为:"_id
	       }
	       else
	       {
		       s ErrorInfo = %msg
		       TROLLBACK
		       s result="新增数据失败,失败原因:"_ErrorInfo
	       }
	       q result
}

/// Function:  SQL数据删除
/// w ##class(web.PeiXunTest).SQLDelete(19)
ClassMethod SQLDelete(StRowId As %String) As %String
{
	s result=""
	q:StRowId="" "StRowId为空"
	q:$d(^DHCSTUDENTZHOUYL(StRowId))=0 "数据不存在,无法删除"
    TSTART
    &sql(
         DELETE FROM SQLUser.DHC_Student_ZhouYuLing
         WHERE St_RowId=:StRowId 
    )
    if (SQLCODE=0)
    {
	    TCOMMIT
	    s result="数据删除成功"
    }
    else
    {
	    TROLLBACK
	    s result="数据删除失败^"_%msg
    }
    q result
}

/// Function:  SQL数据修改
/// Others:   w ##class(web.PeiXunTest).SQLUpdate("13","13","陈一","1","1997-01-21")
ClassMethod SQLUpdate(StRowId As %String, StCode As %String, StName As %String, StSexDR As %String, StDob As %String) As %String
{
	 if (StRowId="") q "rowid为空,无法修改"
	 if ($d(^DHCSTUDENTZHOUYL(StRowId))=0) q "数据不存在,无法修改"
	 s StDob = $zdh(StDob,3)
	 TSTART
	 &sql(
	     UPDATE SQLUser.DHC_Student_ZhouYuLing SET St_Code=:StCode,St_Name= :StName,St_Sex_DR= :StSexDR,St_Dob= :StDob
	     WHERE St_RowId= :StRowId
	 )
	 if (SQLCODE=0)
	       {
		       s id =%ROWID
		       TCOMMIT
		       s result="修改数据成功,数据的id为:"_id
	       }
	       else
	       {
		       s ErrorInfo = %msg
		       TROLLBACK
		       s result="修改数据失败,失败原因:"_ErrorInfo
	       }
	       q result
}

/// Function: PLIST 修改
/// w ##class(web.PeiXunTest).PLISTUpdate("17","25","xisisi","2","1996-05-18")
ClassMethod PLISTUpdate(StRowId As %String, StCode As %String, StName As %String, StSexDR As %String, StDob As %String) As %String
{
	  k PLIST
	  s result=""
	  if (StRowId="") q "rowid为空,无法修改"
	  q:StName="" "姓名不能为空"
	  if ($d(^DHCSTUDENTZHOUYL(StRowId))=0) q "数据不存在,无法修改"
	  s:StDob'="" StDob = $zdh(StDob,3)
	  s PLIST(3)=StName
	  s PLIST(4)=StSexDR
	  s PLIST(5)=StDob
	  &sql(
	       UPDATE SQLUser.DHC_Student_ZhouYuLing
	       VALUES :PLIST()
	       WHERE St_RowId=:StRowId
	  )
	  if (SQLCODE=0)
	       {
		       s id =%ROWID
		       s result="修改数据成功,数据的id为:"_id
	       }
	       else
	       {
		       s result="修改数据失败,失败原因:"_%msg
	       }
	       q result
}

/*&sql(
	     SELECT PAPER_WorkProvince_DR,PAPER_WorkCity_DR,PAPER_WorkArea_DR
	     INTO :StCode,:StName,:StSexDR
	     FROM DHC_Person WHERE St_RowId=:StRowId
	  )*/
/// Function: 查询数据（单条数据）
/// w ##class(web.PeiXunTest).GetDataByIdOne(17)
ClassMethod GetDataByIdOne(StRowId As %String) As %String
{
	s result=""
	q:StRowId="" "rowid为空"
	q:$d(^DHCSTUDENTZHOUYL(StRowId))=0 "数据不存在"
	&sql(
	     SELECT St_Code,St_Name,St_Sex_DR->CTSEX_Desc,TO_CHAR(St_Dob,'YYYY-MM-DD')
	     INTO :StCode,:StName,:StSexDR,:StDob
	     FROM SQLUser.DHC_Student_ZhouYuLing WHERE St_RowId=:StRowId
	  )
	if (SQLCODE=0)
	{
		s result= "学号："_StCode_",姓名："_StName_",性别："_StSexDR_",出生日期："_StDob
	}
	q result
}

/// Function: 获取全部数据
/// d ##class(web.PeiXunTest).GetAllData()
ClassMethod GetAllData() As %String
{
	s sqlstr = "SELECT St_RowId FROM SQLUser.DHC_Student_ZhouYuLing WHERE St_Sex_DR=1"
	s rs =##class(%Library.ResultSet).%New()
	s sc = rs.Prepare(sqlstr)
	if (sc=1)
	{
		d rs.Execute()
		while (rs.Next())
		{
			s StRowId = rs.Data("St_RowID")
			w StRowId ,!
		}
	}
}

/// Function: SQL数据查询
/// Others: d ##class(web.PeiXunTest).SQLGetList(14)
ClassMethod SQLGetList(StRowId As %String) As %String
{
	if (StRowId="") q "StRowId为空"
	k PLIST
	&sql(
	     SELECT St_Code,St_Name,St_Sex_DR,St_Dob
	     INTO :PLIST()
	     FROM SQLUser.DHC_Student_ZhouYuLing
	)
	s count=$O(PLIST(""),-1)
	for i=1:1:count
	{
		if ($d(PLIST(i)))
		{
			w PLIST(i) ,!
		}
	}
}

/// Function:%Query 的应用
/// do ##class(%ResultSet).RunQuery("web.PeiXunTest","GetDataList","","")
Query GetDataList(Code As %String, Name As %String) As %Query(ROWSPEC = "StRowId:%String,StCode:%String:学号,StName:%String:姓名,StSexDR:%String:性别,StDob:%String:出生日期")
{
}

ClassMethod GetDataListExecute(ByRef qHandle As %Binary, Code As %String, Name As %String) As %Status
{
	s repid = $I(^CacheTemp)
	s ind = 1
	s StRowId=0
	for
	{
		s StRowId = $o(^DHCSTUDENTZHOUYL(StRowId))
		q:StRowId=""
		s StCode = $p($g(^DHCSTUDENTZHOUYL(StRowId)),"^",1) /// 学号
		s StName = $p($g(^DHCSTUDENTZHOUYL(StRowId)),"^",2) /// 姓名
		s StSexDRA = $p($g(^DHCSTUDENTZHOUYL(StRowId)),"^",3) /// 性别
		s:StSexDRA'="" StSexDR = $P($g(^CT("SEX",StSexDRA)),"^",2)  /// 取性别的描述
		s StDob = $p($g(^DHCSTUDENTZHOUYL(StRowId)),"^",4) /// 出生日期
		s:StDob'="" StDob = $zd(StDob,3) /// 出生日期
		d OutputRow
	}
	
	
	s qHandle = $lb(0,repid,0)
	Quit $$$OK
OutputRow
    s Data =$lb(StRowId,StCode,StName,StSexDR,StDob)
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
    q
}

/// do ##class(%ResultSet).RunQuery("User.Test032","GetWebSysList","","")
Query GetWebSysList(RowId As %String, Desc As %String) As websys.Query(ROWSPEC = "DHCRowId:%String,DHCCode:%String:代码,DHCName:%String:姓名,DHCDobDate:%String:生日,DHCSexDR:%String:性别,DHCActive:%String:是否有效")
{
}

ClassMethod GetWebSysListExecute(ByRef qHandle As %Binary, RowId As %String, Desc As %String) As %Status
{
	s repid = $I(^CacheTemp)
	s ind = 1
	
	if (RowId'="")
	{
		s DHCRowId = RowId
		s DHCCode = $list(^User.DHCStudentD(DHCRowId),2)
		s DHCName = $list(^User.DHCStudentD(DHCRowId),3)
		s DHCDob = $list(^User.DHCStudentD(DHCRowId),4)
		s:DHCDob'="" DHCDobDate = $zd(DHCDob,3) /// 生日
		s DHCSexDRA = $list(^User.DHCStudentD(DHCRowId),7)
		s DHCActive = $list(^User.DHCStudentD(DHCRowId),6)
		s:DHCActive="Y" DHCActive="有效"
		s:DHCActive="N" DHCActive="无效"
		s:DHCSexDRA'="" DHCSexDR = $P($g(^CT("SEX",DHCSexDRA)),"^",2)  /// 取性别的描述
		d OutputSYSRow
	}
	if (RowId = "")
	{
		s DHCRowId = 0
	    for
         {
			s DHCRowId = $o(^User.DHCStudentD(DHCRowId))
			q:DHCRowId=""
			
			s DHCCode = $list(^User.DHCStudentD(DHCRowId),2)
		    s DHCName = $list(^User.DHCStudentD(DHCRowId),3)
		    s DHCDob = $list(^User.DHCStudentD(DHCRowId),4)
		    s:DHCDob'="" DHCDobDate = $zd(DHCDob,3) /// 生日
		    s DHCSexDRA = $list(^User.DHCStudentD(DHCRowId),7)
		    s DHCActive = $list(^User.DHCStudentD(DHCRowId),6)
		    s:DHCActive="Y" DHCActive="有效"
		    s:DHCActive="N" DHCActive="无效"
		    s:DHCSexDRA'="" DHCSexDR = $P($g(^CT("SEX",DHCSexDRA)),"^",2)  /// 取性别的描述
		    if (DHCName[Desc)
		    {
			    d OutputSYSRow
		    }
			
		  }
	}
	
	s qHandle = $lb(0,repid,0)
	Quit $$$OK
OutputSYSRow
    s Data =$lb(DHCRowId,DHCCode,DHCName,DHCDobDate,DHCSexDR,DHCActive)
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
    q
}

ClassMethod GetDataListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataListExecute ]
{
	s AtEnd =$List(qHandle,1)
	s repid =$List(qHandle,2)
	s ind =$List(qHandle,3)
	
	s ind = $o(^CacheTemp(repid,ind))
	if ind=""
	{
		///if there are no more rows,finish fetching...
		s AtEnd = 1
		s Row=""
	}
	else
	{
		s Row = ^CacheTemp(repid,ind)
	}
	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetDataListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataListExecute ]
{
 
	s repid = $list(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// SQL query
/// do ##class(%ResultSet).RunQuery("User.Test032","GetWebSQLList","","")
Query GetWebSQLList(RowId As %String, Desc As %String) As %SQLQuery(ROWSPEC = "DHCCode:%String:代码,DHCName:%String:姓名,DHCDobDate:%String:生日,DHCSexDR:%String:性别,DHCActive:%String:是否有效")
{
	SELECT DHC_Code,DHC_Name,DHC_Dob,DHC_Sex_DR,DHC_Active
	FROM SQLUser.DHC_Student
}

/// Function: 调用query方法
/// Others: do ##class(User.Test032).UseQuery()
ClassMethod UseQuery()
{
	s result=##class(%ResultSet).%New("User.Test032:GetWebSQLList")
	if (result)
	{
		s sc=result.Execute("","")
		if (sc=1)
		{
			while (result.Next())
			{
				s DHCCode = result.Data("DHCCode")
				s DHCName = result.GetData(2)
				
				w DHCCode_" "_DHCName ,!
			}
		}
	}
}

/// 面向对象操作：
/// Function: 数据新增
/// Input:    StCode,StName,StSexDR,StDob
/// Others:   w ##class(web.PeiXunTest).AddData("20","Test","1","2012-07-08")
ClassMethod AddData(StCode As %String, StName As %String, StSexDR As %String, StDob As %String) As %String
{
	s result=""
	q:StCode="" "学号不能为空"
	q:StName="" "姓名不能为空"
	q:$d(^DHCSTUDENTZHOUYL(0,"Code",StCode)) "学号不允许重复"
	s:StDob'="" StDob = ##class(websys.Conversions).DateHtmlToLogical(StDob) /// 或者用$zdh(StDob,3)
	s oref = ##class(User.DHCSTUDENTZhouYuLing).%New()
	if (oref)
	{
		s oref.StCode = StCode /// 赋值
		s oref.StName = StName
		// s SexObj = ##class(User.CTSex).%OpenId(StSexDR)
		// if (SexObj) s oref.StSexDR = SexObj /// 对象赋值 (不常用)
		d oref.StSexDRSetObjectId(StSexDR) /// 常用的方式
		s oref.StDob = StDob
		TSTART
		s sc = oref.%Save()
		if (sc = 1)
		{
			TCOMMIT
			s StRowId = oref.%Id()
			s result = "保存成功，数据的RowId为："_StRowId
		}
	    else
	    {
		    TROLLBACK
		    s result = "保存失败^"_system.Status.GetErrorTest(sc) ///或者$system.OBJ.DisplayError(sc)
	    }
	    d oref.%Close()
	}
	q result
}

/// Function: 数据修改
/// Input:    StRowId,StCode,StName,StSexDR,StDob
/// Others:   w ##class(web.PeiXunTest).UpOneData("27","20","TestA","1","2013-04-12")
ClassMethod UpOneData(StRowId As %String, StCode As %String, StName As %String, StSexDR As %String, StDob As %String) As %String
{
	s result=""
	q:StRowId="" "StRowId不能为空"
	q:StCode="" "学号不能为空"
	q:StName="" "姓名不能为空"
	;q:$d(^DHCSTUDENTZHOUYL(0,"Code",StCode)) "学号不允许重复"
	s flag = $d(^DHCSTUDENTZHOUYL(0,"Code",StCode))
	s RowId = $o(^DHCSTUDENTZHOUYL(0,"Code",StCode,0))
	if (flag>0)&(RowId'=StRowId) q "学号重复"
	s:StDob'="" StDob = ##class(websys.Conversions).DateHtmlToLogical(StDob) /// 或者用$zdh(StDob,3)
	s oref = ##class(User.DHCSTUDENTZhouYuLing).%OpenId(StRowId)
	if (oref)
	{
		s oref.StCode = StCode /// 赋值
		s oref.StName = StName
		// s SexObj = ##class(User.CTSex).%OpenId(StSexDR)
		// if (SexObj) s oref.StSexDR = SexObj /// 对象赋值 (不常用)
		d oref.StSexDRSetObjectId(StSexDR) /// 常用的方式
		s oref.StDob = StDob
		TSTART
		s sc = oref.%Save()
		if ($$$ISOK(sc))  /// sc=1
		{
			TCOMMIT
			s StRowId = oref.%Id()
			s result = "修改成功，数据的RowId为："_StRowId
		}
	    else
	    {
		    TROLLBACK
		    s result = "修改失败^"_system.Status.GetErrorTest(sc) ///或者$system.OBJ.DisplayError(sc)
	    }
	    d oref.%Close()
	}
	else
	{
		s result = "对象不存在"
	}
	q result
}

/// Function: 数据保存（新增或者修改）
/// Input:    StRowId,StCode,StName,StSexDR,StDob
/// Others:   w ##class(web.PeiXunTest).SaveData("28","21","BCDA","1","2008-12-25")
ClassMethod SaveData(StRowId As %String, StCode As %String, StName As %String, StSexDR As %String, StDob As %String) As %String
{
	s result=""
	q:StCode="" "学号不能为空"
	q:StName="" "姓名不能为空"
	s:StDob'="" StDob = ##class(websys.Conversions).DateHtmlToLogical(StDob) /// 或者用$zdh(StDob,3)
	if (StRowId="") /// RowId为空，新增数据
	{
		s oref = ##class(User.DHCSTUDENTZhouYuLing).%New()
	}
	else /// RowId不为空，修改数据
	{
		s oref = ##class(User.DHCSTUDENTZhouYuLing).%OpenId(StRowId)
	}
	if (oref)
	{
		s oref.StCode = StCode /// 赋值
		s oref.StName = StName
		// s SexObj = ##class(User.CTSex).%OpenId(StSexDR)
		// if (SexObj) s oref.StSexDR = SexObj /// 对象赋值 (不常用)
		d oref.StSexDRSetObjectId(StSexDR) /// 常用的方式
		s oref.StDob = StDob
		TSTART
		s sc = oref.%Save()
		if (sc = 1)
		{
			TCOMMIT
			s Id = oref.%Id()
			if (StRowId="") s result = "新增成功，数据的RowId为："_Id
			else  s result = "修改成功，数据的RowId为："_Id	
		}
	    else
	    {
		    TROLLBACK
		    s result = "保存失败^"_system.Status.GetErrorTest(sc) ///或者$system.OBJ.DisplayError(sc)
	    }
	    d oref.%Close()
	}
	q result
}

/// Function: 数据删除
/// Others:   w ##class(web.PeiXunTest).DeleteData("")
ClassMethod DeleteData(StRowId As %String) As %String
{
	s result=""
	q:StRowId="" "StRowId不能为空"
	s oref = ##class(User.DHCSTUDENTZhouYuLing).%OpenId(StRowId)
	if (oref)
	{
	   TSTART
	   s sc = ##class(User.DHCSTUDENTZhouYuLing).%DeleteId(StRowId)
	   if ($$$ISOK(sc))
	   ;if (sc=1)
	   {
		  TCOMMIT
		  s result="数据删除成功"
	   }
	   else
	   {
		   TROLLBACK
		   s sc = $system.OBJ.DisplayError(sc)
		   s result="数据删除失败,错误原因："_sc
	   }
	   d oref.%Close()
	}
	else
	{
		s result = "数据不存在"
	}
	q result
}

/// Function: 数据查询
/// Input:    StRowId
/// Others:  w ##class(web.PeiXunTest).OpenData("27")
ClassMethod OpenData(StRowId As %String) As %String
{
   	s result=""
	q:StRowId="" "RowId不能为空"
	s oref = ##class(User.DHCSTUDENTZhouYuLing).%OpenId(StRowId)
	if (oref)
	{
		s StCode = oref.StCode /// 赋值
		s StName = oref.StName
		s StSexDR = oref.StSexDR.%Id()
		s StSexDR = oref.StSexDR.CTSEXDesc
		s StDob = oref.StDob
		s:StDob'="" StDob = ##class(websys.Conversions).DateLogicalToHtml(StDob) /// 或者用$zdh(StDob,3)
		s result = "学号："_StCode_",姓名："_StName_",性别："_StSexDR_",出生日期："_StDob
		d oref.%Close()
	}
	else
	{
		s result = "数据不存在"
	}
	q result
}

/// Function: 子表新增
/// Input: StRowId,DHCScCourseDR,DHCScScore
/// Others: w ##class(web.PeiXunTest).AddStuCourse("8","5",95)
ClassMethod AddStuCourse(StRowId As %String, DHCScCourseDR As %String, DHCScScore As %String) As %String
{
	s result=""
	q:StRowId="" "RowId不能为空"
	q:DHCScCourseDR="" "课程不能为空"
	q:DHCScScore="" "分数不能为空"
	s obj = ##class(User.DHCSTUDENTZhouYuLingCourse).%New(StRowId)
	if (obj)
	{
		d obj.ParRefSetObjectId(StRowId)
		d obj.DHCScCourseDRSetObjectId(DHCScCourseDR)
		s obj.DHCScScore=DHCScScore
		s sc=obj.%Save()
		if ($$$ISOK(sc))
		{
			s result= "数据新增成功^"_obj.%Id()
		}
		else
		{
			s result= "数据新增失败"_$system.OBJ.DisplayError(sc)
		}
		d obj.%Close()
	}
	q result
}

/// Function: 查询子表数据
/// Input: ParRef
/// d ##class(web.PeiXunTest).GetStuCourseList("4")
ClassMethod GetStuCourseList(ParRef As %String) As %String
{
	if (ParRef'="")
	{
		s StCode = $p(^DHCSTUDENTZHOUYL(ParRef),"^",1)
		s StName = $p(^DHCSTUDENTZHOUYL(ParRef),"^",2)
		s ChildSub=0
		for
		{
		    s ChildSub = $o(^DHCSTUDENTZHOUYL(ParRef,"Course",ChildSub)) q:ChildSub=""
			s DataStr = $g(^DHCSTUDENTZHOUYL(ParRef,"Course",ChildSub))
			s StScRowId = ParRef_"||"_ChildSub
			s DHCScCourseDR = $p(DataStr,"^",1)
			s:DHCScCourseDR'="" DHCScCourseDR = $p($g(^DHCCOURSE(DHCScCourseDR)),"^",2) /// 课程名称
			s DHCScScore = $p(DataStr,"^",2) /// 成绩
			w StCode_"  "_StName_"  "_DHCScCourseDR_"  "_DHCScScore ,!
		}
	}
	else
	{
	   s StRowId=0
	   for
	   {
		   s StRowId = $o(^DHCSTUDENTZHOUYL(StRowId)) q:StRowId=""
		   s ChildSub=0
		   for
		   {
			   s ChildSub = $o(^DHCSTUDENTZHOUYL(StRowId,"Course",ChildSub)) q:ChildSub=""
			   s DataStr = $g(^DHCSTUDENTZHOUYL(StRowId,"Course",ChildSub))
			   s StScRowId = StRowId_"||"_ChildSub
			   s DHCScCourseDR = $p(DataStr,"^",1)
			   s:DHCScCourseDR'="" DHCScCourseDR = $p($g(^DHCCOURSE(DHCScCourseDR)),"^",2) /// 课程名称
			   s DHCScScore = $p(DataStr,"^",2) /// 成绩
			   w StScRowId_"  "_DHCScCourseDR_"  "_DHCScScore ,!
		   }
	    }
	}
}

/// Function: 父子表保存（多表操作）
/// Input: StCode,StName,StSexDR,StDob,DHCScCourseDR,DHCScScore
/// Others: w ##class(web.PeiXunTest).SaveAllData("","","","","","")
ClassMethod SaveAllData(StCode As %String, StName As %String, StSexDR As %String, StDob As %String, DHCScCourseDR As %String, DHCScScore As %String) As %String
{
	s result=""
	q:StCode="" "学号不能为空"
	q:StName="" "姓名不能为空"
	/// 保存学生信息
	TSTART
	s StudentSc=##class(web.PeiXunTest).AddData(StCode,StName,StSexDR,StDob)
	if (StudentSc["成功")
	{
		s StRowId=$p(StudentSc,"^",2)
		if (DHCScCourseDR'="")
		{
			s sc = ##class(web.PeiXunTest).AddStuCourse(StRowId,DHCScCourseDR,DHCScScore)
			if (sc["成功")
			{
				TCOMMIT
				s result = "保存成功"
			}
			else
			{
				TROLLBACK
				s result = "学生选课保存失败"
			}
		}
	}
	else
	{
		TROLLBACK
		s result = "学生保存失败"
	}
	q result
}

/// SQL query
/// do ##class(%ResultSet).RunQuery("User.Test032","GetXUQList","","")
Query GetXUQList(DHCName) As %SQLQuery(ROWSPEC = "DHCCode:%String:代码,DHCName:%String:姓名,DHCDobDate:%String:生日,DHCSexDR:%String:性别,DHCActive:%String:是否有效")
{
	SELECT DHC_Code,DHC_Name,DHC_Dob,DHC_Sex_DR,DHC_Active
	FROM SQLUser.DHC_Student WHERE DHC_Name=:DHCName
}

/// Function: 调用query方法
/// Others: do ##class(User.Test032).UseqQuery()
ClassMethod UseqQuery()
{
	s result=##class(%ResultSet).%New("web.PeiXunTest:emradm")
	if (result)
	{
		s sc=result.Execute("")
		if (sc=1)
		{
			while (result.Next())
			{
				s DHCCode = result.Data("DHCCode")
				s DHCName = result.GetData(2)
				
				w DHCCode_" "_DHCName ,!
			}
		}
	}
}

/// Creator：	ZYL
/// CreateDate：2022-09-08
/// Desc：		入院信息(emr_adm)
/// Input:		就诊号：AEpisodeID
/// 			d ##class(%ResultSet).RunQuery("web.PeiXunTest","emradm","4")
Query emradm(AEpisodeID As %String, Name As %String, ExpDataAry As %ArrayOfDataTypes = "") As %Query(ROWSPEC = "org_code,org_name,name,mdtrt_sn,psn_no,mdtrtsn,chfcomp,dise_now,dise_his,physexm_tprt,physexm_pule,physexm_vent_frqu,physexm_systolic_pre,physexm_dstl_pre,physexm_height,physexm_wt,physexm_ordn_stas,physexm_skin_musl,physexm_spef_lymph,physexm_head,physexm_neck,physexm_chst,physexm_abd,physexm_finger_exam,physexm_genital_area,physexm_spin,physexm_all_fors,nersys") [ SqlName = emr_adm, SqlProc ]
{
}

ClassMethod emradmExecute(ByRef qHandle As %Binary, AEpisodeID As %String, Name As %String, ExpDataAry As %ArrayOfDataTypes = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	
		// 初始化字段
		s (orgcode,orgname,mdtrtsn,psnno,mdtrtsn,chfcomp,disenow,disehis,physexmtprt,physexmpule,physexmventfrqu,physexmsystolicpre,physexmdstlpre,physexmheight,physexmwt,physexmordnstas,physexmskinmusl,physexmspeflymph,physexmhead,physexmneck,physexmchst,physexmabd,physexmfingerexam,physexmgenitalarea,physexmspin,physexmallfors,nersys) = ""
		s name = Name
		s orgcode ="4001" //机构编码
		s orgname="长丰县人民医院" //机构名称
		s mdtrtsn= AEpisodeID //就医流水号
		s InstanceID = ##Class(EMRservice.BL.InterfaceRecordInfoINSU1).GetValidInstanceIDListByGlossary(AEpisodeID,"HDSD00.13.01")
	    s InstanceID = $P(InstanceID,"^",1)
	    q:(InstanceID="")
	
	    if ($IsObject(ExpDataAry))
        {
	        s psnno= ExpDataAry.GetAt("psn_no") // 人员编号
        }
    
	    // 登记RowId
 	    s PapmiDR = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(AEpisodeID)
 	
 	    s arr = ##Class(EMRservice.BL.BLScatterData).GetNewDataByGlossaryCategory(AEpisodeID,"HDSD00.13.01")
	    s mdtrtsn= ##class(EMRservice.HISInterface.PatientInfoAssist).IPRecordNoInfo(AEpisodeID) // 住院号
 
	    s chfcomp= arr.GetAt("HDSD00.13.114") // 主诉
	    s disenow= arr.GetAt("HDSD00.13.095")  // 现病史
	    s disehis= arr.GetAt("HDSD00.13.042") // 疾病史（含外伤）
	    s physexmtprt= $P(arr.GetAt("HDSD00.13.088"),"℃",1) // 体格检查–体温（℃）
	    s physexmpule= $P(arr.GetAt("HDSD00.13.080"),"次",1) // 体格检查 – 脉率（次 /mi数字）
	    s physexmventfrqu= arr.GetAt("HDSD00.13.077") // 体格检查–呼吸频率
	    s physexmsystolicpre= arr.GetAt("HDSD00.13.085") // 体格检查 – 收缩压 （mmHg）
	    s physexmdstlpre= arr.GetAt("HDSD00.13.086") // 体格检查 – 舒张压 （mmHg）
	    s physexmheight= arr.GetAt("HDSD00.13.083") // 体格检查–身高（cm）
	    s physexmwt= arr.GetAt("HDSD00.13.089") // 体格检查–体重（kg）
	    s physexmordnstas= arr.GetAt("HDSD00.13.094") // 体格检查 – 一般状况 检查结果
	    s physexmskinmusl= arr.GetAt("HDSD00.13.081") // 体格检查 – 皮肤和黏膜检查结果
	    s physexmspeflymph= arr.GetAt("HDSD00.13.082") // 体格检查 – 全身浅表淋巴结检查结果
	    s physexmhead= arr.GetAt("HDSD00.13.091") // 体格检查 – 头部及其器官检查结果
	    s physexmneck= arr.GetAt("HDSD00.13.079") // 体格检查 – 颈部检查结果
	    s physexmchst= arr.GetAt("HDSD00.13.093") // 体格检查 – 胸部检查结果
	    s physexmabd= arr.GetAt("HDSD00.13.075") // 体格检查 – 腹部检查结果
	    s physexmfingerexam= arr.GetAt("HDSD00.13.076") // 体格检查 -- 肛门指诊检查结果描述
	    s physexmgenitalarea= arr.GetAt("HDSD00.13.092") // 体格检查 -- 外生殖器检查结果
	    s physexmspin= arr.GetAt("HDSD00.13.078") // 体格检查 -- 脊柱检查结果
	    s physexmallfors= arr.GetAt("HDSD00.13.087") // 体格检查 -- 四肢检查结果
	    s nersys= arr.GetAt("HDSD00.13.084") // 体格检查 -- 神经系统检查结果
	    
	    set ^CacheTemp(repid, ind) = $LB(orgcode,orgname,name,mdtrtsn,psnno,mdtrtsn,chfcomp,disenow,disehis,physexmtprt,physexmpule,physexmventfrqu,physexmsystolicpre,physexmdstlpre,physexmheight,physexmwt,physexmordnstas,physexmskinmusl,physexmspeflymph,physexmhead,physexmneck,physexmchst,physexmabd,physexmfingerexam,physexmgenitalarea,physexmspin,physexmallfors,nersys)
	    set ind = ind + 1
		
    
    Quit $$$OK
}

ClassMethod emradmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = emradmExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod emradmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = emradmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

}
