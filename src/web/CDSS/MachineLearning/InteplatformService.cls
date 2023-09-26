/// web.CDSS.MachineLearning.InteplatformService
Class web.CDSS.MachineLearning.InteplatformService Extends %SOAP.WebService [ ProcedureBlock ]
{

/// WebService 的名称.
Parameter SERVICENAME = "InteplatformService";

// Parameter LOCATION = "http://192.144.152.252/imedical/web/";

/// TODO:将此更改为实际 SOAP namespace.
/// WebService 的 SOAP Namespace
Parameter NAMESPACE = "http://tempuri.org";

/// 引用类的 Namespace 将在 WSDL 中使用.
Parameter USECLASSNAMESPACES = 1;

/// W ##class(web.CDSS.MachineLearning.InteplatformService).TESTCDSS()
ClassMethod TESTCDSS()
{
	s stream=##class(%Stream.GlobalCharacter).%New()
	d stream.Write("<Request><SignInfo><IDNO>0001</IDNO><PatientDR>0001</PatientDR><VisitID>1</VisitID><VisitType>3</VisitType><MeasureDate>2021-12-22 17:00:00</MeasureDate><BodyTemperature>37.1</BodyTemperature><BloodPressure>120</BloodPressure><DiastolicBlood></DiastolicBlood><SystolicBlood>77</SystolicBlood><Pulse></Pulse><BreathFeature></BreathFeature><HeartRate></HeartRate><OxygenSaturation></OxygenSaturation><Pupil></Pupil><CornealReflex></CornealReflex><Height></Height><Weight>100</Weight><PassFlag>0</PassFlag></SignInfo></Request>")
	set result=..DHCServerInterface("PATIENT_SIGN_INFORMATION",stream)
	Q result
}

/// TODO:添加自变量和实施.
/// Test
Method Test() As %String [ WebMethod ]
{
	Quit "Test"
}

/// Creator:阚延新
/// CreatDate:2021-02-19
/// Description:第三方调用数据接口(后台调用)，护理接口
/// Table:
/// Input: action: 服务编号 message：请求流传给改参数
/// Return:
/// Others:w ##class(web.CDSS.MachineLearning.InteplatformService).DHCServerInterface(action,message)
ClassMethod DHCServerInterface(action As %String, message As %Stream.GlobalCharacter) As %String [ WebMethod ]
{
	s str=""
    while 'message.AtEnd
    {
        s str=str_message.ReadLine()
    }
 	s SaveDict={}
 	s XMLObj=##class(web.CDSS.Public.XML).FromXML(str)
 	q:XMLObj="" 
 	if (action="PATIENT_SIGN_INFORMATION")   //患者体征信息
 	{
	 	s body=XMLObj.Get("SignInfo")  //body下可能有多条数据
 		/******************遍历body下的多条数据********************/
 		while body.Next(.nodeName, .nodeVal) 
 		{
	 		d:nodeName="IDNO" SaveDict.%Set("IDNO",nodeVal)  							//患者主索引，患者在医疗机构的唯一标识
	 		d:nodeName="PatientDR" SaveDict.%Set("PatientDR",nodeVal)   							//病人标识
	 		d:nodeName="VisitID" SaveDict.%Set("VisitID",nodeVal)  						//就诊次数编号（第几次）
	 		d:nodeName="VisitType" SaveDict.%Set("VisitType",nodeVal)  					//就诊类型
        	d:nodeName="BodyTemperature" SaveDict.%Set("BodyTemperature",nodeVal)  	//体温
        	d:nodeName="BloodPressure" SaveDict.%Set("BloodPressure",nodeVal)  			//血压
        	d:nodeName="Pulse" SaveDict.%Set("Pulse",nodeVal)  							//脉搏
        	d:nodeName="BreathFeature" SaveDict.%Set("BreathFeature",nodeVal)  			//呼吸
        	d:nodeName="HeartRate" SaveDict.%Set("HeartRate",nodeVal)  					//心率
        	d:nodeName="OxygenSaturation" SaveDict.%Set("OxygenSaturation",nodeVal) 	//血氧饱和度
        	d:nodeName="Pupil" SaveDict.%Set("Pupil",nodeVal)  							//瞳孔
        	d:nodeName="CornealReflex" SaveDict.%Set("CornealReflex",nodeVal)  			//角膜反射
        	d:nodeName="Height" SaveDict.%Set("Height",nodeVal)  					//身高
        	d:nodeName="Weight" SaveDict.%Set("Weight",nodeVal)  						//体重       
        	d:nodeName="MeasureDate" SaveDict.%Set("MeasureDate",nodeVal)  				//测量时间
        	d:nodeName="PassFlag" SaveDict.%Set("PassFlag",nodeVal)  					//同步标记（0为同步，1为新增）
        	d:nodeName="DiastolicBlood" SaveDict.%Set("DiastolicBlood",nodeVal)  		//舒张压
        	d:nodeName="SystolicBlood" SaveDict.%Set("SystolicBlood",nodeVal)  			//收缩压	
 		}
 		s SaveDict=SaveDict.%ToJSON()	
		;d ..SaveSignInfo1(SaveDict)   //分批多次入库
		d ..SaveSignInfo2(SaveDict)   //按日期入库
 		q "" 	
	}
	if (action="NURSING_RECORD_INFORMATION")   //护理记录信息
 	{
	 	s body=XMLObj.Get("NursingInfo")  //body下可能有多条数据
 		/******************遍历body下的多条数据********************/
 		while body.Next(.nodeName, .nodeVal) 
 		{
	 		//s Content=nodeVal
	 		d:nodeName="IDNO" SaveDict.%Set("IDNO",nodeVal)  								//患者主索引，患者在医疗机构的唯一标识
	 		d:nodeName="PatientDR" SaveDict.%Set("PatientDR",nodeVal)  						//病人标识（就诊医院id
	 		d:nodeName="VisitID" SaveDict.%Set("VisitID",nodeVal)  							//就诊次数编号（第几次）
	 		d:nodeName="VisitType" SaveDict.%Set("VisitType",nodeVal)  						//就诊类型
	 		if nodeName="NursingMeasureInfo"
	 		{
		 		s NursingMeaInfoC=[]
		 		s NursingMeaInfoDict={}
			 	d NursingMeaInfoDict.%Set("NursingItemCode",nodeVal.Get("AnestMedication"))		//护理项目编码
			 	d NursingMeaInfoDict.%Set("NursingItemName",nodeVal.Get("Dose"))				//护理项目名称
			 	
			 	while nodeVal.Next(.nodeName1,.nodeVal1)
			 	{
				 	s NursingMeaChildInfoC=[]
				 	s NursingMeaChildInfoDict={}
					d NursingMeaChildInfoDict.%Set("ChildItemNum",nodeVal.Get("Usage"))					//护理小项顺序号
				 	d NursingMeaChildInfoDict.%Set("ChildItemCode",nodeVal.Get("Anesthesia"))				//护理小项编码
				 	d NursingMeaChildInfoDict.%Set("ChildItemName",nodeVal.Get("AnestSite"))				//护理小项名称
		 			d NursingMeaChildInfoDict.%Set("NursingDate",nodeVal.Get("AnestDuration"))				//护理执行时间
		 			d NursingMeaChildInfoDict.%Set("NursingEffect",nodeVal.Get("AnestStartTime"))			//护理效果
	 				d NursingMeaChildInfoC.%Push(NursingMeaChildInfoDict)
	 				d NursingMeaInfoDict.%Set("ChildItem",NursingMeaChildInfoC)
			 	}
			 	d NursingMeaInfoC.%Push(NursingMeaInfoDict)
			 	d SaveDict.%Set("Children",NursingMeaInfoC)
	 		}
        	d:nodeName="PassFlag" SaveDict.%Set("PassFlag",nodeVal)  						//同步标记（0为同步，1为新增）
        	
 		}
 		s SaveDict=SaveDict.%ToJSON()
 		try
    	{
        	d ..SaveNursingInfo(SaveDict)
    	}
    	catch e
    	{
	    	if ($d(^TMPCDSSCDLERROR(1))=0)
	    	{
		    	s number=1
	    	}
	    	else
	    	{
        		s number=$o(^TMPCDSSCDLERROR(""),-1)+1
	    	}
        	s ^TMPCDSSCDLERROR(number)=SaveDict_"&&"_e.Name
    	}
 		q "" 	
	}
	if (action="ORDER_EXECUTION_INFORMATION")   //医嘱执行信息
 	{
	 	s body=XMLObj.Get("DrugInfo")  //body下可能有多条数据
 		/******************遍历body下的多条数据********************/
 		while body.Next(.nodeName, .nodeVal) 
 		{
	 		//s Content=nodeVal
	 		d:nodeName="IDNO" SaveDict.%Set("IDNO",nodeVal)  								//患者主索引，患者在医疗机构的唯一标识
	 		d:nodeName="PatientDR" SaveDict.%Set("PatientDR",nodeVal)  						//病人标识（就诊医院id
	 		d:nodeName="VisitID" SaveDict.%Set("VisitID",nodeVal)  							//就诊次数编号（第几次）
	 		d:nodeName="VisitType" SaveDict.%Set("VisitType",nodeVal)  						//就诊类型
	 		d:nodeName="Type" SaveDict.%Set("Type",nodeVal)  								//类型（长期、临时（皮试））
	 		d:nodeName="OrderType" SaveDict.%Set("OrderType",nodeVal)  						//医嘱分类
        	d:nodeName="GroupFlag" SaveDict.%Set("GroupFlag",nodeVal)  						//医嘱单号
        	d:nodeName="GroupSequence" SaveDict.%Set("GroupSequence",nodeVal)  				//组顺序
        	d:nodeName="DrugCode" SaveDict.%Set("DrugCode",nodeVal)  						//药品编码
        	d:nodeName="DrugName" SaveDict.%Set("DrugName",nodeVal)  						//药品名称
        	d:nodeName="ExecuteTime" SaveDict.%Set("ExecuteTime",nodeVal)  					//执行时间
        	d:nodeName="ExecuteStatus" SaveDict.%Set("ExecuteStatus",nodeVal)  				//执行/撤销执行
 		}
 		s SaveDict=SaveDict.%ToJSON()
        d ..SaveDrugInfo(SaveDict)
 		q "" 	
	}
	if (action="NURSING_DOCUMENT_INFORMATION")   //护理文书信息
 	{
	 	s body=XMLObj.Get("InpatientInfo")  //body下可能有多条数据
 		/******************遍历body下的多条数据********************/
 		while body.Next(.nodeName, .nodeVal) 
 		{
	 		//s Content=nodeVal
	 		d:nodeName="IDNO" SaveDict.%Set("IDNO",nodeVal)  								//患者主索引，患者在医疗机构的唯一标识
	 		d:nodeName="PatientDR" SaveDict.%Set("PatientDR",nodeVal)  						//病人标识（就诊医院id
	 		d:nodeName="VisitID" SaveDict.%Set("VisitID",nodeVal)  							//就诊次数编号（第几次）
	 		d:nodeName="VisitType" SaveDict.%Set("VisitType",nodeVal)  						//就诊类型
	 		d:nodeName="MRNum" SaveDict.%Set("MRNum",nodeVal)  								//病历顺序
        	d:nodeName="MRClass" SaveDict.%Set("MRClass",nodeVal)  							//病历类型
        	d:nodeName="MRFileNum" SaveDict.%Set("MRFileNum",nodeVal)  						//病历文件顺序
        	d:nodeName="MRCode" SaveDict.%Set("MRCode",nodeVal)  							//病历编码
        	d:nodeName="MRTempletName" SaveDict.%Set("MRTempletName",nodeVal)  				//病历模版编码
        	d:nodeName="MRDesc" SaveDict.%Set("MRDesc",nodeVal)  							//病历概述
        	
 		}
 		s SaveDict=SaveDict.%ToJSON()
        d ..SaveInpatientInfo(SaveDict)
 		q "" 	
	}
	if (action="BLOOD_MATCHING_INFORMATION")   //配血信息接口
 	{
	 	s body=XMLObj.Get("BloodTransInfo")  //body下可能有多条数据
 		/******************遍历body下的多条数据********************/
 		while body.Next(.nodeName, .nodeVal) 
 		{
	 		//s Content=nodeVal
	 		d:nodeName="IDNO" SaveDict.%Set("IDNO",nodeVal)  									//患者主索引，患者在医疗机构的唯一标识
	 		d:nodeName="PatientDR" SaveDict.%Set("PatientDR",nodeVal)  							//病人标识（就诊医院id
	 		d:nodeName="VisitID" SaveDict.%Set("VisitID",nodeVal)  								//就诊次数编号（第几次）
	 		d:nodeName="VisitType" SaveDict.%Set("VisitType",nodeVal)  							//就诊类型
	 		d:nodeName="BloodTransVolume" SaveDict.%Set("BloodTransVolume",nodeVal)  			//输血量
        	d:nodeName="BloodTransVolumeU" SaveDict.%Set("BloodTransVolumeU",nodeVal)  			//输血量单位
        	d:nodeName="BloodTransSite" SaveDict.%Set("BloodTransSite",nodeVal)  				//输血部位
        	d:nodeName="BloodTransType" SaveDict.%Set("BloodTransType",nodeVal)  				//输血血型（ABO血型系统）
        	d:nodeName="BloodTransTypeRh" SaveDict.%Set("BloodTransTypeRh",nodeVal)  			//输血血型（Rh血型系统）
        	d:nodeName="BloodTransClass" SaveDict.%Set("BloodTransClass",nodeVal)  				//输血品名称
        	d:nodeName="PassFlag" SaveDict.%Set("PassFlag",nodeVal)                     		//同步标记（0为同步，1为新增）
 		}
 		s SaveDict=SaveDict.%ToJSON()
        d ..SaveBloodTransInfo(SaveDict)
 		q "" 	
	}
	if (action="DEPARTMENT_DICTIONARY_SYNCHRONIZATION")   //科室信息
 	{
	 	d ##class(web.CDSS.MachineLearning.UserAndDeptSynchronized).DHCServerInterface(action,message)
 		q "" 	
	}
	if (action="USER_DICTIONARY_SYNCHRONIZATION")   //用户信息
 	{
	 	d ##class(web.CDSS.MachineLearning.UserAndDeptSynchronized).DHCServerInterface(action,message)
 		q "" 	
	}
	if (action="USERJOINDEPT_DICTIONARY_SYNCHRONIZATION")   //科室及用户关联关系
 	{
	 	d ##class(web.CDSS.MachineLearning.UserAndDeptSynchronized).DHCServerInterface(action,message)
 		q "" 	
	}
	if (action="TRANSFER_INFORMATION")   //患者转科记录
 	{
	 	s body=XMLObj.Get("Body")  //body下可能有多条数据
 		/******************遍历body下的多条数据********************/
 		while body.Next(.nodeName, .nodeVal) 
 		{
	 		d:nodeName="PATPatientID" SaveDict.%Set("PATPatientID",nodeVal.%get("AdmTransactionRt"))  				//患者主索引，患者在医疗机构的唯一标识
	 		d:nodeName="PAADMVisitNumber" SaveDict.%Set("PAADMVisitNumber",nodeVal.%get("AdmTransactionRt"))   		//就诊号码
	 		d:nodeName="PAADMTState" SaveDict.%Set("PAADMTState",nodeVal.%get("AdmTransactionRt"))  				//状态（02）
	 		d:nodeName="PAADMTTargDeptCode" SaveDict.%Set("PAADMTTargDeptCode",nodeVal.%get("AdmTransactionRt")) 	//转入科室代码
        	d:nodeName="PAADMTEndDate" SaveDict.%Set("PAADMTEndDate",nodeVal.%get("AdmTransactionRt"))  	    	//日期
        	d:nodeName="PAADMTEndTime" SaveDict.%Set("PAADMTEndTime",nodeVal.%get("AdmTransactionRt"))  			//时间
 		}
 		s SaveDict=SaveDict.%ToJSON()	
        d ..SaveTransferInfo(SaveDict)
 		q "" 	
	}
	if action="OPERATION_EXECUTION_INFORMATION"							//手术执行信息
	{
		s body=XMLObj.Get("OperationInfo")  //body下可能有多条数据
 		/******************遍历body下的多条数据********************/
 		while body.Next(.nodeName, .nodeVal) 
 		{
	 		d:nodeName="IDNO" SaveDict.%Set("IDNO",nodeVal)  									//患者主索引，患者在医疗机构的唯一标识
	 		d:nodeName="PatientDR" SaveDict.%Set("PatientDR",nodeVal)  							//病人标识（就诊医院id
	 		d:nodeName="VisitID" SaveDict.%Set("VisitID",nodeVal)  								//就诊次数编号（第几次）
	 		d:nodeName="VisitType" SaveDict.%Set("VisitType",nodeVal)  							//就诊类型
	 		d:nodeName="OperNum" SaveDict.%Set("OperNum",nodeVal)  								//手术次数
        	if nodeName="OperationResultInfo"
		 	{
			 	s OperResultInfoC=[]
				s OperResultInfoDict={}
				d OperResultInfoDict.%Set("OperSequence",nodeVal.Get("OperSequence"))				//手术顺序号
				d OperResultInfoDict.%Set("MainOperFlag",nodeVal.Get("MainOperFlag"))				//主手术标记
				d OperResultInfoDict.%Set("OperCode",nodeVal.Get("OperCode"))						//手术编码
				d OperResultInfoDict.%Set("OperName",nodeVal.Get("OperName"))						//手术名称
				d OperResultInfoDict.%Set("OperDesc",nodeVal.Get("OperDesc"))						//手术描述
				d OperResultInfoDict.%Set("OperPosition",nodeVal.Get("OperPosition"))				//手术部位
				d OperResultInfoDict.%Set("IntraoperDiagnosis",nodeVal.Get("IntraoperDiagnosis"))		//术中诊断
				d OperResultInfoDict.%Set("OperDuration",nodeVal.Get("OperDuration"))					//手术持续时间
				d OperResultInfoDict.%Set("OperStartTime",nodeVal.Get("OperStartTime"))				//手术开始时间
				d OperResultInfoDict.%Set("OperEndTime",nodeVal.Get("OperEndTime"))					//手术结束时间
				d OperResultInfoC.%Push(OperResultInfoDict)
				d SaveDict.%Set("Children",OperResultInfoC)
		 	}
		 	d:nodeName="PassFlag" SaveDict.%Set("PassFlag",nodeVal)								//同步标记
 		}
 		s SaveDict=SaveDict.%ToJSON()
        d ..SaveOperExecInfo(SaveDict)
 		q "" 	
	}
	if action="SURGICAL_ANESTHESIA_INFORMATION"							//手术麻醉信息
	{
		s body=XMLObj.Get("AnestInfo")  //body下可能有多条数据
 		/******************遍历body下的多条数据********************/
 		while body.Next(.nodeName, .nodeVal) 
 		{
	 		d:nodeName="IDNO" SaveDict.%Set("IDNO",nodeVal)  									//患者主索引，患者在医疗机构的唯一标识
	 		d:nodeName="PatientDR" SaveDict.%Set("PatientDR",nodeVal)  							//病人标识（就诊医院id
	 		d:nodeName="VisitID" SaveDict.%Set("VisitID",nodeVal)  								//就诊次数编号（第几次）
	 		d:nodeName="VisitType" SaveDict.%Set("VisitType",nodeVal)  							//就诊类型
	 		if nodeName="AnestDrugInfo"
	 		{
		 		if nodeVal=""
		 		{
			 		d SaveDict.%Set("Children",[])	
			 		continue
			 	}
		 		s AnestInfoC=[]
		 		s AnestInfoDict={}
			 	d AnestInfoDict.%Set("AnestMedication",nodeVal.Get("AnestMedication"))		//麻醉用药
			 	d AnestInfoDict.%Set("Dose",nodeVal.Get("Dose"))							//计量
			 	d AnestInfoDict.%Set("Usage",nodeVal.Get("Usage"))							//用法
			 	d AnestInfoDict.%Set("Anesthesia",nodeVal.Get("Anesthesia"))					//麻醉方式
			 	d AnestInfoDict.%Set("AnestSite",nodeVal.Get("AnestSite"))						//麻醉部位
	 			d AnestInfoDict.%Set("AnestDuration",nodeVal.Get("AnestDuration"))				//麻醉持续时长
	 			d AnestInfoDict.%Set("AnestStartTime",nodeVal.Get("AnestStartTime"))			//麻醉开始时间
	 			d AnestInfoC.%Push(AnestInfoDict)
				d SaveDict.%Set("Children",AnestInfoC)
	 		}
	 		d:nodeName="PassFlag" SaveDict.%Set("PassFlag",nodeVal)  							//同步标记
 		}
 		s SaveDict=SaveDict.%ToJSON()
        d ..SaveOperAnestInfo(SaveDict)
 		q ""
	}
	if action="OPERATION_NURSING_INFORMATION"						//手术护理
	{
		s body=XMLObj.Get("NursingInfo")  //body下可能有多条数据
 		/******************遍历body下的多条数据********************/
 		while body.Next(.nodeName, .nodeVal) 
 		{
	 		d:nodeName="IDNO" SaveDict.%Set("IDNO",nodeVal)  									//患者主索引，患者在医疗机构的唯一标识
	 		d:nodeName="PatientDR" SaveDict.%Set("PatientDR",nodeVal)  							//病人标识（就诊医院id
	 		d:nodeName="VisitID" SaveDict.%Set("VisitID",nodeVal)  								//就诊次数编号（第几次）
	 		d:nodeName="VisitType" SaveDict.%Set("VisitType",nodeVal)  							//就诊类型
	 		if nodeName="NursingMeasureInfo"
	 		{
		 		s NursingMeaInfoC=[]
		 		s NursingMeaInfoDict={}
			 	d NursingMeaInfoDict.%Set("NursingItemCode",nodeVal.Get("AnestMedication"))		//护理项目编码
			 	d NursingMeaInfoDict.%Set("NursingItemName",nodeVal.Get("Dose"))				//护理项目名称
			 	
			 	while nodeVal.Next(.nodeName1,.nodeVal1)
			 	{
				 	s NursingMeaChildInfoC=[]
				 	s NursingMeaChildInfoDict={}
					d NursingMeaChildInfoDict.%Set("ChildItemNum",nodeVal.Get("Usage"))					//护理小项顺序号
				 	d NursingMeaChildInfoDict.%Set("ChildItemCode",nodeVal.Get("Anesthesia"))				//护理小项编码
				 	d NursingMeaChildInfoDict.%Set("ChildItemName",nodeVal.Get("AnestSite"))				//护理小项名称
		 			d NursingMeaChildInfoDict.%Set("NursingDate",nodeVal.Get("AnestDuration"))				//护理执行时间
		 			d NursingMeaChildInfoDict.%Set("NursingEffect",nodeVal.Get("AnestStartTime"))			//护理效果
	 				d NursingMeaChildInfoC.%Push(NursingMeaChildInfoDict)
	 				d NursingMeaInfoDict.%Set("ChildItem",NursingMeaChildInfoC)
			 	}
			 	d NursingMeaInfoC.%Push(NursingMeaInfoDict)
			 	d SaveDict.%Set("Children",NursingMeaInfoC)
	 		}
	 		d:nodeName="PassFlag" SaveDict.%Set("PassFlag",nodeVal)  							//同步标记
 		}
 		s SaveDict=SaveDict.%ToJSON()
        d ..SaveNursingMeaInfo(SaveDict)
 		q ""	
	}
	if action="OPERATION_BLOOD_TRANSFUSION_INFORMATION"							//手术输血信息
	{
		s body=XMLObj.Get("BloodTransInfo")  //body下可能有多条数据
 		/******************遍历body下的多条数据********************/
 		while body.Next(.nodeName, .nodeVal) 
 		{
	 		d:nodeName="IDNO" SaveDict.%Set("IDNO",nodeVal)  									//患者主索引，患者在医疗机构的唯一标识
	 		d:nodeName="PatientDR" SaveDict.%Set("PatientDR",nodeVal)  							//病人标识（就诊医院id
	 		d:nodeName="VisitID" SaveDict.%Set("VisitID",nodeVal)  								//就诊次数编号（第几次）
	 		d:nodeName="VisitType" SaveDict.%Set("VisitType",nodeVal)  							//就诊类型
	 		if nodeName="BloodTransRecordInfo"
	 		{
		 		if nodeVal=""
		 		{
			 		d SaveDict.%Set("Children",[])	
			 		continue
			 	}
		 		s BloodInfoC=[]
		 		s BloodInfoDict={}
		 		d BloodInfoDict.%Set("BloodTransStartTime",nodeVal.Get("BloodTransStartTime"))		//输血开始时间
				d BloodInfoDict.%Set("BloodTransEndTime",nodeVal.Get("BloodTransStartTime"))		//输血结束时间
				d BloodInfoDict.%Set("BloodTransDuration",nodeVal.Get("BloodTransStartTime"))		//输血时长
				d BloodInfoDict.%Set("BloodTransDurationU",nodeVal.Get("BloodTransStartTime"))		//输血时长单位
				d BloodInfoDict.%Set("BloodTransVolume",nodeVal.Get("BloodTransStartTime"))			//输血量
				d BloodInfoDict.%Set("BloodTransVolumeU",nodeVal.Get("BloodTransStartTime"))		//输血量单位
				d BloodInfoDict.%Set("BloodTransType",nodeVal.Get("BloodTransStartTime"))			//输血血型(ABO)
				d BloodInfoDict.%Set("BloodTransTypeRh",nodeVal.Get("BloodTransStartTime"))			//RH
				d BloodInfoDict.%Set("BloodTransClass",nodeVal.Get("BloodTransStartTime"))			//输血品名称
				d BloodInfoDict.%Set("BTIndication",nodeVal.Get("BloodTransStartTime"))				//输血指征
				d BloodInfoDict.%Set("BTIndicationValue",nodeVal.Get("BloodTransStartTime"))		//指征值
				d BloodInfoDict.%Set("BTIndicationValueUnit",nodeVal.Get("BloodTransStartTime"))	//指征值单位
				d BloodInfoC.%Push(BloodInfoDict)
				d SaveDict.%Set("Children",BloodInfoC)
	 		}
	 		d:nodeName="PassFlag" SaveDict.%Set("PassFlag",nodeVal)  								//同步标记
 		}
 		s SaveDict=SaveDict.%ToJSON()
        d ..SaveOperBloodInfo(SaveDict)
 		q ""
	}
	if action="EXAM_INFORMATION"							//检查报告
	{
		s body=XMLObj.Get("ExamInfo")  //body下可能有多条数据
 		/******************遍历body下的多条数据********************/
 		while body.Next(.nodeName, .nodeVal) 
 		{
	 		d:nodeName="IDNO" SaveDict.%Set("IDNO",nodeVal)  							//患者主索引，患者在医疗机构的唯一标识
	 		d:nodeName="PatientDR" SaveDict.%Set("PatientDR",nodeVal)   				//病人标识
	 		d:nodeName="VisitID" SaveDict.%Set("VisitID",nodeVal)  						//就诊次数编号（第几次）
	 		d:nodeName="VisitType" SaveDict.%Set("VisitType",nodeVal)  					//就诊类型
        	d:nodeName="GroupFlag" SaveDict.%Set("GroupFlag",nodeVal)  					//医嘱单号
        	d:nodeName="GroupSequence" SaveDict.%Set("GroupSequence",nodeVal)  			//组顺序
        	d:nodeName="ExamCode" SaveDict.%Set("ExamCode",nodeVal)  					//检查编码
        	d:nodeName="ExamName" SaveDict.%Set("ExamName",nodeVal)  					//检查名称
        	if nodeName="ExamResultInfo"
	 		{
		    	d SaveDict.%Set("ExamResultNum",nodeVal.Get("ExamResultNum"))  				//检查结果顺序号
		    	d SaveDict.%Set("ExamResult",nodeVal.Get("ExamResult"))  		 			//检查结果
		    	d SaveDict.%Set("ExamResultFlag",nodeVal.Get("ExamResultFlag"))  			//检查结果指标（阴性或阳性）
		    	d SaveDict.%Set("ExamResultDesc",nodeVal.Get("ExamResultDesc"))  			//检查结果概述
	 		}
        	d:nodeName="PartDR" SaveDict.%Set("PartDR",nodeVal)  						//部位
        	d:nodeName="ExecuteTime" SaveDict.%Set("ExecuteTime",nodeVal)  				//执行时间      
        	d:nodeName="ReportTime" SaveDict.%Set("ReportTime",nodeVal)  				//报告时间
        	d:nodeName="Remarks" SaveDict.%Set("Remarks",nodeVal)  						//备注
 		}
 		s SaveDict=SaveDict.%ToJSON()
        d ..SaveExamInfo(SaveDict)
 		q ""
	}
	if action="LAB_INFORMATION"							//检验报告
	{
		s body=XMLObj.Get("LabInfo")  //body下可能有多条数据
 		/******************遍历body下的多条数据********************/
 		s LabResultChildInfoC=[]
 		while body.Next(.nodeName, .nodeVal) 
 		{
	 		d:nodeName="IDNO" SaveDict.%Set("IDNO",nodeVal)  							//患者主索引，患者在医疗机构的唯一标识
	 		d:nodeName="PatientDR" SaveDict.%Set("PatientDR",nodeVal)   				//病人标识
	 		d:nodeName="VisitID" SaveDict.%Set("VisitID",nodeVal)  						//就诊次数编号（第几次）
	 		d:nodeName="VisitType" SaveDict.%Set("VisitType",nodeVal)  					//就诊类型
        	d:nodeName="GroupFlag" SaveDict.%Set("GroupFlag",nodeVal)  					//医嘱单号
        	d:nodeName="GroupSequence" SaveDict.%Set("GroupSequence",nodeVal)  			//组顺序
        	d:nodeName="InspectionCode" SaveDict.%Set("InspectionCode",nodeVal)  		//检验大项编码
        	d:nodeName="InspectionName" SaveDict.%Set("InspectionName",nodeVal)  		//检验大项名称
        	if nodeName="LabResultInfo"
	 		{
				s LabResultChildInfoDict={}
		 		while nodeVal.Next(.nodeName1,.nodeVal1)
			 	{
					d LabResultChildInfoDict.%Set("LabItemCode",nodeVal.Get("LabItemCode"))			//检验小项编码
				 	d LabResultChildInfoDict.%Set("LabItemName",nodeVal.Get("LabItemName"))			//检验小项名称
				 	d LabResultChildInfoDict.%Set("LabResult",nodeVal.Get("LabResult"))				//检验结果
		 			d LabResultChildInfoDict.%Set("LabResultFlag",nodeVal.Get("LabResultFlag"))		//检验结果指标（阴性或阳性）
		 			d LabResultChildInfoDict.%Set("Unit",nodeVal.Get("Unit"))						//单位
		 			d LabResultChildInfoDict.%Set("Reference",nodeVal.Get("Reference"))				//参考值	
			 	}
			 	d LabResultChildInfoC.%Push(LabResultChildInfoDict)
	 		}
	 		
        	d:nodeName="Specimen" SaveDict.%Set("Specimen",nodeVal)  					//标本
        	d:nodeName="ExecuteTime" SaveDict.%Set("ExecuteTime",nodeVal)  				//执行时间      
        	d:nodeName="ReportTime" SaveDict.%Set("ReportTime",nodeVal)  				//报告时间
        	d:nodeName="Remarks" SaveDict.%Set("Remarks",nodeVal)  						//备注
 		}
 		d SaveDict.%Set("ChildItem",LabResultChildInfoC)
 		s SaveDict=SaveDict.%ToJSON()
        d ..SaveLabInfo(SaveDict)
 		q ""
	}
	q "消息代码不存在"
}

/// Creator:阚延新
/// CreatDate:2021-07-06
/// Description：用于推送的患者转科信息的入库
/// Input：json
/// Output: 
/// w ##class(web.CDSS.MachineLearning.InteplatformService).SaveSignInfo()
ClassMethod SaveTransferInfo(json As %String) As %String
{
    s json=[].%FromJSON(json)
    //获得推送内容
    s IDNO=json.%Get("PATPatientID")
    s PatientDR=json.%Get("PAADMVisitNumber")
    s VisitID=$o(^WDT.CDSS.SignInfoI("PatVisDRTypeIndex",PatientDR,""),-1)+1   //获取最后一次就诊次+1
    s PAADMTState=json.%Get("PAADMTState")
    q:PAADMTState'="02" "不是转入科室信息，不入库"
    s PAADMTTargDeptCode=json.%Get("PAADMTTargDeptCode")
    s ID=$o(^User.DHCDSSDeptDictI("CodeIndex",PAADMTTargDeptCode,0))
    q:ID="" "科室不存在"
    s PAADMTEndDate=json.%Get("PAADMTEndDate")
    s PAADMTEndTime=json.%Get("PAADMTEndTime")
    //新增
    s Transferobj = ##class(User.DHCDSSPatientTransfer).%New()
    s Transferobj.IDNO= IDNO
    s Transferobj.PatientDR =PatientDR
    s Transferobj.VisitID =VisitID
    s Transferobj.VisitType =""
    s Transferobj.TreatmentTime =PAADMTEndDate_" "_PAADMTEndTime 
    s Transferobj.VisitingDepartment=ID
    s Transferobj.TransferDeptResult=""
    s Transferobj.Remarks=""
    s sc=Transferobj.%Save()
    q ""
}

/// Creator:阚延新
/// CreatDate:2021-02-20
/// Description：用于护理系统推送的患者体征信息的入库
/// Input：json
/// Output: 
/// w ##class(web.CDSS.MachineLearning.InteplatformService).SaveSignInfo()
ClassMethod SaveSignInfo(json As %String) As %String
{
    s json=[].%FromJSON(json)
    //获得推送内容
    s IDNO=json.%Get("IDNO")
    s PatientDR=json.%Get("PatientDR")
    s VisitID=json.%Get("VisitID")
    //s:VisitID="" VisitID=$o(^WDT.CDSS.SignInfoI("PatVisDRIndex",PatientDR,""),-1)+1   //获取最后一次就诊次+1
    s VisitType=json.%Get("VisitType")
    s BodyTemperature=json.%Get("BodyTemperature")
    s BloodPressure=json.%Get("BloodPressure")
    s Pulse=json.%Get("Pulse")
    s BreathFeature=json.%Get("BreathFeature")
    s HeartRate=json.%Get("HeartRate")
    s OxygenSaturation=json.%Get("OxygenSaturation")
    s Pupil=json.%Get("Pupil")
    s CornealReflex=json.%Get("CornealReflex")
    s Height=json.%Get("Height")
    s Weight=json.%Get("Weight")
    s MeasureDate=json.%Get("MeasureDate")
    s PassFlag=json.%Get("PassFlag")
    s DiastolicBlood=json.%Get("DiastolicBlood")
    s SystolicBlood=json.%Get("SystolicBlood")
    //新增
    s Signobj = ##class(WDT.CDSS.SignInfo).%New()
    s Signobj.IDNO= IDNO
    s Signobj.PatientDR =PatientDR
    s Signobj.VisitID =VisitID
    s Signobj.VisitType =VisitType
    s Signobj.BodyTemperature =BodyTemperature 
    s Signobj.BloodPressure=BloodPressure
    s Signobj.Pulse=Pulse
    s Signobj.BreathFeature=BreathFeature
    s Signobj.HeartRate=HeartRate
    s Signobj.OxygenSaturation=OxygenSaturation
    s Signobj.Pupil=Pupil
    s Signobj.CornealReflex=CornealReflex
    s Signobj.Height=Height
    s Signobj.Weight=Weight
    s Signobj.MeasureDate =MeasureDate
    s Signobj.PassFlag=PassFlag
    s Signobj.DiastolicBlood=DiastolicBlood
    s Signobj.SystolicBlood=SystolicBlood
    
    s sc=Signobj.%Save()
    q ""
}

/// Creator:阚延新
/// CreatDate:2021-09-22
/// Description：用于护理系统推送的患者体征信息的入库（根据推送时间入库）
/// Input：json
/// Output: 
/// w ##class(web.CDSS.MachineLearning.InteplatformService).SaveSignInfo()
ClassMethod SaveSignInfo1(json As %String) As %String
{
    s json=[].%FromJSON(json)
    //获得推送内容
    s IDNO=json.%Get("IDNO")
    s PatientDR=json.%Get("PatientDR")
    s VisitID=json.%Get("VisitID")
	;s:VisitID="" VisitID=$o(^WDT.CDSS.SignInfo("PatVisDRIndex",PatientDR,""),-1)   //获取最后一次就诊次
    s VisitType=json.%Get("VisitType")
    s BodyTemperature=json.%Get("BodyTemperature")
    s BloodPressure=json.%Get("BloodPressure")
    s Pulse=json.%Get("Pulse")
    s BreathFeature=json.%Get("BreathFeature")
    s HeartRate=json.%Get("HeartRate")
    s OxygenSaturation=json.%Get("OxygenSaturation")
    s Pupil=json.%Get("Pupil")
    s CornealReflex=json.%Get("CornealReflex")
    s Height=json.%Get("Height")
    s Weight=json.%Get("Weight")
    s MeasureDate=json.%Get("MeasureDate")
    s PassFlag=json.%Get("PassFlag")
    s DiastolicBlood=json.%Get("DiastolicBlood")
    s SystolicBlood=json.%Get("SystolicBlood")
    s:VisitID="" VisitID=1
    if (Height="")
    {
	    if (MeasureDate'="")
	    {
		    s Dates=$p(MeasureDate," ",1)
		    s Date=""
		    for 
		    {
			    q:Height'=""
			    s Date=$o(^WDT.CDSS.SignInfoI("PatVisDRTypeTimeIndex",PatientDR,VisitID,VisitType,Date))
			    q:Date=""
			    CONTINUE:Date'[Dates
			    s signID="" 
			    for
				{
					s signID=$o(^WDT.CDSS.SignInfoI("PatVisDRTypeTimeIndex",PatientDR,VisitID,Date,VisitType,signID))
					q:signID=""
					s Height= $lg($g(^WDT.CDSS.SignInfoD(signID)),14)
					q:Height'=""
				}
			}
		}	    
	}
	if (Weight="")
    {
	    if (MeasureDate'="")
	    {
		    s Dates=$p(MeasureDate," ",1)
		    s Date=""
		    for 
		    {
			    q:Weight'=""
			    s Date=$o(^WDT.CDSS.SignInfoI("PatVisDRTypeTimeIndex",PatientDR,VisitID,VisitType,Date))
			    q:Date=""
			    CONTINUE:Date'[Dates
			    s signID=""
			    for
				{
					s signID=$o(^WDT.CDSS.SignInfoI("PatVisDRTypeTimeIndex",PatientDR,VisitID,VisitType,Date,signID))
					q:signID=""
					s Weight= $lg($g(^WDT.CDSS.SignInfoD(signID)),15)
					q:Weight'=""
				}
			}
		}	    
	}
	if (DiastolicBlood="")
    {
	    if (MeasureDate'="")
	    {
		    s Dates=$p(MeasureDate," ",1)
		    s Date=""
		    for 
		    {
			    q:DiastolicBlood'=""
			    s Date=$o(^WDT.CDSS.SignInfoI("PatVisDRTypeTimeIndex",PatientDR,VisitID,VisitType,Date))
			    q:Date=""
			    CONTINUE:Date'[Dates
			    s signID=""
			    for
				{
					s signID=$o(^WDT.CDSS.SignInfoI("PatVisDRTypeTimeIndex",PatientDR,VisitID,VisitType,Date,signID))
					q:signID=""
					s DiastolicBlood= $lg($g(^WDT.CDSS.SignInfoD(signID)),18)
					q:DiastolicBlood'=""
				}
			}
		}	    
	}
	if (SystolicBlood="")
    {
	    if (MeasureDate'="")
	    {
		    s Dates=$p(MeasureDate," ",1)
		    s Date=""
		    for 
		    {
			    q:SystolicBlood'=""
			    s Date=$o(^WDT.CDSS.SignInfoI("PatVisDRTypeTimeIndex",PatientDR,VisitID,VisitType,Date))
			    q:Date=""
			    CONTINUE:Date'[Dates
			    s signID=""
			    for
				{
					s signID=$o(^WDT.CDSS.SignInfoI("PatVisDRTypeTimeIndex",PatientDR,VisitID,VisitType,Date,signID))
					q:signID=""
					s SystolicBlood= $lg($g(^WDT.CDSS.SignInfoD(signID)),19)
					q:SystolicBlood'=""
				}
			}
		}	    
	}
    s ID=$o(^WDT.CDSS.SignInfoI("PatVisDRTypeTimeIndex",PatientDR,VisitID,VisitType,MeasureDate,0))
    if (ID'="")
    {
	    //修改
	    s Signobj = ##class(WDT.CDSS.SignInfo).%OpenId(ID)
	    s:BodyTemperature="" BodyTemperature=Signobj.BodyTemperature 
	    s:BloodPressure="" BloodPressure=SystolicBlood_"/"_DiastolicBlood    
	    s:Pulse="" Pulse=Signobj.Pulse    
	    s:BreathFeature="" BreathFeature=Signobj.BreathFeature    
	    s:HeartRate="" HeartRate=Signobj.HeartRate    
	    s:OxygenSaturation="" OxygenSaturation=Signobj.OxygenSaturation    
	    s:Pupil="" Pupil=Signobj.Pupil 
	    s:CornealReflex="" CornealReflex=Signobj.CornealReflex   
	    ;s:Height="" Height=Signobj.Height    
	    ;s:Weight="" Weight=Signobj.Weight    
	    ;s:DiastolicBlood="" DiastolicBlood=Signobj.DiastolicBlood  
	    ;s:SystolicBlood="" SystolicBlood=Signobj.SystolicBlood  
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
    s Signobj.BloodPressure=BloodPressure
    s Signobj.Pulse=Pulse
    s Signobj.BreathFeature=BreathFeature
    s Signobj.HeartRate=HeartRate
    s Signobj.OxygenSaturation=OxygenSaturation
    s Signobj.Pupil=Pupil
    s Signobj.CornealReflex=CornealReflex
    s Signobj.Height=Height
    s Signobj.Weight=Weight
    s Signobj.MeasureDate =MeasureDate
    s Signobj.PassFlag=PassFlag
    s Signobj.DiastolicBlood=DiastolicBlood
    s Signobj.SystolicBlood=SystolicBlood
    
    s sc=Signobj.%Save()
    q ""
}

/// Creator:阚延新
/// CreatDate:2022-01-07
/// Description：用于护理系统推送的患者体征信息的入库（根据推送时间入库）
/// Input：json
/// Output: 
/// w ##class(web.CDSS.MachineLearning.InteplatformService).SaveSignInfo()
ClassMethod SaveSignInfo2(json As %String) As %String
{
    s json=[].%FromJSON(json)
    //获得推送内容
    s IDNO=json.%Get("IDNO")
    s PatientDR=json.%Get("PatientDR")
    s VisitID=json.%Get("VisitID")
    s VisitType=json.%Get("VisitType")
    s VisitType=$case(VisitType,1:"急诊",2:"门诊",3:"住院",:"住院")
    //V1.2不需要同步识别词
    s BodyTemperature=json.%Get("BodyTemperature")
    s BloodPressure=json.%Get("BloodPressure")
    s Pulse=json.%Get("Pulse")
    s BreathFeature=json.%Get("BreathFeature")
    s HeartRate=json.%Get("HeartRate")
    s OxygenSaturation=json.%Get("OxygenSaturation")
    s Pupil=json.%Get("Pupil")
    s CornealReflex=json.%Get("CornealReflex")
    s Height=json.%Get("Height")
    s Weight=json.%Get("Weight")
    s MeasureDate=json.%Get("MeasureDate")
    s Date=$p(MeasureDate," ",1)_" 00:00:00"
    s PassFlag=json.%Get("PassFlag")
    s DiastolicBlood=json.%Get("DiastolicBlood")
    s SystolicBlood=json.%Get("SystolicBlood")
    //V2.0同步识别词
    s BodyTemperature=json.%Get("BodyTemperature")
    d:BodyTemperature'="" ..SaveSatisfyIW("WDT.CDSS.SignInfo","BodyTemperature",IDNO,PatientDR,VisitID,VisitType)
    s BloodPressure=json.%Get("BloodPressure")
    d:BodyTemperature'="" ..SaveSatisfyIW("WDT.CDSS.SignInfo","BodyTemperature",IDNO,PatientDR,VisitID,VisitType)
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
    s Date=$p(MeasureDate," ",1)_" 00:00:00"
    s PassFlag=json.%Get("PassFlag")
    s DiastolicBlood=json.%Get("DiastolicBlood")
    d:DiastolicBlood'="" ..SaveSatisfyIW("WDT.CDSS.SignInfo","DiastolicBlood",IDNO,PatientDR,VisitID,VisitType)
    s SystolicBlood=json.%Get("SystolicBlood")
    d:SystolicBlood'="" ..SaveSatisfyIW("WDT.CDSS.SignInfo","SystolicBlood",IDNO,PatientDR,VisitID,VisitType)
    s:VisitID="" VisitID=1
    s ID=$o(^WDT.CDSS.SignInfoI("PatVisDRTypeTimeIndex",PatientDR,VisitID,VisitType,Date,0))
    if (ID'="")
    {
	    //修改
	    s Signobj = ##class(WDT.CDSS.SignInfo).%OpenId(ID)
	    s:BodyTemperature="" BodyTemperature=Signobj.BodyTemperature 
	    s:BloodPressure="" BloodPressure=Signobj.BloodPressure 	    
	    s:Pulse="" Pulse=Signobj.Pulse    
	    s:BreathFeature="" BreathFeature=Signobj.BreathFeature    
	    s:HeartRate="" HeartRate=Signobj.HeartRate    
	    s:OxygenSaturation="" OxygenSaturation=Signobj.OxygenSaturation    
	    s:Pupil="" Pupil=Signobj.Pupil 
	    s:CornealReflex="" CornealReflex=Signobj.CornealReflex   
	    s:Height="" Height=Signobj.Height    
	    s:Weight="" Weight=Signobj.Weight    
	    s:DiastolicBlood="" DiastolicBlood=Signobj.DiastolicBlood  
	    s:SystolicBlood="" SystolicBlood=Signobj.SystolicBlood  
	    
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
    s Signobj.BloodPressure=BloodPressure
    s Signobj.Pulse=Pulse
    s Signobj.BreathFeature=BreathFeature
    s Signobj.HeartRate=HeartRate
    s Signobj.OxygenSaturation=OxygenSaturation
    s Signobj.Pupil=Pupil
    s Signobj.CornealReflex=CornealReflex
    s Signobj.Height=Height
    s Signobj.Weight=Weight
    s Signobj.MeasureDate =Date
    s Signobj.PassFlag=PassFlag
    s Signobj.DiastolicBlood=DiastolicBlood
    s Signobj.SystolicBlood=SystolicBlood
    s Signobj.BloodPressure=SystolicBlood_"/"_DiastolicBlood

    s sc=Signobj.%Save()
    q ""
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

/// Creator:阚延新
/// CreatDate:2021-02-20
/// Description：用于护理系统推送的护理记录信息的入库
/// Input：json
/// Output: 
/// w ##class(web.CDSS.MachineLearning.InteplatformService).SaveNursingInfo()
ClassMethod SaveNursingInfo(json As %String) As %String
{
	s json=[].%FromJSON(json)
	s IDNO=json.%Get("IDNO")
    s PatientDR=json.%Get("PatientDR")
    s VisitID=json.%Get("VisitID")
    s VisitType=json.%Get("VisitType")
    s PassFlag=json.%Get("PassFlag")
    s Children=json.%Get("Children")
    for i=0:1:(Children.%Size()-1)
    {
		s NursingItemCode=Children.%Get(i).%Get("NursingItemCode")
		s NursingItemName=Children.%Get(i).%Get("NursingItemName")
		s ChildItem=Children.%Get(i).%Get("ChildItem")
		for j=0:1:(ChildItem.%Size()-1)
		{
			s ChildItemNum=ChildItem.%Get(j).%Get("ChildItemNum")
			s ChildItemCode=ChildItem.%Get(j).%Get("ChildItemCode")
			s ChildItemName=ChildItem.%Get(j).%Get("ChildItemName")
			s NursingDate=ChildItem.%Get(j).%Get("NursingDate")
			s NursingEffect=ChildItem.%Get(j).%Get("NursingEffect")
			
			//保存护理信息
			s obj=##class(WDT.CDSS.NursingInfo).%New()
			s obj.IDNO=IDNO
			s obj.PatientDR=PatientDR
			s obj.VisitID=VisitID
			s obj.VisitType=VisitType
			s obj.NursingItemCode=NursingItemCode
			s obj.NursingItemName=NursingItemName
			s obj.ChildItemNum=ChildItemNum
			s obj.ChildItemCode=ChildItemCode
			s obj.ChildItemName=ChildItemName
			s obj.NursingDate=NursingDate
			s obj.NursingEffect=NursingEffect
			s obj.PassFlag=PassFlag
			d obj.%Save()    
		}
	}
	q "success"
}

/// Creator:阚延新
/// CreatDate:2021-02-20
/// Description：用于护理系统推送的医嘱执行信息的入库
/// Input：json
/// Output: 
/// w ##class(web.CDSS.MachineLearning.InteplatformService).SaveDrugInfo()
ClassMethod SaveDrugInfo(json As %String) As %String
{
    s json=[].%FromJSON(json)
    //获得推送内容
    s IDNO=json.%Get("IDNO")
    s PatientDR=json.%Get("PatientDR")
    s VisitID=json.%Get("VisitID")
    ;s VisitID=$o(^WDT.CDSS.SignInfo("PatVisDRIndex",PatientDR,""),-1)+1   //获取最后一次就诊次+1
    s VisitType=json.%Get("VisitType")
    s Type=json.%Get("Type")
    s OrderType=json.%Get("OrderType")
    s GroupFlag=json.%Get("GroupFlag")
    s str1=$P(GroupFlag,"||",1)
    s str2=$P(GroupFlag,"||",2)
    s GroupFlag=str1_"||"_str2
    s GroupSequence=json.%Get("GroupSequence")
    s Code=json.%Get("DrugCode")
    s Name=json.%Get("DrugName")
    s ExecuteTime=json.%Get("ExecuteTime")
    s ExecuteStatus=json.%Get("ExecuteStatus")
    if (ExecuteStatus="撤销执行")
	{
		s Type=""
		s ExecuteTime=""
	}
    //修改
	if (OrderType="药品")
	{
    	s DrugID = $o(^WDT.CDSS.DrugInfoI("UniqueIDNOIndex"," "_IDNO," "_GroupFlag,0))
		q:DrugID="" "该处方不存在"
		s Drugobj = ##class(WDT.CDSS.DrugInfo).%OpenId(DrugID)

		s Drugobj.Type=Type
    	s Drugobj.ExecuteTime=ExecuteTime
		s sc=Drugobj.%Save()
    	q ""
	}
	if (OrderType="检查")
	{
    	s ExamID = $o(^WDT.CDSS.ExamInfoI("UniqueIDNOIndex"," "_IDNO," "_GroupFlag,0))
		q:ExamID="" "该检查不存在"
		s Examobj = ##class(WDT.CDSS.ExamInfo).%OpenId(ExamID)
		s Examobj.Type=Type
    	s Examobj.ExecuteTime=ExecuteTime
    	s sc=Examobj.%Save()
	    q ""
	}
	if (OrderType="检验")
	{
		// 检验存在多条 都要保存执行时间 2023-04-04
		s LabID=0
		for
		{
	    	s LabID = $o(^WDT.CDSS.LabInfoI("UniqueIDNOIndex"," "_IDNO," "_GroupFlag,LabID))
			q:LabID=""
			s Labobj = ##class(WDT.CDSS.LabInfo).%OpenId(LabID)
			s Labobj.Type=Type
	    	s Labobj.ExecuteTime=ExecuteTime
	    	s sc=Labobj.%Save()
		}
	    q ""
	}
	if (OrderType="手术")
	{
    	s OperationID = $o(^WDT.CDSS.OperationInfoI("UniqueIDNOIndex"," "_IDNO,1," "_Code,0))
		q:OperationID="" "该手术不存在"
		s Operationobj = ##class(WDT.CDSS.OperationInfo).%OpenId(OperationID)
		s Operationobj.Type=Type
		s Operationobj.OperStartTime=ExecuteTime
    	s sc=Operationobj.%Save()
		q ""
	}
	if (OrderType="麻醉")
	{
		s AnestID = $o(^WDT.CDSS.AnestInfoI("PatVisDRTypeIndex",PatientDR,VisitID,VisitType,0))
		q:AnestID="" "该麻醉信息不存在"
		s Anestobj = ##class(WDT.CDSS.AnestInfo).%OpenId(AnestID)
		s Anestobj.Type=Type
		s Anestobj.AnestStartTime=ExecuteTime
    	s sc=Anestobj.%Save()
		q ""	
	}
	if (OrderType="护理")
	{
		s NursingID = $o(^WDT.CDSS.NursingInfoI("IDNONursNumIndex"," "_IDNO,1," "_Code,0))
		q:NursingID="" "该护理信息不存在"
		s Nursingtobj = ##class(WDT.CDSS.NursingInfo).%OpenId(NursingID)
		s Nursingtobj.Type=Type
		s Nursingtobj.NursingDate=ExecuteTime
    	s sc=Nursingtobj.%Save()
		q ""       
	}
	/*if (OrderType="输血")
	{
		s BloodTransID = $o(^User.DHCDSSBloodTransInfoI("PatVisDRIndex",PatientDR,VisitID,0))
		q:BloodTransID="" "该输血信息不存在"
		s BloodTransobj = ##class(User.DHCDSSBloodTransInfo).%OpenId(BloodTransID)
		s BloodTransobj.BloodTransStartTime=ExecuteTime
    	s sc=BloodTransobj.%Save()
		q ""
	}*/
	if (OrderType="膳食")
	{
		s DietID = $o(^WDT.CDSS.DietInfoI("UniqueIDNOIndex"," "_IDNO," "_GroupFlag,0))
		q:DietID="" "该饮食信息不存在"
		s Dietobj = ##class(WDT.CDSS.DietInfo).%OpenId(DietID)
		s Dietobj.Type=Type
    	s Dietobj.StartTime=ExecuteTime
    	s sc=Dietobj.%Save()
	    q ""
	}
	if (OrderType="处置")
	{
		s OtherOrderID = $o(^WDT.CDSS.OtherOrderInfoI("UniqueIDNOIndex"," "_IDNO," "_GroupFlag,0))
		q:OtherOrderID="" "该处置信息不存在"
		s OtherOrderobj = ##class(WDT.CDSS.OtherOrderInfo).%OpenId(OtherOrderID)
		s OtherOrderobj.Type=Type
    	s OtherOrderobj.ExecuteTime=ExecuteTime
    	s sc=OtherOrderobj.%Save()
	    q ""
	}
	q "其他类型医嘱"
}

/// Creator:阚延新
/// CreatDate:2021-02-20
/// Description：用于护理系统推送的护理文书信息的入库
/// Input：json
/// Output: 
/// w ##class(web.CDSS.MachineLearning.InteplatformService).SaveInpatientInfo()
ClassMethod SaveInpatientInfo(json As %String) As %String
{
    s json=[].%FromJSON(json)
    //获得推送内容
    s IDNO=json.%Get("IDNO")
    s PatientDR=json.%Get("PatientDR")
    s VisitID=json.%Get("VisitID")
    //s VisitID=$o(^WDT.CDSS.SignInfo("PatVisDRIndex",PatientDR,""),-1)+1   //获取最后一次就诊次+1
    s VisitType=json.%Get("VisitType")
    s MRNum=json.%Get("MRNum")
    s MRClass=json.%Get("MRClass")
    s MRFileNum=json.%Get("MRFileNum")
    s MRCode=json.%Get("MRCode")
    s MRTempletName=json.%Get("MRTempletName")
    s MRDesc=json.%Get("MRDesc")
    s HosID=$lg($g(^CF.WDT.CDSS.MKBConfigD(14)),3)
    //新增
	s Inpatientobj = ##class(WDT.CDSS.InpatientInfo).%New()
	s Inpatientobj.IDNO= IDNO
	s Inpatientobj.PatientDR =PatientDR
	s Inpatientobj.VisitID =VisitID
	s Inpatientobj.VisitType =VisitType
	s Inpatientobj.MRNum=MRNum
	s Inpatientobj.MRClass=MRClass
	s Inpatientobj.MRFileNum=MRFileNum
	s Inpatientobj.MRCode=MRCode
	s Inpatientobj.MRTempletName=MRTempletName
	s Inpatientobj.MRDesc=MRDesc
	s sc=Inpatientobj.%Save()
	If $$$ISOK(sc)
	{
		//口腔护理,清洁灌肠。CDSS测试
		s NursingItemNames=$p(MRDesc,"。",1)
		s size=$l(NursingItemNames,",")
		for i=1:1:size
	    {
		    s NursingItemName=$p(NursingItemNames,",",i)
		    q:NursingItemName=""
			s NursingItemName=##class(web.CDSS.IMP.ContrastDict).GetDiectName(NursingItemName)
			q:NursingItemName=""
  			s NursingItemCode=##class(web.CDSS.IMP.ContrastDict).GetMatchCode(NursingItemName)
  			q:NursingItemCode=""
  			s NursingItemName=$p(NursingItemName,",",1)
  			s NursingItemCode=$p(NursingItemCode,",",1)
			s obj=##class(WDT.CDSS.NursingInfo).%New()
			s obj.IDNO=IDNO
			s obj.PatientDR=PatientDR
			s obj.VisitID=VisitID
			s obj.VisitType=VisitType
			s obj.NursingItemCode=NursingItemCode
			s obj.NursingItemNum=i
			s obj.NursingItemName=NursingItemName
			s obj.ChildItemNum=""
			s obj.ChildItemCode=""
			s obj.ChildItemName=""
			s obj.NursingDate=$ZDATETIME($HOROLOG,3)
			s obj.NursingEffect=""
			s obj.PassFlag=""
			d obj.%Save()  		  
	    }	
	}
   	q ""
}

/// Creator:阚延新
/// CreatDate:2021-03-18
/// Description：用于输血系统推送的配血信息的入库
/// Input：json
/// Output: 
/// w ##class(web.CDSS.MachineLearning.InteplatformService).SaveBloodTransInfo()
ClassMethod SaveBloodTransInfo(json As %String) As %String
{
    s json=[].%FromJSON(json)
    //获得推送内容
    s IDNO=json.%Get("IDNO")
    s PatientDR=json.%Get("PatientDR")
    s VisitID=json.%Get("VisitID")
    //s VisitID=$o(^WDT.CDSS.SignInfoI("PatVisDRIndex",PatientDR,""),-1)+1   //获取最后一次就诊次+1
    s VisitType=json.%Get("VisitType")
    s BloodTransVolume=json.%Get("BloodTransVolume")
    s BloodTransVolumeU=json.%Get("BloodTransVolumeU")
    s BloodTransSite=json.%Get("BloodTransSite")
    s BloodTransType=json.%Get("BloodTransType")
    s BloodTransTypeRh=json.%Get("BloodTransTypeRh")
    s BloodTransClass=json.%Get("BloodTransClass")
    s PassFlag=json.%Get("PassFlag")
    
    s BloodTransID = $o(^WDT.CDSS.BloodTransInfoI("PatVisDRTypeIndex",PatientDR,VisitID,VisitType,0))
    q:BloodTransID="" "该输血信息不存在"
    s BloodTransobj = ##class(WDT.CDSS.BloodTransInfo).%OpenId(BloodTransID)
    s BloodTransobj.BloodTransVolume=BloodTransVolume
    s BloodTransobj.BloodTransVolumeU=BloodTransVolumeU
    s BloodTransobj.BloodTransSite=BloodTransSite
    s BloodTransobj.BloodTransType=BloodTransType
    s BloodTransobj.BloodTransTypeRh=BloodTransTypeRh
    s BloodTransobj.BloodTransClass=BloodTransClass
    s BloodTransobj.PassFlag=PassFlag
	s sc=BloodTransobj.%Save()
    q ""
}

/// Creator:Xuwenhu
/// CreatDate:2021-08-04
/// Description：手术执行信息入库方法
/// Input：json-手术执行信息串
/// Output: 
/// w ##class(web.CDSS.MachineLearning.InteplatformService).SaveOperExecInfo()
ClassMethod SaveOperExecInfo(json As %String) As %String
{
	s json=[].%FromJSON(json)
	s IDNO=json.%Get("IDNO")
    s PatientDR=json.%Get("PatientDR")
    s VisitID=json.%Get("VisitID")
    //s VisitID=$o(^User.DHCDSSOperationInfoI("PatVisDRIndex",PatientDR,""),-1)+1   //获取最后一次就诊次+1
    s VisitType=json.%Get("VisitType")
    s PassFlag=json.%Get("PassFlag")
    s Children=json.%Get("Children")
    for i=0:1:(Children.%Size()-1)
    {
	    s OperNum=Children.%Get(i).%Get("OperNum")
		s OperSequence=Children.%Get(i).%Get("OperSequence")
		s:OperSequence="" OperSequence=1
		s MainOperFlag=Children.%Get(i).%Get("MainOperFlag")
		s OperCode=Children.%Get(i).%Get("OperCode")
		s OperName=Children.%Get(i).%Get("OperName")
		s OperDesc=Children.%Get(i).%Get("OperDesc")
		s OperPosition=Children.%Get(i).%Get("OperPosition")
		s IntraoperDiagnosis=Children.%Get(i).%Get("IntraoperDiagnosis")
		s OperDuration=Children.%Get(i).%Get("OperDuration")
		s OperStartTime=Children.%Get(i).%Get("OperStartTime")
		s OperEndTime=Children.%Get(i).%Get("OperEndTime")    
	
		//保存执行信息
		s OperID=$o(^WDT.CDSS.OperationInfoI("UniqueIDNOIndex"," "_IDNO,OperSequence," "_OperCode,""),-1)
		s obj=##class(WDT.CDSS.OperationInfo).%OpenId(OperID)
		/*s obj.IDNO=IDNO
		s obj.PatientDR=PatientDR
		s obj.VisitID=VisitID
		s obj.VisitType=VisitType
		s obj.OperNum=OperNum
		s obj.OperSequence=OperSequence
		s obj.MainOperFlag=MainOperFlag
		s obj.OperCode=OperCode
		s obj.OperName=OperName
		s obj.OperDesc=OperDesc*/
		s obj.OperPosition=OperPosition
		s obj.IntraoperDiagnosis=IntraoperDiagnosis
		s obj.OperStartTime=OperStartTime
		s obj.OperEndTime=OperEndTime
		s obj.PassFlag=PassFlag
		d obj.%Save()
    }
	q "success"
}

/// Creator:Xuwenhu
/// CreatDate:2021-08-04
/// Description: 手术麻醉信息入库方法
/// Table:User.DHCDSSAnestInfo
/// Input: json-麻醉信息串
/// Return:success
/// Others:w ##class(web.CDSS.MachineLearning.InteplatformService).SaveOperAnestInfo()
ClassMethod SaveOperAnestInfo(json) As %String
{
	s json=[].%FromJSON(json)
	s IDNO=json.%Get("IDNO")
    s PatientDR=json.%Get("PatientDR")
    s VisitID=json.%Get("VisitID")
    //s VisitID=$o(^User.DHCDSSAnestInfoI("PatVisDRIndex",PatientDR,""),-1)+1   //获取最后一次就诊次+1
    s VisitType=json.%Get("VisitType")
    s PassFlag=json.%Get("PassFlag")
    s Children=json.%Get("Children")
    for i=0:1:(Children.%Size()-1)
    {
		s Anesthesia=Children.%Get(i).%Get("Anesthesia")
		s AnestDuration=Children.%Get(i).%Get("AnestDuration")
		s AnestStartTime=Children.%Get(i).%Get("AnestStartTime")
		s AnestMedication=Children.%Get(i).%Get("AnestMedication")
		s Dose=Children.%Get(i).%Get("Dose")
		s Usage=$o(^CT.WDT.CDSS.UsageDictI("CodeIndex"," "_Children.%Get(i).%Get("Usage"),0))
		s AnestSite=Children.%Get(i).%Get("AnestSite")
		
		//保存麻醉信息
		s obj=##class(WDT.CDSS.AnestInfo).%New()
		s obj.IDNO=IDNO
		s obj.PatientDR=PatientDR
		s obj.VisitID=VisitID
		s obj.VisitType=VisitType
		s obj.Anesthesia=Anesthesia
		s obj.AnestDuration=AnestDuration
		s obj.AnestStartTime=AnestStartTime
		s obj.AnestMedication=AnestMedication
		s obj.Dose=Dose
		d obj.UsageSetObjectId(Usage)
		s obj.PassFlag=PassFlag
		d obj.%Save()    
	}
	q "success"
}

/// Creator:Xuwenhu
/// CreatDate:2021-08-04
/// Description: 手术护理信息入库方法
/// Table:User.DHCDSSNursingInfo
/// Input: json-护理信息串
/// Return:success
/// Others:w ##class(web.CDSS.MachineLearning.InteplatformService).SaveNursingMeaInfo()
ClassMethod SaveNursingMeaInfo(json) As %String
{
	s json=[].%FromJSON(json)
	s IDNO=json.%Get("IDNO")
    s PatientDR=json.%Get("PatientDR")
    s VisitID=json.%Get("VisitID")
    //s VisitID=$o(^User.DHCDSSAnestInfoI("PatVisDRIndex",PatientDR,""),-1)+1   //获取最后一次就诊次+1
    s VisitType=json.%Get("VisitType")
    s PassFlag=json.%Get("PassFlag")
    s Children=json.%Get("Children")
    for i=0:1:(Children.%Size()-1)
    {
		s NursingItemCode=Children.%Get(i).%Get("NursingItemCode")
		s NursingItemName=Children.%Get(i).%Get("NursingItemName")
		s ChildItem=Children.%Get(i).%Get("ChildItem")
		for j=0:1:(ChildItem.%Size()-1)
		{
			s ChildItemNum=ChildItem.%Get(j).%Get("ChildItemNum")
			s ChildItemCode=ChildItem.%Get(j).%Get("ChildItemCode")
			s ChildItemName=ChildItem.%Get(j).%Get("ChildItemName")
			s NursingDate=ChildItem.%Get(j).%Get("NursingDate")
			s NursingEffect=ChildItem.%Get(j).%Get("NursingEffect")
			
			//保存护理信息
			s obj=##class(WDT.CDSS.NursingInfo).%New()
			s obj.IDNO=IDNO
			s obj.PatientDR=PatientDR
			s obj.VisitID=VisitID
			s obj.VisitType=VisitType
			s obj.NursingItemCode=NursingItemCode
			s obj.NursingItemName=NursingItemName
			s obj.ChildItemNum=ChildItemNum
			s obj.ChildItemCode=ChildItemCode
			s obj.ChildItemName=ChildItemName
			s obj.NursingDate=NursingDate
			s obj.NursingEffect=NursingEffect
			s obj.PassFlag=PassFlag
			d obj.%Save()    
		}
	}
	q "success"
}

/// Creator:Xuwenhu
/// CreatDate:2021-08-04
/// Description: 手术输血信息入库方法
/// Table:User.DHCDSSBloodTransInfo
/// Input: json-手术输血信息串
/// Return:success
/// Others:w ##class(web.CDSS.MachineLearning.InteplatformService).SaveOperBloodInfo()
ClassMethod SaveOperBloodInfo(json) As %String
{
	s json=[].%FromJSON(json)
	s IDNO=json.%Get("IDNO")
    s PatientDR=json.%Get("PatientDR")
    s VisitID=json.%Get("VisitID")
    //s VisitID=$o(^User.DHCDSSBloodTransInfoI("PatVisDRIndex",PatientDR,""),-1)+1   //获取最后一次就诊次+1
    s VisitType=json.%Get("VisitType")
    s PassFlag=json.%Get("PassFlag")
    s Children=json.%Get("Children")
    for i=0:1:(Children.%Size()-1)
    {
	    s BloodTransStartTime=Children.%Get(i).%Get("BloodTransStartTime")
		s BloodTransEndTime=Children.%Get(i).%Get("BloodTransEndTime")
		s BloodTransDuration=Children.%Get(i).%Get("BloodTransDuration")
		s BloodTransDurationU=Children.%Get(i).%Get("BloodTransDurationU")
		s BloodTransVolume=Children.%Get(i).%Get("BloodTransVolume")
		s BloodTransVolumeU=Children.%Get(i).%Get("BloodTransVolumeU")
		s BloodTransType=Children.%Get(i).%Get("BloodTransType")
		s BloodTransTypeRh=Children.%Get(i).%Get("BloodTransTypeRh")
		s BloodTransClass=Children.%Get(i).%Get("BloodTransClass")
		s BTIndication=Children.%Get(i).%Get("BTIndication")
		s BTIndicationValue=Children.%Get(i).%Get("BTIndicationValue")
		s BTIndicationValueUnit=Children.%Get(i).%Get("BTIndicationValueUnit")
		
		//新增
		s obj=##class(WDT.CDSS.BloodTransInfo).%New()
		s obj.IDNO=IDNO
		s obj.PatientDR=PatientDR
		s obj.VisitID=VisitID
		s obj.VisitType=VisitType
		s obj.BloodTransStartTime=BloodTransStartTime
		s obj.BloodTransEndTime=BloodTransEndTime
		s obj.BloodTransDuration=BloodTransDuration
		s obj.BloodTransDurationU=BloodTransDurationU
		s obj.BloodTransVolume=BloodTransVolume
		s obj.BloodTransType=BloodTransType
		s obj.BloodTransTypeRh=BloodTransTypeRh
		s obj.BloodTransClass=BloodTransClass
		s obj.BTIndication=BTIndication
		s obj.BTIndicationValue=BTIndicationValue
		s obj.BTIndicationValueUnit=BTIndicationValueUnit
		d obj.%Save()
    }
	q "success"
}

/// Creator:阚延新
/// CreatDate:2021-08-19
/// Description：用于检查报告入库
/// Input：json
/// Output: 
/// w ##class(web.CDSS.MachineLearning.InteplatformService).SaveExamInfo()
ClassMethod SaveExamInfo(json As %String) As %String
{
    s json=[].%FromJSON(json)
    s GroupFlag=json.%Get("GroupFlag")
	s ExamInfoID = $o(^WDT.CDSS.ExamInfoI("GroupFlagIndex"," "_GroupFlag,""),-1)    
    q:ExamInfoID="" ""
    s IDNO = $lg($g(^WDT.CDSS.ExamInfoD(ExamInfoID)),2)
    s PatientDR  = $lg($g(^WDT.CDSS.ExamInfoD(ExamInfoID)),3)
    s VisitID = $lg($g(^WDT.CDSS.ExamInfoD(ExamInfoID)),4)
    s VisitType = $lg($g(^WDT.CDSS.ExamInfoD(ExamInfoID)),5)
    s GroupSequence = $lg($g(^WDT.CDSS.ExamInfoD(ExamInfoID)),7)
    s ExamCode = $lg($g(^WDT.CDSS.ExamInfoD(ExamInfoID)),8)
    s ExamName = $lg($g(^WDT.CDSS.ExamInfoD(ExamInfoID)),9)
    s ExamResult = $lg($g(^WDT.CDSS.ExamInfoD(ExamInfoID)),10)
    s PartDR = $lg($g(^WDT.CDSS.ExamInfoD(ExamInfoID)),11)
    s ExecuteTime = $lg($g(^WDT.CDSS.ExamInfoD(ExamInfoID)),12)
    s ReportTime = $lg($g(^WDT.CDSS.ExamInfoD(ExamInfoID)),13)
    s Remarks = $lg($g(^WDT.CDSS.ExamInfoD(ExamInfoID)),14)
    s PassFlag = $lg($g(^WDT.CDSS.ExamInfoD(ExamInfoID)),15)
    s ExamResultNum = $lg($g(^WDT.CDSS.ExamInfoD(ExamInfoID)),16)
    s ExamResultFlag = $lg($g(^WDT.CDSS.ExamInfoD(ExamInfoID)),17)
    s ExamResultDesc = $lg($g(^WDT.CDSS.ExamInfoD(ExamInfoID)),18)
    s ProjectName=$lg($g(^WDT.CDSS.ExamInfoD(ExamInfoID)),20)
    if ((ExamResult="")&&(ExamResultDesc="")) //首推
    {
        d ##class(WDT.CDSS.ExamInfo).%DeleteId(ExamInfoID)
    }
    //获得推送内容
    s ExamResult = json.%Get("ExamResult")
    s ExamResultDesc = json.%Get("ExamResultDesc") 
    s ExamResultDescs = ExamResult_ExamResultDesc
    s ExamResultDescNLP=..GetStructedDataAPI(ExamResultDescs)
    s ExamResultDescNLP=$REPLACE(ExamResultDescNLP,"""","'")
    s ExamResultDescFormal=..CollectResultToNLP(ExamResultDescNLP)
    //肱二头肌长,头肌腱腱鞘无回声,肌腱未见肿胀,撕裂
    s ExamResultFlag = json.%Get("ExamResultFlag") 
    s ExamResultNum = json.%Get("ExamResultNum") 
    s:ExecuteTime="" ExecuteTime = json.%Get("ExecuteTime") 
    s:ReportTime="" ReportTime = json.%Get("ReportTime")
    s Remarks = json.%Get("Remarks")
    s PartDR = json.%Get("PartDR")
    s PartDR=$o(^WDT.CDSS.BodyParDictI("NameIndex"," "_PartDR,0))
    s size=$l(ExamResultDescFormal,",")
    for i=1:1:size
    {
	    s SymProperty=""	    
	    s ExamResultD=$p(ExamResultDescFormal,",",i)
	    if ExamResultD["%%"
	    {
			s SymProperty=$p(ExamResultD,"%%",2) //属性
			s ExamResultD=$p(ExamResultD,"%%",1) //检查结果
		}
	     //检查结果进行检查检验结果字典的筛选
	    if ExamResultD["&%"
	    {
		    s ResultID=""
		    for sum=1:1:$l(ExamResultD,"&%")
		    {
			    s ExamResultNow=$p(ExamResultD,"&%",sum)
			    s ResultID=$o(^CT.WDT.CDSS.ExamResultDictI("DescIndex"," "_$ZCONVERT(ExamResultNow,"U"),0)) //检查结果字典筛选
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
		
	    //新增
	    s Examobj = ##class(WDT.CDSS.ExamInfo).%New()
		s Examobj.IDNO= IDNO
	    s Examobj.PatientDR =PatientDR
	    s Examobj.VisitID =VisitID
	    s Examobj.VisitType =VisitType
	    s Examobj.GroupFlag =GroupFlag
	    s Examobj.GroupSequence =GroupSequence
		s Examobj.ExamCode= ExamCode
		s Examobj.ExamName= ExamName
		s Examobj.ExamResult= ExamResultD
		s Examobj.ExecuteTime=ExecuteTime
	    s Examobj.ReportTime=ReportTime
	    s Examobj.Remarks = Remarks	
	    s Examobj.ExamResultDesc= ExamResultDescs
	    s Examobj.ExamResultFlag= ExamResultFlag
	    s Examobj.ExamResultNum= ExamResultNum
	    s Examobj.PassFlag= PassFlag
	    s Examobj.ProjectName=ProjectName
	    s Examobj.SymProperty=SymProperty
	    s sc=Examobj.%Save()
	    d Examobj.%Close()  
	    If $$$ISOK(sc)
	    {
	    }
	    else
	    {
	   	    w ##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	    } 
    }
    d ##class(web.CDSS.MachineLearning.PlatformService).SaveSatisfyIW("WDT.CDSS.ExamInfo","ExamResult",IDNO,PatientDR,VisitID,VisitType)
    q "success"
}

/// Creator:阚延新
/// CreatDate:2021-08-19
/// Description：用于检验报告入库
/// Input：json
/// Output: 
/// w ##class(web.CDSS.MachineLearning.InteplatformService).SaveLabInfo()
ClassMethod SaveLabInfo(json As %String) As %String
{
    s json=[].%FromJSON(json)
    s GroupFlag=json.%Get("GroupFlag")
    s LabInfoID = $o(^WDT.CDSS.LabInfoI("GroupFlagIndex"," "_$ZCONVERT(GroupFlag,"U"),""),-1)
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
    s ExecuteTime = json.%Get("ExecuteTime")
    s ReportTime = json.%Get("ReportTime")
    s:ExecuteTime="" ExecuteTime = $lg($g(^WDT.CDSS.LabInfoD(LabInfoID)),16)
    s:ReportTime="" ReportTime = $lg($g(^WDT.CDSS.LabInfoD(LabInfoID)),17)
    s Remarks = $lg($g(^WDT.CDSS.LabInfoD(LabInfoID)),18)
    s PassFlag = $lg($g(^WDT.CDSS.LabInfoD(LabInfoID)),19)
    s LabResultFlag = $lg($g(^WDT.CDSS.LabInfoD(LabInfoID)),20)
    s ProjectName=$lg($g(^WDT.CDSS.LabInfoD(LabInfoID)),21)
    s LabItemName = $lg($g(^WDT.CDSS.LabInfoD(LabInfoID)),11)
    s RLabResult=$lg($g(^WDT.CDSS.LabInfoD(LabInfoID)),12)		//检验结果
    if (RLabResult="")  //首推
    {
       s LabID=0
	    for
	    {
		    s LabID=$o(^WDT.CDSS.LabInfoI("GroupFlagIndex"," "_$ZCONVERT(GroupFlag,"U"),LabID))
		    q:LabID=""
        	d ##class(WDT.CDSS.LabInfo).%DeleteId(LabID)
	    }
    }
    //获得推送内容
    s Specimen = json.%Get("Specimen")
    s Remarks = json.%Get("Remarks")
    s ChildItem=json.%Get("ChildItem")
	for j=0:1:(ChildItem.%Size()-1)
	{
		s LabItemCode=ChildItem.%Get(j).%Get("LabItemCode")
		s LabItemName=ChildItem.%Get(j).%Get("LabItemName")
		s LabItemName=##class(web.CDSS.IMP.ContrastDict).GetDiectName(LabItemName,##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401"),"检查检验")	//对照
		s LabResult=ChildItem.%Get(j).%Get("LabResult")
		s LabResultFlag=ChildItem.%Get(j).%Get("LabResultFlag")
		s Unit=ChildItem.%Get(j).%Get("Unit")
		s Reference=ChildItem.%Get(j).%Get("Reference")
		//新增
		s Labobj = ##class(WDT.CDSS.LabInfo).%New()
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
		s Labobj.ExecuteTime = ExecuteTime
		s Labobj.ReportTime =ReportTime
		s Labobj.Remarks = Remarks
		s Labobj.PassFlag = PassFlag
		s Labobj.ProjectName=ProjectName
		s sc=Labobj.%Save()  
	}
	d ##class(web.CDSS.MachineLearning.PlatformService).SaveSatisfyIW("WDT_CDSS.LabInfo","LabResult",IDNO,PatientDR,VisitID,VisitType)
	q "success"
}

/// Creator:lideyuan
/// CreatDate:2020-05-13
/// Description：把非结构化数据通过调用nlp服务器接口，转化为结构化数据
/// Input：data: json格式数据，key:data,value:要结构化的内容
/// Output: 结构化结果json字符串
/// w ##class(web.CDSS.MachineLearning.InteplatformService).GetStructedDataAPI("f波，p波消失")
ClassMethod GetStructedDataAPI(content As %String) As %String
{
	
	s content=$zstrip(content,"<>W") //只去掉字符串前和后的控制，不去掉字符之间的空格
	q:content="" "[]"
	set httpRequest = ##class(%Net.HttpRequest).%New()
 	//s Url="http://111.205.6.207:1223/tag"
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
    { //Quit $system.OBJ.DisplayError(status)
    	//w "nlp error",! 
    	q "[]"
    }
    //s stream=##class(%GlobalCharacterStream).%New()
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
/// w ##class(web.CDSS.MachineLearning.InteplatformService).CollectResultToNLP(json)
ClassMethod CollectResultToNLP(NLPStringOld As %String) As %String
{
	
	///w NLPStringOld,!
	s NLPString=$REPLACE(NLPStringOld,"'","""")
	///w NLPString,!
	s formal=""
	s signvalename=""
	if NLPString="[]"
	{
		q ""
	}
	else
	{
		s NLPArray=[].%FromJSON(NLPString)
	
	    for i=0:1:NLPArray.%Size()-1
		{
			s SymProperty=""
			s ItemJson=NLPArray.%Get(i)
			if (ItemJson.%IsDefined("formal"))&(ItemJson.%Get("formal")'="")
		    {
			    if (formal="")
			    {
				    s formal=ItemJson.%Get("formal")
				}
				else
				{
					s formal=formal_","_ItemJson.%Get("formal") 
				}
		    }
		    if (ItemJson.%IsDefined("sign_name")) //sign_name 心室率：210次/分
			{
				if (ItemJson.%Get("sign_name").%Get("name")'="")
				{
					s signvalename=ItemJson.%Get("sign_name").%Get("name")
					if formal'=""
					{
						s signname=formal_"&%"_signvalename
					}
					else
					{
						s formal=signvalename
					}
				}
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
				if Nature'=""
				{
					s formal=formal_"%%"_Nature
				}
				else
				{
					s formal=Nature
				}
			}
		}
	}
	q formal
}

/// Creator：阚延新
/// CreatDate: 2022-1-22
/// Description：同步医嘱到对接方字典表   原代码  新代码 新名称
/// Table:
/// Input：原代码  新代码 新名称 
/// Return：
/// Other: w ##class(web.CDSS.MachineLearning.InteplatformService).UpdateIntData("cs1","测试1","cs10","测试10")
ClassMethod UpdateIntData(oldcode, oldname, newcode, newname) As %String [ WebMethod ]
{
	d ..UpdateIntData2(oldcode, oldname, newcode, newname)
	q ""
}

/// Creator：阚延新
/// CreatDate: 2022-1-25
/// Description：同步院区  原代码  新代码 新名称
/// Table:
/// Input：原代码  新代码 新名称 
/// Return：
/// Other: w ##class(web.CDSS.MachineLearning.InteplatformService).%New().UpdateHospArea("XGSQ","浒墅关镇社区卫生服务中心2","XGSQ","浒墅关镇社区卫生服务中心")
Method UpdateHospArea(oldcode, oldname, newcode, newname) As %String [ WebMethod ]
{
	s ^TMP("K5")=oldcode_""_oldname_""_newcode_""_newname
	s result="true"
	q:((oldcode="")||(newcode="")||(newname="")) "false"
	s errorflag=0
	s DictHosp=$lg($g(^CF.WDT.CDSS.MKBConfigD(14)),3)
	q:DictHosp="" "false"
	
	s AreaID=$o(^CT.WDT.CDSS.CustomerHospAreaI("CodeIndex",DictHosp,oldcode,0))
	q:AreaID="" "false"
	s obj=##class(CT.WDT.CDSS.CustomerHospArea).%OpenId(DictHosp_"||"_AreaID)
	s eobj = ##class(web.CDSSEntity.IMP.CustomerHospArea).%New()
	s eobj.HospAreaID=DictHosp_"||"_AreaID
	s eobj.HospAreaCode=newcode	
	s eobj.HospAreaDesc=newname				
	s eobj.StartDate=obj.StartDate				
	s eobj.EndDate=obj.EndDate
	s eobj.ParRef=obj.ParRef.%Id()
	s re=##class(web.CDSS.IMP.CustomerHosp).SaveHospAreaEntity(eobj)
	s:re["false" result=re	
	q result
}

/// Creator：阚延新
/// CreatDate: 2022-1-25
/// Description：his医嘱项 关联医院 新增，删除时，同步到 CDSS对接方字典关联院区
/// Table:
/// Input：医嘱项代码  、医嘱项名称、医院名称1/医院名称2、类型（A,D）
/// Return：
/// Other: w ##class(web.CDSS.MachineLearning.InteplatformService).OperateOrderConArea("cs2","desc2","苏州科技城医院/通安卫生院","A")
/// Other: w ##class(web.CDSS.MachineLearning.InteplatformService).OperateOrderConArea("K000000012","特级护理","测试10/浒墅关镇社区卫生服务中心","D")
ClassMethod OperateOrderConArea(code, name, hosp, type) As %String [ WebMethod ]
{
	d ..OperateOrderConArea2(code, name, hosp, type)
	q ""
}

/// w ##class(web.CDSS.MachineLearning.InteplatformService).HospValidate("苏州科技城医院/通安卫生院")
ClassMethod HospValidate(hosp) As %String
{
	
	s flag=0
	s DictHosp=$lg($g(^CF.WDT.CDSS.MKBConfigD(14)),3)
	s size=$l(hosp,"/")
	for i=1:1:size
	{
    	s HospAreaDesc=$p(hosp,"/",i)
    	s:HospAreaDesc="" flag=1
    	q:HospAreaDesc=""
    	s HospAreaID=$o(^CT.WDT.CDSS.CustomerHospAreaI("DescIndex",DictHosp,HospAreaDesc,0))
    	s:HospAreaID="" flag=1
    	q:HospAreaID=""
    }
    q flag
}

/// Creator：阚延新
/// CreatDate: 2022-1-25
/// Description：his医嘱项 关联医院 修改，同步到 CDSS对接方字典关联院区
/// Table:
/// Input：医嘱项代码  、医嘱项名称、医院名称1/医院名称2、医院名称1/医院名称2
/// Return：
/// Other: w ##class(web.CDSS.MachineLearning.InteplatformService).UpdateOrderConArea("cs2","desc2","苏州科技城医院/通安卫生院","阳山街道社区卫生服务中心/浒墅关镇社区卫生服务中心")
ClassMethod UpdateOrderConArea(code, name, oldhosp, newhosp) As %String [ WebMethod ]
{
	d ..UpdateOrderConArea2(code, name, oldhosp, newhosp)
	q ""
}

/// Creator：阚延新
/// CreatDate: 2022-1-25
/// Description：his医嘱项新增
/// Table:
/// Input：医嘱项代码  、医嘱项名称、医嘱类型
/// Return：
/// Other: w ##class(web.CDSS.MachineLearning.InteplatformService).AddIntData("cs1","测试1","诊断字典")
ClassMethod AddIntData(code, name, type) As %String [ WebMethod ]
{
	d ..AddIntData2(code, name, type)
	q ""
}

/// Creator：阚延新
/// CreatDate: 2022-1-25
/// Description：院区新增
/// Table:
/// Input：医嘱项代码  、医嘱项名称
/// Return：
/// Other: w ##class(web.CDSS.MachineLearning.InteplatformService).AddHospArea (code, name)
ClassMethod AddHospArea(code, name) As %String [ WebMethod ]
{
	s result=""
	s DictHosp=$lg($g(^CF.WDT.CDSS.MKBConfigD(14)),3)
	q:DictHosp="" "false"
	s eobj = ##class(web.CDSSEntity.IMP.CustomerHospArea).%New()
	s eobj.HospAreaID = ""
		
	s eobj.HospAreaCode=code				//代码
	s eobj.HospAreaDesc=name				//描述
	s eobj.ParRef = DictHosp					//医院
	s eobj.StartDate=""					//开始日期
	s eobj.EndDate=""						//结束日期
	s result=##class(web.CDSS.IMP.CustomerHosp).SaveHospAreaEntity(eobj)
	if ((result'["false"))
	{		
		s result="true"	
	}
	else
	{
		s result="flase"
	}
	q result
}

/// Creator：阚延新
/// CreatDate: 2022-3-2
/// Description：同步医嘱到对接方字典表2.0   原代码  新代码 新名称
/// Table:
/// Input：原代码  新代码 新名称 
/// Return：
/// Other: w ##class(web.CDSS.MachineLearning.InteplatformService).UpdateIntData2("001","k1","002","k2")
ClassMethod UpdateIntData2(oldcode, oldname, newcode, newname) As %String [ WebMethod ]
{
	s result=""
	q:((oldcode="")||(oldname="")||(newcode="")||(newname="")) "false"
	s DictHosp= ##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401")  //医院id
	s errorflag=0
	s DictType=""
	for
	{
		s DictType=$o(^CT.WDT.CDSS.ContrastDictI("IntDictCDIndex",DictHosp,DictType))
		q:DictType=""
		q:errorflag=1
		s IntID=0
		for
		{
			s IntID=$o(^CT.WDT.CDSS.ContrastDictI("IntDictCDIndex",DictHosp,DictType,oldcode,oldname,IntID))
			q:IntID=""
			q:errorflag=1
			s obj=##class(CT.WDT.CDSS.ContrastDict).%OpenId(IntID)
			s bobj = ##class(web.CDSSEntity.IMP.ContrastDict).%New()
			s bobj.ID = IntID
			s bobj.DictCode=obj.DictCode
			s bobj.DictName=obj.DictName
			s:obj.HospitalDR'="" bobj.HospitalDR=obj.HospitalDR.%Id()
			s bobj.State=obj.State				//使用标志（0在用，1停用）
			s bobj.Remarks=obj.Remarks				//备注
			s bobj.ConDictCode=newcode
			s bobj.ConDictName=newname
			s bobj.DictDR=obj.DictDR
			s bobj.IntDictDR=obj.IntDictDR
			s bobj.ContrastType=obj.ContrastType
			s LogID=1 //flag
			s re= ##class(web.CDSS.IMP.ContrastDict).SaveEntity(bobj,LogID)
			s:re["false" errorflag=1
			s ContrastType=$lg($g(^CT.WDT.CDSS.ContrastDictD(IntID)),4)	
			s IntDictDR=$lg($g(^CT.WDT.CDSS.ContrastDictD(IntID)),11)	
			if (ContrastType="诊断")
			{
				s obj=##class(CT.WDT.CDSS.ConDieaseDict).%OpenId(IntDictDR)
				s eobj=##class(web.CDSSEntity.IMP.ConDiseaseDict).%New()
				s eobj.ID=IntDictDR
				s:obj.HospitalDR'="" eobj.HospitalDR = obj.HospitalDR.%Id()	//医院
				s eobj.DiseaseCode=newcode	
				s eobj.DiseaseName=newname				
				s eobj.Source=obj.Source				
				s eobj.ICDCode=obj.ICDCode
				s eobj.Remarks=obj.Remarks			
				s eobj.State=obj.State				
				s eobj.CreateDate=obj.CreateDate				
				s eobj.CreateUser=obj.CreateUser					
				s eobj.UpdateDate=obj.UpdateDate				
				s eobj.UpdateUser=obj.UpdateUser
				s eobj.StartDate=obj.StartDate
				s eobj.EndDate=obj.EndDate
				s LogID=1 //flag
				s result= ##class(web.CDSS.IMP.ConDiseaseDict).SaveEntity(eobj,LogID)
				s:result["false" errorflag=1
			}
			if (ContrastType="药品")
			{
				s obj=##class(CT.WDT.CDSS.ConDrugDict).%OpenId(IntDictDR)
				s eobj=##class(web.CDSSEntity.IMP.ConDrugDict).%New()
				s eobj.ID=IntDictDR
				s:obj.HospitalDR'="" eobj.HospitalDR = obj.HospitalDR.%Id()	//医院
				s eobj.DrugCode=newcode	
				s eobj.DrugName=obj.DrugName
				s eobj.Source=obj.Source				
				s eobj.DrugTradeName=newname			
				s eobj.DrugAlias=obj.DrugAlias
				s eobj.Manufacturers=obj.Manufacturers
				s eobj.DrugComposition=obj.DrugComposition
				s eobj.DosageForm=obj.DosageForm
				s eobj.Specification=obj.Specification
				s eobj.Remarks=obj.Remarks			
				s eobj.State=obj.State				
				s eobj.CreateDate=obj.CreateDate				
				s eobj.CreateUser=obj.CreateUser					
				s eobj.UpdateDate=obj.UpdateDate				
				s eobj.UpdateUser=obj.UpdateUser
				s eobj.StartDate=obj.StartDate
				s eobj.EndDate=obj.EndDate
				s LogID=1 //flag
				s result= ##class(web.CDSS.IMP.ConDrugDict).SaveEntity(eobj,LogID)
				s:result["false" errorflag=1
			}
			if (ContrastType="中药")
			{
				s obj=##class(CT.WDT.CDSS.ConTCMDict).%OpenId(IntDictDR)
				s eobj=##class(web.CDSSEntity.IMP.ConTCMDict).%New()
				s eobj.ID=IntDictDR
				s:obj.HospitalDR'="" eobj.HospitalDR = obj.HospitalDR.%Id()	//医院
				s eobj.TCMCode=newcode	
				s eobj.TCMName=obj.TCMName
				s eobj.Source=obj.Source				
				s eobj.TCMTradeName=newname			
				s eobj.TCMAlias=obj.TCMAlias
				s eobj.Manufacturers=obj.Manufacturers
				s eobj.TCMComposition=obj.TCMComposition
				s eobj.DosageForm=obj.DosageForm
				s eobj.Specification=obj.Specification
				s eobj.Remarks=obj.Remarks			
				s eobj.State=obj.State				
				s eobj.CreateDate=obj.CreateDate				
				s eobj.CreateUser=obj.CreateUser					
				s eobj.UpdateDate=obj.UpdateDate				
				s eobj.UpdateUser=obj.UpdateUser
				s eobj.StartDate=obj.StartDate
				s eobj.EndDate=obj.EndDate
				s LogID=1 //flag
				s result= ##class(web.CDSS.IMP.ConTCMDict).SaveEntity(eobj,LogID)
				//s ^TMP("GXP",3)=result
				s:result["false" errorflag=1
			}
			if (ContrastType="检查检验")
			{
				s obj=##class(CT.WDT.CDSS.ConExamDict).%OpenId(IntDictDR)
				s eobj=##class(web.CDSSEntity.IMP.ConExamDict).%New()
				s eobj.ID=IntDictDR
				s:obj.HospitalDR'="" eobj.HospitalDR = obj.HospitalDR.%Id()	//医院
				s eobj.ExamCode=newcode			
				s eobj.ExamName=newname			
				s eobj.Source=obj.Source				
				s eobj.ExamType=obj.ExamType
				s eobj.SpecimenCode=obj.SpecimenCode
				s eobj.SpecimenName=obj.SpecimenName
				s eobj.Remarks=obj.Remarks			
				s eobj.State=obj.State				
				s eobj.CreateDate=obj.CreateDate				
				s eobj.CreateUser=obj.CreateUser					
				s eobj.UpdateDate=obj.UpdateDate				
				s eobj.UpdateUser=obj.UpdateUser
				s eobj.StartDate=obj.StartDate
				s eobj.EndDate=obj.EndDate
				s LogID=1 //flag
				s result= ##class(web.CDSS.IMP.ConExamDict).SaveEntity(eobj,LogID)
				s:result["false" errorflag=1
			}
			if (ContrastType="手术")
			{
				s obj=##class(CT.WDT.CDSS.ConOperDict).%OpenId(IntDictDR)
				s eobj=##class(web.CDSSEntity.IMP.ConOperDict).%New()
				s eobj.ID=IntDictDR
				s:obj.HospitalDR'="" eobj.HospitalDR = obj.HospitalDR.%Id()	//医院
				s eobj.OperationCode=newcode	
				s eobj.OperationName=newname			
				s eobj.Source=obj.Source				
				s eobj.ICDCode=obj.ICDCode
				s eobj.Remarks=obj.Remarks			
				s eobj.State=obj.State				
				s eobj.CreateDate=obj.CreateDate				
				s eobj.CreateUser=obj.CreateUser					
				s eobj.UpdateDate=obj.UpdateDate				
				s eobj.UpdateUser=obj.UpdateUser
				s eobj.StartDate=obj.StartDate
				s eobj.EndDate=obj.EndDate
				s LogID=1 //flag
				s result= ##class(web.CDSS.IMP.ConOperDict).SaveData(eobj,LogID)
				s:result["false" errorflag=1
			}
			if (ContrastType="护理")
			{
				s obj=##class(CT.WDT.CDSS.ConNurseDict).%OpenId(IntDictDR)
				s eobj=##class(web.CDSSEntity.IMP.ConNurseDict).%New()
				s eobj.ID=IntDictDR
				s:obj.HospitalDR'="" eobj.HospitalDR = obj.HospitalDR.%Id()	//医院
				s eobj.NursingCode=newcode	
				s eobj.NursingName=newname		
				s eobj.Source=obj.Source				
				s eobj.NursingType=obj.NursingType
				s eobj.Remarks=obj.Remarks			
				s eobj.State=obj.State				
				s eobj.CreateDate=obj.CreateDate				
				s eobj.CreateUser=obj.CreateUser					
				s eobj.UpdateDate=obj.UpdateDate				
				s eobj.UpdateUser=obj.UpdateUser
				s eobj.StartDate=obj.StartDate
				s eobj.EndDate=obj.EndDate
				s LogID=1 //flag
				s result= ##class(web.CDSS.IMP.ConNurseDict).SaveEntity(eobj,LogID)
				s:result["false" errorflag=1
			}
			if (ContrastType="输血品")||(ContrastType="频率")||(ContrastType="检验标本")||(ContrastType="用法")||(ContrastType="单位")||(ContrastType="科室")
			{
				s obj=##class(CT.WDT.CDSS.ConOtherDict).%OpenId(IntDictDR)
				s eobj=##class(web.CDSSEntity.IMP.ConOtherDict).%New()
				s eobj.RowID=IntDictDR
				s:obj.HospitalDR'="" eobj.HospitalDR = obj.HospitalDR.%Id()	//医院
				s eobj.ProDictCode=newcode
				s eobj.ProDictName=newname	
				s eobj.Source=obj.Source				
				s eobj.ProDictType=obj.ProDictType
				s eobj.Remarks=obj.Remarks			
				s eobj.State=obj.State				
				s eobj.CreateDate=obj.CreateDate				
				s eobj.CreateUser=obj.CreateUser					
				s eobj.UpdateDate=obj.UpdateDate				
				s eobj.UpdateUser=obj.UpdateUser
				s eobj.StartDate=obj.StartDate
				s eobj.EndDate=obj.EndDate
				s LogID=1 //flag
				s result= ##class(web.CDSS.IMP.ConOtherDict).SaveEntity(eobj,LogID)
				s:result["false" errorflag=1
			}
		}
	}
	if (errorflag=1)	//失败
	{
		s result=re	
	}
	else
	{	
		s result="true"
	}
	q result
}

/// Creator：阚延新
/// CreatDate: 2022-1-25
/// Description：his医嘱项 关联医院 新增，删除时，同步到 CDSS对接方字典关联院区2.0
/// Table:
/// Input：医嘱项代码  、医嘱项名称、医院名称1/医院名称2、类型（A,D）
/// Return：
/// Other: w ##class(web.CDSS.MachineLearning.InteplatformService).OperateOrderConArea2("002","k2","院区1","A")
/// Other: w ##class(web.CDSS.MachineLearning.InteplatformService).OperateOrderConArea2("002","k2","院区1","D")
ClassMethod OperateOrderConArea2(code, name, hosp, type) As %String [ WebMethod ]
{
	s result=""
	q:((code="")||(name="")||(hosp="")||(type="")) "false"
	q:..HospValidate(hosp)=1 "flase"
	s DictHosp=$lg($g(^CF.WDT.CDSS.MKBConfigD(14)),3)
	q:DictHosp="" "false"
	s re=""
	s errorflag=0
	s DictType=""
	for
	{
		s DictType=$o(^CT.WDT.CDSS.ContrastDictI("IntDictCDIndex",DictHosp,DictType))
		q:DictType=""
		q:errorflag=1
		s IntID=0
		for
		{
			s IntID=$o(^CT.WDT.CDSS.ContrastDictI("IntDictCDIndex",DictHosp,DictType,code,name,IntID))
			q:IntID=""
			q:errorflag=1
			s ContrastType=$lg($g(^CT.WDT.CDSS.ContrastDictD(IntID)),4)	
			s IntDictDR=$lg($g(^CT.WDT.CDSS.ContrastDictD(IntID)),11)
			if (type="A")
			{
				s size=$l(hosp,"/")
	   			for i=1:1:size
	    		{
		    		s DictHospAreaDesc=$p(hosp,"/",i)
					s HospID=$o(^CT.WDT.CDSS.CustomerHospAreaI("DescIndex",DictHosp,DictHospAreaDesc,0))
					continue:HospID=""
					q:errorflag=1
					s eobj=##class(web.CDSSEntity.IMP.ConDictConArea).%New()
					s eobj.InterDictDR=IntDictDR
					s eobj.HospAreaDR=DictHosp_"||"_HospID
					s eobj.ConDictType=ContrastType
					s re=##class(web.CDSS.IMP.ContrastDict).SaveConDictArea(eobj)
					s:((re["false")&&(re'["存在")) errorflag=1
	    		}
			}
			if (type="D")
			{
				s size=$l(hosp,"/")
	   			for i=1:1:size
	    		{
		    		s DictHospAreaDesc=$p(hosp,"/",i)
		    		continue:DictHospAreaDesc=""
					s HospID=$o(^CT.WDT.CDSS.CustomerHospAreaI("DescIndex",DictHosp,DictHospAreaDesc,0))
					continue:HospID=""
					q:errorflag=1
					s ConID=""
					for
					{
						s ConID=$o(^CT.WDT.CDSS.ConDictConAreaI("ConAreaIndex",ContrastType,IntDictDR,DictHosp_"||"_HospID,ConID))
						q:ConID=""
						q:errorflag=1
						s re=##class(web.CDSS.IMP.ContrastDict).DeleteConArea(ConID)
						s:(re["false") errorflag=1
					}
					
	    		}
			}

		}
	}
	if (errorflag=1)	//失败
	{
		s result=re	
	}
	else
	{
		s result="true"
	}
	q result
}

/// Creator：阚延新
/// CreatDate: 2022-1-25
/// Description：his医嘱项 关联医院 修改，同步到 CDSS对接方字典关联院区2.0
/// Table:
/// Input：医嘱项代码  、医嘱项名称、医院名称1/医院名称2、医院名称1/医院名称2
/// Return：
/// Other: w ##class(web.CDSS.MachineLearning.InteplatformService).UpdateOrderConArea2("002","k2","院区1","院区2")
ClassMethod UpdateOrderConArea2(code, name, oldhosp, newhosp) As %String [ WebMethod ]
{
	s result=""
	q:((code="")||(name="")||(oldhosp="")||(newhosp="")) "false"
	q:(oldhosp=newhosp) "true"
	q:..HospValidate(oldhosp)=1 "flase"
	q:..HospValidate(newhosp)=1 "flase"
	s DictHosp=$lg($g(^CF.WDT.CDSS.MKBConfigD(14)),3)
	q:DictHosp="" "false"
	
	s errorflag=0
	s DictType=""
	for
	{
		s DictType=$o(^CT.WDT.CDSS.ContrastDictI("IntDictCDIndex",DictHosp,DictType))
		q:DictType=""
		q:errorflag=1
		s IntID=0
		for
		{
			s IntID=$o(^CT.WDT.CDSS.ContrastDictI("IntDictCDIndex",DictHosp,DictType,code,name,IntID))
			q:IntID=""
			q:errorflag=1
			s ContrastType=$lg($g(^CT.WDT.CDSS.ContrastDictD(IntID)),4)	
			s IntDictDR=$lg($g(^CT.WDT.CDSS.ContrastDictD(IntID)),11)
			s size=$l(oldhosp,"/")
	   		for i=1:1:size
	    	{
		    	s HospAreaDesc=$p(oldhosp,"/",i)
				continue:HospAreaDesc=""
				s HospAreaID=$o(^CT.WDT.CDSS.CustomerHospAreaI("DescIndex",DictHosp,HospAreaDesc,0))
				continue:HospAreaID=""
				q:errorflag=1
				s ConID=""
				for
				{
					s ConID=$o(^CT.WDT.CDSS.ConDictConAreaI("ConAreaIndex",ContrastType,IntDictDR,DictHosp_"||"_HospAreaID,ConID))
					q:ConID=""
					q:errorflag=1
					s re=##class(web.CDSS.IMP.ContrastDict).DeleteConArea(ConID)
					s:(re["false") errorflag=1
				}
	    	}
	    	s size=$l(newhosp,"/")
   			for i=1:1:size
    		{
	    		s DictHospAreaDesc=$p(newhosp,"/",i)
	    		b:DictHospAreaDesc=""
				s HospID=""
				for
				{
					s HospID=$o(^CT.WDT.CDSS.CustomerHospAreaI("DescIndex",DictHosp,DictHospAreaDesc,HospID))
					q:HospID=""
					q:errorflag=1
					s eobj=##class(web.CDSSEntity.IMP.ConDictConArea).%New()
					s eobj.InterDictDR=IntDictDR
					s eobj.HospAreaDR=DictHosp_"||"_HospID
					s eobj.ConDictType=ContrastType
					s re=##class(web.CDSS.IMP.ContrastDict).SaveConDictArea(eobj)
					s:((re["false")&&(re'["存在")) errorflag=1
				}
    		}
		}			
	}
	if (errorflag=1)	//失败
	{
		s result="false"	
	}
	else
	{	
		s result="true"
	}
	q result
}

/// Creator：阚延新
/// CreatDate: 2022-1-25
/// Description：his医嘱项新增2.0
/// Table:
/// Input：医嘱项代码  、医嘱项名称、医嘱类型
/// Return：
/// Other: w ##class(web.CDSS.MachineLearning.InteplatformService).AddIntData2("cs1","测试1","诊断字典")
ClassMethod AddIntData2(code, name, type) As %String [ WebMethod ]
{
	s result=""
	s DictHosp=$lg($g(^CF.WDT.CDSS.MKBConfigD(14)),3)
	q:DictHosp="" "false"
	s errorflag=0
	if (type="诊断字典")
	{
		s eobj=##class(web.CDSSEntity.IMP.ConDiseaseDict).%New()
		s eobj.ID=""
		s eobj.HospitalDR = DictHosp	//医院
		s eobj.DiseaseCode=code	
		s eobj.DiseaseName=name				
		s eobj.Source=""		
		s eobj.ICDCode=code
		s eobj.Remarks=""
		s eobj.State="未关联"		
		s eobj.CreateDate=""				
		s eobj.CreateUser=""					
		s eobj.UpdateDate=""			
		s eobj.UpdateUser=""
		s eobj.StartDate=""
		s eobj.EndDate=""
		s result= ##class(web.CDSS.IMP.ConDiseaseDict).SaveEntity(eobj)
		s:result["false" errorflag=1
	}
	if (type="药品字典")
	{
		s eobj=##class(web.CDSSEntity.IMP.ConDrugDict).%New()
		s eobj.ID=""
		s eobj.HospitalDR = DictHosp	//医院
		s eobj.DrugCode=code	
		s eobj.DrugName=""
		s eobj.Source=""				
		s eobj.DrugTradeName=name		
		s eobj.DrugAlias=""
		s eobj.Manufacturers=""
		s eobj.DrugComposition=""
		s eobj.DosageForm=""
		s eobj.Specification=""
		s eobj.Remarks=""
		s eobj.State="未关联"		
		s eobj.CreateDate=""				
		s eobj.CreateUser=""					
		s eobj.UpdateDate=""			
		s eobj.UpdateUser=""
		s eobj.StartDate=""
		s eobj.EndDate=""
		s result= ##class(web.CDSS.IMP.ConDrugDict).SaveEntity(eobj)
		s:result["false" errorflag=1
	}
	if (type="中药字典")
	{
		s eobj=##class(web.CDSSEntity.IMP.ConTCMDict).%New()
		s eobj.ID=""
		s eobj.HospitalDR = DictHosp	//医院
		s eobj.TCMCode=code	
		s eobj.TCMName=""
		s eobj.Source=""				
		s eobj.TCMTradeName=name		
		s eobj.TCMAlias=""
		s eobj.Manufacturers=""
		s eobj.TCMComposition=""
		s eobj.DosageForm=""
		s eobj.Specification=""
		s eobj.Remarks=""
		s eobj.State="未关联"		
		s eobj.CreateDate=""				
		s eobj.CreateUser=""					
		s eobj.UpdateDate=""			
		s eobj.UpdateUser=""
		s eobj.StartDate=""
		s eobj.EndDate=""
		s result= ##class(web.CDSS.IMP.ConTCMDict).SaveEntity(eobj)
		//s ^TMP("HYL",1)=result
		s:result["false" errorflag=1
	}
	if ((type="检查项目字典")||(type="检验项目字典")||(type="检验医嘱"))
	{
		s:type="检查项目字典" type="检查"
		s:type="检验项目字典" type="检验项目"
		s eobj=##class(web.CDSSEntity.IMP.ConExamDict).%New()
		s eobj.ID=""
		s eobj.HospitalDR = DictHosp	//医院
		s eobj.ExamCode=code			
		s eobj.ExamName=name			
		s eobj.Source=""			
		s eobj.ExamType=type
		s eobj.SpecimenCode=""
		s eobj.SpecimenName=""
		s eobj.Remarks=""
		s eobj.State="未关联"		
		s eobj.CreateDate=""				
		s eobj.CreateUser=""					
		s eobj.UpdateDate=""			
		s eobj.UpdateUser=""
		s eobj.StartDate=""
		s eobj.EndDate=""
		s result= ##class(web.CDSS.IMP.ConExamDict).SaveEntity(eobj)
		s:result["false" errorflag=1
	}
	if (type="手术操作字典")
	{
		s eobj=##class(web.CDSSEntity.IMP.ConOperDict).%New()
		s eobj.ID=""
		s eobj.HospitalDR = DictHosp	//医院
		s eobj.OperationCode=code	
		s eobj.OperationName=name			
		s eobj.Source=""			
		s eobj.ICDCode=""
		s eobj.Remarks=""
		s eobj.State="未关联"		
		s eobj.CreateDate=""				
		s eobj.CreateUser=""					
		s eobj.UpdateDate=""			
		s eobj.UpdateUser=""
		s eobj.StartDate=""
		s eobj.EndDate=""
		s result= ##class(web.CDSS.IMP.ConOperDict).SaveData(eobj)
		s:result["false" errorflag=1
	}
	if (type="护理医嘱字典")
	{
		s eobj=##class(web.CDSSEntity.IMP.ConNurseDict).%New()
		s eobj.ID=""
		s eobj.HospitalDR = DictHosp	//医院
		s eobj.NursingCode=code	
		s eobj.NursingName=name		
		s eobj.Source=""				
		s eobj.NursingType=""
		s eobj.Remarks=""
		s eobj.State="未关联"		
		s eobj.CreateDate=""				
		s eobj.CreateUser=""					
		s eobj.UpdateDate=""			
		s eobj.UpdateUser=""
		s eobj.StartDate=""
		s eobj.EndDate=""
		s result= ##class(web.CDSS.IMP.ConNurseDict).SaveEntity(eobj)
		s:result["false" errorflag=1
	}
	if (type="输血品字典")||(type="频率字典")||(type="检验标本")||(type="用法字典")||(type="单位字典")||(type="科室字典")
	{
		s:type="输血品字典" type="14"
		s:type="频率字典" type="7"
		s:type="检验标本" type="9"
		s:type="用法字典" type="10"
		s:type="单位字典" type="11"
		s:type="科室字典" type="12"
		s eobj=##class(web.CDSSEntity.IMP.ConOtherDict).%New()
		s eobj.RowID=""
		s eobj.HospitalDR = DictHosp	//医院
		s eobj.ProDictCode=code
		s eobj.ProDictName=name	
		s eobj.Source=""	
		s eobj.ProDictType=type
		s eobj.Remarks=""
		s eobj.State="未关联"		
		s eobj.CreateDate=""				
		s eobj.CreateUser=""					
		s eobj.UpdateDate=""			
		s eobj.UpdateUser=""
		s eobj.StartDate=""
		s eobj.EndDate=""
		s result= ##class(web.CDSS.IMP.ConOtherDict).SaveEntity(eobj)
		s:result["false" errorflag=1
	}
	if (errorflag=1)	
	{
		s result=result
	}
	else
	{	
		s result="true"
	}
	q result
}

}
