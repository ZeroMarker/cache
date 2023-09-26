/// 名称:cdss第三方数据数据校验相关方法
/// 描述: 对第三方数据进行数据合理性 一致性的校验
/// 编写者：李得原-基础数据平台
/// 编写日期: 2020-04-28
Class web.CDSS.MachineLearning.DataVerification Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:lideyuan
/// CreatDate:2020-04-30
/// Description：对第三方数据json串进行基本信息、就诊信息数据一致性和临床信息完整性校验
/// Input：患者信息json串
/// Output: 
/// w ##class(web.CDSS.MachineLearning.DataVerification).DataConsistency("")
ClassMethod DataConsistency(PatientInfo As %String) As %String
{
	n (PatientInfo)
	if ($e(PatientInfo,1,1)'="[")     //如果入参外层不是列表，就加一层列表
	{
		s PatientInfo="["_PatientInfo_"]"
	}
	s ErrorInfo=[]
	
 	//s PatientArray=[{"IDNO":"DH001","PatientDR":"te001","VisitID":"1","children":[{"DataClass":"DHCDSSPatientMaster","children":[{"MedicareCardNum":"620","IDCardNumber":"620503199901017676","Name":"测试患者","PhoneNumber":"1234567890"}]},{"DataClass":"DHCDSSPatientVisit","children":[{"VisitType":"门诊","TreatmentTime":"2020-04-29 17:15:30","SpecExamSum":"测试1数据"}]},{"DataClass":"DHCDSSSignInfo","children":[{"MeasureDate":"2020-04-29 17:20:30","BodyTemperature":"37.2","Weight":""}]}]}]
  	s PatientArray=[].%FromJSON(PatientInfo)

 //	s PatientArray=a
 	
	for i=0:1:PatientArray.%Size()-1   //遍历第一层列表
	{
		s PatientJson=PatientArray.%Get(i)
		k key
		k value
		d PatientJson.%Remove("UserID")    
		d PatientJson.%Remove("UserName")
		d PatientJson.%Remove("CTLocID")
		d PatientJson.%Remove("CTLocDesc")
		s IDNO=PatientJson.%Get("IDNO")
		s VisitID=PatientJson.%Get("VisitID")
		s PatientDR=PatientJson.%Get("PatientDR")
		s PatientIterator=PatientJson.%GetIterator()     //遍历第一层{}
		while PatientIterator.%GetNext(.key,.value)
		{
			if key="children"    //如果键值对中的键为"children"
			{
				s ChildrenArray=PatientJson.%Get("children")       //包含表名的children
				
				for j=0:1:(ChildrenArray.%Size()-1)
				{ 
					s ChildrenJson=ChildrenArray.%Get(j)
					s TableName="WDT.CDSS."_ChildrenJson.%Get("DataClass")   //字段所属表名
					
					//如果是患者基本信息表 或 就诊信息表 则进行数据一致性校验
					if ((TableName="WDT.CDSS.PatientMaster")||(TableName="WDT.CDSS.PatientVisit")) 
					{
						s TableGlobalName="^"_TableName_"I"
						k TableRowid
						 
						if TableName="WDT.CDSS.PatientMaster"    //如果是患者基本信息表
						{
							s TableRowidExpStr="$o("_TableGlobalName_"("_"""PatDRIndex"""_","_""""_PatientDR_""""_","_"""""))"
							s TableRowidExp="s TableRowid="_TableRowidExpStr
							x TableRowidExp
							
						}
						if TableName="WDT.CDSS.PatientVisit"    //如果是就诊信息表
						{
							s TableRowidExpStr="$o("_TableGlobalName_"("_"""PatVisDRIndex"""_","_""""_PatientDR_""""_","_VisitID_","_"""""))"
							s TableRowidExp="s TableRowid="_TableRowidExpStr
							x TableRowidExp
							
						}
						continue:TableRowid=""  //如果不存在患者的主索引 或者 当前就诊号，则跳出当前循环
						
						s GrandChildrenArray=ChildrenJson.%Get("children")       //包含字段名的children
						for i=0:1:GrandChildrenArray.%Size()-1      //遍历children的每一个键值对
						{
							s GrandChildren=GrandChildrenArray.%Get(i)
							k fieldkey
							k fieldvalue    //清空数据，以防数据窜值
							
							s FieldNameIterator=GrandChildren.%GetIterator()
							while FieldNameIterator.%GetNext(.fieldkey,.fieldvalue)    //遍历当前键值对的key value
							{
								if $d(^CT.WDT.CDSS.DataTableDictI("TableNameIndex",TableName,fieldkey)) //如果数据库中存在此字段
								{
									s CDSSDTDRowid=$o(^CT.WDT.CDSS.DataTableDictI("TableNameIndex",TableName,fieldkey,0))
									s FieldNum=$lg($g(^CT.WDT.CDSS.DataTableDictD(CDSSDTDRowid)),5)  //当前字段在User表中的位置
									s FieldExpStr="$lg($g("_"^"_TableName_"D"_"("_TableRowid_")"_")"_","_FieldNum_")"
									s FieldExp="s UserFieldValue="_FieldExpStr
									x FieldExp
									if (UserFieldValue=fieldvalue)    //判断数据库中存的值和获取的患者json数据是否一致
									{
										
									}
									elseif UserFieldValue=""   //如果数据库中不存在比对的信息 则跳过
									{
										continue
									}
									else
									{
										s (ErrExplain,ErrStandard)=""
										if TableName="WDT.CDSS.PatientMaster"
										{
											s TableDesc="患者基础信息"
										}
										if TableName="WDT.CDSS.PatientVisit"
										{
											s TableDesc="患者就诊信息"
										}
										k MessageValue
										s MessageValue=fieldvalue
										s:MessageValue="" MessageValue="空值"
										//s ErrExplain=fieldkey_"和之前信息不一致,之前为:"_UserFieldValue_",现在为:"_fieldvalue
										s ErrStandard=fieldkey_"信息和之前需要保持一致"
										s ErrorItem={}
										s ChildItem={}
										s Children=[]
										d ErrorItem.%Set("异常信息来源",TableDesc)
										d ErrorItem.%Set("异常信息项",fieldkey)
										
										d ChildItem.%Set("异常类型","一致性")
										d ChildItem.%Set("标准要求",fieldkey_":"_UserFieldValue)
										d ChildItem.%Set("异常说明","历史信息为:"_UserFieldValue_","_"推送信息为:"_MessageValue)
										d Children.%Push(ChildItem)
										d ErrorItem.%Set("children",Children)
										d ErrorItem.%Set("影响等级","高")
										d ErrorInfo.%Push(ErrorItem)
									}
								}
							}
						}
					}
					else   //除患者基本信息表和就诊信息表以外的，进行临床信息完整性校验
					{
						s TableGlobalName="^"_TableName_"I"
						k TableRowid
						
						s GrandChildrenArray=ChildrenJson.%Get("children")       //包含字段名的children
						for i=0:1:GrandChildrenArray.%Size()-1      //遍历children的每一个键值对
						{
							s GrandChildren=GrandChildrenArray.%Get(i)
							k fieldkey
							k fieldvalue    //清空数据，以防数据窜值
							
							s FieldNameIterator=GrandChildren.%GetIterator()
							while FieldNameIterator.%GetNext(.fieldkey,.fieldvalue)    //遍历当前键值对的key value
							{
								
								if fieldvalue=""
								{
									s ErrorItem={}
									s ChildItem={}
									s Children=[]
									
									d ErrorItem.%Set("异常信息来源","患者临床信息")
									d ErrorItem.%Set("异常信息项",fieldkey)
									d ChildItem.%Set("异常类型","完整性")
									d ChildItem.%Set("标准要求","数据缺失")
									d ChildItem.%Set("异常说明","无")
									d Children.%Push(ChildItem)
									d ErrorItem.%Set("children",Children)
									d ErrorItem.%Set("影响等级","中")
									d ErrorInfo.%Push(ErrorItem)
								}
							}
						}
					}
				}
			}	
		}
	}
	q ErrorInfo.%ToJSON()
}

/// Creator:lideyuan
/// CreatDate:2020-04-28
/// Description：对第三方数据json串进行数据合理性校验，包括（数据类型是否匹配，主键是否存在等）
/// Input：患者信息json串
/// Output: 
/// //s PatientJson={"姓名":"张三","性别":"男","年龄":23,"主诉概述":"今天崴脚了"}
/// "{"Name":"张三","Age":23,"Birthplace": "中国","BloodType": "B","ChiefCompSum":"今天崴脚了"}"
/// s a=[{"IDNO":"620503199901017676","PatientDR":"Test001","VisitID":"1","children":[{"DataClass":"DHCDSSPatientMaster","children":[{"MedicareCardNum":"620503199901017676","IDCardNumber":"620503199901017676","Name":"测试患者","PhoneNumber":"1234567890"}]},{"DataClass":"DHCDSSPatientVisit","children":[{"VisitType":"门诊","TreatmentTime":"2020-04-29 17:15:30","SpecExamSum":"测试数据"}]},{"DataClass":"DHCDSSSignInfo","children":[{"MeasureDate":"2020-04-29 17:20:30","BodyTemperature":"37.2","Weight":"68.9"}]}]}]
/// w ##class(web.CDSS.MachineLearning.DataVerification).DataRationalisation("")
ClassMethod DataRationalisation(PatientInfo As %String) As %String
{
	n (PatientInfo)
	if ($e(PatientInfo,1,1)'="[")     //如果入参外层不是列表，就加一层列表
	{
		s PatientInfo="["_PatientInfo_"]"
	}
	s ErrorInfo=[]
	d GetUserDesc
	//s PatientArray=[{"IDNO":"620503199901017676","PatientDR":"Test001","VisitID":"1","children":[{"DataClass":"DHCDSSPatientMaster","children":[{"MedicareCardNum":"620503199901017676","IDCardNumber":"620503199901017676","Name":"测试患者","PhoneNumber":"1234567890"}]},{"DataClass":"DHCDSSPatientVisit","children":[{"VisitType":"门诊","TreatmentTime":"2020-04-10 17:15:30","SpecExamSum":"测试数据"}]},{"DataClass":"DHCDSSSignInfo","children":[{"MeasureDate":"2020-04-29 17:20:30","BodyTemperature":"37.2","Weight":"68.9"}]}]}]
	s PatientArray=[].%FromJSON(PatientInfo)
	for i=0:1:PatientArray.%Size()-1
	{
		s PatientJson=PatientArray.%Get(i)
		k key
		k value
		d PatientJson.%Remove("UserID")
		d PatientJson.%Remove("UserName")
		d PatientJson.%Remove("CTLocID")
		d PatientJson.%Remove("CTLocDesc")
		s PatientIterator=PatientJson.%GetIterator()
		while PatientIterator.%GetNext(.key,.value)
		{
			s value=$zstrip(value,"<>W")
			if key="children"
			{
				s ChildrenArray=PatientJson.%Get("children")       //包含表名的children
				for j=0:1:ChildrenArray.%Size()-1
				{
					s ChildrenJson=ChildrenArray.%Get(j)
					s TableName="WDT.CDSS."_ChildrenJson.%Get("DataClass")   //字段所属表名
					
					s GrandChildrenArray=ChildrenJson.%Get("children")       //包含字段名的children
					for i=0:1:GrandChildrenArray.%Size()-1      //遍历children的每一个键值对
					{
						s GrandChildren=GrandChildrenArray.%Get(i)
						k fieldkey
						k fieldvalue    //清空数据，以防数据窜值
						
						s FieldNameIterator=GrandChildren.%GetIterator()
						while FieldNameIterator.%GetNext(.fieldkey,.fieldvalue)    //遍历当前键值对的key value
						{
							
							s FieldType=GrandChildren.%GetTypeOf(fieldkey)   //获取前台传来的数据类型
							
							if $d(^CT.WDT.CDSS.DataTableDictI("TableNameIndex",TableName,fieldkey)) //如果数据库中存在此字段
							{
								s CDSSDTDRowid=$o(^CT.WDT.CDSS.DataTableDictI("TableNameIndex",TableName,fieldkey,0))
								s UserType=$lg($g(^CT.WDT.CDSS.DataTableDictD(CDSSDTDRowid)),7)  //当前字段在User表中的数据类型
								s UserLength=$lg($g(^CT.WDT.CDSS.DataTableDictD(CDSSDTDRowid)),8)  //当前字段在User表中的长度
								s UserKeyFlag=$lg($g(^CT.WDT.CDSS.DataTableDictD(CDSSDTDRowid)),9) //当前字段在User表中是否是主键
								
			//********************** 主键校验 *****************
								
								if fieldvalue=""  //如果此值为空
								{
									if UserKeyFlag=1   //如果此值为空,判断是否为主键
									{
										s ErrorItem={}
										s Children=[]
										s ChildItem={}
										d ErrorItem.%Set("异常信息来源",MappingUserDesc(TableName))
										d ErrorItem.%Set("异常信息项",fieldkey)
										
										d ChildItem.%Set("异常类型","合理性")
										d ChildItem.%Set("标准要求","此字段为主键")
										d ChildItem.%Set("异常说明","此字段不能为空")
										d Children.%Push(ChildItem)
										
										d ErrorItem.%Set("children",Children)
										d ErrorItem.%Set("影响等级","高")
										d ErrorInfo.%Push(ErrorItem)
									}	
									continue   
								}
								
								
				//*******************长度校验*********************
								s:UserLength="" UserLength=50
								s PatientLength=$l(fieldvalue)
								if UserLength<PatientLength
								{
									s ErrorItem={}
									s Children=[]
									s ChildItem={}
									d ErrorItem.%Set("异常信息来源",MappingUserDesc(TableName))
									d ErrorItem.%Set("异常信息项",fieldkey_":"_fieldvalue)
									
									d ChildItem.%Set("异常类型","合理性")
									d ChildItem.%Set("标准要求","此字段最长为"_UserLength)
									d ChildItem.%Set("异常说明","此字段超长")
									d Children.%Push(ChildItem)
									d ErrorItem.%Set("children",Children)
									d ErrorItem.%Set("影响等级","高")
									d ErrorInfo.%Push(ErrorItem)
								}
								
				//*******************时间校验*********************
								if (fieldkey["Date")||(fieldkey["Time")   //如果是时间格式
								{
									s PatientTimeType= ##class(%Library.TimeStamp).IsValid(fieldvalue)   //检验患者时间格式是否正确
									if ((UserType="date")||(UserType="timestamp"))  //数据库中如果字段类型包含时间关键字
									{
										if PatientTimeType=1
										{
										}
										else              //患者时间数据和数据库字段格式不对
										{
											s ErrorItem={}
											s Children=[]
											s ChildItem={}
											d ErrorItem.%Set("异常信息来源",MappingUserDesc(TableName))
											d ErrorItem.%Set("异常信息项",fieldkey_":"_fieldvalue)
											
											d ChildItem.%Set("异常类型","合理性")
											d ChildItem.%Set("标准要求","标准要求格式:"_UserType)
											d ChildItem.%Set("异常说明","时间格式不符合要求")
											d Children.%Push(ChildItem)
											d ErrorItem.%Set("children",Children)
											
											d ErrorItem.%Set("影响等级","高")
											d ErrorInfo.%Push(ErrorItem)
										}
									}
								}
								
				//***********************数字类型校验********************
								elseif (FieldType="number")    //如果患者数据是数字格式的
								{
									if ((UserType="float")||(UserType="intergar"))   //如果数据库字段也是时间格式
									{
										s ValidType=1
									}
									elseif $match(fieldvalue,"\d.*")
									{
										
									}
									else
									{
										
										s ErrorItem={}
										s Children=[]
										s ChildItem={}
										d ErrorItem.%Set("异常信息来源",MappingUserDesc(TableName))
										d ErrorItem.%Set("异常信息项",fieldkey_":"_fieldvalue)
										
										d ChildItem.%Set("异常类型","合理性")
										d ChildItem.%Set("标准要求","标准要求格式:"_UserType)
										d ChildItem.%Set("异常说明","数字格式不符合要求")
										d Children.%Push(ChildItem)
										
										d ErrorItem.%Set("children",Children)
										d ErrorItem.%Set("影响等级","高")
										d ErrorInfo.%Push(ErrorItem)
									}
									
								}
								
			//******************** 字符串数据类型***************
								else   //如果不是时间格式，则判断数据类型
								{
									if (FieldType=UserType)     //如果患者字段类型和数据库类型一致
									{
										s ValidType=1
									}
									else
									{
										s ErrorItem={}
										s Children=[]
										s ChildItem={}
										
										d ErrorItem.%Set("异常信息来源",MappingUserDesc(TableName))
										d ErrorItem.%Set("异常信息项",fieldkey_":"_fieldvalue)
										
										d ChildItem.%Set("异常类型","合理性")
										d ChildItem.%Set("标准要求","标准要求格式:"_UserType)
										d ChildItem.%Set("异常说明","字符串不符合要求")
										d Children.%Push(ChildItem)
										d ErrorItem.%Set("children",Children)
										d ErrorItem.%Set("影响等级","高")
										d ErrorInfo.%Push(ErrorItem)
									}
								}
								
							}
						}
					}
				}
				  
			}     //如果不是children里面的键值对
			else
			{
				s PatientType = PatientJson.%GetTypeOf(key)   //获取当前键值对的数据类型
				s PatientLength=$l(value)    //获取当前键值对值的长度
				s PatientValue=value
				s TableName=""
				if '$d(^CT.WDT.CDSS.DataTableDictI("FieldNameIndex",key))
				{
					continue
				}
				s TableName=$o(^CT.WDT.CDSS.DataTableDictI("FieldNameIndex",key,""))  //获取数据库中的tablename
				s CDSSDTDRowid=$o(^CT.WDT.CDSS.DataTableDictI("FieldNameIndex",key,TableName,0))
				s UserType=$lg($g(^CT.WDT.CDSS.DataTableDictD(CDSSDTDRowid)),7)  //当前字段在User表中的数据类型
				s UserLength=$lg($g(^CT.WDT.CDSS.DataTableDictD(CDSSDTDRowid)),8)  //当前字段在User表中的长度
				s UserKeyFlag=$lg($g(^CT.WDT.CDSS.DataTableDictD(CDSSDTDRowid)),9) //当前字段在User表中是否是主键
		//********************** 主键校验 *****************
				
				if value=""  //如果此值为空
				{
					if UserKeyFlag=1   //如果此值为空,判断是否为主键
					{
						s ErrorItem={}
						s Children=[]
						s ChildItem={}
						d ErrorItem.%Set("异常信息来源",MappingUserDesc(TableName))
						d ErrorItem.%Set("异常信息项",key_":"_value)
						
						d ChildItem.%Set("异常类型","合理性")
						d ChildItem.%Set("标准要求","此字段为主键")
						d ChildItem.%Set("异常说明","此字段不能为空")
						d Children.%Push(ChildItem)
						
						d ErrorItem.%Set("children",Children)
						d ErrorItem.%Set("影响等级","高")
						d ErrorInfo.%Push(ErrorItem)
					}	
					continue   
				}
				
				
		//*******************长度校验*********************
				s:UserLength="" UserLength=50
				s PatientLength=$l(value)
				if UserLength<PatientLength
				{
					s ErrorItem={}
					s Children=[]
					s ChildItem={}
					d ErrorItem.%Set("异常信息来源",MappingUserDesc(TableName))
					d ErrorItem.%Set("异常信息项",key_":"_value)
					
					d ChildItem.%Set("异常类型","合理性")
					d ChildItem.%Set("标准要求","此字段最长为"_UserLength)
					d ChildItem.%Set("异常说明","此字段超长")
					d Children.%Push(ChildItem)
					
					d ErrorItem.%Set("children",Children)
					d ErrorItem.%Set("影响等级","高")
					d ErrorInfo.%Push(ErrorItem)
				}
								
	//*******************时间校验*********************
				if (key["Date")||(key["Time")   //如果是时间格式
				{
					
					s PatientTimeType= ##class(%Library.TimeStamp).IsValid(value)   //检验患者时间格式是否正确
					if ((UserType="date")||(UserType="timestamp"))  //数据库中如果字段类型包含时间关键字
					{
						
						if PatientTimeType=1
						{
						}
						else              //患者时间数据和数据库字段格式不对
						{
							s ErrorItem={}
							s Children=[]
							s ChildItem={}
							d ErrorItem.%Set("异常信息来源",MappingUserDesc(TableName))
							d ErrorItem.%Set("异常信息项",key_":"_value)
							
							d ChildItem.%Set("异常类型","合理性")
							d ChildItem.%Set("标准要求","标准要求格式:"_UserType)
							d ChildItem.%Set("异常说明","时间格式不符合要求")
							d Children.%Push(ChildItem)
							
							d ErrorItem.%Set("children",Children)
							d ErrorItem.%Set("影响等级","高")
							d ErrorInfo.%Push(ErrorItem)
						}
					}
				}
				
	//***********************数字类型校验********************
				elseif (PatientType="number")    //如果患者数据是时间格式的
				{
					if ((UserType="float")||(UserType="intergar"))   //如果数据库字段也是时间格式
					{
						s ValidType=1
					}
					else
					{
						s ErrorItem={}
						s Children=[]
						s ChildItem={}
						d ErrorItem.%Set("异常信息来源",MappingUserDesc(TableName))
						d ErrorItem.%Set("异常信息项",key_":"_value)
						
						d ChildItem.%Set("异常类型","合理性")
						d ChildItem.%Set("标准要求","标准要求格式:"_UserType)
						d ChildItem.%Set("异常说明","数字格式不符合要求")
						d Children.%Push(ChildItem)
						
						d ErrorItem.%Set("children",Children)
						d ErrorItem.%Set("影响等级","高")
						d ErrorInfo.%Push(ErrorItem)
					}
					
				}
				
	//******************** 字符串数据类型***************
				else   //如果不是时间格式，则判断数据类型
				{
					if (PatientType=UserType)     //如果患者字段类型和数据库类型一致
					{
						s ValidType=1
					}
					else
					{
						s ErrorItem={}
						s Children=[]
						s ChildItem={}
						d ErrorItem.%Set("异常信息来源",MappingUserDesc(TableName))
						d ErrorItem.%Set("异常信息项",key_":"_value)
						
						d ChildItem.%Set("异常类型","合理性")
						d ChildItem.%Set("标准要求","标准要求格式:"_UserType)
						d ChildItem.%Set("异常说明","字符串不符合要求")
						d Children.%Push(ChildItem)
						
						d ErrorItem.%Set("children",Children)
						d ErrorItem.%Set("影响等级","高")
						d ErrorInfo.%Push(ErrorItem)
					}
				}
				
			}
		}
	}
	q ErrorInfo.%ToJSON()
GetUserDesc
	s MappingUserDesc("WDT.CDSS.PatientMaster")="患者基础信息表"
	s MappingUserDesc("WDT.CDSS.PatientVisit")="患者就诊信息表"
	s MappingUserDesc("WDT.CDSS.SignInfo")="患者体征信息表"
	s MappingUserDesc("WDT.CDSS.ChiefCompInfo")="患者主诉信息表"
	s MappingUserDesc("WDT.CDSS.CurrentMedHistory")="患者现病史信息表"
	s MappingUserDesc("WDT.CDSS.PastDiagnosis")="患者既往史信息表"
	s MappingUserDesc("WDT.CDSS.PersonalInfo")="患者个人史信息表"
	s MappingUserDesc("WDT.CDSS.MarryInfo")="患者婚育史信息表"
	s MappingUserDesc("WDT.CDSS.FamilyHisInfo")="患者家族史信息表"
	s MappingUserDesc("WDT.CDSS.AllergyHistory")="患者过敏史信息表"
	s MappingUserDesc("WDT.CDSS.PhysicalExam")="患者体格检查信息表"
	s MappingUserDesc("WDT.CDSS.DiagnosisInfo")="患者诊断信息表"
	s MappingUserDesc("WDT.CDSS.DrugInfo")="患者处方信息表"
	s MappingUserDesc("WDT.CDSS.SpecExam")="患者专科检查信息表"
	s MappingUserDesc("WDT.CDSS.ExamInfo")="患者检查信息表"
	s MappingUserDesc("WDT.CDSS.LabInfo")="患者检验信息表"
	s MappingUserDesc("WDT.CDSS.OperationInfo")="患者手术信息表"
	s MappingUserDesc("WDT.CDSS.AnestInfo")="患者麻醉信息表"
	s MappingUserDesc("WDT.CDSS.NursingInfo")="患者护理信息表"
	s MappingUserDesc("WDT.CDSS.BloodTransInfo")="患者输血信息表"
	s MappingUserDesc("WDT.CDSS.DietInfo")="患者饮食信息表"
	s MappingUserDesc("WDT.CDSS.OtherOrderInfo")="患者其他在院医嘱信息表"
	s MappingUserDesc("WDT.CDSS.InpatientInfo")="患者病历信息表"
	s MappingUserDesc("WDT.CDSS.CarryDrug")="患者出院带药信息表"
	s MappingUserDesc("WDT.CDSS.OtherDisOrderInfo")="患者其他出院医嘱信息表"
}

/// Table: CT.WDT.CDSS.DataTableDict
/// w ##class(web.CDSS.MachineLearning.DataVerification).TempInsertUserDict()
ClassMethod TempInsertUserDict()
{
	TS
	s TableName("WDT.CDSS.PatientMaster")=1
	s TableName("WDT.CDSS.SignInfo")=2
	s TableName("WDT.CDSS.PatientVisit")=3
	s TableName("WDT.CDSS.ChiefCompInfo")=4
	s TableName("WDT.CDSS.CurrentMedHistory")=5
	s TableName("WDT.CDSS.PhysicalExam")=6
	s TableName("WDT.CDSS.SpecExam")=7
	s TableName("WDT.CDSS.PastDiagnosis")=8
	s TableName("WDT.CDSS.PersonalInfo")=9
	s TableName("WDT.CDSS.MarryInfo")=10
	s TableName("WDT.CDSS.FamilyHisInfo")=11   
	s TableName("WDT.CDSS.DiagnosisInfo")=12
	s TableName("WDT.CDSS.DrugInfo")=13
	s TableName("WDT.CDSS.ExamInfo")=14
	s TableName("WDT.CDSS.LabInfo")=15
	s TableName("WDT.CDSS.OperationInfo")=16
	s TableName("WDT.CDSS.AnestInfo")=17
	s TableName("WDT.CDSS.NursingInfo")=18
	s TableName("WDT.CDSS.BloodTransInfo")=19
	s TableName("WDT.CDSS.DietInfo")=20
	s TableName("WDT.CDSS.OtherOrderInfo")=21
	s TableName("WDT.CDSS.InpatientInfo")=22
	s TableName("WDT.CDSS.AllergyHistory")=23
	s TableName("WDT.CDSS.CarryDrug")=24
	s TableName("WDT.CDSS.OtherDisOrderInfo")=25
	
	s Table=""
	for
	{
		s Table=$o(TableName(Table))
		q:Table=""
		

		s Class=##class(%Dictionary.ClassDefinition).%OpenId(Table)
		s PropertyCount=Class.Properties.Count()
		for i=1:1:PropertyCount
		{
			s FieldName=Class.Properties.GetAt(i).Name
			s FieldType=Class.Properties.GetAt(i).Type
			if FieldType["%"
			{
				s FieldType=$zconvert($e(FieldType,2,*),"L")
				s TableFieldFkey=""
			}
			else
			{
				s TableFieldFkey=FieldType
				s FieldType="DR"
			}
			s FieldDescription=Class.Properties.GetAt(i).Description
			s FieldNum=Class.Properties.GetAt(i).SequenceNumber+1
			s FieldDefault=Class.Properties.GetAt(i).InitialExpression
			if FieldDefault=""""""
			{
				s FieldDefault=""
			}
			s Length=""
 			s Length= Class.Properties.GetAt(i).Parameters.GetAt("MAXLEN")
			if Length=""
			{
				s LengthFlag=Class.Properties.GetAt(i).Parameters.IsDefined("MAXLEN")
				if LengthFlag=1
				{
					s Length=9999999999
				}
				else
				{
					s Length=50
				}
			}
			
			s FieldKeyFlag=Class.Properties.GetAt(i).Required
			s obj=##class(CT.WDT.CDSS.DataTableDict).%New()
			s obj.TableSpaceName="DHCDSS"
			s obj.TableName=Table
			s obj.TableNum=TableName(Table)
			s obj.TableFieldNum=FieldNum
			s obj.TableFieldName=FieldName
			s obj.TableFieldClass=FieldType
			s obj.TableFieldDesc=FieldDescription
			s obj.TableFieldKeyFlag=FieldKeyFlag
			s obj.TableFieldDefaults=FieldDefault
			s obj.TableFieldFkey=TableFieldFkey
			s obj.TableFieldLength=Length
			s sc=obj.%Save()
			if $$$ISERR(sc)
			{
				w $system.OBJ.DisplayError(sc),!
				b ;error
			}
		}	
	}
	q ""
}

/// w ##class(web.CDSS.MachineLearning.DataVerification).Export()
ClassMethod Export()
{
	s n=0
	s file=##class(%File).%New("D:\数据库表字典表.csv")
	d file.Open("NWS")
	d file.WriteLine("表空间名,表序号,表名,字段名,字段描述,字段类型,字段长度限制,字段主键标识,外键,默认值,字段顺序")
	s rowid=0
	for
	{
		s rowid=$o(^CT.WDT.CDSS.DataTableDictD(rowid))
		q:rowid=""
		s n=n+1
		s spacename=$lg($g(^CT.WDT.CDSS.DataTableDictD(rowid)),2) //表空间名
		s tablename=$lg($g(^CT.WDT.CDSS.DataTableDictD(rowid)),4) //表名
		s fieldnum=$lg($g(^CT.WDT.CDSS.DataTableDictD(rowid)),5) //序号
		s tablenum=$lg($g(^CT.WDT.CDSS.DataTableDictD(rowid)),3)  //表序号
		s fieldname=$lg($g(^CT.WDT.CDSS.DataTableDictD(rowid)),6) //字段名
		s fieldclass=$lg($g(^CT.WDT.CDSS.DataTableDictD(rowid)),7) //字段类型
		s fieldlength=$lg($g(^CT.WDT.CDSS.DataTableDictD(rowid)),8) //字段长度限制
		s fieldkeyflag=$lg($g(^CT.WDT.CDSS.DataTableDictD(rowid)),9) //字段主键标记
		s fielddeFkey=$lg($g(^CT.WDT.CDSS.DataTableDictD(rowid)),10) //外键
		s fielddefault=$lg($g(^CT.WDT.CDSS.DataTableDictD(rowid)),11) //默认值
		s fielddesc=$lg($g(^CT.WDT.CDSS.DataTableDictD(rowid)),12)  //描述
		d file.WriteLine(spacename_","_tablenum_","_tablename_","_fieldname_","_fielddesc_","_fieldclass_","_fieldlength_","_fieldkeyflag_","_fielddeFkey_","_fielddefault_","_fieldnum)
	}
	d file.%Save()
	d file.Close()
	q n
}

/// Creator:lideyuan
/// CreatDate:2020-04-28
/// Description：对第三方数据json串进行数据一致性校验
/// Input：患者信息json串
/// Output: 
/// s a=[{"IDNO":"620503199901017676","PatientDR":"Test001","VisitID":"1","children":[{"DataClass":"DHCDSSPatientMaster","children":[{"MedicareCardNum":"620503199901017676","IDCardNumber":"620503199901017676","Name":"测试患者","PhoneNumber":"1234567890"}]},{"DataClass":"DHCDSSPatientVisit","children":[{"VisitType":"门诊","TreatmentTime":"2020-04-29 17:15:30","SpecExamSum":"测试数据"}]},{"DataClass":"DHCDSSSignInfo","children":[{"MeasureDate":"2020-04-29 17:20:30","BodyTemperature":"37.2","Weight":"68.9"}]}]}]
/// w ##class(web.CDSS.MachineLearning.DataVerification).Test()

}
