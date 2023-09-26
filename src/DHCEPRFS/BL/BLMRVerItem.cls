Class DHCEPRFS.BL.BLMRVerItem Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// debug: w ##class(DHCEPRFS.BL.BLMRVerItem).MRVerItemIsChecked("152^166","15")
ClassMethod MRVerItemIsChecked(AMRVerItemIDS As %String, ASchemeID As %String) As %String
{
	s ret = ""
	for i=1:1:$l(AMRVerItemIDS,"^")
	{
		s mrVerItemID = $p(AMRVerItemIDS,"^",i)
		s obj = ##class(DHCEPRFS.INST.MRVerItem).%OpenId(mrVerItemID)
		s mrItemID = obj.MRItemID
		s objScheme = ##class(DHCEPRFS.META.PrintScheme).%OpenId(ASchemeID)
		s checkedItems = objScheme.CheckItems
		for j=1:1:$l(checkedItems,"^")
		{
			s checkItemID = $p(checkedItems,"^",j)
			s checkItemID = $p(checkItemID,"#",3)
			if (checkItemID = mrItemID)	
			{
				if (ret = "")
				{
					s ret = mrVerItemID	
				}	
				else
				{
					s ret = ret_"^"_mrVerItemID	
				}
				q
			}
		}
	}
	q ret
}

/// Desc:	注册MRVerItem对象并获取其RowID
/// Debug:	w ##Class(DHCEPRFS.BL.BLMRVerItem).RegMRVerItemID("1","1","7")
ClassMethod RegMRVerItemID(AMRVersionID As %String, AMRItemID As %String, ATotCount As %String, ALogicID As %String = "", ALogicPath As %String = "") As %String
{
	//b "s"
	//处理入参
	s ATotCount = +ATotCount
	
	//获取MRVerItemID
	s mrVerItemID = ..GetMRVerItemID(AMRVersionID, AMRItemID)
	
	//MRVerItem不存在，创建
	if (mrVerItemID = "")
	{
		s mrVerItemID = ..CreateMRVerItem(AMRVersionID, AMRItemID, ATotCount, ALogicID, ALogicPath)
	}
	else
	{
		s sc = ..UpdateMRVerItem(mrVerItemID, ATotCount, ALogicID, ALogicPath)
		if (sc '= "1")
		{
			s mrVerItemID = ""
		}
	}
	
	q mrVerItemID
}

/// Desc:	获取MRVerItemID
ClassMethod GetMRVerItemID(AMRVersionID As %String, AMRItemID As %String) As %String
{
	q:(AMRVersionID="")||(AMRItemID="") ""
	
	s rowID = $O(^DHCEPRFS.INST.MRVerItemI("IdxMain", " "_AMRVersionID, " "_AMRItemID, ""))
	q rowID
}

/// Desc:	创建MRVerItem
ClassMethod CreateMRVerItem(AMRVersionID As %String, AMRItemID As %String, ATotCount As %String, ALogicID As %String = "", ALogicPath As %String = "") As %String
{
	s now = $h
	
	s obj = ##Class(DHCEPRFS.INST.MRVerItem).%New()
	s obj.MRVersionID = AMRVersionID
	s obj.MRItemID = AMRItemID
	s obj.TotCount = ATotCount
	s obj.CreateDate = $p(now, ",", 1)
	s obj.CreateTime = $p(now, ",", 2)
	s obj.ModifyDate = $p(now, ",", 1)
	s obj.ModifyTime = $p(now, ",", 2)
	s uniqueID = $p(ALogicPath,".",1)
	if ($l(uniqueID,"_0-0_") > 1)
	{
		s uniqueID = $p(uniqueID,"_0-0_",1)
	}
	if ($l(uniqueID,"/") > 1)
	{
		s uniqueID = $p(uniqueID,"/",$l(uniqueID,"/"),$l(uniqueID,"/"))
	}
	s obj.FileUniqueID = uniqueID
	
	s status = obj.%Save()
	if ($$$ISOK(status))
	{
		q obj.%Id()
	}
	else
	{
		q ""
	}
}

/// Desc:	创建MRVerItem
ClassMethod UpdateMRVerItem(AMRVerItemID As %String, ATotCount As %String, ALogicID As %String = "", ALogicPath As %String = "") As %String
{
	s now = $h
	
	s obj = ##Class(DHCEPRFS.INST.MRVerItem).%OpenId(AMRVerItemID)
	s obj.TotCount = ATotCount
	s obj.ModifyDate = $p(now, ",", 1)
	s obj.ModifyTime = $p(now, ",", 2)
	s uniqueID = $p(ALogicPath,".",1)
	if ($l(uniqueID,"_0-0_") > 1)
	{
		s uniqueID = $p(uniqueID,"_0-0_",1)
	}
	if ($l(uniqueID,"/") > 1)
	{
		s uniqueID = $p(uniqueID,"/",$l(uniqueID,"/"),$l(uniqueID,"/"))
	}
	s obj.FileUniqueID = uniqueID
	
	s status = obj.%Save()
	if ($$$ISOK(status))
	{
		q "1"
	}
	else
	{
		q "0"
	}
}

/// debug: w ##Class(DHCEPRFS.BL.BLMRVerItem).GetTotalItemDetailCount("75008","1","7")
ClassMethod GetTotalItemDetailCount(AMREpisodeID As %String, AMRVersion As %String) As %String
{
	s AMRVersionID = ##class(DHCEPRFS.BL.BLMRVersion).GetMRVersionID(AMREpisodeID, AMRVersion)
	s count = 0
	s mrItemID = ""
	for {
		s mrItemID = $O(^DHCEPRFS.INST.MRVerItemI("IdxMain", " "_AMRVersionID, mrItemID))
		q:(mrItemID = "")
		
		s mrVerItemID = $O(^DHCEPRFS.INST.MRVerItemI("IdxMain", " "_AMRVersionID, mrItemID, ""))
		continue:(mrVerItemID = "")
		
		s objMRVerItem = ##Class(DHCEPRFS.INST.MRVerItem).%OpenId(mrVerItemID)
		continue:(objMRVerItem = "")
		
		s count = count + objMRVerItem.TotCount
	}
	q count
}

/// debug: w ##Class(DHCEPRFS.BL.BLMRVerItem).GetTotalCountByVerItemIDs("75008","1","7")
ClassMethod GetTotalCountByVerItemIDs(AVerItemIDs As %String) As %String
{
	s count = 0
	for i=1:1:$l(AVerItemIDs,"^")
	{
		s mrVerItemID = $p(AVerItemIDs,"^",i)
		s objMRVerItem = ##Class(DHCEPRFS.INST.MRVerItem).%OpenId(mrVerItemID)
		continue:(objMRVerItem = "")
		
		s count = count + objMRVerItem.TotCount	
	}
	q count
}

/// Desc:自动生成病历总页数 
ClassMethod GetTotalCreateItemCount(AMREpisodeID As %String, AMRVersion As %String) As %String
{
	s AMRVersionID = ##class(DHCEPRFS.BL.BLMRVersion).GetMRVersionID(AMREpisodeID, AMRVersion)
	s count = 0
	s mrItemID = ""
	for {
		s mrItemID = $O(^DHCEPRFS.INST.MRVerItemI("IdxMain", " "_AMRVersionID, mrItemID))
		q:(mrItemID = "")
		s tmpMrItemID = $tr(mrItemID," ","")
		s objMRitem = ##Class(DHCEPRFS.META.MRItem).%OpenId(tmpMrItemID)
		continue:($zcvt(objMRitem.Type,"U") = "PS") 
		s mrVerItemID = $O(^DHCEPRFS.INST.MRVerItemI("IdxMain", " "_AMRVersionID, mrItemID, ""))
		continue:(mrVerItemID = "")
		
		s objMRVerItem = ##Class(DHCEPRFS.INST.MRVerItem).%OpenId(mrVerItemID)
		continue:(objMRVerItem = "")
		
		s count = count + objMRVerItem.TotCount
	}
	q count
}

/// Desc:	获取指定的 DHCEPRFS.MRVerItem.TotCount 属性
ClassMethod GetTotCountByID(AMRVerItemID As %String) As %String
{
	s obj = ##Class(DHCEPRFS.INST.MRVerItem).%OpenId(AMRVerItemID)
	q:(obj = "") "0"
	
	q obj.TotCount
}

/// Desc:	获取指定的MRVerItem病历项目
/// Input:	MRVerItem的ID串，以^分隔
/// Debug: do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMRVerItem","GetMRVerItemsEpisodeByID","1^2^3^4^5^6^7^8^9^10")
Query GetMRVerItemsEpisodeByID(AParam As DHCEPRFS.Entity.EMRVerItem) As %Query(ROWSPEC = "MREpisodeID:%String,MRVerItemID:%String,MRItemName:%String,MRItemCode:%String,MRItemDescription:%String,MRItemType:%String,MRItemMediaType:%String,MRItemTypeParams:%String,MRVersionID:%String,MRItemID:%String,TotCount:%String,CreateDate:%String,CreateTime:%String,ModifyDate:%String,ModifyTime:%String,HasSub:%String,MREpisodeType:%String,AdmDate:%String")
{
}

ClassMethod GetMRVerItemsEpisodeByIDExecute(ByRef qHandle As %Binary, AParam As DHCEPRFS.Entity.EMRVerItem) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	
	s AMRMRVerItemsIDs = AParam.MRVerItemIDS
	s curMREpisodeID = AParam.MREpisodeID
	s:(curMREpisodeID = $c(0)) curMREpisodeID =""
	
	for index=1:1:$l(AMRMRVerItemsIDs,"^")
	{
		s mrVerItemID = $p(AMRMRVerItemsIDs,"^",index)
		
		s objMRVerItem = ##Class(DHCEPRFS.INST.MRVerItem).%OpenId(mrVerItemID)
		continue:(objMRVerItem = "")
		
		s mrVerItemDetailID = ""
		s detailNum = ""
		s detailNum = $O(^DHCEPRFS.INST.MRVerItemDetailI("IdxMain", mrVerItemID, detailNum),-1)
		s mrVerItemDetailID = $O(^DHCEPRFS.INST.MRVerItemDetailI("IdxMain", mrVerItemID, detailNum, mrVerItemDetailID))
		continue:(mrVerItemDetailID = "")
		s objMRVerItemDetail = ##class(DHCEPRFS.INST.MRVerItemDetail).%OpenId(mrVerItemID_"||"_mrVerItemDetailID)
		s deleteFlag = objMRVerItemDetail.DeleteFlag
		continue:(deleteFlag = "Y")
		
		s MRVersionID = objMRVerItem.MRVersionID
		s MRItemID = objMRVerItem.MRItemID
		s MRVerItemID = mrVerItemID
		s TotCount = objMRVerItem.TotCount
		s CreateDate = $zd(objMRVerItem.CreateDate,3)
		s CreateTime = $zt(objMRVerItem.CreateTime,1)
		s ModifyDate = $zd(objMRVerItem.ModifyDate,3)
		s ModifyTime = $zt(objMRVerItem.ModifyTime,1)
		
		s MRItemEntity = ##class(DHCEPRFS.BL.BLMRItem).GetItemByID(MRItemID)
		s MRItemName = MRItemEntity.Name
		s MRItemCode = MRItemEntity.Code
		s MRItemDescription = MRItemEntity.Description
		s MRItemType = MRItemEntity.Type
		s MRItemTypeParams = MRItemEntity.TypeParams
		s MRItemMediaType = MRItemEntity.MediaType
		
		s objMRVersion = ##Class(DHCEPRFS.INST.MRVersion).%OpenId(MRVersionID)
		s MREpisodeID = objMRVersion.MREpisodeID
		s MREpisodeType = "Episode"
		if (MREpisodeID '= "")&&(MREpisodeID '= curMREpisodeID)
		{
			s MREpisodeType = ##class(DHCEPRFS.BL.BLMREpisodeRelate).GetRelatedType(curMREpisodeID,MREpisodeID)
		}
		elseif (MREpisodeID = "")
		{
			s MREpisodeID = curMREpisodeID
			s MREpisodeType = "Episode"
		}
		
		s HasSub = "0"
		s Remark1 = $o(^DHCEPRFS.INST.MRVerSubItemI("IdxMRVerItemID"," "_mrVerItemID,""))
		if (Remark1 '= "")
		{
			s HasSub = "1"
		}
		
		s obj = ##class(DHCEPRFS.INST.MREpisode).%OpenId(MREpisodeID)
		s admDate = obj.AdmDate
		s:(admDate '="") admDate=$zd(admDate,3)
		
		s ^CacheTemp(repid,ind) = $lb(MREpisodeID,MRVerItemID,MRItemName,MRItemCode,MRItemDescription,MRItemType,MRItemMediaType,MRItemTypeParams,MRVersionID,MRItemID,TotCount,CreateDate,CreateTime,ModifyDate,ModifyTime,HasSub,MREpisodeType,admDate)
		s ind=ind+1 
	}
	
	Quit $$$OK
}

ClassMethod GetMRVerItemsEpisodeByIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMRVerItemsEpisodeByIDExecute ]
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

ClassMethod GetMRVerItemsEpisodeByIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMRVerItemsEpisodeByIDExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc:	获取指定的MRVerItem病历项目
/// Input:	MRVerItem的ID串，以^分隔
/// Debug: do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMRVerItem","GetMRVerItemsByID","1^2^3^4^5^6^7^8^9^10")
Query GetMRVerItemsByID(AMRMRVerItemsIDs As %String) As %Query(ROWSPEC = "MREpisodeID:%String,MRVerItemID:%String,MRItemName:%String,MRItemCode:%String,MRItemDescription:%String,MRItemType:%String,MRItemTypeParams:%String,MRVersionID:%String,MRItemID:%String,TotCount:%String,CreateDate:%String,CreateTime:%String,ModifyDate:%String,ModifyTime:%String")
{
}

ClassMethod GetMRVerItemsByIDExecute(ByRef qHandle As %Binary, AMRMRVerItemsIDs As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1

	for index=1:1:$l(AMRMRVerItemsIDs,"^")
	{
		s mrVerItemID = $p(AMRMRVerItemsIDs,"^",index)
		
		s objMRVerItem = ##Class(DHCEPRFS.INST.MRVerItem).%OpenId(mrVerItemID)
		continue:(objMRVerItem = "")
		
		s MRVersionID = objMRVerItem.MRVersionID
		
		s objMRVersion = ##class(DHCEPRFS.INST.MRVersion).%OpenId(MRVersionID)
		s MREpisodeID = objMRVersion.MREpisodeID
		
		s MRItemID = objMRVerItem.MRItemID
		s MRVerItemID = mrVerItemID
		s TotCount = objMRVerItem.TotCount
		s CreateDate = $zd( objMRVerItem.CreateDate,3)
		s CreateTime = $zt( objMRVerItem.CreateTime,1)
		s ModifyDate = $zd( objMRVerItem.ModifyDate,3)
		s ModifyTime = $zt( objMRVerItem.ModifyTime,1)
		
		s MRItemEntity = ##class(DHCEPRFS.BL.BLMRItem).GetItemByID(MRItemID)
		s MRItemName = MRItemEntity.Name
		s MRItemCode = MRItemEntity.Code
		s MRItemDescription = MRItemEntity.Description
		s MRItemType = MRItemEntity.Type
		s MRItemTypeParams = MRItemEntity.TypeParams
	
		s ^CacheTemp(repid,ind) = $lb(MREpisodeID,MRVerItemID,MRItemName,MRItemCode,MRItemDescription,MRItemType,MRItemTypeParams,MRVersionID,MRItemID,TotCount,CreateDate,CreateTime,ModifyDate,ModifyTime)
		s ind=ind+1 
	}
	
	Quit $$$OK
}

ClassMethod GetMRVerItemsByIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMRVerItemsByIDExecute ]
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

ClassMethod GetMRVerItemsByIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMRVerItemsByIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc:	获取指定的MRVerItem病历项目
/// Input:	MRVerItem的ID串，以^分隔
/// Debug: w ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMRVerItem","GetMRVerItemsInfoByID","27^28^29^30")
Query GetMRVerItemsInfoByID(AMRMRVerItemsIDs As %String) As %Query(ROWSPEC = "MRVerItemID:%String,TotCount:%String,DateFlag:%String,TimeFlag:%String,MRVerItemDesc:%String,MRItemTypeParams:%String,MRCategoryID:%String,MRCategoryDesc:%String")
{
}

ClassMethod GetMRVerItemsInfoByIDExecute(ByRef qHandle As %Binary, AMRMRVerItemsIDs As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1

	for index=1:1:$l(AMRMRVerItemsIDs,"^")
	{
		s mrVerItemID = $p(AMRMRVerItemsIDs,"^",index)
		
		s objMRVerItem = ##Class(DHCEPRFS.INST.MRVerItem).%OpenId(mrVerItemID)
		continue:(objMRVerItem = "")
		
		s mrVerItemDetailID =""
		s detailNum = ""
		s detailNum = $O(^DHCEPRFS.INST.MRVerItemDetailI("IdxMain", mrVerItemID, detailNum),-1)
		s mrVerItemDetailID = $O(^DHCEPRFS.INST.MRVerItemDetailI("IdxMain", mrVerItemID, detailNum, mrVerItemDetailID))
		continue:(mrVerItemDetailID = "")
		s objMRVerItemDetail = ##class(DHCEPRFS.INST.MRVerItemDetail).%OpenId(mrVerItemID_"||"_mrVerItemDetailID)
		s deleteFlag = objMRVerItemDetail.DeleteFlag
		continue:(deleteFlag = "Y")
		
		
		
		s MRItemID = objMRVerItem.MRItemID
		s MRVerItemID = mrVerItemID
		s TotCount = objMRVerItem.TotCount
		s DateFlag = $zd( objMRVerItem.DateFlag,3)
		s TimeFlag = $zt( objMRVerItem.TimeFlag,1)
		
		s MRItemEntity = ##class(DHCEPRFS.BL.BLMRItem).GetItemByID(MRItemID)

		s MRVerItemDesc = MRItemEntity.Description
		s MRItemTypeParams = MRItemEntity.TypeParams
		s MRSubCategoryID = MRItemEntity.MRSubCategoryID
		s objMRSubCategory = ##class(DHCEPRFS.META.MRSubCategory).%OpenId(MRSubCategoryID)
		s MRCategoryID = objMRSubCategory.MRCategoryID
		s objMRCategory = ##class(DHCEPRFS.META.MRCategory).%OpenId(MRCategoryID)
		s MRCategoryDesc = objMRCategory.Description
		
	
		s ^CacheTemp(repid,ind) = $lb(MRVerItemID,TotCount,DateFlag,TimeFlag,MRVerItemDesc,MRItemTypeParams,MRCategoryID,MRCategoryDesc)
		s ind=ind+1 
	}
	
	Quit $$$OK
}

ClassMethod GetMRVerItemsInfoByIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMRVerItemsInfoByIDExecute ]
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

ClassMethod GetMRVerItemsInfoByIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMRVerItemsInfoByIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc:	获取指定MRVersionID的病历项目的ID
/// Debug: w ##class(DHCEPRFS.BL.BLMRVerItem).GetAllByVersionString("1")
ClassMethod GetAllByVersionString(AMRVersionID As %String, ACorrelation As %String = "N") As %String
{
	s ret = ""
	s mrItemID = ""
	for {
		s mrItemID = $O(^DHCEPRFS.INST.MRVerItemI("IdxMain", " "_AMRVersionID, mrItemID))
		q:(mrItemID = "")
				
		s mrVerItemID = $O(^DHCEPRFS.INST.MRVerItemI("IdxMain", " "_AMRVersionID, mrItemID, ""))
		
		//对这个就诊的项目做筛选，如果此项目作废就跳过，deleteFlag="Y"--作废
		s deleteFlag =""
		if (mrVerItemID '= "")
		{
			s objMRVerItem = ##class(DHCEPRFS.INST.MRVerItem).%OpenId(mrVerItemID)
			s deleteFlag = objMRVerItem.DeleteFlag
		}
		continue:(deleteFlag = "Y")
		
		//处理有VerItem但无VerItemDetail的项目，例如平台生成的项目
		if (mrVerItemID '= "")  //MRVerItemID 不为空 并且 没有 MRVerItemDetail
		{
			s detailNum = ""
            s detailNum = $o(^DHCEPRFS.INST.MRVerItemDetailI("IdxMain",mrVerItemID,detailNum),-1)
            continue:(detailNum = "")
		}
		
		if (ACorrelation = "N")
		{
			continue:(mrVerItemID = "")

		}
		else
		{
			if (mrVerItemID = "")
			{
				//此项目不存在
				//判断此项目是否需替换，若需替换则替换为相应的项目	
				s MRItemID = $tr(mrItemID," ","")
				s mrVerItemID = ##class(DHCEPRFS.BL.BLPrintItemCorrelation).ReplaceCorrelation(AMRVersionID,MRItemID)
				//要替换项目也没有
				continue:(mrVerItemID = "")	
			}
		}
		
		if (ret = "")
		{
			s ret = mrVerItemID	
		}
		else 
		{
			s ret = ret_"^"_mrVerItemID	
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
				if (retDone ="")
				{
					//没有重复的
					s retDone = current
				}
				else
				{
					//没有重复的
					s retDone = current_"^"_retDone
				}	
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

/// Desc:	根据EpisodeID和ItemID获取VerItemID
/// Debug: w ##class(DHCEPRFS.BL.BLMRVerItem).GetVerItemByItemIDAndEpisodeID("330","2")
ClassMethod GetVerItemByItemIDAndEpisodeID(AEpisodeID As %String, AItemID As %String) As %String
{
	//b "s"
	s mrEpisodeID = ##class(DHCEPRFS.BL.BLMREpisode).GetMREpisodeIDByAdm(AEpisodeID,"DHC")
	s mrVersionID = ##class(DHCEPRFS.BL.BLMRVersion).GetMRVersionID(mrEpisodeID)
	s mrVerItemID = $O(^DHCEPRFS.INST.MRVerItemI("IdxMain", " "_mrVersionID, " "_AItemID, ""))
	q mrVerItemID
}

/// Desc:	根据EpisodeID和ItemID获取VerItemID
/// Debug: w ##class(DHCEPRFS.BL.BLMRVerItem).GetVerItemByItemIDAndEpisodeID("1")
ClassMethod GetVerItemByItemIDAndMRAdmID(AMRID As %String, AItemID As %String, AVersionCode As %String = "", AType As %String = "") As %String
{
	s Version = "0"
	if (AVersionCode '= "")
	{
		s Version = $o(^DHCEPRFS.META.VersionCodeI("IdxVersion"," "_AVersionCode,""))
		s Version = $TR(Version," ","")
	}
	s mrVersionID = ##class(DHCEPRFS.BL.BLMRVersion).GetMRVersionID(AMRID,Version,AType)
	s mrVerItemID = $O(^DHCEPRFS.INST.MRVerItemI("IdxMain", " "_mrVersionID, " "_AItemID, ""))
	q mrVerItemID
}

/// Desc:	获取指定MRVersionID的病历项目
/// Debug: do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMRVerItem","GetAllByMRVersion","1")
Query GetAllByMRVersion(AMRVersionID As %String) As %Query(ROWSPEC = "MRVerItemID:%String,MRItemName:%String,MRItemCode:%String,MRItemDescription:%String,MRItemType:%String,MRItemTypeParams:%String,MRVersionID:%String,MRItemID:%String,TotCount:%String,CreateDate:%String,CreateTime:%String,ModifyDate:%String,ModifyTime:%String")
{
}

ClassMethod GetAllByMRVersionExecute(ByRef qHandle As %Binary, AMRVersionID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	
	s mrItemID = ""
	for {
		s mrItemID = $O(^DHCEPRFS.INST.MRVerItemI("IdxMain", " "_AMRVersionID, mrItemID))
		q:(mrItemID = "")
		
		s mrVerItemID = $O(^DHCEPRFS.INST.MRVerItemI("IdxMain", " "_AMRVersionID, mrItemID, ""))
		continue:(mrVerItemID = "")
		
		s objMRVerItem = ##Class(DHCEPRFS.INST.MRVerItem).%OpenId(mrVerItemID)
		continue:(objMRVerItem = "")
		
		s MRVersionID = AMRVersionID
		s MRItemID = objMRVerItem.MRItemID
		s MRVerItemID = mrVerItemID
		s TotCount = objMRVerItem.TotCount
		s CreateDate = $zd(objMRVerItem.CreateDate,3)
		s CreateTime = $zt(objMRVerItem.CreateTime,1)
		s ModifyDate = $zd(objMRVerItem.ModifyDate,3)
		s ModifyTime = $zt(objMRVerItem.ModifyTime,1)
		
		s MRItemEntity = ##class(DHCEPRFS.BL.BLMRItem).GetItemByID(MRItemID)
		s MRItemName = MRItemEntity.Name
		s MRItemCode = MRItemEntity.Code
		s MRItemDescription = MRItemEntity.Description
		s MRItemType = MRItemEntity.Type
		s MRItemTypeParams = MRItemEntity.TypeParams
		
		s ^CacheTemp(repid,ind) = $lb(MRVerItemID,MRItemName,MRItemCode,MRItemDescription,MRItemType,MRItemTypeParams,MRVersionID,MRItemID,TotCount,CreateDate,CreateTime,ModifyDate,ModifyTime)
		s ind=ind+1 
	}
	
	Quit $$$OK
}

ClassMethod GetAllByMRVersionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllByMRVersionExecute ]
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

ClassMethod GetAllByMRVersionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllByMRVersionExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc:根据目录类型获取指定MRVersionID的病历项目
/// Creator:Candyxu 
/// Createdate:2013-06-17
/// Input:AMREpisdoeID 归档就诊号,AVersion,版本,AType 目录类型
/// outPut:
/// Debug: do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMRVerItem","GetItemByType","20","0","PS","1","","159")
Query GetItemByType(AMRID As %String, AVersion As %String, AType As %String, ANeedLocPath As %String = "0", AIDType As %String = "", AUserID As %String = "") As %Query(ROWSPEC = "MRItemID:%String,MRItemName:%String,MRItemCode:%String,MRItemDescription:%String,MRItemType:%String,MRItemTypeParams:%String,MRVersionID:%String,MRVerItemID:%String,DetailNum:%String,FileMasterID:%String,FileMasterPath:%String,FileLocPath:%String")
{
}

ClassMethod GetItemByTypeExecute(ByRef qHandle As %Binary, AMRID As %String, AVersion As %String, AType As %String, ANeedLocPath As %String = "0", AIDType As %String = "", AUserID As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
    
    s MRVersionID = ##Class(DHCEPRFS.BL.BLMRVersion).GetMRVersionID(AMRID, AVersion, AIDType)
    
	s mrTypeParam = ""	
	for {
		//b "s"
		s mrTypeParam = $O(^DHCEPRFS.META.MRItemI("IdxType", " "_$ZCVT(AType,"U"), mrTypeParam))
		q:(mrTypeParam = "")
		
		s MRItemID = $O(^DHCEPRFS.META.MRItemI("IdxType", " "_$ZCVT(AType,"U"), mrTypeParam,""))
		
		//扫描未分类应该始终显示
		s ret1 = ##class(DHCEPRFS.BL.BLMRItem).IsScanUnArrange(MRItemID)
		if (ret1 = "0")
		{
			//获取此用户的角色的权限，对应的方案中是否有次MRItem，没有则continue
			s ret = ##class(DHCEPRFS.BL.BLMRItem).CheckMRItemBelong(MRItemID,AUserID)
			continue:(ret = "0")
		}
		
		s MRItemEntity = ##class(DHCEPRFS.BL.BLMRItem).GetItemByID(MRItemID)
		s MRItemName = MRItemEntity.Name
		s MRItemCode = MRItemEntity.Code
		s MRItemDescription = MRItemEntity.Description
		s MRItemType = MRItemEntity.Type
		s MRItemTypeParams = MRItemEntity.TypeParams
		
		s mrVerItemID = $O(^DHCEPRFS.INST.MRVerItemI("IdxMain", " "_MRVersionID, " "_MRItemID, ""))
        continue:(mrVerItemID="")
        
        s mrVerItemDetailID = ""
        //是否有合并版本
        s mrVerItemDetailID = $O(^DHCEPRFS.INST.MRVerItemDetailI("IdxMain", mrVerItemID, "-1", mrVerItemDetailID))
        if (mrVerItemDetailID = "")
        {
			//取最高版本
			s detailNum = ""
			s detailNum = $O(^DHCEPRFS.INST.MRVerItemDetailI("IdxMain", mrVerItemID, detailNum),-1)
	
			s mrVerItemDetailID = $O(^DHCEPRFS.INST.MRVerItemDetailI("IdxMain", mrVerItemID, detailNum, mrVerItemDetailID))
        }
		continue:(mrVerItemDetailID = "")
		
		s mrVerItemDetailID = mrVerItemID_"||"_mrVerItemDetailID
		s objMRVerItemDetail = ##Class(DHCEPRFS.INST.MRVerItemDetail).%OpenId(mrVerItemDetailID)
		continue:(objMRVerItemDetail = "")
		
		s DetailNum = "0"  
		s FileMasterID = objMRVerItemDetail.FileMasterID
		s FileMasterPath = objMRVerItemDetail.FileMasterPath
		if (ANeedLocPath = "1")
		{	
			s FileLocPath = ##Class(DHCEPRFS.BL.BLFileMaster).GetFullFileLocName(FileMasterID)
		}
		else
		{
			s FileLocPath = ""
		}
		
		s ^CacheTemp(repid,ind) = $lb(MRItemID,MRItemName,MRItemCode,MRItemDescription,MRItemType,MRItemTypeParams,MRVersionID,mrVerItemID,DetailNum,FileMasterID,FileMasterPath,FileLocPath)
		s ind=ind+1
	}
	Quit $$$OK
}

ClassMethod GetItemByTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetItemByTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetItemByTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetItemByTypeExecute ]
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

/// Desc:根据MRItemCode和MREpisodeID获取指定MRVerItem的信息
/// Input:AMREpisdoeID 归档就诊号,AVersion 版本,AMRItemCode 归档项目Code
/// outPut:
/// Debug: do ##class(DHCEPRFS.BL.BLMRVerItem).GetMrVerItemByMRItemCode("1","0","PS","1")
ClassMethod GetMrVerItemByMRItemCode(AMREpisdoeID As %String, AVersion As %String, AMRItemCode As %String, ADetailNum As %String) As %String
{
   
	s MRItemID = ##class(DHCEPRFS.BL.BLMRItem).GetItemIDByCode(AMRItemCode)
	s MRVerItemID = ..GetVerItemByItemIDAndMRAdmID(AMREpisdoeID,MRItemID)
	q:(MRVerItemID = "") "-1"
	
	//若为空取最高版本
	s:(ADetailNum = $c(0)) ADetailNum = ""
	s detailNum = ""
	if (ADetailNum = "")
	{
		s detailNum = $O(^DHCEPRFS.INST.MRVerItemDetailI("IdxMain", MRVerItemID, detailNum),-1)
	}
	else
	{
		s detailNum = +ADetailNum
	}
	
	s MRVerItemDetailID = ""
	s MRVerItemDetailID = $O(^DHCEPRFS.INST.MRVerItemDetailI("IdxMain", MRVerItemID, detailNum, MRVerItemDetailID))
	q:(MRVerItemDetailID = "") "-1"
	
	s MRVerItemDetailID = MRVerItemID_"||"_MRVerItemDetailID
	s objMRVerItemDetail = ##Class(DHCEPRFS.INST.MRVerItemDetail).%OpenId(MRVerItemDetailID)
	q:(objMRVerItemDetail = "") "-1"
	
	s FileMasterID = objMRVerItemDetail.FileMasterID
	s FileMasterPath = objMRVerItemDetail.FileMasterPath
	s FileLocPath = ##Class(DHCEPRFS.BL.BLFileMaster).GetFullFileLocName(FileMasterID)

	q FileMasterID_"^"_FileMasterPath_"^"_FileLocPath_"^"_MRItemID_"^"_MRVerItemID_"^"_MRVerItemDetailID
}

/// Desc:	删除MRVerItem
ClassMethod DeleteMRVerItemByMrEpisodeID(AMrEpisodeID As %String, AMRItemID As %String) As %String
{
	
	s mrVerionID = ##class(DHCEPRFS.BL.BLMRVersion).GetMRVersionID(AMrEpisodeID)
	
	//获取MRVerItemID
	s mrVerItemID = ..GetMRVerItemID(mrVerionID, AMRItemID)
	q:(mrVerItemID="") "-1"
	
	//删除MRVerItem
	s sc = ##Class(DHCEPRFS.INST.MRVerItem).%DeleteId(mrVerItemID)
	if ($$$ISOK(sc))
	{
		q "1"
	}
	else
	{
		q "0"
	}
}

/// Desc:	删除MRVerItem
ClassMethod DeleteMRVerItem(AMRVersionID As %String, AMRItemID As %String) As %String
{
	//获取MRVerItemID
	s mrVerItemID = ..GetMRVerItemID(AMRVersionID, AMRItemID)
	q:(mrVerItemID="") "-1"
	
	//删除MRVerItem
	s sc = ##Class(DHCEPRFS.INST.MRVerItem).%DeleteId(mrVerItemID)
	if ($$$ISOK(sc))
	{
		q "1"
	}
	else
	{
		q "0"
	}
}

ClassMethod DeleteByID(AMRVerItemID As %String) As %String
{
	q:(AMRVerItemID = "") "0"
	
	//删除MRVerItem
	s sc = ##Class(DHCEPRFS.INST.MRVerItem).%DeleteId(AMRVerItemID)
	if ($$$ISOK(sc))
	{
		q "1"
	}
	else
	{
		q "0"
	}
}

ClassMethod DeleteMRVerItemByEpisodeAndType(AEpisodeID As %String, AType As %String, ATypeParam As %String) As %String
{
	s mrEpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxSysCodeAndEpisodeID", " DHC", " "_AEpisodeID, ""))
	q:(mrEpisodeID = "") "0"	
	
	s versionID = $o(^DHCEPRFS.INST.MRVersionI("IdxMain", " "_mrEpisodeID, "0", ""))
	q:(versionID = "") "0"
	
	s mrItemID = $o(^DHCEPRFS.META.MRItemI("IdxType"," "_AType, " "_ATypeParam, ""))
	q:(mrItemID = "") "0"
	
	s mrVerItemID = $o(^DHCEPRFS.INST.MRVerItemI("IdxMain"," "_versionID, " "_mrItemID, ""))
	q:(mrVerItemID = "") "0"
	
	s sc = ##class(DHCEPRFS.INST.MRVerItem).%DeleteId(mrVerItemID)
	if ($$$ISOK(sc))
	{
		q "1"	
	}
	else
	{
		q "-1"	
	}
}

/// Desc:		获取指定扫描归档项目关联的自动生成归档项目，
/// 			比如入院记录签字扫描项目 关联 入院记录通用、入院记录儿科等
/// Creator:	houjian 
/// Createdate:	2013-06-17
/// Input:		AMRVersionID 归档版本ID,
/// 			AItemID 扫描归档项目ID
/// outPut:
/// Debug: 		do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMRVerItem","GetReleatedVerItem","1","12")
Query GetReleatedVerItem(AMRVersionID As %String, AItemID As %String) As %Query(ROWSPEC = "MRItemID:%String,MRItemName:%String,MRItemCode:%String,MRItemDescription:%String,MRItemType:%String,MRItemTypeParams:%String,MRVersionID:%String,MRVerItemID:%String,DetailNum:%String,FileMasterID:%String,FileMasterPath:%String,FileLocPath:%String")
{
}

ClassMethod GetReleatedVerItemExecute(ByRef qHandle As %Binary, AMRVersionID As %String, AItemID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
    
    //s ^CacheTempDHCEPRDebug("houj")=AMRVersionID_"^"_AItemID
    s releatedType = "SCAN"
    s releatedItemIDs = ##class(DHCEPRFS.BL.BLItemCorrelation).GetReleatedItemID(releatedType,AItemID)
	s releatedItemCount = $L(releatedItemIDs, "^")	
	for i = 1:1:releatedItemCount
	{	
		s MRItemID = $P(releatedItemIDs, "^", i)
		continue:(MRItemID = "")
		
		s MRItemEntity = ##class(DHCEPRFS.BL.BLMRItem).GetItemByID(MRItemID)
		s MRItemName = MRItemEntity.Name
		s MRItemCode = MRItemEntity.Code
		s MRItemDescription = MRItemEntity.Description
		s MRItemType = MRItemEntity.Type
		s MRItemTypeParams = MRItemEntity.TypeParams
		
		s mrVerItemID = $O(^DHCEPRFS.INST.MRVerItemI("IdxMain", " "_AMRVersionID, " "_MRItemID, ""))
        continue:(mrVerItemID = "")
        
        s mrVerItemDetailID = ""
        //是否有合并版本
        s mrVerItemDetailID = $O(^DHCEPRFS.INST.MRVerItemDetailI("IdxMain", mrVerItemID, "-1", mrVerItemDetailID))
        if (mrVerItemDetailID = "")
        {
			//取最高版本
			s detailNum = ""
			s detailNum = $O(^DHCEPRFS.INST.MRVerItemDetailI("IdxMain", mrVerItemID, detailNum),-1)
	
			s mrVerItemDetailID = $O(^DHCEPRFS.INST.MRVerItemDetailI("IdxMain", mrVerItemID, detailNum, mrVerItemDetailID))
        }
		continue:(mrVerItemDetailID = "")
			
		s mrVerItemDetailID = mrVerItemID_"||"_mrVerItemDetailID
		s objMRVerItemDetail = ##Class(DHCEPRFS.INST.MRVerItemDetail).%OpenId(mrVerItemDetailID)
		continue:(objMRVerItemDetail = "")
			
		s DetailNum = objMRVerItemDetail.DetailNum
		s FileMasterID = objMRVerItemDetail.FileMasterID
		s FileMasterPath = objMRVerItemDetail.FileMasterPath
		s FileLocPath = ##Class(DHCEPRFS.BL.BLFileMaster).GetFullFileLocName(FileMasterID)
		
        
        s ^CacheTemp(repid,ind) = $lb(MRItemID,MRItemName,MRItemCode,MRItemDescription,MRItemType,MRItemTypeParams,MRVersionID,mrVerItemID,DetailNum,FileMasterID,FileMasterPath,FileLocPath)
		s ind=ind+1
	}
	Quit $$$OK
}

ClassMethod GetReleatedVerItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetReleatedVerItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetReleatedVerItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetReleatedVerItemExecute ]
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

/// Desc:		获取指定扫描归档项目关联的自动生成归档项目，
/// 			比如入院记录签字扫描项目 关联 入院记录通用、入院记录儿科等
/// Creator:	houjian 
/// Createdate:	2013-06-17
/// Input:		AMRVersionID 归档版本ID,
/// 			AItemID 扫描归档项目ID
/// outPut:
/// Debug: 		do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMRVerItem","GetRedundantVerItem","1","",)
Query GetRedundantVerItem(AMRVersionID As %String, ACorrectItemIDList As %String, ASchemeID As %String) As %Query(ROWSPEC = "MRItemID:%String,MRItemName:%String,MRItemCode:%String,MRItemDescription:%String,MRItemType:%String,MRItemTypeParams:%String,MRVersionID:%String,MRVerItemID:%String,DetailNum:%String,FileMasterID:%String,FileMasterPath:%String,FileLocPath:%String")
{
}

ClassMethod GetRedundantVerItemExecute(ByRef qHandle As %Binary, AMRVersionID As %String, ACorrectItemIDList As %String, ASchemeID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
    
    s schemeItems = ##Class(DHCEPRFS.BL.BLPrintScheme).GetSchemeItems(ASchemeID)
    q:(schemeItems="") $$$OK
    
    
    s curMrItemID = ""
   	for {	
		s curMrItemID = $O(^DHCEPRFS.INST.MRVerItemI("IdxMain", " "_AMRVersionID, curMrItemID))
        q:(curMrItemID = "")
        
        //b "s"
        s MRItemID = $e(curMrItemID,2,$L(curMrItemID))
        
        //归档项目在本次归档生成中已经成功生成，不是冗余项目，无需删除
        s isInclude = $$IsIncludedIn(MRItemID, ACorrectItemIDList)
        continue:(isInclude = "1")
        
        // 归档项目不在本次归档Scheme中，不需要对其做数据处理，无需删除
        s isInclude = $$IsIncludedIn(MRItemID, schemeItems)
        continue:(isInclude = "0")
        
        s MRItemEntity = ##class(DHCEPRFS.BL.BLMRItem).GetItemByID(MRItemID)
		s MRItemName = MRItemEntity.Name
		s MRItemCode = MRItemEntity.Code
		s MRItemDescription = MRItemEntity.Description
		s MRItemType = MRItemEntity.Type
		s MRItemTypeParams = MRItemEntity.TypeParams
        s isGen = $$IsGenType(MRItemType)
        continue:(isGen = "0")
        
		s mrVerItemID = $O(^DHCEPRFS.INST.MRVerItemI("IdxMain", " "_AMRVersionID, curMrItemID, ""))
        continue:(mrVerItemID = "")
        
        
        s curDetailNum = ""
        for {
	        s curDetailNum = $O(^DHCEPRFS.INST.MRVerItemDetailI("IdxMain", mrVerItemID, curDetailNum))
			q:(curDetailNum = "")
			        
        	s childSub = $O(^DHCEPRFS.INST.MRVerItemDetailI("IdxMain", mrVerItemID, curDetailNum, ""))
        	continue:(childSub = "")
			
			s mrVerItemDetailID = mrVerItemID_"||"_childSub
			s objMRVerItemDetail = ##Class(DHCEPRFS.INST.MRVerItemDetail).%OpenId(mrVerItemDetailID)
			continue:(objMRVerItemDetail = "")
			
			s DetailNum = objMRVerItemDetail.DetailNum
			s FileMasterID = objMRVerItemDetail.FileMasterID
			s FileMasterPath = objMRVerItemDetail.FileMasterPath
			s FileLocPath = ##Class(DHCEPRFS.BL.BLFileMaster).GetFullFileLocName(FileMasterID)
			s MRVersionID = AMRVersionID
        	s ^CacheTemp(repid,ind) = $lb(MRItemID,MRItemName,MRItemCode,MRItemDescription,MRItemType,MRItemTypeParams,MRVersionID,mrVerItemID,DetailNum,FileMasterID,FileMasterPath,FileLocPath)
			s ind=ind+1
        }
	}
	Quit $$$OK
	
IsIncludedIn(MRItemID, ALLItemIDList)
	s ret = "0"
	s count = $L(ALLItemIDList,"^")
	for k = 1:1:count
	{
		if ($p(ALLItemIDList,"^",k)=MRItemID)
		{	
			s ret = "1"
			quit
		}
	}
	q ret
	
IsGenType(type)
	q:(type="PS") "0"
	q "1"
}

ClassMethod GetRedundantVerItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRedundantVerItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetRedundantVerItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRedundantVerItemExecute ]
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

/// Desc:	批量删除指定项目
ClassMethod DeleteItemList(AMRID As %String, AVersionCode As %String, AMRItemIDList As %String, AType As %String = "") As %String
{
	q:(AMRItemIDList="") "1"
	
	s versionNum = ##Class(DHCEPRFS.BL.BLVersionCodeMapping).GetVersionByCode(AVersionCode)
	
	s mrVersionID = ##Class(DHCEPRFS.BL.BLMRVersion).GetMRVersionID(AMRID,versionNum,AType)
	q:(mrVersionID="") "1"
	
	s count = $L(AMRItemIDList,"^")
	for i = 1:1:count
	{
		s mrItemID = $P(AMRItemIDList,"^",i)
		continue:(mrItemID="")
		
		s mrVerItemID = ..GetMRVerItemID(mrVersionID,mrItemID)
		continue:(mrVerItemID="")
		
		//删除MRVerItem
		s sc = ##Class(DHCEPRFS.INST.MRVerItem).%DeleteId(mrVerItemID)
	}
	
	q "1"
}

ClassMethod GetMRItemIDByVerItemID(AMRVerItemID As %String) As %String
{
	q:(AMRVerItemID = "") "-1"
	s obj = ##class(DHCEPRFS.INST.MRVerItem).%OpenId(AMRVerItemID)
	s mrItemID = obj.MRItemID
	q mrItemID
}

/// Debug:w ##class(DHCEPRFS.BL.BLMRVerItem).GetAllItemByVersionString("147^150^148^149^192^175^176^184^193^194^195^196^197^198")
ClassMethod GetAllItemByVersionString(AMRVersionIDS As %String) As %String
{
	
	s ret = ""
	s rowIDScheme = ""
	s rowIDScheme = ##class(DHCEPRFS.BL.BLPrintScheme).GetSchemeIDByDefault("VIEW")
	if (rowIDScheme = "")||(rowIDScheme = $c(0))
	{
		q AMRVersionIDS
	}
	s obj = ##Class(DHCEPRFS.META.PrintScheme).%OpenId(rowIDScheme)
	s schemeItems = obj.SchemeItems
	 	
	
	for i=1:1:$l(schemeItems,"^")
	{
     	s schemeItem = $p(schemeItems,"^",i)
     	s IDschemeItem = $p(schemeItem,"#",3)
     	for j=1:1:$l(AMRVersionIDS,"^")
     	{
	     	s verItem = $p(AMRVersionIDS,"^",j)
	     	s objItem = ##class(DHCEPRFS.INST.MRVerItem).%OpenId(verItem)
	     	s IDVerItem = objItem.MRItemID
	     	if (IDschemeItem = IDVerItem)
	     	{
		     	if (ret = "")
		     	{
			     	s ret = verItem
		     	}
		     	else
		     	{
			     	s ret = ret_"^"_verItem
		     	}
	     	}
     	}
	}
	q ret
}

/// Desc:根据封存版本号得到封存项目
/// Creator:liushuang
/// Createdate:2016-10-24
/// Input:AMREpisdoeID 归档就诊号,AVersion,版本
ClassMethod GetSealUpItemByVersion(AMRID As %String, AVersionCode As %String) As %String
{
	s ret = ""
	s MRVersionID = ""
	s MRVersionID = ##Class(DHCEPRFS.BL.BLMRVersion).GetMRVersionID(AMRID,AVersionCode)
	s ret = ..GetAllByVersionString(MRVersionID)
	q ret
}

/// debug:w ##class(DHCEPRFS.BL.BLMRVerItem).GetSubMRVerItemByMREpisodeID("6","0","Y")
ClassMethod GetSubMRVerItemByMREpisodeID(AMREpiosdeID As %String, AVersion As %String = "0", ACorrelation As %String = "N") As %String
{
	//b "s"
	s subMRVerItem = ""
	q:(AMREpiosdeID = "") ""
	s obj = ##class(DHCEPRFS.INST.MREpisode).%OpenId(AMREpiosdeID)
	s extendMREpisodeID = ""
	s extendMREpisodeID = obj.ExtendMREpisodeID
	q:(extendMREpisodeID = "") ""
	s MRVersionID = ""
	s MRVersionID = ##Class(DHCEPRFS.BL.BLMRVersion).GetMRVersionID(extendMREpisodeID,AVersion)
	q:(MRVersionID = "") ""
	s subMRVerItem = ##class(DHCEPRFS.BL.BLMRVerItem).GetAllByVersionString(MRVersionID,ACorrelation)
	q subMRVerItem
}

ClassMethod GetSubMRVerItemBySchemeID(AMREpiosdeID As %String, ASchemeID As %String, AVersion As %String = "0", ACorrelation As %String = "N") As %String
{
	s subMRVerItem = ""
	q:(AMREpiosdeID = "") ""
	s objMREpisode = ##class(DHCEPRFS.INST.MREpisode).%OpenId(AMREpiosdeID)
	s extendMREpisodeID = ""
	s extendMREpisodeID = objMREpisode.ExtendMREpisodeID
	q:(extendMREpisodeID = "") ""
	s MRVersionID = ""
	s MRVersionID = ##Class(DHCEPRFS.BL.BLMRVersion).GetMRVersionID(extendMREpisodeID,AVersion)
	q:(MRVersionID = "") ""
	
	s ret = ""
	
 	s obj = ##Class(DHCEPRFS.META.PrintScheme).%OpenId(ASchemeID)
 	q:(obj = "") ""
 	s Items = obj.SchemeSubItems
 	d obj.%Close()
 	q:(Items = "") "" 
 	s total = $l(Items,"^")
 	
 	for i=1:1:total
	{
		s ItemID = $p($p(Items,"^",i),"#",3)
		s MRVerItemID = $O(^DHCEPRFS.INST.MRVerItemI("IdxMain", " "_MRVersionID, " "_ItemID, ""))
		
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
				s MRVerItemID = ##class(DHCEPRFS.BL.BLPrintItemCorrelation).ReplaceCorrelation(MRVersionID,ItemID)
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
				if (retDone ="")
				{
					//没有重复的
					s retDone = current
				}
				else
				{
					//没有重复的
					s retDone = current_"^"_retDone
				}	
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

/// Desc:获取扫描页数
/// Creator:yangpeng
/// Createdate:2020-11-21
/// Input:AMREpisdoeID 归档就诊号,AVersion,版本
/// Output:已分类页数^未分类页数(FileTemporary)
/// Debug:w ##class(DHCEPRFS.BL.BLMRVerItem).GetScanCount("2","0","","PS","159")
ClassMethod GetScanCount(AMREpisodeID As %String, AVersion As %String, AType As %String, AMRItemType As %String, AUserID As %String) As %String
{
	s cateCount = 0, tempCount = 0
	s ret = cateCount_"^"_tempCount
	s:(AType = $c(0)) AType = ""
	q:(AMREpisodeID = "") ret
	
	s mrVersionID = ##class(DHCEPRFS.BL.BLMRVersion).GetMRVersionID(AMREpisodeID,AVersion,AType)
	q:(mrVersionID = "") ret
	
	s xTypeParam = ""
	for {
		s xTypeParam = $o(^DHCEPRFS.META.MRItemI("IdxType"," "_$zcvt(AMRItemType,"U"),xTypeParam))
		q:(xTypeParam = "")
		
		s mrItemID = $o(^DHCEPRFS.META.MRItemI("IdxType"," "_$zcvt(AMRItemType,"U"),xTypeParam,""))
		continue:(mrItemID = "")
		s flagBelong = ##class(DHCEPRFS.BL.BLMRItem).CheckMRItemBelong(mrItemID,AUserID)
		continue:(flagBelong = "0")
		s mrVerItemID = $o(^DHCEPRFS.INST.MRVerItemI("IdxMain"," "_mrVersionID," "_mrItemID,""))
		continue:(mrVerItemID = "")
		
		s objMRVerItem = ##class(DHCEPRFS.INST.MRVerItem).%OpenId(mrVerItemID)
		s totalCount = objMRVerItem.TotCount
		s cateCount = cateCount + totalCount
	}
	
	s xFileTemporaryID = ""
	for { 
		s xFileTemporaryID = $o(^DHCEPRFS.INST.FileTemporaryI("IdxMREpisodeID"," "_AMREpisodeID,xFileTemporaryID))
		q:(xFileTemporaryID = "")
		s objFileTemporary = ##class(DHCEPRFS.INST.FileTemporary).%OpenId(xFileTemporaryID)
		continue:(objFileTemporary.Status '= "0")
		s tempCount = tempCount + 1
	}
	
	s ret = cateCount_"^"_tempCount
	q ret
}

}
