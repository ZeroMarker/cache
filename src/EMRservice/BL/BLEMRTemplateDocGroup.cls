///  名称：		EMRservice.BL.BLEMRTemplateGroup
///  描述：		病历模板分组BL层
///  编写者：	yejian
///  编写时间：	2016-9-20
Class EMRservice.BL.BLEMRTemplateDocGroup Extends (%RegisteredObject, %XML.Adaptor)
{

/// 根据科室ID获取所有分组
/// /////////病历模板////////////
/// Debug:	d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLEMRTemplateDocGroup","GetEMRTemplateGroup","10")
Query GetEMRTemplateGroup(ACtLocID As %String) As %Query(ROWSPEC = "ID:%Integer,GroupCode:%String,GroupName:%String,CTLocID:%String,ParentID:%String,Sequence:%Integer")
{
}

ClassMethod GetEMRTemplateGroupExecute(ByRef qHandle As %Binary, ACtLocID As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	q:((($g(ACtLocID) = "")||(ACtLocID=$c(0)))) $$$OK
	//取出通用分组
	s rowID = ""
	for {
		s rowID = $o(^DHCEMRM.EMRTemplateDocGroupI("IdxCTLocID"," 0",rowID))
		q:(rowID = "")
		s objEMRTemplateGroup = ##Class(EMRmeta.EMRTemplateDocGroup).%OpenId(rowID)
		continue:(objEMRTemplateGroup = "")
	
		s GroupCode = objEMRTemplateGroup.GroupCode
		s GroupName = objEMRTemplateGroup.GroupName
		s CTLocID = objEMRTemplateGroup.CTLocID
		s ParentID = objEMRTemplateGroup.ParentID
		s Sequence = objEMRTemplateGroup.Sequence
	
		s Data = $lb(rowID,GroupCode,GroupName,CTLocID,ParentID,Sequence)
		s ^CacheTemp(repid,ind) = Data
		s ind = ind + 1	
	}
	//取科室分组
	s rowID = ""
	for {
		if ((ACtLocID '="")&&(ACtLocID'=$c(0)))
		{
			s rowID = $o(^DHCEMRM.EMRTemplateDocGroupI("IdxCTLocID"," "_$g(ACtLocID),rowID))
		}
		q:(rowID = "")
		s objEMRTemplateGroup = ##Class(EMRmeta.EMRTemplateDocGroup).%OpenId(rowID)
		continue:(objEMRTemplateGroup = "")
	
		s GroupCode = objEMRTemplateGroup.GroupCode
		s GroupName = objEMRTemplateGroup.GroupName
		s CTLocID = objEMRTemplateGroup.CTLocID
		s ParentID = objEMRTemplateGroup.ParentID
		s Sequence = objEMRTemplateGroup.Sequence
	
		s Data = $lb(rowID,GroupCode,GroupName,CTLocID,ParentID,Sequence)
		s ^CacheTemp(repid,ind) = Data
		s ind = ind + 1	
	}
	
	q $$$OK
}

ClassMethod GetEMRTemplateGroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEMRTemplateGroupExecute ]
{
	s AtEnd=$list(qHandle,1)
 	s repid=$list(qHandle,2)
 	s ind=$list(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	if ind="" {	
 		s AtEnd=1
 		s Row=""
 		k ^CacheTemp(repid)
 	} else {
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetEMRTemplateGroupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEMRTemplateGroupExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 根据科室ID获取所有分组明细
/// /////////病历模板////////////
/// Debug:	d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLEMRTemplateGroup","GetEMRTemplateGroupItem","50")
Query GetEMRTemplateGroupItem(ACtLocID As %String) As %Query(ROWSPEC = "ID:%Integer,GroupID:%String,DocID:%String,Sequence:%Integer")
{
}

ClassMethod GetEMRTemplateGroupItemExecute(ByRef qHandle As %Binary, ACtLocID As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	q:((($g(ACtLocID) = "")||(ACtLocID=$c(0)))) $$$OK
	//查模板通用分组
	s rowID = ""
	for {
		s rowID = $o(^DHCEMRM.EMRTemplateDocGroupI("IdxCTLocID"," 0",rowID))
		
		q:(rowID = "")
		s objEMRTemplateGroup = ##Class(EMRmeta.EMRTemplateDocGroup).%OpenId(rowID)
		continue:(objEMRTemplateGroup = "")
		s GroupCode = objEMRTemplateGroup.GroupCode
		s gdRowID = ""
		for {
			s gdRowID = $o(^DHCEMRM.EMRTemDGroupItemI("IdxGroupID"," "_$g(rowID),gdRowID))
			q:(gdRowID = "")
			s objGroupItem = ##Class(EMRmeta.EMRTemplateDocGroupItem).%OpenId(gdRowID)
			continue:(objGroupItem = "")
			s GroupID = objGroupItem.GroupID
			s DocID = objGroupItem.DocID
			s Sequence = objGroupItem.Sequence

			s Data = $lb(gdRowID,GroupID,DocID,Sequence)
			s ^CacheTemp(repid,ind) = Data
			s ind = ind + 1	
		}
	}
	//查模板科室分组
	s rowID = ""
	for {
		if ((ACtLocID '="")&&(ACtLocID'=$c(0)))
		{
			s rowID = $o(^DHCEMRM.EMRTemplateDocGroupI("IdxCTLocID"," "_$g(ACtLocID),rowID))
		}
		q:(rowID = "")
		s objEMRTemplateGroup = ##Class(EMRmeta.EMRTemplateDocGroup).%OpenId(rowID)
		continue:(objEMRTemplateGroup = "")
		s GroupCode = objEMRTemplateGroup.GroupCode
		s gdRowID = ""
		for {
			s gdRowID = $o(^DHCEMRM.EMRTemDGroupItemI("IdxGroupID"," "_$g(rowID),gdRowID))
			q:(gdRowID = "")
			s objGroupItem = ##Class(EMRmeta.EMRTemplateDocGroupItem).%OpenId(gdRowID)
			continue:(objGroupItem = "")
			s GroupID = objGroupItem.GroupID
			s DocID = objGroupItem.DocID
			s Sequence = objGroupItem.Sequence

			s Data = $lb(gdRowID,GroupID,DocID,Sequence)
			s ^CacheTemp(repid,ind) = Data
			s ind = ind + 1	
		}
	}
	
	q $$$OK
}

ClassMethod GetEMRTemplateGroupItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEMRTemplateGroupItemExecute ]
{
	s AtEnd=$list(qHandle,1)
 	s repid=$list(qHandle,2)
 	s ind=$list(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	if ind="" {	
 		s AtEnd=1
 		s Row=""
 		k ^CacheTemp(repid)
 	} else {
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetEMRTemplateGroupItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEMRTemplateGroupItemExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 得到最大code编号
ClassMethod GetMaxID() As %String
{
	//s IdexCode=0
	&sql(select max(id) into :IdexCode   from EMRmeta.EMRTemplateDocGroup)
	s:(IdexCode="") IdexCode=0
	q IdexCode
}

/// 根据ID获取病历模板
ClassMethod GetEMRTemplateGroupByID(ARowID As %String) As EMRservice.entity.EEMRTemplateDocGroup
{
	s objEMRTemplateC = ##Class(EMRmeta.EMRTemplateDocGroup).%OpenId(ARowID)
	q:(objEMRTemplateC = "") ""
	
	s Result = ##Class(EMRservice.entity.EEMRTemplateDocGroup).%New()
	s Result.ID = objEMRTemplateC.%Id()
	s Result.CTLocID = objEMRTemplateC.CTLocID
	s Result.GroupCode = objEMRTemplateC.GroupCode
	s Result.GroupName = objEMRTemplateC.GroupName
	s Result.ParentID = objEMRTemplateC.ParentID
	s Result.Sequence = objEMRTemplateC.Sequence

	q Result
}

/// 检查病历模板分组
ClassMethod CheckEMRTemplateGroup(GroupCode As %String) As %String
{
	s rowID = ""
    s rowID = $o(^DHCEMRM.EMRTemplateDocGroupI("IdxGroupCode"," "_$zcvt(GroupCode,"U"),rowID))
	q rowID
}

/// 添加病历模板分组
ClassMethod AddEMRTemplateGroup(AEMRTemplateC As EMRservice.entity.EEMRTemplateDocGroup) As %String
{
	TStart
	s ret = 1
	s objEMRTemplateC = ##Class(EMRmeta.EMRTemplateDocGroup).%New()
	s objEMRTemplateC.CTLocID = AEMRTemplateC.CTLocID
	s objEMRTemplateC.GroupCode = AEMRTemplateC.GroupCode
	s objEMRTemplateC.GroupName = AEMRTemplateC.GroupName
	s objEMRTemplateC.ParentID = AEMRTemplateC.ParentID
	if (objEMRTemplateC.%Save())
	{
		s ret=objEMRTemplateC.%Id()
		s objEMRTemplateC.Sequence=ret
		if (objEMRTemplateC.%Save())
		{
			 TCommit
		}
		else
		{
			TRollback
			s ret=0
		}
	}
	else
	{
		TRollback
		s ret=0
	}

	d objEMRTemplateC.%Close()	
	k objEMRTemplateC
	q ret
}

/// 修改病历模板分组
ClassMethod ModEMRTemplateGroup(AEMRTemplateC As EMRservice.entity.EEMRTemplateDocGroup) As %Boolean
{
	
	s ret = 1
	s objEMRTemplateC = ##Class(EMRmeta.EMRTemplateDocGroup).%OpenId(AEMRTemplateC.ID)
	;s CateCodeOld = objEMRTemplateC.GroupCode
	;s objEMRTemplateC.GroupCode = AEMRTemplateC.GroupCode
	s objEMRTemplateC.CTLocID = AEMRTemplateC.CTLocID
	s objEMRTemplateC.GroupName = AEMRTemplateC.GroupName
	if '(objEMRTemplateC.%Save())
	{
		s ret=0
	}	
	d objEMRTemplateC.%Close()
	q ret
}

/// 根据ID获取病历模板分组子项
ClassMethod GetEMRTemplateGroupItemByCode(AGroupID As %String, ADocID As %String) As EMRservice.entity.EEMRTemplateDocGroupItem
{
	s ARowID = ""
	s ARowID = $o(^DHCEMRM.EMRTemDGroupItemI("IdxCode"," "_AGroupID," "_$zcvt(ADocID,"U"),ARowID))
	q:(ARowID = "") ""
	s objEMRTemplateC = ##Class(EMRmeta.EMRTemplateDocGroupItem).%OpenId(ARowID)
	q:(objEMRTemplateC = "") ""
	
	s Result = ##Class(EMRservice.entity.EEMRTemplateDocGroupItem).%New()
	s Result.ID = objEMRTemplateC.%Id()
	s Result.GroupID = objEMRTemplateC.GroupID
	s Result.DocID = objEMRTemplateC.DocID
	s Result.Sequence = objEMRTemplateC.Sequence


	q Result
}

/// 添加病历模板分组
ClassMethod UpEMRTemplateGroupItem(ADocID As %String, oldGroupID As %String, newGroupID As %String) As %Boolean
{
	TStart
	s ret = 1
	s objGroupItem =""
	q:(ADocID =""||oldGroupID=""||newGroupID = "") ret
	if (newGroupID =0)
	{
		s dRowID = $o(^DHCEMRM.EMRTemDGroupItemI("IdxCode"," "_$zcvt(oldGroupID,"U")," "_$zcvt(ADocID,"U"),""))
		q:(dRowID ="") ret
		s objGroupItem = ##Class(EMRmeta.EMRTemplateDocGroupItem).%OpenId(dRowID)
		if '(objGroupItem.%DeleteId(dRowID))
		{
			TROLLBACK
			s ret = 0
		}
	}
	elseif (oldGroupID = 0)
	{
		s objGroupItem = ##Class(EMRmeta.EMRTemplateDocGroupItem).%New()
		s objGroupItem.DocID = ADocID
		s objGroupItem.GroupID = newGroupID
		if (objGroupItem.%Save())
		{
			s DetID=objGroupItem.%Id()
			s objGroupItem.Sequence=DetID
			if '(objGroupItem.%Save())
			{
				TRollback
				s ret=0
			}
		}
		else
		{
			TRollback
			s ret=0
		}
	}
	else
	{
		s dRowID = $o(^DHCEMRM.EMRTemDGroupItemI("IdxCode"," "_$zcvt(oldGroupID,"U")," "_$zcvt(ADocID,"U"),""))
		q:(dRowID ="") ret
		s objGroupItem = ##Class(EMRmeta.EMRTemplateDocGroupItem).%OpenId(dRowID)
		if '(objGroupItem.%DeleteId(dRowID))
		{
			TROLLBACK
			s ret = 0
		}
		s objGroupItem = ##Class(EMRmeta.EMRTemplateDocGroupItem).%New()
		s objGroupItem.DocID = ADocID
		s objGroupItem.GroupID = newGroupID
		if (objGroupItem.%Save())
		{
			s DetID=objGroupItem.%Id()
			s objGroupItem.Sequence=DetID
			if '(objGroupItem.%Save())
			{
				TRollback
				s ret=0
			}
		}
		else
		{
			TRollback
			s ret=0
		}
	}
	
	if (ret=1)
	{
		TCOMMIT	
	}
	d objGroupItem.%Close()	
	k objGroupItem
	q ret
}

/// creator:yejian
/// CreatDate:2018-3-22
/// Description:修改树节点排序顺序号
/// Return: result是否操作成功
/// do ##class(EMRservice.BL.BLEMRTemplateGroup).SwapEMRTemplateCatSeq("1","2")
ClassMethod SwapEMRTemplateCatSeq(EMRTemplateGID1 As %String, EMRTemplateGID2 As %String) As %Boolean
{
	set result = 0
	set objNextTree = ##class(EMRmeta.EMRTemplateDocGroup).%OpenId(EMRTemplateGID1)
	set objSelectTree = ##class(EMRmeta.EMRTemplateDocGroup).%OpenId(EMRTemplateGID2)
	quit:((objNextTree = "")||(objSelectTree = "")) result
	
	set TempSequence = objNextTree.Sequence
	set objNextTree.Sequence = objSelectTree.Sequence
	set objSelectTree.Sequence = TempSequence
	
	set $zt = "SwapErrorHandler"
	Tstart
	set scResult=objNextTree.%Save() 
	if $$$ISERR(scResult)
	{
		Trollback
		quit result
	}
	set scResultSele=objSelectTree.%Save() 
	if $$$ISERR(objSelectTree)
	{
		Trollback
		quit result
	}
	TCOMMIT
	 do objSelectTree.%Close()
	 do objNextTree.%Close()
	 set objSelectTree = ""
	 set objNextTree = ""
	 set result = 1
	 quit result
	 
SwapErrorHandler
    quit 0
}

/// creator:yejian
/// CreatDate:2018-3-22
/// Description:修改树节点排序顺序号
/// Return: result是否操作成功
/// do ##class(EMRservice.BL.BLEMRTemplateGroup).SwapEMRTemplateItemSeq("1","2")
ClassMethod SwapEMRTemplateItemSeq(EMRTemplateGID1 As %String, EMRTemplateGID2 As %String) As %Boolean
{
	set result = 0
	set objNextTree = ##class(EMRmeta.EMRTemplateDocGroupItem).%OpenId(EMRTemplateGID1)
	set objSelectTree = ##class(EMRmeta.EMRTemplateDocGroupItem).%OpenId(EMRTemplateGID2)
	quit:((objNextTree = "")||(objSelectTree = "")) result
	
	set TempSequence = objNextTree.Sequence
	set objNextTree.Sequence = objSelectTree.Sequence
	set objSelectTree.Sequence = TempSequence
	
	set $zt = "SwapErrorHandler"
	Tstart
	set scResult=objNextTree.%Save() 
	if $$$ISERR(scResult)
	{
		Trollback
		quit result
	}
	set scResultSele=objSelectTree.%Save() 
	if $$$ISERR(objSelectTree)
	{
		Trollback
		quit result
	}
	TCOMMIT
	 do objSelectTree.%Close()
	 do objNextTree.%Close()
	 set objSelectTree = ""
	 set objNextTree = ""
	 set result = 1
	 quit result
	 
SwapErrorHandler
    quit 0
}

/// 删除病历模板分组
ClassMethod DelEMRTemplateGroup(AEMRTemplateCID As %String) As %String
{
	
	s ret = 0
	q:($g(AEMRTemplateCID) = "") ret
	TStart
	s ret = "1"
	s objEMRTemplateC = ##Class(EMRmeta.EMRTemplateDocGroup).%OpenId(AEMRTemplateCID)
	s strGroupCode = objEMRTemplateC.GroupCode
	///删除所有病历模板关联
	s GroupItemRowID = ""
	for {
		s GroupItemRowID = $o(^DHCEMRM.EMRTemDGroupItemI("IdxGroupID"," "_$zcvt(AEMRTemplateCID,"U"),GroupItemRowID))
		q:(GroupItemRowID = "")
	
		s objGroupDetal = ##Class(EMRmeta.EMRTemplateDocGroupItem).%OpenId(GroupItemRowID)
		if '(objGroupDetal.%DeleteId(GroupItemRowID))
		{
			TROLLBACK
			s ret = 0
			q
		}
	}
	if ('objEMRTemplateC.%DeleteId(AEMRTemplateCID))
	{
		TROLLBACK
		s ret = 0
	}
	else
	{
		 TCommit
		 s ret = 1
	}
	
	q ret
}

/// Desc:       按分类展现目录结构，显示模板
/// Creator:    Candy
/// CreateDate: 2018-3-9
/// Input:      ALocID 科室ID
///             AParentID 父节点
///             AKey 临时global节点位置
/// Output:     模板目录json流
/// Debug:      d ##Class(EMRservice.BL.BLEMRTemplateDocGroup).GetGroupTemplate(190,0,1)
ClassMethod GetGroupTemplate(ALocID As %String, AParentID As %String, AKey As %String, pText As %String = "") As %GlobalBinaryStream
{
	s json = ##Class(%GlobalBinaryStream).%New()
	q:(AParentID = "") json
	if (ALocID = "")
	{
		s locId = " 0"
		for
		{
			s locId = $o(^DHCEMRM.EMRTemplateDocGroupI("IdxLocSeq",locId))
			q:(locId = "")
			s tmpLocId = $tr(locId," ","")
			s result = ..GetGroupTemplateByLoc(tmpLocId,AParentID,AKey,pText)
			if ((result '= "")&&(result.Size>0))
			{
				d:(json.Size>0) json.Write(",")
				d json.CopyFrom(result)
			}
		}
	}
	else
	{
		d json.CopyFrom(..GetGroupTemplateByLoc(ALocID,AParentID,AKey,pText))
	}
	s tempJson = ..GetGroupTemplateByLoc("0",AParentID,AKey,pText)
	if ((tempJson '= "")&&(tempJson.Size>0))
	{
		d:(json.Size>0) json.Write(",")
		d json.CopyFrom(tempJson)
	}
	q json
}

/// Desc:      按分类展现目录结构，显示当前科室模板
/// Creator:    Candy
/// CreateDate: 2018-3-9
/// Input:      ALocID 科室ID
///            AParentID 父节点
///            AKey 临时global节点位置
/// Output:     模板目录json流
/// Debug:      d ##Class(EMRservice.BL.BLEMRTemplateDocGroup).GetGroupTemplateByLoc(190,0,1)
ClassMethod GetGroupTemplateByLoc(ALocID As %String, AParentID As %String, AKey As %String, pText As %String = "") As %GlobalBinaryStream
{
	s json = ##Class(%GlobalBinaryStream).%New()
	q:(AParentID = "")||(ALocID = "") json
	s seq = ""
	for
	{
		s seq = $o(^DHCEMRM.EMRTemplateDocGroupI("IdxLocSeq"," "_ALocID," "_AParentID,seq))
		q:(seq = "")
		s tempJson = ##Class(%GlobalBinaryStream).%New()
		s flag = "1"
		s rowId = ""
		for
		{
			s rowId = $o(^DHCEMRM.EMRTemplateDocGroupI("IdxLocSeq"," "_ALocID," "_AParentID,seq,rowId))
			q:(rowId = "")
			s obj = ##Class(EMRmeta.EMRTemplateDocGroup).%OpenId(rowId)
			continue:(obj = "")
			
			d:(json.Size > 0) tempJson.Write(",")
			s strGroupName = $zcvt(obj.GroupName,"O","JSON")
			d tempJson.Write("{")
			d tempJson.Write("""id"":"""_rowId_"""")
			d tempJson.Write(",""text"":"""_strGroupName_"""")
			d tempJson.Write(",""DocIDText"":"""_strGroupName_"""")
			d tempJson.Write(",""type"":""flod""")
			if (##Class(EMRservice.SystemParameter).GetListDisplayExpandType() = "collapse")&&(pText="")
			{
				d tempJson.Write(",""state"":""closed""")
			}
			d tempJson.Write(",""children"":[")
			s childJson = ..GetGroupTemplateByLoc(ALocID,rowId,AKey)
			s:(childJson.Size = 0) flag = "0"
			d tempJson.CopyFrom(childJson)
			s itemSeq = ""
			s itemCount = 0
			s tempDocIdJson = ##Class(%GlobalBinaryStream).%New()
			for
			{
				s itemSeq = $o(^DHCEMRM.EMRTemDGroupItemI("IdxSeq"," "_rowId, itemSeq))
				q:(itemSeq = "")
				s docId = ""
				for
				{
					s docId = $o(^DHCEMRM.EMRTemDGroupItemI("IdxSeq"," "_rowId, itemSeq,docId))
					q:(docId = "")

					s tmpDocId = $tr(docId," ","")
					continue:($d(^CacheTemp("GetTempCateJsonByCategoryID",AKey,"Flag",tmpDocId))<=0)					
					s flagRowId = ^CacheTemp("GetTempCateJsonByCategoryID",AKey,"Flag",tmpDocId)
					d:((childJson.Size >0)&&(itemCount =0)) tempDocIdJson.Write(",") 
					d:(itemCount '=0) tempDocIdJson.Write(",") 
					d tempDocIdJson.Write(^CacheTemp("GetTempCateJsonByCategoryID",AKey,flagRowId))
					s itemCount = itemCount +1
					k ^CacheTemp("GetTempCateJsonByCategoryID",AKey,"Flag",tmpDocId)
					k ^CacheTemp("GetTempCateJsonByCategoryID",AKey,flagRowId)
				}
			}
			s:(tempDocIdJson.Size '= "0") flag = "1"
			d tempJson.CopyFrom(tempDocIdJson)
			d tempJson.Write("]}")
		}
		if (flag = "1")
		{
			d json.CopyFrom(tempJson)
		}
	}
	q json
}

/// Desc:      按模板目录结构，显示知情告知结构
/// Creator:    yejian
/// CreateDate: 2018-3-9
/// Input:      ALocID 科室ID
///            AParentID 父节点
///            AKey 临时global节点位置
/// Output:     模板目录json流
/// Debug:      s json = ##Class(EMRservice.BL.BLEMRTemplateDocGroup).GetGroupAgreeTemplate(3)
/// 			d json.OutputToDevice()
ClassMethod GetGroupAgreeTemplate(AKey As %String) As %GlobalBinaryStream
{
	s jsonStream = ##Class(%GlobalBinaryStream).%New()
	s gourpArr = ##class(%ArrayOfDataTypes).%New()
	s tmpDocId = ""
	s tJsons = ""
	s intSeq =0
	s intCategoryID = 0
	s docGroup = ""
	s flagRowId =""
	for
	{
		s flagRowId = $o(^CacheTemp("GetTempCateJsonByCategoryID",AKey,"Seq",flagRowId))
		q:(flagRowId="")
		s tmpDocId =$o(^CacheTemp("GetTempCateJsonByCategoryID",AKey,"Seq",flagRowId,""))
		continue:(tmpDocId="")
		s objTemplate = ##Class(EMRservice.BL.BLTemplate).GetTemplateByEMRTmpCateID(tmpDocId)
	    continue:(objTemplate = "")
	    s intParentID = objTemplate.TemplateCategoryID	 
	    s structID = ##class(EMRservice.BL.BLEMRTemplateDocGroup).GetStructParentIDByID(intParentID)
	    s docStartEnd = gourpArr.GetAt(structID)
	    s docStartEnd = $case(docStartEnd,"":tmpDocId,:$p(docStartEnd,"^",1))
	    s docStartEnd =docStartEnd_"^"_tmpDocId
	    //记录同一个业务活动记录分类的"开始docid^结束docid"
	    d gourpArr.SetAt(docStartEnd,structID)   
	    //目录相同数据以^分隔
	    if (intCategoryID = intParentID)
	    {
		    s docGroup=$Case(docGroup,"":tmpDocId,:docGroup_"^"_tmpDocId)
	    }
	    else //目录不同以,分隔
	    {
		    s docGroup=$Case(docGroup,"":tmpDocId,:docGroup_","_tmpDocId)
		    s intCategoryID = intParentID
	    }
	}
	q:(docGroup="") jsonStream
	//获取目录对象集合
	s listObjs = ##Class(EMRservice.BL.BLEMRTemplateDocGroup).GetCateTemByDocID(docGroup)
	s blnMark =0
	s key =""
	for 
	{
		s item = listObjs.GetNext(.key)
		q:(item ="")
		if (item.ShowCategory = "0")
		{
			d:(key'=1) jsonStream.Write(",") 
			s intDocIDs = item.DocID
			s docjson = ##Class(EMRservice.BL.BLEMRTemplateDocGroup).GetDocIDJsonByKeys(intDocIDs,AKey)
			d jsonStream.Write(docjson)
		}
		else
		{
			s cjson = ""
			s strStructID = item.DocID
			;w item.DocID,!
			s obj = ##Class(EMRmeta.TemplateCategory).%OpenId(strStructID)
			d:(key'=1) jsonStream.Write(",") 
			s cjson = "{"
			s cjson = cjson_ """id"":"""_"flod-"_strStructID_""""
			s cjson = cjson_ ",""text"":"""_obj.Name_""""
			s cjson = cjson_ ",""DocIDText"":"""_obj.Name_""""
			s cjson = cjson_ ",""type"":""flod"""
			if (##Class(EMRservice.SystemParameter).GetListDisplayExpandType() = "collapse")
			{
				s cjson = cjson_ ",""state"":""closed"""
			}
			s cjson = cjson_ ",""children"":["
			d jsonStream.Write(cjson)
			s jsons = ##Class(EMRservice.BL.BLEMRTemplateDocGroup).GetAgreeNodeDatas(item,AKey)
			s jsons = jsons_ "]}"
			d jsonStream.Write(jsons)
		}
	}
	s mergeJsonStream = ..MergeJsonData(jsonStream)
	s jsonStreamNew = ##Class(%GlobalBinaryStream).%New()
	d jsonStreamNew.CopyFrom(mergeJsonStream)
	q jsonStreamNew
}

/// Desc:      获取知情目录json数据
/// Creator:    yejian
/// CreateDate: 2021-7-11
/// Input:      alist 知情模板目录结构对象
/// Output:     模板目录json流
/// Debug:      s json = ##Class(EMRservice.BL.BLEMRTemplateDocGroup).GetNodeDatas()
/// 			d json.OutputToDevice()
ClassMethod GetAgreeNodeDatas(agreeCates As EMRservice.entity.EAgreeDocIDList, AKey As %String) As %String
{
	s cjson = ""

	s key =""
	for
 	{
	 	s item = agreeCates.NodeData.GetNext(.key)
		q:(item ="")
		s intCatID = item.DocID
		;w item.DocID,!
		if (item.NodeData="")||(item.NodeData.Count()=0)
		{
			 s docjson = ##Class(EMRservice.BL.BLEMRTemplateDocGroup).GetDocIDJsonByKeys(intCatID,AKey)
			 if (docjson'="")
			{
				s cjson = cjson_docjson
			}
		}
		else
		{
			s obj = ##Class(EMRmeta.TemplateCategory).%OpenId(intCatID)
			q:(obj ="")
			s cjson = cjson_$Case(key,1:"{",:",{")
			s cjson = cjson_ """id"":"""_"flod-"_intCatID_""""
			s cjson = cjson_ ",""text"":"""_obj.Name_""""
			s cjson = cjson_ ",""DocIDText"":"""_obj.Name_""""
			s cjson = cjson_ ",""type"":""flod"""
			if (##Class(EMRservice.SystemParameter).GetListDisplayExpandType() = "collapse")
			{
				s cjson = cjson_ ",""state"":""closed"""
			}
			s cjson = cjson_ ",""children"":["
			s childJson = ##Class(EMRservice.BL.BLEMRTemplateDocGroup).GetAgreeNodeDatas(item,AKey)
			if (childJson'="")
			{
				s cjson = cjson_childJson
			}
			s cjson = cjson_ "]}"
		}
 	}
 	q cjson
}

/// Desc:      根据模板ID获取关联业务活动分类目录ID
/// Creator:    yejian
/// CreateDate: 2021-6-18
/// Input:      ALocID 科室ID
///            AParentID 父节点
/// Output:     关联业务活动分类目录ID
/// Debug:      d ##Class(EMRservice.BL.BLEMRTemplateDocGroup).GetStructParentIDByID(190)
ClassMethod GetStructParentIDByID(aParentID As %String) As %String
{
	s itemCount = 0
	s strStructID= ""
	s obj = ##Class(EMRmeta.TemplateCategory).%OpenId(aParentID)
	q:(obj="") "-1"
	q:(obj.PropertyCode = "EMR07")||(obj.PropertyCode [ "EMR070") aParentID
	
	s strStructID = ..GetStructParentIDByID(obj.ParentID)
	q strStructID
}

/// Desc:      根据docids获取json
/// Creator:    yejian
/// CreateDate: 2021-7-11
/// Input:      strItems docid^docid
/// Output:     模板目录json流
/// Debug:      s json = ##Class(EMRservice.BL.BLEMRTemplateDocGroup).GetDocIDJsonByIDs("602,603^604,605,606,607^612")
/// 			d json.OutputToDevice()
ClassMethod GetDocIDJsonByKeys(strItems As %String, AKey As %String) As %String
{
	s countTem = $l(strItems,"^")
	s tJsons = ""
	for j=1:1:countTem
	{
		s tmpDocId = $p(strItems,"^",j)
		s flagRowId = ^CacheTemp("GetTempCateJsonByCategoryID",AKey,"Flag",tmpDocId)
		continue:(flagRowId="")
		s objTemplate = ##Class(EMRservice.BL.BLTemplate).GetTemplateByEMRTmpCateID(tmpDocId)
	    continue:(objTemplate = "")
		s tJson = ^CacheTemp("GetTempCateJsonByCategoryID",AKey,flagRowId)
		s tJsons = $case(tJsons,"":tJson,:tJsons_","_tJson)
		k ^CacheTemp("GetTempCateJsonByCategoryID",AKey,"Flag",tmpDocId)
		k ^CacheTemp("GetTempCateJsonByCategoryID",AKey,"Seq",flagRowId)
		k ^CacheTemp("GetTempCateJsonByCategoryID",AKey,flagRowId)
	}
	q tJsons
}

/// Desc:      按模板目录结构，显示知情告知结构
/// Creator:    yejian
/// CreateDate: 2018-3-9
/// Input:      ALocID 科室ID
///            AParentID 父节点
///            AKey 临时global节点位置
/// Output:     模板目录json流
/// Debug:      s json = ##Class(EMRservice.BL.BLEMRTemplateDocGroup).GetCateTemByDocID("602,603^604,605,606,607^612")
/// 			d json.OutputToDevice()
ClassMethod GetCateTemByDocID(docGroup As %String) As %ListOfObjects(ELEMENTTYPE="EMRservice.entity.EAgreeDocIDList")
{
	s gourpArr = ##class(%ListOfObjects).%New()
	q:(docGroup="") jsonStream
	s blnMark =0
	s countGroup =$l(docGroup,",")
	for i=1:1:countGroup
	{
		s strItems = $p(docGroup,",",i)
		s countTem = $l(strItems,"^")
		s cNode = ##class(EMRservice.entity.EAgreeDocIDList).%New()
		s cNode.DocID = strItems
		s intParentID= ""
		s tJsons = ""
		if (countTem>0)
		{
			s tmpDocId = $p(strItems,"^",1)
			s objTemplate = ##Class(EMRservice.BL.BLTemplate).GetTemplateByEMRTmpCateID(tmpDocId)
		    continue:(objTemplate = "")
			s intParentID = objTemplate.TemplateCategoryID
			s objp = ##Class(EMRmeta.TemplateCategory).%OpenId(intParentID)
			continue:(objp="")
			//如果目录为业务活动记录，不显示目录
			if (objp.PropertyCode = "EMR07")||(objp.PropertyCode [ "EMR070")
			{
				s cNode.ShowCategory = "0"
				d gourpArr.Insert(cNode)
				continue	
			}
			else
			{
				s catNode = ##class(EMRservice.entity.EAgreeDocIDList).%New()
				s catNode.DocID = intParentID
				d catNode.NodeData.Insert(cNode)
				d gourpArr.Insert(catNode)
			}
		}
	}
	s strCountg = gourpArr.Count()
	q:(strCountg<=0) gourpArr
	s arrayItems = ##Class(EMRservice.BL.BLEMRTemplateDocGroup).GetAgreeTemplateCategory(gourpArr)
	q arrayItems
}

/// Desc:      获取知情告知第二层、及其以下目录结构
/// Creator:    yejian
/// CreateDate: 2021-6-18
/// Input:      ALocID 科室ID
///            AParentID 父节点
///            AKey 临时global节点位置
/// Output:     模板目录json流
/// Debug:      d ##Class(EMRservice.BL.BLEMRTemplateDocGroup).GetGroupTemplateByLoc(190,0,1)
ClassMethod GetAgreeTemplateCategory(aList As %ListOfObjects(ELEMENTTYPE="EMRservice.entity.EAgreeDocIDList")) As %ListOfObjects(ELEMENTTYPE="EMRservice.entity.EAgreeDocIDList")
{
	s itemCount = 0
	s intCategoryID = 0
	s listArr = ##class(%ListOfObjects).%New()
	s blMark =0
	s key =""
	for 
	{
		s item = aList.GetNext(.key)
		q:(item ="")
		s strID = item.DocID
		//不显示目录，直接添加数据
		if (item.ShowCategory = "0")
		{
			d listArr.Insert(item)
			continue
		}
		s obj = ##Class(EMRmeta.TemplateCategory).%OpenId(strID)
		continue:(obj="")
		s aParentID = obj.ParentID
		s objp = ##Class(EMRmeta.TemplateCategory).%OpenId(aParentID)
		continue:(objp="")
		if (objp.PropertyCode = "EMR07")||(objp.PropertyCode [ "EMR070")
		{
			d listArr.Insert(item)
			continue	
		}
		else
		{
			s blMark =1	
		}
		//目录不同以
	    if (intCategoryID'=aParentID)
	    {
		    s pNode = ##class(EMRservice.entity.EAgreeDocIDList).%New()
			s pNode.DocID = aParentID
			d pNode.NodeData.Insert(item)
			d listArr.Insert(pNode)
			s intCategoryID=aParentID		    
	    }
	    else
	    {
		    s pNode =listArr.GetAt(listArr.Count())
		    d pNode.NodeData.Insert(item)
	    }
	}
	if (listArr.Count()>0)&&(blMark=1)
	{
		s listArr = ##Class(EMRservice.BL.BLEMRTemplateDocGroup).GetAgreeTemplateCategory(listArr)
	}
	elseif(listArr.Count()>0)&&(blMark=0) ////标识所有集合内容都为第一层目录
	{
		s listArr = ##Class(EMRservice.BL.BLEMRTemplateDocGroup).GetPaAgreeTemplateCategory(listArr)
	}
	else
	{
		s listArr= aList
	}
	q listArr
}

/// Desc:      获取知情告知第一层目录结构
/// Creator:    yejian
/// CreateDate: 2021-6-18
/// Input:      ALocID 科室ID
///            AParentID 父节点
///            AKey 临时global节点位置
/// Output:     模板目录json流
/// Debug:      d ##Class(EMRservice.BL.BLEMRTemplateDocGroup).GetGroupTemplateByLoc(190,0,1)
ClassMethod GetPaAgreeTemplateCategory(aList As %ListOfObjects(ELEMENTTYPE="EMRservice.entity.EAgreeDocIDList")) As %ListOfObjects
{
	s paArr = ##class(%ListOfObjects).%New()
	s paCategoryID =0
	s key = ""
	for 
	{
		s item = aList.GetNext(.key)
		q:(item ="")
		s strID = item.DocID 
		if (item.ShowCategory="0")
		{
			d paArr.Insert(item)
			continue
		}
		s obj = ##Class(EMRmeta.TemplateCategory).%OpenId(strID)
		s aParentID = obj.ParentID
		s objp = ##Class(EMRmeta.TemplateCategory).%OpenId(aParentID)
		continue:(objp="")
		if (objp.PropertyCode = "EMR07")
		{
			d paArr.Insert(item)
			continue
		}
		//目录不同以
	    if (paCategoryID'=aParentID)
	    {
		    s pNode = ##class(EMRservice.entity.EAgreeDocIDList).%New()
			s pNode.DocID = aParentID
			d pNode.NodeData.Insert(item)
			d paArr.Insert(pNode)
			s paCategoryID=aParentID		    
	    }
	    else
	    {
		    s pNode =paArr.GetAt(paArr.Count())
		    d pNode.NodeData.Insert(item)
	    }
	}
	q paArr
}

/// w ##Class(EMRservice.BL.BLEMRTemplateDocGroup).MergeJsonData("")
ClassMethod MergeJsonData(AJsonSteam As %GlobalBinaryStream) As %Stream
{
	s fullJsonStrem = ##class(%GlobalBinaryStream).%New()
	d fullJsonStrem.Write("[")
	d fullJsonStrem.CopyFrom(AJsonSteam)
	d fullJsonStrem.Write("]")
	s json = [].%FromJSON(fullJsonStrem)
	s ind = $i(^CacheTemp)
	set iter = json.%GetIterator()
  	while iter.%GetNext(.key, .jsonsub) 
  	{ 
		if (jsonsub.children = "")
  		{
	  		
	  		if ($d(^CacheTemp(ind,jsonsub.text))=0) 
			{
				s tmpnumber = 1
			}
			else
			{
				s tmpnumber = $o(^CacheTemp(ind,jsonsub.text,""),-1)+1
			}
			s ^CacheTemp(ind,jsonsub.text,tmpnumber) = jsonsub.%ToJSON()
	  	}
	  	else
	  	{
		  
			set itersub = jsonsub.children.%GetIterator()
			while itersub.%GetNext(.keysub, .jsonsubchild) 
	  		{ 
				if ($d(^CacheTemp(ind,jsonsubchild.text))=0) 
				{
					s tmpnumber = 1
				}
				else
				{
					s tmpnumber = $o(^CacheTemp(ind,jsonsubchild.text,""),-1)+1
				}
				s ^CacheTemp(ind,jsonsubchild.text,tmpnumber) = jsonsubchild.%ToJSON()
			}
	  	}
  	}
  	s text=""
  	for
  	{
		 s text = $o(^CacheTemp(ind,text))
		 q:(text="")
		 s number=""
		 s jsonH={}
		 for
		 {
			s number = $o(^CacheTemp(ind,text,number))
		 	q:(number="")
		 	s tmpJson = ^CacheTemp(ind,text,number)	
		 	if (number=1)
		 	{
				s jsonH = {}.%FromJSON(tmpJson)
			}
			else
			{
				s jsonH2 = {}.%FromJSON(tmpJson)
				
				s key=""
				if (jsonH2.children="")
				{
					//s jsonH = jsonH2
				}
				else
				{
					set itersub = jsonH2.children.%GetIterator()
					while itersub.%GetNext(.key, .jsonchild) 
			  		{
				  		//判定children中是否有同样的数据，
				  		//如果有，将当前数据的children数据合并进去
				  		//如果没有，将当前数据合并进去
				  		s isExist=0
				  		s keyL2=""
				  		set itersubjsonH = jsonH.children.%GetIterator()
				  		while itersubjsonH.%GetNext(.keyL2, .jsonhaschild) 
			  			{
				  			
				  			
				  			if (jsonhaschild.text = jsonchild.text)
				  			{
					  			s keyL3=""
					  			if (jsonchild.children'="")
					  			{
						  			set itersubjsonchild = jsonchild.children.%GetIterator()
						  			while (itersubjsonchild.%GetNext(.keyL3, .jsonchildL3))
						  			{
						  				d jsonH.children.%Get(keyL2).children.%Push(jsonchildL3)
						  			}
					  				s isExist=1
					  			}
				  			}
			  			}
			  			
			  			if (isExist=0)
			  			{
				  			d jsonH.children.%Push(jsonchild)
			  			}
			  		}
				}
			}
		 }
		 s ^CacheTemp(ind,"NEW",text) = jsonH.%ToJSON()
	}
  	s returnJSON=[]
  	s newText=""
  	for
  	{
		s newText = $o(^CacheTemp(ind,"NEW",newText))
		q:(newText="")
		s subjson = {}.%FromJSON(^CacheTemp(ind,"NEW",newText))
		d returnJSON.%Push(subjson)
	}
  	k ^CacheTemp(ind)
  	s returnStream = ##class(%GlobalBinaryStream).%New()
  	d returnJSON.%ToJSON(returnStream)
  	//剥离最外层的[]
  	s tmpStream = ##class(%GlobalBinaryStream).%New()
  	d tmpStream.CopyFrom(returnStream)
  	d returnStream.Clear()
  	s tmpStreamLen = tmpStream.Size-2
  	d tmpStream.MoveTo(2)
  	while('tmpStream.AtEnd)
  	{
	  	if (tmpStreamLen>32000)
		{
			s readLen=32000
			d returnStream.Write(tmpStream.Read(readLen))
			s tmpStreamLen = tmpStreamLen-32000
		}
		else
		{
			s readLen=tmpStreamLen
			d returnStream.Write(tmpStream.Read(readLen))
			q
		}
	}
  	q returnStream
}

}
