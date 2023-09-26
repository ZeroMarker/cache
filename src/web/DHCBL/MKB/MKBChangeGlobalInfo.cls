/// Creator:基础数据平台组-谷雪萍
/// CreatDate:2020-02-24
/// Description：更新医学知识库的Global
Class web.DHCBL.MKB.MKBChangeGlobalInfo Extends %RegisteredObject
{

/// Creator:谷雪萍
/// CreatDate:2020-02-20
/// Description：获取诊断相关数据（包括部位、病因）到临时global里
/// Input：dia 诊断ID,historyName  数据处理工厂名称,productFlag-产品标识 “”：CDSS+结构化诊断，1-只结构化诊断，2-只CDSS
/// Return:1
/// w ##class(web.DHCBL.MKB.MKBChangeGlobalInfo).GetDiaConDataToTempGlobal(dia,historyName,productFlag)
ClassMethod GetDiaConDataToTempGlobal(dia As %String = "", historyName As %String = "", productFlag As %String = "") As %String
{
    //文献管理
    k ^MTEMPMKBDocManageD
    s ^MTEMPMKBDocManageD=^User.MKBDocManageD
    s MKBDMRowId=0
    for{  
      s MKBDMRowId=$o(^User.MKBDocManageD(MKBDMRowId)) q:MKBDMRowId=""  
      s ^MTEMPMKBDocManageD(MKBDMRowId)=^User.MKBDocManageD(MKBDMRowId)
    }  
    
    //遍历知识库注册表
    k ^MTEMPMKBTermBaseD
	k ^MTEMPMKBTermBasePropertyD
	k ^MTEMPMKBTermBasePropertyC
	k ^MTEMPMKBTermD
	k ^MTEMPMKBTermPropertyD
	k ^MTEMPMKBTermPropertyC
	k ^MTEMPMKBTermProDetailD
	k ^MTEMPMKBTermExtendProValD
	s ^MTEMPMKBTermBaseD=^User.MKBTermBaseD
	s ^MTEMPMKBTermBasePropertyD=^User.MKBTermBasePropertyD
	s ^MTEMPMKBTermBasePropertyC("ChildExt")=^User.MKBTermBasePropertyC("ChildExt")
	s ^MTEMPMKBTermD=^User.MKBTermD
    s ^MTEMPMKBTermPropertyD=^User.MKBTermPropertyD
    s ^MTEMPMKBTermPropertyC("ChildExtPro")=^User.MKBTermPropertyC("ChildExtPro")
    s ^MTEMPMKBTermProDetailD=^User.MKBTermProDetailD
    s ^MTEMPMKBTermExtendProValD=^User.MKBTermExtendProValD
	s MKBTBRowId=0
	for{    
		s MKBTBRowId=$o(^User.MKBTermBaseD(MKBTBRowId)) q:MKBTBRowId=""  
		s MKBTBFlag=$LISTGET($G(^User.MKBTermBaseD(MKBTBRowId)),10)  //标识
		s MKBTBDesc=$LISTGET($G(^User.MKBTermBaseD(MKBTBRowId)),3)  //知识库注册名称
		

		if (productFlag="1")  //如果是只部署结构化诊断，则不用导疾病、症状、检查、手术、检验的数据
		{
			continue:(MKBTBDesc="疾病")||(MKBTBDesc="症状")||(MKBTBDesc="检查")||(MKBTBDesc="手术")||(MKBTBDesc="检验")||(MKBTBDesc="护理")||(MKBTBDesc="疾病出院指导")
		}
		if (productFlag="2")  //如果是只部署CDSS,则不用导结构化诊断相关的数据
		{
			continue:(MKBTBFlag="Diagnose")||(MKBTBFlag="TCMDiag")||(MKBTBFlag="Part")||(MKBTBFlag="Pathogeny")||(MKBTBFlag="Cat")||(MKBTBFlag="GenDesc")||(MKBTBFlag="Loc")||(MKBTBDesc="ICD版本")||(MKBTBDesc="诊断类型")||(MKBTBDesc="诊断状态")||(MKBTBDesc="症状体征")||(MKBTBDesc="科室常用治疗手术")||(MKBTBDesc="药物成分分类")||(MKBTBDesc="药物成分")||(MKBTBDesc="其他药理学分类")||(MKBTBDesc="检查检验异常描述")||(MKBTBDesc="全局化词表标记")

		}
		//如果是部署CDSS和结构化诊断
		if (MKBTBFlag="Diagnose")||(MKBTBFlag="TCMDiag")||(MKBTBFlag="Part")||(MKBTBFlag="Pathogeny")||(MKBTBFlag="Cat")||(MKBTBFlag="GenDesc")||(MKBTBFlag="Loc")||(MKBTBDesc="ICD版本")||(MKBTBDesc="诊断类型")||(MKBTBDesc="诊断状态")||(MKBTBDesc="症状体征")||(MKBTBDesc="科室常用治疗手术")||(MKBTBDesc="药物成分分类")||(MKBTBDesc="药物成分")||(MKBTBDesc="其他药理学分类")||(MKBTBDesc="检查检验异常描述")||(MKBTBDesc="全局化词表标记")||(MKBTBDesc="疾病")||(MKBTBDesc="症状")||(MKBTBDesc="检查")||(MKBTBDesc="手术")||(MKBTBDesc="检验")||(MKBTBDesc="护理")||(MKBTBDesc="疾病出院指导")
		{
			s ^MTEMPMKBTermBaseD(MKBTBRowId)=^User.MKBTermBaseD(MKBTBRowId)
			//遍历属性
			s MKBTBPRowId=0
			for  
			{	s MKBTBPRowId=$o(^User.MKBTermBasePropertyI("TermBaseIdx",MKBTBRowId,MKBTBPRowId)) q:MKBTBPRowId="" 
				s ^MTEMPMKBTermBasePropertyD(MKBTBPRowId)=^User.MKBTermBasePropertyD(MKBTBPRowId)
				//遍历扩展属性
				s MKBTBEPChildsub=0
				for 
				{
					S MKBTBEPChildsub=$o(^User.MKBTermBasePropertyD(MKBTBPRowId,"ChildExt",MKBTBEPChildsub)) q:MKBTBEPChildsub=""
					s MKBTBEPRowId=MKBTBPRowId_"||"_MKBTBEPChildsub
					s ^MTEMPMKBTermBasePropertyD(MKBTBPRowId,"ChildExt",MKBTBEPChildsub)=^User.MKBTermBasePropertyD(MKBTBPRowId,"ChildExt",MKBTBEPChildsub)
				}
			}
			//遍历术语
			s MKBTRowId=0
			for  
			{	
				s MKBTRowId=$o(^User.MKBTermI("BaseIndex",MKBTBRowId,MKBTRowId)) q:MKBTRowId="" 
				continue:(dia'="")&(MKBTBFlag="Diagnose")&(MKBTRowId'=dia)  //如果入参不为空，则只取某一个诊断的数据
				d ..GetTermDataToTempGlobal(MKBTRowId)
			}
		}	  	  
	}
	//遍历规则注册
    k ^MTEMPMKBKLMappingBaseD
	k ^MTEMPMKBKLMappingBaseC
	k ^MTEMPMKBKLMappingDetailD
    s ^MTEMPMKBKLMappingBaseD=^User.MKBKLMappingBaseD
    s ^MTEMPMKBKLMappingBaseC("ChildField")=^User.MKBKLMappingBaseC("ChildField")
    s ^MTEMPMKBKLMappingDetailD=^User.MKBKLMappingDetailD 
    if (productFlag'="2")  //如果不是只部署CDSS，则需要导规则管理数据
    {  
		s MKBKMBRowId=0
		for
		{  
			s MKBKMBRowId=$o(^User.MKBKLMappingBaseD(MKBKMBRowId)) 
			q:MKBKMBRowId=""  
			s MKBKMBIdentify=$LISTGET($G(^User.MKBKLMappingBaseD(MKBKMBRowId)),10)
			if ((dia'=""))
			{
				continue:MKBKMBIdentify'="LC"   //只取文献管理的数据
			}
			if ((MKBKMBIdentify="SD")||(MKBKMBIdentify="DD")||(MKBKMBIdentify="LC")||(MKBKMBIdentify="RF"))
			{
				s ^MTEMPMKBKLMappingBaseD(MKBKMBRowId)=^User.MKBKLMappingBaseD(MKBKMBRowId)
				//遍历规则注册字段表
				s MKBKMBFChildSub=0
				for
				{
					s MKBKMBFChildSub = $O(^User.MKBKLMappingBaseD(MKBKMBRowId,"ChildField",MKBKMBFChildSub))
					q:MKBKMBFChildSub=""
					s MKBKMBFRowId = MKBKMBRowId_"||"_MKBKMBFChildSub
					s ^MTEMPMKBKLMappingBaseD(MKBKMBRowId,"ChildField",MKBKMBFChildSub)= ^User.MKBKLMappingBaseD(MKBKMBRowId,"ChildField",MKBKMBFChildSub)
				}
				//遍历规则管理
				s MKBKMDRowId=0
				for
				{
					s MKBKMDRowId=$O(^User.MKBKLMappingDetailI("BaseIndex",MKBKMBRowId,MKBKMDRowId))
					q:MKBKMDRowId=""
					s ^MTEMPMKBKLMappingDetailD(MKBKMDRowId)=^User.MKBKLMappingDetailD(MKBKMDRowId)
				}
			}
		}
    }
	
	//获取结构化诊断录入所需要数据
	if (dia="")
	{   
	    //平台配置
		k ^MTEMPMKBConfigD
		s ^MTEMPMKBConfigD=^User.MKBConfigD 
	    s ConfigRowId=0
	    for
	    {  
	      s ConfigRowId=$o(^User.MKBConfigD(ConfigRowId)) q:ConfigRowId=""  
	      s ^MTEMPMKBConfigD(ConfigRowId)=^User.MKBConfigD(ConfigRowId)
	    }  
	    //评估表
	    k ^MTEMPMKBAssessmentBaseD
		k ^MTEMPMKBAssessmentBaseC
		s ^MTEMPMKBAssessmentBaseD=^User.MKBAssessmentBaseD
	    s ^MTEMPMKBAssessmentBaseC("ChildField")=^User.MKBAssessmentBaseC("ChildField")
	    s ^MTEMPMKBAssessmentBaseC("ChildRules")=^User.MKBAssessmentBaseC("ChildRules")
	    s MKBABRowId=0
	    for
	    {  
	      s MKBABRowId=$o(^User.MKBAssessmentBaseD(MKBABRowId)) q:MKBABRowId=""  
	      s ^MTEMPMKBAssessmentBaseD(MKBABRowId)=^User.MKBAssessmentBaseD(MKBABRowId)
	      s MKBABFChildSub = 0
			for
			{
				s MKBABFChildSub = $O(^User.MKBAssessmentBaseFieldI("ParIndex",MKBABRowId,MKBABFChildSub))
				q:MKBABFChildSub=""
				s MKBABFRowId=MKBABRowId_"||"_MKBABFChildSub
				s ^MTEMPMKBAssessmentBaseD(MKBABRowId,"ChildField",MKBABFChildSub)=^User.MKBAssessmentBaseD(MKBABRowId,"ChildField",MKBABFChildSub)
			}
			s MKBASRChild = 0
			for
			{
				s MKBASRChild = $O(^User.MKBAssessmentScoringRulesI("ParIndex",MKBABRowId,MKBASRChild))
				q:MKBASRChild=""
				
				s MKBASRRowId = MKBABRowId_"||"_MKBASRChild
				s ^MTEMPMKBAssessmentBaseD(MKBABRowId,"ChildRules",MKBASRChild)=^User.MKBAssessmentBaseD(MKBABRowId,"ChildRules",MKBASRChild)

			}
	    } 	
		//工厂注册、数据处理工厂
		k ^MTEMPMKBStructuredBaseD
		k ^MTEMPMKBStructuredDataD
		k ^MTEMPMKBStructuredDataC
		//各版本ICD对照
	    k ^MTEMPMKBICDContrastD
	    k ^MTEMPMKBICDContrastC
	    
	    if (productFlag'="2")  //如果不是只部署CDSS，则需要取数据处理工厂或者各版本ICD数据
	    {
			if (historyName'="")  //如果要取某一数据处理工厂的数据
			{
				s ^MTEMPMKBStructuredBaseD=^User.MKBStructuredBaseD
				s ^MTEMPMKBStructuredDataD=^User.MKBStructuredDataD
			    s ^MTEMPMKBStructuredDataC("MKBSDStructResult")=$g(^User.MKBStructuredDataC("MKBSDStructResult"))
			    s ^MTEMPMKBStructuredDataC("MKBSDStructLoc")=$g(^User.MKBStructuredDataC("MKBSDStructLoc"))
			    s ^MTEMPMKBStructuredDataC("MKBSDStructOther")=$g(^User.MKBStructuredDataC("MKBSDStructOther"))
			    s ^MTEMPMKBStructuredDataC("MKBSDStructProLoc")=$g(^User.MKBStructuredDataC("MKBSDStructProLoc"))
				//工厂注册
			    s MKBSTBRowId=0
			    for
			    {  
				    s MKBSTBRowId=$o(^User.MKBStructuredBaseD(MKBSTBRowId)) q:MKBSTBRowId=""  
				    s MKBSTBDesc=$LISTGET($G(^User.MKBStructuredBaseD(MKBSTBRowId)),2)
				    continue:(MKBSTBDesc'=historyName)  //只提取某一个数据处理工厂的数据
					      
					s ^MTEMPMKBStructuredBaseD(MKBSTBRowId)=^User.MKBStructuredBaseD(MKBSTBRowId)
					//数据处理工厂父表
					s MKBSDRowId=0
					for
					{
						s MKBSDRowId=$o(^User.MKBStructuredDataI("BaseIndex",MKBSTBRowId,MKBSDRowId))
						q:MKBSDRowId=""
						s ^MTEMPMKBStructuredDataD(MKBSDRowId)=^User.MKBStructuredDataD(MKBSDRowId)
						//结构化结果子表
						s rowid=0
						for
						{
							s rowid=$o(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",rowid))
							q:rowid=""
							s ^MTEMPMKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",rowid)=^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",rowid)
						}
						//科室频次子表
						s rowid=0
						for
						{
							s rowid=$o(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructLoc",rowid))
							q:rowid=""
							s ^MTEMPMKBStructuredDataD(MKBSDRowId,"MKBSDStructLoc",rowid)=^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructLoc",rowid)
						}
						//别名/其他描述子表
						s rowid=0
						for
						{
							s rowid=$o(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructOther",rowid))
							q:rowid=""
							s ^MTEMPMKBStructuredDataD(MKBSDRowId,"MKBSDStructOther",rowid)=^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructOther",rowid)
						}
						//专业科室子表
						s rowid=0
						for
						{
							s rowid=$o(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructProLoc",rowid))
							q:rowid=""
							s ^MTEMPMKBStructuredDataD(MKBSDRowId,"MKBSDStructProLoc",rowid)=^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructProLoc",rowid)
						}
						
					}

			    } 
			}
			else  //如果没有该项目的数据处理工厂，则取各版本ICD对照的数据
			{    
				s ^MTEMPMKBICDContrastD=^User.MKBICDContrastD
			    s ^MTEMPMKBICDContrastC("MKBICDContrastResult")=$g(^User.MKBICDContrastC("MKBICDContrastResult"))
			    s MKBICDRowId=0
			    for
			    {  
				    s MKBICDRowId=$o(^User.MKBICDContrastD(MKBICDRowId)) q:MKBICDRowId=""  
					s ^MTEMPMKBICDContrastD(MKBICDRowId)=^User.MKBICDContrastD(MKBICDRowId)
					//各版本ICD对照结果子表
					s rowid=0
					for
					{
						s rowid=$o(^User.MKBICDContrastD(MKBICDRowId,"MKBICDContrastResult",rowid))
						q:rowid=""
						s ^MTEMPMKBICDContrastD(MKBICDRowId,"MKBICDContrastResult",rowid)=^User.MKBICDContrastD(MKBICDRowId,"MKBICDContrastResult",rowid)
					} 
			    }
			}
	    }
	}
	q 1
}

/// Creator:谷雪萍
/// CreatDate:2020-02-20
/// Description：获取一个术语的数据存到临时global里
/// Input：dia 术语ID
/// Return:1
/// w ##class(web.DHCBL.MKB.MKBChangeGlobalInfo).GetTermDataToTempGlobal(1650775)
ClassMethod GetTermDataToTempGlobal(dia As %String) As %String
{
	q:dia="" 0
	
    s ^MTEMPMKBTermD(dia)=^User.MKBTermD(dia)    
	
    //遍历该诊断属性
	s MKBTPRowId=""
	for  
	{	
		s MKBTPRowId=$o(^User.MKBTermPropertyI("TermIndex",dia,MKBTPRowId)) q:MKBTPRowId=""  
		if ($d(^User.MKBTermPropertyD(MKBTPRowId))=0)
		{
			continue
		}
		s ^MTEMPMKBTermPropertyD(MKBTPRowId)=^User.MKBTermPropertyD(MKBTPRowId)	
			
		//遍历扩展属性表
		s MKBTEPChildsub=0    
		for   
		{
			S MKBTEPChildsub=$o(^User.MKBTermPropertyD(MKBTPRowId,"ChildExtPro",MKBTEPChildsub)) q:MKBTEPChildsub=""
			s MKBTEPRowId=MKBTPRowId_"||"_MKBTEPChildsub
			s ^MTEMPMKBTermPropertyD(MKBTPRowId,"ChildExtPro",MKBTEPChildsub)=^User.MKBTermPropertyD(MKBTPRowId,"ChildExtPro",MKBTEPChildsub)
		}
		
		//遍历属性内容
		s MKBTPDRowId=0
		for  
		{	
			s MKBTPDRowId=$o(^User.MKBTermProDetailI("ProIdx",MKBTPRowId,MKBTPDRowId)) q:MKBTPDRowId=""
			if ($d(^User.MKBTermProDetailD(MKBTPDRowId))=0)
			{
				continue
			}
			s ^MTEMPMKBTermProDetailD(MKBTPDRowId)=^User.MKBTermProDetailD(MKBTPDRowId)
			//遍历扩展属性内容表
			s MKBTEPVRowId=0
			for  
			{	
				s MKBTEPVRowId=$o(^User.MKBTermExtendProValI("DetailIndex",MKBTPDRowId,MKBTEPVRowId)) q:MKBTEPVRowId=""
				s ^MTEMPMKBTermExtendProValD(MKBTEPVRowId)=^User.MKBTermExtendProValD(MKBTEPVRowId)
			}
		}	
		
	}
    q 1
}

/// Creator:谷雪萍
/// CreatDate:2020-02-20
/// Description：获取临时global的数据保存到知识库表里
/// Input：configFlag-是否导入平台配置数据 空-导（默认），1-不导,IndexFlag-是否生成全文检索，默认不生成
/// Return:1
/// w ##class(web.DHCBL.MKB.MKBChangeGlobalInfo).GetTempGlobalToMKBTable()
ClassMethod GetTempGlobalToMKBTable(configFlag As %String = "") As %String
{
	
	b ;确定要删除本地医学知识库数据，重新导入吗？ 确定输g 返回输q

	//把临时global赋值给正式的global	
	
	//文献 ^MTEMPMKBDocManageD 
	if ($d(^MTEMPMKBDocManageD)>0)
	{
		k ^User.MKBDocManageD   //文献
		k ^User.MKBDocManageI
		s ^User.MKBDocManageD=^MTEMPMKBDocManageD
		s MKBDMRowId=0
	    for{  
	      s MKBDMRowId=$o(^MTEMPMKBDocManageD(MKBDMRowId)) q:MKBDMRowId=""  
	      s ^User.MKBDocManageD(MKBDMRowId)=^MTEMPMKBDocManageD(MKBDMRowId)
	    } 
	    k ^MTEMPMKBDocManageD
	    d ##class(User.MKBDocManage).%BuildIndices()
	}
  
	
	//保存到知识库注册表
	if ($d(^MTEMPMKBTermBaseD)>0)
	{
		k ^User.MKBTermBaseD	//术语库注册表 
		k ^User.MKBTermBaseI	//术语库注册表 
		s ^User.MKBTermBaseD=^MTEMPMKBTermBaseD
		s MKBTBRowId=0
		for{    
			s MKBTBRowId=$o(^MTEMPMKBTermBaseD(MKBTBRowId)) q:MKBTBRowId=""  
			s ^User.MKBTermBaseD(MKBTBRowId)=^MTEMPMKBTermBaseD(MKBTBRowId)
		}
		k ^MTEMPMKBTermBaseD
		d ##class(User.MKBTermBase).%BuildIndices()
	}
	
	//保存到知识库注册属性表和扩展属性表
	if (($d(^MTEMPMKBTermBasePropertyD)>0)&($d(^MTEMPMKBTermBasePropertyC)>0))
	{
		k ^User.MKBTermBasePropertyI	//术语库注册属性表 
		k ^User.MKBTermBasePropertyD	//术语库注册属性表
		k ^User.MKBTermBasePropertyC	//术语库注册属性表	
	 	k ^User.MKBTermBaseExtendProI	//术语库注册扩展属性表
	 	
		s ^User.MKBTermBasePropertyD=^MTEMPMKBTermBasePropertyD
		s ^User.MKBTermBasePropertyC("ChildExt")=^MTEMPMKBTermBasePropertyC("ChildExt")
		s MKBTBPRowId=0
		for{	      
			s MKBTBPRowId=$o(^MTEMPMKBTermBasePropertyD(MKBTBPRowId)) q:MKBTBPRowId=""  
			s ^User.MKBTermBasePropertyD(MKBTBPRowId)=^MTEMPMKBTermBasePropertyD(MKBTBPRowId)    
			s MKBTBEPChildsub=0    
			for   
			{
				S MKBTBEPChildsub=$o(^MTEMPMKBTermBasePropertyD(MKBTBPRowId,"ChildExt",MKBTBEPChildsub)) q:MKBTBEPChildsub=""
				s ^User.MKBTermBasePropertyD(MKBTBPRowId,"ChildExt",MKBTBEPChildsub)=^MTEMPMKBTermBasePropertyD(MKBTBPRowId,"ChildExt",MKBTBEPChildsub)
			}
		}
		k ^MTEMPMKBTermBasePropertyD
		k ^MTEMPMKBTermBasePropertyC
		d ##class(User.MKBTermBaseProperty).%BuildIndices()
		d ##class(User.MKBTermBaseExtendPro).%BuildIndices()
	}
	
	//保存到术语表
	if ($d(^MTEMPMKBTermD)>0)
	{
		k ^User.MKBTermD	//术语表
	 	k ^User.MKBTermI	//术语表
		s ^User.MKBTermD=^MTEMPMKBTermD	
		s MKBTRowId=0
		for{    
			s MKBTRowId=$o(^MTEMPMKBTermD(MKBTRowId)) q:MKBTRowId=""  
			s ^User.MKBTermD(MKBTRowId)=^MTEMPMKBTermD(MKBTRowId)    
		}
		k ^MTEMPMKBTermD
		d ##class(User.MKBTerm).%BuildIndices()
	}
	
	//保存到属性表和扩展属性表
	if (($d(^MTEMPMKBTermPropertyD)>0)&($d(^MTEMPMKBTermPropertyC)>0))
	{
		k ^User.MKBTermPropertyD	//术语维护属性表
		k ^User.MKBTermPropertyI	//术语维护属性表
		k ^User.MKBTermPropertyC	//术语属性表
		k ^User.MKBTermExtendProI	//术语扩展属性表	
		s ^User.MKBTermPropertyD=^MTEMPMKBTermPropertyD
		s ^User.MKBTermPropertyC("ChildExtPro")=^MTEMPMKBTermPropertyC("ChildExtPro")
		s MKBTPRowId=0
		for{	      
			s MKBTPRowId=$o(^MTEMPMKBTermPropertyD(MKBTPRowId)) q:MKBTPRowId=""  
			s ^User.MKBTermPropertyD(MKBTPRowId)=^MTEMPMKBTermPropertyD(MKBTPRowId)    
			s MKBTEPChildsub=0    
			for   
			{
				S MKBTEPChildsub=$o(^MTEMPMKBTermPropertyD(MKBTPRowId,"ChildExtPro",MKBTEPChildsub)) q:MKBTEPChildsub=""
				s ^User.MKBTermPropertyD(MKBTPRowId,"ChildExtPro",MKBTEPChildsub)=^MTEMPMKBTermPropertyD(MKBTPRowId,"ChildExtPro",MKBTEPChildsub)
			}
		}
		k ^MTEMPMKBTermPropertyD
		k ^MTEMPMKBTermPropertyC
		d ##class(User.MKBTermProperty).%BuildIndices()
		d ##class(User.MKBTermExtendPro).%BuildIndices()
	}
  
	//保存到属性内容表
	if ($d(^MTEMPMKBTermProDetailD)>0)
	{
		k ^User.MKBTermProDetailD	//术语属性内容表
		k ^User.MKBTermProDetailI	//术语属性内容表	
		s ^User.MKBTermProDetailD=^MTEMPMKBTermProDetailD
		s MKBTPDRowId=0
		for  
		{	
			s MKBTPDRowId=$o(^MTEMPMKBTermProDetailD(MKBTPDRowId)) q:MKBTPDRowId=""
			s ^User.MKBTermProDetailD(MKBTPDRowId)=^MTEMPMKBTermProDetailD(MKBTPDRowId)
		}
		k ^MTEMPMKBTermProDetailD
		d ##class(User.MKBTermProDetail).%BuildIndices()
	}
	
	//保存到扩展属性内容表
	if ($d(^MTEMPMKBTermExtendProValD)>0)
	{
		k ^User.MKBTermExtendProValD	//扩展属性值表
		k ^User.MKBTermExtendProValI	//扩展属性值表	
		s ^User.MKBTermExtendProValD=^MTEMPMKBTermExtendProValD
		s MKBTEPVRowId=0
		for  
		{	
			s MKBTEPVRowId=$o(^MTEMPMKBTermExtendProValD(MKBTEPVRowId)) q:MKBTEPVRowId=""
			s ^User.MKBTermExtendProValD(MKBTEPVRowId)=^MTEMPMKBTermExtendProValD(MKBTEPVRowId)
		} 
		k ^MTEMPMKBTermExtendProValD
		d ##class(User.MKBTermExtendProVal).%BuildIndices()
	}
	
	//平台配置
    if ((configFlag="")&($d(^MTEMPMKBConfigD)>0))
    {
		k ^User.MKBConfigD
		k ^User.MKBConfigI
		s ^User.MKBConfigD=^MTEMPMKBConfigD
	    s ConfigRowId=0
	    for{  
	      s ConfigRowId=$o(^MTEMPMKBConfigD(ConfigRowId)) q:ConfigRowId=""  
	      s ^User.MKBConfigD(ConfigRowId)=^MTEMPMKBConfigD(ConfigRowId)
	    } 	    
	    d ##class(User.MKBConfig).%BuildIndices() 
    }
    k ^MTEMPMKBConfigD
    
	//遍历评估表
	if (($d(^MTEMPMKBAssessmentBaseD)>0)&($d(^MTEMPMKBAssessmentBaseC)>0))
	{
		k ^User.MKBAssessmentBaseD
		k ^User.MKBAssessmentBaseI
		k ^User.MKBAssessmentBaseC
		k ^User.MKBAssessmentBaseFieldI
		k ^User.MKBAssessmentScoringRulesI
		s ^User.MKBAssessmentBaseD=^MTEMPMKBAssessmentBaseD
		s ^User.MKBAssessmentBaseC("ChildField")=^MTEMPMKBAssessmentBaseC("ChildField")
		s ^User.MKBAssessmentBaseC("ChildRules")=^MTEMPMKBAssessmentBaseC("ChildRules")
		s MKBABRowId=0
		for
		{  
			s MKBABRowId=$o(^MTEMPMKBAssessmentBaseD(MKBABRowId)) q:MKBABRowId=""
			s ^User.MKBAssessmentBaseD(MKBABRowId)=^MTEMPMKBAssessmentBaseD(MKBABRowId)
			s MKBABFChildSub=0
			for
			{
				s MKBABFChildSub = $O(^MTEMPMKBAssessmentBaseD(MKBABRowId,"ChildField",MKBABFChildSub))
				q:MKBABFChildSub=""
				s MKBABFRowId = MKBABRowId_"||"_MKBABFChildSub
				s ^User.MKBAssessmentBaseD(MKBABRowId,"ChildField",MKBABFChildSub)= ^MTEMPMKBAssessmentBaseD(MKBABRowId,"ChildField",MKBABFChildSub)
			}
			s MKBASRChild = 0
			for
			{
				s MKBASRChild = $O(^MTEMPMKBAssessmentBaseD(MKBABRowId,"ChildRules",MKBASRChild))
				q:MKBASRChild=""
				
				s MKBASRRowId = MKBABRowId_"||"_MKBASRChild
				s ^User.MKBAssessmentBaseD(MKBABRowId,"ChildRules",MKBASRChild)= ^MTEMPMKBAssessmentBaseD(MKBABRowId,"ChildRules",MKBASRChild)

			}
		}
		k ^MTEMPMKBAssessmentBaseD
		k ^MTEMPMKBAssessmentBaseC
		d ##class(User.MKBAssessmentBase).%BuildIndices()
		d ##class(User.MKBAssessmentBaseField).%BuildIndices()
		d ##class(User.MKBAssessmentScoringRules).%BuildIndices()
	}
	
	//遍历规则注册
	if (($d(^MTEMPMKBKLMappingBaseD)>0)&($d(^MTEMPMKBKLMappingBaseC)>0))
	{
		k ^User.MKBKLMappingBaseD
		k ^User.MKBKLMappingBaseI
		k ^User.MKBKLMappingBaseC
		k ^User.MKBKLMappingBaseFieldI
		s ^User.MKBKLMappingBaseD=^MTEMPMKBKLMappingBaseD
		s ^User.MKBKLMappingBaseC("ChildField")=^MTEMPMKBKLMappingBaseC("ChildField")
		s MKBKMBRowId=0
		for
		{  
			s MKBKMBRowId=$o(^MTEMPMKBKLMappingBaseD(MKBKMBRowId)) q:MKBKMBRowId=""
			s ^User.MKBKLMappingBaseD(MKBKMBRowId)=^MTEMPMKBKLMappingBaseD(MKBKMBRowId)
			//遍历规则注册字段表
			s MKBKMBFChildSub=0
			for
			{
				s MKBKMBFChildSub = $O(^MTEMPMKBKLMappingBaseD(MKBKMBRowId,"ChildField",MKBKMBFChildSub))
				q:MKBKMBFChildSub=""
				s MKBKMBFRowId = MKBKMBRowId_"||"_MKBKMBFChildSub
				s ^User.MKBKLMappingBaseD(MKBKMBRowId,"ChildField",MKBKMBFChildSub)= ^MTEMPMKBKLMappingBaseD(MKBKMBRowId,"ChildField",MKBKMBFChildSub)
			}
		}
		k ^MTEMPMKBKLMappingBaseD
		k ^MTEMPMKBKLMappingBaseC
		d ##class(User.MKBKLMappingBase).%BuildIndices()
		d ##class(User.MKBKLMappingBaseField).%BuildIndices()
	}
	
	//遍历规则管理
	if ($d(^MTEMPMKBKLMappingDetailD)>0)
	{
		k ^User.MKBKLMappingDetailD
		k ^User.MKBKLMappingDetailI
		s ^User.MKBKLMappingDetailD=^MTEMPMKBKLMappingDetailD
		s MKBKMDRowId=0
		for
		{
			s MKBKMDRowId=$O(^MTEMPMKBKLMappingDetailD(MKBKMDRowId))
			q:MKBKMDRowId=""
			s ^User.MKBKLMappingDetailD(MKBKMDRowId)=^MTEMPMKBKLMappingDetailD(MKBKMDRowId)
		}
		k ^MTEMPMKBKLMappingDetailD
		d ##class(User.MKBKLMappingDetail).%BuildIndices()
		
		d ##class(web.DHCBL.MKB.MKBMappingRely).RegenerateAll()
	}
	
	//生成全文索引(属性不生成)
	//w ##class(web.DHCBL.MKB.BDPMKBIndex).SaveTermIdx("")
	
	//工厂注册
	if ($d(^MTEMPMKBStructuredBaseD)>0)
	{
		k ^User.MKBStructuredBaseD
		k ^User.MKBStructuredBaseI
		s ^User.MKBStructuredBaseD=^MTEMPMKBStructuredBaseD
		s MKBSTBRowId=0
		for
		{  
			s MKBSTBRowId=$o(^MTEMPMKBStructuredBaseD(MKBSTBRowId)) q:MKBSTBRowId=""
			s ^User.MKBStructuredBaseD(MKBSTBRowId)=^MTEMPMKBStructuredBaseD(MKBSTBRowId)
		}
		k ^MTEMPMKBStructuredBaseD
		d ##class(User.MKBStructuredBase).%BuildIndices()	
	}	
	
    // 遍历数据处理工厂
    if ($d(^MTEMPMKBStructuredDataD)>0)&($d(^MTEMPMKBStructuredDataC)>0)
    {
	    k ^User.MKBStructuredDataD
		k ^User.MKBStructuredDataI
		k ^User.MKBStructuredDataC
		k ^User.MKBStructuredDataResultI
		k ^User.MKBStructuredDataLocI
		k ^User.MKBStructuredDataOtherI
		k ^User.MKBStructuredDataProLocI
		s ^User.MKBStructuredDataD=^MTEMPMKBStructuredDataD
		s ^User.MKBStructuredDataC("MKBSDStructResult")=^MTEMPMKBStructuredDataC("MKBSDStructResult")
		s ^User.MKBStructuredDataC("MKBSDStructLoc")=^MTEMPMKBStructuredDataC("MKBSDStructLoc")
		s ^User.MKBStructuredDataC("MKBSDStructOther")=^MTEMPMKBStructuredDataC("MKBSDStructOther")
		s ^User.MKBStructuredDataC("MKBSDStructProLoc")=^MTEMPMKBStructuredDataC("MKBSDStructProLoc")
		s MKBSDRowId=0
		for
		{  
			s MKBSDRowId=$o(^MTEMPMKBStructuredDataD(MKBSDRowId)) q:MKBSDRowId=""
			s ^User.MKBStructuredDataD(MKBSDRowId)=^MTEMPMKBStructuredDataD(MKBSDRowId)
			//结构化结果子表
			s ChildSub=0
			for
			{
				s ChildSub = $O(^MTEMPMKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",ChildSub))
				q:ChildSub=""
				s ^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",ChildSub)= ^MTEMPMKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",ChildSub)
			}
			//科室频次子表
			s ChildSub=0
			for
			{
				s ChildSub = $O(^MTEMPMKBStructuredDataD(MKBSDRowId,"MKBSDStructLoc",ChildSub))
				q:ChildSub=""
				s ^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructLoc",ChildSub)= ^MTEMPMKBStructuredDataD(MKBSDRowId,"MKBSDStructLoc",ChildSub)
			}
			//别名/其他描述子表
			s ChildSub=0
			for
			{
				s ChildSub = $O(^MTEMPMKBStructuredDataD(MKBSDRowId,"MKBSDStructOther",ChildSub))
				q:ChildSub=""
				s ^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructOther",ChildSub)= ^MTEMPMKBStructuredDataD(MKBSDRowId,"MKBSDStructOther",ChildSub)
			}
			//专业科室
			s ChildSub=0
			for
			{
				s ChildSub = $O(^MTEMPMKBStructuredDataD(MKBSDRowId,"MKBSDStructProLoc",ChildSub))
				q:ChildSub=""
				s ^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructProLoc",ChildSub)= ^MTEMPMKBStructuredDataD(MKBSDRowId,"MKBSDStructProLoc",ChildSub)
			}
		}
		k ^MTEMPMKBStructuredDataD
		k ^MTEMPMKBStructuredDataC
		d ##class(User.MKBStructuredData).%BuildIndices()
		d ##class(User.MKBStructuredDataResult).%BuildIndices()
		d ##class(User.MKBStructuredDataLoc).%BuildIndices()
		d ##class(User.MKBStructuredDataOther).%BuildIndices()
		d ##class(User.MKBStructuredDataProLoc).%BuildIndices()
    }
	

	
	//各版本ICD对照
	if ($d(^MTEMPMKBICDContrastD)>0)&($d(^MTEMPMKBICDContrastC)>0)
	{
		k ^User.MKBICDContrastD
		k ^User.MKBICDContrastI
		k ^User.MKBICDContrastC
		k ^User.MKBICDContrastResultI

		s ^User.MKBICDContrastD=^MTEMPMKBICDContrastD
		s ^User.MKBICDContrastC("MKBICDContrastResult")=^MTEMPMKBICDContrastC("MKBICDContrastResult")

		s MKBICD=0
		for
		{  
			s MKBICD=$o(^MTEMPMKBICDContrastD(MKBICD)) q:MKBICD=""
			s ^User.MKBICDContrastD(MKBICD)=^MTEMPMKBICDContrastD(MKBICD)
			//结构化结果子表
			s ChildSub=0
			for
			{
				s ChildSub = $O(^MTEMPMKBICDContrastD(MKBICD,"MKBICDContrastResult",ChildSub))
				q:ChildSub=""
				s ^User.MKBICDContrastD(MKBICD,"MKBICDContrastResult",ChildSub)= ^MTEMPMKBICDContrastD(MKBICD,"MKBICDContrastResult",ChildSub)
			}
		}
		k ^MTEMPMKBICDContrastD
		k ^MTEMPMKBICDContrastC
		d ##class(User.MKBICDContrast).%BuildIndices()
		d ##class(User.MKBICDContrastResult).%BuildIndices()
	}
	
	//生成结构化诊断所需要的索引 入参IndexFlag ""：中心词生成全文索引，1:中心词+属性内容生成全文索引，2:不生成全文索引
	//d ##class(web.DHCBL.MKB.MKBDataImport).DoAfterImport("")
	    	
    q "over"
}

/// Creator:谷雪萍
/// CreatDate:2021-07-13
/// Description:获取临床学实用诊断的诊断模板中用到的知识库
/// Input:base：知识库注册id 
/// Return:临床学实用诊断的诊断模板中用到的知识库名
/// Other:w ##class(web.DHCBL.MKB.MKBChangeGlobalInfo).GetDiaModeUseTermBase(5)
ClassMethod GetDiaModeUseTermBase(base As %String = "")
{
	s result=""
	k myArray
	s MKBTRowId=0
	for  
	{	
		s MKBTRowId=$o(^User.MKBTermI("BaseIndex",base,MKBTRowId)) q:MKBTRowId="" 
		s MKBTDesc=$listGet($g(^User.MKBTermD(MKBTRowId)),3)  //术语中心词
		s proId=$o(^User.MKBTermPropertyI("FlagIndex",MKBTRowId," DT",0)) //诊断模板的属性ID 直接根据标识来获取 
		continue:proId=""

		s proDetailId=$o(^User.MKBTermProDetailI("ProIdx",proId,0)) //属性内容的id
		continue:proDetailId=""

		s proDetailDesc=$LISTGET($G(^User.MKBTermProDetailD(proDetailId)),3)   //属性内容
		continue:proDetailDesc=""

		s argsLen=$Length(proDetailDesc,",")
	    for i=1:1:argsLen   
	    {     
	        s argstr=$p(proDetailDesc,",",i)  //术语/属性id&展示类型&起始节点&单选/多选&是否必填&术语/属性标识
	        s catRowId=$p(argstr,"&",1)  //术语属性id 或者术语id 
	        continue:catRowId=""
	        s showType=$p(argstr,"&",2) //展示类型
	        s treeNode=$p(argstr,"&",3) //定义起始节点
	        s:treeNode="undefined" treeNode=""
	        s choiceType=$p(argstr,"&",4)  //单选多选
	        s:choiceType="" choiceType="S"  //默认单选
	        s ifRequired=$p(argstr,"&",5)  //是否必填（Y/N）
          	s:ifRequired="" ifRequired="N"  //默认不必填
          	s isTOrP=$p(argstr,"&",6)  //术语T或属性P
          	s:isTOrP="" isTOrP="P"  //默认属性P
	      	s catDesc="",catType="",TreeNodeDesc="",catFlag=""
	      	if (isTOrP="T") //术语
	      	{
		      	s catDesc=$LISTGET($G(^User.MKBTermBaseD(catRowId)),3) //术语库描述 
			    s myArray(catRowId)=catDesc
	      	}
	      	else    //属性
	      	{
		      	s Config=$LISTGET($G(^User.MKBTermPropertyD(catRowId)),5)  //配置项
		      	continue:Config=""
		      	s catDesc=$LISTGET($G(^User.MKBTermBaseD(Config)),3) //术语库描述 
		      	s myArray(Config)=catDesc
	      	}

	    }
		
	}
	s mySeq=0
	for {
		s mySeq=$o(myArray(mySeq)) q:(mySeq="")
		s baseDesc=$g(myArray(mySeq))
		s:result'="" result=result_"^"
		s result=result_baseDesc
		
	}
	q result
}

}
