Class DHCEPRFS.SelfPrint.Tool.InitMeta Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", ProcedureBlock ]
{

/// Debug: d ##Class(DHCEPRFS.SelfPrint.Tool.InitMeta).InitSelfPrintScheme("72")
ClassMethod InitSelfPrintScheme(APrintSchemeID As %String)
{
	s sc = $$UpdateSysOption("SelfPrintSchemeID", "72", "自助机打印方案ID", "base")
	
UpdateSysOption(argOptionName,argOptionValue,argOptionDesc,argOptionType)
    s rowid = ""
	&sql(select ID into :rowid from DHCEPRFS_META.SysOption
		where OptionName = :argOptionName and OptionValue = :argOptionValue)
	w !,rowid
	if (rowid = "")
	{
		&sql(insert into DHCEPRFS_META.SysOption (OptionName, OptionValue, OptionDesc, OptionType) 
			values (:argOptionName, :argOptionValue, :argOptionDesc,:argOptionType))
	}
	
	q "1"
}

/// Debug: d ##Class(DHCEPRFS.SelfPrint.Tool.InitMeta).InitSelfPrintUser()
ClassMethod InitSelfPrintUser()
{
	d ..InitOneSelfPrintUser("DYEY-DHCEPRFS-01-01-01","自助机打印用户1","1")
}

/// Debug: d ##Class(DHCEPRFS.SelfPrint.Tool.InitMeta).InitSelfPrintUser()
ClassMethod InitOneSelfPrintUser(AUserCode As %String, AUserName As %String, AUserPassword As %String)
{
	s userEntity = ##class(DHCEPRFS.Entity.EQueryUser).%New()
	s userEntity.UserCode = AUserCode
	s userEntity.UserName = AUserName
	s userEntity.PassWord = AUserPassword
	s userEntity.IsAvailable = "1"
	s userEntity.StartDate = $zd($p($h,",",1),3)
	s userEntity.EndDate = $zd($p($h,",",1) + 400000,3)
	s userEntity.Type = "TEMP"
	s userEntity.SSUserID = ""
	
	s rowid = ""
	&sql(select ID into :rowid from DHCEPRFS_META.QueryRole where RoleName = "selfprint")
	if (rowid = "")
	{
		s obj = ##class(DHCEPRFS.META.QueryRole).%New()
		s obj.ParentID = ""
		s obj.RoleDesc = "自助机打印"
		s obj.RoleName = "selfprint"
		d obj.%Save()
		s rowid = obj.%Id()
	}
	q ##Class(DHCEPRFS.BL.BLQueryUser).AddUser(userEntity,rowid)
}

/// Debug: d ##Class(DHCEPRFS.SelfPrint.Tool.InitMeta).InitPrintPurpose()
ClassMethod InitPrintPurpose()
{
	d ..InitOnePrintPurpose("SP001.001.001","投保","1")	
	d ..InitOnePrintPurpose("SP001.001.002","医保报销","2")	
	d ..InitOnePrintPurpose("SP001.001.003","办理病退","3")	
	d ..InitOnePrintPurpose("SP001.001.004","外院就诊","4")	
	d ..InitOnePrintPurpose("SP001.001.005","自己保存","5")	
	d ..InitOnePrintPurpose("SP001.001.006","农村医保","6")	
	d ..InitOnePrintPurpose("SP001.001.007","保险理赔","7")	
	d ..InitOnePrintPurpose("SP001.001.008","评残","8")
}

/// Debug: d ##Class(DHCEPRFS.SelfPrint.Tool.InitMeta).InitOnePrintPurpose()
ClassMethod InitOnePrintPurpose(ACode As %String, AName As %String, AOrder As %String)
{
	
	s date = $p($h,",",1)
	s time = $p($h,",",2)

	s aliasName = ##Class(DHCEPRFS.Util.StringHelper).GetCNCODE(AName,3,"")
	s aliasNameInitial = ##Class(DHCEPRFS.Util.StringHelper).GetCNCODE(AName,4,"")

	s rowid = ""
	&sql(select ID into :rowid from DHCEPRFS_SelfPrint_META.PrintPurposes where Code = :ACode AND Name = :AName)
	
	if (rowid = "")
	{
		s obj = ##class(DHCEPRFS.SelfPrint.META.PrintPurposes).%New()
		s obj.Code = ACode
		s obj.Name = AName
		s obj.Description = AName
		s obj.OrderNum = AOrder
		s obj.AliasName = aliasName
		s obj.AliasNameInitial = aliasNameInitial
		s obj.LastModifyDate = date
		s obj.LastModifyTime = time
		
		s obj.CreateDate = date
		s obj.CreateTime = time
		s obj.IsActive = "Y"
		s obj.Source = "DHC"
		s sc = obj.%Save()
		w !,sc_" create "_ACode_" "_AName_" "_AOrder_" ok!"
	}
	else
	{
		s obj = ##class(DHCEPRFS.SelfPrint.META.PrintPurposes).%OpenId(rowid)
		s obj.Code = ACode
		s obj.Name = AName
		s obj.Description = AName
		s obj.OrderNum = AOrder
		s obj.AliasName = aliasName
		s obj.AliasNameInitial = aliasNameInitial
		s obj.LastModifyDate = date
		s obj.LastModifyTime = time
		s sc = obj.%Save()
		w !,sc_" update "_ACode_" "_AName_" "_AOrder_" ok!"
	}

	q "1"
}

}
