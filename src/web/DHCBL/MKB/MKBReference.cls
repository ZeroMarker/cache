/// Creator:李欣
/// CreateDate:2018-05-04
/// Desc:为引用表提供接口
/// Table:User.MKBReference
Class web.DHCBL.MKB.MKBReference Extends %RegisteredObject
{

/// d ##class(web.DHCBL.MKB.MKBReference).RegenerateAll()
ClassMethod RegenerateAll()
{
	k ^User.MKBReferenceD
	k ^User.MKBReferenceI
	
	d ..ReGenerateRefer()
	w "知识管理完成",!
	d ..ReGenerateReferFromMapping()
	w "规则注册完成",!
	d ..ReGenerateHISICDAndStructData()
	w "数据处理工厂完成",!
	d ..ReGenerateSDSData()
	w "结构化诊断完成",!
	d ..ReGenerateSDSOData()
	w "结构化手术完成",!
	d ..ReGenerateICDData()
	w "各版本icd对照完成",!
	d ..ReGenerateOCRData()
	w "各版本手术对照完成",!
	q ""
}

ClassMethod ReGenerateKLMappingExps()
{
	s MKBKLMBRowId=0
	for
	{
		s MKBKLMBRowId=$O(^User.MKBKLMappingBaseD(MKBKLMBRowId))
		q:MKBKLMBRowId=""
		
		s MKBKLMFChild=0
		for
		{
			s MKBKLMFChild=$O(^User.MKBKLMappingBaseD(MKBKLMBRowId,"ChildField",MKBKLMFChild))
			q:MKBKLMFChild=""
			
			s FieldConfig=$LG($G(^User.MKBKLMappingBaseD(MKBKLMBRowId,"ChildField",MKBKLMFChild)),5)
			continue:FieldConfig'="Exp"	
			
			s RowNum=0
			for
			{
				s RowNum=$O(^User.MKBKLMappingDetailI("RowNumIndex",MKBKLMBRowId,RowNum))
				q:RowNum=""
				
				s MKBKLMDRowId=0
				for
				{
					s MKBKLMDRowId=$O(^User.MKBKLMappingDetailI("ValIndex",RowNum,MKBKLMDRowId))
					q:MKBKLMDRowId=""
					
					s val = $LG($G(^User.MKBKLMappingDetailD(MKBKLMDRowId)),2)
					
					if (subval["-")
					{
						s TermId=$P(subval,"-",1)
						s ProDets=$P(subval,"-",2)
						
						s result1=..SaveDataById(MKBRRowId,"MD",MKBKLMDRowId,"T",TermId)
						s result2=..SaveExpFroReference("MD",MKBKLMDRowId,ProDets)	
					}
					else
					{
						s TermId=subval	
						s MKBRRowId=..GetMKBRRowId("MD",MKBKLMDRowId,"T",TermId)
						s result=..SaveDataById(MKBRRowId,"MD",MKBKLMDRowId,"T",TermId)
					}		
				}	
			}
		}	
	}
}

/// Creator:李欣	
/// Desc:重新生成引用表数据
/// d ##class(web.DHCBL.MKB.MKBReference).ReGenerateRefer()
ClassMethod ReGenerateRefer()
{
	s MKBTBRowId=0
	for
	{
		///术语库
		s MKBTBRowId = $O(^User.MKBTermBaseD(MKBTBRowId))
		q:MKBTBRowId=""
		
		///分类
		s MKBTBCatDr = $LG($G(^User.MKBTermBaseD(MKBTBRowId)),9)
		b:MKBTBCatDr="" ;MKBTBCatDr=""
		for i=1:1:$L(MKBTBCatDr,",")
		{
			s CatDr = $P(MKBTBCatDr,",",i)
			s result1 = ##class(web.DHCBL.MKB.MKBReference).SaveDataById("","B",MKBTBRowId,"T",CatDr)
			;b:result1["error" ;result1["error"
		}
		
		///公有属性
		s MKBTBPRowId = 0
		for
		{
			s MKBTBPRowId = $O(^User.MKBTermBasePropertyI("TermBaseIdx",MKBTBRowId,MKBTBPRowId))
			q:MKBTBPRowId=""
			
			
			s MKBTBPType = $LG($G(^User.MKBTermBasePropertyD(MKBTBPRowId)),4)
			if ((MKBTBPType="S")||(MKBTBPType="SS")||(MKBTBPType="SD"))
			{
				s MKBTBPConfig = $LG($G(^User.MKBTermBasePropertyD(MKBTBPRowId)),6)
				;b:MKBTBPConfig="" ;MKBTBPConfig=""
				///引用术语类型  单节点引用 知识表达式类型
				
				s result2=##class(web.DHCBL.MKB.MKBReference).SaveDataById("","BP",MKBTBPRowId,"B",MKBTBPConfig)
				;b:result2["error" ;result2	
				
				if (MKBTBPType="S")
				{
					///起始节点
					s BDefineNode = $LG($G(^User.MKBTermBasePropertyD(MKBTBPRowId)),10)
					continue:BDefineNode=""
					
					s resultBDN=##class(web.DHCBL.MKB.MKBReference).SaveDataById("","BP",MKBTBPRowId,"T",BDefineNode)
					;b:resultBDN["error"		
				}
			}
			elseif (MKBTBPType="M")
			{
				/// 映射类型
				s MKBTBPConfig = $LG($G(^User.MKBTermBasePropertyD(MKBTBPRowId)),6)
				continue:MKBTBPConfig="" ;MKBTBPConfig=""
				
				s resultBM=##class(web.DHCBL.MKB.MKBReference).SaveDataById("","BP",MKBTBPRowId,"MB",MKBTBPConfig)
				;b:resultBM["error" 
			}
			
			///扩展属性
			s MKBTBEChild=0
			for
			{
				s MKBTBEChild = $O(^User.MKBTermBaseExtendProI("ParIndex",MKBTBPRowId,MKBTBEChild))
				q:MKBTBEChild=""
				
				s MKBTBEType = $LG($G(^User.MKBTermBasePropertyD(MKBTBPRowId,"ChildExt",MKBTBEChild)),3)
				continue:MKBTBEType'="S"
				///引用
				s MKBTBEPConfig = $LG($G(^User.MKBTermBasePropertyD(MKBTBPRowId,"ChildExt",MKBTBEChild)),4)
				continue:MKBTBEPConfig="" ;MKBTBEPConfig=""
				
				s result3=##class(web.DHCBL.MKB.MKBReference).SaveDataById("","BE",MKBTBPRowId_"||"_MKBTBEChild,"B",MKBTBEPConfig)
				;b:result3["error" ;result3
			} 
			///术语
			s MKBTRowId = ""
			for
			{
				s MKBTRowId = $O(^User.MKBTermI("BaseIndex",MKBTBRowId,MKBTRowId))
				q:MKBTRowId=""
				
				s MKBTPRowId = ""
				for
				{
					s MKBTPRowId = $O(^User.MKBTermPropertyI("TermIndex",MKBTRowId,MKBTPRowId))
					q:MKBTPRowId=""
					
					s MKBTPType = $LG($G(^User.MKBTermPropertyD(MKBTPRowId)),4)
					if ((MKBTPType="S")||(MKBTPType="SS"))
					{
						s MKBTPConfig = $LG($G(^User.MKBTermPropertyD(MKBTPRowId)),5)
						continue:MKBTPConfig="" ;MKBTPConfig=""
						///引用术语类型  单节点引用
						
						if (MKBTPType="S")
						{
							///起始节点
							s DefineNode = $LG($G(^User.MKBTermPropertyD(MKBTPRowId)),10)
							continue:DefineNode=""
							
							s resultDN=##class(web.DHCBL.MKB.MKBReference).SaveDataById("","P",MKBTPRowId,"T",DefineNode)
							;b:resultDN["error"		
						}
						
						///属性引用
						s result4=##class(web.DHCBL.MKB.MKBReference).SaveDataById("","P",MKBTPRowId,"B",MKBTPConfig)
						;b:result4["error" ;result4
						
						///属性内容
						s MKBTPDRowId=0
						for
						{
							s MKBTPDRowId = $O(^User.MKBTermProDetailI("ProIdx",MKBTPRowId,MKBTPDRowId))
							q:MKBTPDRowId=""
							
							s MKBTPDDesc = $LG($G(^User.MKBTermProDetailD(MKBTPDRowId)),3)
							;w MKBTPDRowId,MKBTPDDesc,!
							s result8=##class(web.DHCBL.MKB.MKBReference).SaveDataById("","D",MKBTPDRowId,"T",MKBTPDDesc)
							;b:result8["error" ;result8
							
						}
						
						
						
						///起始节点
						s MKBTPDefineNode = $LG($G(^User.MKBTermPropertyD(MKBTPRowId)),10)
						continue:MKBTPDefineNode=""
						if (MKBTPDefineNode'="")
						{
							s result5=##class(web.DHCBL.MKB.MKBReference).SaveDataById("","P",MKBTPRowId,"T",MKBTPDefineNode)
							;b:result5["error" ;result5	
						}						
					}
					elseif (MKBTPType="SD")
					{
						s MKBTPConfig = $LG($G(^User.MKBTermPropertyD(MKBTPRowId)),5)
						continue:MKBTPConfig="" ;MKBTPConfig=""
						///引用术语类型  单节点引用

						///属性引用
						s resultSD=##class(web.DHCBL.MKB.MKBReference).SaveDataById("","P",MKBTPRowId,"B",MKBTPConfig)
						;b:resultSD["error" 
					}	
					elseif (MKBTPType="M")
					{
						s MKBTPConfig = $LG($G(^User.MKBTermPropertyD(MKBTPRowId)),5)
						continue:MKBTPConfig="" ;MKBTPConfig=""
						///引用术语类型  单节点引用

						///属性引用
						s resultM=##class(web.DHCBL.MKB.MKBReference).SaveDataById("","P",MKBTPRowId,"MB",MKBTPConfig)
						;b:resultM["error" 	
					}
					elseif (MKBTPType="P") //诊断模板
					{
						s MKBTPDRowId = $O(^User.MKBTermProDetailI("ProIdx",MKBTPRowId,0))
						if (MKBTPDRowId'="")
						{
							s MKBTPDDesc = $LG($G(^User.MKBTermProDetailD(MKBTPDRowId)),3)
							for k=1:1:$L(MKBTPDDesc,",")
							{
								s temp = $P(MKBTPDDesc,",",k)
								s node = $P(temp,"&",3) ///起始节点
								s type = $P(temp,"&",6) ///类型
								if ((node'="")&&(node'="undefined"))
								;if (node'="")
						        {
							        if (type="T")  //术语
							        {
						       			s result9 = ##class(web.DHCBL.MKB.MKBReference).SaveDataById("", "D", MKBTPDRowId, "T", node)
							        	;b:result9["error" ;result9
							        }
							        else  //属性
							        {
								        s result9 = ##class(web.DHCBL.MKB.MKBReference).SaveDataById("", "D", MKBTPDRowId, "D", node)
							       		;b:result9["error" ;result9
							        }
						        } 	
							}	
						}	
					}
					///扩展属性值
					s MKBTEPChild = 0
					for
					{
						s MKBTEPChild = $O(^User.MKBTermPropertyD(MKBTPRowId,"ChildExtPro",MKBTEPChild))
						q:MKBTEPChild=""
						
						s MKBTEPType = $LG($G(^User.MKBTermPropertyD(MKBTPRowId,"ChildExtPro",MKBTEPChild)),3)
						continue:MKBTEPType'="S"
						
						s MKBTEPConfig = $LG($G(^User.MKBTermPropertyD(MKBTPRowId,"ChildExtPro",MKBTEPChild)),4)
						continue:MKBTEPConfig="" ;MKBTEPConfig=""
						s result6=##class(web.DHCBL.MKB.MKBReference).SaveDataById("","E",MKBTPRowId_"||"_MKBTEPChild,"B",MKBTEPConfig)
						;b:result6["error" ;result6
		 				
						s MKBTPDRowId=0
						for
						{
							s MKBTPDRowId = $O(^User.MKBTermProDetailI("ProIdx",MKBTPRowId,MKBTPDRowId))
							q:MKBTPDRowId=""
							
							s MKBTEPVRowId = $O(^User.MKBTermExtendProValI("ValIndex",MKBTPDRowId,MKBTPRowId_"||"_MKBTEPChild,0))
							continue:MKBTEPVRowId=""
							s MKBTEPVVal = $LG($G(^User.MKBTermExtendProValD(MKBTEPVRowId)),4)	
							
							s result7=##class(web.DHCBL.MKB.MKBReference).SaveDataById("","D",MKBTPDRowId,"T",MKBTEPVVal)
							;b:result7["error" ;result7
						}
					}	
				}
			}
		}	
	}
}

/// Creator:李欣	
/// Desc:重新生成引用表数据-规则管理
/// d ##class(web.DHCBL.MKB.MKBReference).ReGenerateReferFromMapping()
ClassMethod ReGenerateReferFromMapping()
{

	///规则注册
	s MKBKLMBRowId = 0
	for
	{
		s MKBKLMBRowId=$O(^User.MKBKLMappingBaseD(MKBKLMBRowId))
		q:MKBKLMBRowId=""
		
		s kno1 = $LG($G(^User.MKBKLMappingBaseD(MKBKLMBRowId)),5)
		s kno2 = $LG($G(^User.MKBKLMappingBaseD(MKBKLMBRowId)),6)
		
		if ((kno1'="D")&&(kno1'="A"))
		{
			s result1=##class(web.DHCBL.MKB.MKBReference).SaveDataById("","MB",MKBKLMBRowId,"B",kno1)
			;b:result1["error" ;result1	
		}	
		if ((kno2'="D")&&(kno2'="A"))
		{
			s result2=##class(web.DHCBL.MKB.MKBReference).SaveDataById("","MB",MKBKLMBRowId,"B",kno2)
			;b:result2["error" ;result2	
		}
		///字段
		s MKBKLMFChild = 0
		for
		{
			s MKBKLMFChild = $O(^User.MKBKLMappingBaseD(MKBKLMBRowId,"ChildField",MKBKLMFChild))
			q:MKBKLMFChild=""
			
			s MKBKLMFType = $LG($G(^User.MKBKLMappingBaseD(MKBKLMBRowId,"ChildField",MKBKLMFChild)),4)
			if ((MKBKLMFType="K1")||(MKBKLMFType="K2"))	
			{
				s MKBKLMFConfig = $LG($G(^User.MKBKLMappingBaseD(MKBKLMBRowId,"ChildField",MKBKLMFChild)),5)
				if ((MKBKLMFConfig'="Exp")&&(MKBKLMFConfig'="Desc"))	
				{
					s result3 = ##class(web.DHCBL.MKB.MKBReference).SaveDataById("","MF",MKBKLMBRowId_"||"_MKBKLMFChild,"P",MKBKLMFConfig)	
					;b:result3["error" ;result3
				}
				if (MKBKLMFConfig="Desc")
				{
					s RowNum=0
					for
					{
						s RowNum = $O(^User.MKBKLMappingDetailI("RowNumIndex",MKBKLMBRowId,RowNum))
						q:RowNum=""
						
						///内容
						s MKBKLMDRowId=0
						for
						{
							s MKBKLMDRowId = $O(^User.MKBKLMappingDetailI("ValIndex",RowNum,MKBKLMBRowId_"||"_MKBKLMFChild,MKBKLMDRowId))
							q:MKBKLMDRowId=""
							
							s MKBKLMDVal = $LG($G(^User.MKBKLMappingDetailD(MKBKLMDRowId)),2)
							continue:MKBKLMDVal=""
							if ($D(^User.MKBTermD(MKBKLMDVal))=0)
							{
								;w MKBKLMDVal_"->("_MKBKLMDRowId_")->"_MKBKLMBRowId_"||"_MKBKLMFChild,!
								continue	
							}
							s result4 = ##class(web.DHCBL.MKB.MKBReference).SaveDataById("","MD",MKBKLMDRowId,"T",MKBKLMDVal)		
							;b:result4["error" ;result4
						} 	
					}	
				}				
			}
		}
	}
}

/// Creator:李欣	
/// Desc:重新生成引用表数据-HISICD对照，数据处理工厂
/// d ##class(web.DHCBL.MKB.MKBReference).ReGenerateHISICDAndStructData()
ClassMethod ReGenerateHISICDAndStructData()
{
	///StucturedData
	s MKBSDRowId=0
	for
	{
		s MKBSDRowId=$O(^User.MKBStructuredDataD(MKBSDRowId))
		q:MKBSDRowId=""
		
		s Child=0
		for
		{
			s Child=$O(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",Child))
			q:Child=""
			
			s ResultRowId=MKBSDRowId_"||"_Child
			s TermId=$LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",Child)),4)
			s Exp=$LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",Child)),2)
			
			if (TermId'="")
			{
				s MKBRRowId=..GetMKBRRowId("SDR",ResultRowId,"T",TermId)
				s result=..SaveDataById(MKBRRowId,"SDR",ResultRowId,"T",TermId)
				;b:result["error"	
			}
			
			if ((Exp'["-")&&(Exp'=""))
			{
				s result=..SaveExpFroReference("SDR",ResultRowId,Exp)	
				;b:result["error"
			}
		}	
	}
}

/// Creator:谷雪萍	
/// Desc:重新生成引用表数据-插件版结构化手术父子表
/// d ##class(web.DHCBL.MKB.MKBReference).ReGenerateSDSOData()
ClassMethod ReGenerateSDSOData()
{
	s SDSRowId=0
	for
	{
		s SDSRowId=$O(^User.SDSOperationD(SDSRowId))
		q:SDSRowId=""
		
		s SDSTermDR	= $LG($G(^User.SDSOperationD(SDSRowId)),2)
		s SDSSDDr = $LG($G(^User.SDSOperationD(SDSRowId)),7)
		if (SDSTermDR'="")
		{
			s MKBRRowId=..GetMKBRRowId("SDSO",SDSRowId,"T",SDSTermDR)
			s result=..SaveDataById(MKBRRowId,"SDSO",SDSRowId,"T",SDSTermDR)
			;b:result["error"	
		}
		if (SDSSDDr'="")
		{
			s SDSDataSource=##class(web.DHCBL.MKB.MKBConfig).GetConfigValue("SDSOperationResource")  //平台配置-手术短语来源
			if (SDSDataSource["ICD")  //各版本手术对照
			{
				s MKBRRowId=..GetMKBRRowId("SDSO",SDSRowId,"OC",SDSSDDr)
				s result=..SaveDataById(MKBRRowId,"SDSO",SDSRowId,"OC",SDSSDDr)
			}
			else  //数据处理工厂
			{
				s MKBRRowId=..GetMKBRRowId("SDSO",SDSRowId,"SD",SDSSDDr)
				s result=..SaveDataById(MKBRRowId,"SDSO",SDSRowId,"SD",SDSSDDr)
			}
			;b:result["error"	
		}
		s SDSPChild=0
		for
		{
			s SDSPChild = $O(^User.SDSOperationD(SDSRowId,"ChildProperty",SDSPChild))
			q:SDSPChild=""
			
			s SDSProperty = $LG($G(^User.SDSOperationD(SDSRowId,"ChildProperty",SDSPChild)),2)
			s SDSProDetail = $LG($G(^User.SDSOperationD(SDSRowId,"ChildProperty",SDSPChild)),3)
			s SDSFlag = $LG($G(^User.SDSOperationD(SDSRowId,"ChildProperty",SDSPChild)),4)	
			if (SDSProperty'="")
			{
				s MKBRRowId=..GetMKBRRowId("SDSOP",SDSRowId_"||"_SDSPChild,"P",SDSProperty)
				s result=..SaveDataById(MKBRRowId,"SDSOP",SDSRowId_"||"_SDSPChild,"P",SDSProperty)
				;b:result["error"		
			}
			if ((SDSFlag="D")&&(SDSProDetail'=""))
			{
				s MKBRRowId=..GetMKBRRowId("SDSOP",SDSRowId_"||"_SDSPChild,"D",SDSProDetail)
				s result=..SaveDataById(MKBRRowId,"SDSOP",SDSRowId_"||"_SDSPChild,"D",SDSProDetail)
				;b:result["error"	
			}
			if ((SDSFlag="T")&&(SDSProDetail'=""))
			{
				s MKBRRowId=..GetMKBRRowId("SDSOP",SDSRowId_"||"_SDSPChild,"T",SDSProDetail)
				s result=..SaveDataById(MKBRRowId,"SDSOP",SDSRowId_"||"_SDSPChild,"T",SDSProDetail)
				;b:result["error"	
			}
		}
		
	}
}

/// Creator:谷雪萍	
/// Desc:重新生成引用表数据-插件版结构化诊断父子表
/// d ##class(web.DHCBL.MKB.MKBReference).ReGenerateSDSData()
ClassMethod ReGenerateSDSData()
{
	s SDSRowId=0
	for
	{
		s SDSRowId=$O(^User.SDSDiagnosD(SDSRowId))
		q:SDSRowId=""
		
		s SDSTermDR	= $LG($G(^User.SDSDiagnosD(SDSRowId)),2)
		s SDSSDDr = $LG($G(^User.SDSDiagnosD(SDSRowId)),7)
		if (SDSTermDR'="")
		{
			s MKBRRowId=..GetMKBRRowId("SDS",SDSRowId,"T",SDSTermDR)
			s result=..SaveDataById(MKBRRowId,"SDS",SDSRowId,"T",SDSTermDR)
			;b:result["error"	
		}
		if (SDSSDDr'="")
		{
			s SDSDataSource=##class(web.DHCBL.MKB.MKBConfig).GetConfigValue("SDSDataSource")  //平台配置-诊断短语来源
			if (SDSDataSource["ICD")  //各版本ICD对照
			{
				s MKBRRowId=..GetMKBRRowId("SDS",SDSRowId,"ICDX",SDSSDDr)
				s result=..SaveDataById(MKBRRowId,"SDS",SDSRowId,"ICDX",SDSSDDr)
			}
			else  //数据处理工厂
			{
				s MKBRRowId=..GetMKBRRowId("SDS",SDSRowId,"SD",SDSSDDr)
				s result=..SaveDataById(MKBRRowId,"SDS",SDSRowId,"SD",SDSSDDr)
			}
			;b:result["error"	
		}
		s SDSPChild=0
		for
		{
			s SDSPChild = $O(^User.SDSDiagnosD(SDSRowId,"ChildProperty",SDSPChild))
			q:SDSPChild=""
			
			s SDSProperty = $LG($G(^User.SDSDiagnosD(SDSRowId,"ChildProperty",SDSPChild)),2)
			s SDSProDetail = $LG($G(^User.SDSDiagnosD(SDSRowId,"ChildProperty",SDSPChild)),3)
			s SDSFlag = $LG($G(^User.SDSDiagnosD(SDSRowId,"ChildProperty",SDSPChild)),4)	
			if (SDSProperty'="")
			{
				s MKBRRowId=..GetMKBRRowId("SDSP",SDSRowId_"||"_SDSPChild,"P",SDSProperty)
				s result=..SaveDataById(MKBRRowId,"SDSP",SDSRowId_"||"_SDSPChild,"P",SDSProperty)
				;b:result["error"		
			}
			if ((SDSFlag="D")&&(SDSProDetail'=""))
			{
				s MKBRRowId=..GetMKBRRowId("SDSP",SDSRowId_"||"_SDSPChild,"D",SDSProDetail)
				s result=..SaveDataById(MKBRRowId,"SDSP",SDSRowId_"||"_SDSPChild,"D",SDSProDetail)
				;b:result["error"	
			}
			if ((SDSFlag="T")&&(SDSProDetail'=""))
			{
				s MKBRRowId=..GetMKBRRowId("SDSP",SDSRowId_"||"_SDSPChild,"T",SDSProDetail)
				s result=..SaveDataById(MKBRRowId,"SDSP",SDSRowId_"||"_SDSPChild,"T",SDSProDetail)
				;b:result["error"	
			}
		}
		
	}
}

/*ClassMethod ReGenerateSDSData()
{
	s SDSRowId=0
	for
	{
		s SDSRowId=$O(^User.SDSStructDiagnosD(SDSRowId))
		q:SDSRowId=""
		
		s SDSTermDR	= $LG($G(^User.SDSStructDiagnosD(SDSRowId)),2)
		s SDSSDDr = $LG($G(^User.SDSStructDiagnosD(SDSRowId)),13)
		if (SDSTermDR'="")
		{
			s MKBRRowId=..GetMKBRRowId("SDS",SDSRowId,"T",SDSTermDR)
			s result=..SaveDataById(MKBRRowId,"SDS",SDSRowId,"T",SDSTermDR)
			;b:result["error"	
		}
		if (SDSSDDr'="")
		{
			s MKBRRowId=..GetMKBRRowId("SDS",SDSRowId,"SD",SDSSDDr)
			s result=..SaveDataById(MKBRRowId,"SDS",SDSRowId,"SD",SDSSDDr)
			;b:result["error"	
		}
		s SDSPChild=0
		for
		{
			s SDSPChild = $O(^User.SDSStructDiagnosD(SDSRowId,"ChildProperty",SDSPChild))
			q:SDSPChild=""
			
			s SDSProperty = $LG($G(^User.SDSStructDiagnosD(SDSRowId,"ChildProperty",SDSPChild)),2)
			s SDSProDetail = $LG($G(^User.SDSStructDiagnosD(SDSRowId,"ChildProperty",SDSPChild)),3)
			s SDSFlag = $LG($G(^User.SDSStructDiagnosD(SDSRowId,"ChildProperty",SDSPChild)),4)	
			if (SDSProperty'="")
			{
				s MKBRRowId=..GetMKBRRowId("SDSP",SDSRowId_"||"_SDSPChild,"P",SDSProperty)
				s result=..SaveDataById(MKBRRowId,"SDSP",SDSRowId_"||"_SDSPChild,"P",SDSProperty)
				;b:result["error"		
			}
			if ((SDSFlag="D")&&(SDSProDetail'=""))
			{
				s MKBRRowId=..GetMKBRRowId("SDSP",SDSRowId_"||"_SDSPChild,"D",SDSProDetail)
				s result=..SaveDataById(MKBRRowId,"SDSP",SDSRowId_"||"_SDSPChild,"D",SDSProDetail)
				;b:result["error"	
			}
			if ((SDSFlag="T")&&(SDSProDetail'=""))
			{
				s MKBRRowId=..GetMKBRRowId("SDSP",SDSRowId_"||"_SDSPChild,"T",SDSProDetail)
				s result=..SaveDataById(MKBRRowId,"SDSP",SDSRowId_"||"_SDSPChild,"T",SDSProDetail)
				;b:result["error"	
			}
		}
		
	}
}*/
/// Creator:李欣	
/// Desc:重新生成引用表数据-结构化诊断父子表 -安贞版结构化诊断
/// d ##class(web.DHCBL.MKB.MKBReference).ReGenerateSDSData()
/// Creator:李得原	
/// Desc:重新生成引用表数据-各版本icd对照
/// w ##class(web.DHCBL.MKB.MKBReference).ReGenerateICDData()
ClassMethod ReGenerateICDData()
{
	s str=""
	s MKBICDRowid=0
	for
	{
		s MKBICDRowid=$o(^User.MKBICDContrastD(MKBICDRowid))
		q:MKBICDRowid=""
		s MKBICDRRowid=0
		for
		{
			s MKBICDRRowid=$o(^User.MKBICDContrastD(MKBICDRowid,"MKBICDContrastResult",MKBICDRRowid))
			q:MKBICDRRowid=""
			s ResultRowId=MKBICDRowid_"||"_MKBICDRRowid
			s MKBICDTerm=$lg($g(^User.MKBICDContrastD(MKBICDRowid,"MKBICDContrastResult",MKBICDRRowid)),4)
			s MKBICDResultId=$lg($g(^User.MKBICDContrastD(MKBICDRowid,"MKBICDContrastResult",MKBICDRRowid)),2)
			if MKBICDTerm'=""
			{
				s MKBRRowId=..GetMKBRRowId("ICDXR",ResultRowId,"T",MKBICDTerm)
				s result=..SaveDataById(MKBRRowId,"ICDXR",ResultRowId,"T",MKBICDTerm)
				b:result["false"
				if ((MKBICDResultId'["-")&&(MKBICDResultId'=""))
				{
					s result=..SaveExpFroReference("ICDXR",ResultRowId,MKBICDResultId)	
					if result["error"
					{
						s:str'="" str=str_"||"_result
						s:str="" str=result
					}
				}
			}
			
		}
	}
	q str
}

/// Creator:李得原	
/// Desc:重新生成引用表数据-各版本手术对照
/// w ##class(web.DHCBL.MKB.MKBReference).ReGenerateOCRData()
ClassMethod ReGenerateOCRData()
{
	s str=""
	s MKBOCRowid=0
	for
	{
		s MKBOCRowid=$o(^User.MKBOperationContrastD(MKBOCRowid))
		q:MKBOCRowid=""
		s MKBOCRRowid=0
		for
		{
			s MKBOCRRowid=$o(^User.MKBOperationContrastD(MKBOCRowid,"MKBOperationResult",MKBOCRRowid))
			q:MKBOCRRowid=""
			s ResultRowId=MKBOCRowid_"||"_MKBOCRRowid
			s MKBOCRTerm=$lg($g(^User.MKBOperationContrastD(MKBOCRowid,"MKBOperationResult",MKBOCRRowid)),4)
			s MKBOCRResultId=$lg($g(^User.MKBOperationContrastD(MKBOCRowid,"MKBOperationResult",MKBOCRRowid)),2)
			if MKBOCRTerm'=""
			{
				s MKBRRowId=..GetMKBRRowId("OCR",ResultRowId,"T",MKBOCRTerm)
				s result=..SaveDataById(MKBRRowId,"OCR",ResultRowId,"T",MKBOCRTerm)
				b:result["false"
				if ((MKBOCRResultId'["-")&&(MKBOCRResultId'=""))
				{
					s result=..SaveExpFroReference("OCR",ResultRowId,MKBOCRResultId)
					if result["error"
					{
						s:str'="" str=str_"||"_result
						s:str="" str=result
					}
				}
			}
			
		}
	}
	q str
}

/// Creator:李欣	
/// Desc:保存表达式类型(Pro:Det*Det,Pro:SDet*SDet)
/// ##class(web.DHCBL.MKB.MKBStructuredData).GetChiForNewSeqStrucIDs("1768:S16415*S16426","14626")
/// w ##class(web.DHCBL.MKB.MKBReference).SaveExpFroReference("ICDXR","1915||304165","1768:S16415*S16426")
ClassMethod SaveExpFroReference(OriFlag, OriID, Exp)
{
	s OriFlag = ..GetTrueFlag(OriFlag)
	if (..FlagValid(OriFlag)=0)
	{
		s result = "error,传入的标识错误"
		q result	
	}

	if (..IDValid(OriFlag,OriID)=0)
	{
		s result="error,传入的ID值查无此数据"
		q result	
	}
	s ProLen=$L(Exp,",")

	s result=""

	for i=1:1:ProLen
	{
		s Pro=$P($P(Exp,",",i),":",1)
		if (..IDValid("P",Pro)=0)
		{
			s:result'="" result=result_"^error,传入的ID值("_Pro_")查无此数据"	
			s:result="" result="error,传入的ID值("_Pro_")查无此数据"
			continue
		}
		s subresult=""
		s MKBRRowId=..GetMKBRRowId(OriFlag,OriID,"P",Pro)
		s subresult = ..SaveDataById(MKBRRowId,OriFlag,OriID,"P",Pro)
		if (subresult["errro")
		{
			s:result'="" result=result_"^"_subresult	
			s:result="" result=subresult	
		}
		
		s DetLen=$L($P($P(Exp,",",i),":",2),"*")	
		for j=1:1:DetLen
		{
			s Det=$P($P($P(Exp,",",i),":",2),"*",j)
			if Det'["S"
			{
				if (..IDValid("D",Det)=0)
				{
					s:result'="" result=result_"^error,传入的ID值("_Det_")查无此数据"	
					s:result="" result="error,传入的ID值("_Det_")查无此数据"
				}
				q:result'=""
				s subresult=""
				s MKBRRowId=..GetMKBRRowId(OriFlag,OriID,"D",Det)
				s subresult = ..SaveDataById(MKBRRowId,OriFlag,OriID,"D",Det)
				if (subresult["errro")
				{
					s:result'="" result=result_"^"_subresult	
					s:result="" result=subresult	
				}
			}	
			else
			{
				s Det=$P(Det,"S",2)
				if (..IDValid("T",Det)=0)
				{
					s:result'="" result=result_"^error,传入的ID值("_Det_")查无此数据"	
					s:result="" result="error,传入的ID值("_Det_")查无此数据"
				}
				q:result'=""
				s subresult=""
				s MKBRRowId=..GetMKBRRowId(OriFlag,OriID,"T",Det)
				s subresult = ..SaveDataById(MKBRRowId,OriFlag,OriID,"T",Det)
				if (subresult["errro")
				{
					s:result'="" result=result_"^"_subresult	
					s:result="" result=subresult	
				}	
			}
		}
	}
	if (result="")
	{

		s result="success,保存成功"	
	}
	q result
}

/// Creator:李欣
/// CreateDate:2018-05-04
/// Desc:判断标识是否合法
/// Return:1 合法 0不合法
/// Debug:w ##class(web.DHCBL.MKB.MKBReference).FlagValid("A")
ClassMethod FlagValid(Flag)
{
	s result=1
	if (Flag'="B")&&(Flag'="BE")&&(Flag'="BP")&&(Flag'="T")&&(Flag'="P")&&(Flag'="E")&&(Flag'="D")&&(Flag'="ASS")&&(Flag'="MB")&&(Flag'="MF")&&(Flag'="MD")&&(Flag'="DOC")&&(Flag'="SDR")&&(Flag'="ICD")&&(Flag'="SDS")&&(Flag'="SDSP")&&(Flag'="SD")&&(Flag'="ICDXR")&&(Flag'="ICDX")&&(Flag'="OCR")&&(Flag'="OC")&&(Flag'="SDSO")&&(Flag'="SDSOP")
	{
		s result=0	
	}
	q result
}

/// Creator:李欣
/// CreateDate:2018-05-04
/// Desc:获取表名对应的标识
/// Return:
/// Debug:w ##class(web.DHCBL.MKB.MKBReference).GetTrueFlag("User.MKBTerm")
ClassMethod GetTrueFlag(Flag)
{
	s:Flag="User.MKBTermBase" Flag="B"
	s:Flag="User.MKBTermBaseProperty" Flag="BP"
	s:Flag="User.MKBTermBaseExtendPro" Flag="BE"
	s:Flag="User.MKBTerm" Flag="T"
	s:Flag="User.MKBTermProperty" Flag="P"
	s:Flag="User.MKBTermExtendPro" Flag="E"
	s:Flag="User.MKBTermProDetail" Flag="D"
	s:Flag="User.MKBDocManage" Flag="DOC"
	s:Flag="User.MKBAssessment" Flag="ASS"
	s:Flag="User.MKBKLMappingBase" Flag="MB"
	s:Flag="User.MKBKLMappingBaseField" Flag="MF"
	s:Flag="User.MKBKLMappingDetail" Flag="MD"
	s:Flag="User.MKBStructuredDataResult" Flag="SDR"
	s:Flag="User.MKBHISICDContrastResult" Flag="ICD"
	s:Flag="User.SDSDiagnos" Flag="SDS"
	s:Flag="User.SDSDiagnosProperty" Flag="SDSP"
	s:Flag="User.MKBStructuredData" Flag="SD"
	s:Flag="User.MKBICDContrast" Flag="ICDX"
	s:Flag="User.MKBICDContrastResult" Flag="ICDXR"
	s:Flag="User.MKBOperationResult" Flag="OCR"	
	//结构化手术相关 谷雪萍 2020-03-24
	s:Flag="User.MKBOperationContrast" Flag="OC"
	s:Flag="User.SDSOperation" Flag="SDSO"
	s:Flag="User.SDSOperationProperty" Flag="SDSOP"
	q Flag
}

/// Creator:李欣
/// CreateDate:2018-05-04
/// Desc:验证传入的ID值是否合法
/// Return:1合法 0不合法
/// Debug:w ##class(web.DHCBL.MKB.MKBReference).IDValid("SDS","1")
ClassMethod IDValid(Flag, ID)
{
	s result=1
	if (Flag="B")&&($D(^User.MKBTermBaseD(ID))=0)
	{
		s result=0		
	}
	elseif (Flag="BP")&&($D(^User.MKBTermBasePropertyD(ID))=0)
	{
		s result=0	
	}	
	elseif (Flag="BE")&&($D(^User.MKBTermBasePropertyD($P(ID,"||",1),"ChildExt",$P(ID,"||",2)))=0)
	{
		s result=0	
	}
	elseif (Flag="T")&&($D(^User.MKBTermD(ID))=0)
	{
		s result=0	
	}
	elseif (Flag="P")&&($D(^User.MKBTermPropertyD(ID))=0)
	{
		s result=0	
	}
	elseif (Flag="E")&&($D(^User.MKBTermPropertyD($P(ID,"||",1),"ChildExtPro",$P(ID,"||",2)))=0)
	{
		s result=0	
	}
	elseif (Flag="D")&&($D(^User.MKBTermProDetailD(ID))=0)
	{
		s result=0	
	}
	elseif (Flag="DOC")&&($D(^User.MKBDocManageD(ID))=0)
	{
		s result=0	
	}
	elseif (Flag="ASS")&&($D(^User.MKBAssessmentBaseD(ID))=0)
	{
		s result=0	
	}
	elseif (Flag="MB")&&($D(^User.MKBKLMappingBaseD(ID))=0)
	{
		s result=0	
	}
	elseif (Flag="MF")&&($D(^User.MKBKLMappingBaseD($P(ID,"||",1),"ChildField",$P(ID,"||",2)))=0)
	{
		s result=0	
	}
	elseif (Flag="MD")&&($D(^User.MKBKLMappingDetailD(ID))=0)
	{
		s result=0	
	}
	elseif (Flag="SDR")&&($D(^User.MKBStructuredDataD($P(ID,"||",1),"MKBSDStructResult",$P(ID,"||",2)))=0)
	{
		s result=0	
	}
	elseif (Flag="ICD")&&($D(^User.MKBHISICDContrastD($P(ID,"||",1),"MKBHISICDContrastResult",$P(ID,"||",2)))=0)
	{
		s result=0	
	}
	elseif (Flag="SDS")&&($D(^User.SDSDiagnosD(ID))=0)
	{
		s result=0	
	}
	elseif (Flag="SDSP")&&($D(^User.SDSDiagnos($P(ID,"||",1),"ChildProperty",$P(ID,"||",2)))=0)
	{
		s result=0	
	}
	elseif (Flag="SD")&&($D(^User.MKBStructuredDataD(ID))=0)
	{
		s result=0	
	}
	elseif (Flag="ICDX")&&($D(^User.MKBICDContrastD(ID))=0)
	{
		s result=0
	}
	elseif (Flag="ICDXR")&&($D(^User.MKBICDContrastD($P(ID,"||",1),"MKBICDContrastResult",$P(ID,"||",2)))=0)
	{
		s result=0
	}
	elseif (Flag="OCR")&&($D(^User.MKBOperationContrastD($P(ID,"||",1),"MKBOperationResult",$P(ID,"||",2)))=0)
	{
		s result=0
	}
	//结构化手术相关 谷雪萍 2020-03-24
	elseif (Flag="OC")&&($D(^User.MKBOperationContrastD(ID))=0)
	{
		s result=0	
	}
	elseif (Flag="SDSO")&&($D(^User.SDSOperationD(ID))=0)
	{
		s result=0	
	}
	elseif (Flag="SDSOP")&&($D(^User.SDSOperationD($P(ID,"||",1),"ChildProperty",$P(ID,"||",2)))=0)
	{
		s result=0	
	}
	q result
}

/// Desc: 根据传入信息获取引用表ID
ClassMethod GetMKBRRowId(MKBOriginalFlag, MKBOriginalID, MKBReferFlag, MKBReferID)
{
	q:MKBOriginalFlag="" ""
	q:MKBOriginalID="" ""
	q:MKBReferFlag="" ""
	q:MKBReferID="" ""
	s MKBOriginalFlag = ..GetTrueFlag(MKBOriginalFlag)
	s MKBReferFlag = ..GetTrueFlag(MKBReferFlag)
	
	s MKBRRowId = $O(^User.MKBReferenceI("AllIndex",MKBOriginalFlag, MKBOriginalID, MKBReferFlag, MKBReferID,0))
	q MKBRRowId
}

/// Creator:李欣
/// CreateDate:2018-05-04
/// Desc:引用表保存方法
/// Return:error/success,提示信息
/// Debug:w ##class(web.DHCBL.MKB.MKBReference).SaveData("T",545,"T",684)
ClassMethod SaveDataById(MKBRRowId, MKBOriginalFlag, MKBOriginalID, MKBReferFlag, MKBReferID)
{
	s result="suceess,保存成功"
	s MKBOriginalFlag = ..GetTrueFlag(MKBOriginalFlag)
	if (..FlagValid(MKBOriginalFlag)=0)
	{
		s result = "error,传入的标识错误"
		q result	
	}

	if (..IDValid(MKBOriginalFlag,MKBOriginalID)=0)
	{
		s result="error,传入的ID值查无此数据"
		q result	
	}
	s MKBReferFlag = ..GetTrueFlag(MKBReferFlag)
	if (..FlagValid(MKBReferFlag)=0)
	{
		s result = "error,传入的标识错误"
		q result	
	}
	if (MKBReferID'="")
	{
		if (..IDValid(MKBReferFlag,MKBReferID)=0)
		{
			s result="error,传入的ID值查无此数据"
			q result	
		}	
		if (MKBRRowId="")
		{
			s Obj = ##class(User.MKBReference).%New()	
		}
		else
		{
			s Obj = ##Class(User.MKBReference).%OpenId(MKBRRowId)	
		}
		
		s Obj.MKBROriginalFlag = MKBOriginalFlag
		s Obj.MKBROriginalID = MKBOriginalID
		s Obj.MKBRReferFlag = MKBReferFlag
		s Obj.MKBRReferID = MKBReferID
		s sc = Obj.%Save()
		if $$$ERROR(sc)
		{
			s result = "error,"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else
	{
		s sc = ##class(User.MKBReference).%DeleteId(MKBRRowId)	
		if $$$ERROR(sc)
		{
			s result = "error,"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	q result
}

/// Creator:李欣
/// CreateDate:2018-05-04
/// Desc:引用表保存方法
/// Input: oldXXXX:新增时此处为空，原对象数据 newXXX:新增时的数据或修改时的数据
/// Return:error/success,提示信息
/// Debug:w ##class(web.DHCBL.MKB.MKBReference).SaveData("T",545,"T",684)
ClassMethod SaveData(oldMKBOriginalFlag, oldMKBOriginalID, oldMKBReferFlag, oldMKBReferID, newMKBOriginalFlag, newMKBOriginalID, newMKBReferFlag, newMKBReferID)
{
	s result="suceess,保存成功"
	s oldMKBOriginalFlag = ..GetTrueFlag(oldMKBOriginalFlag)
	if (..FlagValid(oldMKBOriginalFlag)=0)
	{
		s result = "error,传入的原标识错误"
		q result	
	}

	if (..IDValid(oldMKBOriginalFlag,oldMKBOriginalID)=0)
	{
		s result="error,传入的原ID值查无此数据"
		q result	
	}
	s MKBReferFlag = ..GetTrueFlag(oldMKBReferFlag)
	if (..FlagValid(oldMKBReferFlag)=0)
	{
		s result = "error,传入的原标识错误"
		q result	
	}
	if (..IDValid(oldMKBReferFlag,oldMKBReferID)=0)
	{
		s result="error,传入的原ID值查无此数据"
		q result	
	}
	s MKBRRowId = ..GetMKBRRowId(oldMKBOriginalFlag, oldMKBOriginalID, oldMKBReferFlag, oldMKBReferID)
	if (MKBRRowId="")
	{
		q "error,参数有误旧数据不存在"	
	}
	s newMKBOriginalFlag = ..GetTrueFlag(newMKBOriginalFlag)
	if (..FlagValid(newMKBOriginalFlag)=0)
	{
		s result = "error,传入的新标识错误"
		q result	
	}

	if (..IDValid(newMKBOriginalFlag,newMKBOriginalID)=0)
	{
		s result="error,传入的新ID值查无此数据"
		q result	
	}
	s MKBReferFlag = ..GetTrueFlag(newMKBReferFlag)
	if (..FlagValid(newMKBReferFlag)=0)
	{
		s result = "error,传入的新标识错误"
		q result	
	}
	if (newMKBReferID'="")
	{
		if (..IDValid(newMKBReferFlag,newMKBReferID)=0)
		{
			s result="error,传入的新ID值查无此数据"
			q result	
		}	
		
		if (MKBRRowId="")
		{
			s Obj = ##class(User.MKBReference).%New()	
		}
		else
		{
			s Obj = ##Class(User.MKBReference).%OpenId(MKBRRowId)	
		}
		
		s Obj.MKBROriginalFlag = newMKBOriginalFlag
		s Obj.MKBROriginalID = newMKBOriginalID
		s Obj.MKBRReferFlag = newMKBReferFlag
		s Obj.MKBRReferID = newMKBReferID
		s sc = Obj.%Save()
		if $$$ERROR(sc)
		{
			s result = "error,"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else
	{
		s sc = ##class(User.MKBReference).%DeleteId(MKBRRowId)	
		if $$$ERROR(sc)
		{
			s result = "error,"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)	
		}
	}
	
	q result
}

/// Creator:李欣
/// CreateDate:2018-05-05
/// Desc:获取被引用的信息
/// Return:
/// Debug:w ##class(web.DHCBL.MKB.MKBReference).GetResult("E",200446||72565)
ClassMethod GetResult(Flag, ID)
{
	s result = ""
	if (Flag="B")
	{
		s Desc = $LG($G(^User.MKBTermBaseD(ID)),3)
		s result = Desc	
	}
	elseif (Flag="BP")
	{
		s BPDesc = $LG($G(^User.MKBTermBasePropertyD(ID)),3)
		s BaseDR = $LG($G(^User.MKBTermBasePropertyD(ID)),5)
		s BaseDesc = $LG($G(^User.MKBTermBaseD(BaseDR)),3)
		s result = BaseDesc_" 的 "_BPDesc	
	}
	elseif (Flag="BE")
	{
		s BEDesc = $LG($G(^User.MKBTermBasePropertyD($P(ID,"||",1),"ChildExt",$P(ID,"||",2))),2)
		s BPDesc = $LG($G(^User.MKBTermBaseD($P(ID,"||",1))),3)	
		s BaseDR = $LG($G(^User.MKBTermBasePropertyD($P(ID,"||",1))),5)
		s BaseDesc = $LG($G(^User.MKBTermBaseD(BaseDR)),3)
		s result=BaseDesc_" 的 "_BPDesc_" 的 "_BEDesc
	}
	elseif (Flag="T")
	{
		s TermDesc = $LG($G(^User.MKBTermD(ID)),3)
		s BaseDR = $LG($G(^User.MKBTermD(ID)),4)
		s BaseDesc = $LG($G(^User.MKBTermBaseD(BaseDR)),3)
		s result = BaseDesc_" 的 "_TermDesc
	}
	elseif (Flag="P")
	{
		s ProDesc = $LG($G(^User.MKBTermPropertyD(ID)),3)
		s TermDR = $LG($G(^User.MKBTermPropertyD(ID)),6)
		s TermDesc = $LG($G(^User.MKBTermD(TermDR)),3)
		s BaseDR = $LG($G(^User.MKBTermD(TermDR)),4)
		s BaseDesc = $LG($G(^User.MKBTermBaseD(BaseDR)),3)
		s result = BaseDesc_" 的 "_TermDesc_" 的 "_ProDesc
	}
	elseif (Flag="E")
	{
		s ExtendProDesc = $LG($G(^User.MKBTermPropertyD($P(ID,"||",1),"ChildExtPro",$P(ID,"||",2))),2)	
		s ProDesc = $LG($G(^User.MKBTermPropertyD($P(ID,"||",1))),3)
		s TermDR = $LG($G(^User.MKBTermPropertyD($P(ID,"||",1))),6)
		s TermDesc = $LG($G(^User.MKBTermD(TermDR)),3)
		s BaseDR = $LG($G(^User.MKBTermD(TermDR)),4)
		s BaseDesc = $LG($G(^User.MKBTermBaseD(BaseDR)),3)
		s result = BaseDesc_" 的 "_TermDesc_" 的 "_ProDesc_" 的 "_ExtendProDesc
	}
	elseif (Flag="D")
	{
		s DetDesc = $LG($G(^User.MKBTermProDetailD(ID)),3)
		s ProDR = $LG($G(^User.MKBTermProDetailD(ID)),6)
		s ProType = $LG($G(^User.MKBTermPropertyD(ProDR)),4)
		s ProDesc = $LG($G(^User.MKBTermPropertyD(ProDR)),3)
		s TermDR = $LG($G(^User.MKBTermPropertyD(ProDR)),6)
		s TermDesc = $LG($G(^User.MKBTermD(TermDR)),3)
		s BaseDR = $LG($G(^User.MKBTermD(TermDR)),4)
		s BaseDesc = $LG($G(^User.MKBTermBaseD(BaseDR)),3)
		
		s result = BaseDesc_" 的 "_TermDesc_" 的 "_ProDesc
	
	}
	elseif (Flag="MB")
	{
		s MBDesc = $LG($G(^User.MKBKLMappingBaseD(ID)),3)
		s result = MBDesc	
	}
	elseif (Flag="MF")
	{
		s MKBKLMBRowId = $P(ID,"||",1)
		s MKBKLMFChild = $P(ID,"||",2)
		s MKBMBDesc = $LG($G(^User.MKBKLMappingBaseD(MKBKLMBRowId)),3)	
		s MKBKLMFDesc = $LG($G(^User.MKBKLMappingBaseD(MKBKLMBRowId,"ChildField",MKBKLMFChild)),3)
		
		s result = MKBMBDesc_"的 "_MKBKLMFDesc
	}
	elseif (Flag="MD")
	{
		s MKBMBRowId = $LG($G(^User.MKBKLMappingDetailD(ID)),5)	
		s MKBKLMBDesc = $LG($G(^User.MKBKLMappingBaseD(MKBMBRowId)),3)
		
		s result = MKBKLMBDesc_"的内容"		
	}
	elseif (Flag="SDR")
	{
		s MKBSDRDiag=$LG($G(^User.MKBStructuredDataD($P(ID,"||",1))),2)
		s MKBSDBase=$LG($G(^User.MKBStructuredDataD($P(ID,"||",1))),22)
		s MKBSDBDesc=$lg($g(^User.MKBStructuredBaseD(MKBSDBase)),2)
		s result = MKBSDBDesc_"的"_MKBSDRDiag
	}
	elseif (Flag="ICD")
	{
		s MKBHICDiag=$LG($G(^User.MKBHISICDContrastD($P(ID,"||",1))),2)
		s result = "HISICD对照的"_MKBHICDiag
	}
	elseif (Flag="SDS")
	{
		s result="结构化诊断业务表"
	}
	elseif (Flag="SDSP")
	{
		s result="结构化诊断业务子表"	
	}
	elseif (Flag="ICDXR")
	{
		s result="各版本ICD对照的"_$lg($g(^User.MKBICDContrastD($p(ID,"||",1))),3)
	}
	elseif (Flag="OCR")
	{
		s result="各版本手术对照的"_$lg($g(^User.MKBOperationContrastD($p(ID,"||",1))),3)
	}
	//结构化手术相关 谷雪萍 2020-03-24
	elseif (Flag="SDSO")
	{
		s result="结构化手术业务表"
	}
	elseif (Flag="SDSOP")
	{
		s result="结构化手术业务子表"	
	}
	q result
}

/// Creator：李欣
/// CreatDate: 2018-05-16
/// Description：获取被引用的列表
/// Input：MKBReferFlag 要删除数据的表 MKBReferID 要删除数据的ID
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBReference","GetReferedList","T","14626")
Query GetReferedList(MKBReferFlag, MKBReferID) As %Query(ROWSPEC = "Flag,ID,Desc")
{
}

ClassMethod GetReferedListExecute(ByRef qHandle As %Binary, MKBReferFlag, MKBReferID) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1

	if ($D(^User.MKBReferenceI("ReferIndex",MKBReferFlag,MKBReferID))'=0)
	{
		s MKBROriginalFlag=""
		for
		{
			s MKBROriginalFlag = $O(^User.MKBReferenceI("InverAllIndex",MKBReferFlag,MKBReferID,MKBROriginalFlag))	
			q:MKBROriginalFlag=""
			
			s MKBROriginalID=0
			for
			{
				s MKBROriginalID=$O(^User.MKBReferenceI("InverAllIndex",MKBReferFlag,MKBReferID,MKBROriginalFlag,MKBROriginalID))		
				q:MKBROriginalID=""
				
				s RederedStr = "被"_..GetResult(MKBROriginalFlag,MKBROriginalID)_"所引用"
				d OutputReferdRow
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputReferdRow
    set Data=$lb(MKBROriginalFlag,MKBROriginalID,RederedStr)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetReferedListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetReferedListExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetReferedListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetReferedListExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 
 Set ind=$o(^CacheTemp(repid,ind))
 If ind=""
 {
  //if there are no more rows,finish fetching...
  Set AtEnd=1
  Set Row=""
 }
 Else
 {
  Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

/// 删除选中的引用数据
/// 删除失败返回错误信息，删除成功返回空------------------------------------------------------------------------------------------------------
/// DeleteId:要删除数据的ID 选中的引用数据的拼串51561||4639
/// w ##class(web.DHCBL.MKB.MKBReference).DeleteSelected("T","2990508","SDR^44688||3734&SDR^44689||3735")
ClassMethod DeleteSelected(MKBReferFlag, DeleteId, FlagAndIDs)
{
	s result=""
	TS
	s len=$L(FlagAndIDs,"&")
	for i=1:1:len
	{
		s subIDs=$P(FlagAndIDs,"&",i)
		s Flag=$p(subIDs,"^",1)
		s ID = $P(subIDs,"^",2)		
		if (Flag["SDSO")  //结构化手术相关 谷雪萍 2020-03-24
		{
			s result = "被结构化手术业务引用，不可删除"	
			q	
		}
		elseif (Flag["SDS")
		{
			s result = "被结构化诊断业务引用，不可删除"	
			q
		} 
		elseif (Flag="B")
		{
			s result=##class(web.DHCBL.MKB.MKBTermBase).DeleteData(ID) 
			q:result["false"
		}
		elseif (Flag="BP")
		{
			s result=##class(web.DHCBL.MKB.MKBTermBaseProperty).DeleteData(ID) 
			q:result["false"	
		}
		elseif (Flag="BE")
		{
			s result=##class(web.DHCBL.MKB.MKBTermBaseExtendPro).DeleteData(ID,"") 
			q:result["false"
		}
		elseif (Flag="T")
		{
			s result=##class(web.DHCBL.MKB.MKBTerm).DeleteData(ID) 
			q:result["false"
		}
		elseif (Flag="P")
		{
			s result=##class(web.DHCBL.MKB.MKBTermProperty).DeleteData(ID) 
			q:result["false"	
		}
		elseif (Flag="D")
		{
			s MKBTPDProDR=$LISTGET($G(^User.MKBTermProDetailD(ID)),6)
			if (MKBTPDProDR'="")
			{
				s MKBTPType=$LISTGET($G(^User.MKBTermPropertyD(MKBTPDProDR)),4)
				if (MKBTPType="P")
				{
					continue
				}
			}
			s result=##class(web.DHCBL.MKB.MKBTermProDetail).DeleteData(ID) 
			q:result["false"
		}
		elseif (Flag="E")
		{
			s result=##class(web.DHCBL.MKB.MKBTermExtendPro).DeleteData(ID,"") 
			q:result["false"
		}
		elseif (Flag="MB")
		{
			s result=##class(web.DHCBL.MKB.MKBKLMappingBase).DeleteData(ID) 
			q:result["false"
		}
		elseif (Flag="MF")
		{
			s result=##class(web.DHCBL.MKB.MKBKLMappingBaseField).DeleteData(ID) 
			q:result["false"
		}
		elseif (Flag="MD")
		{
			s rownum=$LG($G(^User.MKBKLMappingDetailD(ID)),4)
			s base=$LG($G(^User.MKBKLMappingDetailD(ID)),5)
			s result=##class(web.DHCBL.MKB.MKBKLMappingDetail).DeleteData(rownum,base) 
			q:result["false"
		}
		elseif (Flag="SDR")
		{
			//SaveData(Pid As %String, Cid As %String, StructResultID As %String, StructResult As %String, PropertyDR As %String, Supplement As %String)
			;s cobj = ##class(User.MKBStructuredDataResult).%OpenId(ID)
			s Rtermdr=$lg($g(^User.MKBStructuredDataD($p(ID,"||",1),"MKBSDStructResult",$p(ID,"||",2))),4)
			s Rsupplement=$lg($g(^User.MKBStructuredDataD($p(ID,"||",1),"MKBSDStructResult",$p(ID,"||",2))),5)
			if (DeleteId=Rtermdr)
			{
				s result= ##class(web.DHCBL.MKB.MKBStructuredData).DeleteData(ID)
			}
			else
			{
				s oldResultId=$LG($G(^User.MKBStructuredDataD($P(ID,"||",1),"MKBSDStructResult",$P(ID,"||",2))),2)
				if oldResultId=""
				{
					d ##class(web.DHCBL.MKB.MKBReference).DeleteViaOriginal("SDR",ID)
					continue
				}
				if (MKBReferFlag="P")
				{
					k rep
					s num=1
					for m=1:1:$L(oldResultId,",")
					{
						s rep($P($P(oldResultId,",",m),":",1),$P($P(oldResultId,",",m),":",2))=num
						s num=num+1
					}
					k rep(DeleteId)
					s pro=""
					for
					{
						s pro=$O(rep(pro))
						q:pro=""
						
						s detstrs=""
						for
						{
							s detstrs=$O(rep(pro,detstrs))
							q:detstrs=""
							
							s sortrep(rep(pro,detstrs),pro,detstrs)=""	
						}		
					}
					s newResultId=""
					s num=0
					for
					{
						s num=$O(sortrep(num))
						q:num=""
						
						s pro=$O(sortrep(num,""))
						
						s:newResultId'="" newResultId=newResultId_","_pro_":"
						s:newResultId="" newResultId=pro_":"
						s detstrs=""
						for
						{
							s detstrs=$O(sortrep(num,pro,detstrs))
							q:detstrs=""
							
							s newResultId=newResultId_detstrs	
						}		
					}
					s result=##class(web.DHCBL.MKB.MKBStructuredData).SaveData($P(ID,"||",1),ID,newResultId,"",Rtermdr,Rsupplement) 		
				}	
				else
				{
					k rep
					if MKBReferFlag="T"
					{
						s ids=$lg($g(^User.MKBStructuredDataD($p(ID,"||",1),"MKBSDStructResult",$p(ID,"||",2))),2)
						
						k tmp
						s num=1
						for m=1:1:$L(ids,",")
						{
							s subIds=$P(ids,",",m)
							;s subResultId=$replace(subResultId,"S","")        //包含S的字符串
							for j=1:1:$L(subIds,"*")
							{
								s rep($P(subIds,":",1),$P($P(subIds,":",2),"*",j))=num
								s tmp($P($P(subIds,":",2),"*",j),$P(subIds,":",1))=""	
							}
							s num=num+1	
						}
						s ProId=$O(tmp("S"_DeleteId,0))
						s:ProId="" ProId=$O(tmp("SS"_DeleteId,0))
						
						k rep(ProId,"S"_DeleteId)
						k rep(ProId,"SS"_DeleteId)
						
						d SaveAction
						
					}
					else
					{
						s ProId=$LG($G(^User.MKBTermProDetailD(DeleteId)),6)
						s num=1
						for m=1:1:$L(oldResultId,",")
						{
							s subResultId=$P(oldResultId,",",m)
							
							;s subResultId=$replace(subResultId,"S","")        //包含S的字符串
							for j=1:1:$L(subResultId,"*")
							{
								
								s rep($P(subResultId,":",1),$P($P(subResultId,":",2),"*",j))=num
								
								s num=num+1
								k rep(ProId,DeleteId)
							}	
						}
						d SaveAction
					}
					s result=##class(web.DHCBL.MKB.MKBStructuredData).SaveData($P(ID,"||",1),ID,newResultId,"",Rtermdr,Rsupplement)	

				}	
			}	
			q:result["false"
		}
		elseif (Flag="ICD")
		{
			s result=##class(web.DHCBL.MKB.MKBHISICDContrast).DeleteData(ID) 
			q:result["false"
		}
		elseif (Flag="ICDXR")
		{
			s Rtermdr=$lg($g(^User.MKBICDContrastD($p(ID,"||",1),"MKBICDContrastResult",$p(ID,"||",2))),4)
			s Rsupplement=$lg($g(^User.MKBICDContrastD($p(ID,"||",1),"MKBICDContrastResult",$p(ID,"||",2))),5)

			if (DeleteId=Rtermdr)
			{
				s result= ##class(web.DHCBL.MKB.MKBICDContrast).DeleteData(ID)
			}
			else
			{
				s oldResultId=$LG($G(^User.MKBICDContrastD($P(ID,"||",1),"MKBICDContrastResult",$P(ID,"||",2))),2)
				if (MKBReferFlag="P")
				{  
					k sortrep
					k rep
					s num=1
					for m=1:1:$L(oldResultId,",")
					{
						s rep($P($P(oldResultId,",",m),":",1),$P($P(oldResultId,",",m),":",2))=num
						s num=num+1
					}
					k rep(DeleteId)
					s pro=""
					for
					{
						s pro=$O(rep(pro))
						q:pro=""
						
						s detstrs=""
						for
						{
							s detstrs=$O(rep(pro,detstrs))
							q:detstrs=""
							
							s sortrep(rep(pro,detstrs),pro,detstrs)=""	
						}		
					}
					s newResultId=""
					s num=0
					for
					{
						s num=$O(sortrep(num))
						q:num=""
						
						s pro=$O(sortrep(num,""))
						
						s:newResultId'="" newResultId=newResultId_","_pro_":"
						s:newResultId="" newResultId=pro_":"
						s detstrs=""
						for
						{
							s detstrs=$O(sortrep(num,pro,detstrs))
							q:detstrs=""
							
							s newResultId=newResultId_detstrs	
						}		
					}
					s result=##class(web.DHCBL.MKB.MKBICDContrast).SaveData($P(ID,"||",1),ID,newResultId,"",Rtermdr,Rsupplement) 		
				}	
				else
				{
					
					k rep

					if MKBReferFlag="T"       
					{
						s ids=$lg($g(^User.MKBICDContrastD($p(ID,"||",1),"MKBICDContrastResult",$p(ID,"||",2))),2)
						k tmp
						s num=1
						for m=1:1:$L(ids,",")
						{
							s subIds=$P(ids,",",m)
							;s subResultId=$replace(subResultId,"S","")        //包含S的字符串
							for j=1:1:$L(subIds,"*")
							{
								s rep($P(subIds,":",1),$P($P(subIds,":",2),"*",j))=num
								s tmp($P($P(subIds,":",2),"*",j),$P(subIds,":",1))=""	
							}
							s num=num+1	
						}
					
						s ProId=$O(tmp("S"_DeleteId,0))
						s:ProId="" ProId=$O(tmp("SS"_DeleteId,0))
						
						k rep(ProId,"S"_DeleteId)
						k rep(ProId,"SS"_DeleteId)
						s newResultId=""
						d SaveAction 
			
						s result=##class(web.DHCBL.MKB.MKBICDContrast).SaveData($P(ID,"||",1),ID,newResultId,"",Rtermdr,Rsupplement)	
						
						
					}
					else
					{
						s ProId=$LG($G(^User.MKBTermProDetailD(DeleteId)),6)
						s num=1
						for m=1:1:$L(oldResultId,",")
						{
							s subResultId=$P(oldResultId,",",m)
							
							for j=1:1:$L(subResultId,"*")
							{

								s rep($P(subResultId,":",1),$P($P(subResultId,":",2),"*",j))=num
								s num=num+1
								k rep(ProId,DeleteId)
							}	
						}
						s newResultId=""
						d SaveAction
						s result=##class(web.DHCBL.MKB.MKBICDContrast).SaveData($P(ID,"||",1),ID,newResultId,"",Rtermdr,Rsupplement)	
					}
	
				}	
			}	
			q:result["false"
		}
		elseif (Flag="OCR")
		{
			s Rtermdr=$lg($g(^User.MKBOperationContrastD($p(ID,"||",1),"MKBOperationResult",$p(ID,"||",2))),4)
			s Rsupplement=$lg($g(^User.MKBOperationContrastD($p(ID,"||",1),"MKBOperationResult",$p(ID,"||",2))),5)

			if (DeleteId=Rtermdr)
			{
				s result= ##class(web.DHCBL.MKB.MKBOperationContrast).DeleteData(ID)
			}
			else
			{
				s oldResultId=$LG($G(^User.MKBOperationContrastD($P(ID,"||",1),"MKBOperationResult",$P(ID,"||",2))),2)
				if (MKBReferFlag="P")
				{  
					k sortrep
					k rep
					s num=1
					for m=1:1:$L(oldResultId,",")
					{
						s rep($P($P(oldResultId,",",m),":",1),$P($P(oldResultId,",",m),":",2))=num
						s num=num+1
					}
					k rep(DeleteId)
					s pro=""
					for
					{
						s pro=$O(rep(pro))
						q:pro=""
						
						s detstrs=""
						for
						{
							s detstrs=$O(rep(pro,detstrs))
							q:detstrs=""
							
							s sortrep(rep(pro,detstrs),pro,detstrs)=""	
						}		
					}
					s newResultId=""
					s num=0
					for
					{
						s num=$O(sortrep(num))
						q:num=""
						
						s pro=$O(sortrep(num,""))
						
						s:newResultId'="" newResultId=newResultId_","_pro_":"
						s:newResultId="" newResultId=pro_":"
						s detstrs=""
						for
						{
							s detstrs=$O(sortrep(num,pro,detstrs))
							q:detstrs=""
							
							s newResultId=newResultId_detstrs	
						}		
					}
					s result=##class(web.DHCBL.MKB.MKBOperationContrast).SaveData($P(ID,"||",1),ID,newResultId,"",Rtermdr,Rsupplement) 		
				}	
				else
				{
					
					k rep

					if MKBReferFlag="T"       
					{
						s ids=$lg($g(^User.MKBOperationContrastD($p(ID,"||",1),"MKBOperationResult",$p(ID,"||",2))),2)
						k tmp
						s num=1
						for m=1:1:$L(ids,",")
						{
							s subIds=$P(ids,",",m)
							;s subResultId=$replace(subResultId,"S","")        //包含S的字符串
							for j=1:1:$L(subIds,"*")
							{
								s rep($P(subIds,":",1),$P($P(subIds,":",2),"*",j))=num
								s tmp($P($P(subIds,":",2),"*",j),$P(subIds,":",1))=""	
							}
							s num=num+1	
						}
					
						s ProId=$O(tmp("S"_DeleteId,0))
						s:ProId="" ProId=$O(tmp("SS"_DeleteId,0))
						
						k rep(ProId,"S"_DeleteId)
						k rep(ProId,"SS"_DeleteId)
						s newResultId=""
						d SaveAction 
			
						s result=##class(web.DHCBL.MKB.MKBOperationContrast).SaveData($P(ID,"||",1),ID,newResultId,"",Rtermdr,Rsupplement)	
						
						
					}
					else
					{
						s ProId=$LG($G(^User.MKBTermProDetailD(DeleteId)),6)
						s num=1
						for m=1:1:$L(oldResultId,",")
						{
							s subResultId=$P(oldResultId,",",m)
							
							for j=1:1:$L(subResultId,"*")
							{
								s rep($P(subResultId,":",1),$P($P(subResultId,":",2),"*",j))=num
								s num=num+1
								k rep(ProId,DeleteId)
							}	
						}
						s newResultId=""
						d SaveAction
						s result=##class(web.DHCBL.MKB.MKBOperationContrast).SaveData($P(ID,"||",1),ID,newResultId,"",Rtermdr,Rsupplement)	
					}
				}	
			}	
			q:result["false"
		}
		s result=""
	}	
	tc:result=""
	tro:result'=""	
	q result
SaveAction
	k sortrep
	s pro=""
	for
	{
		s pro=$O(rep(pro))
		q:pro=""
		
		s det=""
		for
		{
			s det=$O(rep(pro,det))	
			q:det=""
			
			s sortrep(rep(pro,det),pro,det)=""						
		}
	}	
	s newResultId=""
	s num=0
	for
	{
		s num=$O(sortrep(num))
		q:num=""
		s subnew=""
		s pro=$O(sortrep(num,""))
		
		s det=""
		for
		{
			s det=$O(sortrep(num,pro,det))
			q:det=""
			
			s:subnew'="" subnew=subnew_"*"_det
			s:subnew="" subnew=pro_":"_det
		}		
		s:newResultId'="" newResultId=newResultId_","_subnew
		s:newResultId="" newResultId=subnew
	}
}

/// 删除引用给定数据的数据及对应引用记录
/// 删除失败返回错误信息，删除成功返回空
/// w ##class(web.DHCBL.MKB.MKBReference).DeleteAll("D",1220198)
ClassMethod DeleteAll(MKBReferFlag, MKBReferID)
{
	s result=""
	if ($D(^User.MKBReferenceI("ReferIndex",MKBReferFlag,MKBReferID))'=0)
	{
		TS
		s MKBROriginalFlag=""
		for
		{
			s MKBROriginalFlag = $O(^User.MKBReferenceI("InverAllIndex",MKBReferFlag,MKBReferID,MKBROriginalFlag))	
			q:MKBROriginalFlag=""
			
			s MKBROriginalID=0
			for
			{
				s MKBROriginalID=$O(^User.MKBReferenceI("InverAllIndex",MKBReferFlag,MKBReferID,MKBROriginalFlag,MKBROriginalID))		
				q:MKBROriginalID=""
				if (MKBROriginalFlag["SDSO") //结构化手术相关 谷雪萍 2020-03-24
				{
					s result = "被结构化手术业务引用，不可删除"	
					q
				} 
				if (MKBROriginalFlag["SDS")
				{
					s result = "被结构化诊断业务引用，不可删除"	
					q
				} 
				elseif (MKBROriginalFlag="B")
				{
					s result=##class(web.DHCBL.MKB.MKBTermBase).DeleteData(MKBROriginalID) 
					q:result["false"
				}
				elseif (MKBROriginalFlag="BP")
				{
					s result=##class(web.DHCBL.MKB.MKBTermBaseProperty).DeleteData(MKBROriginalID) 
					q:result["false"
				}
				elseif (MKBROriginalFlag="BE")
				{
					s result=##class(web.DHCBL.MKB.MKBTermBaseExtendPro).DeleteData(MKBROriginalID,"") 
					q:result["false"
				}
				elseif (MKBROriginalFlag="T")
				{
					s result=##class(web.DHCBL.MKB.MKBTerm).DeleteData(MKBROriginalID) 
					q:result["false"
				}
				elseif (MKBROriginalFlag="P")
				{
					s result=##class(web.DHCBL.MKB.MKBTermProperty).DeleteData(MKBROriginalID) 
					q:result["false"
				}
				elseif (MKBROriginalFlag="D")
				{
					s MKBTPDProDR=$LISTGET($G(^User.MKBTermProDetailD(MKBROriginalID)),6)
					if (MKBTPDProDR'="")
					{
						s MKBTPType=$LISTGET($G(^User.MKBTermPropertyD(MKBTPDProDR)),4)
						if (MKBTPType="P")
						{
							continue
						}
					}
					s result=##class(web.DHCBL.MKB.MKBTermProDetail).DeleteData(MKBROriginalID) 
					q:result["false"
				}
				elseif (MKBROriginalFlag="E")
				{
					s result=##class(web.DHCBL.MKB.MKBTermExtendPro).DeleteData(MKBROriginalID,"") 
					q:result["false"
				}
				elseif (MKBROriginalFlag="MB")
				{
					s result=##class(web.DHCBL.MKB.MKBKLMappingBase).DeleteData(MKBROriginalID) 
					q:result["false"
				}
				elseif (MKBROriginalFlag="MF")
				{
					s result=##class(web.DHCBL.MKB.MKBKLMappingBaseField).DeleteData(MKBROriginalID) 
					q:result["false"
				}
				elseif (MKBROriginalFlag="MD")
				{
					s rownum=$LG($G(^User.MKBKLMappingDetailD(MKBROriginalID)),4)
					s base=$LG($G(^User.MKBKLMappingDetailD(MKBROriginalID)),5)
					s result=##class(web.DHCBL.MKB.MKBKLMappingDetail).DeleteData(rownum,base) 
					q:result["false"
				}
				elseif (MKBROriginalFlag="SDR")
				{
					//SaveData(Pid As %String, Cid As %String, StructResultID As %String, StructResult As %String, PropertyDR As %String, Supplement As %String)
					s Rtermdr=$lg($g(^User.MKBStructuredDataD($p(MKBROriginalID,"||",1),"MKBSDStructResult",$p(MKBROriginalID,"||",2))),4)
					s Rsupplement=$lg($g(^User.MKBStructuredDataD($p(MKBROriginalID,"||",1),"MKBSDStructResult",$p(MKBROriginalID,"||",2))),5)
					if (MKBReferID=Rtermdr)
					{
						s result= ##class(web.DHCBL.MKB.MKBStructuredData).DeleteData(MKBROriginalID)
					}
					else
					{
						s oldResultId=$LG($G(^User.MKBStructuredDataD($P(MKBROriginalID,"||",1),"MKBSDStructResult",$P(MKBROriginalID,"||",2))),2)
						if oldResultId=""
						{
							d ##class(web.DHCBL.MKB.MKBReference).DeleteViaOriginal("SDR",MKBROriginalID)
							continue
						}
						if (MKBReferFlag="P")
						{
							k rep
							s num=1
							for m=1:1:$L(oldResultId,",")
							{
								s rep($P($P(oldResultId,",",m),":",1),$P($P(oldResultId,",",m),":",2))=num
								s num=num+1
							}
							k rep(MKBReferID)
							s pro=""
							for
							{
								s pro=$O(rep(pro))
								q:pro=""
								
								s detstrs=""
								for
								{
									s detstrs=$O(rep(pro,detstrs))
									q:detstrs=""
									
									s sortrep(rep(pro,detstrs),pro,detstrs)=""	
								}		
							}
							s newResultId=""
							s num=0
							for
							{
								s num=$O(sortrep(num))
								q:num=""
								
								s pro=$O(sortrep(num,""))
								
								s:newResultId'="" newResultId=newResultId_","_pro_":"
								s:newResultId="" newResultId=pro_":"
								s detstrs=""
								for
								{
									s detstrs=$O(sortrep(num,pro,detstrs))
									q:detstrs=""
									
									s newResultId=newResultId_detstrs	
								}		
							}
							s result=##class(web.DHCBL.MKB.MKBStructuredData).SaveData($P(MKBROriginalID,"||",1),MKBROriginalID,newResultId,"",Rtermdr,Rsupplement) 		
						}	
						else
						{
							k rep
							if MKBReferFlag="T"
							{
								s SDRRowid=0
								for
								{
									s SDRRowid=$o(^User.MKBReferenceI("InverAllIndex","T",MKBReferID,"SDR",SDRRowid))
									q:SDRRowid=""
									s ids=$lg($g(^User.MKBStructuredDataD($p(SDRRowid,"||",1),"MKBSDStructResult",$p(SDRRowid,"||",2))),2)
									
									k tmp
									s num=1
									for m=1:1:$L(ids,",")
									{
										
										s subIds=$P(ids,",",m)
										continue:subIds=""
										;s subResultId=$replace(subResultId,"S","")        //包含S的字符串
										for j=1:1:$L(subIds,"*")
										{
											s rep($P(subIds,":",1),$P($P(subIds,":",2),"*",j))=num
											s tmp($P($P(subIds,":",2),"*",j),$P(subIds,":",1))=""	
										}	
										s num=num+1
									}
									s ProId=$O(tmp("S"_MKBReferID,0))
									s:ProId="" ProId=$O(tmp("SS"_MKBReferID,0))
									
									k rep(ProId,"S"_MKBReferID)
									k rep(ProId,"SS"_MKBReferID)
									d SaveAction
								}
							}
							else
							{
								s ProId=$LG($G(^User.MKBTermProDetailD(MKBReferID)),6)
								s num=1
								for m=1:1:$L(oldResultId,",")
								{
									s subResultId=$P(oldResultId,",",m)
									
									;s subResultId=$replace(subResultId,"S","")        //包含S的字符串
									for j=1:1:$L(subResultId,"*")
									{

										s rep($P(subResultId,":",1),$P($P(subResultId,":",2),"*",j))=num
										s num=num+1
										k rep(ProId,MKBReferID)
									}	
								}
								d SaveAction
							}
							s result=##class(web.DHCBL.MKB.MKBStructuredData).SaveData($P(MKBROriginalID,"||",1),MKBROriginalID,newResultId,"",Rtermdr,Rsupplement)	
						}	
					}	
					q:result["false"
					
				}
				elseif (MKBROriginalFlag="ICD")
				{
					s result=##class(web.DHCBL.MKB.MKBHISICDContrast).DeleteData(MKBROriginalID) 
					q:result["false"
				}
				elseif (MKBROriginalFlag="ICDXR")
				{
					k sortrep
					s Rtermdr=$lg($g(^User.MKBICDContrastD($p(MKBROriginalID,"||",1),"MKBICDContrastResult",$p(MKBROriginalID,"||",2))),4)
					s Rsupplement=$lg($g(^User.MKBICDContrastD($p(MKBROriginalID,"||",1),"MKBICDContrastResult",$p(MKBROriginalID,"||",2))),5)
					if (MKBReferID=Rtermdr)
					{
						s result= ##class(web.DHCBL.MKB.MKBICDContrast).DeleteData(MKBROriginalID)
					}
					else
					{
						s oldResultId=$LG($G(^User.MKBICDContrastD($P(MKBROriginalID,"||",1),"MKBICDContrastResult",$P(MKBROriginalID,"||",2))),2)
						if oldResultId=""
						{
							d ##class(web.DHCBL.MKB.MKBReference).DeleteViaOriginal("ICDXR",MKBROriginalID)
							continue
						}
						if (MKBReferFlag="P")
						{
							k rep
							s num=1
							for m=1:1:$L(oldResultId,",")
							{
								s rep($P($P(oldResultId,",",m),":",1),$P($P(oldResultId,",",m),":",2))=num
								s num=num+1
							}
							k rep(MKBReferID)
							s pro=""
							for
							{
								s pro=$O(rep(pro))
								q:pro=""
								
								s detstrs=""
								for
								{
									s detstrs=$O(rep(pro,detstrs))
									q:detstrs=""
									
									s sortrep(rep(pro,detstrs),pro,detstrs)=""	
								}		
							}
							s newResultId=""
							s num=0
							for
							{
								s num=$O(sortrep(num))
								q:num=""
								
								s pro=$O(sortrep(num,""))
								
								s:newResultId'="" newResultId=newResultId_","_pro_":"
								s:newResultId="" newResultId=pro_":"
								s detstrs=""
								for
								{
									s detstrs=$O(sortrep(num,pro,detstrs))
									q:detstrs=""
									
									s newResultId=newResultId_detstrs	
								}		
							}
							s result=##class(web.DHCBL.MKB.MKBICDContrast).SaveData($P(MKBROriginalID,"||",1),MKBROriginalID,newResultId,"",Rtermdr,Rsupplement) 		
						}	
						else
						{
							k rep
							if MKBReferFlag="T"
							{
								s ICDRRowid=0
								for
								{
									s ICDRRowid=$o(^User.MKBReferenceI("InverAllIndex","T",MKBReferID,"ICDXR",ICDRRowid))
									q:ICDRRowid=""
									s ids=$lg($g(^User.MKBICDContrastD($p(ICDRRowid,"||",1),"MKBICDContrastResult",$p(ICDRRowid,"||",2))),2)
									
									k tmp
									s num=1
									for m=1:1:$L(ids,",")
									{
										s subIds=$P(ids,",",m)
										;s subResultId=$replace(subResultId,"S","")        //包含S的字符串
										for j=1:1:$L(subIds,"*")
										{
											s rep($P(subIds,":",1),$P($P(subIds,":",2),"*",j))=num
											s tmp($P($P(subIds,":",2),"*",j),$P(subIds,":",1))=""	
										}	
										s num=num+1
									}
									s ProId=$O(tmp("S"_MKBReferID,0))
									s:ProId="" ProId=$O(tmp("SS"_MKBReferID,0))
									
									k rep(ProId,"S"_MKBReferID)
									k rep(ProId,"SS"_MKBReferID)
									d SaveAction
								}
							}
							else
							{
								s ProId=$LG($G(^User.MKBTermProDetailD(MKBReferID)),6)
								s num=1
								for m=1:1:$L(oldResultId,",")
								{
									s subResultId=$P(oldResultId,",",m)
									
									for j=1:1:$L(subResultId,"*")
									{

										s rep($P(subResultId,":",1),$P($P(subResultId,":",2),"*",j))=num
										s num=num+1
										k rep(ProId,MKBReferID)
									}	
								}
								d SaveAction
							}
							s result=##class(web.DHCBL.MKB.MKBICDContrast).SaveData($P(MKBROriginalID,"||",1),MKBROriginalID,newResultId,"",Rtermdr,Rsupplement)	
						}	
					}	
					q:result["false"

				}
				elseif  (MKBROriginalFlag="OCR")   //各版本手术对照
				{
					k sortrep
					s Rtermdr=$lg($g(^User.MKBOperationContrastD($p(MKBROriginalID,"||",1),"MKBOperationResult",$p(MKBROriginalID,"||",2))),4)
					s Rsupplement=$lg($g(^User.MKBOperationContrastD($p(MKBROriginalID,"||",1),"MKBOperationResult",$p(MKBROriginalID,"||",2))),5)
					if (MKBReferID=Rtermdr)
					{
						s result= ##class(web.DHCBL.MKB.MKBOperationContrast).DeleteData(MKBROriginalID)
					}
					else
					{
						s oldResultId=$LG($G(^User.MKBICDContrastD($P(MKBROriginalID,"||",1),"MKBICDContrastResult",$P(MKBROriginalID,"||",2))),2)
						if oldResultId=""
						{
							d ##class(web.DHCBL.MKB.MKBReference).DeleteViaOriginal("OCR",MKBROriginalID)
							continue
						}
						if (MKBReferFlag="P")
						{
							k rep
							s num=1
							for m=1:1:$L(oldResultId,",")
							{
								s rep($P($P(oldResultId,",",m),":",1),$P($P(oldResultId,",",m),":",2))=num
								s num=num+1
							}
							k rep(MKBReferID)
							s pro=""
							for
							{
								s pro=$O(rep(pro))
								q:pro=""
								
								s detstrs=""
								for
								{
									s detstrs=$O(rep(pro,detstrs))
									q:detstrs=""
									
									s sortrep(rep(pro,detstrs),pro,detstrs)=""	
								}		
							}
							s newResultId=""
							s num=0
							for
							{
								s num=$O(sortrep(num))
								q:num=""
								
								s pro=$O(sortrep(num,""))
								
								s:newResultId'="" newResultId=newResultId_","_pro_":"
								s:newResultId="" newResultId=pro_":"
								s detstrs=""
								for
								{
									s detstrs=$O(sortrep(num,pro,detstrs))
									q:detstrs=""
									
									s newResultId=newResultId_detstrs	
								}		
							}
							s result=##class(web.DHCBL.MKB.MKBOperationContrast).SaveData($P(MKBROriginalID,"||",1),MKBROriginalID,newResultId,"",Rtermdr,Rsupplement) 		
						}	
						else
						{
							k rep
							if MKBReferFlag="T"
							{
								s OCRRRowid=0
								for
								{
									s OCRRRowid=$o(^User.MKBReferenceI("InverAllIndex","T",MKBReferID,"OCR",OCRRRowid))
									q:OCRRRowid=""
									s ids=$lg($g(^User.MKBOperationContrastD($p(OCRRRowid,"||",1),"MKBOperationResult",$p(OCRRRowid,"||",2))),2)
									
									k tmp
									s num=1
									for m=1:1:$L(ids,",")
									{
										s subIds=$P(ids,",",m)
										;s subResultId=$replace(subResultId,"S","")        //包含S的字符串
										for j=1:1:$L(subIds,"*")
										{
											s rep($P(subIds,":",1),$P($P(subIds,":",2),"*",j))=num
											s tmp($P($P(subIds,":",2),"*",j),$P(subIds,":",1))=""	
										}	
										s num=num+1
									}
									s ProId=$O(tmp("S"_MKBReferID,0))
									s:ProId="" ProId=$O(tmp("SS"_MKBReferID,0))
									
									k rep(ProId,"S"_MKBReferID)
									k rep(ProId,"SS"_MKBReferID)
									d SaveAction
								}
							}
							else
							{
								s ProId=$LG($G(^User.MKBTermProDetailD(MKBReferID)),6)
								s num=1
								for m=1:1:$L(oldResultId,",")
								{
									s subResultId=$P(oldResultId,",",m)
									
									for j=1:1:$L(subResultId,"*")
									{

										s rep($P(subResultId,":",1),$P($P(subResultId,":",2),"*",j))=num
										s num=num+1
										k rep(ProId,MKBReferID)
									}	
								}
								d SaveAction
							}
							s result=##class(web.DHCBL.MKB.MKBOperationContrast).SaveData($P(MKBROriginalID,"||",1),MKBROriginalID,newResultId,"",Rtermdr,Rsupplement)	
						}	
					}	
					q:result["false"
				}
				s result=""
			}
			q:result'=""
		}	
		tc:result=""
		tro:result'=""
	}	
	q result
SaveAction
	k sortrep
	s pro=""
	for
	{
		s pro=$O(rep(pro))
		q:pro=""
		
		s det=""
		for
		{
			s det=$O(rep(pro,det))	
			q:det=""
			
			s sortrep(rep(pro,det),pro,det)=""						
		}
	}	
	s newResultId=""
	s num=0
	for
	{
		s num=$O(sortrep(num))
		q:num=""
		s subnew=""
		s pro=$O(sortrep(num,""))
		
		s det=""
		for
		{
			s det=$O(sortrep(num,pro,det))
			q:det=""
			
			s:subnew'="" subnew=subnew_"*"_det
			s:subnew="" subnew=pro_":"_det
		}		
		s:newResultId'="" newResultId=newResultId_","_subnew
		s:newResultId="" newResultId=subnew
	}
}

/// Creator:李欣
/// CreateDate:2018-05-05
/// Desc:删除引用表数据
/// Input:MKBReferFlag 欲删除的标识 MKBReferID 欲删除的ID
/// Return:
/// Debug:w ##class(web.DHCBL.MKB.MKBReference).DeleteData("T",18156)
ClassMethod DeleteData(MKBReferFlag, MKBReferID)
{
	if (MKBReferFlag="")||(MKBReferID="")
	{
		q "参数为空"	
	}
	s MKBReferFlag = ..GetTrueFlag(MKBReferFlag)
	if (..FlagValid(MKBReferFlag)=0)
	{
		q "标识错误"	
	}
	if (..IDValid(MKBReferFlag,MKBReferID)=0)
	{
		q "ID不存在"	
	}
	if ($D(^User.MKBReferenceI("ReferIndex",MKBReferFlag,MKBReferID))'=0)
	{
		s MKBRRowId=0
		s result=""

		s MKBRRowId = $O(^User.MKBReferenceI("ReferIndex",MKBReferFlag,MKBReferID,MKBRRowId))	
		q:MKBRRowId=""
		s MKBROriginalFlag = $LG($G(^User.MKBReferenceD(MKBRRowId)),2)
		s MKBROriginalID = $LG($G(^User.MKBReferenceD(MKBRRowId)),3)
		if (result'="")
		{
			s result = result_";"_..GetResult(MKBROriginalFlag,MKBROriginalID)	
		}
		else
		{
			s result = "记录被"_..GetResult(MKBROriginalFlag,MKBROriginalID)	
		}
		
		s result = result_"所引用"
		q result
	}
	q ""
}

/// Creator:李欣
/// CreateDate:2018-12-13
/// Desc:删除所有符合original条件的数据
/// originalflag 标识 originalid ID
/// Return:
/// d ##class(web.DHCBL.MKB.MKBReference).DeleteViaOriginal("ICDXR","23660||336072")
ClassMethod DeleteViaOriginal(originalflag, originalid)
{
	s MKBRRowId = 0
	for
	{
		s MKBRRowId = $O(^User.MKBReferenceI("OriginalIndex",originalflag,originalid,MKBRRowId))
		q:MKBRRowId=""
		d ##class(User.MKBReference).%DeleteId(MKBRRowId)	
	}
	q ""
}

}
