/// Creator:丁亚男
/// CreatDate:2023-03-23
/// Description:获取患者符合条件的高质量相似病历结果
Class web.CDSS.MedicalRule.GetPatientHQEMR Extends %RegisteredObject
{

/// Creator:丁亚男
/// CreatDate:2023-03-23
/// Description:根据患者当前临床信息，获取相似高质量病历保存到患者推荐信息表
/// Table: CT.WDT.CDSS.HighQualityEMR:优质病历字典表 CT_WDT_CDSS.HighQEMRConDia:优质病历关联诊断表  CT_WDT_CDSS.HighQEMRConSym:优质病历关联诊断因子表
/// Input: PatientInfo : 患者信息（医生站所传json串）
/// Return: 
/// Others:w ##class(web.CDSS.MedicalRule.GetPatientHQEMR).SaveSatisfyHQEMR("DM000812^DM000812^1^住院^48^李得原^1^信息科^1")
ClassMethod SaveSatisfyHQEMR(PatientInfo As %String) As %String
{
	s IDNO=$p(PatientInfo,"^",1)
	s PatientDR=$p(PatientInfo,"^",2)
	s VisitID=$p(PatientInfo,"^",3)
	s VisitType=$p(PatientInfo,"^",4)
	s Config=$p(PatientInfo,"^",9)
	s Type=$p(PatientInfo,"^",10)
	if (Config="") s Config=1	//是否启用流水号（急诊号、门诊号、住院号）为患者就诊唯一标识（0为是，1为否），默认为1
	
	//获取患者主诊断
	s MainDiag="",MainDiagClass=""
	if (Config=1)&(PatientDR'="")&(VisitID'="") // 单个患者单次就诊 根据病人标识和就诊次数编号取数据
	{
		if ($d(^WDT.CDSS.DiagnosisInfoI("PatVisDRTySequenceIndex",PatientDR,VisitID,VisitType)))
		{
			s FirstFlag=0
			s Sequence=""
			for
			{
				s Sequence =$o(^WDT.CDSS.DiagnosisInfoI("PatVisDRTySequenceIndex",PatientDR,VisitID,VisitType,Sequence)) q:Sequence=""
				s DiagnosisID=0
				for
				{
					s DiagnosisID =$o(^WDT.CDSS.DiagnosisInfoI("PatVisDRTySequenceIndex",PatientDR,VisitID,VisitType,Sequence,DiagnosisID)) q:DiagnosisID=""
					s FirstFlag=FirstFlag+1
					s DiagnosisName=$lg($g(^WDT.CDSS.DiagnosisInfoD(DiagnosisID)),9)
					s DiagnosisClass=$lg($g(^WDT.CDSS.DiagnosisInfoD(DiagnosisID)),18)
					s:DiagnosisClass="" DiagnosisClass="西医"
					s ChildDiagnosisFlag=$lg($g(^WDT.CDSS.DiagnosisInfoD(DiagnosisID)),13)  //主诊断标记（1是0否）
					if (FirstFlag=1)
					{
						s MainDiag=DiagnosisName
						s MainDiagClass=DiagnosisClass
					}
					
					if (ChildDiagnosisFlag=1)
					{
						s MainDiag=DiagnosisName
						s MainDiagClass=DiagnosisClass
					}
				}
			}
			
			
		}
	}
	elseif(IDNO'="")  //患者主索引
	{
		s FirstFlag=0
		s Sequence=""
		for
		{
			s Sequence =$o(^WDT.CDSS.DiagnosisInfoI("IDNOSequenceIndex",IDNO,Sequence)) q:Sequence=""
			s DiagnosisID=0
			for
			{
				s DiagnosisID =$o(^WDT.CDSS.DiagnosisInfoI("IDNODiaTySeqIndex",IDNO,Sequence,DiagnosisID)) q:DiagnosisID=""
				s FirstFlag=FirstFlag+1
				s DiagnosisName=$lg($g(^WDT.CDSS.DiagnosisInfoD(DiagnosisID)),9)
				s DiagnosisClass=$lg($g(^WDT.CDSS.DiagnosisInfoD(DiagnosisID)),18)
				s:DiagnosisClass="" DiagnosisClass="西医"
				s ChildDiagnosisFlag=$lg($g(^WDT.CDSS.DiagnosisInfoD(DiagnosisID)),13)  //主诊断标记（1是0否）
				
				if (FirstFlag=1)
				{
					s MainDiag=DiagnosisName
					s MainDiagClass=DiagnosisClass
				}
				if (ChildDiagnosisFlag=1)
				{
					s MainDiag=DiagnosisName
					s MainDiagClass=DiagnosisClass
				}
				
			}
		}
	}
	k ^TempPInfoEMRData
	k ^TempPInfoEMROrderData
			
	//根据主诊断获取符合条件的病历
	if (MainDiag'="")
	{
		if ($d(^CT.WDT.CDSS.HighQEMRConDiaI("DiagEMRDRIndex",MainDiagClass,MainDiag)))
		{
			s EMRId=0
			for 
			{
				s EMRId=$O(^CT.WDT.CDSS.HighQEMRConDiaI("DiagEMRDRIndex",MainDiagClass,MainDiag,EMRId)) q:EMRId=""
				s ^TempPInfoEMRData($j,PatientInfo,EMRId)=0.5   //通过主诊断推荐的系数暂定0.5
			}
		}
		
	}
	
	//根据主诉、现病史等症状获取符合条件的病历
	s PInfoItemChief=##class(web.CDSS.IdentifyWords.GetPatientInfo).DealDataByPatientEnumI(PatientInfo,"症状") //取患者模型的数据
	if (PInfoItemChief'="")&(PInfoItemChief'="[]")
	{
		s PInfoItemChief=[].%FromJSON(PInfoItemChief)
		for i=0:1:(PInfoItemChief.%Size()-1)  //遍历条件判断是否满足
		{
			s DataValue=$tr((PInfoItemChief.%Get(i)).%Get("Symptom"),"""","'")
			if ($d(^CT.WDT.CDSS.HighQEMRConSymI("SymptomEMRIndex",DataValue)))
			s EMRId=0
			for 
			{
				s EMRId=$O(^CT.WDT.CDSS.HighQEMRConSymI("SymptomEMRIndex",DataValue,EMRId)) q:EMRId=""
				s ^TempPInfoEMRData($j,PatientInfo,EMRId)=$g(^TempPInfoEMRData($j,PatientInfo,EMRId))+0.03   //通过主诉推荐的系数暂定0.03
			}
		}
	}
	
	//获取主诉数据，为标红做准备
	s ChiefStr=""
	s PInfoItemChief=##class(web.CDSS.Public.PatientModel).GetPatienCompInfo(IDNO,PatientDR,VisitID,VisitType,Config) //取患者模型的数据
	s PInfoItemChief="["_PInfoItemChief_"]"
	if (PInfoItemChief'="")&(PInfoItemChief'="[]")
	{
		s PInfoItemChief=[].%FromJSON(PInfoItemChief)
		for i=0:1:(PInfoItemChief.%Size()-1)  //遍历条件判断是否满足
		{
			s DataValue=$tr((PInfoItemChief.%Get(i)).%Get("Symptom"),"""","'")
			if (DataValue'="")
			{
				s:ChiefStr'="" ChiefStr=ChiefStr_"&%"_DataValue
				s:ChiefStr="" ChiefStr=DataValue
			}
		}
	}
	
	//根据科室获取符合条件的病历
	s PInfoItemDept=##class(web.CDSS.IdentifyWords.GetPatientInfo).DealDataByPatientEnumI(PatientInfo,"就诊科室") //取患者模型的数据
	if (PInfoItemDept'="")&(PInfoItemDept'="[]")
	{
		s PInfoItemDept=[].%FromJSON(PInfoItemDept)
		s DataValue=$tr((PInfoItemDept.%Get(0)).%Get("VisitingDepartment"),"""","'")
		if ($d(^CT.WDT.CDSS.HighQualityEMRI("LocIndex",DataValue)))
		s EMRId=0
		for 
		{
			s EMRId=$O(^CT.WDT.CDSS.HighQualityEMRI("LocIndex",DataValue,EMRId)) q:EMRId=""
			s ^TempPInfoEMRData($j,PatientInfo,EMRId)=$g(^TempPInfoEMRData($j,PatientInfo,EMRId))+0.02   //通过科室推荐的系数暂定0.02
		}	
	}
	//获取患者的性别 
	s PInfoItemSex=##class(web.CDSS.IdentifyWords.GetPatientInfo).DealDataByPatientEnumI(PatientInfo,"性别") //取患者模型的数据
	s PInfoItemSex=[].%FromJSON(PInfoItemSex)
	if (PInfoItemSex'="")&(PInfoItemSex'="[]")
	{
		s Sex=(PInfoItemSex.%Get(0)).%Get("Sex")
	}
	
	//获取患者的年龄
	s PInfoItemAge=##class(web.CDSS.IdentifyWords.GetPatientInfo).DealDataByPatientEnumI(PatientInfo,"年龄") //取患者模型的数据
	s PInfoItemAge=[].%FromJSON(PInfoItemAge)
	if (PInfoItemAge'="")&(PInfoItemAge'="[]")
	{
		s Age=(PInfoItemAge.%Get(0)).%Get("Age")
	}
	//增加性别、年龄的考量 并且给数据排序
	s EMRId=0
	for 
	{
		s EMRId=$O(^TempPInfoEMRData($j,PatientInfo,EMRId)) q:EMRId=""
		s EMRSex=$lg($g(^CT.WDT.CDSS.HighQualityEMRD(EMRId)),7)
		s EMRAge=$lg($g(^CT.WDT.CDSS.HighQualityEMRD(EMRId)),8)
		if (EMRSex'="")&(EMRSex=Sex)
		{
			s ^TempPInfoEMRData($j,PatientInfo,EMRId)=$g(^TempPInfoEMRData($j,PatientInfo,EMRId))+0.01
		}
		if (EMRAge'="")&&(Age'="")&&($ZABS(EMRAge-Age)<6)
		{
			s ^TempPInfoEMRData($j,PatientInfo,EMRId)=$g(^TempPInfoEMRData($j,PatientInfo,EMRId))+0.01
		}
		s Percentage=$g(^TempPInfoEMRData($j,PatientInfo,EMRId))
		s ^TempPInfoEMROrderData($j,PatientInfo,Percentage,EMRId)=Percentage
		
	}
	s Percentage="",HighQualityEMR="",count=0
	s EMRArray=[]
	for 
	{
		s Percentage=$O(^TempPInfoEMROrderData($j,PatientInfo,Percentage)) q:Percentage=""
		s EMRId=0
		for 
		{
			s EMRId=$O(^TempPInfoEMROrderData($j,PatientInfo,Percentage,EMRId)) q:EMRId=""
			s count=count+1
			q:count=6
			s EMRContent=$lg($g(^CT.WDT.CDSS.HighQualityEMRD(EMRId)),3)
			//优质病历关联主诊断
			s MDiagName=""
    		if $d(^CT.WDT.CDSS.HighQEMRConDiaI("EMRDRIndex",EMRId))
			{
				s ConDiaId=""
				for 
				{
					s ConDiaId=$O(^CT.WDT.CDSS.HighQEMRConDiaI("EMRDRIndex",EMRId,ConDiaId)) q:ConDiaId="" 
					s DiagnosisName= $lg($g(^CT.WDT.CDSS.HighQEMRConDiaD(ConDiaId)),4)
					s IsMainDiagnosis= $lg($g(^CT.WDT.CDSS.HighQEMRConDiaD(ConDiaId)),6)
					s:IsMainDiagnosis=1 MDiagName=DiagnosisName 
				}
			}
				
			s VisitType= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(EMRId)),4)
		    s Loc= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(EMRId)),5) 	
		    s Name= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(EMRId)),6)     
		    s Sex= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(EMRId)),7)        
		    s Age= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(EMRId)),8)
			
			s BaseInfo=Sex_"|"_Age_"|"_Loc_"|"_VisitType
			
			   	
			s lenContent=$length(EMRContent)
			if (lenContent>100)
			{
				s EMRContent=$E(EMRContent,1,100)_"..."
			}
			s TmpAss={}
			d TmpAss.%Set("ItemName",EMRContent)
			d TmpAss.%Set("ItemID",EMRId)
			d TmpAss.%Set("MDiagName",MDiagName)
			d TmpAss.%Set("BaseInfo",BaseInfo)
			d TmpAss.%Set("ChiefStr",ChiefStr)
			d EMRArray.%Push(TmpAss)
		}
		q:count=6
		
	}
	//保存推荐优质病历到患者推荐信息表
	s EMRResultArray=[]
	s TmpAss={}
	d TmpAss.%Set("InterfaceName","优质病历")
	d TmpAss.%Set("InterfaceValue",EMRArray)
	s EMRInfo=EMRResultArray.%Push(TmpAss).%ToJSON()
	
	d ##class(web.CDSS.PatientView.PatientRecomInfo).SaveRecomInfo(PatientInfo,"优质病历",EMRInfo)
	
	k ^TempPInfoEMRData
	k ^TempPInfoEMROrderData
	
	q EMRArray
}

}
