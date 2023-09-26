Class DHCEPRFS.BL.BLMRViewItem Extends %RegisteredObject
{

/// Desc: yangshun 2022-7-21 根据描述模糊查询相关的归档项目
/// Return: 返回结果存在局部全局变量^||TmpMRItemTree，使用完记得kill
/// Debug: d ##class(DHCEPRFS.web.eprajax.AjaxConfigMRViewItem).GetMRItemTree("知情同意书")
ClassMethod BuildMRViewItemTree(ADesc As %String)
{
	s desc = "1111"
	s:(ADesc'="") desc = "%"_ADesc_"%"
	&sql(DECLARE MRItemTreeCorsor Cursor FOR
	SELECT ID into :mritemid FROM DHCEPRFS_META.MRItem WHERE
	Name Like :desc)
	s ret = $SortBegin(^||TmpMRItemTree)
	&sql(OPEN MRItemTreeCorsor)
	for
	{
		&sql(FETCH MRItemTreeCorsor)
		q:SQLCODE
		s mrItemObj = ##class(DHCEPRFS.META.MRItem).%OpenId(mritemid)
		s mrItemDesc = mrItemObj.Description
		s subCategoryID = mrItemObj.MRSubCategoryID
		continue:(subCategoryID="")
		s mrSubCategory = ##class(DHCEPRFS.META.MRSubCategory).%OpenId(subCategoryID)
		continue:(mrSubCategory="")
		s mrSubCategoryName = mrSubCategory.Name
		s categoryID = mrSubCategory.MRCategoryID
		continue:(categoryID="")
		s category = ##class(DHCEPRFS.META.MRCategory).%OpenId(categoryID)
		continue:(category="")
		s categoryName = category.Name
		s ^||TmpMRItemTree(categoryID,subCategoryID,mritemid)=""	
	}
	&sql(CLOSE MRItemTreeCorsor)
	s ret = $SortEnd(^||TmpMRItemTree)
}

/// Desc: yangshun 2022-7-19 修改或新增MRViewCategory
/// Input: AID MRViewCategory的id，若为空则新增；ACode，AName，ADesc，ASequence 基本信息
/// Return: 0 失败；1 成功
/// Debug: w ##class(DHCEPRFS.web.eprajax.AjaxConfigMRViewItem).AddOrUpdateMRViewCategory("","","","","")
ClassMethod AddOrUpdateMRViewCategory(AID As %String, ACode As %String, AName As %String, ADesc As %String, ASequence As %String) As %String
{
	s ret = "0"
	ts
	if (AID'="")
	{
		s obj = ##class(DHCEPRFS.META.MRViewCategory).%OpenId(AID)
		q:(obj="") ret
		if (ACode'=obj.Code)
		{
			s subID = ""
			for
			{
				s subID = $O(^DHCEPRFS.META.MRViewSubCategoryI("IdxParent"," "_obj.Code,subID))
				q:(subID="")
				s subObj = ##class(DHCEPRFS.META.MRViewSubCategory).%OpenId(subID)
				s subObj.ParentCode = ACode
				d subObj.%Save()
			}
		}
	}
	else
	{
		s obj = ##class(DHCEPRFS.META.MRViewCategory).%New()
	}
	s obj.Code = ACode
	s obj.Name = AName
	s obj.Description = ADesc
	s obj.Sequence = ASequence
	s ok = obj.%Save()
	
	if ($$$ISOK(ok))
	{ 
		tc
		q obj.%Id()
	}
	else
	{
		tro
		q ret
	}
}

/// Desc: yangshun 2022-7-19 根据id删除MRViewCategory，以及删除其关联的MRViewSubCategory及其关联的MRViewItem
/// Return: 1 成功；0 失败
ClassMethod DelMRViewCategory(AID As %String) As %String
{
	s ret = "1"
	s obj = ##class(DHCEPRFS.META.MRViewCategory).%OpenId(AID)
	q:(obj="") ret
	s code = " "_obj.Code
	s subid = ""
	ts
	for
	{
		s subid = $O(^DHCEPRFS.META.MRViewSubCategoryI("IdxParent",code,subid))
		q:(subid="")
		s subObj = ##class(DHCEPRFS.META.MRViewSubCategory).%OpenId(subid)
		continue:(subObj="")
		s subCode =" "_subObj.Code
		s itemid = ""
		for
		{
			s itemid = $O(^DHCEPRFS.META.MRViewItemI("IdxParent",subCode,itemid))
			q:(itemid="")
			s ok = ##class(DHCEPRFS.META.MRViewItem).%DeleteId(itemid)
			if ($$$ISERR(ok))
			{
				s ret = "0"
				q
			}
		}
		q:(ret="0")
		s ok = ##class(DHCEPRFS.META.MRViewSubCategory).%DeleteId(subid)
		if ($$$ISERR(ok))
		{
			s ret = "0"
			q
		}
	}
	if (ret="0")
	{
		tro
		q ret
	}
	s ok = ##class(DHCEPRFS.META.MRViewCategory).%DeleteId(AID)
	if ($$$ISERR(ok))
	{
		tro
		s ret = "0"
	}
	else
	{
		tc
	}
	q ret
}

/// Desc: yangshun 2022-7-19 修改或新增MRViewSubCategory
/// Input: AID MRViewSubCategory对应的ID，若为空则新增；AParentCode 关联的MRViewCategory的Code；ACode 自己的Code；AName、ADesc，ASequence 该类的一些信息
/// Return: 0 失败 ； 1 成功
/// Debug: w ##class(DHCEPRFS.web.eprajax.AjaxConfigMRViewItem).AddOrUpdateMRViewCategory("","","","","")
ClassMethod AddOrUpdateMRViewSubCategory(AID As %String, AParentCode As %String, ACode As %String, AName As %String, ADesc As %String, ASequence As %String) As %String
{
	s ret = "0"
	ts
	if (AID'="")
	{
		s obj = ##class(DHCEPRFS.META.MRViewSubCategory).%OpenId(AID)
		q:(obj="") ret
		if (obj.Code'=ACode)
		{
			s mrItemId = ""
			for
			{
				s mrItemId = $O(^DHCEPRFS.META.MRViewItemI("IdxParent"," "_obj.Code,mrItemId))
				q:(mrItemId="")
				s mrItemObj = ##class(DHCEPRFS.META.MRViewItem).%OpenId(mrItemId)
				s mrItemObj.ParentCode = ACode
				d mrItemObj.%Save()
			}
		}
	}
	else
	{
		s obj = ##class(DHCEPRFS.META.MRViewSubCategory).%New()
	}
	s obj.ParentCode = AParentCode
	s obj.Code = ACode
	s obj.Name = AName
	s obj.Description = ADesc
	s obj.Sequence = ASequence
	s ok = obj.%Save()
	if ($$$ISOK(ok))
	{ 
		tc
	 	q obj.%Id()
	}
	else
	{
		tro
		q ret
	}
}

/// Desc: yangshun 2022-7-19 根据ID删除MRViewSubCategory，同时删除其关联的MRViewItem
/// Return: 1 成功；0 失败
ClassMethod DelMRViewSubCategory(AID As %String) As %String
{
	s ret = "1"
	s obj = ##class(DHCEPRFS.META.MRViewSubCategory).%OpenId(AID)
	q:(obj="") ret
	s code = " "_obj.Code
	
	ts
	s itemid = ""
	for
	{
		s itemid = $O(^DHCEPRFS.META.MRViewItemI("IdxParent",code,itemid))
		q:(itemid="")
		s ok = ##class(DHCEPRFS.META.MRViewItem).%DeleteId(itemid)
		if ($$$ISERR(ok))
		{
			s ret = "0"
			q
		}
	}
	if (ret="0")
	{
		tro
		q ret
	}
	s ok = ##class(DHCEPRFS.META.MRViewSubCategory).%DeleteId(AID)
	if ($$$ISERR(ok))
	{
		tro
		s ret = "0"
	}
	else
	{
		tc
	}
	q ret
}

/// Desc: yangshun 2022-7-19 添加或修改MRViewItem
/// Input: AID MRViewItem的id，若为空则为新增；AParentCode 关联的MRViewSubCategory的Code；Name 名称；AMRItemID 关联的归档项目；ASequence 排序位置
/// Return: 0 失败 ；其他数字为成功返回的id
/// Debug: w ##class(DHCEPRFS.web.eprajax.AjaxConfigMRViewItem).AddOrUpdateMRViewCategory("","","","","")
ClassMethod AddOrUpdateMRViewItem(AID As %String, AParentCode As %String, AName As %String, AMRItemID As %String, ASequence As %String) As %String
{
	s ret = "0"
	if (AID'="")
	{
		s obj = ##class(DHCEPRFS.META.MRViewItem).%OpenId(AID)
		q:(obj="") ret
	}
	else
	{
		s obj = ##class(DHCEPRFS.META.MRViewItem).%New()
	}
	
	s obj.ParentCode = AParentCode
	s obj.Name = AName
	s obj.MRItemID = AMRItemID
	s obj.Sequence = ASequence
	s ok = obj.%Save()
	q:($$$ISOK(ok)) obj.%Id()
	q ret
}

/// Desc: yangshun 2022-7-19 根据ids批量删除MRViewItem
ClassMethod DelMRViewMRItem(AIDs As %String) As %String
{
	s ret = "1"
	ts
	for i=1:1:$L(AIDs,"^")
	{
		s ok = ##class(DHCEPRFS.META.MRViewItem).%DeleteId($P(AIDs,"^",i))
		if ($$$ISERR(ok))
		{
			s ret = "0"
			q
		}
	}
	if (ret="1")
	{
		tc
	}
	else
	{
		tro
	}
	q ret
}

/// Desc: yangshun 2022-7-21 批量给MRViewSubCategory添加实例MRViewItem
/// Input: AParentCode MRViewSubCategory的Code，AMRItems 实例子项对应的归档项目ids
/// Return: 1 成功 0 失败
/// Debug: w ##class(DHCEPRFS.BL.BLMRViewItem).AddMRViewItemBatch("NS005_SUB_1","38#检查报告#0^39#超声#0^40#放射#0^41#核医学#0^42#内镜#0^43#核磁#0^44#病理#0^45#心电#0^59#入院记录 入院记录#0^872#入院记录 入院记录#0^875#再次入院记录 再次入院记录（新生儿科）#0^1128#入院记录 入院记录#0^1131#入院记录（脑梗死） 入院记录（脑梗死）#0^1664#入院记录 入院记录#0^1665#24小时内出入院记录 24小时入出院记录#0^2301#入院记录（康复科） 入院记录（康复科）#0")
ClassMethod AddMRViewItemBatch(AParentCode As %String, AMRItems As %String) As %String
{
	s id = $O(^DHCEPRFS.META.MRViewSubCategoryI("IdxCode"," "_AParentCode,""))
	q:(id="") "0"
	s success = 0
	s total = $L(AMRItems,"^")
	for i=1:1:total
	{
		s mrItem = $P(AMRItems,"^",i)
		s mrItemID = $P(mrItem,"#",1)
		s mrItemName = $P(mrItem,"#",2)
		s mrItemSequence = $P(mrItem,"#",3)
		s mrviewId = ""
		s hasFlag = "0"
		for
		{
			s mrviewId = $O(^DHCEPRFS.META.MRViewItemI("IdxMain"," "_mrItemID,mrviewId))
			q:(mrviewId="")
			s obj = ##class(DHCEPRFS.META.MRViewItem).%OpenId(mrviewId)
			if (obj.ParentCode=AParentCode)
			{
				s hasFlag="1"
				s success = success+1
				q
			}
		}
		if (hasFlag="0")
		{
			s obj = ##class(DHCEPRFS.META.MRViewItem).%New()
			s obj.MRItemID = mrItemID
			s obj.Name = mrItemName
			s obj.ParentCode = AParentCode
			s obj.Sequence = mrItemSequence
			s ok = obj.%Save()
			s:($$$ISOK(ok)) success = success+1
		}
		
	}
	q:(success=total) "1"
	q "0"
}

/// Desc: 根据就诊号与网站地址获取患者的病历分类排序树
/// Input: AEpisodeID 就诊号 ADataServiceUrl 网站地址
/// Return: 返回结果存在局部全局变量^||DHCEPRFSMRViewItemTree里面，调用完这个方法使用后记得kill
/// Debug: d ##class(DHCEPRFS.web.eprajax.AjaxConfigMRViewItem).GetMRViewTreeByEpisodeID("82323453","")
ClassMethod GetMRViewTreeByEpisodeID(AEpisodeID As %String, ADataServiceUrl As %String)
{
	s mrEpisodeID = ##class(DHCEPRFS.BL.BLMREpisode).GetMREpisodeIDByAdm(AEpisodeID,"DHC")
	q:(mrEpisodeID = "")
	s mrVersionID = ##class(DHCEPRFS.BL.BLMRVersion).GetMRVersionID(mrEpisodeID,"0")
	q:(mrVersionID = "")
	s dataServiceUrl = ADataServiceUrl
	s:(dataServiceUrl = "") dataServiceUrl = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("WebURL")
	s mrItemID = ""
	kill ^||DHCEPRFSMRViewItemTree
	s ret = $SortBegin(^||DHCEPRFSMRViewItemTree)
	for
	{
		s mrItemID = $o(^DHCEPRFS.INST.MRVerItemI("IdxMain"," "_mrVersionID,mrItemID))
		q:mrItemID=""
		s mrVerItemID = $o(^DHCEPRFS.INST.MRVerItemI("IdxMain"," "_mrVersionID,mrItemID,""))
		continue:mrVerItemID=""
		s detailNum = ""
		s detailNum = $o(^DHCEPRFS.INST.MRVerItemDetailI("IdxMain",mrVerItemID,detailNum),-1)
		continue:(detailNum = "")
		s subID = ""
		s subID = $o(^DHCEPRFS.INST.MRVerItemDetailI("IdxMain",mrVerItemID,detailNum,subID))
		continue:(subID = "")
		s mrVerItemDetailID = mrVerItemID_"||"_subID
		s objMRVerItemDetail = ##class(DHCEPRFS.INST.MRVerItemDetail).%OpenId(mrVerItemDetailID)
		s fileMasterID = objMRVerItemDetail.FileMasterID
		d objMRVerItemDetail.%Close()
		s encryptFileID = ##class(web.Util.Encryption).SimpleEncrypt(fileMasterID)
		s httpFilePath = dataServiceUrl_"DHCEPRFS.Util.PDFView.cls?FileID="_encryptFileID
		s viewItemID = $O(^DHCEPRFS.META.MRViewItemI("IdxMain",mrItemID,""))
		
		
		s parentName = ""
		s parentCode = ""
		s parentSequence = ""
		s ppName = ""
		s ppCode = ""
		s ppSequence = ""
		s sequence = ""
		s name = ""
		
		if ((viewItemID'="")&&(viewItemID'=0))
		{
			s viewItemObj = ##class(DHCEPRFS.META.MRViewItem).%OpenId(viewItemID)
			s parentCode = viewItemObj.ParentCode
			s sequence = viewItemObj.Sequence
			s name = viewItemObj.Name
		}
		continue:(parentCode="")
		&sql(select Name,Sequence,ParentCode INTO :parentName,:parentSequence,:ppCode FROM dhceprfs_meta.mrviewsubcategory where Code [:parentCode)
		continue:((parentName="")||(parentSequence="")||(ppCode=""))
		&sql(select Name,Sequence INTO :ppName,:ppSequence from dhceprfs_meta.mrviewcategory where Code [ :ppCode)
		continue:((ppName="")||(ppSequence=""))
		s ^||DHCEPRFSMRViewItemTree(ppSequence) = ppCode_"^"_ppName
		s ^||DHCEPRFSMRViewItemTree(ppSequence,parentSequence)=parentCode_"^"_parentName
		s ^||DHCEPRFSMRViewItemTree(ppSequence,parentSequence,sequence) = $lb(name,$tr(mrItemID," ",""),httpFilePath)
		
	}
	s ret = $SortEnd(^||DHCEPRFSMRViewItemTree)
}

}
