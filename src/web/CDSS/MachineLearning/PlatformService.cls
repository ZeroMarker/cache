/// web.CDSS.MachineLearning.PlatformService
Class web.CDSS.MachineLearning.PlatformService Extends %SOAP.WebService [ ProcedureBlock ]
{

/// WebService 的名称.
Parameter SERVICENAME = "PlatformService";

// Parameter LOCATION = "http://192.144.152.252/imedical/web/";

/// TODO:将此更改为实际 SOAP namespace.
/// WebService 的 SOAP Namespace
Parameter NAMESPACE = "http://tempuri.org";

/// 引用类的 Namespace 将在 WSDL 中使用.
Parameter USECLASSNAMESPACES = 1;

/// TODO:添加自变量和实施.
/// Test
Method Test() As %String [ WebMethod ]
{
	Quit "Test"
}

/// W ##class(web.CDSS.MachineLearning.PlatformService).TESTCDSS()
ClassMethod TESTCDSS()
{
	s stream=##class(%Stream.GlobalCharacter).%New()
	;d stream.Write("<Request><LabInfo><IDNO>4918330</IDNO><PatientDR>0002514177</PatientDR><VisitID>1</VisitID><VisitType>3</VisitType><GroupFlag>4760504||270</GroupFlag><GroupSequence>270</GroupSequence><InspectionCode>C002</InspectionCode><InspectionName>血常规+CRP</InspectionName><LabResultInfo><LabItemCode>C0002</LabItemCode><LabItemName>血红蛋白浓度</LabItemName><LabResult>87</LabResult><LabResultFlag>L</LabResultFlag><Unit>g/L</Unit><Reference>115-150</Reference></LabResultInfo><LabResultInfo><LabItemCode>C0003</LabItemCode><LabItemName>白细胞</LabItemName><LabResult>6.16</LabResult><LabResultFlag></LabResultFlag><Unit>10^9/L</Unit><Reference>3.5-9.5</Reference></LabResultInfo><LabResultInfo><LabItemCode>C0004</LabItemCode><LabItemName>淋巴细胞绝对值</LabItemName><LabResult>1.43</LabResult><LabResultFlag></LabResultFlag><Unit>10^9/L</Unit><Reference>1.1-3.2</Reference></LabResultInfo><LabResultInfo><LabItemCode>C0005</LabItemCode><LabItemName>淋巴细胞百分比</LabItemName><LabResult>23.2</LabResult><LabResultFlag></LabResultFlag><Unit>%</Unit><Reference>20-50</Reference></LabResultInfo><LabResultInfo><LabItemCode>C0008</LabItemCode><LabItemName>嗜碱性粒细胞绝对值</LabItemName><LabResult>0.01</LabResult><LabResultFlag></LabResultFlag><Unit>10^9/L</Unit><Reference>0-0.06</Reference></LabResultInfo><LabResultInfo><LabItemCode>C0009</LabItemCode><LabItemName>嗜碱性粒细胞百分比</LabItemName><LabResult>0.2</LabResult><LabResultFlag></LabResultFlag><Unit>%</Unit><Reference>0-1</Reference></LabResultInfo><LabResultInfo><LabItemCode>C0010</LabItemCode><LabItemName>嗜酸性粒细胞绝对值</LabItemName><LabResult>0.03</LabResult><LabResultFlag></LabResultFlag><Unit>10^9/L</Unit><Reference>0.02-0.52</Reference></LabResultInfo><LabResultInfo><LabItemCode>C0011</LabItemCode><LabItemName>嗜酸性粒细胞百分比</LabItemName><LabResult>0.5</LabResult><LabResultFlag></LabResultFlag><Unit>%</Unit><Reference>0.4-8.0</Reference></LabResultInfo><LabResultInfo><LabItemCode>C0012</LabItemCode><LabItemName>血小板</LabItemName><LabResult>193</LabResult><LabResultFlag></LabResultFlag><Unit>10^9/L</Unit><Reference>125-350</Reference></LabResultInfo><LabResultInfo><LabItemCode>C0013</LabItemCode><LabItemName>血小板分布宽度</LabItemName><LabResult>13.6</LabResult><LabResultFlag></LabResultFlag><Unit>%</Unit><Reference>9-17</Reference></LabResultInfo><LabResultInfo><LabItemCode>C0014</LabItemCode><LabItemName>平均血小板体积</LabItemName><LabResult>11.1</LabResult><LabResultFlag></LabResultFlag><Unit>fl</Unit><Reference>6.5-12</Reference></LabResultInfo><LabResultInfo><LabItemCode>C0015</LabItemCode><LabItemName>血小板压积</LabItemName><LabResult>0.210</LabResult><LabResultFlag></LabResultFlag><Unit>%</Unit><Reference>0.108-0.282</Reference></LabResultInfo><LabResultInfo><LabItemCode>C0016</LabItemCode><LabItemName>红细胞</LabItemName><LabResult>2.83</LabResult><LabResultFlag>L</LabResultFlag><Unit>X10^12/L</Unit><Reference>3.8-5.1</Reference></LabResultInfo><LabResultInfo><LabItemCode>C0017</LabItemCode><LabItemName>红细胞压积</LabItemName><LabResult>27.7</LabResult><LabResultFlag>L</LabResultFlag><Unit>%</Unit><Reference>35-45</Reference></LabResultInfo><LabResultInfo><LabItemCode>C0018</LabItemCode><LabItemName>红细胞平均体积</LabItemName><LabResult>97.9</LabResult><LabResultFlag></LabResultFlag><Unit>fl</Unit><Reference>82-100</Reference></LabResultInfo><LabResultInfo><LabItemCode>C0019</LabItemCode><LabItemName>平均红细胞血红蛋白</LabItemName><LabResult>30.7</LabResult><LabResultFlag></LabResultFlag><Unit>pg</Unit><Reference>27-34</Reference></LabResultInfo><LabResultInfo><LabItemCode>C0020</LabItemCode><LabItemName>平均红细胞血红蛋白浓度</LabItemName><LabResult>314</LabResult><LabResultFlag>L</LabResultFlag><Unit>g/L</Unit><Reference>316-354</Reference></LabResultInfo><LabResultInfo><LabItemCode>C0021</LabItemCode><LabItemName>红细胞分布宽度变异系数</LabItemName><LabResult>13.1</LabResult><LabResultFlag></LabResultFlag><Unit>%</Unit><Reference>11-16</Reference></LabResultInfo><LabResultInfo><LabItemCode>C0026</LabItemCode><LabItemName>单核细胞绝对值</LabItemName><LabResult>0.52</LabResult><LabResultFlag></LabResultFlag><Unit>X10^9/L</Unit><Reference>0.1-0.6</Reference></LabResultInfo><LabResultInfo><LabItemCode>C0027</LabItemCode><LabItemName>中性粒细胞绝对值</LabItemName><LabResult>4.17</LabResult><LabResultFlag></LabResultFlag><Unit>10^9/L</Unit><Reference>1.8-6.3</Reference></LabResultInfo><LabResultInfo><LabItemCode>C0028</LabItemCode><LabItemName>中性粒细胞百分比</LabItemName><LabResult>67.7</LabResult><LabResultFlag></LabResultFlag><Unit>%</Unit><Reference>40-75</Reference></LabResultInfo><LabResultInfo><LabItemCode>C0032</LabItemCode><LabItemName>单核细胞百分比</LabItemName><LabResult>8.4</LabResult><LabResultFlag></LabResultFlag><Unit>%</Unit><Reference>3-10</Reference></LabResultInfo><LabResultInfo><LabItemCode>C0033</LabItemCode><LabItemName>C反应蛋白</LabItemName><LabResult>47.60</LabResult><LabResultFlag>H</LabResultFlag><Unit>mg/l</Unit><Reference>0.0-10.0</Reference></LabResultInfo><Specimen>001</Specimen><ExecuteTime></ExecuteTime><ReportTime> </ReportTime><Remarks></Remarks></LabInfo></Request>")
	;d stream.Write("<Request><Header><SourceSystem>SYS0001</SourceSystem><MessageID>40</MessageID></Header><Body><LISReportInfo><LISRRReportID>0000003487||2189</LISRRReportID><LISRRPatientID>0000000598</LISRRPatientID><LISRREncounterTypeCode>I</LISRREncounterTypeCode><LISRRVisitNumber>1708</LISRRVisitNumber><LISRRCollectDate>2022-10-13</LISRRCollectDate><LISRRCollectTime>16:15:43</LISRRCollectTime><LISRRCollectUserCode>HS01</LISRRCollectUserCode><LISRRCollectUserDesc>护士01</LISRRCollectUserDesc><RISROrdSubCatCode></RISROrdSubCatCode><LISRRCarryDate>2022-10-13</LISRRCarryDate><LISRRCarryTime>16:17:12</LISRRCarryTime><LISRRCarryUserCode>HS01</LISRRCarryUserCode><LISRRCarryUserDesc>护士01</LISRRCarryUserDesc><LISRRReceiveDate>2023-01-12</LISRRReceiveDate><LISRRReceiveTime>17:04:38</LISRRReceiveTime><LISRRReceiveUserCode>lis01</LISRRReceiveUserCode><LISRRReceiveUserDesc>测试管理员</LISRRReceiveUserDesc><LISRRSpecimenQuality></LISRRSpecimenQuality><LISRRReceiveNotes></LISRRReceiveNotes><LISRRInStorageUserCode></LISRRInStorageUserCode><LISRRInStorageUserDesc></LISRRInStorageUserDesc><LISRROutStorageUserCode></LISRROutStorageUserCode><LISRROutStorageUserDesc></LISRROutStorageUserDesc><LISRROutStorageType></LISRROutStorageType><LISRRAddDate>2023-01-12</LISRRAddDate><LISRRAddTime>17:03:03</LISRRAddTime><LISRRAddUserCode>lis01</LISRRAddUserCode><LISRRAddUserDesc>测试管理员</LISRRAddUserDesc><LISRRAddType></LISRRAddType><LISRRArriveUserCode></LISRRArriveUserCode><LISRRArriveUserDesc></LISRRArriveUserDesc><LISRRArriveWorkGroup></LISRRArriveWorkGroup><LISRRTestDate>2023-01-12</LISRRTestDate><LISRRTestTime>17:04:38</LISRRTestTime><LISRRCancelUserCode></LISRRCancelUserCode><LISRRCancelUserDesc></LISRRCancelUserDesc><LISRRCancelReason></LISRRCancelReason><LISRRReprotType>1</LISRRReprotType><LISRRRemarks></LISRRRemarks><LISRRISMcroorganism>2</LISRRISMcroorganism><LISRRIdentifition></LISRRIdentifition><LISRRCheckDate>2023-01-17</LISRRCheckDate><LISRRCheckTime>18:06:05</LISRRCheckTime><LISRRCheckUserCode>lis01</LISRRCheckUserCode><LISRRCheckUserDesc>测试管理员</LISRRCheckUserDesc><LISRRFirstCheckDate>2023-01-17</LISRRFirstCheckDate><LISRRFirstCheckTime>18:05:44</LISRRFirstCheckTime><LISRRFirstCheckUserCode>lis01</LISRRFirstCheckUserCode><LISRRFirstCheckUserDesc>测试管理员</LISRRFirstCheckUserDesc><LISRROrderItemDesc>血常规五分类</LISRROrderItemDesc><LISRRWarnCode></LISRRWarnCode><LISRRStatus>1</LISRRStatus><LISRRAuthType>1</LISRRAuthType><LISRRTransmitDate>2023-01-12</LISRRTransmitDate><LISRRWorkGroupCode>LJA01</LISRRWorkGroupCode><LISRRWorkGroupDesc>Sysmex-KX21</LISRRWorkGroupDesc><LISRROrder>1</LISRROrder><LISRRSpecimenID>SP004</LISRRSpecimenID><LISRRSpecimenDesc>血清</LISRRSpecimenDesc><LISRRAcceptDate>2023-01-12</LISRRAcceptDate><LISRRAcceptTime>17:04:38</LISRRAcceptTime><LISRRAcceptUserCode>lis01</LISRRAcceptUserCode><LISRRAcceptUserDesc>测试管理员</LISRRAcceptUserDesc><LISRRMainConclusion></LISRRMainConclusion><LISRRMinorConclusion></LISRRMinorConclusion><LISRItemResult><LISIRItemCode>30</LISIRItemCode><LISIRItemDesc>血红蛋白</LISIRItemDesc><LISIRResult>1.00</LISIRResult><LISIRUnit>g/dl</LISIRUnit><LISIRTextResult>1.00</LISIRTextResult><LISIRExtraResult></LISIRExtraResult><LISIRResultExplain></LISIRResultExplain><LISIRAbnormalFlags>PL</LISIRAbnormalFlags><LISIRRanges>30-70</LISIRRanges><LISIRTestMethod></LISIRTestMethod><LISIRTestMachine></LISIRTestMachine><LISIRTestUserCode></LISIRTestUserCode><LISIRTestUserDesc></LISIRTestUserDesc><LISIRShowSeq>29</LISIRShowSeq><LISIRTestDate>2023-01-17</LISIRTestDate><LISIRTestTime>18:06:05</LISIRTestTime><LISIRCount></LISIRCount><LISIRExpertRule></LISIRExpertRule><LISIRRemark></LISIRRemark><LISIRInterCode></LISIRInterCode><LISIROrderItemID>1586||233</LISIROrderItemID><LISIRAssayStatus></LISIRAssayStatus><LISIRReAssayNum></LISIRReAssayNum><LISIRResClass></LISIRResClass><LISIROrganism></LISIROrganism><LISIRReAssayNumber></LISIRReAssayNumber><LISIRMultipleResistant></LISIRMultipleResistant></LISRItemResult><LISRItemResult><LISIRItemCode>169</LISIRItemCode><LISIRItemDesc>白细胞</LISIRItemDesc><LISIRResult>100.00</LISIRResult><LISIRUnit>*10^9/L</LISIRUnit><LISIRTextResult>100.00</LISIRTextResult><LISIRExtraResult></LISIRExtraResult><LISIRResultExplain></LISIRResultExplain><LISIRAbnormalFlags></LISIRAbnormalFlags><LISIRRanges>4-10</LISIRRanges><LISIRTestMethod></LISIRTestMethod><LISIRTestMachine></LISIRTestMachine><LISIRTestUserCode></LISIRTestUserCode><LISIRTestUserDesc></LISIRTestUserDesc><LISIRShowSeq>14</LISIRShowSeq><LISIRTestDate>2023-01-17</LISIRTestDate><LISIRTestTime>18:06:05</LISIRTestTime><LISIRCount></LISIRCount><LISIRExpertRule></LISIRExpertRule><LISIRRemark></LISIRRemark><LISIRInterCode></LISIRInterCode><LISIROrderItemID>1586||233</LISIROrderItemID><LISIRAssayStatus></LISIRAssayStatus><LISIRReAssayNum></LISIRReAssayNum><LISIRResClass></LISIRResClass><LISIROrganism></LISIROrganism><LISIRReAssayNumber></LISIRReAssayNumber><LISIRMultipleResistant></LISIRMultipleResistant></LISRItemResult><LISRItemResult><LISIRItemCode>178</LISIRItemCode><LISIRItemDesc>红细胞</LISIRItemDesc><LISIRResult>100.00</LISIRResult><LISIRUnit>*10^12/L</LISIRUnit><LISIRTextResult>100.00</LISIRTextResult><LISIRExtraResult></LISIRExtraResult><LISIRResultExplain></LISIRResultExplain><LISIRAbnormalFlags>H</LISIRAbnormalFlags><LISIRRanges>3.5-5</LISIRRanges><LISIRTestMethod></LISIRTestMethod><LISIRTestMachine></LISIRTestMachine><LISIRTestUserCode></LISIRTestUserCode><LISIRTestUserDesc></LISIRTestUserDesc><LISIRShowSeq>23</LISIRShowSeq><LISIRTestDate>2023-01-17</LISIRTestDate><LISIRTestTime>18:06:05</LISIRTestTime><LISIRCount></LISIRCount><LISIRExpertRule></LISIRExpertRule><LISIRRemark></LISIRRemark><LISIRInterCode></LISIRInterCode><LISIROrderItemID>1586||233</LISIROrderItemID><LISIRAssayStatus></LISIRAssayStatus><LISIRReAssayNum></LISIRReAssayNum><LISIRResClass></LISIRResClass><LISIROrganism></LISIROrganism><LISIRReAssayNumber></LISIRReAssayNumber><LISIRMultipleResistant></LISIRMultipleResistant></LISRItemResult></LISReportInfo></Body></Request>")
	;set result=..HIPMessageServer("MES0035",stream)
	d stream.Write("<Request><Header><SourceSystem>SYS0001</SourceSystem><MessageID>1446</MessageID></Header><Body><ExamReportInfo><RISRReportID>CTU86</RISRReportID><RISRExamID>CTU86</RISRExamID><RISROrderItemID>6003||65</RISROrderItemID><RISRPatientID>0000012670</RISRPatientID><RISRPatientName>YW010</RISRPatientName><RISREncounterTypeCode>I</RISREncounterTypeCode><RISRAdmDeptCode>ZYZY003</RISRAdmDeptCode><RISRAdmDeptDesc>内分泌科</RISRAdmDeptDesc><RISROrdSubCatCode>检查CT</RISROrdSubCatCode><RISROrdSubCatDesc>检查CT</RISROrdSubCatDesc><RISROrdCatCode>检查</RISROrdCatCode><RISROrdCatDesc>检查</RISROrdCatDesc><RISRRecDeptCode>ZYYJ002</RISRRecDeptCode><RISRRecDeptDesc>CT室</RISRRecDeptDesc><RISRVisitNumber>6608</RISRVisitNumber><RISRSysCode>US</RISRSysCode><RISRReportDocCode>RIS</RISRReportDocCode><RISRReportDocDesc>ris</RISRReportDocDesc><RISRReportDate>2023-02-22</RISRReportDate><RISRReportTime>15:24:12Z</RISRReportTime><RISRCheckDocCode>RIS</RISRCheckDocCode><RISRCheckDocDesc>ris</RISRCheckDocDesc><RISRCheckDate>2023-02-22</RISRCheckDate><RISRCheckTime>15:24:16Z</RISRCheckTime><RISRFinalCheckDocCode></RISRFinalCheckDocCode><RISRFinalCheckDocDesc></RISRFinalCheckDocDesc><RISRItemDesc>胸部CT平扫+三维</RISRItemDesc><RISRBACode></RISRBACode><RISRBADesc></RISRBADesc><RISRMethod></RISRMethod><RISRExamDesc>    胸部CT示分叶状肺肿块影</RISRExamDesc><RISRDiagDesc>    胸部CT示分叶状肺肿块影</RISRDiagDesc><RISRACRCode></RISRACRCode><RISRAdviseDesc></RISRAdviseDesc><RISRIsGet></RISRIsGet><RISRUpdateDate>2023-02-22</RISRUpdateDate><RISRUpdateTime>15:23:04Z</RISRUpdateTime><RISROrderItemDesc>胸部CT平扫+三维</RISROrderItemDesc><RISRImageSrc></RISRImageSrc><RISRReportImageSrc>http://119.255.194.82:1443/pacs_data/2023-02-22/0000012670_YW010/CTU86/CTU86.pdf</RISRReportImageSrc><RISRWarnCode>N</RISRWarnCode><RISRIsPositive>N</RISRIsPositive><RISRAbnormalFlags></RISRAbnormalFlags><RISRAnesDocCode></RISRAnesDocCode><RISRAnesDocName></RISRAnesDocName><RISRAnesMethodCode></RISRAnesMethodCode><RISRAnesMethodDesc></RISRAnesMethodDesc><RISRAnesLevelCode></RISRAnesLevelCode><RISRAnesLevelDesc></RISRAnesLevelDesc><RISRAnesStartDateTime></RISRAnesStartDateTime><RISRAnesEndDateTime></RISRAnesEndDateTime><RISRSliceFrozenNo></RISRSliceFrozenNo><RISRInspMaterials></RISRInspMaterials><RISRImmuneGrpNo></RISRImmuneGrpNo></ExamReportInfo></Body></Request>")
	set result=..HIPMessageServer("MES0076",stream)
	Q result
	;Quit result.Read()
}

/// Creator:陈代雷
/// CreatDate:2020-10-15
/// Description:第三方调用数据接口(后台调用)，主要获取检查检验报告数据
/// Table:
/// Input: action: 服务编号 message：请求流传给改参数
/// Return:
/// Others:w ##class(web.CDSS.MachineLearning.PlatformService).HIPMessageServer(action,message)
ClassMethod HIPMessageServer(action As %String, message As %Stream.GlobalCharacter) As %String [ WebMethod ]
{
	s str=""
    while 'message.AtEnd
    {
        s str=str_message.ReadLine()
    }
	s result=##class(web.CDSS.Public.XML).%New("Response")
	//s ResultResponse=##class(web.CDSS.Public.XML).%New()
	s ResultHeader=##class(web.CDSS.Public.XML).%New("Header")
	s ResultBody=##class(web.CDSS.Public.XML).%New("Body")
	d ResultHeader.Set("SourceSystem","")
	d ResultHeader.Set("MessageID","")
	d result.Insert(ResultHeader)
	d ResultBody.Set("ResultCode","-1")
	d ResultBody.Set("ResultContent","失败")
	d result.Insert(ResultBody)
 	s SaveDict={}
 	s XMLObj=##class(web.CDSS.Public.XML).NewFromXml(str)
 	q:XMLObj="" result.ToXML()
 	//s request=XMLObj.Get("Request")
 	s Header=XMLObj.Get("Header")
 	s Header1=##class(web.CDSS.Public.XML).%New("Header")
 	d Header1.Set("SourceSystem",Header.SourceSystem)
	d Header1.Set("MessageID",Header.MessageID)
 	s ResultBody1=##class(web.CDSS.Public.XML).%New("Body")
 	d ResultBody1.Set("ResultCode","0")
	d ResultBody1.Set("ResultContent","成功")
	s result=##class(web.CDSS.Public.XML).%New("Response")
	d result.Insert(Header1)
	d result.Insert(ResultBody1)
	s result=result.ToXML()
 	//q:action'="MES0035" result  //过滤掉非检查检验报告信息
 	
 	s Config=##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSSxwh2023041901")
 	s CodeJson={}.%FromJSON(Config)
 	s ExamCode=CodeJson.%Get("EXAM_MessageCode")
 	s LabCode=CodeJson.%Get("LAB_MessageCode")
 	// 检查
 	if action=ExamCode
 	{
	 	s ^TMP("EXAM")=str
		s body=XMLObj.Get("Body")  //body下可能有多条数据
	 	/******************遍历body下的多条数据********************/
	 	while body.Next(.nodeName, .nodeVal) 
	 	{	
		 	s RegisterDocumentRt=nodeVal
		 	d SaveDict.%Set("OrganizationCode",RegisterDocumentRt.Get("OrganizationCode"))  //医疗结构编码
	        d SaveDict.%Set("PatientDR",RegisterDocumentRt.Get("RISRPatientID"))  //患者主索引，患者在医疗机构的唯一标识
	        d SaveDict.%Set("PAADMVisitNumber",RegisterDocumentRt.Get("RISRVisitNumber"))  //就诊号码，患者每次就诊的唯一标识
	        s RISRExamID=RegisterDocumentRt.Get("RISRExamID")  //检查号
	        s SpecimenID=RegisterDocumentRt.Get("SpecimenID")  //样本号
	        d SaveDict.%Set("GroupFlag",RegisterDocumentRt.Get("RISROrderItemID"))  //医嘱号
	        d SaveDict.%Set("ExamResult",RegisterDocumentRt.Get("RISRDiagDesc"))
	        d SaveDict.%Set("ExamResultDesc",RegisterDocumentRt.Get("RISRExamDesc"))
	        d SaveDict.%Set("ExecuteTime",$replace(RegisterDocumentRt.Get("RISRUpdateDate")_" "_RegisterDocumentRt.Get("RISRUpdateTime"),"Z",""))
	        d SaveDict.%Set("ReportTime",$replace(RegisterDocumentRt.Get("RISRReportDate")_" "_RegisterDocumentRt.Get("RISRReportTime"),"Z",""))
	        d SaveDict.%Set("Remarks",RegisterDocumentRt.Get("RISRAdviseDesc"))
	        
		    try
		    {
		        d ..SaveExamInfo(SaveDict.%ToJSON())
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
	 	} 	
	}
 	
 	if action=LabCode
 	{
	 	s ^TMP("LAB")=str
		s body=XMLObj.Get("Body")  //body下可能有多条数据
	 	/******************遍历body下的多条数据********************/
	 	while body.Next(.nodeName, .nodeVal) 
	 	{	
		 	s RegisterDocumentRt=nodeVal
		 	d SaveDict.%Set("OrganizationCode",RegisterDocumentRt.Get("OrganizationCode"))  //医疗结构编码
	        d SaveDict.%Set("PatientDR",RegisterDocumentRt.Get("LISRRPatientID"))  			//患者主索引，患者在医疗机构的唯一标识
	        d SaveDict.%Set("PAADMVisitNumber",RegisterDocumentRt.Get("LISRRVisitNumber"))  //就诊号码，患者每次就诊的唯一标识
	        s RISRExamID=RegisterDocumentRt.Get("LISRRReportID")  							//检验号
	        s SpecimenID=RegisterDocumentRt.Get("SpecimenID")  								//样本
	        	        	
	        d SaveDict.%Set("InspectionCode",RegisterDocumentRt.Get("LISIRItemCode"))  		//检验医嘱代码
		 	d SaveDict.%Set("InspectionName",RegisterDocumentRt.Get("LISRROrderItemDesc"))  //检验医嘱名称
		 	d SaveDict.%Set("InspectionDate",RegisterDocumentRt.Get("LISIRTestDate"))  		//送检日期
		 	d SaveDict.%Set("ExecuteTime",RegisterDocumentRt.Get("LISRRReceiveDate")_" "_RegisterDocumentRt.Get("LISRRReceiveTime"))  	  	//检验日期
		 	d SaveDict.%Set("ReportTime",RegisterDocumentRt.Get("LISRRCheckDate")_" "_RegisterDocumentRt.Get("LISRRCheckTime"))  			//报告日期
		 	
		 	//s SingleDict=XMLObj.Body.LISReportInfo
		 	while XMLObj.Body.LISReportInfo.Next(.nodeName1, .nodeVal1)
		 	{
			 	continue:nodeName1'="LISRItemResult"
			 	s SingleDict=SaveDict.%ToJSON()
			 	s SingleDict=[].%FromJSON(SingleDict)
			 	d SingleDict.%Set("GroupFlag",nodeVal1.Get("LISIROrderItemID"))  	//医嘱号
			 	d SingleDict.%Set("LabItemCode",nodeVal1.Get("LISIRItemCode"))  	//检验小项代码
			 	d SingleDict.%Set("LabItemName",nodeVal1.Get("LISIRItemDesc"))  	//检验小项名称
			 	d SingleDict.%Set("LabResult",nodeVal1.Get("LISIRResult"))  		//检验结果
			 	d SingleDict.%Set("Unit",nodeVal1.Get("LISIRUnit"))  				//单位
			 	d SingleDict.%Set("LabResultFlag",nodeVal1.Get("LISIRTextResult"))  //检验子项结果（定性，阴/阳）
			 	d SingleDict.%Set("Reference",nodeVal1.Get("LISIRRanges"))  		//参考值
			 	d SingleDict.%Set("Remarks",nodeVal1.Get("LISIRResultExplain"))  	//结果说明
				
			 	try
		    	{
			        d ..SaveLabInfo(SingleDict.%ToJSON())
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
			        s ^TMPCDSSCDLERROR(number)=SingleDict.%ToJSON()_"&&"_e.Name
			    }
		 	}
	
	 	}
	}
 	 	
 	//s body=XMLObj.Get("Body")  //body下可能有多条数据
 	/******************遍历body下的多条数据********************/
 	/*while body.Next(.nodeName, .nodeVal) 
 	{	
	 	s RegisterDocumentRt=nodeVal
	 	d SaveDict.%Set("OrganizationCode",RegisterDocumentRt.Get("OrganizationCode"))  //医疗结构编码
        d SaveDict.%Set("PatientDR",RegisterDocumentRt.Get("PATPatientID"))  //患者主索引，患者在医疗机构的唯一标识
        d SaveDict.%Set("PAADMVisitNumber",RegisterDocumentRt.Get("PAADMVisitNumber"))  //就诊号码，患者每次就诊的唯一标识
        s RISRExamID=RegisterDocumentRt.Get("RISRExamID")  //检查号
        s SpecimenID=RegisterDocumentRt.Get("SpecimenID")  //样本号
        d SaveDict.%Set("GroupFlag",RegisterDocumentRt.Get("OEORIOrderItemID"))  //医嘱号
        s DocumentType=RegisterDocumentRt.Get("DocumentType")  //文档类别
        s DocumentID=RegisterDocumentRt.Get("DocumentID")  //文档ID，原系统内该文档唯一标识
        s DocumentContent=RegisterDocumentRt.Get("DocumentContent")  //具体文档内容见临床文档,内容转换成BASE64格式
        s DocumentPath=RegisterDocumentRt.Get("DocumentPath")  //PDF文档路径
        s UpdateUserCode=RegisterDocumentRt.Get("UpdateUserCode")  //最后更新人编码
        d SaveDict.%Set("UpdateDate",RegisterDocumentRt.Get("UpdateDate"))  //最后更新日期 YYYY-MM-DD
        s UpdateTime=RegisterDocumentRt.Get("UpdateDate")  //最后更新时间 hh:mm:ss
        continue:DocumentContent=""
        if (DocumentType="01001")  //检验
        {
			d ..ProcessLabReport(DocumentContent,SaveDict)
        }
        elseif(DocumentType="02001")||(DocumentType="02002")||(DocumentType="02003")||(DocumentType="02004")||(DocumentType="02005")||(DocumentType="16")  //检查
        {
	        d ..ProcessExamReport(DocumentContent,SaveDict)
        }
 	}*/
	q result
}

/// Creator:陈代雷
/// CreatDate:2020-10-20
/// Description:平台组检验报告数据解析、入库
/// Table:
/// Input: DocumentContent：请求流传给改参数 SaveDict:上级中存在的需要的数据
/// Return:
/// Others:w ##class(web.CDSS.MachineLearning.PlatformService).ProcessLabReport(DocumentContent,SaveDict)
ClassMethod ProcessLabReport(DocumentContent, SaveDict) As %String
{
	s clinicalDocument=##class(%SYSTEM.Encryption).Base64Decode(DocumentContent)  //解码base64
    s clinicalDocument=$ZCONVERT(clinicalDocument,"I","UTF8")   //转换编码
    s clinicalDocument=$replace(clinicalDocument,"&quot;",$c(34))
    s clinicalDocument=##class(web.CDSS.Public.XML).NewFromXml(clinicalDocument)
	//s clinicalDocument=obj.Get("clinicalDocument")
 	s structuredBody=clinicalDocument.Get("structuredBody")
 	while structuredBody.Next(.nodeName, .nodeVal)
 	{
	 	continue:nodeName'="section"
	 	continue:nodeVal.Get("section")=""  //过滤掉诊断
	 	d SaveDict.%Set("InspectionCode",nodeVal.Get("E01"))  		//检验项目代码
	 	d SaveDict.%Set("InspectionName",nodeVal.Get("E02"))  		//检验项目名称
	 	d SaveDict.%Set("InspectionDate",nodeVal.Get("E03"))  		//送检日期
	 	d SaveDict.%Set("ExecuteTime",nodeVal.Get("E11")_" "_nodeVal.Get("E12"))  	  		//检验日期
	 	d SaveDict.%Set("ReportTime",nodeVal.Get("E15")_" "_nodeVal.Get("E16"))  			//报告日期
	 	while nodeVal.Next(.nodeName1, .nodeVal1)
	 	{
		 	s SingleDict=SaveDict.%ToJSON()
		 	s SingleDict=[].%FromJSON(SingleDict)
		 	continue:nodeName1'="section"
		 	continue:nodeVal1.text="图像信息的详细描述"
		 	d SingleDict.%Set("LabItemCode",nodeVal1.Get("E01"))  	//检验小项代码
		 	d SingleDict.%Set("LabItemName",nodeVal1.Get("E02"))  	//检验小项名称
		 	d SingleDict.%Set("LabResult",nodeVal1.Get("E03"))  	//检验结果
		 	d SingleDict.%Set("Unit",nodeVal1.Get("E04"))  			//单位
		 	d SingleDict.%Set("LabResultFlag",nodeVal1.Get("E5"))  	//检验子项结果（定性，阴/阳）
		 	d SingleDict.%Set("Reference",nodeVal1.Get("E06"))  	//参考值
		 	d SingleDict.%Set("Remarks",nodeVal1.Get("E10"))  		//结果说明
		 	try
		    {
			    
			    if ($d(^TMPCDSSServer(1))=0)
			    {
				    s number1=1
			    }
			    else
			    {
		        	s number1=$o(^TMPCDSSServer(""),-1)+1
			    }
		        s ^TMPCDSSServer(number1)=SingleDict.%ToJSON()
		        d ##class(web.CDSS.MachineLearning.PlatformService).SaveLabInfo(SingleDict.%ToJSON())
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
		        s ^TMPCDSSCDLERROR(number)=SingleDict.%ToJSON()_"&&"_e.Name
		    }
	 	}	
 	}
 	q ""
}

/// Creator:陈代雷
/// CreatDate:2020-10-21
/// Description:平台组检查报告数据解析、入库
/// Table:
/// Input: DocumentContent：请求流传给改参数 SaveDict:上级中存在的需要的数据
/// Return:
/// Others:w ##class(web.CDSS.MachineLearning.PlatformService).ProcessExamReport(DocumentContent,SaveDict)
ClassMethod ProcessExamReport(DocumentContent, SaveDict) As %String
{
	s clinicalDocument=##class(%SYSTEM.Encryption).Base64Decode(DocumentContent)  //解码base64
    s clinicalDocument=$ZCONVERT(clinicalDocument,"I","UTF8")   //转换编码
    s clinicalDocument=$replace(clinicalDocument,"&quot;",$c(34))
    s clinicalDocument=$REPLACE(clinicalDocument,"//","")
    s clinicalDocument=##class(web.CDSS.Public.XML).NewFromXml(clinicalDocument)
	//s clinicalDocument=obj.Get("clinicalDocument")
 	s structuredBody=clinicalDocument.Get("structuredBody")
 	while structuredBody.Next(.nodeName, .nodeVal)
 	{
	 	continue:nodeName'="section"
	 	continue:nodeVal.Length()<10  //过滤掉诊断
	 	s ExamResult=nodeVal.Get("E09")  //检查结果
        s ExecuteTime=nodeVal.Get("E16")_" "_nodeVal.Get("E17")    //执行时间
        s ReportTime=nodeVal.Get("E23")_" "_nodeVal.Get("E24")    //报告时间
        s Remarks=nodeVal.Get("E08")    //备注，用于存储诊断意见
        d SaveDict.%Set("ExamResult",ExamResult)
        d SaveDict.%Set("ExamResultDesc",Remarks)
        d SaveDict.%Set("ExecuteTime",ExecuteTime)
        d SaveDict.%Set("ReportTime",ReportTime)
        d SaveDict.%Set("Remarks",Remarks)
        s SaveDict=SaveDict.%ToJSON()
        //w SaveDict,!
 	}
 	try
    {
        d ##class(web.CDSS.MachineLearning.PlatformService).SaveExamInfo(SaveDict)
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

/// Creator:陈代雷
/// CreatDate:2020-10-21
/// Description：用于平台组推送的检验报告信息的入库
/// Input：
/// Output: 
/// w ##class(web.CDSS.MachineLearning.PlatformService).SaveLabInfo(json)
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
    s ExecuteTime = $lg($g(^WDT.CDSS.LabInfoD(LabInfoID)),16)
    s ReportTime = $lg($g(^WDT.CDSS.LabInfoD(LabInfoID)),17)
    s Remarks = $lg($g(^WDT.CDSS.LabInfoD(LabInfoID)),18)
    s PassFlag = $lg($g(^WDT.CDSS.LabInfoD(LabInfoID)),19)
    s LabResultFlag = $lg($g(^WDT.CDSS.LabInfoD(LabInfoID)),20)
    s ProjectName=$lg($g(^WDT.CDSS.LabInfoD(LabInfoID)),21)
    s LabItemName = $lg($g(^WDT.CDSS.LabInfoD(LabInfoID)),11)
    s RLabResult=$lg($g(^WDT.CDSS.LabInfoD(LabInfoID)),12)		//检验结果
    if (RLabResult="")  //首推全部删除
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
    s LabItemCode=json.%Get("LabItemCode")
    s LabItemName=json.%Get("LabItemName")
    s LabItemName=##class(web.CDSS.IMP.ContrastDict).GetDiectName(LabItemName,##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401"),"检查检验")		//对照
    s LabResult = json.%Get("LabResult")
    s ExecuteTime = json.%Get("ExecuteTime")
    s ReportTime = json.%Get("ReportTime")
    s Unit = json.%Get("Unit")
    s LabResultFlag = json.%Get("LabResultFlag")
    s Reference = json.%Get("Reference")
    s Remarks = json.%Get("Remarks")
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
    s Labobj.Unit = Unit
    s Labobj.Reference = Reference
    d Labobj.SpecimenSetObjectId(Specimen)
    s Labobj.ExecuteTime = ExecuteTime
    s Labobj.ReportTime =ReportTime
    s Labobj.Remarks = Remarks
    s Labobj.PassFlag = PassFlag
    s Labobj.LabResultFlag = LabResultFlag  
    s Labobj.ProjectName=ProjectName
    s sc=Labobj.%Save()
    
    d ..SaveSatisfyIW("WDT.CDSS.LabInfo","LabResult",IDNO,PatientDR,VisitID,VisitType)
    q ""
}

/// Creator:陈代雷
/// CreatDate:2020-10-21
/// Description：提供数据库更新检查报告数据
/// Input：
/// Output: 
/// w ##class(web.CDSS.MachineLearning.PlatformService).SaveExamInfo(json)
ClassMethod SaveExamInfo(json As %String) As %String
{
    /*s json=[].%FromJSON(json)
    s GroupFlag=json.%Get("GroupFlag")
    s ExamResult = json.%Get("ExamResult")
    s ExecuteTime = json.%Get("ExecuteTime") 
    s ReportTime = json.%Get("ReportTime")
    s Remarks = json.%Get("Remarks")
   	
    s ExamInfoID = $o(^User.DHCDSSExamInfoI("GroupFlagIndex"," "_GroupFlag,0))
    if ExamInfoID'=""
    {
	    s Examobj = ##class(User.DHCDSSExamInfo).%OpenId(ExamInfoID)
	    s Examobj.ExamResultDesc= ExamResult
	    s Examobj.ExecuteTime=ExecuteTime
	    s Examobj.ReportTime=ReportTime
	    s Examobj.Remarks = Remarks
	    d Examobj.%Save()
	    d Examobj.%Close()  
    }*/
   	d ##class(web.CDSS.MachineLearning.InteplatformService).SaveExamInfo(json)
    q ""
}

/// Creator:Fanwenkai	
/// CreatDate:2021-12-27
/// Description：用于信息入库时触发识别词更新
/// Input：json
/// Output: 
/// w ##class(web.CDSS.MachineLearning.PlatformService).SaveSatisfyIW()
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
	s PatientUserInfo=IDNOValue_"^"_PatientDRValue_"^"_VisitIDValue_"^"_VisitTypeValue_"^^^^^1"
	d ##class(web.CDSS.IdentifyWords.GetPatientIW).GetSatisfyIW(PatientUserInfo)
}

}
