Class DHCEPRFS.BL.HISInfo.BLPatientInfo Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
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

/// 北京协和医院
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

/// Desc: 从病案号取所有PatientID
/// Debug: w ##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetPapmiInfo(286577879)
ClassMethod GetPapmiInfo(AMedical As %String, AMedType As %String = "I")
{
	s ret=""
	q:AMedical="" ret
	if (##class(%Dictionary.CompiledMethod).%ExistsId("DHCWMR.IO.OutService||IGetPatientIDByMrNo"))
	{
		s ret=##Class(DHCWMR.IO.OutService).IGetPatientIDByMrNo(AMedical,AMedType,"",.ErrMsg)
		s ret=$replace(ret,",","^")
	}
	else
	{
		set Rowid="" f  set Rowid=$o(^PAPERi("Medicare1",AMedical,Rowid))  q:Rowid=""  d
		.s Active=$P(^PAPER(Rowid,"PAT",1),"^",6)
		.i ret="" d
		..s ret=Rowid
		.e  d
		..s ret=ret_"^"_Rowid
	}
	q ret
}

/// Debug: w ##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetRegNoByMedRecordNo("M000276")
ClassMethod GetRegNoByMedRecordNo(AMedRecordNo As %String) As %String
{
	s regNo = ""
	s hospitalFlag = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("HospitalFlag")
	
	if (hospitalFlag = "FCYY")
	{
		s ret = ##class(web.DHCBL.Patient.DHCPatientFC).Getpatinfo(AMedRecordNo)
		s regNo = $p(ret,"^",2)	
	}	
	
	q regNo
}

/// Desc：	从病案号取患者指针(PatientID)
/// Debug: w ##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetPatientIDByMedRecord(286577879)
ClassMethod GetPatientIDByMedRecord(AMedRecordNo)
{
	s PAPMI = $o(^PAPERi("Medicare1",AMedRecordNo,0))
	q PAPMI
}

/// Desc：	从就诊卡号取患者指针(PatientID)
/// Debug: w ##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetPatientIDByCardNo(286577879)
ClassMethod GetPatientIDByCardNo(ACardNo As %String) As %String
{
	//0^5722224^420450160001^0^^0^000000^7729587^42045016^9037479^^PC^2^^0^5722224^420450160001^0^^0^000000^7729587^42045016^9037479^^PC^2^
	s ret = ##class(web.UDHCAccManageCLSIF).getaccinfofromcardno(ACardNo,"",""_$c(2)_"1"_$c(2)_"PatInfo")
	//第一位-200表示卡号无效或者未连接读卡器
	s code = $p(ret,"^",1)
	s patientID = $p(ret,"^",8)
	q code_"^"_patientID
}

/// Desc：	取患者指针(PatientID)，not different from hospitals
/// Table:	PA_Adm.PAADM_PAPMI_DR
/// Others：被下列模板引用
/// 		[病案质控]EPRmeta.Quality.QualityExamSet
/// 		[模板控制]EPRservice.TPrivLogic.PatientInfoAssist
/// Debug: w ##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetPapmiDR()
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

/// Desc：	取留观号
/// Debug: w ##class(DHCEPRFS.BL.HISInfo.BLPatientInfo)GetObservedNo(286577879)
ClassMethod GetObservedNo(argPapmiDR As %String) As %String
{
	s observedNo = ""
	s paperid = $o(^DHCPERSON(0,"PAPERSON",argPapmiDR,""))
	if (paperid '= "")
	{
		s observedNo = $p($g(^DHCPERSON(paperid)),"^",5)	
	}	
	q observedNo
}

/// Desc：	取母亲PatientID
ClassMethod GetMotherDR(argPapmiDR As %String) As %String
{
	q:(($d(argPapmiDR)=0)||(argPapmiDR="")) ""
	q $P($g(^PAPER(argPapmiDR,"PAT",1)),"^",20)
}

/// Desc：	取患者病案号
/// Debug:	w ##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetMedRecordNo("5000")
ClassMethod GetMedRecordNo(APapmiDR As %String, AHospital As %String = "", AEpisodeID As %String = "") As %String
{
	s:(APapmiDR = $c(0)) APapmiDR = ""
	s:(AEpisodeID = $c(0)) AEpisodeID = ""

	//取系统参数医院标识
	s hospital = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("HospitalFlag")
	
	if (hospital = "FCYY")
	{
		//使用新接口
		s recordNo = ##class(web.DHCBL.Patient.DHCPatientFC).GetzynoByadm(AEpisodeID)
		q recordNo
		
		s recordNo = ""
		s medRecordInfo = ##class(web.DHCBL.Patient.DHCPatientFC).GetpatinfoByadm(AEpisodeID)
		//patid^patno^patname^outpmrnoE^inpmrnoE^outpmrnoW^inpmrnoW^hospdr
		//判断门诊住院
		s PAAdmType = $p($g(^PAADM(AEpisodeID)),"^",2)
		
		s hospdr=$p(medRecordInfo,"^",8)
		//1为东院，3为西院,4为南院
		
		if ((PAAdmType = "I") || (PAAdmType = "E"))
		{
			//判断东西院
			if ((hospdr = "1") || (hospdr = "4"))
			{
				//东院住院
				s recordNo = $p(medRecordInfo,"^",5)
				
				//妇科微创中心东,妇科肿瘤东 特殊处理（此科室一阵子在东院，一阵子在西院，所以若为此科室，并且东院没有取到病案号则取西院的）
				s depdr=$p(^PAADM(AEpisodeID),"^",4)
				if ((depdr = "1762") || (depdr = "1504"))
				{
					//if (recordNo = "")
					//{
						s recordNo = $p(medRecordInfo,"^",7)
					//}
				}
			}
			elseif (hospdr = "3")
			{
				//西院住院
				s recordNo = $p(medRecordInfo,"^",7)
			}
			else
			{
				q ""
			}
		}
		else
		{
			//判断东西院
			if ((hospdr = "1") || (hospdr = "4"))
			{
				//东院门诊
				s recordNo = $p(medRecordInfo,"^",4)
			}
			elseif (hospdr = "3")
			{
				//西院门诊
				s recordNo = $p(medRecordInfo,"^",6)
			}
			else
			{
				q ""
			}
		}
		
		//s recordNo = ##class(EPRservice.HISInterface.PatientInfoAssist).IPRecordNoByMR(AEpisodeID, AHospital)
		s:(+recordNo < 0) recordNo = ""
		q recordNo
	}
	elseif (hospital = "NYFY")
	{
		s recordNo = ##class(DHCWMR.IO.ToOutService).IGetMrNoByPatientID(APapmiDR,"I")
		q:(recordNo '= "") recordNo
		
		// 其它医院使用默认字段
		s recordNo = $P($g(^PAPER(APapmiDR,"PAT",1)),"^",22)
		q recordNo
	}
	elseif (hospital ="YZRMYY")
	{
		s recordNo = ##class(web.DHCWMRService).IGetMrNoByEpisodeID(AEpisodeID)
		q:(recordNo '= "") recordNo
		
		// 其它医院使用默认字段
		s recordNo = $P($g(^PAPER(APapmiDR,"PAT",1)),"^",22)
		q recordNo
	}
	else
	{
		if (##class(%Dictionary.CompiledMethod).%ExistsId("DHCWMR.IO.OutService||IGetMrNoByEpisodeID"))
		{
			if (AEpisodeID '= "")
			{
				s admTypeCode = $p($g(^PAADM(AEpisodeID)),"^",2)  //就诊类型
				s recordNo = ##class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(AEpisodeID,admTypeCode,.ErrMsg)
			}
			else
			{
				s recordNo = ##class(DHCWMR.IO.OutService).IGetMrNoByPatientID(APapmiDR,"I","",.ErrMsg)
			}
		}
		else
		{
			s recordNo = ##class(web.DHCWMRService).IGetMrNoByPatientID(APapmiDR,.AErr)
		}
		q:(recordNo '= "") recordNo
		
		// 其它医院使用默认字段
		s recordNo = $p($g(^PAPER(APapmiDR,"PAT",1)),"^",22)
		q:(recordNo '= "") recordNo
		
		s mrEpisodeID = $O(^DHCEPRFS.INST.MREpisodeI("IdxSysCodeAndEpisodeID", " DHC", " "_AEpisodeID, ""))
		q:(mrEpisodeID="") ""
		s objMREpisode = ##Class(DHCEPRFS.INST.MREpisode).%OpenId(mrEpisodeID)
		q:(objMREpisode="") ""
		s recordNo = objMREpisode.MedRecordNo
	}
	
	q recordNo
}

/// Desc：	取患者登记号
ClassMethod GetRegNo(APapmiDR As %String, AHospital As %String = "") As %String
{
	q:(($d(APapmiDR)=0)||(APapmiDR="")) ""
	s regNo = $P($g(^PAPER(APapmiDR,"PAT",1)),"^",1)
	q:(regNo '="") regNo
	
	s mrPaitenID = $o(^DHCEPRFS.INST.MRPatientI("IdxPatientID"," DHC"," "_APapmiDR,""))
	q:(mrPaitenID = "") ""
	s objMRPatient = ##class(DHCEPRFS.INST.MRPatient).%OpenId(mrPaitenID)
	q:(objMRPatient = "") ""
	s regNo = objMRPatient.RegNo
	q regNo
	//q "5"
}

/// Desc：	取患者登记号
ClassMethod GetPapmiNo(argPapmiDR As %String) As %String
{
	q:(($d(argPapmiDR)=0)||(argPapmiDR="")) ""
	q $P($g(^PAPER(argPapmiDR,"PAT",1)),"^",1)
}

/// Desc:	身份证号
/// Table:	PA_Person.PAPER_ID
/// Others：not different from others
ClassMethod GetIDCard(argPaperDR As %String, AHospital As %String = "")
{
	//q "6"  //test
	
	q:($d(argPaperDR)=0)||(argPaperDR="") ""
	s idcard=""
	
	q:(($d(^PAPER(argPaperDR,"ALL"))'=1)&&($d(^PAPER(argPaperDR,"ALL"))'=11)) ""
	s idcard=$P($G(^PAPER(argPaperDR,"ALL")),"^",9)
	
	q idcard
}

/// Desc:	姓名
ClassMethod GetName(argPaperDR As %String) As %String
{
	//q "7" //test
	q:($d(argPaperDR)=0)||(argPaperDR="") ""
	
	s name=$P($G(^PAPER(argPaperDR,"ALL")),"^",1)
	
	//去掉两端空格
	//s name = ##Class(DHCEPRFS.Util.StringHelper).Trim(name)
		
	q:(name'="") name
	
	s mrPaitenID = $o(^DHCEPRFS.INST.MRPatientI("IdxPatientID"," DHC"," "_argPaperDR,""))
	q:(mrPaitenID = "") ""
	s objMRPatient = ##class(DHCEPRFS.INST.MRPatient).%OpenId(mrPaitenID)
	q:(objMRPatient = "") ""
	s name = objMRPatient.Name
	q name
}

/// Desc:	性别，not different from hospitals
/// Output:	RowId^Code^Desc
ClassMethod GetGender(argPaperDR As %String, AHospital As %String = "") As %String
{
	//q "8"
	q:(($d(argPaperDR)=0)||(argPaperDR="")) ""
	s genderDR="",gender="",gendercode=""

	if ($d(^PAPER(argPaperDR,"ALL"))'=1)&&($d(^PAPER(argPaperDR,"ALL"))'=11)
	{
		s mrPaitenID = $o(^DHCEPRFS.INST.MRPatientI("IdxPatientID"," DHC"," "_argPaperDR,""))
		q:(mrPaitenID = "") ""
		s objMRPatient = ##class(DHCEPRFS.INST.MRPatient).%OpenId(mrPaitenID)
		q:(objMRPatient = "") ""
		s gender = "^^"_objMRPatient.Gender
	}
	else
	{
		s genderDR=$P($G(^PAPER(argPaperDR,"ALL")),"^",7)
		if genderDR'="" 
		{ 
			s gendercode=$P($g(^CT("SEX",genderDR)),"^",1)
			s gender=$P($g(^CT("SEX",genderDR)),"^",2)
			s gender=genderDR_"^"_gendercode_"^"_gender
		}
	}
	q gender
}

ClassMethod GetAge(APatientID As %String, AHospital As %String = "") As %String
{
	//移动到BLEpisodeInfo中
	q ""
}

/// 09 出生日期
/// w ##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetBirthday(APatientID)
ClassMethod GetBirthday(APapmiDR As %String, AHospital As %String = "") As %String
{
	//q "09"
	q:($d(APapmiDR)=0)||(APapmiDR="") ""
	s Birthday=""
	
	q:(($d(^PAPER(APapmiDR,"ALL"))'=1)&&($d(^PAPER(APapmiDR,"ALL"))'=11)) ""
	s Birthday=$P($G(^PAPER(APapmiDR,"ALL")),"^",6)
	
	q Birthday
}

/// 10 国籍
/// Debug:	w ##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetCountry(APatientID)
/// Desc:	国籍
/// Output：RowId^Code^Desc
/// Others: not different from hospitals
ClassMethod GetCountry(argPaperDR As %String, AHospital As %String = "") As %String
{
	//q "10"
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

/// 11 手机号
/// Debug: ##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetPhoneNo(APatientID)
ClassMethod GetPhoneNo(APatientID As %String, AHospital As %String = "") As %String
{
	//q "11"
	q:(($d(APatientID)=0)||(APatientID="")) ""
	s mobilephone=""
	
	s mobilephone=$P($G(^PAPER(APatientID,"PER",4)),"^",21)
	
	q mobilephone
}

/// 12 证件类别
/// Debug:  ##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetCardType(APatientID)
/// Output: id^desc
ClassMethod GetCardType(APatientID As %String, AHospital As %String = "") As %String
{
	//q "12"
	q:($d(APatientID)=0)||(APatientID="") ""
	q:(($d(^PAPER(APatientID,"ALL"))'=1)&&($d(^PAPER(APatientID,"ALL"))'=11)) ""
	
	s CardTypeDR="",CARDDesc=""
	
	s CardTypeDR=$P($g(^PAPER(APatientID,"PAT",3)),"^",7)
	if (CardTypeDR'="") 
	{
		s CARDDesc = $p($g(^PAC("CARD",CardTypeDR)),"^",2)
	}
	s CardType=CARDDesc
			
	q CardTypeDR_"^"_CardType
}

/// 13 证件号
/// Debug: ##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetGovCardno(APatientID)
ClassMethod GetGovCardno(APatientID As %String, AHospital As %String = "") As %String
{
	//q "13"
	q:($d(APatientID)=0)||(APatientID="") ""
	q:(($d(^PAPER(APatientID,"ALL"))'=1)&&($d(^PAPER(APatientID,"ALL"))'=11)) ""
	
	s CardNumber=""
	
	s CardNumber =$P($g(^PAPER(APatientID,"PAT",3)),"^",6)
			
	q CardNumber
}

/// 14 卡类型
/// Debug: ##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetOPCardType(APatientID)
ClassMethod GetOPCardType(APatientID As %String, AHospital As %String = "") As %String
{
	q "14"
}

/// 15 卡号
/// Debug: ##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetOPCardID(APatientID)
ClassMethod GetOPCardID(APatientID As %String, AHospital As %String = "") As %String
{
	q "15"
}

/// 16 医保类型
/// Debug: ##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetInsuType(APatientID)
/// Output: id^desc
ClassMethod GetInsuType(argAdmId As %String, AHospital As %String = "") As %String
{
	//b "s"
	//q "16"
	//医疗付款方式
	//Modify By wangwentao 20080519 argPapmiDR -> argAdmId
	//地坛医院PAC_AdmReason
	//01 自费 02 医保 03 公费医疗 04 农合 05 外地医保 06 商业保险 07 本院职工 08 儿童医保 09 老年医保
	//安徽省立PAC_AdmReason
	//9自费, 10省医保, 11省医保在职, 12省医保30年在职, 13省医保退休, 14省医保特种病, 15合肥市医保, 16本院职工, 17本院职工45岁以下, 18本院职工45岁以上, 19本院职工60岁以上, 20本院职工30年在职, 21本院职工退休, 22本院职工离休, 23本院职工30年工龄干保, 24本院职工55岁以上干保, 25社会干保, 26贵宾(暂不用), 27特困, 28绿色通道110, 29绿色通道120, 30无名氏, 31合肥市医保特病, 32合肥市城镇居民医保, 33院长减免, 34新农合

	q:($d(argAdmId)=0)||($d(AHospital)=0)||(argAdmId="")||(AHospital="") ""
	
	s PayMode="",PayModeCode="",PayType="",PayTypeCode=""
	
	//b "s"
	if (AHospital=..#HospitalBJJSTYY)||(AHospital=..#HospitalHXYY) 
	{
		//北京积水潭医院, 华西医院
		s PayType=$p($g(^PAADM(argAdmId,1)),"^",7)
		s:(PayType'="") PayMode = $p($g(^PAC("ADMREA",PayType)),"^",2) 
	}	
	elseif AHospital=..#HospitalBJDTYY 
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
	elseif AHospital=..#HospitalAHSLYY
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
	elseif AHospital=..#HospitalAHXNXGYY
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
	elseif AHospital=..#HospitalYKYZLYY
	{
		//医科院肿瘤医院
		s PayType=$p($g(^PAADM(argAdmId,1)),"^",7)
		if PayType'=""
		{
			s PayTypeCode = $p($g(^PAC("ADMREA",PayType)),"^",1)
			
			s PayModeCode= ##class(web.UDHCJFBaseCommon).admReasonTransfer(PayTypeCode)
		    
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
	
	q PayType_"^"_PayMode
}

/// 17 医保号
/// Debug: ##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetInsuNo(APatientID)
ClassMethod GetInsuNo(argAdmId As %String, AHospital As %String = "") As %String
{
	//q "17"
	q:($d(argAdmId)=0)||($d(AHospital)=0)||(argAdmId="")||(AHospital="") ""
	s insuranceNo="", argPapmiDR=""  
	
	if (AHospital=..#HospitalAHSLYY)||(AHospital=..#HospitalAHXNXGYY)||(AHospital=..#HospitalXAJDKQYY)
	{
		s insuranceNo=##class(web.DHCINSUAdmInfoCtl).GetInfoByAdm(argAdmId)
		if ($p(insuranceNo,"!",1)'="1") {s insuranceNo=""}
		else {
		 s insuranceNo=$p(insuranceNo,"!",2)
		 s insuranceNo=$p(insuranceNo,"^",3)
		}
		q insuranceNo
	}
	if (AHospital=..#HospitalYBRMYY)||(AHospital=..#HospitalBJJSTYY)	
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

/// 18 婚姻状况
/// Debug: ##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetMarriage(APatientID)
/// Desc:	婚姻状态
/// Output:	RowId^Code^Desc
ClassMethod GetMarriage(argPaperDR As %String, AHospital As %String = "") As %String
{
	//q "18"
	q:(($d(argPaperDR)=0)||(argPaperDR="")) ""
	s maritalDR="",marital=""
	
	q:(($d(^PAPER(argPaperDR,"PER",2))'=1)&&($d(^PAPER(argPaperDR,"PER",2))'=11)) ""
	if AHospital=##Class(DHCEPRFS.Const.Hospital).HospitalBJJSTYY()	//北京积水潭
	{	s maritalDR=$P($G(^PAPER(argPaperDR,"PER",2)),"^",1)}
	else
	{
		s maritalDR=$P($G(^PAPER(argPaperDR,"PER",2)),"^",3)
	}
	
	if maritalDR'=""  
	{
		s code = $p($g(^CT("MAR",maritalDR)),"^",1)
		s desc = $p($g(^CT("MAR",maritalDR)),"^",2)
		s marital=maritalDR_"^"_code_"^"_desc
	}
	
	q marital
}

/// 19 民族
/// Debug: ##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetNationality(APatientID)
ClassMethod GetNationality(APatientID As %String, AHospital As %String = "") As %String
{
	//q "19"
	q:(($d(APatientID)=0)||(APatientID="")) ""
	s retValue=""
	
	q:(($d(^PAPER(APatientID,"PER",2))'=1)&&($d(^PAPER(APatientID,"PER",2))'=11)) ""
	s nationDR=$P($G(^PAPER(APatientID,"PER",2)),"^",1)
	q:(nationDR="") ""
	s code=$p($g(^CT("NAT",nationDR)),"^",1)
	s desc=$p($g(^CT("NAT",nationDR)),"^",2)
	if $l(desc,"-")>1 {s desc=$p($g(desc),"-",2)}
	s retValue=nationDR_"^"_code_"^"_desc
	
	q retValue
}

/// 20 职业
/// Debug: ##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetOccupation(APatientID)
ClassMethod GetOccupation(APatientID As %String, AHospital As %String = "") As %String
{
	//q "20"
	q:(($d(APatientID)=0)||(APatientID="")) ""
	s retValue = ""
	
	q:(($d(^PAPER(APatientID,"PER",2))'=1)&&($d(^PAPER(APatientID,"PER",2))'=11)) ""
	s occupationDR=$P($G(^PAPER(APatientID,"PER",2)),"^",6)
	i occupationDR'=""  
	{
		s occupationcode=$p($g(^CT("OCC",occupationDR)),"^",1)
		s occupationdesc=$p($g(^CT("OCC",occupationDR)),"^",2)
		i ($l(occupationdesc,"-")>1) {s occupationdesc=$p($g(occupationdesc),"-",2)}
		s retValue=occupationDR_"^"_occupationcode_"^"_occupationdesc
		
		//通过入参判断是否进行数据替换处理
		//if (argCDType'="") 
		//{
			//s relation=..GetCustomDictionaryLinkByCode(argCDType,argCDCode)
			//s relation=relationDR_"^"_relation
		//}
	}	
	
	q retValue
}

/// 21 工作单位
/// Debug: ##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetCompany(APatientID)
ClassMethod GetCompany(APatientID As %String, AHospital As %String = "") As %String
{
	//q "21"
	//q:(($d(APatientID)=0)||(APatientID="")) ""
	//s WorkAddress="",WorkAddressDR="",workcode=""

	//s WorkAddressDR=$o(^DHCPERSON(0,"PAPERSON",APatientID,""))
	//if WorkAddressDR'=""
	//{
	//	s WorkAddress=$p($g(^DHCPERSON(WorkAddressDR)),"^",22)
	//}	
	
	//q WorkAddress
	
	q:(($d(APatientID)=0)||(APatientID="")) ""
	s workaddr=""
	
	q:(($d(^PAPER(APatientID,"PER",4))'=1)&&($d(^PAPER(APatientID,"PER",4))'=11)) ""
	s workaddr=$P($G(^PAPER(APatientID,"PER",4)),"^",18)
	//s workaddr=..ChangeHenggangType(workaddr)
	q workaddr
}

/// 22 工作电话
/// Debug: ##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetWorktel(APatientID)
ClassMethod GetWorktel(APatientID As %String, AHospital As %String = "") As %String
{
	//q "22"
	q:($d(APatientID)=0)||($d(argHospital)=0)||(APatientID="")||(argHospital="") ""
	s workphone=""
	
	q:(($d(^PAPER(APatientID,"PER",1))'=1)&&($d(^PAPER(APatientID,"PER",1))'=11)) ""
	
	if (argHospital=..#HospitalBJDTYY)||(argHospital=..#HospitalYBRMYY)			
	{	
		//北京地坛医院,粤北人民医院
		s workphone=$P($G(^PAPER(APatientID,"PER",1)),"^",11)	//PA_Person.PAPER_TelH
	}	
	else
	{
		//北京积水潭
		s workphone=$P($G(^PAPER(APatientID,"PER",1)),"^",9)	//PA_Person.PAPER_TelO
	}	
	
	q workphone
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
		s:(addressNum'="") streetHukou=$g(^PAPER(argPaperDR,"PER","ADD",addressNum))
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

/// 23 户口地址省
/// Debug: ##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetHouseProvince(APatientID)
ClassMethod GetHouseProvince(APatientID As %String, AHospital As %String = "") As %String
{
	//q "23"
	q:(($d(APatientID)=0)||(APatientID="")) ""
	s HukouProvince = ""
	s tmpHuKou=..HuKouAddressNew(APatientID,AHospital)
 	i tmpHuKou'=""
 	{
   	// 户口地址省份 
   	s tmpHukouProvince = $p($g(tmpHuKou),"!",1)
   	s HukouProvince = $p($g(tmpHukouProvince),"^",2)
   	s HukouProvince = HukouProvince_"^"_$p($g(tmpHukouProvince),"^",3)
 	}
   	q HukouProvince
}

/// 24 户口地址市
/// Debug: ##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetHouseCity(APatientID)
ClassMethod GetHouseCity(APatientID As %String, AHospital As %String = "") As %String
{
	//q "24"
	q:(($d(APatientID)=0)||(APatientID="")) ""
	s HuKouCity = ""
	s tmpHuKou=..HuKouAddressNew(APatientID,AHospital)
	i tmpHuKou'=""
 	{
	// 户口地址城市 
   	s tmpHuKouCity = $p($g(tmpHuKou),"!",2)
   	s HuKouCity = $p($g(tmpHuKouCity),"^",2)
   	s HuKouCity = HuKouCity_"^"_$p($g(tmpHuKouCity),"^",3)
 	}
   	q HuKouCity
}

/// 25 户口地址县区
/// Debug: ##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetHouseArea(APatientID)
ClassMethod GetHouseArea(APatientID As %String, AHospital As %String = "") As %String
{
	//b "s"
	//q "25"
	q:(($d(APatientID)=0)||(APatientID="")) ""
	s HuKouBlock=""
	s tmpHuKou=..HuKouAddressNew(APatientID,AHospital)
	i tmpHuKou'=""
 	{
	// 户口地址区县
	s tmpHuKouBlock = $p($g(tmpHuKou),"!",3)
   	s HuKouBlock = $p($g(tmpHuKouBlock),"^",2)
   	s HuKouBlock = HuKouBlock_"^"_$p($g(tmpHuKouBlock),"^",3)
 	}
   	q HuKouBlock
}

/// 26 户口地址
/// Debug: ##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetHouseAddress(APatientID)
ClassMethod GetHouseAddress(APatientID As %String, AHospital As %String = "") As %String
{
	//q "26"
	s HuKouStreet=""
	q:(($d(APatientID)=0)||(APatientID="")) ""
	s tmpHuKou=..HuKouAddressNew(APatientID,AHospital)
	i tmpHuKou'=""
 	{
	s HuKouStreet= $p($g(tmpHuKou),"!",4)
 	}
	
	q HuKouStreet
}

/// 27 户口邮编
/// Debug: ##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetHouseZipCode(APatientID)
ClassMethod GetHouseZipCode(APatientID As %String, AHospital As %String = "") As %String
{
	//q "27"
	q:(($d(APatientID)=0)||(APatientID="")) ""
	s hukoupostalcodeDR="",hukoupostalcode=""

	s hukoupostalcodeDR=$o(^DHCPERSON(0,"PAPERSON",APatientID,""))
	if hukoupostalcodeDR'=""
	{
		s hukoupostalcode=$p($g(^DHCPERSON(hukoupostalcodeDR)),"^",7)
	}	
	
	if AHospital = ..#HospitalYKYZLYY			//医科院肿瘤医院
	{
		//PA_Person.PAPER_ForeignPostCode
		s hukoupostalcode=$p($g(^PAPER(APatientID,"PER",2)),"^",8)
	}	
	
	q hukoupostalcode
}

/// 28 联系人姓名
/// Debug: ##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetLinkName(APatientID)
ClassMethod GetLinkName(APatientID As %String, AHospital As %String = "") As %String
{
	//q "28"
	q:(($d(APatientID)=0)||(APatientID="")) ""
	s linkman=""
	
	q:(($d(^PAPER(APatientID,"PER",2))'=1)&&($d(^PAPER(APatientID,"PER",2))'=11)) ""
	s linkman=$P($G(^PAPER(APatientID,"PER",2)),"^",13)
	
	q linkman
}

/// 29 联系人关系
/// Debug: ##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetLinkRelation(APatientID)
/// Output: relationDR_"^"_relationcode_"^"_relationdesc
ClassMethod GetLinkRelation(APatientID As %String, AHospital As %String = "") As %String
{
	//q "29"
	q:($d(APatientID)=0)||(APatientID="") ""
	s relationDR="",relation="",relationcode="",relationdesc=""
	
	q:(($d(^PAPER(APatientID,"EMP"))'=1)&&($d(^PAPER(APatientID,"EMP"))'=11)) ""
	s relationDR=$P($G(^PAPER(APatientID,"EMP")),"^",4)
	if relationDR'=""
	{
		s relationcode=$p($g(^CT("RLT",relationDR)),"^",1)
	  	s relationdesc=$p($g(^CT("RLT",relationDR)),"^",2)
		s relation=relationDR_"^"_relationcode_"^"_relationdesc
		
		//通过入参判断是否进行数据替换处理
		//if (argCDType'="") 
		//{
			//s relation=..GetCustomDictionaryLinkByCode(argCDType,argCDCode)
			//s relation=relationDR_"^"_relation
		//}
	}
	
	q relation
}

/// 30 联系人电话
/// Debug: ##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetLinkPhone(APatientID)
ClassMethod GetLinkPhone(APatientID As %String, AHospital As %String = "") As %String
{
	//q "30"
	q:(($d(APatientID)=0)||(APatientID="")) ""
	s phone=""
	
	q:(($d(^PAPER(APatientID,"ALL"))'=1)&&($d(^PAPER(APatientID,"ALL"))'=11)) ""
	s phone=$P($G(^PAPER(APatientID,"ALL")),"^",4)	

	q phone
}

/// Desc:	民族
/// Output：RowId^Code^Desc
/// Others: not different from hospitals
ClassMethod GetNation(argPaperDR As %String, AHospital As %String = "") As %String
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

ClassMethod GetCompanyCode(APatientID As %String, AHospital As %String = "") As %String
{
	//q "35"
	q ""
}

/// Desc: 33 统计组就诊RowID【统计组】
ClassMethod GetMRAdmDR(argAdmId As %String)
{
	q:(($d(argAdmId)=0)||(argAdmId="")) ""
	q $P($g(^PAADM(argAdmId)),"^",61)
}

/// Desc:	现住址
/// Output：省!市!区!详细地址
ClassMethod GetResidentAddress(argPaperDR As %String, argHospital As %String = "") As %String
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

	s residentaddr=$g(^PAPER(argPaperDR,"PER","ADD",1))
	s residentaddr = curprovinceDR_"^"_curProvince_"!"_curcityDR_"^"_curCity_"!"_curblockDR_"^"_curBlock_"!"_residentaddr
	
	q residentaddr
}

/// Desc:	现住址邮编
ClassMethod GetResidentZipCode(argPaperDR As %String, argHospital As %String = "") As %String
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
	
	q residentpostalcode
}

/// Desc:	籍贯
/// Output:
/// Debug: ##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).Native()
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

/// Creator:Candy
/// CreateDate 20130428
/// Desc:患者信息存储
/// Debug:w ##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).SetPatientInfomation(4)
ClassMethod SetPatientInfomation(AEpisodeID As %String) As %String
{
	s result = "0"
	q:(AEpisodeID = "") result
	s dt = ##Class(%ResultSet).%New("EPRservice.SystemData:GetPatientInfo2")
	d dt.Execute(AEpisodeID)
	
	While (dt.Next()) {
		s Hospital=##class(EPRmeta.SysOption).GetOptionValueByName("HospitalName")
		s PapmiDR = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiDR(AEpisodeID)
		s AdmDateTime=##class(EPRservice.HISInterface.PatientInfoAssist).AdmDateTime(AEpisodeID,Hospital)
		s DisDateTime=##class(EPRservice.HISInterface.PatientInfoAssist).DisDateTime(AEpisodeID,Hospital)
		s DeathDateTime=##class(EPRservice.HISInterface.PatientInfoAssist).DeathDateTime(PapmiDR,Hospital)

		s objEPatient = ##Class(DHCEPRFS.Entity.EMRPatient).%New()
		s objEPatient.SysCode = "DHC"
		s objEPatient.MedRecordNo = dt.Data("IPRecordNo") //病案号
		s objEPatient.Name = dt.Data("Name") //姓名
		s objEPatient.Gender = dt.Data("Gender") //性别
		s objEPatient.IDCard = dt.Data("IDCard") //身份证
		s objEPatient.PatientID = dt.Data("RegisterNo") //登记号
		s MRPatientID = ..SetMRPatient(objEPatient) 
		d objEPatient.%Close()
		
        // 就诊信息
		s objEEpisode = ##Class(DHCEPRFS.Entity.EMREpisode).%New()
		s objEEpisode.MRPatientID = MRPatientID
		s objEEpisode.SysCode = "DHC"
		s objEEpisode.EpisodeID = AEpisodeID
		s objEEpisode.MedRecordNo = dt.Data("IPRecordNo") //病案号
		s:(AdmDateTime '= "") objEEpisode.AdmDate = $P($G(AdmDateTime),",",1) //入院日期
		s:(AdmDateTime '= "") objEEpisode.AdmTime = $P($G(AdmDateTime),",",2) //入院时间
		s:(DisDateTime '= "") objEEpisode.DisDate = $P($G(DisDateTime),",",1) //出院日期
		s:(DisDateTime '= "") objEEpisode.DisTime = $P($G(DisDateTime),",",2) //出院时间
		s:(DeathDateTime'="") objEEpisode.DeathDate = $P($G(DeathDateTime),",",1) //死亡日期
		s:(DeathDateTime'="") objEEpisode.DeathTime = $P($G(DeathDateTime),",",2) //死亡时间
		
		s MREpisodeID = ##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).SetMREpisode(objEEpisode)
		d objEEpisode.%Close()
		s:(MREpisodeID '= "0") result = "1"

	}
	q result
}

/// Desc:添加患者基本信息
/// Creator:Candyxu
/// CreateDate:2013-04-27
ClassMethod SetMRPatient(AEMRPatient As DHCEPRFS.Entity.EMRPatient) As %String
{
	s result = "0"
	q:((AEMRPatient.IDCard = "")||(AEMRPatient.PatientID = "")) result

	if ($d(^DHCEPRFS.INST.MRPatientI("IdxPatientID"," "_AEMRPatient.IDCard," "_AEMRPatient.SysCode," "_AEMRPatient.PatientID)))
	{
	   s result = $o(^DHCEPRFS.INST.MRPatientI("IdxPatientID"," "_AEMRPatient.IDCard," "_AEMRPatient.SysCode," "_AEMRPatient.PatientID,""))
	   q result
	}
    s objMRPatient = ##Class(DHCEPRFS.INST.MRPatient).%New()
    s objMRPatient.SysCode = AEMRPatient.SysCode
    s objMRPatient.MedRecordNo = AEMRPatient.MedRecordNo
    s objMRPatient.Name = AEMRPatient.Name
    s objMRPatient.Gender = AEMRPatient.Gender
    s objMRPatient.IDCard = AEMRPatient.IDCard
    s objMRPatient.PatientID = AEMRPatient.PatientID
    s sc = objMRPatient.%Save()
    s:($$$ISOK(sc)) result = objMRPatient.%Id()
    q result
}

/// Desc:	根据登记号获取PatientID列表
/// Debug:	w ##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetPapmiListByPapmiNo("00000005")
ClassMethod GetPapmiListByPapmiNo(APapmiNo As %String) As %String
{
	s ret = ""
	
	q:(APapmiNo = "") ret
	
	s upPapmiNo = $zcvt(APapmiNo,"u")
	
	s papmiID = ""
	for {
		s papmiID = $O(^PAPERi("PAPMI_PatNo",upPapmiNo,papmiID))
		q:(papmiID = "")
		
		if (ret = "")
		{
			s ret = papmiID	
		}
		else
		{
			s ret = ret_"^"_papmiID	
		}
	}
	
	q ret
}

/// Desc:病人信息列表
/// Creator:Candy
/// CreateDate:2013-05-02
/// debug:do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.HISInfo.BLPatientInfo","GetPatientInformation",")
Query GetPatientInformation(AParam As DHCEPRFS.Entity.EPatientInfoQueryPara) As %Query(ROWSPEC = "MRPatientID:%String,MREpisodeID:%String,MedRecordNo:%String,Name:%String,Birthday:%String,Age:%String,Sex:%String,HouseAddress:%String,LinkName:%String,LinkRelation:%String,AdmDateTime:%String,DisDateTime:%String,AdmInLoc:%String,DischgrgeLoc:%String,MainDiagDesc:%String,DeathDate:%String")
{
}

ClassMethod GetPatientInformationExecute(ByRef qHandle As %Binary, AParam As DHCEPRFS.Entity.EPatientInfoQueryPara) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	q:(AParam = "") $$$OK

	d GetParm
	if (PName '= "")
	{
		s tmpName = " "_$zcvt(PName,"U")
		while ((tmpName'="")&&(tmpName[PName)) 
		{
		    s MRPatientID = ""
		    for {
		        s MRPatientID = $o(^DHCEPRFS.INST.MRPatientI("IdxName",tmpName,MRPatientID))
	            q:(MRPatientID = "")
	            s flag = $$GetPatientInfo()
	            continue:(flag '= "1")
	            s MEpisodeID = ""
                for {
	                s MEpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxMRPatientID"," "_MRPatientID,MEpisodeID))
	                q:(MEpisodeID = "")
	                d GetEpisodeInfo
	                d OutPutInfo
                }  
		    }
		    s tmpName=$o(^DHCEPRFS.INST.MRPatientI("IdxName",tmpName))
		}
	}
	elseif (PIDCard '="")
	{
		s MRPatientID = ""
		for {
			s MRPatientID = $o(^DHCEPRFS.INST.MRPatientI("IdxIDCard"," "_PIDCard,MRPatientID))
		    q:(MRPatientID = "")
		    s flag = $$GetPatientInfo()
	        continue:(flag '= "1")
	        s MEpisodeID = ""
	        for {
	            s MEpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxMRPatientID"," "_MRPatientID,MEpisodeID))
	            q:(MEpisodeID = "")
	            d GetEpisodeInfo
	            d OutPutInfo
            }  
		}
	}
	elseif(PNo'="")
	{
		s MRPatientID = ""
		for {
			s MRPatientID = $o(^DHCEPRFS.INST.MRPatientI("IdxRegNo"," "_PNo,MRPatientID))
		    q:(MRPatientID = "")
		    s flag = $$GetPatientInfo()
	        continue:(flag '= "1")
	        s MEpisodeID = ""
	        for {
	            s MEpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxMRPatientID"," "_MRPatientID,MEpisodeID))
	            q:(MEpisodeID = "")
	            d GetEpisodeInfo
	            d OutPutInfo
            }  
		}
	}
	elseif(PMedRecordNo'= "")
	{
	   	s MRPatientID = ""
		for {
			s MRPatientID = $o(^DHCEPRFS.INST.MRPatientI("IdxMedRecordNo"," "_PMedRecordNo,MRPatientID))
		    q:(MRPatientID = "")
		    s flag = $$GetPatientInfo()
	        continue:(flag '= "1")
	        s MEpisodeID = ""
            for {
	            s MEpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxMRPatientID"," "_MRPatientID,MEpisodeID))
	            q:(MEpisodeID = "")
	            d GetEpisodeInfo
	            d OutPutInfo
            }  
		}	
	}
	elseif((PAStartDate '="")&&(PAEndDate '= ""))
	{
		s PAStartDate=$zdh(PAStartDate,3),PAEndDate=$zdh(PAEndDate,3)
		for AdmDate = PAStartDate:1:PAEndDate 
		{
			s tempMRPID = ""
			for {
			    s tempMRPID = $o(^DHCEPRFS.INST.MREpisodeI("IdxAdmDate",AdmDate,tempMRPID))
			    q:(tempMRPID = "")
			    s MRPatientID = $tr(tempMRPID," ","")
			    s flag = $$GetPatientInfo()
			    continue:(flag '= "1")
			    s MEpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxAdmDate",AdmDate,tempMRPID,""))
			    d GetEpisodeInfo
			    d OutPutInfo 
			}
		}
	}
	elseif((PDStartDate '= "")&&(PDEndDate '= ""))
	{
		s PDStartDate=$zdh(PDStartDate,3),PDEndDate=$zdh(PDEndDate,3)
		for DisDate = PDStartDate:1:PDEndDate 
		{
			s tempMRPID = ""
			for {
			    s tempMRPID = $o(^DHCEPRFS.INST.MREpisodeI("IdxDisDate",DisDate,tempMRPID))
			    q:(tempMRPID = "")
			    s MRPatientID = $tr(tempMRPID," ","")
			    s flag = $$GetPatientInfo()
			    continue:(flag '= "1")
			    s MEpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxDisDate",DisDate,tempMRPID,""))
			    d GetEpisodeInfo
			    d OutPutInfo 
			}
		}	
	}
	Quit $$$OK
	
GetPatientInfo()
    s flag = "-1"
    s objPatient = ##Class(DHCEPRFS.INST.MRPatient).%OpenId(MRPatientID)
    s Name = objPatient.Name
    q:((PName '="") && ($zcvt(Name,"U") '[ PName)) flag 
    s Birthday = objPatient.Birthday
    q:(AParam.Birthday '= "")&&(AParam.Birthday '= Birthday) flag
    s:(Birthday '= "") Birthday = $zd(Birthday,3)
    s Age = objPatient.Age	
    s Sex = objPatient.Gender
    s HouseAddress = objPatient.HouseAddress
    s LinkName = objPatient.LinkName	
    s LinkRelation = objPatient.LinkRelation
    s MedRecordNo = objPatient.MedRecordNo
    q:((PMedRecordNo '= "")&&(MedRecordNo '=PMedRecordNo)) flag
    d objPatient.%Close()
    s flag = "1"
    q flag
GetEpisodeInfo
	s objEpisode = ##Class(DHCEPRFS.INST.MREpisode).%OpenId(MEpisodeID)
	s AdmDate = objEpisode.AdmDate
	s AdmTime = objEpisode.AdmTime 
	s AdmDateTime = $zd(AdmDate,3)   
	s DisDate = objEpisode.DisDate
	s DisTime = objEpisode.DisTime
    s DisDateTime = $zd(DisDate,3)   
    s AdmLoc = objEpisode.AdmLoc
    s DisLoc = objEpisode.DisLoc
    s DeathDate = objEpisode.DeathDate	
    s MainDiagDesc = ""
    d objEpisode.%Close()  
    q
OutPutInfo 
    s data = $lb(MRPatientID,MEpisodeID,MedRecordNo,Name,Birthday,Age,Sex,HouseAddress,LinkName,LinkRelation,AdmDateTime,DisDateTime,AdmLoc,DisLoc,MainDiagDesc,DeathDate)
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1
    q
GetParm
  	s PName = $zcvt(AParam.Name,"U")
	s PMedRecordNo =  AParam.MedRecordNo
	s PNo = AParam.PatientID
	s PIDCard = AParam.IDCard
	s PAStartDate = AParam.AdmStratDate
	s PAEndDate = AParam.AdmEndDate
	s PDStartDate = AParam.DisStratDate
	s PDEndDate = AParam.DisEndDate
	q
}

ClassMethod GetPatientInformationClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatientInformationExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPatientInformationFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatientInformationExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

ClassMethod FSPatientInfoTest(argAdmId As %String) As %String
{
	q:($d(argAdmId) = 0)||(argAdmId = "") ""
	s PapmiDR = ..GetPapmiDR(argAdmId)
	w "PapmiDr:"_..GetPapmiDR(argAdmId),!
	w "病 案 号:"_..GetMedRecordNo(PapmiDR,""),!
	w "登 记 号:"_..GetRegNo(PapmiDR,""),!
	w "登 记 号:"_..GetPapmiNo(PapmiDR),!
	w "身份证号:"_..GetIDCard(PapmiDR,""),!
	w "姓    名:"_..GetName(PapmiDR),!
	w "性    别:"_..GetGender(PapmiDR),!
	w "年    龄:"_"NULL",!
	w "出生日期:"_..GetBirthday(PapmiDR),!
	w "国    籍:"_..GetCountry(PapmiDR),!
	w "手 机 号:"_..GetPhoneNo(PapmiDR,""),!
	w "证件类别:"_..GetCardType(PapmiDR),!,!
	w "证 件 号:"_..GetGovCardno(PapmiDR)
	w "卡 类 型:"_"NULL",!
	w "卡    号:"_"NULL",!
	w "医保类型:"_..GetInsuType(argAdmId),!
	w "医 保 号:"_..GetInsuNo(argAdmId),!
	w "婚姻状况:"_..GetMarriage(PapmiDR),!
	w "民    族:"_..GetNationality(PapmiDR),!
	w "职    业:"_..GetOccupation(PapmiDR),!
	w "工作单位:"_..GetCompany(PapmiDR),!
	w "工作电话:"_..GetWorktel(PapmiDR),!
	w "户口地址省:"_..GetHouseProvince(PapmiDR),!
	w "户口地址市:"_..GetHouseCity(PapmiDR),!
	w "户口地址县:"_..GetHouseArea(PapmiDR),!
	w "户口地址街:"_..GetHouseAddress(PapmiDR),!
	w "户口邮编:"_..GetHouseZipCode(PapmiDR),!
	w "联系人姓名:"_..GetLinkName(PapmiDR),!
	w "联系人关系:"_..GetLinkRelation(PapmiDR),!
	w "联系人电话:"_..GetLinkPhone(PapmiDR),!
	w "民    族:"_..GetNation(PapmiDR),!
	q ""
}

/// debug: w ##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).CheckAndAddEpisode("","0000000093","")
ClassMethod CheckAndAddEpisode(AName As %String, ARegNo As %String, AMedRecordNo As %String)
{
	//检查是否是录入的病案，录入的病案不增加就诊
	if (AMedRecordNo '= "")
	{
		s isHIS = ""
		&sql(select IsHISMedRecord into :isHIS from DHCEPRFS_INST.MRMedRecord where MedRecordNo = :AMedRecordNo)
		q:(isHIS = "N")
	}
	
	s PName = $zcvt(AName,"U")
	s PMedRecordNo =  $zcvt(AMedRecordNo,"U")
	s PNo = ARegNo
	if (PName '= "")
	{
		s PAPMI = ""
		for {
		   	s PAPMI = $O(^PAPERi("PAPER_PatName",PName,PAPMI))
		   	q:(PAPMI = "")
		   	d CreateMRPatient(PAPMI)
		}
	}
	elseif(PNo'="")
	{
		s PAPMI = $o(^PAPERi("PAPMI_PatNo",PNo,""))
		d CreateMRPatient(PAPMI)
	}
	elseif(PMedRecordNo'="")
	{
		s PAPMIS = ##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetPapmiInfo(PMedRecordNo)
		for index=1:1:$l(PAPMIS,"^")
		{
			s PAPMI = $p(PAPMIS,"^",index)
			continue:(PAPMI="")
			//s PAPMI = $o(^PAPERi("Medicare1",PMedRecordNo,0))
			d CreateMRPatient(PAPMI)
		}
	}
CreateMRPatient(PAPMI)
	s AdmType = ""
	for {
	    s AdmType = $o(^PAPERdr(PAPMI,"ADM",AdmType))
	    q:(AdmType = "")
	    s PAAdm = ""
	    for {
			s PAAdm = $o(^PAPERdr(PAPMI,"ADM",AdmType,PAAdm))
			q:(PAAdm = "")
			s PAAdmType = $p($g(^PAADM(PAAdm)),"^",2)  
			s AdmStatus=$P($g(^PAADM(PAAdm)),"^",20)
			//A表示在院，D表示出院，P表示预约
			continue:(AdmStatus '= "D")
			if (PAAdmType = "I")
			{
				//b "s"
				d ##Class(DHCEPRFS.BL.BLMREpisode).RegMREpisodeIDByAdm(PAAdm,"DHC")	
			}
		}
	}
	q
}

/// Desc:病人信息列表
/// Creator:Candy
/// CreateDate:2013-05-02
/// debug:do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.HISInfo.BLPatientInfo","GetPatientInfo","")
Query GetPatientInfo(AParam As DHCEPRFS.Entity.EPatientInfoQueryPara) As %Query(ROWSPEC = "MRPatientID:%String,MREpisodeID:%String,MedRecordNo:%String,Name:%String,Birthday:%String,Age:%String,Sex:%String,HouseAddress:%String,LinkName:%String,LinkRelation:%String,AdmDateTime:%String,DisDateTime:%String,AdmInLoc:%String,DischgrgeLoc:%String,MainDiagDesc:%String,DeathDate:%String,ScanerName:%String,ScanDateTime:%String,LastStatus:%String,LastMrStatus:%String,LastMrStatusDateTime:%String,LastMrStatusOperator:%String,LastReviewOperator:%String,LastReviewDateTime:%String")
{
}

ClassMethod GetPatientInfoExecute(ByRef qHandle As %Binary, AParam As DHCEPRFS.Entity.EPatientInfoQueryPara) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	q:(AParam = "") $$$OK

	d GetParm
	
	s ret = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("ScanQueryAddEpisode")
	if (ret = "Y")
	{
		d ..CheckAndAddEpisode(AParam.Name,AParam.PatientID,AParam.MedRecordNo)	
	}
	
	if (PName '= "")
	{
		s tmpName = " "_$zcvt(PName,"U")
		while ((tmpName'="")&&(tmpName[PName)) 
		{
		    s MRPatientID = ""
		    for {
		        s MRPatientID = $o(^DHCEPRFS.INST.MRPatientI("IdxName",tmpName,MRPatientID))
	            q:(MRPatientID = "")
	            s flag = $$GetPatientInfo()
	            continue:(flag '= "1")
	            s MEpisodeID = ""
                for {
	                s MEpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxMRPatientID"," "_MRPatientID,MEpisodeID))
	                q:(MEpisodeID = "")
		            s flag = $$GetEpisodeInfo()
					continue:(flag '= "1")
	                d GetLogInfo
	                d OutPutInfo
                }  
		    }
		    s tmpName=$o(^DHCEPRFS.INST.MRPatientI("IdxName",tmpName))
		}
	}
	elseif (PIDCard '="")
	{
		s MRPatientID = ""
		for {
			s MRPatientID = $o(^DHCEPRFS.INST.MRPatientI("IdxIDCard"," "_PIDCard,MRPatientID))
		    q:(MRPatientID = "")
		    s flag = $$GetPatientInfo()
	        continue:(flag '= "1")
	        s MEpisodeID = ""
	        for {
	            s MEpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxMRPatientID"," "_MRPatientID,MEpisodeID))
	            q:(MEpisodeID = "")
	            s flag = $$GetEpisodeInfo()
				continue:(flag '= "1")
	            d GetLogInfo
	            d OutPutInfo
            }  
		}
	}
	elseif(PNo'="")
	{
		s MRPatientID = ""
		for {
			s MRPatientID = $o(^DHCEPRFS.INST.MRPatientI("IdxRegNo"," "_PNo,MRPatientID))
		    q:(MRPatientID = "")
		    s flag = $$GetPatientInfo()
	        continue:(flag '= "1")
	        s MEpisodeID = ""
	        for {
	            s MEpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxMRPatientID"," "_MRPatientID,MEpisodeID))
	            q:(MEpisodeID = "")
	            s flag = $$GetEpisodeInfo()
				continue:(flag '= "1")
	            d GetLogInfo
	            d OutPutInfo
            }  
		}
	}
	elseif(PMedRecordNo'= "")
	{
		s MedRecordNo = PMedRecordNo
		
		s MRMedRecordID = $o(^DHCEPRFS.INST.MRMedRecordI("IdxMedRecordNo"," DHC"," "_PMedRecordNo,""))
		s objMRMedRecord = ##class(DHCEPRFS.INST.MRMedRecord).%OpenId(MRMedRecordID)
		q:(objMRMedRecord = "") $$$OK
		if (objMRMedRecord.IsHISMedRecord = "N")
		{
			
			s MRPatientID = objMRMedRecord.MRPatientID
			s flag = $$GetPatientInfo()
	   	 	s MEpisodeID = ""
	    	for {
				s MEpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxMRMedRecordID"," "_MRMedRecordID,MEpisodeID))
				q:(MEpisodeID = "")
				s flag = $$GetEpisodeInfo()
				continue:(flag '= "1")
	        	d GetLogInfo
	        	d OutPutInfo     
			}
		}
		else
		{
		
	   		s MREpisodePatID = ""
			for {
				s MREpisodePatID = $o(^DHCEPRFS.INST.MREpisodePatI("IdxMedRecordNo"," "_PMedRecordNo,MREpisodePatID))
		    	q:(MREpisodePatID = "")
		    	s objMREpisodePat = ##class(DHCEPRFS.INST.MREpisodePat).%OpenId(MREpisodePatID)
		    	s MRPatientID = objMREpisodePat.MRPatientID
		    	s flag = $$GetEpisodePatientInfo()
	       	 	continue:(flag '= "1")    
	       	  	s MEpisodeID = objMREpisodePat.MREpisodeID
	        	s flag = $$GetEpisodeInfo()
				continue:(flag '= "1")
	        	d GetLogInfo
	        	d OutPutInfo 
			}	
		}
	}
	elseif (PMRMedRecordNo '= "")
	{
		s objMRMedRecord = ##class(DHCEPRFS.INST.MRMedRecord).%OpenId(PMRMedRecordNo)
		s MRPatientID = objMRMedRecord.MRPatientID
		s flag = $$GetPatientInfo()
	    s MEpisodeID = ""
	    for {
			s MEpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxMRMedRecordID"," "_PMRMedRecordNo,MEpisodeID))
			q:(MEpisodeID = "")
			s flag = $$GetEpisodeInfo()
			continue:(flag '= "1")
	        d GetLogInfo
	        d OutPutInfo     
		}
	}
	elseif((PAStartDate '="")&&(PAEndDate '= ""))
	{
		s PAStartDate=$zdh(PAStartDate,3),PAEndDate=$zdh(PAEndDate,3)
		for AdmDate = PAStartDate:1:PAEndDate 
		{
			s tempMRPID = ""
			for {
			    s tempMRPID = $o(^DHCEPRFS.INST.MREpisodeI("IdxAdmDate",AdmDate,tempMRPID))
			    q:(tempMRPID = "")
			    s MRPatientID = $tr(tempMRPID," ","")
			    s flag = $$GetPatientInfo()
			    continue:(flag '= "1")
			    s MEpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxAdmDate",AdmDate,tempMRPID,""))
				s flag = $$GetEpisodeInfo()
			    continue:(flag '= "1")
			    d GetLogInfo
			    d OutPutInfo 
			}
		}
	}
	elseif((PDStartDate '= "")&&(PDEndDate '= ""))
	{
		s PDStartDate=$zdh(PDStartDate,3),PDEndDate=$zdh(PDEndDate,3)
		for DisDate = PDStartDate:1:PDEndDate 
		{
			s tempMRPID = ""
			for {
			    s tempMRPID = $o(^DHCEPRFS.INST.MREpisodeI("IdxDisDate",DisDate,tempMRPID))
			    q:(tempMRPID = "")
			    s MRPatientID = $tr(tempMRPID," ","")
			    s flag = $$GetPatientInfo()
			    continue:(flag '= "1")
			    s MEpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxDisDate",DisDate,tempMRPID,""))
			    s flag = $$GetEpisodeInfo()
			    continue:(flag '= "1")
			    d GetLogInfo
			    d OutPutInfo 
			}
		}	
	}
	elseif (ObservedNo '= "")
	{
		s MRPatientID = ""
		for {
			s MRPatientID = $o(^DHCEPRFS.INST.MRPatientI("IdxObservedNo"," "_ObservedNo,MRPatientID))
		    q:(MRPatientID = "")
		    s flag = $$GetPatientInfo()
	        continue:(flag '= "1")
	        s MEpisodeID = ""
	        for {
	            s MEpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxMRPatientID"," "_MRPatientID,MEpisodeID))
	            q:(MEpisodeID = "")
	            s flag = $$GetEpisodeInfo()
				continue:(flag '= "1")
	            d GetLogInfo
	            d OutPutInfo
            }  
		}
	}
	elseif (PBirthday '= "")
	{
		s birthday = $zdh(PBirthday,8)
		s MRPatientID = ""
		for {
			s MRPatientID = $o(^DHCEPRFS.INST.MRPatientI("IdxBirthday"," "_birthday,MRPatientID))
		    q:(MRPatientID = "")
		    s flag = $$GetPatientInfo()
	        continue:(flag '= "1")
	        s MEpisodeID = ""
	        for {
	            s MEpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxMRPatientID"," "_MRPatientID,MEpisodeID))
	            q:(MEpisodeID = "")
	            s flag = $$GetEpisodeInfo()
				continue:(flag '= "1")
	            d GetLogInfo
	            d OutPutInfo
            }  
		}
	}
	Quit $$$OK
	
GetPatientInfo()
    s flag = "-1"
    s objPatient = ##Class(DHCEPRFS.INST.MRPatient).%OpenId(MRPatientID)
    
    s Name = objPatient.Name
    q:((PName '="") && ($zcvt(Name,"U") '[ PName)) flag 
    s Birthday = objPatient.Birthday
    q:(AParam.Birthday '= "")&&(AParam.Birthday '= Birthday) flag
    s:(Birthday '= "") Birthday = $zd(Birthday,3)
    s Age = objPatient.Age	
    s Sex = objPatient.Gender
    s HouseAddress = objPatient.HouseAddress
    s LinkName = objPatient.LinkName	
    s LinkRelation = objPatient.LinkRelation
    //交由就诊号那取病案号
    s MedRecordNo = ""
    //s MedRecordNo = objPatient.MedRecordNo
    //q:((PMedRecordNo '= "")&&(MedRecordNo '=PMedRecordNo)) flag
    d objPatient.%Close()
    s flag = "1"
    q flag
GetEpisodePatientInfo()
    s flag = "-1"
    s objPatient = ##Class(DHCEPRFS.INST.MREpisodePat).%OpenId(MREpisodePatID)
    s Name = objPatient.Name
    q:((PName '="") && ($zcvt(Name,"U") '[ PName)) flag 
    s Birthday = objPatient.Birthday
    q:(AParam.Birthday '= "")&&(AParam.Birthday '= Birthday) flag
    s:(Birthday '= "") Birthday = $zd(Birthday,3)
    s Age = objPatient.Age	
    s Sex = objPatient.Gender
    s HouseAddress = objPatient.HouseAddress
    s LinkName = objPatient.LinkName	
    s LinkRelation = objPatient.LinkRelation
    s MedRecordNo = objPatient.MedRecordNo
    if (MedRecordNo '= "")
    {
    	s MedRecordNo = $zcvt(MedRecordNo,"U")
    }
    q:((PMedRecordNo '= "")&&(MedRecordNo '=PMedRecordNo)) flag
    d objPatient.%Close()
    s flag = "1"
    q flag
GetEpisodeInfo()
	s flag = "-1"
	s objEpisode = ##Class(DHCEPRFS.INST.MREpisode).%OpenId(MEpisodeID)
	s EpisodeID = objEpisode.EpisodeID
	s PatientID = ..GetPapmiDR(EpisodeID)
	
	if (MedRecordNo = "")
	{
		s MedRecordNo = objEpisode.MedRecordNo
	}
	
	s AdmDate = objEpisode.AdmDate
	s AdmTime = objEpisode.AdmTime   
	s DisDate = objEpisode.DisDate
	s DisTime = objEpisode.DisTime
	
	s hospitalFlag = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("HospitalFlag")
    if (hospitalFlag = "FCYY")
    {
		s DisDate = objEpisode.DisDateDoc   
		s DisTime = objEpisode.DisTimeDoc  
	}
	
	s AdmDateTime = ""
	s DisDateTime = ""
	//可能在生成时出院日期为空（没办出院），则此时在扫描查询时存在这种情况则更新就诊信息（扫描时一般已办出院）
	if ((DisDate = "") || (DisDate = $c(0)))
	{
		d objEpisode.%Close()
		d ##class(DHCEPRFS.BL.BLUpdateMrEpisode).UpdateMrEpisodeData(MEpisodeID)
		s objEpisode = ##Class(DHCEPRFS.INST.MREpisode).%OpenId(MEpisodeID)
		s AdmDate = objEpisode.AdmDate
		s AdmTime = objEpisode.AdmTime   
		s DisDate = objEpisode.DisDate
		s DisTime = objEpisode.DisTime
	}
	
 	s AdmLoc = objEpisode.AdmLoc
    s DisLoc = objEpisode.DisLoc
	
	s:(AdmDate = $c(0)) AdmDate = ""
	if (AdmDate '= "")
	{
		if (PAStartDate '= "")
		{
			q:(AdmDate < PAStartDate) flag
		}
		
		if (PAEndDate '= "")
		{
			q:(AdmDate > PAEndDate) flag
		}
		
		s AdmDateTime = $zd(AdmDate,3) 
	}
	s:(DisDate = $c(0)) DisDate = ""
	if (DisDate '= "")
	{
    	s DisDateTime = $zd(DisDate,3) 
	}
      
    s AdmLoc = objEpisode.AdmLoc
    s DisLoc = objEpisode.DisLoc
    
    s isWMROn = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("IsWMROn")
    if (isWMROn = "Y")
    {
    	s LastMrStatusString = ##class(DHCEPRFS.BL.HISInfo.BLWMRInfo).GetLastMrStatus(EpisodeID)
    	s LastMrStatus = $p(LastMrStatusString,"^",1)
    	s LastMrStatusDateTime = $p(LastMrStatusString,"^",2)_" "_$p(LastMrStatusString,"^",3)
    	s LastMrStatusOperator = $p(LastMrStatusString,"^",5)

    }
    else
    {
    	s LastMrStatusString = ""
    	s LastMrStatus = ""
    	s LastMrStatusDateTime = ""
    	s LastMrStatusOperator = ""	   
	}
    s MedRecordNo = $g(MedRecordNo)
    if (MedRecordNo="")||(MedRecordNo=$c(0))
    {
	    s MedRecordNo = objEpisode.MedRecordNo
    }
    
    if ($e(EpisodeID,1,2) = "VE")
    {
		s DeathDate = objEpisode.DeathDate   
		s:(DeathDate '= "") DeathDate = $zd(DeathDate,3) 
	}
    else
    {
   		s DeathDateTime = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).DeathDateTime(PatientID)
    	if (DeathDateTime = "")
    	{
			s DeathDate = ""    
		}
		else
		{
			//只有最后一次就诊死亡
			if ((DisDate '= "") && (DisDate < $p(DeathDateTime,",",1)))
			{
				//出院日期小于死亡日期，此次就诊未死亡	
				s DeathDate = ""
			}
			elseif ((DisDate '= "") && (DisDate = $p(DeathDateTime,",",1)))
			{
				//出院日期等于死亡日期，判断此次就诊是否是最后一次就诊	
				s mrEpisodeID = ""
				s lastDisDate = $zd(DisDate,3)
				s lastDisTime = $zt(DisTime,3)
				s tempMREpisodeID = MEpisodeID
				for {
					s mrEpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxMRPatientID"," "_MRPatientID,mrEpisodeID))
					q:(mrEpisodeID = "")
					s objTemp = ##Class(DHCEPRFS.INST.MREpisode).%OpenId(mrEpisodeID)
					if ($zd(objTemp.DisDate,3) > lastDisDate)
					{
						s lastDisDate = $zd(objTemp.DisDate,3)
						s lastDisTime = $zt(objTemp.DisTime,3)
						s tempMREpisodeID = mrEpisodeID
						continue
					}
				
					if (($zd(objTemp.DisDate,3) = lastDisDate) && ($zt(objTemp.DisTime,3) > lastDisTime))
					{
						s lastDisDate = $zd(objTemp.DisDate,3)
						s lastDisTime = $zt(objTemp.DisTime,3)
						s tempMREpisodeID = mrEpisodeID
						continue
					}
				}
				//此次为最后一次就诊
				if (tempMREpisodeID = MEpisodeID)
				{
					s DeathDate = $zd($p(DeathDateTime,",",1),3)_" "_$zt($p(DeathDateTime,",",2),3)
				}
				else
				{
					s DeathDate = ""
				}
			}
			else
			{
    			s DeathDate = $zd($p(DeathDateTime,",",1),3)_" "_$zt($p(DeathDateTime,",",2),3)
			}
		}
    }
    s MainDiagDesc = ""
    d objEpisode.%Close()
    s flag = "1"  
    q flag  
GetLogInfo
	s Scan = ##class(DHCEPRFS.BL.BLMRLog).GetScanData(MEpisodeID)
	s ScanerName = $p(Scan,"^",1)
	s ScanDate = $p(Scan,"^",2)
	s ScanTime = $p(Scan,"^",3)
	s ScanDateTime = ScanDate_" "_ScanTime
	//s LastStatus = ##Class(DHCEPRFS.BL.BLMRLog).GetStatus(MEpisodeID)
	s LastStatus = ##Class(DHCEPRFS.BL.BLMRLog).GetAllStatus(MEpisodeID)

	s LastReview = ##Class(DHCEPRFS.BL.BLMRLog).GetLastOpNameAndDate(MEpisodeID,"REVIEW")
	s LastReviewOperator = $p(LastReview,"^",1)
   	s LastReviewDateTime = $p(LastReview,"^",2)
	
	q
OutPutInfo 
	s hasScanPrivilege=##class(DHCEPRFS.BL.BLPrivilege).CheckScanPrivilege(MEpisodeID,AParam.QueryUserID)
	q:(hasScanPrivilege="-1")	//如果是-1则不显示该条记录
    s data = $lb(MRPatientID,MEpisodeID,MedRecordNo,Name,Birthday,Age,Sex,HouseAddress,LinkName,LinkRelation,AdmDateTime,DisDateTime,AdmLoc,DisLoc,MainDiagDesc,DeathDate,ScanerName,ScanDateTime,LastStatus,LastMrStatus,LastMrStatusDateTime,LastMrStatusOperator,LastReviewOperator,LastReviewDateTime)
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1
    q
GetParm
  	s PName = $zcvt(AParam.Name,"U")
	s PMedRecordNo =  $zcvt(AParam.MedRecordNo,"U")
	s PNo = AParam.PatientID
	if ((PNo '= "") && (PNo '= $c(0)))
	{
		s PNo = ..AddZero(PNo)	
	}
	s PIDCard = AParam.IDCard
	s PAStartDate = AParam.AdmStratDate
	s PAEndDate = AParam.AdmEndDate
	s PDStartDate = AParam.DisStratDate
	s PDEndDate = AParam.DisEndDate
	s ObservedNo = AParam.ObservedNo
	s PMRMedRecordNo = $zcvt(AParam.MRMedRecordNo,"U")
	s PBirthday = AParam.Birthday
	q
}

ClassMethod GetPatientInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatientInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPatientInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatientInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

/// Desc:病人信息列表
/// Creator:Candy
/// CreateDate:2013-05-02
/// debug:do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.HISInfo.BLPatientInfo","GetPatInfo4Print","")
Query GetPatInfo4Print(AParam As DHCEPRFS.Entity.EPatientInfoQueryPara) As %Query(ROWSPEC = "AdmTypeID:%String,AdmType:%String,MRPatientID:%String,MREpisodeID:%String,ObservedNo:%String,MedRecordNo:%String,RegNo:%String,Name:%String,Birthday:%String,Age:%String,Sex:%String,HouseAddress:%String,LinkName:%String,LinkRelation:%String,AdmDateTime:%String,DisDateTime:%String,AdmInLoc:%String,DischgrgeLoc:%String,AdmWard:%String,DisWard:%String,MainDiagDesc:%String,DeathDate:%String,ScanerName:%String,ScanDateTime:%String,LastStatus:%String,LastMrStatus:%String,LastMrStatusDateTime:%String,LastMrStatusOperator:%String,DeathFlag:%String,FinalAccountFlag:%String,CanPrintFlag:%String,IsPrinted:%String,IsAdvancedSecurity:%String,PrintPrivilege:%String,FinalAccountFlagRemark:%String,FinalAccountFlagRemarkDesc:%String,IsCardScan:%String")
{
}

ClassMethod GetPatInfo4PrintExecute(ByRef qHandle As %Binary, AParam As DHCEPRFS.Entity.EPatientInfoQueryPara) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	q:(AParam = "") $$$OK

	d GetParmForPrint
	if (PName '= "")
	{
		s tmpName = " "_$zcvt(PName,"U")
		while ((tmpName'="")&&(tmpName[PName)) 
		{
		    s MRPatientID = ""
		    for {
		        s MRPatientID = $o(^DHCEPRFS.INST.MRPatientI("IdxName",tmpName,MRPatientID))
	            q:(MRPatientID = "")
	            s flag = $$GetMRPatForPrint()
	            continue:(flag '= "1")
	            s MEpisodeID = ""
                for {
	                s MEpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxMRPatientID"," "_MRPatientID,MEpisodeID))
	                q:(MEpisodeID = "")
	                d GetEpisodeForPrint
	                d GetLogForPrint
	                d OutPutForPrint
                }  
		    }
		    s tmpName=$o(^DHCEPRFS.INST.MRPatientI("IdxName",tmpName))
		}
	}
	elseif (PIDCard '="")
	{
		s MRPatientID = ""
		for {
			s MRPatientID = $o(^DHCEPRFS.INST.MRPatientI("IdxIDCard"," "_PIDCard,MRPatientID))
		    q:(MRPatientID = "")
		    s flag = $$GetMRPatForPrint()
	        continue:(flag '= "1")
	        s MEpisodeID = ""
	        for {
	            s MEpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxMRPatientID"," "_MRPatientID,MEpisodeID))
	            q:(MEpisodeID = "")
	            d GetEpisodeForPrint
	            d GetLogForPrint
	            d OutPutForPrint
            }  
		}
	}
	elseif(PNo'="")
	{
		s MRPatientID = ""
		for {
			s MRPatientID = $o(^DHCEPRFS.INST.MRPatientI("IdxRegNo"," "_PNo,MRPatientID))
		    q:(MRPatientID = "")
		    s flag = $$GetMRPatForPrint()
	        continue:(flag '= "1")
	        s MEpisodeID = ""
	        for {
	            s MEpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxMRPatientID"," "_MRPatientID,MEpisodeID))
	            q:(MEpisodeID = "")
	            d GetEpisodeForPrint
	            d GetLogForPrint
	            d OutPutForPrint
            }  
		}
	}
	elseif(PMedRecordNo'= "")
	{
	   	s MREpisodePatID = ""
		for {
			s MREpisodePatID = $o(^DHCEPRFS.INST.MREpisodePatI("IdxMedRecordNo"," "_PMedRecordNo,MREpisodePatID))
		    q:(MREpisodePatID = "")
		    s objMREpisodePat = ##class(DHCEPRFS.INST.MREpisodePat).%OpenId(MREpisodePatID)
		    s MRPatientID = objMREpisodePat.MRPatientID
		    s MRMedRecordID = objMREpisodePat.MRMedRecordID
		    s objMRMed = ##class(DHCEPRFS.INST.MRMedRecord).%OpenId(MRMedRecordID)
		    s isHIS = objMRMed.IsHISMedRecord
		    if (isHIS = "N")
		    {
			   s flag = $$GetMRPatForPrint() 
			}
			else
			{
		    	s flag = $$GetMREpisodePatForPrint()
			}
	        continue:(flag '= "1")
	        s MEpisodeID = objMREpisodePat.MREpisodeID
	        d GetEpisodeForPrint
	        d GetLogForPrint
	        d OutPutForPrint
		}	
	}
	elseif (PMRMedRecordNo '= "")
	{
		s objMRMedRecord = ##class(DHCEPRFS.INST.MRMedRecord).%OpenId(PMRMedRecordNo)
		s MRPatientID = objMRMedRecord.MRPatientID
		s flag = $$GetMRPatForPrint()
	    s MEpisodeID = ""
	    for {
			s MEpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxMRMedRecordID"," "_PMRMedRecordNo,MEpisodeID))
			q:(MEpisodeID = "")
			d GetEpisodeForPrint
	        d GetLogForPrint
	        d OutPutForPrint    
		}
	}
	elseif((PAStartDate '="")&&(PAEndDate '= ""))
	{
		s PAStartDate=$zdh(PAStartDate,3),PAEndDate=$zdh(PAEndDate,3)
		for AdmDate = PAStartDate:1:PAEndDate 
		{
			s tempMRPID = ""
			for {
			    s tempMRPID = $o(^DHCEPRFS.INST.MREpisodeI("IdxAdmDate",AdmDate,tempMRPID))
			    q:(tempMRPID = "")
			    s MRPatientID = $tr(tempMRPID," ","")
			    s flag = $$GetMRPatForPrint()
			    continue:(flag '= "1")
			    s MEpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxAdmDate",AdmDate,tempMRPID,""))
			    d GetEpisodeForPrint
			    d GetLogForPrint
			    d OutPutForPrint
			}
		}
	}
	elseif((PDStartDate '= "")&&(PDEndDate '= ""))
	{
		s PDStartDate=$zdh(PDStartDate,3),PDEndDate=$zdh(PDEndDate,3)
		for DisDate = PDStartDate:1:PDEndDate 
		{
			s tempMRPID = ""
			for {
			    s tempMRPID = $o(^DHCEPRFS.INST.MREpisodeI("IdxDisDate",DisDate,tempMRPID))
			    q:(tempMRPID = "")
			    s MRPatientID = $tr(tempMRPID," ","")
			    s flag = $$GetMRPatForPrint()
			    continue:(flag '= "1")
			    s MEpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxDisDate",DisDate,tempMRPID,""))
			    d GetEpisodeForPrint
			    d GetLogForPrint
			    d OutPutForPrint
			}
		}	
	}
	elseif (ObservedNo '= "")
	{
		s MRPatientID = ""
		for {
			s MRPatientID = $o(^DHCEPRFS.INST.MRPatientI("IdxObservedNo"," "_ObservedNo,MRPatientID))
		    q:(MRPatientID = "")
		    s flag = $$GetMRPatForPrint()
	        continue:(flag '= "1")
	        s MEpisodeID = ""
	        for {
	            s MEpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxMRPatientID"," "_MRPatientID,MEpisodeID))
	            q:(MEpisodeID = "")
	            d GetEpisodeForPrint
	            d GetLogForPrint
	            d OutPutForPrint
            }  
		}
	}
	Quit $$$OK
	
GetMRPatForPrint()
    s flag = "-1"
    s objPatient = ##Class(DHCEPRFS.INST.MRPatient).%OpenId(MRPatientID)
    
    s Name = objPatient.Name
    s regNo = objPatient.RegNo
    q:((PName '="") && ($zcvt(Name,"U") '[ PName)) flag 
    s Birthday = objPatient.Birthday
    q:(PBirthday '= "")&&($zdh(PBirthday,3) '= Birthday) flag
    if (Birthday '= "")
    {
	   s Birthday = $zd(Birthday,3)
    }
    //增加省份筛选
    q:(PProvinceCode '= "")&&(PProvinceCode '= objPatient.HouseProvinceID) flag
    //增加婚姻筛选
    q:(PMarriageCode '= "")&&(PMarriageCode '= objPatient.MarriageID) flag
    //增加性别筛选
    
    s Sex = objPatient.Gender
    q:((PGender '="") && (PGender'=Sex)) flag 

    s Age = ""
    s Age = objPatient.Age	
    s Sex = objPatient.Gender
    s HouseAddress = objPatient.HouseAddress
    s LinkName = objPatient.LinkName	
    s LinkRelation = objPatient.LinkRelation
    s MedRecordNo = objPatient.MedRecordNo
    s ObservedNo = objPatient.ObservedNo
    
    if (MedRecordNo'="")&&(MedRecordNo'=$c(0))
    {
	    s MedRecordNo = $ZCVT(MedRecordNo,"U")
    }
    q:((PMedRecordNo '= "")&&(MedRecordNo '=PMedRecordNo)) flag
    d objPatient.%Close()
    s flag = "1"
    q flag
GetMREpisodePatForPrint()
    s flag = "-1"
    s objPatient = ##Class(DHCEPRFS.INST.MREpisodePat).%OpenId(MREpisodePatID)
    s Name = objPatient.Name
    s regNo = objPatient.RegNo
    q:((PName '="") && ($zcvt(Name,"U") '[ PName)) flag 
    s Birthday = objPatient.Birthday
    q:(PBirthday '= "")&&($zdh(PBirthday,3) '= Birthday) flag
    if (Birthday '= "")
    {
	   s Birthday = $zd(Birthday,3)
    }
    //增加省份筛选
    q:(PProvinceCode '= "")&&(PProvinceCode '= objPatient.HouseProvinceID) flag
    //增加婚姻筛选
    q:(PMarriageCode '= "")&&(PMarriageCode '= objPatient.MarriageID) flag
    s Age = ""
    s Age = objPatient.Age	
    s Sex = objPatient.Gender
    s HouseAddress = objPatient.HouseAddress
    s LinkName = objPatient.LinkName	
    s LinkRelation = objPatient.LinkRelation
    s MedRecordNo = objPatient.MedRecordNo
    if (MedRecordNo'="")&&(MedRecordNo'=$c(0))
    {
	    s MedRecordNo = $ZCVT(MedRecordNo,"U")
    }
    q:((PMedRecordNo '= "")&&(MedRecordNo '=PMedRecordNo)) flag
    d objPatient.%Close()
    s flag = "1"
    q flag
GetEpisodeForPrint
	s objEpisode = ##Class(DHCEPRFS.INST.MREpisode).%OpenId(MEpisodeID)
	s EpisodeID = objEpisode.EpisodeID
	s PatientID = ..GetPapmiDR(EpisodeID)
	s AdmDate = objEpisode.AdmDate
	if (AdmDate '= "")&&(Birthday '= "")
	{
		s BirthdayCD = $zdh(Birthday,3)
		s Age = $fn((+AdmDate-BirthdayCD)/365,"",0)
	}

	s AdmTime = objEpisode.AdmTime   
	s DisDate = objEpisode.DisDate
	s DisTime = objEpisode.DisTime
	
	s AdmDateTime = ""
	s DisDateTime = ""
	//可能在生成时出院日期为空（没办出院），则此时在扫描查询时存在这种情况则更新就诊信息（扫描时一般已办出院）
	if ((DisDate = "") || (DisDate = $c(0)))
	{
		d objEpisode.%Close()
		d ##class(DHCEPRFS.BL.BLUpdateMrEpisode).UpdateMrEpisodeData(MEpisodeID)
		s objEpisode = ##Class(DHCEPRFS.INST.MREpisode).%OpenId(MEpisodeID)
		s AdmDate = objEpisode.AdmDate
		s AdmTime = objEpisode.AdmTime   
		s DisDate = objEpisode.DisDate
		s DisTime = objEpisode.DisTime
	}
	
	s AdmLoc = objEpisode.AdmLoc
    s DisLoc = objEpisode.DisLoc
    
    s AdmWard = objEpisode.AdmWard
    s DisWard = objEpisode.DisWard
    
    s AdmTypeCode = objEpisode.AdmTypeID
    s AdmType = objEpisode.AdmType
    s AdmTypeID = "1"  
    if (AdmTypeCode = "O") 
    {
		s AdmTypeID = "2"    
	}
	elseif (AdmTypeCode = "E") 
	{
		s AdmTypeID = "3" 	
	}
	
	s:(AdmDate = $c(0)) AdmDate = ""
	if (AdmDate '= "")
	{
		s AdmDateTime = $zd(AdmDate,3) 
	}
	else
	{
		s AdmLoc = ""
	}
	
	s:(DisDate = $c(0)) DisDate = ""
	if (DisDate '= "")
	{
    	s DisDateTime = $zd(DisDate,3) 
	}
    else
	{
		s DisLoc = ""
	} 

    
    s isWMROn = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("IsWMROn")
    if (isWMROn = "Y")
    {
    	s LastMrStatusString = ##class(DHCEPRFS.BL.HISInfo.BLWMRInfo).GetLastMrStatus(EpisodeID)
    	s LastMrStatus = $p(LastMrStatusString,"^",1)
    	s LastMrStatusDateTime = $p(LastMrStatusString,"^",2)_" "_$p(LastMrStatusString,"^",3)
    	s LastMrStatusOperator = $p(LastMrStatusString,"^",5)
 
    }
    else
    {
    	s LastMrStatusString = ""
    	s LastMrStatus = ""
    	s LastMrStatusDateTime = ""
    	s LastMrStatusOperator = ""	    
	}
	s PrintPrivilege = ##class(DHCEPRFS.BL.BLPrivilege).CheckPrintPrivilege(MEpisodeID,EpisodeID,PQueryUserID)
    s MedRecordNo = $g(MedRecordNo)
    if (MedRecordNo="")||(MedRecordNo=$c(0))
    {
	    s MedRecordNo = objEpisode.MedRecordNo
    }
    
    if ($e(EpisodeID,1,2) = "VE")
    {
		s DeathDate = objEpisode.DeathDate   
		s:(DeathDate '= "") DeathDate = $zd(DeathDate,3) 
	}
    else
    {
    	s DeathDateTime = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).DeathDateTime(PatientID)
    	if (DeathDateTime = "")
    	{
			s DeathDate = ""    
		}
		else
		{
			//只有最后一次就诊死亡
			if ((DisDate '= "") && (DisDate < $p(DeathDateTime,",",1)))
			{
				//出院日期小于死亡日期，此次就诊未死亡	
				s DeathDate = ""
			}
			elseif ((DisDate '= "") && (DisDate = $p(DeathDateTime,",",1)))
			{
				//出院日期等于死亡日期，判断此次就诊是否是最后一次就诊	
				s mrEpisodeID = ""
				s lastDisDate = $zd(DisDate,3)
				s lastDisTime = $zt(DisTime,3)
				s tempMREpisodeID = MEpisodeID
				for {
					s mrEpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxMRPatientID"," "_MRPatientID,mrEpisodeID))
					q:(mrEpisodeID = "")
					s objTemp = ##Class(DHCEPRFS.INST.MREpisode).%OpenId(mrEpisodeID)
					if ($zd(objTemp.DisDate,3) > lastDisDate)
					{
						s lastDisDate = $zd(objTemp.DisDate,3)
						s lastDisTime = $zt(objTemp.DisTime,3)
						s tempMREpisodeID = mrEpisodeID
						continue
					}
				
					if (($zd(objTemp.DisDate,3) = lastDisDate) && ($zt(objTemp.DisTime,3) > lastDisTime))
					{
						s lastDisDate = $zd(objTemp.DisDate,3)
						s lastDisTime = $zt(objTemp.DisTime,3)
						s tempMREpisodeID = mrEpisodeID
						continue
					}
				}
				//此次为最后一次就诊
				if (tempMREpisodeID = MEpisodeID)
				{
					s DeathDate = $zd($p(DeathDateTime,",",1),3)_" "_$zt($p(DeathDateTime,",",2),3)
				}
				else
				{
					s DeathDate = ""
				}
			}
			else
			{
    			s DeathDate = $zd($p(DeathDateTime,",",1),3)_" "_$zt($p(DeathDateTime,",",2),3)
			}
		}
	
		s DeathDate2 = ##Class(EPRservice.BOScatterData).GetEPRData(objEpisode.EpisodeID,"EMR10 住院病程记录.EMR100014 死亡记录.入院时情况.入院时情况.死亡日期#TYPE:Simple#TID:38#TVER:0#SCODE:D0010#VTYPE:YMD")
    	if (DeathDate = "")&&(DeathDate2'="") {s DeathDate =  DeathDate2}
    	s DeathDate3 = ##Class(EPRservice.BOScatterData).GetEPRData(objEpisode.EpisodeID,"EMR09 住院志.EMR090003 24小时内入院死亡记录.24小时内入院死亡记录.入院情况.入院情况.死亡日期#TYPE:Simple#TID:54#TVER:0#SCODE:D0010#VTYPE:YMD")
    	if (DeathDate = "")&&(DeathDate3'="") {s DeathDate =  DeathDate3}
    }
    
    if (DeathDate '= "") 
    {	s DeathFlag = "Y"}
    else
    {	s DeathFlag = "N"}

    s MainDiagDesc = ""
    d objEpisode.%Close() 
    //IsAdvancedSecurity
    s ASrowID = ""
	s ASrowID = $o(^DHCEPRRBAC.META.ASecurityI("IdxUnique"," DHC", " "_EpisodeID,ASrowID))
	if (ASrowID="")
	{	s IsAdvancedSecurity="N" }
	else
	{	s IsAdvancedSecurity="Y"}
	
	s IsCardScan = ""
	s mrVersionID = ""
	s mrItemIDCardScan = ""
	s mrVersionID = ##class(DHCEPRFS.BL.BLMRVersion).RegMRVersionID(MEpisodeID,"0")
	s mrItemIDCardScan = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("CardScanMRItemID")
	if (mrVersionID '="")&&(mrItemIDCardScan '="")
	{
		s rowIDCardScan = ""
		s rowIDCardScan = $o(^DHCEPRFS.INST.MRVerItemI("IdxMain"," "_mrVersionID," "_mrItemIDCardScan,rowIDCardScan))
		if (rowIDCardScan '="")
		{
			s IsCardScan = "Y"
		}
		else
		{
			s IsCardScan = "N"
		}
	}
    q   
GetLogForPrint
	s Scan = ##class(DHCEPRFS.BL.BLMRLog).GetScanData(MEpisodeID)
	s ScanerName = $p(Scan,"^",1)
	s ScanDate = $p(Scan,"^",2)
	s ScanTime = $p(Scan,"^",3)
	s ScanDateTime = ScanDate_" "_ScanTime
	//s LastStatus = ##Class(DHCEPRFS.BL.BLMRLog).GetStatus(MEpisodeID)
	//s LastStatus = ##Class(DHCEPRFS.BL.BLMRLog).GetAllStatus(MEpisodeID)
	s LastStatus = ##Class(DHCEPRFS.BL.BLMRLog).GetLastStatus(MEpisodeID)
	
	s FinalAccountFlag = ##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).HasFinalAccount(EpisodeID)
    if (FinalAccountFlag = "1")
    {	s FinalAccountFlag = "已"}
    else
    {	s FinalAccountFlag = "未"}
    
    s LastStatusCode = ##Class(DHCEPRFS.BL.BLMRLog).GetAllStatusCode(MEpisodeID)
	s LastStatus1 = $tr($p(LastStatusCode,"|",1)," ","")
	s LastStatus2 = $tr($p(LastStatusCode,"|",2)," ","")
	s isLastStatus1OK = (LastStatus1 = "REVIEWED")||(LastStatus1 = "CATALOGED")||(LastStatus1 = "REPLACED")
	s isLastStatus2OK = (LastStatus2 = "REPLACED")||(LastStatus2 = "CONFIRMSCAN")
	
	if (isLastStatus1OK && isLastStatus2OK && (FinalAccountFlag = "已"))
	{	s CanPrintFlag = "是"}
	else
	{	s CanPrintFlag = "否"}
	
	s isPrinted = ##class(DHCEPRFS.BL.BLMRLog).IsPrinted(MEpisodeID)
    if (isPrinted = "1")
    {	s isPrinted = "已"}
    else
    {	s isPrinted = "未"}
	
	q
OutPutForPrint
    //if (MRPatientID = "234532") b "s"
    q:(PrintPrivilege="-1")		//宁医要求不符合权限的患者不显示
    s data = $lb(AdmTypeID,AdmType,MRPatientID,MEpisodeID,ObservedNo,MedRecordNo,regNo,Name,Birthday,Age,Sex,HouseAddress,LinkName,LinkRelation,AdmDateTime,DisDateTime,AdmLoc,DisLoc,AdmWard,DisWard, MainDiagDesc,DeathDate,ScanerName,ScanDateTime,LastStatus,LastMrStatus,LastMrStatusDateTime,LastMrStatusOperator,DeathFlag,FinalAccountFlag,CanPrintFlag,isPrinted,IsAdvancedSecurity,PrintPrivilege,FinalAccountFlagRemark,FinalAccountFlagRemarkDesc,IsCardScan)
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1
    q
GetParmForPrint
  	s PName = $zcvt(AParam.Name,"U")
	s PMedRecordNo =  $zcvt(AParam.MedRecordNo,"U")
	s PNo = AParam.PatientID
	if ((PNo '= "") && (PNo '= $c(0)))
	{
		s PNo = ..AddZero(PNo)	
	}
	s PIDCard = AParam.IDCard
	s PAStartDate = AParam.AdmStratDate
	s PAEndDate = AParam.AdmEndDate
	s PDStartDate = AParam.DisStratDate
	s PDEndDate = AParam.DisEndDate
	s PMRMedRecordNo = $zcvt(AParam.MRMedRecordNo,"U")
	s PQueryUserID = AParam.QueryUserID
	s PBirthday = AParam.Birthday
	s:(PBirthday = $c(0)) PBirthday = ""
	s PProvinceCode=AParam.HouseProvince
	s:(PProvinceCode = $c(0)) PProvinceCode = ""
	s PMarriageCode=AParam.Marriage
	s ObservedNo = AParam.ObservedNo
	s:(PMarriageCode = $c(0)) PMarriageCode = ""
	s PGender=AParam.Gender
	s:(PGender = $c(0)) PGender = ""
	q
}

ClassMethod GetPatInfo4PrintClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatInfo4PrintExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPatInfo4PrintFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatInfo4PrintExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

/// debug: w ##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).AddZero("8284286")
ClassMethod AddZero(ARegNo As %String) As %String
{
	s regNo = ""
	s regNo = $o(^PAPERi("PAPMI_PatNo",regNo))
	s regNo = $tr(regNo, " ")
	s regNo = $tr(regNo,$c(10),"")
	s regNo = $tr(regNo,$c(13),"")
	s length = $l(regNo)
	q:(length = $l(ARegNo)) ARegNo
	
	for index=1:1:(length - $l(ARegNo)) 
	{
		s ARegNo = "0"_ARegNo
	}
	q ARegNo
}

/// do ##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).Test()
ClassMethod Test()
{
	s EP = ##Class(DHCEPRFS.Entity.EPatientInfoQueryPara).%New()
	//s EP.MedRecordNo = "500307"
	//s EP.MRMedRecordNo = "23"
	//s EP.Name = "张秀兰"
	//s EP.AdmEndDate = "2016-03-21"
	//s EP.AdmStratDate = "2016-03-01"
	//s EP.IDCard = "231081196810110623"
	//s EP.Marriage="20"
	s EP.MedRecordNo = "500301"
	s obj = ##Class(%ResultSet).%New("DHCEPRFS.BL.HISInfo.BLPatientInfo:GetPatientInfo")
	d obj.Execute(EP)
	while (obj.Next())
	{
		//if (obj.Data("MedRecordNo") = "90566012")
		//{
			w obj.Data("MREpisodeID")_"  "_obj.Data("MREpisodeID")_"  "_obj.Data("Name")
		//}
	}
}

/// 通过病人号得到病人基础信息
/// PAPMI:病人号   arrFiles:把病人基本信息组到一个队列导出
/// Output:
/// MedRecordNo:病 案 号
/// RegNo:登 记 号
/// IdCardNo:身份证号
/// PAPMIName:姓    名
/// PAPMISex:性    别PAPMISex = RowId^Code^Desc
/// PAPMIDOB:出生日期
/// Country:国    籍Country = RowId^Code^Desc
/// MobilePhone:手 机 号
/// CardType:证件类别CardType = RowId^Desc
/// IdCardNo:证 件 号
/// InsuType:医保类型InsuType = RowId^Desc
/// InsuNo:医 保 号
/// Marriage:婚姻状况Marriage = RowId^Code^Desc
/// Nation:民    族Nation = RowId^Code^Desc
/// Occupation:职    业Occupation = RowId^Code^Desc
/// Company:工作单位
/// Worktel:工作电话
/// HouseProvince:户口地址省 HouseProvince =RowId^Desc
/// HouseCity:户口地址市 HouseCity =RowId^Desc 
/// HouseArea:户口地址县 HouseArea =RowId^Desc
/// HouseAddress:户口地址街 HouseAddress =RowId^Desc
/// HouseZipCode:户口邮编
/// LinkName:联系人姓名
/// LinkRelation:联系人关系 LinkRelation = RowId^Code^Desc
/// LinkPhone:联系人电话
/// DeathDate:死亡日期
/// debug:w ##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetPatientInfoByPAPMI("199")
ClassMethod GetPatientInfoByPAPMI(PAPMI As %String) As %ArrayOfDataTypes
{
	q:(PAPMI = "") ""
	//s CTLocInfo = ""
	
	s arrFiles = ##class(%ArrayOfDataTypes).%New()
	//病 案 号
	s MedRecordNo = ""
	s MedRecordNo = ..GetMedRecordNo(PAPMI,"")
	d arrFiles.SetAt(MedRecordNo,"MedRecordNo")
	//登 记 号
	s RegNo = ""
	s RegNo = ..GetRegNo(PAPMI,"")
	d arrFiles.SetAt(RegNo,"RegNo")
	//身份证号
	s IdCardNo =""
	s IdCardNo = ..GetIDCard(PAPMI,"")
	d arrFiles.SetAt(IdCardNo,"IdCardNo")
	//姓    名
	s PAPMIName =""
	s PAPMIName =..GetName(PAPMI)
	d arrFiles.SetAt(PAPMIName,"PAPMIName")
	//性    别PAPMISex = RowId^Code^Desc
	s PAPMISex = ""
	s PAPMISex =..GetGender(PAPMI)
	d arrFiles.SetAt(PAPMISex,"PAPMISex")
	//出生日期
	s PAPMIDOB =""
	s PAPMIDOB = ..GetBirthday(PAPMI)
	d arrFiles.SetAt(PAPMIDOB,"PAPMIDOB")
	//国    籍Country = RowId^Code^Desc
	s Country =""
	s Country =..GetCountry(PAPMI)
	d arrFiles.SetAt(Country,"Country")
	//手 机 号
	s MobilePhone = ""
	s MobilePhone = ..GetPhoneNo(PAPMI,"")
	d arrFiles.SetAt(MobilePhone,"MobilePhone")
	//证件类别CardType = RowId^Desc
	s CardType = ""
	s CardType = ..GetCardType(PAPMI)
	d arrFiles.SetAt(CardType,"CardType")
	//证 件 号
	s IdCardNo = ""
	s IdCardNo = ..GetGovCardno(PAPMI)
	d arrFiles.SetAt(IdCardNo,"IdCardNo")
	//医保类型InsuType = RowId^Desc
	s InsuType =""
	s InsuType =..GetInsuType(PAPMI)
	d arrFiles.SetAt(InsuType,"InsuType")
	//医 保 号
	s InsuNo =""
	s InsuNo =..GetInsuNo(PAPMI)
	d arrFiles.SetAt(InsuNo,"InsuNo")
	//婚姻状况Marriage = RowId^Code^Desc
	s Marriage = ""
	s Marriage =..GetMarriage(PAPMI)
	d arrFiles.SetAt(Marriage,"Marriage")
	//民    族Nation = RowId^Code^Desc
	s Nation =""
	s Nation = ..GetNationality(PAPMI)
	d arrFiles.SetAt(Nation,"Nation")
	//职    业Occupation = RowId^Code^Desc
	s Occupation=""
	s Occupation = ..GetOccupation(PAPMI)
	d arrFiles.SetAt(Occupation,"Occupation")
	//工作单位
	s Company =""
	s Company = ..GetCompany(PAPMI)
	d arrFiles.SetAt(Company,"Company")
	//工作电话
	s Worktel = ""
	s Worktel =..GetWorktel(PAPMI)
	d arrFiles.SetAt(Worktel,"Worktel")
	//户口地址省 HouseProvince =RowId^Desc
	s HouseProvince =""
	s HouseProvince =..GetHouseProvince(PAPMI)
	d arrFiles.SetAt(HouseProvince,"HouseProvince")
	//户口地址市 HouseCity =RowId^Desc 
	s HouseCity =""
	s HouseCity = ..GetHouseCity(PAPMI)
	d arrFiles.SetAt(HouseCity,"HouseCity")
	//户口地址县 HouseArea =RowId^Desc
	s HouseArea = ""
	s HouseArea = ..GetHouseArea(PAPMI)
	d arrFiles.SetAt(HouseArea,"HouseArea")
	//户口地址街 HouseAddress =RowId^Desc
	s HouseAddress = ""
	s HouseAddress =..GetHouseAddress(PAPMI)
	d arrFiles.SetAt(HouseAddress,"HouseAddress")
	//户口邮编
	s HouseZipCode =""
	s HouseZipCode =..GetHouseZipCode(PAPMI)
	d arrFiles.SetAt(HouseZipCode,"HouseZipCode")
	//联系人姓名
	s LinkName = ""
	s LinkName =..GetLinkName(PAPMI)
	d arrFiles.SetAt(LinkName,"LinkName")
	//联系人关系 LinkRelation = RowId^Code^Desc
	s LinkRelation = ""
	s LinkRelation =..GetLinkRelation(PAPMI)
	d arrFiles.SetAt(LinkRelation,"LinkRelation")
	//联系人电话
	s LinkPhone = ""
	s LinkPhone =..GetLinkPhone(PAPMI)
	d arrFiles.SetAt(LinkPhone,"LinkPhone")
	//死亡日期
	s DeathDate = ""
	s DeathDate = $p($g(^PAPER(PAPMI,"ALL")),"^",13)
	s:(DeathDate '= "") DeathDate = $zd(DeathDate,3)
	d arrFiles.SetAt(DeathDate,"DeathDate")
	q arrFiles
}

/// Desc: 打印ActiveX患者信息取值
/// Debug: d ##class(%ResultSet).RunQuery("DHCEPRFS.BL.HISInfo.BLPatientInfo","GetPatInfoUserControl","602")
Query GetPatInfoUserControl(AEpisodeID As %String) As %Query(ROWSPEC = "AdmTypeCode:%String,AdmType:%String,MRPatientID:%String,MREpisodeID:%String,MedRecordNo:%String,PatName:%String,PatBirthday:%String,PatAge:%String,PatSex:%String,AdmitDate:%String,DischDate:%String,AdmInLoc:%String,DischargeLoc:%String,AdmWard:%String,DisWard:%String,DeathDate:%String,DeathFlag:%String,ScanUserName:%String,ScanDateTime:%String,LastStatus:%String,IsPrinted:%String")
{
}

ClassMethod GetPatInfoUserControlExecute(ByRef qHandle As %Binary, AEpisodeID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	
	q:(AEpisodeID = "") $$$OK
	s mrEpisodeID = ""
	s mrEpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxSysCodeAndEpisodeID"," DHC"," "_AEpisodeID,mrEpisodeID))
	q:(mrEpisodeID = "") $$$OK
	
	s objMREpisode = ##Class(DHCEPRFS.INST.MREpisode).%OpenId(mrEpisodeID)
	s episodeID = objMREpisode.EpisodeID
	s mrPatientID = objMREpisode.MRPatientID
	s medRecordNo = objMREpisode.MedRecordNo
	
	s objMRPatient = ##Class(DHCEPRFS.INST.MRPatient).%OpenId(mrPatientID)
	s patName = objMRPatient.Name
	s patBirthday = objMRPatient.Birthday
	s:(patBirthday '= "") patBirthday = $zd(patBirthday,3)
	s patAge = objMRPatient.Age
	s patSex = objMRPatient.Gender
	s medRecordNo = objMRPatient.MedRecordNo
	if (medRecordNo '= "")&&(medRecordNo '= $c(0))
	{
		s medRecordNo = $ZCVT(medRecordNo,"U")
	}
	d objMRPatient.%Close()
	
	s admDate = objMREpisode.AdmDate
	s admTime = objMREpisode.AdmTime
	s disDate = objMREpisode.DisDate
	s disTime = objMREpisode.DisTime
	s admLoc = objMREpisode.AdmLoc
	s disLoc = objMREpisode.DisLoc
	s admWard = objMREpisode.AdmWard
	s disWard = objMREpisode.DisWard
	s admTypeCode = objMREpisode.AdmTypeID
	s admType = objMREpisode.AdmType
	
	if (admDate '= "")&&(patBirthday '= "")
	{
		s birthdayCD = $zdh(patBirthday,3)
		s patAge = $fn((+admDate-birthdayCD)/365,"",0)
	}
	
	s admitDate = "", dischDate = ""
	s:(admDate = $c(0)) admDate = ""
	if (admDate '= "")
	{
		s admitDate = $zd(admDate,3)
	}
	else
	{
		s admLoc = ""
	}
	
	s:(disDate = $c(0)) disDate = ""
	if (disDate '= "")
	{
		s dischDate = $zd(disDate,3)
	}
	else
	{
		s disLoc = ""
	} 
	
	if (medRecordNo = "")||(medRecordNo = $c(0))
	{
		s medRecordNo = objMREpisode.MedRecordNo
	}
	
	if ($e(episodeID,1,2) = "VE")
	{
		s deathDate = objMREpisode.DeathDate   
		s:(deathDate '= "") deathDate = $zd(deathDate,3) 
	}
	else
	{
		s patientID = ..GetPapmiDR(episodeID)
		s deathDateTime = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).DeathDateTime(patientID)
		if (deathDateTime = "")
		{
			s deathDate = ""
		}
		else
		{
			//只有最后一次就诊死亡
			if ((disDate '= "") && (disDate < $p(deathDateTime,",",1)))
			{
				//出院日期小于死亡日期，此次就诊未死亡
				s deathDate = ""
			}
			elseif ((disDate '= "") && (disDate = $p(deathDateTime,",",1)))
			{
				//出院日期等于死亡日期，判断此次就诊是否是最后一次就诊
				s lastDisDate = $zd(disDate,3)
				s lastDisTime = $zt(disTime,3)
				s tempMREpisodeID = mrEpisodeID
				s xMREpisodeID = ""
				for {
					s xMREpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxMRPatientID"," "_MRPatientID,xMREpisodeID))
					q:(xMREpisodeID = "")
					s objTemp = ##Class(DHCEPRFS.INST.MREpisode).%OpenId(xMREpisodeID)
					if ($zd(objTemp.DisDate,3) > lastDisDate)
					{
						s lastDisDate = $zd(objTemp.DisDate,3)
						s lastDisTime = $zt(objTemp.DisTime,3)
						s tempMREpisodeID = xMREpisodeID
						continue
					}
					
					if (($zd(objTemp.DisDate,3) = lastDisDate) && ($zt(objTemp.DisTime,3) > lastDisTime))
					{
						s lastDisDate = $zd(objTemp.DisDate,3)
						s lastDisTime = $zt(objTemp.DisTime,3)
						s tempMREpisodeID = xMREpisodeID
						continue
					}
				}
				//此次为最后一次就诊
				if (tempMREpisodeID = mrEpisodeID)
				{
					s deathDate = $zd($p(deathDateTime,",",1),3)_" "_$zt($p(deathDateTime,",",2),3)
				}
				else
				{
					s deathDate = ""
				}
			}
			else
			{
				s deathDate = $zd($p(deathDateTime,",",1),3)_" "_$zt($p(deathDateTime,",",2),3)
			}
		}
		/*
		s deathDate2 = ##Class(EPRservice.BOScatterData).GetEPRData(objMREpisode.episodeID,"EMR10 住院病程记录.EMR100014 死亡记录.入院时情况.入院时情况.死亡日期#TYPE:Simple#TID:38#TVER:0#SCODE:D0010#VTYPE:YMD")
		if (deathDate = "")&&(deathDate2'="") {s deathDate =  deathDate2}
		s deathDate3 = ##Class(EPRservice.BOScatterData).GetEPRData(objMREpisode.episodeID,"EMR09 住院志.EMR090003 24小时内入院死亡记录.24小时内入院死亡记录.入院情况.入院情况.死亡日期#TYPE:Simple#TID:54#TVER:0#SCODE:D0010#VTYPE:YMD")
		if (deathDate = "")&&(deathDate3'="") {s deathDate =  deathDate3}
		*/
	}
	if (deathDate '= "") {
		s deathFlag = "Y"
	}
	else {
		s deathFlag = "N"
	}
	d objMREpisode.%Close() 
	
	s scanData = ##class(DHCEPRFS.BL.BLMRLog).GetScanData(mrEpisodeID)
	s scanUserName = $p(scanData,"^",1)
	s scanDate = $p(scanData,"^",2)
	s scanTime = $p(scanData,"^",3)
	s scanDateTime = ""
	if (scanDate '= "")&&(scanTime '= "") {
		s scanDateTime = scanDate_" "_scanTime
	}
	s lastStatus = ##Class(DHCEPRFS.BL.BLMRLog).GetLastStatus(mrEpisodeID)
	s isPrinted = ##class(DHCEPRFS.BL.BLMRLog).IsPrinted(mrEpisodeID)
	if (isPrinted = "1") {
		s isPrinted = "已"
	}
	else {
		s isPrinted = "未"
	}
	
	s data = $lb(admTypeCode,admType,mrPatientID,mrEpisodeID,medRecordNo,patName,patBirthday,patAge,patSex,admitDate,dischDate,admLoc,disLoc,admWard,disWard,deathDate,deathFlag,scanUserName,scanDateTime,lastStatus,isPrinted)
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1
	Quit $$$OK
}

ClassMethod GetPatInfoUserControlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatInfoUserControlExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
		kill ^CacheTemp(repid)
	}
	Else      {				// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetPatInfoUserControlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatInfoUserControlExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
