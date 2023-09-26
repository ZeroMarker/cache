Class web.DHCENS.STBLL.Method.SystemStatusInfo Extends (%RegisteredObject, %XML.Adaptor)
{

// 医嘱号 部位 检查号 状态 操作人工号 操作人姓名 操作时间日期 来源系统 

// w ##class(web.DHCENS.STBLL.Method.SystemStatusInfo).UpdateSystemStatus("[{""OEOrdItemID"":""123||3"",""Position"":""右肩@@右臂"",""ExamID"":""456"",""Status"":""SC"",""UserID"":""789"",""UserName"":""demo"",""UpDateTime"":""2011-11-1 11:11:11"",""SourceSystem"":""PACS""}]")

ClassMethod UpdateSystemStatus(InputStr As %GlobalCharacterStream) As %GlobalCharacterStream
{
	
	//入参格式：[{"OEOrdItemID":"医嘱号","Position":"检查部位","ExamID":"检查号\病理标本号\检验条码号","Status":"状态","UserID":"操作人工号","UserName":"操作人姓名","UpDateTime":"操作时间日期","SourceSystem":"来源系统"}]
	//入参示例：[{"OEOrdItemID":"123||3","Position":"右肩@@右臂","ExamID":"456","Status":"SC","UserID":"789","UserName":"demo","UpDateTime":"2011-11-1 11:11:11","SourceSystem":"PACS"}]
	//入参说明：医嘱号 必填；检查部位 传部位描述，非必填，多部位时将多个部位以@@分割；检查号\病理标本号\检验条码号 必填；状态 必填；操作人工号 必填；操作人姓名 必填；更新时间日期 必填；来源系统 必填。
	//返回值格式：[{"ResultCode":"结果代码","ResultContent":"结果描述"}]
	//返回值示例：[{"ResultCode":"0","ResultContent":"成功"}]
	//返回值说明：结果代码 0成功 非0失败；结果描述 错误信息
	s $zt="GetErroMSG"
	d InputStr.Rewind()
	s InputString=InputStr.Read()
	s ResultStr=##class(%GlobalCharacterStream).%New()
	s MainErroString=""
	set tmpJSONs={}.%FromJSON(InputString)
	s count=tmpJSONs.%Size()
	i count=0
	{
		d ResultStr.Write("[{""ResultCode"":""0"",""ResultContent"":""输入为空或入参json不合法""}]")	
		q ResultStr
	}
	f i=1:1:count
	{
		s ErroString=""
		s tmpJSON=tmpJSONs.%Get(i-1)
		s OEOrdItemID=tmpJSON.%Get("OEOrdItemID")
		i OEOrdItemID=""
		{
			s ErroString=ErroString_";医嘱号不能为空"
		}
		/*
		s OEOrdID=+OEOrdItemID
		s OESubOrdID=+$p(OEOrdItemID,"||",2)
		i (OEOrdID=0)||(OESubOrdID=0)||($D(^OEORD(OEOrdID,"I",OESubOrdID))=0)
		{
			s ErroString=ErroString_";OEOrdItemID="_OEOrdItemID_" 医嘱号格式不合法或不存在此医嘱"
		}
		*/
		s Position=tmpJSON.%Get("Position")
		s ExamID=tmpJSON.%Get("ExamID")
		s Status=tmpJSON.%Get("Status")
		s Notes=tmpJSON.%Get("Notes")
		s OperateDeptCode=tmpJSON.%Get("OperateDeptCode")
		s OperateDept=tmpJSON.%Get("OperateDept")
		s ReportID=tmpJSON.%Get("ReportID")
		
		i (Status="")
		{
			s ErroString=ErroString_";状态代码为空或不存在"
		}
		else
		{
			s Status=$$ALPHAUP^SSUTIL4(Status)
		}
		s UserID=tmpJSON.%Get("UserID")
		s UserName=tmpJSON.%Get("UserName")
		i (UserName="")
		{
			s ErroString=ErroString_";操作员姓名为空"
		}
		s UpDateTime=tmpJSON.%Get("UpDateTime")
		s UpDate=$p(UpDateTime," ")
		s UpTime=$p(UpDateTime," ",2)
		i (UpDate="")||(UpTime="")
		{
			s ErroString=ErroString_";操作日期时间为空"
		}
		i (UpDate'["-")||(UpTime'[":")
		{
			s ErroString=ErroString_";操作日期时间格式不正确YYYY-MM-DD hh:mm:ss"
		}
		s ESOperateDate=$zdh($p(UpDateTime," "),3)
		s ESOperateTime=$zth($p(UpDateTime," ",2))
		s SourceSystem=tmpJSON.%Get("SourceSystem")
		i (SourceSystem="")
		{
			s ErroString=ErroString_";来源系统代码为空"
		}
		s ESSystemID=""
		s:SourceSystem'="" ESSystemID=$o(^Config.ENS.EnsSystemI("IndexEffectiveESysCode","Y",SourceSystem,""))
		i ESSystemID=""
		{
			s ErroString=ErroString_";来源系统代码不合法"
		}
		s SystemStatusLinkID=""
		s:(SourceSystem'="")&&(Status'="") SystemStatusLinkID=$o(^Config.ENS.EnsSystemLinkStatusI("IndexSysStatus",SourceSystem,Status,""))
		i SystemStatusLinkID=""
		{
			s ErroString=ErroString_";来源系统"_SourceSystem_"不包含状态"_Status
		}
		//状态顺序
		s StatusSequence=""
		s:SystemStatusLinkID'="" StatusSequence=$listget($g(^Config.ENS.EnsSystemLinkStatusD(SystemStatusLinkID)),5)
		
		//OCA状态特殊处理
		s:Status="OCA" StatusSequence=0
		s tmpPositionFlag=""
		i Position'=""
		{
			//部位排序
			k ^TMP("ENS","SubPart",$j)
			s tmpPositionCount=$l(Position,"@@")
			for k=1:1:tmpPositionCount
			{
				s tmpSubPosition=$p(Position,"@@",k)
				s ^TMP("ENS","SubPart",$j,tmpSubPosition)=""
			}
			s tmpSubPosition=""
			s tmpMainPosition=""
			for
			{
				s tmpSubPosition=$o(^TMP("ENS","SubPart",$j,tmpSubPosition))
				q:tmpSubPosition=""
				i tmpMainPosition=""
				{
					s tmpMainPosition=tmpSubPosition
				}
				else
				{
					s tmpMainPosition=tmpMainPosition_"@@"_tmpSubPosition
				}
			}
			k ^TMP("ENS","SubPart",$j)
			s Position=tmpMainPosition
			;s tmpStatusInputStr=OEOrdItemID_"^"_ExamID_"^"_Position
			s tmpStatusInputStr=OEOrdItemID_"^"_ExamID_"^"_Position_"^"_ReportID
			s tmpPositionFlag=##class(web.DHCENS.STBLL.Method.SystemStatusInfo).ExamPart(tmpStatusInputStr)

			s AlphaupPositionStr=$zcvt(Position,"U")
			s tmpESStatusID=$p(tmpPositionFlag,"^",2)

		}
		else
		{
			//tmpESStatusID存在说明当前部位组合在主表中已经存在有效记录
			s tmpESStatusID=""
			////报告ID不等于空，并且当前状态有没有报告ID ，有报告ID证明存在报告状态，有报告ID，判断索引值是否存在，存在做更新，不存在做新增；没有报告ID说明当前状态是报告状态之前，做更新
			if (ReportID'="") {
				s tmpESStatusID=$o(^Busi.ENS.EnsStatusI("IndexESOrdItemIDExamID"," "_OEOrdItemID," "_ExamID,""),-1)
				if (tmpESStatusID'=""){
					s tmpESString1=$g(^Busi.ENS.EnsStatusD(tmpESStatusID))
					s tmpStatusReportID=$listget(tmpESString1,16)
					if (tmpStatusReportID'=""){
						s tmpESStatusID=$o(^Busi.ENS.EnsStatusI("IndexESOrdItemIDExamIDRepID"," "_OEOrdItemID," "_ExamID,tmpStatusReportID,""),-1)
					}
				}
				
			}else{
				s tmpESStatusID=$o(^Busi.ENS.EnsStatusI("IndexESOrdItemIDExamID"," "_OEOrdItemID," "_ExamID,""),-1)		
				s:(tmpESStatusID="") tmpESStatusID=$o(^Busi.ENS.EnsStatusI("IndexESOrdItemID"," "_OEOrdItemID,""),-1)
			}
			if tmpESStatusID'=""
			{
				s tmpESString=$g(^Busi.ENS.EnsStatusD(tmpESStatusID))
				s tmpESEffectFlag=$listget(tmpESString,12)
				//仅返回有效记录
				s:tmpESEffectFlag="N" tmpESStatusID=""
			}
			
		}
		
		i (Position="")||(+tmpPositionFlag=1)
		{
			
			
			//判断数据内容避免医技系统重复触发接口
			;s tmpESStatusID=$o(^Busi.ENS.EnsStatusI("IndexESOrdItemIDExamIDPartID"," "_OEOrdItemID," "_ExamID," "_AlphaupPositionStr,""),-1)
			;s:(tmpESStatusID="") tmpESStatusID=$o(^Busi.ENS.EnsStatusI("IndexESOrdItemIDPartID"," "_OEOrdItemID," "_AlphaupPositionStr,""),-1)
			
			i tmpESStatusID'=""
			{
				s tmpPreString=$g(^Busi.ENS.EnsStatusD(tmpESStatusID))
				s tmpPreStatusCode=$listget(tmpPreString,9)
				s tmpPreExamID=$listget(tmpPreString,3)
				s tmpPreEPosition=$listget(tmpPreString,4)
				s tmpOperateDate=$listget(tmpPreString,7)
				s tmpOperateTime=$listget(tmpPreString,8)
				s tmpReportID=$listget(tmpPreString,16)
				s tmpSystemCode=$listget(tmpPreString,10)
				s tmpSystemLinkStId=""
				s:(tmpSystemCode'="")&&(tmpPreStatusCode'="") tmpSystemLinkStId=$o(^Config.ENS.EnsSystemLinkStatusI("IndexSysStatus",tmpSystemCode,tmpPreStatusCode,""))
				s tmpPositionId=$lg($g(^Config.ENS.EnsSystemLinkStatusD(tmpSystemLinkStId,5)))
				i (Status=tmpPreStatusCode)&&(ExamID=tmpPreExamID)&&(Position=tmpPreEPosition)&&(ESOperateDate=tmpOperateDate)&&(ESOperateTime=tmpOperateTime)&&(ReportID=tmpReportID)
				{
					s ErroString=ErroString_";入参内容与当前医嘱号、检查号、检查部位、检查状态、操作日期、操作时间、报告号记录一致，不允许重复触发"
				}
				elseif($zabs(StatusSequence)<$zabs(tmpPositionId))
				{
					s ErroString=ErroString_";入参状态顺序与当前状态顺序相比，入参状态已过期，不允许插入"
				}
			}
			i ErroString=""
			{
				i ExamID'=""
				{
					i tmpESStatusID=""
					{
						// EffectiveFlag_"^"_ExamID_"^"Position"^"ESOperateDate"^"ESOperateTime"^"UserID"^"UserName"^"OEOrdItemID"^"_ProcessFlag_"^"Status"^"SourceSystem
						//写入状态表
						&sql(Insert into SqlUser.Ens_Status(ES_EffectiveFlag,ES_ExamID,ES_ExamPart,ES_OperateDate,ES_OperateTime,ES_OperatorID,ES_OperatorName,ES_OrdItemID,ES_Process,ES_StatusCode,ES_SystemCode,ES_Notes,ES_OperateDeptCode,ES_OperateDept,ES_ReportID) 
			    		 Values ('Y',:ExamID,:Position,:ESOperateDate,:ESOperateTime,:UserID,:UserName,:OEOrdItemID,'Y',:Status,:SourceSystem,:Notes,:OperateDeptCode,:OperateDept,:ReportID))
						//写入日志表
						&sql(Insert into SqlUser.Ens_Statuslog(ES_ExamID,ES_ExamPart,ES_OperateDate,ES_OperateTime,ES_OperatorID,ES_OperatorName,ES_OrdItemID,ES_StatusCode,ES_SystemCode,ES_OperateCode,ES_PreStatusCode,ES_Notes,ES_OperateDeptCode,ES_OperateDept,ES_ReportID) 
			     		Values (:ExamID,:Position,:ESOperateDate,:ESOperateTime,:UserID,:UserName,:OEOrdItemID,:Status,:SourceSystem,:Status,'',:Notes,:OperateDeptCode,:OperateDept,:ReportID))
					}
					else
					{
						i (StatusSequence>0)||(StatusSequence=0)
						{
							i Status="OCA"
							{
								//写入状态表
								&sql(update SqlUser.Ens_Status  set ES_EffectiveFlag='N' , ES_ExamID=:ExamID , ES_ExamPart=:Position , ES_OperateDate=:ESOperateDate , ES_OperateTime=:ESOperateTime , 
								ES_OperatorID=:UserID , ES_OperatorName=:UserName , ES_Process='N' , ES_StatusCode=:Status , ES_SystemCode=:SourceSystem,ES_Notes=:Notes,ES_OperateDeptCode=:OperateDeptCode,ES_OperateDept=:OperateDept,ES_ReportID=:ReportID where ID=:tmpESStatusID)

								//写入日志表
								&sql(Insert into SqlUser.Ens_Statuslog(ES_ExamID,ES_ExamPart,ES_OperateDate,ES_OperateTime,ES_OperatorID,ES_OperatorName,ES_OrdItemID,ES_StatusCode,ES_SystemCode,ES_OperateCode,ES_PreStatusCode,ES_Notes,ES_OperateDeptCode,ES_OperateDept,ES_ReportID) 
			     				Values (:ExamID,:Position,:ESOperateDate,:ESOperateTime,:UserID,:UserName,:OEOrdItemID,:Status,:SourceSystem,:Status,:tmpPreStatusCode,:Notes,:OperateDeptCode,:OperateDept,:ReportID))	
							}
							else
							{
								//写入状态表
								&sql(update SqlUser.Ens_Status set ES_ExamID=:ExamID , ES_ExamPart=:Position , ES_OperateDate=:ESOperateDate , ES_OperateTime=:ESOperateTime , 
								ES_OperatorID=:UserID , ES_OperatorName=:UserName , ES_Process='Y' , ES_StatusCode=:Status  , ES_SystemCode=:SourceSystem,ES_Notes=:Notes,ES_OperateDeptCode=:OperateDeptCode,ES_OperateDept=:OperateDept,ES_ReportID=:ReportID where ID=:tmpESStatusID)
							
								//写入日志表
								&sql(Insert into SqlUser.Ens_Statuslog(ES_ExamID,ES_ExamPart,ES_OperateDate,ES_OperateTime,ES_OperatorID,ES_OperatorName,ES_OrdItemID,ES_StatusCode,ES_SystemCode,ES_OperateCode,ES_PreStatusCode,ES_Notes,ES_OperateDeptCode,ES_OperateDept,ES_ReportID) 
			     				Values (:ExamID,:Position,:ESOperateDate,:ESOperateTime,:UserID,:UserName,:OEOrdItemID,:Status,:SourceSystem,:Status,:tmpPreStatusCode,:Notes,:OperateDeptCode,:OperateDept,:ReportID))		
							}
						}
						else
						{
							s PrePositiveStatusSequence=$FNUMBER(StatusSequence,"-")
			
							s PrePositiveStatusCode=$o(^Config.ENS.EnsSystemLinkStatusI("IndexSysSequenceStatus",SourceSystem,PrePositiveStatusSequence,""))
							//考虑连续逆流程的情况
							s PrePrePositiveStatusLogID=""
							s PrePrePositiveStatusCode=""
							for
							{
								//s PrePrePositiveStatusLogID=$o(^Busi.ENS.EnsStatusLogI("IndexESOrdItemIDExamIDESPartESStatusCode"," "_OEOrdItemID," "_ExamID," "_Position," "_PrePositiveStatusCode,PrePrePositiveStatusLogID),-1)
								
								//s:PrePrePositiveStatusLogID="" PrePrePositiveStatusLogID=$o(^Busi.ENS.EnsStatusLogI("IndexESOrdItemIDESPartESStatusCode"," "_OEOrdItemID," "_Position," "_PrePositiveStatusCode,PrePrePositiveStatusLogID),-1)
								s PrePrePositiveStatusLogID=$o(^Busi.ENS.EnsStatusLogI("IndexESOrdItemIDESPartESStatusCode"," "_OEOrdItemID," "_Position," "_PrePositiveStatusCode,PrePrePositiveStatusLogID),-1)
								q:PrePrePositiveStatusLogID=""
								s tmpPrePreString=$g(^Busi.ENS.EnsStatusLogD(PrePrePositiveStatusLogID))
								s PreOperateCode=$listget(tmpPrePreString,9)
								s PreStatusCode=$listget(tmpPrePreString,11)
								continue:(PreOperateCode'=PreStatusCode)
								s PrePrePositiveStatusCode=$listget(tmpPrePreString,12)
								continue:(PreOperateCode=PreStatusCode)
								
							}
							
							s:(PrePrePositiveStatusCode="")||(PrePrePositiveStatusCode=$c(0))||(PrePositiveStatusSequence=1) PrePrePositiveStatusCode="AP"
							//对检验部分报告后取消报告做特殊处理
							s:tmpPreStatusCode="PRP" PrePrePositiveStatusCode="ACCEPT"
							//对检查完成后取消检查CIM做特殊处理
							s:tmpPreStatusCode="CM" PrePrePositiveStatusCode="SC"
							//判断逆流程到申请状态时是否需要将多个部位多条记录合并为一条
							i ((PrePrePositiveStatusCode="AP")||(PrePrePositiveStatusCode="BLDAP")||(PrePrePositiveStatusCode="BLDCAP")||(PrePrePositiveStatusCode="CISANAP")||(PrePrePositiveStatusCode="CISANCAP"))&&((Position'=""))
							{
								i $d(^TMP("ENS","Status",$j))'=0
								{
									s tmpRemainESID=$o(^TMP("ENS","Status",$j,""))
									s tmpRemainPosition=$o(^TMP("ENS","Status",$j,tmpRemainESID,""))
									s ALLPosition=Position_"@@"_tmpRemainPosition
								
									//部位排序
									k ^TMP("ENS","SubPart",$j)
									s tmpPositionCount=$l(ALLPosition,"@@")
									for k=1:1:tmpPositionCount
									{
										s tmpSubPosition=$p(ALLPosition,"@@",k)
										s ^TMP("ENS","SubPart",$j,tmpSubPosition)=""
									}
									s tmpSubPosition=""
									s tmpMainPosition=""
									for
									{
										s tmpSubPosition=$o(^TMP("ENS","SubPart",$j,tmpSubPosition))
										q:tmpSubPosition=""
										i tmpMainPosition=""
										{
											s tmpMainPosition=tmpSubPosition
										}
										else
										{
											s tmpMainPosition=tmpMainPosition_"@@"_tmpSubPosition
										}
									}
									k ^TMP("ENS","SubPart",$j)
									s ALLPosition=tmpMainPosition
								
								
									
									&sql(update SqlUser.Ens_Status set ES_EffectiveFlag='N' where ID=:tmpRemainESID)
									&sql(update SqlUser.Ens_Status set ES_EffectiveFlag='N' where ID=:tmpESStatusID)
									//写入状态表
									&sql(Insert into SqlUser.Ens_Status(ES_EffectiveFlag,ES_ExamID,ES_ExamPart,ES_OperateDate,ES_OperateTime,ES_OperatorID,ES_OperatorName,ES_OrdItemID,ES_Process,ES_StatusCode,ES_SystemCode,ES_Notes,ES_OperateDeptCode,ES_OperateDept,ES_ReportID) 
			    		 			Values ('Y',:ExamID,:ALLPosition,:ESOperateDate,:ESOperateTime,:UserID,:UserName,:OEOrdItemID,'Y','AP',:SourceSystem,:Notes,:OperateDeptCode,:OperateDept,:ReportID))
						
									//写入日志表
									&sql(Insert into SqlUser.Ens_Statuslog(ES_ExamID,ES_ExamPart,ES_OperateDate,ES_OperateTime,ES_OperatorID,ES_OperatorName,ES_OrdItemID,ES_StatusCode,ES_SystemCode,ES_OperateCode,ES_PreStatusCode,ES_Notes,ES_OperateDeptCode,ES_OperateDept,ES_ReportID) 
					     			Values (:ExamID,:Position,:ESOperateDate,:ESOperateTime,:UserID,:UserName,:OEOrdItemID,:PrePrePositiveStatusCode,:SourceSystem,:Status,:tmpPreStatusCode,:Notes,:OperateDeptCode,:OperateDept,:ReportID))

								}
								else
								{
									//写入状态表
									&sql(update SqlUser.Ens_Status set ES_ExamID=:ExamID , ES_ExamPart=:Position , ES_OperateDate=:ESOperateDate , ES_OperateTime=:ESOperateTime , 
									ES_OperatorID=:UserID , ES_OperatorName=:UserName , ES_Process='N' , ES_StatusCode=:PrePrePositiveStatusCode  , ES_SystemCode=:SourceSystem,ES_Notes=:Notes,ES_OperateDeptCode=:OperateDeptCode,ES_OperateDept=:OperateDept,ES_ReportID=:ReportID where ID=:tmpESStatusID)

									//写入日志表
									&sql(Insert into SqlUser.Ens_Statuslog(ES_ExamID,ES_ExamPart,ES_OperateDate,ES_OperateTime,ES_OperatorID,ES_OperatorName,ES_OrdItemID,ES_StatusCode,ES_SystemCode,ES_OperateCode,ES_PreStatusCode,ES_Notes,ES_OperateDeptCode,ES_OperateDept,ES_ReportID) 
			     					Values (:ExamID,:Position,:ESOperateDate,:ESOperateTime,:UserID,:UserName,:OEOrdItemID,:PrePrePositiveStatusCode,:SourceSystem,:Status,:tmpPreStatusCode,:Notes,:OperateDeptCode,:OperateDept,:ReportID))	
							
								}
							}
							else
							{
								//写入状态表
								&sql(update SqlUser.Ens_Status set ES_ExamID=:ExamID , ES_ExamPart=:Position , ES_OperateDate=:ESOperateDate , ES_OperateTime=:ESOperateTime , 
								ES_OperatorID=:UserID , ES_OperatorName=:UserName , ES_Process='N' , ES_StatusCode=:PrePrePositiveStatusCode  , ES_SystemCode=:SourceSystem,ES_Notes=:Notes,ES_OperateDeptCode=:OperateDeptCode,ES_OperateDept=:OperateDept,ES_ReportID=:ReportID where ID=:tmpESStatusID)

								//写入日志表
								&sql(Insert into SqlUser.Ens_Statuslog(ES_ExamID,ES_ExamPart,ES_OperateDate,ES_OperateTime,ES_OperatorID,ES_OperatorName,ES_OrdItemID,ES_StatusCode,ES_SystemCode,ES_OperateCode,ES_PreStatusCode,ES_Notes,ES_OperateDeptCode,ES_OperateDept,ES_ReportID) 
			     				Values (:ExamID,:Position,:ESOperateDate,:ESOperateTime,:UserID,:UserName,:OEOrdItemID,:PrePrePositiveStatusCode,:SourceSystem,:Status,:tmpPreStatusCode,:Notes,:OperateDeptCode,:OperateDept,:ReportID))	
							}
						}
					}
				}
				else
				{
					i tmpESStatusID=""
					{
						//写入状态表
						&sql(Insert into SqlUser.Ens_Status(ES_EffectiveFlag,ES_ExamID,ES_ExamPart,ES_OperateDate,ES_OperateTime,ES_OperatorID,ES_OperatorName,ES_OrdItemID,ES_Process,ES_StatusCode,ES_SystemCode,ES_Notes,ES_OperateDeptCode,ES_OperateDept,ES_ReportID) 
			    		 Values ('Y',:ExamID,:Position,:ESOperateDate,:ESOperateTime,:UserID,:UserName,:OEOrdItemID,'Y',:Status,:SourceSystem,:Notes,:OperateDeptCode,:OperateDept,:ReportID))
						//写入日志表
						&sql(Insert into SqlUser.Ens_Statuslog(ES_ExamID,ES_ExamPart,ES_OperateDate,ES_OperateTime,ES_OperatorID,ES_OperatorName,ES_OrdItemID,ES_StatusCode,ES_SystemCode,ES_OperateCode,ES_PreStatusCode,ES_Notes,ES_OperateDeptCode,ES_OperateDept,ES_ReportID) 
			     		Values (:ExamID,:Position,:ESOperateDate,:ESOperateTime,:UserID,:UserName,:OEOrdItemID,:Status,:SourceSystem,:Status,'',:Notes,:OperateDeptCode,:OperateDept,:ReportID))
					}
					else
					{
						i (StatusSequence>0)||(StatusSequence=0)
						{
							i Status="OCA"
							{
								//写入状态表
								&sql(update SqlUser.Ens_Status  set ES_EffectiveFlag='N' , ES_ExamID=:ExamID , ES_ExamPart=:Position , ES_OperateDate=:ESOperateDate , ES_OperateTime=:ESOperateTime , 
								ES_OperatorID=:UserID , ES_OperatorName=:UserName , ES_Process='N' , ES_StatusCode=:Status , ES_SystemCode=:SourceSystem,ES_Notes=:Notes,ES_OperateDeptCode=:OperateDeptCode,ES_OperateDept=:OperateDept,ES_ReportID=:ReportID where ID=:tmpESStatusID)

								//写入日志表
								&sql(Insert into SqlUser.Ens_Statuslog(ES_ExamID,ES_ExamPart,ES_OperateDate,ES_OperateTime,ES_OperatorID,ES_OperatorName,ES_OrdItemID,ES_StatusCode,ES_SystemCode,ES_OperateCode,ES_PreStatusCode,ES_Notes,ES_OperateDeptCode,ES_OperateDept,ES_ReportID) 
			     				Values (:ExamID,:Position,:ESOperateDate,:ESOperateTime,:UserID,:UserName,:OEOrdItemID,:Status,:SourceSystem,:Status,:tmpPreStatusCode,:Notes,:OperateDeptCode,:OperateDept,:ReportID))	
							}
							else
							{
								//写入状态表
								&sql(update SqlUser.Ens_Status set ES_ExamID=:ExamID , ES_ExamPart=:Position , ES_OperateDate=:ESOperateDate , ES_OperateTime=:ESOperateTime , 
								ES_OperatorID=:UserID , ES_OperatorName=:UserName , ES_Process='Y' , ES_StatusCode=:Status  , ES_SystemCode=:SourceSystem,ES_Notes=:Notes,ES_OperateDeptCode=:OperateDeptCode,ES_OperateDept=:OperateDept,ES_ReportID=:ReportID where ID=:tmpESStatusID)
							
								//写入日志表
								&sql(Insert into SqlUser.Ens_Statuslog(ES_ExamID,ES_ExamPart,ES_OperateDate,ES_OperateTime,ES_OperatorID,ES_OperatorName,ES_OrdItemID,ES_StatusCode,ES_SystemCode,ES_OperateCode,ES_PreStatusCode,ES_Notes,ES_OperateDeptCode,ES_OperateDept,ES_ReportID) 
			     				Values (:ExamID,:Position,:ESOperateDate,:ESOperateTime,:UserID,:UserName,:OEOrdItemID,:Status,:SourceSystem,:Status,:tmpPreStatusCode,:Notes,:OperateDeptCode,:OperateDept,:ReportID))		
							}
						}
						else
						{
							
							s PrePositiveStatusSequence=$FNUMBER(StatusSequence,"-")
			
							s PrePositiveStatusCode=$o(^Config.ENS.EnsSystemLinkStatusI("IndexSysSequenceStatus",SourceSystem,PrePositiveStatusSequence,""))
							
							//考虑连续逆流程的情况
							s PrePrePositiveStatusLogID=""
							s PrePrePositiveStatusCode=""
							for
							{
								//s PrePrePositiveStatusLogID=$o(^Busi.ENS.EnsStatusLogI("IndexESOrdItemIDExamIDESPartESStatusCode"," "_OEOrdItemID," "_ExamID," "_Position," "_PrePositiveStatusCode,PrePrePositiveStatusLogID),-1)
								//s:PrePrePositiveStatusLogID="" PrePrePositiveStatusLogID=$o(^Busi.ENS.EnsStatusLogI("IndexESOrdItemIDESPartESStatusCode"," "_OEOrdItemID," "_Position," "_PrePositiveStatusCode,PrePrePositiveStatusLogID),-1)
								s PrePrePositiveStatusLogID=$o(^Busi.ENS.EnsStatusLogI("IndexESOrdItemIDESPartESStatusCode"," "_OEOrdItemID," "_Position," "_PrePositiveStatusCode,PrePrePositiveStatusLogID),-1)
								q:PrePrePositiveStatusLogID=""
								s tmpPrePreString=$g(^Busi.ENS.EnsStatusLogD(PrePrePositiveStatusLogID))
								s PreOperateCode=$listget(tmpPrePreString,9)
								s PreStatusCode=$listget(tmpPrePreString,11)
								continue:(PreOperateCode'=PreStatusCode)
								s PrePrePositiveStatusCode=$listget(tmpPrePreString,12)
								continue:(PreOperateCode=PreStatusCode)
								
							}
							
							s:(PrePrePositiveStatusCode="")||(PrePrePositiveStatusCode=$c(0))||(PrePositiveStatusSequence=1) PrePrePositiveStatusCode="AP"
							//对检验部分报告后取消报告做特殊处理
							s:tmpPreStatusCode="PRP" PrePrePositiveStatusCode="ACCEPT"
							//对检查完成后取消检查CIM做特殊处理
							s:tmpPreStatusCode="CM" PrePrePositiveStatusCode="SC"
							//判断逆流程到申请状态时是否需要将多个部位多条记录合并为一条
							i ((PrePrePositiveStatusCode="AP")||(PrePrePositiveStatusCode="BLDAP")||(PrePrePositiveStatusCode="BLDCAP")||(PrePrePositiveStatusCode="CISANAP")||(PrePrePositiveStatusCode="CISANCAP"))&&((Position'=""))
							{
								i $d(^TMP("ENS","Status",$j))'=0
								{
									s tmpRemainESID=$o(^TMP("ENS","Status",$j,""))
									s tmpRemainPosition=$o(^TMP("ENS","Status",$j,tmpRemainESID,""))
									s ALLPosition=Position_"@@"_tmpRemainPosition
								
									//部位排序
									k ^TMP("ENS","SubPart",$j)
									s tmpPositionCount=$l(ALLPosition,"@@")
									for k=1:1:tmpPositionCount
									{
										s tmpSubPosition=$p(ALLPosition,"@@",k)
										s ^TMP("ENS","SubPart",$j,tmpSubPosition)=""
									}
									s tmpSubPosition=""
									s tmpMainPosition=""
									for
									{
										s tmpSubPosition=$o(^TMP("ENS","SubPart",$j,tmpSubPosition))
										q:tmpSubPosition=""
										i tmpMainPosition=""
										{
											s tmpMainPosition=tmpSubPosition
										}
										else
										{
											s tmpMainPosition=tmpMainPosition_"@@"_tmpSubPosition
										}
									}
									k ^TMP("ENS","SubPart",$j)
									s ALLPosition=tmpMainPosition
								
								
									
									&sql(update SqlUser.Ens_Status set ES_EffectiveFlag='N' where ID=:tmpRemainESID)
									&sql(update SqlUser.Ens_Status set ES_EffectiveFlag='N' where ID=:tmpESStatusID)
									//写入状态表
									&sql(Insert into SqlUser.Ens_Status(ES_EffectiveFlag,ES_ExamID,ES_ExamPart,ES_OperateDate,ES_OperateTime,ES_OperatorID,ES_OperatorName,ES_OrdItemID,ES_Process,ES_StatusCode,ES_SystemCode,ES_Notes,ES_OperateDeptCode,ES_OperateDept,ES_ReportID) 
			    		 			Values ('Y',:ExamID,:ALLPosition,:ESOperateDate,:ESOperateTime,:UserID,:UserName,:OEOrdItemID,'Y','AP',:SourceSystem,:Notes,:OperateDeptCode,:OperateDept,:ReportID))
						
									//写入日志表
									&sql(Insert into SqlUser.Ens_Statuslog(ES_ExamID,ES_ExamPart,ES_OperateDate,ES_OperateTime,ES_OperatorID,ES_OperatorName,ES_OrdItemID,ES_StatusCode,ES_SystemCode,ES_OperateCode,ES_PreStatusCode,ES_Notes,ES_OperateDeptCode,ES_OperateDept,ES_ReportID) 
					     			Values (:ExamID,:Position,:ESOperateDate,:ESOperateTime,:UserID,:UserName,:OEOrdItemID,:PrePrePositiveStatusCode,:SourceSystem,:Status,:tmpPreStatusCode,:Notes,:OperateDeptCode,:OperateDept,:ReportID))

								}
								else
								{
									//写入状态表
									&sql(update SqlUser.Ens_Status set ES_ExamID=:ExamID , ES_ExamPart=:Position , ES_OperateDate=:ESOperateDate , ES_OperateTime=:ESOperateTime , 
									ES_OperatorID=:UserID , ES_OperatorName=:UserName , ES_Process='N' , ES_StatusCode=:PrePrePositiveStatusCode  , ES_SystemCode=:SourceSystem,ES_Notes=:Notes,ES_OperateDeptCode=:OperateDeptCode,ES_OperateDept=:OperateDept,ES_ReportID=:ReportID where ID=:tmpESStatusID)

									//写入日志表
									&sql(Insert into SqlUser.Ens_Statuslog(ES_ExamID,ES_ExamPart,ES_OperateDate,ES_OperateTime,ES_OperatorID,ES_OperatorName,ES_OrdItemID,ES_StatusCode,ES_SystemCode,ES_OperateCode,ES_PreStatusCode,ES_Notes,ES_OperateDeptCode,ES_OperateDept,ES_ReportID) 
			     					Values (:ExamID,:Position,:ESOperateDate,:ESOperateTime,:UserID,:UserName,:OEOrdItemID,:PrePrePositiveStatusCode,:SourceSystem,:Status,:tmpPreStatusCode,:Notes,:OperateDeptCode,:OperateDept,:ReportID))	
							
								}
							}
							else
							{
								//写入状态表
								&sql(update SqlUser.Ens_Status set ES_ExamID=:ExamID , ES_ExamPart=:Position , ES_OperateDate=:ESOperateDate , ES_OperateTime=:ESOperateTime , 
								ES_OperatorID=:UserID , ES_OperatorName=:UserName , ES_Process='N' , ES_StatusCode=:PrePrePositiveStatusCode  , ES_SystemCode=:SourceSystem,ES_Notes=:Notes,ES_OperateDeptCode=:OperateDeptCode,ES_OperateDept=:OperateDept,ES_ReportID=:ReportID where ID=:tmpESStatusID)
							
								//写入日志表
								&sql(Insert into SqlUser.Ens_Statuslog(ES_ExamID,ES_ExamPart,ES_OperateDate,ES_OperateTime,ES_OperatorID,ES_OperatorName,ES_OrdItemID,ES_StatusCode,ES_SystemCode,ES_OperateCode,ES_PreStatusCode,ES_Notes,ES_OperateDeptCode,ES_OperateDept,ES_ReportID) 
			     				Values (:ExamID,:Position,:ESOperateDate,:ESOperateTime,:UserID,:UserName,:OEOrdItemID,:PrePrePositiveStatusCode,:SourceSystem,:Status,:tmpPreStatusCode,:Notes,:OperateDeptCode,:OperateDept,:ReportID))
							}
						}
						
					}
					
				}
				i SQLCODE'=0
				{	
					s ErroString=ErroString_";数据写入发生错误"_SQLCODE
				}
			}
			i ErroString'=""
			{
				s MainErroString=MainErroString_"##"_ErroString
			}
		}
		if (+tmpPositionFlag=2)
		{
			s tmpRemainPosition=$p(tmpPositionFlag,"^",2)
			;s tmpRemainPosition=$p(tmpPositionFlag,"^",3)
			;s tmpRemainStatusCount=$p(tmpPositionFlag,"^",4)
			
			s tmpAPESID=$o(^TMP("ENS","Status",$j,""))
			;s tmpRemainPosition=$o(^TMP("ENS","Status",$j,tmpRemainESID,""))
			
			i ErroString=""
			{
				
				s tmpPreString=$g(^Busi.ENS.EnsStatusD(tmpAPESID))
				s tmpPreStatusCode=$listget(tmpPreString,9)
				//写入状态表
				&sql(Insert into SqlUser.Ens_Status(ES_EffectiveFlag,ES_ExamID,ES_ExamPart,ES_OperateDate,ES_OperateTime,ES_OperatorID,ES_OperatorName,ES_OrdItemID,ES_Process,ES_StatusCode,ES_SystemCode,ES_Notes,ES_OperateDeptCode,ES_OperateDept,ES_ReportID) 
			    Values ('Y',:ExamID,:Position,:ESOperateDate,:ESOperateTime,:UserID,:UserName,:OEOrdItemID,'Y',:Status,:SourceSystem,:Notes,:OperateDeptCode,:OperateDept,:ReportID))
				//写入日志表
				&sql(Insert into SqlUser.Ens_Statuslog(ES_ExamID,ES_ExamPart,ES_OperateDate,ES_OperateTime,ES_OperatorID,ES_OperatorName,ES_OrdItemID,ES_StatusCode,ES_SystemCode,ES_OperateCode,ES_PreStatusCode,ES_Notes,ES_OperateDeptCode,ES_OperateDept,ES_ReportID) 
			    Values (:ExamID,:Position,:ESOperateDate,:ESOperateTime,:UserID,:UserName,:OEOrdItemID,:Status,:SourceSystem,:Status,:tmpPreStatusCode,:Notes,:OperateDeptCode,:OperateDept,:ReportID))
				
				//写入状态表
				&sql(Insert into SqlUser.Ens_Status(ES_EffectiveFlag,ES_ExamID,ES_ExamPart,ES_OperateDate,ES_OperateTime,ES_OperatorID,ES_OperatorName,ES_OrdItemID,ES_Process,ES_StatusCode,ES_SystemCode,ES_Notes,ES_OperateDeptCode,ES_OperateDept,ES_ReportID) 
				SELECT ES_EffectiveFlag,ES_ExamID,:tmpRemainPosition,ES_OperateDate,ES_OperateTime,ES_OperatorID,ES_OperatorName,ES_OrdItemID,ES_Process,ES_StatusCode,ES_SystemCode,ES_Notes,ES_OperateDeptCode,ES_OperateDept,ES_ReportID FROM SqlUser.ens_status WHERE ID=:tmpAPESID)
				//更新原始状态表
				&sql(update SqlUser.Ens_Status set ES_EffectiveFlag='N' where ID=:tmpAPESID)
				
			}
		}
		if ((Status="CRP")||(Status="CPRP")||(Status="CPRERP")||(Status="CSRP"))&&(SourceSystem'="")
		{
			s sysTypeCode=""
			&SQL(SELECT ESys_TypeCode into :sysTypeCode FROM SQLUser.Ens_System WHERE ESys_Code=:SourceSystem)	
			if (sysTypeCode="RIS")||(sysTypeCode="PIS")
			{
				s crpFlag=""
				s crpFlag=..DeleteSystemStatusExam(ExamID,OEOrdItemID,ReportID)
				if crpFlag="-1"
				{
					s ErroString=ErroString_":检查报告取消审核报错"	
				}
			}
			elseif (sysTypeCode="LIS")
			{
				s crpFlag=""
				s crpFlag=..UpdateReportStatusLIS(OEOrdItemID,ExamID,ReportID)
				if crpFlag="-1"
				{
					s ErroString=ErroString_":检验报告取消审核报错"	
				}
			}
		}
	}
	
	k ^TMP("ENS","Status",$j)
	
	i MainErroString=""
	{	
		d ResultStr.Write("[{""ResultCode"":""0"",""ResultContent"":""成功""}]")
		q ResultStr
	}
	else
	{
		d ResultStr.Write("[{""ResultCode"":""-1"",""ResultContent"":"""_MainErroString_"""}]")
		q ResultStr
	}
GetErroMSG
	k ^TMP("ENS","Status",$j)
	s ResultStr=##class(%GlobalCharacterStream).%New()
	d ResultStr.Write("[{""ResultCode"":""-2"",""ResultContent"":""程序内部错误"_$ze_$g(ErroString)_"""}]")
	q ResultStr
}

// w ##class(web.DHCENS.STBLL.Method.SystemStatusInfo).QuerySystemStatus("[{""OEOrdItemID"":""123||3"",""ExamID"":""456""}]")

ClassMethod QuerySystemStatus(InputStr As %GlobalCharacterStream) As %GlobalCharacterStream
{
	//入参格式：[{"OEOrdItemID":"医嘱号","ExamID":"检查号\病理标本号\检验条码号"}]
	//入参示例1：[{"OEOrdItemID":"123||3","ExamID":"456"}]
	//入参示例2：[{"OEOrdItemID":"123||3","ExamID":"","Position":"右臂"}]
	//入参说明：医嘱号 必填；检查号\病理标本号\检验条码号 必填；
	//返回值格式：[{"OEOrdItemID":"医嘱号","Position":"检查部位","ExamID":"检查号\病理标本号\检验条码号","Status":"状态","UserID":"操作人工号","UserName":"操作人姓名","UpDateTime":"操作时间日期","SourceSystem":"来源系统","ProcessFlag":"正逆流程标识"}]
	//返回值示例：[{"OEOrdItemID":"123||3","Position":"右肩@@右臂","ExamID":"456","Status":"RP","UserID":"789","UserName":"demo","UpDateTime":"2011-11-1 11:12:11","SourceSystem":"PACS","ProcessFlag": "1"}]
	//返回值说明：入参医嘱号和检查号对应的检验检查记录当前状态
	s $zt="GetErroMSG"
	d InputStr.Rewind()
	s InputString=InputStr.Read()
	s ResultStr=##class(%GlobalCharacterStream).%New()
	set tmpJSONs={}.%FromJSON(InputStr)
	s ErroString=""
	s tmpJSON=tmpJSONs.%Get(0)
	s OEOrdItemID=tmpJSON.%Get("OEOrdItemID")
	s ExamID=tmpJSON.%Get("ExamID")
	s Position=tmpJSON.%Get("Position")
	i OEOrdItemID=""
	{
		d ResultStr.Write("[{""ResultCode"":""-1"",""ResultContent"":""OEOrdItemID="""_OEOrdItemID_"""医嘱号不能为空""}]")
		q ResultStr
	}
	/*
	s OEOrdID=+OEOrdItemID
	s OESubOrdID=+$p(OEOrdItemID,"||",2)
	i (OEOrdID=0)||(OESubOrdID=0)||($d(^OEORD(OEOrdID,"I",OESubOrdID))=0)
	{
		d ResultStr.Write("[{""ResultCode"":""-1"",""ResultContent"":""OEOrdItemID="""_OEOrdItemID_"""医嘱号格式不合法或不存在此医嘱""}]")
		q ResultStr
	}
	*/
	i ExamID'=""
	{

		//考虑多部位情况，读取最新一条有效记录
		s tmpESStatusID=""
		for
		{
			s tmpESStatusID=$o(^Busi.ENS.EnsStatusI("IndexESOrdItemIDExamID"," "_OEOrdItemID," "_ExamID,tmpESStatusID),-1)
			q:tmpESStatusID=""
			
			s tmpESStatusStr=$g(^Busi.ENS.EnsStatusD(tmpESStatusID))
			s EffectiveFlag=$listget(tmpESStatusStr,12)
			continue:EffectiveFlag="N"
			q:EffectiveFlag="Y"
		}
		
	}
	else
	{
		i Position=""
		{
			s tmpESStatusID=""
			for
			{
				s tmpESStatusID=$o(^Busi.ENS.EnsStatusI("IndexESOrdItemID"," "_OEOrdItemID,tmpESStatusID),-1)
				q:tmpESStatusID=""
				s tmpESStatusStr=$g(^Busi.ENS.EnsStatusD(tmpESStatusID))
				s EffectiveFlag=$listget(tmpESStatusStr,12)
				continue:EffectiveFlag="N"
				q:EffectiveFlag="Y"
			}
		}
		else
		{
			s tmpESStatusID=""
			for
			{
				s tmpESStatusID=$o(^Busi.ENS.EnsStatusI("IndexESOrdItemIDPartID"," "_OEOrdItemID," "_Position,tmpESStatusID),-1)
				q:tmpESStatusID=""
				s tmpESStatusStr=$g(^Busi.ENS.EnsStatusD(tmpESStatusID))
				s EffectiveFlag=$listget(tmpESStatusStr,12)
				continue:EffectiveFlag="N"
				q:EffectiveFlag="Y"
			}
			if '$d(^Busi.ENS.EnsStatusI("IndexESOrdItemIDPartID"," "_OEOrdItemID," "_Position))&&(Position["@@") //兼容多部位(@@分割)查询状态时，部位顺序号和医嘱闭环状态表中部位顺序不一致的情况
			{
				s tmpPosition=""
				for
				{
					s tmpPosition=$o(^Busi.ENS.EnsStatusI("IndexESOrdItemIDPartID"," "_OEOrdItemID,tmpPosition))
					q:(tmpPosition="")
					s tmpESStatusID1=""
					for
					{
						s tmpESStatusID1=$o(^Busi.ENS.EnsStatusI("IndexESOrdItemIDPartID"," "_OEOrdItemID,tmpPosition,tmpESStatusID1),-1)
						q:tmpESStatusID1=""
						s Position1=$tr(tmpPosition," ","")
						continue:$l(Position1,"@@")'=$l(Position,"@@") 
						s len=$l(Position1,"@@")
						s num=0
						for j=1:1:len
						{
							s PositionI=$p(Position,"@@",j)
							if (Position1[PositionI) s num=num+1	
						}
						q:num'=len
						s tmpESStatusStr=$g(^Busi.ENS.EnsStatusD(tmpESStatusID1))
						s EffectiveFlag=$listget(tmpESStatusStr,12)
						continue:EffectiveFlag="N"
						;q:EffectiveFlag="Y"
						s tmpESStatusID=tmpESStatusID1
					}	
				}
			}
			elseif '$d(^Busi.ENS.EnsStatusI("IndexESOrdItemIDPartID"," "_OEOrdItemID," "_Position))&&(Position'["@@"){ //兼容多部位登记时，按多部位中某一部位查询能正常输出检查号的情况
				
				s tmpPosition2=""
				for
				{
					s tmpPosition2=$o(^Busi.ENS.EnsStatusI("IndexESOrdItemIDPartID"," "_OEOrdItemID,tmpPosition2))
					q:(tmpPosition2="")
					continue:tmpPosition2'[Position
					
					s tmpESStatusID2=""
					for
					{
						s tmpESStatusID2=$o(^Busi.ENS.EnsStatusI("IndexESOrdItemIDPartID"," "_OEOrdItemID,tmpPosition2,tmpESStatusID2),-1)
						q:tmpESStatusID2=""
						s tmpESStatusStr=$g(^Busi.ENS.EnsStatusD(tmpESStatusID2))
						s EffectiveFlag=$listget(tmpESStatusStr,12)
						continue:EffectiveFlag="N"
						s tmpESStatusID=tmpESStatusID2
					}
				}
				
			}
		}
	}
	
	i tmpESStatusID=""
	{
		d ResultStr.Write("[{""ResultCode"":""-2"",""ResultContent"":""OEOrdItemID="_OEOrdItemID_"不存在相关有效记录""}]")
		q ResultStr
	}
	
	s tmpESStatusStr=$g(^Busi.ENS.EnsStatusD(tmpESStatusID))
	s OEOrdItemID=$listget(tmpESStatusStr,2)
	s ExamID=$listget(tmpESStatusStr,3)
	s Position=$listget(tmpESStatusStr,4)
	s UserID=$listget(tmpESStatusStr,5)
	s UserName=$listget(tmpESStatusStr,6)
	s UpDateTime=$zd($listget(tmpESStatusStr,7),3)_" "_$zt($listget(tmpESStatusStr,8))
	s Status=$listget(tmpESStatusStr,9)
	s SourceSystem=$listget(tmpESStatusStr,10)
	s ProcessFlag=$case($listget(tmpESStatusStr,11),"Y":1,"N":0)
	s Notes=$listget(tmpESStatusStr,13)
	s OperateDeptCode=$listget(tmpESStatusStr,14)
	s OperateDept=$listget(tmpESStatusStr,15)
	s ReportID=$listget(tmpESStatusStr,16)
	d ResultStr.Write("[{""OEOrdItemID"":"""_OEOrdItemID_""",""Position"":"""_Position_""",""ExamID"":"""_ExamID_""",""Status"":"""_Status_""",""UserID"":"""_UserID_""",""UserName"":"""_UserName_""",""UpDateTime"":"""_UpDateTime_""",""SourceSystem"":"""_SourceSystem_""",""ProcessFlag"":"""_ProcessFlag_""",""Notes"":"""_Notes_""",""OperateDeptCode"":"""_OperateDeptCode_""",""OperateDept"":"""_OperateDept_""",""ReportID"":"""_ReportID_"""}]")
	q ResultStr
GetErroMSG
	s ResultStr=##class(%GlobalCharacterStream).%New()
	d ResultStr.Write("[{""ResultCode"":""-2"",""ResultContent"":""程序内部错误"_$ze_"""}]")
	q ResultStr
}

// w ##class(web.DHCENS.STBLL.Method.SystemStatusInfo).QuerySystemStatusLog("[{""OEOrdItemID"":""123||3"",""ExamID"":""456""}]")

ClassMethod QuerySystemStatusLog(InputStr As %GlobalCharacterStream) As %GlobalCharacterStream
{
	//入参格式：[{"OEOrdItemID":"医嘱号","ExamID":"检查号\病理标本号\检验条码号"}]
	//入参示例：[{"OEOrdItemID":"123||3","ExamID":"456"}]
	//入参说明：医嘱号 必填；检查号\病理标本号\检验条码号 必填；
	//返回值格式：[{"OEOrdItemID":"医嘱号","Position":"检查部位","ExamID":"检查号\病理标本号\检验条码号","Status":"状态","UserID":"操作人工号","UserName":"操作人姓名","UpDateTime":"操作时间日期","SourceSystem":"来源系统"},{"OEOrdItemID":"医嘱号","Position":"检查部位","ExamID":"检查号\病理标本号\检验条码号","Status":"状态","UserID":"操作人工号","UserName":"操作人姓名","UpDateTime":"操作时间日期","SourceSystem":"来源系统"},{"OEOrdItemID":"医嘱号","Position":"检查部位","ExamID":"检查号\病理标本号\检验条码号","Status":"状态","UserID":"操作人工号","UserName":"操作人姓名","UpDateTime":"操作时间日期","SourceSystem":"来源系统"}]
	//返回值示例：[{"OEOrdItemID":"123||3","Position":"右肩@@右臂","ExamID":"456","Status":"BK","UserID":"789","UserName":"demo","UpDateTime":"2011-11-1 11:10:11","SourceSystem":"PACS"},{"OEOrdItemID":"123||3","Position":"右肩@@右臂","ExamID":"456","Status":"SC","UserID":"789","UserName":"demo","UpDateTime":"2011-11-1 11:11:11","SourceSystem":"PACS"},{"OEOrdItemID":"123||3","Position":"右肩@@右臂","ExamID":"456","Status":"RP","UserID":"789","UserName":"demo","UpDateTime":"2011-11-1 11:12:11","SourceSystem":"PACS"}]
	//返回值说明：入参医嘱号和检查号对应的检验检查记录的所有状态
	
	s $zt="GetErroMSG"
	d InputStr.Rewind()
	s InputString=InputStr.Read()
	s ResultStr=##class(%GlobalCharacterStream).%New()
	set tmpJSONs={}.%FromJSON(InputStr)
	s ErroString=""
	s tmpJSON=tmpJSONs.%Get(0)
	s OEOrdItemID=tmpJSON.%Get("OEOrdItemID")
	s ExamID=tmpJSON.%Get("ExamID")
	i OEOrdItemID=""
	{
		d ResultStr.Write("[{""ResultCode"":""-1"",""ResultContent"":""OEOrdItemID="""_OEOrdItemID_"""医嘱号不能为空""}]")
		q ResultStr
	}
	/*
	s OEOrdID=+OEOrdItemID
	s OESubOrdID=+$p(OEOrdItemID,"||",2)
	i (OEOrdID=0)||(OESubOrdID=0)||($d(^OEORD(OEOrdID,"I",OESubOrdID))=0)
	{
		d ResultStr.Write("[{""ResultCode"":""-1"",""ResultContent"":""OEOrdItemID="""_OEOrdItemID_"""医嘱号格式不合法或不存在此医嘱""}]")
		q ResultStr
	}
	*/
	s tmpMainObj=##class(%DynamicArray).%New()
	i ExamID'=""
	{
		s tmpESStatusID=""
		for
		{
			s tmpESStatusID=$o(^Busi.ENS.EnsStatusLogI("IndexESOrdItemIDExamID"," "_OEOrdItemID," ",tmpESStatusID))
			q:tmpESStatusID=""
			s tmpESStatusStr=$g(^Busi.ENS.EnsStatusLogD(tmpESStatusID))
			s tmpESStatusObj={}
			s tmpESStatusObj.OEOrdItemID=$listget(tmpESStatusStr,2)
			s tmpESStatusObj.ExamID=$listget(tmpESStatusStr,3)
			s tmpESStatusObj.Position=$listget(tmpESStatusStr,4)
			s tmpESStatusObj.UserID=$listget(tmpESStatusStr,5)
			s tmpESStatusObj.UserName=$listget(tmpESStatusStr,6)
			s tmpESStatusObj.UpDateTime=$zd($listget(tmpESStatusStr,7),3)_" "_$zt($listget(tmpESStatusStr,8))
			s tmpESStatusObj.Status=$listget(tmpESStatusStr,9)
			s tmpESStatusObj.SourceSystem=$listget(tmpESStatusStr,10)
			s tmpESStatusObj.Notes=$listget(tmpESStatusStr,14)
			s tmpESStatusObj.OperateDeptCode=$listget(tmpESStatusStr,15)
			s tmpESStatusObj.OperateDept=$listget(tmpESStatusStr,16)
			s tmpESStatusObj.ReportID=$listget(tmpESStatusStr,17)
			d tmpMainObj.%Push(tmpESStatusObj)
		}
		s tmpESStatusID=""
		for
		{
			s tmpESStatusID=$o(^Busi.ENS.EnsStatusLogI("IndexESOrdItemIDExamID"," "_OEOrdItemID," "_ExamID,tmpESStatusID))
			q:tmpESStatusID=""
			s tmpESStatusStr=$g(^Busi.ENS.EnsStatusLogD(tmpESStatusID))
			s tmpESStatusObj={}
			s tmpESStatusObj.OEOrdItemID=$listget(tmpESStatusStr,2)
			s tmpESStatusObj.ExamID=$listget(tmpESStatusStr,3)
			s tmpESStatusObj.Position=$listget(tmpESStatusStr,4)
			s tmpESStatusObj.UserID=$listget(tmpESStatusStr,5)
			s tmpESStatusObj.UserName=$listget(tmpESStatusStr,6)
			s tmpESStatusObj.UpDateTime=$zd($listget(tmpESStatusStr,7),3)_" "_$zt($listget(tmpESStatusStr,8))
			s tmpESStatusObj.Status=$listget(tmpESStatusStr,9)
			s tmpESStatusObj.SourceSystem=$listget(tmpESStatusStr,10)
			s tmpESStatusObj.Notes=$listget(tmpESStatusStr,14)
			s tmpESStatusObj.OperateDeptCode=$listget(tmpESStatusStr,15)
			s tmpESStatusObj.OperateDept=$listget(tmpESStatusStr,16)
			s tmpESStatusObj.ReportID=$listget(tmpESStatusStr,17)
			d tmpMainObj.%Push(tmpESStatusObj)
		}
	}
	else
	{
		s tmpESStatusID=""
		for
		{
			s tmpESStatusID=$o(^Busi.ENS.EnsStatusLogI("IndexESOrdItemID"," "_OEOrdItemID,tmpESStatusID))
			q:tmpESStatusID=""
			s tmpESStatusStr=$g(^Busi.ENS.EnsStatusLogD(tmpESStatusID))
			s tmpESStatusObj={}
			s tmpESStatusObj.OEOrdItemID=$listget(tmpESStatusStr,2)
			s tmpESStatusObj.ExamID=$listget(tmpESStatusStr,3)
			s tmpESStatusObj.Position=$listget(tmpESStatusStr,4)
			s tmpESStatusObj.UserID=$listget(tmpESStatusStr,5)
			s tmpESStatusObj.UserName=$listget(tmpESStatusStr,6)
			s tmpESStatusObj.UpDateTime=$zd($listget(tmpESStatusStr,7),3)_" "_$zt($listget(tmpESStatusStr,8))
			s tmpESStatusObj.Status=$listget(tmpESStatusStr,9)
			s tmpESStatusObj.SourceSystem=$listget(tmpESStatusStr,10)
			s tmpESStatusObj.Notes=$listget(tmpESStatusStr,14)
			s tmpESStatusObj.OperateDeptCode=$listget(tmpESStatusStr,15)
			s tmpESStatusObj.OperateDept=$listget(tmpESStatusStr,16)
			s tmpESStatusObj.ReportID=$listget(tmpESStatusStr,17)
			d tmpMainObj.%Push(tmpESStatusObj)
		}
	}
	d ResultStr.Write(tmpMainObj.%ToJSON())
	q ResultStr
GetErroMSG
	d ResultStr.Write("[{""ResultCode"":""-2"",""ResultContent"":""程序内部错误"_$ze_"""}]")
	q ResultStr
}

// 入参：检查部位

// 返回：检查部位统计排序后的数据

// OEOrdItemID_"^"_ExamID_"^"_Position

// w ##class(web.DHCENS.STBLL.Method.SystemStatusInfo).ExamPart("")

ClassMethod ExamPart(positionStr As %String) As %String
{
	k ^TMP("ENS","Status",$j)
	s OEOrdItemID=$p(positionStr,"^",1)
	s ExamID=$p(positionStr,"^",2)
	s Position=$p(positionStr,"^",3)
	s ReportID=$p(positionStr,"^",4)
	s RemainPosition=""
	s tmpAPESID=""
	//找出处于AP状态的部位
	s tmpAPStatusStr=""
	for
	{
		s tmpAPStatusStr=$o(^Busi.ENS.EnsStatusI("IndexESOrdItemIDPartID"," "_OEOrdItemID,tmpAPStatusStr))
		q:tmpAPStatusStr=""
		s tmpAPESID=""
		for
		{
			s tmpAPESID=$o(^Busi.ENS.EnsStatusI("IndexESOrdItemIDPartID"," "_OEOrdItemID,tmpAPStatusStr,tmpAPESID))
			q:tmpAPESID=""
			s tmpAPESString=$g(^Busi.ENS.EnsStatusD(tmpAPESID))
			s tmpAPStatusCode=$listget(tmpAPESString,9)
			s tmpAPEffectFlag=$listget(tmpAPESString,12)
			s tmpAPPosition=$listget(tmpAPESString,4)
			if (tmpAPStatusCode="AP")&&(tmpAPEffectFlag="Y")
			{
				s:tmpAPPosition'="" ^TMP("ENS","Status",$j,tmpAPESID,tmpAPPosition)=""
				s:tmpAPPosition="" ^TMP("ENS","Status",$j,tmpAPESID," ")=""
			}
		}
	}
	
	s AlphaupPositionStr=$zcvt(Position,"U")
	//tmpESStatusID存在说明当前部位组合在主表中已经存在有效记录
	s tmpESStatusID=""
	
	if (ReportID'="")
	{
		s tmpESStatusID=$o(^Busi.ENS.EnsStatusI("IndexESOrdItemIDExamIDPartID"," "_OEOrdItemID," "_ExamID," "_AlphaupPositionStr,""),-1)
		if (tmpESStatusID'="") {
			s tmpESString1=$g(^Busi.ENS.EnsStatusD(tmpESStatusID))
			s tmpStatusReport=$listget(tmpESString1,16)
			if (tmpStatusReport'=""){
				s tmpESStatusID=$o(^Busi.ENS.EnsStatusI("IndexESOrdItemIDExamIDRepPartID"," "_OEOrdItemID," "_ExamID," "_ReportID," "_AlphaupPositionStr,""),-1)		
			}
		}
		
		//s:(tmpESStatusID="") tmpESStatusID=$o(^Busi.ENS.EnsStatusI("IndexESOrdItemIDExamIDPartID"," "_OEOrdItemID," "_ExamID," "_AlphaupPositionStr,""),-1)
	}
	elseif (ReportID="")&&(ExamID'="")
	{
		s tmpESStatusID=$o(^Busi.ENS.EnsStatusI("IndexESOrdItemIDExamIDPartID"," "_OEOrdItemID," "_ExamID," "_AlphaupPositionStr,""),-1)		
		s:(tmpESStatusID="") tmpESStatusID=$o(^Busi.ENS.EnsStatusI("IndexESOrdItemIDPartID"," "_OEOrdItemID," "_AlphaupPositionStr,""),-1)
	}
	else
	{
		s tmpESStatusID=$o(^Busi.ENS.EnsStatusI("IndexESOrdItemIDPartID"," "_OEOrdItemID," "_AlphaupPositionStr,""),-1)
	
	}
	if tmpESStatusID'=""
	{
		s tmpESString=$g(^Busi.ENS.EnsStatusD(tmpESStatusID))
		s tmpESEffectFlag=$listget(tmpESString,12)
		//仅返回有效记录
		s:tmpESEffectFlag="N" tmpESStatusID=""
		;s tmpAPEffectFlag=$listget(tmpAPESString,12)
		;s tmpAPPosition=$listget(tmpAPESString,4)
	}
	i $d(^TMP("ENS","Status",$j))'=0
	{
		s tmpAPESID=$o(^TMP("ENS","Status",$j,""))
		s tmpAPESStatusStr=$g(^Busi.ENS.EnsStatusD(tmpAPESID))
		s APPosition=$listget(tmpAPESStatusStr,4)
		s APSubPositionNum=$l(APPosition,"@@")
		s RemainPosition=""
		s AlphaupRemainPosition=""
		for i=1:1:APSubPositionNum
		{
			s APSubPosition=$p(APPosition,"@@",i)
			s SubPositionNum=$l(Position,"@@")
			s tmpFlag=0
			for l=1:1:SubPositionNum
			{
				s SubPosition=$p(Position,"@@",l)
				s:(SubPosition=APSubPosition) tmpFlag=1
			}
			i tmpFlag=0
			{
				i RemainPosition=""
				{
			 		s RemainPosition=APSubPosition
				}
				else
				{
			 		s RemainPosition=RemainPosition_"@@"_APSubPosition
				}
			}
		}
	}
	
	//ap状态部位为空但后续回传的状态数据中部位不为空时，不拆分记录。
	s tmpAPESID=""
	for
	{
		s tmpAPESID=$o(^Busi.ENS.EnsStatusI("IndexESOrdItemID"," "_OEOrdItemID,tmpAPESID))
		q:tmpAPESID=""
		s tmpAPESString=$g(^Busi.ENS.EnsStatusD(tmpAPESID))
		s tmpAPStatusCode=$listget(tmpAPESString,9)
		s tmpAPEffectFlag=$listget(tmpAPESString,12)
		s tmpAPPosition=$listget(tmpAPESString,4)
		if (tmpAPStatusCode="AP")&&(tmpAPEffectFlag="Y")&&(tmpAPPosition="")
		{
			s tmpESStatusID=tmpAPESID
		}
	}

	/*
	1 部位为空
	2 部位不为空 $d(^TMP("ENS","Status",$j))=0  
	  2.1 带部位检查以申请状态第一次触发
	  2.2 多部位检查所有部位已经都处于非AP状态
	3 部位不为空 $d(^TMP("ENS","Status",$j))'=0
	  3.1 tmpESStatusID’="" && tmpAPESID=tmpESStatusID 是对当前AP状态的所有部位进行操作 不需要特殊处理
	  3.2 tmpESStatusID’="" && tmpAPESID'=tmpESStatusID 是对tmpESStatusID记录的操作 正流程不需要特殊处理 逆流程到AP时组合tmpESStatusID和tmpESStatusID的部位到同一条记录
	  3.3 tmpESStatusID="" 需要通过RemainPosition生成两条新记录 同时tmpAPESID修改为无效
	
	1 2 3.1 3.2 返回1
	3.3 返回2
	*/

	if ($d(^TMP("ENS","Status",$j))'=0)&&(tmpESStatusID="")
	{
		q 2_"^"_RemainPosition
	}
	else
	{
		q 1_"^"_tmpESStatusID
	}
}

// chenjiang

// 20190121

// 执行此方法将清除医技状态记录表（sqlUser.Ens_Status）以及医技状态日志表(sqlUser.Ens_StatusLog)

// w ##class(web.DHCENS.STBLL.Method.SystemStatusInfo).ClearEnsStatusData()

ClassMethod ClearEnsStatusData() As %String
{
	k ^Busi.ENS.EnsStatusD
	k ^Busi.ENS.EnsStatusI
	k ^Busi.ENS.EnsStatusS
	k ^Busi.ENS.EnsStatusC
	
	k ^Busi.ENS.EnsStatusLogD
	k ^Busi.ENS.EnsStatusLogI
	k ^Busi.ENS.EnsStatusLogS
	k ^Busi.ENS.EnsStatusLogC
	
	q 0
}

// w ##class(web.DHCENS.STBLL.Method.SystemStatusInfo).test(5)

ClassMethod test(flag) As %String
{
	i flag=1
	{
		s string="[{""OEOrdItemID"":""123||3""}]"
		set obj={}.%FromJSON(string)
		s count=obj.%Size()
		f i=1:1:count
		{
			s obj1=obj.%Get(i-1)
			w obj1.%Get("OEOrdItemID")
		}
		q 0
	}
	i flag=2
	{
		s bb=##class(%DynamicArray).%New()
		s aa={}
		s aa.a=1
		s aa.b=2
		d bb.%Push(aa)
		d bb.%Push(aa)
		w bb.%ToJSON()
		q 0
	}
	i flag=3
	{
		s aa=##class(%GlobalCharacterStream).%New()
		d aa.Write("[{""ExamID"":""B82-001"",""OEOrdItemID"":""82||79"",""Position"":"""",""SourceSystem"":""US"",""Status"":""CA"",""UpDateTime"":""2019-02-26 15:49:47"",""UserID"":""687"",""UserName"":""ris""}]")
		s result=..UpdateSystemStatus(aa)
		w result.Read()
		q 0
	}
	i flag=4
	{
		s aa=##class(%GlobalCharacterStream).%New()
		d aa.Write("[{""OEOrdItemID"":""90||21"",""ExamID"":""US20181229001""}]")
		s ret=..QuerySystemStatusLog(aa)
		w ret.Read()
		q 0
	}
	i flag=5
	{
		s aa=##class(%GlobalCharacterStream).%New()
		d aa.Write("[{""OEOrdItemID"":""183||23"",""ExamID"":""EKG||183||23""}]")
		s ret=..QuerySystemStatus(aa)
		w ret.Read()
		q 0
	}
}

/// Creator：ZhangXinying
/// CreatDate：2022—01-06
/// Description：东华检验报告取消审核时更新检验报告表和对应文档表数据状态字段为2:取消审核，同时按体检组要求处理体检检验报告
/// Table：Ens_LISReportResult、Ens_HOSDocument
/// Input：Ens_LISReportResult报告表ID
/// Return：状态0:成功,-1:失败
/// w ##class(web.DHCENS.STBLL.Method.SystemStatusInfo).DeleteSystemStatus("0000000679||84")
ClassMethod DeleteSystemStatus(LISRRReportID As %String) As %String
{
	q:LISRRReportID="" "-1"
	q:'$d(^Busi.ENS.EnsLISReportResultI("LISREPORTRESULTPKey",$zcvt(LISRRReportID,"U"))) "-1"
	s rtn=""
	try{
		set ID=""
		set ID=$o(^Busi.ENS.EnsLISReportResultI("LISREPORTRESULTPKey",$zcvt(LISRRReportID,"U"),ID))
		q:ID=""
		ts
		set LISRRISMcroorganism=$lg(^Busi.ENS.EnsLISReportResultD(ID),103) //1,微生物报告；2,普通报告
		set AdmType=$lg(^Busi.ENS.EnsLISReportResultD(ID),4) //就诊类型，如果是体检需单独调用体检组接口
		if LISRRISMcroorganism=2{
			&SQL(Update SQLUser.Ens_LISReportResult set LISRR_Status="2" where LISRR_ReportID=:LISRRReportID)
			if SQLCODE'=0{
				tro		
			}
			s HOSDSerialNumberXml="01001_"_LISRRReportID_".xml"
			s HosDocuIDXml=$o(^Busi.ENS.EnsHOSDocumentI("HOSDOCUMENTSerialIndex",HOSDSerialNumberXml,""))
			if HosDocuIDXml'=""
			{
				&SQL(Update SQLUser.Ens_HOSDocument set HOSD_Status="2" where HOSD_SerialNumber=:HOSDSerialNumberXml)	
				if SQLCODE'=0{
					tro	
				}
			}
			s HOSDSerialNumberPdf="01001_"_LISRRReportID_".pdf"
			s HosDocuIDPdf=$o(^Busi.ENS.EnsHOSDocumentI("HOSDOCUMENTSerialIndex",HOSDSerialNumberPdf,""))
			if HosDocuIDPdf'=""
			{
				&SQL(Update SQLUser.Ens_HOSDocument set HOSD_Status="2" where HOSD_SerialNumber=:HOSDSerialNumberPdf)	
				if SQLCODE'=0{
					tro	
				}
			}
			if AdmType="H"
			{
				d ..DeletePEResult(LISRRReportID) //如果是体检检验报告，删除体检结果表相关数据
			}
		}
		
		elseif LISRRISMcroorganism=1{
			
			&SQL(Update SQLUser.Ens_LISReportResult set LISRR_Status="2" where LISRR_ReportID=:LISRRReportID)
			if SQLCODE'=0{
				tro		
			}
			s HOSDSerialNumberXml="01002_"_LISRRReportID_".xml"
			s HosDocuIDXml=$o(^Busi.ENS.EnsHOSDocumentI("HOSDOCUMENTSerialIndex",HOSDSerialNumberXml,""))
			if HosDocuIDXml'=""
			{
				&SQL(Update SQLUser.Ens_HOSDocument set HOSD_Status="2" where HOSD_SerialNumber=:HOSDSerialNumberXml)	
				if SQLCODE'=0{
					tro	
				}
				
			}
			s HOSDSerialNumberPdf="01002_"_LISRRReportID_".pdf"
			s HosDocuIDPdf=$o(^Busi.ENS.EnsHOSDocumentI("HOSDOCUMENTSerialIndex",HOSDSerialNumberPdf,""))
			if HosDocuIDPdf'=""
			{
				&SQL(Update SQLUser.Ens_HOSDocument set HOSD_Status="2" where HOSD_SerialNumber=:HOSDSerialNumberPdf)	
				if SQLCODE'=0{
					tro	
				}
			}
			if AdmType="H"
			{
				d ..DeletePEResult(LISRRReportID) //如果是体检检验报告，删除体检结果表相关数据
			}
		} 			
		if (($g(SQLCODE)=0)||($g(SQLCODE)=100)||($g(SQLCODE)=""))&&($TLEVEL>0)
		{
			tc
			set rtn=0
		}
		else
		{
			if $TLEVEL>0
			{
				tro
			}
			set rtn="-1"	
		}
	}catch{
		if $TLEVEL>0
		{
	 		tro	
		}
		set $zt=""
		set rtn="-1"	
	}
	
	q rtn
}

/// Creator：ZhangXinying
/// CreatDate：2022—09-06
/// Description：东华检查、病理报告取消审核时更新报告表和对应文档表数据状态字段为2:取消审核，同时按体检组要求处理体检检查/病理报告
/// Table：Ens_RISReportResult、Ens_HOSDocument
/// Input：Ens_RISReportResult检查号、医嘱号
/// Return：状态0:成功,-1:失败
/// Debug:w ##class(web.DHCENS.STBLL.Method.SystemStatusInfo).DeleteSystemStatusExam("CJCH1142","23||165","")
ClassMethod DeleteSystemStatusExam(RISRExamID As %String, OrdItemID As %String, ReportID As %String = "") As %String
{
	q:RISRExamID="" "-1"
	q:'$d(^Busi.ENS.EnsRISReportResultI("RISRExamIDIndex",$zcvt(RISRExamID,"U"))) "-1"
	s rtn=""
	try{
		s rtn=##class(web.DHCENS.STBLL.Method.ReturnSystemStatus).UpdateReportStatusRIS(OrdItemID,RISRExamID,ReportID)
		s Adm=$p($g(^OEORD(+OrdItemID)),"^",1)
		s AdmType=$p($g(^PAADM(Adm)),"^",2)
		if (##class(websys.Conversions).IsValidMethodName("web.DHCPE.TransResult","DeleteResultByOEID"))&&(AdmType="H")
		{
			d ##class(web.DHCPE.TransResult).DeleteResultByOEID(OrdItemID)
		}
		}catch{
			set rtn="-1"	
		}
	
	q rtn
}

/// Creator：ZhangXinying
/// CreatDate：2022—09-06
/// Description：东华检验报告取消审核时删除对应体检表DHC_PE_Reult数据
/// Table：Ens_LISReportResult
/// Input：Ens_LISReportResult表ID
/// Return：状态0:成功,-1:失败
/// Debug:w ##class(web.DHCENS.STBLL.Method.SystemStatusInfo).DeletePEResult("0000000013||1")
ClassMethod DeletePEResult(lisRptID As %String) As %String
{
	try
	{
		s rtn=""
		s specimenNo=""
		for
		{
			s specimenNo=$o(^Busi.ENS.EnsLISSpecimenReportI("LISSPECIMENREPORTPKey"," "_$zcvt(lisRptID,"U"),specimenNo))
			q:specimenNo=""
			s ordItemID=""
			for 
			{
				s ordItemID=$o(^Busi.ENS.EnsLISSpecimenReportI("LISSPECIMENREPORTPKey"," "_$zcvt(lisRptID,"U"),specimenNo,ordItemID))
				q:ordItemID=""
				if (##class(websys.Conversions).IsValidMethodName("web.DHCPE.TransResult","DeleteResultByOEID"))
				{
					s rtn=##class(web.DHCPE.TransResult).DeleteResultByOEID(ordItemID)	
				}
			}	
		}
	}
	catch
	{
		set rtn="-1"	
	}
	q rtn
}

/// Description:更新文档表和检验报告表状态为取消审核
/// Debug: w ##class(web.DHCENS.STBLL.Method.SystemStatusInfo).UpdateReportStatusLIS("2||3","0000002337")
ClassMethod UpdateReportStatusLIS(OEORROrderItemID As %String, SpecimenID As %String, LISReportID As %String = "") As %String
{
	s $Ztrap="Exception"
	q:(OEORROrderItemID="")||(SpecimenID="") "0"
	ts
	set RelODType="" for  s RelODType=$o(^Busi.ENS.EnsRelOrderDocumentI("RelODOrderItemIDIndex",OEORROrderItemID,RelODType)) q:RelODType=""  d
	.set RelODID="" for  s RelODID= $o(^Busi.ENS.EnsRelOrderDocumentI("RelODOrderItemIDIndex",OEORROrderItemID,RelODType,RelODID)) q:RelODID=""  d
	..set RelDocuID=$lg($g(^Busi.ENS.EnsRelOrderDocumentD(RelODID)),2)
	..if RelDocuID'="" d
	...set DocuID=$o(^Busi.ENS.EnsHOSDocumentI("HOSDOCUMENTPKey",RelDocuID,""))
	...&SQL(Update SQLUser.Ens_HosDocument set HOSD_Status="2" where %id=:DocuID)
	...if SQLCODE'=0 d
	....tro
	....q
	set SpecimenRepID="" for  s SpecimenRepID=$o(^Busi.ENS.EnsLISSpecimenReportI("RELORDERSPECIMENHOSCODE"," "_SpecimenID,SpecimenRepID)) q:SpecimenRepID=""  d
	.set LISSRReportID=$lg($g(^Busi.ENS.EnsLISSpecimenReportD(SpecimenRepID)),2)
	.set LISRepRowID=$O(^Busi.ENS.EnsLISReportResultI("LISREPORTRESULTPKey",LISSRReportID,""))
	.if LISRepRowID'="" d
	..&SQL(Update SQLUser.Ens_LISReportResult set LISRR_Status="2" where %id=:LISRepRowID)
	..if SQLCODE'=0 d 
	...tro
	...q
	if LISReportID'=""
	{
		&SQL(Update SQLUser.Ens_LISReportResult set LISRR_Status="2" where LISRR_ReportID=:LISReportID)	
	}
	if (($g(SQLCODE)=0)||($g(SQLCODE)="")||($g(SQLCODE)=100))&&($TLEVEL>0)
	{
		tc
	}
	q 0
Exception
	if $TLEVEL>0
	{
	 	tro	
	}
	q "-1"
}

}
