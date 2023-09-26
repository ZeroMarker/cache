Class EMRservice.BL.RevisionLog Extends %RegisteredObject
{

/// Desc:       保存病历修改历史
/// Creator:    Lina
/// Createdate: 2021-07-29
/// Input:      AInstanceID 实例数据ID
/// Output:     rtn 0缺少参数,1成功,-1失败
/// Debug:      w ##Class(EMRservice.BL.RevisionLog).SaveRevisionLog("58||3")
ClassMethod SaveRevisionLog(AInstanceID As %String) As %String
{
    s rtn = "1"
    q:(AInstanceID = "") "0:缺少参数"
    s objInstance = ##class(EMRinstance.InstanceData).%OpenId(AInstanceID)
    q:(objInstance = "") "0"
    s streamAbiwordData = ##Class(EMRservice.Parser.StreamData).ParserStream(objInstance.InstanceData,"<abiword","</abiword>","10")
    s streamRevisionsData = ##Class(EMRservice.Parser.StreamData).ParserStream(streamAbiwordData,"<revisions","</revisions>","12")
    q:(streamRevisionsData.Size = 0) "0:没有留痕信息"
    s sc = ##class(%XML.XPATH.Document).CreateFromStream(streamRevisionsData,.revisionsData)
    q:($$$ERROR(sc)) "-1:revisionsData"
    s sc = revisionsData.EvaluateExpression("/revisions","count(r)",.rData)
    q:($$$ERROR(sc)||(rData.GetAt(1)="")) "-1:rData"
    s count = rData.GetAt(1).Value
    for i=1:1:count
    {
        s sc = revisionsData.EvaluateExpression("/revisions/r["_i_"]","@id",.result)
        continue:($$$ERROR(sc)||(result.GetAt(1)=""))   
        s revisionID = result.GetAt(1).Value
        
        s rowID = $o(^DHCEMRI.RevisionLogI("IdxMain",AInstanceID,revisionID,""))
        ;b:(i=count)
        if (rowID = "")
        {
            s objRevisionLog = ##class(EMRinstance.RevisionLog).%New()
            s objRevisionLog.InstanceID = objInstance
            s objRevisionLog.RevisionID = revisionID
            d objRevisionLog.InstanceData.Write(AInstanceID)
            s sc = revisionsData.EvaluateExpression("/revisions/r["_i_"]","@time-started",.result)
            continue:($$$ERROR(sc)||(result.GetAt(1)=""))
            s timeStamp = result.GetAt(1).Value
            s objRevisionLog.TimeStamp = timeStamp
            s revisionDateTime = ##class(EMRservice.Tools.Tool).TimestampToDateTime(timeStamp,"s")
            s objRevisionLog.RevisionDate = $p(revisionDateTime,",",1)
            s objRevisionLog.RevisionTime = $p(revisionDateTime,",",2)
            s sc = revisionsData.EvaluateExpression("/revisions/r["_i_"]","@revision-key",.result)
            continue:($$$ERROR(sc)||(result.GetAt(1)=""))
            s revisionUserID = result.GetAt(1).Value
            s objSSUser = ##class(User.SSUser).%OpenId(revisionUserID)
            s objRevisionLog.UserID = objSSUser
            s scRevisionLog = objRevisionLog.%Save()
            if ($$$ISERR(scRevisionLog))
            {
                s rtn = "-1:error"
                q
            }
            d objRevisionLog.%Close(),objSSUser.%Close()
            k objRevisionLog,objSSUser
        }
    }
    d objInstance.%Close()
    k objInstance       
    q rtn
}

/// Desc:       根据条件批量生成病历修改历史记录
/// Creator:    Lina
/// Createdate: 2021-07-30
/// Input:      AStartDate  开始日期
///             AEndDate    结束日期
///             AStatus     过滤条件,病历状态,默认为空表示所有,可选值:"SAVE"、"DELETE"、"UNSAVE"
/// Output:     0           缺少参数
///             totalCount  病历总数量
///             okCount     有留痕病历数量
///             notRevision 无留痕病历数
///             errorCount  插入失败病历数量
/// Debug:      w ##Class(EMRservice.BL.RevisionLog).batchAddRevisionLog("2022-01-17","2022-01-31")
ClassMethod batchAddRevisionLog(AStartDate As %String, AEndDate As %String, AStatus As %String = "") As %String
{
    q:(AStartDate = "")||(AEndDate = "") "0"
    s stDate = $zdh(AStartDate,3)
    s endDate = $zdh(AEndDate,3)
    s (totalCount,okCount,notRevision,errorCount) = 0
    //rtn 保存病历修改历史记录标识; errorInstances 返回失败病历实例IDs
    s rtn = "1", errorInstanceIDs = ""
    for date = stDate:1:endDate
    {
	    w $zd(date,3),!
        s time = ""
        for
        {
            s time = $o(^DHCEMRI.EMRLogsI("IdxCreateDateTime",date,time))
            q:(time = "")
            s EpisodeID = ""
            for
            {
                s EpisodeID = $o(^DHCEMRI.EMRLogsI("IdxCreateDateTime",date,time,EpisodeID))
                //s EpisodeID = $tr(EpisodeID," ","")
                q:(EpisodeID = "")
                s docId = ""
                for
                {
                    s docId = $o(^DHCEMRI.EMRLogsI("IdxCreateDateTime",date,time,EpisodeID,docId))
                    //s docId = $tr(docId," ","")
                    q:(docId = "")
                    s ecrecordID = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",EpisodeID,docId,""))
                    q:(ecrecordID = "")
                    s objRecord = ##Class(EMRinstance.ECRecord).%OpenId(ecrecordID)
                    q:(objRecord = "")
                    s emrNum = ""
                    for
                    {
                        s emrNum = $o(^DHCEMRI.EMRLogsI("IdxCreateDateTime",date,time,EpisodeID,docId,emrNum))
                        //s emrNum = $tr(emrNum," ","")
                        q:(emrNum = "")
                        s rowId = $tr(ecrecordID," ","")_"||"_$tr(emrNum," ","")
                        s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(rowId,0)
                        q:(objInstance = "")
                        continue:(AStatus '= "")&&($zcvt(objInstance.Status,"U") '= AStatus)
                        s totalCount = totalCount + 1
                        //非压缩病历补留痕信息
                        ///s rtn = ..SaveRevisionLog(rowId)
                   	s rtn = ..SaveRevisionLogNewBatch(rowId)
                        if ($p(rtn,":",1) = "-1")
                        {
                            s errorCount = errorCount + 1
                            s errorInstanceIDs = errorInstanceIDs_","_rowId
                        }
                        elseif ($p(rtn,":",1) = "0")
                        {
                            s notRevision = notRevision+1
                        }
                        else
                        {
                            s okCount = okCount + 1
                        }
                        
                        d objRecord.%Close(),objInstance.%Close()
                        k objRecord,objInstance
                    }
                }
            }
        }
    }
    
    s:(errorCount '= 0) errorCount = errorCount_":"_errorInstanceIDs
    q "病历总数量"_totalCount_",有留痕病历数量:"_okCount_",无留痕病历数:"_notRevision_",插入失败病历数量:"_errorCount
}

/// Desc:       保存病历修改历史
/// Creator:    Lifengbo
/// Createdate: 2022-05-09
/// Input:      AInstanceID 实例数据ID
/// Output:     rtn 0缺少参数,1成功,-1失败
/// Debug:      w ##Class(EMRservice.BL.RevisionLog).SaveRevisionLog("58||3")
ClassMethod SaveRevisionLogNew(AInstanceID As %String, AStream As %GlobalBinaryStream = "", AIsCompressDocument As %String = "") As %String
{
    s rtn = "1"
    q:(AInstanceID = "") "0:缺少参数"
    s objInstance = ##class(EMRinstance.InstanceData).%OpenId(AInstanceID)
    q:(objInstance = "") "0"
   
    //DOC GRID
    s DocumentType = objInstance.TheECRecord.DocumentType
    
    if (AIsCompressDocument="")
    {
		s AIsCompressDocument=##class(EMRservice.BL.BLInstanceDataCompressInfo).GetIsCompressByInstanceID(AInstanceID)
    }
    if (AIsCompressDocument="TRUE")
    {
	    if (AStream'="")
	    {
	   		s streamNInstanceData = ##Class(EMRservice.Parser.StreamData).ParserStream(AStream,"<NInstanceData","</NInstanceData>","16")
	    }
	}
    else
    {
	    //增加后台解压处理
	    s IsBKCompress=##class(EMRservice.BL.BLInstanceDataCompressInfo).GetIsBKCompressByInstanceID(AInstanceID)
	    if (IsBKCompress="1")
	    {
	    	s tempInstanceData = ##class(EMRservice.Parser.StreamData).DeCompressStream(objInstance.InstanceData)
	    	s streamNInstanceData = ##Class(EMRservice.Parser.StreamData).ParserStream(tempInstanceData,"<NInstanceData","</NInstanceData>","16")
	    
	    }
	    else
	    {
    		s streamNInstanceData = ##Class(EMRservice.Parser.StreamData).ParserStream(objInstance.InstanceData,"<NInstanceData","</NInstanceData>","16")
	    }
    }
    s streamRevisionsData = ##Class(EMRservice.Parser.StreamData).ParserStream(streamNInstanceData,"<revisions","</revisions>","12")
    q:(streamRevisionsData.Size = 0) "0:没有留痕信息"
    
    s sc = ##class(%XML.XPATH.Document).CreateFromStream(streamRevisionsData,.revisionsData)
    
    q:($$$ERROR(sc)) "-1:revisionsData"
    s sc = revisionsData.EvaluateExpression("/revisions","count(r)",.rData)
    
    q:($$$ERROR(sc)||(rData.GetAt(1)="")) "-1:rData"
    s count = rData.GetAt(1).Value
    q:(count = 0) "0:没有留痕信息"
   	//取最后数据(分析XML，Grid模板留痕信息会额外多出2个revisionId,所以Grid的FinNum = count-1
	//s finNum=$case(DocumentType,"WORD":count,"GRID":count-1)
	//s finNum=$case(DocumentType,"WORD":count,"GRID":count-1)
	
	s revisionID=""
	
	if (DocumentType="DOC")
	{
		s finNum= count
		s sc = revisionsData.EvaluateExpression("/revisions/r["_finNum_"]","@id",.result)
		q:($$$ERROR(sc)||(result.GetAt(1)="")) "" 
		s revisionID = result.GetAt(1).Value
	}
	
	
	if (DocumentType="GRID")
	{
		s revisionIdList=""
		for finNum=1:1:count
		{
			s sc = revisionsData.EvaluateExpression("/revisions/r["_finNum_"]","@id",.result)
			continue:($$$ERROR(sc)||(result.GetAt(1)=""))
			s revisionIdList = revisionIdList_$lb(result.GetAt(1).Value)
		}
		//获取倒数第三个id作为RevisionID
		s rIdsll= $ll(revisionIdList)
		if (rIdsll=1)
		{
			s revisionID = $list(revisionIdList,1)
		}
		else
		{
			s revisionID = $list(revisionIdList,(rIdsll-1))
		}
	}
	q:(revisionID = "") "0:缺少参数"
	
	s rowID = $o(^DHCEMRI.RevisionLogI("IdxMain",AInstanceID,revisionID,""))
 
 	//存在需要更新数据的情况
	if (rowID = "")
	{
		s objRevisionLog = ##class(EMRinstance.RevisionLog).%New()
	}
	else
	{
		s objRevisionLog = ##class(EMRinstance.RevisionLog).%OpenId(rowID)
	}
	
		s objRevisionLog.InstanceID = objInstance
		s objRevisionLog.RevisionID = revisionID
		s sc = revisionsData.EvaluateExpression("/revisions/r["_finNum_"]","@time-started",.result)
		q:($$$ERROR(sc)||(result.GetAt(1)="")) "" 
		s timeStamp = result.GetAt(1).Value
		s objRevisionLog.TimeStamp = timeStamp
		s revisionDateTime = ##class(EMRservice.Tools.Tool).TimestampToDateTime(timeStamp,"s")
		s objRevisionLog.RevisionDate = $p(revisionDateTime,",",1)
		s objRevisionLog.RevisionTime = $p(revisionDateTime,",",2)
		s sc = revisionsData.EvaluateExpression("/revisions/r["_finNum_"]","@revision-key",.result)
		q:($$$ERROR(sc)||(result.GetAt(1)="")) ""
		
		s revisionUserID = result.GetAt(1).Value
		s objSSUser = ##class(User.SSUser).%OpenId(revisionUserID)
		s objRevisionLog.UserID = objSSUser
		
		
		//revisionDetail, json格式：{章节编码:章节内留痕信息,章节编码:章节内留痕信息}
		
	    s revisionDetail = ##class(%GlobalBinaryStream).%New()
	    if (DocumentType = "DOC")
	    {
			d ..GetWordRevisionData(streamNInstanceData, revisionID, .revisionDetail)
			
	    }
	    if (DocumentType= "GRID")
	    {
		    d ..GetGridRevisionData(streamNInstanceData, revisionID, .revisionDetail)
			
	    }
	   	q:(revisionDetail.Size<4) "0:没有留痕信息"
		d objRevisionLog.InstanceData.CopyFrom(revisionDetail)
		s scRevisionLog = objRevisionLog.%Save()
		
		if ($$$ISERR(scRevisionLog))
		{
			s rtn = "-1:error"
			q rtn
		}
		
		d objRevisionLog.%Close(),objSSUser.%Close()
		k objRevisionLog,objSSUser
	

	
	
    d objInstance.%Close()
    k objInstance       
    q rtn
}

/// s a=##class(%GlobalBinaryStream).%New()
/// s b=##class(%GlobalBinaryStream).%New()
/// d ##class(EMRservice.Tools.DailyWorkTool).GetRevisionData(a,1,.b)
/// w b.Read(32000)
ClassMethod GetWordRevisionData(AStreamNInstanceData As %GlobalBinaryStream, ARevisionId As %String, ByRef AOutputStream As %GlobalBinaryStream) As %Stream
{
		
	s detailJson={}
	
	//移除字符串 xmlns="http://www.abisource.com/awml.dtd"
	s streamAftNInstanceData = ##class(%GlobalBinaryStream).%New()
	s removeString = "xmlns=""http://www.abisource.com/awml.dtd"""
	d streamAftNInstanceData.CopyFrom(..ParserStreamRemoveString(AStreamNInstanceData,removeString))
	
	s sc1 = ##class(%XML.XPATH.Document).CreateFromStream(streamAftNInstanceData,.ninstanceData)
	//容错
	if ($$$ISERR(sc1))
	{
		d AOutputStream.Write(detailJson.%ToJSON())
		q
	}
	if (ninstanceData="")
	{
		d AOutputStream.Write(detailJson.%ToJSON())
		q
	}
	s sc2 = ninstanceData.EvaluateExpression("/NInstanceData/abiword","//bookmark|//c",.pResults)
	//容错
	if ($$$ISERR(sc2))
	{
		d AOutputStream.Write(detailJson.%ToJSON())
		q
	}
	
	
	For tI=1:1:pResults.Count()
    {
        Set tResult=pResults.GetAt(tI)
        
        if (tResult.Type=2)
        {
            
            While tResult.Read()
            {   
                If tResult.NodeType="element"
                {
                    //tResult.Name  
                    if (tResult.Name = "bookmark")
                    {
	                	
                        Do tResult.MoveToAttributeIndex(1)
                        
                        if (tResult.Name = "usage")
                        {
                        	s bkmkusage = tResult.Value
							//1.章节编码   3.标题信息（处理修改日期的留痕信息）
							continue:((bkmkusage'="1")&&(bkmkusage'="3"))

                        }
                        
                        Do tResult.MoveToAttributeIndex(2)
                        
                        if (tResult.Name = "type")
                        {
                        	s bkmkusage = tResult.Value
                        	continue:(bkmkusage'="start")

                        }
                        
                         Do tResult.MoveToAttributeIndex(3)
                        if (tResult.Name = "name")
                        {
                        	s sectionInfo = tResult.Value	                        	
                        	s sectionCode = $p(sectionInfo,"^",2)
							//w !,sectionCode
							
							
                        }
                           
	                }
                    elseif (tResult.Name = "c")
                    {
	                    If tResult.HasAttributes 
	                    {
	                        For tJ=1:1:tResult.AttributeCount
	                        {
	                            Do tResult.MoveToAttributeIndex(tJ)
	                            
	                            if (tResult.Name = "revision")
	                            {
		                        	s clabelRevisionValue = tResult.Value
		                        	
		                        	s itemFinalRevisionId = $p($p(clabelRevisionValue,",",$l(clabelRevisionValue,",")),"{",1)
									if (( itemFinalRevisionId = ARevisionId )||( itemFinalRevisionId = -ARevisionId ))
									{
										d tResult.MoveToElement()
										
										//组合 <c> 标签信息
										s tagName = tResult.LocalName
										s tagInfo = "<"_tagName
										For subtagpros=1:1:tResult.AttributeCount
				                        {
				                            Do tResult.MoveToAttributeIndex(subtagpros)
				                            s tagInfo = tagInfo_" "_tResult.Name_"="""_tResult.Value_""""
				                        }
										s tagInfo = tagInfo_">"
										
										d tResult.MoveToElement()
										d tResult.Read()
										
					                    Set tValue=tResult.Value
					                    
					                    s revisionDetail=##class(%GlobalBinaryStream).%New()
					                	//c标签内容超32k 兼容方案，暂时不需要
					                	d revisionDetail.Write(tagInfo)
					                    If $IsObject(tValue){
					                        d revisionDetail.CopyFrom(tValue)
					                    } else {
					                        
					                        d revisionDetail.Write(tValue)
					                    }
					                    d revisionDetail.Write("</"_tagName_">")
					                    s:($g(sectionCode)="") sectionCode= "errorSection"
					                    d detailJson.%Set(sectionCode,detailJson.%Get(sectionCode)_revisionDetail.Read(32000))
					                    
									}


		                        }
	                        }
	                    }
                    }
                } 
            }
        } 
    }
	d AOutputStream.Write(detailJson.%ToJSON())
}

/// s a=##class(%GlobalBinaryStream).%New()
/// s b=##class(%GlobalBinaryStream).%New()
/// d ##class(EMRservice.Tools.DailyWorkTool).GetGridRevisionData(a,1,.b)
/// w b.Read(32000)
ClassMethod GetGridRevisionData(AStreamNInstanceData As %GlobalBinaryStream, ARevisionId As %String, ByRef AOutputStream As %GlobalBinaryStream) As %Stream
{
	s detailJson={}
	s sc1 = ##class(%XML.XPATH.Document).CreateFromStream(AStreamNInstanceData,.ninstanceData)
	//容错
	if ($$$ISERR(sc1))
	{
		d AOutputStream.Write(detailJson.%ToJSON())
		q
	}
	//容错
    if (ninstanceData="")
	{
		d AOutputStream.Write(detailJson.%ToJSON())
		q
	}
    s sc2 = ninstanceData.EvaluateExpression("/NInstanceData/iEditor","//Object",.pResults)
	//容错
	if ($$$ISERR(sc2))
	{
		d AOutputStream.Write(detailJson.%ToJSON())
		q
	}
	
	s tmpEleCode = ""
	
	For tI=1:1:pResults.Count()
    {
        Set tResult=pResults.GetAt(tI)
        
        if (tResult.Type=2)
        {
            
            While tResult.Read()
            {   
                If tResult.NodeType="element"
                {		
                			
					s tagName = tResult.LocalName
					
					if (tagName="Object")
					{						
	                    Do tResult.MoveToAttributeName("Code")
	                    s tmpEleCode=tResult.Value
	                    continue
					}
					
					if (tagName="Revision")
					{
						//组合 <Revision> 标签信息
						//s tagName = tResult.LocalName
						
						Do tResult.MoveToAttributeName("ID")
						s revisionID=tResult.Value
						continue:(revisionID'=ARevisionId)
						Do tResult.MoveToElement()
						
						s tagName = tResult.LocalName				
						s tagInfo = "<"_tagName
						For subtagpros=1:1:tResult.AttributeCount
	                    {
	                        Do tResult.MoveToAttributeIndex(subtagpros)
	                        s tagInfo = tagInfo_" "_tResult.Name_"="""_tResult.Value_""""
	                    }
						s tagInfo = tagInfo_"/>"

	                    s revisionDetail=##class(%GlobalBinaryStream).%New()
	                	d revisionDetail.Write(tagInfo)
	                   
	                    d detailJson.%Set(tmpEleCode,detailJson.%Get(tmpEleCode)_revisionDetail.Read(32000))
					}

                } 
            }
        } 
    }
    
	d AOutputStream.Write(detailJson.%ToJSON())
}

/// Creator：      lifengbo
/// CreatDate：    2014-1-25
/// Description:   移除XML中影响解析的字符串
/// Table：        
/// Input：        Stream :实例数据流
/// Return：       移除指定字符串后的流数
/// Others：       
/// Debug:         w ##Class(EMRservice.Parser.StreamData).ParserStreamRemoveString()	
ClassMethod ParserStreamRemoveString(argstream As %GlobalBinaryStream, argString As %String) As %GlobalBinaryStream
{

	s ReturnValue=##Class(%GlobalBinaryStream).%New()
		
	s templatestream=##Class(%GlobalBinaryStream).%New()
	d templatestream.CopyFrom(argstream)
	d templatestream.Rewind()

	s endLocation=-1
	s reStartLocation=-1
	
	s endLocation = templatestream.FindAt("-1",argString)
	s reStartLocation = endLocation+$l(argString)
	q:((endLocation=-1)&&(reStartLocation=-1)) ReturnValue
	
	s Readlen1 = endLocation-1
	s Readlen2 = templatestream.Size - reStartLocation+1
	
	d templatestream.Rewind()
	
	if (Readlen1>32000)
	{
		s tmplen=0
		s count=+Readlen1\32000
		
		for i=1:1:count
		{	
			d ReturnValue.Write(templatestream.Read(32000))
			s tmplen=32000*i
		}
		s lastlen=+Readlen1-tmplen
		d ReturnValue.Write(templatestream.Read(lastlen))
	}
	else
	{
		d ReturnValue.Write(templatestream.Read(Readlen1))
	}
	
	d templatestream.MoveTo(reStartLocation)
	
	if (Readlen2>32000)
	{
		s tmplen=0
		s count=+Readlen2\32000
		
		for i=1:1:count
		{	
			d ReturnValue.Write(templatestream.Read(32000))
			s tmplen=32000*i
		}
		s lastlen=+Readlen2-tmplen
		d ReturnValue.Write(templatestream.Read(lastlen))
	}
	else
	{
		d ReturnValue.Write(templatestream.Read(Readlen2))
	}
	
	q ReturnValue
}

/// Desc:       保存病历修改历史
/// Creator:    Lifengbo
/// Createdate: 2022-05-09
/// Input:      AInstanceID 实例数据ID
/// Output:     rtn 0缺少参数,1成功,-1失败
/// Debug:      w ##Class(EMRservice.BL.RevisionLog).SaveRevisionLog("58||3")
ClassMethod SaveRevisionLogNewBatch(AInstanceID As %String, AStream As %GlobalBinaryStream = "", AIsCompressDocument As %String = "") As %String
{
    s rtn = "1"
    q:(AInstanceID = "") "0:缺少参数"
    s objInstance = ##class(EMRinstance.InstanceData).%OpenId(AInstanceID)
    q:(objInstance = "") "0"
   
    //DOC GRID
    s DocumentType = objInstance.TheECRecord.DocumentType
    
    if (AIsCompressDocument="")
    {
		s AIsCompressDocument=##class(EMRservice.BL.BLInstanceDataCompressInfo).GetIsCompressByInstanceID(AInstanceID)
	}
	
    if (AIsCompressDocument="TRUE")
    {
	    if (AStream'="")
	    {
	   		s streamNInstanceData = ##Class(EMRservice.Parser.StreamData).ParserStream(AStream,"<NInstanceData","</NInstanceData>","16")
	    }
	}
    else
    {
	    //增加后台解压处理
	    s IsBKCompress=##class(EMRservice.BL.BLInstanceDataCompressInfo).GetIsBKCompressByInstanceID(AInstanceID)
	    if (IsBKCompress="1")
	    {
	    	s tempInstanceData = ##class(EMRservice.Parser.StreamData).DeCompressStream(objInstance.InstanceData)
	    	s streamNInstanceData = ##Class(EMRservice.Parser.StreamData).ParserStream(tempInstanceData,"<NInstanceData","</NInstanceData>","16")
	    
	    }
	    else
	    {
    		s streamNInstanceData = ##Class(EMRservice.Parser.StreamData).ParserStream(objInstance.InstanceData,"<NInstanceData","</NInstanceData>","16")
	    }
    	
    }
    s streamRevisionsData = ##Class(EMRservice.Parser.StreamData).ParserStream(streamNInstanceData,"<revisions","</revisions>","12")
    q:(streamRevisionsData.Size = 0) "0:没有留痕信息"
    
    s sc = ##class(%XML.XPATH.Document).CreateFromStream(streamRevisionsData,.revisionsData)
    
    q:($$$ERROR(sc)) "-1:revisionsData"
    s sc = revisionsData.EvaluateExpression("/revisions","count(r)",.rData)
    
    q:($$$ERROR(sc)||(rData.GetAt(1)="")) "-1:rData"
    s count = rData.GetAt(1).Value
    q:(count = 0) "0:没有留痕信息"
   	//取最后数据(分析XML，Grid模板留痕信息会额外多出2个revisionId,所以Grid的FinNum = count-1
	//s finNum=$case(DocumentType,"WORD":count,"GRID":count-1)
	//s finNum=$case(DocumentType,"WORD":count,"GRID":count-1)
	
	for verIdnum=1:1:count
	{
		s revisionID=""
		
		if (DocumentType="DOC")
		{
			s finNum= verIdnum
			s sc = revisionsData.EvaluateExpression("/revisions/r["_finNum_"]","@id",.result)
			continue:($$$ERROR(sc)||(result.GetAt(1)="")) 
			s revisionID = result.GetAt(1).Value
		}
		
		
		if (DocumentType="GRID")
		{
			s revisionIdList=""
			for finNum=1:1:verIdnum
			{
				s sc = revisionsData.EvaluateExpression("/revisions/r["_finNum_"]","@id",.result)
				continue:($$$ERROR(sc)||(result.GetAt(1)=""))
				s revisionIdList = revisionIdList_$lb(result.GetAt(1).Value)
			}
			//获取倒数第三个id作为RevisionID
			s rIdsll= $ll(revisionIdList)
			if (rIdsll=1)
			{
				s revisionID = $list(revisionIdList,1)
			}
			else
			{
				s revisionID = $list(revisionIdList,(rIdsll-1))
			}
		}
		continue:(revisionID = "") //"0:缺少参数"
		
		s rowID = $o(^DHCEMRI.RevisionLogI("IdxMain",AInstanceID,revisionID,""))
	 
	 	//存在需要更新数据的情况
		if (rowID = "")
		{
			s objRevisionLog = ##class(EMRinstance.RevisionLog).%New()
		}
		else
		{
			s objRevisionLog = ##class(EMRinstance.RevisionLog).%OpenId(rowID)
		}
		
		s objRevisionLog.InstanceID = objInstance
		s objRevisionLog.RevisionID = revisionID
		s sc = revisionsData.EvaluateExpression("/revisions/r["_finNum_"]","@time-started",.result)
		continue:($$$ERROR(sc)||(result.GetAt(1)="")) 
		s timeStamp = result.GetAt(1).Value
		s objRevisionLog.TimeStamp = timeStamp
		s revisionDateTime = ##class(EMRservice.Tools.Tool).TimestampToDateTime(timeStamp,"s")
		s objRevisionLog.RevisionDate = $p(revisionDateTime,",",1)
		s objRevisionLog.RevisionTime = $p(revisionDateTime,",",2)
		s sc = revisionsData.EvaluateExpression("/revisions/r["_finNum_"]","@revision-key",.result)
		continue:($$$ERROR(sc)||(result.GetAt(1)="")) 
		
		s revisionUserID = result.GetAt(1).Value
		s objSSUser = ##class(User.SSUser).%OpenId(revisionUserID)
		s objRevisionLog.UserID = objSSUser
		
		
		//revisionDetail, json格式：{章节编码:章节内留痕信息,章节编码:章节内留痕信息}
		
	    s revisionDetail = ##class(%GlobalBinaryStream).%New()
	    if (DocumentType = "DOC")
	    {
			d ..GetWordRevisionData(streamNInstanceData, revisionID, .revisionDetail)
			
	    }
	    if (DocumentType= "GRID")
	    {
		    d ..GetGridRevisionData(streamNInstanceData, revisionID, .revisionDetail)
			
	    }
	    continue:(revisionDetail.Size<4)
		d objRevisionLog.InstanceData.CopyFrom(revisionDetail)
		s scRevisionLog = objRevisionLog.%Save()
		
		if ($$$ISERR(scRevisionLog))
		{
			s rtn = "-1:error"
			continue
		}
		
		d objRevisionLog.%Close(),objSSUser.%Close()
		k objRevisionLog,objSSUser
	}

	
	
    d objInstance.%Close()
    k objInstance       
    q rtn
}

/// desc：批量清除留痕信息为空的数据
/// creator：lifengbo
/// debugger：w ##class(EMRservice.BL.RevisionLog).ModifyRevisionData()
ClassMethod ModifyRevisionData() As %String
{
	s $zt="error"
	s count=0
	s total=0
	s tmpId=""
	for
	{
		s tmpId = $o(^DHCEMRI.RevisionLogD(tmpId))
		q:(tmpId="")
		s total= +$g(total)+1
		if (total#100=0)
		{
			w (total\100),!
		}
		s obj=##class(EMRinstance.RevisionLog).%OpenId(tmpId)
		continue:(obj="")
		
		s sc=""
		
		if (obj.InstanceData.Size<6)
		{
			s sc = ##class(EMRinstance.RevisionLog).%DeleteId(tmpId)
			
		}
		
		if ($$$ISOK(sc))
		{
			s count=+$g(count)+1
			continue
		}
	}
	q "total count:"_total_",delete count:"_count
error
	s $zt=""
	s errorMsg=$ze
	q errorMsg
}

}
