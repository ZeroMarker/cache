Class web.DHCBL.Patient.DHCPatientBuilder Extends (DHCDoc.Util.RegisteredObject, %XML.Adaptor) [ Inheritance = right, ProcedureBlock ]
{

ClassMethod DHCPatientUpdate(PAPersonInfo As %String, hospId As %String) As %String
{
	;更新基本信息按钮响应  做了更新2009-6-10
	TStart
	//s PPAPersonInfo=##class(web.DHCEntity.PCA.PAPerson).%New()
	//d PPAPersonInfo.XMLNodeDeserialize(.PPAPersonInfo,"TransContent",PAPersonInfo)
	s PPAPersonInfo=##class(web.DHCEntity.PCA.PATMAS).%New()
	d PPAPersonInfo.XMLNodeDeserialize(.PPAPersonInfo,"TransContent",PAPersonInfo)
	s PArowid=PPAPersonInfo.PAPMIRowID
	s PPAPersonInfo=..AddDHCEntityInfo(PAPersonInfo,PPAPersonInfo)
	//set patInfo=..SearchPatInfoByRowID(PArowid)
	//set OldDataObject=##class(web.DHCBL.Patient.DHCPatientUpdateLog).GetLogData("User.PAPatMas"_$c(2)_PArowid_"^"_"User.PAPerson"_$c(2)_PArowid)
	//set status=##class(web.DHCBL.Patient.DHCPatient).PAPersonUpdate(PPAPersonInfo)
	s status=##class(web.DHCBL.CARD.UCardPaPatMasInfo).SavePatInfo(PPAPersonInfo)
	if status="-100" {
		TRollback
		quit -100 
	}
	/*set UPpatInfo=..SearchPatInfoByRowID(PArowid)   
	s logInfo=..CheckPatInfoUpdate(patInfo,UPpatInfo)
	s flag=..AddDHCPatientUpdateLog(logInfo)  */
	if (..%IsValidMethod("web.DHCPE.PreIBIUpdate","UpdatePEInfoByHis"))  d
	.s PAPMINO=$P($G(^PAPER(PArowid,"PAT",1)),"^",1)
	.//PAPER_UserUpdate
	.s UserDr=$P($G(^PAPER(PArowid,"PER",4)),"^",7)
	.s:UserDr="" UserDr=$P($G(^PAPER(PArowid,"PER",5)),"^",18)
	.d ##class(web.DHCPE.PreIBIUpdate).UpdatePEInfoByHis(PAPMINO,UserDr,hospId)
	/*s UPUserDr=%session.Get("LOGON.USERID")
	i $IsObject(OldDataObject)  
	{
		set flag=##class(web.DHCBL.Patient.DHCPatientUpdateLog).SaveUpdLog(OldDataObject,"User.PAPatMas"_$c(2)_PArowid_"^"_"User.PAPerson"_$c(2)_PArowid,UPUserDr)
	}           
	if flag'=0{                                       
		TRollback                                     
		quit -100                                     
	}*/
	TCommit
	quit 0
}

/// Creator?      guobaoping
/// CreatDate?    2009-03-09
/// Description:? 删除字符串的左导空格
/// Table?        
/// Input?        String
/// Output?       String
/// Return?       
/// Others?
ClassMethod DelLBlack(String As %String)
{
	s length=$l(String)
	s checkflag="",subStr=String
	f i=1:1:length  q:(checkflag'="")&&(checkflag'=" ")  d
	.s char=$e(String,i)
	.s checkflag=char
	.i (char=" ") d
	..s subStr=$e(String,i+1,length)
	.e  q 
	q subStr
}

/// Creator?      guobaoping
/// CreatDate?    2009-03-06
/// Description:? 根据病人ID查找病人个人信息
/// Table?        
/// Input?        病人ID
/// Output?       病人信息
/// Return?       
/// Others?
ClassMethod SearchPatInfoByRowID(PArowid As %String)
{
	set (PAPERName,PAPERSex,PAPERAge,PAPERDob,PAPMICardType,PAPERID,EastOPMedicareNo,EastIPMedicareNo,EmgMedicare,PAPERSocialStatusDR,MedicalCardNo,HealthCareProvider,LocalFlag,PAPERForeignAddress,PAPEREmail,PAPERForeignId,PAPERTelH,PAPERCTRLTDR,PAPERCompany,PAPERCountryDR,PAPERCTProvinceDR,PAPERCityCodeDR,PAPERNationDR,PAPMIAllergy,PAPERZipDR,PAPEROccupationDR)=""
	q:PArowid=""
	q:'$d(^PAPER(PArowid))
	If (+$p($g(^PAPER(PArowid,"PAT",1)),"^",1) '=0)
	{
		Set PAPMINo = $p($g(^PAPER(PArowid,"PAT",1)),"^",1)
	}
	else
	{
		Set PAPMINo = $p($g(^PAPER(PArowid,"PAT",2)),"^",1)
	}	
	s PAPERName=$p($g(^PAPER(PArowid,"ALL")),"^",1)
	s PAPERSex=$p($g(^PAPER(PArowid,"ALL")),"^",7)
	s PAPERDob=$p($g(^PAPER(PArowid,"ALL")),"^",6)
	s PAPERAge=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.reg.GetPapmiAge",PArowid,"")
	s PAPMICardType=$p($g(^PAPER(PArowid,"PAT",3)),"^",7)
	//s PAPERID=$p($g(^PAPER(PArowid,"ALL")),"^",9)
	s PAPERID=$p($g(^PAPER(PArowid,"PAT",3)),"^",6) //2016-01-08
	s EastOPMedicareNo=##class(DHCWMR.IO.OutService).IGetMrNoByPatientID("",PArowid,"O","") ;门诊病案号(东)
	s EastIPMedicareNo=##class(DHCWMR.IO.OutService).IGetMrNoByPatientID("",PArowid,"I","") ;住院病案号(东)
	s EmMedicaare=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(PArowid,"E")  
	s PAPERSocialStatusDR=$p($g(^PAPER(PArowid,"PER",1)),"^",10)
	s MedicalCardNo=EastIPMedicareNo
	s HealthCareProvider=$p($g(^PAPER(PArowid,"PER",4)),"^",17)
	s PAPERForeignAddress=$p($g(^PAPER(PArowid,"PER",1)),"^",1)
	s PAPEREmail=$p($g(^PAPER(PArowid,"PER",4)),"^",19)
	s PAPERForeignId=$p($g(^PAPER(PArowid,"PER",2)),"^",13)
	s PAPERTelH=$p($g(^PAPER(PArowid,"PER",1)),"^",11)
	s PAPERCTRLTDR=$p($g(^PAPER(PArowid,"EMP")),"^",4)
	//PAPERCompany
	s PAPERCompany=$p($g(^PAPER(PArowid,"PER",3)),"^",2)
	s PAPERCountryDR=$p($g(^PAPER(PArowid,"PER",1)),"^",8)
	s PAPERCTProvinceDR=$p($g(^PAPER(PArowid,"PER",4)),"^",2)
	s PAPERCityCodeDR=$p($g(^PAPER(PArowid,"PER",1)),"^",5)
	s PAPERNationDR=$p($g(^PAPER(PArowid,"PER",2)),"^",1)
	s PAPMIAllergy=$g(^PAPER(PArowid,"ALLERGY",1))
	s PAPERZipDR=$p($g(^PAPER(PArowid,"PER",1)),"^",7)
	s PAPEROccupationDR=$p($g(^PAPER(PArowid,"PER",2)),"^",6)
	//s cardid=$o(^DHCCARDi("CF",0,"PAPMIDR",PArowid,0))
	s CardNo=""
	//i cardid'="" s CardNo=$p($g(^DHCCARD("CF",cardid)),"^",2)
	s cardid=""
	f  s cardid=$o(^DHCCARDi("CF",0,"PAPMIDR",PArowid,cardid)) q:(cardid="")||(CardNo'="")  d
	.s CardActiveFlag=$p($g(^DHCCARD("CF",cardid)),"^",10)
	.q:CardActiveFlag'="N"
	.s CardNo=$p($g(^DHCCARD("CF",cardid)),"^",2)
	
	s EmployeeFunction="",SecretLevel=""
	s PatEncryptLevel=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(PArowid,.ErrMsg)
	i PatEncryptLevel'="" {
		s EmployeeFunction=$p(PatEncryptLevel,"^",2)
		s SecretLevel=$p(PatEncryptLevel,"^",1)
	}
    s InsuranceNo=$p($g(^PAPER(PArowid,"PAT",3)),"^",12) //医保号
	s PAPERCompany=$p($g(^PAPER(PArowid,"PER",4)),"^",18) //工作单位  PAPERTelH
	
	s PatInfo=PAPMINo_"$"_CardNo  
	s PatInfo=PatInfo_"$"_PAPERName_"^"_PAPERSex_"^"_PAPERAge_"^"_PAPERDob_"^"_PAPMICardType_"^"_PAPERID_"^"_EastOPMedicareNo_"^"_EastIPMedicareNo_"^"_EmgMedicare_"^"_PAPERSocialStatusDR_"^"_MedicalCardNo_"^"_HealthCareProvider_"^"_LocalFlag_"^"_PAPERForeignAddress_"^"_PAPEREmail_"^"_PAPERForeignId_"^"_PAPERTelH_"^"_PAPERCTRLTDR_"^"_PAPERCompany_"^"_PAPERCountryDR_"^"_PAPERCTProvinceDR_"^"_PAPERCityCodeDR_"^"_PAPERNationDR_"^"_PAPMIAllergy_"^"_PAPERZipDR_"^"_PAPEROccupationDR
	s PatInfo=PatInfo_"^"_EmployeeFunction_"^"_SecretLevel_"^"_InsuranceNo_"^"_PAPERCompany
	
	q PatInfo
}

/// Creator?      guobaoping
/// CreatDate?    2009-03-06
/// Description:? 比较两个字符串信息的差异
/// Table?        
/// Input?        两条病人信息字符串
/// Output?       检出的修改过的记录并建立日志记录
/// Return?       
/// Others?
ClassMethod CheckPatInfoUpdate(patInfo As %String, UPpatInfo As %String) As %String
{
 s logInfo="",patName="",UPpatName="",str="" 
 q:(patInfo="")!(UPpatInfo="") 
 s PAPMINo=$p(patInfo,"$",1)
 S CardNo=$p(patInfo,"$",2)
 s otherInfo=$p(patInfo,"$",3)
 s UPotherInfo=$p(UPpatInfo,"$",3)
 s strLength=$l(otherInfo,"^")
 s patName=$p(otherInfo,"^",1)  //病人姓名单独存储
 s UPpatName=$p(UPotherInfo,"^",1)
 f i=1:1:strLength  d           //对更改信息字符串中的其他字符进行比较
 .s Infoval=$p(otherInfo,"^",i) //$$delLBlack(
 .s UPInfoval=$p(UPotherInfo,"^",i) // $$delLBlack(
 
 .s Infoval=..DelLBlack(Infoval)
 .s UPInfoval=..DelLBlack(UPInfoval)
 .q:((Infoval="")&&(UPInfoval=""))
 .i Infoval'=UPInfoval  d
 ..i i=1   d
 ...s logInfo=$$addLogInfo("姓名",patName,UPpatName,logInfo)
 ..e  i i=2  d
 ...i (Infoval'="")&&($d(^CT("SEX",Infoval)))  d
 ....s Infoval=$p($g(^CT("SEX",Infoval)),"^",2)
 ...i (UPInfoval'="")&&($d(^CT("SEX",UPInfoval)))  d
 ....s UPInfoval=$p($g(^CT("SEX",UPInfoval)),"^",2)
 ...s logInfo=$$addLogInfo("性别",Infoval,UPInfoval,logInfo)
 ..e  i i=3  d
 ...s logInfo=$$addLogInfo("年龄",Infoval,UPInfoval,logInfo)
 ..e  i i=4  d
 ...i Infoval'=""  d
 ....s Infoval=..%ZD(Infoval) //$zd(Infoval,3)
 ...i UPInfoval'=""  d
 ...s UPInfoval=..%ZD(UPInfoval) //$zd(UPInfoval,3)
 ...s logInfo=$$addLogInfo("出生日期",Infoval,UPInfoval,logInfo)
 ..e  i i=5  d
 ...i (Infoval'="")&&($d(^PAC("CARD",Infoval)))  d
 ....s Infoval=$p($g(^PAC("CARD",Infoval)),"^",2)
 ...i (UPInfoval'="")&&($d(^PAC("CARD",UPInfoval)))  d
 ....s UPInfoval=$p($g(^PAC("CARD",UPInfoval)),"^",2)
 ...s logInfo=$$addLogInfo("证件类别",Infoval,UPInfoval,logInfo)
 ..e  i i=6  d
 ...s logInfo=$$addLogInfo("证件号码",Infoval,UPInfoval,logInfo)
 ..e  i i=7  d
 ...s logInfo=$$addLogInfo("门诊病历号",Infoval,UPInfoval,logInfo)
 ..e  i i=8  d
 ...s logInfo=$$addLogInfo("住院病历号",Infoval,UPInfoval,logInfo)
 ..e  i i=9  d
 ...s logInfo=$$addLogInfo("急诊病历号",Infoval,UPInfoval,logInfo)
 ..e  i i=10 d
 ...i (Infoval'="")&&($d(^CT("SS",Infoval)))  d
 ....s Infoval=$p($g(^CT("SS",Infoval)),"^",2)
 ...i (UPInfoval'="")&&($d(^CT("SS",UPInfoval)))  d
 ....s UPInfoval=$p($g(^CT("SS",UPInfoval)),"^",2)
 ...s logInfo=$$addLogInfo("病人类型",Infoval,UPInfoval,logInfo)
 ..e  i i=11 d
 ...s logInfo=$$addLogInfo("医保号",Infoval,UPInfoval,logInfo)
 ..e  i i=12  d
 ...i (Infoval'="")&&($d(^CT("HCP",Infoval)))  d
 ....s Infoval=$p($g(^CT("HCP",Infoval)),"^",2)
 ...i (UPInfoval'="")&&($d(^CT("HCP",UPInfoval)))  d
 ....s UPInfoval=$p($g(^CT("HCP",UPInfoval)),"^",2) 
 ...s logInfo=$$addLogInfo("公费单位",Infoval,UPInfoval,logInfo)
 ..e  i i=13  d
 ...i (Infoval'="")  d
 ....i Infoval=2  
 .....s Infoval="外埠"
 ....e  s Infoval="本市"
 ...i (UPInfoval'="")  d
 ....i Infoval=2  
 .....s Infoval="外埠"
 ....e  s Infoval="本市" 
 ...s logInfo=$$addLogInfo("本市/外埠",Infoval,UPInfoval,logInfo)
 ..e  i i=14 d
 ...s logInfo=$$addLogInfo("家庭地址",Infoval,UPInfoval,logInfo)
 ..e  i i=15 d
 ...s logInfo=$$addLogInfo("电子邮件",Infoval,UPInfoval,logInfo)
 ..e  i i=16 d
 ...s logInfo=$$addLogInfo("联系人",Infoval,UPInfoval,logInfo)
 ..e  i i=17 d
 ...s logInfo=$$addLogInfo("联系电话",Infoval,UPInfoval,logInfo)
 ..e  i i=18 d
 ...i (Infoval'="")&&($d(^CT("RLT",Infoval)))  d
 ....s Infoval=$p($g(^CT("RLT",Infoval)),"^",2)
 ...i (UPInfoval'="")&&($d(^CT("RLT",UPInfoval)))  d
 ....s UPInfoval=$p($g(^CT("RLT",UPInfoval)),"^",2) 
 ...s logInfo=$$addLogInfo("关系",Infoval,UPInfoval,logInfo)
 ..e  i i=19 d
 ...i (Infoval'="")&&($d(^CT("CTCO",Infoval)))  d
 ....s Infoval=$p($g(^CT("CTCO",Infoval)),"^",2)
 ...i (UPInfoval'="")&&($d(^CT("CTCO",UPInfoval)))  d
 ....s UPInfoval=$p($g(^CT("CTCO",UPInfoval)),"^",2) 
 ...;s logInfo=$$addLogInfo("工作单位",Infoval,UPInfoval,logInfo)
 ..e  i i=20  d
 ...i (Infoval'="")&&($d(^CT("COU",Infoval)))  d
 ....s Infoval=$p($g(^CT("COU",Infoval)),"^",2)
 ...i (UPInfoval'="")&&($d(^CT("COU",UPInfoval)))  d
 ....s UPInfoval=$p($g(^CT("COU",UPInfoval)),"^",2) 
 ...s logInfo=$$addLogInfo("国籍",Infoval,UPInfoval,logInfo)
 ..e  i i=21  d
 ...i (Infoval'="")&&($d(^CT("PROV",Infoval)))  d
 ....s Infoval=$p($g(^CT("PROV",Infoval)),"^",2)
 ...i (UPInfoval'="")&&($d(^CT("PROV",UPInfoval)))  d
 ....s UPInfoval=$p($g(^CT("PROV",UPInfoval)),"^",2) 
 ...s logInfo=$$addLogInfo("省份",Infoval,UPInfoval,logInfo)
 ..e  i i=22  d
 ...i (Infoval'="")&&($d(^CT("CIT",Infoval)))  d
 ....s Infoval=$p($g(^CT("CIT",Infoval)),"^",2)
 ...i (UPInfoval'="")&&($d(^CT("CIT",UPInfoval)))  d
 ....s UPInfoval=$p($g(^CT("CIT",UPInfoval)),"^",2) 
 ...s logInfo=$$addLogInfo("所在城市",Infoval,UPInfoval,logInfo)
 ..e  i i=23 d
 ...i (Infoval'="")&&($d(^CT("NAT",Infoval)))  d
 ....s Infoval=$p($g(^CT("NAT",Infoval)),"^",2)
 ...i (UPInfoval'="")&&($d(^CT("NAT",UPInfoval)))  d
 ....s UPInfoval=$p($g(^CT("NAT",UPInfoval)),"^",2) 
 ...s logInfo=$$addLogInfo("民族",Infoval,UPInfoval,logInfo)
 ..e  i i=24 d
 ...s logInfo=$$addLogInfo("过敏史",Infoval,UPInfoval,logInfo)
 ..e  i i=25 d
 ...i (Infoval'="")&&($d(^CT("ZIP",Infoval)))  d
 ....s Infoval=$p($g(^CT("ZIP",Infoval)),"^",1)
 ...i (UPInfoval'="")&&($d(^CT("ZIP",UPInfoval)))  d
 ....s UPInfoval=$p($g(^CT("ZIP",UPInfoval)),"^",1) 
 ...s logInfo=$$addLogInfo("邮政编码",Infoval,UPInfoval,logInfo)
 ..e  i i=26 d
 ...i (Infoval'="")&&($d(^CT("OCC",Infoval)))  d
 ....s Infoval=$p($g(^CT("OCC",Infoval)),"^",2)
 ...i (UPInfoval'="")&&($d(^CT("OCC",UPInfoval)))  d
 ....s UPInfoval=$p($g(^CT("OCC",UPInfoval)),"^",2) 
 ...s logInfo=$$addLogInfo("职业",Infoval,UPInfoval,logInfo)
 ..e  i i=27 d
 ...s logInfo=$$addLogInfo("病人级别",Infoval,UPInfoval,logInfo)
 ..e  i i=28 d
 ...s logInfo=$$addLogInfo("病人密级",Infoval,UPInfoval,logInfo)
 ..e  i i=29 d
 ...s logInfo=$$addLogInfo("医保号",Infoval,UPInfoval,logInfo)
 ..e  i i=30 d
 ...s logInfo=$$addLogInfo("工作单位",Infoval,UPInfoval,logInfo)
 s str=PAPMINo_"$"_CardNo_"$"_patName_"$"_UPpatName_"$"_logInfo
 //s ^TEMPDDD(1111)=str
 q str
addLogInfo(title,Infoval,UPInval,logInfo)
 s logInfo=logInfo_";"_title_"由'"_Infoval_"'改成了'"_UPInval_"'"
 q logInfo
}

/// Creator?      guobaoping
/// CreatDate?    2009-03-06
/// Description:? 添加病人信息修改日志
/// Table?        SQLuser.DHCUPPERSON 病人信息修改日志表
/// Input?        修改信息
/// Output?       sqlcode
/// Return?       
/// Others?
ClassMethod AddDHCPatientUpdateLog(UpdateLog As %String, UPUserDr As %String = "")
{
 q:UpdateLog=""
 s PAPMINo=$p(UpdateLog,"$",1)
 s CardNo=$p(UpdateLog,"$",2)
 s patName=$p(UpdateLog,"$",3)
 s UPpatName=$p(UpdateLog,"$",4)
 s logInfo=$p(UpdateLog,"$",5)
 q:logInfo="" 0
 s UPDate=..%SysDate()
 s UPTime=..%SysTime()
 s:UPUserDr="" UPUserDr=%session.Get("LOGON.USERID")
 //s ^TEMPDDD(7777)=PAPMINo+"^"+CardNo+"^"+patName+"^"+UPpatName+"^"+logInfo+"^"+UPDate+"^"+UPTime+"^"+UPUserDr
 &sql(insert into SQLuser.DHCUPPERSON(UP_CardNo,UP_RegistrationNo,UP_PAPERName,UPs_PAPERName,UP_CardInfo,UP_Date,UP_Time,UP_UserDr)
 values(:CardNo,:PAPMINo,:patName,:UPpatName,:logInfo,:UPDate,:UPTime,:UPUserDr)
 )
 Q SQLCODE
}

// GetOtherInform

ClassMethod Test(PapmiNo As %String = "", Test As %String = "") As %String
{
	s ^DHCXPTest(0,"1")="aaaaaaaaaa"
	q:"1^2^3^4^5^6^7"
}

ClassMethod GetOtherInform(PapmiNo As %String = "") As %String
{
 
 // w ##class(web.DHCBL.Patient.DHCPatientBuilder).a("0000000038")
 // 根据病人登记号,获取病人的病案号等信息
 	s ^DHCXPTest(0,"Test")="AAAAAAAAA"
	s PapmiDr=$o(^PAPERi("PAPMI_PatNo",PapmiNo,""))
	q:PapmiDr="" ""
	s OtherInformStr=""
	s EastOPMedicareNo=""
	s EastIPMedicareNo=""
	;i $d(^PAPER(PapmiDr,"PER",4)) s EastOPMedicareNo=$p(^PAPER(PapmiDr,"PER",4),"^",4)  ;门诊病案号(东)
	s EastOPMedicareNo=##class(web.DHCDocOrderCommon).GetMrNo("",PapmiDr,"O",$g(%session.Data("LOGON.HOSPID"))) ;门诊病案号
	;i $d(^PAPER(PapmiDr,"PAT",1)) s EastIPMedicareNo=$p(^PAPER(PapmiDr,"PAT",1),"^",22)  ;住院病案号(东)
	s EastIPMedicareNo=##class(web.DHCDocOrderCommon).GetMrNo("",PapmiDr,"I",$g(%session.Data("LOGON.HOSPID"))) ;住院病案号
	s InsuranceNo=$p($g(^PAPER(PapmiDr,"PAT",3)),"^",12)  ;医保号
	//住院病案号,本埠/外埠,从User.DHCPerson取 
	s WestOPMedicareNo=""
	s WestIPMedicareNo=""
	s DHCPAPersonID=$o(^DHCPERSON(0,"PAPERSON",PapmiDr,""))
	i DHCPAPersonID'="" s LocalFlagDr=$p($g(^DHCPERSON(DHCPAPersonID)),"^",12)
	e  s LocalFlagDr=""
	s LocalFlagDesc=""
	s EmMedicaare=##class(web.DHCDocOrderCommon).GetMrNo("",PapmiDr,"E",$g(%session.Data("LOGON.HOSPID"))) ;急诊诊病案号
	
	i LocalFlagDr=2  s LocalFlagDesc="外埠"
	e  s LocalFlagDesc="本市"
	s OtherInformStr=EastOPMedicareNo_"^"_EastIPMedicareNo_"^"_WestOPMedicareNo
	s OtherInformStr=OtherInformStr_"^"_WestIPMedicareNo_"^"_InsuranceNo_"^"_LocalFlagDesc_"^"_EmMedicaare
	s OtherInformStr=$TR(OtherInformStr,$C(0),"")
	
	s OtherCredInfo=##class(web.DHCBL.Patient.DHCPatient).GetOtherCredInfo(PapmiDr)
	s OtherCredInfo=$TR(OtherCredInfo,"^","@")
	s OtherInformStr=OtherInformStr_"^"_OtherCredInfo
	;s ^DHCXPTest(0,"OtherInform")=OtherInformStr
	q OtherInformStr
}

ClassMethod GetPatCardNo(PapmiNo As %String = "", CardDesc As %String = "") As %String
{
 // 根据病人登记号,获取病人的病案号等信息
 s ^DHCXPTest("CardTypeDesc")=CardDesc
	s PatCardNo=..GetUPCardNo(PapmiNo,CardDesc)
	//s PatCardNo=PatCardNo_"^1^2^3^4^5^6^7^8"
	q PatCardNo
}

ClassMethod GetUPCardNo(UPPno As %String = "", UPCardDesc As %String = "") As %String
{
	s UPCardNo=""
	s PapmiDr=$o(^PAPERi("PAPMI_PatNo",UPPno,""))
	s CardDr=""
	f  s CardDr=$o(^DHCCARDi("CF",0,"PAPMIDR",PapmiDr,CardDr)) q:CardDr=""  d 
	.s CardActiveFlag=$p(^DHCCARD("CF",CardDr),"^",10)
	.q:(CardActiveFlag'="N") 
	.s CardTypeDr=$p(^DHCCARD("CF",CardDr),"^",16)
	.s CardTypeDesc=$p(^DHCCARDTYPEDef(CardTypeDr),"^",2)
	.q:CardTypeDesc'[UPCardDesc
	.s UPCardDr=CardDr
	.s UPCardNo=$p(^DHCCARD("CF",UPCardDr),"^",2)
	q UPCardNo
}

ClassMethod QueryLogClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryLogExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryLogExecute(ByRef qHandle As %Binary, RegNo As %String = "") As %Status
{
	s ^DHCXPTest("RegNo")=RegNo
	s CardNo=RegNo
	s repid=$I(^CacheTemp)
 i $g(ind)="" s ind=1
 s UPPRowid=""
	f  s UPPRowid=$o(^User.DHCUPPERSONI("UPPCardNoIndex"," "_CardNo,UPPRowid)) q:UPPRowid=""  d 
	.s PatInfrom=""
	.f i=2:1:44  d
	..s UPPNode=$ListGet(^User.DHCUPPERSOND(UPPRowid),i)
	..i i=16  s UPPNode=$p(^SSU("SSUSR",+UPPNode),"^",2)  ;根据挂号员的Rowid,取挂号员姓名
	..s PatInfrom=PatInfrom_"^"_UPPNode
	.s ^CacheTemp(repid,ind)=$LB(PatInfrom)
	.s ind=ind+1
	s qHandle=$lb(0,repid,0)
	q $$$OK
}

ClassMethod QueryLogFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLogExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" 
 {	// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      
 {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 // Save QHandle
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod UpDateOtherInform(OtherInformStr As %String = "", PapmiNo As %String = "") As %String
{
	//更新病人基本信息,新增病案号等信息
	s ^DHCXPTest(0,"OtherInformStr")=OtherInformStr_"^"_PapmiNo
	s EastOPMedicareNo=$p(OtherInformStr,"^",1)
	s EastIPMedicareNo=$p(OtherInformStr,"^",2)
	s WestOPMedicareNo=$p(OtherInformStr,"^",3)
	s WestIPMedicareNo=$p(OtherInformStr,"^",4)
	s InsuranceNo=$p(OtherInformStr,"^",5)
	s PAPERCompany=$p(OtherInformStr,"^",7)
	
	s PapmiDr=$o(^PAPERi("PAPMI_PatNo",PapmiNo,""))
	;s legalFlag=$$CheckNoLegal(PapmiDr,EastOPMedicareNo,EastIPMedicareNo,WestOPMedicareNo,WestIPMedicareNo,InsuranceNo)  
	;检查病案号和医保号是否合法,是否与其他人冲突
	s LocalFlagDesc=$p(OtherInformStr,"^",6)
	i LocalFlagDesc="本市"  s LocalFlagDr=1
	e  s LocalFlagDr=2
	s RtnValue=0
	s DHCPersonDr=$o(^DHCPERSON(0,"PAPERSON",PapmiDr,""))
	
	/*&sql(Update SQLUser.PA_PatMas Set papmi_medicare=:EastIPMedicareNo,
		PAPMI_HealthFundNo=:InsuranceNo,PAPMI_SecondPhone=:PAPERCompany where PAPMI_No=:PapmiNo )	
	i SQLCODE'=0  s RtnValue=SQLCODE */
	/*&sql(Update SQLUser.pa_person Set paper_governcardno=:EastOPMedicareNo 
		where paper_rowid=:PapmiDr)	
	i SQLCODE'=0  s RtnValue=SQLCODE
	*/
	i DHCPersonDr'="" { 
	i '$d(^DHCPERSON(DHCPersonDr)) q 0
	/*&sql(Update SQLUser.DHC_Person Set PAPER_FCMedicareCode1=:WestOPMedicareNo,
		 PAPER_FCMedicareCode2=:WestIPMedicareNo,PAPER_CityFlag=:LocalFlagDr 
		 where paper_rowid=:DHCPersonDr)
	*/
	&sql(Update SQLUser.DHC_Person Set PAPER_CityFlag=:LocalFlagDr 
		 where paper_rowid=:DHCPersonDr)
	}ELSE{
	/*&sql(INSERT INTO SQLUser.DHC_Person(PAPER_FCMedicareCode1,PAPER_FCMedicareCode2,PAPER_CityFlag,PAPER_PaPerson_dr) 
		values(:WestOPMedicareNo,:WestIPMedicareNo,:LocalFlagDr,:PapmiDr)
		 )
	*/	
	&sql(INSERT INTO SQLUser.DHC_Person(PAPER_CityFlag,PAPER_PaPerson_dr) 
		values(:LocalFlagDr,:PapmiDr)
		 )
	}
	i SQLCODE'=0  s RtnValue=SQLCODE
	/*s logInfo=""
	if (InsuranceNo'=EmgMedicare){
        s logInfo="医保号"_"由'"_EmgMedicare_"'改成了'"_InsuranceNo_"'"
	}
	if (PAPERCompany'=OldPAPERCompany){
		i logInfo="" s logInfo="工作单位"_"由'"_OldPAPERCompany_"'改成了'"_PAPERCompany_"'"
		e  s logInfo=logInfo_";"_"工作单位"_"由'"_OldPAPERCompany_"'改成了'"_PAPERCompany_"'"
	}
	if (logInfo'=""){
		s patInfo=..SearchPatInfoByRowID(PapmiDr)
		s PAPMINo=$p(patInfo,"$",1)
        S CardNo=$p(patInfo,"$",2)
		s patName=$p(otherInfo,"^",1)  //病人姓名单独存储
		s otherInfo=$p(patInfo,"$",3)
		s UPpatName=$p(UPotherInfo,"^",1)
		s str=PAPMINo_"$"_CardNo_"$"_patName_"$"_UPpatName_"$"_logInfo
		d ..AddDHCPatientUpdateLog(str)  
	}*/
	q RtnValue
}

Query QueryLog(RegNo As %String = "") As %Query(ROWSPEC = "PatInfrom:%String")
{
}

/// Creator?      guobaoping
/// CreatDate?    2009-03-04
/// Description:?  根据查询选项查询卡信息修改日志记录
/// Table?        SQLUser.DHCUPPERSON ,SS_user
/// Input?        UPCardNo  查询的卡号
/// UPRegNo    查询的登记号
/// UPPAPERName  原病人姓名
/// UPsPAPERName  改后的病人姓名
/// StartDate    查询起始日期
/// EndDate      查询截止日期
/// Output?       TUPCardNo   卡号
/// TUPRegNo     登记号
/// TUPPAPERName 原病人姓名
/// TUPsPAPERName 改后的病人姓名
/// TUPDate       修改日期
/// TUPTime       修改时间
/// TUPCardInfo   修改的其他卡信息
/// TUPUserDr     修改人
/// Return?         
/// Others?   Query查询  查询条件为优先级互斥 优先顺序为?卡号>登记号>修改前的病人姓名>修改后的病人姓名>时间段
/// d ##class(%ResultSet).RunQuery("web.DHCBL.Patient.DHCPatientBuilder","QueryUptLog","","","","MIC","2019-06-17","2019-06-17")    
Query QueryUptLog(UPCardNo As %String = "", UPRegNo As %String = "", UPPAPERName As %String = "", UPsPAPERName As %String = "", StartDate As %String = "", EndDate As %String = "") As %Query(ROWSPEC = "TUPCardNo:%String,TUPRegNo:%String,TUPPAPERName:%String,TUPsPAPERName:%String,TUPDate:%String,TUPTime:%String,TUPCardInfo:%String,TUPUserDr:%String,TPoliticalLevel:%String,TSecretLevel:%String")
{
}

ClassMethod QueryUptLogClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryUptLogExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryUptLogExecute(ByRef qHandle As %Binary, UPCardNo As %String, UPRegNo As %String = "", UPPAPERName As %String, UPsPAPERName As %String, StartDate As %String, EndDate As %String) As %Status
{
	 Set repid=$I(^CacheTemp)
	 If $g(ind)="" Set ind=1
	 s UPPAPERName=$ZCONVERT(UPPAPERName,"U")
	 s UPsPAPERName=$ZCONVERT(UPsPAPERName,"U")
    i StartDate'="" s StartDate=..%ZDH(StartDate)
    i EndDate'="" s EndDate=..%ZDH(EndDate)
    s Admfalg=""
	s (TUPCardNo,TUPRegNo,TUPPAPERName,TUPsPAPERName,TUPDate,TUPTime,TUPCardInfo,TUPUserDr,UPUser,TPoliticalLevel,TSecretLevel)=""    
	If ((UPCardNo = "" )&&(UPRegNo = "")&&(UPPAPERName = "")&&(UPsPAPERName ="")&&(StartDate ="")&&(EndDate ="")) 
	{goto end }
	s validation=""
	k ^TMP("PATIENTULog",$j)
	if (UPCardNo'=""){
		s CFRowID=0
		for {
			s CFRowID=$o(^DHCCARDi("CF",0,"CardNo",UPCardNo,CFRowID)) Q:CFRowID=""
			s CFActiveFlag=$p(^DHCCARD("CF",CFRowID),"^",10)
			continue:CFActiveFlag'="N"
			s PatientID=$p(^DHCCARD("CF",CFRowID),"^",4)
			d GetChangeLogByPat
		}
	}elseif (UPRegNo'= ""){
		s myPatLen=+$p(^CF("PATCF",1,3),"^",5)
		s UPRegNo=$e("0000000000000000000",1,myPatLen-$l(UPRegNo))_UPRegNo
		s PatientID=$o(^PAPERi("PAPMI_PatNo",UPRegNo,""))
		d GetChangeLogByPat
	}elseif (UPPAPERName'= ""){
	   s id=0
	   for {
		   s id=$o(^User.DHCDocDataChangeLogI("ClassNameIndex"," USER.PAPATMAS#USER.PAPERSON",id)) Q:id=""
		   Do GetChangeLogByUpID
	   }
	}elseif (UPsPAPERName'= ""){
		s PAPERName=0
		for {
			Set PAPERName = $o(^User.DHCDocDataChangeLogI("ObjDesIdx",PAPERName)) Q:PAPERName="" //模糊查
			s PAPERNameSub=$ZCONVERT(PAPERName,"U")
			if (PAPERNameSub[UPsPAPERName) {
				s id=0
				for {
					Set id =$o(^User.DHCDocDataChangeLogI("ObjDesIdx",PAPERName,id)) Q:id=""
					Do GetChangeLogByUpID
				}
			}
		}
	}elseif ((StartDate'="")&&(EndDate'="")&&(StartDate<=EndDate)){  
	    s date=StartDate-1
		for {
			s date=$o(^User.DHCDocDataChangeLogI("UpdateDateIndex",date)) Q:(date="")||((date>EndDate)&&(EndDate'=""))
			s id=0
			for {
				s id=$o(^User.DHCDocDataChangeLogI("UpdateDateIndex",date,id)) Q:id=""
				Do GetChangeLogByUpID
			}
		}
	}
	Do OutPutRow
	k ^TMP("PATIENTULog",$j)
	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutPutRow
	Set L1="" 
	For {
		Set L1=$O(^TMP("PATIENTULog",$j,L1)) Quit:L1=""
		Set L2="" 
		For {
			Set L2=$O(^TMP("PATIENTULog",$j,L1,L2)) Quit:L2=""
			Set L3="" 
			For  {
				Set L3=$O(^TMP("PATIENTULog",$j,L1,L2,L3)) Quit:L3=""
				Set ^CacheTemp(repid,ind)=^TMP("PATIENTULog",$j,L1,L2,L3)
				Set ind=ind+1 
			}
		}
	}
	Q
GetChangeLogByPat
	Q:PatientID=""
	s ObjectReference="USER.PAPATMAS#USER.PAPERSON_"_PatientID
	s id=0
	s Admfalg=""
	for {
		s id=$o(^User.DHCDocDataChangeLogI("ObjectReferenceIndex"," "_ObjectReference,id)) Q:id=""
		d GetChangeLogByUpID
	}
	s AdmType=""
	f  {
		s AdmType=$O(^PAPERdr(PatientID,"ADM",AdmType)) 
		q:AdmType="" 
		s AdmId=""
		for {
			s AdmId=$O(^PAPERdr(PatientID,"ADM",AdmType,AdmId)) 
			q:AdmId="" 
			s id=0 
			s ObjectReference="USER.PAADM#USER.PAADMEXT_"_AdmId
			for {
				s Admfalg="Y"
				s id=$o(^User.DHCDocDataChangeLogI("ObjectReferenceIndex"," "_ObjectReference,id)) Q:id=""
				b "L+"
				d GetChangeLogByUpID
			}
		}
	}
	Q
GetChangeLogByUpID
	Q:id=""
	s data=$g(^User.DHCDocDataChangeLogD(id))
	s ClassName=$lg(data,3)
	Q:(ClassName'="User.PAPatMas#User.PAPerson")&&(Admfalg="")
	Q:(ClassName'="User.PAAdm#User.PAAdmExt")&&(Admfalg="Y")
	s TUPDate=$lg(data,7)
	Q:(TUPDate<StartDate)&&(StartDate'="")
	Q:(TUPDate>EndDate)&&(EndDate'="")
	s ObjectDesc=$lg(data,4) //对象ID
	i ObjectDesc["_" s TUPPatId=$p(ObjectDesc,"_",2)
	if (Admfalg="Y") s TUPRegNo=$p(^PAPER(PatientID,"PAT",1),"^",1)
	e  s TUPRegNo=$p(^PAPER(TUPPatId,"PAT",1),"^",1)
	Q:(UPRegNo'="")&&(TUPRegNo'=UPRegNo)
	//s TUPsPAPERName=$p(^PAPER(TUPPatId,"ALL"),"^",1)
	s NewValue=$lg($g(data),10)
	k NewValueCongeriesArr
	d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(NewValue,.NewValueCongeriesArr)
	s TUPsPAPERName=##class(web.DHCDocDataChangeLog).DelSingleQuotation($g(NewValueCongeriesArr(1,"PAPMI_Name")))
	Q:(UPsPAPERName'="")&&($ZCONVERT(TUPsPAPERName,"U")'[UPsPAPERName)
	s OldValue=$lg($g(data),14)
	k OldValueCongeriesArr
	d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(OldValue,.OldValueCongeriesArr)
	s TUPPAPERName=##class(web.DHCDocDataChangeLog).DelSingleQuotation($g(OldValueCongeriesArr(1,"PAPMI_Name")))
	Q:(UPPAPERName'="")&&($ZCONVERT(TUPPAPERName,"U")'[UPPAPERName)
	s UpdateUserDR=$lg(data,5)
    i UpdateUserDR'="" s UPUser=$p($G(^SSU("SSUSR",UpdateUserDR)),"^",2) //操作人
    else  s UPUser=""
	s UpdateType=$lg(data,9) //操作类型
	s TUPDate=..%ZD(TUPDate) //操作日期
    s TUPTime=..%ZT($lg(data,8),1) //操作时间
    s TUPCardInfo=##class(web.DHCDocDataChangeLog).GetChangeDetail(id)
    Q:TUPCardInfo=""
    s TPoliticalLevel="",TSecretLevel=""
	s PatEncryptLevel=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(TUPPatId,.ErrMsg)
	i PatEncryptLevel'="" {
		s TPoliticalLevel=$p(PatEncryptLevel,"^",2)
		s TSecretLevel=$p(PatEncryptLevel,"^",4)
	}
	s TUPCardNo=""
	if (UPCardNo'="") {
		s TUPCardNo=UPCardNo
	}else {
		s CardRowId=0
		for {
			s CardRowId=$o(^DHCCARDi("CF",0,"PAPMIDR",TUPPatId,CardRowId)) Q:(CardRowId="")||(TUPCardNo'="")  d
			s ActiveFlag=$p(^DHCCARD("CF",CardRowId),"^",10)
			continue:ActiveFlag'="N"
			s TUPCardNo=$p(^DHCCARD("CF",CardRowId),"^",2)
		}
	}
	s Data=$lb(TUPCardNo,TUPRegNo,TUPPAPERName,TUPsPAPERName,TUPDate,TUPTime,TUPCardInfo,UPUser,TPoliticalLevel,TSecretLevel)
	Set ^TMP("PATIENTULog",$j,id,$lg(data,7),$lg(data,8))=Data
  	Q
	/*
	Set validation = 0
	s UPPRowid=""
	if (UPCardNo'= ""){ 
		Set UPPRowid = $o(^User.DHCUPPERSONI("UPCardNo",UPCardNo,0))
		Set validation = 1
	}elseif (UPRegNo'= ""){
		s myPatLen=+$p(^CF("PATCF",1,3),"^",5)
		s UPRegNo=$e("0000000000000000000",1,myPatLen-$l(UPRegNo))_UPRegNo
	    set UPPRowid=$o(^User.DHCUPPERSONI("UPRegNo",UPRegNo,0))
	    set validation = 2
	}elseif (UPPAPERName'= ""){
	    Set PAPERName = $o(^User.DHCUPPERSONI("UPPAName","")) //模糊查询	
		s PAPERNameSub=$ZCONVERT(PAPERName,"U")
		While (PAPERNameSub'[UPPAPERName)
		{
			Set PAPERName = $o(^User.DHCUPPERSONI("UPPAName",PAPERName))
			if ( PAPERName="") quit
			s PAPERNameSub=$ZCONVERT(PAPERName,"U")
		}	
			
		if (PAPERName ="") {goto end }
		Set UPPRowid =$o(^User.DHCUPPERSONI("UPPAName",PAPERName,0))
		Set validation = 3
	}elseif (UPsPAPERName'= ""){
		Set PAPERName = $o(^User.DHCUPPERSONI("UPsPAName","")) //模糊查询	
		s PAPERNameSub=$ZCONVERT(PAPERName,"U")
		While (PAPERNameSub'[UPsPAPERName)
		{
			Set PAPERName = $o(^User.DHCUPPERSONI("UPsPAName",PAPERName))
			if ( PAPERName="") quit
			s PAPERNameSub=$ZCONVERT(PAPERName,"U")
		}		
		if (PAPERName ="") {goto end }
		Set UPPRowid =$o(^User.DHCUPPERSONI("UPsPAName",PAPERName,0))
		Set validation = 4
	}elseif ((StartDate'="")&&(EndDate'="")&&(StartDate<=EndDate)){  
	    s UptDate=StartDate
	    while(('$d(^User.DHCUPPERSONI("UPDate",UptDate))))
	    { 
	     S UptDate =$o(^User.DHCUPPERSONI("UPDate",UptDate))
	     
	     q:UptDate="" 
	    }
	    if ((UptDate ="")!(UptDate>EndDate)) {goto end }
	    Set UPPRowid =$o(^User.DHCUPPERSONI("UPDate",UptDate,0))
		set validation = 5
		
	}else{
		goto end 
	}
 while (+UPPRowid'=0)
	{    
		If ($d(^User.DHCUPPERSOND(UPPRowid)))
		{    //TUPCardNo,TUPRegNo,TUPPAPERName,TUPsPAPERName,TUPDate,TUPTime,TUPCardInfo,TUPUserDr
			Set TUPCardNo = $p($g(^User.DHCUPPERSOND(UPPRowid)),"^",1)
			Set TUPRegNo = $p($g(^User.DHCUPPERSOND(UPPRowid)),"^",2)
		    Set TUPPAPERName =$p($g(^User.DHCUPPERSOND(UPPRowid)),"^",6)
		    Set TUPsPAPERName = $p($g(^User.DHCUPPERSOND(UPPRowid)),"^",7)
		    Set TUPDate = $p($g(^User.DHCUPPERSOND(UPPRowid)),"^",4) //$zd($p($g(^User.DHCUPPERSOND(UPPRowid)),"^",4),4)
		    Set TUPDate = ..%ZD(TUPDate)
		    Set TUPTime = ..%ZT($p($g(^User.DHCUPPERSOND(UPPRowid)),"^",5),1)
		    Set TUPCardInfo = $p($g(^User.DHCUPPERSOND(UPPRowid)),"^",8)
		    //Set TUPCardInfo=$replace(TUPCardInfo,"身份证","证件")
		    Set TUPUserDr = $p($g(^User.DHCUPPERSOND(UPPRowid)),"^",3)
		    if (TUPUserDr'="")&&($d(^SSU("SSUSR",TUPUserDr))'=0)
		    {Set UPUser=$p(^SSU("SSUSR",TUPUserDr),"^",2) }
		    else {s UPUser="" }
		    s PersonRowId="",TPoliticalLevel="",TSecretLevel=""
		    i TUPRegNo'="" s PersonRowId=$o(^PAPERi("PAPMI_PatNo",TUPRegNo,PersonRowId))
		    s PatEncryptLevel=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(PersonRowId,.ErrMsg)
			i PatEncryptLevel'="" {
				s TPoliticalLevel=$p(PatEncryptLevel,"^",2)
				s TSecretLevel=$p(PatEncryptLevel,"^",1)
			}
			Set Data=$ListBuild(TUPCardNo,TUPRegNo,TUPPAPERName,TUPsPAPERName,TUPDate,TUPTime,TUPCardInfo,UPUser,TPoliticalLevel,TSecretLevel)
			
			Set ^CacheTemp(repid,ind)=Data
	 	    Set ind=ind+1
		}
			
	if (+validation = 1) 
	 	{
		 	Set UPPRowid = $o(^User.DHCUPPERSONI("UPCardNo",UPCardNo,UPPRowid))
		 
			 if UPPRowid =""
			 {
				 quit
			 }
		}
	 	
	 elseif (+validation=2)
		{
			Set UPPRowid = $o(^User.DHCUPPERSONI("UPRegNo",UPRegNo,UPPRowid))
		    
			 if UPPRowid =""
			 {
				 quit
			 }
		}
	 elseif (+validation=3)
		{   
			Set UPPRowid =$o(^User.DHCUPPERSONI("UPPAName",PAPERName,UPPRowid))
			if (UPPRowid = "")
			{
				 Set PAPERName = $o(^User.DHCUPPERSONI("UPPAName",PAPERName)) //模糊查询	
				 if (PAPERName="") quit 
				 s PAPERNameSub=$ZCONVERT(PAPERName,"U")
				 While (PAPERNameSub '[ UPPAPERName)
				 {
					
					Set PAPERName = $o(^User.DHCUPPERSONI("UPPAName",PAPERName))
					if (PAPERName ="") quit 
					s PAPERNameSub=$ZCONVERT(PAPERName,"U")
				
				 }
				
				 if ( PAPERName'="") 
				 
				 { s UPPRowid  =$o(^User.DHCUPPERSONI("UPPAName",PAPERName,0))}
		    }
					
			if (UPPRowid="")  q
		 }
	 elseif (+validation=4)
		{    
			Set UPPRowid =$o(^User.DHCUPPERSONI("UPsPAName",PAPERName,UPPRowid))
			if (UPPRowid = "")
			{
				 Set PAPERName =$o(^User.DHCUPPERSONI("UPsPAName",PAPERName)) //模糊查询	
				 if (PAPERName="") quit 
				 s PAPERNameSub=$ZCONVERT(PAPERName,"U")
				 While (PAPERNameSub '[ UPsPAPERName)
				 {
					
					Set PAPERName = $o(^User.DHCUPPERSONI("UPsPAName",PAPERName))
					if (PAPERName="") quit 
					s PAPERNameSub=$ZCONVERT(PAPERName,"U")
				
				 }
				
				 if ( PAPERName'="") 
				 
				 { s UPPRowid  =$o(^User.DHCUPPERSONI("UPsPAName",PAPERName,0))}
		    }
					
			if (UPPRowid="")  q
		}elseif(+validation=5)
		 
		 { 
		    Set UPPRowid =$o(^User.DHCUPPERSONI("UPDate",UptDate,UPPRowid))
			if (UPPRowid ="")
			{   s UptDate=UptDate+1
			    q:UptDate>EndDate
			   while('$d(^User.DHCUPPERSONI("UPDate",UptDate)))
			   { Set UptDate = $o(^User.DHCUPPERSONI("UPDate",UptDate))
			     if (UptDate="")!(UptDate>EndDate)	 Quit
			   }
			   if (UptDate'="")
			   { Set UPPRowid = $o(^User.DHCUPPERSONI("UPDate",UptDate,0))}
			
			}
		   if (UPPRowid="")  q	
		 }		
}*/
end 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
}

ClassMethod QueryUptLogFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryUptLogExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" 
 {	// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      
 {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 // Save QHandle
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod CheckCardType(CardNo As %String = "") As %String
{
	s ^RP("CheckCardType")=CardNo
	;w ##class(web.DHCBL.Patient.DHCPatientBuilder).CheckCardType("3")
	s CardType=0
	s CardRowid=$o(^DHCCARDi("CF",0,"CardNo",CardNo,""))
	i CardRowid'=""{
		s CardType=$p($g(^DHCCARD("CF",CardRowid)),"^",16)
	}
	Q CardType
}

/// Backup 原病人日志记录更新方法,现使用AddDHCPatientUpdateLog
/// BackupUser:郭荣勇
/// BackupDate:2010-10-17
ClassMethod DHCPatientUpdateLog(LogStr As %String = "") As %String
{
 // 病人信息修改日志
	//更新前的病人信息
	;s LogStr="1987-02-17^自费^李雨辰^女^00000210^00000211^000000112^000000113"
	;s LogStr=LogStr_"^1987-02-17^自费^李雨辰^女^00000210^00000211^000000112^000000113"
	;s LogStr=LogStr_"^00000493^6^注册医疗卡"
	s ^DHCXPTest("LOVE")=LogStr
	s UPPSbor=$p(LogStr,"^",1)		;出生日期
	s UPPSbor=..%ZDH(UPPSbor) //$zdh(UPPSbor,3)		
	s UPPSlx=$p(LogStr,"^",2)		;病人类型
	s UPPSname=$p(LogStr,"^",3)
	s UPPSsex=$p(LogStr,"^",4)
	s UPPSEastopno=$p(LogStr,"^",5)
	s UPPSEastipno=$p(LogStr,"^",6)
	s UPPSWestopno=$p(LogStr,"^",7)
	s UPPSWestipno=$p(LogStr,"^",8)
	s UPPSInsuranceNo=$p(LogStr,"^",9) 	//医保号
	s UPPSIDCardNo=$p(LogStr,"^",10)	//身份证号		
	s UPPSNation=$p(LogStr,"^",11)		//民族
	s UPPSOccupation=$p(LogStr,"^",12)	//职业
	s UPPSCompany=$p(LogStr,"^",13)		//工作单位,暂时没有
	s UPPSAddress=$p(LogStr,"^",14)		//地址
	s UPPSRelation=$p(LogStr,"^",15)		//联系人
	s UPPSRelationship=$p(LogStr,"^",16)	//与联系人的关系
	s UPPSTelH=$p(LogStr,"^",17)			//联系电话
	//更新后的病人信息
	s UPPbor=$p(LogStr,"^",18)		;出生日期
	s UPPbor=..%ZDH(UPPbor) //$zdh(UPPbor,3)		
	s UPPlx=$p(LogStr,"^",19)		;病人类型
	s UPPname=$p(LogStr,"^",20)
	s UPPsex=$p(LogStr,"^",21)
	s UPPEastopno=$p(LogStr,"^",22)
	s UPPEastipno=$p(LogStr,"^",23)
	s UPPWestopno=$p(LogStr,"^",24)
	s UPPWestipno=$p(LogStr,"^",25)
	s UPPInsuranceNo=$p(LogStr,"^",26) 	//医保号
	s UPPIDCardNo=$p(LogStr,"^",27)		//身份证号		
	s UPPNation=$p(LogStr,"^",28)		//民族
	s UPPOccupation=$p(LogStr,"^",29)	//职业
	s UPPCompany=$p(LogStr,"^",30)		//工作单位,暂时没有
	s UPPAddress=$p(LogStr,"^",31)		//地址
	s UPPRelation=$p(LogStr,"^",32)		//联系人
	s UPPRelationship=$p(LogStr,"^",33)	//与联系人的关系
	s UPPTelH=$p(LogStr,"^",34)			//联系电话
	//登记号,操作员,卡号,更新日期,更新时间
	s UPPno=$p(LogStr,"^",35)
	s UPPuserDr=$p(LogStr,"^",36)
	s UPCardDesc=$p(LogStr,"^",37)
	s UPPCardNo=..GetUPCardNo(UPPno,UPCardDesc)
	s UPPDate=..%SysDate()
	s UPPTime=..%SysTime()
	
	TStart
	/*
	&sql(insert into SQLUser.DHCUPPerson 
			(UPPSbor,UPPSlx,UPPSname,UPPSsex,UPPSEastopno,UPPSEastipno,UPPSWestopno,UPPSWestipno,
			UPPSInsuranceNo,UPPSIDCardNo,UPPSNation,UPPSOccupation,UPPSCompany,UPPSAddress,
			UPPSRelation,UPPSRelationship,UPPSTelH,
			UPPbor,UPPlx,UPPname,UPPsex,UPPEastopno,UPPEastipno,UPPWestopno,UPPWestipno,
			UPPInsuranceNo,UPPIDCardNo,UPPNation,UPPOccupation,UPPCompany,UPPAddress,
			UPPRelation,UPPRelationship,UPPTelH,
			UPPno,UPPuserDr,UPPCardNo,UPPDate,UPPTime) 
			values(:UPPSbor,:UPPSlx,:UPPSname,:UPPSsex,:UPPSEastopno,:UPPSEastipno,:UPPSWestopno,:UPPSWestipno,
			:UPPSInsuranceNo,:UPPSIDCardNo,:UPPSNation,:UPPSOccupation,:UPPSCompany,:UPPSAddress,
			:UPPSRelation,:UPPSRelationship,:UPPSTelH,
			:UPPbor,:UPPlx,:UPPname,:UPPsex,:UPPEastopno,:UPPEastipno,:UPPWestopno,:UPPWestipno,
			:UPPInsuranceNo,:UPPIDCardNo,:UPPNation,:UPPOccupation,:UPPCompany,:UPPAddress,
			:UPPRelation,:UPPRelationship,:UPPTelH,
			:UPPno,:UPPuserDr,:UPPCardNo,:UPPDate,:UPPTime)
		)
		*/
	if SQLCODE'=0{
		TRollback
		w "数据插入错误,错误代码:"_SQLCODE,!
		quit -100
	}
	else{
		TCommit
		quit 0	
	}
}

ClassMethod AddDHCEntityInfo(PAPersonInfo, PatObj As web.DHCEntity.PCA.PATMAS)
{
	s PAPMIRowID=PatObj.PAPMIRowID
	Set person = ##class(User.PAPerson).%OpenId(PAPMIRowID)
	Set patmas = ##class(User.PAPatMas).%OpenId(PAPMIRowID)
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(PAPersonInfo,.tDocument)
	if $$$ISERR(tSC) {
		Quit "xml结构错误"
	}
	set tSC="<Address>"
	if (PAPersonInfo'[tSC)
	{
		s PatObj.Address=$p($g(^PAPER(PAPMIRowID,"PER","ADD",1)),"^",1)	
	}
	set tSC="<Allergy>"
	if (PAPersonInfo'[tSC)
	{
		s PatObj.Allergy=$g(^PAPER(PAPMIRowID,"ALLERGY",1)) ;
	}
	set tSC="<Birth>"
	if (PAPersonInfo'[tSC)
	{
		s PatObj.Birth=person.PAPERDob
	}
	set tSC="<CTRelationDR>"
	if (PAPersonInfo'[tSC)
	{
		s PatObj.CTRelationDR=$p($g(^PAPER(PAPMIRowID,"EMP")),"^",4)
	}
	set tSC="<CityDescLookUpRowID>"
	if (PAPersonInfo'[tSC)
	{
		s PatObj.CityDescLookUpRowID=person.PAPERCityCodeDRGetObjectId()
	}
	set tSC="<CityAreaLookUpRowID>"
	if (PAPersonInfo'[tSC)
	{
		s PatObj.CityAreaLookUpRowID=person.PAPERCityAreaDRGetObjectId()
	}
	set tSC="<EmployeeCompanyLookUpRowID>"
	if (PAPersonInfo'[tSC)
	{
		s PatObj.EmployeeCompanyLookUpRowID=person.PAPEREmployeeCompanyGetObjectId()
	}
	set tSC="<CountryDescLookUpRowID>"
	if (PAPersonInfo'[tSC)
	{
		s PatObj.CountryDescLookUpRowID=person.PAPERCountryDRGetObjectId()
	}
	set tSC="<CredType>"
	if (PAPersonInfo'[tSC)
	{
		s PatObj.CredType=patmas.PAPMICardTypeDRGetObjectId()
	}
	set tSC="<CredNo>"
	if (PAPersonInfo'[tSC)
	{
		s PatObj.CredNo=patmas.PAPMIDVAnumber
	}
	set tSC="<EMail>"
	if (PAPersonInfo'[tSC)
	{
		s PatObj.EMail=person.PAPEREmail
	}
	set tSC="<ForeignName>"
	if (PAPersonInfo'[tSC)
	{
		s PatObj.ForeignName=person.PAPERForeignId
	}
	set tSC="<EmployeeCompany>"
	if (PAPersonInfo'[tSC)
	{
		s PatObj.EmployeeCompany=person.PAPEREmployeeCompanyGetObjectId()
	}
	set tSC="<PAPMINo>"
	if (PAPersonInfo'[tSC)
	{
		s PatObj.PAPMINo=$P(^PAPER(PAPMIRowID,"PAT",1),"^",1)
	}
	set tSC="<IDCardNo1>"
	if (PAPersonInfo'[tSC)
	{
		set tSC="<CredNo>"
		if (PAPersonInfo'[tSC){
			s PatObj.IDCardNo1=person.PAPERID
		}
	}
	set tSC="<InMedicare>"
	if (PAPersonInfo'[tSC)
	{
		s PatObj.InMedicare=patmas.PAPMIMedicare
	}
	set tSC="<MobPhone>"
	if (PAPersonInfo'[tSC)
	{
		s PatObj.MobPhone=patmas.PAPMIMobPhone
	}
	set tSC="<Name>"
	if (PAPersonInfo'[tSC)
	{
		s PatObj.Name=person.PAPERName 
	}
	set tSC="<NationDescLookUpRowID>"
	if (PAPersonInfo'[tSC)
	{
		s PatObj.NationDescLookUpRowID=person.PAPERNationDRGetObjectId()
	}
	set tSC="<OpMedicare>"
	if (PAPersonInfo'[tSC)
	{
		s PatObj.OpMedicare=person.PAPERGovernCardNo
	}
	set tSC="<PatType>"
	if (PAPersonInfo'[tSC)
	{
		s PatObj.PatType=person.PAPERSocialStatusDRGetObjectId()
	}
	set tSC="<ProvinceInfoLookUpRowID>"
	if (PAPersonInfo'[tSC)
	{
		s PatObj.ProvinceInfoLookUpRowID=person.PAPERCTProvinceDRGetObjectId()
	}
	set tSC="<Sex>"
	if (PAPersonInfo'[tSC)
	{
		s PatObj.Sex=person.PAPERSexDRGetObjectId()
	}
	set tSC="<TelHome>"
	if (PAPersonInfo'[tSC)
	{
		s PatObj.TelHome=person.PAPERTelH
	}
	set tSC="<TelOffice>"
	if (PAPersonInfo'[tSC)
	{
		s PatObj.TelOffice=person.PAPERTelO
	}
	set tSC="<UpdateDate>"
	if (PAPersonInfo'[tSC)
	{
		s PatObj.UpdateDate=person.PAPERUpdateDate
	}
	set tSC="<UserDR>"
	if (PAPersonInfo'[tSC)
	{
		s PatObj.UserDR=person.PAPERUserAddedDRGetObjectId()
	}
	set tSC="<UpdateTime>"
	if (PAPersonInfo'[tSC)
	{
		s PatObj.UpdateTime=person.PAPERUpdateTime
	}
	set tSC="<Vocation>"
	if (PAPersonInfo'[tSC)
	{
		s PatObj.Vocation=person.PAPEROccupationDRGetObjectId()
	}
	set tSC="<ZipLookUpRowID>"
	if (PAPersonInfo'[tSC)
	{
		s PatObj.ZipLookUpRowID=person.PAPERZipDRGetObjectId()
	}
	set tSC="<PatYBCode>"
	if (PAPersonInfo'[tSC)
	{
		s PatObj.PatYBCode=$p($g(^PAPER(PAPMIRowID,"PAT",3)),"^",12)
	}
	set tSC="<MedicalCardNo>"
	if (PAPersonInfo'[tSC)
	{
		s PatObj.MedicalCardNo=""
	}
	set tSC="<OtherCardInfo>"
	if (PAPersonInfo'[tSC)
	{
		s CardType=""
		for {
			Set CardType=$O(^DHCPCNi("PAPMI",PAPMIRowID,CardType))
			q:CardType=""
			s DHCPCNROWID=""
			for {
				Set DHCPCNROWID=$O(^DHCPCNi("PAPMI",PAPMIRowID,CardType,DHCPCNROWID))
				q:DHCPCNROWID=""
				s CardNo=$P(^DHCPCN(DHCPCNROWID),"^",4)
				if (PatObj.OtherCardInfo=""){s PatObj.OtherCardInfo=CardType_"^"_CardNo}
				else{s PatObj.OtherCardInfo=PatObj.OtherCardInfo_"!"_CardType_"^"_CardNo}
			}
		}
	}
	set tSC="<EmployeeNo>"
	if (PAPersonInfo'[tSC)
	{
		s PatObj.EmployeeNo=person.PAPEREmployeeNo
	}
	set tSC="<HCPDR>"
	if (PAPersonInfo'[tSC)
	{
		s PatObj.HCPDR=$p($g(^PAPER(PAPMIRowID,"PER",4)),"^",17) 
	}
	set tSC="<AdmReason>"
	if (PAPersonInfo'[tSC)
	{
		s PatObj.AdmReason=$P($G(^PAPER(PAPMIRowID,"DHCINS")),"^",3)
	}
	set tSC="<InsurCardNo>"
	if (PAPersonInfo'[tSC)
	{
		s PatObj.InsurCardNo=$P($G(^PAPER(PAPMIRowID,"DHCINS")),"^",2)
	}
	set tSC="<PAPERMarital>"
	if (PAPersonInfo'[tSC)
	{
		s PatObj.PAPERMarital=person.PAPERMaritalDRGetObjectId()
	}
	set tSC="<MedUnionCard>"
	if (PAPersonInfo'[tSC)
	{
		s PatObj.MedUnionCard=""
	}
	set tSC="<ForeignCredType>"
	if (PAPersonInfo'[tSC)
	{
		s PatObj.ForeignCredType=person.PAPERForeignCardTypeDRGetObjectId()
	}
	set tSC="<ForeignIDCard>"
	if (PAPersonInfo'[tSC)
	{
		s PatObj.ForeignIDCard=person.PAPERForeignCountry
	}
	set tSC="<ForeignPhone>"
	if (PAPersonInfo'[tSC)
	{
		s PatObj.ForeignPhone=person.PAPERForeignPhone
	}
	set tSC="<HealthCareRegion>"
	if (PAPersonInfo'[tSC)
	{
		if (person.PAPERStayingPermanently ="Y"){
		s PatObj.HealthCareRegion="on"
		}
	}
	set tSC="<Company>"
	if (PAPersonInfo'[tSC)
	{
		s PatObj.Company=person.PAPERSecondPhone
	}
	set tSC="<VIPFlag>"
	if (PAPersonInfo'[tSC)
	{
		if (patmas.PAPMIVIPFlag="Y"){
			s PatObj.VIPFlag="on"
		}
	}
	set tSC="<BirthPlace>"
	if (PAPersonInfo'[tSC)
	{
		s DHCPersonID=$O(^DHCPERSON(0,"PAPERSON",PAPMIRowID,0))
		i DHCPersonID'="" d
		.s PatObj.BirthPlace=$P(^DHCPERSON(DHCPersonID),"^",16)
	}
	set tSC="<BloodType>"
	if (PAPersonInfo'[tSC)
	{
		s PatObj.BloodType=person.PAPERBloodTypeDR
	}
	set tSC="<CompanyPostCode>"
	if (PAPersonInfo'[tSC)
	{
		s PatObj.CompanyPostCode=person.PAPERName6
	}
	set tSC="<ForeignAddress>"
	if (PAPersonInfo'[tSC)
	{
		s PatObj.ForeignAddress=person.PAPERForeignAddress
	}
	set tSC="<ForeignPostCode>"
	if (PAPersonInfo'[tSC)
	{
		s PatObj.ForeignPostCode=person.PAPERForeignPostCode
	}
	set tSC="<GPOrgAddress>"
	if (PAPersonInfo'[tSC)
	{
		s PatObj.GPOrgAddress=$g(^PAPER(PAPMIRowID,"GPA",1))
	}
	set tSC="<HomePlace>"
	if (PAPersonInfo'[tSC)
	{
		s PatObj.HomePlace=$P($G(^PAPER(PAPMIRowID ,"DHC")),"^",32)
	}
	set tSC="<HouseArea>"
	if (PAPersonInfo'[tSC)
	{
		s PatObj.HouseArea=$P($G(^PAPER(PAPMIRowID ,"DHC")),"^",34)
	}
	set tSC="<PostCode>"
	if (PAPersonInfo'[tSC)
	{
		s DHCPersonID=$O(^DHCPERSON(0,"PAPERSON",PAPMIRowID,0))
		i DHCPersonID'="" d
		.s PatObj.PostCode=$P(^DHCPERSON(DHCPersonID),"^",8)
	}
	set tSC="<RegisterPlace>"
	if (PAPersonInfo'[tSC)
	{
		s DHCPersonID=$O(^DHCPERSON(0,"PAPERSON",PAPMIRowID,0))
		i DHCPersonID'="" d
		.s PatObj.RegisterPlace=$P(^DHCPERSON(DHCPersonID),"^",20)
	}
	set tSC="<PhotoInfo>"
	if (PAPersonInfo'[tSC)
	{
		s PatObj.PhotoInfo=person.PAPERPhoto
	}
	set tSC="<ProvinceHome>"
	if (PAPersonInfo'[tSC)
	{
		s PatObj.ProvinceHome=person.PAPERProvinceBirthDRGetObjectId()
	}
	set tSC="<CityHome>"
	if (PAPersonInfo'[tSC)
	{
		s PatObj.CityHome=person.PAPERCityBirthDRGetObjectId()
	}
	set tSC="<ProvinceBirth>"
	if (PAPersonInfo'[tSC)
	{
		s DHCPersonID=$O(^DHCPERSON(0,"PAPERSON",PAPMIRowID,0))
		i DHCPersonID'="" d
		.s PatObj.ProvinceBirth=$P(^DHCPERSON(DHCPersonID),"^",13)
		//s PatObj.ProvinceBirth=person.PAPERProvinceBirthDRGetObjectId()
	}
	set tSC="<CityBirth>"
	if (PAPersonInfo'[tSC)
	{
		s DHCPersonID=$O(^DHCPERSON(0,"PAPERSON",PAPMIRowID,0))
		i DHCPersonID'="" d
		.s PatObj.CityBirth=$P(^DHCPERSON(DHCPersonID),"^",14)
		//s PatObj.CityBirth=person.PAPERCityBirthDRGetObjectId()
	}
	set tSC="<AreaBirth>"
	if (PAPersonInfo'[tSC)
	{
		s DHCPersonID=$O(^DHCPERSON(0,"PAPERSON",PAPMIRowID,0))
		i DHCPersonID'="" d
		.s PatObj.AreaBirth=$P(^DHCPERSON(DHCPersonID),"^",15)
	}
	set tSC="<AddressBirth>"
	if (PAPersonInfo'[tSC)
	{
		s DHCPersonID=$O(^DHCPERSON(0,"PAPERSON",PAPMIRowID,0))
		i DHCPersonID'="" d
		.s PatObj.AddressBirth=$P(^DHCPERSON(DHCPersonID),"^",16)
	}
	set tSC="<ProvinceHouse>"
	if (PAPersonInfo'[tSC)
	{
		s DHCPersonID=$O(^DHCPERSON(0,"PAPERSON",PAPMIRowID,0))
		i DHCPersonID'="" d
		.s PatObj.ProvinceHouse=$P(^DHCPERSON(DHCPersonID),"^",17)
	}
	set tSC="<Cityhouse>"
	if (PAPersonInfo'[tSC)
	{
		s DHCPersonID=$O(^DHCPERSON(0,"PAPERSON",PAPMIRowID,0))
		i DHCPersonID'="" d
		.s PatObj.Cityhouse=$P(^DHCPERSON(DHCPersonID),"^",18)
	}
	set tSC="<AreaHouse>"
	if (PAPersonInfo'[tSC)
	{
		s DHCPersonID=$O(^DHCPERSON(0,"PAPERSON",PAPMIRowID,0))
		i DHCPersonID'="" d
		.s PatObj.AreaHouse=$P(^DHCPERSON(DHCPersonID),"^",19)
	}
	set tSC="<PostCodeHouse>"
	if (PAPersonInfo'[tSC)
	{
		s DHCPersonID=$O(^DHCPERSON(0,"PAPERSON",PAPMIRowID,0))
		i DHCPersonID'="" d
		.s PatObj.PostCodeHouse=$P(^DHCPERSON(DHCPersonID),"^",9)
	}
	set tSC="<PoliticalLevel>"
	if (PAPersonInfo'[tSC)
	{
		s PatObj.PoliticalLevel=person.PAPEREmployeeFunctionGetObjectId()
	}
	set tSC="<SecretLevel>"
	if (PAPersonInfo'[tSC)
	{
		s PatObj.SecretLevel=$P(^PAPER(PAPMIRowID ,"DHC"),"^",30)
	}
	set tSC="<BirthTime>"
	if (PAPersonInfo'[tSC)
	{
		s PatObj.BirthTime=$p($g(^PAPER(PAPMIRowID,"DHC")),"^",1)
	}
	set tSC="<Age>"
	if (PAPersonInfo'[tSC)
	{
		s PatObj.Age=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.reg.GetPapmiAge",PAPMIRowID,"")
	}
	set tSC="<StreetHouse>"
	if (PAPersonInfo'[tSC)
	{
		s PatObj.StreetHouse=$p($g(^PAPER(PAPMIRowID,"DHC")),"^",53)
	}
	set tSC="<StreetBirth>"
	if (PAPersonInfo'[tSC)
	{
		s PatObj.StreetBirth=$p($g(^PAPER(PAPMIRowID,"DHC")),"^",52)
	}
	set tSC="<AreaHome>"
	if (PAPersonInfo'[tSC)
	{
		s PatObj.AreaHome=person.PAPERAreaHomeDRGetObjectId()
	}
	set tSC="<CountryBirth>"
	if (PAPersonInfo'[tSC)
	{
		s PatObj.CountryBirth=$p($g(^PAPER(PAPMIRowID,"ALL")),"^",26)
	}

	set tSC="<CountryHome>"
	if (PAPersonInfo'[tSC)
	{
		s PatObj.CountryHome=$p($g(^PAPER(PAPMIRowID,"PER",5)),"^",12)
	}
	
	set tSC="<CountryHouse>"
	if (PAPersonInfo'[tSC)
	{
		s PatObj.CountryHouse=$p($g(^PAPER(PAPMIRowID,"ALL")),"^",11)
	}
	q PatObj
}

}
