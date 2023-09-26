Class DHCEPRFS.BL.BLMRVerItemDetail Extends %RegisteredObject [ ProcedureBlock ]
{

/// Desc:	注册MRVerItemDetail对象并获取其RowID
/// Debug:	w ##Class(DHCEPRFS.BL.BLMRVerItemDetail).RegMRVerItemDetailID("45","2","42","/145/436/epr/CG07_Multiple_145_436_3_505_0-0_1_2.pdf","")
ClassMethod RegMRVerItemDetailIDWOT(AMRVerItemID As %String, ADetailNum As %String, AFileMasterID As %String, AFileMasterPath As %String, ATotalCount As %String = "") As %String
{
	//获取MRVerItemDetailID
	s mrVerItemDetailID = ..GetMRVerItemDetailID(AMRVerItemID, ADetailNum)
	
	//MRVerItemDetail不存在，创建
	if (mrVerItemDetailID = "")
	{
		s mrVerItemDetailID = ..CreateMRVerItemDetail(AMRVerItemID, ADetailNum, AFileMasterID, AFileMasterPath,ATotalCount)
	}
	else
	{
		s sc = ..UpdateMRVerItemDetail(mrVerItemDetailID, AFileMasterID, AFileMasterPath, ATotalCount)
		if (sc '= "1")
		{
			s mrVerItemDetailID = ""
		}
	}
	
	if (ATotalCount '= "")
	{
		if (mrVerItemDetailID = "")
		{
			q ""	
		}
		else
		{
			s mrVerItemID = $p(mrVerItemDetailID,"||",1)
			s obj = ##class(DHCEPRFS.INST.MRVerItem).%OpenId(mrVerItemID)
			s obj.TotCount = ATotalCount
			s status = obj.%Save()
			if ('$$$ISOK(status))
			{
				q ""
			}
		}
	}
	
	q mrVerItemDetailID
}

/// Desc:	注册MRVerItemDetail对象并获取其RowID
/// Debug:	w ##Class(DHCEPRFS.BL.BLMRVerItemDetail).RegMRVerItemDetailID(^CacheTemp("debug-fs-yang","1"),^CacheTemp("debug-fs-yang","2"),^CacheTemp("debug-fs-yang","3"),^CacheTemp("debug-fs-yang","4"),^CacheTemp("debug-fs-yang","5"))
ClassMethod RegMRVerItemDetailID(AMRVerItemID As %String, ADetailNum As %String, AFileMasterID As %String, AFileMasterPath As %String, ATotalCount As %String = "") As %String
{
	TSTART
	
	s $zt = "OnRegErrorHandler"
	//获取MRVerItemDetailID
	s mrVerItemDetailID = ..GetMRVerItemDetailID(AMRVerItemID, ADetailNum)

	//MRVerItemDetail不存在，创建
	if (mrVerItemDetailID = "")
	{
		s mrVerItemDetailID = ..CreateMRVerItemDetail(AMRVerItemID, ADetailNum, AFileMasterID, AFileMasterPath, ATotalCount)
	}
	else
	{
		s sc = ..UpdateMRVerItemDetail(mrVerItemDetailID, AFileMasterID, AFileMasterPath, ATotalCount)
		if (sc '= "1")
		{
			s mrVerItemDetailID = ""
			TROLLBACK
			q ""
		}
	}
	
	s:(ATotalCount = $c(0)) ATotalCount = ""
	if (ATotalCount '= "")
	{
		if (mrVerItemDetailID = "")
		{
			TROLLBACK
			q ""	
		}
		else
		{
			s mrVerItemID = $p(mrVerItemDetailID,"||",1)
			s obj = ##class(DHCEPRFS.INST.MRVerItem).%OpenId(mrVerItemID)
			s obj.TotCount = ATotalCount
			s status = obj.%Save()
			if ($$$ISOK(status))
			{
				TCOMMIT
				q mrVerItemDetailID
			}
			else
			{
				TROLLBACK
				q ""
			}
		}
	}
	TCOMMIT
	q mrVerItemDetailID
OnRegErrorHandler
	TROLLBACK
	q ""
}

/// Debug:	w ##Class(DHCEPRFS.BL.BLMRVerItemDetail).DeleteMergeDetail("2","-1")
ClassMethod DeleteMergeDetail(AMRVerItemID As %String, AMergeDetailNum As %String) As %String
{
	//b "s"
	
	//获取MRVerItemDetailID
	s mrVerItemDetailID = ..GetMRVerItemDetailID(AMRVerItemID, AMergeDetailNum)
	//不存在则不需要删除
	q:(mrVerItemDetailID = "") "ok"
	
	//存在则删除此条合并信息
	s sc = ##class(DHCEPRFS.INST.MRVerItemDetail).%DeleteId(mrVerItemDetailID)
	if ($$$ISOK(sc))
	{
		q "ok"
	}
	else
	{
		q "error"
	}
}

/// Desc:	获取MRVerItemDetailID
ClassMethod GetMRVerItemDetailID(AMRVerItemID As %String, ADetailNum As %String) As %String
{
	q:(AMRVerItemID="")||(ADetailNum="") ""
	
	s childSub = $O(^DHCEPRFS.INST.MRVerItemDetailI("IdxMain", AMRVerItemID, ADetailNum, ""))
	
	if (childSub = "")
	{
		q ""
	}
	else
	{
		q AMRVerItemID_"||"_childSub
	}
}

/// Desc:	创建MRVerItemDetail
ClassMethod CreateMRVerItemDetail(AMRVerItemID As %String, ADetailNum As %String, AFileMasterID As %String, AFileMasterPath As %String, ATotalCount As %String = "") As %String
{
	//s now = $h
	s objItem = ##Class(DHCEPRFS.INST.MRVerItem).%OpenId(AMRVerItemID)
	q:(objItem = "") ""
	
	s objDetail = ##Class(DHCEPRFS.INST.MRVerItemDetail).%New()
	s objDetail.DetailNum = ADetailNum
	s objDetail.FileMasterID = AFileMasterID
	s objDetail.FileMasterPath = AFileMasterPath
	s objDetail.TotCount = +ATotalCount
	s objDetail.Flag = ""
	s objDetail.TheMRVerItem = objItem
	s objDetail.CreateDate = $p($h,",",1)
	s objDetail.CreateTime = $p($h,",",2)
	s objDetail.ModifyDate = $p($h,",",1)
	s objDetail.ModifyTime = $p($h,",",2)
	s objDetail.DeleteFlag = ""
	s uniqueID = $p(AFileMasterPath,".",1)
	if ($l(uniqueID,"/") > 1)
	{
		s uniqueID = $p(uniqueID,"/",$l(uniqueID,"/"),$l(uniqueID,"/"))
	}
	s objDetail.FileDetailUniqueID = uniqueID
	s status = objItem.%Save()
	if ($$$ISOK(status))
	{
		q objDetail.%Id()
	}
	else
	{
		q ""
	}
}

ClassMethod UpdateMRVerItemDetail(AMRVerItemDetailID As %String, AFileMasterID As %String, AFileMasterPath As %String, ATotalCount As %String) As %String
{
	s objDetail = ##Class(DHCEPRFS.INST.MRVerItemDetail).%OpenId(AMRVerItemDetailID)
	q:(objDetail = "") "0"
	
	s objDetail.FileMasterID = AFileMasterID
	s objDetail.FileMasterPath = AFileMasterPath
	s objDetail.ModifyDate = $p($h,",",1)
	s objDetail.ModifyTime = $p($h,",",2)
	s objDetail.TotCount = ATotalCount
	s objDetail.DeleteFlag = ""
	s uniqueID = $p(AFileMasterPath,".",1)
	if ($l(uniqueID,"/") > 1)
	{
		s uniqueID = $p(uniqueID,"/",$l(uniqueID,"/"),$l(uniqueID,"/"))
	}
	s objDetail.FileDetailUniqueID = uniqueID
	
	s status = objDetail.%Save()
	if ($$$ISOK(status))
	{
		q "1"
	}
	else
	{
		q "0"
	}
}

/// Desc:	获取指定MRVersionID的病历项目
/// Debug: do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMRVerItemDetail","GetAllByMRItem","55^56^57","1","false","")
Query GetAllByMRItem(AMRVerItemIDList As %String, ANeedLocPath As %String = "0", ALastVersion As %String = "", AMRLogDetailID As %String = "") As %Query(ROWSPEC = "MRVerItemID:%String,MRItemID:%String,MRItemName:%String,MRItemType:%String,MRItemMediaType:%String,DetailNum:%String,TotalCount:%String,FileMasterID:%String,FileMasterPath:%String,FileLocPath:%String,FTPConfig:%String,FTPMethod:%String,FTPIP:%String,FTPPort:%String,FTPUserName:%String,FTPPassword:%String,FTPTimeOut:%String,MRVerSubItemID:%String,MRVerSubItemDetailID:%String")
{
}

ClassMethod GetAllByMRItemExecute(ByRef qHandle As %Binary, AMRVerItemIDList As %String, ANeedLocPath As %String = "0", ALastVersion As %String = "", AMRLogDetailID As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
	
	k ^CacheTemp(repid,"dhceprfs","GetAllByMRItem")
	
	s:(ALastVersion = $c(0)) ALastVersion = ""
	s:(AMRLogDetailID = $c(0)) AMRLogDetailID = ""
	
	q:(AMRVerItemIDList="")||(AMRVerItemIDList=$c(0)) $$$OK
	
	s ftpCount = 0
	s ftpConfig = ""
	s listCount = $L(AMRVerItemIDList,"^")
	for i=1:1:listCount
	{
		s AMRVerItemID = $p(AMRVerItemIDList,"^",i)
		
		//s totCount = ##Class(DHCEPRFS.BL.BLMRVerItem).GetTotCountByID(AMRVerItemID)
		//continue:(totCount < 1)
		
		s mrVerItemObj = ##class(DHCEPRFS.INST.MRVerItem).%OpenId(AMRVerItemID)
		s mrVersionID = mrVerItemObj.MRVersionID
		s mrItemID = mrVerItemObj.MRItemID	
		
		s mrItemObj = ##class(DHCEPRFS.META.MRItem).%OpenId(mrItemID)
		s mrItemType = mrItemObj.Type
		s mrItemName = mrItemObj.Name
		s mrItemMediaType = mrItemObj.MediaType
		
		//是否有子版本
		s HasSub = "0"
		s Remark1 = $o(^DHCEPRFS.INST.MRVerSubItemI("IdxMRVerItemID"," "_AMRVerItemID,""))
    	if (Remark1 '= "")
    	{
 			s HasSub = "1"
    	}
		
		s mrVerItemDetailID = ""
		//是否有合并版本
        s mrVerItemDetailID = $O(^DHCEPRFS.INST.MRVerItemDetailI("IdxMain", AMRVerItemID, "-1", mrVerItemDetailID))
        if (mrVerItemDetailID = "")
        {
	        //无合并版本
			if (AMRLogDetailID '= "")
			{
				//按打印记录取
				s mrLogID = $p(AMRLogDetailID,"||",1)
				s mrLogDetailSubID = $p(AMRLogDetailID,"||",2)
				s detailVersion = $o(^DHCEPRFS.INST.MRLogDetailSubI("IdxDetail",mrLogID,mrLogDetailSubID," MRITEMID"," "_mrItemID,""))
				if (detailVersion = "")
				{
					//打印记录的那次打印没有打印此项目
					//此项目取最新版本
					s detailNum = ""
					s detailNum = $O(^DHCEPRFS.INST.MRVerItemDetailI("IdxMain", AMRVerItemID, detailNum),-1)
					s mrVerItemDetailID = $O(^DHCEPRFS.INST.MRVerItemDetailI("IdxMain", AMRVerItemID, detailNum, mrVerItemDetailID))
				}
				else
				{
					//打印记录的那次打印打过此项目
					//此项目取记录中的版本
					s detailVersion = $TR(detailVersion," ","")
					s mrVerItemDetailID = $O(^DHCEPRFS.INST.MRVerItemDetailI("IdxMain", AMRVerItemID, detailVersion, mrVerItemDetailID))
				}
			}
			elseif ((ALastVersion '= "") && (ALastVersion = "true"))
			{
				//取上次打印的
				s mrVersionObj = ##class(DHCEPRFS.INST.MRVersion).%OpenId(mrVersionID)
				s mrEpisodeID = mrVersionObj.MREpisodeID
				s mrLogID = ""
				s mrLogID = $o(^DHCEPRFS.INST.MRLogI("IdxMain"," "_mrEpisodeID,mrLogID))
				s mrLogDetailID = ""
				s mrLogDetailID = $o(^DHCEPRFS.INST.MRLogDetailI("IdxMainAction", mrLogID, " PRINT",mrLogDetailID),-1)	
				if (mrLogDetailID = "")
				{
					//上次没打印过此项目，取最高版本
					s detailNum = ""
					s detailNum = $O(^DHCEPRFS.INST.MRVerItemDetailI("IdxMain", AMRVerItemID, detailNum),-1)
					s mrVerItemDetailID = $O(^DHCEPRFS.INST.MRVerItemDetailI("IdxMain", AMRVerItemID, detailNum, mrVerItemDetailID))
				}
				else
				{
					//上次打印过此项目，取上次打印的版本
					s detailVersion = $o(^DHCEPRFS.INST.MRLogDetailSubI("IdxDetail",mrLogID,mrLogDetailID," MRITEMID"," "_mrItemID,""))
					if (detailVersion = "")	//未打印过该项目
					{
						s detailVersion = $O(^DHCEPRFS.INST.MRVerItemDetailI("IdxMain", AMRVerItemID, detailVersion),-1)
					}
					else
					{
						s detailVersion = $TR(detailVersion," ","")
					}
					s mrVerItemDetailID = $O(^DHCEPRFS.INST.MRVerItemDetailI("IdxMain", AMRVerItemID, detailVersion, mrVerItemDetailID))
				}
			}
			else
			{
				//默认取最高版本
				s detailNum = ""
				s detailNum = $O(^DHCEPRFS.INST.MRVerItemDetailI("IdxMain", AMRVerItemID, detailNum),-1)
	
				s mrVerItemDetailID = $O(^DHCEPRFS.INST.MRVerItemDetailI("IdxMain", AMRVerItemID, detailNum, mrVerItemDetailID))
			}
			continue:(mrVerItemDetailID = "")
        }
		s mrVerItemDetailID = AMRVerItemID_"||"_mrVerItemDetailID

		s objMRVerItemDetail = ##Class(DHCEPRFS.INST.MRVerItemDetail).%OpenId(mrVerItemDetailID)
		continue:(objMRVerItemDetail = "")
		
		s MRVerItemID = AMRVerItemID
		s DetailNum = objMRVerItemDetail.DetailNum
		s FileMasterID = objMRVerItemDetail.FileMasterID
		s FileMasterPath = objMRVerItemDetail.FileMasterPath
		s TotalCount = objMRVerItemDetail.TotCount
		
		s objFileMaster = ##class(DHCEPRFS.INST.FileMaster).%OpenId(FileMasterID)
		s DirLocID = objFileMaster.DirLocID
		s nameSpace = ##class(DHCEPRFS.BL.BLDirLoc).GetNamespaceByDirLocID(DirLocID)
		s nameSpace = $ZSTRIP(nameSpace,"*N")
		
		s FileLocPath = ""
		s FTPConfig = ""
		s FTPMethod = ""
		s FTPIP = ""
		s FTPPort = ""
		s FTPUserName = ""
		s FTPPassword = ""
		s FTPTimeOut = ""
		if (ANeedLocPath = "1")
		{	
			s FileInfo = ##Class(DHCEPRFS.BL.BLFileMaster).GetFullFileLocName(FileMasterID,nameSpace)
			s FileLocPath = $p(FileInfo,"@@@",2)
			s FTPConfigOne = $p(FileInfo,"@@@",1)
			if (FTPConfigOne '= FTPConfig)
			{
				s FTPConfig = FTPConfigOne
				s ftpCount = (+ftpCount) + 1	
			}

			s FTPMethod = $p(FTPConfigOne,"^",1)
			s FTPIP = $p(FTPConfigOne,"^",2)
			s FTPPort = $p(FTPConfigOne,"^",3)
			s FTPUserName = $p(FTPConfigOne,"^",4)
			s FTPPassword = $p(FTPConfigOne,"^",5)
			s FTPTimeOut = $p(FTPConfigOne,"^",6)
		}
		if (HasSub '= "1")
		{
			s ^CacheTemp(repid,"dhceprfs","GetAllByMRItem",ftpCount,mrVerItemDetailID) = $lb(MRVerItemID,mrItemID,mrItemName,mrItemType,mrItemMediaType,DetailNum,TotalCount,FileMasterID,FileMasterPath,FileLocPath,FTPConfigOne,FTPMethod,FTPIP,FTPPort,FTPUserName,FTPPassword,FTPTimeOut,"","")
		}
		//s ^CacheTemp(repid,ind) = $lb(MRVerItemID,DetailNum,FileMasterID,FileMasterPath,FileLocPath,FTPConfig,FTPMethod,FTPIP,FTPPort,FTPUserName,FTPPassword,FTPTimeOut)
		//s ind=ind+1 
		
		if (HasSub = "1")
		{
			s mrVerSubItemUnique = ""
			for {
				s mrVerSubItemUnique = $o(^DHCEPRFS.INST.MRVerSubItemI("IdxMain"," "_AMRVerItemID,mrVerSubItemUnique))
				q:(mrVerSubItemUnique = "")
		
				s mrVerSubItemID = ""
				for {
					s mrVerSubItemID = $o(^DHCEPRFS.INST.MRVerSubItemI("IdxMain"," "_AMRVerItemID,mrVerSubItemUnique,mrVerSubItemID))
					q:(mrVerSubItemID = "")		
			
					//取subdetail最后一条
					s detailNum = $o(^DHCEPRFS.INST.MRVerSubItemDtlI("IdxMain",mrVerSubItemID,""),-1)
					q:(detailNum = "")
						
					s subID = $o(^DHCEPRFS.INST.MRVerSubItemDtlI("IdxMain",mrVerSubItemID,detailNum,""))	
					s fullSubID = mrVerSubItemID_"||"_subID
					
					s objMRVerSubItemDetail = ##Class(DHCEPRFS.INST.MRVerSubItemDetail).%OpenId(fullSubID)
					continue:(objMRVerSubItemDetail = "")
		
					s MRVerItemID = AMRVerItemID
					s DetailNum = objMRVerSubItemDetail.DetailNum
					s FileMasterID = objMRVerSubItemDetail.FileMasterID
					s FileMasterPath = objMRVerSubItemDetail.FileMasterPath
					
					s objFileMaster = ##class(DHCEPRFS.INST.FileMaster).%OpenId(FileMasterID)
					s DirLocID = objFileMaster.DirLocID
					s nameSpace = ##class(DHCEPRFS.BL.BLDirLoc).GetNamespaceByDirLocID(DirLocID)
					s nameSpace = $ZSTRIP(nameSpace,"*N")
		
					s FileLocPath = ""
					s FTPConfig = ""
					s FTPMethod = ""
					s FTPIP = ""
					s FTPPort = ""
					s FTPUserName = ""
					s FTPPassword = ""
					s FTPTimeOut = ""
					if (ANeedLocPath = "1")
					{	
						s FileInfo = ##Class(DHCEPRFS.BL.BLFileMaster).GetFullFileLocName(FileMasterID,nameSpace)
						s FileLocPath = $p(FileInfo,"@@@",2)
						s FTPConfigOne = $p(FileInfo,"@@@",1)
						if (FTPConfigOne '= FTPConfig)
						{
							s FTPConfig = FTPConfigOne
							s ftpCount = (+ftpCount) + 1	
						}

						s FTPMethod = $p(FTPConfigOne,"^",1)
						s FTPIP = $p(FTPConfigOne,"^",2)
						s FTPPort = $p(FTPConfigOne,"^",3)
						s FTPUserName = $p(FTPConfigOne,"^",4)
						s FTPPassword = $p(FTPConfigOne,"^",5)
						s FTPTimeOut = $p(FTPConfigOne,"^",6)
					}
		
					s ^CacheTemp(repid,"dhceprfs","GetAllByMRItem",ftpCount,AMRVerItemID_"||"_fullSubID) = $lb(MRVerItemID,mrItemID,mrItemName,mrItemType,mrItemMediaType,DetailNum,TotalCount,FileMasterID,FileMasterPath,FileLocPath,FTPConfigOne,FTPMethod,FTPIP,FTPPort,FTPUserName,FTPPassword,FTPTimeOut,mrVerSubItemID,fullSubID)
				}
			}
		}
		
	}

	s ftpCount = ""
	for {
		s ftpCount = $o(^CacheTemp(repid,"dhceprfs","GetAllByMRItem",ftpCount))
		q:(ftpCount = "")
		s mrVerItemDetailID = ""
		for {
			s mrVerItemDetailID = $o(^CacheTemp(repid,"dhceprfs","GetAllByMRItem",ftpCount,mrVerItemDetailID))
			q:(mrVerItemDetailID = "")
			
			s ^CacheTemp(repid,ind) = ^CacheTemp(repid,"dhceprfs","GetAllByMRItem",ftpCount,mrVerItemDetailID)
			s ind=ind+1 	
		}
	}
	
	k ^CacheTemp(repid,"dhceprfs","GetAllByMRItem")
	
	Quit $$$OK
}

ClassMethod GetAllByMRItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllByMRItemExecute ]
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

ClassMethod GetAllByMRItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllByMRItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc:	获取指定MRVersionID的病历项目
/// Debug: 	do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMRVerItemDetail","GetVerItemDetail","1","0","1")
Query GetVerItemDetail(AMRVerItemIDList As %String, ADetailNum As %String, ANeedLocPath As %String = "0") As %Query(ROWSPEC = "MRVerItemID:%String,DetailNum:%String,FileMasterID:%String,FileMasterPath:%String,FileLocPath:%String")
{
}

ClassMethod GetVerItemDetailExecute(ByRef qHandle As %Binary, AMRVerItemIDList As %String, ADetailNum As %String, ANeedLocPath As %String = "0") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
	
	s listCount = $L(AMRVerItemIDList,"^")
	for i=1:1:listCount
	{
		s AMRVerItemID = $p(AMRVerItemIDList,"^",i)
		
		s mrVerItemDetailID = $O(^DHCEPRFS.INST.MRVerItemDetailI("IdxMain", AMRVerItemID, ADetailNum, ""))
		continue:(mrVerItemDetailID = "")
		
		s mrVerItemDetailID = AMRVerItemID_"||"_mrVerItemDetailID
		s objMRVerItemDetail = ##Class(DHCEPRFS.INST.MRVerItemDetail).%OpenId(mrVerItemDetailID)
		continue:(objMRVerItemDetail = "")
		
		s MRVerItemID = AMRVerItemID
		s DetailNum = ADetailNum
		s FileMasterID = objMRVerItemDetail.FileMasterID
		s FileMasterPath = objMRVerItemDetail.FileMasterPath
		s FileLocPath = ""
		if (ANeedLocPath = "1")
		{	
			s FileLocPath = ##Class(DHCEPRFS.BL.BLFileMaster).GetFullFileLocName(FileMasterID)
		}
		s ^CacheTemp(repid,ind) = $lb(MRVerItemID,DetailNum,FileMasterID,FileMasterPath,FileLocPath)
		s ind=ind+1 
	}
	Quit $$$OK
}

ClassMethod GetVerItemDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetVerItemDetailExecute ]
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

ClassMethod GetVerItemDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetVerItemDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetMaxDetailNum(AMRVerItemID As %String) As %String
{
	s detailNum = ""
	s detailNum = $o(^DHCEPRFS.INST.MRVerItemDetailI("IdxMain",AMRVerItemID,detailNum),-1)
	q detailNum
}

ClassMethod GetBeforeDetailNum(AMRVerItemID As %String, ADetailNum As %String) As %String
{
	s detailNum = $o(^DHCEPRFS.INST.MRVerItemDetailI("IdxMain",AMRVerItemID,ADetailNum),-1)
	q detailNum
}

ClassMethod GetNextDetailNum(AMRVerItemID As %String, ADetailNum As %String) As %String
{
	s detailNum = $o(^DHCEPRFS.INST.MRVerItemDetailI("IdxMain",AMRVerItemID,ADetailNum))
	q detailNum
}

/// debug: w ##class(DHCEPRFS.BL.BLMRVerItemDetail).GetMaxDetailNumByEpisode("373","07","630","")
ClassMethod GetMaxDetailNumByEpisode(AEpisodeID As %String, AType As %String, ATypeParams As %String, AVersionCode As %String = "") As %String
{
	s:(AVersionCode= $c(0)) AVersionCode= ""
	s mrEpisodeID = ##class(DHCEPRFS.BL.BLMREpisode).GetMREpisodeIDByAdm(AEpisodeID,"DHC")	
	q:(mrEpisodeID = "") ""
	s detailNum = ..GetMaxDetailNumByMREpisode(mrEpisodeID,AType,ATypeParams, AVersionCode)
	q detailNum
}

/// debug: w ##class(DHCEPRFS.BL.BLMRVerItemDetail).GetMaxDetailNumByMREpisode("436","07","505")
ClassMethod GetMaxDetailNumByMREpisode(AMREpisodeID As %String, AType As %String, ATypeParams As %String, AVersionCode As %String = "") As %String
{
	s:(AVersionCode= $c(0)) AVersionCode= ""
	s mrItemID = ##Class(DHCEPRFS.BL.BLMRItem).GetItemIDByType(AType,ATypeParams)
	q:(mrItemID = "") ""
	s MRVerItemID = ##Class(DHCEPRFS.BL.BLMRVerItem).GetVerItemByItemIDAndMRAdmID(AMREpisodeID,mrItemID,AVersionCode)
	q:(MRVerItemID = "") ""
	s detailNum = ..GetMaxDetailNum(MRVerItemID)
	q detailNum
}

/// debug: w ##class(DHCEPRFS.BL.BLMRVerItemDetail).GetMaxDetailNumByMRItem("436","505")
ClassMethod GetMaxDetailNumByMRItem(AMRID As %String, AMRItemID As %String, AVersionCode As %String = "", AType As %String = "") As %String
{
	s:(AVersionCode= $c(0)) AVersionCode= ""
	s MRVerItemID = ##Class(DHCEPRFS.BL.BLMRVerItem).GetVerItemByItemIDAndMRAdmID(AMRID,AMRItemID, AVersionCode,AType)
	q:(MRVerItemID = "") ""
	s detailNum = ..GetMaxDetailNum(MRVerItemID)
	q detailNum
}

/// w ##Class(DHCEPRFS.BL.BLMRVerItemDetail).GetToNumListByMR("2","","49")
ClassMethod GetToNumListByMR(AID As %String, AVersionType As %String, AMRItemIDList As %String, AType As %String = "") As %String
{
	q:(AMRItemIDList="")||(AMRItemIDList=$c(0)) ""
	
	s mrItemCount = $L(AMRItemIDList,"^")
	
	s defaultToNum = "", retToNum = ""
	for i=1:1:mrItemCount
	{
		if (defaultToNum = "")
		{	s defaultToNum = "0"}
		else
		{	s defaultToNum = defaultToNum_"^0"}
	}
	
	s mrID = AID
	q:(mrID="") defaultToNum
	
	//s version = ##Class(DHCEPRFS.BL.BLVersionCodeMapping).GetVersionBySchemeType(ASchemeType)
	s version = ##Class(DHCEPRFS.BL.BLVersionCodeMapping).GetVersionByTypeCode(AVersionType)
	s mrVersionID = ##Class(DHCEPRFS.BL.BLMRVersion).GetMRVersionID(mrID,version,AType)
	q:(mrVersionID="") defaultToNum
	
	//是否需要保留历史,默认不保留历史、覆盖原来的文件
	s isOverwrite = "1"
	s overwriteTimePoint = ##Class(DHCEPRFS.BL.BLSysOption).GetValueByName("OverwriteTimePoint")
	if (overwriteTimePoint'="")&&(overwriteTimePoint'=$C(0))&&(overwriteTimePoint '= "NULL")
	{
		s hasAction = ##Class(DHCEPRFS.BL.BLMRLog).CheckAction(mrID,overwriteTimePoint,AType)
		if (hasAction = "0")
		{
			s isOverwrite = "0"
		}
	}
	
	for i=1:1:mrItemCount
	{
		s itemID = $P(AMRItemIDList,"^",i)
		
		s maxNum = "", toNum = "0"
		//s itemID = ##Class(DHCEPRFS.BL.BLMRItem).GetItemIDByType(itemType,itemTypeParams)   
		s mrVerItemID = $O(^DHCEPRFS.INST.MRVerItemI("IdxMain", " "_mrVersionID, " "_itemID, ""))
		if (mrVerItemID '= "")
		{
			s maxNum = $o(^DHCEPRFS.INST.MRVerItemDetailI("IdxMain",mrVerItemID,""),-1)
		}
		
		//b "s"
		//原始版本不为空并且保留历史版本时，版本号加1
		if (maxNum '= "")&&(isOverwrite = "1")
		{
			s toNum = maxNum + 1
		}
		
		//有最新版本，但是又不保留版本，默认使用最大版本号
		if (maxNum '= "")&&(isOverwrite = "0")
		{
			s toNum = maxNum 
		} 
		
		if (retToNum = "")
		{
			s retToNum = toNum
		}
		else
		{
			s retToNum = retToNum_"^"_toNum
		}
	}
	
	q retToNum
}

/// debug: w ##class(DHCEPRFS.BL.BLMRVerItemDetail).GetToNumList("2","","07|53|xxxx^07|627|xxx")
ClassMethod GetToNumListSub(AEpisodeID As %String, AVersionTypeCode As %String, AMRItemParamList As %String) As %String
{
	//b "s"
	q:(AMRItemParamList="")||(AMRItemParamList=$c(0)) ""
	
	s mrItemCount = $L(AMRItemParamList,"^")
	
	s defaultToNum = "", retToNum = ""
	for i=1:1:mrItemCount
	{
		if (defaultToNum = "")
		{	s defaultToNum = "0"}
		else
		{	s defaultToNum = defaultToNum_"^0"}
	}
	
	
	s mrEpisodeID = ##Class(DHCEPRFS.BL.BLMREpisode).GetMREpisodeIDByAdm(AEpisodeID,"DHC")
	q:(mrEpisodeID="") defaultToNum
	
	//s version = ##Class(DHCEPRFS.BL.BLVersionCodeMapping).GetVersionBySchemeType(ASchemeType)
	s version = ##Class(DHCEPRFS.BL.BLVersionCodeMapping).GetVersionByTypeCode(AVersionTypeCode)
	s mrVersionID = ##Class(DHCEPRFS.BL.BLMRVersion).GetMRVersionID(mrEpisodeID,version)
	q:(mrVersionID="") defaultToNum
	
	//是否需要保留历史,默认不保留历史、覆盖原来的文件
	s isOverwrite = "1"	//默认要覆盖
	s overwriteTimePoint = ##Class(DHCEPRFS.BL.BLSysOption).GetValueByName("OverwriteTimePoint")
	if (overwriteTimePoint'="")&&(overwriteTimePoint'=$C(0))&&(overwriteTimePoint '= "NULL")
	{
		//取保留历史版本的动作节点，如果本次就诊已经发生该动作，则需要不能覆盖
		s hasAction = ##Class(DHCEPRFS.BL.BLMRLog).CheckAction(mrEpisodeID,overwriteTimePoint)
		if (hasAction = "1")
		{
			s isOverwrite = "0"
		}
	}
	
	for i=1:1:mrItemCount
	{
		s oneItem = $P(AMRItemParamList,"^",i)
		s itemType = $P(oneItem,"|",1)
		s itemTypeParams = $P(oneItem,"|",2)
		s fileUniqueID = $p(oneItem,"|",3)
		
		s maxNum = "", toNum = "0"
		s itemID = ##Class(DHCEPRFS.BL.BLMRItem).GetItemIDByType(itemType,itemTypeParams)   
		s mrVerItemID = $O(^DHCEPRFS.INST.MRVerItemI("IdxMain", " "_mrVersionID, " "_itemID, ""))
		if (mrVerItemID '= "")
		{
			s mrVerItemSubID = $o(^DHCEPRFS.INST.MRVerSubItemI("IdxMain", " "_mrVerItemID, " "_fileUniqueID, ""))
			if (mrVerItemSubID '= "")
			{
				s maxNum = $o(^DHCEPRFS.INST.MRVerSubItemDtlI("IdxMain",mrVerItemSubID,""),-1)
			}
		}
		
		//b "s"
		//原始版本不为空并且不覆盖保留历史版本时，版本号加1
		if (maxNum '= "")&&(isOverwrite = "0")
		{
			s toNum = maxNum + 1
		}
		
		if (retToNum = "")
		{
			s retToNum = toNum
		}
		else
		{
			s retToNum = retToNum_"^"_toNum
		}
	}
	
	q retToNum
}

/// debug: w ##class(DHCEPRFS.BL.BLMRVerItemDetail).GetToNumList("2","","07|534^07|627")
ClassMethod GetToNumList(AEpisodeID As %String, AVersionTypeCode As %String, AMRItemParamList As %String) As %String
{
	//b "s"
	q:(AMRItemParamList="")||(AMRItemParamList=$c(0)) ""
	
	s mrItemCount = $L(AMRItemParamList,"^")
	
	s defaultToNum = "", retToNum = ""
	for i=1:1:mrItemCount
	{
		if (defaultToNum = "")
		{	s defaultToNum = "0"}
		else
		{	s defaultToNum = defaultToNum_"^0"}
	}
	
	
	s mrEpisodeID = ##Class(DHCEPRFS.BL.BLMREpisode).GetMREpisodeIDByAdm(AEpisodeID,"DHC")
	q:(mrEpisodeID="") defaultToNum
	
	//s version = ##Class(DHCEPRFS.BL.BLVersionCodeMapping).GetVersionBySchemeType(ASchemeType)
	s version = ##Class(DHCEPRFS.BL.BLVersionCodeMapping).GetVersionByTypeCode(AVersionTypeCode)
	s mrVersionID = ##Class(DHCEPRFS.BL.BLMRVersion).GetMRVersionID(mrEpisodeID,version)
	q:(mrVersionID="") defaultToNum
	
	//默认不保留历史、覆盖原来的文件
	s isOverwrite = "1"	//默认要覆盖
	s overwriteTimePoint = ##Class(DHCEPRFS.BL.BLSysOption).GetValueByName("OverwriteTimePoint")
	if (overwriteTimePoint'="")&&(overwriteTimePoint'=$C(0))&&(overwriteTimePoint '= "NULL")
	{
		//取保留历史版本的动作节点，如果本次就诊已经发生该动作，则需要不能覆盖
		s hasAction = ##Class(DHCEPRFS.BL.BLMRLog).CheckAction(mrEpisodeID,overwriteTimePoint)
		if (hasAction = "1")
		{
			s isOverwrite = "0"
		}
	}
	
	for i=1:1:mrItemCount
	{
		s oneItem = $P(AMRItemParamList,"^",i)
		s itemType = $P(oneItem,"|",1)
		s itemTypeParams = $P(oneItem,"|",2)
		
		s maxNum = "", toNum = "0"
		s itemID = ##Class(DHCEPRFS.BL.BLMRItem).GetItemIDByType(itemType,itemTypeParams)   
		s mrVerItemID = $O(^DHCEPRFS.INST.MRVerItemI("IdxMain", " "_mrVersionID, " "_itemID, ""))
		if (mrVerItemID '= "")
		{
			s maxNum = $o(^DHCEPRFS.INST.MRVerItemDetailI("IdxMain",mrVerItemID,""),-1)
		}
		
		//b "s"
		//原始版本不为空并且不覆盖保留历史版本时，版本号加1
		if (maxNum '= "")&&(isOverwrite = "0")
		{
			s toNum = maxNum + 1
		}
		
		if (retToNum = "")
		{
			s retToNum = toNum
		}
		else
		{
			s retToNum = retToNum_"^"_toNum
		}
	}
	
	q retToNum
}

/// Input:	AMREpisodeID  : MREpisodeID
/// 			AVersionCode  : 版本编码
/// 			AMRVerItemList: 要注册的归档项目明细，格式如下
/// 						   MRItemID1|DetailNum1|PageCount1|FileMasterID1|FileMasterPath1^MRItemID2|DetailNum2|PageCount2|FileMasterID2|FileMasterPath2
ClassMethod RegDetailList(AMRID As %String, AVersionCode As %String, AMRVerItemDetailList As %String, AType As %String = "") As %String
{
	s versionNum = ##Class(DHCEPRFS.BL.BLVersionCodeMapping).GetVersionByCode(AVersionCode)
	
	s mrVersionID =##Class(DHCEPRFS.BL.BLMRVersion).RegMRVersionID(AMRID,versionNum,AType)
	
	s isError = "0"
	s retDetailIDList = ""
	s count = $L(AMRVerItemDetailList,"^")
	for i=1:1:count
	{
		s oneItem = $P(AMRVerItemDetailList,"^",i)
		s mrItemID = $P(oneItem,"|",1)
		s detailNum = $P(oneItem,"|",2)
		s pageCount = $P(oneItem,"|",3)
		s fileMasterID = $P(oneItem,"|",4)
		s fileMasterPath = $P(oneItem,"|",5)
		
		s mrVerItemID = ##Class(DHCEPRFS.BL.BLMRVerItem).RegMRVerItemID(mrVersionID, mrItemID, pageCount)
		if (mrVerItemID = "")
		{
			s isError = "1"
			q
		}
		
		s mrVerItemDetailID = ##Class(DHCEPRFS.BL.BLMRVerItemDetail).RegMRVerItemDetailIDWOT(mrVerItemID,detailNum,fileMasterID,fileMasterPath,pageCount)
		if (mrVerItemDetailID = "")
		{
			s isError = "1"
			s retDetailIDList = ""
			q
		}
		
		if (retDetailIDList = "")
		{	s retDetailIDList = mrVerItemDetailID}
		else
		{	s retDetailIDList = retDetailIDList_"^"_mrVerItemDetailID}
	}
	
	if (isError = "1")
	{
		q ""
	}
	else
	{
		q retDetailIDList
	}
}

// debug:w ##class(DHCEPRFS.BL.BLMRVerItemDetail).DeleteMRVerItemDetail("577","4")

ClassMethod DeleteMRVerItemDetail(AEpisodeID As %String, AMRItemID As %String) As %String
{
	q:(AEpisodeID = "") ""
	q:(AMRItemID = "") ""
	s sysCode = ##Class(DHCEPRFS.Const.SysCode).DHC()
	s mrEpisodeID =""
	s mrEpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxSysCodeAndEpisodeID"," "_sysCode," "_AEpisodeID,""))
	q:(mrEpisodeID = "")
	s count = 0
	
	s version =""
	for {
		s version = $o(^DHCEPRFS.INST.MRVersionI("IdxMain"," "_mrEpisodeID,version))
		q:(version ="")
		s mrVersion = ""
		for {
			s mrVersion = $o(^DHCEPRFS.INST.MRVersionI("IdxMain"," "_mrEpisodeID,version,mrVersion))
			q:(mrVersion = "")
			s mrVerItem = ""
			s mrVerItem = $o(^DHCEPRFS.INST.MRVerItemI("IdxMain"," "_mrVersion," "_AMRItemID,mrVerItem))
			q:(mrVerItem ="")
			
			s detailNum = ""
			for {
				s detailNum = $o(^DHCEPRFS.INST.MRVerItemDetailI("IdxMain",mrVerItem,detailNum))
				q:(detailNum ="")
				s mrVerItemDetail = ""
				for {
					s mrVerItemDetail = $o(^DHCEPRFS.INST.MRVerItemDetailI("IdxMain",mrVerItem,detailNum,mrVerItemDetail))
					q:(mrVerItemDetail ="")
					s obj = ##class(DHCEPRFS.INST.MRVerItemDetail).%OpenId(mrVerItem_"||"_mrVerItemDetail)
					s obj.DeleteFlag = "Y"
					s sc = obj.%Save()
					if ($$$ISOK(sc))
					{
						s count = count+1
					}
				}
			}
		}		
	}
	q count
}

}
