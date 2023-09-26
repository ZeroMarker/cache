/// creator:郭荣勇
/// date:2016-2-3
/// desc:医生站基础工具类(方法与具体业务无关),web.DHCDocCommon中的方法都移植到这里
Class DHCDoc.Util.Base Extends (DHCDoc.Util.RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// creator:郭荣勇
/// date:2017-7-13
/// desc:身份证号15位转18位
/// input:IDCardNo15 15位身份证号码
/// output:18位身份证号码
ClassMethod ID15to18(IDCardNo15 As %String = "") As %String
{

	if $length(IDCardNo15)'=15 quit IDCardNo15
	set IDCardNo17=$extract(IDCardNo15,1,6)_"19"_$extract(IDCardNo15,7,15)

	set W(1)=1,W(2)=2,W(3)=4,W(4)=8,W(5)=5,W(6)=10,W(7)=9,W(8)=7,W(9)=3,W(10)=6
	set W(11)=1,W(12)=2,W(13)=4,W(14)=8,W(15)=5,W(16)=10,W(17)=9,W(18)=7
	set Y(0)="1",Y(1)="0",Y(2)="X",Y(3)="9",Y(4)="8",Y(5)="7",Y(6)="6",Y(7)="5",Y(8)="4",Y(9)="3",Y(10)="2"

	set snum=0
	for i=18:-1:2
	{
		set snum=snum+($extract(IDCardNo17,19-i,19-i)*W(i))
	}

	set ynum=snum#11

	set IDCardNo18=IDCardNo17_Y(ynum)
	quit IDCardNo18
}

/// creator:郭荣勇
/// date:2017-7-13
/// desc:身份证号18位转15位
/// input:IDCardNo18 18位身份证号码
/// output:15位身份证号码
ClassMethod ID18to15(IDCardNo18 As %String = "") As %String
{
	if $length(IDCardNo18)'=18 quit IDCardNo18
	set IDCardNo15=$extract(IDCardNo18,1,6)_$extract(IDCardNo18,9,17)

	quit IDCardNo15
}

/// creator:郭荣勇
/// date:2015-11-18
/// desc:通过年龄描述得到出生日期
/// input:Age 年龄描述, Type 类型:默认为空,为空即如果只有"岁"则计算的月和日和当前的月和日相同
/// output:年龄描述(eg:1岁 或 2月 或 3天)
/// other:
/// debug:w ##class(DHCDoc.Util.Base).GetBirthDateByAge("1","")
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
			s Month=CurMonth
			i Year="" s Year=CurYear
		}else{
			s Day=$p($p(Age,"月",2),"天",1)
		}
		s Day=CurDay-Day
		i Day<=0{
			s Month=Month-1
			i Month=0{
				s Year=Year-1
				s Month=12
				s Day=Day+31
			}else{
				s Day=Day+($zd($zdh(Year_"-"_(Month+1)_"-01",3),14)-$zd($zdh(Year_"-"_Month_"-01",3),14)-1)
			}
		}
	}
	
	
	i Type="" {
		i Year="" s Year=CurYear
		i Year'="",Month="" s Month=CurMonth
		i Month'="",Day="" s Day=CurDay
		i $l(Month)=1 s Month="0"_Month
		i $l(Day)=1  s Day="0"_Day
		s BirthDate=Year_"-"_Month_"-"_Day
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
/// Others:	！！！此方法不属于工具类方法，应该移出到通用业务类，不允许在此类中使用
/// Debug:		w ##class(DHCDoc.Util.Base).GetPatAge(1)
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
/// Others:	！！！此方法不属于工具类方法，应该移出到通用业务类，不允许在此类中使用
/// Debug:		w ##class(DHCDoc.Util.Base).GetCardNoByPAPER("LAST","00000629")
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
/// other:	！！！此方法不属于工具类方法，应该移出到通用业务类，不允许在此类中使用
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
/// other:	！！！此方法不属于工具类方法，应该移出到通用业务类，不允许在此类中使用
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
/// Others:	！！！此方法不属于工具类方法，应该移出到通用业务类，不允许在此类中使用
/// Debug:		w ##class(DHCDoc.Util.Base).GetCardNo(1,"0000000001")
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
/// Description:: 得到web配置的模板路径
/// Table;        websys.configuration
/// Input:        SEXRowid:性别rowid
/// Return:       web配置的模板路径
/// Others:
/// Debug:		w ##class(DHCDoc.Util.Base).GetPath()
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
///  Debug:  d ##class(DHCDoc.Util.Base).GetHospIdByLocId(2)
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
/// Debug:		w ##class(DHCDoc.Util.Base).GetCTHospitalStr()
ClassMethod GetCTHospitalStr() As %String
{
	s CTHospitalStr=""
	s HospRowid=0
	for {
		s HospRowid=$O(^CT("HOSP",HospRowid)) Q:HospRowid=""
		s HospitalCode=$p($g(^CT("HOSP",HospRowid)),"^",1)
		s HospitalDesc=$p($g(^CT("HOSP",HospRowid)),"^",2)
		i CTHospitalStr="" s CTHospitalStr=HospRowid_"^"_HospitalCode_"^"_HospitalDesc
		e  s CTHospitalStr=CTHospitalStr_$C(1)_HospRowid_"^"_HospitalCode_"^"_HospitalDesc
	}
	

	Q $g(CTHospitalStr)
}

/// Creator:      郭荣勇
/// CreatDate:    2010.12.01
/// Description:: 得到代码表下设置的医院代码
/// Table;        CT_Hospital
/// Input:        HospRowid 医院Rowid
/// Return:       代码表下设置的医院代码
/// Others:
/// Debug:		w ##class(DHCDoc.Util.Base).GetCTHospitalCode(1)
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
///  Debug:  d ##class(DHCDoc.Util.Base).SetTimeLog("大通保存时间","1")
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
/// Debug:		  w ##class(DHCDoc.Util.Base).IsPracticeDoctor(3907)
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
/// w ##class(DHCDoc.Util.Base).GetAgeDescNew("2014-01-04","")
ClassMethod GetAgeDescNew(DOB As %String, CalDate As %String, HospID As %String = "") As %String
{
	s $ZT="ErrorDate"
	s HospID=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	s DOBTest=$ZDH(DOB,3)
	s:CalDate'="" CalDateTest=$ZDH(CalDate,3)
	s:CalDate="" CalDate=$ZD(+$H,3)
	s AgeStr=##class(web.UDHCJFCOMMON).DispPatAge(DOB,CalDate,"","",HospID)
	s Age=$P(AgeStr,"||",1)
	q Age
ErrorDate
	q ""
}

/// creater scl
/// 根据表名、记录id，查询条件判断条件是否在别名列表里
/// 入参：表名 查询条件
/// 出参 1 在 0不在
/// w ##class(DHCDoc.Util.Base).CheckAliasByTableName("SS_User","1","DM")
ClassMethod CheckAliasByTableName(TableName As %String, paraId As %String, paraDesc As %String) As %String
{
	s AliasExistFlag=0
	Q:(TableName="")||(paraDesc="") 1
	s paraDesc=$$ALPHAUP^SSUTIL4(paraDesc)
	s SubID=0  
	f  s SubID=$O(^User.BDPAliasI("DataRef",TableName,paraId,SubID)) Q:(SubID="")||(AliasExistFlag=1)  d
	.i $D(^User.BDPAliasD(SubID)) d
	..s SubCode=$$ALPHAUP^SSUTIL4($list(^User.BDPAliasD(SubID),2))
	..i SubCode[paraDesc  d
	...s AliasExistFlag=1
	Q AliasExistFlag
}

/// creater scl
/// 根据表名、记录id，查询条件判断条件
/// 入参：表名 查询条件
/// 出参 1 在 0不在
/// w ##class(DHCDoc.Util.Base).CheckUserName("SS_User","1","DM")
ClassMethod CheckUserName(TableName As %String, paraId As %String, paraDesc As %String, langid As %String = "") As %String
{
	n (TableName,paraId,paraDesc,langid,%session)
	Q:paraDesc="" 1
	s:langid="" langid=..%LanguageID()
	s AliasExistFlag=0
	s paraDesc=$$ALPHAUP^SSUTIL4(paraDesc)
	s UserCode=$p(^SSU("SSUSR",paraId),"^",1)
	i ($$ALPHAUP^SSUTIL4(UserCode))[paraDesc  q 1
	s Username=$p(^SSU("SSUSR",paraId),"^",2)
	s UserEngName=##class(DHCDoc.Common.Translate).GetTransUser(Username,langid)
	i ($$ALPHAUP^SSUTIL4(Username))[paraDesc  s AliasExistFlag=1
	i ($$ALPHAUP^SSUTIL4(UserEngName))[paraDesc  s AliasExistFlag=1
	Q:AliasExistFlag="1" AliasExistFlag
	s careRowId=$p(^SSU("SSUSR",paraId),"^",14)
	if (careRowId'=""){
		s con=$p($g(^CTPCP(careRowId,3)),"^",28)
		i ($$ALPHAUP^SSUTIL4(con))[paraDesc  q 1
	}
	s AliasExistFlag=##class(DHCDoc.Util.Base).CheckAliasByTableName(TableName,paraId,paraDesc)
	Q AliasExistFlag
}

ClassMethod CheckCTCareName(TableName As %String, paraId As %String, paraDesc As %String) As %String
{
	Q:paraDesc="" 1
	s AliasExistFlag=0
	s paraDesc=$$ALPHAUP^SSUTIL4(paraDesc)
	s CTPCPDesc=$p(^CTPCP(paraId,1),"^",2)
	s CTPCPOtherName=$p(^CTPCP(paraId,3),"^",28)
	i ($$ALPHAUP^SSUTIL4(CTPCPDesc))[paraDesc  s AliasExistFlag=1
	i ($$ALPHAUP^SSUTIL4(CTPCPOtherName))[paraDesc  s AliasExistFlag=1
	Q:AliasExistFlag="1" AliasExistFlag
	s AliasExistFlag=##class(DHCDoc.Util.Base).CheckAliasByTableName(TableName,paraId,paraDesc)
	Q AliasExistFlag
}

/// creater scl
/// 根据表名、记录id，查询别名列表
/// 入参：表名 查询条件
/// 出参 别名1^别名2
/// w ##class(DHCDoc.Util.Base).GetAliasByTabName("CT_Country","1")
ClassMethod GetAliasByTabName(TableName As %String, paraId As %String) As %String
{
	s AliasStr=""
	Q:(TableName="")||(paraId="") ""
	s SubID=0  
	f  s SubID=$O(^User.BDPAliasI("DataRef",TableName,paraId,SubID)) Q:(SubID="")  d
	.i $D(^User.BDPAliasD(SubID)) d
	..s SubCode=$$ALPHAUP^SSUTIL4($list(^User.BDPAliasD(SubID),2))
	..i AliasStr="" s AliasStr=SubCode
	..e  s AliasStr=AliasStr_"^"_SubCode
	Q AliasStr
}

/// 字符转ASCII码,以冒号(:)拼接返回;对应javascript方法:DHCOPAdm.Common.js中DHCC_CharTransAsc
ClassMethod CharTransAsc(Str As %String) As %String
{
	if (Str="") quit ""
	s rtnStr=""
	s len=$l(Str)
	for i=1:1:len {
		s oneStr=$e(Str,i)
		if (rtnStr="") {
			s rtnStr=$A(oneStr)
		}else{
			s rtnStr=rtnStr_":"_$A(oneStr)
		}
	}
	quit rtnStr
}

/// ASCII码转字符,以冒号(:)拼接传入
ClassMethod AscTransChar(AscStr As %String) As %String
{
	if (AscStr="") quit ""
	s rtnStr=""
	for i=1:1:$l(AscStr,":") {
		if (rtnStr="") {
			s rtnStr=$C($p(AscStr,":",i))
		}else{
			s rtnStr=rtnStr_$C($p(AscStr,":",i))
		}
	}
	quit rtnStr
}

/// Creator:      宋春莉
/// CreatDate:    2019.05.13
/// Description:: 根据页面CSP名称获取页面配置快捷键json
/// Table;        
/// Input:        
/// Return:       
/// Others:
/// Debug:		  w ##class(DHCDoc.Util.Base).GetCSPShortcutKeyJSON("opadm.return.hui.csp")
ClassMethod GetCSPShortcutKeyJSON(cspName As %String = "") As %String
{
	s JsonObj=[]
	s JsonData={}
	s DOPRowId=$O(^DHCDocOPi("Code",0,cspName,0))
	if (DOPRowId'=""){
		s Rowid=0
	 	for {
		 	s Rowid=$o(^DHCDocSCK(DOPRowId,Rowid)) q:Rowid=""  d
		 	s ItemID=$p($g(^DHCDocSCK(DOPRowId,Rowid)),"^",1)
		 	s ShortcutKey=$p($g(^DHCDocSCK(DOPRowId,Rowid)),"^",2)
		 	s callBackFun=$p($g(^DHCDocSCK(DOPRowId,Rowid)),"^",3)
			s keycode=$case(ShortcutKey,"F1":112,"F2":113,"F3":114,"F4":115,"F5":116,"F6":117,"F7":118,"F8":119,"F9":120,"F10":121,"F11":122,"F12":123,:"")
			continue:keycode=""
			s JsonData={}
			do JsonData.%Set("id",ItemID)
			do JsonData.%Set("ShortcutKey",ShortcutKey)
			do JsonData.%Set("KeyCode",keycode)
			do JsonData.%Set("callBackFun",callBackFun)
			do JsonObj.%Push(JsonData,"")
	 	}
 	}
	s JsonInfo=""
	s obj=##class(%Stream.GlobalCharacter).%New()
	do JsonObj.%ToJSON(obj)
	While 'obj.AtEnd { 
		s JsonInfo=JsonInfo_obj.ReadLine(,.sc,.eol)
	}
	q JsonInfo
}

ClassMethod FormateNumber(Number)
{
    if ((Number = "")||(Number=" ")) Q ""
    s FirstNum = $p(Number,".",1)
    s FirstNum = +FirstNum
    s SecondNum = ""
    if (Number[".") s SecondNum = $p(Number,".",2)
    if (SecondNum '= "") {
        Q FirstNum_"."_SecondNum
    } else {
        Q FirstNum
    }
}

/// Creator:      tanjishan
/// CreatDate:    2020.09.22
/// Description:: 判断截止时间是否有效
/// Table;        
/// Input:        
/// Return:       1：有效；0：无效
/// Others:
/// Debug:		  w ##class(DHCDoc.Util.Base).CheckDateValid()
ClassMethod CheckDateValid(datefrom As %String, dateto As %String)
{
	 i datefrom>+$h q 0
	 i dateto,dateto<+$h q 0
	 q 1
}

/// Creator:      宋春莉
/// CreatDate:    2021.02.04
/// Description:: 验证身份证号有效性
/// Return:       Y：有效；N：无效
/// Debug:		  w ##class(DHCDoc.Util.Base).CheckIdCardNo("412727199001093569")
ClassMethod CheckIdCardNo(pId As %String, ByRef ErrMsg As %String = "")
{
	s ErrMsg=""
	s pId=$ZCVT(pId,"L")
	s IdCardNoLen=$l(pId)
	if (IdCardNoLen'=15)&&(IdCardNoLen'=18) {
		s ErrMsg="身份证号共有 15位或18位！"
		Q "N"
	}
	s Ai=$case(IdCardNoLen,18:pId,:(..ID15to18(pId)))
	s IdCardNoLen=$l(Ai)
	if ($MATCH($e(Ai,1,17),"!/^\d+$/")) {
		s ErrMsg="身份证除最后一位外必须为数字！"
		Q "N"
	}
	s yyyy=$e(Ai,7,10), mm=$e(Ai,11,12), dd=$e(Ai,13,14)
	if (yyyy < 1901)||($zd(yyyy_"-"_mm_"-"_dd,3) > +$h) {
		s ErrMsg="身份证输入错误！"
		Q "N"
	}
	k Errors,area
	s Errors(1)="身份证号码位数不对！"
	s Errors(2)="身份证号码出生日期超出范围或含有非法字符！"
	s Errors(3)="身份证号码校验错误！"
	s Errors(4)="身份证地区非法！"
	
	s area(11)="北京",area(12)="天津",area(13)="河北",area(14)="山西",area(15)="内蒙古",area(21)="辽宁",area(22)="吉林",area(23)="黑龙江"
	s area(31)="上海",area(32)="江苏",area(33)="浙江",area(34)="安徽",area(35)="福建",area(36)="江西",area(37)="山东"
	s area(41)="河南",area(42)="湖北",area(43)="湖南",area(44)="广东",area(45)="广西",area(46)="海南"
	s area(50)="重庆",area(51)="四川",area(52)="贵州",area(53)="云南",area(54)="西藏"
	s area(61)="陕西",area(62)="甘肃",area(63)="青海",area(64)="宁夏",area(65)="新疆",area(71)="台湾"
	s area(81)="香港",area(82)="澳门",area(83)="台湾",area(91)="国外"
	if ('$d(area($e(Ai,1,2)))) {
		s ErrMsg= Errors(4) 
		Q "N"
	}
	if (($e(Ai,7,10) # 4 = 0) || (($e(Ai,7,10) # 100 = 0) && ($e(Ai,7,10)#4 = 0 ))){
		s ereg="^[1-9][0-9]{5}(19|20)[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
	}else{
		s ereg="^[1-9][0-9]{5}(19|20)[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
	}
	if ($MATCH(Ai,ereg)) {
		k idcardArray
		for i=1:1:IdCardNoLen {
			s idcardArray(i-1)=$e(Ai,i,i)
		}
		s tt = ((idcardArray(0)+idcardArray(10))*7)+((idcardArray(1)+idcardArray(11))*9)
		s tt = tt + ((idcardArray(2)+idcardArray(12))*10)
		s tt = tt + ((idcardArray(3)+idcardArray(13))*5)
		s tt = tt + ((idcardArray(4)+(idcardArray(14)))*8)
		s tt = tt + ((idcardArray(5)+(idcardArray(15)))*4)
		s tt = tt + ((idcardArray(6)+(idcardArray(16)))*2)
		s tt = tt + (idcardArray(7)*1)
		s tt = tt + (idcardArray(8)*6)
		s tt = tt + (idcardArray(9)*3)
		s Y = tt # 11
		s M ="F"
		s JYM="10x98765432"
		s M = $e(JYM,Y+1,Y+1) //判断校验位
		if (M = idcardArray(17)) {
			Q "Y" //检测ID的校验位 
		} else {
			s ErrMsg= Errors(3) 
			Q "N"
		}
     } else{
	     s ErrMsg= Errors(2) 
		 Q "N"
	 }
	 Q "Y"
}

/// Creator:      lixu
/// CreatDate:    2021.05.17
/// Description:  判断值是否存在目标串中
/// Return:       0：不存主、1：存在
/// Debug:		  w ##class(DHCDoc.Util.Base).CheckExitFlag("1*2*3","3*2","*","Y")
ClassMethod CheckExitFlag(CheckStr, ValueStr, Delim = "^", Sigle = "") As %String
{
	n (CheckStr,ValueStr,Delim,Sigle)
	s ExitFlag=0
	q:(CheckStr="")||(ValueStr="") ExitFlag
	i Sigle="Y" {
		f len=1:1:$l(ValueStr,Delim) d
		.s Value=$p(ValueStr,Delim,len)
		.q:(Value="")||(ExitFlag=1)
		.d CheckExit
	}else{
		s Value=ValueStr
		d CheckExit
	}
	
	q ExitFlag

CheckExit	
	s Value=Delim_Value_Delim
	s CheckStr=Delim_CheckStr_Delim
	s:CheckStr[Value ExitFlag=1
	q ""
}

/// Creator:      qujian
/// CreatDate:    2022.04.7
/// Description:  隐藏中心的部分符号，用*代替
/// Return:       0：不存主、1：存在
/// Debug:		  w ##class(DHCDoc.Util.Base)HideStringNumber("122234444","2")
ClassMethod HideStringNumber(NumberStr, Num, StartNumber, EndNumber)
{
	q:((NumberStr="")&&(Num="")) ""
	s NumStrLength=$L(NumberStr)
	s rtnStr=""
	if (Num'=""){
		if (Num>=NumStrLength) {
			f len=1:1:NumStrLength d
			.s rtnStr=rtnStr_"*"
			q rtnStr
		}else{
			s midLength=NumStrLength-Num
			s SplitNum=midLength/2
			s SplitNum=$P(SplitNum,".",1)
			f len=1:1:Num d
			.s rtnStr=rtnStr_"*"
			s NumberStr=$e(NumberStr,1,SplitNum)_rtnStr_$e(NumberStr,SplitNum+Num+1,NumStrLength)
			q NumberStr
			}
	}
	if ((StartNumber'="")&&(EndNumber'="")){
		f len=1:1:EndNumber-StartNumber d
		.s rtnStr=rtnStr_"*"
		s NumberStr=$e(NumberStr,1,StartNumber)_rtnStr_$e(NumberStr,EndNumber+1,NumStrLength)
		q NumberStr
		}
	q NumberStr
}

/// Creator:      WangQingyong
/// CreatDate:    2022.11.01
/// Description:  去除字符串两端空格
/// Return:       替换后的字符串
/// Debug:		  w ##class(DHCDoc.Util.Base).Trim("  ad d c  ")
ClassMethod Trim(str As %String) As %String
{
	s len=$L(str)
	while $E(str,1)=" "{
		s str=$E(str,2,len)
		s len=len-1
	}
	while $E(str,len)=" "{
		s str=$E(str,1,$I(len,-1))
	}
	Q str
}

/// Creator:      pengjun
/// Description:返回汉字的编码信息
/// Input：	HANZI:汉字
/// 			FLAG:返回何种编码(1:ASC码,2:汉字,3:拼音,4:首拼,5:四角码6:五笔码7:区位码8:笔划数9:郑码)
/// 			SPLIT:分割符(可以为空)
/// Output：
/// 	非0:返回编码信息:ASC码^汉字^拼音^首拼^四角码^五笔码^区位码^笔划数^郑码
/// 	0：未找到编码信息
/// CreatDate:2011-06-08
/// w ##class(DHCDoc.Util.Base).GetCNCODE("东华",4,"^")
/// w ##class(DHCDoc.Util.Base).GetCNCODE("aaa",3,"")
ClassMethod GetCNCODE(HANZIS As %String = "", FLAG As %String = "", SPLIT As %String = "") As %String
{
	s Rtnstr="0"
	q:$g(HANZIS)="" Rtnstr
	s Rtnstr=""
	f i=1:1:$l(HANZIS) d
	.s HANZI=$EXTRACT(HANZIS,i)
	.s ASCIICODE=$ASCII(HANZI)
	.i $D(^DHCCharacterEncoding("0","ASCII",ASCIICODE))'=0 d
	..s rowid=$o(^DHCCharacterEncoding("0","ASCII",ASCIICODE,""))
	..s tmpstr=""
	..s:FLAG="" tmpstr=$g(^DHCCharacterEncoding(rowid))
	..s:FLAG'="" tmpstr=$p(^DHCCharacterEncoding(rowid),"^",FLAG)
	..i Rtnstr=""  d
	...s Rtnstr=tmpstr
	..e  d
	...s Rtnstr=Rtnstr_SPLIT_tmpstr
	.e  d
	..s:Rtnstr="" Rtnstr="?"
	..s Rtnstr=Rtnstr_SPLIT_"?"
	q Rtnstr
}

/// Creator:      lixu
/// CreatDate:    2021.05.17
/// Description:  通过菜单代码获取对应的菜单信息
/// Return:       
/// Debug:		  w ##class(DHCDoc.Util.Base).GetMenuInfoByName("DHC.Seconde.DHCEMRbrowse")
ClassMethod GetMenuInfoByName(MenuCode) As %String
{
	n (MenuCode)
	s Obj={}
	s MenuCode=$ZCVT(MenuCode,"U")
	s MenuId=$o(^websys.MenuI("UniqueNameIndex"," "_MenuCode,0))
	i MenuId'="" d
	.s ChartBookId=$li(^websys.MenuD(MenuId),22)
	.s ValueExpression=$li(^websys.MenuD(MenuId),10)
	.i ValueExpression'="" d
	..f Len=1:1:$l(ValueExpression,"&") d
	...s Expression=$p(ValueExpression,"&",Len)
	...s key=$p(Expression,"=",1)
	...s val=$p(Expression,"=",2)
	...q:key=""
	...s Code="s Obj."""_key_"""="""_val_""""
	...XECUTE Code
	.s Obj."TMENU"=MenuId
	.s Obj."ChartBookID"=ChartBookId
	i MenuCode="DHC.Seconde.DHCEMRbrowse"{
		;超融合双屏增加工程
		if $d(^templx("Screen"))=0{
			job ..AddItemToProject()
			s ^templx("Screen")=1
		}
	}
	q Obj.%ToJSON()
}

/// Creator:      lixu
/// CreatDate:    2021.05.17
/// Description:  通过安全组和菜单描述获取对应的菜单信息
/// Return:       
/// Debug:		  w ##class(DHCDoc.Util.Base).GetMenuInfoByGroupId(275,"病历浏览")
ClassMethod GetMenuInfoByGroupId(GroupId, MenuDesc, MenuId = "") As %String
{
	n (GroupId,MenuDesc,MenuId)
	i (GroupId'="")&&(MenuId="") d
	.s MainMenuId = ##Class(epr.GroupSettings).GetMainMenu(GroupId,.swf)
	i (MenuId'="") d
	.s MainMenuId=MenuId
	q:MainMenuId="" "{}"
	
	s OutObj={},ObjJson="{}"
	s Find=0,SubMenu=0
	f  s SubMenu=$o(^websys.MenuI("SubMenuOf1",MainMenuId,SubMenu)) q:(SubMenu="")||(Find=1)  d
	.;递归子菜单
	.i $d(^websys.MenuI("SubMenuOf1",SubMenu))'=0 d
	..s ObjJson=..GetMenuInfoByGroupId(GroupId,MenuDesc,SubMenu)
	..s:ObjJson'="{}" Find=1
	.q:Find=1
	.s Caption=$li(^websys.MenuD(SubMenu),1)
	.q:(MenuDesc'="")&&(Caption'=MenuDesc)
	.s Name=$li(^websys.MenuD(SubMenu),4)
	.s ChartBookId=$li(^websys.MenuD(SubMenu),22)
	.s ValueExpression=$li(^websys.MenuD(SubMenu),10)
	.i ValueExpression'="" d
	..f Len=1:1:$l(ValueExpression,"&") d
	...s Expression=$p(ValueExpression,"&",Len)
	...s key=$p(Expression,"=",1)
	...s val=$p(Expression,"=",2)
	...q:key=""
	...s Code="s OutObj."""_key_"""="""_val_""""
	...XECUTE Code
	.s OutObj."TMENU"=SubMenu
	.s OutObj."ChartBookID"=ChartBookId
	.s Find=1
	q:ObjJson'="{}" ObjJson
	q OutObj.%ToJSON()
}

/// Creator:      lixu
/// CreatDate:    2021.05.17
/// Desc: 把文件添加到项目工程中(主要用于标版添加文件到工程)
/// Input: XMLStr:xml、QExit:(1/0)存在工程就退出
/// w ##class(DHCDoc.Util.Base).AddItemToProject()
ClassMethod AddItemToProject(XMLStr = "", QExit = "1")
{
	if XMLStr="" {
		s XMLStr="<Project name=""DHCDocSecondScreen"" LastModified=""2023-04-05 12:22:11.40468"" TargetType=""0""><Items>"
	    _"<ProjectItem name=""DHCAnt.KSS.MainInterface"" type=""CLS""></ProjectItem>"
	    _"<ProjectItem name=""DHCDoc.DHCDocCure.Apply"" type=""CLS""></ProjectItem>"
	    _"<ProjectItem name=""DHCDoc.GetInfo.Second.ScreenMethod"" type=""CLS""></ProjectItem>"
	    _"<ProjectItem name=""DHCDoc.GetInfo.Service.FaceAuthentication"" type=""CLS""></ProjectItem>"
	    _"<ProjectItem name=""DHCDoc.Util.Base"" type=""CLS""></ProjectItem>"
	    _"<ProjectItem name=""imedical/web/csp/dhcant.kss.business.findapply.csp"" type=""CSP""></ProjectItem>"
	    _"<ProjectItem name=""imedical/web/csp/dhcdoc.secondescreen.protal.csp"" type=""CSP""></ProjectItem>"
	    _"<ProjectItem name=""imedical/web/csp/dhcdoc.secondescreen.protal.show.csp"" type=""CSP""></ProjectItem>"
	    _"<ProjectItem name=""imedical/web/csp/doccure.apply.update.hui.csp"" type=""CSP""></ProjectItem>"
	    _"<ProjectItem name=""imedical/web/csp/doccure.applytree.hui.csp"" type=""CSP""></ProjectItem>"
	    _"<ProjectItem name=""imedical/web/csp/doccure.workreport.patientcure.hui.csp"" type=""CSP""></ProjectItem>"
	    _"<ProjectItem name=""imedical/web/csp/docdoc.cure.secondescreen.hui.csp"" type=""CSP""></ProjectItem>"
	    _"<ProjectItem name=""imedical/web/csp/docdoc.cure.secondescreen.show.hui.csp"" type=""CSP""></ProjectItem>"
	    _"<ProjectItem name=""imedical/web/csp/docdoc.kss.secondescreen.hui.csp"" type=""CSP""></ProjectItem>"
	    _"<ProjectItem name=""imedical/web/csp/docdoc.kss.secondescreen.show.hui.csp"" type=""CSP""></ProjectItem>"
	    _"<ProjectItem name=""imedical/web/csp/docdoc.secondescreen.hui.csp"" type=""CSP""></ProjectItem>"
	    _"<ProjectItem name=""imedical/web/csp/docdoc.secondescreen.show.hui.csp"" type=""CSP""></ProjectItem>"
	    _"<ProjectItem name=""imedical/web/csp/opdoc.main.framework.show.csp"" type=""CSP""></ProjectItem>"
	    _"<ProjectItem name=""imedical/web/csp/opdoc.oeorder.cmpresclist.csp"" type=""CSP""></ProjectItem>"
	    _"<ProjectItem name=""imedical/web/csp/opdoc.oeorder.cmpresclist.show.csp"" type=""CSP""></ProjectItem>"
	    _"<ProjectItem name=""imedical/web/scripts/DHCDoc.OP.BillInfo.js"" type=""CSP""></ProjectItem>"
	    _"<ProjectItem name=""imedical/web/scripts/Doc.AdmListQuery.hui.js"" type=""CSP""></ProjectItem>"
	    _"<ProjectItem name=""imedical/web/scripts/dhcdoc/DHCDocDiagnoEntry.V8.js"" type=""CSP""></ProjectItem>"
	    _"<ProjectItem name=""imedical/web/scripts/dhcdoc/InPatientList.inPat.js"" type=""CSP""></ProjectItem>"
	    _"<ProjectItem name=""imedical/web/scripts/dhcdoc/InPatientList.js"" type=""CSP""></ProjectItem>"
	    _"<ProjectItem name=""imedical/web/scripts/dhcdoc/OEOrder.Common.Control.js"" type=""CSP""></ProjectItem>"
	    _"<ProjectItem name=""imedical/web/scripts/dhcdoc/UDHCOEOrder.List.Custom.New.js"" type=""CSP""></ProjectItem>"
	    _"<ProjectItem name=""imedical/web/scripts/dhcdoc/dhcapp/inspectrs.js"" type=""CSP""></ProjectItem>"
	    _"<ProjectItem name=""imedical/web/scripts/dhcdoc/dhcapp/mainframe.js"" type=""CSP""></ProjectItem>"
	    _"<ProjectItem name=""imedical/web/scripts/dhcdoc/dhcapp/seepatlis.js"" type=""CSP""></ProjectItem>"
	    _"<ProjectItem name=""imedical/web/scripts/dhcdoc/dhcdoc.secondescreen.protal.js"" type=""CSP""></ProjectItem>"
	    _"<ProjectItem name=""imedical/web/scripts/dhcdoc/dhcdoccure_hui/app.apply.update.js"" type=""CSP""></ProjectItem>"
	    _"<ProjectItem name=""imedical/web/scripts/dhcdoc/dhcdoccure_hui/app.applytree.js"" type=""CSP""></ProjectItem>"
	    _"<ProjectItem name=""imedical/web/scripts/dhcdoc/dhcdoccure_hui/app.cureapplist.all.js"" type=""CSP""></ProjectItem>"
	    _"<ProjectItem name=""imedical/web/scripts/dhcdoc/dhcdoccure_hui/app.cureapplist.exec.js"" type=""CSP""></ProjectItem>"
	    _"<ProjectItem name=""imedical/web/scripts/dhcdoc/dhcdoccure_hui/applydatagrid.js"" type=""CSP""></ProjectItem>"
	    _"<ProjectItem name=""imedical/web/scripts/dhcdoc/dhcdoccure_hui/common.openwin.js"" type=""CSP""></ProjectItem>"
	    _"<ProjectItem name=""imedical/web/scripts/dhcdoc/dhcdoccure_hui/record.worklist.applyapplist.js"" type=""CSP""></ProjectItem>"
	    _"<ProjectItem name=""imedical/web/scripts/dhcdoc/dhcdoccure_hui/record.worklist.cureassessmentlist.js"" type=""CSP""></ProjectItem>"
	    _"<ProjectItem name=""imedical/web/scripts/dhcdoc/ipdoc/InPatOrderView.js"" type=""CSP""></ProjectItem>"
	    _"<ProjectItem name=""imedical/web/scripts/dhcdoc/oeorder.cure.secondescreen.js"" type=""CSP""></ProjectItem>"
	    _"<ProjectItem name=""imedical/web/scripts/dhcdoc/oeorder.kss.secondescreen.js"" type=""CSP""></ProjectItem>"
	    _"<ProjectItem name=""imedical/web/scripts/dhcdoc/oeorder.oplistcustom.show.js"" type=""CSP""></ProjectItem>"
	    _"<ProjectItem name=""imedical/web/scripts/dhcdoc/oeorder.secondescreen.js"" type=""CSP""></ProjectItem>"
	    _"<ProjectItem name=""imedical/web/scripts/dhcdoc/opdoc/CMPrescList.js"" type=""CSP""></ProjectItem>"
	    _"<ProjectItem name=""imedical/web/scripts/dhcdoc/opdoc/TreatPrint.js"" type=""CSP""></ProjectItem>"
	    _"<ProjectItem name=""imedical/web/scripts/dhcdoc/opdoc/UDHCOEOrder.CHNMEDEntry.js"" type=""CSP""></ProjectItem>"
	    _"<ProjectItem name=""imedical/web/scripts/dhcdoc/opdoc/main.framework.js"" type=""CSP""></ProjectItem>"
	    _"<ProjectItem name=""imedical/web/scripts/dhcdoc/opdoc/patient.list.js"" type=""CSP""></ProjectItem>"
	    _"<ProjectItem name=""imedical/web/scripts/dhcdoc/passwork/nmain.comtpl.js"" type=""CSP""></ProjectItem>"
	    _"<ProjectItem name=""imedical/web/scripts/dhcdocant/kss_hui/apply.js"" type=""CSP""></ProjectItem>"
	    _"<ProjectItem name=""imedical/web/scripts/dhcdocant/kss_hui/applydatagrid.js"" type=""CSP""></ProjectItem>"
	    _"<ProjectItem name=""imedical/web/scripts/dhcdocant/kss_hui/audit.js"" type=""CSP""></ProjectItem>"
	    _"<ProjectItem name=""imedical/web/scripts/dhcdocant/kss_hui/extend/business.findapply.init.js"" type=""CSP""></ProjectItem>"
	    _"<ProjectItem name=""imedical/web/scripts/dhcdocant/kss_hui/main.init.js"" type=""CSP""></ProjectItem>"
	    _"<ProjectItem name=""imedical/web/scripts/dhcdocant/kss_hui/main.js"" type=""CSP""></ProjectItem>"
	    _"<ProjectItem name=""web.DHCAPPSeePatPacs"" type=""CLS""></ProjectItem>"
	    _"<ProjectItem name=""web.DHCDoc.OP.AjaxInterface"" type=""CLS""></ProjectItem>"
	  _"</Items></Project>"
	}
	
	s XMLObj=##class(DHCDoc.Util.FromXML).XML2Arr(XMLStr)
	if '$IsObject(XMLObj) Q XMLObj
	s PrjName=XMLObj.name
	Q:PrjName="" "-1^没有工程名"
	s Exit=##class(%Studio.Project).%ExistsId("DHCDocSecondScreen")
	Q:(QExit=1)&&(Exit=1) "-1^已经存在工程"
	
	s PrjObj=##class(%Studio.Project).%New(PrjName)
	s:Exit=1 PrjObj=##class(%Studio.Project).%OpenId(PrjName)
	for len=1:1:XMLObj.Items.ProjectItem.%Size(){
		s OneObj=XMLObj.Items.ProjectItem.%Get(len)
		s name=OneObj."name"
		s type=OneObj."type"
		;添加到工程
		d PrjObj.AddItem(name)
	}
	s Status=PrjObj.%Save()
	Q Status
}

}
