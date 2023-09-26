Class DHCEPRFS.BL.BLMetaLCQuery Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Desc: 系统参数表查询
/// Debug: d ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMetaLCQuery","GetSysOption")
Query GetSysOption() As %Query(ROWSPEC = "ID:%String,OptionDesc:%String,OptionName:%String,OptionType:%String,OptionValue:%String")
{
}

ClassMethod GetSysOptionExecute(ByRef qHandle As %Binary) As %Status
{
	s repid = $I(^CacheTemp)
	s qHandle = $lb(0,repid,0)
	s ind = 1
	
	s rowID = ""
	f {
		s rowID = $o(^DHCEPRFS.META.SysOptionD(rowID))
		q:(rowID = "")
		s objSysOption = ##class(DHCEPRFS.META.SysOption).%OpenId(rowID)
		s optionDesc = objSysOption.OptionDesc
		s optionName = objSysOption.OptionName
		s optionType = objSysOption.OptionType
		s optionValue = objSysOption.OptionValue
		d objSysOption.%Close()
		s ^CacheTemp(repid,ind) = $lb(rowID,optionDesc,optionName,optionType,optionValue)
		s ind = ind + 1
	}
	
	q $$$OK
}

ClassMethod GetSysOptionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSysOptionExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
	Set repid = $LIST(qHandle,2)
	Set ind = $LIST(qHandle,3)
	Set ind = $o(^CacheTemp(repid,ind))
	If ind = "" {				// if there are no more rows, finish fetching
		Set AtEnd = 1
		Set Row = ""
		kill ^CacheTemp(repid)
	}
	Else      {				// fetch row
		Set Row = ^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetSysOptionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSysOptionExecute ]
{
	Set repid = $LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc: 归档动作维护表查询
/// Debug: d ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMetaLCQuery","GetMRAction")
Query GetMRAction() As %Query(ROWSPEC = "ID:%String,ActionCode:%String,ActionName:%String,IsActive:%String,CategoryCode:%String,CategoryName:%String,OrderNo:%String")
{
}

ClassMethod GetMRActionExecute(ByRef qHandle As %Binary) As %Status
{
	s repid = $I(^CacheTemp)
	s qHandle = $lb(0,repid,0)
	s ind = 1
	
	s rowID = ""
	f {
		s rowID = $o(^DHCEPRFS.META.MRActionD(rowID))
		q:(rowID = "")
		s objAction = ##class(DHCEPRFS.META.MRAction).%OpenId(rowID)
		s actionCode = objAction.ActionCode
		s actionName = objAction.ActionName
		s isActive = objAction.IsActive
		s categoryCode = objAction.CategoryCode
		s categoryName = objAction.CategoryName
		s orderNo = objAction.OrderNo
		d objAction.%Close()
		s ^CacheTemp(repid,ind) = $lb(rowID,actionCode,actionName,isActive,categoryCode,categoryName,orderNo)
		s ind = ind + 1
	}
	
	q $$$OK
}

ClassMethod GetMRActionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMRActionExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
	Set repid = $LIST(qHandle,2)
	Set ind = $LIST(qHandle,3)
	Set ind = $o(^CacheTemp(repid,ind))
	If ind = "" {				// if there are no more rows, finish fetching
		Set AtEnd = 1
		Set Row = ""
		kill ^CacheTemp(repid)
	}
	Else      {				// fetch row
		Set Row = ^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetMRActionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMRActionExecute ]
{
	Set repid = $LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc: 三单一致编目配置表查询
/// Debug: d ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMetaLCQuery","GetRecordCheck")
Query GetRecordCheck() As %Query(ROWSPEC = "ID:%String,CheckDesc:%String,CheckName:%String,CheckType:%String,CheckURL:%String,IsValid:%String,Sequence:%String")
{
}

ClassMethod GetRecordCheckExecute(ByRef qHandle As %Binary) As %Status
{
	s repid = $I(^CacheTemp)
	s qHandle = $lb(0,repid,0)
	s ind = 1
	
	s rowID = ""
	f {
		s rowID = $o(^DHCEPRFS.META.RecordCheckD(rowID))
		q:(rowID = "")
		s objRecordCheck = ##class(DHCEPRFS.META.RecordCheck).%OpenId(rowID)
		s checkDesc = objRecordCheck.CheckDesc
		s checkName = objRecordCheck.CheckName
		s checkType = objRecordCheck.CheckType
		s checkURL = objRecordCheck.CheckURL
		s isValid = objRecordCheck.IsValid
		s sequence = objRecordCheck.Sequence
		d objRecordCheck.%Close()
		s ^CacheTemp(repid,ind) = $lb(rowID,checkDesc,checkName,checkType,checkURL,isValid,sequence)
		s ind = ind + 1
	}
	
	q $$$OK
}

ClassMethod GetRecordCheckFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRecordCheckExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
	Set repid = $LIST(qHandle,2)
	Set ind = $LIST(qHandle,3)
	Set ind = $o(^CacheTemp(repid,ind))
	If ind = "" {				// if there are no more rows, finish fetching
		Set AtEnd = 1
		Set Row = ""
		kill ^CacheTemp(repid)
	}
	Else      {				// fetch row
		Set Row = ^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetRecordCheckClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRecordCheckExecute ]
{
	Set repid = $LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc: 归档项目csp对照表查询
/// Debug: d ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMetaLCQuery","GetCTItemType")
Query GetCTItemType() As %Query(ROWSPEC = "ID:%String,TypeCode:%String,TypeName:%String,TypeDesc:%String,CSPPath:%String,Sequence:%String,ProductSource:%String,InvokeType:%String,TypeURL:%String,TypeClass:%String,TypeMethod:%String,TypeFTPConfig:%String,TypeNote:%String,TypeFlag:%String,CreateType:%String,Company:%String,ProductTeam:%String,CreateTypeSub:%String")
{
}

ClassMethod GetCTItemTypeExecute(ByRef qHandle As %Binary) As %Status
{
	s repid = $I(^CacheTemp)
	s qHandle = $lb(0,repid,0)
	s ind = 1
	
	s rowID = ""
	f {
		s rowID = $o(^DHCEPRFS.META.CTItemTypeD(rowID))
		q:(rowID = "")
		s objCTItemType = ##class(DHCEPRFS.META.CTItemType).%OpenId(rowID)
		s typeCode = objCTItemType.TypeCode
		s typeName = objCTItemType.TypeName
		s typeDesc = objCTItemType.TypeDesc
		s cspPath = objCTItemType.CSPPath
		s sequence = objCTItemType.Sequence
		s productSource = objCTItemType.ProductSource
		s invokeType = objCTItemType.InvokeType
		s typeURL = objCTItemType.TypeURL
		s typeClass = objCTItemType.TypeClass
		s typeMethod = objCTItemType.TypeMethod
		s typeFTPConfig = objCTItemType.TypeFTPConfig
		s typeNote = objCTItemType.TypeNote
		s typeFlag = objCTItemType.TypeFlag
		s createType = objCTItemType.CreateType
		s company = objCTItemType.Company
		s productTeam = objCTItemType.ProductTeam
		s createTypeSub = objCTItemType.CreateTypeSub 
		d objCTItemType.%Close()
		s ^CacheTemp(repid,ind) = $lb(rowID,typeCode,typeName,typeDesc,cspPath,sequence,productSource,invokeType,typeURL,typeClass,typeMethod,typeFTPConfig,typeNote,typeFlag,createType,company,productTeam,createTypeSub)
		s ind = ind + 1
	}
	
	q $$$OK
}

ClassMethod GetCTItemTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCTItemTypeExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
	Set repid = $LIST(qHandle,2)
	Set ind = $LIST(qHandle,3)
	Set ind = $o(^CacheTemp(repid,ind))
	If ind = "" {				// if there are no more rows, finish fetching
		Set AtEnd = 1
		Set Row = ""
		kill ^CacheTemp(repid)
	}
	Else      {				// fetch row
		Set Row = ^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetCTItemTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCTItemTypeExecute ]
{
	Set repid = $LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc: 归档项目表查询
/// Debug: d ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMetaLCQuery","GetMRItem")
Query GetMRItem() As %Query(ROWSPEC = "ID:%String,Name:%String,Code:%String,Description:%String,MRSubCategoryID:%String,Type:%String,TypeParams:%String,Source:%String,Sequence:%String,Attachment:%String,AttachType:%String,SubFlag:%String,OCRArrangeTitle:%String")
{
}

ClassMethod GetMRItemExecute(ByRef qHandle As %Binary) As %Status
{
	s repid = $I(^CacheTemp)
	s qHandle = $lb(0,repid,0)
	s ind = 1
	
	s rowID = ""
	f {
		s rowID = $o(^DHCEPRFS.META.MRItemD(rowID))
		q:(rowID = "")
		s objMRItem = ##class(DHCEPRFS.META.MRItem).%OpenId(rowID)
		s name = objMRItem.Name
		s code = objMRItem.Code
		s description = objMRItem.Description
		s mrSubCategoryID = objMRItem.MRSubCategoryID
		s type = objMRItem.Type
		s typeParams = objMRItem.TypeParams
		s source = objMRItem.Source
		s sequence = objMRItem.Sequence
		s attachment = objMRItem.Attachment
		s attachType = objMRItem.AttachType
		s subFlag = objMRItem.SubFlag
		s ocrArrangeTitle = objMRItem.OCRArrangeTitle
		d objMRItem.%Close()
		s ^CacheTemp(repid,ind) = $lb(rowID,name,code,description,mrSubCategoryID,type,typeParams,source,sequence,attachment,attachType,subFlag,ocrArrangeTitle)
		s ind = ind + 1
	}
	
	q $$$OK
}

ClassMethod GetMRItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMRItemExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
	Set repid = $LIST(qHandle,2)
	Set ind = $LIST(qHandle,3)
	Set ind = $o(^CacheTemp(repid,ind))
	If ind = "" {				// if there are no more rows, finish fetching
		Set AtEnd = 1
		Set Row = ""
		kill ^CacheTemp(repid)
	}
	Else      {				// fetch row
		Set Row = ^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetMRItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMRItemExecute ]
{
	Set repid = $LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc: 归档大类表查询
/// Debug: d ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMetaLCQuery","GetMRCategory")
Query GetMRCategory() As %Query(ROWSPEC = "ID:%String,Name:%String,Code:%String,Description:%String,Sequence:%String")
{
}

ClassMethod GetMRCategoryExecute(ByRef qHandle As %Binary) As %Status
{
	s repid = $I(^CacheTemp)
	s qHandle = $lb(0,repid,0)
	s ind = 1
	
	s rowID = ""
	f {
		s rowID = $o(^DHCEPRFS.META.MRCategoryD(rowID))
		q:(rowID = "")
		s objMRCategory = ##class(DHCEPRFS.META.MRCategory).%OpenId(rowID)
		s name = objMRCategory.Name
		s code = objMRCategory.Code
		s description = objMRCategory.Description
		s sequence = objMRCategory.Sequence
		d objMRCategory.%Close()
		s ^CacheTemp(repid,ind) = $lb(rowID,name,code,description,sequence)
		s ind = ind + 1
	}
	
	q $$$OK
}

ClassMethod GetMRCategoryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMRCategoryExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
	Set repid = $LIST(qHandle,2)
	Set ind = $LIST(qHandle,3)
	Set ind = $o(^CacheTemp(repid,ind))
	If ind = "" {				// if there are no more rows, finish fetching
		Set AtEnd = 1
		Set Row = ""
		kill ^CacheTemp(repid)
	}
	Else      {				// fetch row
		Set Row = ^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetMRCategoryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMRCategoryExecute ]
{
	Set repid = $LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc: 归档子类表查询
/// Debug: d ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMetaLCQuery","GetMRSubCategory")
Query GetMRSubCategory() As %Query(ROWSPEC = "ID:%String,Name:%String,Code:%String,Description:%String,MRCategoryID:%String,Sequence:%String,TypeParam:%String")
{
}

ClassMethod GetMRSubCategoryExecute(ByRef qHandle As %Binary) As %Status
{
	s repid = $I(^CacheTemp)
	s qHandle = $lb(0,repid,0)
	s ind = 1
	
	s rowID = ""
	f {
		s rowID = $o(^DHCEPRFS.META.MRSubCategoryD(rowID))
		q:(rowID = "")
		s objSub = ##class(DHCEPRFS.META.MRSubCategory).%OpenId(rowID)
		s name = objSub.Name
		s code = objSub.Code
		s description = objSub.Description
		s mrCategoryID = objSub.MRCategoryID
		s sequence = objSub.Sequence
		s typeParam = objSub.TypeParam
		d objSub.%Close()
		s ^CacheTemp(repid,ind) = $lb(rowID,name,code,description,mrCategoryID,sequence,typeParam)
		s ind = ind + 1
	}
	
	q $$$OK
}

ClassMethod GetMRSubCategoryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMRSubCategoryExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
	Set repid = $LIST(qHandle,2)
	Set ind = $LIST(qHandle,3)
	Set ind = $o(^CacheTemp(repid,ind))
	If ind = "" {				// if there are no more rows, finish fetching
		Set AtEnd = 1
		Set Row = ""
		kill ^CacheTemp(repid)
	}
	Else      {				// fetch row
		Set Row = ^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetMRSubCategoryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMRSubCategoryExecute ]
{
	Set repid = $LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc: 归档状态表查询
/// Debug: d ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMetaLCQuery","GetMRStatus")
Query GetMRStatus() As %Query(ROWSPEC = "ID:%String,StatusCode:%String,StatusName:%String,IsActive:%String")
{
}

ClassMethod GetMRStatusExecute(ByRef qHandle As %Binary) As %Status
{
	s repid = $I(^CacheTemp)
	s qHandle = $lb(0,repid,0)
	s ind = 1
	
	s rowID = ""
	f {
		s rowID = $o(^DHCEPRFS.META.MRStatusD(rowID))
		q:(rowID = "")
		s objMRStatus = ##class(DHCEPRFS.META.MRStatus).%OpenId(rowID)
		s statusCode = objMRStatus.StatusCode
		s statusName = objMRStatus.StatusName
		s isActive = objMRStatus.IsActive
		d objMRStatus.%Close()
		s ^CacheTemp(repid,ind) = $lb(rowID,statusCode,statusName,isActive)
		s ind = ind + 1
	}
	
	q $$$OK
}

ClassMethod GetMRStatusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMRStatusExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
	Set repid = $LIST(qHandle,2)
	Set ind = $LIST(qHandle,3)
	Set ind = $o(^CacheTemp(repid,ind))
	If ind = "" {				// if there are no more rows, finish fetching
		Set AtEnd = 1
		Set Row = ""
		kill ^CacheTemp(repid)
	}
	Else      {				// fetch row
		Set Row = ^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetMRStatusClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMRStatusExecute ]
{
	Set repid = $LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc: 状态转换表查询
/// Debug: d ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMetaLCQuery","GetMRTransition")
Query GetMRTransition() As %Query(ROWSPEC = "ID:%String,PrevStatusCode:%String,ActionCode:%String,PostStatusCode:%String,IsActive:%String")
{
}

ClassMethod GetMRTransitionExecute(ByRef qHandle As %Binary) As %Status
{
	s repid = $I(^CacheTemp)
	s qHandle = $lb(0,repid,0)
	s ind = 1
	
	s rowID = ""
	f {
		s rowID = $o(^DHCEPRFS.META.MRTransitionD(rowID))
		q:(rowID = "")
		s objMRTransition = ##class(DHCEPRFS.META.MRTransition).%OpenId(rowID)
		s prevStatusCode = objMRTransition.PrevStatusCode
		s actionCode = objMRTransition.ActionCode
		s postStatusCode = objMRTransition.PostStatusCode
		s isActive = objMRTransition.IsActive
		d objMRTransition.%Close()
		s ^CacheTemp(repid,ind) = $lb(rowID,prevStatusCode,actionCode,postStatusCode,isActive)
		s ind = ind + 1
	}
	
	q $$$OK
}

ClassMethod GetMRTransitionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMRTransitionExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
	Set repid = $LIST(qHandle,2)
	Set ind = $LIST(qHandle,3)
	Set ind = $o(^CacheTemp(repid,ind))
	If ind = "" {				// if there are no more rows, finish fetching
		Set AtEnd = 1
		Set Row = ""
		kill ^CacheTemp(repid)
	}
	Else      {				// fetch row
		Set Row = ^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetMRTransitionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMRTransitionExecute ]
{
	Set repid = $LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc: 收费类型表查询
/// Debug: d ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMetaLCQuery","GetMRChargeType")
Query GetMRChargeType() As %Query(ROWSPEC = "ID:%String,ChargeTypeCode:%String,ChargeTypeName:%String")
{
}

ClassMethod GetMRChargeTypeExecute(ByRef qHandle As %Binary) As %Status
{
	s repid = $I(^CacheTemp)
	s qHandle = $lb(0,repid,0)
	s ind = 1
	
	s rowID = ""
	f {
		s rowID = $o(^DHCEPRFS.META.MRChargeTypeD(rowID))
		q:(rowID = "")
		s objCharge = ##class(DHCEPRFS.META.MRChargeType).%OpenId(rowID)
		s chargeTypeCode = objCharge.ChargeTypeCode
		s chargeTypeName = objCharge.ChargeTypeName
		d objCharge.%Close()
		s ^CacheTemp(repid,ind) = $lb(rowID,chargeTypeCode,chargeTypeName)
		s ind = ind + 1
	}
	
	q $$$OK
}

ClassMethod GetMRChargeTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMRChargeTypeExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
	Set repid = $LIST(qHandle,2)
	Set ind = $LIST(qHandle,3)
	Set ind = $o(^CacheTemp(repid,ind))
	If ind = "" {				// if there are no more rows, finish fetching
		Set AtEnd = 1
		Set Row = ""
		kill ^CacheTemp(repid)
	}
	Else      {				// fetch row
		Set Row = ^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetMRChargeTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMRChargeTypeExecute ]
{
	Set repid = $LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc: 归档方案表查询
/// Debug: d ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMetaLCQuery","GetPrintScheme")
Query GetPrintScheme() As %Query(ROWSPEC = "ID:%String,SchemeName:%String,SchemeDesc:%String,SchemeType:%String,SchemeOrder:%String,SchemeItems:%String,IsDefault:%String,IsCreate:%String,CreateUserID:%String,CreateDate:%String,CreateTime:%String,ModifyUserID:%String,ModifyDate:%String,ModifyTime:%String,CheckItems:%String,IsAvailable:%String")
{
}

ClassMethod GetPrintSchemeExecute(ByRef qHandle As %Binary) As %Status
{
	s repid = $I(^CacheTemp)
	s qHandle = $lb(0,repid,0)
	s ind = 1
	
	s rowID = ""
	f {
		s rowID = $o(^DHCEPRFS.META.PrintSchemeD(rowID))
		q:(rowID = "")
		s objScheme = ##class(DHCEPRFS.META.PrintScheme).%OpenId(rowID)
		s schemeName = objScheme.SchemeName
		s schemeDesc = objScheme.SchemeDesc
		s schemeType = objScheme.SchemeType
		s schemeOrder = objScheme.SchemeOrder
		s schemeItems = objScheme.SchemeItems
		s isDefault = objScheme.IsDefault
		s isCreate = objScheme.IsCreate
		s createUserID = objScheme.CreateUserID
		s createDate = $zd(objScheme.CreateDate,3)
		s createTime = $zt(objScheme.CreateTime)
		s modifyUserID = objScheme.ModifyUserID
		s modifyDate = $zd(objScheme.ModifyDate,3)
		s modifyTime = $zt(objScheme.ModifyTime)
		s checkItems = objScheme.CheckItems
		s isAvailable = objScheme.IsAvailable
		d objScheme.%Close()
		s ^CacheTemp(repid,ind) = $lb(rowID,schemeName,schemeDesc,schemeType,schemeOrder,schemeItems,isDefault,isCreate,createUserID,createDate,createTime,modifyUserID,modifyDate,modifyTime,checkItems,isAvailable)
		s ind = ind + 1
	}
	
	q $$$OK
}

ClassMethod GetPrintSchemeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPrintSchemeExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
	Set repid = $LIST(qHandle,2)
	Set ind = $LIST(qHandle,3)
	Set ind = $o(^CacheTemp(repid,ind))
	If ind = "" {				// if there are no more rows, finish fetching
		Set AtEnd = 1
		Set Row = ""
		kill ^CacheTemp(repid)
	}
	Else      {				// fetch row
		Set Row = ^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetPrintSchemeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPrintSchemeExecute ]
{
	Set repid = $LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc: 打印二维码内容维护表查询
/// Debug: d ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMetaLCQuery","GetQRCodeInfo")
Query GetQRCodeInfo() As %Query(ROWSPEC = "ID:%String,Name:%String,Description:%String,ClassName:%String,ClassProperty:%String,ClassPropertyType:%String,Enable:%String,Sequence:%String,CustemNoteInfo:%String")
{
}

ClassMethod GetQRCodeInfoExecute(ByRef qHandle As %Binary) As %Status
{
	s repid = $I(^CacheTemp)
	s qHandle = $lb(0,repid,0)
	s ind = 1
	
	s rowID = ""
	f {
		s rowID = $o(^DHCEPRFS.META.QRCodeInfoD(rowID))
		q:(rowID = "")
		s objQRCodeInfo = ##class(DHCEPRFS.META.QRCodeInfo).%OpenId(rowID)
		s name = objQRCodeInfo.Name
		s description = objQRCodeInfo.Description
		s className = objQRCodeInfo.ClassName
		s classProperty = objQRCodeInfo.ClassProperty
		s classPropertyType = objQRCodeInfo.ClassPropertyType
		s enable = objQRCodeInfo.Enable
		s sequence = objQRCodeInfo.Sequence
		s custemNoteInfo = objQRCodeInfo.CustemNoteInfo
		d objQRCodeInfo.%Close()
		s ^CacheTemp(repid,ind) = $lb(rowID,name,description,className,classProperty,classPropertyType,enable,sequence,custemNoteInfo)
		s ind = ind + 1
	}
	
	q $$$OK
}

ClassMethod GetQRCodeInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetQRCodeInfoExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
	Set repid = $LIST(qHandle,2)
	Set ind = $LIST(qHandle,3)
	Set ind = $o(^CacheTemp(repid,ind))
	If ind = "" {				// if there are no more rows, finish fetching
		Set AtEnd = 1
		Set Row = ""
		kill ^CacheTemp(repid)
	}
	Else      {				// fetch row
		Set Row = ^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetQRCodeInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetQRCodeInfoExecute ]
{
	Set repid = $LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc: 权限功能表查询
/// Debug: d ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMetaLCQuery","GetQueryFunction")
Query GetQueryFunction() As %Query(ROWSPEC = "ID:%String,FuncName:%String,FuncDesc:%String,ParentID:%String,Notes:%String,IsAvailable:%String")
{
}

ClassMethod GetQueryFunctionExecute(ByRef qHandle As %Binary) As %Status
{
	s repid = $I(^CacheTemp)
	s qHandle = $lb(0,repid,0)
	s ind = 1
	
	s rowID = ""
	f {
		s rowID = $o(^DHCEPRFS.META.QueryFunctionD(rowID))
		q:(rowID = "")
		s objQuery = ##class(DHCEPRFS.META.QueryFunction).%OpenId(rowID)
		s funcName = objQuery.FuncName
		s funcDesc = objQuery.FuncDesc
		s parentID = objQuery.ParentID
		s notes = objQuery.Notes
		s isAvailable = objQuery.IsAvailable
		d objQuery.%Close()
		s ^CacheTemp(repid,ind) = $lb(rowID,funcName,funcDesc,parentID,notes,isAvailable)
		s ind = ind + 1
	}
	
	q $$$OK
}

ClassMethod GetQueryFunctionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetQueryFunctionExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
	Set repid = $LIST(qHandle,2)
	Set ind = $LIST(qHandle,3)
	Set ind = $o(^CacheTemp(repid,ind))
	If ind = "" {				// if there are no more rows, finish fetching
		Set AtEnd = 1
		Set Row = ""
		kill ^CacheTemp(repid)
	}
	Else      {				// fetch row
		Set Row = ^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetQueryFunctionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetQueryFunctionExecute ]
{
	Set repid = $LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc: 计算页数基础项目表查询
/// Debug: d ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMetaLCQuery","GetEstimatePagesItem")
Query GetEstimatePagesItem() As %Query(ROWSPEC = "ID:%String,ItemCode:%String,ItemName:%String,ItemDesc:%String,TypeParam:%String,Type:%String,Available:%String,Sequence:%String,RelatedItems:%String")
{
}

ClassMethod GetEstimatePagesItemExecute(ByRef qHandle As %Binary) As %Status
{
	s repid = $I(^CacheTemp)
	s qHandle = $lb(0,repid,0)
	s ind = 1
	
	s rowID = ""
	f {
		s rowID = $o(^DHCEPRFS.META.EstimatePageD(rowID))
		q:(rowID = "")
		s objItem = ##class(DHCEPRFS.META.EstimatePagesItem).%OpenId(rowID)
		s itemCode = objItem.ItemCode
		s itemName = objItem.ItemName
		s itemDesc = objItem.ItemDesc
		s typeParam = objItem.TypeParam
		s type = objItem.Type
		s available = objItem.Available
		s sequence = objItem.Sequence
		s relatedItems = objItem.RelatedItems
		d objItem.%Close()
		s ^CacheTemp(repid,ind) = $lb(rowID,itemCode,itemName,itemDesc,typeParam,type,available,sequence,relatedItems)
		s ind = ind + 1
	}
	
	q $$$OK
}

ClassMethod GetEstimatePagesItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEstimatePagesItemExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
	Set repid = $LIST(qHandle,2)
	Set ind = $LIST(qHandle,3)
	Set ind = $o(^CacheTemp(repid,ind))
	If ind = "" {				// if there are no more rows, finish fetching
		Set AtEnd = 1
		Set Row = ""
		kill ^CacheTemp(repid)
	}
	Else      {				// fetch row
		Set Row = ^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetEstimatePagesItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEstimatePagesItemExecute ]
{
	Set repid = $LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc: 文件系统分布配置表查询
/// Debug: d ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMetaLCQuery","GetFileStoreConfig")
Query GetFileStoreConfig() As %Query(ROWSPEC = "ID:%String,StartDate:%String,EndDate:%String,FileServerIP:%String,VirtualDir:%String,NameSpace:%String,FileServerUserName:%String,FileServerPassword:%String,FileServerPort:%String,FileServerTimeOut:%String,FTPMethod:%String")
{
}

ClassMethod GetFileStoreConfigExecute(ByRef qHandle As %Binary) As %Status
{
	s repid = $I(^CacheTemp)
	s qHandle = $lb(0,repid,0)
	s ind = 1
	
	s rowID = ""
	f {
		s rowID = $o(^DHCEPRFS.META.FileStoreConfigD(rowID))
		q:(rowID = "")
		s objConfig = ##class(DHCEPRFS.META.FileStoreConfig).%OpenId(rowID)
		s startDate = $zd(objConfig.StartDate,3)
		s endDate = $zd(objConfig.EndDate,3)
		s fileServerIP = objConfig.FileServerIP
		s virtualDir = objConfig.VirtualDir
		s nameSpace = objConfig.NameSpace
		s fileServerUserName = objConfig.FileServerUserName
		s fileServerPassword = objConfig.FileServerPassword
		s fileServerPort = objConfig.FileServerPort
		s fileServerTimeOut = objConfig.FileServerTimeOut
		s ftpMethod = objConfig.FTPMethod
		d objConfig.%Close()
		s ^CacheTemp(repid,ind) = $lb(rowID,startDate,endDate,fileServerIP,virtualDir,nameSpace,fileServerUserName,fileServerPassword,fileServerPort,fileServerTimeOut,ftpMethod)
		s ind = ind + 1
	}
	
	q $$$OK
}

ClassMethod GetFileStoreConfigFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetFileStoreConfigExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
	Set repid = $LIST(qHandle,2)
	Set ind = $LIST(qHandle,3)
	Set ind = $o(^CacheTemp(repid,ind))
	If ind = "" {				// if there are no more rows, finish fetching
		Set AtEnd = 1
		Set Row = ""
		kill ^CacheTemp(repid)
	}
	Else      {				// fetch row
		Set Row = ^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetFileStoreConfigClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetFileStoreConfigExecute ]
{
	Set repid = $LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc: 归档项目生成调用方式表查询
/// Debug: d ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMetaLCQuery","GetCTItemInvokeType")
Query GetCTItemInvokeType() As %Query(ROWSPEC = "ID:%String,InvokeTypeCode:%String,InvokeTypeName:%String")
{
}

ClassMethod GetCTItemInvokeTypeExecute(ByRef qHandle As %Binary) As %Status
{
	s repid = $I(^CacheTemp)
	s qHandle = $lb(0,repid,0)
	s ind = 1
	
	s rowID = ""
	f {
		s rowID = $o(^DHCEPRFS.META.CTItemInvokeD(rowID))
		q:(rowID = "")
		s objType = ##class(DHCEPRFS.META.CTItemInvokeType).%OpenId(rowID)
		s invokeTypeCode = objType.InvokeTypeCode
		s invokeTypeName = objType.InvokeTypeName
		d objType.%Close()
		s ^CacheTemp(repid,ind) = $lb(rowID,invokeTypeCode,invokeTypeName)
		s ind = ind + 1
	}
	
	q $$$OK
}

ClassMethod GetCTItemInvokeTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCTItemInvokeTypeExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
	Set repid = $LIST(qHandle,2)
	Set ind = $LIST(qHandle,3)
	Set ind = $o(^CacheTemp(repid,ind))
	If ind = "" {				// if there are no more rows, finish fetching
		Set AtEnd = 1
		Set Row = ""
		kill ^CacheTemp(repid)
	}
	Else      {				// fetch row
		Set Row = ^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetCTItemInvokeTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCTItemInvokeTypeExecute ]
{
	Set repid = $LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc: 自定义字典表查询
/// Debug: d ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMetaLCQuery","GetCustomDic")
Query GetCustomDic() As %Query(ROWSPEC = "ID:%String,CtmDictCode:%String,CtmDictDesc:%String,CtmDictAlias:%String,CtmDictType:%String,CtmIsActive:%String,CtmIndex:%String")
{
}

ClassMethod GetCustomDicExecute(ByRef qHandle As %Binary) As %Status
{
	s repid = $I(^CacheTemp)
	s qHandle = $lb(0,repid,0)
	s ind = 1
	
	s rowID = ""
	f {
		s rowID = $o(^DHCEPRFS.META.CustomDicD(rowID))
		q:(rowID = "")
		s objDic = ##class(DHCEPRFS.META.CustomDic).%OpenId(rowID)
		s ctmDictCode = objDic.CtmDictCode
		s ctmDictDesc = objDic.CtmDictDesc
		s ctmDictAlias = objDic.CtmDictAlias
		s ctmDictType = objDic.CtmDictType
		s ctmIsActive = objDic.CtmIsActive
		s ctmIndex = objDic.CtmIndex
		d objDic.%Close()
		s ^CacheTemp(repid,ind) = $lb(rowID,ctmDictCode,ctmDictDesc,ctmDictAlias,ctmDictType,ctmIsActive,ctmIndex)
		s ind = ind + 1
	}
	
	q $$$OK
}

ClassMethod GetCustomDicFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCustomDicExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
	Set repid = $LIST(qHandle,2)
	Set ind = $LIST(qHandle,3)
	Set ind = $o(^CacheTemp(repid,ind))
	If ind = "" {				// if there are no more rows, finish fetching
		Set AtEnd = 1
		Set Row = ""
		kill ^CacheTemp(repid)
	}
	Else      {				// fetch row
		Set Row = ^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetCustomDicClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCustomDicExecute ]
{
	Set repid = $LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc: 归档查询字段表查询
/// Debug: d ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMetaLCQuery","GetQueryFields")
Query GetQueryFields() As %Query(ROWSPEC = "ID:%String,FieldName:%String,FieldDesc:%String,FieldType:%String,FieldInterface:%String,CategoryID:%String,Sequence:%String,IsActive:%String")
{
}

ClassMethod GetQueryFieldsExecute(ByRef qHandle As %Binary) As %Status
{
	s repid = $I(^CacheTemp)
	s qHandle = $lb(0,repid,0)
	s ind = 1
	
	s rowID = ""
	f {
		s rowID = $o(^DHCEPRFS.META.QueryFieldsD(rowID))
		q:(rowID = "")
		s objField = ##class(DHCEPRFS.META.QueryFields).%OpenId(rowID)
		s fieldName = objField.FieldName
		s fieldDesc = objField.FieldDesc
		s fieldType = objField.FieldType
		s fieldInterface = objField.FieldInterface
		s categoryID = objField.CategoryID
		s sequence = objField.Sequence
		s isActive = objField.IsActive
		d objField.%Close()
		s ^CacheTemp(repid,ind) = $lb(rowID,fieldName,fieldDesc,fieldType,fieldInterface,categoryID,sequence,isActive)
		s ind = ind + 1
	}
	
	q $$$OK
}

ClassMethod GetQueryFieldsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetQueryFieldsExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
	Set repid = $LIST(qHandle,2)
	Set ind = $LIST(qHandle,3)
	Set ind = $o(^CacheTemp(repid,ind))
	If ind = "" {				// if there are no more rows, finish fetching
		Set AtEnd = 1
		Set Row = ""
		kill ^CacheTemp(repid)
	}
	Else      {				// fetch row
		Set Row = ^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetQueryFieldsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetQueryFieldsExecute ]
{
	Set repid = $LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc: 综合查询结果列表查询
/// Debug: d ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMetaLCQuery","GetResultColumn")
Query GetResultColumn() As %Query(ROWSPEC = "ID:%String,ColDesc:%String,ColName:%String,IsActive:%String,Sequence:%String")
{
}

ClassMethod GetResultColumnExecute(ByRef qHandle As %Binary) As %Status
{
	s repid = $I(^CacheTemp)
	s qHandle = $lb(0,repid,0)
	s ind = 1
	
	s rowID = ""
	f {
		s rowID = $o(^DHCEPRFS.META.ResultColumnD(rowID))
		q:(rowID = "")
		s objCol = ##class(DHCEPRFS.META.ResultColumn).%OpenId(rowID)
		s colDesc = objCol.ColDesc
		s colName = objCol.ColName
		s isActive = objCol.IsActive
		s sequence = objCol.Sequence
		d objCol.%Close()
		s ^CacheTemp(repid,ind) = $lb(rowID,colDesc,colName,isActive,sequence)
		s ind = ind + 1
	}
	
	q $$$OK
}

ClassMethod GetResultColumnFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetResultColumnExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
	Set repid = $LIST(qHandle,2)
	Set ind = $LIST(qHandle,3)
	Set ind = $o(^CacheTemp(repid,ind))
	If ind = "" {				// if there are no more rows, finish fetching
		Set AtEnd = 1
		Set Row = ""
		kill ^CacheTemp(repid)
	}
	Else      {				// fetch row
		Set Row = ^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetResultColumnClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetResultColumnExecute ]
{
	Set repid = $LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc: 迟归生成类型表查询
/// Debug: d ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMetaLCQuery","GetLateToCreate")
Query GetLateToCreate() As %Query(ROWSPEC = "ID:%String,CreateType:%String,Interface:%String,MRItems:%String")
{
}

ClassMethod GetLateToCreateExecute(ByRef qHandle As %Binary) As %Status
{
	s repid = $I(^CacheTemp)
	s qHandle = $lb(0,repid,0)
	s ind = 1
	
	s rowID = ""
	f {
		s rowID = $o(^DHCEPRFS.META.LateToCreateD(rowID))
		q:(rowID = "")
		s obj = ##class(DHCEPRFS.META.LateToCreate).%OpenId(rowID)
		s CreateType = obj.CreateType
		s MRItems = obj.MRItems
		s Interface = obj.Interface
		d obj.%Close()
		s ^CacheTemp(repid,ind) = $lb(rowID,CreateType,Interface,MRItems)
		s ind = ind + 1
	}
	
	q $$$OK
}

ClassMethod GetLateToCreateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLateToCreateExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
	Set repid = $LIST(qHandle,2)
	Set ind = $LIST(qHandle,3)
	Set ind = $o(^CacheTemp(repid,ind))
	If ind = "" {				// if there are no more rows, finish fetching
		Set AtEnd = 1
		Set Row = ""
		kill ^CacheTemp(repid)
	}
	Else      {				// fetch row
		Set Row = ^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetLateToCreateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLateToCreateExecute ]
{
	Set repid = $LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Debug: d ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMetaLCQuery","GetDepartmentFunc")
Query GetDepartmentFunc() As %Query(ROWSPEC = "ID:%String,Name:%String,Code:%String,Description:%String,DepartmentID:%String,Scan:%String,Query:%String,Correlation:%String")
{
}

ClassMethod GetDepartmentFuncExecute(ByRef qHandle As %Binary) As %Status
{
	s repid = $I(^CacheTemp)
	s qHandle = $lb(0,repid,0)
	s ind = 1
	
	s rowID = ""
	f {
		s rowID = $o(^DHCEPRFS.META.DepartmentFuncD(rowID))
		q:(rowID = "")
		s objDepartment = ##class(DHCEPRFS.META.DepartmentFunc).%OpenId(rowID)
		s Name = objDepartment.Name
		s Code = objDepartment.Code
		s Description = objDepartment.Description
		s DepartmentID = objDepartment.DepartmentID
		s Scan = objDepartment.Scan
		s Query = objDepartment.Query
		s Correlation = objDepartment.Correlation
		d objDepartment.%Close()
		s ^CacheTemp(repid,ind) = $lb(rowID,Name,Code,Description,DepartmentID,Scan,Query,Correlation)
		s ind = ind + 1
	}
	
	q $$$OK
}

ClassMethod GetDepartmentFuncFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDepartmentFuncExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
	Set repid = $LIST(qHandle,2)
	Set ind = $LIST(qHandle,3)
	Set ind = $o(^CacheTemp(repid,ind))
	If ind = "" {				// if there are no more rows, finish fetching
		Set AtEnd = 1
		Set Row = ""
		kill ^CacheTemp(repid)
	}
	Else      {				// fetch row
		Set Row = ^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetDepartmentFuncClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDepartmentFuncExecute ]
{
	Set repid = $LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// debug: do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMetaLCQuery","GetCTTaskType")
Query GetCTTaskType() As %SQLQuery
{
	SELECT *
	FROM DHCEPRFS_META.CTTaskType
}

/// debug: do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMetaLCQuery","GetCreateServer")
Query GetCreateServer() As %SQLQuery
{
	SELECT *
	FROM DHCEPRFS_META.CreateServer
}

/// debug: do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMetaLCQuery","GetASType")
Query GetASType() As %SQLQuery
{
	SELECT *
	FROM DHCEPRFS_META.ASType
}

}
