/// Creator:yyx
/// CreateDate:2011-01-06
/// Function:计算年龄	
Class CHSSWeb.DTHealthCommon Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right, Not ProcedureBlock ]
{

/// Creator：yyx
/// CreateDate:2011-01-06
/// Function :根据当前日期出生日期结算年龄
ClassMethod GetAgeDesc(DOB As %String, CalDate As %String) As %String
{
	q:DOB="" ""
	i DOB["/" s DOB=$zdh(DOB,4)
	i DOB["-" s DOB=$zdh(DOB,3)
	i CalDate["/" s CalDate=$zdh(CalDate,4)
	i CalDate["-" s CalDate=$zdh(CalDate,3)
	i CalDate="" s CalDate=+$h
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

/// creator:haiwenbo
/// date:2011-10-27
/// description: 卡位数不够时，卡号前自动补零
/// input:  CardType(卡类型)  CardNo(卡号)
/// output: 补零后CardNo
/// others:
ClassMethod FormatPatientNo(CardType As %String, CardNo As %String) As %String
{
	;s CFCardType = $p(^DHCCARDTYPEDef(CardType),"^",2)
	;i CardType = 1 d
	s len=$l(CardNo)
	For i = 1:1:(8-len) {
		s CardNo="0"_CardNo
	}
	Q CardNo
}

/// creator:zhangyong
/// date:2011-10-19
/// description: 读取卡信息
/// input:  CardType(卡类型)  CardNo(卡号)
/// output: String  卡号^RowId号^身份证号^登记号^卡类型DR^卡类型^姓名^生日^年龄^性别Rowid^性别Description^婚姻状况^手机^病人类型Rowid^病人类型Code^病人类型Desc^职业^学历^email
/// others: 身份证号
/// edit by :haiwenbo 2011-11-3
ClassMethod GetPatInfoFromCardNo(CardType As %Library.String, CardNo As %Library.String) As %Library.String
{
	s CFCardNo = ""
	s CFPAPMIDR = ""
	s CFIDCardNo = ""
	s CFPAPMINo = ""
	s CFCardTypeDR = ""
	s CFCardType = ""
	s PapmiName = ""
	;s PAPERId = ""
	s PapmiDOB = ""
	s PapmAge = ""
	s PapmiSex = ""
	s PapmiSexName = ""
	s PAPERMaritalDR = ""
	s PAPMIMobPhone = ""
	s PAPERSocialStatusDR = ""
	s PAPERSocialStatusCode = ""
	s PAPERSocialStatusDesc = ""
	s PAPEROccupationDR = ""
	s PAPEREducationDR = ""
	s PAPEREmail = ""

	SET resultString = ""
	IF CardType="1" DO
	.set mycardid = ""
	.s mycardid=$o(^DHCCARDi("CF",0,"CardTypeNo",CardType, CardNo, mycardid)) 
	.q:mycardid=""
	.s Card = ^DHCCARD("CF",mycardid)
	.s CFCardNo = $p(Card,"^",2)  //卡号
	.s CFPAPMIDR = $p(Card,"^",4)  //rowid号 
	.s CFIDCardNo = $p(Card,"^",5)  //身份证号
	.s CFPAPMINo = $p(Card,"^",6)    //登记号
	.s CFCardTypeDR = $p(Card,"^",16) //卡类型DR
	.set CFCardType = $p(^DHCCARDTYPEDef(CFCardTypeDR),"^",2) //卡类型
	.SET Pat = ^PAPER(CFPAPMIDR, "ALL")  //表PA_Person（类User.PAPerson）
	.SET PapmiName = $P(Pat,"^",1)  //姓名
	.;s PAPERId = $P(Pat,"^",9)  //身份证号
	.SET PapmiDOB = $ZD($P(Pat,"^",6),3)  //生日YYYY-MM-DD
	.SET PapmAge = ##class(CHSSWeb.DTHealthCommon).GetAgeDesc($P($G(Pat),"^",6) , "")  //年龄
	.s PapmiSex = $P(Pat,"^",7)  //性别Rowid
	.SET PapmiSexName = $P(^CT("SEX",$P(Pat,"^",7)),"^",2)  //性别Description
	.S PAPERMaritalDR = $P(^PAPER(CFPAPMIDR, "PER", 2),"^", 3)  //婚姻状况
	.;set RIDCardNo = $p($g(Pat),"^",9)
	.;set PatYBCode=$p($g(Pat),"^",19)
	.s PAPMIMobPhone = $P(Pat,"^",21)  //手机
	.s PAPERSocialStatusDR = $P(^PAPER(CFPAPMIDR,"PER",1),"^",10)  //病人类型Rowid
	.s PAPERSocialStatusCode = $P($g(^CT("SS",PAPERSocialStatusDR)),"^",1) //病人类型Code
	.s PAPERSocialStatusDesc =  $P($g(^CT("SS",PAPERSocialStatusDR)),"^",2) //病人类型description
	.s PAPEROccupationDR = $P(^PAPER(CFPAPMIDR,"PER",2),"^",6) //职业
	.s PAPEREducationDR = $P(^PAPER(CFPAPMIDR,"PER",2),"^",5) //学历
	.s PAPEREmail = $P(^PAPER(CFPAPMIDR,"PER",4),"^",19)  //email
	
	SET resultString=CFCardNo_"^"_CFPAPMIDR_"^"_CFIDCardNo_"^"_CFPAPMINo_"^"_CFCardTypeDR_"^"_CFCardType_"^"_PapmiName_"^"_PapmiDOB_"^"_PapmAge_"^"_PapmiSex_"^"_PapmiSexName_"^"_PAPERMaritalDR_"^"_PAPMIMobPhone_"^"_PAPERSocialStatusDR_"^"_PAPERSocialStatusCode_"^"_PAPERSocialStatusDesc_"^"_PAPEROccupationDR_"^"_PAPEREducationDR_"^"_PAPEREmail
	Q resultString
}

/// creator:zhangyong
/// date:2011-10-19
/// description: 读取卡信息
/// input:  PapmiNo(登记号)
/// output: String RowId号^登记号^姓名^身份证号^生日^年龄^性别Rowid^性别Description^婚姻状况^手机^病人类型Rowid^病人类型Code^病人类型description^职业^学历^email
/// others:
ClassMethod GetPatInfoFromPapmiNo(PapmiNo As %Library.String) As %Library.String
{
	SET resultString = ""
	SET RowId = ""
	SET RowId = $O(^PAPERi("PAPMI_PatNo",PapmiNo,"")) //Rowid号
	quit:RowId="" resultString
	SET CFPAPMINo = PapmiNo  //登记号
	SET Pat = ^PAPER(RowId, "ALL")
	SET PapmiName = $P(Pat,"^",1) //姓名
	s CFIDCardNo = $P(Pat,"^",9)  //身份证号
	SET PapmiDOB = $ZD($P(Pat,"^",6),3)  //生日YYYY-MM-DD
	SET PapmAge = ##class(CHSSWeb.DTHealthCommon).GetAgeDesc($P($G(^PAPER(RowId,"ALL")),"^",6) , "") //年龄
	s PapmiSex = $P(Pat,"^",7)  //性别Rowid
	SET PapmiSexName = $P(^CT("SEX",$P(Pat,"^",7)),"^",2) //性别Description
	S PAPERMaritalDR = $P(^PAPER(RowId, "PER", 2),"^", 3)  //婚姻状况
	;set RIDCardNo = $p($g(Pat),"^",9)
	;set PatYBCode=$p($g(Pat),"^",19)
	s PAPMIMobPhone = $P(Pat,"^",21)  //手机
	s PAPERSocialStatusDR = $P(^PAPER(RowId,"PER",1),"^",10)  //病人类型Rowid
	s PAPERSocialStatusCode = $P($g(^CT("SS",PAPERSocialStatusDR)),"^",1) //病人类型Code
	s PAPERSocialStatusDesc =  $P($g(^CT("SS",PAPERSocialStatusDR)),"^",2) //病人类型description
	s PAPEROccupationDR = $P(^PAPER(RowId,"PER",2),"^",6) //职业
	s PAPEREducationDR = $P(^PAPER(RowId,"PER",2),"^",5) //学历
	s PAPEREmail = $P(^PAPER(RowId,"PER",4),"^",19)  //email
	
	SET resultString=RowId_"^"_CFPAPMINo_"^"_PapmiName_"^"_CFIDCardNo_"^"_PapmiDOB_"^"_PapmAge_"^"_PapmiSex_"^"_PapmiSexName_"^"_PAPERMaritalDR_"^"_PAPMIMobPhone_"^"_PAPERSocialStatusDR_"^"_PAPERSocialStatusCode_"^"_PAPERSocialStatusDesc_"^"_PAPEROccupationDR_"^"_PAPEREducationDR_"^"_PAPEREmail
	Q resultString
}

}
