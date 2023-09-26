/// 为卡注册作的基础数据类
Class web.DHCBL.CTBASE.CTCardRegLB Extends (DHCDoc.Util.RegisteredObject, %RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// 类名称参数
Parameter ClassName;

Parameter ListSplitStr = "$c(1)";

Parameter ValueSplitStr = "^";

/// /这个类主要用来支持 返回 下拉框的数据 ，
/// /返回到数据库时， 是一个字符串， 
/// /由 JS生成一个数组， 绑定的控件中
/// /有 默认值得选择 （考虑中）
/// /
Query GetCTCityInfo(CITCode As %String = "", CTProvinceDR As %String) As %SQLQuery(CONTAINID = 1)
{
	SELECT CTCIT_RowId, CTCIT_Desc FROM SQLUser.CT_City
	where UPPER(CTCIT_Desc) %STARTSWITH UPPER(:CITCode) and CTCIT_Province_DR = :CTProvinceDR
}

ClassMethod ReadCTCityInfo(CTProvinceDR As %String) As %String
{
	;1 读取基本信息
	;2 读取默认信息
	;^CT("CIT",0,"ProvCode",{CTCIT_Province_DR},                       x
	;x           $$ALPHAUP({CTCIT_Code}),{CTCIT_RowId})
	;w ##class(web.DHCBL.CTBASE.CTCardRegLB).ReadCTCityInfo("")
	q:(CTProvinceDR="") ""
	
	s myobj=##class(web.DHCEntity.CTBASE.ComboListObject).%New()
	s Code=""
	s myrtn=""
	s myCode=""
	s myDesc=""
	s myDefaultFlag=0
	s myDefRowID=0
	s myDefInfo=##class(web.DHCBL.CARD.UCardPATRegConfig).GetDefaultCity()
	s myDefRowID=$p(myDefInfo,"^",1)
	
	f  s Code=$o(^CT("CIT",0,"ProvCode",CTProvinceDR, Code))  q:(Code="")  d
	.s myRowID=0
	.f  s myRowID=$o(^CT("CIT",0,"ProvCode",CTProvinceDR, Code, myRowID))  q:(myRowID="")  d
	..;^CT("CIT",{CTCIT_RowId})
	..s myCode=$p(^CT("CIT",myRowID),"^",1)
	..s myDesc=$p(^CT("CIT",myRowID),"^",2)
	..s DateFrom=$p(^CT("CIT",myRowID),"^",5)
	..q:(DateFrom'="")&&(DateFrom>+$H)
	..s DateTo=$p(^CT("CIT",myRowID),"^",6)
	..q:(DateTo'="")&&(DateTo<+$H)
	..s Active=$p(^CT("CIT",myRowID),"^",11)
	..q:Active'="Y"
	..i myRowID=myDefRowID d
	...s myDefaultFlag=1
	..;w myDesc,!
	..s AliasAtr=##class(DHCDoc.Util.Base).GetAliasByTabName("CT_City",myRowID)
	..d myobj.Put(myRowID,myDesc,myDefaultFlag,AliasAtr)
	..s myDefaultFlag=0
	
	s myrtn=myobj.GetListValue()
	
	d myobj.%Close()
	
	q myrtn
}

/// 读取国家信息
ClassMethod ReadCTCountryInfo() As %String
{
	;w ##class(web.DHCBL.CTBASE.CTCardRegLB).ReadCTCountryInfo()
	s myobj=##class(web.DHCEntity.CTBASE.ComboListObject).%New()
	
	s myrtn=""
	s myCode=""
	s myDesc=""
	s myDefaultFlag=0
	s myDefRowID=0
	s myDefInfo=##class(web.DHCBL.CARD.UCardPATRegConfig).GetDefaultCountry()
	s myDefRowID=$p(myDefInfo,"^",1)
	
	;^CT("COU",{CTCOU_RowId})
	s myRowID=0
	f  s myRowID=$o(^CT("COU", myRowID))  q:(myRowID="")  d
	.;^CT("CIT",{CTCIT_RowId})
	.s myCode=$p(^CT("COU", myRowID),"^",1)
	.s myDesc=$p(^CT("COU", myRowID),"^",2)
	.s CTCOUActive=$p(^CT("COU", myRowID),"^",3)
	.q:CTCOUActive'="Y"
	.s DateActiveFrom=$p(^CT("COU", myRowID),"^",4)
	.q:(DateActiveFrom>+$h)&&(DateActiveFrom'="")
	.s DateActiveTo=$p(^CT("COU", myRowID),"^",5)
	.q:(DateActiveTo<+$h)&&(DateActiveTo'="")
	.i myRowID=myDefRowID d
	..s myDefaultFlag=1
	.s AliasAtr=##class(DHCDoc.Util.Base).GetAliasByTabName("CT_Country",myRowID)
	.d myobj.Put(myRowID,myCode_"-"_myDesc,myDefaultFlag,AliasAtr)
	.s myDefaultFlag=0
	
	s myrtn=myobj.GetListValue()
	
	d myobj.%Close()
	
	q myrtn
}

ClassMethod ReadCTNationInfo() As %String
{
	;GetDefaultNation
	s myobj=##class(web.DHCEntity.CTBASE.ComboListObject).%New()
	
	s myrtn=""
	s myCode=""
	s myDesc=""
	s myDefaultFlag=0
	s myDefRowID=0
	s myDefInfo=##class(web.DHCBL.CARD.UCardPATRegConfig).GetDefaultNation()
	s myDefRowID=$p(myDefInfo,"^",1)
	
	;^CT("COU",{CTCOU_RowId})
	s myRowID=0
	f  s myRowID=$o(^CT("NAT", myRowID))  q:(myRowID="")  d
	.;^CT("NAT",{CTCIT_RowId})
	.s myCode=$p(^CT("NAT", myRowID),"^",1)
	.s myDesc=$p(^CT("NAT", myRowID),"^",2)
	.s Active=$p(^CT("NAT", myRowID),"^",6)
	.q:Active'="Y"
	.s DateActiveFrom=$p(^CT("NAT", myRowID),"^",7)
	.s DateActiveTo=$p(^CT("NAT", myRowID),"^",8)
	.q:(DateActiveFrom>+$h)&&(DateActiveFrom'="")
	.q:(DateActiveTo<+$h)&&(DateActiveTo'="")
	
	.i myRowID=myDefRowID d
	..s myDefaultFlag=1
	.s AliasAtr=##class(DHCDoc.Util.Base).GetAliasByTabName("CT_Nation",myRowID)
	.d myobj.Put(myRowID,myDesc,myDefaultFlag,AliasAtr)
	.s myDefaultFlag=0
	
	s myrtn=myobj.GetListValue()
	
	d myobj.%Close()
	
	q myrtn
}

ClassMethod ReadCTOccupationInfo() As %String
{
	;GetDefaultNation
	s myobj=##class(web.DHCEntity.CTBASE.ComboListObject).%New()
	
	s myrtn=""
	s myCode=""
	s myDesc=""
	s myDefaultFlag=0
	s myDefRowID=0
	
	s myDefRowID=0			;$p(myDefInfo,"^",1)
	
	;^CT("OCC",{CTCOU_RowId})
	s myRowID=0
	f  s myRowID=$o(^CT("OCC", myRowID))  q:(myRowID="")  d
	.;^CT("OCC",{CTCIT_RowId})
	.s myCode=$p(^CT("OCC", myRowID),"^",1)
	.s myDesc=$p(^CT("OCC", myRowID),"^",2)
	.i myRowID=myDefRowID d
	..s myDefaultFlag=1
	.d myobj.Put(myRowID,myDesc,myDefaultFlag)
	.s myDefaultFlag=0
	
	s myrtn=myobj.GetListValue()
	
	d myobj.%Close()
	
	q myrtn
}

ClassMethod ReadCTProvinceInfo(CTCountryDR As %String) As %String
{
	;w ##class(web.DHCBL.CTBASE.CTCardRegLB).ReadCTProvinceInfo(1)
	s myobj=##class(web.DHCEntity.CTBASE.ComboListObject).%New()
	d myobj.Put("","",0)
	s myrtn=""
	s myCode=""
	s myDesc=""
	s myDefaultFlag=0
	s myDefRowID=0
	s myDefInfo=##class(web.DHCBL.CARD.UCardPATRegConfig).GetDefaultProvince()
	s myDefRowID=$p(myDefInfo,"^",1)
	
	;
	s myRowID=0
	;^CT("RG",{CTRG_RowId})
	s myRegRowID=0
	f  s myRegRowID=$o(^CT("RG", myRegRowID))  q:(myRegRowID="")  d
	.s myCountryDR=$p(^CT("RG", myRegRowID),"^", 4)
	.q:((CTCountryDR'=myCountryDR)&&(myCountryDR'=""))
	.;^CT("PROV",{PROV_RowId})
	.s myRowID=0
	.f  s myRowID=$o(^CT("PROV", myRowID))  q:(myRowID="")  d
	..s myRegProDR=$p(^CT("PROV", myRowID),"^",3)
	..q:(myRegProDR'=myRegRowID)
	..s Active=$p(^CT("PROV", myRowID),"^",10)
	..q:Active'="Y"
	..s myCode=$p(^CT("PROV", myRowID),"^",1)
	..s myDesc=$p(^CT("PROV", myRowID),"^",2)
	..s DateFrom=$p(^CT("PROV", myRowID),"^",4)
	..q:(DateFrom'="")&&(DateFrom>+$h)
	..s DateTo=$p(^CT("PROV", myRowID),"^",5)
	..q:(DateTo'="")&&(DateTo<+$h)

	..i myRowID=myDefRowID d
	...s myDefaultFlag=1
	..s AliasAtr=##class(DHCDoc.Util.Base).GetAliasByTabName("CT_Province",myRowID)
	..d myobj.Put(myRowID,myDesc,myDefaultFlag,AliasAtr)
	..s myDefaultFlag=0
	..
	
	s myrtn=myobj.GetListValue()
	
	d myobj.%Close()
	
	q myrtn
}

ClassMethod ReadCTRelationInfo() As %String
{
	;w ##class(web.DHCBL.CTBASE.CTCardRegLB).ReadCTRelationInfo()
	s myobj=##class(web.DHCEntity.CTBASE.ComboListObject).%New()
	Set langid=..%LanguageID()
	s myrtn=""
	s myCode=""
	s myDesc=""
	s myDefaultFlag=0
	s myDefRowID=0
	s myDefInfo=##class(web.DHCBL.CARD.UCardPATRegConfig).GetDefaultRelation()
	s myDefRowID=$p(myDefInfo,"^",1)
	
	;^CT("RLT",{CTRLT_RowId})
	d myobj.Put("","",1)
	
	s myRowID=0
	f  s myRowID=$o(^CT("RLT", myRowID))  q:(myRowID="")  d
	.s myCode=$p(^CT("RLT", myRowID),"^",1)
	.s myDesc=$p(^CT("RLT", myRowID),"^",2)
	.Set myDesc= ##class(User.CTRelation).GetTranByDesc("CTRLTDesc",myDesc,langid)
	.s DateFrom=$p(^CT("RLT", myRowID),"^",3)
	.q:(DateFrom'="")&&(DateFrom>+$H)
	.s DateTo=$p(^CT("RLT", myRowID),"^",4)
	.q:(DateTo'="")&&(DateTo<+$H)
	.i myRowID=myDefRowID d
	..s myDefaultFlag=1
	.d myobj.Put(myRowID,myDesc,myDefaultFlag)
	.s myDefaultFlag=0
	
	s myrtn=myobj.GetListValue()
	
	d myobj.%Close()
	
	q myrtn
}

/// 职业
ClassMethod ReadOccupationInfo() As %String
{
	s myobj=##class(web.DHCEntity.CTBASE.ComboListObject).%New()
	
	s myrtn=""
	s myCode=""
	s myDesc=""
	s myDefaultFlag=0
	s myDefRowID=0
	;s myDefInfo=##class(web.DHCBL.CARD.UCardPATRegConfig).GetDefaultRelation()
	s myDefRowID=""
	
	d myobj.Put("","",1)
	;^CT("OCC",{CTRLT_RowId})
	s myRowID=0
	f  s myRowID=$o(^CT("OCC", myRowID))  q:(myRowID="")  d
	.s myCode=$p(^CT("OCC", myRowID),"^",1)
	.s myDesc=$p(^CT("OCC", myRowID),"^",2)
	.s DateFrom=$p(^CT("OCC", myRowID),"^",3)
	.q:(DateFrom'="")&&(DateFrom>+$H)
	.s DateTo=$p(^CT("OCC", myRowID),"^",4)
	.q:(DateTo'="")&&(DateTo<+$H)
	.s Active=$p(^CT("OCC", myRowID),"^",6)
	.q:Active'="Y"
	.i myRowID=myDefRowID d
	..s myDefaultFlag=1
	.s AliasStr=##class(DHCDoc.Util.Base).GetAliasByTabName("CT_Occupation",myRowID)
	.d myobj.Put(myRowID,myDesc,myDefaultFlag,AliasStr)
	.s myDefaultFlag=0
	
	s myrtn=myobj.GetListValue()
	
	d myobj.%Close()
	
	q myrtn
}

ClassMethod ReadZipInfo(ProvinceDR As %String, CityDR As %String, CityAreaDR As %String) As %String
{
	;w ##class(web.DHCBL.CTBASE.CTCardRegLB).ReadZipInfo(ProvinceDR,CityDR,CityAreaDR)
	s myrtn=""
	
	s myxml=""
	s myZipRowID=""
	s myZipCode=""
	s myDefaultFlag=0
	s myobj=##class(web.DHCEntity.CTBASE.ComboListObject).%New()
	
	s myfflag=0
	i (CityAreaDR'="")&&(+myfflag=0) d
	.s myZipRowID=""
	.f  s myZipRowID=$o(^CT("ZIP",0,"CityArea",CityAreaDR,myZipRowID)) q:myZipRowID=""  d
	..s myfflag=1
	..s DateFrom=$p(^CT("ZIP", myZipRowID),"^", 15)
	..q:(DateFrom'="")&&(DateFrom>+$H)
	..s DateTo=$p(^CT("ZIP", myZipRowID),"^", 16)
	..q:(DateTo'="")&&(DateTo<+$H)
	..s myZipCode=$p(^CT("ZIP", myZipRowID),"^", 1)
	..//s myDefaultFlag=1
	..d myobj.Put(myZipRowID,myZipCode,myDefaultFlag)
	..//s myxml=myobj.GetListValue()
	
	i (CityDR'="")&&(+myfflag=0) d
	.s myZipRowID=""
	.f  s myZipRowID=$o(^CT("ZIP",0,"City",CityDR,myZipRowID)) q:myZipRowID=""  d
	..s myfflag=1
	..s DateFrom=$p(^CT("ZIP", myZipRowID),"^", 15)
	..q:(DateFrom'="")&&(DateFrom>+$H)
	..s DateTo=$p(^CT("ZIP", myZipRowID),"^", 16)
	..q:(DateTo'="")&&(DateTo<+$H)
	..s myZipCode=$p(^CT("ZIP", myZipRowID),"^", 1)
	..//s myDefaultFlag=1
	..d myobj.Put(myZipRowID,myZipCode,myDefaultFlag)
	..//s myxml=myobj.GetListValue()
	
	
	;找出定义退出
	
	i (ProvinceDR'="")&&(+myfflag=0) d
	.s myZipRowID=""
	.f  s myZipRowID=$o(^CT("ZIP",0,"Prov",ProvinceDR,myZipRowID)) q:myZipRowID=""  d
	..s myfflag=1
	..s DateFrom=$p(^CT("ZIP", myZipRowID),"^", 15)
	..q:(DateFrom'="")&&(DateFrom>+$H)
	..s DateTo=$p(^CT("ZIP", myZipRowID),"^", 16)
	..q:(DateTo'="")&&(DateTo<+$H)
	..s myZipCode=$p(^CT("ZIP", myZipRowID),"^", 1)
	..//s myDefaultFlag=1
	..d myobj.Put(myZipRowID,myZipCode,myDefaultFlag)
	..//s myxml=myobj.GetListValue()
	s myxml=myobj.GetListValue()
	s myrtn=myxml
	
	q myrtn
}

// 得到保险信息

// w ##class(web.DHCBL.CTBASE.CTCardRegLB).ReadInsuranceInfo()

ClassMethod ReadInsuranceInfo() As %String
{
	s myobj=##class(web.DHCEntity.CTBASE.ComboListObject).%New()
	
	s myrtn=""
	s myCode=""
	s myDesc=""
	s myDefaultFlag=0
	s myDefRowID=0
	//s myDefInfo=##class(web.DHCBL.CARD.UCardPATRegConfig).GetDefaultNation()
	//s myDefRowID=$p(myDefInfo,"^",1)
	d myobj.Put("","",myDefaultFlag)
	;^ARC("INST",{INST_RowId})
	s myRowID=0
	f  s myRowID=$o(^ARC("INST", myRowID))  q:(myRowID="")  d
	.s myCode=$p(^ARC("INST", myRowID),"^",1)
	.s myDesc=$p(^ARC("INST", myRowID),"^",2)
	.s dateFrom=$p(^ARC("INST", myRowID),"^",13)
	.q:dateFrom>+$H
	.s dateTo=$p(^ARC("INST", myRowID),"^",14)
	.q:(dateTo'="")&&(dateTo<+$H)
	.i myRowID=myDefRowID d
	..s myDefaultFlag=1
	.d myobj.Put(myRowID,myDesc_"-"_myCode,myDefaultFlag)
	.s myDefaultFlag=0
	
	s myrtn=myobj.GetListValue()
	
	d myobj.%Close()
	
	q myrtn
}

// 得到保险信息

// w ##class(web.DHCBL.CTBASE.CTCardRegLB).ReadAdmReasonInfo("5^aa")

ClassMethod ReadAdmReasonInfo(PatInfo As %String = "") As %String
{
	s myobj=##class(web.DHCEntity.CTBASE.ComboListObject).%New()
	
	s PatDr=$P(PatInfo,"^",1)
	s PatType=$P(PatInfo,"^",2)
	s myBMRowid=0
	s mydes=""
	s myval=""
	s myDefaultFlag=0
	s myIdx=0
	;s PatientNo=..FormatPatientNo(PatientNo)
	;Set PatDr=$o(^PAPERi("PAPMI_PatNo",$ZCVT(PatientNo,"U"),""))
	Quit:PatDr="" ""
	i PatType="PatTypeID" d
	.if $D(^PAPER(PatDr,"PER",1)) d
 	..Set PAPERStateCodeDR=$p(^PAPER(PatDr,"PER",1),"^",10)
 	e  d
 	.Set PAPERStateCodeDR=PatDr
 	f  s myBMRowid=$o(^DHCPACADM(0,"Social",PAPERStateCodeDR,myBMRowid)) q:(myBMRowid="")  d
	.if $D(^DHCPACADM(myBMRowid)) d
	..s myRowID=$p(^DHCPACADM(myBMRowid),"^",2)
	..s myCode=$p(^PAC("ADMREA", myRowID),"^",1)
	..s myDesc=$p(^PAC("ADMREA", myRowID),"^",2)
	..;q:(##class(web.DHCDocHardCoded).GetInternationFlag()="1")&&(myDesc["医保")
	..;q:(##class(web.DHCDocHardCoded).GetInternationFlag()="0")&&(myDesc["保险")
	..s dateFrom=$p(^PAC("ADMREA", myRowID),"^",3)
	..q:dateFrom>+$H
	..s dateTo=$p(^PAC("ADMREA", myRowID),"^",4)
	..q:(dateTo'="")&&(dateTo<+$H)
	..;i myRowID=myDefRowID d
	..;.s myDefaultFlag=1
	..d myobj.Put(myRowID,myDesc_"-"_myCode,myDefaultFlag)
	..s myDefaultFlag=0
	
	s myrtn=myobj.GetListValue()
	
	d myobj.%Close()
	
	q myrtn
}

// 得到合同单位信息

// w ##class(web.DHCBL.CTBASE.CTCardRegLB).ReadHealthCareProviderInfo()

ClassMethod ReadHealthCareProviderInfo() As %String
{
	s myobj=##class(web.DHCEntity.CTBASE.ComboListObject).%New()
	
	s myrtn=""
	s myCode=""
	s myDesc=""
	s myDefaultFlag=0
	s myDefRowID=0
	//s myDefInfo=##class(web.DHCBL.CARD.UCardPATRegConfig).GetDefaultNation()
	//s myDefRowID=$p(myDefInfo,"^",1)
	d myobj.Put("","",myDefaultFlag)
	;^CT("HCP",{HCP_RowId})
	s myRowID=0
	f  s myRowID=$o(^CT("HCP", myRowID))  q:(myRowID="")  d
	.s myCode=$p(^CT("HCP", myRowID),"^",1)
	.s myDesc=$p(^CT("HCP", myRowID),"^",2)
	.i myRowID=myDefRowID d
	..s myDefaultFlag=1
	.d myobj.Put(myRowID,myDesc_"-"_myCode,myDefaultFlag)
	.s myDefaultFlag=0
	
	s myrtn=myobj.GetListValue()
	d myobj.%Close()
	q myrtn
}

ClassMethod ReadCTMaritalInfo() As %String
{
	s myobj=##class(web.DHCEntity.CTBASE.ComboListObject).%New()
	
	s myrtn=""
	s myCode=""
	s myDesc=""
	s myDefaultFlag=0
	s myDefRowID=0
	//s myDefInfo=##class(web.DHCBL.CARD.UCardPATRegConfig).GetDefaultNation()
	//s myDefRowID=$p(myDefInfo,"^",1)
	d myobj.Put("","",myDefaultFlag)
	;^CT("MAR",{CTMAR_RowId})
	s myRowID=0
	f  s myRowID=$o(^CT("MAR", myRowID))  q:(myRowID="")  d
	.s myCode=$p(^CT("MAR", myRowID),"^",1)
	.s myDesc=$p(^CT("MAR", myRowID),"^",2)
	.s dateFrom=$p(^CT("MAR", myRowID),"^",4)
	.q:dateFrom>+$H
	.s dateTo=$p(^CT("MAR", myRowID),"^",5)
	.q:(dateTo'="")&&(dateTo<+$H)
	.s Active=$p(^CT("MAR", myRowID),"^",6)
	.q:Active'="Y"
	.i myRowID=myDefRowID d
	..s myDefaultFlag=1
	.s AliasAtr=##class(DHCDoc.Util.Base).GetAliasByTabName("CT_Marital",myRowID)
	.d myobj.Put(myRowID,myDesc_"-"_myCode,myDefaultFlag,AliasAtr)
	.s myDefaultFlag=0
	
	s myrtn=myobj.GetListValue()
	d myobj.%Close()
	q myrtn
}

ClassMethod ReadHealthCareRegionInfo() As %String
{
	s myobj=##class(web.DHCEntity.CTBASE.ComboListObject).%New()
	
	s myrtn=""
	s myCode=""
	s myDesc=""
	s myDefaultFlag=0
	s myDefRowID=0
	//s myDefInfo=##class(web.DHCBL.CARD.UCardPATRegConfig).GetDefaultNation()
	//s myDefRowID=$p(myDefInfo,"^",1)
	d myobj.Put("","",myDefaultFlag)
	;^CT("HCR",{HCR_RowId})
	s myRowID=0
	f  s myRowID=$o(^CT("HCR", myRowID))  q:(myRowID="")  d
	.s myCode=$p(^CT("HCR", myRowID),"^",1)
	.s myDesc=$p(^CT("HCR", myRowID),"^",2)
	.s dateFrom=$p(^CT("HCR", myRowID),"^",3)
	.q:+dateFrom>+$H
	.s dateTo=$p(^CT("HCR", myRowID),"^",4)
	.q:(dateTo'="")&&(dateTo<+$H)
	.i myRowID=myDefRowID d
	..s myDefaultFlag=1
	.d myobj.Put(myRowID,myDesc_"-"_myCode,myDefaultFlag)
	.s myDefaultFlag=0
	
	s myrtn=myobj.GetListValue()
	d myobj.%Close()
	q myrtn
}

// w ##class(web.DHCBL.CTBASE.CTCardRegLB).ReadCTAreaInfo("1482")

ClassMethod ReadCTAreaInfo(CityDR)
{
	q:CityDR="" ""
	s myobj=##class(web.DHCEntity.CTBASE.ComboListObject).%New()
	
	s myrtn=""
	s myCode=""
	s myDesc=""
	s myDefaultFlag=0
	s myDefRowID=0
	s Code=""
	f  s Code=$o(^CT("CITAREA",0,"CityCode",CityDR, Code))  q:(Code="")  d
	.s myRowID=0
	.f  s myRowID=$o(^CT("CITAREA",0,"CityCode",CityDR,Code,myRowID))  q:(myRowID="")  d
	..s myCode=$p(^CT("CITAREA", myRowID),"^",1)
	..s myDesc=$p(^CT("CITAREA", myRowID),"^",2)
	..s dateFrom=$p(^CT("CITAREA", myRowID),"^",4)
	..q:+dateFrom>+$H
	..s dateTo=$p(^CT("CITAREA", myRowID),"^",5)
	..q:(dateTo'="")&&(dateTo<+$H)
	..s Active=$p(^CT("CITAREA", myRowID),"^",9)
	..q:Active'="Y"
	..i myRowID=myDefRowID d
	...s myDefaultFlag=1
	..s AliasAtr=##class(DHCDoc.Util.Base).GetAliasByTabName("CT_CityArea",myRowID)
	..d myobj.Put(myRowID,myDesc,myDefaultFlag,AliasAtr)
	..s myDefaultFlag=0
	d myobj.Put("","",0)
	
	s myrtn=myobj.GetListValue()
	d myobj.%Close()
	q myrtn
}

ClassMethod ReadPoliticalLevelInfo() As %String
{
	s myobj=##class(web.DHCEntity.CTBASE.ComboListObject).%New()
	
	s myrtn=""
	s myDefaultFlag=0
	d myobj.Put("","",myDefaultFlag)
	
	s myRowID=0
	f  s myRowID=$o(^CT("EMF",myRowID))  q:(myRowID="")  d
	.s myCode=$p($g(^CT("EMF",myRowID)),"^",1)
	.s myDesc=$p($g(^CT("EMF",myRowID)),"^",2)
	.s ActiveFlag=$p($g(^CT("EMF",myRowID)),"^",3)
	.q:(ActiveFlag'="")&&(ActiveFlag'="Y")
	.d myobj.Put(myRowID,myDesc_"-"_myCode,myDefaultFlag)
	.s myDefaultFlag=0
	
	s myrtn=myobj.GetListValue()
	d myobj.%Close()
	q myrtn
}

ClassMethod ReadSecretLevelInfo() As %String
{
	s myobj=##class(web.DHCEntity.CTBASE.ComboListObject).%New()
	
	s myrtn=""
	s myDefaultFlag=0
	d myobj.Put("","",myDefaultFlag)
	
	s myRowID=0
	f  s myRowID=$o(^User.DHCSecretLevelD(myRowID))  q:(myRowID="")  d
	.s myCode=$list(^User.DHCSecretLevelD(myRowID),2)
	.s myDesc=$list(^User.DHCSecretLevelD(myRowID),3)
	.d myobj.Put(myRowID,myDesc_"-"_myCode,myDefaultFlag)
	.s myDefaultFlag=0
	
	s myrtn=myobj.GetListValue()
	d myobj.%Close()
	q myrtn
}

/// 合同单位
ClassMethod ReadHCPDRInfo(HospId As %String = "") As %String
{
	if (HospId="")&&($d(%session)){
		s HospId=%session.Data("LOGON.HOSPID")
	}
	s myobj=##class(web.DHCEntity.CTBASE.ComboListObject).%New()
	s myrtn=""
	s myDefaultFlag=0
	d myobj.Put("","",myDefaultFlag)
	s myRowID=0
	f  s myRowID=$o(^CT("HCP",myRowID))  q:(myRowID="")  d
	.s myCode=$P(^CT("HCP",myRowID),"^",1)
	.s myDesc=$P(^CT("HCP",myRowID),"^",2)
	.s HCPActiveFlag=$P(^CT("HCP",myRowID),"^",6)
	.q:HCPActiveFlag'="Y"
	.s ShowDataFlag=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("CT_HealthCareProvider",myRowID,HospId)
	.Q:ShowDataFlag'="Y"
	.d myobj.Put(myRowID,myDesc,myDefaultFlag)
	.s myDefaultFlag=0
	s myrtn=myobj.GetListValue()
	d myobj.%Close()
	q myrtn
}

/// creator:郭荣勇
/// date:2015-12-11
/// desc:使用统一到一张表的省市区,县,街道维护代码
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CTBASE.CTCardRegLB","QueryUnifyAddress","dh")
Query QueryUnifyAddress(desc As %String) As %Query(ROWSPEC = "AddressDesc:%String,AddressId:%String")
{
}

ClassMethod QueryUnifyAddressClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryUnifyAddressExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryUnifyAddressExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
    s desc=$$ALPHAUP^SSUTIL4(desc)
    If $g(ind)="" Set ind=1
	s provdesc="",rowid="0"
	
	s rowid="0"
	f  s rowid=$o(^CT("ADD",rowid))  q:rowid=""  d
	.s provdesc=$p(^CT("ADD",rowid),"^",2)
	.s SearchCode=$p(^CT("ADD",rowid),"^",8)
	.s provdesc1=$$ALPHAUP^SSUTIL4(provdesc)
	.s SearchCode1=$$ALPHAUP^SSUTIL4(SearchCode)
	.i $f(provdesc,"-")'=0  d
	..s provdesc=$p(provdesc,"-",2)
	.i desc'=""  d
	..i (provdesc1[desc)||(SearchCode1[desc)  d
	...i $f(provdesc,"-")'=0  d
    ....s provdesc=$p(provdesc,"-",2)
    ...d QueryUnifyAddressOut
 	.e  d
 	..i $f(provdesc,"-")'=0  d
    ...s provdesc=$p(provdesc,"-",2)
    ..d QueryUnifyAddressOut
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
QueryUnifyAddressOut
	set Data=$lb(provdesc,rowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryUnifyAddressFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryUnifyAddressExecute ]
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

/// creator:郭荣勇
/// date:2015-12-11
/// desc:通过统一到一张表地址id获取省市县街道.
/// ##class(web.DHCBL.CTBASE.CTCardRegLB).ReadUnifyAddressDetail(5)
ClassMethod ReadUnifyAddressDetail(AddressNewID)
{
	Q:AddressNewID="" ""
	///^CT("ADD",rowid)
	///CTADDProvinceDR   //省
	s CTADDProvinceDR=$p(^CT("ADD",AddressNewID),"^",3)
	s provdesc=""
	i CTADDProvinceDR'="" d
	.s provdesc=$p(^CT("PROV",CTADDProvinceDR),"^",2)
	.s:provdesc["-" provdesc=$p(provdesc,"-",2)
	///CTADDCityDR      //市
	s CTADDCityDR=$p(^CT("ADD",AddressNewID),"^",4)
	s citydesc=""
	if (CTADDCityDR'="") d
	.s citydesc=$p(^CT("CIT",CTADDCityDR),"^",2)
	.s:citydesc["-" citydesc=$p(citydesc,"-",2)
	///CTADDCityAreaDR  //区/县
	s CTADDCityAreaDR=$p(^CT("ADD",AddressNewID),"^",5)
	s ctdesc=""
	i CTADDCityAreaDR'="" d
	.i ($d(^CT("CITAREA",CTADDCityAreaDR))'=0) d
	..s ctdesc=$p(^CT("CITAREA",CTADDCityAreaDR),"^",2)
	..s:ctdesc["-" ctdesc=$p(ctdesc,"-",2)
	
	///Street   //街道
	s Street=$p(^CT("ADD",AddressNewID),"^",7)
	s StreetDesc=""
	i Street'="" d
	.s StreetDesc=$p(^CT("LOCTYPE",Street),"^",2)
	.s:StreetDesc["-" StreetDesc=$p(StreetDesc,"-",2)
	
	///Community   //社区
	s Community=$p(^CT("ADD",AddressNewID),"^",7)
	s CTZipDesc=""
	if CTADDCityDR'="" d
	.s CTZipInfo=..ReadZipInfo(CTADDProvinceDR,CTADDCityDR,CTADDCityAreaDR)
	.s CTZipDesc=$p(CTZipInfo,"$c(2)",2)
	q provdesc_"^"_CTADDProvinceDR_"^"_citydesc_"^"_CTADDCityDR_"^"_ctdesc_"^"_CTADDCityAreaDR_"^"_StreetDesc_"^"_Street_"^"_CTZipDesc
}

ClassMethod ReadCTLocalityType(CTAreaDR As %String) As %String
{
	;1 读取基本信息
	;2 读取默认信息
	;^CT("CIT",0,"ProvCode",{CTCIT_Province_DR},                       x
	;x           $$ALPHAUP({CTCIT_Code}),{CTCIT_RowId})
	;w ##class(web.DHCBL.CTBASE.CTCardRegLB).ReadCTLocalityType("1")
	q:(CTAreaDR="") ""
	
	s myobj=##class(web.DHCEntity.CTBASE.ComboListObject).%New()
	s Code=""
	s myrtn=""
	s myCode=""
	s myDesc=""
	s myDefaultFlag=0
	s myDefRowID=0
	s LOCTYPERowId=0
	
	f  s LOCTYPERowId=$o(^CT("LOCTYPE",LOCTYPERowId))  q:(LOCTYPERowId="")  d
	.
	.s CTAreaCode=$p(^CT("CITAREA",CTAreaDR),"^",1)
	.s LOCTYPENationalCode=$p(^CT("LOCTYPE",LOCTYPERowId),"^",3)
	.q:LOCTYPENationalCode'=CTAreaCode
	.s myCode=$p(^CT("LOCTYPE",LOCTYPERowId),"^",1)
	.s myDesc=$p(^CT("LOCTYPE",LOCTYPERowId),"^",2)
	.s Active=$p(^CT("LOCTYPE",LOCTYPERowId),"^",5)
    .q:Active'="Y"
	.s AliasAtr=##class(DHCDoc.Util.Base).GetAliasByTabName("CT_LocalityType",LOCTYPERowId)
	.d myobj.Put(LOCTYPERowId,myDesc,myDefaultFlag,AliasAtr)
	.s myDefaultFlag=0
	
	s myrtn=myobj.GetListValue()
	
	d myobj.%Close()
	
	q myrtn
}

}
