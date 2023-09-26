/// Desc: 打印方案
/// Creator:Candyxu
/// CreateDate:2012-05-04
Class DHCEPRFS.BL.BLPrintScheme Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", ProcedureBlock ]
{

/// Desc:	通过SchemeType获取SchemeID
/// w ##class(DHCEPRFS.BL.BLPrintScheme).GetSchemeIDBySchemeType("CREATETOP")
ClassMethod GetSchemeIDBySchemeType(ASchemeType As %String) As %String
{
	if ($e(ASchemeType,1,2) = "@@")	//如果是表达式则直接返回
	{
		q ASchemeType
	}
	
	s schemeID = ""
	if (ASchemeType = ##Class(DHCEPRFS.Const.SchemeType).CreateLIS())
	{
		s schemeID = ##Class(DHCEPRFS.Srv.SrvSysOption).GetValueByName(ASchemeType)
	}
	elseif (ASchemeType = ##Class(DHCEPRFS.Const.SchemeType).CreateRIS())
	{
		s schemeID = ##Class(DHCEPRFS.Srv.SrvSysOption).GetValueByName(ASchemeType)
	}
	elseif (ASchemeType = ##Class(DHCEPRFS.Const.SchemeType).CreatePIS())
	{
		s schemeID = ##Class(DHCEPRFS.Srv.SrvSysOption).GetValueByName(ASchemeType)
	}
	elseif (ASchemeType = ##Class(DHCEPRFS.Const.SchemeType).CreateFP())
	{
		s schemeID = ##Class(DHCEPRFS.Srv.SrvSysOption).GetValueByName(ASchemeType)
	}
	elseif (ASchemeType = ##Class(DHCEPRFS.Const.SchemeType).CreateTemperature())
	{
		s schemeID = ##Class(DHCEPRFS.Srv.SrvSysOption).GetValueByName(ASchemeType)
	}
	elseif (ASchemeType = ##Class(DHCEPRFS.Const.SchemeType).CreateLongOrder())
	{
		s schemeID = ##Class(DHCEPRFS.Srv.SrvSysOption).GetValueByName(ASchemeType)
	}
	elseif (ASchemeType = ##Class(DHCEPRFS.Const.SchemeType).CreateTempOrder())
	{
		s schemeID = ##Class(DHCEPRFS.Srv.SrvSysOption).GetValueByName(ASchemeType)
	}
	elseif (ASchemeType = ##Class(DHCEPRFS.Const.SchemeType).CreateNurse())
	{
		s schemeID = ##Class(DHCEPRFS.Srv.SrvSysOption).GetValueByName(ASchemeType)
	}
	elseif (ASchemeType = ##Class(DHCEPRFS.Const.SchemeType).CreateNursePF())
	{
		s schemeID = ##Class(DHCEPRFS.Srv.SrvSysOption).GetValueByName(ASchemeType)
	}
	elseif (ASchemeType = ##Class(DHCEPRFS.Const.SchemeType).CreateAN())
	{
		s schemeID = ##Class(DHCEPRFS.Srv.SrvSysOption).GetValueByName(ASchemeType)
	}
	elseif (ASchemeType = ##Class(DHCEPRFS.Const.SchemeType).CreateICU())
	{
		s schemeID = ##Class(DHCEPRFS.Srv.SrvSysOption).GetValueByName(ASchemeType)
	}
	elseif (ASchemeType = ##Class(DHCEPRFS.Const.SchemeType).CreateTop())
	{
		s schemeID = ##Class(DHCEPRFS.Srv.SrvSysOption).GetValueByName(ASchemeType)
	}
	elseif (ASchemeType = ##Class(DHCEPRFS.Const.SchemeType).CreatePrivacy01())
	{
		s schemeID = ##Class(DHCEPRFS.Srv.SrvSysOption).GetValueByName(ASchemeType)
	}
	elseif (ASchemeType = ##Class(DHCEPRFS.Const.SchemeType).CreateTemp01())
	{
		s schemeID = ##Class(DHCEPRFS.Srv.SrvSysOption).GetValueByName(ASchemeType)
	}
	elseif (ASchemeType = ##Class(DHCEPRFS.Const.SchemeType).CreateTemp02())
	{
		s schemeID = ##Class(DHCEPRFS.Srv.SrvSysOption).GetValueByName(ASchemeType)
	}
	elseif (ASchemeType = ##Class(DHCEPRFS.Const.SchemeType).CreateOPBillDailyHZ())
	{
		s schemeID = ##Class(DHCEPRFS.Srv.SrvSysOption).GetValueByName(ASchemeType)
	}
	elseif (ASchemeType = ##Class(DHCEPRFS.Const.SchemeType).CreateOPBillDaily())
	{
		s schemeID = ##Class(DHCEPRFS.Srv.SrvSysOption).GetValueByName(ASchemeType)
	}
	elseif (ASchemeType = ##Class(DHCEPRFS.Const.SchemeType).CreateIPBillDailyHZ())
	{
		s schemeID = ##Class(DHCEPRFS.Srv.SrvSysOption).GetValueByName(ASchemeType)
	}
	elseif (ASchemeType = ##Class(DHCEPRFS.Const.SchemeType).CreateIPBillDaily())
	{
		s schemeID = ##Class(DHCEPRFS.Srv.SrvSysOption).GetValueByName(ASchemeType)
	}
	elseif (ASchemeType = ##Class(DHCEPRFS.Const.SchemeType).CreateDHCStkMonFD())
	{
		s schemeID = ##Class(DHCEPRFS.Srv.SrvSysOption).GetValueByName(ASchemeType)
	}
	elseif (ASchemeType = ##Class(DHCEPRFS.Const.SchemeType).CreateDHCEQDEPRE())
	{
		s schemeID = ##Class(DHCEPRFS.Srv.SrvSysOption).GetValueByName(ASchemeType)
	}
	elseif (ASchemeType = ##Class(DHCEPRFS.Const.SchemeType).Create3rdPartyLIS())
	{
		s schemeID = ##Class(DHCEPRFS.Srv.SrvSysOption).GetValueByName(ASchemeType)
	}
	elseif (ASchemeType = ##Class(DHCEPRFS.Const.SchemeType).CreateFPTOP())
	{
		s schemeID = ##Class(DHCEPRFS.Srv.SrvSysOption).GetValueByName(ASchemeType)
	}
	else
	{
		s schemeID = ..GetSchemeIDByDefault("CREATE")
	}
	q schemeID
}

/// Desc:	修改方案名称
/// Creator:houjian
/// CreateDate:2013-09-28
/// do ##Class(DHCEPRFS.BL.BLPrintScheme).SetSchemeName("37","测试模板8","","159","SCANARRANGE")
ClassMethod SetSchemeName(ASchemeID As %String, ASchemeName As %String, ASchemeDesc As %String, AModifyUserID As %String, ASchemeType As %String = "") As %String
{
	s result = "0"
	s obj = ##Class(DHCEPRFS.META.PrintScheme).%OpenId(ASchemeID)
	q:(obj = "") result
	
	s obj.SchemeName = ASchemeName
	s obj.SchemeDesc = ASchemeDesc
	s obj.ModifyUserID = AModifyUserID
	s obj.ModifyDate = $p($h,",",1)
	s obj.ModifyTime = $p($h,",",2)
	
	s preSchemeType = obj.SchemeType
	if (ASchemeType '= "")
	{
		s obj.SchemeType = ASchemeType
	}
	
	if (ASchemeType = "SCANARRANGE")||(ASchemeType = "PHOTOARRANGE")
	{
		s itemRowID = ""
		for {
			s itemRowID = $o(^DHCEPRFS.META.MRItemI("IdxType"," PS"," 0",itemRowID))
			q:(itemRowID = "")
			s objItem = ##class(DHCEPRFS.META.MRItem).%OpenId(itemRowID)
			s mrSubCategoryID = objItem.MRSubCategoryID
			s mrItemID = itemRowID
			s objCategoruID = ##class(DHCEPRFS.META.MRSubCategory).%OpenId(mrSubCategoryID)
			s mrCategoryID = objCategoruID.MRCategoryID
		}
		
		if (obj.SchemeItems = "")||(obj.SchemeItems = $c(0))
		{
			s obj.SchemeItems = mrCategoryID_"#"_mrSubCategoryID_"#"_mrItemID
		}
		else
		{
			s flag = 0
			for i = 1:1:$l(obj.SchemeItems,"^")
			{
				//b "s"
				s schemeItem = $p(obj.SchemeItems,"^",i)
				if ($p(schemeItem,"#",3) = mrItemID)
				{
					s flag = 1
					q
				}
			}
			if (flag = 0)
			{
				s obj.SchemeItems = obj.SchemeItems_"^"_mrCategoryID_"#"_mrSubCategoryID_"#"_mrItemID
			}
		}
	}
	
	s status = obj.%Save()
	if ($$$ISOK(status))
	{
		s result = obj.%Id()
		if (ASchemeType = "SCANARRANGE") {
			s flagFunc = ..AddScanScheme(result)
		}
		elseif (ASchemeType = "PHOTOARRANGE") {
			s flagFunc = ..AddPhotoScheme(result)
		}
		else {
			if (preSchemeType = "SCANARRANGE") {
				s flagFunc = ..AddScanScheme(result)
			}
			elseif (preSchemeType = "PHOTOARRANGE") {
				s flagFunc = ..AddPhotoScheme(result)
			}
		}
	}
	q result
}

/// Desc:增加或修改方案
/// Creator:Candyxu
/// CreateDate:2013-05-04
ClassMethod SetScheme(ParaScheme As DHCEPRFS.Entity.EPrintScheme) As %String
{
	s result = "0"
	s rowId = ParaScheme.ID
	if ((rowId '= "") && ($d(^DHCEPRFS.META.PrintSchemeD(rowId))))
	{
		s obj = ##Class(DHCEPRFS.META.PrintScheme).%OpenId(rowId)
	}
	else
	{
		s obj = ##Class(DHCEPRFS.META.PrintScheme).%New()
		s obj.CreateDate = $p($h,",",1)
		s obj.CreateTime = $p($h,",",2)
		s obj.CreateUserID = ParaScheme.CreateUserID
		s obj.IsDefault = "N"
		//s obj.IsCreate = "N"
		s squence = $o(^DHCEPRFS.META.PrintSchemeD(""),-1)
		s:(squence = "") squence = 0
		s obj.SchemeOrder = squence +1
	}
	s obj.SchemeName = ParaScheme.SchemeName
	s obj.SchemeDesc = ParaScheme.SchemeDesc
	s obj.SchemeItems = ParaScheme.SchemeItems
	s obj.ModifyUserID = ParaScheme.ModifyUserID
	s obj.SchemeType = ParaScheme.SchemeType
	s itemRowID = ""
	for {
		s itemRowID = $o(^DHCEPRFS.META.MRItemI("IdxType"," PS"," 0",itemRowID))
		q:(itemRowID = "")
		s objItem = ##class(DHCEPRFS.META.MRItem).%OpenId(itemRowID)
		s mrSubCategoryID = objItem.MRSubCategoryID
		s mrItemID = itemRowID
		s objCategoruID = ##class(DHCEPRFS.META.MRSubCategory).%OpenId(mrSubCategoryID)
		s mrCategoryID = objCategoruID.MRCategoryID
	}
	if (ParaScheme.SchemeType = "SCANARRANGE")||(ParaScheme.SchemeType = "PHOTOARRANGE")
	{
		if (obj.SchemeItems = "")||(obj.SchemeItems = $c(0))
		{
			s obj.SchemeItems = mrCategoryID_"#"_mrSubCategoryID_"#"_mrItemID
		}
		else
		{
			s flag = 0
			for i = 1:1:$l(obj.SchemeItems,"^")
			{
				//b "s"
				s schemeItem = $p(obj.SchemeItems,"^",i)
				if ($p(schemeItem,"#",3) = mrItemID)
				{
					s flag = 1
					q
				}
			}
			if (flag = 0)
			{
				s obj.SchemeItems = obj.SchemeItems_"^"_mrCategoryID_"#"_mrSubCategoryID_"#"_mrItemID
			}
		}
	}
	s obj.ModifyDate = $p($h,",",1)
	s obj.ModifyTime = $p($h,",",2)
	s obj.IsAvailable = "Y"
	
	s status = obj.%Save()
	if ($$$ISOK(status))
	{
		s result = obj.%Id()
		if (ParaScheme.SchemeType = "SCANARRANGE") {
			s flagFunc = ..AddScanScheme(result)
		}
		elseif (ParaScheme.SchemeType = "PHOTOARRANGE") {
			s flagFunc = ..AddPhotoScheme(result)
		}
	}
	q result
}

/*
/// Desc:	删除方案
/// Debug: w ##class(DHCEPRFS.BL.BLPrintScheme).DeleScheme(16)
ClassMethod DeleScheme(ASchemeID As %String) As %String
{
	q:(ASchemeID="")||(ASchemeID=$c(0)) "0"
	
	s status = ##Class(DHCEPRFS.META.PrintScheme).%DeleteId(ASchemeID)
	if ($$$ISOK(status))
	{
		q "1"
	}
	else
	{
		q "0"
	}
}*/
/// Desc:	作废方案
/// Debug: w ##class(DHCEPRFS.BL.BLPrintScheme).DeleteScheme(16)
ClassMethod DeleteScheme(ASchemeID As %String) As %String
{
	q:(ASchemeID="")||(ASchemeID=$c(0)) "0"
	
	s obj = ##Class(DHCEPRFS.META.PrintScheme).%OpenId(ASchemeID)
	s schemeType = obj.SchemeType
	s obj.IsAvailable = "N"
	s status = obj.%Save()
	if ($$$ISOK(status))
	{
		if (schemeType = "SCANARRANGE") {
			s flagFunc = ..AddScanScheme(ASchemeID)
		}
		elseif (schemeType = "PHOTOARRANGE") {
			s flagFunc = ..AddPhotoScheme(ASchemeID)
		}
		q "1"
	}
	else
	{
		q "0"
	}
}

/// Creator:Candy
/// CreateDate:2013-05-06
/// Desc:增加方案项目
ClassMethod SetSchemeItems(rowId As %String, Items As %String, CheckedItems As %String = "")
{
	s result = "0"
	if ($d(^DHCEPRFS.META.PrintSchemeD(rowId)))
	{
		s obj = ##Class(DHCEPRFS.META.PrintScheme).%OpenId(rowId)
		s obj.SchemeItems = Items
		s obj.CheckItems = CheckedItems
		s statue = obj.%Save()
		s:($$$ISOK(statue)) result = "1"
	}
	q result
}

/// Desc:设为默认打印方案
/// Creator:Candyxu
/// CreateDate:2013-05-04
ClassMethod SetfaultScheme(rowId As %String) As %String
{
	s result = "0"
	s result = ..SetDefault(rowId,"PRINT")
	q result
}

/// Desc:设为默认生成方案
ClassMethod SetDefaultCreateScheme(rowId As %String) As %String
{
	s result = "0"
	s result = ..SetDefault(rowId,"CREATE")
	q result
}

/// Desc:设为默认生成方案
/// Debug: w ##class(DHCEPRFS.BL.BLPrintScheme).SetDefault("2","CREATE")
ClassMethod SetDefault(APrintSchemeID As %String, ASchemeType As %String) As %String
{
	s rowID= ""
	TSTART
	s $zt = "OnSetDefaultErrorHandler"
	
	s rowID = $o(^DHCEPRFS.META.PrintSchemeI("IdxDefaultType"," "_ASchemeType," Y",rowID))
	if (rowID '= "")
	{
		s tmpObj = ##Class(DHCEPRFS.META.PrintScheme).%OpenId(rowID)
		q:(tmpObj = "") "0"
		s tmpObj.IsDefault = "N"
		s typestatus = tmpObj.%Save()
		d tmpObj.%Close()
		if ('$$$ISOK(typestatus))
		{
			TROLLBACK
			q "0"
		}
	}
		
	s obj = ##Class(DHCEPRFS.META.PrintScheme).%OpenId(APrintSchemeID)
	if (obj = "")
	{
		TROLLBACK
		q "0"
	}
	s obj.IsDefault = "Y"
	s status = obj.%Save()
	d obj.%Close()
	if ('$$$ISOK(status))
	{
		TROLLBACK
		q "0"
	}	
	TCOMMIT
	q "1"
OnSetDefaultErrorHandler
	TROLLBACK
	q "0"
}

/// Desc:设为非默认生成方案
/// Debug: w ##class(DHCEPRFS.BL.BLPrintScheme).SetNonDefault("2")
ClassMethod SetNonDefault(APrintSchemeID As %String) As %String
{
	s result = "0"
	s rowID= ""
	
	s obj = ##Class(DHCEPRFS.META.PrintScheme).%OpenId(APrintSchemeID)
	q:(obj = "") result
	
	s obj.IsDefault = "N"
	s status = obj.%Save()
	s:($$$ISOK(status)) result =1
	d obj.%Close()
	q result
}

/// Desc:获得方案列表
/// Creator:Candyxu 
/// CreateDate:2013-05-04
/// Debuger:do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLPrintScheme","GetAllSchemeList","")
Query GetAllSchemeList(ASchemeType As %String = "") As %Query(ROWSPEC = "ID:%String,SchemeName:%String,SchemeDesc:%String,SchemeItems:%String,IsDefault:%String,CreateUser:%String,ModifyUser:%String,CreateDate:%String,ModifyDate:%String,SchemeOrder:%String,SchemeType:%String,SchemeTypeDesc:%String,IsAvailable:%String")
{
}

ClassMethod GetAllSchemeListExecute(ByRef qHandle As %Binary, ASchemeType As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	s order = ""
 	for {
	 	s order = $o(^DHCEPRFS.META.PrintSchemeI("IdxSchemeOrder",order))
	 	q:(order = "")
		s rowId = $o(^DHCEPRFS.META.PrintSchemeI("IdxSchemeOrder",order,""))
		continue:(rowId = "")
		s obj = ##Class(DHCEPRFS.META.PrintScheme).%OpenId(rowId)
		continue:(obj = "")
		
		s SchemeName = obj.SchemeName
		s SchemeDesc = obj.SchemeDesc
		s SchemeItems = obj.SchemeItems
		s IsDefault = obj.IsDefault
		//s IsCreate = obj.IsCreate
		s CreateDate = $zd(obj.CreateDate,3)
		s ModifyDate = $zd(obj.ModifyDate,3)
		
		s CreateID = obj.CreateUserID
		s ModifyID = obj.ModifyUserID
		if ($p(CreateID,"^",1) = "TEMP")
    	{
			s objUser = ##class(DHCEPRFS.META.QueryUser).%OpenId($p(CreateID,"^",2))
			s CreateUser = objUser.UserName    
		}
		else
		{
    		s CreateUser = ##Class(DHCEPRFS.BL.HISInfo.BLHISInfo).GetUserName(CreateID)
		}
		
		if ($p(ModifyID,"^",1) = "TEMP")
    	{
			s objUser = ##class(DHCEPRFS.META.QueryUser).%OpenId($p(ModifyID,"^",2))
			s ModifyUser = objUser.UserName    
		}
		else
		{
    		s ModifyUser = ##Class(DHCEPRFS.BL.HISInfo.BLHISInfo).GetUserName(ModifyID)
		}
		
		s SchemeOrder = obj.SchemeOrder	
		s SchemeType = obj.SchemeType
		s:(SchemeType=$c(0)) SchemeType = ""
		if (ASchemeType '= "")
		{
			if (ASchemeType '= "ALL")
			{
				continue:(ASchemeType'=SchemeType)	
			}
		}
		s SchemeTypeDesc = ""
		if (SchemeType = "CREATE")
		{
			s SchemeTypeDesc = "生成方案"
		}
		elseif (SchemeType = "PRINT")
		{
			s SchemeTypeDesc = "打印方案"
		}
		elseif (SchemeType = "VIEW")
		{
			s SchemeTypeDesc = "浏览方案"
		}
		elseif (SchemeType = "QUEUE")
		{
			s SchemeTypeDesc = "队列查看方案"
		}
		elseif (SchemeType = "SCANARRANGE")
		{
			s SchemeTypeDesc = "扫描分类"
		}
		elseif (SchemeType = "IMPORT")
		{
			s SchemeTypeDesc = "导出方案"
		}
		elseif (SchemeType = "PHOTOARRANGE")
		{
			s SchemeTypeDesc = "高拍分类"
		}
		elseif (SchemeType = "SEAL")
		{
			s SchemeTypeDesc = "封存方案"
		}
		
		s IsAvailable = obj.IsAvailable
		continue:(IsAvailable = "N")
			
		s data = $lb(rowId,SchemeName,SchemeDesc,SchemeItems,IsDefault,CreateUser,ModifyUser,CreateDate,ModifyDate,SchemeOrder,SchemeType,SchemeTypeDesc,IsAvailable)
	    s ^CacheTemp(repid,ind)=data
	    s ind=ind+1
	}
	Quit $$$OK
}

ClassMethod GetAllSchemeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllSchemeListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

ClassMethod GetAllSchemeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllSchemeListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod IsChecked(AItem As %String, ACheckedItems As %String) As %String
{
	q:((ACheckedItems = "") || (ACheckedItems = $c(0))) "false"
	s check = "false"
	for index=1:1:$l(ACheckedItems,"^")
	{
		s oneCheckedItem = $p(ACheckedItems,"^",index)
		if (oneCheckedItem = AItem)
		{
			s check = "true"
			q	
		}
	}
	q check
}

/// Creator:Candyxu
/// CreateDate:2013-05-06
/// Desc:获得方案项
Query GetSchemeByID(ASchemeID As %String) As %Query(ROWSPEC = "MRItemID:%String,MRSubCateogryID:%String,MRCateCategoryID:%String,Description:%String,SubCgDesc:%String,CgDesc:%String, Checked:%String")
{
}

ClassMethod GetSchemeByIDExecute(ByRef qHandle As %Binary, ASchemeID As %String) As %Status
{
    s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	q:(ASchemeID = "") $$$OK
 	s obj = ##Class(DHCEPRFS.META.PrintScheme).%OpenId(ASchemeID)
 	q:(obj = "") $$$OK
 	s Items = obj.SchemeItems
 	s CheckedItems = obj.CheckItems
 	d obj.%Close()
 	q:(Items = "") $$$OK 
 	s total = $l(Items,"^")
 	for i=1:1:total
 	{
	    s ItemID = $p($p(Items,"^",i),"#",3)
	    s subCategoryID =  $p($p(Items,"^",i),"#",2)
	    s CategoryID =  $p($p(Items,"^",i),"#",1)
	    s objItem = ##Class(DHCEPRFS.META.MRItem).%OpenId(ItemID)
	    Continue:(objItem = "")
	    s Desc = objItem.Description
	    d objItem.%Close()
	    
	    s objSubCategory = ##Class(DHCEPRFS.META.MRSubCategory).%OpenId(subCategoryID)
	    Continue:(objSubCategory = "")
	    s SubCategoryDesc = objSubCategory.Description
	    d objSubCategory.%Close()
	    
	    s objCategory = ##Class(DHCEPRFS.META.MRCategory).%OpenId(CategoryID)
	    Continue:(objCategory = "")
	    s CategoryDesc = objCategory.Description
	    d objCategory.%Close()
	    
	    s checked = ..IsChecked($p(Items,"^",i),CheckedItems)
	    
		s data = $lb(ItemID,subCategoryID,CategoryID,Desc,SubCategoryDesc,CategoryDesc,checked)
	    s ^CacheTemp(repid,ind)=data
	    s ind=ind+1	    	
	}
	Quit $$$OK
}

ClassMethod GetSchemeByIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSchemeByIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetSchemeByIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSchemeByIDExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

/// debug: w ##class(DHCEPRFS.BL.BLPrintScheme).GetVerItemBySchemeIDString("25","33","Y")
ClassMethod GetVerItemBySchemeIDString(ASchemeID As %String, AMRVersionID As %String, ACorrelation As %String = "N") As %String
{
	s ret = ""
	
 	s obj = ##Class(DHCEPRFS.META.PrintScheme).%OpenId(ASchemeID)
 	q:(obj = "") ""
 	s Items = obj.SchemeItems
 	d obj.%Close()
 	q:(Items = "") "" 
 	s total = $l(Items,"^")

	for i=1:1:total
	{
		s ItemID = $p($p(Items,"^",i),"#",3)
		s MRVerItemID = $O(^DHCEPRFS.INST.MRVerItemI("IdxMain", " "_AMRVersionID, " "_ItemID, ""))
		
		//对这个就诊的项目做筛选，如果此项目作废就跳过，deleteFlag="Y"--作废
		s deleteFlag =""
		if (MRVerItemID '= "")
		{
			s objMRVerItem = ##class(DHCEPRFS.INST.MRVerItem).%OpenId(MRVerItemID)
			s deleteFlag = objMRVerItem.DeleteFlag
		}
		continue:(deleteFlag = "Y")
		
		//处理有VerItem但无VerItemDetail的项目，例如平台生成的项目
		if (MRVerItemID '= "")  //MRVerItemID 不为空 并且 没有 MRVerItemDetail
		{
			s detailNum = ""
            s detailNum = $o(^DHCEPRFS.INST.MRVerItemDetailI("IdxMain",MRVerItemID,detailNum),-1)
            continue:(detailNum = "")
		}
		
		if (ACorrelation = "N")
		{
			continue:(MRVerItemID = "")
		}
		else
		{
			if (MRVerItemID = "")
			{
				//此项目不存在
				//判断此项目是否需替换，若需替换则替换为相应的项目	
				s MRVerItemID = ##class(DHCEPRFS.BL.BLPrintItemCorrelation).ReplaceCorrelation(AMRVersionID,ItemID)
				//要替换项目也没有
				continue:(MRVerItemID = "")
			}
		}
		
		if (ret = "")
		{
			s ret = MRVerItemID	
		}
		else
		{
			s ret = ret_"^"_MRVerItemID	
		}

	}
	s retDone = ""
	if (ACorrelation = "N")
	{
		s retDone = ret
	}
	else
	{
		//查重，从后往前
		for i=$l(ret,"^"):-1:1
		{
			s current = $p(ret,"^",i)
			s flag = "N"
			//检查此项目前所有项目是否有一样的
			for j=1:1:(i-1)
			{
				s before = $p(ret,"^",j)
				if (current = before)
				{
					s flag = "Y"
					q	
				}
			}
			if (flag = "N")
			{
				//没有重复的
				s retDone = current_"^"_retDone	
			}	
		}
		//去除第一个^
		if ($e(retDone,1) = "^")
		{
			s retDone = $e(retDone,2,$l(retDone))		
		}	
	}
	q retDone
}

/// Desc:根据MRVersionID获取应有的项目
/// Creator:Liushuang 
/// Createdate:2016-12-01
/// Debug: w ##Class(DHCEPRFS.BL.BLPrintScheme).GetCategoryByAMRVersionID("32")
ClassMethod GetCategoryByAMRVersionID(AMRVersionID As %String) As %String
{
	s Items = ""
	s mrItemID = ""
	for {
		s mrItemID = $O(^DHCEPRFS.INST.MRVerItemI("IdxMain", " "_AMRVersionID, mrItemID))
		q:(mrItemID = "")
		
		s mrVerItemID = $O(^DHCEPRFS.INST.MRVerItemI("IdxMain", " "_AMRVersionID, mrItemID, ""))
		continue:(mrVerItemID = "")
		
		s objMRVerItem = ##Class(DHCEPRFS.INST.MRVerItem).%OpenId(mrVerItemID)
		continue:(objMRVerItem = "")		
		s MRItemID = objMRVerItem.MRItemID
		if (Items = "")
		{
			s Items = MRItemID	
		}
		else 
		{
			s Items = Items_"^"_MRItemID
		}
	}
	q Items
}

/// Desc:根据方案条目内容获得查看内容
/// Debug: w ##Class(DHCEPRFS.BL.BLPrintScheme).GetVerItemBySchemeItemsString("1#1#1^1#1#2",0)
ClassMethod GetVerItemBySchemeItemsString(ASchemeItems As %String, AMRVersionID As %String) As %String
{
	s mrItemID = ""
	s allInfo = ""
	s ret = ""
	for {
		s mrItemID = $O(^DHCEPRFS.INST.MRVerItemI("IdxMain", " "_AMRVersionID, mrItemID))
		q:(mrItemID = "")
		
		s mrVerItemID = $O(^DHCEPRFS.INST.MRVerItemI("IdxMain", " "_AMRVersionID, mrItemID, ""))
		continue:(mrVerItemID = "")
		
		//对这个就诊的项目做筛选，如果此项目作废就跳过，deleteFlag="Y"--作废
		s deleteFlag =""
		if (mrVerItemID '= "")
		{
			s objMRVerItem = ##class(DHCEPRFS.INST.MRVerItem).%OpenId(mrVerItemID)
			s deleteFlag = objMRVerItem.DeleteFlag
		}
		continue:(deleteFlag = "Y")
		
		s objMRVerItem = ##Class(DHCEPRFS.INST.MRVerItem).%OpenId(mrVerItemID)
		continue:(objMRVerItem = "")
		
		s MRVersionID = AMRVersionID
		s MRVerItemID = mrVerItemID
		s MRItemID = objMRVerItem.MRItemID
		s TotCount = objMRVerItem.TotCount
		if (allInfo = "")
		{
			s allInfo = MRVersionID_"|"_MRVerItemID_"|"_MRItemID_"|"_TotCount	
		}
		else 
		{
			s allInfo = allInfo_"^"_MRVersionID_"|"_MRVerItemID_"|"_MRItemID_"|"_TotCount
		}
	}
 	s total = $l(ASchemeItems,"^")
	for i=1:1:total
	{
		s ItemID = $p($p(ASchemeItems,"^",i),"#",3)
		s subCategoryID =  $p($p(ASchemeItems,"^",i),"#",2)
		s CategoryID =  $p($p(ASchemeItems,"^",i),"#",1)
		
		for j=1:1:$l(allInfo,"^")
		{
			s singleOne = $p(allInfo,"^",j)
			s AMRVerItemID = $p(singleOne,"|",2)
			s AMRItemID = $p(singleOne,"|",3)

			if (AMRItemID = ItemID)	
			{
				if (ret = "")
				{
					s ret = AMRVerItemID	
				}
				else
				{
					s ret = ret_"^"_AMRVerItemID	
				}
			}
		}
	}
	
	s SequenceByViewScheme = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("SequenceByViewScheme")

	if (SequenceByViewScheme = "Y")
	{
		///取浏览方案的项目，并且把此MRVersionID拥有的MRVerItemID按照方案ItemID的顺序加入队列，存在一种可能，有的MRVerItemID对应的ItemID不在浏览方案中，所以没有加入队列
		s schemeID = ..GetSchemeIDByDefault("VIEW")
		s listRet = ##class(%ListOfDataTypes).%New()
		s obj = ##class(DHCEPRFS.META.PrintScheme).%OpenId(schemeID)
		s Items = obj.SchemeItems
		s count = $l(Items,"^")
		for i =1:1:count
		{
			s ItemID = $p($p(Items,"^",i),"#",3)
			for j=1:1:$l(allInfo,"^")
			{
				s singleOne = $p(allInfo,"^",j)
				s AMRVerItemID = $p(singleOne,"|",2)
				s AMRItemID = $p(singleOne,"|",3)

				if (AMRItemID = ItemID)	
				{
					d listRet.Insert(AMRVerItemID)
				}
			}
		}
		
		///按照队列顺序重新对要输出的MRVerItemID排序，存在要输出的MRVerItemID不在队列中
		s realRet = ""
		s key = ""
		for {
			s key = listRet.Next(key)
			q:(key = "")
			s oneVerItemID = listRet.GetAt(key)
			
			for k =1:1:$l(ret,"^")
			{
				if (oneVerItemID = $p(ret,"^",k))
				{
					if (realRet = "")
					{
						s realRet = oneVerItemID
					}
					else
					{
						s realRet = realRet_"^"_oneVerItemID
					}
				}
			}
		}
		
		///对不在队列的，并且要输出的MRVerItemID进行补充
		for g = 1:1:$l(ret,"^")
		{
			s remainVerItemID = $p(ret,"^",g)
			if (listRet.Find(remainVerItemID) = "")
			{
				if (realRet = "")
				{
					s realRet = remainVerItemID
				}
				else
				{
					s realRet = realRet_"^"_remainVerItemID
				}
			}
		}
		
		s ret = realRet
	}
	
	q ret
}

/// Desc:根据方案条目内容获得查看内容
/// Debug: w ##Class(DHCEPRFS.BL.BLPrintScheme).GetVerItemBySchemeItemsString("1#1#1^1#1#2",0,"1")
ClassMethod GetVerItemBySchemeItemsStringAndSchemeID(ASchemeItems As %String, AMRVersionID As %String, ASchemeID As %String) As %String
{
	s mrItemID = ""
	s allInfo = ""
	s ret = ""
	for {
		s mrItemID = $O(^DHCEPRFS.INST.MRVerItemI("IdxMain", " "_AMRVersionID, mrItemID))
		q:(mrItemID = "")
		
		s mrVerItemID = $O(^DHCEPRFS.INST.MRVerItemI("IdxMain", " "_AMRVersionID, mrItemID, ""))
		continue:(mrVerItemID = "")
		
		//对这个就诊的项目做筛选，如果此项目作废就跳过，deleteFlag="Y"--作废
		s deleteFlag =""
		if (mrVerItemID '= "")
		{
			s objMRVerItem = ##class(DHCEPRFS.INST.MRVerItem).%OpenId(mrVerItemID)
			s deleteFlag = objMRVerItem.DeleteFlag
		}
		continue:(deleteFlag = "Y")
		
		s objMRVerItem = ##Class(DHCEPRFS.INST.MRVerItem).%OpenId(mrVerItemID)
		continue:(objMRVerItem = "")
		
		s MRVersionID = AMRVersionID
		s MRVerItemID = mrVerItemID
		s MRItemID = objMRVerItem.MRItemID
		s TotCount = objMRVerItem.TotCount
		if (allInfo = "")
		{
			s allInfo = MRVersionID_"|"_MRVerItemID_"|"_MRItemID_"|"_TotCount	
		}
		else 
		{
			s allInfo = allInfo_"^"_MRVersionID_"|"_MRVerItemID_"|"_MRItemID_"|"_TotCount
		}
	}
 	s total = $l(ASchemeItems,"^")
	for i=1:1:total
	{
		s ItemID = $p($p(ASchemeItems,"^",i),"#",3)
		s subCategoryID =  $p($p(ASchemeItems,"^",i),"#",2)
		s CategoryID =  $p($p(ASchemeItems,"^",i),"#",1)
		
		for j=1:1:$l(allInfo,"^")
		{
			s singleOne = $p(allInfo,"^",j)
			s AMRVerItemID = $p(singleOne,"|",2)
			s AMRItemID = $p(singleOne,"|",3)

			if (AMRItemID = ItemID)	
			{
				if (ret = "")
				{
					s ret = AMRVerItemID	
				}
				else
				{
					s ret = ret_"^"_AMRVerItemID	
				}
			}
		}
	}

	if ((ASchemeID'="") && (ASchemeID'=$c(0)))
	{
		///取浏览方案的项目，并且把此MRVersionID拥有的MRVerItemID按照方案ItemID的顺序加入队列，存在一种可能，有的MRVerItemID对应的ItemID不在浏览方案中，所以没有加入队列
		
		s listRet = ##class(%ListOfDataTypes).%New()
		s obj = ##class(DHCEPRFS.META.PrintScheme).%OpenId(ASchemeID)
		s Items = obj.SchemeItems
		s count = $l(Items,"^")
		for i =1:1:count
		{
			s ItemID = $p($p(Items,"^",i),"#",3)
			for j=1:1:$l(allInfo,"^")
			{
				s singleOne = $p(allInfo,"^",j)
				s AMRVerItemID = $p(singleOne,"|",2)
				s AMRItemID = $p(singleOne,"|",3)

				if (AMRItemID = ItemID)	
				{
					d listRet.Insert(AMRVerItemID)
				}
			}
		}
		
		///按照队列顺序重新对要输出的MRVerItemID排序，存在要输出的MRVerItemID不在队列中
		s realRet = ""
		s key = ""
		for {
			s key = listRet.Next(key)
			q:(key = "")
			s oneVerItemID = listRet.GetAt(key)
			
			for k =1:1:$l(ret,"^")
			{
				if (oneVerItemID = $p(ret,"^",k))
				{
					if (realRet = "")
					{
						s realRet = oneVerItemID
					}
					else
					{
						s realRet = realRet_"^"_oneVerItemID
					}
				}
			}
		}
		
		///对不在队列的，并且要输出的MRVerItemID进行补充
		for g = 1:1:$l(ret,"^")
		{
			s remainVerItemID = $p(ret,"^",g)
			if (listRet.Find(remainVerItemID) = "")
			{
				if (realRet = "")
				{
					s realRet = remainVerItemID
				}
				else
				{
					s realRet = realRet_"^"_remainVerItemID
				}
			}
		}
		
		s ret = realRet
	}
	
	q ret
}

/// Debug: w ##Class(DHCEPRFS.BL.BLPrintScheme).GetAllVerItemsByTypeString("20",a)
ClassMethod GetAllVerItemsByTypeString(AMREpisodeID As %String, AItemsString As %String) As %String
{
	s ret = ""
	s count = $l(AItemsString,"^")
	for index=1:1:count
	{
		s oneItem = $p(AItemsString,"^",index)
		s versionNum = $p(oneItem,"@",1)
		s itemID = $p(oneItem,"@",2)
		s itemType = $p(oneItem,"@",3)
		if (itemType = "FSMS")
		{
			s obj = ##class(DHCEPRFS.INST.MREpisode).%OpenId(AMREpisodeID)
			s mrMedRecordID = obj.MRMedRecordID
			s versionID = ##Class(DHCEPRFS.BL.BLMRVersion).GetMRVersionID(mrMedRecordID, versionNum,"MEDRECORD")

		}
		else
		{
			s versionID = ##Class(DHCEPRFS.BL.BLMRVersion).GetMRVersionID(AMREpisodeID, versionNum,"")
		}
			
		if (versionID '= "")
		{
			s verItemID = $o(^DHCEPRFS.INST.MRVerItemI("IdxMain"," "_versionID," "_itemID,""))
			if (verItemID '= "")
			{
				if (ret = "")
				{
					s ret = verItemID
				}	
				else
				{
					s ret = ret_"^"_verItemID	
				}
			}
		}	
	}
	q ret
}

/// Debug: w ##Class(DHCEPRFS.BL.BLPrintScheme).GetVerItemBySchemeItemsString("1#1#1^1#1#2",0)
ClassMethod GetVerItemByVersionItemsString(AMREpisodeID As %String, AItemsString As %String) As %String
{
	s ret = ""
	s count = $l(AItemsString,"^")
	for index=1:1:count
	{
		s oneItem = $p(AItemsString,"^",index)
		s versionNum = $p(oneItem,"@",1)
		s itemID = $p(oneItem,"@",2)
		s type = $p(oneItem,"@",3)
		if (type = "FSMS")
		{
			s objMREpisode = ##class(DHCEPRFS.INST.MREpisode).%OpenId(AMREpisodeID)
			s mrMedRecordID = objMREpisode.MRMedRecordID
			s versionID = $o(^DHCEPRFS.INST.MRVersionI("IdxMRMedRecord"," "_mrMedRecordID,+versionNum,""))
		}
		else
		{
			s versionID = $o(^DHCEPRFS.INST.MRVersionI("IdxMain"," "_AMREpisodeID,+versionNum,""))
		}

		if (versionID '= "")
		{
			s verItemID = $o(^DHCEPRFS.INST.MRVerItemI("IdxMain"," "_versionID," "_itemID,""))
			if (verItemID '= "")
			{
				if (ret = "")
				{
					s ret = verItemID
				}	
				else
				{
					s ret = ret_"^"_verItemID	
				}
			}
		}	
	}
	q ret
}

/// Desc:获得病人的项目符合方案内容和顺序
/// Debug: do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLPrintScheme","GetSchemeVerItemByID","3","1")
Query GetScheVerItemByID(ASchemeID As %String, AMRVersionID As %String) As %Query(ROWSPEC = "MRVerItemID:%String,MRItemName:%String,MRItemCode:%String,MRItemDescription:%String,MRItemType:%String,MRItemTypeParams:%String,MRVersionID:%String,MRItemID:%String,TotCount:%String")
{
}

ClassMethod GetScheVerItemByIDExecute(ByRef qHandle As %Binary, ASchemeID As %String, AMRVersionID As %String) As %Status
{
    s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
	q:(ASchemeID = "") $$$OK
	q:(AMRVersionID = "") $$$OK
	
	s mrItemID = ""
	s allInfo = ""
	for {
		s mrItemID = $O(^DHCEPRFS.INST.MRVerItemI("IdxMain", " "_AMRVersionID, mrItemID))
		q:(mrItemID = "")
		
		s mrVerItemID = $O(^DHCEPRFS.INST.MRVerItemI("IdxMain", " "_AMRVersionID, mrItemID, ""))
		continue:(mrVerItemID = "")
		
		s objMRVerItem = ##Class(DHCEPRFS.INST.MRVerItem).%OpenId(mrVerItemID)
		continue:(objMRVerItem = "")
		
		s MRVersionID = AMRVersionID
		s MRVerItemID = mrVerItemID
		s MRItemID = objMRVerItem.MRItemID
		s TotCount = objMRVerItem.TotCount
		if (allInfo = "")
		{
			s allInfo = MRVersionID_"|"_MRVerItemID_"|"_MRItemID_"|"_TotCount	
		}
		else 
		{
			s allInfo = allInfo_"^"_MRVersionID_"|"_MRVerItemID_"|"_MRItemID_"|"_TotCount
		}
	}
	
 	s obj = ##Class(DHCEPRFS.META.PrintScheme).%OpenId(ASchemeID)
 	q:(obj = "") $$$OK
 	s Items = obj.SchemeItems
 	d obj.%Close()
 	q:(Items = "") $$$OK 
 	s total = $l(Items,"^")

	for i=1:1:total
	{
		s ItemID = $p($p(Items,"^",i),"#",3)
		s subCategoryID =  $p($p(Items,"^",i),"#",2)
		s CategoryID =  $p($p(Items,"^",i),"#",1)
		
		for j=1:1:$l(allInfo,"^")
		{
			s singleOne = $p(allInfo,"^",j)
			s AMRVersionID = $p(singleOne,"|",1)
			s AMRVerItemID = $p(singleOne,"|",2)
			s AMRItemID = $p(singleOne,"|",3)
			s ATotCount = $p(singleOne,"|",4)

			if (AMRItemID = ItemID)	
			{
				s MRItemEntity = ##class(DHCEPRFS.BL.BLMRItem).GetItemByID(ItemID)
				s MRItemName = MRItemEntity.Name
				s MRItemCode = MRItemEntity.Code
				s MRItemDescription = MRItemEntity.Description
				s MRItemType = MRItemEntity.Type
				s MRItemTypeParams = MRItemEntity.TypeParams
				s ^CacheTemp(repid,ind) = $lb(AMRVerItemID,MRItemName,MRItemCode,MRItemDescription,MRItemType,MRItemTypeParams,AMRVersionID,MRItemID,ATotCount)
				s ind=ind+1 		
			}
		}
	}
	Quit $$$OK
}

ClassMethod GetScheVerItemByIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetScheVerItemByIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetScheVerItemByIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetScheVerItemByIDExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

/// desc:取生成PDF方案
ClassMethod GetPDFCreateScheme() As %String
{
	s rowID = $O(^DHCEPRFS.META.PrintSchemeI("IdxIsCreate", " Y", ""))
	q rowID
}

/// Desc: 根据ItemID和就诊号，取浏览打印列表
/// Creator:Candy
/// CreateDate:20130521
/// Debug:do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLPrintScheme","GetVerItemByMrItemID","1","4")
Query GetVerItemByItemID(AMrItemID As %String, AMRVersionID As %String) As %Query(ROWSPEC = "MRVerItemID:%String,MRItemName:%String,MRItemCode:%String,MRItemDescription:%String,MRItemType:%String,MRItemTypeParams:%String,MRVersionID:%String,MRItemID:%String,TotCount:%String")
{
}

ClassMethod GetVerItemByItemIDExecute(ByRef qHandle As %Binary, AMrItemID As %String, AMRVersionID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	q:((AMrItemID = "")||(AMrItemID = $c(0))||AMRVersionID = "" || AMRVersionID = $c(0)) $$$OK
 	
 	s mrVerItemID = $O(^DHCEPRFS.INST.MRVerItemI("IdxMain", " "_AMRVersionID, " "_AMrItemID, ""))
	q:(mrVerItemID = "") $$$OK
	s objMRVerItem = ##Class(DHCEPRFS.INST.MRVerItem).%OpenId(mrVerItemID)
	q:(objMRVerItem = "") $$$OK
		
	s MRVerItemID = mrVerItemID
	s TotCount = objMRVerItem.TotCount
	
	s MRItemEntity = ##class(DHCEPRFS.BL.BLMRItem).GetItemByID(AMrItemID)
	s MRItemName = MRItemEntity.Name
	s MRItemCode = MRItemEntity.Code
	s MRItemDescription = MRItemEntity.Description
	s MRItemType = MRItemEntity.Type
	s MRItemTypeParams = MRItemEntity.TypeParams
	
    s ^CacheTemp(repid,ind) = $lb(mrVerItemID,MRItemName,MRItemCode,MRItemDescription,MRItemType,MRItemTypeParams,AMRVersionID,AMrItemID,TotCount)
	s ind=ind+1 
	Quit $$$OK
}

ClassMethod GetVerItemByItemIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetVerItemByItemIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetVerItemByItemIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetVerItemByItemIDExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

/// Debug:	w ##Class(DHCEPRFS.BL.BLPrintScheme).GetSchemeItems("2")
ClassMethod GetSchemeItems(ASchemeID As %String) As %String
{
	s objScheme = ##Class(DHCEPRFS.META.PrintScheme).%OpenId(ASchemeID)
    q:(objScheme = "") ""
   	
    s schemeItems = objScheme.SchemeItems
    q:(schemeItems="")||(schemeItems=$c(0)) ""
    
    s retItems = ""
    
    s count = $L(schemeItems,"^")
    for i = 1:1:count
    {
	    s itemInfo = $p(schemeItems, "^", i)
	    continue:((itemInfo="")||(itemInfo=$c(0)))
	    
	    if (retItems = "")
	    {	s retItems = $P(itemInfo, "#", 3)	}
	    else
	    {	s retItems = retItems_"^"_$P(itemInfo, "#", 3)	}
    }
    
    q retItems
}

/// 正常返回rowID，错误返回空
/// Debug:	w ##Class(DHCEPRFS.BL.BLPrintScheme).GetSchemeIDByDefault("VIEW")
ClassMethod GetSchemeIDByDefault(ASchemeType As %String) As %String
{
	s rowID = ""
	s rowID = $o(^DHCEPRFS.META.PrintSchemeI("IdxDefaultType"," "_ASchemeType," Y",rowID))
	q:(rowID = "") ""
	s obj = ##Class(DHCEPRFS.META.PrintScheme).%OpenId(rowID)
	s isAvailable = obj.IsAvailable
	if (isAvailable = "N")
	{
		s rowID = ""
	}
	q rowID
}

/// Desc: 增加扫描分类方案的角色权限
/// Debug: w ##Class(DHCEPRFS.BL.BLPrintScheme).AddScanScheme("1")
ClassMethod AddScanScheme(ASchemeID As %String) As %String
{
	s result = "0"
	q:(ASchemeID = "") result
	
	s rowID = ""
	s rowID = $o(^DHCEPRFS.META.QueryFunctionI("IdxFuncName"," SCAN_OPERATION_ARRANGE",rowID))
	if (rowID = "")  //若不存在扫描分类权限的根节点则新建
	{
		s objParentFunc = ##class(DHCEPRFS.META.QueryFunction).%New()
		s objParentFunc.ParentID = "0"
		s objParentFunc.FuncDesc = "扫描分类权限"
		s objParentFunc.FuncName = "Scan_Operation_Arrange"
		s sc = objParentFunc.%Save()
		if ($$$ISOK(sc)) {
			s rowID = objParentFunc.%Id()
			d objParentFunc.%Close()
		}
	}
	q:(rowID = "") result
	
	s count = 0, xFuncID = ""
	for {
		s xFuncID = $o(^DHCEPRFS.META.QueryFunctionI("IdxParentId"," "_rowID,xFuncID))
		q:(xFuncID = "")
		s count = count + 1
	}
	
	s objScheme = ##Class(DHCEPRFS.META.PrintScheme).%OpenId(ASchemeID)
	s schemeName = objScheme.SchemeName
	s schemeType = objScheme.SchemeType
	s isAvailable =objScheme.IsAvailable
	
	s queryFuncID = ""
	s queryFuncID = $o(^DHCEPRFS.META.QueryFunctionI("IdxNotes"," "_ASchemeID,queryFuncID))
	if (queryFuncID '= "")
	{
		s objQueryFunc = ##Class(DHCEPRFS.META.QueryFunction).%OpenId(queryFuncID)
		s funcName = "Scan_Operation_Arrange"_"_"_count_"_"_queryFuncID
	}
	else
	{
		s objQueryFunc = ##Class(DHCEPRFS.META.QueryFunction).%New()
		s funcName = "Scan_Operation_Arrange"_"_"_count
	}
	s objQueryFunc.FuncDesc = schemeName
	s objQueryFunc.FuncName = funcName
	s objQueryFunc.Notes = ASchemeID
	s objQueryFunc.ParentID = rowID
	if (schemeType = "SCANARRANGE")
	{
		s objQueryFunc.IsAvailable = isAvailable
	}
	else
	{
		s objQueryFunc.IsAvailable = "N"
	}
	s sc = objQueryFunc.%Save()
	if ($$$ISOK(sc)) {
		s result = "1"
		d objQueryFunc.%Close()
	}
	q result
}

/// Desc: 增加高拍分类方案的角色权限
/// Debug: w ##Class(DHCEPRFS.BL.BLPrintScheme).AddPhotoScheme("1")
ClassMethod AddPhotoScheme(ASchemeID As %String) As %String
{
	s result = "0"
	q:(ASchemeID = "") result
	
	s rowID = ""
	s rowID = $o(^DHCEPRFS.META.QueryFunctionI("IdxFuncName"," PHOTO_OPERATION_ARRANGE",rowID))
	if (rowID = "")  //若不存在高拍分类权限的根节点则新建
	{
		s objParentFunc = ##class(DHCEPRFS.META.QueryFunction).%New()
		s objParentFunc.ParentID = "0"
		s objParentFunc.FuncDesc = "高拍分类权限"
		s objParentFunc.FuncName = "Photo_Operation_Arrange"
		s sc = objParentFunc.%Save()
		if ($$$ISOK(sc)) {
			s rowID = objParentFunc.%Id()
			d objParentFunc.%Close()
		}
	}
	q:(rowID = "") result
	
	s count = 0, xFuncID = ""
	for {
		s xFuncID = $o(^DHCEPRFS.META.QueryFunctionI("IdxParentId"," "_rowID,xFuncID))
		q:(xFuncID = "")
		s count = count + 1
	}
	
	s objScheme = ##Class(DHCEPRFS.META.PrintScheme).%OpenId(ASchemeID)
	s schemeName = objScheme.SchemeName
	s schemeType = objScheme.SchemeType
	s isAvailable =objScheme.IsAvailable
	
	s queryFuncID = ""
	s queryFuncID = $o(^DHCEPRFS.META.QueryFunctionI("IdxNotes"," "_ASchemeID,queryFuncID))
	if (queryFuncID '= "")
	{
		s objQueryFunc = ##Class(DHCEPRFS.META.QueryFunction).%OpenId(queryFuncID)
		s funcName = "Photo_Operation_Arrange"_"_"_count_"_"_queryFuncID
	}
	else
	{
		s objQueryFunc = ##Class(DHCEPRFS.META.QueryFunction).%New()
		s funcName = "Photo_Operation_Arrange"_"_"_count
	}
	s objQueryFunc.FuncDesc = schemeName
	s objQueryFunc.FuncName = funcName
	s objQueryFunc.Notes = ASchemeID
	s objQueryFunc.ParentID = rowID
	if (schemeType = "PHOTOARRANGE")
	{
		s objQueryFunc.IsAvailable = isAvailable
	}
	else
	{
		s objQueryFunc.IsAvailable = "N"
	}
	s sc = objQueryFunc.%Save()
	if ($$$ISOK(sc)) {
		s result = "1"
		d objQueryFunc.%Close()
	}
	q result
}

/// Desc:	通过SchemeType获取SchemeID
/// w ##class(DHCEPRFS.BL.BLPrintScheme).GetSchemeIDBySchemeType("CREATETOP")
ClassMethod GetLateToCreateItems(ASchemeType As %String) As %String
{
	q:(ASchemeType = "") ""
	s rowID = ""
	s rowID = $o(^DHCEPRFS.META.LateToCreateI("IdxCreateType"," "_ASchemeType,rowID))
	q:(rowID = "") ""
	s obj = ##class(DHCEPRFS.META.LateToCreate).%OpenId(rowID)
	s MRItems = obj.MRItems
	q MRItems
}

/// Creator:liushuang
/// CreateDate:2018-05-14
/// Desc:增加方案辅助项目
ClassMethod SetSchemeSubItems(rowId As %String, SubItems As %String, CheckedSubItems As %String = "")
{
	s result = "0"
	if ($d(^DHCEPRFS.META.PrintSchemeD(rowId)))
	{
		s obj = ##Class(DHCEPRFS.META.PrintScheme).%OpenId(rowId)
		s obj.SchemeSubItems = SubItems
		s obj.CheckSubItems = CheckedSubItems
		s statue = obj.%Save()
		s:($$$ISOK(statue)) result = "1"
	}
	q result
}

/// Creator:liushuang
/// CreateDate:2018-05-14
/// Desc:获得方案辅助项
Query GetSchemeSubItemByID(ASchemeID As %String) As %Query(ROWSPEC = "MRItemID:%String,MRSubCateogryID:%String,MRCateCategoryID:%String,Description:%String,SubCgDesc:%String,CgDesc:%String,Checked:%String")
{
}

ClassMethod GetSchemeSubItemByIDExecute(ByRef qHandle As %Binary, ASchemeID As %String) As %Status
{
    s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	q:(ASchemeID = "") $$$OK
 	s obj = ##Class(DHCEPRFS.META.PrintScheme).%OpenId(ASchemeID)
 	q:(obj = "") $$$OK
 	s Items = obj.SchemeSubItems
 	s CheckedItems = obj.CheckSubItems
 	d obj.%Close()
 	q:(Items = "") $$$OK 
 	s total = $l(Items,"^")
 	for i=1:1:total
 	{
	    s ItemID = $p($p(Items,"^",i),"#",3)
	    s subCategoryID =  $p($p(Items,"^",i),"#",2)
	    s CategoryID =  $p($p(Items,"^",i),"#",1)
	    s objItem = ##Class(DHCEPRFS.META.MRItem).%OpenId(ItemID)
	    Continue:(objItem = "")
	    s Desc = objItem.Description
	    d objItem.%Close()
	    
	    s objSubCategory = ##Class(DHCEPRFS.META.MRSubCategory).%OpenId(subCategoryID)
	    Continue:(objSubCategory = "")
	    s SubCategoryDesc = objSubCategory.Description
	    d objSubCategory.%Close()
	    
	    s objCategory = ##Class(DHCEPRFS.META.MRCategory).%OpenId(CategoryID)
	    Continue:(objCategory = "")
	    s CategoryDesc = objCategory.Description
	    d objCategory.%Close()
	    
	    s checked = ..IsChecked($p(Items,"^",i),CheckedItems)
	    
		s data = $lb(ItemID,subCategoryID,CategoryID,Desc,SubCategoryDesc,CategoryDesc,checked)
	    s ^CacheTemp(repid,ind)=data
	    s ind=ind+1	    	
	}
	Quit $$$OK
}

ClassMethod GetSchemeSubItemByIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSchemeSubItemByIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetSchemeSubItemByIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSchemeSubItemByIDExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

/// Creator:yangpeng
/// CreateDate:2020-4-5
/// Desc:通过表达式获取就诊
/// w ##Class(DHCEPRFS.BL.BLPrintScheme).GetSchemeItemsByExp("@@S:13^15,T:71^21,I:2^3")
ClassMethod GetSchemeItemsByExp(QueryString As %String = "") As %String
{
	s ret=""
	s MRItemIDs=..GetItemIDsBySchemeExp(QueryString)
	for i=1:1:$l(MRItemIDs,"^")
	{
		s MRItemID=$p(MRItemIDs,"^",i)
		s objMRItem=##class(DHCEPRFS.META.MRItem).%OpenId(MRItemID)
		s objMRSubCategory=##class(DHCEPRFS.META.MRSubCategory).%OpenId(objMRItem.MRSubCategoryID)
		if (ret = "")
		{
			s ret=objMRSubCategory.MRCategoryID_"#"_objMRItem.MRSubCategoryID_"#"_MRItemID
		}
		else
		{
			s ret=ret_"^"_objMRSubCategory.MRCategoryID_"#"_objMRItem.MRSubCategoryID_"#"_MRItemID
		}
	}
	q ret
}

/// Creator:yangpeng
/// CreateDate:2020-3-1
/// Desc:通过表达式获取生成项目MRItemID
/// w ##Class(DHCEPRFS.BL.BLPrintScheme).GetItemsBySchemeExp("@@S:13^15,T:71^21,I:2^3")
ClassMethod GetItemIDsBySchemeExp(QueryString As %String = "") As %String
{
	q:QueryString="" ""
	if ($e(QueryString,1,2))'="@@"
	{
		q ..GetSchemeIDBySchemeType(QueryString)
	}
	s QueryString = $e(QueryString,3,$l(QueryString))
	s count = $l(QueryString,",")
	s arrMRItemID=##class(%ArrayOfDataTypes).%New()
	for i=1:1:count
	{
		s query = $p(QueryString,",",i)
		if ($e(query,1,2)="S:")
		{
			s SchemeIDString = $e(query,3,$l(query))
			s schemecount = $l(SchemeIDString,"^")
			for j=1:1:schemecount
			{
				s schemeid = $p(SchemeIDString,"^",j)
				continue:($data(^DHCEPRFS.META.PrintSchemeD(schemeid))="0")
				s items = $lg(^DHCEPRFS.META.PrintSchemeD(schemeid),4)
				s itemcount = $l(items,"^")
				for k=1:1:itemcount
				{
					s item = $p(items,"^",k)
					s itemid = $p(item,"#",3)
					if (itemid'=""){d arrMRItemID.SetAt(itemid,itemid)}
				}
			}
		}
		elseif ($e(query,1,2)="T:")
		{
			s ItemTypeString = $e(query,3,$l(query))
			s itemtypecount = $l(ItemTypeString,"^")
			for j=1:1:itemtypecount
			{
				s itemtype = $p(ItemTypeString,"^",j)
				s typeparams = ""
				for
				{
					s typeparams = $o(^DHCEPRFS.META.MRItemI("IdxType"," "_itemtype,typeparams))
					quit:(typeparams="")
					s itemid = $o(^DHCEPRFS.META.MRItemI("IdxType"," "_itemtype,typeparams,""))
					d arrMRItemID.SetAt(itemid,itemid)
				}
			}
		}
		elseif ($e(query,1,2)="I:")
		{
			
			s ItemIDString = $e(query,3,$l(query))
			s itemcount = $l(ItemIDString,"^")
			for j=1:1:itemcount
			{
				s itemid = $p(ItemIDString,"^",j)
				s flag = $data(^DHCEPRFS.META.MRItemD(itemid))
				if ((itemid'="") && (flag'="0"))
				{
					d arrMRItemID.SetAt(itemid,itemid)
				}
			}
		}
	}
	
	s key = ""
	s ret = ""
	for
	{
		s key = arrMRItemID.Next(key)
		q:(key="")
		if (ret = "")
		{
			s ret = arrMRItemID.GetAt(key)
		}
		else
		{
			s ret = ret_"^"_arrMRItemID.GetAt(key)
		}
	}
	q ret
}

/// Desc:记录方案内容修改日志
/// Creator:zeb
/// CreateDate:2020-09-30
/// w ##Class(DHCEPRFS.BL.BLPrintScheme).SetSchemeLog("2","3","2#2#2","192.170.3.16")
ClassMethod SetSchemeLog(AActUserID As %String, ASchemeID As %String, ASchemeItem As %String, AIP As %String) As %String
{
	s result = "0"
	s obj = ##Class(DHCEPRFS.INST.PrintSchemeLog).%New()
	s obj.ActDate = $p($h,",",1)
	s obj.ActTime = $p($h,",",2)
	s obj.IP = AIP
	s obj.ActUserID = AActUserID
	s obj.SchemeID = ASchemeID
	s obj.SchemeContent = ASchemeItem
	//s obj.Modifier = ##class(DHCEPRFS.BL.BLQueryUser).GetQueryUserName(AActUserID)
	s userObj = ##Class(DHCEPRFS.META.QueryUser).%OpenId(AActUserID)
	s obj.Modifier = userObj.UserName
	
	s PSobj = ##Class(DHCEPRFS.META.PrintScheme).%OpenId(ASchemeID)
	s obj.SchemeType = PSobj.SchemeType
	
	s status = obj.%Save()
	if ($$$ISOK(status))
	{
		s result = obj.%Id()
	}
	d obj.%Close()
	q result
}

/// Creator:yangpeng
/// CreateDate:2021.5.23
/// Desc:保存科室方案
/// w ##Class(DHCEPRFS.BL.BLPrintScheme).UpdateLocScheme(16,93,"33#217#178^33#217#150")
ClassMethod UpdateLocScheme(ASchemeID As %String, ALocID As %String, AExSchemeItems As %String) As %String
{
	s PrintSchemeLocID=""
	s PrintSchemeLocID=$o(^DHCEPRFS.META.PrintSchemeLocI("idxPrintSchemeLoc"," "_ASchemeID," "_ALocID,""))
	
	
	if (PrintSchemeLocID ="")
	{
		s objPrintSchemeLoc=##class(DHCEPRFS.META.PrintSchemeLoc).%New()
	}
	else
	{
		s objPrintSchemeLoc=##class(DHCEPRFS.META.PrintSchemeLoc).%OpenId(PrintSchemeLocID)
	}
	
	s objPrintSchemeLoc.PrintSchemeID=ASchemeID
	s objPrintSchemeLoc.LocID=ALocID
	s objPrintSchemeLoc.ExSchemeItems=AExSchemeItems
	s status = objPrintSchemeLoc.%Save()
	if ($$$ISOK(status))
	{
		s result = objPrintSchemeLoc.%Id()
	}
	else
	{
		s result = 0
	}
	q result
}

/// Creator:yangpeng
/// CreateDate:2021.5.23
/// Desc:获取科室方案
/// w ##Class(DHCEPRFS.BL.BLPrintScheme).GetLocScheme(16,93)
ClassMethod GetLocScheme(ASchemeID As %String, ALocID As %String) As %String
{
	s PrintSchemeLocID=""
	s PrintSchemeLocID=$o(^DHCEPRFS.META.PrintSchemeLocI("idxPrintSchemeLoc"," "_ASchemeID," "_ALocID,""))
	

	if (PrintSchemeLocID ="")
	{
		q ""
	}
	else
	{
		s objPrintSchemeLoc=##class(DHCEPRFS.META.PrintSchemeLoc).%OpenId(PrintSchemeLocID)
		q objPrintSchemeLoc.ExSchemeItems
	}
}

}
