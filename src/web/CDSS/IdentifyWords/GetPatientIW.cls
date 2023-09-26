/// Creator:丁亚男
/// CreatDate:2021-08-13
/// Description:获取患者的识别词
Class web.CDSS.IdentifyWords.GetPatientIW Extends %RegisteredObject
{

/// Creator:丁亚男（弃用）
/// CreatDate:2022-04-07
/// Description:生成用到的患者模型数据临时global
/// Table: CT.WDT.CDSS.WordsItem
/// Input: PatientInfo ：患者信息
/// Return:成功返回1，失败返回0
/// Others:w ##class(web.CDSS.IdentifyWords.GetPatientIW).CreatePatientInfoData("DM000721^DM000721^1^住院^13984^李得原^183^信息部^1")
ClassMethod CreatePatientInfoDataBakup(PatientInfo As %String) As %String
{
	
	s DataType=""
	for
	{
		s DataType =$o(^CT.WDT.CDSS.WordsItemI("ParTypeIdx",DataType))  q:DataType="" 
		s WordsItemRowId=$o(^CT.WDT.CDSS.WordsItemI("ParTypeIdx",DataType,-100000000000000,""))
		continue:WordsItemRowId="" 	
				
		s FiledName=""
		s:WordsItemRowId'="" FiledName=$lg($g(^CT.WDT.CDSS.WordsItemD(WordsItemRowId)),7) 
						
		//先获取患者模型数据，避免多次获取
		s PInfoItem=##class(web.CDSS.IdentifyWords.GetPatientInfo).DealDataByPatientEnumI(PatientInfo,DataType) //取患者模型的数据
		continue:(PInfoItem="")||(PInfoItem="[]")
		s ^TempPInfoItemData($j,PatientInfo,DataType)=PInfoItem
		
		if (DataType="年龄")
		{
			continue:(PInfoItem="")||(PInfoItem="[]")
			s PInfoItem=[].%FromJSON(PInfoItem)
			s DataValue=(PInfoItem.%Get(0)).%Get(FiledName)
			if (DataValue'="")
			{
				s ^TempPInfoItemData($j,PatientInfo,DataType,FiledName,DataValue)=(PInfoItem.%Get(0)).%ToJSON()
			}
			
			s PInfoItem=##class(web.CDSS.IdentifyWords.GetPatientInfo).DealDataByPatientEnumI(PatientInfo,"年龄(天)") //取患者模型的数据
			continue:(PInfoItem="")||(PInfoItem="[]")
			s ^TempPInfoItemData($j,PatientInfo,"年龄(天)")=PInfoItem
			s PInfoItem=[].%FromJSON(PInfoItem)
			s DataValue=(PInfoItem.%Get(0)).%Get(FiledName)
			if (DataValue'="") 
			{
				s ^TempPInfoItemData($j,PatientInfo,"年龄(天)",FiledName,DataValue)=(PInfoItem.%Get(0)).%ToJSON()
			}
			
		}
		elseif (DataType="性别")
		{
			s PInfoItem=##class(web.CDSS.IdentifyWords.GetPatientInfo).DealDataByPatientEnumI(PatientInfo,DataType) //取患者模型的数据
			continue:(PInfoItem="")||(PInfoItem="[]")
			s PInfoItem=[].%FromJSON(PInfoItem)
			s DataValue=(PInfoItem.%Get(0)).%Get(FiledName)
			if (DataValue'="")
			{
				s ^TempPInfoItemData($j,PatientInfo,DataType,FiledName,DataValue)=(PInfoItem.%Get(0)).%ToJSON()
			}
			
		}
		elseif(DataType="体征")
		{
			s SignMeasutureStr=##class(web.CDSS.IdentifyWords.GetPatientInfo).DealDataByPatientEnumI(PatientInfo,"体征")
			if SignMeasutureStr'=""
			{
				s SignMeasutureJson=[].%FromJSON(SignMeasutureStr)
			}
			s CommonTypeRowId=$o(^CT.WDT.CDSS.CommonDictTypeI("DescIndex"," "_$ZCONVERT("体征","U"),0))
			s CommonRowId=0
			for 
			{
				s CommonRowId=$o(^CT.WDT.CDSS.CommonDictI("TypeIndex",CommonTypeRowId,CommonRowId)) q:CommonRowId=""
				s DictDesc=$lg($g(^CT.WDT.CDSS.CommonDictD(CommonRowId)),4)  
				s EnCommonName=$lg($g(^CT.WDT.CDSS.CommonDictD(CommonRowId)),10)        //通用名英文名称 体重 Weight
				
				//体征单独处理业务数据临时global
				s PInfoItem=##class(web.CDSS.IdentifyWords.GetPatientInfo).DealDataByPatientEnumI(PatientInfo,DictDesc) //取患者模型的数据
				continue:(PInfoItem="")||(PInfoItem="[]")
				s ^TempPInfoItemData($j,PatientInfo,DictDesc)=PInfoItem
				s PInfoItem=[].%FromJSON(PInfoItem)
				s DataValue=(PInfoItem.%Get(0)).%Get(EnCommonName)
				if (DataValue'="")
				{
					for MeasureIndex=0:1:SignMeasutureJson.%Size()-1
					{
						s MeasureDate=SignMeasutureJson.%Get(MeasureIndex).%Get("MeasureDate")
						s MeasureItemValue=SignMeasutureJson.%Get(MeasureIndex).%Get(EnCommonName)
						s:MeasureItemValue="/" MeasureItemValue=""
						if ($g(MeasureDate)'="")&(MeasureItemValue'="")
						{
							s ^TempPInfoItemData($j,PatientInfo,DataType,EnCommonName,DictDesc,MeasureDate)=MeasureItemValue_"&*"
						}
					}
					s ^TempPInfoItemData($j,PatientInfo,DataType,DictDesc)=DictDesc
					s ^TempPInfoItemData($j,PatientInfo,DictDesc,EnCommonName,DataValue)=(PInfoItem.%Get(0)).%ToJSON()
				}
			}
		}
		else
		{
			s PInfoItem=[].%FromJSON(PInfoItem)
			for i=0:1:(PInfoItem.%Size()-1)  //遍历条件判断是否满足
			{
				s lenFiledName=$length(FiledName,"&")
				for jFiled=1:1:lenFiledName
				{
					s ItemName=$p(FiledName,"&",jFiled)
					s DataValueStr=$tr((PInfoItem.%Get(i)).%Get(ItemName),"""","'")  //有的数据多条用&%拼接
					s lenDataValue=$l(DataValueStr,"&%")
					for ilenDataValue=1:1:lenDataValue
					{
						s DataValue=$p(DataValueStr,"&%",ilenDataValue)
						continue:DataValue=""
						if (DataType="检验")||(DataType="检验结果")||(DataType="检查")||(DataType="检查结果")||(DataType="护理结果")
						{
							if DataType["检验"
							{
								s ReportTime=PInfoItem.%Get(i).%Get("children").%Get(0).%Get("ReportTime")
								s ValueResult = PInfoItem.%Get(i).%Get("children").%Get(0).%Get("LabResult")
								s ValueUnit= PInfoItem.%Get(i).%Get("children").%Get(0).%Get("Unit")
							}
							elseif DataType["检查"
							{
								s ReportTime=PInfoItem.%Get(i).%Get("ReportTime")
								s ValueResult=PInfoItem.%Get(i).%Get("ExamResultFlag")
								s ValueUnit=PInfoItem.%Get(i).%Get("Unit")
							}
							else
							{
								s ReportTime=PInfoItem.%Get(i).%Get("ReportTime")
								s ValueResult=PInfoItem.%Get(i).%Get("NursValue")
								s ValueUnit=PInfoItem.%Get(i).%Get("Unit")
							}
							
							if ReportTime'=""
							{
								s ^TempPInfoItemData($j,PatientInfo,DataType,ItemName,DataValue,ReportTime)=ValueResult_"&*"_$g(ValueUnit,"")
							}
						}
						s ^TempPInfoItemData($j,PatientInfo,DataType,ItemName,DataValue)=PInfoItem.%Get(i).%ToJSON()
					}
				}
			}						
					
		}
	} 
	q 1
}

// w ##class(web.CDSS.IdentifyWords.GetPatientIW).GetRequiredIW("NursingWarning","dhcc")

ClassMethod CreatePatientInfoData(PatientInfo As %String) As %String
{
	
	s DataType=""
	for
	{
		s DataType =$o(^CT.WDT.CDSS.WordsItemI("ParTypeIdx",DataType))  q:DataType="" 
		s WordsItemRowId=$o(^CT.WDT.CDSS.WordsItemI("ParTypeIdx",DataType,-100000000000000,""))
		continue:WordsItemRowId="" 	
				
		s FiledName=""
		s:WordsItemRowId'="" FiledName=$lg($g(^CT.WDT.CDSS.WordsItemD(WordsItemRowId)),7) 
						
		//先获取患者模型数据，避免多次获取
		s PInfoItem=##class(web.CDSS.IdentifyWords.GetPatientInfo).DealDataByPatientEnumI(PatientInfo,DataType) //取患者模型的数据
		continue:(PInfoItem="")||(PInfoItem="[]")
		s ^TempPInfoItemData($j,PatientInfo,DataType)=PInfoItem
		
		if (DataType="年龄")
		{
			continue:(PInfoItem="")||(PInfoItem="[]")
			s PInfoItem=[].%FromJSON(PInfoItem)
			s DataValue=(PInfoItem.%Get(0)).%Get(FiledName)
			if (DataValue'="")
			{
				s ^TempPInfoItemData($j,PatientInfo,DataType,FiledName,DataValue)=(PInfoItem.%Get(0)).%ToJSON()
			}
			
			s PInfoItem=##class(web.CDSS.IdentifyWords.GetPatientInfo).DealDataByPatientEnumI(PatientInfo,"年龄(天)") //取患者模型的数据
			continue:(PInfoItem="")||(PInfoItem="[]")
			s ^TempPInfoItemData($j,PatientInfo,"年龄(天)")=PInfoItem
			s PInfoItem=[].%FromJSON(PInfoItem)
			s DataValue=(PInfoItem.%Get(0)).%Get(FiledName)
			if (DataValue'="") 
			{
				s ^TempPInfoItemData($j,PatientInfo,"年龄(天)",FiledName,DataValue)=(PInfoItem.%Get(0)).%ToJSON()
			}
			
		}
		elseif (DataType="性别")
		{
			s PInfoItem=##class(web.CDSS.IdentifyWords.GetPatientInfo).DealDataByPatientEnumI(PatientInfo,DataType) //取患者模型的数据
			continue:(PInfoItem="")||(PInfoItem="[]")
			s PInfoItem=[].%FromJSON(PInfoItem)
			s DataValue=(PInfoItem.%Get(0)).%Get(FiledName)
			if (DataValue'="")
			{
				s ^TempPInfoItemData($j,PatientInfo,DataType,FiledName,DataValue)=(PInfoItem.%Get(0)).%ToJSON()
			}
			
		}
		elseif(DataType="体征")
		{
			s SignMeasutureStr=##class(web.CDSS.IdentifyWords.GetPatientInfo).DealDataByPatientEnumI(PatientInfo,"体征")
			if SignMeasutureStr'=""
			{
				s SignMeasutureJson=[].%FromJSON(SignMeasutureStr)
			}
			s CommonTypeRowId=$o(^CT.WDT.CDSS.CommonDictTypeI("DescIndex"," "_$ZCONVERT("体征","U"),0))
			s CommonRowId=0
			for 
			{
				s CommonRowId=$o(^CT.WDT.CDSS.CommonDictI("TypeIndex",CommonTypeRowId,CommonRowId)) q:CommonRowId=""
				s DictDesc=$lg($g(^CT.WDT.CDSS.CommonDictD(CommonRowId)),4)  
				s EnCommonName=$lg($g(^CT.WDT.CDSS.CommonDictD(CommonRowId)),10)        //通用名英文名称 体重 Weight
				
				//体征单独处理业务数据临时global
				s PInfoItem=##class(web.CDSS.IdentifyWords.GetPatientInfo).DealDataByPatientEnumI(PatientInfo,DictDesc) //取患者模型的数据
				continue:(PInfoItem="")||(PInfoItem="[]")
				s ^TempPInfoItemData($j,PatientInfo,DictDesc)=PInfoItem
				s PInfoItem=[].%FromJSON(PInfoItem)
				s DataValue=(PInfoItem.%Get(0)).%Get(EnCommonName)
				if (DataValue'="")
				{
					for MeasureIndex=0:1:SignMeasutureJson.%Size()-1
					{
						s MeasureDate=SignMeasutureJson.%Get(MeasureIndex).%Get("MeasureDate")
						s MeasureItemValue=SignMeasutureJson.%Get(MeasureIndex).%Get(EnCommonName)
						s:MeasureItemValue="/" MeasureItemValue=""
						if ($g(MeasureDate)'="")&(MeasureItemValue'="")
						{
							s ^TempPInfoItemData($j,PatientInfo,DataType,EnCommonName,DictDesc,MeasureDate)=MeasureItemValue_"&*"
						}
					}
					s ^TempPInfoItemData($j,PatientInfo,DataType,DictDesc)=DictDesc
					s ^TempPInfoItemData($j,PatientInfo,DictDesc,EnCommonName,DataValue)=(PInfoItem.%Get(0)).%ToJSON()
				}
			}
		}
		else
		{
			s PInfoItem=[].%FromJSON(PInfoItem)
			for i=0:1:(PInfoItem.%Size()-1)  //遍历条件判断是否满足
			{
				s lenFiledName=$length(FiledName,"&")
				for jFiled=1:1:lenFiledName
				{
					s ItemName=$p(FiledName,"&",jFiled)
					s DataValueStr=$tr((PInfoItem.%Get(i)).%Get(ItemName),"""","'")  //有的数据多条用&%拼接
					if DataValueStr=""
					{
						if PInfoItem.%Get(i).%IsDefined("children")
						{
							s Children=PInfoItem.%Get(i).%Get("children")
							if Children.%Size()<1
							{
								continue
							}
							for ChildIndex=0:1:Children.%Size()-1
							{
								s DataValueStr=$tr((Children.%Get(ChildIndex)).%Get(ItemName),"""","'")
								d ..ProcessItemName(PatientInfo,DataValueStr,DataType,Children,ChildIndex,ItemName)
							}
						}
					}
					else
					{
						d ..ProcessItemName(PatientInfo,DataValueStr,DataType,PInfoItem,i,ItemName)
					}
				}
			}						
					
		}
	} 
	q 1
}

ClassMethod ProcessItemName(PatientInfo As %String, DataValueStr As %String, DataType As %String, ItemJson As %String, Index As %String, ItemName As %String)
{
	s lenDataValue=$l(DataValueStr,"&%")
	for ilenDataValue=1:1:lenDataValue
	{
		s DataValue=$p(DataValueStr,"&%",ilenDataValue)
		continue:DataValue=""
		if (DataType="检验")||(DataType="检验结果")||(DataType="检查")||(DataType="检查检验结果")||(DataType="护理结果")
		{
			if DataType["检验"
			{
				s ReportTime=ItemJson.%Get(Index).%Get("ReportTime")
				s ValueResult = ItemJson.%Get(Index).%Get("LabResult")
				s ValueUnit= ItemJson.%Get(Index).%Get("Unit")
			}
			elseif DataType["检查"
			{
				s ReportTime=ItemJson.%Get(Index).%Get("ReportTime")
				s ValueResult=ItemJson.%Get(Index).%Get("ExamResultFlag")
				s ValueUnit=ItemJson.%Get(Index).%Get("Unit")
			}
			else
			{
				s ReportTime=ItemJson.%Get(Index).%Get("ReportTime")
				s ValueResult=ItemJson.%Get(Index).%Get("NursValue")
				s ValueUnit=ItemJson.%Get(Index).%Get("Unit")
			}
			
			if ReportTime'=""
			{
				try
				{
					s ^TempPInfoItemData($j,PatientInfo,DataType,ItemName,DataValue,ReportTime)=ValueResult_"&*"_$g(ValueUnit,"")
				}
				catch e
				{
					continue
				}
			}
			//2023-04-14 用来做识别词new old origin相关操作
			if ReportTime=""
			{
				s ReportTime=$zdt($now(),3)
			}
			try
			{
				s ^TempPInfoItemData($j,PatientInfo,DataType,ItemName,DataValue,"ReportTime",ReportTime)=ItemJson.%Get(Index).%ToJSON()
			}catch e
			{}
		}
		try
		{
			s ^TempPInfoItemData($j,PatientInfo,DataType,ItemName,DataValue)=ItemJson.%Get(Index).%ToJSON()
		}catch e
		{}
	}
	q ""
}

ClassMethod GetRequiredIW(RecomType As %String, ProVision As %String)
{
	k ^RequireIW
	
	if $d(^CDSSMatchRule(ProVision,RecomType))
	{
		s RuleRowid=0
		for
		{
			s RuleRowid=$o(^CDSSMatchRule(ProVision,RecomType,RuleRowid)) q:RuleRowid=""
			s RuleType=""
			for
			{
				s RuleType=$o(^CDSSMatchRule(ProVision,RecomType,RuleRowid,RuleType)) q:RuleType=""
				s FlowNum=0
				for
				{
					s FlowNum=$o(^CDSSMatchRule(ProVision,RecomType,RuleRowid,RuleType,FlowNum)) q:FlowNum=""
					s IWString=^CDSSMatchRule(ProVision,RecomType,RuleRowid,RuleType,FlowNum)
					for i=1:1:$l(IWString,"[A]")
					{
						
						s IWRowid=$p(IWString,"[A]",i)
						continue:IWRowid=""
						s ^RequireIW(ProVision,RecomType,IWRowid)=""
					}
				}
			}
		}
	}
	q ""
}

/// Creator:丁亚男
/// CreatDate:2021-08-13
/// Description:根据患者汇总信息表刷选有价值的患者信息去匹配识别词，并且保存到 患者当前触发识别词表
/// Table: WDT.CDSS.PatPMTypeIndex:患者汇总信息表 WDT.CDSS.PatTriggerIW:患者当前触发的识别词 CT.WDT.CDSS.IdentifyWIndex:识别词项目索引表
/// Input: PatientInfo : 患者信息（医生站所传json串）
/// Return: 
/// Others:w ##class(web.CDSS.IdentifyWords.GetPatientIW).GetSatisfyIW("DM000780^DM000780^1^住院^15^范文凯^1^信息科^Y")
/// w ##class(web.CDSS.IdentifyWords.GetPatientIW).GetSatisfyIW("DM000821^DM000821^1^住院^1^范文凯^1^信息科^1")
/// w ##class(web.CDSS.IdentifyWords.GetPatientIW).GetSatisfyIW("9138^0000000293^1^住院^17276^医生02^ZYZY003^内分泌科^0")
ClassMethod GetSatisfyIW(PatientInfo As %String, RecomType As %String = "", ProVision As %String = "", RuleId As %String = "") As %String
{
	s ^TMP("PPPP")=PatientInfo
	s start = $p($zdt($now(),3,1,4),":",*)
	s IDNO=$p(PatientInfo,"^",1)
	s PatientDR=$p(PatientInfo,"^",2)
	s VisitID=$p(PatientInfo,"^",3)
	s VisitType=$p(PatientInfo,"^",4)
	s Config=$p(PatientInfo,"^",9)
	s Type=$p(PatientInfo,"^",10)
	if (Config="") s Config=1	//是否启用流水号（急诊号、门诊号、住院号）为患者就诊唯一标识（0为是，1为否），默认为1
	s OperLevelValueMap={}
	s OperLevelIWMap={}
	s IWArray=""  //符合索引条件的识别词
	//K ^TempPInfoItemData($j,PatientInfo)
	//先获取患者模型数据，避免多次获取
	s DiseaseFlag=""
	if $l(PatientInfo,"^")=10
	{
		s DiseaseFlag=$p(PatientInfo,"^",*)
		s PatientInfo=$replace(PatientInfo,"^"_DiseaseFlag,"")
	}
	if '$d(^TempPInfoItemData($j,PatientInfo))
	{
		d ..CreatePatientInfoData(PatientInfo)
	}
	
	if ((Config=1)||(Config="Y"))&(PatientDR'="")&(VisitID'="") // 单个患者单次就诊 根据病人标识和就诊次数编号取数据
	{
		s DataTypeArray=""
		//获取患者信息更新可能触发的识别词
		if ($d(^WDT.CDSS.PatPMTypeIndexI("PatVisDRUpTypeIndex",PatientDR,VisitID,VisitType,"1")))
		{
			s DataType=0
			for
			{
				s DataType =$o(^WDT.CDSS.PatPMTypeIndexI("PatVisDRUpTypeIndex",PatientDR,VisitID,VisitType,"1",DataType))  q:DataType=""  
				s DataTypeArray(DataType)=""
			}
		}
		
		if ($d(^WDT.CDSS.PatPMTypeIndexI("IDNOUpTypeIndex",IDNO,"1","过敏史")))
		{
			s DataTypeArray("过敏史")=""
		}
		
		s DataType=""
		for
		{
			s DataType=$o(DataTypeArray(DataType))
			q:DataType=""
			
			if $d(^CT.WDT.CDSS.IdentifyWIndexI("TypeNameIWIndex",DataType))  //存在这个数据类型的索引
			{
				if ($d(^CT.WDT.CDSS.WordsItemI("ParTypeIdx",DataType,-100000000000000))) //类型关联的识别词项目有父节点
				{
					s WordsItemRowId=$o(^CT.WDT.CDSS.WordsItemI("ParTypeIdx",DataType,-100000000000000,""))
					s FiledName=""
					s:WordsItemRowId'="" FiledName=$lg($g(^CT.WDT.CDSS.WordsItemD(WordsItemRowId)),7) 
					if (FiledName'="") //类型关联的字段不为空
					{
						if (FiledName="DiagnosisName")   //评估表用到 全部诊断 单独处理
						{
							s PInfoItem=$g(^TempPInfoItemData($j,PatientInfo,DataType)) //取患者模型的数据
							continue:(PInfoItem="")||(PInfoItem="[]")
							s PInfoItem=[].%FromJSON(PInfoItem)
							s DataValue=(PInfoItem.%Get(0)).%Get(FiledName)
							s DataType1="全部诊断"
							if (DataValue'="")&&($d(^CT.WDT.CDSS.IdentifyWIndexI("TypeNameIWIndex",DataType,DataType1)))
							{
								s IWRowId=0
								for 
								{
									s IWRowId=$o(^CT.WDT.CDSS.IdentifyWIndexI("TypeNameIWIndex",DataType,DataType1,IWRowId)) q:IWRowId=""
									s IWArray(IWRowId)=""
								}
							}
						}
						
						if (FiledName="OperName")
						{
							s PInfoItem=$g(^TempPInfoItemData($j,PatientInfo,DataType)) //取患者模型的数据
							continue:(PInfoItem="")||(PInfoItem="[]")
							s PInfoItem=[].%FromJSON(PInfoItem)
							s DataValue=(PInfoItem.%Get(0)).%Get(FiledName)
							s DataType1="全部手术"
							if (DataValue'="")&&($d(^CT.WDT.CDSS.IdentifyWIndexI("TypeNameIWIndex",DataType,DataType1)))
							{
								s IWRowId=0
								for 
								{
									s IWRowId=$o(^CT.WDT.CDSS.IdentifyWIndexI("TypeNameIWIndex",DataType,DataType1,IWRowId)) q:IWRowId=""
									s IWArray(IWRowId)=""
								}
							}
						}
						
						if (FiledName="Sex")||(FiledName="Age")  //规则可能只用到年龄、性别，识别词表加年龄、性别的识别词 患者模型对应的值不为空即保存这两条数据
						{
							s PInfoItem=$g(^TempPInfoItemData($j,PatientInfo,DataType)) //取患者模型的数据
							continue:(PInfoItem="")||(PInfoItem="[]")
							//s PInfoItem=[].%FromJSON(PInfoItem)
							s DataValue=$O(^TempPInfoItemData($j,PatientInfo,DataType,FiledName,"")) //(PInfoItem.%Get(0)).%Get(FiledName)
							if (DataValue'="")&&($d(^CT.WDT.CDSS.IdentifyWIndexI("TypeNameIWIndex",DataType,DataType)))
							{
								s IWRowId=0
								for 
								{
									s IWRowId=$o(^CT.WDT.CDSS.IdentifyWIndexI("TypeNameIWIndex",DataType,DataType,IWRowId)) q:IWRowId=""
									s IWArray(IWRowId)=""
								}
							}
						}
						else
						{
							s PInfoItem=$g(^TempPInfoItemData($j,PatientInfo,DataType)) //取患者模型的数据
							continue:(PInfoItem="")||(PInfoItem="[]")
							//s PInfoItem=[].%FromJSON(PInfoItem)
							s lenFiledName=$length(FiledName,"&")
							for jFiled=1:1:lenFiledName
							{
								s ItemName=$p(FiledName,"&",jFiled)
								s DataValue=""
								for 
								{
									s DataValue=$O(^TempPInfoItemData($j,PatientInfo,DataType,ItemName,DataValue)) q:DataValue=""
									if ($d(^CT.WDT.CDSS.IdentifyWIndexI("TypeNameIWIndex",DataType,DataValue)))
									{
										if DataType="手术"
										{
											s OperIW=""
											s OperInfo=$g(^TempPInfoItemData($j,PatientInfo,DataType,ItemName,DataValue))
											continue:(OperInfo="")||(OperInfo="{}")
											s OperInfo={}.%FromJSON(OperInfo)
											s OperLevel=OperInfo.%Get("OperLevel")
											d ..OperLevel(.IWArray,.OperLevelValueMap,OperLevel,DataValue)
										}
										else
										{
											s IWRowId=0
											for 
											{
												s IWRowId=$o(^CT.WDT.CDSS.IdentifyWIndexI("TypeNameIWIndex",DataType,DataValue,IWRowId)) q:IWRowId=""
												s IWDesc=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(IWRowId)),3)
												if $match(IWDesc,".级手术")
												{
													d OperLevelIWMap.%Set(IWDesc,DataValue)
												}
												s IWArray(IWRowId)=""
												
											}
										}
										if (DataType="药品")
										{
											s MIWRowId=$o(^CT.WDT.CDSS.IdentifyWordsI("DescIndex"," 中成药",0))
											s IWArray(MIWRowId)=""
											s CIWRowId=$o(^CT.WDT.CDSS.IdentifyWordsI("DescIndex"," 中草药",0))
											s IWArray(CIWRowId)=""
										}
									}
								}
								
							} 
							
						}	
					}
					elseif(DataType="体征")
					{
						s CommonTypeRowId=$o(^CT.WDT.CDSS.CommonDictTypeI("DescIndex"," "_$ZCONVERT("体征","U"),0))
						s CommonRowId=0
						for 
						{
							s CommonRowId=$o(^CT.WDT.CDSS.CommonDictI("TypeIndex",CommonTypeRowId,CommonRowId)) q:CommonRowId=""
							s DictDesc=$lg($g(^CT.WDT.CDSS.CommonDictD(CommonRowId)),4)  
							s EnCommonName=$lg($g(^CT.WDT.CDSS.CommonDictD(CommonRowId)),10)        //通用名英文名称 体重 Weight
							s PInfoItem=$g(^TempPInfoItemData($j,PatientInfo,DataType,DictDesc)) //取患者模型的数据
							continue:(PInfoItem="")||(PInfoItem="[]")
							//s PInfoItem=[].%FromJSON(PInfoItem)
							
							if ($o(^TempPInfoItemData($j,PatientInfo,DictDesc,EnCommonName,""))'="")&&($d(^CT.WDT.CDSS.IdentifyWIndexI("TypeNameIWIndex",DataType,DictDesc)))
							{
								s IWRowId=0
								for 
								{
									s IWRowId=$o(^CT.WDT.CDSS.IdentifyWIndexI("TypeNameIWIndex",DataType,DictDesc,IWRowId)) q:IWRowId=""
									s IWArray(IWRowId)=""
								}
							}
						}
					}
				}
			}
			
		}
		//获取当前触发的识别词
		if ($d(^WDT.CDSS.PatTriggerIWI("PatVisTypeIWIndex",PatientDR,VisitID,VisitType)))
		{
			s IWRowId=0
			for 
			{
				s IWRowId=$O(^WDT.CDSS.PatTriggerIWI("PatVisTypeIWIndex",PatientDR,VisitID,VisitType,IWRowId)) q:IWRowId=""
				s IWArray(IWRowId)=""
			}
			
		}
	} 
	elseif (IDNO'="")  //患者主索引
	{
		//获取患者信息更新可能触发的识别词
		if ($d(^WDT.CDSS.PatPMTypeIndexI("IDNOUpTypeIndex",IDNO,"1")))
		{
			s DataType=0
			for
			{
				s DataType =$o(^WDT.CDSS.PatPMTypeIndexI("IDNOUpTypeIndex",IDNO,"1",DataType))  q:DataType=""  
				if $d(^CT.WDT.CDSS.IdentifyWIndexI("TypeNameIWIndex",DataType))  //存在这个数据类型的索引
				{
					if ($d(^CT.WDT.CDSS.WordsItemI("ParTypeIdx",DataType,-100000000000000))) //类型关联的识别词项目有父节点
					{
						
						s WordsItemRowId=$o(^CT.WDT.CDSS.WordsItemI("ParTypeIdx",DataType,-100000000000000,""))
						
						s FiledName=""
						s:WordsItemRowId'="" FiledName=$lg($g(^CT.WDT.CDSS.WordsItemD(WordsItemRowId)),7) 
						if (FiledName'="") //类型关联的字段不为空
						{
							
							if (FiledName="DiagnosisName")   //评估表用到 全部诊断 单独处理
							{
							
								s PInfoItem=$g(^TempPInfoItemData($j,PatientInfo,DataType)) //取患者模型的数据
								continue:(PInfoItem="")||(PInfoItem="[]")
								s PInfoItem=[].%FromJSON(PInfoItem)
								s DataValue=(PInfoItem.%Get(0)).%Get(FiledName)
								s DataType1="全部诊断"
								
								if (DataValue'="")&&($d(^CT.WDT.CDSS.IdentifyWIndexI("TypeNameIWIndex",DataType,DataType1)))
								{
									s IWRowId=0
									for 
									{
										s IWRowId=$o(^CT.WDT.CDSS.IdentifyWIndexI("TypeNameIWIndex",DataType,DataType1,IWRowId)) q:IWRowId=""
										s IWArray(IWRowId)=""
									}
								}
							
							}
							if (FiledName="OperName")
							{
								s PInfoItem=$g(^TempPInfoItemData($j,PatientInfo,DataType)) //取患者模型的数据
								continue:(PInfoItem="")||(PInfoItem="[]")
								s PInfoItem=[].%FromJSON(PInfoItem)
								s DataValue=(PInfoItem.%Get(0)).%Get(FiledName)
								s DataType1="全部手术"
								if (DataValue'="")&&($d(^CT.WDT.CDSS.IdentifyWIndexI("TypeNameIWIndex",DataType,DataType1)))
								{
									s IWRowId=0
									for 
									{
										s IWRowId=$o(^CT.WDT.CDSS.IdentifyWIndexI("TypeNameIWIndex",DataType,DataType1,IWRowId)) q:IWRowId=""
										s IWArray(IWRowId)=""
									}
								}
								
								
							}
							
							if (FiledName="Sex")||(FiledName="Age")  //规则可能只用到年龄、性别，识别词表加年龄、性别的识别词 患者模型对应的值不为空即保存这两条数据
							{
								
								s PInfoItem=$g(^TempPInfoItemData($j,PatientInfo,DataType)) //取患者模型的数据
								continue:(PInfoItem="")||(PInfoItem="[]")
								//s PInfoItem=[].%FromJSON(PInfoItem)
								s DataValue=$O(^TempPInfoItemData($j,PatientInfo,DataType,FiledName,"")) //(PInfoItem.%Get(0)).%Get(FiledName)
								
								if (DataValue'="")&&($d(^CT.WDT.CDSS.IdentifyWIndexI("TypeNameIWIndex",DataType,DataType)))
								{
									s IWRowId=0
									for 
									{
										s IWRowId=$o(^CT.WDT.CDSS.IdentifyWIndexI("TypeNameIWIndex",DataType,DataType,IWRowId)) q:IWRowId=""
										s IWArray(IWRowId)=""
									}
								}
								
							}
							else
							{
								
								s PInfoItem=$g(^TempPInfoItemData($j,PatientInfo,DataType)) //取患者模型的数据
								continue:(PInfoItem="")||(PInfoItem="[]")
								
								//s PInfoItem=[].%FromJSON(PInfoItem)
								s lenFiledName=$length(FiledName,"&")
								for jFiled=1:1:lenFiledName
								{
									s ItemName=$p(FiledName,"&",jFiled)
									s DataValue=""
									for 
									{
										s DataValue=$O(^TempPInfoItemData($j,PatientInfo,DataType,ItemName,DataValue)) q:DataValue=""
										if ($d(^CT.WDT.CDSS.IdentifyWIndexI("TypeNameIWIndex",DataType,DataValue)))
										{
											if DataType="手术"
											{
												s OperIW=""
												s OperInfo=$g(^TempPInfoItemData($j,PatientInfo,DataType,ItemName,DataValue))
												continue:(OperInfo="")||(OperInfo="{}")
												s OperInfo={}.%FromJSON(OperInfo)
												s OperLevel=OperInfo.%Get("OperLevel")
												d ..OperLevel(.IWArray,.OperLevelValueMap,OperLevel,DataValue)
											}
											else
											{
												s IWRowId=0
												for 
												{
													s IWRowId=$o(^CT.WDT.CDSS.IdentifyWIndexI("TypeNameIWIndex",DataType,DataValue,IWRowId)) q:IWRowId=""
													s IWDesc=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(IWRowId)),3)
													if $match(IWDesc,".级手术")
													{
														d OperLevelIWMap.%Set(IWDesc,DataValue)
													}
													s IWArray(IWRowId)=""
													
												}
											}
											if (DataType="药品")
											{
												s MIWRowId=$o(^CT.WDT.CDSS.IdentifyWordsI("DescIndex"," 中成药",0))
												s IWArray(MIWRowId)=""
												s CIWRowId=$o(^CT.WDT.CDSS.IdentifyWordsI("DescIndex"," 中草药",0))
												s IWArray(CIWRowId)=""
											}
										}
									}
									
								} 
							}
							
						}
						elseif(DataType="体征")
						{
							
							s CommonTypeRowId=$o(^CT.WDT.CDSS.CommonDictTypeI("DescIndex"," "_$ZCONVERT("体征","U"),0))
							s CommonRowId=0
							for 
							{
								s CommonRowId=$o(^CT.WDT.CDSS.CommonDictI("TypeIndex",CommonTypeRowId,CommonRowId)) q:CommonRowId=""
								s DictDesc=$lg($g(^CT.WDT.CDSS.CommonDictD(CommonRowId)),4)  
								s EnCommonName=$lg($g(^CT.WDT.CDSS.CommonDictD(CommonRowId)),10)        //通用名英文名称 体重 Weight
								s PInfoItem=$g(^TempPInfoItemData($j,PatientInfo,DataType,DictDesc)) //取患者模型的数据
								continue:(PInfoItem="")||(PInfoItem="[]")
								//s PInfoItem=[].%FromJSON(PInfoItem)
								if ($O(^TempPInfoItemData($j,PatientInfo,DictDesc,EnCommonName,""))'="")&&($d(^CT.WDT.CDSS.IdentifyWIndexI("TypeNameIWIndex",DataType,DictDesc)))
								{
									s IWRowId=0
									for 
									{
										s IWRowId=$o(^CT.WDT.CDSS.IdentifyWIndexI("TypeNameIWIndex",DataType,DictDesc,IWRowId)) q:IWRowId=""
										s IWArray(IWRowId)=""
									}
								}
							}
						}
					}
				}
			}
		}
		//获取当前触发的识别词
		if ($d(^WDT.CDSS.PatTriggerIWI("IDNOIWIndex",IDNO)))
		{
			s IWRowId=0
			for 
			{
				s IWRowId=$O(^WDT.CDSS.PatTriggerIWI("IDNOIWIndex",IDNO,IWRowId)) q:IWRowId=""
				s IWArray(IWRowId)=""
			}
		}
	}
	
	if (ProVision="sds")&(RecomType'=$c(0))&(RecomType'="")   //sds
	{
		s IWRowid=0
		for
		{
			s IWRowId=$o(IWArray(IWRowId)) q:IWRowId=""
			s IWFlag=0
			for RecomTypeIndex=1:1:$l(RecomType,",")
			{
				s RecomTypeItem = $p(RecomType,",",RecomTypeIndex)
				continue:RecomTypeItem=""
				if $d(^RequireIW(ProVision,RecomTypeItem,IWRowId))
				{
					s IWFlag=1
				}
			}
			if IWFlag=0
			{
				k IWArray(IWRowId)
			}

		}
		
	}

	//判断识别词是否满足条件 满足保存到患者识别词表
	s IWRowId=0
	for
	{
		s IWRowId=$o(IWArray(IWRowId)) q:IWRowId=""
		s WordsDesc=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(IWRowId)),3)
		s WordsState=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(IWRowId)),5)
		
		//年龄、性别是为了触发规则的年龄和性别条件增加的项目，全部诊断是方便有些评估表关联的诊断是全部诊断，评估表一直需要推荐的情况
		if (WordsDesc="年龄")||(WordsDesc="性别")||(WordsDesc="全部诊断")||(WordsDesc="手术")||(WordsDesc="择期手术")||($match(WordsDesc,".级手术"))||(WordsDesc="中草药")||(WordsDesc="中成药")
		{
			
			s flag=1
			if (WordsDesc="年龄")||(WordsDesc="性别")
			{
				s Dict = {"年龄":"Age", "性别":"Sex"}
				if $g(^TempPInfoItemData($j,PatientInfo,WordsDesc))'=""
				{
					s DataValue = [].%FromJSON(^TempPInfoItemData($j,PatientInfo,WordsDesc)).%Get(0)
					s ^TMPIdentifyW(PatientInfo,"PTableName")="WDT.CDSS.PatientMaster"
					s ^TMPIdentifyW(PatientInfo,"PTableName","PFiledName") = Dict.%Get(WordsDesc)
					s ^TMPIdentifyW(PatientInfo,"PTableName","PFiledName","PFiledValue")=DataValue.%Get(Dict.%Get(WordsDesc))
				}
			}
			else
			{
				if $g(^TempPInfoItemData($j,PatientInfo,"诊断"))=""
				{
					s flag=0
				}
				else
				{
					s flag=1
					s ^TMPIdentifyW(PatientInfo,"PTableName")="WDT.CDSS.DiagnosisInfo"
					s ^TMPIdentifyW(PatientInfo,"PTableName","PFiledName") = "DiagnosisName"
					s ^TMPIdentifyW(PatientInfo,"PTableName","PFiledName","PFiledValue")=""
				}
			} 
			if WordsDesc="中草药"
			{
				s PInfoItem=$g(^TempPInfoItemData($j,PatientInfo,"药品"))
				if (PInfoItem="")||(PInfoItem="[]")
				{
					s flag=0
				}
				else
				{
					s PInfoItem=[].%FromJSON(PInfoItem)
					for i=0:1:(PInfoItem.%Size()-1)  //遍历条件判断是否满足
					{
						s DrugName=PInfoItem.%Get(i).%Get("DrugName")
						if $d(^CT.WDT.CDSS.TCMMedicineI("NameIndex"," "_$zconvert(DrugName,"U")))
						{
							s flag=1
							s ^TMPIdentifyW(PatientInfo,"PTableName")="WDT.CDSS.DrugInfo"
							s ^TMPIdentifyW(PatientInfo,"PTableName","PFiledName") = "DrugName"
							s ^TMPIdentifyW(PatientInfo,"PTableName","PFiledName","PFiledValue")=DrugName
							q
						}
					}
				}
			}
			
			if WordsDesc="中成药"
			{
				s PInfoItem=$g(^TempPInfoItemData($j,PatientInfo,"药品"))
				if (PInfoItem="")||(PInfoItem="[]")
				{
					s flag=0
				}
				else
				{
					s PInfoItem=[].%FromJSON(PInfoItem)
					for i=0:1:(PInfoItem.%Size()-1)  //遍历条件判断是否满足
					{
						s DrugName=PInfoItem.%Get(i).%Get("DrugName")
						if $d(^CT.WDT.CDSS.DrugDictI("DrugCategoryIndex"," 中成药"," "_$zconvert(DrugName,"U")))
						{
							s flag=1
							s ^TMPIdentifyW(PatientInfo,"PTableName")="WDT.CDSS.DrugInfo"
							s ^TMPIdentifyW(PatientInfo,"PTableName","PFiledName") = "DrugName"
							s ^TMPIdentifyW(PatientInfo,"PTableName","PFiledName","PFiledValue")=DrugName
							q
						}
					}
				}
			}
			
			if (WordsDesc="手术")
			{
				s flag=0
				s PInfoItem=$g(^TempPInfoItemData($j,PatientInfo,"手术")) //取患者模型的数据
				if (PInfoItem="")||(PInfoItem="[]")
				{
					s flag=0
				}
				else
				{
					s flag=1
					s ^TMPIdentifyW(PatientInfo,"PTableName")="WDT.CDSS.OperationInfo"
					s ^TMPIdentifyW(PatientInfo,"PTableName","PFiledName") = "OperName"
					s ^TMPIdentifyW(PatientInfo,"PTableName","PFiledName","PFiledValue")="Todo"
				}	

			}
			
			if (WordsDesc="择期手术")||(WordsDesc="急诊手术")
			{
				s flag=0
				s PInfoItem=$g(^TempPInfoItemData($j,PatientInfo,"手术")) //取患者模型的数据
				if (PInfoItem="")||(PInfoItem="[]")
				{
					s flag=0
				}
				else
				{
					s PInfoItem=[].%FromJSON(PInfoItem)
					for i=0:1:(PInfoItem.%Size()-1)  //遍历条件判断是否满足
					{
						s DataValue=$tr((PInfoItem.%Get(i)).%Get("OperName"),"""","'")  //手术名称
						s OperClass=$tr((PInfoItem.%Get(i)).%Get("OperClass"),"""","'")  //手术类型
						if (DataValue'="")&((OperClass="择期")||(OperClass="急诊"))
						{
							s flag=1
							s ^TMPIdentifyW(PatientInfo,"PTableName")="WDT.CDSS.OperationInfo"
							s ^TMPIdentifyW(PatientInfo,"PTableName","PFiledName") = "OperName"
							s ^TMPIdentifyW(PatientInfo,"PTableName","PFiledName","PFiledValue")="Todo"
						}
						q:flag=1
					}
				}	
			}
			
			if ($match(WordsDesc,".级手术"))
			{
				s PInfoItem=$g(^TempPInfoItemData($j,PatientInfo,"手术")) //取患者模型的数据
				if (PInfoItem="")||(PInfoItem="[]")
				{
					s flag=0
				}
				else
				{
					s flag=0
					s PInfoItemJson=[].%FromJSON(PInfoItem)
					for PInfoItemIndex=0:1:PInfoItemJson.%Size()-1
					{
						s OperLevel=PInfoItemJson.%Get(PInfoItemIndex).%Get("OperLevel")   //患者模型中存在此分级
						if OperLevel'=""
						{
							if WordsDesc[OperLevel
							{
								s flag=1
								q
							}
						}
						s OperName=PInfoItemJson.%Get(PInfoItemIndex).%Get("OperName")
						if $d(^CT.WDT.CDSS.IdentifyWIndexI("TypeIWNameIndex","手术",IWRowId,OperName))
						{
							s flag=1
						}
						
					}
					

				}
				if flag=1
				{
					s ^TMPIdentifyW(PatientInfo,"PTableName","PFiledName")="OperLevel"
					s ^TMPIdentifyW(PatientInfo,"PTableName")="WDT.CDSS.OperationInfo"
					s ^TMPIdentifyW(PatientInfo,"PTableName","PFiledName","PFiledValue")=WordsDesc
				}

			}

		}
		elseif(WordsState'="已上线")&(WordsState'="审核通过")
		{
			s flag=0
		}
		else
		{
			s flag=..DealIdentifyWords(IWRowId,PatientInfo)
		}
		
		if (flag=1)
		{
			if ((PatientDR'="")&&(VisitID'="")&&('$d(^WDT.CDSS.PatTriggerIWI("PatVisTypeIWIndex",PatientDR,VisitID,VisitType,IWRowId)))&&((IDNO'="")&&('$d(^WDT.CDSS.PatTriggerIWI("IDNOIWIndex",IDNO,IWRowId)))))
			{
				
				Ts
				s obj=##class(WDT.CDSS.PatTriggerIW).%New()
				s obj.IDNO=IDNO
				s obj.PatientDR=PatientDR
				s obj.VisitID=VisitID
				s obj.VisitType=VisitType
				d obj.IdentifyWordsDRSetObjectId(IWRowId)
				s obj.PTableNameStr=$g(^TMPIdentifyW(PatientInfo,"PTableName"))
				s obj.PFiledNameStr=$g(^TMPIdentifyW(PatientInfo,"PTableName","PFiledName"))
				s obj.PFiledValueStr=$g(^TMPIdentifyW(PatientInfo,"PTableName","PFiledName","PFiledValue"))
				s FlagStr=$g(^TMPIdentifyW(PatientInfo,"PTableName","PFiledName","PFiledValue","Flag"))
				s OldFlag=$p(FlagStr,"^",1)
				s NewFlag=$p(FlagStr,"^",2)
				s AllFlag=$p(FlagStr,"^",3)
				if (OldFlag=1)&(NewFlag=1)
				{
					s obj.PFiledValueFlagStr="origin&new&all"
				}
				elseif (OldFlag=1)
				{
					s obj.PFiledValueFlagStr="origin&all"
				}
				elseif (NewFlag=1)
				{
					s obj.PFiledValueFlagStr="new&all"
				}
				else 
				{
					s obj.PFiledValueFlagStr="all"
				}
				
				s sc=obj.%Save()
                d obj.%Close()
                If $$$ISOK(sc)
	            {
	                Tc
	                s id = obj.%Id()
	                //保存日志
					//d ##class(web.CDSS.Config.DataChangeLog).SaveLog("PatTriggerIW","WDT.CDSS.PatTriggerIW","患者当前触发的识别词",id,obj.IDNO,"A",obj)
				}
	            else
	            {
		            //w ##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc),!
	                Trollback
	                s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	                //s logid=##class(web.DHCBL.MKB.SysErrorLog).SaveLog("患者当前触发的识别词","web.CDSS.MedicalRule.DiagAndTreatR","SaveData",obj)
	       	    	//s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	            }
	            
	            k ^TMPIdentifyW(PatientInfo)
			}
		}
		else
		{
			
			s PatIWRowId=""
			if (PatientDR'="")&&(VisitID'="")&&$d(^WDT.CDSS.PatTriggerIWI("PatVisTypeIWIndex",PatientDR,VisitID,VisitType,IWRowId))
			{
				s PatIWRowId=$O(^WDT.CDSS.PatTriggerIWI("PatVisTypeIWIndex",PatientDR,VisitID,VisitType,IWRowId,""))
			}
			elseif (IDNO'="")&&$d(^WDT.CDSS.PatTriggerIWI("IDNOIWIndex",IDNO,IWRowId))
			{
				s PatIWRowId=$O(^WDT.CDSS.PatTriggerIWI("IDNOIWIndex",IDNO,IWRowId,""))
			}
			if (PatIWRowId'="")
			{
				s delsc=##class(WDT.CDSS.PatTriggerIW).%DeleteId(PatIWRowId)
			}
		}
	}
	

	
	if DiseaseFlag'=""
	{
		s PatientInfo=PatientInfo_"^"_DiseaseFlag
	}
	d ##class(web.CDSS.MedicalRule.GetPatientRule).GetSatisfyRule(PatientInfo,RecomType,ProVision, RuleId) //更新患者当前触发的规则
	job ##class(web.CDSS.IdentifyWords.GetPatientIW).UpdatePMTypeIndex(PatientInfo)  //更新患者汇总信息索引表d ##class(web.CDSS.IdentifyWords.GetPatientIW).UpdatePMTypeIndex(PatientInfo)  //更新患者汇总信息索引表
	k ^TempPInfoItemData($j,PatientInfo)
	
	q 1
}

ClassMethod OperLevel(ByRef IWArray, ByRef OperLevelValueMap, OperLevel As %String, OperName As %String)
{
	s OperIW=""
	s OperLevelMap={"一级":"一级手术","二级":"二级手术","三级":"三级手术","四级":"四级手术"}
	if (OperLevel'="")
	{
		s OperLevel=OperLevelMap.%Get(OperLevel)
		if ($d(^CT.WDT.CDSS.IdentifyWordsI("DescIndex"," "_OperLevel)))
		{
			s OperIW=$o(^CT.WDT.CDSS.IdentifyWordsI("DescIndex"," "_OperLevel,""))
		}
	}
	
	if OperIW=""    //患者没有手术等级
	{
		s IWRowId=0
		for 
		{
			s IWRowId=$o(^CT.WDT.CDSS.IdentifyWIndexI("TypeNameIWIndex","手术",OperName,IWRowId)) q:IWRowId=""
			s IWDesc=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(IWRowId)),3)
			if $match(IWDesc,".级手术")
			{
				d OperLevelValueMap.%Set(IWDesc,OperName)
			}
			s IWArray(IWRowId)=""
		}
	}
	else    //患者有手术等级
	{
		s IWRowId=0
		for 
		{
			s IWRowId=$o(^CT.WDT.CDSS.IdentifyWIndexI("TypeNameIWIndex","手术",OperName,IWRowId)) q:IWRowId=""
			s IWDesc=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(IWRowId)),3)
			continue:$match(IWDesc,".级手术")
			s IWArray(IWRowId)=""
		}
		s IWArray(OperIW)=""
		d OperLevelValueMap.%Set(OperLevel,OperName)
	}
}

/// Creator:李得原
/// CreatDate:2023-02-09
/// Description:处理公式类型时序问题
/// Table: CT.WDT.CDSS.WordsItem
/// Input: PatientInfo ：患者信息
/// Return:成功返回1，失败返回0
/// Others:w ##class(web.CDSS.IdentifyWords.GetPatientIW).DealFormulaOrder
ClassMethod DealFormulaOrder(ConditionID As %String, TimeOrder As %String, PatientInfo As %String)
{
	s Result=""
	s FormulaConditionValue=$lg($g(^CT.WDT.CDSS.WordsConditionD(ConditionID)),9)  //规则值
	s FormulaConditionUnit=$lg($g(^CT.WDT.CDSS.WordsConditionD(ConditionID)),10)
	s FormulaConditionTypeDR= $lg($g(^CT.WDT.CDSS.WordsConditionD(ConditionID)),3)
	s FormulaConditionType=$lg($g(^CT.WDT.CDSS.WordsItemD(FormulaConditionTypeDR)),5) //项目类型
	s FormulaConditionDesc=$lg($g(^CT.WDT.CDSS.WordsItemD(FormulaConditionTypeDR)),3)
	s FormulaConditionTable=$lg($g(^CT.WDT.CDSS.WordsItemD(FormulaConditionTypeDR)),6)

	if FormulaConditionDesc="生命体征名称"
	{
		s FormulaConditionType="体征"
		s CommonDictRowid=$o(^CT.WDT.CDSS.CommonDictI("DescIndex"," "_FormulaConditionValue,""))
		s CommonDictDescEn=$lg($g(^CT.WDT.CDSS.CommonDictD(CommonDictRowid)),10)
		s FormulaConditionFields=CommonDictDescEn
	}
	if FormulaConditionDesc'="生命体征名称"
	{
		s FormulaFieldsRowid=$o(^CT.WDT.CDSS.WordsItemI("ParTypeIdx",FormulaConditionType,-100000000000000,0))
		s FormulaConditionFields=$lg($g(^CT.WDT.CDSS.WordsItemD(FormulaFieldsRowid)),7)
	}
	
	for FormulaIndex=1:1:$l(FormulaConditionFields,"&")
	{
		s FormulaConditionField=$p(FormulaConditionFields,"&",FormulaIndex)
		if $d(^TempPInfoItemData($j,PatientInfo,FormulaConditionType,FormulaConditionField,FormulaConditionValue))
		{
			if (TimeOrder="最新")||(TimeOrder="")
			{
				s TheOrderTime=$o(^TempPInfoItemData($j,PatientInfo,FormulaConditionType,FormulaConditionField,FormulaConditionValue,""),-1)
			}
			elseif TimeOrder="次新"
			{
				s TheOrderTime=""
				s TheOrderTime=$o(^TempPInfoItemData($j,PatientInfo,FormulaConditionType,FormulaConditionField,FormulaConditionValue,TheOrderTime),-1)
				s TheOrderTime=$o(^TempPInfoItemData($j,PatientInfo,FormulaConditionType,FormulaConditionField,FormulaConditionValue,TheOrderTime),-1)
			}
			elseif TimeOrder="初始"
			{
				s TheOrderTime=$o(^TempPInfoItemData($j,PatientInfo,FormulaConditionType,FormulaConditionField,FormulaConditionValue,""))
			}
			
			if TheOrderTime'=""
			{
				s ValueResultStr=$g(^TempPInfoItemData($j,PatientInfo,FormulaConditionType,FormulaConditionField,FormulaConditionValue,TheOrderTime))
				s ValueResult=$p(ValueResultStr,"&*",1)
				s ValueResultUnit=$p(ValueResultStr,"&*",2)
				s Coef=##class(web.CDSS.CMKB.UnitConversion).GetConversion(FormulaConditionUnit,ValueResultUnit)
				if (Coef'="")&(ValueResult'="")
				{
					s ValueResult=ValueResult*Coef
				}
			}
			if $g(ValueResult)=""
			{
				continue
			}
			else
			{
				s Result=ValueResult
			}
		}
	}
	q Result
}

/// Creator:丁亚男
/// CreatDate:2021-08-02
/// Description:判断对应识别词的条件是否满足
/// Table: web.CDSS.CMKB.IdentifyWords
/// Input: CT.WDT.CDSS.IdentifyWords ：WordsDesc 识别词描述，PatientInfo ：患者信息
/// Return:满足返回1，不满足返回0
/// Others:w ##class(web.CDSS.IdentifyWords.GetPatientIW).DealIdentifyWords("91190","DM000780^DM000780^1^住院^TMPAPI5533^TMPAPI5533^^1")
ClassMethod DealIdentifyWords(WordsRowId As %String, PatientInfo As %String) As %String
{
	/*s WordsRowId=$o(^CT.WDT.CDSS.IdentifyWordsI("DescTypeIndex",WordsDesc,"识别词",0))
	q:WordsRowId="" 0 */
	/*触发范围按照生成索引来控制
	s WordsState=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),5)
	q:WordsState'="已上线" 0*/
	s FinalFlag=0
	s IWFlag=0
	s FlowChartNum="" //顺序号
	for
	{
		s FlowChartNum=$o(^CT.WDT.CDSS.WordsNodeI("WordsDRTypeIndex",WordsRowId,FlowChartNum)) q:(FlowChartNum="")||(FinalFlag=1) //流程图顺序号
		k ^TMPIdentifyW(PatientInfo)
		s SatisfyFlag="" //满足规则的标志
		s NodeType=""
		for
		{   
			s NodeType=$o(^CT.WDT.CDSS.WordsNodeI("WordsDRTypeIndex",WordsRowId,FlowChartNum,NodeType)) q:(NodeType="")||(SatisfyFlag=0)  //节点类型
			s NodeTypeDesc=$lg($g(^CT.WDT.CDSS.NodeTypeD(NodeType)),3) //节点类型描述
			if (NodeTypeDesc="基本信息-年龄")||(NodeTypeDesc="基本信息-性别")||(NodeTypeDesc="主要条件-识别词")||(NodeTypeDesc="否定条件-识别词")
			{
				s NodeRowId=""
				for
				{
					s NodeRowId=$o(^CT.WDT.CDSS.WordsNodeI("WordsDRTypeIndex",WordsRowId,FlowChartNum,NodeType,NodeRowId)) q:(NodeRowId="")||(SatisfyFlag=0) //节点
					s MeetConditionNum=$lg($g(^CT.WDT.CDSS.WordsNodeD(NodeRowId)),6)  //该节点下需要满足的条件个数
					S:MeetConditionNum="" MeetConditionNum=1
					s CurMeetConditionNum=0
					//遍历条件 是否满足
					s ConditionRowId=0
					for
					{    
						s ConditionRowId = $o(^CT.WDT.CDSS.WordsConditionI("NodeParentIndex",NodeRowId,-100000000000000,ConditionRowId)) q:(ConditionRowId="")||(CurMeetConditionNum=MeetConditionNum)||(SatisfyFlag=0)  //触发条件类节点内容
						s WordsItemDR  = $lg($g(^CT.WDT.CDSS.WordsConditionD(ConditionRowId)),3) //（识别词项目-一级节点）
						s ItemType="",TableName="",FiledName="",Remarks="", ItemDesc=""
						
						if (WordsItemDR'="")
						{
							s ItemType=$lg($g(^CT.WDT.CDSS.WordsItemD(WordsItemDR)),5)		//项目类型
							s ItemDesc=$lg($g(^CT.WDT.CDSS.WordsItemD(WordsItemDR)),3)		//项目名称
							s TableName=$lg($g(^CT.WDT.CDSS.WordsItemD(WordsItemDR)),6)		//关联表名
							s FiledName=$lg($g(^CT.WDT.CDSS.WordsItemD(WordsItemDR)),7)		//关联字段名
							s Remarks=$lg($g(^CT.WDT.CDSS.WordsItemD(WordsItemDR)),11)		//备注
						}
						
						s ConditionClass  = $lg($g(^CT.WDT.CDSS.WordsConditionD(ConditionRowId)),6) //条件类型（年龄/性别/诊断/手术/检查/检验/护理/输血/症状/体征/等）
						s ConditionItem  = $lg($g(^CT.WDT.CDSS.WordsConditionD(ConditionRowId)),7) //规则条件对应字段名称
						s ConditionItemCalculate  = $lg($g(^CT.WDT.CDSS.WordsConditionD(ConditionRowId)),8) //运算符
						s ConditionItemValue  = $lg($g(^CT.WDT.CDSS.WordsConditionD(ConditionRowId)),9)  //规则条件值
						continue:(ConditionItemValue="")  //不存在患者信息 默认不满足
						s ConditionItemValUnit  = $lg($g(^CT.WDT.CDSS.WordsConditionD(ConditionRowId)),10) //规则条件值单位
						s ConditionItemValUnitN=""
						s:ConditionItemValUnit'="" ConditionItemValUnitN= $lg($g(^CT.WDT.CDSS.UnitDictD(ConditionItemValUnit)),3)
						if (NodeTypeDesc="基本信息-性别")
						{
							s ItemType=ConditionClass
							s FiledName=ConditionItem
						}
						if (ConditionItem="Age")
						{
							//s ConditionItemValue= $lg($g(^CT.WDT.CDSS.RuleConditionD(ConditionRowId)),9)  //备注 年龄(天)
							//很多备注没有按照要求保存
							s ConditionItemValue=##class(web.CDSS.CMKB.FunLib).TransforDateFormat(ConditionItemValue,ConditionItemValUnitN)	
							s ItemType="年龄(天)"
							s FiledName=ConditionItem
						}
						
						if ItemDesc="公式"
						{
							//(【491494】<最新>-【491494】<次新>)/【491494】<最新>
							s BreakFlag=0
							s FormulaMap={}
							s ConditionRemarks = $lg($g(^CT.WDT.CDSS.WordsConditionD(ConditionRowId)),11)
							set FillMatcher=##class(%Regex.Matcher).%New("】(?!<)")
							s FillMatcher.Text=ConditionRemarks
							s ConditionRemarks=FillMatcher.ReplaceAll("】<>")

							s Matcher =##class(%Regex.Matcher).%New("【.*?>")
							s Matcher.Text=ConditionRemarks
							while Matcher.Locate()
							{
								s group = Matcher.Group
								s NumMatcher=##class(%Regex.Matcher).%New("\d{1,10}")
								s NumMatcher.Text=group
								d NumMatcher.Locate()
								s OrderMatcher = ##class(%Regex.Matcher).%New("(?<=<).*?(?=>)")
								s OrderMatcher.Text=group
								d OrderMatcher.Locate()
								s ConditionID = NumMatcher.Group   //condition ID
								s OrderCondition = OrderMatcher.Group // 次序

								s FormulaValue=..DealFormulaOrder(ConditionID,OrderCondition,PatientInfo)
								if FormulaValue=""  //FormulaValue=""不满足条件
								{
									s BreakFlag=1
									q
								}
								s ConditionRemarks= $replace(ConditionRemarks,group,FormulaValue)
								
							}
							if BreakFlag=1
							{
								continue
							}
							
							
							s ChildRowid=0
							for
							{
								s ChildRowid=$o(^CT.WDT.CDSS.WordsConditionI("ParentIndex",ConditionRowId,ChildRowid))
								q:ChildRowid=""
								s ChildCalculate=$lg($g(^CT.WDT.CDSS.WordsConditionD(ChildRowid)),8)
								s ChildValue=$lg($g(^CT.WDT.CDSS.WordsConditionD(ChildRowid)),9)
								s PreValue=$p(ChildValue,"&&",1)
								s PostValue=$p(ChildValue,"&&",2)
								s PreCal=$p(ChildCalculate,"&&",1)
								s PostCal=$p(ChildCalculate,"&&",2)
								try
								{
									if (PreValue'="")&(PreCal'="")
									{
										if @(ConditionRemarks_PreCal_PreValue)
										{
											s PreFlag=1
										}
									}
								}
								catch e
								{
									s PreFlag=0
								}
								
								try
								{
									if (PostValue'="")&(PostCal'="")
									{
										
										if @(ConditionRemarks_PostCal_PostValue)
										{
											s PostFlag=1
										}
									}
								}
								catch e
								{
									s PostFlag=0
								}
							}
							
							if ($g(PreValue)'="")&($g(PostValue)'="")
							{
								if ($g(PreFlag,0)=1)&($g(PostFlag,0)=1)
								{
									do MeetCondtionNum
								}
							}
							elseif $g(PreValue)'=""
							{
								if ($g(PreFlag,0)=1)
								{
									do MeetCondtionNum
								}
							}
							else
							{
								if ($g(PostFlag,0)=1)
								{
									do MeetCondtionNum
								}
							}

						}
						
						elseif (ItemType="体征")  //体征单独处理
						{
							s PareConditionSatisfyFlag=0
							if ($d(^TempPInfoItemData($j,PatientInfo,"体征",ConditionItemValue)))
							{
								s CommonRowId=$o(^CT.WDT.CDSS.CommonDictI("DescIndex"," "_$ZCONVERT(ConditionItemValue,"U"),0))
								s EnCommonName="",DictDesc=""
								s:CommonRowId'="" EnCommonName=$lg($g(^CT.WDT.CDSS.CommonDictD(CommonRowId)),10)        //通用名英文名称 体重 Weight
								s:CommonRowId'="" DictDesc=$lg($g(^CT.WDT.CDSS.CommonDictD(CommonRowId)),4)  
								s ItemType=ConditionItemValue
								s FiledName=EnCommonName
							
								s PareConditionSatisfyFlag=1
								s PTableName=TableName
								s PFiledName=FiledName
								s PFiledValue=EnCommonName
								
								s ChildFlag=..DealChildConditon(ConditionRowId,NodeRowId,PatientInfo)  //体征信息的子节点需要再次读取患者信息的数据
								s OldFlag=0
								s NewFlag=1
								s AllFlag=1
								if (ChildFlag)
								{
									do MeetCondtionNum
								}
								 
							}
						
						}
						elseif(ItemType="过敏史") //药物过敏时支持药物通用名、别名、化学名、商品名、药物类、成分的匹配
						{
							if (ConditionItemValue'="")
							{
								s drugid=$o(^CT.WDT.CDSS.DrugDictI("NameIndex"," "_$ZCONVERT(ConditionItemValue,"U"),""))
								s DrugAlias="",DrugCategory="",DrugChemicalName="",DrugComposition="",DrugTradeName=""
								if (drugid'="")
								{
									s DrugAlias=$lg($g(^CT.WDT.CDSS.DrugDictD(drugid)),25)	//别名
									s DrugCategory=$lg($g(^CT.WDT.CDSS.DrugDictD(drugid)),26)	//药物类
									s DrugChemicalName=$lg($g(^CT.WDT.CDSS.DrugDictD(drugid)),27)	//化学名
									s DrugComposition=$lg($g(^CT.WDT.CDSS.DrugDictD(drugid)),28)	//成分
									s DrugTradeName=$lg($g(^CT.WDT.CDSS.DrugDictD(drugid)),29)	//商品名
								}
								s PInfoItem=$g(^TempPInfoItemData($j,PatientInfo,ItemType)) //取患者模型的数据，并且预处理 后期优化2021-08-02 By Dingyanan
							    
								if (PInfoItem="")||(PInfoItem="[]")  //所需类型信息在患者模型中不存在时，继续下一条规则条件的判断
								{
									//s SatisfyFlag=0  //不满足
									continue 
								}
								
								//s PInfoItem=[].%FromJSON(PInfoItem)
								s PareConditionSatisfyFlag=0 //父条件是否满足
								s ChildFlag=""  //子节点满足标志
								s lenFiledName=$length(FiledName,"&")
								for jFiled=1:1:lenFiledName
								{
									s ItemName=$p(FiledName,"&",jFiled)
										//w (PInfoItem.%Get(i)).%Get(ItemName)_ConditionItemCalculate_ConditionItemValue ,!
									s AllergyValue=""
									if ($d(^TempPInfoItemData($j,PatientInfo,ItemType,ItemName,ConditionItemValue)))
									{
										s PareConditionSatisfyFlag=1
										s AllergyValue=ConditionItemValue
									}
									elseif((DrugAlias'="")&&$d(^TempPInfoItemData($j,PatientInfo,ItemType,ItemName,DrugAlias)))
									{
										s PareConditionSatisfyFlag=1
										s AllergyValue=DrugAlias
									}
									elseif((DrugCategory'="")&&$d(^TempPInfoItemData($j,PatientInfo,ItemType,ItemName,DrugCategory)))
									{
										s PareConditionSatisfyFlag=1
										s AllergyValue=DrugCategory
									}
									elseif((DrugChemicalName'="")&&$d(^TempPInfoItemData($j,PatientInfo,ItemType,ItemName,DrugChemicalName)))
									{
										s PareConditionSatisfyFlag=1
										s AllergyValue=DrugChemicalName
									}
									elseif((DrugComposition'="")&&$d(^TempPInfoItemData($j,PatientInfo,ItemType,ItemName,DrugComposition)))
									{
										s PareConditionSatisfyFlag=1
										s AllergyValue=DrugComposition
									}
									elseif((DrugTradeName'="")&&$d(^TempPInfoItemData($j,PatientInfo,ItemType,ItemName,DrugTradeName)))
									{
										s PareConditionSatisfyFlag=1
										s AllergyValue=DrugTradeName
									}
									
									
									if (PareConditionSatisfyFlag=1)	
									{
										s ChildFlagStr=$$ChildCondtion(ConditionRowId, NodeRowId,ItemName)
										s ChildFlag=$p(ChildFlagStr,"^",1)
										s OldFlag=0
										s NewFlag=1
										s AllFlag=1
										if (ChildFlag)
										{
											s PTableName={}.%FromJSON(($g(^TempPInfoItemData($j,PatientInfo,ItemType,ItemName,AllergyValue)))).%Get("TableName")
											s PFiledName=ItemName
											s PFiledValue={}.%FromJSON(($g(^TempPInfoItemData($j,PatientInfo,ItemType,ItemName,AllergyValue)))).%Get(ItemName)
											do MeetCondtionNum
										}
										q:ChildFlag=1
									}
									q:ChildFlag=1
								}
							
							}
							else
							{
								s PareConditionSatisfyFlag=0 //父条件是否满足	
							}
						}
						else
						{ 
							s:ItemType="" ItemType="空"
							s PInfoItem=$g(^TempPInfoItemData($j,PatientInfo,ItemType)) //取患者模型的数据，并且预处理 后期优化2021-08-02 By Dingyanan

							s PareConditionSatisfyFlag=0 //父条件是否满足
							s ChildFlag=""  //子节点满足标志
							if (PInfoItem="")||(PInfoItem="[]")  //所需类型信息在患者模型中不存在时，继续下一条规则条件的判断
							{
								//s SatisfyFlag=0  //不满足
								continue 
							}
							
							//s PInfoItem=[].%FromJSON(PInfoItem)
							
							//continue:(ConditionItemCalculate'="<")&(ConditionItemCalculate'="<=")&(ConditionItemCalculate'="=")&(ConditionItemCalculate'=">=")&(ConditionItemCalculate'=">")
							
							if (ConditionItemCalculate="=")
							{
								s lenFiledName=$length(FiledName,"&")
								for jFiled=1:1:lenFiledName
								{
									s ItemName=$p(FiledName,"&",jFiled)
									continue:(ConditionItemValue="")  //不存在患者信息 默认不满足
									if $d(^TempPInfoItemData($j,PatientInfo,ItemType,ItemName,ConditionItemValue))
									{
										s OrderFlag=..CheckExecutedOrderFilter(NodeRowId,ConditionRowId,ItemName,ConditionItemValue,PatientInfo,ItemType)
										
										if OrderFlag="0"
										{
											s PareConditionSatisfyFlag=0
										}
										else
										{
											s PareConditionSatisfyFlag=1
											s ChildFlagStr=$$ChildCondtion(ConditionRowId, NodeRowId,ItemName,ConditionItemValue)
											s ChildFlag=$p(ChildFlagStr,"^",1)
											s OldFlag=$p(ChildFlagStr,"^",2)
											s NewFlag=$p(ChildFlagStr,"^",3)
											s AllFlag=$p(ChildFlagStr,"^",4)
											if (ChildFlag)
											{
												s PTableName={}.%FromJSON(($g(^TempPInfoItemData($j,PatientInfo,ItemType,ItemName,ConditionItemValue)))).%Get("TableName")
												s PFiledName=ItemName
												s PFiledValue={}.%FromJSON(($g(^TempPInfoItemData($j,PatientInfo,ItemType,ItemName,ConditionItemValue)))).%Get("ProjectName")
												if PFiledValue=""
												{
													s PFiledValue=ConditionItemValue
												}
												
												do MeetCondtionNum
											}
										}
									}
									
									if ConditionItemValue="全部手术"
									{
										if $d(^TempPInfoItemData($j,PatientInfo,ItemType))
										{
											s ItemValue = ""
											for
											{
												s ItemValue=$o(^TempPInfoItemData($j,PatientInfo,ItemType,ItemName,ItemValue))
												q:ItemValue=""
												
												s PareConditionSatisfyFlag=1
												s ParentConditionItemValue=ItemValue //父节点规则条件值
												
												s ChildFlagStr=$$ChildCondtion(ConditionRowId, NodeRowId,ItemName,ItemValue)
												s ChildFlag=$p(ChildFlagStr,"^",1)
												s OldFlag=0
												s NewFlag=1
												s AllFlag=1
												if (ChildFlag)
												{
													s ConditionItemValue=ItemValue
													s PTableName={}.%FromJSON(($g(^TempPInfoItemData($j,PatientInfo,ItemType,ItemName,ConditionItemValue)))).%Get("TableName")
													s PFiledName=ItemName
													s PFiledValue={}.%FromJSON(($g(^TempPInfoItemData($j,PatientInfo,ItemType,ItemName,ConditionItemValue)))).%Get("ProjectName")
													
													do MeetCondtionNum
													q
												}
											}

										}
									}
										
									q:ChildFlag=1
								}	
								continue:ChildFlag=1
							}
							else
							{
								s lenFiledName=$length(FiledName,"&")
								for jFiled=1:1:lenFiledName
								{
									s ItemName=$p(FiledName,"&",jFiled)
									s DataValue=""
									for 
									{
										s DataValue=$O(^TempPInfoItemData($j,PatientInfo,ItemType,ItemName,DataValue)) q:DataValue=""
										if @(""""_DataValue_""""_ConditionItemCalculate_""""_$tr(ConditionItemValue,"""","'")_"""")
										{
											s OrderFlag = ..CheckExecutedOrderFilter(NodeRowId, ConditionRowId, ItemName, ConditionItemValue,PatientInfo,ItemType)
											
											if OrderFlag="0"
											{
												s PareConditionSatisfyFlag=0
											}
											else
											{
												s PareConditionSatisfyFlag=1
												s ChildFlagStr=$$ChildCondtion(ConditionRowId, NodeRowId,ItemName)
												s ChildFlag=$p(ChildFlagStr,"^",1)
												s OldFlag=$p(ChildFlagStr,"^",2)
												s NewFlag=$p(ChildFlagStr,"^",3)
												s AllFlag=$p(ChildFlagStr,"^",4)
												if (ChildFlag)
												{
													s ItemJsonStr = {}.%FromJSON(($g(^TempPInfoItemData($j,PatientInfo,ItemType,ItemName,DataValue))))
													s PFiledName=ItemName
													if ItemJsonStr.%IsDefined("ProjectName")
													{
														s PTableName=ItemJsonStr.%Get("TableName")
														s PFiledValue=ItemJsonStr.%Get("ProjectName")
													}
													elseif ItemName="Age"
													{
														
														s PTableName=ItemJsonStr.%Get("TableName")
														//s PFiledValueStr=##class(web.CDSS.IdentifyWords.GetPatientInfo).DealDataByPatientEnumI(PatientInfo,"年龄")
														
														s PFiledValueStr=$g(^TempPInfoItemData($j,PatientInfo,"年龄"))
														if (PFiledValueStr'="")||(PFiledValueStr'="[]") 
														{
															s PFiledValueJson = [].%FromJSON(PFiledValueStr)
															s PFiledValue = PFiledValueJson.%Get(0).%Get(ItemName)
														}
														else
														{
															s PFiledValue = ""
														}
														
													}
													else
													{
														s PTableName=ItemJsonStr.%Get("TableName")
														s PFiledValue=ItemJsonStr.%Get("ItemName")
													}
													do MeetCondtionNum
												}
											}

										}
										
										q:ChildFlag=1
									}
										
									q:ChildFlag=1
								}
								
							}
							
						}
						if (PareConditionSatisfyFlag'=1) //父节点不满足
						{
							if (NodeTypeDesc="基本信息-年龄")||(NodeTypeDesc="基本信息-性别")
							{
								s SatisfyFlag=0
							}		
						}
						
					}
					
					if ((CurMeetConditionNum<MeetConditionNum)&(NodeTypeDesc'="否定条件-识别词"))||((CurMeetConditionNum>=MeetConditionNum)&(NodeTypeDesc="否定条件-识别词"))  //当前节点没有满足条件
					{
						s SatisfyFlag=0
					}
					else
					{
						s SatisfyFlag=1
					}
					
				}
			}
		}
		if (SatisfyFlag=1)
		{
			s FinalFlag=1
		}
	}
	q FinalFlag
MeetCondtionNum   //判断父节点满足条件数及留痕
	s CurMeetConditionNum=CurMeetConditionNum+1
	s ^TMPIdentifyW(PatientInfo,"PTableName")=$g(^TMPIdentifyW(PatientInfo,"PTableName"))_"&"_PTableName
	s ^TMPIdentifyW(PatientInfo,"PTableName","PFiledName")=$g(^TMPIdentifyW(PatientInfo,"PTableName","PFiledName"))_"&"_PFiledName
	s ^TMPIdentifyW(PatientInfo,"PTableName","PFiledName","PFiledValue")=$g(^TMPIdentifyW(PatientInfo,"PTableName","PFiledName","PFiledValue"))_"&"_PFiledValue
	s ^TMPIdentifyW(PatientInfo,"PTableName","PFiledName","PFiledValue","Flag")=$g(OldFlag)_"^"_$g(NewFlag)_"^"_$g(AllFlag)

ChildCondtion(ParentDR,NodeDR,ItemName,PName)   //判断子节点是否满足
	s ChildSFlag=0 //子条件是否满足
	s OldFlag=0
	s NewFlag=0
	s AllFlag=0
	if ('$d(^CT.WDT.CDSS.WordsConditionI("NodeParentIndex",NodeDR,ParentDR)))
	{
		s ChildSFlag=1
		s NewFlag=1
		s AllFlag=1
	}
	else
	{
		s ParentWordsItemDR  = $lg($g(^CT.WDT.CDSS.WordsConditionD(ParentDR)),3) //（识别词项目）
		if (ParentWordsItemDR'="")
		{
			s ParentItemType=$lg($g(^CT.WDT.CDSS.WordsItemD(ParentWordsItemDR)),5)		//项目类型
		}
		s ParentConditionItemValue  = $lg($g(^CT.WDT.CDSS.WordsConditionD(ParentDR)),9)  //父节点规则条件值
		if ParentConditionItemValue="全部手术"
		{
			s ParentConditionItemValue=PName
		}
		
		
		//2023-04-14 触发识别词old new orgin
		s CurrentPInfoItemArray=[]
		if (ParentItemType="检验")||(ParentItemType="检验结果")||(ParentItemType="检查")||(ParentItemType="检查检验结果")||(ParentItemType="护理结果")
		{
			s LastReportTime=""
			s ReportTime=""
			if $d(^TempPInfoItemData($j,PatientInfo,ParentItemType,ItemName,ParentConditionItemValue,"ReportTime"))
			{
				s ReportTime=""
				for
				{
					s ReportTime=$o(^TempPInfoItemData($j,PatientInfo,ParentItemType,ItemName,ParentConditionItemValue,"ReportTime",ReportTime))
					q:ReportTime=""
					s CurrentItem = ^TempPInfoItemData($j,PatientInfo,ParentItemType,ItemName,ParentConditionItemValue,"ReportTime",ReportTime)
					s CurrentItem={}.%FromJSON(CurrentItem)
					d CurrentPInfoItemArray.%Push(CurrentItem)
				}
			}
		}
		else
		{
			s CurrentItem=	{}.%FromJSON($g(^TempPInfoItemData($j,PatientInfo,ParentItemType,ItemName,ParentConditionItemValue)))			
			d CurrentPInfoItemArray.%Push(CurrentItem)
		}
		for CurrentIndex=0:1:CurrentPInfoItemArray.%Size()-1
		{
			s CurrentPInfoItem=CurrentPInfoItemArray.%Get(CurrentIndex)   //触发识别词old new orgin所用信息	
			
			s ChildSatisfyFlag=""

			s ChildConditionRowId=0
			for
			{
				s ChildConditionRowId = $o(^CT.WDT.CDSS.WordsConditionI("NodeParentIndex",NodeDR,ParentDR,ChildConditionRowId)) q:((ChildConditionRowId="")||(ChildSatisfyFlag=0))  //触发条件类节点内容
				s ChildWordsItemDR  = $lg($g(^CT.WDT.CDSS.WordsConditionD(ChildConditionRowId)),3) //（识别词项目）
				s ChildItemType="",ChildTableName="",ChildFiledName="",ChildRemarks=""
				if (ChildWordsItemDR'="")
				{
					s ChildWordsItemDesc=$lg($g(^CT.WDT.CDSS.WordsItemD(ChildWordsItemDR)),3)
					s ChildItemType=$lg($g(^CT.WDT.CDSS.WordsItemD(ChildWordsItemDR)),5)		//项目类型
					s ChildTableName=$lg($g(^CT.WDT.CDSS.WordsItemD(ChildWordsItemDR)),6)		//关联表名
					s ChildFiledName=$lg($g(^CT.WDT.CDSS.WordsItemD(ChildWordsItemDR)),7)		//关联字段名
					s ChildRemarks=$lg($g(^CT.WDT.CDSS.WordsItemD(ChildWordsItemDR)),11)		//备注(暂时保存关联字段在关联表的第几个节点)
				}
				if (ParentItemType="体征")
				{
					s ChildItemType=ParentConditionItemValue
					s ChildCommonRowId=$o(^CT.WDT.CDSS.CommonDictI("DescIndex"," "_$ZCONVERT(ParentConditionItemValue,"U"),0))
					s ChildEnCommonName=""
					s:ChildCommonRowId'="" ChildEnCommonName=$lg($g(^CT.WDT.CDSS.CommonDictD(ChildCommonRowId)),10)        //通用名英文名称 体重 Weight
					s ChildFiledName=ChildEnCommonName
				}
				s ChildConditionClass  = $lg($g(^CT.WDT.CDSS.WordsConditionD(ChildConditionRowId)),6) //条件类型（年龄/性别/诊断/手术/检查/检验/护理/输血/症状/体征/等）
				s ChildConditionItem  = $lg($g(^CT.WDT.CDSS.WordsConditionD(ChildConditionRowId)),7) //规则条件对应字段名称
				s ChildConditionItemCalculate  = $lg($g(^CT.WDT.CDSS.WordsConditionD(ChildConditionRowId)),8) //运算符
				s ChildConditionItemValue  = $lg($g(^CT.WDT.CDSS.WordsConditionD(ChildConditionRowId)),9)  //规则条件值
				s ChildConditionItemValUnit  = $lg($g(^CT.WDT.CDSS.WordsConditionD(ChildConditionRowId)),10) //规则条件值单位
				s ChildConditionItemValUnitN=""
				s:ChildConditionItemValUnit'="" ChildConditionItemValUnitN= $lg($g(^CT.WDT.CDSS.UnitDictD(ChildConditionItemValUnit)),3)
				
				s ConditionChildSatisfyFlag="" //条件是否满足
				//当前临床信息

				//s CurrentPInfoItem=	{}.%FromJSON($g(^TempPInfoItemData($j,PatientInfo,ParentItemType,ItemName,ParentConditionItemValue)))	
				if (ChildWordsItemDesc="值")||(ChildWordsItemDesc="剂量单位范围")||(ChildWordsItemDesc="孕周")
				{
					s ChildConditionItemCalculateMin  = $p(ChildConditionItemCalculate,"&&",1) //运算符
					s ChildConditionItemValueMin  =  $p(ChildConditionItemValue,"&&",1)  //规则条件值
					s ChildConditionItemValUnitMin  =  $p(ChildConditionItemValUnit,"&&",1) //规则条件值单位
					s ChildConditionItemValUnitMinN=""
					s:ChildConditionItemValUnitMin'="" ChildConditionItemValUnitMinN= $lg($g(^CT.WDT.CDSS.UnitDictD(ChildConditionItemValUnitMin)),3)
					if (ParentItemType="评估表")
					{
						s coeffMin=1
					}
					else
					{
						s coeffMin=..getValueCoefficient(ChildConditionItemValUnitMinN)
					}
					s:ChildConditionItemValueMin'="" ChildConditionItemValueMin=  ChildConditionItemValueMin*coeffMin
					
					
					s ChildConditionItemCalculateMax  = $p(ChildConditionItemCalculate,"&&",2) //运算符
					s ChildConditionItemValueMax  =  $p(ChildConditionItemValue,"&&",2)  //规则条件值
					s ChildConditionItemValUnitMax  =  $p(ChildConditionItemValUnit,"&&",2) //规则条件值单位
					s ChildConditionItemValUnitMaxN=""
					s:ChildConditionItemValUnitMax'="" ChildConditionItemValUnitMaxN= $lg($g(^CT.WDT.CDSS.UnitDictD(ChildConditionItemValUnitMax)),3)
					if (ParentItemType="评估表")
					{
						s coeffMax=1
					}
					else
					{
						s coeffMax=..getValueCoefficient(ChildConditionItemValUnitMaxN)
					}
					
					s:ChildConditionItemValueMax'="" ChildConditionItemValueMax=  ChildConditionItemValueMax*coeffMax
					
					
					continue:(ChildConditionItemValueMin="")&&(ChildConditionItemCalculateMax="")
					continue:(ChildConditionItemCalculateMin'="<")&(ChildConditionItemCalculateMin'="<=")&(ChildConditionItemCalculateMin'="=")&(ChildConditionItemCalculateMin'=">=")&(ChildConditionItemCalculateMin'=">")
					continue:(ChildConditionItemCalculateMax'="<")&(ChildConditionItemCalculateMax'="<=")&(ChildConditionItemCalculateMax'="=")&(ChildConditionItemCalculateMax'=">=")&(ChildConditionItemCalculateMax'=">")	
					s ConditionChildSatisfyFlag="" //条件是否满足
					if (ChildFiledName["&*")  //需要考虑单位转换
					{
						s ChildFiledName1=$p(ChildFiledName,"&*",1) 
						s ChildUnitName=$p(ChildFiledName,"&*",2) 	
						s ChildFiledName=ChildFiledName1 	
					}
					
					if (CurrentPInfoItem.%Get(ChildFiledName)'="") //取到的值为空
					{
						s ConditionChildSatisfyFlagMin=0,ConditionChildSatisfyFlagMax=0
						
						if (ChildFiledName["&*")  //需要考虑单位转换
						{
							s PUnit=$tr(CurrentPInfoItem.%Get(ChildUnitName),"""","'")
							s coeffUnitMin=##class(web.CDSS.CMKB.UnitConversion).GetConversion(PUnit,ChildConditionItemValUnitMinN)
							s coeffUnitMax=##class(web.CDSS.CMKB.UnitConversion).GetConversion(PUnit,ChildConditionItemValUnitMaxN)
							s ChildConditionItemValueMin= ChildConditionItemValueMin*coeffUnitMin
							s ChildConditionItemValueMax= ChildConditionItemValueMax*coeffUnitMax
									
						}
						s ClinicalData=$tr(CurrentPInfoItem.%Get(ChildFiledName),"""","'")
						
						if ChildWordsItemDesc="孕周"
						{
							s coeffPreg=..getValueCoefficient(ChildConditionItemValUnitMinN)
							s ClinicalData = ClinicalData*coeffPreg
						}
						
						if (ClinicalData[">")
						{
							s ConstrastData=$p(ClinicalData,">",2)-0.0001
						}
						elseif(ClinicalData["<")
						{
							s ConstrastData=$p(ClinicalData,"<",2)+0.0001
						}
						else
						{
							s ConstrastData=ClinicalData
						}
						if (ChildConditionItemValueMin'="")
						{
							if @(""""_ConstrastData_""""_ChildConditionItemCalculateMin_""""_$tr(ChildConditionItemValueMin,"""","'")_"""")
							{
								
								s ConditionChildSatisfyFlagMin=1
							}
						}
						else
						{
							s ConditionChildSatisfyFlagMin=1
						}
						if (ChildConditionItemValueMax'="")
						{
							if @(""""_ConstrastData_""""_ChildConditionItemCalculateMax_""""_$tr(ChildConditionItemValueMax,"""","'")_"""")
							{
								s ConditionChildSatisfyFlagMax=1
							}
						}
						else
						{
							s ConditionChildSatisfyFlagMax=1
						}
						
						if (ConditionChildSatisfyFlagMin=1)&(ConditionChildSatisfyFlagMax=1)
						{
							s ConditionChildSatisfyFlag=1
						}
					}	
					
				}
				elseif (ChildWordsItemDesc="持续时间")||(ChildWordsItemDesc="时间")||((ChildWordsItemDesc="手术持续时间"))  //此处比较都是数值比较，没有时分秒,是时间段
				{
					s ChildConditionItemCalculateMin  = $p(ChildConditionItemCalculate,"&&",1) //运算符
					s ChildConditionItemValueMin  =  $p(ChildConditionItemValue,"&&",1)  //规则条件值
					s ChildConditionItemValUnitMin  =  $p(ChildConditionItemValUnit,"&&",1) //规则条件值单位
					s ChildConditionItemValUnitMinN=""
					s:ChildConditionItemValUnitMin'="" ChildConditionItemValUnitMinN= $lg($g(^CT.WDT.CDSS.UnitDictD(ChildConditionItemValUnitMin)),3)
					s coeffMin=..getCoefficient(ChildConditionItemValUnitMinN)
					s:ChildConditionItemValueMin'="" ChildConditionItemValueMin=  ChildConditionItemValueMin*coeffMin
					
					s ChildConditionItemCalculateMax  = $p(ChildConditionItemCalculate,"&&",2) //运算符
					s ChildConditionItemValueMax  =  $p(ChildConditionItemValue,"&&",2)  //规则条件值
					s ChildConditionItemValUnitMax  =  $p(ChildConditionItemValUnit,"&&",2) //规则条件值单位
					s ChildConditionItemValUnitMaxN=""
					s:ChildConditionItemValUnitMax'="" ChildConditionItemValUnitMaxN= $lg($g(^CT.WDT.CDSS.UnitDictD(ChildConditionItemValUnitMax)),3)
					s coeffMax=..getCoefficient(ChildConditionItemValUnitMaxN)
					s:ChildConditionItemValueMax'="" ChildConditionItemValueMax=  ChildConditionItemValueMax*coeffMax
					
					continue:(ChildConditionItemValueMin="")&&(ChildConditionItemCalculateMax="")
					continue:(ChildConditionItemCalculateMin'="<")&(ChildConditionItemCalculateMin'="<=")&(ChildConditionItemCalculateMin'="=")&(ChildConditionItemCalculateMin'=">=")&(ChildConditionItemCalculateMin'=">")
					continue:(ChildConditionItemCalculateMax'="<")&(ChildConditionItemCalculateMax'="<=")&(ChildConditionItemCalculateMax'="=")&(ChildConditionItemCalculateMax'=">=")&(ChildConditionItemCalculateMax'=">")	
					
					s ConditionChildSatisfyFlag="" //条件是否满足
					
					
					if (CurrentPInfoItem.%Get(ChildFiledName)'="") //取到的值为空
					{
						s ConditionChildSatisfyFlagMin=0,ConditionChildSatisfyFlagMax=0
						//w CurrentPInfoItem.%Get(ChildFiledName),!
						
						if (ChildConditionItemValueMin'="")
						{
							if @(""""_$tr(CurrentPInfoItem.%Get(ChildFiledName),"""","'")_""""_ChildConditionItemCalculateMin_""""_$tr(ChildConditionItemValueMin,"""","'")_"""")
							{
								s ConditionChildSatisfyFlagMin=1
							}
						}
						else
						{
							s ConditionChildSatisfyFlagMin=1
						}
						
						if (ChildConditionItemValueMax'="")
						{
							if @(""""_$tr(CurrentPInfoItem.%Get(ChildFiledName),"""","'")_""""_ChildConditionItemCalculateMax_""""_$tr(ChildConditionItemValueMax,"""","'")_"""")
							{
								s ConditionChildSatisfyFlagMax=1
							}
						}
						else
						{
							s ConditionChildSatisfyFlagMax=1
						}
						
						if (ConditionChildSatisfyFlagMin=1)&(ConditionChildSatisfyFlagMax=1)
						{
							s ConditionChildSatisfyFlag=1
						}
						
						
					}
				
				}
				elseif (ChildWordsItemDesc="手术开始时间")||(ChildWordsItemDesc="手术结束时间")||(ChildWordsItemDesc="就诊时间") //时间格式比较，年月日时分秒
				{
					s ConditionChildSatisfyFlagMin=0,ConditionChildSatisfyFlagMax=0
					s ChildConditionItemCalculateMin  = $p(ChildConditionItemCalculate,"&&",1) //运算符
					s ChildConditionItemValueMin  =  $p(ChildConditionItemValue,"&&",1)  //规则条件值
					s ChildConditionItemValUnitMin  =  $p(ChildConditionItemValUnit,"&&",1) //规则条件值单位
					s ChildConditionItemValUnitMinN=""
					s:ChildConditionItemValUnitMin'="" ChildConditionItemValUnitMinN= $lg($g(^CT.WDT.CDSS.UnitDictD(ChildConditionItemValUnitMin)),3)
					s coeffMin=..getCoefficient(ChildConditionItemValUnitMinN)
					s:ChildConditionItemValueMin'="" ChildConditionItemValueMin=  ChildConditionItemValueMin*coeffMin
					
					s ChildConditionItemCalculateMax  = $p(ChildConditionItemCalculate,"&&",2) //运算符
					s ChildConditionItemValueMax  =  $p(ChildConditionItemValue,"&&",2)  //规则条件值
					s ChildConditionItemValUnitMax  =  $p(ChildConditionItemValUnit,"&&",2) //规则条件值单位
					s ChildConditionItemValUnitMaxN=""
					s:ChildConditionItemValUnitMax'="" ChildConditionItemValUnitMaxN= $lg($g(^CT.WDT.CDSS.UnitDictD(ChildConditionItemValUnitMax)),3)
					s coeffMax=..getCoefficient(ChildConditionItemValUnitMaxN)
					s:ChildConditionItemValueMax'="" ChildConditionItemValueMax=  ChildConditionItemValueMax*coeffMax
					
					continue:(ChildConditionItemValueMin="")&&(ChildConditionItemCalculateMax="")
					continue:(ChildConditionItemCalculateMin'="<")&(ChildConditionItemCalculateMin'="<=")&(ChildConditionItemCalculateMin'="=")&(ChildConditionItemCalculateMin'=">=")&(ChildConditionItemCalculateMin'=">")
					continue:(ChildConditionItemCalculateMax'="<")&(ChildConditionItemCalculateMax'="<=")&(ChildConditionItemCalculateMax'="=")&(ChildConditionItemCalculateMax'=">=")&(ChildConditionItemCalculateMax'=">")	
					
					s ConditionChildSatisfyFlag="" //条件是否满足
					if (CurrentPInfoItem.%Get(ChildFiledName)'="") //取到的值不为空
					{
						s ConditionChildSatisfyFlagMin=0,ConditionChildSatisfyFlagMax=0
						//w CurrentPInfoItem.%Get(ChildFiledName),!
						s NowTime = $zdt($now(),3)
						if (ChildConditionItemValueMin'="")
						{
							s ChildFieldValue=$tr(CurrentPInfoItem.%Get(ChildFiledName),"""","'")   //获取具体时间
							s HoursMin = $system.SQL.DATEDIFF("hour",ChildFieldValue,NowTime)
							s HoursMin = $zabs(HoursMin)
							if @(""""_HoursMin_""""_ChildConditionItemCalculateMin_""""_$tr(ChildConditionItemValueMin,"""","'")_"""")
							{
								s ConditionChildSatisfyFlagMin=1
							}
						}
						else
						{
							s ConditionChildSatisfyFlagMin=1
						}
						
						if (ChildConditionItemValueMax'="")
						{
							s ChildFieldValue=$tr(CurrentPInfoItem.%Get(ChildFiledName),"""","'")
							s HoursMax = $system.SQL.DATEDIFF("hour",ChildFieldValue,NowTime)
							s HoursMax = $zabs(HoursMax)
							if @(""""_HoursMax_""""_ChildConditionItemCalculateMax_""""_$tr(ChildConditionItemValueMax,"""","'")_"""")
							{
								s ConditionChildSatisfyFlagMax=1
							}
						}
						else
						{
							s ConditionChildSatisfyFlagMax=1
						}
						
						if (ConditionChildSatisfyFlagMin=1)&(ConditionChildSatisfyFlagMax=1)
						{
							s ConditionChildSatisfyFlag=1
						}
						
					}
					elseif CurrentPInfoItem.%IsDefined("children")    //是否存在子节点，子节点是否存在满足
					{
						
						for childIndex=0:1:CurrentPInfoItem.%Get("children").%Size()-1
						{
							s ChildItem =CurrentPInfoItem.%Get("children").%Get(childIndex)
							s ConditionChildSatisfyFlagMin=0,ConditionChildSatisfyFlagMax=0
							//w CurrentPInfoItem.%Get(ChildFiledName),!
							s NowTime = $zdt($now(),3)
							if (ChildConditionItemValueMin'="")
							{
								s ChildFieldValue=$tr(ChildItem.%Get(ChildFiledName),"""","'")   //获取具体时间
								s HoursMin = $system.SQL.DATEDIFF("hour",ChildFieldValue,NowTime)
								s HoursMin = $zabs(HoursMin)
								if @(""""_HoursMin_""""_ChildConditionItemCalculateMin_""""_$tr(ChildConditionItemValueMin,"""","'")_"""")
								{
									s ConditionChildSatisfyFlagMin=1
								}
							}
							else
							{
								s ConditionChildSatisfyFlagMin=1
							}
							
							if (ChildConditionItemValueMax'="")
							{
								s ChildFieldValue=$tr(ChildItem.%Get(ChildFiledName),"""","'")
								s HoursMax = $system.SQL.DATEDIFF("hour",ChildFieldValue,NowTime)
								s HoursMax = $zabs(HoursMax)
								if @(""""_HoursMax_""""_ChildConditionItemCalculateMax_""""_$tr(ChildConditionItemValueMax,"""","'")_"""")
								{
									s ConditionChildSatisfyFlagMax=1
								}
							}
							else
							{
								s ConditionChildSatisfyFlagMax=1
							}
							
							if (ConditionChildSatisfyFlagMin=1)&(ConditionChildSatisfyFlagMax=1)
							{
								s ConditionChildSatisfyFlag=1
								break
							}
						}
						
					}
				
				}
				else
				{
					continue:(ChildConditionItemCalculate'="<")&(ChildConditionItemCalculate'="<=")&(ChildConditionItemCalculate'="=")&(ChildConditionItemCalculate'=">=")&(ChildConditionItemCalculate'=">")
					
					if (ChildFiledName="SymProperty")  //定语也是用&%拼接
					{
						s ChildPFiledNameValueStr=$tr(CurrentPInfoItem.%Get(ChildFiledName),"""","'")
						s lenChildPFNValueStr=$length(ChildPFiledNameValueStr,"&%")
						for iChildlenPFNValueStr=1:1:lenChildPFNValueStr
						{
							s ChildPFiledNameValue=$p(ChildPFiledNameValueStr,"&%",iChildlenPFNValueStr)
							if @(""""_ChildPFiledNameValue_""""_ChildConditionItemCalculate_""""_$tr(ChildConditionItemValue,"""","'")_"""")
							{
								continue:(ChildPFiledNameValue="")||(ChildConditionItemValue="")  //不存在患者信息 默认不满足
								s ConditionChildSatisfyFlag=1
							}
						}
					}
					else
					{
						s lenChildFiledName=$length(ChildFiledName,"&")  //考虑业务数据多个字段的值
						for jChildFiled=1:1:lenChildFiledName
						{
							s jChildFiledName=$p(ChildFiledName,"&",jChildFiled)
						
							;w !,$tr(CurrentPInfoItem.%Get(jChildFiledName),"""","'")
							if @(""""_$tr(CurrentPInfoItem.%Get(jChildFiledName),"""","'")_""""_ChildConditionItemCalculate_""""_$tr(ChildConditionItemValue,"""","'")_"""")
							{
								continue:(CurrentPInfoItem.%Get(jChildFiledName)="")||(ChildConditionItemValue="")  //不存在患者信息 默认不满足
								s ConditionChildSatisfyFlag=1
							}		
						}
								
						
					}	
				}
				s:ConditionChildSatisfyFlag=1 ChildSatisfyFlag=1  
				s:ConditionChildSatisfyFlag'=1 ChildSatisfyFlag=0	
			}
			if (CurrentPInfoItemArray.%Size()>1)&(ChildSatisfyFlag=1)
			{
				s Length=CurrentPInfoItemArray.%Size()-1
				if (CurrentIndex=0)
				{
					s OldFlag=1
				}
				
				if (CurrentIndex=Length)
				{
					s NewFlag=1
				}
				s AllFlag=1	
			}
			else
			{
				if (ChildSatisfyFlag=1)
				{
					s NewFlag=1
				}
				s AllFlag=1	
			}
		}
		if ($g(ChildSatisfyFlag)=1) //条件都满足
		{
			s ChildSFlag=1
		}
	}
	q ChildSFlag_"^"_OldFlag_"^"_NewFlag_"^"_AllFlag
}

/// Creator:丁亚男
/// CreatDate:2021-08-02
/// Description:判断对应识别词一级节点下的子条件是否满足
/// Table: CT.WDT.CDSS.WordsCondition
/// Input: CT.WDT.CDSS.IdentifyWords ：WordsDesc 识别词描述，PatientInfo ：患者信息
/// Return:满足返回1，不满足返回0
/// Others:w ##class(web.CDSS.IdentifyWords.GetPatientIW).DealChildConditon("316069","298690","TMPAPI1788^TMPAPI1788^1^住院^TMPAPI1788^TMPAPI1788^^1")
ClassMethod DealChildConditon(ParentDR As %String, NodeDR As %String, PatientInfo As %String) As %String
{
	s ChildSFlag=0 //子条件是否满足
	if ($d(^CT.WDT.CDSS.WordsConditionI("NodeParentIndex",NodeDR,ParentDR)))
	{
		s ParentWordsItemDR  = $lg($g(^CT.WDT.CDSS.WordsConditionD(ParentDR)),3) //（识别词项目）
		if (ParentWordsItemDR'="")
		{
			s ParentItemType=$lg($g(^CT.WDT.CDSS.WordsItemD(ParentWordsItemDR)),5)		//项目类型
		}
		s ParentConditionItemValue  = $lg($g(^CT.WDT.CDSS.WordsConditionD(ParentDR)),9)  //规则条件值
				
		s SatisfyFlag=""
		s ConditionRowId=0
		for
		{
			s ConditionRowId = $o(^CT.WDT.CDSS.WordsConditionI("NodeParentIndex",NodeDR,ParentDR,ConditionRowId)) q:(ConditionRowId="")||(SatisfyFlag=0)  //触发条件类节点内容
			s WordsItemDR  = $lg($g(^CT.WDT.CDSS.WordsConditionD(ConditionRowId)),3) //（识别词项目）
			s ItemType="",TableName="",FiledName="",Remarks=""
			if (WordsItemDR'="")
			{
				s WordsItemDesc=$lg($g(^CT.WDT.CDSS.WordsItemD(WordsItemDR)),3)
				s ItemType=$lg($g(^CT.WDT.CDSS.WordsItemD(WordsItemDR)),5)		//项目类型
				s TableName=$lg($g(^CT.WDT.CDSS.WordsItemD(WordsItemDR)),6)		//关联表名
				s FiledName=$lg($g(^CT.WDT.CDSS.WordsItemD(WordsItemDR)),7)		//关联字段名
				s Remarks=$lg($g(^CT.WDT.CDSS.WordsItemD(WordsItemDR)),11)		//备注(暂时保存关联字段在关联表的第几个节点)
			}
			if (ParentItemType="体征")
			{
				s ItemType=ParentConditionItemValue
				s CommonRowId=$o(^CT.WDT.CDSS.CommonDictI("DescIndex"," "_$ZCONVERT(ParentConditionItemValue,"U"),0))
				s EnCommonName=""
				s:CommonRowId'="" EnCommonName=$lg($g(^CT.WDT.CDSS.CommonDictD(CommonRowId)),10)        //通用名英文名称 体重 Weight
				s FiledName=EnCommonName
			}
			
			s ConditionClass  = $lg($g(^CT.WDT.CDSS.WordsConditionD(ConditionRowId)),6) //条件类型（年龄/性别/诊断/手术/检查/检验/护理/输血/症状/体征/等）
			s ConditionItem  = $lg($g(^CT.WDT.CDSS.WordsConditionD(ConditionRowId)),7) //规则条件对应字段名称
			s ConditionItemCalculate  = $lg($g(^CT.WDT.CDSS.WordsConditionD(ConditionRowId)),8) //运算符
			s ConditionItemValue  = $lg($g(^CT.WDT.CDSS.WordsConditionD(ConditionRowId)),9)  //规则条件值
			s ConditionItemValUnit  = $lg($g(^CT.WDT.CDSS.WordsConditionD(ConditionRowId)),10) //规则条件值单位
			s ConditionItemValUnitN=""
			s:ConditionItemValUnit'="" ConditionItemValUnitN= $lg($g(^CT.WDT.CDSS.UnitDictD(ConditionItemValUnit)),3)
			
			s PInfoItem=$g(^TempPInfoItemData($j,PatientInfo,ItemType)) //取患者模型的数据，并且预处理 后期优化2021-08-02 By Dingyanan
			
			if (PInfoItem="")||(PInfoItem="[]")  //所需类型信息在患者模型中不存在时，继续下一条规则条件的判断
			{
				s SatisfyFlag=0
				continue 
			}
			
			s PInfoItem=[].%FromJSON(PInfoItem)
			s ConditionSatisfyFlag="" //条件是否满足
			
			if (WordsItemDesc="值")
			{
				
				s ConditionItemCalculateMin  = $p(ConditionItemCalculate,"&&",1) //运算符
				s ConditionItemValueMin  =  $p(ConditionItemValue,"&&",1)  //规则条件值
				s ConditionItemValUnitMin  =  $p(ConditionItemValUnit,"&&",1) //规则条件值单位
				s ConditionItemValUnitMinN=""
				s:ConditionItemValUnitMin'="" ConditionItemValUnitMinN= $lg($g(^CT.WDT.CDSS.UnitDictD(ConditionItemValUnitMin)),3)
				if (ParentItemType="评估表")
				{
					s coeffMin=1
				}
				else
				{
					s coeffMin=..getValueCoefficient(ConditionItemValUnitMinN)
				}
				s:ConditionItemValueMin'="" ConditionItemValueMin=  ConditionItemValueMin*coeffMin
				
				
				s ConditionItemCalculateMax  = $p(ConditionItemCalculate,"&&",2) //运算符
				s ConditionItemValueMax  =  $p(ConditionItemValue,"&&",2)  //规则条件值
				s ConditionItemValUnitMax  =  $p(ConditionItemValUnit,"&&",2) //规则条件值单位
				s ConditionItemValUnitMaxN=""
				s:ConditionItemValUnitMax'="" ConditionItemValUnitMaxN= $lg($g(^CT.WDT.CDSS.UnitDictD(ConditionItemValUnitMax)),3)
				if (ParentItemType="评估表")
				{
					s coeffMax=1
				}
				else
				{
					s coeffMax=..getValueCoefficient(ConditionItemValUnitMaxN)
				}
				
				s:ConditionItemValueMax'="" ConditionItemValueMax=  ConditionItemValueMax*coeffMax
				
				continue:(ConditionItemValueMin="")&&(ConditionItemCalculateMax="")
				continue:(ConditionItemCalculateMin'="<")&(ConditionItemCalculateMin'="<=")&(ConditionItemCalculateMin'="=")&(ConditionItemCalculateMin'=">=")&(ConditionItemCalculateMin'=">")
				continue:(ConditionItemCalculateMax'="<")&(ConditionItemCalculateMax'="<=")&(ConditionItemCalculateMax'="=")&(ConditionItemCalculateMax'=">=")&(ConditionItemCalculateMax'=">")	
				s ConditionSatisfyFlag="" //条件是否满足
				if (FiledName["&*")  //需要考虑单位转换
				{
					s FiledName1=$p(FiledName,"&*",1) 
					s UnitName=$p(FiledName,"&*",2) 
					s FiledName=FiledName1	
				}
					
				for i=0:1:(PInfoItem.%Size()-1)  //遍历条件判断是否满足
				{
					
					continue:(PInfoItem.%Get(i)).%Get(FiledName)="" //取到的值为空
					
					s ConditionSatisfyFlagMin=0,ConditionSatisfyFlagMax=0
					
					if (FiledName["&*")  //需要考虑单位转换
					{
						s PUnit=$tr((PInfoItem.%Get(i)).%Get(UnitName),"""","'")
						s coeffUnitMin=##class(web.CDSS.CMKB.UnitConversion).GetConversion(PUnit,ConditionItemValUnitMinN)
						s coeffUnitMax=##class(web.CDSS.CMKB.UnitConversion).GetConversion(PUnit,ConditionItemValUnitMaxN)
						s ConditionItemValueMin= ConditionItemValueMin*coeffUnitMin
						s ConditionItemValueMax= ConditionItemValueMax*coeffUnitMax
								
					}
					
					if (ConditionItemValueMin'="")
					{
						
						if @(""""_$tr((PInfoItem.%Get(i)).%Get(FiledName),"""","'")_""""_ConditionItemCalculateMin_""""_$tr(ConditionItemValueMin,"""","'")_"""")
						{
							
							s ConditionSatisfyFlagMin=1
						}
					}
					else
					{
						s ConditionSatisfyFlagMin=1
					}
					if (ConditionItemValueMax'="")
					{
						
						if @(""""_$tr((PInfoItem.%Get(i)).%Get(FiledName),"""","'")_""""_ConditionItemCalculateMax_""""_$tr(ConditionItemValueMax,"""","'")_"""")
						{
							s ConditionSatisfyFlagMax=1
						}
					}
					else
					{
						s ConditionSatisfyFlagMax=1
					}
					
					if (ConditionSatisfyFlagMin=1)&(ConditionSatisfyFlagMax=1)
					{
						s ConditionSatisfyFlag=1
					}
					
				}
			}
			elseif (WordsItemDesc="持续时间")||(WordsItemDesc="时间")
			{
				
				s ConditionItemCalculateMin  = $p(ConditionItemCalculate,"&&",1) //运算符
				s ConditionItemValueMin  =  $p(ConditionItemValue,"&&",1)  //规则条件值
				s ConditionItemValUnitMin  =  $p(ConditionItemValUnit,"&&",1) //规则条件值单位
				s ConditionItemValUnitMinN=""
				s:ConditionItemValUnitMin'="" ConditionItemValUnitMinN= $lg($g(^CT.WDT.CDSS.UnitDictD(ConditionItemValUnitMin)),3)
				s coeffMin=..getCoefficient(ConditionItemValUnitMinN)
				s:ConditionItemValueMin'="" ConditionItemValueMin=  ConditionItemValueMin*coeffMin
				
				s ConditionItemCalculateMax  = $p(ConditionItemCalculate,"&&",2) //运算符
				s ConditionItemValueMax  =  $p(ConditionItemValue,"&&",2)  //规则条件值
				s ConditionItemValUnitMax  =  $p(ConditionItemValUnit,"&&",2) //规则条件值单位
				s ConditionItemValUnitMaxN=""
				s:ConditionItemValUnitMax'="" ConditionItemValUnitMaxN= $lg($g(^CT.WDT.CDSS.UnitDictD(ConditionItemValUnitMax)),3)
				s coeffMax=..getCoefficient(ConditionItemValUnitMaxN)
				s:ConditionItemValueMax'="" ConditionItemValueMax=  ConditionItemValueMax*coeffMax
				
				continue:(ConditionItemValueMin="")&&(ConditionItemCalculateMax="")
				continue:(ConditionItemCalculateMin'="<")&(ConditionItemCalculateMin'="<=")&(ConditionItemCalculateMin'="=")&(ConditionItemCalculateMin'=">=")&(ConditionItemCalculateMin'=">")
				continue:(ConditionItemCalculateMax'="<")&(ConditionItemCalculateMax'="<=")&(ConditionItemCalculateMax'="=")&(ConditionItemCalculateMax'=">=")&(ConditionItemCalculateMax'=">")	
				
				s ConditionSatisfyFlag="" //条件是否满足
				for i=0:1:(PInfoItem.%Size()-1)  //遍历条件判断是否满足
				{
					continue:(PInfoItem.%Get(i)).%Get(FiledName)="" //取到的值为空
					s ConditionSatisfyFlagMin=0,ConditionSatisfyFlagMax=0
					//w (PInfoItem.%Get(i)).%Get(FiledName),!
					
					if (ConditionItemValueMin'="")
					{
						if @(""""_$tr((PInfoItem.%Get(i)).%Get(FiledName),"""","'")_""""_ConditionItemCalculateMin_""""_$tr(ConditionItemValueMin,"""","'")_"""")
						{
							s ConditionSatisfyFlagMin=1
						}
					}
					else
					{
						s ConditionSatisfyFlagMin=1
					}
					
					if (ConditionItemValueMax'="")
					{
						if @(""""_$tr((PInfoItem.%Get(i)).%Get(FiledName),"""","'")_""""_ConditionItemCalculateMax_""""_$tr(ConditionItemValueMax,"""","'")_"""")
						{
							s ConditionSatisfyFlagMax=1
						}
					}
					else
					{
						s ConditionSatisfyFlagMax=1
					}
					
					if (ConditionSatisfyFlagMin=1)&(ConditionSatisfyFlagMax=1)
					{
						s ConditionSatisfyFlag=1
					}
					
				}
			
			}
			else
			{
				continue:(ConditionItemCalculate'="<")&(ConditionItemCalculate'="<=")&(ConditionItemCalculate'="=")&(ConditionItemCalculate'=">=")&(ConditionItemCalculate'=">")
				for i=0:1:(PInfoItem.%Size()-1)  //遍历条件判断是否满足
				{
					if (FiledName="SymProperty")  //定语也是用&%拼接
					{
						s PFiledNameValueStr=$tr((PInfoItem.%Get(i)).%Get(FiledName),"""","'")
						s lenPFNValueStr=$length(PFiledNameValueStr,"&%")
						for ilenPFNValueStr=1:1:lenPFNValueStr
						{
							s PFiledNameValue=$p(PFiledNameValueStr,"&%",ilenPFNValueStr)
							if @(""""_PFiledNameValue_""""_ConditionItemCalculate_""""_$tr(ConditionItemValue,"""","'")_"""")
							{
								continue:(PFiledNameValue="")||(ConditionItemValue="")  //不存在患者信息 默认不满足
								s ConditionSatisfyFlag=1
							}
						}
					}
					else
					{
						s lenFiledName=$length(FiledName,"&")  //考虑业务数据多个字段的值
						for jFiled=1:1:lenFiledName
						{
							s jFiledName=$p(FiledName,"&",jFiled)
							;w !,$tr((PInfoItem.%Get(i)).%Get(jFiledName),"""","'")
							if @(""""_$tr((PInfoItem.%Get(i)).%Get(jFiledName),"""","'")_""""_ConditionItemCalculate_""""_$tr(ConditionItemValue,"""","'")_"""")
							{
								continue:((PInfoItem.%Get(i)).%Get(jFiledName)="")||(ConditionItemValue="")  //不存在患者信息 默认不满足
								s ConditionSatisfyFlag=1
							}		
						}
								
						
					}
				}
			}
			s:ConditionSatisfyFlag=1 SatisfyFlag=1  
			s:ConditionSatisfyFlag'=1 SatisfyFlag=0	
		}
		
		
		if (SatisfyFlag=1) //条件都满足
		{
			s ChildSFlag=1
		}
	}
	else
	{
		s ChildSFlag=1
	}
	
	
	q ChildSFlag
}

/// Creator:丁亚男
/// CreatDate:2021-11-25
/// Description:根据单位获取转化系数 月经婚育史项目-值以及个人史-值:时间转换成天,其他单位入库做转换
/// Input: Unit ：单位
/// Return:返回系数
/// Others:w ##class(web.CDSS.IdentifyWords.GetPatientIW).getCoefficient("天")
ClassMethod getValueCoefficient(Unit As %String) As %String
{
	s result=1 //入参为"天"、空等默认为1
	s:Unit="天" result=1
	s:Unit="周" result=7
	s:Unit="月" result=30
	s:Unit="年" result=365
	s:Unit="岁" result=365  //例：初潮 岁 转化成 天 
	q result
}

/// Creator:丁亚男
/// CreatDate:2021-11-25
/// Description:根据单位获取转化系数
/// Input: Unit ：单位
/// Return:返回系数
/// Others:w ##class(web.CDSS.IdentifyWords.GetPatientIW).getCoefficient("天")
ClassMethod getCoefficient(Unit As %String) As %String
{
	s result=1 //入参为"时"、空等默认为1
	s:Unit="秒" result=0.000278
	s:Unit="分" result=0.0167
	s:Unit="天" result=24
	s:Unit="周" result=168
	s:Unit="月" result=720
	s:Unit="年" result=8760
	q result
}

/// Creator:丁亚男
/// CreatDate:2021-08-24
/// Description:更新患者汇总信息索引表数据
/// Table: WDT.CDSS.PatPMTypeIndex
/// Input: PatientInfo ：患者信息
/// Return:成功返回1，失败返回0
/// Others:w ##class(web.CDSS.IdentifyWords.GetPatientIW).UpdatePMTypeIndex("心房颤动^心房颤动^1^门诊^6464^石萧伟^111^信息部^1")
ClassMethod UpdatePMTypeIndex(PatientInfo As %String) As %String
{
	s IDNO=$p(PatientInfo,"^",1)
	s PatientDR=$p(PatientInfo,"^",2)
	s VisitID=$p(PatientInfo,"^",3)
	s VIsitType=$p(PatientInfo,"^",4)
	s Config=$p(PatientInfo,"^",9)
	s Type=$p(PatientInfo,"^",10)
	if (Config="") s Config=1	//是否启用流水号（急诊号、门诊号、住院号）为患者就诊唯一标识（0为是，1为否），默认为1
	
	if ((Config=1)||(Config="Y"))&(PatientDR'="")&(VisitID'="") // 单个患者单次就诊 根据病人标识和就诊次数编号取数据
	{
		if ($d(^WDT.CDSS.PatPMTypeIndexI("PatVisDRTypeIndex",PatientDR,VisitID,VIsitType)))
		{
			s IndexRowId=0
			for 
			{
				s IndexRowId=$o(^WDT.CDSS.PatPMTypeIndexI("PatVisDRTypeIndex",PatientDR,VisitID,VIsitType,IndexRowId)) q:IndexRowId=""
				s sc=##class(WDT.CDSS.PatPMTypeIndex).%DeleteId(IndexRowId)
			}
			
		}
	} 
	elseif (IDNO'="")  //患者主索引
	{
		if ($d(^WDT.CDSS.PatPMTypeIndexI("IDNOIndex"," "_$zconvert(IDNO,"U"))))
		{
			s IndexRowId=0
			for 
			{
				s IndexRowId=$o(^WDT.CDSS.PatPMTypeIndexI("IDNOIndex"," "_$zconvert(IDNO,"U"),IndexRowId)) q:IndexRowId=""
				s sc=##class(WDT.CDSS.PatPMTypeIndex).%DeleteId(IndexRowId)
			}	
		}
	}
	q 1
}

/// Creator:丁亚男
/// CreatDate:2021-08-24
/// Description:测试遍历所有识别词
/// Table: CT.WDT.CDSS.IdentifyWords
/// Input: PatientInfo ：患者信息
/// Return:成功返回1，失败返回0
/// Others:w ##class(web.CDSS.IdentifyWords.GetPatientIW).TestALLIW("心房颤动^心房颤动^1^门诊^6464^石萧伟^111^信息部^1")
ClassMethod TestALLIW(PatientInfo As %String) As %String
{
	s IDNO=$p(PatientInfo,"^",1)
	s PatientDR=$p(PatientInfo,"^",2)
	s VisitID=$p(PatientInfo,"^",3)
	s VisitType=$p(PatientInfo,"^",4)
	s Config=$p(PatientInfo,"^",9)
	s Type=$p(PatientInfo,"^",10)
	if (Config="") s Config=1	//是否启用流水号（急诊号、门诊号、住院号）为患者就诊唯一标识（0为是，1为否），默认为1
	
	//判断识别词是否满足条件 满足保存到患者识别词表
	s IWRowId=0
	for
	{
		s IWRowId=$o(^CT.WDT.CDSS.IdentifyWordsD(IWRowId)) q:IWRowId=""
		s WordsDesc=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(IWRowId)),3)
		if (WordsDesc="年龄")||(WordsDesc="性别")
		{
			s flag=1
		}
		else
		{
			s flag=..DealIdentifyWords(IWRowId,PatientInfo)
		}
		if (flag=1)
		{
		
			if ('$d(^WDT.CDSS.PatTriggerIWI("PatVisTypeIWIndex",PatientDR,VisitID,VisitType,IWRowId))&&('$d(^WDT.CDSS.PatTriggerIWI("IDNOIWIndex",IDNO,IWRowId))))
			{
				
				Ts
				s obj=##class(WDT.CDSS.PatTriggerIW).%New()
				s obj.IDNO=IDNO
				s obj.PatientDR=PatientDR
				s obj.VisitID=VisitID
				s obj.VisitType=VisitType
				d obj.IdentifyWordsDRSetObjectId(IWRowId)
				s obj.PTableNameStr=$g(^TMPIdentifyW(PatientInfo,"PTableName"))
				s obj.PFiledNameStr=$g(^TMPIdentifyW(PatientInfo,"PTableName","PFiledName"))
				s obj.PFiledValueStr=$g(^TMPIdentifyW(PatientInfo,"PTableName","PFiledName","PFiledValue"))
				
				s sc=obj.%Save()
                d obj.%Close()
                If $$$ISOK(sc)
	            {
	                Tc
	                s id = obj.%Id()
	                //保存日志
					d ##class(web.CDSS.Config.DataChangeLog).SaveLog("PatTriggerIW","WDT.CDSS.PatTriggerIW","患者当前触发的识别词",id,obj.IDNO,"A",obj)
				}
	            else
	            {
	                Trollback
	                s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	                s logid=##class(web.DHCBL.MKB.SysErrorLog).SaveLog("患者当前触发的识别词","web.CDSS.MedicalRule.DiagAndTreatR","SaveData",obj)
	       	    	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	            }
	            k ^TMPIdentifyW(PatientInfo)
			}
		}
		else
		{
			s PatIWRowId=""
			if $d(^WDT.CDSS.PatTriggerIWI("PatVisTypeIWIndex",PatientDR,VisitID,VisitType,IWRowId))
			{
				s PatIWRowId=$O(^WDT.CDSS.PatTriggerIWI("PatVisTypeIWIndex",PatientDR,VisitID,VisitType,IWRowId,""))
			}
			elseif $d(^WDT.CDSS.PatTriggerIWI("IDNOIWIndex",IDNO,IWRowId))
			{
				s PatIWRowId=$O(^WDT.CDSS.PatTriggerIWI("IDNOIWIndex",IDNO,IWRowId,""))
			}
			if (PatIWRowId'="")
			{
				s delsc=##class(WDT.CDSS.PatTriggerIW).%DeleteId(PatIWRowId)
			}
		}
	}
	q 1
}

/// Creator:李得原
/// CreatDate:2022-06-20
/// Description:获取患者触发的识别词
/// Table: CT.WDT.CDSS.IdentifyWords
/// Input: PatientInfo ：患者信息
/// Return:患者触发的识别词json
/// Others:w ##class(web.CDSS.IdentifyWords.GetPatientIW).GetPatTriggerIW("DM000755^DM000755^1^住院^9^石萧伟^1^信息科^Y")
ClassMethod GetPatTriggerIW(PatientInfo As %String) As %String
{
	//WDT.CDSS.PatTriggerIW
	s Result = {}
	s start = $p($zdt($now(),3,1,4),":",*)
	s IDNO=$p(PatientInfo,"^",1)
	s PatientDR=$p(PatientInfo,"^",2)
	s VisitID=$p(PatientInfo,"^",3)
	s VisitType=$p(PatientInfo,"^",4)
	s Config=$p(PatientInfo,"^",9)
	s Type=$p(PatientInfo,"^",10)
	if (Config="") s Config=1	//是否启用流水号（急诊号、门诊号、住院号）为患者就诊唯一标识（0为是，1为否），默认为1
	s IWArray=""  //符合索引条件的识别词
	//K ^TempPInfoItemData($j,PatientInfo)
	//先获取患者模型数据，避免多次获取
	if (Config=1)&(PatientDR'="")&(VisitID'="")
	{
		s Rowid = 0
		for
		{
			s Rowid=$o(^WDT.CDSS.PatTriggerIWI("PatVisDRTypeIndex",PatientDR,VisitID,VisitType,Rowid)) q:Rowid=""
			//s IWRowid = $lg($g(^WDT.CDSS.PatTriggerIWD(Rowid)),6)
			s WordsDesc= $lg($g(^CT.WDT.CDSS.IdentifyWordsD(Rowid)),3)
			continue:WordsDesc=""
			d Result.%Set(Rowid, WordsDesc)
		}
	}
	elseif IDNO'=""
	{
		s Rowid = 0
		for
		{
			//
			s Rowid=$o(^WDT.CDSS.PatTriggerIWI("IDNOIWIndex",IDNO,Rowid)) q:Rowid=""
			//s IWRowid = $lg($g(^WDT.CDSS.PatTriggerIWD(Rowid)),6)
			s WordsDesc= $lg($g(^CT.WDT.CDSS.IdentifyWordsD(Rowid)),3)
			continue:WordsDesc=""
			d Result.%Set(Rowid, WordsDesc)
		}
	}
	q Result.%ToJSON()
}

/// w ##class(web.CDSS.IdentifyWords.GetPatientIW).TestWordsRule("DM000814^DM000814^1^住院^48^李得原^1^信息科^1",95675)
ClassMethod TestWordsRule(PatientInfo, WordRowid)
{
	d ..CreatePatientInfoData(PatientInfo)
	b
	s sc=..DealIdentifyWords(WordRowid,PatientInfo)
	k ^TempPInfoItemData($j,PatientInfo)
	q sc
}

/// Creator:李得原
/// CreatDate:2023-02-07
/// Description:根据患者信息返回推荐确诊信息
/// Table: WDT.CDSS.PatientRecomInfo
/// Input: PatientInfo ：患者信息
/// Return:返回推荐确诊信息
/// Others:w ##class(web.CDSS.IdentifyWords.GetPatientIW).GetRecomDisease("DM000022^DM000022^1^住院^13984^李得原^183^信息部^1")
ClassMethod GetRecomDisease(PatientInfo As %String)
{
	s Result="{}"
	d ..GetSatisfyIW(PatientInfo)
	s IDNO=$p(PatientInfo,"^",1)
	if IDNO=""
	{
		s Result = {"Error":"患者IDNO为空"}
		return Result.%ToJSON()
	}
	s ResRowid=0
	for
	{
		s ResRowid=$o(^WDT.CDSS.PatientRecomInfoI("UniqueIDNOIndex",IDNO,"推荐确诊",ResRowid))
		q:ResRowid=""
		s Result=$lg($g(^WDT.CDSS.PatientRecomInfoD(ResRowid)),7)
		if Result'=""
		{
			s Result =$e(Result,2,*-1)
		}
		return Result
	}
	q Result
}

/// Creator:李得原
/// CreatDate:2023-04-07
/// Description:判断医嘱是否已经执行
/// Table: 
/// Input: 识别词规则条件id
/// Return:
/// Others:w ##class(web.CDSS.IdentifyWords.GetPatientIW).CheckExecutedOrder()
ClassMethod CheckExecutedOrderFilter(NodeDR As %String, ConditionRowid As %String, ItemField As %String, ItemValue As %String, PatientInfo As %String, ItemType As %String)
{
	
	if ItemType="药品"
	{
		q "1"
	}
	s ChildConditionRowId = $o(^CT.WDT.CDSS.WordsConditionI("NodeParentIndex",NodeDR,ConditionRowid,""))
	if ChildConditionRowId'=""   //如果规则有子节点，则按原逻辑
	{
		return "1"	
	}
	else
	{
		s PInfoItem=$g(^TempPInfoItemData($j,PatientInfo,ItemType)) 
		if (PInfoItem="")||(PInfoItem="[]")  
		{
			return "0"  //该类型患者数据为空，不再继续进行规则匹配
		}
		s PInfoItem=[].%FromJSON(PInfoItem)
		for PInfoIndex=0:1:PInfoItem.%Size()-1
		{
			if PInfoItem.%Get(PInfoIndex).%IsDefined("ExecuteTime")   //有执行时间为医嘱
			{
				for PIndex=0:1:PInfoItem.%Size()-1
				{
					s PItem = PInfoItem.%Get(PIndex).%Get(ItemField)
					s ExecuteTime = PInfoItem.%Get(PIndex).%Get("ExecuteTime")
					if (PItem=ItemValue)&(ExecuteTime="")  //未执行了的医嘱
					{
						return "1"
					}
					if (PItem=ItemValue)&(ExecuteTime'="")  //已经执行了的医嘱
					{
						return "0"
					}
				}
			}
			elseif PInfoItem.%Get(PInfoIndex).%IsDefined("children")
			{
				s Children=PInfoItem.%Get(PInfoIndex).%Get("children")
				if Children.%Size()>0
				{
					for PIndex=0:1:Children.%Size()-1
					{
						s PItem = Children.%Get(PIndex).%Get(ItemField)
						s ExecuteTime = Children.%Get(PIndex).%Get("ExecuteTime")
						if (PItem=ItemValue)&(ExecuteTime="")  //未执行的医嘱
						{
							return "1"
						}
						if (PItem=ItemValue)&(ExecuteTime'="")  //已经执行了的医嘱
						{
							return "0"
						}
						
					}
				}
			}
			else //非医嘱
			{
				return "1"	
			}
		}
		
	}
	q "1"
}

/// Creator:李得原
/// CreatDate:2023-05-06
/// Description:如果识别词有检验检查结果的，把检查检验结果的条件返回
/// Table: 
/// Input: 
/// Return:
/// Others:w ##class(web.CDSS.IdentifyWords.GetPatientIW).GetPatientLabExamCondition("心房颤动")
ClassMethod GetPatientLabExamCondition(Diag As %String)
{
	s Result=[]
	s DiseaseName=Diag
	if DiseaseName=""
	{
		q "[]"
	}
	s Diag=##class(web.CDSS.IMP.ContrastDict).GetDiectName(DiseaseName,"","诊断字典")
	for DiagIndex=1:1:$l(Diag,"&%")
	{
		s DiagItem=$p(Diag,"&%",DiagIndex)
		continue:DiagItem=""
		s IWRowid=$o(^CT.WDT.CDSS.IdentifyWordsI("DescTypeIndex",DiagItem,"识别条件",0))
		s FlowNum=0
		for
		{
			s FlowNum=$o(^CT.WDT.CDSS.WordsNodeI("WordsDRTypeIndex",IWRowid,FlowNum)) q:FlowNum=""
			s FlowFlag=0
			s FlowCondition=[]
			s NodeType=""
			for
			{
				s NodeType=$o(^CT.WDT.CDSS.WordsNodeI("WordsDRTypeIndex",IWRowid,FlowNum,NodeType)) q:NodeType=""
				continue:NodeType="1"
				continue:NodeType="2"
				s NodeId=0
				for
				{
					s NodeId=$o(^CT.WDT.CDSS.WordsNodeI("WordsDRTypeIndex",IWRowid,FlowNum,NodeType,NodeId)) q:NodeId=""
					
					
					if $d(^CT.WDT.CDSS.WordsConditionI("NodeParentIndex",NodeId))  // 有子条件的
					{
						s ConditionId=0
						for
						{
							s ConditionId=$o(^CT.WDT.CDSS.WordsConditionI("NodeDRIndex",NodeId,ConditionId)) q:ConditionId=""
							
							if $lg($g(^CT.WDT.CDSS.WordsConditionD(ConditionId)),4)'=""
							{
								continue
							}
							s WordsItemDR=$lg($g(^CT.WDT.CDSS.WordsConditionD(ConditionId)),3)
							s WordsItemDesc=$lg($g(^CT.WDT.CDSS.WordsItemD(WordsItemDR)),3)
							s WordsItemType=$lg($g(^CT.WDT.CDSS.WordsItemD(WordsItemDR)),5)
							if "检查检验结果 检查 检验结果 检验 体格检查"[WordsItemType
							{
								s FlowFlag=1
							}
							continue:WordsItemType["诊断"
							s ParentConditonValue=$lg($g(^CT.WDT.CDSS.WordsConditionD(ConditionId)),9)
			
							s Tmp=""
							s ChildTmp=""
							s ChildConditionRowid=0
							for
							{
								s ChildConditionRowid=$o(^CT.WDT.CDSS.WordsConditionI("NodeParentIndex",NodeId,ConditionId,ChildConditionRowid))
								q:ChildConditionRowid=""
								s ChildWordsItemDR=$lg($g(^CT.WDT.CDSS.WordsConditionD(ChildConditionRowid)),3)
								s ChildWordsItemDesc=$lg($g(^CT.WDT.CDSS.WordsItemD(ChildWordsItemDR)),3)
								s ChildWordsCalculate=$lg($g(^CT.WDT.CDSS.WordsConditionD(ChildConditionRowid)),8)
								s ChildWordsValue=$lg($g(^CT.WDT.CDSS.WordsConditionD(ChildConditionRowid)),9)
								s ChildWordsUnit=$lg($g(^CT.WDT.CDSS.WordsConditionD(ChildConditionRowid)),10)
								if ChildWordsCalculate["&&"   //如果子条件值有区间
								{
									s MinCal=$p(ChildWordsCalculate,"&&",1)
									s MaxCal=$p(ChildWordsCalculate,"&&",2)
									s MinValue=$p(ChildWordsValue,"&&",1)
									s MaxValue=$p(ChildWordsValue,"&&",2)
									s MinUnit=$p(ChildWordsUnit,"&&",1)
									s MaxUnit=$p(ChildWordsUnit,"&&",2)
									s (MinUnitDesc,MaxUnitDesc)=""
									if MinUnit'=""
									{
										s MinUnitDesc=$lg($g(^CT.WDT.CDSS.UnitDictD(MinUnit)),3)
									}
									if MaxUnit'=""
									{
										s MaxUnitDesc=$lg($g(^CT.WDT.CDSS.UnitDictD(MaxUnit)),3)
									}
									if MinCal'=""
									{
										s ChildTmp=ParentConditonValue_MinCal_MinValue_MinUnitDesc
									}
									
									if MaxCal'=""
									{
										s:ChildTmp'="" ChildTmp=ChildTmp_"&"_ParentConditonValue_MaxCal_MaxValue_MaxUnitDesc
										s:ChildTmp="" ChildTmp=ParentConditonValue_MaxCal_MaxValue_MaxUnitDesc
									}
								}   
								else   //如果子条件没有区间
								{
									s ChildTmp=ParentConditonValue_" ("_ChildWordsItemDesc_")："_ChildWordsValue
								}
							}
							s:ChildTmp'="" Tmp=WordsItemDesc_"："_ChildTmp
							s:ChildTmp="" Tmp=WordsItemDesc_"："_ParentConditonValue
							d FlowCondition.%Push(Tmp)
							
						}
					}
				}
			}
			if FlowCondition.%Size()>0
			{
				if FlowFlag=1
				{
					d Result.%Push(FlowCondition)
				}
			}
		}
		
	}
	if Result.%Size()=1
	{
		q Result.%Get(0).%ToJSON()
	}
	q Result.%ToJSON()
}

}
