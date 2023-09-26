/// 名称:过敏接口
/// 描述:
/// 编写者:基础平台组 - 徐文虎
/// 编写日期:2021-01-22
Class web.CDSS.MachineLearning.AllergyInterface Extends %RegisteredObject
{

/// Creator:徐文虎
/// CreatDate:2020-01-19
/// Description:同步过敏信息
/// Table:User.DHCDSSAllergyHistory
/// Input: AllergyInfo : {"IDNO":"患者主索引","PatientDR":"病人标识","children":[{"AllergySourceName":"过敏源名称","AllergySourceType":"过敏源类型","StartTime":"开始时间","EndTime":"结束时间","RiskLevel":"危重程度","TreatmentEffect":"缓解因素","RegisterData":"登记时间","RegisterUser":"登记人","Remarks":"备注","PassFlag":"同步标记"}]}
/// Return:标准版诊断信息
/// Others:w ##class(web.CDSS.MachineLearning.AllergyInterface).SynchronousAllergyInfo(AllergyInfo)
ClassMethod SynchronousAllergyInfo(allergyjson As %String) As %String
{
    s info=[].%FromJSON(allergyjson)
    s AllergyJson={}
    d AllergyJson.%Set("IDNO",info.%Get("IDNO"))
    d AllergyJson.%Set("PatientDR",info.%Get("PatientDR"))
    d AllergyJson.%Set("VisitID",$select(info.%Get("VisitID")="":1,info.%Get("VisitID")'="":info.%Get("VisitID")))
    d AllergyJson.%Set("VisitType",$select(info.%Get("VisitType")="":"住院",info.%Get("VisitType")'="":info.%Get("VisitID")))
    s children=[]  //所有信息表
    s ChildrenList=info.%Get("children")  //过敏信息列表
    s num=$o(^WDT.CDSS.AllergyHistoryI("AllergyHistoryNum",info.%Get("PatientDR"),""),-1)	//最后一个过敏信息记录
    if ChildrenList.%Size()=0
    {
	    s AllergyHistoryID=0			//全量推过来为空，删除最后一条数据
	    for
	    {
	        s AllergyHistoryID = $o(^WDT.CDSS.AllergyHistoryI("PatDRIndex",info.%Get("PatientDR"),AllergyHistoryID))
	        q:AllergyHistoryID=""
	        s RiskLevel=$lg($g(^WDT.CDSS.AllergyHistoryD(AllergyHistoryID)),9) //危险等级
	        continue:RiskLevel'="" //等于空是过敏记录存的，可删；不等于空是病历存的，不可删
	        d ##class(WDT.CDSS.AllergyHistory).%DeleteId(AllergyHistoryID)
	        //保存识别词标识表
			s PMobj=##class(WDT.CDSS.PatPMTypeIndex).%New()
			s PMobj.IDNO=info.%Get("IDNO")
			s PMobj.PatientDR=info.%Get("PatientDR")
			s PMobj.VisitID=1
			s PMobj.VisitType="住院"
			s PMobj.DataType="过敏史"
			s PMobj.IsLastUpdate=1
			d PMobj.%Save()
			d PMobj.%Close()
	    }
	    q "DeleteAllergyInfo"
    }
    for i=0:1:(ChildrenList.%Size()-1)
    {
    	s AllergyInfo={}  //过敏信息
        d AllergyInfo.%Set("DataClass","AllergyHistory")
        s AllergyInfoC=[]  //基础信息详细内容
        s AllergyInfoDict={}  //单个过敏信息详细内容
        s num=num+1
        d AllergyInfoDict.%Set("AllergyHistoryNum",num)
        s AllergySourceName=ChildrenList.%Get(i).%Get("AllergySourceName")
        continue:AllergySourceName=""
        s AllergyID=$o(^CT.WDT.CDSS.AllergyDictI("DescIndex"," "_$ZCONVERT(AllergySourceName,"U"),0)) //过敏史字典判断
		if (AllergyID="")
		{
			s:AllergyID="" AllergyID=$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.AllergyDict",AllergySourceName,0))  //别名通用名判断
			s:AllergyID'="" AllergySourceName=$lg($g(^CT.WDT.CDSS.AllergyDictD(AllergyID)),3)
		}
        //d AllergyInfoDict.%Set("AllergySourceName",ChildrenList.%Get(i).%Get("AllergySourceName"))  //过敏源名称
        d AllergyInfoDict.%Set("AllergySourceName",AllergySourceName)  //过敏源名称
        d AllergyInfoDict.%Set("AllergySourceType",ChildrenList.%Get(i).%Get("AllergySourceType"))  //过敏源类型
        s StartTime=ChildrenList.%Get(i).%Get("StartTime")
        s:StartTime'="" StartTime=$ZDH(StartTime,3)								
        d AllergyInfoDict.%Set("StartTime",StartTime)								//开始时间
        s EndTime=ChildrenList.%Get(i).%Get("EndTime")
        s:EndTime'="" EndTime=$ZDH(EndTime,3)
        d AllergyInfoDict.%Set("EndTime",EndTime)  									//结束时间
        d AllergyInfoDict.%Set("RiskLevel",ChildrenList.%Get(i).%Get("RiskLevel"))  //危重程度
        d AllergyInfoDict.%Set("TreatmentEffect",ChildrenList.%Get(i).%Get("TreatmentEffect"))  //缓解因素
        //d AllergyInfoDict.%Set("RegisterData",ChildrensList.%Get(i).%Get("RegisterData"))  //登记时间
        //d AllergyInfoDict.%Set("RegisterUser",ChildrensList.%Get(i).%Get("RegisterUser"))  //登记人
        d AllergyInfoDict.%Set("Remarks",ChildrenList.%Get(i).%Get("Remarks"))			//备注
        d AllergyInfoDict.%Set("PassFlag",ChildrenList.%Get(i).%Get("PassFlag"))		//同步标记(0同步，1新增)
        
       	d AllergyInfoC.%Push(AllergyInfoDict)
        d AllergyInfo.%Set("children",AllergyInfoC)
        d children.%Push(AllergyInfo)
   	}
   	d AllergyJson.%Set("children",children)
   	s config=##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020061601")
    
   	s RationalResult=##Class(web.CDSS.MachineLearning.DataVerification).DataRationalisation(AllergyJson.%ToJSON())  //对第三方数据json串进行数据合理性校验，包括（数据类型是否匹配，主键是否存在等）
   	s RationalResult=[].%FromJSON(RationalResult)
   	s UnifomResult=##Class(web.CDSS.MachineLearning.DataVerification).DataConsistency(AllergyJson.%ToJSON())  //对第三方数据json串进行基本信息、就诊信息数据一致性和临床信息完整性校验
   	s UnifomResult=[].%FromJSON(UnifomResult)
   	if (RationalResult.%Size()=0)&(UnifomResult.%Size()=0)  //如果没有错误信息
   	{
        return AllergyJson.%ToJSON()       
   	}
   	elseif(config="Y")  //有错误信息，但是允许强制交互
   	{
        return AllergyJson.%ToJSON()
   	}
   	else  //有错误信息，不允许强制交互
   	{
        for i=0:1:UnifomResult.%Size()-1
        {
            d RationalResult.%Push(UnifomResult.%Get(i))
        } 
        return RationalResult.%ToJSON()  
   	}
	q ""
}

}
