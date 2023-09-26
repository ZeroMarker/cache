///  名称：		EMRservice.BL.BLUserTemplateGroup
///  描述：		科室模板分组BL层
///  编写者：	yejian
///  编写时间：	2016-9-20
Class EMRservice.BL.BLUserTemplateGroup Extends (%RegisteredObject, %XML.Adaptor)
{

/// 根据科室ID获取所有分组
/// /////////科室模板////////////
/// Debug:	d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLUserTemplateGroup","GetUserTemplateGroup","50")
Query GetUserTemplateGroup(ACtLocID As %String) As %Query(ROWSPEC = "ID:%Integer,GroupCode:%String,GroupName:%String,CTLocID:%String,ParentID:%String,Sequence:%Integer,EMRDocID:%String")
{
}

ClassMethod GetUserTemplateGroupExecute(ByRef qHandle As %Binary, ACtLocID As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	q:((($g(ACtLocID) = "")||(ACtLocID=$c(0)))) $$$OK
	s rowID = ""
	for {
		if ((ACtLocID '="")&&(ACtLocID'=$c(0)))
		{
			s rowID = $o(^DHCEMRM.UserTemplateGroupI("IdxCTLocID"," "_$g(ACtLocID),rowID))
		}
		q:(rowID = "")
		s objUserTemplateGroup = ##Class(EMRmeta.UserTemplateGroup).%OpenId(rowID)
		continue:(objUserTemplateGroup = "")
	
		s GroupCode = objUserTemplateGroup.GroupCode
		s GroupName = objUserTemplateGroup.GroupName
		s CTLocID = objUserTemplateGroup.CTLocID
		s ParentID = objUserTemplateGroup.ParentID
		s Sequence = objUserTemplateGroup.Sequence
		s EMRDocID = objUserTemplateGroup.EMRDocID
		s Data = $lb(rowID,GroupCode,GroupName,CTLocID,ParentID,Sequence,EMRDocID)
		s ^CacheTemp(repid,ind) = Data
		s ind = ind + 1	
	}
	
	q $$$OK
}

ClassMethod GetUserTemplateGroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUserTemplateGroupExecute ]
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

ClassMethod GetUserTemplateGroupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUserTemplateGroupExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 根据科室ID获取所有分组明细
/// /////////科室模板////////////
/// Debug:	d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLUserTemplateGroup","GetUserTemplateGroupItem","50")
Query GetUserTemplateGroupItem(ACtLocID As %String) As %Query(ROWSPEC = "ID:%Integer,GroupID:%String,Code:%String,Sequence:%Integer")
{
}

ClassMethod GetUserTemplateGroupItemExecute(ByRef qHandle As %Binary, ACtLocID As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	q:((($g(ACtLocID) = "")||(ACtLocID=$c(0)))) $$$OK
	s rowID = ""
	for {
		if ((ACtLocID '="")&&(ACtLocID'=$c(0)))
		{
			s rowID = $o(^DHCEMRM.UserTemplateGroupI("IdxCTLocID"," "_$g(ACtLocID),rowID))
		}
		q:(rowID = "")
		s objUserTemplateGroup = ##Class(EMRmeta.UserTemplateGroup).%OpenId(rowID)
		continue:(objUserTemplateGroup = "")
		s GroupCode = objUserTemplateGroup.GroupCode
		s gdRowID = ""
		for {
			s gdRowID = $o(^DHCEMRM.UserTemplateGroupItemI("IdxGroupID"," "_$g(rowID),gdRowID))
			q:(gdRowID = "")
			s objGroupItem = ##Class(EMRmeta.UserTemplateGroupItem).%OpenId(gdRowID)
			continue:(objGroupItem = "")
			s GroupID = objGroupItem.GroupID
			s Code = objGroupItem.Code
			s Sequence = objGroupItem.Sequence

			s Data = $lb(gdRowID,GroupID,Code,Sequence)
			s ^CacheTemp(repid,ind) = Data
			s ind = ind + 1	
		}
	}
	
	q $$$OK
}

ClassMethod GetUserTemplateGroupItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUserTemplateGroupItemExecute ]
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

ClassMethod GetUserTemplateGroupItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUserTemplateGroupItemExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 根据科室ID获取科室模板
/// /////////科室模板////////////
/// Debug:	d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLUserTemplateGroup","GetUserTemplateByCtLocID","1")
Query GetUserTemplateByCtLocID(ACtLocID As %String) As %Query(ROWSPEC = "ID:%Integer,Code:%String,Name:%String,Status:%String,Sequence:%Integer,Type:%String")
{
}

ClassMethod GetUserTemplateByCtLocIDExecute(ByRef qHandle As %Binary, ACtLocID As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	q:((($g(ACtLocID) = "")||(ACtLocID=$c(0)))) $$$OK
	s rowID = ""
	for {
		s rowID = $o(^DHCEMRM.UserTemplateD(rowID))
		q:(rowID = "")
		s objUserTemplate = ##Class(EMRmeta.UserTemplate).%OpenId(rowID)
		continue:(objUserTemplate = "")
		s Status = objUserTemplate.Status
		continue:(Status '="1")
		s Code = objUserTemplate.Code
		s Type = objUserTemplate.Type
		if (Type '= "0")
		{
			continue:($d(^DHCEMRM.UserTemplateCTLocI("IdxCTLocIDAndCode"," "_ACtLocID," "_Code))<=0)
		}
		
		s Name = objUserTemplate.Name
		s Sequence = objUserTemplate.Sequence

		s Data = $lb(rowID,Code,Name,Status,Sequence,Type)
		s ^CacheTemp(repid,ind) = Data
		s ind = ind + 1	
	}
	
	q $$$OK
}

ClassMethod GetUserTemplateByCtLocIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUserTemplateByCtLocIDExecute ]
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

ClassMethod GetUserTemplateByCtLocIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUserTemplateByCtLocIDExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 得到最大code编号
ClassMethod GetMaxID() As %String
{
	//s IdexCode=0
	&sql(select max(id) into :IdexCode   from EMRmeta.UserTemplateGroup)
	s:(IdexCode="") IdexCode=0
	q IdexCode
}

/// 根据ID获取科室模板
ClassMethod GetUserTemplateGroupByID(ARowID As %String) As EMRservice.entity.EUserTemplateGroup
{
	s objUserTemplateC = ##Class(EMRmeta.UserTemplateGroup).%OpenId(ARowID)
	q:(objUserTemplateC = "") ""
	
	s Result = ##Class(EMRservice.entity.EUserTemplateGroup).%New()
	s Result.ID = objUserTemplateC.%Id()
	s Result.CTLocID = objUserTemplateC.CTLocID
	s Result.GroupCode = objUserTemplateC.GroupCode
	s Result.GroupName = objUserTemplateC.GroupName
	s Result.ParentID = objUserTemplateC.ParentID
	s Result.Sequence = objUserTemplateC.Sequence
	s Result.EMRDocID = objUserTemplateC.EMRDocID
	q Result
}

/// 检查科室模板分组
ClassMethod CheckUserTemplateGroup(GroupCode As %String) As %String
{
	s rowID = ""
    s rowID = $o(^DHCEMRM.UserTemplateGroupI("IdxGroupCode"," "_$zcvt(GroupCode,"U"),rowID))
	q rowID
}

/// 添加科室模板分组
ClassMethod AddUserTemplateGroup(AUserTemplateC As EMRservice.entity.EUserTemplateGroup) As %String
{
	TStart
	s ret = 1
	s objUserTemplateC = ##Class(EMRmeta.UserTemplateGroup).%New()
	s objUserTemplateC.CTLocID = AUserTemplateC.CTLocID
	s objUserTemplateC.GroupCode = AUserTemplateC.GroupCode
	s objUserTemplateC.GroupName = AUserTemplateC.GroupName
	s objUserTemplateC.ParentID = AUserTemplateC.ParentID
	s objUserTemplateC.TemplateID = AUserTemplateC.TemplateID
	s objUserTemplateC.EMRDocID = AUserTemplateC.EMRDocID
	if (objUserTemplateC.%Save())
	{
		s ret=objUserTemplateC.%Id()
		s objUserTemplateC.Sequence=ret
		if (objUserTemplateC.%Save())
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

	d objUserTemplateC.%Close()	
	k objUserTemplateC
	q ret
}

/// 修改科室模板分组
ClassMethod ModUserTemplateGroup(AUserTemplateC As EMRservice.entity.EUserTemplateGroup) As %Boolean
{
	
	s ret = 1
	s objUserTemplateC = ##Class(EMRmeta.UserTemplateGroup).%OpenId(AUserTemplateC.ID)
	;s CateCodeOld = objUserTemplateC.GroupCode
	;s objUserTemplateC.GroupCode = AUserTemplateC.GroupCode
	s objUserTemplateC.GroupName = AUserTemplateC.GroupName
	if '(objUserTemplateC.%Save())
	{		   
		s ret=0
	}	
	d objUserTemplateC.%Close()
	q ret
}

/// 根据ID获取科室模板分组子项
ClassMethod GetUserTemplateGroupItemByCode(AGroupID As %String, ACode As %String) As EMRservice.entity.EUserTemplateGroupItem
{
	s ARowID = ""
	s ARowID = $o(^DHCEMRM.UserTemplateGroupItemI("IdxCode"," "_AGroupID," "_$zcvt(ACode,"U"),ARowID))
	q:(ARowID = "") ""
	s objUserTemplateC = ##Class(EMRmeta.UserTemplateGroupItem).%OpenId(ARowID)
	q:(objUserTemplateC = "") ""
	
	s Result = ##Class(EMRservice.entity.EUserTemplateGroupItem).%New()
	s Result.ID = objUserTemplateC.%Id()
	s Result.GroupID = objUserTemplateC.GroupID
	s Result.Code = objUserTemplateC.Code
	s Result.Sequence = objUserTemplateC.Sequence


	q Result
}

/// 添加科室模板分组
ClassMethod UpUserTemplateGroupItem(aCode As %String, oldGroupID As %String, newGroupID As %String) As %Boolean
{
	TStart
	s ret = 1
	s objGroupItem =""
	q:(aCode =""||oldGroupID=""||newGroupID = "") ret
	if (newGroupID =0)
	{
		s dRowID = $o(^DHCEMRM.UserTemplateGroupItemI("IdxCode"," "_$zcvt(oldGroupID,"U")," "_$zcvt(aCode,"U"),""))
		q:(dRowID ="") ret
		s objGroupItem = ##Class(EMRmeta.UserTemplateGroupItem).%OpenId(dRowID)
		if '(objGroupItem.%DeleteId(dRowID))
		{
			TROLLBACK
			s ret = 0
		}
	}
	elseif (oldGroupID = 0)
	{
		s objGroupItem = ##Class(EMRmeta.UserTemplateGroupItem).%New()
		s objGroupItem.Code = aCode
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
		s dRowID = $o(^DHCEMRM.UserTemplateGroupItemI("IdxCode"," "_$zcvt(oldGroupID,"U")," "_$zcvt(aCode,"U"),""))
		q:(dRowID ="") ret
		s objGroupItem = ##Class(EMRmeta.UserTemplateGroupItem).%OpenId(dRowID)
		if '(objGroupItem.%DeleteId(dRowID))
		{
			TROLLBACK
			s ret = 0
		}
		s objGroupItem = ##Class(EMRmeta.UserTemplateGroupItem).%New()
		s objGroupItem.Code = aCode
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
/// CreatDate:2016-8-9
/// Description:修改树节点排序顺序号
/// Return: result是否操作成功
/// do ##class(EMRservice.BL.BLUserTemplateGroup).SwapUserTemplateCatSeq("1","2")
ClassMethod SwapUserTemplateCatSeq(UserTemplateGID1 As %String, UserTemplateGID2 As %String) As %Boolean
{
	set result = 0
	set objNextTree = ##class(EMRmeta.UserTemplateGroup).%OpenId(UserTemplateGID1)
	set objSelectTree = ##class(EMRmeta.UserTemplateGroup).%OpenId(UserTemplateGID2)
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
/// CreatDate:2016-8-9
/// Description:修改树节点排序顺序号
/// Return: result是否操作成功
/// do ##class(EMRservice.BL.BLUserTemplateGroup).SwapUserTemplateItemSeq("1","2")
ClassMethod SwapUserTemplateItemSeq(UserTemplateGID1 As %String, UserTemplateGID2 As %String) As %Boolean
{
	set result = 0
	set objNextTree = ##class(EMRmeta.UserTemplateGroupItem).%OpenId(UserTemplateGID1)
	set objSelectTree = ##class(EMRmeta.UserTemplateGroupItem).%OpenId(UserTemplateGID2)
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

/// 删除科室模板分组
ClassMethod DelUserTemplateGroup(AUserTemplateCID As %String) As %String
{
	
	s ret = 0
	q:($g(AUserTemplateCID) = "") ret
	TStart
	s ret = "1"
	s objUserTemplateC = ##Class(EMRmeta.UserTemplateGroup).%OpenId(AUserTemplateCID)
	s strGroupCode = objUserTemplateC.GroupCode
	///删除所有科室模板关联
	s GroupItemRowID = ""
	for {
		s GroupItemRowID = $o(^DHCEMRM.UserTemplateGroupItemI("IdxGroupID"," "_$zcvt(AUserTemplateCID,"U"),GroupItemRowID))
		q:(GroupItemRowID = "")
	
		s objGroupDetal = ##Class(EMRmeta.UserTemplateGroupItem).%OpenId(GroupItemRowID)
		if '(objGroupDetal.%DeleteId(GroupItemRowID))
		{
			TROLLBACK
			s ret = 0
			q
		}
	}
	if ('objUserTemplateC.%DeleteId(AUserTemplateCID))
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

/// Desc:       按分类展现目录结构，显示全院模板
/// Creator:    Candy
/// CreateDate: 2018-3-9
/// Input:      AParentID 父节点
///            AKey 临时global节点位置
/// Output:     模板目录json流
ClassMethod GetGroupUserTemplate(AParentID As %String, AKey As %String, ATitleCode As %String) As %GlobalBinaryStream
{
	s json = ##Class(%GlobalBinaryStream).%New()
	s locId = ""
	for
	{
		s locId = $o(^DHCEMRM.UserTemplateGroupI("IdxLocSeq",locId))
		q:(locId = "")
		s tmpLocId = $tr(locId," ","")
		s tmpJson = ..GetGroupUserTemplateByLoc(tmpLocId,AParentID,AKey,ATitleCode)
		d:(tmpJson.Size > 0)&&(json.Size >0) json.Write(",")
		d json.CopyFrom(tmpJson)
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
/// Debug:      d ##Class(EMRservice.BL.BLUserTemplateGroup).GetGroupUserTemplate(191,0,1)
ClassMethod GetGroupUserTemplateByLoc(ALocID As %String, AParentID As %String, AKey As %String, ATitleCode As %String) As %GlobalBinaryStream
{
	s json = ##Class(%GlobalBinaryStream).%New()
	s SetTemplateDirectoryState = "open"
	s SetTempDirSta = ##class(EMRservice.SystemParameter).SetTemplateDirectoryState()
	s:(SetTempDirSta = "N") SetTemplateDirectoryState = "closed"
	q:(ALocID = "") json
	s seq = ""
	for
	{
		s seq = $o(^DHCEMRM.UserTemplateGroupI("IdxLocSeq"," "_ALocID," "_AParentID,seq))
		q:(seq = "")
		s rowId = ""
		for
		{
			s rowId = $o(^DHCEMRM.UserTemplateGroupI("IdxLocSeq"," "_ALocID," "_AParentID,seq,rowId))
			q:(rowId = "")
			s obj = ##Class(EMRmeta.UserTemplateGroup).%OpenId(rowId)
			continue:(obj = "")
			if (AParentID = "0")
			{
				s flag = ..IsValidGroupID(ALocID,rowId,AKey,ATitleCode)
				continue:(flag = "0")
			}
			
			d:(json.Size > 0) json.Write(",")
			d json.Write("{")
			d json.Write("""id"":"""_rowId_"""")
			d json.Write(",""text"":"""_obj.GroupName_"""")
			d json.Write(",""state"":"""_SetTemplateDirectoryState_"""")
			d json.Write(",""icon"":""../scripts/emr/image/icon/folder.png""")
			d json.Write(",""attributes"":{""nodetype"":""flod""}")
			d json.Write(",""children"":[")
			s childJson = ..GetGroupUserTemplateByLoc(ALocID,rowId,AKey,ATitleCode)
			d json.CopyFrom(childJson)
			s itemSeq = ""
			s itemCount = 0
			for
			{
				s itemSeq = $o(^DHCEMRM.UserTemplateGroupItemI("IdxSeq"," "_rowId, itemSeq))
				q:(itemSeq = "")
				s userTemplateCode = ""
				for
				{
					s userTemplateCode = $o(^DHCEMRM.UserTemplateGroupItemI("IdxSeq"," "_rowId, itemSeq,userTemplateCode))
					q:(userTemplateCode = "")

					s ItemCode = $tr(userTemplateCode," ","")
					continue:($d(^CacheTemp("GetUserTemplateJson",AKey,ATitleCode,"Flag",ItemCode))<=0)					
	                s flagRowId = ^CacheTemp("GetUserTemplateJson",AKey,ATitleCode,"Flag",ItemCode)
					d:((childJson.Size >0)&&(itemCount =0)) json.Write(",") 
					d:(itemCount '=0) json.Write(",") 
		            d json.Write("{")
		            d json.Write("""id"":"""_$li(^CacheTemp("GetUserTemplateJson",AKey,ATitleCode,flagRowId),1)_"""")
                    if ($li(^CacheTemp("GetUserTemplateJson",AKey,ATitleCode,flagRowId),6) = "全院通用")
					{
						s name = "<span style='color:blue;'>"_$li(^CacheTemp("GetUserTemplateJson",AKey,ATitleCode,flagRowId),2)_"</span>"
					}
					else
					{
						s name = $li(^CacheTemp("GetUserTemplateJson",AKey,ATitleCode,flagRowId),2)
					}
                    s templateID = $li(^CacheTemp("GetUserTemplateJson",AKey,ATitleCode,flagRowId),4)
                    s templateobj = ##Class(EMRmeta.Template).%OpenId(templateID)
		            d json.Write(",""text"":"""_name_"""")
		            //d json.Write(",""text"":"""_$li(^CacheTemp("GetUserTemplateJson",AKey,ATitleCode,flagRowId),2)_"""")
		            d json.Write(",""icon"":""../scripts/emr/image/icon/leaf.png""")
		            d json.Write(",""attributes"":{")
					d json.Write("""Code"":"""_$li(^CacheTemp("GetUserTemplateJson",AKey,ATitleCode,flagRowId),1)_"""")
					d json.Write(",""SimpleSpel"":"""_$li(^CacheTemp("GetUserTemplateJson",AKey,ATitleCode,flagRowId),3)_"""")
					d json.Write(",""TemplateID"":"""_$li(^CacheTemp("GetUserTemplateJson",AKey,ATitleCode,flagRowId),4)_"""")
					d json.Write(",""TitleCode"":"""_$li(^CacheTemp("GetUserTemplateJson",AKey,ATitleCode,flagRowId),5)_"""")
					d json.Write(",""Type"":"""_$li(^CacheTemp("GetUserTemplateJson",AKey,ATitleCode,flagRowId),6)_"""")
                    d json.Write(",""UserTemplateId"":"""_$li(^CacheTemp("GetUserTemplateJson",AKey,ATitleCode,flagRowId),7)_"""")
                    d json.Write(",""documentType"":"""_templateobj.DocumentType_"""")
					d json.Write(",""nodetype"":""leaf""")
					d json.Write("}}")
					s itemCount = itemCount +1
					k ^CacheTemp("GetUserTemplateJson",AKey,ATitleCode,"Flag",ItemCode)
					k ^CacheTemp("GetUserTemplateJson",AKey,ATitleCode,flagRowId)
				}
			}
			d json.Write("]}")
		}
	}
	q json
}

/// Desc:       按分类展现目录结构，显示全院模板
/// Creator:    yejian
/// CreateDate: 2021-6-25
/// Input:      AParentID 父节点
///            AKey 临时global节点位置
/// Output:     模板目录json流
ClassMethod GetGroupUserTemplateNew(AParentID As %String, AKey As %String, ATitleCode As %String, pJson As %String) As %GlobalBinaryStream
{
	s json = ##Class(%GlobalBinaryStream).%New()
	s locId = ""
	for
	{
		s locId = $o(^DHCEMRM.UserTemplateGroupI("IdxLocSeq",locId))
		q:(locId = "")
		s tmpLocId = $tr(locId," ","")
		s tmpJson = ..GetGroupUserTemplateByLocNew(tmpLocId,AParentID,AKey,ATitleCode,pJson)
		d:(tmpJson.Size > 0)&&(json.Size >0) json.Write(",")
		d json.CopyFrom(tmpJson)
	}
	q json
}

/// Desc:      按分类展现目录结构，显示当前科室模板
/// Creator:    yejian
/// CreateDate: 2021-6-25
/// Input:      ALocID 科室ID
///            AParentID 父节点
///            AKey 临时global节点位置
/// Output:     模板目录json流
/// Debug:      d ##Class(EMRservice.BL.BLUserTemplateGroup).GetGroupUserTemplate(190,0,1)
ClassMethod GetGroupUserTemplateByLocNew(ALocID As %String, AParentID As %String, AKey As %String, ATitleCode As %String, pJson As %String) As %GlobalBinaryStream
{
	s json = ##Class(%GlobalBinaryStream).%New()
	s SetTemplateDirectoryState = "open"
	s SetTempDirSta = ##class(EMRservice.SystemParameter).SetTemplateDirectoryState()
	s:(SetTempDirSta = "N") SetTemplateDirectoryState = "closed"
	q:(ALocID = "") json
	s seq = ""
	for
	{
		s seq = $o(^DHCEMRM.UserTemplateGroupI("IdxLocSeq"," "_ALocID," "_AParentID,seq))
		q:(seq = "")
		s rowId = ""
		for
		{
			s rowId = $o(^DHCEMRM.UserTemplateGroupI("IdxLocSeq"," "_ALocID," "_AParentID,seq,rowId))
			q:(rowId = "")
			s obj = ##Class(EMRmeta.UserTemplateGroup).%OpenId(rowId)
			continue:(obj = "")
			if (AParentID = "0")
			{
				s flag = ..IsValidGroupID(ALocID,rowId,AKey,ATitleCode)
				continue:(flag = "0")
			}
			
			d:(json.Size > 0) json.Write(",")
			d json.Write("{")
			d json.Write("""id"":"""_"flod-"_rowId_"""")
			d json.Write(",""text"":"""_obj.GroupName_"""")
			d json.Write(",""DocIDText"":"""_obj.GroupName_"""")
			d json.Write(",""state"":"""_SetTemplateDirectoryState_"""")
			d json.Write(",""icon"":""../scripts/emr/image/icon/folder.png""")
			d json.Write(",""type"":""flod""")
			d json.Write(",""attributes"":{""nodetype"":""flod""}")
			d json.Write(",""children"":[")
			s childJson = ..GetGroupUserTemplateByLoc(ALocID,rowId,AKey,ATitleCode)
			d json.CopyFrom(childJson)
			s itemSeq = ""
			s itemCount = 0
			for
			{
				s itemSeq = $o(^DHCEMRM.UserTemplateGroupItemI("IdxSeq"," "_rowId, itemSeq))
				q:(itemSeq = "")
				s userTemplateCode = ""
				for
				{
					s userTemplateCode = $o(^DHCEMRM.UserTemplateGroupItemI("IdxSeq"," "_rowId, itemSeq,userTemplateCode))
					q:(userTemplateCode = "")

					s ItemCode = $tr(userTemplateCode," ","")
					continue:($d(^CacheTemp("GetUserTemplateJson",AKey,ATitleCode,"Flag",ItemCode))<=0)					
	                s flagRowId = ^CacheTemp("GetUserTemplateJson",AKey,ATitleCode,"Flag",ItemCode)
					d:((childJson.Size >0)&&(itemCount =0)) json.Write(",") 
					d:(itemCount '=0) json.Write(",") 
		            d json.Write("{")
                    if ($li(^CacheTemp("GetUserTemplateJson",AKey,ATitleCode,flagRowId),6) = "全院通用")
					{
						//s name = "<span style='color:blue;'>"_$li(^CacheTemp("GetUserTemplateJson",AKey,ATitleCode,flagRowId),2)_"</span>"
						s name = $li(^CacheTemp("GetUserTemplateJson",AKey,ATitleCode,flagRowId),2)
						s strType = "TempCate"
					}
					else
					{
						s name = $li(^CacheTemp("GetUserTemplateJson",AKey,ATitleCode,flagRowId),2)
						s strType = "UserTem"
					}
					d json.Write("""id"":"""_strType_"-"_$li(^CacheTemp("GetUserTemplateJson",AKey,ATitleCode,flagRowId),1)_"""")
		            d json.Write(",""text"":"""_name_"""")
		            d json.Write(",""DocIDText"":"""_name_"""")
		            //d json.Write(",""text"":"""_$li(^CacheTemp("GetUserTemplateJson",AKey,ATitleCode,flagRowId),2)_"""")
		            d json.Write(pJson)
		            d json.Write(",""iconCls"":""icon-person""")
		            d json.Write(",""type"":"""_strType_"""")
		            d json.Write(",""attributes"":{")
					d json.Write("""Code"":"""_$li(^CacheTemp("GetUserTemplateJson",AKey,ATitleCode,flagRowId),1)_"""")
					d json.Write(",""SimpleSpel"":"""_$li(^CacheTemp("GetUserTemplateJson",AKey,ATitleCode,flagRowId),3)_"""")
					d json.Write(",""TemplateID"":"""_$li(^CacheTemp("GetUserTemplateJson",AKey,ATitleCode,flagRowId),4)_"""")
					d json.Write(",""TitleCode"":"""_$li(^CacheTemp("GetUserTemplateJson",AKey,ATitleCode,flagRowId),5)_"""")
					d json.Write(",""Type"":"""_$li(^CacheTemp("GetUserTemplateJson",AKey,ATitleCode,flagRowId),6)_"""")
					d json.Write(",""nodetype"":""leaf""")
					d json.Write("}}")
					s itemCount = itemCount +1
					k ^CacheTemp("GetUserTemplateJson",AKey,ATitleCode,"Flag",ItemCode)
					k ^CacheTemp("GetUserTemplateJson",AKey,ATitleCode,flagRowId)
				}
			}
			d json.Write("]}")
		}
	}
	q json
}

/// Desc:       检查病历目录是否有是当前科室目录
/// Creator:    Candy
/// CreateDate: 2018-3-12
/// Input:      ALocID 科室ID
///            AGroupID 目录ID
///            AKey global位置
/// Output:     result 0 不是 1是
/// w ##Class(EMRservice.BL.BLUserTemplateGroup).IsValidGroupID(190,4,2)
ClassMethod IsValidGroupID(ALocID As %String, AGroupID As %String, AKey As %String, ATitleCode As %String) As %String
{
	s result = "0"
	s rowItemId= ""
	for
	{
		s rowItemId = $o(^DHCEMRM.UserTemplateGroupItemI("IdxCode"," "_AGroupID,rowItemId))
		q:(rowItemId="")
		s ItemCode = $tr(rowItemId," ","")
		if (ItemCode '= "")
		{
			s flag = $d(^CacheTemp("GetUserTemplateJson",AKey,ATitleCode,"Flag",ItemCode))
			s:(flag >0) result = "1"
			q:(result = "1")
		}
	}
	q:(result=1) result
	s rowId = ""
	for
	{
		s rowId = $o(^DHCEMRM.UserTemplateGroupI("IdxLocParent"," "_ALocID," "_AGroupID,rowId))
		q:(rowId = "")
		s child = ..IsValidGroupID(ALocID,rowId,AKey,ATitleCode)
		s ItemCode = $o(^DHCEMRM.UserTemplateGroupItemI("IdxCode"," "_rowId,""))
		s ItemCode = $tr(ItemCode," ","")
		continue:(ItemCode = "")
		s flag = $d(^CacheTemp("GetUserTemplateJson",AKey,ATitleCode,"Flag",ItemCode))
		s:((flag >0)||(child =1)) result = 1
		q:(result = 1)
	}
	q result
}

/// Desc:       处理科室模板旧的分组数据，增加DOCID关联
/// Creator:    yejian
/// CreateDate: 2018-3-12
/// Input:      
/// Output:     strRes 0 不是 1是
/// d ##Class(EMRservice.BL.BLUserTemplateGroup).InitAllGroupData()
ClassMethod InitAllGroupData()
{
	s totCount=0,okCount=0,failCount=0
	s rowId = ""
	for
	{
		s rowId = $o(^DHCEMRM.UserTemplateGroupD(rowId))
		q:(rowId = "")
		s objGroup = ##class(EMRmeta.UserTemplateGroup).%OpenId(rowId)
		continue:(objGroup="")||(objGroup.EMRDocID'="")
		
		s ItemCode = $o(^DHCEMRM.UserTemplateGroupItemI("IdxCode"," "_rowId,""))
		s ItemCode = $tr(ItemCode," ","")
		continue:(ItemCode = "")
		s ARowID = $o(^DHCEMRM.UserTemplateI("IdxCode"," "_$zcvt(ItemCode,"U"),""))
		continue:(ARowID = "")
		s objUserTemplate = ##Class(EMRmeta.UserTemplate).%OpenId(ARowID)
		s templateID  = objUserTemplate.TemplateID
		continue:(templateID="")
		s emrTemID = $o(^DHCEMRM.EMRTemplateI("IdxBindTemplateID"," "_templateID,""))
		s objEmrTem =##class(EMRmeta.EMRTemplate).%OpenId(emrTemID)
		continue:(objEmrTem="")
		s docID = objEmrTem.CategoryID
		s objGroup.EMRDocID =docID
		s ss = objGroup.%Save()
		s totCount = totCount + 1
		if (ss)
		{
			s okCount = okCount + 1
		}
		else
		{
			s failCount = failCount + 1
		}
	}
	w !,"01_Summary: "_totCount_" okCount:"_okCount_" failCount:"_failCount
	q
}

/// Desc:       取科室模板分类数据
/// Creator:    Lina
/// CreateDate: 2022-12-21
/// Input:      argUserLocID 用户科室ID
///             argDocID 
/// Output:     分类流数据
/// Debug:      w ##Class(EMRservice.BL.BLUserTemplateGroup).GetUserTempGroupData(191,58,0).Read(32000)
ClassMethod GetUserTempGroupData(argUserLocID As %String, argDocID As %String, argParentID As %String, TemplateId As %String) As %GlobalCharacterStream
{
    s json = ##class(%GlobalCharacterStream).%New()
    q:(argUserLocID = "")||(argDocID = "") json
    s seq = ""
    for
    {
        s seq = $o(^DHCEMRM.UserTemplateGroupI("IdxDOCIDLocSeq"," "_argDocID," "_argUserLocID," "_argParentID,seq))
        q:(seq = "")
        s rowId = ""
        for
        {
            s rowId = $o(^DHCEMRM.UserTemplateGroupI("IdxDOCIDLocSeq"," "_argDocID," "_argUserLocID," "_argParentID,seq,rowId))
            q:(rowId = "")
            s obj = ##Class(EMRmeta.UserTemplateGroup).%OpenId(rowId)
            continue:(obj = "")||(obj.TemplateID '= TemplateId)
            d:(json.Size > 0) json.Write(",")
            d json.Write("{")
            d json.Write("""id"":"""_rowId_"""")
            d json.Write(",""text"":"""_obj.GroupName_"""")
            d json.Write(",""children"":[")
            s childJson = ..GetGroupTemplateChildren(rowId)
            d:(childJson.Size >0) json.CopyFrom(childJson)
            d json.Write("]") 
            d json.Write("}") 
        }
    }
    q json
}

/// Creator： 		liuyunfei
/// CreatDate： 	2023-05-09
/// Description:： 	获取科室模板自建文件夹目录
/// Input： 		
/// Output： 		json Stream	
/// debug:			w ##Class(EMRservice.BL.BLUserTemplateGroup).GetGroupTemplateChildren(1)
ClassMethod GetGroupTemplateChildren(AParentId As %String) As %GlobalCharacterStream
{
	s ret = ##Class(%GlobalCharacterStream).%New()
	q:(AParentId = "") ret
	s seq = ""
	for
	{
		s seq = $o(^DHCEMRM.UserTemplateGroupI("IdxSeq"," "_AParentId,seq))
		q:(seq = "")
		s rowId = ""
		for
		{
			s rowId = $o(^DHCEMRM.UserTemplateGroupI("IdxSeq"," "_AParentId,seq,rowId))
			q:(rowId = "")
			
			s obj = ##Class(EMRmeta.UserTemplateGroup).%OpenId(rowId)
			d:(ret.Size > 0) ret.Write(",")
			d ret.Write("{")
			d ret.Write("""id"":"""_rowId_"""")
			d ret.Write(",""text"":"""_##class(EMRservice.HISInterface.Translation).Get("EMRTrans",obj.GroupName)_"""")
			d ret.Write(",""children"":[")
			s json = ..GetGroupTemplateChildren(rowId)
			d ret.CopyFrom(json)
			d ret.Write("]")
			d ret.Write("}")
		}
	}
	q ret
}

}
