Class DHCDoc.Interface.Outside.GDHealthCardService.Util Extends (%RegisteredObject, Parameter)
{

ClassMethod GetEncrypt(params As %String) As %String
{
	Q params
	s result=""
	s EncryptObj=##class(%Library.DynamicObject).%New()
	d EncryptObj.%Set("params",params)
	s EncryptJson=EncryptObj.%ToJSON()
	s OutJson=..HttpService(EncryptJson,"encrypt")
	s obj=##class(%Library.DynamicObject).%FromJSON(OutJson)
	if obj.%Get("code")=0
    {
	    s result=obj.%Get("result")
    }
	q result
}

/// w ##Class(DHCDoc.Interface.Outside.ElecHealthCardService.ElecHealthCardMethods).GetDeEncrypt("673B3F94095302C7EB6CB619E87B9C96")
ClassMethod GetDeEncrypt(params As %String) As %String
{
	q params
	s result=""
	s EncryptObj=##class(%Library.DynamicObject).%New()
	d EncryptObj.%Set("params",params)
	s EncryptJson=EncryptObj.%ToJSON()
	s OutJson=..HttpService(EncryptJson,"deciphering")
	s obj=##class(%Library.DynamicObject).%FromJSON(OutJson)
	 if obj.%Get("code")=0
    {
	    s result=obj.%Get("result")
    }
	q result
}

ClassMethod GetSign(nonceStr As %String, timestamp As %String) As %String
{
	s result=""
	s SignObj=##class(%Library.DynamicObject).%New()
	s bodyObj=##class(%Library.DynamicObject).%New()
	d bodyObj.%Set("appId",..#appId)
	d bodyObj.%Set("nonceStr",nonceStr)
	d bodyObj.%Set("orgCode",..#orgCode)
	d bodyObj.%Set("timestamp",timestamp)
	d bodyObj.%Set("version",..#version)
	d SignObj.%Set("body",bodyObj)
	s SignJson=SignObj.%ToJSON()
	b ;EncryptJson
	s OutJson=..HttpService(SignJson,"sign")
	;b ;OutJson -GetSign
	s obj=##class(%Library.DynamicObject).%FromJSON(OutJson)
	 if obj.%Get("code")=0
    {
	    s result=obj.%Get("result")
    }
	q result
}

ClassMethod GetBodySign(Body As %String) As %String
{
	s result=""
	s BodySignObj=##class(%Library.DynamicObject).%New()
	d BodySignObj.%Set("body",Body)
	s BodySignJson=BodySignObj.%ToJSON()
	s OutJson=..HttpService(BodySignJson,"sign")
	s obj=##class(%Library.DynamicObject).%FromJSON(OutJson)
	 if obj.%Get("code")=0
    {
	    s result=obj.%Get("result")
    }
	q result
}

ClassMethod HttpService(Json As %String, tLink As %String = "do") As %String
{
	;http://192.168.100.96:8098/api/do
	s Json=$tr(Json," ","")
	s Json=$tr(Json,$c(10),"")
	s Json=$tr(Json,$c(13),"")
	s ScanOutput=""
    /*s httpRequest=##class(%Net.HttpRequest).%New()
	s httpRequest.Timeout=10
	s httpRequest.Server=(..#Server)
	s httpRequest.Port=(..#Port)
	;s httpRequest.ReadRawMode=1
	s httpRequest.ContentCharset="utf-8"
	d httpRequest.ContentTypeSet("text/json")
	d httpRequest.EntityBody.Write(Json)
	s retStr=httpRequest.Post(..#Link_tLink)
	s contentInfo=httpRequest.HttpResponse.ContentInfo
	s statusCode=httpRequest.HttpResponse.StatusCode
	s dataStream=httpRequest.HttpResponse.Data
	i dataStream'="" s ScanOutput=dataStream.ReadLine()
	*/
	
	s obj=##class(%Library.DynamicObject).%FromJSON(Json)
	s method=obj.method
	s Action=""
	i method="createVmcardQRcode" s Action="MES0107"
	i method="queryIfHasRegistered" s Action="MES0108"
	i method="getPersonInfo" s Action="MES0109"
	i method="modifyVmcardInfo" s Action="MES0110"
	i method="getPersonInfoByQrCode" s Action="MES0111"
	i method="getActiveQrCode" s Action="MES0112"
	i method="activateVmcardQRcode" s Action="MES0113"
	i method="resetVmcardInfo" s Action="MES0152"	
	
	s className="web.DHCENS.BLL.DZJKK.Method.DZJKKService"
	s methodName="DZJKKService"
	s flag=##class(%Dictionary.MethodDefinition).%ExistsId(className_"||"_methodName)
	q:flag'=1 "<Response><Header><SourceSystem></SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>"_className_"."_methodName_"方法不存在,请找数据中心技术支持部署相关接口</ResultContent></Body></Response>"
	set Stream = ##class(%GlobalCharacterStream).%New()
	d Stream.Write(Json)
	s ScanOutput=##class(web.DHCENS.BLL.DZJKK.Method.DZJKKService).DZJKKService(Action,Stream)
	s ScanOutput=ScanOutput.Read()
	b ; ScanOutput
	s ^temp("ScanOutput")=$lb(Action,Json,ScanOutput)
	set JsonOutput=$tr(ScanOutput," ","")
	set JsonOutput=$tr(JsonOutput,$c(10),"")
	set JsonOutput=$tr(JsonOutput,$c(13),"")
	Q JsonOutput
}

/// 生成随机数 (入参位随机数的长度)
ClassMethod GetRandomNum(Len As %String) As %String
{
	s randomNum=""
	f i=1:1:Len
	{
		i randomNum="" {
			s randomNum=$Random(10)
		}else{
			s randomNum=randomNum_$Random(10)
		}
	}
	q randomNum
}

ClassMethod ConvertDataValueTo(Type, Value)
{
	Q:Value="" ""
	if Type="idCardTypeCode"{
		/*
		01	居民身份证
		02	居民户口簿
		03	护照
		04	军官证
		05	驾驶证
		06	港澳居民来往内地通行证
		07	台湾居民来往内地通行证
		08	出生医学证明
		09	医保卡
		10	就诊卡
		11	实体健康卡
		12	港澳台居民居住证
		99	其他法定有效证件
		101	无证件儿童系统自编码
		*************************		
		20	01	居民身份证
		21	02	居民户口簿
		22	03	护照
		23	04	军官证
		24	05	驾驶证
		25	06	港澳居民来往内地通行证
		26	07	台湾居民来往内地通行证
		*/
		//s ret=$case(Value,1:"01",2:"02",3:"03",4:"04",5:"05",16:"06",:"99")
		s ret=$p($g(^PAC("CARD",Value)),"^",1)
	}elseif Type="sex"{
		s ret=$p($g(^CT("SEX",Value)),"^",1)
	}elseif Type="nation"{
		//s ret=$p($g(^CT("NA",Value)),"^",1)
		s ret=$p($g(^CT("NAT",Value)),"^",1)
		i ret=57 s ret=97
	}elseif Type="maritalstatuscode"{
		s ret=$p($g(^CT("MAR",Value)),"^",1)
	}elseif Type="provinceCode"{  // 省
		s ret=$p($g(^CT("PROV",Value)),"^",1)
		i ret'="" s ret=ret_$e("0000000000",1,9-$l(ret))		
	}elseif Type="addressCityCode"{  // 市
		s ret=$p($g(^CT("CIT",Value)),"^",1)
		i ret'="" s ret=ret_$e("0000000000",1,9-$l(ret))	
	}elseif Type="countyCode"{  // 区
		s ret=$p($g(^CT("CITAREA",Value)),"^",1)
		i ret'="" s ret=ret_$e("0000000000",1,9-$l(ret))
	}elseif Type="professionType"{  // 职业类型
		/*
		1	国家机关、党群组织、企、事业单位负责人
		2	专业技术人员
		3	办事人员和有关人员
		4	商业、服务业人员
		5	农、林、牧、渔、水利业生产人员
		6	生产、运输设备操作人员及有关人员
		7	军人
		8	不便分类的其他从业人员
		9	无职业
		**************************
		316	11	国家公务员
		317	13	专业技术人员
		318	17	职员
		319	21	企业管理人员
		320	24	工人
		321	27	农民
		322	31	学生
		323	37	现役军人
		324	51	自由职业者
		325	54	个体经营者
		326	70	无业人员
		327	80	退(离)休人员
		328	90	其他
		*/
		s ret=$case(Value,316:"1",317:"2",318:"3",319:"4",320:"6",321:"5",322:"9",323:"7",324:"8",325:"8",326:"9",327:"8",328:"8",:"9")
	}
	
	

	
	Q ret
}

ClassMethod ConvertDataValueFrom(Type, Value)
{
	Q:Value="" ""
	s Value=$$ALPHAUP^SSUTIL4(Value)
	if Type="idCardTypeCode"{
		/*
		01	居民身份证
		02	居民户口簿
		03	护照
		04	军官证
		05	驾驶证
		06	港澳居民来往内地通行证
		07	台湾居民来往内地通行证
		08	出生医学证明
		09	医保卡
		10	就诊卡
		11	实体健康卡
		12	港澳台居民居住证
		99	其他法定有效证件
		101	无证件儿童系统自编码
		**************************
		20	01	居民身份证
		21	02	居民户口簿
		22	03	护照
		23	04	军官证
		24	05	驾驶证
		25	06	港澳居民来往内地通行证
		26	07	台湾居民来往内地通行证
		*/
		//s ret=$case(Value,"01":1,"02":2,"03":3,"04":4,"05":5,"06":16,:2)
		s ret=$o(^PAC("CARD",0,"Code",Value,0))
	}elseif Type="sex"{
		s ret=$o(^CT("SEX",0,"Code",Value,""))
	}elseif Type="nation"{
		s ret=$o(^CT("NAT",0,"Code",Value,""))
	}elseif Type="maritalstatuscode"{
		s ret=$o(^CT("MAR",0,"Code",Value,""))
	}elseif Type="provinceCode"{  // 省
		s Value=$e(Value,1,6)
		s ret=$o(^CT("PROV",0,"Code",Value,0))
	}elseif Type="addressCityCode"{  // 市
		s Value=$e(Value,1,6)
		s ret=$o(^CT("CIT",0,"Code",Value,0)) 
	}elseif Type="countyCode"{  // 区
		s Value=$e(Value,1,6)
		s ret=$o(^CT("CITAREA",0,"Code",Value,0)) 
	}elseif Type="professionType"{  // 职业类型
		/*
		1	国家机关、党群组织、企、事业单位负责人
		2	专业技术人员
		3	办事人员和有关人员
		4	商业、服务业人员
		5	农、林、牧、渔、水利业生产人员
		6	生产、运输设备操作人员及有关人员
		7	军人
		8	不便分类的其他从业人员
		9	无职业
		**************************
		316	11	国家公务员
		317	13	专业技术人员
		318	17	职员
		319	21	企业管理人员
		320	24	工人
		321	27	农民
		322	31	学生
		323	37	现役军人
		324	51	自由职业者
		325	54	个体经营者
		326	70	无业人员
		327	80	退(离)休人员
		328	90	其他
		*/
		//s ret=$case(Value,316:"1",317:"2",318:"3",319:"4",320:"6",321:"5",322:"9",323:"7",324:"8",325:"8",326:"9",327:"8",328:"8",:"9")
		s ret=$case(Value,1:"316",2:"317",3:"318",4:"319",6:"320",5:"321",9:"326",7:"323",8:"324:",:"")
	}
	Q ret
}

/// w ##class(DHCDoc.Interface.Outside.GDHealthCardService.Util).ReadCardTypeByDesc()
ClassMethod ReadCardTypeByDesc()
{
	//s DZJJKCardTypeID=##class(DHCDoc.Interface.Outside.GDHealthCardService.Util).ReadCardTypeByDesc()
	s myTypeID=0 s myval="" 
	f  s myTypeID=$o(^DHCCARDTYPEDef(myTypeID)) q:((myTypeID="")||(myval'=""))  d
	.//q:myTypeID'=DZJJKCardTypeID
	.s CardTypeDesc=$p($g(^DHCCARDTYPEDef(myTypeID)),"^",2)
	.q:CardTypeDesc'["电子健康卡"
	.s mydes=$p(^DHCCARDTYPEDef(myTypeID),"^", 2)
	.s myActiveFlag=$p(^DHCCARDTYPEDef(myTypeID),"^", 11)		;CTD_ActiveFlag
	.q:(myActiveFlag'="IE")
	.s myDateTo=+$p(^DHCCARDTYPEDef(myTypeID),"^", 10)		;CTD_DateTo
	.q:((+myDateTo'=0)&(myDateTo<+$h))			;失效日
	.s myval=myTypeID
	.s myval=myval_"^"_$g(^DHCCARDTYPEDef(myTypeID))
	q myval
}

/// 通过登记号获取患者信息
ClassMethod GetPatInfoByPatNo(PAPMINo)
{
	s PAPMINo=$ZCVT(PAPMINo,"U")
	s PatientID=$o(^PAPERi("PAPMI_PatNo",PAPMINo,0))
	s PatInfo=..GetPatInfoByPatientID(PatientID)
	Q PatInfo
}

/// 通过登记号获取病人id
/// w ##class(DHCDoc.Interface.Outside.GDHealthCardService.Util).GetPatIDByPatNo("0000003083")
ClassMethod GetPatIDByPatNo(PAPMINo)
{
	s ^temp("GetPatIDByPatNo")=PAPMINo
	s PAPMINo=$ZCVT(PAPMINo,"U")
	s PatientID=$o(^PAPERi("PAPMI_PatNo",PAPMINo,0))
	Q PatientID
}

ClassMethod GetPatInfoByPatientID(PatientID)
{
	s ^temp("GetPatInfoByPatientID")=PatientID
	Q:PatientID="" ""
	s Name=$p($g(^PAPER(PatientID,"ALL")),"^",1)
    s PatientNo=$p($g(^PAPER(PatientID,"PAT",1)),"^",1)
    s PatSex="",Age=""
    s PatSexDR=$p($g(^PAPER(PatientID,"ALL")),"^",7)
	i PatSexDR'="" s PatSex=$p(^CT("SEX",PatSexDR),"^",2)
	s PatDOB=$P($G(^PAPER(PatientID,"ALL")),"^",6)
    s Age=$$CalAge^at182(PatDOB,+$H,"","","")
    s Age=$p(Age,"|",12)
    
    set IDTypeCode=$p(^PAPER(PatientID,"PAT",3),"^",7)
	if IDTypeCode'="" set IDTypeDesc=$p(^PAC("CARD",IDTypeCode),"^",7)
	set IDNo=$p($g(^PAPER(PatientID,"PAT",3)),"^",6)
	s ReInfo=PatientNo_"^"_Name_"^"_PatSex_"^"_Age_"^"_IDTypeCode_"^"_IDNo
	
	Q ReInfo
}

/// w ##class(DHCDoc.Interface.Outside.GDHealthCardService.Util).GetEHCHealthCardByPat("1309283")
ClassMethod GetEHCHealthCardByPat(PatientID As %String)
{
	Q:PatientID="" ""
	s CardTypeID=..ReadCardTypeByDesc()
	s CardTypeID=$p(CardTypeID,"^",1)
	s PatientCard=""
	s CardID=""
	for {
		s CardID=$o(^DHCCARDi("CF",0,"PAPMIDR",PatientID,CardID))
		q:CardID=""
		s CFActive=$p(^DHCCARD("CF",CardID),"^",10)
		Continue:CFActive'="N"
		s CFCardTypeDR=$p(^DHCCARD("CF",CardID),"^",16)
		Continue:(CardTypeID'="")&(CardTypeID'=CFCardTypeDR)
		s PatientCard=$p(^DHCCARD("CF",CardID),"^",2)
	}
	Q PatientCard
}

}
