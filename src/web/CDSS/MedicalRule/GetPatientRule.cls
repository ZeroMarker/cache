/// Creator:丁亚男
/// CreatDate:2021-08-16
/// Description:获取患者符合条件的诊疗规则
Class web.CDSS.MedicalRule.GetPatientRule Extends %RegisteredObject
{

/// Creator:丁亚男
/// CreatDate:2021-08-02
/// Description:根据患者信息匹配可视化规则表中信息,保存匹配的规则
/// Table: CT.WDT.CDSS.RuleDict:诊疗规则表 CT.WDT.CDSS.RuleNode:诊疗规则节点表 CT.WDT.CDSS.RuleCondition:诊疗规则内容表(有多个)
/// Input: PatientInfo : 患者信息（医生站所传json串）
/// Return:                                                               DM000770^DM000770^1^住院^48^李得原^1^信息科^Y
/// Others:w ##class(web.CDSS.MedicalRule.GetPatientRule).GetSatisfyRule("DM000816^DM000816^1^住院^18881^王健^ZYZY003^内分泌科^1^脑梗死")
ClassMethod GetSatisfyRule(PatientInfo As %String, RecomType As %String = "", ProVision As %String = "", RuleId As %String = "") As %String
{
	s start = $p($zdt($now(),3,1,4),":",*)
	s IDNO=$p(PatientInfo,"^",1)
	s PatientDR=$p(PatientInfo,"^",2)
	s VisitID=$p(PatientInfo,"^",3)
	s VisitType=$p(PatientInfo,"^",4)
	s Config=$p(PatientInfo,"^",9)
	s DiseaseFlag=""
	if $l(PatientInfo,"^")=10
	{
		s DiseaseFlag=$p(PatientInfo,"^",*)
		s PatientInfo=$replace(PatientInfo,"^"_DiseaseFlag,"")
	}
	if (Config="") s Config=1	//是否启用流水号（急诊号、门诊号、住院号）为患者就诊唯一标识（0为是，1为否），默认为1
	s RuleArray=""  //符合索引条件的规则
	if ((Config=1)||(Config="Y"))&(PatientDR'="")&(VisitID'="") // 单个患者单次就诊 根据病人标识和就诊次数编号取数据
	{
		s IWArray=""
		//获取当前触发的识别词涉及的规则
		if ($d(^WDT.CDSS.PatTriggerIWI("PatVisTypeIWIndex",PatientDR,VisitID,VisitType)))
		{
			s IdentifyWordsDR=0
			for
			{
				s IdentifyWordsDR =$o(^WDT.CDSS.PatTriggerIWI("PatVisTypeIWIndex",PatientDR,VisitID,VisitType,IdentifyWordsDR))  q:IdentifyWordsDR="" 
				s RuleRowId=0
				
				for
				{
					s RuleRowId=$o(^CT.WDT.CDSS.RuleIndexI("IRTypeFlowIndex",IdentifyWordsDR, RuleRowId))
					q:RuleRowId=""
					if RuleId'=""    //
					{
						continue:RuleRowId'=RuleId
					}
					
					s Vision=$lg($g(^CT.WDT.CDSS.RuleDictD(RuleRowId)),14)
					
					s TCMFlag = ##class(web.CDSS.Config.MKBConfig).GetConfigValue("TCM")
					if TCMFlag=0
					{
						continue:Vision["中医"
					}
					if ProVision="sds"  //sds
					{
						continue:Vision'="sds"
					}
					elseif ProVision="emr-gender"
					{
						
						s GenderIWRowid=$o(^CT.WDT.CDSS.IdentifyWordsI("DescIndex"," 性别",0))
						continue:'$d(^CT.WDT.CDSS.RuleIndexI("RuleIWDRIndex",RuleRowId,GenderIWRowid))
						s IndexRowid=$o(^CT.WDT.CDSS.RuleIndexI("RuleIWDRIndex",RuleRowId,GenderIWRowid,""))
						s IndexRuleType =$lg($g(^CT.WDT.CDSS.RuleIndexD(IndexRowid)),6)
						if IndexRuleType'=""
						{
							s FilterType=$lg($g(^CT.WDT.CDSS.ChartTypeD(IndexRuleType)),3)
							continue:FilterType["推荐"
							continue:FilterType["鉴别"
							continue:FilterType["出院"
						}
						
					}
					else
					{
						continue:Vision["sds"
					}
					s RuleType=""
					for
					{
						s RuleType=$o(^CT.WDT.CDSS.RuleIndexI("IRTypeFlowIndex",IdentifyWordsDR, RuleRowId, RuleType))
						q:RuleType=""
						
						s RuleFlowNum=0
						for
						{
							s RuleFlowNum=$o(^CT.WDT.CDSS.RuleIndexI("IRTypeFlowIndex",IdentifyWordsDR, RuleRowId, RuleType,RuleFlowNum))
							q:RuleFlowNum=""
							
							s TotalMeetNum = 0
							
							//获取当前流程图中应该匹配成功的识别词个数
							s NodeNum=0
							for
							{
								s NodeNum=$o(^CT.WDT.CDSS.RuleNodeI("ChartNumIndex",RuleRowId, RuleType, RuleFlowNum, NodeNum))
								q:NodeNum=""
								
								s NodeRowid = $o(^CT.WDT.CDSS.RuleNodeI("ChartNumIndex",RuleRowId, RuleType, RuleFlowNum, NodeNum,0))
								
								s NodeType=$lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowid)),5)	 //节点类型
								s NodeTypeDesc=""
								s:NodeType'="" NodeTypeDesc=$lg($g(^CT.WDT.CDSS.NodeTypeD(NodeType)),3) //节点类型描述
								if (NodeTypeDesc="主要条件-诊断")||(NodeTypeDesc="主要条件-识别词")
								{
									s MeetConditionNum = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowid)),6)
									s:MeetConditionNum="" MeetConditionNum=1
									s TotalMeetNum=TotalMeetNum+MeetConditionNum
								}
							}
						
							s MatchedNum=0    //查看患者识别词在此规则的这个流程图中一共有多少匹配成功的
							s IWRowid=0
							for
							{
								s IWRowid=$o(^CT.WDT.CDSS.RuleIndexI("RuleTypeFlowIndex",RuleRowId,RuleType,RuleFlowNum,IWRowid))
								q:IWRowid=""
								
								if $d(^WDT.CDSS.PatTriggerIWI("PatVisTypeIWIndex",PatientDR,VisitID,VisitType, IWRowid))
								{
									s MatchedNum=MatchedNum+1
									q:MatchedNum=TotalMeetNum  //如果患者识别词匹配成功流程图个数则退出
								}
							}  

							if (ProVision="sds")  //如果是数据中台 走过滤
							{

								if $l(RecomType,",")=1
								{
									if '$d(^CDSSMatchRule(ProVision,RecomType,RuleRowId,RuleType,RuleFlowNum))
									{
										continue
									}
								}
								else
								{
									s RecomFlag=0
									for RecomIndex=1:1:$l(RecomType,",")
									{
										s RecomTypeItem =$p(RecomType,",",RecomIndex)
										continue:RecomTypeItem=""
										
										if $d(^CDSSMatchRule(ProVision,RecomTypeItem,RuleRowId,RuleType,RuleFlowNum))
										{
											s RecomFlag=1
											q
										}
									}
									continue:RecomFlag=0
								}
								

							}  
							
							if TotalMeetNum<=MatchedNum
							{
								s RuleArray(RuleRowId,RuleType,RuleFlowNum)=""
							}
							
						}
						
					}
					
				}
				
			}
		
		}
		
		//获取现有触发的规则
		if ($d(^WDT.CDSS.PatTriggerRuleI("PatVisTypeRuleTypeDRFlowIndex",PatientDR,VisitID,VisitType)))
		{
			s RuleRowId=0
			for 
			{
				s RuleRowId =$o(^WDT.CDSS.PatTriggerRuleI("PatVisTypeRuleTypeDRFlowIndex",PatientDR,VisitID,VisitType,RuleRowId))    //根据识别词获取规则
				q:RuleRowId=""
				
				s RuleType=""
				for
				{                                            
					s RuleType=$o(^WDT.CDSS.PatTriggerRuleI("PatVisTypeRuleTypeDRFlowIndex",PatientDR,VisitID,VisitType,RuleRowId,RuleType))
					q:RuleType=""
					
					s RuleFlowNum=0
					for
					{
						s RuleFlowNum=$o(^WDT.CDSS.PatTriggerRuleI("PatVisTypeRuleTypeDRFlowIndex",PatientDR,VisitID,VisitType,RuleRowId,RuleType, RuleFlowNum))
						q:RuleFlowNum=""
						s RuleArray(RuleRowId,RuleType,RuleFlowNum )=""
					}
				}
				
			}	
		}	

	} 
	elseif (IDNO'="")  //患者主索引
	{
		
		s IWArray=""
		//获取当前触发的识别词涉及的规则
		if ($d(^WDT.CDSS.PatTriggerIWI("IDNOIWIndex",IDNO)))
		{

			s IdentifyWordsDR=0
			for
			{
				s IdentifyWordsDR =$o(^WDT.CDSS.PatTriggerIWI("IDNOIWIndex",IDNO,IdentifyWordsDR))  q:IdentifyWordsDR="" 
				
				s RuleRowId=0
				for
				{
					s RuleRowId=$o(^CT.WDT.CDSS.RuleIndexI("IRTypeFlowIndex",IdentifyWordsDR, RuleRowId))
					q:RuleRowId=""
					
					if RuleId'=""
					{
						continue:RuleId'=RuleRowId
					}
					
					s Vision=$lg($g(^CT.WDT.CDSS.RuleDictD(RuleRowId)),14)
					
					s TCMFlag = ##class(web.CDSS.Config.MKBConfig).GetConfigValue("TCM")
					if TCMFlag=0
					{
						continue:Vision["中医"
					}
					if ProVision="sds"  //sds
					{
						continue:Vision'="sds"
					}
					elseif ProVision="emr-gender"
					{
						
						s GenderIWRowid=$o(^CT.WDT.CDSS.IdentifyWordsI("DescIndex"," 性别",0))
						continue:'$d(^CT.WDT.CDSS.RuleIndexI("RuleIWDRIndex",RuleRowId,GenderIWRowid))
						s IndexRowid=$o(^CT.WDT.CDSS.RuleIndexI("RuleIWDRIndex",RuleRowId,GenderIWRowid,""))
						s IndexRuleType =$lg($g(^CT.WDT.CDSS.RuleIndexD(IndexRowid)),6)
						if IndexRuleType'=""
						{
							s FilterType=$lg($g(^CT.WDT.CDSS.ChartTypeD(IndexRuleType)),3)
							continue:FilterType["推荐"
							continue:FilterType["鉴别"
							continue:FilterType["出院"
						}
						
					}
					else
					{
						continue:Vision["sds"
					}
					
					s RuleType=""
					for
					{
						s RuleType=$o(^CT.WDT.CDSS.RuleIndexI("IRTypeFlowIndex",IdentifyWordsDR, RuleRowId, RuleType))
						q:RuleType=""
						
						s RuleFlowNum=0
						for
						{
							s RuleFlowNum=$o(^CT.WDT.CDSS.RuleIndexI("IRTypeFlowIndex",IdentifyWordsDR, RuleRowId, RuleType,RuleFlowNum))
							q:RuleFlowNum=""
							

							
							s TotalMeetNum = 0
							
							//获取当前流程图中应该匹配成功的识别词个数
							s NodeNum=0
							for
							{
								s NodeNum=$o(^CT.WDT.CDSS.RuleNodeI("ChartNumIndex",RuleRowId, RuleType, RuleFlowNum, NodeNum))
								q:NodeNum=""
								
								s NodeRowid = $o(^CT.WDT.CDSS.RuleNodeI("ChartNumIndex",RuleRowId, RuleType, RuleFlowNum, NodeNum,0))
								
								s NodeType=$lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowid)),5)	 //节点类型
								s NodeTypeDesc=""
								s:NodeType'="" NodeTypeDesc=$lg($g(^CT.WDT.CDSS.NodeTypeD(NodeType)),3) //节点类型描述
								if (NodeTypeDesc="主要条件-诊断")||(NodeTypeDesc="主要条件-识别词")
								{
									s MeetConditionNum = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowid)),6)
									s:MeetConditionNum="" MeetConditionNum=1
									s TotalMeetNum=TotalMeetNum+MeetConditionNum
								}
								
							}
								
							
							s MatchedNum=0    //查看患者识别词在此规则的这个流程图中一共有多少匹配成功的
							s IWRowid=0
							for
							{
								s IWRowid=$o(^CT.WDT.CDSS.RuleIndexI("RuleTypeFlowIndex",RuleRowId,RuleType,RuleFlowNum,IWRowid))
								q:IWRowid=""
								
								if $d(^WDT.CDSS.PatTriggerIWI("IDNOIWIndex",IDNO, IWRowid))
								{
									s MatchedNum=MatchedNum+1
									q:MatchedNum=TotalMeetNum  //如果患者识别词匹配成功流程图个数则退出
								}
							}   
							
							if (ProVision="sds")  //如果是数据中台 走过滤
							{

								if $l(RecomType,",")=1
								{
									if '$d(^CDSSMatchRule(ProVision,RecomType,RuleRowId,RuleType,RuleFlowNum))
									{
										continue
									}
								}
								else
								{
									s RecomFlag=0
									for RecomIndex=1:1:$l(RecomType,",")
									{
										s RecomTypeItem =$p(RecomType,",",RecomIndex)
										continue:RecomTypeItem=""
										if $d(^CDSSMatchRule(ProVision,RecomTypeItem,RuleRowId,RuleType,RuleFlowNum))
										{
											s RecomFlag=1
											q
										}
									}
									continue:RecomFlag=0
								}
								

							}    
							
							if TotalMeetNum<=MatchedNum
							{
								s RuleArray(RuleRowId,RuleType,RuleFlowNum)=""
							}
						}
					}
				}
				
			}
		}
		//获取现有触发的规则
		if ($d(^WDT.CDSS.PatTriggerRuleI("IDNORuleIndex",IDNO)))
		{
			s RuleRowId=0
			for 
			{
				s RuleRowId =$o(^WDT.CDSS.PatTriggerRuleI("IDNORuleTypeFlowIndex",IDNO,RuleRowId))  q:RuleRowId=""  //根据识别词获取规则
				
				s RuleType = ""
				for
				{
					s RuleType =$o(^WDT.CDSS.PatTriggerRuleI("IDNORuleTypeFlowIndex",IDNO,RuleRowId,RuleType))  q:RuleType="" 
					s RuleFlowNum = 0
					for
					{
						s RuleFlowNum =$o(^WDT.CDSS.PatTriggerRuleI("IDNORuleTypeFlowIndex",IDNO,RuleRowId,RuleType,RuleFlowNum))  q:RuleFlowNum="" 
						s RuleArray(RuleRowId, RuleType,RuleFlowNum)=""
					}
					
				}
			}	
		}
	}
	
	d ..GetSingleNodeType(.RuleArray,ProVision,RuleId)
	//判断规则是否满足条件 满足保存到患者规则表
	s RuleRowId=0
	for
	{
		s RuleRowId=$o(RuleArray(RuleRowId)) q:RuleRowId=""
		//触发范围按照生成索引来控制
		s RuleStatus=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowId)),8)
		s RuleResultFlag = ""
		s IpAddress = ##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020061901")
		if IpAddress["119.96.225.237"
		{
			s RuleDictStatus="已上线&审核通过"
		}
		else
		{
			s RuleDictStatus="已上线"
		}
		if (RuleDictStatus'[RuleStatus)
		{
			s RuleResultFlag=""
			if $d(^WDT.CDSS.PatTriggerRuleI("PatVisRuleDRIndex",PatientDR,VisitID,VisitType,RuleRowId))
			{
				s PatRowid=0
				for
				{
					s PatRowid=$o(^WDT.CDSS.PatTriggerRuleI("PatVisRuleDRIndex",PatientDR,VisitID,VisitType,RuleRowId,PatRowid))
					q:PatRowid=""
					s delsc=##class(WDT.CDSS.PatTriggerRule).%DeleteId(PatRowid)
				}
			}
		}
		else
		{	
			
			//如果存在先删掉再增加
			if (PatientDR'="")&&(VisitID'="")&&$d(^WDT.CDSS.PatTriggerRuleI("PatVisRuleDRIndex",PatientDR,VisitID,VisitType,RuleRowId))
			{
				s PatRuleRowId=0
				for
				{
					s PatRuleRowId=$O(^WDT.CDSS.PatTriggerRuleI("PatVisRuleDRIndex",PatientDR,VisitID,VisitType,RuleRowId,PatRuleRowId)) q:PatRuleRowId=""
					s delsc=##class(WDT.CDSS.PatTriggerRule).%DeleteId(PatRuleRowId)
				}
			}
			elseif (IDNO'="")&&$d(^WDT.CDSS.PatTriggerRuleI("IDNORuleIndex",IDNO,RuleRowId))
			{
				s PatRuleRowId=0
				for
				{
					s PatRuleRowId=$O(^WDT.CDSS.PatTriggerRuleI("IDNORuleIndex",IDNO,RuleRowId,PatRuleRowId)) q:PatRuleRowId=""
					s delsc=##class(WDT.CDSS.PatTriggerRule).%DeleteId(PatRuleRowId)
				}
			}
			
			s RuleType=""
			for
			{
				s RuleType=$o(RuleArray(RuleRowId,RuleType))
				q:RuleType=""
				
				s RuleFlowNum=0
				for
				{
					s RuleFlowNum=$o(RuleArray(RuleRowId,RuleType,RuleFlowNum))
					q:RuleFlowNum=""
					s RuleTypeA = $lg($g(^CT.WDT.CDSS.RuleDictD(RuleRowId)),6)
					if RuleTypeA'=""
					{
						s RuleTypeADesc = $lg($g(^CT.WDT.CDSS.ChartTypeD(RuleTypeA)),3)
						if RuleTypeADesc="评估表自动勾选"
						{
							continue
						}
					}

					//w RuleRowId_" "_$lg(^CT.WDT.CDSS.ChartTypeD(RuleType),3)_" "_RuleFlowNum_" "_PatientInfo,!
					s RuleResultFlag=..DealMedicalRule(RuleRowId,RuleType,RuleFlowNum,PatientInfo)
					if (RuleResultFlag'="")
					{
						s num=$p(RuleResultFlag,"&&",1)
						s RuleTypeDR=$p(RuleResultFlag,"&&",2)
						s IWordStr=$p(RuleResultFlag,"&&",3)

						if ((PatientDR'="")&&(VisitID'="")&&('$d(^WDT.CDSS.PatTriggerRuleI("PatVisTypeRuleTypeDRFlowIndex",PatientDR,VisitID,VisitType,RuleRowId,RuleTypeDR,num)))&((IDNO'="")&&('$d(^WDT.CDSS.PatTriggerRuleI("IDNORuleTypeFlowIndex",IDNO,RuleRowId,RuleTypeDR,num)))))
						{
							
							s:RuleTypeDR="-100000000000000" RuleTypeDR=""
							Ts
							s obj=##class(WDT.CDSS.PatTriggerRule).%New()
							s obj.IDNO=IDNO
							s obj.PatientDR=PatientDR
							s obj.VisitID=VisitID
							s obj.VisitType=VisitType
							d obj.RuleDRSetObjectId(RuleRowId)
							s obj.FlowChartNum=num
							d obj.RuleTypeDRSetObjectId(RuleTypeDR)
							s obj.PRuleFlowIWordStr=IWordStr
							s sc=obj.%Save()
			                d obj.%Close()
			              	
			                If $$$ISOK(sc)
				            {
				                Tc
				                s id = obj.%Id()
				                //保存日志
								//d ##class(web.CDSS.Config.DataChangeLog).SaveLog("PatTriggerRule","WDT.CDSS.PatTriggerRule","患者当前触发的规则",id,obj.IDNO,"A",obj)
							}
				            else
				            {
				                Trollback
				                
				                s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
				                //s logid=##class(web.DHCBL.MKB.SysErrorLog).SaveLog("患者当前触发的规则","web.CDSS.MedicalRule.DiagAndTreatR","SaveData",obj)
				       	    	//s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
				            }
						}
					
					}
					
				}
			}	
		}
	}

	if DiseaseFlag'=""
	{
		s PatientInfo=PatientInfo_"^"_DiseaseFlag
	}

	//保存推荐信息到患者推荐信息表
	d ##class(web.CDSS.MedicalRule.GetPatientRuleResult).SaveSatisfyRuleResult(PatientInfo, ProVision)
	
	q 1
}

/// Creator:丁亚男
/// CreatDate:2021-08-02
/// Description:判断对应规则的规则条件是否满足，返回满足条件的规则流程图顺序号串
/// Table: CT.WDT.CDSS.RuleNode
/// Input: RuleDR ：规则rowId，PatientInfo ：患者信息
/// Return:满足返回规则流程图顺序号串，不满足返回0
/// Others:w ##class(web.CDSS.MedicalRule.GetPatientRule).DealMedicalRule("11211",13,1,"TMPAPI7028^TMPAPI7028^1^住院^TMPAPI7028^TMPAPI7028^^1")
ClassMethod DealMedicalRule(RuleDR As %String, RuleTypeDR As %String, FlowChartNum As %String, PatientInfo As %String) As %String
{
	s DrugFlag=0
	s ExamLabInfo=""
	
	s ChartNumStr=""
	s RuleTypeRowId=$Lg($g(^CT.WDT.CDSS.RuleDictD(RuleDR)),6)
	q:RuleTypeRowId="" ""
	s RuleTypeDesc=$lg($g(^CT.WDT.CDSS.ChartTypeD(RuleTypeRowId)),3)
	s PatientDR=$p(PatientInfo,"^",2)
	s VisitID=$p(PatientInfo,"^",3)
	s VisitType=$p(PatientInfo,"^",4)
	s IWordStr="" //触发规则的识别词id串
	s SatisfyFlag="" //满足规则的标志
	s NodeRowId=""
	for
	{
		s NodeRowId=$o(^CT.WDT.CDSS.RuleNodeI("TypeChartIndex",RuleDR,RuleTypeDR,FlowChartNum,NodeRowId)) q:(NodeRowId="")||(SatisfyFlag=0) //节点
		s NodeType=$lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowId)),5)	 //节点类型
		s NodeTypeDesc=""
		s:NodeType'="" NodeTypeDesc=$lg($g(^CT.WDT.CDSS.NodeTypeD(NodeType)),3) //节点类型描述

		if (NodeTypeDesc="通过条件")||(NodeTypeDesc="基本信息-年龄")||(NodeTypeDesc="基本信息-性别")||(NodeTypeDesc="主要条件-诊断")||(NodeTypeDesc="主要条件-识别词")||(NodeTypeDesc="否定条件-识别词")||(NodeTypeDesc="否定条件-诊断")
		{
			s MeetConditionNum=$lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowId)),6)  //该节点下需要满足的条件个数
			S:MeetConditionNum="" MeetConditionNum=1
			s CurMeetConditionNum=0
			s ConditionRowId=0
			for
			{
				s ConditionRowId = $o(^CT.WDT.CDSS.RuleConditionI("NodeDRIndex",NodeRowId,ConditionRowId)) q:(ConditionRowId="")||(CurMeetConditionNum=MeetConditionNum)||(SatisfyFlag=0)  //触发条件类节点内容
				s ConditionClass  = $lg($g(^CT.WDT.CDSS.RuleConditionD(ConditionRowId)),3) //条件数据类型（性别、年龄、体质、诊断、主诉、现病史、既往史、个人史、婚育史、体征、检查、检验、药物、手术等）
				s:ConditionClass="" ConditionClass=$CASE(NodeTypeDesc,"基本信息-年龄":"年龄(天)","基本信息-性别":"性别","主要条件-诊断":"主要条件-诊断","否定条件-诊断":"主要条件-诊断",:"识别条件") //注意识别词类型也转化成诊断
				s ConditionItem  = $lg($g(^CT.WDT.CDSS.RuleConditionD(ConditionRowId)),4) //规则条件对应字段名称
				s:ConditionClass="诊断" ConditionItem="DiagnosisName"
				s ConditionItemCalculate  = $lg($g(^CT.WDT.CDSS.RuleConditionD(ConditionRowId)),5) //运算符
				s ConditionItemValue  = $lg($g(^CT.WDT.CDSS.RuleConditionD(ConditionRowId)),6)  //规则条件值
				s ConditionItemValUnit  = $lg($g(^CT.WDT.CDSS.RuleConditionD(ConditionRowId)),7) //规则条件值单位
				s SpecialConfig=$lg($g(^CT.WDT.CDSS.RuleConditionD(ConditionRowId)),8) //规则条件值单位
				s ConditionItemCategory = $lg($g(^CT.WDT.CDSS.RuleConditionD(ConditionRowId)),10)
				s ConditionItemValUnitN=""
				s:ConditionItemValUnit'="" ConditionItemValUnitN= $lg($g(^CT.WDT.CDSS.UnitDictD(ConditionItemValUnit)),3)

				if (ConditionItem="Age")
				{
					//s ConditionItemValue  = $lg($g(^CT.WDT.CDSS.RuleConditionD(ConditionRowId)),9)  //备注 年龄(天)
					//很多备注没有按照要求保存
					s ConditionItemValue=##class(web.CDSS.CMKB.FunLib).TransforDateFormat(ConditionItemValue,ConditionItemValUnitN)	
					s ConditionClass="年龄(天)"
				}
				
				if (ConditionClass="识别条件")||(ConditionClass="主要条件-诊断")
				{
					s IdentifyFlag=..DealIdentifyWords(ConditionItemValue,PatientInfo,ConditionClass,ConditionItemCategory,SpecialConfig)

					if ((RuleTypeDesc["检验合理性")||(RuleTypeDesc["检查合理性"))&&(IdentifyFlag=1)
					{

						s WordsRowId=$o(^CT.WDT.CDSS.IdentifyWordsI("DescTypeIndex",ConditionItemValue,ConditionClass,0))
						if WordsRowId'=""
						{
							if $d(^WDT.CDSS.PatTriggerIWI("PatVisTypeIWIndex",PatientDR,VisitID,VisitType,WordsRowId))
							{
								s TriggerIWRowid=$o(^WDT.CDSS.PatTriggerIWI("PatVisTypeIWIndex",PatientDR,VisitID,VisitType,WordsRowId,0))
								s PTableNameStr=$lg($g(^WDT.CDSS.PatTriggerIWD(TriggerIWRowid)),8)
								s PFiledValueStr=$lg($g(^WDT.CDSS.PatTriggerIWD(TriggerIWRowid)),10)
								if PTableNameStr["DrugInfo"   //如果包含药品
								{
									s DrugFlag=1
								}
								if (PTableNameStr["ExamInfo")||(PTableNameStr["LabInfo")
								{
									s ExamLabInfo=$replace(PFiledValueStr,"&","")
								}
							}
						}
						
					}
					
					if (RuleTypeDesc="出院指导")&&(ConditionClass="主要条件-诊断")
					{
						
						s DischargeFlag=0
						s PatientDR=$p(PatientInfo,"^",2)
						s VisitId=$p(PatientInfo,"^",3)
						s DiagRowid=0
						for
						{
							s DiagRowid=$o(^WDT.CDSS.DiagnosisInfoI("PatVisDRIndex",PatientDR,VisitId,VisitType,DiagRowid))
							q:DiagRowid=""
							s DiagName=$lg($g(^WDT.CDSS.DiagnosisInfoD(DiagRowid)),9)
							s DiagType=$lg($g(^WDT.CDSS.DiagnosisInfoD(DiagRowid)),6)
							
							if (DiagName=ConditionItemValue)&&(DiagType=5)
							{
								s DischargeFlag=1
								q
							}
						}
						if DischargeFlag=1
						{
							s IdentifyFlag=1
						}
						else
						{
							s IdentifyFlag=0
						}
						
					}
					
					if (IdentifyFlag=1)
					{
						if ConditionClass="主要条件-诊断"
						{
							s ConditionClass="诊断条件"
						}
						s CurMeetConditionNum=CurMeetConditionNum+1
						s WordsRowId=$o(^CT.WDT.CDSS.IdentifyWordsI("DescTypeIndex",ConditionItemValue,ConditionClass,0))
						s:IWordStr'="" IWordStr=IWordStr_"[A]"_WordsRowId
						s:IWordStr="" IWordStr=WordsRowId
					}
				}
				else
				{
				
					//s PInfoItem=##class(web.CDSS.IdentifyWords.GetPatientInfo).DealDataByPatientEnumI(PatientInfo,ConditionClass) //取患者模型的数据，并且预处理 后期优化2021-08-02 By Dingyanan
					s PInfoItem =$g(^TempPInfoItemData($j,PatientInfo,ConditionClass))
					
					if (PInfoItem="")  //所需类型信息在患者模型中不存在时，继续下一条规则条件的判断
					{
						s SatisfyFlag=0
						continue 
					}
					s PInfoItem=[].%FromJSON(PInfoItem)
					
					s ConditionSatisfyFlag="" //条件是否满足
					for i=0:1:(PInfoItem.%Size()-1)  //遍历条件判断是否满足
					{
						
						//w """"_(PInfoItem.%Get(i)).%Get(ConditionItem)_""""ConditionItemCalculate""""ConditionItemValue"""",!
						//w (""""_$tr((PInfoItem.%Get(i)).%Get(ConditionItem),"""","'")_""""_ConditionItemCalculate_""""_$tr(ConditionItemValue,"""","'")_""""),!
						if @(""""_$tr((PInfoItem.%Get(i)).%Get(ConditionItem),"""","'")_""""_ConditionItemCalculate_""""_$tr(ConditionItemValue,"""","'")_"""") //满足条件
						{
							continue:((PInfoItem.%Get(i)).%Get(ConditionItem)="")||(ConditionItemValue="")  //不存在患者信息 默认不满足
							s ConditionSatisfyFlag=1
						}
						else //不满足条件
						{
							if (ConditionItem="Age")  //年龄的条件一个不满足就判定不满足
							{
								s SatisfyFlag=0
							}
							
						}
					}
					s:ConditionSatisfyFlag=1 CurMeetConditionNum=CurMeetConditionNum+1
				}
				
			}
			
			if ((CurMeetConditionNum<MeetConditionNum)&(NodeTypeDesc'["否定条件"))||((CurMeetConditionNum>=MeetConditionNum)&(NodeTypeDesc["否定条件"))  //当前节点没有满足条件 否定条件-识别词、否定条件-诊断
			{
				s SatisfyFlag=0
			}
			elseif ((CurMeetConditionNum>=MeetConditionNum)&(NodeTypeDesc["通过条件"))
			{
				s SatisfyFlag=0
			}
			elseif ((CurMeetConditionNum<MeetConditionNum)&(NodeTypeDesc["通过条件"))
			{
				s SatisfyFlag=1
			}
			else
			{
				s SatisfyFlag=1
			}
		}
	}
	
	if ((RuleTypeDesc["检验合理性")||(RuleTypeDesc["检查合理性"))&&(DrugFlag=1)&&(ExamLabInfo'="")&&(SatisfyFlag=1)
	{
		s RuleTypeDict={"检验合理性":"检验","检查合理性":"检查"}
		s DataType=RuleTypeDict.%Get(RuleTypeDesc)

		s ExamLabStr=$g(^TempPInfoItemData($j,PatientInfo,DataType,"InspectionName",ExamLabInfo))
		s ExecuteTime=""
		if ExamLabStr'=""
		{
			s ExamLabJson={}.%FromJSON(ExamLabStr)
			s ExecuteTime=ExamLabJson.%Get("children").%Get(0).%Get("ExecuteTime")
		}
		if ExecuteTime'=""
		{
			s SatisfyFlag=0
		}
		
	}
	
	if (SatisfyFlag=1)
	{
		s:ChartNumStr'="" ChartNumStr=ChartNumStr_"^"_FlowChartNum_"&&"_RuleTypeDR_"&&"_IWordStr
		s:ChartNumStr="" ChartNumStr=FlowChartNum_"&&"_RuleTypeDR_"&&"_IWordStr
	}
	
	q ChartNumStr
}

/// Creator:丁亚男
/// CreatDate:2021-08-02
/// Description:判断对应识别词是否在患者识别词表
/// Table: WDT.CDSS.PatTriggerIW
/// Input: CT.WDT.CDSS.IdentifyWords ：WordsDesc 识别词描述，PatientInfo ：患者信息
/// Return:满足返回1，不满足返回0
/// Others:w ##class(web.CDSS.MedicalRule.GetPatientRule).DealIdentifyWords("脑梗死","DM000751^DM000751^1^住院^48^李得原^1^信息科^Y","主要条件-诊断","西医")
ClassMethod DealIdentifyWords(WordsDesc As %String, PatientInfo As %String, WordsType As %String, ConditionItemCategory As %String, SpecialConfig As %String = "new") As %String
{
	if WordsType["诊断"
	{
		s WordsType="诊断条件"
	}
	s:ConditionItemCategory="中医" WordsType="中医"_WordsType
	s WordsRowId=$o(^CT.WDT.CDSS.IdentifyWordsI("DescTypeIndex",WordsDesc,WordsType,0))
	q:WordsRowId="" 0
	s WordsState=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),5)
	q:WordsState'="已上线" 0
	s FinalFlag=0  //赋初值,不存在识别词
	
	s IDNO=$p(PatientInfo,"^",1)
	s PatientDR=$p(PatientInfo,"^",2)
	s VisitID=$p(PatientInfo,"^",3)
	s VisitType=$p(PatientInfo,"^",4)
	s Config=$p(PatientInfo,"^",9)
	s Type=$p(PatientInfo,"^",10)
	if (Config="") s Config=1	//是否启用流水号（急诊号、门诊号、住院号）为患者就诊唯一标识（0为是，1为否），默认为1
	if (Config=1)&(PatientDR'="")&(VisitID'="") // 单个患者单次就诊 根据病人标识和就诊次数编号取数据
	{
		if ($d(^WDT.CDSS.PatTriggerIWI("PatVisTypeIWIndex",PatientDR,VisitID,VisitType,WordsRowId)))
		{
			s PatTriRowid=$o(^WDT.CDSS.PatTriggerIWI("PatVisTypeIWIndex",PatientDR,VisitID,VisitType,WordsRowId,""))
			s NewOldFlag=$lg($g(^WDT.CDSS.PatTriggerIWD(PatTriRowid)),11)
			s:NewOldFlag="" NewOldFlag="new&all"
			if NewOldFlag[SpecialConfig
			{
				s FinalFlag=1   //存在识别词
			}
		}
	} 
	elseif (IDNO'="")  //患者主索引
	{
		if ($d(^WDT.CDSS.PatTriggerIWI("IDNOIWIndex",IDNO,WordsRowId)))
		{
			s PatTriRowid=$o(^WDT.CDSS.PatTriggerIWI("IDNOIWIndex",IDNO,WordsRowId,""))
			s NewOldFlag=$lg($g(^WDT.CDSS.PatTriggerIWD(PatTriRowid)),11)
			s:NewOldFlag="" NewOldFlag="new&all"
			if NewOldFlag[SpecialConfig
			{
				s FinalFlag=1   //存在识别词
			}
		}
		
	}
	q FinalFlag
}

/// Creator:丁亚男
/// CreatDate:2021-08-24
/// Description:测试遍历所有规则
/// Table: CT.WDT.CDSS.IdentifyWords
/// Input: PatientInfo ：患者信息
/// Return:成功返回1，失败返回0
/// Others:w ##class(web.CDSS.MedicalRule.GetPatientRule).TestALLRule("心房颤动^心房颤动^1^门诊^6464^石萧伟^111^信息部^1")
ClassMethod TestALLRule(PatientInfo As %String) As %String
{
	s IDNO=$p(PatientInfo,"^",1)
	s PatientDR=$p(PatientInfo,"^",2)
	s VisitID=$p(PatientInfo,"^",3)
	s VisitType=$p(PatientInfo,"^",4)
	s Config=$p(PatientInfo,"^",9)
	s Type=$p(PatientInfo,"^",10)
	if (Config="") s Config=1	//是否启用流水号（急诊号、门诊号、住院号）为患者就诊唯一标识（0为是，1为否），默认为1
	
	//判断规则是否满足条件 满足保存到患者规则表
	s RuleRowId=0
	for
	{
		s RuleRowId=$o(^CT.WDT.CDSS.RuleDictD(RuleRowId)) q:RuleRowId=""
		s RuleStatus=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowId)),8)
		//continue:RuleStatus'="已上线"
		s RuleResultFlag=..DealMedicalRule(RuleRowId,PatientInfo)
		//如果存在先删掉再增加
		if $d(^WDT.CDSS.PatTriggerRuleI("PatVisRuleDRIndex",PatientDR,VisitID,VisitType,RuleRowId))
		{
			s PatRuleRowId=0
			for
			{
				s PatRuleRowId=$O(^WDT.CDSS.PatTriggerRuleI("PatVisRuleDRIndex",PatientDR,VisitID,VisitType,RuleRowId,PatRuleRowId)) q:PatRuleRowId=""
				s delsc=##class(WDT.CDSS.PatTriggerRule).%DeleteId(PatRuleRowId)
			}
		}
		elseif $d(^WDT.CDSS.PatTriggerRuleI("IDNORuleIndex",IDNO,RuleRowId))
		{
			s PatRuleRowId=0
			for
			{
				s PatRuleRowId=$O(^WDT.CDSS.PatTriggerRuleI("IDNORuleIndex",IDNO,RuleRowId,PatRuleRowId)) q:PatRuleRowId=""
				s delsc=##class(WDT.CDSS.PatTriggerRule).%DeleteId(PatRuleRowId)
			}
		}
			
		
		if (RuleResultFlag'="")
		{
			s LenRule=$length(RuleResultFlag,"^")
			for irule=1:1:LenRule
			{
				s str=$p(RuleResultFlag,"^",irule)
				s num=$p(str,"&&",1)
				s RuleTypeDR=$p(str,"&&",2)
				if ('$d(^WDT.CDSS.PatTriggerRuleI("PatVisRuleDRFlowIndex",PatientDR,VisitID,VisitType,RuleRowId,num))&('$d(^WDT.CDSS.PatTriggerRuleI("IDNORuleFlowIndex",IDNO,RuleRowId,num))))
				{
					Ts
					s obj=##class(WDT.CDSS.PatTriggerRule).%New()
					s obj.IDNO=IDNO
					s obj.PatientDR=PatientDR
					s obj.VisitID=VisitID
					s obj.VisitType=VisitType
					d obj.RuleDRSetObjectId(RuleRowId)
					s obj.FlowChartNum=num
					d obj.RuleTypeDRSetObjectId(RuleTypeDR)
					s sc=obj.%Save()
	                d obj.%Close()
	                If $$$ISOK(sc)
		            {
		                Tc
		                s id = obj.%Id()
		                //保存日志
						d ##class(web.CDSS.Config.DataChangeLog).SaveLog("PatTriggerRule","WDT.CDSS.PatTriggerRule","患者当前触发的规则",id,obj.IDNO,"A",obj)
					}
		            else
		            {
		                Trollback
		                s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		                s logid=##class(web.DHCBL.MKB.SysErrorLog).SaveLog("患者当前触发的规则","web.CDSS.MedicalRule.DiagAndTreatR","SaveData",obj)
		       	    	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		            }
				}
			}
		}	
	}
	q 1
}

ClassMethod GetSatisfyRule2(PatientInfo As %String) As %String
{
	s IDNO=$p(PatientInfo,"^",1)
	s PatientDR=$p(PatientInfo,"^",2)
	s VisitID=$p(PatientInfo,"^",3)
	s VisitType=$p(PatientInfo,"^",4)
	s Config=$p(PatientInfo,"^",9)
	s Type=$p(PatientInfo,"^",10)
	if (Config="") s Config=1	//是否启用流水号（急诊号、门诊号、住院号）为患者就诊唯一标识（0为是，1为否），默认为1
	s RuleArray=""  //符合索引条件的规则
	if (Config=1)&(PatientDR'="")&(VisitID'="") // 单个患者单次就诊 根据病人标识和就诊次数编号取数据
	{
		//获取当前触发的识别词涉及的规则
		if ($d(^WDT.CDSS.PatTriggerIWI("PatVisDRIWIndex",PatientDR,VisitID)))
		{
			s IdentifyWordsDR=0
			for
			{
				s IdentifyWordsDR =$o(^WDT.CDSS.PatTriggerIWI("PatVisDRIWIndex",PatientDR,VisitID,IdentifyWordsDR))  q:IdentifyWordsDR="" 
				s RuleRowId=0
				for 
				{
					s RuleRowId =$o(^CT.WDT.CDSS.RuleIndexI("IWRuleDRIndex",IdentifyWordsDR,RuleRowId))  q:RuleRowId=""  //根据识别词获取规则
					s RuleArray(RuleRowId)=""
				}
			}
		}
		//获取现有触发的规则
		if ($d(^WDT.CDSS.PatTriggerRuleI("PatVisRuleDRIndex",PatientDR,VisitID,VisitType)))
		{
			s RuleRowId=0
			for 
			{
				s RuleRowId =$o(^WDT.CDSS.PatTriggerRuleI("PatVisRuleDRIndex",PatientDR,VisitID,VisitType,RuleRowId))  q:RuleRowId=""  //根据识别词获取规则
				s RuleArray(RuleRowId)=""
			}	
		}
	} 
	elseif (IDNO'="")  //患者主索引
	{
		//获取当前触发的识别词涉及的规则
		if ($d(^WDT.CDSS.PatTriggerIWI("IDNOIWIndex",IDNO)))
		{
			s IdentifyWordsDR=0
			for
			{
				s IdentifyWordsDR =$o(^WDT.CDSS.PatTriggerIWI("IDNOIWIndex",IDNO,IdentifyWordsDR))  q:IdentifyWordsDR=""  
				s RuleRowId=0
				for 
				{
					s RuleRowId =$o(^CT.WDT.CDSS.RuleIndexI("IWRuleDRIndex",IdentifyWordsDR,RuleRowId))  q:RuleRowId=""  //根据识别词获取规则
					s RuleArray(RuleRowId)=""
				}
			}
		}
		//获取现有触发的规则
		if ($d(^WDT.CDSS.PatTriggerRuleI("IDNORuleIndex",IDNO)))
		{
			s RuleRowId=0
			for 
			{
				s RuleRowId =$o(^WDT.CDSS.PatTriggerRuleI("IDNORuleIndex",IDNO,RuleRowId))  q:RuleRowId=""  //根据识别词获取规则
				s RuleArray(RuleRowId)=""
			}	
		}
	}	
	
	
	s sc =""
    Set queue=##class(%SYSTEM.WorkMgr).Initialize("/multicompile=2",.sc) 
    If $$$ISERR(sc) {
       Return sc
    }
	s RuleRowId = 0
	for 
	{
		s RuleRowId=$o(RuleArray(RuleRowId)) q:RuleRowId=""
		
		s RuleStatus=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowId)),8)
		
		if (RuleStatus'="已上线")
		{
			continue
		}
		else
		{
			s JobNum = $j
	        Set sc=queue.Queue("..DealMedicalRule2",RuleRowId,PatientInfo,JobNum)
	        If $$$ISERR(sc) { 
	            Return sc
	        }
		}
		
	}
    Set sc=queue.WaitForComplete()
    If $$$ISERR(sc) { 
        w sc,!
    }
	
	
	//保存推荐信息到患者推荐信息表
	d ##class(web.CDSS.MedicalRule.GetPatientRuleResult).SaveSatisfyRuleResult(PatientInfo)

	q 1
}

ClassMethod DealMedicalRule2(RuleDR As %String, PatientInfo As %String, JobNum As %String) As %String
{
	s IDNO=$p(PatientInfo,"^",1)
	s PatientDR=$p(PatientInfo,"^",2)
	s VisitID=$p(PatientInfo,"^",3)
	s VisitType=$p(PatientInfo,"^",4)

	s ChartNumStr=""
	s RuleTypeDR="" //图类型
	for
	{
		s RuleTypeDR=$o(^CT.WDT.CDSS.RuleNodeI("TypeChartIndex",RuleDR,RuleTypeDR)) q:(RuleTypeDR="") //图类型  治疗方案和预警为空
		s FlowChartNum="" //顺序号
		for
		{
			s FlowChartNum=$o(^CT.WDT.CDSS.RuleNodeI("TypeChartIndex",RuleDR,RuleTypeDR,FlowChartNum)) q:(FlowChartNum="") //流程图顺序号
			//w "FlowChartNum: "_FlowChartNum,!
			s IWordStr="" //触发规则的识别词id串
			s SatisfyFlag="" //满足规则的标志
			s NodeRowId=""
			for
			{
				s NodeRowId=$o(^CT.WDT.CDSS.RuleNodeI("TypeChartIndex",RuleDR,RuleTypeDR,FlowChartNum,NodeRowId)) q:(NodeRowId="")||(SatisfyFlag=0) //节点
				s NodeType=$lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowId)),5)	 //节点类型
				s NodeTypeDesc=""
				s:NodeType'="" NodeTypeDesc=$lg($g(^CT.WDT.CDSS.NodeTypeD(NodeType)),3) //节点类型描述
				
				if (NodeTypeDesc="基本信息-年龄")||(NodeTypeDesc="基本信息-性别")||(NodeTypeDesc="主要条件-诊断")||(NodeTypeDesc="主要条件-识别词")||(NodeTypeDesc="否定条件-识别词")||(NodeTypeDesc="否定条件-诊断")
				{
					s MeetConditionNum=$lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowId)),6)  //该节点下需要满足的条件个数
					S:MeetConditionNum="" MeetConditionNum=1
					s CurMeetConditionNum=0
					s ConditionRowId=0
					for
					{
						s ConditionRowId = $o(^CT.WDT.CDSS.RuleConditionI("NodeDRIndex",NodeRowId,ConditionRowId)) q:(ConditionRowId="")||(CurMeetConditionNum=MeetConditionNum)||(SatisfyFlag=0)  //触发条件类节点内容
						s ConditionClass  = $lg($g(^CT.WDT.CDSS.RuleConditionD(ConditionRowId)),3) //条件数据类型（性别、年龄、体质、诊断、主诉、现病史、既往史、个人史、婚育史、体征、检查、检验、药物、手术等）
						s:ConditionClass="" ConditionClass=$CASE(NodeTypeDesc,"基本信息-年龄":"年龄(天)","基本信息-性别":"性别","主要条件-诊断":"主要条件-诊断","否定条件-诊断":"主要条件-诊断",:"识别条件") //注意识别词类型也转化成诊断
						s ConditionItem  = $lg($g(^CT.WDT.CDSS.RuleConditionD(ConditionRowId)),4) //规则条件对应字段名称
						s:ConditionClass="诊断" ConditionItem="DiagnosisName"
						s ConditionItemCalculate  = $lg($g(^CT.WDT.CDSS.RuleConditionD(ConditionRowId)),5) //运算符
						s ConditionItemValue  = $lg($g(^CT.WDT.CDSS.RuleConditionD(ConditionRowId)),6)  //规则条件值
						s ConditionItemValUnit  = $lg($g(^CT.WDT.CDSS.RuleConditionD(ConditionRowId)),7) //规则条件值单位
						s SpecialConfig=$lg($g(^CT.WDT.CDSS.RuleConditionD(ConditionRowId)),8)
						s ConditionItemValUnitN=""
						s:ConditionItemValUnit'="" ConditionItemValUnitN= $lg($g(^CT.WDT.CDSS.UnitDictD(ConditionItemValUnit)),3)
						if (ConditionItem="Age")
						{
							//s ConditionItemValue  = $lg($g(^CT.WDT.CDSS.RuleConditionD(ConditionRowId)),9)  //备注 年龄(天)
							//很多备注没有按照要求保存
							s ConditionItemValue=##class(web.CDSS.CMKB.FunLib).TransforDateFormat(ConditionItemValue,ConditionItemValUnitN)	
							s ConditionClass="年龄(天)"
						}
						
						if (ConditionClass="识别条件")||(ConditionClass="主要条件-诊断")
						{
							s IdentifyFlag=..DealIdentifyWords(ConditionItemValue,PatientInfo,ConditionClass,SpecialConfig)
							if (IdentifyFlag=1)
							{
								s CurMeetConditionNum=CurMeetConditionNum+1
								s WordsRowId=$o(^CT.WDT.CDSS.IdentifyWordsI("DescTypeIndex",ConditionItemValue,ConditionClass,0))
								s:IWordStr'="" IWordStr=IWordStr_"[A]"_WordsRowId
								s:IWordStr="" IWordStr=WordsRowId
							}
						}
						else
						{
							//s PInfoItem=##class(web.CDSS.IdentifyWords.GetPatientInfo).DealDataByPatientEnumI(PatientInfo,ConditionClass) //取患者模型的数据，并且预处理 后期优化2021-08-02 By Dingyanan
							s PInfoItem =$g(^TempPInfoItemData(JobNum,PatientInfo,ConditionClass))
							if (PInfoItem="")  //所需类型信息在患者模型中不存在时，继续下一条规则条件的判断
							{
								s SatisfyFlag=0
								continue 
							}
							s PInfoItem=[].%FromJSON(PInfoItem)
							
							s ConditionSatisfyFlag="" //条件是否满足
							for i=0:1:(PInfoItem.%Size()-1)  //遍历条件判断是否满足
							{
								
								//w """"_(PInfoItem.%Get(i)).%Get(ConditionItem)_""""ConditionItemCalculate""""ConditionItemValue"""",!
								if @(""""_$tr((PInfoItem.%Get(i)).%Get(ConditionItem),"""","'")_""""_ConditionItemCalculate_""""_$tr(ConditionItemValue,"""","'")_"""") //满足条件
								{
									continue:((PInfoItem.%Get(i)).%Get(ConditionItem)="")||(ConditionItemValue="")  //不存在患者信息 默认不满足
									s ConditionSatisfyFlag=1
								}
								else //不满足条件
								{
									if (ConditionItem="Age")  //年龄的条件一个不满足就判定不满足
									{
										s SatisfyFlag=0
									}
									
								}
							}
							s:ConditionSatisfyFlag=1 CurMeetConditionNum=CurMeetConditionNum+1
						}
						
					}
					
					if ((CurMeetConditionNum<MeetConditionNum)&(NodeTypeDesc'["否定条件"))||((CurMeetConditionNum>=MeetConditionNum)&(NodeTypeDesc["否定条件"))  //当前节点没有满足条件 否定条件-识别词、否定条件-诊断
					{
						s SatisfyFlag=0
					}
					else
					{
						s SatisfyFlag=1
					}
					
					
				}
			}
			
			
			
			if (SatisfyFlag=1)
			{
				s:ChartNumStr'="" ChartNumStr=ChartNumStr_"^"_FlowChartNum_"&&"_RuleTypeDR_"&&"_IWordStr
				s:ChartNumStr="" ChartNumStr=FlowChartNum_"&&"_RuleTypeDR_"&&"_IWordStr
			}
			
		}
	}

	if (PatientDR'="")&&(VisitID'="")&&$d(^WDT.CDSS.PatTriggerRuleI("PatVisRuleDRIndex",PatientDR,VisitID,VisitType,RuleDR))
	{
		s PatRuleRowId=0
		for
		{                                                
			s PatRuleRowId=$O(^WDT.CDSS.PatTriggerRuleI("PatVisRuleDRIndex",PatientDR,VisitID,VisitType,RuleDR,PatRuleRowId)) q:PatRuleRowId=""
			s delsc=##class(WDT.CDSS.PatTriggerRule).%DeleteId(PatRuleRowId)
		}
	}
	elseif (IDNO'="")&&$d(^WDT.CDSS.PatTriggerRuleI("IDNORuleIndex",IDNO,RuleDR))
	{
		s PatRuleRowId=0
		for
		{
			s PatRuleRowId=$O(^WDT.CDSS.PatTriggerRuleI("IDNORuleIndex",IDNO,RuleDR,PatRuleRowId)) q:PatRuleRowId=""
			s delsc=##class(WDT.CDSS.PatTriggerRule).%DeleteId(PatRuleRowId)
		}
	}
	
	if (ChartNumStr'="")
	{
		s LenRule=$length(ChartNumStr,"^")
		
		for irule=1:1:LenRule
		{
			s str=$p(ChartNumStr,"^",irule)
			s num=$p(str,"&&",1)
			s RuleTypeDR=$p(str,"&&",2)
			s IWordStr=$p(str,"&&",3)
			
			if ((PatientDR'="")&&(VisitID'="")&&('$d(^WDT.CDSS.PatTriggerRuleI("PatVisTypeRuleTypeDRFlowIndex",PatientDR,VisitID,VisitType,RuleDR,RuleTypeDR,num)))&((IDNO'="")&&('$d(^WDT.CDSS.PatTriggerRuleI("IDNORuleTypeFlowIndex",IDNO,RuleDR,RuleTypeDR,num)))))
			{
				
				s:RuleTypeDR=-100000000000000 RuleTypeDR=""
				Ts
				s obj=##class(WDT.CDSS.PatTriggerRule).%New()
				s obj.IDNO=IDNO
				s obj.PatientDR=PatientDR
				s obj.VisitID=VisitID
				s obj.VisitType=VisitType
				d obj.RuleDRSetObjectId(RuleDR)
				s obj.FlowChartNum=num
				d obj.RuleTypeDRSetObjectId(RuleTypeDR)
				s obj.PRuleFlowIWordStr=IWordStr
				s sc=obj.%Save()
                d obj.%Close()
              	
                If $$$ISOK(sc)
	            {
	                Tc
	                s id = obj.%Id()
	                //保存日志
					//d ##class(web.CDSS.Config.DataChangeLog).SaveLog("PatTriggerRule","WDT.CDSS.PatTriggerRule","患者当前触发的规则",id,obj.IDNO,"A",obj)
				}
	            else
	            {
	                Trollback
	                s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	                //s logid=##class(web.DHCBL.MKB.SysErrorLog).SaveLog("患者当前触发的规则","web.CDSS.MedicalRule.DiagAndTreatR","SaveData",obj)
	       	    	//s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	            }
			}
		}
	}
	q ""
}

ClassMethod DealMedicalRule3(RuleDR As %String, PatientInfo As %String) As %String
{
	s ChartNumStr=""
	s RuleTypeDR="" //图类型
	for
	{
		s RuleTypeDR=$o(^CT.WDT.CDSS.RuleNodeI("TypeChartIndex",RuleDR,RuleTypeDR)) q:(RuleTypeDR="") //图类型  治疗方案和预警为空
		
		s FlowChartNum="" //顺序号
		for
		{
			s FlowChartNum=$o(^CT.WDT.CDSS.RuleNodeI("TypeChartIndex",RuleDR,RuleTypeDR,FlowChartNum)) q:(FlowChartNum="") //流程图顺序号
			s IWordStr="" //触发规则的识别词id串
			s SatisfyFlag="" //满足规则的标志
			s NodeRowId=""
			for
			{
				s NodeRowId=$o(^CT.WDT.CDSS.RuleNodeI("TypeChartIndex",RuleDR,RuleTypeDR,FlowChartNum,NodeRowId)) q:(NodeRowId="")||(SatisfyFlag=0) //节点
				s NodeType=$lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowId)),5)	 //节点类型
				s NodeTypeDesc=""
				s:NodeType'="" NodeTypeDesc=$lg($g(^CT.WDT.CDSS.NodeTypeD(NodeType)),3) //节点类型描述
				
				if (NodeTypeDesc="基本信息-年龄")||(NodeTypeDesc="基本信息-性别")||(NodeTypeDesc="主要条件-诊断")||(NodeTypeDesc="主要条件-识别词")||(NodeTypeDesc="否定条件-识别词")||(NodeTypeDesc="否定条件-诊断")
				{
					s MeetConditionNum=$lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowId)),6)  //该节点下需要满足的条件个数
					S:MeetConditionNum="" MeetConditionNum=1
					s CurMeetConditionNum=0
					s ConditionRowId=0
					for
					{
						s ConditionRowId = $o(^CT.WDT.CDSS.RuleConditionI("NodeDRIndex",NodeRowId,ConditionRowId)) q:(ConditionRowId="")||(CurMeetConditionNum=MeetConditionNum)||(SatisfyFlag=0)  //触发条件类节点内容
						s ConditionClass  = $lg($g(^CT.WDT.CDSS.RuleConditionD(ConditionRowId)),3) //条件数据类型（性别、年龄、体质、诊断、主诉、现病史、既往史、个人史、婚育史、体征、检查、检验、药物、手术等）
						s:ConditionClass="" ConditionClass=$CASE(NodeTypeDesc,"基本信息-年龄":"年龄(天)","基本信息-性别":"性别","主要条件-诊断":"主要条件-诊断","否定条件-诊断":"主要条件-诊断",:"识别条件") //注意识别词类型也转化成诊断
						s ConditionItem  = $lg($g(^CT.WDT.CDSS.RuleConditionD(ConditionRowId)),4) //规则条件对应字段名称
						s:ConditionClass="诊断" ConditionItem="DiagnosisName"
						s ConditionItemCalculate  = $lg($g(^CT.WDT.CDSS.RuleConditionD(ConditionRowId)),5) //运算符
						s ConditionItemValue  = $lg($g(^CT.WDT.CDSS.RuleConditionD(ConditionRowId)),6)  //规则条件值
						s ConditionItemValUnit  = $lg($g(^CT.WDT.CDSS.RuleConditionD(ConditionRowId)),7) //规则条件值单位
						s ConditionItemValUnitN=""
						s:ConditionItemValUnit'="" ConditionItemValUnitN= $lg($g(^CT.WDT.CDSS.UnitDictD(ConditionItemValUnit)),3)
						if (ConditionItem="Age")
						{
							//s ConditionItemValue  = $lg($g(^CT.WDT.CDSS.RuleConditionD(ConditionRowId)),9)  //备注 年龄(天)
							//很多备注没有按照要求保存
							s ConditionItemValue=##class(web.CDSS.CMKB.FunLib).TransforDateFormat(ConditionItemValue,ConditionItemValUnitN)	
							s ConditionClass="年龄(天)"
						}
						
						if (ConditionClass="识别条件")||(ConditionClass="主要条件-诊断")
						{
							s IdentifyFlag=..DealIdentifyWords(ConditionItemValue,PatientInfo,ConditionClass)
							if (IdentifyFlag=1)
							{
								s CurMeetConditionNum=CurMeetConditionNum+1
								s WordsRowId=$o(^CT.WDT.CDSS.IdentifyWordsI("DescTypeIndex",ConditionItemValue,ConditionClass,0))
								s:IWordStr'="" IWordStr=IWordStr_"[A]"_WordsRowId
								s:IWordStr="" IWordStr=WordsRowId
							}
						}
						else
						{
							//s PInfoItem=##class(web.CDSS.IdentifyWords.GetPatientInfo).DealDataByPatientEnumI(PatientInfo,ConditionClass) //取患者模型的数据，并且预处理 后期优化2021-08-02 By Dingyanan
							s PInfoItem =$g(^TempPInfoItemData($j,PatientInfo,ConditionClass))
							if (PInfoItem="")  //所需类型信息在患者模型中不存在时，继续下一条规则条件的判断
							{
								s SatisfyFlag=0
								continue 
							}
							s PInfoItem=[].%FromJSON(PInfoItem)
							
							s ConditionSatisfyFlag="" //条件是否满足
							for i=0:1:(PInfoItem.%Size()-1)  //遍历条件判断是否满足
							{
								
								//w """"_(PInfoItem.%Get(i)).%Get(ConditionItem)_""""ConditionItemCalculate""""ConditionItemValue"""",!
								if @(""""_$tr((PInfoItem.%Get(i)).%Get(ConditionItem),"""","'")_""""_ConditionItemCalculate_""""_$tr(ConditionItemValue,"""","'")_"""") //满足条件
								{
									continue:((PInfoItem.%Get(i)).%Get(ConditionItem)="")||(ConditionItemValue="")  //不存在患者信息 默认不满足
									s ConditionSatisfyFlag=1
								}
								else //不满足条件
								{
									if (ConditionItem="Age")  //年龄的条件一个不满足就判定不满足
									{
										s SatisfyFlag=0
									}
									
								}
							}
							s:ConditionSatisfyFlag=1 CurMeetConditionNum=CurMeetConditionNum+1
						}
						
					}
					
					if ((CurMeetConditionNum<MeetConditionNum)&(NodeTypeDesc'["否定条件"))||((CurMeetConditionNum>=MeetConditionNum)&(NodeTypeDesc["否定条件"))  //当前节点没有满足条件 否定条件-识别词、否定条件-诊断
					{
						s SatisfyFlag=0
					}
					else
					{
						s SatisfyFlag=1
					}
					
				}
			}
			
			
			
			if (SatisfyFlag=1)
			{
				s:ChartNumStr'="" ChartNumStr=ChartNumStr_"^"_FlowChartNum_"&&"_RuleTypeDR_"&&"_IWordStr
				s:ChartNumStr="" ChartNumStr=FlowChartNum_"&&"_RuleTypeDR_"&&"_IWordStr
			}
			
		}
	}
	q ChartNumStr
}

/// Creator:李得原
/// CreatDate:2022-08-15
/// Description:把只有否定条件 通过条件的规则加入规则列表
/// Table: 
/// Input: 
/// Return: 
/// Others:w ##class(web.CDSS.MedicalRule.GetPatientRule).GetSingleNodeType(.RuleArray,"sds",10460)
ClassMethod GetSingleNodeType(ByRef RuleArray, ProVision As %String, RuleId As %String)
{
	q:ProVision="" ""
	q:RuleId="" ""
	if '$d(^OnlyNotCondition(ProVision))
	{
		q ""
	}
	if $d(^OnlyNotCondition(ProVision,RuleId))
	{
		s RuleType=""
		for
		{
			s RuleType=$o(^OnlyNotCondition(ProVision,RuleId,RuleType))
			q:RuleType=""
			s RuleFlow=0
			for
			{
				s RuleFlow=$o(^OnlyNotCondition(ProVision,RuleId,RuleType,RuleFlow))
				q:RuleFlow=""
				s RuleArray(RuleId,RuleType,RuleFlow)=""
			}
		}
	}
	q ""
}

/// Creator:李得原
/// CreatDate:2022-12-05
/// Description:评估表对应规则是否成立
/// Table: 
/// Input: 
/// Return: 
/// Others:w ##class(web.CDSS.MedicalRule.GetPatientRule).DealScaleRule(58160,"87^0000000083^1^住院^18881^王健^ZYZY003^内分泌科^1")
ClassMethod DealScaleRule(RuleRowId As %String, PatientInfo As %String) As %String
{
	s RuleTypeDR= "-100000000000000"
	d ##class(web.CDSS.IdentifyWords.GetPatientIW).CreatePatientInfoData(PatientInfo)
	s FlowChartNum=""
	for
	{
		s FlowChartNum = $o(^CT.WDT.CDSS.RuleNodeI("RuleDRTypeIndex",RuleRowId,FlowChartNum))
		q:FlowChartNum=""
		s flag = ..DealMedicalRule(RuleRowId, RuleTypeDR, FlowChartNum, PatientInfo)
		if flag'=""
		{
			k ^TempPInfoItemData($j,PatientInfo)
			return "True"
		}
	}
	k ^TempPInfoItemData($j,PatientInfo)
	return "False"
}

/// Creator:李得原
/// CreatDate:2023-02-11
/// Description:判断该流程图中是否只有否定条件
/// Table: 
/// Input: 
/// Return: 
/// Others:w ##class(web.CDSS.MedicalRule.GetPatientRule).OnlyNotCondition(10460,-100000000000000,1)
ClassMethod OnlyNotCondition(RuleRowid As %String, RuleType As %String, RuleFlow As %String) As %String
{
	s NoFlag=0,YesFlag=0
	s NodeRowid=0
	for
	{
		s NodeRowid=$o(^CT.WDT.CDSS.RuleNodeI("TypeChartIndex",RuleRowid,RuleType,RuleFlow,NodeRowid))
		q:NodeRowid=""
		s NodeTypeRowid = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowid)),5)
		s NodeTypeDesc=$lg($g(^CT.WDT.CDSS.NodeTypeD(NodeTypeRowid)),3) //节点类型描述
		continue:(NodeTypeDesc="开始")||(NodeTypeDesc="结束")||(NodeTypeDesc["推荐")||(NodeTypeDesc["合理")||(NodeTypeDesc["出院")

		if (NodeTypeDesc["否定")
		{
			s NoFlag=1
		}
		if (NodeTypeDesc'["否定")
		{
			s YesFlag=1
		}
	}
	if ($g(NoFlag,0)=1)&($g(YesFlag,0)=0)
	{
		q "1"
	}
	q "0"
}

/// Creator:李得原
/// CreatDate:2023-02-11
/// Description:查询出所有只有否定节点的规则
/// Table: CT.WDT.CDSS.RuleDict:诊疗规则表 CT.WDT.CDSS.RuleNode:诊疗规则节点表 CT.WDT.CDSS.RuleCondition:诊疗规则内容表(有多个)
/// Input: PatientInfo : 患者信息（医生站所传json串）
/// Return:                                                               
/// Others:w ##class(web.CDSS.MedicalRule.GetPatientRule).GetAllOnlyNotRule()
ClassMethod GetAllOnlyNotRule()
{
	k ^OnlyNotCondition
	s RuleRowid=0
	for
	{
		s RuleRowid=$o(^CT.WDT.CDSS.RuleDictD(RuleRowid))
		q:RuleRowid=""
		
		s RuleProvision=$lg($g(^CT.WDT.CDSS.RuleDictD(RuleRowid)),14)
		s RuleDictType=$lg($g(^CT.WDT.CDSS.RuleDictD(RuleRowid)),6)
		if RuleDictType'="-100000000000000"
		{
			s RuleTypeDesc= $lg($g(^CT.WDT.CDSS.ChartTypeD(RuleDictType)),3)
			continue:RuleTypeDesc["勾选"
		}
		s RuleType=""
		for
		{
			s RuleType=$o(^CT.WDT.CDSS.RuleNodeI("TypeChartIndex",RuleRowid,RuleType))
			q:RuleType=""

			s RuleFlow=0
			for
			{
				s RuleFlow=$o(^CT.WDT.CDSS.RuleNodeI("TypeChartIndex",RuleRowid,RuleType,RuleFlow))
				q:RuleFlow=""
				
				s flag=..OnlyNotCondition(RuleRowid,RuleType,RuleFlow)
				if flag=1
				{
					s ^OnlyNotCondition(RuleProvision,RuleRowid,RuleType,RuleFlow)=""
				}
			}
		}
	}
	q ""
}

}
