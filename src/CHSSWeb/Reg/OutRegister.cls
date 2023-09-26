Import sqluser

Class CHSSWeb.Reg.OutRegister Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/*
Query SelData() As %SQLQuery(CONTAINID = 1)
{
SELECT * FROM PA_Person
}

/// 修改一条记录
ClassMethod Upd(id, cityArea, cityBirth, city, contactNotes, country, dob, education, eMail, ID, name, nation, occupation, sex, socialStatus, street, tel, upddate, zip, contactPerson, familyRelation, familyAddress, province, lang, active, medicare, cardType, user, dvaNumber) As %String
{
 
 q:##class(User.PAPerson).%ExistsId(id)=0 ""
 s dd=+$h
 s tt=$p($h,",",2)

	i (country="")&(province'="") d
	.&sql(select prov_region_dr->ctrg_country_dr into :country from ct_province where prov_rowid=:province)
	
 i dob'="" s dob=$zdh(dob,3)  
 &sql(update PA_Person set
		PAPER_CityArea_DR=:cityArea,	
		PAPER_CityBirth_DR=:cityBirth,   	
		PAPER_CityCode_DR=:city , 
		PAPER_ContactNotes=:contactNotes,   	
 	PAPER_Country_DR =:country,  
 	PAPER_Dob =:dob,  
 	PAPER_Education_DR =:education ,
 	PAPER_Email=:eMail,
 	PAPER_ID  =:ID,  
 	PAPER_Name = :name ,
 	PAPER_Nation_DR =:nation ,
 	PAPER_Occupation_DR =:occupation,  
 	PAPER_Sex_DR=:sex,  
 	PAPER_SocialStatus_DR=:socialStatus , 
 	PAPER_StName =:street, 
 	PAPER_TelH =:tel,  
  PAPER_UpdateDate=:upddate , 
 	PAPER_Zip_DR=:zip,
  PAPER_ForeignId =:contactPerson,  	
  PAPER_CTRLT_DR =:familyRelation,  	
 	PAPER_ForeignAddress =:familyAddress , 
 	PAPER_CT_Province_DR= :province ,
 	PAPER_UserUpdate=:user,
 	PAPER_UpdateDate=:dd,
 	PAPER_UpdateTime=:tt
 	where PAPER_Rowid=:id)
  q:SQLCODE ""
  
 &sql(update PA_PatMas SET PAPMI_LangPrim_DR=:lang,
   PAPMI_Active=:active,
   PAPMI_Medicare=:medicare,
   PAPMI_CardType_DR=:cardType,
   PAPMI_DVAnumber=:dvaNumber
 where papmi_rowid=:id)
 q:SQLCODE ""

	q 0
}

/// 删除
ClassMethod Del(id) As %String
{
	&sql(delete from PA_PatMas where PAPMI_RowId=:id)
	q SQLCODE
}

/// 插入一条记录到 PA_Person
ClassMethod Ins(cityArea, cityBirth, city, contactNotes, country, dob, education, eMail, ID, name, nation, occupation, sex, socialStatus, street, tel, upddate, zip, contactPerson, familyRelation, familyAddress, province, lang, active, medicare, cardType, user, dvaNumber) As %String
{
 q:name="" ""
 q:sex="" ""
	
	s dd=+$H
	s tt=$p($h,",",2)
	
	i (country="")&(province'="") d
	.&sql(select prov_region_dr->ctrg_country_dr into :country from ct_province where prov_rowid=:province)
	
	&sql( insert into PA_Person (
			PAPER_CityArea_DR,
			PAPER_CityBirth_DR,
			PAPER_CityCode_DR,
			PAPER_ContactNotes,
			PAPER_Country_DR, 
			PAPER_Dob, 
			PAPER_Education_DR, 
			PAPER_Email,
			PAPER_ID,  
			PAPER_Name, 
			PAPER_Nation_DR,
			PAPER_Occupation_DR,
			PAPER_Sex_DR,
			PAPER_SocialStatus_DR,
			PAPER_StName, 
			PAPER_TelH, 
			PAPER_UpdateDate,
			PAPER_Zip_DR,
			PAPER_ForeignId ,
			PAPER_CTRLT_DR, 
			PAPER_ForeignAddress ,
			PAPER_CT_Province_DR,
		    paper_UserAdded_DR,
			paper_dateAdded,
		    paper_userUpdate,
		    paper_updateDate,
		    paper_updateTime
			) 
 values (
			:cityArea,
			:cityBirth,   
			:city,
			:contactNotes,
			:country,
			:dob,
			:education,
			:eMail,
			:ID,
			:name,
			:nation,
			:occupation,
			:sex,
			:socialStatus,
			:street,
			:tel,
			:upddate,
			:zip,
			:contactPerson,
			:familyRelation, 
			:familyAddress,  
			:province,
			:user,
			:dd,
			:user,
			:dd,
			:tt
 )	)
 
 q:%ROWID="" ""
 s newid=%ROWID
 
 ///更新pa_patmas中其他信息
 &sql(update PA_PatMas SET PAPMI_LangPrim_DR=:lang,
   PAPMI_Active=:active,
   PAPMI_Medicare=:medicare,
   PAPMI_CardType_DR=:cardType,
   PAPMI_DVAnumber=:dvaNumber
 where papmi_rowid=:newid)
 q:SQLCODE ""
 
 //更新登记号 
 i 'SQLCODE d ..SetRegNo(newid)
  //
	q SQLCODE_"^"_newid
}

/// id:PAPMI_RowId
/// no:登记号
/// 
ClassMethod GetJsonData(id As %String, no As %String = "") As %String
{
	n (id,no)
	s id=$g(id)
	s no=$g(no)
	
	s rs=##class(%ResultSet).%New()
	
	i id'="" d
	.d rs.Prepare("select * from PA_Person where PAPER_Rowid="_id)
	.d rs.Execute()
	e  d
	.i no'="" d
	..s no=..FormatPatientNo(no)
	..q:no=""
	..s paper=$O(^PAPERi("PAPMI_PatNo",$zcvt(no,"U"),""))
	..q:paper=""
	..d rs.Prepare("select * from PA_Person where PAPER_Rowid="_paper)
	..d rs.Execute()
	.e  d
	..s rs.ClassName="CHSSHIS.PAPerson"
	..s rs.QueryName="SelData"
	..	d rs.Execute()
	
	s mess="",count=0
	While (rs.Next())
	{
	  s rowid=rs.Get("PAPER_RowId")
	  s paId=rs.Get("PAPER_ID")
	  s name=rs.Get("PAPER_Name")
	  s name2=rs.Get("PAPER_Name2")
	  s name3=rs.Get("PAPER_Name3")
	  s dob=rs.Get("PAPER_Dob")
	  s sex=rs.Get("PAPER_Sex_DR")
	  s sexDesc="" i sex'="" s sexDesc=$p($g(^CT("SEX",sex)),"^",2)
	  s province=rs.Get("PAPER_CT_Province_DR")
	  s provinceDesc="" i province'="" s provinceDesc=$P($g(^CT("PROV",province)),"^",2)
	s ForeignId=rs.Get("PAPER_ForeignId")			
	  //s age=rs.Get("PAPER_Age")			
	  
	  s ageYr=rs.Get("PAPER_AgeYr")			
	  s ageMth=rs.Get("PAPER_AgeMth")			
	  s ageDay=rs.Get("PAPER_AgeDay")			
	  
	  s age=..FormatAge(ageYr,ageMth,ageDay)
	  s userUpdate=rs.Get("PAPER_UserUpdate")  
	  s userNameUpdate="" i userUpdate'="" s userNameUpdate=$p($g(^SSU("SSUSR",userUpdate)),"^",2)
	  s userAdded=rs.Get("PAPER_UserAdded_DR")  
	  s userNameAdded="" i userAdded'="" s userNameAdded=$p($g(^SSU("SSUSR",userAdded)),"^",2)
	  
	  s region=rs.Get("PAPER_CT_Region_DR")
	  s regionDesc="" i region'="" s regionDesc=$p($g(^CT("RG",region)),"^",2)
	  s cityArea=rs.Get("PAPER_CityArea_DR")			  
	  s cityAreaDesc="" i cityArea'="" s cityAreaDesc=$p($g(^CT("CITAREA",cityArea)),"^",2)
	  s occupation=rs.Get("PAPER_Occupation_DR")
	  s occupationDesc="" i occupation'="" s occupationDesc=$p($g(^CT("OCC",occupation)),"^",2)
	  s religion=rs.Get("PAPER_Religion_DR") 
	  s religionDesc="" i religion'="" s religionDesc=$p($g(^CT("RLG",religion)),"^",2)
	  s socialStatus=rs.Get("PAPER_SocialStatus_DR")
	  s socialStatusDesc="" i socialStatus'="" s socialStatusDesc=$p($g(^CT("SS",socialStatus)),"^",2)
	  s zip=rs.Get("PAPER_Zip_DR")
	  s zipCode="" i zip'="" s zipCode=$p($g(^CT("ZIP",zip)),"^",1)
	  s nation=rs.Get("PAPER_Nation_DR")
	  s nationDesc="" i nation'="" s nationDesc=$p($g(^CT("NAT",nation)),"^",2)
	  s education=rs.Get("PAPER_Education_DR")
	  s educationDesc="" i education'="" s educationDesc=$p($g(^CT("EDU",education)),"^",1)
	  s country=rs.Get("PAPER_Country_DR")
	  s countryDesc="" i country'="" s countryDesc=$p($g(^CT("COU",country)),"^",2)
	  s email=rs.Get("PAPER_Email")
	  s contactNotes=rs.Get("PAPER_ContactNotes")
	  s city=rs.Get("PAPER_CityCode_DR")
	  s cityDesc="" i city'="" s cityDesc=$p($g(^CT("CIT",city)),"^",2)
	  s cityBirth=rs.Get("PAPER_CityBirth_DR")
	  s cityBirthDesc="" i cityBirth'="" s cityBirthDesc=$p($g(^CT("CIT",cityBirth)),"^",2)
	  s tel=rs.Get("PAPER_TelH")
		s relation=rs.Get("PAPER_CTRLT_DR")
		s relationDesc="" i relation'="" s relationDesc=$p($g(^CT("RLT",relation)),"^",2)

	  s patRs=##class(%ResultSet).%New()
	  d patRs.Prepare("select * from PA_PatMas where PAPMI_RowId="_rowid)
	  d patRs.Execute()
	  d patRs.Next()
	  s regNo=patRs.Get("PAPMI_No")
	  s ipNo=patRs.Get("PAPMI_IPNo")
	  s opNo=patRs.Get("PAPMI_OPNo")
	  s lang=patRs.Get("PAPMI_LangPrim_DR")  
	  s langDesc="" i lang'="" s langDesc=$p($g(^SS("LAN",lang)),"^",2)
	  s active=patRs.Get("PAPMI_Active")
	  s index=patRs.Get("PAPMI_IndexMark")
	  s black=patRs.Get("PAPMI_BlackList")
	  s medicare=patRs.Get("PAPMI_Medicare")
	  s medicareStr=patRs.Get("PAPMI_MedicareString")
	  s eprDesc=patRs.Get("PAPMI_EPRDescription")
	  s cardType=patRs.Get("PAPMI_CardType_DR")
	  s cardTypeDesc="" i cardType'="" s cardTypeDesc=$p($g(^PAC("CARD",cardType)),"^",2)          
	  s dvaNumber=patRs.Get("PAPMI_DVAnumber")
			
		s count=count+1
		i (mess'="") s mess=mess_","
		s mess=mess_"{"_"id"_":"_""""_rowid_""""
		s mess=mess_","_"paId"_":"_""""_paId_""""
		s mess=mess_","_"name"_":"_""""_name_""""
		s mess=mess_","_"name2"_":"_""""_name2_""""
		s mess=mess_","_"name3"_":"_""""_name3_""""
		s mess=mess_","_"regNo"_":"_""""_regNo_""""
		s mess=mess_","_"ipNo"_":"_""""_ipNo_""""
		s mess=mess_","_"opNo"_":"_""""_opNo_""""
		s mess=mess_","_"dob"_":"_""""_$zd(dob,3)_""""
	
		s mess=mess_","_"sex"_":"_""""_sex_""""
		s mess=mess_","_"sexDesc"_":"_""""_sexDesc_""""
		s mess=mess_","_"province"_":"_""""_province_""""
		s mess=mess_","_"provinceDesc"_":"_""""_provinceDesc_""""
		
		s mess=mess_","_"lang"_":"_""""_lang_""""
		s mess=mess_","_"langDesc"_":"_""""_langDesc_""""
		
		s mess=mess_","_"active"_":"_""""_active_""""
		s mess=mess_","_"index"_":"_""""_index_""""

		s mess=mess_","_"black"_":"_""""_black_""""
		s mess=mess_","_"medicare"_":"_""""_medicare_""""
		s mess=mess_","_"medicareStr"_":"_""""_medicareStr_""""
		s mess=mess_","_"eprDesc"_":"_""""_eprDesc_""""

		s mess=mess_","_"ForeignId"_":"_""""_ForeignId_""""
		s mess=mess_","_"age"_":"_""""_age_""""
		s mess=mess_","_"ageYr"_":"_""""_ageYr_""""
		s mess=mess_","_"ageMth"_":"_""""_ageMth_""""
		s mess=mess_","_"ageDay"_":"_""""_ageDay_""""
		s mess=mess_","_"userUpdate"_":"_""""_userUpdate_""""
		s mess=mess_","_"userNameUpdate"_":"_""""_userNameUpdate_""""
		s mess=mess_","_"userAdded"_":"_""""_userAdded_""""
		s mess=mess_","_"userNameAdded"_":"_""""_userNameAdded_""""
		s mess=mess_","_"region"_":"_""""_region_""""
		s mess=mess_","_"regionDesc"_":"_""""_regionDesc_""""
		s mess=mess_","_"cityArea"_":"_""""_cityArea_""""
		s mess=mess_","_"cityAreaDesc"_":"_""""_cityAreaDesc_""""
		s mess=mess_","_"occupation"_":"_""""_occupation_""""
		s mess=mess_","_"occupationDesc"_":"_""""_occupationDesc_""""

		s mess=mess_","_"religion"_":"_""""_religion_""""
		s mess=mess_","_"religionDesc"_":"_""""_religionDesc_""""
		s mess=mess_","_"socialStatus"_":"_""""_socialStatus_""""
		s mess=mess_","_"socialStatusDesc"_":"_""""_socialStatusDesc_""""
		s mess=mess_","_"zip"_":"_""""_zip_""""
		s mess=mess_","_"zipCode"_":"_""""_zipCode_""""
		s mess=mess_","_"nation"_":"_""""_nation_""""
		s mess=mess_","_"nationDesc"_":"_""""_nationDesc_""""
		s mess=mess_","_"education"_":"_""""_education_""""
		s mess=mess_","_"educationDesc"_":"_""""_educationDesc_""""
		s mess=mess_","_"country"_":"_""""_country_""""

		s mess=mess_","_"countryDesc"_":"_""""_countryDesc_""""
		s mess=mess_","_"email"_":"_""""_email_""""
		s mess=mess_","_"contactNotes"_":"_""""_contactNotes_""""
		s mess=mess_","_"city"_":"_""""_city_""""
		s mess=mess_","_"cityDesc"_":"_""""_cityDesc_""""
		s mess=mess_","_"cityBirth"_":"_""""_cityBirth_""""
		s mess=mess_","_"cityBirthDesc"_":"_""""_cityBirthDesc_""""
		s mess=mess_","_"tel"_":"_""""_tel_""""
		s mess=mess_","_"relation"_":"_""""_relation_""""
		s mess=mess_","_"relationDesc"_":"_""""_relationDesc_""""
		
		s mess=mess_","_"cardType"_":"_""""_cardType_""""
		s mess=mess_","_"cardTypeDesc"_":"_""""_cardTypeDesc_""""
		s mess=mess_","_"dvaNumber"_":"_""""_dvaNumber_""""
  
		s mess=mess_"}"
	}
 s mess="["_mess_"]"
 
 s mess="{"_"totalCount"_":"_""""_count_""""_","_"topics"_":"_mess_"}"
 q $tr(mess,$c(13,10))
}

/// 取得新登记号
ClassMethod GetNewRegNo() As %String
{
	s myMAXNo=0
	i $d(^PAPER(0,"CNT","I")) d
	.;s myMAXNo=^PAPER(0,"CNT","I") //最大登记号
	e  d
	.s myMAXNo=0
	;s ^PAPER(0,"CNT","I")=myMAXNo+1
	s myMAXNo=$i(^PAPER(0,"CNT","I"))
	;s myMAXNo=myMAXNo+1
	s myPatLen=+$p(^CF("PATCF",1,3),"^",5)
	s myMAXNo=$e("0000000000000000000",1,myPatLen-$l(myMAXNo))_myMAXNo
	
	;s patmas.PAPMINo=myMAXNo
	;s patmas.PAPMIIPNo=myMAXNo
	;s patmas.PAPMIOPNo=myMAXNo
	
	q myMAXNo
}

//

//更新PA_PatMas中的登记号字段

ClassMethod SetRegNo(id As %String)
{
	s patmas=##class(User.PAPatMas).%OpenId(id)
	s regno=..GetNewRegNo() //获得登记号
	 
	s patmas.PAPMINo=regno
	s patmas.PAPMIIPNo=regno
 	s patmas.PAPMIOPNo=regno
 
 	d patmas.%Save()
}

ClassMethod FormatAge(AgeYear As %String, AgeMonth As %String, AgeDay As %String) As %String
{
	if AgeYear>0 s AgeDesc=AgeYear_"岁"
	else  d
	.if AgeMonth>0 s AgeDesc=AgeMonth_"月"
	.else  s AgeDesc=AgeDay_"天"
	Q AgeDesc
}

/// 格式化登记号
ClassMethod FormatPatientNo(no As %String) As %String
{
 q ##class(CHSSHIS.CHSS01).FormatPatientNo(no)
}
*/
/// creator:haiwenbo
/// date:2011-11-1
/// name:ConfigInfoXml
/// description: String参数转换成XML格式
/// input:  CardType(卡类型)  CardNo(卡号)
/// output: 补零后CardNo
/// others:
ClassMethod GetConfigInfoXml() As %String
{
	s AccManageFLag = "Y"
	s CardAccountRelation = "N"
	s CardFareCost = 0
	s CardRefFlag = "Y"
	s FareType = "NP"
	s GroupRegFlag = "PR"
	s PANoCardRefFlag = "N"
	s PatMasFlag = "Y"
	s PreCardFlag = "N"
	s SearchMasFlag = "N"
	s SecurityNoFlag = "N"
	s StChangeValidateFlag = "N"
	s ConfigInfoXml = "<CardTypeConfig><AccManageFLag>"_AccManageFLag_"</AccManageFLag><CardAccountRelation>"_CardAccountRelation_"</CardAccountRelation><CardFareCost>"_CardFareCost_"</CardFareCost><CardRefFlag>"_CardRefFlag_"</CardRefFlag><FareType>"_FareType_"</FareType><GroupRegFlag>"_GroupRegFlag_"</GroupRegFlag><PANoCardRefFlag>"_PANoCardRefFlag_"</PANoCardRefFlag><PatMasFlag>"_PatMasFlag_"</PatMasFlag><PreCardFlag>"_PreCardFlag_"</PreCardFlag><SearchMasFlag>"_SearchMasFlag_"</SearchMasFlag><SecurityNoFlag>"_SecurityNoFlag_"</SecurityNoFlag><StChangeValidateFlag>"_StChangeValidateFlag_"</StChangeValidateFlag></CardTypeConfig>"
	
	q ConfigInfoXml
}

ClassMethod GetPaPatInfoXml(Address As %String, Birth As %String, CredNo As %String, EmployeeCompany As %String, IDCardNo1 As %String, MobPhone As %String, Name As %String, PatYBCode As %String, Sex As %String, TelHome As %String) As %String
{
 
	;s Address = "北京市"
	s Allergy = ""
	;s Birth = "1985-10-08"
	s CTRelationDR = ""
	s CityAreaLookUpRowID = ""
	s CityDescLookUpRowID = ""
	s CountryDescLookUpRowID = "1"
	;s CredNo = "610324198510080010"
	s CredType = "1"
	s EMail = ""
	;s EmployeeCompany = "北京东华"
	s EmployeeCompanyLookUpRowID = ""
	s ForeignName = ""
	;s IDCardNo1 = "610324198510080010"
	s InMedicare = ""
	s MedicalCardNo = ""
	;s MobPhone = "13311021008"
	;s Name = "慕容云海"
	s NationDescLookUpRowID = "1"
	s OpMedicare = ""
	s OtherCardInfo = ""
	s PAPMINo = ""
	s PAPMIRowID = ""
	s PatType = "2"
	;s PatYBCode = "12312312312S"
	s ProvinceInfoLookUpRowID = ""
	;s Sex = "2"
	;s TelHome = "18003261575"
	s TelOffice = ""
	s UpdateDate = ""
	s UpdateTime = ""
	s UserDR = "639"
	s Vocation = ""
	s ZipLookUpRowID = ""
	
	s PaPatInfoXml = "<PATMAS><Address>"_Address_"</Address><Allergy>"_Allergy_"</Allergy><Birth>"_Birth_"</Birth><CTRelationDR>"_CTRelationDR_"</CTRelationDR><CityAreaLookUpRowID>"_CityAreaLookUpRowID_"</CityAreaLookUpRowID><CityDescLookUpRowID>"_CityDescLookUpRowID_"</CityDescLookUpRowID><CountryDescLookUpRowID>"_CountryDescLookUpRowID_"</CountryDescLookUpRowID><CredNo>"_CredNo_"</CredNo><CredType>"_CredType_"</CredType><EMail>"_EMail_"</EMail><EmployeeCompany>"_EmployeeCompany_"</EmployeeCompany><EmployeeCompanyLookUpRowID>"_EmployeeCompanyLookUpRowID_"</EmployeeCompanyLookUpRowID><ForeignName>"_ForeignName_"</ForeignName><IDCardNo1>"_IDCardNo1_"</IDCardNo1><InMedicare>"_InMedicare_"</InMedicare><MedicalCardNo>"_MedicalCardNo_"</MedicalCardNo><MobPhone>"_MobPhone_"</MobPhone><Name>"_Name_"</Name><NationDescLookUpRowID>"_NationDescLookUpRowID_"</NationDescLookUpRowID><OpMedicare>"_OpMedicare_"</OpMedicare><OtherCardInfo>"_OtherCardInfo_"</OtherCardInfo><PAPMINo>"_PAPMINo_"</PAPMINo><PAPMIRowID>"_PAPMIRowID_"</PAPMIRowID><PatType>"_PatType_"</PatType><PatYBCode>"_PatYBCode_"</PatYBCode><ProvinceInfoLookUpRowID>"_ProvinceInfoLookUpRowID_"</ProvinceInfoLookUpRowID><Sex>"_Sex_"</Sex><TelHome>"_TelHome_"</TelHome><TelOffice>"_TelOffice_"</TelOffice><UpdateDate>"_UpdateDate_"</UpdateDate><UpdateTime>"_UpdateTime_"</UpdateTime><UserDR>"_UserDR_"</UserDR><Vocation>"_Vocation_"</Vocation><ZipLookUpRowID>"_ZipLookUpRowID_"</ZipLookUpRowID></PATMAS>"
	
	q PaPatInfoXml
}

ClassMethod GetCardInfoXml(CardNo As %String, CredNo As %String) As %String
{
	s ActiveFlag = ""
	s CFAccNoDR = ""
	s CFDate = ""
	s CFTime = ""
	s CardINVPRTDR = ""
	;s CardNo = "000000111117"
	s CardRowID = ""
	s CardTypeDefine = "1"
	s ComputerIP = "HAIWENBO"
	;s CredNo = "610324198510080010"
	s FareType = ""
	s PAPMINo = ""
	s PAPMIRowID = ""
	s SecurityNo = ""
	s UserDR = "639"
	
	s CardInfoXml = "<CardRef><ActiveFlag>"_ActiveFlag_"</ActiveFlag><CFAccNoDR>"_CFAccNoDR_"</CFAccNoDR><CFDate>"_CFDate_"</CFDate><CFTime>"_CFTime_"</CFTime><CardINVPRTDR>"_CardINVPRTDR_"</CardINVPRTDR><CardNo>"_CardNo_"</CardNo><CardRowID>"_CardRowID_"</CardRowID><CardTypeDefine>"_CardTypeDefine_"</CardTypeDefine><ComputerIP>"_ComputerIP_"</ComputerIP><CredNo>"_CredNo_"</CredNo><FareType>"_FareType_"</FareType><PAPMINo>"_PAPMINo_"</PAPMINo><PAPMIRowID>"_PAPMIRowID_"</PAPMIRowID><SecurityNo>"_SecurityNo_"</SecurityNo><UserDR>"_UserDR_"</UserDR></CardRef>"
	
	q CardInfoXml
}

ClassMethod GetAccInfoXml(CardNo As %String, CredNo As %String) As %String
{
	s AccountType = ""
	;s CardNo = "000000999777"
	;s CredNo = "610324198510080010"
	s CredType = "1"
	s Depprice = "0"
	s OCDate = ""
	s OCTime = ""
	s PAPMINo = ""
	s PAPMIRowID = ""
	s PassWord = ""
	s UserDR = "639"
	s amt = "12"

	s AccInfoXml = "<AccManager><AccountType>"_AccountType_"</AccountType><CardNo>"_CardNo_"</CardNo><CredNo>"_CredNo_"</CredNo><CredType>"_CredType_"</CredType><Depprice>"_Depprice_"</Depprice><OCDate>"_OCDate_"</OCDate><OCTime>"_OCTime_"</OCTime><PAPMINo>"_PAPMINo_"</PAPMINo><PAPMIRowID>"_PAPMIRowID_"</PAPMIRowID><PassWord>"_PassWord_"</PassWord><UserDR>"_UserDR_"</UserDR><amt>"_amt_"</amt></AccManager>"
	
	q AccInfoXml
}

ClassMethod GetDepositInfoXml() As %String
{
	s BackReason = ""
	s Bank = ""
	s BankCardType = ""
	s CardChequeNo = ""
	s ChequeDate = ""
	s PayAccNo = ""
	s PayCompany = ""
	s PayMode = "1"
	s PreDate = ""
	s PreTime = ""
	s ReceiptsNo = ""
	s Remark = ""
	s UserDR = "639"
	s amt = "12"

	s DepositInfoXml = "<AccPreDeposit><BackReason>"_BackReason_"</BackReason><Bank>"_Bank_"</Bank><BankCardType>"_BankCardType_"</BankCardType><CardChequeNo>"_CardChequeNo_"</CardChequeNo><ChequeDate>"_ChequeDate_"</ChequeDate><PayAccNo>"_PayAccNo_"</PayAccNo><PayCompany>"_PayCompany_"</PayCompany><PayMode>"_PayMode_"</PayMode><PreDate>"_PreDate_"</PreDate><PreTime>"_PreTime_"</PreTime><ReceiptsNo>"_ReceiptsNo_"</ReceiptsNo><Remark>"_Remark_"</Remark><UserDR>"_UserDR_"</UserDR><amt>"_amt_"</amt></AccPreDeposit>"
	
	q DepositInfoXml
}

ClassMethod GetCardINVInfoXml(PayMode As %String) As %String
{
	s Bank = ""
	s BankCardType = ""
	s CardChequeNo = ""
	s CardFareCost = "0"
	s ChequeDate = ""
	s Date = ""
	s Flag = ""
	s PAPMIRowID = ""
	s PayAccNo = ""
	s PayCompany = ""
	s PayMode = "1"
	s ReceiptNO = ""
	s Remark = ""
	s Time = ""
	s UserDR = "639"

	s CardINVInfoXml = "<CardINVPRT><Bank>"_Bank_"</Bank><BankCardType>"_BankCardType_"</BankCardType><CardChequeNo>"_CardChequeNo_"</CardChequeNo><CardFareCost>"_CardFareCost_"</CardFareCost><ChequeDate>"_ChequeDate_"</ChequeDate><Date>"_Date_"</Date><Flag>"_Flag_"</Flag><PAPMIRowID>"_PAPMIRowID_"</PAPMIRowID><PayAccNo>"_PayAccNo_"</PayAccNo><PayCompany>"_PayCompany_"</PayCompany><PayMode>"_PayMode_"</PayMode><ReceiptNO>"_ReceiptNO_"</ReceiptNO><Remark>"_Remark_"</Remark><Time>"_Time_"</Time><UserDR>"_UserDR_"</UserDR></CardINVPRT>"
	
	q CardINVInfoXml
}

ClassMethod GetSepcialInfoXml() As %String
{

	s SepcialInfoXml = "^670B14728AD9902AECBA32E22FA4F6BD"
	
	q SepcialInfoXml
}

ClassMethod GetExpStrXml() As %String
{

	s ExpStrXml = ""
	
	q ExpStrXml
}

}
