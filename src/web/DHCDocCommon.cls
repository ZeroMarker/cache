/// Creator:      郭荣勇
/// CreatDate:    2011-01-13
/// Description:: 医生站公共业务方法类      
/// Others:
Class web.DHCDocCommon Extends (DHCDoc.Util.RegisteredObject, %XML.Adaptor) [ Inheritance = right, Not ProcedureBlock ]
{

/// creator:郭荣勇
/// date:2015-11-18
/// desc:通过年龄描述得到出生日期
/// input:Age 年龄描述, Type 类型:默认为空,为空即如果只有"岁"则计算的月和日和当前的月和日相同
/// output:年龄描述(eg:1岁 或 2月 或 3天)
/// other:
/// debug:w ##class(web.DHCDocCommon).GetBirthDateByAge("22天","")
ClassMethod GetBirthDateByAge(Age As %String, Type As %String = "") As %String
{
	n (Age,Type)
	s BirthDate=""
	q:Age="" ""
	;兼容只填了数字,没有单位的情况
	i +Age=Age s Age=+Age_"岁"
	
	s CurDate=$zd($h,3)
	s CurYear=$P(CurDate,"-",1)
	s CurMonth=$P(CurDate,"-",2)
	s CurDay=$P(CurDate,"-",3)
	s Year="",Month="",Day=""
	i Age["岁" {
		s Year=$p(Age,"岁",1)
		s Year=CurYear-Year
	}
	i Age["月" {
		i Year="" {
			s Month=$p(Age,"月",1)
			s Year=CurYear
		}else{
			s Month=$p($p(Age,"岁",2),"月",1)
		}
		s Month=CurMonth-Month
		i Month<=0{
			s Year=Year-1
			s Month=Month+12
		}
	}
	i Age["天" {
		i Month="" {
			s Day=$p(Age,"天",1) 
			s Day=$h-Day
			s Day=$zd(Day,3)
			s Year=$P(Day,"-",1)
			s Month=$P(Day,"-",2)
			s Day=$P(Day,"-",3)
		}else{
			
			s Day=$p($p(Age,"月",2),"天",1)
			s Day=CurDay-Day
			i Day<=0{
				s Month=Month-1
				i Month=0{
					s Year=Year-1
					s Month=12
					s Day=Day+31
				}else{
					s Day=Day+($zd($zdh(Year_"-"_(Month+1)_"-01",3),14)-$zd($zdh(Year_"-"_Month_"-01",3),14))
					b ;10
				}
			}
		}
	}
	
	
	i Type="" {
		i Year="" s Year=CurYear
		i Year'="",Month="" s Month=CurMonth
		i Month'="",Day="" s Day=CurDay
		i $l(Month)=1 s Month="0"_Month
		i $l(Day)=1  s Day="0"_Day
		//如果得到的是02-29号,则判断所在年份是否是闰年,如果是平年,则取2月28号
		if ((Month="02")&&(Day="29")){
			if (Year#4=0){
				if (Year#100=0){
					if (Year#400=0){
						s leaf=1
					}else{
						s leaf=0
					}
				}else{
				  s leaf=1
				}
			}else{
				s leaf=0
			}
			if (leaf=0) {
				s Day="28"
			}
		}
		if (",04,06,09,11,"[Month)&&(Day="31") s Day="30"
		s sysDateFormat=##class(websys.Conversions).DateFormat()
		if (sysDateFormat="3"){
			s BirthDate=Year_"-"_Month_"-"_Day
		}
		if (sysDateFormat="4"){
			s BirthDate=Day_"/"_Month_"/"_Year
		}
		
	}
	
	
	Q BirthDate
}

/// creator:郭荣勇
/// date:2011-01-13
/// desc:得到年龄描述
/// input:PatientNo 登记号
/// output:年龄描述(eg:1年 或 2月 或 3天)
/// other:
/// debug:w ##class(web.DHCDTHealthCommon).GetAgeDesc("2010-04-01","")
ClassMethod GetAgeDesc(DOB As %String, CalDate As %String) As %String
{
	Q ##class(web.DHCDTHealthCommon).GetAgeDesc(DOB,CalDate)
	
	q:DOB="" ""
	i DOB["/" s DOB=$zdh(DOB,4)
	i DOB["-" s DOB=$zdh(DOB,3)
	i CalDate["/" s CalDate=$zdh(CalDate,4)
	i CalDate["-" s CalDate=$zdh(CalDate,3)
	i CalDate="" s CalDate=..%SysDate()
	s Age=$$CalAge^at182(DOB,CalDate,"","","")
	s AgeYear=$P(Age,"|",12)
	s AgeMonth=$P(Age,"|",13)
	s AgeDay=$P(Age,"|",14)
	s AgeDesc=..FormatAge(AgeYear,AgeMonth,AgeDay)
	Q AgeDesc
}

ClassMethod FormatAge(AgeYear As %String, AgeMonth As %String, AgeDay As %String) As %String
{
	if AgeYear>0 s AgeDesc=AgeYear_"岁"
	else  d
	.if AgeMonth>0 s AgeDesc=AgeMonth_"月"
	.else  s AgeDesc=AgeDay_"天"
	Q AgeDesc
}

/// Creator:      郭荣勇
/// CreatDate:    2010.12.01
/// Description:: 得到病人年龄
/// Table;        PA_Person
/// Input:        PatientID 病人Rowid
/// Return:       病人年龄 数字类型
/// Others:
/// Debug:		w ##class(web.DHCDocCommon).GetPatAge(1)
ClassMethod GetPatAge(PatientID As %String) As %String
{
	n (PatientID,%session)
	s myAge=""
	s:PatientID'="" myAge=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.reg.GetPapmiAge",PatientID,"")
	Q myAge
}

/// Creator:      郭荣勇
/// CreatDate:    2010.12.01
/// Description:: 得到登记号对应的所有卡,通过类型控制,是否显示最后一次或者全部(以,分开)
/// Table;        DHC_CardRef
/// Input:        Type:显示类型(最后一次:LAST,全部:ALL),PatientNO:登记号,PatientID:病人rowid,EpisodeID:就诊rowid
/// Return:       卡号||全部卡号及类型||""
/// Others:
/// Debug:		w ##class(web.DHCDocCommon).GetCardNoByPAPER("LAST","00000629")
ClassMethod GetCardNoByPAPER(Type As %String, PatientNO As %String = "", PatientID As %String = "", EpisodeID As %String = "") As %String
{
	////n (Type,PatientNO,PatientID,EpisodeID)
	s myCardNo=""
	
	if PatientID'="" {
		s PAPMIRowid=PatientID
	}elseif PatientNO'="" {
		s PAPMIRowid=$O(^PAPERi("PAPMI_PatNo",PatientNO,0))
	}elseif EpisodeID'="" {
		s PAPMIRowid=$p($g(^PAADM(EpisodeID)),"^",1)
	}
	Q:Type="" myCardNo
	Q:PAPMIRowid="" myCardNo
	s CFRowid=""
	for {
		s CFRowid=$O(^DHCCARDi("CF",0,"PAPMIDR",PAPMIRowid,CFRowid),-1)
		Q:CFRowid=""
		s ActiveFlag=$p($g(^DHCCARD("CF",CFRowid)),"^",10)
		if ActiveFlag'="N" continue
		s CardType=""
		s CardTypeDr=$p($g(^DHCCARD("CF",CFRowid)),"^",16)
		i CardTypeDr'="" s CardType=$p(^DHCCARDTYPEDef(CardTypeDr),"^",2)
		if CFRowid'="" {
			s CardNo=$p($g(^DHCCARD("CF",CFRowid)),"^",2)
			if $ZCVT(Type,"U")="LAST" {
				s myCardNo=CardNo 
				quit
			}elseif ($ZCVT(Type,"U")="ALL")  {
				if myCardNo="" s myCardNo=CardType_":"_CardNo
				else  s myCardNo=myCardNo_","_CardType_":"_CardNo
			}
		}
	}
	
	Q myCardNo
}

/// creator:郭荣勇
/// date:2011-01-13
/// desc:格式化登记号
/// input:PatientNo 登记号
/// output:格式化后的登记号
/// other:
/// debug:w ##class(web.DHCDTHealthCommon).FormatPatientNo("12")
ClassMethod FormatPatientNo(PatientNo As %String) As %String
{
	n (PatientNo)
	s PatientNoRet=""
	Q:$Number(PatientNo)="" ""
	s PatientNoLen=+..GetPatientNoLen()
	
	if $l(PatientNo)>PatientNoLen {
		s PatientNoRet=$e(PatientNo,1,PatientNoLen)
	}else{
		s PatientNoRet=$e("0000000000000000000",1,PatientNoLen-$l(PatientNo))_PatientNo
	}
	
	Q PatientNoRet
}

/// creator:郭荣勇
/// date:2011-01-13
/// desc:得到登记号系统设置长度
/// input:
/// output:登记号系统设置长度
/// other:
/// debug:w ##class(web.DHCDTHealthCommon).GetPatientNoLen()
ClassMethod GetPatientNoLen() As %String
{
	s PatientNoLen=+$p(^CF("PATCF",1,3),"^",5)
	
	Q PatientNoLen
}

/// Creator:      郭荣勇
/// CreatDate:    2010.12.01
/// Description:: 得到卡号根据登记号和卡类型
/// Table;        DHC_CardRef
/// Input:        CardTypeRowid:卡类型rowid,PatientNO:登记号,PatientID:病人rowid,EpisodeID:就诊rowid
/// Return:       卡号||""
/// Others:
/// Debug:		w ##class(web.DHCDocCommon).GetCardNo(1,"0000000001")
ClassMethod GetCardNo(CardTypeRowid As %String, PatientNO As %String = "", PatientID As %String = "", EpisodeID As %String = "") As %String
{
	n (CardTypeRowid,PatientNO,PatientID,EpisodeID)
	s myCardNo=""
	
	if PatientID'="" {
		s PAPMIRowid=PatientID
	}elseif PatientNO'="" {
		s PAPMIRowid=$O(^PAPERi("PAPMI_PatNo",PatientNO,0))
	}elseif EpisodeID'="" {
		s PAPMIRowid=$p($g(^PAADM(EpisodeID)),"^",1)
	}
	Q:CardTypeRowid="" myCardNo
	Q:PAPMIRowid="" myCardNo
	s CFRowid=0
	s CFRowid=$O(^DHCCARDi("CF",0,"TypePAPMINO",CardTypeRowid,PAPMIRowid,CFRowid))
	if CFRowid'="" {
		s myCardNo=$p($g(^DHCCARD("CF",CFRowid)),"^",2)
	}
	
	Q myCardNo
}

/// Creator:      郭荣勇
/// CreatDate:    2010.12.01
/// Description:: 得到病人信息表字段信息
/// Table;        PA_Person
/// Input:        PatientID:病人rowid,PropertieName 字段名称,TransferFlag 是否转换,TransferName 转换表字段名
/// Return:       不转换/转换的字段值
/// Others:
/// Debug:		w ##class(web.DHCDocCommon).GetPATPropert(1,"PAPERName","")
ClassMethod GetPATPropert(PatientID As %String, PropertieName As %String, TransferFlag As %String = "Y", TransferName As %String = "") As %String
{
}

/// Creator:      郭荣勇
/// CreatDate:    2010.12.01
/// Description:: 得到就诊信息表字段信息
/// Table;        PA_Adm
/// Input:        EpisodeID:就诊rowid,PropertieName 字段名称,TransferFlag 是否转换  ,TransferName 转换表字段名
/// Return:       不转换/转换的字段值
/// Others:
/// Debug:		w ##class(web.DHCDocCommon).GetADMPropert(1,"PAADMType","")
ClassMethod GetADMPropert(EpisodeID As %String, PropertieName As %String, TransferFlag As %String = "Y", TransferName As %String = "") As %String
{
}

/// Creator:      郭荣勇
/// CreatDate:    2010.12.01
/// Description:: 得到医嘱信息表字段信息
/// Table;        OE_OrdItem
/// Input:        OEORIRowid:医嘱rowid,PropertieName 字段名称,TransferFlag 是否转换 ,TransferName 转换表字段名
/// Return:       不转换/转换的字段值
/// Others:
/// Debug:		w ##class(web.DHCDocCommon).GetOEORIPropert(1,"OEORIBilled","")
ClassMethod GetOEORIPropert(OEORIRowid As %String, PropertieName As %String, TransferFlag As %String = "Y", TransferName As %String = "") As %String
{
}

/// Creator:      郭荣勇
/// CreatDate:    2010.12.01
/// Description:: 格式化性别
/// Table;        CT_Sex
/// Input:        SEXRowid:性别rowid
/// Return:       格式化性别值
/// Others:
/// Debug:		w ##class(web.DHCDocCommon).FormatSex(1)
ClassMethod FormatSex(SEXRowid As %String) As %String
{
	n (SEXRowid)
}

/// Creator:      郭荣勇
/// CreatDate:    2010.12.01
/// Description:: 得到web配置的模板路径
/// Table;        websys.configuration
/// Input:        SEXRowid:性别rowid
/// Return:       web配置的模板路径
/// Others:
/// Debug:		w ##class(web.DHCDocCommon).GetPath()
ClassMethod GetPath()
{
	n (Path)
	Set Path=""
	Set Config=##Class(websys.Configuration).%OpenId(1)
	if $IsObject(Config) {
		Set Path=Config.PathToReports
		d Config.%Close()
	}

	Q Path
}

///  Creator:      郭荣勇
///  CreatDate:    2015.03.12
///  Description:: 根据科室RowId得到科室所归属的医院
///  Table:        
///  Input:        
///  Return:       
///  Others:
///  Debug:  d ##class(web.DHCDocCommon).GetHospIdByLocId(2)
ClassMethod GetHospIdByLocId(LocId As %String) As %String
{
	Q:(LocId="") ""
	s HospId=$p(^CTLOC(LocId),"^",22)
	
	Q HospId
}

/// Creator:      郭荣勇
/// CreatDate:    2010.12.01
/// Description:: 得到代码表下设置的医院代码
/// Table;        CT_Hospital
/// Input:        HospRowid 医院Rowid
/// Return:       代码表下设置的医院代码
/// Others:
/// Debug:		w ##class(web.DHCDocCommon).GetCTHospitalCode(1)
ClassMethod GetCTHospitalCode(HospRowid As %String = "") As %String
{
	s HospitalCode=""
	if (HospRowid'=""){
		s HospitalCode=$p($g(^CT("HOSP",HospRowid)),"^",1)
	}else{
		s HospRowid=$O(^CT("HOSP",0))
		i HospRowid'="" s HospitalCode=$p($g(^CT("HOSP",HospRowid)),"^",1)
	}

	Q $g(HospitalCode)
}

/// Creator:      周志强
/// CreatDate:    2009.03.20
/// Description:: 得到医生站设置里当前医院的代码
/// Table:        
/// Input:        
/// Return:       医生站设置医院的代码
/// Others:
ClassMethod GetDocHospitalCode() As %String
{
	s HospitalCode=""
	s Hospital=..%GetConfig("CurrentHospital")
	i Hospital'="" s HospitalCode=$P(Hospital,"^",1)
	Q HospitalCode
}

///  Creator:      郭荣勇
///  CreatDate:    2011.01.14
///  Description:: 通过就诊得到医嘱主表Rowid
///  Table:        PA_Adm,OE_Order
///  Input:        
///  Return:       医嘱主表Rowid
///  Others:
///  Creator:      郭荣勇
///  CreatDate:    2011.01.14
///  Description:: 通过用户Rowid得到对应医生Rowid
///  Table:        SS_User,CT_CareProv
///  Input:        
///  Return:       医生Rowid
///  Others:
///  Creator:      郭荣勇
///  CreatDate:    2011.01.14
///  Description:: 设置时间日志
///  Table:        
///  Input:        
///  Return:       
///  Others:
///  Debug:  d ##class(web.DHCDocCommon).SetTimeLog("大通保存时间","1")
ClassMethod SetTimeLog(Flag As %String, UniqueID As %String) As %String
{
	Q:(Flag="")||(UniqueID="") 0
	s ^DHCDocTimeLog(Flag,UniqueID)=$zd(+$H,3)_"	"_..%ZT(..%SysTime(),1)
	s ^DHCDocTimeLog(Flag,0,+$H,UniqueID)=""
	
	Q 0
}

/// Creator:      周志强
/// CreatDate:    2012.12.29
/// Description:: 判断是否为实习医生
/// Table;        CT_CareProv
/// Input:        UserID :用户指针
/// Return:       1:是   0:否
/// Others:
/// Debug:		  w ##class(web.DHCDocCommon).IsPracticeDoctor(3907)
ClassMethod IsPracticeDoctor(UserID As %String = "") As %String
{
	s CTPCPRowId=$P($G(^SSU("SSUSR",UserID)),"^",14)
	s CarPrvTypeCode=""
	i CTPCPRowId'="" {
		s CarPrvTypeRowId=$P($g(^CTPCP(CTPCPRowId,1)),"^",4)
		s CarPrvTypeCode=$P($g(^CT("CPT",CarPrvTypeRowId)),"^",1)
	}
	i CarPrvTypeCode="PRACTICE" Quit 1
	Q 0
}

/// 获取科室描述/Code
ClassMethod GetCTLOCDesc(CTLOCID As %String) As %String
{
	s CTLOCCode=""
	s CTLOCDesc=""
	i CTLOCID'=""  d
	.s CTLOCCode=$P(^CTLOC(CTLOCID),"^",1)
	.s CTLOCDesc=$P(^CTLOC(CTLOCID),"^",2)
	Q CTLOCDesc_"^"_CTLOCCode
}

/// creater lxz
/// 获取年龄调用计费组方法
/// s PAPMIAge=##class(web.DHCBillInterface).GetPapmiAge(PatientID,PAAdm)
/// 如果建卡之前获取没有患者索引使用出生日期和日期来计算
/// 入参YYYY-MM-DD
/// w ##class(web.DHCDocCommon).GetAgeDescNew("2014-01-04","")
ClassMethod GetAgeDescNew(DOB As %String, CalDate As %String, HospID As %String = "") As %String
{
	s $ZT="ErrorDate"
	s HospID=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	if (DOB'=""){
		i DOB["-" s DOBTest=$ZDH(DOB,3)
		i DOB["/" s DOBTest=$ZDH(DOB,4)
		s DOB=$zd(DOBTest,3)
	}
	s:CalDate'="" CalDateTest=$ZDH(CalDate,3)
	s:CalDate="" CalDate=$ZD(+$H,3)
	s AgeStr=##class(web.UDHCJFCOMMON).DispPatAge(DOB,CalDate,"","",HospID)
	s Age=$P(AgeStr,"||",1)
	q Age
ErrorDate
	q ""
}

/// 根据身份证号获取省、市、区对应的id及Desc
ClassMethod GetAddrInfoByCredNo(CredNo As %String) As %String
{
	n (CredNo)
	q:(CredNo="") ""
	q:($l(CredNo)'="15")&&($l(CredNo)'="18") ""
	s ProvCode=$e(CredNo,1,2)_"0000"
	s CityCode=$e(CredNo,1,4)_"00"
	s AreaCode=$e(CredNo,1,6)
	s ProvId="", CityId="", AreaId="", ProvDesc="", CityDesc="", AreaDesc=""
	
	if $d(^CT("PROV",0,"Code",$$ALPHAUP^SSUTIL4(ProvCode))) {
		s ProvId=$o(^CT("PROV",0,"Code",$$ALPHAUP^SSUTIL4(ProvCode),""))
		s ProvDesc=$p(^CT("PROV",ProvId),"^",2)
	}
	if $d(^CT("CIT",0,"Code",$$ALPHAUP^SSUTIL4(CityCode))) {
		s CityId=$o(^CT("CIT",0,"Code",$$ALPHAUP^SSUTIL4(CityCode),""))
		s CityDesc=$p(^CT("CIT",CityId),"^",2)
	}
	if $d(^CT("CITAREA",0,"Code",$$ALPHAUP^SSUTIL4(AreaCode))) {
		s AreaId=$o(^CT("CITAREA",0,"Code",$$ALPHAUP^SSUTIL4(AreaCode),""))
		s AreaDesc=$p(^CT("CITAREA",AreaId),"^",2)
	}
	q ProvId_"^"_ProvDesc_"!"_CityId_"^"_CityDesc_"!"_AreaId_"^"_AreaDesc
}

/// 获取两个日期之间的间隔天数
ClassMethod GetDaysBetween(FromDate As %String, ToDate As %String = "") As %String
{
	n (FromDate, ToDate)
	q:FromDate="" ""
	i FromDate["-" s FromDate=$ZDH(FromDate,3)
	i ToDate["/" s ToDate=$ZDH(ToDate,4)
	if ToDate="" s ToDate=..%SysDate()
	q ToDate-FromDate
}

/// 判断科室是否在有效范围内
/// Return:       1:是   0:否
/// w ##class(web.DHCDocCommon).CheckLocIsValid(1)
ClassMethod CheckLocIsValid(CTLOCRowID As %String = "") As %String
{
	n (CTLOCRowID)
	q:CTLOCRowID="" 0
	s CTActive=$p($g(^CTLOC(CTLOCRowID)),"^",14)
	q:CTActive'="Y" 0
	s CTLOCDateActiveFrom=$p($G(^CTLOC(CTLOCRowID)),"^",24)
	s CTLOCDateActiveTo=$p($G(^CTLOC(CTLOCRowID)),"^",25)
	i +CTLOCDateActiveTo=0 s CTLOCDateActiveTo=+$H+30
	q:((CTLOCDateActiveFrom<+$H)&&(CTLOCDateActiveTo>+$H)) 1
	q 0
}

}
