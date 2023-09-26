/// Creator:Xuwenhu
/// CreatDate:2021-09-27
/// Description:CDSSV2.0患者推荐信息类
Class web.CDSS.PatientView.PatientRecomInfo Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator：Xuwenhu 		
/// CreatDate: 2021-09-27
/// Description：保存数据 
/// Table:WDT.CDSS.PatientRecomInfo
/// Input:PatientInfo-患者信息串,InterfaceName-接口名称,ReturnValue-返回值
/// Output:success or false_原因
/// Other: w ##class(web.CDSS.PatientView.PatientRecomInfo).SaveRecomInfo("XwhTest^XwhTest^1^住院^13951^徐文虎^111^呼吸科^1","INITIALIZE_PATIENT_INFORMATION","string")
ClassMethod SaveRecomInfo(PatientInfo As %String, InterfaceName As %String, ReturnValue As %String) As %String
{
	s IDNO=$p(PatientInfo,"^",1)			//主索引
	s PatientDR=$p(PatientInfo,"^",2)		//病人表示
	s VisitID=$p(PatientInfo,"^",3)			//就诊次
	s VisitType=$p(PatientInfo,"^",4)		//就诊类型
	q:InterfaceName="" "接口名称为空"
	s result=""
	if $d(^WDT.CDSS.PatientRecomInfoI("UniqueIDNOIndex",IDNO,InterfaceName))		//接口是否已存在
	{
		//接口已存在
		s RecomID=$o(^WDT.CDSS.PatientRecomInfoI("UniqueIDNOIndex",IDNO,InterfaceName,0))
		s OldReturnVal=$lg($g(^WDT.CDSS.PatientRecomInfoD(RecomID)),7)			//旧返回值
		if OldReturnVal'=ReturnValue
		{
			s obj=##class(WDT.CDSS.PatientRecomInfo).%OpenId(RecomID)
			s result=$$SaveOBJ(InterfaceName,ReturnValue,1)
		}else
		{
			s obj=##class(WDT.CDSS.PatientRecomInfo).%OpenId(RecomID)
			s result=$$SaveOBJ(InterfaceName,ReturnValue,0)
		}
	}else
	{
		//接口不存在
		s obj=##class(WDT.CDSS.PatientRecomInfo).%New()
		s result=$$SaveOBJ(InterfaceName,ReturnValue,1)	
	}
	q result
SaveOBJ(Name,Value,Flag)
	s obj.IDNO=IDNO
	s obj.PatientDR=PatientDR
	s obj.VisitID=VisitID
	s obj.VisitType=VisitType
	s obj.InterfaceName=Name		
	s obj.InterfaceReturn=Value
	s obj.UpdateFlag=Flag
	s sc=obj.%Save()
	d obj.%Close()
	if $$$ISOK(sc)
	{
		s result="success"	
	}else
	{
		s result="false"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)	
	}
	q result
}

/// Creator：Xuwenhu 		
/// CreatDate: 2021-09-27
/// Description：取数据 
/// Table:WDT.CDSS.PatientRecomInfo
/// Input:PatientInfo-患者信息串,DataSize-数据量(1-全量推，0-只推更新)
/// Output:success or false_原因
/// Other: w ##class(web.CDSS.PatientView.PatientRecomInfo).GetAllRecomInfo("DM000021^DM000021^1^住院^^^^心内科一^1","评估表评估记录")
ClassMethod GetAllRecomInfo(PatientInfo As %String, DataSize As %String) As %String
{
	s IDNO=$p(PatientInfo,"^",1)			//主索引
	s:IDNO="DM000020" IDNO="DYNCS识别词"
	//s AllRecomInfo=[]
	s ID=0
	s ID=$o(^WDT.CDSS.PatientRecomInfoI("UniqueIDNOIndex",IDNO,DataSize,ID))
	q:ID="" "[]"
	s ReturnValue=$lg($g(^WDT.CDSS.PatientRecomInfoD(ID)),7)
	q ReturnValue
	/*for
	{
		s ID=$o(^WDT.CDSS.PatientRecomInfoI("IDNOIndex",IDNO,ID))
		q:ID=""
		s InterfaceInfo={}
		s InterfaceName=$lg($g(^WDT.CDSS.PatientRecomInfoD(ID)),6)		//接口名称
		s ReturnValue=$lg($g(^WDT.CDSS.PatientRecomInfoD(ID)),7)			//返回值
		s UpdateFlag=$lg($g(^WDT.CDSS.PatientRecomInfoD(ID)),8)			//更新标志
		
		continue:((DataSize="0")&&(UpdateFlag="0"))
		//d InterfaceInfo.%Set("InterfaceName",InterfaceName)
		//d InterfaceInfo.%Set("ReturnValue",ReturnValue)
		d AllRecomInfo.%Push(InterfaceInfo)
	}*/
	//d AllRecomInfo.%Set(" ",AllRecomInfoC)
	//q AllRecomInfo.%ToJSON()
}

/// Creator：Xuwenhu 		
/// CreatDate: 2021-09-27
/// Description：取数据 
/// Table:WDT.CDSS.PatientRecomInfo
/// Input:PatientInfo-患者信息串,DataSize-数据量(1-全量推，0-只推更新)
/// Output:success or false_原因
/// Other: w ##class(web.CDSS.PatientView.PatientRecomInfo).GetRecomInfo("523^0000000015^2^住院^19085^医生02^ZYZY003^内分泌科^0^Ⅰ度晒斑[晒伤]","ALLINFO")
ClassMethod GetRecomInfo(PatientInfo As %String, DataSize As %String) As %String
{
	q:PatientInfo="" "[]"
	try{
		//d ##class(web.CDSS.IdentifyWords.GetPatientIW).GetSatisfyIW(PatientInfo)
		d ##class(web.CDSS.MedicalRule.GetPatientRuleResult).SaveSatisfyRuleResult(PatientInfo)
	}catch e
	{
	}
	s returninfo={}
	s BaseTable={}
	s NoBaseTable={}
	d BaseTable.%Set("RatingScale",[])
	d BaseTable.%Set("AuxCale",[])
	d NoBaseTable.%Set("RatingScale",[])
	d NoBaseTable.%Set("AuxCale",[])
	s IDNO=$p(PatientInfo,"^",1)			//主索引
	;s:IDNO="DM000020" IDNO="DYNCS识别词"
	//s AllRecomInfo=[]
	s ID=0
	s ID=$o(^WDT.CDSS.PatientRecomInfoI("UniqueIDNOIndex",IDNO,DataSize,ID))
	//q:ID="" "[]"
	if (ID="")
	{
		d BaseTable.%Set("出院指导",[])
		d BaseTable.%Set("手术并发症",[])
		d BaseTable.%Set("手术预警",[])
		d BaseTable.%Set("护理预警",[])
		d BaseTable.%Set("推荐护理措施",[])
		d BaseTable.%Set("推荐检验检查",[])
		d BaseTable.%Set("推荐治疗方案",[])
		d BaseTable.%Set("推荐相关文献",[])
		d BaseTable.%Set("推荐确诊",[])
		d BaseTable.%Set("推荐评估量表",[])
		d BaseTable.%Set("检验检查预警",[])
		d BaseTable.%Set("疾病预警",[])
		d BaseTable.%Set("确诊诊断",[])
		d BaseTable.%Set("药品预警",[])
		d BaseTable.%Set("评估表评估记录",[])
		d BaseTable.%Set("辅助计算",[])
		d BaseTable.%Set("输血预警",[])
		d BaseTable.%Set("过敏史预警",[])
		d BaseTable.%Set("鉴别诊断",[])
		d BaseTable.%Set("高危警示",[])
		d BaseTable.%Set("病历书写合理性",[])
		q BaseTable.%ToJSON()
	}
	s ReturnValue=$lg($g(^WDT.CDSS.PatientRecomInfoD(ID)),7)
	s ReturnValue=[].%FromJSON(ReturnValue)
	for i=0:1:ReturnValue.%Size()-1   //遍历第一层列表
    {
	    s IFName= ""
	    s PatientJson = ReturnValue.%Get(i)
	    s PatientIterator=PatientJson.%GetIterator()
        while PatientIterator.%GetNext(.key,.value)
        {
	        //InterfaceReturn     InterfaceValue                              
	        if (key="InterfaceName")
	        {
		        s IFName = value
		        //s value=$case(value,"确诊诊断":"","drug":"药物","operation":"手术","allergy":"过敏",:"")
		        d returninfo.%Set(value,"")
		    }
		    if (key="InterfaceValue")
		    {
			    if (IFName="评估表评估记录")
			    {
				    //if (PatientInfo["00234")
				    //{
					   s value=##class(web.CDSS.TreatDecision.RatingScale).GetPatientRatingScale(PatientInfo)
				       d returninfo.%Set(IFName,[].%FromJSON(value))
					//}
					//else
					//{
						//d returninfo.%Set(IFName,[])
				    //}
				}
				elseif(IFName="推荐评估量表")
				{
					//s returnvalue={}
					
					for j=0:1:value.%Size()-1
					{
						d value.%Get(j).%Set("resourceShow",0)
						s BaseFlag = value.%Get(j).%Get("BaseTable")
						if ((BaseFlag="0")||(BaseFlag=""))
						{
							d NoBaseTable.%Get("RatingScale").%Push(value.%Get(j))
						}
						else
						{
							d BaseTable.%Get("RatingScale").%Push(value.%Get(j))	
						}
					}
					//d returnvalue.%Set("BaseTable",BaseTable)
					//d returnvalue.%Set("NoBaseTable",NoBaseTable) 
					//d returninfo.%Set(IFName,returnvalue)
				}
				elseif (IFName="辅助计算")
				{
					for j=0:1:value.%Size()-1
					{
						d value.%Get(j).%Set("resourceShow",0)
						s BaseFlag = value.%Get(j).%Get("BaseTable")
						if ((BaseFlag="0")||(BaseFlag=""))
						{
							d NoBaseTable.%Get("AuxCale").%Push(value.%Get(j))
						}
						else
						{
							d BaseTable.%Get("AuxCale").%Push(value.%Get(j))	
						}
					}
				}
				else{
					if (IFName="确诊诊断"){ b}
			    	d returninfo.%Set(IFName,value)
				}
			}
	    }
	}
	s returnvalue={}
	d returnvalue.%Set("BaseTable",BaseTable)
	d returnvalue.%Set("NoBaseTable",NoBaseTable)
	d returninfo.%Set("推荐评估量表",returnvalue)
	//s AddValue=[{"ItemName":"保持情绪稳定，避免情绪激动。"},{"ItemName":"合理饮食，戒烟酒，忌暴饮暴食。"},{"ItemName":"大便时避免用力过度和憋气。"},{"ItemName":"坚持适度锻炼，注重控制体重"},{"ItemName":"伴有肢体功能障碍遵医嘱行康复锻炼"}]
	//d returninfo.%Set("出院指导",AddValue)
	q returninfo.%ToJSON()
}

}
