/// Desc:病历文档目录信息
/// Creator:Candy
/// CreatDate:2014-2-18
Class EMRservice.BL.BLDirectoryInformation Extends %RegisteredObject
{

/// Desc:       存储文档目录信息
/// Creator:    Candy
/// CreatDate:  2014-02-18
/// Input: 	    AInstanceID 实例数据id
///             ADirInfoData 目录xml
/// OutPut:     result  -1 失败  1 成功
ClassMethod SetDirectoryInformation(AInstanceID As %String, ADirInfoData As %GlobalBinaryStream) As %String
{
	s result = "-1"
	q:((AInstanceID = "")||(ADirInfoData = "")) result
	s ECRecordID = $p(AInstanceID,"||",1) 
	s SubRowID = $p(AInstanceID,"||",2)
	q:($d(^DHCEMRI.InstanceDataI("IdxECRecord",ECRecordID,SubRowID))<=0) result
	s rowID = $o(^DHCEMRI.DirectoryInformationI("IdxECRecordID"," "_ECRecordID,""))
	if (rowID = "")
	{
		s obj = ##Class(EMRinstance.DirectoryInformation).%New()
		s obj.ECRecordID = ECRecordID
		s objECRecord = ##Class(EMRinstance.ECRecord).%OpenId(ECRecordID)
		q:(objECRecord = "") result
		s objDoc = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(objECRecord.RealChartItemID)
		q:(objDoc = "") result	
		s objChapter = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(objDoc.ParentCategoryID)
		q:(objChapter = "") result
		s obj.DocID = objECRecord.RealChartItemID
		s obj.EpisodeID = objECRecord.RealEpisodeID
		s obj.DocName = objChapter.CategoryName
		k objCategory,objECRecord
	}
	else
	{
		s obj = ##Class(EMRinstance.DirectoryInformation).%OpenId(rowID)
	}
	d obj.DirInfoData.Clear()
	d obj.DirInfoData.CopyFrom(ADirInfoData)
	s sc = obj.%Save()
	s:($$$ISOK(sc)) result = "1"
	q result
}

/// Desc:       取文档目录信息
/// Creator:    Candy
/// CreatDate:  2014-02-18
/// Input: 	    AInstanceID 实例数据ID
/// OutPut:     dirInfoData  文档目录信息
ClassMethod GetDirectoryInformation(AInstanceID As %String) As %GlobalBinaryStream
{
	s dirInfoData = ##Class(%GlobalBinaryStream).%New()
	q:(AInstanceID = "") dirInfoData
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceID)
	q:(objInstance = "") result
	s ECRecordID = $p(AInstanceID,"||",1)
	d objInstance.%Close() 
	k objInstance
	s rowID = $o(^DHCEMRI.DirectoryInformationI("IdxECRecordID"," "_ECRecordID,""))
	q:(rowID = "") dirInfoData
	s obj = ##Class(EMRinstance.DirectoryInformation).%OpenId(rowID)
	q:(obj = "") dirInfoData
	d dirInfoData.CopyFrom(obj.DirInfoData)
	q dirInfoData
}

/// Desc:       保存病历页码
/// Creator:    Candy
/// CreateDate: 2015-05-21
/// Input:      AIndexXml 变更页码xml
/// Output:     result 成功1 失败0
/// d ##Class(EMRservice.BL.BLDirectoryInformation).SetDocumentIndex()
ClassMethod SetDocumentIndex(AInstanceID As %String, AIndexXml As %GlobalBinaryStream) As %String
{
	s result = "0"
	q:(AIndexXml = "")||(AIndexXml.Size = 0)||(AInstanceID = "") result
	s reader = ##class(%XML.Reader).%New()
	s sc = reader.OpenStream(AIndexXml)
	q:($$$ISERR(sc)) result
	d reader.Correlate("NInstanceIndex","EMRservice.entity.ENInstanceIndex")
	Tstart
	s result = "1"
	While reader.Next(.obj,.sc)
	{
		s lastModifyPosition = obj.InstanceProperty.LastModifyPosition
		s ecrecordId = $p(AInstanceID,"||",1)
		s extra = ##class(EMRservice.BL.BLECRecordExtraInfo).SetDocumentExtraInfo(ecrecordId,lastModifyPosition)
		s:(extra = "") result = 0
		q:(result = 0)
		s indexCount = obj.InstanceIndex.Count()
		continue:(indexCount <=0)
		for i=1:1:indexCount
		{
			s id = obj.InstanceIndex.GetAt(i).ID
            s pageBreak = obj.InstanceIndex.GetAt(i).PageBreak
			s startPageNum = obj.InstanceIndex.GetAt(i).StartPageNum
	        s startRowNum = obj.InstanceIndex.GetAt(i).StartRowNum
			s endPageNum = obj.InstanceIndex.GetAt(i).EndPageNum
			s endRowNum = obj.InstanceIndex.GetAt(i).EndRowNum
			s sc = ##Class(EMRservice.BL.BLInstanceData).SetDocumentPageNum(id,startPageNum,startRowNum,endPageNum,endRowNum)
			s:(sc = "0") result = "0"
			q:(result = "0")
            s dataExtra = ##Class(EMRservice.BL.BLInstanceDataExtraInfo).SetDocumentExtraInfo(id,pageBreak)
            s:(dataExtra = "") result = 0
            q:(result = 0)
		}
		q:(result = "0")
	}
	if (result = "1")
	{
		Tcommit
	}
	else
	{
		Trollback
	}
	q result
}

/// Desc:       取文档目录信息
/// Creator:    Candy
/// CreatDate:  2014-02-18
/// Input: 	    AInstanceID 实例数据ID
/// OutPut:     dirInfoData  文档目录信息
/// Debug:      d ##Class(EMRservice.BL.BLDirectoryInformation).GetDocumentIndex("2||1","DELETE")
ClassMethod GetDocumentIndex(AInstanceID As %String, AType As %String, IsLoadOne As %String = "", ALoadDocMode As %String = "", ALoadDirection As %String = "", ADateTime As %String = "", AUserLocID As %String = "") As %GlobalBinaryStream
{
    s dirInfoData = ##Class(%GlobalBinaryStream).%New()
    q:(AInstanceID = "") dirInfoData
    s eCRecordId = $p(AInstanceID,"||",1)
    q:(eCRecordId = "") result
    d dirInfoData.Write("<NInstanceIndex>")
    d dirInfoData.Write("<InstanceProperty>")
    s extra = ##Class(EMRservice.BL.BLECRecordExtraInfo).GetDocumentExtraInfo(eCRecordId)
    if (AType = "DELETE")
    {
        d dirInfoData.Write(extra)
        d dirInfoData.Write("</InstanceProperty>") 
        d dirInfoData.Write("<InstanceIndex>")
        d dirInfoData.Write("<ID>"_AInstanceID_"</ID>")
        d dirInfoData.Write("<CompressDocument>"_##class(EMRservice.BL.BLInstanceDataCompressInfo).GetIsCompressByInstanceID(AInstanceID)_"</CompressDocument>")
        d dirInfoData.Write("</InstanceIndex>")
    }
    else
    {
        s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceID)
        if (objInstance.TheECRecord.DocumentCharacteristic '= "1")
        {
            d dirInfoData.Write(extra)
            d dirInfoData.Write("</InstanceProperty>") 
            s result = ##Class(EMRservice.BL.BLInstanceData).GetDocumentPageNum(AInstanceID)
            d dirInfoData.Write(result)
        }
        else
        {
            if (IsLoadOne = "Y")
            {
                d dirInfoData.Write(extra)
                d dirInfoData.Write("</InstanceProperty>") 
                s result = ##Class(EMRservice.BL.BLInstanceData).GetDocumentPageNum(AInstanceID)
                d dirInfoData.Write(result)
            }else
            {
                s loadDocMode = ##Class(EMRservice.SystemParameter).GetLoadDocMode()
                s Stream = ##Class(%GlobalCharacterStream).%New()
                d Stream.Write(loadDocMode)
                //解析json参数
                s objJson = ##Class(EMRservice.Parser.Json).%New()  
                s array = objJson.Deserialize(Stream)
                s TitleCode = array.GetAt("TitleCode")
                s RecordConfig = array.GetAt("RecordConfig")
                // 按阶段小结分段加载设置
                if ((ALoadDocMode '= "")&&(ALoadDocMode '= "ALL")&&($ZSTRIP(TitleCode,"*C") '= ""))
                {
                    d dirInfoData.Write(extra)
                    d dirInfoData.Write("<BatchMode>Business</BatchMode>")
                    d dirInfoData.Write("</InstanceProperty>")
                    if ($zcvt(ALoadDocMode,"U") = "BATCH")
                    {
                        d GetAllRowIds
                        s date = $case(ADateTime,"":objInstance.HappenDate,:$zdh($p(ADateTime," ",1),3))
                        s time = $case(ADateTime,"":objInstance.HappenTime,:$zth($p(ADateTime," ",2)))
                        d GetBatchIndexStream
                        
                    }elseif ($zcvt(ALoadDocMode,"U") = "APPEND")
                    {
                        d GetAppendIndexStream
                    }
                }elseif ((ALoadDocMode '= "")&&(ALoadDocMode '= "ALL")&&($ZSTRIP(RecordConfig,"*C") '= ""))
                {
                    s LoadCondition = array.GetAt("RecordConfig").GetAt("LoadCondition")
                    s count = ##Class(EMRservice.BL.BLInstanceData).getInstanceCount(AInstanceID,"SAVE")
                    // 满足条件开启按病程条目分段加载
                    if (count > LoadCondition)
                    {
                        d dirInfoData.Write(extra)
                        d dirInfoData.Write("<BatchMode>Number</BatchMode>")
                        d dirInfoData.Write("</InstanceProperty>")
                        s currentDate = $case(ADateTime,"":objInstance.HappenDate,:$zdh($p(ADateTime," ",1),3))
                        s currentTime = $case(ADateTime,"":objInstance.HappenTime,:$zth($p(ADateTime," ",2)))
                        d GetAllRowIds
                        s outRowIds = ""
                        s LoadRecordNum = array.GetAt("RecordConfig").GetAt("LoadRecord")
                        if ($zcvt(ALoadDocMode,"U") = "BATCH")
                        {
                            s key = ..getKey(currentDate,currentTime), preRowId = "", preCount = 0
                            s currentRowId = rowIds.GetAt(key)
                            d GetPreRowIdByLoadRecordNum
                            s preRowId = $case(preRowId,"":currentRowId,:$case(currentRowId,"":preRowId,:preRowId_","_currentRowId))
                            s key = ..getKey(currentDate,currentTime), nextRowId = "", nextCount = 0
                            d GetNextRowIdByLoadRecordNum
                            s outRowIds = $case(preRowId,"":nextRowId,:$case(nextRowId,"":preRowId,:preRowId_","_nextRowId))
                        }elseif ($zcvt(ALoadDocMode,"U") = "APPEND")
                        {
                            if ($zcvt(ALoadDirection,"U") = "UP") {
                                s key = ..getKey(currentDate,currentTime), preRowId = "", preCount = 0
                                d GetPreRowIdByLoadRecordNum
                                s outRowIds = preRowId
                            }elseif ($zcvt(ALoadDirection,"U") = "DOWN") {
                                s key = ..getKey(currentDate,currentTime), nextRowId = "", nextCount = 0
                                d GetNextRowIdByLoadRecordNum
                                s outRowIds = nextRowId
                            }
                        }
                        for i=1:1:$l(outRowIds,",")
                        {
                            s instanceId = $p(outRowIds,",",i)
                            s result = ##Class(EMRservice.BL.BLInstanceData).GetDocumentPageNum(instanceId)
                            d dirInfoData.Write(result)
                        }
                    }else
                    {
                        d dirInfoData.Write(extra)
                        d dirInfoData.Write("</InstanceProperty>")
                        // 默认病程全部加载设置
                        d GetIndexStream
                    }
                }
                else
                {
                    d dirInfoData.Write(extra)
                    d dirInfoData.Write("</InstanceProperty>")
                    // 默认病程全部加载设置
                    d GetIndexStream
                }
            }
        }
        k objInstance
    }
    d dirInfoData.Write("</NInstanceIndex>")
    q dirInfoData
GetAllRowIds
    s rowIds = ##Class(%ArrayOfDataTypes).%New()
    s date = ""
    for
    {
        s date = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",eCRecordId," SAVE",date))
        q:(date = "")
        s time = ""
        for
        {
            s time = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",eCRecordId," SAVE",date,time)) 
            q:(time = "")
            s subId = ""
            for
            {
                s subId = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",eCRecordId," SAVE",date,time,subId))
                q:(subId = "")
                s rowId = eCRecordId_"||"_subId
                s key = ..getKey(date,time)
                d rowIds.SetAt(rowId, key)
                ;w $lb(rowId, key),!
            }
        }
    }
    q
GetBatchIndexStream
    s preKey = ""
    s key = ..getKey(date,time)
    while (1)
    {
        s key = rowIds.Previous(key)
        q:(key = "")
        s rowId = rowIds.GetAt(key)
        s preKey = key
        s tmpobjInstance = ##Class(EMRinstance.InstanceData).%OpenId(rowId)
        q:(0'=$f("^"_TitleCode_"^","^"_tmpobjInstance.TitleCode_"^"))
    }
    k tmpobjInstance
    s key = $Case(preKey,"":0,:preKey)
    if (key = preKey)
    {
        s result = ##Class(EMRservice.BL.BLInstanceData).GetDocumentPageNum(rowIds.GetAt(key))
        d dirInfoData.Write(result)
    }
    while (1)
    {
        s key = rowIds.Next(key)
        q:(key = "")
        s rowId = rowIds.GetAt(key)
        s tmpobjInstance = ##Class(EMRinstance.InstanceData).%OpenId(rowId)
        if ((AInstanceID '= rowId)&&(0'=$f("^"_TitleCode_"^","^"_tmpobjInstance.TitleCode_"^")))
        {
            s result = ##Class(EMRservice.BL.BLInstanceData).GetDocumentPageNum(rowId)
            d dirInfoData.Write(result)
            q
        }
        else
        {
            s result = ##Class(EMRservice.BL.BLInstanceData).GetDocumentPageNum(rowId)
            d dirInfoData.Write(result)
        }
    }
    k tmpobjInstance
    q
GetAppendIndexStream
    s date = ""
    for
    {
        s date = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",eCRecordId," SAVE",date))
        q:(date = "")
        continue:(objInstance.HappenDate > date)
        s time = ""
        for
        {
            s time = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",eCRecordId," SAVE",date,time)) 
            q:(time = "")
            continue:((objInstance.HappenDate = date)&&(objInstance.HappenTime > time))
            s subId = ""
            for
            {
                s subId = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",eCRecordId," SAVE",date,time,subId))
                q:(subId = "") 
                s rowId = eCRecordId_"||"_subId
                continue:(rowId = AInstanceID)
                s result = ##Class(EMRservice.BL.BLInstanceData).GetDocumentPageNum(rowId)
                d dirInfoData.Write(result)
            }
        }
    }
    q
GetPreRowIdByLoadRecordNum
    while (1)
    {
        s key = rowIds.Previous(key)
        q:(key = "")
        s rowId = rowIds.GetAt(key)
        s preCount = preCount + 1
        q:(preCount > LoadRecordNum)
        s preRowId = $case(preRowId,"":rowId,:rowId_","_preRowId)
    }
    q
GetNextRowIdByLoadRecordNum  
    while (1)
    {
        s key = rowIds.Next(key)
        q:(key = "")
        s rowId = rowIds.GetAt(key)
        s nextCount = nextCount + 1
        q:(nextCount > LoadRecordNum)
        s nextRowId = $case(nextRowId,"":rowId,:nextRowId_","_rowId)
    }
    q
GetIndexStream
	s date = ""
	for
	{
		s date = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",eCRecordId," SAVE",date))
		q:(date = "")
		s time = ""
		for
		{
			s time = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",eCRecordId," SAVE",date,time)) 
			q:(time = "")
			s subId = ""
			for
			{
				s subId = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",eCRecordId," SAVE",date,time,subId))
				q:(subId = "")
				//如果是病历浏览状态，根据系统参数BrowseViewDataState，根据状态过滤数据
				if (AType="BROWSE")&&(AUserLocID'="")	
				{
					//增加病历状态验证
					s aInstanceID = eCRecordId_"||"_subId
					s strState = ##class(EMRservice.BL.BLClientCategory).GetInstanceState(aInstanceID,AUserLocID)
					continue:(strState=0)
				}
				s result = ##Class(EMRservice.BL.BLInstanceData).GetDocumentPageNum(eCRecordId_"||"_subId)
				d dirInfoData.Write(result)
			}
		}
	}
    q
}

/// Desc:      根据病人ID将患者某科室门诊病历续打在一起
/// Creator:   Candy
/// CreateDate:2018-10-10
/// Input:     APatientID 病人ID
///            ALocID 科室ID
/// Debug:     d ##Class(EMRservice.BL.BLDirectoryInformation).GetDocumentIndexByPatiendID("50","7")
ClassMethod GetDocumentIndexByPatiendID(APatientID As %String, ALocID As %String) As %GlobalBinaryStream
{
	s dirInfoData = ##Class(%GlobalBinaryStream).%New()
	d dirInfoData.Write("<NInstanceIndex>")
	d dirInfoData.Write("<InstanceProperty>")
	d dirInfoData.Write("</InstanceProperty>")
	s ds = ##Class(%Library.ResultSet).%New("EMRservice.HISInterface.EpisodeInfo:GetEpisodeListByPID")
	d ds.Execute(APatientID,"","O",1)
	While (ds.Next())
	{
		s episodeDeptId = ds.Data("EpisodeDeptID")
		continue:((ALocID '= "")&&(episodeDeptId '= ALocID))
		s episodeId = ds.Data("EpisodeID")
		continue:(episodeId = "")
		s date = ""
		for
		{
			s date = $o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",episodeId," SAVE",date))
			q:(date = "")
			s time = ""
			for
			{
				s time = $o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",episodeId," SAVE",date,time))
				q:(time = "")
				s ecrecordId = ""
				for
				{
					s ecrecordId = $o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",episodeId," SAVE",date,time,ecrecordId))
					q:(ecrecordId = "")
					s subId = ""
					for
					{
						s subId = $o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",episodeId," SAVE",date,time,ecrecordId,subId))
						q:(subId = "")
						s instanceId = ecrecordId_"||"_subId
						d dirInfoData.Write("<InstanceIndex><ID>"_instanceId_"</ID></InstanceIndex>")
						//增加压缩相关代码 20220419
						d dirInfoData.Write("<CompressDocument>"_##class(EMRservice.BL.BLInstanceDataCompressInfo).GetIsCompressByInstanceID(instanceId)_"</CompressDocument>")
					}
				}
			}
		}	
	}
	d dirInfoData.Write("</NInstanceIndex>")
	q dirInfoData
}

/// Desc:      根据病人ID将患者某科室门诊病历续打在一起
/// Creator:   lifb
/// CreateDate:20190122
/// Input:     AEpisodeID 病人ID
/// Debug:     d ##Class(EMRservice.BL.BLDirectoryInformation).GetDocumentIndexByEpisodeID("50")
ClassMethod GetDocumentIndexByEpisodeID(AEpisodeID As %String) As %GlobalBinaryStream
{
	s dirInfoData = ##Class(%GlobalBinaryStream).%New()
	d dirInfoData.Write("<NInstanceIndex>")
	d dirInfoData.Write("<InstanceProperty>")
	d dirInfoData.Write("</InstanceProperty>")
	
	s date = ""
	for
	{
		s date = $o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",AEpisodeID," SAVE",date))
		q:(date = "")
		s time = ""
		for
		{
			s time = $o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",AEpisodeID," SAVE",date,time))
			q:(time = "")
			s ecrecordId = ""
			for
			{
				s ecrecordId = $o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",AEpisodeID," SAVE",date,time,ecrecordId))
				q:(ecrecordId = "")
				s subId = ""
				for
				{
					s subId = $o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",AEpisodeID," SAVE",date,time,ecrecordId,subId))
					q:(subId = "")
					s instanceId = ecrecordId_"||"_subId
						//是否过滤无有效签名或无签名病历
					s signFlag = ##Class(EMRservice.BOPrivAssist).HasValidSign(instanceId)
					continue:(signFlag = 0)
					
					d dirInfoData.Write("<InstanceIndex>")
					
					d dirInfoData.Write("<ID>"_instanceId_"</ID>")
					//增加压缩相关代码 20220419
					d dirInfoData.Write("<CompressDocument>"_##class(EMRservice.BL.BLInstanceDataCompressInfo).GetIsCompressByInstanceID(instanceId)_"</CompressDocument>")
					
					d dirInfoData.Write("</InstanceIndex>")
				}
			}
		}
	}	
	d dirInfoData.Write("</NInstanceIndex>")
	q dirInfoData
}

/// Desc:       按实例ID将索引表数据迁移到实例表中
/// Creator:    Candy
/// CreateDate: 2015-6-25
/// Desc:       w ##Class(EMRservice.BL.BLDirectoryInformation).MoveIndexToInstanceEcrecord(0,5)
ClassMethod MoveIndexToInstanceEcrecord(AStart As %String, AEnd As %String) As %String
{
	s result = "1"
	s ECRecordID = AStart
	for
	{	
		s ECRecordID = $o(^DHCEMRI.ECRecordD(ECRecordID))
		q:((ECRecordID = "")||(ECRecordID > AEnd))
		s rowId = $o(^DHCEMRI.DirectoryInformationI("IdxECRecordID"," "_ECRecordID,""))	
		continue:(rowId = "")
		s obj = ##Class(EMRinstance.DirectoryInformation).%OpenId(rowId)
		continue:(obj = "") 
		s result = ..SetDocumentIndex(obj.DirInfoData)
		w "ECRecordID: "_ECRecordID_" DirectoryInformation: "_rowId_" result: "_result,!	
		q:(result = "0")
	}
	q result
}

/// Desc:       按索引ID将索引表数据迁移到实例表中
/// Creator:    Candy
/// CreateDate: 2015-6-25
/// Input:      AStartDate 开始日期 格式：2015-6-25
///             AEndDate 结束日期 格式：2015-6-25
/// Desc:       w ##Class(EMRservice.BL.BLDirectoryInformation).MoveIndexToInstance(0,"10")
ClassMethod MoveIndexToInstance(AStart As %String, AEnd As %String) As %String
{
	s result = "1"
	s rowId = AStart
	for
	{
		s rowId = $o(^DHCEMRI.DirectoryInformationD(rowId))
		q:((rowId = "")||(rowId > AEnd))
		s obj = ##Class(EMRinstance.DirectoryInformation).%OpenId(rowId)
		continue:(obj = "") 
		s result = ..SetDocumentIndex(obj.DirInfoData)	
		w " DirectoryInformation: "_rowId_" result: "_result,!
		q:(result = "0")
	}
	q result
}

ClassMethod getKey(ADate As %String, ATime As %String) As %String
{
    s d = ADate
    s t = "0000"_ATime
    s key = d_$E(t,$L(t)-4,$L(t))
    q key
}

/// Desc:      根据病历实例ID获取相关病历数据
/// Creator:   Lina
/// CreateDate:2020-2-21
/// Input:     AInstanceID 病历实例ID,当前病历分为可重复连续显示和单独显示
///            AEpisodeIDs 就诊号，多个以","分隔
///            ADocID      目录展现结构挂模板一层的目录ID
/// Debug:     d ##Class(EMRservice.BL.BLDirectoryInformation).GetDocumentIndexByEpisodeIDs("1||1","24,41","66")
ClassMethod GetDocumentIndexByEpisodeIDs(AInstanceID As %String, AEpisodeIDs As %String, ADocID As %String) As %GlobalBinaryStream
{
    s dirInfoData = ##Class(%GlobalBinaryStream).%New()
    q:(AInstanceID = "") dirInfoData
    s eCRecordId = $p(AInstanceID,"||",1)
    q:(eCRecordId = "") dirInfoData
    d dirInfoData.Write("<NInstanceIndex>")
    d dirInfoData.Write("<InstanceProperty>")
    s extra = ##Class(EMRservice.BL.BLECRecordExtraInfo).GetDocumentExtraInfo(eCRecordId)
    d dirInfoData.Write(extra)
    d dirInfoData.Write("</InstanceProperty>")
    
    s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceID)
    if ((objInstance.TheECRecord.ChartItemType = "Multiple")&&(objInstance.TheECRecord.DocumentCharacteristic = "1"))
    {
        s length = $l(AEpisodeIDs,",")
        for i=1:1:length
        {
            s episodeId = $p(AEpisodeIDs,",",i)
            continue:(episodeId = "")
            s ecrRowId = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",episodeId,ADocID,""))
            continue:(ecrRowId = "")
            
            s date = ""
            for
            {
                s date = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ecrRowId," SAVE",date))
                q:(date = "")
                s time = ""
                for
                {
                    s time = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ecrRowId," SAVE",date,time)) 
                    q:(time = "")
                    s subId = ""
                    for
                    {
                        s subId = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ecrRowId," SAVE",date,time,subId))
                        q:(subId = "")
                        s result = ##Class(EMRservice.BL.BLInstanceData).GetDocumentPageNum(ecrRowId_"||"_subId)
                        d dirInfoData.Write(result)
                    }
                }
            } 
        }
    }else
    {
        s result = ##Class(EMRservice.BL.BLInstanceData).GetDocumentPageNum(AInstanceID)
        d dirInfoData.Write(result)     
    }
    k objInstance, objECRecord
    d dirInfoData.Write("</NInstanceIndex>")
    q dirInfoData
}

}
