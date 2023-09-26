/// Function: HOS人员基本信息表
/// CreateDate:2022-11-10
/// Creator:gaoshanshan
Class web.DHCBL.CT.HOSPerson Extends %RegisteredObject [ ProcedureBlock ]
{

/// Function：  人员基本信息查询
/// Creator:    gaoshanshan
/// CreatDate:  2022-11-10
/// Table：     CT_BDP_CT.HOS_Person   
/// Other:      d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSPerson","GetList","","","","")
Query GetList(rowid As %String, code As %String, desc As %String, status As %String) As %Query(ROWSPEC = "ID,PAPersonID,EMPPAPersonNo,PAName,PAFormerName,PAGenderDesc,PABirthDate,PABirthTime,PANationalityDesc,PALanguageDesc1,PALanguageDesc2,PAIdentityID,PAIdentityTypeDesc,PANationDesc,PAEducationDesc,PADegreeDesc,PAOccupationDesc,PAMarriedDesc,PAReligionDesc,PANPCountryDesc,PANPPROVDesc,PANPCITYDesc,PANPDISTRDesc,PAAddrCountryDesc,PAAddrPROVDesc,PAAddrCITYDesc,PAAddrDISTRDesc,PAAddress,PAMobile,PAEmail,PAPersonStatusDesc,PAActivity,PAStartDate,PAEndDate,PASeqNo,PAPYCode,PAWBCode,PAMark")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, status As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    if (rowid'="") //根据rowid返回该条记录
    { 
        s ID=rowid
        s PAPersonID =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),2) /// 唯一标识码
        s PAName =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),3) /// 姓名
        s EmployeeId=$o(^CT.BDP.CT.HOSORGEmployeeI("IndexPAPersonID",ID,""))
        s:EmployeeId'="" EMPPAPersonNo =$listget($g(^CT.BDP.CT.HOSORGEmployeeD(EmployeeId)),4) /// 工号
        s:EmployeeId="" EMPPAPersonNo=""
        s PAFormerName =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),4) /// 曾用名
        s PAGenderDesc="",PANationalityDesc="",PALanguageDesc1="",PALanguageDesc2="",PAIdentityTypeDesc="",PANationDesc="",PAEducationDesc="",PADegreeDesc="",PAOccupationDesc="",PAMarriedDesc="",PAReligionDesc=""
        s PAGenderCode =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),5) /// 性别代码-外键
        s:PAGenderCode'="" PAGenderDesc=$p($g(^CT("SEX",PAGenderCode)),"^",2)
        s PABirthDate =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),6) /// 出生日期
		s:PABirthDate'="" PABirthDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(PABirthDate)
        s PABirthTime =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),7) /// 出生时间
        s PANationalityCode =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),8) /// 国籍-外键
        s:PANationalityCode'="" PANationalityDesc=$p($g(^CT("COU",PANationalityCode)),"^",2)
        s PALanguageCode1 =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),9) /// 第一语言-外键
        s:PALanguageCode1'="" PALanguageDesc1=$p($g(^SS("LAN",PALanguageCode1)),"^",2)
        s PALanguageCode2 =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),10) /// 第二语言-外键
        s:PALanguageCode2'="" PALanguageDesc2=$p($g(^SS("LAN",PALanguageCode2)),"^",2)
        s PAIdentityID =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),11) /// 身份证号
        s PAIdentityType =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),12) /// 身份证件类型
        s:PAIdentityType'="" PAIdentityTypeDesc=$p($g(^PAC("CARD",PAIdentityType)),"^",2)
        s PANationCode =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),13) /// 民族代码-外键
        s:PANationCode'="" PANationDesc=$p($g(^CT("NAT",PANationCode)),"^",2)
        s PAEducationCode =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),14) /// 学历代码-外键
        s:PAEducationCode'="" PAEducationDesc=$p($g(^CT("EDU",PAEducationCode)),"^",2)
        s PADegreeCode =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),15) /// 学位代码-外键
        s:PADegreeCode'="" PADegreeDesc=$listget($g(^CT.BDP.CT.HOSDegreeD(ID)),3)
        s PAOccupationCode =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),16) /// 职业代码-外键
        s:PAOccupationCode'="" PAOccupationDesc=$p($g(^CT("OCC",PAOccupationCode)),"^",2)
        s PAMarriedCode =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),17) /// 婚姻状态-外键
        s:PAMarriedCode'="" PAMarriedDesc=$p($g(^CT("MAR",PAMarriedCode)),"^",2)
        s PAReligionCode =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),18) /// 宗教-外键
        s:PAReligionCode'="" PAReligionDesc=$p($g(^CT("RLG",PAReligionCode)),"^",2)
        s PANPCountryDesc="",PANPPROVDesc="",PANPCITYDesc="",PANPDISTRDesc="",PAAddrCountryDesc="",PAAddrPROVDesc="",PAAddrCITYDesc="",PAAddrDISTRDesc="",PAPersonStatusDesc=""
        s PANPCountryCode =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),19) /// 籍贯（国家）-外键
        s:PANPCountryCode'="" PANPCountryDesc=$p($g(^CT("COU",PANPCountryCode)),"^",2)
        s PANPPROVCode =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),20) /// 籍贯（省）-外键
        s:PANPPROVCode'="" PANPPROVDesc=$p($g(^CT("PROV",PANPPROVCode)),"^",2)
        s PANPCITYCode =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),21) /// 籍贯（市）-外键
        s:PANPCITYCode'="" PANPCITYDesc=$p($g(^CT("CIT",PANPCITYCode)),"^",2)
        s PANPDISTRCode =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),22) /// 籍贯（县区）-外键
        s:PANPDISTRCode'="" PANPDISTRDesc=$p($g(^CT("CITAREA",PANPDISTRCode)),"^",2)
        s PAAddrCountryCode =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),23) /// 现住址（国家）-外键
        s:PAAddrCountryCode'="" PAAddrCountryDesc=$p($g(^CT("COU",PAAddrCountryCode)),"^",2)
        s PAAddrPROVCode =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),24) /// 现住址（省）-外键
        s:PAAddrPROVCode'="" PAAddrPROVDesc=$p($g(^CT("PROV",PAAddrPROVCode)),"^",2)
        s PAAddrCITYCode =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),25) /// 现住址（市）-外键
        s:PAAddrCITYCode'="" PAAddrCITYDesc=$p($g(^CT("CIT",PAAddrCITYCode)),"^",2)
        s PAAddrDISTRCode =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),26) /// 现住址（县区）-外键
        s:PAAddrDISTRCode'="" PAAddrDISTRDesc=$p($g(^CT("CITAREA",PAAddrDISTRCode)),"^",2)
        s PAAddress =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),27) /// 现住址（详细地址）	
        s PAPhoto =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),28) /// 照片
        s PAMobile =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),29) /// 手机号码	
        s PAEmail =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),30) /// 邮箱
        s PAPersonStatus =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),31) /// 状态 外键
        s:PAPersonStatus'="" PAPersonStatusDesc=$listget($g(^CT.BDP.CT.HOSPersonStatusDictD(PAPersonStatus)),3)
        s PAActivity =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),32) /// 是否有效(Y/N)
        s PAStartDate =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),33) /// 开始日期
        s:PAStartDate'="" PAStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(PAStartDate)
        s PAEndDate =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),34) /// 结束日期
        s:PAEndDate'="" PAEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(PAEndDate)
        s PASeqNo =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),38) /// 系统排序号
        s PAPYCode =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),42) /// 拼音码
        s PAWBCode =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),43) /// 五笔码
        s PAMark =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),44) /// 备注
           
        d OutputRow
    }
    else
    {  
    	s AuStr=##class(web.DHCBL.Authorize.HOSPerson).DHCGetDataByDefaultSession()
		s AuFlag=0
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1 
		
		s AuGenderStr=##class(web.DHCBL.Authorize.CTSex).DHCGetDataByDefaultSession() //性别
		s AuGenderFlag=0
		if (AuGenderStr="")||(AuGenderStr["limited:0") s AuGenderFlag=1 
		s AuCountryStr=##class(web.DHCBL.Authorize.CTCountry).DHCGetDataByDefaultSession() //国家
		s AuCountryFlag=0
		if (AuCountryStr="")||(AuCountryStr["limited:0") s AuCountryFlag=1 
		s AuLanguageStr=##class(web.DHCBL.Authorize.SSLanguage).DHCGetDataByDefaultSession() //语言
		s AuLanguageFlag=0
		if (AuLanguageStr="")||(AuLanguageStr["limited:0") s AuLanguageFlag=1 
		s AuCredTypeStr=##class(web.DHCBL.Authorize.DHCCredType).DHCGetDataByDefaultSession() //身份证件类型
		s AuCredTypeFlag=0
		if (AuCredTypeStr="")||(AuCredTypeStr["limited:0") s AuCredTypeFlag=1 
		s AuNationStr=##class(web.DHCBL.Authorize.CTNation).DHCGetDataByDefaultSession() //民族
		s AuNationFlag=0
		if (AuNationStr="")||(AuNationStr["limited:0") s AuNationFlag=1 
		s AuEducationStr=##class(web.DHCBL.Authorize.CTEducation).DHCGetDataByDefaultSession() //学历
		s AuEducationFlag=0
		if (AuEducationStr="")||(AuEducationStr["limited:0") s AuEducationFlag=1
		s AuDegreeStr=##class(web.DHCBL.Authorize.HOSDegree).DHCGetDataByDefaultSession() //学位
		s AuDegreeFlag=0
		if (AuDegreeStr="")||(AuDegreeStr["limited:0") s AuDegreeFlag=1
		s AuOccupationStr=##class(web.DHCBL.Authorize.CTOccupation).DHCGetDataByDefaultSession() //职业
		s AuOccupationFlag=0
		if (AuOccupationStr="")||(AuOccupationStr["limited:0") s AuOccupationFlag=1
		s AuMaritalStr=##class(web.DHCBL.Authorize.CTMarital).DHCGetDataByDefaultSession() //婚姻状态
		s AuMaritalFlag=0
		if (AuMaritalStr="")||(AuMaritalStr["limited:0") s AuMaritalFlag=1
		s AuReligionStr=##class(web.DHCBL.Authorize.CTReligion).DHCGetDataByDefaultSession() //宗教
		s AuReligionFlag=0
		if (AuReligionStr="")||(AuReligionStr["limited:0") s AuReligionFlag=1
		s AuProvinceStr=##class(web.DHCBL.Authorize.CTProvince).DHCGetDataByDefaultSession() //省
		s AuProvinceFlag=0
		if (AuProvinceStr="")||(AuProvinceStr["limited:0") s AuProvinceFlag=1
		s AuCityStr=##class(web.DHCBL.Authorize.CTCity).DHCGetDataByDefaultSession() //市
		s AuCityFlag=0
		if (AuCityStr="")||(AuCityStr["limited:0") s AuCityFlag=1
		s AuCityAreaStr=##class(web.DHCBL.Authorize.CTCityArea).DHCGetDataByDefaultSession() //县区
		s AuCityAreaFlag=0
		if (AuCityAreaStr="")||(AuCityAreaStr["limited:0") s AuCityAreaFlag=1
		s AuStatusStr="" //##class(web.DHCBL.Authorize.HOSPersonStatusDict).DHCGetDataByDefaultSession() //状态
		s AuStatusFlag=0
		if (AuStatusStr="")||(AuStatusStr["limited:0") s AuStatusFlag=1
		
    	s:code'="" code=$zcvt(code,"U")  
  		s:desc'="" desc=$zcvt(desc,"U")  
        s ID=0
        for 
        {
            s ID=$o(^CT.BDP.CT.HOSPersonD(ID))
            q:ID="" 
	        s PAPersonID =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),2) /// 唯一标识码
	        s PAName =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),3) /// 姓名
	        s EmployeeId=$o(^CT.BDP.CT.HOSORGEmployeeI("IndexPAPersonID",ID,""))
        	s:EmployeeId'="" EMPPAPersonNo =$listget($g(^CT.BDP.CT.HOSORGEmployeeD(EmployeeId)),4) /// 工号
        	s:EmployeeId="" EMPPAPersonNo=""
	        s PAFormerName =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),4) /// 曾用名
	        s PAGenderDesc="",PANationalityDesc="",PALanguageDesc1="",PALanguageDesc2="",PAIdentityTypeDesc="",PANationDesc="",PAEducationDesc="",PADegreeDesc="",PAOccupationDesc="",PAMarriedDesc="",PAReligionDesc=""
	        s PAGenderCode =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),5) /// 性别代码-外键
	        s:PAGenderCode'="" PAGenderDesc=$p($g(^CT("SEX",PAGenderCode)),"^",2)
	        s PABirthDate =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),6) /// 出生日期
			s:PABirthDate'="" PABirthDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(PABirthDate)
	        s PABirthTime =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),7) /// 出生时间
	        s PANationalityCode =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),8) /// 国籍-外键
	        s:PANationalityCode'="" PANationalityDesc=$p($g(^CT("COU",PANationalityCode)),"^",2)
	        s PALanguageCode1 =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),9) /// 第一语言-外键
	        s:PALanguageCode1'="" PALanguageDesc1=$p($g(^SS("LAN",PALanguageCode1)),"^",2)
	        s PALanguageCode2 =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),10) /// 第二语言-外键
	        s:PALanguageCode2'="" PALanguageDesc2=$p($g(^SS("LAN",PALanguageCode2)),"^",2)
	        s PAIdentityID =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),11) /// 身份证号
	        s PAIdentityType =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),12) /// 身份证件类型
	        s:PAIdentityType'="" PAIdentityTypeDesc=$p($g(^PAC("CARD",PAIdentityType)),"^",2)
	        s PANationCode =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),13) /// 民族代码-外键
	        s:PANationCode'="" PANationDesc=$p($g(^CT("NAT",PANationCode)),"^",2)
	        s PAEducationCode =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),14) /// 学历代码-外键
	        s:PAEducationCode'="" PAEducationDesc=$p($g(^CT("EDU",PAEducationCode)),"^",2)
	        s PADegreeCode =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),15) /// 学位代码-外键
	        s:PADegreeCode'="" PADegreeDesc=$listget($g(^CT.BDP.CT.HOSDegreeD(ID)),3)
	        s PAOccupationCode =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),16) /// 职业代码-外键
	        s:PAOccupationCode'="" PAOccupationDesc=$p($g(^CT("OCC",PAOccupationCode)),"^",2)
	        s PAMarriedCode =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),17) /// 婚姻状态-外键
	        s:PAMarriedCode'="" PAMarriedDesc=$p($g(^CT("MAR",PAMarriedCode)),"^",2)
	        s PAReligionCode =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),18) /// 宗教-外键
	        s:PAReligionCode'="" PAReligionDesc=$p($g(^CT("RLG",PAReligionCode)),"^",2)
	        s PANPCountryDesc="",PANPPROVDesc="",PANPCITYDesc="",PANPDISTRDesc="",PAAddrCountryDesc="",PAAddrPROVDesc="",PAAddrCITYDesc="",PAAddrDISTRDesc="",PAPersonStatusDesc=""
	        s PANPCountryCode =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),19) /// 籍贯（国家）-外键
	        s:PANPCountryCode'="" PANPCountryDesc=$p($g(^CT("COU",PANPCountryCode)),"^",2)
	        s PANPPROVCode =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),20) /// 籍贯（省）-外键
	        s:PANPPROVCode'="" PANPPROVDesc=$p($g(^CT("PROV",PANPPROVCode)),"^",2)
	        s PANPCITYCode =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),21) /// 籍贯（市）-外键
	        s:PANPCITYCode'="" PANPCITYDesc=$p($g(^CT("CIT",PANPCITYCode)),"^",2)
	        s PANPDISTRCode =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),22) /// 籍贯（县区）-外键
	        s:PANPDISTRCode'="" PANPDISTRDesc=$p($g(^CT("CITAREA",PANPDISTRCode)),"^",2)
	        s PAAddrCountryCode =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),23) /// 现住址（国家）-外键
	        s:PAAddrCountryCode'="" PAAddrCountryDesc=$p($g(^CT("COU",PAAddrCountryCode)),"^",2)
	        s PAAddrPROVCode =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),24) /// 现住址（省）-外键
	        s:PAAddrPROVCode'="" PAAddrPROVDesc=$p($g(^CT("PROV",PAAddrPROVCode)),"^",2)
	        s PAAddrCITYCode =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),25) /// 现住址（市）-外键
	        s:PAAddrCITYCode'="" PAAddrCITYDesc=$p($g(^CT("CIT",PAAddrCITYCode)),"^",2)
	        s PAAddrDISTRCode =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),26) /// 现住址（县区）-外键
	        s:PAAddrDISTRCode'="" PAAddrDISTRDesc=$p($g(^CT("CITAREA",PAAddrDISTRCode)),"^",2)
	        s PAAddress =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),27) /// 现住址（详细地址）	
	        s PAPhoto =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),28) /// 照片
	        s PAMobile =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),29) /// 手机号码	
	        s PAEmail =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),30) /// 邮箱
	        s PAPersonStatus =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),31) /// 状态 外键
	        s:PAPersonStatus'="" PAPersonStatusDesc=$listget($g(^CT.BDP.CT.HOSPersonStatusDictD(PAPersonStatus)),3)
	        s PAActivity =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),32) /// 是否有效(Y/N)
	        s PAStartDate =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),33) /// 开始日期
	        s:PAStartDate'="" PAStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(PAStartDate)
	        s PAEndDate =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),34) /// 结束日期
	        s:PAEndDate'="" PAEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(PAEndDate)
	        s PASeqNo =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),38) /// 系统排序号
	        s PAPYCode =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),42) /// 拼音码
	        s PAWBCode =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),43) /// 五笔码
	        s PAMark =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),44) /// 备注
	        
			s strRowId = "{ID:"_ID_"}"
			s strGenderRowId = "{ID:"_PAGenderCode_"}" //性别
			s strNationalityRowId = "{ID:"_PANationalityCode_"}" //国籍
			s strLanguage1RowId = "{ID:"_PALanguageCode1_"}" //第一语言
			s strLanguage2RowId = "{ID:"_PALanguageCode2_"}" //第二语言
			s strIdentityTypeRowId = "{ID:"_PAIdentityType_"}" //身份证件类型
			s strNationRowId = "{ID:"_PANationCode_"}" //民族
			s strEducationRowId = "{ID:"_PAEducationCode_"}" //学历
			s strDegreeRowId = "{ID:"_PADegreeCode_"}" //学位
			s strOccupationRowId = "{ID:"_PAOccupationCode_"}" //职业
			s strMarriedRowId = "{ID:"_PAMarriedCode_"}" //婚姻状态
			s strReligionRowId = "{ID:"_PAReligionCode_"}" //宗教
			s strNPCountryRowId = "{ID:"_PANPCountryCode_"}" //籍贯(国家)
			s strNPPROVRowId = "{ID:"_PANPPROVCode_"}" //籍贯(省)
			s strNPCITYRowId = "{ID:"_PANPCITYCode_"}" //籍贯(市)
			s strNPDISTRRowId = "{ID:"_PANPDISTRCode_"}" //籍贯(县区)
			s strAddrCountryRowId = "{ID:"_PAAddrCountryCode_"}" //现住址(国家)
			s strAddrPROVRowId = "{ID:"_PAAddrPROVCode_"}" //现住址(省)
			s strAddrCITYRowId = "{ID:"_PAAddrCITYCode_"}" //现住址(石)
			s strAddrDISTRRowId = "{ID:"_PAAddrDISTRCode_"}" //现住址(县区)
			s strStatusRowId = "{ID:"_PAPersonStatus_"}" //状态
			if ((AuStr[strRowId)||(AuFlag=1))&&((AuGenderStr[strGenderRowId)||(AuGenderFlag=1))&&((AuCountryStr[strNationalityRowId)||(AuCountryFlag=1))&&((AuLanguageStr[strLanguage1RowId)||(AuLanguageFlag=1))&&((AuLanguageStr[strLanguage2RowId)||(AuLanguageFlag=1))&&((AuCredTypeStr[strIdentityTypeRowId)||(AuCredTypeFlag=1))
			&&((AuNationStr[strNationRowId)||(AuNationFlag=1))&&((AuEducationStr[strEducationRowId)||(AuEducationFlag=1))&&((AuDegreeStr[strDegreeRowId)||(AuDegreeFlag=1))&&((AuOccupationStr[strOccupationRowId)||(AuOccupationFlag=1))&&((AuMaritalStr[strMarriedRowId)||(AuMaritalFlag=1))
			&&((AuReligionStr[strReligionRowId)||(AuReligionFlag=1))&&((AuCountryStr[strNPCountryRowId)||(AuCountryFlag=1))&&((AuProvinceStr[strNPPROVRowId)||(AuProvinceFlag=1))&&((AuCityStr[strNPCITYRowId)||(AuCityFlag=1))&&((AuCityAreaStr[strNPDISTRRowId)||(AuCityAreaFlag=1))
			&&((AuCountryStr[strAddrCountryRowId)||(AuCountryFlag=1))&&((AuProvinceStr[strAddrPROVRowId)||(AuProvinceFlag=1))&&((AuCityStr[strAddrCITYRowId)||(AuCityFlag=1))&&((AuCityAreaStr[strAddrDISTRRowId)||(AuCityAreaFlag=1))&&((AuStatusStr[strStatusRowId)||(AuStatusFlag=1)) //授权数据筛选
			{
	            if ($zcvt(PAPersonID,"U")[code)&(($zcvt(PAName,"U")[desc)||(($zcvt(PAPYCode,"U")[desc)))&((PAPersonStatus=status)||(status=""))
	            {
	                d OutputRow
	            }  
			}
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow  
    set Data=$lb(ID,PAPersonID,EMPPAPersonNo,PAName,PAFormerName,PAGenderDesc,PABirthDate,PABirthTime,PANationalityDesc,PALanguageDesc1,PALanguageDesc2,PAIdentityID,PAIdentityTypeDesc,PANationDesc,PAEducationDesc,PADegreeDesc,PAOccupationDesc,PAMarriedDesc,PAReligionDesc,PANPCountryDesc,PANPPROVDesc,PANPCITYDesc,PANPDISTRDesc,PAAddrCountryDesc,PAAddrPROVDesc,PAAddrCITYDesc,PAAddrDISTRDesc,PAAddress,PAMobile,PAEmail,PAPersonStatusDesc,PAActivity,PAStartDate,PAEndDate,PASeqNo,PAPYCode,PAWBCode,PAMark)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    
    Set ind=$o(^CacheTemp(repid,ind))
    If ind=""
    {
        //if there are no more rows,finish fetching...
        Set AtEnd=1
        Set Row=""
    }
    Else
    {
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

/// Function: combox查询提供接口 
/// Creator:  gaoshanshan
/// CreatDate:2022-11-10
/// Tables: CT_BDP_CT.HOS_Person
/// Input:  code,desc  
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSPerson", "GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID:%String,PAPersonID:%String,PAName:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
  Set repid=$I(^CacheTemp)
  s ind=1
  s:code'="" code=$zcvt(code,"U")  
  s:desc'="" desc=$zcvt(desc,"U")  
  if (rowid'="")  
  {
    s ID=rowid
    s PAPersonID =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),2) /// 唯一标识码
    s PAName =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),3) /// 姓名
    s PAName=PAName_"["_PAPersonID_"]"
    d OutputRowCmb
  }
  else
  {
    s ID=0
    for 
    {
       s ID=$o(^CT.BDP.CT.HOSPersonD(ID))
       q:ID="" 
       s PAActivity =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),32) /// 是否有效(Y/N)
       continue:(PAActivity="N") 
       s PAStartDate =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),33) /// 开始日期
       continue:(PAStartDate'="")&&(PAStartDate>+$h)
       s PAEndDate =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),34) /// 结束日期 
       continue:(PAEndDate'="")&&(PAEndDate<+$h)
       s PAPersonID =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),2) /// 唯一标识码
       s PAName =$listget($g(^CT.BDP.CT.HOSPersonD(ID)),3) /// 姓名
       s PAName=PAName_"["_PAPersonID_"]"
      
       if ($zcvt(PAPersonID,"U")[code)&($zcvt(PAName,"U")[desc)
       {
         d OutputRowCmb
       }
    }
  } 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb
 set Data=$lb(ID,PAPersonID,PAName)
  Set ^CacheTemp(repid,ind)=Data
  Set ind=ind+1
  q
}

ClassMethod GetDataForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
 Set repid=$LIST(qHandle,2)
  Kill ^CacheTemp(repid)  
  Quit $$$OK
}

ClassMethod GetDataForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
 
  Set AtEnd=$LIST(qHandle,1)
  Set repid=$LIST(qHandle,2)
  Set ind=$LIST(qHandle,3)
  Set ind=$o(^CacheTemp(repid,ind))
  If ind="" {    // if there are no more rows, finish fetching
   Set AtEnd=1
   Set Row=""
  }
  Else      {    // fetch row
   Set Row=^CacheTemp(repid,ind)
  }
  s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

/// Function： 修改时打开的数据
/// Creator:   gaoshanshan
/// CreatDate: 2022-11-10
/// Input：    id    
/// Other:     w ##class(web.DHCBL.CT.HOSPerson).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.CT.HOSPerson).%New()
    s obj = ##class(CT.BDP.CT.HOSPerson).%OpenId(id)
    s eobj.ID=id
    s eobj.PAPersonID=obj.PAPersonID 
    s eobj.PAName= obj.PAName   
    s eobj.PAFormerName = obj.PAFormerName 
    s:$IsObject(obj.PAGenderCode) eobj.PAGenderCode = obj.PAGenderCode.%Id()
    s eobj.PABirthDate = obj.PABirthDate 
    s:obj.PABirthDate'="" eobj.PABirthDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.PABirthDate) 
    s eobj.PABirthTime = obj.PABirthTime 
    s:obj.PABirthTime'="" eobj.PABirthTime= ##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(obj.PABirthTime) 
    s:$IsObject(obj.PANationalityCode) eobj.PANationalityCode = obj.PANationalityCode.%Id()
    s:$IsObject(obj.PALanguageCode1) eobj.PALanguageCode1 = obj.PALanguageCode1.%Id()
    s:$IsObject(obj.PALanguageCode2) eobj.PALanguageCode2 = obj.PALanguageCode2.%Id()
    s eobj.PAIdentityID = obj.PAIdentityID 
    s:$IsObject(obj.PAIdentityType) eobj.PAIdentityType = obj.PAIdentityType.%Id() 
    s:$IsObject(obj.PANationCode) eobj.PANationCode = obj.PANationCode.%Id() 
    s:$IsObject(obj.PAEducationCode) eobj.PAEducationCode = obj.PAEducationCode.%Id() 
    s:$IsObject(obj.PADegreeCode) eobj.PADegreeCode = obj.PADegreeCode.%Id() 
    s:$IsObject(obj.PAOccupationCode) eobj.PAOccupationCode = obj.PAOccupationCode.%Id() 
    s:$IsObject(obj.PAMarriedCode) eobj.PAMarriedCode = obj.PAMarriedCode.%Id() 
    s:$IsObject(obj.PAReligionCode) eobj.PAReligionCode = obj.PAReligionCode.%Id() 
    s:$IsObject(obj.PANPCountryCode) eobj.PANPCountryCode = obj.PANPCountryCode.%Id()
    s:$IsObject(obj.PANPPROVCode) eobj.PANPPROVCode = obj.PANPPROVCode.%Id() 
    s:$IsObject(obj.PANPCITYCode) eobj.PANPCITYCode = obj.PANPCITYCode.%Id() 
    s:$IsObject(obj.PANPDISTRCode) eobj.PANPDISTRCode = obj.PANPDISTRCode.%Id() 
    s:$IsObject(obj.PAAddrCountryCode) eobj.PAAddrCountryCode = obj.PAAddrCountryCode.%Id() 
    s:$IsObject(obj.PAAddrPROVCode) eobj.PAAddrPROVCode = obj.PAAddrPROVCode.%Id() 
    s:$IsObject(obj.PAAddrCITYCode) eobj.PAAddrCITYCode = obj.PAAddrCITYCode.%Id()
    s:$IsObject(obj.PAAddrDISTRCode) eobj.PAAddrDISTRCode = obj.PAAddrDISTRCode.%Id() 
    s eobj.PAAddress = obj.PAAddress 
    s eobj.PAPhoto = obj.PAPhoto 
    s eobj.PAMobile = obj.PAMobile 
    s eobj.PAEmail = obj.PAEmail 
    s:$IsObject(obj.PAPersonStatus) eobj.PAPersonStatus = obj.PAPersonStatus.%Id()
    s eobj.PAActivity = obj.PAActivity 
    s:obj.PAStartDate'="" eobj.PAStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.PAStartDate) 
    s:obj.PAEndDate'="" eobj.PAEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.PAEndDate) 
    s eobj.PASeqNo= obj.PASeqNo
    s eobj.PAPYCode= obj.PAPYCode
    s eobj.PAWBCode= obj.PAWBCode
    s eobj.PAMark= obj.PAMark
    s str = eobj.JsonS()    
    d eobj.%Close()
    d obj.%Close()
    q str
}

/// Function：数据重复验证方法 
/// Creator:  gaoshanshan
/// CreatDate:2022-11-10
/// Table：   CT.BDP.CT.HOSPerson
/// Input：   id-rowid, code-代码,desc-描述
/// Return：  "1"(数据重复),"0"(数据不重复)
/// Other:    d ##class(web.DHCBL.CT.HOSPerson).FormValidate("","")
ClassMethod FormValidate(id As %String, code As %String) As %String
{
    s flag=0
    if (code'=""){
	    s idc=$o(^CT.BDP.CT.HOSPersonI("IndexPersonID"," "_$zconvert(code,"U"),0)) 
		if ((id="")||((id'="")&&(idc'=id)))&&(idc>0) s flag=1  //返回重复标志
	}
    q flag
}

/// Function    保存内容
/// Creator:    gaoshanshan
/// CreatDate:  2022-11-10
/// Table：     CT.BDP.CT.HOSPerson
/// Input：     web.Entity.CT.HOSPerson  
/// Return：    成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other:      d ##class(web.DHCBL.CT.HOSPerson).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.HOSPerson) As %String
{
 
    s result="" 
    s:eobj.PAStartDate'="" eobj.PAStartDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.PAStartDate) 
    s:eobj.PAEndDate'="" eobj.PAEndDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.PAEndDate) 
    s:eobj.PAStartDate="" eobj.PAStartDate=+$h
    s:eobj.PABirthDate'="" eobj.PABirthDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.PABirthDate)
    s:eobj.PABirthTime'="" eobj.PABirthTime=##class(web.DHCBL.BDP.FunLib).TimeHtmlToLogical(eobj.PABirthTime) 
    
    s USERID=""
    s:$d(%session) USERID=$g(%session.Data("LOGON.USERID")) 
    s eobj.PALastUpdateDate=+$h  ///系统最后更新日期
    s eobj.PALastUpdateTime=$p($h,",",2)  ///系统最后更新时间
    if (eobj.PALastUpdateUser="") s eobj.PALastUpdateUser=USERID  ///系统最新更新人
    s:eobj.PAActivity="" eobj.PAActivity="N"		//是否有效
    
    s:eobj.PAPYCode="" eobj.PAPYCode=##class(web.DHCBL.BDP.FunLib).GetDBCCNCODE(eobj.PAName,4)
	s:eobj.PAWBCode="" eobj.PAWBCode=##class(web.DHCBL.BDP.FunLib).GetSWBCODE(eobj.PAName,1)
    
    s flag=  ..FormValidate(eobj.ID,eobj.PAPersonID)  //调用重复验证
    if (flag=1)
    {
        s result = "{success:'false',errorinfo:'该记录已经存在！'}"
    }
    else
    {
        if (eobj.ID="")  
        {
            s obj=##class(CT.BDP.CT.HOSPerson).%New()
            s eobj.PACreateDate=+$h  ///系统创建日期
            s eobj.PACreateTime=$p($h,",",2)  ///系统创建时间
            s:eobj.PACreateUser="" eobj.PACreateUser=USERID   ///系统创建人
            s obj.PACreateDate=eobj.PACreateDate
            s obj.PACreateTime=eobj.PACreateTime
            d obj.PACreateUserSetObjectId(eobj.PACreateUser)
        }
        else              
        {
            s obj=##class(CT.BDP.CT.HOSPerson).%OpenId(eobj.ID)
            s bobj=##class(web.Entity.CT.HOSPerson).%New()
            s bobj.ID=eobj.ID 
            s bobj.PAPersonID=obj.PAPersonID
            s bobj.PAName= obj.PAName  
           	s bobj.PAFormerName = obj.PAFormerName 
		    s:$IsObject(obj.PAGenderCode) bobj.PAGenderCode = obj.PAGenderCode.%Id()
		    s:obj.PABirthDate'="" bobj.PABirthDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.PABirthDate) 
		    s:obj.PABirthTime'="" bobj.PABirthTime= ##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(obj.PABirthTime) 
		    s:$IsObject(obj.PANationalityCode) bobj.PANationalityCode = obj.PANationalityCode.%Id()
		    s:$IsObject(obj.PALanguageCode1) bobj.PALanguageCode1 = obj.PALanguageCode1.%Id()
		    s:$IsObject(obj.PALanguageCode2) bobj.PALanguageCode2 = obj.PALanguageCode2.%Id()
		    s bobj.PAIdentityID = obj.PAIdentityID 
		    s:$IsObject(obj.PAIdentityType) bobj.PAIdentityType = obj.PAIdentityType.%Id() 
		    s:$IsObject(obj.PANationCode) bobj.PANationCode = obj.PANationCode.%Id() 
		    s:$IsObject(obj.PAEducationCode) bobj.PAEducationCode = obj.PAEducationCode.%Id() 
		    s:$IsObject(obj.PADegreeCode) bobj.PADegreeCode = obj.PADegreeCode.%Id() 
		    s:$IsObject(obj.PAOccupationCode) bobj.PAOccupationCode = obj.PAOccupationCode.%Id() 
		    s:$IsObject(obj.PAMarriedCode) bobj.PAMarriedCode = obj.PAMarriedCode.%Id() 
		    s:$IsObject(obj.PAReligionCode) bobj.PAReligionCode = obj.PAReligionCode.%Id() 
		    s:$IsObject(obj.PANPCountryCode) bobj.PANPCountryCode = obj.PANPCountryCode.%Id()
		    s:$IsObject(obj.PANPPROVCode) bobj.PANPPROVCode = obj.PANPPROVCode.%Id() 
		    s:$IsObject(obj.PANPCITYCode) bobj.PANPCITYCode = obj.PANPCITYCode.%Id() 
		    s:$IsObject(obj.PANPDISTRCode) bobj.PANPDISTRCode = obj.PANPDISTRCode.%Id() 
		    s:$IsObject(obj.PAAddrCountryCode) bobj.PAAddrCountryCode = obj.PAAddrCountryCode.%Id() 
		    s:$IsObject(obj.PAAddrPROVCode) bobj.PAAddrPROVCode = obj.PAAddrPROVCode.%Id() 
		    s:$IsObject(obj.PAAddrCITYCode) bobj.PAAddrCITYCode = obj.PAAddrCITYCode.%Id()
		    s:$IsObject(obj.PAAddrDISTRCode) bobj.PAAddrDISTRCode = obj.PAAddrDISTRCode.%Id() 
		    s bobj.PAAddress = obj.PAAddress 
		    s bobj.PAPhoto = obj.PAPhoto 
		    s bobj.PAMobile = obj.PAMobile 
		    s bobj.PAEmail = obj.PAEmail
		    s:$IsObject(obj.PAPersonStatus) bobj.PAPersonStatus = obj.PAPersonStatus.%Id() 
		    s bobj.PAActivity = obj.PAActivity 
		    s:obj.PAStartDate'="" bobj.PAStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.PAStartDate) 
		    s:obj.PAEndDate'="" bobj.PAEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.PAEndDate) 
		    s:obj.PACreateDate'="" bobj.PACreateDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.PACreateDate) 
		    s:obj.PACreateTime'="" bobj.PACreateTime= ##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(obj.PACreateTime) 
		    s:$IsObject(obj.PACreateUser) bobj.PACreateUser= obj.PACreateUser.%Id()
		    s bobj.PASeqNo= obj.PASeqNo
		    s:obj.PALastUpdateDate'="" bobj.PALastUpdateDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.PALastUpdateDate) 
		    s bobj.PALastUpdateTime= obj.PALastUpdateTime
		    s:$IsObject(obj.PALastUpdateUser) bobj.PALastUpdateUser= obj.PALastUpdateUser.%Id()
		    s bobj.PAPYCode= obj.PAPYCode
		    s bobj.PAWBCode= obj.PAWBCode
		    s bobj.PAMark= obj.PAMark
        }
        s obj.PAPersonID = eobj.PAPersonID 
        s obj.PAName=eobj.PAName   
        s obj.PAFormerName = eobj.PAFormerName 
	    d:eobj.PAGenderCode'="" obj.PAGenderCodeSetObjectId(eobj.PAGenderCode)
	    s obj.PABirthDate = eobj.PABirthDate 
	    s obj.PABirthTime = eobj.PABirthTime 
	    d:eobj.PANationalityCode'="" obj.PANationalityCodeSetObjectId(eobj.PANationalityCode)
	    d:eobj.PALanguageCode1'="" obj.PALanguageCode1SetObjectId(eobj.PALanguageCode1)
	    d:eobj.PALanguageCode2'="" obj.PALanguageCode2SetObjectId(eobj.PALanguageCode2)
	    s obj.PAIdentityID = eobj.PAIdentityID 
	    d:eobj.PAIdentityType'="" obj.PAIdentityTypeSetObjectId(eobj.PAIdentityType) 
	    d:eobj.PANationCode'="" obj.PANationCodeSetObjectId(eobj.PANationCode) 
	    d:eobj.PAEducationCode'="" obj.PAEducationCodeSetObjectId(eobj.PAEducationCode) 
	    d:eobj.PADegreeCode'="" obj.PADegreeCodeSetObjectId(eobj.PADegreeCode) 
	    d:eobj.PAOccupationCode'="" obj.PAOccupationCodeSetObjectId( eobj.PAOccupationCode) 
	    d:eobj.PAMarriedCode'="" obj.PAMarriedCodeSetObjectId( eobj.PAMarriedCode) 
	    d:eobj.PAReligionCode'="" obj.PAReligionCodeSetObjectId( eobj.PAReligionCode) 
	    d:eobj.PANPCountryCode'="" obj.PANPCountryCodeSetObjectId( eobj.PANPCountryCode)
	    d:eobj.PANPPROVCode'="" obj.PANPPROVCodeSetObjectId( eobj.PANPPROVCode) 
	    d:eobj.PANPCITYCode'="" obj.PANPCITYCodeSetObjectId( eobj.PANPCITYCode) 
	    d:eobj.PANPDISTRCode'="" obj.PANPDISTRCodeSetObjectId( eobj.PANPDISTRCode) 
	    d:eobj.PAAddrCountryCode'="" obj.PAAddrCountryCodeSetObjectId( eobj.PAAddrCountryCode) 
	    d:eobj.PAAddrPROVCode'="" obj.PAAddrPROVCodeSetObjectId( eobj.PAAddrPROVCode) 
	    d:eobj.PAAddrCITYCode'="" obj.PAAddrCITYCodeSetObjectId( eobj.PAAddrCITYCode)
	    d:eobj.PAAddrDISTRCode'="" obj.PAAddrDISTRCodeSetObjectId( eobj.PAAddrDISTRCode) 
	    s obj.PAAddress = eobj.PAAddress 
	    s obj.PAPhoto = eobj.PAPhoto 
	    s obj.PAMobile = eobj.PAMobile 
	    s obj.PAEmail = eobj.PAEmail 
	    d:eobj.PAPersonStatus'="" obj.PAPersonStatusSetObjectId(eobj.PAPersonStatus)
	    s obj.PAActivity = eobj.PAActivity 
	    s obj.PAStartDate= eobj.PAStartDate
	    s obj.PAEndDate= eobj.PAEndDate
	    s obj.PASeqNo= eobj.PASeqNo
	    s obj.PALastUpdateDate= eobj.PALastUpdateDate
	    s obj.PALastUpdateTime= eobj.PALastUpdateTime
	    d obj.PALastUpdateUserSetObjectId(eobj.PALastUpdateUser)
	    s obj.PAPYCode= eobj.PAPYCode
	    s obj.PAWBCode= eobj.PAWBCode
	    s obj.PAMark= eobj.PAMark 
	    
        TSTART 
        s sc=obj.%Save()
        d obj.%Close()
        If $$$ISOK(sc)
        {
            TCOMMIT
            s id = obj.%Id()
            s result = "{success:'true',id:'"_id_"'}"  //返回RowId  
            d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_Person","CT.BDP.CT.HOSPerson","人员基本信息",id,eobj.PAName,"A",eobj)
            d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_Person","CT.BDP.CT.HOSPerson","人员基本信息",eobj.ID,eobj.PAName,"U",eobj,bobj)
        }
        else
        {
            Trollback
            s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
            s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("人员基本信息","web.DHCBL.CT.HOSPerson","SaveData",eobj)
            s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
        }
    }  
     q result
}

/// Creator:gaoshanshan
/// CreatDate:2022-11-10
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// Other:w ##class(web.DHCBL.CT.HOSPerson).GetRefFlag("6")
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="",myInfo=""
    if $d(^CT.BDP.CT.HOSORGEmployeeI("IndexPAPersonID",id))
    {
	    s myInfo=myInfo_"<组织人员>"
	}
	if $d(^CT.BDP.CT.HOSEmpPostionI("IndexPAPersonID",id))
    {
	    s myInfo=myInfo_"<人员职位>"
	}
	if $d(^CT.BDP.CT.HOSEmpProfTitleI("IndexPAPersonID",id))
    {
	    s myInfo=myInfo_"<人员职务>"
	}
	if $d(^CT.BDP.CT.HOSEmpPostI("IndexPAPersonID",id))
    {
	    s myInfo=myInfo_"<人员岗位>"
	}
	if $d(^SSU("SSUSR",0,"HOSPerson",id))
	{
		s myInfo=myInfo_"<用户>"
	}
	
    i myInfo="" s return="0^未被引用可删除！"
    else  s return="1^在"_myInfo_"表里被引用,不能删除！"
    
    q return
}

/// Creator:gaoshanshan
/// CreatDate:2022-11-10
/// Description：根据ID删除内容
/// Table：CT.BDP.CT.HOSPerson
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.CT.HOSPerson).DeleteData("6")
ClassMethod DeleteData(id As %String) As %String
{
    s result="" 
    s re=##class(web.DHCBL.CT.HOSPerson).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag'=0)
	{
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
	}
	else
	{
	    //new Entity对象，用于保存日志
	    s pobj = ##class(CT.BDP.CT.HOSPerson).%OpenId(id)
	    s eobj = ##class(web.Entity.CT.HOSPerson).%New()
	    s eobj.ID = id
	    s eobj.PAPersonID=pobj.PAPersonID
	    s eobj.PAName=pobj.PAName
	    s eobj.PAFormerName = pobj.PAFormerName 
	    s:$IsObject(pobj.PAGenderCode) eobj.PAGenderCode = pobj.PAGenderCode.%Id()
	    s:pobj.PABirthDate'="" eobj.PABirthDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.PABirthDate) 
	    s:pobj.PABirthTime'="" eobj.PABirthTime= ##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(pobj.PABirthTime) 
	    s:$IsObject(pobj.PANationalityCode) eobj.PANationalityCode = pobj.PANationalityCode.%Id()
	    s:$IsObject(pobj.PALanguageCode1) eobj.PALanguageCode1 = pobj.PALanguageCode1.%Id()
	    s:$IsObject(pobj.PALanguageCode2) eobj.PALanguageCode2 = pobj.PALanguageCode2.%Id()
	    s eobj.PAIdentityID = pobj.PAIdentityID 
	    s:$IsObject(pobj.PAIdentityType) eobj.PAIdentityType = pobj.PAIdentityType.%Id() 
	    s:$IsObject(pobj.PANationCode) eobj.PANationCode = pobj.PANationCode.%Id() 
	    s:$IsObject(pobj.PAEducationCode) eobj.PAEducationCode = pobj.PAEducationCode.%Id() 
	    s:$IsObject(pobj.PADegreeCode) eobj.PADegreeCode = pobj.PADegreeCode.%Id() 
	    s:$IsObject(pobj.PAOccupationCode) eobj.PAOccupationCode = pobj.PAOccupationCode.%Id() 
	    s:$IsObject(pobj.PAMarriedCode) eobj.PAMarriedCode = pobj.PAMarriedCode.%Id() 
	    s:$IsObject(pobj.PAReligionCode) eobj.PAReligionCode = pobj.PAReligionCode.%Id() 
	    s:$IsObject(pobj.PANPCountryCode) eobj.PANPCountryCode = pobj.PANPCountryCode.%Id()
	    s:$IsObject(pobj.PANPPROVCode) eobj.PANPPROVCode = pobj.PANPPROVCode.%Id() 
	    s:$IsObject(pobj.PANPCITYCode) eobj.PANPCITYCode = pobj.PANPCITYCode.%Id() 
	    s:$IsObject(pobj.PANPDISTRCode) eobj.PANPDISTRCode = pobj.PANPDISTRCode.%Id() 
	    s:$IsObject(pobj.PAAddrCountryCode) eobj.PAAddrCountryCode = pobj.PAAddrCountryCode.%Id() 
	    s:$IsObject(pobj.PAAddrPROVCode) eobj.PAAddrPROVCode = pobj.PAAddrPROVCode.%Id() 
	    s:$IsObject(pobj.PAAddrCITYCode) eobj.PAAddrCITYCode = pobj.PAAddrCITYCode.%Id()
	    s:$IsObject(pobj.PAAddrDISTRCode) eobj.PAAddrDISTRCode = pobj.PAAddrDISTRCode.%Id() 
	    s eobj.PAAddress = pobj.PAAddress 
	    s eobj.PAPhoto = pobj.PAPhoto 
	    s eobj.PAMobile = pobj.PAMobile 
	    s eobj.PAEmail = pobj.PAEmail
	    s:$IsObject(pobj.PAPersonStatus) eobj.PAPersonStatus = pobj.PAPersonStatus.%Id() 
	    s eobj.PAActivity = pobj.PAActivity 
	    s:pobj.PAStartDate'="" eobj.PAStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.PAStartDate) 
	    s:pobj.PAEndDate'="" eobj.PAEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.PAEndDate) 
	    s:pobj.PACreateDate'="" eobj.PACreateDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.PACreateDate) 
	    s eobj.PACreateTime= pobj.PACreateTime
	    s:$IsObject(pobj.PACreateUser) eobj.PACreateUser= pobj.PACreateUser.%Id()
	    s eobj.PASeqNo= pobj.PASeqNo
	    s:pobj.PALastUpdateDate'="" eobj.PALastUpdateDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.PALastUpdateDate) 
	    s eobj.PALastUpdateTime= pobj.PALastUpdateTime
	    s:$IsObject(pobj.PALastUpdateUser) eobj.PALastUpdateUser= pobj.PALastUpdateUser.%Id()
	    s eobj.PAPYCode= pobj.PAPYCode
	    s eobj.PAWBCode= pobj.PAWBCode
	    s eobj.PAMark= pobj.PAMark
	    d pobj.%Close()
	    k pobj
	    Tstart
	    s sc=##class(CT.BDP.CT.HOSPerson).%DeleteId(id)
	    if $$$ISOK(sc)
	    {
	        Tcommit
	        s result = "{success:'true',info:'删除成功！'}"  
	        //保存日志
	        d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_Person","CT.BDP.CT.HOSPerson","人员基本信息",id,eobj.PAName,"D",eobj)
	        d eobj.%Close()
	    }
	    else 
	    {
	        Trollback
	        s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	        s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("人员基本信息","web.DHCBL.CT.HOSPerson","DeleteData",eobj)
	        s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
	    } 
	}
    q result
}

/// Function: 人员职位、职务、岗位的组织部门combox查询提供接口 
/// Creator:  gaoshanshan
/// CreatDate:2023-02-07
/// Tables: CT_BDP_CT.HOS_Person、CT_BDP_CT.HOS_ORGEmployee、CT_BDP_CT.HOS_Department
/// Input:  code,desc  
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSPerson", "GetDepartmentForCmb1","","","")
Query GetDepartmentForCmb1(rowid As %String, personid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID,DEPTCode,DEPTDesc")
{
}

ClassMethod GetDepartmentForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, personid As %String, code As %String, desc As %String) As %Status
{
  Set repid=$I(^CacheTemp)
  s ind=1
  s:code'="" code=$zcvt(code,"U")  
  s:desc'="" desc=$zcvt(desc,"U")  
  if (rowid'="")  
  {
    s ID=rowid
    s DEPTCode =$listget($g(^CT.BDP.CT.HOSDepartmentD(ID)),2) /// 部门代码
    s DEPTDesc =$listget($g(^CT.BDP.CT.HOSDepartmentD(ID)),3) /// 部门名称
    d OutputRowCmbDepartment
  }
  else
  {
	s EmployeeId=""
	for{
		s EmployeeId=$o(^CT.BDP.CT.HOSORGEmployeeI("IndexPAPersonID",personid,EmployeeId)) q:EmployeeId=""
		s EMPActivity =$listget($g(^CT.BDP.CT.HOSORGEmployeeD(EmployeeId)),8) /// 是否有效(Y/N)
        continue:(EMPActivity="N") 
        s EMPStartDate =$listget($g(^CT.BDP.CT.HOSORGEmployeeD(EmployeeId)),9) /// 开始日期
        continue:(EMPStartDate'="")&&(EMPStartDate>+$h)
        s EMPEndDate =$listget($g(^CT.BDP.CT.HOSORGEmployeeD(EmployeeId)),10) /// 结束日期
        continue:(EMPEndDate'="")&&(EMPEndDate<+$h)
        
		s EMPORGCode =$listget($g(^CT.BDP.CT.HOSORGEmployeeD(EmployeeId)),2) //组织代码，指向CT.BDP.CT.HOSOrganization
		s DepartmentId=""
		for{
			s DepartmentId=$o(^CT.BDP.CT.HOSDepartmentI("IndexORGCode",EMPORGCode,DepartmentId)) q:DepartmentId=""
			s DEPTActivity=$listget($g(^CT.BDP.CT.HOSDepartmentD(DepartmentId)),15)	//是否有效(Y/N)
			continue:DEPTActivity="N"
			s DEPTStartDate=$listget($g(^CT.BDP.CT.HOSDepartmentD(DepartmentId)),16)		//开始日期
			continue:(DEPTStartDate'="")&&(DEPTStartDate>+$h) 
			s DEPTEndDate=$listget($g(^CT.BDP.CT.HOSDepartmentD(DepartmentId)),17)		//结束日期
			continue:(DEPTEndDate'="")&&(DEPTEndDate<+$h)
			
			s arrDepartment(DepartmentId)=""
		}	
	}
    s ID=""
    for 
    {
       s ID=$o(arrDepartment(ID))
       q:ID="" 
       
       s DEPTCode=$listget($g(^CT.BDP.CT.HOSDepartmentD(ID)),2)	//部门代码
	   s DEPTDesc= $listget($g(^CT.BDP.CT.HOSDepartmentD(ID)),3)	//部门名称
	   s DEPTPYCode=$listget($g(^CT.BDP.CT.HOSDepartmentD(ID)),26)		//拼音码 
      
       if (($zcvt(DEPTCode,"U")[$zcvt(code,"U"))||(code=""))&(($zcvt(DEPTDesc,"U")[$zcvt(desc,"U"))||($zcvt(DEPTPYCode,"U")[$zcvt(desc,"U"))||(desc=""))
        {
        	d OutputRowCmbDepartment
    	}
    }
  } 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmbDepartment
 set Data=$lb(ID,DEPTCode,DEPTDesc)
  Set ^CacheTemp(repid,ind)=Data
  Set ind=ind+1
  q
}

ClassMethod GetDepartmentForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDepartmentForCmb1Execute ]
{
 Set repid=$LIST(qHandle,2)
  Kill ^CacheTemp(repid)  
  Quit $$$OK
}

ClassMethod GetDepartmentForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDepartmentForCmb1Execute ]
{
 
  Set AtEnd=$LIST(qHandle,1)
  Set repid=$LIST(qHandle,2)
  Set ind=$LIST(qHandle,3)
  Set ind=$o(^CacheTemp(repid,ind))
  If ind="" {    // if there are no more rows, finish fetching
   Set AtEnd=1
   Set Row=""
  }
  Else      {    // fetch row
   Set Row=^CacheTemp(repid,ind)
  }
  s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

}
