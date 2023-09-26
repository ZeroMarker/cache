Class DHCEPRFS.BL.BLMRVerSubItemDetail Extends %RegisteredObject [ ProcedureBlock ]
{

ClassMethod GetMaxDetailNum(AMRVerSubItemID As %String) As %String
{
	s detailNum = ""
	s detailNum = $o(^DHCEPRFS.INST.MRVerSubItemDtlI("IdxMain",AMRVerSubItemID,detailNum),-1)
	q detailNum
}

/// Desc:	注册MRVerSubItem对象并获取其RowID
/// Debug:	w ##Class(DHCEPRFS.BL.BLMRVerSubItem).RegMRVerSubItemDetailID("1","1","7")
ClassMethod RegMRVerSubItemDetailID(AMRVerSubItemID As %String, ADetailNum As %String, AFileMasterID As %String, AFileMasterPath As %String, ATotalCount As %String) As %String
{
	//b "s"
	//处理入参
	s ATotalCount = +ATotalCount
	
	//获取MRVerSubItemDetailID
	s mrVerSubItemDetailID = ..GetMRVerSubItemDetailID(AMRVerSubItemID, ADetailNum)
	
	//mrVerSubItemDetailID不存在，创建
	if (mrVerSubItemDetailID = "")
	{
		s mrVerSubItemDetailID = ..CreateMRVerSubItemDetail(AMRVerSubItemID, ADetailNum, AFileMasterID, AFileMasterPath, ATotalCount)
	}
	else
	{
		s sc = ..UpdateMRVerSubItemDetail(mrVerSubItemDetailID, AFileMasterID, AFileMasterPath, ATotalCount)
		if (sc '= "1")
		{
			s mrVerSubItemDetailID = ""
		}
	}
	
	q mrVerSubItemDetailID
}

/// Desc:	获取MRVerItemID
ClassMethod GetMRVerSubItemDetailID(AMRVerSubItemID As %String, ADetailNum As %String) As %String
{
	q:(AMRVerSubItemID="")||(ADetailNum="") ""
	
	//索引内容前面没有空格
	s childSub = $O(^DHCEPRFS.INST.MRVerSubItemDtlI("IdxMain", AMRVerSubItemID, ADetailNum, ""))
	if (childSub = "")
	{
		q ""
	}
	else
	{
		q AMRVerSubItemID_"||"_childSub
	}
}

/// Desc:	创建MRVerItem
ClassMethod CreateMRVerSubItemDetail(AMRVerSubItemID As %String, ADetailNum As %String, AFileMasterID As %String, AFileMasterPath As %String, ATotalCount As %String) As %String
{
	//b "s"
	s objItem = ##Class(DHCEPRFS.INST.MRVerSubItem).%OpenId(AMRVerSubItemID)
	q:(objItem = "") ""
	s now = $h
	
	s objDetail = ##Class(DHCEPRFS.INST.MRVerSubItemDetail).%New()
	s objDetail.TheMRVerSubItem = objItem
	s objDetail.DetailNum = ADetailNum
	s objDetail.FileMasterID = AFileMasterID
	s objDetail.FileMasterPath = AFileMasterPath
	s objDetail.Flag = ""
	s objDetail.CreateDate = $p(now, ",", 1)
	s objDetail.CreateTime = $p(now, ",", 2)
	s objDetail.ModifyDate = $p(now, ",", 1)
	s objDetail.ModifyTime = $p(now, ",", 2)
	s uniqueID = $p(AFileMasterPath,".",1)
	if ($l(uniqueID,"/") > 1)
	{
		s uniqueID = $p(uniqueID,"/",$l(uniqueID,"/"),$l(uniqueID,"/"))
	}
	s objDetail.FileSubDetailUniqueID = uniqueID
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

/// Desc:	创建MRVerItem
ClassMethod UpdateMRVerSubItemDetail(AMRVerSubItemDetailID As %String, AFileMasterID As %String, AFileMasterPath As %String, ATotalCount As %String) As %String
{
	s objDetail = ##Class(DHCEPRFS.INST.MRVerSubItemDetail).%OpenId(AMRVerSubItemDetailID)
	q:(objDetail = "") "0"
	s now = $h
	
	s objDetail.FileMasterID = AFileMasterID
	s objDetail.FileMasterPath = AFileMasterPath
	s objDetail.ModifyDate = $p(now, ",", 1)
	s objDetail.ModifyTime = $p(now, ",", 2)
	s uniqueID = $p(AFileMasterPath,".",1)
	if ($l(uniqueID,"/") > 1)
	{
		//s uniqueID = $p(uniqueID,"/",$l(uniqueID,"/") -1,$l(uniqueID,"/")) 好像不对吧
		s uniqueID = $p(uniqueID,"/",$l(uniqueID,"/"),$l(uniqueID,"/"))
	}
	s objDetail.FileSubDetailUniqueID = uniqueID
	s status = objDetail.%Save()
	if ($$$ISOK(status))
	{
		//q objDetail.%Id() 返回“1”
		q "1"
	}
	else
	{
		q "0"
	}
}

}
