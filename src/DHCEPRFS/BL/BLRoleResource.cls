Class DHCEPRFS.BL.BLRoleResource Extends %RegisteredObject [ ProcedureBlock ]
{

/// Desc:	初始化科室资源数据
/// Debug:	d ##Class(DHCEPRFS.BL.BLRoleResource).InitResourceLoc()
ClassMethod InitResourceLoc() As %String
{
	s obj = ##Class(%ResultSet).%New("DHCEPRFS.BL.HISInfo.BLDictionaryInfo:CTLoc")
	s sc = obj.Execute()

	while (obj.Next())
	{
		s objResourceLoc=##class(DHCEPRFS.META.ResourceLoc).%New()
		s objResourceLoc.LocID=obj.Get("rowid")
		s objResourceLoc.LocDesc=obj.Get("Desc")
		s objResourceLoc.InitialPinYin=##Class(DHCEPRFS.Util.StringHelper).GetCNCODE(obj.Get("Desc"),4)
		s objResourceLoc.AliasPinYin=##Class(DHCEPRFS.Util.StringHelper).GetCNCODE(obj.Get("Desc"),3)
		s objResourceLoc.Sequence=""
		s objResourceLoc.IsValid="1"
		s objResourceLoc.CatalogueCode=""
		
		s sc=objResourceLoc.%Save()
	}
}

/// Desc:	增加科室资源数据
/// Debug:	w ##Class(DHCEPRFS.BL.BLRoleResource).AddResourceLoc()
ClassMethod AddResourceLoc(ALocID As %String, ALocDesc As %String, AInitialPinYin As %String, AAliasPinYin As %String, ASequence As %String, AIsValid As %String, ACatalogueCode As %String) As %String
{
	s objResourceLoc=##class(DHCEPRFS.META.ResourceLoc).%New()
	s objResourceLoc.LocID=ALocID
	s objResourceLoc.LocDesc=ALocDesc
	s objResourceLoc.InitialPinYin=AInitialPinYin
	s objResourceLoc.AliasPinYin=AAliasPinYin
	s objResourceLoc.Sequence=ASequence
	s objResourceLoc.IsValid=AIsValid
	s objResourceLoc.CatalogueCode=ACatalogueCode
	
	s sc=objResourceLoc.%Save()
	if ($$$ISOK(sc))
	{q objResourceLoc.%Id() }
	else
	{q ""}
}

/// Desc:	修改科室资源数据
/// Debug:	w ##Class(DHCEPRFS.BL.BLRoleResource).UpdateResourceLoc()
ClassMethod UpdateResourceLoc(AResourceLocID As %String, ALocID As %String, ALocDesc As %String, AInitialPinYin As %String, AAliasPinYin As %String, ASequence As %String, AIsValid As %String, ACatalogueCode As %String) As %String
{
	s objResourceLoc=##class(DHCEPRFS.META.ResourceLoc).%OpenId(AResourceLocID)
	s objResourceLoc.LocID=ALocID
	s objResourceLoc.LocDesc=ALocDesc
	s objResourceLoc.InitialPinYin=AInitialPinYin
	s objResourceLoc.AliasPinYin=AAliasPinYin
	s objResourceLoc.Sequence=ASequence
	s objResourceLoc.IsValid=AIsValid
	s objResourceLoc.CatalogueCode=ACatalogueCode
	
	s sc=objResourceLoc.%Save()
	if ($$$ISOK(sc))
	{q objResourceLoc.%Id() }
	else
	{q ""}
}

/// Desc:	获取科室资源数据
/// Debug:	w ##Class(DHCEPRFS.BL.BLRoleResource).GetAllResourceLoc()
Query GetAllResourceLoc() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,LocID:%String,LocDesc:%String,InitialPinYin:%String,AliasPinYin:%String,Sequence:%String,IsValid:%String,CatalogueCode:%String")
{
	SELECT ID,LocID,LocDesc,InitialPinYin,AliasPinYin,Sequence,IsValid,CatalogueCode
	FROM DHCEPRFS_META.ResourceLoc
	ORDER BY ID
}

/// Desc:	初始化病历项目资源数据
/// Debug:	d ##Class(DHCEPRFS.BL.BLRoleResource).InitResourceMRItem()
ClassMethod InitResourceMRItem() As %String
{
	s MRItemRowID=""
	
	for {
		s MRItemRowID= $o(^DHCEPRFS.META.MRItemD(MRItemRowID))
		q:(MRItemRowID="")
		
		s objMRItem=##class(DHCEPRFS.META.MRItem).%OpenId(MRItemRowID)
		s objMRSubCategory=##class(DHCEPRFS.META.MRSubCategory).%OpenId(objMRItem.MRSubCategoryID)
		s objMRCategory=##class(DHCEPRFS.META.MRCategory).%OpenId(objMRSubCategory.MRCategoryID)
		
		s objResourceMRItem=##class(DHCEPRFS.META.ResourceMRItem).%New()
		s objResourceMRItem.MRCategoryID=objMRCategory.%Id()
		s objResourceMRItem.MRCategoryName=objMRCategory.Name
		s objResourceMRItem.MRSubCategoryID=objMRSubCategory.%Id()
		s objResourceMRItem.MRSubCategoryName=objMRSubCategory.Name
		s objResourceMRItem.MRItemID=objMRItem.%Id()
		s objResourceMRItem.MRItemName=objMRItem.Name
		s objResourceMRItem.InitialPinYin=##Class(DHCEPRFS.Util.StringHelper).GetCNCODE(objMRItem.Name,4)
		s objResourceMRItem.AliasPinYin=##Class(DHCEPRFS.Util.StringHelper).GetCNCODE(objMRItem.Name,3)
		s objResourceMRItem.IsValid="1"
		s objResourceMRItem.CatalogueCode=""
		
		s sc=objResourceMRItem.%Save()
	}
}

/// Desc:	增加病历项目资源数据
/// Debug:	d ##Class(DHCEPRFS.BL.BLRoleResource).AddResourceMRItem()
ClassMethod AddResourceMRItem(AMRItemID As %String, AMRItemName As %String, AInitialPinYin As %String, AAliasPinYin As %String, AIsValid As %String, ACatalogueCode As %String) As %String
{
	s objMRItem=##class(DHCEPRFS.META.MRItem).%OpenId(AMRItemID)
	s objMRSubCategory=##class(DHCEPRFS.META.MRSubCategory).%OpenId(objMRItem.MRSubCategoryID)
	s objMRCategory=##class(DHCEPRFS.META.MRCategory).%OpenId(objMRSubCategory.MRCategoryID)

	s obj=##class(DHCEPRFS.META.ResourceMRItem).%New()
	s obj.MRCategoryID=objMRCategory.%Id()
	s obj.MRCategoryName=objMRCategory.Name
	s obj.MRSubCategoryID=objMRSubCategory.%Id()
	s obj.MRSubCategoryName=objMRSubCategory.Name
	s obj.MRItemID=AMRItemID
	s obj.MRItemName=objMRItem.Name
	s obj.InitialPinYin=AInitialPinYin
	s obj.AliasPinYin=AAliasPinYin
	s obj.IsValid=AIsValid
	s obj.CatalogueCode=ACatalogueCode
	
	s sc=obj.%Save()
	if ($$$ISOK(sc))
	{q obj.%Id()}
	else
	{q ""}
}

/// Desc:	更新病历项目资源数据
/// Debug:	d ##Class(DHCEPRFS.BL.BLRoleResource).UpdateResourceMRItem()
ClassMethod UpdateResourceMRItem(AResourceMRItemID As %String, AMRItemID As %String, AMRItemName As %String, AInitialPinYin As %String, AAliasPinYin As %String, AIsValid As %String, ACatalogueCode As %String) As %String
{
	s objMRItem=##class(DHCEPRFS.META.MRItem).%OpenId(AMRItemID)
	s objMRSubCategory=##class(DHCEPRFS.META.MRSubCategory).%OpenId(objMRItem.MRSubCategoryID)
	s objMRCategory=##class(DHCEPRFS.META.MRCategory).%OpenId(objMRSubCategory.MRCategoryID)
	
	s obj=##class(DHCEPRFS.META.ResourceMRItem).%OpenId(AResourceMRItemID)
	s obj.MRCategoryID=objMRCategory.%Id()
	s obj.MRCategoryName=objMRCategory.Name
	s obj.MRSubCategoryID=objMRSubCategory.%Id()
	s obj.MRSubCategoryName=objMRSubCategory.Name
	s obj.MRItemID=AMRItemID
	s obj.MRItemName=objMRItem.Name
	s obj.InitialPinYin=AInitialPinYin
	s obj.AliasPinYin=AAliasPinYin
	s obj.IsValid=AIsValid
	s obj.CatalogueCode=ACatalogueCode
	
	s sc=obj.%Save()
	if ($$$ISOK(sc))
	{q obj.%Id()}
	else
	{q ""}
}

/// Desc:	获取病例项目资源数据
/// Debug:	w ##Class(DHCEPRFS.BL.BLRoleResource).GetAllResourceMRItem()
Query GetAllResourceMRItem() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,MRCategoryID:%String,MRCategoryName:%String,MRSubCategoryID:%String,MRSubCategoryName:%String,MRItemID:%String,MRItemName:%String,InitialPinYin:%String,AliasPinYin:%String,IsValid:%String,CatalogueCode:%String")
{
	SELECT ID,MRCategoryID,MRCategoryName,MRSubCategoryID,MRSubCategoryName,MRItemID,MRItemName,InitialPinYin,AliasPinYin,IsValid,CatalogueCode
	FROM DHCEPRFS_META.ResourceMRItem
	ORDER BY ID
}

/// Desc:	初始化出院日期资源
/// Debug:	d ##Class(DHCEPRFS.BL.BLRoleResource).InitResourceDisDate()
ClassMethod InitResourceDisDate() As %String
{
	s objResourceDisDate=##class(DHCEPRFS.META.ResourceDisDate).%New()
	s objResourceDisDate.StartDate=$zdh("2000-01-01",3)
	s objResourceDisDate.EndDate=$zdh("2020-01-01",3)
	s objResourceDisDate.NoExpireFlag="1"
	s objResourceDisDate.IsValid="1"
	s sc=objResourceDisDate.%Save()
}

/// Desc:	增加出院日期资源
/// Debug:	d ##Class(DHCEPRFS.BL.BLRoleResource).AddResourceDisDate()
ClassMethod AddResourceDisDate(AStartDate As %String, AEndDate As %String, ANoExpireFlag As %String, AIsValid As %String) As %String
{
	s obj=##class(DHCEPRFS.META.ResourceDisDate).%New()
	s obj.StartDate=$zdh(AStartDate,3)
	s obj.EndDate=$zdh(AEndDate,3)
	s obj.NoExpireFlag=ANoExpireFlag
	s obj.IsValid=AIsValid
	
	s sc=obj.%Save()
	if ($$$ISOK(sc))
	{q obj.%Id()}
	else
	{q ""}
}

/// Desc:	更新出院日期资源
/// Debug:	d ##Class(DHCEPRFS.BL.BLRoleResource).AddResourceDisDate()
ClassMethod UpdateResourceDisDate(AResourceDisDateID As %String, AStartDate As %String, AEndDate As %String, ANoExpireFlag As %String, AIsValid As %String) As %String
{
	s obj=##class(DHCEPRFS.META.ResourceDisDate).%OpenId(AResourceDisDateID)
	s obj.StartDate=$zdh(AStartDate,3)
	s obj.EndDate=$zdh(AEndDate,3)
	s obj.NoExpireFlag=ANoExpireFlag
	s obj.IsValid=AIsValid
	
	s sc=obj.%Save()
	if ($$$ISOK(sc))
	{q obj.%Id()}
	else
	{q ""}
}

/// Desc:	获取出院日期资源数据
/// Debug:	w ##Class(DHCEPRFS.BL.BLRoleResource).GetAllResourceDisDate()
Query GetAllResourceDisDate() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,StartDate:%String,EndDate:%String,NoExpireFlag:%String,IsValid:%String")
{
    SELECT ID,TO_CHAR(StartDate,'YYYY-MM-DD') AS StartDate,TO_CHAR(EndDate,'YYYY-MM-DD') AS EndDate,NoExpireFlag,IsValid
    FROM DHCEPRFS_META.ResourceDisDate
    ORDER BY ID
}

/// Desc:	初始化功能资源
/// Debug:	d ##Class(DHCEPRFS.BL.BLRoleResource).InitResourceFunc()
ClassMethod InitResourceFunc() As %String
{
	s result=##class(%XML.DataSet).%New()
    d result.Prepare("SELECT FuncName,FuncDesc,'1' AS IsValid,'' AS Sequence,ParentID " _
    				" FROM DHCEPRFS_META.QueryFunction WHERE FuncDesc<>'' ORDER BY FuncName")
    d result.Execute()
    while (result.Next())
    {
	   s objResourceFunc=##class(DHCEPRFS.META.ResourceFunc).%New()
	   s objResourceFunc.FuncCode=result.Get("FuncName")
	   s objResourceFunc.FuncName=result.Get("FuncDesc")
	   s objResourceFunc.IsValid="1"
	   s objResourceFunc.Sequence=""
	   s sc=objResourceFunc.%Save()
	}
}

/// Desc:	获取功能资源数据
/// Debug:	w ##Class(DHCEPRFS.BL.BLRoleResource).GetAllResourceFunc()
Query GetAllResourceFunc() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,FuncCode:%String,FuncName:%String,Sequence:%String,IsValid:%String")
{
    SELECT ID,FuncCode,FuncName,Sequence,IsValid
    FROM DHCEPRFS_META.ResourceFunc
    ORDER BY ID
}

/// Desc:	初始化资源操作
/// Debug:	d ##Class(DHCEPRFS.BL.BLRoleResource).InitResourceOperation()
ClassMethod InitResourceOperation() As %String
{
	&sql(insert into DHCEPRFS_META.ResourceOperation(OperationCode,OperationDesc,IsValid) 
		values ('BROWSE', '浏览','1'))
	&sql(insert into DHCEPRFS_META.ResourceOperation(OperationCode,OperationDesc,IsValid) 
		values ('EXPORT', '导出','1'))
	&sql(insert into DHCEPRFS_META.ResourceOperation(OperationCode,OperationDesc,IsValid) 
		values ('ENABLE', '启用','1'))
}

/// Desc:	初始化资源类型
/// Debug:	d ##Class(DHCEPRFS.BL.BLRoleResource).InitResourceType()
ClassMethod InitResourceType() As %String
{
	&sql(insert into DHCEPRFS_META.ResourceType(ResourceTypeCode,ResourceTypeName,AvailableOperations) 
		values ('LOC', '病历科室资源','BROWSE^EXPORT'))
	&sql(insert into DHCEPRFS_META.ResourceType(ResourceTypeCode,ResourceTypeName,AvailableOperations) 
		values ('MRITEM', '病历项目资源','BROWSE^EXPORT'))
	&sql(insert into DHCEPRFS_META.ResourceType(ResourceTypeCode,ResourceTypeName,AvailableOperations) 
		values ('DISDATE', '病历出院日期资源','BROWSE^EXPORT'))
	&sql(insert into DHCEPRFS_META.ResourceType(ResourceTypeCode,ResourceTypeName,AvailableOperations) 
		values ('FUNC', '功能资源','ENABLE'))
}

/// Desc:	获取资源类型数据
/// Debug:	w ##Class(DHCEPRFS.BL.BLRoleResource).GetAllResourceType()
Query GetAllResourceType() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,ResourceTypeCode:%String,ResourceTypeName:%String,AvailableOperations:%String")
{
    SELECT ID,ResourceTypeCode,ResourceTypeName,AvailableOperations
    FROM DHCEPRFS_META.ResourceType
    ORDER BY ID
}

/// Desc:	获取资源表数据
/// Debug:	w ##Class(DHCEPRFS.BL.BLRoleResource).GetAllResourceType()
ClassMethod GetResourceByID(AResourceTypeCode As %String, AResourceID As %String) As %XML.DataSet
{
	s ret=##Class(%XML.DataSet).%New()
	s TableName=""
	if (AResourceTypeCode="LOC")
	{s TableName="ResourceLoc"}
	if (AResourceTypeCode="MRITEM")
	{s TableName="ResourceMRItem"}
	if (AResourceTypeCode="DISDATE")
	{s TableName="ResourceDisDate"}
	if (AResourceTypeCode="FUNC")
	{s TableName="ResourceFunc"}
	 
	d ret.Prepare("SELECT * FROM DHCEPRFS_META."_TableName_" WHERE ID='"_	AResourceID_"'")
	d ret.Execute()
	q ret
}

/// Desc:	查询资源对应的操作
/// Input：	AResourceTypeCode
/// Debug：	do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLRoleResource","GetResourceOperation","LOC")
Query GetResourceOperation(AResourceTypeCode As %String) As %Query(ROWSPEC = "Id:%String,OperationCode:%String,OperationDesc:%String,IsValid:%String")
{
}

ClassMethod GetResourceOperationExecute(ByRef qHandle As %Binary, AResourceTypeCode As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1	
 	s ResourceTypeRowID=""
 	s ResourceTypeRowID=$o(^DHCEPRFS.META.ResourceTypeI("IdxResourceTypeCode"," "_AResourceTypeCode,ResourceTypeRowID))
 	
 	q:(ResourceTypeRowID="")
 	s objResourceType=##class(DHCEPRFS.META.ResourceType).%OpenId(ResourceTypeRowID)
 	
 	s Operations=objResourceType.AvailableOperations
 	
 	for i=1:1:$l(Operations,"^")
 	{
	 	s OperationCode=$p(Operations,"^",i)
	 	s ResourceOperationRowID=""
	 	s ResourceOperationRowID=$o(^DHCEPRFS.META.ResourceOperaI("IdxOperationCode"," "_OperationCode,ResourceOperationRowID))
	 	
	 	s objResourceOperation=##class(DHCEPRFS.META.ResourceOperation).%OpenId(ResourceOperationRowID)
	 	
	 	s ^CacheTemp(repid,ind) = $lb(objResourceOperation.%Id(),objResourceOperation.OperationCode,
	 						objResourceOperation.OperationDesc,objResourceOperation.IsValid )
		s ind = ind + 1
	 	
	}

	quit $$$OK
}

ClassMethod GetResourceOperationFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetResourceOperationExecute ]
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

ClassMethod GetResourceOperationClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetResourceOperationExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc:	保存角色资源操作关系
/// Input：	ARoleResourceStr RoleID|ResourceID|ResourceTypeCode|OperationCode~
/// Debug：	d ##Class(DHCEPRFS.BL.BLRoleResource).SaveRoleResourceLink()
ClassMethod SaveRoleResourceLink(ARoleResourceStr As %String) As %String
{
	if (ARoleResourceStr="")
	{
		q ""
	}
	
	s oneRow=$p(ARoleResourceStr,"~",1)
	s RoleID=$p(oneRow,"|",1)
	s ResourceTypeCode=$p(oneRow,"|",3)
	
	s RoleResourceLinkID=""	//先删
	for {
		s RoleResourceLinkID=$o(^DHCEPRFS.INST.RoleResLinkI("IdxRoleResourceType"," "_RoleID," "_ResourceTypeCode,RoleResourceLinkID))
		q:(RoleResourceLinkID="")
		s sc=##class(DHCEPRFS.INST.RoleResourceLink).%DeleteId(RoleResourceLinkID)
	}
	
	for i=1:1:$l(ARoleResourceStr,"~")	//后加
	{
		s oneRow=$p(ARoleResourceStr,"~",i)
		s obj=##class(DHCEPRFS.INST.RoleResourceLink).%New()
		s obj.RoleID=$p(oneRow,"|",1)
		s obj.ResourceID=$p(oneRow,"|",2)
		s obj.ResourceTypeCode=$p(oneRow,"|",3)
		s obj.OperationCode=$p(oneRow,"|",4)
		
		s sc=obj.%Save()
	}
	
	q ""
}

/// Desc:	获取角色资源关系
/// Debug:	w ##Class(DHCEPRFS.BL.BLRoleResource).GetRoleResourceLink()
Query GetRoleResourceLink(ARoleID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,RoleID:%String,ResourceID:%String,ResourceTypeCode:%String,OperationCode:%String")
{
    SELECT ID,RoleID,ResourceID,ResourceTypeCode,OperationCode
    FROM DHCEPRFS_INST.RoleResourceLink
    WHERE RoleID=:ARoleID
    ORDER BY ID
}

/// Desc:	查询角色资源对应的操作
/// Input：	ARoleID
/// 	Input:	AResourceTypeCode
/// Debug：	d ##Class(DHCEPRFS.BL.BLRoleResource).GetRoleResourceOperation("6","FUNC")
ClassMethod GetRoleResourceOperation(ARoleID As %String, AResourceTypeCode As %String) As %String
{
	s RoleResourceLinkID=""
	s RoleResourceLinkID=$o(^DHCEPRFS.INST.RoleResLinkI("IdxRoleResourceType"," "_ARoleID," "_AResourceTypeCode,RoleResourceLinkID))
	
	if (RoleResourceLinkID="")
	{
		q ""
	}
	else
	{
		s objRoleResourceLink=##class(DHCEPRFS.INST.RoleResourceLink).%OpenId(RoleResourceLinkID)
		q objRoleResourceLink.OperationCode
	}
}

/// Debug:	d ##Class(DHCEPRFS.BL.BLRoleResource).Test()
ClassMethod Test() As %String
{
	s result=##Class(%ResultSet).%New("DHCEPRFS.BL.BLRoleResource:GetAllResourceDisDate")
	d result.Execute()
	while (result.Next())
	{
		w result.Get("StartDate"),!
	}
}

}
