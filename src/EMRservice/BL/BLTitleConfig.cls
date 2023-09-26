/// Desc:      标题配置
/// Creator:   Candy
/// CreateDate:2013-3-31
Class EMRservice.BL.BLTitleConfig Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:      取标题配置项
/// Creator:   Candy
/// Createdate:2013-3-31
/// Input:  ACategoryID TempCate的parentId
/// Output: <Titles><Title><!--文档类型，索引标识--><Code>T001</Code><!--文档标题--><Desc>主治医师查房记录</Desc><!--标题第一项--><Col1  Type="Title" ReadOnly="True/False" Format="" LineBreak="True/False"></Col1><!--标题第二项，日期格式--><Col2 Type="DateTime" ReadOnly="True/False" Format="yyyy-mm-dd HH:MM:SS" LineBreak ="True/False"></Col2><!--是否另起一页--><PageBreak>True</PageBreak></Title></Titles>
/// debug： w ##Class(EMRservice.BL.BLTitleConfig).GetTitleConfig(103)
ClassMethod GetTitleConfig(ADocID As %String, ALocID As %String = "", AEpisodeID As %String, ASsgorupID As %String) As %GlobalBinaryStream
{
	s stream = ##Class(%GlobalBinaryStream).%New()
	d stream.Write("<TitleConfig>")
	d stream.CopyFrom(..GetCategorys())
	d stream.CopyFrom(..GetTitles(ADocID,ALocID))
	d stream.CopyFrom(##Class(EMRservice.BL.BLPowerUser).GetSuperiorDoctors(ALocID))
	d stream.CopyFrom(##Class(EMRservice.BL.Event.BLOperation).GetDataToXml(AEpisodeID))
	d stream.Write("</TitleConfig>")
	q stream
}

/// Desc:		取标题目录及属性
/// Creator:		Candy
/// CreateDate:	2016-2-18
/// debug： w ##Class(EMRservice.BL.BLTitleConfig).GetCategorys()
ClassMethod GetCategorys() As %GlobalBinaryStream
{
	s stream = ##Class(%GlobalBinaryStream).%New()
	d stream.Write("<Categorys>")
	s rowId = ""
	s strSeq = ""
	for 
	{
		s strSeq = $o(^DHCEMRM.TitleCategoryI("IdxSequence",strSeq))
		q:(strSeq = "")
		s rowId = $o(^DHCEMRM.TitleCategoryI("IdxSequence",strSeq,""))
		q:(rowId = "")
		s obj = ##Class(EMRmeta.TitleCategory).%OpenId(rowId)
		continue:(obj = "")
		s obj.TitleCategoryType=$case(obj.TitleCategoryType,$c(0):"",:obj.TitleCategoryType)		
		s obj.TitleCategoryName=$case(obj.TitleCategoryName,$c(0):"",:obj.TitleCategoryName)		
		d stream.Write("<Category>")
		d stream.Write("<Type>"_obj.TitleCategoryType_"</Type>")
		d stream.Write("<Name>"_$ZCVT(obj.TitleCategoryName,"O","UTF8")_"</Name>")
		s propty = obj.PropertyParams		
		if ((propty'="")&&(propty'=$c(0)))	
		{	
		  for i=1:1:$l(propty,",")
		  {
			s pname = $p($p(propty,",",i),":",1)
			s pvalue = $p($p(propty,",",i),":",2)		
			d stream.Write("<"_pname_">"_pvalue_"</"_pname_">")
		  }
		}
		d stream.Write("</Category>")
	}		
	d stream.Write("</Categorys>")	
	q stream
}

/// Desc:		取标题及属性配置
/// Creator:		Candy
/// CreateDate:	2016-2-18
ClassMethod GetTitles(ADocID As %String, ALocID As %String = "") As %GlobalBinaryStream
{
	s stream = ##Class(%GlobalBinaryStream).%New()
	q:(ADocID = "") stream
	s objEmrTempalteCategory = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(ADocID)
	q:(objEmrTempalteCategory = "") stream
	s CategoryID = objEmrTempalteCategory.ParentCategoryID
	q:(CategoryID = "") stream
	d stream.Write("<Titles>")
	s sequence = ""
	for
	{ 
		s sequence = $o(^DHCEMRM.TitleConfigI("IdxCategorySequence"," "_CategoryID,sequence))
		q:(sequence = "")
		s rowID = ""
		for
		{
			s rowID = $o(^DHCEMRM.TitleConfigI("IdxCategorySequence"," "_CategoryID,sequence,rowID))
			q:(rowID = "")
			s obj = ##Class(EMRmeta.TitleConfig).%OpenId(rowID)
			q:(obj = "")
			s titleCode = obj.TitleCode
			s titleRowID = ""
			s:(titleCode '= "") titleRowID = $o(^DHCEMRM.TitlesI("IdxCode"," "_titleCode,""))
			continue:(titleRowID = "")
			s titleObj = ##Class(EMRmeta.Titles).%OpenId(titleRowID)
			continue:(titleObj = "")
			continue:(($d(^DHCEMRM.TitleLocI("IdxCTLocIDTitleID"," "_titleRowID))>0)&&($d(^DHCEMRM.TitleLocI("IdxCTLocIDTitleID"," "_titleRowID," "_ALocID))<=0))
			s titleDesc = $ZCVT(titleObj.Description,"O","UTF8")
			s titleAlias = $ZCVT(titleObj.Alias,"O","UTF8")
			s pageBreak = obj.PageBreak
			s PageNextBreak = $Case(obj.PageNextBreak,"":"False",:obj.PageNextBreak)
			s autoLoad = obj.AutoLoad			
			s groupId = obj.GroupID
			s uniqueCreate = obj.UniqueCreate
			s objGroup = ##Class(EMRmeta.TitleCategory).%OpenId(groupId)
			s groupName = $Case(objGroup,"":"",:$zcvt(objGroup.TitleCategoryName,"O","UTF8"))
			s groupType= objGroup.TitleCategoryType
			d stream.Write("<Title>")
			d stream.Write("<Code>"_titleCode_"</Code>") 
			d stream.Write("<Alias>"_titleAlias_"</Alias>")
			d stream.Write("<Description>"_titleDesc_"</Description>")
			s seqNum = ""
			s count = 1
			for
			{
				s seqNum = $o(^DHCEMRM.TitleColConfigI("IdxTitleConfigVisibleSeqNum",rowID," TRUE",seqNum))
				q:((seqNum="")||(count >2))
				s subId = $o(^DHCEMRM.TitleColConfigI("IdxTitleConfigVisibleSeqNum",rowID," TRUE",seqNum,""))
				s id = rowID_"||"_subId
				s objCol = ##Class(EMRmeta.TitleColConfig).%OpenId(id)
				continue:(objCol = "")
				s colType =objCol.Type,colReadOnly = objCol.ReadOnly,colFormat = $zcvt(objCol.Format,"O","UTF8"),colLineBreak = objCol.LineBreak, align = $case(objCol.Align,"":"Left",:objCol.Align),colFontStyle = $zcvt(objCol.FontStyle,"O","UTF8"),colParams = $zcvt(objCol.Params,"O","UTF8")
		        if (count = 1)
		        {
			       	d stream.Write("<FirstColType Align="""_align_""" Type="""_colType_""" ReadOnly="""_colReadOnly_""" Format="""_colFormat_""" LineBreak="""_colLineBreak_""" FontStyle="""_colFontStyle_""" Params="""_colParams_"""></FirstColType>") 
			    }elseif(count = 2)
			    {
					d stream.Write("<SecondColType Align="""_align_""" Type="""_colType_""" ReadOnly="""_colReadOnly_""" Format="""_colFormat_""" LineBreak="""_colLineBreak_""" FontStyle="""_colFontStyle_""" Params="""_colParams_"""></SecondColType>")				    
				}
				s count = count + 1	
			}
			d stream.Write("<PageBreak>"_pageBreak_"</PageBreak>")
			d stream.Write("<PageNextBreak>"_PageNextBreak_"</PageNextBreak>")
			d stream.Write("<AutoLoad>"_autoLoad_"</AutoLoad>")	
			d stream.Write("<UniqueCreate>"_uniqueCreate_"</UniqueCreate>")		
			d stream.Write("<CategoryType>"_groupType_"</CategoryType>")	
			d stream.Write("<CategoryName>"_groupName_"</CategoryName>")		
			d stream.Write("</Title>")
		}
    }
    d stream.Write("</Titles>")
    q stream
}

/// Desc:		取可重复模板默认加载的标题code(若该次就诊已保存该titlecode病历，方法返回空)
/// Creator:	Donglulu
/// CreateDate:	2016-9-5
/// Input:  	ADocID TempCate的Id，ALocID 科室ID,AEpisodeID就诊号,ATemplateID 模板ID
/// Output: 	可重复模板默认加载的标题code
/// debug： 	w ##Class(EMRservice.BL.BLTitleConfig).GetDefaultLoadTitleCode(272,95,67)
ClassMethod GetDefaultLoadTitleCode(ADocID As %String, ALocID As %String = "", AEpisodeID As %String = "", ATemplateID As %String = "") As %String
{
	s defaultTitle = ""
	q:(ADocID = "") defaultTitle
	s objEmrTempalteCategory = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(ADocID)
	q:(objEmrTempalteCategory = "") defaultTitle
	s CategoryID = objEmrTempalteCategory.ParentCategoryID
	q:(CategoryID = "") defaultTitle
	s emrTemplateIds = ##class(EMRservice.BL.BLEMRTemplate).GetEMRTemplateIDsByDocID(ADocID)
	s sequence = ""
	for
	{ 
		s sequence = $o(^DHCEMRM.TitleConfigI("IdxCategoryDefaultLoadSequence"," "_CategoryID," TRUE",sequence))
		q:(sequence = "")
		s rowID = ""
		for
		{
			s rowID = $o(^DHCEMRM.TitleConfigI("IdxCategoryDefaultLoadSequence"," "_CategoryID," TRUE",sequence,rowID))
			q:(rowID = "")
			s obj = ##Class(EMRmeta.TitleConfig).%OpenId(rowID)
			q:(obj = "")
			s titleCode = obj.TitleCode
			s titleRowID = ""
			s:(titleCode '= "") titleRowID = $o(^DHCEMRM.TitlesI("IdxCode"," "_titleCode,""))
			continue:(titleRowID = "")
			continue:(($d(^DHCEMRM.TitleLocI("IdxCTLocIDTitleID"," "_titleRowID))>0)&&($d(^DHCEMRM.TitleLocI("IdxCTLocIDTitleID"," "_titleRowID," "_ALocID))<=0))
			if ((titleCode '= "")&&(AEpisodeID '= ""))
			{
				continue:($d(^DHCEMRI.InstanceDataI("IdxEpisodeTitleCodeStatus",AEpisodeID," "_$zcvt(titleCode,"U")," SAVE"))>0)
			}
			//过滤非本DocID下的模板的配置
			if (emrTemplateIds'="")&&(obj.TemplateID'="")
			{
				continue:($f("^"_emrTemplateIds_"^", "^"_obj.TemplateID_"^") = 0)
			}
			s defaultTitle = titleCode
			q:(defaultTitle '= "")
		}
		q:(defaultTitle '= "")
    }
    q defaultTitle
}

/// Desc:         标题列表
/// Creator:      Candy
/// CreateDate:   2015-4-3
/// Input:        ADocID 目录展现结构ID
/// Output:       ACode 代码 ADesc 描述 列表
/// Debug:        do ##class(%ResultSet).RunQuery("EMRservice.BL.BLTitleConfig","GetTitleByDocID","4","6")
Query GetTitleByDocID(ADocID As %String, ACTLocId As %String = "") As %Query(ROWSPEC = "ACode:%String,ADesc:%String")
{
}

ClassMethod GetTitleByDocIDExecute(ByRef qHandle As %Binary, ADocID As %String, ACTLocId As %String = "") As %Status
{
	s repid = $I(^CacheTemp)
	s qHandle = $lb(0,repid,0)
 	s ind = 1
 	q:(ADocID = "") $$$OK
	s objEmrTempalteCategory = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(ADocID)
	q:(objEmrTempalteCategory = "") $$$OK
	s CategoryID = objEmrTempalteCategory.ParentCategoryID
	q:(CategoryID = "") $$$OK
	s sequence = ""
	for
	{ 
		s sequence = $o(^DHCEMRM.TitleConfigI("IdxCategorySequence"," "_CategoryID,sequence))
		q:(sequence = "")
		s rowID = ""
		for
		{
			s rowID = $o(^DHCEMRM.TitleConfigI("IdxCategorySequence"," "_CategoryID,sequence,rowID))
			q:(rowID = "")
			s obj = ##Class(EMRmeta.TitleConfig).%OpenId(rowID)
			q:(obj = "")
			s titleCode = obj.TitleCode
			s titleRowID = ""
			s:(titleCode '= "") titleRowID = $o(^DHCEMRM.TitlesI("IdxCode"," "_titleCode,""))
			continue:(titleRowID = "")
			s titleObj = ##Class(EMRmeta.Titles).%OpenId(titleRowID)
			continue:(titleObj = "")
			continue:(($d(^DHCEMRM.TitleLocI("IdxCTLocIDTitleID"," "_titleRowID))>0)&&($d(^DHCEMRM.TitleLocI("IdxCTLocIDTitleID"," "_titleRowID," "_ACTLocId))<=0))
			s data = $lb(titleObj.Code,titleObj.Description)
			s ^CacheTemp(repid,ind) = data
			s ind=ind+1 
		}
	} 	 
	
	Quit $$$OK
}

ClassMethod GetTitleByDocIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTitleByDocIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetTitleByDocIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTitleByDocIDExecute ]
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

/// Desc:       前台创建病历取标题配置
/// Creator:    Candy
/// CreateDate: 2017-12-8
/// Debug:      w ##Class(EMRservice.BL.BLTitleConfig).GetTitleConfigByCode(66,"EMR100003",4)
ClassMethod GetTitleConfigByCode(qDocID As %String, qCode As %String, qEpisodeID As %String = "") As %String
{
	s json = ""
	q:(qDocID = "")||(qCode = "") json
	s objEmrTempalteCategory = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(qDocID)
	q:(objEmrTempalteCategory = "") json
	s categoryId = objEmrTempalteCategory.ParentCategoryID
	s rowId = $o(^DHCEMRM.TitleConfigI("IdxCategoryTitleCode"," "_categoryId," "_$zcvt(qCode,"U"),""))
	q:(rowId = "") json
	s obj = ##Class(EMRmeta.TitleConfig).%OpenId(rowId)
	q:(obj = "") json
	s titleRowId = $o(^DHCEMRM.TitlesI("IdxCode"," "_$zcvt(qCode,"U"),""))
	q:(titleRowId = "") json
	s objTitle = ##Class(EMRmeta.Titles).%OpenId(titleRowId)
	q:(objTitle = "") json
	s json = json_"{"
	s json = json_"""Code"":"""_objTitle.Code_""""
	s json = json_",""Title"":"""_objTitle.Description_""""
	s json = json_",""DateTime"":"""_$zd($p($h,",",1),3)_" "_$zt($p($h,",",2))_""""
	s json = json_",""DefaultLoad"":"""_obj.DefaultLoad_""""
	s cjson = ""
	s colId = ""
	for
	{
		s colId = $o(^DHCEMRM.TitleColConfigI("IdxTitleConfig",rowId,colId))
		q:(colId = "")
		s objCol = ##Class(EMRmeta.TitleColConfig).%OpenId(rowId_"||"_colId)
		continue:(objCol = "")
		s:(cjson '= "") cjson = cjson_","
		s cjson = cjson_"{"
		s cjson = cjson_"""ReadOnly"":"""_objCol.ReadOnly_""""
		s cjson = cjson_",""Type"":"""_objCol.Type_""""
		s cjson = cjson_",""Format"":"""_objCol.Format_""""
		s cjson = cjson_",""Params"":"""_objCol.Params_""""
		s cjson = cjson_",""Visible"":"""_$zcvt(objCol.Visible,"U")_""""
		s cjson = cjson_"}"
	}
	
	s eventConfig = ""
	s eventData = ""
	s linkEvent = ##Class(EMRservice.BL.BLTitleLinkEvent).GetEventCodeByTitle(qCode)
	if (linkEvent '= "")
	{
		s eventConfig = ##Class(EMRservice.BL.Event.BLEventConfig).GetEventScheme(linkEvent)
		s eventData = ##Class(EMRservice.BL.Event.BLEvents).GetData(linkEvent,qEpisodeID)
	}
	
	s json = json_",""Config"":["_cjson_"]"
	s json = json_",""EventType"":"""_linkEvent_""""
	s json = json_",""EventConfig"":"""_eventConfig_""""
	s json = json_",""EventData"":["_eventData_"]"
	s json = json_"}"
	q json
}

/// Desc:        判断是所写病程时间是否小于首次病程时间
/// Creator:     CandyXu
/// CreateDaate: 2018-1-29
/// Input:       qEpisodeID 就诊号
///             qDocID     病历分类ID(目录展现结构第三层)
///             qTitleCode 所写病历ID
///             qDateTime  所写病历发生时间
/// Output:      result     1 可写   0 不可写  
/// Debug:       w ##Class(EMRservice.BL.BLTitleConfig).CanCreateTitle(130,66,"EMR100002","2019-02-19 10:01:20")
ClassMethod CanCreateTitle(qEpisodeID As %String, qDocID As %String, qTitleCode As %String, qDateTime As %String) As %String
{
	s result = 1
	q:(qDocID = "")||(qTitleCode = "")||(qDateTime = "") result
	s titleTimeConfigAll = ##Class(EMRservice.SystemParameter).GetFirstRecordConfig()
	s quitFlag=1
	for i=1:1:$l(titleTimeConfigAll,"#")
	{
		s titleTimeConfig = $p(titleTimeConfigAll,"#",i)
		continue:(titleTimeConfig = "")
		s tmpDocId = $P($p(titleTimeConfig,",",1),":",2)
		s tmpFisrtTitleCode = $P($p(titleTimeConfig,",",2),":",2)
		
		continue:(qDocID '= tmpDocId) 
		continue:(qTitleCode = tmpFisrtTitleCode) 
	s ecrecordId = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",qEpisodeID,qDocID,""))
	s:(ecrecordId = "") result = "0^请先创建首次病程记录"
		continue:(result '= 1) 
		s fisrtTitleInstanceSubId = $O(^DHCEMRI.InstanceDataI("IdxEpisodeTitleCodeStatus",qEpisodeID," "_tmpFisrtTitleCode," SAVE",ecrecordId,""))
		s:(fisrtTitleInstanceSubId = "") result = "0^请先创建首次病程记录"
		continue:(result '= 1) 
		
		s quitFlag=0
	}
	q:(quitFlag) result
	s rowId = ecrecordId_"||"_fisrtTitleInstanceSubId
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(rowId)
	s:(objInstance = "") result = "0^请先创建首次病程记录"
	q:($p(result,"^",1) '= 1) result
	s qDate = $zdh($p(qDateTime," ",1),3)
	s:(qDate < objInstance.HappenDate) result = "0^病历书写日期不能早于首次病程书写日期"
	q:($p(result,"^",1) '= 1) result
	s qTime =  $zth($p(qDateTime," ",2))
	s:((qDate = objInstance.HappenDate)&&(qTime < objInstance.HappenTime)) result = "0^病历书写时间不能早于首次病程书写时间"
	q result
}

/// Desc:        判断病程时间是否小于入院时间大于出院时间
/// Creator:     CandyXu
/// CreateDaate: 2018-6-5
/// Input:       qEpisodeID 就诊号
///              qDateTime  所写病历发生时间
/// Output:      result     1 可写   0 不可写  
/// Debug:       w ##Class(EMRservice.BL.BLTitleConfig).CanCreateByEpisodeTime(315,"2018-08-13 14:47:54")
ClassMethod CanCreateByEpisodeTime(qEpisodeID As %String, qDateTime As %String, createCode As %String = "") As %String
{
	s result = 1
	s date = $zdh($p(qDateTime," ",1),3)
	s time = $zth($p(qDateTime," ",2))
	s admDateTime = ##class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTime(qEpisodeID)
	s admDate = $p(admDateTime,",",1)
	s:(date < admDate) result = "0^病历书写日期小于入院日期"
	q:($p(result,"^",1) '= 1) result
	s admTime = $p(admDateTime,",",2)
	s:((date = admDate)&&(time < admTime)) result = "0^病历书写时间小于入院时间"
	q:($p(result,"^",1) '= 1) result
	//通过在系统参数中维护病历的titlecode控制医生创建病程记录时，不受出院时间限制
	s flag = ##Class(EMRservice.BL.BLTitleConfig).IsExistTitleCode(createCode)
	q:(flag = "1") result
	s disDateTime = ##Class(EMRservice.HISInterface.PatientInfoAssist).DisDateTime(qEpisodeID)
	q:(disDateTime = "") result
	s disDate = $p(disDateTime,",",1)
	s:(date > disDate ) result = "0^病历书写日期大于出院日期"
	q:($p(result,"^",1) '= 1) result
	s disTime = $p(disDateTime,",",2)
	s:((date = disDate )&&(time > disTime)) result = "0^病历书写时间大于出院时间"
	q result
}

/// Desc:        通过在系统参数中维护病历的titlecode控制医生创建病程记录时，不受出院时间限制
/// Creator:     wangyu
/// CreateDaate: 2021-11-24
/// Input:       
/// Output:      1 可写   0 不可写 
/// w ##Class(EMRservice.BL.BLTitleConfig).IsExistTitleCode("EMR100020")
ClassMethod IsExistTitleCode(createCode As %String) As %String
{
	s result = "0"
	q:(createCode = "") result
	s DocTitleCode = ##class(EMRservice.BL.BLSysOption).GetOptionValueByName("openDocCode")
	if (DocTitleCode = "") q result 
	s arr = [].%FromJSON(DocTitleCode) 
	s DocCode = arr.%GetIterator()
	while DocCode.%GetNext(.key, .value)
	{
		if (value = createCode)
		{
			s result = "1"
		}
	}
	q result
}

/// Desc:        判断病程时间是否在可修改范围内(根据系统参数AllowModifyCreateRange判断)
/// Creator:     Donglulu
/// CreateDaate: 2019-3-25
/// Input:       qDateTime  所写病历发生时间
/// Output:      result     1 可写   0 不可写  
/// Debug:       w ##Class(EMRservice.BL.BLTitleConfig).CheckAllowModifyCreateRange("2019-3-27 10:2:0")
ClassMethod CheckAllowModifyCreateRange(qDateTime As %String) As %String
{
	s result = 1
	s date = $zdh($p(qDateTime," ",1),3)
	s time = $zth($p(qDateTime," ",2))
	s allowModifyCreateRange = ##class(EMRservice.BL.BLSysOption).GetOptionValueByName("AllowModifyCreateRange")
	s before = $p(allowModifyCreateRange,"^",1)
	s after = $p(allowModifyCreateRange,"^",2)
	q:((before = "")&&(after = "")) result
	s start = ##class(EMRservice.BL.BLTitleConfig).GetBeforeDateTime($P($H,",",1),$P($H,",",2),before * 3600)
	s startDate = $P(start,",",1)
	s startTime = $P(start,",",2)
	s end = ##class(EMRservice.Ajax.Appoint).GetEndDateTime($P($H,",",1),$P($H,",",2),after * 3600)
	s endDate = $P(end,",",1)
	s endTime = $P(end,",",2)
	if (date < startDate)
	{
		s result = "0^最多可将时间调整至"_before_"小时前"
	}
	elseif ((date = startDate)&&(time < startTime))
	{
		s result = "0^最多可将时间调整至"_before_"小时前"
	}
	elseif (date > endDate)
	{
		s result = "0^最多可将时间调整至"_after_"小时后"
	}
	elseif ((date = endDate)&&(time > endTime))
	{
		s result = "0^最多可将时间调整至"_after_"小时后"
	}
	q result
}

/// Creator:Donglulu
/// CreatDate:2019-03-27
/// Description:根据起始日期、起始时间、时间间隔(以秒为单位)计算提前于当前时间的日期和时间
/// Table:EPRinstance.EPRActionAppoint
/// Input:startDate-起始日期,startTime-起始时间,timeSpan-时间间隔（提前于当前时间的）
/// Output:
/// Return:截止日期和截止时间,格式为:截止日期,截止时间
/// Others:
/// Debug: w ##class(EMRservice.BL.BLTitleConfig).GetBeforeDateTime($P($H,",",1),$P($H,",",2),36000)
ClassMethod GetBeforeDateTime(startDate As %Date, startTime As %Time, timeSpan As %Integer) As %String
{
	if (timeSpan > startTime)
	{
		s curDate = (timeSpan - startTime)\86400 + 1
		s curTime = curDate*86400 - (timeSpan - startTime)
		q startDate-curDate_","_curTime
	}
	else
	{
		q startDate_","_(startTime-timeSpan)
	}
}

/// Desc:        获取病历的happendatetime，设置修改标题时的时间
/// Creator:     Donglulu
/// CreateDaate: 2020-12-15
/// Input:       AInstanceID  实例ID
/// Output:      result     happendatetime   例："2019-3-27 10:2:0"
/// Debug:       w ##Class(EMRservice.BL.BLTitleConfig).GetHappenDateTime("98||38")
ClassMethod GetHappenDateTime(AInstanceID As %String) As %String
{
	s result = ""
	q:(AInstanceID = "") result
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceID)
	q:(objInstance = "") result
	s happendate = $zd(objInstance.HappenDate,3)
	s happentime = $zt(objInstance.HappenTime)
	s result = happendate_" "_happentime
	q result
}

/// Desc:       根据docID获取标题
/// Creator:    yejian
/// CreateDate: 2022-1-24
/// Input:      aLocID 科室ID 
///             aDocID 目录展现结构ID
/// 			aText 过滤文本
/// 			aUserID 用户ID
/// 			pJson json数据
/// Output:     json Stream
/// Debug:     s stream=##Class(EMRservice.BL.BLTitleConfig).GetTitlesNew("66","","","","","641")
/// d stream.OutputToDevice()
ClassMethod GetTitlesNew(aDocID As %String, aLocID As %String = "", aText As %String = "", aUserID As %String = "", aJson As %String, AEpisodeID As %String = "") As %GlobalBinaryStream
{
	s json = ##Class(%GlobalBinaryStream).%New()
	q:(aDocID = "") json
	s objEmrTempalteCategory = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(aDocID)
	q:(objEmrTempalteCategory = "") json
	s CategoryID = objEmrTempalteCategory.ParentCategoryID
	q:(CategoryID = "") json
	k ^TempGetTitles
	s sequence = ""
	for
	{ 
		s sequence = $o(^DHCEMRM.TitleConfigI("IdxCategorySequence"," "_CategoryID,sequence))
		q:(sequence = "")
		s rowID = ""
		for
		{
			s rowID = $o(^DHCEMRM.TitleConfigI("IdxCategorySequence"," "_CategoryID,sequence,rowID))
			q:(rowID = "")
			s titleCategory= "",cateSeq=""
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
			continue:(emrTemplateCateId'=aDocID)
			
			//过滤科室
			continue:(($d(^DHCEMRM.TitleLocI("IdxCTLocIDTitleID"," "_titleRowID))>0)&&($d(^DHCEMRM.TitleLocI("IdxCTLocIDTitleID"," "_titleRowID," "_aLocID))<=0))
			s TemplateID = obj.TemplateID
			s titleDesc = titleObj.Description ;$ZCVT(titleObj.Description,"O","UTF8")
			s titleAlias =titleObj.Alias ; $ZCVT(titleObj.Alias,"O","UTF8")
			continue:(($find(titleDesc,aText) = 0)&&($find(titleAlias,aText) = 0))   
		 	//唯一实例
		 	if ($zcvt(obj.UniqueCreate,"U")="TRUE")
		 	{
			 	if ($d(^DHCEMRI.InstanceDataI("IdxEpisodeTitleCodeStatus",AEpisodeID," "_$zcvt(titleCode,"U")," SAVE"))=10)
		 		{
			 		continue
			 	}
		 	}
		 	s isCollect = ##Class(EMRservice.BL.BLCollectTemplate).GetIsCollect(aUserID,"TempCate"_TemplateID_"T"_titleRowID)
			s strItem = ""
			s strItem = strItem _"{"
			s strItem = strItem _"""id"":"""_"TempCate"_TemplateID_"T"_titleRowID_""""
            s strItem = strItem _",""text"":"""_titleDesc_""""
            s strItem = strItem _",""isCollect"":"""_isCollect_""""
            s strItem = strItem _",""DocIDText"":"""_titleDesc_""""
            s:(aJson'="") strItem = strItem _aJson
            s:(aJson'="") strItem = strItem _",""iconCls"":""general-template"""
            s:(aJson="") strItem = strItem _",""icon"":""../scripts/emr/image/icon/leaf.png"""
            s strItem = strItem _",""type"":"""_"TempCate"_""""
            s strItem = strItem _",""attributes"":{"
			s strItem = strItem _"""Code"":"""_""_""""
			s strItem = strItem _",""SimpleSpel"":"""_titleAlias_""""
			s strItem = strItem _",""TemplateID"":"""_TemplateID_""""
			s strItem = strItem _",""TitleCode"":"""_titleCode_""""
			s strItem = strItem _",""Type"":"""_"全院通用"_""""
			s strItem = strItem _",""nodetype"":""leaf"""
			s strItem = strItem _"}}"
			s:(obj.GroupID'="") titleCategory = ##class(EMRmeta.TitleCategory).%OpenId(obj.GroupID)
			s:(titleCategory'="") cateSeq = titleCategory.Sequence
			s strKey = cateSeq_sequence_rowID
			s ^TempGetTitles(strKey) = strItem
		}
    }
    s key = ""
	for
	{
		s key = $o(^TempGetTitles(key))
		q:(key = "")
		s strValue = ^TempGetTitles(key)
		d:(json.Size>0) json.Write(",")
		d json.Write(strValue)
	}
	k ^TempGetTitles
    q json
}

}
