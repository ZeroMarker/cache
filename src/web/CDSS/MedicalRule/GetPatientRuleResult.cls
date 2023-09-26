/// Creator:丁亚男
/// CreatDate:2021-08-20
/// Description:获取患者符合条件的诊疗规则结果
Class web.CDSS.MedicalRule.GetPatientRuleResult Extends %RegisteredObject
{

/// Creator:丁亚男
/// CreatDate:2021-09-29
/// Description:根据患者当前触发的规则，获取检验检查保存到患者推荐信息表
/// Table: WDT.CDSS.PatTriggerRule:患者当前触发的规则 CT.WDT.CDSS.RuleResult:诊疗节点内容表  CT.WDT.CDSS.RuleDetail:治疗方案明细表（推荐治疗方案-药品、推荐治疗方案-手术）
/// Input: PatientInfo : 患者信息（医生站所传json串）
/// Return: 
/// Others:w ##class(web.CDSS.MedicalRule.GetPatientRuleResult).SaveSatisfyRuleResult("DM000816^DM000816^1^住院^48^李得原^1^信息科^1")
/// w ##class(web.CDSS.MedicalRule.GetPatientRuleResult).SaveSatisfyRuleResult("DM000824^DM000824^1^住院^48^李得原^1^信息科^1^脑梗死")
ClassMethod SaveSatisfyRuleResult(PatientInfo As %String, ProVision As %String = "") As %String
{
	s IDNO=$p(PatientInfo,"^",1)
	s PatientDR=$p(PatientInfo,"^",2)
	s VisitID=$p(PatientInfo,"^",3)
	s VisitType=$p(PatientInfo,"^",4)
	s Config=$p(PatientInfo,"^",9)
	s Type=$p(PatientInfo,"^",10)
	if (Config="") s Config=1	//是否启用流水号（急诊号、门诊号、住院号）为患者就诊唯一标识（0为是，1为否），默认为1
	
	if $l(PatientInfo,"^")=10
	{
		s PatientIn=$p(PatientInfo,"^",1,*-1)
	}
	else
	{
		s PatientIn=PatientInfo
	}
	
	if '$d(^TempPInfoItemData($j,PatientIn))
	{

		d ##class(web.CDSS.IdentifyWords.GetPatientIW).CreatePatientInfoData(PatientIn)
	}
	s RuleIDArray=""  //符合索引条件的规则
	if ((Config=1)||(Config="Y"))&(PatientDR'="")&(VisitID'="") // 单个患者单次就诊 根据病人标识和就诊次数编号取数据
	{
		if ($d(^WDT.CDSS.PatTriggerRuleI("PatVisTypeIndex",PatientDR,VisitID,VisitType)))
		{
			s TriggerRuleRowId=0
			for
			{
				s TriggerRuleRowId =$o(^WDT.CDSS.PatTriggerRuleI("PatVisTypeIndex",PatientDR,VisitID,VisitType,TriggerRuleRowId))  q:TriggerRuleRowId="" 
				s RuleDR=$lg($g(^WDT.CDSS.PatTriggerRuleD(TriggerRuleRowId)),6) 
				s FlowChartNum=$lg($g(^WDT.CDSS.PatTriggerRuleD(TriggerRuleRowId)),7)
				s RuleTypeDR=$lg($g(^WDT.CDSS.PatTriggerRuleD(TriggerRuleRowId)),8)
				s PRuleFlowIWordStr=$lg($g(^WDT.CDSS.PatTriggerRuleD(TriggerRuleRowId)),10)
				s:RuleTypeDR="" RuleTypeDR=-100000000000000
				s RuleIDArray(RuleDR,RuleTypeDR,FlowChartNum)=PRuleFlowIWordStr
			}
		}
		
	} 
	elseif (IDNO'="")  //患者主索引
	{
		if ($d(^WDT.CDSS.PatTriggerRuleI("IDNOIndex",IDNO)))
		{
			s TriggerRuleRowId=0
			for
			{
				s TriggerRuleRowId =$o(^WDT.CDSS.PatTriggerRuleI("IDNOIndex",IDNO,TriggerRuleRowId))  q:TriggerRuleRowId="" 
				s RuleDR=$lg($g(^WDT.CDSS.PatTriggerRuleD(TriggerRuleRowId)),6) 
				s FlowChartNum=$lg($g(^WDT.CDSS.PatTriggerRuleD(TriggerRuleRowId)),7) 
				s RuleTypeDR=$lg($g(^WDT.CDSS.PatTriggerRuleD(TriggerRuleRowId)),8) 
				s PRuleFlowIWordStr=$lg($g(^WDT.CDSS.PatTriggerRuleD(TriggerRuleRowId)),10) 
				
				s:RuleTypeDR="" RuleTypeDR=-100000000000000 
				s RuleIDArray(RuleDR,RuleTypeDR,FlowChartNum)=PRuleFlowIWordStr
			}
		}
		
	}
	;s RuleIDArray(RuleDR,RuleTypeDR,FlowChartNum)=PRuleFlowIWordStr
	;s RuleIDArray(11235,-100000000000000,1)=""
	
	
	s ResultArray=[] //汇总推荐信息
	//确诊诊断 鉴别诊断 推荐相关文献 推荐检验检查 推荐护理措施	推荐评估量表	推荐治疗方案	疾病预警	检验检查预警	手术预警	护理预警	过敏史预警	输血预警	手术并发症   药品预警	院方预警阻断	出院指导
	s DiagArray=[],RDiagArray=[],DiffDiagArray=[],DocArray=[],LabExamArray=[],NursArray=[],AssessArray=[],TreatArray=[],DiseWArray=[],LabExamWArray=[],OperaWArray=[],NursWArray=[],AllergyWArray=[],BloodWArray=[],OperCompArray=[],DrugWArray=[],HospWarnStopArray=[],DischargeGArray=[],MedCalulateArray=[],HighRiskWarnArray=[],EmrRecordRationArray=[],Temp1MedCalulateArray=[],Temp1AssessArray=[],Temp2MedCalulateArray=[],Temp2AssessArray=[]
	//判断是否存在临床指征评估表
	s DiseaseFlag=""
	if $l(PatientInfo,"^")=10
	{
		s DiseaseFlag=$p(PatientInfo,"^",*)
		s PatientInfo=$replace(PatientInfo,"^"_DiseaseFlag,"")
	}
	s ClinicValue=..AccessClinicCheck(PatientInfo)
	s MainDiagDesc = "" 
	s DiagRuleArray=""
	s IWData=""
	if (ProVision="")||(ProVision="CDSS")||(ProVision="cdss")
	{
		s MainDiagDesc=..GetMainDiag(PatientDR,VisitID,VisitType,IDNO,DiseaseFlag,.DiagRuleArray,.IWData)
	}
	
	s AssessRemark=""
	// 取符合条件的数据
	s RuleRowId=""
	for
	{
		s RuleRowId=$o(RuleIDArray(RuleRowId)) q:RuleRowId=""
		s RuleDesc=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowId)),3)  //规则名称
		s RuleVision = $LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowId)),14)  //录入来源

		//规则类型
		s RuleTypeDR1=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowId)),6)
		s RuleType1=""
		s:RuleTypeDR1'="" RuleType1=$LISTGET($G(^CT.WDT.CDSS.ChartTypeD(RuleTypeDR1)),3)
		s RuleTypeDR=""
		for
		{
			s RuleTypeDR=$o(RuleIDArray(RuleRowId,RuleTypeDR)) q:RuleTypeDR=""
			
			s FChartNum=""
			for
			{
				s FChartNum=$o(RuleIDArray(RuleRowId,RuleTypeDR,FChartNum)) q:FChartNum=""
				s PRuleFlowIWordStr=RuleIDArray(RuleRowId,RuleTypeDR,FChartNum)
				//单独获取该流程图下治疗方案的子节点内容
				s childArray=[]
				
				// 类型为1且RuleTypeDR为空是辅助诊疗规则下治疗方案 
				if (RuleTypeDR1="1")&(RuleTypeDR=-100000000000000)
				{
					s RealRuleType=$o(^CT.WDT.CDSS.ChartTypeI("DescIndex"," 推荐治疗方案",0))
					if ($d(^CT.WDT.CDSS.RuleNodeI("TypeChartIndex",RuleRowId,RuleTypeDR,FChartNum)))
					{
						s NodeRowId=0
						for
						{ 
							s NodeRowId=$o(^CT.WDT.CDSS.RuleNodeI("TypeChartIndex",RuleRowId,RuleTypeDR,FChartNum,NodeRowId)) q:NodeRowId=""
							s NodeType=$lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowId)),5)	 //节点类型
							s NodeTypeDesc=""
							s:NodeType'="" NodeTypeDesc=$lg($g(^CT.WDT.CDSS.NodeTypeD(NodeType)),3) //节点类型描述
							if (ProVision="")||(ProVision="CDSS")||(ProVision="cdss")
							{
								continue:'$d(DiagRuleArray(1,RuleRowId,RealRuleType,FChartNum))
							}
							continue:(NodeTypeDesc'="推荐治疗方案-药品")&(NodeTypeDesc'="推荐治疗方案-手术")&(NodeTypeDesc'="推荐治疗方案-治法")&(NodeTypeDesc'="推荐治疗方案-处置")
							s TCMTreatFlag=0
							s DetailRowId = 0
							for
							{
								s DetailRowId = $o(^CT.WDT.CDSS.RuleDetailI("NodeDRIndex",NodeRowId,DetailRowId)) q:DetailRowId=""
								s Sequence  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId)),3)
								s DrugDR  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId)),4)
								s DrugUse  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId)),5)
								s DosageMIN  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId)),6)
								s DosageMINUnit  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId)),7)
								s DosageMINUnitName=""
								s:DosageMINUnit'="" DosageMINUnitName=$lg($g(^CT.WDT.CDSS.UnitDictD(DosageMINUnit)),3)
								
								s DosageMAX  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId)),8)
								s DosageMAXUnit  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId)),9)
								s DosageMAXUnitName=""
								s:DosageMAXUnit'="" DosageMAXUnitName=$lg($g(^CT.WDT.CDSS.UnitDictD(DosageMAXUnit)),3)
								
								s Frequency  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId)),10)
								s FrequencyName=""
								s:Frequency'="" FrequencyName=$lg($g(^CT.WDT.CDSS.FrequencyDictD(Frequency)),3)
								s Remarks  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId)),11)
								
								s TreatSource = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId)),13)
								s RuleBasisDR = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId)),14)
								s SourceFlag=0
								if (TreatSource'="")||(RuleBasisDR'="")
								{
									s SourceFlag=1
								}
								s DrugDRName="",DrugUseName=""
								
								if (NodeTypeDesc="推荐治疗方案-药品") 
								{
									s DrugDRName=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugDR)),4)
									s:DrugUse'="" DrugUseName=$lg($g(^CT.WDT.CDSS.UsageDictD(DrugUse)),3)
									
									//s ProjectDataName =  ##class(web.CDSS.IMP.ContrastDict).GetProjectDataName(DrugDRName,"药品","1")
									//s ProjectCode =$p(ProjectDataName,"&%",1)
									//s ProjectName=$p(ProjectDataName,"&%",2)
									
									s ProjectDataJson=..GetProjectDataName(DrugDRName,"药品",DrugDRName)
									s ProjectCode =ProjectDataJson.%Get("MatchCode")
									s ProjectName=ProjectDataJson.%Get("ProjectName")
									
									s TmpAssC={}
									d TmpAssC.%Set("ItemID",DrugDR)
									d TmpAssC.%Set("TreatItemType","药品")
									d TmpAssC.%Set("TreatItemName",DrugDRName)
									d TmpAssC.%Set("FrequencyName",FrequencyName)
									d TmpAssC.%Set("ProjectName",ProjectName)
									d TmpAssC.%Set("MatchCode",ProjectCode)
									d TmpAssC.%Set("SourceFlag",SourceFlag)
									d childArray.%Push(TmpAssC)
								
								}
								elseif(NodeTypeDesc="推荐治疗方案-手术") 
								{
									s DrugDRName=$lg($g(^CT.WDT.CDSS.OperationDictD(DrugDR)),4)
									s:DrugUse'="" DrugUseName=$lg($g(^CT.WDT.CDSS.UsageDictD(DrugUse)),3)
									
									//s ProjectDataName =  ##class(web.CDSS.IMP.ContrastDict).GetProjectDataName(DrugUseName,"手术","1")
									//s ProjectCode =$p(ProjectDataName,"&%",1)
									//s ProjectName=$p(ProjectDataName,"&%",2)
									s ProjectDataJson=..GetProjectDataName(DrugUseName,"手术",DrugUseName)
									s ProjectCode =ProjectDataJson.%Get("MatchCode")
									s ProjectName=ProjectDataJson.%Get("ProjectName")
									s TmpAssC={}
									d TmpAssC.%Set("ItemID",DrugDR)
									d TmpAssC.%Set("TreatItemType","手术")
									d TmpAssC.%Set("TreatItemName",DrugDRName)
									d TmpAssC.%Set("ProjectName",ProjectName)
									d TmpAssC.%Set("MatchCode",ProjectCode)
									d TmpAssC.%Set("SourceFlag",SourceFlag)
									d childArray.%Push(TmpAssC)
								}
								elseif(NodeTypeDesc="推荐治疗方案-治法")   //治疗方案-治法-方剂-方剂组成
								{
									continue:TCMTreatFlag=1   //治法合并，只需循环一次
									s TreatmentName=""
									s TreatNameId=0
									for
									{
										s TreatNameId=$o(^CT.WDT.CDSS.RuleDetailI("NodeDRIndex",NodeRowId,TreatNameId))
										q:TreatNameId=""
										s DrugDR  = $lg($g(^CT.WDT.CDSS.RuleDetailD(TreatNameId)),4)
										s PartTreatmentName=$lg($g(^CT.WDT.CDSS.TCMTreatmentD(DrugDR)),3)
										s:TreatmentName'="" TreatmentName=TreatmentName_","_PartTreatmentName
										s:TreatmentName="" TreatmentName=PartTreatmentName
									}
									//s DetailRowId = $o(^CT.WDT.CDSS.RuleDetailI("NodeDRIndex",NodeRowId,DetailRowId)) q:DetailRowId=""
									
									s PMNodeRowId=0
									for
									{ 
										s PMNodeRowId=$o(^CT.WDT.CDSS.RuleNodeI("TypeChartIndex",RuleRowId,RuleTypeDR,FChartNum,PMNodeRowId)) q:PMNodeRowId=""
										s PMNodeType=$lg($g(^CT.WDT.CDSS.RuleNodeD(PMNodeRowId)),5)	 //节点类型
										s PMNodeTypeDesc=""
										s:PMNodeType'="" PMNodeTypeDesc=$lg($g(^CT.WDT.CDSS.NodeTypeD(PMNodeType)),3) //节点类型描述
										continue:(PMNodeTypeDesc'="推荐治疗方案-方剂")
										s childArray1=[]
										if ($d(^CT.WDT.CDSS.RuleDetailI("NodeLLevelIndex",PMNodeRowId))) //判断是否有方剂
										{
											s DetailRowId1 = 0
											for
											{
												s DetailRowId1 = $o(^CT.WDT.CDSS.RuleDetailI("NodeLLevelIndex",PMNodeRowId,-100000000000000,DetailRowId1)) q:DetailRowId1=""
												s Sequence1  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId1)),3)
												s DrugDR1  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId1)),4)
												s PrescriptionName=""
												s:DrugDR1'="" PrescriptionName=$lg($g(^CT.WDT.CDSS.TCMPrescriptionD(DrugDR1)),3)
												s Frequency1  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId1)),10)
												s FrequencyName1=""
												s:Frequency1'="" FrequencyName1=$lg($g(^CT.WDT.CDSS.FrequencyDictD(Frequency1)),3)
												s Remarks1  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId1)),11)
												s childArray2=[]
												if ($d(^CT.WDT.CDSS.RuleDetailI("LastLevelIndex",DetailRowId1))) //判断是否有方剂组成
												{
													s DetailRowId2 = 0
													for
													{
														s DetailRowId2 = $o(^CT.WDT.CDSS.RuleDetailI("LastLevelIndex",DetailRowId1,DetailRowId2)) q:DetailRowId2=""
														s Sequence2  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId2)),3)
														s DrugDR2  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId2)),4)
														s MedicineName=""
														s:DrugDR2'="" MedicineName=$lg($g(^CT.WDT.CDSS.TCMMedicineD(DrugDR2)),3)  //中药字典
														
														s DrugUse2  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId2)),5)
														s DecoctionName=""
														s:DrugUse2'="" DecoctionName=$lg($g(^CT.WDT.CDSS.TCMDecoctionD(DrugUse2)),3) //煎法
														
														s DosageMIN2  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId)),6)
														s DosageMINUnit2  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId)),7)
														s DosageMINUnitName2=""
														s:DosageMINUnit2'="" DosageMINUnitName2=$lg($g(^CT.WDT.CDSS.UnitDictD(DosageMINUnit2)),3)
														s Remarks2  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId2)),11)
														//s ProjectDataName =  ##class(web.CDSS.IMP.ContrastDict).GetProjectDataName(MedicineName,"中药","1")
														//s ProjectName=$p(ProjectDataName,"&%",2)
														//s MatchCode=$p(ProjectDataName,"&%",1)
														s ProjectDataJson=..GetProjectDataName(MedicineName,"中药",MedicineName)
														s MatchCode =ProjectDataJson.%Get("MatchCode")
														s ProjectName=ProjectDataJson.%Get("ProjectName")
														s TmpAssC={}
														d TmpAssC.%Set("TreatItemType","方剂组成")
														d TmpAssC.%Set("TreatItemName",MedicineName)
														d TmpAssC.%Set("ProjectName",ProjectName)
														d TmpAssC.%Set("MatchCode",MatchCode)
														d TmpAssC.%Set("Dosage",DosageMIN2)
														d TmpAssC.%Set("DosageUnit",DosageMINUnitName2)
														d TmpAssC.%Set("DecoctionName",DecoctionName)
														
														d childArray2.%Push(TmpAssC)
													}
												}
									
												s TmpAssC={}
												d TmpAssC.%Set("TreatItemType","方剂")
												d TmpAssC.%Set("TreatItemName",PrescriptionName)
												d TmpAssC.%Set("FrequencyName",FrequencyName1)
												d TmpAssC.%Set("ShowFlag","false")
												d:childArray2'=[] TmpAssC.%Set("children",childArray2)
												d childArray1.%Push(TmpAssC)

											}
										}
									}
									s TCMTreatFlag=1
									s TmpAssC={}
									d TmpAssC.%Set("ItemID",DrugDR)
									d TmpAssC.%Set("TreatItemType","治法")
									d TmpAssC.%Set("TreatItemName",TreatmentName)
									d TmpAssC.%Set("SourceFlag",SourceFlag)
									d:childArray1'=[] TmpAssC.%Set("children",childArray1)
									d childArray.%Push(TmpAssC)
								}
								elseif(NodeTypeDesc="推荐治疗方案-处置")   //治疗方案-处置(护理字典)-处置明细
								{
									s NursingName=""
									s NursingName=$lg($g(^CT.WDT.CDSS.NursingDictD(DrugDR)),4)  //护理名称
									continue:NursingName=""
									s LastLevel = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId)),12)
									continue:LastLevel'=""
									s childArray1=[]
									
									if ($d(^CT.WDT.CDSS.RuleDetailI("LastLevelIndex",DetailRowId))) //判断是否有处置明细
									{
										s DetailRowId1 = 0
										for
										{
											s DetailRowId1 = $o(^CT.WDT.CDSS.RuleDetailI("LastLevelIndex",DetailRowId,DetailRowId1)) q:DetailRowId1=""
											s Sequence1  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId1)),3)
											s DrugDR1  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId1)),4)
											s DrugUse1  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId)),5) //处置类型（腧穴、中药、药物）
											s DrugDRName1=""
											s ProjectDataName=""
											s ProjectName=""
											s MatchCode=[]
											if (DrugUse1'="")
											{
												if (DrugUse1="腧穴")
												{
													s DrugDRName1=$lg($g(^CT.WDT.CDSS.TCMAcupointsD(DrugDR1)),3)
												}
												elseif (DrugUse1="中药")
												{
													s DrugDRName1=$lg($g(^CT.WDT.CDSS.TCMMedicineD(DrugDR1)),3)
													//s ProjectDataName =  ##class(web.CDSS.IMP.ContrastDict).GetProjectDataName(DrugDRName1,"中药","1")
													s ProjectDataJson=..GetProjectDataName(DrugDRName1,"中药",DrugDRName1)
													s MatchCode =ProjectDataJson.%Get("MatchCode")
													s ProjectName=ProjectDataJson.%Get("ProjectName")
												}
												elseif (DrugUse1="药物")
												{
													s DrugDRName1=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugDR1)),4)
													//s ProjectDataName =  ##class(web.CDSS.IMP.ContrastDict).GetProjectDataName(DrugDRName1,"药品","1")
													s ProjectDataJson=..GetProjectDataName(DrugDRName1,"药品",DrugDRName1)
													s MatchCode =ProjectDataJson.%Get("MatchCode")
													s ProjectName=ProjectDataJson.%Get("ProjectName")
												}
												
											}

											s Remarks1  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId1)),11)
											s TmpAssC={}
											d TmpAssC.%Set("ProjectName",ProjectName)
											d TmpAssC.%Set("MatchCode",MatchCode)
											d TmpAssC.%Set("TreatItemType",DrugUse1)
											d TmpAssC.%Set("TreatItemName",DrugDRName1)
											d childArray1.%Push(TmpAssC)

										}
									}
									s ProjectDataNameJson =  ..GetProjectDataName(NursingName,"护理",NursingName)
									s ProjectName=ProjectDataNameJson.%Get("ProjectName")
									s MatchCode =ProjectDataNameJson.%Get("MatchCode")
									s TmpAssC={}
									d TmpAssC.%Set("ItemID",DrugDR)
									d TmpAssC.%Set("TreatItemType","处置")
									d TmpAssC.%Set("ProjectName",ProjectName)
									d TmpAssC.%Set("MatchCode",MatchCode)
									d TmpAssC.%Set("TreatItemName",NursingName)
									d TmpAssC.%Set("SourceFlag",SourceFlag)
									d:childArray1'=[] TmpAssC.%Set("children",childArray1)
									d childArray.%Push(TmpAssC)

								}
								//保存患者触发规则数据统计
								if PatientInfo'["TMPAPI"
								{
									d ##class(web.CDSS.MedicalRule.GetPatientRuleResult).SavePatTriggerStatic(PatientInfo,RuleRowId,FChartNum,RuleTypeDR1,DetailRowId,DrugDRName,"",NodeTypeDesc)	
								}
							}
						}
					}
				}					
								
									
				if ($d(^CT.WDT.CDSS.RuleNodeI("TypeChartIndex",RuleRowId,RuleTypeDR,FChartNum)))
				{
					s NodeRowId=0
					for
					{ 
						s NodeRowId=$o(^CT.WDT.CDSS.RuleNodeI("TypeChartIndex",RuleRowId,RuleTypeDR,FChartNum,NodeRowId)) q:NodeRowId=""
						s NodeType=$lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowId)),5)	 //节点类型
						s NodeTypeDesc=""
						s:NodeType'="" NodeTypeDesc=$lg($g(^CT.WDT.CDSS.NodeTypeD(NodeType)),3) //节点类型描述
				
						//取推荐信息
						if ($d(^CT.WDT.CDSS.RuleResultI("NodeDRIndex",NodeRowId)))
						{
							s ResultRowId = 0
							for
							{
								s ResultRowId = $o(^CT.WDT.CDSS.RuleResultI("NodeDRIndex",NodeRowId,ResultRowId)) q:ResultRowId=""
								s Sequence  = $lg($g(^CT.WDT.CDSS.RuleResultD(ResultRowId)),3)
								s RecommendType  = $lg($g(^CT.WDT.CDSS.RuleResultD(ResultRowId)),4)
								s RecommendResult  = $lg($g(^CT.WDT.CDSS.RuleResultD(ResultRowId)),5)
								s Remarks  = $lg($g(^CT.WDT.CDSS.RuleResultD(ResultRowId)),6)
								//s BaseTable  = $lg($g(^CT.WDT.CDSS.RuleResultD(ResultRowId)),7)
								//s:BaseTable="" BaseTable=0
								/*
								if (RecommendType="评估表")||(RecommendType="辅助计算")||(RecommendType="推荐确诊")
								{
									continue:'$d(DiagRuleArray(RuleRowId))
								}
								*/
								
								s TreatSource= $lg($g(^CT.WDT.CDSS.RuleResultD(ResultRowId)),8)
								s RuleBasisDR= $lg($g(^CT.WDT.CDSS.RuleResultD(ResultRowId)),10)
								s SourceFlag=0
								if (RuleBasisDR'="")
								{
									s SourceFlag=1
								}
								if (TreatSource'="")
								{
									s isExistDoc = ##class(web.DHCBL.BDP.BDPUploadFile).IsExistsFile("scripts\\bdp\\CDSS\\Doc\\"_TreatSource_".pdf")
									if isExistDoc
									{
										s SourceFlag=1
									}	
								}
								s RecommendResultDesc=""
								if (RecommendType="检验") 
								{
									s RealRuleType=$o(^CT.WDT.CDSS.ChartTypeI("DescIndex"," 推荐检验检查",0))
									if (ProVision="")||(ProVision="CDSS")||(ProVision="cdss")
									{
										continue:'$d(DiagRuleArray(1,RuleRowId,RealRuleType,FChartNum))
									}
									
									s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.LabInspectionDictD(RecommendResult)),4)
									//s ProjectDataName =  ##class(web.CDSS.IMP.ContrastDict).GetProjectDataName(RecommendResultDesc,"检验","1")
									s ProjectDataJson=..GetProjectDataName(RecommendResultDesc,"检验项目",RecommendResultDesc)
									s ProjectCode =ProjectDataJson.%Get("MatchCode")
									s ProjectName=ProjectDataJson.%Get("ProjectName")
									///s ProjectCode =$p(ProjectDataName,"&%",1)
									//s ProjectName=$p(ProjectDataName,"&%",2)
									s basedr=##class(web.CDSS.CMKB.TermBase).GetIdByDesc("检验")
									
									s TmpAss={}
									d TmpAss.%Set("ItemName",RecommendResultDesc)
									d TmpAss.%Set("ItemID",RecommendResult)
									d TmpAss.%Set("ItemType",basedr)
									d TmpAss.%Set("ProjectName",ProjectName)  
									d TmpAss.%Set("MatchCode",ProjectCode)
									d TmpAss.%Set("SourceFlag",SourceFlag)
									
									
									s Tmp={}
									d Tmp.%Set("CureId",ResultRowId)
									d Tmp.%Set("ItemDesc",Remarks)
									d Tmp.%Set("NodeId",NodeRowId_"|"_RecommendResult)
									d ..ProcessDuplicate(RuleVision,.LabExamArray,.TmpAss,Tmp)
								}
								elseif(RecommendType="检验医嘱")
								{
									s RealRuleType=$o(^CT.WDT.CDSS.ChartTypeI("DescIndex"," 推荐检验检查",0))
									if (ProVision="")||(ProVision="CDSS")||(ProVision="cdss")
									{
										continue:'$d(DiagRuleArray(1,RuleRowId,RealRuleType,FChartNum))
									}
									s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.LabOrdersDictD(RecommendResult)),3)
									//s ProjectDataName =  ##class(web.CDSS.IMP.ContrastDict).GetProjectDataName(RecommendResultDesc,"检验医嘱","1")
									//s ProjectCode =$p(ProjectDataName,"&%",1)
									//s ProjectName=$p(ProjectDataName,"&%",2)
									s ProjectDataJson=..GetProjectDataName(RecommendResultDesc,RecommendType,RecommendResultDesc)
									s ProjectCode =ProjectDataJson.%Get("MatchCode")
									s ProjectName=ProjectDataJson.%Get("ProjectName")
									s basedr=##class(web.CDSS.CMKB.TermBase).GetIdByDesc("检验")
									
									s TmpAss={}
									d TmpAss.%Set("ItemName",RecommendResultDesc)
									d TmpAss.%Set("ItemID",RecommendResult)
									
									d TmpAss.%Set("ItemType",basedr)
									d TmpAss.%Set("ProjectName",ProjectName)  
									d TmpAss.%Set("MatchCode",ProjectCode)
									d TmpAss.%Set("SourceFlag",SourceFlag)

									s Tmp={}
									d Tmp.%Set("CureId",ResultRowId)
									d Tmp.%Set("ItemDesc",Remarks)
									d Tmp.%Set("NodeId",NodeRowId_"|"_RecommendResult)
									d ..ProcessDuplicate(RuleVision,.LabExamArray,.TmpAss,Tmp)
								}
								elseif(RecommendType="检查")
								{
								
									s RealRuleType=$o(^CT.WDT.CDSS.ChartTypeI("DescIndex"," 推荐检验检查",0))
									if (ProVision="")||(ProVision="CDSS")||(ProVision="cdss")
									{
										continue:'$d(DiagRuleArray(1,RuleRowId,RealRuleType,FChartNum))
									}
									s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.ExamDictD(RecommendResult)),4)
									//s ProjectDataName =  ##class(web.CDSS.IMP.ContrastDict).GetProjectDataName(RecommendResultDesc,"检查","1")
									//s ProjectCode =$p(ProjectDataName,"&%",1)
									//s ProjectName=$p(ProjectDataName,"&%",2)
									s ProjectDataJson=..GetProjectDataName(RecommendResultDesc,RecommendType,RecommendResultDesc)
									s ProjectCode =ProjectDataJson.%Get("MatchCode")
									s ProjectName=ProjectDataJson.%Get("ProjectName")
									s basedr=##class(web.CDSS.CMKB.TermBase).GetIdByDesc("检查")
									
									s TmpAss={}
									d TmpAss.%Set("ItemName",RecommendResultDesc)
									d TmpAss.%Set("ItemID",RecommendResult)
									
									d TmpAss.%Set("ItemType",basedr)
									d TmpAss.%Set("ProjectName",ProjectName)  
									d TmpAss.%Set("MatchCode",ProjectCode)
									d TmpAss.%Set("SourceFlag",SourceFlag)
									
									s Tmp={}
									d Tmp.%Set("CureId",ResultRowId)
									d Tmp.%Set("ItemDesc",Remarks)
									d Tmp.%Set("NodeId",NodeRowId_"|"_RecommendResult)
									d ..ProcessDuplicate(RuleVision,.LabExamArray,.TmpAss,Tmp)
								}
								elseif(RecommendType="评估表")
								{
									s AccessOn = ##class(web.CDSS.Config.MKBConfig).GetConfigValue("AccessmentOn")
									continue:AccessOn=0
									s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.AssBaseD(RecommendResult)),3)
									continue:RecommendResultDesc=""
									s AssBIRowid=$o(^CT.WDT.CDSS.AssBasicInfoI("AssIndex",RecommendResult,0))
									if AssBIRowid'=""
									{
										s BaseTable=$lg($g(^CT.WDT.CDSS.AssBasicInfoD(AssBIRowid)),20)
										s ShowPriority=$lg($g(^CT.WDT.CDSS.AssBasicInfoD(AssBIRowid)),22)
									}
									else
									{
										s BaseTable = 1
										s ShowPriority="最低"
									}
									
									if BaseTable=1 
									{
										s BaseTable=0
									}
									else
									{
										s BaseTable=1
									}
									
									
									if NodeTypeDesc="推荐科室关联评估表"
									{
										if (ClinicValue=1)&(BaseTable=0)
										{
											continue
										}
									}
									/*
									s AssRuleZ=$o(^CT.WDT.CDSS.RuleDictI("DescIndex"," 临床指征评估表推荐",0))
									if $d(^WDT.CDSS.PatTriggerRuleI("PatVisRuleDRIndex",PatientDR,VisitID,VisitType,AssRuleZ))
									{
										if RuleDesc="科室关联评估表推荐"
										{
											continue:BaseTable=0   //剔除非基础评估表
										}
									}
									*/
									s RealRuleType=$o(^CT.WDT.CDSS.ChartTypeI("DescIndex"," 推荐评估表",0))
											
									s MKBABNote=$lg($g(^CT.WDT.CDSS.AssBaseD(RecommendResult)),4)
									s MKBABType=$lg($g(^CT.WDT.CDSS.AssBaseD(RecommendResult)),4)
									
									if MKBABType="医学计算器"
									{
										s CurrentItemType="百科"
									}
									else
									{
										s CurrentItemType="评估表"
									}
									s TmpCurrentAss={}
									d TmpCurrentAss.%Set("ShowPriority",ShowPriority)
									d TmpCurrentAss.%Set("ItemName",RecommendResultDesc)
									d TmpCurrentAss.%Set("ItemID",RecommendResult)
									d TmpCurrentAss.%Set("SourceFlag",SourceFlag)
									d TmpCurrentAss.%Set("ItemType",CurrentItemType)
									d TmpCurrentAss.%Set("CureId",ResultRowId)
									d TmpCurrentAss.%Set("ItemDesc",Remarks)
									d TmpCurrentAss.%Set("NodeId",NodeRowId_"|"_RecommendResult)
									d TmpCurrentAss.%Set("BaseTable",BaseTable)

									if $d(AssessRemark(CurrentItemType,RecommendResult))
									{
										continue
									}
									else
									{
										s AssessRemark(CurrentItemType,RecommendResult)=""
									}
									
									if $d(DiagRuleArray(1,RuleRowId,RealRuleType,FChartNum))
									{

										if MKBABType="医学计算器"
										{
											
											d Temp1MedCalulateArray.%Push(TmpCurrentAss)
										}
										else
										{
											d Temp1AssessArray.%Push(TmpCurrentAss)
										}
										continue
									}
									
									if $d(DiagRuleArray(2,RuleRowId,RealRuleType,FChartNum))
									{
										if MKBABType="医学计算器"
										{
											d Temp2MedCalulateArray.%Push(TmpCurrentAss)
										}
										else
										{
											d Temp2AssessArray.%Push(TmpCurrentAss)
										}
										continue
									}
									if (MKBABType="医学计算器")
									{
										s TmpAss={}
										d TmpAss.%Set("ItemName",RecommendResultDesc)
										d TmpAss.%Set("ItemID",RecommendResult)
										d TmpAss.%Set("SourceFlag",SourceFlag)
										d TmpAss.%Set("ItemType","百科")
										d TmpAss.%Set("ShowPriority",ShowPriority)

										s Tmp={}
										d Tmp.%Set("CureId",ResultRowId)
										d Tmp.%Set("ItemDesc",Remarks)
										d Tmp.%Set("NodeId",NodeRowId_"|"_RecommendResult)
										d Tmp.%Set("BaseTable",BaseTable)
										d ..ProcessDuplicate(RuleVision,.MedCalulateArray,.TmpAss,Tmp)
									}
									else
									{
										s TmpAss={}
										
										d TmpAss.%Set("ItemID",RecommendResult)
										d TmpAss.%Set("ItemName",RecommendResultDesc)
										d TmpAss.%Set("ItemType","评估表")
										
										s Tmp={}
										d Tmp.%Set("SourceFlag",SourceFlag)
										d Tmp.%Set("ShowPriority",ShowPriority)
										d Tmp.%Set("CureId",ResultRowId)
										d Tmp.%Set("ItemDesc",Remarks)
										d Tmp.%Set("NodeId",NodeRowId_"|"_RecommendResult)
										d Tmp.%Set("BaseTable",BaseTable)
										
										d ..ProcessDuplicate(RuleVision,.AssessArray,.TmpAss,Tmp)
										
									}
									
								}
								elseif(RecommendType="辅助计算")
								{
									s AccessOn = ##class(web.CDSS.Config.MKBConfig).GetConfigValue("AccessmentOn")
									continue:AccessOn=0
									s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.TermD(RecommendResult)),3)
									s AssBIRowid=$o(^CT.WDT.CDSS.AssBasicInfoI("AssIndex",RecommendResult,0))
									
									if AssBIRowid'=""
									{
										s BaseTable=$lg($g(^CT.WDT.CDSS.AssBasicInfoD(AssBIRowid)),20)
										s ShowPriority=$lg($g(^CT.WDT.CDSS.AssBasicInfoD(AssBIRowid)),22)
									}
									else
									{
										s BaseTable = 1
										s ShowPriority = "最低"
									}
									if BaseTable=1 
									{
										s BaseTable=0
									}
									else
									{
										s BaseTable=1
									}
									
									if NodeTypeDesc="推荐科室关联评估表"
									{
										if (ClinicValue=1)&(BaseTable=0)
										{
											continue
										}
									}
										
									s TmpCurrentAss={}
									d TmpCurrentAss.%Set("ItemName",RecommendResultDesc)
									d TmpCurrentAss.%Set("ItemID",RecommendResult)
									d TmpCurrentAss.%Set("SourceFlag",SourceFlag)
									d TmpCurrentAss.%Set("CureId",ResultRowId)
									d TmpCurrentAss.%Set("ItemDesc",Remarks)
									d TmpCurrentAss.%Set("ShowPriority",ShowPriority)
									d TmpCurrentAss.%Set("NodeId",NodeRowId_"|"_RecommendResult)
									d TmpCurrentAss.%Set("BaseTable",BaseTable)
									s RealRuleType=$o(^CT.WDT.CDSS.ChartTypeI("DescIndex"," 推荐评估表",0))
									
									if $d(DiagRuleArray(1,RuleRowId,RealRuleType,FChartNum))
									{
										d Temp1MedCalulateArray.%Push(TmpCurrentAss)
										continue
									}
									
									if $d(DiagRuleArray(2,RuleRowId,RealRuleType,FChartNum))
									{
										d Temp2MedCalulateArray.%Push(TmpCurrentAss)
										continue
									} 
									
									s TmpAss={}
									d TmpAss.%Set("ShowPriority",ShowPriority)
									d TmpAss.%Set("ItemName",RecommendResultDesc)
									d TmpAss.%Set("ItemID",RecommendResult)
									d TmpAss.%Set("SourceFlag",SourceFlag)

									s Tmp={}
									d Tmp.%Set("CureId",ResultRowId)
									d Tmp.%Set("ItemDesc",Remarks)
									d Tmp.%Set("NodeId",NodeRowId_"|"_RecommendResult)
									d Tmp.%Set("BaseTable",BaseTable)
									d ..ProcessDuplicate(RuleVision,.MedCalulateArray,.TmpAss,Tmp)
								}
								elseif(RecommendType="治疗方案")
								{
									
									s RealRuleType=$o(^CT.WDT.CDSS.ChartTypeI("DescIndex"," 推荐治疗方案",0))
									if (ProVision="")||(ProVision="CDSS")||(ProVision="cdss")
									{
										continue:'$d(DiagRuleArray(1,RuleRowId,RealRuleType,FChartNum))
									}
									s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.TreatDictD(RecommendResult)),3)
									
									//s Remarks=$lg($g(^CT.WDT.CDSS.TreatDictD(RecommendResult)),7)
									s TreatSource  = $lg($g(^CT.WDT.CDSS.RuleResultD(ResultRowId)),8)
								    s SourceImg  = $lg($g(^CT.WDT.CDSS.RuleResultD(ResultRowId)),9)
								    s RuleBasisDR = $lg($g(^CT.WDT.CDSS.RuleResultD(ResultRowId)),10)
								    s SourceFlag=0									
									if (RuleBasisDR'="")
									{
										s SourceFlag=1
									}
									if (TreatSource'="")
									{
										s isExistDoc = ##class(web.DHCBL.BDP.BDPUploadFile).IsExistsFile("scripts\\bdp\\CDSS\\Doc\\"_TreatSource_".pdf")
										if isExistDoc
										{
											s SourceFlag=1
										}	
									}
									s TmpAss={}
									d TmpAss.%Set("ItemName",RecommendResultDesc)
									d TmpAss.%Set("ItemID",RecommendResult)
									
									//判断是否是中医
									s:RuleVision["中医" tcmFlag=1
									s:RuleVision'["中医" tcmFlag=0
									if tcmFlag=1
									{
										d TmpAss.%Set("TCMFlag",1)
									}
									else
									{
										d TmpAss.%Set("TCMFlag",0)
									}

									s Tmp={}
									d Tmp.%Set("CureId",ResultRowId)
									d Tmp.%Set("ItemDesc",Remarks)
									d Tmp.%Set("NodeId",NodeRowId_"|"_RecommendResult)
									d Tmp.%Set("children",childArray)
									d Tmp.%Set("ResultID",ResultRowId)
									d Tmp.%Set("SourceFlag",SourceFlag)
									d ..ProcessDuplicate(RuleVision,.TreatArray,.TmpAss,Tmp)
								}
								//规则里面没有确诊诊断，只有推荐确诊
								elseif(RecommendType="确诊诊断")
								{
									s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.DiseaseDictD(RecommendResult)),3)
									
									//s ProjectDataName =  ##class(web.CDSS.IMP.ContrastDict).GetProjectDataName(RecommendResultDesc,"诊断","1")
									//s ProjectCode =$p(ProjectDataName,"&%",1)
									//s ProjectName=$p(ProjectDataName,"&%",2)
									s ProjectDataJson=..GetProjectDataName(RecommendResultDesc,RecommendType,RecommendResultDesc)
									s ProjectCode =ProjectDataJson.%Get("MatchCode")
									s ProjectName=ProjectDataJson.%Get("ProjectName")
									s TmpAss={}
									d TmpAss.%Set("ItemName",RecommendResultDesc)
									d TmpAss.%Set("ItemID",RecommendResult)
									
									d TmpAss.%Set("ProjectName",ProjectName)  
									d TmpAss.%Set("MatchCode",ProjectCode)
									d TmpAss.%Set("SourceFlag",SourceFlag)
									
									s Tmp={}
									d Tmp.%Set("CureId",ResultRowId)
									d Tmp.%Set("ItemDesc",Remarks)
									d Tmp.%Set("NodeId",NodeRowId_"|"_RecommendResult)
									d ..ProcessDuplicate(RuleVision,.RDiagArray,.TmpAss,Tmp)
									
								}
								elseif(RecommendType="鉴别诊断")
								{
									s RealRuleType=$o(^CT.WDT.CDSS.ChartTypeI("DescIndex"," 推荐鉴别诊断",0))
									if (ProVision="")||(ProVision="CDSS")||(ProVision="cdss")
									{
										continue:'$d(DiagRuleArray(1,RuleRowId,RealRuleType,FChartNum))
									}
									
									s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.DiseaseDictD(RecommendResult)),3)
									s TmpAss={}
									d TmpAss.%Set("ItemName",RecommendResultDesc)
									d TmpAss.%Set("ItemID",RecommendResult)
									d TmpAss.%Set("SourceFlag",SourceFlag)
									
									s Tmp={}
									d Tmp.%Set("CureId",ResultRowId)
									d Tmp.%Set("ItemDesc",Remarks)
									d Tmp.%Set("NodeId",NodeRowId_"|"_RecommendResult)
									d ..ProcessDuplicate(RuleVision,.DiffDiagArray,.TmpAss,Tmp)
								}
								elseif(RecommendType="护理处置")
								{
									s RealRuleType=$o(^CT.WDT.CDSS.ChartTypeI("DescIndex"," 推荐护理处置",0))
									if (ProVision="")||(ProVision="CDSS")||(ProVision="cdss")
									{
										continue:'$d(DiagRuleArray(1,RuleRowId,RealRuleType,FChartNum))
									}
									s RecommendResultDesc=$LISTGET($G(^CT.WDT.CDSS.NursingDictD(RecommendResult)),4)
									s TmpAss={}
									d TmpAss.%Set("ItemName",RecommendResultDesc)
									d TmpAss.%Set("ItemID",RecommendResult)
									d TmpAss.%Set("SourceFlag",SourceFlag)
									
									s Tmp={}
									d Tmp.%Set("CureId",ResultRowId)
									d Tmp.%Set("ItemDesc",Remarks)
									d Tmp.%Set("NodeId",NodeRowId_"|"_RecommendResult)
									d ..ProcessDuplicate(RuleVision,.NursArray,.TmpAss,Tmp)
								}
								/*elseif(RecommendType="文献")
								{
									s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.DocuManageD(RecommendResult)),3) //中文文献名称
									s TmpAss={}
									d TmpAss.%Set("ItemName",RecommendResultDesc)
									d TmpAss.%Set("ItemID",RecommendResult)
									d TmpAss.%Set("ItemDesc",Remarks)
									d DocArray.%Push(TmpAss)
								}*/	
								elseif(RecommendType="出院指导")
								{
									s RealRuleType=$o(^CT.WDT.CDSS.ChartTypeI("DescIndex"," 出院指导",0))
									if (ProVision="")||(ProVision="CDSS")||(ProVision="cdss")
									{
										continue:'$d(DiagRuleArray(1,RuleRowId,RealRuleType,FChartNum))
										//continue:'$d(DiagRuleArray(RuleRowId))
										continue:'$d(DiagRuleArray(1,RuleRowId,RealRuleType,FChartNum))
									}
									s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.DischargeGuideD(RecommendResult)),2)
									s TmpAss={}
									d TmpAss.%Set("ItemName",RecommendResultDesc)
									d TmpAss.%Set("ItemID",RecommendResult)
									d TmpAss.%Set("SourceFlag",SourceFlag)

									s Tmp={}
									s Remarks=##class(web.CDSS.CMKB.DGuideDetail).GetDetail(RecommendResult)
									d Tmp.%Set("CureId",ResultRowId)
									d Tmp.%Set("ItemDesc",Remarks)
									d Tmp.%Set("NodeId",NodeRowId_"|"_RecommendResult)
									d ..ProcessDuplicate(RuleVision,.DischargeGArray,.TmpAss,Tmp)
								}
								
								//保存患者触发规则数据统计
								if PatientInfo'["TMPAPI"
								{
									d ##class(web.CDSS.MedicalRule.GetPatientRuleResult).SavePatTriggerStatic(PatientInfo,RuleRowId,FChartNum,RuleTypeDR1,ResultRowId,RecommendResultDesc,"",NodeTypeDesc)	
								}
							}
							
						}
						
						//取预警数据
						if ($d(^CT.WDT.CDSS.RuleRationalityI("NodeDRIndex",NodeRowId)))
						{	
							k WarnTypeArray
							s OrderStr=""
							s IWordlen=$length(PRuleFlowIWordStr,"[A]")
							
							for iIWord=1:1:IWordlen
							{
								s IWordDR=$p(PRuleFlowIWordStr,"[A]",iIWord)
								if (IWordDR'="")
								{
									s TriggerIWRowId=0
									for
									{
										s TriggerIWRowId=$o(^WDT.CDSS.PatTriggerIWI("IDNOIWIndex",IDNO,IWordDR,TriggerIWRowId)) q:TriggerIWRowId=""
										s PFiledValueStr=$lg($g(^WDT.CDSS.PatTriggerIWD(TriggerIWRowId)),10)
										s PTableNameStr=$lg($g(^WDT.CDSS.PatTriggerIWD(TriggerIWRowId)),8)
										s ValueLen=$l(PFiledValueStr,"&")
										
										for iValue=1:1:ValueLen
										{
											s Value=$p(PFiledValueStr,"&",iValue)
											if (Value'="")
											{
												s:OrderStr'="" OrderStr=OrderStr_Value_"[^]"
												s:OrderStr="" OrderStr="[^]"_Value_"[^]"
											}
											s TableName=$p(PTableNameStr,"&",iValue)
											if TableName'=""
											{
												//Todo
												s Itemtype=""
												for
												{
													s Itemtype=$o(^CT.WDT.CDSS.WordsItemI("TableNameIndex",TableName,Itemtype))
													q:Itemtype=""
													continue:Itemtype=""
													s WarnTypeArray(Itemtype)=""
												}
											}
										}
									}
								}
								
							}
							
							s RationalityRowId = 0
							for
							{
								s RationalityRowId = $o(^CT.WDT.CDSS.RuleRationalityI("NodeDRIndex",NodeRowId,RationalityRowId)) q:RationalityRowId=""
								s Sequence  = $lg($g(^CT.WDT.CDSS.RuleRationalityD(RationalityRowId)),3)
								s WarningContent  = $lg($g(^CT.WDT.CDSS.RuleRationalityD(RationalityRowId)),4)
								s TabooLevel  = $lg($g(^CT.WDT.CDSS.RuleRationalityD(RationalityRowId)),5)
								s TreatSource = $lg($g(^CT.WDT.CDSS.RuleRationalityD(RationalityRowId)),7)
								s RuleBasisDR = $lg($g(^CT.WDT.CDSS.RuleRationalityD(RationalityRowId)),8)
								s SourceFlag=0
								if (TreatSource'="")||(RuleBasisDR'="")
								{
									s SourceFlag=1
								}
								//院方预警阻断
								s HospWarnStopFlag=##class(web.CDSS.Config.RuleConfig).GetRuleLevel(RationalityRowId)
								if (HospWarnStopFlag="阻断开立")||(HospWarnStopFlag="弹窗提醒")
								{	
								 	if (NodeTypeDesc="手术合理性")
								 	{
									 	continue:'$d(WarnTypeArray("手术"))
									}
									
									if (NodeTypeDesc="护理/处置合理性")
									{
										continue:'$d(WarnTypeArray("护理"))&('$d(WarnTypeArray("体征")))
									}
									s TmpAss={}
									d TmpAss.%Set("RiskLevel",TabooLevel)
									d TmpAss.%Set("WarningTip",WarningContent)
									d TmpAss.%Set("AlertLevel",HospWarnStopFlag)
									d TmpAss.%Set("SourceFlag",SourceFlag)

									s Tmp={}
									d Tmp.%Set("OrderStr",OrderStr)
									d Tmp.%Set("NodeId",NodeRowId)
									d ..ProcessDuplicate(RuleVision,.HospWarnStopArray,.TmpAss,Tmp)	
									
								}								
								
								if (NodeTypeDesc="检查合理性")||(NodeTypeDesc="检验合理性")
								{
									continue:'$d(WarnTypeArray("检查"))&'$d(WarnTypeArray("检查结果"))&'$d(WarnTypeArray("检验"))
									s TmpAss={}
									d TmpAss.%Set("RiskLevel",TabooLevel)
									d TmpAss.%Set("WarningTip",WarningContent)
									d TmpAss.%Set("AlertLevel",HospWarnStopFlag)
									d TmpAss.%Set("SourceFlag",SourceFlag)

									s Tmp={}
									d Tmp.%Set("OrderStr",OrderStr)
									d Tmp.%Set("NodeId",NodeRowId_"|"_RationalityRowId)
									d ..ProcessDuplicate(RuleVision,.LabExamWArray,.TmpAss,Tmp)
										
								}
								elseif(NodeTypeDesc="手术合理性")
								{
									continue:'$d(WarnTypeArray("手术"))
									s TmpAss={}
									d TmpAss.%Set("RiskLevel",TabooLevel)
									d TmpAss.%Set("WarningTip",WarningContent)
									d TmpAss.%Set("AlertLevel",HospWarnStopFlag)
									d TmpAss.%Set("SourceFlag",SourceFlag)

									s Tmp={}
									d Tmp.%Set("OrderStr",OrderStr)
									d Tmp.%Set("NodeId",NodeRowId)
									d ..ProcessDuplicate(RuleVision,.OperaWArray,.TmpAss,Tmp)
								
								}
								elseif(NodeTypeDesc="护理/处置合理性")
								{
									continue:'$d(WarnTypeArray("护理"))&('$d(WarnTypeArray("体征")))
									s TmpAss={}
									d TmpAss.%Set("RiskLevel",TabooLevel)
									d TmpAss.%Set("WarningTip",WarningContent)
									d TmpAss.%Set("AlertLevel",HospWarnStopFlag)
									d TmpAss.%Set("SourceFlag",SourceFlag)	
									
									s Tmp={}
									d Tmp.%Set("OrderStr",OrderStr)
									d Tmp.%Set("NodeId",NodeRowId_"|"_RationalityRowId)
									d ..ProcessDuplicate(RuleVision,.NursWArray,.TmpAss,Tmp)
								}
								elseif(NodeTypeDesc="过敏合理性")
								{
									s TmpAss={}
									d TmpAss.%Set("RiskLevel",TabooLevel)
									d TmpAss.%Set("WarningTip",WarningContent)
									d TmpAss.%Set("AlertLevel",HospWarnStopFlag)
									d TmpAss.%Set("SourceFlag",SourceFlag)	
									
									s Tmp={}
									d Tmp.%Set("OrderStr",OrderStr)
									d Tmp.%Set("NodeId",NodeRowId_"|"_RationalityRowId)
									d ..ProcessDuplicate(RuleVision,.AllergyWArray,.TmpAss,Tmp)
								}
								elseif(NodeTypeDesc="输血合理性")
								{
									s TmpAss={}
									d TmpAss.%Set("RiskLevel",TabooLevel)
									d TmpAss.%Set("WarningTip",WarningContent)
									d TmpAss.%Set("AlertLevel",HospWarnStopFlag)
									d TmpAss.%Set("SourceFlag",SourceFlag)
									
									s Tmp={}
									d Tmp.%Set("OrderStr",OrderStr)
									d Tmp.%Set("NodeId",NodeRowId_"|"_RationalityRowId)
									d ..ProcessDuplicate(RuleVision,.BloodWArray,.TmpAss,Tmp)
								}
								elseif(NodeTypeDesc="诊断合理性")
								{
									s TmpAss={}
									d TmpAss.%Set("RiskLevel",TabooLevel)
									d TmpAss.%Set("WarningTip",WarningContent)
									d TmpAss.%Set("AlertLevel",HospWarnStopFlag)
									d TmpAss.%Set("SourceFlag",SourceFlag)

									s Tmp={}
									d Tmp.%Set("OrderStr",OrderStr)
									d Tmp.%Set("NodeId",NodeRowId_"|"_RationalityRowId)
									d ..ProcessDuplicate(RuleVision,.DiseWArray,.TmpAss,Tmp)
								}	
								elseif(NodeTypeDesc="药品合理性")
								{
									s TmpAss={}
									d TmpAss.%Set("RiskLevel",TabooLevel)
									d TmpAss.%Set("WarningTip",WarningContent)
									d TmpAss.%Set("AlertLevel",HospWarnStopFlag)
									d TmpAss.%Set("SourceFlag",SourceFlag)
				
									s Tmp={}
									d Tmp.%Set("OrderStr",OrderStr)
									d Tmp.%Set("NodeId",NodeRowId_"|"_RationalityRowId)
									d ..ProcessDuplicate(RuleVision,.DrugWArray,.TmpAss,Tmp)
								}
								elseif(NodeTypeDesc="高危警示")
								{
									s TmpAss={}
									d TmpAss.%Set("RiskLevel",TabooLevel)
									d TmpAss.%Set("WarningTip",WarningContent)
									d TmpAss.%Set("AlertLevel",HospWarnStopFlag)
									d TmpAss.%Set("SourceFlag",SourceFlag)
				
									s Tmp={}
									d Tmp.%Set("OrderStr",OrderStr)
									d Tmp.%Set("NodeId",NodeRowId_"|"_RationalityRowId)
									d ..ProcessDuplicate(RuleVision,.HighRiskWarnArray,.TmpAss,Tmp)
									
								}
								elseif(NodeTypeDesc="病历书写合理性")
								{
									s TmpAss={}
									d TmpAss.%Set("RiskLevel",TabooLevel)
									d TmpAss.%Set("WarningTip",WarningContent)
									d TmpAss.%Set("AlertLevel",HospWarnStopFlag)
									d TmpAss.%Set("SourceFlag",SourceFlag)
				
									s Tmp={}
									d Tmp.%Set("OrderStr",OrderStr)
									d Tmp.%Set("NodeId",NodeRowId_"|"_RationalityRowId)
									d ..ProcessDuplicate(RuleVision,.EmrRecordRationArray,.TmpAss,Tmp)
								}
								

								//保存患者触发规则数据统计
								if PatientInfo'["TMPAPI"
								{
									d ##class(web.CDSS.MedicalRule.GetPatientRuleResult).SavePatTriggerStatic(PatientInfo,RuleRowId,FChartNum,RuleTypeDR1,RationalityRowId,WarningContent,TabooLevel,NodeTypeDesc)
								}
							}
						}
						
						//取并发症数据
						if ($d(^CT.WDT.CDSS.RuleComplicationI("NodeDRIndex",NodeRowId)))
						{	
							//s PatOperInfo=##class(web.CDSS.IdentifyWords.GetPatientInfo).DealDataByPatientEnumI(PatientInfo,"手术")
							s PatOperInfo = $g(^TempPInfoItemData($j,PatientInfo,"手术"))
							s:PatOperInfo="" PatOperInfo="[]"
							s PatOperInfo=[].%FromJSON(PatOperInfo)
							for iOper=0:1:(PatOperInfo.%Size()-1)  //遍历条件判断是否满足
							{
								if (RuleDesc[((PatOperInfo.%Get(iOper)).%Get("OperName")))&&(((PatOperInfo.%Get(iOper)).%Get("OperEndTime")'="")) //完成后的手术才能触发并发症
								{
									s ComplicationRowId = 0
									for
									{
										s ComplicationRowId = $o(^CT.WDT.CDSS.RuleComplicationI("NodeDRIndex",NodeRowId,ComplicationRowId)) q:ComplicationRowId=""
										s Sequence  = $lg($g(^CT.WDT.CDSS.RuleComplicationD(ComplicationRowId)),3)
										s ComplicationDR  = $lg($g(^CT.WDT.CDSS.RuleComplicationD(ComplicationRowId)),4)
										s ComplicationDRDesc=""
										s:ComplicationDR'="" ComplicationDRDesc=$lg($g(^CT.WDT.CDSS.DiseaseDictD(ComplicationDR)),3)
										s MainPoints  = $lg($g(^CT.WDT.CDSS.RuleComplicationD(ComplicationRowId)),5)
										s TreatSource = $lg($g(^CT.WDT.CDSS.RuleComplicationD(ComplicationRowId)),7)
										s RuleBasisDR = $lg($g(^CT.WDT.CDSS.RuleComplicationD(ComplicationRowId)),8)
										s SourceFlag=0
										if (TreatSource'="")||(RuleBasisDR'="")
										{
											s SourceFlag=1
										}
										
										s TmpAss={}
										d TmpAss.%Set("Complication",ComplicationDRDesc)
										d TmpAss.%Set("Remark",MainPoints)
										d TmpAss.%Set("SourceFlag",SourceFlag)
										
										s Tmp={}
										d ..ProcessDuplicate(RuleVision,.OperCompArray,.TmpAss,Tmp)
										//保存患者触发规则数据统计
										if PatientInfo'["TMPAPI"
										{
											d ##class(web.CDSS.MedicalRule.GetPatientRuleResult).SavePatTriggerStatic(PatientInfo,RuleRowId,FChartNum,RuleTypeDR1,ComplicationRowId,ComplicationDRDesc,"",NodeTypeDesc)		
										}
									}
									
								}
									
							}
						}
									
							
					}	
				}
			}
			
		}
		/*	
		//取规则的文献
		s RuleSources=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowId)),5)
		if (RuleSources'="") 
		{
			s SourseLen=$length(RuleSources,"&%")
			for iSourse=1:1:SourseLen
			{
				s DocuDesc=$p(RuleSources,"&%",iSourse)
				s DocuRowId=$o(^CT.WDT.CDSS.DocuManageI("DescIndex",DocuDesc,0))	
				s TmpAss={}
				d TmpAss.%Set("ItemName",DocuDesc)
				d TmpAss.%Set("ItemID",DocuRowId)
				s DocArrayJson=DocArray.%ToJSON()
				s TmpAssJson=TmpAss.%ToJSON()
				
				if (DocArrayJson'[TmpAssJson)
				{
					d DocArray.%Push(TmpAss)
				}	
			}
		}*/
	}
	s DiagResultArray=[],RDiagResultArray=[],DiffDiagResultArray=[],DocResultArray=[],LabExamResultArray=[],NursResultArray=[],AssessResultArray=[],TreatResultArray=[],DiseWResultArray=[],
	LabExamWResultArray=[],OperaWResultArray=[],NursWResultArray=[],AllergyWResultArray=[],BloodWResultArray=[],OperCompResultArray=[],DrugWResultArray=[],HospWarnStopResultArray=[],DischargeGResultArray=[],MedCalulateResultArray=[],HighRiskResultArray=[],EmrRationResultArray=[]
	
	//从患者信息表获取确诊诊断，根据确诊诊断获取相关文献

	s DiagnosisInfo=##class(web.CDSS.Public.PatientModelInterface).GetPatientEnumInfo(PatientInfo_"^诊断")
	
	//s DiagnosisInfo=$g(^TempPInfoItemData($j,PatientInfo,"诊断"))
	if (DiagnosisInfo'="")  //患者模型取到的数据不为空
	{
		s MainTmpAss=""
		s MainDiseaseData=[]
		s PInfoItem=[].%FromJSON(DiagnosisInfo)
		for i=0:1:(PInfoItem.%Size()-1)  //遍历条件
		{
			s DiagnosisID=$tr((PInfoItem.%Get(i)).%Get("DiagnosisID"),"""","'")
			s DiagnosisName=$tr((PInfoItem.%Get(i)).%Get("DiagnosisName"),"""","'")
			s DiagnosisType=$tr((PInfoItem.%Get(i)).%Get("DiagnosisType"),"""","'")
			s ChildDiagnosisFlag=$tr((PInfoItem.%Get(i)).%Get("ChildDiagnosisFlag"),"""","'")
			s DiagnosisClass=$tr((PInfoItem.%Get(i)).%Get("DiagnosisClass"),"""","'")
			if (DiagnosisName'="")
			{
				//获取相关文献
				/*
				s DiseID=$o(^CT.WDT.CDSS.DiseaseDictI("NameIndex"," "_$ZCONVERT(DiagnosisName,"U"),0))
				if (DiseID'="")
				{
					s DocJDiseRowId = 0
					for
					{
						s DocJDiseRowId = $o(^CT.WDT.CDSS.DocuJoinDiseaseI("DiseIndex",DiseID,DocJDiseRowId)) q:DocJDiseRowId=""
						s DocuDR = $lg($g(^CT.WDT.CDSS.DocuJoinDiseaseD(DocJDiseRowId)),2)
						s DocuDesc ="",DocuPath="",DocuType="",DocuMonth=""
						s:DocuDR'="" DocuDesc = $lg($g(^CT.WDT.CDSS.DocuManageD(DocuDR)),3)
						s:DocuDR'="" DocuPath = $lg($g(^CT.WDT.CDSS.DocuManageD(DocuDR)),5)
						s:DocuDR'="" DocuType = $lg($g(^CT.WDT.CDSS.DocuManageD(DocuDR)),7)
						s:DocuDR'="" DocuMonth = $lg($g(^CT.WDT.CDSS.DocuManageD(DocuDR)),10)
						continue:DocuPath=""
						s TmpAss={}
						d TmpAss.%Set("ItemName",DocuDesc)
						d TmpAss.%Set("ItemID",DocuDR)
						
						s DocuPathList=[]
						for j=1:1:$l(DocuPath,"^")
						{
							s Doc=$p(DocuPath,"^",j)
							continue:Doc=""
							d DocuPathList.%Push(Doc)
						}
						d TmpAss.%Set("ItemPath",DocuPathList)
						d TmpAss.%Set("ItemType",DocuType)
						d TmpAss.%Set("ItemDate",DocuMonth)
						
						s Tmp={}
						d ..ProcessDuplicate("",.DocArray,.TmpAss,Tmp)
						//保存患者触发规则数据统计
						if PatientInfo'["TMPAPI"
						{
							d ##class(web.CDSS.MedicalRule.GetPatientRuleResult).SavePatTriggerStatic(PatientInfo,"","","",DocJDiseRowId,DocuDesc,"","相关文献")		
						}
					}
				}
				*/
				//确诊诊断
				s ProjectDataName =  ##class(web.CDSS.IMP.ContrastDict).GetProjectDataName(DiagnosisName,"诊断","1")

				s ProjectCode =$p(ProjectDataName,"&%",1)
				s ProjectName=$p(ProjectDataName,"&%",2)
				
				if ChildDiagnosisFlag'=""
				{
					if ChildDiagnosisFlag=0
					{
						s MainTmpAss={}
						d MainTmpAss.%Set("ItemName",DiagnosisName)
						d MainTmpAss.%Set("ItemType",DiagnosisType)
						d MainTmpAss.%Set("ProjectName",ProjectName)  
						d MainTmpAss.%Set("MatchCode",ProjectCode)
						d MainTmpAss.%Set("ItemID",DiagnosisID)
						d MainTmpAss.%Set("DiagnosisClass",DiagnosisClass)
						d MainTmpAss.%Set("MainDiseaseFlag",1)
						d MainDiseaseData.%Push(MainTmpAss)
						continue
					}
				}
				s TmpAss={}
				d TmpAss.%Set("ItemName",DiagnosisName)
				
				
				d TmpAss.%Set("ItemType",DiagnosisType)
				d TmpAss.%Set("ProjectName",ProjectName)  
				d TmpAss.%Set("MatchCode",ProjectCode)
				d TmpAss.%Set("DiagnosisClass",DiagnosisClass)
				d TmpAss.%Set("MainDiseaseFlag",0)
				s Tmp={}
				d Tmp.%Set("ItemID",DiagnosisID)
				

				d ..ProcessDuplicate("",.DiagArray,.TmpAss,Tmp)	
			} 
		}
		if MainTmpAss'=""
		{
			s DiagArray=..ConcatArrays(MainDiseaseData,DiagArray)
		}
	}
	
	d ..GetIWDoc(PatientDR,VisitID,VisitType,.DocArray,.IWData)
	
	s TmpAss={}
	d TmpAss.%Set("InterfaceName","确诊诊断")
	d TmpAss.%Set("InterfaceValue",DiagArray)
	s DiagInfo=DiagResultArray.%Push(TmpAss).%ToJSON()
	d ResultArray.%Push(TmpAss)
	d ##class(web.CDSS.PatientView.PatientRecomInfo).SaveRecomInfo(PatientInfo,"确诊诊断",DiagInfo)
	
	
	s TmpAss={}
	d TmpAss.%Set("InterfaceName","推荐确诊")
	d TmpAss.%Set("InterfaceValue",RDiagArray)
	s RDiagInfo=RDiagResultArray.%Push(TmpAss).%ToJSON()
	d ResultArray.%Push(TmpAss)
	d ##class(web.CDSS.PatientView.PatientRecomInfo).SaveRecomInfo(PatientInfo,"推荐确诊",RDiagInfo)

	
	s TmpAss={}
	d TmpAss.%Set("InterfaceName","鉴别诊断")
	d TmpAss.%Set("InterfaceValue",DiffDiagArray)
	s DiffDiagInfo=DiffDiagResultArray.%Push(TmpAss).%ToJSON()
	d ResultArray.%Push(TmpAss)
	d ##class(web.CDSS.PatientView.PatientRecomInfo).SaveRecomInfo(PatientInfo,"鉴别诊断",DiffDiagInfo)
	
	s TmpAss={}
	d TmpAss.%Set("InterfaceName","推荐相关文献")
	d TmpAss.%Set("InterfaceValue",DocArray)
	s DocInfo=DocResultArray.%Push(TmpAss).%ToJSON()
	d ResultArray.%Push(TmpAss)
	d ##class(web.CDSS.PatientView.PatientRecomInfo).SaveRecomInfo(PatientInfo,"推荐相关文献",DocInfo)
	
	s TmpAss={}
	d TmpAss.%Set("InterfaceName","推荐检验检查")
	d TmpAss.%Set("InterfaceValue",LabExamArray)
	s LabExamInfo=LabExamResultArray.%Push(TmpAss).%ToJSON()
	d ResultArray.%Push(TmpAss)
	d ##class(web.CDSS.PatientView.PatientRecomInfo).SaveRecomInfo(PatientInfo,"推荐检验检查",LabExamInfo)
	
	s TmpAss={}
	d TmpAss.%Set("InterfaceName","推荐护理措施")
	d TmpAss.%Set("InterfaceValue",NursArray)
	s NursInfo=NursResultArray.%Push(TmpAss).%ToJSON()
	d ResultArray.%Push(TmpAss)
	d ##class(web.CDSS.PatientView.PatientRecomInfo).SaveRecomInfo(PatientInfo,"推荐护理措施",NursInfo)
	
	s TmpAss={}
	d TmpAss.%Set("InterfaceName","出院指导")
	d TmpAss.%Set("InterfaceValue",DischargeGArray)
	s DischargeGInfo=DischargeGResultArray.%Push(TmpAss).%ToJSON()
	d ResultArray.%Push(TmpAss)
	d ##class(web.CDSS.PatientView.PatientRecomInfo).SaveRecomInfo(PatientInfo,"出院指导",DischargeGInfo)
	
	s TmpAss={}
	d TmpAss.%Set("InterfaceName","推荐评估量表")
	s AssessArray=..SortArrayByField(AssessArray,"ShowPriority")
	s Temp2AssessArray=..SortArrayByField(Temp2AssessArray,"ShowPriority")
	s Temp1AssessArray=..SortArrayByField(Temp1AssessArray,"ShowPriority")
	
	s AssessArray = ..ConcatArrays(Temp2AssessArray,AssessArray)
	s AssessArray = ..ConcatArrays(Temp1AssessArray,AssessArray)
	d TmpAss.%Set("InterfaceValue",AssessArray)
	s AssessInfo=AssessResultArray.%Push(TmpAss).%ToJSON()
	d ResultArray.%Push(TmpAss)
	d ##class(web.CDSS.PatientView.PatientRecomInfo).SaveRecomInfo(PatientInfo,"推荐评估量表",AssessInfo)
	
	s TmpAss={}
	d TmpAss.%Set("InterfaceName","辅助计算")
	s AssessArray=..SortArrayByField(AssessArray,"ShowPriority")
	s Temp2AssessArray=..SortArrayByField(Temp2AssessArray,"ShowPriority")
	s Temp1AssessArray=..SortArrayByField(Temp1AssessArray,"ShowPriority")
	
	s MedCalulateArray = ..ConcatArrays(Temp2MedCalulateArray,MedCalulateArray)
	s MedCalulateArray = ..ConcatArrays(Temp1MedCalulateArray,MedCalulateArray)

	d TmpAss.%Set("InterfaceValue",MedCalulateArray)
	s MedCalulateInfo=MedCalulateResultArray.%Push(TmpAss).%ToJSON()
	d ResultArray.%Push(TmpAss)
	d ##class(web.CDSS.PatientView.PatientRecomInfo).SaveRecomInfo(PatientInfo,"辅助计算",MedCalulateInfo)
	
	
	s TmpAss={}
	d TmpAss.%Set("InterfaceName","推荐治疗方案")
	s SortedTreatArray=..SortRecomTreatResult(TreatArray)
	d TmpAss.%Set("InterfaceValue",SortedTreatArray)
	s TreatInfo=TreatResultArray.%Push(TmpAss).%ToJSON()
	d ResultArray.%Push(TmpAss)
	d ##class(web.CDSS.PatientView.PatientRecomInfo).SaveRecomInfo(PatientInfo,"推荐治疗方案",TreatInfo)
	
	s TmpAss={}
	d TmpAss.%Set("InterfaceName","疾病预警")
	d TmpAss.%Set("InterfaceValue",DiseWArray)
	s DiseWInfo=DiseWResultArray.%Push(TmpAss).%ToJSON()
	d ResultArray.%Push(TmpAss)
	d ##class(web.CDSS.PatientView.PatientRecomInfo).SaveRecomInfo(PatientInfo,"疾病预警",DiseWInfo)
	
	s TmpAss={}
	d TmpAss.%Set("InterfaceName","检验检查预警")
	d TmpAss.%Set("InterfaceValue",LabExamWArray)
	s LabExamWInfo=LabExamWResultArray.%Push(TmpAss).%ToJSON()
	d ResultArray.%Push(TmpAss)
	d ##class(web.CDSS.PatientView.PatientRecomInfo).SaveRecomInfo(PatientInfo,"检验检查预警",LabExamWInfo)
	
	s TmpAss={}
	d TmpAss.%Set("InterfaceName","手术预警")
	d TmpAss.%Set("InterfaceValue",OperaWArray)
	s OperaWInfo=OperaWResultArray.%Push(TmpAss).%ToJSON()
	d ResultArray.%Push(TmpAss)
	d ##class(web.CDSS.PatientView.PatientRecomInfo).SaveRecomInfo(PatientInfo,"手术预警",OperaWInfo)
	
	s TmpAss={}
	d TmpAss.%Set("InterfaceName","护理预警")
	d TmpAss.%Set("InterfaceValue",NursWArray)
	s NursWInfo=NursWResultArray.%Push(TmpAss).%ToJSON()
	d ResultArray.%Push(TmpAss)
	d ##class(web.CDSS.PatientView.PatientRecomInfo).SaveRecomInfo(PatientInfo,"护理预警",NursWInfo)
	
	s TmpAss={}
	d TmpAss.%Set("InterfaceName","过敏史预警")
	d TmpAss.%Set("InterfaceValue",AllergyWArray)
	s AllergyWInfo=AllergyWResultArray.%Push(TmpAss).%ToJSON()
	d ResultArray.%Push(TmpAss)
	d ##class(web.CDSS.PatientView.PatientRecomInfo).SaveRecomInfo(PatientInfo,"过敏史预警",AllergyWInfo)
	
	s TmpAss={}
	d TmpAss.%Set("InterfaceName","输血预警")
	d TmpAss.%Set("InterfaceValue",BloodWArray)
	s BloodWInfo=BloodWResultArray.%Push(TmpAss).%ToJSON()
	d ResultArray.%Push(TmpAss)
	d ##class(web.CDSS.PatientView.PatientRecomInfo).SaveRecomInfo(PatientInfo,"输血预警",BloodWInfo)
	
	s TmpAss={}
	d TmpAss.%Set("InterfaceName","手术并发症")
	d TmpAss.%Set("InterfaceValue",OperCompArray)
	s OperCompInfo=OperCompResultArray.%Push(TmpAss).%ToJSON()
	d ResultArray.%Push(TmpAss)
	d ##class(web.CDSS.PatientView.PatientRecomInfo).SaveRecomInfo(PatientInfo,"手术并发症",OperCompInfo)
	
	s TmpAss={}
	d TmpAss.%Set("InterfaceName","药品预警")
	d TmpAss.%Set("InterfaceValue",DrugWArray)
	s DrugWInfo=DrugWResultArray.%Push(TmpAss).%ToJSON()
	d ResultArray.%Push(TmpAss)
	d ##class(web.CDSS.PatientView.PatientRecomInfo).SaveRecomInfo(PatientInfo,"药品预警",DrugWInfo)
	
	s TmpAss={}
	d TmpAss.%Set("InterfaceName","高危警示")
	d TmpAss.%Set("InterfaceValue",HighRiskWarnArray)
	s HighRiskWInfo=HighRiskResultArray.%Push(TmpAss).%ToJSON()
	d ResultArray.%Push(TmpAss)
	d ##class(web.CDSS.PatientView.PatientRecomInfo).SaveRecomInfo(PatientInfo,"高危警示",HighRiskWInfo)
	
	s TmpAss={}
	d TmpAss.%Set("InterfaceName","病历书写合理性")
	d TmpAss.%Set("InterfaceValue",EmrRecordRationArray)
	s EmrRationInfo=EmrRationResultArray.%Push(TmpAss).%ToJSON()
	d ResultArray.%Push(TmpAss)
	d ##class(web.CDSS.PatientView.PatientRecomInfo).SaveRecomInfo(PatientInfo,"病历书写合理性",EmrRationInfo)
	
	//院方预警阻断
	s TmpAss={}
	d TmpAss.%Set("InterfaceName","院方预警阻断")
	d TmpAss.%Set("InterfaceValue",HospWarnStopArray)
	s HospWarnStopInfo=HospWarnStopResultArray.%Push(TmpAss).%ToJSON()
	d ResultArray.%Push(TmpAss)
	d ##class(web.CDSS.PatientView.PatientRecomInfo).SaveRecomInfo(PatientInfo,"院方预警阻断",HospWarnStopInfo)
	
	//获取评估记录
	s AssessRSArray=[],AssessRSResultArray=[]
	
	if (Config=1)&(PatientDR'="")&(VisitID'="") // 单个患者单次就诊 根据病人标识和就诊次数编号取数据
	{
		if ($d(^WDT.CDSS.PatientRatingScaleI("RatingScaleDictDrIndex",PatientDR,VisitID," "_VisitType)))
		{
			s RatingScaleDictDR=""
			for
			{
				s RatingScaleDictDR = $o(^WDT.CDSS.PatientRatingScaleI("RatingScaleDictDrIndex",PatientDR,VisitID," "_VisitType,RatingScaleDictDR)) q:RatingScaleDictDR=""
				s MKBAssName = $LISTGET($G(^CT.WDT.CDSS.AssBaseD(RatingScaleDictDR)),3)
				s childArray=[]
				s TableID=""
				for
				{
					s TableID = $o(^WDT.CDSS.PatientRatingScaleI("RatingScaleDictDrIndex",PatientDR,VisitID," "_VisitType,RatingScaleDictDR,TableID)) q:TableID=""
					s AllValue = $LISTGET($G(^WDT.CDSS.PatientRatingScaleD(TableID)),15)
					s Remarks = $LISTGET($G(^WDT.CDSS.PatientRatingScaleD(TableID)),11)
					s RatingUser = $LISTGET($G(^WDT.CDSS.PatientRatingScaleD(TableID)),9)
					s RatingScore = $LISTGET($G(^WDT.CDSS.PatientRatingScaleD(TableID)),12)
					s RatingDesc = $LISTGET($G(^WDT.CDSS.PatientRatingScaleD(TableID)),13)
					s RatingDate = $LISTGET($G(^WDT.CDSS.PatientRatingScaleD(TableID)),8)
					
					s TmpAssC={}
					d TmpAssC.%Set("ID",RatingScaleDictDR)  //评估表ID
					d TmpAssC.%Set("AllValue",AllValue)
					d TmpAssC.%Set("Remarks",Remarks)
					d TmpAssC.%Set("TableID",TableID)  
					d TmpAssC.%Set("Score",RatingScore)
					d TmpAssC.%Set("Result",RatingDesc)
					d TmpAssC.%Set("RatingUser",RatingUser)
					d TmpAssC.%Set("ShowDate",RatingDate)
					d childArray.%Push(TmpAssC)
					
					//保存患者触发规则数据统计
					if PatientInfo'["TMPAPI"
					{
						d ##class(web.CDSS.MedicalRule.GetPatientRuleResult).SavePatTriggerStatic(PatientInfo,"","","",TableID,MKBAssName,"","评估记录")	
					}
				}
				s TmpAss={}
				d TmpAss.%Set("ItemName",MKBAssName)  //评估表ID
				d TmpAss.%Set("children",childArray)
				d AssessRSArray.%Push(TmpAss)
				
			}	
		}	
	} 
	elseif (IDNO'="")  //患者主索引
	{
		if ($d(^WDT.CDSS.PatientRatingScaleI("IDNORSDictDRIndex",IDNO)))
		{
			s RatingScaleDictDR=""
			for
			{
				s RatingScaleDictDR = $o(^WDT.CDSS.PatientRatingScaleI("IDNORSDictDRIndex",IDNO,RatingScaleDictDR)) q:RatingScaleDictDR=""
				s MKBAssName = $LISTGET($G(^CT.WDT.CDSS.AssBaseD(RatingScaleDictDR)),3)
				s childArray=[]
				s TableID=""
				for
				{
					s TableID = $o(^WDT.CDSS.PatientRatingScaleI("IDNORSDictDRIndex",IDNO,RatingScaleDictDR,TableID)) q:TableID=""
					s AllValue = $LISTGET($G(^WDT.CDSS.PatientRatingScaleD(TableID)),15)
					s Remarks = $LISTGET($G(^WDT.CDSS.PatientRatingScaleD(TableID)),11)
					s RatingUser = $LISTGET($G(^WDT.CDSS.PatientRatingScaleD(TableID)),9)
					s RatingScore = $LISTGET($G(^WDT.CDSS.PatientRatingScaleD(TableID)),12)
					s RatingDesc = $LISTGET($G(^WDT.CDSS.PatientRatingScaleD(TableID)),13)
					s RatingDate = $LISTGET($G(^WDT.CDSS.PatientRatingScaleD(TableID)),8)
					
					s TmpAssC={}
					d TmpAssC.%Set("ID",RatingScaleDictDR)  //评估表ID
					d TmpAssC.%Set("AllValue",AllValue)
					d TmpAssC.%Set("Remarks",Remarks)
					d TmpAssC.%Set("TableID",TableID)  
					d TmpAssC.%Set("Score",RatingScore)
					d TmpAssC.%Set("Result",RatingDesc)
					d TmpAssC.%Set("RatingUser",RatingUser)
					d TmpAssC.%Set("ShowDate",RatingDate)
					d childArray.%Push(TmpAssC)
					
					//保存患者触发规则数据统计
					if PatientInfo'["TMPAPI"
					{
						d ##class(web.CDSS.MedicalRule.GetPatientRuleResult).SavePatTriggerStatic(PatientInfo,"","","",TableID,MKBAssName,"","评估记录")	
					}
				}
				s TmpAss={}
				d TmpAss.%Set("ItemName",MKBAssName)  //评估表ID
				d TmpAss.%Set("children",childArray)
				d AssessRSArray.%Push(TmpAss)
				
			}
		}	
	}
	s TmpAss={}
	d TmpAss.%Set("InterfaceName","评估表评估记录")
	d TmpAss.%Set("InterfaceValue",AssessRSArray)
	s AssessRSInfo=AssessRSResultArray.%Push(TmpAss).%ToJSON()
	d ResultArray.%Push(TmpAss)
	d ##class(web.CDSS.PatientView.PatientRecomInfo).SaveRecomInfo(PatientInfo,"评估表评估记录",AssessRSInfo)
	
	if ProVision=""
	{
		s EMRArray=##class(web.CDSS.MedicalRule.GetPatientHQEMR).SaveSatisfyHQEMR(PatientInfo)
		s TmpAss={}
		d TmpAss.%Set("InterfaceName","优质病历")
		d TmpAss.%Set("InterfaceValue",EMRArray)
		d ResultArray.%Push(TmpAss)
	}
	
	s ALLInfo=ResultArray.%ToJSON()

    d ##class(web.CDSS.PatientView.PatientRecomInfo).SaveRecomInfo(PatientInfo,"ALLINFO",ALLInfo)
	k ^TempPInfoItemData($j,PatientIn)
	q "OK"
}

/// Creator:李得原
/// CreatDate:2023-01-16
/// Description:判断是否存在临床指征评估表推荐
/// Table: 
/// Input: PatientInfo 
/// Return: 
/// Others:w ##class(web.CDSS.MedicalRule.GetPatientRuleResult).AccessClinicCheck("DM000778^DM000778^1^住院^^Demo Group^^心脏内科^1")
ClassMethod AccessClinicCheck(PatientInfo As %String) As %String
{
	s RuleTypeDR="-100000000000000"
	s NodeTypeDR=$o(^CT.WDT.CDSS.NodeTypeI("DescIndex"," 推荐临床指征评估表",0))
	s IDNO=$p(PatientInfo,"^",1)
	s PatientDR=$p(PatientInfo,"^",2)
	s VisitID=$p(PatientInfo,"^",3)
	s VisitType=$p(PatientInfo,"^",4)
	s RuleDR=0
	for
	{
		s RuleDR=$o(^WDT.CDSS.PatTriggerRuleI("PatVisTypeRuleTypeDRFlowIndex",PatientDR,VisitID,VisitType,RuleDR))
		q:RuleDR=""
		s FlowNum=0
		for
		{
			s FlowNum=$o(^WDT.CDSS.PatTriggerRuleI("PatVisTypeRuleTypeDRFlowIndex",PatientDR,VisitID,VisitType,RuleDR,RuleTypeDR,FlowNum))
			q:FlowNum=""
			if $d(^CT.WDT.CDSS.RuleNodeI("RuleChartTypeIndex",RuleDR,RuleTypeDR,FlowNum,NodeTypeDR))
			{
				return "1"
			}
		}
		
	}
	q "0"
}

/// Creator:丁亚男
/// CreatDate:2021-22-25
/// Description:保存患者触发的数据到患者触发规则预警数据统计表
/// Table: 
/// Input: PatientInfo : 患者信息（医生站所传json串）
/// Return: 
/// Others:w ##class(web.CDSS.MedicalRule.GetPatientRuleResult).SavePatTriggerStatic("DYNCS识别词^DYNCS识别词^1^门诊^13927^丁亚男^111^内分泌科^1")
ClassMethod SavePatTriggerStatic(PatientInfo As %String, RuleDR As %String, FlowChartNum As %String, RuleTypeDR As %String, DetailID As %String, DetailDesc As %String, RiskLevel As %String, NodeType As %String) As %String
{
	//IDNO^PatientDR^VisitID^VisitType^UserID^UserName^CTLocID^CTLocDesc^Config^枚举字段
	q:PatientInfo="" "OK"
	s IDNO=$p(PatientInfo,"^",1)
	s PatientDR=$p(PatientInfo,"^",2)
	s VisitID=$p(PatientInfo,"^",3)
	s VisitType=$p(PatientInfo,"^",4)
	s UserID=$p(PatientInfo,"^",5)
	s UserName=$p(PatientInfo,"^",6)
	s CTLocID=$p(PatientInfo,"^",7)
	s CTLocDesc=$p(PatientInfo,"^",8)
	Ts
	s obj=##class(WDT.CDSS.PatTriggerStatic).%New()
	s obj.IDNO=IDNO
	s obj.PatientDR=PatientDR
	s obj.VisitID=VisitID
	s obj.VisitType=VisitType
	s obj.UserID=UserID
	s obj.UserName=UserName
	s obj.CTLocID=CTLocID
	s obj.CTLocDesc=CTLocDesc
	d:RuleDR'="" obj.RuleDRSetObjectId(RuleDR)
	s obj.FlowChartNum=FlowChartNum
	d:RuleTypeDR'="" obj.RuleTypeDRSetObjectId(RuleTypeDR)
	
	s obj.DetailID=DetailID
	s obj.DetailDesc=DetailDesc
	s obj.RiskLevel=RiskLevel
	s obj.TriggerTime=$zdt($h,3)
	s obj.NodeType=NodeType
	
	s sc=obj.%Save()
    d obj.%Close()
  	
    If $$$ISOK(sc)
    {
        Tc
        s id = obj.%Id()
        
	}
    else
    {
        Trollback
        s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
    }
    q "OK"
}

/// Creator:丁亚男--弃用
/// CreatDate:2021-08-20
/// Description:根据患者当前触发的规则，获取对应治疗方案等信息
/// Table: WDT.CDSS.PatTriggerRule:患者当前触发的规则 CT.WDT.CDSS.RuleResult:诊疗节点内容表  CT.WDT.CDSS.RuleDetail:治疗方案明细表（推荐治疗方案-药品、推荐治疗方案-手术）
/// Input: PatientInfo : 患者信息（医生站所传json串）
/// Return: 
/// Others:w ##class(web.CDSS.MedicalRule.GetPatientRuleResult).GetSatisfyRuleResult("DYNCS识别词^DYNCS识别词^1^门诊^13927^丁亚男^111^内分泌科^1")
ClassMethod GetSatisfyRuleResult(PatientInfo As %String, NodeType As %String = "") As %String
{
	s IDNO=$p(PatientInfo,"^",1)
	s PatientDR=$p(PatientInfo,"^",2)
	s VisitID=$p(PatientInfo,"^",3)
	s VisitType=$p(PatientInfo,"^",4)
	s Config=$p(PatientInfo,"^",9)
	s Type=$p(PatientInfo,"^",10)
	if (Config="") s Config=1	//是否启用流水号（急诊号、门诊号、住院号）为患者就诊唯一标识（0为是，1为否），默认为1
	
	s RuleIDArray=""  //符合索引条件的规则
	if (Config=1)&(PatientDR'="")&(VisitID'="") // 单个患者单次就诊 根据病人标识和就诊次数编号取数据
	{
		if ($d(^WDT.CDSS.PatTriggerRuleI("PatVisDRTypeIndex",PatientDR,VisitID,VisitType)))
		{
			s TriggerRuleRowId=0
			for
			{
				s TriggerRuleRowId =$o(^WDT.CDSS.PatTriggerRuleI("PatVisDRTypeIndex",PatientDR,VisitID,VisitType,TriggerRuleRowId))  q:TriggerRuleRowId="" 
				s RuleDR=$lg($g(^WDT.CDSS.PatTriggerRuleD(TriggerRuleRowId)),6) 
				s FlowChartNum=$lg($g(^WDT.CDSS.PatTriggerRuleD(TriggerRuleRowId)),7) 
				s RuleIDArray(RuleDR,FlowChartNum)=""
			}
		}
	} 
	elseif (IDNO'="")  //患者主索引
	{
		if ($d(^WDT.CDSS.PatTriggerIWI("IDNOIndex",IDNO)))
		{
			s TriggerRuleRowId=0
			for
			{
				s TriggerRuleRowId =$o(WDT.CDSS.PatTriggerIWI("IDNOIndex",IDNO,TriggerRuleRowId))  q:TriggerRuleRowId="" 
				s RuleDR=$lg($g(^WDT.CDSS.PatTriggerRuleD(TriggerRuleRowId)),6) 
				s FlowChartNum=$lg($g(^WDT.CDSS.PatTriggerRuleD(TriggerRuleRowId)),7) 
				s RuleIDArray(RuleDR,FlowChartNum)=""
			}
		}
		
	}
	s NodeTypeRowId=""
	s:NodeType'="" NodeTypeRowId=$o(^CT.WDT.CDSS.NodeTypeI("DescIndex"," "_$ZCONVERT(NodeType,"U"),"")) 
	
	s ResultArray=[]
	// 取符合条件的数据
	s RuleRowId=0
	for
	{
		s RuleRowId=$o(RuleIDArray(RuleRowId)) q:RuleRowId=""
		s FChartNum=0
		for
		{
			s FChartNum=$o(RuleIDArray(RuleRowId,FChartNum)) q:FChartNum=""
			if (NodeTypeRowId'="")&&($d(^CT.WDT.CDSS.RuleNodeI("RuleDRTypeIndex",RuleRowId,FChartNum,NodeTypeRowId)))
			{
				s NodeRowId=0
				for
				{ 
					s NodeRowId=$o(^CT.WDT.CDSS.RuleNodeI("RuleDRTypeIndex",RuleRowId,FChartNum,NodeTypeRowId,NodeRowId)) q:NodeRowId=""
					if (NodeType="推荐检验/检查")||(NodeType="推荐评估表")||(NodeType="推荐护理措施")||(NodeType="推荐治疗方案")||(NodeType="推荐确诊")
					{
						s ResultRowId = 0
						for
						{
							s ResultRowId = $o(^CT.WDT.CDSS.RuleResultI("NodeDRIndex",NodeRowId,ResultRowId)) q:ResultRowId=""
							s Sequence  = $lg($g(^CT.WDT.CDSS.RuleResultD(ResultRowId)),3)
							s RecommendType  = $lg($g(^CT.WDT.CDSS.RuleResultD(ResultRowId)),4)
							s RecommendResult  = $lg($g(^CT.WDT.CDSS.RuleResultD(ResultRowId)),5)
							s RecommendResultDesc=""
							if (RecommendType="检验") 
							{
								s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.LabInspectionDictD(RecommendResult)),4)
							}
							elseif(RecommendType="检查")
							{
								s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.ExamDictD(RecommendResult)),4)
							}
							elseif(RecommendType="评估表")
							{
								s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.AssBaseD(RecommendResult)),3)
							}
							elseif(RecommendType="治疗方案")
							{
								s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.TreatDictD(RecommendResult)),3)
							}
							elseif((RecommendType="确诊诊断")||(RecommendType="鉴别诊断"))
							{
								s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.DiseaseDictD(RecommendResult)),3)
							}
							elseif(RecommendType="护理处置")
							{
								s RecommendResultDesc=$LISTGET($G(^CT.WDT.CDSS.NursingDictD(RecommendResult)),4)
							}elseif(RecommendType="文献"){
								s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.DocuManageD(RecommendResult)),3) //中文文献名称
							}
							
							s TmpAss={}
							
							d TmpAss.%Set("id",ResultRowId)
							d TmpAss.%Set("NodeType",NodeType)
							d TmpAss.%Set("Sequence",Sequence)
							d TmpAss.%Set("RecommendType",RecommendType)
							d TmpAss.%Set("RecommendDesc",RecommendResultDesc)
							d ResultArray.%Push(TmpAss)
						}
					}
					elseif (NodeType="推荐治疗方案-药品")||(NodeType="推荐治疗方案-手术")
					{
						s DetailRowId = 0
						for
						{
							s DetailRowId = $o(^CT.WDT.CDSS.RuleDetailI("NodeDRIndex",NodeRowId,DetailRowId)) q:DetailRowId=""
							s Sequence  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId)),3)
							s DrugDR  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId)),4)
							s DrugUse  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId)),5)
							s DrugDRName="",DrugUseName=""
							if (NodeType="推荐治疗方案-药品") 
							{
								s DrugDRName=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugDR)),4)
								s:DrugUse'="" DrugUseName=$lg($g(^CT.WDT.CDSS.UsageDictD(DrugUse)),3)
							}
							else
							{
								s DrugDRName=$lg($g(^CT.WDT.CDSS.OperationDictD(DrugDR)),4)
								s:DrugUse'="" DrugUseName=$lg($g(^CT.WDT.CDSS.UsageDictD(DrugUse)),3)
							}
							
							s DosageMIN  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId)),6)
							s DosageMINUnit  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId)),7)
							s DosageMINUnitName=""
							s:DosageMINUnit'="" DosageMINUnitName=$lg($g(^CT.WDT.CDSS.UnitDictD(DosageMINUnit)),3)
							
							s DosageMAX  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId)),8)
							s DosageMAXUnit  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId)),9)
							s DosageMAXUnitName=""
							s:DosageMAXUnit'="" DosageMAXUnitName=$lg($g(^CT.WDT.CDSS.UnitDictD(DosageMAXUnit)),3)
							
							s Frequency  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId)),10)
							s FrequencyName=""
							s:Frequency'="" FrequencyName=$lg($g(^CT.WDT.CDSS.FrequencyDictD(Frequency)),3)
							s TmpAss={}
							d TmpAss.%Set("id",DetailRowId)
							d TmpAss.%Set("NodeType",NodeType)
							d TmpAss.%Set("Sequence",Sequence)
							d TmpAss.%Set("DrugDRName",DrugDRName)
							d TmpAss.%Set("DrugUseName",DrugUseName)
							
							d TmpAss.%Set("DosageMIN",DosageMIN)
							d TmpAss.%Set("DosageMINUnitName",DosageMINUnitName)
							d TmpAss.%Set("DosageMAX",DosageMAX)
							d TmpAss.%Set("DosageMAXUnitName",DosageMAXUnitName)
							d TmpAss.%Set("FrequencyName",FrequencyName)
							
							d ResultArray.%Push(TmpAss)
							
						}
					}
					elseif (NodeType="检查合理性")||(NodeType="检验合理性")||(NodeType="手术合理性")||(NodeType="护理合理性")||(NodeType="过敏合理性")
					{
						s RationalityRowId = 0
						for
						{
							s RationalityRowId = $o(^CT.WDT.CDSS.RuleRationalityI("NodeDRIndex",NodeRowId,RationalityRowId)) q:RationalityRowId=""
							s Sequence  = $lg($g(^CT.WDT.CDSS.RuleRationalityD(RationalityRowId)),3)
							s WarningContent  = $lg($g(^CT.WDT.CDSS.RuleRationalityD(RationalityRowId)),4)
							s TabooLevel  = $lg($g(^CT.WDT.CDSS.RuleRationalityD(RationalityRowId)),5)
							s TmpAss={}
							d TmpAss.%Set("id",RationalityRowId)
							d TmpAss.%Set("NodeType",NodeType)
							d TmpAss.%Set("Sequence",Sequence)
							d TmpAss.%Set("WarningContent",WarningContent)
							d TmpAss.%Set("TabooLevel",TabooLevel)
							
							d ResultArray.%Push(TmpAss)
						}
						
						
					}
					elseif (NodeType="手术并发症")
					{
						s ComplicationRowId = 0
						for
						{
							s ComplicationRowId = $o(^CT.WDT.CDSS.RuleComplicationI("NodeDRIndex",NodeRowId,ComplicationRowId)) q:ComplicationRowId=""
							s Sequence  = $lg($g(^CT.WDT.CDSS.RuleComplicationD(ComplicationRowId)),3)
							s ComplicationDR  = $lg($g(^CT.WDT.CDSS.RuleComplicationD(ComplicationRowId)),4)
							s ComplicationDRDesc=""
							s:ComplicationDR'="" ComplicationDRDesc=$lg($g(^CT.WDT.CDSS.DiseaseDictD(ComplicationDR)),3)
							s MainPoints  = $lg($g(^CT.WDT.CDSS.RuleComplicationD(ComplicationRowId)),5)
							s TmpAss={}
							d TmpAss.%Set("id",ComplicationRowId)
							d TmpAss.%Set("NodeType",NodeType)
							d TmpAss.%Set("Sequence",Sequence)
							d TmpAss.%Set("ComplicationDRDesc",ComplicationDRDesc)
							d TmpAss.%Set("MainPoints",MainPoints)
							d ResultArray.%Push(TmpAss)
							
						}
		
						
					}
				}
			}
			elseif(NodeTypeRowId="")&&($d(^CT.WDT.CDSS.RuleNodeI("RuleDRTypeIndex",RuleRowId,FChartNum)))
			{
				
				s NodeTypeRowId=0
				for
				{ 
					s NodeTypeRowId=$o(^CT.WDT.CDSS.RuleNodeI("RuleDRTypeIndex",RuleRowId,FChartNum,NodeTypeRowId))  q:NodeTypeRowId=""
					s NodeTypeDesc=$lg($g(^CT.WDT.CDSS.NodeTypeD(NodeTypeRowId)),3)
					
					s NodeRowId=0
					for
					{ 
						s NodeRowId=$o(^CT.WDT.CDSS.RuleNodeI("RuleDRTypeIndex",RuleRowId,FChartNum,NodeTypeRowId,NodeRowId)) q:NodeRowId=""
						if (NodeTypeDesc="推荐检验/检查")||(NodeTypeDesc="推荐评估表")||(NodeTypeDesc="推荐护理措施")||(NodeTypeDesc="推荐治疗方案")||(NodeTypeDesc="推荐确诊")
						{
							
							s ResultRowId = 0
							for
							{
								s ResultRowId = $o(^CT.WDT.CDSS.RuleResultI("NodeDRIndex",NodeRowId,ResultRowId)) q:ResultRowId=""
								s Sequence  = $lg($g(^CT.WDT.CDSS.RuleResultD(ResultRowId)),3)
								s RecommendType  = $lg($g(^CT.WDT.CDSS.RuleResultD(ResultRowId)),4)
								s RecommendResult  = $lg($g(^CT.WDT.CDSS.RuleResultD(ResultRowId)),5)
								s RecommendResultDesc=""
								if (RecommendType="检验") 
								{
									s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.LabInspectionDictD(RecommendResult)),4)
								}
								elseif(RecommendType="检查")
								{
									s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.ExamDictD(RecommendResult)),4)
								}
								elseif(RecommendType="评估表")
								{
									s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.AssBaseD(RecommendResult)),3)
								}
								elseif(RecommendType="治疗方案")
								{
									s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.TreatDictD(RecommendResult)),3)
								}
								elseif((RecommendType="确诊诊断")||(RecommendType="鉴别诊断"))
								{
									s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.DiseaseDictD(RecommendResult)),3)
								}
								elseif(RecommendType="护理处置")
								{
									s RecommendResultDesc=$LISTGET($G(^CT.WDT.CDSS.NursingDictD(RecommendResult)),4)
								}elseif(RecommendType="文献"){
									s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.DocuManageD(RecommendResult)),3) //中文文献名称
								}
								
								s TmpAss={}
								
								d TmpAss.%Set("id",ResultRowId)
								d TmpAss.%Set("NodeType",NodeTypeDesc)
								d TmpAss.%Set("Sequence",Sequence)
								d TmpAss.%Set("RecommendType",RecommendType)
								d TmpAss.%Set("RecommendDesc",RecommendResultDesc)
								d ResultArray.%Push(TmpAss)
							}
						}
						elseif (NodeTypeDesc="推荐治疗方案-药品")||(NodeTypeDesc="推荐治疗方案-手术")
						{
							s DetailRowId = 0
							for
							{
								s DetailRowId = $o(^CT.WDT.CDSS.RuleDetailI("NodeDRIndex",NodeRowId,DetailRowId)) q:DetailRowId=""
								s Sequence  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId)),3)
								s DrugDR  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId)),4)
								s DrugUse  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId)),5)
								s DrugDRName="",DrugUseName=""
								if (NodeTypeDesc="推荐治疗方案-药品") 
								{
									s DrugDRName=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugDR)),4)
									s:DrugUse'="" DrugUseName=$lg($g(^CT.WDT.CDSS.UsageDictD(DrugUse)),3)
								}
								else
								{
									s DrugDRName=$lg($g(^CT.WDT.CDSS.OperationDictD(DrugDR)),4)
									s:DrugUse'="" DrugUseName=$lg($g(^CT.WDT.CDSS.UsageDictD(DrugUse)),3)
								}
								
								s DosageMIN  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId)),6)
								s DosageMINUnit  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId)),7)
								s DosageMINUnitName=""
								s:DosageMINUnit'="" DosageMINUnitName=$lg($g(^CT.WDT.CDSS.UnitDictD(DosageMINUnit)),3)
								
								s DosageMAX  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId)),8)
								s DosageMAXUnit  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId)),9)
								s DosageMAXUnitName=""
								s:DosageMAXUnit'="" DosageMAXUnitName=$lg($g(^CT.WDT.CDSS.UnitDictD(DosageMAXUnit)),3)
								
								s Frequency  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId)),10)
								s FrequencyName=""
								s:Frequency'="" FrequencyName=$lg($g(^CT.WDT.CDSS.FrequencyDictD(Frequency)),3)
								s TmpAss={}
								d TmpAss.%Set("id",DetailRowId)
								d TmpAss.%Set("NodeType",NodeTypeDesc)
								d TmpAss.%Set("Sequence",Sequence)
								d TmpAss.%Set("DrugDRName",DrugDRName)
								d TmpAss.%Set("DrugUseName",DrugUseName)
								
								d TmpAss.%Set("DosageMIN",DosageMIN)
								d TmpAss.%Set("DosageMINUnitName",DosageMINUnitName)
								d TmpAss.%Set("DosageMAX",DosageMAX)
								d TmpAss.%Set("DosageMAXUnitName",DosageMAXUnitName)
								d TmpAss.%Set("FrequencyName",FrequencyName)
								
								d ResultArray.%Push(TmpAss)
								
							}
						}
						elseif (NodeTypeDesc="检查合理性")||(NodeTypeDesc="检验合理性")||(NodeTypeDesc="手术合理性")||(NodeTypeDesc="护理合理性")||(NodeTypeDesc="过敏合理性")
						{
							s RationalityRowId = 0
							for
							{
								s RationalityRowId = $o(^CT.WDT.CDSS.RuleRationalityI("NodeDRIndex",NodeRowId,RationalityRowId)) q:RationalityRowId=""
								s Sequence  = $lg($g(^CT.WDT.CDSS.RuleRationalityD(RationalityRowId)),3)
								s WarningContent  = $lg($g(^CT.WDT.CDSS.RuleRationalityD(RationalityRowId)),4)
								s TabooLevel  = $lg($g(^CT.WDT.CDSS.RuleRationalityD(RationalityRowId)),5)
								s TmpAss={}
								d TmpAss.%Set("id",RationalityRowId)
								d TmpAss.%Set("NodeType",NodeTypeDesc)
								d TmpAss.%Set("Sequence",Sequence)
								d TmpAss.%Set("WarningContent",WarningContent)
								d TmpAss.%Set("TabooLevel",TabooLevel)
								
								d ResultArray.%Push(TmpAss)
							}
							
							
						}
						elseif (NodeTypeDesc="手术并发症")
						{
							s ComplicationRowId = 0
							for
							{
								s ComplicationRowId = $o(^CT.WDT.CDSS.RuleComplicationI("NodeDRIndex",NodeRowId,ComplicationRowId)) q:ComplicationRowId=""
								s Sequence  = $lg($g(^CT.WDT.CDSS.RuleComplicationD(ComplicationRowId)),3)
								s ComplicationDR  = $lg($g(^CT.WDT.CDSS.RuleComplicationD(ComplicationRowId)),4)
								s ComplicationDRDesc=""
								s:ComplicationDR'="" ComplicationDRDesc=$lg($g(^CT.WDT.CDSS.DiseaseDictD(ComplicationDR)),3)
								s MainPoints  = $lg($g(^CT.WDT.CDSS.RuleComplicationD(ComplicationRowId)),5)
								s TmpAss={}
								d TmpAss.%Set("id",ComplicationRowId)
								d TmpAss.%Set("NodeType",NodeTypeDesc)
								d TmpAss.%Set("Sequence",Sequence)
								d TmpAss.%Set("ComplicationDRDesc",ComplicationDRDesc)
								d TmpAss.%Set("MainPoints",MainPoints)
								d ResultArray.%Push(TmpAss)
								
							}
			
							
						}
					}
				}
			}
			
		}
		
	}
	q ResultArray.%ToJSON()
}

/// Creator:李得原
/// CreatDate:2022-07-01
/// Description:对数组中的数据根据配置进行排序，中医、西医前后顺序
/// Table: 
/// Input: ResultArray 数组
/// Return: 排序后的数组
/// Others:w ##class(web.CDSS.MedicalRule.GetPatientRuleResult).SortRecomTreatResult([])
ClassMethod SortRecomTreatResult(ResultArray)
{
	s Result=[]
	s Res={}     //存储优先级排序后的数据{"1":[],"2":[]}
	s Map={"中医":1,"西医":0}
	s Priority=##class(web.CDSS.Config.MKBConfig).GetConfigValue("DisplayPriority")
	if Priority=""
	{
		q ResultArray
	}
	try
	{
		s PriorityJson ={}.%FromJSON(Priority)
		for PriorityIndex=1:1:PriorityJson.%Size()
		{
			s p = PriorityJson.%Get(PriorityIndex)
			d Res.%Set(PriorityIndex,[])
			s TCMFlagValue = Map.%Get(p)
			for ArrayIndex=0:1:ResultArray.%Size()-1
			{
				s Item = ResultArray.%Get(ArrayIndex)
				s TCMFlag=Item.%Get("TCMFlag")
				if TCMFlag=TCMFlagValue
				{
					d Res.%Get(PriorityIndex).%Push(Item)
				}
			}
		}
		
	}
	catch e
	{
		return ResultArray
	}
	
	for ResIndex=1:1:Res.%Size()
	{
		s TempList = Res.%Get(ResIndex)
		for TempIndex=0:1:TempList.%Size()-1
		{
			s TempItem=TempList.%Get(TempIndex)
			d Result.%Push(TempItem)
		}
		
	}
	q Result
}

/// Creator:李得原
/// CreatDate:2022-08-22
/// Description:推荐结果判断重复
/// Table: 
/// Input: ResultArray 数组
/// Return: 排序后的数组
/// Others:w ##class(web.CDSS.MedicalRule.GetPatientRuleResult).ProcessDuplicate()
ClassMethod ProcessDuplicate(RuleProvision As %String, ByRef Array, ByRef TmpObject, Extend)
{
	if (RuleProvision["sds")||(RuleProvision["SDS")
	{
		s ExtendIter=Extend.%GetIterator()
		while ExtendIter.%GetNext(.key,.value)
		{
			d TmpObject.%Set(key,value)
		}
		d Array.%Push(TmpObject)	
	}
	else
	{
		s ArrayJson = Array.%ToJSON()
		s TmpJson = TmpObject.%ToJSON()
		
		s TmpJson=$e(TmpJson,2,*-1)
		if (ArrayJson'[TmpJson)
		{
			s ExtendIter=Extend.%GetIterator()
			while ExtendIter.%GetNext(.key,.value)
			{
				d TmpObject.%Set(key,value)
			}
			d Array.%Push(TmpObject)
		}
	}
}

ClassMethod SortDrug(ByRef childArray)
{
	if childArray.%Get(0).%Get("TreatItemType")'="药品"
	{
		q
	}
	
	for DrugIndex=0:1:childArray.%Size()-1
	{
		
	}
}

/// Creator:李得原
/// CreatDate:2023-03-10
/// Description:获取主诊断推出的规则
/// Table: 
/// Input: Disease为空代表获取主诊断相关规则，有值则查询该Disease触发的规则
/// Return: 
/// Others:w ##class(web.CDSS.MedicalRule.GetPatientRuleResult).GetMainDiag("DM000756","1","鼻窦炎",)
ClassMethod GetMainDiag(PatientDR As %String, VisitID As %String, VisitType As %String, IDNO As %String, Disease As %String, ByRef DiagRuleArray, ByRef IWData)
{
	s MainDiagFlag=1
	s MainDiagDesc=""
	if PatientDR'=""
	{
		s MainDiag=""
		s DiagRowid=0
		for
		{
			s DiagRowid=$o(^WDT.CDSS.DiagnosisInfoI("PatVisDRIndex",PatientDR,VisitID,VisitType,DiagRowid))
			q:DiagRowid=""
			s MainDiagFlag=$lg($g(^WDT.CDSS.DiagnosisInfoD(DiagRowid)),13) //主诊断标识
			if MainDiagFlag=0
			{
				s MainDiag=$lg($g(^WDT.CDSS.DiagnosisInfoD(DiagRowid)),9)  //主诊断名称
				s MainDiagDesc=MainDiag
				q
			}
		}
		
		if MainDiagFlag=1  //没有主诊断
		{
			if $d(^WDT.CDSS.DiagnosisInfoI("PatVisDRTySequenceIndex",PatientDR,VisitID,VisitType))
			{
				s Seq=$o(^WDT.CDSS.DiagnosisInfoI("PatVisDRTySequenceIndex",PatientDR,VisitID,VisitType,0))
				s DiagRowid=$o(^WDT.CDSS.DiagnosisInfoI("PatVisDRTySequenceIndex",PatientDR,VisitID,VisitType,Seq,0))
				s MainDiag=$lg($g(^WDT.CDSS.DiagnosisInfoD(DiagRowid)),9)
				s MainDiagDesc=MainDiag
			}
				
		}
	}
	if Disease'=""
	{
		if '$d(^WDT.CDSS.DiagnosisInfoI("IDNODiagnosisNameIndex",IDNO,Disease))  //如果不存在此诊断
		{
			s Disease=""
		}
	}
	
	if Disease=""
	{
		s MainDiag=MainDiagDesc
	}
	else
	{
		s MainDiag=Disease
	}
	
	s IWData=""
	s PatIWRowid=0
	for
	{
		s PatIWRowid=$o(^WDT.CDSS.PatTriggerIWI("PatVisDRTypeIndex",PatientDR,VisitID,VisitType,PatIWRowid))
		q:PatIWRowid=""
		s IWRowid=$lg($g(^WDT.CDSS.PatTriggerIWD(PatIWRowid)),6)  //取诊断触发的识别词
		continue:IWRowid=""
		s IWDesc=$lg($g(^CT.WDT.CDSS.IdentifyWordsD(IWRowid)),3)
		s IWValue=$lg($g(^WDT.CDSS.PatTriggerIWD(PatIWRowid)),10)
		if IWDesc=MainDiag
		{
			s IWData(1,IWRowid)=""
		}
		
		if IWValue[MainDiag
		{
			s IWData(2,IWRowid)=""
		}
		
	}
	s Seq=""
	for
	{
		s Seq=$o(IWData(Seq))
		q:Seq=""
		
		s IWRowid=""
		for
		{	
			s IWRowid=$o(IWData(Seq,IWRowid))
			q:IWRowid=""
			
			s RealType=0
			for
			{
				s RealType=$o(^CT.WDT.CDSS.RuleIndexI("RealTypeIndex",IWRowid,RealType))
				q:RealType=""
				
				s FlowNum=""
				for
				{
					s FlowNum=$o(^CT.WDT.CDSS.RuleIndexI("RealTypeIndex",IWRowid,RealType,FlowNum))
					q:FlowNum=""
					
					s RuleRowid=0
					for
					{
						s RuleRowid=$o(^CT.WDT.CDSS.RuleIndexI("RealTypeIndex",IWRowid,RealType,FlowNum,RuleRowid))
						q:RuleRowid=""
						s DiagRuleArray(Seq,RuleRowid,RealType,FlowNum)=""
					}
				}
				
			}
		}
		
	}
	q MainDiagDesc
}

/// Creator:李得原
/// CreatDate:2023-03-10
/// Description:合并多个数组
/// Table: 
/// Input: 数组个数不受限制
/// Return: 
/// Others:w ##class(web.CDSS.MedicalRule.GetPatientRuleResult).ConcatArrays(a,b,c)
ClassMethod ConcatArrays(pArgs...) As %DynamicArray
{
    set outArray = []
    for i=1:1:pArgs {
        set arg = pArgs(i)
        if ($IsObject(arg) && arg.%IsA("%DynamicArray")) {
            set iter = arg.%GetIterator()
            while iter.%GetNext(.key, .value) {
                do outArray.%Push(value)
            }
        } else {
            do outArray.%Push(arg)
        }
    }
    return outArray
}

/// Creator:李得原
/// CreatDate:2023-03-24
/// Description: 数组按元素字段排序
/// Table: 
/// Input: 
/// Return: 
/// Others:w ##class(web.CDSS.MedicalRule.GetPatientRuleResult).SortAssessByDegree()
ClassMethod SortArrayByField(Array As %DynamicArray, FieldName As %String) As %DynamicArray
{
	//q Array
	s Score=""
	//s DegreeMap={"最高":1,"较高":2,"中等":3,"最低":4}
	for ItemIndex=0:1:Array.%Size()-1
	{
		s Item=Array.%Get(ItemIndex)
		s Priority=Item.%Get(FieldName)
		s:Priority="" Priority=4
		s Score(Priority,ItemIndex+1)=Item	
	}
	
	s Result = []
	s Num=""
	for
	{
		s Num=$o(Score(Num))
		q:Num=""
		s IndexNum=0
		for
		{
			s IndexNum=$o(Score(Num,IndexNum))
			q:IndexNum=""
			
			d Result.%Push(Score(Num,IndexNum))
		}
	}
	q Result
}

/// Creator:李得原
/// CreatDate:2023-03-28
/// Description: 根据触发识别词推荐文献
/// Table: 
/// Input: 
/// Return: 
/// Others:w ##class(web.CDSS.MedicalRule.GetPatientRuleResult).GetIWDoc("DM000022","1",.DocArray)
ClassMethod GetIWDoc(PatientDR As %String, VisitID As %String, VisitType As %String, ByRef DocArray, ByRef IWData)
{
	s DocRowidArray=""
	s IWRowid=0
	for
	{
		s IWRowid=$o(^WDT.CDSS.PatTriggerIWI("PatVisTypeIWIndex",PatientDR,VisitID,VisitType,IWRowid))
		q:IWRowid=""
				
		s DocIWRowId = 0
		for
		{
			s DocIWRowId = $o(^CT.WDT.CDSS.DocuJoinDiseaseI("IWordsDRIndex",IWRowid,DocIWRowId)) q:DocIWRowId=""
			s DocuDR = $lg($g(^CT.WDT.CDSS.DocuJoinDiseaseD(DocIWRowId)),2)
			s:DocuDR'="" DocuState = $lg($g(^CT.WDT.CDSS.DocuManageD(DocuDR)),12) //文献状态
			if (DocuState'="上线")&(DocuState'="审核中")
			{
				continue
			}
			s:DocuDR'="" DocuMonth = $lg($g(^CT.WDT.CDSS.DocuManageD(DocuDR)),10) //文献日期
			s:DocuDR'="" DocuInstitution = $lg($g(^CT.WDT.CDSS.DocuManageD(DocuDR)),8)  //发布机构id
			s:DocuInstitution'="" AgencyPriority=$lg($g(^CT.WDT.CDSS.DocuAgencyD(DocuInstitution)),4)  //发布机构等级
			s DocuMonth=$g(DocuMonth,"1900-01")
			if DocuMonth=""
			{
				s DocuMonth="1900-01"
			}
			s AgencyPriority=$g(AgencyPriority,4)
			if AgencyPriority=""
			{
				s AgencyPriority=4
			}
			if $d(IWData("1",IWRowid))
			{
				s DocRowidArray("1",DocuMonth,AgencyPriority,DocIWRowId)=""	
			}
			elseif $d(IWData("2",IWRowid))
			{
				s DocRowidArray("2",DocuMonth,AgencyPriority,DocIWRowId)=""	
			}
			else
			{
				s DocRowidArray("3",DocuMonth,AgencyPriority,DocIWRowId)=""	
			}
		}
		
		s DocWRowid=0
		for
		{
			s DocWRowid= $o(^CT.WDT.CDSS.DocuJoinDiseaseI("WordsDRIndex",IWRowid,DocWRowid)) q:DocWRowid=""
			s DocuDR = $lg($g(^CT.WDT.CDSS.DocuJoinDiseaseD(DocWRowid)),2)
			s:DocuDR'="" DocuState = $lg($g(^CT.WDT.CDSS.DocuManageD(DocuDR)),12) //文献状态
			if (DocuState'="上线")&(DocuState'="审核中")
			{
				continue
			}
			s:DocuDR'="" DocuMonth = $lg($g(^CT.WDT.CDSS.DocuManageD(DocuDR)),10) //文献日期
			s:DocuDR'="" DocuInstitution = $lg($g(^CT.WDT.CDSS.DocuManageD(DocuDR)),8)  //发布机构id
			s:DocuInstitution'="" AgencyPriority=$lg($g(^CT.WDT.CDSS.DocuAgencyD(DocuInstitution)),4)  //发布机构等级
			s DocuMonth=$g(DocuMonth,"1900-01")
			if DocuMonth=""
			{
				s DocuMonth="1900-01"
			}
			s AgencyPriority=$g(AgencyPriority,4)
			if AgencyPriority=""
			{
				s AgencyPriority=4
			}
			if $d(IWData("1",IWRowid))
			{
				s DocRowidArray("1",DocuMonth,AgencyPriority,DocWRowid)=""	
			}
			elseif $d(IWData("2",IWRowid))
			{
				s DocRowidArray("2",DocuMonth,AgencyPriority,DocWRowid)=""	
			}
			else
			{
				s DocRowidArray("3",DocuMonth,AgencyPriority,DocWRowid)=""	
			}
		}
	}
	
	s Seq=0
	for
	{
		s Seq=$o(DocRowidArray(Seq))
		q:Seq=""
		s DocDate=""
		for
		{
			s DocDate=$o(DocRowidArray(Seq,DocDate),-1)
			q:DocDate=""
			
			s Priority=0
			for
			{
				s Priority=$o(DocRowidArray(Seq,DocDate,Priority))
				q:Priority=""
				
				s DocRowid=0
				for
				{
					s DocRowid=$o(DocRowidArray(Seq,DocDate,Priority,DocRowid))
					q:DocRowid=""
					s DocuDR = $lg($g(^CT.WDT.CDSS.DocuJoinDiseaseD(DocRowid)),2)
					s DocuDesc ="",DocuPath="",DocuType="",DocuMonth=""
					
					s:DocuDR'="" DocuDesc = $lg($g(^CT.WDT.CDSS.DocuManageD(DocuDR)),3)
					s:DocuDR'="" DocuPath = $lg($g(^CT.WDT.CDSS.DocuManageD(DocuDR)),5)
					s:DocuDR'="" DocuType = $lg($g(^CT.WDT.CDSS.DocuManageD(DocuDR)),7)
					s:DocuDR'="" DocuMonth = $lg($g(^CT.WDT.CDSS.DocuManageD(DocuDR)),10)
					continue:DocuPath=""
					s TmpAss={}
					d TmpAss.%Set("ItemName",DocuDesc)
					d TmpAss.%Set("ItemID",DocuDR)
					
					s DocuPathList=[]
					for j=1:1:$l(DocuPath,"^")
					{
						s Doc=$p(DocuPath,"^",j)
						continue:Doc=""
						d DocuPathList.%Push(Doc)
					}
					d TmpAss.%Set("ItemPath",DocuPathList)
					d TmpAss.%Set("ItemType",DocuType)
					d TmpAss.%Set("ItemDate",DocuMonth)
					
					s Tmp={}
					d ..ProcessDuplicate("",.DocArray,.TmpAss,Tmp)
								
				}
			}
		}
		
	}
	q ""
}

/// Creator:李得原
/// CreatDate:2023-04-10
/// Description:获取项目对照名称
/// Table: 
/// Input: 
/// Return:
/// Others:w ##class(web.CDSS.MedicalRule.GetPatientRuleResult).GetProjectDataName("空腹血糖","检验","空腹ItemDesc")
ClassMethod GetProjectDataName(Desc As %String, Type As %String, ItemDesc)
{
	s Result={}
	s ProjectData=##class(web.CDSS.IMP.ContrastDict).GetAllProjectDataName(Desc,Type,"","","1")  //1 返回json格式
	if (ProjectData="[]")||(ProjectData="")
	{
		d Result.%Set("ProjectName",ItemDesc)
		d Result.%Set("MatchCode",[])
	}
	else
	{
		s ProjectJson=[].%FromJSON(ProjectData)
		if ProjectJson.%Size()=1
		{
			s ItemName=ProjectJson.%Get(0).%Get("ItemName")
			d Result.%Set("ProjectName",ItemName)
			d Result.%Set("MatchCode",ProjectJson)
		}
		else
		{
			d Result.%Set("ProjectName",ItemDesc)
			d Result.%Set("MatchCode",ProjectJson)
		}
	}
	q Result
}

/// Creator:李得原
/// CreatDate:2023-05-06
/// Description:提供根据诊断推荐检验检查的接口
/// Table: 
/// Input: 
/// Return:
/// Others:w ##class(web.CDSS.MedicalRule.GetPatientRuleResult).GetPatientLabExam("DM000821^DM000821^1^住院^15^范文凯^1^信息科^Y^鼻窦炎")
ClassMethod GetPatientLabExam(PatientInfo As %String)
{
	s Result=[]
	s IDNO=$p(PatientInfo,"^",1)
	if $p(PatientInfo,"^",10)'=""
	{
		s Diag=$p(PatientInfo,"^",10)
		s Diag=##class(web.CDSS.IMP.ContrastDict).GetDiectName(Diag,"","诊断字典")
		for DiagIndex=1:1:$l(Diag,"&%")
		{
			s DiagItem=$p(Diag,"&%",DiagIndex)
			continue:DiagItem=""
			s PatientInfo=$p(PatientInfo,"^",1,*-1)_"^"_DiagItem
			d ..SaveSatisfyRuleResult(PatientInfo,"")
			s Rowid=$o(^WDT.CDSS.PatientRecomInfoI("UniqueIDNOIndex",IDNO,"推荐检验检查",0))
			s InterfaceReturn=$lg($g(^WDT.CDSS.PatientRecomInfoD(Rowid)),7)
			s InterfaceJson=[].%FromJSON(InterfaceReturn)
			s DataList=InterfaceJson.%Get(0).%Get("InterfaceValue")
			for InterfaceIndex=0:1:DataList.%Size()-1
			{
				s DataItem=DataList.%Get(InterfaceIndex)
				d Result.%Push(DataItem)
			}
		}
		
	}
	else
	{
		d ..SaveSatisfyRuleResult(PatientInfo, "sds")
		s Rowid=$o(^WDT.CDSS.PatientRecomInfoI("UniqueIDNOIndex",IDNO,"推荐检验检查",0))
		s InterfaceReturn=$lg($g(^WDT.CDSS.PatientRecomInfoD(Rowid)),7)
		s InterfaceJson=[].%FromJSON(InterfaceReturn)
		s Result=InterfaceJson.%Get(0).%Get("InterfaceValue")
	}

	q Result.%ToJSON()
}

}
