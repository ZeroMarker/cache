/// 给单病种提供推荐结果数据
Class web.CDSS.MiddlePlatform.SDSRelated Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// CreatDate:2022-08-22
/// Description:推荐结果判断重复
/// Table: 
/// Input: ResultArray 数组
/// Return: 排序后的数组
/// Others:w ##class(web.CDSS.MiddlePlatform.SDSRelated).ProcessDuplicate()
ClassMethod ProcessDuplicate(ByRef Array, ByRef TmpObject, Extend)
{
	s ExtendIter=Extend.%GetIterator()
	while ExtendIter.%GetNext(.key,.value)
	{
		d TmpObject.%Set(key,value)
	}
	d Array.%Push(TmpObject)
}

// w ##class(web.CDSS.MiddlePlatform.SDSRelated).GetSDSRuleResult("中高危风险患者预防静脉血栓栓塞症")

ClassMethod GetSDSRuleResult(RuleDesc As %String) As %String
{
	k RulesArray
	k RuleIDArray
	s Result={}
	s RuleDesc=$zstrip(RuleDesc,"<>W")
	
	if (RuleDesc'="")&&(RuleDesc'=$c(0))
	{
		if '$d(^CT.WDT.CDSS.RuleDictI("DescIndex", " "_$zconvert(RuleDesc,"U")))
		{
			q Result.%ToJSON()
		}
		s RuleRowid=""
		for
		{
			s RuleRowid = $o(^CT.WDT.CDSS.RuleDictI("DescIndex", " "_$zconvert(RuleDesc,"U"),RuleRowid))
			q:RuleRowid=""
			s RulesArray(RuleRowid)=""
		}
		
		
	}
	else
	{
		s RuleRowid=0
		for
		{
			s RuleRowid=$o(^CT.WDT.CDSS.RuleDictD(RuleRowid)) q:RuleRowid=""
			s ProVision =$lg($g(^CT.WDT.CDSS.RuleDictD(RuleRowid)),14)
			if (ProVision["单病种")||(ProVision["sds")||(ProVision["SDS")
			{
				s RulesArray(RuleRowid)=""
			}
		}
	}
	
	s RuleRowid=0
	for
	{
		s RuleRowid=$o(RulesArray(RuleRowid))
		q:RuleRowid=""
		
		s RuleDesc =$lg($g(^CT.WDT.CDSS.RuleDictD(RuleRowid)),3)
		s FinalType = ""
		for
		{
			s FinalType = $o(^CDSSMatchRule("sds",FinalType)) q:FinalType=""
			if '$d(^CDSSMatchRule("sds",FinalType,RuleRowid))
			{
				continue
			}
			
			s RecomType= ""
			for
			{
				s RecomType=$o(^CDSSMatchRule("sds",FinalType,RuleRowid,RecomType)) q:RecomType=""
				s FlowNum =0
				for
				{
					s FlowNum=$o(^CDSSMatchRule("sds",FinalType,RuleRowid,RecomType,FlowNum)) q:FlowNum=""
					s RuleIDArray(RuleRowid,RecomType,FlowNum)=""
				}
			}
		}
	}
	
	s RecomTypeMap={"推荐鉴别诊断":"RecommendDifferDiag","推荐检验检查":"RecommendLabExam","推荐评估表":"RecommendAssess","推荐临床指征评估表":"RecommendAssess","推荐科室关联评估表":"RecommendAssess","推荐护理处置":"RecommendNursing","推荐护理措施":"RecommendNursingTreat", "推荐治疗方案":"AssistTreat","推荐治疗方案-药品":"AssistTreat","推荐治疗方案-手术":"AssistTreat","推荐确诊":"RecomDiag","检查合理性":"LabExamWarning","检验合理性":"LabExamWarning","手术合理性":"OperationWarning","手术并发症":"OperationComplication","护理/处置合理性":"NursingWarning","输血合理性":"BloodWarning","药品合理性":"DrugWarning","出院指导":"OutHospital","诊断合理性":"DiseaseWarning","推荐治疗方案-处置":"AssistTreat"}
	s ResultArray={} //汇总推荐信息
	//确诊诊断 鉴别诊断 推荐相关文献 推荐检验检查 推荐护理措施	推荐评估量表	推荐治疗方案	疾病预警	检验检查预警	手术预警	护理预警	过敏史预警	输血预警	手术并发症   药品预警	院方预警阻断	出院指导
	
	// 取符合条件的数据
	s RuleRowId=""
	for
	{
		s RuleRowId=$o(RuleIDArray(RuleRowId)) q:RuleRowId=""
		s RuleDesc=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowId)),3)  //规则名称
		s ProVision = $LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowId)),14)  //录入来源
		s:ProVision="" ProVision="dhcc-西医"
		s Result = {}
		s DiagArray=[],RDiagArray=[],DiffDiagArray=[],DocArray=[],LabExamArray=[],NursArray=[],AssessArray=[],TreatArray=[],DiseWArray=[],LabExamWArray=[],OperaWArray=[],NursWArray=[],AllergyWArray=[],BloodWArray=[],OperCompArray=[],DrugWArray=[],HospWarnStopArray=[],DischargeGArray=[],MedCalulateArray=[]
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
					if ($d(^CT.WDT.CDSS.RuleNodeI("TypeChartIndex",RuleRowId,RuleTypeDR,FChartNum)))
					{
						s NodeRowId=0
						for
						{ 
							s NodeRowId=$o(^CT.WDT.CDSS.RuleNodeI("TypeChartIndex",RuleRowId,RuleTypeDR,FChartNum,NodeRowId)) q:NodeRowId=""
							s NodeType=$lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowId)),5)	 //节点类型
							s NodeTypeDesc=""
							s:NodeType'="" NodeTypeDesc=$lg($g(^CT.WDT.CDSS.NodeTypeD(NodeType)),3) //节点类型描述
							
							continue:(NodeTypeDesc'="推荐治疗方案-药品")&(NodeTypeDesc'="推荐治疗方案-手术")&(NodeTypeDesc'="推荐治疗方案-治法")&(NodeTypeDesc'="推荐治疗方案-处置")
						
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
									
									s ProjectDataName =  ##class(web.CDSS.IMP.ContrastDict).GetProjectDataName(DrugDRName,"药品","1")
									s ProjectCode =$p(ProjectDataName,"&%",1)
									s ProjectName=$p(ProjectDataName,"&%",2)
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
									
									s ProjectDataName =  ##class(web.CDSS.IMP.ContrastDict).GetProjectDataName(DrugUseName,"手术","1")
									s ProjectCode =$p(ProjectDataName,"&%",1)
									s ProjectName=$p(ProjectDataName,"&%",2)
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
									s TreatmentName=$lg($g(^CT.WDT.CDSS.TCMTreatmentD(DrugDR)),3)
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
														s ProjectDataName =  ##class(web.CDSS.IMP.ContrastDict).GetProjectDataName(MedicineName,"中药","1")
														s TmpAssC={}
														d TmpAssC.%Set("TreatItemType","方剂组成")
														d TmpAssC.%Set("TreatItemName",MedicineName)
														d TmpAssC.%Set("ProjectName",ProjectDataName)
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
											if (DrugUse1'="")
											{
												if (DrugUse1="腧穴")
												{
													s DrugDRName1=$lg($g(^CT.WDT.CDSS.TCMAcupointsD(DrugDR1)),3)
												}
												elseif (DrugUse1="中药")
												{
													s DrugDRName1=$lg($g(^CT.WDT.CDSS.TCMMedicineD(DrugDR1)),3)
												}
												elseif (DrugUse1="药物")
												{
													s DrugDRName1=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugDR1)),4)
												}
												
											}
											s Remarks1  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId1)),11)
											s TmpAssC={}
											d TmpAssC.%Set("TreatItemType",DrugUse1)
											d TmpAssC.%Set("TreatItemName",DrugDRName1)
											d childArray1.%Push(TmpAssC)

										}
									}
									s TmpAssC={}
									d TmpAssC.%Set("ItemID",DrugDR)
									d TmpAssC.%Set("TreatItemType","处置")
									d TmpAssC.%Set("TreatItemName",NursingName)
									d TmpAssC.%Set("SourceFlag",SourceFlag)
									d:childArray1'=[] TmpAssC.%Set("children",childArray1)
									d childArray.%Push(TmpAssC)

								}
								//保存患者触发规则数据统计
								
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
						continue:NodeTypeDesc="开始"
						continue:NodeTypeDesc="结束"
						continue:NodeTypeDesc["条件"
						continue:NodeTypeDesc["基本"

						s FinalType=RecomTypeMap.%Get(NodeTypeDesc)
						
						s IWRowid=$g(^CDSSMatchRule(ProVision, FinalType, RuleRowId, RuleTypeDR,FChartNum))
						if IWRowid=""
						{
							s NoCondition=1
						}
						else
						{
							s NoCondition=0
						}
						
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
									s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.LabInspectionDictD(RecommendResult)),4)
									s ProjectDataName =  ##class(web.CDSS.IMP.ContrastDict).GetProjectDataName(RecommendResultDesc,"检验","1")
									s ProjectCode =$p(ProjectDataName,"&%",1)
									s ProjectName=$p(ProjectDataName,"&%",2)
									s basedr=##class(web.CDSS.CMKB.TermBase).GetIdByDesc("检验")
									
									s TmpAss={}
									d TmpAss.%Set("ItemName",RecommendResultDesc)
									d TmpAss.%Set("ItemID",RecommendResult)
									d TmpAss.%Set("ItemType",basedr)
									d TmpAss.%Set("ProjectName",ProjectName)  
									d TmpAss.%Set("MatchCode",ProjectCode)
									d TmpAss.%Set("SourceFlag",SourceFlag)
									d TmpAss.%Set("NoCondition",NoCondition)
									
									s Tmp={}
									d Tmp.%Set("CureId",ResultRowId)
									d Tmp.%Set("ItemDesc",Remarks)
									d Tmp.%Set("NodeId",NodeRowId_"|"_RecommendResult)
									d ..ProcessDuplicate(.LabExamArray,.TmpAss,Tmp)
	
								
								}
								elseif(RecommendType="检验医嘱")
								{
									s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.LabOrdersDictD(RecommendResult)),3)
									s ProjectDataName =  ##class(web.CDSS.IMP.ContrastDict).GetProjectDataName(RecommendResultDesc,"检验医嘱","1")
									s ProjectCode =$p(ProjectDataName,"&%",1)
									s ProjectName=$p(ProjectDataName,"&%",2)
									s basedr=##class(web.CDSS.CMKB.TermBase).GetIdByDesc("检验")
									
									s TmpAss={}
									d TmpAss.%Set("ItemName",RecommendResultDesc)
									d TmpAss.%Set("ItemID",RecommendResult)
									
									d TmpAss.%Set("ItemType",basedr)
									d TmpAss.%Set("ProjectName",ProjectName)  
									d TmpAss.%Set("MatchCode",ProjectCode)
									d TmpAss.%Set("SourceFlag",SourceFlag)
									d TmpAss.%Set("NoCondition",NoCondition)
									
									s Tmp={}
									d Tmp.%Set("CureId",ResultRowId)
									d Tmp.%Set("ItemDesc",Remarks)
									d Tmp.%Set("NodeId",NodeRowId_"|"_RecommendResult)
									d ..ProcessDuplicate(.LabExamArray,.TmpAss,Tmp)
								}
								elseif(RecommendType="检查")
								{
									s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.ExamDictD(RecommendResult)),4)
									s ProjectDataName =  ##class(web.CDSS.IMP.ContrastDict).GetProjectDataName(RecommendResultDesc,"检查","1")
									s ProjectCode =$p(ProjectDataName,"&%",1)
									s ProjectName=$p(ProjectDataName,"&%",2)
									s basedr=##class(web.CDSS.CMKB.TermBase).GetIdByDesc("检查")
									
									s TmpAss={}
									d TmpAss.%Set("ItemName",RecommendResultDesc)
									d TmpAss.%Set("ItemID",RecommendResult)
									
									d TmpAss.%Set("ItemType",basedr)
									d TmpAss.%Set("ProjectName",ProjectName)  
									d TmpAss.%Set("MatchCode",ProjectCode)
									d TmpAss.%Set("SourceFlag",SourceFlag)
									d TmpAss.%Set("NoCondition",NoCondition)
									
									s Tmp={}
									d Tmp.%Set("CureId",ResultRowId)
									d Tmp.%Set("ItemDesc",Remarks)
									d Tmp.%Set("NodeId",NodeRowId_"|"_RecommendResult)
									d ..ProcessDuplicate(.LabExamArray,.TmpAss,Tmp)
								}
								elseif(RecommendType="评估表")
								{
									s AccessOn = ##class(web.DHCBL.MKB.MKBConfig).GetConfigValue("AccessmentOn")
									continue:AccessOn=0
									s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.AssBaseD(RecommendResult)),3)
									continue:RecommendResultDesc=""
									s MKBABNote=$lg($g(^CT.WDT.CDSS.AssBaseD(RecommendResult)),4)
									s MKBABType=$lg($g(^CT.WDT.CDSS.AssBaseD(RecommendResult)),4)
									s AssBIRowid=$o(^CT.WDT.CDSS.AssBasicInfoI("AssIndex",RecommendResult,0))
									if AssBIRowid'=""
									{
										s BaseTable=$lg($g(^CT.WDT.CDSS.AssBasicInfoD(AssBIRowid)),20)
									}
									else
									{
										s BaseTable = 1
									}
									
									if BaseTable=1 
									{
										s BaseTable=0
									}
									else
									{
										s BaseTable=1
									}
									
									if (MKBABType="医学计算器")
									{
										s TmpAss={}
										d TmpAss.%Set("ItemName",RecommendResultDesc)
										d TmpAss.%Set("ItemID",RecommendResult)
										d TmpAss.%Set("SourceFlag",SourceFlag)
										d TmpAss.%Set("ItemType","百科")

										s Tmp={}
										d Tmp.%Set("CureId",ResultRowId)
										d Tmp.%Set("ItemDesc",Remarks)
										d Tmp.%Set("NodeId",NodeRowId_"|"_RecommendResult)
										d Tmp.%Set("BaseTable",BaseTable)
										d ..ProcessDuplicate(.MedCalulateArray,.TmpAss,Tmp)
									}
									else
									{
										s TmpAss={}
										d TmpAss.%Set("ItemName",RecommendResultDesc)
										d TmpAss.%Set("ItemID",RecommendResult)
										d TmpAss.%Set("ItemType","评估表")
										d TmpAss.%Set("SourceFlag",SourceFlag)
										d TmpAss.%Set("NoCondition",NoCondition)
									
										s Tmp={}
										d Tmp.%Set("CureId",ResultRowId)
										d Tmp.%Set("ItemDesc",Remarks)
										d Tmp.%Set("NodeId",NodeRowId_"|"_RecommendResult)
										d Tmp.%Set("BaseTable",BaseTable)
										d ..ProcessDuplicate(.AssessArray,.TmpAss,Tmp)
										
									}
							
								}
								elseif(RecommendType="辅助计算")
								{
									s AccessOn = ##class(web.DHCBL.MKB.MKBConfig).GetConfigValue("AccessmentOn")
									continue:AccessOn=0
									s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.TermD(RecommendResult)),3)
									s AssBIRowid=$o(^CT.WDT.CDSS.AssBasicInfoI("AssIndex",RecommendResult,0))
									if AssBIRowid'=""
									{
										s BaseTable=$lg($g(^CT.WDT.CDSS.AssBasicInfoD(AssBIRowid)),20)
									}
									else
									{
										s BaseTable = 1
									}
									if BaseTable=1 
									{
										s BaseTable=0
									}
									else
									{
										s BaseTable=1
									}
									s TmpAss={}
									d TmpAss.%Set("ItemName",RecommendResultDesc)
									d TmpAss.%Set("ItemID",RecommendResult)
									d TmpAss.%Set("SourceFlag",SourceFlag)
									d TmpAss.%Set("NoCondition",NoCondition)
									
									s Tmp={}
									d Tmp.%Set("CureId",ResultRowId)
									d Tmp.%Set("ItemDesc",Remarks)
									d Tmp.%Set("NodeId",NodeRowId_"|"_RecommendResult)
									d Tmp.%Set("BaseTable",BaseTable)
									d ..ProcessDuplicate(.MedCalulateArray,.TmpAss,Tmp)
								
								}
								elseif(RecommendType="治疗方案")
								{
									s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.TreatDictD(RecommendResult)),3)
									//s Remarks=$lg($g(^CT.WDT.CDSS.TreatDictD(RecommendResult)),7)
									s TreatSource  = $lg($g(^CT.WDT.CDSS.RuleResultD(ResultRowId)),8)
								    s SourceImg  = $lg($g(^CT.WDT.CDSS.RuleResultD(ResultRowId)),9)
								    s RuleBasisDR = $lg($g(^CT.WDT.CDSS.RuleResultD(ResultRowId)),10)
								    s SourceFlag=0									
									if (RuleBasisDR'="")||(SourceImg'="")
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
									d TmpAss.%Set("NoCondition",NoCondition)
									
									//判断是否是中医
									s:ProVision["中医" tcmFlag=1
									s:ProVision'["中医" tcmFlag=0
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
									d ..ProcessDuplicate(.TreatArray,.TmpAss,Tmp)
								}
								//规则里面没有确诊诊断，只有推荐确诊
								elseif(RecommendType="确诊诊断")
								{
									s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.DiseaseDictD(RecommendResult)),3)
									
									s ProjectDataName =  ##class(web.CDSS.IMP.ContrastDict).GetProjectDataName(RecommendResultDesc,"诊断","1")
									s ProjectCode =$p(ProjectDataName,"&%",1)
									s ProjectName=$p(ProjectDataName,"&%",2)
									
									s TmpAss={}
									d TmpAss.%Set("ItemName",RecommendResultDesc)
									d TmpAss.%Set("ItemID",RecommendResult)
									
									d TmpAss.%Set("ProjectName",ProjectName)  
									d TmpAss.%Set("MatchCode",ProjectCode)
									d TmpAss.%Set("SourceFlag",SourceFlag)
									d TmpAss.%Set("NoCondition",NoCondition)
									
									s Tmp={}
									d Tmp.%Set("CureId",ResultRowId)
									d Tmp.%Set("ItemDesc",Remarks)
									d Tmp.%Set("NodeId",NodeRowId_"|"_RecommendResult)
									d ..ProcessDuplicate(.RDiagArray,.TmpAss,Tmp)
									
								}
								elseif(RecommendType="鉴别诊断")
								{
									s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.DiseaseDictD(RecommendResult)),3)
									s TmpAss={}
									d TmpAss.%Set("ItemName",RecommendResultDesc)
									d TmpAss.%Set("ItemID",RecommendResult)
									d TmpAss.%Set("SourceFlag",SourceFlag)
									d TmpAss.%Set("NoCondition",NoCondition)
									
									s Tmp={}
									d Tmp.%Set("CureId",ResultRowId)
									d Tmp.%Set("ItemDesc",Remarks)
									d Tmp.%Set("NodeId",NodeRowId_"|"_RecommendResult)
									d ..ProcessDuplicate(.DiffDiagArray,.TmpAss,Tmp)
								}
								elseif(RecommendType="护理处置")
								{
									s RecommendResultDesc=$LISTGET($G(^CT.WDT.CDSS.NursingDictD(RecommendResult)),4)
									s TmpAss={}
									d TmpAss.%Set("ItemName",RecommendResultDesc)
									d TmpAss.%Set("ItemID",RecommendResult)
									d TmpAss.%Set("SourceFlag",SourceFlag)
									d TmpAss.%Set("NoCondition",NoCondition)
									
									s Tmp={}
									d Tmp.%Set("CureId",ResultRowId)
									d Tmp.%Set("ItemDesc",Remarks)
									d Tmp.%Set("NodeId",NodeRowId_"|"_RecommendResult)
									d ..ProcessDuplicate(.NursArray,.TmpAss,Tmp)
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
								elseif(RecommendType="出院指导"){
									s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.DischargeGuideD(RecommendResult)),2)
									s TmpAss={}
									d TmpAss.%Set("ItemName",RecommendResultDesc)
									d TmpAss.%Set("ItemID",RecommendResult)
									d TmpAss.%Set("SourceFlag",SourceFlag)
									d TmpAss.%Set("NoCondition",NoCondition)
									
									s Tmp={}
									s Remarks=##class(web.CDSS.CMKB.DGuideDetail).GetDetail(RecommendResult)
									d Tmp.%Set("CureId",ResultRowId)
									d Tmp.%Set("ItemDesc",Remarks)
									d Tmp.%Set("NodeId",NodeRowId_"|"_RecommendResult)
									d ..ProcessDuplicate(.DischargeGArray,.TmpAss,Tmp)
								}
								//保存患者触发规则数据统计
								
							}
							
						}
						
						//取预警数据
						if ($d(^CT.WDT.CDSS.RuleRationalityI("NodeDRIndex",NodeRowId)))
						{	
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
										s ValueLen=$l(PFiledValueStr,"&")
										
										for iValue=1:1:ValueLen
										{
											s Value=$p(PFiledValueStr,"&",iValue)
											if (Value'="")
											{
												s:OrderStr'="" OrderStr=OrderStr_Value_"[^]"
												s:OrderStr="" OrderStr="[^]"_Value_"[^]"
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
									s TmpAss={}
									d TmpAss.%Set("RiskLevel",TabooLevel)
									d TmpAss.%Set("WarningTip",WarningContent)
									d TmpAss.%Set("AlertLevel",HospWarnStopFlag)
									d TmpAss.%Set("SourceFlag",SourceFlag)
									d TmpAss.%Set("NoCondition",NoCondition)
									
									s Tmp={}
									d Tmp.%Set("OrderStr",OrderStr)
									d Tmp.%Set("NodeId",NodeRowId)
									d ..ProcessDuplicate(.HospWarnStopArray,.TmpAss,Tmp)	
									
								}
								
								
								if (NodeTypeDesc="检查合理性")||(NodeTypeDesc="检验合理性")
								{
									s TmpAss={}
									d TmpAss.%Set("RiskLevel",TabooLevel)
									d TmpAss.%Set("WarningTip",WarningContent)
									d TmpAss.%Set("AlertLevel",HospWarnStopFlag)
									d TmpAss.%Set("SourceFlag",SourceFlag)
									d TmpAss.%Set("NoCondition",NoCondition)
									
									s Tmp={}
									d Tmp.%Set("OrderStr",OrderStr)
									d Tmp.%Set("NodeId",NodeRowId_"|"_RationalityRowId)
									d ..ProcessDuplicate(.LabExamWArray,.TmpAss,Tmp)
										
								}
								elseif(NodeTypeDesc="手术合理性")
								{
									s TmpAss={}
									d TmpAss.%Set("RiskLevel",TabooLevel)
									d TmpAss.%Set("WarningTip",WarningContent)
									d TmpAss.%Set("AlertLevel",HospWarnStopFlag)
									d TmpAss.%Set("SourceFlag",SourceFlag)
									d TmpAss.%Set("NoCondition",NoCondition)
									
									s Tmp={}
									d Tmp.%Set("OrderStr",OrderStr)
									d Tmp.%Set("NodeId",NodeRowId_"|"_RationalityRowId)
									d ..ProcessDuplicate(.OperaWArray,.TmpAss,Tmp)
								}
								elseif(NodeTypeDesc="护理/处置合理性")
								{
									s TmpAss={}
									d TmpAss.%Set("RiskLevel",TabooLevel)
									d TmpAss.%Set("WarningTip",WarningContent)
									d TmpAss.%Set("AlertLevel",HospWarnStopFlag)
									d TmpAss.%Set("SourceFlag",SourceFlag)	
									d TmpAss.%Set("NoCondition",NoCondition)
									
									s Tmp={}
									d Tmp.%Set("OrderStr",OrderStr)
									d Tmp.%Set("NodeId",NodeRowId_"|"_RationalityRowId)
									d ..ProcessDuplicate(.NursWArray,.TmpAss,Tmp)
								}
								elseif(NodeTypeDesc="过敏合理性")
								{
									s TmpAss={}
									d TmpAss.%Set("RiskLevel",TabooLevel)
									d TmpAss.%Set("WarningTip",WarningContent)
									d TmpAss.%Set("AlertLevel",HospWarnStopFlag)
									d TmpAss.%Set("SourceFlag",SourceFlag)	
									d TmpAss.%Set("NoCondition",NoCondition)
									
									s Tmp={}
									d Tmp.%Set("OrderStr",OrderStr)
									d Tmp.%Set("NodeId",NodeRowId_"|"_RationalityRowId)
									d ..ProcessDuplicate(.AllergyWArray,.TmpAss,Tmp)
								}
								elseif(NodeTypeDesc="输血合理性")
								{
									s TmpAss={}
									d TmpAss.%Set("RiskLevel",TabooLevel)
									d TmpAss.%Set("WarningTip",WarningContent)
									d TmpAss.%Set("AlertLevel",HospWarnStopFlag)
									d TmpAss.%Set("SourceFlag",SourceFlag)
									d TmpAss.%Set("NoCondition",NoCondition)
									
									s Tmp={}
									d Tmp.%Set("OrderStr",OrderStr)
									d Tmp.%Set("NodeId",NodeRowId_"|"_RationalityRowId)
									d ..ProcessDuplicate(.BloodWArray,.TmpAss,Tmp)
								}
								elseif(NodeTypeDesc="诊断合理性")
								{
									s TmpAss={}
									d TmpAss.%Set("RiskLevel",TabooLevel)
									d TmpAss.%Set("WarningTip",WarningContent)
									d TmpAss.%Set("AlertLevel",HospWarnStopFlag)
									d TmpAss.%Set("SourceFlag",SourceFlag)
									d TmpAss.%Set("NoCondition",NoCondition)
									
									s Tmp={}
									d Tmp.%Set("OrderStr",OrderStr)
									d Tmp.%Set("NodeId",NodeRowId_"|"_RationalityRowId)
									d ..ProcessDuplicate(.DiseWArray,.TmpAss,Tmp)
								}	
								elseif(NodeTypeDesc="药品合理性")
								{
									s TmpAss={}
									d TmpAss.%Set("RiskLevel",TabooLevel)
									d TmpAss.%Set("WarningTip",WarningContent)
									d TmpAss.%Set("AlertLevel",HospWarnStopFlag)
									d TmpAss.%Set("SourceFlag",SourceFlag)
									d TmpAss.%Set("NoCondition",NoCondition)
									
									s Tmp={}
									d Tmp.%Set("OrderStr",OrderStr)
									d Tmp.%Set("NodeId",NodeRowId_"|"_RationalityRowId)
									d ..ProcessDuplicate(.DrugWArray,.TmpAss,Tmp)
								}
							}
						}	
					}	
				}
			}
			
		}
	
	
		//s Map("RDiagArray")="确诊诊断"
		s Map("DiffDiagArray")="鉴别诊断"
		//s Map("DocArray")="推荐相关文献"
		s Map("LabExamArray")="推荐检验检查"
		s Map("NursArray")="推荐护理措施"
		s Map("AssessArray")="推荐评估量表"
		s Map("TreatArray")="推荐治疗方案"
		//s Map("DiseWArray")="疾病预警"
		//s Map("TreatArray")="检验检查预警"
		//s Map("DiseWArray")="疾病预警"
		//s Map("LabExamWArray")="检验检查预警"
		//s Map("OperaWArray")="手术预警"
		//s Map("NursWArray")="护理预警"
		//s Map("AllergyWArray")="过敏史预警"
		
		s Code =""
		for
		{
			s Code=$o(Map(Code)) q:Code=""
			s Desc=Map(Code)
			try
			{
				d Result.%Set(Desc, @Code)
			}
			catch e
			{
				continue
			}
			
		}
		if ResultArray.%Get(RuleDesc)=""
		{
			d ResultArray.%Set(RuleDesc,Result)
		}
		else
		{
			s ResultIter=Result.%GetIterator()     //遍历第一层{}
			while ResultIter.%GetNext(.key,.value)
			{
				if value.%Size()'=0
				{
					d ResultArray.%Get(RuleDesc).%Set(key,value)
				}
			}
		}
	}
	q ResultArray.%ToJSON()
	//确诊诊断 鉴别诊断 推荐相关文献 推荐检验检查 推荐护理措施	推荐评估量表	推荐治疗方案	疾病预警	检验检查预警	手术预警	护理预警	过敏史预警	输血预警	手术并发症   药品预警	院方预警阻断	出院指导
	//s =[],=[],=[],=[],=[],=[],=[],=[],=[],=[],=[],=[],BloodWArray=[],OperCompArray=[],DrugWArray=[],HospWarnStopArray=[],DischargeGArray=[],MedCalulateArray=[]
}

}
