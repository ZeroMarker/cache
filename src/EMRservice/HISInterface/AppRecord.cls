Class EMRservice.HISInterface.AppRecord Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

Parameter SERVICENAME = "AppRecordExternal";

/// Input:	xmlRequest 入参xml字符串，格式如下
/// 			<Request>
/// 				<EpisodeID>10</EpisodeID>
/// 				<MainSuit>测试主诉</MainSuit>
/// 				<NowHisInfo>测试现病史</NowHisInfo>
/// 				<PrevHisInfo>测试既往史</PrevHisInfo>
/// 				<PhyExam>测试查体</PhyExam>
/// 			</Request>
/// Return: <Response><ResultCode>0</ResultCode><ResultContent>成功</ResultContent></Response>
/// w ##class(EMRservice.HISInterface.AppRecord).InsertAppRecordInfoOut(^CacheTempDHCEPRDebug("input","65431,44393"))
ClassMethod InsertAppRecordInfoOut(xmlRequest As %String) As %String [ WebMethod ]
{
	s arr = ..XmlToArray(xmlRequest)
    s docType = arr.GetAt("DocType")
    
    s EpisodeID = arr.GetAt("EpisodeID")
    s MainSuit = arr.GetAt("MainSuit")                    //主诉
    s NowHisInfo = arr.GetAt("NowHisInfo")                //现病史
    s PrevHisInfo = arr.GetAt("PrevHisInfo")              //既往史
    s PhyExam = arr.GetAt("PhyExam")                      //体格检查
    s PersonalHisInfo = arr.GetAt("PersonalHisInfo")      //个人史
    s RecordDate = arr.GetAt("RecordDate")                //采集日期，日期格式：2020-02-14
    s RecordTime = arr.GetAt("RecordTime")                //采集时间，时间格式：19:00:00
    s ProductCode = arr.GetAt("ProductCode")              //产品线
    
    //兼容协和历史传值方式
    s:(docType = "Assist") ProductCode = "DoctorAssist"
    s:(docType = "Patient") ProductCode = "PatientAPP"
    s:(docType = "ObgynCDSS") ProductCode = "ObgynCDSS"
    
    s Allergy = arr.GetAt("Allergy")                      //过敏史
    s Surgery = arr.GetAt("Surgery ")                     //手术史
    s Trauma= arr.GetAt("Trauma")                         //外伤史
    s BloodHisInfo = arr.GetAt("BloodHisInfo")            //输血史
    s FamillyHisInfo = arr.GetAt("FamillyHisInfo")        //家族史
    s MenstrualHisInfo = arr.GetAt("MenstrualHisInfo")    //月经史
    s MarritalHisInfo = arr.GetAt("MarritalHisInfo")      //生育史
    s AdditionalExam = arr.GetAt("AdditionalExam")        //辅助检查
    s SpecialityExam = arr.GetAt("SpecialityExam")        //专科检查
    s Diag = arr.GetAt("Diag")                            //诊断
    s Oeord = arr.GetAt("Oeord")                          //处理 
    
    s ret = ..InsertAppRecordInfo(EpisodeID,MainSuit,NowHisInfo,PrevHisInfo,PhyExam,PersonalHisInfo,ProductCode,RecordDate,RecordTime,Allergy, Surgery, Trauma, BloodHisInfo, FamillyHisInfo, MenstrualHisInfo, MarritalHisInfo, AdditionalExam, SpecialityExam, Diag, Oeord)
    if (ret = "0")
    {
        q "<Response><ResultCode>0</ResultCode><ResultContent>成功</ResultContent></Response>"
    }
    else
    {
        q "<Response><ResultCode>-1</ResultCode><ResultContent>"_ret_"</ResultContent></Response>"
    }
}

/// ///////////////////////////上方为对外服务////////////////////////////////////
/// /////////////////////////////我是分割线//////////////////////////////////////
/// ///////////////////////////下方为内部调用////////////////////////////////////
/// 调用插入病历主诉、病史以及查体
/// w ##class(EMRservice.HISInterface.AppRecord).InsertAppRecordInfo("1","测试主诉","测试现病史","测试既往史","测试查体")
ClassMethod InsertAppRecordInfo(EpisodeID As %String, MainSuit As %String, NowHisInfo As %String, PrevHisInfo As %String, PhyExam As %String, PersonalHisInfo As %String, Product As %String, RecordDate As %String, RecordTime As %String, Allergy As %String, Surgery As %String, Trauma As %String, BloodHisInfo As %String, FamillyHisInfo As %String, MenstrualHisInfo As %String, MarritalHisInfo As %String, AdditionalExam As %String, SpecialityExam As %String, Diag As %String, Oeord As %String) As %String
{
	s $ZT="ERROR"
	s obj=##Class(EMRinstance.Custom.AppRecordInfo).%New()
	s obj.EpisodeID = EpisodeID
	s obj.MainSuit = MainSuit
	s obj.NowHisInfo = NowHisInfo
	s obj.PhyExam = PhyExam
	s obj.PrevHisInfo = PrevHisInfo
	s obj.DataSources = Product
	s obj.PersonalHisInfo = PersonalHisInfo
    s:(RecordDate'="") RecordDate = $zdh(RecordDate,3)
	s:(RecordTime'="") RecordTime = $zth(RecordTime,1)
	s obj.RecordDate = RecordDate
	s obj.RecordTime = RecordTime
	s obj.CreateDate = $P($H,",",1)
	s obj.CreateTime = $P($H,",",2)
	
	s obj.Allergy = Allergy
	s obj.Surgery = Surgery
	s obj.Trauma = Trauma
	s obj.BloodHisInfo = BloodHisInfo
	s obj.FamillyHisInfo = FamillyHisInfo
	s obj.MenstrualHisInfo = MenstrualHisInfo
	s obj.MarritalHisInfo = MarritalHisInfo
	s obj.AdditionalExam = AdditionalExam
	s obj.SpecialityExam = SpecialityExam
	s obj.Diag = Diag
	s obj.Oeord = Oeord
	s sc = obj.%Save()
	q:($$$ISOK(sc)) "0"
	q "-1^"_$zstrip(sc,"*C")
	
ERROR
	q "-1^"_$zstrip($zerror,"*C")
}

/// s a = ##Class(EMRservice.HISInterface.AppRecord).XmlToArray("<Request><EpisodeID>27256171</EpisodeID><UserCode>1000</UserCode><MainSuit>潮热、盗汗、情绪变化、失眠等2月,骨关节肌肉痛3周,阴道干涩2月</MainSuit><NowHisInfo>LMP：2020-08-09不正常3个月，未使用性激素，自然月经，无排卵,未使用促排卵药物，月经稀发(大于60d)，规律月经，经期过短(小于3d)，经量明显过少(小于5ml)，有痛经(VAS7分)初潮年龄：12，有痛经，5/35，量多</NowHisInfo><PrevHisInfo>近期用药史：没有病史/手术史：子宫肌瘤,子宫内膜息肉史,妇科感染性疾病，剖宫产,卵巢切除,诊断性刮宫术，甲亢，高血压</PrevHisInfo><PhyExam>身高165cm，体重60kg，BMI22.04，W/H0.76，T36.2℃，P78次/分，BP145/90mmHg，BI-RADS分级：II，溢乳：有，外阴：正常，阴道：正常，宫颈：光</PhyExam><AdditionalExam/><SpecialityExam/><IsFeverHistory/><IsRunnyNose/><IsContactDeadAnimals/><IsContactPatient/><IsTravelledInfectedArea/><IsAgglomerativeDisease/><IsVisitHosp/><RecordDate>2020-12-01</RecordDate><RecordTime>13:30:01</RecordTime><DocType>ObgynCDSS</DocType></Request>")
ClassMethod XmlToArray(xmlRequest As %String) As %ArrayOfDataTypes
{
	if ($f(xmlRequest,"<?xml version=""1.0"" encoding=""utf-8""?>")>0) 
	{
		s xmlRequest = $p(xmlRequest,"<?xml version=""1.0"" encoding=""utf-8""?>",2)
	}
	
	s ret = ##Class(%ArrayOfDataTypes).%New()
	//医生助手问诊信息 | 患者问卷调查主诉等信息 | 疑难病平台推送数据
	s keyS = "DocType^EpisodeID^UserCode^MainSuit^NowHisInfo^PrevHisInfo^PhyExam^PersonalHisInfo^Allergy^Surgery^Trauma"
	s keyS = keyS_"^BloodHisInfo^FamillyHisInfo^MenstrualHisInfo^MarritalHisInfo^AdditionalExam^SpecialityExam^Diag^Oeord"
	//门诊病历数量、签名数量信息
	s keyS = keyS_"^ProductCode^SavedInstanceCount^SignedInstanceCount"
	//app 疫情三史信息 | 口腔科医生采集的疫情三史信息
	s keyS = keyS_"^IsFeverHistory^IsRunnyNose^IsContactDeadAnimals^IsContactPatient^IsTravelledInfectedArea"
	s keyS = keyS_"^IsAgglomerativeDisease^IsVisitHosp^RecordDate^RecordTime^IsTravelledOtherCountry^IsTravlledWholesaleMarket"
	s keyS = keyS_"^IsTravelledEpidemicArea^IsInjectVaccine^EpidemicAreaAdds^IsTakeTests^TakeTestResult^NoTakeTestReason"

	s count = $l(keyS,"^")
	for i=1:1:count {
		s key = $p(keyS,"^",i)
		s value = ..GetXMLNodeValue(key,xmlRequest)
		d ret.SetAt(value, key)
	}
	q ret
}

/// w ##class(EMRservice.HISInterface.AppRecord).GetXMLNodeValue("AdditionalExam","") 
ClassMethod GetXMLNodeValue(ANode As %String, AInputXML As %String) As %String
{
	s inputXML = ##class(%GlobalCharacterStream).%New()
	d inputXML.Write(AInputXML)
	//d input.Write("<Request><AdditionalExam>2020-11-23行血常规检查，检查结果：&lt;br/&gt;白细胞计数（WBC）：5.29*10^9/L，&lt;br/&gt;中性粒细胞百分比(NEUT%):70%</AdditionalExam><Exam>测试体检</Exam></Request>")
	s sc = ##class(%XML.XPATH.Document).CreateFromStream(inputXML,.document)
	s sc = document.EvaluateExpression("/Request/"_ANode,"text()",.res)		
	
	s value = ""
	if ($$$ISOK(sc) && (res.GetAt(1)'="")){					
		s value = res.GetAt(1).Value
		s value = $tr(value,$c(0),"")
	}
	q value
}

}
