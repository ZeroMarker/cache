/// Creator:陈代雷
/// CreatDate:2020-06-03
/// Description:内部交互接口
Class web.CDSS.MachineLearning.InteractiveInterface Extends %RegisteredObject
{

/// Creator:陈代雷
/// CreatDate:2020-06-04
/// Description:初始化患者信息
/// Table:
/// Input: BasicInfo : 患者基本信息 {"IDNO": "患者主索引", "PatientDR":"病人标识","VisitID":"就诊次","Name":"患者姓名","UserID":"医生ID","UserName":"医生姓名","DeptCode":"科室编码","DeptName":"科室名称","PageSource":"数据来源"}
/// Return:标准版信息
/// Others:w ##class(web.CDSS.MachineLearning.InteractiveInterface).GetBasicInfo(BasicInfo)
ClassMethod GetBasicInfo(BasicInfo As %String) As %String
{
    s info=[].%FromJSON(BasicInfo)
    s result=[]
    s BasicJson={}
    d BasicJson.%Set("IDNO",info.%Get("IDNO"))
    d BasicJson.%Set("PatientDR",info.%Get("PatientDR"))
    d BasicJson.%Set("VisitID",info.%Get("VisitID"))
    d BasicJson.%Set("VisitType",..ConvertVisitType(info.%Get("VisitType")))
    d BasicJson.%Set("UserID",info.%Get("UserID"))
    d BasicJson.%Set("UserName",info.%Get("UserName"))
    d BasicJson.%Set("CTLocID",info.%Get("DeptCode"))
    d BasicJson.%Set("CTLocDesc",info.%Get("DeptName"))
    //d BasicJson.%Set("Config",##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSSdyn20200416"))
    //s PatientUserInfo=IDNO_"^"_PatientDR_"^"_VisitID_"^"_VisitType_"^"_UserID_"^"_UserName_"^"_CTLocID_"^"_CTLocDesc_"^"_Config  //调用后台接口的参数
    s PatientMaster={}  //基础信息字典
    d PatientMaster.%Set("DataClass","PatientMaster")
    s PatientMasterC=[]  ////基础信息详细内容
    s PatientMasterDict={}  //单个基础信息详细内容
    s PatID=$o(^WDT.CDSS.PatientMasterI("PatDRIndex",info.%Get("PatientDR"),0))
    s (Name,Gender,Age,Birthday)=""
    s:PatID'="" Name=$lg($g(^WDT.CDSS.PatientMasterD(PatID)),6)
    s:PatID'="" Gender=$lg($g(^WDT.CDSS.PatientMasterD(PatID)),7)
    s:PatID'="" Age=$lg($g(^WDT.CDSS.PatientMasterD(PatID)),8)
    s:PatID'="" Birthday=$lg($g(^WDT.CDSS.PatientMasterD(PatID)),17)
    d PatientMasterDict.%Set("MedicareCardNum",info.%Get("IDNO")) 	//病人标识 //医保卡号
    d PatientMasterDict.%Set("IDCardNumber",info.%Get("IDNO")) 		//病人标识, //身份证号
    d PatientMasterDict.%Set("Name",Name)   						//姓名
    d PatientMasterDict.%Set("Sex",Gender)  			//性别（性别病史）
    d PatientMasterDict.%Set("Age",Age) 				//年龄
    d PatientMasterDict.%Set("Profession","") 			//职业（职业病史）
    d PatientMasterDict.%Set("Nation","")				//民族
    d PatientMasterDict.%Set("Marriage","") 			//婚姻
    d PatientMasterDict.%Set("BloodGroup","") 			//血型
    d PatientMasterDict.%Set("Country","") 				//国籍
    d PatientMasterDict.%Set("Birthplace","") 			//籍贯
    d PatientMasterDict.%Set("CurrentAddress","") 		//现住址
    d PatientMasterDict.%Set("PhoneNumber","") 			//电话
    d PatientMasterDict.%Set("Birthday",Birthday)  //出生日期
    d PatientMasterC.%Push(PatientMasterDict)
    d BasicJson.%Set("children",PatientMasterC)
    d result.%Push(BasicJson)
    q result.%ToJSON()
}

/// Creator:陈代雷
/// CreatDate:2020-06-05
/// Description:同步诊断数据
/// Table:
/// Input: DiagInfo : 患者基本信息 {"IDNO": "患者主索引", "PatientDR": "病人标识", "VisitID": "就诊次", "Name": "患者姓名", "UserID": "医生ID", "UserName": "医生姓名", "DeptCode": "科室编码", "DeptName": "科室名称", "PatientInfo": {"Gender": "性别", "BirthDate": "出生日期", "PregnancyStatus": "妊娠状态"}, "DiagnosisList": [{"DiagnosisId": "诊断ID", "DiagnosisCode": "诊断编码", "DiagnosisName": "诊断名称", "DiagnosisType": "诊断类型", "DiagnosisDoctorType": "诊断分类", "IsMainDiagnosis": "是否主诊断", "DiagnosisSequence": "诊断顺序", "RecordTime": "开立时间", "DiagnosisDoctorId": "开立医生ID", "DiagnosisDoctorName": "开立医生名称"}]}
/// Return:标准版诊断信息
/// Others:w ##class(web.CDSS.MachineLearning.InteractiveInterface).SynchronousDiagInfo(DiagInfo)
ClassMethod SynchronousDiagInfo(DiagInfo As %String) As %String
{
    s info=[].%FromJSON(DiagInfo)
    s DiagJson={}
    d DiagJson.%Set("IDNO",info.%Get("IDNO"))
    d DiagJson.%Set("PatientDR",info.%Get("PatientDR"))
    d DiagJson.%Set("VisitID",info.%Get("VisitID"))
    d DiagJson.%Set("VisitType",..ConvertVisitType(info.%Get("VisitType")))
    d DiagJson.%Set("UserID",info.%Get("UserID"))
    d DiagJson.%Set("UserName",info.%Get("UserName"))
    d DiagJson.%Set("CTLocID",info.%Get("DeptCode"))
    d DiagJson.%Set("CTLocDesc",info.%Get("DeptName"))
    s PatientUserInfo=info.%Get("IDNO")_"^"_info.%Get("PatientDR")_"^"_info.%Get("VisitID")_"^"_..ConvertVisitType(info.%Get("VisitType"))_"^"_info.%Get("UserID")_"^"_info.%Get("UserName")_"^"_info.%Get("DeptCode")_"^"_info.%Get("DeptName")
    //d DiagJson.%Set("Config",##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSSdyn20200416"))
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
    if (##class(%Library.TimeStamp).IsValid(info.%Get("PatientInfo").%Get("BirthDate")))
    {
    	s Age=##class(web.CDSS.MachineLearning.InteractiveInterface).CurrentAge($zdh(info.%Get("PatientInfo").%Get("BirthDate"),3))
    }
    else
    {
	    s Age=""
    }
    d PatientMasterDict.%Set("Age",Age) //年龄
    d PatientMasterDict.%Set("Profession","") //职业（职业病史）
    d PatientMasterDict.%Set("Nation","") //民族
    d PatientMasterDict.%Set("Marriage","") //婚姻
    d PatientMasterDict.%Set("BloodGroup","") //血型
    d PatientMasterDict.%Set("Country","") //国籍
    d PatientMasterDict.%Set("Birthplace","") //籍贯
    d PatientMasterDict.%Set("CurrentAddress","") //现住址
    d PatientMasterDict.%Set("PhoneNumber","") //电话
    d PatientMasterDict.%Set("Birthday",info.%Get("PatientInfo").%Get("BirthDate"))  //出生日期
    d PatientMasterC.%Push(PatientMasterDict)
    d PatientMaster.%Set("children",PatientMasterC)
    d children.%Push(PatientMaster)
 // d DiagJson.%Set("IDNO",info.%Get("IDNO"))  //患者主索引
 //    d DiagJson.%Set("PatientDR",info.%Get("PatientDR"))  //病人标识
 //    d DiagJson.%Set("VisitID",info.%Get("VisitID"))  //就诊次
 //    d DiagJson.%Set("Name",info.%Get("Name"))  //患者姓名
 //    d DiagJson.%Set("UserID",info.%Get("UserID"))  //医生ID
 //    d DiagJson.%Set("UserName",info.%Get("UserName"))  //医生姓名
 //    d DiagJson.%Set("DeptCode",info.%Get("DeptCode"))  //科室编码
 //    d DiagJson.%Set("DeptName",info.%Get("DeptName"))  //科室名称
 //    d DiagJson.%Set("Sex",info.%Get("PatientInfo").%Get("Gender"))    //性别
    //d DiagJson.%Set("PregnancyStatus",info.%Get("PatientInfo").%Get("PregnancyStatus"))  //妊娠状态
    ///诊断信息表
    //s DiagnosisInfo={}  //诊断信息
    //d DiagnosisInfo.%Set("DataClass","DiagnosisInfo")
    //s DiagnosisInfoC=[]  ////基础信息详细内容
    s DiagnosisList=info.%Get("DiagnosisList")  //诊断信息列表
    //如果是删除诊断，全量推过来为空
    if (DiagnosisList.%Size()=0)
    {
        //d ##class(web.CDSS.MachineLearning.ParseMode).DeletePatientDiagnose(info.%Get("PatientDR"),info.%Get("VisitID"),info.%Get("IDNO"),##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSSdyn20200416"))
        return "DeleteDiagnosisInfo"
    }
    else
    {
	    s DiagFlag=""
        for i=0:1:(DiagnosisList.%Size()-1)
        {
	        s DiagContrastName=##class(web.CDSS.IMP.ContrastDict).GetDiectName(DiagnosisList.%Get(i).%Get("DiagnosisName"),##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401"),"诊断字典")
	        for Diagi=1:1:$l(DiagContrastName,"&%")
	        {
		        s DiagnosisName=$p(DiagContrastName,"&%",Diagi)
	            s DiagnosisInfo={}  //诊断信息
	            d DiagnosisInfo.%Set("DataClass","DiagnosisInfo")
	            s DiagnosisInfoC=[]  //基础信息详细内容
	            s DiagnosisInfoDict={}  //单个诊断信息详细内容
	            d DiagnosisInfoDict.%Set("DiagnosisSequence",DiagnosisList.%Get(i).%Get("DiagnosisSequence"))  //诊断ID
	            s DiagnosisCode=##class(web.CDSS.CMKB.DiseaseDictDetail).GetCodeByName(DiagnosisName)
	            i DiagnosisCode="" s DiagnosisCode=DiagnosisList.%Get(i).%Get("DiagnosisCode")
	            d DiagnosisInfoDict.%Set("DiagnosisCode",DiagnosisCode)  								//诊断编码 改为知识库编码，知识库不存在则保存his编码 20230420
	            d DiagnosisInfoDict.%Set("DiagnosisName",DiagnosisName)  								//诊断名称
	            d DiagnosisInfoDict.%Set("DiagnosisType",DiagnosisList.%Get(i).%Get("DiagnosisType"))  	//诊断类型
	            d DiagnosisInfoDict.%Set("DiagnosisDesc","")  //诊断描述
	            d DiagnosisInfoDict.%Set("ChildDiagnosisFlag",$CASE(DiagnosisList.%Get(i).%Get("IsMainDiagnosis"),1:0,0:1,:1))  //子诊断标记，默认否
	            d DiagnosisInfoDict.%Set("DiagnosisTime",DiagnosisList.%Get(i).%Get("RecordTime"))  	//开立时间
	            ;d DiagnosisInfoDict.%Set("DiagnosisStatus","")  //诊断状态
	            d DiagnosisInfoDict.%Set("DiagnosisStatus",$CASE(DiagnosisList.%Get(i).%Get("DiagnosisStatus"),0:"确诊",1:"待诊",2:"疑诊","":""))  //诊断状态
	            d DiagnosisInfoDict.%Set("ProjectName",DiagnosisList.%Get(i).%Get("DiagnosisName"))
	            d DiagnosisInfoDict.%Set("DiagnosisClass",DiagnosisList.%Get(i).%Get("DiagnosisClass"))			//诊断类别
	            d DiagnosisInfoDict.%Set("HISDiagnosisCode",DiagnosisList.%Get(i).%Get("DiagnosisCode"))		//His诊断编码
	            d DiagnosisInfoDict.%Set("HISDiagnosisID",DiagnosisList.%Get(i).%Get("DiagnosisId"))			//His诊断ID
		        s DiagFlag=DiagnosisList.%Get(i).%Get("DiagFlag")  
	            d DiagnosisInfoC.%Push(DiagnosisInfoDict)
	            d DiagnosisInfo.%Set("children",DiagnosisInfoC)
	            d children.%Push(DiagnosisInfo)
	            /*if (##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSSFWK20211209")="Y")
	            {
		            try	//预警 2021-11-25
			        {
				        //如果患者弹出预警表里已经存在了该患者该诊断相关的预警 则不再执行后续算法
				        if ('$d(^CT.WDT.CDSS.PatientWarningListI("UniquePatIndex",info.%Get("PatientDR"),info.%Get("VisitID"),DiagnosisList.%Get(i).%Get("DiagnosisName"))))
				        {
					        d ##class(web.CDSS.WarnDecision.AllOrderWarning).DiagWarningToDoc(PatientUserInfo,DiagnosisList.%Get(i).%Get("DiagnosisName"),11)
					    }
				    }
				    catch e
				    {
					    //s ^TMPCDSSXWHERROR=OrderEntry.%Get("OrderContent")_"&&"_e.Name
					}
		        }*/	
	        }
        }
        //d DiagnosisInfo.%Set("children",DiagnosisInfoC)
        //d children.%Push(DiagnosisInfo)
        d DiagJson.%Set("OperationFlag",DiagFlag)
        d DiagJson.%Set("children",children)
        s config=##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020061601")
        
        //w DiagJson.%ToJSON(),!
        s RationalResult=##Class(web.CDSS.MachineLearning.DataVerification).DataRationalisation(DiagJson.%ToJSON())  //对第三方数据json串进行数据合理性校验，包括（数据类型是否匹配，主键是否存在等）
        s RationalResult=[].%FromJSON(RationalResult)
        s UnifomResult=##Class(web.CDSS.MachineLearning.DataVerification).DataConsistency(DiagJson.%ToJSON())  //对第三方数据json串进行基本信息、就诊信息数据一致性和临床信息完整性校验
        s UnifomResult=[].%FromJSON(UnifomResult)
        if (RationalResult.%Size()=0)&(UnifomResult.%Size()=0)  //如果没有错误信息
        {
            return DiagJson.%ToJSON()       
        }
        elseif(config="Y")  //有错误信息，但是允许强制交互
        {
            return DiagJson.%ToJSON()
        }
        else  //有错误信息，不允许强制交互
        {
            for i=0:1:UnifomResult.%Size()-1
            {
                d RationalResult.%Push(UnifomResult.%Get(i))
            } 
            return RationalResult.%ToJSON()  
        }
    }
    q ""
}

/// w ##class(web.CDSS.MachineLearning.InteractiveInterface).CurrentAge("56931")
ClassMethod CurrentAge(date As %Date = "") As %Integer
{
    s age =$Select(date="":"",1:($ZD($H,8)-$ZD(date,8)\10000))
    q age
}

/// Creator:陈代雷
/// CreatDate:2020-06-09
/// Description:根据第三方诊断ID，去对照表中获取到我们的诊断编码
/// Table:
/// Input: DiagnosisId:诊断id
/// Return:标准版诊断信息
/// Others:w ##class(web.CDSS.MachineLearning.InteractiveInterface).GetDiagNodeByDiagId()
ClassMethod GetDiagNodeByDiagId(DiagnosisId As %String) As %String
{
    q DiagnosisId
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
    //d CaseJson.%Set("Config",##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSSdyn20200416"))
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
    if (##class(%Library.TimeStamp).IsValid(info.%Get("PatientInfo").%Get("BirthDate")))
    {
    	s Age=##class(web.CDSS.MachineLearning.InteractiveInterface).CurrentAge($zdh(info.%Get("PatientInfo").%Get("BirthDate"),3))
    }
    else
    {
	    s Age=""
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
    d CaseJson.%Set("PregnancyStatus",info.%Get("PatientInfo").%Get("PregnancyStatus"))  //妊娠状态
    ///病例信息表
    s CaseInfo={}  //病例信息
    d CaseInfo.%Set("DataClass","PatientVisit")
    s CaseInfoC=[]  //病例信息详细内容
    s CaseList=info.%Get("ProgressNoteList")  //病例信息列表，医院数据
    s MRCode=CaseList.%Get("ProgressID")
    d CaseJson.%Set("MRCode",MRCode)
    s CaseInfoDict={}  //单个基础信息详细内容
    d CaseInfoDict.%Set("VisitType",..ConvertVisitType(info.%Get("VisitType"))) //就诊类型（急诊、门诊、住院）
    d CaseInfoDict.%Set("TreatmentTime",CaseList.%Get("RecordTime")) //就诊时间
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
	        d CaseInfoDict.%Set("ChiefCompSum",$replace(##class(web.CDSS.CMKB.FunLib).TransLinefeed(MessageList.%Get(i).%Get("value")),"""","'")) //主诉概述
            //d CaseInfoDict.%Set("ChiefCompSum",$replace(MessageList.%Get(i).%Get("value"),$c(13),"")) //主诉概述
        }
        if (MessageList.%Get(i).%Get("key")="现病史")
        {
            d CaseInfoDict.%Set("CurrentMedHisSum",$replace(##class(web.CDSS.CMKB.FunLib).TransLinefeed(MessageList.%Get(i).%Get("value")),"""","'")) //现病史概述
        }
        if ((MessageList.%Get(i).%Get("key")="既往史")||(MessageList.%Get(i).%Get("key")="出院情况"))		//2022-03-25 新增出院情况
        {
            d CaseInfoDict.%Set("PastDiagnosisSum",$replace(##class(web.CDSS.CMKB.FunLib).TransLinefeed(MessageList.%Get(i).%Get("value")),"""","'")) //既往史概述
        }
        if (MessageList.%Get(i).%Get("key")="家族史")
        {
            d CaseInfoDict.%Set("FamilyHisSum",$replace(##class(web.CDSS.CMKB.FunLib).TransLinefeed(MessageList.%Get(i).%Get("value")),"""","'")) //家族史概述
        }
        if (MessageList.%Get(i).%Get("key")="个人史")
        {
            d CaseInfoDict.%Set("PersonalHisSum",$replace(##class(web.CDSS.CMKB.FunLib).TransLinefeed(MessageList.%Get(i).%Get("value")),"""","'")) //个人史概述
        }
        if (MessageList.%Get(i).%Get("key")="婚育史")
        {
            d CaseInfoDict.%Set("MarryHisSum",$replace(##class(web.CDSS.CMKB.FunLib).TransLinefeed(MessageList.%Get(i).%Get("value")),"""","'")) //婚育史概述
        }
        if (MessageList.%Get(i).%Get("key")="月经史")
        {
            d CaseInfoDict.%Set("MenstrualHisSum",$replace(##class(web.CDSS.CMKB.FunLib).TransLinefeed(MessageList.%Get(i).%Get("value")),"""","'")) //月经史概述
        }
        if (MessageList.%Get(i).%Get("key")="过敏史")
        {
            d CaseInfoDict.%Set("AllergyHisSum",$replace(##class(web.CDSS.CMKB.FunLib).TransLinefeed(MessageList.%Get(i).%Get("value")),"""","'")) //过敏史概述
        }
        if (MessageList.%Get(i).%Get("key")="体格检查")
        {
            d CaseInfoDict.%Set("PhysicalExamSum",$replace(##class(web.CDSS.CMKB.FunLib).TransLinefeed(MessageList.%Get(i).%Get("value")),"""","'")) //体格检查概述
        }
        if (MessageList.%Get(i).%Get("key")="转科检查")
        {
            d CaseInfoDict.%Set("SpecExamSum",$replace(##class(web.CDSS.CMKB.FunLib).TransLinefeed(MessageList.%Get(i).%Get("value")),"""","'")) //转科检查概述
        }
        //新增诊断信息解析 2021-10-21
        if (MessageList.%Get(i).%Get("key")="初步诊断")
        {
	    	d CaseInfoDict.%Set("PrimaryDiag",$replace(##class(web.CDSS.CMKB.FunLib).TransLinefeed(MessageList.%Get(i).%Get("value")),"""","'")) 		//初步诊断概述    
	    }
        if (MessageList.%Get(i).%Get("key")="确诊诊断")
        {
	    	d CaseInfoDict.%Set("DefiniteDiag",$replace(##class(web.CDSS.CMKB.FunLib).TransLinefeed(MessageList.%Get(i).%Get("value")),"""","'"))  	//确诊诊断概述
	    }
        if (MessageList.%Get(i).%Get("key")="补充诊断")
        {
	    	d CaseInfoDict.%Set("SuppleDiag",$replace(##class(web.CDSS.CMKB.FunLib).TransLinefeed(MessageList.%Get(i).%Get("value")),"""","'")) 		//补充诊断概述
	    }
        if (MessageList.%Get(i).%Get("key")="修正诊断")
        {
	    	d CaseInfoDict.%Set("CurrectionDiag",$replace(##class(web.CDSS.CMKB.FunLib).TransLinefeed(MessageList.%Get(i).%Get("value")),"""","'")) 	//修正诊断概述   
	    }
	    //新增辅助检查信息解析 2021-12-03
	    if (MessageList.%Get(i).%Get("key")="辅助检查")
        {
	    	d CaseInfoDict.%Set("LabExamSum",$replace(##class(web.CDSS.CMKB.FunLib).TransLinefeed(MessageList.%Get(i).%Get("value")),"""","'")) 		//修正诊断概述   
	    }
	    //新增出院诊断 2022-03-25
	    if (MessageList.%Get(i).%Get("key")="出院诊断")
	    {
			d CaseInfoDict.%Set("DischargeDiag",$replace(##class(web.CDSS.CMKB.FunLib).TransLinefeed(MessageList.%Get(i).%Get("value")),"""","'")) 	//出院诊断概述     
		}
    }
    d CaseInfoC.%Push(CaseInfoDict)
    d CaseInfo.%Set("children",CaseInfoC)
    d children.%Push(CaseInfo)
    //s NLPSignInfo=##class(web.CDSS.MachineLearning.NLPProcessingData).GetStructedDataAPI(MessageList.%Get(i).%Get("value"))
    //s NLPSignInfo=[].%FromJSON(NLPSignInfo)
    if (CaseInfoDict.%Get("PhysicalExamSum")'="")
    {
        s PhysicalExamSum=##class(web.CDSS.MachineLearning.NLPProcessingData).SignInfoToNLP(CaseInfoDict.%Get("PhysicalExamSum"))
        if PhysicalExamSum'="[]"
        {
	       	s PhysicalExamSum=[].%FromJSON(PhysicalExamSum)
	       	///体征信息表
	        s SignInfo={}  //体征信息
	        d SignInfo.%Set("DataClass","SignInfo")
	        s SignInfoC=[]  //体征信息详细内容
	        s SignList=info.%Get("ProgressNoteList")  //体征信息列表，医院数据
	        s SignInfoDict={}  //单个体征信息详细内容
	        ;s PhysicalExamSum=##class(web.CDSS.IMP.HospLinkRules).SplitPhysicalcheckToJson(CaseInfoDict.%Get("PhysicalExamSum"))
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
    }
    
    if (CaseInfoDict.%Get("CurrentMedHisSum")'="") //现病史中的体征信息存体征信息表
    {
	    s CurrentMedHisSum=##class(web.CDSS.MachineLearning.NLPProcessingData).SignInfoToNLP(CaseInfoDict.%Get("CurrentMedHisSum"))
        if (CurrentMedHisSum'="[]")
	    {
			s CurrentMedHisSum=[].%FromJSON(CurrentMedHisSum)	    
		    ///体征信息表
	        s SignInfo={}  //体征信息
	        d SignInfo.%Set("DataClass","SignInfo")
	        s SignInfoC=[]  //体征信息详细内容
	        s SignList=info.%Get("ProgressNoteList")  //体征信息列表，医院数据
	        s SignInfoDict={}  //单个体征信息详细内容
	        s CurrentMedHisSum=##class(web.CDSS.MachineLearning.NLPProcessingData).SignInfoToNLP(CaseInfoDict.%Get("CurrentMedHisSum"))
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
    s config=##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020061601")
    s RationalResult=##Class(web.CDSS.MachineLearning.DataVerification).DataRationalisation(CaseJson.%ToJSON())  //对第三方数据json串进行数据合理性校验，包括（数据类型是否匹配，主键是否存在等）
    s RationalResult=[].%FromJSON(RationalResult)
    s UnifomResult=##Class(web.CDSS.MachineLearning.DataVerification).DataConsistency(CaseJson.%ToJSON())  //对第三方数据json串进行基本信息、就诊信息数据一致性和临床信息完整性校验
    s UnifomResult=[].%FromJSON(UnifomResult)
    s CaseJson=##Class(web.CDSS.MachineLearning.NLPProcessingData).GetStructedDataJson(CaseJson.%ToJSON())
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
                continue:'(TableArr.%IsDefined(PatientJson.%Get("DataClass")))
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
/// CreatDate:2020-06-09
/// Description:同步医嘱信息
/// Table:
/// Input: CaseInfo : {"IDNO": "患者主索引", "PatientDR": "病人标识", "VisitID": "就诊次", "Name": "患者姓名", "UserID": "医生ID", "UserName": "医生姓名", "DeptCode": "科室编码", "DeptName": "科室名称", "PatientInfo": {"Gender": "性别", "BirthDate": "出生日期", "PregnancyStatus": "妊娠状态"}, "OrderEntry": {"OrderID": "医嘱唯一标识", "OrderClass": "医嘱类型", "OrderFlag": "医嘱 操作标识", "OrderType": "医嘱分类", "CreatTime": "医嘱创建时间", "StopTime": "医嘱作废时间", "DoctorId": "医生唯一标识", "DoctorName": "医生姓名", "CreateDeptCode": "开立科室代码", "CreateDeptName": "开立科室名称", "GroupSequence": "医嘱组顺序", "OrderCode": "医嘱代码", "OrderContent": "医嘱内容", "Dosage": "给药剂量", "Unit": "剂量单位", "Frequency": "频率", "Specification": "规格", "Pathway": "给药方式", "Sample": "样本", "Position": "部位", "Level": "手术等级", "IncisionType": "切口类型", "Anesthesia": "麻醉方式", "PreoperativeDiagnose": "术前诊断"}}
/// Return:
/// Others:w ##class(web.CDSS.MachineLearning.InteractiveInterface).SynchronizeOrder(OrderInfo)
ClassMethod SynchronizeOrder(OrderInfo As %String) As %String
{
    s info=[].%FromJSON(OrderInfo)
    s OrderJson={}
    d OrderJson.%Set("IDNO",info.%Get("IDNO"))
    d OrderJson.%Set("PatientDR",info.%Get("PatientDR"))
    d OrderJson.%Set("VisitID",info.%Get("VisitID"))
    d OrderJson.%Set("VisitType",..ConvertVisitType(info.%Get("VisitType")))
    d OrderJson.%Set("UserID",info.%Get("UserID"))
    d OrderJson.%Set("UserName",info.%Get("UserName"))
    d OrderJson.%Set("CTLocID",info.%Get("DeptCode"))
    d OrderJson.%Set("CTLocDesc",info.%Get("DeptName"))
    if (info.%Get("UserName")=""){
	    d info.%Set("UserName","Demo")
	}
    k ^TMPOrder(info.%Get("IDNO"),info.%Get("UserName"))
    s ^TMPOrder(info.%Get("IDNO"),info.%Get("UserName"))=OrderInfo
    s OrderFlag=""  //医嘱操作标识
    //d OrderJson.%Set("Config",##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSSdyn20200416"))
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
    if (##class(%Library.TimeStamp).IsValid(info.%Get("PatientInfo").%Get("BirthDate")))
    {
    	s Age=##class(web.CDSS.MachineLearning.InteractiveInterface).CurrentAge($zdh(info.%Get("PatientInfo").%Get("BirthDate"),3))
    }
    else
    {
	    s Age=""
    }
    //s Age=($h-$zdh(info.%Get("PatientInfo").%Get("BirthDate"),3))/365
    d PatientMasterDict.%Set("Age",Age) //年龄
    d PatientMasterDict.%Set("Profession","") //职业（职业病史）
    d PatientMasterDict.%Set("Nation","") //民族
    d PatientMasterDict.%Set("Marriage","") //婚姻
    d PatientMasterDict.%Set("BloodGroup","") //血型
    d PatientMasterDict.%Set("Country","") //国籍
    d PatientMasterDict.%Set("Birthplace","") //籍贯
    d PatientMasterDict.%Set("CurrentAddress","") //现住址
    d PatientMasterDict.%Set("PhoneNumber","") //电话
    d PatientMasterDict.%Set("Birthday",info.%Get("PatientInfo").%Get("BirthDate"))  //出生日期
    d PatientMasterC.%Push(PatientMasterDict)
    d PatientMaster.%Set("children",PatientMasterC)
    d children.%Push(PatientMaster)
    //d OrderJson.%Set("Birthday",info.%Get("PatientInfo").%Get("BirthDate"))  //出生日期
    //d OrderJson.%Set("PregnancyStatus",info.%Get("PatientInfo").%Get("PregnancyStatus"))  //妊娠状态
    ///医嘱相关信息
    s OrderInfo={}  //医嘱信息
    d OrderInfo.%Set("DataClass","PatientVisit")
    s OrderInfoC=[]  //病例信息详细内容
    s AllOrderEntry=info.%Get("OrderEntry")  //医嘱信息列表，医院数据
    for i=0:1:(AllOrderEntry.%Size()-1)
    {
	    //b ;;
        s OrderEntry=AllOrderEntry.%Get(i)
        s OrderInfoDict={}  //单个基础信息详细内容
        s OrderType=OrderEntry.%Get("OrderType")  //医嘱分类
        s OrderClass=OrderEntry.%Get("OrderClass")  //医嘱类型
        s OrderFlag=OrderEntry.%Get("OrderFlag")  //医嘱操作标识
        
        if (OrderEntry.%Get("GroupSequence")="")
        {
	        d OrderEntry.%Set("GroupSequence","1")
	    }
        //2023-04-25 判断知识库类型
        s OType=$case(OrderType,"1":"药品","2":"检查","3":"检验医嘱","4":"手术","5":"护理","6":"护理","10":"其他",:"")
        s ConDictS=##class(web.CDSS.IMP.ContrastDict).GetDiectNameType(OrderEntry.%Get("OrderContent"),##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401"),OType)
        s OrderType=$p($p(ConDictS,",",1),"^",2)		//知识库类型
        /*if (OrderType=10)
        {
	       	//检查检验
	    	if $d(^CT.WDT.CDSS.ContrastDictI("IntDictDescIndex",##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401"),"检查检验",OrderEntry.%Get("OrderContent")))
	    	{
		    	//适用于2.0字典对照
				s OrderContrastID=$o(^CT.WDT.CDSS.ContrastDictI("IntDictDescIndex",##class(web.DHCBL.MKB.MKBConfig).GetConfigValue("CDSScdl2020072401"),"检查检验",OrderEntry.%Get("OrderContent"),0))
				s ConId=$lg($g(^CT.WDT.CDSS.ContrastDictD(OrderContrastID)),11)		//对接方字典DR
				s:ConId'="" Type=$lg($g(^CT.WDT.CDSS.ConExamDictD(ConId)),4)
				if Type="检查"
				{
				    s OrderType=2
				}
				else //检验项目/检验医嘱
				{
				    s OrderType=3
				} 	
	    	}
			//药品
			elseif $d(^CT.WDT.CDSS.ContrastDictI("IntDictDescIndex",##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401"),"药品",OrderEntry.%Get("OrderContent")))
			{
				s OrderType=1	
			}
			//护理
			elseif $d(^CT.WDT.CDSS.ContrastDictI("IntDictDescIndex",##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401"),"护理",OrderEntry.%Get("OrderContent")))
			{
				s OrderType=5	
			}
			//手术
			elseif $d(^CT.WDT.CDSS.ContrastDictI("IntDictDescIndex",##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401"),"手术",OrderEntry.%Get("OrderContent")))
        	{
	        	s OrderType=4	
	        }
	    }*/
        ///处方信息（药品）
        if (OrderType="药品")
        {
	        s DrugContrastName=##class(web.CDSS.IMP.ContrastDict).GetDiectName(OrderEntry.%Get("OrderContent"),##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401"),"药品")
	        for Diagi=1:1:$l(DrugContrastName,"&%")
	        {
		        s DrugName=$p(DrugContrastName,"&%",Diagi)
		        s DrugInfo={}  //药品信息
		        d DrugInfo.%Set("DataClass","DrugInfo")
		        s DrugInfoC=[]  //详细内容
	            s DrugInfoDict={}  //单个详细内容
	            if (OrderEntry.%IsDefined("PriorType"))
	            {
		            d DrugInfoDict.%Set("Type",OrderEntry.%Get("PriorType")) //类型(长期、临时（皮试）)
		        }
	            else
	            {
		            d DrugInfoDict.%Set("Type","Short") //类型(长期、临时（皮试）)
		        }
	            d DrugInfoDict.%Set("GroupFlag",OrderEntry.%Get("OrderID")) //医嘱单号
	            d DrugInfoDict.%Set("GroupSequence",OrderEntry.%Get("GroupSequence")) //组顺序
	            d DrugInfoDict.%Set("DrugCode",OrderEntry.%Get("OrderCode")) //药品编码
	            d DrugInfoDict.%Set("DrugName",DrugName) //药品名称
	            d DrugInfoDict.%Set("Usage",OrderEntry.%Get("Pathway")) //用法
	            d DrugInfoDict.%Set("Dose",OrderEntry.%Get("Dosage")) //剂量
	            //频率进行别名转换
	            s Frequency=OrderEntry.%Get("Frequency")
	            if Frequency'=""
	            {
		            s CommonID=$o(^CT.WDT.CDSS.AliasI("UPAliasIndex","CT.WDT.CDSS.FrequencyDict"," "_$ZCONVERT(Frequency,"U"),0))  //别名通用名判断
					if CommonID'=""
					{
						s Frequency=$lg($g(^CT.WDT.CDSS.FrequencyDictD(CommonID)),3)  //频率名称-频率字典表
					}
		        }
		        d DrugInfoDict.%Set("Frequency",Frequency) //频率
	            d DrugInfoDict.%Set("Unit",OrderEntry.%Get("Unit")) //单位
	            d DrugInfoDict.%Set("Specification",OrderEntry.%Get("Specification")) //规格
	            d DrugInfoDict.%Set("StartTime",OrderEntry.%Get("CreatTime")) //开始时间
	            d DrugInfoDict.%Set("StopTime",OrderEntry.%Get("StopTime")) //停止时间
	            d DrugInfoDict.%Set("Remarks","") //备注
	            d DrugInfoDict.%Set("ProjectName",OrderEntry.%Get("OrderContent")) //20211209
	            d DrugInfoC.%Push(DrugInfoDict)
	            d DrugInfo.%Set("children",DrugInfoC)
	        	d children.%Push(DrugInfo)
	        }
        }
        ///检查
        elseif (OrderType="检查")
        {
	        s ExamContrastName=##class(web.CDSS.IMP.ContrastDict).GetDiectName(OrderEntry.%Get("OrderContent"),##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401"),"检查")
	        for Diagi=1:1:$l(ExamContrastName,"&%")
	        {
		        s ExamName=$p(ExamContrastName,"&%",Diagi)
		        s ExamInfo={}  //检查信息
	            d ExamInfo.%Set("DataClass","ExamInfo")
	            s ExamInfoC=[]  //详细内容
	            s ExamInfoDict={}  //单个详细内容
	            d ExamInfoDict.%Set("GroupFlag",OrderEntry.%Get("OrderID")) //医嘱单号
	            d ExamInfoDict.%Set("GroupSequence",OrderEntry.%Get("GroupSequence")) //组顺序
	            d ExamInfoDict.%Set("ExamCode",OrderEntry.%Get("OrderCode")) //检查编码
	            d ExamInfoDict.%Set("ExamName",ExamName) //检查名称
	            d ExamInfoDict.%Set("ExamResultNum","") //检查结果顺序号
	            d ExamInfoDict.%Set("ExamResult","") //检查结果
	            d ExamInfoDict.%Set("ExamResultFlag","") //检查结果指标（阴性或阳性）
	            d ExamInfoDict.%Set("ExamResultDesc","") //检查结果概述
	            d ExamInfoDict.%Set("PartDR",OrderEntry.%Get("Position")) //部位（改成指针）
	            d ExamInfoDict.%Set("ExecuteTime","") //执行时间
	            d ExamInfoDict.%Set("ReportTime","") //报告时间
	            d ExamInfoDict.%Set("Remarks","") //备注
	            d ExamInfoDict.%Set("ProjectName",OrderEntry.%Get("OrderContent")) //20211209
	            d ExamInfoC.%Push(ExamInfoDict)
	           	d ExamInfo.%Set("children",ExamInfoC)
	       		d children.%Push(ExamInfo)
	        }
        }
        ///检验
        elseif ((OrderType="检验项目")||(OrderType="检验医嘱"))
        {
	        s ItemName=OrderEntry.%Get("OrderContent")
            s DictName=##class(web.CDSS.IMP.ContrastDict).GetDiectName(ItemName,##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401"),"检验")
            if DictName=ItemName
            {
	        	s DictName=##class(web.CDSS.IMP.ContrastDict).GetDiectName(ItemName,##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401"),"检验医嘱")   
	        }
	        for Labi=1:1:$l(DictName,"&%")
	        {
		        s LabName=$p(DictName,"&%",Labi)
		        ;s:LabName="阴道分泌物常规" LabName="阴道分泌物检查"
		    	s OrderConItems=##class(web.CDSS.IMP.LabOrderConItem).GetConItem(ItemName,##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401"))
		    	for CI=1:1:$l(OrderConItems,"^")
		    	{
			    	s LabItemName=$p(OrderConItems,"^",CI)
			    	s DictLabItemName=##class(web.CDSS.IMP.ContrastDict).GetDiectName(LabItemName,##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401"),"检验项目")
			        for DI=1:1:$l(DictLabItemName,"&%")
		    		{
			    		s OneLabItemName=$p(DictLabItemName,"&%",DI)
				        s LabInfo={}  //检查信息
			            d LabInfo.%Set("DataClass","LabInfo")
			            s LabInfoC=[]  //详细内容
			            s LabInfoDict={}  //单个详细内容
			            d LabInfoDict.%Set("GroupFlag",OrderEntry.%Get("OrderID")) //医嘱单号
			            //d LabInfoDict.%Set("GroupSequence",OrderEntry.%Get("GroupSequence")) //组顺序
			            d LabInfoDict.%Set("InspectionCode",OrderEntry.%Get("OrderCode")) //检验大项编码
			            /*s ItemName=OrderEntry.%Get("OrderContent")
			            s DictName=##class(web.CDSS.IMP.ContrastDict).GetDiectName(ItemName,##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401"),"检验")
			            if DictName=ItemName
			            {
				        	s DictName=##class(web.CDSS.IMP.ContrastDict).GetDiectName(ItemName,##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401"),"检验医嘱")   
				        }*/
			            d LabInfoDict.%Set("InspectionName",LabName) //检验大项名称
			            d LabInfoDict.%Set("LabItemCode","") //检验小项编码
			            d LabInfoDict.%Set("LabItemName",OneLabItemName) //检验小项名称
			            d LabInfoDict.%Set("LabResult","") //检验结果
			            d LabInfoDict.%Set("LabResultFlag","") //检验结果指标（阴性或阳性）
			            d LabInfoDict.%Set("Unit","") //单位
			            d LabInfoDict.%Set("Reference","") //参考值
			            if (OrderEntry.%Get("Sample")'="")  //如果标本为空，不传避免覆盖检验报告中的标本
			            {
			                d LabInfoDict.%Set("Specimen",OrderEntry.%Get("Sample"))  //标本
			            }
			            d LabInfoDict.%Set("ExecuteTime","") //执行时间
			            d LabInfoDict.%Set("ReportTime","") //报告时间
			            d LabInfoDict.%Set("Remarks","") //备注
			            d LabInfoDict.%Set("ProjectName",OrderEntry.%Get("OrderContent")) //20211209
			            d LabInfoC.%Push(LabInfoDict)
			            d LabInfo.%Set("children",LabInfoC)
			        	d children.%Push(LabInfo)
		    		}
	        	}
	        }
        }
        ///手术
        elseif (OrderType="手术")
        {
	        s OperContrastName=##class(web.CDSS.IMP.ContrastDict).GetDiectName(OrderEntry.%Get("OrderContent"),##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401"),OType)
            for Operi=1:1:$l(OperContrastName,"&%")
            {
	            s OperName=$p(OperContrastName,"&%",Operi)
	            s OperationInfo={}  //手术信息
	            d OperationInfo.%Set("DataClass","OperationInfo")
	            s OperationInfoC=[]  //详细内容
	            s OperationInfoDict={}  //单个详细内容        
	            d OperationInfoDict.%Set("OperNum","") //手术次数
	            d OperationInfoDict.%Set("OperSequence","") //手术顺序号
	            d OperationInfoDict.%Set("MainOperFlag","") //主手术标记
	            d OperationInfoDict.%Set("OperCode",OrderEntry.%Get("OrderCode")) //手术编码
	            d OperationInfoDict.%Set("OperName",OperName) //手术名称
	            d OperationInfoDict.%Set("OperDesc","") 		//手术描述
	            d OperationInfoDict.%Set("OperType",OrderEntry.%Get("Position")) //手术部位
	            d OperationInfoDict.%Set("OperPosition","") 	//手术体位
	            d OperationInfoDict.%Set("IntraoperDiagnosis","") //术中诊断
	            d OperationInfoDict.%Set("OperDuration","") 	//手术持续时间
	            d OperationInfoDict.%Set("OperStartTime","") 	//手术开始时间
	            d OperationInfoDict.%Set("OperEndTime","") 		//手术结束时间
	            d OperationInfoDict.%Set("OperClass",OrderEntry.%Get("OrderClass"))	//手术等级 
	            d OperationInfoDict.%Set("OperLevel",OrderEntry.%Get("Level"))	//手术等级
	            d OperationInfoDict.%Set("OperIncisionType",OrderEntry.%Get("IncisionType"))		//切口类型
	            d OperationInfoDict.%Set("OperAnest",OrderEntry.%Get("Anesthesia"))			//麻醉方式
	            d OperationInfoDict.%Set("ProjectName",OrderEntry.%Get("OrderContent")) //20211209
	            d OperationInfoDict.%Set("GroupFlag",OrderEntry.%Get("OrderID")) //医嘱单号
	            d OperationInfoC.%Push(OperationInfoDict)
	            d OperationInfo.%Set("children",OperationInfoC)
            	d children.%Push(OperationInfo)
            }
        }
        ///麻醉
        elseif (OrderType="麻醉")
        {
            s AnestInfo={}  //麻醉信息
            d AnestInfo.%Set("DataClass","AnestInfo")
            s AnestInfoC=[]  //详细内容
            s AnestInfoDict={}  //单个详细内容        
            d AnestInfoDict.%Set("AnestMedication","") //麻醉用药
            d AnestInfoDict.%Set("Dose","") //剂量
            d AnestInfoDict.%Set("Usage","") //用法
            d AnestInfoDict.%Set("Anesthesia","") //麻醉方式
            d AnestInfoDict.%Set("AnestSite","") //麻醉部位
            d AnestInfoDict.%Set("AnestDuration","") //麻醉持续时长
            d AnestInfoDict.%Set("AnestStartTime","") //麻醉开始时间
            d AnestInfoDict.%Set("ProjectName",OrderEntry.%Get("OrderContent")) //20211209
            d AnestInfoC.%Push(AnestInfoDict)
            d AnestInfo.%Set("children",AnestInfoC)
            d children.%Push(AnestInfo)
        }
        ///护理
        elseif (OrderType="护理")
        {
	        s NurContrastName=##class(web.CDSS.IMP.ContrastDict).GetDiectName(OrderEntry.%Get("OrderContent"),##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401"),"护理")
	        for Nuri=1:1:$l(NurContrastName,"&%")
	        {
		        s NursingName=$p(NurContrastName,"&%",Nuri)
	            s NursingInfo={}  //护理信息
	            d NursingInfo.%Set("DataClass","NursingInfo")
	            s NursingInfoC=[]  //详细内容
	            s NursingInfoDict={}  //单个详细内容
	            d NursingInfoDict.%Set("NursingItemNum","") //护理项目顺序号
	            d NursingInfoDict.%Set("NursingItemCode",OrderEntry.%Get("OrderCode")) //护理项目编码
	            d NursingInfoDict.%Set("NursingItemName",NursingName) //护理项目名称
	            d NursingInfoDict.%Set("ChildItemNum","") //护理小项顺序号
	            d NursingInfoDict.%Set("ChildItemCode","") //护理小项编码
	            d NursingInfoDict.%Set("ChildItemName","") //护理小项名称
	            d NursingInfoDict.%Set("NursingEffect","") //护理效果
	            d NursingInfoDict.%Set("ProjectName",OrderEntry.%Get("OrderContent")) //20211209
	            d NursingInfoDict.%Set("GroupFlag",OrderEntry.%Get("OrderID")) //医嘱单号
	            d NursingInfoC.%Push(NursingInfoDict)
	            d NursingInfo.%Set("children",NursingInfoC)
	            d children.%Push(NursingInfo)
	        }
        }
        ///护理
        elseif (OrderType="输血品")
        {
	        s BloodContrastName=##class(web.CDSS.IMP.ContrastDict).GetDiectName(OrderEntry.%Get("OrderContent"),##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401"),"输血品")
	        for Bloi=1:1:$l(BloodContrastName,"&%")
	        {
		        s BloodTransName=$p(BloodContrastName,"&%",Bloi)
	            s BloodInfo={}  //护理信息
	            d BloodInfo.%Set("DataClass","BloodTransInfo")
	            s BloodInfoC=[]  //详细内容
	            s BloodInfoDict={}  //单个详细内容
	            d BloodInfoDict.%Set("BloodTransClass",BloodContrastName)   //输血品名称
	            d BloodInfoC.%Push(BloodInfoDict)
	            d BloodInfo.%Set("children",BloodInfoC)
	            d children.%Push(BloodInfo)
	        }
        }
        ///饮食
        elseif (OrderType="饮食")
        {
            s DietInfo={}  //饮食信息
            d DietInfo.%Set("DataClass","DietInfo")
            s DietInfoC=[]  //详细内容
            s DietInfoDict={}  //单个详细内容
            d DietInfoDict.%Set("GroupFlag",OrderEntry.%Get("OrderID")) //医嘱单号
            d DietInfoDict.%Set("GroupSequence",OrderEntry.%Get("GroupSequence")) //组顺序
            d DietInfoDict.%Set("DietMethod","") //饮食方式
            d DietInfoDict.%Set("DietType","") //饮食类型
            d DietInfoDict.%Set("DietContent",OrderEntry.%Get("OrderContent")) //饮食内容
            d DietInfoDict.%Set("DietAmount","") //饮食量
            d DietInfoDict.%Set("DietInstructions","") //饮食说明
            d DietInfoDict.%Set("Duration","") //持续时长
            d DietInfoDict.%Set("StartTime","") //开始时间
            d DietInfoDict.%Set("EndTime","") //结束时间
            d DietInfoDict.%Set("ProjectName",OrderEntry.%Get("OrderContent")) //20211209
            d DietInfoC.%Push(DietInfoDict)
            d DietInfo.%Set("children",DietInfoC)
            d children.%Push(DietInfo)
        }
        ///出院带药
        elseif (OrderType="药品")&(OrderClass=4)
        {
	        s DrugContrastName=##class(web.CDSS.IMP.ContrastDict).GetDiectName(OrderEntry.%Get("OrderContent"),##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401"),"药品")
            for Drugi=1:1:$l(DrugContrastName,"&%")
            {
	            s DrugName=$p(DrugContrastName,"&%",Drugi)
	            s DrugInfo={}  //出院带药信息
	            d DrugInfo.%Set("DataClass","CarryDrug")
	            s DrugInfoC=[]  //详细内容
	            s DrugInfoDict={}  //单个详细内容
	            d DrugInfoDict.%Set("GroupFlag",OrderEntry.%Get("OrderID")) //医嘱单号
	            d DrugInfoDict.%Set("GroupSequence",OrderEntry.%Get("GroupSequence")) //组顺序
	            d DrugInfoDict.%Set("DrugCode",OrderEntry.%Get("OrderCode")) //药品编码
	            d DrugInfoDict.%Set("DrugName",DrugName) //药品名称
	            d DrugInfoDict.%Set("Usage",OrderEntry.%Get("Pathway")) //用法
	            d DrugInfoDict.%Set("Dose",OrderEntry.%Get("Dosage")) //剂量
	            d DrugInfoDict.%Set("Frequency",OrderEntry.%Get("Frequency")) //频率
	            d DrugInfoDict.%Set("Unit",OrderEntry.%Get("Unit")) //单位
	            d DrugInfoDict.%Set("Specification",OrderEntry.%Get("Specification")) //规格
	            d DrugInfoDict.%Set("StartTime","") //开始时间
	            d DrugInfoDict.%Set("StopTime","") //停止时间
	            d DrugInfoDict.%Set("Remarks","") //备注
	            d DrugInfoC.%Push(DrugInfoDict)
	            d DrugInfo.%Set("children",DrugInfoC)
	            d children.%Push(DrugInfo)
            }
        }
        elseif (OrderClass=4)  //其他出院医嘱信息
        {
            s OtherDisOrderInfo={}  //其他出院医嘱信息
            d OtherDisOrderInfo.%Set("DataClass","OtherDisOrderInfo")
            s OtherDisOrderInfoC=[]  //详细内容
            s OtherDisOrderInfoDict={}  //单个详细内容
            d OtherDisOrderInfoDict.%Set("GroupFlag",OrderEntry.%Get("OrderID")) //医嘱单号
            d OtherDisOrderInfoDict.%Set("GroupSequence",OrderEntry.%Get("GroupSequence")) //组顺序
            d OtherDisOrderInfoDict.%Set("OrderDesc","") //医嘱描述
            d OtherDisOrderInfoDict.%Set("ExecuteMethod","") //执行方式
            d OtherDisOrderInfoDict.%Set("PlanStartTime","") //计划开始时间
            d OtherDisOrderInfoDict.%Set("PlanStopTime","") //计划停止时间
            d OtherDisOrderInfoDict.%Set("ExecuteDesc","") //执行说明
            d OtherDisOrderInfoC.%Push(OtherDisOrderInfoDict)
            d OtherDisOrderInfo.%Set("children",OtherDisOrderInfoC)
            d children.%Push(OtherDisOrderInfo)
        }
        elseif (OrderClass=1)  //其他在院医嘱信息
        {
            s OtherOrderInfo={}  //其他在院医嘱信息
            d OtherOrderInfo.%Set("DataClass","OtherOrderInfo")
            s OtherOrderInfoC=[]  //详细内容
            s OtherOrderInfoDict={}  //单个详细内容
            d OtherOrderInfoDict.%Set("GroupFlag",OrderEntry.%Get("OrderID")) //医嘱单号
            d OtherOrderInfoDict.%Set("GroupSequence",OrderEntry.%Get("GroupSequence")) //组顺序
            d OtherOrderInfoDict.%Set("OrderDesc","") //医嘱描述
            d OtherOrderInfoDict.%Set("ExecuteTime","") //执行时间
            d OtherOrderInfoDict.%Set("ExecuteResult","") //执行结果
            d OtherOrderInfoC.%Push(OtherOrderInfoDict)
            d OtherOrderInfo.%Set("children",OtherOrderInfoC)
            d children.%Push(OtherOrderInfo)
        }
        d OrderJson.%Set("OperationFlag",OrderFlag)
        d OrderJson.%Set("children",children)
        s config=##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020061601")
        s RationalResult=##Class(web.CDSS.MachineLearning.DataVerification).DataRationalisation(OrderJson.%ToJSON())  //对第三方数据json串进行数据合理性校验，包括（数据类型是否匹配，主键是否存在等）
        s RationalResult=[].%FromJSON(RationalResult)
        s UnifomResult=##Class(web.CDSS.MachineLearning.DataVerification).DataConsistency(OrderJson.%ToJSON())  //对第三方数据json串进行基本信息、就诊信息数据一致性和临床信息完整性校验
        s UnifomResult=[].%FromJSON(UnifomResult)
    }   
    if (RationalResult.%Size()=0)&(UnifomResult.%Size()=0)  //如果没有错误信息
    {
        q OrderJson.%ToJSON()       
    }
    elseif(config="Y")  //有错误信息，但是允许强制交互
    {
        q OrderJson.%ToJSON()
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
/// CreatDate:2020-06-11
/// Description:检验报告更新
/// Table:
/// Input: JsonStr : 基础信息+各种报告json串 tableName：表名
/// Return:
/// Others:w ##class(web.CDSS.MachineLearning.InteractiveInterface).SaveRealTimeInfo(JsonStr,tableName)
ClassMethod SaveRealTimeInfo(JsonStr As %String, tableName As %String) As %String
{
    s info=[].%FromJSON(JsonStr)
    s DealedJson={}
    d DealedJson.%Set("IDNO",info.%Get("IDNO"))
    d DealedJson.%Set("PatientDR",info.%Get("PatientDR"))
    d DealedJson.%Set("VisitID",info.%Get("VisitID"))
    d DealedJson.%Set("VisitType",..ConvertVisitType(info.%Get("VisitType")))
    d DealedJson.%Set("UserID",info.%Get("UserID"))
    d DealedJson.%Set("UserName",info.%Get("UserName"))
    d DealedJson.%Set("CTLocID",info.%Get("DeptCode"))
    d DealedJson.%Set("CTLocDesc",info.%Get("DeptName"))
    //d DealedJson.%Set("Config",##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSSdyn20200416"))
    s children=[]  //所有信息表
    s dict={}  //每一类信息表
    d dict.%Set("DataClass",tableName)
    s childrenC=[]  //每一类信息所有数据
    d childrenC.%Push(info.%Get("字段名"))
    d dict.%Set("children",childrenC)
    d children.%Push(dict)
    d DealedJson.%Set("children",children)
    s config=##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020061601")
    s RationalResult=##Class(web.CDSS.MachineLearning.DataVerification).DataRationalisation(DealedJson.%ToJSON())  //对第三方数据json串进行数据合理性校验，包括（数据类型是否匹配，主键是否存在等）
    s RationalResult=[].%FromJSON(RationalResult)
    s UnifomResult=##Class(web.CDSS.MachineLearning.DataVerification).DataConsistency(DealedJson.%ToJSON())  //对第三方数据json串进行基本信息、就诊信息数据一致性和临床信息完整性校验
    s UnifomResult=[].%FromJSON(UnifomResult)
    if (RationalResult.%Size()=0)&(UnifomResult.%Size()=0)  //如果没有错误信息
    {
        q DealedJson.%ToJSON()      
    }
    elseif(config="Y")  //有错误信息，但是允许强制交互
    {
        q DealedJson.%ToJSON()
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
/// CreatDate:2020-06-15
/// Description:第三方调用数据接口
/// Table:
/// Input: action:命令 json：json信息串
/// Return:
/// Others:w ##class(web.CDSS.MachineLearning.InteractiveInterface).DHCHisInterface("CATCH_DIAG_WARNING",json)
/// Others:w ##class(web.CDSS.MachineLearning.InteractiveInterface).DHCHisInterface("ALLERGY_INFORMATION",^TMP("LDYY"))
ClassMethod DHCHisInterface(action As %String, json As %String) As %String
{
	s json=$REPLACE(json,":""}",":""""}")
	s json=$REPLACE(json,":"",",":"""",")
	s info=[].%FromJSON(json)
	s UserName = info.%Get("UserName")
	s UserLoc = info.%Get("DeptName")
	s Config=##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSSdyn20200416")
    s PatientUserInfo=info.%Get("IDNO")_"^"_info.%Get("PatientDR")_"^"_info.%Get("VisitID")_"^"_..ConvertVisitType(info.%Get("VisitType"))_"^"_info.%Get("UserID")_"^"_info.%Get("UserName")_"^"_info.%Get("DeptCode")_"^"_info.%Get("DeptName")_"^"_Config  //调用后台接口的参数
    s result=""
    if (action="INITIALIZE_PATIENT_INFORMATION")  //初始化患者信息
    {
        s result=..GetBasicInfo(json)
        try
	    {
	    	d ##class(web.CDSS.IdentifyWords.GetPatientIW).GetSatisfyIW(PatientUserInfo)
	    }
	    catch e
	    {
		}
        q PatientUserInfo
    }
    elseif (action="ONLY_DIAGNOSTIC_INFORMATION")
	{
		job ..OnlySyncDiag(json)			//单开进程入库
		q PatientUserInfo
	}
    elseif(action="SYNCHRONOUS_DIAGNOSTIC_INFORMATION")  //同步诊断信息
    {
        s tmpResult=..SynchronousDiagInfo(json)
        if (tmpResult="DeleteDiagnosisInfo")
        {
	        try
		    {
		    	d ##class(web.CDSS.IdentifyWords.GetPatientIW).GetSatisfyIW(PatientUserInfo)
		    }
		    catch e
		    {
			}
	        q PatientUserInfo
            s result=tmpResult
        }
        else
        {
            s result=[]
            s tmpResult=[].%FromJSON(tmpResult)
            d result.%Push(tmpResult)
            s result=result.%ToJSON()
        }
    }
    elseif(action="SAVE_MEDICAL_RECORD_INFORMATION")  //保存病例信息
    {
        s result=..SaveProgress(json)
    }
    elseif(action="DELETE_MEDICAL_RECORD_INFORMATION")  //删除病例信息
    {     
    }
    elseif(action="SYNCHRONIZE_PATIENT_ORDERS")  //同步患者医嘱信息
    {
        s tmpResult=..SynchronizeOrder(json)
        s result=[]
        s tmpResult=[].%FromJSON(tmpResult)
        d result.%Push(tmpResult)
        s result=result.%ToJSON()
    }
    elseif (action="DHCDSSLabInfo")  //检验报告实时更新
    {
        s result=..SaveRealTimeInfo(action,json)
    }
    elseif (action="DHCDSSExamInfo")  //检查报告实时更新
    {
        s result=..SaveRealTimeInfo(action,json)
    }
    elseif (action="DHCDSSOperationInfo")  //术后报告实时更新
    {
        s result=..SaveRealTimeInfo(action,json)
    }
    elseif (action="DHCDSSPatientMaster")  //基础信息实时更新
    {
        s result=..SaveRealTimeInfo(action,json)
    }
    elseif (action="DHCDSSSignInfo")  //患者体征实时更新
    {
        s result=..SaveRealTimeInfo(action,json)
    }
    elseif (action="SAVE_Exam_INFORMATION")  //演示系统检查报告更新
    {
        s result=##class(web.CDSS.MachineLearning.Inteplatform).SaveExamJsonInfo(json)
    }
    elseif (action="SAVE_Lab_INFORMATION")  //演示系统检验报告更新
    {
        s result=##class(web.CDSS.MachineLearning.Inteplatform).SaveLabJsonInfo(json)
    }
    elseif (action="CATCH_DIAG_WARNING")	//捕捉预警
    {
	    try
	    {
	    	s result=..SynchronousDiagInfoV2(json) 
	    }
	    catch e
	    {
		    s OrderWarnList={}
			s StopWarn=[]
			s PopWarn=[]
			d OrderWarnList.%Set("BlockWarn",StopWarn)
		    d OrderWarnList.%Set("PopWarn",PopWarn)
		    s result = OrderWarnList.%ToJSON()
	    }
	    //q OrderWarnList.%ToJSON()
		//s result=..NewSynchronousDiagInfo(json)  
		q result
	}
	elseif (action="CATCH_ORDER_WARNING")	//输血接口
    {
	    try
	    {
	    	s result=..SynchronizeOrderV2(json)  
	    }
	    catch e
	    {
		    s OrderWarnList={}
			s StopWarn=[]
			s PopWarn=[]
			d OrderWarnList.%Set("BlockWarn",StopWarn)
		    d OrderWarnList.%Set("PopWarn",PopWarn)
		    s result = OrderWarnList.%ToJSON()
	    }
	    //q OrderWarnList.%ToJSON()
		//s result=..NewSynchronizeOrder(json)  
		q result
	}
	elseif (action="ALLERGY_INFORMATION")
	{
		s PatientUserInfo=info.%Get("IDNO")_"^"_info.%Get("PatientDR")_"^"_1_"^住院^^^^^"_Config  //调用后台接口的参数
		s result=##class(web.CDSS.MachineLearning.AllergyInterface).SynchronousAllergyInfo(json)
		if result="DeleteAllergyInfo"	
		{
			try
			{
				d ##class(web.CDSS.IdentifyWords.GetPatientIW).GetSatisfyIW(PatientUserInfo)
			}
			catch e
			{}
			q PatientUserInfo	
		}
	}
	elseif (action="SYNCHRONOUS_SIGN_INFORMATION")
	{
		s result=##class(web.CDSS.MachineLearning.Inteplatform).SaveSignJsonInfo(json)	
	}
	elseif (action="MARRY_INFORMATION")		//月经史接口
	{
		d ..SynchronousMarryInfo(json)
		q PatientUserInfo	
	}
    if result=""
    {
	    q ""
    }
    elseif result="DeleteDiagnosisInfo"
    {
	    q PatientUserInfo
    }
    else
    {
	    try
	    {
	    	d ##class(web.CDSS.MachineLearning.ParseMode).ParsePatientModel(result)
	    }
	    catch e
	    {
		    w ##class(web.CDSS.MachineLearning.ParseMode).ParsePatientModel(result)
	    }
    }
    try
    {
    	d ##class(web.CDSS.IdentifyWords.GetPatientIW).GetSatisfyIW(PatientUserInfo)
    }
    catch e
    {
	}
    /*s ClassName="web.CDSS.MachineLearning.InteractiveInterface.cls"
    s MethodName="DHCHisInterface"
    s ExecutionTime=($p($h,",",2)-ExecutionTimeSt)
    d ##class(web.CDSS.Public.MethodExecutionTime).SaveExecutionTime(ClassName,MethodName,ExecutionTime,action,UserName,UserLoc)*/
    q PatientUserInfo
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

/// Creator:陈代雷
/// CreatDate:2020-08-13
/// Description:性别数字转换成文字描述
/// Table:
/// Input: SexCode:性别代码
/// Return:
/// Others:w ##class(web.CDSS.MachineLearning.InteractiveInterface).CDRConvertSex(1)
ClassMethod CDRConvertSex(SexCode As %String) As %String
{
    s sex=$CASE(SexCode,2:"女",1:"男",0:"其他",9:"其他",:"其他")
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

/// Creator:陈代雷
/// CreatDate:2020-07-21
/// Description:第三方调用数据接口(后台调用)
/// Table:
/// Input: json：json信息串
/// Return:
/// Others:w ##class(web.CDSS.MachineLearning.InteractiveInterface).DHCHisServerInterface(json)
ClassMethod DHCHisServerInterface(json As %String) As %String
{
	/*s ^TMPCDSSCDL(1)=$g(^TMPCDSSCDL(1))_"AAAAAAAAAA"_json
	if ($d(^TMPCDSSCDL(2))=0)
	{
		s ^TMPCDSSCDL(2)=1
	}
	else
	{
		s ^TMPCDSSCDL(2)=^TMPCDSSCDL(2)+1	
	}*/
    s count=0  //记录成功个数  
    s result={}  //返回结果
    s ResultData={}   //返回数据
    d ResultData.%Set("ResultCode","-1")
    d ResultData.%Set("ResultContent","数据为空！")
    d result.%Set("data",ResultData)
    s NullResult=result.%ToJSON()
    q:json="" NullResult  //如果没有数据，返回空
    /*try
    {
	    if (json["content=")
	    {
		    s content=$replace(json,"content=","")
		    
	    }
	    else
	    {
        	s json=[].%FromJSON(json)
        	// FWK0716
        	//s content = json
        	s content=json.%Get("content")
	    }
    }
    catch e
    {
	    d ResultData.%Set("ResultContent","数据格式或编码有误！")
    	d result.%Set("data",ResultData)
    	s CodeResult=result.%ToJSON()
        return CodeResult
        
    }
    q:content="" NullResult  //如果没有内容，返回空*/
    s content=[].%FromJSON(json)
    s theme=content.%Get("theme")  //主题，用于区分所传是什么信息
    d ResultData.%Set("ResultContent","theme为空！")
    d result.%Set("data",ResultData)
    s ThemeResult=result.%ToJSON()
    q:theme="" ThemeResult   //主题为空时，返回错误信息
    s data=content.%Get("data")  //获取主要信息数据
    s SaveDict={}  //存储要保存的信息
    if (theme="THM00159")||(theme="THM00160")   //患者基本信息
    {
        for i=0:1:(data.%Size()-1)
        {
            s SingleData=data.%Get(i)
            s count=count+1
            s DiagJson={}
            d DiagJson.%Set("IDNO",SingleData.%Get("patpatientid"))
            d DiagJson.%Set("PatientDR",SingleData.%Get("patpatientid"))
            d DiagJson.%Set("VisitID",SingleData.%Get("patpatientid"))
            d DiagJson.%Set("VisitType","")
            d DiagJson.%Set("UserID","")
            d DiagJson.%Set("UserName","")
            d DiagJson.%Set("CTLocID","")
            d DiagJson.%Set("CTLocDesc","")
            //d DiagJson.%Set("Config",##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSSdyn20200416"))
            s children=[]  //所有信息表
            ///基础信息表
            s PatientMaster={}  //基础信息字典
            d PatientMaster.%Set("DataClass","PatientMaster")
            s PatientMasterC=[]  ////基础信息详细内容
            s PatientMasterDict={}  //单个基础信息详细内容
            d PatientMasterDict.%Set("MedicareCardNum",SingleData.%Get("patpatientid")) //病人标识 //医保卡号
            d PatientMasterDict.%Set("IDCardNumber",SingleData.%Get("patpatientid")) //病人标识, //身份证号
            d PatientMasterDict.%Set("Name",SingleData.%Get("papatdename"))   //姓名
            d PatientMasterDict.%Set("Sex",..CDRConvertSex(SingleData.%Get("papatdesexcode")))  //性别（性别病史）
            if (##class(%Library.TimeStamp).IsValid(info.%Get("PatientInfo").%Get("BirthDate")))
		    {
		    	s Age=##class(web.CDSS.MachineLearning.InteractiveInterface).CurrentAge($zdh(info.%Get("PatientInfo").%Get("BirthDate"),3))
		    }
		    else
		    {
			    s Age=""
		    }
            //s Age=($h-$zdh(info.%Get("PatientInfo").%Get("BirthDate"),3))/365
            d PatientMasterDict.%Set("Age",Age) //年龄
            d PatientMasterDict.%Set("Profession","") //职业（职业病史）
            d PatientMasterDict.%Set("Nation","") //民族
            d PatientMasterDict.%Set("Marriage","") //婚姻
            d PatientMasterDict.%Set("BloodGroup","") //血型
            d PatientMasterDict.%Set("Country","") //国籍
            d PatientMasterDict.%Set("Birthplace","") //籍贯
            d PatientMasterDict.%Set("CurrentAddress","") //现住址
            d PatientMasterDict.%Set("PhoneNumber","") //电话
            d PatientMasterDict.%Set("Birthday",SingleData.%Get("papatdedob"))  //出生日期
            d PatientMasterC.%Push(PatientMasterDict)
            d PatientMaster.%Set("children",PatientMasterC)
            d children.%Push(PatientMaster)
            d DiagJson.%Set("children",children)
            try
            {
                d ##Class("web.CDSS.MachineLearning.ParseMode").ParsePatientModel(DiagJson.%ToJSON())
            }
            catch e
            {
                s number=$o(^TMPCDSSCDR(""),-1)+1
                s ^TMPCDSSCDR(number)=DiagJson.%ToJSON()_"&&"_e.Name
                
            }
            //w DiagJson.%ToJSON(),!
        }
        
    }
    elseif (theme="THM00164")||(theme="THM00163")  //就诊信息
    {
        for i=0:1:(data.%Size()-1)
        {
            s count=count+1
        }
    }
    elseif (theme="THM00161")||(theme="THM00162")  //医嘱信息
    {
        for i=0:1:(data.%Size()-1)
        {
            s SingleData=data.%Get(i)
            s count=count+1
            s oeoriarcitmmastcode=SingleData.%Get("oeoriarcitmmastcode")  //医嘱项目代码
            s Hospital=##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401")
            s OrderType=##class(web.CDSS.IMP.InterfaceDict).GetDictType(Hospital,oeoriarcitmmastcode)  //医嘱类型，检查，检验等等
            if (OrderType="检查")
            {
                s OrderJson={}
                d OrderJson.%Set("IDNO",SingleData.%Get("hosvisitnumber"))
                d OrderJson.%Set("PatientDR",SingleData.%Get("patpatientid"))
                d OrderJson.%Set("VisitID",SingleData.%Get("patpatientid"))
                d OrderJson.%Set("VisitType",SingleData.%Get("hosadmtype"))
                d OrderJson.%Set("UserID","")
                d OrderJson.%Set("UserName","")
                d OrderJson.%Set("CTLocID","")
                d OrderJson.%Set("CTLocDesc","")
                s children=[]  //所有信息表
                s ExamInfo={}  //检查信息
                d ExamInfo.%Set("DataClass","ExamInfo")
                s ExamInfoC=[]  //详细内容
                s ExamInfoDict={}  //单个详细内容
                d ExamInfoDict.%Set("GroupFlag",SingleData.%Get("oeorihosorderid")) //医嘱单号
                d ExamInfoDict.%Set("GroupSequence","") //组顺序
                d ExamInfoDict.%Set("ExamCode",oeoriarcitmmastcode) //检查编码
                d ExamInfoDict.%Set("ExamName",##class(web.CDSS.IMP.InterfaceDict).GetDiectNameByCode(oeoriarcitmmastcode,##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401"),"检查项目字典")) //检查名称
                d ExamInfoDict.%Set("ExamResultNum","") //检查结果顺序号
                d ExamInfoDict.%Set("ExamResult","") //检查结果
                d ExamInfoDict.%Set("ExamResultFlag","") //检查结果指标（阴性或阳性）
                d ExamInfoDict.%Set("ExamResultDesc","") //检查结果概述
                d ExamInfoDict.%Set("PartDR","") //部位（改成指针）
                d ExamInfoDict.%Set("ExecuteTime","") //执行时间
                d ExamInfoDict.%Set("ReportTime","") //报告时间
                d ExamInfoDict.%Set("Remarks","") //备注
                d ExamInfoC.%Push(ExamInfoDict)
                d ExamInfo.%Set("children",ExamInfoC)
                d children.%Push(ExamInfo)
                d OrderJson.%Set("children",children)
                try
                {
                    d ##Class("web.CDSS.MachineLearning.ParseMode").ParsePatientModel(OrderJson.%ToJSON())
                }
                catch e
                {
                    s number=$o(^TMPCDSSCDR(""),-1)+1
                    s ^TMPCDSSCDR(number)=OrderJson.%ToJSON()_"&&"_e.Name
                    
                }
                //w OrderJson.%ToJSON(),!
            }
            if (OrderType="检验")
            {
                s OrderJson={}
                d OrderJson.%Set("IDNO",SingleData.%Get("hosvisitnumber"))
                d OrderJson.%Set("PatientDR",SingleData.%Get("patpatientid"))
                d OrderJson.%Set("VisitID",SingleData.%Get("patpatientid"))
                d OrderJson.%Set("VisitType",SingleData.%Get("hosadmtype"))
                d OrderJson.%Set("UserID","")
                d OrderJson.%Set("UserName","")
                d OrderJson.%Set("CTLocID","")
                d OrderJson.%Set("CTLocDesc","")
                s children=[]  //所有信息表
                s LabInfo={}  //检查信息
                d LabInfo.%Set("DataClass","LabInfo")
                s LabInfoC=[]  //详细内容
                s LabInfoDict={}  //单个详细内容
                d LabInfoDict.%Set("GroupFlag",SingleData.%Get("oeorihosorderid")) //医嘱单号
                //d LabInfoDict.%Set("GroupSequence",OrderEntry.%Get("GroupSequence")) //组顺序
                d LabInfoDict.%Set("InspectionCode",oeoriarcitmmastcode) //检验大项编码
                d LabInfoDict.%Set("InspectionName",##class(web.CDSS.IMP.InterfaceDict).GetDiectNameByCode(oeoriarcitmmastcode,##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401"),"检验项目字典")) //检验大项名称
                d LabInfoDict.%Set("LabItemCode","") //检验小项编码
                d LabInfoDict.%Set("LabItemName","") //检验小项名称
                d LabInfoDict.%Set("LabResult","") //检验结果
                d LabInfoDict.%Set("LabResultFlag","") //检验结果指标（阴性或阳性）
                d LabInfoDict.%Set("Unit","") //单位
                d LabInfoDict.%Set("Reference","") //参考值
                d LabInfoDict.%Set("Specimen","")  //标本
                d LabInfoDict.%Set("ExecuteTime","") //执行时间
                d LabInfoDict.%Set("ReportTime","") //报告时间
                d LabInfoDict.%Set("Remarks","") //备注
                d LabInfoC.%Push(LabInfoDict)
                d LabInfo.%Set("children",LabInfoC)
                d children.%Push(LabInfo)
                d OrderJson.%Set("children",children)
                try
                {
                    d ##Class("web.CDSS.MachineLearning.ParseMode").ParsePatientModel(OrderJson.%ToJSON())
                }
                catch e
                {
                    s number=$o(^TMPCDSSCDR(""),-1)+1
                    s ^TMPCDSSCDR(number)=OrderJson.%ToJSON()_"&&"_e.Name
                    
                }
                //w OrderJson.%ToJSON(),!
            }
            
        }
    }
    elseif (theme="THM00167")     //条码与医嘱关联信息
    {
	    s counter=0
	    if ($d(^TMPCDSSServer("THM00167"))=0)
	    {
			 s counter=1
	    }
	    elseif($d(^TMPCDSSServer("THM00167"))=10)
	    {
			s counter=$o(^TMPCDSSServer("THM00167",""),-1)   
	    }
	    s ^TMPCDSSServer("THM00167",counter+1)=data.%ToJSON()
        for i=0:1:(data.%Size()-1)
        {
            s count=count+1
            s SaveDict={}
            s Specimen=data.%Get(i).%Get("sample_class_name")  //样本信息
            s SpecimenId=$o(^CT.WDT.CDSS.LabSpecimenDictI("NameIndex"," "_$ZCONVERT(Specimen,"U"),0))  //获取检验标本在字典表中的RowID
            if (SpecimenId="")  //如果检验标本名称不存在于字典表中，将该检验标本存入字典中
            {
                s SpecimenId=..SaveLabSpecimenDict(Specimen,Specimen,"","","","","华西二院","")
            }
            s GroupFlag=data.%Get(i).%Get("his_id")  //获取医嘱号
            if (GroupFlag="")
            {
                d ResultData.%Set("ResultContent","医嘱号为空！")
                d result.%Set("data",ResultData)
                return result.%ToJSON()
            }
            d SaveDict.%Set("GroupFlag",GroupFlag)
            d SaveDict.%Set("Specimen",SpecimenId)
            s SaveDict=SaveDict.%ToJSON()
            //w SaveDict,!
            d ##class(web.CDSS.MachineLearning.ParseMode).UpdateLabInfo("update",SaveDict)
        }
    }
    elseif (theme="THM00168")     //检验报告信息
    {
	    if ($d(^TMPCDSSCDL(3))=0)
		{
			s ^TMPCDSSCDL(3)=1
		}
		else
		{
			s ^TMPCDSSCDL(3)=^TMPCDSSCDL(3)+1	
		}
	    s counter=0
	    if ($d(^TMPCDSSServer("THM00168"))=0)
	    {
			 s counter=0
	    }
	    elseif($d(^TMPCDSSServer("THM00168"))=10)
	    {
			s counter=$o(^TMPCDSSServer("THM00168",""),-1)   
	    }
	    s ^TMPCDSSServer("THM00168",counter+1)=data.%ToJSON()
        for i=0:1:(data.%Size()-1)
        {
            s count=count+1
            s SaveDict={}
            s GroupFlag=data.%Get(i).%Get("his_id")  //获取医嘱号
            if (GroupFlag="")
            {
                d ResultData.%Set("ResultContent","医嘱号为空！")
                d result.%Set("data",ResultData)
                return result.%ToJSON()
            }
            s GroupSequence=data.%Get(i).%Get("lisrr_hosreportid")  //获取报告单号
            if (GroupSequence="")
            {
                d ResultData.%Set("ResultContent","报告单号为空！")
                d result.%Set("data",ResultData)
                return result.%ToJSON()
            }
            s ExecuteTime=data.%Get(i).%Get("lisrr_testdate")  //执行时间
            s ReportTime=data.%Get(i).%Get("lisrr_checkdate")    //报告时间
            s Remarks=data.%Get(i).%Get("lisrr_remarks")    //备注
            d SaveDict.%Set("GroupFlag",GroupFlag)
            d SaveDict.%Set("GroupSequence",GroupSequence)
            d SaveDict.%Set("ExecuteTime",ExecuteTime)
            d SaveDict.%Set("ReportTime",ReportTime)
            d SaveDict.%Set("Remarks",Remarks)
            s SaveDict=SaveDict.%ToJSON()
            //w SaveDict,!
            d ##class(web.CDSS.MachineLearning.ParseMode).UpdateLabInfo("update",SaveDict)
        }
    }
    elseif (theme="THM00169")     //检验报告明细信息
    {
	    s counter=0
	    if ($d(^TMPCDSSServer("THM00169"))=0)
	    {
			 s counter=1
	    }
	    elseif($d(^TMPCDSSServer("THM00169"))=10)
	    {
			s counter=$o(^TMPCDSSServer("THM00169",""),-1)   
	    }
	    s ^TMPCDSSServer("THM00169",counter+1)=data.%ToJSON()
        for i=0:1:(data.%Size()-1)
        {
            s count=count+1
            s SaveDict={}
            s GroupSequence=data.%Get(i).%Get("hoslisreportid")  //获取报告单号
            if (GroupSequence="")
            {
                d ResultData.%Set("ResultContent","报告单号为空！")
                d result.%Set("data",ResultData)
                return result.%ToJSON()
            }
            s LabItemCode=data.%Get(i).%Get("lisir_itemcode")  //检验小项编码
            s LabItemName = ##class(web.CDSS.IMP.ContrastDict).GetDiectName(data.%Get(i).%Get("lisir_itemdesc"),"2","检验项目字典")
            //s LabItemName=##class(web.CDSS.IMP.InterfaceDict).GetDiectNameByCode(data.%Get(i).%Get("lisir_itemdesc"),##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401"),"检验项目字典")    //检验小项名称
            s LabResult=data.%Get(i).%Get("lisir_result")    //检验结果
            s Unit=data.%Get(i).%Get("lisir_uint")    //单位
            s Reference=data.%Get(i).%Get("lisir_ranges")    //参考值          
            s LabResultFlag=..GetLabResultFlag(LabResult,LabItemName)  //检验结果指标
            s GroupFlag=##class(web.CDSS.MachineLearning.InteractiveInterface).GetGroupFlagBySeq(GroupSequence)  //通过报告单号获取医嘱号
            d SaveDict.%Set("GroupFlag",GroupFlag)
            d SaveDict.%Set("LabItemCode",LabItemCode)
            d SaveDict.%Set("LabItemName",LabItemName)
            d SaveDict.%Set("LabResult",LabResult)
            d SaveDict.%Set("Unit",Unit)
            d SaveDict.%Set("Reference",Reference)
            d SaveDict.%Set("LabResultFlag",LabResultFlag)
            s SaveDict=SaveDict.%ToJSON()
            //w SaveDict,!
            d ##class(web.CDSS.MachineLearning.ParseMode).UpdateLabInfo("add",SaveDict)
        }
    }
    elseif (theme="THM00158")     //检查报告信息
    {
	    s counter=0
	    if ($d(^TMPCDSSServer("THM00158"))=0)
	    {
			 s counter=1
	    }
	    elseif($d(^TMPCDSSServer("THM00158"))=10)
	    {
			s counter=$o(^TMPCDSSServer("THM00158",""),-1)   
	    }
	    s ^TMPCDSSServer("THM00158",counter+1)=data.%ToJSON()
        for i=0:1:(data.%Size()-1)
        {
            s count=count+1
            s SaveDict={}
            s GroupFlag=data.%Get(i).%Get("hosrisorderitemid")  //获取医嘱号
            if (GroupFlag="")
            {
                d ResultData.%Set("ResultContent","医嘱号为空！")
                d result.%Set("data",ResultData)
                return result.%ToJSON()
            }
            s ExamResultDesc=data.%Get(i).%Get("risrexamdesc")  //检查结果概述
            s ExecuteTime=data.%Get(i).%Get("risrchecktime")    //执行时间
            s ReportTime=data.%Get(i).%Get("risrreportdate")    //报告时间
            s Remarks=data.%Get(i).%Get("risrdiagdesc")    //备注，用于存储诊断意见
            d SaveDict.%Set("GroupFlag",GroupFlag)
            d SaveDict.%Set("ExamResultDesc",ExamResultDesc)
            d SaveDict.%Set("ExecuteTime",ExecuteTime)
            d SaveDict.%Set("ReportTime",ReportTime)
            d SaveDict.%Set("Remarks",Remarks)
            s SaveDict=SaveDict.%ToJSON()
            //w SaveDict,!
            d ##class(web.CDSS.MachineLearning.ParseMode).UpdateExamInfo(SaveDict)
        }
    }
    elseif (theme="THM00165")||((theme="THM00166"))     //生命体征信息
    {
	    s counter=0
	    if ($d(^TMPCDSSServer("THM00165"))=0)
	    {
			 s counter=1
	    }
	    elseif($d(^TMPCDSSServer("THM00165"))=10)
	    {
			s counter=$o(^TMPCDSSServer("THM00165",""),-1)   
	    }
	    s ^TMPCDSSServer("THM00165",counter+1)=data.%ToJSON()
        for i=0:1:(data.%Size()-1)
        {
            s count=count+1
            s SaveDict={}
            s IDNO=data.%Get(i).%Get("hosvisitnumber")  //获取就诊号
            if (IDNO="")
            {
                d ResultData.%Set("ResultContent","就诊号为空！")
                d result.%Set("data",ResultData)
                return result.%ToJSON()
            }
            s SignCode=data.%Get(i).%Get("obsitemcode")  //体征信息代码
            s SignName=##class(web.CDSS.IMP.InterfaceDict).GetDiectNameByCode(SignCode,##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401"),"")  //通过体征信息代码获取体征信息名称
            s MeasureDate=data.%Get(i).%Get("obsdate")    //测量时间
            s MeasureResult=data.%Get(i).%Get("obsitemvalue")    //测量结果
            d SaveDict.%Set("IDNO",IDNO)
            d SaveDict.%Set("MeasureDate",MeasureDate)
            
            if (SignName="体温")
            {
                d SaveDict.%Set("BodyTemperature",MeasureResult)
            }
            if (SignName="舒张压")
            {
                d SaveDict.%Set("DiastolicBlood",MeasureResult)
            }
            if (SignName="收缩压")
            {
                d SaveDict.%Set("SystolicBlood",MeasureResult)
            }
            if (SignName="脉搏")
            {
                d SaveDict.%Set("Pulse",MeasureResult)
            }
            if (SignName="呼吸")
            {
                d SaveDict.%Set("BreathFeature",MeasureResult)
            }
            if (SignName="心率")
            {
                d SaveDict.%Set("HeartRate",MeasureResult)
            }
            if (SignName="血氧饱和度")
            {
                d SaveDict.%Set("OxygenSaturation",MeasureResult)
            }
            if (SignName="体重(kg)")
            {
                d SaveDict.%Set("Weight",MeasureResult)
            }
            s SaveDict=SaveDict.%ToJSON()
            //w SaveDict,!
            d ##class(web.CDSS.MachineLearning.ParseMode).UpdateSignInfo(SaveDict)
        }
    }
    d ResultData.%Set("ResultCode","0")
    d ResultData.%Set("ResultContent",""_count_"")
    d result.%Set("data",ResultData)
    q result.%ToJSON()
}

/*ClassMethod GetLabIDByOrder(OrderNum As %String) As %String
{
    s rowid=$o(^WDT.CDSS.LabInfoI("GroupFlagIndex"," "_$ZCONVERT(OrderNum,"U"),0))
    q rowid
}*/
/// Creator:陈代雷
/// CreatDate:2020-07-22
/// Description:通过医嘱号获取检验信息表RowID
/// Table: WDT.CDSS.LabInfo :检验信息表
/// Input: OrderNum :医嘱单号
/// Return:
/// Others:w ##class(web.CDSS.MachineLearning.InteractiveInterface).DHCHisServerInterface(json)
/// Creator:陈代雷
/// CreatDate:2020-07-22
/// Description:通过检验结果推出检验结果指标（阴性，阳性），如果结果为定性，直接赋值，如果为定量，则需要去判断
/// Table: WDT.CDSS.LabInfo :检验信息表 CT.WDT.CDSS.InspectionDetail :检验明细字典表 CT.WDT.CDSS.LabInspectionDict :检验字典表
/// Input: LabResult :检验结果, LabItemName :检验小项名称
/// Return:检验结果指标
/// Others:w ##class(web.CDSS.MachineLearning.InteractiveInterface).GetLabResultFlag(LabResult)
ClassMethod GetLabResultFlag(LabResult As %String, LabItemName As %String) As %String
{
    s LabResultFlag=""
    if (LabResult="阴性")||(LabResult="阳性")  //如果结果为定性，直接赋值
    {
        s LabResultFlag=LabResult
    }
    else  //如果为定量，则需要去判断 
    {
        s LabRowId=$o(^CT.WDT.CDSS.LabInspectionDictI("NameIndex"," "_$ZCONVERT(LabItemName,"U"),0))
        q:LabRowId="" ""
        s LabDetailRowId=$o(^CT.WDT.CDSS.LabInspectionDictI("LabDRIndex",LabRowId,0))
        q:LabDetailRowId="" ""
        s LabResultMin=$lg($g(^CT.WDT.CDSS.LabInspectionDictI(LabDetailRowId)),7)  //参考最小值
        s LabResultMax=$lg($g(^CT.WDT.CDSS.LabInspectionDictI(LabDetailRowId)),7)  //参考最大值
        if (LabResultMin'="")&(LabResultMax'="")  //最大值最小值均不为空
        {
            if (LabResult>=LabResultMin)&(LabResult<=LabResultMax)
            {
                s LabResultFlag="阴性"
            }
            else
            {
                s LabResultFlag="阳性"
            }
        }
        elseif(LabResultMin="")  //最小值为空
        {
            if (LabResult<=LabResultMax)
            {
                s LabResultFlag="阴性"
            }
            else
            {
                s LabResultFlag="阳性"
            }
        }
        elseif(LabResultMax="")  //最大值为空
        {
            if (LabResult>=LabResultMin)
            {
                s LabResultFlag="阴性"
            }
            else
            {
                s LabResultFlag="阳性"
            }
        }

    }
    q LabResultFlag
}

/// Creator:陈代雷
/// CreatDate:2020-07-23
/// Description:通过报告单号获取医嘱单号（只适用于检验）
/// Table: WDT.CDSS.LabInfo :检验信息表 CT.WDT.CDSS.InspectionDetail :检验明细字典表 CT.WDT.CDSS.LabInspectionDict :检验字典表
/// Input: GroupSequence :报告单号
/// Return:医嘱号
/// Others:w ##class(web.CDSS.MachineLearning.InteractiveInterface).GetGroupFlagBySeq(LabResult)
ClassMethod GetGroupFlagBySeq(GroupSequence As %String) As %String
{
    s GroupFlag=""
    ///倒叙遍历检验信息表，节省遍历时间
    s RowId=""
    for
    {
        s RowId=$o(^WDT.CDSS.LabInfoD(RowId),-1)  //倒叙遍历
        q:RowId=""
        s GroupSeq=$lg($g(^WDT.CDSS.LabInfoD(RowId)),7)  //表中存的报告单号
        if (GroupSeq[GroupSequence)
        {
            s GroupFlag=$lg($g(^WDT.CDSS.LabInfoD(RowId)),6)  //医嘱号
            q
        }
    }
    q GroupFlag
}

/// Creator:chendailei
/// CreatDate:2020-08-5
/// Description：测试平台提供的标准服务接口
/// Input：URL
/// Output: 获取到的数据
/// w ##class(web.CDSS.MachineLearning.InteractiveInterface).TestPlatformInterface("")
ClassMethod TestPlatformInterface(url As %String) As %String
{
    set httpRequest = ##class(%Net.HttpRequest).%New()
    s params={"data":{"hdcPatRegNo":"0009221406","hosPatRegNo":"","hdcEncId":"","hosEncId":"","encHosCode":"","diagnoseInfo":{"diagnoseName":"","diagnoseDate":""}}}
    //s params={"data":{"encHosCode":"00001"}}
    s params=params.%ToJSON()
    s Url="http://192.178.61.87:9090/emviewdoctor/hdc/SerachQuery/MES0032"
    Do httpRequest.SetHeader("Content-Type","application/x-www-form-urlencoded; charset=utf8")
    do httpRequest.InsertFormData("params", params)
    set status = httpRequest.Post(Url)
    w "status："_status,!
    If $$$ISERR(status) { Quit $system.OBJ.DisplayError(status) }
    Set responseString = httpRequest.HttpResponse.Data.Read()
    Quit responseString
}

/// Creator:chendailei
/// CreatDate:2020-08-05
/// Description：保存检验标本字典表数据
/// Table: CT.WDT.CDSS.LabSpecimenDict :检验标本字典表
/// Input: SpecimenCode:标本编码 SpecimenName:标本名称 SpecimenDesc:标本描述 SpecimenNorm:标本采集标准 UseFlag:使用标志（0在用，1停用） CreateDate:创建时间 CreateUserID:创建人员 Remarks:备注
/// Output: 获取到的数据
/// w ##class(web.CDSS.MachineLearning.InteractiveInterface).SaveLabSpecimenDict("全血","全血","","","","","","")
ClassMethod SaveLabSpecimenDict(SpecimenCode As %String, SpecimenName As %String, SpecimenDesc As %String, SpecimenNorm As %String, UseFlag As %String, CreateDate As %String, CreateUserID As %String, Remarks As %String) As %String
{
    s id=""
    s obj=##class(CT.WDT.CDSS.LabSpecimenDict).%New()
    s obj.SpecimenCode=SpecimenCode
    s obj.SpecimenName=SpecimenName
    s obj.SpecimenDesc=SpecimenDesc
    s obj.SpecimenNorm=SpecimenNorm
    s obj.UseFlag=UseFlag
    s obj.CreateDate=CreateDate
    s obj.CreateUserID=CreateUserID
    s obj.Remarks=Remarks
    s sc=obj.%Save()
    d obj.%Close()
    if $$$ISOK(sc)
    {
        s id = obj.%Id()
    }
    q id
}

/// Creator:chendailei
/// CreatDate:2020-08-17
/// Description：医院信息平台诊断抽取
/// Input: hosEncId :就诊号
/// Output: 获取到的数据
/// w ##class(web.CDSS.MachineLearning.InteractiveInterface).ExtractingDiagnosis(hosEncId)
ClassMethod ExtractingDiagnosis(hosEncId As %String) As %String
{
    s httpRequest = ##class(%Net.HttpRequest).%New()    //初始化一个请求
    s params={}
    s data={}  //请求数据
    d data.%Set("hdcEncId","")
    d data.%Set("hosEncId",hosEncId)
    d data.%Set("hdcPatRegNo","0009221406")
    d data.%Set("hosPatRegNo","")
    d data.%Set("encHosCode","")
    s diagnoseInfo={}
    d diagnoseInfo.%Set("diagnoseName","")
    d diagnoseInfo.%Set("diagnoseDate","")
    d data.%Set("diagnoseInfo",diagnoseInfo)
    d params.%Set("data",data)
    //s params={"data":{"hdcPatRegNo":"0009221406","hosPatRegNo":"","hdcEncId":"","hosEncId":"","encHosCode":"","diagnoseInfo":{"diagnoseName":"","diagnoseDate":""}}}
    //s params={"data":{"encHosCode":"00001"}}
    s params=params.%ToJSON()
    s Url="http://192.178.61.87:9090/emviewdoctor/hdc/SerachQuery/MES0004"
    do httpRequest.SetHeader("Content-Type","application/x-www-form-urlencoded; charset=utf8")
    do httpRequest.InsertFormData("params", params)
    //do httpRequest.InsertFormData("page", 1)
    //do httpRequest.InsertFormData("rows", 2)
    s status = httpRequest.Post(Url)
    //w "status："_status,!
    //If $$$ISERR(status) { Quit $system.OBJ.DisplayError(status) }
    s responseString=##class(%Stream.GlobalCharacter).%New()
    s responseString = httpRequest.HttpResponse.Data
    s json=""
    while 'responseString.AtEnd
    {
        s json=json_responseString.ReadLine()
    }
    s json=[].%FromJSON()
    s responseData=json.%Get("data")
    for i=0:1:(responseData.%Size()-1)
    {
        s DiagJson={}
        d DiagJson.%Set("IDNO",info.%Get("hosEncId"))
        d DiagJson.%Set("PatientDR",info.%Get("hosPatRegNo"))
        d DiagJson.%Set("VisitID",info.%Get("hosPatRegNo"))
        d DiagJson.%Set("VisitType",..ConvertVisitType(info.%Get("VisitType")))
        d DiagJson.%Set("UserID",info.%Get("UserID"))
        d DiagJson.%Set("UserName",info.%Get("UserName"))
        d DiagJson.%Set("CTLocID",info.%Get("DeptCode"))
        d DiagJson.%Set("CTLocDesc",info.%Get("DeptName"))
        
        s DiagnosisInfo={}  //诊断信息
        d DiagnosisInfo.%Set("DataClass","DiagnosisInfo")
        s DiagnosisInfoC=[]  //基础信息详细内容
        s DiagnosisInfoDict={}  //单个诊断信息详细内容
        d DiagnosisInfoDict.%Set("DiagnosisSequence",responseData.%Get(i).%Get("hosDiagId"))  //诊断ID
        d DiagnosisInfoDict.%Set("DiagnosisCode",responseData.%Get(i).%Get("diagnoseName"))  //诊断编码
        d DiagnosisInfoDict.%Set("DiagnosisName",responseData.%Get(i).%Get("diagnoseName"))  //诊断名称
        d DiagnosisInfoDict.%Set("DiagnosisType",responseData.%Get(i).%Get("diagTypeDesc"))  //诊断类型
        d DiagnosisInfoDict.%Set("DiagnosisDesc","")  //诊断描述
        d DiagnosisInfoDict.%Set("ChildDiagnosisFlag",$CASE("",2:1,1:0,:1))  //子诊断标记，默认否
        d DiagnosisInfoDict.%Set("DiagnosisTime",responseData.%Get(i).%Get("diagnoseDate"))  //开立时间
        d DiagnosisInfoDict.%Set("DiagnosisStatus","")  //诊断状态
        d DiagnosisInfoC.%Push(DiagnosisInfoDict)
        d DiagnosisInfo.%Set("children",DiagnosisInfoC)
        d children.%Push(DiagnosisInfo)
        d DiagJson.%Set("children",children)
        s config=##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020061601")
        s RationalResult=##Class(web.CDSS.MachineLearning.DataVerification).DataRationalisation(DiagJson.%ToJSON())  //对第三方数据json串进行数据合理性校验，包括（数据类型是否匹配，主键是否存在等）
        s RationalResult=[].%FromJSON(RationalResult)
        s UnifomResult=##Class(web.CDSS.MachineLearning.DataVerification).DataConsistency(DiagJson.%ToJSON())  //对第三方数据json串进行基本信息、就诊信息数据一致性和临床信息完整性校验
        s UnifomResult=[].%FromJSON(UnifomResult)
        if (RationalResult.%Size()=0)&(UnifomResult.%Size()=0)  //如果没有错误信息
        {
            return DiagJson.%ToJSON()       
        }
        elseif(config="Y")  //有错误信息，但是允许强制交互
        {
            return DiagJson.%ToJSON()
        }
        else  //有错误信息，不允许强制交互
        {
            for i=0:1:UnifomResult.%Size()-1
            {
                d RationalResult.%Push(UnifomResult.%Get(i))
            } 
            return RationalResult.%ToJSON()  
        }
    }
    q ""
}

/// Creator:chendailei
/// CreatDate:2020-08-20
/// Description：医院信息平台就诊信息抽取(只抽取就诊信息中的诊断信息)
/// Input: hosEncId :就诊号
/// Output: 获取到的数据
/// w ##class(web.CDSS.MachineLearning.InteractiveInterface).ExtractingVisitInfo(hosEncId)
ClassMethod ExtractingVisitInfo(hosEncId As %String) As %String
{
	s result=""
    s httpRequest = ##class(%Net.HttpRequest).%New()    //初始化一个请求
    s params={"data":{"hdcPatRegNo":"","hosPatRegNo":"","hdcEncId":"","hosEncId":"","encHosCode":"","encounterInfo":{"encTypeCode":[],"encDocCode":[],"encDeptCode":[],"encStartDate":"","encEndDate":""}}}
    d params.%Get("data").%Set("hosEncId",hosEncId)
    s params=params.%ToJSON()
    s Url="http://192.178.61.87:9090/emviewdoctor/hdc/SerachQuery/MES0002"
    do httpRequest.SetHeader("Content-Type","application/x-www-form-urlencoded; charset=utf8")
    do httpRequest.InsertFormData("params", params)
    //do httpRequest.InsertFormData("page", 1)
    //do httpRequest.InsertFormData("rows", 2)
    s status = httpRequest.Post(Url)
    //w "status："_status,!
    //If $$$ISERR(status) { Quit $system.OBJ.DisplayError(status) }
    s responseString=##class(%Stream.GlobalCharacter).%New()
    s responseString = httpRequest.HttpResponse.Data
    s json=""
    while 'responseString.AtEnd
    {
        s json=json_responseString.ReadLine()
    }
    s json=[].%FromJSON(json)
    s responseData=json.%Get("data")
    for i=0:1:(responseData.%Size()-1)
    {
        s DiagJson={}
        d DiagJson.%Set("IDNO",responseData.%Get(i).%Get("hosEncId"))
        d DiagJson.%Set("PatientDR",responseData.%Get(i).%Get("hosPatRegNo"))
        d DiagJson.%Set("VisitID",responseData.%Get(i).%Get("hosPatRegNo"))
        d DiagJson.%Set("VisitType",responseData.%Get(i).%Get("encTypeDesc"))
        d DiagJson.%Set("UserID",responseData.%Get(i).%Get("encDocCode"))
        d DiagJson.%Set("UserName",responseData.%Get(i).%Get("encDocName"))
        d DiagJson.%Set("CTLocID",responseData.%Get(i).%Get("encDeptCode"))
        d DiagJson.%Set("CTLocDesc",responseData.%Get(i).%Get("encDeptName"))
        s children=[]  //所有信息表
        ///病例信息表
        s CaseInfo={}  //就诊信息
        d CaseInfo.%Set("DataClass","PatientVisit")
        s CaseInfoC=[]  //就诊信息详细内容
        s CaseInfoDict={}  //单个基础信息详细内容
        d CaseInfoDict.%Set("VisitType",responseData.%Get(i).%Get("encTypeDesc")) //就诊类型（急诊、门诊、住院）
        d CaseInfoDict.%Set("TreatmentTime",responseData.%Get(i).%Get("encStartDate")) //就诊时间
        d CaseInfoDict.%Set("VisitingDepartment",responseData.%Get(i).%Get("encDeptName")) //就诊科室
        d CaseInfoDict.%Set("ComorbidityMarker","") //合并症标记
        d CaseInfoDict.%Set("TransferRecord","") //转科记录
        d CaseInfoDict.%Set("DischargeTime","") //离院时间
        d CaseInfoDict.%Set("DischargeDepartment","") //离院科室
        d CaseInfoDict.%Set("ChiefCompSum","") //主诉概述
        d CaseInfoDict.%Set("CurrentMedHisSum","") //现病史概述
        d CaseInfoDict.%Set("PastDiagnosisSum","") //既往史概述
        d CaseInfoDict.%Set("FamilyHisSum","") //家族史概述
        d CaseInfoDict.%Set("PersonalHisSum","") //个人史概述
        d CaseInfoDict.%Set("MarryHisSum","")  //婚育史概述
        d CaseInfoDict.%Set("MenstrualHisSum","")  //月经史概述
        d CaseInfoDict.%Set("AllergyHisSum","") //过敏史概述
        d CaseInfoDict.%Set("PhysicalExamSum","") //体格检查概述
        d CaseInfoDict.%Set("SpecExamSum","") //转科检查概述
        d CaseInfoC.%Push(CaseInfoDict)
        d CaseInfo.%Set("children",CaseInfoC)
        d children.%Push(CaseInfo)
        
        ///诊断信息
        s diagnoseInfo=responseData.%Get(i).%Get("diagnoseInfo")  //平台组抽取就诊信息中的诊断信息
        if (diagnoseInfo="")  //如果平台组没有传这个字段
        {
            s diagnoseInfo=[]
        }
        for j=0:1:(diagnoseInfo.%Size()-1)
        {
            s DiagnosisInfo={}  //诊断信息
            d DiagnosisInfo.%Set("DataClass","DiagnosisInfo")
            s DiagnosisInfoC=[]  //基础信息详细内容
            s DiagnosisInfoDict={}  //单个诊断信息详细内容
            d DiagnosisInfoDict.%Set("DiagnosisSequence",diagnoseInfo.%Get(j).%Get("hosDiagId"))  //诊断ID
            d DiagnosisInfoDict.%Set("DiagnosisCode",diagnoseInfo.%Get(j).%Get("diagnoseName"))  //诊断编码
            d DiagnosisInfoDict.%Set("DiagnosisName",diagnoseInfo.%Get(j).%Get("diagnoseName"))  //诊断名称
            d DiagnosisInfoDict.%Set("DiagnosisType",diagnoseInfo.%Get(j).%Get("diagTypeDesc"))  //诊断类型
            d DiagnosisInfoDict.%Set("DiagnosisDesc","")  //诊断描述
            d DiagnosisInfoDict.%Set("ChildDiagnosisFlag",$CASE("",2:1,1:0,:1))  //子诊断标记，默认否
            d DiagnosisInfoDict.%Set("DiagnosisTime",diagnoseInfo.%Get(j).%Get("diagnoseDate"))  //开立时间
            d DiagnosisInfoDict.%Set("DiagnosisStatus","")  //诊断状态
            d DiagnosisInfoC.%Push(DiagnosisInfoDict)
            d DiagnosisInfo.%Set("children",DiagnosisInfoC)
            d children.%Push(DiagnosisInfo)
        }
        d DiagJson.%Set("children",children)
        s config=##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020061601")
        s RationalResult=##Class(web.CDSS.MachineLearning.DataVerification).DataRationalisation(DiagJson.%ToJSON())  //对第三方数据json串进行数据合理性校验，包括（数据类型是否匹配，主键是否存在等）
        s RationalResult=[].%FromJSON(RationalResult)
        s UnifomResult=##Class(web.CDSS.MachineLearning.DataVerification).DataConsistency(DiagJson.%ToJSON())  //对第三方数据json串进行基本信息、就诊信息数据一致性和临床信息完整性校验
        s UnifomResult=[].%FromJSON(UnifomResult)
        s FinalResult=""
        if (RationalResult.%Size()=0)&(UnifomResult.%Size()=0)  //如果没有错误信息
        {
            s FinalResult=DiagJson.%ToJSON()        
        }
        elseif(config="Y")  //有错误信息，但是允许强制交互
        {
            s FinalResult=DiagJson.%ToJSON()
        }
        else  //有错误信息，不允许强制交互
        {
            for i=0:1:UnifomResult.%Size()-1
            {
                d RationalResult.%Push(UnifomResult.%Get(i))
            } 
            s FinalResult=RationalResult.%ToJSON()  
        }
        //w FinalResult,!,!
        s result="抽取成功！  "_FinalResult
        try
        {
            d ##Class("web.CDSS.MachineLearning.ParseMode").ParsePatientModel(FinalResult)
        }
        catch e
        {
            s number=$o(^TMPCDSSCDR(""),-1)+1
            s ^TMPCDSSCDR(number)=FinalResult_"&&"_e.Name
            s result="抽取失败！"_e.name
        }
    }
    q result
}

/// Creator:chendailei
/// CreatDate:2020-08-20
/// Description：医院信息平台医嘱信息抽取
/// Input: hosEncId :就诊号
/// Output: 获取到的数据
/// w ##class(web.CDSS.MachineLearning.InteractiveInterface).ExtractingOrderInfo(hosEncId)
ClassMethod ExtractingOrderInfo(hosEncId As %String) As %String
{
    s httpRequest = ##class(%Net.HttpRequest).%New()    //初始化一个请求
    s params={"data":{"hdcPatRegNo":"","hosPatRegNo":"","hdcEncId":"","hosEncId":"","encHosCode":"","orderInfo":{"orderName":"","orderCode":[],"ordStatusList":[],"ordEnterDate":"","ordPriList":[],"ordCatList":[],"ordSubCatList":[],"ordDeptList":[],"ordExecDeptList":[]}}}
    d params.%Get("data").%Set("hosEncId",hosEncId)
    s params=params.%ToJSON()
    s Url="http://192.178.61.87:9090/emviewdoctor/hdc/SerachQuery/MES0008"
    do httpRequest.SetHeader("Content-Type","application/x-www-form-urlencoded; charset=utf8")
    do httpRequest.InsertFormData("params", params)
    //do httpRequest.InsertFormData("page", 1)
    //do httpRequest.InsertFormData("rows", 2)
    s status = httpRequest.Post(Url)
    //w "status："_status,!
    //If $$$ISERR(status) { Quit $system.OBJ.DisplayError(status) }
    s responseString=##class(%Stream.GlobalCharacter).%New()
    s responseString = httpRequest.HttpResponse.Data
    s json=""
    while 'responseString.AtEnd
    {
        s json=json_responseString.ReadLine()
    }
    s json=[].%FromJSON(json)
    s responseData=json.%Get("data")
    for i=0:1:(responseData.%Size()-1)
    {
        s OrderJson={}
        d OrderJson.%Set("IDNO",responseData.%Get(i).%Get("hosEncId"))
        d OrderJson.%Set("PatientDR",responseData.%Get(i).%Get("hosPatRegNo"))
        d OrderJson.%Set("VisitID",responseData.%Get(i).%Get("hosPatRegNo"))
        s VisitType=""
        s PatientVisitId=$o(^WDT.CDSS.PatientVisitI("IDNOIndex"," "_$ZCONVERT(responseData.%Get(i).%Get("hosEncId"),"U"),0))
        if (PatientVisitId'="")  //如果就诊信息存在
        {
            s VisitType=$lg($g(^WDT.CDSS.PatientVisitD(PatientVisitId)),5)
        }
        else
        {
            s VisitType="无就诊信息"
        }
        d OrderJson.%Set("VisitType",VisitType)
        d OrderJson.%Set("UserID",responseData.%Get(i).%Get("ordDocCode"))
        d OrderJson.%Set("UserName",responseData.%Get(i).%Get("ordDocName"))
        d OrderJson.%Set("CTLocID",responseData.%Get(i).%Get("ordDeptCode"))
        d OrderJson.%Set("CTLocDesc",responseData.%Get(i).%Get("ordDeptName"))
        s children=[]
        s ordCatDesc=responseData.%Get(i).%Get("ordCatDesc")   //医嘱大类
        ///处方信息（药品）
        if (ordCatDesc="西药")||(ordCatDesc="中成药")||(ordCatDesc="中草药")||(ordCatDesc="便民药品")
        {
            s DrugInfo={}  //药品信息
            d DrugInfo.%Set("DataClass","DrugInfo")
            s DrugInfoC=[]  //详细内容
            s DrugInfoDict={}  //单个详细内容
            d DrugInfoDict.%Set("Type",responseData.%Get(i).%Get("ordPriDesc")) //类型(长期、临时（皮试）)
            d DrugInfoDict.%Set("GroupFlag",responseData.%Get(i).%Get("hosOrdId")) //医嘱单号
            d DrugInfoDict.%Set("GroupSequence",responseData.%Get(i).%Get("ordGrpNo")) //组顺序
            d DrugInfoDict.%Set("DrugCode",responseData.%Get(i).%Get("orderCode")) //药品编码
            d DrugInfoDict.%Set("DrugName",responseData.%Get(i).%Get("orderName")) //药品名称
            d DrugInfoDict.%Set("Usage",responseData.%Get(i).%Get("medUsageDesc")) //用法
            d DrugInfoDict.%Set("Dose",responseData.%Get(i).%Get("medicineDosage")) //剂量
            d DrugInfoDict.%Set("Frequency",responseData.%Get(i).%Get("medFreqDesc")) //频率
            d DrugInfoDict.%Set("Unit",responseData.%Get(i).%Get("medDosUnitDesc")) //单位
            d DrugInfoDict.%Set("Specification",responseData.%Get(i).%Get("medDoseFormDesc")) //规格
            d DrugInfoDict.%Set("StartTime",responseData.%Get(i).%Get("orderDate")) //开始时间
            d DrugInfoDict.%Set("StopTime",responseData.%Get(i).%Get("ordStopDate")) //停止时间
            d DrugInfoDict.%Set("ExecuteTime",..GetOrderExecutionDate(responseData.%Get(i).%Get("hosOrdId"))) //执行时间
            d DrugInfoDict.%Set("ReportTime",responseData.%Get(i).%Get("orderDate")) //报告时间
            d DrugInfoDict.%Set("Remarks","") //备注
            d DrugInfoC.%Push(DrugInfoDict)
            d DrugInfo.%Set("children",DrugInfoC)
            d children.%Push(DrugInfo)
        }
        ///检查
        elseif (ordCatDesc="检查")
        {
            s ExamInfo={}  //检查信息
            d ExamInfo.%Set("DataClass","ExamInfo")
            s ExamInfoC=[]  //详细内容
            s ExamInfoDict={}  //单个详细内容
            d ExamInfoDict.%Set("GroupFlag",responseData.%Get(i).%Get("hosOrdId")) //医嘱单号
            d ExamInfoDict.%Set("GroupSequence",responseData.%Get(i).%Get("ordGrpNo")) //组顺序
            d ExamInfoDict.%Set("ExamCode",responseData.%Get(i).%Get("orderCode")) //检查编码
            d ExamInfoDict.%Set("ExamName",responseData.%Get(i).%Get("orderName")) //检查名称
            d ExamInfoDict.%Set("ExamResultNum","") //检查结果顺序号
            d ExamInfoDict.%Set("ExamResult","") //检查结果
            d ExamInfoDict.%Set("ExamResultFlag","") //检查结果指标（阴性或阳性）
            d ExamInfoDict.%Set("ExamResultDesc","") //检查结果概述
            d ExamInfoDict.%Set("PartDR","") //部位（改成指针）
            d ExamInfoDict.%Set("ExecuteTime",..GetOrderExecutionDate(responseData.%Get(i).%Get("hosOrdId"))) //执行时间
            d ExamInfoDict.%Set("ReportTime",responseData.%Get(i).%Get("orderDate")) //报告时间
            d ExamInfoDict.%Set("Remarks","") //备注
            d ExamInfoC.%Push(ExamInfoDict)
            d ExamInfo.%Set("children",ExamInfoC)
            d children.%Push(ExamInfo)
        }
        ///检验
        elseif (ordCatDesc="检验")
        {
            s LabInfo={}  //检查信息
            d LabInfo.%Set("DataClass","LabInfo")
            s LabInfoC=[]  //详细内容
            s LabInfoDict={}  //单个详细内容
            d LabInfoDict.%Set("GroupFlag",responseData.%Get(i).%Get("hosOrdId")) //医嘱单号
            //d LabInfoDict.%Set("GroupSequence",responseData.%Get(i).%Get("ordGrpNo")) //组顺序
            d LabInfoDict.%Set("InspectionCode",responseData.%Get(i).%Get("orderCode")) //检验大项编码
            d LabInfoDict.%Set("InspectionName",responseData.%Get(i).%Get("orderName")) //检验大项名称
            d LabInfoDict.%Set("LabItemCode","") //检验小项编码
            d LabInfoDict.%Set("LabItemName","") //检验小项名称
            d LabInfoDict.%Set("LabResult","") //检验结果
            d LabInfoDict.%Set("LabResultFlag","") //检验结果指标（阴性或阳性）
            d LabInfoDict.%Set("Unit","") //单位
            d LabInfoDict.%Set("Reference","") //参考值
            if (responseData.%Get(i).%Get("Sample")'="")  //如果标本为空，不传避免覆盖检验报告中的标本
            {
                d LabInfoDict.%Set("Specimen","")  //标本
            }
            d LabInfoDict.%Set("ExecuteTime",..GetOrderExecutionDate(responseData.%Get(i).%Get("hosOrdId"))) //执行时间
            d LabInfoDict.%Set("ReportTime",responseData.%Get(i).%Get("orderDate")) //报告时间
            d LabInfoDict.%Set("Remarks","") //备注
            d LabInfoC.%Push(LabInfoDict)
            d LabInfo.%Set("children",LabInfoC)
            d children.%Push(LabInfo)
        }
        ///手术
        elseif (ordCatDesc="手术")
        {
            s OperationInfo={}  //手术信息
            d OperationInfo.%Set("DataClass","OperationInfo")
            s OperationInfoC=[]  //详细内容
            s OperationInfoDict={}  //单个详细内容        
            d OperationInfoDict.%Set("OperNum","") //手术次数
            d OperationInfoDict.%Set("OperSequence","") //手术顺序号
            d OperationInfoDict.%Set("MainOperFlag","") //主手术标记
            d OperationInfoDict.%Set("OperCode",responseData.%Get(i).%Get("orderCode")) //手术编码
            d OperationInfoDict.%Set("OperName",responseData.%Get(i).%Get("orderName")) //手术名称
            d OperationInfoDict.%Set("OperDesc","") //手术描述
            d OperationInfoDict.%Set("OperType","") //手术部位
            d OperationInfoDict.%Set("OperPosition","") //手术体位
            d OperationInfoDict.%Set("IntraoperDiagnosis","") //术中诊断
            d OperationInfoDict.%Set("OperDuration","") //手术持续时间
            d OperationInfoDict.%Set("OperStartTime","") //手术开始时间
            d OperationInfoDict.%Set("OperEndTime","") //手术结束时间
            d OperationInfoC.%Push(OperationInfoDict)
            d OperationInfo.%Set("children",OperationInfoC)
            d children.%Push(OperationInfo)
        }
        ///麻醉
        elseif (ordCatDesc="麻醉")
        {
            s AnestInfo={}  //麻醉信息
            d AnestInfo.%Set("DataClass","AnestInfo")
            s AnestInfoC=[]  //详细内容
            s AnestInfoDict={}  //单个详细内容        
            d AnestInfoDict.%Set("AnestMedication","") //麻醉用药
            d AnestInfoDict.%Set("Dose","") //剂量
            d AnestInfoDict.%Set("Usage",responseData.%Get(i).%Get("orderName")) //用法
            d AnestInfoDict.%Set("Anesthesia","") //麻醉方式
            d AnestInfoDict.%Set("AnestSite","") //麻醉部位
            d AnestInfoDict.%Set("AnestDuration","") //麻醉持续时长
            d AnestInfoDict.%Set("AnestStartTime","") //麻醉开始时间
            d AnestInfoC.%Push(AnestInfoDict)
            d AnestInfo.%Set("children",AnestInfoC)
            d children.%Push(AnestInfo)
        }
        ///护理
        elseif (ordCatDesc="护理")
        {
            s NursingInfo={}  //护理信息
            d NursingInfo.%Set("DataClass","NursingInfo")
            s NursingInfoC=[]  //详细内容
            s NursingInfoDict={}  //单个详细内容
            d NursingInfoDict.%Set("NursingItemNum","") //护理项目顺序号
            d NursingInfoDict.%Set("NursingItemCode",responseData.%Get(i).%Get("orderCode")) //护理项目编码
            d NursingInfoDict.%Set("NursingItemName",responseData.%Get(i).%Get("orderName")) //护理项目名称
            d NursingInfoDict.%Set("ChildItemNum","") //护理小项顺序号
            d NursingInfoDict.%Set("ChildItemCode","") //护理小项编码
            d NursingInfoDict.%Set("ChildItemName","") //护理小项名称
            d NursingInfoDict.%Set("NursingEffect","") //护理效果
            d NursingInfoC.%Push(NursingInfoDict)
            d NursingInfo.%Set("children",NursingInfoC)
            d children.%Push(NursingInfo)
        }
        ///饮食
        elseif (ordCatDesc="饮食")
        {
            s DietInfo={}  //饮食信息
            d DietInfo.%Set("DataClass","DietInfo")
            s DietInfoC=[]  //详细内容
            s DietInfoDict={}  //单个详细内容
            d DietInfoDict.%Set("GroupFlag",responseData.%Get(i).%Get("hosOrdId")) //医嘱单号
            d DietInfoDict.%Set("GroupSequence",responseData.%Get(i).%Get("ordGrpNo")) //组顺序
            d DietInfoDict.%Set("DietMethod","") //饮食方式
            d DietInfoDict.%Set("DietType","") //饮食类型
            d DietInfoDict.%Set("DietContent",responseData.%Get(i).%Get("orderName")) //饮食内容
            d DietInfoDict.%Set("DietAmount","") //饮食量
            d DietInfoDict.%Set("DietInstructions","") //饮食说明
            d DietInfoDict.%Set("Duration","") //持续时长
            d DietInfoDict.%Set("StartTime","") //开始时间
            d DietInfoDict.%Set("EndTime","") //结束时间
            d DietInfoC.%Push(DietInfoDict)
            d DietInfo.%Set("children",DietInfoC)
            d children.%Push(DietInfo)
        }
        d OrderJson.%Set("children",children)
        s config=##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020061601")
        s RationalResult=##Class(web.CDSS.MachineLearning.DataVerification).DataRationalisation(OrderJson.%ToJSON())  //对第三方数据json串进行数据合理性校验，包括（数据类型是否匹配，主键是否存在等）
        s RationalResult=[].%FromJSON(RationalResult)
        s UnifomResult=##Class(web.CDSS.MachineLearning.DataVerification).DataConsistency(OrderJson.%ToJSON())  //对第三方数据json串进行基本信息、就诊信息数据一致性和临床信息完整性校验
        s UnifomResult=[].%FromJSON(UnifomResult)
        s FinalResult=""
        if (RationalResult.%Size()=0)&(UnifomResult.%Size()=0)  //如果没有错误信息
        {
            s FinalResult=OrderJson.%ToJSON()   
        }
        elseif(config="Y")  //有错误信息，但是允许强制交互
        {
            s FinalResult=OrderJson.%ToJSON()
        }
        else  //有错误信息，不允许强制交互
        {
            for i=0:1:UnifomResult.%Size()-1
            {
                d RationalResult.%Push(UnifomResult.%Get(i))
            } 
            s FinalResult=RationalResult.%ToJSON()  
        }
        //w FinalResult,!
        s result="抽取成功！  "_FinalResult
        try
        {
            d ##Class("web.CDSS.MachineLearning.ParseMode").ParsePatientModel(FinalResult)
        }
        catch e
        {
            s number=$o(^TMPCDSSCDR(""),-1)+1
            s ^TMPCDSSCDR(number)=FinalResult_"&&"_e.Name
            s result="抽取失败！"_e.name
        }
    }
    q result
}

/// Creator:chendailei
/// CreatDate:2020-08-25
/// Description：医院信息平台检查报告信息抽取
/// Input: hosEncId :就诊号
/// Output: 获取到的数据
/// w ##class(web.CDSS.MachineLearning.InteractiveInterface).ExtractExamReportInfo(hosEncId)
ClassMethod ExtractExamReportInfo(hosEncId As %String) As %String
{
    s httpRequest = ##class(%Net.HttpRequest).%New()    //初始化一个请求
    s params={"data":{"hdcPatRegNo":"","hosPatRegNo":"","hdcEncId":"","hosEncId":"","encHosCode":"","examInfo":{"examRptDocCode":[],"examRptDocName":[],"examItemName":"","examRptDate":"","ordSubCatCode":""}}}
    d params.%Get("data").%Set("hosEncId",hosEncId)
    s params=params.%ToJSON()
    s Url="http://192.178.61.87:9090/emviewdoctor/hdc/SerachQuery/MES0012"
    do httpRequest.SetHeader("Content-Type","application/x-www-form-urlencoded; charset=utf8")
    do httpRequest.InsertFormData("params", params)
    //do httpRequest.InsertFormData("page", 1)
    //do httpRequest.InsertFormData("rows", 2)
    s status = httpRequest.Post(Url)
    //w "status："_status,!
    //If $$$ISERR(status) { Quit $system.OBJ.DisplayError(status) }
    s responseString=##class(%Stream.GlobalCharacter).%New()
    s responseString = httpRequest.HttpResponse.Data
    s json=""
    while 'responseString.AtEnd
    {
        s json=json_responseString.ReadLine()
    }
    s json=[].%FromJSON(json)
    s data=json.%Get("data")
    for i=0:1:(data.%Size()-1)
    {
        s SaveDict={}
        s GroupFlag=data.%Get(i).%Get("hosOrdId")  //获取医嘱号
        if (GroupFlag="")
        {
            continue
        }
        s ExamResultDesc=data.%Get(i).%Get("examSymptom")  //检查结果概述
        s ExecuteTime=data.%Get(i).%Get("examDate")    //执行时间
        s ReportTime=data.%Get(i).%Get("examRptDate")    //报告时间
        s Remarks=data.%Get(i).%Get("diagnoseComments")    //备注，用于存储诊断意见
        d SaveDict.%Set("GroupFlag",GroupFlag)
        d SaveDict.%Set("ExamResultDesc",ExamResultDesc)
        d SaveDict.%Set("ExecuteTime",ExecuteTime)
        d SaveDict.%Set("ReportTime",ReportTime)
        d SaveDict.%Set("Remarks",Remarks)
        s SaveDict=SaveDict.%ToJSON()
        //w SaveDict,!
        s result="抽取成功！  "_SaveDict
        try
        {
            d ##class(web.CDSS.MachineLearning.ParseMode).UpdateExamInfo(SaveDict)
        }
        catch e
        {
            s number=$o(^TMPCDSSCDR(""),-1)+1
            s ^TMPCDSSCDR(number)=SaveDict_"&&"_e.Name
            s result="抽取失败！"_e.name
        }
    }
    q result
}

/// Creator:chendailei
/// CreatDate:2020-08-25
/// Description：医院信息平台检验报告信息抽取
/// Input: hosEncId :就诊号
/// Output: 获取到的数据
/// w ##class(web.CDSS.MachineLearning.InteractiveInterface).ExtractLabReportInfo(hosEncId)
ClassMethod ExtractLabReportInfo(hosEncId As %String) As %String
{
    s httpRequest = ##class(%Net.HttpRequest).%New()    //初始化一个请求
    s params={"data":{"hdcPatRegNo":"","hdcEncId":"","hosPatRegNo":"","encHosCode":"","hosEncId":"","inspOrdInfo":{"orderName":"","inspRptVerifyDate":""}}}
    d params.%Get("data").%Set("hosEncId",hosEncId)
    s params=params.%ToJSON()
    s Url="http://192.178.61.87:9090/emviewdoctor/hdc/SerachQuery/MES0024"
    do httpRequest.SetHeader("Content-Type","application/x-www-form-urlencoded; charset=utf8")
    do httpRequest.InsertFormData("params", params)
    //do httpRequest.InsertFormData("page", 1)
    //do httpRequest.InsertFormData("rows", 2)
    s status = httpRequest.Post(Url)
    //w "status："_status,!
    //If $$$ISERR(status) { Quit $system.OBJ.DisplayError(status) }
    s responseString=##class(%Stream.GlobalCharacter).%New()
    s responseString = httpRequest.HttpResponse.Data
    s json=""
    while 'responseString.AtEnd
    {
        s json=json_responseString.ReadLine()
    }
    s json=[].%FromJSON(json)
    s data=json.%Get("data")
    for i=0:1:(data.%Size()-1)
    {
        s SaveDict={}
        s Specimen=data.%Get(i).%Get("inspSpecmName")  //样本信息
        s SpecimenId=$o(^CT.WDT.CDSS.LabSpecimenDictI("NameIndex"," "_$ZCONVERT(Specimen,"U"),0))  //获取检验标本在字典表中的RowID
        if (SpecimenId="")  //如果检验标本名称不存在于字典表中，将该检验标本存入字典中
        {
            s SpecimenId=..SaveLabSpecimenDict(Specimen,Specimen,"","","","","华西二院","")
        }
        s GroupFlag=data.%Get(i).%Get("hosOrdId")  //获取医嘱号
        if (GroupFlag="")
        {
            continue
        }
        s GroupSequence=data.%Get(i).%Get("hosInspRptId")  //获取报告单号
        s ExecuteTime=data.%Get(i).%Get("inspectionDate")  //执行时间
        s ReportTime=data.%Get(i).%Get("inspRptVerifyDate")    //报告时间
        s Remarks=data.%Get(i).%Get("inspRptRemarks")    //备注
        d SaveDict.%Set("GroupFlag",GroupFlag)
        d SaveDict.%Set("GroupSequence",GroupSequence)
        d SaveDict.%Set("ExecuteTime",ExecuteTime)
        d SaveDict.%Set("ReportTime",ReportTime)
        d SaveDict.%Set("Remarks",Remarks)
        d SaveDict.%Set("Specimen",SpecimenId)
        s SaveDict=SaveDict.%ToJSON()
        //w SaveDict,!
        s result="抽取成功！  "_SaveDict
        try
        {
            d ##class(web.CDSS.MachineLearning.ParseMode).UpdateLabInfo("update",SaveDict)
        }
        catch e
        {
            s number=$o(^TMPCDSSCDR(""),-1)+1
            s ^TMPCDSSCDR(number)=SaveDict_"&&"_e.Name
            s result="抽取失败！"_e.name
        }
    }
    q result
}

/// Creator:chendailei
/// CreatDate:2020-08-25
/// Description：医院信息平台检验报告项目结果信息抽取
/// Input: hosEncId :就诊号
/// Output: 获取到的数据
/// w ##class(web.CDSS.MachineLearning.InteractiveInterface).ExtractLabReportResultInfo(hosEncId)
ClassMethod ExtractLabReportResultInfo(hosEncId As %String) As %String
{
    s httpRequest = ##class(%Net.HttpRequest).%New()    //初始化一个请求
    s params={"data":{"hdcPatRegNo":"","hdcEncId":"","hosPatRegNo":"","encHosCode":"00001","hosEncId":"","inspOrdInfo":{"hdcInspRptId":"8396988","orderName":"","inspItemCode":""}}}
    d params.%Get("data").%Set("hosEncId",hosEncId)
    s params=params.%ToJSON()
    s Url="http://192.178.61.87:9090/emviewdoctor/hdc/SerachQuery/MES0023"
    do httpRequest.SetHeader("Content-Type","application/x-www-form-urlencoded; charset=utf8")
    do httpRequest.InsertFormData("params", params)
    //do httpRequest.InsertFormData("page", 1)
    //do httpRequest.InsertFormData("rows", 2)
    s status = httpRequest.Post(Url)
    //w "status："_status,!
    //If $$$ISERR(status) { Quit $system.OBJ.DisplayError(status) }
    s responseString=##class(%Stream.GlobalCharacter).%New()
    s responseString = httpRequest.HttpResponse.Data
    s json=""
    while 'responseString.AtEnd
    {
        s json=json_responseString.ReadLine()
    }
    s json=[].%FromJSON(json)
    s data=json.%Get("data")
    for i=0:1:(data.%Size()-1)
    {
        s SaveDict={}
        s LabItemCode=data.%Get(i).%Get("inspItemCode")  //检验小项编码
        s LabItemName=data.%Get(i).%Get("inspItemDesc")    //检验小项名称
        s LabResult=data.%Get(i).%Get("inspectionValue")    //检验结果
        s Unit=data.%Get(i).%Get("inspResultUnitCode")    //单位
        s Reference=data.%Get(i).%Get("inspResultRange")    //参考值           
        s LabResultFlag=..GetLabResultFlag(LabResult,LabItemName)  //检验结果指标
        s GroupFlag=data.%Get(i).%Get("hosOrdId")  //医嘱号
        d SaveDict.%Set("GroupFlag",GroupFlag)
        d SaveDict.%Set("LabItemCode",LabItemCode)
        d SaveDict.%Set("LabItemName",LabItemName)
        d SaveDict.%Set("LabResult",LabResult)
        d SaveDict.%Set("Unit",Unit)
        d SaveDict.%Set("Reference",Reference)
        d SaveDict.%Set("LabResultFlag",LabResultFlag)
        s SaveDict=SaveDict.%ToJSON()
        //w SaveDict,!
        s result="抽取成功！  "_SaveDict
        try
        {
            d ##class(web.CDSS.MachineLearning.ParseMode).UpdateLabInfo("add",SaveDict)
        }
        catch e
        {
            s number=$o(^TMPCDSSCDR(""),-1)+1
            s ^TMPCDSSCDR(number)=SaveDict_"&&"_e.Name
            s result="抽取失败！"_e.name
        }
    }
    q result
}

/// Creator:chendailei
/// CreatDate:2020-08-25
/// Description：医院信息平台生命体征信息抽取
/// Input: hosEncId :就诊号
/// Output: 获取到的数据
/// w ##class(web.CDSS.MachineLearning.InteractiveInterface).ExtractVitalSignsInfo(hosEncId)
ClassMethod ExtractVitalSignsInfo(hosEncId As %String) As %String
{
    s httpRequest = ##class(%Net.HttpRequest).%New()    //初始化一个请求
    s params={"data":{"hdcPatRegNo":"","hosPatRegNo":"","hdcEncId":"","hosEncId":"","encHosCode":"","vitalSignInfo":{"vitalSignMeasItemCode":["Item2","Item4"],"vitalSignMeasStartDate":"2019-05-14","vitalSignMeasEndDate":"2019-06-11"}}}
    d params.%Get("data").%Set("hosEncId",hosEncId)
    s params=params.%ToJSON()
    s Url="http://192.178.61.87:9090/emviewdoctor/hdc/SerachQuery/MES0014"
    do httpRequest.SetHeader("Content-Type","application/x-www-form-urlencoded; charset=utf8")
    do httpRequest.InsertFormData("params", params)
    //do httpRequest.InsertFormData("page", 1)
    //do httpRequest.InsertFormData("rows", 2)
    s status = httpRequest.Post(Url)
    //w "status："_status,!
    //If $$$ISERR(status) { Quit $system.OBJ.DisplayError(status) }
    s responseString=##class(%Stream.GlobalCharacter).%New()
    s responseString = httpRequest.HttpResponse.Data
    s json=""
    while 'responseString.AtEnd
    {
        s json=json_responseString.ReadLine()
    }
    s json=[].%FromJSON(json)
    s SignData=json.%Get("data")
    s SaveDict={}
    if (SignData.%Get("Item1")'="")
    {
        for j=0:1:(SignData.%Get("Item1").%Size()-1)
        {
            s SingleData=SignData.%Get("Item1").%Get(j)
            d SaveDict.%Set("BodyTemperature",SingleData.%Get("vitalSignMeasValue"))
            d SaveDict.%Set("MeasureDate",SingleData.%Get("vitalSignMeasDate"))
        }
    }
    if (SignData.%Get("Item6")'="")
    {
        for j=0:1:(SignData.%Get("Item6").%Size()-1)
        {
            s SingleData=SignData.%Get("Item6").%Get(j)
            d SaveDict.%Set("DiastolicBlood",SingleData.%Get("vitalSignMeasValue"))
            d SaveDict.%Set("MeasureDate",SingleData.%Get("vitalSignMeasDate"))
        }
        
    }
    if (SignData.%Get("Item5")'="")
    {
        for j=0:1:(SignData.%Get("Item5").%Size()-1)
        {
            s SingleData=SignData.%Get("Item5").%Get(j)
            d SaveDict.%Set("SystolicBlood",SingleData.%Get("vitalSignMeasValue"))
            d SaveDict.%Set("MeasureDate",SingleData.%Get("vitalSignMeasDate"))
        }
        
    }
    if (SignData.%Get("Item7")'="")
    {
        for j=0:1:(SignData.%Get("Item7").%Size()-1)
        {
            s SingleData=SignData.%Get("Item7").%Get(j)
            d SaveDict.%Set("Pulse",SingleData.%Get("vitalSignMeasValue"))
            d SaveDict.%Set("MeasureDate",SingleData.%Get("vitalSignMeasDate"))
        }
        
    }
    if (SignData.%Get("Item4")'="")
    {
        for j=0:1:(SignData.%Get("Item4").%Size()-1)
        {
            s SingleData=SignData.%Get("Item4").%Get(j)
            d SaveDict.%Set("BreathFeature",SingleData.%Get("vitalSignMeasValue"))
            d SaveDict.%Set("MeasureDate",SingleData.%Get("vitalSignMeasDate"))
        }
        
    }
    if (SignData.%Get("心率")'="")
    {
        for j=0:1:(SignData.%Get("心率").%Size()-1)
        {
            s SingleData=SignData.%Get("心率").%Get(j)
            d SaveDict.%Set("HeartRate",SingleData.%Get("vitalSignMeasValue"))
            d SaveDict.%Set("MeasureDate",SingleData.%Get("vitalSignMeasDate"))
        }
        
    }
    if (SignData.%Get("Item25")'="")
    {
        for j=0:1:(SignData.%Get("Item25").%Size()-1)
        {
            s SingleData=SignData.%Get("Item25").%Get(j)
            d SaveDict.%Set("OxygenSaturation",SingleData.%Get("vitalSignMeasValue"))
            d SaveDict.%Set("MeasureDate",SingleData.%Get("vitalSignMeasDate"))
        }
        
    }
    if (SignData.%Get("Item2")'="")
    {
        for j=0:1:(SignData.%Get("Item2").%Size()-1)
        {
            s SingleData=SignData.%Get("Item2").%Get(j)
            d SaveDict.%Set("Weight",SingleData.%Get("vitalSignMeasValue"))
            d SaveDict.%Set("MeasureDate",SingleData.%Get("vitalSignMeasDate"))
        }
        
    }
    s SaveDict=SaveDict.%ToJSON()
    //w SaveDict,!
    s result="抽取成功！  "_FinalResult
    try
    {
        d ##class(web.CDSS.MachineLearning.ParseMode).UpdateSignInfo(SaveDict)
    }
    catch e
    {
        s number=$o(^TMPCDSSCDR(""),-1)+1
        s ^TMPCDSSCDR(number)=SaveDict_"&&"_e.Name
        s result="抽取失败！"_e.name
    }
    q result
}

/// Creator:chendailei
/// CreatDate:2020-08-26
/// Description：通过医嘱号获取医嘱执行日期
/// Input: hosOrdId :医嘱号
/// Output: 医嘱执行日期
/// w ##class(web.CDSS.MachineLearning.InteractiveInterface).GetOrderExecutionDate(hosOrdId)
ClassMethod GetOrderExecutionDate(hosOrdId As %String) As %String
{
    s httpRequest = ##class(%Net.HttpRequest).%New()    //初始化一个请求
    s params={"data":{"ordExecInfo":{"hdcOrdId":"","hosOrdId":""}}}
    d params.%Get("data").%Get("ordExecInfo").%Set("hosOrdId",hosOrdId)
    s params=params.%ToJSON()
    s Url="http://192.178.61.87:9090/emviewdoctor/hdc/SerachQuery/MES0010"
    do httpRequest.SetHeader("Content-Type","application/x-www-form-urlencoded; charset=utf8")
    do httpRequest.InsertFormData("params", params)
    //do httpRequest.InsertFormData("page", 1)
    //do httpRequest.InsertFormData("rows", 2)
    s status = httpRequest.Post(Url)
    //w "status："_status,!
    //If $$$ISERR(status) { Quit $system.OBJ.DisplayError(status) }
    s responseString=##class(%Stream.GlobalCharacter).%New()
    s responseString = httpRequest.HttpResponse.Data
    s json=""
    while 'responseString.AtEnd
    {
        s json=json_responseString.ReadLine()
    }
    s json=[].%FromJSON(json)
    s data=json.%Get("data")
    s ordExecDate=""
    for i=0:1:(data.%Size()-1)
    {
        s ordExecDate=data.%Get(i).%Get("ordExecDate")
        q
    }
    q ordExecDate
}

/// Creator:chendailei
/// CreatDate:2020-08-26
/// Description：数据采集平台总接口
/// Input: hosEncId :就诊号 action :数据采集类型
/// Output: 
/// w ##class(web.CDSS.MachineLearning.InteractiveInterface).DataAcquisitionPlatform(hosEncId,action)
ClassMethod DataAcquisitionPlatform(hosEncId As %String, action As %String) As %String
{
	s result=""
	if (action["EXTRACT_VISIT_INFORMATION")  //就诊信息（包括诊断信息）
	{
		s result=##class(web.CDSS.MachineLearning.InteractiveInterface).ExtractingVisitInfo(hosEncId)
	}
	if (action["EXTRACT_MEDICALORDER_INFORMATION")  //医嘱信息
	{
		s result=##class(web.CDSS.MachineLearning.InteractiveInterface).ExtractingOrderInfo(hosEncId)
	}
	if (action["EXTRACT_EXAMREPORT_INFORMATION")  //检查报告信息
	{
		s result=##class(web.CDSS.MachineLearning.InteractiveInterface).ExtractExamReportInfo(hosEncId)
	}
	if (action["EXTRACT_TESTREPORT_INFORMATION")  //检验报告信息
	{
		s result=##class(web.CDSS.MachineLearning.InteractiveInterface).ExtractLabReportInfo(hosEncId)
	}
	if (action["EXTRACT_TESTREPORT_RESULT_INFORMATION")  //检验报告项目结果信息
	{
		s result=##class(web.CDSS.MachineLearning.InteractiveInterface).ExtractLabReportResultInfo(hosEncId)
	}
	if (action["EXTRACTING_VITALSIGNS_INFORMATION")  //生命体征信息
	{
		s result=##class(web.CDSS.MachineLearning.InteractiveInterface).ExtractVitalSignsInfo(hosEncId)
	}
	q result
}

/// Creator:陈代雷
/// CreatDate:2020-06-09
/// Description:解析医嘱信息中所有医嘱名称，按照类型分类
/// Table:
/// Input: IDNO UserName
/// Return:医嘱字典
/// Others:w ##class(web.CDSS.MachineLearning.InteractiveInterface).GetTmpOrder("XwhTest^XwhTest^1^住院^13925^高姗姗^111^呼吸科^1")
ClassMethod GetTmpOrder(PatientInfo As %String) As %String
{
	s IDNO=$p(PatientInfo,"^",1)  //患者主索引
	s UserName=$p(PatientInfo,"^",6)  //预警用户
	q:(IDNO="")||(UserName="") "{}"
	
	s info=$g(^TMPOrder(IDNO,UserName))
	q:info="" "{}"
	s info=[].%FromJSON(info)
	s result={}
    s AllOrderEntry=info.%Get("OrderEntry")  //医嘱信息列表，医院数据
    for i=0:1:(AllOrderEntry.%Size()-1)
    {
        s OrderEntry=AllOrderEntry.%Get(i)
        s OrderInfoDict={}  //单个基础信息详细内容
        s OrderType=OrderEntry.%Get("OrderType")  //医嘱分类
        s OrderClass=OrderEntry.%Get("OrderClass")  //医嘱类型
        s OrderFlag=OrderEntry.%Get("OrderFlag")  //医嘱操作标识
        return:OrderFlag'=1 "{}"
        if result.%Get(OrderType)=""
        {
	        d result.%Set(OrderType,[].%Push(##class(web.CDSS.IMP.ContrastDict).GetDiectName(OrderEntry.%Get("OrderContent"),##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401"),"药品字典")))
        }
        else
        {
	        d result.%Get(OrderType).%Push(##class(web.CDSS.IMP.ContrastDict).GetDiectName(OrderEntry.%Get("OrderContent"),##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401"),"药品字典"))
        }
        
    }
    s ^TMPGSS("GetTmpOrder")=result.%ToJSON()
    q result.%ToJSON()
}

/// Creator:Xuwenhu
/// CreatDate:2021-12-09
/// Description:解析输血信息，返回json
/// Table:
/// Input: bloodjson 输血信息
/// Return:输血信息表json串
/// Others:w ##class(web.CDSS.MachineLearning.InteractiveInterface).SaveBloodTransInfo(bloodjson)
ClassMethod SaveBloodTransInfo(bloodjson As %String) As %String
{
	s info=[].%FromJSON(bloodjson)
    s BloodJson={}
    d BloodJson.%Set("IDNO",info.%Get("IDNO"))
    d BloodJson.%Set("PatientDR",info.%Get("PatientDR"))
    d BloodJson.%Set("VisitID",info.%Get("VisitID"))
    d BloodJson.%Set("VisitType",info.%Get("VisitType"))
    s children=[]  //所有信息表
    s ChildrenList=info.%Get("children")  //输血信息列表
    //s num=$o(^CT.WDT.CDSS.BloodHistoryI("BloodHistoryNum",info.%Get("PatientDR"),""),-1)	//最后一个过敏信息记录
    for i=0:1:(ChildrenList.%Size()-1)
    {
    	s BloodInfo={}  //输血信息
        d BloodInfo.%Set("DataClass","BloodTransInfo")
        s BloodInfoC=[]  //基础信息详细内容
        s BloodInfoDict={}  //单个输血信息详细内容
        d BloodInfoDict.%Set("BloodTransVolume",ChildrenList.%Get(i).%Get("BloodTransVolume"))	//输血量
        d BloodInfoDict.%Set("BloodTransVolumeU",ChildrenList.%Get(i).%Get("BloodSourceName"))  //输血量单位
        d BloodInfoDict.%Set("BloodTransSite",ChildrenList.%Get(i).%Get("BloodTransSite"))  	//输血部位
        d BloodInfoDict.%Set("BloodTransType",ChildrenList.%Get(i).%Get("BloodTransType")) 			//输血血型
        d BloodInfoDict.%Set("BloodTransTypeRh",ChildrenList.%Get(i).%Get("BloodTransTypeRh"))  	//RH
        d BloodInfoDict.%Set("BloodTransClass",##class(web.CDSS.IMP.ContrastDict).GetDiectName(ChildrenList.%Get(i).%Get("BloodTransClass"),##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401"),"输血品字典"))  		//输血品名称
        d BloodInfoDict.%Set("BTIndication",ChildrenList.%Get(i).%Get("BTIndication"))  			//输血指征
        d BloodInfoDict.%Set("BTIndicationValue",ChildrenList.%Get(i).%Get("BTIndicationValue"))			//指征值
        d BloodInfoDict.%Set("BTIndicationValueUnit",ChildrenList.%Get(i).%Get("BTIndicationValueUnit"))	//单位
        d BloodInfoDict.%Set("PassFlag",ChildrenList.%Get(i).%Get("PassFlag"))  							//同步标记
        d BloodInfoDict.%Set("ProjectName",ChildrenList.%Get(i).%Get("BloodTransClass"))			//项目名称
       	d BloodInfoC.%Push(BloodInfoDict)
        d BloodInfo.%Set("children",BloodInfoC)
        d children.%Push(BloodInfo)
   	}
   	d BloodJson.%Set("children",children)
   	s config=##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020061601")
   	s RationalResult=##Class(web.CDSS.MachineLearning.DataVerification).DataRationalisation(BloodJson.%ToJSON())  //对第三方数据json串进行数据合理性校验，包括（数据类型是否匹配，主键是否存在等）
   	s RationalResult=[].%FromJSON(RationalResult)
   	s UnifomResult=##Class(web.CDSS.MachineLearning.DataVerification).DataConsistency(BloodJson.%ToJSON())  //对第三方数据json串进行基本信息、就诊信息数据一致性和临床信息完整性校验
   	s UnifomResult=[].%FromJSON(UnifomResult)
   	if (RationalResult.%Size()=0)&(UnifomResult.%Size()=0)  //如果没有错误信息
   	{
        return BloodJson.%ToJSON()       
   	}
   	elseif(config="Y")  //有错误信息，但是允许强制交互
   	{
        return BloodJson.%ToJSON()
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

/// Creator:陈代雷
/// CreatDate:2020-06-09
/// Description:同步医嘱信息
/// Table:
/// Input: CaseInfo : {"IDNO": "患者主索引", "PatientDR": "病人标识", "VisitID": "就诊次", "Name": "患者姓名", "UserID": "医生ID", "UserName": "医生姓名", "DeptCode": "科室编码", "DeptName": "科室名称", "PatientInfo": {"Gender": "性别", "BirthDate": "出生日期", "PregnancyStatus": "妊娠状态"}, "OrderEntry": {"OrderID": "医嘱唯一标识", "OrderClass": "医嘱类型", "OrderFlag": "医嘱 操作标识", "OrderType": "医嘱分类", "CreatTime": "医嘱创建时间", "StopTime": "医嘱作废时间", "DoctorId": "医生唯一标识", "DoctorName": "医生姓名", "CreateDeptCode": "开立科室代码", "CreateDeptName": "开立科室名称", "GroupSequence": "医嘱组顺序", "OrderCode": "医嘱代码", "OrderContent": "医嘱内容", "Dosage": "给药剂量", "Unit": "剂量单位", "Frequency": "频率", "Specification": "规格", "Pathway": "给药方式", "Sample": "样本", "Position": "部位", "Level": "手术等级", "IncisionType": "切口类型", "Anesthesia": "麻醉方式", "PreoperativeDiagnose": "术前诊断"}}
/// Return:
/// Others:w ##class(web.CDSS.MachineLearning.InteractiveInterface).NewSynchronizeOrder(json)
ClassMethod NewSynchronizeOrder(OrderInfo As %String) As %String
{
	Ts
	s OrderInfo=$REPLACE(OrderInfo,":""}",":""""}")
	s OrderInfo=$REPLACE(OrderInfo,":"",",":"""",")
	s OrderWarnList={}
	s StopWarn=[]
	s PopWarn=[]
	if (OrderInfo="")
	{
		tro
		d OrderWarnList.%Set("BlockWarn",StopWarn)
	    d OrderWarnList.%Set("PopWarn",PopWarn)
	    q OrderWarnList.%ToJSON()
	}
    s info=[].%FromJSON(OrderInfo)
    s OrderJson={}
    d OrderJson.%Set("IDNO",info.%Get("IDNO"))
    d OrderJson.%Set("PatientDR",info.%Get("PatientDR"))
    d OrderJson.%Set("VisitID",info.%Get("VisitID"))
    d OrderJson.%Set("VisitType",..ConvertVisitType(info.%Get("VisitType")))
    d OrderJson.%Set("UserID",info.%Get("UserID"))
    d OrderJson.%Set("UserName",info.%Get("UserName"))
    d OrderJson.%Set("CTLocID",info.%Get("DeptCode"))
    d OrderJson.%Set("CTLocDesc",info.%Get("DeptName"))
    s PatientUserInfo=info.%Get("IDNO")_"^"_info.%Get("PatientDR")_"^"_$tr(info.%Get("VisitID"),0)_"^"_..ConvertVisitType(info.%Get("VisitType"))_"^"_info.%Get("UserID")_"^"_info.%Get("UserName")_"^"_info.%Get("DeptCode")_"^"_info.%Get("DeptName")
    //判断是否有改患者 没有该患者 则存基础信息表
    b ;1
    if ('$d(^WDT.CDSS.PatientMasterI("PatDRIndex",info.%Get("PatientDR"))))
    {
	    ///基础信息表
	    s OneOrderJson=OrderJson
	    s children=[] 
	    s PatientMaster={}  //基础信息字典
	    d PatientMaster.%Set("DataClass","PatientMaster")
	    s PatientMasterC=[]  ////基础信息详细内容
	    s PatientMasterDict={}  //单个基础信息详细内容
	    d PatientMasterDict.%Set("MedicareCardNum",info.%Get("IDNO")) //病人标识 //医保卡号
	    d PatientMasterDict.%Set("IDCardNumber",info.%Get("IDNO")) //病人标识, //身份证号
	    d PatientMasterDict.%Set("Name",info.%Get("Name"))   //姓名
	    d PatientMasterDict.%Set("Sex",..ConvertSex(info.%Get("PatientInfo").%Get("Gender")))  //性别（性别病史）
	    if (##class(%Library.TimeStamp).IsValid(info.%Get("PatientInfo").%Get("BirthDate")))
	    {
	    	s Age=##class(web.CDSS.MachineLearning.InteractiveInterface).CurrentAge($zdh(info.%Get("PatientInfo").%Get("BirthDate"),3))
	    }
	    else
	    {
		    s Age=""
	    }
	    //s Age=($h-$zdh(info.%Get("PatientInfo").%Get("BirthDate"),3))/365
	    d PatientMasterDict.%Set("Age",Age) //年龄
	    d PatientMasterDict.%Set("Profession","") //职业（职业病史）
	    d PatientMasterDict.%Set("Nation","") //民族
	    d PatientMasterDict.%Set("Marriage","") //婚姻
	    d PatientMasterDict.%Set("BloodGroup","") //血型
	    d PatientMasterDict.%Set("Country","") //国籍
	    d PatientMasterDict.%Set("Birthplace","") //籍贯
	    d PatientMasterDict.%Set("CurrentAddress","") //现住址
	    d PatientMasterDict.%Set("PhoneNumber","") //电话
	    d PatientMasterDict.%Set("Birthday",info.%Get("PatientInfo").%Get("BirthDate"))  //出生日期
	    d PatientMasterC.%Push(PatientMasterDict)
	    d PatientMaster.%Set("children",PatientMasterC)
	    d children.%Push(PatientMaster)
	    d OneOrderJson.%Set("children",children)
        try{
	        d ##class(web.CDSS.MachineLearning.ParseMode).ParsePatientModel(OneOrderJson.%ToJSON())
	    }catch e{
		}
	}
   
    //d OrderJson.%Set("Birthday",info.%Get("PatientInfo").%Get("BirthDate"))  //出生日期
    //d OrderJson.%Set("PregnancyStatus",info.%Get("PatientInfo").%Get("PregnancyStatus"))  //妊娠状态
    ///医嘱相关信息
    s OrderInfo={}  //医嘱信息
    d OrderInfo.%Set("DataClass","PatientVisit")
    s OrderInfoC=[]  //病例信息详细内容
    s AllOrderEntry=info.%Get("OrderEntry")  //医嘱信息列表，医院数据
    for i=0:1:(AllOrderEntry.%Size()-1)
    {
	    //b ;;
        s OrderEntry=AllOrderEntry.%Get(i)
        s OrderInfoDict={}  //单个基础信息详细内容
        s OrderType=OrderEntry.%Get("OrderType")  //医嘱分类
        s OrderClass=OrderEntry.%Get("OrderClass")  //医嘱类型
        s OrderFlag=OrderEntry.%Get("OrderFlag")  //医嘱操作标识
        
        if (OrderEntry.%Get("GroupSequence")="")
        {
	        d OrderEntry.%Set("GroupSequence","1")
	    }
        //2021-12-02
        if (OrderType=10)
        {
	       	//检查
	    	if $d(^CT.WDT.CDSS.ContrastDictI("IntDictDescIndex",##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401"),"检查检验",OrderEntry.%Get("OrderContent")))
	    	{
		    	//s OrderType=2
		    	//适用于2.0字典对照
				s OrderContrastID=$o(^CT.WDT.CDSS.ContrastDictI("IntDictDescIndex",##class(web.DHCBL.MKB.MKBConfig).GetConfigValue("CDSScdl2020072401"),"检查检验",OrderEntry.%Get("OrderContent"),0))
				s ConId=$lg($g(^CT.WDT.CDSS.ContrastDictD(OrderContrastID)),11)		//对接方字典DR
				s:ConId'="" Type=$lg($g(^CT.WDT.CDSS.ConExamDictD(ConId)),4)
				if Type="检查"
				{
				    s OrderType=2
				}
				else //检验项目/检验医嘱
				{
				    s OrderType=3
				} 	
	    	}
			//药品
			elseif $d(^CT.WDT.CDSS.ContrastDictI("IntDictDescIndex",##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401"),"药品",OrderEntry.%Get("OrderContent")))
			{
				s OrderType=1	
			}
			//护理
			elseif $d(^CT.WDT.CDSS.ContrastDictI("IntDictDescIndex",##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401"),"护理",OrderEntry.%Get("OrderContent")))
			{
				s OrderType=5	
			}
			//手术
			elseif $d(^CT.WDT.CDSS.ContrastDictI("IntDictDescIndex",##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401"),"手术",OrderEntry.%Get("OrderContent")))
        	{
	        	s OrderType=4	
	        }
	    }
        ///处方信息（药品）
        if (OrderType=1)
        {
	        s OneOrderJson=OrderJson
	    	s children=[] 
            s DrugInfo={}  //药品信息
            d DrugInfo.%Set("DataClass","DrugInfo")
            s DrugInfoC=[]  //详细内容
            s DrugInfoDict={}  //单个详细内容
            if (OrderEntry.%IsDefined("PriorType"))
            {
	            d DrugInfoDict.%Set("Type",OrderEntry.%Get("PriorType")) //类型(长期、临时（皮试）)
	        }
            else
            {
	            d DrugInfoDict.%Set("Type","Short") //类型(长期、临时（皮试）)
	        }
            d DrugInfoDict.%Set("GroupFlag",OrderEntry.%Get("OrderID")) //医嘱单号
            d DrugInfoDict.%Set("GroupSequence",OrderEntry.%Get("GroupSequence")) //组顺序
            d DrugInfoDict.%Set("DrugCode",OrderEntry.%Get("OrderCode")) //药品编码
            d DrugInfoDict.%Set("DrugName",##class(web.CDSS.IMP.ContrastDict).GetDiectName(OrderEntry.%Get("OrderContent"),##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401"),"药品字典")) //药品名称
            d DrugInfoDict.%Set("Usage",OrderEntry.%Get("Pathway")) //用法
            d DrugInfoDict.%Set("Dose",OrderEntry.%Get("Dosage")) //剂量
            d DrugInfoDict.%Set("Frequency",OrderEntry.%Get("Frequency")) //频率
            d DrugInfoDict.%Set("Unit",OrderEntry.%Get("Unit")) //单位
            d DrugInfoDict.%Set("Specification",OrderEntry.%Get("Specification")) //规格
            d DrugInfoDict.%Set("StartTime",OrderEntry.%Get("CreatTime")) //开始时间
            d DrugInfoDict.%Set("StopTime",OrderEntry.%Get("StopTime")) //停止时间
            d DrugInfoDict.%Set("Remarks","") //备注
            d DrugInfoDict.%Set("ProjectName",OrderEntry.%Get("OrderContent")) //20211209
            d DrugInfoC.%Push(DrugInfoDict)
            d DrugInfo.%Set("children",DrugInfoC)
            d children.%Push(DrugInfo)
            d OneOrderJson.%Set("children",children)
            //判断该医嘱是否触发规则
            s WarnInfo=##class(web.CDSS.WarnDecision.SingleOrderWarning).GetOrderWarningByRule(PatientUserInfo,OrderEntry.%Get("OrderContent"),OrderType)
	        if WarnInfo'="[]"
	        {
		        s OneWarn={}
		        s WarnInfo=[].%FromJSON(WarnInfo)
		        s ControlMode = WarnInfo.%Get(0).%Get("ControlMode")
		        if (ControlMode="阻断开立")
		        {
			        d OneWarn.%Set("WarningSource",OrderEntry.%Get("OrderContent"))
			        d OneWarn.%Set("WarningTip",WarnInfo.%Get(0).%Get("WarningTip"))
			        d StopWarn.%Push(OneWarn)
			    }
			    if (ControlMode="弹窗提醒")
		        {
			        d OneWarn.%Set("WarningSource",OrderEntry.%Get("OrderContent"))
			        d OneWarn.%Set("WarningTip",WarnInfo.%Get(0).%Get("WarningTip"))
			        d PopWarn.%Push(OneWarn)
			    }
		    }
	        try{
		        d ##class(web.CDSS.MachineLearning.ParseMode).ParsePatientModel(OneOrderJson.%ToJSON())
		    }catch e{
			}
        }
        ///检查
        elseif (OrderType=2)
        {
	        s OneOrderJson=OrderJson
	    	s children=[] 
            s ExamInfo={}  //检查信息
            d ExamInfo.%Set("DataClass","ExamInfo")
            s ExamInfoC=[]  //详细内容
            s ExamInfoDict={}  //单个详细内容
            d ExamInfoDict.%Set("GroupFlag",OrderEntry.%Get("OrderID")) //医嘱单号
            d ExamInfoDict.%Set("GroupSequence",OrderEntry.%Get("GroupSequence")) //组顺序
            d ExamInfoDict.%Set("ExamCode",OrderEntry.%Get("OrderCode")) //检查编码
            d ExamInfoDict.%Set("ExamName",##class(web.CDSS.IMP.ContrastDict).GetDiectName(OrderEntry.%Get("OrderContent"),##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401"),"检查项目字典")) //检查名称
            d ExamInfoDict.%Set("ExamResultNum","") //检查结果顺序号
            d ExamInfoDict.%Set("ExamResult","") //检查结果
            d ExamInfoDict.%Set("ExamResultFlag","") //检查结果指标（阴性或阳性）
            d ExamInfoDict.%Set("ExamResultDesc","") //检查结果概述
            d ExamInfoDict.%Set("PartDR",OrderEntry.%Get("Position")) //部位（改成指针）
            d ExamInfoDict.%Set("ExecuteTime","") //执行时间
            d ExamInfoDict.%Set("ReportTime","") //报告时间
            d ExamInfoDict.%Set("Remarks","") //备注
            d ExamInfoDict.%Set("ProjectName",OrderEntry.%Get("OrderContent")) //20211209
            d ExamInfoC.%Push(ExamInfoDict)
            d ExamInfo.%Set("children",ExamInfoC)
            d children.%Push(ExamInfo)
            d OneOrderJson.%Set("children",children)
            //判断该医嘱是否触发规则
            s WarnInfo=##class(web.CDSS.WarnDecision.SingleOrderWarning).GetOrderWarningByRule(PatientUserInfo,OrderEntry.%Get("OrderContent"),OrderType)
	        if WarnInfo'="[]"
	        {
		        s OneWarn={}
		        s WarnInfo=[].%FromJSON(WarnInfo)
		        s ControlMode = WarnInfo.%Get(0).%Get("ControlMode")
		        if (ControlMode="阻断开立")
		        {
			        d OneWarn.%Set("WarningSource",OrderEntry.%Get("OrderContent"))
			        d OneWarn.%Set("WarningTip",WarnInfo.%Get(0).%Get("WarningTip"))
			        d StopWarn.%Push(OneWarn)
			    }
			    if (ControlMode="弹窗提醒")
		        {
			        d OneWarn.%Set("WarningSource",OrderEntry.%Get("OrderContent"))
			        d OneWarn.%Set("WarningTip",WarnInfo.%Get(0).%Get("WarningTip"))
			        d PopWarn.%Push(OneWarn)
			    }
		    }
	        try{
		        d ##class(web.CDSS.MachineLearning.ParseMode).ParsePatientModel(OneOrderJson.%ToJSON())
		    }catch e{
			}
        }
        ///检验
        elseif (OrderType=3)
        {
	        s OneOrderJson=OrderJson
	    	s children=[] 
            s LabInfo={}  //检查信息
            d LabInfo.%Set("DataClass","LabInfo")
            s LabInfoC=[]  //详细内容
            s LabInfoDict={}  //单个详细内容
            d LabInfoDict.%Set("GroupFlag",OrderEntry.%Get("OrderID")) //医嘱单号
            //d LabInfoDict.%Set("GroupSequence",OrderEntry.%Get("GroupSequence")) //组顺序
            d LabInfoDict.%Set("InspectionCode",OrderEntry.%Get("OrderCode")) //检验大项编码
            d LabInfoDict.%Set("InspectionName",##class(web.CDSS.IMP.ContrastDict).GetDiectName(OrderEntry.%Get("OrderContent"),##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401"),"检验项目字典")) //检验大项名称
            d LabInfoDict.%Set("LabItemCode","") //检验小项编码
            d LabInfoDict.%Set("LabItemName","") //检验小项名称
            d LabInfoDict.%Set("LabResult","") //检验结果
            d LabInfoDict.%Set("LabResultFlag","") //检验结果指标（阴性或阳性）
            d LabInfoDict.%Set("Unit","") //单位
            d LabInfoDict.%Set("Reference","") //参考值
            if (OrderEntry.%Get("Sample")'="")  //如果标本为空，不传避免覆盖检验报告中的标本
            {
                d LabInfoDict.%Set("Specimen",OrderEntry.%Get("Sample"))  //标本
            }
            d LabInfoDict.%Set("ExecuteTime","") //执行时间
            d LabInfoDict.%Set("ReportTime","") //报告时间
            d LabInfoDict.%Set("Remarks","") //备注
            d LabInfoDict.%Set("ProjectName",OrderEntry.%Get("OrderContent")) //20211209
            d LabInfoC.%Push(LabInfoDict)
            d LabInfo.%Set("children",LabInfoC)
            d children.%Push(LabInfo)
            d OneOrderJson.%Set("children",children)
            //判断该医嘱是否触发规则
            s WarnInfo=##class(web.CDSS.WarnDecision.SingleOrderWarning).GetOrderWarningByRule(PatientUserInfo,OrderEntry.%Get("OrderContent"),OrderType)
	        if WarnInfo'="[]"
	        {
		        s OneWarn={}
		        s WarnInfo=[].%FromJSON(WarnInfo)
		        s ControlMode = WarnInfo.%Get(0).%Get("ControlMode")
		        if (ControlMode="阻断开立")
		        {
			        d OneWarn.%Set("WarningSource",OrderEntry.%Get("OrderContent"))
			        d OneWarn.%Set("WarningTip",WarnInfo.%Get(0).%Get("WarningTip"))
			        d StopWarn.%Push(OneWarn)
			    }
			    if (ControlMode="弹窗提醒")
		        {
			        d OneWarn.%Set("WarningSource",OrderEntry.%Get("OrderContent"))
			        d OneWarn.%Set("WarningTip",WarnInfo.%Get(0).%Get("WarningTip"))
			        d PopWarn.%Push(OneWarn)
			    }
		    }
	        try{
		        d ##class(web.CDSS.MachineLearning.ParseMode).ParsePatientModel(OneOrderJson.%ToJSON())
		    }catch e{
			}
        }
        ///手术
        elseif (OrderType=4)
        {
	        s OneOrderJson=OrderJson
	    	s children=[] 
            s OperationInfo={}  //手术信息
            d OperationInfo.%Set("DataClass","OperationInfo")
            s OperationInfoC=[]  //详细内容
            s OperationInfoDict={}  //单个详细内容        
            d OperationInfoDict.%Set("OperNum","") //手术次数
            d OperationInfoDict.%Set("OperSequence","") //手术顺序号
            d OperationInfoDict.%Set("MainOperFlag","") //主手术标记
            d OperationInfoDict.%Set("OperCode",OrderEntry.%Get("OrderCode")) //手术编码
            d OperationInfoDict.%Set("OperName",##class(web.CDSS.IMP.ContrastDict).GetDiectName(OrderEntry.%Get("OrderContent"),##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401"),"手术操作字典")) //手术名称
            d OperationInfoDict.%Set("OperDesc","") //手术描述
            d OperationInfoDict.%Set("OperType",OrderEntry.%Get("Position")) //手术部位
            d OperationInfoDict.%Set("OperPosition","") //手术体位
            d OperationInfoDict.%Set("IntraoperDiagnosis","") //术中诊断
            d OperationInfoDict.%Set("OperDuration","") //手术持续时间
            d OperationInfoDict.%Set("OperStartTime","") //手术开始时间
            d OperationInfoDict.%Set("OperEndTime","") //手术结束时间
            d OperationInfoDict.%Set("ProjectName",OrderEntry.%Get("OrderContent")) //20211209
            d OperationInfoC.%Push(OperationInfoDict)
            d OperationInfo.%Set("children",OperationInfoC)
            d children.%Push(OperationInfo)
            d OneOrderJson.%Set("children",children)
            //判断该医嘱是否触发规则
            s WarnInfo=##class(web.CDSS.WarnDecision.SingleOrderWarning).GetOrderWarningByRule(PatientUserInfo,OrderEntry.%Get("OrderContent"),OrderType)
	        if WarnInfo'="[]"
	        {
		        s OneWarn={}
		        s WarnInfo=[].%FromJSON(WarnInfo)
		        s ControlMode = WarnInfo.%Get(0).%Get("ControlMode")
		        if (ControlMode="阻断开立")
		        {
			        d OneWarn.%Set("WarningSource",OrderEntry.%Get("OrderContent"))
			        d OneWarn.%Set("WarningTip",WarnInfo.%Get(0).%Get("WarningTip"))
			        d StopWarn.%Push(OneWarn)
			    }
			    if (ControlMode="弹窗提醒")
		        {
			        d OneWarn.%Set("WarningSource",OrderEntry.%Get("OrderContent"))
			        d OneWarn.%Set("WarningTip",WarnInfo.%Get(0).%Get("WarningTip"))
			        d PopWarn.%Push(OneWarn)
			    }
		    }
	        try{
		        d ##class(web.CDSS.MachineLearning.ParseMode).ParsePatientModel(OneOrderJson.%ToJSON())
		    }catch e{
			}
        }
        ///麻醉
        elseif (OrderType=9)
        {
	        s OneOrderJson=OrderJson
	    	s children=[] 
            s AnestInfo={}  //麻醉信息
            d AnestInfo.%Set("DataClass","AnestInfo")
            s AnestInfoC=[]  //详细内容
            s AnestInfoDict={}  //单个详细内容        
            d AnestInfoDict.%Set("AnestMedication","") //麻醉用药
            d AnestInfoDict.%Set("Dose","") //剂量
            d AnestInfoDict.%Set("Usage","") //用法
            d AnestInfoDict.%Set("Anesthesia","") //麻醉方式
            d AnestInfoDict.%Set("AnestSite","") //麻醉部位
            d AnestInfoDict.%Set("AnestDuration","") //麻醉持续时长
            d AnestInfoDict.%Set("AnestStartTime","") //麻醉开始时间
            d AnestInfoDict.%Set("ProjectName",OrderEntry.%Get("OrderContent")) //20211209
            d AnestInfoC.%Push(AnestInfoDict)
            d AnestInfo.%Set("children",AnestInfoC)
            d children.%Push(AnestInfo)
            d OneOrderJson.%Set("children",children)
            //判断该医嘱是否触发规则
            s WarnInfo=##class(web.CDSS.WarnDecision.SingleOrderWarning).GetOrderWarningByRule(PatientUserInfo,OrderEntry.%Get("OrderContent"),OrderType)
	        if WarnInfo'="[]"
	        {
		        s OneWarn={}
		        s WarnInfo=[].%FromJSON(WarnInfo)
		        s ControlMode = WarnInfo.%Get(0).%Get("ControlMode")
		        if (ControlMode="阻断开立")
		        {
			        d OneWarn.%Set("WarningSource",OrderEntry.%Get("OrderContent"))
			        d OneWarn.%Set("WarningTip",WarnInfo.%Get(0).%Get("WarningTip"))
			        d StopWarn.%Push(OneWarn)
			    }
			    if (ControlMode="弹窗提醒")
		        {
			        d OneWarn.%Set("WarningSource",OrderEntry.%Get("OrderContent"))
			        d OneWarn.%Set("WarningTip",WarnInfo.%Get(0).%Get("WarningTip"))
			        d PopWarn.%Push(OneWarn)
			    }
		    }
	        try{
		        d ##class(web.CDSS.MachineLearning.ParseMode).ParsePatientModel(OneOrderJson.%ToJSON())
		    }catch e{
			}
        }
        ///护理
        elseif (OrderType=5)
        {
	        s OneOrderJson=OrderJson
	   	 	s children=[] 
            s NursingInfo={}  //护理信息
            d NursingInfo.%Set("DataClass","NursingInfo")
            s NursingInfoC=[]  //详细内容
            s NursingInfoDict={}  //单个详细内容
            d NursingInfoDict.%Set("NursingItemNum","") //护理项目顺序号
            d NursingInfoDict.%Set("NursingItemCode",OrderEntry.%Get("OrderCode")) //护理项目编码
            d NursingInfoDict.%Set("NursingItemName",##class(web.CDSS.IMP.ContrastDict).GetDiectName(OrderEntry.%Get("OrderContent"),##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401"),"护理医嘱字典")) //护理项目名称
            d NursingInfoDict.%Set("ChildItemNum","") //护理小项顺序号
            d NursingInfoDict.%Set("ChildItemCode","") //护理小项编码
            d NursingInfoDict.%Set("ChildItemName","") //护理小项名称
            d NursingInfoDict.%Set("NursingEffect","") //护理效果
            d NursingInfoDict.%Set("ProjectName",OrderEntry.%Get("OrderContent")) //20211209
            d NursingInfoC.%Push(NursingInfoDict)
            d NursingInfo.%Set("children",NursingInfoC)
            d children.%Push(NursingInfo)
            d OneOrderJson.%Set("children",children)
            //判断该医嘱是否触发规则
            s WarnInfo=##class(web.CDSS.WarnDecision.SingleOrderWarning).GetOrderWarningByRule(PatientUserInfo,OrderEntry.%Get("OrderContent"),OrderType)
	        if WarnInfo'="[]"
	        {
		        s OneWarn={}
		        s WarnInfo=[].%FromJSON(WarnInfo)
		        s ControlMode = WarnInfo.%Get(0).%Get("ControlMode")
		        if (ControlMode="阻断开立")
		        {
			        d OneWarn.%Set("WarningSource",OrderEntry.%Get("OrderContent"))
			        d OneWarn.%Set("WarningTip",WarnInfo.%Get(0).%Get("WarningTip"))
			        d StopWarn.%Push(OneWarn)
			    }
			    if (ControlMode="弹窗提醒")
		        {
			        d OneWarn.%Set("WarningSource",OrderEntry.%Get("OrderContent"))
			        d OneWarn.%Set("WarningTip",WarnInfo.%Get(0).%Get("WarningTip"))
			        d PopWarn.%Push(OneWarn)
			    }
		    }
	        try{
		        d ##class(web.CDSS.MachineLearning.ParseMode).ParsePatientModel(OneOrderJson.%ToJSON())
		    }catch e{
			}
        }
        ///饮食
        elseif (OrderType=7)
        {
	        s OneOrderJson=OrderJson
	    	s children=[] 
            s DietInfo={}  //饮食信息
            d DietInfo.%Set("DataClass","DietInfo")
            s DietInfoC=[]  //详细内容
            s DietInfoDict={}  //单个详细内容
            d DietInfoDict.%Set("GroupFlag",OrderEntry.%Get("OrderID")) //医嘱单号
            d DietInfoDict.%Set("GroupSequence",OrderEntry.%Get("GroupSequence")) //组顺序
            d DietInfoDict.%Set("DietMethod","") //饮食方式
            d DietInfoDict.%Set("DietType","") //饮食类型
            d DietInfoDict.%Set("DietContent",OrderEntry.%Get("OrderContent")) //饮食内容
            d DietInfoDict.%Set("DietAmount","") //饮食量
            d DietInfoDict.%Set("DietInstructions","") //饮食说明
            d DietInfoDict.%Set("Duration","") //持续时长
            d DietInfoDict.%Set("StartTime","") //开始时间
            d DietInfoDict.%Set("EndTime","") //结束时间
            d DietInfoDict.%Set("ProjectName",OrderEntry.%Get("OrderContent")) //20211209
            d DietInfoC.%Push(DietInfoDict)
            d DietInfo.%Set("children",DietInfoC)
            d children.%Push(DietInfo)
            d OneOrderJson.%Set("children",children)
            //判断该医嘱是否触发规则
            s WarnInfo=##class(web.CDSS.WarnDecision.SingleOrderWarning).GetOrderWarningByRule(PatientUserInfo,OrderEntry.%Get("OrderContent"),OrderType)
	        if WarnInfo'="[]"
	        {
		        s OneWarn={}
		        s WarnInfo=[].%FromJSON(WarnInfo)
		        s ControlMode = WarnInfo.%Get(0).%Get("ControlMode")
		        if (ControlMode="阻断开立")
		        {
			        d OneWarn.%Set("WarningSource",OrderEntry.%Get("OrderContent"))
			        d OneWarn.%Set("WarningTip",WarnInfo.%Get(0).%Get("WarningTip"))
			        d StopWarn.%Push(OneWarn)
			    }
			    if (ControlMode="弹窗提醒")
		        {
			        d OneWarn.%Set("WarningSource",OrderEntry.%Get("OrderContent"))
			        d OneWarn.%Set("WarningTip",WarnInfo.%Get(0).%Get("WarningTip"))
			        d PopWarn.%Push(OneWarn)
			    }
		    }
	        try{
		        d ##class(web.CDSS.MachineLearning.ParseMode).ParsePatientModel(OneOrderJson.%ToJSON())
		    }catch e{
			}
        }
        ///出院带药
        elseif (OrderType=1)&(OrderClass=4)
        {
            s OneOrderJson=OrderJson
	    	s children=[] 
            s DrugInfo={}  //出院带药信息
            d DrugInfo.%Set("DataClass","CarryDrug")
            s DrugInfoC=[]  //详细内容
            s DrugInfoDict={}  //单个详细内容
            d DrugInfoDict.%Set("GroupFlag",OrderEntry.%Get("OrderID")) //医嘱单号
            d DrugInfoDict.%Set("GroupSequence",OrderEntry.%Get("GroupSequence")) //组顺序
            d DrugInfoDict.%Set("DrugCode",OrderEntry.%Get("OrderCode")) //药品编码
            d DrugInfoDict.%Set("DrugName",##class(web.CDSS.IMP.ContrastDict).GetDiectName(OrderEntry.%Get("OrderContent"),##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401"),"药品字典")) //药品名称
            d DrugInfoDict.%Set("Usage",OrderEntry.%Get("Pathway")) //用法
            d DrugInfoDict.%Set("Dose",OrderEntry.%Get("Dosage")) //剂量
            d DrugInfoDict.%Set("Frequency",OrderEntry.%Get("Frequency")) //频率
            d DrugInfoDict.%Set("Unit",OrderEntry.%Get("Unit")) //单位
            d DrugInfoDict.%Set("Specification",OrderEntry.%Get("Specification")) //规格
            d DrugInfoDict.%Set("StartTime","") //开始时间
            d DrugInfoDict.%Set("StopTime","") //停止时间
            d DrugInfoDict.%Set("Remarks","") //备注
            d DrugInfoC.%Push(DrugInfoDict)
            d DrugInfo.%Set("children",DrugInfoC)
            d children.%Push(DrugInfo)
            d OneOrderJson.%Set("children",children)
            //判断该医嘱是否触发规则
            s WarnInfo=##class(web.CDSS.WarnDecision.SingleOrderWarning).GetOrderWarningByRule(PatientUserInfo,OrderEntry.%Get("OrderContent"),OrderType)
	        if WarnInfo'="[]"
	        {
		        s OneWarn={}
		        s WarnInfo=[].%FromJSON(WarnInfo)
		        s ControlMode = WarnInfo.%Get(0).%Get("ControlMode")
		        if (ControlMode="阻断开立")
		        {
			        d OneWarn.%Set("WarningSource",OrderEntry.%Get("OrderContent"))
			        d OneWarn.%Set("WarningTip",WarnInfo.%Get(0).%Get("WarningTip"))
			        d StopWarn.%Push(OneWarn)
			    }
			    if (ControlMode="弹窗提醒")
		        {
			        d OneWarn.%Set("WarningSource",OrderEntry.%Get("OrderContent"))
			        d OneWarn.%Set("WarningTip",WarnInfo.%Get(0).%Get("WarningTip"))
			        d PopWarn.%Push(OneWarn)
			    }
		    }
	        try{
		        d ##class(web.CDSS.MachineLearning.ParseMode).ParsePatientModel(OneOrderJson.%ToJSON())
		    }catch e{
			}
        }
        elseif (OrderClass=4)  //其他出院医嘱信息
        {
	        s OneOrderJson=OrderJson
	    	s children=[] 
            s OtherDisOrderInfo={}  //其他出院医嘱信息
            d OtherDisOrderInfo.%Set("DataClass","OtherDisOrderInfo")
            s OtherDisOrderInfoC=[]  //详细内容
            s OtherDisOrderInfoDict={}  //单个详细内容
            d OtherDisOrderInfoDict.%Set("GroupFlag",OrderEntry.%Get("OrderID")) //医嘱单号
            d OtherDisOrderInfoDict.%Set("GroupSequence",OrderEntry.%Get("GroupSequence")) //组顺序
            d OtherDisOrderInfoDict.%Set("OrderDesc","") //医嘱描述
            d OtherDisOrderInfoDict.%Set("ExecuteMethod","") //执行方式
            d OtherDisOrderInfoDict.%Set("PlanStartTime","") //计划开始时间
            d OtherDisOrderInfoDict.%Set("PlanStopTime","") //计划停止时间
            d OtherDisOrderInfoDict.%Set("ExecuteDesc","") //执行说明
            d OtherDisOrderInfoC.%Push(OtherDisOrderInfoDict)
            d OtherDisOrderInfo.%Set("children",OtherDisOrderInfoC)
            d children.%Push(OtherDisOrderInfo)
            d OneOrderJson.%Set("children",children)
            //判断该医嘱是否触发规则
            s WarnInfo=##class(web.CDSS.WarnDecision.SingleOrderWarning).GetOrderWarningByRule(PatientUserInfo,OrderEntry.%Get("OrderContent"),OrderType)
	        if WarnInfo'="[]"
	        {
		        s OneWarn={}
		        s WarnInfo=[].%FromJSON(WarnInfo)
		        s ControlMode = WarnInfo.%Get(0).%Get("ControlMode")
		        if (ControlMode="阻断开立")
		        {
			        d OneWarn.%Set("WarningSource",OrderEntry.%Get("OrderContent"))
			        d OneWarn.%Set("WarningTip",WarnInfo.%Get(0).%Get("WarningTip"))
			        d StopWarn.%Push(OneWarn)
			    }
			    if (ControlMode="弹窗提醒")
		        {
			        d OneWarn.%Set("WarningSource",OrderEntry.%Get("OrderContent"))
			        d OneWarn.%Set("WarningTip",WarnInfo.%Get(0).%Get("WarningTip"))
			        d PopWarn.%Push(OneWarn)
			    }
		    }
	        try{
		        d ##class(web.CDSS.MachineLearning.ParseMode).ParsePatientModel(OneOrderJson.%ToJSON())
		    }catch e{
			}
        }
        elseif (OrderClass=1)  //其他在院医嘱信息
        {
	        s OneOrderJson=OrderJson
	    	s children=[] 
            s OtherOrderInfo={}  //其他在院医嘱信息
            d OtherOrderInfo.%Set("DataClass","OtherOrderInfo")
            s OtherOrderInfoC=[]  //详细内容
            s OtherOrderInfoDict={}  //单个详细内容
            d OtherOrderInfoDict.%Set("GroupFlag",OrderEntry.%Get("OrderID")) //医嘱单号
            d OtherOrderInfoDict.%Set("GroupSequence",OrderEntry.%Get("GroupSequence")) //组顺序
            d OtherOrderInfoDict.%Set("OrderDesc","") //医嘱描述
            d OtherOrderInfoDict.%Set("ExecuteTime","") //执行时间
            d OtherOrderInfoDict.%Set("ExecuteResult","") //执行结果
            d OtherOrderInfoC.%Push(OtherOrderInfoDict)
            d OtherOrderInfo.%Set("children",OtherOrderInfoC)
            d children.%Push(OtherOrderInfo)
            d OneOrderJson.%Set("children",children)
            //判断该医嘱是否触发规则
            s WarnInfo=##class(web.CDSS.WarnDecision.SingleOrderWarning).GetOrderWarningByRule(PatientUserInfo,OrderEntry.%Get("OrderContent"),OrderType)
	        if WarnInfo'="[]"
	        {
		        s OneWarn={}
		        s WarnInfo=[].%FromJSON(WarnInfo)
		        s ControlMode = WarnInfo.%Get(0).%Get("ControlMode")
		        if (ControlMode="阻断开立")
		        {
			        d OneWarn.%Set("WarningSource",OrderEntry.%Get("OrderContent"))
			        d OneWarn.%Set("WarningTip",WarnInfo.%Get(0).%Get("WarningTip"))
			        d StopWarn.%Push(OneWarn)
			    }
			    if (ControlMode="弹窗提醒")
		        {
			        d OneWarn.%Set("WarningSource",OrderEntry.%Get("OrderContent"))
			        d OneWarn.%Set("WarningTip",WarnInfo.%Get(0).%Get("WarningTip"))
			        d PopWarn.%Push(OneWarn)
			    }
		    }
	        try{
		        d ##class(web.CDSS.MachineLearning.ParseMode).ParsePatientModel(OneOrderJson.%ToJSON())
		    }catch e{
			}
        }
    } 
    if (StopWarn.%Size()=0)&&(PopWarn.%Size()=0)  //如果没有错误信息
    {
        Tro      
    }
    elseif((StopWarn.%Size()=0)&&(PopWarn.%Size()'=0))  //有错误信息，但是允许强制交互
    {
        Tro
    }
    else 
    {
        Tro
    }
    d OrderWarnList.%Set("BlockWarn",StopWarn)
    d OrderWarnList.%Set("PopWarn",PopWarn)
    q OrderWarnList.%ToJSON()
}

/// Creator:陈代雷
/// CreatDate:2020-06-05
/// Description:同步诊断数据
/// Table:
/// Input: DiagInfo : 患者基本信息 {"IDNO": "患者主索引", "PatientDR": "病人标识", "VisitID": "就诊次", "Name": "患者姓名", "UserID": "医生ID", "UserName": "医生姓名", "DeptCode": "科室编码", "DeptName": "科室名称", "PatientInfo": {"Gender": "性别", "BirthDate": "出生日期", "PregnancyStatus": "妊娠状态"}, "DiagnosisList": [{"DiagnosisId": "诊断ID", "DiagnosisCode": "诊断编码", "DiagnosisName": "诊断名称", "DiagnosisType": "诊断类型", "DiagnosisDoctorType": "诊断分类", "IsMainDiagnosis": "是否主诊断", "DiagnosisSequence": "诊断顺序", "RecordTime": "开立时间", "DiagnosisDoctorId": "开立医生ID", "DiagnosisDoctorName": "开立医生名称"}]}
/// Return:标准版诊断信息
/// Others:w ##class(web.CDSS.MachineLearning.InteractiveInterface).NewSynchronousDiagInfo(json)
ClassMethod NewSynchronousDiagInfo(DiagInfo As %String) As %String
{
	Ts
	s OrderWarnList={}
	s StopWarn=[]
	s PopWarn=[]
	s DiagInfo=$REPLACE(DiagInfo,":""}",":""""}")
	s DiagInfo=$REPLACE(DiagInfo,":"",",":"""",")
    s info=[].%FromJSON(DiagInfo)
    s DiagJson={}
    d DiagJson.%Set("IDNO",info.%Get("IDNO"))
    d DiagJson.%Set("PatientDR",info.%Get("PatientDR"))
    d DiagJson.%Set("VisitID",info.%Get("VisitID"))
    d DiagJson.%Set("VisitType",..ConvertVisitType(info.%Get("VisitType")))
    d DiagJson.%Set("UserID",info.%Get("UserID"))
    d DiagJson.%Set("UserName",info.%Get("UserName"))
    d DiagJson.%Set("CTLocID",info.%Get("DeptCode"))
    d DiagJson.%Set("CTLocDesc",info.%Get("DeptName"))
    s PatientUserInfo=info.%Get("IDNO")_"^"_info.%Get("PatientDR")_"^"_$tr(info.%Get("VisitID"),0)_"^"_..ConvertVisitType(info.%Get("VisitType"))_"^"_info.%Get("UserID")_"^"_info.%Get("UserName")_"^"_info.%Get("DeptCode")_"^"_info.%Get("DeptName")
    ///基础信息表
    if ('$d(^WDT.CDSS.PatientMasterI("PatDRIndex",info.%Get("PatientDR"))))
    {
	    ///基础信息表
	    s OneOrderJson=DiagJson
	    s children=[] 
	    s PatientMaster={}  //基础信息字典
	    d PatientMaster.%Set("DataClass","PatientMaster")
	    s PatientMasterC=[]  ////基础信息详细内容
	    s PatientMasterDict={}  //单个基础信息详细内容
	    d PatientMasterDict.%Set("MedicareCardNum",info.%Get("IDNO")) //病人标识 //医保卡号
	    d PatientMasterDict.%Set("IDCardNumber",info.%Get("IDNO")) //病人标识, //身份证号
	    d PatientMasterDict.%Set("Name",info.%Get("Name"))   //姓名
	    d PatientMasterDict.%Set("Sex",..ConvertSex(info.%Get("PatientInfo").%Get("Gender")))  //性别（性别病史）
	    if (##class(%Library.TimeStamp).IsValid(info.%Get("PatientInfo").%Get("BirthDate")))
	    {
	    	s Age=##class(web.CDSS.MachineLearning.InteractiveInterface).CurrentAge($zdh(info.%Get("PatientInfo").%Get("BirthDate"),3))
	    }
	    else
	    {
		    s Age=""
	    }
	    //s Age=($h-$zdh(info.%Get("PatientInfo").%Get("BirthDate"),3))/365
	    d PatientMasterDict.%Set("Age",Age) //年龄
	    d PatientMasterDict.%Set("Profession","") //职业（职业病史）
	    d PatientMasterDict.%Set("Nation","") //民族
	    d PatientMasterDict.%Set("Marriage","") //婚姻
	    d PatientMasterDict.%Set("BloodGroup","") //血型
	    d PatientMasterDict.%Set("Country","") //国籍
	    d PatientMasterDict.%Set("Birthplace","") //籍贯
	    d PatientMasterDict.%Set("CurrentAddress","") //现住址
	    d PatientMasterDict.%Set("PhoneNumber","") //电话
	    d PatientMasterDict.%Set("Birthday",info.%Get("PatientInfo").%Get("BirthDate"))  //出生日期
	    d PatientMasterC.%Push(PatientMasterDict)
	    d PatientMaster.%Set("children",PatientMasterC)
	    d children.%Push(PatientMaster)
	    d OneOrderJson.%Set("children",children)
        try{
	        d ##class(web.CDSS.MachineLearning.ParseMode).ParsePatientModel(OneOrderJson.%ToJSON())
	    }catch e{
		}
	}
    s DiagnosisList=info.%Get("DiagnosisList")  //诊断信息列表
    for i=0:1:(DiagnosisList.%Size()-1)
    {
	    continue:DiagnosisList.%Get(i).%Get("DiagnosisName")=""
        s OneOrderJson=DiagJson
    	s children=[] 
        s DiagnosisInfo={}  //诊断信息
        d DiagnosisInfo.%Set("DataClass","DiagnosisInfo")
        s DiagnosisInfoC=[]  //基础信息详细内容
        s DiagnosisInfoDict={}  //单个诊断信息详细内容
        d DiagnosisInfoDict.%Set("DiagnosisSequence",DiagnosisList.%Get(i).%Get("DiagnosisSequence"))  //诊断ID
        d DiagnosisInfoDict.%Set("DiagnosisCode",..GetDiagNodeByDiagId(DiagnosisList.%Get(i).%Get("DiagnosisId")))  //诊断编码
        d DiagnosisInfoDict.%Set("DiagnosisName",##class(web.CDSS.IMP.ContrastDict).GetDiectName(DiagnosisList.%Get(i).%Get("DiagnosisName"),##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401"),"诊断字典"))  //诊断名称
        d DiagnosisInfoDict.%Set("DiagnosisType",DiagnosisList.%Get(i).%Get("DiagnosisType"))  //诊断类型
        d DiagnosisInfoDict.%Set("DiagnosisDesc","")  //诊断描述
        d DiagnosisInfoDict.%Set("ChildDiagnosisFlag",/*$CASE(DiagnosisList.%Get(i).%Get("IsMainDiagnosis"),2:1,1:0,:1)*/1)  //子诊断标记，默认否
        d DiagnosisInfoDict.%Set("DiagnosisTime",DiagnosisList.%Get(i).%Get("RecordTime"))  //开立时间
        ;d DiagnosisInfoDict.%Set("DiagnosisStatus","")  //诊断状态
        d DiagnosisInfoDict.%Set("DiagnosisStatus",$CASE(DiagnosisList.%Get(i).%Get("DiagnosisStatus"),0:"确诊",1:"待诊",2:"疑诊","":""))  //诊断状态
        d DiagnosisInfoDict.%Set("ProjectName",DiagnosisList.%Get(i).%Get("DiagnosisName"))
        d DiagnosisInfoC.%Push(DiagnosisInfoDict)
        d DiagnosisInfo.%Set("children",DiagnosisInfoC)
        d children.%Push(DiagnosisInfo)
    	d OneOrderJson.%Set("children",children) 
    	s WarnInfo=##class(web.CDSS.WarnDecision.SingleOrderWarning).GetOrderWarningByRule(PatientUserInfo,DiagnosisList.%Get(i).%Get("DiagnosisName"),"11")
        if WarnInfo'="[]"
        {
	        s OneWarn={}
	        s WarnInfo=[].%FromJSON(WarnInfo)
	        s ControlMode = WarnInfo.%Get(0).%Get("ControlMode")
	        if (ControlMode="阻断开立")
	        {
		        d OneWarn.%Set("WarningSource",DiagnosisList.%Get(i).%Get("DiagnosisName"))
		        d OneWarn.%Set("WarningTip",WarnInfo.%Get(0).%Get("WarningTip"))
		        d StopWarn.%Push(OneWarn)
		    }
		    if (ControlMode="弹窗提醒")
	        {
		        d OneWarn.%Set("WarningSource",DiagnosisList.%Get(i).%Get("DiagnosisName"))
		        d OneWarn.%Set("WarningTip",WarnInfo.%Get(0).%Get("WarningTip"))
		        d PopWarn.%Push(OneWarn)
		    }
	    }
        try{
	        d ##class(web.CDSS.MachineLearning.ParseMode).ParsePatientModel(OneOrderJson.%ToJSON())
	    }catch e{
		}	
    }
    if (StopWarn.%Size()=0)&&(PopWarn.%Size()=0)  //如果没有错误信息
    {
        Tro      
    }
    elseif((StopWarn.%Size()=0)&&(PopWarn.%Size()'=0))  //有错误信息，但是允许强制交互
    {
        Tro
    }
    else 
    {
        Tro
    }
    d OrderWarnList.%Set("BlockWarn",StopWarn)
    d OrderWarnList.%Set("PopWarn",PopWarn)
    q OrderWarnList.%ToJSON()
}

/// Creator:Xuwenhu
/// CreatDate:2022-03-04
/// Description:同步婚育和既往史信息
/// Table:WDT.CDSS.MarryInfo
/// Input:
/// Return:标准版诊断信息
/// Others:w ##class(web.CDSS.MachineLearning.InteractiveInterface).SynchronousMarryInfo(^TMP("XWH"))
ClassMethod SynchronousMarryInfo(json As %String) As %String
{
    s info=[].%FromJSON(json)
    s MarryJson={}
    s IDNO=info.%Get("IDNO")
    s PatientDR=info.%Get("PatientDR")
    s VisitID=info.%Get("VisitID")
    s VisitType=info.%Get("VisitType")
    s MarriageOverview=info.%Get("MarriageOverview")
    s DelID=0
    for
    {
    	s DelID=$o(^WDT.CDSS.MarryInfoI("PatDRIndex",PatientDR,DelID))
    	q:DelID=""
    	d ##class(WDT.CDSS.MarryInfo).%Delete(DelID)
    }
    s DelPastID=0
    for
    {
		s DelPastID=$o(^WDT.CDSS.PastDiagnosisI("PatVisDRTypeIndex",PatientDR,VisitID,VisitType,DelPastID)) 
		q:DelPastID=""
		d ##class(WDT.CDSS.PastDiagnosis).%Delete(DelPastID)   
	}
	for i=1:1:$l(MarriageOverview,",")
	{
		s MarriageOverviews=$p(MarriageOverview,",",i)
		if ((MarriageOverviews="孕妇")||(MarriageOverviews="哺乳期")||(MarriageOverviews="计划妊娠")||(MarriageOverviews="卵泡期")||(MarriageOverviews="排卵期")||(MarriageOverviews="黄体期")||(MarriageOverviews="经期")||(MarriageOverviews="经期")||(MarriageOverviews="绝经期"))
		{
			s obj=##class(WDT.CDSS.MarryInfo).%New()
			if ((MarriageOverviews="孕妇")||(MarriageOverviews="哺乳期")||(MarriageOverviews="计划妊娠"))
			{
				s obj.TypeOfMarriage="生育" 	
			}
			else
			{
				s obj.TypeOfMarriage="月经"
			}
			s obj.IDNO=IDNO
			s obj.PatientDR=PatientDR
			s obj.MarriageOverview=MarriageOverviews
			s obj.StartTime=+$H
			s obj.EndTime=""
			s obj.Duration=""
			s obj.Remarks=""
			s obj.Criticality=""
			s obj.PassFlag=""
			s obj.MRCode=""
			d obj.%Save()
			d obj.%Close()
		}
		else
		{
			s sobj=##class(WDT.CDSS.PastDiagnosis).%New()
			s PastHistoryNum=$o(^WDT.CDSS.PastDiagnosisI("PatVisDRSeqIndex",PatientDR,VisitID,VisitType,""),-1)
			s sobj.IDNO=IDNO
			s sobj.PatientDR=PatientDR
			s sobj.VisitID=VisitID
			s sobj.VisitType=VisitType
			s sobj.PastHistoryNum=PastHistoryNum
			s sobj.PastDiagnosisName=MarriageOverviews
			s sobj.DiagnosisType="检查"
			s sobj.StartTime=+$H
			s sobj.EndTime=""
			s sobj.Duration=""
			s sobj.Remarks=""
			s sobj.TreatmentEffect=""
			s sobj.Criticality=""
			s sobj.PassFlag=""
			s sobj.MRCode=""
			d sobj.%Save()
			d sobj.%Close()	
		}
	}
	q ""
}

/// Creator:陈代雷
/// CreatDate:2020-06-05
/// Description:同步诊断数据
/// Table:
/// Input: DiagInfo : 患者基本信息 {"IDNO": "患者主索引", "PatientDR": "病人标识", "VisitID": "就诊次", "Name": "患者姓名", "UserID": "医生ID", "UserName": "医生姓名", "DeptCode": "科室编码", "DeptName": "科室名称", "PatientInfo": {"Gender": "性别", "BirthDate": "出生日期", "PregnancyStatus": "妊娠状态"}, "DiagnosisList": [{"DiagnosisId": "诊断ID", "DiagnosisCode": "诊断编码", "DiagnosisName": "诊断名称", "DiagnosisType": "诊断类型", "DiagnosisDoctorType": "诊断分类", "IsMainDiagnosis": "是否主诊断", "DiagnosisSequence": "诊断顺序", "RecordTime": "开立时间", "DiagnosisDoctorId": "开立医生ID", "DiagnosisDoctorName": "开立医生名称"}]}
/// Return:标准版诊断信息
/// Others:w ##class(web.CDSS.MachineLearning.InteractiveInterface).SynchronousDiagInfoV2(^TMP("FWKKKK"))
ClassMethod SynchronousDiagInfoV2(DiagInfo As %String) As %String
{
	s ^TMP("FWKKKK")=DiagInfo
	Ts
	//Tro
	//q "test"
	s WarningTipStr=""
	s DiagList=[]
	s OrderWarnList={}
	s StopWarn=[]
	s PopWarn=[]
	s DiagInfo=$REPLACE(DiagInfo,":""}",":""""}")
	s DiagInfo=$REPLACE(DiagInfo,":"",",":"""",")
    s info=[].%FromJSON(DiagInfo)
    s DiagJson={}
    d DiagJson.%Set("IDNO",info.%Get("IDNO"))
    d DiagJson.%Set("PatientDR",info.%Get("PatientDR"))
    d DiagJson.%Set("VisitID",info.%Get("VisitID"))
    d DiagJson.%Set("VisitType",..ConvertVisitType(info.%Get("VisitType")))
    d DiagJson.%Set("UserID",info.%Get("UserID"))
    d DiagJson.%Set("UserName",info.%Get("UserName"))
    d DiagJson.%Set("CTLocID",info.%Get("DeptCode"))
    d DiagJson.%Set("CTLocDesc",info.%Get("DeptName"))
    s PatientUserInfo=info.%Get("IDNO")_"^"_info.%Get("PatientDR")_"^"_info.%Get("VisitID")_"^"_..ConvertVisitType(info.%Get("VisitType"))_"^"_info.%Get("UserID")_"^"_info.%Get("UserName")_"^"_info.%Get("DeptCode")_"^"_info.%Get("DeptName")_"^1"
    ///基础信息表
    if ('$d(^WDT.CDSS.PatientMasterI("PatDRIndex",info.%Get("PatientDR"))))
    {
	    ///基础信息表
	    s OneOrderJson=DiagJson
	    s children=[] 
	    s PatientMaster={}  //基础信息字典
	    d PatientMaster.%Set("DataClass","PatientMaster")
	    s PatientMasterC=[]  ////基础信息详细内容
	    s PatientMasterDict={}  //单个基础信息详细内容
	    d PatientMasterDict.%Set("MedicareCardNum",info.%Get("IDNO")) //病人标识 //医保卡号
	    d PatientMasterDict.%Set("IDCardNumber",info.%Get("IDNO")) //病人标识, //身份证号
	    d PatientMasterDict.%Set("Name",info.%Get("Name"))   //姓名
	    d PatientMasterDict.%Set("Sex",..ConvertSex(info.%Get("PatientInfo").%Get("Gender")))  //性别（性别病史）
	    if (##class(%Library.TimeStamp).IsValid(info.%Get("PatientInfo").%Get("BirthDate")))
	    {
	    	s Age=##class(web.CDSS.MachineLearning.InteractiveInterface).CurrentAge($zdh(info.%Get("PatientInfo").%Get("BirthDate"),3))
	    }
	    else
	    {
		    s Age=""
	    }
	    //s Age=($h-$zdh(info.%Get("PatientInfo").%Get("BirthDate"),3))/365
	    d PatientMasterDict.%Set("Age",Age) //年龄
	    d PatientMasterDict.%Set("Profession","") //职业（职业病史）
	    d PatientMasterDict.%Set("Nation","") //民族
	    d PatientMasterDict.%Set("Marriage","") //婚姻
	    d PatientMasterDict.%Set("BloodGroup","") //血型
	    d PatientMasterDict.%Set("Country","") //国籍
	    d PatientMasterDict.%Set("Birthplace","") //籍贯
	    d PatientMasterDict.%Set("CurrentAddress","") //现住址
	    d PatientMasterDict.%Set("PhoneNumber","") //电话
	    d PatientMasterDict.%Set("Birthday",info.%Get("PatientInfo").%Get("BirthDate"))  //出生日期
	    d PatientMasterC.%Push(PatientMasterDict)
	    d PatientMaster.%Set("children",PatientMasterC)
	    d children.%Push(PatientMaster)
	    d OneOrderJson.%Set("children",children)
        try{
	        d ##class(web.CDSS.MachineLearning.ParseMode).ParsePatientModel(OneOrderJson.%ToJSON())
	    }catch e{
		}
	}
    s DiagnosisList=info.%Get("DiagnosisList")  //诊断信息列表
    for i=0:1:(DiagnosisList.%Size()-1)
    {
	    continue:DiagnosisList.%Get(i).%Get("DiagnosisName")=""
	    d DiagList.%Push(DiagnosisList.%Get(i).%Get("DiagnosisName"))
        s OneOrderJson=DiagJson
    	s children=[] 
        s DiagnosisInfo={}  //诊断信息
        d DiagnosisInfo.%Set("DataClass","DiagnosisInfo")
        s DiagnosisInfoC=[]  //基础信息详细内容
        s DiagnosisInfoDict={}  //单个诊断信息详细内容
        d DiagnosisInfoDict.%Set("DiagnosisSequence",DiagnosisList.%Get(i).%Get("DiagnosisSequence"))  //诊断ID
        d DiagnosisInfoDict.%Set("DiagnosisCode",DiagnosisList.%Get(i).%Get("DiagnosisCode"))  //诊断编码
        d DiagnosisInfoDict.%Set("DiagnosisName",##class(web.CDSS.IMP.ContrastDict).GetDiectName(DiagnosisList.%Get(i).%Get("DiagnosisName"),##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401"),"诊断字典"))  //诊断名称
        d DiagnosisInfoDict.%Set("DiagnosisType",DiagnosisList.%Get(i).%Get("DiagnosisType"))  //诊断类型
        d DiagnosisInfoDict.%Set("DiagnosisDesc","")  //诊断描述
        d DiagnosisInfoDict.%Set("ChildDiagnosisFlag",/*$CASE(DiagnosisList.%Get(i).%Get("IsMainDiagnosis"),2:1,1:0,:1)*/1)  //子诊断标记，默认否
        d DiagnosisInfoDict.%Set("DiagnosisTime",DiagnosisList.%Get(i).%Get("RecordTime"))  //开立时间
        ;d DiagnosisInfoDict.%Set("DiagnosisStatus","")  //诊断状态
        d DiagnosisInfoDict.%Set("DiagnosisStatus",$CASE(DiagnosisList.%Get(i).%Get("DiagnosisStatus"),0:"确诊",1:"待诊",2:"疑诊","":""))  //诊断状态
        d DiagnosisInfoDict.%Set("ProjectName",$REPLACE(DiagnosisList.%Get(i).%Get("DiagnosisName")," ",""))
        d DiagnosisInfoC.%Push(DiagnosisInfoDict)
        d DiagnosisInfo.%Set("children",DiagnosisInfoC)
        d children.%Push(DiagnosisInfo)
    	d OneOrderJson.%Set("children",children) 
        try{
	        d ##class(web.CDSS.MachineLearning.ParseMode).ParsePatientModel(OneOrderJson.%ToJSON())
	    }catch e{
		}
    }
    //触发识别词
    try
    {
	    //d ##class(web.CDSS.MachineLearning.ParseMode).ParsePatientModel(OneOrderJson.%ToJSON())
    	d ##class(web.CDSS.IdentifyWords.GetPatientIW).GetSatisfyIW(PatientUserInfo)
    }
    catch e
    {
	}
	//获取院方预警阻断信息
	s WarnInfo = ##class(web.CDSS.PatientView.PatientRecomInfo).GetRecomInfo(PatientUserInfo,"院方预警阻断")
	//筛选出本次诊断触发的预警信息
	for DLi=0:1:(DiagList.%Size()-1) 
	{
		s DLItem ="[^]"_DiagList.%Get(DLi)_"[^]"
		continue:WarnInfo'[DLItem
		s WarnArray=[].%FromJSON(WarnInfo).%Get("院方预警阻断")
		for WAi=0:1:(WarnArray.%Size()-1)
		{
			continue:WarnArray.%Get(WAi).%Get("AlertLevel")="辅助预警"
			if (WarnArray.%Get(WAi).%Get("OrderStr")[DLItem)
			{
				s OneWarn={}
				d OneWarn.%Set("WarningSource",DiagList.%Get(DLi))
			    d OneWarn.%Set("WarningTip",WarnArray.%Get(WAi).%Get("WarningTip"))
			    continue:(WarningTipStr[WarnArray.%Get(WAi).%Get("WarningTip"))
			    s WarningTipStr=WarningTipStr_WarnArray.%Get(WAi).%Get("WarningTip")
				if (WarnArray.%Get(WAi).%Get("AlertLevel")="弹窗提醒")
				{
			        d PopWarn.%Push(OneWarn)
				}
				else
				{
			        d StopWarn.%Push(OneWarn)
				}
			}
		}
	}
   	Tro
    d OrderWarnList.%Set("BlockWarn",StopWarn)
    d OrderWarnList.%Set("PopWarn",PopWarn)
    q OrderWarnList.%ToJSON()
}

/// Creator:陈代雷
/// CreatDate:2020-06-09
/// Description:同步医嘱信息
/// Table:
/// Input: CaseInfo : {"IDNO": "患者主索引", "PatientDR": "病人标识", "VisitID": "就诊次", "Name": "患者姓名", "UserID": "医生ID", "UserName": "医生姓名", "DeptCode": "科室编码", "DeptName": "科室名称", "PatientInfo": {"Gender": "性别", "BirthDate": "出生日期", "PregnancyStatus": "妊娠状态"}, "OrderEntry": {"OrderID": "医嘱唯一标识", "OrderClass": "医嘱类型", "OrderFlag": "医嘱 操作标识", "OrderType": "医嘱分类", "CreatTime": "医嘱创建时间", "StopTime": "医嘱作废时间", "DoctorId": "医生唯一标识", "DoctorName": "医生姓名", "CreateDeptCode": "开立科室代码", "CreateDeptName": "开立科室名称", "GroupSequence": "医嘱组顺序", "OrderCode": "医嘱代码", "OrderContent": "医嘱内容", "Dosage": "给药剂量", "Unit": "剂量单位", "Frequency": "频率", "Specification": "规格", "Pathway": "给药方式", "Sample": "样本", "Position": "部位", "Level": "手术等级", "IncisionType": "切口类型", "Anesthesia": "麻醉方式", "PreoperativeDiagnose": "术前诊断"}}
/// Return:
/// Others:w ##class(web.CDSS.MachineLearning.InteractiveInterface).SynchronizeOrderV2(json)
ClassMethod SynchronizeOrderV2(OrderInfo As %String) As %String
{
	Ts
	s WarningTipStr=""
	s OrderList=[]
	s OrderWarnList={}
	s StopWarn=[]
	s PopWarn=[]
    s info=[].%FromJSON(OrderInfo)
    s OrderJson={}
    d OrderJson.%Set("IDNO",info.%Get("IDNO"))
    d OrderJson.%Set("PatientDR",info.%Get("PatientDR"))
    d OrderJson.%Set("VisitID",info.%Get("VisitID"))
    d OrderJson.%Set("VisitType",..ConvertVisitType(info.%Get("VisitType")))
    d OrderJson.%Set("UserID",info.%Get("UserID"))
    d OrderJson.%Set("UserName",info.%Get("UserName"))
    d OrderJson.%Set("CTLocID",info.%Get("DeptCode"))
    d OrderJson.%Set("CTLocDesc",info.%Get("DeptName"))
    s PatientUserInfo=info.%Get("IDNO")_"^"_info.%Get("PatientDR")_"^"_info.%Get("VisitID")_"^"_..ConvertVisitType(info.%Get("VisitType"))_"^"_info.%Get("UserID")_"^"_info.%Get("UserName")_"^"_info.%Get("DeptCode")_"^"_info.%Get("DeptName")_"^1"

    if (info.%Get("UserName")=""){
	    d info.%Set("UserName","Demo")
	}
    k ^TMPOrder(info.%Get("IDNO"),info.%Get("UserName"))
    s ^TMPOrder(info.%Get("IDNO"),info.%Get("UserName"))=OrderInfo
    s OrderFlag=""  //医嘱操作标识
    //d OrderJson.%Set("Config",##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSSdyn20200416"))
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
    if (##class(%Library.TimeStamp).IsValid(info.%Get("PatientInfo").%Get("BirthDate")))
    {
    	s Age=##class(web.CDSS.MachineLearning.InteractiveInterface).CurrentAge($zdh(info.%Get("PatientInfo").%Get("BirthDate"),3))
    }
    else
    {
	    s Age=""
    }
    //s Age=($h-$zdh(info.%Get("PatientInfo").%Get("BirthDate"),3))/365
    d PatientMasterDict.%Set("Age",Age) //年龄
    d PatientMasterDict.%Set("Profession","") //职业（职业病史）
    d PatientMasterDict.%Set("Nation","") //民族
    d PatientMasterDict.%Set("Marriage","") //婚姻
    d PatientMasterDict.%Set("BloodGroup","") //血型
    d PatientMasterDict.%Set("Country","") //国籍
    d PatientMasterDict.%Set("Birthplace","") //籍贯
    d PatientMasterDict.%Set("CurrentAddress","") //现住址
    d PatientMasterDict.%Set("PhoneNumber","") //电话
    d PatientMasterDict.%Set("Birthday",info.%Get("PatientInfo").%Get("BirthDate"))  //出生日期
    d PatientMasterC.%Push(PatientMasterDict)
    d PatientMaster.%Set("children",PatientMasterC)
    d children.%Push(PatientMaster)
    //d OrderJson.%Set("Birthday",info.%Get("PatientInfo").%Get("BirthDate"))  //出生日期
    //d OrderJson.%Set("PregnancyStatus",info.%Get("PatientInfo").%Get("PregnancyStatus"))  //妊娠状态
    ///医嘱相关信息
    s OrderInfo={}  //医嘱信息
    d OrderInfo.%Set("DataClass","PatientVisit")
    s OrderInfoC=[]  //病例信息详细内容
    s AllOrderEntry=info.%Get("OrderEntry")  //医嘱信息列表，医院数据
    for i=0:1:(AllOrderEntry.%Size()-1)
    {
	    //b ;;
        s OrderEntry=AllOrderEntry.%Get(i)
        s OrderInfoDict={}  //单个基础信息详细内容
        s OrderType=OrderEntry.%Get("OrderType")  //医嘱分类
        s OrderClass=OrderEntry.%Get("OrderClass")  //医嘱类型
        s OrderFlag=OrderEntry.%Get("OrderFlag")  //医嘱操作标识
        d OrderList.%Push(OrderEntry.%Get("OrderContent"))
        if (OrderEntry.%Get("GroupSequence")="")
        {
	        d OrderEntry.%Set("GroupSequence","1")
	    }
        //2023-04-25 判断知识库类型
        s OType=$case(OrderType,"1":"药品","2":"检查","3":"检验医嘱","4":"手术","5":"护理","6":"护理","10":"其他",:"")
        s ConDictS=##class(web.CDSS.IMP.ContrastDict).GetDiectNameType(OrderEntry.%Get("OrderContent"),##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401"),OType)
        s OrderType=$p($p(ConDictS,",",1),"^",2)		//知识库类型
        /*if (OrderType=10)
        {
	       	//检查检验
	    	if $d(^CT.WDT.CDSS.ContrastDictI("IntDictDescIndex",##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401"),"检查检验",OrderEntry.%Get("OrderContent")))
	    	{
		    	//适用于2.0字典对照
				s OrderContrastID=$o(^CT.WDT.CDSS.ContrastDictI("IntDictDescIndex",##class(web.DHCBL.MKB.MKBConfig).GetConfigValue("CDSScdl2020072401"),"检查检验",OrderEntry.%Get("OrderContent"),0))
				s ConId=$lg($g(^CT.WDT.CDSS.ContrastDictD(OrderContrastID)),11)		//对接方字典DR
				s:ConId'="" Type=$lg($g(^CT.WDT.CDSS.ConExamDictD(ConId)),4)
				if Type="检查"
				{
				    s OrderType=2
				}
				else //检验项目/检验医嘱
				{
				    s OrderType=3
				} 	
	    	}
			//药品
			elseif $d(^CT.WDT.CDSS.ContrastDictI("IntDictDescIndex",##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401"),"药品",OrderEntry.%Get("OrderContent")))
			{
				s OrderType=1	
			}
			//护理
			elseif $d(^CT.WDT.CDSS.ContrastDictI("IntDictDescIndex",##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401"),"护理",OrderEntry.%Get("OrderContent")))
			{
				s OrderType=5	
			}
			//手术
			elseif $d(^CT.WDT.CDSS.ContrastDictI("IntDictDescIndex",##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401"),"手术",OrderEntry.%Get("OrderContent")))
        	{
	        	s OrderType=4	
	        }
	    }*/
        ///处方信息（药品）
        if (OrderType="药品")
        {
	        s DrugContrastName=##class(web.CDSS.IMP.ContrastDict).GetDiectName(OrderEntry.%Get("OrderContent"),##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401"),"药品")
	        for Diagi=1:1:$l(DrugContrastName,"&%")
	        {
		        s DrugName=$p(DrugContrastName,"&%",Diagi)
		        s DrugInfo={}  //药品信息
		        d DrugInfo.%Set("DataClass","DrugInfo")
		        s DrugInfoC=[]  //详细内容
	            s DrugInfoDict={}  //单个详细内容
	            if (OrderEntry.%IsDefined("PriorType"))
	            {
		            d DrugInfoDict.%Set("Type",OrderEntry.%Get("PriorType")) //类型(长期、临时（皮试）)
		        }
	            else
	            {
		            d DrugInfoDict.%Set("Type","Short") //类型(长期、临时（皮试）)
		        }
	            d DrugInfoDict.%Set("GroupFlag",OrderEntry.%Get("OrderID")) //医嘱单号
	            d DrugInfoDict.%Set("GroupSequence",OrderEntry.%Get("GroupSequence")) //组顺序
	            d DrugInfoDict.%Set("DrugCode",OrderEntry.%Get("OrderCode")) //药品编码
	            d DrugInfoDict.%Set("DrugName",DrugName) //药品名称
	            d DrugInfoDict.%Set("Usage",OrderEntry.%Get("Pathway")) //用法
	            d DrugInfoDict.%Set("Dose",OrderEntry.%Get("Dosage")) //剂量
	            //频率进行别名转换
	            s Frequency=OrderEntry.%Get("Frequency")
	            if Frequency'=""
	            {
		            s CommonID=$o(^CT.WDT.CDSS.AliasI("UPAliasIndex","CT.WDT.CDSS.FrequencyDict"," "_$ZCONVERT(Frequency,"U"),0))  //别名通用名判断
					if CommonID'=""
					{
						s Frequency=$lg($g(^CT.WDT.CDSS.FrequencyDictD(CommonID)),3)  //频率名称-频率字典表
					}
		        }
		        d DrugInfoDict.%Set("Frequency",Frequency) //频率
	            d DrugInfoDict.%Set("Unit",OrderEntry.%Get("Unit")) //单位
	            d DrugInfoDict.%Set("Specification",OrderEntry.%Get("Specification")) //规格
	            d DrugInfoDict.%Set("StartTime",OrderEntry.%Get("CreatTime")) //开始时间
	            d DrugInfoDict.%Set("StopTime",OrderEntry.%Get("StopTime")) //停止时间
	            d DrugInfoDict.%Set("Remarks","") //备注
	            d DrugInfoDict.%Set("ProjectName",OrderEntry.%Get("OrderContent")) //20211209
	            d DrugInfoC.%Push(DrugInfoDict)
	            d DrugInfo.%Set("children",DrugInfoC)
	        	d children.%Push(DrugInfo)
	        }
        }
        ///检查
        elseif (OrderType="检查")
        {
	        s ExamContrastName=##class(web.CDSS.IMP.ContrastDict).GetDiectName(OrderEntry.%Get("OrderContent"),##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401"),"检查")
	        for Diagi=1:1:$l(ExamContrastName,"&%")
	        {
		        s ExamName=$p(ExamContrastName,"&%",Diagi)
		        s ExamInfo={}  //检查信息
	            d ExamInfo.%Set("DataClass","ExamInfo")
	            s ExamInfoC=[]  //详细内容
	            s ExamInfoDict={}  //单个详细内容
	            d ExamInfoDict.%Set("GroupFlag",OrderEntry.%Get("OrderID")) //医嘱单号
	            d ExamInfoDict.%Set("GroupSequence",OrderEntry.%Get("GroupSequence")) //组顺序
	            d ExamInfoDict.%Set("ExamCode",OrderEntry.%Get("OrderCode")) //检查编码
	            d ExamInfoDict.%Set("ExamName",ExamName) //检查名称
	            d ExamInfoDict.%Set("ExamResultNum","") //检查结果顺序号
	            d ExamInfoDict.%Set("ExamResult","") //检查结果
	            d ExamInfoDict.%Set("ExamResultFlag","") //检查结果指标（阴性或阳性）
	            d ExamInfoDict.%Set("ExamResultDesc","") //检查结果概述
	            d ExamInfoDict.%Set("PartDR",OrderEntry.%Get("Position")) //部位（改成指针）
	            d ExamInfoDict.%Set("ExecuteTime","") //执行时间
	            d ExamInfoDict.%Set("ReportTime","") //报告时间
	            d ExamInfoDict.%Set("Remarks","") //备注
	            d ExamInfoDict.%Set("ProjectName",OrderEntry.%Get("OrderContent")) //20211209
	            d ExamInfoC.%Push(ExamInfoDict)
	           	d ExamInfo.%Set("children",ExamInfoC)
	       		d children.%Push(ExamInfo)
	        }
        }
        ///检验
        elseif ((OrderType="检验项目")||(OrderType="检验医嘱"))
        {
	        s ItemName=OrderEntry.%Get("OrderContent")
            s DictName=##class(web.CDSS.IMP.ContrastDict).GetDiectName(ItemName,##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401"),"检验")
            if DictName=ItemName
            {
	        	s DictName=##class(web.CDSS.IMP.ContrastDict).GetDiectName(ItemName,##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401"),"检验医嘱")   
	        }
	        for Labi=1:1:$l(DictName,"&%")
	        {
		        s LabName=$p(DictName,"&%",Labi)
		        ;s:LabName="阴道分泌物常规" LabName="阴道分泌物检查"
		    	s OrderConItems=##class(web.CDSS.IMP.LabOrderConItem).GetConItem(ItemName,##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401"))
		    	for CI=1:1:$l(OrderConItems,"^")
		    	{
			    	s LabItemName=$p(OrderConItems,"^",CI)
			    	s DictLabItemName=##class(web.CDSS.IMP.ContrastDict).GetDiectName(LabItemName,##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401"),"检验项目")
			        for DI=1:1:$l(DictLabItemName,"&%")
		    		{
			    		s OneLabItemName=$p(DictLabItemName,"&%",DI)
				        s LabInfo={}  //检查信息
			            d LabInfo.%Set("DataClass","LabInfo")
			            s LabInfoC=[]  //详细内容
			            s LabInfoDict={}  //单个详细内容
			            d LabInfoDict.%Set("GroupFlag",OrderEntry.%Get("OrderID")) //医嘱单号
			            //d LabInfoDict.%Set("GroupSequence",OrderEntry.%Get("GroupSequence")) //组顺序
			            d LabInfoDict.%Set("InspectionCode",OrderEntry.%Get("OrderCode")) //检验大项编码
			            /*s ItemName=OrderEntry.%Get("OrderContent")
			            s DictName=##class(web.CDSS.IMP.ContrastDict).GetDiectName(ItemName,##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401"),"检验")
			            if DictName=ItemName
			            {
				        	s DictName=##class(web.CDSS.IMP.ContrastDict).GetDiectName(ItemName,##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401"),"检验医嘱")   
				        }*/
			            d LabInfoDict.%Set("InspectionName",LabName) //检验大项名称
			            d LabInfoDict.%Set("LabItemCode","") //检验小项编码
			            d LabInfoDict.%Set("LabItemName",OneLabItemName) //检验小项名称
			            d LabInfoDict.%Set("LabResult","") //检验结果
			            d LabInfoDict.%Set("LabResultFlag","") //检验结果指标（阴性或阳性）
			            d LabInfoDict.%Set("Unit","") //单位
			            d LabInfoDict.%Set("Reference","") //参考值
			            if (OrderEntry.%Get("Sample")'="")  //如果标本为空，不传避免覆盖检验报告中的标本
			            {
			                d LabInfoDict.%Set("Specimen",OrderEntry.%Get("Sample"))  //标本
			            }
			            d LabInfoDict.%Set("ExecuteTime","") //执行时间
			            d LabInfoDict.%Set("ReportTime","") //报告时间
			            d LabInfoDict.%Set("Remarks","") //备注
			            d LabInfoDict.%Set("ProjectName",OrderEntry.%Get("OrderContent")) //20211209
			            d LabInfoC.%Push(LabInfoDict)
			            d LabInfo.%Set("children",LabInfoC)
			        	d children.%Push(LabInfo)
		    		}
	        	}
	        }
        }
        ///手术
        elseif (OrderType="手术")
        {
	        s OperContrastName=##class(web.CDSS.IMP.ContrastDict).GetDiectName(OrderEntry.%Get("OrderContent"),##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401"),OType)
            for Operi=1:1:$l(OperContrastName,"&%")
            {
	            s OperName=$p(OperContrastName,"&%",Operi)
	            s OperationInfo={}  //手术信息
	            d OperationInfo.%Set("DataClass","OperationInfo")
	            s OperationInfoC=[]  //详细内容
	            s OperationInfoDict={}  //单个详细内容        
	            d OperationInfoDict.%Set("OperNum","") //手术次数
	            d OperationInfoDict.%Set("OperSequence","") //手术顺序号
	            d OperationInfoDict.%Set("MainOperFlag","") //主手术标记
	            d OperationInfoDict.%Set("OperCode",OrderEntry.%Get("OrderCode")) //手术编码
	            d OperationInfoDict.%Set("OperName",OperName) //手术名称
	            d OperationInfoDict.%Set("OperDesc","") 		//手术描述
	            d OperationInfoDict.%Set("OperType",OrderEntry.%Get("Position")) //手术部位
	            d OperationInfoDict.%Set("OperPosition","") 	//手术体位
	            d OperationInfoDict.%Set("IntraoperDiagnosis","") //术中诊断
	            d OperationInfoDict.%Set("OperDuration","") 	//手术持续时间
	            d OperationInfoDict.%Set("OperStartTime","") 	//手术开始时间
	            d OperationInfoDict.%Set("OperEndTime","") 		//手术结束时间
	            d OperationInfoDict.%Set("OperClass",OrderEntry.%Get("OrderClass"))	//手术等级 
	            d OperationInfoDict.%Set("OperLevel",OrderEntry.%Get("Level"))	//手术等级
	            d OperationInfoDict.%Set("OperIncisionType",OrderEntry.%Get("IncisionType"))		//切口类型
	            d OperationInfoDict.%Set("OperAnest",OrderEntry.%Get("Anesthesia"))			//麻醉方式
	            d OperationInfoDict.%Set("ProjectName",OrderEntry.%Get("OrderContent")) //20211209
	            d OperationInfoDict.%Set("GroupFlag",OrderEntry.%Get("OrderID")) //医嘱单号
	            d OperationInfoC.%Push(OperationInfoDict)
	            d OperationInfo.%Set("children",OperationInfoC)
            	d children.%Push(OperationInfo)
            }
        }
        ///麻醉
        elseif (OrderType="麻醉")
        {
            s AnestInfo={}  //麻醉信息
            d AnestInfo.%Set("DataClass","AnestInfo")
            s AnestInfoC=[]  //详细内容
            s AnestInfoDict={}  //单个详细内容        
            d AnestInfoDict.%Set("AnestMedication","") //麻醉用药
            d AnestInfoDict.%Set("Dose","") //剂量
            d AnestInfoDict.%Set("Usage","") //用法
            d AnestInfoDict.%Set("Anesthesia","") //麻醉方式
            d AnestInfoDict.%Set("AnestSite","") //麻醉部位
            d AnestInfoDict.%Set("AnestDuration","") //麻醉持续时长
            d AnestInfoDict.%Set("AnestStartTime","") //麻醉开始时间
            d AnestInfoDict.%Set("ProjectName",OrderEntry.%Get("OrderContent")) //20211209
            d AnestInfoC.%Push(AnestInfoDict)
            d AnestInfo.%Set("children",AnestInfoC)
            d children.%Push(AnestInfo)
        }
        ///护理
        elseif (OrderType="护理")
        {
	        s NurContrastName=##class(web.CDSS.IMP.ContrastDict).GetDiectName(OrderEntry.%Get("OrderContent"),##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401"),"护理")
	        for Nuri=1:1:$l(NurContrastName,"&%")
	        {
		        s NursingName=$p(NurContrastName,"&%",Nuri)
	            s NursingInfo={}  //护理信息
	            d NursingInfo.%Set("DataClass","NursingInfo")
	            s NursingInfoC=[]  //详细内容
	            s NursingInfoDict={}  //单个详细内容
	            d NursingInfoDict.%Set("NursingItemNum","") //护理项目顺序号
	            d NursingInfoDict.%Set("NursingItemCode",OrderEntry.%Get("OrderCode")) //护理项目编码
	            d NursingInfoDict.%Set("NursingItemName",NursingName) //护理项目名称
	            d NursingInfoDict.%Set("ChildItemNum","") //护理小项顺序号
	            d NursingInfoDict.%Set("ChildItemCode","") //护理小项编码
	            d NursingInfoDict.%Set("ChildItemName","") //护理小项名称
	            d NursingInfoDict.%Set("NursingEffect","") //护理效果
	            d NursingInfoDict.%Set("ProjectName",OrderEntry.%Get("OrderContent")) //20211209
	            d NursingInfoDict.%Set("GroupFlag",OrderEntry.%Get("OrderID")) //医嘱单号
	            d NursingInfoC.%Push(NursingInfoDict)
	            d NursingInfo.%Set("children",NursingInfoC)
	            d children.%Push(NursingInfo)
	        }
        }
        elseif (OrderType="输血品")
        {
	        s BloodContrastName=##class(web.CDSS.IMP.ContrastDict).GetDiectName(OrderEntry.%Get("OrderContent"),##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401"),"输血品")
	        for Bloi=1:1:$l(BloodContrastName,"&%")
	        {
		        s BloodTransName=$p(BloodContrastName,"&%",Bloi)
	            s BloodInfo={}  //护理信息
	            d BloodInfo.%Set("DataClass","BloodTransInfo")
	            s BloodInfoC=[]  //详细内容
	            s BloodInfoDict={}  //单个详细内容
	            d BloodInfoDict.%Set("BloodTransClass",BloodContrastName)   //输血品名称
	            d BloodInfoC.%Push(BloodInfoDict)
	            d BloodInfo.%Set("children",BloodInfoC)
	            d children.%Push(BloodInfo)
	        }
        }
        ///饮食
        elseif (OrderType="饮食")
        {
            s DietInfo={}  //饮食信息
            d DietInfo.%Set("DataClass","DietInfo")
            s DietInfoC=[]  //详细内容
            s DietInfoDict={}  //单个详细内容
            d DietInfoDict.%Set("GroupFlag",OrderEntry.%Get("OrderID")) //医嘱单号
            d DietInfoDict.%Set("GroupSequence",OrderEntry.%Get("GroupSequence")) //组顺序
            d DietInfoDict.%Set("DietMethod","") //饮食方式
            d DietInfoDict.%Set("DietType","") //饮食类型
            d DietInfoDict.%Set("DietContent",OrderEntry.%Get("OrderContent")) //饮食内容
            d DietInfoDict.%Set("DietAmount","") //饮食量
            d DietInfoDict.%Set("DietInstructions","") //饮食说明
            d DietInfoDict.%Set("Duration","") //持续时长
            d DietInfoDict.%Set("StartTime","") //开始时间
            d DietInfoDict.%Set("EndTime","") //结束时间
            d DietInfoDict.%Set("ProjectName",OrderEntry.%Get("OrderContent")) //20211209
            d DietInfoC.%Push(DietInfoDict)
            d DietInfo.%Set("children",DietInfoC)
            d children.%Push(DietInfo)
        }
        ///出院带药
        elseif (OrderType="药品")&(OrderClass=4)
        {
	        s DrugContrastName=##class(web.CDSS.IMP.ContrastDict).GetDiectName(OrderEntry.%Get("OrderContent"),##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401"),"药品")
            for Drugi=1:1:$l(DrugContrastName,"&%")
            {
	            s DrugName=$p(DrugContrastName,"&%",Drugi)
	            s DrugInfo={}  //出院带药信息
	            d DrugInfo.%Set("DataClass","CarryDrug")
	            s DrugInfoC=[]  //详细内容
	            s DrugInfoDict={}  //单个详细内容
	            d DrugInfoDict.%Set("GroupFlag",OrderEntry.%Get("OrderID")) //医嘱单号
	            d DrugInfoDict.%Set("GroupSequence",OrderEntry.%Get("GroupSequence")) //组顺序
	            d DrugInfoDict.%Set("DrugCode",OrderEntry.%Get("OrderCode")) //药品编码
	            d DrugInfoDict.%Set("DrugName",DrugName) //药品名称
	            d DrugInfoDict.%Set("Usage",OrderEntry.%Get("Pathway")) //用法
	            d DrugInfoDict.%Set("Dose",OrderEntry.%Get("Dosage")) //剂量
	            d DrugInfoDict.%Set("Frequency",OrderEntry.%Get("Frequency")) //频率
	            d DrugInfoDict.%Set("Unit",OrderEntry.%Get("Unit")) //单位
	            d DrugInfoDict.%Set("Specification",OrderEntry.%Get("Specification")) //规格
	            d DrugInfoDict.%Set("StartTime","") //开始时间
	            d DrugInfoDict.%Set("StopTime","") //停止时间
	            d DrugInfoDict.%Set("Remarks","") //备注
	            d DrugInfoC.%Push(DrugInfoDict)
	            d DrugInfo.%Set("children",DrugInfoC)
	            d children.%Push(DrugInfo)
            }
        }
        elseif (OrderClass=4)  //其他出院医嘱信息
        {
            s OtherDisOrderInfo={}  //其他出院医嘱信息
            d OtherDisOrderInfo.%Set("DataClass","OtherDisOrderInfo")
            s OtherDisOrderInfoC=[]  //详细内容
            s OtherDisOrderInfoDict={}  //单个详细内容
            d OtherDisOrderInfoDict.%Set("GroupFlag",OrderEntry.%Get("OrderID")) //医嘱单号
            d OtherDisOrderInfoDict.%Set("GroupSequence",OrderEntry.%Get("GroupSequence")) //组顺序
            d OtherDisOrderInfoDict.%Set("OrderDesc","") //医嘱描述
            d OtherDisOrderInfoDict.%Set("ExecuteMethod","") //执行方式
            d OtherDisOrderInfoDict.%Set("PlanStartTime","") //计划开始时间
            d OtherDisOrderInfoDict.%Set("PlanStopTime","") //计划停止时间
            d OtherDisOrderInfoDict.%Set("ExecuteDesc","") //执行说明
            d OtherDisOrderInfoC.%Push(OtherDisOrderInfoDict)
            d OtherDisOrderInfo.%Set("children",OtherDisOrderInfoC)
            d children.%Push(OtherDisOrderInfo)
        }
        elseif (OrderClass=1)  //其他在院医嘱信息
        {
            s OtherOrderInfo={}  //其他在院医嘱信息
            d OtherOrderInfo.%Set("DataClass","OtherOrderInfo")
            s OtherOrderInfoC=[]  //详细内容
            s OtherOrderInfoDict={}  //单个详细内容
            d OtherOrderInfoDict.%Set("GroupFlag",OrderEntry.%Get("OrderID")) //医嘱单号
            d OtherOrderInfoDict.%Set("GroupSequence",OrderEntry.%Get("GroupSequence")) //组顺序
            d OtherOrderInfoDict.%Set("OrderDesc","") //医嘱描述
            d OtherOrderInfoDict.%Set("ExecuteTime","") //执行时间
            d OtherOrderInfoDict.%Set("ExecuteResult","") //执行结果
            d OtherOrderInfoC.%Push(OtherOrderInfoDict)
            d OtherOrderInfo.%Set("children",OtherOrderInfoC)
            d children.%Push(OtherOrderInfo)
        }
        d OrderJson.%Set("OperationFlag",OrderFlag)
        d OrderJson.%Set("children",children)
        s config=##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020061601")
        /*s RationalResult=##Class(web.CDSS.MachineLearning.DataVerification).DataRationalisation(OrderJson.%ToJSON())  //对第三方数据json串进行数据合理性校验，包括（数据类型是否匹配，主键是否存在等）
        s RationalResult=[].%FromJSON(RationalResult)
        s UnifomResult=##Class(web.CDSS.MachineLearning.DataVerification).DataConsistency(OrderJson.%ToJSON())  //对第三方数据json串进行基本信息、就诊信息数据一致性和临床信息完整性校验
        s UnifomResult=[].%FromJSON(UnifomResult)*/
    }   

    //if (RationalResult.%Size()=0)&(UnifomResult.%Size()=0)  //如果没有错误信息
    //{ 
        try{
	        d ##class(web.CDSS.MachineLearning.ParseMode).ParsePatientModel(OrderJson.%ToJSON())
	        //触发识别词
	        
	        d ##class(web.CDSS.IdentifyWords.GetPatientIW).GetSatisfyIW(PatientUserInfo)
	        //获取院方预警阻断信息
	         
			s WarnInfo = ##class(web.CDSS.PatientView.PatientRecomInfo).GetRecomInfo(PatientUserInfo,"院方预警阻断")
			//筛选出本次诊断触发的预警信息
			for DLi=0:1:(OrderList.%Size()-1) 
			{
				s DLItem ="[^]"_OrderList.%Get(DLi)_"[^]"
				continue:WarnInfo'[DLItem
				s WarnArray=[].%FromJSON(WarnInfo).%Get("院方预警阻断")
				for WAi=0:1:(WarnArray.%Size()-1)
				{
					continue:WarnArray.%Get(WAi).%Get("AlertLevel")="辅助预警"
					if (WarnArray.%Get(WAi).%Get("OrderStr")[DLItem)
					{
						s OneWarn={}
						d OneWarn.%Set("WarningSource",OrderList.%Get(DLi))
					    d OneWarn.%Set("WarningTip",WarnArray.%Get(WAi).%Get("WarningTip"))
					    continue:(WarningTipStr[WarnArray.%Get(WAi).%Get("WarningTip"))
			    		s WarningTipStr=WarningTipStr_WarnArray.%Get(WAi).%Get("WarningTip")
						if (WarnArray.%Get(WAi).%Get("AlertLevel")="弹窗提醒")
						{
					        d PopWarn.%Push(OneWarn)
						}
						else
						{
					        d StopWarn.%Push(OneWarn)
						}
					}
				}	
			}
	    }catch e{
		    
		}		
    //}
    Tro
    d OrderWarnList.%Set("BlockWarn",StopWarn)
    d OrderWarnList.%Set("PopWarn",PopWarn)
    q OrderWarnList.%ToJSON()
}

/// Create:2023-02-28
/// w ##class(web.CDSS.MachineLearning.InteractiveInterface).OnlySyncDiag(json)
ClassMethod OnlySyncDiag(json As %String) As %String
{
	s tmpResult=..SynchronousDiagInfo(json)	
	s result=[]
    s tmpResult=[].%FromJSON(tmpResult)
    d result.%Push(tmpResult)
    s result=result.%ToJSON()
	try
    {
    	d ##class(web.CDSS.MachineLearning.ParseMode).ParsePatientModel(result)		//单开进程提升入库速度
    }
    catch e
    {
	    w ##class(web.CDSS.MachineLearning.ParseMode).ParsePatientModel(result)
    }
    q ""
}

}
