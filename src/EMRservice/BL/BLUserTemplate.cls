/// 名称：		EMRservice.BL.BLUserTemplate
/// 描述：		用户模板BL层
/// 编写者：	yejian
/// 编写时间：	2017-11-9
Class EMRservice.BL.BLUserTemplate Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:       取当前科室模板并排序
/// Creator:    Candy
/// CreateDate: 2018-1-8	
/// Input:      pLocID 科室ID 
///             pDocID 目录展现结构ID
///             pEpisodeID 就诊ID
/// Output:     oCode:科室模板代码,
///             oName:科室模板名称,
///             oSimpleSpel:科室模板简拼,
///             TemplateID:基础模板ID,
///             TitleCode:标题代码,
///             Type:模板类型
/// Debug:      d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLUserTemplate","GetUserTemplate",190,881,408047)
Query GetUserTemplate(pLocID As %String, pDocID As %String, pEpisodeID As %String, pText As %String = "", pDiseaseCodeAndName As %String = "") As %Query(ROWSPEC = "oCode:%String,oName:%String,oSimpleSpel:%String,oTemplateID:%String,oTitleCode:%String,oType:%String,ID:%String,oSequence:%String,oTitleSeq:%String")
{
}

ClassMethod GetUserTemplateExecute(ByRef qHandle As %Binary, pLocID As %String, pDocID As %String, pEpisodeID As %String, pText As %String = "", pDiseaseCodeAndName As %String = "") As %Status
{
	s repid = $I(^CacheTemp)
	s qHandle = $lb(0,repid,0)
	s ind = 1
	q:(pDocID = "") $$$OK	
	s key = $i(^CacheTemp("GetUserTemplate"))
	d ..GetUserTemplateByDocID(pLocID,pDocID,pEpisodeID,key,pText,pDiseaseCodeAndName)
		s titleCode = ""
		for
		{
			s titleCode = $o(^CacheTemp("GetUserTemplate",key,titleCode))
			q:(titleCode = "")
			s type = ""
			for
			{
			s type = $o(^CacheTemp("GetUserTemplate",key,titleCode,type),-1)
				q:(type = "")
				s seq = ""
				for
				{
					s seq = $o(^CacheTemp("GetUserTemplate",key,titleCode,type,seq))
					q:(seq = "")
					s data = ^CacheTemp("GetUserTemplate",key,titleCode,type,seq)
					s ^CacheTemp(repid,ind) = data
					s ind = ind + 1			
				}		
			}
		}


	k ^CacheTemp("GetUserTemplate",key)
	Quit $$$OK
}

ClassMethod GetUserTemplateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUserTemplateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetUserTemplateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUserTemplateExecute ]
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
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Desc:       根据DOCID取当前科室模板
/// Creator:    Candy
/// CreateDate: 2018-1-8	
/// Input:      pLocID 科室ID 
///             pDocID 目录展现结构ID
///             pEpisodeID 就诊ID
/// Output:     oCode:科室模板代码,
///             oName:科室模板名称,
///             oSimpleSpel:科室模板简拼,
///             TemplateID:基础模板ID,
///             TitleCode:标题代码,
///             Type:模板类型
/// Debug:      d ##Class(EMRservice.BL.BLUserTemplate).GetUserTemplateByDocID(190,4561,456449,1)
ClassMethod GetUserTemplateByDocID(pLocID As %String, pDocID As %String, pEpisodeID As %String, pKey As %String, pText As %String, pDiseaseCodeAndName As %String = "")
{
	q:(pDocID = "") $$$OK
	s templateId = ""
	for
	{
		s templateId = $o(^DHCEMRM.EMRTemplateI("IdxCategoryTemplate"," "_pDocID,templateId))
		q:(templateId = "")
		s type = ""
		for 
		{
			s type = $o(^DHCEMRM.UserTemplateI("IdxTemplateIDType",templateId,type))
			q:(type = "")
			s tmpType = $tr(type," ","")	
			s rowId = ""
			for
			{
				s rowId = $o(^DHCEMRM.UserTemplateI("IdxTemplateIDType",templateId,type,rowId))
				q:(rowId = "")
				s objUserTemplate = ##Class(EMRmeta.UserTemplate).%OpenId(rowId)
				q:(objUserTemplate = "")
				continue:((pText '= "")&&(objUserTemplate.Name '[ pText)&&(objUserTemplate.SimpleSpelName '[ pText))
				s userTempCode = objUserTemplate.Code
				continue:(objUserTemplate.Status '=1)
				if ((tmpType '= "0")&&(pLocID '= ""))
				{
					continue:($d(^DHCEMRM.UserTemplateCTLocI("IdxCTLocIDAndCode"," "_pLocID," "_userTempCode))<=0)
				}
				s titleCode = $o(^DHCEMRM.UserTemplateTitleI("IdxCodeAndTitleCode"," "_userTempCode,""))
				s titleCode = $tr(titleCode," ","")
				s isUniq = ##Class(EMRservice.BL.BLClientCategory).IsTitleUniqueCreate(titleCode,pEpisodeID)
				continue:(isUniq = "1")
				s tmpLocId = $o(^DHCEMRM.UserTemplateCTLocI("IdxCodeAndCTLocID"," "_$zcvt(objUserTemplate.Code,"U"),""))
				s tmpLocId = $tr(tmpLocId," ","")
				//处理usertemplate未关联科室导致的数据异常
				continue:((tmpType '= "0")&&(tmpLocId = ""))
				s tmpTypeDesc = $case(tmpType,"0":"全院通用",:$p($g(^CTLOC(tmpLocId)),"^",2))
	    		//病种关联模板
	    		s flag=0
	    		if (pDiseaseCodeAndName'=""){
					s key = 0
	       			s ret = ..GetTempCodeByDisease(pDiseaseCodeAndName)
	    			for
	    			{
	    				s objCode = ret.GetNext(.key)
	    				q:key=""
	    				s:(userTempCode=objCode) flag=1
	    				q:flag=1    
	    			} 
	    		}
	    
	    		continue:((pDiseaseCodeAndName '="")&&(flag'=1))
                //根据参数判断是否开启默认标题分组
                s UserTemplateDefaultGroup=##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("UserTemplateDefaultGroup","N")
                s tcRowID=$o(^DHCEMRM.TitleConfigI("IdxTitleCode"," "_$zcvt(titleCode,"U"),""))
                if (tcRowID'="")
                {
					s titleConfig =##class(EMRmeta.TitleConfig).%OpenId(tcRowID)
					s titleCategory = ##class(EMRmeta.TitleCategory).%OpenId(titleConfig.GroupID)
					//通过目录顺序+标题顺序(4位左补0)+标题ID（4位左补0）
	                s gsrID = titleCategory.Sequence_$tr($j(titleConfig.Sequence, 4), " ", "0")_$tr($j(tcRowID, 4), " ", "0")
	                s titleCodeSeq = $case(titleConfig,"":"^"_titleCode,:gsrID_"^"_titleCode)
                }
                else
                {
	                s titleCodeSeq =titleCode
                }
                s:((titleCodeSeq = "")||(UserTemplateDefaultGroup = "N")) titleCodeSeq = "ZZNONE"
                s data = $lb(userTempCode,objUserTemplate.Name,objUserTemplate.SimpleSpelName,objUserTemplate.TemplateID,titleCode,tmpTypeDesc,rowId,objUserTemplate.Sequence,titleCodeSeq)
	
				s ^CacheTemp("GetUserTemplate",pKey,titleCodeSeq,objUserTemplate.Type,objUserTemplate.Sequence) = data				
			}
		}
	}
}

/// Desc:       取当前科室模板
/// Creator:    Candy
/// CreateDate: 2017-11-8
/// Input:       pLocID 科室ID 
///             pDocID 目录展现结构ID
///             pEpisodeID 就诊ID
/// Output:     json Stream
/// Debug:      d ##Class(EMRservice.BL.BLUserTemplate).GetUserTemplateJson(190,4561,456449)
ClassMethod GetUserTemplateJson(pLocID As %String, pDocID As %String, pEpisodeID As %String, pText As %String = "", pDiseaseCodeAndName As %String = "", pUserID As %String = "") As %GlobalBinaryStream
{
	s resultJson = ##Class(%GlobalBinaryStream).%New()
	q:(pDocID = "") json
	s result = ##class(%ResultSet).%New("EMRservice.BL.BLUserTemplate:GetUserTemplate")
	d result.Execute(pLocID,pDocID,pEpisodeID,pText,pDiseaseCodeAndName)
	s key = $i(^CacheTemp("GetUserTemplateJson"))
	s count = 0
    s oTitleSeq = "ZZNONE"
	while result.%Next()
	{
		s count = count + 1
		s data = $lb(result.Data("oCode"),result.Data("oName"),result.Data("oSimpleSpel"),result.Data("oTemplateID"),result.Data("oTitleCode"),result.Data("oType"),result.Data("ID"))
		s oTitleSeq = result.Data("oTitleSeq")
		s:(oTitleSeq = "") oTitleSeq = "ZZNONE"
		//根据用户使用频率排序
		if (##Class(EMRservice.SystemParameter).IsSortByUserFrequency() = "Y")&&(pUserID '= "")
		{
			s frequency = 0
			s strTemplateID = result.Data("oTemplateID")
			s strUserTemID =result.Data("ID")
			s frequency = $o(^DHCEMRI.UserTemplateFreqI("IdxTemUserTemUserFreq"," "_strTemplateID," "_strUserTemID," "_pUserID,""))
			s:(frequency = "") frequency = 0
			s ^CacheTemp("GetUserTemplateFreq",key,oTitleSeq,strTemplateID,frequency,count) = data
			s ^CacheTemp("GetUserTemplateFreq",key,oTitleSeq,strTemplateID,frequency,count,"Flag")= result.Data("oCode")
		}
		else
		{
			s ^CacheTemp("GetUserTemplateJson",key,oTitleSeq,count) = data
			s ^CacheTemp("GetUserTemplateJson",key,oTitleSeq,"Flag",result.Data("oCode"))= count
		}
	}
	if (##Class(EMRservice.SystemParameter).IsSortByUserFrequency() = "Y")
	{
		d ..SortUserTemplateByFrequency(key)
	}
	if (oTitleSeq = "ZZNONE")
	{
		if (pLocID = "")
		{	
			s tmpJson = ##Class(EMRservice.BL.BLUserTemplateGroup).GetGroupUserTemplate(0,key,oTitleSeq)
		}
		else
		{
			s tmpJson = ##Class(EMRservice.BL.BLUserTemplateGroup).GetGroupUserTemplateByLoc(pLocID,0,key,oTitleSeq)
		}
		d resultJson.CopyFrom(tmpJson)
	}


	//循环取可重复模板数据
	s titleCode = ""
	for
	{
		s titleCode = $o(^CacheTemp("GetUserTemplateJson",key,titleCode))
		q:(titleCode = "")
		continue:(titleCode = "ZZNONE")
		s strTitleCode = $p(titleCode,"^",2)
		s rowId = "title" + strTitleCode
		s titleID = $o(^DHCEMRM.TitlesI("IdxCode"," "_strTitleCode,""))
		continue:(titleID = "")
		s obj = ##Class(EMRmeta.Titles).%OpenId(titleID)
		continue:(obj = "")
		s name = obj.Description
		continue:(name = "")
		d:(resultJson.Size > 0) resultJson.Write(",")
		d resultJson.Write("{")
		d resultJson.Write("""id"":"""_rowId_"""")
		d resultJson.Write(",""text"":"""_name_"""")
		d resultJson.Write(",""icon"":""../scripts/emr/image/icon/folder.png""")
		d resultJson.Write(",""attributes"":{""nodetype"":""flod""}")
		d resultJson.Write(",""children"":[")
			 
		s seq = ""
		s count = 0
		for
		{
			s seq = $o(^CacheTemp("GetUserTemplateJson",key,titleCode,seq))
			q:(seq = "Flag")||(seq = "")
			d:(count '= 0) resultJson.Write(",")
			d writeJson
			s count = count + 1	
		}
		d resultJson.Write("]}")
	}
	
	//循环取唯一模板数据
	s seq = ""
	s titleCode = "ZZNONE"
	for
	{
		s seq = $o(^CacheTemp("GetUserTemplateJson",key,titleCode,seq))
		q:(seq = "Flag")||(seq = "")
		d:(resultJson.Size>0) resultJson.Write(",")
		d writeJson		
	}
	k ^CacheTemp("GetUserTemplateJson",key)
	q resultJson
	
writeJson
	if ($li(^CacheTemp("GetUserTemplateJson",key,titleCode,seq),6) = "全院通用")
	{
		s name = "<span style='color:blue;'>"_$li(^CacheTemp("GetUserTemplateJson",key,titleCode,seq),2)_"</span>"
	}
	else
	{
		s name = $li(^CacheTemp("GetUserTemplateJson",key,titleCode,seq),2)
	}
    d resultJson.Write("{")
    d resultJson.Write("""id"":"""_$li(^CacheTemp("GetUserTemplateJson",key,titleCode,seq),7)_"""")
    d resultJson.Write(",""text"":"""_name_"""")
    d resultJson.Write(",""icon"":""../scripts/emr/image/icon/leaf.png""")
    d resultJson.Write(",""attributes"":{")
	d resultJson.Write("""Code"":"""_$li(^CacheTemp("GetUserTemplateJson",key,titleCode,seq),1)_"""")
	d resultJson.Write(",""SimpleSpel"":"""_$li(^CacheTemp("GetUserTemplateJson",key,titleCode,seq),3)_"""")
	d resultJson.Write(",""TemplateID"":"""_$li(^CacheTemp("GetUserTemplateJson",key,titleCode,seq),4)_"""")
	d resultJson.Write(",""TitleCode"":"""_$li(^CacheTemp("GetUserTemplateJson",key,titleCode,seq),5)_"""")
	d resultJson.Write(",""Type"":"""_$li(^CacheTemp("GetUserTemplateJson",key,titleCode,seq),6)_"""") 
	d resultJson.Write(",""nodetype"":""leaf""")
	d resultJson.Write("}}")
}

/// Desc:       取当前科室模板和标题
/// Creator:    yejian
/// CreateDate: 2022-1-25
/// Input:       pLocID 科室ID 
///             pDocID 目录展现结构ID
///             pEpisodeID 就诊ID
/// Output:     json Stream
/// Debug:      d ##Class(EMRservice.BL.BLUserTemplate).GetUserTemplateTitlesJson("",66,67,"","",10209)
ClassMethod GetUserTemplateTitlesJson(pLocID As %String, pDocID As %String, pEpisodeID As %String, pText As %String = "", pDiseaseCodeAndName As %String = "", pUserID As %String = "") As %GlobalBinaryStream
{
	s objRes = ##class(%GlobalBinaryStream).%New()
	s streamTemps = ##Class(EMRservice.BL.BLUserTemplate).GetUserTemplateJson(pLocID,pDocID,pEpisodeID,pText,pDiseaseCodeAndName,pUserID)
	d:((streamTemps'="")&&(streamTemps.Size>1)) objRes.CopyFrom(streamTemps)
	//获取通用标题数据
    s titleTemps =  ##Class(EMRservice.BL.BLTitleConfig).GetTitlesNew(pDocID,pLocID,pText,pUserID,"",pEpisodeID)
    if ((titleTemps'="")&&(titleTemps.Size>1)) 
    {
	   d:(objRes.Size>1) objRes.Write(",")
	   d objRes.Write(titleTemps.Read(titleTemps.Size))
    }
    q objRes
}

/// Desc:       取当前科室模板（去掉样式，增加Type属性）
/// Creator:    yejian
/// CreateDate: 2021-6-25
/// Input:      pLocID 科室ID 
///             pDocID 目录展现结构ID
///             pEpisodeID 就诊ID
/// 			pText 过滤文本
/// 			pUserID 用户ID
/// 			pDiseaseCodeAndName 病种
/// 			pJson json数据
/// Output:     json Stream
/// Debug:      d ##Class(EMRservice.BL.BLUserTemplate).GetUserTemplateJsonNew("",66,67,"",10209,"","")
ClassMethod GetUserTemplateJsonNew(pLocID As %String, pDocID As %String, pEpisodeID As %String, pText As %String = "", pUserID As %String = "", pDiseaseCodeAndName As %String = "", pJson As %String) As %GlobalBinaryStream
{
	s resultJson = ##Class(%GlobalBinaryStream).%New()
	q:(pDocID = "") json
	s result = ##class(%ResultSet).%New("EMRservice.BL.BLUserTemplate:GetUserTemplate")
	d result.Execute(pLocID,pDocID,pEpisodeID,pText,pDiseaseCodeAndName)
	s key = $i(^CacheTemp("GetUserTemplateJson"))
	s count = 0
    s oTitleSeq = "ZZNONE"
	while result.%Next()
	{
		s count = count + 1
		s data = $lb(result.Data("oCode"),result.Data("oName"),result.Data("oSimpleSpel"),result.Data("oTemplateID"),result.Data("oTitleCode"),result.Data("oType"),result.Data("ID"))
		s oTitleSeq = result.Data("oTitleSeq")
		s:(oTitleSeq = "") oTitleSeq = "ZZNONE"
		//根据用户使用频率排序
		if (##Class(EMRservice.SystemParameter).IsSortByUserFrequency() = "Y")&&(pUserID '= "")
		{
			s frequency = 0
			s strTemplateID = result.Data("oTemplateID")
			s strUserTemID =result.Data("ID")
			s frequency = $o(^DHCEMRI.UserTemplateFreqI("IdxTemUserTemUserFreq"," "_strTemplateID," "_strUserTemID," "_pUserID,""))
			s:(frequency = "") frequency = 0
			s ^CacheTemp("GetUserTemplateFreq",key,oTitleSeq,strTemplateID,frequency,count) = data
			s ^CacheTemp("GetUserTemplateFreq",key,oTitleSeq,strTemplateID,frequency,count,"Flag")= result.Data("oCode")
		}
		else
		{
			s ^CacheTemp("GetUserTemplateJson",key,oTitleSeq,count) = data
			s ^CacheTemp("GetUserTemplateJson",key,oTitleSeq,"Flag",result.Data("oCode"))= count
		}
	}
	if (##Class(EMRservice.SystemParameter).IsSortByUserFrequency() = "Y")
	{
		d ..SortUserTemplateByFrequency(key)
	}
	if (oTitleSeq = "ZZNONE")
	{
		if (pLocID = "")
		{	
			s tmpJson = ##Class(EMRservice.BL.BLUserTemplateGroup).GetGroupUserTemplateNew(0,key,oTitleSeq,pJson)
		}
		else
		{
			s tmpJson = ##Class(EMRservice.BL.BLUserTemplateGroup).GetGroupUserTemplateByLocNew(pLocID,0,key,oTitleSeq,pJson)
		}
		d resultJson.CopyFrom(tmpJson)
	}


	//循环取可重复模板数据
	s titleCode = ""
	for
	{
		s titleCode = $o(^CacheTemp("GetUserTemplateJson",key,titleCode))
		q:(titleCode = "")
		continue:(titleCode = "ZZNONE")
		s rowId = "title" + titleCode
		s titleID = $o(^DHCEMRM.TitlesI("IdxCode"," "_titleCode,""))
		continue:(titleID = "")
		s obj = ##Class(EMRmeta.Titles).%OpenId(titleID)
		continue:(obj = "")
		s name = obj.Description
		continue:(name = "")
		d:(resultJson.Size > 0) resultJson.Write(",")
		d resultJson.Write("{")
		d resultJson.Write("""id"":"""_"flod"_"-"_rowId_"""")
		d resultJson.Write(",""text"":"""_name_"""")
		d resultJson.Write(",""DocIDText"":"""_name_"""")
		d resultJson.Write(",""icon"":""../scripts/emr/image/icon/folder.png""")
		d resultJson.Write(",""type"":"""_"flod"_"""")
		d resultJson.Write(",""attributes"":{""nodetype"":""flod""}")
		d resultJson.Write(",""children"":[")
			 
		s seq = ""
		s count = 0
		for
		{
			s seq = $o(^CacheTemp("GetUserTemplateJson",key,titleCode,seq))
			q:(seq = "Flag")||(seq = "")
			d:(count '= 0) resultJson.Write(",")
			d writeJson
			s count = count + 1	
		}
		d resultJson.Write("]}")
	}
	
	//循环取唯一模板数据
	s seq = ""
	s titleCode = "ZZNONE"
	for
	{
		s seq = $o(^CacheTemp("GetUserTemplateJson",key,titleCode,seq))
		q:(seq = "Flag")||(seq = "")
		d:(resultJson.Size>0) resultJson.Write(",")
		d writeJson		
	}
	k ^CacheTemp("GetUserTemplateJson",key)
	q resultJson
	
writeJson
	if ($li(^CacheTemp("GetUserTemplateJson",key,titleCode,seq),6) = "全院通用")
	{
		//s name = "<span style='color:blue;'>"_$li(^CacheTemp("GetUserTemplateJson",key,titleCode,seq),2)_"</span>"
		s name = $li(^CacheTemp("GetUserTemplateJson",key,titleCode,seq),2)
		s strType = "TempCate"
	}
	else
	{
		s name = $li(^CacheTemp("GetUserTemplateJson",key,titleCode,seq),2)
		s strType = "UserTem"
	}
	s idStr = strType_"-"_$li(^CacheTemp("GetUserTemplateJson",key,titleCode,seq),7)
	s id = idStr
	if (strType="TempCate"){
		s id = $li(^CacheTemp("GetUserTemplateJson",key,titleCode,seq),7)
		}
	s isCollect = ##Class(EMRservice.BL.BLCollectTemplate).GetIsCollect(pUserID,id)
    d resultJson.Write("{")
    d resultJson.Write("""id"":"""_idStr_"""")
    d resultJson.Write(",""text"":"""_name_"""")
    d resultJson.Write(",""isCollect"":"""_isCollect_"""")
    d resultJson.Write(",""DocIDText"":"""_name_"""")
    d resultJson.Write(pJson)
    d resultJson.Write(",""iconCls"":""icon-person""")
    d resultJson.Write(",""type"":"""_strType_"""")
    d resultJson.Write(",""attributes"":{")
	d resultJson.Write("""Code"":"""_$li(^CacheTemp("GetUserTemplateJson",key,titleCode,seq),1)_"""")
	d resultJson.Write(",""SimpleSpel"":"""_$li(^CacheTemp("GetUserTemplateJson",key,titleCode,seq),3)_"""")
	d resultJson.Write(",""TemplateID"":"""_$li(^CacheTemp("GetUserTemplateJson",key,titleCode,seq),4)_"""")
	d resultJson.Write(",""TitleCode"":"""_$li(^CacheTemp("GetUserTemplateJson",key,titleCode,seq),5)_"""")
	d resultJson.Write(",""Type"":"""_$li(^CacheTemp("GetUserTemplateJson",key,titleCode,seq),6)_"""") 
	d resultJson.Write(",""nodetype"":""leaf""")
	d resultJson.Write("}}")
}

/// Desc:       根据条件查询科室模板
/// Creator:    Candy
/// CreateDate: 2017-12-6
/// Input:      AText 条件 
/// Output:     json Stream
/// Debug:      d ##Class(EMRservice.BL.BLUserTemplate).GetUserTemplateByCondition("入院")
ClassMethod GetUserTemplateByCondition(ADocID As %String, AText As %String) As %GlobalBinaryStream
{
	s json = ##Class(%GlobalBinaryStream).%New()
	q:(AText = "")||(ADocID = "") json
	s text = $zcvt(AText,"U")
	s templateId = ""
	for
	{
		s templateId = $o(^DHCEMRM.EMRTemplateI("IdxCategoryTemplate"," "_ADocID,templateId))
		q:(templateId = "")

		s name = ""
		for
		{
			s name = $o(^DHCEMRM.UserTemplateI("IdxName",templateId,name))
			q:(name = "")
			continue:((name '[ text))
			s rowId = ""
			for
			{
				s rowId = $o(^DHCEMRM.UserTemplateI("IdxName",templateId,name,rowId))
				q:(rowId = "")
				d Output
			}		
		}
		s jp = ""
		for
		{
			s jp = $o(^DHCEMRM.UserTemplateI("IdxSimpleSpelName",templateId,jp))
			q:(jp = "")
			continue:((jp '[ text))
			s rowId = ""
			for
			{
				s rowId = $o(^DHCEMRM.UserTemplateI("IdxSimpleSpelName",templateId,jp,rowId))
				q:(rowId = "")
				d Output
			}		
		}
	}
	q json
Output
	s obj = ##Class(EMRmeta.UserTemplate).%OpenId(rowId)
	s titleCode = $o(^DHCEMRM.UserTemplateTitleI("IdxCodeAndTitleCode"," "_$zcvt(obj.Code,"U"),""))
	s titleCode = $tr(titleCode," ","")
	s ctLoc = $o(^DHCEMRM.UserTemplateCTLocI("IdxCodeAndCTLocID"," "_$zcvt(obj.Code,"U"),""))
	s ctLoc = $tr(ctLoc," ","")
	s locDesc = $p($g(^CTLOC(ctLoc)),"^",2)
	s type = $case(obj.Type,"0":"全院通用",:locDesc)
	d:(json.Size > 0) json.Write(",")
	d json.Write("{")
	d json.Write("""Code"":"""_obj.Code_"""")
	d json.Write(",""text"":"""_obj.Name_"""")
	d json.Write(",""SimpleSpel"":"""_obj.SimpleSpelName_"""")
	d json.Write(",""TemplateID"":"""_obj.TemplateID_"""")
	d json.Write(",""TitleCode"":"""_titleCode_"""")
	d json.Write(",""Type"":"""_type_"""")
	d json.Write("}")
	
	q
}

/// Desc:       是否配置用户模板
/// Creator:    Candy
/// CreateDate: 2017-11-8
/// Input:      ALocID 科室ID 
///             ATemplateID 基础模板ID
/// Output:     1,0
/// Debug       w ##Class(EMRservice.BL.BLUserTemplate).HasUserTemplate(171,646)
ClassMethod HasUserTemplate(ALocID As %String, ADocID As %String) As %String
{
	
	s result = 0
	q:(ALocID = "")||(ADocID = "") result
	s createStatus = ##Class(EMRservice.SystemParameter).GetCreateStatus()
	s objJson = ##Class(EMRservice.Parser.Json).%New()  
	s objparam = ##Class(%GlobalCharacterStream).%New()
	d objparam.Write(createStatus)
	s array = objJson.Deserialize(objparam)
	q:(array.GetAt("LoadMode") '= "UserTemplate") result
	s templateId = ""
	for
	{
		s templateId = $o(^DHCEMRM.EMRTemplateI("IdxCategoryTemplate"," "_ADocID,templateId))
		q:(templateId = "")
		s seq = ""
		for
		{
			s seq = $o(^DHCEMRM.UserTemplateI("IdxTemplateID",templateId,seq))
			q:(seq = "")
			s rowId = ""
			for
			{
				s rowId = $o(^DHCEMRM.UserTemplateI("IdxTemplateID",templateId,seq,rowId))
				q:(rowId = "")
				s obj = ##class(EMRmeta.UserTemplate).%OpenId(rowId)
				continue:(obj = "")
				continue:(obj.Status = "-1" )
				continue:(($d(^DHCEMRM.UserTemplateCTLocI("IdxCTLocIDAndCode"," "_ALocID," "_obj.Code))<=0) && (obj.Type = "1"))
				//根据模板使用状态字段Status过滤掉未审核过的科室模板
				continue:(obj.Status '= "1")
				s result = 1
				q:(result = 1)
			}
			q:(result = 1)
		}
		q:(result = 1)
	}
	
	q:(result = 1) result
	
	//增加验证验证DocId是否有标题关联
	s objEmrTempalteCategory = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(ADocID)
	q:(objEmrTempalteCategory = "") result
	s CategoryID = objEmrTempalteCategory.ParentCategoryID
	q:(CategoryID = "") result
	
	s sequence = ""
	for
	{ 
		s sequence = $o(^DHCEMRM.TitleConfigI("IdxCategorySequence"," "_CategoryID,sequence))
		q:(sequence = "")
		q:(result=1)
		
		s rowID = ""
		for
		{
			s rowID = $o(^DHCEMRM.TitleConfigI("IdxCategorySequence"," "_CategoryID,sequence,rowID))
			q:(rowID = "")
			s obj = ##Class(EMRmeta.TitleConfig).%OpenId(rowID)
			continue:(obj = "")
			
			s titleCode = obj.TitleCode
			s titleRowID = ""
			s:(titleCode '= "") titleRowID = $o(^DHCEMRM.TitlesI("IdxCode"," "_titleCode,""))
			continue:(titleRowID = "")
			
			s titleObj = ##Class(EMRmeta.Titles).%OpenId(titleRowID)
			continue:(titleObj = "")
			//过滤不属于当前DocId的标题
			s titleConfigRowID = titleRowID
			s titleConfigObj = ##Class(EMRmeta.TitleConfig).%OpenId(titleConfigRowID)
			
			s emrTemplateID = titleConfigObj.TemplateID
			s emrTemplateObj = ##class(EMRmeta.EMRTemplate).%OpenId(emrTemplateID)
			continue:(emrTemplateObj = "")
			s emrTemplateCateId = emrTemplateObj.CategoryID
			
			continue:(emrTemplateCateId'=ADocID)
			
			//过滤科室
			continue:(($d(^DHCEMRM.TitleLocI("IdxCTLocIDTitleID"," "_titleRowID))>0)&&($d(^DHCEMRM.TitleLocI("IdxCTLocIDTitleID"," "_titleRowID," "_ALocID))<=0))
			
			s result=1
			
			q

		}
    }
    
	q result
}

/// Desc:       取用户模板Stream
/// Creator:    Candy
/// CreateDate: 2017-11-17
/// Input:      AUserTemplateCode 用户模板代码 
/// Output:     OutStream 模板Stream
/// Debug       w ##Class(EMRservice.BL.BLUserTemplate).GetUserTemplateStream
ClassMethod GetUserTemplateStream(AUserTemplateCode As %String) As %String
{
	
	s result = ##Class(%GlobalBinaryStream).%New()
	q:(AUserTemplateCode = "") result
	s rowId = $o(^DHCEMRM.UserTemplateI("IdxCode"," "_$zcvt(AUserTemplateCode,"U"),""))
	q:(rowId = "") result
	s obj = ##Class(EMRmeta.UserTemplate).%OpenId(rowId)
	q:(obj = "") result
	d result.CopyFrom(obj.TemplateData)
	s obj = ""
	q result
}

/// 获取所有用户模板
/// /////////用户模板科室////////////
/// Debug:	d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLUserTemplate","GetAllUserTemplate")
Query GetAllUserTemplate(aCTLocName As %String) As %Query(ROWSPEC = "ID:%Integer,Code:%String,Name:%String,TemplateID:%String,SimpleSpelName:%String,UserID:%String,UserName:%String,CreateDate:%String,AuditID:%String,AuditName:%String,AuditDate:%String,Type:%String,Sequence:%String,Status:%String,VersionNumber:%String,RowCTID:%String,CTLocID:%String,CTLocName:%String,RowTitleID:%String,TitleCode:%String,TitleName:%String,Remark:%String,path:%String,rowDiseaseID:%String,DiagnosCode:%String,DiagnosName:%String")
{
}

ClassMethod GetAllUserTemplateExecute(ByRef qHandle As %Binary, aCTLocName As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	s rowID = ""
	for {
		s rowID = $o(^DHCEMRM.UserTemplateD(rowID))
		q:(rowID = "")
		s objUserTemplate = ##Class(EMRmeta.UserTemplate).%OpenId(rowID)
		continue:(objUserTemplate = "")
		s Status = objUserTemplate.Status
		continue:(Status ="-1")
		s Code = objUserTemplate.Code
		s Name = objUserTemplate.Name
		s TemplateID = objUserTemplate.TemplateID
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
				s AuditName = $p($g(^SSU("SSUSR",AuditRowId)),"^",2) //书写医生姓名
			}
		}
		s AuditDate = objUserTemplate.AuditDate
		
		s Sequence = objUserTemplate.Sequence
		s VersionNumber = objUserTemplate.VersionNumber
		s Remark = objUserTemplate.Remark
		s Type = objUserTemplate.Type
		s objTemplate = ##Class(EMRmeta.Template).%OpenId(objUserTemplate.TemplateID)
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
		if (aCTLocName'="")&&(aCTLocName'=$c(0))
		{
			&sql(select ID into :rowCTID from EMRmeta.UserTemplateCTLoc where Code =:Code and CTLocName like '%'_:aCTLocName_'%')
			;continue:(rowCTID="")
		}
		else
		{
			s rowCTID = $o(^DHCEMRM.UserTemplateCTLocI("IdxCode"," "_$g(Code),rowCTID))
		}
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
		s Data = $lb(rowID,Code,Name,TemplateID,SimpleSpelName,UserID,UserName,CreateDate,AuditID,AuditName,AuditDate,Type,Sequence,Status,VersionNumber,rowCTID,CTLocID,CTLocName,rowTitleID,TitleCode,TitleName,Remark,path,rowDiseaseID,DiagnosCode,DiagnosName)
		s ^CacheTemp(repid,ind) = Data
		s ind = ind + 1	
		
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

/// 根据科室ID获取用户模板
/// /////////用户模板科室////////////
/// Debug:	d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLUserTemplate","GetUserTemplateByTemID","1")
Query GetUserTemplateByTemID(aTemID As %String, aCTLocName As %String) As %Query(ROWSPEC = "ID:%Integer,Code:%String,Name:%String,TemplateID:%String,SimpleSpelName:%String,UserID:%String,CreateDate:%String,Sequence:%String,Status:%String,Type:%String,VersionNumber:%String,RowCTID:%String,CTLocID:%String,CTLocName:%String,RowTitleID:%String,TitleCode:%String,TitleName:%String,Remark:%String,rowDiseaseID:%String,DiagnosCode:%String,DiagnosName:%String")
{
}

ClassMethod GetUserTemplateByTemIDExecute(ByRef qHandle As %Binary, aTemID As %String, aCTLocName As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	q:(($g(aTemID) = "")||(aTemID=$c(0))) $$$OK
	s rowID = ""
	s Sequence = ""
	for {
		s Sequence = $o(^DHCEMRM.UserTemplateI("IdxTemplateID"," "_$g(aTemID),Sequence))
		q:(Sequence = "")
		for {
		s rowID = $o(^DHCEMRM.UserTemplateI("IdxTemplateID"," "_$g(aTemID),Sequence,rowID))
		
		q:(rowID = "")
		s objUserTemplate = ##Class(EMRmeta.UserTemplate).%OpenId(rowID)
		continue:(objUserTemplate = "")
		s Status = objUserTemplate.Status
		continue:(Status ="-1")
		s Code = objUserTemplate.Code
		s Name = objUserTemplate.Name
		s TemplateID = objUserTemplate.TemplateID
		s SimpleSpelName = objUserTemplate.SimpleSpelName
		s UserID = objUserTemplate.UserID	
		s CreateDate = objUserTemplate.CreateDate
		s Sequence = objUserTemplate.Sequence
		s VersionNumber = objUserTemplate.VersionNumber
		s Remark = objUserTemplate.Remark
		s Type = objUserTemplate.Type
		s CTLocID = ""
		s CTLocName = ""
		s rowCTID =""
		if (aCTLocName'="")&&(aCTLocName'=$c(0))
		{
			&sql(select ID into :rowCTID from EMRmeta.UserTemplateCTLoc where Code =:Code and CTLocName like '%'_:aCTLocName_'%')
			;continue:(rowCTID="")
		}
		else
		{
			s rowCTID = $o(^DHCEMRM.UserTemplateCTLocI("IdxCode"," "_$g(Code),rowCTID))
		}
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
		s Data = $lb(rowID,Code,Name,TemplateID,SimpleSpelName,UserID,CreateDate,Sequence,Status,Type,VersionNumber,rowCTID,CTLocID,CTLocName,rowTitleID,TitleCode,TitleName,Remark,rowDiseaseID,DiagnosCode,DiagnosName)
		s ^CacheTemp(repid,ind) = Data
		s ind = ind + 1	
		}
	}
	
	q $$$OK
}

ClassMethod GetUserTemplateByTemIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUserTemplateByTemIDExecute ]
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

ClassMethod GetUserTemplateByTemIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUserTemplateByTemIDExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 根据ID获取用户模板
ClassMethod GetUserTemplateByID(ARowID As %String) As EMRservice.entity.EUserTemplate
{
	s objUserTemplate = ##Class(EMRmeta.UserTemplate).%OpenId(ARowID)
	q:(objUserTemplate = "") ""
	
	s Result = ##Class(EMRservice.entity.EUserTemplate).%New()
	s Result.ID = objUserTemplate.%Id()
	s Result.Code = objUserTemplate.Code
	s Result.Name = objUserTemplate.Name
	s Result.TemplateID = objUserTemplate.TemplateID
	s Result.SimpleSpelName = objUserTemplate.SimpleSpelName
	s Result.UserID = objUserTemplate.UserID	
	s Result.CreateDate = objUserTemplate.CreateDate
	s Result.Status = objUserTemplate.Status
	s Result.Type = objUserTemplate.Type
	s Result.Sequence = objUserTemplate.Sequence
	s Result.VersionNumber = objUserTemplate.VersionNumber
	s Result.Remark = objUserTemplate.Remark
	d Result.TemplateData.CopyFrom(objUserTemplate.TemplateData)
	
	q Result
}

/// CreateTime: 2014-02-12
/// Creator:    
/// Desc:		得到模板xml文档
/// Input:		ATemplateVersionId: 模板版本ID
///             AOutRecords: 返回xml 
/// OutPut:     result: 返回1保存成功, -1保存失败
ClassMethod LoadUserTemplate(ByRef AOutRecords As %GlobalBinaryStream, AUserTemplateId As %String) As %String
{
	s result = "-1"		
    q:(AUserTemplateId = "") result 
    s objUserTemplate = ##Class(EMRmeta.UserTemplate).%OpenId(AUserTemplateId)
    q:(objUserTemplate = "") result
    
    s TemplateData = ##class(%GlobalBinaryStream).%New()

    d TemplateData.CopyFrom(objUserTemplate.TemplateData)  	

    d AOutRecords.CopyFrom(TemplateData)
	s result = "1"
	q result
}

/// Desc:       保存模板
/// Creator:    
/// Createdate: 2014-01-25
/// Input:      argInData 模板文件流
///             TemplateVersionId   
/// Output:     result 1成功,-1失败 
ClassMethod SaveUserTemplate(argInData As %GlobalBinaryStream, UserTemplateId As %String, Author As %String = "") As %String
{
	s result = "-1"		
    q:((UserTemplateId = "")||(argInData = "")) result 
   	s objUserTempalte = ##Class(EMRmeta.UserTemplate).%OpenId(UserTemplateId)
    q:(objUserTempalte = "") result

    d objUserTempalte.TemplateData.Clear()

    d objUserTempalte.TemplateData.CopyFrom(argInData)
    s sc = objUserTempalte.%Save()
    s strCode =objUserTempalte.Code
	s:($$$ISOK(sc)) result = "1"
	q result
}

/// 根据Code获取用户模板
ClassMethod GetUserTemplateByCode(ACode As %String) As EMRservice.entity.EUserTemplate
{
	s ARowID = ""
	s ARowID = $o(^DHCEMRM.UserTemplateI("IdxCode"," "_$zcvt(ACode,"U"),ARowID))
	q:(ARowID = "") ""
	s objUserTemplate = ##Class(EMRmeta.UserTemplate).%OpenId(ARowID)
	q:(objUserTemplate = "") ""
	
	s Result = ##Class(EMRservice.entity.EUserTemplate).%New()
	s Result.ID = objUserTemplate.%Id()
	s Result.Code = objUserTemplate.Code
	s Result.Name = objUserTemplate.Name
	s Result.TemplateID = objUserTemplate.TemplateID
	s Result.SimpleSpelName = objUserTemplate.SimpleSpelName
	s Result.UserID = objUserTemplate.UserID	
	s Result.CreateDate = objUserTemplate.CreateDate
	s Result.Type = objUserTemplate.Type
	s Result.Status = objUserTemplate.Status
	s Result.Sequence = objUserTemplate.Sequence
	s Result.VersionNumber = objUserTemplate.VersionNumber
	d Result.TemplateData.CopyFrom(objUserTemplate.TemplateData)
	q Result
}

/// 检查用户模板
ClassMethod CheckUserTemplate(Code As %String) As %String
{
	s rowID = ""
    s rowID = $o(^DHCEMRM.UserTemplateI("IdxCode"," "_$zcvt(Code,"U"),rowID))
	q rowID
}

/// 得到最大code编号
ClassMethod GetMaxCode() As %String
{
	//s IdexCode=0
	&sql(select max(id) into :IdexCode   from EMRmeta.UserTemplate)
	s:(IdexCode="") IdexCode=0
	q IdexCode
}

/// 添加用户模板
ClassMethod AddUserTemplate(AUserTemplate As EMRservice.entity.EUserTemplate, aCTLocID As %String, aCTLocName As %String, aTitleCode As %String, aTitleName As %String, aDiagnosCode As %String, aDiagnosName As %String) As %String
{
	TStart
	s ret = 1
	s objUserTemplate = ##Class(EMRmeta.UserTemplate).%New()
	s objUserTemplate.Code = $case(AUserTemplate.Code,$c(0):"",:AUserTemplate.Code)
	s objUserTemplate.Name = $case(AUserTemplate.Name,$c(0):"",:AUserTemplate.Name)
	s objUserTemplate.TemplateID = AUserTemplate.TemplateID
	s objUserTemplate.SimpleSpelName = AUserTemplate.SimpleSpelName
	s objUserTemplate.UserID = AUserTemplate.UserID
	s objUserTemplate.Status = AUserTemplate.Status
	s objUserTemplate.Type = AUserTemplate.Type
	s objUserTemplate.CreateDate =  $ZDATE($h,3)_" "_ $ZTIME($PIECE($H,",",2),1)
	s objUserTemplate.VersionNumber = AUserTemplate.VersionNumber
	s objUserTemplate.ModifyID = AUserTemplate.ModifyID
	s objUserTemplate.ModifyDate = $ZDATE($h,3)_" "_ $ZTIME($PIECE($H,",",2),1)
	s objUserTemplate.OperateMachineIP = AUserTemplate.OperateMachineIP
	//d objUserTemplate.TemplateData.CopyFrom(AUserTemplate.TemplateData)
	s sc = objUserTemplate.%Save()
	if ($$$ISOK(sc))
	{
		s ret=objUserTemplate.%Id()
		s objUserTemplate.Sequence=ret
		if '(objUserTemplate.%Save())
		{
			s ret=0
		}
		//用户模板关联标题
		if ((aCTLocID'="")&&(aCTLocID'=$C(0)))
		{
			//用户模板关联科室
			s objUserTemLoc = ##Class(EMRmeta.UserTemplateCTLoc).%New()
			quit:(objUserTemLoc="") ""
			s objUserTemLoc.Code =AUserTemplate.Code
			s objUserTemLoc.CTLocID =aCTLocID
			s objUserTemLoc.CTLocName =aCTLocName
			s sc = objUserTemLoc.%Save()
			if ('$$$ISOK(sc))
			{
				s ret=0
			}
		}
		//用户模板关联标题
		if ((aTitleCode'="")&&(aTitleCode'=$C(0)))
		{
			s objUserTemTitle = ##Class(EMRmeta.UserTemplateTitle).%New()
			quit:(objUserTemTitle="") ""
			s objUserTemTitle.Code =AUserTemplate.Code
			s objUserTemTitle.TitleCode =aTitleCode
			s objUserTemTitle.TitleName =aTitleName
			s sc = objUserTemTitle.%Save()
			if ('$$$ISOK(sc))
			{
				s ret=0
			}
		}
		//用户模板关联标题
		if ((aDiagnosCode'="")&&(aDiagnosCode'=$C(0)))
		{
			s objUserTemDisease = ##Class(EMRmeta.UserTemplateDisease).%New()
			quit:(objUserTemDisease="") ""
			s objUserTemDisease.Code =AUserTemplate.Code
			s objUserTemDisease.DiagnosCode =aDiagnosCode
			s objUserTemDisease.DiagnosName =aDiagnosName
			s sc = objUserTemDisease.%Save()
			if ('$$$ISOK(sc))
			{
				s ret=0
			}
		}
		
	}
	else
	{
		s ret=0
	}
	if (ret ="0")
	{
		TROLLBACK
		q ret
	}
	else
	{
		TCOMMIT
	}
	d objUserTemplate.%Close()
	k objUserTemplate
	q ret
}

/// 修改用户模板
ClassMethod ModUserTemplate(AUserTemplate As EMRservice.entity.EUserTemplate, aUserTemLoc As EMRservice.entity.EUserTemplateCTLoc, aUserTemTitle As EMRservice.entity.EUserTemplateTitle, aUserTemDisease As EMRservice.entity.EUserTemplateDisease) As %Boolean
{
	
	TStart
	s ret = 1
	s objUserTemplate = ##Class(EMRmeta.UserTemplate).%OpenId(AUserTemplate.ID) 
	s objUserTemplate.Code = AUserTemplate.Code
	s objUserTemplate.Name = AUserTemplate.Name
	s objUserTemplate.TemplateID = AUserTemplate.TemplateID
	s objUserTemplate.SimpleSpelName = AUserTemplate.SimpleSpelName
	s objUserTemplate.UserID = AUserTemplate.UserID
	s objUserTemplate.Sequence = AUserTemplate.Sequence
	s objUserTemplate.Status = AUserTemplate.Status
	s objUserTemplate.Type = AUserTemplate.Type
	s objUserTemplate.VersionNumber = AUserTemplate.VersionNumber
	s objUserTemplate.ModifyID = AUserTemplate.ModifyID
	s objUserTemplate.ModifyDate = $ZDATE($h,3)_" "_ $ZTIME($PIECE($H,",",2),1)
	s objUserTemplate.OperateMachineIP = AUserTemplate.OperateMachineIP
	;d objUserTemplate.TemplateData.CopyFrom(AUserTemplate.TemplateData)
	if (aUserTemLoc'="")
	{
		s ctLRowId = $o(^DHCEMRM.UserTemplateCTLocI("IdxCodeAndCTLocID"," "_AUserTemplate.Code," "_aUserTemLoc.CTLocID,""))
		if (ctLRowId = "")
		{
			s objUserTemplateCT = ##Class(EMRmeta.UserTemplateCTLoc).%New()
			s objUserTemplateCT.Code = aUserTemLoc.Code
			s objUserTemplateCT.CTLocID = aUserTemLoc.CTLocID
			s objUserTemplateCT.CTLocName = aUserTemLoc.CTLocName
			if '(objUserTemplateCT.%Save())
			{
				TROLLBACK
				s ret = 0
				q
			}
			d objUserTemplateCT.%Close()
		}
	}
	if (objUserTemplate.Type = "0")
	{
		&sql(DELETE FROM EMRmeta.UserTemplateCTLoc where Code =:AUserTemplate.Code)
	}
	s tiRowId = $o(^DHCEMRM.UserTemplateTitleI("IdxCode"," "_AUserTemplate.Code,""))
	if (aUserTemTitle'="")
	{
		if (tiRowId '= "")
		{
			s objUserTemplateTitle = ##Class(EMRmeta.UserTemplateTitle).%OpenId(tiRowId)
			s objUserTemplateTitle.TitleCode = aUserTemTitle.TitleCode
			s objUserTemplateTitle.TitleName = aUserTemTitle.TitleName
			if '(objUserTemplateTitle.%Save())
			{
				TROLLBACK
				s ret = 0
				q
			}
			d objUserTemplateTitle.%Close()
		}
		else
		{
			s objUserTemplateTitle = ##Class(EMRmeta.UserTemplateTitle).%New()
			s objUserTemplateTitle.Code = aUserTemTitle.Code
			s objUserTemplateTitle.TitleCode = aUserTemTitle.TitleCode
			s objUserTemplateTitle.TitleName = aUserTemTitle.TitleName
			if '(objUserTemplateTitle.%Save())
			{
				TROLLBACK
				s ret = 0
				q
			}
			d objUserTemplateTitle.%Close()
		}
	}
	elseif (tiRowId'="")
	{
		s objUserTitle = ##Class(EMRmeta.UserTemplateTitle).%OpenId(tiRowId)
		if '(objUserTitle.%DeleteId(tiRowId))
		{
			TROLLBACK
			s ret = 0
			q
		}
		
	}
	if (aUserTemDisease'="")
	{
		s disRowId = $o(^DHCEMRM.UserTemplateDiseaseI("IdxCode"," "_$zcvt(aUserTemDisease.Code,"U"),""))
		if (disRowId = "")
		{
			s objUserTemDisease = ##Class(EMRmeta.UserTemplateDisease).%New()
			s objUserTemDisease.Code = aUserTemDisease.Code
			s objUserTemDisease.DiagnosCode = aUserTemDisease.DiagnosCode
			s objUserTemDisease.DiagnosName = aUserTemDisease.DiagnosName
			if '(objUserTemDisease.%Save())
			{
				TROLLBACK
				s ret = 0
				q
			}
			d objUserTemDisease.%Close()
		}
		else
		{
			s objUserTemDisease = ##Class(EMRmeta.UserTemplateDisease).%OpenId(disRowId)
			s objUserTemDisease.DiagnosCode = aUserTemDisease.DiagnosCode
			s objUserTemDisease.DiagnosName = aUserTemDisease.DiagnosName
			if '(objUserTemDisease.%Save())
			{
				TROLLBACK
				s ret = 0
				q
			}
			d objUserTemDisease.%Close()
		}
	}
	//if (objUserTemplate.Type = "0")
	//{
	//	&sql(DELETE FROM EMRmeta.UserTemplateDisease where Code =:AUserTemplate.Code)
	//}
	if ((ret=1)&&(objUserTemplate.%Save()))
	{		   
		TCommit
	}
	else
	{
		TRollback
		s ret=0
	}	
	d objUserTemplate.%Close()
	q ret
}

/// 更新一个数据元范畴
/// w ##Class(EMRservice.BL.BLEMROrganSchemeDetails).UpdateSequences("13||1||24^2,13||1||27^24")
ClassMethod UpdateSequences(argStr As %String) As %String
{
	 S IDCount =$L(argStr,",")
	 S strMrk= 1
	 TSTART 
	 For I=1:1:IDCount
	 {
		S argstrItem= $P(argStr,",",I)
		S argID = $P(argstrItem,"^",1)
		S argSeq = $P(argstrItem,"^",2)
		if ($d(argID)=0)||($d(argSeq)=0)||(argID="")||(argSeq="")
		{
			TROLLBACK
			s strMrk = 0
			quit
		}
		s objEntity="",result=""
		s objEntity=##class(EMRmeta.UserTemplate).%OpenId(argID)
		if (objEntity ="")
		{
			TROLLBACK
			s strMrk = 0
			quit
		}	
		s objEntity.Sequence=argSeq
		s result=""
		if '(objEntity.%Save())
		{
			TROLLBACK
			s strMrk = 0
		    quit
		}
	 }
	 if (strMrk = 0)
	 {
		 TROLLBACK
		 quit 0
	 }
	TCOMMIT
	Quit 1
}

/// 修改用户模板状态
/// do ##class(EMRservice.BL.BLUserTemplate).ModUserTemplateStatus("1","-1")
ClassMethod ModUserTemplateStatus(AUserTemIDS As %String, Atatus As %String, aAuditID As %String, Remark As %String = "") As %String
{
	s Result = "-1"
	q:($g(AUserTemIDS) = "") Result
	S IDCount =$L(AUserTemIDS,"^")
	TSTART 
	For I=1:1:IDCount
	{
		s AUserTemID = $p(AUserTemIDS,"^",I)
		continue:(AUserTemID="")
		s objUserTemplate = ##Class(EMRmeta.UserTemplate).%OpenId(AUserTemID)
		q:(objUserTemplate = "")
		s objUserTemplate.Status =Atatus
		
		
		if ((Remark'="")&&(Remark'=$C(0)))
		{
			s objUserTemplate.Remark =Remark
		}
		if ((aAuditID'="")&&(aAuditID'=$C(0)))
		{
			s objUserTemplate.AuditID = aAuditID
			s objUserTemplate.AuditDate =  $ZDATE($h,3)_" "_ $ZTIME($PIECE($H,",",2),1)
		}
		if '(objUserTemplate.%Save())
		{
			TROLLBACK
			s Result = 0
			q 
		}
	}
	if (Result = 0)
	{
		 TROLLBACK
		 quit 0
	}
	TCOMMIT
	s Result = "1"
	q Result
}

/// 修改用户模板状态
/// do ##class(EMRservice.BL.BLUserTemplate).ModUserTemplateStatusNew("1","-1")
ClassMethod ModUserTemplateStatusNew(AUserTemIDS As %String, AUserTemplate As EMRservice.entity.EUserTemplate) As %String
{
	s Result = "-1"
	q:($g(AUserTemIDS) = "") Result
	S IDCount =$L(AUserTemIDS,"^")
	TSTART 
	For I=1:1:IDCount
	{
		s AUserTemID = $p(AUserTemIDS,"^",I)
		continue:(AUserTemID="")
		s objUserTemplate = ##Class(EMRmeta.UserTemplate).%OpenId(AUserTemID)
		q:(objUserTemplate = "")
		s objUserTemplate.Status =AUserTemplate.Status
		if (AUserTemplate.Status ="-1")
		{
			//s objUserTemplate.ModifyID =AUserTemplate.ModifyID
			//s objUserTemplate.ModifyDate =$ZDATE($h,3)_" "_ $ZTIME($PIECE($H,",",2),1)
			//s objUserTemplate.OperateMachineIP =AUserTemplate.OperateMachineIP
			//科室模板数据由逻辑删除，直接改为物理删除。
			s Result = ##Class(EMRservice.BL.BLUserTemplate).DelUserTemplateAll(objUserTemplate.Code)
			//删除成功执行下一条
			continue:(Result=1)
			//删除失败执行回滚
			if (Result=0)
			{
				TROLLBACK
				q
			}
		}
		if ((AUserTemplate.Remark'="")&&(AUserTemplate.Remark'=$C(0)))
		{
			s objUserTemplate.Remark =AUserTemplate.Remark
		}
		if ((AUserTemplate.AuditID'="")&&(AUserTemplate.AuditID'=$C(0)))
		{
			s objUserTemplate.AuditID = AUserTemplate.AuditID
			s objUserTemplate.AuditDate =  $ZDATE($h,3)_" "_ $ZTIME($PIECE($H,",",2),1)
		}
		if '(objUserTemplate.%Save())
		{
			TROLLBACK
			s Result = 0
			q 
		}
	}
	if (Result = 0)
	{
		 TROLLBACK
		 quit 0
	}
	TCOMMIT
	s Result = "1"
	q Result
}

/// 删除用户模板
/// do ##class(EMRservice.BL.BLUserTemplate).DelUserTemplate("BINZ004")
ClassMethod DelUserTemplateAll(ACode As %String) As %Boolean
{
	s ret = 0
	q:($g(ACode) = "") ret

	s flag = 1
	s UserTemplateID = $g(ACode)
	
	TSTART
	s UserTemplateID = $o(^DHCEMRM.UserTemplateI("IdxCode"," "_$zcvt(ACode,"U"),""))
	q:($g(UserTemplateID) = "") ret
	
	///删除所有用户模板科室关联
	s UserTemplateCTRowID = ""
	for {
		s UserTemplateCTRowID = $o(^DHCEMRM.UserTemplateCTLocI("IdxCode"," "_$zcvt(ACode,"U"),UserTemplateCTRowID))
		q:(UserTemplateCTRowID = "")
	
		s objUserTemplateCT = ##Class(EMRmeta.UserTemplateCTLoc).%OpenId(UserTemplateCTRowID)
		if '(objUserTemplateCT.%DeleteId(UserTemplateCTRowID))
		{
			TROLLBACK
			s ret = 0
			q
		}
	}
	
	///删除所有用户模板诊断关联
	s UserTemplateDisRowID = ""
	for {
		s UserTemplateDisRowID = $o(^DHCEMRM.UserTemplateDiseaseI("IdxCode"," "_$zcvt(ACode,"U"),UserTemplateDisRowID))
		q:(UserTemplateDisRowID = "")
		
		s objUserTemplateDis = ##Class(EMRmeta.UserTemplateDisease).%OpenId(UserTemplateDisRowID)
		if '(objUserTemplateDis.%DeleteId(UserTemplateDisRowID))
		{
			TROLLBACK
			s flag = 0
			q
		}
	}
	
	///删除章节关联
	s UserTemplateSecReRowID = ""
	for {
		s UserTemplateSecReRowID = $o(^DHCEMRM.UserTemplateRelationI("IdxCode"," "_$zcvt(ACode,"U"),UserTemplateSecReRowID))
		q:(UserTemplateSecReRowID = "")
		
		s objUserTemplateSecRe = ##Class(EMRmeta.UserTemplateSectionRelation).%OpenId(UserTemplateSecReRowID)
		if '(objUserTemplateSecRe.%DeleteId(UserTemplateSecReRowID))
		{
			TROLLBACK
			s flag = 0
			q
		}
	}
	
	///删除章节打散数据
	s UserTemplateSecRowID = ""
	for {
		s UserTemplateSecRowID = $o(^DHCEMRM.UserTemplateSectionI("IdxCode"," "_$zcvt(ACode,"U"),UserTemplateSecRowID))
		q:(UserTemplateSecRowID = "")
		
		s objUserTemplateSec = ##Class(EMRmeta.UserTemplateSection).%OpenId(UserTemplateSecRowID)
		if '(objUserTemplateSec.%DeleteId(UserTemplateSecRowID))
		{
			TROLLBACK
			s flag = 0
			q
		}
	}
	
	///删除分组科室关联数据
	s UserTemplateGroupItemRowID = ""
	for {
		s UserTemplateGroupItemRowID = $o(^DHCEMRM.UserTemplateGroupItemI("IdxUserCode"," "_$zcvt(ACode,"U"),UserTemplateGroupItemRowID))
		q:(UserTemplateGroupItemRowID = "")
		
		s objUserTemplateGroupItem = ##Class(EMRmeta.UserTemplateGroupItem).%OpenId(UserTemplateGroupItemRowID)
		if '(objUserTemplateGroupItem.%DeleteId(UserTemplateGroupItemRowID))
		{
			TROLLBACK
			s flag = 0
			q
		}
	}
	
	///删除科室模板关联的标题表数据
	s UserTemplateTitleRowID = ""
	for {
		s UserTemplateTitleRowID = $o(^DHCEMRM.UserTemplateTitleI("IdxCode"," "_$zcvt(ACode,"U"),UserTemplateTitleRowID))
		q:(UserTemplateTitleRowID = "")
	
		s objUserTemplateTitle = ##Class(EMRmeta.UserTemplateTitle).%OpenId(UserTemplateTitleRowID)
		if '(objUserTemplateTitle.%DeleteId(UserTemplateTitleRowID))
		{
			TROLLBACK
			s flag = 0
			q
		}
	}
	
	s objUserTemplate = ##Class(EMRmeta.UserTemplate).%OpenId(UserTemplateID)
	if '(objUserTemplate.%DeleteId(UserTemplateID))
	{
		TROLLBACK
		s flag = 0
	}
	else
	{
		 TCommit
		 s flag = 1
	}
	
	s ret = flag
	q ret
}

/// 根据科室ID获取用户模板
/// /////////用户模板科室////////////
/// Debug:	d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLUserTemplate","GetUserTemplateByCtLocIDOrCode","","GROUP01")
Query GetUserTemplateByCtLocIDOrCode(ACtLocID As %String, aCode As %String) As %Query(ROWSPEC = "ID,Code,Name,CTLocID,CTLocName")
{
}

ClassMethod GetUserTemplateByCtLocIDOrCodeExecute(ByRef qHandle As %Binary, ACtLocID As %String, aCode As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	q:((($g(ACtLocID) = "")||(ACtLocID=$c(0)))&&(($g(aCode)="")||(aCode=$c(0)))) $$$OK
	s rowID = ""
	for {
		if ((ACtLocID '="")&&(ACtLocID'=$c(0)))
		{
			s rowID = $o(^DHCEMRM.UserTemplateCTLocI("IdxCTLocID"," "_$g(ACtLocID),rowID))
		}
		elseif ((aCode'="")&&(aCode'=$c(0)))
		{
			s rowID = $o(^DHCEMRM.UserTemplateCTLocI("IdxCode"," "_$zcvt(aCode,"U"),rowID))
		}
		q:(rowID = "")
		s objUserTemplateCT = ##Class(EMRmeta.UserTemplateCTLoc).%OpenId(rowID)
		continue:(objUserTemplateCT = "")
	
		s Code = objUserTemplateCT.Code
		s Name = objUserTemplateCT.Name
		s CTLocID = objUserTemplateCT.CTLocID
		s CTLocName = objUserTemplateCT.CTLocName

	
		s Data = $lb(rowID,Code,Name,CTLocID,CTLocName)
		s ^CacheTemp(repid,ind) = Data
		s ind = ind + 1	
	}
	
	q $$$OK
}

ClassMethod GetUserTemplateByCtLocIDOrCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUserTemplateByCtLocIDOrCodeExecute ]
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

ClassMethod GetUserTemplateByCtLocIDOrCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUserTemplateByCtLocIDOrCodeExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 检查用户模板科室
ClassMethod CheckUserTemplateCTLocCode(Code As %String, CTLocID As %String) As %String
{
	s rowID = ""	
    s rowID = $o(^DHCEMRM.UserTemplateCTLocI("IdxCTLocIDAndCode"," "_$zcvt(CTLocID,"U")," "_$zcvt(Code,"U"),rowID))
	q rowID
}

/// 添加用户模板科室
ClassMethod AddUserTemplateCTLoc(AUserTemplateCTLoc As EMRservice.entity.EUserTemplateCTLoc) As %String
{
	s ret = 1
	
	s rowID= ##Class(EMRservice.BL.BLUserTemplate).CheckUserTemplateCTLocCode(AUserTemplateCTLoc.CTLocID,AUserTemplateCTLoc.Code)
	q:(rowID'="") ret
	s objUserTemplateCTLoc = ##Class(EMRmeta.UserTemplateCTLoc).%New()
	s objUserTemplateCTLoc.Code =AUserTemplateCTLoc.Code
	s objUserTemplateCTLoc.Name =AUserTemplateCTLoc.Name
	s objUserTemplateCTLoc.CTLocID =AUserTemplateCTLoc.CTLocID
	s objUserTemplateCTLoc.CTLocName =AUserTemplateCTLoc.CTLocName
	if (objUserTemplateCTLoc.%Save())
	{
	    s ret=objUserTemplateCTLoc.%Id()
	}
	else
	{
	   s ret=0
	}		

	d objUserTemplateCTLoc.%Close()
	q ret
}

/// 删除用户模板科室
ClassMethod DelUserTemplateCTLoc(AID As %String) As %Boolean
{
	&SQL(DELETE FROM EMRmeta.UserTemplateCTLoc WHERE ID=:AID)
	q SQLCODE
}

/// 根据用户模板ID获取用户模板关联
/// /////////用户模板诊断/////////////
/// Debug:	d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLUserTemplate","GetUserTemplateByICDIDOrCode","BINZ001","")
Query GetUserTemplateByICDIDOrCode(aCode As %String, aICDID As %String) As %Query(ROWSPEC = "ID,Code,Name,ICDID,ICDCode,ICDName")
{
}

ClassMethod GetUserTemplateByICDIDOrCodeExecute(ByRef qHandle As %Binary, aCode As %String, aICDID As %String) As %Status
{
	
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	q:((($g(aICDID) = "")||(aICDID=$c(0)))&&(($g(aCode)="")||(aCode=$c(0)))) $$$OK
	
	///开始查询
	s rowid = 0
	for {
		if ((aICDID '="")&&(aICDID'=$c(0)))
		{
			s rowid = $o(^DHCEMRM.UserTemplateDiseaseI("IdxICDID",$g(aICDID),rowid))
		}
		elseif ((aCode '="")&&(aCode'=$c(0)))
		{
			s rowid = $o(^DHCEMRM.UserTemplateDiseaseI("IdxCode"," "_$zcvt(aCode,"U"),rowid))
		}
		quit:(rowid = "")			
			
		s objUserTemplateDis = ##Class(EMRmeta.UserTemplateDisease).%OpenId(rowid)
		s Code=objUserTemplateDis.Code
		s Name=objUserTemplateDis.Name
		s ICDID=objUserTemplateDis.ICDID
		s ICDCode=objUserTemplateDis.ICDCode
		s ICDName=objUserTemplateDis.ICDName
		
		s Data = $LB(rowid,Code,Name,ICDID,ICDCode,ICDName)
		s ^CacheTemp(repid,ind) = Data
		s ind = ind + 1			
	}		
	
	q $$$OK
}

ClassMethod GetUserTemplateByICDIDOrCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUserTemplateByICDIDOrCodeExecute ]
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

ClassMethod GetUserTemplateByICDIDOrCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUserTemplateByICDIDOrCodeExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 检查用户模板诊断
ClassMethod CheckUserTemplateDiseaseCode(Code As %String, ICDCode As %String) As %String
{
	
	s rowID = ""	
    s rowID = $o(^DHCEMRM.UserTemplateDiseaseI("IdxCodeAndICDCode"," "_$zcvt(Code,"U")," "_$zcvt(ICDCode,"U"),rowID))
	q rowID
}

/// 添加用户模板诊断
ClassMethod AddUserTemplateDisease(AUserTemplateDisease As EMRservice.entity.EUserTemplateDisease) As %String
{
	s ret = 1
	
	s rowID= ##Class(EMRservice.BL.BLUserTemplate).CheckUserTemplateDiseaseCode(AUserTemplateDisease.Code,AUserTemplateDisease.ICDCode)
	q:(rowID'="") ret
	s objUserTemplateDisease = ##Class(EMRmeta.UserTemplateDisease).%New()
	s objUserTemplateDisease.Code =AUserTemplateDisease.Code
	s objUserTemplateDisease.Name =AUserTemplateDisease.Name
	s objUserTemplateDisease.ICDID =AUserTemplateDisease.ICDID
	s objUserTemplateDisease.ICDCode =AUserTemplateDisease.ICDCode	
	s objUserTemplateDisease.ICDName =AUserTemplateDisease.ICDName
	if (objUserTemplateDisease.%Save())
	{
	    s ret=objUserTemplateDisease.%Id()
	}
	else
	{
	   s ret=0
	}		

	d objUserTemplateDisease.%Close()
	q ret
}

/// 删除用户模板诊断
ClassMethod DelUserTemplateDisease(AID As %String) As %Boolean
{
	&SQL(DELETE FROM EMRmeta.UserTemplateDisease WHERE ID=:AID)
	q SQLCODE
}

ClassMethod Test()
{
    /*
    s obj = ##class(EMRservice.entity.EUserTemplate).%New()
	s obj.CTLocID="106"
	s obj.Description="1"
	s obj.ID="91"
	s obj.UserTemplate="aaa"
	s obj.GroupName="sdfsdaf"
	s obj.Name="sdfsdaf"
	s obj.GroupDescription="sdfsdaf"
	*/
}

/// Desc: 取病种
/// input:DiagnosInfo 诊断（包含RowID）  ALocID 科室ID AText病种名
/// output:  Code  病种Code
///         Name  病种名称
/// Debug d ##class(EMRservice.BL.BLUserTemplate).getDiseaseByDiagnos("6924^E10.000^1型糖尿病伴有昏迷","95")
ClassMethod getDiseaseByDiagnos(ADiagnosInfo As %String = "", ALocID As %String = "", AText As %String = "")
{
		s resultJson = ##Class(%GlobalBinaryStream).%New()
	s result=""
	//s IcdID = $P(ADiagnosInfo,"^",1)
	
	s IcdCode = $P(ADiagnosInfo,"^",2)
	s RowId = ""
	d resultJson.Write("[")
	s count=0
	//if (IcdID'=""){
	if (IcdCode'=""){
		for
		{	
			//诊断过滤
			//s RowId=$O(^DHCEMRM.DiagnosDiseaseI("IdxICDID",IcdID,RowId))
			s RowId=$O(^DHCEMRM.DiagnosDiseaseI("IdxICDCode"," "_$zcvt(IcdCode,"U"),RowId))
			
			q:RowId=""
			
			s obj = ##class(EMRmeta.DiagnosDisease).%OpenId(RowId)
			s DiseaseCode = obj.DiagnosCode
			continue:DiseaseCode=""
			//科室过滤
			s CTLocRowID=""
			s CTLocIDFlag=0
			if (ALocID'=""){
				for
				{
					s CTLocRowID = $O(^DHCEMRM.DiagnosCTLocI("IdxDiagnosCode"," "_DiseaseCode,CTLocRowID))
					q:CTLocRowID=""
					s obj = ##class(EMRmeta.DiagnosCTLoc).%OpenId(CTLocRowID)
					s CTLocID = obj.CTLocID
					s:CTLocID=ALocID CTLocIDFlag=1
					q:CTLocIDFlag=1
				}	
			}
			continue:(ALocID'="")&&(CTLocIDFlag=0)
			//IdxDiagnosCode ^DHCEMRM.DiagnosI
			s DiseaseRowID = ""
			s DiseaseRowID = $O(^DHCEMRM.DiagnosI("IdxDiagnosCode"," "_DiseaseCode,DiseaseRowID))
			continue:DiseaseRowID=""
			s DiseaseObj = ##class(EMRmeta.Diagnos).%OpenId(DiseaseRowID)
			continue:DiseaseObj.Status'="0"
			s Code = DiseaseObj.DiagnosCode
			s Name = DiseaseObj.DiagnosName
			s:(count'=0) result=result_","
			d:(count'=0) resultJson.Write(",")
			continue:('(Name[AText) && '(Code[AText)&&(AText'=""))
			d resultJson.Write("{")
			d resultJson.Write("""Code"":"""_Code_"""")
			d resultJson.Write(",""Name"":"""_Name_"""")
			d resultJson.Write("}")
			s result=result_"{"
			s result=result_"""Id"":"""_count_""""
			s result=result_",""Code"":"""_Code_""""
			s result=result_",""Name"":"""_Name_""""
			s result=result_"}"
			s count = count+1
		}	
	}else{
		s DiseaseCode=""
		for
		{
			s DiseaseCode=$O(^DHCEMRM.DiagnosI("IdxDiagnosCode",DiseaseCode))
			q:DiseaseCode=""
			//科室过滤
			s CTLocRowID=""
			s CTLocIDFlag=0
			if (ALocID'=""){
				for
				{
					s CTLocRowID = $O(^DHCEMRM.DiagnosCTLocI("IdxDiagnosCode",DiseaseCode,CTLocRowID))
					q:CTLocRowID=""
					s obj = ##class(EMRmeta.DiagnosCTLoc).%OpenId(CTLocRowID)
					s CTLocID = obj.CTLocID
					s:CTLocID=ALocID CTLocIDFlag=1
					q:CTLocIDFlag=1
				}
			}
			continue:(ALocID'="")&&(CTLocIDFlag=0)
			s DiseaseRowID=""
			s DiseaseRowID = $O(^DHCEMRM.DiagnosI("IdxDiagnosCode",DiseaseCode,DiseaseRowID))
			continue:DiseaseRowID=""
			s DiseaseObj = ##class(EMRmeta.Diagnos).%OpenId(DiseaseRowID)
			continue:DiseaseObj.Status'="0"
			s Code = DiseaseObj.DiagnosCode
			s Name = DiseaseObj.DiagnosName
			continue:('(Name[AText) && '(Code[AText)&&(AText'=""))
			s:(count'=0) result=result_","
			d:(count'=0) resultJson.Write(",")
			d resultJson.Write("{")
			d resultJson.Write("""Code"":"""_Code_"""")
			d resultJson.Write(",""Name"":"""_Name_"""")
			d resultJson.Write("}")
			s result=result_"{"
			s result=result_"""Id"":"""_count_""""
			s result=result_",""Code"":"""_Code_""""
			s result=result_",""Name"":"""_Name_""""
			s result=result_"}"
			s count = count+1
		}
	}
	d resultJson.Write("]")

	q resultJson
}

/// Desc: 通过病种取关联模板的EMRmeta.UserTemplate的Code
/// input:病种code-name
/// output:   EMRmeta.UserTemplate的Code
/// Debug d ##class(EMRservice.BL.BLUserTemplate).GetTempCodeByDisease("032101-乳腺癌")
ClassMethod GetTempCodeByDisease(pDiseaseCodeAndName As %String)
{
	s ReturnValue=##Class(%ListOfDataTypes).%New()
	s diseaseCode = $P(pDiseaseCodeAndName,"-",1)
	q:diseaseCode="" ""
	s rowId=""
	for
	{
		s rowId = $O(^DHCEMRM.UserTemplateDiseaseI("IdxDiagnosCode"," "_diseaseCode,rowId))
		q:rowId=""
		s obj = ##class(EMRmeta.UserTemplateDisease).%OpenId(rowId)
		continue:obj=""
		s userTempCode = obj.Code
		d ReturnValue.Insert(userTempCode)
	}
	q ReturnValue
}

Query SELECTALLTITLES(AtemplateID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,Code:%String,Description:%String,Alias:%String,Sequence:%Integer,CID:%Integer,CategoryID:%String,TemplateID:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_EMR_USERTEM_SELECTALLTITLES, SqlProc ]
{
	SELECT t.ID,t.Code,t.Description,t.Alias,c.Sequence,c.ID,c.CategoryID,e.BindTemplateID
	FROM EMRmeta.Titles t join EMRmeta.TitleConfig c
	on  t.Code = c.TitleCode  JOIN emrmeta.emrtemplate e ON c.TemplateID = e.ID and e.BindTemplateID =:AtemplateID ORDER BY c.Sequence
}

/// Desc:       取当前科室模板
/// Creator:    Candy
/// CreateDate: 2017-11-8
/// Input:       pLocID 科室ID 
///             pDocID 目录展现结构ID
///             pEpisodeID 就诊ID
/// Output:     json Stream
/// Debug:      d ##Class(EMRservice.BL.BLUserTemplate).GetUserTemplateJson(190,4561,456449)
ClassMethod GetUserTemplateJsonForHISUI(pLocID As %String, pDocID As %String, pEpisodeID As %String, pText As %String = "", pDiseaseCodeAndName As %String = "", pUserID As %String = "") As %GlobalBinaryStream
{
	s resultJson = ##Class(%GlobalBinaryStream).%New()
	q:(pDocID = "") json
	s result = ##class(%ResultSet).%New("EMRservice.BL.BLUserTemplate:GetUserTemplate")
	d result.Execute(pLocID,pDocID,pEpisodeID,pText,pDiseaseCodeAndName)
	s key = $i(^CacheTemp("GetUserTemplateJson"))
	s count = 0
    s oTitleSeq = "ZZNONE"
	while result.%Next()
	{
		s count = count + 1
		s data = $lb(result.Data("oCode"),result.Data("oName"),result.Data("oSimpleSpel"),result.Data("oTemplateID"),result.Data("oTitleCode"),result.Data("oType"),result.Data("ID"))
		s oTitleSeq = result.Data("oTitleSeq")
		s:(oTitleSeq = "") oTitleSeq = "ZZNONE"
		//根据用户使用频率排序
		if (##Class(EMRservice.SystemParameter).IsSortByUserFrequency() = "Y")&&(pUserID '= "")
		{
			s frequency = 0
			s strTemplateID = result.Data("oTemplateID")
			s strUserTemID =result.Data("ID")
			s frequency = $o(^DHCEMRI.UserTemplateFreqI("IdxTemUserTemUserFreq"," "_strTemplateID," "_strUserTemID," "_pUserID,""))
			s:(frequency = "") frequency = 0
			s ^CacheTemp("GetUserTemplateFreq",key,oTitleSeq,strTemplateID,frequency,count) = data
			s ^CacheTemp("GetUserTemplateFreq",key,oTitleSeq,strTemplateID,frequency,count,"Flag")= result.Data("oCode")
		}
		else
		{
			s ^CacheTemp("GetUserTemplateJson",key,oTitleSeq,count) = data
			s ^CacheTemp("GetUserTemplateJson",key,oTitleSeq,"Flag",result.Data("oCode"))= count
		}
	}
	if (##Class(EMRservice.SystemParameter).IsSortByUserFrequency() = "Y")
	{
		d ..SortUserTemplateByFrequency(key)
	}
	if (oTitleSeq = "ZZNONE")
	{
		if (pLocID = "")
		{	
			s tmpJson = ##Class(EMRservice.BL.BLUserTemplateGroup).GetGroupUserTemplate(0,key,oTitleSeq)
		}
		else
		{
			s tmpJson = ##Class(EMRservice.BL.BLUserTemplateGroup).GetGroupUserTemplateByLoc(pLocID,0,key,oTitleSeq)
		}
		d resultJson.CopyFrom(tmpJson)
	}


	//循环取可重复模板数据
	s titleCode = ""
	for
	{
		s titleCode = $o(^CacheTemp("GetUserTemplateJson",key,titleCode))
		q:(titleCode = "")
		continue:(titleCode = "ZZNONE")
		s rowId = "title" + titleCode
		s titleID = $o(^DHCEMRM.TitlesI("IdxCode"," "_titleCode,""))
		continue:(titleID = "")
		s obj = ##Class(EMRmeta.Titles).%OpenId(titleID)
		continue:(obj = "")
		s name = obj.Description
		continue:(name = "")
		d:(resultJson.Size > 0) resultJson.Write(",")
		d resultJson.Write("{")
		d resultJson.Write("""id"":"""_rowId_"""")
		d resultJson.Write(",""text"":"""_name_"""")
		d resultJson.Write(",""iconCls"":""""")
		d resultJson.Write(",""attributes"":{""nodeType"":""flod""}")
		d resultJson.Write(",""children"":[")
			 
		s seq = ""
		s count = 0
		for
		{
			s seq = $o(^CacheTemp("GetUserTemplateJson",key,titleCode,seq))
			q:(seq = "Flag")||(seq = "")
			d:(count '= 0) resultJson.Write(",")
			d writeJson
			s count = count + 1	
		}
		d resultJson.Write("]}")
	}
	
	//循环取唯一模板数据
	s seq = ""
	s titleCode = "ZZNONE"
	for
	{
		s seq = $o(^CacheTemp("GetUserTemplateJson",key,titleCode,seq))
		q:(seq = "Flag")||(seq = "")
		d:(resultJson.Size>0) resultJson.Write(",")
		d writeJson		
	}
	k ^CacheTemp("GetUserTemplateJson",key)
	q resultJson
	
writeJson
	s isUniversal = $li(^CacheTemp("GetUserTemplateJson",key,titleCode,seq),6) 
	if (isUniversal = "全院通用")
	{
		s name = "<span style='color:blue;'>"_$li(^CacheTemp("GetUserTemplateJson",key,titleCode,seq),2)_"</span>"
	}
	else
	{
		s name = $li(^CacheTemp("GetUserTemplateJson",key,titleCode,seq),2)
	}
    d resultJson.Write("{")
    d resultJson.Write("""id"":"""_$li(^CacheTemp("GetUserTemplateJson",key,titleCode,seq),7)_"""")
    d resultJson.Write(",""text"":"""_name_"""")
	if (isUniversal= "全院通用")
    {
    	d resultJson.Write(",""iconCls"":""icon-house""")
    }
    else
    {
	   d resultJson.Write(",""iconCls"":""icon-person""") 
	}
    
    s templateID = $li(^CacheTemp("GetUserTemplateJson",key,titleCode,seq),4)
    s templateobj = ##Class(EMRmeta.Template).%OpenId(templateID)
    s templateVersionId = ##Class(EMRservice.BL.BLTemplateVersion).GetMaxPubVrnID(templateID)
    s objTemplate = ##Class(EMRservice.BL.BLTemplate).GetTemplateByEMRTmpCateID(pDocID)
    
    d resultJson.Write(",""attributes"":{")
	d resultJson.Write("""Code"":"""_$li(^CacheTemp("GetUserTemplateJson",key,titleCode,seq),1)_"""")
	d resultJson.Write(",""SimpleSpel"":"""_$li(^CacheTemp("GetUserTemplateJson",key,titleCode,seq),3)_"""")
	d resultJson.Write(",""TemplateID"":"""_$li(^CacheTemp("GetUserTemplateJson",key,titleCode,seq),4)_"""")
	d resultJson.Write(",""TitleCode"":"""_$li(^CacheTemp("GetUserTemplateJson",key,titleCode,seq),5)_"""")
	d resultJson.Write(",""Type"":"""_$li(^CacheTemp("GetUserTemplateJson",key,titleCode,seq),6)_"""") 
    d resultJson.Write(",""UserTemplateId"":"""_$li(^CacheTemp("GetUserTemplateJson",key,titleCode,seq),7)_"""")
    d resultJson.Write(",""TemplateVersionId"":"""_templateVersionId_"""")
    d resultJson.Write(",""documentType"":"""_templateobj.DocumentType_"""")
	d resultJson.Write(",""nodeType"":""leaf""")
	d resultJson.Write(",""DocID"":"""_pDocID_"""")
    d resultJson.Write(",""chartItemType"":"""_objTemplate.ChartItemType_"""")
	d resultJson.Write("}}")
}

/// Desc:       取默认排序第一的科室模板ID
/// Creator:    
/// CreateDate: 2019-12-11
/// Input:      pLocID 科室ID 
///             pDocID 目录展现结构ID
///             pEpisodeID 就诊ID
/// Output:     resultID String
/// Debug:      w ##Class(EMRservice.BL.BLUserTemplate).GetFirstUserTemplateID((6,102,636,"")
ClassMethod GetFirstUserTemplateID(pLocID As %String, pDocID As %String, pEpisodeID As %String, pText As %String = "", pDiseaseCodeAndName As %String = "") As %String
{
	s resultID = ""
	q:(pDocID = "") resultID
	s result = ##class(%ResultSet).%New("EMRservice.BL.BLUserTemplate:GetUserTemplate")
	d result.Execute(pLocID,pDocID,pEpisodeID,pText,pDiseaseCodeAndName)
	s key = $i(^CacheTemp("GetUserTemplateJson"))
	s count = 0
	s oTitleCode = "ZZNONE"
	while result.%Next()
	{
		s count = count + 1
		s data = $lb(result.Data("oCode"),result.Data("oName"),result.Data("oSimpleSpel"),result.Data("oTemplateID"),result.Data("oTitleCode"),result.Data("oType"),result.Data("ID"))
		s oTitleCode = result.Data("oTitleCode")
		s:(oTitleCode = "") oTitleCode = "ZZNONE"
		s ^CacheTemp("GetUserTemplateJson",key,oTitleCode,count) = data
		s ^CacheTemp("GetUserTemplateJson",key,oTitleCode,"Flag",result.Data("oCode"))= count
	}


	//循环取可重复模板数据
	s titleCode = ""
	for
	{
		s titleCode = $o(^CacheTemp("GetUserTemplateJson",key,titleCode))
		q:(titleCode = "")
		continue:(titleCode = "ZZNONE")
		s rowId = "title" + titleCode
		s titleID = $o(^DHCEMRM.TitlesI("IdxCode"," "_titleCode,""))
		continue:(titleID = "")
		s obj = ##Class(EMRmeta.Titles).%OpenId(titleID)
		continue:(obj = "")
		s name = obj.Description
		continue:(name = "")
		q:(resultID '="")
	
		s seq = ""
		s count = 0
		for
		{
			s seq = $o(^CacheTemp("GetUserTemplateJson",key,titleCode,seq))
			q:(seq = "Flag")||(seq = "")
			s isUniversal = $li(^CacheTemp("GetUserTemplateJson",key,titleCode,seq),6) 
			s:((resultID = "")||(isUniversal = "全院通用")) resultID = $li(^CacheTemp("GetUserTemplateJson",key,titleCode,seq),1)
			q:(isUniversal = "全院通用")
		}
	}
	
	//循环取唯一模板数据
	s seq = ""
	s titleCode = "ZZNONE"
	for
	{
		s seq = $o(^CacheTemp("GetUserTemplateJson",key,titleCode,seq))
		q:(seq = "Flag")||(seq = "")
		s isUniversal = $li(^CacheTemp("GetUserTemplateJson",key,titleCode,seq),6) 
		s:((resultID = "")||(isUniversal = "全院通用")) resultID = $li(^CacheTemp("GetUserTemplateJson",key,titleCode,seq),1)
		q:(isUniversal = "全院通用")	
	}
	
	k ^CacheTemp("GetUserTemplateJson",key)
	q resultID
}

/// Desc:       将科室模板按照用户使用频率排序
/// Creator:    董璐璐
/// CreateDate: 2019-5-27	
/// Input:      key 缓存Global索引
/// Output:     resultID String
/// Debug:      d ##Class(EMRservice.BL.BLUserTemplate).SortUserTemplateByFrequency(1)
ClassMethod SortUserTemplateByFrequency(key As %String) As %String
{
	s ind = 1
	s titleSeq = ""
	for
	{
		s titleSeq = $o(^CacheTemp("GetUserTemplateFreq",key,titleSeq))
		q:(titleSeq = "")
		s templateID = ""
		for
		{
			s templateID = $o(^CacheTemp("GetUserTemplateFreq",key,titleSeq,templateID))
			q:(templateID = "")
			s frequency = ""
			for
			{
				s frequency = $o(^CacheTemp("GetUserTemplateFreq",key,titleSeq,templateID,frequency),-1)
				q:(frequency = "")
				s seq = ""
				for
				{
					s seq = $o(^CacheTemp("GetUserTemplateFreq",key,titleSeq,templateID,frequency,seq))
					q:(seq = "")
					
					s ^CacheTemp("GetUserTemplateJson",key,titleSeq,ind) = ^CacheTemp("GetUserTemplateFreq",key,titleSeq,templateID,frequency,seq)
					s oCode = ^CacheTemp("GetUserTemplateFreq",key,titleSeq,templateID,frequency,seq,"Flag")
					s ^CacheTemp("GetUserTemplateJson",key,titleSeq,"Flag",oCode)= ind
					s ind = ind + 1			
				}	
			}
		}	
	}
	k ^CacheTemp("GetUserTemplateFreq",key)
}

/// Desc:       取默认加载标题的默认排序第一的科室模板ID及信息
/// Creator:    DongLulu
/// CreateDate: 2021-11-16
/// Input:      pTitleCode 默认加载的TitleCode
///             pLocID 科室ID 
///             pDocID 目录展现结构ID
///             pEpisodeID 就诊ID
/// Output:     
/// Debug:      w ##Class(EMRservice.BL.BLUserTemplate).GetFirstUserTemplateInfoByTitle("EMR100001",79,66,71,"")
ClassMethod GetFirstUserTemplateInfoByTitle(pTitleCode As %String, pLocID As %String, pDocID As %String, pEpisodeID As %String, pText As %String = "", pDiseaseCodeAndName As %String = "") As %String
{
	s resultID = ""
	s result = ""
	s ret = ""
	q:((pTitleCode = "")||(pDocID = "")) ret
	
	s titleCode = $zcvt(pTitleCode,"U")
	s titleID = $o(^DHCEMRM.TitlesI("IdxCode"," "_titleCode,""))
	q:(titleID = "") ret
	s obj = ##Class(EMRmeta.Titles).%OpenId(titleID)
	q:(obj = "") ret
	s name = obj.Description
	q:(name = "") ret
	
	s result = ##class(%ResultSet).%New("EMRservice.BL.BLUserTemplate:GetUserTemplate")
	d result.Execute(pLocID,pDocID,pEpisodeID,pText,pDiseaseCodeAndName)
	s key = $i(^CacheTemp("GetUserTemplateJson"))
	s count = 0
	s oTitleCode = "ZZNONE"
	while result.%Next()
	{
		s count = count + 1
		s data = $lb(result.Data("oCode"),result.Data("oName"),result.Data("oSimpleSpel"),result.Data("oTemplateID"),result.Data("oTitleCode"),result.Data("oType"),result.Data("ID"))
		s oTitleCode = result.Data("oTitleCode")
		s:(oTitleCode = "") oTitleCode = "ZZNONE"
		s ^CacheTemp("GetUserTemplateJson",key,oTitleCode,count) = data
		s ^CacheTemp("GetUserTemplateJson",key,oTitleCode,"Flag",result.Data("oCode"))= count
	}
	
	s seq = ""
	for
	{
		s seq = $o(^CacheTemp("GetUserTemplateJson",key,titleCode,seq))
		q:(seq = "Flag")||(seq = "")
		s isUniversal = $li(^CacheTemp("GetUserTemplateJson",key,titleCode,seq),6) 
		s:((resultID = "")||(isUniversal = "全院通用")) resultID = $li(^CacheTemp("GetUserTemplateJson",key,titleCode,seq),1)
		q:(isUniversal = "全院通用")
		q:(resultID '= "")
	}
	
	k ^CacheTemp("GetUserTemplateJson",key)
	
	s date = $zd($p($h,",",1),3)
	s time = $zt($p($h,",",2))
	s dateTime = date_" "_time
	
	q:(resultID = "") ret
	s result = "{"
	s result=result_"""code"":"""_resultID_""""
	s result=result_",""titleCode"":"""_pTitleCode_""""
	s result=result_",""titleName"":"""_name_""""
	s result=result_",""dateTime"":"""_dateTime_""""
	s result=result_"}"
	s ret = result
	q ret
}

}
