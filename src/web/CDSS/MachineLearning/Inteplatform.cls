Class web.CDSS.MachineLearning.Inteplatform Extends %RegisteredObject
{

/// Creator:阚延新
/// CreatDate:2021-08-19
/// Description：用于内部检查报告入库
/// Input：{ "GroupFlag":"医嘱号","ExamCode":"检查编码","ExamName":"检查名称","ExamResult":"检查结果","PartDR":"部位,可以直接传位置或者根据部位表传id或者传空","ExecuteTime":"执行时间","ReportTime":"报告时间","Remarks":"备注"}
/// Output: 
/// w ##class(web.CDSS.MachineLearning.Inteplatform).SaveExamJsonInfo(^TMP("KYXExam"))
ClassMethod SaveExamJsonInfo(json As %String) As %String
{
	s:json["DM000821" ^TMP("KYXExam")=json
    s json=[].%FromJSON(json)
    s GroupFlag=json.%Get("GroupFlag")
    s ExamInfoID=0
    s num=0
    for
    {
		s ExamInfoID =$o(^WDT.CDSS.ExamInfoI("GroupFlagIndex"," "_GroupFlag,ExamInfoID)) 
	    q:ExamInfoID=""
	    s num=num+1
	    d:num'=1 ##class(WDT.CDSS.ExamInfo).%DeleteId(ExamInfoID)
	}
    s ExamInfoID =$o(^WDT.CDSS.ExamInfoI("GroupFlagIndex"," "_GroupFlag,""),-1)
    q:ExamInfoID="" ""
    s IDNO = $lg($g(^WDT.CDSS.ExamInfoD(ExamInfoID)),2)
    s PatientDR  = $lg($g(^WDT.CDSS.ExamInfoD(ExamInfoID)),3)
    s VisitID = $lg($g(^WDT.CDSS.ExamInfoD(ExamInfoID)),4)
    s VisitType = $lg($g(^WDT.CDSS.ExamInfoD(ExamInfoID)),5)
    s GroupSequence = $lg($g(^WDT.CDSS.ExamInfoD(ExamInfoID)),7)
    s ExamCode = $lg($g(^WDT.CDSS.ExamInfoD(ExamInfoID)),8)
    s ExamName = $lg($g(^WDT.CDSS.ExamInfoD(ExamInfoID)),9)
    s ExamResult ="" // $lg($g(^WDT.CDSS.ExamInfoD(ExamInfoID)),10)
    s PartDR ="" // $lg($g(^WDT.CDSS.ExamInfoD(ExamInfoID)),11)
    s ExecuteTime = $lg($g(^WDT.CDSS.ExamInfoD(ExamInfoID)),12)
    s ReportTime ="" // $ZDATETIME($H,3)
    s Remarks ="" // $lg($g(^WDT.CDSS.ExamInfoD(ExamInfoID)),14)
    s PassFlag ="" // $lg($g(^WDT.CDSS.ExamInfoD(ExamInfoID)),15)
    s ExamResultNum ="" // $lg($g(^WDT.CDSS.ExamInfoD(ExamInfoID)),16)
    s ExamResultFlag ="" // $lg($g(^WDT.CDSS.ExamInfoD(ExamInfoID)),17)
    s ExamResultDesc ="" //$lg($g(^WDT.CDSS.ExamInfoD(ExamInfoID)),18)
    //获得推送内容
    s ExamResult = json.%Get("ExamResult")
    s ExamResultDesc = json.%Get("ExamResultDesc") 
    s ExamResultDescs = ExamResult_ExamResultDesc
    s ExamResultDescNLP=..GetStructedDataAPI(ExamResultDescs)
    s ExamResultDescNLP=$REPLACE(ExamResultDescNLP,"""","'")
    s ExamResultDescFormal=..CollectResultToNLP(ExamResultDescNLP)
    s ExamResultFlag = json.%Get("ExamResultFlag") //json里面有没有内容 
    s ExamResultNum = json.%Get("ExamResultNum") 
    s:ExecuteTime="" ExecuteTime = json.%Get("ExecuteTime") 
    s:ReportTime="" ReportTime = json.%Get("ReportTime")
    s Remarks = json.%Get("Remarks")
    s PartDR =json.%Get("PartDR")
    
    //s:PartDR'="" PartDR=$o(^User.DHCDSSBodyParDictI("NameIndex"," "_PartDR,0))
    //s:PartDR'="" PartDR=$o(^CT.WDT.CDSS.BodyPartsDictI("DescIndex"," "_PartDR,0))
    
    d ##class(WDT.CDSS.ExamInfo).%DeleteId(ExamInfoID)
    s size=$l(ExamResultDescFormal,";")
    for i=1:1:size
    {
	    s ExamResults=$p(ExamResultDescFormal,";",i)
	    s ExamResultD=$p(ExamResults,"%%",1)
	    //检查结果进行检查检验结果字典的筛选
	    if ExamResultD["&%"
	    {
		    s ResultID=""
		    for sum=1:1:$l(ExamResultD,"&%")
		    {
			    s ExamResultNow=$p(ExamResultD,"&%",sum)
			    s ResultID=$o(^CT.WDT.CDSS.ExamResultDictI("DescIndex"," "_$ZCONVERT(ExamResultNow,"U"),0)) //检查检验结果字典筛选
			    if ResultID=""
			    {
			    	s ResultID=$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.ExamResultDict",ExamResultNow,0)) //别名通用名
			    	s:ResultID'="" ExamResultD=$lg($g(^CT.WDT.CDSS.ExamResultDictD(ResultID)),3) //检查检验结果字典转换
			    }
			    else
			    {
				    s:ResultID'="" ExamResultD=ExamResultNow
				}
			    q:ResultID'=""
			}
			if ResultID=""
			{
				s ExamResultD=""
			}
		}
		else
		{
			if ExamResultD'=""
			{
				s ResultID=$o(^CT.WDT.CDSS.ExamResultDictI("DescIndex"," "_$ZCONVERT(ExamResultD,"U"),0))  //检查检验结果字典筛选
		    	if ResultID=""
		    	{
				    s ResultID=$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.ExamResultDict",ExamResultD,0)) //别名通用名
				    if ResultID'=""
				    {
					    s ExamResultD=$lg($g(^CT.WDT.CDSS.ExamResultDictD(ResultID)),3) //检查检验结果字典转换
					}
					else
					{
						s ExamResultD=""
					}
				}
			}
		}
	    
	    s SymptomCore=$p(ExamResults,"%%",2)
	    s SymProperty=$p(ExamResults,"%%",3)
	    s CDSS2PartDR=$p(ExamResults,"%%",4)
	    s:CDSS2PartDR'="" CDSS2PartDR=$o(^CT.WDT.CDSS.BodyPartsDictI("DescIndex"," "_CDSS2PartDR,0))
	    s PositionWordDR=$p(ExamResults,"%%",5)
	    s:PositionWordDR'="" PositionWordDR=$o(^CT.WDT.CDSS.PositionWordI("DescIndex"," "_PositionWordDR,0))
	    s RisValue=$p(ExamResults,"%%",6)
	    s ExamResultFlag=RisValue
	    
	    s Examobj = ##class(WDT.CDSS.ExamInfo).%New()
	    /*d:PartDR'="" Examobj.PartDRSetObjectId(PartDR)		//1.0部位
		d:PartDR="" Examobj.PartDRSetObjectId("")*/
		d:CDSS2PartDR'="" Examobj.CDSS2PartDRSetObjectId(CDSS2PartDR)		//2.0部位
		d:CDSS2PartDR="" Examobj.CDSS2PartDRSetObjectId("")
		d:PositionWordDR'="" Examobj.PositionWordDRSetObjectId(PositionWordDR)		//2.0方位
		d:PositionWordDR="" Examobj.PositionWordDRSetObjectId("")
		s Examobj.IDNO= IDNO
	    s Examobj.PatientDR =PatientDR
	    s Examobj.VisitID =VisitID
	    s Examobj.VisitType =VisitType
	    s Examobj.GroupFlag =GroupFlag
	    s Examobj.GroupSequence =GroupSequence
		s Examobj.ExamCode= ExamCode
		s Examobj.ExamName= ExamName
		s Examobj.ExamResult= ExamResultD
		s:ExecuteTime'="" Examobj.ExecuteTime=ExecuteTime
	    s:ReportTime'="" Examobj.ReportTime=ReportTime
	    s Examobj.Remarks = Remarks	
	    s Examobj.ExamResultDesc= ExamResultDescs
	    s Examobj.ExamResultFlag= ExamResultFlag
	    s Examobj.ExamResultNum= ExamResultNum
	    s Examobj.PassFlag= PassFlag
	    s Examobj.SymptomCore=SymptomCore
	    s Examobj.SymProperty=SymProperty
	    s Examobj.ProjectName=ExamName	    
	    
	    s:PartDR'="" Examobj.PartDR=PartDR		//1.0部位
		s:PartDR="" Examobj.PartDR=""
		
		//s:CDSS2PartDR'="" Examobj.CDSS2PartDR=CDSS2PartDR		//2.0部位
		//s:PositionWordDR'="" Examobj.PositionWordDR=PositionWordDR		//2.0方位
		
		
	    d Examobj.%Save()
	    d Examobj.%Close()
	    d ..SaveSatisfyIW("WDT.CDSS.ExamInfo","ExamResult",IDNO,PatientDR,VisitID,VisitType)
	}
	q "success"
}

/// Creator:阚延新
/// CreatDate:2021-08-19
/// Description：用于内部检验报告入库
/// Input：{"GroupFlag":"01","InspectionCode":"001","InspectionName":"k1","LabResultInfo":[{"LabItemCode":"检验小项号","LabItemName":"x1","LabResult":"0.1","LabResultFlag":"阴性阳性","Unit":"单位","Reference":"参考范围"},{"LabItemCode":"检验小项号","LabItemName":"检验小项名称","LabResult":"检验结果","LabResultFlag":"阴性阳性","Unit":"单位","Reference":"参考范围"}],"ExecuteTime":"执行时间","ReportTime":"报告时间","Remarks":"备注"}
/// Output: 
/// w ##class(web.CDSS.MachineLearning.Inteplatform).SaveLabJsonInfo(^TMP("KYXLab"))
ClassMethod SaveLabJsonInfo(json As %String) As %String
{
	s:json["DM000821" ^TMP("KYXLab")=json
    s json=[].%FromJSON(json)
    s GroupFlag=json.%Get("GroupFlag")
    s LabInfoID=0
    s num=0
    for
    {
	    s LabInfoID =$o(^WDT.CDSS.LabInfoI("GroupFlagIndex"," "_GroupFlag,LabInfoID))
	    q:LabInfoID=""
	    s num=num+1
	    d:num'=1 ##class(WDT.CDSS.LabInfo).%DeleteId(LabInfoID)
	}
    s LabInfoID = $o(^WDT.CDSS.LabInfoI("GroupFlagIndex"," "_$ZCONVERT(GroupFlag,"U"),""),-1)
    w LabInfoID,!
    q:LabInfoID="" ""
    s IDNO = $lg($g(^WDT.CDSS.LabInfoD(LabInfoID)),2)
    s PatientDR  = $lg($g(^WDT.CDSS.LabInfoD(LabInfoID)),3)
    s VisitID = $lg($g(^WDT.CDSS.LabInfoD(LabInfoID)),4)
    s VisitType = $lg($g(^WDT.CDSS.LabInfoD(LabInfoID)),5)
    s GroupSequence = $lg($g(^WDT.CDSS.LabInfoD(LabInfoID)),7)
    s InspectionCode = $lg($g(^WDT.CDSS.LabInfoD(LabInfoID)),8)
    s InspectionName = $lg($g(^WDT.CDSS.LabInfoD(LabInfoID)),9)
    s Unit = $lg($g(^WDT.CDSS.LabInfoD(LabInfoID)),13)
    s Reference = $lg($g(^WDT.CDSS.LabInfoD(LabInfoID)),14)
    s Specimen = $lg($g(^WDT.CDSS.LabInfoD(LabInfoID)),15)
    s ExecuteTime = $lg($g(^WDT.CDSS.LabInfoD(LabInfoID)),16)
    s ReportTime = $ZDT($H,3)
    s Remarks = $lg($g(^WDT.CDSS.LabInfoD(LabInfoID)),18)
    s PassFlag = $lg($g(^WDT.CDSS.LabInfoD(LabInfoID)),19)
    s LabResultFlag = $lg($g(^WDT.CDSS.LabInfoD(LabInfoID)),20)
    s LabItemName = $lg($g(^WDT.CDSS.LabInfoD(LabInfoID)),11)
    //d ##class(WDT.CDSS.LabInfo).%DeleteId(LabInfoID)   //取出数据成功后删除这条数据
    //获得推送内容
    s:ExecuteTime="" ExecuteTime = json.%Get("ExecuteTime")
    s:ReportTime="" ReportTime = json.%Get("ReportTime")
    s Remarks = json.%Get("Remarks")
    s ChildItem=json.%Get("LabResultInfo")
	for j=0:1:(ChildItem.%Size()-1)
	{
		s LabItemCode=ChildItem.%Get(j).%Get("LabItemCode")
		s LabItemName=ChildItem.%Get(j).%Get("LabItemName")
		s LabResult=ChildItem.%Get(j).%Get("LabResult")
		s LabResultFlag=ChildItem.%Get(j).%Get("LabResultFlag")
		s:(LabResultFlag'="预期寿命")&(LabResultFlag'="阴性")&(LabResultFlag'="阳性")&(LabResultFlag'="已治愈")&(LabResultFlag'="原因性质待查")&(LabResultFlag'="存在状态未明确")&(LabResultFlag'="弱阳性")&(LabResultFlag'="强阳性")&(LabResultFlag'="减弱")&(LabResultFlag'="消失")&(LabResultFlag'="亢进")&(LabResultFlag'="迟钝")&(LabResultFlag'="升高")&(LabResultFlag'="降低") LabResultFlag=""
		s Unit=ChildItem.%Get(j).%Get("Unit")
		s Reference=ChildItem.%Get(j).%Get("Reference")
	    s Labobj=##class(WDT.CDSS.LabInfo).%New()
		s Labobj.IDNO= IDNO
		s Labobj.PatientDR =PatientDR
		s Labobj.VisitID =VisitID
		s Labobj.VisitType =VisitType
		s Labobj.GroupFlag =GroupFlag
		s Labobj.GroupSequence =GroupSequence
		s Labobj.InspectionCode =InspectionCode
		s Labobj.InspectionName =InspectionName
		s Labobj.LabItemCode =LabItemCode
		s Labobj.LabItemName =LabItemName
		s Labobj.LabResult =LabResult
		s Labobj.LabResultFlag =LabResultFlag
		s Labobj.Unit = Unit
		s Labobj.Reference = Reference
		d Labobj.SpecimenSetObjectId(Specimen)
		s:ExecuteTime'="" Labobj.ExecuteTime = ExecuteTime
		s:ReportTime'="" Labobj.ReportTime =ReportTime
		s Labobj.Remarks = Remarks
		s Labobj.PassFlag = PassFlag
		s sc=Labobj.%Save()  
		d ..SaveSatisfyIW("WDT.CDSS.LabInfo","LabResult",IDNO,PatientDR,VisitID,VisitType)
	}

	q "success"
}

/// Creator:阚延新
/// CreatDate:2021-12-13
/// Description：用于内部体征信息入库
/// Input：json
/// Output: 
/// w ##class(web.CDSS.MachineLearning.Inteplatform).SaveSignJsonInfo()
ClassMethod SaveSignJsonInfo(json As %String) As %String
{
	s ^TMP("KYXSign")=json
    s json=[].%FromJSON(json)
    //获得推送内容
    s SignFlag=json.%Get("SignFlag")
    s IDNO=json.%Get("IDNO")
    s PatientDR=json.%Get("PatientDR")
    s VisitID=json.%Get("VisitID")
	;s:VisitID="" VisitID=$o(^WDT.CDSS.SignInfoI("PatVisDRIndex",PatientDR,""),-1)   //获取最后一次就诊次
    s VisitType=json.%Get("VisitType")
    s VisitType=$case(VisitType,1:"急诊",2:"门诊",3:"住院",:"住院")
    s BodyTemperature=json.%Get("BodyTemperature")
    d:BodyTemperature'="" ..SaveSatisfyIW("WDT.CDSS.SignInfo","BodyTemperature",IDNO,PatientDR,VisitID,VisitType)
    s BloodPressure=json.%Get("BloodPressure")
    d:BodyTemperature'="" ..SaveSatisfyIW("WDT.CDSS.SignInfo","BloodPressure",IDNO,PatientDR,VisitID,VisitType)
    s Pulse=json.%Get("Pulse")
    d:Pulse'="" ..SaveSatisfyIW("WDT.CDSS.SignInfo","Pulse",IDNO,PatientDR,VisitID,VisitType)
    s BreathFeature=json.%Get("BreathFeature")
    d:BreathFeature'="" ..SaveSatisfyIW("WDT.CDSS.SignInfo","BreathFeature",IDNO,PatientDR,VisitID,VisitType)
    s HeartRate=json.%Get("HeartRate")
    d:HeartRate'="" ..SaveSatisfyIW("WDT.CDSS.SignInfo","HeartRate",IDNO,PatientDR,VisitID,VisitType)
    s OxygenSaturation=json.%Get("OxygenSaturation")
    d:OxygenSaturation'="" ..SaveSatisfyIW("WDT.CDSS.SignInfo","OxygenSaturation",IDNO,PatientDR,VisitID,VisitType)
    s Pupil=json.%Get("Pupil")
    d:Pupil'="" ..SaveSatisfyIW("WDT.CDSS.SignInfo","Pupil",IDNO,PatientDR,VisitID,VisitType)
    s CornealReflex=json.%Get("CornealReflex")
    d:CornealReflex'="" ..SaveSatisfyIW("WDT.CDSS.SignInfo","CornealReflex",IDNO,PatientDR,VisitID,VisitType)
    s Height=json.%Get("Height")
    d:Height'="" ..SaveSatisfyIW("WDT.CDSS.SignInfo","Height",IDNO,PatientDR,VisitID,VisitType)
    s Weight=json.%Get("Weight")
    d:Weight'="" ..SaveSatisfyIW("WDT.CDSS.SignInfo","Weight",IDNO,PatientDR,VisitID,VisitType)
    s MeasureDate=json.%Get("MeasureDate")
    s DiastolicBlood=json.%Get("DiastolicBlood")
    d:DiastolicBlood'="" ..SaveSatisfyIW("WDT.CDSS.SignInfo","DiastolicBlood",IDNO,PatientDR,VisitID,VisitType)
    s SystolicBlood=json.%Get("SystolicBlood")
    d:SystolicBlood'="" ..SaveSatisfyIW("WDT.CDSS.SignInfo","SystolicBlood",IDNO,PatientDR,VisitID,VisitType)
    s:VisitID="" VisitID=1
    s Config=##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSSdyn20200416")
    s:Config="" Config="1"
    if (SignFlag=1)
    {
	    if Config
	    {
	    	s ID=$o(^WDT.CDSS.SignInfoI("PatVisDRTypeTimeIndex",PatientDR,VisitID,VisitType,MeasureDate,0))
	    }
	    else 
	    {
		    s ID=$o(^WDT.CDSS.SignInfoI("IDNOTimeIndex",IDNO,MeasureDate,0))
		}
	    if (ID'="")
	    {
		    //修改
		    s Signobj = ##class(WDT.CDSS.SignInfo).%OpenId(ID)
		}
		else
		{
			//新增
	    	s Signobj = ##class(WDT.CDSS.SignInfo).%New()
		}
	    s Signobj.IDNO= IDNO
	    s Signobj.PatientDR =PatientDR
	    s Signobj.VisitID =VisitID
	    s Signobj.VisitType =VisitType
	    s Signobj.BodyTemperature =BodyTemperature 
	    s Signobj.BloodPressure=SystolicBlood_"/"_DiastolicBlood
	    s Signobj.Pulse=Pulse
	    s Signobj.BreathFeature=BreathFeature
	    s Signobj.HeartRate=HeartRate
	    s Signobj.OxygenSaturation=OxygenSaturation
	    s Signobj.Pupil=Pupil
	    s Signobj.CornealReflex=CornealReflex
	    s Signobj.Height=Height
	    s Signobj.Weight=Weight
	    s Signobj.MeasureDate =MeasureDate
	    s Signobj.DiastolicBlood=DiastolicBlood
	    s Signobj.SystolicBlood=SystolicBlood
	    
	    s sc=Signobj.%Save()
	    s PatientUserInfo=IDNO_"^"_PatientDR_"^"_VisitID_"^"_VisitType_"^^^^^1"
	    d ##class(web.CDSS.IdentifyWords.GetPatientIW).GetSatisfyIW(PatientUserInfo)	    
	}
	if (SignFlag=2) //批量删除
	{
		s size=$l(MeasureDate,",")
	    for i=1:1:size
	    {
		    s MeasureDateD=$p(MeasureDate,",",i)
		    //新增
		    if Config
		    {
		    	s ID=$o(^WDT.CDSS.SignInfoI("PatVisDRTypeTimeIndex",PatientDR,VisitID,VisitType,MeasureDateD,0))
		    }
		    else
		    {
				s ID=$o(^WDT.CDSS.SignInfoI("IDNOTimeIndex",IDNO,MeasureDate,0))    
			}
		    d:ID'="" ..DeleteData(ID)
		    
		}
	}
    q ""
}

ClassMethod DeleteData(id As %String) As %String
{
	s result=""
	Tstart
	s sc=##class(WDT.CDSS.SignInfo).%DeleteId(id)
	IF $$$ISOK(sc)
	{
		
		Tc
		s result="{success:'true',info:'删除成功！'}"
	}
	else
	{
		Trollback
		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		s result= "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}
	q result
}

/// Creator:Fanwenkai	
/// CreatDate:2021-12-27
/// Description：用于内部体征信息入库时触发识别词更新
/// Input：json
/// Output: 
/// w ##class(web.CDSS.MachineLearning.Inteplatform).SaveSignJsonInfo()
ClassMethod SaveSatisfyIW(TableName, fieldkey, IDNOValue, PatientDRValue, VisitIDValue, VisitTypeValue) As %String
{
	s:VisitTypeValue=3 VisitTypeValue="住院"
	//判断该字段是否要触发识别词
    s TableRowID = $o(^CT.WDT.CDSS.DataTableDictI("TableNameIndex",TableName,fieldkey,""))
    s PMDataType=$lg($g(^CT.WDT.CDSS.DataTableDictD(TableRowID)),14)
    if (PMDataType'="")
	{
		s PMDataTypeNum=$l(PMDataType,"&")
		for i=0:1:(PMDataTypeNum-1)
		{
			s DataType=$p(PMDataType,"&",i+1)
			continue:$d(^WDT.CDSS.PatPMTypeIndexI("PatVisDRUpTypeIndex",PatientDRValue,VisitIDValue,1,DataType))
			s PMobj=##class(WDT.CDSS.PatPMTypeIndex).%New()
			s PMobj.IDNO=IDNOValue
			s PMobj.PatientDR=PatientDRValue
			s PMobj.VisitID=VisitIDValue
			s PMobj.VisitType=VisitTypeValue
			s PMobj.DataType=DataType
			s PMobj.IsLastUpdate=1
			d PMobj.%Save()
			d PMobj.%Close()
		}
	}
	//d ##class(web.CDSS.IdentifyWords.GetPatientIW).GetSatisfyIW(PatientUserInfo)
}

/// Creator:lideyuan
/// CreatDate:2020-05-13
/// Description：把非结构化数据通过调用nlp服务器接口，转化为结构化数据
/// Input：data: json格式数据，key:data,value:要结构化的内容
/// Output: 结构化结果json字符串
/// w ##class(web.CDSS.MachineLearning.Inteplatform).GetStructedDataAPI("上腹疼痛，夜间腹痛加重，上腹疼痛5分钟，呕血10毫升，转移性右下腹痛，眼部疼痛，5月前脑梗死")
ClassMethod GetStructedDataAPI(content As %String) As %String
{
	
	set httpRequest = ##class(%Net.HttpRequest).%New()
 	//s Url="http://111.205.6.207:1223/tag"
 	s Url=##class(web.DHCBL.MKB.MKBConfig).GetConfigValue("CDSSldy2020070701")
    Do httpRequest.SetHeader("Content-Type","application/x-www-form-urlencoded; charset=utf8")
    do httpRequest.InsertFormData("data", content)
    q:content="" ""
    //超时时间
    s httpRequest.Timeout=1.5
    set status = httpRequest.Post(Url)
    If $$$ISERR(status) 
    { //Quit $system.OBJ.DisplayError(status) 
    	q "[]"
    }
    s stream=##class(%Stream.GlobalCharacter).%New()
    s stream= httpRequest.HttpResponse.Data
    Set responseString =""
    while 'stream.AtEnd
    {
	    s responseString=responseString_stream.ReadLine()
	}
    Quit responseString
}

/// Creator:阚延新
/// CreatDate:2021-08-20
/// Description：提取主诉过NLP后的解析内容
/// Input：nlp json返回的字符串
/// Output: formal串
/// w ##class(web.CDSS.MachineLearning.Inteplatform).CollectResultToNLP(json)
ClassMethod CollectResultToNLP(NLPStringOld As %String) As %String
{
	///w NLPStringOld,!
	s NLPString=$REPLACE(NLPStringOld,"'","""")
	///w NLPString,!
	s formal=""
	s results=""
	if NLPString="[]"
	{
		q ""
	}
	else
	{
		s NLPArray=[].%FromJSON(NLPString)
	
	    for i=0:1:NLPArray.%Size()-1
		{
			s ItemJson=NLPArray.%Get(i)
			s result=""
			s formal=""
			s risname=""
			s signname=""
			s Core=""
			s signvalename=""
			if (ItemJson.%IsDefined("formal"))&(ItemJson.%Get("formal")'="")
		    {
			    s formal=ItemJson.%Get("formal")			    
		    }
		    if (ItemJson.%IsDefined("ris_name"))&(ItemJson.%Get("ris_name")'="")
		    {
			    s risname=ItemJson.%Get("ris_name").%Get("name")
			}
			if (ItemJson.%IsDefined("sign")) //体征名
		    {
			    if (ItemJson.%Get("sign").%Get("name")'="")
			    {
				    s signname=ItemJson.%Get("sign").%Get("name")
				}
			}
			if (ItemJson.%IsDefined("sign_name")) //sign_name 心室率：210次/分
			{
				if (ItemJson.%Get("sign_name").%Get("name")'="")
				{
					s signvalename=ItemJson.%Get("sign_name").%Get("name")
					if signname="" 
					{
						s signname=signvalename
					}
					else
					{
						s signname=signname_"&%"_signvalename
					}
				}
			}
			if (ItemJson.%IsDefined("core"))&(ItemJson.%Get("core")'="") //多发性鼻息肉
		    {
			    s Core=result_ItemJson.%Get("core")
			    if Core["、"
			    {
				    s Core=$replace(Core,"、","&%")
				}
		    }
			
			
			if (formal'="") //归一词不为空
			{
				if (risname'="")
				{
					if (signname'="")
					{
						if (Core'="")
						{
							s result=formal_"&%"_risname_"&%"_signname_"&%"_Core
						}
						else
						{
							s result=formal_"&%"_risname_"&%"_signname
						}
					}
					else
					{
						if (Core'="")
						{
							s result=formal_"&%"_risname_"&%"_Core
						}
						else
						{
							s result=formal_"&%"_risname
						}
					}
				}
				else
				{
					if (signname'="")
					{
						if (Core'="")
						{
							s result=formal_"&%"_signname_"&%"_Core
						}
						else
						{
							s result=formal_"&%"_signname
						}
					}
					else
					{
						if (Core'="")
						{
							s result=formal_"&%"_Core
						}
						else
						{
							s result=formal
						}
					}
				}
			}
			else //归一词为空
			{
				if (risname'="")
				{
					if (signname'="")
					{
						if (Core'="")
						{
							s result=risname_"&%"_signname_"&%"_Core
						}
						else
						{
							s result=risname_"&%"_signname
						}
					}
					else
					{
						if (Core'="")
						{
							s result=risname_"&%"_Core
						}
						else
						{
							s result=risname
						}
					}
				}
				else //检查名称为空
				{
					if (signname'="")
					{
						if (Core'="")
						{
							s result=signname_"&%"_Core
						}
						else
						{
							s result=signname
						}
					}
					else //体征名为空
					{
						if Core'=""
						{
							s result=Core
						}
					}
				}
			}
		    s result=result_"%%"
		    if (ItemJson.%IsDefined("core"))&(ItemJson.%Get("core")'="")
		    {
			    s result=result_ItemJson.%Get("core")
		    }
		    s result=result_"%%"
		    
		    
		    ///属性：用&%拼接level，frequency，nature，day_time内容
			s SymProperty=""
			if ItemJson.%IsDefined("level")
			{
				s Level=ItemJson.%Get("level").%Get("name")  //程度
				s SymProperty=Level
			}
			if ItemJson.%IsDefined("frenquency")
			{
				s Frenquency=ItemJson.%Get("frenquency").%Get("name")  //频率
				s:SymProperty'="" SymProperty=SymProperty_"&%"_Frenquency
				s:SymProperty="" SymProperty=Frenquency
			}
			if ItemJson.%IsDefined("nature")
			{
				s Nature=""
				if ($e(ItemJson.%Get("nature").%ToJSON(),1)="[")  //"[...]"格式
				{
					for p=0:1:ItemJson.%Get("nature").%Size()-1 //$l(ItemJson.%Get("nature"))
					{
						s NatureJson=ItemJson.%Get("nature").%Get(p)
						s NatureNow=NatureJson.%Get("name")
						s:Nature'="" Nature=Nature_"&%"_NatureNow
						s:Nature="" Nature=NatureNow
					}
				}
				elseif ($e(ItemJson.%Get("nature").%ToJSON(),1)="{") //"{...}"格式
				{
					s Nature=ItemJson.%Get("nature").%Get("name")  //性质
				}
				
				//s Nature=ItemJson.%Get("nature").%Get("name")  //性质
				s:SymProperty'="" SymProperty=SymProperty_"&%"_Nature
				s:SymProperty="" SymProperty=Nature
			}
			if ItemJson.%IsDefined("day_time")
			{
				///day_time的格式区别于level和frequency，"[...]"格式
				s DayTime=""
				for y=0:1:ItemJson.%Get("day_time").%Size()-1 //$l(ItemJson.%Get("day_time"))
				{
					s DayTimeJson=ItemJson.%Get("day_time").%Get(y)
					s DayTimeNow=DayTimeJson.%Get("name")
					s:DayTime'="" DayTime=DayTime_"&%"_DayTimeNow
					s:DayTime="" DayTime=DayTimeNow
				}
				s:SymProperty'="" SymProperty=SymProperty_"&%"_DayTime
				s:SymProperty="" SymProperty=DayTime
			}
			if ItemJson.%IsDefined("ris_result") //检查结果存属性字段
			{
				s risresult=ItemJson.%Get("ris_result").%Get("name")
				s:SymProperty'="" SymProperty=SymProperty_"&%"_risresult
				s:SymProperty="" SymProperty=risresult
			}
			
			s result=result_SymProperty_"%%"
			//2.0的部位和方位
			if ItemJson.%IsDefined("stand_body") ///2.0的部位 CDSS2PartDR
			{
				s Body=""
				for t=0:1:ItemJson.%Get("stand_body").%Size()-1
				{
					s BodyJson=ItemJson.%Get("stand_body").%Get(t)
					s BodyNow=BodyJson.%Get("name")
					s:Body'="" Body=Body_BodyNow
					s:Body="" Body=BodyNow
				}
			}
			else
			{
				s Body=""
			}
			
			if ItemJson.%IsDefined("stand_pos")  //2.0的方位  PositionWordDR
			{
				s Pos=""
				for q=0:1:ItemJson.%Get("stand_pos").%Size()-1
				{
					s PosJson=ItemJson.%Get("stand_pos").%Get(q)
					s PosNow=PosJson.%Get("name")
					s:Pos'="" Pos=Pos_PosNow
					s:Pos="" Pos=PosNow
				}
			}
			else
			{
				s Pos=""
			}
			s result=result_Body_"%%"_Pos_"%%"
			
			//检查结果的值
			if ItemJson.%IsDefined("ris_value")
			{
				s risvalue=ItemJson.%Get("ris_value").%Get("name")
			}
			elseif ItemJson.%IsDefined("value")
			{
				s risvalue=ItemJson.%Get("value").%Get("name")
			}
			elseif ItemJson.%IsDefined("sign_value")
			{
				s risvalue=ItemJson.%Get("sign_value").%Get("name")
			}
			else
			{
				s risvalue=""
			}
			s:risvalue'="" risvalue=$ZSTRIP(risvalue,"*A") //去除字母
			s result=result_risvalue_"%%"
			
			if (results="")
			{
				s results=result
			}
			else
			{
				s results=results_";"_result
			}
		}
	}
	q results
}

/// Creator:wuzhe
/// CreatDate:2022-10-09
/// Description：提取LIS报告描述过NLP后的解析内容
/// Input：LIS报告描述
/// Output: JSON串
/// Others：w ##class(web.CDSS.MachineLearning.Inteplatform).LisResultToNLP("尿红细胞形态检查：红细胞呈多形性")
ClassMethod LisResultToNLP(content As %String) As %String
{
	q:content="" "[]"
	
	s NLPString=..GetStructedDataAPI(content) //检验结果过NLP
	q:(NLPString="[]")||(NLPString["error") "[]"
	s NLPArray=[].%FromJSON(NLPString)
	s Result=[] 
	for i=0:1:NLPArray.%Size()-1
	{
		s ItemJson=NLPArray.%Get(i)
		s IsPositiveFlag=ItemJson.%Get("type")
		continue:(IsPositiveFlag'="lis_reslut")&(IsPositiveFlag'="+lis_reslut")&(IsPositiveFlag'="lis_reslut") //去除NLP解析不是检验结果的数据
		
		
		if ItemJson.%IsDefined("lis_name") //检验名称
		{
			s lisname=ItemJson.%Get("lis_name").%Get("name")
		}
		else
		{
			s lisname=""
		}
		
		if ItemJson.%IsDefined("lis_result") //检验结果名称
		{
			s lisresult=ItemJson.%Get("lis_result").%Get("name")
		}
		else
		{
			s lisresult=""
		}
		
		if ItemJson.%IsDefined("lis_order") //关联检验医嘱名称
		{
			s lisorder=ItemJson.%Get("lis_order").%Get("name")
		}
		else
		{
			s lisorder=""
		}
		
		
		/*
		
		if ItemJson.%IsDefined("sign_value") //体征值
		{
			s SignValue=ItemJson.%Get("sign_value")
			s SignValueType=ItemJson.%GetTypeOf("sign_value")
			if SignValueType="array"   //如果值是一个数组
			{
				s SignValueArraySize=SignValue.%Size()
				s value=""
				for j=0:1:SignValueArraySize-1
				{
					s:value'="" value=value_"/"_SignValue.%Get(j).%Get("name")
					s:value="" value=SignValue.%Get(j).%Get("name")
				}
			}
			else   //如果值只是一个{}
			{
				s value=SignValue.%Get("name")
			}
		}
		else
		{
			s value=""
		}
		
		if ItemJson.%IsDefined("sign_unit") //体征单位
		{
			s unit=ItemJson.%Get("sign_unit").%Get("name")
		}
		else
		{
			s unit=""
		}*/
		
		/*s ChildItem={}
		d ChildItem.%Set("lisname",lisname)
		d ChildItem.%Set("lisresult",lisresult)

		d Result.%Push(ChildItem)*/
	}
	q Result.%ToJSON()
}

}
