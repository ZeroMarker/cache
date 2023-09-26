/// Desc: 电子病历取HIS信息接口类
/// History:
/// <+>2010-10-28 	修改BirthPlace(),增加默认参数
/// <+>2010-11-04	增加InhsAdmDateTime(),护理组入院日期时间
/// <+>2010-11-10	增加SpecTransDeptDetail(),取特定科室转科信息
/// <+>2010-11-11 	修改Gender(),没有性别信息时需要返回空数据
/// <+>2010-11-23 	增加: Parameter HospitalLZDXDEYY = "LZDXDEYY";
/// <+>2010-12-29	修改AdmDiagnos(),增加入院诊断类型C008
/// <+>2011-03-25	增加检验接口函数: GetLabRs() GetBldPrdGrp()	GetLabBldInfo()
/// <+>2011-04-11  	处理PayModeLink()为空的情况
/// <+>2011-04-27	DiagnosInfo()中的诊断描述加入备注信息
/// <+>2011-04-29	增加GetOrderHours(),取按小时计费医嘱的持续时间(单位为小时)
/// <+>2011-11-15	修改PayModeLink(),使用新的视图名称
/// <+>2011-11-17	增加病案首页付款方式新国标描述Parameter
/// 					修改BirthPlace(),兼容更多方式
/// 					修改WorkPostCode(),兼容中国医学科学院肿瘤医院
/// 					修改HuKouPostCode(),兼容中国医学科学院肿瘤医院
/// 					增加DischgDoc()
/// 					增加SeniorDoc()
/// 					修改SpecTransDeptDetail()变量名手误
/// 					修改InTimes(),优先使用PA_Adm.InPatNo
/// 					修改PayMode(),兼容中国医学科学院肿瘤医院
/// 					修改GetDiagnos(),兼容仅写诊断备注的情况
/// 					OutDiag，兼容名字空间
/// 					Ageold，兼容名字空间
/// <+>2011-11-25	修改下列方法，去掉描述中的拼音码
/// 					EmployType()
/// 					EmployStatus()
/// 					NativeRegion()
/// 					NativeArea()
/// 					AddressRegion()
/// 					AddressArea()
/// <+>2012-04-20	新增IPRecordNoInfo(),用以在电子病历基本信息界面显示病案号
/// <+>2013-03-18   GetOrderByPriority 修改备注信息
/// 					GetDiagnosByType 修改程序,兼容接口程序处理
/// 					GetOrders 修改报错的问题,UserID不能为空
/// 					GetPatScoreByAdmAndScoreType 添加新方法,北京协和医院 获取护理组急诊病人评分 与护理组彭俊福协作
/// 					GetOrderDetailByOrdCat 添加新方法,北京协和医院 门诊急诊绑定药品,检查,检验 医嘱 等
/// 					IPRecordNoByMR 添加新方法,南通大学附院 医政组提供的病案号接口
/// 					GetDischCondition 添加新方法,温岭市第一人民医院 取医生医疗结算的出院条件
/// 					EPRecordNoWMR 添加新方法,北京地坛医院 医政组提供急诊号
/// 					GetAllergen 合并新方法,聊城脑科医院 
Class EPRservice.HISInterface.PatientInfoAssist Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 北京安贞医院
Parameter HospitalBJAZYY = "BJAZYY";

/// 01 北京积水潭医院 ok
Parameter HospitalBJJSTYY = "BJJSTYY";

/// 02 粤北人民医院 ok
Parameter HospitalYBRMYY = "YBRMYY";

/// 03 安徽省立医院
Parameter HospitalAHSLYY = "AHSLYY";

/// 04 西安交大口腔医院
Parameter HospitalXAJDKQYY = "XAJDKQYY";

/// 05 北京地坛医院
Parameter HospitalBJDTYY = "BJDTYY";

/// 06 宁医一附院
Parameter HospitalNYYFY = "NYYFY";

/// 07 厦门翔鹭体检中心
Parameter HospitalXMXLTJZX = "XMXLTJZX";

/// 08 上海华山东院
Parameter HospitalSHHSDY = "SHHSDY";

/// 09 宁波明洲医院
Parameter HospitalNBMZYY = "NBMZYY";

/// 10 华西二院
Parameter HospitalHXEY = "HXEY";

/// 11 华西医院
Parameter HospitalHXYY = "HXYY";

/// 12 中国医大一附院
Parameter HospitalZGYDYFY = "ZGYDYFY";

/// 13 北京中医医院
Parameter HospitalBJZYYY = "BJZYYY";

/// 14 北京妇产医院
Parameter HospitalBJFCYY = "BJFCYY";

/// 15 衢州人民医院
Parameter HospitalQZRMYY = "QZRMYY";

/// 16 潍坊市人民医院
Parameter HospitalWFSRMYY = "WFSRMYY";

/// 17 深圳中医医院
Parameter HospitalSZZYYY = "SZZYYY";

/// 18 长春妇产医院
Parameter HospitalCCFCYY = "CCFCYY";

/// 19 长春吉大三院
Parameter HospitalCCJDSY = "CCJDSY";

/// 20 医科院肿瘤医院
Parameter HospitalYKYZLYY = "YKYZLYY";

/// 21 上海东方医院
Parameter HospitalSHDFYY = "SHDFYY";

/// 22 大同三院
Parameter HospitalDTSY = "DTSY";

/// 23 南通通大附院
Parameter HospitalNTDXFY = "NTDXFY";

/// 24 安徽心脑心血医院
Parameter HospitalAHXNXGYY = "AHXNXGYY";

/// 25 中国石油中心医院
Parameter HospitalZGSYZXYY = "ZGSYZXYY";

/// 26 徐州市中心医院
Parameter HospitalXZSZXYY = "XZSZXYY";

/// 27 兰州大学第二医院
Parameter HospitalLZDXDEYY = "LZDXDEYY";

/// 28 武汉儿童医院
Parameter HospitalWHETYY = "WHETYY";

/// 29 武汉第一医院
Parameter HospitalWHDYYY = "WHDYYY";

/// 30 北京协和医院
Parameter HospitalBJXHYY = "BJXHYY";

Parameter Had = "有";

Parameter Hadnot = "无";

Parameter Negative = "阴性";

Parameter Positive = "阳性";

Parameter NotExamined = "未查";

Parameter NoTransDept = "无";

Parameter OperationFinished = "完成";

Parameter CadaverExamYes = "是";

Parameter PayTypeDBTC = "大病统筹";

Parameter PayTypeGFYL = "公费医疗";

Parameter PayTypeGF = "公费";

Parameter PayTypeQT = "其它";

Parameter PayTypeSYBX = "商业保险";

Parameter PayTypeYLBX = "医疗保险";

Parameter PayTypeZFYL = "自费医疗";

Parameter PayTypeZF = "自费";

Parameter PayTypeSHJBYLBX = "社会基本医疗保险";

Parameter PayTypeCZZGYB = "城镇职工医保";

Parameter PayTypeCZJMYB = "城镇居民医保";

Parameter PayTypeXNH = "新农合";

Parameter PayTypeSYJKBX = "商业健康保险";

/// 新病案首页2012版
Parameter PayTypeQT2 = "其他";

/// 新病案首页2012版
Parameter PayTypeCZZGJBYLBX = "城镇职工基本医疗保险";

/// 新病案首页2012版
Parameter PayTypeCZJMJBYLBX = "城镇居民基本医疗保险";

/// 新病案首页2012版
Parameter PayTypeXXNCHZYL = "新型农村合作医疗";

/// 新病案首页2012版
Parameter PayTypePKJZ = "贫困救助";

/// 新病案首页2012版
Parameter PayTypeSYYLBX = "商业医疗保险";

/// 新病案首页2012版
Parameter PayTypeQGF = "全公费";

/// 新病案首页2012版
Parameter PayTypeGZF = "全自费";

/// 新病案首页2012版
Parameter PayTypeQTSHBX = "其他社会保险";

/// Desc：	取患者指针(PatientID)，not different from hospitals
/// Table:	PA_Adm.PAADM_PAPMI_DR
/// Others：被下列模板引用
/// 		[病案质控]EPRmeta.Quality.QualityExamSet
/// 		[模板控制]EPRservice.TPrivLogic.PatientInfoAssist
ClassMethod GetPapmiDR(argAdmId As %String) As %String
{
	q:(($d(argAdmId)=0)||(argAdmId="")) ""
	
	s retValue = ""
	s retValue = $P($g(^PAADM(argAdmId)),"^",1)
	q:(retValue '= "") retValue

	//华西医院：global节点中的数据丢失，但sql语句可以查询出数据
	&sql(select PAADM_PAPMI_DR into :retValue from SQLUser.PA_Adm where PAADM_RowId = :argAdmId)
	q retValue
}

/// Desc：	取患者指针，not different from hospitals
/// Table：	PA_Person 和 PA_PatMas 共用同一个RowId
ClassMethod GetPaperDR(argPapmiDR As %String) As %String
{
	q:(($d(argPapmiDR)=0)||(argPapmiDR="")) ""
	q argPapmiDR
}

/// Desc: 	PA_Adm.PAADM_ADMNo
ClassMethod GetEpisodeNo(argAdmId As %String)
{
	q:(($d(argAdmId)=0)||(argAdmId="")) ""
	q $P($g(^PAADM(argAdmId)),"^",81)
}

/// Desc：	取患者登记号，not different from hospitals
/// Table:	PA_PatMas.PAPMI_IPNo
/// Others：被下列模块引用
/// 		[病案质控]EPRmeta.Quality.QualityExamSet
ClassMethod GetPapmiNo(argPapmiDR As %String) As %String
{
	q:(($d(argPapmiDR)=0)||(argPapmiDR="")) ""
	q $P($g(^PAPER(argPapmiDR,"PAT",1)),"^",1)
}

/// Desc: 	取患者就诊类型
/// Table:	PA_Adm.PAADM_Type
ClassMethod GetEpisodeType(argAdmId As %String)
{
	q:(($d(argAdmId)=0)||(argAdmId="")) ""
	q $P($g(^PAADM(argAdmId)),"^",2)
}

/// Desc:	姓名，not different from hospitals 
/// Others：被下列模块引用
/// 		[病案质控]EPRmeta.Quality.QualityExamSet
/// ModifyDate: 2009-08-06
/// ModifyDesc: 去掉姓名两端的空格	
ClassMethod Name(argPaperDR As %String) As %String
{
	q:($d(argPaperDR)=0)||(argPaperDR="") ""
	s name=""
	
	q:($d(^PAPER(argPaperDR,"ALL"))'=1)&&($d(^PAPER(argPaperDR,"ALL"))'=11) ""
	s name=$P($G(^PAPER(argPaperDR,"ALL")),"^",1)
	s name = ..Trim(name)
		
	q name
}

/// CreateUser: LiaoWP
/// CreateDate: 20009-08-06
/// Desc: 去掉字符串两端的空格
/// Input: argStr:原始字符串
/// Return：去掉两端空格的字符串
ClassMethod Trim(argStr As %String) As %String
{
	Q:(argStr="") ""
	
	Set sLoc=0,eLoc=0,StrLen=0,sChar="",eChar="",i=0
	Set StrLen=$l(argStr)
	for i=1:1:StrLen
	{
		Set sLoc=i,sChar=$E(argStr,i)
		Q:(sChar'=" ")
	}
	for i=StrLen:-1:1
	{
		Set eLoc=i,eChar=$E(argStr,i)
		Q:(eChar'=" ")
	}
	
	s RtnStr=$E(argStr,sLoc,eLoc)
	Q RtnStr
}

/// Desc:	性别，not different from hospitals
/// Output:	RowId^Code^Desc
/// Others:	被下列模块引用
/// 		[模板控制]EPRservice.TPrivLogic.PatientInfoAssist 
ClassMethod Gender(argPaperDR As %String, argHospital As %String = "") As %String
{
	q:(($d(argPaperDR)=0)||(argPaperDR="")) ""
	s genderDR="",gender="",gendercode=""

	q:($d(^PAPER(argPaperDR,"ALL"))'=1)&&($d(^PAPER(argPaperDR,"ALL"))'=11) ""
	s genderDR=$P($G(^PAPER(argPaperDR,"ALL")),"^",7)
	if genderDR'="" 
	{ 
		s gendercode=$P($g(^CT("SEX",genderDR)),"^",1)
		s gender=$P($g(^CT("SEX",genderDR)),"^",2)
		s gender=genderDR_"^"_gendercode_"^"_gender
	}

	q gender
}

/// Desc:	婚姻状态
/// Output:	RowId^Code^Desc
ClassMethod Marriage(argPaperDR As %String, argHospital As %String = "") As %String
{
	q:(($d(argPaperDR)=0)||(argPaperDR="")) ""
	s maritalDR="",marital=""
	
	q:(($d(^PAPER(argPaperDR,"PER",2))'=1)&&($d(^PAPER(argPaperDR,"PER",2))'=11)) ""
	if argHospital=..#HospitalBJJSTYY	//北京积水潭
	{	s maritalDR=$P($G(^PAPER(argPaperDR,"PER",2)),"^",1)}
	else
	{
		s maritalDR=$P($G(^PAPER(argPaperDR,"PER",2)),"^",3)
	}
	
	if maritalDR'=""  
	{
		s code = $p($g(^CT("MAR",maritalDR)),"^",1)
		s desc = $p($g(^CT("MAR",maritalDR)),"^",2)
		s:($l(desc,"-")>1) desc=$tr($p($g(desc),"-",2)," ","")	//处理例如格式"4 - 丧偶"

		s marital=maritalDR_"^"_code_"^"_desc
	}
	
	q marital
}

/// Desc:	婚姻状态
/// Output:	RowId^Code^Desc
ClassMethod MaritalStatus(argPaperDR As %String) As %String
{
	q:(($d(argPaperDR)=0)||(argPaperDR="")) ""
	q ..Marriage(argPaperDR)
}

/// Desc:	身份证号
/// Table:	PA_Person.PAPER_ID
/// Others：not different from others
ClassMethod IDCard(argPaperDR As %String)
{
	q:($d(argPaperDR)=0)||(argPaperDR="") ""
	s idcard=""
	
	q:(($d(^PAPER(argPaperDR,"ALL"))'=1)&&($d(^PAPER(argPaperDR,"ALL"))'=11)) ""
	s idcard=$P($G(^PAPER(argPaperDR,"ALL")),"^",9)
	
	q idcard
}

/// Desc:	民族
/// Output：RowId^Code^Desc
/// Others: not different from hospitals
ClassMethod Nation(argPaperDR As %String, argHospital As %String = "") As %String
{
	q:(($d(argPaperDR)=0)||(argPaperDR="")) ""
	s retValue=""
	
	q:(($d(^PAPER(argPaperDR,"PER",2))'=1)&&($d(^PAPER(argPaperDR,"PER",2))'=11)) ""
	s nationDR=$P($G(^PAPER(argPaperDR,"PER",2)),"^",1)
	q:(nationDR="") ""
	s code=$p($g(^CT("NAT",nationDR)),"^",1)
	s desc=$p($g(^CT("NAT",nationDR)),"^",2)
	if $l(desc,"-")>1 {s desc=$p($g(desc),"-",2)}
	s retValue=nationDR_"^"_code_"^"_desc
	
	q retValue
}

/// Desc:	国籍
/// Output：RowId^Code^Desc
/// Others: not different from hospitals
ClassMethod Country(argPaperDR As %String, argHospital As %String = "") As %String
{
	q:(($d(argPaperDR)=0)||(argPaperDR="")) ""
	s retValue = ""
	
	q:(($d(^PAPER(argPaperDR,"PER",1))'=1)&&($d(^PAPER(argPaperDR,"PER",1))'=11)) ""	
	s countryDR=$P($G(^PAPER(argPaperDR,"PER",1)),"^",8)
	if (countryDR '= "")
	{
		s code = $p($g(^CT("COU",countryDR)),"^",1)
		s desc=$p($g(^CT("COU",countryDR)),"^",2)
		if $l(desc,"-")>1 {s desc=$p($g(desc),"-",2)}
		s retValue=countryDR_"^"_code_"^"_desc	
	}
		
	q retValue
}

/// Desc:	职业
/// Output：RowId^Code^Desc
/// Others: not different from hospitals
ClassMethod Occupation(argPaperDR As %String, argHospital As %String = "", argCDType As %String = "", argCDCode As %String = "") As %String
{
	
	q:(($d(argPaperDR)=0)||(argPaperDR="")) ""
	s retValue = ""
	
	q:(($d(^PAPER(argPaperDR,"PER",2))'=1)&&($d(^PAPER(argPaperDR,"PER",2))'=11)) ""
	s occupationDR=$P($G(^PAPER(argPaperDR,"PER",2)),"^",6)
	i occupationDR'=""  
	{
		s occupationcode=$p($g(^CT("OCC",occupationDR)),"^",1)
		s occupationdesc=$p($g(^CT("OCC",occupationDR)),"^",2)
		i ($l(occupationdesc,"-")>1) {s occupationdesc=$p($g(occupationdesc),"-",2)}
		s retValue=occupationDR_"^"_occupationcode_"^"_occupationdesc
		
		//通过入参判断是否进行数据替换处理
		if (argCDType'="") 
		{
			s relation=..GetCustomDictionaryLinkByCode(argCDType,argCDCode)
			s relation=relationDR_"^"_relation
		}
	}	
	
	q retValue
}

/// Desc:	出生日期【内部格式】
/// Others：not different from hospitals 
ClassMethod Birthday(argPapmiDR As %String) As %String
{
	q:($d(argPapmiDR)=0)||(argPapmiDR="") ""
	s Birthday=""
	
	q:(($d(^PAPER(argPapmiDR,"ALL"))'=1)&&($d(^PAPER(argPapmiDR,"ALL"))'=11)) ""
	s Birthday=$P($G(^PAPER(argPapmiDR,"ALL")),"^",6)
	
	q Birthday
}

/// Desc：	出生地
/// Input:	AIsNative 是否取旧出生地字段(即原来的籍贯),默认不取
/// Output：省^市^县
/// 20120418 wangwentao update
ClassMethod BirthPlace(argPapmiDR As %String, argHospital As %String = "", AIsNative As %String = "0") As %String
{
	q:($d(argPapmiDR)=0)||(argPapmiDR="") ""
	
	s birthPlace=""
	
	q:(($d(^PAPER(argPapmiDR,"ALL"))'=1)&&($d(^PAPER(argPapmiDR,"ALL"))'=11)) ""
	
	//新出生地字段
	//PAPER_CT_Province_DR
	s provinceDR = $p($g(^PAPER(argPapmiDR,"PER",4)),"^",2)
	//PAPER_CityCode_DR
	s cityBirthDR = $p($g(^PAPER(argPapmiDR,"PER",1)),"^",5)
	//PAPER_CityArea_DR
	s cityAreaDR =  $p($g(^PAPER(argPapmiDR,"PER",4)),"^",9)
	
	//新出生地字段
	//若省份为空城市不为空，可通过市获取省份信息
	if (provinceDR="")&&(cityBirthDR'="")
	{
		s provinceDR = $p($g(^CT("CIT",cityBirthDR)),"^",4)
	}
	
	//特殊处理
	if (AIsNative=1) {
		
		//取旧出生地字段(即原来的籍贯)
		if (provinceDR="")||(cityBirthDR="") {
			
			s cityBirthDR=$P($g(^PAPER(argPapmiDR,"ALL")),"^",18)
			s provinceDR = $P($g(^PAPER(argPapmiDR,"PER",2)),"^",11)
			s cityAreaDR = ""
			//若省份为空，可通过市获取省份信息
			if (provinceDR="")&&(cityBirthDR'="") s provinceDR = $p($g(^CT("CIT",cityBirthDR)),"^",4)
		}	
	}
	
	s birthCity="",	birthProvince=""
	if (cityBirthDR'="")&&(provinceDR'="") 
	{
		s birthCityDesc = $p($g(^CT("CIT",cityBirthDR)),"^",2)
		i $l(birthCityDesc,"-")'=1 {s birthCityDesc=$p($g(birthCityDesc),"-",2)} 
		s birthCityCode = $p($g(^CT("CIT",cityBirthDR)),"^",1)
		s birthCity = cityBirthDR_"^"_birthCityCode_"^"_birthCityDesc
		
		s birthProvinceDesc = $p($g(^CT("PROV",provinceDR)),"^",2)
		i $l(birthProvinceDesc,"-")'=1 {s birthProvinceDesc=$p($g(birthProvinceDesc),"-",2)} 
		s birthProvinceCode = $p($g(^CT("PROV",provinceDR)),"^",1)
		s birthProvince = provinceDR_"^"_birthProvinceCode_"^"_birthProvinceDesc
		
		s birthPlace = birthProvince_"!"_birthCity
	}
	if (cityAreaDR'="")
	{
		//CT_CityArea
		s cityAreaDesc = $p($g(^CT("CITAREA",cityAreaDR)),"^",2)
		i $l(cityAreaDesc,"-")'=1 {s cityAreaDesc=$p($g(cityAreaDesc),"-",2)} 
		s cityAreaCode = $p($g(^CT("CITAREA",cityAreaDR)),"^",1)
		s cityArea = cityAreaDR_"^"_cityAreaCode_"^"_cityAreaDesc
		s birthPlace = birthPlace_"!"_cityArea
	}
	q birthPlace
}

/// Desc:	籍贯
/// Output:	
/// Debug: ##Class(EPRservice.HISInterface.PatientInfoAssist).Native(105785)
ClassMethod Native(argPapmiDR As %String, argHospital As %String = "") As %String
{
	q:(($d(argPapmiDR)=0)||(argPapmiDR="")) ""
	s Native=""
	
	//PAPER_Province_Birth_DR
	s ProvinceDR = $P($g(^PAPER(argPapmiDR,"PER",2)),"^",11)
	//PAPER_CityBirth_DR
	s CityDR =$P($g(^PAPER(argPapmiDR,"ALL")),"^",18) 
	
	if (ProvinceDR'="")&&(CityDR'="")
	{
		//省份信息
		s ProvinceCode=$P($g(^CT("PROV",ProvinceDR)),"^",1)
		s ProvinceDesc = $P($g(^CT("PROV",ProvinceDR)),"^",2)
		i $l(ProvinceDesc,"-")'=1 {s ProvinceDesc=$p($g(ProvinceDesc),"-",2)} 
		//城市信息
		s CityCode = $p($g(^CT("CIT",CityDR)),"^",1)
		s CityDesc = $p($g(^CT("CIT",CityDR)),"^",2)
		i ($l(CityDesc,"-")>1) {s CityDesc=$p($g(CityDesc),"-",2)}	
		//整理返回值
		s Native = ProvinceDR_"^"_ProvinceCode_"^"_ProvinceDesc
		s Native = Native_"!"_CityDR_"^"_CityCode_"^"_CityDesc
	}		
	
	q Native
}

/// Desc:	现住址
ClassMethod ResidentAddress(argPaperDR As %String, argHospital As %String = "") As %String
{
	q:(($d(argPaperDR)=0)||(argPaperDR="")) ""
	s residentaddr=""
	
	s residentaddr=$g(^PAPER(argPaperDR,"PER","ADD",1))
	
	q residentaddr
}

/// Desc:	现住址邮编
ClassMethod ResidentPostCode(argPaperDR As %String, argHospital As %String = "") As %String
{
	q:(($d(argPaperDR)=0)||(argPaperDR="")) ""
	s postcode=""
	
	if argHospital=..#HospitalBJFCYY 
	{
		//&SQL(select TOP 1 PAPMI_Allergy into :postcode from SQLUser.PA_Patmas where PAPMI_RowId1 = :argPaperDR)
		s postcode = $g(^PAPER(argPaperDR,"ALLERGY",1))
	}
	else
	{
		q:(($d(^PAPER(argPaperDR,"PER",1))'=1)&&($d(^PAPER(argPaperDR,"PER",1))'=11)) ""
		s postcode=$P($G(^PAPER(argPaperDR,"PER",1)),"^",7)
	}

	q postcode
}

/// Desc:	户口地址
/// Table:	PA_Person.PAPER_StName
ClassMethod HuKouAddress(argPaperDR As %String, argHospital As %String = "") As %String
{
	q:(($d(argPaperDR)=0)||(argPaperDR="")) ""
	s hukouaddress=""	
	
	//默认字段
	//地坛医院
	q:(($d(^PAPER(argPaperDR,"PER","ADD",1))'=1)&&($d(^PAPER(argPaperDR,"PER","ADD",1))'=11)) ""
	s hukouaddress=$G(^PAPER(argPaperDR,"PER","ADD",1))	
	q hukouaddress
}

/// Desc:	户口电话
/// Table:	默认字段是：PA_Person.PAPER_TelH
/// 		个别项目是：PA_Person.PAPER_TelO
ClassMethod HuKouPhone(argPaperDR As %String, argHospital As %String = "") As %String
{
	q:(($d(argPaperDR)=0)||(argPaperDR="")) ""
	s hukouphone=""
	
	q:(($d(^PAPER(argPaperDR,"PER",1))'=1)&&($d(^PAPER(argPaperDR,"PER",1))'=11)) ""
	
	//北京积水潭医院
	//北京地坛医院
	if (argHospital=..#HospitalBJJSTYY)||(argHospital=..#HospitalBJDTYY)
	{	s hukouphone=$P($G(^PAPER(argPaperDR,"PER",1)),"^",9)}	//PA_Person.PAPER_TelO
	else
	{	s hukouphone=$P($G(^PAPER(argPaperDR,"PER",1)),"^",11)}	//PA_Person.PAPER_TelH
	
	q hukouphone
}

/// Desc:	户口邮编
/// Output:	邮编
/// Table:	DHC_Person.PAPER_Comment1 	User.DHCPerson.cls 
ClassMethod HuKouPostCode(argPaperDR As %String, argHospital As %String) As %String
{
	q:(($d(argPaperDR)=0)||(argPaperDR="")) ""
	s hukoupostalcodeDR="",hukoupostalcode=""

	s hukoupostalcodeDR=$o(^DHCPERSON(0,"PAPERSON",argPaperDR,""))
	if hukoupostalcodeDR'=""
	{
		s hukoupostalcode=$p($g(^DHCPERSON(hukoupostalcodeDR)),"^",7)
	}	
	
	if argHospital=..#HospitalYKYZLYY			//医科院肿瘤医院
	{
		//PA_Person.PAPER_ForeignPostCode
		s hukoupostalcode=$p($g(^PAPER(argPaperDR,"PER",2)),"^",8)
	}	
	
	q hukoupostalcode
}

/// Desc:	工作地址
ClassMethod WorkAddress(argPaperDR As %String, argHospital As %String = "") As %String
{
	q:(($d(argPaperDR)=0)||(argPaperDR="")) ""
	s workaddr=""
	
	q:(($d(^PAPER(argPaperDR,"PER",4))'=1)&&($d(^PAPER(argPaperDR,"PER",4))'=11)) ""
	s workaddr=$P($G(^PAPER(argPaperDR,"PER",4)),"^",18)

	q workaddr
}

/// Desc:	工作地址邮编
/// Table:	DHC_Person.PAPER_Comment2 	User.DHCPerson.cls 
ClassMethod WorkPostCode(argPaperDR As %String, argHospital As %String = "") As %String
{
	q:(($d(argPaperDR)=0)||(argPaperDR="")) ""
	s workpostalcodeDR="",workpostalcode=""

	
	s workpostalcodeDR=$o(^DHCPERSON(0,"PAPERSON",argPaperDR,""))
	if workpostalcodeDR'=""
	{
		s workpostalcode=$p($g(^DHCPERSON(workpostalcodeDR)),"^",8)
	}	
	
	if argHospital=..#HospitalYKYZLYY			//医科院肿瘤医院
	{
		//PA_Person.PAPER_Name6
		s workpostalcode=$p($g(^PAPER(argPaperDR,"ALL")),"^",22)
	}
	
	q workpostalcode
}

/// Desc:	工作地址邮编,停用，仅为保持代码兼容，建议使用WorkPostCode
/// Table:	DHC_Person.PAPER_Comment2 	User.DHCPerson.cls 
ClassMethod WorkPostalCode(argPaperDR As %String, argHospital As %String = "") As %String
{
	q:(($d(argPaperDR)=0)||(argPaperDR="")) ""
	q ..WorkPostCode(argPaperDR,argHospital)
}

/// Desc:	工作电话
/// Table:	默认字段是：PA_Person.PAPER_TelO
/// 		个别项目是：PA_Person.PAPER_TelH
ClassMethod WorkPhone(argPaperDR As %String, argHospital As %String = "") As %String
{
	q:($d(argPaperDR)=0)||(argPaperDR="") ""
	s workphone=""
	
	q:(($d(^PAPER(argPaperDR,"PER",1))'=1)&&($d(^PAPER(argPaperDR,"PER",1))'=11)) ""
	
	if (argHospital=..#HospitalBJDTYY)||(argHospital=..#HospitalYBRMYY)			
	{	
		//北京地坛医院,粤北人民医院
		s workphone=$P($G(^PAPER(argPaperDR,"PER",1)),"^",11)	//PA_Person.PAPER_TelH
	}	
	else
	{
		//北京积水潭
		s workphone=$P($G(^PAPER(argPaperDR,"PER",1)),"^",9)	//PA_Person.PAPER_TelO
	}	
	
	q workphone
}

/// Desc:	移动电话
/// Table：	PA_Person.PAPER_MobPhone
/// Others：not different from hospitals
ClassMethod MobilePhone(argPaperDR As %String, argHospital As %String = "") As %String
{
	q:(($d(argPaperDR)=0)||(argPaperDR="")) ""
	s mobilephone=""
	
	s mobilephone=$P($G(^PAPER(argPaperDR,"PER",4)),"^",21)
	
	q mobilephone
}

/// Desc:	联系人地址
/// Table:	PA_Person.PAPER_ForeignAddress
/// Others:	not different from hospitals
ClassMethod LinkmanAddress(argPaperDR As %String, argHospital As %String = "") As %String
{
	q:(($d(argPaperDR)=0)||(argPaperDR="")) ""
	s address=""
	
	q:(($d(^PAPER(argPaperDR,"PER",1))'=1)&&($d(^PAPER(argPaperDR,"PER",1))'=11)) ""
	s address=$P($G(^PAPER(argPaperDR,"PER",1)),"^",1)
		
	q address
}

/// Desc:	联系人姓名
/// Table：	PA_Person.PAPER_ForeignId
/// Others: not different from hospitals
ClassMethod LinkmanName(argPaperDR As %String, argHospital As %String = "") As %String
{
	q:(($d(argPaperDR)=0)||(argPaperDR="")) ""
	s linkman=""
	
	q:(($d(^PAPER(argPaperDR,"PER",2))'=1)&&($d(^PAPER(argPaperDR,"PER",2))'=11)) ""
	s linkman=$P($G(^PAPER(argPaperDR,"PER",2)),"^",13)
	
	q linkman
}

/// Desc:	联系人电话
/// Talbe:	PA_Person.PAPER_ForeignPhone
ClassMethod LinkmanPhone(argPaperDR As %String, argHospital As %String) As %String
{
	q:(($d(argPaperDR)=0)||(argPaperDR="")) ""
	s phone=""
	
	q:(($d(^PAPER(argPaperDR,"ALL"))'=1)&&($d(^PAPER(argPaperDR,"ALL"))'=11)) ""
	s phone=$P($G(^PAPER(argPaperDR,"ALL")),"^",4)	

	q phone
}

/// Desc:	联系人关系
/// Output：RowId^Code^Desc
/// Table：	PA_Person.PAPER_CTRLT_DR -> SQLUser.CT_Relation
/// Other:	argCDType = RelationGB/T4761
ClassMethod LinkmanRelation(argPaperDR As %String, argHospital As %String = "", argCDType As %String = "", argCDCode As %String = "") As %String
{
	q:($d(argPaperDR)=0)||(argPaperDR="") ""
	s relationDR="",relation="",relationcode="",relationdesc=""
	
	q:(($d(^PAPER(argPaperDR,"EMP"))'=1)&&($d(^PAPER(argPaperDR,"EMP"))'=11)) ""
	s relationDR=$P($G(^PAPER(argPaperDR,"EMP")),"^",4)
	if relationDR'=""
	{
		s relationcode=$p($g(^CT("RLT",relationDR)),"^",1)
	  	s relationdesc=$p($g(^CT("RLT",relationDR)),"^",2)
	  	s:($l(relationdesc,"-")>1) relationdesc=$p($g(relationdesc),"-",2)
		s relation=relationDR_"^"_relationcode_"^"_relationdesc
		
		//通过入参判断是否进行数据替换处理
		if (argCDType'="") 
		{
			s relation=..GetCustomDictionaryLinkByCode(argCDType,argCDCode)
			s relation=relationDR_"^"_relation
		}
	}
	
	q relation
}

/// Desc：	入院科室【返回: RowId^Code^Desc】
/// Table：	
/// OutPut:	RowId^Code^Desc
/// Others: not different from hospitals
ClassMethod AdmDept(argAdmId As %String, argHospital As %String = "") As %String
{
	q:(($d(argAdmId)=0)||(argAdmId="")) ""
	s TRANSChildsub="",locDR="",tmplocDR="",bed="",admdept="",DeptDesc="",DeptCode=""
	
	// 遍历转科记录，取入院科室
	f  s TRANSChildsub=$o(^PAADM(argAdmId,"TRANS",TRANSChildsub)) q:(TRANSChildsub="")!(bed'="")  d
	.s bed=$p($g(^PAADM(argAdmId,"TRANS",TRANSChildsub)),"^",8)
	.s tmplocDR=$p($g(^PAADM(argAdmId,"TRANS",TRANSChildsub)),"^",6)
	.if tmplocDR'="" {s locDR=tmplocDR}
		
	if locDR'="" 
	{	
		s DeptCode=$p($g(^CTLOC(locDR)),"^",1)
		s DeptDesc=$p($g(^CTLOC(locDR)),"^",2)
		if $l(DeptDesc,"-")>1 {s DeptDesc=$p($g(DeptDesc),"-",2)}
		s admdept=locDR_"^"_DeptCode_"^"_DeptDesc		
	}
	
	q admdept
}

/// Desc:	入院日期时间【Cache内部格式】
/// Table：	PA_Adm.PAADM_AdmDate，PA_Adm.PAADM_AdmTime
/// Output: date_","_time
ClassMethod AdmDateTime(argAdmId As %String, argHospital As %String = "") As %String
{
	q:(($d(argAdmId)=0)||(argAdmId="")) ""
	
	s admdatetime="",admdate="",admtime=""
	
	// not different from hospitals
	q:(($d(^PAADM(argAdmId))'=1)&&($d(^PAADM(argAdmId))'=11)) ""
	s admdate=$P($G(^PAADM(argAdmId)),"^",6)
	s admtime=$P($G(^PAADM(argAdmId)),"^",7)
	if (admdate'="")&&(admtime'="") 
	{
		s admdatetime=admdate_","_admtime
	}
	
	q admdatetime
}

/// Desc:	入院日期时间(分床时间)【Cache内部格式】
/// Table：
/// Output：date_","_time
ClassMethod AdmDateTimeInBed(argAdmId As %String, argHospital As %String = "") As %String
{
	q:(($d(argAdmId)=0)||(argAdmId="")) ""
	
	s TRANSChildsub="",bed="",admdatetime="",admdate="",admtime=""
	s admdatetimeinbed=""

	f  s TRANSChildsub=$o(^PAADM(argAdmId,"TRANS",TRANSChildsub)) q:(TRANSChildsub="")!(bed'="")  d
	.s bed=$p($g(^PAADM(argAdmId,"TRANS",TRANSChildsub)),"^",8)
	.q:(bed="")
	.s admdate=$p(^PAADM(argAdmId,"TRANS",TRANSChildsub),"^",1)
	.s admtime=$p(^PAADM(argAdmId,"TRANS",TRANSChildsub),"^",2)
	if (admdate'="")&&(admtime'="") 
	{
		s admdatetimeinbed=admdate_","_admtime
	}
	
	q admdatetimeinbed
}

/// Desc:	入院病区【RowId^Code^Desc】
/// Table：	
/// Output：RowId^Code^Desc
/// Others：not different from hospitals
ClassMethod AdmWard(argAdmId As %String, argHospital As %String = "") As %String
{
	
	q:(($d(argAdmId)=0)||(argAdmId="")) ""
	
	s TRANSChildsub="",WardCode="",wardDR="",bed="",WardDesc="",admward=""
	
	f  s TRANSChildsub=$o(^PAADM(argAdmId,"TRANS",TRANSChildsub)) q:(TRANSChildsub="")!(bed'="")  d
	.s bed=$p($g(^PAADM(argAdmId,"TRANS",TRANSChildsub)),"^",8)
	.s wardDR=$p($g(^PAADM(argAdmId,"TRANS",TRANSChildsub)),"^",9)
	if wardDR'="" 
	{
		if (argHospital="BJXHYY")
		{
			s admward=..GetShortWard(wardDR)
			}
		else
		{
			s WardCode=$p($g(^PAWARD(wardDR)),"^",1)
			s WardDesc=$p($g(^PAWARD(wardDR)),"^",2)
			if $l(WardDesc,"-")>1 {s WardDesc=$p($g(WardDesc),"-",2)}
			s admward=wardDR_"^"_WardCode_"^"_WardDesc
		}
			
	}
	
	q admward
}

/// Desc:	取病区简写【RowId^Code^Desc】
/// Table：	
/// Output：RowId^Code^Desc
/// Others：not different from hospitals
ClassMethod GetShortWard(argWardDR As %String) As %String
{
	
	q:(($d(argWardDR)=0)||(argWardDR="")) ""
	s admward="",LocDR="",WardCode="",WardDesc=""
	s LocDR=$p($g(^PAWARD(argWardDR)),"^",5)	
	if LocDR'="" 
	{
		s WardCode=$p($g(^CTLOC(LocDR)),"^",1)
		s WardDesc=$p($g(^CTLOC(LocDR)),"^",56)
		if (WardDesc="")
		{
			s WardDesc=$p($g(^CTLOC(LocDR)),"^",2)
			}
		if $l(WardDesc,"-")>1 {s WardDesc=$p($g(WardDesc),"-",2)}
		s admward=LocDR_"^"_WardCode_"^"_WardDesc
	}
	
	q admward
}

/// Desc:	入院床位号
ClassMethod AdmBed(argAdmId As %String) As %String
{
	
	q:($d(argAdmId)=0)||(argAdmId="") ""
	s TRANSChildsub="",bedDR="",admbedno=""
	s bedwordrowid="",bedchildsub=""

	f  s TRANSChildsub=$o(^PAADM(argAdmId,"TRANS",TRANSChildsub)) q:(TRANSChildsub="")!(bedDR'="")  d
	.s bedDR=$p($g(^PAADM(argAdmId,"TRANS",TRANSChildsub)),"^",8)
	
	q:($d(bedDR)=0)||(bedDR="")||($l(bedDR,"||")<2) ""
	s bedwordrowid = $p(bedDR,"||",1)
	s bedchildsub = $p(bedDR,"||",2)
	
    q:($d(^PAWARD(bedwordrowid,"BED"))'=10) ""
    
	s admbedno = $p($g(^PAWARD(bedwordrowid,"BED",bedchildsub)),"^",1)

 	q admbedno
}

/// Desc:	入院医生 
/// Output:	RowId^医生代码^医生描述
/// Table:	PA_Adm.PAADM_AdmDocCodeDR
/// 		AdmDoctorDR is CT_CareProv RowID
ClassMethod AdmDoctor(argAdmId As %String, argHospital As %String = "") As %String
{
	q:(($d(argAdmId)=0)||(argAdmId="")) ""
	s admdoctorDR="",admdoctor="",admdoctorcode=""
	
	q:(($d(^PAADM(argAdmId))'=1)&&($d(^PAADM(argAdmId))'=11)) ""
	s AdmDoctorDR=$P($g(^PAADM(argAdmId)),"^",9)
	if AdmDoctorDR'=""
	{
		s admdoctorcode=$P($g(^CTPCP(AdmDoctorDR,1)),"^",1)
		s admdoctor=$P($g(^CTPCP(AdmDoctorDR,1)),"^",2)
		s admdoctor=AdmDoctorDR_"^"_admdoctorcode_"^"_admdoctor
	}
 
	q admdoctor
}

/// Desc:	主管护士 
/// Output:	RowId^护士代码^护士描述
/// Table:	DHC_PA_Adm.DHCADM_MainNurse_Dr
ClassMethod AdmNurse(argAdmId As %String, argHospital As %String) As %String
{
	q:(($d(argAdmId)=0)||(argAdmId="")) ""
	s DHCPaadmRowId=0,admNurseDR="",admNurse="",admNursecode=""
	;q:(($d(^DHCPAAdm(0,"PAAdm",argAdmId))'=1)&&($d(^DHCPAAdm(0,"PAAdm",argAdmId))'=11)) ""
	s DHCPaadmRowId=$o(^DHCPAAdm(0,"PAAdm",argAdmId,DHCPaadmRowId))
	q:((DHCPaadmRowId=0)||(DHCPaadmRowId="")) ""
	s admNurseDR=$P($g(^DHCPAAdm(DHCPaadmRowId)),"^",2)
	if admNurseDR'=""
	{
		s admNursecode=$P($g(^CTPCP(admNurseDR,1)),"^",1)
		s admNurse=$P($g(^CTPCP(admNurseDR,1)),"^",2)
		s admNurse=admNurseDR_"^"_admNursecode_"^"_admNurse
	}
 
	q admNurse
}

/// Desc:	带组医生 
/// Output:	RowId^医生代码^医生描述
/// Table:	PA_Adm.PAADM_AdmDocCodeDR
ClassMethod MasterDoctor(argAdmId As %String, argHospital As %String) As %String
{
	q:(($d(argAdmId)=0)||(argAdmId="")) ""
	s Masterdoctor=""
	
	q:(($d(^PAADM(argAdmId))'=1)&&($d(^PAADM(argAdmId))'=11)) ""
	s Loc="",Doctor="",PAAdmDocCodeDR=""
	Set Loc=$P($g(^PAADM(argAdmId)),"^",4)
	Set Doctor=$P($g(^PAADM(argAdmId)),"^",9)
	If Doctor'="" Set PAAdmDocCodeDR=Doctor_"^"_$P($g(^CTPCP(Doctor,1)),"^",1)_"^"_$P($g(^CTPCP(Doctor,1)),"^",2)  //就诊医生
    Else  Set PAAdmDocCodeDR=""
	if ((Doctor'="")&&(Loc'="")) {s Masterdoctor=..GetHadeUniteDoc(Doctor,Loc)}
    if ((Doctor'="")&&(Loc="")) {s Masterdoctor=PAAdmDocCodeDR} //取到就诊医生所在组的组长
	
	/*if admdoctorDR'=""
	{
		s admdoctorcode=$P($g(^CTPCP(admdoctorDR,1)),"^",1)
		s admdoctor=$P($g(^CTPCP(admdoctorDR,1)),"^",2)
		s admdoctor=admdoctorDR_"^"_admdoctorcode_"^"_admdoctor
	}*/
 
	q Masterdoctor
}

/// creator:李相宗
/// date:2011-11-30
/// desc:得到病人就诊医生的所在组的组长
/// input:CTLOCRowId就诊科室ID	DoctorID就诊医生ID
/// outPut:DocMessage 就诊医生所在组的组长和DocID
/// debug:w ##class(web.DHCDocInPatientList).GetHadeUniteDoc("810","1595")
ClassMethod GetHadeUniteDoc(DoctorID As %String, CTLOCID As %String) As %Status
{
	
    s date=+$P($H,",",1)
 	s Str=""
	s SSUSRCareProvDR=DoctorID
    s CTMUChildsub=0  f  s CTMUChildsub=$O(^CTLOC(CTLOCID,"MU",CTMUChildsub)) q:(CTMUChildsub="")||(Str'="")  d
    .s CTMUActiveFlag=$P(^CTLOC(CTLOCID,"MU",CTMUChildsub),"^",3)
    .q:CTMUActiveFlag'="Y"  //单元是激活状态
    .s DateFrom1=+$P(^CTLOC(CTLOCID,"MU",CTMUChildsub),"^",4) //单元没有过期，有效状态
    .q:((date<DateFrom1)&&(DateFrom1'=0))
    .s DateTo1=+$P(^CTLOC(CTLOCID,"MU",CTMUChildsub),"^",5)
    .q:(date>DateTo1)&&(DateTo1'=0)
    .s IsExist=0,LeaderDoctorDR=""
 	.s MUCPChildsub=0 f  s MUCPChildsub=$O(^CTLOC(CTLOCID,"MU",CTMUChildsub,"CP",MUCPChildsub)) q:(MUCPChildsub="")  d
 	..s MUCPDoctorDR=$p(^CTLOC(CTLOCID,"MU",CTMUChildsub,"CP",MUCPChildsub),"^",1) 
	..if (MUCPDoctorDR=SSUSRCareProvDR) s IsExist=1
	..s MUCPLeaderFlag=$p(^CTLOC(CTLOCID,"MU",CTMUChildsub,"CP",MUCPChildsub),"^",2) //取组长标志
	..s DateFrom2=+$p(^CTLOC(CTLOCID,"MU",CTMUChildsub,"CP",MUCPChildsub),"^",5)
	..q:((date<DateFrom2)&&(DateFrom2'=0)) //单元中的用户没有超出有效期
	..s DateTo2=+$p(^CTLOC(CTLOCID,"MU",CTMUChildsub,"CP",MUCPChildsub),"^",6)
	..q:((date>DateTo2)&&(DateTo2'=0))
	..if (MUCPLeaderFlag="Y") s LeaderDoctorDR=MUCPDoctorDR
	.i (IsExist=1)&&(LeaderDoctorDR'="") s Str=CTLOCID_"||"_CTMUChildsub_"^"_LeaderDoctorDR //_"^"_MUCPDoctorDR_"^"_SSUSRCareProvDR
	if (Str="") s Docdesc=DoctorID_"^"_$P($g(^CTPCP(DoctorID,1)),"^",1)_"^"_$P($g(^CTPCP(DoctorID,1)),"^",2)
	else  s Docdesc=$P(Str,"^",2)_"^"_$P($g(^CTPCP($P(Str,"^",2),1)),"^",1)_"^"_$P($g(^CTPCP($P(Str,"^",2),1)),"^",2)
	q Docdesc
}

/// Desc:	入院诊断
/// Input:	argAdmId: 就诊rowid， argAdmDiagTypeId：入院诊断类型id
/// Output:	RowId^诊断代码^诊断描述!RowId^诊断代码^诊断描述
/// Upate: 	2010-12-29 入院诊断类型增加 C008
ClassMethod AdmDiagnos(argAdmId As %String) As %String
{
	q:($d(argAdmId)=0)||(argAdmId="") ""
	s retValue = ""
	
	//取表 MRC_DiagnosType 中入院诊断对应的RowId 
	s admDiagTypeId = ""
	s admDiagTypeId = $O(^MRC("DTYP",0,"Code","PRE",""))
	s tmpid = $O(^MRC("DTYP",0,"Code","C008",""))
	if (tmpid '= "")
	{
		if admDiagTypeId = ""
		{	s admDiagTypeId = tmpid}
		else
		{	s admDiagTypeId = admDiagTypeId_"^"_tmpid}
	}
	q:(admDiagTypeId = "") ""
	s admDiagTypeId = "^"_admDiagTypeId_"^"
	
	s mainmradmdr = $p($g(^PAADM(argAdmId)),"^",61)
	q:(mainmradmdr = "") ""
	q:($d(^MR(mainmradmdr)) = 0) ""
	
	
	s themrdiachildsub = ""
	s mrdiachildsub = ""
	for {
		s mrdiachildsub=$o(^MR(mainmradmdr,"DIA",mrdiachildsub))
		q:(mrdiachildsub="")
		
		s mrdiagtype = ""
		for {
			q:($d(^MR(mainmradmdr,"DIA",mrdiachildsub,"TYP"))=0)
			s mrdiagtype=$o(^MR(mainmradmdr,"DIA",mrdiachildsub,"TYP",mrdiagtype))
			q:(mrdiagtype="")
			
			s typmrcdiagtyp = $p($g(^MR(mainmradmdr,"DIA",mrdiachildsub,"TYP",mrdiagtype)),"^",1)
			//if (typmrcdiagtyp = admDiagTypeId)	//此处判断是否为入院诊断
			if ($find(admDiagTypeId, "^"_typmrcdiagtyp_"^"))
			{
				s themrdiachildsub = mrdiachildsub
				
				s mricdid = $p($g(^MR(mainmradmdr,"DIA",themrdiachildsub)),"^",1)
				q:(mricdid = "") 
	
				s mricdCode = $p($g(^MRC("ID",mricdid)),"^",4)
				s mricdDesc = $p($g(^MRC("ID",mricdid)),"^",2)
				
				//20120516 wangwentao add
				s diagNote=$g(^MR(mainmradmdr,"DIA",themrdiachildsub,"DES",1))
				if (diagNote '= "") 
				{	s mricdDesc = mricdDesc_"("_diagNote_")"}
				//end
				
				if (retValue = "")
				{	s retValue = mricdid_"^"_mricdCode_"^"_mricdDesc}
				else
				{	s retValue = retValue_"!"_mricdid_"^"_mricdCode_"^"_mricdDesc}
			}
		}
	}
	
	q retValue
}

/// Desc:	主要诊断
/// Input:	argAdmId: 就诊rowid， argAdmDiagTypeId：主要诊断类型id
/// Output:	RowId^诊断代码^诊断描述
/// Debug: w ##class(EPRservice.HISInterface.PatientInfoAssist).MainDiagnos("65")
ClassMethod MainDiagnos(argAdmId As %String) As %String
{
	q:($d(argAdmId)=0)||(argAdmId="") ""
	s retValue = ""
	
	//取表 MRC_DiagnosType 中入院诊断对应的RowId 
	s mainDiagTypeId = ""
	s mainDiagTypeId = $O(^MRC("DTYP",0,"Code","M",""))
	q:(mainDiagTypeId = "") ""
	
	
	s mainmradmdr = $p($g(^PAADM(argAdmId)),"^",61)
	q:(mainmradmdr = "") ""
	q:($d(^MR(mainmradmdr)) = 0) ""
	
	
	s themrdiachildsub = ""
	s mrdiachildsub = ""
	for {
		s mrdiachildsub=$o(^MR(mainmradmdr,"DIA",mrdiachildsub))
		q:(mrdiachildsub="")
		
		s mrdiagtype = ""
		for {
			q:($d(^MR(mainmradmdr,"DIA",mrdiachildsub,"TYP"))=0)
			s mrdiagtype=$o(^MR(mainmradmdr,"DIA",mrdiachildsub,"TYP",mrdiagtype))
			q:(mrdiagtype="")
			
			s typmrcdiagtyp = $p($g(^MR(mainmradmdr,"DIA",mrdiachildsub,"TYP",mrdiagtype)),"^",1)
			if (typmrcdiagtyp = mainDiagTypeId)	//此处判断是否为主要诊断
			{
				s themrdiachildsub = mrdiachildsub
				
				s mricdid = $p($g(^MR(mainmradmdr,"DIA",themrdiachildsub)),"^",1)
				q:(mricdid = "") 
	
				s mricdCode = $p($g(^MRC("ID",mricdid)),"^",4)
				s mricdDesc = $p($g(^MRC("ID",mricdid)),"^",2)
				
				//20120516 wangwentao add
				s diagNote=$g(^MR(mainmradmdr,"DIA",themrdiachildsub,"DES",1))
				if (diagNote '= "") 
				{	s mricdDesc = mricdDesc_"("_diagNote_")"}
				//end
				
				if (retValue = "")
				{	s retValue = mricdid_"^"_mricdCode_"^"_mricdDesc}
				else
				{	s retValue = retValue_"!"_mricdid_"^"_mricdCode_"^"_mricdDesc}
			}
		}
	}
	
	q retValue
}

/// Desc:	出院诊断
/// Input:	argAdmId: 就诊rowid
/// Output:	RowId^诊断代码^诊断描述!RowId^诊断代码^诊断描述
ClassMethod OutDiagnos(argAdmId As %String) As %String
{
	q:($d(argAdmId)=0)||(argAdmId="") ""
	s retValue = ""
	
	//取表 MRC_DiagnosType 中出院诊断对应的RowId 
	s admDiagTypeId = ""
	s admDiagTypeId = $O(^MRC("DTYP",0,"Code","DIS",""))  
	q:(admDiagTypeId = "") ""
	
	
	s mainmradmdr = $p($g(^PAADM(argAdmId)),"^",61)
	q:(mainmradmdr = "") ""
	q:($d(^MR(mainmradmdr)) = 0) ""
	
	
	s themrdiachildsub = ""
	s mrdiachildsub = ""
	for {
		s mrdiachildsub=$o(^MR(mainmradmdr,"DIA",mrdiachildsub))
		q:(mrdiachildsub="")
		
		s mrdiagtype = 0
		for {
			q:($d(^MR(mainmradmdr,"DIA",mrdiachildsub,"TYP"))=0)
			s mrdiagtype=$o(^MR(mainmradmdr,"DIA",mrdiachildsub,"TYP",mrdiagtype))
			q:(mrdiagtype="")
			
			s typmrcdiagtyp = $p($g(^MR(mainmradmdr,"DIA",mrdiachildsub,"TYP",mrdiagtype)),"^",1)
			if (typmrcdiagtyp = admDiagTypeId)	//此处判断是否为出院诊断
			{
				s themrdiachildsub = mrdiachildsub
				
				s mricdid = $p($g(^MR(mainmradmdr,"DIA",themrdiachildsub)),"^",1)
				q:(mricdid = "") 
	
				s mricdCode = $p($g(^MRC("ID",mricdid)),"^",4)
				s mricdDesc = $p($g(^MRC("ID",mricdid)),"^",2)
				
				//20120516 wangwentao add
				s diagNote=$g(^MR(mainmradmdr,"DIA",themrdiachildsub,"DES",1))
				if (diagNote '= "") 
				{	s mricdDesc = mricdDesc_"("_diagNote_")"}
				//end
				
				if (retValue = "")
				{	s retValue = mricdid_"^"_mricdCode_"^"_mricdDesc}
				else
				{	s retValue = retValue_"!"_mricdid_"^"_mricdCode_"^"_mricdDesc}
			}
		}
	}
	
	q retValue
}

/// Desc: 诊断信息，诊断的优先原则为：出院诊断>主要诊断>入院诊断
/// Input: argAdmId: 就诊rowid
/// Return: RowId^诊断代码^诊断描述
ClassMethod DiagnosInfo(argAdmId As %String) As %String
{
	q:(argAdmId="") ""
	
	s retDiagnos = ""
	s diagnosID = ""
	
	//出院诊断
	s disDiagTypeID = $O(^MRC("DTYP",0,"Code","DIS",""))  
	if (disDiagTypeID '= "")
	{
		s diagIDs = ..GetTypedDiagnosID(argAdmId, disDiagTypeID)
		if diagIDs '= ""
		{
			s diagnosID = $P(diagIDs, "^", 1)
			s retDiagnos = ..GetDiagnosWithNote(diagnosID)
		}
	}
	q:(retDiagnos '= "") retDiagnos
	
	//主要诊断
	s mainDiagTypeId = $O(^MRC("DTYP",0,"Code","M",""))
	if (mainDiagTypeId '= "")
	{
		s diagIDs = ..GetTypedDiagnosID(argAdmId, mainDiagTypeId)
		if diagIDs '= ""
		{
			s diagnosID = $P(diagIDs, "^", 1)
			s retDiagnos = ..GetDiagnosWithNote(diagnosID)
		}
	}
	q:(retDiagnos '= "") retDiagnos
	
	//入院诊断
	s admDiagTypeId = $O(^MRC("DTYP",0,"Code","PRE",""))
	s tmpid = $O(^MRC("DTYP",0,"Code","C008",""))
	if (tmpid '= "")
	{
		if admDiagTypeId = ""
		{	s admDiagTypeId = tmpid}
		else
		{	s admDiagTypeId = admDiagTypeId_"^"_tmpid}
	}
	if (admDiagTypeId '= "")
	{
		s diagIDs = ..GetTypedDiagnosID(argAdmId, admDiagTypeId)
		if diagIDs '= ""
		{
			s diagnosID = $P(diagIDs, "^", 1)
			s retDiagnos = ..GetDiagnosWithNote(diagnosID)
		}
	}
	q:(retDiagnos '= "") retDiagnos
	
	//兼容无诊断类型的医院老项目,取第1条诊断
	s tmpDiagnos = ..GetDiagnos(argAdmId)
	if (tmpDiagnos '= "")
	{
		s Diagnos=$p($g(tmpDiagnos),"!",1)
		if Diagnos '= ""
		{
			s diagnosID = $p($g(Diagnos),"^",1)
			s diagnosDesc = $p($g(Diagnos),"^",2)
			s retDiagnos = diagnosID_"^"_"^"_diagnosDesc
		}
	}
	
	q retDiagnos
}

/// Desc:	取指定类型的诊断ID
ClassMethod GetTypedDiagnosID(argEpisodeID As %String, argMRCDiagnosTypeID As %String) As %String
{
	q:(argMRCDiagnosTypeID = "") ""
	
	s ret = ""
	
	s mrAdmDR = $p($g(^PAADM(argEpisodeID)),"^",61)
	q:(mrAdmDR = "") ""
	
	s mrcDiagnosTypeIDString = "^"_argMRCDiagnosTypeID_"^"
	
	s mrDiaChildsub = "0"
	for {
		s mrDiaChildsub = $o(^MR(mrAdmDR,"DIA",mrDiaChildsub))
		q:(mrDiaChildsub="")
		
		s typeChildSub = 0
		for {
			s typeChildSub = $o(^MR(mrAdmDR,"DIA",mrDiaChildsub,"TYP",typeChildSub))
			q:(typeChildSub = "")
			
			s mrcDiagTypID = $p($g(^MR(mrAdmDR,"DIA",mrDiaChildsub,"TYP",typeChildSub)),"^",1)
			continue:(mrcDiagTypID = "")
			
			//判断是否为待选诊断类型
			continue:('$f(mrcDiagnosTypeIDString, "^"_mrcDiagTypID_"^"))
			
			s mrDiagnosID = mrAdmDR_"||"_mrDiaChildsub
			if ret = ""
			{	s ret = mrDiagnosID}
			else
			{	s ret = ret_"^"_mrDiagnosID}	
		}
	}
	
	q ret
}

/// 	Desc:	取诊断信息
/// 	Input:	argMRDiagnosID : MR_Adm.MRADM_RowId||MR_Diagnos.MRDIA_Childsub
/// 	Return：RowId^诊断代码^诊断描述(诊断备注)
ClassMethod GetDiagnosWithNote(argMRDiagnosID) As %String
{
	s mrAdmID = $P(argMRDiagnosID, "||", 1)
	s mrDiaChildSub = $P(argMRDiagnosID, "||", 2)
	q:(mrAdmID = "")||(mrDiaChildSub = "") ""
	
	s icdid = $p($g(^MR(mrAdmID,"DIA",mrDiaChildSub)),"^",1)
	q:(icdid = "") ""
	
	s icdCode = $p($g(^MRC("ID",icdid)),"^",4)
	s icdDesc = $p($g(^MRC("ID",icdid)),"^",2)
	
	s diagNote=$g(^MR(mrAdmID,"DIA",mrDiaChildSub,"DES",1))
	//s diagNote=$g(^MR(mrAdmID,"DIA",mrDiaChildSub,"DES"))
	if (diagNote '= "") 
	{	s icdDesc = icdDesc_"("_diagNote_")"}	
	
	q icdid_"^"_icdCode_"^"_icdDesc
}

/// Desc:	主管医师 or 管床医生 (同入院医生)
/// Others:	not different from hospitals 
ClassMethod MainDoc(argAdmId As %String) As %String
{
	q:(($d(argAdmId)=0)||(argAdmId="")) ""
	s mainDoc=""
	
	q:(($d(^PAADM(argAdmId))'=1)&&($d(^PAADM(argAdmId))'=11)) ""
	s docDR = $P($G(^PAADM(argAdmId)),"^",9)
	q:(docDR="") ""
	s docCode=$p($g(^CTPCP(docDR,1)),"^",1)
	s docName=$p($g(^CTPCP(docDR,1)),"^",2)
	s mainDoc=docDR_"^"_docCode_"^"_docName
	
	q mainDoc
}

// Desc:	出院医师

/// Others:	not different from hospitals 
ClassMethod DischgDoc(argAdmId As %String) As %String
{
	q:(($d(argAdmId)=0)||(argAdmId="")) ""
	s DischgDoc="",docDR="",docCode="",docName=""
	
	q:(($d(^PAADM(argAdmId))'=1)&&($d(^PAADM(argAdmId))'=11)) ""
	s docDR = $P($G(^PAADM(argAdmId)),"^",19)
	q:(docDR="") ""
	s docCode=$p($g(^CTPCP(docDR,1)),"^",1)
	s docName=$p($g(^CTPCP(docDR,1)),"^",2)
	s DischgDoc=docDR_"^"_docCode_"^"_docName
	
	q DischgDoc
}

/// Desc:	上级医师
/// Others:	not different from hospitals
/// SQLUser.DHC_PA_Adm.DHCADM_SeniorDoctor_Dr ->
ClassMethod SeniorDoc(argAdmId As %String) As %String
{
	q:(($d(argAdmId)=0)||(argAdmId="")) ""
	s SeniorDoc="",docDR="",docCode="",docName="",DHCAdmDR="",SeniorDocDR=""
	
	s DHCAdmDR=$o(^DHCPAAdm(0,"PAAdm",argAdmId,0))
	q:(DHCAdmDR="") ""
	s SeniorDocDR=$p($g(^DHCPAAdm(DHCAdmDR)),"^",19)
	q:(SeniorDocDR="") ""
	s docCode=$p($g(^CTPCP(SeniorDocDR,1)),"^",1)
	s docName=$p($g(^CTPCP(SeniorDocDR,1)),"^",2)
	s SeniorDoc=docDR_"^"_docCode_"^"_docName

	q SeniorDoc
}

/// Desc: 临时科室
/// Return: RowId^Code^Desc
/// Others: 被下列模块引用
/// 		[模板控制]EPRservice.TPrivLogic.PatientInfoAssist
ClassMethod TempDept(argAdmId As %String, argHospital As %String = "") As %String
{
	q:($d(argAdmId)=0)||(argAdmId="") ""
	s dept=""
	
	s deptDR=$P($g(^PAADM(argAdmId)),"^",74)
	if deptDR'="" 
	{	
		s deptDesc=$p($g(^CTLOC(deptDR)),"^",2)
		s deptCode=$p($g(^CTLOC(deptDR)),"^",1)
		if $l(deptDesc,"-")>1 {s deptDesc=$p($g(deptDesc),"-",2)}
		s dept=deptDR_"^"_deptCode_"^"_deptDesc
	}

	q dept
}

/// Desc:	当前科室(即出院科室)
/// Return：RowId^Code^Desc
/// Others：被下列模块引用
/// 		[操作权限]EPRservice.Privilege.BOPrivAssist
/// 		[模板控制]EPRservice.TPrivLogic.PatientInfoAssist
ClassMethod CurrentDept(argAdmId As %String, argHospital As %String = "") As %String
{
	q:($d(argAdmId)=0)||(argAdmId="") ""
	s CurrentDept=""
	
	s DeptDR=$P($g(^PAADM(argAdmId)),"^",4)
	if DeptDR'="" 
	{	
		s DeptDesc=$p($g(^CTLOC(DeptDR)),"^",2)
		s DeptCode=$p($g(^CTLOC(DeptDR)),"^",1)
		if $l(DeptDesc,"-")>1 {s DeptDesc=$p($g(DeptDesc),"-",2)}
		s CurrentDept=DeptDR_"^"_DeptCode_"^"_DeptDesc
	}

	q CurrentDept
}

/// Desc:	取 CT_LocLinkLocation 科室与病区的对应关系
/// 	  	用于[操作权限]，如一个大病区包括多个科室或治疗组，登录某治疗组，具有本大病区病历的操作权限
/// Return：^CurrentDeptDR^LinkLoc1DR^LinkLoc2DR^
/// Others：被下列模块引用
/// 		[操作权限]EPRservice.Privilege.BOPrivAssist
ClassMethod CurrentDeptLinkLoc(argAdmId As %String) As %String
{
	// Table: CT_LocLinkLocation
	// Global: ^CTLOC({CT_Loc.CTLOC_RowID},"LINK",0,"Loc",{LINK_CTLOC_DR},{LINK_Childsub})

	q:($d(argAdmId)=0)||(argAdmId="") ""
	s CurrentDeptLinkLoc=""
	s CurrentDept="",CurrentDeptDR="",VarLocDR="",VarLocString=""
	
	s CurrentDept=..DisDept(argAdmId,..HospitalName())
	s CurrentDeptDR=$p($g(CurrentDept),"^",1)
	
	f  s VarLocDR=$o(^CTLOC(CurrentDeptDR,"LINK",0,"Loc",VarLocDR)) q:VarLocDR=""  d
	. s VarLocString=VarLocString_"^"_VarLocDR
	
	i $l(VarLocString,"^")=2 
	{ 
		f  s VarLocDR=$o(^CTLOC($p(VarLocString,"^",2),"LINK",0,"Loc",VarLocDR)) q:VarLocDR=""  d
		. s VarLocString=VarLocString_"^"_VarLocDR
	}
	s CurrentDeptLinkLoc=CurrentDeptDR_VarLocString
	s CurrentDeptLinkLoc="^"_CurrentDeptLinkLoc_"^"
	
	q CurrentDeptLinkLoc
}

/// Desc: 	出院科室(即当前科室)【RowId^Code^Desc】
/// Output：RowId^Code^Desc
/// Others: not different from hospitals
ClassMethod DisDept(argAdmId As %String, argHospital As %String = "") As %String
{
	q:($d(argAdmId)=0)||(argAdmId="") ""
	
	s DeptCode="",DeptDesc="",dischgDeptDR="",dischgDept=""
	
	s dischgDeptDR=$P($g(^PAADM(argAdmId)),"^",4)
	if dischgDeptDR'="" 
	{	
		s DeptDesc=$p($g(^CTLOC(dischgDeptDR)),"^",2)
		s DeptCode=$p($g(^CTLOC(dischgDeptDR)),"^",1)
		if $l(DeptDesc,"-")>1 {s DeptDesc=$p($g(DeptDesc),"-",2)}
		s dischgDept=dischgDeptDR_"^"_DeptCode_"^"_DeptDesc
	}

	q dischgDept
}

/// Desc:  	出院病区【RowId^Code^Desc】
/// Output: RowId^Code^Desc
/// Others：not different from hospitals 
ClassMethod DisWard(argAdmId As %String, argHospital As %String = "") As %String
{
	q:(($d(argAdmId)=0)||(argAdmId="")) ""
	
	s WardDesc="",WardCode="",dischgWardDR="",dischgWard=""
	
	s dischgWardDR=$P($g(^PAADM(argAdmId)),"^",70)
	if dischgWardDR'="" 
	{
		if (argHospital="BJXHYY")
		{
			s dischgWard=..GetShortWard(dischgWardDR)
			}
		else
		{
			s WardDesc=$p($g(^PAWARD(dischgWardDR)),"^",2)
			s WardCode=$p($g(^PAWARD(dischgWardDR)),"^",1)
			if $l(WardDesc,"-")>1 {s WardDesc=$p($g(WardDesc),"-",2)}
			s dischgWard=dischgWardDR_"^"_WardCode_"^"_WardDesc
		}
	}	
	
	q dischgWard
}

/// Desc:	出院床位号
ClassMethod DisBed(argAdmId As %String) As %String
{
	q:($d(argAdmId)=0)||(argAdmId="") ""
	s bedwordrowid="",bedchildsub=""
	s bedDR="",dischgbedno=""

    q:(($d(^PAADM(argAdmId))'=1)&&($d(^PAADM(argAdmId))'=11)) ""
    
	s bedDR=$p($g(^PAADM(argAdmId)),"^",73)
	
	q:($d(bedDR)=0)||(bedDR="")||($l(bedDR,"||")<2) ""
	s bedwordrowid = $p(bedDR,"||",1)
	s bedchildsub = $p(bedDR,"||",2)
	
    q:($d(^PAWARD(bedwordrowid,"BED"))'=10) ""
    
	s dischgbedno = $p($g(^PAWARD(bedwordrowid,"BED",bedchildsub)),"^",1)

 	q dischgbedno
}

/// Desc: 	出院日期时间(护士结算)
/// Output：date_","_time【Cache内部格式】
/// Others：not different from hospitals
ClassMethod DisDateTime(argAdmId As %String, argHospital As %String = "") As %String
{
	q:(($d(argAdmId)=0)||(argAdmId="")) ""
	
	s dischgdatetime="",dischgdate="",dischgtime=""
	s dischgdateyear="",dischgdatemonth="",dischgdateday=""
		
	q:(($d(^PAADM(argAdmId))'=1)&&($d(^PAADM(argAdmId))'=11)) ""
	s dischgdate=$P($G(^PAADM(argAdmId)),"^",17)
	s dischgtime=$P($G(^PAADM(argAdmId)),"^",18)
	q:((dischgdate="")||(dischgtime="")) ""

	s dischgdatetime=dischgdate_","_dischgtime
	q dischgdatetime
}

/// Desc: 	出院日期(护士结算)
/// Output：date【Cache内部格式】
/// Others：add for 安徽省立医院, on 2007/11/1, by houjian@dhcc.com.cn
ClassMethod DisDate(argAdmId As %String) As %String
{
	q:($d(argAdmId)=0)||(argAdmId="") ""
	s dischgdate=""
	
	q:(($d(^PAADM(argAdmId))'=1)&&($d(^PAADM(argAdmId))'=11)) ""
	s dischgdate=$P($G(^PAADM(argAdmId)),"^",17)
	
	q dischgdate
}

/// Desc: 出院日期(操作权限使用)
/// Input: argAdmId 就诊rowid
/// Output: date, Cache内部格式
/// Debug：##class(EPRservice.HISInterface.PatientInfoAssist).DisDatePriv("65")	
ClassMethod DisDatePriv(argAdmId As %String) As %String
{
	
	q:(argAdmId="") ""
	s (deathdate,disDateMR,disDate) = ""
	
	//先取死亡日期
	s papmiDR = ..GetPapmiDR(argAdmId)
	if papmiDR '= ""
	{	s deathdate=$p(^PAPER(papmiDR,"ALL"),"^",13)}
	q:(deathdate'="") deathdate
	
	//再取统计组出院日期
	s nameSpace=##class(EPRmeta.SysOption).GetOptionValueByName("NamespaceHIS")
	if nameSpace'=""
	{
		s medData = $p($g(nameSpace),"^",1)
		s curSpace = $zu(5)
		d $zu(5,medData)
		s iprowid=0 
	 	for {
		  s iprowid=$o(^DHCMRIPDetail(0,"TYPE","CYRS","ADM",argAdmId,iprowid)) 
		  q:(iprowid="")
		  s MRIPDayDr=$p($g(^DHCMRIPDetail(iprowid)),"^",3)
	 	  s disDateMR=$p($g(^MRIPdaily(MRIPDayDr)),"^",6)
	 	}
	 	d $zu(5,curSpace)
	 	q:(disDateMR'="") disDateMR
	}
	
 	//最后取护士结算日期
 	s disDate = $P($G(^PAADM(argAdmId)),"^",17)
 	q disDate
}

/// Desc: 	出院日期时间(医生结算)
/// Output：date_","_time【Cache内部格式】
/// Others：not different from hospitals
ClassMethod DisDateTimeDoctor(argAdmId As %String, argHospital As %String = "") As %String
{
	q:(($d(argAdmId)=0)||(argAdmId="")) ""
	
	s dischgdatetime="",dischgdate="",dischgtime=""
	s dischgdateyear="",dischgdatemonth="",dischgdateday=""
		
	q:(($d(^PAADM(argAdmId))'=1)&&($d(^PAADM(argAdmId))'=11)) ""
	s dischgdate=$P($G(^PAADM(argAdmId)),"^",59)
	s dischgtime=$P($G(^PAADM(argAdmId)),"^",60)
	q:((dischgdate="")||(dischgtime="")) ""

	s dischgdatetime=dischgdate_","_dischgtime
	q dischgdatetime
}

/// Desc:	取特定科室转科情况
/// Input: argAdmId 就诊rowid;		argDeptDR 指定科室ID，多个ID之间使用^分割
/// Output:	科室id1^科室名称1^进入日期1^进入时间1^退出日期1^退出时间1#科室id2^科室名称2^进入日期2^进入时间2^退出日期2^退出时间2
/// Others:	not different from hospitals 
ClassMethod SpecTransDeptDetail(argAdmId As %String, argDeptDR As %String, argTransDesc As %String = "") As %String
{
	//入参检查
	q:($d(argAdmId)=0)||(argAdmId="") ""
	q:($d(argDeptDR)=0)||(argDeptDR="") ""
	
	//获取所有有效的转科记录
	s transDept=""
	s childSub = ""
	for {
		s childSub = $O(^PAADM(argAdmId,"TRANS",childSub))
		q:(childSub="")
		
		s transStatusDR = $p($g(^PAADM(argAdmId,"TRANS",childSub)),"^",12)
		if transStatusDR=2 continue
		
		s transCtlocDR = $p($g(^PAADM(argAdmId,"TRANS",childSub)),"^",6)
		if transCtlocDR="" continue
		
		s transDeptDesc = $p($g(^CTLOC(transCtlocDR)),"^",2)
		if $l(transDeptDesc,"-")>1 {s transDeptDesc=$p(transDeptDesc,"-",2)}
		if transDeptDesc="" continue
		
		s startDate = $p($g(^PAADM(argAdmId,"TRANS",childSub)),"^",1)
		s startDate = $zd(startDate,3)
		s startTime = $p($g(^PAADM(argAdmId,"TRANS",childSub)),"^",2)
		s startTime = $zt(startTime,1)
		s endDate = $p($g(^PAADM(argAdmId,"TRANS",childSub)),"^",3)
		s endDate = $zd(endDate,3)
		s endTime = $p($g(^PAADM(argAdmId,"TRANS",childSub)),"^",4)
		s endTime = $zt(endTime,1)
		
		//将特定科室名称替换为指定的科室名称
		if (argTransDesc'="")
		{
			s:($p(argTransDesc,"^",1)=transDeptDesc) transDeptDesc = $p(argTransDesc,"^",2)
		}
		
		if transDept = ""
		{	s transDept = transCtlocDR_"^"_transDeptDesc_"^"_startDate_"^"_startTime_"^"_endDate_"^"_endTime}
		else
		{	s transDept = transDept_"#"_transCtlocDR_"^"_transDeptDesc_"^"_startDate_"^"_startTime_"^"_endDate_"^"_endTime}
	}
	
	q:(transDept="") ""

	//合并相邻的转科记录
	s mergeTransDept = ""
	s tmpMergeTransDept = "" 
	s lastTransCtlocDR = ""
	s count = $L(transDept,"#")
	for i=1:1:count
	{
		s curTransDept = $p(transDept,"#",i)
		s curTransCtlocDR = $p(curTransDept,"^",1)
		
		if i=1
		{
			s lastTransCtlocDR = curTransCtlocDR
			s tmpMergeTransDept = curTransDept
			continue
		}
		
		if curTransCtlocDR = lastTransCtlocDR
		{
			s oldDate = $p(tmpMergeTransDept,"^",5)
			s oldTime = $p(tmpMergeTransDept,"^",6)
			s length = $L(oldDate) + $L(oldTime) + 1
			s newDate = $p(curTransDept,"^",5)
			s newTime = $p(curTransDept,"^",6)
			s tmpMergeTransDept = $e(tmpMergeTransDept,1,$L(tmpMergeTransDept)-length)_newDate_"^"_newTime
		}
		else
		{
			if mergeTransDept = ""
			{	s mergeTransDept = tmpMergeTransDept}
			else
			{	s mergeTransDept = mergeTransDept_"#"_tmpMergeTransDept}
			
			s tmpMergeTransDept = curTransDept
			s lastTransCtlocDR = curTransCtlocDR
		}
	}
	if mergeTransDept = ""
	{	s mergeTransDept = tmpMergeTransDept}
	else
	{	s mergeTransDept = mergeTransDept_"#"_tmpMergeTransDept}
	
	//筛选指定科室的转科记录
	s specTransDept = ""
	s count = $L(mergeTransDept,"^")
	for i=1:1:count
	{
		s curTransDept = $p(mergeTransDept,"#",i)
		s curTransCtlocDR = $P(curTransDept,"^",1)
		if $f("^"_argDeptDR_"^", "^"_curTransCtlocDR_"^")<1 continue
		if specTransDept = ""
		{	s specTransDept = curTransDept}
		else
		{	s specTransDept = specTransDept_"#"_curTransDept}
	}	
		
	q specTransDept
}

/// Desc:	转科情况
/// Output:	(科室名称->科室名称->...)或(无)
/// Others:	not different from hospitals 
ClassMethod TransDept(argAdmId As %String) As %String
{
	//入参检查
	q:(($d(argAdmId)=0)||(argAdmId="")) ""
	
	//定义变量
	s transDept="",tmpTransDept="",lastTransDept="",transStatusDR=""
	
	//最大的childSub节点
	s maxChildSub = $O(^PAADM(argAdmId,"TRANS",""),-1)
	
	s childSub = "0"
	for {
		s childSub = $O(^PAADM(argAdmId,"TRANS",childSub))
		q:(childSub="")
		//扬中项目：索引问题导致轮询到最后一个childSub后，又再次重新开始轮询
		q:(childSub = maxChildSub)
		
		
		s transStatusDR = $p($g(^PAADM(argAdmId,"TRANS",childSub)),"^",12)
		if transStatusDR=2 continue
		
		s transCtlocDR = $p($g(^PAADM(argAdmId,"TRANS",childSub)),"^",6)
		if transCtlocDR="" continue
		
		s tmpTransDept = $p($g(^CTLOC(transCtlocDR)),"^",2)
		if $l(tmpTransDept,"-")>1 {s tmpTransDept=$p(tmpTransDept,"-",2)}
		if tmpTransDept="" continue
		if tmpTransDept=lastTransDept continue
		
		s transDept = transDept_tmpTransDept
		s transDept = transDept_"->"
		
		s lastTransDept=tmpTransDept
	}
	
	if transDept'=""
	{
		s transDept=$e(transDept,1,$l(transDept)-2)
		if '($f(transDept,"->")>0) {s transDept=..#NoTransDept}
	}
		
	q transDept
	
	/*
	q:(($d(argAdmId)=0)||(argAdmId="")) ""
	s transDept="",tmpTransDept="",lastTransDept=""
	Set result=##class(%ResultSet).%New("%DynamicQuery:SQL")
	Do result.Prepare("select trans_ctloc_dr from PA_AdmTransaction  where trans_parref = ? and trans_status_dr <> 2 and trans_ctloc_dr is not null order by trans_childsub")
	Do result.Execute(argAdmId)
	For  Quit:'result.Next()  Do
	.s tmpTransDept=$p($g(^CTLOC(result.Data("TRANS_CTLOC_DR"))),"^",2)
	.if $l(tmpTransDept,"-")>1 {s tmpTransDept=$p($g(tmpTransDept),"-",2)}
	.q:(tmpTransDept="")
	.if tmpTransDept'=lastTransDept  d
	..s transDept=transDept_tmpTransDept
	..S transDept=transDept_"->"
	.s lastTransDept=tmpTransDept
	if transDept'=""
	{
	 s transDept=$e(transDept,1,$l(transDept)-2)
	 if '($f(transDept,"->")>0) {s transDept=..#NoTransDept}
	}
	q transDept
	*/
}

/// Desc:	转科明细
/// Output:	(科室DR^科室名称^日期^时间^病区DR^病区名称->科室DR^科室名称^日期^时间^病区DR^病区名称->...)或(无)
/// 		Update wangwentao 20090901 Update 20100408
/// ModifyDate: 2009-09-12
/// ModifyUser: houj
/// ModifyReson: 使用global实现替代sql实现
ClassMethod TransDeptDetail(argAdmId As %String, argHospital As %String = "") As %String
{
	//入参检查
	q:($d(argAdmId)=0)||($d(argHospital)=0)||(argAdmId="") ""
	
	//定义变量
	s transDept="",tmpTransDept="",lastTransDept="",lastTransWard="",tmpTransWard=""
	
	s childSub = ""
	for {
		s childSub = $O(^PAADM(argAdmId,"TRANS",childSub))
		q:(childSub="")
		
		s transStatusDR = $p($g(^PAADM(argAdmId,"TRANS",childSub)),"^",12)
		if transStatusDR=2 continue
		
		s transCtlocDR = $p($g(^PAADM(argAdmId,"TRANS",childSub)),"^",6)
		if transCtlocDR="" continue
		
		s tmpTransDept = $p($g(^CTLOC(transCtlocDR)),"^",2)
		if $l(tmpTransDept,"-")>1 {s tmpTransDept=$p(tmpTransDept,"-",2)}
		if tmpTransDept="" continue
		if tmpTransDept=lastTransDept continue
		
		//get TRANS_Ward_DR PAC_Ward
		s transPACWardDR = $p($g(^PAADM(argAdmId,"TRANS",childSub+1)),"^",9)
		if transPACWardDR="" continue
		
		s tmpTransWard = $p($g(^PAWARD(transPACWardDR)),"^",2)
		if $l(tmpTransWard,"-")>1 {s tmpTransWard=$p(tmpTransWard,"-",2)}
		if tmpTransDept="" continue
		if tmpTransWard=lastTransWard continue
		
		
		s startDate = $p($g(^PAADM(argAdmId,"TRANS",childSub)),"^",1)
		s startTime = $p($g(^PAADM(argAdmId,"TRANS",childSub)),"^",2)
		
		s transDept = transDept_transCtlocDR_"^"_tmpTransDept_"^"_$zd(startDate,3)_"^"_$zt(startTime)_"^"_transPACWardDR_"^"_tmpTransWard
		s transDept = transDept_"->"
		
		s lastTransDept=tmpTransDept
		s lastTransWard=tmpTransWard
	}
	
	if transDept'=""
	{
		s transDept=$e(transDept,1,$l(transDept)-2)
		if '($f(transDept,"->")>0) {s transDept=..#NoTransDept}
	}
		
	q transDept
}

/// Desc:	转科明细
/// Output:	(科室ID^科室名称^日期^时间->科室ID^科室名称^日期^时间->...)或(无)
/// Others: 【新框架web.eprajax.appointdeptmanagerGetPatientDeptList】引用
ClassMethod TransDeptIDDetail(argAdmId As %String, argHospital As %String = "") As %String
{
	//q "12^名称^1^1->13^名称1^11^11->"
	//入参检查
	q:($d(argAdmId)=0)||($d(argHospital)=0)||(argAdmId="") ""
	
	//定义变量
	s transDept="",tmpTransDept="",lastTransDept=""
	
	s childSub = ""
	for {
		s childSub = $O(^PAADM(argAdmId,"TRANS",childSub))
		q:(childSub="")
		
		s transStatusDR = $p($g(^PAADM(argAdmId,"TRANS",childSub)),"^",12)
		if transStatusDR=2 continue
		
		s transCtlocDR = $p($g(^PAADM(argAdmId,"TRANS",childSub)),"^",6)
		if transCtlocDR="" continue
		
		s tmpTransDept = $p($g(^CTLOC(transCtlocDR)),"^",2)
		if $l(tmpTransDept,"-")>1 {s tmpTransDept=$p(tmpTransDept,"-",2)}
		if tmpTransDept="" continue
		if tmpTransDept=lastTransDept continue
		
		
		s startDate = $p($g(^PAADM(argAdmId,"TRANS",childSub)),"^",1)
		s startTime = $p($g(^PAADM(argAdmId,"TRANS",childSub)),"^",2)
		
		s transDept = transDept_transCtlocDR_"^"_tmpTransDept_"^"_$zd(startDate,3)_"^"_$zt(startTime)
		s transDept = transDept_"->"
		
		s lastTransDept=tmpTransDept
	}
	
	if transDept'=""
	{
		s transDept=$e(transDept,1,$l(transDept)-2)
		if '($f(transDept,"->")>0) {s transDept=..#NoTransDept}
	}
		
	q transDept
}

/// Desc: 	保健人员分类
/// Table:	CT_EmpFunc
ClassMethod EmployType(argPaperID As %String) As %String
{
	q:(argPaperID="") ""
	
	s (retValue,dr,code,desc) = ""
	
	s dr = $P($G(^PAPER(argPaperID,"DHC")),"^",21)
	if dr'=""
	{
		//CT_EmpFunc
		s code = $p($g(^CT("EMF",dr)),"^",1)
	  	s desc = $p($g(^CT("EMF",dr)),"^",2)
	  	//过滤拼音码
	  	s:($l(desc,"-")>1) desc=$p(desc,"-",2)
		s retValue = dr_"^"_code_"^"_desc
	}
	
	q retValue
}

/// Desc: 	保健人员在岗状态
/// Table:	PAC_EmploymentStatus
ClassMethod EmployStatus(argPaperID As %String) As %String
{
	q:(argPaperID="") ""
	
	s (retValue,dr,code,desc) = ""
	
	s dr = $P($G(^PAPER(argPaperID,"DHC")),"^",22)
	if dr'=""
	{
		//PAC_EmploymentStatus
		s code = $p($g(^PAC("EMPLST",dr)),"^",1)
	  	s desc = $p($g(^PAC("EMPLST",dr)),"^",2)
	  	//过滤拼音码
	  	s:($l(desc,"-")>1) desc=$p(desc,"-",2)
		s retValue = dr_"^"_code_"^"_desc
	}
	
	q retValue
}

/// Desc: 	户口地址区县
/// Table:	CT_HealthCareRegion
ClassMethod NativeRegion(argPaperID As %String) As %String
{
	q:(argPaperID="") ""
	
	s (retValue,dr,code,desc) = ""
	
	s dr = $P($G(^PAPER(argPaperID,"DHC")),"^",17)
	if dr'=""
	{
		//CT_HealthCareRegion
		s code = $p($g(^CT("HCR",dr)),"^",1)
	  	s desc = $p($g(^CT("HCR",dr)),"^",2)
	  	//过滤拼音码
	  	s:($l(desc,"-")>1) desc=$p(desc,"-",2)
		
		s retValue = dr_"^"_code_"^"_desc
	}
	
	q retValue
}

/// Desc: 	户口街道乡镇
/// Table:	CT_HealthCareArea
ClassMethod NativeArea(argPaperID As %String) As %String
{
	q:(argPaperID="") ""
	
	s (retValue,dr,code,desc) = ""
	
	s dr = $P($G(^PAPER(argPaperID,"DHC")),"^",18)
	if dr'=""
	{
		//CT_HealthCareArea
		s code = $p($g(^CT("HCA",dr)),"^",1)
	  	s desc = $p($g(^CT("HCA",dr)),"^",2)
	  	//过滤拼音码
	  	s:($l(desc,"-")>1) desc=$p(desc,"-",2)
		s retValue = dr_"^"_code_"^"_desc
	}
	
	q retValue
}

/// Desc: 	现住址区县
/// Table:	CT_HealthCareRegion
ClassMethod AddressRegion(argPaperID As %String) As %String
{
	q:(argPaperID="") ""
	
	s (retValue,dr,code,desc) = ""
	
	s dr = $P($G(^PAPER(argPaperID,"DHC")),"^",19)
	if dr'=""
	{
		//CT_HealthCareRegion
		s code = $p($g(^CT("HCR",dr)),"^",1)
	  	s desc = $p($g(^CT("HCR",dr)),"^",2)
	  	//过滤拼音码
	  	s:($l(desc,"-")>1) desc=$p(desc,"-",2)
		s retValue = dr_"^"_code_"^"_desc
	}
	
	q retValue
}

/// Desc: 	现住址街道乡镇
/// Table:	CT_HealthCareArea
ClassMethod AddressArea(argPaperID As %String) As %String
{
	q:(argPaperID="") ""
	
	s (retValue,dr,code,desc) = ""
	
	s dr = $P($G(^PAPER(argPaperID,"DHC")),"^",20)
	if dr'=""
	{
		//CT_HealthCareArea
		s code = $p($g(^CT("HCA",dr)),"^",1)
	  	s desc = $p($g(^CT("HCA",dr)),"^",2)
	  	//过滤拼音码
	  	s:($l(desc,"-")>1) desc=$p(desc,"-",2)
		s retValue = dr_"^"_code_"^"_desc
	}
	
	q retValue
}

/// Desc:	住院天数
/// Input:	argAdmDate: 入院日期(Cache内部格式)，argDischgDate:出院日期(Cache内部格式)
/// Output:	天数
/// Others:	not different from hospitals
ClassMethod ResidentDays(argAdmDate As %String, argDischgDate As %String) As %String
{
	q:($d(argAdmDate)=0)||($d(argDischgDate)=0)||(argAdmDate="")||(argDischgDate="") ""
	s residentdays=""
	
	s residentdays=argDischgDate - argAdmDate
	q:(residentdays<0) ""
 	//不足1天按1天计算
 	q:(residentdays=0) "1"
 	
 	q residentdays
}

/// Desc:	住院天数
/// Input:	argAdmId: 病人就诊RowID，argHospital:医院标识
/// Output:	天数
/// Others:	not different from hospitals
ClassMethod ResidentDaysAdm(argAdmId As %String, argHospital As %String = "") As %String
{
	q:($d(argAdmId)=0)||(argAdmId="") ""
	//q:($d(argHospital)=0)||(argHospital="") ""
	
	s papmidr="",DeathDateTime="",AdmDateTime="",DisDateTimeMR="",DisDateTime=""
	s admdate="",admtime="",dischgdate="",dischgtime=""
	s residentdays=""

	//取PapmiDR
	q:(($d(^PAADM(argAdmId))'=1)&&($d(^PAADM(argAdmId))'=11)) ""
	s papmidr = ..GetPapmiDR(argAdmId)
	
	
	//取入院日期(护士分床)
	s AdmDateTimeInBed=..AdmDateTimeInBed(argAdmId)
	if AdmDateTimeInBed'="" 
	{
		s admdate=$p($g(AdmDateTimeInBed),",",1)
	}
	
	//出院日期取值判断  死亡日期->出院日期(统计组)->出院日期(护士结算)
	

	//取死亡日期
	s DeathDateTime=..DeathDateTime(papmidr)
	if DeathDateTime'=""
	{
		s dischgdate=$p($g(DeathDateTime),",",1)
	}
		
	if dischgdate=""
	{
		//取出院日期(统计组)
		s DisDateTimeMR=..DisDateTimeMR(argAdmId)
		if DisDateTimeMR'="" 
		{
			s dischgdate=$p($g(DisDateTimeMR),",",1)
		}
		
		if dischgdate=""
		{
			//取出院日期(护士结算)
			s DisDateTime=..DisDateTime(argAdmId)
			if DisDateTime'="" 
			{
				s dischgdate=$p($g(DisDateTime),",",1)
			}
		}
	}
	
	
	q:((admdate="")||(dischgdate="")) ""
	
	//计算住院天数
	s residentdays = ..ResidentDays(admdate,dischgdate)

	q residentdays
}

/// Desc: 	统计组就诊RowID【统计组】
ClassMethod GetMRAdmDR(argAdmId As %String)
{
	q:(($d(argAdmId)=0)||(argAdmId="")) ""
	q $P($g(^PAADM(argAdmId)),"^",61)
}

/// Desc:	出院日期时间【统计组.工作量】
/// Other:  ##Class(EPRservice.HISInterface.PatientInfoAssist).DisDateTimeMR("7","DiTan")
ClassMethod DisDateTimeMR(argAdmId As %String, argHospital As %String = "") As %String
{
	q:($d(argAdmId)=0)||(argAdmId="") ""
	//q:($d(argMeddata)=0)||(argMeddata="") ""
	//q:($d(argWebsrc)=0)||(argWebsrc="") ""
	//q:($d(argHospital)=0)||(argHospital="") ""
	
	//取命名空间
	//s NAMESPACES=##class(EPRmeta.SysOption).GetOptionValueByName("NAMESPACES")
	s NAMESPACES=##class(EPRmeta.SysOption).GetOptionValueByName("NamespaceHIS")
	if NAMESPACES'=""
	{
		s MEDDATA = $p($g(NAMESPACES),"^",1)
		s WEBSRC  = $p($g(NAMESPACES),"^",2)
	    //s LABDATA = $p($g(NAMESPACES),"^",3)
	    //s LABSRC  = $p($g(NAMESPACES),"^",3)
	}
	
	//转命名空间 调用统计组接口
	d $zu(5,MEDDATA)
	s dischgdatetime=""
    s dischgdatetime=$$GetDisAdmDate^DHCMRIPday(argAdmId)
    d $zu(5,WEBSRC)
    
    //转换为标准格式
    if (dischgdatetime'="^")&&(dischgdatetime'="")
    {
	    s dischgdatetime=$tr(dischgdatetime,"^",",")
    }
    else
    {
	    s dischgdatetime=""
	}

    q dischgdatetime
}

/// Desc：	出院日期【统计组.工作量】,待整理
/// Debug：	w ##class(EPRservice.HISInterface.PatientInfoAssist).DisDateMR("644410","Meddata","EPR")
ClassMethod DisDateMR(argAdmId As %String, argMedata As %String, argEPR As %String) As %String
{
	q:($d(argAdmId)=0)||(argAdmId="") ""
	d $zu(5,argMedata)
	if '$d(^DHCMRIPDetail(0,"TYPE","CYRS","ADM",argAdmId)) 
	{
		d $zu(5,argEPR)
		q ""
	}
 	s iprowid=0 
 	for {
	  s iprowid=$o(^DHCMRIPDetail(0,"TYPE","CYRS","ADM",argAdmId,iprowid)) 
	  q:(iprowid="")
	  s MRIPDayDr=$p($g(^DHCMRIPDetail(iprowid)),"^",3)
 	  s disdate=$p($g(^MRIPdaily(MRIPDayDr)),"^",6)
 	}
 	
 	d $zu(5,argEPR)
 	q $zd($g(disdate),3)
}

/// Desc：	出院科别【统计组.工作量】
/// 	Debug：	w ##class((EPRservice.HISInterface.PatientInfoAssist).DisLoc("644410","Meddata","EPR")
ClassMethod DisLocMR(argAdmId As %String, argMedata As %String, argEPR As %String) As %String
{
	q:($d(argAdmId)=0)||(argAdmId="") ""
	d $zu(5,argMedata)
	if '$d(^DHCMRIPDetail(0,"TYPE","CYRS","ADM",argAdmId)) 
	{
		d $zu(5,argEPR)
		q ""
	}
 	s iprowid=0 
 	s DisLoc="",LocCode="",LocDesc=""
 	for {
	  s iprowid=$o(^DHCMRIPDetail(0,"TYPE","CYRS","ADM",argAdmId,iprowid)) 
	  q:(iprowid="")
	  s MRIPDayDr=$p($g(^DHCMRIPDetail(iprowid)),"^",3)
	  continue:(MRIPDayDr="")
	  continue:('$d(^MRIPdaily(MRIPDayDr)))
	  if (DisLoc=""){s DisLoc=$p($g(^MRIPdaily(MRIPDayDr)),"^",7)}
 	}
 	
 	s LocDesc=""
 	if DisLoc'=""{
		s LocCode=$p($g(^CTLOC(DisLoc)),"^",1)
		s LocDesc=$p($g(^CTLOC(DisLoc)),"^",2)
		if $l(LocDesc,"-")>1 {s LocDesc=$p(LocDesc,"-",2)}
 	}
 	
 	d $zu(5,argEPR)
 	q DisLoc_"^"_LocCode_"^"_LocDesc
}

/// Desc：	死亡日期时间
/// Ouput：	date，time【内部格式】
/// Others：not different from hospitals 
ClassMethod DeathDateTime(argPapmiDR As %String, argHospital As %String = "") As %String
{
	q:(($d(argPapmiDR)=0)||(argPapmiDR="")) ""
	
	s deathdate="",deathtime=""
	s deathdate=$p(^PAPER(argPapmiDR,"ALL"),"^",13)
	s deathtime=$p(^PAPER(argPapmiDR,"ALL"),"^",8)
	q:((deathdate="")||(deathtime="")) ""
	q deathdate_","_deathtime
}

/// Desc:	入院次数(Trak中入院病人状态不是Cancel的个数)
/// Others:	not different from hospitals 
ClassMethod InTimes(argAdmId As %String, argHospital As %String = "") As %String
{
	q:($d(argAdmId)=0)||(argAdmId="") ""	
	
	s admid=0,times=0,papmiDR=""
	
	//PAADM_InPatNo
	s times= $p($g(^PAADM(argAdmId)),"^",29)
	q:(times '="")&&(times '= $C(0)) times
	
	s times = 0
	s papmiDR =..GetPapmiDR(argAdmId)
	q:($d(^PAPERdr(papmiDR,"ADM","I"))'=10) "1"
	for {
		s admid=$o(^PAPERdr(papmiDR,"ADM","I",admid))
		q:((admid="")||(admid>argAdmId))
		// Trak中入院病人状态不是Cancel的个数
		if $d(^PAADMi("PAADM_VisitStatus","C",admid))=0 {s times=times+1}
	}
		
	q times
}

/// Desc:	医政组的入院次数
ClassMethod InTimesWMR(argAdmId As %String, argHospital As %String) As %String
{
	s times=##Class(web.DHCWMRCodingInterface).getPaadmIP(argAdmId)
	q:(times="0") "1"
	q times
}

/// Desc:	病案费用信息：按照费用大类，一般19项
/// Output：
/// Others：
ClassMethod InPatCostTrakCare(argAdmId As %String, argHospital As %String = "") As %String
{
	// 依照病案大类取费用(SQL:DHC_TarMc )(Global：^DHCTarC("TMC",rowid) )
	q:(($d(argAdmId)=0)||(argAdmId="")) ""

		s UniqueId=""
		s UniqueId=$i(^CacheTemp)
		k ^CacheTempPatMcCate(UniqueId),PLIST
		
		// 取费用大类信息
		s n=1
		s rowid="0"
		f  s rowid=$o(^DHCTarC("TMC",rowid))  q:rowid=""  d
		.i $g(^CacheTempPatMcCate(UniqueId))="" s ^CacheTempPatMcCate(UniqueId)=0
		.i $p(^DHCTarC("TMC",rowid),"^",1)'="" d
		..s acctdesc=$p($p(^DHCTarC("TMC",rowid),"^",1),$c(1))  //DHC_TarMc  -> TARTMC_Code
		..s acctdesc2=$p($p(^DHCTarC("TMC",rowid),"^",2),$c(1)) //DHC_TarMc  -> TARTMC_Desc
		..s ^CacheTempPatMcCate(UniqueId,n)=$p(rowid,$c(1))_"^"_acctdesc_"^"_acctdesc2
		..s ^CacheTempPatMcCate(UniqueId)=n
		..s PLIST(n)=acctdesc
		..s n=n+1
	
		// 初始化
		s argAdmId=$g(argAdmId)
		q:(argAdmId="") 0
		s sum=0, P9=""
		f i=1:1:$g(^CacheTempPatMcCate(UniqueId)) d
		.s itmfee(i)=0
		
		// 将病人费用按费用大类归并
		s rowid=""
		f  s rowid=$o(^DHCPB(0,"ADM",argAdmId,rowid))  q:rowid=""  d
		.s pboid=""
		.f  s pboid=$o(^DHCPB(rowid,"O",pboid))  q:pboid=""  d
		..s pbdid="0"
		..f  s pbdid=$o(^DHCPB(rowid,"O",pboid,"D",pbdid))  q:pbdid=""  d
		...s taritem=$p(^DHCPB(rowid,"O",pboid,"D",pbdid),"^",3)     
		...s unitprice=$p(^DHCPB(rowid,"O",pboid,"D",pbdid),"^",4)   
		...s qty=$p(^DHCPB(rowid,"O",pboid,"D",pbdid),"^",5)         
		...s totalamount=$p(^DHCPB(rowid,"O",pboid,"D",pbdid),"^",7)
		...i totalamount=""  s totalamount=0
		...s sum=sum+totalamount
		...q:(taritem="")
		...q:($d(^DHCTARI(taritem))=0)
		...s subcate=$p(^DHCTARI(taritem),"^",6)
		...q:(subcate="")
		...//b
		...s acctcate=$p($g(^DHCTarC("MC",subcate)),"^",3)
		...q:(acctcate="")
		...f i=1:1:$g(^CacheTempPatMcCate(UniqueId)) d
		....i $p(acctcate,$c(1))=$p($p(^CacheTempPatMcCate(UniqueId,i),"^",1),$c(1)) d
		.....s itmfee(i)=totalamount+itmfee(i)
	
		// 将归并后的费用信息拼成字符串
		f i=1:1:$g(^CacheTempPatMcCate(UniqueId)) d
		.s P9=P9_"!"_$p($g(^CacheTempPatMcCate(UniqueId,i)),"^",2)_"^"_$p($g(^CacheTempPatMcCate(UniqueId,i)),"^",3)_"^"_$fn(itmfee(i),"",2)
		s P9="Total^总费用^"_$fn(sum,"",2)_P9
		
		k ^CacheTempPatMcCate(UniqueId)
		
		q P9
}

/// Desc:	病案费用信息：按照费用子类
/// Output:	
/// Others:
ClassMethod InPatCostTrakCareSub(argAdmId As %String, argHospital As %String = "") As %String
{
	// 依照病案子类取费用(SQL:DHC_TarMrCate )(Global：^DHCTarC("MC",rowid) )
	
	q:(($d(argAdmId)=0)||(argAdmId="")) ""

	
		s UniqueId=$i(^CacheTemp)
		k ^CacheTempPatMcCate(UniqueId),PLIST
		
		// 取费用子类信息
		s n=1
		s rowid="0"
		f  s rowid=$o(^DHCTarC("MC",rowid))  q:rowid=""  d
		.i $g(^CacheTempPatMcCate(UniqueId))="" s ^CacheTempPatMcCate(UniqueId)=0
		.i $p(^DHCTarC("MC",rowid),"^",1)'="" d
		..s acctdesc=$p($p(^DHCTarC("MC",rowid),"^",1),$c(1)) //DHC_TarMrCate -> TARMC_Code
		..s acctdesc2=$p($p(^DHCTarC("MC",rowid),"^",2),$c(1)) //DHC_TarMrCate -> TARMC_Desc
		..s ^CacheTempPatMcCate(UniqueId,n)=$p(rowid,$c(1))_"^"_acctdesc_"^"_acctdesc2
		..s ^CacheTempPatMcCate(UniqueId)=n
		..s PLIST(n)=acctdesc
		..s n=n+1
		
		
		// 初始化
		s argAdmId=$g(argAdmId)
		q:(argAdmId="") 0
		s sum=0, P9=""
		f i=1:1:$g(^CacheTempPatMcCate(UniqueId)) d
		.s itmfee(i)=0
		
		// 将病人费用信息按费用子类归并
		s rowid=""
		f  s rowid=$o(^DHCPB(0,"ADM",argAdmId,rowid))  q:rowid=""  d
		.s pboid=""
		.f  s pboid=$o(^DHCPB(rowid,"O",pboid))  q:pboid=""  d
		..s pbdid="0"
		..f  s pbdid=$o(^DHCPB(rowid,"O",pboid,"D",pbdid))  q:pbdid=""  d
		...s taritem=$p(^DHCPB(rowid,"O",pboid,"D",pbdid),"^",3)     
		...s unitprice=$p(^DHCPB(rowid,"O",pboid,"D",pbdid),"^",4)   
		...s qty=$p(^DHCPB(rowid,"O",pboid,"D",pbdid),"^",5)         
		...s totalamount=$p(^DHCPB(rowid,"O",pboid,"D",pbdid),"^",7)
		...i totalamount=""  s totalamount=0
		...s sum=sum+totalamount
		...q:(taritem="")
		...q:($d(^DHCTARI(taritem))=0)
		...s subcate=$p(^DHCTARI(taritem),"^",6)  //DHC_TarMrCate -> Rowid
		...q:(subcate="")
		...//b
		...s acctcate=subcate
		...q:(acctcate="")
		...f i=1:1:$g(^CacheTempPatMcCate(UniqueId)) d
		....i $p(acctcate,$c(1))=$p($p(^CacheTempPatMcCate(UniqueId,i),"^",1),$c(1)) d
		.....s itmfee(i)=totalamount+itmfee(i)
		
		// 将归并后的费用信息拼成字符串
		f i=1:1:$g(^CacheTempPatMcCate(UniqueId)) d
		.s P9=P9_"!"_$p($g(^CacheTempPatMcCate(UniqueId,i)),"^",2)_"^"_$p($g(^CacheTempPatMcCate(UniqueId,i)),"^",3)_"^"_$fn(itmfee(i),"",2)
		s P9="Total^总费用^"_$fn(sum,"",2)_P9
		
		k ^CacheTempPatMcCate(UniqueId)
		
		q P9
}

/// Desc:	病人费用类型
/// Input:	argType {"D":Desc,"C":Code,"ALL":PayTypeDR_"^"_PayTypeCode_"^"_PayTypeDesc}
/// wangwentao OK
ClassMethod PayType(argAdmId As %String, argType As %String = "D") As %String
{
	//病人费用类型
	//SQL:PAC_AdmReason

	q:($d(argAdmId)=0)||(argAdmId="") ""
	q:($d(argType)=0)||(argType="") ""
	
	s (PayTypeCode,PayTypeDesc,PayTypeDR)=""
	
	s PayTypeDR=$p($g(^PAADM(argAdmId,1)),"^",7)
	q:(PayTypeDR="") ""
	
	if (argType ="C")
	{
		s PayType = $p($g(^PAC("ADMREA",PayTypeDR)),"^",1)
	}
	elseif (argType ="D")
	{
		s PayType=$p($g(^PAC("ADMREA",PayTypeDR)),"^",2)
	}
	elseif (argType ="ALL")
	{
		s PayType = PayTypeDR_"^"_$p($g(^PAC("ADMREA",PayTypeDR)),"^",1)_"^"_$p($g(^PAC("ADMREA",PayTypeDR)),"^",2)
	}

	q PayType
}

/// Desc:	医疗付款方式(病案首页)
ClassMethod PayMode(argAdmId As %String, argHospital As %String) As %String
{
	//医疗付款方式
	//Modify By wangwentao 20080519 argPapmiDR -> argAdmId
	//地坛医院PAC_AdmReason
	//01 自费 02 医保 03 公费医疗 04 农合 05 外地医保 06 商业保险 07 本院职工 08 儿童医保 09 老年医保
	//安徽省立PAC_AdmReason
	//9自费, 10省医保, 11省医保在职, 12省医保30年在职, 13省医保退休, 14省医保特种病, 15合肥市医保, 16本院职工, 17本院职工45岁以下, 18本院职工45岁以上, 19本院职工60岁以上, 20本院职工30年在职, 21本院职工退休, 22本院职工离休, 23本院职工30年工龄干保, 24本院职工55岁以上干保, 25社会干保, 26贵宾(暂不用), 27特困, 28绿色通道110, 29绿色通道120, 30无名氏, 31合肥市医保特病, 32合肥市城镇居民医保, 33院长减免, 34新农合

	q:($d(argAdmId)=0)||($d(argHospital)=0)||(argAdmId="")||(argHospital="") ""
	
	s PayMode="",PayModeCode="",PayType="",PayTypeCode=""
	
	//b "s"
	if (argHospital=..#HospitalBJJSTYY)||(argHospital=..#HospitalHXYY) 
	{
		//北京积水潭医院, 华西医院
		s PayType=$p($g(^PAADM(argAdmId,1)),"^",7)
		s:(PayType'="") PayMode = $p($g(^PAC("ADMREA",PayType)),"^",2) 
	}	
	elseif argHospital=..#HospitalBJDTYY 
	{
		//北京地坛医院
		s PayType=$p($g(^PAADM(argAdmId,1)),"^",7)
		if PayType'="" 
		{
			if (PayType=2)||(PayType=8)||(PayType=9)  {s PayMode=..#PayTypeYLBX}
			elseif (PayType=6)  {s PayMode=..#PayTypeSYBX}
			elseif (PayType=3)||(PayType=7)  {s PayMode=..#PayTypeGFYL}
			elseif (PayType=4)  {s PayMode=..#PayTypeQT}
			//elseifif (PayType=7)  {s PayMode=..#PayTypeDBTC}
			else {s PayMode=..#PayTypeZFYL}
		}
		
	}
	elseif argHospital=..#HospitalAHSLYY
	{
		//安徽省立医院
		s PayType=$p($g(^PAADM(argAdmId,1)),"^",7)
		if PayType'="" 
		{
			if (PayType=10)||(PayType=8)||(PayType=9)  {s PayMode=..#PayTypeSHJBYLBX}
			elseif (PayType=6)  {s PayMode=..#PayTypeSYBX}
			elseif (PayType=3)||(PayType=7)  {s PayMode=..#PayTypeGFYL}
			elseif (PayType=4)  {s PayMode=..#PayTypeQT}
			//elseifif (PayType=7)  {s PayMode=..#PayTypeDBTC}
			else {s PayMode=..#PayTypeZFYL}
		}
	}
	elseif argHospital=..#HospitalAHXNXGYY
	{
		//安徽心脑心血医院
		s PayType=$p($g(^PAADM(argAdmId,1)),"^",7)
		if PayType'=""
		{
			//1	社会基本医疗保险
			if (PayType=10)||(PayType=11)||(PayType=12)||(PayType=13)||(PayType=14)||(PayType=15)||(PayType=16)||(PayType=17)||(PayType=18)||(PayType=19)||(PayType=20)||(PayType=21)||(PayType=22)||(PayType=23)||(PayType=24)||(PayType=25)
			{s PayMode=..#PayTypeSHJBYLBX}
			//2	商业保险
			//elseif (PayType=6)||(PayType=8)
			//{s PayMode=..#PayTypeSYBX}
			//3	自费
			elseif (PayType=9)
			{s PayMode=..#PayTypeZF}
			//4	公费
			//elseif (PayType=6)
			//{s PayMode=..#PayTypeGF}
			//5	大病统筹
			//elseif (PayType=6)
			//{s PayMode=..#PayTypeDBTC}
			//6	其它
			//elseif (PayType=6)
			//{s PayMode=..#PayTypeQT}
			
		}
		
	}
	elseif argHospital=..#HospitalYKYZLYY
	{
		//医科院肿瘤医院
		s PayType=$p($g(^PAADM(argAdmId,1)),"^",7)
		if PayType'=""
		{
			s PayTypeCode = $p($g(^PAC("ADMREA",PayType)),"^",1)
			
			s PayModeCode= ##class(web.UDHCJFBaseCommon).admReasonTransfer(PayTypeCode)
		    //s PayModeCode= $ZOBJCLASSMETHOD("web.UDHCJFBaseCommon","admReasonTransfer",PayTypeCode)
		    /*
		    if (PayModeCode=1)     { set PayMode=..#PayTypeCZJMYB  }
		    elseif (PayModeCode=2) { set PayMode=..#PayTypeCZJMYB  }
		    elseif (PayModeCode=3) { set PayMode=..#PayTypeXNH }
		    elseif (PayModeCode=4) { set PayMode=..#PayTypeQTSHBX }
		    elseif (PayModeCode=5) { set PayMode=..#PayTypeSYJKBX }
		    elseif (PayModeCode=6) { set PayMode=..#PayTypeZF }
	        elseif (PayModeCode=7) { set PayMode=..#PayTypeGFYL }
	        elseif (PayModeCode=9) { set PayMode=..#PayTypeQT2 }
	        */
		    
		    if (PayModeCode=1)     { set PayMode=..#PayTypeCZZGJBYLBX  }
		    elseif (PayModeCode=2) { set PayMode=..#PayTypeCZJMJBYLBX  }
		    elseif (PayModeCode=3) { set PayMode=..#PayTypeXXNCHZYL }
		    elseif (PayModeCode=4) { set PayMode=..#PayTypePKJZ }
		    elseif (PayModeCode=5) { set PayMode=..#PayTypeSYYLBX }
		    elseif (PayModeCode=6) { set PayMode=..#PayTypeQGF }
	        elseif (PayModeCode=7) { set PayMode=..#PayTypeGZF }
	        elseif (PayModeCode=9) { set PayMode=..#PayTypeQT2 }
	        
	        
	    }
	}
	
	q PayMode
	
	/*
	s PayType=""
	
	if (argHospital=..#HospitalBJJSTYY)||(argHospital=..#HospitalHXYY) 
	{
		//北京积水潭医院, 华西医院
		s PayType=$p($g(^PAADM(argAdmId,1)),"^",7)
		q:(PayType="") ""
		q $p($g(^PAC("ADMREA",PayType)),"^",2)
	}	
	elseif argHospital=..#HospitalBJDTYY 
	{
		//北京地坛医院
		s PayType=$p($g(^PAADM(argAdmId,1)),"^",7)
		if PayType'="" 
		{
			if (PayType=2)||(PayType=8)||(PayType=9)  {s PayType=..#PayTypeYLBX}
			elseif (PayType=6)  {s PayType=..#PayTypeSYBX}
			elseif (PayType=3)||(PayType=7)  {s PayType=..#PayTypeGFYL}
			elseif (PayType=4)  {s PayType=..#PayTypeQT}
			//elseifif (PayType=7)  {s PayType=..#PayTypeDBTC}
			else {s PayType=..#PayTypeZFYL}
		}
		
	}
	elseif argHospital=..#HospitalAHSLYY
	{
		//安徽省立医院
		s PayType=$p($g(^PAADM(argAdmId,1)),"^",7)
		if PayType'="" 
		{
			if (PayType=10)||(PayType=8)||(PayType=9)  {s PayType=..#PayTypeSHJBYLBX}
			elseif (PayType=6)  {s PayType=..#PayTypeSYBX}
			elseif (PayType=3)||(PayType=7)  {s PayType=..#PayTypeGFYL}
			elseif (PayType=4)  {s PayType=..#PayTypeQT}
			//elseifif (PayType=7)  {s PayType=..#PayTypeDBTC}
			else {s PayType=..#PayTypeZFYL}
		}
	}
	elseif argHospital=..#HospitalAHXNXGYY
	{
		//安徽心脑心血医院
		s PayType=$p($g(^PAADM(argAdmId,1)),"^",7)
		if PayType'=""
		{
			//1	社会基本医疗保险
			if (PayType=10)||(PayType=11)||(PayType=12)||(PayType=13)||(PayType=14)||(PayType=15)||(PayType=16)||(PayType=17)||(PayType=18)||(PayType=19)||(PayType=20)||(PayType=21)||(PayType=22)||(PayType=23)||(PayType=24)||(PayType=25)
			{s PayType=..#PayTypeSHJBYLBX}
			//2	商业保险
			//elseif (PayType=6)||(PayType=8)
			//{s PayType=..#PayTypeSYBX}
			//3	自费
			elseif (PayType=9)
			{s PayType=..#PayTypeZF}
			//4	公费
			//elseif (PayType=6)
			//{s PayType=..#PayTypeGF}
			//5	大病统筹
			//elseif (PayType=6)
			//{s PayType=..#PayTypeDBTC}
			//6	其它
			//elseif (PayType=6)
			//{s PayType=..#PayTypeQT}
			
		}
		
	}
	
	q PayType
	*/
}

/// Desc:	医疗付款方式SQL(病案首页)
ClassMethod PayModeLink(argAdmId As %String, argHospital As %String = "") As %String
{
	q:($d(argAdmId)=0)||(argAdmId="") ""
	
	s PayTypeCode=..PayType(argAdmId,"C"),PayModeLink=""
	
	s PayModeLink = ..GetCustomDictionaryLinkByCode("DHCEPRVPayModeLink",PayTypeCode,"D")
	
	q PayModeLink
}

/// guozongtao
/// w ##Class(EPRservice.HISInterface.PatientInfoAssist).GetCustomDictionaryViewByID("RelationGB/T4761","5")
ClassMethod GetCustomDictionaryViewByID(paraCtmDictType As %String, paraCtmDictCode As %String, argType As %String = "ALL") As %String
{

 s relationDR="",relationcode="",relationdesc=""
 
 k SQLCODE
 &sql(SELECT TOP 1 CtmDictCode ,CtmDictDesc into :relationcode,:relationdesc FROM EPRmeta.CustomDictionary WHERE CtmDictType = :paraCtmDictType AND CtmDictID=:paraCtmDictID)
 
	if (argType ="C")
	{
		s DictCode = relationcode
	}
	elseif (argType ="D")
	{
		s DictCode = relationdesc
	}
	elseif (argType ="ALL")
	{
		s DictCode = relationcode_"^"_relationdesc
	}

 	s:(SQLCODE'=0) DictCode=""

 QUIT DictCode
}

/// w ##Class(EPRservice.HISInterface.PatientInfoAssist).GetCustomDictionaryLinkByCode("RelationGB/T4761","5")
ClassMethod GetCustomDictionaryLinkByCode(paraCtmDictType As %String, paraCtmDictCode As %String, argType As %String = "ALL") As %String
{

 s relationDR="",relationcode="",relationdesc=""
 
 k SQLCODE
 &sql(SELECT TOP 1 CtmDictLinkCode ,CtmDictLink into :relationcode,:relationdesc FROM EPRmeta.CustomDictionary WHERE CtmDictType = :paraCtmDictType AND CtmDictCode=:paraCtmDictCode)
 
	if (argType ="C")
	{
		s DictCode = relationcode
	}
	elseif (argType ="D")
	{
		s DictCode = relationdesc
	}
	elseif (argType ="ALL")
	{
		s DictCode = relationcode_"^"_relationdesc
	}

 	s:(SQLCODE'=0) DictCode=""
 
 QUIT DictCode
}

/// Desc:	住院病案号, 停用，使用 IPRecordNo 代替
/// Table:	PA_PatMas.PAPMI_Medicare
ClassMethod IMedicare(argPapmiDR As %String, argHospital As %String = "")
{
 
	q:(($d(argPapmiDR)=0)||(argPapmiDR="")) ""
	q ..IPRecordNo(argPapmiDR, argHospital)
}

/// Desc:	门诊病案号, 停用，使用 OPRecordNo 代替
/// Table:	PA_Person.PAPER_GovernCardNo
ClassMethod OMedicare(argPaperDR As %String, argHospital As %String = "")
{
	q:(($d(argPaperDR)=0)||(argPaperDR="")) ""
	q ..OPRecordNo(argPaperDR, argHospital)
}

/// Desc:	急诊病案号，停用，使用 EPRecordNo 代替
/// Table:	DHC_Person.PAPER_FCMedicareCode1
ClassMethod EMedicare(argPaperDR As %String, argHospital As %String = "")
{
	q:(($d(argPaperDR)=0)||(argPaperDR="")) ""
	q ..EPRecordNo(argPaperDR, argHospital)
}

/// Desc:	住院病案号 
/// Table:	PA_PatMas.PAPMI_Medicare
ClassMethod IPRecordNo(argPapmiDR As %String, argHospital As %String = "")
{
 
	q:(($d(argPapmiDR)=0)||(argPapmiDR="")) ""
	
	s recordNo = ""
	
	//积水潭医院的病案号第一位可能是字母, 要去掉
	if argHospital=..#HospitalBJJSTYY {
		s recordNo=$p($g(^PAPER(argPapmiDR,"PAT",1)),"^",22)
		if ((recordNo?1L.N)||(recordNo?1U.N)) {s recordNo=$e(recordNo,2,$l(recordNo))}
		q recordNo
	}
	
	//Modify by Liaowp 2010-01-20
	//大同三院病案号SQLUSER.PA_Patmas:PAPMI_safetynetcardno:$P(^PAPER(argPapmiDR,"PAT",3),"^",4)
	if argHospital=..#HospitalDTSY {
		s recordNo = $P($g(^PAPER(argPapmiDR,"PAT",3)),"^",4)	
		q recordNo
	}
	
	// 其它医院使用默认字段
	s recordNo = $P($g(^PAPER(argPapmiDR,"PAT",1)),"^",22)	
	
	q recordNo
}

/// Desc:	门诊病案号 
/// Table:	PA_Person.PAPER_GovernCardNo
ClassMethod OPRecordNo(argPaperDR As %String, argHospital As %String = "")
{
	q:(($d(argPaperDR)=0)||(argPaperDR="")) ""
	s recordNo=""

	//积水潭医院病案号第一位可能是字母, 要去掉
	if argHospital=..#HospitalBJJSTYY 
	{
		s recordNo=$p($g(^PAPER(argPapmiDR,"PER",4)),"^",4)
		if ((recordNo?1L.N)||(recordNo?1U.N)) {s recordNo=$e(recordNo,2,$l(recordNo))}
		q recordNo
	}
	
	// 其它医院使用默认字段
	q:($d(^PAPER(argPaperDR,"PER",4))'=1) ""
	s recordNo=$P($g(^PAPER(argPaperDR,"PER",4)),"^",4)
	
	q recordNo
}

/// Desc:	急诊病案号 
/// Table:	DHC_Person.PAPER_FCMedicareCode1
ClassMethod EPRecordNo(argPaperDR As %String, argHospital As %String = "")
{
	q:(($d(argPaperDR)=0)||(argPaperDR="")) ""
	s recordNo=""
	
	s emedicareDR=$o(^DHCPERSON(0,"PAPERSON",argPaperDR,""))
	if emedicareDR'=""
	{
		q:($d(^DHCPERSON(emedicareDR))'=1) ""
		s recordNo=$p($g(^DHCPERSON(emedicareDR)),"^",5)
	}

	q recordNo
}

/// Desc:	医保号
ClassMethod InsuranceNo(argAdmId As %String, argHospital As %String) As %String
{
	q:($d(argAdmId)=0)||($d(argHospital)=0)||(argAdmId="")||(argHospital="") ""
	s insuranceNo="", argPapmiDR=""  
	
	if (argHospital=..#HospitalAHSLYY)||(argHospital=..#HospitalAHXNXGYY)||(argHospital=..#HospitalXAJDKQYY)
	{
		s insuranceNo=##class(web.DHCINSUAdmInfoCtl).GetInfoByAdm(argAdmId)
		if ($p(insuranceNo,"!",1)'="1") {s insuranceNo=""}
		else {
		 s insuranceNo=$p(insuranceNo,"!",2)
		 s insuranceNo=$p(insuranceNo,"^",3)
		}
		q insuranceNo
	}
	if (argHospital=..#HospitalYBRMYY)||(argHospital=..#HospitalBJJSTYY)	
	{
		s insuranceNo=##class(web.INSUAdmInfoCtl).QueryAdmInfo(argAdmId)
		if ($p(insuranceNo,"^",11)="") {s insuranceNo=""}
		else {s insuranceNo=$p(insuranceNo,"^",11)}
		q insuranceNo
	}
	
	// 下列医院取默认字段：Pa_Person -> PAPER_Name
	// 北京地坛医院	 
	s argPapmiDR =..GetPapmiDR(argAdmId)
	if argPapmiDR'=""{s insuranceNo=$P($G(^PAPER(argPapmiDR,"ALL")),"^",19)}
		
	
	q insuranceNo
}

/// Desc: X线号, 待整理
ClassMethod XRayID(argPapmiDR As %String, argHospital As %String = "") As %String
{
	
	q:(($d(argPapmiDR)=0)||(argPapmiDR="")) ""
	q ""
}

/// Desc: 	护理单元，即护理病区
/// Output：RowId^Code^Desc
/// Others: 被下列模块引用
/// 		[操作权限]EPRservice.Privilege.BOPrivAssist
/// 		[模板控制]EPRservice.TPrivLogic.PatientInfoAssist
ClassMethod CareUnit(argAdmId As %String) As %String
{
	q:($d(argAdmId)=0)||(argAdmId="") ""
	s retValue=""
	
	s wardDR=$P($g(^PAADM(argAdmId)),"^",70)
	if wardDR'="" 
	{
		s WardCode=$p($g(^PAWARD(wardDR)),"^",1)
		s WardDesc=$p($g(^PAWARD(wardDR)),"^",2)
		if $l(WardDesc,"-")>1 {s WardDesc=$p($g(WardDesc),"-",2)}
		s retValue=wardDR_"^"_WardCode_"^"_WardDesc
	}
	
	q retValue
}

/// Desc:	取西药医嘱
ClassMethod GetOrdersXiYao(argAdmId As %String)
{

	s PrescNoStr="",PrescNo="",RecDep="",PrescDate=""
	s PrescNoStrCount="",PrescNoSub=""
	s PrescDesc="",PrescDescStr="",PrescDescStrCount=""
	s i="",Subi="",Result="",ResultSub="",PrescDescResult="",PrescDescSubResult=""
	s NoteStr="",Note2="",Note4="",Note5="",Note6="",Note9="",Note10="",Note12="",Note13=""
	
	s PrescNoStr=##class(EPRservice.HISInterface.PatientInfoAssist).GetOrdersXiYaoPrescNo(argAdmId)
		
		s PrescNoStrCount=$l(PrescNoStr,"!")-1
		
		//暂时处理<MAXSTRING>报错
 		s:(PrescNoStrCount>1000) PrescNoStrCount = "" 
		
        f i=1:1:PrescNoStrCount
        {
	        s ResultSub=""
	        s PrescNoSub=$p($g(PrescNoStr),"!",i)
	        s PrescDescStr=##class(EPRservice.HISInterface.PatientInfoAssist).GetOrdersXiYaoItems(argAdmId,PrescNoSub)
	        s PrescDescStrCount=$l(PrescDescStr,"!")-1

	        f Subi=1:1:PrescDescStrCount
	        {
		        s PrescDesc=$p($g(PrescDescStr),"!",Subi)

		        //EPR> Note 2 医嘱名称
		        //EPR> Note 4 医嘱序号
		        //EPR> Note 5 单次计量
		        //EPR> Note 6 单次计量单位 
		        //EPR> Note 9 频次
		        //EPR> Note 10 用法
		        //EPR> Note 12 总量
		        //EPR> Note 13 总量单位
		        //
		        //EPR> 4医嘱序号 2医嘱名称 X 12总量13总理单位 / 10用法 每次5单次计量6单次计量单位 9频次
				//EPR> 1 氯化钠注射液 ([0.9%100ml]) X 15瓶 / 静脉滴注 每次100ml Q8h
				
				s Note2=$p($g(PrescDesc),"^",2)
				s Note4=$p($g(PrescDesc),"^",4)
				s Note5=$p($g(PrescDesc),"^",5)
				s Note6=$p($g(PrescDesc),"^",6)
				s Note9=$p($g(PrescDesc),"^",9)
				s Note10=$p($g(PrescDesc),"^",10)
				s Note12=$p($g(PrescDesc),"^",12)
				s Note13=$p($g(PrescDesc),"^",13)
				
                s PrescDesc=Note4_" "_Note2_" X "_Note12_Note13_" / "_Note10_" 每次"_Note5_Note6_" "_Note9
		        s ResultSub=ResultSub_PrescDesc_$c(13,10)
		        s Result=ResultSub
		    }

		    s PrescDescResult=PrescDescResult_Result_$c(13,10)
		    

        }
        s PrescDescResult = $e(PrescDescResult,1,$l(PrescDescResult)-4)
	    q PrescDescResult
}

/// Desc:	被GetOrdersXiYao调用，取西药医嘱
ClassMethod GetOrdersXiYaoPrescNo(argAdmId As %String)
{
	s rset="",PrescNoStr="",PrescNo="",RecDep="",PrescDate=""
	
	s rset=##class(%ResultSet).%New("web.DHCOEOrdItem:GetPrescriptions")
	do rset.Execute(argAdmId)
		While (rset.Next()) {
		s PrescNo=rset.Data("PrescNo")
		s RecDep=rset.Data("RecDep")
		s PrescDate=rset.Data("PrescDate")
		s PrescNoStr=PrescNoStr_PrescNo_"!"
		}
	d rset.Close()
	q PrescNoStr
}

/// Desc:	被GetOrdersXiYao调用，取西药医嘱
ClassMethod GetOrdersXiYaoItems(argAdmId As %String, argPrescNo As %String) As %Library.String
{
	s columns="0",value="",ItemsStr=""
	
	Set rset=##class(%ResultSet).%New("web.DHCOEOrdItem:GetPrescItems")
	do rset.Execute(argAdmId,argPrescNo)
	Set columns = rset.GetColumnCount()
	While (rset.Next()) {
		For col = 1:1:columns {
			//Write rset.GetColumnName(col),":"
			if col=1 set value=rset.GetData(col)
			e  s value=value_"^"_rset.GetData(col)
		}
		s ItemsStr=ItemsStr_value_"!"
	}
	d rset.Close()
	Q ItemsStr
}

/// Desc：	取中草药医嘱
/// Output：返回值格式如下
/// 		藿香30g     黄芩30g     苦杏仁30g    桔红30g   
/// 		白豆蔻18g   荷叶30g     苏梗30g      紫苏叶30g
/// 		白茅根45g   旋覆花30包  生赭石45g       
/// 		共7付    每日1剂 450ml 煎服 每日3次 每次150ml
/// Debug：	w ##class(EPRservice.HISInterface.PatientInfoAssist).GetOrdersCaoYao(304)		
ClassMethod GetOrdersCaoYao(episodeID As %String)
{
	quit:($d(episodeID)=0||episodeID="") ""
	s result = ""
	s TENBLANK = "          "
	
	//job:进程号，用以确定中草药医嘱所在Global位置
	s job = ##class(web.UDHCPrescriptQueryCM).allprint(episodeID)
	//医嘱总条数
	s totNum = ##class(web.UDHCPrescriptQueryCM).getnum(job)
	for num = 1:1:totNum
	{
		//一条医嘱
		s orderStr = ##class(web.UDHCPrescriptQueryCM).getallinfo(job,num)
		s itemStr = $P(orderStr,"^",15)
		//数量
		s qty = $P(orderStr,"^",19)
		//用法
		s method = $P(orderStr,"^",12)
		//频次
		s frequence = $P(orderStr,"^",23)
		//每次剂量
		s eachMake = $P(orderStr,"^",24)
		//总剂量
		s allMake = $P(orderStr,"^",25)
		
		//该条医嘱包含的草药数目
		s itemNum = $Length(itemStr,"|")
		s flag = 0
		for I = 1:1:itemNum-1
		{	
			//一种草药信息
			s item = $P(itemStr,"|",I)
			//取名称、剂量、单位
			s item = $p(item,"%",1)
			//去掉中间的空格
			s item = $tr(item," ","")
			//不足十个字符，补空格，一个汉字的长度为1
			//s length =  $length($zcvt(item,"O","GB"))
			s length = $length(item)
			if length < 10
			{
				s item = item_$e(TENBLANK,1,10-length)
			}
			//每四项一行
			if flag '= 4
			{
				s result = result_item
				s flag = flag + 1
			}	
			else
			{
				s result = result_$c(13,10)_item
				s flag = 1
			}
		}
		//b "s"
		s result = result_$c(13,10)_"共"_qty_"付"_"    "_$P(frequence," ",1)_" "_allMake_" "_method_" "_$P(frequence," ",2)_" "_"每次"_eachMake_$c(13,10)_$c(13,10)
	}
	
	//去掉最后的两个回车
	s result = $e(result,1,$l(result)-4)
	
	quit result
}

/// Desc：	取中草药医嘱最近一次
/// Output：返回值格式如下
/// 		藿香30g     黄芩30g     苦杏仁30g    桔红30g 
/// 		白豆蔻18g   荷叶30g     苏梗30g      紫苏叶30g 
/// 		白茅根45g   旋覆花30包  生赭石45g       
/// 		共7付    每日1剂 450ml 煎服 每日3次 每次150ml
/// Debug：	w ##class(EPRservice.HISInterface.PatientInfoAssist).GetOrdersCaoYao(304)		
ClassMethod GetOrdersCaoYaoPrevious(episodeID As %String)
{
	quit:($d(episodeID)=0||episodeID="") ""
	s result = ""
	s TENBLANK = "          "
	
	//job:进程号，用以确定中草药医嘱所在Global位置
	s job = ##class(web.UDHCPrescriptQueryCM).allprint(episodeID)
	//医嘱总条数
	s totNum = ##class(web.UDHCPrescriptQueryCM).getnum(job)
	
	q:(totNum="") result
	
	for num = totNum:totNum:totNum
	{
		//一条医嘱
		s orderStr = ##class(web.UDHCPrescriptQueryCM).getallinfo(job,num)
		s itemStr = $P(orderStr,"^",15)
		//数量
		s qty = $P(orderStr,"^",19)
		//用法
		s method = $P(orderStr,"^",12)
		//频次
		s frequence = $P(orderStr,"^",23)
		//每次剂量
		s eachMake = $P(orderStr,"^",24)
		//总剂量
		s allMake = $P(orderStr,"^",25)
		
		//该条医嘱包含的草药数目
		s itemNum = $Length(itemStr,"|")
		s flag = 0
		for I = 1:1:itemNum-1
		{	
			//一种草药信息
			s item = $P(itemStr,"|",I)
			//取名称、剂量、单位
			s item = $p(item,"%",1)
			//去掉中间的空格
			s item = $tr(item," ","")
			//不足十个字符，补空格，一个汉字的长度为1
			//s length =  $length($zcvt(item,"O","GB"))
			//b "s"
			s length = $length(item)
			if length < 10
			{
				s item = item_$e(TENBLANK,1,10-length)
			}
			//每四项一行
			if flag '= 4
			{	
				s result = result_item
				s flag = flag + 1
				//b //111
			}	
			else
			{
				s result = result_$c(13,10)_item
				s flag = 1
				//b //222
			}
		}
		//b "s"
		s result = result_$c(13,10)_"共"_qty_"付"_"    "_$P(frequence," ",1)_" "_allMake_" "_method_" "_$P(frequence," ",2)_" "_"每次"_eachMake_"         "_$c(13,10)_$c(13,10)
	}
	
	//去掉最后的两个回车
	s result = $e(result,1,$l(result)-4)
	
	quit result
}

/// Desc:	从系统参数中取医院名称
ClassMethod HospitalName()
{
	s retValue = ##class(EPRmeta.SysOption).GetOptionValueByName("HospitalName")
	q retValue
}

/// Desc:	从系统参数中取名字空间, 停用
ClassMethod NameSpaces(argId As %Integer = "")
{
	s NameSpaces=##class(EPRmeta.SysOption).GetOptionValueByName("NameSpaces")
	
	q:(argId="") NameSpaces
	q $p($g(NameSpaces),"^",argId)
}

/// Desc:	从系统参数中取名字空间
ClassMethod NameSpaceHIS()
{
	q ##class(EPRmeta.SysOption).GetOptionValueByName("NameSpaceHIS")
}

/// Desc:	从系统参数中取名字空间
ClassMethod NameSpaceRIS()
{
	
	q ##class(EPRmeta.SysOption).GetOptionValueByName("NameSpaceRIS")
}

/// Desc:	从系统参数中取名字空间
ClassMethod NameSpaceLIS()
{
	
	q ##class(EPRmeta.SysOption).GetOptionValueByName("NameSpaceLIS")
}

/// Desc：	公共函数: 将Cache内部格式的日期时间转为标准格式
/// Input：	date,time
/// Output: 通过引用，返回 日期，年，月，日，时间，小时，分钟
ClassMethod GetSeprateDateTime(parDateTime As %String, ByRef argDate As %String, ByRef argYear As %String, ByRef argMonth As %String, ByRef argDay As %String, ByRef argTime As %String, ByRef argHour As %String, argMinute As %String) As %Status
{
	s date="",time=""
	q:($d(parDateTime)=0)||(parDateTime="") 0
	q:($l(parDateTime,",")<2) 0
	s date=$p(parDateTime,",",1)
	s argDate=date
	if date'="" {
		s date=$zd(date,3)
		if date'="1840-12-31" {
			s argYear=$p(date,"-",1)
			s argMonth=$p(date,"-",2)
			s argDay=$p(date,"-",3)}
		else {s argDate=""}
	}
	s time=$p(parDateTime,",",2)
	if time'="" {
		s time=$zt(time,1)
		s argTime=time
		s argHour=$p(time,":",1)
		s argMinute=$p(time,":",2)
	}
	
	q $$$OK
}

/// Desc: 自费药品名称
ClassMethod PayOwnMedicine(argAdmId As %String, argHospital As %String, argMeddata As %String) As %String
{
	q:($d(argAdmId)=0)||($d(argHospital)=0)||($d(argMeddata)=0)||(argAdmId="")||(argHospital="")||(argMeddata="") ""
	s medicine=""
	
	s medicine=$$getPayOwnMedicine^EPR(argAdmId)
		
	q medicine
}

/// Desc: ICU转入转出信息
ClassMethod SomeCUHistory(argAdmId As %String, argHospital As %String, argMeddata As %String, ByRef argCUHistory As %String) As %String
{
	q:($d(argAdmId)=0)||($d(argHospital)=0)||($d(argMeddata)=0)||(argAdmId="")||(argMeddata="")||(argHospital="") 0
	
	s result=$$getCUHistory^EPR(argAdmId,.argCUHistory)

	q result
}

/// Desc: 专用于ICU转入转出信息
ClassMethod SplitCUInfo(CUInfo As %String, FirstFlag As %String) As %String
{
	s CUname1=$p(CUInfo,"^",1),CUdate1tmp=$p(CUInfo,"^",2),
		CUtime1tmp=$p(CUInfo,"^",3),CUdate2tmp=$p(CUInfo,"^",4),CUtime2tmp=$p(CUInfo,"^",5),
		CUdate1="",CUdate2="",CUtime1="",CUtime2="",CU1DateTime="",CU2DateTime=""
	
	if CUdate1tmp'="" {s CUdate1=$zd(CUdate1tmp,3)}
	if CUtime1tmp'="" {
		s CUtime1=$zt(CUtime1tmp,1)
		s CUtime1=$p(CUtime1,":",1)_":"_$p(CUtime1,":",2)}
	else {s CUtime1=""}
	
	if CUdate2tmp'="" {s CUdate2=$zd(CUdate2tmp,3)}
	if CUtime2tmp'="" {
		s CUtime2=$zt(CUtime2tmp,1)
		s CUtime2=$p(CUtime2,":",1)_":"_$p(CUtime2,":",2)}
	
	if (CUtime1'="") {s CU1DateTime=CUdate1_" "_CUtime1}
	else {s CU1DateTime=CUdate1}
	if (CUtime2'="") {s CU2DateTime=CUdate2_" "_CUtime2}
	else {s CU2DateTime=CUdate2}
	
	if (FirstFlag="1") {
		if (CUname1="") {
			s CUname1=..#Hadnot
			if CU1DateTime="" {s CU1DateTime="-"}
			if CU2DateTime="" {s CU2DateTime="-"}}
	}
	if ($l(CUname1,"-")>1) {s CUname1=$p(CUname1,"-",2)}
	q CUname1_"^"_CU1DateTime_"^"_CU2DateTime
}

/// Desc：	取呼吸机使用天数
/// Output:	呼吸机使用天数，单位：天
ClassMethod ABVUsingPeriod(argAdmId As %String, argHospital As %String, argMeddata As %String) As %String
{
	q:(($d(argAdmId)=0)||($d(argHospital)=0)||($d(argMeddata)=0)||(argAdmId="")||(argHospital="")||(argMeddata="")) ""
	
	s ABVDays=0
	s ABVDays=$$getABVInfo^EPR(argAdmId)
	q ABVDays
}

/// Desc:	取护理天数信息
/// Output：特级护理天数^一级护理天数^二级护理天数^三级护理天数^ICU护理天数^CCU护理天数
ClassMethod CareDays(argAdmId As %String, caredesc0 As %String = "", caredesc1 As %String = "", caredesc2 As %String = "", caredesc3 As %String = "", icudesc As %String = "", ccudesc As %String = "", argHospital As %String = "") As %String
{
	q:(($d(argAdmId)=0)||(argAdmId="")) ""
	
	//默认值兼容
	s:((caredesc0="")&&(caredesc1="")&&(caredesc2="")&&(caredesc3="")&&(icudesc="")&&(ccudesc="")) caredesc0="特级护理",caredesc1="一级护理",caredesc2="二级护理",caredesc3="三级护理",icudesc="重症监护",ccudesc="CCU护理常规"
		
	s caredays=$$getCareDays^EPR(argAdmId,caredesc0,caredesc1,caredesc2,caredesc3,icudesc,ccudesc,argHospital)
	
	q caredays
}

/// Desc： 血型信息
/// Output：血型^RH
/// 		0^0:	都未做
/// Debug:w ##class(EPRservice.HISInterface.PatientInfoAssist).BloodType("0000095507")
ClassMethod BloodType(argRegisterNo As %String) As %String
{
	q:(($d(argRegisterNo)=0)||(argRegisterNo="")) ""
	s resultdr="",result="",bloodtype="",rh=""
	
	s resultdr=$p($g(^TDEB(argRegisterNo)),"\",4)
	q:(resultdr="") "0^0"
	s result=$G(^TTAB("BB-BG",resultdr))
	s bloodtype=$P($G(result),"\",2)
	s rh=$P($G(result),"\",3)
	q bloodtype_"^"_rh
}

/// Desc：	免疫学检查信息
/// Output：血型^RH^HBS^HCV^HIV	
ClassMethod ImmuneExamBloodType(argPapmiNo As %String, argHospital As %String, argMeddata As %String, argLabdata As %String) As %String
{
	q:($d(argPapmiNo)=0)||($d(argHospital)=0)||($d(argLabdata)=0)||(argPapmiNo="")||(argHospital="")||(argLabdata="") ""
	s result="",bloodtypetmp="",bloodtype="",rh="",hbs="",hcv="",hiv=""
	
	s result=$$getImmuneExamBloodType^EPR(argPapmiNo,argLabdata)
		
		s bloodtypetmp=$p($g(result),"^",1)
		if bloodtypetmp="" {s bloodtype="-",rh="-"}
		else {
			if $e(bloodtypetmp,1,2)="AB" {
				s bloodtype="AB"
				s rh=$e(bloodtypetmp,3,3)}
			else {
				s bloodtype=$e(bloodtypetmp,1,1)
				s rh=$e(bloodtypetmp,2,2)
			}
			if rh="P" {s rh=..#Positive}
			elseif rh="N" {s rh=..#Negative}
		}
		s hbs=$p($g(result),"^",2)
		s hbs=$case(hbs,"1":..#Negative,"0":..#Positive,:..#NotExamined)
		s hcv=$p($g(result),"^",3)
		s hcv=$case(hcv,"1":..#Negative,"0":..#Positive,:..#NotExamined)
		s hiv=$p($g(result),"^",3)
		s hiv=$case(hiv,"1":..#Negative,"0":..#Positive,:..#NotExamined)

	q bloodtype_"^"_rh_"^"_hbs_"^"_hcv_"^"_hiv
}

/// Desc: 协议检查
ClassMethod ProtocolExam(argAdmId As %String, argHospital As %String, argMeddata As %String) As %String
{
	q:($d(argAdmId)=0)||($d(argHospital)=0)||($d(argMeddata)=0)||(argAdmId="")||(argHospital="")||(argMeddata="") ""
		
	s exams=$$getProtocolExam^EPR(argAdmId)
	
	q exams
}

/// Desc: 陪护
/// Return: 1-had family care, 0-no family care 
ClassMethod HadFamilyCare(argAdmId As %String, argHospital As %String, argMeddata As %String) As %String
{
	q:($d(argAdmId)=0)||($d(argHospital)=0)||($d(argMeddata)=0)||(argAdmId="")||(argHospital="")||(argMeddata="") ""
	
	s familycare=..#Hadnot
	s familycare=$$getAccompany^EPR(argAdmId)
		
	q:(familycare=1) ..#Had
	q ..#Hadnot
}

/// Desc: 当前护理级别
/// Input: argItmMastDRStr 格式为 ^ItmMastDR1^ItmMastDR2^ItmMastDR3^...^
/// Example:     w ##Class(EPRservice.TestAndTools.EPRTest).CareClass(171380)
ClassMethod CareClass(argAdmId As %String, argItmMastDRStr As %String, argHospital As %String = "") As %String
{
	
	//&sql(select top 1 * from OE_OrdItem where oeori_oeord_parref ='50594' and OEORI_ItmMast_DR -> arcim_itemcat_dr = '217' and OEORI_ItemStat_DR <>'4' )
	//select * from ARC_ItemCat where arcic_ordcat_dr =''
	//OE_OrdItem	^OEORD({OE_Order.OEORD_RowId},"I",{OEORI_Childsub}) 
	//OE_Order		^OEORD(0,"Adm",{OEORD_Adm_DR},{OEORD_RowId})
	//[ARC_ItmMast]OEORIItmMastDR->[ARC_ItemCat]ARCIM_ItemCat_DR				
	//[ARCIM_ItemCat_DR	1	10]^ARCIM({ARCIM_Subscript},{ARCIM_Version}) 
	//[ARCIM_Desc	1	2]^ARCIM({ARCIM_Subscript},{ARCIM_Version}) 
	//[OEORI_ItemStat_DR	1	13]^OEORD({OE_Order.OEORD_RowId},"I",{OEORI_Childsub})  
	
	q:($d(argAdmId)=0)||(argAdmId="") ""
	q:($d(argItmMastDRStr)=0)||(argItmMastDRStr="") ""

	s CareClass=""
	s OEORDRowId="",OEORIChdsub="",OEORIItmMastDR="",OEORIItmMastDRsub="",ARCIMItemCatDR="",OEORIItemStatDR="",ARCIMDesc=""
	
    f  s OEORDRowId=$o(^OEORD(0,"Adm",argAdmId,OEORDRowId)) q:((OEORDRowId="")||(CareClass'=""))  d
    . //Get Max OEORIChdsub Add 1
    . s OEORIChdsub=$g(^OEORD(OEORDRowId,"I",0))+1
	. f  s OEORIChdsub=$o(^OEORD(OEORDRowId,"I",OEORIChdsub),-1) q:((OEORIChdsub="")||(CareClass'=""))  d  
	  .. //Get OE_OrdItem.OEORI_ItemStat_DR[OEC_OrderStatus]
	  .. s OEORIItemStatDR=$p($g(^OEORD(OEORDRowId,"I",OEORIChdsub,1)),"^",13)
	  .. q:(OEORIItemStatDR=4)
	  .. //Get OE_OrdItem.OEORI_ItmMast_DR[ARC_ItmMast]
	  .. s OEORIItmMastDR= $p($g(^OEORD(OEORDRowId,"I",OEORIChdsub,1)),"^",2)
	  .. q:(OEORIItmMastDR="")
	  .. //Check OE_OrdItem.OEORI_ItmMast_DR[ARC_ItmMast] 
	  .. q:($f(argItmMastDRStr,"^"_OEORIItmMastDR_"^")=0)
	  .. s OEORIItmMastDRsub=$p(OEORIItmMastDR,"||",1)
	  .. s ARCIMDesc=$p($g(^ARCIM(OEORIItmMastDRsub,1,1)),"^",2)
	  .. s CareClass=ARCIMDesc
	  
	q CareClass
}

/// Desc: 术后天数
ClassMethod DaysAfterOper(argAdmId As %String, argHospital As %String) As %String
{
	q ""
}

/// Desc: 当前膳食级别
/// Input: argItemCatDRStr 格式为 ^ItemCatDR1^ItemCatDR2^ItemCatDR3^...^
ClassMethod HadFoodTreatment(argAdmId As %String, argItemCatDRStr As %String, argHospital As %String = "") As %String
{
	//&sql(select top 1 * from OE_OrdItem where oeori_oeord_parref ='50594' and OEORI_ItmMast_DR -> arcim_itemcat_dr = '217' and OEORI_ItemStat_DR <>'4' )
	//select * from ARC_ItemCat where arcic_ordcat_dr =''
	//OE_OrdItem	^OEORD({OE_Order.OEORD_RowId},"I",{OEORI_Childsub}) 
	//OE_Order		^OEORD(0,"Adm",{OEORD_Adm_DR},{OEORD_RowId})
	//[ARC_ItmMast]OEORIItmMastDR->[ARC_ItemCat]ARCIM_ItemCat_DR				
	//[ARCIM_ItemCat_DR	1	10]^ARCIM({ARCIM_Subscript},{ARCIM_Version}) 
	//[ARCIM_Desc	1	2]^ARCIM({ARCIM_Subscript},{ARCIM_Version}) 
	//[OEORI_ItemStat_DR	1	13]^OEORD({OE_Order.OEORD_RowId},"I",{OEORI_Childsub})  
	
	q:($d(argAdmId)=0)||(argAdmId="") ""
	q:($d(argItemCatDRStr)=0)||(argItemCatDRStr="") ""

	s FoodTreatment=""
	s OEORDRowId="",OEORIChdsub="",OEORIItmMastDR="",OEORIItmMastDRsub="",ARCIMItemCatDR="",OEORIItemStatDR="",ARCIMDesc=""

    f  s OEORDRowId=$o(^OEORD(0,"Adm",argAdmId,OEORDRowId)) q:((OEORDRowId="")||(FoodTreatment'=""))  d
    . //Get Max OEORIChdsub Add 1
    . s OEORIChdsub=$g(^OEORD(OEORDRowId,"I",0))+1
	. f  s OEORIChdsub=$o(^OEORD(OEORDRowId,"I",OEORIChdsub),-1) q:((OEORIChdsub="")||(FoodTreatment'=""))  d  
	  .. //Get OE_OrdItem.OEORI_ItemStat_DR[OEC_OrderStatus]
	  .. s OEORIItemStatDR=$p($g(^OEORD(OEORDRowId,"I",OEORIChdsub,1)),"^",13)
	  .. q:(OEORIItemStatDR=4)
	  .. //Get OE_OrdItem.OEORI_ItmMast_DR[ARC_ItmMast]
	  .. s OEORIItmMastDR= $p($g(^OEORD(OEORDRowId,"I",OEORIChdsub,1)),"^",2)
	  .. q:(OEORIItmMastDR="")
	  .. s OEORIItmMastDRsub=$p(OEORIItmMastDR,"||",1)
	  .. //Get OE_OrdItem.ARCIM_ItemCat_DR[ARC_ItemCat]
	  .. s ARCIMItemCatDR=$p($g(^ARCIM(OEORIItmMastDRsub,1,1)),"^",10)
	  .. q:($f(argItemCatDRStr,"^"_ARCIMItemCatDR_"^")=0)
	  .. s ARCIMDesc=$p($g(^ARCIM(OEORIItmMastDRsub,1,1)),"^",2)
	  .. s FoodTreatment=ARCIMDesc
	  
	q FoodTreatment
}

/// Desc: 	patient's doctor in charge，not different from hospitals
/// Return: SSUSR_Initials
/// Others：被下列模块引用
/// 		[操作权限]EPRservice.Privilege.BOPrivAssist
ClassMethod SSUsrInCharge(argAdmId As %String) As %String
{
	q:($d(argAdmId)=0)||(argAdmId="") ""
	s doc="",ssusrid=""
	s doc=$P($g(^PAADM(argAdmId)),"^",9)
	i doc'="" {
		s ssusrid=$o(^SSU("SSUSR",0,"CTPCP",doc,""))
	}
	q ssusrid
}

/// Desc: 	用于默认模板控制,取所有权限, 建议使用PrivAll代替
/// Return："PrivAll"
/// Others：被下列模块引用
/// 		[模板控制]EPRservice.TPrivLogic.PatientInfoAssist
ClassMethod InterfgetPrivAll()
{
	s PrivStatus="PrivAll"
	q PrivStatus
}

/// Desc: 	用于模板权限,取所有权限
/// Return："PrivAll"
/// Others：被下列模块引用
/// 		
ClassMethod PrivAll()
{
	s PrivStatus="PrivAll"
	q PrivStatus
}

/// Desc:	病人类型，建议使用 PrivPatType，是否还在使用？？？
/// Others: 被下列模块使用
/// 			
ClassMethod InterfgetPrivPatType(argAdmId As %String) As %String
{
 	q:(($d(argAdmId)=0)||(argAdmId="")) ""
 	q ..PrivPatType(argAdmId)
}

/// Desc: 病人类型，用于默认模板控制功能，目前在用
ClassMethod PrivPatType(argAdmId As %String) As %String
{
	//定义返回值
	s Type=""
	
	//取系统参数 医院名称
	s Hospital=""
	s Hospital=##class(EPRmeta.SysOption).GetOptionValueByName("HospitalName")
	q:(Hospital="") ""

 	// 取病人所在当前科室RowId
	s Dept = "",i=""
	s Dept = ##class(EPRservice.HISInterface.PatientInfoAssist).CurrentDept(argAdmId)
	q:(Dept="") ""
	s Dept =$p($g(Dept),"^",1)


	//取系统参数 多科室多套模板
	//Modified by wangwentao 2009-03-10 添加系统参数TPrivPatTypeString
	//s TypeStr="^1004^1005^1006^1313^1314^1315^1316^1319^@^01^02^||^1106^1341^1028^1300^@^03^04^05^||^1089^1090^1091^@^06^07^08^"
 	s TypeStr=""
 	s TypeStr=##class(EPRmeta.SysOption).GetOptionValueByName("TPrivPatTypeString")	
 	q:(TypeStr="") ""
 	
    //非多套模板的通用科室 直接返回-1 不判断
	q:(+($f(TypeStr,"^"_Dept_"^"))=0) "-1"
		
	//Modified by wangwentao 2009-03-10 添加系统参数PatCatalogUnitCode
 	//s scatterCode = "病历类型#TYPE:Simple#TID:100#TVER:0#SCODE:I0024#VTYPE:C"
 	s scatterCode = ##class(EPRmeta.SysOption).GetOptionValueByName("PatCatalogUnitCode")	
	s Type = ##class(EPRservice.BOScatterData).GetEPRData(argAdmId,scatterCode)
	s Type=$tr(Type,"Null")
	q:(Type="") ""
	
	//实现不同科室使用不同的病历类型
	s Return=""
	s TypeStrCount=""
	s TypeStrCount=$l(TypeStr,"||")

	f i=1:1:TypeStrCount
	{
		s TypeSubStr=$p($g(TypeStr),"||",i)
		s TypeSubStrLoc=$p($g(TypeSubStr),"@",1)
		s TypeSubStrItemCode=$p($g(TypeSubStr),"@",2)

		i ($f(TypeSubStrLoc,"^"_Dept_"^")'=0)&&($f(TypeSubStrItemCode,"^"_Type_"^")'=0)
		{ 
		  s Return=1 
		  q
		}
	}
    if (Return'=1) { s Type="" }
    
    q Type
}

/// Desc: 取HIS的出院科室，并转换为病案室出院科室, 返回(代码+描述) 
/// Other: 仅为安徽省立医院，【病案号自动生成功能】
ClassMethod DisDeptForBingAn(argAdmId As %String, argHospital As %String) As %String
{
	// Purpose: 取HIS的出院科室，并转换为病案室出院科室, 返回(代码+描述) 
    // add for 安徽省立医院, on 2007/11/1, by houjian@dhcc.com.cn
    // 
	q:($d(argAdmId)=0)||(argAdmId="")||($d(argHospital)=0)||(argHospital="") ""
	
	s disDeptDR=""
	s disDeptCode=""
	s disDeptCodeBA="",disDeptDescBA=""
	
	s disDeptDR=$P($g(^PAADM(argAdmId)),"^",4)
    q:(disDeptDR="") ""
    //s disDeptCode=$p($g(^CTLOC(disDeptDR)),"^",1) Modify by wangwentao 2007-12-15
    //修改出院科室代码为CTLOC.CTLOC_RowID by wangwentao 2007-12-15
    s disDeptCode=disDeptDR
    q:(disDeptCode="") ""
    
    // format of retVal: disDeptCodeBA^disDeptDescBA
    s retVal=$ZOBJCLASSMETHOD("EPRmeta.CodeTable.CTLoc","SelectBALocByLocCode",disDeptCode)
    s disDeptCodeBA=$p($g(retVal),"^",1)
    s disDeptDescBA=$p($g(retVal),"^",2)
    if $L(disDeptDescBA,"-")>1 {s disDeptDescBA=$p(disDeptDescBA,"-",2)}   
    q disDeptCodeBA_"^"_disDeptDescBA
}

/// Other：仅为安徽省立医院，【病案号自动生成功能】
/// Desc: 取病案室一保存的病案号信息, 生成疾病顺序号
ClassMethod CaseRecordNoInfo(argAdmId As %String, argHospital As %String) As %String
{
	//  Purpose:取病案室一保存的病案号信息
    //  add for 安徽省立医院, on 2007/10/30，by houjian@dhcc.com.cn
    //   b "s"
	quit:($d(argAdmId)=0)||(argAdmId="")||($d(argHospital)=0)||(argHospital="") ""
	
	s disDeptBA="", disYear="", diagICDCode="", diseaseNo=""
	
	s className="EPRservice.Query.BODataQueryService"
	
	//取病案室一模板的相关信息
	s paraRecRoom=""
	&sql(select OptionValue into :paraRecRoom
	     from EPRmeta.SysOption where Name='ParaRecordRoom1')

	quit:paraRecRoom="" ""
	s templateId=$p(paraRecRoom,"^",1)            ///Id of "病案室专用一"
	s itemCodeDisDeptBA=$p(paraRecRoom,"^",2)     ///simple item code of "出院科室"
 	s itemCodeDisYear=$p(paraRecRoom,"^",3)       ///simple item code of "出院年份"
 	s itemCodeDiagICDCode=$p(paraRecRoom,"^",4)   ///simple item code of "主诊断ICD码"
 	
 	//取病案室出院科室
	s getCode="0"                 ///getCode=1:get ValueCode,  getCode'=1:get DataValue
	s disDeptBA = $ZOBJCLASSMETHOD(className,"SelectEPRItemSimple",argAdmId,templateId, itemCodeDisDeptBA, getCode)
		
	//取病案室出院年份
	s getCode="0"
	s disYear = $ZOBJCLASSMETHOD(className,"SelectEPRItemSimple",argAdmId,templateId, itemCodeDisYear, getCode)
		
	//取病案室主诊断ICD码，并取前四位（不含“.”）
	s getCode="0"
	s diagICDCode=$ZOBJCLASSMETHOD(className,"SelectEPRItemSimple",argAdmId,templateId, itemCodeDiagICDCode, getCode)
	if ($FIND(diagICDCode,".")<=5) {
	    s diagICDCode = $EXTRACT(diagICDCode,1,5)
	}
	else {
		s diagICDCode = $EXTRACT(diagICDCode,1,4)
	}
	
	//检查该病人此次就诊的病案是否保存过
	//若未保存过,生成新的疾病顺序号
	//若已保存过,比较已保存病案号和所取病案室的出院科室、出院年份、主诊断ICD码,
	//           若三者相同，则取已保存病案号的疾病顺序号
	//           若三者不同，则生成新的疾病顺序号
    s IsExist = $ZOBJCLASSMETHOD("EPRinstance.CaseRecordNo","CheckInstanceExist",argAdmId) 
    if (IsExist=0){ 
	    quit:(disDeptBA="")||(disYear="")||(diagICDCode="") disDeptBA_"^"_disYear_"^"_diagICDCode_"^"_diseaseNo 
	    s diseaseNo=$ZOBJCLASSMETHOD("EPRinstance.CaseRecordNo","AssignNewDiseaseNo",disDeptBA,disYear,diagICDCode)	    
	} 
	else {
		s savedCaseRecordNo = $ZOBJCLASSMETHOD("EPRinstance.CaseRecordNo","GetInstanceInfo",argAdmId)
		quit:(savedCaseRecordNo="") disDeptBA_"^"_disYear_"^"_diagICDCode_"^"_diseaseNo
		s savedDisDeptBA = $P(savedCaseRecordNo,"^",1)
		s savedDisYear = $P(savedCaseRecordNo, "^",2)
		s savedDiagICDCode = $P(savedCaseRecordNo,"^",3)
		s savedDiseaseNo = $P(savedCaseRecordNo, "^",4)
		if (disDeptBA=savedDisDeptBA)&(disYear=savedDisYear)&(diagICDCode=savedDiagICDCode){
			s diseaseNo=savedDiseaseNo
		} 
		else {
			s diseaseNo=$ZOBJCLASSMETHOD("EPRinstance.CaseRecordNo","AssignNewDiseaseNo",disDeptBA,disYear,diagICDCode)
		}	
	}
		
	quit disDeptBA_"^"_disYear_"^"_diagICDCode_"^"_diseaseNo
}

/// Desc:  	: 成都附院取急诊病人病人已出院时间(单位:小时)
/// Input  	: EpisodeID: 就诊号
/// Return	: 出院时间到当前时间的差值
/// Debug： : w ##Class(EPRservice.HISInterface.PatientInfoAssist).GetDischHour(argEpisodeID)
ClassMethod GetDischHour(argAdmId)
{
	s ret=0
	q ret
	
	//接口描述：取留观病人的离院时间
	//接口方法：("web.DHCADMVisitStat","FindAdmVisitStat","5091114","","","离院")
	//返回值：patRegNo:patientName:admLocDesc:patVisitStat:statDate:statTime:inWardDesc:userDesc:
    //示例：0003095945:刘波:急诊科医疗单元:离院:2009-08-08:18:47::周晶:
	
	s VisitStat="离院",PatstatDate="", PatstatTime="",Patstat=""
	
  	Set rset = ##class(%ResultSet).%New("web.DHCADMVisitStat:FindAdmVisitStat")
	do rset.Execute(argAdmId,"","",VisitStat)
	While (rset.Next()) {
	 s PatstatDate = rset.Data("statDate")
	 s PatstatTime = rset.Data("statTime")
  	}
	d rset.Close()
	
	q:(PatstatDate="")||(PatstatTime="") ret
	s DisDate=$zdh(PatstatDate,3),DisTime=$zth(PatstatTime,2)
	s CurrDate=+$h,CurrTime=$p($h,",",2)
	s cDay=0,cSecond=0
	s cDay=CurrDate-DisDate
	s cSecond=(CurrTime-DisTime)\3600
	s ret=cDay*24+cSecond
	q ret
}

/// Desc: 手术信息
/// Input: argAdmId：就诊rowid; argHospital:医院名称; argOperInfo 手术信息，引用类型
/// Output: argOperInfo 手术信息
ClassMethod OperInfo(argAdmId As %String, argHospital As %String, ByRef argOperInfo As %String) As %String
{
	q:($d(argAdmId)=0)||($d(argHospital)=0)||(argAdmId="")||(argHospital="") ""
	if argHospital=..#HospitalBJAZYY  d
	.s operdate="", opername="", operdoc="", operanatype="", operanadoc="", operid="",opercount=0
	.s argOperInfo(1)="",argOperInfo(2)="",argOperInfo(3)="",argOperInfo(4)=""
	.for  set operid=$o(^opeschi(0,"ADM",argAdmId,operid)) quit:(operid="")  do
	..q:($p($g(^opesch(operid)),"^",28)'=..#OperationFinished)
	..s operdate=$p($g(^opesch(operid)),"^",17)
	..s opername=$p($g(^opesch(operid)),"^",21)
	..s operdoc=$p($g(^opesch(operid)),"^",12)
	..s operanatype=$p($g(^opesch(operid)),"^",34)
	..s operanadoc=$p($g(^opesch(operid)),"^",3)
	..s opercount=opercount+1
	..//w operdate_"^"_opername_"^"_operdoc_"^"_operanatype_"^"_operanadoc,!
	..s argOperInfo(opercount)=operdate_"^"_opername_"^"_operdoc_"^"_operanatype_"^"_operanadoc
	q 1
}

/// Desc:获取手术信息，使用临床组接口
/// Return: 手术1日期^手术1名称^手术1医生^手术1一助^手术1二助^手术1麻醉方式^手术1麻醉医生#手术2日期^手术2名称^手术2医生^手术2一助^手术2二助^手术2麻醉方式^手术2麻醉医生
/// CreateUser: houj
/// CreateDate: 2009-12-04
ClassMethod ANOperInfo(stDate As %String, endDate As %String, episodeID As %String, ctLocID As %String) As %String
{
	//##class(web.DHCANService).GetLocOperPatInfo()返回流
	//其中信息如下：
	//<Response><PatInfo><OpDate>02/12/2009</OpDate><OpName> 踝关节骨折切开复位钢板内固定术 距骨骨折切开复位螺钉内固定术</OpName>
	//<OpDoctor>贡小英</OpDoctor><Assistant1>王金辉</Assistant1><Assistant2>张玉富</Assistant2>
	//<AnaMethod>静脉全麻+蛛网膜下腔麻醉</AnaMethod><AnaDoctor>章彦</AnaDoctor></PatInfo></Response>
	
	s operInfo = ""
	
	//临床组接口，获取手术信息流数据
 	set stream = ##class(web.DHCANService).GetLocOperPatInfo(stDate,endDate,episodeID,ctLocID)
	
	Set reader = ##class(%XML.Reader).%New()
	Set sc=reader.OpenStream(stream)
	quit:($$$ISERR(sc)) ""  
	
	//每个PatInfo节点的信息对应一个web.DHCANInterfaceReg类
	Do reader.Correlate("PatInfo","web.DHCANInterfaceReg")

	While reader.Next(.operObj,.sc) {
	   	s:(operInfo'="") operInfo = operInfo_"#"
	    s operInfo = operInfo_operObj.OpDate_"^"
	    s operInfo = operInfo_operObj.OpName_"^"
	    s operInfo = operInfo_operObj.OpDoctor_"^"
	    s operInfo = operInfo_operObj.Assistant1_"^"
	    s operInfo = operInfo_operObj.Assistant2_"^"
	    s operInfo = operInfo_operObj.AnaMethod_"^"
	    s operInfo = operInfo_operObj.AnaDoctor
	}
	
	q operInfo
}

/// Creator:	wangwentao
/// CreatDate:	20091211
/// Description:获取患者年龄
/// Table:		/
/// Input:		argAdmId:就诊号, argBirthday:出生日期, argAdmDate:入院日期, argMeddata:命名空间, argWebsrc:命名空间
/// 			argType:返回类型(1:TrakAge|2:RecordAge_"^"_RecordAgeUnit|3:BabyAge|4:ClinicAge),argCondition:临床区间条件默认14岁,argDetail:是否显示时分秒默认否
/// Output:		/
/// Others:				
/// Example:	w ##Class(EPRservice.HISInterface.PatientInfoAssist).Age(AdmId,Birthday,AdmDate,Meddata,Websrc,Type)
ClassMethod Age(argAdmId As %String, argBirthday As %String, argAdmDate As %String, argType As %String, argCondition As %String = "14", argDetail As %String = "N") As %String
{
	//入参检查
	q:($d(argBirthday)=0)||(argBirthday="") ""
	q:($d(argAdmDate)=0)||(argAdmDate="") ""
	q:(argBirthday>argAdmDate) ""
	
	//定义返回值
	s RetAge=""

	//定义变量
	s tmpAge=""
	
	// 取系统参数
  	s MEDDATA = ""
  	s SpaceHIS=##class(EPRmeta.SysOption).GetOptionValueByName("NameSpaceHIS")
	q:(SpaceHIS = "") ""
	s MEDDATA = $p($g(SpaceHIS),"^",1)
	
	//获取HIS年龄信息
	s curSpace = $zu(5)
	d $zu(5,MEDDATA)
	s tmpAge=$$CalAge^at182(argBirthday,argAdmDate)
	d $zu(5,curSpace)
	
	//b "s"
	q:(tmpAge="")&&($l(tmpAge,"|")'<14) "" 
	
	s PapmiDR = ..GetPapmiDR(argAdmId)
	s ClinicAge = ##class(web.DHCBillInterface).GetPapmiAge(PapmiDR,argAdmId)
	//年龄类型处理
	;s RetAge=$CASE(argType,1:..GetTrakAge(tmpAge),2:..GetRecordAge(tmpAge),3:..GetBabyAge(tmpAge,argBirthday,argAdmDate),4:..GetClinicAge(tmpAge,argBirthday,argAdmDate,argCondition,argDetail),5:..GetBabyAgeNew(tmpAge,argBirthday,argAdmDate))
	s RetAge=$CASE(argType,1:..GetTrakAge(tmpAge),2:..GetRecordAge(tmpAge),3:..GetBabyAge(tmpAge,argBirthday,argAdmDate),4:ClinicAge,5:ClinicAge)
	
	q RetAge
}

/// Desc: Trakcare年龄 
/// Intput：$$CalAge^at182的返回值
/// Output：	age>1岁，返回：N岁
/// 			1月<age<1岁，返回：N月 
/// 			age<1月，返回：N天
/// Others：Belong to ClassMethod Age
ClassMethod GetTrakAge(tmpAge As %String) As %String
{
	//b "s"
	//入参检查
	q:($d(tmpAge)=0)||(tmpAge="") ""
	
	//定义变量
	s TrakAge="",TrakAgeUnit=""
	s tmpAgeYear="",tmpAgeMonth="",tmpAgeDay=""
	
	//获取年月日初始值
	s tmpAgeYear=$p(tmpAge,"|",12)
	s tmpAgeMonth=$p(tmpAge,"|",13)
	s tmpAgeDay=$p(tmpAge,"|",14)
	
	//年龄逻辑判断
	if (tmpAgeYear>0)
	{
		//Trak年龄(N岁)
		s TrakAge=tmpAgeYear ,TrakAgeUnit="岁"
		s TrakAge=TrakAge_TrakAgeUnit
	}
	elseif (tmpAgeYear=0)
	{
		if (tmpAgeMonth>0)
		{
			//Trak年龄(N月)
			s TrakAge=tmpAgeMonth ,TrakAgeUnit="月"
			s TrakAge=TrakAge_TrakAgeUnit
		}
		elseif (tmpAgeMonth=0)
		{
			if (tmpAgeDay>0)
			{
				//Trak年龄(N日)
				s TrakAge=tmpAgeDay ,TrakAgeUnit="天"
				s TrakAge=TrakAge_TrakAgeUnit
			} 
			elseif (tmpAgeDay=0)
			{
				//Trak年龄(N日)
				s TrakAge=1 ,TrakAgeUnit="天"
				s TrakAge=TrakAge_TrakAgeUnit
			}  
		}
	}
	else
	{
		q ""
	}
	
	q TrakAge
}

/// Desc: 病案年龄 
/// Input: $$CalAge^at182的返回值
/// Output: 	age>1岁，返回：N_"^"_岁
/// 			age<1岁，返回：1^岁
/// Others: Belong to ClassMethod Age
ClassMethod GetRecordAge(tmpAge As %String) As %String
{
	//入参检查
	q:($d(tmpAge)=0)||(tmpAge="") ""

	//定义变量
	s RecordAge="",RecordAgeUnit=""
	s tmpAgeYear="",tmpAgeMonth="",tmpAgeDay=""
	
	//获取年月日初始值
	s tmpAgeYear=$p(tmpAge,"|",12)
	s tmpAgeMonth=$p(tmpAge,"|",13)
	s tmpAgeDay=$p(tmpAge,"|",14)
	
	//年龄逻辑判断
	if (tmpAgeYear>0)
	{		
		//病案年龄(岁)
		s RecordAge=tmpAgeYear ,RecordAgeUnit="岁"
	}
	elseif (tmpAgeYear=0)
	{
		if (tmpAgeMonth>0)
		{			
			//病案年龄(岁)
			s RecordAge=1 ,RecordAgeUnit="岁"
		}
		elseif (tmpAgeMonth=0)
		{
			if (tmpAgeDay>0)
			{				
				//病案年龄(岁)
				s RecordAge=1 ,RecordAgeUnit="岁"
			} 
			elseif (tmpAgeDay=0)
			{
				//病案年龄(岁)
				s RecordAge=1 ,RecordAgeUnit="岁"
			}  
		}
	}
	else
	{
		q ""
	}
	s RecordAge=RecordAge_"^"_RecordAgeUnit
	
	q RecordAge
}

/// Desc: 	新生儿年龄(天数格式)
/// Input:	tmpAge: $$CalAge^at182的返回值
/// 	 	argBirthday: 出生日期
/// 	 	argAdmDate：就诊日期
/// Output:  age>1岁，返回：空值
/// 			age<1岁，返回：N
/// Others: Belong to ClassMethod Age
ClassMethod GetBabyAge(tmpAge As %String, argBirthday As %String, argAdmDate As %String) As %String
{
	//入参检查
	q:($d(tmpAge)=0)||(tmpAge="") ""
	q:($d(argBirthday)=0)||(argBirthday="") ""
	q:($d(argAdmDate)=0)||(argAdmDate="") ""

	//定义变量
	s BabyAge=""
	s tmpAgeYear="",tmpAgeMonth="",tmpAgeDay=""

	//获取年月日初始值
	s tmpAgeYear=$p(tmpAge,"|",12)
	s tmpAgeMonth=$p(tmpAge,"|",13)
	s tmpAgeDay=$p(tmpAge,"|",14)
	
	//年龄逻辑判断
	if (tmpAgeYear>0)
	{
	}
	elseif (tmpAgeYear=0)
	{
		//年龄小于1岁 计算天数
		s BabyAge=(argAdmDate-argBirthday)
		
		//校验ClinicAge
		if BabyAge=0
		{
			s BabyAge=BabyAge+1
		}
		//s BabyAge=BabyAge_"天"	//因最原始的程序没拼单位"天",故注释代码!
	}
	else
	{
		q ""
	}
	
	q BabyAge
}

/// Desc: 	新生儿年龄(分数格式)
/// Input:	tmpAge: $$CalAge^at182的返回值
/// 	 	argBirthday: 出生日期
/// 	 	argAdmDate：就诊日期
/// Output:  age>1岁，返回：空值
/// 			age<1岁，返回：月 日/30
/// Others: Belong to ClassMethod Age
ClassMethod GetBabyAgeNew(tmpAge As %String, argBirthday As %String, argAdmDate As %String) As %String
{
	//入参检查
	q:($d(tmpAge)=0)||(tmpAge="") ""
	q:($d(argBirthday)=0)||(argBirthday="") ""
	q:($d(argAdmDate)=0)||(argAdmDate="") ""

	//定义变量
	s BabyAge=""
	s tmpAgeYear="",tmpAgeMonth="",tmpAgeDay=""

	//获取年月日初始值
	s tmpAgeYear=$p(tmpAge,"|",12)
	s tmpAgeMonth=$p(tmpAge,"|",13)
	s tmpAgeDay=$p(tmpAge,"|",14)
	
	//年龄逻辑判断
	if (tmpAgeYear>0)
	{
	}
	elseif (tmpAgeYear=0)
	{
		if (tmpAgeMonth>0)
		{			
			if (tmpAgeDay>0)
			{		
				//新生儿年龄(月 日/30)		
				s BabyAge=tmpAgeMonth_" "_tmpAgeDay_"/30"
			} 
			elseif (tmpAgeDay=0)
			{
				//新生儿年龄(月 日/30)
				s BabyAge=tmpAgeMonth
			} 
		}
		elseif (tmpAgeMonth=0)
		{
			if (tmpAgeDay>0)
			{				
				//新生儿年龄(岁)
				s BabyAge=tmpAgeDay
			} 
			elseif (tmpAgeDay=0)
			{
				q ""
			}  
		}		
	}
	else
	{
		q ""
	}
	
	q BabyAge
}

/// Desc: 	临床年龄 / 自然年龄
/// Input：	tmpAge：$$CalAge^at182的返回值
/// 			argBirthday: 出生日期
/// 	 	argAdmDate：就诊日期
/// 	 	argCondition: 一般为14岁
/// 	 	argDetail：
/// Output： age>argCondition，返回：N岁 
/// 			1<=age<argCondition, 返回：N岁N月 
/// 			age<1岁，返回：N天
/// Others:	Belong to ClassMethod Age   
ClassMethod GetClinicAge(tmpAge As %String, argBirthday As %String, argAdmDate As %String, argCondition As %String = "14", argDetail As %String = "N") As %String
{
	//入参检查
	q:($d(tmpAge)=0)||(tmpAge="") ""
	q:($d(argBirthday)=0)||(argBirthday="") ""
	q:($d(argAdmDate)=0)||(argAdmDate="") ""
	q:(argCondition<0)||(argCondition>200) ""

	//定义变量  argDetail  argCondition  argFormat
	s ClinicAge=""
	s tmpAgeYear="",tmpAgeMonth="",tmpAgeDay=""

	//获取年月日初始值
	s tmpAgeYear=$p(tmpAge,"|",12)
	s tmpAgeMonth=$p(tmpAge,"|",13)
	s tmpAgeDay=$p(tmpAge,"|",14)
			
	//年龄逻辑判断
	if (tmpAgeYear>0)
	{
		if (tmpAgeYear<argCondition)
		{
		 	if (tmpAgeMonth'=0)
			{
				s ClinicAge=tmpAgeYear_"岁"_tmpAgeMonth_"月"
			}
			elseif (tmpAgeMonth=0)
			{
				s ClinicAge=tmpAgeYear_"岁"
			}
		}
		elseif (tmpAgeYear>=argCondition)
		{
			s ClinicAge=tmpAgeYear_"岁"
		}
	}
	elseif (tmpAgeYear=0)
	{
		//年龄小于1岁 计算天数
		s ClinicAge=(argAdmDate-argBirthday)
	
		//校验ClinicAge
		if ClinicAge=0
		{
			s ClinicAge=ClinicAge+1
		}
		s ClinicAge=ClinicAge_"天"
	}
	else
	{
		q ""
	}
	
	q ClinicAge
}

/// Desc：	自然年龄
/// Output:	年龄大于等于1岁，返回 x岁y月
/// 	  	年龄大于等于1月但小于1岁，返回 x月y天
/// 	  	年龄小于1月但不小于30天，返回 1月0天
/// 	  	年龄小于1月且小于30天，返回 x天y时z分		
ClassMethod Ageorg(argBirthday As %String, argAdmDate As %String, argMeddata As %String, argAdmId As %String, argHospital = "") As %String
{
  	q:($d(argBirthday)=0)||($d(argAdmDate)=0)||($d(argMeddata)=0)||($d(argBirthday)=0)||(argAdmDate="")||(argMeddata="") ""
 	s tmpAge="",ageYears=0,ageMonths=0,ageDays=0,age=""
 
 	s curSpace = $zu(5)
 	d $zu(5,argMeddata)
 	s tmpAge=$$CalAge^at182(argBirthday,argAdmDate)
 	d $zu(5,curSpace)
 	
 	q:(tmpAge = "")||($l(tmpAge,"|")<14) age
 	
 	s ageYears=$p($g(tmpAge),"|",12)
 	s ageMonths=$p($g(tmpAge),"|",13)
 	s ageDays=$p($g(tmpAge),"|",14)
 		
 	if (argHospital = ..#HospitalWHETYY)
 	{
	 	//18岁以上显示：年
	 	//2岁到18岁显示：年+月
	 	//1岁到2岁显示：年+月+天
	 	//1岁之内的显示：月+天
	 	//1个月内显示：天；
		if ((+ageYears) >= 18) 
		{	s age = ageYears_"岁"}
		elseif ((+ageYears) < 18)&&((+ageYears) >= 2) 
		{	s age = ageYears_"岁"_ageMonths_"月"}
		elseif ((+ageYears) < 2)&&((+ageYears) >= 1)
		{	s age = ageYears_"岁"_ageMonths_"月"_ageDays_"天"}
		elseif ((+ageYears) < 1)&&(ageMonths >= 1)
		{	s age = ageMonths_"月"_ageDays_"天"}
		else
		{	s age = ageDays_"天"}
 	}
 	else 
 	{
 		if (ageYears'=0) 
 		{	s age=ageYears_"岁"_ageMonths_"月"}
 		elseif (ageMonths'=0) 
 		{	s age=ageMonths_"月"_ageDays_"天"}
 		elseif (ageDays'<30) 
 		{	s age="1月0天"}
 		else 
 		{
 			s papmidr=##class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiDR(argAdmId)
 			q:(papmidr="") ""
 			s birthTimeString=$g(^PAPER("DHC",papmidr,1))
 			s birthday=$p($g(birthTimeString),"^",1)
 			s birthTime=$p($g(birthTimeString),"^",2)
 			s hospital = ##class(EPRmeta.SysOption).GetOptionValueByName("HospitalName")
 			s admDateTime=##class(EPRservice.HISInterface.PatientInfoAssist).AdmDateTime(argAdmId,hospital)
 			s admDate=$p($g(admDateTime),",",1)
 			s admTime=$p($g(admDateTime),",",2)
 			i birthday="" {   s birthday=argBirthday      }
 			s ageDays=admDate-birthday
 			s ageSeconds=admTime-birthTime
 			if ageSeconds<0 {s ageSeconds=24*3600+ageSeconds,ageDays=ageDays-1}
 			s ageHours=ageSeconds\3600
 			s ageMinutes=ageSeconds#3600\60
 			s age=ageDays_"天"_ageHours_"小时"_ageMinutes_"分"
 		}
 	}
 	
 	q age
}

/// ********************************************************************************************************
///  以下为待整理方法 
/// ********************************************************************************************************
/// 
/// 待整理
/// 
/// 取所有医嘱， 整理 
/// 根据处方打印类方法，取出中药处方中的所有药物，拼成标准的中药处方格式并返回字符串
/// add for KuanJie ZhongYiYuan to fetch order infomation 2007-9-4
/// arguments:
/// argStartDate, argEndDate format: YYYY-MM-DD
/// argOrdCategory: "化验", "中草药", ...
/// argNeedFormat: "1"--true, "0"--false
/// ORW(OE_OrdItem RowId)->ARC_ItmMast->ARC_ItemCat->OEC_OrderCategory
/// select OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrdCat_DR->ORCAT_Desc from OE_OrdItem
/// select OEORI_ItmMast_DR->ARCIM_Desc from OE_OrdItem  :  order name
/// usage: w ##class(EPRservice.HISInterface.PatientInfoAssist).TempOrders(1,"2007-7-10","2007-7-10","中草药","1")
/// change: 2007-9-12 by gjb -- add frequency and duration
ClassMethod GetOrders(argAdmId As %String, argStartDate As %String, argEndDate As %String, argOrdCategory As %String, argNeedFormat As %String) As %String
{
 //EPR> 接医嘱大类取医嘱明细
 n
 s sdate=$zdh(argStartDate,3),edate=$zdh(argEndDate,3)
 //b
 s result=""
 // Create a Result object for the Sample.Person:ByName query
 Set rset = ##class(%ResultSet).%New("web.DHCTEMPOERPRINT:GetTempOrd")

 // Execute the query
 // by wwt Set sc = rset.Execute(argAdmId,sdate,edate)
 Set sc = rset.Execute(argAdmId,sdate,edate,,,"3879",,0,1)
 s usage="",i=1,newOrderSet=0 //i: counter// newOrderSet: if it is a new order set, tell by "   _____", the 1st order in a order set without "   _____"
 // Now fetch the results
 While (rset.Next()) {
   s orderCategory="",orditemrowid=rset.Data("ORW")
   
   ///get frequency and duration-----------------
   s oeorderRowid="",orditemSub="",freq="",duration=""
   s oeorderRowid=$p(orditemrowid,"||",1)
   s orditemSub=$p(orditemrowid,"||",2)
   s freq=$p($g(^OEORD(oeorderRowid,"I",orditemSub,2)),"^",4)
   if (freq'="") {s freq=$p($g(^PHCFR(freq)),"^",3)}
   s duration=$p($g(^OEORD(oeorderRowid,"I",orditemSub,2)),"^",6)
   if (duration'="") {s duration=$p($g(^PHCDU(duration)),"^",3)}
   ///-----------------get frequency and duration
   
   k SQLCODE
   ///get order category description
   &sql(select OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrdCat_DR->ORCAT_Desc into :orderCategory from SQLUser.OE_OrdItem where OEORI_RowId=:orditemrowid)
   q:(SQLCODE'=0)
   
   if (orderCategory=argOrdCategory) {
	 	 s ordDesc=rset.Data("ARCIMDesc")_" "_freq
	 	 if (argNeedFormat="1") 
	 	 {
		 	 ///get order desc, set value of newOrderSet
		 	 if ($f(ordDesc,"   _____")>2) {s ordDesc=$p(ordDesc,"   _____",2),newOrderSet=0}
		 	 else {s newOrderSet=1}
		 	 ///get usage from 1st order of a order set
		 	 if (usage="")||(newOrderSet=1) {s usage=duration_" "_$p(ordDesc," ",4)}
		 	 ///get herb order desc
		 	 s ordDesc=$p(ordDesc," ",1)_$p(ordDesc," ",2)_$p(ordDesc," ",3)
		 	 ///new order set add a empty line
		 	 if (newOrderSet=1) {s result=result_$c(13)_$c(10)_$c(13)_$c(10)}
		 	 ///4 herbs a line
		 	 if (i#4=0) {s result=result_ordDesc_$c(13)_$c(10)}
		 	 else {s result=result_ordDesc_"  "}
		 }
		 ///not herb order
 	 	 else 
 	 	    {
	 	 	    //s result=result_ordDesc_$c(13)_$c(10)
	 	 	    s result=result_$tr(ordDesc," " )_" , "
	 	 	    //s result=result_$tr($p(ordDesc,"(",1)," " )_" , "
	 	 	 
	 	 	}
 	 	 s i=i+1
 	 }
 }
 Do rset.Close()
 q usage_result
}

/// Desc: 按医嘱优先级取医嘱明细
/// Input: argAdmId:就诊rowid
/// argPriorityDesc:医嘱优先级描述(即刻医嘱，临时医嘱，长期医嘱，出院带药，自备药即刻，自备药长期),空值表示取所有
/// argStDate:起始日期，Cache内部格式，若为空表示取所有
/// argEndDate：结束日期，Cache内部格式，若为空表示取所有
/// Debug: w ##class(EPRservice.HISInterface.PatientInfoAssist).GetOrdersByPriority("56","临时医嘱")
ClassMethod GetOrdersByPriority(argAdmId As %String, argPriorityDesc As %String, argStDate As %String = "", argEndDate As %String = "") As %String
{
	q:($d(argAdmId)=0)||(argAdmId="") ""
	s retVal = ""
	
	//医嘱名称，包装总量，包装单位，用法，单次计量，单次计量单位，频次,医嘱备注
	s (OrderName,PackQty,PackUOM,Useage,DoseQty,DoseUOM,Frequcy,OrderDepProcNote) = ""
	
	//转换医嘱优先级描述
	s priorityId = "ALL"
	if (argPriorityDesc '= "")
	{
	//s priorityId = ^OECPR(0,"Desc",argPriorityDesc,"")
	s tmpid=""
	&sql(select OECPR_RowId into :tmpid from SQLUser.OEC_Priority
	where OECPR_Desc = :argPriorityDesc)
	if (tmpid '= "") s priorityId = tmpid
	}
	
	q:(priorityId="")
	
	//取医嘱表[OE_Order]的rowid
	s oeordId = $O(^OEORD(0,"Adm",argAdmId,""))
	q:(oeordId="") ""
	
	//遍历医嘱项表[OE_OrdItem]
	s oeoriSub = 0
	for {
	s oeoriSub = $O(^OEORD(oeordId,"I",oeoriSub))
	q:(oeoriSub="")
	
	//医嘱日期是否满足条件[OE_OrdItem.OEORI_Date]
	s oeoriDate = $P($G(^OEORD(oeordId,"I",oeoriSub,3)),"^",7)
	if ((argStDate'="")&&(argEndDate'="")&&((oeoriDate<argStDate)||(oeoriDate>argEndDate)))
	{ continue}
	
	//医嘱优先级类别是否满足条件
	if (priorityId '= "ALL")
	{
	s oeoriPriorityDR = $P($G(^OEORD(oeordId,"I",oeoriSub,1)),"^",8)
	if (priorityId '= oeoriPriorityDR) continue
	}
	
	//医嘱是否执行 
	/*
	s itemStatDR = $P($G(^OEORD(oeordId,"I",oeoriSub,1)),"^",13)
	if (itemStatDR = "") continue
	s statCode = $P($G(^OEC("OSTAT",itemStatDR)),"^",1)
	if (statCode '= "V")&&(statCode '= "E") continue 
	*/
	//取医嘱明细
	//PHCFR_Desc1 英文频次
	//PHCFR_Desc2 中文频次
	s oeoriRowid = oeordId_"||"_oeoriSub, OrderName=""
	&sql(SELECT OEORI_ItmMast_DR->ARCIM_Desc,OEORI_QtyPackUOM,
	OEORI_ItmMast_DR->ARCIM_BillingUOM_DR->CTUOM_Desc,OEORI_Instr_DR->PHCIN_Desc2,
	OEORI_DoseQty,OEORI_Unit_DR->CTUOM_Desc,
	OEORI_PHFreq_DR->PHCFR_Desc2
	INTO :OrderName,:PackQty,:PackUOM,:Useage,:DoseQty,:DoseUOM,:Frequcy
	From SQLUser.OE_OrdItem
	WHERE OEORI_Rowid = :oeoriRowid)
	
	//格式如下：
	//[医嘱名称] X [总量][总理单位] / [用法] [单次计量] [单次计量单位] [频次]
	//氯化钠注射液 ([0.9%100ml]) X 15瓶 / 静脉滴注 每次100ml Q8h
	s OrderDepProcNote=$g(^OEORD(oeordId,"I",oeoriSub,"DEP",1))
	if ($g(OrderDepProcNote)'="")
	{
		s tmpValue = OrderName_" X "_PackQty_PackUOM_" / "_Useage_" "_DoseQty_" "_DoseUOM_" "_Frequcy_" ("_OrderDepProcNote_")"
	}
	else
	{
		s tmpValue = OrderName_" X "_PackQty_PackUOM_" / "_Useage_" "_DoseQty_" "_DoseUOM_" "_Frequcy
	}
	if retVal=""
	{ s retVal = tmpValue}
	else
	{ s retVal = retVal_$c(13)_tmpValue}
	
	}
	
	q retVal
	
	/* 医生工作站相关的方法报错
	//取所有医嘱明细
	//web.DHCOEOrdItem:GetOrderItems 的返回值如下：
	//"Rowid:%String,OrderName:%String,StartDate:%String,Priority:%String,Status:%String,PackQty:%
	
	String,PackUOM:%String,Price:%String,Sum:%String,RecDep:%String,Billed:%String,BillType:%
	
	String,OrderType:%String,Spec:%String,UserAddName:%String,LabEpisodeNo:%String,orcat:%
	
	String,orcatdesc:%String,RecDepAdress,DepProcNotes:%String,StatusCode:%String,ExecuteTime:%String")
	s rs = ##class(%ResultSet).%New("web.DHCOEOrdItem:GetOrderItems")
	s sc = rs.Execute(argAdmId,"0")
	q:(sc'=1) ""
	
	//遍历所有医嘱，取满足医嘱优先级条件的医嘱
	while (rs.Next())
	{
	//是否满足医嘱优先级要求
	s priority = rs.Data("Priority")
	if (priority '= argPriorityDesc) continue
	
	//是否满足时间要求
	if (argStDate '= "")&&(argEndDate '= "")
	{
	s sttDate = rs.Data("StartDate")
	if (sttDate = "") continue
	if ($zdh(sttDate,3) < argStDate) continue
	if ($zdh(sttDate,3) > argEndDate) continue
	}
	
	s orderName = rs.Data("OrderName")
	if retVal=""
	{ s retVal = orderName}
	else
	{ s retVal = retVal_$c(13,10)_orderName}
	}
	
	q retVal
	*/
}

/// Creator:	wangwentao
/// CreatDate:	20090606
/// Description:获取诊断信息
/// Table:		/
/// Input:		西医诊断(argTypeId=1) 中医诊断(argTypeId=2) 中医辩证(argTypeId=3) 全部诊断(argTypeId="")
/// 				argDiagCode {RowID,ICD10}
/// Output:		/
/// Return:		/
/// Others:		SQL MR_Diagnos
/// 				^MR(argAdmId,"DIA",0)
/// 				^MR({MR_Adm.MRADM_RowId},"DIA",{MRDIA_Childsub})
/// 				MRDIA_SignSym_DR   note 10  中医辨证 BJZYYY  -> Table is  MRC_DiagnosSignSymptom 
/// 				Table is  MRC_DiagnosSignSymptom ^MRC("DSYM",{DSYM_RowId}) 	
/// 				SQL MRC_ICDDx
/// 				^MRC("ID",{MRCID_RowId})    Table is  MRC_ICDDx 
/// 				MRCID_ICD9CM_Code  note 4
/// 				MRCID_Desc_        note 2
/// 				MRCID_BillFlag3    note 15  区别 中医诊断 西医诊断
/// 				如果诊断备注diagnote不为空，则取诊断备注信息
/// 				SQLUser.MR_Diagtype
/// 				SQLUser.MRC_DiagnosType
/// 				SQLUser.MR_Diagnos
/// 				SQLUser.DHC_MRDiagnos
/// Example:		
ClassMethod GetDiagnos(argAdmId As %String, argTypeId As %String = "", argDiagCode As %String = "RowID") As %String
{
	//通过argAdmId 取PAADM_MainMRADM_DR
	s MRAdmId="" 
	s MRAdmId=$p($g(^PAADM(argAdmId)),"^",61)

	q:($d(argAdmId)=0)||(argAdmId="") ""
	q:(MRAdmId="") ""
	q:($d(^MR(MRAdmId,"DIA"))'=10) ""
	s diagstr="",diagstr2="",diagstr3="",diag="",diagdesc="",diagcode="",diagnote="",diagDR="",diagsub="0",diagflag="",diagsymDR=""
	
	f  s diagsub=$o(^MR(MRAdmId,"DIA",diagsub)) q:diagsub=""  d
	. s diagDR=$p($g(^MR(MRAdmId,"DIA",diagsub)),"^",1)
	. s diagsymDR=$p($g(^MR(MRAdmId,"DIA",diagsub)),"^",10)
	. //兼容仅写诊断备注不选择诊断库的情况 并修改diagdesc diagflag取值
	. //q:(diagDR="")
	. //兼容diagcode取ICD10或RowID
	. s:($ZCVT(argDiagCode,"U")="ICD10") diagcode=$s(diagDR'="":$p($g(^MRC("ID",diagDR)),"^",4),1:"")
	. s:($ZCVT(argDiagCode,"U")="ROWID") diagcode=$s(diagDR'="":diagDR,1:"")
	. s diagdesc=$s(diagDR'="":$p($g(^MRC("ID",diagDR)),"^",2),1:"")
	. s diagflag=$s(diagDR'="":$p($g(^MRC("ID",diagDR)),"^",15),1:"")
	. //
	. s diagnote=$g(^MR(MRAdmId,"DIA",diagsub,"DES",1))
	. i diagflag'="Y" d
	. . i diagnote'="" d
	. . . s diag=diagcode_"^"_diagdesc_"("_diagnote_")"_"!"
	. . e  d  
	. . . s diag=diagcode_"^"_diagdesc_"!" 
	. . s diagstr=diagstr_diag
	. e  d 
	. . i diagsymDR'="" d
	. . . s diagsym=$p($g(^MRC("DSYM",diagsymDR)),"^",1)_"^"_$p($g(^MRC("DSYM",diagsymDR)),"^",2)_"!" 
	. . . s diagstr3=diagstr3_diagsym
	. . i diagnote'="" d  
	. . . s diag=diagcode_"^"_diagdesc_"("_diagnote_")"_"!"
	. . e  d  
	. . . s diag=diagcode_"^"_diagdesc_"!" 
	. . s diagstr2=diagstr2_diag
	
	// WM
	if argTypeId="1"
	{
		s diagstr=diagstr
	}
	// TCM
	elseif argTypeId="2"
	{
		s diagstr=diagstr2
		s diagstr=..CheckRepeatDiag(argAdmId,diagstr)
	}
	// SYM
	elseif argTypeId="3"
	{
		s diagstr=diagstr3
	}
	// ALL
	else 
	{
		s diagstr=diagstr_diagstr2
	}
	
	q diagstr
}

/// ##Class(EPRservice.TestAndTools.DevTest).CheckRepeat()
ClassMethod CheckRepeatDiag(argAdmId As %String, argDiagStr As %String) As %String
{

	q:($d(argAdmId)=0)||(argAdmId="") ""
	q:($d(argDiagStr)=0)||(argDiagStr="") ""
	
	
	s DiagStr="",Diag="",DiagNo=""
	
	s tmpDiagStr=argDiagStr,Adm=argAdmId
	
	s tmpNode="",i=""
	
	
	k ^CacheTempDHCEPRDebug("CheckRepeat",Adm,"DIA")
	
	if tmpDiagStr'=""
	{
		//s diagcount=$l(DiagString,"!")-1
		s diagcount=$l(tmpDiagStr,"!")
		f i=1:1:diagcount 
		{
			//b "s"
			s tmpDiag=$p($g(tmpDiagStr),"!",i)
			if tmpDiag'=""
			{
				if $d(^CacheTempDHCEPRDebug("CheckRepeat",Adm,"TMPDIA",tmpDiag))'=1
				{
					s ^CacheTempDHCEPRDebug("CheckRepeat",Adm,"TMPDIA",tmpDiag)=i_"#"_tmpDiag
				}
			}
		}
		
		
		f i=1:1:diagcount 
		{
			//b "s"
			s tmpDiag=$p($g(tmpDiagStr),"!",i)
			if tmpDiag'=""
			{
				s DiagNo=$p($g(^CacheTempDHCEPRDebug("CheckRepeat",Adm,"TMPDIA",tmpDiag)),"#",1)
				s Diag=$p($g(^CacheTempDHCEPRDebug("CheckRepeat",Adm,"TMPDIA",tmpDiag)),"#",2)
				
				
				if $d(^CacheTempDHCEPRDebug("CheckRepeat",Adm,"DIA",DiagNo))'=1
				{
					s ^CacheTempDHCEPRDebug("CheckRepeat",Adm,"DIA",DiagNo)=Diag
				}
			}
		}

		 f  s tmpNode=$o(^CacheTempDHCEPRDebug("CheckRepeat",Adm,"DIA",tmpNode)) quit:tmpNode=""  d
		 . s Diag=$g(^CacheTempDHCEPRDebug("CheckRepeat",Adm,"DIA",tmpNode))_"!"
		 . s DiagStr=DiagStr_Diag
		 
	
		 k ^CacheTempDHCEPRDebug("CheckRepeat",Adm,"TMPDIA")
		 k ^CacheTempDHCEPRDebug("CheckRepeat",Adm,"DIA")

	}
	
	q DiagStr
}

/// Desc:	是否尸检
/// Output：1-exam, 0-not exam 
ClassMethod HadCadaverExam(argMrAdmId As %String, argHospital As %String, argMeddata As %String) As %String
{
	//return value 1-exam, 0-not exam 尸检
	q:($d(argMrAdmId)=0)||($d(argHospital)=0)||($d(argMeddata)=0)||(argMrAdmId="")||(argHospital="")||(argMeddata="") 0
	if argHospital=..#HospitalBJAZYY {
		s space = $zu(5)
		s exam="-"
		d $zu(5,argMeddata)
		if (($d(^MR(argMrAdmId,"PRO",1))'=1)&&($d(^MR(argMrAdmId,"PRO",1))'=11)) 
		{
			d $zu(5, space)
			q ..#Hadnot
		}
		s exam=$P($g(^MR(argMrAdmId,"PRO",1)),"^",47)
		if exam'="" {s exam=$p($g(^PAC("AUTOP",exam)),"^",2)}
		d $zu(5, space)
		q:(exam="X") "-"
		q:(exam="") "-"
		q exam
	}
}

/// 这个方法是什么？？？
/// 这个方法是什么？？？出院病区（工作量）
ClassMethod DisWardGZL(argAdmId As %String, argMedata As %String, argEPR As %String) As %String
{
	q:($d(argAdmId)=0)||(argAdmId="") ""
	d $zu(5,argMedata)
	if '$d(^DHCMRIPDetail(0,"TYPE","CYRS","ADM",argAdmId)) 
	{
		d $zu(5,argEPR)
		q ""
	}
 	s iprowid=0 
 	s DisLoc=""
 	for {
	  s iprowid=$o(^DHCMRIPDetail(0,"TYPE","CYRS","ADM",argAdmId,iprowid)) 
	  q:(iprowid="")
	  s MRIPDayDr=$p($g(^DHCMRIPDetail(iprowid)),"^",3)
	  continue:(MRIPDayDr="")
	  continue:('$d(^MRIPdaily(MRIPDayDr)))
	  if (DisLoc=""){s DisLoc=$p($g(^MRIPdaily(MRIPDayDr)),"^",19)}
 	}
 	
 	s WardDesc=""
 	if DisLoc'=""{
		s WardCode=$p($g(^PAWARD(DisLoc)),"^",1)
		s WardDesc=$p($g(^PAWARD(DisLoc)),"^",2)
		if $l(WardDesc,"-")>1 {s WardDesc=$p(WardDesc,"-",2)}
 	}
 	
 	d $zu(5,argEPR)
 	q WardDesc
}

ClassMethod InstanceCount(argEpisodeID As %String, argCategoryID As %String) As %String
{
	//q:($d(argCategoryID)=0)||($d(argEpisodeID)=0)||(argCategoryID="")||(argEpisodeID="") ""
	
	s InstanceCount=""
	s parEpisodeID=" "_argEpisodeID
	s parCategoryID=" "_argCategoryID
	s TheEcrecordIndex="0"
	s TheEcrecordIndex= $O(^DHCEPRI.ECRecordI("IdxEpisodeIDCategoryID",parEpisodeID,parCategoryID,""))
	q:(TheEcrecordIndex="") ""
	s objInstanceData=##Class(EPRinstance.ECRecord).%OpenId(TheEcrecordIndex)
	s InstanceCount=objInstanceData.InstanceCount
	
	//w "wang:",!,InstanceCount
	
	q InstanceCount
}

/// 取西医诊断:
/// 华西医院，待整理
ClassMethod GetDiagXYByAdm(AdmID As %String, TYPID As %String) As %String
{

	//^MR(argAdmId,"DIA",0)  //参数为“1”取ALL诊断  //参数为“2”时取出院诊断
	//^MR({MR_Adm.MRADM_RowId},"DIA",{MRDIA_Childsub})
	//^MRC("ID",{MRCID_RowId})    -->  MRC_ICDDx 
	//^MRC("DTYP",1) = "DIS^出院诊断^N" 
	//MRCID_ICD9CM_Code  note 4
	//MRCID_Desc_        note 2
	//^MR(MR_Adm,"DIA",MRDIA_Childsub,"TYP",MRDIA_Childsub) = 3(诊断类型) 
	// s MRDIAChildsub=$o(^MR(+MRadm,"DIA",Childsub,"TYP",MRDIAChildsub)) q:(MRDIAChildsub="")
	//	10:  ^MRC("DTYP",1) = "DIS^出院诊断^N" 
	//	11:  ^MRC("DTYP",2) = "M^主诊断^N" 
	//	12:  ^MRC("DTYP",3) = "PRE^入院前诊断^N" 
	//	13:  ^MRC("DTYP",4) = "C008^入院诊断^N" 
	if TYPID="1"
	 {
	 s MRadm=$p($g(^PAADM(AdmID)),"^",61) //指向MRADM,p7p8相同
	 s mrcicddxid="",MRCIDDesc="",MRCIDCode="",MRCICD9CMCode="",BillFlag=""
	 s Childsub=0 
	 f  s Childsub=$o(^MR(+MRadm,"DIA",Childsub)) q:(Childsub="")  d
	 .s mCurrRow=$g(^MR(MRadm,"DIA",Childsub))
	 .s mrcicddxid=$p($g(^MR(MRadm,"DIA",Childsub)),"^",1)
	 .i mrcicddxid'="" d
	 ..s BillFlag3=$p($g(^MRC("ID",mrcicddxid)),"^",15)
	 ..  d //q:BillFlag="Y"  d
	 ..s MRCIDCode=$p($g(^MRC("ID",mrcicddxid)),"^",1)
	 ..s MRCIDDesc=MRCIDDesc_","_$p($g(^MRC("ID",mrcicddxid)),"^",2)
	 ..s MRCICD9CMCode=$p($g(^MRC("ID",mrcicddxid)),"^",4)
	 .e  d
	 ..s MRCIDDesc=""
	 }
	 	if TYPID="2"
     {
	     s MRadm=$p($g(^PAADM(AdmID)),"^",61) //指向MRADM,p7p8相同
		 s mrcicddxid="",MRCIDDesc="",MRCIDCode="",MRCICD9CMCode="",BillFlag=""
		 s Childsub=0 ,TYPChildsub=0
		 f  s Childsub=$o(^MR(+MRadm,"DIA",Childsub)) q:(Childsub="")  d
		 .s mCurrRow=$g(^MR(MRadm,"DIA",Childsub))
		 .//s ^xuefl("TYPChildsub",AdmID,Childsub)="AdmID:"_AdmID_"  Childsub:"_Childsub_"   MRadm:"_MRadm
		 .q:(TYPChildsub="")
		 .//s ^xuefl("TYPChildsub",TYPChildsub)=TYPChildsub
		 .s MRDIAChildsub=$g(^MR(+MRadm,"DIA",Childsub,"TYP",TYPChildsub))
		 .q:(TYPChildsub="")
		 .//s ^xuefl("TYPChildsub",TYPChildsub)=MRDIAChildsub
		 .s MRDIAChildsub=$g(^MR(MRadm,"DIA",Childsub,"TYP",TYPChildsub))
		 .//s ^xuefl("MRDIAChildsub",MRDIAChildsub)=MRDIAChildsub
		 .Q:(MRDIAChildsub'=1)
		 .s mrcicddxid=$p($g(^MR(MRadm,"DIA",Childsub)),"^",1)
		 .i mrcicddxid'="" d
		 ..s BillFlag3=$p($g(^MRC("ID",mrcicddxid)),"^",15)
		 ..  d //q:BillFlag="Y"  d
		 ..s MRCIDCode=$p($g(^MRC("ID",mrcicddxid)),"^",1)
		 ..s MRCIDDesc=MRCIDDesc_","_$p($g(^MRC("ID",mrcicddxid)),"^",2)
		 ..s MRCICD9CMCode=$p($g(^MRC("ID",mrcicddxid)),"^",4)
		 .e  d
		 ..s MRCIDDesc=""
     }   
	 //W mrcicddxid_"^"_MRCIDCode_"^"_MRCIDDesc_"^"_MRCICD9CMCode_"^"_MRadm_"^  Childsub:"_Childsub 
	 q MRCIDDesc  ////mrcicddxid_"!"_MRCIDCode_"!"_
}

/// query的参数TYPE=1是抗生素，TYPE=2是手术
/// 返回值：
/// "OrderName:%String,StartDate:%String,EndDate:%String,DoseQty:%String,CTUOMDesc:%String,PHCFRDesc:%String,PHCINDesc:%String")
/// 医嘱名称，			开始日期，		结束日期		  单次计量			计量单位		频次				用法
Query FindOrderItems(EpisodeID As %String, TYPE As %String = "") As %Library.Query(CONTAINID = "", ROWSPEC = "OrderName:%String,StartDate:%String,EndDate:%String,DoseQty:%String,CTUOMDesc:%String,PHCFRDesc:%String,PHCINDesc:%String")
{
}

ClassMethod FindOrderItemsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOrderItemsExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod FindOrderItemsExecute(ByRef qHandle As %Binary, EpisodeID As %String, TYPE As %String = "") As %Status
{
 Set repid=$I(^CacheTemp)
 If $g(ind)="" Set ind=1
 
 do ResetVariables5
 if EpisodeID'="" {
	 set PAADMType=$p($g(^PAADM(EpisodeID)),"^",2)
	 //s PatType=$P(^PAADM(EpisodeID,1),"^",6)  //PAADM_Epissubtype_DR
	 s PatType=$P(^PAADM(EpisodeID),"^",2)
	 if PAADMType="I"{
	 &SQL(DECLARE OrdCursor CURSOR FOR 
	 SELECT OEORI_Rowid,OEORI_ItmMast_DR,OEORI_ItmMast_DR->ARCIM_Desc,OEORI_SttDat,
	 OEORI_SttTim,Todate(OEORI_SttDat,'yyyy-mm-dd'),OEORI_ItemStat_DR->OSTAT_Code,
	 OEORI_Priority_dr->OECPR_Code,OEORI_UserDepartment_DR,
	 OEORI_DoseQty,OEORI_UNIT_DR->CTUOM_Desc,oeori_PHFreq_dr->PHCFR_Desc1,OEORI_instr_dr->PHCIN_Desc1
	 INTO :OrderItemRowid,:ARCIMRowid,:OrderName,:OrderSttDate,:OrderSttTime,
	 	  :StartDate,:StatusCode,:PriorCode,:UserDepartmentDR,
	 	  :DoseQty,:CTUOMDesc,:PHCFRDesc,:PHCINDesc
	 From SQLUser.OE_OrdItem
	 WHERE OEORI_OEORD_PARREF->OEORD_ADM_DR=:EpisodeID
	 Order By OEORI_SttDat desc)
	 
	 &SQL(OPEN OrdCursor)
	 For  &SQL(FETCH OrdCursor) QUIT:SQLCODE  do
	    . //手术没有长期医嘱
	 	. Q:(TYPE=2)&&((PriorCode="S")!(PriorCode="OMST"))
	 	. Q:((PriorCode="S")!(PriorCode="OMST"))&(StatusCode'="D")
	 	. i ((PriorCode="S")!(PriorCode="OMST"))&(StatusCode="D") d  q
	 	. . s FirstOrderItemRowId=$$getFirstOrderItemRowId(OrderItemRowid)
	 	. . i FirstOrderItemRowId'="" d 
	 	. . . s EndDate=$p($g(^OEORD(+OrderItemRowid,"I",$p(OrderItemRowid,"||",2),3)),"^",7)
	 	. . . s EndDate=$ZD(EndDate,3)
	 	. . . s StartDate=$p($g(^OEORD(+FirstOrderItemRowId,"I",$p(FirstOrderItemRowId,"||",2),1)),"^",9)
	 	. . . s StartDate=$ZD(StartDate,3)
		. . . s PHPrescType=$$GetPHPrescType(OrderItemRowid)
		. . . i (PHPrescType="7") d OutputRow5
	 	. Q:(StatusCode="D")
		. s billed=$p($g(^OEORD(+OrderItemRowid,"I",$p(OrderItemRowid,"||",2),3)),"^",5)
		. s subcat=$p($g(^ARCIM(+ARCIMRowid,1,1)),"^",10)
		. s orcat=$p($g(^ARC("IC",+subcat)),"^",8)
		. s PHPrescType=$$GetPHPrescType(OrderItemRowid)
		. s EndDate=StartDate
		. Q:(TYPE=1)&&(PHPrescType'="7")
		. Q:(TYPE=2)&&(((orcat'="58")&&(orcat'="17")&&(orcat'="33"))||(UserDepartmentDR'=103))
		. d OutputRow5
	 }
	 &SQL(CLOSE OrdCursor)
 }

 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
 
 
OutputRow5
 s Data=$lb(OrderName,StartDate,EndDate,DoseQty,CTUOMDesc,PHCFRDesc,PHCINDesc)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
ResetVariables5
 set (OrderName,StartDate,EndDate)=""
 Quit
GetPHPrescType(row)
    Q:row="" ""
	S ArcimRowid=$p(^OEORD(+row,"I",$P(row,"||",2),1),"^",2)
	s CNMedAppendItemRowid=$$getconfignode("CNMedAppendItem")
	//如果是附加材料则算成中草药
	Q:CNMedAppendItemRowid=ArcimRowid "3"
	s ItemCatRowid=$p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1)),"^",10)
	Q:ItemCatRowid="" ""
	s ItemType=""
	s PoisonRowid=$$GetDrgFormPoison(ArcimRowid)
	s PoisonCode=""
	i PoisonRowid'="" {
	s PoisonCode=$P(^PHCPO(PoisonRowid),"^",1)
	//精神一类
	if PoisonCode="J1" s ItemType="6"
	//精神二类
	if PoisonCode="J2" s ItemType="5"
	//抗生素
	if PoisonCode="KSS" s ItemType="7"
	if PoisonCode="DM" s ItemType="8"
	if ItemType'="" Q ItemType
	}
	s CNMedItemCat=$$getconfignode("CNMedItemCat")
	i "^"_CNMedItemCat_"^"[("^"_ItemCatRowid_"^") s ItemType="3"
	s MedItemCat=$$getconfignode("MedItemCat")
	i "^"_MedItemCat_"^"[("^"_ItemCatRowid_"^") s ItemType="1"
	s CPMedItemCat=$$getconfignode("CPMedItemCat")
	i "^"_CPMedItemCat_"^"[("^"_ItemCatRowid_"^") s ItemType="2"
	s CPMedItemCat=$$getconfignode("LimitMedItemCat")
	//精神二类药
	i "^"_CPMedItemCat_"^"[("^"_ItemCatRowid_"^") s ItemType="5"
	Q ItemType
GetDrgFormPoison(ARCIMRowid)
	//w $$GetDrgFormPoison^DHCDocOrderCommon("4859||1")
	n (ARCIMRowid)
	
	s DrgFormRowid=$p(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1),"^",12)
	i DrgFormRowid=-1 s DrgFormRowid=""
	Q:DrgFormRowid="" ""
	s DrgFormPoison=$p(^PHCD(+DrgFormRowid,1),"^",4)
	if DrgFormPoison=$C(0) s DrgFormPoison=""
	Q $g(DrgFormPoison)
getconfignode(node)
	q $g(^DHCDocConfig(node))
getFirstOrderItemRowId(row)
	s FillerNo=""
	s FillerNo=$P($G(^OEORD(+row,"I",$P(row,"||",2),9)),"^",12)
	i FillerNo'="" s FirstOrderItemRowId= $P(FillerNo,"!!",1)
	Q $G(FirstOrderItemRowId)
}

ClassMethod FindOrderItemsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOrderItemsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
	Set AtEnd=1
	Set Row=""
	}
	Else      {				// fetch row
	Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:	wangwentao
/// CreatDate:	20090701
/// Description:获取医嘱项目通过医嘱项字串
/// Table:		/
/// Input:		argAdmId是病人就诊ID[PA_Adm表RowID]// argItemString是医嘱项ID[ARC_ItmMast表RowID]// argHospital是医院标识
/// 			特殊说明： argItemString字串结构是 2903||1^2904||1^2905||1^2902||1^2901||1 即 一级护理^二级护理^三级护理^特级护理^重症监护
/// Output:		/
/// Return:		CurrentOrdItem
/// Others:		&sql(select top 1 * from OE_OrdItem where oeori_oeord_parref ='50594' and OEORI_ItmMast_DR -> arcim_itemcat_dr = '217' and OEORI_ItemStat_DR <>'4' )
/// 			OE_OrdItem	^OEORD({OE_Order.OEORD_RowId},"I",{OEORI_Childsub}) 
/// 			OE_Order		^OEORD(0,"Adm",{OEORD_Adm_DR},{OEORD_RowId})
/// 			[ARC_ItmMast]OE_OrdItem.OEORI_ItmMast_DR->[ARC_ItemCat]ARC_ItmMast.ARCIM_ItemCat_DR				
/// 			[ARC_ItmMast.ARCIM_ItemCat_DR	1	10]^ARCIM({ARCIM_Subscript},{ARCIM_Version}) 
/// 			[ARC_ItmMast.ARCIM_Desc	    1	2] ^ARCIM({ARCIM_Subscript},{ARCIM_Version}) 
/// 			[OE_OrdItem.OEORI_ItemStat_DR	1	13]^OEORD({OE_Order.OEORD_RowId},"I",{OEORI_Childsub})  
/// 			长春妇产医院 一级护理=2903||1 二级护理=2904||1 三级护理=2905||1 特级护理=2902||1 重症监护=2901||1	
/// Example:	w ##Class(EPRservice.HISInterface.PatientInfoAssist).GetOrderByOrdItem(171380,"^2903||1^2904||1^2905||1^2902||1^2901||1^","CCFCYY")
ClassMethod GetOrderByOrdItem(argAdmId As %String, argItemString As %String, argHospital As %String = "") As %String
{
	
	//完整性判断
	q:($d(argAdmId)=0)||(argAdmId="") ""
	q:($d(argItemString)=0)||(argItemString="") ""
	q:($l(argItemString,"^")>1) ""
	
	//定义返回值
	s CurrentOrdItem=""
	
	//定义变量
	s OEORDRowId="",OEORIChdsub="",OEORIItmMastDR="",OEORIItmMastDRsub="",ARCIMItemCatDR="",OEORIItemStatDR="",ARCIMDesc=""
	
	//程序处理
    f  s OEORDRowId=$o(^OEORD(0,"Adm",argAdmId,OEORDRowId)) q:((OEORDRowId="")||(CurrentOrdItem'=""))  d
    . //Get Max OEORIChdsub Add 1
    . s OEORIChdsub=$g(^OEORD(OEORDRowId,"I",0))+1
	. f  s OEORIChdsub=$o(^OEORD(OEORDRowId,"I",OEORIChdsub),-1) q:((OEORIChdsub="")||(CurrentOrdItem'=""))  d  
	  .. //Get OE_OrdItem.OEORI_ItmMast_DR[ARC_ItmMast]
	  .. s OEORIItmMastDR= $p($g(^OEORD(OEORDRowId,"I",OEORIChdsub,1)),"^",2)
	  .. q:(OEORIItmMastDR="")
	  .. s OEORIItmMastDRsub=$p(OEORIItmMastDR,"||",1)
	  .. //Check OE_OrdItem.OEORI_ItmMast_DR[ARC_ItmMast] 
	  .. q:($f(argItemString,OEORIItmMastDR)=0)
	  .. //Get OE_OrdItem.OEORI_ItemStat_DR[OEC_OrderStatus]
	  .. s OEORIItemStatDR=$p($g(^OEORD(OEORDRowId,"I",OEORIChdsub,1)),"^",13)
	  .. q:(OEORIItemStatDR=4)
	  .. s ARCIMDesc=$p($g(^ARCIM(OEORIItmMastDRsub,1,1)),"^",2)
	  .. s CurrentOrdItem=ARCIMDesc
	
	
	//返回当前医嘱项
	q CurrentOrdItem
}

/// Creator:	wangwentao
/// CreatDate:	20090701
/// Description:获取医嘱项目通过医嘱子类
/// Table:		/
/// Input:		argAdmId是病人就诊ID[PA_Adm表RowID]// argCategory是医嘱子类ID[ARC_ItemCat表RowID]// argHospital是医院标识
/// Output:		/
/// Return:		CurrentOrdItem
/// Others:		&sql(select top 1 * from OE_OrdItem where oeori_oeord_parref ='50594' and OEORI_ItmMast_DR -> arcim_itemcat_dr = '217' and OEORI_ItemStat_DR <>'4' )
/// 			OE_OrdItem	^OEORD({OE_Order.OEORD_RowId},"I",{OEORI_Childsub}) 
/// 			OE_Order		^OEORD(0,"Adm",{OEORD_Adm_DR},{OEORD_RowId})
/// 			[ARC_ItmMast]OE_OrdItem.OEORI_ItmMast_DR->[ARC_ItemCat]ARC_ItmMast.ARCIM_ItemCat_DR				
/// 			[ARC_ItmMast.ARCIM_ItemCat_DR	1	10]^ARCIM({ARCIM_Subscript},{ARCIM_Version}) 
/// 			[ARC_ItmMast.ARCIM_Desc	    1	2] ^ARCIM({ARCIM_Subscript},{ARCIM_Version}) 
/// 			[OE_OrdItem.OEORI_ItemStat_DR	1	13]^OEORD({OE_Order.OEORD_RowId},"I",{OEORI_Childsub})  
/// 			长春妇产医院	护理=47 膳食=49				
/// Example:	w ##Class(EPRservice.HISInterface.PatientInfoAssist).GetOrderByItemCat(171380,47,"CCFCYY")
ClassMethod GetOrderByItemCat(argAdmId As %String, argCategory As %String, argHospital As %String = "") As %String
{
	
	//完整性判断
	q:($d(argAdmId)=0)||(argAdmId="") ""
	q:($d(argCategory)=0)||(argCategory="") ""

	
	//定义返回值
	s CurrentOrdItem=""
	
	//定义变量
	s OEORDRowId="",OEORIChdsub="",OEORIItmMastDR="",OEORIItmMastDRsub="",ARCIMItemCatDR="",OEORIItemStatDR="",ARCIMDesc=""
	
	//程序处理
    f  s OEORDRowId=$o(^OEORD(0,"Adm",argAdmId,OEORDRowId)) q:((OEORDRowId="")||(CurrentOrdItem'=""))  d
    . //Get Max OEORIChdsub Add 1
    . s OEORIChdsub=$g(^OEORD(OEORDRowId,"I",0))+1
	. f  s OEORIChdsub=$o(^OEORD(OEORDRowId,"I",OEORIChdsub),-1) q:((OEORIChdsub="")||(CurrentOrdItem'=""))  d  
	  .. //Get OE_OrdItem.OEORI_ItmMast_DR[ARC_ItmMast]
	  .. s OEORIItmMastDR= $p($g(^OEORD(OEORDRowId,"I",OEORIChdsub,1)),"^",2)
	  .. q:(OEORIItmMastDR="")
	  .. s OEORIItmMastDRsub=$p(OEORIItmMastDR,"||",1)
	  .. //Get OE_OrdItem.ARCIM_ItemCat_DR[ARC_ItemCat]
	  .. s ARCIMItemCatDR=$p($g(^ARCIM(OEORIItmMastDRsub,1,1)),"^",10)
	  .. q:(ARCIMItemCatDR'=argCategory)
	  .. //Get OE_OrdItem.OEORI_ItemStat_DR[OEC_OrderStatus]
	  .. s OEORIItemStatDR=$p($g(^OEORD(OEORDRowId,"I",OEORIChdsub,1)),"^",13)
	  .. q:(OEORIItemStatDR=4)
	  .. s ARCIMDesc=$p($g(^ARCIM(OEORIItmMastDRsub,1,1)),"^",2)
	  .. s CurrentOrdItem=ARCIMDesc
	
	
	//返回当前医嘱项
	q CurrentOrdItem
}

/// Creator:	wangwentao
/// CreatDate:	20090701
/// Description:获取医嘱项目通过医嘱大类
/// Table:		/
/// Input:		argAdmId是病人就诊ID[PA_Adm表RowID]// argCategory是医嘱大类ID[OEC_OrderCategory表RowID]// argHospital是医院标识
/// Output:		/
/// Return:		CurrentOrdItem
/// Others:		&sql(select top 1 * from OE_OrdItem where oeori_oeord_parref ='50594' and OEORI_ItmMast_DR -> arcim_itemcat_dr = '217' and OEORI_ItemStat_DR <>'4' )
/// 			OE_OrdItem	^OEORD({OE_Order.OEORD_RowId},"I",{OEORI_Childsub}) 
/// 			OE_Order		^OEORD(0,"Adm",{OEORD_Adm_DR},{OEORD_RowId})
/// 			[ARC_ItmMast]OE_OrdItem.OEORI_ItmMast_DR->[ARC_ItemCat]ARC_ItmMast.ARCIM_ItemCat_DR				
/// 			[ARC_ItmMast.ARCIM_ItemCat_DR	1	10]^ARCIM({ARCIM_Subscript},{ARCIM_Version}) 
/// 			[ARC_ItmMast.ARCIM_Desc	    1	2] ^ARCIM({ARCIM_Subscript},{ARCIM_Version}) 
/// 			[OE_OrdItem.OEORI_ItemStat_DR	1	13]^OEORD({OE_Order.OEORD_RowId},"I",{OEORI_Childsub})
/// 			[ARC_ItemCat.ARCIC_OrdCat_DR    8     ]^ARC("IC",{ARCIC_RowId})  
/// Example:	w ##Class(EPRservice.HISInterface.PatientInfoAssist).GetOrderByOrdCat(171380,47,"CCFCYY")
ClassMethod GetOrderByOrdCat(argAdmId As %String, argCategory As %String, argHospital As %String = "") As %String
{
	
	//完整性判断
	q:($d(argAdmId)=0)||(argAdmId="") ""
	q:($d(argCategory)=0)||(argCategory="") ""

	
	//定义返回值
	s CurrentOrdItem=""
	
	//定义变量
	s OEORDRowId="",OEORIChdsub="",OEORIItmMastDR="",OEORIItmMastDRsub="",ARCIMItemCatDR="",OEORIItemStatDR="",ARCIMDesc="",ARCICOrdCatDR=""
	
	//程序处理
    f  s OEORDRowId=$o(^OEORD(0,"Adm",argAdmId,OEORDRowId)) q:((OEORDRowId="")||(CurrentOrdItem'=""))  d
    . //Get Max OEORIChdsub Add 1
    . s OEORIChdsub=$g(^OEORD(OEORDRowId,"I",0))+1
	. f  s OEORIChdsub=$o(^OEORD(OEORDRowId,"I",OEORIChdsub),-1) q:((OEORIChdsub="")||(CurrentOrdItem'=""))  d  
	  .. //Get OE_OrdItem.OEORI_ItmMast_DR[ARC_ItmMast]
	  .. s OEORIItmMastDR= $p($g(^OEORD(OEORDRowId,"I",OEORIChdsub,1)),"^",2)
	  .. q:(OEORIItmMastDR="")
	  .. s OEORIItmMastDRsub=$p(OEORIItmMastDR,"||",1)
	  .. //Get OE_OrdItem.ARCIM_ItemCat_DR[ARC_ItemCat]
	  .. s ARCIMItemCatDR=$p($g(^ARCIM(OEORIItmMastDRsub,1,1)),"^",10)
	  .. q:(ARCIMItemCatDR="")
	  .. //Get ARC_ItemCat.ARCIC_OrdCat_DR[OEC_OrderCategory]
	  .. s ARCICOrdCatDR=$p($g(^ARC("IC",ARCIMItemCatDR)),"^",8) 
	  .. q:(ARCICOrdCatDR'=argCategory)
	  .. //Get OE_OrdItem.OEORI_ItemStat_DR[OEC_OrderStatus]
	  .. s OEORIItemStatDR=$p($g(^OEORD(OEORDRowId,"I",OEORIChdsub,1)),"^",13)
	  .. q:(OEORIItemStatDR=4)
	  .. s ARCIMDesc=$p($g(^ARCIM(OEORIItmMastDRsub,1,1)),"^",2)
	  .. s CurrentOrdItem=ARCIMDesc
	
	
	//返回当前医嘱项
	q CurrentOrdItem
}

/// Creator:	wangwentao
/// CreatDate:	2009-07-02
/// Description:控制放在打印处方的时候 入参是ADM，返回值Y/N 任意一个病历填了内容且保存了就是Y   
/// Table:		/
/// Input:		EpisodeID
/// Output:		状态^描述   状态(Y/N) 描述(文本)
/// Others:		/
/// Example:    w ##Class(EPRservice.TestAndTools.EPRTools).GetOutpatEPRStatus(28)
ClassMethod GetOutpatEPRStatus(argEpisodeID As %String) As %String
{
	//入参检查
	q:(($d(argEpisodeID)=0)||(argEpisodeID="")) ""
	
	//定义变量
	s Status=""
	s AdmType="" ,DisDept="" ,DisDeptDR=""

	//病人类型检查
	s AdmType = $p($g(^PAADM(argEpisodeID)),"^",2)
	q:(AdmType'="O") ""
	
	//病人科室检查(妇产科不控制)
	//44	妇产科门诊	FCKMZ-妇产科门诊
	//45	妇科门诊	FKMZ-妇科门诊
	s DisDept=##Class(EPRservice.HISInterface.PatientInfoAssist).DisDept(argEpisodeID,"DiTan")
	q:(DisDept="") ""
	s DisDeptDR=$p($g(DisDept),"^",1)
	q:((DisDeptDR="44")||(DisDeptDR="45")) ""
	
	//初诊通用模板定义(一般情况主诉.现病史既往史.体格检查.辅助检查.初步诊断.治疗处理意见)
	s FirTemplateId1 = "76"
	s FirTemplateId2 = "77"
	s FirTemplateId3 = "78"
	s FirTemplateId4 = "79"
	s FirTemplateId5 = "80"
	s FirTemplateId6 = "81"
	s FirTime	= "门诊初诊.就诊时间#TYPE:Simple#TID:76#TVER:0#SCODE:D0025#VTYPE:V"
	s FirRec1	= "门诊初诊.主诉#TYPE:TextDesc#TID:76#TVER:0#ECODE:E0055"
	s FirRec2	= "门诊初诊.现病史#TYPE:TextDesc#TID:77#TVER:0#ECODE:E0056"
	s FirCheck	= "门诊初诊.体格检查#TYPE:TextDesc#TID:78#TVER:0#ECODE:E0171" 
	s FirDoctor	= "门诊初诊.医师签名#TYPE:Simple#TID:81#TVER:0#SCODE:I0002#VTYPE:V" 
	
	//复诊通用模板定义
	s SecTemplateId = "257"
	s SecTime	= "门诊复诊.就诊时间#TYPE:Simple#TID:257#TVER:0#SCODE:D0007#VTYPE:V"
	s SecCheck	= "门诊复诊.病史查体#TYPE:TextDesc#TID:257#TVER:0#ECODE:E0047"
	s SecDoctor	= "门诊复诊.医师签名#TYPE:Simple#TID:257#TVER:0#SCODE:I0043#VTYPE:V"
	
	//定义变量
	s SecTemplateStatus=""
	s IsSecTime="" ,IsSecCheck="" ,IsSecDoctor=""
	s FirTemplateStatus=""
	s IsFirTime="" ,IsFirRec1="" ,IsFirRec2="" ,IsFirCheck="" ,IsFirDoctor=""

	//判断复诊病历完整性  1=Save  0=UnSave
	s SecTemplateStatus = ##Class(EPRservice.Quality.BOQuaExpExplain).GetInstanceDataStatus(argEpisodeID,SecTemplateId)
	if SecTemplateStatus = 1 {
		s IsSecTime = ##Class(EPRservice.BOScatterData).GetEPRData(argEpisodeID,SecTime)
		s IsSecCheck =##Class(EPRservice.BOScatterData).GetEPRData(argEpisodeID,SecCheck)
		s IsSecDoctor = ##Class(EPRservice.BOScatterData).GetEPRData(argEpisodeID,SecDoctor)
		
		if (IsSecTime'="")&&(IsSecCheck'="")&&(IsSecDoctor'="") {
			s Status = "Y^复诊病历保存成功,完整性检查成功!"
		}
		else {
			s Status = "N^复诊病历保存成功,完整性检查失败!"
		}

	}
	//判断初诊病历完整性
	else {
		s FirTemplateStatus1 = ##Class(EPRservice.Quality.BOQuaExpExplain).GetInstanceDataStatus(argEpisodeID,FirTemplateId1)
		s FirTemplateStatus2 = ##Class(EPRservice.Quality.BOQuaExpExplain).GetInstanceDataStatus(argEpisodeID,FirTemplateId2)
		s FirTemplateStatus3 = ##Class(EPRservice.Quality.BOQuaExpExplain).GetInstanceDataStatus(argEpisodeID,FirTemplateId3)
		s FirTemplateStatus4 = ##Class(EPRservice.Quality.BOQuaExpExplain).GetInstanceDataStatus(argEpisodeID,FirTemplateId4)
		s FirTemplateStatus5 = ##Class(EPRservice.Quality.BOQuaExpExplain).GetInstanceDataStatus(argEpisodeID,FirTemplateId5)
		s FirTemplateStatus6 = ##Class(EPRservice.Quality.BOQuaExpExplain).GetInstanceDataStatus(argEpisodeID,FirTemplateId6)
		
		if (FirTemplateStatus1 && FirTemplateStatus2 && FirTemplateStatus3 && FirTemplateStatus4 && FirTemplateStatus5 && FirTemplateStatus6) {
			s SecTemplateStatus = 1
		}
		
		if SecTemplateStatus = 1 {
			s IsFirTime = ##Class(EPRservice.BOScatterData).GetEPRData(argEpisodeID,FirTime)
			s IsFirRec1 =##Class(EPRservice.BOScatterData).GetEPRData(argEpisodeID,FirRec1)
			s IsFirRec2 = ##Class(EPRservice.BOScatterData).GetEPRData(argEpisodeID,FirRec2)
			s IsFirCheck =##Class(EPRservice.BOScatterData).GetEPRData(argEpisodeID,FirCheck)
			s IsFirDoctor = ##Class(EPRservice.BOScatterData).GetEPRData(argEpisodeID,FirDoctor)
			
			if (IsFirTime'="")&&(IsFirRec1'="")&&(IsFirRec2'="")&&(IsFirCheck'="")&&(IsFirDoctor'="") {
				s Status = "Y^初诊病历保存成功,完整性检查成功!"
			}
			else {
				s Status = "N^初诊病历保存成功,完整性检查失败!"
			}
		}
		else {
			s Status = "N^初诊病历未保存,复诊病历未保存!"
		}
	}
			

    q Status
}

/// Desc:	入院病区【RowId^Code^Desc】
/// Table：	SQLUser.PA_AdmTransaction TRANS_Room_DR /SQLUser.PAC_Room
/// Output：RowId^Code^Desc
/// Others：not different from hospitals
/// Test:   ##Class(EPRservice.HISInterface.PatientInfoAssist).AdmRoom()
ClassMethod AdmRoom(argAdmId As %String, argHospital As %String = "") As %String
{
	
	q:(($d(argAdmId)=0)||(argAdmId="")) ""
	
	s TRANSChildsub="",roomDR="",room="",bed="",RoomCode="",RoomDesc="",admroom=""
	
	f  s TRANSChildsub=$o(^PAADM(argAdmId,"TRANS",TRANSChildsub)) q:(TRANSChildsub="")!(bed'="")  d
	.s bed=$p($g(^PAADM(argAdmId,"TRANS",TRANSChildsub)),"^",8)
	.s roomDR=$p($g(^PAADM(argAdmId,"TRANS",TRANSChildsub)),"^",7)
	if roomDR'="" 
	{
		s RoomCode=$p($g(^PAROOM(roomDR)),"^",1)
		s RoomDesc=$p($g(^PAROOM(roomDR)),"^",2)
		//if $l(WardDesc,"-")>1 {s WardDesc=$p($g(WardDesc),"-",2)}
		s admroom=roomDR_"^"_RoomCode_"^"_RoomDesc
	}
	
	q admroom
}

/// Desc:  	出院病区【RowId^Code^Desc】
/// Output: RowId^Code^Desc
/// Others：not different from hospitals 
/// Test:   ##Class(EPRservice.HISInterface.PatientInfoAssist).DisRoom()
ClassMethod DisRoom(argAdmId As %String, argHospital As %String = "") As %String
{
	q:(($d(argAdmId)=0)||(argAdmId="")) ""
	
	s RoomDesc="",RoomCode="",DisRoomDR="",DisRoom=""
	
	s DisRoomDR=$P($g(^PAADM(argAdmId)),"^",69)
	if DisRoomDR'="" 
	{
		s RoomCode=$p($g(^PAROOM(DisRoomDR)),"^",1)
		s RoomDesc=$p($g(^PAROOM(DisRoomDR)),"^",2)
		//if $l(RoomDesc,"-")>1 {s RoomDesc=$p($g(RoomDesc),"-",2)}
		s DisRoom=DisRoomDR_"^"_RoomCode_"^"_RoomDesc
	}	
	
	q DisRoom
}

ClassMethod GetInsuranceFee(AdmId As %String) As %String
{
	q:(($g(AdmId)="")||(AdmId="")) ""
	s billId="",result="",ZFFee="",TCFee="",JZFee=""
	
	f  s billId=$o(^DHCPB(0,"ADM",AdmId,billId)) q:(billId="")  d
	.s result=##class(web.DHCINSUDivideCtl).GetByBillforJF(billId)
	.q:((result=-1)||(result=-100)||($p(result,"!",1)'=1))
	.s result=$p(result,"!",2)
	.s ZFFee=(+ZFFee)+(+$p(result,"^",3))
	.s TCFee=(+TCFee)+(+$p(result,"^",4))
	.s JZFee=(+JZFee)+(+$p(result,"^",5))
	
	//return with 2 digits decimal  epr_gjb_20070311 update
	q $fn(ZFFee,"",2)_"^"_$fn(TCFee,"",2)_"^"_$fn(JZFee,"",2)
}

ClassMethod GetDocUnfinishedEPR(argStartDate As %String, argEndDate As %String, argCategoryID As %String, argGroupItemIDs As %String) As %String
{
	q:($d(argStartDate)=0)||($d(argEndDate)=0)||($d(argCategoryID)=0)||($d(argGroupItemIDs)=0)||(argStartDate="")||(argEndDate="")||(argCategoryID="")||(argGroupItemIDs="") 0
	//get discharged patients list
	s uniqueid=$i(^CacheTemp)
	k ^CacheTempAdmId(uniqueid),^CacheTempUnfinishedEPR(uniqueid)
	//k ^CacheTempAdmId,^CacheTempUnfinishedEPR 
	s wherestring="dischargedate#>=#"_argStartDate_"^dischargedate#<=#"_argEndDate
	s AdmNum=0
	s AdmNum=##class(EPRservice.Query.BODataQueryService).PrepareAdmIdList(wherestring,uniqueid)
	q:(AdmNum=0) 0
	
	s Adm=0,num=0
	//loop every Adm
	for {
		s Adm=$o(^CacheTempAdmId(uniqueid,Adm))
		q:(Adm="")
		
		//get patient's name and location
		s PapmiDR=$P($g(^PAAdm(Adm)),"^",1)
		s PatName=$P($g(^PAPER(PapmiDR,"ALL")),"^",1)
		s PatRegNo=$P($g(^PAPER(PapmiDR,"PAT",1)),"^",1)
		
		s PatientLoc=$p($g(^PAAdm(Adm)),"^",4) //PatientLoc=PAAdm_DepCode_DR
		s PatientLoc=$p($g(^CTLOC(PatientLoc)),"^",2)
		s PatientLoc=$p( PatientLoc,"-",2)   // 2007-06-06 update by wwt
		//b "s"
		 
		
		
		//get the Adm's EPR which CategoryID = argCategoryID (the ID in TemplateCategory)
		s ECRecordId=##class(EPRinstance.ECRecord).GetIDByEpisodeAndCategoryID(Adm,argCategoryID)
		
		//if there is no ECRecordId, the patient's EPR is unfinished
		if (ECRecordId="") {
			s num=num+1
			s ^CacheTempUnfinishedEPR(uniqueid,num)=argStartDate_"	"_num_"	"_PatientLoc_"	"_PatRegNo_"	"_PatName
			continue
		}
		
		//get all EPR instance data which ECRecord 
		Set rset = ##class(%ResultSet).%New("EPRinstance.InstanceData:SELECTGroupList")
		Set sc = rset.Execute(ECRecordId)
	
		//loop all instance, check if all instances which ID are in argGroupItemIDs are saved,
		//if one is not, then the patient's EPR is unfinished
		s unfinished=0
		While (rset.Next()) {
			//b "s"
			s InstanceId=rset.Get("ID")
			q:(InstanceId="")
			s Instance=##class(EPRinstance.InstanceData).%OpenId(InstanceId)
			q:(Instance="")
			
			for i=1:1:$l(argGroupItemIDs,"^") {
				//b "s"
				if ($p(argGroupItemIDs,"^",i)=Instance.GroupItemID)&&(Instance.Status="UnSave") {s unfinished=1}
				q:(unfinished=1)
			}
		}
		
		Do rset.Close()
		
		//record unfinished info
		if unfinished {
			s num=num+1
			s ^CacheTempUnfinishedEPR(uniqueid,num)=argStartDate_"	"_num_"	"_PatientLoc_"	"_PatRegNo_"	"_PatName
		}
	}
	q uniqueid_"^"_num
}

ClassMethod GetGlobalItem(uniqueid As %String, argNum As %String) As %String
{
	q $g(^CacheTempUnfinishedEPR(uniqueid,argNum))
}

ClassMethod GetLocWardBedAdmdatetime(adm As %String, ByRef loc As %String, ByRef ward As %String, ByRef bed As %String, ByRef admdate As %String, ByRef admtime As %String)
{
	q:(($d(adm)=0)||(adm="")) ""
	
	s TRANSChildsub="",loc="",ward="",bed="",tmploc=""
	f  s TRANSChildsub=$o(^PAADM(adm,"TRANS",TRANSChildsub)) q:(TRANSChildsub="")!(bed'="")  d
	.s bed=$p(^PAADM(adm,"TRANS",TRANSChildsub),"^",8)
	.s ward=$p(^PAADM(adm,"TRANS",TRANSChildsub),"^",9)
	.s tmploc=$p(^PAADM(adm,"TRANS",TRANSChildsub),"^",6)
	.s admdate=$p(^PAADM(adm,"TRANS",TRANSChildsub),"^",1)
	.s admtime=$p(^PAADM(adm,"TRANS",TRANSChildsub),"^",2)
	.if tmploc'="" {s loc=tmploc}
	;q loc_"^"_ward_"^"_bed_"^"_admdate_"^"_admtime
}

ClassMethod GetPatMCInfo(Admno As %String) As %String
{
	s UniqueId=$i(^CacheTemp)
	k ^CacheTempPatMcCate(UniqueId),PLIST
	s n=1
	s rowid="0"
	f  s rowid=$o(^DHCTarC("TMC",rowid))  q:rowid=""  d
	.i $g(^CacheTempPatMcCate(UniqueId))="" s ^CacheTempPatMcCate(UniqueId)=0
	.i $p(^DHCTarC("TMC",rowid),"^",1)'="" d
	..s acctdesc=$p($p(^DHCTarC("TMC",rowid),"^",1),$c(1))
	..s ^CacheTempPatMcCate(UniqueId,n)=$p(rowid,$c(1))_"^"_acctdesc
	..s ^CacheTempPatMcCate(UniqueId)=n
	..s PLIST(n)=acctdesc
	..s n=n+1
			
	s Admno=$g(Admno)
	q:(Admno="") 0
	s sum=0, P9=""
	f i=1:1:$g(^CacheTempPatMcCate(UniqueId)) d
	.s itmfee(i)=0
	
	s rowid=""
	f  s rowid=$o(^DHCPB(0,"Adm",Admno,rowid))  q:rowid=""  d
	.s pboid=""
	.f  s pboid=$o(^DHCPB(rowid,"O",pboid))  q:pboid=""  d
	..s pbdid="0"
	..f  s pbdid=$o(^DHCPB(rowid,"O",pboid,"D",pbdid))  q:pbdid=""  d
	...s taritem=$p(^DHCPB(rowid,"O",pboid,"D",pbdid),"^",3)     
	...s unitprice=$p(^DHCPB(rowid,"O",pboid,"D",pbdid),"^",4)   
	...s qty=$p(^DHCPB(rowid,"O",pboid,"D",pbdid),"^",5)         
	...s totalamount=$p(^DHCPB(rowid,"O",pboid,"D",pbdid),"^",7)
	...i totalamount=""  s totalamount=0
	...s sum=sum+totalamount
	...q:(taritem="")
	...q:($d(^DHCTARI(taritem))=0)
	...s subcate=$p(^DHCTARI(taritem),"^",6)
	...s acctcate=$p(^DHCTarC("MC",subcate),"^",3)
	...f i=1:1:$g(^CacheTempPatMcCate(UniqueId)) d
	....i $p(acctcate,$c(1))=$p($p(^CacheTempPatMcCate(UniqueId,i),"^",1),$c(1)) d
	.....s itmfee(i)=totalamount+itmfee(i)
	
	f i=1:1:$g(^CacheTempPatMcCate(UniqueId)) d
	.//w itmfee(i),!
	.s P9=P9_"!"_$p(^CacheTempPatMcCate(UniqueId,i),"^",2)_"^"_$fn(itmfee(i),"",2)
	s P9="Total^"_$fn(sum,"",2)_P9
	q P9
	
	/*
	different between Hospitals!
	 
	费用代码: 来自^DHCTarC("TMC"
	1^西药 xyf, 2^中成药 zcyf, 5^诊察费 zcf , 3^中草药 zchyf, 4^床位费 cwf, 
	6^护理费 hlf, 7^检查费 jcf, 8^治疗费 zlf, 9^手术费 ssf, 10^麻醉费 mzf, 
	11^化验费 hyf, 12^输血费 sxf, 13^输氧费 syf, 14^材料费 clf, 15^其他 qtf, 
	16^挂号费 ghf, 17^伙食费 hsf, 18^无费用 wfy
	
	XYF:%String,ZCYF:%String,ZCF:%String,ZCHYF:%String,CWF:%String,HLF:%String,JCF:%String,ZLF:%String,SSF:%String,MZF:%String,HYF:%String,SXF:%String,SYF:%String,CLF:%String,QTF:%String,GHF:%String,HSF:%String,WFY:%String
	*/
}

ClassMethod CheckEPRInstance(ECRecordId As %String, argGroupItemIDs As %String) As %String
{
		//get all EPR instance data which ECRecord 
		Set rset = ##class(%ResultSet).%New("EPRinstance.InstanceData:SELECTGroupList")
		Set sc = rset.Execute(ECRecordId)
	
		//loop all instance, check if all instances which ID are in argGroupItemIDs are saved,
		//if one is not, then the patient's EPR is unfinished
		s unfinished=0
		While (rset.Next()) {
			//b "s"
			s InstanceId=rset.Get("ID")
			q:(InstanceId="")
			s Instance=##class(EPRinstance.InstanceData).%OpenId(InstanceId)
			q:(Instance="")
			
			for i=1:1:$l(argGroupItemIDs,"^") {
				//b "s"
				if ($p(argGroupItemIDs,"^",i)=Instance.GroupItemID)&&(Instance.Status="UnSave") {s unfinished=1}
				q:(unfinished=1)
			}
		}
		Do rset.Close()
	
	q unfinished
}

/// 获取过敏记录
/// 赵连军安排临床组王奎忠提供
ClassMethod MedAllergy(admNo As %String = "") As %String
{
	//返回:医嘱名称+试敏+(阴/阳)+日期+执行人
	s retStr=""
	q:admNo="" retStr
    s oeordId="" f  s oeordId=$O(^OEORD(0,"Adm",admNo,oeordId)) q:oeordId=""  d 
    .s oeordSubId=""  f  s oeordSubId=$O(^OEORD(oeordId,"I",oeordSubId))  q:oeordSubId=""  d
    ..s ordStatDR=$P($G(^OEORD(oeordId,"I",oeordSubId,1)),"^",13)
    ..i ordStatDR'="" s ordStat=$P(^OEC("OSTAT",ordStatDR),"^",1)
    ..e  s ordStat="" 
    ..s skintest="",abnorm=""
    ..s skintest=$p($g(^OEORD(oeordId,"I",oeordSubId,5)),"^",2)
    ..q:skintest=""
    ..s abnorm=""
    ..if (skintest="Y")&(ordStat'="D") d
    ...s abnorm=$p($g(^OEORD(oeordId,"I",oeordSubId,11)),"^",3)
    ...s skinTR="未做"
    ...if abnorm="Y"  s skinTR="(阳性)"
    ...if abnorm="N"  s skinTR="(阴性)"
    ...s arcimdescDR=$p($g(^OEORD(oeordId,"I",oeordSubId,1)),"^",2)
    ...q:arcimdescDR=""
    ...s arcimdesc=$P(^ARCIM($P(arcimdescDR,"||",1),$P(arcimdescDR,"||",2),1),"^",2)_"试敏"_skinTR
    ...s skinTestCtcpDesc=""
    ...s skinTestDate=""
    ...s dhcoriId=$o(^DHCORDItem(0,oeordId_"||"_oeordSubId,""))
    ...i dhcoriId'="" d
    ....s skinTestCtcpId=$p(^DHCORDItem(dhcoriId),"^",2)
    ....i skinTestCtcpId="" q
    ....s skinTestCtcpDesc=$p($g(^CTPCP(skinTestCtcpId,1)),"^",2)
    ....s skinTestDate=$p(^DHCORDItem(dhcoriId),"^",3)
    ....i skinTestDate'="" s skinTestDate=$ZD(skinTestDate,3)
    ...i retStr="" s retStr=arcimdesc_" "_skinTestDate_" "_skinTestCtcpDesc
    ...e  s retStr=retStr_"^"_arcimdesc_" "_skinTestDate_" "_skinTestCtcpDesc

    q retStr
}

/// Creator：Liaowp 
/// CreateDate: 2009-11-04
/// Desc: 获取病人过敏记录，For Get Allergy info from doctor status
/// Input: PatientID 病人登记rowid  flag 处理 "注射用头孢美唑钠|[1.0g/瓶]"
/// Output：过敏描述1,过敏描述2
/// Debug:w ##class(EPRservice.HISInterface.PatientInfoAssist).EPRGetAllergy(274902)
ClassMethod EPRGetAllergy(PatientID As %String, flag As %String = "")
{
	s ret="",AllergyStr=""
	
	;病人过敏记录 PA_Allergy
	s chl=0 f  s chl=$O(^PAPER(PatientID,"ALG",chl)) q:chl=""  d
	.s s=$G(^PAPER(PatientID,"ALG",chl))
	.s ALGStatus=$P(s,"^",8)
	.Q:ALGStatus="I"
	.s ALGTypeDR=$P(s,"^",9) ;自定义 PAC_Allergy
	.s ALGPHCGEDR=$P(s,"^",4) ;通用名 PHC_Generic
	.s ALGPHCDMDR=$P(s,"^",27) ;药学项 PHC_DrgMast
	.s ALGSeverityDR=$P(s,"^",21) ;过敏程度 PAC_AllergySeverity
	.i ALGSeverityDR'="" s ALGSeverityCode=$P($g(^PAC("ALRGSEV",ALGSeverityDR)),"^",1)
	.;
	.i (ALGTypeDR'="") d
	..s ALGDesc=$P(^PAC("ALG",ALGTypeDR),"^",2)
	..i ($L(ALGDesc,"-")>1) d
	...s ALGDesc=$p(ALGDesc,"-",2)
	..i (AllergyStr="") d
	...s AllergyStr=ALGDesc
	..e  d
	...s AllergyStr=AllergyStr_","_ALGDesc
	
	.;
	.i (ALGPHCGEDR'="") d
	..s ALGPHCGEDesc=$P(^PHCGE("GE",ALGPHCGEDR),"^",2)
	..i ($L(ALGPHCGEDesc,"-")>1) d
	...s ALGPHCGEDesc=$p(ALGPHCGEDesc,"-",2)
	..i (AllergyStr="") d
	...s AllergyStr=ALGPHCGEDesc
	..e  d
	...s AllergyStr=AllergyStr_","_ALGPHCGEDesc
	
	.;
	.i (ALGPHCDMDR'="") d
	..s ALGPHCDMDesc=$P(^PHCD(ALGPHCDMDR,1),"^",2)
	..i ($L(ALGPHCDMDesc,"-")>1) d
	...s ALGPHCDMDesc=$p(ALGPHCDMDesc,"-",2)
	...s:(flag="Y") ALGPHCDMDesc =$p(ALGPHCDMDesc,"|",1)
	..i (AllergyStr="") d
	...s:(flag="Y") ALGPHCDMDesc =$p(ALGPHCDMDesc,"|",1)
	...s AllergyStr=ALGPHCDMDesc
	..e  d
	...s:(flag="Y") ALGPHCDMDesc =$p(ALGPHCDMDesc,"|",1)
	...s AllergyStr=AllergyStr_","_ALGPHCDMDesc

	Q AllergyStr
}

/// Creator: Liaowp 
/// CreateDate: 2009-11-04
/// Desc: 取对照转换后的病人付款方式，For get the method of patient pay
/// Input: EpisodeID 病人就诊rowid
/// Return: 对照转换后的病人付款方式
/// Debug:w ##class(EPRservice.HISInterface.PatientInfoAssist).GetAdmReason(15805)
ClassMethod GetAdmReason(EpisodeID As %String) As %String
{
	Q:(EpisodeID="") ""
	;N (EpisodeID)
	s AdmRSDR="",AdmRS=""
	s AdmRSDR=$P($G(^PAADM(EpisodeID,1)),"^",7)
	
	K SQLCODE
	&sql(select CtmDictAlias into :AdmRS from eprmeta.customdictionary where CtmDictID=:AdmRSDR and CtmDictName= '费用类别')
	if SQLCODE=0 { Q AdmRS }
	else { Q "" }
}

/// Creator:	wangwentao
/// CreatDate:	20090820
/// Description:获取医嘱项目通过医嘱类型
/// Table:		
/// Input:		argAdmId是病人就诊ID[PA_Adm表RowID] argPriority是医嘱类型ID[OEC_Priority 表RowID] argHospital是医院标识
/// Output:		/
/// Return:		
/// Others:	1	STAT	即刻医嘱
/// 		2	PRN	PRN
/// 		3	NORM	临时医嘱
/// 		4	ONE	取药医嘱
/// 		5	S	长期医嘱
/// 		6	OM	自备药即刻
/// 		7	OUT	出院带药
/// 		8	OMST	自备药长期			
/// Example:	w ##Class(EPRservice.HISInterface.PatientInfoAssist).GetOrderByPriority(50729,7,"BJDTYY")
ClassMethod GetOrderByPriority(argAdmId As %String, argPriority As %String, argHospital As %String = "") As %String
{
	//完整性判断
	q:($d(argAdmId)=0)||(argAdmId="") ""
	q:($d(argPriority)=0)||(argPriority="") ""

	
	//定义返回值
	s RetString="",tmpRetString=""
	
	//定义变量
	s OEORDRowId="",OEORIChdsub="",OEORIItmMastDR="",OEORIItmMastDRSub="",OEORIItmMastDRSubNo="",ARCIMItemCatDR="",OEORIItemStatDR="",ARCIMDesc=""
	
	s OEORIPriorityDR="",OSTATCode="",QtyPackUOM="",DoseQty="",OEORIInstrDR="",PHCINDesc1="",OEORIUnitDR="",CTUOMDesc="",ARCIMBillingUOMDR="",CTUOMDescSUM="",OEORIPHFreqDR="",PHCFRDesc1=""
	
	
	//程序处理
    f  s OEORDRowId=$o(^OEORD(0,"Adm",argAdmId,OEORDRowId)) q:(OEORDRowId="")  d
    . //Sub Loop
	. f  s OEORIChdsub=$o(^OEORD(OEORDRowId,"I",OEORIChdsub)) q:(OEORIChdsub="")  d
	  .. //i OEORIChdsub=755 b "s" 
	  .. //Get OEORI_Priority_DR[SQLUser.OE_OrdItem]依照医嘱类型取数
	  .. s OEORIPriorityDR= $p($g(^OEORD(OEORDRowId,"I",OEORIChdsub,1)),"^",8)
	  .. q:(OEORIPriorityDR'=argPriority)
	  .. //Get OE_OrdItem.OEORI_ItemStat_DR[OEC_OrderStatus]
	  .. //Get OSTAT_Code[OEC_OrderStatus] [OSTAT_RowId=4	OSTAT_Code=D	OSTAT_Desc=停止	OSTAT_Activate=Y]
	  .. s OEORIItemStatDR=$p($g(^OEORD(OEORDRowId,"I",OEORIChdsub,1)),"^",13)
	  .. q:(OEORIItemStatDR="")
	  .. s OSTATCode=$p($g(^OEC("OSTAT",OEORIItemStatDR)),"^",1)
	  .. q:(OSTATCode="D")
	  .. //Get OE_OrdItem.OEORI_ItmMast_DR[ARC_ItmMast]
	  .. s OEORIItmMastDR= $p($g(^OEORD(OEORDRowId,"I",OEORIChdsub,1)),"^",2)
	  .. q:(OEORIItmMastDR="")
	  .. s OEORIItmMastDRSub=$p(OEORIItmMastDR,"||",1)
	  .. s OEORIItmMastDRSubNo=$p(OEORIItmMastDR,"||",2)
	  .. //Get ARC_ItmMast.ARCIM_Desc[ARC_ItmMast]取医嘱描述
	  .. s ARCIMDesc=$p($g(^ARCIM(OEORIItmMastDRSub,OEORIItmMastDRSubNo,1)),"^",2)
	  .. //Get OEORI_QtyPackUOM[SQLUser.OE_OrdItem]取总数量
	  .. s QtyPackUOM=$p($g(^OEORD(OEORDRowId,"I",OEORIChdsub,9)),"^",4)
	  .. //Get OEORI_DoseQty[SQLUser.OE_OrdItem]取单次剂量
	  .. s DoseQty=$p($g(^OEORD(OEORDRowId,"I",OEORIChdsub,2)),"^",1)
	  .. //Get [SQLUser.OE_OrdItem]OEORI_Instr_DR[PHC_Instruc]取用法
	  .. //Get PHCIN_Desc1[PHC_Instruc]
	  .. s OEORIInstrDR=$p($g(^OEORD(OEORDRowId,"I",OEORIChdsub,2)),"^",7)
	  .. q:(OEORIInstrDR="")
	  .. s PHCINDesc1=$p($g(^PHCIN(OEORIInstrDR)),"^",2)
	  .. //Get [SQLUser.OE_OrdItem]OEORI_Unit_DR[CT_UOM]取单次剂量单位
	  .. //Get CTUOM_Desc[CT_UOM]
	  .. s OEORIUnitDR=$p($g(^OEORD(OEORDRowId,"I",OEORIChdsub,2)),"^",3)
	  .. q:(OEORIUnitDR="")
	  .. s CTUOMDesc=$p($g(^CT("UOM",OEORIUnitDR)),"^",2) 
	  .. //Get [ARC_ItmMast]ARCIM_BillingUOM_DR[CT_UOM]取总数量单位
	  .. //Get CTUOM_Desc[CT_UOM]
	  .. s ARCIMBillingUOMDR=$p($g(^ARCIM(OEORIItmMastDRSub,OEORIItmMastDRSubNo,8)),"^",14)
	  .. q:(ARCIMBillingUOMDR="")
	  .. s CTUOMDescSUM=$p($g(^CT("UOM",ARCIMBillingUOMDR)),"^",2)
	  .. //Get [SQLUser.OE_OrdItem]OEORI_PHFreq_DR[PHC_Freq]取频次
	  .. //Get PHCFR_Desc1[PHC_Freq]
	  .. s OEORIPHFreqDR=$p($g(^OEORD(OEORDRowId,"I",OEORIChdsub,2)),"^",4)
	  .. q:(OEORIPHFreqDR="")
	  .. s PHCFRDesc1=$p($g(^PHCFR(OEORIPHFreqDR)),"^",3)
	  .. s tmpRetString=ARCIMDesc_"*"_QtyPackUOM_CTUOMDescSUM_"/"_PHCINDesc1_" "_DoseQty_CTUOMDesc_" "_PHCFRDesc1
	  .. s RetString=RetString_$c(13,10)_tmpRetString
	  
	  
	  //消除信息串起始的||
	  if (RetString'="") {
		  s RetString=$e(RetString,3,$l(RetString))
	  }
	  
	  //w RetString
	
	
	//返回嘱项
	q RetString
}

/// Creator:	wangwentao
/// CreatDate:	20090831
/// Description:取EPRinstance.InstanceData状态
/// Table:		/
/// Input:		argAdmID是患者就诊ID argGroupID是模板权限-模板组ID argHospital是医院标识
/// Output:		InstanceStatus="Y" InstanceStatus="N"
/// Return:		
/// Others:		TemplateID->Template.CategoryID
/// 			Index IdxEpisodeIDCategoryID On (EpisodeID, CategoryID)
/// 			Index IdxECRecord On TheECRecord	
/// Example:	w ##Class(EPRservice.HISInterface.PatientInfoAssist).GetInstanceDataStatus(50729,1)
ClassMethod GetInstanceDataStatus(EpisodeID As %String, TemplateID As %String) As %String
{
	
	//定义返回状态
    s RetStatus="N"
    
    s objTemplate=##Class(EPRmeta.Template).%OpenId(TemplateID)
    s CategoryID=objTemplate.TemplateCategoryID
    s objTemplateCategory=##Class(EPRmeta.TemplateCategory).%OpenId(CategoryID)
    
    i objTemplateCategory.CategoryType="Normal"
    {
		s CategoryID=objTemplate.TemplateCategoryID
	}
    i objTemplateCategory.CategoryType="GroupItem"
    {
		s CategoryID=objTemplateCategory.ParentID
	}
	
    s BlankEpisodeID=" "_EpisodeID
	s BlankCategoryID=" "_CategoryID
	s TheEcrecordIndex="0"
	s TheEcrecordIndex= $O(^DHCEPRI.ECRecordI("IdxEpisodeIDCategoryID",BlankEpisodeID,BlankCategoryID,""))
	q:TheEcrecordIndex="" RetStatus 
	s objInstanceData=##Class(EPRinstance.ECRecord).%OpenId(TheEcrecordIndex)
	s InstanceCount=objInstanceData.InstanceCount
	
	f i=1:1:InstanceCount
	{
		s InstanceDataID=TheEcrecordIndex_"||"_i
		s objInstanceData=##Class(EPRinstance.InstanceData).%OpenId(InstanceDataID)
		if objInstanceData.TemplateID=TemplateID 
		{
			i ((objInstanceData.Status="Save")||(objInstanceData.Status="Commit"))  
			{
				s RetStatus="Y"
			}
		}
	}
    q RetStatus
}

/// Creator:	wangwentao
/// CreatDate:	20090831
/// Description:获取界面模板状态通过模板权限-模板组ID
/// Table:		/
/// Input:		argAdmID是患者就诊ID argGroupID是模板权限-模板组ID argHospital是医院标识
/// Output:		/
/// Return:		
/// Others:		^DHCEPRM.Priv.TempsInGroupD(1,275) = $lb("",,,"66") 		
/// Example:	w ##Class(EPRservice.HISInterface.PatientInfoAssist).GetEPRStatusByGroupID(50729,1)
ClassMethod GetEPRStatusByGroupID(argAdmID As %String, argGroupString As %String, argHospital As %String = "") As %String
{
	//完整性判断
	q:($d(argAdmID)=0)||(argAdmID="") ""
	q:($d(argGroupString)=0)||(argGroupString="") ""
	
	//定义返回值
	s RetStatus="N"
	
	//定义变量	
	s GroupID="",GroupSubNo="",TemplateID=""
	s AdmType="",GroupIDCount="", i=""
	
	//病人类型检查
	//s AdmType = $p($g(^PAADM(argEpisodeID)),"^",2)
	//q:(AdmType'="O") ""
	
	//程序处理
	s GroupIDCount = $l(argGroupString, "^")
	f i=1:1:GroupIDCount
	{
		s GroupID = $p(argGroupString, "^", i)
		//b
		i (GroupID'="")
		{
		    f  s GroupSubNo=$o(^DHCEPRM.Priv.TempsInGroupD(GroupID,GroupSubNo)) q:(GroupSubNo="")  d
		    . //Get TemplateID In Node 4
		    . s TemplateID=$li(^DHCEPRM.Priv.TempsInGroupD(GroupID,GroupSubNo),4)
		    . s InstanceStatus= ##Class(EPRservice.HISInterface.PatientInfoAssist).GetInstanceDataStatus(argAdmID,TemplateID)
		    . i (InstanceStatus="Y") s RetStatus="Y"
		}
		q:(RetStatus="Y")
	}

    q RetStatus
}

/// Creator:	wangwentao
/// CreatDate:	20090903
/// Description:获取TrakCare年龄
/// Table:		select PAPER_Age,PAPER_AgeYr,PAPER_AgeMth,PAPER_AgeDay  from SQLUser.PA_Person
/// Input:		argAgeType="B"(婴儿) argAgeType="R"(病案) argAgeType="T"(TrakCare) argAgeType="C"(临床)
/// Output:		/
/// Return:		/
/// Others:		/
/// Example:	##Class(EPRservice.HISInterface.PatientInfoAssist).AgeByType(argAdmId,argBirthday,argAdmDate,argMeddata,argWebsrc,argAgeType,argHospital)
ClassMethod AgeByType(argAdmId As %String, argBirthday As %String, argAdmDate As %String, argMeddata As %String, argWebsrc As %String, argAgeType As %String, argHospital As %String = "") As %String
{
	//入参检查
	q:($d(argAdmId)=0)||(argAdmId="") ""
	q:($d(argBirthday)=0)||(argBirthday="") ""
	q:($d(argAdmDate)=0)||(argAdmDate="") ""
	q:($d(argMeddata)=0)||(argMeddata="") ""
	q:($d(argWebsrc)=0)||(argWebsrc="") ""
	q:($d(argAgeType)=0)||(argAgeType="") ""

	//逻辑检查
    q:(argBirthday>argAdmDate) ""
    
    //年龄初始化
	d $zu(5,argMeddata)
	s tmpAge=""
    s tmpAge=$$CalAge^at182(argBirthday,argAdmDate)
    d $zu(5,argWebsrc)
    q:(tmpAge="")||($l(tmpAge,"|")<14) ""
    
	//返回值定义
	s RetAge=""
	 
	//定义变量
	s tmpAgeYear="",tmpAgeMonth="",tmpAgeDay=""
	s TrakCareAge="",TrakAge="",TrakAgeUnit="",RecordAge="",RecordAgeUnit="",ClinicAge="",BabyAge="",BabyAgeUnit=""

	//取年月日初始值
	s tmpAgeYear=$p(tmpAge,"|",12)
	s tmpAgeMonth=$p(tmpAge,"|",13)
	s tmpAgeDay=$p(tmpAge,"|",14)
	
	if (argAgeType="B")
	{
		if (tmpAgeYear=0)
		{
			//年龄小于1岁 计算天数
			s BabyAge=(argAdmDate-argBirthday)
			
			if BabyAge=0
			{
				s BabyAge=BabyAge+1
			}
		}
		else
		{
			s BabyAge=""
		}
		//返回值 婴儿年龄(N)
		s RetAge=BabyAge
	}
	elseif(argAgeType="R")
	{
		if (tmpAgeYear>0)
		{
			//病案年龄(N)年龄单位(岁)
			s RecordAge=tmpAgeYear ,RecordAgeUnit="岁"
		}
		else
		{
			//病案年龄(1)年龄单位(岁)
			s RecordAge="1" ,RecordAgeUnit="岁"
		}
		//返回值 病案年龄(N)年龄单位(岁)
		s RetAge=RecordAge_"^"_RecordAgeUnit
	}
	elseif(argAgeType="T")
	{
		if (tmpAgeYear>0)
		{
			//TrakCare年龄(N岁)
			s TrakAge=tmpAgeYear ,TrakAgeUnit="岁"
			s TrakCareAge=TrakAge_TrakAgeUnit
		}
		elseif (tmpAgeYear=0)
		{
				if (tmpAgeMonth>0)
				{
					//TrakCare年龄(N月)
					s TrakAge=tmpAgeMonth ,TrakAgeUnit="月"
					s TrakCareAge=TrakAge_TrakAgeUnit
				}
				elseif (tmpAgeMonth=0)
				{
					if (tmpAgeDay>0)
					{
						//TrakCare年龄(N日)
						s TrakAge=tmpAgeDay ,TrakAgeUnit="天"
						s TrakCareAge=TrakAge_TrakAgeUnit
					} 
					elseif (tmpAgeDay=0)
					{
						//TrakCare年龄(N日)
						s TrakAge="1" ,TrakAgeUnit="天"
						s TrakCareAge=TrakAge_TrakAgeUnit
					}  
				}
		}
		
		//返回值 TrakCare年龄(N年/月/日) Trak年龄(N) Trak单位(年/月/日)
		s RetAge=TrakCareAge_"^"_TrakAge_"^"_TrakAgeUnit
	}
	elseif(argAgeType="C")
	{
		if (argHospital=..#HospitalHXYY)
		{ 
		}
		elseif(argHospital=..#HospitalBJDTYY)
		{
		    //ClinicAge >= 14 SHOW (N岁)
		    //ClinicAge < 14 SHOW (N岁M月)
		    //ClinicAge < 1 SHOW (N天)
		    
			if (tmpAgeYear>0)
			{
				if (tmpAgeYear<14)
				{
				 	if (tmpAgeMonth'=0)
					{
						s ClinicAge=tmpAgeYear_"岁"_tmpAgeMonth_"月"
					}
					elseif (tmpAgeMonth=0)
					{
						s ClinicAge=tmpAgeYear_"岁"
					}
				}
				elseif (tmpAgeYear>=14)
				{
					s ClinicAge=tmpAgeYear_"岁"
				}
			}
			elseif (tmpAgeYear=0)
			{
				//年龄小于1岁 计算天数
				s ClinicAge=(argAdmDate-argBirthday)
				
				//校验ClinicAge
				if ClinicAge=0
				{
					s ClinicAge=ClinicAge+1
				}
				s ClinicAge=ClinicAge_"天"
			}
			else
			{
				q ""
			}
		}
		elseif(argHospital=..#HospitalXAJDKQYY)
		{
		}
		else
		{
		}
		
		//返回值 临床年龄
		s RetAge=ClinicAge
	}
				
	q RetAge
}

/// Desc:	当前住院天数
/// Input:	argAdmId: 病人就诊RowID，argHospital:医院标识
/// Output:	天数
/// Others:	not different from hospitals
ClassMethod CurrentDaysAdm(argAdmId As %String, argHospital As %String = "") As %String
{
	q:($d(argAdmId)=0)||(argAdmId="") ""
	//q:($d(argHospital)=0)||(argHospital="") ""
	
	s papmidr="",DeathDateTime="",AdmDateTime="",CurDateTime="",DisDateTimeMR="",DisDateTime=""
	s admdate="",admtime="",dischgdate="",dischgtime=""
	s residentdays=""

	//取PapmiDR
	q:(($d(^PAADM(argAdmId))'=1)&&($d(^PAADM(argAdmId))'=11)) ""
	s papmidr = ..GetPapmiDR(argAdmId)
	
	if argHospital=..#HospitalAHSLYY
	{
		//取入院日期(护士分床)
		s AdmDateTimeInBed=..AdmDateTimeInBed(argAdmId)
		if AdmDateTimeInBed'="" 
		{
			s admdate=$p($g(AdmDateTimeInBed),",",1)
		}
	}
	else
	{
		//取入院日期(入院登记)
		s AdmDateTime=..AdmDateTime(argAdmId)
		if AdmDateTime'="" 
		{
			s admdate=$p($g(AdmDateTime),",",1)
		}
	}

	
	//出院日期取值判断  当前时间
	

	//取当前时间
	s CurDateTime=$h
	if CurDateTime'=""
	{
		s dischgdate=$p($g(CurDateTime),",",1)
	}
		
	
	
	q:((admdate="")||(dischgdate="")) ""
	
	//计算住院天数
	s residentdays = ..ResidentDays(admdate,dischgdate)

	q residentdays
}

/// Desc:	处理综合科各个专科治疗组病历打印抬头问题
/// Input:	argDeptId: CT_Loc.CTLOC_RowId
/// Output:	PrintTemplateTitle
/// Others:	not different from hospitals
/// Test:	d ##class(EPRservice.HISInterface.PatientInfoAssist).GetPrintTitle(argDeptId)
ClassMethod GetPrtTemplateTitle(argDeptId) As %String
{
	//入参检查
	//q:($d(^PAADM(argAdmId))=0)||(argAdmId="") ""
	q:($d(^PAADM(argDeptId))=0)||(argDeptId="") ""
	
	//定义返回值
	s PrintTemplateTitle=""
	
	//定义变量
	s CurDeptStr=""
	
	//0取 综合外科  治疗组及Link治疗组
	s DeptId0="1396",DeptLink0=..CurDeptLinkLocByDept(DeptId0)
	
	//1取  骨科 治疗组及Link治疗组
	s DeptId1="869",DeptLink1=..CurDeptLinkLocByDept(DeptId1)

	//2取  口腔科 治疗组及Link治疗组
	s DeptId2="942",DeptLink2=..CurDeptLinkLocByDept(DeptId2)
	
	//3取泌尿外科 治疗组及Link治疗组
	s DeptId3="990",DeptLink3=..CurDeptLinkLocByDept(DeptId3)
	
	//4取  神经外科 治疗组及Link治疗组
	//s DeptId4="",DeptLink4=..CurDeptLinkLocByDept(DeptId4)
	
	//5取  普外科 治疗组及Link治疗组
	//s DeptId5="",DeptLink5=..CurDeptLinkLocByDept(DeptId5)
	
	//6取  耳鼻喉科 治疗组及Link治疗组
	s DeptId6="810",DeptLink6=..CurDeptLinkLocByDept(DeptId6)
	
	//7取  胸外科 治疗组及Link治疗组
	s DeptId7="1089",DeptLink7=..CurDeptLinkLocByDept(DeptId7)
	
	//8取  眼科 治疗组及Link治疗组
	s DeptId8="1106",DeptLink8=..CurDeptLinkLocByDept(DeptId8)
	
	//系统中 综合外科 分为 (综合外科骨科组,综合外科口腔科组,综合外科泌尿外科组,综合外科脑外科组,综合外科普外科组,综合外科五官科组,综合外科胸外科组,综合外科眼科组)
	//要求以上八个治疗组分别使用该学科科室入院录界面模板,打印时标题变为[综合外科入院记录]
	if (+($f(DeptLink0,"^"_argDeptId_"^"))>0)
	{
		s PrintTemplateTitle="综合外科"
	}
	elseif (+($f(DeptLink1,"^"_argDeptId_"^"))>0) 
	{
		s PrintTemplateTitle="骨科"	 
	}
	elseif (+($f(DeptLink2,"^"_argDeptId_"^"))>0) 
	{
		s PrintTemplateTitle="口腔科"	 
	}
	elseif (+($f(DeptLink3,"^"_argDeptId_"^"))>0) 
	{
		s PrintTemplateTitle="泌尿外科"	 
	}
	//elseif (+($f(DeptLink4,"^"_argDeptId_"^"))>0) 
	//{
	//	s PrintTemplateTitle="神经外科"	 
	//}
	//elseif (+($f(DeptLink5,"^"_argDeptId_"^"))>0) 
	//{
	//	s PrintTemplateTitle="普外科"	 
	//}
	elseif (+($f(DeptLink6,"^"_argDeptId_"^"))>0) 
	{
		s PrintTemplateTitle="耳鼻喉科"	 
	}
	elseif (+($f(DeptLink7,"^"_argDeptId_"^"))>0) 
	{
		s PrintTemplateTitle="胸外科"	 
	}
	elseif (+($f(DeptLink8,"^"_argDeptId_"^"))>0) 
	{
		s PrintTemplateTitle="眼科"	 
	}
	else 
	{
		s PrintTemplateTitle=""
	}
	
	q PrintTemplateTitle
}

/// Desc:	通过患者所在科室的RowID,取 CT_LocLinkLocation 科室与病区的对应关系
/// Input:	
/// Output:	
/// Others:	Table CT_LocLinkLocation / Global ^CTLOC({CT_Loc.CTLOC_RowID},"LINK",0,"Loc",{LINK_CTLOC_DR},{LINK_Childsub})
/// Test:	d ##class(EPRservice.HISInterface.PatientInfoAssist).CurDeptLinkLocByDept(argDeptId)
ClassMethod CurDeptLinkLocByDept(argDeptId As %String) As %String
{
	//b "s"
	//入参检查
	q:($d(argDeptId)=0)||(argDeptId="") ""

	//定义变量
	s CurrentDeptLinkLoc=""
	s CurrentDept="",CurrentDeptDR="",VarLocDR="",VarLocString=""
	s CurrentDeptDR=argDeptId

	//程序处理
	f  s VarLocDR=$o(^CTLOC(CurrentDeptDR,"LINK",0,"Loc",VarLocDR)) q:VarLocDR=""  d
	. s VarLocString=VarLocString_"^"_VarLocDR

	s CurrentDeptLinkLoc="^"_CurrentDeptDR_VarLocString_"^"

	q CurrentDeptLinkLoc
}

/// Creator:	wangwentao
/// CreatDate:	20091122
/// Description:获取指定医保类型的项目字串通过病人就诊ID
/// Input:		argAdmId是病人就诊ID[PA_Adm表RowID]
///             argINSUType是医保类型[1:甲 2:乙 3:丙]
///             argOrdStat是否过滤医嘱状态为停止的记录[Y:是 N:否]
///             argRetType是返回值名称[1:ARC_ItmMast.ARCIM_Desc 2:DHC_TarItem.TARI_Desc]
///             argHospital是医院标识
/// Output:		/
/// Return:		项目字串[Item1^Item2^Item3^...]					
/// Example:	w ##Class(EPRservice.HISInterface.PatientInfoAssist).GetOrderByINSUType(2258699,3,"N",2,"CCFCYY")
/// 
/// Description:  通过paadm表rowid获取患者是否医保病人
/// Table:		  PAC_AdmReason,Pa_adm
/// Input:		  AdmDr   ;pa_adm表rowid
/// Output:	  Y  or  N
/// w ##class(web.INSUBase).GetPatTypeByAdmDr(AdmDr)
/// Description:  根据收费项rowid判断该项目是否丙类项目
/// Table:		  dhc_taritem ,insu_tarcontrast ,insu_taritems
/// Input:		  tari_rowid   ;dhc_taritem表rowid
/// Output:	  Y  or  N
/// w ##class(web.INSUBase).GetItmTypeByTariDr(TariDR)
ClassMethod GetOrderByINSUType(argAdmId As %String, argINSUType As %String, argOrdStat As %String, argRetType As %String = "1", argHospital As %String = "") As %String
{
	
	//检查入参
	q:($d(argAdmId)=0)||(argAdmId="") ""
	q:($d(argINSUType)=0)||(argINSUType="") ""
	q:($d(argOrdStat)=0)||(argOrdStat="") ""
	
	//定义返回值
	s RetItemSting="",tmpRetItem=""
	
	//检查是否医保病人
	//IsINSUPatient Check
	s IsINSUPatient=""	
	//s IsINSUPatient=##class(web.INSUBase).GetPatTypeByAdmDr(argAdmId)
	q:($zcvt(IsINSUPatient,"U")="N") ""

	
	//定义变量
	s OEORDRowId="",OEORIChdsub="0",OEORIItmMastDR="",OEORIItmMastDRsub="",OEORIItmMastDRversion="",ARCIMItemCatDR="",OEORIItemStatDR="",ARCIMDesc=""
	s OLTRowId="",OLTInstDR="",OLTARCIMDR="",OLTStartDate="",OLTTariffDR="",TARIRowId="",TARIDesc=""
	
	//程序处理
    f  s OEORDRowId=$o(^OEORD(0,"Adm",argAdmId,OEORDRowId)) q:OEORDRowId=""  d
    .  //b "s"
    .  //Get Max OEORIChdsub Add 1
    .  //s OEORIChdsub=$g(^OEORD(OEORDRowId,"I",0))+1
	.  f  s OEORIChdsub=$o(^OEORD(OEORDRowId,"I",OEORIChdsub)) q:OEORIChdsub=""  d  
	.  .  //b "s"
	.  .  //Get OE_OrdItem.OEORI_ItmMast_DR[ARC_ItmMast][^OEORD({OE_Order.OEORD_RowId},"I",{OEORI_Childsub})]
	.  .  s OEORIItmMastDR= $p($g(^OEORD(OEORDRowId,"I",OEORIChdsub,1)),"^",2)
	.  .  q:(OEORIItmMastDR="")
	.  .  //Get OE_OrdItem.OEORI_ItemStat_DR[OEC_OrderStatus] //医嘱状态控制
	.  .  i $zcvt(argOrdStat,"U")="Y"  d  
	.  .  . s OEORIItemStatDR=$p($g(^OEORD(OEORDRowId,"I",OEORIChdsub,1)),"^",13)
	.  .  q:(OEORIItemStatDR=4)
	.  .  //Trans OE_OrdItem.OEORI_ItmMast_DR[ARC_ItmMast] To DHC_TarItem.TARI_RowId  By [DHC_OrderLinkTar] 
	.  .  s OLTARCIMDR=OEORIItmMastDR
	.  .  //Get DHC_OrderLinkTar.OLT_RowId //OLTInstDR is NULL
	.  .  f  s OLTStartDate=$o(^DHCOLT(0,"ARCIM",OLTARCIMDR,OLTInstDR_"Z",OLTStartDate)) q:OLTStartDate=""  d
	.  .  .  //b "s"
	.  .  .  f  s OLTRowId=$o(^DHCOLT(0,"ARCIM",OLTARCIMDR,OLTInstDR_"Z",OLTStartDate,OLTRowId)) q:OLTRowId=""  d
	.  .  .  .  //b "s"
	.  .  .  .  //Get DHC_OrderLinkTar.OLT_Tariff_DR[DHC_TarItem][^DHCOLT({OLT_RowId})  2 ] 
	.  .  .  .  s OLTTariffDR=$p($g(^DHCOLT(OLTRowId)),"^",2)
	.  .  q:(OLTTariffDR="")
	.  .  s TARIRowId=OLTTariffDR
	.  .  //IsINSUTpye Check
	.  .  i argINSUType="1"  d  s INSUTypeChk ="N"
	.  .  i argINSUType="2"  d  s INSUTypeChk ="N"
	.  .  i argINSUType="3"  d  s INSUTypeChk =##class(web.INSUBase).GetItmTypeByTariDr(TARIRowId)
	.  .  q:($zcvt(INSUTypeChk,"U")="N")
	.  .  //Get DHC_TarItem.TARI_Desc[^DHCTARI({TARI_RowId}) 2] //计费项名称
	.  .  s TARIDesc=$p($g(^DHCTARI(TARIRowId)),"^",2)
	.  .  //Get ARC_ItmMast.ARCIM_Desc[^ARCIM({ARCIM_Subscript},{ARCIM_Version})  1	2] //医嘱项名称 
	.  .  s OEORIItmMastDRsub=$p(OEORIItmMastDR,"||",1)
	.  .  s OEORIItmMastDRversion=$p(OEORIItmMastDR,"||",2)
	.  .  s ARCIMDesc=$p($g(^ARCIM(OEORIItmMastDRsub,OEORIItmMastDRversion,1)),"^",2)
	.  .  //IsRetType Check
	.  .  i argRetType="1"  d  s RetItemSting=RetItemSting_"!"_ARCIMDesc
	.  .  i argRetType="2"  d  s RetItemSting=RetItemSting_"!"_TARIDesc

	//格式转换
	i (RetItemSting'="") {
		s RetItemSting=$e(RetItemSting,2,$l(RetItemSting))
	}	
	
	//项目查重
	s RetItemSting=..CheckRepeatItem(argAdmId,RetItemSting) 
	
	//格式转换
	s RetCount="",tmpRetItemSting="",tmpItem=""
	s RetCount=$l(RetItemSting,"!")
	f i=1:1:RetCount 
	{
		s tmpItem=$p($g(RetItemSting),"!",i)
		i tmpRetItemSting'="" {
			s tmpRetItemSting=tmpRetItemSting_$c(13,10)_tmpItem
		}
		else {
			s tmpRetItemSting=tmpItem
		}	
	}
	s RetItemSting=tmpRetItemSting
	
	//格式转换
	i (RetItemSting'="") {
		s RetItemSting=$e(RetItemSting,2,$l(RetItemSting))
	}	

	//清理垃圾
	k ^CacheTempDHCEPRDebug("CheckRepeat",argAdmId,"GetOrderByINSUType")
	
	q RetItemSting
}

ClassMethod CheckRepeatItem(argAdmId As %String, argItemSting As %String) As %String
{

	q:($d(argAdmId)=0)||(argAdmId="") ""
	q:($d(argItemSting)=0)||(argItemSting="") ""
	
	s DiagStr="",Diag="",DiagNo=""
	s tmpNode="",i=""
	
	k ^CacheTempDHCEPRDebug("CheckRepeat",argAdmId,"GetOrderByINSUType")
	
	//s diagcount=$l(DiagString,"!")-1
	s diagcount=$l(argItemSting,"!")
	f i=1:1:diagcount 
	{
		//b "s"
		s tmpDiag=$p($g(argItemSting),"!",i)
		if tmpDiag'=""
		{
			if $d(^CacheTempDHCEPRDebug("CheckRepeat",argAdmId,"GetOrderByINSUType","TMPITEM",tmpDiag))'=1
			{
				s ^CacheTempDHCEPRDebug("CheckRepeat",argAdmId,"GetOrderByINSUType","TMPITEM",tmpDiag)=i_"^"_tmpDiag
			}
		}
	}
	
	f i=1:1:diagcount 
	{
		//b "s"
		s tmpDiag=$p($g(argItemSting),"!",i)
		if tmpDiag'=""
		{
			s DiagNo=$p($g(^CacheTempDHCEPRDebug("CheckRepeat",argAdmId,"GetOrderByINSUType","TMPITEM",tmpDiag)),"^",1)
			s Diag=$p($g(^CacheTempDHCEPRDebug("CheckRepeat",argAdmId,"GetOrderByINSUType","TMPITEM",tmpDiag)),"^",2)
			
			
			if $d(^CacheTempDHCEPRDebug("CheckRepeat",argAdmId,"GetOrderByINSUType","ITEM",DiagNo))'=1
			{
				s ^CacheTempDHCEPRDebug("CheckRepeat",argAdmId,"GetOrderByINSUType","ITEM",DiagNo)=Diag
			}
		}
	}
	

	f  s tmpNode=$o(^CacheTempDHCEPRDebug("CheckRepeat",argAdmId,"GetOrderByINSUType","ITEM",tmpNode)) quit:tmpNode=""  d
	. s Diag=$g(^CacheTempDHCEPRDebug("CheckRepeat",argAdmId,"GetOrderByINSUType","ITEM",tmpNode))
	. s DiagStr=DiagStr_"!"_Diag

	i (DiagStr'="") {
		s DiagStr=$e(DiagStr,2,$l(DiagStr))
	}	

	q DiagStr
}

/// Creator:	wangwentao
/// CreatDate:	20100225
/// Description:获取证件类型
/// Table:		[SQLUSER.PA_PatMas]PAPMI_CardType_DR -> [SQLUSER.PAC_CardType]CARD_Desc
ClassMethod CardType(argPapmiDR As %String) As %String
{
	q:($d(argPapmiDR)=0)||(argPapmiDR="") ""
	q:(($d(^PAPER(argPapmiDR,"ALL"))'=1)&&($d(^PAPER(argPapmiDR,"ALL"))'=11)) ""
	
	s CardTypeDR="",CARDDesc=""
	
	s CardTypeDR=$P($g(^PAPER(argPapmiDR,"ALL",3)),"^",7)
	if (CardTypeDR'="") 
	{
		s CARDDesc = $p($g(^PAC("CARD",CardTypeDR)),"^",2)
	}
	s CardType=CARDDesc
			
	q CardType
}

/// Creator:	wangwentao
/// CreatDate:	20100225
/// Description:获取证件号码
/// Table:		[SQLUSER.PA_PatMas]PAPMI_DVAnumber
ClassMethod CardNumber(argPapmiDR As %String) As %String
{
	q:($d(argPapmiDR)=0)||(argPapmiDR="") ""
	q:(($d(^PAPER(argPapmiDR,"ALL"))'=1)&&($d(^PAPER(argPapmiDR,"ALL"))'=11)) ""
	
	s CardNumber=""
	
	s CardNumber =$P($g(^PAPER(argPapmiDR,"ALL",3)),"^",6)
			
	q CardNumber
}

/// Desc: 护理组入院日期时间[护理组]
ClassMethod InhsAdmDateTime(Adm) As %String
{
	s ret=""
	q:(Adm="")
	
	s rw=0 
	f  s rw=$O(^DHCADMQTREC("adm",Adm,rw)) q:rw=""  d
	.s ADate=$P($G(^DHCADMQTREC("QTREC",rw)),"^",2)
	.//if ADate'="" s ADate=$ZD(ADate,3)
	.s ATime=$P($G(^DHCADMQTREC("QTREC",rw)),"^",3)
	.//if ATime'="" s ATime=$ZT(ATime,2)
	.//s TypDr=$P(^DHCADMQTREC("QTREC",rw),"^",4)
	.if TypDr'="" s Typ=$P(^DHCQTRECTYP("typ",TypDr),"^",2)
	.if (Typ="入院")&&(ADate'="")&&(ATime'="") s ret=ADate_","_ATime
	q ret
}

/// Desc: 获取检查项目结果
/// Test: w ##class(EPRservice.HISInterface.PatientInfoAssist).GetLabRs("63","A5309") 
ClassMethod GetLabRs(argEpisodeId As %String, argItemCode As %String) As %String
{
	s TCResult=""
    s ds = ##class(%Library.ResultSet).%New("DHCLabToEPR.DHCLabTestSetQuery:GetBloodItemByDebtorCode")
 	s sc=ds.Execute(argEpisodeId,argItemCode)
 	while(ds.Next())
  	{
   	s TCResult=ds.Data("TCResult")
  	}
  	d ds.Close()
  	q TCResult
}

/// Desc: 获取输血品种
/// Test: w ##class(EPRservice.HISInterface.PatientInfoAssist).GetBldPrdGrp(71)
ClassMethod GetBldPrdGrp(adm As %String) As %String
{
	Set rset = ##class(%ResultSet).%New("DHCLabToEPR.DHCLabTestSetQuery:DHCBldFindPatPack")
	Set columns = rset.GetColumnCount()
	
	// Execute the query
	Set sc = rset.Execute(adm)
    Set ItResult="",ItName="",ItValue="",ItUnit=""
    set RBC=0,Plt=0,Pls=0,Bld=0,Oth=0
	While(rset.Next())
	{
		s EPRName=""
		For col = 1:1:columns 
	 	{
		 s colName=rset.GetColumnName(col)
		 if (colName="Name")
		 {
			 s ItName=rset.GetData(col)
			 k SQLCODE
			 &sql(select ctmdictalias into :EPRName from eprmeta.customdictionary where ctmdictdesc=:ItName and ctmdictname='输血类别' and ctmdictstatus='Y')
			 q:(SQLCODE'=0)	
			 }
	     elseif (colName="Value")
	     {
		     s ItValue=rset.GetData(col)
		     }
		 elseif (colName="Units")
		 {
			 s ItUnit=rset.GetData(col)
			 }		 
		 }	
		 
		 if (EPRName="红细胞")
		 {
			 if (ItUnit="ml")
			 {
				 set ItValue=ItValue\200
				 }
			 set RBC=RBC+ItValue
			 }
		 elseif (EPRName="血小板")
		 {
			 if (ItUnit="ml")
			 {
				 set ItValue=ItValue\200
				 }
			 set Plt=Plt+ItValue
			 }
		 elseif (EPRName="血浆")
		 {
			 if (ItUnit="U")
			 {
				 set ItValue=ItValue*200
				 }
			 set Pls=Pls+ItValue
			 }
		 elseif (EPRName="全血")
		 {
			 if (ItUnit="U")
			 {
				 set ItValue=ItValue*200
				 }
			 Set Bld=Bld+ItValue
			 }
		 elseif (EPRName="其他")
		 {
			 if (ItUnit="U")
			 {
				 set ItValue=ItValue*200
				 }
			 Set Oth=Oth+ItValue
			 }	 
		
	 }
	 
	 Do rset.Close()
	 //红细胞，血小板，血浆，全血，其他
	 Set ItResult=RBC_"^"_Plt_"^"_Pls_"^"_Bld_"^"_Oth
	 Q ItResult
}

/// Creator: wangwentao HNZLYY
/// Desc: 引用 web.DHCBldReqLabInfo
/// Output: BG_"^"_Rh_"^"_RBC_"^"_HCT_"^"_HGB_"^"_PLT_"^"_ALT_"^"_HBsAg_"^"_AntiHBs_"^"_HBeAg_"^"_AntiHBe_"^"_AntiHBc_"^"_AntiHCV_"^"_AntiHIV_"^"_MD
/// Test: w ##class(EPRservice.HISInterface.PatientInfoAssist).GetLabBldInfo(50035)
ClassMethod GetLabBldInfo(admId As %String, LabItemID As %String = "") As %String
{
	
	s SpaceHIS=##class(EPRmeta.SysOption).GetOptionValueByName("NameSpaceHIS")
	if SpaceHIS'=""
	{
		s MEDDATA = $p($g(SpaceHIS),"^",1)
		s WEBSRC  = $p($g(SpaceHIS),"^",2)
	}
	s SpaceLIS=##class(EPRmeta.SysOption).GetOptionValueByName("NameSpaceLIS")
	if SpaceLIS'=""
	{
	    s LABDATA = $p($g(SpaceLIS),"^",1)
	    s LABSRC  = $p($g(SpaceLIS),"^",2)
	 }

	s papmiId=+^PAADM(admId)
	s debtorDR=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
 
  ZN LABDATA		
  s bldGpId=""
  i $d(^TDEB(debtorDR)) s bldGpId=$p(^TDEB(debtorDR),"\",4)
  i '$l(bldGpId),$d(^TDEB(debtorDR)) s bldGpId=$p(^TDEB(debtorDR),"\",10)
  s BG="",Rh=""
  i $l(bldGpId) d
  .s BG=$p(^TTAB("BB-BG",bldGpId),"\",2)_"型"
  .i $p(^TTAB("BB-BG",bldGpId),"\",3)="P" s Rh="阳性(+)"
  .i $p(^TTAB("BB-BG",bldGpId),"\",3)="N" s Rh="阴性(-)"
  s dt=0,RBC=""
  s res=$$getResult(debtorDR,"A0020")
  i $l(res) d
  .i +$p(res,"^",1)>dt s RBC=$p(res,$c(1),2),dt=+$p(res,"^",1)
  
  s dt=0,HCT=""
  s res=$$getResult(debtorDR,"A0040")
  i $l(res) d
  .i +$p(res,"^",1)>dt s HCT=$p(res,$c(1),2),dt=+$p(res,"^",1)
  
  s dt=0,HGB=""
  s res=$$getResult(debtorDR,"A0030")
  i $l(res) d
  .i +$p(res,"^",1)>dt s HGB=$p(res,$c(1),2),dt=+$p(res,"^",1)

  ;HNZLYY PLT	A0120	G0090
  s dt=0,PLT=""
  s res=$$getResult(debtorDR,"A0080")
  i $l(res) d
  .i +$p(res,"^",1)>dt s PLT=$p(res,$c(1),2),dt=+$p(res,"^",1)

  ;HNZLYY ALT	B0010	G0920
  s dt=0,ALT=""
  s res=$$getResult(debtorDR,"B0310")
  i $l(res) d
  .i +$p(res,"^",1)>dt s ALT=$p(res,$c(1),2),dt=+$p(res,"^",1)

  ;HNZLYY HBsAg	C0010
  s dt=0,HBsAg=""
  s res=$$getResult(debtorDR,"B0950")
  i $l(res) d
  .i +$p(res,"^",1)>dt s HBsAg=$p(res,$c(1),2),dt=+$p(res,"^",1)
  
  ;HNZLYY HBsAb	C0020
  s dt=0,AntiHBs=""
  s res=$$getResult(debtorDR,"B0960")
  i $l(res) d
  .i +$p(res,"^",1)>dt s AntiHBs=$p(res,$c(1),2),dt=+$p(res,"^",1)
  
  ;HNZLYY HBeAg	C0030
  s dt=0,HBeAg=""
  s res=$$getResult(debtorDR,"B0970")
  i $l(res) d
  .i +$p(res,"^",1)>dt s HBeAg=$p(res,$c(1),2),dt=+$p(res,"^",1)
  
  ;HNZLYY HBeAb	C0040
  s dt=0,AntiHBe=""
  s res=$$getResult(debtorDR,"B0980")
  i $l(res) d
  .i +$p(res,"^",1)>dt s AntiHBe=$p(res,$c(1),2),dt=+$p(res,"^",1)
  
  ;HNZLYY HBcAb	C0050
  s dt=0,AntiHBc=""
  s res=$$getResult(debtorDR,"B0990")
  i $l(res) d
  .i +$p(res,"^",1)>dt s AntiHBc=$p(res,$c(1),2),dt=+$p(res,"^",1)
  
  ;HNZLYY Anti-HCV	C0070
  s dt=0,AntiHCV=""
  s res=$$getResult(debtorDR,"B0910")
  i $l(res) d
  .i +$p(res,"^",1)>dt s AntiHCV=$p(res,$c(1),2),dt=+$p(res,"^",1)
  
  ;HNZLYY Anti-HIV	C0420
  s dt=0,AntiHIV=""
  s res=$$getResult(debtorDR,"B0920")
  i $l(res) d
  .i +$p(res,"^",1)>dt s AntiHIV=$p(res,$c(1),2),dt=+$p(res,"^",1)
  
  ;HNZLYY 梅毒	C0530
  s dt=0,MD=""
  s res=$$getResult(debtorDR,"B0930")
  i $l(res) d
  .i +$p(res,"^",1)>dt s MD=$p(res,$c(1),2),dt=+$p(res,"^",1)
  
  zn WEBSRC
  
  s retStr=BG_"^"_Rh_"^"_RBC_"^"_HCT_"^"_HGB_"^"_PLT_"^"_ALT_"^"_HBsAg_"^"_AntiHBs_"^"_HBeAg_"^"_AntiHBe_"^"_AntiHBc_"^"_AntiHCV_"^"_AntiHIV_"^"_MD
  //s retval=itmjs_"('"_$ZCVT(retStr,"O","JS")_"');"
 // &javascript<#(retval)#>
  q retStr

getResult(debtor,tc)  ;TrakCare
  s ret=""
  i '$d(^TDHCOldResult(1,debtor,tc)) q ret
  i $d(^TDHCOldResult(1,debtor,tc)) d
  .s dd=$o(^TDHCOldResult(1,debtor,tc,""),-1)
  .i '$l(dd) q
  .s tt=$o(^TDHCOldResult(1,debtor,tc,dd,""),-1)
  .i '$l(tt) q
  .s x1=$o(^TDHCOldResult(1,debtor,tc,dd,tt,""),-1)
  .i '$l(x1) q
  .s x2=$o(^TDHCOldResult(1,debtor,tc,dd,tt,x1,""),-1)
  .i '$l(x2) q
  .s x3=$o(^TDHCOldResult(1,debtor,tc,dd,tt,x1,x2,""),-1)
  .i '$l(x3) q
  .i '$d(^TEPI(x1,1,x2,x3,"DATA",tc)) q
  .s ret=$p(^TEPI(x1,1,x2,x3,"DATA",tc),"\",1)
   s itmtype=$p(^TTAB("TC",tc),"\",3)
   i itmtype["N" d    ;numeric
   .s decimal=$e(itmtype,2)
   .i decimal="" s decimal="0"
   .s temres=$$CheckResDecimal^CHDhcLabReport(ret,decimal)
   .s ret=temres_$c(1)_temres
   ;文本
   i itmtype["X" d
   .s ret=ret_$c(1)_ret
   ;标准备注
   i itmtype["S" d
   .s preres=""
   .i $l(ret),$d(^TTAB("TC",tc,2,ret,1))  d
   ..s preres=$g(^TTAB("TC",tc,2,ret,1))
   .s ret=ret_$c(1)_preres
   ;血型
   i itmtype["B" d
   .s preres=""
   .i $l(ret),$d(^TTAB("BB-BG",ret)) d
   ..s preres=$p(^TTAB("BB-BG",ret),"\",1)
   .s ret=ret_$c(1)_preres
   ;安贞阴阳性处理
   s unit=$p(^TTAB("TC",tc),"\",2)
   ;转换类型
   i $p(^TTAB("TC",tc),"\",7)="Y" d
   .s tret=ret
   .s ret="("_$$standdata(tc,x1,ret)_")"
   .s ret=tret_ret_$c(1)_ret
   ;i $l(ret) s ret=dd_tt_"^"_ret_" "_unit
   i $l(ret) s ret=dd_"^"_ret_" "_unit
   q ret


standdata(itmcode,labno,res)  ;求正常值 
  s itmcode=$g(itmcode),res=$g(res)
  s sex=$P($g(^TEPI(labno)),"\",3)
  s age=$P($g(^TEPI(labno)),"\",25)
  s age=+age
  i sex="" s sex="M"
  s itmcode=$g(itmcode) 
  s ranges=""
  s tvalue=$$ranges^LVBVIS1(itmcode,age,sex,"",0,"","")
  s lowvalue=$p(tvalue,$c(1),1)
  s hvalue=$p(tvalue,$c(1),2)
  i $tr(tvalue,$c(1))'="" d
  .s ranges="{"_lowvalue_"-"_hvalue_"}"
  .s ranges=$tr(ranges,$c(1))
  i res'="" d
  .s res=$tr(res,">,<")
  .i ranges'="" d
  ..i $p(^TTAB("TC",itmcode),"\",7)="Y" d
  ...s res1="0"
  ...//-----DaiYi-----湖南省肿瘤--2010-01-26
  ...i $f(ranges,"-")>0,$tr($p(ranges,"-",2),"}")>0 d
  ....s low=$tr($p(ranges,"-",1),"{"),high=$tr($p(ranges,"-",2),"}")
  ....i res<low s res1="1"
  ....i res>high s res1="1"
  ...If $Tr($Tr($Piece(ranges,"-",2),"}")," ")="",$Tr($Tr($Piece(ranges,"-",1),"{")," ")'="" d
  ....s low=$Tr($tr($p(ranges,"-",1),"{"),"<")
  ....i res>low s res1="1"
  ...//----------------------
  ...i $d(^TTAB("TC",itmcode,2,res1)),$d(^TTAB("TC",itmcode,2,res1,1)) d
  ....s ranges=^TTAB("TC",itmcode,2,res1,1)
  q ranges
}

/// Creator: Liaowp BJXHYY
/// Desc: 引用 web.DHCBldReqLabInfo
/// Output: BG_"^"_Rh_"^"_RBC_"^"_HCT_"^"_HGB_"^"_PLT_"^"_ALT_"^"_HBsAg_"^"_AntiHBs_"^"_HBeAg_"^"_AntiHBe_"^"_AntiHBc_"^"_AntiHCV_"^"_AntiHIV_"^"_MD
/// Test: w ##class(EPRservice.HISInterface.PatientInfoAssist).GetLabBldInfoNew(50035)
ClassMethod GetLabBldInfoNew(admId As %String, LabItemID As %String = "") As %String
{
	
	s SpaceHIS=##class(EPRmeta.SysOption).GetOptionValueByName("NameSpaceHIS")
	if SpaceHIS'=""
	{
		s MEDDATA = $p($g(SpaceHIS),"^",1)
		s WEBSRC  = $p($g(SpaceHIS),"^",2)
	}
	s SpaceLIS=##class(EPRmeta.SysOption).GetOptionValueByName("NameSpaceLIS")
	if SpaceLIS'=""
	{
	    s LABDATA = $p($g(SpaceLIS),"^",1)
	    s LABSRC  = $p($g(SpaceLIS),"^",2)
	 }

	s papmiId=+^PAADM(admId)
	s debtorDR=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
 
  ZN LABDATA		
  s bldGpId=""
  i $d(^TDEB(debtorDR)) s bldGpId=$p(^TDEB(debtorDR),"\",4)
  i '$l(bldGpId),$d(^TDEB(debtorDR)) s bldGpId=$p(^TDEB(debtorDR),"\",10)
  s BG="",Rh=""
  i $l(bldGpId) d
  .s BG=$p(^TTAB("BB-BG",bldGpId),"\",2)_"型"
  .i $p(^TTAB("BB-BG",bldGpId),"\",3)="P" s Rh="阳性(+)"
  .i $p(^TTAB("BB-BG",bldGpId),"\",3)="N" s Rh="阴性(-)"
  s dt=0,RBC=""
  ;s res=$$getResult(debtorDR,"A0020")
  ;i $l(res) d
  ;.i +$p(res,"^",1)>dt s RBC=$p(res,$c(1),2),dt=+$p(res,"^",1)
  
  s dt=0,HCT=""
  ;s res=$$getResult(debtorDR,"A0040")
  ;i $l(res) d
  ;.i +$p(res,"^",1)>dt s HCT=$p(res,$c(1),2),dt=+$p(res,"^",1)
  
  s dt=0,HGB=""
  ;s res=$$getResult(debtorDR,"A0030")
  ;i $l(res) d
  ;.i +$p(res,"^",1)>dt s HGB=$p(res,$c(1),2),dt=+$p(res,"^",1)
  
  s BG="",Rh="",PLT="",ALT="",HBsAg="",AntiHBs="",HBeAg="",AntiHBe="",AntiHBc="",AntiHCV="",AntiHIV="",MD=""
  ;ABO 
  s BG=$$GetTCResultByRegNo^LabServiceTCResult(debtorDR,"ABO",30)
  s BG=$TR(BG,$C(2))
  
  ;Rh
  s Rh=$$GetTCResultByRegNo^LabServiceTCResult(debtorDR,"Rh",30)
  s Rh=$TR(Rh,$C(2))

  ;ALT	0001  
  s ALT=$$GetTCResultByRegNo^LabServiceTCResult(debtorDR,"0001",30)
  s ALT=$TR(ALT,$C(2))

  ;HBsAg  0534
  s HBsAg=$$GetTCResultByRegNo^LabServiceTCResult(debtorDR,"0203",30)
  s HBsAg=$TR(HBsAg,$C(2))
  
  ;HBsAb  0532
  s HBsAb=$$GetTCResultByRegNo^LabServiceTCResult(debtorDR,"0532",30)
  s HBsAb=$TR(HBsAb,$C(2))
  
  ;HBeAg  0528
  s HBeAg=$$GetTCResultByRegNo^LabServiceTCResult(debtorDR,"0528",30)
  s HBeAg=$TR(HBeAg,$C(2))
  
  ;HBeAb  0526
  s HBeAb=$$GetTCResultByRegNo^LabServiceTCResult(debtorDR,"0526",30)
  s HBeAb=$TR(HBeAb,$C(2))
  
  ;HBcAb  0524
  s HBcAb=$$GetTCResultByRegNo^LabServiceTCResult(debtorDR,"0524",30)
  s HBcAb=$TR(HBcAb,$C(2))
  
  ;Anti-HCV	0522
  s AntiHCV=$$GetTCResultByRegNo^LabServiceTCResult(debtorDR,"0522",30)
  s AntiHCV=$TR(AntiHCV,$C(2))
  
  ;Anti-HIV	0318
  s AntiHIV=$$GetTCResultByRegNo^LabServiceTCResult(debtorDR,"0318",30)
  s AntiHIV=$TR(AntiHIV,$C(2))

  
  ;梅毒	0267
  s MD=$$GetTCResultByRegNo^LabServiceTCResult(debtorDR,"0205",30)
  ;s MD=$$GetTCResultByRegNo^LabServiceTCResult(debtorDR,"1787",30)
  s MD=$TR(MD,$C(2))
  
  zn WEBSRC
  
  s retStr=BG_"^"_Rh_"^"_RBC_"^"_HCT_"^"_HGB_"^"_PLT_"^"_ALT_"^"_HBsAg_"^"_HBsAb_"^"_HBeAg_"^"_HBeAb_"^"_HBcAb_"^"_AntiHCV_"^"_AntiHIV_"^"_MD
  //s retval=itmjs_"('"_$ZCVT(retStr,"O","JS")_"');"
 // &javascript<#(retval)#>
  q retStr
}

/// 取按小时计费医嘱的持续小时数
/// w ##class(web.DHCXPTest4).GetOrderHours(233,"1743||1")
ClassMethod GetOrderHours(EpisodeID, ArcimRowid)
{
	s OrderHours=0
	s OrderRowid=$o(^OEORD(0,"Adm",EpisodeID,""))
	q:OrderRowid="" ""
	s SttDate=0
	s Childsub=0
	f  s SttDate=$o(^OEORDi(0,"ARCIM",OrderRowid,ArcimRowid,SttDate)) q:SttDate=""  d
	.f  s Childsub=$o(^OEORDi(0,"ARCIM",OrderRowid,ArcimRowid,SttDate,Childsub)) q:Childsub=""  d
	..s SttTime=$p($g(^OEORD(OrderRowid,"I",Childsub,1)),"^",10)
	..s Xtime=$p($g(^OEORD(OrderRowid,"I",Childsub,2)),"^",15)
	..i Xtime="" s Xtime=$p($h,",",2)
	..i Xtime<SttTime s Xtime=SttTime
	..s DuraHours=$fn((Xtime-SttTime)/3600,"",0)
	..s OrderHours=OrderHours+DuraHours
	q OrderHours
}

/// Creator:	wangwentao
/// CreatDate:	2011-08-31
/// Description:获取病人就诊列表
/// Input:		APatientID 
/// 			AType就诊类型 I O E
/// Output:		/
/// Return:		/
/// Others:		医科院肿瘤医院 内科病历
/// Example:	##Class(EPRservice.HISInterface.PatientInfoAssist).GetEpisodeListByType(919332,"I")
ClassMethod GetEpisodeListByType(AAdmID As %String, APatientID As %String, AType As %String) As %String
{
	q:(($d(AAdmID)=0)||(AAdmID="")) ""
	q:(($d(APatientID)=0)||(APatientID="")) ""
	q:(($d(AType)=0)||(AType="")) ""
	
	set typeRowID = "0" ,ind =1
	set (ret ,data ,InTimes ,AdmDateTimeInBed ,AdmDateInBed ,DisDateTime ,DisDate) =""
	
	s Hospital=##class(EPRmeta.SysOption).GetOptionValueByName("HospitalName")
	
	for {
	 	set typeRowID = $o(^PAPERdr(APatientID,"ADM",typeRowID))
	 	q:(typeRowID = "")
	 	
	 	set episodeID = "0"
	 	for {
		 	s episodeID = $o(^PAPERdr(APatientID,"ADM",typeRowID,episodeID))
		 	q:(episodeID = "")
		 	
		 	//筛选住院病人		   
			set episodeType= $p($g(^PAADM(episodeID)),"^",2)
			continue:(episodeType'=AType)
			
			//筛选访问状态Cancel病人  //wangwentao 20130118 add	   
			set VisitStatus= $p($g(^PAADM(episodeID)),"^",20)
			Continue:(VisitStatus="C")
					 	
		 	// 入院次数			[InTimes]
		 	s InTimes=##Class(EPRservice.HISInterface.PatientInfoAssist).InTimes(episodeID,Hospital)
		 	
			// 入院分床日期 	[AdmDateInBed]					
			s AdmDateTimeInBed=##class(EPRservice.HISInterface.PatientInfoAssist).AdmDateTimeInBed(episodeID)
			i AdmDateTimeInBed'="" 
			{
				s AdmDateInBed = $ZD($P($G(AdmDateTimeInBed),",",1),3)
				//s AdmTimeInBed = $ZT($P($G(AdmDateTimeInBed),",",2),1)
				//s AdmDateTimeInBed=AdmDateInBed_" "_AdmTimeInBed
			}
			
			// 出院日期 		[DisDate]
			s DisDateTime=##class(EPRservice.HISInterface.PatientInfoAssist).DisDateTime(episodeID)
			if DisDateTime'="" 
			{ 
				s DisDate = $ZD($P($G(DisDateTime),",",1),3)
				//s DisTime = $ZT($P($G(DisDateTime),",",2),1)
				//s DisDateTime=DisDate_" "_DisTime
			}
			else
			{
				s DisDate = ""
			}
			
			//构建结果 格式 第N次住院 yyyy-mm-dd 至 yyyy-mm-dd
			//if (AdmDateInBed'="")&&(DisDate'="")
			//{
				set data = "第"_InTimes_"次住院"_" "_AdmDateInBed_" "_"至"_" "_DisDate
				set:(DisDate="") data=$e(data,1,$L(data)-2)
				set ret = ret_$c(13,10)_data
				set:(ind=1) ret = data
			//}
			
			//计数器去掉第1个$c(13,10)
			set ind = ind+1	
			
			//筛选数据截至当前的episodeID
			quit:(episodeID=AAdmID)		
	 	}
	}

	q ret
}

/// Desc:	入院医生级别
/// Output:	AUserID is ssusr_rowid
/// Table:	
ClassMethod AdmDoctorLevel(AUserID As %String, argHospital As %String = "") As %String
{
	q:(($d(AUserID)=0)||(AUserID="")) ""
	s admdoctorlevel=""
	
	
	&SQL(select UserLevel into :admdoctorlevel from EPRmeta_Privilege.PowerUser where UserID = :AUserID  )

 
	q admdoctorlevel
}

/// Desc:	入院医生职称
/// Output:	AUserID is ssusr_rowid
/// Table:	SQLUser.CT_CArPrvTp
/// SS_USER.SSUSR_CareProv_DR
/// CT_CareProv.CTPCP_CarPrvTp_DR
/// CT_CArPrvTp.CTCPT_InternalType
/// CT_CArPrvTp.CTCPT_Desc
ClassMethod AdmDoctorTitle(argAdmId As %String, argHospital As %String = "") As %String
{
	q:(($d(argAdmId)=0)||(argAdmId="")) ""
	
	s (AdmDoctorTitle,SSUSRCareProvDR,CTPCPCarPrvTpDR,CTCPTInternalType,CTCPTDesc) =""

	s SSUSRCareProvDR=..AdmDoctor(argAdmId)
	s:(SSUSRCareProvDR'="") SSUSRCareProvDR=$P(SSUSRCareProvDR,"^")
	if SSUSRCareProvDR'=""
	{
		s CTPCPCarPrvTpDR=$P($g(^CTPCP(SSUSRCareProvDR,1)),"^",4)
		if CTPCPCarPrvTpDR'=""
		{
			s CTCPTInternalType=$P($g(^CT("CPT",CTPCPCarPrvTpDR)),"^",4)
			s:(CTCPTInternalType="DOCTOR") CTCPTDesc =$P($g(^CT("CPT",CTPCPCarPrvTpDR)),"^",2)
		}
		s AdmDoctorTitle=CTCPTDesc
	}
	 
	q AdmDoctorTitle
}

/// Creator:	wangwentao
/// CreatDate:	2011-09-04
/// Description:通过化疗方案ID获取化疗药物
/// Input:		ASolutionID
/// Output:		/
/// Return:		/
/// Others:		医科院肿瘤医院 化疗观察表 
/// Example:	##Class(EPRservice.HISInterface.PatientInfoAssist).GetChemoDrugBySolutionID(1)
ClassMethod GetChemoDrugBySolutionID(ASolutionID As %String) As %String
{
	q:($d(ASolutionID)=0)||(ASolutionID="") ""
	
	s (DrugList,DrugString,DrugItem,ACode,ADesc,AID) =""
	
	&sql(declare DrugList cursor for 
			select CtmDictCode,CtmDictDesc,CtmDictID into :ACode,:ADesc,:AID 
			from EPRmeta.CustomDictionary
			where CtmDictType ='Chemotherapeutics' and CtmDictStatus='Y'  )
	&sql(open DrugList)
	for  &sql(fetch DrugList) Quit:SQLCODE  Do
	.//b "s"
	.if $f(AID,"^"_ASolutionID_"^")>0 {s DrugItem=ACode_"^"_$e(ADesc,$f(ADesc,"-"),$l(ADesc)),DrugString=DrugString_"#"_DrugItem}
	&sql(close DrugList) 

	s DrugString = $e(DrugString,2,$l(DrugString))
	
	q DrugString
}

/// Creator:	wangwentao
/// CreatDate:	20111012
/// Description:获取医嘱项目数量通过医嘱子类 目前支持取15个医医嘱子类相应医嘱项目的数量
/// Table:		/
/// Input:		argAdmId是病人就诊ID[PA_Adm表RowID]// argCategory是医嘱子类ID[ARC_ItemCat表RowID]// argHospital是医院标识
/// Output:		/
/// Return:		CurrentOrdItem
/// Others:		&sql(select top 1 * from OE_OrdItem where oeori_oeord_parref ='50594' and OEORI_ItmMast_DR -> arcim_itemcat_dr = '217' and OEORI_ItemStat_DR <>'4' )
/// 			OE_OrdItem	^OEORD({OE_Order.OEORD_RowId},"I",{OEORI_Childsub}) 
/// 			OE_Order		^OEORD(0,"Adm",{OEORD_Adm_DR},{OEORD_RowId})
/// 			[ARC_ItmMast]OE_OrdItem.OEORI_ItmMast_DR->[ARC_ItemCat]ARC_ItmMast.ARCIM_ItemCat_DR				
/// 			[ARC_ItmMast.ARCIM_ItemCat_DR	1	10]^ARCIM({ARCIM_Subscript},{ARCIM_Version}) 
/// 			[ARC_ItmMast.ARCIM_Desc	    1	2] ^ARCIM({ARCIM_Subscript},{ARCIM_Version}) 
/// 			[OE_OrdItem.OEORI_ItemStat_DR	1	13]^OEORD({OE_Order.OEORD_RowId},"I",{OEORI_Childsub})  
/// 						
/// Example:	w ##Class(EPRservice.SystemData).GetOrdItemCountByItemCat(171380,47)
ClassMethod GetOrdItemCountByItemCat(argAdmId As %String, argCategoryStr As %String, argHospital As %String = "") As %String
{
	
	//完整性判断
	q:($d(argAdmId)=0)||(argAdmId="") ""
	q:($d(argCategoryStr)=0)||(argCategoryStr="") ""
	
	//定义返回值
	s OrdItemCount =""
	s (OIC01,OIC02,OIC03,OIC04,OIC05,OIC06,OIC07,OIC08,OIC09,OIC10,OIC11,OIC12,OIC13,OIC14,OIC15)=0
	
	//定义变量
	s OEORDRowId="",OEORIChdsub="",OEORIItmMastDR="",OEORIItmMastDRsub="",ARCIMItemCatDR="",OEORIItemStatDR="",ARCIMDesc=""

	//程序处理
    f  s OEORDRowId=$o(^OEORD(0,"Adm",argAdmId,OEORDRowId)) q:(OEORDRowId="")  d
    . //b "s"
    . //Get Max OEORIChdsub Add 1
    . s OEORIChdsub=$g(^OEORD(OEORDRowId,"I",0))+1
	. f  s OEORIChdsub=$o(^OEORD(OEORDRowId,"I",OEORIChdsub),-1) q:(OEORIChdsub="")  d
	  .. //b "s"
	  .. //Get OE_OrdItem.OEORI_ItmMast_DR[ARC_ItmMast]
	  .. s OEORIItmMastDR= $p($g(^OEORD(OEORDRowId,"I",OEORIChdsub,1)),"^",2)
	  .. q:(OEORIItmMastDR="")
	  .. s OEORIItmMastDRsub=$p(OEORIItmMastDR,"||",1)
	  .. //Get OE_OrdItem.ARCIM_ItemCat_DR[ARC_ItemCat]
	  .. s ARCIMItemCatDR=$p($g(^ARCIM(OEORIItmMastDRsub,1,1)),"^",10)
	  .. q:($f(argCategoryStr,"^"_ARCIMItemCatDR_"^")=0)
	  .. //Get OE_OrdItem.OEORI_ItemStat_DR[OEC_OrderStatus]
	  .. s OEORIItemStatDR=$p($g(^OEORD(OEORDRowId,"I",OEORIChdsub,1)),"^",13)
	  .. q:(OEORIItemStatDR=2)||(OEORIItemStatDR=4)||(OEORIItemStatDR=10)
	  .. //b
	  .. s:($f($p(argCategoryStr,"@",1),"^"_ARCIMItemCatDR_"^")'=0) OIC01=OIC01+1
	  .. s:($f($p(argCategoryStr,"@",2),"^"_ARCIMItemCatDR_"^")'=0) OIC02=OIC02+1
	  .. s:($f($p(argCategoryStr,"@",3),"^"_ARCIMItemCatDR_"^")'=0) OIC03=OIC03+1
	  .. s:($f($p(argCategoryStr,"@",4),"^"_ARCIMItemCatDR_"^")'=0) OIC04=OIC04+1
	  .. s:($f($p(argCategoryStr,"@",5),"^"_ARCIMItemCatDR_"^")'=0) OIC05=OIC05+1
	  .. s:($f($p(argCategoryStr,"@",6),"^"_ARCIMItemCatDR_"^")'=0) OIC06=OIC06+1
	  .. s:($f($p(argCategoryStr,"@",7),"^"_ARCIMItemCatDR_"^")'=0) OIC07=OIC07+1
	  .. s:($f($p(argCategoryStr,"@",8),"^"_ARCIMItemCatDR_"^")'=0) OIC08=OIC08+1
	  .. s:($f($p(argCategoryStr,"@",9),"^"_ARCIMItemCatDR_"^")'=0) OIC09=OIC09+1
	  .. s:($f($p(argCategoryStr,"@",10),"^"_ARCIMItemCatDR_"^")'=0) OIC10=OIC10+1
	  .. s:($f($p(argCategoryStr,"@",11),"^"_ARCIMItemCatDR_"^")'=0) OIC11=OIC11+1
	  .. s:($f($p(argCategoryStr,"@",12),"^"_ARCIMItemCatDR_"^")'=0) OIC12=OIC12+1
	  .. s:($f($p(argCategoryStr,"@",13),"^"_ARCIMItemCatDR_"^")'=0) OIC13=OIC13+1
	  .. s:($f($p(argCategoryStr,"@",14),"^"_ARCIMItemCatDR_"^")'=0) OIC14=OIC14+1
	  .. s:($f($p(argCategoryStr,"@",15),"^"_ARCIMItemCatDR_"^")'=0) OIC15=OIC15+1
	  .. //b

	s OrdItemCount = OIC01_"^"_OIC02_"^"_OIC03_"^"_OIC04_"^"_OIC05_"^"_OIC06_"^"_OIC07_"^"_OIC08_"^"_OIC09_"^"_OIC10_"^"_OIC11_"^"_OIC12_"^"_OIC13_"^"_OIC14_"^"_OIC15
	//b
	
	//返回医嘱项目数量
	q OrdItemCount
}

/// Creator:	wangwentao
/// CreatDate:	20111215
/// Description:处理放疗科诊断格式串,用于打印模板显示条件控制。
/// Table:		/
/// Input:		argAdmId是病人就诊ID[PA_Adm表RowID]//  argHospital是医院标识
/// Output:		/
/// Return:		DiagDisplaySite
/// Others:		位置一是第1条诊断,位置二是分期相关,位置三是第2条及后续诊断. 再由于诊断为层次结构,不能确定第1条诊断包含几条子诊断,故采用程序处理.		
/// Example:	w ##Class(EPRservice.HISInterface.PatientInfoAssist).GetDiagSiteByLevelFlag(1600390,"YKYZLYY")
ClassMethod GetDiagSiteByLevelFlag(argAdmId As %String, argHospital As %String = "") As %String
{
	
	//完整性判断
	q:($d(argAdmId)=0)||(argAdmId="") ""
	
	s DiagDisplaySite = "N^N^N^N^N^N^N^N^N^N^N^N^N^N" , LevFlag=""
	s (LevFlag2,LevFlag3,LevFlag4,LevFlag5,LevFlag6,LevFlag7,LevFlag8,LevFlag9,LevFlag10,LevFlag11,LevFlag12,LevFlag13,LevFlag14,LevFlag15) =""
	
	if argHospital=..#HospitalYKYZLYY
	{
		s LevFlag2 = ##class(EPRservice.BOScatterData).GetEPRData(argAdmId, "诊断2控制项.M0020^#TYPE:Simple#TID:113#TVER:0#SCODE:M0020#VTYPE:V")
		s LevFlag3 = ##class(EPRservice.BOScatterData).GetEPRData(argAdmId, "诊断3控制项.M0031^#TYPE:Simple#TID:113#TVER:0#SCODE:M0031#VTYPE:V")
		s LevFlag4 = ##class(EPRservice.BOScatterData).GetEPRData(argAdmId, "诊断4控制项.M0033^#TYPE:Simple#TID:113#TVER:0#SCODE:M0033#VTYPE:V")
		s LevFlag5 = ##class(EPRservice.BOScatterData).GetEPRData(argAdmId, "诊断5控制项.M0032^#TYPE:Simple#TID:113#TVER:0#SCODE:M0032#VTYPE:V")
		s LevFlag6 = ##class(EPRservice.BOScatterData).GetEPRData(argAdmId, "诊断6控制项.M0030^#TYPE:Simple#TID:113#TVER:0#SCODE:M0030#VTYPE:V")
		s LevFlag7 = ##class(EPRservice.BOScatterData).GetEPRData(argAdmId, "诊断7控制项.M0029^#TYPE:Simple#TID:113#TVER:0#SCODE:M0029#VTYPE:V")
		s LevFlag8 = ##class(EPRservice.BOScatterData).GetEPRData(argAdmId, "诊断8控制项.M0022^#TYPE:Simple#TID:113#TVER:0#SCODE:M0022#VTYPE:V")
		s LevFlag9 = ##class(EPRservice.BOScatterData).GetEPRData(argAdmId, "诊断9控制项.M0028^#TYPE:Simple#TID:113#TVER:0#SCODE:M0028#VTYPE:V")
		s LevFlag10 = ##class(EPRservice.BOScatterData).GetEPRData(argAdmId, "诊断10控制项.M0027^#TYPE:Simple#TID:113#TVER:0#SCODE:M0027#VTYPE:V")
		s LevFlag11 = ##class(EPRservice.BOScatterData).GetEPRData(argAdmId, "诊断11控制项.M0026^#TYPE:Simple#TID:113#TVER:0#SCODE:M0026#VTYPE:V")
		s LevFlag12 = ##class(EPRservice.BOScatterData).GetEPRData(argAdmId, "诊断12控制项.M0025^#TYPE:Simple#TID:113#TVER:0#SCODE:M0025#VTYPE:V")
		s LevFlag13 = ##class(EPRservice.BOScatterData).GetEPRData(argAdmId, "诊断13控制项.M0024^#TYPE:Simple#TID:113#TVER:0#SCODE:M0024#VTYPE:V")
		s LevFlag14 = ##class(EPRservice.BOScatterData).GetEPRData(argAdmId, "诊断14控制项.M0023^#TYPE:Simple#TID:113#TVER:0#SCODE:M0023#VTYPE:V")
		s LevFlag15 = ##class(EPRservice.BOScatterData).GetEPRData(argAdmId, "诊断15控制项.M0021^#TYPE:Simple#TID:113#TVER:0#SCODE:M0021#VTYPE:V")
	}

	s LevFlagStr = LevFlag2_"^"_LevFlag3_"^"_LevFlag4_"^"_LevFlag5_"^"_LevFlag6_"^"_LevFlag7_"^"_LevFlag8_"^"_LevFlag9_"^"_LevFlag10_"^"_LevFlag11_"^"_LevFlag12_"^"_LevFlag13_"^"_LevFlag14_"^"_LevFlag15
	
	s StrLen=$l(LevFlagStr)
	for i=1:1:StrLen
	{
		s LevFlag=$p(LevFlagStr,"^",i)
		s:(LevFlag'="") $p(DiagDisplaySite,"^",i)="Y"
		q:(LevFlag="")
	}

	//返回放疗科诊断格式
	q DiagDisplaySite
}

/// Desc:	当前住院天数
/// Input:	argAdmId: 病人就诊RowID，argHospital:医院标识
/// Output:	天数
/// Others:	not different from hospitals
ClassMethod ResidentDaysCurrent(argAdmId As %String, argHospital As %String = "") As %String
{
	q:($d(argAdmId)=0)||(argAdmId="") ""
	//q:($d(argHospital)=0)||(argHospital="") ""
	
	s papmidr="",DeathDateTime="",AdmDateTime="",DisDateTimeMR="",DisDateTime=""
	s admdate="",admtime="",dischgdate="",dischgtime=""
	s residentdays=""

	//取PapmiDR
	q:(($d(^PAADM(argAdmId))'=1)&&($d(^PAADM(argAdmId))'=11)) ""
	s papmidr = ..GetPapmiDR(argAdmId)
	
	
	//取入院日期(护士分床)
	s AdmDateTimeInBed=..AdmDateTimeInBed(argAdmId)
	if AdmDateTimeInBed'="" 
	{
		s admdate=$p($g(AdmDateTimeInBed),",",1)
	}
	
	//出院日期取值判断  死亡日期->出院日期(统计组)->出院日期(护士结算)
	

	//取当前日期
	s dischgdate= $p($h,",")
	
	
	q:((admdate="")||(dischgdate="")) ""
	
	//计算住院天数
	s residentdays = ..ResidentDays(admdate,dischgdate)

	q residentdays
}

/// Creator:	wangwentao
/// CreatDate:	20120220
/// Description:取可重复模板上的数据
/// Table:		/
/// Input:		argAdmId,argChartItemID,argMultiCodeStr
/// Output:		RetMultiDataString
/// Return:		
/// Others:		/
/// Example:	w ##Class(EPRservice.HISInterface.PatientInfoAssist).GetMultiDataByChartItemID(50729,1)
ClassMethod GetMultiDataByChartItemID(argAdmId As %String, argChartItemID As %String, argMultiCodeStr As %String) As %String
{
	q:($d(argAdmId)=0)||(argAdmId="") ""
	q:($d(argChartItemID)=0)||(argChartItemID="") ""
	q:($d(argMultiCodeStr)=0)||(argMultiCodeStr="") ""
	
	//返回值
    s RetMultiDataString=""
    
    //变量
    s (TheECRecordID,ListNoMax,LastInstanceID,CurMultiCode,CurMultiData)=""
    
	s TheECRecordID = ##class(EPRinstance.ECRecord).GetECRecordID("", argAdmId, argChartItemID)
	q:(TheECRecordID="") ""
	
	//wangwentao 20120309 update
	//s ListNoMax = $g(^DHCEPRI.ECRecordD(TheECRecordID,"Instances"))
	s ListNoMax = $o(^DHCEPRI.ECRecordD(TheECRecordID,"Instances",""),-1)
	//wangwentao 20120309 update close
	
	q:(ListNoMax="") ""
	
	s LastInstanceID = TheECRecordID_"||"_ListNoMax
	

	f ind=1:1:$l(argMultiCodeStr,"!")
	{
		s CurMultiCode=$p(argMultiCodeStr,"!",ind)
		
		s CurMultiData= ##class(EPRservice.BOScatterData).GetEPRMultipleData(argAdmId,CurMultiCode,LastInstanceID)
		
		//s:(CurMultiData'="") RetMultiDataString = RetMultiDataString_"|"_CurMultiData
		//s:(CurMultiData'="")&&(ind=1) RetMultiDataString = CurMultiData
		
		s RetMultiDataString = RetMultiDataString_"|"_CurMultiData
		s:(ind=1) RetMultiDataString = CurMultiData

		//初始化
		s CurMultiData=""
	}

    q RetMultiDataString
}

/// Desc:	新病案费用信息：按照费用大类 一般24项
/// Output：
/// Others：
ClassMethod InPatCostTrakCareNew(argAdmId As %String, argHospital As %String = "") As %String
{
	// 依照病案大类取费用(SQL:DHC_TarMc )(Global：^DHCTarC("TMC",rowid) )
	q:(($d(argAdmId)=0)||(argAdmId="")) ""

		s UniqueId=""
		s UniqueId=$i(^CacheTemp)
		k ^CacheTempPatMcCate(UniqueId),PLIST
		
		// 取费用大类信息
		s n=1
		s rowid="0"
		f  s rowid=$o(^DHCTarC("TMCNew",rowid))  q:rowid=""  d
		.i $g(^CacheTempPatMcCate(UniqueId))="" s ^CacheTempPatMcCate(UniqueId)=0
		.i $p(^DHCTarC("TMCNew",rowid),"^",1)'="" d
		..s acctdesc=$p($p(^DHCTarC("TMCNew",rowid),"^",1),$c(1))  //DHC_TarMc  -> TARTMC_Code
		..s acctdesc2=$p($p(^DHCTarC("TMCNew",rowid),"^",2),$c(1)) //DHC_TarMc  -> TARTMC_Desc
		..s ^CacheTempPatMcCate(UniqueId,n)=$p(rowid,$c(1))_"^"_acctdesc_"^"_acctdesc2
		..s ^CacheTempPatMcCate(UniqueId)=n
		..s PLIST(n)=acctdesc
		..s n=n+1
	
		// 初始化
		s argAdmId=$g(argAdmId)
		q:(argAdmId="") 0
		s sum=0, P9=""
		f i=1:1:$g(^CacheTempPatMcCate(UniqueId)) d
		.s itmfee(i)=0
		
		// 将病人费用按费用大类归并
		s rowid=""
		f  s rowid=$o(^DHCPB(0,"ADM",argAdmId,rowid))  q:rowid=""  d
		.s pboid=""
		.f  s pboid=$o(^DHCPB(rowid,"O",pboid))  q:pboid=""  d
		..s pbdid="0"
		..f  s pbdid=$o(^DHCPB(rowid,"O",pboid,"D",pbdid))  q:pbdid=""  d
		...s taritem=$p(^DHCPB(rowid,"O",pboid,"D",pbdid),"^",3)     
		...s unitprice=$p(^DHCPB(rowid,"O",pboid,"D",pbdid),"^",4)   
		...s qty=$p(^DHCPB(rowid,"O",pboid,"D",pbdid),"^",5)         
		...s totalamount=$p(^DHCPB(rowid,"O",pboid,"D",pbdid),"^",7)
		...i totalamount=""  s totalamount=0
		...s sum=sum+totalamount
		...q:(taritem="")
		...q:($d(^DHCTARI(taritem))=0)
		...s subcate=$p(^DHCTARI(taritem),"^",30)
		...q:(subcate="")
		...//b
		...s acctcate=$p($g(^DHCTarC("MCNew",subcate)),"^",3)
		...q:(acctcate="")
		...f i=1:1:$g(^CacheTempPatMcCate(UniqueId)) d
		....i $p(acctcate,$c(1))=$p($p(^CacheTempPatMcCate(UniqueId,i),"^",1),$c(1)) d
		.....s itmfee(i)=totalamount+itmfee(i)
	
		// 将归并后的费用信息拼成字符串
		f i=1:1:$g(^CacheTempPatMcCate(UniqueId)) d
		.s P9=P9_"!"_$p($g(^CacheTempPatMcCate(UniqueId,i)),"^",2)_"^"_$p($g(^CacheTempPatMcCate(UniqueId,i)),"^",3)_"^"_$fn(itmfee(i),"",2)
		s P9="Total^总费用^"_$fn(sum,"",2)_P9
		
		k ^CacheTempPatMcCate(UniqueId)
		
		q P9
}

/// Desc:	新病案费用信息：按照费用子类 一般38项
/// Output:	
/// Others:
ClassMethod InPatCostTrakCareSubNew(argAdmId As %String, argHospital As %String = "") As %String
{
	// 依照病案子类取费用(SQL:DHC_TarMrCate )(Global：^DHCTarC("MC",rowid) )
	
	q:(($d(argAdmId)=0)||(argAdmId="")) ""

	
		s UniqueId=$i(^CacheTemp)
		k ^CacheTempPatMcCate(UniqueId),PLIST
		
		// 取费用子类信息
		s n=1
		s rowid="0"
		f  s rowid=$o(^DHCTarC("MCNew",rowid))  q:rowid=""  d
		.i $g(^CacheTempPatMcCate(UniqueId))="" s ^CacheTempPatMcCate(UniqueId)=0
		.i $p(^DHCTarC("MCNew",rowid),"^",1)'="" d
		..s acctdesc=$p($p(^DHCTarC("MCNew",rowid),"^",1),$c(1)) //DHC_TarMrCate -> TARMC_Code
		..s acctdesc2=$p($p(^DHCTarC("MCNew",rowid),"^",2),$c(1)) //DHC_TarMrCate -> TARMC_Desc
		..s ^CacheTempPatMcCate(UniqueId,n)=$p(rowid,$c(1))_"^"_acctdesc_"^"_acctdesc2
		..s ^CacheTempPatMcCate(UniqueId)=n
		..s PLIST(n)=acctdesc
		..s n=n+1
		
		
		// 初始化
		s argAdmId=$g(argAdmId)
		q:(argAdmId="") 0
		s sum=0, P9=""
		f i=1:1:$g(^CacheTempPatMcCate(UniqueId)) d
		.s itmfee(i)=0
		
		// 将病人费用信息按费用子类归并
		s rowid=""
		f  s rowid=$o(^DHCPB(0,"ADM",argAdmId,rowid))  q:rowid=""  d
		.s pboid=""
		.f  s pboid=$o(^DHCPB(rowid,"O",pboid))  q:pboid=""  d
		..s pbdid="0"
		..f  s pbdid=$o(^DHCPB(rowid,"O",pboid,"D",pbdid))  q:pbdid=""  d
		...s taritem=$p(^DHCPB(rowid,"O",pboid,"D",pbdid),"^",3)     
		...s unitprice=$p(^DHCPB(rowid,"O",pboid,"D",pbdid),"^",4)   
		...s qty=$p(^DHCPB(rowid,"O",pboid,"D",pbdid),"^",5)         
		...s totalamount=$p(^DHCPB(rowid,"O",pboid,"D",pbdid),"^",7)
		...i totalamount=""  s totalamount=0
		...s sum=sum+totalamount
		...q:(taritem="")
		...q:($d(^DHCTARI(taritem))=0)
		...s subcate=$p(^DHCTARI(taritem),"^",30)  //DHC_TarMrCate -> Rowid
		...q:(subcate="")
		...//b
		...s acctcate=subcate
		...q:(acctcate="")
		...f i=1:1:$g(^CacheTempPatMcCate(UniqueId)) d
		....i $p(acctcate,$c(1))=$p($p(^CacheTempPatMcCate(UniqueId,i),"^",1),$c(1)) d
		.....s itmfee(i)=totalamount+itmfee(i)
		
		// 将归并后的费用信息拼成字符串
		f i=1:1:$g(^CacheTempPatMcCate(UniqueId)) d
		.s P9=P9_"!"_$p($g(^CacheTempPatMcCate(UniqueId,i)),"^",2)_"^"_$p($g(^CacheTempPatMcCate(UniqueId,i)),"^",3)_"^"_$fn(itmfee(i),"",2)
		s P9="Total^总费用^"_$fn(sum,"",2)_P9
		
		k ^CacheTempPatMcCate(UniqueId)
		
		q P9
}

/// Creator:	wangwentao
/// CreatDate:	20120326
/// Description:获取医生职业证书编码通过医生工号
/// Table:		/
/// Input:		/
/// 			
/// Output:		/
/// Others:				
/// Example:	w ##Class(EPRservice.HISInterface.PatientInfoAssist).GetDocJQCyUserCode(ASSUSRInitials)
ClassMethod GetDocJQCyUserCode(ASSUSRInitials As %String) As %String
{
	q:(ASSUSRInitials="") ""
	
	//b "s"
	//BJYYYY 20120517 WANGWENTAO ADD
	s:($f(ASSUSRInitials,"-")'=0) ASSUSRInitials = $tr(ASSUSRInitials,"-")
	
	s (retValue,SSUSRRowId,SSUSRCareProvDR,DoctorJobQC) = ""
	
	//^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP({SSUSR_Initials}), {SSUSR_RowId})
	s SSUSRRowId = $o(^SSU("SSUSR",0,"SSUSR_Initials",ASSUSRInitials,""))
	s:(SSUSRRowId'="") SSUSRCareProvDR = $p($g(^SSU("SSUSR",SSUSRRowId)),"^",14) 
	s:(SSUSRCareProvDR'="") DoctorJobQC = $p($g(^CTPCP(SSUSRCareProvDR,2)),"^",8)
	
	s retValue = DoctorJobQC

	
	q retValue
}

/// Desc:	电子病历界面需要显示的病案号信息
ClassMethod IPRecordNoInfo(argAdmId As %String, argHospital As %String = "") As %String
{
	s recordNo = ""
	
	if (argHospital = ..#HospitalWHDYYY)
	{
		s recordNo = ##class(web.DHCWMRInterface.ReceiptSrv).GetMrNo(argAdmId,"","7")
	}
	
	if ($g(recordNo) = "") 
	{
		s papmiDR = ..GetPapmiDR(argAdmId)
		s recordNo = ..IPRecordNo(papmiDR, argHospital)
	}

	q recordNo
}

/// Creator:	wangwentao
/// CreatDate:	20120614
/// Description:获取诊断通过诊断类型
/// Table:		/
/// Input:		argAdmId: 就诊rowid
/// 				ADiagType DIS:出院诊断 M:门诊诊断 PRE:入院诊断 C008:初步诊断 Died:死亡诊断
/// 				ADiagNote:是否显示诊断备注
/// 				ADiagEPRNew:取新诊断的顺序和等级 "N|Y":不取等级只取顺序 "Y|Y":又取等级又取顺序 "N|N":不取等级不取顺序		
/// Output:		RowId^诊断代码^诊断描述!RowId^诊断代码^诊断描述
/// Others:		/	
/// Example:	
/// 				DHC-APP>w ##Class(EPRservice.HISInterface.PatientInfoAssist).GetDiagnosByType(2,"DIS","N","N|N")
/// 				5^A02.003^阿哥拉沙门氏菌肠炎!17^A06.401^阿米巴性肝脓肿
/// 				DHC-APP>w ##Class(EPRservice.HISInterface.PatientInfoAssist).GetDiagnosByType(2,"DIS","Y","N|N")
/// 				5^A02.003^阿哥拉沙门氏菌肠炎(1111111)!17^A06.401^阿米巴性肝脓肿(2222222)!19^A06.901^阿米巴病(3333333)
/// 				DHC-APP>w ##Class(EPRservice.HISInterface.PatientInfoAssist).GetDiagnosByType(2,"DIS","Y","N|Y")
/// 				522^C71.901^鞍上区恶性肿瘤(5555555)!212^B24.001^艾滋病(4444444)!19^A06.901^阿米巴病(3333333)
/// 				DHC-APP>w ##Class(EPRservice.HISInterface.PatientInfoAssist).GetDiagnosByType(2,"DIS","Y","Y|Y")
/// 				2||522^C71.901^鞍上区恶性肿瘤(5555555)!1||212^B24.001^艾滋病(4444444)!3||19^A06.901^阿米巴病(3333333)
ClassMethod GetDiagnosByType(argAdmId As %String, ADiagType As %String = "", ADiagNote As %String = "Y", ADiagEPRNew As %String = "N|Y") As %String
{
	q:($d(argAdmId)=0)||(argAdmId="") ""
	q:($d(ADiagType)=0)||(ADiagType="") ""
	
	//诊断类型
	q:(ADiagType'="DIS")&&(ADiagType'="M")&&(ADiagType'="PRE")&&(ADiagType'="C008")&&(ADiagType'="Died") ""
	
	s retValue = ""
	
	//取表 MRC_DiagnosType 中诊断类型对应的RowId 		
	s admDiagTypeId = ""
	s admDiagTypeId = $O(^MRC("DTYP",0,"Code",ADiagType,""))  
	q:(admDiagTypeId = "") ""
	
	s mainmradmdr = $p($g(^PAADM(argAdmId)),"^",61)
	q:(mainmradmdr = "") ""
	q:($d(^MR(mainmradmdr)) = 0) ""
	s IsExistEPRGlobal=""
	
	//初始化Global
	k:($p(ADiagEPRNew,"|",2)="Y") ^CacheTempDHCEPRDebug("EPRservice.HISInterface.PatientInfoAssist","GetDiagnosByType",argAdmId)
	
	//诊断处理
	s themrdiachildsub = ""
	s mrdiachildsub = ""
	for {
		s mrdiachildsub=$o(^MR(mainmradmdr,"DIA",mrdiachildsub))
		q:(mrdiachildsub="")
		
		s mrdiagtype = 0
		for {
			q:($d(^MR(mainmradmdr,"DIA",mrdiachildsub,"TYP"))=0)
			s mrdiagtype=$o(^MR(mainmradmdr,"DIA",mrdiachildsub,"TYP",mrdiagtype))
			q:(mrdiagtype="")
			
			s typmrcdiagtyp = $p($g(^MR(mainmradmdr,"DIA",mrdiachildsub,"TYP",mrdiagtype)),"^",1)
			if (typmrcdiagtyp = admDiagTypeId)	//此处判断是否为诊断类型
			{
				s themrdiachildsub = mrdiachildsub
				
				s mricdid = $p($g(^MR(mainmradmdr,"DIA",themrdiachildsub)),"^",1)
				q:(mricdid = "") 
	
				s mricdCode = $p($g(^MRC("ID",mricdid)),"^",4)
				s mricdDesc = $p($g(^MRC("ID",mricdid)),"^",2)
				
				//判断诊断备注
				if (ADiagNote="Y")
				{
					s diagNote=$g(^MR(mainmradmdr,"DIA",themrdiachildsub,"DES",1))
					if (diagNote '= "") 
					{	
						s mricdDesc = mricdDesc_"("_diagNote_")"
					}
				}

				//判断新诊断层级和顺序,当EPRGlobal存在时候.
				s IsExistEPRGlobal = $d(^MR(mainmradmdr,"DIA",themrdiachildsub,"EPR"))
				
				if ($p(ADiagEPRNew,"|",2)="Y")&&(IsExistEPRGlobal=1)
				{
					s diagEPRNew=$g(^MR(mainmradmdr,"DIA",themrdiachildsub,"EPR"))
					q:(diagEPRNew = "")

					s diagLevel = $p(diagEPRNew,"^",1)
					s diagNum = $p(diagEPRNew,"^",2)

					s retValueNew = mricdid_"^"_mricdCode_"^"_mricdDesc
					
					if ($p(ADiagEPRNew,"|",1)="Y")
					{ 
						s ^CacheTempDHCEPRDebug("EPRservice.HISInterface.PatientInfoAssist","GetDiagnosByType",argAdmId,diagNum)=diagLevel_"||"_retValueNew
					}
					else
					{
						s ^CacheTempDHCEPRDebug("EPRservice.HISInterface.PatientInfoAssist","GetDiagnosByType",argAdmId,diagNum)=retValueNew
					}	
				}
				else
				{
					if (retValue = "")
					{	s retValue = mricdid_"^"_mricdCode_"^"_mricdDesc}
					else
					{	s retValue = retValue_"!"_mricdid_"^"_mricdCode_"^"_mricdDesc}
				}
			}
		}
	}
	
	//处理新诊断层级和顺序数据,当EPRGlobal存在时候.
	if ($p(ADiagEPRNew,"|",2)="Y")&&(IsExistEPRGlobal=1)
	{
		s diagNum = 0 ,tmpDiagValue="",DiagValue =""
		for {
			s diagNum=$o(^CacheTempDHCEPRDebug("EPRservice.HISInterface.PatientInfoAssist","GetDiagnosByType",argAdmId,diagNum))
			q:(diagNum="")
			
			s tmpDiagValue=^(diagNum)
			
			if (DiagValue="")
			{
				 s DiagValue = tmpDiagValue
			}
			else
			{
				s DiagValue = DiagValue_"!"_tmpDiagValue
			}
		}
		s retValue = DiagValue
		
		k ^CacheTempDHCEPRDebug("EPRservice.HISInterface.PatientInfoAssist","GetDiagnosByType",argAdmId)	
	}

	
	q retValue
}

/// Creator:	wangwentao
/// CreatDate:	2011-08-31
/// Description:获取上一次病人就诊号通过"当前就诊号","就诊类型"
/// Input:		APatientID 
/// 			AType就诊类型 I O E
/// Output:		/
/// Return:		/
/// Others:		医科院肿瘤医院 妇科化学观察治疗表数据绑定
/// Example:	##Class(EPRservice.HISInterface.PatientInfoAssist).GetPreviousEpisodeIDByType(1604166,1140956,"I")
ClassMethod GetPreviousEpisodeIDByType(AAdmID As %String, APatientID As %String, AType As %String) As %String
{
	q:(($d(AAdmID)=0)||(AAdmID="")) ""
	q:(($d(APatientID)=0)||(APatientID="")) ""
	q:(($d(AType)=0)||(AType="")) ""
	
	set (VisitStatus) =""
	
	s Hospital=##class(EPRmeta.SysOption).GetOptionValueByName("HospitalName")
	s episodeID=AAdmID	
 	for {
	 	set episodeID = $o(^PAPERdr(APatientID,"ADM",AType,episodeID),-1)
		
		if (episodeID'="") {
			//筛选排除访问状态Cancel		   
			set VisitStatus= $p(^PAADM(episodeID),"^",20)
			Continue:(VisitStatus="C")
			quit
		}
		else {
			quit
		}
 	}
 	
	q episodeID
}

/// Desc:  取电子病历主诉[北京协和] Add by Liaowp 2011-9-20
/// OutPut:主诉String
/// DeBug: w ##class(EPRservice.HISInterface.PatientInfoAssist).MainAccount(1470)
ClassMethod MainAccount(argAdmId As %String) As %String
{
	//Item1:急诊流水主诉
	//Item2:急诊抢救室主诉
	//Item3:急诊留观室主诉
	//Item4:住院通用模板主诉
	s Item1="主诉：#TYPE:Segment#TID:26#TVER:0#GCODE:G0144",Item2="主诉：#TYPE:TextDesc#TID:6#TVER:0#ECODE:E0015",Item3="主诉：#TYPE:TextDesc#TID:5#TVER:0#ECODE:E0015",Item4="主诉：#TYPE:TextDesc#TID:13#TVER:0#ECODE:E0013"
	s MainAccount=""
	
	s MainAccount=##class(EPRservice.BOScatterData).GetEPRData(argAdmId, Item1)
	if (MainAccount="")
	{
		s MainAccount=##class(EPRservice.BOScatterData).GetEPRData(argAdmId, Item2)
		}
	if (MainAccount="")
	{
		s MainAccount=##class(EPRservice.BOScatterData).GetEPRData(argAdmId, Item3)
		}
	if (MainAccount="")
	{
		s MainAccount=##class(EPRservice.BOScatterData).GetEPRData(argAdmId, Item4)
		}
	q MainAccount
}

/// Desc:  取电子病历现病史[北京协和] Add by Liaowp 2011-9-20
/// OutPut:现病史String
/// DeBug: w ##class(EPRservice.HISInterface.PatientInfoAssist).PatHistory(539)
ClassMethod PatHistory(argAdmId As %String) As %String
{
	//Item1:急诊流水现病史
	//Item2:急诊抢救室现病史
	//Item3:急诊留观室现病史
	//Item4:住院通用模板现病史
	s Item1="现病史：#TYPE:TextDesc#TID:26#TVER:0#ECODE:E0016",Item2="现病史：#TYPE:TextDesc#TID:6#TVER:0#ECODE:E0016",Item3="现病史：#TYPE:TextDesc#TID:5#TVER:0#ECODE:E0016",Item4="现 病 史：#TYPE:TextDesc#TID:13#TVER:0#ECODE:E0014"
	s PatHistory=""
	
	s PatHistory=##class(EPRservice.BOScatterData).GetEPRData(argAdmId, Item1)
	if (PatHistory="")
	{
		s PatHistory=##class(EPRservice.BOScatterData).GetEPRData(argAdmId, Item2)
		}
	if (PatHistory="")
	{
		s PatHistory=##class(EPRservice.BOScatterData).GetEPRData(argAdmId, Item3)
		}
	if (PatHistory="")
	{
		s PatHistory=##class(EPRservice.BOScatterData).GetEPRData(argAdmId, Item4)
		}
	q PatHistory
}

/// Desc:  取电子病历病例摘要[北京协和] Add by Liaowp 2011-10-27
/// OutPut:现病史String
/// DeBug: w ##class(EPRservice.HISInterface.PatientInfoAssist).RecordSummary(539)
ClassMethod RecordSummary(argAdmId As %String) As %String
{
	//Item:病历摘要
	s Item="病例摘要:#TYPE:Segment#TID:29#TVER:0#GCODE:G0016"
	s MainAccount="",PatHistory="", RecordSummary=""
	
	s RecordSummary=##class(EPRservice.BOScatterData).GetEPRData(argAdmId, Item)
	if (RecordSummary="")
	{
		s MainAccount=..MainAccount(argAdmId)
		s PatHistory=..PatHistory(argAdmId)
		s RecordSummary=MainAccount_$Char(10,13)_PatHistory
		}
	q RecordSummary
}

/// Add by Liaowp 2012-1-15
/// Desc:  取护理组日常生活能力评定量表得分
/// OutPut:Inscore^Outscore
/// DeBug: w ##class(EPRservice.HISInterface.PatientInfoAssist).PatSelfCareDegree(539)
ClassMethod PatSelfCareDegree(argAdmId As %String) As %String
{
	q:($d(argAdmId)=0)||(argAdmId="") "^"
	
	s ScoreStr="^",InScore="",OutScore=""
	s ScoreStr=##class(Nur.DHCMoudDataSub).getshnlpf(argAdmId)
	if (ScoreStr="")
	{
		s ScoreStr="^"
		}
	if (ScoreStr'="^")
	{
		s InScore=$P($P(ScoreStr,"^",1),"|",2)
		s OutScore=$P($P(ScoreStr,"^",2),"|",2)
		s ScoreStr=InScore_"^"_OutScore
		}	
	q ScoreStr
}

/// Desc: 获取前一次就诊EpisodeID
/// Test: w ##class(EPRservice.HISInterface.PatientInfoAssist).GetBFAdmID("1818") 
ClassMethod GetBFAdmID(argAdmId As %String) As %String
{
	s PapmiDR=""
	q:($d(argAdmId)=0)||(argAdmId="") ""
	s PapmiDR=..GetPapmiDR(argAdmId)
	q:(PapmiDR="") ""
	q:(($d(^PAPERdr(PapmiDR,"ADM","I",argAdmId))'=1)&&($d(^PAPERdr(PapmiDR,"ADM","I",argAdmId))'=11)) ""
    s BFAdmID = $O(^PAPERdr(PapmiDR,"ADM","I",argAdmId),-1)
 	q BFAdmID
}

/// Desc:	2012新籍贯-20120324 Add by Liaowp
/// 20120711 WWT CHECKOK
ClassMethod NativeNew(argPapmiDR As %String, argHospital As %String = "") As %String
{
	q:(($d(argPapmiDR)=0)||(argPapmiDR="")) ""
	s Native=""
	
	s ProvinceDR = $P($g(^PAPER(argPapmiDR,"PER",2)),"^",11) 
	s CityDR =$P($g(^PAPER(argPapmiDR,"ALL")),"^",18) 
	
	if (ProvinceDR'="")&&(CityDR'="")
	{
		//省份信息
		s ProvinceCode=$P($g(^CT("PROV",ProvinceDR)),"^",1)
		s ProvinceDesc = $P($g(^CT("PROV",ProvinceDR)),"^",2)
		i $l(ProvinceDesc,"-")'=1 {s ProvinceDesc=$p($g(ProvinceDesc),"-",2)} 
		//城市信息
		s CityCode = $p($g(^CT("CIT",CityDR)),"^",1)
		s CityDesc = $p($g(^CT("CIT",CityDR)),"^",2)
		i ($l(CityDesc,"-")>1) {s CityDesc=$p($g(CityDesc),"-",2)}	
		//整理返回值
		s Native = ProvinceDR_"^"_ProvinceCode_"^"_ProvinceDesc
		s Native = Native_"!"_CityDR_"^"_CityCode_"^"_CityDesc
	}		
	
	q Native
}

/// Desc:	2012新现住址-20120324 Add by Liaowp
/// 20120711 WWT CHECKOK
ClassMethod ResidentAddressNew(argPaperDR As %String, argHospital As %String = "") As %String
{
	q:(($d(argPaperDR)=0)||(argPaperDR="")) ""
	s residentaddr=""
	s birthPlace="",curprovinceDR="",curcityDR="",curblockDR=""
	
	q:(($d(^PAPER(argPaperDR,"ALL"))'=1)&&($d(^PAPER(argPaperDR,"ALL"))'=11)) ""
	
	//新现住址字段
	//PAPER_CT_Province_DR
	s curprovinceDR = $p($g(^PAPER(argPaperDR,"PER",4)),"^",2)
	//PAPER_CityCode_DR
	s curcityDR = $p($g(^PAPER(argPaperDR,"PER",1)),"^",5)
	//PAPER_CityArea_DR
	s curblockDR = $p($g(^PAPER(argPaperDR,"PER",4)),"^",9)
	
	s curCity="",curProvince="", curBlock=""
	
	if (curprovinceDR'="")
	{	
		s curProvinceDesc = $p($g(^CT("PROV",curprovinceDR)),"^",2)
		i $l(curProvinceDesc,"-")'=1 {s curProvinceDesc=$p($g(curProvinceDesc),"-",2)} 
		s curProvinceCode = $p($g(^CT("PROV",curprovinceDR)),"^",1)
		s curProvince = curprovinceDR_"^"_curProvinceCode_"^"_curProvinceDesc
	}
	if (curcityDR'="")
	{
		s curCityDesc = $p($g(^CT("CIT",curcityDR)),"^",2)
		i $l(curCityDesc,"-")'=1 {s curCityDesc=$p($g(curCityDesc),"-",2)} 
		s curCityCode = $p($g(^CT("CIT",curcityDR)),"^",1)
		s curCity = curcityDR_"^"_curCityCode_"^"_curCityDesc
	}	
	if (curblockDR'="")	
	{
		s curBlockDesc = $p($g(^CT("CITAREA",curblockDR)),"^",2)
		i $l(curBlockDesc,"-")'=1 {s curBlockDesc=$p($g(curBlockDesc),"-",2)} 
		s curBlockCode = $p($g(^CT("CITAREA",curblockDR)),"^",1)
		s curBlock = curblockDR_"^"_curBlockCode_"^"_curBlockDesc		
	}

	if ($ZCVT(argHospital,"U")=..#HospitalBJFCYY)
	{
		s residentaddr=$p($g(^PAPER(argPaperDR,"PER",1)),"^",1)
	}
	else
	{
		s residentaddr=$g(^PAPER(argPaperDR,"PER","ADD",1))
	}
	
	s residentaddr = curProvince_"!"_curCity_"!"_curBlock_"!"_residentaddr
	
	q residentaddr
}

/// Desc:	2012新户口地址-20120324 Add by Liaowp
/// Output：省!市!区!详细地址
/// 20120418 wangwentao update  20120711 WWT CHECKOK
ClassMethod HuKouAddressNew(argPaperDR As %String, argHospital As %String = "") As %String
{
	q:(($d(argPaperDR)=0)||(argPaperDR="")) ""
	
	s DHCPersonDR=0
	s DHCPersonDR = $o(^DHCPERSON(0,"PAPERSON",argPaperDR,DHCPersonDR)) q:(DHCPersonDR="") ""
	 
	q:(($d(^DHCPERSON(DHCPersonDR))'=1)&&($d(^DHCPERSON(DHCPersonDR))'=11)) ""
	
	s (provinceDR,cityHuKouDR,blockHukouDR,streetHukou)=""
	//新户口地址字段 存储不同 需特殊处理
	if ($ZCVT(argHospital,"U")=..#HospitalBJFCYY)
	{
		//新户口地址字段
		//DHC_Person.PAPER_HouseProvinceDR
		s provinceDR = $p($g(^DHCPERSON(DHCPersonDR)),"^",18)
		//DHC_Person.PAPER_HouseCityDR
		s cityHuKouDR = $p($g(^DHCPERSON(DHCPersonDR)),"^",19)
		//DHC_Person.PAPER_HouseAreaDR
		s blockHukouDR = $p($g(^DHCPERSON(DHCPersonDR)),"^",20)
		//DHC_Person.PAPER_HouseAddress
		s streetHukou = $p($g(^DHCPERSON(DHCPersonDR)),"^",21)
	}
	else
	{
		//医生站郭荣勇确认以协和为准
		//新户口地址字段
		//DHC_Person.PAPER_HouseProvinceDR
		s provinceDR = $p($g(^DHCPERSON(DHCPersonDR)),"^",17)
		//DHC_Person.PAPER_HouseCityDR
		s cityHuKouDR = $p($g(^DHCPERSON(DHCPersonDR)),"^",18)
		//DHC_Person.PAPER_HouseAreaDR
		s blockHukouDR = $p($g(^DHCPERSON(DHCPersonDR)),"^",19)
		//DHC_Person.PAPER_HouseAddress
		s streetHukou = $p($g(^DHCPERSON(DHCPersonDR)),"^",20)
	}	
	
	if (streetHukou="")
	{
		//PA_Person.PAPER_StName
		//详细地址存了两个位置 故进行处理 
		s addressNum=$o(^PAPER(argPaperDR,"PER","ADD",""),-1)
		s streetHukou=$g(^PAPER(argPaperDR,"PER","ADD",addressNum))
	}
	
	s HuKouCity="",HuKouProvince="", HuKouBlock="",HuKouStreet="",HuKouaddr=""

	if (provinceDR'="")
	{	
		s HuKouProvinceDesc = $p($g(^CT("PROV",provinceDR)),"^",2)
		i $l(HuKouProvinceDesc,"-")'=1 {s HuKouProvinceDesc=$p($g(HuKouProvinceDesc),"-",2)} 
		s HuKouProvinceCode = $p($g(^CT("PROV",provinceDR)),"^",1)
		s HuKouProvince = provinceDR_"^"_HuKouProvinceCode_"^"_HuKouProvinceDesc
	}
	if (cityHuKouDR'="")
	{
		s HuKouCityDesc = $p($g(^CT("CIT",cityHuKouDR)),"^",2)
		i $l(HuKouCityDesc,"-")'=1 {s HuKouCityDesc=$p($g(HuKouCityDesc),"-",2)} 
		s HuKouCityCode = $p($g(^CT("CIT",cityHuKouDR)),"^",1)
		s HuKouCity = cityHuKouDR_"^"_HuKouCityCode_"^"_HuKouCityDesc
	}	
	if (blockHukouDR'="")	
	{
		s HuKouBlockDesc = $p($g(^CT("CITAREA",blockHukouDR)),"^",2)
		i $l( HuKouBlockDesc,"-")'=1 {s HuKouBlockDesc=$p($g( HuKouBlockDesc),"-",2)} 
		s HuKouBlockCode = $p($g(^CT("CITAREA",blockHukouDR)),"^",1)
		s HuKouBlock = blockHukouDR_"^"_HuKouBlockCode_"^"_HuKouBlockDesc		
	}

	
	s HuKoutaddr = HuKouProvince_"!"_HuKouCity_"!"_HuKouBlock_"!"_streetHukou
	s:(HuKoutaddr="!!!") HuKoutaddr =""
	
	q HuKoutaddr
}

/// Desc：	2012新出生地-20120324 Add by Liaowp
/// Output：省!市!区!详细地址
/// 20120418 wangwentao update 20120711 WWT CHECKOK
ClassMethod BirthPlaceNew(argPapmiDR As %String, argHospital As %String = "") As %String
{
	q:($d(argPapmiDR)=0)||(argPapmiDR="") ""
	
	s birthPlace="",DHCPersonDR=0
	s DHCPersonDR = $o(^DHCPERSON(0,"PAPERSON",argPapmiDR,DHCPersonDR)) q:(DHCPersonDR="") ""
	 
	q:(($d(^DHCPERSON(DHCPersonDR))'=1)&&($d(^DHCPERSON(DHCPersonDR))'=11)) ""
	
	//新户口地址字段 存储不同 需特殊处理
	if ($ZCVT(argHospital,"U")=..#HospitalBJFCYY)
	{
		//新出生地字段
		s (provinceDR,cityBirthDR,blockBirthDR,detailAddressDR)=""
		//DHC_Person.PAPER_BirthProvinceDR
		s provinceDR = $p($g(^DHCPERSON(DHCPersonDR)),"^",14)
		//DHC_Person.PAPER_BirthCityDR
		s cityBirthDR = $p($g(^DHCPERSON(DHCPersonDR)),"^",15)
		//DHC_Person.PAPER_BirthAreadr
		s blockBirthDR = $p($g(^DHCPERSON(DHCPersonDR)),"^",16)
		//DHC_Person.PAPER_BirthAddress
		s detailAddressDR = $p($g(^DHCPERSON(DHCPersonDR)),"^",17)
	}
	else
	{
		//医生站郭荣勇确认以协和为准 
		//新出生地字段
		s (provinceDR,cityBirthDR,blockBirthDR,detailAddressDR)=""
		//DHC_Person.PAPER_BirthProvinceDR
		s provinceDR = $p($g(^DHCPERSON(DHCPersonDR)),"^",13)
		//DHC_Person.PAPER_BirthCityDR
		s cityBirthDR = $p($g(^DHCPERSON(DHCPersonDR)),"^",14)
		//DHC_Person.PAPER_BirthAreadr
		s blockBirthDR = $p($g(^DHCPERSON(DHCPersonDR)),"^",15)
		//DHC_Person.PAPER_BirthAddress
		s detailAddressDR = $p($g(^DHCPERSON(DHCPersonDR)),"^",16)
	}
	
	s birthProvince="",birthCity="",birthBlock="",birthDetail=""
	
	if (provinceDR'="")
	{	
		s birthProvinceDesc = $p($g(^CT("PROV",provinceDR)),"^",2)
		i $l(birthProvinceDesc,"-")'=1 {s birthProvinceDesc=$p($g(birthProvinceDesc),"-",2)} 
		s birthProvinceCode = $p($g(^CT("PROV",provinceDR)),"^",1)
		s birthProvince = provinceDR_"^"_birthProvinceCode_"^"_birthProvinceDesc
	}
	if (cityBirthDR'="")
	{
		s birthCityDesc = $p($g(^CT("CIT",cityBirthDR)),"^",2)
		i $l(birthCityDesc,"-")'=1 {s birthCityDesc=$p($g(birthCityDesc),"-",2)} 
		s birthCityCode = $p($g(^CT("CIT",cityBirthDR)),"^",1)
		s birthCity = cityBirthDR_"^"_birthCityCode_"^"_birthCityDesc
	}	
	if (blockBirthDR'="")	
	{
		s birthBlockDesc = $p($g(^CT("CITAREA",blockBirthDR)),"^",2)
		i $l(birthBlockDesc,"-")'=1 {s birthBlockDesc=$p($g(birthBlockDesc),"-",2)} 
		s birthBlockCode = $p($g(^CT("CITAREA",blockBirthDR)),"^",1)
		s birthBlock = blockBirthDR_"^"_birthBlockCode_"^"_birthBlockDesc		
	}
	if (detailAddressDR'="")	
	{
		s birthDetail = detailAddressDR	
	}
	
	s birthPlace = birthProvince_"!"_birthCity_"!"_birthBlock_"!"_birthDetail
	
	s:(birthPlace="!!!") birthPlace=""
	
	q birthPlace
}

/// Desc:	户口邮编
/// Output:	邮编
/// Table:	DHC_Person.PAPER_Comment3 	User.DHCPerson.cls  对应第9个节点
/// 20120418 wangwentao update 20120711 WWT CHECKOK
/// w ##Class(EPRservice.HISInterface.PatientInfoAssist).HuKouPostCodeNew(1)
ClassMethod HuKouPostCodeNew(argPaperDR As %String, argHospital As %String = "") As %String
{
	q:(($d(argPaperDR)=0)||(argPaperDR="")) ""
	s hukoupostalcodeDR="",hukoupostalcode=""

	s hukoupostalcodeDR=$o(^DHCPERSON(0,"PAPERSON",argPaperDR,""))
	if (hukoupostalcodeDR'="")
	{	
		if ($ZCVT(argHospital,"U")=..#HospitalYKYZLYY)
		{
			//PA_Person.PAPER_ForeignPostCode
			s hukoupostalcode=$p($g(^PAPER(argPaperDR,"PER",2)),"^",8)
		}
		else
		{
			//DHC_Person.PAPER_Comment3
			s hukoupostalcode=$p($g(^DHCPERSON(hukoupostalcodeDR)),"^",9)
		}
	}
		
	q hukoupostalcode
}

/// Desc:	现住址邮编
/// Output:	邮编
/// Table:	DHC_Person.PAPER_Comment2 	User.DHCPerson.cls 对应第8个节点[作废]
/// Table:	DHC_Person.PAPER_Comment1 	User.DHCPerson.cls 医生站郭荣勇确认以协和为准 
/// 20120418 wangwentao update  20120711 WWT CHECKOK
/// w ##Class(EPRservice.HISInterface.PatientInfoAssist).ResidentPostCodeNew(1)
ClassMethod ResidentPostCodeNew(argPaperDR As %String, argHospital As %String = "") As %String
{
	
	q:(($d(argPaperDR)=0)||(argPaperDR="")) ""
	s residentpostalcodeDR="",residentpostalcode=""

	s residentpostalcodeDR=$o(^DHCPERSON(0,"PAPERSON",argPaperDR,""))
	if residentpostalcodeDR'=""
	{
		if ($ZCVT(argHospital,"U")=..#HospitalBJFCYY)
		{
			//DHC_Person.PAPER_Comment2
			s residentpostalcode=$p($g(^DHCPERSON(residentpostalcodeDR)),"^",8)
		}
		else
		{
			//DHC_Person.PAPER_Comment1
			s residentpostalcode=$p($g(^DHCPERSON(residentpostalcodeDR)),"^",7)
		}		
		
	}	
	//容错数据误存医保号 w $p($g(^DHCPERSON(833679)),"^",8) 10390864000S wangwentao 20130726 add bjfcyy
	s:($l(residentpostalcode)>6) residentpostalcode = "" 	
	
	q residentpostalcode
}

/// Desc:	工作地址邮编
/// Output:	邮编
/// Table:	DHC_Person.PAPER_Comment1 	User.DHCPerson.cls 对应第7个节点[作废] 
/// Table:	DHC_Person.PAPER_Comment2 	User.DHCPerson.cls 医生站郭荣勇确认以协和为准 
/// 20120418 wangwentao update
/// w ##Class(EPRservice.HISInterface.PatientInfoAssist).WorkPostCodeNew(1)
ClassMethod WorkPostCodeNew(argPaperDR As %String, argHospital As %String = "") As %String
{
	q:(($d(argPaperDR)=0)||(argPaperDR="")) ""
	s workpostalcodeDR="",workpostalcode=""

	
	s workpostalcodeDR=$o(^DHCPERSON(0,"PAPERSON",argPaperDR,""))
	if workpostalcodeDR'=""
	{
		if $ZCVT(argHospital,"U")=..#HospitalYKYZLYY
		{
			//PA_Person.PAPER_Name6
			s workpostalcode=$p($g(^PAPER(argPaperDR,"ALL")),"^",22)
		}
		if ($ZCVT(argHospital,"U")=..#HospitalBJFCYY)
		{
			//DHC_Person.PAPER_Comment1
			s workpostalcode=$p($g(^DHCPERSON(workpostalcodeDR)),"^",7)
		}
		else
		{
			//DHC_Person.PAPER_Comment2
			s workpostalcode=$p($g(^DHCPERSON(workpostalcodeDR)),"^",8)
		}
	}
	else
	{
		//PA_Person.PAPER_Name6
		s workpostalcode=$p($g(^PAPER(argPaperDR,"ALL")),"^",22)
	}
	//容错数据误存医保号 w $p($g(^DHCPERSON(966586)),"^",7) 11161630000S wangwentao 20130426 add bjfcyy
	s:($l(workpostalcode)>6) workpostalcode = "" 
	
	
	q workpostalcode
}

/// Creator:	wangwentao
/// CreatDate:	20120418
/// Desc:	工作单位
/// Output:	名称
/// Table:	DHC_Person.PAPER_CompanyDesc 	User.DHCPerson.cls 
/// 20120418 wangwentao update
/// w ##Class(EPRservice.HISInterface.PatientInfoAssist).WorkAddressNew(1)
ClassMethod WorkAddressNew(argPaperDR As %String, argHospital As %String = "") As %String
{
	q:(($d(argPaperDR)=0)||(argPaperDR="")) ""
	s WorkAddress="",WorkAddressDR="",workcode=""

	s WorkAddressDR=$o(^DHCPERSON(0,"PAPERSON",argPaperDR,""))
	if WorkAddressDR'=""
	{
		s WorkAddress=$p($g(^DHCPERSON(WorkAddressDR)),"^",22)
	}	
	
	q WorkAddress
}

/// Creator:	wangwentao
/// CreatDate:	20120418
/// Desc:	联系人地址
/// Table:	PA_Person.PAPER_ForeignNotes
/// Others:	/
ClassMethod LinkmanAddressNew(argPaperDR As %String, argHospital As %String = "") As %String
{
	q:(($d(argPaperDR)=0)||(argPaperDR="")) ""
	s (address,addressNum)=""

	s addressNum=$o(^PAPER(argPaperDR,"FNOTES",""),-1)
	
	q:(addressNum="") ""
	q:(($d(^PAPER(argPaperDR,"FNOTES",addressNum))'=1)&&($d(^PAPER(argPaperDR,"FNOTES",addressNum))'=11)) ""
 
	s address=$g(^PAPER(argPaperDR,"FNOTES",addressNum))
 
	q address
}

/// Creator:	wangwentao
/// CreatDate:	20120418
/// Description:获取证件类型CardTypeNew
/// Table:		[SQLUSER.PA_PatMas]PAPMI_CardType_DR -> [SQLUSER.PAC_CardType]CARD_Desc
ClassMethod CardTypeNew(argPapmiDR As %String) As %String
{
	q:($d(argPapmiDR)=0)||(argPapmiDR="") ""
	q:(($d(^PAPER(argPapmiDR,"ALL"))'=1)&&($d(^PAPER(argPapmiDR,"ALL"))'=11)) ""
	
	s CardTypeDR="",CARDDesc=""
	
	s CardTypeDR=$P($g(^PAPER(argPapmiDR,"PAT",3)),"^",7)
	if (CardTypeDR'="") 
	{
		s CARDDesc = $p($g(^PAC("CARD",CardTypeDR)),"^",2)
	}
	s CardType=CARDDesc
			
	q CardType
}

/// Creator:	wangwentao
/// CreatDate:	20120418
/// Description:获取证件号码CardNumberNew
/// Table:		[SQLUSER.PA_PatMas]PAPMI_DVAnumber
ClassMethod CardNumberNew(argPapmiDR As %String) As %String
{
	q:($d(argPapmiDR)=0)||(argPapmiDR="") ""
	q:(($d(^PAPER(argPapmiDR,"ALL"))'=1)&&($d(^PAPER(argPapmiDR,"ALL"))'=11)) ""
	
	s CardNumber=""
	
	s CardNumber =$P($g(^PAPER(argPapmiDR,"PAT",3)),"^",6)
			
	q CardNumber
}

/// Creator:	wangwentao
/// CreatDate:	20120418
/// Desc:	身份证号
/// Table:	PA_Person.PAPER_ID
/// 20120418 wangwentao update
/// w ##Class(EPRservice.HISInterface.PatientInfoAssist).IDCardNew(1)
ClassMethod IDCardNew(argPaperDR As %String, argLen As %String = "15^18") As %String
{
	q:($d(argPaperDR)=0)||(argPaperDR="") ""
	q:(($d(^PAPER(argPaperDR,"ALL"))'=1)&&($d(^PAPER(argPaperDR,"ALL"))'=11)) ""
	
	s (idcard,idcardlen)=""
	
	s idcard=$P($G(^PAPER(argPaperDR,"ALL")),"^",9)
	if (idcard'="")
	{
		s idcardlen = $l(idcard)
		//处理非标准身份证长度
		if ($f("^"_argLen_"^","^"_idcardlen_"^")=0)
		{
			s CardType = ##Class(EPRservice.HISInterface.PatientInfoAssist).CardTypeNew(argPaperDR)
			if (CardType="身份证")
			{
				s CardNumber = ##Class(EPRservice.HISInterface.PatientInfoAssist).CardNumberNew(argPaperDR)
				//处理非标准证件号长度
				if ($f("^"_argLen_"^","^"_$l(CardNumber)_"^")=0)
				{
					//idcard非标准,CardNumber非标准,非标准身份证长度置空
					s idcard=""
				}
				else
				{
					//idcard为非标准,CardNumber标准
					s idcard=CardNumber
				}
			}
			else
			{
				//idcard为非标准,非标准身份证长度置空
				s idcard=""
			}	
		}
	}
		
	q idcard
}

/// Creator:	wangwentao
/// CreatDate:	2012-10-15
/// Description:获取护理组急诊病人评分 
/// Table:		##class(web.DHCCLScore).GetScoreDetailByAdmAndScoreType(30517,"APACHE")
/// parameter:	AEpisodeID 就诊号 AScoreType 评分类型:CRAMS,GLASG,RTS,GUSTL,ISS,SOFA,MEDS,APACHE,CPugh
/// 			w ##class(EPRservice.HISInterface.PatientInfoAssist).GetPatScoreByAdmAndScoreType(30517,"APACHE")
ClassMethod GetPatScoreByAdmAndScoreType(AEpisodeID As %String, AScoreType As %String) As %String
{
	q:($d(AEpisodeID)=0)||(AEpisodeID="") ""
	q:($d(AScoreType)=0)||(AScoreType="") ""
	
	s PatScore=""
	
	s PatScore =##class(web.DHCCLScore).GetScoreDetailByAdmAndScoreType(AEpisodeID,AScoreType)
			
	q PatScore
}

/// Creator:	wangwentao
/// CreatDate:	20121015
/// Description:获取医嘱项目通过医嘱大类
/// Table:		/
/// Input:		AAdmId是病人就诊ID[PA_Adm表RowID]
/// 				ACategory是医嘱大类名称[OEC_OrderCategory表RowID]
/// 				AStartDate是开始时间标准格式
/// 				AEndDate是结束时间标准格式
/// 				AFormatType { 1:顿号 2:逗号 3:逗号B 4:空格 5:回车 }
/// 				AHospital是医院标识
/// Output:		/
/// Return:		Result
/// Others:		
/// 				[OEC_OrderStatus]OEORI_ItemStat_DR
/// Example:	w ##Class(EPRservice.HISInterface.PatientInfoAssist).GetOrderDetailByOrdCat(30517,"2012-09-01","2012-12-12","化验",1)
ClassMethod GetOrderDetailByOrdCat(AEpisodeID As %String, AStartDate As %String, AEndDate As %String, ACategory As %String, AFormatType As %String = "1", AHospital As %String = "") As %String
{
	//b "s"
	//完整性判断
	q:($d(AEpisodeID)=0)||(AEpisodeID="") ""
	q:($d(AStartDate)=0)||(AStartDate="") ""
	q:($d(AEndDate)=0)||(AEndDate="") ""
	q:($d(ACategory)=0)||(ACategory="") ""
	
	//定义返回值
	s Result=""
	s (OrderName,QtyPackUOM,PackUOMDesc,Useage,DoseQty,DoseUnit,PHFreq,Dura)=""
	
	//ACategory是医嘱大类名称ORCAT_Desc转换为ORCAT_RowID[OEC_OrderCategory表]
	s ORCATRowID = $o(^OEC("ORCAT",0,"Desc",ACategory,""))
	//标准格式转换内部格式
	s StartDate = $zdh(AStartDate,3)
	s EndDate = $zdh(AEndDate,3)
	
	//定义变量
	s (sc,OrderStatus,OrderName,QtyPackUOM,PackUOMDesc,Useage,DoseQty,DoseUnit,PHFreq,Dura) =""	
	
	//程序处理 调用医生站郭荣勇接口
	s rset = ##class(%ResultSet).%New("web.DHCFOrdGet:GetOrdByAdm")

	s sc = rset.Execute(AEpisodeID,StartDate,EndDate,ORCATRowID,"","","","")
	q:(sc'=1) ""
	
	//遍历指定类型医嘱或所有医嘱
	While (rset.Next()) {
	
		//判断医嘱状态
		//2	U	作废	Y
		//4	D	停止	Y
		s OrderStatus = rset.Data("OrdStatus")
		continue:((OrderStatus="作废")||(OrderStatus="停止"))
				
		//获取医嘱名称
		s OrderName = rset.Data("ArcimDesc")
		//处理数据格式
		s OrderName = $$ConvertDataStyle(OrderName)
		
		
		if ($f(ACategory,"药")=0)
		{
			//格式: 医嘱名称
			
			//构造结果串
			if (Result="")
			{	s Result = OrderName }
			else
			{
				if (AFormatType = "1")
				{
					s Result = Result_"、"_OrderName
				}
				if (AFormatType = "2")
				{
					s Result = Result_"，"_OrderName
				}
				if (AFormatType = "3")
				{
					s Result = Result_" , "_OrderName
				}
				if (AFormatType = "4")
				{
					s Result = Result_" "_OrderName
				}
				if (AFormatType = "5")
				{
					s Result = Result_$c(13,10)_OrderName
				}
			}
		}
		else
		{
			//获取 [总量]
			s QtyPackUOM = rset.Data("QtyPackUOM")
			
			//获取 [总量单位]
			s PackUOMDesc = rset.Data("PackUOMDesc")
			
			//获取 [用法]
			s Useage = rset.Data("Instr")
			//处理数据格式
			s Useage = $$ConvertDataStyle(Useage)
			
			//获取 [单次计量]
			s DoseQty = rset.Data("DoseQty")			
			
			//获取 [单次计量单位]
			s DoseUnit = rset.Data("DoseUnit")			
			
			//获取 [频次]
			s PHFreq = rset.Data("PHFreq")
			//处理数据格式
			s PHFreq = $$ConvertDataStyle(PHFreq,1)
			
			//获取 [疗程]
			s Dura = rset.Data("Dura")
			
			//构造结果串
			//格式: [医嘱名称] X [总量][总量单位] [用法] 每次[单次计量][单次计量单位] [频次] X [疗程] 
			//板蓝根颗粒(无糖)[3G 10袋/盒] X 1盒 KF-口服 每次3G ETIDAC X 1天
			if (Result="")
			{	s Result = OrderName_" X "_QtyPackUOM_PackUOMDesc_" "_Useage_"每次"_DoseQty_DoseUnit_" "_PHFreq_" X "_Dura }
			else
			{
				s Result = Result_$c(13,10)_OrderName_" X "_QtyPackUOM_PackUOMDesc_" "_Useage_"每次"_DoseQty_DoseUnit_" "_PHFreq_" X "_Dura
			}
			
		}
	
	}
	d rset.Close()
	/*	
	DHC-APP>d ##class(%ResultSet).RunQuery("web.DHCFOrdGet","GetOrdByAdm","30517","62525","62745","24","","","","")
	 
	OrdCreateDate:OrdCreateTime:OrdStartDate:OrdStartTime:ArcimDesc:DoseQty:DoseUnit:Priority:PHFreq:Instr:Doctor:OrdStatus:Dura:OEItemID	PatientID:SeqNo:QtyPackUOM:PackUOMDesc:PrescNo:dstatus:LabEpisodeNo:OrdLabSpec:OrdXDate:OrdXTime:OrdSkinTest:OrdAction:OrdDepProcNotes:OrdBilled:OrdSkinTestResult:RePay:
	2012-09-07:09:56:2012-09-07:23:59:全血细胞分析(东急):::临时医嘱:::张晖:停止::30124||5:4510715:1::次:::2000394026:血:::N:::P:::
	2012-09-07:09:56:2012-09-07:23:59:肝功2(东急):::临时医嘱:::张晖:停止::30124||6:4510715:2::次:::2000394027:血:::N:::P:::
	2012-09-07:09:56:2012-09-07:23:59:肾全1(东急):::临时医嘱:::张晖:停止::30124||7:4510715:3::次:::2000394027:血:::N:::P:::
	2012-10-15:13:31:2012-10-15:23:59:全血细胞分析(东急):::临时医嘱:::张晖:未激活::30124||47:4510715:4::次::::血:::N:::TB:::
	2012-10-15:13:31:2012-10-15:23:59:尿常规(东急):::临时医嘱:::张晖:未激活::30124||48:4510715:5::次::::尿:::N:::TB:::
	2012-10-15:13:31:2012-10-15:23:59:粪便常规+潜血(急诊):::临时医嘱:::张晖:未激活::30124||49:4510715:6::次::::便:::N:::TB:::
	2012-10-15:13:31:2012-10-15:23:59:肝功2(东急):::临时医嘱:::张晖:未激活::30124||50:4510715:7::次::::血:::N:::TB:::
	2012-10-15:17:30:2012-10-15:17:30:伏乐新(头孢呋辛酯片)[0.25G 12片/盒]:0.25:G:临时医嘱:EBID:KF-口服:张晖:未激活:1天:30124||56	4510715:51:1:盒(12)::未发:::::N:::TB:::
	2012-10-15:17:38:2012-10-15:17:38:感冒清热颗粒(无糖)[6G 10袋/盒]:6:G:临时医嘱:ETID:KF-口服:张晖:未激活:1天:30124||57	4510715:52:1:盒(10)::未发:::::N:::TB:::
	2012-10-15:17:39:2012-10-15:17:38:板蓝根颗粒(无糖)[3G 10袋/盒]:3:G:临时医嘱:ETIDAC:KF-口服:张晖:未激活:1天:30124||58	4510715:53:1:盒(10)::未发:::::N:::TB:::
	DHC-APP>
	*/
	
	q Result
	
ConvertDataStyle(ItemVal,ItemType="")
	
	q:($d(ItemVal)=0)||(ItemVal="") ""
	
	if (ItemType="1")
	{
		// [频次] 截第1个字母 病人类型标志
		s:($e(ItemVal,1)="I")||($e(ItemVal,1)="E")||($e(ItemVal,1)="O") ItemVal = $e(ItemVal,2,$l(ItemVal))
	}
	else
	{
		s ItemVal = $p($g(ItemVal),"(")
	
		s ItemVal = $p($g(ItemVal),"（")
	
		s:($f(ItemVal,"-")'=0) ItemVal = $p(ItemVal,"-",2)
	}
		
	q ItemVal
}

/// 20110609 wangwentao add 南通项目补充
/// Desc:	住院病案号 
/// Table:	PA_PatMas.PAPMI_Medicare
ClassMethod IPRecordNoByMR(argAdmID As %String, argHospital As %String = "") As %String
{
 
	q:(($d(argAdmID)=0)||(argAdmID="")) ""
	
	s recordNo = ""
	
	//医院
	//if argHospital=..#HospitalBJJSTYY {
	//	s recordNo=$p($g(^PAPER(argPapmiDR,"PAT",1)),"^",22)
	//	if ((recordNo?1L.N)||(recordNo?1U.N)) {s recordNo=$e(recordNo,2,$l(recordNo))}
	//	q recordNo
	//}
	
	// 医政组历史接口
	s recordNo = ##Class(web.DHCWMRService).IGetMrTypeInfo(argAdmID)
	s:(recordNo'="") recordNo=$p(recordNo,"^",1)	
	
	q recordNo
}

/// Desc:	医政组统一住院病案号 
/// update:	2013-04-01  10:50:28 医政邮件统一接口
ClassMethod IPRecordNoByMRNew(argAdmID As %String, argHospital As %String = "") As %String
{
 
	q:(($d(argAdmID)=0)||(argAdmID="")) ""
	
	s recordNo = ""
	
	//2013-04-01  10:50:28 医政组邮件统一接口
	s recordNo = ##Class(web.DHCWMRService).IGetMrNoByEpisodeID(argAdmID)
	
	q recordNo
}

/// Creator:	wangwentao
/// CreatDate:	20120614 温岭项目添加
/// Desc:	出院条件(医生医疗结算界面)
/// Table：	SQLUser.MR_Adm
/// Output：RowId^Code^Desc
/// Example:w ##Class(EPRservice.HISInterface.PatientInfoAssist).GetDischCondition(1)
ClassMethod GetDischCondition(AEpisodeID As %String) As %String
{
	s ret = ""
	
	q:(($d(AEpisodeID)=0)||(AEpisodeID="")) ret
	
	
	s MRAdmDR = $p($g(^PAADM(AEpisodeID)),"^",61)
	q:(MRAdmDR = "") ret
	
	s DischConditionDR = $p($g(^MR(MRAdmDR,"PRO",1)),"^",10)
	s:(DischConditionDR '= "") ret = DischConditionDR_"^"_$p($g(^PAC("DISCON",DischConditionDR)),"^",1)_"^"_$p($g(^PAC("DISCON",DischConditionDR)),"^",2)
	
	q ret
}

/// Creator:	wangwentao
/// CreatDate:	20121102
/// Description:获取病案首页医保金额和自负金额
/// Table:		/
/// Input:		AAdmId是病人就诊ID[PA_Adm表RowID]
/// 			AHospital是医院标识
/// Output:		Result( YBJE^ZFJE )
/// Others:		医保组给出按账单的函数 计费组给出按AdmID的函数2012-04-19邮件
/// Example:	w ##Class(EPRservice.HISInterface.PatientInfoAssist).GetINSUFeeByAdmID(AdmID)
ClassMethod GetINSUFeeByAdmID(AAdmId As %String, AHospital As %String = "")
{
	q:(($d(AAdmId)=0)||(AAdmId="")) ""
	
	s Result = "",YBJE=0.00,ZFJE=0.00
	
	s pbRowid="0"  f  s pbRowid=$o(^DHCPB(0,"ADM",AAdmId,pbRowid)) q:pbRowid=""  d
	.s rtn=##class(web.DHCINSUPort).GetDivByBill(pbRowid)
	.s YBJE=YBJE++$p(rtn,"^",1)
	.s ZFJE=ZFJE++$p(rtn,"^",2)
	
	s Result = YBJE_"^"_ZFJE
	
	q Result
}

/// Creator:	wangwentao
/// CreatDate:	20130226 北京地坛项目添加 By WangLi 2009-10-31
/// Desc:	急诊病案号(医政组)
ClassMethod EPRecordNoWMR(argPaperDR As %String, argHospital As %String = "")
{
	q:(($d(argPaperDR)=0)||(argPaperDR="")) ""
	s recordNo=""
	
	s emedicareDR=##class(web.DHCWMRService).GetMrNoByPapmiServiceE(argPaperDR)
	if emedicareDR'=""
	{
		s recordNo=##class(web.DHCWMRService).GetMrNoByPapmiServiceQ(argPaperDR)
	}

	q recordNo
}

/// Creator:	wangwentao
/// CreatDate:	20130517 BJDTYY ADD, 20130608 BJFCYY UPDATE
/// Desc:	医联码
/// Table：	SQLUser.PA_Patmas,SQLUser.DHC_Person
/// Output:	Code
/// Debug:	w ##class(EPRservice.HISInterface.PatientInfoAssist).MedicalLinkNo(PaperDR)
ClassMethod MedicalLinkNo(argPaperDR As %String, argHospital As %String = "") As %String
{
	q:(($d(argPaperDR)=0)||(argPaperDR="")) ""
	
	s MedicalLinkNo=""
	s:(argHospital="") argHospital=##class(EPRmeta.SysOption).GetOptionValueByName("HospitalName")
	
	//北京妇产医院的医联码字段是DHC_Person 中 PAPER_MedUnionCard 字段 Global 是 $p($g(^DHCPERSON(RowId)),"^",13)
	if (argHospital=..#HospitalBJFCYY)
	{
		//北京妇产医院的医联码字段是DHC_Person 中 PAPER_MedUnionCard 字段 Global 是 $p($g(^DHCPERSON(RowId)),"^",13)
		s DHCPersonDR=""
		s DHCPersonDR=$o(^DHCPERSON(0,"PAPERSON",argPaperDR,DHCPersonDR))

		s:(DHCPersonDR'="") MedicalLinkNo = $p($g(^DHCPERSON(DHCPersonDR)),"^",13)
	}
	else
	{
		//SQLUser.PA_Patmas.PAPMI_HealthFundNo
		s MedicalLinkNo=$P($G(^PAPER(argPaperDR,"PAT",3)),"^",12)
	}
	
	q MedicalLinkNo
}

/// Creator:	wangwentao
/// CreatDate:	20130703 补北京妇产医院添加的既往方法
/// Desc:	[特定病种质量监测指标-剖宫产->剖宫产术后二次手术]{有,无}(临床组提供)
/// Debug:	##class(EPRservice.HISInterface.PatientInfoAssist).GetCaesPostOper2ndFlag(AAdmID)
ClassMethod GetCaesPostOper2ndFlag(AAdmID As %String) As %String
{
	q:(($d(AAdmID)=0)||(AAdmID="")) ""
	
	//Caesarean PostOperation Second Flag
	s CaesPostOper2ndFlag=""
	
	s GetCaesPostOper2ndFlag=##class(web.DHCANAdaptor).GetPatOpPostExistFlag(AAdmID)

	q GetCaesPostOper2ndFlag
}

/// Creator:	wangwentao
/// CreatDate:	20130703 补北京妇产医院添加的既往方法
/// Desc:	[特定病种质量监测指标-剖宫产->剖宫产术后出院时间]{N}(临床组提供)
/// Debug:	##class(EPRservice.HISInterface.PatientInfoAssist).GetCaesPostOperDisDay(AAdmID)
ClassMethod GetCaesPostOperDisDay(AAdmID As %String) As %String
{
	q:(($d(AAdmID)=0)||(AAdmID="")) ""
	
	//Caesarean PostOperation Discharge Day
	s CaesPostOperDisDay=""

	s CaesPostOperDisDay=##class(web.DHCANAdaptor).GetPatOpEndAndDischargeDay(AAdmID)
	
	q CaesPostOperDisDay
}

/// Creator:	wangwentao
/// CreatDate:	20130703 补北京妇产医院添加的既往方法	
/// Desc:	[病案首页-其它情况->日常生活能力评定]{入院|75^出院|100}(护理组提供)
/// Debug:	##class(EPRservice.HISInterface.PatientInfoAssist).GetADLAssessment(AAdmID)
ClassMethod GetADLAssessment(AAdmID As %String) As %String
{
	q:(($d(AAdmID)=0)||(AAdmID="")) ""
	
	//Activities Of Daily Living Assessment
	s ADLAssessment=""

	s ADLAssessment=##class(Nur.DHCMoudDataSub).getshnlpf(AAdmID)
	
	q ADLAssessment
}

/// Creator:	wangwentao
/// CreatDate:	20130703 补北京妇产医院添加的既往方法	
/// Desc:	[病理号]{返回格式:病理号1^病理号2^病理号3^...}(病理组提供)
/// Debug:	##class(EPRservice.HISInterface.PatientInfoAssist).GetPISNo(AAdmID)
ClassMethod GetPISNo(AAdmID As %String) As %String
{
	q:(($d(AAdmID)=0)||(AAdmID="")) ""
	
	s (PISNo,PISData,PISDataCount,PISDataItem,tmpPISNo)=""

	//返回结果格式:病理号1^病理诊断结果1#病理号2^病理诊断结果2#...
	s PISData=##class(web.GetPisData).GetPisDateByAdm(AAdmID)
	if PISData'=""
	{
		s PISDataCount = $l(PISData,"#")
		for i=1:1:PISDataCount
        {
	        s PISDataItem = $p(PISData,"#",i)
	        
	        s tmpPISNo = $p(PISDataItem,"^",1)
	        
	        if (PISNo'="")
	        {
		        s PISNo = PISNo_"^"_tmpPISNo
	        }
	        else
	        {
		        s PISNo = tmpPISNo
	        }
        }
	}
	
	q PISNo
}

/// Creator:	wangwentao
/// CreatDate:	20130703 补北京妇产医院添加的既往方法	
/// Desc:	[病理诊断]{返回格式:病理诊断结果1^病理诊断结果2^病理诊断结果3^...}(病理组提供)
/// Debug:	##class(EPRservice.HISInterface.PatientInfoAssist).GetPISDiagnos(AAdmID)
ClassMethod GetPISDiagnos(AAdmID As %String) As %String
{
	q:(($d(AAdmID)=0)||(AAdmID="")) ""
	
	s (PISDiagnos,PISData,PISDataCount,PISDataItem,tmpPISDiagnos)=""
	
	//返回结果格式:病理号1^病理诊断结果1#病理号2^病理诊断结果2#...
	s PISData=##class(web.GetPisData).GetPisDateByAdm(AAdmID)
	if PISData'=""
	{
		s PISDataCount = $l(PISData,"#")
		for i=1:1:PISDataCount
        {
	        s PISDataItem = $p(PISData,"#",i)
	        
	        s tmpPISDiagnos = $p(PISDataItem,"^",2)
	        
	        if (PISDiagnos'="")
	        {
		        s PISDiagnos = PISDiagnos_"^"_tmpPISDiagnos
	        }
	        else
	        {
		        s PISDiagnos = tmpPISDiagnos
	        }
        }
	}
	
	q PISDiagnos
}

/// Creator:	wangwentao
/// CreatDate:	20130703 补北京妇产医院添加的既往方法
/// Desc:	[病案首页-手术情况-是否为急诊手术]{是,否,无手术}(手醉组提供)
/// Debug:	##class(EPRservice.HISInterface.PatientInfoAssist).GetOperEmergencyFlag(AAdmID)
ClassMethod GetOperEmergencyFlag(AAdmID As %String) As %String
{
	q:(($d(AAdmID)=0)||(AAdmID="")) ""
	
	//Operation Emergency Flag
	s OperEmergencyFlag=""
	
	s OperEmergencyFlag=##Class(web.ExpTongRenInfo).GetOperEmer(AAdmID)

	q OperEmergencyFlag
}

/// Creator:	wangwentao
/// CreatDate:	20130710 补北京妇产医院添加的既往方法
/// Desc:	[根据EpisodeID取此次IP就诊对应的住院次数](医政组提供)
/// Debug:	##class(EPRservice.HISInterface.PatientInfoAssist).GetInTimesWMR(AAdmID)
ClassMethod GetInTimesWMR(AAdmID As %String) As %String
{
	q:(($d(AAdmID)=0)||(AAdmID="")) ""
	
	s InTimesWMR=""
	
	s InTimesWMR=##Class(web.DHCWMRService).IGetIPCountByEpisodeID(AAdmID)
	
	s InTimesWMR=$CASE(InTimesWMR,-1:"",0:1,:InTimesWMR)

	q InTimesWMR
	
	/*
	/// Modify 入院次数
	/// Creator：    刘学峰
	/// CreatDate：  2009-07-06
	/// Service User:电子病历组
	/// Description：根据EpisodeID取此次IP就诊对应的住院次数
	/// Table：      DHC_WMR_MainVolume
	/// Input：      EpisodeID
	/// Return：     -1或住院次数。如果EpisodeID为空，返回-1
	/// Debug:       w ##Class(web.DHCWMRService).IGetIPCountByEpisodeID(EpisodeID)
	ClassMethod IGetIPCountByEpisodeID(EpisodeID)
	{
	    //n (EpisodeID)
	    //^DHCWMRVOL(0,"VolAdm",{Paadm_Dr},{DHC_WMR_MainVolume.Rowid},{ChildSub})
	    s ret=-1
	    q:EpisodeID="" ret
	    
	    s IPCount=0
	    s FindFlag="N"
	    s VolumeID=""
	    f  s VolumeID=$o(^DHCWMRVOL(0,"VolAdm",EpisodeID,VolumeID),-1) q:(VolumeID="")||(FindFlag="Y")  d
	    .q:VolumeID=""
	    .s sVolume=$g(^DHCWMRVOL(+VolumeID))
	    .s IsActive=$p(sVolume,"^",7)
	    .q:IsActive'="Y"
	    .s FindFlag="Y"
	    .s IPCount=$p(sVolume,"^",9)
		
	    q IPCount
	}
	//*/
}

/// Creator: wangwentao HNZLYY
/// 	20130712 wangwentao update BJFCYY
/// Desc: 引用 web.DHCBldReqLabInfo
/// Output: BG_"^"_Rh_"^"_RBC_"^"_HCT_"^"_HGB_"^"_PLT_"^"_ALT_"^"_HBsAg_"^"_AntiHBs_"^"_HBeAg_"^"_AntiHBe_"^"_AntiHBc_"^"_AntiHCV_"^"_AntiHIV_"^"_MD
/// 		1------2------3-------4-------5-------6-------7-------8---------9-----------10--------11----------12----------13----------14----------15
/// Test: w ##class(EPRservice.HISInterface.PatientInfoAssist).GetLabBldInfo(50035)
ClassMethod GetLabBldInfoByLabItemStr(AAdmId As %String, ALabItemStr As %String = "") As %String
{
	
	q:($d(AAdmId)=0)||(AAdmId="") ""
	q:($d(ALabItemStr)=0)||(ALabItemStr="") ""

	s SpaceHIS=##class(EPRmeta.SysOption).GetOptionValueByName("NameSpaceHIS")
	if SpaceHIS'=""
	{
		s MEDDATA = $p($g(SpaceHIS),"^",1)
		s WEBSRC  = $p($g(SpaceHIS),"^",2)
	}
	s SpaceLIS=##class(EPRmeta.SysOption).GetOptionValueByName("NameSpaceLIS")
	if SpaceLIS'=""
	{
	    s LABDATA = $p($g(SpaceLIS),"^",1)
	    s LABSRC  = $p($g(SpaceLIS),"^",2)
	}
	
	s papmiId=+^PAADM(AAdmId)
	s debtorDR=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	
	s (BG,Rh,RBC,HCT,HGB,PLT,ALT,HBsAg,AntiHBs,HBeAg,AntiHBe,AntiHBc,AntiHCV,AntiHIV,MD) =""
 
  ZN LABDATA
  
  	//BG	1		ABO血型
	//Rh	2		Rh血型
	  s bldGpId=""
	  i $d(^TDEB(debtorDR)) s bldGpId=$p(^TDEB(debtorDR),"\",4)
	  i '$l(bldGpId),$d(^TDEB(debtorDR)) s bldGpId=$p(^TDEB(debtorDR),"\",10)
	  s BG="",Rh=""
	  i $l(bldGpId) d
	  .s BG=$p(^TTAB("BB-BG",bldGpId),"\",2)_"型"
	  .i $p(^TTAB("BB-BG",bldGpId),"\",3)="P" s Rh="阳性(+)"
	  .i $p(^TTAB("BB-BG",bldGpId),"\",3)="N" s Rh="阴性(-)"
  
	//RBC	3		RBC
	if $p(ALabItemStr,"^",3)'=""
	{
		s LabItemStr = $p(ALabItemStr,"^",3)
	 	//--------------------
	  s dt=0,RBC=""
	  s res=$$getResult(debtorDR,LabItemStr)
	  i $l(res) d
	  .i +$p(res,"^",1)>dt s RBC=$p(res,$c(1),2),dt=+$p(res,"^",1)

	}

	//HCT	4		HCT
	if $p(ALabItemStr,"^",4)'=""
	{
		s LabItemStr = $p(ALabItemStr,"^",4)
	 	//--------------------
	  s dt=0,HCT=""
	  s res=$$getResult(debtorDR,LabItemStr)
	  i $l(res) d
	  .i +$p(res,"^",1)>dt s HCT=$p(res,$c(1),2),dt=+$p(res,"^",1)

	}

	//HGB	5		HGB
	if $p(ALabItemStr,"^",5)'=""
	{
		s LabItemStr = $p(ALabItemStr,"^",5)
	 	//--------------------
	  s dt=0,HGB=""
	  s res=$$getResult(debtorDR,LabItemStr)
	  i $l(res) d
	  .i +$p(res,"^",1)>dt s HGB=$p(res,$c(1),2),dt=+$p(res,"^",1)

	}

	//PLT	6		PLT
	if $p(ALabItemStr,"^",6)'=""
	{
		s LabItemStr = $p(ALabItemStr,"^",6)
	 	//--------------------
	  s dt=0,PLT=""
	  s res=$$getResult(debtorDR,LabItemStr)
	  i $l(res) d
	  .i +$p(res,"^",1)>dt s PLT=$p(res,$c(1),2),dt=+$p(res,"^",1)

	}

	//ALT	7		ALT
	if $p(ALabItemStr,"^",7)'=""
	{
		s LabItemStr = $p(ALabItemStr,"^",7)
	 	//--------------------
	  s dt=0,ALT=""
	  s res=$$getResult(debtorDR,LabItemStr)
	  i $l(res) d
	  .i +$p(res,"^",1)>dt s ALT=$p(res,$c(1),2),dt=+$p(res,"^",1)

	}

	//HBsAg		8	HbsAg乙肝病毒表面抗原	
	if $p(ALabItemStr,"^",8)'=""
	{
		s LabItemStr = $p(ALabItemStr,"^",8)

		s ind="" for ind=1:1:$l(LabItemStr,"|") {
		  q:(HBsAg'="")
		  s LabItemID = $p(LabItemStr,"|",ind)
		  //--------------------
		  s dt=0,HBsAg=""
		  s res=$$getResult(debtorDR,LabItemID)
		  i $l(res) d
		  .i +$p(res,"^",1)>dt s HBsAg=$p(res,$c(1),2),dt=+$p(res,"^",1)
		}
	}

	//AntiHBs	9		HBsAb
	if $p(ALabItemStr,"^",9)'=""
	{
		s LabItemStr = $p(ALabItemStr,"^",9)
	 	//--------------------

	  s dt=0,AntiHBs=""
	  s res=$$getResult(debtorDR,LabItemStr)
	  i $l(res) d
	  .i +$p(res,"^",1)>dt s AntiHBs=$p(res,$c(1),2),dt=+$p(res,"^",1)

	}

	//HBeAg	10		HBeAg
	if $p(ALabItemStr,"^",10)'=""
	{
		s LabItemStr = $p(ALabItemStr,"^",10)
	 	//--------------------

	  s dt=0,HBeAg=""
	  s res=$$getResult(debtorDR,LabItemStr)
	  i $l(res) d
	  .i +$p(res,"^",1)>dt s HBeAg=$p(res,$c(1),2),dt=+$p(res,"^",1)

	}

	//AntiHBe	11		HBeAb
	if $p(ALabItemStr,"^",11)'=""
	{
		s LabItemStr = $p(ALabItemStr,"^",11)
	 	//--------------------

	  s dt=0,AntiHBe=""
	  s res=$$getResult(debtorDR,LabItemStr)
	  i $l(res) d
	  .i +$p(res,"^",1)>dt s AntiHBe=$p(res,$c(1),2),dt=+$p(res,"^",1)

	}

	//AntiHBc	12		HBcAb
	if $p(ALabItemStr,"^",12)'=""
	{
		s LabItemStr = $p(ALabItemStr,"^",12)
	 	//--------------------

	  s dt=0,AntiHBc=""
	  s res=$$getResult(debtorDR,LabItemStr)
	  i $l(res) d
	  .i +$p(res,"^",1)>dt s AntiHBc=$p(res,$c(1),2),dt=+$p(res,"^",1)

	}
  
	//AntiHCV	13		HCVAb丙型肝炎病毒抗体
	if $p(ALabItemStr,"^",13)'=""
	{
		s LabItemStr = $p(ALabItemStr,"^",13)
	 
		s ind="" for ind=1:1:$l(LabItemStr,"|") {
		  q:(AntiHCV'="")
		  s LabItemID = $p(LabItemStr,"|",ind)
		  //--------------------
		  s dt=0,AntiHCV=""
		  s res=$$getResult(debtorDR,LabItemID)
		  i $l(res) d
		  .i +$p(res,"^",1)>dt s AntiHCV=$p(res,$c(1),2),dt=+$p(res,"^",1)
		}
	}
  
	//AntiHIV	14			HIVAb艾滋病病毒抗体
	if $p(ALabItemStr,"^",14)'=""
	{
		s LabItemStr = $p(ALabItemStr,"^",14)
	 
		s ind="" for ind=1:1:$l(LabItemStr,"|") {
		  q:(AntiHIV'="")
		  s LabItemID = $p(LabItemStr,"|",ind)
		  //--------------------
		  s dt=0,AntiHIV=""
		  s res=$$getResult(debtorDR,LabItemID)
		  i $l(res) d
		  .i +$p(res,"^",1)>dt s AntiHIV=$p(res,$c(1),2),dt=+$p(res,"^",1)
		}
	}

	//MD		15		MD梅毒
	if $p(ALabItemStr,"^",15)'=""
	{
		s LabItemStr = $p(ALabItemStr,"^",15)
	 
		s ind="" for ind=1:1:$l(LabItemStr,"|") {
		  q:(MD'="")
		  s LabItemID = $p(LabItemStr,"|",ind)
		  //--------------------
		  s dt=0,MD=""
		  s res=$$getResult(debtorDR,LabItemID)
		  i $l(res) d
		  .i +$p(res,"^",1)>dt s MD=$p(res,$c(1),2),dt=+$p(res,"^",1)
		}
	}

  
  zn WEBSRC
  
  s retStr=BG_"^"_Rh_"^"_RBC_"^"_HCT_"^"_HGB_"^"_PLT_"^"_ALT_"^"_HBsAg_"^"_AntiHBs_"^"_HBeAg_"^"_AntiHBe_"^"_AntiHBc_"^"_AntiHCV_"^"_AntiHIV_"^"_MD
  //s retval=itmjs_"('"_$ZCVT(retStr,"O","JS")_"');"
 // &javascript<#(retval)#>
  q retStr

getResult(debtor,tc)  ;TrakCare
  s ret=""
  i '$d(^TDHCOldResult(1,debtor,tc)) q ret
  i $d(^TDHCOldResult(1,debtor,tc)) d
  .s dd=$o(^TDHCOldResult(1,debtor,tc,""),-1)
  .i '$l(dd) q
  .s tt=$o(^TDHCOldResult(1,debtor,tc,dd,""),-1)
  .i '$l(tt) q
  .s x1=$o(^TDHCOldResult(1,debtor,tc,dd,tt,""),-1)
  .i '$l(x1) q
  .s x2=$o(^TDHCOldResult(1,debtor,tc,dd,tt,x1,""),-1)
  .i '$l(x2) q
  .s x3=$o(^TDHCOldResult(1,debtor,tc,dd,tt,x1,x2,""),-1)
  .i '$l(x3) q
  .i '$d(^TEPI(x1,1,x2,x3,"DATA",tc)) q
  .s ret=$p(^TEPI(x1,1,x2,x3,"DATA",tc),"\",1)
   s itmtype=$p(^TTAB("TC",tc),"\",3)
   i itmtype["N" d    ;numeric
   .s decimal=$e(itmtype,2)
   .i decimal="" s decimal="0"
   .s temres=$$CheckResDecimal^CHDhcLabReport(ret,decimal)
   .s ret=temres_$c(1)_temres
   ;文本
   i itmtype["X" d
   .s ret=ret_$c(1)_ret
   ;标准备注
   i itmtype["S" d
   .s preres=""
   .i $l(ret),$d(^TTAB("TC",tc,2,ret,1))  d
   ..s preres=$g(^TTAB("TC",tc,2,ret,1))
   .s ret=ret_$c(1)_preres
   ;血型
   i itmtype["B" d
   .s preres=""
   .i $l(ret),$d(^TTAB("BB-BG",ret)) d
   ..s preres=$p(^TTAB("BB-BG",ret),"\",1)
   .s ret=ret_$c(1)_preres
   ;安贞阴阳性处理
   s unit=$p(^TTAB("TC",tc),"\",2)
   ;转换类型
   i $p(^TTAB("TC",tc),"\",7)="Y" d
   .s tret=ret
   .s ret="("_$$standdata(tc,x1,ret)_")"
   .s ret=tret_ret_$c(1)_ret
   ;i $l(ret) s ret=dd_tt_"^"_ret_" "_unit
   i $l(ret) s ret=dd_"^"_ret_" "_unit
   q ret


standdata(itmcode,labno,res)  ;求正常值 
  s itmcode=$g(itmcode),res=$g(res)
  s sex=$P($g(^TEPI(labno)),"\",3)
  s age=$P($g(^TEPI(labno)),"\",25)
  s age=+age
  i sex="" s sex="M"
  s itmcode=$g(itmcode) 
  s ranges=""
  s tvalue=$$ranges^LVBVIS1(itmcode,age,sex,"",0,"","")
  s lowvalue=$p(tvalue,$c(1),1)
  s hvalue=$p(tvalue,$c(1),2)
  i $tr(tvalue,$c(1))'="" d
  .s ranges="{"_lowvalue_"-"_hvalue_"}"
  .s ranges=$tr(ranges,$c(1))
  i res'="" d
  .s res=$tr(res,">,<")
  .i ranges'="" d
  ..i $p(^TTAB("TC",itmcode),"\",7)="Y" d
  ...s res1="0"
  ...//-----DaiYi-----湖南省肿瘤--2010-01-26
  ...i $f(ranges,"-")>0,$tr($p(ranges,"-",2),"}")>0 d
  ....s low=$tr($p(ranges,"-",1),"{"),high=$tr($p(ranges,"-",2),"}")
  ....i res<low s res1="1"
  ....i res>high s res1="1"
  ...If $Tr($Tr($Piece(ranges,"-",2),"}")," ")="",$Tr($Tr($Piece(ranges,"-",1),"{")," ")'="" d
  ....s low=$Tr($tr($p(ranges,"-",1),"{"),"<")
  ....i res>low s res1="1"
  ...//----------------------
  ...i $d(^TTAB("TC",itmcode,2,res1)),$d(^TTAB("TC",itmcode,2,res1,1)) d
  ....s ranges=^TTAB("TC",itmcode,2,res1,1)
  q ranges
}

/// Creator:	wangwentao
/// CreatDate:	20130712 补北京妇产医院添加的既往方法
/// Desc:	[查询检验首次检验报告完成和末次检验报告完成时间]{YYYY-MM-DD HH:MM:SS,YYYY-MM-DD HH:MM:SS}(检验组提供)
/// Debug:	##class(EPRservice.HISInterface.PatientInfoAssist).GetLabRptFLDateTime(AAdmID,ATSGroup)
ClassMethod GetLabRptFLDateTime(AAdmID As %String, ATSGroup As %String) As %String
{
	q:(($d(AAdmID)=0)||(AAdmID="")) ""
	q:(($d(ATSGroup)=0)||(ATSGroup="")) ""
	
	s LabRptFLDateTime=""
	
	s LabRptFLDateTime=##Class(LabService.TSInfomation).TSDateTime(ATSGroup,AAdmID)
	
	s:(LabRptFLDateTime=" , ")||(LabRptFLDateTime=",") LabRptFLDateTime=""

	q LabRptFLDateTime
}

/// Creator:	wangwentao
/// CreatDate:	20130712 补北京妇产医院添加的既往方法
/// Desc:	[查询检查首次超声报告日期]{StudyNo#YYYY-MM-DD}{E20120206-P235#2012-02-06}(PACS组提供)
/// Debug:	##class(EPRservice.HISInterface.PatientInfoAssist).GetRisRptFDate(AAdmID)
ClassMethod GetRisRptFDate(AAdmID As %String) As %String
{
	q:(($d(AAdmID)=0)||(AAdmID="")) ""
	
	s RisRptFDate=""
	
	s RisRptFDate=##class(web.GetRisData).GetRisDateByAdm(AAdmID)

	q RisRptFDate
}

/// Creator:	wangwentao
/// CreatDate:	20130712 补北京妇产医院添加的既往方法
/// Desc:	[获取输血量]{红细胞,血小板,血浆,全血,其它}{红细胞\4,,血浆\400}(检验组提供)
/// Debug:	##class(EPRservice.HISInterface.PatientInfoAssist).GetLabBldTransfusion(AAdmID)
ClassMethod GetLabBldTransfusion(AAdmID As %String) As %String
{
	q:(($d(AAdmID)=0)||(AAdmID="")) ""
	
	s LabBldTransfusion=""
	
	//^DHCBLDINTERFACE(1,"BBORD",1)=红细胞(一个单位 = 200ml)
	//^DHCBLDINTERFACE(1,"BBORD",2)=血小板
	//^DHCBLDINTERFACE(1,"BBORD",3)=血浆
	//^DHCBLDINTERFACE(1,"BBORD",4)=全血
	//^DHCBLDINTERFACE(1,"BBORD",99)=其它
	s (HXB,XXB,XJ,QX,QT)=""
	
	s LabBldTransfusion = ##Class(LabService.BBResult).GetProductGroupByAdm(AAdmID)
	if (LabBldTransfusion'="")
	{
		s HXB = $p(LabBldTransfusion,",",1) s:(HXB'="") HXB=$p(HXB,"\",2),HXB=HXB*200
		s XXB = $p(LabBldTransfusion,",",2) s:(XXB'="") XXB=$p(XXB,"\",2)
		s XJ = $p(LabBldTransfusion,",",3) s:(XJ'="") XJ=$p(XJ,"\",2)
		s QX = $p(LabBldTransfusion,",",4) s:(QX'="") QX=$p(QX,"\",2)
		s QT = $p(LabBldTransfusion,",",5) s:(QT'="") QT=$p(QT,"\",2)
		
		s LabBldTransfusion = HXB_","_XXB_","_XJ_","_QX_","_QT
	}

	q LabBldTransfusion
}

/// Creator:	wangwentao
/// CreatDate:	20130715 补北京妇产医院添加的既往方法
/// Desc:	[病案首页-病人重返手术室^放弃治疗自动出院^出院是否完成临床路径]{是,否}{是,否}{已完成,未完成,未进入路径}(手醉组提供)
/// Debug:	##class(EPRservice.HISInterface.PatientInfoAssist).GetOperEmergencyFlag(AAdmID)
ClassMethod GetReOperRoomFlag(AAdmID As %String) As %String
{
	q:(($d(AAdmID)=0)||(AAdmID="")) ""
	
	//Return To OperationRoom Flag
	s ReOperRoomFlag=""
	
	s ReOperRoomFlag=##Class(web.ExpTongRenInfo).GetReOpRoom(AAdmID)

	q ReOperRoomFlag
}

/// Creator:	wangwentao
/// CreatDate:	20130715 wangwentao add bjfcyy
/// Desc:	获取城区地址
/// Table:	DHC_Person.PAPER_CityFlag
/// Debug:	##class(EPRservice.HISInterface.PatientInfoAssist).CityAreaAddress(argPaperDR)
ClassMethod CityAreaAddress(argPaperDR As %String) As %String
{
	q:(argPaperDR="") ""
	
	s retValue = ""
	
	s (DHCPersonDR,CAAddressDR)=""
	s DHCPersonDR=$o(^DHCPERSON(0,"PAPERSON",argPaperDR,DHCPersonDR))

	s:(DHCPersonDR'="") CAAddressDR = $p($g(^DHCPERSON(DHCPersonDR)),"^",12)
	
	if CAAddressDR'=""
	{
		s CAAddressDesc = $p($g(^CT("CITAREA",CAAddressDR)),"^",2)
		i $l(CAAddressDesc,"-")'=1 {s CAAddressDesc=$p($g(CAAddressDesc),"-",2)} 
		s CAAddressCode = $p($g(^CT("CITAREA",CAAddressDR)),"^",1)
		s retValue = CAAddressDR_"^"_CAAddressCode_"^"_CAAddressDesc
	}
	
	q retValue
}

/// Creator:	wangwentao
/// CreatDate:	20130717 补北京妇产医院添加的既往方法
/// Desc:	[病案首页-诊断及手术-ICD10编目信息](医政组提供)
/// Debug:	##class(EPRservice.HISInterface.PatientInfoAssist).GetICDCodingWMR(AAdmID,ADataType,AIndex)
ClassMethod GetICDCodingWMR(AAdmID As %String, ADataType As %String, AIndex As %String = "") As %String
{
	q:(($d(AAdmID)=0)||(AAdmID="")) ""
	q:(($d(ADataType)=0)||(ADataType="")) ""
	

	s ICDCoding=""
	
	s ICDCoding=##Class(web.DHCWMRCodingInterface).getFrontPageICD(AAdmID,ADataType,AIndex)

	q ICDCoding
}

/// Creator:	wangwentao
/// CreatDate:	20130717 补北京妇产医院添加的既往方法
/// Desc:	[病案首页-诊断及手术-ICD10编码员]{rowid/code/desc}(医政组提供)
/// Debug:	##class(EPRservice.HISInterface.PatientInfoAssist).GetICDCodingUserWMR(AAdmID)
ClassMethod GetICDCodingUserWMR(AAdmID As %String) As %String
{
	q:(($d(AAdmID)=0)||(AAdmID="")) ""

	s ICDCodingUser=""
	
	s ICDCodingUser=##class(web.DHCWMRCodingInterface).getCodingUserName(AAdmID)

	q ICDCodingUser
}

/// Creator:	wangwentao
/// CreatDate:	20130717 补北京妇产医院添加的既往方法
/// Desc:	[取手术信息]{OpDate_$c(2)_OpName_$c(2)_OpDoctor_$c(2)_Assistant1_$c(2)_Assistant2_$c(2)_AnaMethod_$c(2)_AnaDoctor}(手麻组提供)
/// Debug:	##class(EPRservice.HISInterface.PatientInfoAssist).GetOperationInfo(AAdmId)
ClassMethod GetOperationInfo(AAdmId As %String) As %String
{
	q:(($d(AAdmId)=0)||(AAdmId="")) ""
	
	s retValue=""
	//Get Operation Info from clinic
	s operStream = ##class(web.DHCANAdaptor).GetOperPatInfo("","",AAdmId,"")
	
	// Create an instance of %XML.Reader
	Set reader = ##class(%XML.Reader).%New()
	Set sc=reader.OpenStream(operStream)
	Quit:($$$ISERR(sc)) ""   
	// Associate a class name with the XML element name
	Do reader.Correlate("PatInfo","web.DHCANRegInterface")
	// read Sample.Person objects from xml file
	Set Count=0
	While reader.Next(.operation,.sc) {
	    Set Count=Count+1
	    s retValue = retValue_operation.OpDate_$c(2)_operation.OpName_$c(2)_operation.OpDoctor_$c(2)_operation.Assistant1_$c(2)_operation.Assistant2_$c(2)_operation.AnaMethod_$c(2)_operation.AnaDoctor_"^"
	    
	    Quit:($$$ISERR(sc))  
	}
	s retValue=$E(retValue,1,$L(retValue)-1)
	//w retValue_"!"_Count
	
	q retValue
}

/// Creator:	wangwentao
/// CreatDate:	20130717 补北京妇产医院添加的既往方法
/// Desc:	[通过医生描述获取医护人员表医生代码和描述]{CPUserCode_"^"_CPUserName}
/// Debug:	##class(EPRservice.HISInterface.PatientInfoAssist).GetCPUserDictFromDesc(argName)
ClassMethod GetCPUserDictFromDesc(argName As %String) As %String
{
	//s argName="李建立"
	q:(($d(argName)=0)||(argName="")) ""
	
	s RowID=0,Code=0
	f  s RowID=$O(^CTPCP(0,"Decs",argName,RowID)) q:RowID=""  d
	.i $G(^CTPCP(RowID,1))'=""  d
	..s Code=$p($G(^CTPCP(RowID,1)),"^",1)
	
	q Code_"^"_argName
}

/// Creator:	wangwentao
/// CreatDate:	20130717 补北京妇产医院添加的既往方法
/// Desc:	[通过手术描述获取手术表手术代码和描述]{OperCode_"^"_OperDesc}
/// Debug:	##class(EPRservice.HISInterface.PatientInfoAssist).GetOperDictFromDesc(argOper)
ClassMethod GetOperDictFromDesc(argOper As %String) As %String
{
	//s argOper="子宫肌瘤切除术"
	q:(($d(argOper)=0)||(argOper="")) ""
	
	s RowID=0,Code=0,firstOper=""
	s firstOper=$p(argOper," ",2)
	for  s RowID=$O(^ORC("OPER",0,"Desc",firstOper,RowID)) q:RowID=""  d
	.i $G(^ORC("OPER",RowID))'=""  d
	..s Code=$p($G(^ORC("OPER",RowID)),"^",1)
	
	q Code_"^"_argOper
}

/// Creator:	wangwentao
/// CreatDate:	20130717 补北京妇产医院添加的既往方法
/// Desc:	[通过麻醉描述获取麻醉表麻醉代码和描述]{AnaCode_"^"_AnaDesc}
/// Debug:	##class(EPRservice.HISInterface.PatientInfoAssist).GetAnaDictFromDesc(argAna)
ClassMethod GetAnaDictFromDesc(argAna As %String) As %String
{
	q:(($d(argAna)=0)||(argAna="")) ""
	
	s RowID=0,Code=0
	for  s RowID=$O(^ORC("ANMET",0,"Desc",argAna,RowID)) q:RowID=""  d
	.i $G(^ORC("ANMET",RowID))'=""  d
	..s Code=$p($G(^ORC("ANMET",RowID)),"^",1)
	
	q Code_"^"_argAna
}

/// Creator:	wangwentao
/// CreatDate:	20130717 补北京妇产医院添加的既往方法
/// Desc:	[获取分娩记录信息]{}(临床组提供)
/// Debug:	##class(EPRservice.HISInterface.PatientInfoAssist).GetDeliveryRecordInfo(AAdmID)
ClassMethod GetDeliveryRecordInfo(AAdmID As %String) As %String
{
	q:(($d(AAdmID)=0)||(AAdmID="")) ""
	
	s DeliveryRecordInfo = ""
	
	s DeliveryRecordInfo = ##class(web.DHCPregAdaptor).GetDeliveryInfo(AAdmID)

	q DeliveryRecordInfo
}

/// Creator:	wangwentao
/// CreatDate:	20130717 补北京妇产医院添加的既往方法
/// Desc:	[通过医护人员表医护人员DR获取用户表医生DR和代码和描述]{SSUserDR^SSUserCode^SSUserName$SSUserDR2^SSUserCode2^SSUserName2}
/// Debug:	##class(EPRservice.HISInterface.PatientInfoAssist).GetSSUserFromCPUserDR(ACareProvDR)
ClassMethod GetSSUserFromCPUserDR(ACareProvDR As %String) As %String
{

	q:(($d(ACareProvDR)=0)||(ACareProvDR="")) ""
	
	s (SSUserStr,SSUser,SSUserDR,SSUserCode,SSUserDesc) =""
	
	s SSUSRRowIdCount=0
	
	//取SS_User表SSUSR_CareProv_DR的值相同的记录条数
	&SQL(SELECT count(SSUSR_RowId) INTO :SSUSRRowIdCount FROM SQLUser.SS_User WHERE SSUSR_CareProv_DR = :ACareProvDR )
	for {
		s SSUserDR = $O(^SSU("SSUSR",0,"CTPCP",ACareProvDR,SSUserDR))
		q:(SSUserDR = "")
		
		//SS_User.SSUSR_Initials
		s SSUserCode = $p($g(^SSU("SSUSR",SSUserDR)),"^",1)
		//SS_User.SSUSR_Name
		s SSUserDesc = $p($g(^SSU("SSUSR",SSUserDR)),"^",2)
		
		if SSUserStr '=""
		{
			s SSUserStr = SSUserStr_"$"_SSUserDR_"^"_SSUserCode_"^"_SSUserDesc
		}
		else
		{
			s SSUserStr = SSUserDR_"^"_SSUserCode_"^"_SSUserDesc
		}	
	}
	
	q SSUserStr
}

/// ********************************************************************************************************
///  以下为测试代码
/// ********************************************************************************************************
/// 
/// w ##class(EPRservice.HISInterface.PatientInfoAssist).Test("63")
ClassMethod Test(argAdmId)
{
	s paperdr = ..GetPapmiDR(argAdmId)
	w "PaperDR: "_..GetPapmiDR(paperdr)
	w !,"PapmiNo:"_..GetPapmiNo(paperdr)
	w !,"Name:"_..Name(paperdr)
	w !,"Gender:"_..Gender(paperdr)
	w !,"Marriage:"_..Marriage(paperdr)
	w !,"IDCard:"_..IDCard(paperdr)
	w !,"Nation:"_..Nation(paperdr)
	w !,"Country:"_..Country(paperdr)
	w !,"Nationality:"_..Nationality(paperdr)
	w !,"Occupation:"_..Occupation(paperdr)
	w !,"Birthday:"_..Birthday(paperdr)
	w !,"BirthPlace"_": "_..BirthPlace(paperdr)
	w !,"Native"_": "_..Native(paperdr)
	w !,"ResidentAddress"_": "_..ResidentAddress(paperdr)
	w !,"ResidentPostCode"_": "_..ResidentPostCode(paperdr)
	w !,"HuKouAddress"_": "_..HuKouAddress(paperdr)
	w !,"HuKouPhone"_": "_..HuKouPhone(paperdr)
	w !,"HuKouPostCode"_": "_..HuKouPostCode(paperdr)
	w !,"WorkAddress"_": "_..WorkAddress(paperdr)
	w !,"WorkPostCode"_": "_..WorkPostCode(paperdr)
	w !,"WorkPhone"_": "_..WorkPhone(paperdr)
	w !,"MobilePhone"_": "_..MobilePhone(paperdr)
	w !,"LinkmanAddress"_": "_..LinkmanAddress(paperdr)
	w !,"LinkmanName"_": "_..LinkmanName(paperdr)
	w !,"LinkmanPhone"_": "_..LinkmanPhone(paperdr)
	w !,"LinkmanRelation"_": "_..LinkmanRelation(paperdr)
	w !,"AdmDept"_": "_..AdmDept(argAdmId)
	w !,"AdmDateTime"_": "_..AdmDateTime(argAdmId)
	w !,"AdmDateTimeInBed"_": "_..AdmDateTimeInBed(argAdmId)
	w !,"AdmWard"_": "_..AdmWard(argAdmId)
	w !,"AdmBed"_": "_..AdmBed(argAdmId)
	w !,"AdmDoctor"_": "_..AdmDoctor(argAdmId)
	w !,"MainDoc"_": "_..MainDoc(argAdmId)
	w !,"AdmDiagnos"_": "_..AdmDiagnos(argAdmId)
	w !,"MainDiagnos"_": "_..MainDiagnos(argAdmId)
	w !,"CurrentDept"_": "_..CurrentDept(argAdmId)
	w !,"DisDept"_": "_..DisDept(argAdmId)
	w !,"DisWard"_": "_..DisWard(argAdmId)
	w !,"DisBed"_": "_..DisBed(argAdmId)
	w !,"DisDateTime"_": "_..DisDateTime(argAdmId)
	w !,"TransDept"_": "_..TransDept(argAdmId)
	w !,"TransDeptDetail"_": "_..TransDeptDetail(argAdmId)
	w !,"ResidentDays"_": "_..ResidentDays(argAdmId)
	w !,"GetMRAdmDR"_": "_..GetMRAdmDR(argAdmId)
	w !,"DisDateTimeMR"_": "_..DisDateTimeMR(argAdmId)
	w !,"DeathDateTime"_": "_..DeathDateTime(argAdmId)
	w !,"InTimes"_": "_..InTimes(argAdmId)
	//w !,"InTimesWMR"_": "_..InTimesWMR(argAdmId)
	w !,"InPatCostTrakCare"_": "_..InPatCostTrakCare(argAdmId)
	w !,"InPatCostTrakCareSub"_": "_..InPatCostTrakCareSub(argAdmId)
	w !,"PayType"_": "_..PayType(argAdmId)
	w !,"IMedicare"_": "_..IMedicare(argAdmId)
	w !,"OMedicare"_": "_..OMedicare(argAdmId)
	w !,"EMedicare"_": "_..EMedicare(argAdmId)
	w !,"InsuranceNo"_": "_..InsuranceNo(argAdmId)
	w !,"CareUnit"_": "_..CareUnit(argAdmId)
	w !,"GetOrdersXiYao"_": "_..GetOrdersXiYao(argAdmId)
	//w !,"GetOrdersCaoYao"_": "_..GetOrdersCaoYao(argAdmId)
	w !, "Hospital"_": "_..HospitalName()
	w !,"NameSpaces"_": "_..NameSpaces()
}

/// 
/// ********************************************************************************************************
///  以上为测试代码
/// ********************************************************************************************************
/// ******************************************************************************************
/// 以下为停用方法，仅为代码兼容保留
/// ******************************************************************************************
/// 
/// Desc:	出院诊断，停用
ClassMethod OutDiag(argAdmId As %String, argHospital As %String, argMeddata As %String) As %String
{
	q:($d(argAdmId)=0)||($d(argHospital)=0)||($d(argMeddata)=0)||(argAdmId="")||(argHospital="")||(argMeddata="") ""
	s outdiag=""
	if argHospital=..#HospitalBJAZYY {
		s space = $zu(5)
		d $zu(5,argMeddata)
		s outdiag=$$GetMRICDDesc^DHCFee(argAdmId)
		s outdiag=$p($g(outdiag),",",1)
		d $zu(5, space)
	}
	q outdiag
}

/// Desc:	取费用信息，停用
ClassMethod InPatientCostForFP(argAdmId As %String, argMeddata As %String) As %String
{
	q:($d(argAdmId)=0)||($d(argMeddata)=0)||(argAdmId="")||(argMeddata="") ""
	s totalfee=""

	s space = $zu(5)
	
	d $zu(5,argMeddata)
	s totalfee=$$selAdmFeeForFP^DHCAdmFeeNew(argAdmId)
	d $zu(5, space)
	
	q totalfee
}

/// Desc:	取费用信息，停用
ClassMethod InPatientCost(argAdmId As %String, argHospital As %String, argMeddata As %String) As %String
{
	//各项住院费用
	//
	q:($d(argAdmId)=0)||($d(argHospital)=0)||($d(argMeddata)=0)||(argAdmId="")||(argHospital="")||(argMeddata="") ""
	s totalfee=""
	if argHospital=..#HospitalBJAZYY {
		s space = $zu(5)
		d $zu(5,argMeddata)
		s totalfee=$$GetPatBill^DHCFee(argAdmId)
		d $zu(5, space)
	}
	q totalfee
}

/// Desc:	取费用信息，停用
ClassMethod InPatientCostOld(argAdmId As %String, argHospital As %String, argMeddata As %String) As %String
{
	//for JianChaFei, ZhiLiaoFei and QiTaFei of the original 19 fee 住院费用, 30项中没有, 19项中有
	//

	q:($d(argAdmId)=0)||($d(argHospital)=0)||($d(argMeddata)=0)||(argAdmId="")||(argHospital="")||(argMeddata="") ""
	s totalfeeOld=""
	if argHospital=..#HospitalBJAZYY {
		s space = $zu(5)
		d $zu(5,argMeddata)
		s totalfeeOld=$$selAdmFeeNew^DHCAdmFee(argAdmId)
		d $zu(5, space)
	}
	q totalfeeOld
}

/// Desc: 	门诊病案号，停用，使用 OPRecordNo 代替
ClassMethod OutPatientID(argPapmiDR As %String, argHospital As %String = "") As %String
{
	q:(($d(argPapmiDR)=0)||(argPapmiDR="")) ""
	q ..OPRecordNo(argPapmiDR, argHospital)
}

/// Desc:	住院病案号，停用，使用 IPRecordNo 代替
ClassMethod PatientRecordID(argPapmiDR As %String, argHospital As %String = "") As %String
{
	q:(($d(argPapmiDR)=0)||(argPapmiDR="")) ""
	q ..IPRecordNo(argPapmiDR, argHospital)
}

/// Desc: 	年龄(岁或者天, 不带单位), 停用，not different from hospitals 
ClassMethod Ageold(argBirthday As %String, argAdmDate As %String, argMeddata As %String) As %String
{
 	q:($d(argBirthday)=0)||($d(argAdmDate)=0)||($d(argMeddata)=0)||($d(argBirthday)=0)||(argAdmDate="")||(argMeddata="") ""
 	s tmpAge="",ageYears="",ageMonths="",ageDays="",age=""
 	
 	s curSpace = $zu(5)
 	d $zu(5,argMeddata)
	s tmpAge=$$CalAge^at182(argBirthday,argAdmDate)
	d $zu(5,curSpace)
	if (tmpAge'="")&&($l(tmpAge,"|")'<14) {
	  s ageYears=$p($g(tmpAge),"|",12)
	  s ageMonths=$p($g(tmpAge),"|",13)
	  s ageDays=$p($g(tmpAge),"|",14)
	  if (ageYears'=0) {s age=ageYears}
	  else {s age=argAdmDate-argBirthday}
	  }
	q age
}

/// Desc: 	年龄(岁或者天, 不带单位), 停用，not different from hospitals 
ClassMethod Ageold2(argAdmId As %String, argBirthday As %String, argAdmDate As %String, argHospital As %String, argMeddata As %String, argWebsrc As %String) As %String
{

	 q:($d(argAdmId)=0)||($d(argBirthday)=0)||($d(argAdmDate)=0)||($d(argHospital)=0)||($d(argMeddata)=0)||($d(argWebsrc)=0) ""
	 q:(argAdmId="")||(argBirthday="")||(argAdmDate="")||(argHospital="")||(argMeddata="")||(argWebsrc="") ""
	 
	 s tmpAge="",ageYears="",ageMonths="",ageDays=""
	 s age="",ageday="",medicareage="",medicareageunit="",medicareageyear=""

	 if argHospital=..#HospitalHXYY
	 {
		 s tmpAge="",ageYears=0,ageMonths=0,ageDays=0,age=""
		 s curSpace = $zu(5)
		 d $zu(5,argMeddata)
		 s tmpAge=$$CalAge^at182(argBirthday,argAdmDate)
		 d $zu(5,curSpace)
		 if (tmpAge'="")&&($l(tmpAge,"|")'<14) 
		 {
			 s ageYears=$p($g(tmpAge),"|",12)
			 s ageMonths=$p($g(tmpAge),"|",13)
			 s ageDays=$p($g(tmpAge),"|",14)
			 if (ageYears'=0) {s age=ageYears_"岁"_ageMonths_"月"}
			 elseif (ageMonths'=0) {s age=ageMonths_"月"_ageDays_"天"}
			 elseif (ageDays'<30) {s age="1月0天"}
			 else 
			 {
				 s papmidr=##class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiDR(argAdmId)
				 w "papmidr: "_papmidr,!
				 q:(papmidr="") ""
				 s birthTimeString=$g(^PAPER("DHC",papmidr,1))
				 w "birthTimeString: "_birthTimeString,!
				 s birthday=$p($g(birthTimeString),"^",1)
				 w "birthday: "_birthday,!
				 s birthTime=$p($g(birthTimeString),"^",2)
				 w "birthTime: "_birthTime,!
				 s currentDay=$p($h,",",1)
				 s currentTime=$p($h,",",2)
				 i (birthday'="")&(currentTime'="")  d
				 .s ageDays=currentDay-birthday
				 .s currentTime=+currentTime
				 .s birthTime=+birthTime
				 .i currentTime>birthTime  d 
				 ..s ageSeconds=currentTime-birthTime
				 ..s ageHours=ageSeconds\3600
				 ..s ageMinutes=ageSeconds#3600\60
				 .e  d
				 ..s ageSeconds=birthTime-currentTime
				 ..s ageSeconds=86399-ageSeconds
				 ..s ageDays=ageDays-1
				 ..s ageHours=ageSeconds\3600
				 ..s ageMinutes=ageSeconds#3600\60
				 .s age=ageDays_"天"_ageHours_"小时"_ageMinutes_"分钟"
				 e  d
				 .s argAdmDate1=$zd(argAdmDate,3)
				 .s argBirthday1=$zd(argBirthday,3)
				 .s age=##class(web.UDHCJFCOMMON).GetAge(argAdmDate1, argBirthday1)
	 		  }
	  	 }
	
	 }
	
	q age
}

/// Desc: 身份证号，停用，建议使用 IDCard，仅为代码兼容保留
ClassMethod PersonID(argPapmiDR As %String)
{
	q ..IDCard(argPapmiDR)
}

/// Desc:	国籍(保留该方法兼容以前代码)
/// Output：RowId^Code^Desc
/// Others: not different from hospitals
ClassMethod Nationality(argPaperDR As %String, argHospital As %String = "") As %String
{
	
	q:(($d(argPaperDR)=0)||(argPaperDR="")) ""
	
	q ..Country(argPaperDR, argHospital)
}

/// Desc:	现住址邮编, 停用，仅为保持代码兼容，建议使用ResidentPostCode
ClassMethod ResidentPostalCode(argPaperDR As %String, argHospital As %String = "") As %String
{
	
	q:(($d(argPaperDR)=0)||(argPaperDR="")) ""
	q ..ResidentPostCode(argPaperDR,argHospital)
}

/// Desc:	户口邮编,停用，仅为代码兼容，建议使用 HuKouPostCode
/// Output:	邮编
/// Table:	DHC_Person.PAPER_Comment1 	User.DHCPerson.cls 
ClassMethod HuKouPostalCode(argPaperDR As %String, argHospital As %String) As %String
{
	q:(($d(argPaperDR)=0)||(argPaperDR="")) ""
	q ..HuKouPostCode(argPaperDR, argHospital)
}

/// Desc:	移动电话, 停用，仅为保持代码兼容，建议使用MobilePhone
/// Table：	PA_Person.PAPER_MobPhone
/// Others：not different from hospitals
ClassMethod MoubilePhone(argPaperDR As %String, argHospital As %String = "") As %String
{
	q:(($d(argPaperDR)=0)||(argPaperDR="")) ""
	q ..MobilePhone(argPaperDR,argHospital)
}

/// Desc：	入院科室【返回: RowId^Code^Desc】
/// Table：	
/// OutPut:	RowId^Code^Desc
/// Others: not different from hospitals
ClassMethod InDept(argAdmId As %String, argHospital As %String = "") As %String
{
	q ..AdmDept(argAdmId, argHospital)
}

/// Desc：	出院状态【返回: Code】 用于深圳中医院
/// Table：	
/// OutPut:	Code
/// Others: w ##class(EPRservice.HISInterface.PatientInfoAssist).GetDischCondit("201864")
ClassMethod GetDischCondit(argAdmId As %String) As %String
{
	
	s dr = ""
    s dr = $P($g(^PAADM(argAdmId)), "^", 61)
    q:(dr = "") ""

    s condit = ""
    s condit = $P($g(^MR(dr, "PRO", 1)), "^", 10)
    q:(condit = "") 1
    q condit
}

/// Desc：	现住址  (目前省和市与籍贯相同,待完善)
/// Output：省!市!县
/// Table: PA_Person
/// Debug: ##Class(EPRservice.HISInterface.PatientInfoAssist).ResidentAddressDictionary(105785)
ClassMethod ResidentAddressDictionary(argPapmiDR As %String, argHospital As %String = "") As %String
{
	q:($d(argPapmiDR)=0)||(argPapmiDR="") ""
	
	s ResidentAddress=""
	
	q:(($d(^PAPER(argPapmiDR,"ALL"))'=1)&&($d(^PAPER(argPapmiDR,"ALL"))'=11)) ""
	
	//新出生地字段
	//PAPER_CT_Province_DR
	s provinceDR = $p($g(^PAPER(argPapmiDR,"PER",4)),"^",2)
	//PAPER_CityCode_DR
	s cityBirthDR = $p($g(^PAPER(argPapmiDR,"PER",1)),"^",5)
	//PAPER_CityArea_DR
	s cityareaDR = $p($g(^PAPER(argPapmiDR,"PER",4)),"^",9)
	
	s (City,Province,CityArea)=""
	
	if (cityBirthDR'="")
	{
		s birthCityDesc = $p($g(^CT("CIT",cityBirthDR)),"^",2)
		i $l(birthCityDesc,"-")'=1 {s birthCityDesc=$p($g(birthCityDesc),"-",2)} 
		s birthCityCode = $p($g(^CT("CIT",cityBirthDR)),"^",1)
		s City = cityBirthDR_"^"_birthCityCode_"^"_birthCityDesc
	}
	if (provinceDR'="")
	{
		s birthProvinceDesc = $p($g(^CT("PROV",provinceDR)),"^",2)
		i $l(birthProvinceDesc,"-")'=1 {s birthProvinceDesc=$p($g(birthProvinceDesc),"-",2)} 
		s birthProvinceCode = $p($g(^CT("PROV",provinceDR)),"^",1)
		s Province = provinceDR_"^"_birthProvinceCode_"^"_birthProvinceDesc
	}
	if (cityareaDR'="")
	{
		s birthCityAreaDesc = $p($g(^CT("CITAREA",cityareaDR)),"^",2)
		i $l(birthCityAreaDesc,"-")'=1 {s birthCityAreaDesc=$p($g(birthCityAreaDesc),"-",2)} 
		s birthCityAreaCode = $p($g(^CT("CITAREA",cityareaDR)),"^",1)
		s CityArea = cityareaDR_"^"_birthCityAreaCode_"^"_birthCityAreaDesc
	}
	
	s ResidentAddress = Province_"!"_City_"!"_CityArea
	
	q ResidentAddress
}

/// Desc:取过敏源(合并聊城脑科医院)
ClassMethod GetAllergen(PatientID As %String) As %String
{
 	;病人过敏记录  PA_Allergy
 	q:($d(PatientID)=0)||(PatientID="") ""
 	q:($d(^PAPER(PatientID,"ALG"))=0) ""
 	
 	s ret=""
 	s separtor = $C(13,10)
 
 	s chl= $O(^PAPER(PatientID,"ALG",""))
 	while chl '= ""
 	{
	 	s ALGStatus = $P($G(^PAPER(PatientID,"ALG",chl)),"^",8)
	 	q:ALGStatus="I"
	 	
	 	s ALGTypeDR=$P($G(^PAPER(PatientID,"ALG",chl)),"^",9)            ;自定义       PAC_Allergy
		s ALGPHCGEDR=$P($G(^PAPER(PatientID,"ALG",chl)),"^",4)           ;通用名       PHC_Generic
		s ALGPHCDMDR=$P($G(^PAPER(PatientID,"ALG",chl)),"^",27)          ;药学项       PHC_DrgMast
		//s ALGSeverityDR=$P($G(^PAPER(PatientID,"ALG",chl)),"^",21)       ;过敏程度     PAC_AllergySeverity
	 	
	 	if (ALGTypeDR'="")
	 	{	 
	 		s ALGDesc=$P($G(^PAC("ALG",ALGTypeDR)),"^",2)
	 		s ret=ret_ALGDesc_separtor
	 	}
	 	if (ALGPHCGEDR'="") 
		{
			s ALGPHCGEDesc=$P($G(^PHCGE("GE",ALGPHCGEDR)),"^",2) 
			s ret=ret_ALGPHCGEDesc_separtor
		} 
	 	if (ALGPHCDMDR'="")
		{
			s ALGPHCDMDesc=$P($G(^PHCD(ALGPHCDMDR,1)),"^",2) 
			s ret=ret_ALGPHCDMDesc_separtor
		}
		/*
	 	if (ALGSeverityDR'="")
		{	
			s ALGSeverityCode=$P($g(^PAC("ALRGSEV",ALGSeverityDR)),"^",1)
			s ret=ret_ALGSeverityCode_separtor
		}
		*/
		
	 	s chl=$O(^PAPER(PatientID,"ALG",chl))
	}
	
	//去掉最后一个sperator
	s ret = $e(ret,0,$l(ret)-2)
	
	Q ret
}

/// Desc：	取患者指针(CF_PAPMI_DR)
/// Table:	SQLUSER.DHC_CardRef     (CF_CardType_DR=32 工商银行卡号作为健康卡号)
///         SQLUser.DHC_CardTypeDef 
/// Others：
/// Debug: w ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiDRByCFCardNo("6222024402042260822")		
ClassMethod GetPapmiDRByCFCardNo(argCFCardNo As %String, argCFCardTypeDR As %String = "32") As %String
{
	q:(($d(argCFCardNo)=0)||(argCFCardNo="")) ""
	s ReturnValue="",CFRowID=""
	s CFRowID=$o(^DHCCARDi("CF",0,"CardTypeNo",argCFCardTypeDR,argCFCardNo,CFRowID))
	if (CFRowID'="")
	{
		s ReturnValue=$p($g(^DHCCARD("CF",CFRowID)),"^",4)
	} 
	
	q ReturnValue
}

/// Desc:	健康卡号
/// Debug: w ##Class(EPRservice.HISInterface.PatientInfoAssist).GetCFCardNo("18109930")		
ClassMethod GetCFCardNo(AEpisodeID As %String, argCFCardTypeDR As %String = "32") As %String
{
	q:(($d(AEpisodeID)=0)||(AEpisodeID="")) ""
	s ReturnValue="",CFRowID=""
	s PatientID=..GetPapmiDR(AEpisodeID)
	s CFRowID=$o(^DHCCARDi("CF",0,"TypePAPMINO",argCFCardTypeDR,PatientID,CFRowID))
	if (CFRowID'="")
	{
		s ReturnValue=$p($g(^DHCCARD("CF",CFRowID)),"^",2)
	}  
	q ReturnValue
}

/// Desc:	健康卡号
/// Debug: w ##Class(EPRservice.HISInterface.PatientInfoAssist).GetCFCardNo("18109930")		
ClassMethod GetCFCardNoBypatientID(PatientID As %String, argCFCardTypeDR As %String = "32") As %String
{
	q:(($d(PatientID)=0)||(PatientID="")) ""
	s ReturnValue="",CFRowID=""
	s CFRowID=$o(^DHCCARDi("CF",0,"TypePAPMINO",argCFCardTypeDR,PatientID,CFRowID))
	if (CFRowID'="")
	{
		s ReturnValue=$p($g(^DHCCARD("CF",CFRowID)),"^",2)
	}  
	q ReturnValue
}

/// Desc:	根据身份证号获取PatientID
/// Debug: w ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiDRByIDCard("")	
ClassMethod GetPapmiDRByIDCard(argIDCard As %String) As %String
{
	q:(($d(argIDCard)=0)||(argIDCard="")) ""
	s ReturnValue="",PAPMI=""
	s PAPMI=$O(^PAPERi("DVA",argIDCard,""))
	if (PAPMI'="")
	{
		s ReturnValue=PAPMI
	}
	q ReturnValue
}

/// Desc:	转科明细
/// Output:	(科室ID^科室名称^日期^时间->科室ID^科室名称^日期^时间->...)或(无)
/// debug: w ##class(EPRservice.HISInterface.PatientInfoAssist).TransDeptIDMainDocIDDetail("4")
ClassMethod TransDeptIDMainDocIDDetail(argAdmId As %String, argHospital As %String = "") As %String
{
	//q "12^名称^1^1->13^名称1^11^11->"
	//入参检查
	q:($d(argAdmId)=0)||($d(argHospital)=0)||(argAdmId="") ""
	
	//定义变量
	s transDept="",tmpTransDept="",lastTransDept=""
	
	s childSub = ""
	for {
		s childSub = $O(^PAADM(argAdmId,"TRANS",childSub))
		q:(childSub="")
		
		s transStatusDR = $p($g(^PAADM(argAdmId,"TRANS",childSub)),"^",12)
		if transStatusDR=2 continue
		
		s transCtlocDR = $p($g(^PAADM(argAdmId,"TRANS",childSub)),"^",6)
		if transCtlocDR="" continue
		
		s transCtcpDR = $p($g(^PAADM(argAdmId,"TRANS",childSub)),"^",5)
		if transCtlocDR="" continue
		
		s admdoctorcode=""
		s admdoctor="^^"
		if transCtcpDR'=""
		{
			s admdoctorcode=$P($g(^CTPCP(transCtcpDR,1)),"^",1)
			s admdoctor=$P($g(^CTPCP(transCtcpDR,1)),"^",2)
			s admdoctor=transCtcpDR_"^"_admdoctorcode_"^"_admdoctor
		}
		
		s tmpTransDept = $p($g(^CTLOC(transCtlocDR)),"^",2)
		if $l(tmpTransDept,"-")>1 {s tmpTransDept=$p(tmpTransDept,"-",2)}
		if tmpTransDept="" continue
		if tmpTransDept=lastTransDept continue
		
		
		s startDate = $p($g(^PAADM(argAdmId,"TRANS",childSub)),"^",1)
		s startTime = $p($g(^PAADM(argAdmId,"TRANS",childSub)),"^",2)
		
		s transDept = transDept_transCtlocDR_"^"_tmpTransDept_"^"_$zd(startDate,3)_"^"_$zt(startTime)_"^"_admdoctor
		s transDept = transDept_"->"
		
		s lastTransDept=tmpTransDept
	}
	
	if transDept'=""
	{
		s transDept=$e(transDept,1,$l(transDept)-2)
		if '($f(transDept,"->")>0) {s transDept=..#NoTransDept}
	}
		
	q transDept
}

///                                       
///      ******************************************************************************************
///      以上为停用方法，仅为代码兼容保留
///      ******************************************************************************************

}
