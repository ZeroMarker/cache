Class DHCMGNUR.MgNurDataImport Extends %Persistent
{

/// 
/// Hospital:北京协和
/// Method Description:将老版护理管理中的学习经历导入新版中的子表中
/// Date:2014-11-13
ClassMethod importLeaExp() As %String
{
	s personid="" f  s personid=$O(^DHCMGNUR.MgPersonsI("SSID",personid)) q:personid=""  d
	.s raw="" f  s raw=$O(^DHCMGNUR.MgPersonsI("SSID",personid,raw)) q:raw=""  d
	..s a=##class(DHCMGNUR.MgPersons).%OpenId(raw)
	..s oldId="" f  s oldId=$O(^User.DHCMGPersonsI("SSID",personid,oldId)) q:oldId=""  d
	...s schId="" f  s schId=$O(^User.DHCMGPersonSchoolI("Person"," "_oldId,schId)) q:schId=""  d
	....s objSch=##class(User.DHCMGPersonSchool).%OpenId(schId)
	....;s id=$O(^DHCMGNUR.MgNurLeaExpI("PerID",personid,raw,""))
	....;i id="" d
	....s objLeaExp=##class(DHCMGNUR.MgNurLeaExp).%New()
	....s objLeaExp.LeaExpParref=##class(DHCMGNUR.MgPersons).%OpenId(raw)
	....i objSch.SchoolGraduateDate'="" s objLeaExp.EndDate=objSch.SchoolGraduateDate
	....;s objLeaExp.EndDate=objSch.SchoolGraduateDate
	....s school=objSch.SchoolGraduateSchool.MgCodeDesc
	....s schoolAge=objSch.SchoolAgeDr.MgCodeDesc
	....s profession=objSch.SchoolProfession.MgCodeDesc
	....s degree=objSch.SchoolDegreeDR.MgCodeDesc
	....s objLeaExp.PerID=a.PersonID
	....s objLeaExp.PerName=a.PersonName
	....s par="" f  s par=$O(^DHCMGNUR.CommDictionarySubI("Code"," "_school,14,par)) q:par=""  d
	.....s objLeaExp.PerGraduateSchool=##class(DHCMGNUR.CommDictionarySub).%OpenId(14_"||"_par)
	....s agepar="" f  s agepar=$O(^DHCMGNUR.CommDictionarySubI("Code"," "_schoolAge,19,agepar)) q:agepar=""  d
	.....s objLeaExp.PerSchoolAgeDr=##class(DHCMGNUR.CommDictionarySub).%OpenId(19_"||"_agepar)
	....s profpar=""  f  s profpar=$O(^DHCMGNUR.CommDictionarySubI("Code"," "_profession,18,profpar)) q:profpar=""  d
	.....s objLeaExp.PerProfession=##class(DHCMGNUR.CommDictionarySub).%OpenId(18_"||"_profpar)
	....s degreepar="" f  s degreepar=$O(^DHCMGNUR.CommDictionarySubI("Code"," "_degree,20,degreepar)) q:degreepar=""  d
	.....s objLeaExp.PerDegreeDR=##class(DHCMGNUR.CommDictionarySub).%OpenId(20_"||"_degreepar)
	....d objLeaExp.%Save()
}

/// Hospital：北京协和医院
/// Method Description:将老版护理管理的院校代码导入新版公共代码-毕业院校
/// Date:2014-11-13
ClassMethod getGraduateCommCode() As %String
{
	s raw="" f  s raw=$O(^User.DHCMGCCodeI("Typ",2,raw)) q:raw=""  d
	.s objOld=##class(User.DHCMGCCode).%OpenId(raw)
	.s schCode=objOld.MgCodeDesc
	.s par=$O(^DHCMGNUR.CommDictionarySubI("Code",schCode,14,""))
	.i par=""  d
	..s a=##class(DHCMGNUR.CommDictionarySub).%New()
	..s a.CommParref=##class(DHCMGNUR.CommDictionary).%OpenId(14)
	.e  d
	..s a=##class(DHCMGNUR.CommDictionarySub).%OpenId(14_"||"_par)
	.;b ;01
	.s a.Code=objOld.MgCodeDesc
	.s a.CodeDesc=objOld.MgCodeDesc
	.s a.txtMem=objOld.MgCodeDesc
	.d a.%Save()
}

/// hospital:北京协和
/// Method Description:将老护理管理中的毕业院校导入新版人员表中
/// Date:2014-11-12
ClassMethod getPersonGraduateData() As %String
{
	s personid="" f  s personid=$O(^DHCMGNUR.MgPersonsI("SSID",personid)) q:personid=""  d
	.s objrw="" f  s objrw=$O(^DHCMGNUR.MgPersonsI("SSID",personid,objrw)) q:objrw=""  d
	..s objPerson=##class(DHCMGNUR.MgPersons).%OpenId(objrw)
	..s oldTabId="" f  s oldTabId=$O(^User.DHCMGPersonsI("SSID",personid,oldTabId)) q:oldTabId=""  d
	...s oldObj=##class(User.DHCMGPersons).%OpenId(oldTabId)
	...s oldPerGraduate=oldObj.PersonGraduateSchool.MgCodeDesc
	...i oldPerGraduate'=""  d
	....s id="" f  s id=$O(^DHCMGNUR.CommDictionarySubI("Code"," "_oldPerGraduate,14,id)) q:id=""  d
	.....s objPerson.PersonGraduateSchool=##class(DHCMGNUR.CommDictionarySub).%OpenId(14_"||"_id)
	.....d objPerson.%Save()
}

/// Hospital:北京协和
/// Method Description:正式库人力资源数据导入
/// date：2014-11-07
/// 
ClassMethod getOldPersonData()
{
	s ssid=" " f  s ssid=$O(^User.DHCMGPersonsI("SSID",ssid)) q:ssid=" "  d
	.s ssidd=$TR(ssid," ","")
	.q:(($ISVALIDNUM(ssidd)=0)!($L(ssidd)>5))
	.s raw="" f  s raw=$O(^User.DHCMGPersonsI("SSID",ssid,raw)) q:raw=""  d
	..s objOld=##class(User.DHCMGPersons).%OpenId(raw)
	..q:objOld.PersonRegNo=""
	..q:objOld.PersonDepDR=""
	..s id=$O(^DHCMGNUR.MgPersonsI("SSID",ssid,""))
	..i id="" s a=##class(DHCMGNUR.MgPersons).%New()
	..e  s a=##class(DHCMGNUR.MgPersons).%OpenId(id)
	..i objOld.PersonRegNo'="" s a.PersonRegNo=objOld.PersonRegNo
	..s a.PersonName=objOld.PersonName
	..i objOld.PersonBirthDay'="" s a.PersonBirthDay=objOld.PersonBirthDay
	..i objOld.PersonSexDR'="" s a.PersonSexDR=objOld.PersonSexDR
	..s a.PersonID=objOld.PersonID
	..i objOld.PersonTelHand'="" s a.PersonTelHand=objOld.PersonTelHand
	..i objOld.PersonHouseholdAdd'="" s a.PersonHouseholdAdd=objOld.PersonHouseholdAdd
	..i objOld.PersonIdentity'="" s a.PersonIdentity=objOld.PersonIdentity
	..i objOld.PersonWorkDateTime'="" s a.PersonWorkDateTime=objOld.PersonWorkDateTime
	..i objOld.PersonPresentZipCode'="" s a.PersonPresentZipCode=objOld.PersonPresentZipCode
	..i objOld.PersonNativePlaceDR'="" s a.PersonNativePlaceDR=objOld.PersonNativePlaceDR
	..i objOld.PersonHeight'="" s a.PersonHeight=objOld.PersonHeight
	..i objOld.PersonHouseZipCode'="" s a.PersonHouseZipCode=objOld.PersonHouseZipCode
	..i objOld.PersonNurHeadDate'="" s a.PersonNurHeadDate=objOld.PersonNurHeadDate
	..s a.PersonDepDR=objOld.PersonDepDR
	..i objOld.PersonEnterDepDate'="" s a.PersonTransDate=objOld.PersonEnterDepDate
	..i objOld.PersonTechPostDate'="" s a.PersonTechPostDate=objOld.PersonTechPostDate
	..i objOld.PersonAdmHosDate'="" s a.PersonAdmHosDate=objOld.PersonAdmHosDate
	..i objOld.PersonHosEngageDate'="" s a.PersonHosEngageDate=objOld.PersonHosEngageDate
	..i objOld.PersonNurseQualDate'="" s a.PersonNurseQualDate=objOld.PersonNurseQualDate
	..i objOld.PersonPrefQualDate'="" s a.PersonPrefQualDate=objOld.PersonPrefQualDate 
	..i ((objOld.PersonheadshipDR'="")&(objOld.PersonheadshipDR.PostCode="护士长")) s a.PersonheadshipDR=##class(DHCMGNUR.CommDictionarySub).%OpenId("22||2")
	..i ((objOld.PersonheadshipDR'="")&(objOld.PersonheadshipDR.PostCode="总护士长")) s a.PersonheadshipDR=##class(DHCMGNUR.CommDictionarySub).%OpenId("22||3")
	..i ((objOld.PersonAppDutyDR'="")&(objOld.PersonAppDutyDR.PostCode="护士")) s a.PersonAppDutyDR=##class(DHCMGNUR.CommDictionarySub).%OpenId("28||1")
	..i ((objOld.PersonAppDutyDR'="")&(objOld.PersonAppDutyDR.PostCode="护师")) s a.PersonAppDutyDR=##class(DHCMGNUR.CommDictionarySub).%OpenId("28||2")
	..i ((objOld.PersonAppDutyDR'="")&(objOld.PersonAppDutyDR.PostCode="主管护师")) s a.PersonAppDutyDR=##class(DHCMGNUR.CommDictionarySub).%OpenId("28||3")
	..i ((objOld.PersonAppDutyDR'="")&(objOld.PersonAppDutyDR.PostCode="主任护师")) s a.PersonAppDutyDR=##class(DHCMGNUR.CommDictionarySub).%OpenId("28||15")
	..i ((objOld.PersonAppDutyDR'="")&(objOld.PersonAppDutyDR.PostCode="副主任护师")) s a.PersonAppDutyDR=##class(DHCMGNUR.CommDictionarySub).%OpenId("28||4")
	..i ((objOld.Personpeopledr'="")&(objOld.Personpeopledr.MgCodeCode="汉族")) s a.Personpeopledr=##class(DHCMGNUR.CommDictionarySub).%OpenId("5||1")
	..i ((objOld.Personpeopledr'="")&(objOld.Personpeopledr.MgCodeCode="满族")) s a.Personpeopledr=##class(DHCMGNUR.CommDictionarySub).%OpenId("5||6")
	..i ((objOld.Personpeopledr'="")&(objOld.Personpeopledr.MgCodeCode="蒙古族")) s a.Personpeopledr=##class(DHCMGNUR.CommDictionarySub).%OpenId("5||4")
	..i ((objOld.Personpeopledr'="")&(objOld.Personpeopledr.MgCodeCode="回族")) s a.Personpeopledr=##class(DHCMGNUR.CommDictionarySub).%OpenId("5||3")
	..i ((objOld.Personpeopledr'="")&(objOld.Personpeopledr.MgCodeCode="白族")) s a.Personpeopledr=##class(DHCMGNUR.CommDictionarySub).%OpenId("5||7")
	..i ((objOld.Personpeopledr'="")&(objOld.Personpeopledr.MgCodeCode="土家族")) s a.Personpeopledr=##class(DHCMGNUR.CommDictionarySub).%OpenId("5||8")
	..i ((objOld.Personpeopledr'="")&(objOld.Personpeopledr.MgCodeCode="朝鲜族")) s a.Personpeopledr=##class(DHCMGNUR.CommDictionarySub).%OpenId("5||9")
	..i ((objOld.Personpeopledr'="")&(objOld.Personpeopledr.MgCodeCode="壮族")) s a.Personpeopledr=##class(DHCMGNUR.CommDictionarySub).%OpenId("5||10")
	..i ((objOld.PersonPolitydr'="")&(objOld.PersonPolitydr.MgCodeCode="团员")) s a.PersonPolitydr=##class(DHCMGNUR.CommDictionarySub).%OpenId("6||4")
	..i ((objOld.PersonPolitydr'="")&(objOld.PersonPolitydr.MgCodeCode="共产党员"))	s a.PersonPolitydr=##class(DHCMGNUR.CommDictionarySub).%OpenId("6||1")
	..i ((objOld.PersonPolitydr'="")&(objOld.PersonPolitydr.MgCodeCode="群众"))	s a.PersonPolitydr=##class(DHCMGNUR.CommDictionarySub).%OpenId("6||3")
	..i ((objOld.PersonPolitydr'="")&(objOld.PersonPolitydr.MgCodeCode="其他"))	s a.PersonPolitydr=##class(DHCMGNUR.CommDictionarySub).%OpenId("6||6")
	..i ((objOld.PersonSchoolAgeDr'="")&(objOld.PersonSchoolAgeDr.MgCodeCode="本科")) s a.PersonSchoolAgeDr=##class(DHCMGNUR.CommDictionarySub).%OpenId("19||3")
	..i ((objOld.PersonSchoolAgeDr'="")&(objOld.PersonSchoolAgeDr.MgCodeCode="大专")) s a.PersonSchoolAgeDr=##class(DHCMGNUR.CommDictionarySub).%OpenId("19||1")
	..i ((objOld.PersonSchoolAgeDr'="")&(objOld.PersonSchoolAgeDr.MgCodeCode="中专")) s a.PersonSchoolAgeDr=##class(DHCMGNUR.CommDictionarySub).%OpenId("19||5")
	..i ((objOld.PersonSchoolAgeDr'="")&(objOld.PersonSchoolAgeDr.MgCodeCode="研究生")) s a.PersonSchoolAgeDr=##class(DHCMGNUR.CommDictionarySub).%OpenId("19||4")
	..i ((objOld.PersonSchoolAgeDr'="")&(objOld.PersonSchoolAgeDr.MgCodeCode="博士后")) s a.PersonSchoolAgeDr=##class(DHCMGNUR.CommDictionarySub).%OpenId("19||8")
	..i ((objOld.PersonDegreeDR'="")&(objOld.PersonDegreeDR.MgCodeCode="学士")) s a.PersonDegreeDR=##class(DHCMGNUR.CommDictionarySub).%OpenId("20||1")
	..i ((objOld.PersonDegreeDR'="")&(objOld.PersonDegreeDR.MgCodeCode="硕士")) s a.PersonDegreeDR=##class(DHCMGNUR.CommDictionarySub).%OpenId("20||2")
	..i ((objOld.PersonPrefQual'="")&(objOld.PersonPrefQual.MgCodeCode="老年专科护士")) s a.PersonPrefQual=##class(DHCMGNUR.CommDictionarySub).%OpenId("23||1")
	..i ((objOld.PersonPrefQual'="")&(objOld.PersonPrefQual.MgCodeCode="ICU专科护士")) s a.PersonPrefQual=##class(DHCMGNUR.CommDictionarySub).%OpenId("23||2")
	..i ((objOld.PersonPrefQual'="")&(objOld.PersonPrefQual.MgCodeCode="糖尿病健康教育护理师")) s a.PersonPrefQual=##class(DHCMGNUR.CommDictionarySub).%OpenId("23||3")
	..i ((objOld.PersonPrefQual'="")&(objOld.PersonPrefQual.MgCodeCode="艾滋病专科护士")) s a.PersonPrefQual=##class(DHCMGNUR.CommDictionarySub).%OpenId("23||4")
	..i ((objOld.PersonPrefQual'="")&(objOld.PersonPrefQual.MgCodeCode="血友病专科护士")) s a.PersonPrefQual=##class(DHCMGNUR.CommDictionarySub).%OpenId("23||5")
	..i ((objOld.PersonPrefQual'="")&(objOld.PersonPrefQual.MgCodeCode="康复专科护士")) s a.PersonPrefQual=##class(DHCMGNUR.CommDictionarySub).%OpenId("23||6")
	..i ((objOld.PersonPrefQual'="")&(objOld.PersonPrefQual.MgCodeCode="肿瘤专业护士")) s a.PersonPrefQual=##class(DHCMGNUR.CommDictionarySub).%OpenId("23||7")
	..i ((objOld.PersonPrefQual'="")&(objOld.PersonPrefQual.MgCodeCode="造口专科护士")) s a.PersonPrefQual=##class(DHCMGNUR.CommDictionarySub).%OpenId("23||8")
	..i ((objOld.PersonPrefQual'="")&(objOld.PersonPrefQual.MgCodeCode="PICC专科护士")) s a.PersonPrefQual=##class(DHCMGNUR.CommDictionarySub).%OpenId("23||9")
	..i ((objOld.PersonPrefQual'="")&(objOld.PersonPrefQual.MgCodeCode="手术室专业护士")) s a.PersonPrefQual=##class(DHCMGNUR.CommDictionarySub).%OpenId("23||10")
	..i ((objOld.PersonPrefQual'="")&(objOld.PersonPrefQual.MgCodeCode="疼痛护士")) s a.PersonPrefQual=##class(DHCMGNUR.CommDictionarySub).%OpenId("23||11")
	..i ((objOld.PersonPrefQual'="")&(objOld.PersonPrefQual.MgCodeCode="护士长管理")) s a.PersonPrefQual=##class(DHCMGNUR.CommDictionarySub).%OpenId("23||12")
	..i ((objOld.PersonPrefQual'="")&(objOld.PersonPrefQual.MgCodeCode="急诊专科护士")) s a.PersonPrefQual=##class(DHCMGNUR.CommDictionarySub).%OpenId("23||13")
	..i ((objOld.PersonPrefQual'="")&(objOld.PersonPrefQual.MgCodeCode="血液净化专科护士")) s a.PersonPrefQual=##class(DHCMGNUR.CommDictionarySub).%OpenId("23||14")
	..i ((objOld.PersonPostTyp'="")&(objOld.PersonPostTyp.MgCodeCode="病房")) s a.PersonPostTyp=##class(DHCMGNUR.CommDictionarySub).%OpenId("17||1")
	..i ((objOld.PersonPostTyp'="")&(objOld.PersonPostTyp.MgCodeCode="门诊")) s a.PersonPostTyp=##class(DHCMGNUR.CommDictionarySub).%OpenId("17||2")
	..i ((objOld.PersonPostTyp'="")&(objOld.PersonPostTyp.MgCodeCode="手术室")) s a.PersonPostTyp=##class(DHCMGNUR.CommDictionarySub).%OpenId("17||5")
	..i ((objOld.PersonPostTyp'="")&(objOld.PersonPostTyp.MgCodeCode="急诊")) s a.PersonPostTyp=##class(DHCMGNUR.CommDictionarySub).%OpenId("17||5")
	..i ((objOld.PersonProfession'="")&(objOld.PersonProfession.MgCodeCode="护理学")) s a.PersonProfession=##class(DHCMGNUR.CommDictionarySub).%OpenId("18||1")
	..i ((objOld.PersonShoeNO'="")&(objOld.PersonShoeNO.MgCodeCode="38")) s a.PersonShoeNO=##class(DHCMGNUR.CommDictionarySub).%OpenId("8||5")
	..i ((objOld.PersonShoeNO'="")&(objOld.PersonShoeNO.MgCodeCode="35")) s a.PersonShoeNO=##class(DHCMGNUR.CommDictionarySub).%OpenId("8||2")
	..i ((objOld.PersonShoeNO'="")&(objOld.PersonShoeNO.MgCodeCode="36")) s a.PersonShoeNO=##class(DHCMGNUR.CommDictionarySub).%OpenId("8||3")
	..i ((objOld.PersonShoeNO'="")&(objOld.PersonShoeNO.MgCodeCode="39")) s a.PersonShoeNO=##class(DHCMGNUR.CommDictionarySub).%OpenId("8||6")
	..i ((objOld.PersonShoeNO'="")&(objOld.PersonShoeNO.MgCodeCode="37")) s a.PersonShoeNO=##class(DHCMGNUR.CommDictionarySub).%OpenId("8||4")
	..i ((objOld.PersonShoeNO'="")&(objOld.PersonShoeNO.MgCodeCode="40")) s a.PersonShoeNO=##class(DHCMGNUR.CommDictionarySub).%OpenId("8||7")
	..i ((objOld.PersonShoeNO'="")&(objOld.PersonShoeNO.MgCodeCode="41")) s a.PersonShoeNO=##class(DHCMGNUR.CommDictionarySub).%OpenId("8||8")
	..i ((objOld.PersonShoeNO'="")&(objOld.PersonShoeNO.MgCodeCode="34")) s a.PersonShoeNO=##class(DHCMGNUR.CommDictionarySub).%OpenId("8||1")
	..i ((objOld.PersonShoeNO'="")&(objOld.PersonShoeNO.MgCodeCode="42")) s a.PersonShoeNO=##class(DHCMGNUR.CommDictionarySub).%OpenId("8||9")
	..i ((objOld.PersonShoeNO'="")&(objOld.PersonShoeNO.MgCodeCode="43")) s a.PersonShoeNO=##class(DHCMGNUR.CommDictionarySub).%OpenId("8||10")
	..i ((objOld.PersonShoeNO'="")&(objOld.PersonShoeNO.MgCodeCode="45")) s a.PersonShoeNO=##class(DHCMGNUR.CommDictionarySub).%OpenId("8||12")
	..i ((objOld.PersonShoeNO'="")&(objOld.PersonShoeNO.MgCodeCode="44")) s a.PersonShoeNO=##class(DHCMGNUR.CommDictionarySub).%OpenId("8||11")
	..i ((objOld.PersonClothesNO'="")&(objOld.PersonClothesNO.MgCodeCode="L")) s a.PersonClothesNO=##class(DHCMGNUR.CommDictionarySub).%OpenId("11||1")
	..i ((objOld.PersonClothesNO'="")&(objOld.PersonClothesNO.MgCodeCode="S")) s a.PersonClothesNO=##class(DHCMGNUR.CommDictionarySub).%OpenId("11||3")
	..i ((objOld.PersonClothesNO'="")&(objOld.PersonClothesNO.MgCodeCode="M")) s a.PersonClothesNO=##class(DHCMGNUR.CommDictionarySub).%OpenId("11||2")
	..i ((objOld.PersonClothesNO'="")&(objOld.PersonClothesNO.MgCodeCode="XXL")) s a.PersonClothesNO=##class(DHCMGNUR.CommDictionarySub).%OpenId("11||5")
	..i ((objOld.PersonClothesNO'="")&(objOld.PersonClothesNO.MgCodeCode="XL")) s a.PersonClothesNO=##class(DHCMGNUR.CommDictionarySub).%OpenId("11||4")
	..i ((objOld.PersonClothesNO'="")&(objOld.PersonClothesNO.MgCodeCode="XXXL")) s a.PersonClothesNO=##class(DHCMGNUR.CommDictionarySub).%OpenId("11||6")
	..i ((objOld.PersonClothesNO'="")&(objOld.PersonClothesNO.MgCodeCode="XXXXL")) s a.PersonClothesNO=##class(DHCMGNUR.CommDictionarySub).%OpenId("11||7")
	..i ((objOld.PersonClothesNO'="")&(objOld.PersonClothesNO.MgCodeCode="XS")) s a.PersonClothesNO=##class(DHCMGNUR.CommDictionarySub).%OpenId("11||8")
	..i ((objOld.PersonClothesNO'="")&(objOld.PersonClothesNO.MgCodeCode="BS")) s a.PersonClothesNO=##class(DHCMGNUR.CommDictionarySub).%OpenId("11||9")
	..i ((objOld.PersonSchoolType'="")&(objOld.PersonSchoolType.MgCodeCode="全日制")) s a.PersonSchoolType=##class(DHCMGNUR.CommDictionarySub).%OpenId("15||1")
	..i ((objOld.PersonSchoolType'="")&(objOld.PersonSchoolType.MgCodeCode="非全日制")) s a.PersonSchoolType=##class(DHCMGNUR.CommDictionarySub).%OpenId("15||2")
	..i ((objOld.PersonBattery'="")&(objOld.PersonBattery.MgCodeCode="N1")) s a.PersonBattery=##class(DHCMGNUR.CommDictionarySub).%OpenId("12||1")
	..i ((objOld.PersonBattery'="")&(objOld.PersonBattery.MgCodeCode="N2")) s a.PersonBattery=##class(DHCMGNUR.CommDictionarySub).%OpenId("12||2")
	..i ((objOld.PersonBattery'="")&(objOld.PersonBattery.MgCodeCode="N3")) s a.PersonBattery=##class(DHCMGNUR.CommDictionarySub).%OpenId("12||3")
	..i ((objOld.PersonBattery'="")&(objOld.PersonBattery.MgCodeCode="N4")) s a.PersonBattery=##class(DHCMGNUR.CommDictionarySub).%OpenId("12||4")
	..i ((objOld.PersonBattery'="")&(objOld.PersonBattery.MgCodeCode="空分层")) s a.PersonBattery=##class(DHCMGNUR.CommDictionarySub).%OpenId("12||6")
	..i ((objOld.PersonProfPostDR'="")&(objOld.PersonProfPostDR.PostCode="护士")) s a.PersonProfPostDR=##class(DHCMGNUR.CommDictionarySub).%OpenId("28||1")
	..i ((objOld.PersonProfPostDR'="")&(objOld.PersonProfPostDR.PostCode="护师")) s a.PersonProfPostDR=##class(DHCMGNUR.CommDictionarySub).%OpenId("28||2")
	..i ((objOld.PersonProfPostDR'="")&(objOld.PersonProfPostDR.PostCode="主管护师")) s a.PersonProfPostDR=##class(DHCMGNUR.CommDictionarySub).%OpenId("28||3")
	..s a.PersonTransDate=objOld.PersonEnterDepDate
	..i objOld.PersonAddress'="" s a.PersonAddress=objOld.PersonAddress
	..s a.PersonFlag="0"
	..d a.%Save()
}

/// 人员信息导入之后操作此方法
/// Hospital：北京协和医院
/// Method Description：北京协和调科记录信息导入
/// Date:2014-11-10
/// 
ClassMethod getOldTranDepRecords()
{
	s personid="" f  s personid=$O(^DHCMGNUR.MgPersonsI("SSID",personid)) q:personid=""  d
	.s raw="" f  s raw=$O(^DHCMGNUR.MgPersonsI("SSID",personid,raw)) q:raw=""  d
	..s objPerosn=##class(DHCMGNUR.MgPersons).%OpenId(raw)
	..s oldTableId="" f  s oldTableId=$O(^User.DHCMGPersonsI("SSID",personid,oldTableId)) q:oldTableId=""  d
	...s oldTransId="" f  s oldTransId=$O(^User.DHCMGTransI("Person",oldTableId,oldTransId)) q:oldTransId=""  d
	....s objOldTrans=##class(User.DHCMGTrans).%OpenId(oldTransId)
	....;s id=$O(^DHCMGNUR.MgNurTransDepI("PerID",
	....s aa=##class(DHCMGNUR.MgNurTransDep).%New()
	....s aa.PerName=objPerosn.PersonName
	....s aa.PerID=objPerosn.PersonID
	....s aa.PerDr=raw
	....s aa.PerDepart=objOldTrans.DepDr
	....s aa.PerTranStDate=objOldTrans.NurTranStDate
	....s aa.PerTranStTime=objOldTrans.NurTranStTime
	....s aa.PerTranEndDate=objOldTrans.NurTranEndDate
	....s aa.PerTranEndTime=objOldTrans.NurTranEndTime
	....s aa.PerTranCurrent=objOldTrans.NurTranCurrent
	....d aa.%Save()
}

Storage Default
{
<Data name="MgNurDataImportDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCMGNUR.MgNurDataImportD</DataLocation>
<DefaultData>MgNurDataImportDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMGNUR.MgNurDataImportD</IdLocation>
<IndexLocation>^DHCMGNUR.MgNurDataImportI</IndexLocation>
<StreamLocation>^DHCMGNUR.MgNurDataImportS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
