Class EMRservice.InterfaceService.EMRRecordInfo Extends %RegisteredObject
{

/// Desc:限定文档，指定日期是否完成打印
/// lifengbo 20200210
/// 入参：AEpisodeID：当前就诊号
/// 		 ADocID：文档展现ID；
/// 		 ADate：指定日期，默认当前日期。
/// return：	hasPrinted,unPrinted
/// Debugger:
/// 			s ret=##class(EMRservice.InterfaceService.EMRRecordInfo).GetDocumentPrintStatus(10069341,682,+$h)
/// 			s ret=##class(EMRservice.InterfaceService.EMRRecordInfo).GetDocumentPrintStatus(10069341,682,+$h)
ClassMethod GetDocumentPrintStatus(AEpisodeID As %String, ADocID As %String = "", ADate As %String = "") As %String
{
	s errorParames=0
	
	s hasPrinted=1
	
	s unPrinted=0
	
	q:(ADocID="") errorParames
	//默认当前日期
	s:(ADate="") ADate=+$h
	
	s patienID= $p($g(^PAADM(AEpisodeID)),"^",1)
	q:(patienID="") errorParames
	
	s result=unPrinted
	
	s tmpEpisodeID=""
	for
	{
		s tmpEpisodeID=$o(^PAPERdr(patienID,"ADM","O",tmpEpisodeID))
		q:(tmpEpisodeID="")
		
		s IsFinished = ..IsEpisodeIDHasFinished(tmpEpisodeID,ADocID,ADate,"print")
		continue:(IsFinished=0)
		s result= hasPrinted
		q
	}
	
	q result
}

/// /
/// /return:0,无符合条件文档  1，有符合条件文档
/// debugger:
/// w ##class(EMRservice.InterfaceService.EMRRecordInfo).IsEpisodeIDHasFinished(10069341,682,+$h,"print")
/// w ##class(EMRservice.InterfaceService.EMRRecordInfo).IsEpisodeIDHasFinished(10069341,682,+$h,"save")
ClassMethod IsEpisodeIDHasFinished(AEpisodeID As %String, ADocID As %String, ADate As %String, AAction As %String) As %String
{
	
	s result=0
	s TheECRecord=""
	s TheECRecord = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeID,ADocID,TheECRecord))
	q:(TheECRecord="") result
	
	s objECRecord = ##class(EMRinstance.ECRecord).%OpenId(TheECRecord)
	
	for i=1:1:objECRecord.Instances.Count()
	{
		s objInstance = objECRecord.Instances.GetAt(i)
		continue:(objInstance.CreateDate '=ADate) 
		
		continue:(objInstance.Status '="Save") 
		
		//Index IdxMain On (EpisodeID, EMRDocID, EMRNum) [ Unique ];
		s EMRLogs =""
		s EMRLogs = $o(^DHCEMRI.EMRLogsI("IdxMain",AEpisodeID,ADocID,i,EMRLogs))
		continue:(EMRLogs ="") 
		
		s objEMRLogs = ##class(EMRinstance.EMRLogs).%OpenId(EMRLogs)
		continue:(objEMRLogs="")
		
		s log = objEMRLogs.InstanceLog
		for j=log.Count():-1:1
		{ 
			s objlog = log.GetAt(j)
			continue:(objlog.Action '=AAction)
			continue:(objlog.OperateDate '= ADate)
			s result = 1
		
		}
		q:(result = 1)
	}
	q result
}

/// Creator:lifengbo
/// 描述：通过术语集，获取患者历次就诊指定文书数据项
/// 20200310
/// 入参：	PatientID，
/// 			ADataConfig：术语集配置，目录|项目^项目^项目
/// 			ASeq：显示顺序，默认倒序
/// 返回值：
/// 	返回值按照术语集配置顺序返回数据
/// 	2020-02-02 09:00^2020-02-22 09:00^内分泌科^肺部恶性肿瘤$2020-01-02 09:00^2020-01-22 09:00^内分泌科^肺部恶性肿瘤
/// 	##class(EMRservice.InterfaceService.EMRRecordInfo).GetHistoryEMRContentInfo("148","HDSD00.11|HDSD00.11.010","DESC")
/// 		##class(EMRservice.InterfaceService.EMRRecordInfo).GetHistoryEMRContentInfo("1","HDSD00.11|HDSD00.11.010","DESC")
ClassMethod GetHistoryEMRContentInfo(APatientID As %String, ADataConfig As %String, ASeq = "DESC") As %String
{
	// ADataConfig = HDSD00.11|HDSD00.11.010^HDSD00.11.009
	
	//入参为登记号
	//s PatientID = $o(^PAPERi("PAPMI_PatNo",ARegNo,PatientID))
	//入参为PatientID
	s PatientID = APatientID
	
	s EpisodeID = "",retList=""
	for 
	{
		s EpisodeID =$o(^PAPERdr(PatientID,"ADM","I",EpisodeID),$case($zcvt(ASeq,"U"),"DESC":-1,"ASC":1,:-1))
		q:(EpisodeID="")
		
		s tmpString=""
		s tmpString = ..GetPathologyDiagInfo(EpisodeID,ADataConfig)
		continue:(tmpString="")
		s retList = retList_$lb(tmpString)
		
		
	}
	s ret = $lts(retList,"$")
	q ret
}

/// Creator:lifengbo
/// 描述：通过术语集，获取患者历次就诊指定文书数据项
/// 20200310
ClassMethod GetPathologyDiagInfo(AEpisodeID As %String, ADataConfig As %String) As %String
{
	s ret = ""
	s GlossaryCategoryInternalID = $p(ADataConfig,"|",1)
	s GlossaryInteralIDs = $p(ADataConfig,"|",2)
	
	//HDSD00.11.010|DE05.01.025.00|病理诊断名称||各种活检、细胞学检查及尸检的诊断，包括术中冰冻的病理诊断结果||||
	//HDSD00.11.009|DE05.01.024.00|病理诊断疾病编码||病理诊断在特定编码体系中的编码||||
	//HDSD00.11.008|DE01.00.005.00|病理号||按照一定的编码规则赋予病理标本的编号||||
	
	s arr=##class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossary(AEpisodeID,GlossaryCategoryInternalID)
	q:(arr="") ret
	s retValueList = ""
	
	for i=1:1:$l(GlossaryInteralIDs,"^")
	{
		s glossaryInternalID = $p(GlossaryInteralIDs,"^",i)
		
		s tmpValue=""
		s tmpValue = arr.GetAt(glossaryInternalID)
		continue:((tmpValue="")||(tmpValue="-"))
		s retValueList = retValueList_$lb(tmpValue)
	}
	
	s ret = $lts(retValueList,"^")
	q ret
}

/// debug result = ##class(EMRservice.InterfaceService.EMRRecordInfo).GetDocumentContent("1||1").Read(32000)
/// debug result = ##class(EMRservice.InterfaceService.EMRRecordInfo).GetDocumentContent("7||1").Read(32000)
/// debug result = ##class(EMRservice.InterfaceService.EMRRecordInfo).GetDocumentContent("110||4").Read(32000)
ClassMethod GetDocumentContent(AInstanceID As %String, AFilterSectionCode As %String = "") As %Stream
{
	 ///默认不单独获取子章节数据，个别插件版本主章节打散未包含子章节数据，则修改下面的变量值为1
    s isGetChildSecData = "0"
	s streamContent = ##class(%GlobalBinaryStream).%New()
	
	q:AInstanceID="" streamContent
	
	s objInstance = ##class(EMRinstance.InstanceData).%OpenId(AInstanceID)
	q:objInstance="" streamContent
	
	s templateId = objInstance.RealTemplateID
	s templateversion = objInstance.TemplateVersion
	s EpisodeID = objInstance.RealEpisodeID
	
	s templateversionId=""
	s templateversionId = $o(^DHCEMRM.TemplateVersionI("IndexTemplateVersion"," "_templateId,templateversion,templateversionId))
	s objTempalteVersion = ##class(EMRmeta.TemplateVersion).%OpenId(templateversionId)
	
	s streamMetaData = objTempalteVersion.MetaData
	q:(streamMetaData.Size <= 0) streamContent
	
	s sc =##class(%XML.XPATH.Document).CreateFromStream(streamMetaData,.metaData)
	q:($$$ERROR(sc)) streamContent
	
	s sc = metaData.EvaluateExpression("/MetaData/Component","count(Section)",.sections)
	q:($$$ERROR(sc)||(sections.GetAt(1)="")) streamContent
	s count = sections.GetAt(1).Value
	
	s footer = ""
	for i=1:1:count
	{
		set sc=metaData.EvaluateExpression("/MetaData/Component/Section["_i_"]/Code","@DisplayName",.result)
		continue:($$$ERROR(sc)||(result.GetAt(1)=""))		
		s sectionName = result.GetAt(1).Value	
		s:(sectionName'["：") sectionName= sectionName_"："
	
		set sc=metaData.EvaluateExpression("/MetaData/Component/Section["_i_"]/Code","@Code",.result)
		continue:($$$ERROR(sc)||(result.GetAt(1)=""))		
		s sectionCode = result.GetAt(1).Value
		continue:(sectionCode'="")&&(AFilterSectionCode'="")&&($f($zcvt("^"_AFilterSectionCode_"^","U"),$zcvt("^"_sectionCode_"^","U"))>0)
		
		if ($zcvt(sectionCode,"U") = "FOOTER") 
		{
			s footer = sectionName
		}
		else
		{
			d streamContent.Write(sectionName)
		}


        if (isGetChildSecData = "1")
        {
            s childSc = metaData.EvaluateExpression("/ScatterData/Component/Section["_i_"]/Component","count(Section)",.childSections)
            continue:($$$ERROR(childSc)||(childSections.GetAt(1)=""))
            s childCount = childSections.GetAt(1).Value
           
            if (childCount '= "")
            {
                for j=1:1:childCount
                {
                    set sc=metaData.EvaluateExpression("/MetaData/Component/Section["_i_"]/Component/Section["_j_"]/Code","@DisplayName",.result)
                    continue:($$$ERROR(sc)||(result.GetAt(1)=""))		
                    s sectionName = result.GetAt(1).Value	
                    s:(sectionName'["：") sectionName= sectionName_"："
                    d streamContent.Write(sectionName)
                    
                    set sc=metaData.EvaluateExpression("/MetaData/Component/Section["_i_"]/Component/Section["_j_"]/Code","@Code",.result)
                    continue:($$$ERROR(sc)||(result.GetAt(1)=""))		
                    s sectionCode = result.GetAt(1).Value	
                    
                    continue:(sectionCode'="")&&(AFilterSectionCode'="")&&($f($zcvt("^"_AFilterSectionCode_"^","U"),$zcvt("^"_sectionCode_"^","U"))>0)
                    
                    s rowId = ..GetSectionID(EpisodeID,templateId,sectionCode,AInstanceID)	
                    s sectionValue = ##class(EMRservice.BL.BLScatterData).GetSectionData(rowId,"V")
	
                    d streamContent.Write($zstrip(sectionValue,"*C"))
                    d streamContent.Write($c(10,13))
                }
            }

            
        }
		
        s rowId = ..GetSectionID(EpisodeID,templateId,sectionCode,AInstanceID)		
		s sectionValue = ##class(EMRservice.BL.BLScatterData).GetSectionData(rowId,"V")
		//w !,sectionValue
		
		if ($zcvt(sectionCode,"U") = "FOOTER")
		{
			s footer = footer_$zstrip(sectionValue,"*C")
			continue
		}
		
		d streamContent.Write($zstrip(sectionValue,"*C"))
		d streamContent.Write($c(10,13))
	}
	d streamContent.Write(footer)
	q streamContent
}

/// Desc:       返回GetSectionDesc的rowID
/// Creator:    Candy
/// CreateDate: 2014-7-24
/// Input:      AEpisodeID 就诊号
///             ATemplateID 模板ID
///             ACode 单元代码(路径)
///             AInstanceID 就诊号
/// Return:     EMRinstance.ISectionDesc 的 rowID
/// Debug:      w ##Class(EMRservice.BL.BLScatterData).GetSectionID(76,2,"Code:S001","")
ClassMethod GetSectionID(AEpisodeID As %String, ATemplateID As %String, ACode As %String, AInstanceID As %String) As %String
{
	s result = ""
	q:((AEpisodeID = "")||(ATemplateID = "")||(ACode = "")) result
	s sCode = ACode
	s SCode = $zcvt(sCode,"U")
	if (AInstanceID = "")
	{
		s instanceId = ""
		for
		{
			s instanceId = $o(^DHCEMRI.ISectionDescI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_SCode,instanceId),-1)
			q:(instanceId = "")
			s tmpInstanceId = $tr(instanceId," ","")
			s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(tmpInstanceId)
			continue:(objInstance = "")
			q:($zcvt(objInstance.Status,"U") = "SAVE")
		}		
	}
	else
	{
		s instanceId = " "_AInstanceID
	}
	q:(instanceId = "") result
	s result = $o(^DHCEMRI.ISectionDescI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_SCode,instanceId,""),-1)
	q result
}

/// debug result = ##class(EMRservice.InterfaceService.EMRRecordInfo).GetElementtNameByCode("110||4","S002")
/// debug result = ##class(EMRservice.InterfaceService.EMRRecordInfo).GetElementtNameByCode("110||4","O0002")
ClassMethod GetElementtNameByCode(AInstanceID As %String, ACode As %String) As %String
{
	 ///默认不单独获取子章节数据，个别插件版本主章节打散未包含子章节数据，则修改下面的变量值为1
    s isGetChildSecData = "0"
	s DisplayName = ""
	
	q:AInstanceID="" streamContent
	
	s objInstance = ##class(EMRinstance.InstanceData).%OpenId(AInstanceID)
	q:objInstance="" streamContent
	
	s templateId = objInstance.RealTemplateID
	s templateversion = objInstance.TemplateVersion
	s EpisodeID = objInstance.RealEpisodeID
	
	s templateversionId=""
	s templateversionId = $o(^DHCEMRM.TemplateVersionI("IndexTemplateVersion"," "_templateId,templateversion,templateversionId))
	s objTempalteVersion = ##class(EMRmeta.TemplateVersion).%OpenId(templateversionId)
	
	s streamMetaData = objTempalteVersion.MetaData
	q:(streamMetaData.Size <= 0) streamContent
	
	s sc =##class(%XML.XPATH.Document).CreateFromStream(streamMetaData,.metaData)
	q:($$$ERROR(sc)) streamContent
	

	s sc = metaData.EvaluateExpression("/MetaData/Component","count(Section)",.sections)
	q:($$$ERROR(sc)||(sections.GetAt(1)="")) DisplayName
	s count = sections.GetAt(1).Value
	for i=1:1:count
	{
		if ((ACode["S")||(ACode["H")||(ACode["F"))
		{
			set sc=metaData.EvaluateExpression("/MetaData/Component/Section["_i_"]/Code","@Code",.result)
			continue:($$$ERROR(sc)||(result.GetAt(1)=""))	
			s Code = result.GetAt(1).Value
			
			continue:(Code '= ACode) 
			set sc=metaData.EvaluateExpression("/MetaData/Component/Section["_i_"]/Code","@DisplayName",.result)
			continue:($$$ERROR(sc)||(result.GetAt(1)=""))	
			s DisplayName = result.GetAt(1).Value
			
		}
		else
		{
			s sc = metaData.EvaluateExpression("/MetaData/Component/Section["_i_"]","count(Composite)",.composites)
			continue:($$$ERROR(sc)||(composites.GetAt(1)="")) 
			s cpcount = composites.GetAt(1).Value
			for cc=1:1:cpcount
			{
				s xmlItem = ..getXmlType(ACode)
				s sc = metaData.EvaluateExpression("/MetaData/Component/Section["_i_"]/Composite["_cc_"]/SubItems","count("_xmlItem_")",.result)
				
				continue:($$$ERROR(sc)||(result.GetAt(1)=""))
				
				s total = result.GetAt(1).Value
				
				for j=1:1:total
				{
					set sc=metaData.EvaluateExpression("/MetaData/Component/Section["_i_"]/Composite["_cc_"]/SubItems/"_xmlItem_"["_j_"]/Code","text()",.result)
					
					continue:($$$ERROR(sc)||(result.GetAt(1)=""))		
					s Code = result.GetAt(1).Value
					continue:(Code '= ACode)
					
					set sc=metaData.EvaluateExpression("/MetaData/Component/Section["_i_"]/Composite["_cc_"]/SubItems/"_xmlItem_"["_j_"]/DisplayName","text()",.result)
					continue:($$$ERROR(sc)||(result.GetAt(1)=""))		
					s DisplayName = result.GetAt(1).Value
					q:(DisplayName'="")
				}
			}	
		}	
		q:(DisplayName'="")
		
	}
	q DisplayName
}

ClassMethod getXmlType(ACode As %String)
{
		s Type = $e(ACode,1)
		if (Type = "L")
		{
			s Xmltype = "MIString"	
		}
		elseif (Type = "I")
		{
			s Xmltype = "MIDictionary"
		}
		elseif (Type = "S")
		{
			s Xmltype = "MIString"
		}
		elseif (Type = "D")
		{	
		s Xmltype = "MIDateTime"			
			
		}			
		elseif (Type = "H")
		{	
		s Xmltype = "MILink"			
			
		}
		elseif (Type = "N")
		{
			s Xmltype = "MINumber"				
		}			
		elseif (Type = "O")
		{
			s Xmltype = "MIMonoChoice"		
		}
		elseif (Type = "E")
		{
			s Xmltype = "MITextDesc"		
		}
		elseif(Type = "G")
		{
			s Xmltype = "MISegment"
		}
		q Xmltype
}

}
