Class DHCEPRFS.Tool.InitMetaBase Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", ProcedureBlock ]
{

/// Desc:	元数据初始化
/// Debug:	d ##Class(DHCEPRFS.Tool.InitMetaBase).Init()
ClassMethod Init()
{
	d ..InitMetaBaseProvice()
	d ..InitMetaBaseMarriage()
	d ..InitMetaBaseDepartment()
	d ..InitMetaBaseHospital()
	w !,"初始化元数据完成"
}

/// Desc:	初始化元数据--省份表
/// Debug:	d ##Class(DHCEPRFS.Tool.InitMetaBase).InitMetaBaseProvice()
ClassMethod InitMetaBaseProvice()
{
	s order=0
	s ind="0"
	for {
		s ind=$o(^CT("PROV",ind))
		q:(ind ="")
		s code=$p(^CT("PROV",ind),"^",1)	//取编码
		s name=$p(^CT("PROV",ind),"^",2)	//取名称
		s regionDR = $p(^CT("PROV",ind),"^",3)	//地区
		s dateFrom = $p(^CT("PROV",ind),"^",4)	//起始日期
		s dateTo = $p(^CT("PROV",ind),"^",5)	//终止日期

		s date = $p($h,",",1)
		s time = $p($h,",",2)
		if ($l(name,"-")>1)
		{
			s name=$p(name,"-",2)
		}
		s aliasName = ##Class(DHCEPRFS.Util.StringHelper).GetCNCODE(name,3,"")
		s aliasNameInitial = ##Class(DHCEPRFS.Util.StringHelper).GetCNCODE(name,4,"")
		s order=order+1
		s sc = $$InitOneProvince(code,name,name,aliasName,aliasNameInitial,dateFrom,dateTo,date,time,date,time,"DHC",order,"Y")
	}
	
InitOneProvince(argCode, argName, argDesc,argAliasName, argAliasNameInitial,argDateActiveFrom,argDateActiveTo,argCreateDate,argCreateTime,argLastModifyDate,argLastModifyTime,argSource,argOrder,argIsActive)
	s rowid = ""
	&sql(select ID into :rowid from DHCEPRFS_META_B.Province
		where Code = :argCode AND Name = :argName)
	
	w !,rowid
	if (rowid = "")
	{
		&sql(insert into DHCEPRFS_META_B.Province (Code,Name,Description,AliasName,AliasNameInitial,DateActiveFrom,DateActiveTo,CreateDate,CreateTime,LastModifyDate,LastModifyTime,Source,OrderNum,IsActive) 
			values (:argCode,:argName,:argDesc,:argAliasName,:argAliasNameInitial,:argDateActiveFrom,:argDateActiveTo,:argCreateDate,:argCreateTime,:argLastModifyDate,:argLastModifyTime,:argSource, :argOrder,:argIsActive))
	}
	else
	{
		&sql(update DHCEPRFS_META_B.Province set Code=:argCode,Name=:argName,Description=:argDesc,AliasName=:argAliasName,AliasNameInitial=:argAliasNameInitial,DateActiveFrom=:argDateActiveFrom,DateActiveTo=:argDateActiveTo,LastModifyDate=:argLastModifyDate,LastModifyTime=:argLastModifyTime,Source=:argSource,OrderNum=:argOrder,IsActive=:argIsActive
			where id = :rowid)
	}
	
	q "1"
}

/// Desc:	初始化元数据--婚姻状况表
/// Debug:	d ##Class(DHCEPRFS.Tool.InitMetaBase).InitMetaBaseMarriage()
ClassMethod InitMetaBaseMarriage()
{
	s order=0
	s ind="0"
	for {
		s ind=$o(^CT("MAR",ind))
		q:(ind ="")
		s code=$p(^CT("MAR",ind),"^",1)	//取编码
		s name=$p(^CT("MAR",ind),"^",2)	//取名称
		s dateFrom = $p(^CT("MAR",ind),"^",4)	//起始日期
		s dateTo = $p(^CT("MAR",ind),"^",5)	//终止日期
		s date = $p($h,",",1)
		s time = $p($h,",",2)
		s aliasName = ##Class(DHCEPRFS.Util.StringHelper).GetCNCODE(name,3,"")
		s aliasNameInitial = ##Class(DHCEPRFS.Util.StringHelper).GetCNCODE(name,4,"")
		s order=order+1
		s sc = $$InitOneMarriage(code,name,name,aliasName,aliasNameInitial,dateFrom,dateTo,date,time,date,time,"DHC",order,"Y")
	}
	
InitOneMarriage(argCode, argName, argDesc,argAliasName, argAliasNameInitial,argDateActiveFrom,argDateActiveTo,argCreateDate,argCreateTime,argLastModifyDate,argLastModifyTime,argSource,argOrder,argIsActive)
	s rowid = ""
	&sql(select ID into :rowid from DHCEPRFS_META_B.Marriage
		where Code = :argCode AND Name = :argName)
	
	w !,rowid
	if (rowid = "")
	{
		&sql(insert into DHCEPRFS_META_B.Marriage (Code,Name,Description,AliasName,AliasNameInitial,DateActiveFrom,DateActiveTo,CreateDate,CreateTime,LastModifyDate,LastModifyTime,Source,OrderNum,IsActive) 
			values (:argCode,:argName,:argDesc,:argAliasName,:argAliasNameInitial,:argDateActiveFrom,:argDateActiveTo,:argCreateDate,:argCreateTime,:argLastModifyDate,:argLastModifyTime,:argSource, :argOrder,:argIsActive))
	}
	else
	{
		&sql(update DHCEPRFS_META_B.Marriage set Code=:argCode,Name=:argName,Description=:argDesc,AliasName=:argAliasName,AliasNameInitial=:argAliasNameInitial,DateActiveFrom=:argDateActiveFrom,DateActiveTo=:argDateActiveTo,LastModifyDate=:argLastModifyDate,LastModifyTime=:argLastModifyTime,Source=:argSource,OrderNum=:argOrder,IsActive=:argIsActive
			where id = :rowid)
	}
	
	q "1"
}

/// Desc:	初始化元数据--科室表
/// Debug:	d ##Class(DHCEPRFS.Tool.InitMetaBase).InitMetaBaseDepartment()
ClassMethod InitMetaBaseDepartment()
{
	s order=0
	s locType = ""
	for {
		s locType = $o(^CTLOC(0,"LocType",locType))
		q:(locType ="")
		s rowID =""
		for {
			s rowID = $o(^CTLOC(0,"LocType",locType,rowID))
			q:(rowID ="")
			s objCtLoc = $g(^CTLOC(+rowID))

			s name = $p(objCtLoc,"^",2)
			s description = $p(objCtLoc,"^",2)
			s isActive = $p(objCtLoc,"^",14)
			s ctLocType = $p(objCtLoc,"^",13)
			
			s hospitaldr = $p(objCtLoc,"^",22)
			s dateFrom = $p(objCtLoc,"^",24)
			s dateTo = $p(objCtLoc,"^",25)
			s date = $p($h,",",1)
			s time = $p($h,",",2)
			if ($l(name,"-")>1)
			{
				s name=$p(name,"-",2)
			}
			
			//去掉（）括号转字母产生的？号 2023-2-24 yangshun
			s aliasName = $tr(##Class(DHCEPRFS.Util.StringHelper).GetCNCODE(name,3,""),"?")
			s aliasNameInitial = $tr(##Class(DHCEPRFS.Util.StringHelper).GetCNCODE(name,4,""),"?")
			s order=order +1
			s sc = $$InitOneDepartment(rowID,name,description,aliasName,aliasNameInitial,dateFrom,dateTo,date,time,date,time,"DHC",order,isActive,hospitaldr,ctLocType)
		}
	}
InitOneDepartment(argCode, argName, argDesc,argAliasName, argAliasNameInitial,argDateActiveFrom,argDateActiveTo,argCreateDate,argCreateTime,argLastModifyDate,argLastModifyTime,argSource,argOrder,argIsActive,argHospitalArea,argCTLocType)
	s rowid = ""
	&sql(select ID into :rowid from DHCEPRFS_META_B.Department
		where Code = :argCode AND Name = :argName)
	
	w !,rowid
	if (rowid = "")
	{
		&sql(insert into DHCEPRFS_META_B.Department (Code,Name,Description,AliasName,AliasNameInitial,DateActiveFrom,DateActiveTo,CreateDate,CreateTime,LastModifyDate,LastModifyTime,Source,OrderNum,IsActive,HospitalAreaID,CTLocType,DepartmentID) 
			values (:argCode,:argName,:argDesc,:argAliasName,:argAliasNameInitial,:argDateActiveFrom,:argDateActiveTo,:argCreateDate,:argCreateTime,:argLastModifyDate,:argLastModifyTime,:argSource, :argOrder,:argIsActive,:argHospitalArea,:argCTLocType,:argCode))
	}
	else
	{
		&sql(update DHCEPRFS_META_B.Department set Code=:argCode,Name=:argName,Description=:argDesc,AliasName=:argAliasName,AliasNameInitial=:argAliasNameInitial,DateActiveFrom=:argDateActiveFrom,DateActiveTo=:argDateActiveTo,LastModifyDate=:argLastModifyDate,LastModifyTime=:argLastModifyTime,Source=:argSource,OrderNum=:argOrder,IsActive=:argIsActive,HospitalAreaID=:argHospitalArea,CTLocType=:argCTLocType,DepartmentID=:argCode
			where id = :rowid)
	}
	
	q "1"
}

/// Desc:	查询：院区信息
/// Desc:	d ##class(%ResultSet).RunQuery("DHCEPRFS.Tool.InitMetaBase","SQLHospital")
Query SQLHospital() As %SQLQuery(ROWSPEC = "HospitalAreaID:%String,Description:%String,DateFrom:%Date,DateTo:%Date")
{
	select HOSP_RowId as HospitalAreaID ,HOSP_Desc as Description,HOSP_DateFrom as DateFrom,HOSP_DateTo as DateTo
	FROM SQLUser.CT_Hospital
}

/// Desc:	初始化元数据--院区表
/// Debug:	d ##Class(DHCEPRFS.Tool.InitMetaBase).InitMetaBaseHospital()
ClassMethod InitMetaBaseHospital()
{
	
	s obj = ##Class(%ResultSet).%New("DHCEPRFS.Tool.InitMetaBase:SQLHospital")
	s sc = obj.Execute()
	
	s order =0

	while (obj.Next())
	{
		s name = obj.Data("Description")
		s dateFrom = obj.Data("DateFrom")
		s dateTo = obj.Data("DateTo")

		s hospitalAreaID = 	obj.Data("HospitalAreaID")

		s date = $p($h,",",1)
		s time = $p($h,",",2)
		if ($l(name,"-")>1)
		{
			s name=$p(name,"-",2)
		}
		s aliasName = ##Class(DHCEPRFS.Util.StringHelper).GetCNCODE(name,3,"")
		s aliasNameInitial = ##Class(DHCEPRFS.Util.StringHelper).GetCNCODE(name,4,"")
		s order=order +1
		s sc = $$InitOneHospitalArea(hospitalAreaID,name,name,aliasName,aliasNameInitial,dateFrom,dateTo,date,time,date,time,"DHC",order,"Y")
	}
InitOneHospitalArea(argRowID, argName, argDesc,argAliasName, argAliasNameInitial,argDateActiveFrom,argDateActiveTo,argCreateDate,argCreateTime,argLastModifyDate,argLastModifyTime,argSource,argOrder,argIsActive)
	s rowid = ""
	&sql(select ID into :rowid from DHCEPRFS_META_B.HospitalArea
		where HospitalAreaID = :argRowID AND Name = :argName)
	
	w !,rowid
	if (rowid = "")
	{
		&sql(insert into DHCEPRFS_META_B.HospitalArea (HospitalAreaID,Name,Description,AliasName,AliasNameInitial,DateActiveFrom,DateActiveTo,CreateDate,CreateTime,LastModifyDate,LastModifyTime,Source,OrderNum,IsActive) 
			values (:argRowID,:argName,:argDesc,:argAliasName,:argAliasNameInitial,:argDateActiveFrom,:argDateActiveTo,:argCreateDate,:argCreateTime,:argLastModifyDate,:argLastModifyTime,:argSource, :argOrder,:argIsActive))
	}
	else
	{
		&sql(update DHCEPRFS_META_B.HospitalArea set HospitalAreaID=:argRowID,Name=:argName,Description=:argDesc,AliasName=:argAliasName,AliasNameInitial=:argAliasNameInitial,DateActiveFrom=:argDateActiveFrom,DateActiveTo=:argDateActiveTo,LastModifyDate=:argLastModifyDate,LastModifyTime=:argLastModifyTime,Source=:argSource,OrderNum=:argOrder,IsActive=:argIsActive
			where id = :rowid)
	}

	q "1"
}

}
