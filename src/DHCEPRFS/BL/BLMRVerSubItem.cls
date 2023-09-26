Class DHCEPRFS.BL.BLMRVerSubItem Extends %RegisteredObject [ ProcedureBlock ]
{

ClassMethod RegSubVerItemWOT(AEpisodeID As %String, ASysCode As %String, AMrEpisodeID As %String, ATypeID As %String, APrintDocID As %String, ATotalPages As %String, ALogicID As %String, ALogicPath As %String, AVersionTypeCode As %String, AMaxDetailNum As %String, AUniqueCode As %String, ADocumentID As %String)
{

    s:(AVersionTypeCode = $c(0)) AVersionTypeCode = ""
    s mrVersionID = ##class(DHCEPRFS.BL.BLMRVersion).GetMRVerionIDByType(AMrEpisodeID,AVersionTypeCode)
    
    s mrItemID = $o(^DHCEPRFS.META.MRItemI("IdxType"," "_ATypeID," "_APrintDocID,""))
    if (mrItemID="")    //
    {
        q ""    
    }
    s mrVerItemID = ##class(DHCEPRFS.BL.BLMRVerItem).GetMRVerItemID(mrVersionID,mrItemID)
    
    
    s mrVerSubItemID = ..RegMRVerSubItemID(mrVerItemID,mrItemID,ATotalPages,ADocumentID,AUniqueCode)
    
    //获取此mrVerSubItem下最大的detailNum
    s detailNum = ""
    s maxDetailNum = ##class(DHCEPRFS.BL.BLMRVerSubItemDetail).GetMaxDetailNum(mrVerSubItemID)
    s:(maxDetailNum = $c(0)) maxDetailNum = ""
    //若maxDetailNum为空表示第一次生成无历史版本，则应为版本0，否则当前版本应为最大版本+1
    if (maxDetailNum = "")
    {
        s detailNum = "0"   
    }
    else
    {
        //是否需要保留历史,默认不保留历史、覆盖原来的文件
        s isOverwrite = "1"
        s overwriteTimePoint = ##Class(DHCEPRFS.BL.BLSysOption).GetValueByName("OverwriteTimePoint")
        if (overwriteTimePoint'="")&&(overwriteTimePoint'=$C(0))&&(overwriteTimePoint '= "NULL")
        {
            s hasAction = ##Class(DHCEPRFS.BL.BLMRLog).CheckAction(AMrEpisodeID,overwriteTimePoint)
            if (hasAction = "0")
            {
                s isOverwrite = "0"
            }
        }
    
        if (isOverwrite = "1")
        {
            //在规定动作发生前，做覆盖
            s detailNum = +maxDetailNum
        }
        else
        {
            //在规定动作发生后，做新增版本
            s detailNum = +(maxDetailNum) + 1   
        }
    }
    
    s ret = ##Class(DHCEPRFS.BL.BLMRVerSubItemDetail).RegMRVerSubItemDetailID(mrVerSubItemID,detailNum,ALogicID,ALogicPath,ATotalPages)
    if (ret '="")
    {
	    //判断平台对此项的调用是否在生成归档前、后。如果在归档后就对此项做单项生成。
    	d ##class(DHCEPRFS.BL.BLAdmMRStatus).LateToCreate(AEpisodeID,mrItemID)
    }
    q ret
}

/// Desc:   注册MRVerSubItem对象并获取其RowID
/// Debug:  w ##Class(DHCEPRFS.BL.BLMRVerSubItem).RegMRVerSubItemID("1","1","7")
ClassMethod RegMRVerSubItemID(AMRVerItemID As %String, AMRItemID As %String, ATotCount As %String, ADocumentID As %String, AUniqueCode As %String) As %String
{
    b "s"
    //处理入参
    s ATotCount = +ATotCount
        
    //获取MRVerSubItemID
    s mrVerSubItemID = ..GetMRVerSubItemID(AMRVerItemID, AUniqueCode)
    
    //mrVerSubItemID不存在，创建
    if (mrVerSubItemID = "")
    {
        s mrVerSubItemID = ..CreateMRVerSubItem(AMRVerItemID, AUniqueCode, ADocumentID, AMRItemID, ATotCount)
    }
    else
    {
        s sc = ..UpdateMRVerSubItem(mrVerSubItemID, AUniqueCode, ADocumentID, AMRItemID, ATotCount)
        if (sc '= "1")
        {
            s mrVerSubItemID = ""
        }
    }
    
    q mrVerSubItemID
}

/// Desc:   获取MRVerItemID
ClassMethod GetMRVerSubItemID(AMRVerItemID As %String, AUniqueCode As %String) As %String
{
    q:(AMRVerItemID="")||(AUniqueCode="") ""
    s uniqueID = $p(AUniqueCode,".",1)
    if ($l(uniqueID,"_0-0_") > 1)
    {
        s uniqueID = $p(uniqueID,"_0-0_",1)
    }
    if ($l(uniqueID,"/") > 1)
    {
        s uniqueID = $p(uniqueID,"/",$l(uniqueID,"/"),$l(uniqueID,"/"))
    } 
    s uniqueID=$zcvt(uniqueID,"U")  //转换为大写
    s rowID = $O(^DHCEPRFS.INST.MRVerSubItemI("IdxMain", " "_AMRVerItemID, " "_uniqueID, ""))
    q rowID
}

/// Desc:   创建MRVerItem
ClassMethod CreateMRVerSubItem(AMRVerItemID As %String, AUniqueCode As %String, ADocumentID As %String, AMRItemID As %String, ATotCount As %String) As %String
{
    //b "s"
    s now = $h
    
    s obj = ##Class(DHCEPRFS.INST.MRVerSubItem).%New()
    s obj.MRVerItemID = AMRVerItemID
    s obj.MRItemID = AMRItemID
    s uniqueID = $p(AUniqueCode,".",1)
    s uniqueID = $p(AUniqueCode,".",1)
    if ($l(uniqueID,"_0-0_") > 1)
    {
        s uniqueID = $p(uniqueID,"_0-0_",1)
    }
    if ($l(uniqueID,"/") > 1)
    {
        s uniqueID = $p(uniqueID,"/",$l(uniqueID,"/"),$l(uniqueID,"/"))
    }
    s obj.FileSubUniqueID = uniqueID
    s obj.TotCount = ATotCount
    s obj.Remark1 = ADocumentID
    s obj.CreateDate = $p(now, ",", 1)
    s obj.CreateTime = $p(now, ",", 2)
    s obj.ModifyDate = $p(now, ",", 1)
    s obj.ModifyTime = $p(now, ",", 2)
    
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

/// Desc:   创建MRVerItem
ClassMethod UpdateMRVerSubItem(AMRVerSubItemID As %String, AUniqueCode As %String, ADocumentID As %String, AMRItemID As %String, ATotCount As %String) As %String
{
    s now = $h
    
    s obj = ##Class(DHCEPRFS.INST.MRVerSubItem).%OpenId(AMRVerSubItemID)
    s obj.MRItemID = AMRItemID
    s uniqueID = $p(AUniqueCode,".",1)
    s uniqueID = $p(AUniqueCode,".",1)
    if ($l(uniqueID,"_0-0_") > 1)
    {
        s uniqueID = $p(uniqueID,"_0-0_",1)
    }
    if ($l(uniqueID,"/") > 1)
    {
        s uniqueID = $p(uniqueID,"/",$l(uniqueID,"/"),$l(uniqueID,"/"))
    }
    s obj.FileSubUniqueID = uniqueID
    s obj.TotCount = ATotCount
    s obj.Remark1 = ADocumentID
    s obj.ModifyDate = $p(now, ",", 1)
    s obj.ModifyTime = $p(now, ",", 2)

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

/// Desc:   根据DocID获取SubItem的文件后缀名(如果有返回原始的，没有返回NONE)
/// Debug:  w ##Class(DHCEPRFS.BL.BLMRVerSubItem).GetVerSubItemSuffix("573","111","01.201609080114.01^^^01.201609080114.02^01.201609080114.0x")
ClassMethod GetVerSubItemSuffix(AEpisodeID As %String, AMRItemID As %String, ADocIDs As %String) As %String
{
    //获取MREpisodeID
    s MREpisodeID=##class(DHCEPRFS.BL.BLMREpisode).GetMREpisodeIDByAdm(AEpisodeID,"DHC")
    
    //获取最新的MRVersion
    s MRVersionID=""
    s MaxVersion=""
    s MaxVersion=$o(^DHCEPRFS.INST.MRVersionI("IdxMain"," "_MREpisodeID,MaxVersion),-1)
    s MRVersionID=$o(^DHCEPRFS.INST.MRVersionI("IdxMain"," "_MREpisodeID,MaxVersion,""))
    
    //获取MRVerItemID
    s MRVerItemID=""
    s MRVerItemID = $O(^DHCEPRFS.INST.MRVerItemI("IdxMain", " "_MRVersionID, " "_AMRItemID, ""))
    
    //有原始的取原始的，没有原始的返回NONE，前端发GUID
    s ret=""
    for i=1:1:$l(ADocIDs,"^^^")
    {
        s DocID=$p(ADocIDs,"^^^",i)
        s DocID=$zcvt(DocID,"U")    //将DocID转换为大写，索引里存大写
        s MRVerSubItemID=$O(^DHCEPRFS.INST.MRVerSubItemI("IdxMRVerItemID"," "_MRVerItemID," "_DocID,""))
        if (MRVerSubItemID="")  //为空返回none
        {
            s suffix="NONE"
        }
        else
        {
	        s suffix="NONE"
            //w MRVerSubItemID
            //s objMRVerSubItem=##class(DHCEPRFS.INST.MRVerSubItem).%OpenId(MRVerSubItemID)
            //s suffix=$p(objMRVerSubItem.FileSubUniqueID,"_",$l(objMRVerSubItem.FileSubUniqueID,"_"))
        }
        if (ret="")
        {
            s ret=suffix
        }
        else
        {
            s ret=ret_"^"_suffix
        }
    }
    q ret
}

/// Desc:   根据就诊号和MRItemID查询所有VerSub的PDFPath
/// Input：  MRPrintChargeID 
/// Debug：  do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMRVerSubItem","GetItemVerSubPath","3901339","702")
Query GetItemVerSubPath(AEpisodeID As %String, ATypeCode As %String) As %Query(ROWSPEC = "Remark1:%String,Path:%String")
{
}

ClassMethod GetItemVerSubPathExecute(ByRef qHandle As %Binary, AEpisodeID As %String, ATypeCode As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s ind=1 
    
    s ATypeCode=$e(ATypeCode,3,$l(ATypeCode))   //去掉CG
    s AMRItemID=""  //通过TypeCode获取MRItemID TypeParams 固定=1
    s AMRItemID=##Class(DHCEPRFS.BL.BLMRItem).GetItemIDByType(ATypeCode,"1")
    q:(AMRItemID="") $$$OK
    
    s ftpConfig = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("FTPConfig")
    s mrVerItemID = ##class(DHCEPRFS.BL.BLMRVerItem).GetVerItemByItemIDAndEpisodeID(AEpisodeID,AMRItemID)
    q:(mrVerItemID="") $$$OK
    s Remark1=""
    for {
        s Remark1 = $o(^DHCEPRFS.INST.MRVerSubItemI("IdxMRVerItemID"," "_mrVerItemID,Remark1))
        q:(Remark1="")
        s rowID=$o(^DHCEPRFS.INST.MRVerSubItemI("IdxMRVerItemID"," "_mrVerItemID,Remark1,""),-1) //取最后的RowId
        s detailNum = ""
        s detailNum = $o(^DHCEPRFS.INST.MRVerSubItemDtlI("IdxMain",rowID,detailNum),-1)
        continue:(detailNum="")
        s rowIDSubItem = ""
        s rowIDSubItem = $o(^DHCEPRFS.INST.MRVerSubItemDtlI("IdxMain",rowID,detailNum,rowIDSubItem))
        s rowIDSub = rowID_"||"_rowIDSubItem
        s obj = ##class(DHCEPRFS.INST.MRVerSubItemDetail).%OpenId(rowIDSub)
        s FileMasterID = obj.FileMasterID
		s fileInfo = ##Class(DHCEPRFS.BL.BLFileMaster).GetFullFileLocName(FileMasterID)
		s ftpConfig = $p(fileInfo,"@@@",1)
		s fileLocPath = $p(fileInfo,"@@@",2)
		
		//支持FTPS
		s ftpMethod = ""
		if ($zcvt($p(ftpConfig,"^",1),"U") = "FTPS")
		{ s ftpMethod ="ftps" }
		else
		{ s ftpMethod ="ftp" }
		
		s path= ftpMethod_"://"_$p(ftpConfig,"^",4)_":"_$p(ftpConfig,"^",5)_"@"_$p(ftpConfig,"^",2)_":"_$p(ftpConfig,"^",3)_"/"_fileLocPath
        
        s ^CacheTemp(repid,ind) = $lb(Remark1,path)
        s ind = ind + 1
    }
    
 q $$$OK
}

ClassMethod GetItemVerSubPathFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetItemVerSubPathExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
        Set AtEnd=1
        Set Row=""
        kill ^CacheTemp(repid)
    }
    Else      {             // fetch row
        Set Row=^CacheTemp(repid,ind)
    }
    // Save QHandle
    s qHandle=$lb(AtEnd,repid,ind)  
    Quit $$$OK
}

ClassMethod GetItemVerSubPathClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetItemVerSubPathExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Debug:  w ##Class(DHCEPRFS.BL.BLMRVerSubItem).HaveVerSubItem("3850948","702")
ClassMethod HaveVerSubItem(AEpisodeID As %String, AMRItemID As %String) As %String
{
    s mrVerItemID = ##class(DHCEPRFS.BL.BLMRVerItem).GetVerItemByItemIDAndEpisodeID(AEpisodeID,AMRItemID)
    q:(mrVerItemID="") "0"
    
    s Remark1 = $o(^DHCEPRFS.INST.MRVerSubItemI("IdxMRVerItemID"," "_mrVerItemID,""))
    if (Remark1="")
    {
         q "0"
    }
    else
    {
        q "1"   
    }
}

/// Desc:	获取指定的MRVerItem病历项目
/// Input:	MRVerItem的ID串，以^分隔
/// Debug: do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMRVerSubItem","GetMRVerSubItem","")
Query GetMRVerSubItem(AMRVerItemID As %String) As %Query(ROWSPEC = "MRVerItemID:%String,MRVerSubItemID:%String,FileSubUniqueID:%String,Remark1:%String,Remark2:%String,Remark3:%String,Remark4:%String,Remark5:%String,TotCount:%String")
{
}

ClassMethod GetMRVerSubItemExecute(ByRef qHandle As %Binary, AMRVerItemID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1

	s mrVerSubItemUnique = ""
	for {
		s mrVerSubItemUnique = $o(^DHCEPRFS.INST.MRVerSubItemI("IdxMain"," "_AMRVerItemID,mrVerSubItemUnique))
		q:(mrVerSubItemUnique = "")
		
		s mrVerSubItemID = ""
		for {
			s mrVerSubItemID = $o(^DHCEPRFS.INST.MRVerSubItemI("IdxMain"," "_AMRVerItemID,mrVerSubItemUnique,mrVerSubItemID))
			q:(mrVerSubItemID = "")		
			
			s objMRVerSubItem = ##class(DHCEPRFS.INST.MRVerSubItem).%OpenId(mrVerSubItemID)
			s FileSubUniqueID = objMRVerSubItem.FileSubUniqueID
			s Remark1 = objMRVerSubItem.Remark1
			s Remark2 = objMRVerSubItem.Remark2
			s Remark3 = objMRVerSubItem.Remark3
			s Remark4 = objMRVerSubItem.Remark4
			s Remark5 = objMRVerSubItem.Remark5
			s TotCount = objMRVerSubItem.TotCount
	
			s ^CacheTemp(repid,ind) = $lb(AMRVerItemID,mrVerSubItemID,FileSubUniqueID,Remark1,Remark2,Remark3,Remark4,Remark5,TotCount)
			s ind=ind+1 
		}
	}
	
	Quit $$$OK
}

ClassMethod GetMRVerSubItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMRVerSubItemExecute ]
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

ClassMethod GetMRVerSubItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMRVerSubItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
