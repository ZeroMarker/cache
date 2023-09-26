Class EPRservice.Quality.Interface.FirstPageDRGQInfo Extends %RegisteredObject
{

/// Desc:获取病案首页诊断和手术相关信息提供给DRGS
/// d ##Class(%ResultSet).RunQuery("EPRservice.Quality.Interface.FirstPageDRGQInfo","GetFirstRecordInfo","18")
Query GetFirstRecordInfo(AEpisodeID As %String) As %Query(ROWSPEC = "caseId,GENDER,AGE,TOTALEXPENSE,ACCTUALDAYS,B11C,SF0108,DISEASENAME,DISEASECODE,QTZD1,JBDM1,QTZD2,JBDM2,QTZD3,JBDM3,QTZD4,JBDM4,QTZD5,JBDM5,QTZD6,JBDM6,QTZD7,JBDM7,QTZD8,JBDM8,QTZD9,JBDM9,QTZD10,JBDM10,QTZD11,JBDM11,QTZD12,JBDM12,QTZD13,JBDM13,QTZD14,JBDM14,QTZD15,JBDM15,QTZD16,JBDM16,QTZD17,JBDM17,QTZD18,JBDM18,QTZD19,JBDM19,QTZD20,JBDM20,QTZD21,JBDM21,QTZD22,JBDM22, SSJCZBM1,SSJCZMC1,SSJCZBM2,SSJCZMC2,SSJCZBM3,SSJCZMC3,SSJCZBM4,SSJCZMC4,SSJCZBM5,SSJCZMC5,SSJCZBM6,SSJCZMC6,SSJCZBM7,SSJCZMC7,SSJCZBM8,SSJCZMC8,PAYTYPE,RECSIZE,SF0100,SF0102,SF0102B,SF0104,ICU,CRRT,PDT")
{
}

ClassMethod GetFirstRecordInfoExecute(ByRef qHandle As %Binary, AEpisodeID As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	q:(AEpisodeID="") $$$OK
	
	s (caseId,GENDER,AGE,TOTALEXPENSE,ACCTUALDAYS,B11C,SF0108,DISEASENAME,DISEASECODE,QTZD1,JBDM1,QTZD2,JBDM2,QTZD3,JBDM3,QTZD4,JBDM4,QTZD5,JBDM5,QTZD6,JBDM6,QTZD7,JBDM7,QTZD8,JBDM8,QTZD9,JBDM9,QTZD10,JBDM10,QTZD11,JBDM11,QTZD12,JBDM12,QTZD13,JBDM13,QTZD14,JBDM14,QTZD15,JBDM15,QTZD16,JBDM16,QTZD17,JBDM17,QTZD18,JBDM18,QTZD19,JBDM19,QTZD20,JBDM20,QTZD21,JBDM21,QTZD22,JBDM22, SSJCZBM1,SSJCZMC1,SSJCZBM2,SSJCZMC2,SSJCZBM3,SSJCZMC3,SSJCZBM4,SSJCZMC4,SSJCZBM5,SSJCZMC5,SSJCZBM6,SSJCZMC6,SSJCZBM7,SSJCZMC7,SSJCZBM8,SSJCZMC8)=""
	s (SF0100,SF0102,SF0102B,SF0104,ICU,CRRT,PDT)="-1"
	s ArrGlossary=##class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossary(AEpisodeID,"HDSD00.11")
	
		//s ArrGlossary=##class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossary("20064440","HDSD00.11")
		s PapmiDR = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(AEpisodeID)
		s RegisterNo = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiNo(PapmiDR)
		s IPRecordNo = ##class(EMRservice.HISInterface.PatientInfoAssist).IPRecordNoInfo(AEpisodeID)
		
	    
		
		s caseId = AEpisodeID	//唯一标识
	    s GENDER=ArrGlossary.GetAt("HDSD00.11.109") //性别代码  1：男，2：女,9:未做说明 
	    s:((GENDER'="")&&(GENDER'="1")&&(GENDER'="2")) GENDER=9
		s AGE = ArrGlossary.GetAt("HDSD00.11.079")	//年龄
		//s TOTALEXPENSE=ArrGlossary.GetAt("HDSD00.11.142")	//患者当前总费用
		s TOTALEXPENSE=""
		s PatFee=..GetPatFee(AEpisodeID,"")
		s:(PatFee'="") TOTALEXPENSE=$p(PatFee,"^",3)
		s:(TOTALEXPENSE'="") TOTALEXPENSE=$j(TOTALEXPENSE,1,2)
		s ACCTUALDAYS=ArrGlossary.GetAt("HDSD00.11.087") //患者当前住院天数
		s:(ACCTUALDAYS="-") ACCTUALDAYS="" 
		s SF0100=ArrGlossary.GetAt("HDSD00.11.807") //新生儿年龄（天）
		s:(($tr(SF0100," ","")="")||(SF0100="-")) SF0100="-1"
		s SF0102=ArrGlossary.GetAt("HDSD00.11.108") //新生儿入院体重（克）
		s:(($tr(SF0102," ","")="")||(SF0102="-")) SF0102="-1"
		s SF0102B=ArrGlossary.GetAt("HDSD00.11.107") //新生儿出生体重（克）
		s:(($tr(SF0102B," ","")="")||(SF0102B="-")) SF0102B="-1"
		s SF0104 =ArrGlossary.GetAt("HDSD00.11.555") //呼吸机使用时间（小时）
		s B11C=ArrGlossary.GetAt("HDSD00.11.591") //入院途径
		s:(($tr(SF0104," ","")="")||(SF0104="-")) SF0104="-1" 
		s:(B11C="急诊") B11C=1
		s:(B11C="门诊") B11C=2
		s:(B11C="其他医疗机构转入") B11C=3
		s:((B11C'="")&&(B11C'="急诊")&&(B11C'="门诊")&&(B11C'="其他医疗机构转入")) B11C=9
		s SF0108=ArrGlossary.GetAt("HDSD00.11.603") //离院方式
		s:(SF0108="医嘱离院") SF0108=1
		s:(SF0108="医嘱转院") SF0108=2
		s:(SF0108="转医嘱转社区卫生服务机构/乡镇卫生院") SF0108=3
		s:(SF0108="非医嘱离院") SF0108=4
		s:(SF0108="死亡") SF0108=5
		s:(SF0108="其他") SF0108=9
		s:(SF0108'=+SF0108) SF0108=9
		
		s DISEASENAME = ArrGlossary.GetAt("HDSD00.11.024")	    //主要诊断
		s DISEASECODE = ArrGlossary.GetAt("HDSD00.11.023")		//主要诊断疾病编码
		
		
		s QTZD1 = ArrGlossary.GetAt("HDSD00.11.021")	//其他诊断1 HDSD00.11.021
		s JBDM1 = ArrGlossary.GetAt("HDSD00.11.020")	//疾病编码1
		
		
		s QTZD2 = ArrGlossary.GetAt("HDSD00.11.306")	//其他诊断2
		s JBDM2 = ArrGlossary.GetAt("HDSD00.11.307")	//疾病编码2
		
		
		s QTZD3 = ArrGlossary.GetAt("HDSD00.11.310")	//其他诊断3
		s JBDM3 = ArrGlossary.GetAt("HDSD00.11.311")	//疾病编码3
		
		
		s QTZD4 = ArrGlossary.GetAt("HDSD00.11.314")	//其他诊断4
		s JBDM4 = ArrGlossary.GetAt("HDSD00.11.315")	//疾病编码4
		
		
		s QTZD5 = ArrGlossary.GetAt("HDSD00.11.318")	//其他诊断5
		s JBDM5 = ArrGlossary.GetAt("HDSD00.11.319")	//疾病编码5
		
		s QTZD6 = ArrGlossary.GetAt("HDSD00.11.322")	//其他诊断6
		s JBDM6 = ArrGlossary.GetAt("HDSD00.11.323")	//疾病编码6
		
		s QTZD7 = ArrGlossary.GetAt("HDSD00.11.326")	//其他诊断7
		s JBDM7 = ArrGlossary.GetAt("HDSD00.11.327")	//疾病编码7
		
		s QTZD8 = ArrGlossary.GetAt("HDSD00.11.330")	//其他诊断8 HDSD00.11.
		s JBDM8 = ArrGlossary.GetAt("HDSD00.11.331")	//疾病编码8
		
		s QTZD9 = ArrGlossary.GetAt("HDSD00.11.334")	//其他诊断9
		s JBDM9 = ArrGlossary.GetAt("HDSD00.11.335")	//疾病编码9
		
		s QTZD10 = ArrGlossary.GetAt("HDSD00.11.338")	//其他诊断10 HDSD00.11.338
		s JBDM10 = ArrGlossary.GetAt("HDSD00.11.339")	//疾病编码10
		
		s QTZD11 = ArrGlossary.GetAt("HDSD00.11.342")	//其他诊断11
		s JBDM11 = ArrGlossary.GetAt("HDSD00.11.343")	//疾病编码11
		
		s QTZD12 = ArrGlossary.GetAt("HDSD00.11.346")	//其他诊断12
		s JBDM12 = ArrGlossary.GetAt("HDSD00.11.347")	//疾病编码12
		
		s QTZD13 = ArrGlossary.GetAt("HDSD00.11.350")	//其他诊断13
		s JBDM13 = ArrGlossary.GetAt("HDSD00.11.351")	//疾病编码13
		
		s QTZD14 = ArrGlossary.GetAt("HDSD00.11.354")	//其他诊断14
		s JBDM14 = ArrGlossary.GetAt("HDSD00.11.355")	//疾病编码14
		
		s QTZD15 = ArrGlossary.GetAt("HDSD00.11.358")	//其他诊断15
		s JBDM15 = ArrGlossary.GetAt("HDSD00.11.359")	//疾病编码15
		
		s QTZD16 = ArrGlossary.GetAt("HDSD00.11.362")	//其他诊断16
		s JBDM16 = ArrGlossary.GetAt("HDSD00.11.363")	//疾病编码16
		
		s QTZD17 = ArrGlossary.GetAt("HDSD00.11.366")	//其他诊断17
		s JBDM17 = ArrGlossary.GetAt("HDSD00.11.367")	//疾病编码17
		
		s QTZD18 = ArrGlossary.GetAt("HDSD00.11.370")	//其他诊断18
		s JBDM18 = ArrGlossary.GetAt("HDSD00.11.371")	//疾病编码18
		
		s QTZD19 = ArrGlossary.GetAt("HDSD00.11.374")	//其他诊断19
		s JBDM19 = ArrGlossary.GetAt("HDSD00.11.375")	//疾病编码19
		
		s QTZD20 = ArrGlossary.GetAt("HDSD00.11.378")	//其他诊断20
		s JBDM20 = ArrGlossary.GetAt("HDSD00.11.379")	//疾病编码20
		
		s QTZD21 = ArrGlossary.GetAt("HDSD00.11.382")	//其他诊断21
		s JBDM21 = ArrGlossary.GetAt("HDSD00.11.383")	//疾病编码21
		
		s QTZD22 = ArrGlossary.GetAt("HDSD00.11.386")	//其他诊断22
		s JBDM22 = ArrGlossary.GetAt("HDSD00.11.387")	//疾病编码22
	   
	   
		s SSJCZBM1 = ArrGlossary.GetAt("HDSD00.11.089")	//手术及操作编码1
		s SSJCZMC1 = ArrGlossary.GetAt("HDSD00.11.090")	//手术及操作名称1
		
		
		s SSJCZBM2 = ArrGlossary.GetAt("HDSD00.11.410")	//手术操作编码2
		s SSJCZMC2 = ArrGlossary.GetAt("HDSD00.11.414")	//手术操作名称2
	
	
		s SSJCZBM3 = ArrGlossary.GetAt("HDSD00.11.425")	//手术操作编码3
		s SSJCZMC3 = ArrGlossary.GetAt("HDSD00.11.429")	//手术操作名称3
		
		s SSJCZBM4 = ArrGlossary.GetAt("HDSD00.11.440")	//手术操作编码4
		s SSJCZMC4 = ArrGlossary.GetAt("HDSD00.11.444")	//手术操作名称4
		
		s SSJCZBM5 = ArrGlossary.GetAt("HDSD00.11.455")	//手术操作编码5
		s SSJCZMC5 = ArrGlossary.GetAt("HDSD00.11.459")	//手术操作名称5
		
		s SSJCZBM6 = ArrGlossary.GetAt("HDSD00.11.470")	//手术操作编码6
		s SSJCZMC6 = ArrGlossary.GetAt("HDSD00.11.474")	//手术操作名称6
		
		s SSJCZBM7 = ArrGlossary.GetAt("HDSD00.11.485")	//手术操作编码7
		s SSJCZMC7 = ArrGlossary.GetAt("HDSD00.11.489")	//手术操作名称7
		
		s SSJCZBM8 = ArrGlossary.GetAt("HDSD00.11.500")	//手术操作编码8
		s SSJCZMC8 = ArrGlossary.GetAt("HDSD00.11.504")	//手术操作名称8
		
		s PAYTYPE = ArrGlossary.GetAt("HDSD00.11.117")	//支付类型
		
		s RECSIZE= 3	//推荐结果数量
		
		s Data= $LB(caseId,GENDER,AGE,TOTALEXPENSE,ACCTUALDAYS,B11C,SF0108,DISEASENAME,DISEASECODE,QTZD1,JBDM1,QTZD2,JBDM2,QTZD3,JBDM3,QTZD4,JBDM4,QTZD5,JBDM5,QTZD6,JBDM6,QTZD7,JBDM7,QTZD8,JBDM8,QTZD9,JBDM9,QTZD10,JBDM10,QTZD11,JBDM11,QTZD12,JBDM12,QTZD13,JBDM13,QTZD14,JBDM14,QTZD15,JBDM15,QTZD16,JBDM16,QTZD17,JBDM17,QTZD18,JBDM18,QTZD19,JBDM19,QTZD20,JBDM20,QTZD21,JBDM21,QTZD22,JBDM22, SSJCZBM1,SSJCZMC1,SSJCZBM2,SSJCZMC2,SSJCZBM3,SSJCZMC3,SSJCZBM4,SSJCZMC4,SSJCZBM5,SSJCZMC5,SSJCZBM6,SSJCZMC6,SSJCZBM7,SSJCZMC7,SSJCZBM8,SSJCZMC8,PAYTYPE,RECSIZE,SF0100,SF0102,SF0102B,SF0104,ICU,CRRT,PDT)
		s ^CacheTemp(repid,ind)=Data
		s ind=ind+1
	
	Quit $$$OK
}

ClassMethod GetFirstRecordInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetFirstRecordInfoExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetFirstRecordInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetFirstRecordInfoExecute ]
{
	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	
 	s ind = $o(^CacheTemp(repid,ind))
 	if (ind = "") 
 	{
 		s AtEnd = 1
 		s Row = ""
 		k ^CacheTemp(repid)
 	} 
 	else 
 	{	
 		s Row = ^CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 
/// Debug:  w ##Class(EPRservice.Quality.Interface.FirstPageDRGQInfo).InputWMRHomePageInfo(20064440)
ClassMethod InputWMRHomePageInfo(AEpisodeID As %String) As %String
{
	s Result = ##class(%ResultSet).%New("EPRservice.Quality.Interface.FirstPageDRGQInfo:GetFirstRecordInfo")
	d Result.%Execute(AEpisodeID)
	
	while (Result.Next())
	{
		s json={}
		
		d json.%Set("CASE_ID",Result.Data("caseId"))
		s json.GENDER=Result.Data("GENDER")
		s json.AGE=Result.Data("AGE")
		d json.%Set("DISEASE_CODE",Result.Data("DISEASECODE"))
		d json.%Set("DISEASE_NAME",Result.Data("DISEASENAME"))
		d json.%Set("TOTAL_EXPENSE",Result.Data("TOTALEXPENSE"))
		d json.%Set("ACCTUAL_DAYS",Result.Data("ACCTUALDAYS"))
	    s json.SF0100=Result.Data("SF0100")
	    s json.SF0102=Result.Data("SF0102")
	    d json.%Set("SF0102_B",Result.Data("SF0102B"))
	    s json.SF0104=Result.Data("SF0104")
	    s json.B11C=Result.Data("B11C")
		s json.SF0108=Result.Data("SF0108")
		
		//拼诊断信息
		s jsonsubdiag=[]
		s diagconfig= "QTZD1^JBDM1$QTZD2^JBDM2$QTZD3^JBDM3$QTZD4^JBDM4$QTZD5^JBDM5$QTZD6^JBDM6$QTZD7^JBDM7$QTZD8^JBDM8$QTZD9^JBDM9$QTZD10^JBDM10$QTZD11^JBDM11$QTZD12^JBDM12$QTZD13^JBDM13$QTZD14^JBDM14$QTZD15^JBDM15$QTZD16^JBDM16$QTZD17^JBDM17$QTZD18^JBDM18$QTZD19^JBDM19$QTZD20^JBDM20$QTZD21^JBDM21$QTZD22^JBDM22"
		for i=1:1:$l(diagconfig,"$")
		{
			s diagconfigsub=$p(diagconfig,"$",i)
			
			s NAME = $p(diagconfigsub,"^",1)
			s CODE = $p(diagconfigsub,"^",2)
			continue:((Result.Data(NAME)="")||(Result.Data(CODE)=""))
			
			
			s MapICD=##class(MA.IPMR.IO.OutService).IGetMapICD("诊断","国家临床版","V2.0","医保版","V2.0",Result.Data(CODE))
			
		    if ($p(MapICD,"^",1)=1)
			{
				s MapICDCODE=$p(MapICD,"^",2)
				s MapICDNAME=$p(MapICD,"^",3)
			}
			else
			{
				s MapICDCODE=Result.Data(CODE)
				s MapICDNAME=Result.Data(NAME)
			}
			
			
			s jsonsub={}
			s jsonsub.CODE =MapICDCODE
			s jsonsub.NAME=MapICDNAME
			//s jsonsub.CODE =Result.Data(CODE)
			//s jsonsub.NAME=Result.Data(NAME)
			d jsonsubdiag.%Push(jsonsub)
			
		}
		d json.%Set("DIAGS_CODE",jsonsubdiag)
		
		//拼手术信息
		s jsonsuboper = []
		s operconfig="SSJCZBM1^SSJCZMC1$SSJCZBM2^SSJCZMC2$SSJCZBM3^SSJCZMC3$SSJCZBM4^SSJCZMC4$SSJCZBM5^SSJCZMC5$SSJCZBM6^SSJCZMC6$SSJCZBM7^SSJCZMC7$SSJCZBM8^SSJCZMC8"
		for i=1:1:$l(operconfig,"$")
		{
			s TYPE=""
			s operconfigsub=$p(operconfig,"$",i)
			
			s CODE = $p(operconfigsub,"^",1)
			s NAME = $p(operconfigsub,"^",2)
		    continue:((Result.Data(NAME)="")||(Result.Data(CODE)=""))
		    
		    s MapICD=##class(MA.IPMR.IO.OutService).IGetMapICD("手术","国家临床版","V2.0","医保版","V2.0",Result.Data(CODE))
			if ($p(MapICD,"^",1)=1)
			{
				s MapICDCODE=$p(MapICD,"^",2)
				s MapICDNAME=$p(MapICD,"^",3)
			}
			else
			{
				s MapICDCODE=Result.Data(CODE)
				s MapICDNAME=Result.Data(NAME)
			}
			
			s jsonsub={}
			s jsonsub.CODE =MapICDCODE
			s jsonsub.NAME=MapICDNAME
			//s jsonsub.CODE =Result.Data(CODE)  
			//s jsonsub.NAME=Result.Data(NAME)
			s jsonsub.TYPE =TYPE
			d jsonsuboper.%Push(jsonsub)
		}
		d json.%Set("OPERS_CODE",jsonsuboper)
			
		d json.%Set("PDT", Result.Data("PDT"))
		d json.%Set("CRRT", Result.Data("CRRT"))
		d json.%Set("ICU", Result.Data("ICU"))
		d json.%Set("SF0102_B", Result.Data("SF0102B"))
		//d json.%Set("PAY_TYPE", Result.Data("PAYTYPE"))
		d json.%Set("PAY_TYPE","1")      //标库写死，项目根据接口要求配置
		d json.%Set("STD_YEAR","2022-11")   //标库写死，项目根据接口要求配置
		d json.%Set("REC_SIZE", Result.Data("RECSIZE"))

	
	
	}
	
	q json.%ToJSON()
}

/// w ##Class(EPRservice.Quality.Interface.FirstPageDRGQInfo).GetWMRQualityResult(18)
ClassMethod GetWMRQualityResult(AEpisodeID As %String) As %String
{
	s msgInfo=""
	s (YPFeeRate,HCFeeRate)=""
	s PatFee=..GetPatFee(AEpisodeID,"")
	
	if (PatFee'="")
	{
		s YPFeeRate=$p(PatFee,"^",1)
		s HCFeeRate=$p(PatFee,"^",2)
	}
	s ArrGlossary=##class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossary(AEpisodeID,"HDSD00.11")
	s ZYOPER= ArrGlossary.GetAt("HDSD00.11.090")	//手术及操作名称1
	s ZYDIAG = ArrGlossary.GetAt("HDSD00.11.024")	    //主要诊断
	//获取入参
	s Input = ..InputWMRHomePageInfo(AEpisodeID)
	
	//初始化代理对象
	s soap = ##class(EPRservice.Quality.Soap.PreGroupWebServicePort).%New()  
	s soap.Timeout=5
	s soap.SSLConfiguration="SSLECP"
	s soap.SSLCheckServerIdentity=0
	
	//执行接口
	s soapResult=soap.recGroup(Input)
	
	//解析返回值
	s json = {}.%FromJSON(soapResult)
	
	if (json.%Get("result_code")="0")
	{
	    		
		//循环替换诊断编码
		
		s jsonRecResult = json.%Get("result_data").%Get("REC_RESULT")
		
		s rectotal = jsonRecResult.%Size()
		for i=0:1:(rectotal-1)
		{
			s DISEASECODE = jsonRecResult.%Get(i).%Get("DISEASE_CODE")
			
			s exchange = ##class(MA.IPMR.IO.OutService).IGetMapICD("诊断","医保版","V2.0","国家临床版","V2.0",DISEASECODE)
			if (+exchange=1)
			{
				d jsonRecResult.%Get(i).%Set("DISEASE_CODE",$p(exchange,"^",2))
				d jsonRecResult.%Get(i).%Set("DISEASE_NAME",$p(exchange,"^",3))
			}
			
			s OTHERDIAGS = jsonRecResult.%Get(i).%Get("OTHER_DIAGS")
			s otherdiagcount = OTHERDIAGS.%Size()
			for subdiag=0:1:(otherdiagcount-1)
			{
				s diagCode = OTHERDIAGS.%Get(subdiag).%Get("CODE")
				s exchange = ##class(MA.IPMR.IO.OutService).IGetMapICD("诊断","医保版","V2.0","国家临床版","V2.0",diagCode)
			
				if (+exchange=1)
				{
					d jsonRecResult.%Get(subdiag).%Set("CODE",$p(exchange,"^",2))
					d jsonRecResult.%Get(subdiag).%Set("NAME",$p(exchange,"^",3))
				}
			}
		
			s OPERCODE = jsonRecResult.%Get(i).%Get("OPER_CODE")
			
			s exchange = ##class(MA.IPMR.IO.OutService).IGetMapICD("手术","医保版","V2.0","国家临床版","V2.0",OPERCODE)
			if (+exchange=1)
			{
				d jsonRecResult.%Get(i).%Set("OPER_CODE",$p(exchange,"^",2))
				d jsonRecResult.%Get(i).%Set("OPER_NAME",$p(exchange,"^",3))
			}
			
			s OTHEROPERS = jsonRecResult.%Get(i).%Get("OTHER_OPERS")
			s otheropercount = OTHEROPERS.%Size()
			for suboper=0:1:(otheropercount-1)
			{
				s operCode = OTHEROPERS.%Get(suboper).%Get("Code")
				s exchange = ##class(MA.IPMR.IO.OutService).IGetMapICD("手术","医保版","V2.0","国家临床版","V2.0",operCode)
			
				if (+exchange=1)
				{
					d jsonRecResult.%Get(suboper).%Set("CODE",$p(exchange,"^",2))
					d jsonRecResult.%Get(suboper).%Set("NAME",$p(exchange,"^",3))
				}
			}
			
		}
		
		//新增药占比、耗占比,主要手术、主要诊断
		d json.%Get("result_data").%Set("YPFeeRate",YPFeeRate)
		d json.%Get("result_data").%Set("HCFeeRate",HCFeeRate)
		d json.%Get("result_data").%Set("ZYOPER",ZYOPER)
		d json.%Get("result_data").%Set("ZYDIAG",ZYDIAG)
	}
	q json.%ToJSON()
}

/// w ##Class(EPRservice.Quality.Interface.FirstPageDRGQInfo).GetPatFee(18)
ClassMethod GetPatFee(AEpisodeID As %String, AHospitalID As %String = "")
{
	s ret=""
	q:(AEpisodeID="") ret
	//药品费、耗材费
	s YPFee=0,HCFee=0
	s InPatFee=##class(EMRservice.HISInterface.PatientInfoAssist).InPatCostTrakCareNew(AEpisodeID,AHospitalID)
	q:(InPatFee["异常") ret
	s arrFee=##class(%ArrayOfDataTypes).%New()
	s FeeNum=$l(InPatFee,"!")
	s i=0,FeeList="",tmpFee=""
	s CheckFee=0
	f i=1:1:FeeNum 
	{
		
		s tmpFee=$p(InPatFee,"!",i)
		s FeeType=$p(tmpFee,"^",2)
		s FeeNum=$p(tmpFee,"^",3)
		d arrFee.SetAt(FeeNum,FeeType)
		
		s:(i>1) CheckFee=CheckFee+ FeeNum
		s:(i=1) CheckTotal=FeeNum
			
	}
 
 	
	s MCTotal = arrFee.GetAt("总费用")
	s TMC13XYF = arrFee.GetAt("西药费")
	s TMC14ZCYF = arrFee.GetAt("中成药费")
	s TMC15ZCYF = arrFee.GetAt("中草药费")
	s TMC17BDBLZPF = arrFee.GetAt("白蛋白类制品费")
	s TMC18QDBLZPF = arrFee.GetAt("球蛋白类制品费")
	s TMC19NXYZLZPF = arrFee.GetAt("凝血因子类制品费")
	s TMC20XBYZLZPF = arrFee.GetAt("细胞因子类制品费")
	
	s TMC21JCYYCXYYCLF = arrFee.GetAt("检查用一次性医用材料费")
	s TMC22ZLYYCXYYCLF = arrFee.GetAt("治疗用一次性医用材料费")
	s TMC23SSYYCXYYCLF = arrFee.GetAt("手术用一次性医用材料费")
	s YPFee=TMC13XYF+TMC14ZCYF+TMC15ZCYF+TMC17BDBLZPF+TMC18QDBLZPF+TMC19NXYZLZPF+TMC20XBYZLZPF
	s HCFee=TMC21JCYYCXYYCLF+TMC22ZLYYCXYYCLF+TMC23SSYYCXYYCLF
	s YPFeeRate = $s(+MCTotal=0:"0%",1:$j(YPFee/MCTotal,1,4))*100_"%"
	s HCFeeRate = $s(+MCTotal=0:"0%",1:$j(HCFee/MCTotal,1,4))*100_"%"
	s ret=YPFeeRate_"^"_HCFeeRate_"^"_MCTotal_"^"_YPFee_"^"_HCFee
	q ret
}

/// w ##Class(EPRservice.Quality.Interface.FirstPageDRGQInfo).SaveDRGDIPQuoteResult(285,"","0")
ClassMethod SaveDRGDIPQuoteResult(AEpisodeID As %String, ADRGDIPResult As %String, AKey As %String) As %String
{
	//s ^KKTemp=$lb(AEpisodeID,ADRGDIPResult,AKey)
	//s ADRGDIPResult = "[{""AVG_FEE"":null,""DISEASE_CODE"":""A01.000"",""DISEASE_NAME"":""伤寒"",""FEE_RATIO"":null,""FIGURE"":null,""GROUP_CODE"":""A01X-MX-01"",""GROUP_DESC"":""A01|伤寒和副伤寒||"",""INDEX"":0,""OPER_CODE"":""06.0902"",""OPER_NAME"":""甲状腺切开引流术"",""OPER_TYPE"":"""",""OTHER_DIAGS"":[{""CODE"":""E11.900"",""IS_ADD"":false,""NAME"":""2型糖尿病""},{""CODE"":""E04.102"",""IS_ADD"":false,""NAME"":""甲状腺囊肿""}],""OTHER_OPERS"":[],""PAY_FEE"":0,""PROFIT"":-90158.21,""RATIO_DESC"":""无支付标准"",""STD_FEE"":null,""WEIGHT"":null}]"
	s ret=0
	q:(AEpisodeID="") ret
	s sc = ..DeleteDRGDIPQuoteResult(AEpisodeID)
	
	s resultJson=[].%FromJSON(ADRGDIPResult)
	s quoteResult = resultJson.%Get(AKey)
	
	s mainDiagCode = quoteResult.%Get("DISEASE_CODE")
	s mainDiagName = quoteResult.%Get("DISEASE_NAME")
	d saveDrgDipData(mainDiagCode,mainDiagName,"DIAG")
	
	s mainOperCode = quoteResult.%Get("OPER_CODE")
	s mainOperName = quoteResult.%Get("OPER_NAME")
	d saveDrgDipData(mainOperCode,mainOperName,"OPER")
	
	s otherDiags = quoteResult.%Get("OTHER_DIAGS")
	
	set iteratorDiag=otherDiags.%GetIterator()
   	while iteratorDiag.%GetNext(.key,.val) 
   	{ 
   		
   		s code = val.%Get("CODE")
   		s value = val.%Get("NAME") 
   		d saveDrgDipData(code,value,"DIAG")
   	}
	
	s otherOpers = quoteResult.%Get("OTHER_OPERS")
	set iteratorOper=otherOpers.%GetIterator()
   	while iteratorOper.%GetNext(.key,.val) 
   	{ 
   		s code = val.%Get("CODE")
   		s value = val.%Get("NAME") 
   		d saveDrgDipData(code,value,"OPER")
   	}
	
	
	s ret=1
	q ret
saveDrgDipData(code,value,type)
	
	q:(code="")||(type="")
	s obj = ##class(EPRinstance.Quality.DrgDip.QuotePlanResult).%New()
	s obj.Code=code
	s obj.Value=value
	s obj.Type = type
	s obj.EpisodeID=AEpisodeID
	s sc=obj.%Save()
	if ($$$ISOK(sc))
	{
			
	}
	q
}

ClassMethod DeleteDRGDIPQuoteResult(AEpisodeID As %String) As %String
{
	s result=""
	q:(AEpisodeID="") result
	s resultList=""
	s tmpId=""
	for
	{
		s tmpId = $o(^DHCEPRQ.QuotePlanResultI("IdxEpisodeID"," "_AEpisodeID,tmpId))
		q:(tmpId="")
		
		d ##class(EPRinstance.Quality.DrgDip.QuotePlanResult).%DeleteId(tmpId)
		
	}
	q 1
}

}
