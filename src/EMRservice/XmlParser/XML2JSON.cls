Class EMRservice.XmlParser.XML2JSON Extends %RegisteredObject [ ProcedureBlock ]
{

/// Desc:	获取病历模板数据中患者签名单元列表
/// Debug:	w ##Class(EMRservice.XmlParser.XML2JSON).GetTplSignInfoJson("557","7")
ClassMethod GetTplSignInfoJson(ATemplateID As %String, AVersion As %String, AShowKeyWordConfig As %Boolean = "0") As %String
{
	//b "s"
	
	s result = "[]"
	
	s streamMetaData = ..GetMetaData(ATemplateID, AVersion)
	s sc = ##class(%XML.TextReader).ParseStream(streamMetaData,.reader)
    q:($$$ISERR(sc)) result
    
    s MetaData = ##Class(EMRservice.XmlParser.NIMetaData).%New()
    d MetaData.XMLDeserialize(reader)
    
    s signList = ..GetPatSignItemList(MetaData)
    q:(signList = "") result
    
    if (AShowKeyWordConfig = 0)
    {
	    s result = "["
	    s count = $LL(signList)
	    for i = 1:1:count
	    {
		    s val = $lg(signList,i)
		    s name = $p(val,"^",1)
		    s path = $p(val,"^",2)
		    s:(i > 1) result = result_","
		    s result = result_"{""displayName"":"""_name_""",""path"":"""_path_"""}"
	    }
	    s result = result_"]"
	    q result
    }
    
    s sortJson = ##Class(EMRservice.BL.BLPatSignOrder).GetPatSignOrderJson(ATemplateID,AVersion)
    if (sortJson '= "")
    {
	    s signList = ..ResortItem(signList, sortJson)
    }
    
    s result = "["
    s count = $LL(signList)
    for i = 1:1:count
    {
	    s val = $lg(signList,i)
	    s name = $p(val,"^",1)
	    s path = $p(val,"^",2)
	    s type = $p(val,"^",3)
	    s signertype = $p(val,"^",4)
	    s:(i > 1) result = result_","
	    s result = result_"{""displayName"":"""_name_""",""path"":"""_path_""",""keyWordType"":"""_type_""",""signerType"":"""_signertype_"""}"
    }
    s result = result_"]"
    q result
}

/// Desc:	获取病历实例数据中患者签名单元列表
/// Debug：	w ##Class(EMRservice.XmlParser.XML2JSON).GetMetaSignInfoJson("286003||2")
ClassMethod GetMetaSignInfoJson(AInstanceID As %String) As %String
{
	s result = "{""instanceID"":"""_AInstanceID_""",""MIString"":[]}"
	
	s tplID = "", tplVersion = ""
	s streamMetaData = ..GetDocumentMetaData(AInstanceID, .tplID, .tplVersion)
	 
	s sc = ##class(%XML.TextReader).ParseStream(streamMetaData,.reader)
    q:($$$ISERR(sc)) result
    
    s MetaData = ##Class(EMRservice.XmlParser.NIMetaData).%New()
    d MetaData.XMLDeserialize(reader)
    
    s signList = ..GetPatSignItemList(MetaData)
    q:(signList = "") result
    
    //b "s"
    
    s sortJson = ##Class(EMRservice.BL.BLPatSignOrder).GetPatSignOrderJson(tplID,tplVersion)
    if (sortJson '= "")
    {
	    s signList = ..ResortItem(signList, sortJson)
    }
    
    s result = "{""instanceID"":"""_AInstanceID_""",""MIString"":["
    s count = $LL(signList)
    for i = 1:1:count
    {
	    s val = $lg(signList,i)
	    s name = $p(val,"^",1)
	    s path = $p(val,"^",2)
	    s type = $p(val,"^",3)
	    s signertype = $p(val,"^",4)
	    s:(i > 1) result = result_","
	    s result = result_"{""displayName"":"""_name_""",""path"":"""_path_""",""keyWordType"":"""_type_""",""signerType"":"""_signertype_"""}"
    }
    s result = result_"]}"
    q result
}

/// Desc:	获取病历实例数据中患者签名单元列表
/// Debug：	w ##Class(EMRservice.XmlParser.XML2JSON).GetDocSignInfoJson("13726384||28")
ClassMethod GetDocSignInfoJson(AInstanceID As %String, ByRef ASignItemCount As %Integer = 0) As %String
{
	s ASignItemCount = 0
	
	s result = "{""instanceID"":"""_AInstanceID_""",""MIString"":[]}"
	
	s tplID = "", tplVersion = ""
	s streamMetaData = ..GetDocumentMetaData(AInstanceID, .tplID, .tplVersion)
	
	s sc = ##class(%XML.TextReader).ParseStream(streamMetaData,.reader)
    q:($$$ISERR(sc)) result
    
    s MetaData = ##Class(EMRservice.XmlParser.NIMetaData).%New()
    d MetaData.XMLDeserialize(reader)
    
    s signList = ..GetDocSignItemList(MetaData)
    q:(signList = "") result
   	
    s result = "{""instanceID"":"""_AInstanceID_""",""MIString"":["
    s count = $LL(signList)
    for i = 1:1:count
    {
	    s val = $lg(signList,i)
	    s name = $p(val,"^",1)
	    s path = $p(val,"^",2)
	    s:(i > 1) result = result_","
	    s result = result_"{""displayName"":"""_name_""",""path"":"""_path_"""}"
    }
    s result = result_"]}"
    
    s ASignItemCount = count
    q result
}

/// Desc:       取所选模板的metadata数据
/// Modify:     
/// DateTime:   2020-03-27
/// InPut:      TemplateID  所选病历的TemplateID  
/// OutPut:     result  所选病历的metadata数据流  
/// CopyFrom：	w ##Class(EMRservice.BL.BLBindQuery).GetMetaData(9).Read()
ClassMethod GetMetaData(ATemplateID As %String, AVersion As %String = "") As %GlobalBinaryStream
{
	s result = ##Class(%GlobalBinaryStream).%New()
	q:(ATemplateID = "") result
	s objTempalte = ##Class(EMRmeta.Template).%OpenId(ATemplateID)
	q:(objTempalte = "") result
	//取病历的最新发布版本ID
	if (AVersion = "")
	{	s VersionNumber = objTempalte.PublishVersion}
	else
	{	s VersionNumber = AVersion}
	
	s templateVersionId = $o(^DHCEMRM.TemplateVersionI("IndexTemplateVersion"," "_ATemplateID,VersionNumber,""))
	q:(templateVersionId = "") result
	s objTemplateVersion = ##Class(EMRmeta.TemplateVersion).%OpenId(templateVersionId)
	q:(objTemplateVersion = "") result
	//取最新发布病历版本的MetaData
	s metaStream = objTemplateVersion.MetaData
	/*
	while (metaStream.AtEnd = 0)
	{
		d result.Write($ZCONVERT(metaStream.Read(32000),"I","UTF8"))
	}*/
	d result.CopyFrom(objTemplateVersion.MetaData)
	q result
}

/// CopyFrom：	##Class(EMRservice.BOTemplate).GetDocument
/// 				%FileBinaryStream    %GlobalBinaryStream
ClassMethod GetDocumentMetaData(AInstanceID As %String, ByRef ATemplateID As %String, ByRef ATemplateVersion As %String) As %GlobalBinaryStream [ WebMethod ]
{
	//b "s"
	
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceID) 
	q:(objInstance = "") ""
		
	s ATemplateID = ..GetRealTemplateID(objInstance)
	s ATemplateVersion = objInstance.TemplateVersion
	
	s isExist = ##class(%Dictionary.CompiledProperty).%ExistsId("EMRinstance.InstanceData||IsEncrypt")
	if (isExist = "1")&&(objInstance.IsEncrypt = "1")
	{
		//如果数据已被加密，则取病历模板Meta数据
		q ..GetMetaData(ATemplateID, ATemplateVersion)
	}
    elseif (##class(EMRservice.BL.BLInstanceDataCompressInfo).GetIsCompressByInstanceID(AInstanceID) = "TRUE")
	{
		//如果数据已被压缩，则取病历模板Meta数据
		q ..GetMetaData(ATemplateID, ATemplateVersion)
	}
    elseif (##class(EMRservice.BL.BLInstanceDataCompressInfo).GetIsBKCompressByInstanceID(AInstanceID) = "1")
	{
		//如果数据已被压缩，则取病历模板Meta数据
		q ..GetMetaData(ATemplateID, ATemplateVersion)
	}
	else
	{	
		s ret = ##Class(%GlobalBinaryStream).%New()
		d ret.CopyFrom(objInstance.InstanceMetaData)
		q ret
	}
}

/// Desc:	获取Meta数据中的患者签名单元列表
ClassMethod GetPatSignItemList(AMetaData) As %List
{
	s ret = ""
	
	s count = AMetaData.Sections.Count()
	//w !,"- sectionCount:"_count	//debug
	for i=1:1:count
	{
		s sctionCode = $zcvt(AMetaData.Sections.GetAt(i).Code,"U")
		s ccount = AMetaData.Sections.GetAt(i).Composites.Count()
		//w !,"-- compsiteCount:"_ccount 	//debug
		
		for j=1:1:ccount
		{
			s compsiteCode = $zcvt(AMetaData.Sections.GetAt(i).Composites.GetAt(j).Code,"U")
			s scount = AMetaData.Sections.GetAt(i).Composites.GetAt(j).SubItems.Count()
			//w !,"--- subitemCount:"_scount	//debug
			
			for k=1:1:scount
			{
				if (AMetaData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).CompositeConcept '= ""){
					s conceptCode = $zcvt(AMetaData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).CompositeConcept.Code,"U")
					s ccscount = AMetaData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).CompositeConcept.SubItems.Count()
					//w !,"---- conceptCount:"_ccscount	//debug
			
				    for l=1:1:ccscount
				    {
					    try {
						    s subItm = AMetaData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).CompositeConcept.SubItems.GetAt(l)
							s conceptSimpleCode = $zcvt(subItm.Code,"U")
							if (subItm.Type="MIString") {
								s sLevel  = subItm.SignatureLevel
								s dpName  = subItm.DisplayName
								s path    = sctionCode_"_"_compsiteCode_"_"_conceptCode_"_"_conceptSimpleCode
								if ($ZCVT(sLevel,"U") = "PATIENT") 
								{
									s ret = ret_$lb(dpName_"^"_path)
									s JsonCount = JsonCount+1
								}
							}
						} catch {}
					}
				} else {
					s subItm = AMetaData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k)
					s compositeSimpleCode = $zcvt(subItm.Code,"U")
					continue:(""=compositeSimpleCode)
					//w !,"---- compositeSimpleCode:"_compositeSimpleCode
					
					try {
						if (subItm.Type="MIString") {
							s sLevel  = subItm.SignatureLevel
							s dpName  = subItm.DisplayName
							s path    = sctionCode_"_"_compsiteCode_"_"_compositeSimpleCode
							//w !,"---- MIString:"_dpName
							if ($ZCVT(sLevel,"U") = "PATIENT") 
							{
								s ret = ret_$lb(dpName_"^"_path)
								s JsonCount = JsonCount+1
							}
						}
					} catch {}
				}
			}
		}
	}
	
	q ret
}

/// Desc:	患者签名单元列表排序
ClassMethod ResortItem(inputList As %List, sortJson) As %List
{
	q:(inputList = "") inputList
	q:(sortJson = "") inputList
	
	//b "s"
	//患者签名关键字顺序基础数据解析为List
	s sortList = "",typeList = ""
	s json = ##class(EMRservice.Util.Json).FromJson("{""arr"":"_sortJson_"}")
	s arr = json.GetAt("arr")
	s key = ""
	for {
		s value = arr.GetNext(.key)
		q:(key = "")
		
		s val = value.GetAt("displayName")
		s type =  value.GetAt("keyWordType")
		s signerType =  value.GetAt("signerType")
		
		s sortList = sortList_$lb(val)
		s typeList = typeList_$lb(type_"^"_signerType)
	}
	
	//排序
	s arr1 = ##class(%ArrayOfDataTypes).%New()
	s arr2 = ##class(%ArrayOfDataTypes).%New()
	s count = $LL(inputList)
	for i = 1:1:count
	{
		s val = $lg(inputList,i)
		s name = $p(val,"^",1)
		s seq = $listfind(sortList,name)
		if (seq > "0")
		{	
			s tval = val_"^"_$lg(typeList,seq)
			d arr1.SetAt(tval,seq)
			s $list(sortList,seq) = ""   //防止重名的单元被吃掉
		}
		else
		{	
			s tval = val_"^"
			d arr2.SetAt(tval,i)
		}
	}
	
	//排序后数据输出为List
	s ret = ""
	s key = ""
	for {
		s val = arr1.GetNext(.key)
		q:(key = "")
		s ret = ret_$lb(val)
	}
	s key = ""
	for {
		s val = arr2.GetNext(.key)
		q:(key = "")
		s ret = ret_$lb(val)
	}
	
	q ret
}

/// w ##Class(EMRservice.XmlParser.XML2JSON).GetBindCodeArray(metaStream, "0")
ClassMethod GetBindCodeArray(AMetaDataStream As %Stream, AIsAllPath As %String = "0") As %ArrayOfDataTypes
{
	s ret = ##class(%ArrayOfDataTypes).%New()
	
	s count = AMetaData.Sections.Count()
	//w !,"- sectionCount:"_count	//debug
	for i=1:1:count
	{
		s sctionCode = $zcvt(AMetaData.Sections.GetAt(i).Code,"U")
		s ccount = AMetaData.Sections.GetAt(i).Composites.Count()
		//w !,"-- compsiteCount:"_ccount 	//debug
		
		for j=1:1:ccount
		{
			s compsiteCode = $zcvt(AMetaData.Sections.GetAt(i).Composites.GetAt(j).Code,"U")
			s scount = AMetaData.Sections.GetAt(i).Composites.GetAt(j).SubItems.Count()
			//w !,"--- subitemCount:"_scount	//debug
			
			for k=1:1:scount
			{
				if (AMetaData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).CompositeConcept '= ""){
					s conceptCode = $zcvt(AMetaData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).CompositeConcept.Code,"U")
					s ccscount = AMetaData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).CompositeConcept.SubItems.Count()
					//w !,"---- conceptCount:"_ccscount	//debug
			
				    for l=1:1:ccscount
				    {
					    try {
						    s subItm = AMetaData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).CompositeConcept.SubItems.GetAt(l)
							s conceptSimpleCode = $zcvt(subItm.Code,"U")
							if (subItm.Type="MIString")||(subItm.Type="MIMonoChoice") {
								s bindCode = subItm.BindCode
								if (bindCode '= "") {
									if (AIsAllPath = "1") {
										s path = sctionCode_"_"_compsiteCode_"_"_conceptCode_"_"_conceptSimpleCode
									} else {
										s path = conceptSimpleCode
									}
									d ret.SetAt(bindCode, path)
								}
							}
						} catch {}
					}
				} else {
					s subItm = AMetaData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k)
					s compositeSimpleCode = $zcvt(subItm.Code,"U")
					continue:(""=compositeSimpleCode)
					//w !,"---- compositeSimpleCode:"_compositeSimpleCode
					
					try {
						if (subItm.Type="MIString")||(subItm.Type="MIMonoChoice") {
							s bindCode = subItm.BindCode
							if (bindCode '= "") {
								if (AIsAllPath = "1") {
									s path = sctionCode_"_"_compsiteCode_"_"_compositeSimpleCode
								} else {
									s path = compositeSimpleCode
								}
								d ret.SetAt(bindCode, path)
							}
						}
					} catch {}
				}
			}
		}
	}
	
	q ret
}

/// Desc:	获取Meta数据中的医护签名单元列表
ClassMethod GetDocSignItemList(AMetaData) As %List
{
	s ret = ""
	
	s count = AMetaData.Sections.Count()
	//w !,"- sectionCount:"_count	//debug
	for i=1:1:count
	{
		s sctionCode = $zcvt(AMetaData.Sections.GetAt(i).Code,"U")
		s ccount = AMetaData.Sections.GetAt(i).Composites.Count()
		//w !,"-- compsiteCount:"_ccount 	//debug
		
		for j=1:1:ccount
		{
			s compsiteCode = $zcvt(AMetaData.Sections.GetAt(i).Composites.GetAt(j).Code,"U")
			s scount = AMetaData.Sections.GetAt(i).Composites.GetAt(j).SubItems.Count()
			//w !,"--- subitemCount:"_scount	//debug
			
			for k=1:1:scount
			{
				if (AMetaData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).CompositeConcept '= ""){
					s conceptCode = $zcvt(AMetaData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).CompositeConcept.Code,"U")
					s ccscount = AMetaData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).CompositeConcept.SubItems.Count()
					//w !,"---- conceptCount:"_ccscount	//debug
			
				    for l=1:1:ccscount
				    {
					    try {
						    s subItm = AMetaData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).CompositeConcept.SubItems.GetAt(l)
							s conceptSimpleCode = $zcvt(subItm.Code,"U")
							if (subItm.Type="MIString") {
								s sLevel  = subItm.SignatureLevel
								s dpName  = subItm.DisplayName
								s path    = sctionCode_"_"_compsiteCode_"_"_conceptCode_"_"_conceptSimpleCode
								if (..IsDocSign($ZCVT(sLevel,"U")))  
								{
									b
									s ret = ret_$lb(dpName_"^"_path)
									s JsonCount = JsonCount+1
								}
							}
						} catch {}
					}
				} else {
					s subItm = AMetaData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k)
					s compositeSimpleCode = $zcvt(subItm.Code,"U")
					continue:(""=compositeSimpleCode)
					//w !,"---- compositeSimpleCode:"_compositeSimpleCode
					
					try {
						if (subItm.Type="MIString") {
							s sLevel  = subItm.SignatureLevel
							s dpName  = subItm.DisplayName
							s path    = sctionCode_"_"_compsiteCode_"_"_compositeSimpleCode
							//w !,"---- MIString:"_dpName
							if (..IsDocSign($ZCVT(sLevel,"U")))  
							{
								b
								s ret = ret_$lb(dpName_"^"_path)
								s JsonCount = JsonCount+1
							}
						}
					} catch {}
				}
			}
		}
	}
	
	q ret
}

ClassMethod IsDocSign(level) As %String
{
	q:(level = "") "0"
	q:(level = "NONE") "0"
	q:(level = "PATIENT") "0"
	q:(level = "NOTATION") "0"
	q "1"
}

ClassMethod GetRealEpisodeID(obj As EMRinstance.InstanceData) As %String
{
	q:(obj = "") ""
	q:(obj.EpisodeID = "") ""
	q:($isobject(obj.EpisodeID)) obj.EpisodeID.%Id()
	q obj.EpisodeID
}

ClassMethod GetRealTemplateID(obj As EMRinstance.InstanceData) As %String
{
	q:(obj = "") ""
	q:(obj.TemplateID = "") ""
	q:($isobject(obj.TemplateID)) obj.TemplateID.%Id()
	q obj.TemplateID
}

}
