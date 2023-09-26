/// Creator:lwj
/// CreatDate:2021-11-06
/// Description:第三方调用数据接口
/// Definition：疑似诊断评测工具患者数据更新
Class web.CDSS.Demo.PatientInfoRenew Extends %RegisteredObject
{

/// Creator:陈代雷
/// CreatDate:2020-06-15
/// Description:第三方调用数据接口
/// Table:
/// Input: action:命令 json：json信息串
/// Return:
/// Others:w ##class(web.CDSS.Demo.PatientInfoRenew).DHCHisInterface(action,json)
ClassMethod DHCHisInterface(action As %String, json As %String) As %String
{
	s ExecutionTimeSt=$p($h,",",2)
	s json=$REPLACE(json,":""}",":""""}")
	s json=$REPLACE(json,":"",",":"""",")
	s:json["977445" ^TMP("testjson")=json
	s info=[].%FromJSON(json)
	s UserName = info.%Get("UserName")
	s UserLoc = info.%Get("DeptName")
	//s Config=##class(web.DHCBL.MKB.MKBConfig).GetConfigValue("CDSSdyn20200416")
	s Config = "1"
    s PatientUserInfo=info.%Get("IDNO")_"^"_info.%Get("PatientDR")_"^"_$tr(info.%Get("VisitID"),0)_"^"_..ConvertVisitType(info.%Get("VisitType"))_"^"_info.%Get("UserID")_"^"_info.%Get("UserName")_"^"_info.%Get("DeptCode")_"^"_info.%Get("DeptName")_"^"_Config  //调用后台接口的参数
    s result=""
    if (action="SAVE_MEDICAL_RECORD_INFORMATION")  //保存病例信息
    {
        s dealedJson=##class(web.CDSS.IMP.HospLinkRules).SplitContentToJson(json)  //处理后的病例或其他信息
        s:dealedJson="" dealedJson="[]"
        s dealedJson=[].%FromJSON(dealedJson)
        s BackupJson=json
        s json=[].%FromJSON(json)
        s BackupJson=[].%FromJSON(BackupJson) 
        for i=0:1:(dealedJson.%Size()-1)
        {
            s dealedDict=dealedJson.%Get(i)  //单个病例信息
            s dealedKey=dealedDict.%Get("key")
            s dealedValue=dealedDict.%Get("value")
            ///病例信息完整性
            s ProgressNoteList=json.%Get("ProgressNoteList")
            s BProgressNoteList=BackupJson.%Get("ProgressNoteList")
            if (ProgressNoteList'="")
            {
                s MessageList=ProgressNoteList.%Get("MessageList")  //病例列表
                s BMessageList=BProgressNoteList.%Get("MessageList")  //病例列表
                if (MessageList'="")  //当为键值对类型时
                {
                    for j=0:1:(MessageList.%Size()-1)
                    {
                        s grossDict=MessageList.%Get(j)  //未处理的字段，例如主述、个人史等等
                        s BgrossDict=BMessageList.%Get(j)  //未处理的字段，例如主述、个人史等等
                        if (grossDict.%Get("key")=dealedKey)  //如果为需要处理的字段
                        {
                            d BgrossDict.%Set("value",dealedValue)
                        }
                    }
                }
                else
                {
                    d BProgressNoteList.%Set("MessageList",dealedJson)
                }
            } 
        }
        s BackupJson=BackupJson.%ToJSON()
        //d ##class(web.CDSS.MachineLearning.NewParseMode).ModifyMedicalRecords(BackupJson)
        s result=..SaveProgress(BackupJson)
    }
    if result=""
    {
	    q ""
    }
    elseif result="DeleteDiagnosisInfo"
    {
	    q result
    }
    else
    {
	    try
	    {
	    	d ##class(web.CDSS.MachineLearning.ParseMode).ParsePatientModel(result)
	    }
	    catch e
	    {
		    //w ##class(web.CDSS.MachineLearning.ParseMode).ParsePatientModel(result)
	    }
    }
    q PatientUserInfo
}

/// Creator:陈代雷
/// CreatDate:2020-06-09
/// Description:保存病例信息
/// Table:
/// Input: ProgressInfo : {"IDNO": "患者主索引", "PatientDR": "病人标识", "VisitID": "1", "Name": "患者姓名", "UserID": "医生ID", "UserName": "医生姓名", "DeptCode": "科室编码", "DeptName": "科室名称", "PatientInfo": {"Gender": "性别", "BirthDate": "出生日期", "PregnancyStatus": "妊娠状态"}, "ProgressNoteList": {"ProgressId": "病历唯一标识", "ProgressType": "病历类型", "ProgressTempleateID": "模板唯一标示", "ProgressTemplateName": "模板名称", "MsgType": "病历内容传递格式", "Message": "病历内容", "MessageList": [{"key": "主诉", "value": "今天发热，头痛，转移性右下腹痛"}, {"key": "现病史", "value": "现病史内容"}], "DoctorId": "开立医生ID", "DoctorName": "医生姓名", "CreateDeptCode": "开立科室代码", "CreateDeptName": "开立科室名称", "RecordTime": "病历记录时间"}}
/// Return:
/// Others:w ##class(web.CDSS.MachineLearning.InteractiveInterface).SaveProgress(ProgressInfo)
ClassMethod SaveProgress(ProgressInfo As %String) As %String
{
    s info=[].%FromJSON(ProgressInfo)
    s CaseJson={}
    d CaseJson.%Set("IDNO",info.%Get("IDNO"))
    d CaseJson.%Set("PatientDR",info.%Get("PatientDR"))
    d CaseJson.%Set("VisitID",info.%Get("VisitID"))
    d CaseJson.%Set("VisitType",..ConvertVisitType(info.%Get("VisitType")))
    d CaseJson.%Set("UserID",info.%Get("UserID"))
    d CaseJson.%Set("UserName",info.%Get("UserName"))
    d CaseJson.%Set("CTLocID",info.%Get("DeptCode"))
    d CaseJson.%Set("CTLocDesc",info.%Get("DeptName"))
    //d CaseJson.%Set("Config",##class(web.DHCBL.MKB.MKBConfig).GetConfigValue("CDSSdyn20200416"))
    s children=[]  //所有信息表
    ///基础信息表
    s PatientMaster={}  //基础信息字典
    d PatientMaster.%Set("DataClass","PatientMaster")
    s PatientMasterC=[]  ////基础信息详细内容
    s PatientMasterDict={}  //单个基础信息详细内容
    d PatientMasterDict.%Set("MedicareCardNum",info.%Get("IDNO")) //病人标识 //医保卡号
    d PatientMasterDict.%Set("IDCardNumber",info.%Get("IDNO")) //病人标识, //身份证号
    d PatientMasterDict.%Set("Name",info.%Get("Name"))   //姓名
    d PatientMasterDict.%Set("Sex",..ConvertSex(info.%Get("PatientInfo").%Get("Gender")))  //性别（性别病史）
    if info.%Get("PatientInfo").%Get("Age")'=""
    {
	    s Age=info.%Get("PatientInfo").%Get("Age")
    }	
    else
    {	
    	if (##class(%Library.TimeStamp).IsValid(info.%Get("PatientInfo").%Get("BirthDate")))
    	{
    		s Age=##class(web.CDSS.MachineLearning.InteractiveInterface).CurrentAge($zdh(info.%Get("PatientInfo").%Get("BirthDate"),3))
    	}
    	else
    	{
	    	s Age=""
    	}
    }
    //s Age=($h-$zdh(info.%Get("PatientInfo").%Get("BirthDate"),3))/365
    d PatientMasterDict.%Set("Age",Age) //年龄
    d PatientMasterDict.%Set("Profession","") //职业（职业病史）
    d PatientMasterDict.%Set("Nation","") //民族
    d PatientMasterDict.%Set("Marriage","") //婚姻
    d PatientMasterDict.%Set("BloodGroup","") //血型
    d PatientMasterDict.%Set("Country","") //国籍
    d PatientMasterDict.%Set("Birthplace","") //籍贯
    d PatientMasterDict.%Set("Birthday",info.%Get("PatientInfo").%Get("BirthDate"))  			//出生日期		
    d PatientMasterDict.%Set("CurrentAddress",info.%Get("PatientInfo").%Get("CurrentAddress")) //现住址
    d PatientMasterDict.%Set("PhoneNumber","") //电话
    d PatientMasterC.%Push(PatientMasterDict)
    d PatientMaster.%Set("children",PatientMasterC)
    d children.%Push(PatientMaster)
    d CaseJson.%Set("Birthday",info.%Get("PatientInfo").%Get("BirthDate"))  //出生日期
    //d CaseJson.%Set("PregnancyStatus",info.%Get("PatientInfo").%Get("PregnancyStatus"))  //妊娠状态
    ///病例信息表
    s CaseInfo={}  //病例信息
    d CaseInfo.%Set("DataClass","PatientVisit")
    s CaseInfoC=[]  //病例信息详细内容
    s CaseList=info.%Get("ProgressNoteList")  //病例信息列表，医院数据
    s MRCode=CaseList.%Get("ProgressID")
    d CaseJson.%Set("MRCode",MRCode)
    s CaseInfoDict={}  //单个基础信息详细内容
    d CaseInfoDict.%Set("VisitType",..ConvertVisitType(info.%Get("VisitType"))) //就诊类型（急诊、门诊、住院）
    d CaseInfoDict.%Set("TreatmentTime",$ZDT($h,3)) //就诊时间
    d CaseInfoDict.%Set("VisitingDepartment",CaseList.%Get("CreateDeptName")) //就诊科室
    d CaseInfoDict.%Set("ComorbidityMarker","") //合并症标记
    d CaseInfoDict.%Set("TransferRecord","") //转科记录
    d CaseInfoDict.%Set("DischargeTime",CaseList.%Get("RecordTime")) //离院时间
    d CaseInfoDict.%Set("DischargeDepartment",CaseList.%Get("CreateDeptName")) //离院科室
    /*d CaseInfoDict.%Set("ChiefCompSum","") //主诉概述
    d CaseInfoDict.%Set("CurrentMedHisSum","") //现病史概述
    d CaseInfoDict.%Set("PastDiagnosisSum","") //既往史概述
    d CaseInfoDict.%Set("FamilyHisSum","") //家族史概述
    d CaseInfoDict.%Set("PersonalHisSum","") //个人史概述
    d CaseInfoDict.%Set("MarryHisSum","")  //婚育史概述
    d CaseInfoDict.%Set("MenstrualHisSum","")  //月经史概述
    d CaseInfoDict.%Set("AllergyHisSum","") //过敏史概述
    d CaseInfoDict.%Set("PhysicalExamSum","") //体格检查概述
    d CaseInfoDict.%Set("SpecExamSum","") //转科检查概述*/
    s MessageList=CaseList.%Get("MessageList")  //病历字典
    for i=0:1:(MessageList.%Size()-1)
    {
        if (MessageList.%Get(i).%Get("key")="主诉")
        {
	        /*s MLChiefCompSum = $replace(MessageList.%Get(i).%Get("value"),$c(10),"")
	        s MLChiefCompSum = $replace(MLChiefCompSum,$c(13)," ")
	        d CaseInfoDict.%Set("ChiefCompSum",MLChiefCompSum)*/
	        d CaseInfoDict.%Set("ChiefCompSum",##class(web.CDSS.CMKB.FunLib).TransLinefeed(MessageList.%Get(i).%Get("value"))) //主诉概述
            //d CaseInfoDict.%Set("ChiefCompSum",$replace(MessageList.%Get(i).%Get("value"),$c(13),"")) //主诉概述
        }
        if ((MessageList.%Get(i).%Get("key")="现病史")||(MessageList.%Get(i).%Get("key")="出院情况"))
        {
            d CaseInfoDict.%Set("CurrentMedHisSum",##class(web.CDSS.CMKB.FunLib).TransLinefeed(MessageList.%Get(i).%Get("value"))) //现病史概述
        }
        if (MessageList.%Get(i).%Get("key")="既往史")
        {
            d CaseInfoDict.%Set("PastDiagnosisSum",##class(web.CDSS.CMKB.FunLib).TransLinefeed(MessageList.%Get(i).%Get("value"))) //既往史概述
        }
        if (MessageList.%Get(i).%Get("key")="家族史")
        {
            d CaseInfoDict.%Set("FamilyHisSum",##class(web.CDSS.CMKB.FunLib).TransLinefeed(MessageList.%Get(i).%Get("value"))) //家族史概述
        }
        if (MessageList.%Get(i).%Get("key")="个人史")
        {
            d CaseInfoDict.%Set("PersonalHisSum",##class(web.CDSS.CMKB.FunLib).TransLinefeed(MessageList.%Get(i).%Get("value"))) //个人史概述
        }
        if (MessageList.%Get(i).%Get("key")="婚育史")
        {
            d CaseInfoDict.%Set("MarryHisSum",##class(web.CDSS.CMKB.FunLib).TransLinefeed(MessageList.%Get(i).%Get("value"))) //婚育史概述
        }
        if (MessageList.%Get(i).%Get("key")="月经史")
        {
            d CaseInfoDict.%Set("MenstrualHisSum",##class(web.CDSS.CMKB.FunLib).TransLinefeed(MessageList.%Get(i).%Get("value"))) //月经史概述
        }
        if (MessageList.%Get(i).%Get("key")="过敏史")
        {
            d CaseInfoDict.%Set("AllergyHisSum",##class(web.CDSS.CMKB.FunLib).TransLinefeed(MessageList.%Get(i).%Get("value"))) //过敏史概述
        }
        if (MessageList.%Get(i).%Get("key")="体格检查")
        {
            d CaseInfoDict.%Set("PhysicalExamSum",##class(web.CDSS.CMKB.FunLib).TransLinefeed(MessageList.%Get(i).%Get("value"))) //体格检查概述
        }
        if (MessageList.%Get(i).%Get("key")="转科检查")
        {
            d CaseInfoDict.%Set("SpecExamSum",##class(web.CDSS.CMKB.FunLib).TransLinefeed(MessageList.%Get(i).%Get("value"))) //转科检查概述
        }
        //新增诊断信息解析 2021-10-21
        if (MessageList.%Get(i).%Get("key")="初步诊断")
        {
	    	d CaseInfoDict.%Set("PrimaryDiag",##class(web.CDSS.CMKB.FunLib).TransLinefeed(MessageList.%Get(i).%Get("value"))) //初步诊断概述    
	    }
        if (MessageList.%Get(i).%Get("key")="确诊诊断")
        {
	    	d CaseInfoDict.%Set("DefiniteDiag",##class(web.CDSS.CMKB.FunLib).TransLinefeed(MessageList.%Get(i).%Get("value")))  //确诊诊断概述
	    }
        if (MessageList.%Get(i).%Get("key")="补充诊断")
        {
	    	d CaseInfoDict.%Set("SuppleDiag",##class(web.CDSS.CMKB.FunLib).TransLinefeed(MessageList.%Get(i).%Get("value"))) //补充诊断概述
	    }
        if (MessageList.%Get(i).%Get("key")="修正诊断")
        {
	    	d CaseInfoDict.%Set("CurrectionDiag",##class(web.CDSS.CMKB.FunLib).TransLinefeed(MessageList.%Get(i).%Get("value"))) //修正诊断概述   
	    }
	    //新增辅助检查信息解析 2021-12-03
	    if (MessageList.%Get(i).%Get("key")="辅助检查")
        {
	    	d CaseInfoDict.%Set("LabExamSum",##class(web.CDSS.CMKB.FunLib).TransLinefeed(MessageList.%Get(i).%Get("value"))) //修正诊断概述   
	    }
	    //新增出院诊断 2022-03-25
	    if (MessageList.%Get(i).%Get("key")="出院诊断")
	    {
			d CaseInfoDict.%Set("DischargeDiag",##class(web.CDSS.CMKB.FunLib).TransLinefeed(MessageList.%Get(i).%Get("value"))) 	//出院诊断概述     
		}
    }
    d CaseInfoC.%Push(CaseInfoDict)
    d CaseInfo.%Set("children",CaseInfoC)
    d children.%Push(CaseInfo)
    //s NLPSignInfo=##class(web.CDSS.MachineLearning.NLPProcessingData).GetStructedDataAPI(MessageList.%Get(i).%Get("value"))
    //s NLPSignInfo=[].%FromJSON(NLPSignInfo)
    if (CaseInfoDict.%Get("PhysicalExamSum")'="")
    {
        ///体征信息表
        s SignInfo={}  //体征信息
        d SignInfo.%Set("DataClass","SignInfo")
        s SignInfoC=[]  //体征信息详细内容
        s SignList=info.%Get("ProgressNoteList")  //体征信息列表，医院数据
        s SignInfoDict={}  //单个体征信息详细内容
        //s PhysicalExamSum=##class(web.CDSS.IMP.HospLinkRules).SplitPhysicalcheckToJson(CaseInfoDict.%Get("PhysicalExamSum"))
        s PhysicalExamSum=##class(web.CDSS.Demo.PatientInfoRenew).SignInfoToNLP(CaseInfoDict.%Get("PhysicalExamSum"))
        s PhysicalExamSum=[].%FromJSON(PhysicalExamSum)
        d SignInfoDict.%Set("BodyTemperature","")  // 体温
        d SignInfoDict.%Set("BloodPressure","")  // 血压
        d SignInfoDict.%Set("Pulse","")  // 脉搏
        d SignInfoDict.%Set("BreathFeature","")  // 呼吸
        d SignInfoDict.%Set("HeartRate","")  // 心率
        d SignInfoDict.%Set("Height","")  // 身高
        d SignInfoDict.%Set("Weight","")  // 体重
        for j=0:1:(PhysicalExamSum.%Size()-1)
        {
            s PSignInfo=PhysicalExamSum.%Get(j)
            if (PSignInfo.%Get("key")="体温")
            {
                d SignInfoDict.%Set("BodyTemperature",PSignInfo.%Get("value"))
            }
            if (PSignInfo.%Get("key")="脉搏")
            {
                d SignInfoDict.%Set("Pulse",PSignInfo.%Get("value"))
            }
            if (PSignInfo.%Get("key")="呼吸")
            {
                d SignInfoDict.%Set("BreathFeature",PSignInfo.%Get("value"))
            }
            if (PSignInfo.%Get("key")="血压")
            {
                d SignInfoDict.%Set("BloodPressure",PSignInfo.%Get("value"))
            }
            if (PSignInfo.%Get("key")="心率")
            {
                d SignInfoDict.%Set("HeartRate",PSignInfo.%Get("value"))
            }
            if (PSignInfo.%Get("key")="身高")
            {
                d SignInfoDict.%Set("Height",PSignInfo.%Get("value"))
            }
            if (PSignInfo.%Get("key")="体重")
            {
                d SignInfoDict.%Set("Weight",PSignInfo.%Get("value"))
            }
            if (PSignInfo.%Get("key")="收缩压")
            {
                d SignInfoDict.%Set("SystolicBlood",PSignInfo.%Get("value"))
            }
            if (PSignInfo.%Get("key")="舒张压")
            {
                d SignInfoDict.%Set("DiastolicBlood",PSignInfo.%Get("value"))
            }
            if (PSignInfo.%Get("key")="血氧饱和度")
            {
	            d SignInfoDict.%Set("OxygenSaturation",PSignInfo.%Get("value"))
	        }
        	if (PSignInfo.%Get("key")="口温")
            {
	            d SignInfoDict.%Set("OralTemperature",PSignInfo.%Get("value"))
	        }
	        if (PSignInfo.%Get("key")="肛温")
            {
	            d SignInfoDict.%Set("AnalTemperature",PSignInfo.%Get("value"))
	        }
        }
        d SignInfoDict.%Set("MeasureDate",$zdt($H,3))  // 测量时间
        //d SignInfoDict.%Set("BodyTemperature",NLPSignInfo.%Get(0).%Get("sign_value").%Get("name"))  // 体温
        //d SignInfoDict.%Set("BloodPressure",NLPSignInfo.%Get(3).%Get("sign_value").%Get("name"))  // 血压
        //d SignInfoDict.%Set("DiastolicBlood","")  // 舒张压
        //d SignInfoDict.%Set("SystolicBlood","")  // 收缩压
        //d SignInfoDict.%Set("Pulse",NLPSignInfo.%Get(1).%Get("sign_value").%Get("name"))  // 脉搏
        //d SignInfoDict.%Set("BreathFeature",NLPSignInfo.%Get(2).%Get("sign_value").%Get("name"))  // 呼吸
        //d SignInfoDict.%Set("HeartRate","")  // 心率
        //d SignInfoDict.%Set("OxygenSaturation","")  //血氧饱和度
        d SignInfoDict.%Set("Pupil","")  // 瞳孔
        d SignInfoDict.%Set("CornealReflex","")  // 角膜反射
        //d SignInfoDict.%Set("Height",NLPSignInfo.%Get(4).%Get("sign_value").%Get("name"))  //身高
        //d SignInfoDict.%Set("Weight",NLPSignInfo.%Get(5).%Get("sign_value").%Get("name"))  // 体重
        d SignInfoDict.%Set("PassFlag","")  //同步标记（0为同步，1为新增）
        d SignInfoC.%Push(SignInfoDict)
        d SignInfo.%Set("children",SignInfoC)
        d children.%Push(SignInfo)
    }
    
    if (CaseInfoDict.%Get("CurrentMedHisSum")'="") //现病史中的体征信息存体征信息表
    {
	    ///体征信息表
        s SignInfo={}  //体征信息
        d SignInfo.%Set("DataClass","SignInfo")
        s SignInfoC=[]  //体征信息详细内容
        s SignList=info.%Get("ProgressNoteList")  //体征信息列表，医院数据
        s SignInfoDict={}  //单个体征信息详细内容
        s CurrentMedHisSum=##class(web.CDSS.Demo.PatientInfoRenew).SignInfoToNLP(CaseInfoDict.%Get("CurrentMedHisSum"))
        s CurrentMedHisSum=[].%FromJSON(CurrentMedHisSum)
        d SignInfoDict.%Set("BodyTemperature","")  // 体温
        d SignInfoDict.%Set("BloodPressure","")  // 血压
        d SignInfoDict.%Set("Pulse","")  // 脉搏
        d SignInfoDict.%Set("BreathFeature","")  // 呼吸
        d SignInfoDict.%Set("HeartRate","")  // 心率
        d SignInfoDict.%Set("Height","")  // 身高
        d SignInfoDict.%Set("Weight","")  // 体重
        for j=0:1:(CurrentMedHisSum.%Size()-1)
        {
            s PSignInfo=CurrentMedHisSum.%Get(j)
            if (PSignInfo.%Get("key")="体温")
            {
                d SignInfoDict.%Set("BodyTemperature",PSignInfo.%Get("value"))
            }
            if (PSignInfo.%Get("key")="脉搏")
            {
                d SignInfoDict.%Set("Pulse",PSignInfo.%Get("value"))
            }
            if (PSignInfo.%Get("key")="呼吸")
            {
                d SignInfoDict.%Set("BreathFeature",PSignInfo.%Get("value"))
            }
            if (PSignInfo.%Get("key")="血压")
            {
                d SignInfoDict.%Set("BloodPressure",PSignInfo.%Get("value"))
            }
            if (PSignInfo.%Get("key")="心率")
            {
                d SignInfoDict.%Set("HeartRate",PSignInfo.%Get("value"))
            }
            if (PSignInfo.%Get("key")="身高")
            {
                d SignInfoDict.%Set("Height",PSignInfo.%Get("value"))
            }
            if (PSignInfo.%Get("key")="体重")
            {
                d SignInfoDict.%Set("Weight",PSignInfo.%Get("value"))
            }
            if (PSignInfo.%Get("key")="收缩压")
            {
                d SignInfoDict.%Set("SystolicBlood",PSignInfo.%Get("value"))
            }
            if (PSignInfo.%Get("key")="舒张压")
            {
                d SignInfoDict.%Set("DiastolicBlood",PSignInfo.%Get("value"))
            }
            if (PSignInfo.%Get("key")="血氧饱和度")
            {
	            d SignInfoDict.%Set("OxygenSaturation",PSignInfo.%Get("value"))
	        }
	        if (PSignInfo.%Get("key")="口温")
            {
	            d SignInfoDict.%Set("OralTemperature",PSignInfo.%Get("value"))
	        }
	        if (PSignInfo.%Get("key")="肛温")
            {
	            d SignInfoDict.%Set("AnalTemperature",PSignInfo.%Get("value"))
	        }
        }
        d SignInfoDict.%Set("MeasureDate",$zdt($H,3))  // 测量时间
        //d SignInfoDict.%Set("BodyTemperature",NLPSignInfo.%Get(0).%Get("sign_value").%Get("name"))  // 体温
        //d SignInfoDict.%Set("BloodPressure",NLPSignInfo.%Get(3).%Get("sign_value").%Get("name"))  // 血压
        //d SignInfoDict.%Set("DiastolicBlood","")  // 舒张压
        //d SignInfoDict.%Set("SystolicBlood","")  // 收缩压
        //d SignInfoDict.%Set("Pulse",NLPSignInfo.%Get(1).%Get("sign_value").%Get("name"))  // 脉搏
        //d SignInfoDict.%Set("BreathFeature",NLPSignInfo.%Get(2).%Get("sign_value").%Get("name"))  // 呼吸
        //d SignInfoDict.%Set("HeartRate","")  // 心率
        //d SignInfoDict.%Set("OxygenSaturation","")  //血氧饱和度
        d SignInfoDict.%Set("Pupil","")  // 瞳孔
        d SignInfoDict.%Set("CornealReflex","")  // 角膜反射
        //d SignInfoDict.%Set("Height",NLPSignInfo.%Get(4).%Get("sign_value").%Get("name"))  //身高
        //d SignInfoDict.%Set("Weight",NLPSignInfo.%Get(5).%Get("sign_value").%Get("name"))  // 体重
        d SignInfoDict.%Set("PassFlag","")  //同步标记（0为同步，1为新增）
        d SignInfoC.%Push(SignInfoDict)
        d SignInfo.%Set("children",SignInfoC)
        d children.%Push(SignInfo)   
	}
    
    s InpatientInfo={}  //其他在院医嘱信息
    d InpatientInfo.%Set("DataClass","InpatientInfo")
    s InpatientInfoC=[]  //详细内容
    s InpatientInfoDict={}  //单个详细内容
    d InpatientInfoDict.%Set("MRTempletName",CaseList.%Get("ProgressTempleateID")) //病例模板
    d InpatientInfoDict.%Set("MRNum","")  //病历顺序
    d InpatientInfoDict.%Set("MRClass",..ConvertProgress(CaseList.%Get("ProgressType"))) //病历类型
    d InpatientInfoDict.%Set("MRFileNum","") //病历文件顺序
    d InpatientInfoDict.%Set("MRCode",MRCode) //病历编码
    d InpatientInfoDict.%Set("MRDesc",CaseList.%Get("Message")) //病历概述
    d InpatientInfoDict.%Set("UpdateDate",CaseList.%Get("RecordTime")) //更新时间
    d InpatientInfoDict.%Set("UpdateRemarks","") //更新说明
    d InpatientInfoC.%Push(InpatientInfoDict)
    d InpatientInfo.%Set("children",InpatientInfoC)
    d children.%Push(InpatientInfo)
    d CaseJson.%Set("children",children)
    s config=##class(web.DHCBL.MKB.MKBConfig).GetConfigValue("CDSScdl2020061601")
    s RationalResult=##Class(web.CDSS.MachineLearning.DataVerification).DataRationalisation(CaseJson.%ToJSON())  //对第三方数据json串进行数据合理性校验，包括（数据类型是否匹配，主键是否存在等）
    s RationalResult=[].%FromJSON(RationalResult)
    s UnifomResult=##Class(web.CDSS.MachineLearning.DataVerification).DataConsistency(CaseJson.%ToJSON())  //对第三方数据json串进行基本信息、就诊信息数据一致性和临床信息完整性校验
    s UnifomResult=[].%FromJSON(UnifomResult)
    s ^TMPSXW(1)=CaseJson.%ToJSON()
    s CaseJson=..GetStructedDataJson(CaseJson.%ToJSON())
    s CaseJson=[].%FromJSON(CaseJson)
    s TableArr=["ChiefCompInfo","CurrentMedHistory","PastDiagnosis","FamilyHisInfo","PersonalInfo","MarryInfo","MarryInfo","AllergyHistory","PhysicalExam","SpecExam"]
    for i=0:1:(CaseJson.%Size()-1)
    {
	    s PatientJson=CaseJson.%Get(i)
	    s PatientIterator=PatientJson.%GetIterator()
        while PatientIterator.%GetNext(.key,.value)
        {
	        if key="DataClass"
	        {
		        continue:PatientJson.%Get("DataClass")=""
                continue:'(TableArr.%IsDefined(ChildrenArray.%Get("DataClass")))
	        }
            if key="children"    //如果键值对中的键为"children"
            {
                s ChildrenArray=PatientJson.%Get("children")       //包含表名的children
	    		for j=0:1:(ChildrenArray.%Size()-1)
                {
	                s TalbeJson=ChildrenArray.%Get(j)
	    			s TalbleIterator=TalbeJson.%GetIterator()
	                while TalbleIterator.%GetNext(.key1,.value1)
			        {
				        if key1="DataClass"
				        {
					        continue:value1=""
			                continue:'(TableArr.%IsDefined(value))
				        }
			        }
	                d CaseJson.%Get(i).%Get("children").%Get(j).%Get("children").%Get(0).%Set("MRCode",MRCode)
	                //w CaseJson.%Get(i).%Get("children").%Get(j).%Get("children").%Get(0).%ToJSON(),!
                }
            }
        }
    }
    s CaseJson=CaseJson.%ToJSON()
    
    
    if (RationalResult.%Size()=0)&(UnifomResult.%Size()=0)  //如果没有错误信息
    {
        q CaseJson
    }
    elseif(config="Y")  //有错误信息，但是允许强制交互
    {
        q CaseJson
    }
    else  //有错误信息，不允许强制交互
    {
        for i=0:1:UnifomResult.%Size()-1
        {
            d RationalResult.%Push(UnifomResult.%Get(i))
        } 
        q RationalResult.%ToJSON()  
    }
}

/// Creator:陈代雷
/// CreatDate:2020-07-15
/// Description:性别数字转换成文字描述
/// Table:
/// Input: SexCode:性别代码
/// Return:
/// Others:w ##class(web.CDSS.MachineLearning.InteractiveInterface).ConvertSex(1)
ClassMethod ConvertSex(SexCode As %String) As %String
{
    s sex=$CASE(SexCode,0:"女",1:"男",2:"其他",:"其他")
    q sex
}

/// Creator:陈代雷
/// CreatDate:2020-07-16
/// Description:就诊类型编码转换成数字
/// Table:
/// Input: VisitTypeCode:就诊类型代码
/// Return:
/// Others:w ##class(web.CDSS.MachineLearning.InteractiveInterface).ConvertVisitType(1)
ClassMethod ConvertVisitType(VisitTypeCode As %String) As %String
{
    s VisitType=$CASE(VisitTypeCode,1:"急诊",2:"门诊",3:"住院",:"")
    q VisitType
}

/// Creator:lideyuan
/// CreatDate:2020-05-13
/// Description：把非结构化数据通过调用nlp服务器接口，转化为结构化数据
/// Input：data: json格式数据，key:data,value:要结构化的内容
/// Output: 结构化结果json字符串
/// w ##class(web.CDSS.MachineLearning.NLPProcessingData).GetPythonDataAPI("http://192.144.152.252:8080/DiseaseWarning?PatientUserInfo=%E7%A5%9E%E7%BB%8F%E7%97%9B%5E%E7%A5%9E%E7%BB%8F%E7%97%9B%5E1%5E%E9%97%A8%E8%AF%8A%5E13938%5E%E8%8C%83%E6%96%87%E5%87%AF%5E111%5E%E7%A5%9E%E7%BB%8F%E5%86%85%E7%A7%91%E9%97%A8%E8%AF%8A%5E1&_=1629212307745")
ClassMethod GetPythonDataAPI(InputStr As %String) As %String
{
	set httpRequest = ##class(%Net.HttpRequest).%New()
 	//s Url="http://111.205.6.207:1223/tag"
 	//s Url=##class(web.DHCBL.MKB.MKBConfig).GetConfigValue("CDSSldy2020070701")
    Do httpRequest.SetHeader("Content-Type","application/json")
    //Accept-Language: zh-CN,zh;q=0.9
    //Accept:application/json;charset=UTF-8
    //do httpRequest.InsertFormData("data", content)
    set status = httpRequest.Post(InputStr)
    If $$$ISERR(status) { Quit $system.OBJ.DisplayError(status) }
    //s stream=##class(%Stream.GlobalCharacter).%New()
    s stream=##class(%Stream.GlobalCharacter).%New() //创建流
    
    s stream= httpRequest.HttpResponse.Data
    Set responseString =""
    while 'stream.AtEnd
    {
	    s responseString=responseString_stream.ReadLine()
	}
    Quit responseString
}

/// Creator:lideyuan
/// CreatDate:2020-05-13
/// Description：把非结构化数据通过调用nlp服务器接口，转化为结构化数据
/// Input：data: json格式数据，key:data,value:要结构化的内容
/// Output: 结构化结果json字符串
/// w ##class(web.CDSS.Demo.PatientInfoRenew).GetStructedDataAPI("周期性下腹痛11月，加重并扪及腹部硬块6月")
/// w ##class(web.CDSS.Demo.PatientInfoRenew).GetStructedDataAPI("心悸一年半，游走性关节疼痛")
/// w ##class(web.CDSS.Demo.PatientInfoRenew).GetStructedDataAPI("反复腹痛明显")
ClassMethod GetStructedDataAPI(content As %String) As %String
{
	s content=$zstrip(content,"<>W")
	q:content="" "[]"
	set httpRequest = ##class(%Net.HttpRequest).%New()
 	//s Url="http://111.205.6.207:1223/tag"
 	//s Url="http://49.7.67.45:8082/tag" //迁移后的地址
 	s Url=##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSSldy2020070701")
 	if Url["https" //标版NLP用的https，腾讯云电信云用NLP外网是http
 	{
	 	s httpRequest.SSLConfiguration="SSLECP"
 		s httpRequest.SSLCheckServerIdentity=0	
	}
    Do httpRequest.SetHeader("Content-Type","application/x-www-form-urlencoded; charset=utf8")
    do httpRequest.InsertFormData("data", content)
    //超时时间
    s httpRequest.Timeout=1.5
    //set status = httpRequest.Post(Url)
    set status = httpRequest.Get(Url)
    If $$$ISERR(status) 
    {   //Quit $system.OBJ.DisplayError(status)
    	q "[]"
    }
    //s stream=##class(%Stream.GlobalCharacter).%New()
    s stream=##class(%Stream.GlobalCharacter).%New()	//创建流
    s stream= httpRequest.HttpResponse.Data
    Set responseString =""
    while 'stream.AtEnd
    {
	    s responseString=responseString_stream.ReadLine()
	}
    Quit responseString
}

/// Creator:lideyuan
/// CreatDate:2020-05-13
/// Description：把患者信息json中
/// Input：
/// Output: 
/// w ##class(web.CDSS.MachineLearning.NLPProcessingData).GetStructedDataJson(^TMPSXW(1))
ClassMethod GetStructedDataJson(PatientInfo As %String)
{
	s:PatientInfo["GXPCS07" ^TMP("FWKNLP")=PatientInfo
	kill ^TEMP("PyhsicalExamSum")
	s ^TEMP("PyhsicalExamSum")=0
 	if $e(PatientInfo,1,1)'="["     //如果入参外层不是列表，就加一层列表
 	{
 		s PatientInfo="["_PatientInfo_"]"
    }
  	s PatientArray=[].%FromJSON(PatientInfo)
	//s PatientArray=[{"IDNO":"DH001","PatientDR":"te001","VisitID":"1","children":[{"DataClass":"PatientMaster","children":[{"MedicareCardNum":"620","IDCardNumber":"620503199901017676","Sex":"女","Name":"测试患者","PhoneNumber":"1234567890"}]},{"DataClass":"InpatientInfo","children":[{"MRNum":"","MRClass":"","MRFileNum":"","MRCode":"","MRDesc":"姓名：张三  出生地：临沂市 性别：女 职业：工人 年龄：28岁  入院日期：2016-11-26 08:49:30 民族：汉族   记录日期：2016-11-26 15:13:04 婚姻：已婚         病史陈述人：患者本人 主诉：多饮、多尿、体重增加20天，发现血糖高4天。 现病史：患者20天前无明显诱因出现多饮、多尿，夜尿4-5次，伴体重增加，约6斤，伴面部及腹部明显增胖、淡红色条纹，且面部及躯干出现较多，伴手抖、心慌，伴有全身乏力、视线模糊，伴双下肢、左膝关节、左髋关节及腰背疼、手足麻木、手脚抽筋及月经量减少，无咳嗽、咳痰，无发热，无胸闷、憋喘，无恶心、呕吐、无腰痛、腹泻，无头晕、头痛，无长期服药史，未治疗，4天前出现咳嗽、咳痰，无发热，于当地医院静滴抗感染药物（具体不详）治疗后好转，4天前于当地查血糖高，空腹血糖21mol/L，后复查空腹血糖18mol/L，自行饮食控制。2天前于当地医院住院检查，行双侧肾上腺CT平扫及胸部CT平扫示，余未见异常，垂体MRI未见异常，性腺六项：雌二醇：5.46pg/ml，睾酮：0.025nmol/l，孕酮：0.3ng/ml，泌乳素579.30umol/L，促黄体生成素6.0mIu/ml，促卵泡生成素：5.77mIu/ml，未治疗。今为系统诊疗入院。 患者自发病以来，神志清，精神可，饮食可，睡眠较差，小便次数增多，夜尿4-5次，大便干结，体重增加6斤。既往史：平素健康状况良好。否认高血压病史。否认糖尿病病史。否认冠心病病史。否认慢性支气管炎病史。否认胆结石病史。否认胆囊炎病史。否认传染病史。预防接种史按规定。否认手术外伤史。否认输血史。否认食物史。个人史：出生于原籍，生长于原籍。否认吸烟史；否认饮酒史。否认药物嗜好。否认疫水疫区接触史。无工业毒物、粉尘、放射性物质接触史。无夜游史。月经史：14 2-3/40 2016.10.28。经量少，经期规则，无痛经。婚育史：已婚，未育。家族史：父母婚配；非近亲；家族中否认类似患者。否认家族遗传性病史。体格检查：T37.3℃    P118次/分     R18次/分    WT69kg   BP117/83mmHg    H160cm一般情况尚可，神志清，营养中等，发育正常，体检合作，对答切题，全身皮肤、巩膜无黄染、皮疹及出血点，头颅、五官正常，双瞳孔大小、形态对称，对光反射存在，双眼球活动正常，耳廓正常，外耳道无分泌物，口腔黏膜正常，伸舌居中，咽部、扁桃体无充血，颈软，未见怒张静脉，气管居中，甲状腺不大，胸廓对称，无压痛、红肿，触诊语颤正常，叩诊清音，双肺呼吸音清，未闻及干、湿性啰音及胸膜摩擦音。心前区搏动正常，有力，心脏浊音界不大，心率114次/分，律齐，个瓣膜听诊区未闻及杂音，腹平软，无压痛，未见曲张静脉，肝、脾肋骨下未扪及肿大，未扪及异常腹部包块，肝、肾区无叩击痛，移动性浊音<->，肠鸣音正常。肛门及外生殖器正常，脊柱及四肢无畸形，活动正常，双下肢无水肿。生理性反射存在，未引出病理性反射。专科检查：意识障碍，呼之无反应，瞬目反射正常。全身多处均见有创面，头部创面浅Ⅱ°改变，面积3%。双小腿下段、双足创面呈黄褐素皮革样改变，可见树枝状，创面呈Ⅲ°改变，面积约13%；余创面呈红白相间，部分见深Ⅱ°改变，面积82%。辅助检查：CT寰枢椎、胸腹未见外伤性改变。止凝血功能及D-二聚体正常：Hs-CRP 2.45mg/L；生化：GLU 7.87mmol/L；血常规：WBC 10.8*10~9/L,NE% 80.30%。余查血未见异常。初步诊断：中医 气滞血瘀西医：1.重型颅脑损伤 3.脑干损伤？4.肺挫伤医师签名：李鹏飞日期：2016-11-26","UpdateDate":"","UpdateRemarks":""}]},{"DataClass":"ExamInfo","children":[{"GroupFlag":"","GroupSequence":"","ExamCode":"","ExamName":"","ExamResultNum":"","ExamResult":"","ExamResultFlag":"","ExamResultDesc":"","PartDR":"","ExecuteTime":"","ReportTime":"","Remarks":"","PassFlag":""},{"GroupFlag":"","GroupSequence":"","ExamCode":"","ExamName":"","ExamResultNum":"","ExamResult":"","ExamResultFlag":"","ExamResultDesc":"","PartDR":"","ExecuteTime":"","ReportTime":"","Remarks":"","PassFlag":""}]},{"DataClass":"PatientVisit","children":[{"VisitType":"门诊","TreatmentTime":"2020-04-29 17:15:30","MarryHisSum":"已婚，育有1子1女","PastDiagnosisSum":"既往体健,晚期肝癌(病危)，否认“高血压、冠心病、糖尿病”病史,预防接种史不详；否认外伤史；无手术史；无输血史，无药物、食物过敏史","FamilyHisSum":"父母已故,兄弟姐妹健在,有糖尿病家族史","PersonalHisSum":"久居本地，无疫区、疫情接触史","MenstrualHisSum":"月经初潮13岁","AllergyHisSum":"对药物慢性高度过敏，如青霉素，红霉素，环丙沙星，先锋，感冒药等，常见药物都有过敏反应，对粉尘过敏，对毛发过敏，阑尾炎有发炎的症状","PhysicalExamSum":"T：37.2℃ P:98次/分 R：20次/分 BP：120/80mmHg 一般状况：发育正常；体型匀称，呈正力型；营养良好；意识清楚，查体合作；急性 病容，表情痛苦；强迫左侧卧位，右手按压左侧胸部；步态无异常,皮肤粘膜色泽正<br/>常，无发红、苍白、发绀、黄染、色素沉着、色素脱失；皮肤湿润，弹性好；未见皮疹及皮肤脱屑；无皮下出血、蜘蛛痣、水肿、皮下结节，无溃疡、糜烂及瘢痕；毛发<br/>的性状及分布无异常。左侧颌下触及2个约1.2*1.0cm肿大淋巴结，表面光滑，活动、轻度压痛，边界清晰，局部皮肤无红肿、瘢痕、瘘管。余部浅表淋巴结未触及肿大。<br/><br/>头部：外形正常，头发黑色，分布均匀；无异常活动。视力正常；眉毛分布均匀；眼<br/>睑无水肿、无上睑下垂；上下泪点无红肿、无异常分泌物；睑结膜轻度充血，未见出<br/>血点；巩膜轻度黄染；角膜透明，未见溃疡；瞳孔双侧等大等圆，直径3mm，瞳孔<br/>直接对光反射存在；瞳孔间接对光反射存在；集合反射正常；双侧眼球突出，Stellwag征、Graefe征、Mobius征和Joffroy征阳性；眼球运动正常，无眼球震颤","SpecExamSum":"步态、肌力（0～5级）、肌营养状态、肌张力、共济运动[指鼻试验、运动轮替试验、跟膝胫试验、罗姆伯格（Romberg）征]、不自主运动"}]}]}]
	s ResultArray=[].%FromJSON(PatientArray.%ToJSON())
	k RecordInserted   //用来记录新增了哪些数据，在病历nlp处理的时候可以用来比较
	for i=0:1:PatientArray.%Size()-1   //遍历第一层列表
	{
		s PatientJson=PatientArray.%Get(i)
		s ResultJson=ResultArray.%Get(i)
		k key
		k value
		s IDNO=PatientJson.%Get("IDNO")
		s VisitID=PatientJson.%Get("VisitID")
		s PatientDR=PatientJson.%Get("PatientDR")
		s PatientIterator=PatientJson.%GetIterator()     //遍历第一层{}
		while PatientIterator.%GetNext(.key,.value)
		{
			if key="children"    //如果键值对中的键为"children"
			{
				s ChildrenArray=PatientJson.%Get("children")       //包含表名的children
				s ChildrenResultArray=ResultJson.%Get("children")
				for j=0:1:(ChildrenArray.%Size()-1)
				{ 
					s ChildrenJson=ChildrenArray.%Get(j)
					s TableName="WDT.CDSS."_ChildrenJson.%Get("DataClass")   //字段所属表名
					if TableName="WDT.CDSS.PatientVisit"    //如果为就诊信息表
					{
						s GrandChildrenArray=ChildrenJson.%Get("children")
						for k=0:1:GrandChildrenArray.%Size()-1      //遍历children的每一个键值对
						{
							s GrandChildren=GrandChildrenArray.%Get(k)
							k fieldkey
							k fieldvalue    //清空数据，以防数据窜值
							s FieldNameIterator=GrandChildren.%GetIterator()
							while FieldNameIterator.%GetNext(.fieldkey,.fieldvalue)    //遍历当前键值对的key value
							{
								if (fieldkey="ChiefCompSum")  //如果该字段为主诉概述 
								{
									s StructedSymptomString=..GetStructedDataAPI(fieldvalue)   //通过NLP处理非结构化数据
									//d ..ProcessingNLPSymptomsString(StructedSymptomString,fieldkey,.ChildrenResultArray,.RecordInserted)  //把结构化的数据填充主诉json
									d ..CollectChiefToNLP(StructedSymptomString,fieldkey,.ChildrenResultArray,.RecordInserted) //把结构化的数据填充主诉json
									//d ChildrenResultArray.%Push(AddSymptom)   //把填充好的主诉json加入到患者信息json中
								}
								if (fieldkey="CurrentMedHisSum")  //或现病史概述
								{
									s StructedSymtomCurMedString=..GetStructedDataAPI(fieldvalue)   //通过NLP处理非结构化数据
									//d ..ProcessingNLPSymptomsString(StructedSymptomString,fieldkey,.ChildrenResultArray,.RecordInserted)  //把结构化的数据填充现病史json
									d ..CollectCurrentMedToNlp(StructedSymtomCurMedString,fieldkey,.ChildrenResultArray,.RecordInserted) //把结构化的数据填充现病史json
									//d ChildrenResultArray.%Push(AddSymptom)   //把填充好的主诉json加入到患者信息json中
									
									//现病史中的体征存体格检查表（有数值：体温:39℃，无数值：闭目难立征阳性，都存）wz20221013
									d ..ProcessingNLPPhysicalDiagString(StructedSymtomCurMedString,fieldkey,.ChildrenResultArray,.RecordInserted)  //把结构化的数据填充体格检查json
									
									if (StructedSymtomCurMedString'="[]")&&(StructedSymtomCurMedString'["error")
									{
										//现病史中的月经婚育史信息存婚育史表（黄体期，排卵期等）wz2020221101
										d ..ProcessingNLPMarriageDiagString(StructedSymtomCurMedString,"MenstrualHisSum",.ChildrenResultArray,.RecordInserted)  //把结构化的数据填充婚育史json
									}
								}
								if (fieldkey="PastDiagnosisSum")   //如果该字段为既往史概述
								{
									s StructedPastDiagnosisString=..GetStructedDataAPI(fieldvalue)   //通过NLP处理非结构化数据
									d ..ProcessingNLPPastDiagString(StructedPastDiagnosisString,fieldkey,.ChildrenResultArray,.RecordInserted)  //把结构化的数据填充既往史json
									
									if (StructedPastDiagnosisString'="[]")&&(StructedPastDiagnosisString'["error")
									{
										//既往史过敏原存过敏史表中 wz(20220411，深圳中医) 
										d ..ProcessingNLPAllergyDiagString(StructedPastDiagnosisString,fieldkey,.ChildrenResultArray,.RecordInserted,PatientDR) //把结构化的数据填充过敏史json
										//d ChildrenResultArray.%Push(AddStructedPastDiagnosisString)   //把填充好的主诉json加入到患者信息json中
									}
								}
								if (fieldkey="FamilyHisSum")   //如果该字段为家族史概述
								{
									s StructedFamilyDiagnosisString=..GetStructedDataAPI(fieldvalue)   //通过NLP处理非结构化数据
									d ..ProcessingNLPFamilyDiagString(StructedFamilyDiagnosisString,fieldkey,.ChildrenResultArray,.RecordInserted)  //把结构化的数据填充家族史json
									//d ChildrenResultArray.%Push(AddStructedFamilyDiagnosisString)   //把填充好的主诉json加入到患者信息json中
								}
								if (fieldkey="PersonalHisSum")   //个人史概述
								{
									s StructedPersonDiagnosisString=..GetStructedDataAPI(fieldvalue)   //通过NLP处理非结构化数据
									d ..ProcessingNLPPersonalDiagString(StructedPersonDiagnosisString,fieldkey,.ChildrenResultArray,.RecordInserted)  //把结构化的数据填充个人史json
									//d ChildrenResultArray.%Push(AddStructedPersonDiagnosisString)   //把填充好的主诉json加入到患者信息json中
								}
								if (fieldkey="MarryHisSum")||(fieldkey="MenstrualHisSum")   //婚育史\月经史概述
								{
									s StructedMarriageDiagnosisString=..GetStructedDataAPI(fieldvalue)   //通过NLP处理非结构化数据
									d ..ProcessingNLPMarriageDiagString(StructedMarriageDiagnosisString,fieldkey,.ChildrenResultArray,.RecordInserted)  //把结构化的数据填充月经史json
									//d ChildrenResultArray.%Push(AddStructedMarriageDiagnosisString)   //把填充好的主诉json加入到患者信息json中
								}
								
								
								if (fieldkey="AllergyHisSum") //过敏史概述
								{
									s StructedAllergyDiagnosisString=..GetStructedDataAPI(fieldvalue)   //通过NLP处理非结构化数据
									d ..ProcessingNLPAllergyDiagString(StructedAllergyDiagnosisString,fieldkey,.ChildrenResultArray,.RecordInserted,PatientDR)  //把结构化的数据填充过敏史json
									//d ChildrenResultArray.%Push(AddStructedAllergyDiagnosisString)   //把填充好的主诉json加入到患者信息json中
								}
								
								if (fieldkey="PhysicalExamSum")    //体格检查概述
								{
									s StructedPhysicalDiagnosisString=..GetStructedDataAPI(fieldvalue)   //通过NLP处理非结构化数据
									d ..ProcessingNLPPhysicalDiagString(StructedPhysicalDiagnosisString,fieldkey,.ChildrenResultArray,.RecordInserted)  //把结构化的数据填充体格检查json
									//d ChildrenResultArray.%Push(AddStructedPhysicalDiagnosisString)   //把填充好的主诉json加入到患者信息json中
								}
							
 //								if (fieldkey="SpecExamSum")   //专科检查概述
 //								{
 //									s StructedSpecDiagnosisString=..GetStructedDataAPI(fieldvalue)   //通过NLP处理非结构化数据
 //									s AddStructedSpecDiagnosisString =..ProcessingNLPSpecDiagString(StructedSpecDiagnosisString,fieldkey)  //把结构化的数据填充专科检查json
 //									d ChildrenResultArray.%Push(AddStructedSpecDiagnosisString)   //把填充好的主诉json加入到患者信息json中
 //								}
                                ///初步诊断，确诊诊断，补充诊断，修正诊断-20211021 出院记录的出院诊断-20220325  wuzhe
                                if ((fieldkey="PrimaryDiag")||(fieldkey="DefiniteDiag")||(fieldkey="SuppleDiag")||(fieldkey="CurrectionDiag")||(fieldkey="DischargeDiag"))
                                {
	                                continue:fieldvalue=""
	                                s StructedPhysicalDiagnosisString=..GetStructedDataAPI(fieldvalue)   //通过NLP处理非结构化数据
									//d ..DiagInfoPassNLP(StructedPhysicalDiagnosisString,fieldkey,.ChildrenResultArray,.RecordInserted,IDNO,PatientInfo)  //把结构化的数据填充主诉json
									d ..DiagInfoPassNLPNew(StructedPhysicalDiagnosisString,fieldkey,.ChildrenResultArray,.RecordInserted,IDNO,PatientInfo,fieldkey)
	                            }
	                            //辅助检查 20211203 fanwenkai&wuzhe
	                            if (fieldkey="LabExamSum")
	                            {
		                            //continue:fieldvalue=""
	                                s StructedPhysicalDiagnosisString=..GetStructedDataAPI(fieldvalue)   //通过NLP处理非结构化数据
	                                try
	                                {
										d ..AssistExamPassNLP(StructedPhysicalDiagnosisString,fieldkey,.ChildrenResultArray,.RecordInserted,IDNO,fieldvalue)
	                                }catch e
	                                {
		                                
		                            }
		                        }
							}
						}
					}
					if TableName="WDT.CDSS.ExamInfo"    //如果为检查信息表
					{
					}
					/*if TableName="WDT.CDSS.InpatientInfo"   //如果为病历信息表
					{
						s GrandChildrenArray=ChildrenJson.%Get("children")
						for i=0:1:GrandChildrenArray.%Size()-1      //遍历children的每一个键值对
						{
							s GrandChildren=GrandChildrenArray.%Get(i)
							
							k fieldkey
							k fieldvalue    //清空数据，以防数据窜值
							
							s FieldNameIterator=GrandChildren.%GetIterator()
							while FieldNameIterator.%GetNext(.fieldkey,.fieldvalue)    //遍历当前键值对的key value
							{
								if fieldkey="MRDesc"
								{
									continue:fieldvalue=""
									s InpatientInfoString=..GetStructedDataAPI(fieldvalue)   //通过NLP处理非结构化数据 
									d ..ProcessingNLPInpatientInfoString(InpatientInfoString,.ChildrenResultArray,.RecordInserted)  //把结构化的数据填充主诉json
									//d ChildrenResultArray.%Push(AddInpatientInfoString)   //把填充好的主诉json加入到患者信息json中
								}
							}
						}	
					}*/
				}
			}
		}
	}
	s Result= ResultArray.%ToJSON()
	q Result
	///q ..ValueNormalization(Result)  ///过同义词字典对照
}

/// Creator:lideyuan
/// CreatDate:2020-05-14
/// Description：通过就诊信息表中的概述字段名 获取对应的User表名称
/// Input：概述字段名
/// Output: 该概述字段对应的User表名
/// w ##class(web.CDSS.MachineLearning.NLPProcessingData).GetMappingUser()
ClassMethod GetMappingUser(FieldName As %String)
{
	 q:FieldName="" ""
	 //新加 20211203 wuzhe
	 //s Mapping("Lis")="LabInfo" 
	 //新加 20210819 wuzhe
	 s Mapping("LabExamInfo")="LabExamInfo"   //辅助检验检查（非结构化表）
	 // 新增 20211021 wuzhe 诊断信息表
	 s Mapping("PrimaryDiag")="DiagnosisInfo"
	 s Mapping("DefiniteDiag")="DiagnosisInfo"	
	 s Mapping("SuppleDiag")="DiagnosisInfo"
	 s Mapping("CurrectionDiag")="DiagnosisInfo"
	 // 20220325 出院记录出院诊断 wuzhe
	 s Mapping("DischargeDiag")="DiagnosisInfo"
	 
	 s Mapping("ChiefCompSum")="ChiefCompInfo"   //主诉
	 s Mapping("CurrentMedHisSum")="CurrentMedHistory"   //现病史
	 s Mapping("PastDiagnosisSum")="PastDiagnosis"   //既往史
	 s Mapping("FamilyHisSum")="FamilyHisInfo"  //家族史
	 s Mapping("PersonalHisSum")="PersonalInfo"  //个人史
	 s Mapping("MarryHisSum")="MarryInfo"  //婚育史
	 s Mapping("MenstrualHisSum")="MarryInfo"  //月经史写入婚育史
	 s Mapping("AllergyHisSum")="AllergyHistory" //过敏史
	 s Mapping("PhysicalExamSum")="PhysicalExam" //体格检查
	 s Mapping("SpecExamSum")="SpecExam"   //专科检查
	 s Mapping("婚育史")="MarryInfo"
	 s Mapping("现病史")="CurrentMedHistory"
	 s Mapping("过敏史")="AllergyHistory"
	 s Mapping("月经史")="MarryInfo"
	 s Mapping("家族史")="FamilyHisInfo"
	 s Mapping("既往史")="PastDiagnosis"
	 s Mapping("个人史")="PersonalInfo"
	 s Mapping("体格检查")="PhysicalExam"
	 s Mapping("主诉")="ChiefCompInfo"
	 s Mapping("药物")="CarryDrug"
	 if $d(Mapping(FieldName))
	 {
	 	q Mapping(FieldName)
	 }
	 else
	 {
		 q ""
	 }
}

/// Creator:lideyuan
/// CreatDate:2020-05-14
/// Description：把NLP API中返回的症状的json结果处理一下
/// Input：nlp json返回的字符串
/// Output: json
/// w ##class(web.CDSS.MachineLearning.NLPProcessingData).ProcessingNLPSymptomsString()
ClassMethod ProcessingNLPSymptomsString(NLPString As %String, FieldName As %String, ByRef ChildrenResultArray, ByRef RecordInserted)
{
	if NLPString="[]"
	{
		s SymptomJson={}
		s DataClass=..GetMappingUser(FieldName)
		d SymptomJson.%Set("DataClass",DataClass)
		s Children=[]
		s ChildItem={}
		d ChildItem.%Set("SymptomNum","")
		d ChildItem.%Set("PartDR","")
		d ChildItem.%Set("Symptom","空")
		d ChildItem.%Set("Duration","")
		d ChildItem.%Set("AbnormalMax","")
		d ChildItem.%Set("AbnormalMin","")
		d ChildItem.%Set("NormalMax","")
		d ChildItem.%Set("NormalMin","")
		d ChildItem.%Set("RangeUnit","")
		d ChildItem.%Set("RangeType","")
		d ChildItem.%Set("Cause","")
		d ChildItem.%Set("SymptomResult","")
		d Children.%Push(ChildItem)
		d SymptomJson.%Set("children",Children)
		d ChildrenResultArray.%Push(SymptomJson)
		q ""
	}
	s NLPArray=[].%FromJSON(NLPString)
	for i=0:1:NLPArray.%Size()-1
	{
		//s SymptomJson={}
		//s Children=[]
		s DataClass=..GetMappingUser(FieldName)
		continue:DataClass=""
		//d SymptomJson.%Set("DataClass",..GetMappingUser(FieldName))
		s ItemJson=NLPArray.%Get(i)
		s IsPositiveFlag=ItemJson.%Get("type")
		if (IsPositiveFlag["+")||(IsPositiveFlag["-")
		{
			s IsPositive=$e(ItemJson.%Get("type"),1,1)   //用来取阴性和阳性
			s IsPositive=$case(IsPositive,"+":"阳性","-":"阴性")
		}
		else
		{
			s IsPositive="阳性"
		}
		continue:IsPositive="阴性"
		if ItemJson.%IsDefined("position")    //如果存在部位的信息则取值
		{
			s Part=ItemJson.%Get("position").%Get("name")   //部位
		}
		else    //如果不存在部位信息，则要赋值为空
		{ 
			s Part=""
		}
		s Name=ItemJson.%Get("name")   //获取症状名称
		s NameFlag=0
		s NameFlag=..ExistSymptom(Name)
		s OutcomePreFlag=0
		s OutcomeSubFlag=0
		if ItemJson.%IsDefined("outcome")
		{
			s Outcome=ItemJson.%Get("outcome").%Get("name")
			s OutcomePreName=Name_Outcome
			
			s OutcomePreFlag=..ExistSymptom(OutcomePreName)
			s OutcomeSubName=Outcome_Name
			
			s OutcomeSubFlag=..ExistSymptom(OutcomeSubName)
		}
		

	
		k UserName
		s UserName=..GetMappingUser(FieldName)
		s RecordInserted(UserName,Name)=""
		if ItemJson.%IsDefined("last_time")
		{
			s Duration=ItemJson.%Get("last_time").%Get("name")  //获取持续时长
		}
		else
		{
			s Duration=""
		}
		
		if NameFlag="1"
		{
			s SymptomJson={}
			s Children=[]
			d SymptomJson.%Set("DataClass",..GetMappingUser(FieldName))
			s ChildItem={}
			d ChildItem.%Set("SymptomNum","")
			d ChildItem.%Set("PartDR",Part)
			d ChildItem.%Set("Symptom",Name)
			d ChildItem.%Set("Duration",Duration)
			d ChildItem.%Set("AbnormalMax","")
			d ChildItem.%Set("AbnormalMin","")
			d ChildItem.%Set("NormalMax","")
			d ChildItem.%Set("NormalMin","")
			d ChildItem.%Set("RangeUnit","")
			d ChildItem.%Set("RangeType","")
			d ChildItem.%Set("Cause","")
			d ChildItem.%Set("SymptomResult",IsPositive)
			if FieldName="CurrentMedHisSum"
			{
				d ChildItem.%Set("Status","")	
			}
			//w ChildItem.%ToJSON(),!
			d Children.%Push(ChildItem)
			d SymptomJson.%Set("children",Children)
			d ChildrenResultArray.%Push(SymptomJson)
		}
		if OutcomePreFlag="1"
		{
			s SymptomJson={}
			s Children=[]
			d SymptomJson.%Set("DataClass",..GetMappingUser(FieldName))
			s ChildItem={}
			d ChildItem.%Set("SymptomNum","")
			d ChildItem.%Set("PartDR",Part)
			d ChildItem.%Set("Symptom",OutcomePreName)
			d ChildItem.%Set("Duration",Duration)
			d ChildItem.%Set("AbnormalMax","")
			d ChildItem.%Set("AbnormalMin","")
			d ChildItem.%Set("NormalMax","")
			d ChildItem.%Set("NormalMin","")
			d ChildItem.%Set("RangeUnit","")
			d ChildItem.%Set("RangeType","")
			d ChildItem.%Set("Cause","")
			d ChildItem.%Set("SymptomResult",IsPositive)
			if FieldName="CurrentMedHisSum"
			{
				d ChildItem.%Set("Status","")	
			}
			d Children.%Push(ChildItem)
			d SymptomJson.%Set("children",Children)
			d ChildrenResultArray.%Push(SymptomJson)
		}
		
		if OutcomeSubFlag="1"
		{
			s SymptomJson={}
			s Children=[]
			d SymptomJson.%Set("DataClass",..GetMappingUser(FieldName))
			s ChildItem={}
			d ChildItem.%Set("SymptomNum","")
			d ChildItem.%Set("PartDR",Part)
			d ChildItem.%Set("Symptom",OutcomeSubName)
			d ChildItem.%Set("Duration",Duration)
			d ChildItem.%Set("AbnormalMax","")
			d ChildItem.%Set("AbnormalMin","")
			d ChildItem.%Set("NormalMax","")
			d ChildItem.%Set("NormalMin","")
			d ChildItem.%Set("RangeUnit","")
			d ChildItem.%Set("RangeType","")
			d ChildItem.%Set("Cause","")
			d ChildItem.%Set("SymptomResult",IsPositive)
			if FieldName="CurrentMedHisSum"
			{
				d ChildItem.%Set("Status","")	
			}
			d Children.%Push(ChildItem)
			d SymptomJson.%Set("children",Children)
			d ChildrenResultArray.%Push(SymptomJson)
		}
		//d SymptomJson.%Set("children",Children)
		//d ChildrenResultArray.%Push(SymptomJson)
	}
	
	q ""
}

/// Creator:lideyuan
/// CreatDate:2020-05-14
/// Description：把NLP API中返回的既往史json结果处理一下
/// Input：nlp json返回的字符串
/// Output: json
/// w ##class(web.CDSS.MachineLearning.NLPProcessingData).ProcessingNLPPastDiagString()
ClassMethod ProcessingNLPPastDiagString(NLPString As %String, FieldName As %String, ByRef ChildrenResultArray, ByRef RecordInserted)
{
	if NLPString="[]"
	{
		s SymptomJson={}
		s Children=[]
		s ChildItem={}
		d SymptomJson.%Set("DataClass",..GetMappingUser(FieldName))
		d ChildItem.%Set("PastHistoryNum","")
		d ChildItem.%Set("DiagnosisType","")
		d ChildItem.%Set("PastDiagnosisName","空")
		d ChildItem.%Set("StartTime","")
		d ChildItem.%Set("EndTime","")
		d ChildItem.%Set("Duration","")
		d ChildItem.%Set("Criticality","")
		d ChildItem.%Set("TreatmentEffect","")
		d ChildItem.%Set("Remarks","")

		d Children.%Push(ChildItem)
		d SymptomJson.%Set("children",Children)
		d ChildrenResultArray.%Push(SymptomJson)
		q ""
	}
	s NLPArray=[].%FromJSON(NLPString)
	for i=0:1:NLPArray.%Size()-1
	{
		s SymptomJson={}
		s Children=[]
		s DataClass=..GetMappingUser(FieldName)
		continue:DataClass=""
		d SymptomJson.%Set("DataClass",..GetMappingUser(FieldName))
		s ItemJson=NLPArray.%Get(i)
		s IsPositiveFlag=ItemJson.%Get("type")
		if (IsPositiveFlag["+")||(IsPositiveFlag["-")
		{
			s IsPositive=$e(ItemJson.%Get("type"),1,1)   //用来取阴性和阳性
			s IsPositive=$case(IsPositive,"+":"阳性","-":"阴性")
		}
		else
		{
			s IsPositive="阳性"
		}
		continue:IsPositive="阴性"
		s Type=$e(ItemJson.%Get("type"),2,*)
		
		if ItemJson.%IsDefined("name")        //类型
		{
			s ItemType=ItemJson.%Get("name")
		}
		else
		{
			s ItemType=""
		}
		if ItemType'=""
		{
			s UserName=..GetMappingUser(FieldName)
			s RecordInserted(UserName,ItemType)=""
		}
		s TypeDesc=$case(Type,"epidemic":"疾病","disease":"疾病","drug":"药物","Drug":"药物","operation":"手术","allergy":"过敏","blood_transfusion":"输血",:"")
		
		//Duration字段有last_tiem优先存，没有则存happen_time
		if ItemJson.%IsDefined("last_time")
		{
			s Duration=ItemJson.%Get("last_time").%Get("name")
			s Duration=..DealLastTime(Duration)   ///处理持续时间并进行单位转换（时）
		}
		else
		{
			if ItemJson.%IsDefined("happen_time")
			{
				s Duration=ItemJson.%Get("happen_time").%Get("name")
				s Duration=..DealHappentime(Duration) ///处理开始时间并进行单位转换（时）
			}
			else
			{
				s Duration=""
			}
		}
		
		//输血品类型
		if ItemJson.%IsDefined("bt_name")&(Type="blood_transfusion")
		{
			s ItemType=ItemJson.%Get("bt_name").%Get("name")
			s BPClssID=$o(^CT.WDT.CDSS.BPClassDictI("NameIndex",ItemType,0)) //输血品分类字典判断
			continue:BPClssID=""
		}
		//输血品（NLP目前没这个字段
		
		if ItemJson.%IsDefined("Drug")
		{
			s DrugName=ItemJson.%Get("Drug").%Get("name")
		}
		
		//既往史药物进行别名和化学名转换
		if TypeDesc="药物"
		{
			s DrugID=$o(^CT.WDT.CDSS.DrugDictI("ChemicalNameIndex"," "_$ZCONVERT(ItemType,"U"),0)) //化学名索引
			if DrugID'=""
			{
				s ItemType=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugID)),4)  //药品名称
			}
		}
		//既往史疾病去掉"史"
		if TypeDesc="疾病"
		{
			if ItemJson.%IsDefined("formal")
			{
				if ItemJson.%Get("formal")'=""
				{
					s Formal=ItemJson.%Get("formal")
					s FormalID=$o(^CT.WDT.CDSS.DiseaseDictI("NameIndex"," "_$ZCONVERT(Formal,"U"),0))
					if FormalID=""
					{
						s DiseaseID=$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.DiseaseDict",Formal,0)) //归一是某个诊断的别名
						if (DiseaseID'="")
						{
							s Formal=$lg($g(^CT.WDT.CDSS.DiseaseDictD(DiseaseID)),3) //归一转疾病名称
						}
						else
						{
							if $e(Formal,$l(Formal))="病"
							{
								s FormalDeal=$replace(Formal,"病","")
								s DiagID=$o(^CT.WDT.CDSS.DiseaseDictI("NameIndex"," "_$ZCONVERT(FormalDeal,"U"),0))
								if DiagID'=""
								{
									s Formal=FormalDeal
								}
								else
								{
									s DiagID=$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.DiseaseDict",FormalDeal,0))
									if DiagID'=""
									{
										s Fromal=$lg($g(^CT.WDT.CDSS.DiseaseDictD(DiagID)),3)
									}
								}
							} 	
						}
					}
					s ItemType=Formal
				}
			}
			
		}
		
		if (Duration="")&(ItemType="")
		{
			continue
		}
		s ChildItem={}
		d ChildItem.%Set("PastHistoryNum","")
		d ChildItem.%Set("DiagnosisType",TypeDesc)
		d ChildItem.%Set("PastDiagnosisName",ItemType)
		d ChildItem.%Set("StartTime","")
		d ChildItem.%Set("EndTime","")
		d ChildItem.%Set("Duration",Duration)
		d ChildItem.%Set("Criticality","")
		d ChildItem.%Set("TreatmentEffect","")
		d ChildItem.%Set("Remarks","")

		d Children.%Push(ChildItem)
		d SymptomJson.%Set("children",Children)
		d ChildrenResultArray.%Push(SymptomJson)
	}
	q ""
}

/// Creator:lideyuan
/// CreatDate:2020-05-18
/// Description：把NLP API中返回的家族史json结果处理一下
/// Input：nlp json返回的字符串
/// Output: json
/// w ##class(web.CDSS.MachineLearning.NLPProcessingData).ProcessingNLPFamilyDiagString()
ClassMethod ProcessingNLPFamilyDiagString(NLPString As %String, FieldName As %String, ByRef ChildrenResultArray, ByRef RecordInserted)
{
	if NLPString="[]"
	{
		s FamilyJson={}
		s Children=[]
		s DataClass=..GetMappingUser(FieldName)
		d FamilyJson.%Set("DataClass",..GetMappingUser(FieldName))
		s ChildItem={}
		d ChildItem.%Set("Relationship","")
		d ChildItem.%Set("GeneticDiseNo","")
		d ChildItem.%Set("GeneticDiseName","空")
		d ChildItem.%Set("ConditionDescription","")
		d ChildItem.%Set("EndTime","")
		d ChildItem.%Set("StartTime","")
		d ChildItem.%Set("Duration","")
		d ChildItem.%Set("IsCure","")
		d ChildItem.%Set("Remarks","")

		d Children.%Push(ChildItem)
		d FamilyJson.%Set("children",Children)
		d ChildrenResultArray.%Push(FamilyJson)
		q ""
	}
	
	s NLPArray=[].%FromJSON(NLPString)
	for i=0:1:NLPArray.%Size()-1
	{
		s FamilyJson={}
 //		s Children=[]
		s DataClass=..GetMappingUser(FieldName)
		continue:DataClass=""
 //		d FamilyJson.%Set("DataClass",..GetMappingUser(FieldName))
		s ItemJson=NLPArray.%Get(i)
		s IsPositiveFlag=ItemJson.%Get("type")
		if (IsPositiveFlag["+")||(IsPositiveFlag["-")
		{
			s IsPositive=$e(ItemJson.%Get("type"),1,1)   //用来取阴性和阳性
			s IsPositive=$case(IsPositive,"+":"阳性","-":"阴性")
		}
		else
		{
			s IsPositive="阳性"
		}

		k ItemRelativeString	
		continue:IsPositive="阴性"
		s Type=$e(ItemJson.%Get("type"),2,*)
		if Type="familyhistory"    //如果为家族史
		{
			//遗传病名称
			s DiseaseName=ItemJson.%Get("name")
			s DiseaseID=$o(^CT.WDT.CDSS.DiseaseDictI("NameIndex"," "_$ZCONVERT(DiseaseName,"U"),0)) //疾病字典判断（必须在）
			s:DiseaseID="" DiseaseID=$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.DiseaseDict",DiseaseName,0))  //别名通用名判断
			if (DiseaseID="")
			{
				if ItemJson.%IsDefined("formal")&(ItemJson.%Get("formal")'="")&(ItemJson.%Get("formal")'=ItemJson.%Get("name")) //有实体&归一实体不同&归一不为空
				{
					s DiseaseName=ItemJson.%Get("formal") //归一
					s DiseaseID=$o(^CT.WDT.CDSS.DiseaseDictI("NameIndex"," "_$ZCONVERT(DiseaseName,"U"),0))
					s:DiseaseID="" DiseaseID=$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.DiseaseDict",DiseaseName,0))
					if (DiseaseID="")
					{
						if (ItemJson.%IsDefined("core"))&(ItemJson.%Get("core")'="")&(ItemJson.%Get("core")'=ItemJson.%Get("name"))
						{
							s core=ItemJson.%Get("core")  //上位词
							if ((core'="")&(core'["、")) //单个上位词
							{
								s DiseaseID=$o(^CT.WDT.CDSS.DiseaseDictI("NameIndex"," "_$ZCONVERT(core,"U"),0))
								s:(DiseaseID="") DiseaseID=$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.DiseaseDict",core,0))
							}
							elseif (core'="")&(core["、") //多个上位词，用"、"分隔的
							{
								for v=1:1:$l(core,"、")
								{
									s CoreNow=$p(core,"、",v)
									s DiseaseID=$o(^CT.WDT.CDSS.DiseaseDictI("NameIndex"," "_$ZCONVERT(CoreNow,"U"),0))
									s:(DiseaseID="") DiseaseID=$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.DiseaseDict",CoreNow,0))
									q:DiseaseID'=""
								}
							}
						}
					}
					
				}
				else
				{
					if (ItemJson.%IsDefined("core"))&(ItemJson.%Get("core")'="")&(ItemJson.%Get("core")'=ItemJson.%Get("name"))
					{
						s core=ItemJson.%Get("core")  //上位词
						if ((core'="")&(core'["、")) //单个上位词
						{
							s DiseaseID=$o(^CT.WDT.CDSS.DiseaseDictI("NameIndex"," "_$ZCONVERT(core,"U"),0))
							s:(DiseaseID="") DiseaseID=$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.DiseaseDict",core,0))
						}
						elseif (core'="")&(core["、") //多个上位词，用"、"分隔的
						{
							for v=1:1:$l(core,"、")
							{
								s CoreNow=$p(core,"、",v)
								s DiseaseID=$o(^CT.WDT.CDSS.DiseaseDictI("NameIndex"," "_$ZCONVERT(CoreNow,"U"),0))
								s:(DiseaseID="") DiseaseID=$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.DiseaseDict",CoreNow,0))
								q:DiseaseID'=""
							}
						}
					}
				}
			}
			continue:DiseaseID=""
			s:DiseaseID'="" DiseaseName=$lg($g(^CT.WDT.CDSS.DiseaseDictD(DiseaseID)),3)  //疾病名称
			
			//持续时间
			if ItemJson.%IsDefined("last_time")
			{
				s Duration=ItemJson.%Get("last_time").%Get("name")
				s Duration=..DealLastTime(Duration) //转换成时
			}
			else
			{
				s Duration=""
			}
			
			//亲属关系
			if ItemJson.%IsDefined("relative")
			{
				s ItemRelativeArray=ItemJson.%Get("relative")
				s ItemRelativeString=""
				for j=0:1:ItemRelativeArray.%Size()-1
				{
					s ItemRelative=ItemRelativeArray.%Get(j)
					s Relative=ItemRelative.%Get("name") //亲属
					if ItemRelative.%IsDefined("age")   //亲属年龄
					{
						s:Duration="" Duration=..DealLastTime((ItemRelative.%Get("age"))) //亲属年龄转成小时
					}
					
					s CommonID=$o(^CT.WDT.CDSS.CommonDictI("DescIndex"," "_Relative,0))  //通用名字典进行判断
					s:CommonID="" CommonID=$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.CommonDict",Relative,0))  //别名通用名判断
					s:CommonID="" Relative=""
					s:CommonID'="" Relative=$lg($g(^CT.WDT.CDSS.CommonDictD(CommonID)),4)  //通用名名称
					
					s ItemRelativeString(j+1)=Relative
 //					s:ItemRelativeString'="" ItemRelativeString=ItemRelativeString_"^"_Relative
 //					s:ItemRelativeString="" ItemRelativeString=Relative
				}
			}
			else
			{
				s ItemRelativeString(1)=""   //如果没有relative键，则为空
			}
			
			if ItemJson.%IsDefined("symptom")    //如果存在症状键，则取值
			{
				s ConditionDescription=ItemJson.%Get("symptom").%Get("name")
			}
			else
			{
				s ConditionDescription=""    //如果不存在symptom键，则置为空
			}
			
			//是否治愈
			if ItemJson.%IsDefined("outcome")
			{
				s outcome=ItemJson.%Get("outcome").%Get("name")
				s CommonID=$o(^CT.WDT.CDSS.CommonDictI("DescIndex"," "_outcome,0))  //通用名字典进行判断
				s:CommonID="" outcome=""
			}
			else
			{
				s outcome=""
			}
			//疾病开始年龄
			if ItemJson.%IsDefined("happen_age")
			{
				s happenage=ItemJson.%Get("happen_age").%Get("name")
			}
			else
			{
				s happenage=""
			}
			
			if DiseaseName'=""
			{
				s UserName=..GetMappingUser(FieldName)
				s RecordInserted(UserName,DiseaseName)=""
			}
			
			//一条数据有多个亲属，存多条数据
			s k=0
			for 
			{
				s k=$o(ItemRelativeString(k))
				q:k=""
				s FamilyJson={}
				s DataClass=..GetMappingUser(FieldName)
				d FamilyJson.%Set("DataClass",..GetMappingUser(FieldName))
				s ChildItem={}
				s Children=[]
				s Rel=ItemRelativeString(k)

				d ChildItem.%Set("Relationship",Rel) //亲属关系
				d ChildItem.%Set("GeneticDiseNo","")
				d ChildItem.%Set("GeneticDiseName",DiseaseName) //遗传病名称
				d ChildItem.%Set("ConditionDescription",ConditionDescription) //病情描述
				d ChildItem.%Set("EndTime","")
				d ChildItem.%Set("StartTime","")
				d ChildItem.%Set("Duration","") //持续时间
				d ChildItem.%Set("IsCure",outcome) //是否治愈
				d ChildItem.%Set("Remarks","")
				d Children.%Push(ChildItem)
				d FamilyJson.%Set("children",Children)
				s RepeatArray=ChildrenResultArray.%ToJSON()
				s RepeatJson=FamilyJson.%ToJSON()
				if RepeatArray '[ RepeatJson
				{
					d ChildrenResultArray.%Push(FamilyJson)
				}
			}
			k ItemRelativeString

		
		}


	}

	q ""
}

/// Creator:lideyuan
/// CreatDate:2020-05-19
/// Description：把NLP API中返回的个人史json结果处理一下
/// Input：nlp json返回的字符串
/// Output: json
/// w ##class(web.CDSS.MachineLearning.NLPProcessingData).ProcessingNLPPersonalDiagString()
ClassMethod ProcessingNLPPersonalDiagString(NLPString As %String, FieldName As %String, ByRef ChildrenResultArray, ByRef RecordInserted)
{
	if NLPString="[]"
	{
		s PersonalJson={}
		s Children=[]
		s DataClass=..GetMappingUser(FieldName)
		d PersonalJson.%Set("DataClass",..GetMappingUser(FieldName))
		s ChildItem={}
		d ChildItem.%Set("PersonalHistoryOverview","空")
		d ChildItem.%Set("StartTime","")
		d ChildItem.%Set("Duration","")
		d ChildItem.%Set("EndTime","")
		d ChildItem.%Set("Criticality","")
		d ChildItem.%Set("Remarks","")
		d Children.%Push(ChildItem)
		d PersonalJson.%Set("children",Children)
		d ChildrenResultArray.%Push(PersonalJson)
		q ""
	}
	s NLPArray=[].%FromJSON(NLPString)
	for i=0:1:NLPArray.%Size()-1
	{
		s PersonalJson={}
		s Children=[]
		s DataClass=..GetMappingUser(FieldName)
		continue:DataClass=""
		d PersonalJson.%Set("DataClass",..GetMappingUser(FieldName))
		s ItemJson=NLPArray.%Get(i)
		s IsPositive=$e(ItemJson.%Get("type"),1,1)   //用来取阴性和阳性
		if (IsPositive["+") ||(IsPositive["-")
		{
			s IsPositive=$case(IsPositive,"+":"阳性","-":"阴性")
		}
		else
		{
			s IsPositive="阳性"
		}
		continue:IsPositive="阴性"
		s Type=$e(ItemJson.%Get("type"),2,*)
		continue:Type'="personalhistory"   //如果不是个人史  则跳过
		s:Type="personalhistory" Type="个人史" 
		s (unit,quaunit,quantity,frequency,Frequency)=""
		/*if ItemJson.%IsDefined("name")
		{
			s ItemType=ItemJson.%Get("name")     //获取个人史类型  比如：饮酒史、吸毒史等
		}
		else
		{
			s ItemType=""
		}*/
		if ItemJson.%IsDefined("personalhistory")
		{
			s ItemType=ItemJson.%Get("personalhistory").%Get("name")      //获取描述  比如：吸烟，饮酒等
		}
		else
		{
			s ItemType=""
		}
		
		if ItemType'=""
		{
			s UserName=..GetMappingUser(FieldName)
			s RecordInserted(UserName,ItemType)=""
		}
		if ItemJson.%IsDefined("last_time")
		{
			s Duration=ItemJson.%Get("last_time").%Get("name")  //持续时间
			s Duration=..DealMTime(Duration) //换算成数字，默认单位为：天
		}
		else
		{
			s Duration=""
		}
		continue:Duration=""
		
		//数量
		if ItemJson.%IsDefined("quantity")
		{
			s quantity=ItemJson.%Get("quantity").%Get("value")    //一次多少支
			s quaunit=""
			if ItemJson.%Get("quantity").%IsDefined("unit") 
			{ 
				s quaunit=ItemJson.%Get("quantity").%Get("unit")     //数量单位
				s UnitID=$o(^CT.WDT.CDSS.UnitDictI("DescIndex"," "_$zconvert(quaunit,"U"),0)) //单位字典表
				if UnitID'=""
				{
					s quaunit=quaunit
				}
				else
				{
					s UnitAliasID=$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.UnitDict",quaunit,0)) //别名通用名找，单位字典表 ID
					s:UnitAliasID'="" quaunit=$lg($g(^CT.WDT.CDSS.UnitDictD(UnitAliasID)),3)  //单位字典表 单位名称
					s:UnitAliasID="" quaunit=""
				}
			}
		}
		
		//频率
		if ItemJson.%IsDefined("frequency")
		{
			s frequency=ItemJson.%Get("frequency").%Get("value")  //一天几次
			if (ItemJson.%Get("frequency")).%IsDefined("unit") 
			{ 
				s unit=$replace(ItemJson.%Get("frequency").%Get("unit"),"每","") //频率单位
				//频率名称+频率单位
				s Frequency=frequency_unit
				
				s FreID=$o(^CT.WDT.CDSS.FrequencyDictI("NameIndex"," "_Frequency,0)) //频率名称+单位在频率字典中
				if FreID=""
				{
					s FreALisID=$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.FrequencyDict",Frequency,0))  //别名表判断
					s:FreALisID'="" Frequency=$lg($g(^CT.WDT.CDSS.FrequencyDictD(FreALisID)),3)  //频率字典表 频率名称
					s:FreALisID="" Frequency=""
				}	
			}
		}
		
		if (quantity'="")&&(frequency'="")
		{
			s Criticality=(quantity*frequency)_quaunit_" "_unit     //把频次和一次的个数相乘
			s quantity=quantity*frequency
		}
		else
		{
			s Criticality=""
		}
		
		//数量+数量单位 
		s Value=quantity_quaunit
		
		s DateNow=+$HOROLOG
		s StartTime=DateNow-Duration
		//个人史类型不在通用字典类型表中则不存(CT.WDT.CDSS.CommonDictType)
		s CommonTypeID=$o(^CT.WDT.CDSS.CommonDictTypeI("DescIndex"," "_Type,0))
		continue:CommonTypeID=""
		//个人史描述不在通用名字典表中则不存（CT.WDT.CDSS.CommonDict）
		s CommonID=$o(^CT.WDT.CDSS.CommonDictI("TypeDescIndex",CommonTypeID,ItemType,0))
		continue:CommonID=""

		s ChildItem={}
		d ChildItem.%Set("PersonalHistoryOverview",ItemType)
		///d ChildItem.%Set("StartTime","")
		d ChildItem.%Set("StartTime",StartTime)
		d ChildItem.%Set("Duration",Duration)
		d ChildItem.%Set("EndTime","")
		d ChildItem.%Set("Criticality",Criticality)
		d ChildItem.%Set("Remarks","")
		d ChildItem.%Set("Value",Value) //量
		d ChildItem.%Set("Frequency",Frequency)  //频率
		
		d Children.%Push(ChildItem)
		d PersonalJson.%Set("children",Children)
		d ChildrenResultArray.%Push(PersonalJson)
	}

	q ""
}

/// Creator:lideyuan
/// CreatDate:2020-05-19
/// Description：把NLP API中返回的婚育史json结果处理一下
/// Input：nlp json返回的字符串
/// Output: json
/// w ##class(web.CDSS.MachineLearning.NLPProcessingData).ProcessingNLPMarriageDiagString()
ClassMethod ProcessingNLPMarriageDiagString(NLPString As %String, FieldName As %String, ByRef ChildrenResultArray, ByRef RecordInserted)
{
	q:NLPString="[]" ""
	if NLPString="[]"
	{
		s MarriageJson={}
		s Children=[]
		s DataClass=..GetMappingUser(FieldName)
		d MarriageJson.%Set("DataClass",..GetMappingUser(FieldName))
		s ChildItem={}
		d ChildItem.%Set("TypeOfMarriage","空")
		d ChildItem.%Set("MarriageOverview","空")
		d ChildItem.%Set("Duration","")
		d ChildItem.%Set("StartTime","")
		d ChildItem.%Set("EndTime","")
		d ChildItem.%Set("Criticality","")
		d ChildItem.%Set("Remarks","")
		d Children.%Push(ChildItem)
		d MarriageJson.%Set("children",Children)
		d ChildrenResultArray.%Push(MarriageJson)
		q ""
	}
	s NLPArray=[].%FromJSON(NLPString)
	for i=0:1:NLPArray.%Size()-1
	{
		s MarriageJson={}
		s Children=[]
		s DataClass=..GetMappingUser(FieldName)
		continue:DataClass=""
		d MarriageJson.%Set("DataClass",..GetMappingUser(FieldName))
		s ItemJson=NLPArray.%Get(i)
		s Type=ItemJson.%Get("type")
		if ((Type["+") || (Type["-"))
		{
			continue:$e(Type,1,1)="-"
			if ($e(Type,1,1)="+")   //
			{
				s Type=$e(Type,2,*)
			}
		}
		
		s (ItemType,StartTime,ItemDuration)=""
		
		//特殊处理 "妊娠"
		s:(Type="disease")&(ItemJson.%Get("name")="妊娠") Type="marriagehistory"
		
		//如果是结婚史
		if Type="marriagehistory"
		{
			
			if ItemJson.%IsDefined("marriage_value")   
			{
				if ItemJson.%Get("marriage_value").%IsDefined("value")
				{
					s ItemType=ItemJson.%Get("marriage_value").%Get("value")   //婚育描述
				}
				else
				{
					s ItemType=""
				} 
				//s ItemType=ItemJson.%Get("marriage_value").%Get("value")   //婚育描述
			}
			else
			{
				s ItemType=""
			}
			
			/*if ItemJson.%IsDefined("menstrual_time")    //婚育时间
			{
				s ItemDuration=ItemJson.%Get("menstrual_time").%Get("name")
			}*/
			if ItemJson.%IsDefined("marriage_time")    //婚育时间
			{
				s ItemDuration=ItemJson.%Get("marriage_time").%Get("value")
				s ItemDuration=..DealMTime(ItemDuration) //换算成默认单位为天的数值
			}
			else
			{
				s ItemDuration=""
			}
			s StartTime=""
			
		}
		
		//如果是怀孕史
		if Type="pregnancy&birth"
		{
			if ItemJson.%IsDefined("marriage_value")
			{
				s ItemType=ItemJson.%Get("marriage_value").%Get("value")  //怀孕状态
			}
			
			if ItemJson.%IsDefined("pregnant_times")   //怀孕次数
			{
				//s PregnancyTime="怀孕次数:"_ItemJson.%Get("pregnant_times").%Get("name")
				s PregnancyTime=ItemJson.%Get("pregnant_times").%Get("value")
				s ItemType=ItemJson.%Get("pregnant_times").%Get("name")
			}
			else
			{
				s PregnancyTime=""
			}
			
			if ItemJson.%IsDefined("birth_times")   //生育次数
			{
				//s BirthTime="生育次数："_ItemJson.%Get("birth_times").%Get("name")
				s BirthTime=ItemJson.%Get("birth_times").%Get("value")
				s ItemType=ItemJson.%Get("birth_times").%Get("name")
			}
			else
			{
				s BirthTime=""
			}
			
			s:PregnancyTime'="" ItemDuration=PregnancyTime
			s:BirthTime'="" ItemDuration=BirthTime
		}
		
		
		if Type="menstrualhistory"   //月经史
		{
			//以前单用  name,  now：如果menstrual_type的name找不到再用 name
			if ItemJson.%IsDefined("menstrual_type")
			{
				s ItemType=ItemJson.%Get("menstrual_type").%Get("name")  //月经状态
			}
			elseif(ItemType="")&(ItemJson.%IsDefined("name"))
			{
				s ItemType=ItemJson.%Get("name")  //月经状态
			}
			
			
			if ItemJson.%IsDefined("happen_time")   //发生时间
			{
				s StartTime=ItemJson.%Get("happen_time").%Get("name")
			}
			elseif ItemJson.%IsDefined("menstrual_age")
			{
				s StartTime=ItemJson.%Get("menstrual_age").%Get("name")   // 初潮15岁 为例
				s StartTime=..DealMTime(StartTime) //换算成默认单位为天的数值
				s DateNow=+$HOROLOG
				s StartTime=DateNow-StartTime
				s ItemDuration=ItemJson.%Get("menstrual_age").%Get("name")
				s ItemDuration=..DealMTime(ItemDuration) //换算成默认单位为天的数值 岁换成天
			}
			
			//持续时间
			if ItemJson.%IsDefined("last_time")
			{
				s ItemDuration=ItemJson.%Get("last_time").%Get("name")
				s ItemDuration=..DealMTime(ItemDuration) //换算成默认单位为天的数值
			}
			//持续时间也可由 月经史值和单位组成
			s DurString=""
			if ItemJson.%IsDefined("menstrual_value")&ItemJson.%IsDefined("menstrual_unit")
			{
				s DurString=ItemJson.%Get("menstrual_value").%Get("name") //月经周期38天 为例
				s DurStringUnit=ItemJson.%Get("menstrual_unit").%Get("name")
				s DurString=DurString*##class(web.CDSS.CMKB.UnitConversion).GetConversion(DurStringUnit,"天")  //转换成天，单位转换接口
			}
			s:ItemDuration="" ItemDuration=DurString
		}
		
		//特殊处理 "妊娠"
		s:(Type="marriagehistory")&(ItemJson.%Get("name")="妊娠") ItemType="妊娠"
		
		continue:ItemType=""
		if ItemType'=""
		{
			s UserName=..GetMappingUser(FieldName)
			s RecordInserted(UserName,ItemType)=""
		}
		///s ItemDesc=$case(Type,"marriagehistory":"婚姻","pregnancy&birth":"生育","menstrualhistory":"月经",:"") ///1.0
		s ItemDesc=$case(Type,"marriagehistory":"月经婚育史","pregnancy&birth":"月经婚育史","menstrualhistory":"月经婚育史",:"") ///2.0，用通用名字典类型表CT.WDT.CDSS.CommonDictType的类型描述TypeDesc
		
		// 特殊处理 "妊娠"
		s:(Type="marriagehistory")&(ItemJson.%Get("name")="妊娠") ItemDesc="妊娠/产后状态"
		
		continue:ItemDesc=""
		
		//婚育类型不在通用字典类型表中则不存(CT.WDT.CDSS.CommonDictType)
		s CommonTypeID=$o(^CT.WDT.CDSS.CommonDictTypeI("DescIndex"," "_ItemDesc,0))
		continue:CommonTypeID=""
		s:ItemType="经期" ItemType="月经期"
		//婚育描述不在通用名字典表中则不存（CT.WDT.CDSS.CommonDict）
		s CommonID=$o(^CT.WDT.CDSS.CommonDictI("TypeDescIndex",CommonTypeID,ItemType,0))
		if CommonID=""
		{
			s CommonID=$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.CommonDict",ItemType,0)) //别名通用名找ID
			s:CommonID'="" ItemType=$lg($g(^CT.WDT.CDSS.CommonDictD(CommonID)),4)
		}
		
		continue:CommonID=""
		
		s ChildItem={}
		///d ChildItem.%Set("TypeOfMarriage",ItemDesc)
		d ChildItem.%Set("TypeOfMarriage",ItemType)
		d ChildItem.%Set("MarriageOverview",ItemType)
		d ChildItem.%Set("Duration",ItemDuration)
		d ChildItem.%Set("StartTime",StartTime)
		d ChildItem.%Set("EndTime","")
		d ChildItem.%Set("Criticality","")
		d ChildItem.%Set("Remarks","")
		d Children.%Push(ChildItem)
		d MarriageJson.%Set("children",Children)
		d ChildrenResultArray.%Push(MarriageJson)
	}

	q ""
}

/// Creator:lideyuan
/// CreatDate:2020-05-19
/// Description：把NLP API中返回的过敏史json结果处理一下
/// Input：nlp json返回的字符串
/// Output: json
/// w ##class(web.CDSS.MachineLearning.NLPProcessingData).ProcessingNLPAllergyDiagString()
ClassMethod ProcessingNLPAllergyDiagString(NLPString As %String, FieldName As %String, ByRef ChildrenResultArray, ByRef RecordInserted, PatientDR As %String)
{
	s FieldNameNew=FieldName
	s FieldName=$case(FieldName,"PastDiagnosisSum":"AllergyHisSum",:FieldName)

	//先删除上一次病历中保存的内容（既往史的过敏信息，过敏史）
	s AllergyInfoID=0
	for
	{
		s AllergyInfoID=$o(^WDT.CDSS.AllergyHistoryI("PatDRIndex",PatientDR,AllergyInfoID))
		q:AllergyInfoID=""
		s RiskLevel=$lg($g(^WDT.CDSS.AllergyHistoryD(AllergyInfoID)),9) //病历单号
		if RiskLevel=FieldNameNew
		{
			d ##class(WDT.CDSS.AllergyHistory).%DeleteId(AllergyInfoID) //只删FieldName存进来的检查
		}
	}
	q:NLPString="[]" ""
	if NLPString="[]"
	{
		s AllergyJson={}
		s Children=[]
		s DataClass=..GetMappingUser(FieldName)
		d AllergyJson.%Set("DataClass",..GetMappingUser(FieldName))
		s ChildItem={}
		d ChildItem.%Set("AllergySourceName","空")
		d ChildItem.%Set("AllergySourceType","")
		d ChildItem.%Set("AllergyHistoryNum","")
		d ChildItem.%Set("StartTime","")
		d ChildItem.%Set("EndTime","")
		d ChildItem.%Set("RiskLevel","")
		d ChildItem.%Set("TreatmentEffect","")
		d ChildItem.%Set("CollectionDate","")
		d ChildItem.%Set("SymptomResult","")
		d ChildItem.%Set("Remarks","")
		d Children.%Push(ChildItem) 
		d AllergyJson.%Set("children",Children)
		d ChildrenResultArray.%Push(AllergyJson)
		q ""
	}
	s AllergyJson=""
	s NLPArray=[].%FromJSON(NLPString)
	for i=0:1:NLPArray.%Size()-1
	{
		s AllergyJson={}
		s Children=[]
		s DataClass=..GetMappingUser(FieldName)
		continue:DataClass=""
		d AllergyJson.%Set("DataClass",..GetMappingUser(FieldName))
		s (AllergySourceName,AllergySourceType)=""
		s ItemJson=NLPArray.%Get(i)
		s Type=""
		s Type=ItemJson.%Get("type")
		s ItemType=""
		s Flag=$e(Type,1,1)
		continue:(Flag="-")||((Type["Drug")&(FieldNameNew="PastDiagnosisSum"))    //阴性症状，既往史的药品不要
		
		if (Flag="+")   //如果有阴阳性
		{
			s ItemType=$e(Type,2,*)
		}
		
		if ItemJson.%IsDefined("allergen")    //过敏原
		{
			s AllergySourceName=ItemJson.%Get("name")
		}

		
		if ItemJson.%IsDefined("Drug")   //过敏药物
		{
			s AllergySourceName=ItemJson.%Get("Drug").%Get("name")
			s AllergySourceType="药物"
		}

		//if (AllergySourceName="")&&(AllergySourceType="")   //如果过敏原和类型为空 则跳过
		if (AllergySourceName="") //如果过敏原为空 则跳过
		{
			continue
		}
		else
		{
			s AllergyID=$o(^CT.WDT.CDSS.AllergyDictI("DescIndex"," "_$ZCONVERT(AllergySourceName,"U"),0)) //过敏史字典判断（必须在）
			if (AllergyID="")
			{
				s:AllergyID="" AllergyID=$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.AllergyDict",AllergySourceName,0))  //别名通用名判断
				s:AllergyID'="" AllergySourceName=$lg($g(^CT.WDT.CDSS.AllergyDictD(AllergyID)),3)
			}
			if AllergyID="" //药物字典判断
			{
				s AllergyID=$o(^CT.WDT.CDSS.DrugDictI("NameIndex"," "_$ZCONVERT(AllergySourceName,"U"),0))
				if AllergyID=""
				{
					s DrugID=$o(^CT.WDT.CDSS.DrugDictI("ChemicalNameIndex"," "_$ZCONVERT(AllergySourceName,"U"),0)) //化学名索引
					//化学名转通用名
					if DrugID'=""
					{
						s AllergySourceName=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugID)),4)  //药品名称
					}
				}
			}
			continue:AllergyID=""
		}
		
		s AllergyHistoryNum=""
		s StartTime=""
		s EndTime=""
		s RiskLevel=""     //危重程度
		s TreatmentEffect=""    //缓解因素
		s CollectionDate=""   //采集时间
		s SymptomResult=""    //症状结果
		s Remarks=""    
		if AllergySourceName'=""
		{
			s UserName=..GetMappingUser(FieldName)
			s RecordInserted(UserName,AllergySourceName)=""
		}
		s ChildItem={}
		d ChildItem.%Set("AllergySourceName",AllergySourceName)
		d ChildItem.%Set("AllergySourceType",AllergySourceType)
		d ChildItem.%Set("AllergyHistoryNum","")
		d ChildItem.%Set("StartTime","")
		d ChildItem.%Set("EndTime","")
		d ChildItem.%Set("RiskLevel",FieldNameNew)
		d ChildItem.%Set("TreatmentEffect","")
		d ChildItem.%Set("CollectionDate","")
		d ChildItem.%Set("SymptomResult","")
		d ChildItem.%Set("Remarks","")
		d Children.%Push(ChildItem) 
		d AllergyJson.%Set("children",Children)
		d ChildrenResultArray.%Push(AllergyJson)
	}
	
	q AllergyJson
}

/// Creator:lideyuan
/// CreatDate:2020-05-19
/// Description：把NLP API中返回的体格检查史json结果处理一下
/// Input：nlp json返回的字符串
/// Output: json
/// w ##class(web.CDSS.MachineLearning.NLPProcessingData).ProcessingNLPPhysicalDiagString()
ClassMethod ProcessingNLPPhysicalDiagString(NLPString As %String, FieldName As %String, ByRef ChildrenResultArray, ByRef RecordInserted)
{
	s FieldNameNew=FieldName
	s:FieldName="CurrentMedHisSum" FieldName="PhysicalExamSum"
	s:FieldNameNew="CurrentMedHisSum" ^TEMP("PyhsicalExamSum")=^TEMP("PyhsicalExamSum")+1
	
	if NLPString="[]"
	{
		q:(ChildrenResultArray.%ToJSON()["""DataClass"":""PhysicalExam"",")||(^TEMP("PyhsicalExamSum")=1) ""
		s PhysicalJson={}
		d PhysicalJson.%Set("DataClass",..GetMappingUser(FieldName))
		s Children=[]
		s ChildItem={}
		d ChildItem.%Set("SymptomNum","")
		d ChildItem.%Set("Status","")
		d ChildItem.%Set("PartDR","")
		d ChildItem.%Set("Symptom","空")
		d ChildItem.%Set("ExamItem","")
		d ChildItem.%Set("Duration","")
		d ChildItem.%Set("AbnormalMin","")
		d ChildItem.%Set("NormalMax","")
		d ChildItem.%Set("NormalMin","")
		d ChildItem.%Set("CollectionDate","")
		d ChildItem.%Set("SymptomResult","")
		d ChildItem.%Set("RangeUnit","")
		d ChildItem.%Set("RangeType","")
		d ChildItem.%Set("SymptomFormal","")
		d ChildItem.%Set("SymptomCore","")
		d ChildItem.%Set("SymptomType","")
		d ChildItem.%Set("SymProperty","")
		d ChildItem.%Set("AbnormalMax","")
		d ChildItem.%Set("CDSS2PartDR","")
		d ChildItem.%Set("PositionWordDR","")
		
		d Children.%Push(ChildItem) 
		d PhysicalJson.%Set("children",Children)
		d ChildrenResultArray.%Push(PhysicalJson)
		q ""
	}
	
	s AllData=0  //本次能入库的数据
	s NLPArray=[].%FromJSON(NLPString)
	for i=0:1:NLPArray.%Size()-1
	{
		s PhysicalJson={}
		s Children=[]
		s DataClass=..GetMappingUser(FieldName)
		continue:DataClass=""
		d PhysicalJson.%Set("DataClass",..GetMappingUser(FieldName))
		s (Duration,ItemType,Symptom,PartDR,RangeUnit,ExamItem,SymptomResult,PartDR)=""
		s ItemJson=NLPArray.%Get(i)
		s Type=""
		s Type=ItemJson.%Get("type")
		//continue:Type="+normalsign"
		continue:(FieldNameNew="CurrentMedHisSum")&((Type'["sign")||(Type["-"))&((Type'["generalstatus")||(Type["-")) //现病史中只要体征类型的数据
		
		if Type["symptom"     //如果为症状
		{
			if (Type["+")||(Type["-")    //如果包含阴阳性
			{
				s ItemType=$e(Type,2,*) 
				s Symptom=ItemJson.%Get("name")
				
				s IsPositive=$e(Type,1,1)   //阴阳性
				continue:IsPositive="-"
				s IsPositive=$case(IsPositive,"+":"阳性","-":"阴性")
			}
			else    //如果不包含阴阳性
			{
				if ItemJson.%IsDefined(Type)    
				{
					s Symptom=ItemJson.%Get(Type).%Get("name")
					
				}
				s ItemType=Type
				
			}
			continue:Symptom=""
			s ExamItem=Symptom
		}
		
		//if (Type="sign")||(Type="+sign")    //有体征
		if (Type["sign")&(Type'["-")&(Type'["normalsign")    //有体征
		{
			//s ExamItem="体征"
			if ItemJson.%IsDefined("sign_name")   //体征项目名
			{
				s Symptom=ItemJson.%Get("sign_name").%Get("name")
			}
			///应对+sign类型，name=双下肢肌无力2级    双下肢肌力2级、甲状腺肿大
			else
			{
				s Symptom=ItemJson.%Get("name")
			}
			
			
			if ItemJson.%IsDefined("sign_value")    //体征值
			{
				
				s SymptomResultArray=ItemJson.%Get("sign_value")
				s SymptomResultArrayType=ItemJson.%GetTypeOf("sign_value")
				if SymptomResultArrayType="array"   //如果值是一个数组
				{
					s SymptomResultArraySize=SymptomResultArray.%Size()
					for j=0:1:SymptomResultArraySize-1
					{
						//s:SymptomResult'="" SymptomResult=SymptomResult_"^"_SymptomResultArray.%Get(j).%Get("name")
						s:SymptomResult'="" SymptomResult=SymptomResult_"&%"_SymptomResultArray.%Get(j).%Get("name")
						s:SymptomResult="" SymptomResult=SymptomResultArray.%Get(j).%Get("name")
					}
				}
				else   //如果值只是一个{}
				{
					s SymptomResult=SymptomResultArray.%Get("name")
				}
				
			}
			continue:SymptomResult=""
			
			//体征名
			if ItemJson.%IsDefined("sign")
			{
				s ExamItem=ItemJson.%Get("sign").%Get("name") //NLP部位+NLP体征项
				if ItemJson.%Get("sign").%IsDefined("core") //NLP体征项
				{
					s ExamItemCore=ItemJson.%Get("sign").%Get("core")
					if (ExamItemCore'="")&(ExamItemCore'=ExamItem)
					{
						s ExamItem=ExamItemCore
					}
				}
			}
			else
			{
				s ExamItem=Symptom
			}
			
			s ExamItem=$case(ExamItem,"收缩压/舒张压":"血压",:ExamItem)
			s Symptom=$case(Symptom,"收缩压/舒张压":"血压",:Symptom)
		}
		
		//NLP解析的一般情况类型数据
		if (Type["generalstatus")&(Type'["-")
		{
			s Symptom=ItemJson.%Get("name")
			//体征名
			if Symptom'=""
			{
				s ExamItem=Symptom
			}
			elseif ItemJson.%IsDefined("sign")
			{
				s ExamItem=ItemJson.%Get("sign").%Get("name") //NLP部位+NLP体征项
				if ItemJson.%Get("sign").%IsDefined("core") //NLP体征项
				{
					s ExamItemCore=ItemJson.%Get("sign").%Get("core")
					if (ExamItemCore'="")&(ExamItemCore'=ExamItem)
					{
						s ExamItem=ExamItemCore
					}
				}
			}
			
			if ItemJson.%IsDefined("sign_value")    //体征值
			{
				
				s SymptomResultArray=ItemJson.%Get("sign_value")
				s SymptomResultArrayType=ItemJson.%GetTypeOf("sign_value")
				if SymptomResultArrayType="array"   //如果值是一个数组
				{
					s SymptomResultArraySize=SymptomResultArray.%Size()
					for j=0:1:SymptomResultArraySize-1
					{
						//s:SymptomResult'="" SymptomResult=SymptomResult_"^"_SymptomResultArray.%Get(j).%Get("name")
						s:SymptomResult'="" SymptomResult=SymptomResult_"&%"_SymptomResultArray.%Get(j).%Get("name")
						s:SymptomResult="" SymptomResult=SymptomResultArray.%Get(j).%Get("name")
					}
				}
				else   //如果值只是一个{}
				{
					s SymptomResult=SymptomResultArray.%Get("name")
				}
				
			}
		}
		continue:Symptom=""	
		
		//字典表的筛选，去除无效数据
		s SymptomFlag=..WhetherPyhExamDict(Symptom)
		s SymptomFlagN=..ExistSymptom(Symptom)
		s ExamItemFlag=..WhetherPyhExamDict(ExamItem)
		continue:(SymptomFlag'["1")&(SymptomFlagN'="1")&(ExamItemFlag'["1")
		if (SymptomFlag["1")&(SymptomFlag["^")&(SymptomFlagN="0") //是体格检查别名
		{
			s Symptom=$p(SymptomFlag,"^",2) //别名转体格检查名
		}
		if (ExamItemFlag["1")&(SymptomFlag["^")
		{
			s ExamItem=$p(ExamItemFlag,"^",2)
		}
		
		
		if ItemJson.%IsDefined("position")  //如果有部位
		{
			s Part=ItemJson.%Get("position").%Get("name")   //部位
			s:..GetMappingPosition(Part)'="" Part=..GetMappingPosition(Part)
		}
		
		if ItemJson.%IsDefined("sign_unit")  //体征单位
		{
			s RangeUnit=ItemJson.%Get("sign_unit").%Get("name")
		}

		if ItemJson.%IsDefined("last_time")  //持续时长
		{
			s Duration=ItemJson.%Get("last_time").%Get("name")
			s Duration=..DealLastTime(Duration) ///处理持续时间并进行单位转换（时）
		}
		
		///新加
		if (ItemJson.%IsDefined("formal"))&&(ItemJson.%Get("formal")'=ItemJson.%Get("name"))
		{
			s formal=ItemJson.%Get("formal") ///归一词
		}
		else
		{
			s formal=""
		}
		
		if (ItemJson.%IsDefined("core"))&&(ItemJson.%Get("core")'=ItemJson.%Get("name"))
		{
			s core=ItemJson.%Get("core")  ///上位词
			s core=$replace(core,"、","&%")
		}
		else
		{
			s core=""
		}
		
		///属性：用&%拼接level，frequency，nature，day_time内容
		s SymProperty=""
		if ItemJson.%IsDefined("level")
		{
			//s Level=ItemJson.%Get("level").%Get("name")  //程度
			s LevelValue=ItemJson.%Get("level") //程度
			s LevelType=ItemJson.%GetTypeOf("level")
			if LevelType="array"   //如果值是一个数组
			{
				s LevelArraySize=LevelValue.%Size()
				s Level=""
				for LeSize=0:1:LevelArraySize-1
				{
					s:Level'="" Level=Level_"&%"_LevelValue.%Get(LeSize).%Get("name")
					s:Level="" Level=LevelValue.%Get(LeSize).%Get("name")
				}
			}
			else   //如果值只是一个{}
			{
				s Level=LevelValue.%Get("name") //程度
			}
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
			///nature的格式区别于level和frequency，"[...]"格式
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
		if ItemJson.%IsDefined("incentive")
		{
			s Incentive=ItemJson.%Get("incentive").%Get("name")  //诱因
			s:SymProperty'="" SymProperty=SymProperty_"&%"_Incentive
			s:SymProperty="" SymProperty=Incentive
		}
		//sign_value的name加到属性中
		s:(SymProperty'="")&(SymptomResult'="")&($p(..JDSignValue(SymptomResult),"&",1)="string") SymProperty=SymProperty_"&%"_SymptomResult
		s:(SymProperty="")&&(SymptomResult'="")&($p(..JDSignValue(SymptomResult),"&",1)="string") SymProperty=SymptomResult
		
		//症状的值
		s AbnormalMax=""
		s RangeUnit=""
		if ItemJson.%IsDefined("value")
		{
			s AbnormalMax=ItemJson.%Get("value").%Get("name")  //症状的值
		}
		//值的单位
		if ItemJson.%IsDefined("unit")
		{
			s RangeUnit=ItemJson.%Get("unit").%Get("name")  //值的单位
			//s:RangeUnit="毫升" RangeUnit="ml"
		}
		
		s:Symptom="血压" SymptomResult=$replace(SymptomResult,"&%","/")
		s:Symptom="血压" AbnormalMax=SymptomResult
		
		s:(AbnormalMax="")&($p(..JDSignValue(SymptomResult),"&",1)="stringint") AbnormalMax=$p(..JDSignValue(SymptomResult),"&",2)
		s:(RangeUnit="")&($p(..JDSignValue(SymptomResult),"&",1)="stringint") RangeUnit=$p(..JDSignValue(SymptomResult),"&",3)
		
		//2.0的部位和方位
		if ItemJson.%IsDefined("stand_body") ///2.0的部位 CDSS2PartDR
		{
			s Body=""
			for t=0:1:ItemJson.%Get("stand_body").%Size()-1
			{
				s BodyJson=ItemJson.%Get("stand_body").%Get(t)
				s BodyNow=BodyJson.%Get("name")
				if $d(^CT.WDT.CDSS.BodyPartsDictI("DescIndex"," "_$ZCONVERT(BodyNow,"U")))  ///判断是否部位字典
				{
					s BodyID=$o(^CT.WDT.CDSS.BodyPartsDictI("DescIndex"," "_$ZCONVERT(BodyNow,"U"),0))
					if BodyID'=""
					{
						s Remarks=$lg($g(^CT.WDT.CDSS.BodyPartsDictD(BodyID)),7) //用备注替代部位名称（下肢替代下肢肌）
						s:Remarks'="" BodyNow=Remarks
					}
				}
				
				s:Body'="" Body=Body_"&%"_BodyNow
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
				s:Pos'="" Pos=Pos_"&%"_PosNow
				s:Pos="" Pos=PosNow
			}
		}
		else
		{
			s Pos=""
		}
		
		
		//单位名称是否在单位字典表中，不在则存""
		if RangeUnit'=""
		{
			s UnitID=$o(^CT.WDT.CDSS.UnitDictI("DescIndex"," "_$zconvert(RangeUnit,"U"),0)) //单位字典表
			if UnitID'=""
			{
				s RangeUnit=RangeUnit
			}
			else
			{
				s UnitAliasID=$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.UnitDict",RangeUnit,0)) //别名通用名找，单位字典表 ID
				if UnitAliasID'=""
				{
					s RangeUnit=$lg($g(^CT.WDT.CDSS.UnitDictD(UnitAliasID)),3)  //单位字典表 单位名称
				}
				else
				{
					s RangeUnit=""
				}
			}
		}
		
		//ExamItem必须存体格检查字典表+通用名字典体征类型的数据，不影响整条数据存储
		s Flag=""
		s ID=$o(^CT.WDT.CDSS.PhysicalExamDictI("NameIndex"," "_ExamItem,0))  //体格检查字典判断
		s:ID'="" Flag=$lg($g(^CT.WDT.CDSS.PhysicalExamDictD(ID)),10)
		s:(Flag=0)||(Flag=1) ID=""
		if (ID="")
		{
			s ID=$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.PhysicalExamDict",ExamItem,0))  //别名通用名判断
			if (ID'="")
			{
				s ExamItem=$lg($g(^CT.WDT.CDSS.PhysicalExamDictD(ID)),3)
			}
			else
			{
				s ID=$o(^CT.WDT.CDSS.CommonDictI("TypeDescIndex","3",ExamItem,0))  //通用名字典进行判断
				if (ID="")
				{
					s ID=$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.CommonDict",ExamItem,0))  //别名通用名判断
					if ID'=""
					{
						s ExamItem=$lg($g(^CT.WDT.CDSS.CommonDictD(ID)),4)  //通用名名称
					}
					elseif (ID="")&(ExamItem'=Symptom)
					{
						s ID=$o(^CT.WDT.CDSS.PhysicalExamDictI("NameIndex"," "_Symptom,0))
						s:ID'="" ExamItem=Symptom
						if (ID="")
						{
							s ID=$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.PhysicalExamDict",Symptom,0))
							if ID'="" 
							{
								s ExamItem=$lg($g(^CT.WDT.CDSS.PhysicalExamDictD(ID)),3)
							}
							else
							{
								s ID=$o(^CT.WDT.CDSS.CommonDictI("TypeDescIndex","3",Symptom,0))  //通用名字典进行判断
								s:ID'="" ExamItem=Symptom
								if (ID="")
								{
									s ID=$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.CommonDict",Symptom,0))  //别名通用名判断
									if ID'=""
									{
										s ExamItem=$lg($g(^CT.WDT.CDSS.CommonDictD(ID)),4)  //通用名名称
									}
								}
							} 
						}
					}
				}
			}
		}
		s:ID="" ExamItem=""
		
		if Symptom'=""
		{
			s UserName=..GetMappingUser(FieldName)
			s RecordInserted(UserName,Symptom)=""
		}
		//已有的症状不进行存储
		s InputStr="""Symptom"":"_Symptom_","
		s InputStr=$replace(InputStr,":",":""")
		s InputStr=$replace(InputStr,",",""",")		
		continue:ChildrenResultArray.%ToJSON()[InputStr
		
		s ChildItem={}
		d ChildItem.%Set("SymptomNum","")
		d ChildItem.%Set("Status","")
		d ChildItem.%Set("PartDR",PartDR)
		d ChildItem.%Set("Symptom",Symptom)
		d:ExamItem'="" ChildItem.%Set("ExamItem",ExamItem)
		d ChildItem.%Set("Duration",Duration)
		d ChildItem.%Set("AbnormalMin","")
		d ChildItem.%Set("NormalMax","")
		d ChildItem.%Set("NormalMin","")
		d ChildItem.%Set("CollectionDate","")
		d ChildItem.%Set("SymptomResult",SymptomResult)
		d:RangeUnit'="" ChildItem.%Set("RangeUnit",RangeUnit)
		d ChildItem.%Set("RangeType","")
		d ChildItem.%Set("SymptomFormal",formal)
		d ChildItem.%Set("SymptomCore",core)
		d ChildItem.%Set("SymptomType",Type)
		d ChildItem.%Set("SymProperty",SymProperty)
		d ChildItem.%Set("AbnormalMax",AbnormalMax)
		d ChildItem.%Set("CDSS2PartDR",Body)
		d ChildItem.%Set("PositionWordDR",Pos)
		
		d Children.%Push(ChildItem) 
		d PhysicalJson.%Set("children",Children)
		s AllData=AllData+1
		d ChildrenResultArray.%Push(PhysicalJson)
	}
	
	if (AllData=0)&&(FieldNameNew'="CurrentMedHisSum") //NLP解析不为空但没有满足入库的数据，为了覆盖以前入库的数据
	{
		q:(ChildrenResultArray.%ToJSON()["""DataClass"":""PhysicalExam"",")||(^TEMP("PyhsicalExamSum")=1) "" //不要重复存"空"
		
		s PhysicalJson={}
		d PhysicalJson.%Set("DataClass",..GetMappingUser(FieldName))
		s Children=[]
		s ChildItem={}
		
		d ChildItem.%Set("SymptomNum","")
		d ChildItem.%Set("Status","")
		d ChildItem.%Set("PartDR","")
		d ChildItem.%Set("Symptom","空")
		d ChildItem.%Set("ExamItem","")
		d ChildItem.%Set("Duration","")
		d ChildItem.%Set("AbnormalMin","")
		d ChildItem.%Set("NormalMax","")
		d ChildItem.%Set("NormalMin","")
		d ChildItem.%Set("CollectionDate","")
		d ChildItem.%Set("SymptomResult","")
		d ChildItem.%Set("RangeUnit","")
		d ChildItem.%Set("RangeType","")
		d ChildItem.%Set("SymptomFormal","")
		d ChildItem.%Set("SymptomCore","")
		d ChildItem.%Set("SymptomType","")
		d ChildItem.%Set("SymProperty","")
		d ChildItem.%Set("AbnormalMax","")
		d ChildItem.%Set("CDSS2PartDR","")
		d ChildItem.%Set("PositionWordDR","")
		d Children.%Push(ChildItem) 
		d PhysicalJson.%Set("children",Children)
		d ChildrenResultArray.%Push(PhysicalJson)
	} 
	q ""
}

/// Creator:lideyuan
/// CreatDate:2020-05-19
/// Description：把NLP API中返回的专科检查史json结果处理一下
/// Input：nlp json返回的字符串
/// Output: json
/// w ##class(web.CDSS.MachineLearning.NLPProcessingData).ProcessingNLPSpecDiagString()
ClassMethod ProcessingNLPSpecDiagString(NLPString As %String, FieldName As %String)
{
	if NLPString=""
	{
		q ""
	}
	s SpecJson={}
	s Children=[]
	s DataClass=..GetMappingUser(FieldName)
	q:DataClass="" ""
	d SpecJson.%Set("DataClass",..GetMappingUser(FieldName))
	s NLPArray=[].%FromJSON(NLPString)
	for i=0:1:NLPArray.%Size()-1
	{
		s (Symptom,PartDR)=""
		s ItemJson=NLPArray.%Get(i)
		s Type=""
		s Type=ItemJson.%Get("type")
		if (Type["+")||(Type["-")
		{
			s ItemType=$e(Type,2,*) 
			s Symptom=ItemJson.%Get(ItemType).%Get("name")
		}
		else
		{
			if ItemJson.%IsDefined(Type)   //如果有此Type为key的
			{
				s Symptom=ItemJson.%Get(Type).%Get("name")
			}
			else
			{
				s Symptom=""
			}
			s ItemType=Type
			//s IsPositive="阳性"
		}
		
		if ItemJson.%IsDefined("position")    //部位
		{
			s PartDR=ItemJson.%Get("position").%Get("name")
		}

		
		s ChildItem={}
		d ChildItem.%Set("SymptomNum","")
		d ChildItem.%Set("Status","")
		d ChildItem.%Set("PartDR",PartDR)
		d ChildItem.%Set("Symptom",Symptom)
		d ChildItem.%Set("ExamItem","")
		d ChildItem.%Set("Duration","")
		d ChildItem.%Set("AbnormalMax","")
		d ChildItem.%Set("AbnormalMin","")
		d ChildItem.%Set("NormalMax","")
		d ChildItem.%Set("NormalMin","")
		d ChildItem.%Set("CollectionDate","")
		d ChildItem.%Set("SymptomResult",IsPositive)
		d ChildItem.%Set("RangeUnit","")
		d ChildItem.%Set("RangeType","")
		d Children.%Push(ChildItem) 
	}
	d SpecJson.%Set("children",Children)
	q SpecJson
}

/// Creator:lideyuan
/// CreatDate:2020-05-22
/// Description：把NLP API中返回的病历json结果处理一下
/// Input：nlp json返回的字符串
/// Output: json
/// w ##class(web.CDSS.MachineLearning.NLPProcessingData).ProcessingNLPInpatientInfoString()
ClassMethod ProcessingNLPInpatientInfoString(NLPString As %String, ByRef ChildrenResultArray, ByRef RecordInserted)
{
	if NLPString="[]"
	{
		q ""
	}
	s SpecJson={}
	s Children=[]
	
	//d SpecJson.%Set("DataClass",..GetMappingUser(FieldName))
	s NLPArray=[].%FromJSON(NLPString)
	for i=0:1:NLPArray.%Size()-1
	{
		s (Duration,Type,Desc)=""
		s ItemJson=""
		s ItemJson=NLPArray.%Get(i)
		s Type=ItemJson.%Get("section_type")
		s UserName=..GetMappingUser(Type)
		s Desc=ItemJson.%Get("name")
		if '$d(RecordInserted(UserName,Desc))   //如果此内容不存在json中
		{
 			s TempArray=[]
 			d TempArray.%Push(ItemJson)
 			s TempArrayString=TempArray.%ToJSON()
 			if (Type="主诉") || (Type="现病史")
 			{
 				d ..ProcessingNLPSymptomsString(TempArrayString,Type,.ChildrenResultArray,.RecordInserted)
 			}
 			if Type="既往史"
 			{
	 			d ..ProcessingNLPPastDiagString(TempArrayString,Type,.ChildrenResultArray,.RecordInserted)
	 		}
	 		if Type="家族史"
			{
				d ..ProcessingNLPFamilyDiagString(TempArrayString,Type,.ChildrenResultArray,.RecordInserted)
			}
			if Type="个人史"
			{
				d ..ProcessingNLPPersonalDiagString(TempArrayString,Type,.ChildrenResultArray,.RecordInserted)
			}
			if Type="婚育史"
			{
				d ..ProcessingNLPMarriageDiagString(TempArrayString,Type,.ChildrenResultArray,.RecordInserted)
			}
			if Type="过敏史"
			{
				d ..ProcessingNLPAllergyDiagString(TempArrayString,Type,.ChildrenResultArray,.RecordInserted)
			}
			if Type="体格检查"
			{
				d ..ProcessingNLPPhysicalDiagString(TempArrayString,Type,.ChildrenResultArray,.RecordInserted)
			}		
		}
	}
}

/// Creator:lideyuan
/// CreatDate:2020-05-28
/// Description：查询数据是否在同义词字典中，如果存在则转为标准数据
/// Input：1.是否为基本flag，2.描述Desc
/// Output: 如果存在：则输出标准数据 ；如果不存在：则输出空
/// w ##class(web.CDSS.MachineLearning.NLPProcessingData).TransformStandardDesc("2","男")
ClassMethod TransformStandardDesc(Flag As %String, Desc As %String)
{
	s Result=""
	s Desc=$zstrip(Desc,"<>W")
	if Flag="1" //疾病信息，如果为疾病，则查看是否在疾病字典表中存在，如果存在则不进行同义词转换
	{
		if $d(^CT.WDT.CDSS.DiseaseDictI("NameIndex"," "_$zconvert(Desc,"U")))
		{
			s Result="1"
		}
	}
	elseif Flag="2"    //药品信息，如果为药物，则先查看是否存在药品字典表中，如果存在，则不进行同义词转换
	{
		if $d(^CT.WDT.CDSS.DrugDictI("NameIndex"," "_$zconvert(Desc,"U")))
		{
			s Result="1"
		}
	}
	else  //非疾病信息，直接进行同义词比较
	{
		if $d(^User.DHCDSSSynonymDictI("ItemNameIndex"," "_$zconvert(Desc,"U")))  //是否存在同义词字典表中
		{
			s SDRowid=$o(^User.DHCDSSSynonymDictI("ItemNameIndex"," "_$zconvert(Desc,"U"),0))
			s SDDesc=$lg(^User.DHCDSSSynonymDictD(SDRowid),3)   //获取同义词
			s Result=SDDesc
		}
	}
	q Result
}

/// Creator:lideyuan
/// CreatDate:2020-05-28
/// Description：对NLP结构化之后的数据进行归一化处理
/// Input：NLP处理后的json
/// Output: 对NLP处理后的json进行归一化后的结果
/// w ##class(web.CDSS.MachineLearning.NLPProcessingData).ValueNormalization()
ClassMethod ValueNormalization(PatientInfo As %String)
{
 	if ($e(PatientInfo,1,1)'="[")     //如果入参外层不是列表，就加一层列表
 	{
 		s PatientInfo="["_PatientInfo_"]"
  	}
  	s PatientArray=[].%FromJSON(PatientInfo)
	//s PatientArray=[{"IDNO":"DH001","PatientDR":"te001","VisitID":"1","children":[{"DataClass":"FamilyHisInfo","children":[{"GeneticDiseName":"2型DM"}]},{"DataClass":"CarryDrug","children":[{"DrugName":"VitA"}]},{"DataClass":"PatientMaster","children":[{"MedicareCardNum":"620","IDCardNumber":"620503199901017676","Name":"测试患者","Sex":"男","PhoneNumber":"1234567890"}]},{"DataClass":"InpatientInfo","children":[{"MRNum":"","MRClass":"","MRFileNum":"","MRCode":"","MRDesc":"姓名：张三  出生地：临沂市 性别：女 职业：工人 年龄：28岁  入院日期：2016-11-26 08:49:30 民族：汉族   记录日期：2016-11-26 15:13:04 婚姻：未婚         病史陈述人：患者本人 主诉：多饮、多尿、体重增加20天，发现血糖高4天。 现病史：患者20天前无明显诱因出现多饮、多尿，夜尿4-5次，伴体重增加，约6斤，伴面部及腹部明显增胖、淡红色条纹，且面部及躯干出现较多，伴手抖、心慌，伴有全身乏力、视线模糊，伴双下肢、左膝关节、左髋关节及腰背疼、手足麻木、手脚抽筋及月经量减少，无咳嗽、咳痰，无发热，无胸闷、憋喘，无恶心、呕吐、无腰痛、腹泻，无头晕、头痛，无长期服药史，未治疗，4天前出现咳嗽、咳痰，无发热，于当地医院静滴抗感染药物（具体不详）治疗后好转，4天前于当地查血糖高，空腹血糖21mol/L，后复查空腹血糖18mol/L，自行饮食控制。2天前于当地医院住院检查，行双侧肾上腺CT平扫及胸部CT平扫示，余未见异常，垂体MRI未见异常，性腺六项：雌二醇：5.46pg/ml，睾酮：0.025nmol/l，孕酮：0.3ng/ml，泌乳素579.30umol/L，促黄体生成素6.0mIu/ml，促卵泡生成素：5.77mIu/ml，未治疗。今为系统诊疗入院。 患者自发病以来，神志清，精神可，饮食可，睡眠较差，小便次数增多，夜尿4-5次，大便干结，体重增加6斤。既往史：平素健康状况良好。否认高血压病史。否认糖尿病病史。否认冠心病病史。否认慢性支气管炎病史。否认胆结石病史。否认胆囊炎病史。否认传染病史。预防接种史按规定。否认手术外伤史。否认输血史。否认食物史。个人史：出生于原籍，生长于原籍。否认吸烟史；否认饮酒史。否认药物嗜好。否认疫水疫区接触史。无工业毒物、粉尘、放射性物质接触史。无夜游史。月经史：14 2-3/40 2016.10.28。经量少，经期规则，无痛经。婚育史：已婚，未育。家族史：父母婚配；非近亲；家族中否认类似患者。否认家族遗传性病史。体格检查：T37.3℃    P118次/分     R18次/分    WT69kg   BP117/83mmHg    H160cm一般情况尚可，神志清，营养中等，发育正常，体检合作，对答切题，全身皮肤、巩膜无黄染、皮疹及出血点，头颅、五官正常，双瞳孔大小、形态对称，对光反射存在，双眼球活动正常，耳廓正常，外耳道无分泌物，口腔黏膜正常，伸舌居中，咽部、扁桃体无充血，颈软，未见怒张静脉，气管居中，甲状腺不大，胸廓对称，无压痛、红肿，触诊语颤正常，叩诊清音，双肺呼吸音清，未闻及干、湿性啰音及胸膜摩擦音。心前区搏动正常，有力，心脏浊音界不大，心率114次/分，律齐，个瓣膜听诊区未闻及杂音，腹平软，无压痛，未见曲张静脉，肝、脾肋骨下未扪及肿大，未扪及异常腹部包块，肝、肾区无叩击痛，移动性浊音<->，肠鸣音正常。肛门及外生殖器正常，脊柱及四肢无畸形，活动正常，双下肢无水肿。生理性反射存在，未引出病理性反射。专科检查：意识障碍，呼之无反应，瞬目反射正常。全身多处均见有创面，头部创面浅Ⅱ°改变，面积3%。双小腿下段、双足创面呈黄褐素皮革样改变，可见树枝状，创面呈Ⅲ°改变，面积约13%；余创面呈红白相间，部分见深Ⅱ°改变，面积82%。辅助检查：CT寰枢椎、胸腹未见外伤性改变。止凝血功能及D-二聚体正常：Hs-CRP 2.45mg/L；生化：GLU 7.87mmol/L；血常规：WBC 10.8*10~9/L,NE% 80.30%。余查血未见异常。初步诊断：中医 气滞血瘀西医：1.重型颅脑损伤 3.脑干损伤？4.肺挫伤医师签名：李鹏飞日期：2016-11-26","UpdateDate":"","UpdateRemarks":""}]},{"DataClass":"ExamInfo","children":[{"GroupFlag":"","GroupSequence":"","ExamCode":"","ExamName":"","ExamResultNum":"","ExamResult":"","ExamResultFlag":"","ExamResultDesc":"","PartDR":"","ExecuteTime":"","ReportTime":"","Remarks":"","PassFlag":""},{"GroupFlag":"","GroupSequence":"","ExamCode":"","ExamName":"","ExamResultNum":"","ExamResult":"","ExamResultFlag":"","ExamResultDesc":"","PartDR":"","ExecuteTime":"","ReportTime":"","Remarks":"","PassFlag":""}]},{"DataClass":"PatientVisit","children":[{"VisitType":"门诊","TreatmentTime":"2020-04-29 17:15:30","PastDiagnosisSum":"既往体健,晚期肝癌(病危)，否认“高血压、冠心病、糖尿病”病史,预防接种史不详；否认外伤史；无手术史；无输血史，无药物、食物过敏史","FamilyHisSum":"父母已故,兄弟姐妹健在,有糖尿病家族史","PersonalHisSum":"生于河北正定县,久居于当地,无疫区、疫情、疫水居住史,无牧区、矿山、高氟区、低碘区居住史,无化学性物质、放射物、毒物接触史,无毒品接触史,吸烟史20年,20支/天,戒烟半年,无饮酒史","MenstrualHisSum":"月经初潮13岁","AllergyHisSum":"对药物慢性高度过敏，如青霉素，红霉素，环丙沙星，先锋，感冒药等，常见药物都有过敏反应，对粉尘过敏，对毛发过敏，阑尾炎有发炎的症状","PhysicalExamSum":"T：37.2℃ P:98次/分 R：20次/分 BP：120/80mmHg 一般状况：发育正常；体型匀称，呈正力型；营养良好；意识清楚，查体合作；急性 病容，表情痛苦；强迫左侧卧位，右手按压左侧胸部；步态无异常,皮肤粘膜色泽正<br/>常，无发红、苍白、发绀、黄染、色素沉着、色素脱失；皮肤湿润，弹性好；未见皮疹及皮肤脱屑；无皮下出血、蜘蛛痣、水肿、皮下结节，无溃疡、糜烂及瘢痕；毛发<br/>的性状及分布无异常。左侧颌下触及2个约1.2*1.0cm肿大淋巴结，表面光滑，活动、轻度压痛，边界清晰，局部皮肤无红肿、瘢痕、瘘管。余部浅表淋巴结未触及肿大。<br/><br/>头部：外形正常，头发黑色，分布均匀；无异常活动。视力正常；眉毛分布均匀；眼<br/>睑无水肿、无上睑下垂；上下泪点无红肿、无异常分泌物；睑结膜轻度充血，未见出<br/>血点；巩膜轻度黄染；角膜透明，未见溃疡；瞳孔双侧等大等圆，直径3mm，瞳孔<br/>直接对光反射存在；瞳孔间接对光反射存在；集合反射正常；双侧眼球突出，Stellwag征、Graefe征、Mobius征和Joffroy征阳性；眼球运动正常，无眼球震颤","SpecExamSum":"步态、肌力（0～5级）、肌营养状态、肌张力、共济运动[指鼻试验、运动轮替试验、跟膝胫试验、罗姆伯格（Romberg）征]、不自主运动"}]}]}]
	s ResultArray=[].%FromJSON(PatientArray.%ToJSON())
	k RecordInserted   //用来记录新增了哪些数据，在病历nlp处理的时候可以用来比较
	for i=0:1:PatientArray.%Size()-1   //遍历第一层列表
	{
		s PatientJson=PatientArray.%Get(i)
		s ResultJson=ResultArray.%Get(i)
		k key
		k value
		s IDNO=PatientJson.%Get("IDNO")
		s VisitID=PatientJson.%Get("VisitID")
		s PatientDR=PatientJson.%Get("PatientDR")
		s PatientIterator=PatientJson.%GetIterator()     //遍历第一层{}
		while PatientIterator.%GetNext(.key,.value)
		{
			if key="children"    //如果键值对中的键为"children"
			{
				s ChildrenArray=PatientJson.%Get("children")       //包含表名的children
				s ChildrenResultArray=ResultJson.%Get("children")
				for j=0:1:(ChildrenArray.%Size()-1)
				{ 
					s ChildrenJson=ChildrenArray.%Get(j)
					s ChildrenResultJson=ChildrenResultArray.%Get(j)
					//s TableName="WDT.CDSS."_ChildrenJson.%Get("DataClass")   //字段所属表名
					//if TableName="WDT.CDSS.PatientMaster"    //如果为基本信息表
					//{
					s GrandChildrenArray=ChildrenJson.%Get("children")
					s GrandChildrenResultArray=ChildrenResultJson.%Get("children")
					for k=0:1:GrandChildrenArray.%Size()-1      //遍历children的每一个键值对
					{
						s GrandChildren=GrandChildrenArray.%Get(k)
						s GrandChildrenResult=GrandChildrenResultArray.%Get(k)
						k fieldkey
						k fieldvalue    //清空数据，以防数据窜值
						
						s FieldNameIterator=GrandChildren.%GetIterator()
						while FieldNameIterator.%GetNext(.fieldkey,.fieldvalue)    //遍历当前键值对的key value
						{
							continue:fieldvalue=""
							if ((fieldkey="PastDiagnosisName")||(fieldkey="GeneticDiseName")||(fieldkey="DiagnosisName")||(fieldkey="IntraoperDiagnosis"))   //疾病类字段要先走疾病字典表
							{
								s StandardValue=..TransformStandardDesc("1",fieldvalue)
								if StandardValue="1"  //如果在字典表中找到数据，则不改动
								{
									continue
								}
							}
							
							if ((fieldkey="DrugName"))  //如果为药物，则去药物字典表去查询
							{
								s StandardValue=..TransformStandardDesc("2",fieldvalue)
								if StandardValue="1"  //如果在字典表中找到数据，则不改动
								{
									continue
								}
							}
							
							if ((fieldkey="DrugName")||(fieldkey="PastDiagnosisName")||(fieldkey="GeneticDiseName")||(fieldkey="DiagnosisName")||(fieldkey="IntraoperDiagnosis")||(fieldkey="Sex")||(fieldkey="Profession")||(fieldkey="BloodGroup")||(fieldkey="Symptom")||(fieldkey="PartDR")||(fieldkey="PersonalHistoryOverview")||(fieldkey="Criticality")||(fieldkey="TypeOfMarriage")||(fieldkey="AllergySourceName")||(fieldkey="AllergySourceType")||(fieldkey="RiskLevel")||(fieldkey="DrugName")||(fieldkey="ExamName")||(fieldkey="InspectionName")||(fieldkey="LabItemName")||(fieldkey="OperName")||(fieldkey="")||(fieldkey="NursingItemName")||(fieldkey="ChildItemName")||(fieldkey="BloodTransType")||(fieldkey="DietMethod"))  //如果该字段不是疾病
							{
								s StandardValue=..TransformStandardDesc("3",fieldvalue)
								if StandardValue'=""    //如果有同义词转换的数据
								{
									d GrandChildrenResult.%Set(fieldkey,StandardValue)
								}
							}
						}
					}
					//}
				}
			}
		}
	}
	q ResultArray.%ToJSON()
}

/// Creator:wuzhe
/// CreatDate:2022-06-03
/// Description：查看症状名称是否存在2.0的症状字典(2.0)/诊断因子字典(2.0)/疾病字典/中医疾病字典中
/// Input：症状名称
/// Output: 1 存在   0 不存在
/// w ##class(web.CDSS.MachineLearning.NLPProcessingData).ExistSymptom("痛经进行性加重")
ClassMethod ExistSymptom(Symptom As %String) As %String
{
	q:Symptom="" 0
	s Symptom=$zstrip(Symptom,"<>W")
	s SymptomU=$ZCONVERT(Symptom,"U")
	//症状字典2.0+诊断因子字典库2.0判断是否存在 
	if ($d(^CT.WDT.CDSS.DiagFactorBaseI("NameIndex"," "_SymptomU))||$d(^CT.WDT.CDSS.SymptomDictI("DescIndex"," "_SymptomU)))
	{
		s Result=1

    }
    //疾病字典+中医疾病字典
    elseif($d(^CT.WDT.CDSS.DiseaseDictI("NameIndex"," "_SymptomU))||$d(^CT.WDT.CDSS.TCMDiseaseI("NameIndex",SymptomU)))
    {
	    s Result=1
	}
	//体格检查字典
	elseif $d(^CT.WDT.CDSS.PhysicalExamDictI("NameIndex"," "_SymptomU))
	{
		s Result=1
	}
    else
    {
		s Result=0   
	}
	
	q Result
}

/// Creator:wuzhe
/// CreatDate:2021-08-07
/// Description：提取主诉过NLP后的解析内容
/// Input：nlp json返回的字符串
/// Output: json
/// w ##class(web.CDSS.MachineLearning.NLPProcessingData).CollectChiefToNLP("[{'type':'+symptom','name':'腹痛','position':{'name':'腹'},'symptom':{'name':'痛'},'incentive':{'name':'餐后'},'formal':'腹痛','core':'腹部不适'}]","ChiefCompSum","[]","")
/// w ##class(web.CDSS.MachineLearning.NLPProcessingData).CollectChiefToNLP("[]","ChiefCompSum","[]","")
/// {'type':'+symptom','name':'腹痛','position':{'name':'腹'},'symptom':{'name':'痛'},'incentive':{'name':'餐后'},'formal':'腹痛','core':'腹部不适'}
ClassMethod CollectChiefToNLP(NLPString As %String, FieldName As %String, ByRef ChildrenResultArray, ByRef RecordInserted) As %String
{
	/*///新加
	s Result=""
	s NLPString=$REPLACE(NLPStringOld,"'","""")
	s ChildrenResultArray=[].%FromJSON(ChildrenResultArrayOld)*/
	
	if NLPString="[]"
	{
		s SymptomJson={}
		s DataClass=..GetMappingUser(FieldName)
		d SymptomJson.%Set("DataClass",DataClass)
		s Children=[]
		s ChildItem={}
		d ChildItem.%Set("SymptomNum","")
		d ChildItem.%Set("PartDR","")
		d ChildItem.%Set("Symptom","空")
		d ChildItem.%Set("Duration","")
		d ChildItem.%Set("AbnormalMax","")
		d ChildItem.%Set("AbnormalMin","")
		d ChildItem.%Set("NormalMax","")
		d ChildItem.%Set("NormalMin","")
		d ChildItem.%Set("RangeUnit","")
		d ChildItem.%Set("RangeType","")
		d ChildItem.%Set("Cause","")
		d ChildItem.%Set("SymptomResult","")
		
		///新加
		d ChildItem.%Set("SymptomType","")
		d ChildItem.%Set("SymptomFormal","")
		d ChildItem.%Set("SymptomCore","")
		d ChildItem.%Set("SymProperty","")
		
	    d ChildItem.%Set("RangeUnit","")
		
		d Children.%Push(ChildItem)
		d SymptomJson.%Set("children",Children)
		d ChildrenResultArray.%Push(SymptomJson)
		
		///新加
		s Result=ChildrenResultArray.%ToJSON()
		///q Result
		q ""
	}
	
	s NLPArray=[].%FromJSON(NLPString)
	for i=0:1:NLPArray.%Size()-1
	{
		s DataClass=..GetMappingUser(FieldName)
		continue:DataClass=""
		//d SymptomJson.%Set("DataClass",..GetMappingUser(FieldName))
		s ItemJson=NLPArray.%Get(i)
		s IsPositiveFlag=ItemJson.%Get("type")
		if (IsPositiveFlag["+")||(IsPositiveFlag["-")
		{
			s IsPositive=$e(ItemJson.%Get("type"),1,1)   //用来取阴性和阳性
			s IsPositive=$case(IsPositive,"+":"阳性","-":"阴性")
		}
		else
		{
			s IsPositive="阳性"
		}
		continue:IsPositive="阴性"
		
		s (ValueSymptom,Value)=""
		///没单位类型的检查检验结果提取内容  例：结核性胸腔积液（检验结果）
		if ((IsPositiveFlag="Ris")||(IsPositiveFlag="Lis")||(IsPositiveFlag["ris")||(IsPositiveFlag["lis")) 
		{
			s:(IsPositiveFlag="Ris")||(IsPositiveFlag["ris") Field="ris"
			s:(IsPositiveFlag="Lis")||(IsPositiveFlag["lis") Field="lis"
			
			if ItemJson.%IsDefined(Field_"_name")
			{
				s ValueSymptom=ItemJson.%Get(Field_"_name").%Get("name")
			}
			if ItemJson.%IsDefined(Field_"_result")
			{
				s ResultArrayType=ItemJson.%GetTypeOf(Field_"_result")
				s RisLisArray=ItemJson.%Get(Field_"_result")
				
				if ResultArrayType="array"   //如果值是一个数组
				{
					//s ResultArraySize=ResultArrayType.%Size()
					s ResultArraySize=RisLisArray.%Size()
					for j=0:1:ResultArraySize-1
					{
						//s:Value'="" Value=Value_ResultArraySize.%Get(j).%Get("name")
						s:Value'="" Value=Value_RisLisArray.%Get(j).%Get("name")
						//s:Value="" Value=ResultArraySize.%Get(j).%Get("name")
						s:Value="" Value=RisLisArray.%Get(j).%Get("name")
					}
				}
				else   //如果值只是一个{}
				{
					s Value=ItemJson.%Get(Field_"_result").%Get("name")
				}
			}
		}
		
		if ItemJson.%IsDefined("position")    //如果存在部位的信息则取值1.0
		{
			s Part=ItemJson.%Get("position").%Get("name")   //部位
			s:..GetMappingPosition(Part)'="" Part=..GetMappingPosition(Part)
		}
		else    //如果不存在部位信息，则要赋值为空
		{ 
			s Part=""
		}
		
		///新加
		if (ItemJson.%IsDefined("formal"))&&(ItemJson.%Get("formal")'=ItemJson.%Get("name"))
		{
			s formal=ItemJson.%Get("formal") ///归一词
		}
		else
		{
			s formal=""
		}
		
		if (ItemJson.%IsDefined("core"))&&(ItemJson.%Get("core")'=ItemJson.%Get("name"))
		{
			s core=ItemJson.%Get("core")  ///上位词
			s core=$replace(core,"、","&%")
		}
		else
		{
			s core=""
		}
		
		s Name=ItemJson.%Get("name")   //获取症状名称
		s NameFlag=0
		s NameFlag=..ExistSymptom(Name) //是否存在neo4j中
		
		s OutcomePreFlag=0
		s OutcomeSubFlag=0
		if ItemJson.%IsDefined("outcome")
		{
			s Outcome=ItemJson.%Get("outcome").%Get("name")
			s OutcomePreName=Name_Outcome
			
			s OutcomePreFlag=..ExistSymptom(OutcomePreName)
			s OutcomeSubName=Outcome_Name
			s OutcomeSubFlag=..ExistSymptom(OutcomeSubName)
		}
		k UserName
		s UserName=..GetMappingUser(FieldName)
		
		s RecordInserted(UserName,Name)=""
		
		//Duration字段有last_tiem优先存，没有则存happen_time
		if ItemJson.%IsDefined("last_time")
		{
			s Duration=ItemJson.%Get("last_time").%Get("name") //获取持续时长
			s Duration=..DealLastTime(Duration)   ///处理持续时间并进行单位转换（时）
		}
		else
		{
			if ItemJson.%IsDefined("happen_time")
			{
				s Duration=ItemJson.%Get("happen_time").%Get("name")
				s Duration=..DealHappentime(Duration) ///处理开始时间并进行单位转换（时）
			}
			else
			{
				s Duration=""
			}
		}
		
		///属性：用&%拼接level，frequency，nature，day_time，incentive内容
		s SymProperty=""
		if ItemJson.%IsDefined("level")
		{
			//s Level=ItemJson.%Get("level").%Get("name")  //程度
			s LevelValue=ItemJson.%Get("level") //程度
			s LevelType=ItemJson.%GetTypeOf("level")
			if LevelType="array"   //如果值是一个数组
			{
				s LevelArraySize=LevelValue.%Size()
				s Level=""
				for LeSize=0:1:LevelArraySize-1
				{
					s:Level'="" Level=Level_"&%"_LevelValue.%Get(LeSize).%Get("name")
					s:Level="" Level=LevelValue.%Get(LeSize).%Get("name")
				}
			}
			else   //如果值只是一个{}
			{
				s Level=LevelValue.%Get("name") //程度
			}
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
			///nature的格式区别于level和frequency，"[...]"格式
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
		
		if ItemJson.%IsDefined("incentive")
		{
			s Incentive=ItemJson.%Get("incentive").%Get("name")  //诱因
			s:SymProperty'="" SymProperty=SymProperty_"&%"_Incentive
			s:SymProperty="" SymProperty=Incentive
			
			//诱因/病因识别词维护时取自 诱因/病因，定语字典
			s PathogenyID=$o(^CT.WDT.CDSS.PathogenyDictI("DescIndex"," "_$ZCONVERT(Incentive,"U"),0)) ///诱因/病因字典
			if PathogenyID=""
			{
				s PathogenyID=$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.PathogenyDict",$ZCONVERT(Incentive,"U"),0)) ///别名通用名
				if PathogenyID="" //不在诱因字典，也不是诱因字典的别名
				{
					s AttributeID=$o(^CT.WDT.CDSS.AttributeDictI("DescIndex"," "_$ZCONVERT(Incentive,"U"),0)) ///定语字典
					if AttributeID="" //不在定语字典，也不是定语字典的别名
					{
						s AttributeID=$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.AttributeDict",$ZCONVERT(Incentive,"U"),0)) ///别名通用名
						s:AttributeID="" Incentive=""
						s:AttributeID'="" Incentive=$lg($g(^CT.WDT.CDSS.AttributeDictD(AttributeID)),3)
					}
				}
				else
				{
					s Incentive=$lg($g(^CT.WDT.CDSS.PathogenyDictD(PathogenyID)),3)
				}
			}
		}
		else
		{
			s Incentive=""
		}
		
		//疾病类型数据的肿瘤分期属性
		if ItemJson.%IsDefined("tnm")&&(IsPositiveFlag["disease")
		{
			s TNM=ItemJson.%Get("tnm").%Get("name")
			if TNM'=""
			{
				s:SymProperty'="" SymProperty=SymProperty_"&%"_TNM
				s:SymProperty="" SymProperty=TNM
			}
		}
		
		//症状的值
		s AbnormalMax=""
		s RangeUnit=""
		if ItemJson.%IsDefined("value")
		{
			s AbnormalMax=ItemJson.%Get("value").%Get("name")  //症状的值
		}
		//值的单位
		if ItemJson.%IsDefined("unit")
		{
			s RangeUnit=ItemJson.%Get("unit").%Get("name")  //值的单位
			//单位名称是否在单位字典表中，不在则存""
			s UnitID=$o(^CT.WDT.CDSS.UnitDictI("DescIndex"," "_$zconvert(RangeUnit,"U"),0))
			if UnitID'=""
			{
				s RangeUnit=RangeUnit
			}
			else
			{
				s UnitAliasID=$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.UnitDict",RangeUnit,0)) //单位字典表 ID
				if UnitAliasID'=""
				{
					s RangeUnit=$lg($g(^CT.WDT.CDSS.UnitDictD(UnitAliasID)),3)  //单位字典表 单位名称
				}
				else
				{
					s RangeUnit=""
				}
			}
			//s:RangeUnit="毫升" RangeUnit="ml"
		}
		
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
		
		if NameFlag="1"
		{
			s SymptomJson={}
			s Children=[]
			d SymptomJson.%Set("DataClass",..GetMappingUser(FieldName))
			s ChildItem={}
			d ChildItem.%Set("SymptomNum","")
			d ChildItem.%Set("PartDR",Part)
			d ChildItem.%Set("Symptom",Name)
			d ChildItem.%Set("Duration",Duration)
			d ChildItem.%Set("AbnormalMax","")
			d ChildItem.%Set("AbnormalMin","")
			d ChildItem.%Set("NormalMax","")
			d ChildItem.%Set("NormalMin","")
			d ChildItem.%Set("RangeUnit","")
			d ChildItem.%Set("RangeType","")
			d ChildItem.%Set("Cause",Incentive)
			d ChildItem.%Set("SymptomResult",IsPositive)
			if FieldName="CurrentMedHisSum"
			{
				d ChildItem.%Set("Status","")	
			}
			
			///新加
			d ChildItem.%Set("SymptomFormal",formal)
			d ChildItem.%Set("SymptomCore",core)
			d ChildItem.%Set("SymptomType",IsPositiveFlag)
			d ChildItem.%Set("SymProperty",SymProperty)
			d ChildItem.%Set("AbnormalMax",AbnormalMax)
			d ChildItem.%Set("RangeUnit",RangeUnit)
			d ChildItem.%Set("CDSS2PartDR",Body)
			d ChildItem.%Set("PositionWordDR",Pos)
			
			d Children.%Push(ChildItem)
			d SymptomJson.%Set("children",Children)
			d ChildrenResultArray.%Push(SymptomJson)
			
			///新加
		    s Result=ChildrenResultArray.%ToJSON()
		    //w Result,!
		}
		elseif OutcomePreFlag="1"
		{
			s SymptomJson={}
			s Children=[]
			d SymptomJson.%Set("DataClass",..GetMappingUser(FieldName))
			s ChildItem={}
			d ChildItem.%Set("SymptomNum","")
			d ChildItem.%Set("PartDR",Part)
			d ChildItem.%Set("Symptom",OutcomePreName)
			d ChildItem.%Set("Duration",Duration)
			d ChildItem.%Set("AbnormalMax","")
			d ChildItem.%Set("AbnormalMin","")
			d ChildItem.%Set("NormalMax","")
			d ChildItem.%Set("NormalMin","")
			d ChildItem.%Set("RangeUnit","")
			d ChildItem.%Set("RangeType","")
			d ChildItem.%Set("Cause",Incentive)
			d ChildItem.%Set("SymptomResult",IsPositive)
			///新加
			d ChildItem.%Set("SymptomFormal",formal)
			d ChildItem.%Set("SymptomCore",core)
			d ChildItem.%Set("SymptomType",IsPositiveFlag)
			d ChildItem.%Set("SymProperty",SymProperty)
			d ChildItem.%Set("AbnormalMax",AbnormalMax)
			d ChildItem.%Set("RangeUnit",RangeUnit)
			d ChildItem.%Set("CDSS2PartDR",Body)
			d ChildItem.%Set("PositionWordDR",Pos)
			
			if FieldName="CurrentMedHisSum"
			{
				d ChildItem.%Set("Status","")	
			}
			d Children.%Push(ChildItem)
			d SymptomJson.%Set("children",Children)
			d ChildrenResultArray.%Push(SymptomJson)
		}
		
		elseif OutcomeSubFlag="1"
		{
			s SymptomJson={}
			s Children=[]
			d SymptomJson.%Set("DataClass",..GetMappingUser(FieldName))
			s ChildItem={}
			d ChildItem.%Set("SymptomNum","")
			d ChildItem.%Set("PartDR",Part)
			d ChildItem.%Set("Symptom",OutcomeSubName)
			d ChildItem.%Set("Duration",Duration)
			d ChildItem.%Set("AbnormalMax","")
			d ChildItem.%Set("AbnormalMin","")
			d ChildItem.%Set("NormalMax","")
			d ChildItem.%Set("NormalMin","")
			d ChildItem.%Set("RangeUnit","")
			d ChildItem.%Set("RangeType","")
			d ChildItem.%Set("Cause",Incentive)
			d ChildItem.%Set("SymptomResult",IsPositive)
			///新加
			d ChildItem.%Set("SymptomFormal",formal)
			d ChildItem.%Set("SymptomCore",core)
			d ChildItem.%Set("SymptomType",IsPositiveFlag)
			d ChildItem.%Set("SymProperty",SymProperty)
			d ChildItem.%Set("AbnormalMax",AbnormalMax)
			d ChildItem.%Set("RangeUnit",RangeUnit)
			d ChildItem.%Set("CDSS2PartDR",Body)
			d ChildItem.%Set("PositionWordDR",Pos)
			
			if FieldName="CurrentMedHisSum"
			{
				d ChildItem.%Set("Status","")	
			}
			d Children.%Push(ChildItem)
			d SymptomJson.%Set("children",Children)
			d ChildrenResultArray.%Push(SymptomJson)
		}
		else
		{
			///实体不在neo4j中，判断归一词是否在neo4j中
			s NameFormalFlag=0 ///归一词是否在neo4j标志
			s:formal'="" NameFormalFlag=..ExistSymptom(formal)
			if NameFormalFlag="1"
			{
				s SymptomJson={}
				s DataClass=..GetMappingUser(FieldName)
				d SymptomJson.%Set("DataClass",DataClass)
				s Children=[]
				s ChildItem={}
				d ChildItem.%Set("SymptomNum","")
				d ChildItem.%Set("PartDR","")
				d ChildItem.%Set("Symptom","空")
				d ChildItem.%Set("Duration","")
				d ChildItem.%Set("AbnormalMax","")
				d ChildItem.%Set("AbnormalMin","")
				d ChildItem.%Set("NormalMax","")
				d ChildItem.%Set("NormalMin","")
				d ChildItem.%Set("RangeUnit","")
				d ChildItem.%Set("RangeType","")
				d ChildItem.%Set("Cause",Incentive)
				d ChildItem.%Set("SymptomResult","")
				
				///新加
				d ChildItem.%Set("SymptomFormal",formal)
				d ChildItem.%Set("SymptomCore",core)
				d ChildItem.%Set("SymptomType",IsPositiveFlag)
				d ChildItem.%Set("SymProperty",SymProperty)
				d ChildItem.%Set("AbnormalMax",AbnormalMax)
				d ChildItem.%Set("RangeUnit",RangeUnit)
				d ChildItem.%Set("CDSS2PartDR",Body)
				d ChildItem.%Set("PositionWordDR",Pos)
				
				d Children.%Push(ChildItem)
				d SymptomJson.%Set("children",Children)
				d ChildrenResultArray.%Push(SymptomJson)
			}
			else
			{
				///实体不在neo4j中，归一词不在neo4j中，判断上位词是否在neo4j中，上位词有多个的情况谁在存谁
				s NameCoreFlag=0 ///上位词是否在neo4j标志
				s CoreDeal=""
				s:(core'="")&(core'["、") NameCoreFlag=..ExistSymptom(formal) ///一个上位词
				if (core'="")&(core["&%") ///多个上位词，用"&%"分隔的
				{
					s Lennum=$l(core,"&%")
					for v=1:1:Lennum
					{
						s CoreNow=$p(core,"&%",v)
						s CoreNowFlag=0
						s CoreNowFlag=..ExistSymptom(CoreNow) 
						s:(CoreDeal'="")&(CoreNowFlag="1") CoreDeal=CoreDeal_"&%"_CoreNow
						s:(CoreDeal="")&(CoreNowFlag="1") CoreDeal=CoreNow
					}
					s:CoreDeal'="" NameCoreFlag="1"
				}
				
				if NameCoreFlag="1"
				{
					s:CoreDeal'="" core=CoreDeal
					
					s SymptomJson={}
					s DataClass=..GetMappingUser(FieldName)
					d SymptomJson.%Set("DataClass",DataClass)
					s Children=[]
					s ChildItem={}
					d ChildItem.%Set("SymptomNum","")
					d ChildItem.%Set("PartDR","")
					d ChildItem.%Set("Symptom","空")
					d ChildItem.%Set("Duration","")
					d ChildItem.%Set("AbnormalMax","")
					d ChildItem.%Set("AbnormalMin","")
					d ChildItem.%Set("NormalMax","")
					d ChildItem.%Set("NormalMin","")
					d ChildItem.%Set("RangeUnit","")
					d ChildItem.%Set("RangeType","")
					d ChildItem.%Set("Cause",Incentive)
					d ChildItem.%Set("SymptomResult","")
					
					///新加
					d ChildItem.%Set("SymptomFormal","空")
					d ChildItem.%Set("SymptomCore",core)
					d ChildItem.%Set("SymptomType",IsPositiveFlag)
					d ChildItem.%Set("SymProperty",SymProperty)
					d ChildItem.%Set("AbnormalMax",AbnormalMax)
					d ChildItem.%Set("RangeUnit",RangeUnit)
					d ChildItem.%Set("CDSS2PartDR",Body)
					d ChildItem.%Set("PositionWordDR",Pos)
					
					d Children.%Push(ChildItem)
					d SymptomJson.%Set("children",Children)
					d ChildrenResultArray.%Push(SymptomJson)
				}
				/*else
				{
					s SymptomJson={}
					s DataClass=..GetMappingUser(FieldName)
					d SymptomJson.%Set("DataClass",DataClass)
					s Children=[]
					s ChildItem={}
					d ChildItem.%Set("SymptomNum","")
					d ChildItem.%Set("PartDR","")
					d ChildItem.%Set("Symptom","空")
					d ChildItem.%Set("Duration","")
					d ChildItem.%Set("AbnormalMax","")
					d ChildItem.%Set("AbnormalMin","")
					d ChildItem.%Set("NormalMax","")
					d ChildItem.%Set("NormalMin","")
					d ChildItem.%Set("RangeUnit","")
					d ChildItem.%Set("RangeType","")
					d ChildItem.%Set("Cause","")
					d ChildItem.%Set("SymptomResult","")
					
					///新加
					d ChildItem.%Set("SymptomFormal","")
					d ChildItem.%Set("SymptomCore","")
					d ChildItem.%Set("SymptomType","")
					d ChildItem.%Set("SymProperty","")
					
					d Children.%Push(ChildItem)
					d SymptomJson.%Set("children",Children)
					d ChildrenResultArray.%Push(SymptomJson)
				}*/
			}
			
			/*s SymptomJson={}
			s DataClass=..GetMappingUser(FieldName)
			d SymptomJson.%Set("DataClass",DataClass)
			s Children=[]
			s ChildItem={}
			d ChildItem.%Set("SymptomNum","")
			d ChildItem.%Set("PartDR","")
			d ChildItem.%Set("Symptom","空")
			d ChildItem.%Set("Duration","")
			d ChildItem.%Set("AbnormalMax","")
			d ChildItem.%Set("AbnormalMin","")
			d ChildItem.%Set("NormalMax","")
			d ChildItem.%Set("NormalMin","")
			d ChildItem.%Set("RangeUnit","")
			d ChildItem.%Set("RangeType","")
			d ChildItem.%Set("Cause","")
			d ChildItem.%Set("SymptomResult","")
			d Children.%Push(ChildItem)
			d SymptomJson.%Set("children",Children)
			d ChildrenResultArray.%Push(SymptomJson)*/
		}
		//d SymptomJson.%Set("children",Children)
		//d ChildrenResultArray.%Push(SymptomJson)
		
		///没单位类型的检查检验结果存到辅助检查检查检验表中，结果不能为""  例：结核性胸腔积液（检验结果）
		if (Value'="")&((IsPositiveFlag="Ris")||(IsPositiveFlag["Lis")||(IsPositiveFlag["ris")||(IsPositiveFlag["lis"))
	    {
		    //此处归一词不置为 ""  because:存在辅助检验检查表中
		    s:(ItemJson.%IsDefined("formal"))&(ItemJson.%Get("formal")=ItemJson.%Get("name")) formal=ItemJson.%Get("formal")
		    
		    //名称(ValueSymptom)用，检查字典，检验项目字典，检验医嘱字典判断是否存在，不存在置""
		    //结果(Value)用，检查结果字典，检验结果字典判断是否存在，不存在不存
		    s (ID,ResultID)="" //防止NLP解析出奇怪类型，导致ID没定义报错
		    if ((IsPositiveFlag="Ris")||(IsPositiveFlag["ris"))
		    {
			    if (ValueSymptom'="")
			    {
				    s ID=$o(^CT.WDT.CDSS.ExamDictI("NameIndex"," "_ValueSymptom,0))  //检查字典
				    if ID=""
				    {
					    s ID=$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.ExamDict",ValueSymptom,0)) //别名通用名
					    s:ID'="" ValueSymptom=$lg($g(^CT.WDT.CDSS.ExamDictD(ID)),4) //检查项目名称
					}
				}
			    
			    s ResultID=$o(^CT.WDT.CDSS.ExamResultDictI("DescIndex"," "_Value,0))  //检查结果字典
			    if ResultID=""
			    {
				    s ResultID=$o(^CT.WDT.CDSS.ExamResultDictI("DescIndex"," "_Name,0))  //实体（Name）去找检查结果字典
				    s:ResultID'="" Value=Name
				}
			}
		    elseif ((IsPositiveFlag["Lis")||(IsPositiveFlag["lis"))
		    {
			    if (IsPositiveFlag="Lis_Order")&(ValueSymptom'="") //检验医嘱
			    {
				    s ID=$o(^CT.WDT.CDSS.LabOrdersDictI("DescIndex"," "_ValueSymptom,0))  //检验医嘱字典
		    		if ID=""
		    		{
			    		s ID=$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.LabOrdersDict",ValueSymptom,0)) //别名通用名
			    		s:ID'="" ValueSymptom=$lg($g(^CT.WDT.CDSS.LabOrdersDictD(ID)),3) //检验医嘱描述
			    	}
				}
				elseif (ValueSymptom'="")
				{
					s ID=$o(^CT.WDT.CDSS.LabInspectionDictI("NameIndex"," "_ValueSymptom,0))  //检验项目字典
			    	if ID=""
				    {
					    s ID=$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.LabInspectionDict",ValueSymptom,0)) //别名通用名
					    s:ID'="" ValueSymptom=$lg($g(^CT.WDT.CDSS.LabInspectionDictD(ID)),4) //检验项目名称
					}
				}
				
				s ResultID=$o(^CT.WDT.CDSS.LabResultDictI("DescIndex"," "_Value,0))  //检验结果字典
				if ResultID=""
			    {
				    s ResultID=$o(^CT.WDT.CDSS.LabResultDictI("DescIndex"," "_Name,0))  //实体（Name）去找检验结果字典
				    s:ResultID'="" Value=Name
				}
			}
			s:ID="" ValueSymptom=""
			continue:ResultID=""
			
		    
		    s SymptomJson={}
			s Children=[]
			s FieldNameNew="LabExamInfo"
			
			d SymptomJson.%Set("DataClass",..GetMappingUser(FieldNameNew))
			s ChildItem={}
			
			d ChildItem.%Set("CheckName",ValueSymptom) //名称
			d ChildItem.%Set("CheckFormal",formal)
			d ChildItem.%Set("CheckType",IsPositiveFlag)
			d ChildItem.%Set("CheckValue",Value)  //值
			d ChildItem.%Set("SymProperty",SymProperty)
			d ChildItem.%Set("CDSS2PartDR",Body)
			d ChildItem.%Set("PositionWordDR",Pos)
			d ChildItem.%Set("ProjectName",ValueSymptom)
			
			d Children.%Push(ChildItem)
			d SymptomJson.%Set("children",Children)
			d ChildrenResultArray.%Push(SymptomJson)
		}
		
		//对应主诉中的 孕37周待产  （产科主诉），存到患者信息表中
		if (IsPositiveFlag="marriagehistory")||(IsPositiveFlag["disease")
		{
			s coreflag=0
			if (core["&%") ///多个上位词，用"&%"分隔的
			{
				s LenNum=$l(core,"&%")
				for m=1:1:LenNum
				{
					s CoreNow=$p(core,"&%",m)
					s:CoreNow="妊娠" coreflag=1
					q:coreflag=1
				}
			}
			elseif(core'="")
			{
				s:core="妊娠" coreflag=1 
			}
			
			//实体/归一/上位 有一个是 "妊娠" 才能存
			if (Name="妊娠") || (formal="妊娠") ||(coreflag=1)
			{
				if ItemJson.%IsDefined("marriage_value")
				{
					s GestWeek=ItemJson.%Get("marriage_value").%Get("name")
				}
				elseif ItemJson.%IsDefined("last_time")
				{
					s GestWeek=+(ItemJson.%Get("last_time").%Get("name"))
				}
				else
				{
					s GestWeek=""
				}
				
				s SymptomJson={}
				s Children=[]
				s FieldNameNNew="PatientMaster"
				
				d SymptomJson.%Set("DataClass",FieldNameNNew)
				s ChildItem={}
			
				d ChildItem.%Set("PregStatus","妊娠") //妊娠/产后状态
				d ChildItem.%Set("GestWeek",GestWeek) //孕周
			
				d Children.%Push(ChildItem)
				d SymptomJson.%Set("children",Children)
				d ChildrenResultArray.%Push(SymptomJson)
			}
		}
		else //若第一次主诉中有妊娠，第二次没，用""覆盖
		{
			s ExistPatientJson=ChildrenResultArray.%ToJSON()
			//continue:(ExistPatientJson[("""PregStatus"":"""""""))
			continue:(ExistPatientJson["PregStatus")
			s SymptomJson={}
			s Children=[]
			s FieldNameNNew="PatientMaster"
			
			d SymptomJson.%Set("DataClass",FieldNameNNew)
			s ChildItem={}
		
			d ChildItem.%Set("PregStatus","") //妊娠/产后状态
			d ChildItem.%Set("GestWeek","") //孕周
		
			d Children.%Push(ChildItem)
			d SymptomJson.%Set("children",Children)
			d ChildrenResultArray.%Push(SymptomJson)
		}	
	}
	
	q ""
}

/// Creator:wuzhe
/// CreatDate:2021-08-12
/// Description：提取现病史过NLP后的解析内容
/// Input：nlp json返回的字符串
/// Output: json
/// w ##class(web.CDSS.MachineLearning.NLPProcessingData).CollectCurrentMedToNlp("[{'type':'sign','name':'T:36.5','sign_name':{'name':'T'},'sign_value':{'name':'36.5'},'sign_unit':'℃','context':'T:36.5℃ p','formal':'T:36.5'},{'type':'sign','name':'肠鸣音亢进','sign_name':{'name':'肠鸣音'},'sign_value':{'name':'3-4'},'sign_unit':'次','context':'肠鸣音3-4/次','formal':'肠鸣音3-4/次','core':'肠鸣音'}]","CurrentMedHisSum","[]","")
/// w ##class(web.CDSS.MachineLearning.NLPProcessingData).CollectCurrentMedToNlp("[{'type':'+symptom','name':'腹痛','position':{'name':'腹'},'symptom':{'name':'痛'},'incentive':{'name':'餐后'},'formal':'腹痛','core':'腹部不适'}]","ChiefCompSum","[]","")
/// {'type':'+symptom','name':'腹痛','position':{'name':'腹'},'symptom':{'name':'痛'},'incentive':{'name':'餐后'},'formal':'腹痛','core':'腹部不适'}
/// {'type':sign,'name':'T:36.5','sign_name':{'name':'T'},'sign_value':{'name':'36.5'},'sign_unit':'℃','context':'T:36.5℃ p','formal':'T:36.5'}
ClassMethod CollectCurrentMedToNlp(NLPString As %String, FieldName As %String, ByRef ChildrenResultArray, ByRef RecordInserted) As %String
{
	/*新加
	s Result=""
	s NLPString=$REPLACE(NLPStringOld,"'","""")
	s ChildrenResultArray=[].%FromJSON(ChildrenResultArrayOld)*/
	///s WhetherVaule=0 ///是否是数值型症状标志，1：是，0：否
	///s ALLResult=""
	if NLPString="[]"
	{
		s SymptomJson={}
		s DataClass=..GetMappingUser(FieldName)
		d SymptomJson.%Set("DataClass",DataClass)
		s Children=[]
		s ChildItem={}
		d ChildItem.%Set("SymptomNum","")
		d ChildItem.%Set("PartDR","")
		d ChildItem.%Set("Symptom","空")
		d ChildItem.%Set("Duration","")
		d ChildItem.%Set("AbnormalMax","")
		d ChildItem.%Set("AbnormalMin","")
		d ChildItem.%Set("NormalMax","")
		d ChildItem.%Set("NormalMin","")
		d ChildItem.%Set("RangeUnit","")
		d ChildItem.%Set("RangeType","")
		d ChildItem.%Set("Cause","")
		d ChildItem.%Set("SymptomResult","")
		///新加
		d ChildItem.%Set("SymptomType","")
		d ChildItem.%Set("SymptomFormal","")
		d ChildItem.%Set("SymptomCore","")
		d ChildItem.%Set("SymProperty","")
		d Children.%Push(ChildItem)
		d SymptomJson.%Set("children",Children)
		d ChildrenResultArray.%Push(SymptomJson)
		///新加
		s Result=ChildrenResultArray.%ToJSON()
		///q ""
	}

	///用来排除NLP解析错误的情况{"error":"文本解析错误，请联系管理人员"}
	//if ($e(NLPString,1)="{")&($e(NLPString,-1)="}") ///"-1是否可用值得商榷"
	//if ($e(NLPString,1)="{")&($e(NLPString,$l(NLPString))="}")
	if ($e(NLPString,1)="{")&($e(NLPString,*)="}")
	{
		s NLPStringDict={}.%FromJSON(NLPString)
		q:NLPStringDict.%IsDefined("error") ""
	}
	
	s NLPArray=[].%FromJSON(NLPString)
	///阴性症状列表，用于存放阴性症状
	//s Negative=[].%FromJSON("[]")
	//s Negative={}.%FromJSON("{}")
	///kill ^TMPNega
	
	//第一遍找出所有的否定症状，把实体放入集合中
	/*for i=0:1:NLPArray.%Size()-1
	{
		s DataClass=..GetMappingUser(FieldName)
		continue:DataClass=""
		s ItemJson=NLPArray.%Get(i)
		s IsPositiveFlag=ItemJson.%Get("type")
		if (IsPositiveFlag["+")||(IsPositiveFlag["-")
		{
			s IsPositive=$e(ItemJson.%Get("type"),1,1)   //用来取阴性和阳性
			s IsPositive=$case(IsPositive,"+":"阳性","-":"阴性")
		}
		else
		{
			s IsPositive="阳性"
		}
		
		s Name=ItemJson.%Get("name")   //获取症状名称
	    ///阴性症状加入列表
	    if IsPositive="阴性" 
	    {
		    ///s ^TMPNega("Nega",Name)=Name
		    ///s ^TMPNega(Name,Name)=Name
		    ///d Negative.%Push(Name) 
		    d Negative.%Set(Name,Name)
		}
	}*/
	
	kill Positive
	///w Negative.%ToJSON(),
	///第二遍存储症状
	for i=0:1:NLPArray.%Size()-1
	{
		/// 现病史有血压不存
		continue:NLPArray.%Get(i).%Get("name")="血压"
		s WhetherVaule=0 ///是否是数值型症状标志，1：是，0：否
		s ItemJson=NLPArray.%Get(i)
		
		///新加-是否是数值型症状（检查检验结果之类的），纯症状（发烧，咳嗽之类的）
		s ValueSymptom=""
		s ValueUnit=""
		s Value=""
		s NLPIterator=ItemJson.%GetIterator()     //遍历第一层{}
		while NLPIterator.%GetNext(.key,.value)
		{
			//检查，检验，体征均是 名称和单位均要有
			if ((key="sign_value")&(ItemJson.%IsDefined("sign_unit")))||((key="lis_value")&(ItemJson.%IsDefined("lis_unit")))||((key="ris_value")&(ItemJson.%IsDefined("ris_unit")))
			{
				s WhetherVaule=1
				s ValueSymptomName=$p(key,"_",1)_"_name"
				s ValueSymptomUnit=$p(key,"_",1)_"_unit"
				
				if ItemJson.%IsDefined(ValueSymptomName)
				{
					s ValueSymptom=ItemJson.%Get(ValueSymptomName).%Get("name")  ///有值的症状名称
				}
				if ItemJson.%IsDefined(ValueSymptomUnit)
				{
					s ValueUnit=ItemJson.%Get(ValueSymptomUnit).%Get("name") ///有值的症状的单位
				}  
				///s ValueSymptom=ItemJson.%Get(ValueSymptomName).%Get("name")  ///有值的症状名称
				///s ValueUnit=ItemJson.%Get(ValueSymptomUnit) ///有值的症状的单位
				///s Value=ItemJson.%Get(key).%Get("name") ///有值的症状的值
				 
				///有多个检查结果
				s ValueStr=value.%ToJSON()
				
				if ($e(ValueStr,1)="{")&($e(ValueStr,$l(ValueStr))="}")
				{
					s Value=value.%Get("name") ///有值的症状的值
				}
				elseif ($e(ValueStr,1)="[")&($e(ValueStr,$l(ValueStr))="]")
				{
					for j=0:1:value.%Size()-1
					{
						s valueStr=value.%Get(j)
						s:Value'="" Value=Value_"/"_valueStr.%Get("name") 
						s:Value="" Value=valueStr.%Get("name")
					}
				}
				///s Value=value.%Get("name") ///有值的症状的值
				
				/*if ALLResult=""
				{
					s ALLResult=ValueSymptom_"+"_Value_"+"_ValueUnit
				}
				else
				{
					s ALLResult=ALLResult_"****"_ValueSymptom_"+"_Value_"+"_ValueUnit
				}
				w ValueSymptom,!
				w Value,!
				w ValueUnit,!*/	
			}
		}
		
		s DataClass=..GetMappingUser(FieldName)
		continue:DataClass=""
		//d SymptomJson.%Set("DataClass",..GetMappingUser(FieldName))
		s IsPositiveFlag=ItemJson.%Get("type")
		if (IsPositiveFlag["+")||(IsPositiveFlag["-")
		{
			s IsPositive=$e(ItemJson.%Get("type"),1,1)   //用来取阴性和阳性
			s IsPositive=$case(IsPositive,"+":"阳性","-":"阴性")
		}
		else
		{
			s IsPositive="阳性"
		}
		continue:IsPositive="阴性"
		s Name=ItemJson.%Get("name")   //获取症状名称
		continue:Name=""
		///没单位类型的检查检验结果提取内容  例：结核性胸腔积液（检验结果）
		if (WhetherVaule=0)&((IsPositiveFlag="Ris")||(IsPositiveFlag="Lis")||(IsPositiveFlag["ris")||(IsPositiveFlag["lis")) 
		{
			s:(IsPositiveFlag="Ris")||(IsPositiveFlag["ris") Field="ris"
			s:(IsPositiveFlag="Lis")||(IsPositiveFlag["lis") Field="lis"
			
			if ItemJson.%IsDefined(Field_"_name")
			{
				s ValueSymptom=ItemJson.%Get(Field_"_name").%Get("name")
			}
			if ItemJson.%IsDefined(Field_"_result")
			{
				s ResultArrayType=ItemJson.%GetTypeOf(Field_"_result")
				if ResultArrayType="array"   //如果值是一个数组
				{
					s ResultArraySize=ResultArrayType.%Size()
					for j=0:1:ResultArraySize-1
					{
						s:Value'="" Value=Value_ResultArraySize.%Get(j).%Get("name")
						s:Value="" Value=ResultArraySize.%Get(j).%Get("name")
					}
				}
				else   //如果值只是一个{}
				{
					s Value=ItemJson.%Get(Field_"_result").%Get("name")
				}
			}
			if ItemJson.%IsDefined(Field_"_value")
			{
				s ResultArrayType=ItemJson.%GetTypeOf(Field_"_value")
				if ResultArrayType="array"   //如果值是一个数组
				{
					s ResultArraySize=ResultArrayType.%Size()
					for j=0:1:ResultArraySize-1
					{
						s:Value'="" Value=Value_ResultArraySize.%Get(j).%Get("name")
						s:Value="" Value=ResultArraySize.%Get(j).%Get("name")
					}
				}
				else   //如果值只是一个{}
				{
					s Value=ItemJson.%Get(Field_"_value").%Get("name")
				}
			}
		}
		
		if ItemJson.%IsDefined("position")    //如果存在部位的信息则取值
		{
			s Part=ItemJson.%Get("position").%Get("name")   //部位
			s:..GetMappingPosition(Part)'="" Part=..GetMappingPosition(Part)
		}
		else    //如果不存在部位信息，则要赋值为空
		{ 
			s Part=""
		}
		
		///新加归一词和上位词
		if (ItemJson.%IsDefined("formal"))&&(ItemJson.%Get("formal")'=ItemJson.%Get("name"))
		{
			s formal=ItemJson.%Get("formal") ///归一词
		}
		else
		{
			s formal=""
		}

		if (ItemJson.%IsDefined("core"))&&(ItemJson.%Get("core")'=ItemJson.%Get("name"))
		{
			s core=ItemJson.%Get("core")  ///上位词
			s core=$replace(core,"、","&%")
		}
		else
		{
			s core=""
		}

		s NameFlag=0
		s NameFlag=..ExistSymptom(Name)
		s OutcomePreFlag=0
		s OutcomeSubFlag=0
		if ItemJson.%IsDefined("outcome")
		{
			s Outcome=ItemJson.%Get("outcome").%Get("name")
			s OutcomePreName=Name_Outcome
			
			s OutcomePreFlag=..ExistSymptom(OutcomePreName)
			s OutcomeSubName=Outcome_Name
			s OutcomeSubFlag=..ExistSymptom(OutcomeSubName)
		}
		k UserName
		s UserName=..GetMappingUser(FieldName)
		s RecordInserted(UserName,Name)=""
		//Duration字段有last_tiem优先存，没有则存happen_time
		if ItemJson.%IsDefined("last_time")
		{
			s Duration=ItemJson.%Get("last_time").%Get("name")
			s Duration=..DealLastTime(Duration)   ///处理持续时间并进行单位转换（时）
		}
		else
		{
			if ItemJson.%IsDefined("happen_time")
			{
				s Duration=ItemJson.%Get("happen_time").%Get("name")
				s Duration=..DealHappentime(Duration) ///处理开始时间并进行单位转换（时）
			}
			else
			{
				s Duration=""
			}
		}

		///属性：用&%拼接level，frequency，nature，day_time，incentive内容
		s SymProperty=""
		if ItemJson.%IsDefined("level")
		{
			//s Level=ItemJson.%Get("level").%Get("name")  //程度
			s LevelValue=ItemJson.%Get("level") //程度
			s LevelType=ItemJson.%GetTypeOf("level")
			if LevelType="array"   //如果值是一个数组
			{
				s LevelArraySize=LevelValue.%Size()
				s Level=""
				for LeSize=0:1:LevelArraySize-1
				{
					s:Level'="" Level=Level_"&%"_LevelValue.%Get(LeSize).%Get("name")
					s:Level="" Level=LevelValue.%Get(LeSize).%Get("name")
				}
			}
			else   //如果值只是一个{}
			{
				s Level=LevelValue.%Get("name") //程度
			}
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
			///nature的格式区别于level和frequency，"[...]"格式
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
		
		if ItemJson.%IsDefined("incentive")
		{
			s Incentive=ItemJson.%Get("incentive").%Get("name")  //诱因
			s:SymProperty'="" SymProperty=SymProperty_"&%"_Incentive
			s:SymProperty="" SymProperty=Incentive
			
			//诱因/病因识别词维护时取自 诱因/病因，定语字典
			s PathogenyID=$o(^CT.WDT.CDSS.PathogenyDictI("DescIndex"," "_$ZCONVERT(Incentive,"U"),0)) ///诱因/病因字典
			if PathogenyID=""
			{
				s PathogenyID=$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.PathogenyDict",$ZCONVERT(Incentive,"U"),0)) ///别名通用名
				if PathogenyID="" //不在诱因字典，也不是诱因字典的别名
				{
					s AttributeID=$o(^CT.WDT.CDSS.AttributeDictI("DescIndex"," "_$ZCONVERT(Incentive,"U"),0)) ///定语字典
					if AttributeID="" //不在定语字典，也不是定语字典的别名
					{
						s AttributeID=$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.AttributeDict",$ZCONVERT(Incentive,"U"),0)) ///别名通用名
						s:AttributeID="" Incentive=""
						s:AttributeID'="" Incentive=$lg($g(^CT.WDT.CDSS.AttributeDictD(AttributeID)),3)
					}
				}
				else
				{
					s Incentive=$lg($g(^CT.WDT.CDSS.PathogenyDictD(PathogenyID)),3)
				}
			}
		}
		else
		{
			s Incentive=""
		}
		
		//症状的值
		s AbnormalMax=""
		s RangeUnit=""
		if ItemJson.%IsDefined("value")
		{
			s AbnormalMax=ItemJson.%Get("value").%Get("name")  //症状的值
		}
		//值的单位
		if ItemJson.%IsDefined("unit")
		{
			s RangeUnit=ItemJson.%Get("unit").%Get("name")  //值的单位
			//单位名称是否在单位字典表中，不在则存""
			s UnitID=$o(^CT.WDT.CDSS.UnitDictI("DescIndex"," "_$zconvert(RangeUnit,"U"),0))
			if UnitID'=""
			{
				s RangeUnit=RangeUnit
			}
			else
			{
				s UnitAliasID=$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.UnitDict",RangeUnit,0)) //单位字典表 ID
				if UnitAliasID'=""
				{
					s RangeUnit=$lg($g(^CT.WDT.CDSS.UnitDictD(UnitAliasID)),3)  //单位字典表 单位名称
				}
				else
				{
					s RangeUnit=""
				}
			}
			//s:RangeUnit="毫升" RangeUnit="ml"
		}
		
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
		
		//符号 例：AST/ALT>2
		s symbol=""
		if ItemJson.%IsDefined("symbol")
		{
			s symbol=ItemJson.%Get("symbol").%Get("name")
		}
		///无值型症状（纯症状）进行归一词和上位词的处理
		if (WhetherVaule=0)  //&(IsPositiveFlag'="Ris")&(IsPositiveFlag'="Lis")&(IsPositiveFlag'["ris")&(IsPositiveFlag'["lis")
		{
			///处理归一词
			s NameFormalFlag="0" ///归一词是否在neo4j标志
			s:formal'="" NameFormalFlag=..ExistSymptom(formal)
			s:NameFormalFlag="0" formal=""
			s:NameFormalFlag="1" formal=formal
			
			///处理上位词
			s NameCoreFlag="0" ///上位词是否在neo4j标志
			s CoreDeal=""
			s:(core'="")&(core'["&%") NameCoreFlag=..ExistSymptom(formal) ///一个上位词
			if (core'="")&(core["&%") ///多个上位词，用"&%"分隔的
			{
				s Lennum=$l(core,"&%")
				for v=1:1:Lennum
				{
					s CoreNow=$p(core,"&%",v)
					s CoreNowFlag=0
					s CoreNowFlag=..ExistSymptom(CoreNow)
					///精准匹配
					///s CoreNowTMPFlag=$match($g(^TMPNega("Nega",CoreNow)),CoreNow)
					///s CoreNowTMPFlag=$match(Negative.%ToJSON(),CoreNow) ///如果Negative是列表 [] ,只能精准匹配一个症状，多个还需测试
					//s CoreNowTMPFlag=Negative.%IsDefined(CoreNow)
					
					///在neo4j且不在阴性症状的列表中
					//s:(CoreDeal'="")&(CoreNowFlag="1")&(CoreNowTMPFlag=0) CoreDeal=CoreDeal_"&%"_CoreNow
					//s:(CoreDeal="")&(CoreNowFlag="1")&(CoreNowTMPFlag=0) CoreDeal=CoreNow
					
					s:(CoreDeal'="")&(CoreNowFlag="1") CoreDeal=CoreDeal_"&%"_CoreNow
					s:(CoreDeal="")&(CoreNowFlag="1") CoreDeal=CoreNow
				 }
				 s:CoreDeal'="" NameCoreFlag="1"
			}
			s:(NameCoreFlag="1")&(CoreDeal="") core=core
			s:(NameCoreFlag="1")&(CoreDeal'="") core=CoreDeal
			s:NameCoreFlag="0" core=""
		}
		//w Name
		//w $d(Positive(Name)),!
		if (NameFlag="1")&&(WhetherVaule=0)&&($d(Positive(Name))=0)
		{
			s SymptomJson={}
			s Children=[]
			d SymptomJson.%Set("DataClass",..GetMappingUser(FieldName))
			s ChildItem={}
			d ChildItem.%Set("SymptomNum","")
			d ChildItem.%Set("PartDR",Part)
			d ChildItem.%Set("Symptom",Name)
			d ChildItem.%Set("Duration",Duration)
			d ChildItem.%Set("AbnormalMax","")
			d ChildItem.%Set("AbnormalMin","")
			d ChildItem.%Set("NormalMax","")
			d ChildItem.%Set("NormalMin","")
			d ChildItem.%Set("RangeUnit","")
			d ChildItem.%Set("RangeType","")
			d ChildItem.%Set("Cause",Incentive)
			d ChildItem.%Set("SymptomResult",IsPositive)
			if FieldName="CurrentMedHisSum"
			{
				d ChildItem.%Set("Status","")	
			}
			
			///新加
			d ChildItem.%Set("SymptomFormal",formal)
			d ChildItem.%Set("SymptomCore",core)
			d ChildItem.%Set("SymptomType",IsPositiveFlag)
			d ChildItem.%Set("SymProperty",SymProperty)
			d ChildItem.%Set("AbnormalMax",AbnormalMax)
			d ChildItem.%Set("RangeUnit",RangeUnit)
			d ChildItem.%Set("CDSS2PartDR",Body)
			d ChildItem.%Set("PositionWordDR",Pos)
			
			d Children.%Push(ChildItem)
			d SymptomJson.%Set("children",Children)
			d ChildrenResultArray.%Push(SymptomJson)
		}
		elseif OutcomePreFlag="1"
		{
			s SymptomJson={}
			s Children=[]
			d SymptomJson.%Set("DataClass",..GetMappingUser(FieldName))
			s ChildItem={}
			d ChildItem.%Set("SymptomNum","")
			d ChildItem.%Set("PartDR",Part)
			d ChildItem.%Set("Symptom",OutcomePreName)
			d ChildItem.%Set("Duration",Duration)
			d ChildItem.%Set("AbnormalMax","")
			d ChildItem.%Set("AbnormalMin","")
			d ChildItem.%Set("NormalMax","")
			d ChildItem.%Set("NormalMin","")
			d ChildItem.%Set("RangeUnit","")
			d ChildItem.%Set("RangeType","")
			d ChildItem.%Set("Cause",Incentive)
			d ChildItem.%Set("SymptomResult",IsPositive)
			if FieldName="CurrentMedHisSum"
			{
				d ChildItem.%Set("Status","")	
			}
			d Children.%Push(ChildItem)
			d SymptomJson.%Set("children",Children)
			d ChildrenResultArray.%Push(SymptomJson)
		}
		
		elseif OutcomeSubFlag="1"
		{
			s SymptomJson={}
			s Children=[]
			d SymptomJson.%Set("DataClass",..GetMappingUser(FieldName))
			s ChildItem={}
			d ChildItem.%Set("SymptomNum","")
			d ChildItem.%Set("PartDR",Part)
			d ChildItem.%Set("Symptom",OutcomeSubName)
			d ChildItem.%Set("Duration",Duration)
			d ChildItem.%Set("AbnormalMax","")
			d ChildItem.%Set("AbnormalMin","")
			d ChildItem.%Set("NormalMax","")
			d ChildItem.%Set("NormalMin","")
			d ChildItem.%Set("RangeUnit","")
			d ChildItem.%Set("RangeType","")
			d ChildItem.%Set("Cause",Incentive)
			d ChildItem.%Set("SymptomResult",IsPositive)
			if FieldName="CurrentMedHisSum"
			{
				d ChildItem.%Set("Status","")	
			}
			d Children.%Push(ChildItem)
			d SymptomJson.%Set("children",Children)
			d ChildrenResultArray.%Push(SymptomJson)
		}
		elseif (WhetherVaule=1) //既在neo4j中存在，又有值型症状(针对检查，检验结果此类数据) (NameFlag="1")&&(WhetherVaule=1)
		{
			s:IsPositiveFlag="sign" IsPositiveFlag="体征"
			s:IsPositiveFlag="Lis" IsPositiveFlag="检验"
			s:IsPositiveFlag="Ris" IsPositiveFlag="检查"
			s:symbol'="" Value=symbol_Value

			s SymptomJson={}
			s Children=[]
			//改动，数值型症状存在辅助检验检查（非结构化）表中
			s FieldNameNew="LabExamInfo"
			
			d SymptomJson.%Set("DataClass",..GetMappingUser(FieldNameNew))
			s ChildItem={}
			
			d ChildItem.%Set("CheckType",IsPositiveFlag)
			d ChildItem.%Set("CheckName",ValueSymptom)
			d ChildItem.%Set("CheckFormal",formal)
			d ChildItem.%Set("SymptomCore",core)
			d ChildItem.%Set("CheckValue",Value)
			d ChildItem.%Set("ProjectName",ValueSymptom)
			
			d Children.%Push(ChildItem)
			d SymptomJson.%Set("children",Children)
			d ChildrenResultArray.%Push(SymptomJson)
		}
	 	else ///不在neo4j，也不是有数值型症状
		{
			/*///实体不在neo4j中，判断归一词是否在neo4j中
			s NameFormalFlag=0 ///归一词是否在neo4j标志
			s:formal'="" NameFormalFlag=..ExistSymptom(formal)*/
			if (NameFormalFlag="1")&($d(Positive(Name))=0)
			{
				s SymptomJson={}
				s DataClass=..GetMappingUser(FieldName)
				d SymptomJson.%Set("DataClass",DataClass)
				s Children=[]
				s ChildItem={}
				d ChildItem.%Set("SymptomNum","")
				d ChildItem.%Set("PartDR","")
				d ChildItem.%Set("Symptom","空")
				d ChildItem.%Set("Duration","")
				d ChildItem.%Set("AbnormalMax","")
				d ChildItem.%Set("AbnormalMin","")
				d ChildItem.%Set("NormalMax","")
				d ChildItem.%Set("NormalMin","")
				d ChildItem.%Set("RangeUnit","")
				d ChildItem.%Set("RangeType","")
				d ChildItem.%Set("Cause",Incentive)
				d ChildItem.%Set("SymptomResult","")
				
				///新加
				d ChildItem.%Set("SymptomFormal",formal)
				d ChildItem.%Set("SymptomCore",core)
				d ChildItem.%Set("SymptomType",IsPositiveFlag)
				d ChildItem.%Set("SymProperty",SymProperty)
				d ChildItem.%Set("AbnormalMax",AbnormalMax)
				d ChildItem.%Set("RangeUnit",RangeUnit)
				d ChildItem.%Set("CDSS2PartDR",Body)
				d ChildItem.%Set("PositionWordDR",Pos)
				
				d Children.%Push(ChildItem)
				d SymptomJson.%Set("children",Children)
				d ChildrenResultArray.%Push(SymptomJson)
			}
			else
			{
				/*///实体不在neo4j中，归一词不在neo4j中，判断上位词是否在neo4j中，上位词有多个的情况谁在存谁
				s NameCoreFlag=0 ///上位词是否在neo4j标志
				s CoreDeal=""
				s:(core'="")&(core'["、") NameCoreFlag=..ExistSymptom(formal) ///一个上位词
				if (core'="")&(core["、") ///多个上位词，用"、"分隔的
				{
					s Lennum=$l(core,"、")
					for v=1:1:Lennum
					{
						s CoreNow=$p(core,"、",v)
						s CoreNowFlag=0
						s CoreNowFlag=..ExistSymptom(CoreNow) 
						s:(CoreDeal'="")&(CoreNowFlag="1") CoreDeal=CoreDeal_"、"_CoreNow
						s:(CoreDeal="")&(CoreNowFlag="1") CoreDeal=CoreNow
					}
					s:CoreDeal'="" NameCoreFlag="1"
				}*/
				
				if (NameCoreFlag="1")&($d(Positive(Name))=0)
				{
					s:CoreDeal'="" core=CoreDeal
					
					s SymptomJson={}
					s DataClass=..GetMappingUser(FieldName)
					d SymptomJson.%Set("DataClass",DataClass)
					s Children=[]
					s ChildItem={}
					d ChildItem.%Set("SymptomNum","")
					d ChildItem.%Set("PartDR","")
					d ChildItem.%Set("Symptom","空")
					d ChildItem.%Set("Duration","")
					d ChildItem.%Set("AbnormalMax","")
					d ChildItem.%Set("AbnormalMin","")
					d ChildItem.%Set("NormalMax","")
					d ChildItem.%Set("NormalMin","")
					d ChildItem.%Set("RangeUnit","")
					d ChildItem.%Set("RangeType","")
					d ChildItem.%Set("Cause",Incentive)
					d ChildItem.%Set("SymptomResult","")
					
					///新加
					d ChildItem.%Set("SymptomFormal","空")
					d ChildItem.%Set("SymptomCore",core)
					d ChildItem.%Set("SymptomType",IsPositiveFlag)
					d ChildItem.%Set("SymProperty",SymProperty)
					d ChildItem.%Set("AbnormalMax",AbnormalMax)
					d ChildItem.%Set("RangeUnit",RangeUnit)
					d ChildItem.%Set("CDSS2PartDR",Body)
					d ChildItem.%Set("PositionWordDR",Pos)
					
					d Children.%Push(ChildItem)
					d SymptomJson.%Set("children",Children)
					d ChildrenResultArray.%Push(SymptomJson)
				}
				/*else
				{
					s SymptomJson={}
					s DataClass=..GetMappingUser(FieldName)
					d SymptomJson.%Set("DataClass",DataClass)
					s Children=[]
					s ChildItem={}
					d ChildItem.%Set("SymptomNum","")
					d ChildItem.%Set("PartDR","")
					d ChildItem.%Set("Symptom","空")
					d ChildItem.%Set("Duration","")
					d ChildItem.%Set("AbnormalMax","")
					d ChildItem.%Set("AbnormalMin","")
					d ChildItem.%Set("NormalMax","")
					d ChildItem.%Set("NormalMin","")
					d ChildItem.%Set("RangeUnit","")
					d ChildItem.%Set("RangeType","")
					d ChildItem.%Set("Cause","")
					d ChildItem.%Set("SymptomResult","")
					
					///新加
					d ChildItem.%Set("SymptomFormal","")
					d ChildItem.%Set("SymptomCore","")
					d ChildItem.%Set("SymptomType","")
					
					d Children.%Push(ChildItem)
					d SymptomJson.%Set("children",Children)
					d ChildrenResultArray.%Push(SymptomJson)
				}*/
			}
			/*s SymptomJson={}
			s DataClass=..GetMappingUser(FieldName)
			d SymptomJson.%Set("DataClass",DataClass)
			s Children=[]
			s ChildItem={}
			d ChildItem.%Set("SymptomNum","")
			d ChildItem.%Set("PartDR","")
			d ChildItem.%Set("Symptom","空")
			d ChildItem.%Set("Duration","")
			d ChildItem.%Set("AbnormalMax","")
			d ChildItem.%Set("AbnormalMin","")
			d ChildItem.%Set("NormalMax","")
			d ChildItem.%Set("NormalMin","")
			d ChildItem.%Set("RangeUnit","")
			d ChildItem.%Set("RangeType","")
			d ChildItem.%Set("Cause","")
			d ChildItem.%Set("SymptomResult","")
			
			///新加
			d ChildItem.%Set("SymptomFormal","")
			d ChildItem.%Set("SymptomCore","")
			d ChildItem.%Set("SymptomType","")
			
			d Children.%Push(ChildItem)
			d SymptomJson.%Set("children",Children)
			d ChildrenResultArray.%Push(SymptomJson)*/
		}
		//d SymptomJson.%Set("children",Children)
		//d ChildrenResultArray.%Push(SymptomJson)
		
		///没单位类型的检查检验结果存到辅助检查检查检验表中，结果不能为""  例：结核性胸腔积液（检验结果）
		if (Value'="")&((WhetherVaule=0)&((IsPositiveFlag="Ris")||(IsPositiveFlag["Lis")||(IsPositiveFlag["ris")||(IsPositiveFlag["lis"))) 
	    {
		    // 连接">"和"2" 存checkvalue中  AST/ALT>2
		    s:symbol'="" Value=symbol_Value
		    
		    //此处归一词不置为 ""  because:存在辅助检验检查表中
		    s:(ItemJson.%IsDefined("formal"))&(ItemJson.%Get("formal")=ItemJson.%Get("name")) formal=ItemJson.%Get("formal")
		    
		    //名称(ValueSymptom)用，检查字典，检验项目字典，检验医嘱字典判断是否存在，不存在置""
		    //结果(Value)用，检查结果字典，检验结果字典判断是否存在，不存在不存
		    s (ID,ResultID)="" //防止NLP解析出奇怪类型，导致ID没定义报错
		    if ((IsPositiveFlag="Ris")||(IsPositiveFlag["ris"))
		    {
			    if (ValueSymptom'="")
			    {
				    s ID=$o(^CT.WDT.CDSS.ExamDictI("NameIndex"," "_ValueSymptom,0))  //检查字典
				    if ID=""
				    {
					    s ID=$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.ExamDict",ValueSymptom,0)) //别名通用名
					    s:ID'="" ValueSymptom=$lg($g(^CT.WDT.CDSS.ExamDictD(ID)),4) //检查项目名称
					}
				}
			    
			    if ..JudgeDataType(Value)="string"
			    {
				    s ResultID=$o(^CT.WDT.CDSS.ExamResultDictI("DescIndex"," "_Value,0))  //检查结果字典
				    if ResultID=""
				    {
					    s ResultID=$o(^CT.WDT.CDSS.ExamResultDictI("DescIndex"," "_Name,0))  //实体（Name）去找检查结果字典
					    s:ResultID'="" Value=Name
					}
				}
			}
		    elseif ((IsPositiveFlag["Lis")||(IsPositiveFlag["lis"))
		    {
			    if (IsPositiveFlag="Lis_Order")&(ValueSymptom'="") //检验医嘱
			    {
				    s ID=$o(^CT.WDT.CDSS.LabOrdersDictI("DescIndex"," "_ValueSymptom,0))  //检验医嘱字典
		    		if ID=""
		    		{
			    		s ID=$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.LabOrdersDict",ValueSymptom,0)) //别名通用名
			    		s:ID'="" ValueSymptom=$lg($g(^CT.WDT.CDSS.LabOrdersDictD(ID)),3) //检验医嘱描述
			    	}
				}
				elseif (ValueSymptom'="")
				{
					s ID=$o(^CT.WDT.CDSS.LabInspectionDictI("NameIndex"," "_ValueSymptom,0))  //检验项目字典
			    	if ID=""
				    {
					    s ID=$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.LabInspectionDict",ValueSymptom,0)) //别名通用名
					    s:ID'="" ValueSymptom=$lg($g(^CT.WDT.CDSS.LabInspectionDictD(ID)),4) //检验项目名称
					}
				}
				
				if ..JudgeDataType(Value)="string"
				{
					s ResultID=$o(^CT.WDT.CDSS.LabResultDictI("DescIndex"," "_Value,0))  //检验结果字典
					if ResultID=""
				    {
					    s ResultID=$o(^CT.WDT.CDSS.LabResultDictI("DescIndex"," "_Name,0))  //实体（Name）去找检验结果字典
					    s:ResultID'="" Value=Name
					}
				}
				
			}
			s:ID="" ValueSymptom=""
			continue:(ResultID="")&(Value'[">")&(Value'["<")
			
		    
		    s SymptomJson={}
			s Children=[]
			s FieldNameNew="LabExamInfo"
			
			d SymptomJson.%Set("DataClass",..GetMappingUser(FieldNameNew))
			s ChildItem={}
			
			d ChildItem.%Set("CheckName",ValueSymptom) //名称
			d ChildItem.%Set("CheckFormal",formal)
			d ChildItem.%Set("CheckType",IsPositiveFlag)
			d ChildItem.%Set("CheckValue",Value)  //值
			d ChildItem.%Set("SymProperty",SymProperty)
			d ChildItem.%Set("CDSS2PartDR",Body)
			d ChildItem.%Set("PositionWordDR",Pos)
			d ChildItem.%Set("ProjectName",ValueSymptom)
			
			d Children.%Push(ChildItem)
			d SymptomJson.%Set("children",Children)
			d ChildrenResultArray.%Push(SymptomJson)
		}
		
		//对应现病史中的 "孕5周" ，存到患者信息表中
		if (IsPositiveFlag="marriagehistory")||(IsPositiveFlag["disease")
		{
			s coreflag=0
			if (core["&%") ///多个上位词，用"&%"分隔的
			{
				s LenNum=$l(core,"&%")
				for m=1:1:LenNum
				{
					s CoreNow=$p(core,"&%",m)
					s:CoreNow="妊娠" coreflag=1
					q:coreflag=1
				}
			}
			elseif(core'="")
			{
				s:core="妊娠" coreflag=1
			}

			//实体/归一/上位 有一个是 "妊娠" 才能存
			if (Name="妊娠") || (formal="妊娠") ||(coreflag=1)
			{
				if ItemJson.%IsDefined("marriage_value")
				{
					s GestWeek=ItemJson.%Get("marriage_value").%Get("name")
				}
				elseif ItemJson.%IsDefined("last_time")
				{
					s GestWeek=+(ItemJson.%Get("last_time").%Get("name"))
				}
				else
				{
					s GestWeek=""
				}
				
				s SymptomJson={}
				s Children=[]
				s FieldNameNNew="PatientMaster"
				
				d SymptomJson.%Set("DataClass",FieldNameNNew)
				s ChildItem={}
			
				d ChildItem.%Set("PregStatus","妊娠") //妊娠/产后状态
				d ChildItem.%Set("GestWeek",GestWeek) //孕周
			
				d Children.%Push(ChildItem)
				d SymptomJson.%Set("children",Children)
				d ChildrenResultArray.%Push(SymptomJson)
			}
		}
		else //若第一次现病史中有妊娠，第二次没，用""覆盖
		{
			s ExistPatientJson=ChildrenResultArray.%ToJSON()
			//continue:(ExistPatientJson[("""PregStatus"":"""""""))
			continue:(ExistPatientJson["PregStatus")
			s SymptomJson={}
			s Children=[]
			s FieldNameNNew="PatientMaster"
			
			d SymptomJson.%Set("DataClass",FieldNameNNew)
			s ChildItem={}
		
			d ChildItem.%Set("PregStatus","") //妊娠/产后状态
			d ChildItem.%Set("GestWeek","") //孕周
		
			d Children.%Push(ChildItem)
			d SymptomJson.%Set("children",Children)
			d ChildrenResultArray.%Push(SymptomJson)
		}
		
		s:(IsPositive="阳性")&(WhetherVaule=0) Positive(Name)=""  ///阳性症状集，不要同样的症状存多条
	}
	s Result=ChildrenResultArray.%ToJSON()
	//zw Positive
	//w Result
	q ""
}

/// Creator:wuzhe
/// CreatDate:2021-10-21
/// Description：提取诊断信息过NLP后的解析内容
/// Input：nlp json返回的字符串
/// Output: json
/// Others：
ClassMethod DiagInfoPassNLP(NLPString As %String, FieldName As %String, ByRef ChildrenResultArray, ByRef RecordInserted, IDNO As %String, PatientInfo As %String) As %String
{
	//q ""
	//q:NLPString="[]" ""
	/*if NLPString="[]"
	{
		s DiagnosisTime=$ZDT($H,3)
		s SymptomJson={}
		s DataClass=..GetMappingUser(FieldName)
		d SymptomJson.%Set("DataClass",DataClass)
		s Children=[]
		s ChildItem={}
		d ChildItem.%Set("DiagnosisType","")
		d ChildItem.%Set("DiagnosisSequence","")
		d ChildItem.%Set("DiagnosisCode","")
		d ChildItem.%Set("DiagnosisName","空")
		d ChildItem.%Set("DiagnosisTime","")
		d ChildItem.%Set("ChildDiagnosisFlag","1")
		
		d Children.%Push(ChildItem)
		d SymptomJson.%Set("children",Children)
		d ChildrenResultArray.%Push(SymptomJson)
		q ""
	}*/
	s info=[].%FromJSON(PatientInfo)
	s info=info.%Get(0)
	s PatientUserInfo=info.%Get("IDNO")_"^"_info.%Get("PatientDR")_"^"_$tr(info.%Get("VisitID"),0)_"^"_info.%Get("VisitType")_"^"_info.%Get("UserID")_"^"_info.%Get("UserName")_"^"_info.%Get("DeptCode")_"^"_info.%Get("DeptName") //调用后台接口的参数
	///用来排除NLP解析错误的情况{"error":"文本解析错误，请联系管理人员"}
	if ($e(NLPString,1)="{")&($e(NLPString,$l(NLPString))="}")
	{
		s NLPStringDict={}.%FromJSON(NLPString)
		q:NLPStringDict.%IsDefined("error") ""
	}
	//需要内容放到列表中
	s DiagnosisTime=$ZDT($H,3) //诊断时间
	s SymptomJson={}	
	s DataClass=..GetMappingUser(FieldName)
	q:DataClass="" ""
	d SymptomJson.%Set("DataClass",DataClass)
	//s Children=[]
	
	s NLPArray=[].%FromJSON(NLPString)
	s Children=[]
	for i=0:1:NLPArray.%Size()-1
	{
		s Children=[]
		s SymptomJson={}
		d SymptomJson.%Set("DataClass",DataClass)
		s ItemJson=NLPArray.%Get(i)
		s IsPositiveFlag=ItemJson.%Get("type")
		s Name=ItemJson.%Get("name")   //获取诊断名称
		s DiseaseCode="" //西医诊断编码
		s TCMDiseaseCode="" //中医诊断编码
		s TCMSyCode="" //中医证候编码
		if (IsPositiveFlag["+")||(IsPositiveFlag["-")
		{
			s IsPositive=$e(ItemJson.%Get("type"),1,1)   //用来取阴性和阳性
			s IsPositive=$case(IsPositive,"+":"阳性","-":"阴性")
		}
		else
		{
			s IsPositive="阳性"
		}
		continue:IsPositive="阴性"
		///continue:((IsPositiveFlag'["epidemic")&(IsPositiveFlag'["disease")) ///疾病和传染病类型
		continue:Name=""
		
		//诊断分类 例：鼻渊【风邪外袭证】    例：中医诊断：鼻渊  证型：风邪外袭证  西医诊断：脑梗死
		if ItemJson.%IsDefined("disease_type")
		{
			s DiagnosisClass=ItemJson.%Get("disease_type")
			s DiagnosisClass=$case(DiagnosisClass,"syndrome":"证型","chinese_disease":"中医","western_disease":"西医")

		}
		else
		{
			s DiagnosisClass=""
		}
		
		k UserName
		s UserName=..GetMappingUser(FieldName)
		s RecordInserted(UserName,Name)=""
		s NLPProjectName=Name
		
		s ProjectName=##class(web.CDSS.IMP.ContrastDict).GetDiectName(Name,"","诊断") ///对照名称
		s:ProjectName="" Name=Name
		s:ProjectName'="" Name=ProjectName
		
		s (DiagnosisCode,DiagnosisName)=""
		//西医疾病判断
		if $d(^CT.WDT.CDSS.DiseaseDictI("NameIndex"," "_$ZCONVERT(Name,"U")))  ///先判断实体是否存在疾病字典表（用诊断名称）
		{
			s DiseaseID=$o(^CT.WDT.CDSS.DiseaseDictI("NameIndex"," "_$ZCONVERT(Name,"U"),0))
			s:DiseaseID'="" DiseaseCode=$lg($g(^CT.WDT.CDSS.DiseaseDictD(DiseaseID)),2)
		}
		else ///不存在则判断通用别名表中是否存在（诊断的别名判断）
		{
			s DisBieMingID=""
			s DisBieMingID=$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.DiseaseDict"," "_$ZCONVERT(Name,"U"),DisBieMingID)) ///通用字典表别名索引
			//continue:DisBieMingID="" ///诊断名称和诊断别名名称都和实体不相等则实体不存（有一票否决权）
			s:DisBieMingID'="" DiseaseCode=$lg($g(^CT.WDT.CDSS.DiseaseDictD(DisBieMingID)),2)
			s:DisBieMingID'="" DiagnosisName=$lg($g(^CT.WDT.CDSS.DiseaseDictD(DisBieMingID)),3)
		}
		
		//中医疾病判断
		if $d(^CT.WDT.CDSS.TCMDiseaseI("NameIndex",$ZCONVERT(Name,"U")))  ///先判断实体是否存在中医疾病字典表
		{
			s TCMDiseaseID=$o(^CT.WDT.CDSS.TCMDiseaseI("NameIndex",$ZCONVERT(Name,"U"),0))
			s:TCMDiseaseID'="" TCMDiseaseCode=$lg($g(^CT.WDT.CDSS.TCMDiseaseD(TCMDiseaseID)),2)
		}
		else ///不存在则判断通用别名表中是否存在
		{
			s TCMBieMingID=""
			s TCMBieMingID=$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.TCMDisease",$ZCONVERT(Name,"U"),0)) ///通用字典表别名索引
			s:TCMBieMingID'="" TCMDiseaseCode=$lg($g(^CT.WDT.CDSS.TCMDiseaseD(TCMBieMingID)),2)
			s:TCMBieMingID'="" DiagnosisName=$lg($g(^CT.WDT.CDSS.TCMDiseaseD(TCMBieMingID)),3)
		}
		
		//证型判断
		if $d(^CT.WDT.CDSS.TCMSymptomI("NameIndex"," "_$ZCONVERT(Name,"U")))  ///先判断实体是否存在中医证候字典表
		{
			s TCMSymptomID=$o(^CT.WDT.CDSS.TCMSymptomI("NameIndex"," "_$ZCONVERT(Name,"U"),0))
			s:TCMSymptomID'="" TCMSyCode=$lg($g(^CT.WDT.CDSS.TCMSymptomD(TCMSymptomID)),2)
		}
		else ///不存在则判断通用别名表中是否存在
		{
			s TCMSyBieMingID=""
			s TCMSyBieMingID=$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.TCMSymptom",$ZCONVERT(Name,"U"),0)) ///通用字典表别名索引
			s:TCMSyBieMingID'="" TCMSyCode=$lg($g(^CT.WDT.CDSS.TCMSymptomD(TCMSyBieMingID)),2)
			s:TCMSyBieMingID'="" DiagnosisName=$lg($g(^CT.WDT.CDSS.TCMSymptomD(TCMSyBieMingID)),3)
		}
		continue:(DiseaseCode="")&(TCMDiseaseCode="")&(TCMSyCode="")
		
		s:DiagnosisName="" DiagnosisName=Name
		s:DiseaseCode'="" DiagnosisCode=DiseaseCode
		s:TCMDiseaseCode'="" DiagnosisCode=TCMDiseaseCode
		s:TCMSyCode'="" DiagnosisCode=TCMSyCode
		
		/*s:DiseaseCode'="" DiagnosisClass="西医"
		s:TCMDiseaseCode'="" DiagnosisClass="中医"
		s:TCMSyCode'="" DiagnosisClass="证型"*/
		
		//防止诊断录入中相同的诊断已入，但病历还存进去重复
		s ExitDiseaseJson=ChildrenResultArray.%ToJSON()
		continue:(ExitDiseaseJson[("""DiagnosisName"":"""_DiagnosisName_""""_","_"""DiagnosisClass"":"""_DiagnosisClass_""""))
		//continue:(ExitDiseaseJson[("""DiagnosisName"":"""_DiagnosisName_""""))
		
		s ChildItem={}
		s DiagnosisType=$case(FieldName,"PrimaryDiag":"2","DefiniteDiag":"1","SuppleDiag":"4","CurrectionDiag":"3","DischargeDiag":"5","":"")
		d ChildItem.%Set("DiagnosisType",DiagnosisType)
		d ChildItem.%Set("DiagnosisSequence",$o(^WDT.CDSS.DiagnosisInfoI("IDNODiaTySeqIndex",IDNO,DiagnosisType,""),-1))
		d ChildItem.%Set("DiagnosisCode",DiagnosisCode)
		d ChildItem.%Set("DiagnosisName",DiagnosisName)
		d ChildItem.%Set("DiagnosisClass",DiagnosisClass) //中医，西医，证型
		d ChildItem.%Set("DiagnosisTime",DiagnosisTime)
		d ChildItem.%Set("ChildDiagnosisFlag","1")
		d ChildItem.%Set("ProjectName",NLPProjectName)
		d Children.%Push(ChildItem)
		try	//预警 2021-12-09 fwk
        {
	        d ##class(web.CDSS.WarnDecision.AllOrderWarning).DiagWarningToDoc(PatientUserInfo,Name,11)
	    }
	    catch e
	    {
		    //s ^TMPCDSSXWHERROR=OrderEntry.%Get("OrderContent")_"&&"_e.Name
		}
		d SymptomJson.%Set("children",Children)
		d ChildrenResultArray.%Push(SymptomJson)
	}
	s DisJson=##class(web.CDSS.Demo.DiagEntry).GetDiagList(IDNO) ///诊断录入和病历的诊断去重
	s DiseaseList=[].%FromJSON(DisJson)
	s ExistDisJson=Children.%ToJSON()
	for i=0:1:DiseaseList.%Size()-1
	{
		s Children=[]
		s SymptomJson={}
		d SymptomJson.%Set("DataClass",DataClass)
		s ChildItem={}
		s DiseaseName=DiseaseList.%Get(i).%Get("DiagnosisName")
		s DiseaseClass=DiseaseList.%Get(i).%Get("DiagnosisClass")
		continue:(ExistDisJson[(""""_DiseaseName_""""))
		//continue:(ExitDiseaseJson[("""DiagnosisName"":"""_DiseaseName_""""_","_"""DiagnosisClass"":"""_DiseaseClass_""""))
		//continue:(DiseaseList.%Get(i).%Get("DiagnosisType")'=DiagnosisType)
		d ChildItem.%Set("DiagnosisType",DiseaseList.%Get(i).%Get("DiagnosisType"))
		d ChildItem.%Set("DiagnosisSequence",$o(^WDT.CDSS.DiagnosisInfoI("IDNODiaTySeqIndex",IDNO,DiagnosisType,""),-1))
		d ChildItem.%Set("DiagnosisCode",DiseaseList.%Get(i).%Get("DiagnosisCode"))
		d ChildItem.%Set("DiagnosisName",DiseaseName)
		d ChildItem.%Set("DiagnosisClass",DiseaseList.%Get(i).%Get("DiagnosisClass")) //中医，西医，证型
		d ChildItem.%Set("DiagnosisTime",DiagnosisTime)
		d ChildItem.%Set("ChildDiagnosisFlag","1")
		d ChildItem.%Set("ProjectName",DiseaseName)
		d Children.%Push(ChildItem)
		/*
		try	//预警 2021-12-09 fwk
        {
	        d ##class(web.CDSS.WarnDecision.AllOrderWarning).DiagWarningToDoc(PatientUserInfo,DiseaseName,11)
	    }
	    catch e
	    {
		    b ;1234
		    //s ^TMPCDSSXWHERROR=OrderEntry.%Get("OrderContent")_"&&"_e.Name
		}*/
		d SymptomJson.%Set("children",Children)
		d ChildrenResultArray.%Push(SymptomJson)
	}
	//d SymptomJson.%Set("children",Children)
	//d ChildrenResultArray.%Push(SymptomJson)
	q ""
}

/// Creator:wuzhe
/// CreatDate:2021-10-21
/// Description：提取诊断信息过NLP后的解析内容
/// Input：nlp json返回的字符串
/// Output: json
/// Others：CT.WDT.CDSS.TCMDisease：中医疾病字典；CT.WDT.CDSS.TCMSymptom：中医证候字典
ClassMethod DiagInfoPassNLPNew(NLPString As %String, FieldName As %String, ByRef ChildrenResultArray, ByRef RecordInserted, IDNO As %String, PatientInfo As %String, DiagType As %String) As %String
{
	q:(IDNO="")||(FieldName="")||(PatientInfo="") ""
	
	//先删除病例中的FieldName存的诊断,例：初步诊断等
	s BingLIID=0
	for
	{
		s BingLIID=$o(^WDT.CDSS.DiagnosisInfoI("IDNOIndex"," "_IDNO,BingLIID))
		q:BingLIID=""
		
		s DiagnosisDesc=$lg($g(^WDT.CDSS.DiagnosisInfoD(BingLIID)),10)
		if FieldName=DiagnosisDesc
		{
			d ##class(WDT.CDSS.DiagnosisInfo).%DeleteId(BingLIID) //只删FieldName存进来的诊断
		}
	}
		
	
	s DiagnosisTime=$ZDT($H,3) //诊断时间
	//病历内容过NLP不为空
	if (NLPString'="[]")&(NLPString'["error")
	{
		s NLPArray=[].%FromJSON(NLPString)
		for i=0:1:NLPArray.%Size()-1
		{
			s ItemJson=NLPArray.%Get(i)
			s IsPositiveFlag=ItemJson.%Get("type")
			s Name=ItemJson.%Get("name")   //获取诊断名称
			s Core=ItemJson.%Get("core") //上位词
			s DiseaseCode="" //西医诊断编码
			s TCMDiseaseCode="" //中医诊断编码
			s TCMSyCode="" //中医证候编码
			if (IsPositiveFlag["+")||(IsPositiveFlag["-")
			{
				s IsPositive=$e(ItemJson.%Get("type"),1,1)   //用来取阴性和阳性
				s IsPositive=$case(IsPositive,"+":"阳性","-":"阴性")
			}
			else
			{
				s IsPositive="阳性"
			}
			continue:(IsPositive="阴性")||(Name="")
			///continue:((IsPositiveFlag'["epidemic")&(IsPositiveFlag'["disease")) ///疾病和传染病类型
			//诊断分类 例：鼻渊【风邪外袭证】    例：中医诊断：鼻渊  证型：风邪外袭证  西医诊断：脑梗死
			if ItemJson.%IsDefined("disease_type")
			{
				s DiagnosisClass=ItemJson.%Get("disease_type")
				s DiagnosisClass=$case(DiagnosisClass,"syndrome":"证型","chinese_disease":"中医","western_disease":"西医")
			}
			else
			{
				s DiagnosisClass=""
			}
			s DictName=##class(web.CDSS.IMP.ContrastDict).GetDiectName(Name,"","诊断") ///项目名称对照成知识库名称
			if DictName["&%" //1个项目名称对应多个知识库名称
			{
				s DiagnosisSaveFlag=0 //业务表是否存入诊断
				for sum=1:1:$l(DictName,"&%")
				{
					s DictNameNow=$p(DictName,"&%",sum)
					//诊断编码,诊断名称,上位词获取疾病编码
					s (DiagnosisCode,DiagnosisName,DiagnosisCodeCore)=""
					s DiagnosisCodeName=..GetDiseaseCode(DictNameNow) //获取疾病编码
					//实体Name对照后获取不到诊断编码，用上位词获取诊断编码
					if DiagnosisCodeName=""
					{
						if Core'=""
						{
							s LenCore=$l(Core,"、")
							for NumCore=1:1:LenCore
							{
								s CoreNow=$p(Core,"、",NumCore)
								s DiagnosisCodeCore=..GetDiseaseCode(CoreNow) //获取疾病编码
								if DiagnosisCodeCore'=""
								{
									if DiagnosisCodeCore["^^"
									{
										s DiagnosisCode=$p(DiagnosisCodeCore,"^^",1)
										s DiagnosisName=$p(DiagnosisCodeCore,"^^",2)
									}
									else
									{
										s DiagnosisCode=DiagnosisCodeCore
										s DiagnosisName=CoreNow
									}
								}
								q:DiagnosisCodeCore'=""	
							}
						}
					}
					continue:(DiagnosisCodeName="")&(DiagnosisCodeCore="")
					if DiagnosisCodeName'=""
					{	
						if DiagnosisCodeName["^^"
						{
							s DiagnosisCode=$p(DiagnosisCodeName,"^^",1)
							s DiagnosisName=$p(DiagnosisCodeName,"^^",2)
						}
						else
						{
							s DiagnosisCode=DiagnosisCodeName
						}
					}
					s:DiagnosisName="" DiagnosisName=DictNameNow
					//诊断信息表中有此诊断则不进行存储
					s PatientDiagID=$o(^WDT.CDSS.DiagnosisInfoI("IDNODiagnosisNameIndex",IDNO,DiagnosisName,0))
					if PatientDiagID=""
					{
						//初步诊断：Pr，确诊诊断：De，补充诊断：Su，修正诊断：Cu，出院记录：Di
						s DiagnosisType=$case(FieldName,"PrimaryDiag":"2","DefiniteDiag":"1","SuppleDiag":"4","CurrectionDiag":"3","DischargeDiag":"5")
						s PatientArray=[].%FromJSON(PatientInfo)
						s PatientJson=PatientArray.%Get(0)
						s VisitID=PatientJson.%Get("VisitID")
						s PatientDR=PatientJson.%Get("PatientDR")
						s VisitType=PatientJson.%Get("VisitType")
						continue:(IDNO="")||(PatientDR="")||(VisitID="")||(VisitType="")
						//s DiagnosisSequence=$o(^WDT.CDSS.DiagnosisInfoI("IDNODiaTySeqIndex",IDNO,DiagnosisType,""),-1)
						s DiagnosisSequence=$o(^WDT.CDSS.DiagnosisInfoI("PatVisDRTySequenceIndex",PatientDR,VisitID,VisitType,""),-1)+1
						s bobj = ##class(WDT.CDSS.DiagnosisInfo).%New()
		        		s bobj.IDNO=IDNO //主索引
		        		s bobj.PatientDR=PatientDR //登记号
		        		s bobj.VisitID=VisitID //就诊次数
		        		s bobj.VisitType=VisitType //就诊类型
		        		s bobj.DiagnosisType=DiagnosisType //诊断类型
		        		s bobj.DiagnosisSequence=DiagnosisSequence
		        		s bobj.DiagnosisCode=DiagnosisCode //诊断编码
		        		s bobj.DiagnosisName=DiagnosisName //诊断名称
		        		s bobj.DiagnosisClass=DiagnosisClass //中医，西医，证型
		        		s bobj.DiagnosisTime=DiagnosisTime //诊断时间
		        		s bobj.ChildDiagnosisFlag="1"
		        		s bobj.ProjectName=Name //项目名称
		        		s bobj.DiagnosisDesc=FieldName //病例中的哪个字段存入	
		        		//TS
						s sc=bobj.%Save()
						d bobj.%Close()
						If $$$ISOK(sc)
		        		{ 
		            		//TC
		            		//s result=bobj.%Id() ///保存成功的数据ID
		            		s DiagnosisSaveFlag="1"
						}
						else
						{
							//w ##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc),!
							//TRO
						}
						
						//驱动识别词 0826新增
		        		/*s TableRowID = $o(^CT.WDT.CDSS.DataTableDictI("TableNameIndex","WDT.CDSS.DiagnosisInfo","DiagnosisName","")) //数据库表字典表
			            s PMDataType=$lg($g(^CT.WDT.CDSS.DataTableDictD(TableRowID)),14)
			            s PMDataTypeNum=$l(PMDataType,"&")
						for j=0:1:(PMDataTypeNum-1)
						{
							s DataType=$p(PMDataType,"&",j+1)
							continue:$d(^WDT.CDSS.PatPMTypeIndexI("PatVisDRTyDTyUpIndex",PatientDR,VisitID,VisitType,1,DataType)) //患者汇总信息索引表
							//s UpDatFlag="0"
							//if $d(^WDT.CDSS.PatPMTypeIndexI("PatVisDRTyDTyUpIndex",PatientDR,VisitID,VisitType,1,DataType)) //患者汇总信息索引表
							//{
								//s UpDatFlag="1"
							//}
							//continue:UpDatFlag="1"
							s PMobj=##class(WDT.CDSS.PatPMTypeIndex).%New()
							s PMobj.IDNO=IDNO
							s PMobj.PatientDR=PatientDR
							s PMobj.VisitID=VisitID
							s PMobj.VisitType=VisitType
							s PMobj.DataType=DataType
							s PMobj.IsLastUpdate=1
							d PMobj.%Save()
							d PMobj.%Close()	
						}*/
					}
				}
				
				if DiagnosisSaveFlag="1"
				{
					//驱动识别词 0826新增
	        		s TableRowID = $o(^CT.WDT.CDSS.DataTableDictI("TableNameIndex","WDT.CDSS.DiagnosisInfo","DiagnosisName","")) //数据库表字典表
		            s PMDataType=$lg($g(^CT.WDT.CDSS.DataTableDictD(TableRowID)),14)
		            s PMDataTypeNum=$l(PMDataType,"&")
					for j=0:1:(PMDataTypeNum-1)
					{
						s DataType=$p(PMDataType,"&",j+1)
						continue:$d(^WDT.CDSS.PatPMTypeIndexI("PatVisDRTyDTyUpIndex",PatientDR,VisitID,VisitType,1,DataType)) //患者汇总信息索引表
						/*s UpDatFlag="0"
						if $d(^WDT.CDSS.PatPMTypeIndexI("PatVisDRTyDTyUpIndex",PatientDR,VisitID,VisitType,1,DataType)) //患者汇总信息索引表
						{
							s UpDatFlag="1"
						}
						continue:UpDatFlag="1"*/
						s PMobj=##class(WDT.CDSS.PatPMTypeIndex).%New()
						s PMobj.IDNO=IDNO
						s PMobj.PatientDR=PatientDR
						s PMobj.VisitID=VisitID
						s PMobj.VisitType=VisitType
						s PMobj.DataType=DataType
						s PMobj.IsLastUpdate=1
						d PMobj.%Save()
						d PMobj.%Close()	
					}
				}	
			}
			else //1个项目名称对应1个知识库名称
			{	
				s DiagnosisSaveFlag=0 		
				//诊断编码,诊断名称,上位词获取疾病编码
				s (DiagnosisCode,DiagnosisName,DiagnosisCodeCore)=""
				s DiagnosisCodeName=..GetDiseaseCode(DictName) //获取疾病编码
				//实体Name对照后获取不到诊断编码，用上位词获取诊断编码
				if DiagnosisCodeName=""
				{
					if Core'=""
					{
						s LenCore=$l(Core,"、")
						for NumCore=1:1:LenCore
						{
							s CoreNow=$p(Core,"、",NumCore)
							s DiagnosisCodeCore=..GetDiseaseCode(CoreNow) //获取疾病编码
							if DiagnosisCodeCore'=""
							{
								if DiagnosisCodeCore["^^"
								{
									s DiagnosisCode=$p(DiagnosisCodeCore,"^^",1)
									s DiagnosisName=$p(DiagnosisCodeCore,"^^",2)
								}
								else
								{
									s DiagnosisCode=DiagnosisCodeCore
									s DiagnosisName=CoreNow
								}
							}
							q:DiagnosisCodeCore'=""	
						}
					}
				}
				continue:(DiagnosisCodeName="")&(DiagnosisCodeCore="")
				if DiagnosisCodeName'=""
				{	
					if DiagnosisCodeName["^^"
					{
						s DiagnosisCode=$p(DiagnosisCodeName,"^^",1)
						s DiagnosisName=$p(DiagnosisCodeName,"^^",2)
					}
					else
					{
						s DiagnosisCode=DiagnosisCodeName
					}
				}
				s:DiagnosisName="" DiagnosisName=DictName
				s DiagnosisSaveFlag=0 //业务表是否存入诊断
				//诊断信息表中有此诊断则不进行存储
				s PatientDiagID=$o(^WDT.CDSS.DiagnosisInfoI("IDNODiagnosisNameIndex",IDNO,DiagnosisName,0))
				if PatientDiagID=""
				{
					//初步诊断：Pr，确诊诊断：De，补充诊断：Su，修正诊断：Cu，出院记录：Di
					s DiagnosisType=$case(FieldName,"PrimaryDiag":"2","DefiniteDiag":"1","SuppleDiag":"4","CurrectionDiag":"3","DischargeDiag":"5")
					s PatientArray=[].%FromJSON(PatientInfo)
					s PatientJson=PatientArray.%Get(0)
					s VisitID=PatientJson.%Get("VisitID")
					s PatientDR=PatientJson.%Get("PatientDR")
					s VisitType=PatientJson.%Get("VisitType")
					continue:(IDNO="")||(PatientDR="")||(VisitID="")||(VisitType="")
					//s DiagnosisSequence=$o(^WDT.CDSS.DiagnosisInfoI("IDNODiaTySeqIndex",IDNO,DiagnosisType,""),-1)
					s DiagnosisSequence=$o(^WDT.CDSS.DiagnosisInfoI("PatVisDRTySequenceIndex",PatientDR,VisitID,VisitType,""),-1)+1
					s bobj = ##class(WDT.CDSS.DiagnosisInfo).%New()
	        		s bobj.IDNO=IDNO //主索引
	        		s bobj.PatientDR=PatientDR //登记号
	        		s bobj.VisitID=VisitID //就诊次数
	        		s bobj.VisitType=VisitType //就诊类型
	        		s bobj.DiagnosisType=DiagnosisType //诊断类型
	        		s bobj.DiagnosisSequence=DiagnosisSequence
	        		s bobj.DiagnosisCode=DiagnosisCode //诊断编码
	        		s bobj.DiagnosisName=DiagnosisName //诊断名称
	        		s bobj.DiagnosisClass=DiagnosisClass //中医，西医，证型
	        		s bobj.DiagnosisTime=DiagnosisTime //诊断时间
	        		s bobj.ChildDiagnosisFlag="1"
	        		s bobj.ProjectName=Name //项目名称
	        		s bobj.DiagnosisDesc=FieldName //病例中的哪个字段存入	
	        		//TS
					s sc=bobj.%Save()
					d bobj.%Close()
					If $$$ISOK(sc)
	        		{ 
	            		//TC
	            		//s result=bobj.%Id() ///保存成功的数据ID
	            		s DiagnosisSaveFlag=1
					}
					else
					{
						//w ##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc),!
						//TRO
					}
					
					//驱动识别词 0826新增
	        		/*s TableRowID = $o(^CT.WDT.CDSS.DataTableDictI("TableNameIndex","WDT.CDSS.DiagnosisInfo","DiagnosisName","")) //数据库表字典表
		            s PMDataType=$lg($g(^CT.WDT.CDSS.DataTableDictD(TableRowID)),14)
		            s PMDataTypeNum=$l(PMDataType,"&")
					for j=0:1:(PMDataTypeNum-1)
					{
						s DataType=$p(PMDataType,"&",j+1)
						continue:$d(^WDT.CDSS.PatPMTypeIndexI("PatVisDRTyDTyUpIndex",PatientDR,VisitID,VisitType,1,DataType)) //患者汇总信息索引表
						//s UpDatFlag="0"
						//if $d(^WDT.CDSS.PatPMTypeIndexI("PatVisDRTyDTyUpIndex",PatientDR,VisitID,VisitType,1,DataType)) //患者汇总信息索引表
						//{
							//s UpDatFlag="1"
						//}
						//continue:UpDatFlag="1"
						s PMobj=##class(WDT.CDSS.PatPMTypeIndex).%New()
						s PMobj.IDNO=IDNO
						s PMobj.PatientDR=PatientDR
						s PMobj.VisitID=VisitID
						s PMobj.VisitType=VisitType
						s PMobj.DataType=DataType
						s PMobj.IsLastUpdate=1
						d PMobj.%Save()
						s scc=PMobj.%Save()
					   	If $$$ISOK(scc)
					   	{
					   	}
					   	else
					   	{
						   	//w ##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scc),!
						   	w $system.OBJ.DisplayError(scc)
						}
						d PMobj.%Close()	
					}*/
				}
				if DiagnosisSaveFlag="1"
				{
					//驱动识别词 0826新增
	        		s TableRowID = $o(^CT.WDT.CDSS.DataTableDictI("TableNameIndex","WDT.CDSS.DiagnosisInfo","DiagnosisName","")) //数据库表字典表
		            s PMDataType=$lg($g(^CT.WDT.CDSS.DataTableDictD(TableRowID)),14)
		            s PMDataTypeNum=$l(PMDataType,"&")
					for j=0:1:(PMDataTypeNum-1)
					{
						s DataType=$p(PMDataType,"&",j+1)
						continue:$d(^WDT.CDSS.PatPMTypeIndexI("PatVisDRTyDTyUpIndex",PatientDR,VisitID,VisitType,1,DataType)) //患者汇总信息索引表
						/*s UpDatFlag="0"
						if $d(^WDT.CDSS.PatPMTypeIndexI("PatVisDRTyDTyUpIndex",PatientDR,VisitID,VisitType,1,DataType)) //患者汇总信息索引表
						{
							s UpDatFlag="1"
						}
						continue:UpDatFlag="1"*/
						s PMobj=##class(WDT.CDSS.PatPMTypeIndex).%New()
						s PMobj.IDNO=IDNO
						s PMobj.PatientDR=PatientDR
						s PMobj.VisitID=VisitID
						s PMobj.VisitType=VisitType
						s PMobj.DataType=DataType
						s PMobj.IsLastUpdate=1
						d PMobj.%Save()
						d PMobj.%Close()	
					}
				}
			} 
		}
	}
	q ""
}

/// Creator:wuzhe
/// CreatDate:2021-10-21
/// Description：字符串过NLP返回type=disease和type=epidemic的数据
/// Table: 
/// Input：DiagStr：字符串
/// Output: 
/// Others:w ##class(web.CDSS.MachineLearning.NLPProcessingData).DiagPassNLP("以“急性喉炎、Ⅲ°喉梗阻、支气管异物？”收入我科。")
ClassMethod DiagPassNLP(DiagStr As %String) As %String
{
	q:DiagStr="" ""
	s NameResult=""
	
    ///过NLP
	s NLPString=##class(web.CDSS.MachineLearning.NLPProcessingData).GetStructedDataAPI(DiagStr)
	
	///用来排除NLP解析错误的情况{"error":"文本解析错误，请联系管理人员"}
	if ($e(NLPString,1)="{")&($e(NLPString,$l(NLPString))="}")
	{
		s NLPStringDict={}.%FromJSON(NLPString)
		q:NLPStringDict.%IsDefined("error") ""
	}
	q:NLPString="[]" "NLP不能识别"
	s NLPArray=[].%FromJSON(NLPString)
	for i=0:1:NLPArray.%Size()-1
	{
		s ItemJson=NLPArray.%Get(i)
		s type=ItemJson.%Get("type")
		s Name=ItemJson.%Get("name")
		continue:((type'["epidemic")&(type'["disease")) ///疾病和传染病类型
		continue:Name=""
		s projectname=##class(web.CDSS.IMP.ContrastDict).GetDiectName(Name) ///对照
		
		if (projectname="")
		{
			s:NameResult'="" NameResult=NameResult_"^^"_Name
			s:NameResult="" NameResult=Name
		}
		elseif(projectname'="")
		{
			s:NameResult'="" NameResult=NameResult_"^^"_projectname
			s:NameResult="" NameResult=projectname
		}
		
	}
	q NameResult
}

/// Creator:wuzhe
/// CreatDate:2021-11-24
/// Description：处理持续时间
/// Table：
/// Input：LastTime:持续时间内容
/// Output: "":没有小时  数字：小时
/// Others：w ##class(web.CDSS.MachineLearning.NLPProcessingData).DealLastTime("2天")
/// w ##class(web.CDSS.MachineLearning.NLPProcessingData).DealLastTime("2周")
/// w ##class(web.CDSS.MachineLearning.NLPProcessingData).DealLastTime("2月")
/// w ##class(web.CDSS.MachineLearning.NLPProcessingData).DealLastTime("半个月")
/// w ##class(web.CDSS.MachineLearning.NLPProcessingData).DealLastTime("1个月余")
/// w ##class(web.CDSS.MachineLearning.NLPProcessingData).DealLastTime("1月余")
/// w ##class(web.CDSS.MachineLearning.NLPProcessingData).DealLastTime("10小时")
/// w ##class(web.CDSS.MachineLearning.NLPProcessingData).DealLastTime("10个小时")
/// w ##class(web.CDSS.MachineLearning.NLPProcessingData).DealLastTime("10个半小时")
/// w ##class(web.CDSS.MachineLearning.NLPProcessingData).DealLastTime("半年")
/// w ##class(web.CDSS.MachineLearning.NLPProcessingData).DealLastTime("5分钟")
/// 1月余当1月来算   10个半小时
ClassMethod DealLastTime(LastTime As %String) As %String
{
	s result=""
	s str="1,2,3,4,5,6,7,8,9,0,半"
	s timeunit="分钟,时,日,天,周,月,年,岁"
	s exchange=1 ///单位转化成小时的系数
	s number=""
	s unit=""
	
	s:LastTime["余" LastTime=$replace(LastTime,"余","")
	///数值默认第一个位置,也有10小时这种的
	///s number=$e(LastTime,1)
	for i=1:1:$l(LastTime)
	{
		s:(str[$e(LastTime,i))&(number'="") number=number_$e(LastTime,i)
		s:(str[$e(LastTime,i))&(number="") number=$e(LastTime,i)
		s:(timeunit[$e(LastTime,i))&(unit'="") unit=unit_$e(LastTime,i)
		s:(timeunit[$e(LastTime,i))&(unit="") unit=$e(LastTime,i)
	}
	
	s:number="半" number=0.5
	///应对 10个半小时-10半 
	s:($e(number,1)'="半")&(number["半") number=0.5+$replace(number,"半","")
	
	///单位默认最后一个位置，默认单位：分钟，小时/时，天，月，年，周；如果单位是秒过滤
	///s unit=$e(LastTime,$l(LastTime))
	///q:(unit="分")||(unit="秒") ""	
	s:unit'["时" exchange=$case(unit,"分钟":"0.016","日":"24","天":"24","周":"168","月":"744","年":"8760","岁":"8760","分":"0.016",:"")
	
	s:(exchange'=1)&(exchange'="") number=number*exchange
	s result=number
	
	q result
}

/// Creator:范文凯&wuzhe
/// CreatDate:2021-12-03
/// Description：提取辅助检验检查信息过NLP后的解析内容
/// Input：nlp json返回的字符串
/// Output: json
/// Others：
ClassMethod AssistExamPassNLP(NLPString As %String, FieldName As %String, ByRef ChildrenResultArray, ByRef RecordInserted, IDNO As %String, RecordStr As %String) As %String
{
	//保存前先删除上一次病历存储FieldName的内容
	s ExamInfoID=0
	for
	{
		s ExamInfoID=$o(^WDT.CDSS.ExamInfoI("IDNOIndex"," "_IDNO,ExamInfoID))
		q:ExamInfoID=""
		s GroupFlag=$lg($g(^WDT.CDSS.ExamInfoD(ExamInfoID)),6) //医嘱单号
		if GroupFlag[FieldName
		{
			d ##class(WDT.CDSS.ExamInfo).%DeleteId(ExamInfoID) //只删FieldName存进来的检查
		}
	}
	s LabInfoID=0
	for
	{
		s LabInfoID=$o(^WDT.CDSS.LabInfoI("IDNOIndex"," "_IDNO,LabInfoID))
		q:LabInfoID=""
		s GroupFlag=$lg($g(^WDT.CDSS.LabInfoD(LabInfoID)),6) //医嘱单号
		if GroupFlag[FieldName
		{
			d ##class(WDT.CDSS.LabInfo).%DeleteId(LabInfoID) //只删FieldName存进来的检验
		}
	}
				
	///用来排除NLP解析错误的情况{"error":"文本解析错误，请联系管理人员"}
	if ($e(NLPString,1)="{")&($e(NLPString,$l(NLPString))="}")
	{
		s NLPStringDict={}.%FromJSON(NLPString)
		q:NLPStringDict.%IsDefined("error") ""
	}
	q:NLPString="[]" ""	
	s NLPArray=[].%FromJSON(NLPString)
	for i=0:1:NLPArray.%Size()-1
	{
		//拿到第一层
        //s RecordInserted(UserName,Name)=""
        s SymptomJson={}
		s Children=[]
		s ItemJson=NLPArray.%Get(i)
		s NLPResultType=ItemJson.%Get("type")
		if (NLPResultType = "Lis") ///检验
		{
			s ReportTime=$ZDATETIME($HOROLOG,3) ///报告时间
			d SymptomJson.%Set("DataClass","LabInfo")
			s LabItemName=ItemJson.%Get("lis_name").%Get("name")  //获取检验项目名称
			s DictName=##class(web.CDSS.IMP.ContrastDict).GetDiectName(LabItemName,"","") //对照检验名称
			continue:DictName=""
			for number=1:1:$l(DictName,"&%")
			{
				s SymptomJson={}
				s Children=[]
				d SymptomJson.%Set("DataClass","LabInfo")
				s DictNameNow=$p(DictName,"&%",number)
				s ID=$o(^CT.WDT.CDSS.LabInspectionDictI("NameIndex"," "_DictNameNow,0))  //检验项目字典
		    	if ID=""
			    {
				    s ID=$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.LabInspectionDict",DictNameNow,0)) //别名通用名
				    if ID=""
				    {
					    s ID=$o(^CT.WDT.CDSS.LabOrdersDictI("DescIndex"," "_DictNameNow,0))  //检验医嘱字典
			    		if ID=""
			    		{
				    		s ID=$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.LabOrdersDict",DictNameNow,0)) //别名通用名
				    		s:ID'="" DictNameNow=$lg($g(^CT.WDT.CDSS.LabOrdersDictD(ID)),3) //检验医嘱描述
				    	}
					}
					else
					{
						s DictNameNow=$lg($g(^CT.WDT.CDSS.LabInspectionDictD(ID)),4) //检验项目名称
					}
				}
				s ChildItem={}
				d ChildItem.%Set("InspectionName",DictNameNow) ///检验大项名称
				d ChildItem.%Set("InspectionCode",DictNameNow) ///检验大项编码
				d ChildItem.%Set("LabItemName",DictNameNow)  ///检验小项名称
				d ChildItem.%Set("GroupFlag",i+1_"."_number_FieldName)  ///医嘱单号GroupFlag不能相同，不然保存会覆盖
				d ChildItem.%Set("ReportTime",ReportTime)  ///报告时间
				d:ItemJson.%IsDefined("lis_value") ChildItem.%Set("LabResult",ItemJson.%Get("lis_value").%Get("name")) //检验结果
				d:ItemJson.%IsDefined("lis_unit") ChildItem.%Set("Unit",ItemJson.%Get("lis_unit").%Get("name")) //单位
				d:ItemJson.%IsDefined("lis_result") ChildItem.%Set("LabResultFlag",ItemJson.%Get("lis_result").%Get("name")) //检验结果指标（阴性或阳性）
				d Children.%Push(ChildItem)
				d SymptomJson.%Set("children",Children)
				d ChildrenResultArray.%Push(SymptomJson)
			}
		}
		if ((NLPResultType = "Ris")&&((ItemJson.%IsDefined("ris_result"))||(ItemJson.%IsDefined("ris_value")))&&(ItemJson.%IsDefined("ris_name"))) ///检查
		{
			s ReportTime=$ZDATETIME($HOROLOG,3) ///报告时间
			d SymptomJson.%Set("DataClass","ExamInfo")
			s ExamItemName=ItemJson.%Get("ris_name").%Get("name")  //获取检验项目名称
			s DictName=##class(web.CDSS.IMP.ContrastDict).GetDiectName(ExamItemName,"","") //对照检查名称
			continue:DictName=""
			for number=1:1:$l(DictName,"&%")
			{
				s SymProperty=""
				if ItemJson.%IsDefined("nature")
				{
					s SymProperty=ItemJson.%Get("nature").%Get("name")
				}
				s SymptomJson={}
				s Children=[]
				d SymptomJson.%Set("DataClass","ExamInfo")
				s DictNameNow=$p(DictName,"&%",number)
				s ChildItem={}
				d ChildItem.%Set("ExamName",DictNameNow)
				d ChildItem.%Set("ExamCode",DictNameNow)
				d ChildItem.%Set("GroupFlag",i+1_"."_number_FieldName) //GroupFlag不能相同
				d ChildItem.%Set("ReportTime",ReportTime)  ///报告时间
				d ChildItem.%Set("GroupSequence","1")
				if ItemJson.%IsDefined("ris_result")
				{
					d ChildItem.%Set("ExamResult",ItemJson.%Get("ris_result").%Get("name"))
				}
				elseif DictNameNow'=""
				{
					d ChildItem.%Set("ExamResult",DictNameNow)
				}
				elseif ItemJson.%IsDefined("ris_value")
				{
					d ChildItem.%Set("ExamResult",ItemJson.%Get("ris_value").%Get("name"))
				}
				
				if ItemJson.%IsDefined("ris_value")
				{
					d ChildItem.%Set("ExamResultFlag",ItemJson.%Get("ris_value").%Get("name"))
				}
				d ChildItem.%Set("ExamResultDesc",RecordStr) //原文
				d ChildItem.%Set("ProjectName",ExamItemName) //项目名称
				d ChildItem.%Set("SymProperty",SymProperty) //属性
				d Children.%Push(ChildItem)
				d SymptomJson.%Set("children",Children)
				d ChildrenResultArray.%Push(SymptomJson)
			}
		}
		if ((NLPResultType = "+ris_result")&&(ItemJson.%IsDefined("ris_order")||ItemJson.%IsDefined("ris_name"))) //检查结果关联检查医嘱
		{
			s ReportTime=$ZDATETIME($HOROLOG,3) ///报告时间
			d SymptomJson.%Set("DataClass","ExamInfo")
			if ItemJson.%IsDefined("ris_order") //检查医嘱
			{
				s ExamItemName=ItemJson.%Get("ris_order").%Get("name")  //获取检查项目名称
			}  
			elseif ItemJson.%IsDefined("ris_name") //检查名称
			{
				s ExamItemName=ItemJson.%Get("ris_name").%Get("name")
			}
			else
			{
				s ExamItemName=ItemJson.%Get("name")
			}
			s SymProperty=""
			if ItemJson.%IsDefined("nature")
			{
				s SymProperty=ItemJson.%Get("nature").%Get("name")
			}
			s DictName=##class(web.CDSS.IMP.ContrastDict).GetDiectName(ExamItemName,"","") //对照检查名称
			continue:DictName=""
			if DictName["&%" //多个对照
			{
				s SymptomJson={}
				s Children=[]
				d SymptomJson.%Set("DataClass","ExamInfo")
				if ItemJson.%IsDefined("ris_result") //检查结果
				{
					s ExamResult=ItemJson.%Get("ris_result").%Get("name")
				}
				else
				{
					s ExamResult=ItemJson.%Get("name")
				}
				s ERID=$o(^CT.WDT.CDSS.ExamResultDictI("DescIndex"," "_$ZCONVERT(ExamResult,"U"),0)) //检查结果必须在检查检验结果字典
				if ERID=""
				{
					s ERID=$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.ExamResultDict",ExamResult,0)) //别名通用名
				    s:ERID'="" ExamResult=$lg($g(^CT.WDT.CDSS.ExamResultDictD(ERID)),3)
				    if ERID=""
				    {
					    s ERID=$o(^CT.WDT.CDSS.ExamResultDictI("DescIndex"," "_$ZCONVERT(ExamItemName_ExamResult,"U"),0))
					    if ERID'=""
					    {
						    s ExamResult=ExamItemName_ExamResult
						}
					    else
					    {
						    s ERID=$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.ExamResultDict",ExamItemName_ExamResult,0)) //别名通用名
							s:ERID'="" ExamResult=$lg($g(^CT.WDT.CDSS.ExamResultDictD(ERID)),3)
							if (ERID="")&&(ExamResult'=ItemJson.%Get("name")) //检查结果和实体不一致
							{
								s ERID=$o(^CT.WDT.CDSS.ExamResultDictI("DescIndex"," "_$ZCONVERT(ItemJson.%Get("name"),"U"),0))
								if ERID'=""
								{
									s ExamResult=ItemJson.%Get("name")
								}
								else
								{
									s ERID=$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.ExamResultDict",ItemJson.%Get("name"),0)) //别名通用名
									s:ERID'="" ExamResult=$lg($g(^CT.WDT.CDSS.ExamResultDictD(ERID)),3)
								}
							}
						}
					}
				}
				continue:ERID=""
				
				s ChildItem={}
				d ChildItem.%Set("ExamName",DictName)
				d ChildItem.%Set("ExamCode",DictName)
				d ChildItem.%Set("GroupFlag",i+1_FieldName) //GroupFlag不能相同
				d ChildItem.%Set("ReportTime",ReportTime)  ///报告时间
				d ChildItem.%Set("GroupSequence","1")
				d ChildItem.%Set("ExamResult",ExamResult)
				d ChildItem.%Set("SymProperty",SymProperty) //属性
				// d ChildItem.%Set("ExamResultFlag","")
				d Children.%Push(ChildItem)
				d SymptomJson.%Set("children",Children)
				d ChildrenResultArray.%Push(SymptomJson)
				
			}
			else //单个对照
			{
				if ItemJson.%IsDefined("ris_result") //检查结果
				{
					s ExamResult=ItemJson.%Get("ris_result").%Get("name")
				}
				else
				{
					s ExamResult=ItemJson.%Get("name")
				}
				s ERID=$o(^CT.WDT.CDSS.ExamResultDictI("DescIndex"," "_$ZCONVERT(ExamResult,"U"),0)) //检查结果必须在检查检验结果字典
				if ERID=""
				{
					s ERID=$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.ExamResultDict",ExamResult,0)) //别名通用名
				    s:ERID'="" ExamResult=$lg($g(^CT.WDT.CDSS.ExamResultDictD(ERID)),3)
				    if ERID=""
				    {
					    s ERID=$o(^CT.WDT.CDSS.ExamResultDictI("DescIndex"," "_$ZCONVERT(ExamItemName_ExamResult,"U"),0))
					    if ERID'=""
					    {
						    s ExamResult=ExamItemName_ExamResult
						}
					    else
					    {
						    s ERID=$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.ExamResultDict",ExamItemName_ExamResult,0)) //别名通用名
							s:ERID'="" ExamResult=$lg($g(^CT.WDT.CDSS.ExamResultDictD(ERID)),3)
							if (ERID="")&&(ExamResult'=ItemJson.%Get("name")) //检查结果和实体不一致
							{
								s ERID=$o(^CT.WDT.CDSS.ExamResultDictI("DescIndex"," "_$ZCONVERT(ItemJson.%Get("name"),"U"),0))
								if ERID'=""
								{
									s ExamResult=ItemJson.%Get("name")
								}
								else
								{
									s ERID=$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.ExamResultDict",ItemJson.%Get("name"),0)) //别名通用名
									s:ERID'="" ExamResult=$lg($g(^CT.WDT.CDSS.ExamResultDictD(ERID)),3)
								}
							}
						}
					}
				}
				continue:ERID=""
				s ChildItem={}
				d ChildItem.%Set("ExamName",DictName)
				d ChildItem.%Set("ExamCode",DictName)
				d ChildItem.%Set("GroupFlag",i+1_FieldName) //GroupFlag不能相同
				d ChildItem.%Set("ReportTime",ReportTime)  ///报告时间
				d ChildItem.%Set("GroupSequence","1")
				d ChildItem.%Set("ExamResult",ExamResult)
				d ChildItem.%Set("SymProperty",SymProperty) //属性
				// d ChildItem.%Set("ExamResultFlag","")
				d Children.%Push(ChildItem)
				d SymptomJson.%Set("children",Children)
				d ChildrenResultArray.%Push(SymptomJson)
			}	
		}
		if ((NLPResultType["disease")&(NLPResultType'["-"))||(NLPResultType="+epidemic")  //检查结果如果是疾病名称，例“胃穿孔”
		{
			s ReportTime=$ZDATETIME($HOROLOG,3) ///报告时间
			d SymptomJson.%Set("DataClass","ExamInfo")
			s ExamItemName=ItemJson.%Get("name")
			s DictName=##class(web.CDSS.IMP.ContrastDict).GetDiectName(ExamItemName,"","")
			continue:DictName=""
			for number=1:1:$l(DictName,"&%")
			{
				s SymptomJson={}
				s Children=[]
				d SymptomJson.%Set("DataClass","ExamInfo")
				s DictNameNow=$p(DictName,"&%",number)
				s ChildItem={}
				d ChildItem.%Set("ExamName",DictNameNow)
				d ChildItem.%Set("ExamCode",DictNameNow)
				d ChildItem.%Set("GroupFlag",i+1_"."_number_FieldName) //GroupFlag不能相同，不然保存会覆盖
				d ChildItem.%Set("ReportTime",ReportTime)  ///报告时间
				d ChildItem.%Set("GroupSequence","1")
				d ChildItem.%Set("ExamResult",DictNameNow)
				d Children.%Push(ChildItem)
				d SymptomJson.%Set("children",Children)
				d ChildrenResultArray.%Push(SymptomJson)
			}
		} 
	}
	q ""
}

/// Creator:wuzhe
/// CreatDate:2021-12-14
/// Description：转换婚育和月经的时间成天
/// Table：
/// Input：Time：1天，1年等
/// Output: 0:没有天  数字：天
/// Others：w ##class(web.CDSS.MachineLearning.NLPProcessingData).DealMTime("2天")
/// w ##class(web.CDSS.Demo.PatientInfoRenew).DealMTime("2周") 10余年，10个月，10年
/// w ##class(web.CDSS.Demo.PatientInfoRenew).DealMTime("2小时")
ClassMethod DealMTime(Time As %String) As %String
{
	s result=0
	s str="1,2,3,4,5,6,7,8,9,0"
	s timeunit="日,天,周,月,年"
	s exchange=1 ///单位转化成天的系数
	s number=""
	s unit=""
	
	s:Time["余" Time=$replace(Time,"余","")  ///结婚10余天
	///循环取单位和数值
	for i=1:1:$l(Time)
	{
		s:(str[$e(Time,i))&(number'="") number=number_$e(Time,i)
		s:(str[$e(Time,i))&(number="") number=$e(Time,i)
		s:(timeunit[$e(Time,i))&(unit'="") unit=unit_$e(Time,i)
		s:(timeunit[$e(Time,i))&(unit="") unit=$e(Time,i)
	}
	s:unit'="天" exchange=$case(unit,"周":"7","月":"31","年":"365",:"")
	s:exchange'=1 number=number*exchange
	s result=number
	
	q result
}

/// Creator:wuzhe
/// CreatDate:2021-12-23
/// Description：通过部位名称转换成部位字典里的标准名称（1.0的PartDR使用）
/// Input：内容
/// Output: 该内容对应的字段名称
/// w ##class(web.CDSS.Demo.PatientInfoRenew).GetMappingPosition("眼部")
ClassMethod GetMappingPosition(FieldName As %String)
{
	 q:FieldName="" ""
	 s Mapping("右下腹")="右下腹部"
	 s Mapping("眼部")="眼"
	 if $d(Mapping(FieldName))
	 {
	 	q Mapping(FieldName)
	 }
	 else
	 {
		 q ""
	 }
}

/// w ##class(web.CDSS.MachineLearning.NLPProcessingData).Test1()
ClassMethod Test1()
{
	w "诊断因子保存1,,,",$ZDT($NOW(),3,1,4),!
	for i=1:1:20
	{	
		w ##class(web.CDSS.MachineLearning.NLPProcessingData).ExistSymptom("痛经")
	}
	w "诊断因子保存1,,,",$ZDT($NOW(),3,1,4),!
	q ""
}

/// Creator:陈代雷
/// CreatDate:2021-01-25
/// Description:病历类型代码转描述
/// Table:
/// Input: ProgressCode:病历类型代码
/// Return:
/// Others:w ##class(web.CDSS.MachineLearning.InteractiveInterface).ConvertProgress(1)
ClassMethod ConvertProgress(ProgressCode As %String) As %String
{
    s ProgressType=$CASE(ProgressCode,0:"门诊病历",
	1:"入院记录",
	2:"首次病程记录",
	3:"日常病程",
	4:"查房记录",
	5:"术前小结",
	6:"术后首次病程",
	7:"阶段小结",
	8:"会诊记录",
	9:"出院记录",
	10:"手术记录",
	11:"24小时入出院记录",
	12:"上级医师查房记录",
	13:"转入记录",
	14:"转出记录",
	15:"术前访视记录",
	16:"抢救记录",
	17:"死亡记录",
	18:"术前讨论",
	19:"疑难病例讨论记录",
	20:"交班记录",
	21:"接班记录",
	22:"有创操作记录",
	23:"死亡讨论记录",
	24:"急诊留观记录",:"入院记录")
    q ProgressType
}

/// Creator:wuzhe
/// CreatDate:2021-12-30
/// Description：处理开始时间(happen_time)
/// Input：内容
/// Output: 小时
/// w ##class(web.CDSS.Demo.PatientInfoRenew).DealHappentime("2020年")
/// w ##class(web.CDSS.Demo.PatientInfoRenew).DealHappentime("3年前")
/// w ##class(web.CDSS.Demo.PatientInfoRenew).DealHappentime("5月前")
/// w ##class(web.CDSS.Demo.PatientInfoRenew).DealHappentime("2020年1月5日")
/// 
/// w ##class(web.CDSS.Demo.PatientInfoRenew).DealHappentime("2020年10月5日")
/// 3年  一般出现在持续时间里，3年后  一般不会这样写
ClassMethod DealHappentime(Content As %String)
{
	q:Content="" ""
	s result=""
	s TimeLimit="前"
	s str="1,2,3,4,5,6,7,8,9,0,半"
	s timeunit="时,日,天,周,月,年"
	s exchange=1 ///单位转化成小时的系数
	s number=""
	s unit=""
	//s TimeNow="2022-1-6"
	//s TimeNow="2022-1-4"
	s TimeNow=$zdate(+$H,3)
	
	for i=1:1:$l(Content)
	{
		s:(str[$e(Content,i))&(number'="") number=number_$e(Content,i)
		s:(str[$e(Content,i))&(number="") number=$e(Content,i)
		s:(timeunit[$e(Content,i))&(unit'="") unit=unit_$e(Content,i)
		s:(timeunit[$e(Content,i))&(unit="") unit=$e(Content,i)
	}
	
	//if Content["前"  在外围
	if unit="年"
	{
		s number=($p(TimeNow,"-",1)-number)*8760
	}
	elseif unit="年月"
	{
		s yearnumber=$p(Content,"年","1")
		s monthnumber=$p($replace(Content,yearnumber_"年",""),"月","1")
		//年
		s yearlast=($p(TimeNow,"-",1)-yearnumber)*8760   //年 减  现在的年>=病历中的年
		//月
		s:$p(TimeNow,"-",2)>=monthnumber monthlast=($p(TimeNow,"-",2)-monthnumber)*744  //现在月大 减
		s:$p(TimeNow,"-",2)<monthnumber monthlast=12-monthnumber+$p(TimeNow,"-",2)*744    //现在月小 减：病历 2020.10 现在 2022.1
		s:$p(TimeNow,"-",2)<monthnumber yearlast=yearlast-8760
		
		s number=yearlast+monthlast
	}
	elseif unit="年月日"
	{
		//w TimeNow,!
		s yearnumber=$p(Content,"年","1") //病历 年
		s monthnumber=$p($replace(Content,yearnumber_"年",""),"月","1") //病历 月
		s daynumber=$p($replace(Content,yearnumber_"年"_monthnumber_"月",""),"日","1") //病历 日
		//年
		s yearlast=($p(TimeNow,"-",1)-yearnumber)*8760   //年 减
		//月
		s:$p(TimeNow,"-",2)>=monthnumber monthlast=($p(TimeNow,"-",2)-monthnumber)*744  //现在月大 减
		s:$p(TimeNow,"-",2)<monthnumber monthlast=12-monthnumber+$p(TimeNow,"-",2)*744   //现在月小 减：病历 2020.10 现在 2022.1
		s:$p(TimeNow,"-",2)<monthnumber yearlast=yearlast-8760 //现在月小年-1
		//日
		s:$p(TimeNow,"-",3)>=daynumber daylast=($p(TimeNow,"-",3)-daynumber)*24   //现在日大 减
		s:$p(TimeNow,"-",3)<daynumber daylast=31-daynumber+$p(TimeNow,"-",3)*24   //现在日小 减：病历 2020.10.5  现在 2022.1.6
		s:$p(TimeNow,"-",3)<daynumber monthlast=monthlast-744  //现在日小月-1 减：病历 2020.10.5  现在 2022.1.4
		
		s number=yearlast+monthlast+daylast
		//w (yearlast/8760)_"年"_(monthlast/744)_"月"_(daylast/24)_"日",!
	}
	else
	{
		s:number="半" number="0.5"
		///应对 10个半小时-10半 
		s:($e(number,1)'="半")&(number["半") number=0.5+$replace(number,"半","")

		///单位默认最后一个位置，默认单位：小时/时，天，月，年，周；如果单位是分或者秒过滤	
		s:unit'["时" exchange=$case(unit,"日":"24","天":"24","周":"168","月":"744","年":"8760",:"")
		s:(exchange'=1)&(exchange'="") number=number*exchange
	}
	s result=number
	
	q result
}

/// Creator:wuzhe
/// CreatDate:2022-01-25
/// Description：检查检验结果判断是描述还是值   描述："胸腔积液"   值：">2"
/// Table:
/// Input：Context：字符串
/// Output: string：字符串 int：数值/空
/// 一般不会出现 "≥"  "≤"
/// w ##class(web.CDSS.Demo.PatientInfoRenew).JudgeDataType(">2")
ClassMethod JudgeDataType(Context As %String) As %String
{
	q:Context="" "int" 
	s result=""
	s str=Context
	
	s:str[">" str=$replace(str,">","")
	s:str["<" str=$replace(str,">","")
	
	if +str>0
	{
		s result="int"
	}
	else
	{
		s result="string"
	}
	q result
}

/// Creator:wuzhe
/// CreatDate:2022-01-29
/// Description：判断sign_value是否纯描述,若不是则分开数字和汉字   不纯描述："2级"
/// Table:
/// Input：Context：字符串
/// Output: string：纯字符串 stringint：不纯字符串   "":""
/// w ##class(web.CDSS.Demo.PatientInfoRenew).JDSignValue("2级")   肌力2级，双下肢肌力2级
/// w ##class(web.CDSS.Demo.PatientInfoRenew).JDSignValue("短绌")  脉搏短绌
ClassMethod JDSignValue(Context As %String) As %String
{
	q:Context="" "" 
	s (result,unit,number)=""
	s str=Context
	
	s:str[">" str=$replace(str,">","")
	s:str["<" str=$replace(str,"<","")
	
	if +str>0
	{
		s result="stringint"
		for m=1:1:$l(str)
		{
			if $e(str,m)'="0"
			{
				if $e(str,m)="."
				{
					s:number'="" number=number_$e(str,m)
					s:number="" number=$e(str,m)
				}
				else
				{
					s:(+$e(str,m)>0)&(number'="") number=number_$e(str,m)
					s:(+$e(str,m)>0)&(number="") number=$e(str,m)
					s:(+$e(str,m)=0)&(unit'="") unit=unit_$e(str,m)
					s:(+$e(str,m)=0)&(unit="") unit=$e(str,m)
				}
			}
			else
			{
				s:number'="" number=number_$e(str,m)
			}
		}
	}
	else
	{
		s result="string"
	}
	s result=result_"&"_number_"&"_unit
	q result
}

/// Creator:wuzhe
/// CreatDate:2022-03-25
/// Description：病历过NLP（不需要父子集）
/// Table:
/// Input：TaskID：任务集ID，Context：字符串
/// Output:
/// w ##class(web.CDSS.Demo.PatientInfoRenew).MedicalRecordToNlp("周期性下腹痛11月，加重并扪及腹部硬块6月")
ClassMethod MedicalRecordToNlp(Context As %String) As %String
{
	q:Context="" "数据不能为空"
	s Final=""
	s NLPString=##class(web.CDSS.Demo.PatientInfoRenew).GetStructedDataAPI(Context) //过NLP
	if NLPString="[]"
	{
		q "无法解析"
	}
	
	s NLPArray=[].%FromJSON(NLPString) //转对象
	s Result=NLPArray.%ToJSON()
	
	for i=0:1:NLPArray.%Size()-1
	{
		s ItemJson=NLPArray.%Get(i)
		if ItemJson.%IsDefined("graph") //父子集（不要）
		{
			s GraphStr=ItemJson.%Get("graph").%ToJSON()
			s Result=$replace(Result,GraphStr,"{}") //父子集内容替换成空
		}
		
		s type=ItemJson.%Get("type") ///实体类型
		s name=ItemJson.%Get("name") ///实体
		if (ItemJson.%IsDefined("formal"))&&(ItemJson.%Get("formal")'=ItemJson.%Get("name"))
		{
			s formal=ItemJson.%Get("formal") ///归一词
		}
		else
		{
			s formal=""
		}
		
		if (ItemJson.%IsDefined("core"))&&(ItemJson.%Get("core")'=ItemJson.%Get("name"))
		{
			s core=ItemJson.%Get("core") ///上位词
			s:core["、" core=$replace(core,"、","&%")
		}
		else
		{
			s core=""
		}
		
		///属性：用&%拼接level，frequency，nature，day_time，incentive内容
		s SymProperty=""
		if ItemJson.%IsDefined("level")
		{
			//s Level=ItemJson.%Get("level").%Get("name")  //程度
			s LevelValue=ItemJson.%Get("level") //程度
			s LevelType=ItemJson.%GetTypeOf("level")
			if LevelType="array"   //如果值是一个数组
			{
				s LevelArraySize=LevelValue.%Size()
				s Level=""
				for LeSize=0:1:LevelArraySize-1
				{
					s:Level'="" Level=Level_"&%"_LevelValue.%Get(LeSize).%Get("name")
					s:Level="" Level=LevelValue.%Get(LeSize).%Get("name")
				}
			}
			else   //如果值只是一个{}
			{
				s Level=LevelValue.%Get("name") //程度
			}
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
			///nature的格式区别于level和frequency，"[...]"格式
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
		if ItemJson.%IsDefined("incentive")
		{
			s Incentive=ItemJson.%Get("incentive").%Get("name")  //诱因
			s:SymProperty'="" SymProperty=SymProperty_"&%"_Incentive
			s:SymProperty="" SymProperty=Incentive
		}
		
		//最终结果
		if Final=""
		{
			s Final=type_":"_name_","_"formal"_":"_formal_","_"core"_":"_core_","_"symproperty"_":"_SymProperty
		}
		else
		{
			s Final=Final_"，"_type_":"_name_","_"formal"_":"_formal_","_"core"_":"_core_","_"symproperty"_":"_SymProperty
		}
	}
	//w Result,!
	//w "",!
	q Final
}

/// Creator:wuzhe
/// CreatDate:2022-10-10
/// Description：判断数据是否在体格检查字典中
/// Table: CT.WDT.CDSS.PhysicalExamDict：体格检查字典
/// Input:Context：字符串
/// Output: 1：是，0：否，1^体格检查名：入参是体格检查的别名
/// Others: w ##class(web.CDSS.Demo.PatientInfoRenew).WhetherPyhExamDict("毛发变白")
/// w ##class(web.CDSS.Demo.PatientInfoRenew).WhetherPyhExamDict("脑卒中样发作")
/// w ##class(web.CDSS.Demo.PatientInfoRenew).WhetherPyhExamDict("体温")
ClassMethod WhetherPyhExamDict(Context As %String) As %String
{
	q:Context="" 0
	s result=0
	s ID=$o(^CT.WDT.CDSS.PhysicalExamDictI("NameIndex"," "_Context,0))  //体格检查字典判断
	if (ID="")
	{
		s ID=$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.PhysicalExamDict",Context,0))  //别名通用名判断
		if (ID'="")
		{
			s PhysicalExamName=$lg($g(^CT.WDT.CDSS.PhysicalExamDictD(ID)),3) //体格检查名
			s result=1_"^"_PhysicalExamName
		}
		else
		{
			s CommonID=$o(^CT.WDT.CDSS.CommonDictI("TypeDescIndex","3",Context,0))  //通用名字典进行判断
			if CommonID=""
			{
				s CommonID=$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.CommonDict",Context,0))  //别名通用名判断
				if CommonID'=""
				{
					s DictDesc=$lg($g(^CT.WDT.CDSS.CommonDictD(CommonID)),4)  //通用名名称
					s result=1_"^"_DictDesc
				}
			}
			else
			{
				s result=1
			}
		}
	}
	else
	{
		s Flag=$lg($g(^CT.WDT.CDSS.PhysicalExamDictD(ID)),10) //使用标志（0编辑中，1已删除，2已审核）
		//体温即在体格检查字典又在通用名字典
		if (Flag=0)||(Flag=1)
		{
			s CommonID=$o(^CT.WDT.CDSS.CommonDictI("TypeDescIndex","3",Context,0))  //通用名字典进行判断
			if CommonID=""
			{
				s CommonID=$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.CommonDict",Context,0))  //别名通用名判断
				if CommonID'=""
				{
					s DictDesc=$lg($g(^CT.WDT.CDSS.CommonDictD(CommonID)),4)  //通用名名称
					s result=1_"^"_DictDesc
				}
			}
			else
			{
				s result=1
			}
		}
		
		q:(Flag=0)||(Flag=1) result
		s result=1
	}
	q result
}

/// Creator:wuzhe
/// CreatDate:2022-10-10
/// Description：病历体格检查中的生命体征过NLP存生命体征表
/// Input：nlp json返回的字符串
/// Output: 
/// w ##class(web.CDSS.Demo.PatientInfoRenew).SignInfoToNLP("体温：36.5℃，呼吸：20次/分，血压：90/120mmhg，脉搏：30次/分")
/// w ##class(web.CDSS.Demo.PatientInfoRenew).SignInfoToNLP("患者3天前出现发热，最高温度39℃")
/// w ##class(web.CDSS.Demo.PatientInfoRenew).SignInfoToNLP("患者出现头晕、头痛，在家查血压80/120mmhg")
/// w ##class(web.CDSS.Demo.PatientInfoRenew).SignInfoToNLP("持续发热2天，最高温39℃")  
/// w ##class(web.CDSS.Demo.PatientInfoRenew).SignInfoToNLP("持续发热1天，体温均>39℃，最高达41℃")
ClassMethod SignInfoToNLP(Context As %String)
{
	q:Context="" "[]"
	
	//遂宁的门诊会传生命体征，住院不传这四个字
	if Context["生命体征"
	{
		s SignInfo=$p(Context,"生命体征",2)
		s SignInfo=$e(Context,1,50) //取字符串前50个字符
	}
	else
	{
		s SignInfo=$e(Context,1,200) //取字符串前200个字符
	}
	s NLPString=..GetStructedDataAPI(SignInfo) //过NLP
	q:(NLPString="[]")||(NLPString["error") "[]"
	
	s NLPArray=[].%FromJSON(NLPString)
	
	s Result=[] 
	for i=0:1:NLPArray.%Size()-1
	{
		s ItemJson=NLPArray.%Get(i)
		s IsPositiveFlag=ItemJson.%Get("type")
		continue:(IsPositiveFlag'="sign")&(IsPositiveFlag'="+sign") //去除NLP解析不是sign的数据
		if ItemJson.%IsDefined("sign_name") //体征名称
		{
			s sign=ItemJson.%Get("sign_name").%Get("name")
		}
		elseif ItemJson.%IsDefined("sign") //体征名称
		{
			s sign=ItemJson.%Get("sign").%Get("name")
		}
		else
		{
			s sign=""
		}
		continue:sign=""
		s sign=$case(sign,"收缩压/舒张压":"血压","T":"体温","P":"脉搏","R":"呼吸","口腔温度":"口温",:sign)
		
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
		continue:value=""
		if (value'="0")&(value'["/") //例：口腔温度39度
		{
			s value=+value //只取数字
		}
		
		if ItemJson.%IsDefined("sign_unit") //体征单位
		{
			s unit=ItemJson.%Get("sign_unit").%Get("name")
		}
		else
		{
			s unit=""
		}
		
		if ItemJson.%IsDefined("happen_time") //发生时间
		{
			s happentime=ItemJson.%Get("happen_time").%Get("name")
		}
		else
		{
			s happentime=""
		}
		continue:happentime["前"  //现病史中会写 "患者3天前出现发热，最高温度39℃"，3天前的数据不应作为患者当前触发规则的数据
		
		s ChildItem={}
		d ChildItem.%Set("key",sign)
		d ChildItem.%Set("value",value)
		d ChildItem.%Set("unit",unit)
		d ChildItem.%Set("happentime",happentime)
		d Result.%Push(ChildItem)
		if (sign="血压")&(value["/")
		{
			s ChildItem={}
			d ChildItem.%Set("key","收缩压")
			d ChildItem.%Set("value",$p(value,"/",1))
			d ChildItem.%Set("unit",unit)
			d ChildItem.%Set("happentime",happentime)
			d Result.%Push(ChildItem)
			
			s ChildItem={}
			d ChildItem.%Set("key","舒张压")
			d ChildItem.%Set("value",$p(value,"/",2))
			d ChildItem.%Set("unit",unit)
			d ChildItem.%Set("happentime",happentime)
			d Result.%Push(ChildItem)
		}
	}
	q Result.%ToJSON()
}

/// Creator:wuzhe
/// CreatDate:2023-04-11
/// Description:获取疾病编码
/// Input：DiseaseName:疾病名称
/// Output: DiagnosisCode:疾病编码 (1)疾病编码 (2)疾病编码^^疾病名称 (3)""
/// Others: w ##class(web.CDSS.Demo.NLPProcessingData).GetDiseaseCode("感冒")
/// Others: w ##class(web.CDSS.Demo.NLPProcessingData).GetDiseaseCode("Bruton病")
ClassMethod GetDiseaseCode(DictName As %String)
{
	q:DictName="" ""
	//诊断编码,诊断名称,西医诊断编码,中医诊断编码,中医证候编码
	s (DiagnosisCode,DiagnosisName,DiseaseCode,TCMDiseaseCode,TCMSyCode)=""
	// DictName是诊断别名时，转成DiagnosisName
	
	//西医疾病判断
	if $d(^CT.WDT.CDSS.DiseaseDictI("NameIndex"," "_$ZCONVERT(DictName,"U")))  ///先判断实体是否存在疾病字典表（用诊断名称）
	{
		s DiseaseID=$o(^CT.WDT.CDSS.DiseaseDictI("NameIndex"," "_$ZCONVERT(DictName,"U"),0))
		s:DiseaseID'="" DiseaseCode=$lg($g(^CT.WDT.CDSS.DiseaseDictD(DiseaseID)),2)
	}
	else ///不存在则判断通用别名表中是否存在（诊断的别名判断）
	{
		s DisBieMingID=""
		s DisBieMingID=$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.DiseaseDict",DictName,0)) ///通用字典表别名索引
		s:DisBieMingID'="" DiseaseCode=$lg($g(^CT.WDT.CDSS.DiseaseDictD(DisBieMingID)),2)
		s:DisBieMingID'="" DiagnosisName=$lg($g(^CT.WDT.CDSS.DiseaseDictD(DisBieMingID)),3)
	}
	//中医疾病判断
	if $d(^CT.WDT.CDSS.TCMDiseaseI("NameIndex",$ZCONVERT(DictName,"U")))  ///先判断实体是否存在中医疾病字典表
	{
		s TCMDiseaseID=$o(^CT.WDT.CDSS.TCMDiseaseI("NameIndex",$ZCONVERT(DictName,"U"),0))
		s:TCMDiseaseID'="" TCMDiseaseCode=$lg($g(^CT.WDT.CDSS.TCMDiseaseD(TCMDiseaseID)),2)
	}
	else ///不存在则判断通用别名表中是否存在
	{
		s TCMBieMingID=""
		s TCMBieMingID=$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.TCMDisease",DictName,0)) ///通用字典表别名索引
		s:TCMBieMingID'="" TCMDiseaseCode=$lg($g(^CT.WDT.CDSS.TCMDiseaseD(TCMBieMingID)),2)
		s:TCMBieMingID'="" DiagnosisName=$lg($g(^CT.WDT.CDSS.TCMDiseaseD(TCMBieMingID)),3)
	}
	//证型判断
	if $d(^CT.WDT.CDSS.TCMSymptomI("NameIndex"," "_$ZCONVERT(DictName,"U")))  ///先判断实体是否存在中医证候字典表
	{
		s TCMSymptomID=$o(^CT.WDT.CDSS.TCMSymptomI("NameIndex"," "_$ZCONVERT(DictName,"U"),0))
		s:TCMSymptomID'="" TCMSyCode=$lg($g(^CT.WDT.CDSS.TCMSymptomD(TCMSymptomID)),2)
	}
	else ///不存在则判断通用别名表中是否存在
	{
		s TCMSyBieMingID=""
		s TCMSyBieMingID=$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.TCMSymptom",DictName,0)) ///通用字典表别名索引
		s:TCMSyBieMingID'="" TCMSyCode=$lg($g(^CT.WDT.CDSS.TCMSymptomD(TCMSyBieMingID)),2)
		s:TCMSyBieMingID'="" DiagnosisName=$lg($g(^CT.WDT.CDSS.TCMSymptomD(TCMSyBieMingID)),3)
	}
	
	if (DiseaseCode'="")
	{
		s DiagnosisCode=DiseaseCode
	}
	else
	{
		if (TCMDiseaseCode'="")
		{
			s DiagnosisCode=TCMDiseaseCode
		}
		else
		{
			s DiagnosisCode=TCMSyCode
		}
	}
	
	if DiagnosisCode=""
	{
		q ""
	}
	else 	//诊断编码不为空
	{
		if DiagnosisName'=""
		{
			s DiagnosisCode=DiagnosisCode_"^^"_DiagnosisName
		}
	}
	q DiagnosisCode
}

}
