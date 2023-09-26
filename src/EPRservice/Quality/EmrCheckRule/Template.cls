/// Desc:界面模板逻辑 
Class EPRservice.Quality.EmrCheckRule.Template Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:		获取患者某次就诊中某个模板单元的实例数据;
/// Creator: 	Candy
/// Input:		AEpisodeID为患者就诊号;
/// 			AElementID为模板单元RowID;
/// 			AInstanceID为实例数据RowID(可重复模板单元时用);
/// Output:		result = 模板单元对应的数据
/// Debug:		w ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue("4065867","10462","34||6")
ClassMethod GetElementValue(AEpisodeID As %String, AElementID As %String, AInstanceID As %String) As %String
{
	s result = ""
	q:(AEpisodeID = "")||(AElementID = "") result
	
	//模板单元对象
	s objQualityTemplate = ##Class(EPRmeta.Quality.QualityTemplate).%OpenId(AElementID)
	q:(objQualityTemplate = "") result
	q:($zcvt(objQualityTemplate.IsActive,"U") '= "Y") result
	
	s templateId = objQualityTemplate.TemplateId
	q:(templateId = "") result
	
	s objTemplate = ##Class(EMRmeta.Template).%OpenId(templateId)
	q:(objTemplate = "") result
	
	s catalogID = objTemplate.TemplateCategoryID
	q:(catalogID = "") result
	
	s structID = $o(^DHCEPRM.QualityStructI("IdxCategoryId"," "_catalogID,""))
	q:(structID = "") result

	s objStruct = ##Class(EPRmeta.Quality.QualityStruct).%OpenId(structID)
	q:(objStruct = "") result

	q:($zcvt(objStruct.IsActive,"U") '= "Y") result
	
	if ((objStruct.ChkConditionDR '= "")&&(objStruct.ChkConditionDR '= $c(0)))
	{
	
		s flag = ##Class(EPRservice.Quality.ExpExplain.BOExplainVal).GetQualityQueryValue(AEpisodeID,objStruct.ChkConditionDR,structID)
		q:(flag = "") result
		
	}
	
	s ElementCode = objQualityTemplate.ElementCode		
	q:(ElementCode = "") result
   
	s result = ##Class(EMRservice.BL.BLScatterData).GetScatterData(AEpisodeID,ElementCode,AInstanceID)
	q result
}

/// Desc:		获取患者某次就诊中某个模板单元的实例数据;
/// Creator: 	Candy
/// Input:		AEpisodeID为患者就诊号;
/// 			AElementID为模板单元RowID;
/// 			AInstanceID为实例数据RowID(可重复模板单元时用);
/// Output:		result = 模板单元对应的数据
/// Debug:		w ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue("4065867","10462","34||6")
ClassMethod GetElementValueNew(AEpisodeID As %String, AElementID As %String, AInstanceID As %String) As %String
{
	s result = ""
	q:(AEpisodeID = "")||(AElementID = "") result
	
	//模板单元对象
	s objQualityTemplate = ##Class(CT.MA.QC.QualityTemplate).%OpenId(AElementID)
	q:(objQualityTemplate = "") result

	s GlossaryInternalID = objTemplate.GlossaryInternalID
	q:(GlossaryInternalID = "") result
	
	s ElementCode = GlossaryInternalID		
	q:(ElementCode = "") result
   
	s result = ##Class(EMRservice.BL.BLScatterData).GetScatterData(AEpisodeID,ElementCode,AInstanceID)
	q result
}

/// Desc:		唯一模板病历是否保存、完成、提交、打印、签名...
/// Creator:		Candy
/// CreateDate:	2014-9-26
/// Input:		AEpisodeID 就诊号
/// 			ATemplateCategoryID 模板目录ID
/// 				AActionType 操作类型
/// OutPut:		result 模板ID_$c(1)_操作日期_$c(1)_操作时间_$c(1)_操作者
/// Debug: w ##Class(EPRservice.Quality.EmrCheckRule.Template).GetSingleTempalteInfo(76,78,"提交")
ClassMethod GetSingleTempalteInfo(AEpisodeID As %String, ATemplateCategoryID As %String, AActionType As %String) As %String
{
	q:(AEpisodeID = "")||(ATemplateCategoryID = "") "0^配置错误"
	s result = ""
	s ECRecordID = ""
	for {
		s ECRecordID = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDCategoryID",AEpisodeID,ATemplateCategoryID,ECRecordID))  //8.5版本后索引去掉了空格
		q:(ECRecordID = "")
		s objEcrecord = ##Class(EMRinstance.ECRecord).%OpenId(ECRecordID)
		continue:(objEcrecord = "")
		s DocID = objEcrecord.ChartItemID
		s templateid=""
		for {
			s templateid=$o(^DHCEMRI.InstanceDataI("IdxEcrecordTemplateStatus",ECRecordID,templateid))
			q:templateid=""
			s SubID=""
			for {
				s SubID = $o(^DHCEMRI.InstanceDataI("IdxEcrecordTemplateStatus",ECRecordID,templateid," SAVE",SubID))
				q:(SubID="")
				s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(ECRecordID_"||"_SubID)
				continue:(objInstance = "")
				if (AActionType = "")
				{
					s result = objInstance.TemplateID_$c(1)_objInstance.CreateDate_$c(1)_objInstance.CreateTime_$c(1)_objInstance.CreateUser
				}
                                elseif(AActionType = "签名")
				{
					  s IsBSQualityEnable=##Class(EPRservice.Quality.CommonHelper).IsBSQualityEnable()  //BS版本质控维护程序是否启用
	                  if (IsBSQualityEnable="Y")
	                  {
		                  s ActionsID= $o(^CT.MA.QC.QualityParamsI("IdxCode","SignatureEMRActions",""))
		                  s:(ActionsID '= "") Actions= +$list($g(^CT.MA.QC.QualityParamsD(+ActionsID)),4)
		                  
		              }
	                  else
	                  {
		                   s ActionsID= $o(^DHCEPRM.QualityParamsI("IdxCode","SignatureEMRActions",""))
		                   s:(ActionsID '= "") Actions= +$list($g(^DHCEPRM.QualityParamsD(+ActionsID)),2)
		              }
				     
		           

					s:(ActionsID="") Actions = "INTERNCHECK"_"^"_"RESIDENTCHECK"_"^"_"ATTENDINGCHECK"_"^"_"VICECHIEFCHECK"_"^"_"CHIEFCHECK"
					s Actions="^"_Actions_"^"
					s ListNo = objInstance.ListNo
					s LogID=""
					
					s result=""
					
					for
					{
					    s LogID = $o(^DHCEMRI.EMRLogsI("IdxMain",AEpisodeID,objInstance.TheECRecord.ChartItemID,ListNo,LogID))  //8.5版本后索引去掉了空格
						q:(LogID = "")
						s objEMRLogs= ##Class(EMRinstance.EMRLogs).%OpenId(LogID)
						continue:(objEMRLogs.EMRNum'=SubID)
						s LogSubID=""
						for
						{
							s LogSubID=$o(^DHCEMRI.InstanceLogI("IdxParRef",LogID,LogSubID))
							q:LogSubID=""
							
							s objInstanceLog = ##Class(EMRinstance.InstanceLog).%OpenId(LogID_"||"_LogSubID)
						    continue:(objInstanceLog = "")
						    s action=objInstanceLog.Action
						   
						    continue:(Actions'[$zcvt(action,"U"))
						  
						    s result = objInstance.TemplateID_$c(1)_objInstanceLog.OperateDate_$c(1)_objInstanceLog.OperateTime_$c(1)_objInstanceLog.OperateUserID
							
							q:(result'="")
						}
						
						q:(result'="")
						
					
					}
					
				}
				else
				{
					s action = ##Class(EMRservice.BL.BLEMRAction).GetActionCodeByName(AActionType)
					continue:(action = "")
					s action = $zcvt(action,"U")
					s ListNo = objInstance.ListNo
					s LogID = $o(^DHCEMRI.EMRLogsI("IdxMain",AEpisodeID,DocID,ListNo,""))  //8.5版本后索引去掉了空格
					continue:(LogID = "")
					s OperDate = $o(^DHCEMRI.InstanceLogI("IdxParRefActionDateTime",LogID," "_action,""))
					continue:(OperDate = "")
					s OperTime = $o(^DHCEMRI.InstanceLogI("IdxParRefActionDateTime",LogID," "_action,OperDate,""))
					continue:(OperTime = "")
					s LogSubID = $o(^DHCEMRI.InstanceLogI("IdxParRefActionDateTime",LogID," "_action,OperDate,OperTime,""))
					continue:(LogSubID = "")
					s objInstanceLog = ##Class(EMRinstance.InstanceLog).%OpenId(LogID_"||"_LogSubID)
					continue:(objInstanceLog = "")
					s result = objInstance.TemplateID_$c(1)_objInstanceLog.OperateDate_$c(1)_objInstanceLog.OperateTime_$c(1)_objInstanceLog.OperateUserID
				}
				q
			}
			q:(result'="")	
		}
	}
	s result = $Case(result,"":"-1^",:"1^"_result)
	q result
}

ClassMethod GetInstanceDataByAction()
{
}

/// Desc:		取一个时间段内病历数据的Title、CreateDate、CreateTime、Creator,HappenDate,HappenTime等信息
/// CreateTime:	2014-09-28
/// Creator：	Candy
/// Input:		AEpisodeId: 就诊RowId
/// 			ACategoryId: 挂载目录Id，即模板所属Normal或Group类型目录的Id
/// 			AStartDate：起始日期[Cache内部格式]
/// 				AStartTime: 起始时间[Cache内部格式] 
/// 			AEndDate: 截止日期[Cache内部格式]
///             AEndTime: 截止时间[Cache内部格式]
/// 			ATitles：病历标题
/// 				ATitleCongruent 标题包含还是等于值域:(E 等于,C 包含)
/// 				AActionType 操作类型
/// Output:		TemplateID:模板ID,Title:%String,CreateUser:%String,CreateDate:%String,CreateTime:%String,HappenDate:%String,HappenTime:%String
/// Debug:	d ##class(%ResultSet).RunQuery("EPRservice.Quality.EmrCheckRule.Template","GetMultiTempalteInfo","76","81","","","","","阶段小结\接班记录","C","完成")		
Query GetMultiTempalteInfo(AEpisodeID As %String, ACategoryID As %String, AStartDate As %String, AStartTime As %String, AEndDate As %String, AEndTime As %String, ATitles As %String, ATitleCongruent As %String = "C", AActionType As %String = "") As %Query(ROWSPEC = "TemplateID:%String,Title:%String,CreateUser:%String,CreateDate:%String,CreateTime:%String,HappenDate:%String,HappenTime:%String")
{
}

ClassMethod GetMultiTempalteInfoExecute(ByRef qHandle As %Binary, AEpisodeID As %String, ACategoryID As %String, AStartDate As %String, AStartTime As %String, AEndDate As %String, AEndTime As %String, ATitles As %String, ATitleCongruent As %String = "C", AActionType As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:(AEpisodeID = "")||(ACategoryID = "") $$$OK
	
	s isTimeFilterOK = "1",dataInfo=""
	s:((AStartDate="")||(AEndDate="")||(AStartTime="")||(AEndTime="")) isTimeFilterOK = 0
	s ecRecordId = ""
	for
    {
     s ParamID = $o(^DHCEPRM.QualityParamsI("IdxCode","MutilRelationTempCategoryIDs",""))
     s:(ParamID '= "") ParamCategoryIDs= $list($g(^DHCEPRM.QualityParamsD(+ParamID)),2)
   
     s:(ParamID '= "") ParamCategoryIDList = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ParamCategoryIDs,"^")
     s:(ParamID '= "") longParamCategoryIDs="^"_ParamCategoryIDs_"^"   
     s longCategoryID="^"_ACategoryID_"^"
     
     if ((ParamID="")||( longParamCategoryIDs'[longCategoryID ))
	 {
	  s ecRecordId = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDCategoryID",AEpisodeID,ACategoryID,ecRecordId)) //8.5版本后索引去掉了空格
	  
	 }
	 else 
	 {
	   for i = 1:1:$listlength(ParamCategoryIDList) 
	   {
		 s ParamCategoryID = $listget(ParamCategoryIDList,i)
		 continue:(ParamCategoryID = "")
		
		 s:($d(^DHCEMRI.ECRecordI("IdxEpisodeIDCategoryID",AEpisodeID,ParamCategoryID))=10) ACategoryID=ParamCategoryID
	    
	   }
     s ecRecordId = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDCategoryID",AEpisodeID,ACategoryID,ecRecordId))
	 }
		q:(ecRecordId="")
		
		s templateid=""
		for {
			s templateid=$o(^DHCEMRI.InstanceDataI("IdxEcrecordTemplateStatus",ecRecordId,templateid))
			q:templateid=""
			s childSub=""
			for {
				s childSub = $o(^DHCEMRI.InstanceDataI("IdxEcrecordTemplateStatus",ecRecordId,templateid," SAVE",childSub))
				q:(childSub="")
				s instanceId = ecRecordId_"||"_childSub
				s objInstance = ##class(EMRinstance.InstanceData).%OpenId(instanceId)
				continue:(objInstance = "") 
				
				if (ATitles '= "")
				{
					s isTitleOk = 0
					s count = $l(ATitles,"\")
					for j=1:1:count
					{
						s title = $p(ATitles,"\",j)
						if (ATitleCongruent = "E")
						{
							s:(objInstance.Title = title) isTitleOk = 1
						}
						else
						{
							s:(objInstance.Title [ title) isTitleOk = 1
						}
						q:(isTitleOk = 1) 
					}
					continue:(isTitleOk = 0) 
				}
				if (AActionType = "")
				{
					if (isTimeFilterOK="1")
					{
						s isDateTime1OK = (objInstance.HappenDate > AStartDate)||((objInstance.HappenDate = AStartDate)&&(objInstance.HappenTime >= AStartTime))
						s isDateTime2OK = (objInstance.HappenDate < AEndDate)||((objInstance.HappenDate = AEndDate)&&(objInstance.HappenTime <= AEndTime))
						continue:('(isDateTime1OK && isDateTime2OK))
					}
					s dataInfo = $LB(objInstance.TemplateID,objInstance.Title,objInstance.CreateUser,objInstance.CreateDate,objInstance.CreateTime,objInstance.HappenDate,objInstance.HappenTime)
				}
			    elseif(AActionType = "签名")
				{
					
				    s ActionsID= $o(^DHCEPRM.QualityParamsI("IdxCode","SignatureEMRActions",""))
		            s:(ActionsID '= "") Actions= +$list($g(^DHCEPRM.QualityParamsD(+ActionsID)),2)

					s:(ActionsID="") Actions = "INTERNCHECK"_"^"_"RESIDENTCHECK"_"^"_"ATTENDINGCHECK"_"^"_"VICECHIEFCHECK"_"^"_"CHIEFCHECK"
					for k=1:1:$l(Actions,"^")
					{
						s Action = $p(Actions,"^",k)
						s ListNo = objInstance.ListNo
						s LogID = $o(^DHCEMRI.EMRLogsI("IdxMain",AEpisodeID,objInstance.TheECRecord.ChartItemID,ListNo,""))  //8.5版本后索引去掉了空格
						continue:(LogID = "")
						if (isTimeFilterOK = "1")
						{
							s operDate = AStartDate
							for
							{
								
								s operDate = $o(^DHCEMRI.InstanceLogI("IdxParRefActionDateTime",LogID," "_Action,operDate))
								
								q:(operDate = "")
								s operTime = $case(operDate = AStartDate,1:AStartTime,0:"")
								for
								{
								
									s operTime = $o(^DHCEMRI.InstanceLogI("IdxParRefActionDateTime",LogID," "_Action,operDate,operTime))
								
									q:((operTime = "")||((operDate = AEndDate)&&(operTime>AEndTime)))
									s LogSub = $o(^DHCEMRI.InstanceLogI("IdxParRefActionDateTime",LogID," "_Action,operDate,operTime,""))
									continue:(LogSub = "")
									s objInstanceLog = ##Class(EMRinstance.InstanceLog).%OpenId(LogID_"||"_LogSub)
									continue:(objInstanceLog = "")
									s dataInfo = $LB(objInstance.TemplateID,objInstance.Title,objInstance.CreateUser,objInstance.CreateDate,objInstance.CreateTime,objInstanceLog.OperateDate,objInstanceLog.OperateTime)
								}					
							}
						}
						else
						{
							s OperDate = $o(^DHCEMRI.InstanceLogI("IdxParRefActionDateTime",LogID," "_Action,""))
							
							continue:(OperDate = "")
							s OperTime = $o(^DHCEMRI.InstanceLogI("IdxParRefActionDateTime",LogID," "_Action,OperDate,""))
							
							continue:(OperTime = "")
							s LogSubID = $o(^DHCEMRI.InstanceLogI("IdxParRefActionDateTime",LogID," "_Action,OperDate,OperTime,""))
							
							continue:(LogSubID = "")
							s objInstanceLog = ##Class(EMRinstance.InstanceLog).%OpenId(LogID_"||"_LogSubID)
							continue:(objInstanceLog = "")
							s dataInfo = $LB(objInstance.TemplateID,objInstance.Title,objInstance.CreateUser,objInstance.CreateDate,objInstance.CreateTime,objInstanceLog.OperateDate,objInstanceLog.OperateTime)
						    q:(dataInfo'="")
						}
						
					}
				}
				elseif(AActionType = "保存")
				{
					s objEcrecord = ##Class(EMRinstance.ECRecord).%OpenId(ecRecordId)
					continue:(objEcrecord = "")
					s DocID = objEcrecord.ChartItemID
					s action = ##Class(EMRservice.BL.BLEMRAction).GetActionCodeByName(AActionType)
					continue:(action = "")
					s action = $zcvt(action,"U")
					s ListNo = objInstance.ListNo
					s LogID = $o(^DHCEMRI.EMRLogsI("IdxMain",AEpisodeID,DocID,ListNo,""))  //8.5版本后索引去掉了空格
					continue:(LogID = "")
					if (isTimeFilterOK = "1")
					{
						s operDate = AStartDate
						for
						{
							s operDate = $o(^DHCEMRI.InstanceLogI("IdxParRefActionDateTime",LogID," "_action,operDate))
							s:(operDate="") operDate = $o(^DHCEMRI.InstanceLogI("IdxParRefActionDateTime",LogID," REFERENCE",operDate))
							q:((operDate = "")||(operDate > AEndDate))
							s operTime = $case(operDate = AStartDate,1:AStartTime,0:"")
							for
							{
								s operTime = $o(^DHCEMRI.InstanceLogI("IdxParRefActionDateTime",LogID," "_action,operDate,operTime))
								q:((operTime = "")||((operDate = AEndDate)&&(operTime>AEndTime)))
								s LogSub = $o(^DHCEMRI.InstanceLogI("IdxParRefActionDateTime",LogID," "_action,operDate,operTime,""))
								continue:(LogSub = "")
								s objInstanceLog = ##Class(EMRinstance.InstanceLog).%OpenId(LogID_"||"_LogSub)
								continue:(objInstanceLog = "")
								s dataInfo = $LB(objInstance.TemplateID,objInstance.Title,objInstance.CreateUser,objInstance.CreateDate,objInstance.CreateTime,objInstanceLog.OperateDate,objInstanceLog.OperateTime)
							}
						}
					}
					else
					{
						s OperDate = $o(^DHCEMRI.InstanceLogI("IdxParRefActionDateTime",LogID," "_action,""))
						s:(operDate="") operDate = $o(^DHCEMRI.InstanceLogI("IdxParRefActionDateTime",LogID," REFERENCE",operDate))
						continue:(OperDate = "")
						s OperTime = $o(^DHCEMRI.InstanceLogI("IdxParRefActionDateTime",LogID," "_action,OperDate,""))
						continue:(OperTime = "")
						s LogSubID = $o(^DHCEMRI.InstanceLogI("IdxParRefActionDateTime",LogID," "_action,OperDate,OperTime,""))
						continue:(LogSubID = "")
						s objInstanceLog = ##Class(EMRinstance.InstanceLog).%OpenId(LogID_"||"_LogSubID)
						continue:(objInstanceLog = "")
						s dataInfo = $LB(objInstance.TemplateID,objInstance.Title,objInstance.CreateUser,objInstance.CreateDate,objInstance.CreateTime,objInstanceLog.OperateDate,objInstanceLog.OperateTime)
					}
				}
				s ^CacheTemp(repid, ind) = dataInfo
				s ind = ind + 1
			}	
		}
	}
	Quit $$$OK
}

ClassMethod GetMultiTempalteInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMultiTempalteInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod GetMultiTempalteInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMultiTempalteInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Desc:按日期类型取可重复模板数据
/// Creator:HKY
/// Createdate:2013-02-20
/// Input:	AEpisodeID    : 就诊号
/// 		ATitles       : 格式(质控结构ID|模板标题\模板标题#质控结构ID|模板标题\模板标题)
/// 		AStartDate    : 开始日期 "2009-05-23"
/// 		AStartTime    : 开始时间 "21:32:10"
/// 		AEndDate      : 结束日期 "2009-05-23"
/// 		AEndTime      : 结束时间 "21:32:10"
///         AIsEqual
///         ATimeType     : 按时间取数据（创建时间 C  发生时间 H  修改时间 M）
/// Output:	ret = 发生次数
/// Debug:w ##Class(EPRservice.Quality.EmrCheckRule.Template).GetMultiRecordByTimeType(35,"348|日常病程记录",62860,41909,62870,62082,"C","C")
/// w ##Class(EPRservice.Quality.EmrCheckRule.Template).GetMultiRecordByTimeType(4054959,"369|交班记录",63278,50700,63544,61452,"C","H")	
ClassMethod GetMultiRecordByTimeType(AEpisodeID As %String, ATitles As %String, AStartDate As %String, AStartTime As %String, AEndDate As %String, AEndTime As %String, ATitleCongruent As %String = "C", ATimeType As %String = "H", AActionType As %String = "") As %String
{

	s ret = "0^", Count = 0
	q:(AEpisodeID = "")||(ATitles = "") ret
	q:($d(AEpisodeID) = 0)||($d(ATitles) = 0) ret
	
	s flag = 0
	s lstTitles = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ATitles,"#")
	for Ind = 1:1:$listlength(lstTitles) {
		s ArrTitle = $listget(lstTitles,Ind)
		s StructID = $p(ArrTitle,"|",1)
		s Titles = $p(ArrTitle,"|",2)
		continue:(StructID = "") 
		 
		s TitleList = "", flag = 1
		s:(Titles '= "") TitleList = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(Titles,"\")
		
		s objStruct = $g(^DHCEPRM.QualityStructD(+StructID))
		s IsActive = $list(objStruct,8)
		continue:($zcvt(IsActive,"U") '= "Y")
		
		s CategoryID = $list(objStruct,5)
		s ds = ##Class(%Library.ResultSet).%New("EPRservice.Quality.EmrCheckRule.Template:GetMultiTempalteInfo")

		if (TitleList '= "")
		{
			for indSub = 1:1:$listlength(TitleList) {
				s Title = $listget(TitleList,indSub)
				continue:(Title = "")
				
				d ds.Execute(AEpisodeID,CategoryID,AStartDate,AStartTime,AEndDate,AEndTime,Title,ATitleCongruent,AActionType)
				While(ds.Next())
				{
                    s TempDate = "",TempTime = ""
                    if ($Zcvt(ATimeType,"U") = "C")   //创建时间
                    {
	                    s TempDate =ds.Data("CreateDate")
	                    s TempTime =ds.Data("CreateTime")
	                } elseif($zcvt(ATimeType,"U")= "H")    //发生时间
	                {
		                s TempDate =ds.Data("HappenDate")
	                    s TempTime =ds.Data("HappenTime")
	                
		            }                 
					continue:(TempDate = "")||(TempTime = "")
					
					//要求标题全匹配
					continue:(ATitleCongruent = "E")&&('(ds.Data("Title")=Title))
					//要求标题包含
					continue:(ATitleCongruent = "C")&&('(ds.Data("Title")[Title))
					
					s Count = Count + 1
				}
				d ds.Close()
				
			}
		}
		else
		{
			d ds.Execute(AEpisodeID,CategoryID,AStartDate,AStartTime,AEndDate,AEndTime,"")
			While(ds.Next())
			{
				
				s TempDate = "",TempTime = ""
                    if ($Zcvt(ATimeType,"U") = "C")   //创建时间
                    {
	                    s TempDate =ds.Data("CreateDate")
	                    s TempTime =ds.Data("CreateTime")
	                } elseif($zcvt(ATimeType,"U")= "H")    //发生时间
	                {
		                s TempDate =ds.Data("HappenDate")
	                    s TempTime =ds.Data("HappenTime")
	                
		            }                 
					continue:(TempDate = "")||(TempTime = "")
					//要求标题全匹配
					continue:(ATitleCongruent = "E")&&(ds.Data("Title")=Title)
					//要求标题包含
					
					continue:(ATitleCongruent = "C")&&(ds.Data("Title")[Title)
				
				s Count = Count + 1
			}
			d ds.Close()
		}
	}
	
	q:(flag '= 1) ret
	s ret = "1^"_Count
	q ret
}

/// Desc:	取可重复模板发生日期时间 "\"分割(日期和时间空格分割);
/// Creator:HKY
/// Input:	AEpisodeID	: 就诊号
/// 		ATitles		: StructID|可重复模板固定标题\可重复模板固定标题#StructID|可重复模板固定标题
/// 		AStartDate	: 开始日期 "2009-05-23"
/// 		AStartTime	: 开始时间 "21:32:10"
/// 		AEndDate	: 结束日期 "2009-05-23"
/// 		AEndTime	: 结束时间 "21:32:10"
/// Output:	ret = 发生日期时间
/// Debug:	w ##Class(EPRservice.Quality.EmrCheckRule.Template).GetMultiTemHaDateTime("2482807","337|抢救记录\交班记录","","","","")
ClassMethod GetMultiTemHaDateTime(AEpisodeID As %String, ATitles As %String, AStartDate As %String, AStartTime As %String, AEndDate As %String, AEndTime As %String, ATitleCongruent As %String = "C", AActionType As %String = "") As %String
{

	s ret = "0^"
	q:(AEpisodeID = "")||(ATitles = "") ret
	q:($d(AEpisodeID) = 0)||($d(ATitles) = 0) ret
	
	
	s flag = 0
	s UniqueKey = $i(^CacheTemp)
	k ^CacheTemp("EPRQuality","HappenDateTime",UniqueKey)
	
	s lstTitles = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ATitles,"#")
	for Ind = 1:1:$listlength(lstTitles) {
		s ArrTitle = $listget(lstTitles,Ind)
		s StructID = $p(ArrTitle,"|",1)
		s Titles = $p(ArrTitle,"|",2)
		continue:(StructID = "")
		

		s TitleList = "", flag = 1
		s:(Titles '= "") TitleList = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(Titles,"\")
		
		s objStruct = $g(^DHCEPRM.QualityStructD(StructID))
		s IsActive = $list(objStruct,8)
		continue:($zcvt(IsActive,"U") '= "Y")
		
		s CategoryID = $list(objStruct,5)
		continue:(CategoryID = "")
		
		s ds = ##Class(%Library.ResultSet).%New("EPRservice.Quality.EmrCheckRule.Template:GetMultiTempalteInfo")
		if (TitleList '= "")
		{
			for IndSub = 1:1:$listlength(TitleList) {
				s Title = $listget(TitleList,IndSub)
				continue:(Title = "")
				
				d ds.Execute(AEpisodeID,CategoryID,AStartDate,AStartTime,AEndDate,AEndTime,Title,ATitleCongruent,AActionType)
				While(ds.Next())
				{
					s HappenDate = ds.Data("HappenDate")   //发生日期
					s HappenTime = ds.Data("HappenTime")    //发生时间
					continue:(HappenDate = "")||(HappenTime = "")
					
					s HappenDateTime = $zd(+HappenDate,3)_" "_$zt(+HappenTime,2)
					
					s ^CacheTemp("EPRQuality","HappenDateTime",UniqueKey,HappenDateTime) = ""
				}
				d ds.Close()
			}
		}
		else
		{
			s ParamID = $o(^DHCEPRM.QualityParamsI("IdxCode","MutilRelationTempCategoryIDs",""))
            s:(ParamID '= "") ParamCategoryIDs= $list($g(^DHCEPRM.QualityParamsD(+ParamID)),2)
            s:(ParamID '= "") ParamCategoryIDList = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ParamCategoryIDs,"^")
            s:(ParamID '= "") longParamCategoryIDs="^"_ParamCategoryIDs_"^"   
            s longCategoryID="^"_CategoryID_"^"
           if ((ParamID="")||( longParamCategoryIDs'[longCategoryID ))
	       {
	        d ds.Execute(AEpisodeID,CategoryID,AStartDate,AStartTime,AEndDate,AEndTime,"",ATitleCongruent,AActionType)
			While(ds.Next())
			{
				s HappenDate = ds.Data("HappenDate")   //发生日期
				s HappenTime = ds.Data("HappenTime")   //发生时间
				continue:(HappenDate = "")||(HappenTime = "")
				
				s HappenDateTime = $zd(+HappenDate,3)_" "_$zt(+HappenTime,2)
				s HappenDateTime = HappenDate_" "_HappenTime
				s ^CacheTemp("EPRQuality","HappenDateTime",UniqueKey,HappenDateTime) = ""
			}
			d ds.Close()
		   }
	  
	     else 
	     {
	       for i = 1:1:$listlength(ParamCategoryIDList) 
	      {
		     s ParamCategoryID = $listget(ParamCategoryIDList,i)
		     continue:(ParamCategoryID = "")
		     d ds.Execute(AEpisodeID,ParamCategoryID,AStartDate,AStartTime,AEndDate,AEndTime,"",ATitleCongruent,AActionType)
			 While(ds.Next())
			 {
				s HappenDate = ds.Data("HappenDate")   //发生日期
				s HappenTime = ds.Data("HappenTime")   //发生时间
				continue:(HappenDate = "")||(HappenTime = "")
				
				s HappenDateTime = $zd(+HappenDate,3)_" "_$zt(+HappenTime,2)
				s HappenDateTime = HappenDate_" "_HappenTime
				s ^CacheTemp("EPRQuality","HappenDateTime",UniqueKey,HappenDateTime) = ""
			 }
			 d ds.Close()
		 }
	
	  }	
	}
}	
	q:(flag '= 1) ret
	
	s Data = ""
	s HDateTime = ""
	for {
		s HDateTime = $o(^CacheTemp("EPRQuality","HappenDateTime",UniqueKey,HDateTime)) 
		q:(HDateTime = "") 
		
		s DateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(HDateTime)
		
		s Data = Data_$lb(DateTime)
	}
	
	k ^CacheTemp("EPRQuality","HappenDateTime",UniqueKey)
	
	s:(Data '= "") Data = ##Class(EPRservice.Quality.CommonHelper).GetListToString(Data,"\")
	s ret = "1^"_Data
	q ret
}

/// Source:合肥京东方医院
/// Desc：取某个模板的实例ID
/// CreatDate:2018-11-13
/// Input:AEpisodeID 就诊号，
/// ADocIDs 模板的docID，以"#"分隔
/// OutPut:result 实例ID/实例ID
/// Debuge:w ##Class(EPRservice.Quality.EmrCheckRule.Template).GetInstanceIDByDocID(EpisodeID,"52#302","38#230")
ClassMethod GetInstanceIDByDocID(AEpisodeID As %String, ADocIDs As %String, ATemPlate As %String = "", ATitle As %String = "", ATitleCongruent As %String = "") As %String
{
    s ret = 0
    q:((AEpisodeID = "")||(ADocIDs = "")) ret
    s ret = 1
    s result = ""
    
    s idCount=$l(ADocIDs, "#")
	f i=1:1:idCount 
	{
		s docID = $p(ADocIDs, "#", i)
		s AATemPlate=$p(ATemPlate, "#", i)
		q:docID=""
		s ECRecordID = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeID,docID,""))  //8.5版本后索引去掉了空格
		continue:(ECRecordID = "")
		s happenDate = "" 
		for
		{
			s happenDate = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ECRecordID," SAVE",happenDate))
			q:(happenDate = "")
			s happenTime = ""
			for
			{
				s happenTime = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ECRecordID," SAVE",happenDate,happenTime))
				q:(happenTime = "")
				s listNo = ""
				for
				{
					s listNo = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ECRecordID," SAVE",happenDate,happenTime,listNo))
					q:(listNo = "")
					
					s instanceID = ECRecordID_"||"_listNo
					s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(instanceID)
					continue:(objInstance = "")
					S TemPlate=objInstance.TemplateID
					continue:(ATemPlate'="")&&(TemPlate'=ATemPlate)
					continue:objInstance.Status'="Save"
					if (ATitle'="")
					{
						s Title=objInstance.Title
						s isTitleOk = 0
					    s count = $l(ATitle,"\")
					    for I=1:1:count
					    {
						   s title = $p(ATitles,"\",I)
						   if (ATitleCongruent = "E")
						   {
							   s:(objInstance.Title = title) isTitleOk = 1
						    }
						    else
						    {
							   s:(objInstance.Title [ title) isTitleOk = 1
						    }
						q:(isTitleOk = 1) 
					    }
					    continue:(isTitleOk = 0) 
				     }	
					s CreateDateTime=objInstance.CreateDate
					if (result="")
					{
						s result = instanceID
					}
					else
					{
						s result = result_"\"_instanceID
					}
				
				}
			}
		}
	}
    q result
}

/// 描述：      通过InstanceIDs得到CategoryIDs
/// 入参：      AInstanceID（多个InstanceID用^拼接）
/// 出参：      CategoryIDS（多个InstanceID用^拼接）
/// Debug:		w ##Class(EPRservice.Quality.EmrCheckRule.Template).GetCategoryIDS("504||2")
ClassMethod GetCategoryIDS(AInstanceID As %String) As %String
{
	s result = ""
	s CategoryIDS=""
	
	q:(AInstanceID = "") result
	for i=1:1:$l(AInstanceID,"\")
	{
		s InstanceID=$P(AInstanceID,"\",i)
		q:InstanceID=""
		s CategoryID=$list($g(^DHCEMRI.ECRecordD($p(InstanceID,"||",1),"Instances",$p(InstanceID,"||",2))),5)
		s:CategoryIDS'="" CategoryIDS=CategoryIDS_"^"_CategoryID
		s:CategoryIDS="" CategoryIDS=CategoryID
	}
   q CategoryIDS
}

/// Debuge:w ##Class(EPRservice.Quality.EmrCheckRule.Template).GetRecordInfoByDocID(EpisodeID,"52#302","38#230")
ClassMethod GetRecordInfoByDocID(AEpisodeID As %String, ADocIDs As %String) As %String
{
    s ret = 0
    q:((AEpisodeID = "")||(ADocIDs = "")) ret
    s ret = 1
    s instanceIDs="",TemPlateIDs="",result=""
    
    s idCount=$l(ADocIDs, "^")
	f i=1:1:idCount 
	{
		s docID = $p(ADocIDs, "^", i)
		q:docID=""
		s ECRecordID = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeID,docID,""))  //8.5版本后索引去掉了空格
		continue:(ECRecordID = "")
		s happenDate = "" 
		for
		{
			s happenDate = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ECRecordID," SAVE",happenDate))
			q:(happenDate = "")
			s happenTime = ""
			for
			{
				s happenTime = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ECRecordID," SAVE",happenDate,happenTime))
				q:(happenTime = "")
				s listNo = ""
				for
				{
					s listNo = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ECRecordID," SAVE",happenDate,happenTime,listNo))
					q:(listNo = "")
					s instanceID = ECRecordID_"||"_listNo
					s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(instanceID)
					continue:(objInstance = "")
					S TemPlate=objInstance.TemplateID
					continue:objInstance.Status'="Save"
					s:instanceIDs'="" instanceIDs=instanceIDs_"\"_instanceID
					s:instanceIDs="" instanceIDs=instanceID
					s:TemPlateIDs'="" TemPlateIDs=TemPlateIDs_"\"_TemPlate
					s:TemPlateIDs="" TemPlateIDs=TemPlate
				
				}
			}
		}
	}
	s result=instanceIDs_"^"_TemPlateIDs
    q result
}

}
