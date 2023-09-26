///  名称：		EMRservice.BL.BLIEUserTemplate
///  描述：		科室模板在IE端维护
///  编写者：	liuyunfei
///  编写时间：	2020-06-16
Class EMRservice.BL.BLIEUserTemplate Extends %RegisteredObject
{

/// Creator： 		liuyunfei
/// CreatDate： 	2021-06-16
/// Description:： 	获取模板目录树（包括科室配置的展现结构和科室模板） 
/// Input： 		ACTLocID：科室id，ASSgroupID：安全组id
/// Output： 		json Stream
/// Return： 		json类型的流数据,按照UI-Tree的格式拼成的json流
/// Others： 		该方法返回的json涉及到多个表，生成树的时候id有冲突，相关的表有
/// 				EMRmeta.EMRTemplateCategory/EMRmeta.UserTemplateGroup/EMRmeta.UserTemplate
/// 				对应的id规则为 ct_^_rowid/group_^_rowid/user_^_rowid
/// debug:			w ##Class(EMRservice.BL.BLIEUserTemplate).GetTemplateTreeJson(95,29)
ClassMethod GetTemplateTreeJson(ACTLocID As %String, ASSGroupID As %String) As %GlobalCharacterStream
{
	s json = ##Class(%GlobalCharacterStream).%New()
	s count = 0
	q:(ACTLocID = "")||(ASSGroupID = "") json
	s locTempDesc = ##class(EMRservice.HISInterface.Translation).Get("EMRTrans","科室模板")
	d json.Write("[{")
	d json.Write("""id"":""TEMP"",")
	d json.Write("""attributes"":{")
	d json.Write("""nodetype"":""root"",")
	d json.Write("""type"":""root""},")
	d json.Write("""state"":""open"",")
	d json.Write("""text"":"""_locTempDesc_""",")
	d json.Write("""children"":")
	d json.Write("[")
	
	s UserTemplateTreeState = "closed"
	s:(##Class(EMRservice.SystemParameter).SetUserTemplateTreeState() = "Y") UserTemplateTreeState = "open"
	s result = ##class(%ResultSet).%New("EMRservice.BL.BLUserTemplateShow:GetCategory")
	d result.Execute(ACTLocID,"RUNNING")
	while result.%Next()
	{
		s ItemType = result.Data("ItemType")
		continue:(ItemType = "HIS")
		s categoryId = result.Data("ItemCategoryID")
		
		s itemDr = $o(^DHCEMRM.CTOrgSchemeItemI("IdxEMRTemplateCategoryID"," "_categoryId,""))
		continue:(itemDr = "")
		s objCTOrgScheme = ##Class(EMRmeta.CTOrganizationSchemeItem).%OpenId(itemDr)
		continue:(objCTOrgScheme = "")
		continue:($d(^DHCEMRM.EMRNavItemSSGroupI("IdxCodeSSGroup"," RUNNING"," "_objCTOrgScheme.ItemCode," "_ASSGroupID))<=0)
		d:(count '= 0) json.Write(",")
		d json.Write("{")
		d json.Write("""id"":"""_"ct^"_categoryId_"""")
		d json.Write(",""text"":"""_result.Data("ItemTitle")_"""")
		d json.Write(",""state"":"""_UserTemplateTreeState_"""")
		d json.Write(",""attributes"":{" )
		d json.Write("""type"":""category""")
		d json.Write(",""nodetype"":""category""")
		d json.Write("}")
		d json.Write(",""children"":[")
		
		s templateJson = ##Class(%GlobalCharacterStream).%New()
		s priActivity = ##Class(EMRservice.BL.BLClientCategory).CheckTPrivActivity()  //权限控制	
		s strdocIds = ##class(EMRservice.BL.BLUserTemplateShow).GetDocByCategoryID(categoryId,priActivity,ACTLocID)
		s mutexdoc = $p(strdocIds,"&",1)
		s nomutexdoc = $p(strdocIds,"&",2)
		s docIds = mutexdoc_"^"_nomutexdoc
		s length = $l(docIds,"^")
		for I=1:1:length
		{
			s docId = $p(docIds,"^",I)
			s docJson = ..GetTemplateByDocID(docId,ACTLocID)
			d:(templateJson.Size > 0)&&(docJson.Size > 0) templateJson.Write(",")
			d templateJson.CopyFrom(docJson)

		}
		if (templateJson.Size > 0)
		{
			d json.CopyFrom(templateJson)
		}
		d json.Write("]")
		d json.Write("}")
		
		s count = count + 1
	}
	d json.Write("]")
	d json.Write("}]")
	q json
}

/// Creator： 		liuyunfei
/// CreatDate： 	2021-06-17
/// Description:： 	根据docId和locId获取模板（可展现的基础模板和科室模板）
/// Input： 		ADocID：docId，ACTLocID：科室id
/// Output： 		doc层下面的基础模板和基础模板下的科室模板文件夹和科室模板目录（不包含doc层）
/// Return： 		json类型流数据
/// Others： 		
/// Debug:     w ##Class(EMRservice.BL.BLIEUserTemplate).GetTemplateByDocID(66,93)
ClassMethod GetTemplateByDocID(aDocID As %String, aLocID As %String) As %GlobalCharacterStream
{
	s json = ##Class(%GlobalBinaryStream).%New()
	q:(aDocID = "") json
	
	s count = 0
	s templateID = ""
	for
	{
		s templateID = $o(^DHCEMRM.EMRTemplateI("IdxCategoryTemplate"," "_aDocID,templateID))
		q:(templateID = "")
		s temTemplateID = $tr(templateID," ","")
		s templateObj = ##class(EMRmeta.Template).%OpenId(temTemplateID)
		q:(templateObj = "")
		s ChartItemType = templateObj.ChartItemType
		s Code = templateObj.Code
		s text = templateObj.Name
		s TemplateVersionId = ##Class(EMRservice.BL.BLTemplateVersion).GetMaxPubVrnID(temTemplateID)
		s documentType = templateObj.DocumentType
		d:(count '= 0) json.Write(",")
		d json.Write("{")
		d json.Write("""id"":"""_"template^"_temTemplateID_"""")
		d json.Write(",""text"":"""_text_"""")
		d json.Write(",""iconCls"":""general-template""")
		d json.Write(",""attributes"":{" )
		d json.Write("""Code"":"""_Code_"""")
		d json.Write(",""TemplateID"":"""_temTemplateID_"""")
		d json.Write(",""TemplateVersionId"":"""_TemplateVersionId_"""")
		d json.Write(",""documentType"":"""_documentType_"""")
		d json.Write(",""type"":""Y""")
		d json.Write(",""nodetype"":""basisTemplate""")
		d json.Write("}")
		d json.Write(",""children"":")
		d json.Write("[") 
		
		
		s userTempJson = ..GetUserTemplateJson(aLocID,aDocID,temTemplateID)
		if (userTempJson.Size > 0)
		{
			d json.CopyFrom(userTempJson)
		}
		
		
		d json.Write("]")
		d json.Write("}")
		s count = count + 1
	}
	q json
}

/// Desc:       取当前科室模板（不包含通用模板）
/// Creator:    Candy
/// CreateDate: 2017-11-8
/// Input:      pLocID 科室ID, pDocID 目录展现结构ID,pType:模板类型（0:全院通用，1:科室）
/// Output:     doc层下面的科室模板文件夹和科室模板目录（包含doc层）
/// return:		json类型流数据
/// Debug:      w ##Class(EMRservice.BL.BLIEUserTemplate).GetUserTemplateJson(93,58,1)
ClassMethod GetUserTemplateJson(pLocID As %String, pDocID As %String, pTemplateID As %String) As %GlobalBinaryStream
{
	s resultJson = ##Class(%GlobalBinaryStream).%New()
	q:(pDocID = "") resultJson
	s result = ##class(%ResultSet).%New("EMRservice.BL.BLIEUserTemplate:GetAllUserTemplate")
	d result.Execute(pDocID,pLocID,pTemplateID)
	s key = $i(^CacheTemp("GetUserTemplateJson"))
	s count = 0
    s oTitleSeq = "ZZNONE"
	while result.%Next()
	{
		s count = count + 1
		s data = $lb(result.Data("oCode"),result.Data("oName"),result.Data("oSimpleSpel"),result.Data("oTemplateID"),result.Data("oTitleCode"),result.Data("oTypeDesc"),result.Data("ID"),result.Data("oStatus"),result.Data("oVersionNumber"))
		s oTitleSeq = result.Data("oTitleSeq")
		s:(oTitleSeq = "") oTitleSeq = "ZZNONE"
		s ^CacheTemp("GetUserTemplateJson",key,oTitleSeq,count) = data
		s ^CacheTemp("GetUserTemplateJson",key,oTitleSeq,"Flag",result.Data("oCode"))= count
	}
	s tmpJson = ..GetGroupUserTemplateByLoc(pDocID,pLocID,pTemplateID,0,key,oTitleSeq)
	d resultJson.CopyFrom(tmpJson)

	//循环取可重复模板数据
	s titleCode = ""
	for
	{
		s titleCode = $o(^CacheTemp("GetUserTemplateJson",key,titleCode))
		q:(titleCode = "")
		continue:(titleCode = "ZZNONE")
		d:(resultJson.Size > 0) resultJson.Write(",")
		s userTempSeq = ""
		s count = 0
		for
		{
			s userTempSeq = $o(^DHCEMRM.UserTemplateI("IdxTemplateID"," "_pTemplateID,userTempSeq))
			q:(userTempSeq="")
			s userTempRowID = $o(^DHCEMRM.UserTemplateI("IdxTemplateID"," "_pTemplateID,userTempSeq,""))
			s userTemplateObj = ##class(EMRmeta.UserTemplate).%OpenId(userTempRowID)
			s userTemplateCode = userTemplateObj.Code
			s TemplateVersionId = ##Class(EMRservice.BL.BLTemplateVersion).GetMaxPubVrnID(pTemplateID)
			continue:(TemplateVersionId="")
			continue:($d(^CacheTemp("GetUserTemplateJson",key,titleCode,"Flag",userTemplateCode))<=0)
			s flagRowId = ^CacheTemp("GetUserTemplateJson",key,titleCode,"Flag",userTemplateCode)
			d:(count '= 0) resultJson.Write(",")
			d writeJson
			s count = count + 1	
		}
	}
	
	//循环取唯一模板数据
	s userTempSeq = ""
	s titleCode = "ZZNONE"
	for
	{
		s userTempSeq = $o(^DHCEMRM.UserTemplateI("IdxTemplateID"," "_pTemplateID,userTempSeq))
		q:(userTempSeq="")
		s userTempRowID = $o(^DHCEMRM.UserTemplateI("IdxTemplateID"," "_pTemplateID,userTempSeq,""))
		s userTemplateObj = ##class(EMRmeta.UserTemplate).%OpenId(userTempRowID)
		s userTemplateCode = userTemplateObj.Code
		s TemplateVersionId = ##Class(EMRservice.BL.BLTemplateVersion).GetMaxPubVrnID(pTemplateID)
		continue:(TemplateVersionId="")
		continue:($d(^CacheTemp("GetUserTemplateJson",key,titleCode,"Flag",userTemplateCode))<=0)
		s flagRowId = ^CacheTemp("GetUserTemplateJson",key,titleCode,"Flag",userTemplateCode)
		d:(resultJson.Size>0) resultJson.Write(",")
		d writeJson
	}
	k ^CacheTemp("GetUserTemplateJson",key)
	q resultJson
	
writeJson
	s name = $li(^CacheTemp("GetUserTemplateJson",key,titleCode,flagRowId),2)
	s type = $li(^CacheTemp("GetUserTemplateJson",key,titleCode,flagRowId),6)
	//0 未审核，1 已审核,2 申请审核,3 重新申请审核,4 审核不通过,
	s status = $li(^CacheTemp("GetUserTemplateJson",key,titleCode,flagRowId),8)
	s:(type '= "科室模板") name = "(全院)"_name
	if ($l(status) > 1)
	{
		s temName = "("_$e(status,3,3)_"级已审核)"_name
	}
	else
	{
		s temName = $case($e(status,1,1),
				"0":"(未申请)"_name,
				"1":""_name,
				"2":"(已申请)"_name,
				"3":"(重新申请)"_name,
				"4":"(审核未通过)"_name)
	}
	if (userTemplateObj.Remark '= "")&&(status '= "1")
	{
		s temName = temName_"(备注："_userTemplateObj.Remark_")<p style='display:none'>备注："_userTemplateObj.Remark_"</p>"
	}
	d resultJson.Write("{")
	d resultJson.Write("""id"":"""_"user^"_$li(^CacheTemp("GetUserTemplateJson",key,titleCode,flagRowId),7)_"""")
	d resultJson.Write(",""text"":"""_temName_"""")
	d resultJson.Write(",""iconCls"":""loc-template""")
	d resultJson.Write(",""attributes"":{")
	d resultJson.Write("""Code"":"""_$li(^CacheTemp("GetUserTemplateJson",key,titleCode,flagRowId),1)_"""")
	d resultJson.Write(",""Status"":"""_status_"""")
	d resultJson.Write(",""SimpleSpel"":"""_$li(^CacheTemp("GetUserTemplateJson",key,titleCode,flagRowId),3)_"""")
	d resultJson.Write(",""TemplateID"":"""_$li(^CacheTemp("GetUserTemplateJson",key,titleCode,flagRowId),4)_"""")
	d resultJson.Write(",""TemplateVersionId"":"""_TemplateVersionId_"""")
	d resultJson.Write(",""TitleCode"":"""_$li(^CacheTemp("GetUserTemplateJson",key,titleCode,flagRowId),5)_"""")
	d resultJson.Write(",""Type"":"""_type_"""") 
	d resultJson.Write(",""nodetype"":""leaf""")
	d resultJson.Write("}}")
}

/// Desc:      	按分类展现目录结构，显示当前科室模板（自建文件夹及文件夹下的科室模板）
/// Creator:   	Candy
/// CreateDate:	2018-3-9
/// Input:     	ALocID:docID, ALocID:科室ID, AParentID:父节点, Key:临时global节点位置
/// Output:    	模板目录json流
/// Debug:     	w ##Class(EMRservice.BL.BLIEUserTemplate).GetGroupUserTemplateByLoc(58,93,1,0,60,"ZZNONE")
ClassMethod GetGroupUserTemplateByLoc(ADocID As %String, ALocID As %String, ATemplateID As %String, AParentID As %String, AKey As %String, ATitleCode As %String) As %GlobalBinaryStream
{
	s json = ##Class(%GlobalBinaryStream).%New()
	s userTemplateGroupState = "open"
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
				//维护程序中创建的分组没有记录TemplateID，需要通过if中的方法判断分组目录是否在该Template下
				if (obj.TemplateID = "")
				{
					s groupIds = ..GetAllGroupIDByGroupId(rowId)
					s existFlag = "0"
					for i=1:1:$l(groupIds,"^")
					{
						s tmpGroupId = $p(groupIds,"^",i)
						s tmpCode = $o(^DHCEMRM.UserTemplateGroupItemI("IdxCode"," "_tmpGroupId,""))
						s tmpCode = $tr(tmpCode," ","")
						continue:(tmpCode = "")
						s flag = $d(^CacheTemp("GetUserTemplateJson",AKey,ATitleCode,"Flag",tmpCode))
						s:(flag>0) existFlag = "1"
						q:(existFlag="1")
					}
					continue:(existFlag="0")
				}
				else
				{
					continue:(obj.TemplateID '= ATemplateID)
				}
			}
			
			d:(json.Size > 0) json.Write(",")
			d json.Write("{")
			d json.Write("""id"":"""_"group^"_rowId_"""")
			d json.Write(",""text"":"""_obj.GroupName_"""")
			d json.Write(",""GroupCode"":"""_obj.GroupCode_"""")
			d json.Write(",""state"":"""_userTemplateGroupState_"""")
			d json.Write(",""iconCls"":""""")
			d json.Write(",""attributes"":{" )
			d json.Write("""type"":""Y""")
			d json.Write(",""nodetype"":""flod""")
			d json.Write("}")
			d json.Write(",""children"":[")
			s childJson = ..GetGroupUserTemplateByLoc(ADocID,ALocID,ATemplateID,rowId,AKey,ATitleCode)
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
					s VersionNumber = $li(^CacheTemp("GetUserTemplateJson",AKey,ATitleCode,flagRowId),9)
					s TemplateVersionId = ##Class(EMRservice.BL.BLTemplateVersion).GetMaxPubVrnID(ATemplateID)
					continue:(TemplateVersionId="")
					s temName = $li(^CacheTemp("GetUserTemplateJson",AKey,ATitleCode,flagRowId),2)
				    s userTemplateObj = ##class(EMRmeta.UserTemplate).%OpenId($li(^CacheTemp("GetUserTemplateJson",AKey,ATitleCode,flagRowId),7))
		            if (userTemplateObj.Remark '= "")&&(userTemplateObj.Status '= "1")
					{
						s temName = temName_"(备注："_userTemplateObj.Remark_")<p style='display:none'>备注："_userTemplateObj.Remark_"</p>"
					}
					d:((childJson.Size >0)&&(itemCount =0)) json.Write(",") 
					d:(itemCount '=0) json.Write(",") 
		            d json.Write("{")
		            d json.Write("""id"":"""_"user^"_$li(^CacheTemp("GetUserTemplateJson",AKey,ATitleCode,flagRowId),7)_"""")
                    s templateID = $li(^CacheTemp("GetUserTemplateJson",AKey,ATitleCode,flagRowId),4)
                    s templateobj = ##Class(EMRmeta.Template).%OpenId(templateID)
                    s type = $li(^CacheTemp("GetUserTemplateJson",AKey,ATitleCode,flagRowId),6)
		            d json.Write(",""text"":"""_temName_"""")
		            d json.Write(",""iconCls"":""loc-template""")
		            d json.Write(",""attributes"":{")
					d json.Write("""Code"":"""_$li(^CacheTemp("GetUserTemplateJson",AKey,ATitleCode,flagRowId),1)_"""")
					d json.Write(",""Status"":"""_$li(^CacheTemp("GetUserTemplateJson",AKey,ATitleCode,flagRowId),8)_"""")
					d json.Write(",""SimpleSpel"":"""_$li(^CacheTemp("GetUserTemplateJson",AKey,ATitleCode,flagRowId),3)_"""")
					d json.Write(",""TemplateVersionId"":"""_TemplateVersionId_"""")
					d json.Write(",""TemplateID"":"""_$li(^CacheTemp("GetUserTemplateJson",AKey,ATitleCode,flagRowId),4)_"""")
					d json.Write(",""TitleCode"":"""_$li(^CacheTemp("GetUserTemplateJson",AKey,ATitleCode,flagRowId),5)_"""")
					d json.Write(",""Type"":"""_type_"""")
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

/// Desc:       根据GroupID获取所有叶子节点的GroupID
/// Creator:    liuyunfei
/// CreateDate: 2021-07-19
/// Table:		
/// Input:      AGroupID：科室模板分组ID
/// Output:     50^52^54
/// return:		
/// Debug:     	w ##Class(EMRservice.BL.BLIEUserTemplate).GetAllGroupIDByGroupId(50)
ClassMethod GetAllGroupIDByGroupId(AGroupID As %String) As %String
{
	s ret = ""
	q:(AGroupID = "") ret
	s ret = AGroupID
	//IdxParentID
	s rowId = ""
	for
	{
		s rowId = $o(^DHCEMRM.UserTemplateGroupI("IdxParentID"," "_AGroupID,rowId))
		q:(rowId="")
		s child = ..GetAllGroupIDByGroupId(rowId)
		s ret = ret_"^"_child
	}
	q ret
}

/// Desc:       根据docID和科室ID获取科室模板信息(包括通用)
/// Creator:    liuyunfei
/// CreateDate: 2021-06-22
/// Table:		EMRmeta.UserTemplate
/// Input:      aDocId:docID, aLocID:科室ID
/// Output:     doc层下面的科室模板信息
/// return:		二维表
/// Debug:      d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLIEUserTemplate","GetAllUserTemplate","66",93,1)
Query GetAllUserTemplate(aDocId As %String, aLocId As %String, aTemplateID As %String) As %Query(ROWSPEC = "ID:%Integer,oCode:%String,oName:%String,oSimpleSpel:%String,oTemplateID:%String,oTitleCode:%String,oType:%String,oSequence:%String,oTitleSeq:%String,oStatus:%String,oTypeDesc:%String,oVersionNumber:%String")
{
}

ClassMethod GetAllUserTemplateExecute(ByRef qHandle As %Binary, aDocId As %String, aLocId As %String, aTemplateID As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	s type = ""
	for
	{
		s type = $o(^DHCEMRM.UserTemplateI("IdxTemplateIDType"," "_aTemplateID,type))
		q:(type = "")
		s tmpType = $tr(type," ","")
		s rowID = ""
		for
		{
			s rowID = $o(^DHCEMRM.UserTemplateI("IdxTemplateIDType"," "_aTemplateID,type,rowID))
			q:(rowID = "")
	
			s objUserTemplate = ##Class(EMRmeta.UserTemplate).%OpenId(rowID)
			continue:(objUserTemplate = "")
			s Status = objUserTemplate.Status
			continue:(Status = -1)
			s Code = objUserTemplate.Code
			s Name = objUserTemplate.Name
			if ((tmpType '= "0")&&(aLocId '= ""))
			{
				continue:($d(^DHCEMRM.UserTemplateCTLocI("IdxCTLocIDAndCode"," "_aLocId," "_Code))<=0)
			}
			//continue:($o(^DHCEMRM.EMRTemplateI("IdxCategoryTemplate"," "_aDocId," "_aTemplateID,""))="")
			//continue:($d(^DHCEMRM.UserTemplateCTLocI("IdxCTLocIDAndCode"," "_aLocId," "_Code))<=0)
			s SimpleSpelName = objUserTemplate.SimpleSpelName
			s UserID = objUserTemplate.UserID
			s UserName =UserID
			s SSUSRRowId = $o(^SSU("SSUSR",0,"SSUSR_Initials",UserID,""))
			if (SSUSRRowId'="") 
			{
				s UserName = $p($g(^SSU("SSUSR",SSUSRRowId)),"^",2) //书写医生姓名
			}
			s CreateDate = objUserTemplate.CreateDate
			
			s AuditID = objUserTemplate.AuditID
			s AuditName =AuditID
			if (AuditID'="")
			{
				s AuditRowId = $o(^SSU("SSUSR",0,"SSUSR_Initials",AuditID,""))
				if (AuditRowId'="") 
				{
					s AuditName = $p($g(^SSU("SSUSR",AuditRowId)),"^",2) //审核医生姓名
				}
			}
			s AuditDate = objUserTemplate.AuditDate
			
			s Sequence = objUserTemplate.Sequence
			s VersionNumber = objUserTemplate.VersionNumber
			s Remark = objUserTemplate.Remark
			s Type = objUserTemplate.Type
			s TypeDese = $case(Type,"0":"全院通用",:"科室模板")
			s objTemplate = ##Class(EMRmeta.Template).%OpenId(aTemplateID)
			continue:(objTemplate = "")
			s path = objTemplate.Name _"/"_Name				
			Set key = objTemplate.TemplateCategoryID
			do
			{ 
				s objTemplateCate = ##Class(EMRmeta.TemplateCategory).%OpenId(key)
				q:(objTemplateCate = "")
				s key = objTemplateCate.ParentID
				s path = objTemplateCate.Name _"/"_path
			} 
			while (key '="0" )
			s CTLocID = ""
			s CTLocName = ""
			s rowCTID = ""
			s rowCTID = $o(^DHCEMRM.UserTemplateCTLocI("IdxCTLocIDAndCode"," "_aLocId," "_$g(Code),rowCTID))
			s objUserTemCT = ##Class(EMRmeta.UserTemplateCTLoc).%OpenId(rowCTID)
			if (objUserTemCT '="")
			{
				s CTLocID = objUserTemCT.CTLocID
				s CTLocName = objUserTemCT.CTLocName
			}
			s TitleCode =""
			s TitleName =""
			s rowTitleID = ""
			s rowTitleID = $o(^DHCEMRM.UserTemplateTitleI("IdxCode"," "_$g(Code),rowTitleID))
			s objUserTemTitle = ##Class(EMRmeta.UserTemplateTitle).%OpenId(rowTitleID)
			if (objUserTemTitle '="")
			{
				s TitleCode = objUserTemTitle.TitleCode
				s TitleName = objUserTemTitle.TitleName
			}
			s DiagnosCode =""
			s DiagnosName =""
			s rowDiseaseID = ""
			s rowDiseaseID = $o(^DHCEMRM.UserTemplateDiseaseI("IdxCode"," "_$g(Code),rowDiseaseID))
			s objUserTemDisease = ##Class(EMRmeta.UserTemplateDisease).%OpenId(rowDiseaseID)
			if (objUserTemDisease '="")
			{
				s DiagnosCode = objUserTemDisease.DiagnosCode
				s DiagnosName = objUserTemDisease.DiagnosName
			}
			//根据参数判断是否开启默认标题分组
		    s UserTemplateDefaultGroup=##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("UserTemplateDefaultGroup","N")
			s titleCodeSeq = TitleCode
		    s:((titleCodeSeq = "")||(UserTemplateDefaultGroup = "N")) titleCodeSeq = "ZZNONE"
			//s Data = $lb(rowID,Code,Name,aTemplateID,SimpleSpelName,UserID,UserName,CreateDate,AuditID,AuditName,AuditDate,Type,Sequence,Status,VersionNumber,rowCTID,CTLocID,CTLocName,rowTitleID,TitleCode,TitleName,Remark,path,rowDiseaseID,DiagnosCode,DiagnosName)
			s Data = $lb(rowID,Code,Name,SimpleSpelName,aTemplateID,TitleCode,Type,Sequence,titleCodeSeq,Status,TypeDese,VersionNumber)
			s ^CacheTemp(repid,ind) = Data
			s ind = ind + 1	
		}
	}
	q $$$OK
}

ClassMethod GetAllUserTemplateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllUserTemplateExecute ]
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

ClassMethod GetAllUserTemplateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllUserTemplateExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// Desc:       添加科室模板分组（自建文件夹）
/// Creator:    liuyunfei
/// CreateDate: 2021-06-21
/// Input:      LocID:科室ID, GroupName:文件夹名称, ParentID:父节点id, TemplateID:TemplateID
/// Output:     0：失败 / id：成功
/// return:		string
/// Debug:     	w ##Class(EMRservice.BL.BLIEUserTemplate).AddUserTemplateGroup(93,1212,36,58)
ClassMethod AddUserTemplateGroup(LocID As %String, GroupName As %String, ParentID As %String, TemplateID As %String) As %String
{
	s ret = 0
	s:(ParentID = TemplateID) ParentID=0	//如果父节点是基础模板，则父节点置为0
	s entity = ##class(EMRservice.entity.EUserTemplateGroup).%New()
	s entity.CTLocID =  LocID
	s rowId = $o(^DHCEMRM.UserTemplateGroupD(""),-1)
	s:(rowId="") rowId = 0
	s entity.GroupCode = "GC_"_rowId_"1"
	s entity.GroupName = GroupName
	s entity.ParentID = ParentID
	s entity.TemplateID = TemplateID
	s emrTemID = $o(^DHCEMRM.EMRTemplateI("IdxBindTemplateID"," "_TemplateID,""))
	s objEmrTem =##class(EMRmeta.EMRTemplate).%OpenId(emrTemID)
	q:(objEmrTem="")
	s docID = objEmrTem.CategoryID
	s entity.EMRDocID = docID
	s ret = ##class(EMRservice.BL.BLUserTemplateGroup).AddUserTemplateGroup(entity)
	q ret
}

/// Desc:       删除科室模板分组（自建文件夹）
/// Creator:    liuyunfei
/// CreateDate: 2021-06-21
/// Input:      GroupID:模板分组（文件夹）id
/// Output:     0：失败 / 1：成功
/// return:		string
/// Debug:     	w ##Class(EMRservice.BL.BLIEUserTemplate).DeleteUserTemplateGroup(45)
ClassMethod DeleteUserTemplateGroup(GroupID As %String) As %String
{
	s ret = 0
	s ret = ##class(EMRservice.BL.BLUserTemplateGroup).DelUserTemplateGroup(GroupID)
	q ret
}

/// Desc:       删除科室模板
/// Creator:    liuyunfei
/// CreateDate: 2021-06-22
/// Input:      Code:科室模板Code值
/// Output:     0：失败 / 1：成功
/// return:		string
/// Debug:     	w ##Class(EMRservice.BL.BLIEUserTemplate).DeleteUserTemplate(63)
ClassMethod DeleteUserTemplate(Code As %String) As %String
{
	s ret = 0
	s ret = ##class(EMRservice.BL.BLUserTemplate).DelUserTemplateAll(Code)
	q ret
}

/// Desc:       移动科室模板分组（自建文件夹）（同级）（上移/下移）
/// Creator:    liuyunfei
/// CreateDate: 2021-06-21
/// Input:      GroupID:模板分组（文件夹）id, MoveType:操作类型（UP:上移）
/// Output:     0：失败 / 1：成功
/// return:		string
/// Debug:     	w ##Class(EMRservice.BL.BLIEUserTemplate).MoveFlodNode(37,"UP")
ClassMethod MoveFlodNode(GroupID As %String, MoveType) As %String
{
	s ret = 0
	q:(GroupID = "") ret
	s obj = ##class(EMRmeta.UserTemplateGroup).%OpenId(GroupID)
	s parentID = obj.ParentID
	s sequence = obj.Sequence
	if (MoveType = "UP")	//上移
	{
		s upSequence = $o(^DHCEMRM.UserTemplateGroupI("IdxSeq"," "_parentID,sequence),-1)
		s GrouRowId = $o(^DHCEMRM.UserTemplateGroupI("IdxSeq"," "_parentID,upSequence,""))
		
	}
	else	//下移
	{
		s downSequence = $o(^DHCEMRM.UserTemplateGroupI("IdxSeq"," "_parentID,sequence))
		s GrouRowId = $o(^DHCEMRM.UserTemplateGroupI("IdxSeq"," "_parentID,downSequence,""))
	}
	s ret = ##class(EMRservice.BL.BLUserTemplateGroup).SwapUserTemplateCatSeq(GroupID,GrouRowId)
	q ret
}

/// Desc:       移动科室模板顺序（同级）（上移/下移）
/// Creator:    liuyunfei
/// CreateDate: 2021-06-22
/// Input:      UserTemplateIDInfo:科室模板id（该参数包含三部分，用"#"分隔，第一个是要移动的id，第二个是该id的同级目录的上一个id，第三个是同级目录的下一个id）
/// 			 	MoveType:操作类型（UP:上移/DOWN：下移）
/// Output:     0：失败 / 1：成功
/// return:		string
/// Debug:     	w ##Class(EMRservice.BL.BLIEUserTemplate).MoveLeafNode("56#55#","UP")
ClassMethod MoveLeafNode(UserTemplateIDInfo As %String, MoveType As %String) As %String
{
	s ret = 0
	q:($p(UserTemplateIDInfo,"#",1) = "") ret
	s obj = ##class(EMRmeta.UserTemplate).%OpenId($p(UserTemplateIDInfo,"#",1))
	Tstart
	if ($p(UserTemplateIDInfo,"#",2) '= "")
	{
		if (MoveType = "UP")
		{
			s obj1 = ##class(EMRmeta.UserTemplate).%OpenId($p(UserTemplateIDInfo,"#",2))
		}
		else
		{
			s obj1 = ##class(EMRmeta.UserTemplate).%OpenId($p(UserTemplateIDInfo,"#",3))
		}
		if (obj1 = "")
		{
			Trollback
			q ret
		}
		s tmpSequence = obj.Sequence
		s obj.Sequence = obj1.Sequence
		s obj1.Sequence = tmpSequence
		s sc=obj.%Save() 
		if $$$ISERR(sc)
		{
			Trollback
			q ret
		}
		set sc1=obj1.%Save() 
		if $$$ISERR(sc1)
		{
			Trollback
			q ret
		}
		do obj.%Close()
		do obj1.%Close()
	}
	
	s Code = obj.Code
	s GroupItemRowId = $o(^DHCEMRM.UserTemplateGroupItemI("IdxUserCode"," "_Code,""))
	if (GroupItemRowId '= "")
	{
		s groupItemObj = ##class(EMRmeta.UserTemplateGroupItem).%OpenId(GroupItemRowId)
		s GroupID = groupItemObj.GroupID
		s Sequence = groupItemObj.Sequence
		if (MoveType = "UP")	//上移
		{
			s upSequence = $o(^DHCEMRM.UserTemplateGroupItemI("IdxSeq"," "_GroupID,Sequence),-1)
			s Code = $o(^DHCEMRM.UserTemplateGroupItemI("IdxSeq"," "_GroupID,upSequence,""))
			s GroupItemRowId1 = $o(^DHCEMRM.UserTemplateGroupItemI("IdxSeq"," "_GroupID,upSequence,Code,""))
		}
		else	//下移
		{
			s downSequence = $o(^DHCEMRM.UserTemplateGroupItemI("IdxSeq"," "_GroupID,Sequence))
			s Code = $o(^DHCEMRM.UserTemplateGroupItemI("IdxSeq"," "_GroupID,downSequence,""))
			s GroupItemRowId1 = $o(^DHCEMRM.UserTemplateGroupItemI("IdxSeq"," "_GroupID,downSequence,Code,""))
		}
		s result = ##class(EMRservice.BL.BLUserTemplateGroup).SwapUserTemplateItemSeq(GroupItemRowId,GroupItemRowId1)
		if (result = "0")
		{
			Trollback
			q ret
		}
	}
	
	Tcommit
	s ret = 1

	q ret
}

/// Desc:       修改科室模板分组名称（自建文件夹）
/// Creator:    liuyunfei
/// CreateDate: 2021-06-21
/// Input:      GroupID:模板分组（文件夹）id, FlodName:分组名称
/// Output:     0：失败 / 1：成功
/// return:		string
/// Debug:     	w ##Class(EMRservice.BL.BLIEUserTemplate).ModifyGroupName(37,"新名字")
ClassMethod ModifyGroupName(GroupId As %String, FlodName As %String) As %String
{
	s ret = 0
	s obj = ##Class(EMRmeta.UserTemplateGroup).%OpenId(GroupId)
	s obj.GroupName = FlodName
	s sc = obj.%Save()
	if ($$$ISOK(sc))
	{
		s ret=1
	}
	q ret
}

/// Desc:       修改科室模板名称
/// Creator:    liuyunfei
/// CreateDate: 2021-06-22
/// Input:      UserTemplateID:科室模板id, UserTemplateName:科室模板名称, UserID:用户ID
/// Output:     0：失败 / 1：成功
/// return:		string
/// Debug:     	w ##Class(EMRservice.BL.BLIEUserTemplate).ModifyUserTemplateName(37,"新名字","10209")
ClassMethod ModifyUserTemplateName(UserTemplateID As %String, UserTemplateName As %String, UserID As %String) As %String
{
	s ret = 0
	s obj = ##Class(EMRmeta.UserTemplate).%OpenId(UserTemplateID)
	s obj.Name = UserTemplateName
	s obj.SimpleSpelName = ##class(EMRservice.Tools.Tool).GetCNCODE(UserTemplateName,4,"")
	s obj.ModifyDate = $zd($p($h,",",1),3)_" "_$zt($p($h,",",2))
	s obj.ModifyID = UserID
	s sc = obj.%Save()
	if ($$$ISOK(sc))
	{
		s ret=1
	}
	q ret
}

/// Desc:       更新科室模板节点位置（拖拽）
/// Creator:    liuyunfei
/// CreateDate: 2021-06-23
/// Input:      UserTemplateCode:科室模板Code,OldGroupID:分组（自建文件夹）id, NewGroupID:分组（自建文件夹）id
/// Output:     0：失败 / 1：成功
/// return:		string
/// Debug:     	w ##Class(EMRservice.BL.BLIEUserTemplate).UpdateNodeLocation(57,"33")
ClassMethod UpdateNodeLocation(UserTemplateCode As %String, OldGroupID As %String, NewGroupID As %String) As %String
{
	s ret = 0
	s ret = ##class(EMRservice.BL.BLUserTemplateGroup).UpUserTemplateGroupItem(UserTemplateCode,OldGroupID,NewGroupID)
	q ret
}

/// Desc:       新建科室模板
/// Creator:    liuyunfei
/// CreateDate: 2021-06-28
/// Input:      UserTempInfo：科室模板id（新建时被继承的模板id）^科室模板名称^基础模板id^创建者^科室模板状态^修改者^ip地址
/// 				LocID：科室id，TitleInfo：code+" "+desc
/// Output:     ""：失败/id：新建科室模板的rowId
/// return:		string
/// Debug:     	w ##Class(EMRservice.BL.BLIEUserTemplate).AddUserTemplate("1^测试^1^10209^0^778^10209^","93")
ClassMethod AddUserTemplate(UserTempInfo As %String, LocID As %String, TitleInfo As %String) As %String
{
	s result = ""
	q:($p(UserTempInfo,"^",1)="") result
	s entity = ##Class(EMRservice.entity.EUserTemplate).%New()
	s entity.Code = $o(^DHCEMRM.UserTemplateD(""),-1)+1
	s entity.Name = $p(UserTempInfo,"^",2)
	s entity.TemplateID = $p(UserTempInfo,"^",3)
	s entity.SimpleSpelName = ##class(EMRservice.Tools.Tool).GetCNCODE($p(UserTempInfo,"^",2),4,"")
	s entity.UserID = $p(UserTempInfo,"^",4)
	s entity.Status = $p(UserTempInfo,"^",5)
	s entity.Type = "1"
	s entity.CreateDate =  $ZDATE($h,3)_" "_ $ZTIME($PIECE($H,",",2),1)
	s obj = ##class(EMRmeta.Template).%OpenId($p(UserTempInfo,"^",3))
	s entity.VersionNumber = obj.PublishVersion
	s entity.ModifyID = $p(UserTempInfo,"^",7)
	s entity.ModifyDate = $ZDATE($h,3)_" "_ $ZTIME($PIECE($H,",",2),1)
	s entity.OperateMachineIP = $p(UserTempInfo,"^",8)
	
	s LocName = $p(^CTLOC(LocID),"^",2)
	s result = ##Class(EMRservice.BL.BLUserTemplate).AddUserTemplate(entity,LocID,LocName,$p(TitleInfo," ",1),TitleInfo,"","")
	q result
}

/// Desc:       修改科室模板
/// Creator:    liuyunfei
/// CreateDate: 2021-06-29
/// Table:		
/// Input:      UserTempInfo:科室模板ID^修改者^ip地址，LocID：科室id，TitleInfo：code+" "+desc
/// Output:     0:失败/1:成功
/// return:		string
/// Debug:     	w ##Class(EMRservice.BL.BLIEUserTemplate).ModifyUserTemplate("1^10209^ip","93","EMR100002 日常病程记录")
ClassMethod ModifyUserTemplate(UserTempInfo As %String, LocID As %String, TitleInfo As %String) As %String
{
	s result = ""
	q:($p(UserTempInfo,"^",1)="") result
	s userTempObj = ##Class(EMRmeta.UserTemplate).%OpenId($p(UserTempInfo,"^",1))
	s entity = ##Class(EMRservice.entity.EUserTemplate).%New()
	s entity.ID = $p(UserTempInfo,"^",1)
	s entity.Code = userTempObj.Code
	s entity.Name = userTempObj.Name
	s entity.TemplateID = userTempObj.TemplateID
	s entity.SimpleSpelName = userTempObj.SimpleSpelName
	s entity.UserID = userTempObj.UserID
	s entity.Status = userTempObj.Status
	s entity.Type = "1"
	s entity.Sequence = userTempObj.Sequence
	s entity.VersionNumber = userTempObj.VersionNumber
	s entity.ModifyID = $p(UserTempInfo,"^",2)
	s entity.ModifyDate = $ZDATE($h,3)_" "_ $ZTIME($PIECE($H,",",2),1)
	s entity.OperateMachineIP = $p(UserTempInfo,"^",3)
	
	s entityCTLoc = ##class(EMRservice.entity.EUserTemplateCTLoc).%New()
	s entityCTLoc.Code = userTempObj.Code
	s entityCTLoc.CTLocID = LocID
	s entityCTLoc.CTLocName = $p(^CTLOC(LocID),"^",2)
	
	s entityTitle = ##class(EMRservice.entity.EUserTemplateTitle).%New()
	s entityTitle.Code = userTempObj.Code
	s entityTitle.TitleCode = $p(TitleInfo," ",1)
	s entityTitle.TitleName = $p(TitleInfo," ",1)
	s result = ##Class(EMRservice.BL.BLUserTemplate).ModUserTemplate(entity,entityCTLoc,entityTitle,"")
	q result
}

/// Desc:       添加或修改科室模板章节继承关系
/// Creator:    liuyunfei
/// CreateDate: 2021-06-29
/// Table:		EMRmeta.UserTemplate/EMRmeta.UserTemplateSectionRelation
/// Input:      UserTemplateID：科室模板RowID,SectionCode：章节code,SectionName：章节描述,Status：继承关系（REPLACE/REFERENCE）
/// Output:     ""/id
/// return:		string
/// Debug:     	w ##Class(EMRservice.BL.BLIEUserTemplate).SetUserTemplateSectionRelation("91","S002","主诉","REFERENCE")
ClassMethod SetUserTemplateSectionRelation(UserTemplateID As %String, SectionCode As %String, SectionName As %String, Status As %String) As %String
{
	s result = ""
	q:(UserTemplateID="") result
	
	s obj = ##Class(EMRmeta.UserTemplate).%OpenId(UserTemplateID)
	s entity = ##class(EMRservice.entity.EUserTemplateSectionRelation).%New()
	s entity.TemplateID = obj.TemplateID
	s entity.Code = obj.Code
	s entity.Name = obj.Name
	s entity.SectionCode = SectionCode
	s entity.SectionName = SectionName
	s entity.Status = Status
	s rowID = $o(^DHCEMRM.UserTemplateRelationI("IdxCodeSection"," "_$zcvt(obj.Code,"U")," "_$zcvt(SectionCode,"U"),""))
	if (rowID = "")
	{
		s result = ##Class(EMRservice.BL.BLUserTemplateSectionRelation).AddUserTemplateSection(entity)
	}
	else
	{
		s result = ##Class(EMRservice.BL.BLUserTemplateSectionRelation).ModUserTemplateSection(entity)
	}
	q result
}

/// Desc:       获取科室模板章节继承关系
/// Creator:    liuyunfei
/// CreateDate: 2021-06-25
/// Table:		EMRmeta.UserTemplateSectionRelation
/// Input:      UserTemplateCode:科室模板Code
/// Output:     S001:REFERENCE:患者基本信息^S002:REFERENCE:主诉：^S003:REFERENCE:现病史：^S004:REFERENCE:既往史：^S005:REFERENCE:个人史：
/// return:		string
/// Debug:     	w ##Class(EMRservice.BL.BLIEUserTemplate).GetSectionRelationS(76)
ClassMethod GetSectionRelationS(UserTemplateCode As %String) As %String
{
	s result = ""
	q:(UserTemplateCode = "") result
	s rowID = ""
	for
	{
		s rowID = $o(^DHCEMRM.UserTemplateRelationI("IdxCode"," "_UserTemplateCode,rowID))
		q:(rowID = "")
		s relationobj = ##class(EMRmeta.UserTemplateSectionRelation).%OpenId(rowID)
		continue:(relationobj = "")
		s:(result'="") result = result_"^"
		s result = result_relationobj.SectionCode_":"_relationobj.Status_":"_relationobj.SectionName
	}
	q result
}

/// Desc:       根据TemplateID获取标题信息
/// Creator:    liuyunfei
/// CreateDate: 2021-06-29
/// Table:		
/// Input:      ATemplateID：模板ID
/// Output:     [{"RowID":"2","TitleName":"EMR100002 日常病程记录"},{"RowID":"22","TitleName":"EMR100022 术后病程记录"}]
/// return:		TitleName字段是用code和desc拼在一起，中间用空格隔开
/// Debug:     	w ##Class(EMRservice.BL.BLIEUserTemplate).GetAllTitlesByTempID(4)
ClassMethod GetAllTitlesByTempID(ATemplateID As %String) As %GlobalCharacterStream
{
	s json = ##Class(%GlobalCharacterStream).%New()
	q:(ATemplateID="") json
	d json.Write("[")
	s result = ##class(%ResultSet).%New("EMRservice.BL.BLUserTemplate:SELECTALLTITLES")
	d result.Execute(ATemplateID)
	s count = 0
	while result.%Next()
	{
		d:(count '=0) json.Write(",")
		d json.Write("{""RowID"":"""_result.Data("ID")_"""")
		d json.Write(",""TitleName"":"""_result.Data("Code")_" "_result.Data("Description")_"""}")
		s count = count+1
	}
	d json.Write("]")
	
	q json
}

/// Desc:       修改科室模板状态
/// Creator:    liuyunfei
/// CreateDate: 2021-06-29
/// Table:		EMRmeta.UserTemplate
/// Input:      AUserTemplateID：科室模板ID （可以是多个id，用^分隔）,AStatus：状态码,MaxLevel：最高级角色等级,AIpAddress:ip地址
/// Output:     0:失败,1:成功
/// return:		
/// Debug:     	w ##Class(EMRservice.BL.BLIEUserTemplate).ModifyUserTempStatus(100,2)
ClassMethod ModifyUserTempStatus(AUserTemplateID As %String, AStatus As %String, AMemo As %String, AUserID As %String, MaxLevel As %String, AIpAddress As %String) As %String
{
	s ret = 1
	q:(AUserTemplateID="")||(AStatus="") ret
	Tstart
	for i=1:1:$l(AUserTemplateID,"^")
	{
		s RowID = $p(AUserTemplateID,"^",i)
		q:(RowID="")
		s obj = ##Class(EMRmeta.UserTemplate).%OpenId(RowID)
		continue:(obj = "")

		s date = $p($h,",",1), time = $p($h,",",2)
		s obj.Status = AStatus
		if (AStatus = "1")
		{
			s obj.AuditDate = $zd(date,3)_" "_$zt(time,1)
			s obj.AuditID = AUserID
		}
		s:(AMemo'="") obj.Remark = AMemo
		s sc = obj.%Save()
		if ($$$ISERR(sc))
		{
			Trollback
			s ret = 0
			q
		}
		else
		{
			if (AStatus = 4)	//退回
			{
				s isBack = ..SetAuditLogStatus(RowID,AUserID,time,AMemo,AIpAddress)
				if (isBack = 0)
				{
					Trollback
					s ret = 0
					q
				}
			}
			else
			{
				continue:(AStatus = "2")||(AStatus = "3")	//申请时不记录日志

				s action = "AUDIT"
				if (MaxLevel < 2) 		//只有一级审核
				{
					s level = "1"
				}
				else
				{
					if (AStatus = "1")	//最高级
					{
						s level = MaxLevel
					}
					else
					{
						s level = $p(AStatus,".",2)
					}
				}
				s saveLog = ##Class(EMRservice.BL.BLIEUserTemplate).CreateLog(RowID,AUserID,time,action,level,AMemo,AIpAddress)
				if (saveLog = "0")
				{
					Trollback
					s ret = 0
					q
				}
			}
		}
	}
	if (ret = 0)
	{
		Trollback
		q 0
	}
	Tcommit
	q 1
}

/// Desc:       添加科室模板操作日志
/// Creator:    liuyunfei
/// CreateDate: 2022-11-02
/// Table:		EMRinstance.UserTemplateLog
/// Input:      AUserTemplateID：科室模板ID （可以是多个id，用^分隔）,Action：操作类型,AStatus：状态码,MaxLevel：最高级角色等级,AMemo:备注，AIpAddress：ip地址
/// Output:     0:失败,1:成功
/// return:		
/// Debug:     	w ##Class(EMRservice.BL.BLIEUserTemplate).CreateLog(100,2)
ClassMethod CreateLog(UserTemplateID As %String, AuditID As %String, AuditTime As %String, Action As %String, Level As %String, AMemo As %String, AIpAddress As %String) As %String
{
	s ret = "0"
	q:(UserTemplateID = "") ret
	s obj = ##class(EMRmeta.UserTemplateLog).%New()
	s obj.AuditDate = $p($h,",",1)
	s obj.AuditTime = AuditTime
	s obj.AuditID = AuditID
	d obj.UserTemplateIDSetObjectId(UserTemplateID)
	s obj.Action = Action
	s obj.Levle = Level
	s obj.CreateDate = $p($h,",",1)
	s obj.CreateTime = $p($h,",",2)
	s obj.Remark = AMemo
	s obj.OperateMachineIP = AIpAddress
	if (obj.%Save())
	{
		s ret = "1"
	}
	q ret
}

/// Desc:       把之前审核通过的日志数据标记为退回状态
/// Creator:    liuyunfei
/// CreateDate: 2022-11-02
/// Table:		EMRmeta.UserTemplateLog
/// Input:      AUserTemplateID：科室模板ID, AMemo退回时的备注, AIpAddress:ip地址
/// Output:     0:失败,1:成功
/// return:		
/// Debug:     	w ##Class(EMRservice.BL.BLIEUserTemplate).SetAuditLogStatus(55)
ClassMethod SetAuditLogStatus(UserTemplateID As %String, AUserID As %String, ATime As %String, AMemo As %String, AIpAddress As %String) As %String
{
	s ret = 1
	s rowId = ""
	for
	{
		s rowId = $o(^DHCEMRM.UserTemplateLogI("IdxIDAndAction",UserTemplateID," AUDIT",rowId))
		q:(rowId = "")
		
		s obj = ##class(EMRmeta.UserTemplateLog).%OpenId(rowId)
		s obj.IsBack = "Y"
		s sc = obj.%Save()
		if (sc)
		{
			s ret = 1
		}
		else
		{
			s ret = 0
			q
		}
	}
	if (ret = 1)
	{
		s ret = ..CreateLog(UserTemplateID,AUserID,ATime,"BACK","",AMemo,AIpAddress)
	}
	q ret
}

/// Desc:       获取审核日志数据
/// Creator:    liuyunfei
/// CreateDate: 2022-11-07
/// Table:		EMRmeta.UserTemplateLog
/// Input:      AUserTemplateID：科室模板ID 
/// Output:     审核人^审核日期
/// return:		
/// Debug:     	w ##Class(EMRservice.BL.BLIEUserTemplate).GetAuditLog(55,1)
ClassMethod GetAuditLog(UserTemplateID As %String) As %String
{
	s ret = ""
	s rowId = ""
	for
	{
		s rowId = $o(^DHCEMRM.UserTemplateLogI("IdxIDAndAction",UserTemplateID," AUDIT",rowId))
		q:(rowId = "")
		
		s obj = ##class(EMRmeta.UserTemplateLog).%OpenId(rowId)
		continue:(obj.IsBack = "Y")
		
		s auditor = obj.AuditID
		s:(auditor '= "") auditor = $p($g(^SSU("SSUSR",obj.AuditID)),"^",2)
		// 因为有些科室模板是在维护程序中创建的，admin等用户不在his中，所以还显示id
		s:(auditor = "") auditor = obj.AuditID
		
		s date = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",obj.AuditDate)
		s time = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",obj.AuditTime)
		s:(ret'= "") ret = ret_"@" 
		s ret = ret_obj.Levle_"^"_auditor_"^"_date_" "_time
	}
	q ret
}

/// Desc:       获取科室模板信息通过status
/// Creator:    liuyunfei
/// CreateDate: 2021-06-29
/// Table:		EMRmeta.UserTemplate
/// Input:      AStatus：状态码，AlocID：科室id，AUserTemplateName，科室模板名称
/// Output:     {"rows":[],"total":"0"}
/// return:		json stream
/// Debug:		w ##Class(EMRservice.BL.BLIEUserTemplate).GetUserTemplateByStatus(2,"","",2)
ClassMethod GetUserTemplateByStatus(AStatus As %String, ALocID As %String, AUserTemplateName As %String, AHospitalID As %String, AMaxLevel As %String) As %GlobalCharacterStream
{
	s json = ##Class(%GlobalCharacterStream).%New()
	
	d json.Write("{""rows"":[")
	s count = 0
	for m=1:1:$l(AStatus,"@")
	{
		s status = $p(AStatus,"@",m)
		s squence = ""
		for
		{
			s squence = $o(^DHCEMRM.UserTemplateI("IdxSequence",squence))
			q:(squence="")
			s rowID = $o(^DHCEMRM.UserTemplateI("IdxSequence",squence,""))
			s obj = ##Class(EMRmeta.UserTemplate).%OpenId(rowID)
			q:(obj="")
			continue:(obj.Status '= status)
			s TemplateVersionId = ##Class(EMRservice.BL.BLTemplateVersion).GetMaxPubVrnID(obj.TemplateID)
			s Code = obj.Code
			s CTName = ""
			if (ALocID '= "")
			{
				s CTName = $p(^CTLOC(ALocID),"^",2)
				s CTLocRowId = $o(^DHCEMRM.UserTemplateCTLocI("IdxCTLocIDAndCode"," "_ALocID," "_Code,""))
				continue:(CTLocRowId="")
			}
			else
			{
				s CTLocRowId = $o(^DHCEMRM.UserTemplateCTLocI("IdxCode"," "_Code,""))
				if (CTLocRowId '= "")
				{
					s objCTLoc = ##class(EMRmeta.UserTemplateCTLoc).%OpenId(CTLocRowId)
					if (AHospitalID '= "")&&(##class(%Dictionary.CompiledMethod).%ExistsId("web.DHCBL.BDP.BDPMappingHOSP||GetHospShowDataFlagSpecial") '= "0")
					{
						s flag = ##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlagSpecial("CT_Loc",objCTLoc.CTLocID,AHospitalID,"","Emr_IP_DHCEMRUserTemplate")
						continue:(flag '= "Y")
					}
					s:(objCTLoc '= "") CTName = objCTLoc.CTLocName
				}
			}
			//////过滤掉门诊个人模板分享为科室模板的数据 start///////////////
			//continue:(CTName["门诊")
			//////过滤掉门诊个人模板分享为科室模板的数据 end  ///////////////
			if (AUserTemplateName '= "")
			{
				continue:'(obj.Name[AUserTemplateName)
			}
			
			s objTemplate = ##Class(EMRmeta.Template).%OpenId(obj.TemplateID)
			continue:(objTemplate = "")
			s path = objTemplate.Name _"/"_obj.Name				
			s key = objTemplate.TemplateCategoryID
			do
			{ 
				s objTemplateCate = ##Class(EMRmeta.TemplateCategory).%OpenId(key)
				q:(objTemplateCate = "")
				s key = objTemplateCate.ParentID
				s path = objTemplateCate.Name _"/"_path
			} 
			while (key '="0" )
			
			s creator = obj.UserID
			s auditor = obj.AuditID
			s:(creator '= "") creator = $p($g(^SSU("SSUSR",obj.UserID)),"^",2)
			s:(auditor '= "") auditor = $p($g(^SSU("SSUSR",obj.AuditID)),"^",2)
			// 因为有些科室模板是在维护程序中创建的，admin等用户不在his中，所以还显示id
			s:(creator = "") creator = obj.UserID
			s:(auditor = "") auditor = obj.AuditID
			s dateTime = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","DateTime",obj.AuditDate)
			s auditLogInfo = ""
			s:(AMaxLevel '= 1) auditLogInfo = ..GetAuditLog(rowID)
			
			d:(count '=0) json.Write(",")
			d json.Write("{""RowID"":"""_rowID_"""")
			d json.Write(",""UserTemplateName"":"""_obj.Name_"""")
			d json.Write(",""Code"":"""_Code_"""")
			d json.Write(",""Creator"":"""_creator_"""")
			d json.Write(",""CreateTime"":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","DateTime",obj.CreateDate)_"""")
			for i=1:1:$l(auditLogInfo,"@")
			{
				s auditLog = $p(auditLogInfo,"@",i)
				q:(auditLog = "")
				d json.Write(",""Auditor"_$p(auditLog,"^",1)_""":"""_$p(auditLog,"^",2)_"""")
				d json.Write(",""AuditTime"_$p(auditLog,"^",1)_""":"""_$p(auditLog,"^",3)_"""")
			}
			if (auditLogInfo = "")
			{
				d json.Write(",""Auditor"_AMaxLevel_""":"""_auditor_"""")
				d json.Write(",""AuditTime"_AMaxLevel_""":"""_dateTime_"""")
			}
			d json.Write(",""Auditor"":"""_auditor_"""")
			d json.Write(",""AuditTime"":"""_dateTime_"""")
			d json.Write(",""LocName"":"""_CTName_"""")
			d json.Write(",""TemplateVersionId"":"""_TemplateVersionId_"""")
			d json.Write(",""Path"":"""_path_"""")
			d json.Write(",""Memo"":"""_obj.Remark_"""")
			d json.Write("}")
			s count = count+1
		}
	}
	d json.Write("]")
	d json.Write(",""total"":"""_count_"""")
	d json.Write("}")
	q json
}

/// Desc:       获取全部院区信息
/// Creator:    liuyunfei
/// CreateDate: 2021-06-29
/// Table:		
/// Input:      ASessionStr:用户ID^安全组ID^科室ID^当前登录医院ID
/// Output:     [{"RowID":"2","Desc":"东华标准版数字化医院[总院]"},{"RowID":"3","Desc":"东华标准版数字化口腔医院"},{"RowID":"9","Desc":"东华标准版数字化医院[西院]"},{"RowID":"10","Desc":"东华标准版数字化医院[东院]"}]
/// return:		json stream
/// Debug:		w ##Class(EMRservice.BL.BLIEUserTemplate).GetAllHospitalID("1^1^1^2")
ClassMethod GetAllHospitalID(ASessionStr As %String) As %GlobalCharacterStream
{
	s json = ##Class(%GlobalCharacterStream).%New()
	d json.Write("[")
	if (##class(%Dictionary.CompiledQuery).%ExistsId("web.DHCBL.BDP.BDPMappingHOSP||GetHospDataForCombo") '= "0")
	{
		s result = ##class(%ResultSet).%New("web.DHCBL.BDP.BDPMappingHOSP:GetHospDataForCombo")
		d result.Execute("","","EMR_UserTemplate",ASessionStr)
		s count = 0
		while result.%Next()
		{
			d:(count '=0) json.Write(",")
			d json.Write("{""RowID"":"""_result.Data("HOSPRowId")_"""")
			d json.Write(",""Desc"":"""_result.Data("HOSPDesc")_"""}")
			s count = count+1
		}
	}
	d json.Write("]")
	q json
}

/// Desc:       根据院区id获取全部科室信息
/// Creator:    liuyunfei
/// CreateDate: 2021-06-29
/// Table:		
/// Input:      AHospitalID:院区id
/// Output:     [{"RowID":"0","Desc":""},{"RowID":"1","Desc":"呼吸内科门诊"},{"RowID":"2","Desc":"消化内科门诊"},{"RowID":"3","Desc":"血液内科门诊"}]
/// return:		json stream
/// Debug:		w ##Class(EMRservice.BL.BLIEUserTemplate).GetAllLocInfo()
ClassMethod GetAllLocInfo(AHospitalID As %String) As %GlobalCharacterStream
{
	s json = ##Class(%GlobalCharacterStream).%New()
	q:(AHospitalID="") json
	d json.Write("[")
	s RowId = ""
	s count = 0
	for
	{
		s RowId = $o(^CTLOC(RowId))
		q:(RowId="")
		if (##class(%Dictionary.CompiledMethod).%ExistsId("web.DHCBL.BDP.BDPMappingHOSP||GetHospShowDataFlagSpecial") '= "0")
		{
			s flag = ##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlagSpecial("CT_Loc",RowId,AHospitalID,"","Emr_IP_DHCEMRUserTemplate")
			continue:(flag '= "Y")
		}
		d:(count '=0) json.Write(",")
		d json.Write("{""RowID"":"""_RowId_"""")
		d json.Write(",""Desc"":"""_$p(^CTLOC(RowId),"^",2)_"""}")
		s count = count+1
	}
	d json.Write("]")
	q json
}

/// Desc:       撤回已通过审核的模板
/// Creator:    liuyunfei
/// CreateDate: 2021-07-05
/// Table:		EMRmeta.UserTemplate/EMRmeta.UserTemplateGroupItem
/// Input:      AUserTemplateID：科室模板ID
/// Output:     0:失败,1:成功
/// return:		
/// Debug:     	w ##Class(EMRservice.BL.BLIEUserTemplate).WithdrawAudit(2923)
ClassMethod WithdrawAudit(AUserTemplateID As %String, AUserID As %String, AIpAddress As %String) As %String
{
	s ret = 1
	q:(AUserTemplateID="") ret
	Tstart
	for i=1:1:$l(AUserTemplateID,"^")
	{
		s RowID = $p(AUserTemplateID,"^",i)
		q:(RowID="")
		s obj = ##Class(EMRmeta.UserTemplate).%OpenId(RowID)
		q:(obj="")
		s itemRowId = $o(^DHCEMRM.UserTemplateGroupItemI("IdxUserCode"," "_obj.Code,""))
		if (itemRowId '= "")
		{
			s itemsc = ##Class(EMRmeta.UserTemplateGroupItem).%DeleteId(itemRowId)
			if ($$$ISERR(itemsc))
			{
				Trollback
				s ret = 0
				q
			}
		}
		s obj.Status = "4"
		s obj.AuditDate = ""
		s obj.AuditID = ""
		s sc = obj.%Save()
		if ($$$ISERR(sc))
		{
			Trollback
			s ret = 0
			q
		}
		s time = $p($h,",",2)
		s isBack = ..SetAuditLogStatus(RowID,AUserID,time,"",AIpAddress)
		if (isBack = 0)
		{
			Trollback
			s ret = 0
			q
		}
	}
	if (ret = 0)
	{
		Trollback
		q 0
	}
	Tcommit
	q 1
}

/// Desc:       获取知识库的Category目录
/// Creator:    liuyunfei
/// CreateDate: 2021-07-19
/// Table:		EMRmeta.KBCategory/EMRmeta.KnowledgeBase
/// Input:      
/// Output:     json Stream
/// return:		返回所有知识库的目录
/// Debug:     	w ##Class(EMRservice.BL.BLIEUserTemplate).GetAllKBCategory()
ClassMethod GetAllKBCategory() As %Stream
{
	s json = ##Class(%GlobalCharacterStream).%New()
	s key = $i(^CacheTemp("GetEMRKBCategoryData"))
	s result = ##class(%ResultSet).%New("EMRservice.BL.BLKBCategory:SELECTALL")
	d result.Execute()
	s count = 0
	while result.%Next()
	{
		s count = count + 1
		s data = $lb(result.Data("ID"),result.Data("Name"),result.Data("ParentID"),result.Data("Description"),result.Data("ResChildCount"))
		s ^CacheTemp("GetEMRKBCategoryData",key,result.Data("ParentID"),count) = data
	}
	d json.Write("[{")
	d json.Write("""id"":""KBROOT"",")
	d json.Write("""text"":""知识库目录"",")
	d json.Write("""nodetype"":""root"",")
	d json.Write("""state"":""open"",")
	d json.Write("""children"":")
	d json.Write("[")
	s tmpJson = ..GetKBCategoryByParentID(key,0)
	d json.CopyFrom(tmpJson)
	d json.Write("]")
	d json.Write("}")
	d json.Write("]")
	k ^CacheTemp("GetEMRKBCategoryData",key)
	q json
}

/// Desc:       获取知识库的Category目录根据ParentID
/// Creator:    liuyunfei
/// CreateDate: 2021-07-19
/// Table:		EMRmeta.KBCategory/EMRmeta.KnowledgeBase
/// Input:      AKey：key值；AParentID：EMRmeta.KBCategory中字段parentID
/// Output:     json Stream
/// return:		返回所有知识库的目录
/// debug:		w ##Class(EMRservice.BL.BLIEUserTemplate).GetKBCategoryByParentID(5,0)
ClassMethod GetKBCategoryByParentID(AKey As %String, AParentID As %String) As %GlobalBinaryStream
{
	s json = ##Class(%GlobalCharacterStream).%New()
	s count = 0
	s id = ""
	for
	{
		s id = $o(^CacheTemp("GetEMRKBCategoryData",AKey,AParentID,id))
		q:(id="")
		d:(count > 0) json.Write(",")
		d json.Write("{")
		d json.Write("""id"":"""_"cate^"_$li(^CacheTemp("GetEMRKBCategoryData",AKey,AParentID,id),1)_"""")
		d json.Write(",""text"":"""_$li(^CacheTemp("GetEMRKBCategoryData",AKey,AParentID,id),2)_"""")
		d json.Write(",""Description"":"""_$li(^CacheTemp("GetEMRKBCategoryData",AKey,AParentID,id),4)_"""")
		d json.Write(",""ResChildCount"":"""_$li(^CacheTemp("GetEMRKBCategoryData",AKey,AParentID,id),5)_"""")
		if (AParentID = "0")
		{
			d json.Write(",""state"":""closed""")
		}
		else
		{
			d json.Write(",""state"":""open""")
		}
		d json.Write(",""nodetype"":""KBCateGory""")
		d json.Write(",""children"":[")
		s tempJson = ..GetKBCategoryByParentID(AKey,$li(^CacheTemp("GetEMRKBCategoryData",AKey,AParentID,id),1))
		d:(tempJson.Size > 0) json.CopyFrom(tempJson)
		s childJson = ..GetKBDataByKBCategoryID($li(^CacheTemp("GetEMRKBCategoryData",AKey,AParentID,id),1))
		d:(childJson.Size > 0) json.CopyFrom(childJson)
		d json.Write("]")
		d json.Write("}")
		s count = count + 1
	}
	q json
}

/// Desc:       获取知识库KnowledgeBase根据CategoryID
/// Creator:    liuyunfei
/// CreateDate: 2021-07-19
/// Table:		EMRmeta.KnowledgeBase
/// Input:      AKBCategoryID：表EMRmeta.KBCategory的rowId
/// Output:     json Stream
/// return:		返回KnowledgeBase的数据
/// debug:		w ##Class(EMRservice.BL.BLIEUserTemplate).GetKBDataByKBCategoryID(27)
ClassMethod GetKBDataByKBCategoryID(AKBCategoryID As %String) As %GlobalBinaryStream
{
	s json = ##Class(%GlobalCharacterStream).%New()
	s result = ##class(%ResultSet).%New("EMRservice.BL.BLKnowledgeBase:SELECTBYCATEID")
	d result.Execute(AKBCategoryID)
	s count = 0
	while result.%Next()
	{
		d:(count > 0) json.Write(",")
		d json.Write("{")
		d json.Write("""id"":"""_"KB^"_result.Data("ID")_"""")
		d json.Write(",""text"":"""_result.Data("Name")_"""")
		d json.Write(",""iconCls"":""icon-paper""")
		d json.Write(",""Description"":"""_result.Data("Description")_"""")
		d json.Write(",""nodetype"":""KBData""")
		d json.Write("}")
		s count = count + 1
	}
	q json
}

/// Desc:       获取知识库目录树根据KnowledgeBaseId
/// Creator:    liuyunfei
/// CreateDate: 2021-07-19
/// Table:		EMRmeta.KBTree/EMRmeta.KBNode
/// Input:      AKnowledgeBaseID：表EMRmeta.KnowledgeBase的RowId
/// Output:     json Stream
/// return:		返回EMRmeta.KBTree的数据
/// debug: 		w ##Class(EMRservice.BL.BLIEUserTemplate).GetAllKBTreeByKBID(1)
ClassMethod GetAllKBTreeByKBID(AKnowledgeBaseID As %String) As %GlobalBinaryStream
{
	s json = ##Class(%GlobalCharacterStream).%New()
	q:(AKnowledgeBaseID = "") json
	s key = $i(^CacheTemp("GetEMRKBTreeData"))
	s result = ##class(%ResultSet).%New("EMRservice.BL.BLKBTree:SELECTALL")
	d result.Execute(AKnowledgeBaseID)
	s count = 0
	while result.%Next()
	{
		continue:(result.Data("PersonalKBUserID") '= "")
		s count = count + 1		//ID:Name:ParentID:KnowledgeBaseID:Description:ResChildCount:PersonalKBUserID:Sequence:IsActive:
		s data = $lb(result.Data("ID"),result.Data("Name"),result.Data("ParentID"),result.Data("Description"),result.Data("ResChildCount"),result.Data("KnowledgeBaseID"))
		s ^CacheTemp("GetEMRKBTreeData",key,result.Data("ParentID"),count) = data
	}
	s obj = ##class(EMRmeta.KnowledgeBase).%OpenId(AKnowledgeBaseID)
	q:(obj = "") json
	s text = obj.Name
	d json.Write("[{")
	d json.Write("""id"":""KBROOT"",")
	d json.Write("""text"":"""_text_""",")
	d json.Write("""nodetype"":""root"",")
	d json.Write("""state"":""open"",")
	d json.Write("""children"":")
	d json.Write("[")
	s tmpJson = ..GetKBTreeByParentID(key,0)
	d json.CopyFrom(tmpJson)
	d json.Write("]")
	d json.Write("}")
	d json.Write("]")
	k ^CacheTemp("GetEMRKBTreeData",key)
	q json
}

/// Desc:       获取知识库目录树根据KnowledgeBaseId
/// Creator:    liuyunfei
/// CreateDate: 2021-07-19
/// Table:		EMRmeta.KBTree
/// Input:      AKey：key值；AParentID：表EMRmeta.KBTree的字段ParentID
/// Output:     json Stream
/// return:		返回EMRmeta.KBTree的数据
/// debug: 		w ##Class(EMRservice.BL.BLIEUserTemplate).GetKBTreeByParentID(1,3)
ClassMethod GetKBTreeByParentID(AKey As %String, AParentID As %String) As %GlobalBinaryStream
{
	s json = ##Class(%GlobalCharacterStream).%New()
	s count = 0
	s id = ""
	for
	{
		s id = $o(^CacheTemp("GetEMRKBTreeData",AKey,AParentID,id))
		q:(id="")
		d:(count > 0) json.Write(",")
		d json.Write("{")
		d json.Write("""id"":"""_"Tree^"_$li(^CacheTemp("GetEMRKBTreeData",AKey,AParentID,id),1)_"""")
		d json.Write(",""text"":"""_$li(^CacheTemp("GetEMRKBTreeData",AKey,AParentID,id),2)_"""")
		d json.Write(",""Description"":"""_$li(^CacheTemp("GetEMRKBTreeData",AKey,AParentID,id),4)_"""")
		d json.Write(",""ResChildCount"":"""_$li(^CacheTemp("GetEMRKBTreeData",AKey,AParentID,id),5)_"""")
		d json.Write(",""state"":""open""")
		d json.Write(",""nodetype"":""KBCateGory""")
		d json.Write(",""children"":[")
		s tempJson = ..GetKBTreeByParentID(AKey,$li(^CacheTemp("GetEMRKBTreeData",AKey,AParentID,id),1))
		d:(tempJson.Size > 0) json.CopyFrom(tempJson)
		s childJson = ..GetKBNodeDataByKBTreeID($li(^CacheTemp("GetEMRKBTreeData",AKey,AParentID,id),1))
		if (childJson.Size > 0)
		{
			s flag = "0"
			s tmpId = ""
			for
			{
				s tmpId = $o(^DHCEMRM.KBTreeI("IdxParentID"," "_$li(^CacheTemp("GetEMRKBTreeData",AKey,AParentID,id),1),tmpId))
				q:(tmpId = "")
				s tmpObj = ##class(EMRmeta.KBTree).%OpenId(tmpId)
				if (tmpObj.PersonalKBUserID = "")
				{
					s flag = "1"
					q
				}
			}
			d:(flag = "1") json.Write(",")
			d json.CopyFrom(childJson)
		}
		d json.Write("]")
		d json.Write("}")
		s count = count + 1
	}
	q json
}

/// Desc:       获取知识库目录树所有节点根据KBTreeId
/// Creator:    liuyunfei
/// CreateDate: 2021-07-19
/// Table:		EMRmeta.KBNode
/// Input:      AKBTreeID：表EMRmeta.KBTree的rowId
/// Output:     json Stream
/// return:		返回EMRmeta.KBNode的数据
/// debug:		w ##Class(EMRservice.BL.BLIEUserTemplate).GetKBNodeDataByKBTreeID(13782)
ClassMethod GetKBNodeDataByKBTreeID(AKBTreeID As %String) As %GlobalBinaryStream
{
	s json = ##Class(%GlobalCharacterStream).%New()
	s result = ##class(%ResultSet).%New("EMRservice.BL.BLKBNode:SELECTInUseBYPARENTID")
	d result.Execute(AKBTreeID)
	s count = 0
	while result.%Next()
	{
		d:(count > 0) json.Write(",")
		d json.Write("{")
		d json.Write("""id"":"""_"KBNode^"_result.Data("ID")_"""")
		d json.Write(",""text"":"""_result.Data("Name")_"""")
		d json.Write(",""iconCls"":""icon-paper""")
		d json.Write(",""Description"":"""_result.Data("Description")_"""")
		d json.Write(",""nodetype"":""KBNodeData""")
		d json.Write("}")
		s count = count + 1
	}
	q json
}

/// Desc:       获取签名级别
/// Creator:    liuyunfei
/// CreateDate: 2021-08-16
/// Table:		EMRmeta.SignRole
/// Input:      
/// Output:     json stream
/// return:		返回EMRmeta.SignRole的数据
/// debug:		w ##Class(EMRservice.BL.BLIEUserTemplate).GetSignLevelJson()
ClassMethod GetSignLevelJson() As %GlobalBinaryStream
{
	s json = ##Class(%GlobalCharacterStream).%New()
	d json.Write("{")
	d json.Write("""value"":""NONE""")
	d json.Write(",""name"":""无""")
	d json.Write("}")
	s result = ##class(%ResultSet).%New("EMRservice.BL.BLSignRole:SELECTALL")
	d result.Execute()
	while result.%Next()
	{
		d json.Write(",")
		d json.Write("{")
		d json.Write("""value"":"""_result.Data("Name")_"""")
		d json.Write(",""name"":"""_result.Data("Description")_"""")
		d json.Write("}")
	}
	q json
}

}
