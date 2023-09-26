Class web.DHCMgNurPerHRComm Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 人力资源子集
ClassMethod GetPerLearningExperiences(checkid, pername, perid, w, h) As %String
{
 s ret="["
 s Exchange="调科记录"
 s sumecode="DHCNURPerExchange"
 s url="dhcmgnurcomm.csp?EmrCode="_sumecode_"&RowId="_checkid_"&PerID="_perid
 s ret=ret_"{border: false,region: 'center', layout: 'fit', title: '"_Exchange_"',height:"_h_",width:"_w_",html:'<iframe id =""southTab1"" name=""ddd1"" style=""width:100%;height:100%""  src="""_url_""" ></iframe>'}"
 s order="" f  s order=$O(^DHCMGNUR.MgChildPagEleD(order)) q:order=""  d
 .i ret'="[" s ret=ret_","
 .s Examine=$list(^DHCMGNUR.MgChildPagEleD(order),2)
 .s sumecode=$list(^DHCMGNUR.MgChildPagEleD(order),3)
 .s url="dhcmgnurcomm.csp?EmrCode="_sumecode_"&RowId="_checkid_"&PerID="_perid
 .s ret=ret_"{border: false,region: 'center', layout: 'fit', title: '"_Examine_"',height:"_h_",width:"_w_",html:'<iframe id =""southTab1"" name=""ddd1"" style=""width:100%;height:100%""  src="""_url_""" ></iframe>'}"
 s ret=ret_"]"
 q ret
}

ClassMethod getDateFormat(datestr As %String) As %String
{
	q ##class(websys.Conversions).DateLogicalToHtml(datestr)
}

ClassMethod getPersonInfo(perObj, id, tmp)
{
	s dateFlag=##class(websys.Conversions).DateFormat()
 	s PersonName=perObj.PersonName
 	i perObj.PersonBirthDay'="" d
 	.i ((dateFlag=3)!(dateFlag=4)) s Age=..getDateFormat(perObj.PersonBirthDay) //$ZD(perObj.PersonBirthDay,3)
 	.e  s Age=""
 	e  s Age=""
 	s Mariage=perObj.Personmarriage
	i Mariage="1" s Mariage="已婚"
	e  i Mariage="2" s Mariage="未婚"
	e  i Mariage="3" s Mariage="丧偶"
	e  i Mariage="4" s Mariage="离婚"
	e  i Mariage="5" s Mariage="其他"
	e  s Mariage=""
	s PersonSexDR=perObj.PersonSexDR
	i PersonSexDR="1"  s PersonSexDR="女"
	e  i PersonSexDR="2"  s PersonSexDR="男"
	e  s PersonSexDR=""
	s PersonID=$ZConvert(perObj.PersonID,"U")
	s PersonRegNo=perObj.PersonRegNo
	s PersonIdentity=perObj.PersonIdentity
	i perObj.PersonTeachPostDR'="" s PersonTeachPostDR=perObj.PersonTeachPostDR.Code
	e  s PersonTeachPostDR="" 
	i perObj.PersonWorkDateTime'="" d
	.i ((dateFlag=3)!(dateFlag=4)) s PersonWorkDateTime=..getDateFormat(perObj.PersonWorkDateTime)
	.e  s PersonWorkDateTime=""
	e  s PersonWorkDateTime=""
	s PersonTyp=perObj.PersonTyp
	i PersonTyp="D" s PersonTyp="Doctor"
	e  i PersonTyp="N" s PersonTyp="Nurse"
	e  i PersonTyp="W" s PersonTyp="Worker"
	e  s PersonTyp=""
	s PersonTelHome=perObj.PersonTelHome
	s PersonTelHand=perObj.PersonTelHand
	s PersonAddress=perObj.PersonAddress
	s PersonNativePlaceDR=perObj.PersonNativePlaceDR
	i perObj.PersonNurseQualDate'="" d
	.i ((dateFlag=3)!(dateFlag=4)) s PersonNurseQualDate=..getDateFormat(perObj.PersonNurseQualDate)
	.e  s PersonNurseQualDate=""
	e  s PersonNurseQualDate=""
	i perObj.PersonPrefQual'="" s PersonPrefQual=perObj.PersonPrefQual.Code
	e  s PersonPrefQual=""
	i perObj.PersonPrefQualDate'="" d
	.i ((dateFlag=3)!(dateFlag=4)) s PersonPrefQualDate=..getDateFormat(perObj.PersonPrefQualDate)
	.e  s PersonPrefQualDate=""
	e  s PersonPrefQualDate=""
	i $G(^CTLOC(perObj.PersonDepDR))'="" s PersonDepDR=$p(^CTLOC(perObj.PersonDepDR),"^",2)
	e  d
	.s perWardRw=$O(^DHCMGNUR.MgNurPerWardI("WardLoc",perObj.PersonDepDR,""))
	.i perWardRw'="" d
	..s perWardObj=##class(DHCMGNUR.MgNurPerWard).%OpenId(perWardRw)
	..s PersonDepDR=perWardObj.WardDesc
	.e  s PersonDepDR=""
	i perObj.PersonFromDate'="" d
	.i ((dateFlag=3)!(dateFlag=4)) s PersonFromDate=..getDateFormat(perObj.PersonFromDate)
	.e  s PersonFromDate=""
	e  s PersonFromDate=""
	i perObj.PersonProfPostDR'="" s PersonProfPostDR=perObj.PersonProfPostDR.Code
	e  s PersonProfPostDR=""
	i perObj.PersonTechPostDate'="" d
	.i ((dateFlag=3)!(dateFlag=4)) s PersonTechPostDate=..getDateFormat(perObj.PersonTechPostDate)
	.e  s PersonTechPostDate=""
	e  s PersonTechPostDate=""
	i perObj.PersonAppDutyDR'="" s PersonAppDutyDR=perObj.PersonAppDutyDR.Code
	e  s PersonAppDutyDR=""
	i perObj.PersonheadshipDR'="" s PersonheadshipDR=perObj.PersonheadshipDR.Code
	e  s PersonheadshipDR=""
	i perObj.PersonMentorDR'="" s PersonMentorDR=perObj.PersonMentorDR.Code
	e  s PersonMentorDR=""
	i perObj.PersonGraduateDate'="" d
	.i ((dateFlag=3)!(dateFlag=4)) s PersonGraduateDate=..getDateFormat(perObj.PersonGraduateDate)
	.e  s PersonGraduateDate=""
	e  s PersonGraduateDate=""
	i perObj.PersonGraduateSchool'="" s PersonGraduateSchool=perObj.PersonGraduateSchool.Code
	e  s PersonGraduateSchool=""
	i perObj.PersonSchoolAgeDr'="" s PersonSchoolAgeDr=perObj.PersonSchoolAgeDr.Code
	e  s PersonSchoolAgeDr=""
	i perObj.PersonDegreeDR'="" s PersonDegreeDR=perObj.PersonDegreeDR.Code
	e  s PersonDegreeDR=""
	i perObj.PersonLanguage'="" s PersonLanguage=perObj.PersonLanguage.Code
	e  s PersonLanguage=""
	i perObj.PersonProfession'="" s PersonProfession=perObj.PersonProfession.Code
	e  s PersonProfession=""
	s PersonPresentZipCode=perObj.PersonPresentZipCode
	s PersonHouseholdAdd=perObj.PersonHouseholdAdd
	i perObj.PersonCareDate'="" d
	.i ((dateFlag=3)!(dateFlag=4)) s PersonCareDate=..getDateFormat(perObj.PersonCareDate)
	.e  s PersonCareDate=""
	e  s PersonCareDate=""
	i perObj.PersonTransDate'="" d
	.i ((dateFlag=3)!(dateFlag=4)) s PersonTransDate=..getDateFormat(perObj.PersonTransDate)
	.e  s PersonTransDate=""
	e  s PersonTransDate=""
	s PersonHeight=perObj.PersonHeight
	i perObj.PersonShoeNO'="" s PersonShoeNO=perObj.PersonShoeNO.Code
	e  s PersonShoeNO=""
	i perObj.PersonClothesNO'="" s PersonClothesNO=perObj.PersonClothesNO.Code
	e  s PersonClothesNO=""
	i perObj.PersonNurHeadDate'="" d
	.i ((dateFlag=3)!(dateFlag=4)) s PersonNurHeadDate=..getDateFormat(perObj.PersonNurHeadDate)
	.e  s PersonNurHeadDate=""
	e  s PersonNurHeadDate=""
	i perObj.PersonBattery'="" s PersonBattery=perObj.PersonBattery.Code
	e  s PersonBattery=""
	i perObj.PersonNurTyp'=""  s PersonNurTyp=perObj.PersonNurTyp.Code
	e  s PersonNurTyp=""
	i perObj.PersonEngageMth'="" s PersonEngageMth=perObj.PersonEngageMth.Code
	e  s PersonEngageMth=""
	i perObj.PersonEngageDate'="" d
	.i ((dateFlag=3)!(dateFlag=4)) s PersonEngageDate=..getDateFormat(perObj.PersonEngageDate)
	.e  s PersonEngageDate=""
	e  s PersonEngageDate=""
	i perObj.PersonHosEngageDate'="" d
	.i ((dateFlag=3)!(dateFlag=4)) s PersonHosEngageDate=..getDateFormat(perObj.PersonHosEngageDate)
	.e  s PersonHosEngageDate=""
	e  s PersonHosEngageDate=""
	i perObj.PersonAdmHosDate'="" d
	.i ((dateFlag=3)!(dateFlag=4)) s PersonAdmHosDate=..getDateFormat(perObj.PersonAdmHosDate)
	.e  s PersonAdmHosDate=""
	e  s PersonAdmHosDate=""
	i perObj.PersonPolitydr'="" s PersonPolitydr=perObj.PersonPolitydr.Code
	e  s PersonPolitydr=""
	i perObj.Personpeopledr'="" s Personpeopledr=perObj.Personpeopledr.Code
	e  s Personpeopledr=""
	s PersonIFFullTime=perObj.PersonIFFullTime
	i perObj.PersonSchoolMedWest'="" s PersonSchoolMedWest=perObj.PersonSchoolMedWest.Code
	e  s PersonSchoolMedWest=""
	i perObj.PersonSchoolType'="" s PersonSchoolType=perObj.PersonSchoolType.Code
	e  s PersonSchoolType=""
	i perObj.PersonEndDate'="" d
	.i ((dateFlag=3)!(dateFlag=4)) s PersonEndDate=..getDateFormat(perObj.PersonEndDate)
	.e  s PersonEndDate=""
	e  s PersonEndDate=""
	i perObj.PersonRetireDate'="" d
	.i ((dateFlag=3)!(dateFlag=4)) s PersonRetireDate=..getDateFormat(perObj.PersonRetireDate)
	.e  s PersonRetireDate=""
	e  s PersonRetireDate=""
	s PersonHouseZipCode=perObj.PersonHouseZipCode
	i perObj.PersonPostTyp'="" s PersonPostTyp=perObj.PersonPostTyp.Code
	e  s PersonPostTyp=""
	s PersonFlag=perObj.PersonFlag
	i perObj.PersonWorkType="1" s PersonWorkType="临床"
	e  i perObj.PersonWorkType="2" s PersonWorkType="非临床"
	e  s PersonWorkType=""
	s PersonSchoolHighAge=""
	s PersonHighDegree=""
	s leaExpStDate=$O(^DHCMGNUR.MgNurLeaExpI("DataSort"," "_PersonID,""),-1)
	i leaExpStDate'=""  d
	.s leaExpPar="" f  s leaExpPar=$O(^DHCMGNUR.MgNurLeaExpI("DataSort"," "_PersonID,leaExpStDate,leaExpPar)) q:leaExpPar=""  d
	..s leaExpRw="" f  s leaExpRw=$O(^DHCMGNUR.MgNurLeaExpI("DataSort"," "_PersonID,leaExpStDate,leaExpPar,leaExpRw)) q:leaExpRw=""  d
	...s leaExp=##class(DHCMGNUR.MgNurLeaExp).%OpenId(leaExpPar_"||"_leaExpRw)
	...s PersonSchoolHighAge=leaExp.PerSchoolAgeDr.Code
	...s PersonHighDegree=leaExp.PerDegreeDR.Code
	s tmp="PersonDegreeDR"_"|"_PersonDegreeDR_"^"_"PersonPostTyp"_"|"_PersonPostTyp_"^"_"PersonHouseZipCode"_"|"_PersonHouseZipCode_"^"_"PersonRetireDate"_"|"_PersonRetireDate_"^"_"PersonEndDate"_"|"_PersonEndDate_"^"_"PersonSchoolType"_"|"_PersonSchoolType_"^"_"PersonSchoolMedWest"_"|"_PersonSchoolMedWest_"^"_"PersonIFFullTime"_"|"_PersonIFFullTime_"^"_"Personpeopledr"_"|"_Personpeopledr_"^"_"PersonPolitydr"_"|"_PersonPolitydr_"^"_"PersonAdmHosDate"_"|"_PersonAdmHosDate_"^"_"PersonHosEngageDate"_"|"_PersonHosEngageDate_"^"_"PersonEngageDate"_"|"_PersonEngageDate_"^"_"PersonEngageMth"_"|"_PersonEngageMth_"^"_"PersonNurTyp"_"|"_PersonNurTyp_"^"_"PersonBattery"_"|"_PersonBattery_"^"_"PersonNurHeadDate"_"|"_PersonNurHeadDate_"^"_"PersonClothesNO"_"|"_PersonClothesNO_"^"_"PersonShoeNO"_"|"_PersonShoeNO_"^"_"PersonHeight"_"|"_PersonHeight_"^"_"PersonCareDate"_"|"_PersonCareDate_"^"_"PersonTransDate"_"|"_PersonTransDate_"^"_"PersonHouseholdAdd"_"|"_PersonHouseholdAdd_"^"_"PersonPresentZipCode"_"|"_PersonPresentZipCode_"^"_"PersonProfession"_"|"_PersonProfession_"^"_"PersonLanguage"_"|"_PersonLanguage_"^"_"PersonSchoolAgeDr"_"|"_PersonSchoolAgeDr_"^"_"PersonGraduateSchool"_"|"_PersonGraduateSchool_"^"_"PersonGraduateDate"_"|"_PersonGraduateDate_"^"_"PersonMentorDR"_"|"_PersonMentorDR_"^"_"PersonheadshipDR"_"|"_PersonheadshipDR_"^"_"PersonAppDutyDR"_"|"_PersonAppDutyDR_"^"_"PersonTechPostDate"_"|"_PersonTechPostDate_"^"_"PersonProfPostDR"_"|"_PersonProfPostDR_"^"_"PersonFromDate"_"|"_PersonFromDate_"^"_"PersonDepDR"_"|"_PersonDepDR_"^"_"PersonPrefQualDate"_"|"_PersonPrefQualDate_"^"_"PersonPrefQual"_"|"_PersonPrefQual_"^"_"PersonNurseQualDate"_"|"_PersonNurseQualDate_"^"_"PersonNativePlaceDR"_"|"_PersonNativePlaceDR_"^"_"PersonAddress"_"|"_PersonAddress_"^"_"PersonTelHand"_"|"_PersonTelHand_"^"_"PersonTelHome"_"|"_PersonTelHome_"^"_"PersonTyp"_"|"_PersonTyp_"^"_"PersonWorkDateTime"_"|"_PersonWorkDateTime_"^"_"PersonTeachPostDR"_"|"_PersonTeachPostDR_"^"_"PersonIdentity"_"|"_PersonIdentity_"^"_"PersonName"_"|"_PersonName_"^"_"PersonBirthDay"_"|"_Age_"^"_"Personmarriage"_"|"_Mariage_"^"_"PersonSexDR"_"|"_PersonSexDR_"^"_"PersonID"_"|"_PersonID_"^"_"PersonRegNo"_"|"_PersonRegNo_"^"_"PersonFlag|"_PersonFlag_"^"_"rw|"_id_"^PersonWorkType|"_PersonWorkType_"^PersonSchoolHighAge|"_PersonSchoolHighAge_"^PersonHighDegree|"_PersonHighDegree
	q tmp
}

/// Hospital:北京协和医院
/// Method Decription:按照登录安全组查询护理人员信息
/// Date:2015-01-24
Query SelectPerson(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod SelectPersonExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s ^tempparr1=parr
 	s perdep=$P(parr,"^",1)
 	s personBattery=$P(parr,"^",3)
 	s personBatteryid=$P(personBattery,"||",1)
 	s personBatteryrw=$P(personBattery,"||",2)
 	s personShoeNo=$P(parr,"^",4)
 	s personShoeNoid=$P(personShoeNo,"||",1)
 	s personShoeNorw=$P(personShoeNo,"||",2)
 	s personNurTyp=$P(parr,"^",5)
 	s personNurTypid=$P(personNurTyp,"||",1)
 	s personNurTyprw=$P(personNurTyp,"||",2)
 	s personAppDuty=$P(parr,"^",6)
 	s personAppDutyid=$P(personAppDuty,"||",1)
 	s personAppDutyrw=$P(personAppDuty,"||",2)
 	s personSchAge=$P(parr,"^",7)
 	s personSchAgeid=$P(personSchAge,"||",1)
 	s personSchAgerw=$P(personSchAge,"||",2)
 	s stDate=$P(parr,"^",8)
 	i stDate="" s ageStDate="" ; s stDate=$ZD(+$H,3)
 	e  s ageStDate=$ZDH(stDate,3)
 	s endDate=$P(parr,"^",9)
 	i endDate=""  s ageEndDate=$ZDH($ZD(+$H,3),3)
 	e  s ageEndDate=$ZDH(endDate,3)
 	s nurseName=$ZConvert($P(parr,"^",10),"U")
 	s larLoc=$ZConvert($P(parr,"^",11),"U")
 	s pname=$ZConvert($p(parr,"^",2),"U")
 	s secGrp=$P(parr,"^",12)
 	s logonUser=$P(parr,"^",13)
 	s ret=""
 	s tmp=""
 	s pno=pname
 	i ((secGrp="hlb")!(secGrp="demo")!(secGrp="hlbzr")) d
 	.i larLoc'="" d
 	..s loc="" f  s loc=$O(^DHCMGNUR.MgNurMaCareUnitI("Typ"," "_larLoc,loc)) q:loc=""  d
 	...s id="" f  s id=$O(^DHCMGNUR.MgPersonsI("Dep"," "_loc,id)) q:id=""  d
 	....s perObj=##class(DHCMGNUR.MgPersons).%OpenId(id)
 	....q:((perdep'="")&&(perObj.PersonDepDR'=perdep))
 	....q:((pno'="")&&($ZConvert(perObj.PersonID,"U")'=pno))
 	....q:((nurseName'="")&&($ZConvert(perObj.PersonName,"U")'[nurseName))
 	....q:((personBattery'="")&&(perObj.PersonBattery.Code'=$List(^DHCMGNUR.CommDictionarySubD(personBatteryid,personBatteryrw),2)))
 	....q:((personAppDuty'="")&&(perObj.PersonAppDutyDR.Code'=$List(^DHCMGNUR.CommDictionarySubD(personAppDutyid,personAppDutyrw),2)))
 	....q:((personSchAge'="")&&(perObj.PersonSchoolAgeDr.Code'=$List(^DHCMGNUR.CommDictionarySubD(personSchAgeid,personSchAgerw),2)))
 	....q:((ageStDate'="")&&(ageEndDate'="")&&((perObj.PersonBirthDay<ageStDate)!(perObj.PersonBirthDay>ageEndDate)))
 	....q:(personNurTyp'="")&&(perObj.PersonNurTyp.Code'=$List(^DHCMGNUR.CommDictionarySubD(personNurTypid,personNurTyprw),2))
 	....q:perObj.PersonType2'="N"
 	....d ..getPersonInfo(perObj,id,.tmp)
 	....s ret=tmp ;_"^rw|"_id
	....d OutRowtyp
	.e  d
	..s num="" f  s num=$O(^DHCMGNUR.MgNurPerWardI("WardRow",num)) q:num=""  d
	...s loc="" f  s loc=$O(^DHCMGNUR.MgNurPerWardI("WardRow",num,loc)) q:loc=""  d
	....s id="" f  s id=$O(^DHCMGNUR.MgPersonsI("Dep"," "_loc,id)) q:id=""  d
 	.....s perObj=##class(DHCMGNUR.MgPersons).%OpenId(id)
 	.....q:((perdep'="")&&(perObj.PersonDepDR'=perdep))
 	.....q:((pno'="")&&($ZConvert(perObj.PersonID,"U")'=pno))
 	.....q:((nurseName'="")&&($ZConvert(perObj.PersonName,"U")'[nurseName))
 	.....q:((personBattery'="")&&(perObj.PersonBattery.Code'=$List(^DHCMGNUR.CommDictionarySubD(personBatteryid,personBatteryrw),2)))
 	.....q:((personAppDuty'="")&&(perObj.PersonAppDutyDR.Code'=$List(^DHCMGNUR.CommDictionarySubD(personAppDutyid,personAppDutyrw),2)))
 	.....q:((personSchAge'="")&&(perObj.PersonSchoolAgeDr.Code'=$List(^DHCMGNUR.CommDictionarySubD(personSchAgeid,personSchAgerw),2)))
 	.....q:((ageStDate'="")&&(ageEndDate'="")&&((perObj.PersonBirthDay<ageStDate)!(perObj.PersonBirthDay>ageEndDate)))
 	.....q:((perObj.PersonDepDR="9999")!(perObj.PersonDepDR="9998")!(perObj.PersonDepDR="9997"))&&(perdep="")
 	.....q:(personNurTyp'="")&&(perObj.PersonNurTyp.Code'=$List(^DHCMGNUR.CommDictionarySubD(personNurTypid,personNurTyprw),2))
 	.....q:perObj.PersonType2'="N"
 	.....d ..getPersonInfo(perObj,id,.tmp)
 	.....s ret=tmp
	.....d OutRowtyp
	e  i secGrp="znurhead" d
	.s larLocTmp=$O(^DHCMGNUR.DHCMgNurLarNurForLocI("Typ"," "_logonUser,"")) q:larLocTmp=""
	.i larLocTmp'="" d
	..s locTmp="" f  s locTmp=$O(^DHCMGNUR.MgNurMaCareUnitI("Typ",larLocTmp,locTmp)) q:locTmp=""  d
	...s id="" f  s id=$O(^DHCMGNUR.MgPersonsI("Dep"," "_locTmp,id)) q:id=""  d
 	....s perObj=##class(DHCMGNUR.MgPersons).%OpenId(id)
 	....q:((perdep'="")&&(perObj.PersonDepDR'=perdep))
 	....q:((pno'="")&&($ZConvert(perObj.PersonID,"U")'=pno))
 	....q:((nurseName'="")&&($ZConvert(perObj.PersonName,"U")'[nurseName))
 	....q:((personBattery'="")&&(perObj.PersonBattery.Code'=$List(^DHCMGNUR.CommDictionarySubD(personBatteryid,personBatteryrw),2)))
 	....q:((personAppDuty'="")&&(perObj.PersonAppDutyDR.Code'=$List(^DHCMGNUR.CommDictionarySubD(personAppDutyid,personAppDutyrw),2)))
 	....q:((personSchAge'="")&&(perObj.PersonSchoolAgeDr.Code'=$List(^DHCMGNUR.CommDictionarySubD(personSchAgeid,personSchAgerw),2)))
 	....q:((ageStDate'="")&&(ageEndDate'="")&&((perObj.PersonBirthDay<ageStDate)!(perObj.PersonBirthDay>ageEndDate)))
 	....q:(personNurTyp'="")&&(perObj.PersonNurTyp.Code'=$List(^DHCMGNUR.CommDictionarySubD(personNurTypid,personNurTyprw),2))
 	....q:perObj.PersonType2'="N"
 	....d ..getPersonInfo(perObj,id,.tmp)
 	....s ret=tmp ;_"^rw|"_id
	....d OutRowtyp
	e  i (secGrp="nurhead") d
	.i perdep'="" d
	..s id="" f  s id=$O(^DHCMGNUR.MgPersonsI("Dep"," "_perdep,id)) q:id=""  d
 	...s perObj=##class(DHCMGNUR.MgPersons).%OpenId(id)
 	...q:((perdep'="")&&(perObj.PersonDepDR'=perdep))
 	...q:((pno'="")&&($ZConvert(perObj.PersonID,"U")'=pno))
 	...q:((nurseName'="")&&($ZConvert(perObj.PersonName,"U")'[nurseName))
 	...q:((personBattery'="")&&(perObj.PersonBattery.Code'=$List(^DHCMGNUR.CommDictionarySubD(personBatteryid,personBatteryrw),2)))
 	...q:((personAppDuty'="")&&(perObj.PersonAppDutyDR.Code'=$List(^DHCMGNUR.CommDictionarySubD(personAppDutyid,personAppDutyrw),2)))
 	...q:((personSchAge'="")&&(perObj.PersonSchoolAgeDr.Code'=$List(^DHCMGNUR.CommDictionarySubD(personSchAgeid,personSchAgerw),2)))
 	...q:((ageStDate'="")&&(ageEndDate'="")&&((perObj.PersonBirthDay<ageStDate)!(perObj.PersonBirthDay>ageEndDate)))
 	...q:(personNurTyp'="")&&(perObj.PersonNurTyp.Code'=$List(^DHCMGNUR.CommDictionarySubD(personNurTypid,personNurTyprw),2))
 	...q:perObj.PersonType2'="N"
 	...d ..getPersonInfo(perObj,id,.tmp)
 	...s ret=tmp ;_"^rw|"_id
	...d OutRowtyp
	e  i (secGrp="nurse") d
	.i pno'="" d
	..s id=$O(^DHCMGNUR.MgPersonsI("SSID"," "_pno,"")) q:id=""
	..i id'="" d
	...s perObj=##class(DHCMGNUR.MgPersons).%OpenId(id)
 	...q:((perdep'="")&&(perObj.PersonDepDR'=perdep))
 	...q:((pno'="")&&($ZConvert(perObj.PersonID,"U")'=pno))
 	...q:((nurseName'="")&&(perObj.PersonName'[nurseName))
 	...q:((personBattery'="")&&(perObj.PersonBattery.Code'=$List(^DHCMGNUR.CommDictionarySubD(personBatteryid,personBatteryrw),2)))
 	...q:((personAppDuty'="")&&(perObj.PersonAppDutyDR.Code'=$List(^DHCMGNUR.CommDictionarySubD(personAppDutyid,personAppDutyrw),2)))
 	...q:((personSchAge'="")&&(perObj.PersonSchoolAgeDr.Code'=$List(^DHCMGNUR.CommDictionarySubD(personSchAgeid,personSchAgerw),2)))
 	...q:((ageStDate'="")&&(ageEndDate'="")&&((perObj.PersonBirthDay<ageStDate)!(perObj.PersonBirthDay>ageEndDate)))
 	...q:perObj.PersonType2'="N"
 	...d ..getPersonInfo(perObj,id,.tmp)
 	...s ret=tmp ;_"^rw|"_id
	...d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(ret)
	Set ^CacheTemp(repid,ind)=Data
 	
 	Set ind=ind+1
	quit
}

ClassMethod SelectPersonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectPerson1Execute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SelectPersonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectPerson1Execute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 民族 
Query FindPersonpeopledr(typ As %String = "") As %Query(ROWSPEC = "peopledr,raw")
{
}

ClassMethod FindPersonpeopledrExecute(ByRef qHandle As %Binary, typ As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s ^TEMP("typ")=typ
 	s tp="" f  s tp=$O(^DHCMGNUR.CommDictionaryI("Code",tp)) q:tp=""  d
 	.q:(tp'=" 民族")
 	.s id="" f  s id=$O(^DHCMGNUR.CommDictionaryI("Code",tp,id)) q:id=""  d
 	..s tm="" f  s tm=$O(^DHCMGNUR.CommDictionarySubI("Code",tm)) q:tm=""  d
 	...s rw="" f  s rw=$O(^DHCMGNUR.CommDictionarySubI("Code",tm,id,rw)) q:rw=""  d
 	....s raw=id_"||"_rw
 	....s a=##class(DHCMGNUR.CommDictionarySub).%OpenId(raw)
 	....s peopledr=a.Code
 	....q:((typ'="")&&(peopledr'[typ))
 	....s stdate=a.FromDate
 	....s enddate=a.EndDate
 	....s date=+$H
 	....;q:(((date<stdate)&&(stdate'=""))!((date>enddate)&&(enddate'="")))
    ....d OutputRow8
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(peopledr,raw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindPersonpeopledrFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPersonpeopledrExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindPersonpeopledrClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPersonpeopledrExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 政治面貌
Query FindPersonPolitydr(typ As %String = "") As %Query(ROWSPEC = "Politydr,raw")
{
}

ClassMethod FindPersonPolitydrExecute(ByRef qHandle As %Binary, typ As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s tp="" f  s tp=$O(^DHCMGNUR.CommDictionaryI("Code",tp)) q:tp=""  d
 	.q:(tp'=" 政治面貌")
 	.s id="" f  s id=$O(^DHCMGNUR.CommDictionaryI("Code",tp,id)) q:id=""  d
 	..s tm="" f  s tm=$O(^DHCMGNUR.CommDictionarySubI("Code",tm)) q:tm=""  d
 	...s rw="" f  s rw=$O(^DHCMGNUR.CommDictionarySubI("Code",tm,id,rw)) q:rw=""  d
 	....s raw=id_"||"_rw
 	....s a=##class(DHCMGNUR.CommDictionarySub).%OpenId(raw)
 	....s Politydr=a.Code
    ....d OutputRow8
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(Politydr,raw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindPersonPolitydrFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPersonPolitydrExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindPersonPolitydrClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPersonPolitydrExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 外语语种
Query FindPersonLanguage(typ As %String = "") As %Query(ROWSPEC = "Language,raw")
{
}

ClassMethod FindPersonLanguageExecute(ByRef qHandle As %Binary, typ As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s tp="" f  s tp=$O(^DHCMGNUR.CommDictionaryI("Code",tp)) q:tp=""  d
 	.q:(tp'=" 外语语种")
 	.s id="" f  s id=$O(^DHCMGNUR.CommDictionaryI("Code",tp,id)) q:id=""  d
 	..s tm="" f  s tm=$O(^DHCMGNUR.CommDictionarySubI("Code",tm)) q:tm=""  d
 	...s rw="" f  s rw=$O(^DHCMGNUR.CommDictionarySubI("Code",tm,id,rw)) q:rw=""  d
 	....s raw=id_"||"_rw
 	....s a=##class(DHCMGNUR.CommDictionarySub).%OpenId(raw)
 	....s Language=a.Code
    ....d OutputRow8
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(Language,raw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindPersonLanguageFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPersonLanguageExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindPersonLanguageClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPersonLanguageExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindPersonShoeNO(typ As %String = "") As %Query(ROWSPEC = "ShoeNO,raw")
{
}

ClassMethod FindPersonShoeNOExecute(ByRef qHandle As %Binary, typ As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s tp="" f  s tp=$O(^DHCMGNUR.CommDictionaryI("Code",tp)) q:tp=""  d
 	.q:(tp'=" 鞋号")
 	.s id="" f  s id=$O(^DHCMGNUR.CommDictionaryI("Code",tp,id)) q:id=""  d
 	..s tm="" f  s tm=$O(^DHCMGNUR.CommDictionarySubI("Code",tm)) q:tm=""  d
 	...s rw="" f  s rw=$O(^DHCMGNUR.CommDictionarySubI("Code",tm,id,rw)) q:rw=""  d
 	....s raw=id_"||"_rw
 	....s a=##class(DHCMGNUR.CommDictionarySub).%OpenId(raw)
 	....s ShoeNO=a.Code
    ....d OutputRow8
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(ShoeNO,raw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindPersonShoeNOFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPersonShoeNOExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindPersonShoeNOClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPersonShoeNOExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindPersonSchoolMedWest(typ As %String = "") As %Query(ROWSPEC = "SchoolMedWest,raw")
{
}

ClassMethod FindPersonSchoolMedWestExecute(ByRef qHandle As %Binary, typ As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s tp="" f  s tp=$O(^DHCMGNUR.CommDictionaryI("Code",tp)) q:tp=""  d
 	.q:(tp'=" 中西医")
 	.s id="" f  s id=$O(^DHCMGNUR.CommDictionaryI("Code",tp,id)) q:id=""  d
 	..s tm="" f  s tm=$O(^DHCMGNUR.CommDictionarySubI("Code",tm)) q:tm=""  d
 	...s rw="" f  s rw=$O(^DHCMGNUR.CommDictionarySubI("Code",tm,id,rw)) q:rw=""  d
 	....s raw=id_"||"_rw
 	....s a=##class(DHCMGNUR.CommDictionarySub).%OpenId(raw)
 	....s SchoolMedWest=a.Code
    ....d OutputRow8
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(SchoolMedWest,raw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindPersonSchoolMedWestFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPersonSchoolMedWestExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindPersonSchoolMedWestClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPersonSchoolMedWestExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindPersonTeachPostDR(typ As %String = "") As %Query(ROWSPEC = "TeachPostDR,raw")
{
}

ClassMethod FindPersonTeachPostDRExecute(ByRef qHandle As %Binary, typ As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s tp="" f  s tp=$O(^DHCMGNUR.CommDictionaryI("Code",tp)) q:tp=""  d
 	.q:(tp'=" 教学职称")
 	.s id="" f  s id=$O(^DHCMGNUR.CommDictionaryI("Code",tp,id)) q:id=""  d
 	..s tm="" f  s tm=$O(^DHCMGNUR.CommDictionarySubI("Code",tm)) q:tm=""  d
 	...s rw="" f  s rw=$O(^DHCMGNUR.CommDictionarySubI("Code",tm,id,rw)) q:rw=""  d
 	....s raw=id_"||"_rw
 	....s a=##class(DHCMGNUR.CommDictionarySub).%OpenId(raw)
 	....s TeachPostDR=a.Code
    ....d OutputRow8
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(TeachPostDR,raw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindPersonTeachPostDRFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPersonTeachPostDRExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindPersonTeachPostDRClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPersonTeachPostDRExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindPersonClothesNO(typ As %String = "") As %Query(ROWSPEC = "ClothesNO,raw")
{
}

ClassMethod FindPersonClothesNOExecute(ByRef qHandle As %Binary, typ As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s tp="" f  s tp=$O(^DHCMGNUR.CommDictionaryI("Code",tp)) q:tp=""  d
 	.q:(tp'=" 衣号")
 	.s id="" f  s id=$O(^DHCMGNUR.CommDictionaryI("Code",tp,id)) q:id=""  d
 	..s tm="" f  s tm=$O(^DHCMGNUR.CommDictionarySubI("Code",tm)) q:tm=""  d
 	...s rw="" f  s rw=$O(^DHCMGNUR.CommDictionarySubI("Code",tm,id,rw)) q:rw=""  d
 	....s raw=id_"||"_rw
 	....s a=##class(DHCMGNUR.CommDictionarySub).%OpenId(raw)
 	....s ClothesNO=a.Code
    ....d OutputRow8
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(ClothesNO,raw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindPersonClothesNOFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPersonClothesNOExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindPersonClothesNOClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPersonClothesNOExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindPersonBattery(typ As %String = "") As %Query(ROWSPEC = "Battery,raw")
{
}

ClassMethod FindPersonBatteryExecute(ByRef qHandle As %Binary, typ As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s tp="" f  s tp=$O(^DHCMGNUR.CommDictionaryI("Code",tp)) q:tp=""  d
 	.q:(tp'=" 护士层级")
 	.s id="" f  s id=$O(^DHCMGNUR.CommDictionaryI("Code",tp,id)) q:id=""  d
 	..s tm="" f  s tm=$O(^DHCMGNUR.CommDictionarySubI("Code",tm)) q:tm=""  d
 	...s rw="" f  s rw=$O(^DHCMGNUR.CommDictionarySubI("Code",tm,id,rw)) q:rw=""  d
 	....s raw=id_"||"_rw
 	....s a=##class(DHCMGNUR.CommDictionarySub).%OpenId(raw)
 	....s Battery=a.Code
    ....d OutputRow8
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(Battery,raw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindPersonBatteryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPersonBatteryExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindPersonBatteryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPersonBatteryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindPersonMentorDR(typ As %String = "") As %Query(ROWSPEC = "MentorDR,raw")
{
}

ClassMethod FindPersonMentorDRExecute(ByRef qHandle As %Binary, typ As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s tp="" f  s tp=$O(^DHCMGNUR.CommDictionaryI("Code",tp)) q:tp=""  d
 	.q:(tp'=" 导师资格")
 	.s id="" f  s id=$O(^DHCMGNUR.CommDictionaryI("Code",tp,id)) q:id=""  d
 	..s tm="" f  s tm=$O(^DHCMGNUR.CommDictionarySubI("Code",tm)) q:tm=""  d
 	...s rw="" f  s rw=$O(^DHCMGNUR.CommDictionarySubI("Code",tm,id,rw)) q:rw=""  d
 	....s raw=id_"||"_rw
 	....s a=##class(DHCMGNUR.CommDictionarySub).%OpenId(raw)
 	....s MentorDR=a.Code
    ....d OutputRow8
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(MentorDR,raw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindPersonMentorDRFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPersonMentorDRExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindPersonMentorDRClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPersonMentorDRExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 
/// 查询毕业学校
Query FindPersonGraduateSchool(typ As %String = "") As %Query(ROWSPEC = "GraduateSchool,raw")
{
}

ClassMethod FindPersonGraduateSchoolExecute(ByRef qHandle As %Binary, typ As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s tp="" f  s tp=$O(^DHCMGNUR.CommDictionaryI("Code",tp)) q:tp=""  d
 	.q:(tp'=" 毕业院校")
 	.s id="" f  s id=$O(^DHCMGNUR.CommDictionaryI("Code",tp,id)) q:id=""  d
 	..s tm="" f  s tm=$O(^DHCMGNUR.CommDictionarySubI("Code",tm)) q:tm=""  d
 	...s rw="" f  s rw=$O(^DHCMGNUR.CommDictionarySubI("Code",tm,id,rw)) q:rw=""  d
 	....s raw=id_"||"_rw
 	....s a=##class(DHCMGNUR.CommDictionarySub).%OpenId(raw)
 	....s GraduateSchool=a.Code
 	....q:(typ'="")&&(GraduateSchool'[$ZConvert(typ,"U"))
    ....d OutputRow8
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(GraduateSchool,raw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindPersonGraduateSchoolFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPersonGraduateSchoolExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindPersonGraduateSchoolClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPersonGraduateSchoolExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindPersonSchoolType(typ As %String = "") As %Query(ROWSPEC = "SchoolType,raw")
{
}

ClassMethod FindPersonSchoolTypeExecute(ByRef qHandle As %Binary, typ As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s tp="" f  s tp=$O(^DHCMGNUR.CommDictionaryI("Code",tp)) q:tp=""  d
 	.q:(tp'=" 院校制式")
 	.s id="" f  s id=$O(^DHCMGNUR.CommDictionaryI("Code",tp,id)) q:id=""  d
 	..s tm="" f  s tm=$O(^DHCMGNUR.CommDictionarySubI("Code",tm)) q:tm=""  d
 	...s rw="" f  s rw=$O(^DHCMGNUR.CommDictionarySubI("Code",tm,id,rw)) q:rw=""  d
 	....s raw=id_"||"_rw
 	....s a=##class(DHCMGNUR.CommDictionarySub).%OpenId(raw)
 	....s SchoolType=a.Code
    ....d OutputRow8
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(SchoolType,raw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindPersonSchoolTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPersonSchoolTypeExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindPersonSchoolTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPersonSchoolTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindPersonNurTyp(typ As %String = "") As %Query(ROWSPEC = "NurTyp,raw")
{
}

ClassMethod FindPersonNurTypExecute(ByRef qHandle As %Binary, typ As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s tp="" f  s tp=$O(^DHCMGNUR.CommDictionaryI("Code",tp)) q:tp=""  d
 	.q:(tp'=" 护士种类")
 	.s id="" f  s id=$O(^DHCMGNUR.CommDictionaryI("Code",tp,id)) q:id=""  d
 	..s tm="" f  s tm=$O(^DHCMGNUR.CommDictionarySubI("Code",tm)) q:tm=""  d
 	...s rw="" f  s rw=$O(^DHCMGNUR.CommDictionarySubI("Code",tm,id,rw)) q:rw=""  d
 	....s raw=id_"||"_rw
 	....s a=##class(DHCMGNUR.CommDictionarySub).%OpenId(raw)
 	....s NurTyp=a.Code
    ....d OutputRow8
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(NurTyp,raw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindPersonNurTypFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPersonNurTypExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindPersonNurTypClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPersonNurTypExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindPersonPostTyp(typ As %String = "") As %Query(ROWSPEC = "PostTyp,raw")
{
}

ClassMethod FindPersonPostTypExecute(ByRef qHandle As %Binary, typ As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s tp="" f  s tp=$O(^DHCMGNUR.CommDictionaryI("Code",tp)) q:tp=""  d
 	.q:(tp'=" 工作科室")
 	.s id="" f  s id=$O(^DHCMGNUR.CommDictionaryI("Code",tp,id)) q:id=""  d
 	..s tm="" f  s tm=$O(^DHCMGNUR.CommDictionarySubI("Code",tm)) q:tm=""  d
 	...s rw="" f  s rw=$O(^DHCMGNUR.CommDictionarySubI("Code",tm,id,rw)) q:rw=""  d
 	....s raw=id_"||"_rw
 	....s a=##class(DHCMGNUR.CommDictionarySub).%OpenId(raw)
 	....s PostTyp=a.Code
    ....d OutputRow8
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(PostTyp,raw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindPersonPostTypFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPersonPostTypExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindPersonPostTypClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPersonPostTypExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindPersonProfession(typ As %String = "") As %Query(ROWSPEC = "Profession,raw")
{
}

ClassMethod FindPersonProfessionExecute(ByRef qHandle As %Binary, typ As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s tp="" f  s tp=$O(^DHCMGNUR.CommDictionaryI("Code",tp)) q:tp=""  d
 	.q:(tp'=" 专业")
 	.s id="" f  s id=$O(^DHCMGNUR.CommDictionaryI("Code",tp,id)) q:id=""  d
 	..s tm="" f  s tm=$O(^DHCMGNUR.CommDictionarySubI("Code",tm)) q:tm=""  d
 	...s rw="" f  s rw=$O(^DHCMGNUR.CommDictionarySubI("Code",tm,id,rw)) q:rw=""  d
 	....s raw=id_"||"_rw
 	....s a=##class(DHCMGNUR.CommDictionarySub).%OpenId(raw)
 	....s Profession=a.Code
    ....d OutputRow8
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(Profession,raw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindPersonProfessionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPersonProfessionExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindPersonProfessionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPersonProfessionExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindPersonSchoolAgeDr(typ As %String = "") As %Query(ROWSPEC = "SchoolAgeDr,raw")
{
}

ClassMethod FindPersonSchoolAgeDrExecute(ByRef qHandle As %Binary, typ As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s tp="" f  s tp=$O(^DHCMGNUR.CommDictionaryI("Code",tp)) q:tp=""  d
 	.q:(tp'=" 学历")
 	.s id="" f  s id=$O(^DHCMGNUR.CommDictionaryI("Code",tp,id)) q:id=""  d
 	..s tm="" f  s tm=$O(^DHCMGNUR.CommDictionarySubI("Code",tm)) q:tm=""  d
 	...s rw="" f  s rw=$O(^DHCMGNUR.CommDictionarySubI("Code",tm,id,rw)) q:rw=""  d
 	....s raw=id_"||"_rw
 	....s a=##class(DHCMGNUR.CommDictionarySub).%OpenId(raw)
 	....s SchoolAgeDr=a.Code
    ....d OutputRow8
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(SchoolAgeDr,raw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindPersonSchoolAgeDrFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPersonSchoolAgeDrExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindPersonSchoolAgeDrClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPersonSchoolAgeDrExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindPersonDegreeDR(typ As %String = "") As %Query(ROWSPEC = "DegreeDR,raw")
{
}

ClassMethod FindPersonDegreeDRExecute(ByRef qHandle As %Binary, typ As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s tp="" f  s tp=$O(^DHCMGNUR.CommDictionaryI("Code",tp)) q:tp=""  d
 	.q:(tp'=" 学位")
 	.s id="" f  s id=$O(^DHCMGNUR.CommDictionaryI("Code",tp,id)) q:id=""  d
 	..s tm="" f  s tm=$O(^DHCMGNUR.CommDictionarySubI("Code",tm)) q:tm=""  d
 	...s rw="" f  s rw=$O(^DHCMGNUR.CommDictionarySubI("Code",tm,id,rw)) q:rw=""  d
 	....s raw=id_"||"_rw
 	....s a=##class(DHCMGNUR.CommDictionarySub).%OpenId(raw)
 	....s DegreeDR=a.Code
    ....d OutputRow8
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(DegreeDR,raw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindPersonDegreeDRFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPersonDegreeDRExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindPersonDegreeDRClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPersonDegreeDRExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindPersonEngageMth(typ As %String = "") As %Query(ROWSPEC = "EngageMth,raw")
{
}

ClassMethod FindPersonEngageMthExecute(ByRef qHandle As %Binary, typ As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s tp="" f  s tp=$O(^DHCMGNUR.CommDictionaryI("Code",tp)) q:tp=""  d
 	.q:(tp'=" 职务聘任方式")
 	.s id="" f  s id=$O(^DHCMGNUR.CommDictionaryI("Code",tp,id)) q:id=""  d
 	..s tm="" f  s tm=$O(^DHCMGNUR.CommDictionarySubI("Code",tm)) q:tm=""  d
 	...s rw="" f  s rw=$O(^DHCMGNUR.CommDictionarySubI("Code",tm,id,rw)) q:rw=""  d
 	....s raw=id_"||"_rw
 	....s a=##class(DHCMGNUR.CommDictionarySub).%OpenId(raw)
 	....s EngageMth=a.Code
    ....d OutputRow8
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(EngageMth,raw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindPersonEngageMthFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPersonEngageMthExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindPersonEngageMthClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPersonEngageMthExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindPersonheadshipDR(typ As %String = "") As %Query(ROWSPEC = "headshipDR,raw")
{
}

ClassMethod FindPersonheadshipDRExecute(ByRef qHandle As %Binary, typ As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s tp="" f  s tp=$O(^DHCMGNUR.CommDictionaryI("Code",tp)) q:tp=""  d
 	.q:(tp'=" 职务")
 	.s id="" f  s id=$O(^DHCMGNUR.CommDictionaryI("Code",tp,id)) q:id=""  d
 	..s tm="" f  s tm=$O(^DHCMGNUR.CommDictionarySubI("Code",tm)) q:tm=""  d
 	...s rw="" f  s rw=$O(^DHCMGNUR.CommDictionarySubI("Code",tm,id,rw)) q:rw=""  d
 	....s raw=id_"||"_rw
 	....s a=##class(DHCMGNUR.CommDictionarySub).%OpenId(raw)
 	....s headshipDR=a.Code
    ....d OutputRow8
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(headshipDR,raw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindPersonheadshipDRFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPersonheadshipDRExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindPersonheadshipDRClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPersonheadshipDRExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindPersonPrefQual(typ As %String = "") As %Query(ROWSPEC = "PrefQual,raw")
{
}

ClassMethod FindPersonPrefQualExecute(ByRef qHandle As %Binary, typ As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s tp="" f  s tp=$O(^DHCMGNUR.CommDictionaryI("Code",tp)) q:tp=""  d
 	.q:(tp'=" 取得专科护士资格种类")
 	.s id="" f  s id=$O(^DHCMGNUR.CommDictionaryI("Code",tp,id)) q:id=""  d
 	..s tm="" f  s tm=$O(^DHCMGNUR.CommDictionarySubI("Code",tm)) q:tm=""  d
 	...s rw="" f  s rw=$O(^DHCMGNUR.CommDictionarySubI("Code",tm,id,rw)) q:rw=""  d
 	....s raw=id_"||"_rw
 	....s a=##class(DHCMGNUR.CommDictionarySub).%OpenId(raw)
 	....s PrefQual=a.Code
    ....d OutputRow8
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(PrefQual,raw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindPersonPrefQualFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPersonPrefQualExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindPersonPrefQualClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPersonPrefQualExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 查询专业技术聘任职称
Query FindPersonAppDutyDR(typ As %String = "") As %Query(ROWSPEC = "AppDutyDR,raw")
{
}

ClassMethod FindPersonAppDutyDRExecute(ByRef qHandle As %Binary, typ As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s tp="" f  s tp=$O(^DHCMGNUR.CommDictionaryI("Code",tp)) q:tp=""  d
 	.q:(tp'=" 聘任专业技术职称")
 	.s id="" f  s id=$O(^DHCMGNUR.CommDictionaryI("Code",tp,id)) q:id=""  d
 	..s tm="" f  s tm=$O(^DHCMGNUR.CommDictionarySubI("Code",tm)) q:tm=""  d
 	...s rw="" f  s rw=$O(^DHCMGNUR.CommDictionarySubI("Code",tm,id,rw)) q:rw=""  d
 	....s raw=id_"||"_rw
 	....s a=##class(DHCMGNUR.CommDictionarySub).%OpenId(raw)
 	....s AppDutyDR=a.Code
    ....d OutputRow8
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(AppDutyDR,raw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindPersonAppDutyDRFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPersonAppDutyDRExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindPersonAppDutyDRClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPersonAppDutyDRExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindPerWard(typ, ward = "") As %Query(ROWSPEC = "ctlocDesc,CtLocDr,p")
{
}

ClassMethod FindPerWardExecute(ByRef qHandle As %Binary, typ, ward = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1 
 	s ward=$TR($ZConvert(ward,"U")," ","")
 	s ty="" f  s ty=$O(^DHCMGNUR.MgNurWardI("Typ",1,ty)) q:ty=""  d
 	.q:((ty'=" WARD")&&(ty'=" PWARD"))
    .s loc="" f  s loc=$O(^DHCMGNUR.MgNurWardI("Typ",1,ty,loc)) q:loc=""  d
    ..s rw="" f  s rw=$O(^DHCMGNUR.MgNurWardI("Typ",1,ty,loc,rw)) q:rw=""  d
    ...s a=##class(DHCMGNUR.MgNurWard).%OpenId(rw)
    ...s CtLocDr=a.WardLoc         
    ...s p=a.SortPos
    ...s ctlocDesc=$p(^CTLOC(CtLocDr),"^",2)
    ...q:(ctlocDesc'[ward)&&(ward'="")
    ...i CtLocDr=6 b ;2
    ...d OutputRow8
    s ctlocDesc="LZ-轮转"
    s CtLocDr=947
    s p=""
    d OutputRow8
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(ctlocDesc,CtLocDr,p)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindPerWardFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPerWardExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindPerWardClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPerWardExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 查询学历子集
Query FindPersonLearningExp(parr As %String, rowid As %String, typ As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindPersonLearningExpExecute(ByRef qHandle As %Binary, parr As %String, rowid As %String, typ As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s ret=""
 	s parr=$ZConvert(parr,"U")
 	i typ="Complete"
 	{
 		s id="" f  s id=$O(^DHCMGNUR.MgNurLeaExpI("PerID"," "_parr,id)) q:id=""  d
 		.s rmw="" f  s rmw=$O(^DHCMGNUR.MgNurLeaExpI("PerID"," "_parr,id,rmw)) q:rmw=""  d
 		..s rw=id_"||"_rmw
 		..d outdata(rw)
 	}
 	i typ="Verify"
 	{
	 	s id="" f  s id=$O(^DHCMGNUR.MgNurLeaExpI("PerFlag"," 1"," "_parr,id)) q:id=""  d
	 	.s rmw="" f  s rmw=$O(^DHCMGNUR.MgNurLeaExpI("PerFlag"," 1"," "_parr,id,rmw)) q:rmw=""  d
	 	..s rw=id_"||"_rmw
	 	..d outdata(rw)
 	}
 	i typ="unVerify"
 	{
	 	s id="" f  s id=$O(^DHCMGNUR.MgNurLeaExpI("PerFlag"," 0"," "_parr,id)) q:id=""  d
	 	.s rmw="" f  s rmw=$O(^DHCMGNUR.MgNurLeaExpI("PerFlag"," 0"," "_parr,id,rmw)) q:rmw=""  d
	 	..s rw=id_"||"_rmw
	 	..d outdata(rw)
 	}  
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
outdata(rw)
	s dateFlag=##class(websys.Conversions).DateFormat()
	s a=##class(DHCMGNUR.MgNurLeaExp).%OpenId(rw)
 	s PerID=a.PerID
 	s PerName=a.PerName
 	i a.StaDate'="" d
 	.i ((dateFlag=3)!(dateFlag=4)) s StaDate=##class(web.DHCMgNurPerHRComm).getDateFormat(a.StaDate)
 	.e  s StaDate=""  
 	e  s StaDate=""
 	i a.EndDate'="" d
 	.i ((dateFlag=3)!(dateFlag=4)) s EndDate=##class(web.DHCMgNurPerHRComm).getDateFormat(a.EndDate)
 	.e  s EndDate="" 
 	e  s EndDate=""
 	i a.PerDegreeDR.Code'="" s PerDegreeDR=a.PerDegreeDR.Code
 	e  s PerDegreeDR=""
 	s PerDegreeNo=a.PerDegreeNo
 	i a.PerGraduateSchool.Code'="" s PerGraduateSchool=a.PerGraduateSchool.Code
 	e  s PerGraduateSchool=""
 	s PerHeadShip=a.PerHeadShip
 	i a.PerProfession.Code'="" s PerProfession=a.PerProfession.Code
 	e  s PerProfession=""
 	s PerReferences=a.PerReferences
 	i a.PerSchoolAgeDr.Code'="" s PerSchoolAgeDr=a.PerSchoolAgeDr.Code
 	e  s PerSchoolAgeDr=""
 	s PerSchoolAgeNo=a.PerSchoolAgeNo
 	s PerFlag=a.PerFlag
 	s raw=$tr(rw,"||","__")
 	s ret="PerID|"_PerID_"^PerName|"_PerName_"^StaDate|"_StaDate_"^EndDate|"_EndDate_"^PerDegreeDR|"_PerDegreeDR_"^PerDegreeNo|"_PerDegreeNo_"^PerGraduateSchool|"_PerGraduateSchool_"^PerHeadShip|"_PerHeadShip_"^PerProfession|"_PerProfession_"^PerReferences|"_PerReferences_"^PerSchoolAgeDr|"_PerSchoolAgeDr_"^PerSchoolAgeNo|"_PerSchoolAgeNo_"^raw|"_raw_"^PerFlag|"_PerFlag
	s ret=ret 
	d OutRowtyp
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutRowtyp
	set Data=$lb(ret)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindPersonLearningExpFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPersonLearningExpExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindPersonLearningExpClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPersonLearningExpExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

/// 查询教育培训子集信息
Query FindPersonEduTrain(parr1 As %String, rowid As %String, typ As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindPersonEduTrainExecute(ByRef qHandle As %Binary, parr1 As %String, rowid As %String, typ As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s ret=""
 	s parr1=$ZConvert(parr1,"U")
 	i typ="Complete"
 	{
	 	s id="" f  s id=$O(^DHCMGNUR.MgNurEduTraI("PerID"," "_parr1,id)) q:id=""  d
 		.s rmw="" f  s rmw=$O(^DHCMGNUR.MgNurEduTraI("PerID"," "_parr1,id,rmw)) q:rmw=""  d
 		..s rw=id_"||"_rmw
 		..d outdata(rw)
 	}
 	i typ="Verify"
 	{
	 	s id="" f  s id=$O(^DHCMGNUR.MgNurEduTraI("PerFlag"," 1"," "_parr1,id)) q:id=""  d
	 	.s rmw="" f  s rmw=$O(^DHCMGNUR.MgNurEduTraI("PerFlag"," 1"," "_parr1,id,rmw)) q:rmw=""  d
 		..s rw=id_"||"_rmw
 		..d outdata(rw)
 	}
 	i typ="unVerify"
 	{
	 	s id="" f  s id=$O(^DHCMGNUR.MgNurEduTraI("PerFlag"," 0"," "_parr1,id)) q:id=""  d
	 	.s rmw="" f  s rmw=$O(^DHCMGNUR.MgNurEduTraI("PerFlag"," 0"," "_parr1,id,rmw)) q:rmw=""  d
 		..s rw=id_"||"_rmw
 		..d outdata(rw)
 	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

outdata(rw)
	s dateFlag=##class(websys.Conversions).DateFormat()
	s a=##class(DHCMGNUR.MgNurEduTra).%OpenId(rw)
 	s PerID=a.PerID
 	s PerName=a.PerName
 	i a.StaDate'="" d
 	.i ((dateFlag=3)!(dateFlag=4)) s StaDate=##class(web.DHCMgNurPerHRComm).getDateFormat(a.StaDate)
 	.e  s StaDate=""
 	e  s StaDate=""
 	i a.EndDate'="" d
 	.i ((dateFlag=3)!(dateFlag=4)) s EndDate=##class(web.DHCMgNurPerHRComm).getDateFormat(a.EndDate)
 	.e  s EndDate=""
 	e  s EndDate=""
 	s PerTotalHours=a.PerTotalHours
 	s PerTrainContent=a.PerTrainContent
 	s PerCourseName=a.PerCourseName
 	s PerTrainHabitude=a.PerTrainHabitude
 	i PerTrainHabitude="1" s PerTrainHabitude="培训班"
 	e  i PerTrainHabitude="2" s PerTrainHabitude="进修班"
 	e  i PerTrainHabitude="3" s PerTrainHabitude="继续班"
 	e  i PerTrainHabitude="4" s PerTrainHabitude="其他"
 	e  s PerTrainHabitude=""
 	s PerTrainUnits=a.PerTrainUnits
 	s PerCredit=a.PerCredit
	s PerCreditType=a.PerCreditType
	i PerCreditType="1" s PerCreditType="I 类"
	i PerCreditType="2" s PerCreditType="II 类"
	s PerFlag=a.PerFlag
	s raw=$tr(rw,"||","__")
	s ret="PerID|"_PerID_"^PerName|"_PerName_"^StaDate|"_StaDate_"^EndDate|"_EndDate_"^PerTotalHours|"_PerTotalHours_"^PerTrainContent|"_PerTrainContent_"^PerCourseName|"_PerCourseName_"^PerTrainHabitude|"_PerTrainHabitude_"^PerTrainUnits|"_PerTrainUnits_"^PerCredit|"_PerCredit_"^PerCreditType|"_PerCreditType_"^raw|"_raw_"^PerFlag|"_PerFlag
	s ret=ret
	d OutRowtyp
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutRowtyp
	set Data=$lb(ret)
	Set ^CacheTemp(repid,ind)=Data
 	
 	Set ind=ind+1
	quit
}

ClassMethod FindPersonEduTrainFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPersonEduTrainExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindPersonEduTrainClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPersonEduTrainExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 查询奖惩信息子集
Query FindPersonRewardPunish(parr As %String, rowid As %String, typ As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindPersonRewardPunishExecute(ByRef qHandle As %Binary, parr As %String, rowid As %String, typ As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s ret=""
 	s parr=$ZConvert(parr,"U")
 	i typ="Complete"
 	{
	 	s id="" f  s id=$O(^DHCMGNUR.MgNurRewardPunishI("PerID"," "_parr,id)) q:id=""  d
 		.s rmw="" f  s rmw=$O(^DHCMGNUR.MgNurRewardPunishI("PerID"," "_parr,id,rmw)) q:rmw=""  d
 		..s rw=id_"||"_rmw
 		..d outdata(rw)
 	}
 	i typ="Verify"
 	{
	 	s id="" f  s id=$O(^DHCMGNUR.MgNurRewardPunishI("PerFlag"," 1"," "_parr,id)) q:id=""  d
	 	.s rmw="" f  s rmw=$O(^DHCMGNUR.MgNurRewardPunishI("PerFlag"," 1"," "_parr,id,rmw)) q:rmw=""  d
 		..s rw=id_"||"_rmw
 		..d outdata(rw)
 	}
 	i typ="unVerify"
 	{
	 	s id="" f  s id=$O(^DHCMGNUR.MgNurRewardPunishI("PerFlag"," 0"," "_parr,id)) q:id=""  d
	 	.s rmw="" f  s rmw=$O(^DHCMGNUR.MgNurRewardPunishI("PerFlag"," 0"," "_parr,id,rmw)) q:rmw=""  d
	 	..s rw=id_"||"_rmw
 		..d outdata(rw)
 	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
outdata(rw)
	s dateFlag=##class(websys.Conversions).DateFormat()
	s a=##class(DHCMGNUR.MgNurRewardPunish).%OpenId(rw)
 	s PerID=a.PerID
 	s PerName=a.PerName
 	i a.PerRewPunDate'="" d
 	.i ((dateFlag=3)!(dateFlag=4)) s PerRewPunDate=##class(web.DHCMgNurPerHRComm).getDateFormat(a.PerRewPunDate)
 	.e  s PerRewPunDate=""
 	e  s PerRewPunDate=""
 	s PerRewPunName=a.PerRewPunName
 	s PerRewPunReason=a.PerRewPunReason
 	s PerRewPunUnit=a.PerRewPunUnit
 	s PerFlag=a.PerFlag
 	s raw=$tr(rw,"||","__")
 	s ret="PerID|"_PerID_"^PerName|"_PerName_"^PerRewPunDate|"_PerRewPunDate_"^PerRewPunName|"_PerRewPunName_"^PerRewPunReason|"_PerRewPunReason_"^PerRewPunUnit|"_PerRewPunUnit_"^raw|"_raw_"^PerFlag|"_PerFlag
	s ret=ret
	d OutRowtyp  
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutRowtyp
	set Data=$lb(ret)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindPersonRewardPunishFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPersonRewardPunishExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindPersonRewardPunishClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPersonRewardPunishExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

/// 查询个人联系信息
Query FindPersonContact(parrn As %String, rowid As %String, typ As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindPersonContactExecute(ByRef qHandle As %Binary, parrn As %String, rowid As %String, typ As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s ret=""
 	s parrn=$ZConvert(parrn,"U")
 	i typ="Complete"
 	{
	 	s id="" f  s id=$O(^DHCMGNUR.MgNurContactI("PerID"," "_parrn,id)) q:id=""  d
 		.s rmw="" f  s rmw=$O(^DHCMGNUR.MgNurContactI("PerID"," "_parrn,id,rmw)) q:rmw=""  d
 		..s rw=id_"||"_rmw
 		..d outdata(rw)
 	}
 	i typ="Verify"
 	{
	 	s id="" f  s id=$O(^DHCMGNUR.MgNurContactI("PerFlag"," 1"," "_parrn,id)) q:id=""  d
	 	.s rmw="" f  s rmw=$O(^DHCMGNUR.MgNurContactI("PerFlag"," 1"," "_parrn,id,rmw)) q:rmw=""  d
	 	..s rw=id_"||"_rmw
	 	..d outdata(rw)
 	}
 	i typ="unVerify"
 	{
	 	s id="" f  s id=$O(^DHCMGNUR.MgNurContactI("PerFlag"," 0"," "_parrn,id)) q:id=""  d
	 	.s rmw="" f  s rmw=$O(^DHCMGNUR.MgNurContactI("PerFlag"," 0"," "_parrn,id,rmw)) q:rmw=""  d
	 	..s rw=id_"||"_rmw
	 	..d outdata(rw)
 	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
outdata(rw)
	s a=##class(DHCMGNUR.MgNurContact).%OpenId(rw)
	s PerID=a.PerID
 	s PerName=a.PerName
 	s PerHouseTel=a.PerHouseTel
 	s PerOfficeTel=a.PerOfficeTel
 	s PerMobilePhone=a.PerMobilePhone
 	s PerHouseAddress=a.PerHouseAddress
 	s PerFlag=a.PerFlag
 	s raw=$tr(rw,"||","__")
 	s ret="PerID|"_PerID_"^PerName|"_PerName_"^PerHouseTel|"_PerHouseTel_"^PerOfficeTel|"_PerOfficeTel_"^PerMobilePhone|"_PerMobilePhone_"^PerHouseAddress|"_PerHouseAddress_"^raw|"_raw_"^PerFlag|"_PerFlag
	s ret=ret
	d OutRowtyp  
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRowtyp
	set Data=$lb(ret)
	Set ^CacheTemp(repid,ind)=Data
 	
 	Set ind=ind+1
	quit
}

ClassMethod FindPersonContactFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPersonContactExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindPersonContactClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPersonContactExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 查询个人科研论文信息
Query FindPersonResearch(parrn As %String, rowid As %String, typ As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindPersonResearchExecute(ByRef qHandle As %Binary, parrn As %String, rowid As %String, typ As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s ret=""
 	s parrn=$ZConvert(parrn,"U")
 	i typ="Complete"
 	{
	 	s id="" f  s id=$O(^DHCMGNUR.MgNurResThesisI("PerID"," "_parrn,id)) q:id=""  d
 		.s rmw="" f  s rmw=$O(^DHCMGNUR.MgNurResThesisI("PerID"," "_parrn,id,rmw)) q:rmw=""  d
 		..s rw=id_"||"_rmw
 		..d outdata(rw)
 	}
 	i typ="Verify"
 	{
	 	s id="" f  s id=$O(^DHCMGNUR.MgNurResThesisI("PerFlag"," 1"," "_parrn,id)) q:id=""  d
	 	.s rmw="" f  s rmw=$O(^DHCMGNUR.MgNurResThesisI("PerFlag"," 1"," "_parrn,id,rmw)) q:rmw=""  d
	 	..s rw=id_"||"_rmw
	 	..d outdata(rw)
 	}
 	i typ="unVerify"
 	{
	 	s id="" f  s id=$O(^DHCMGNUR.MgNurResThesisI("PerFlag"," 0"," "_parrn,id)) q:id=""  d
	 	.s rmw="" f  s rmw=$O(^DHCMGNUR.MgNurResThesisI("PerFlag"," 0"," "_parrn,id,rmw)) q:rmw=""  d
	 	..s rw=id_"||"_rmw
	 	..d outdata(rw)
 	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
outdata(rw)
	s dateFlag=##class(websys.Conversions).DateFormat()
	s a=##class(DHCMGNUR.MgNurResThesis).%OpenId(rw)
 	s PerID=a.PerID
 	s PerName=a.PerName
 	s PerResearchItem=a.PerResearchItem
 	i a.PerResearchType="1" s PerResearchType="国家级科研项目"
 	e  i a.PerResearchType="2" s PerResearchType="省部级科研项目"
 	e  i a.PerResearchType="3" s PerResearchType="市厅级科研项目"
 	e  i a.PerResearchType="4" s PerResearchType="市局级科研项目"
 	e  i a.PerResearchType="5" s PerResearchType="其他"
 	e  i a.PerResearchType="6" s PerResearchType="无"
 	e  s PerResearchType=""
 	s PerResearchResult=a.PerResearchResult
 	s PerPubThesis=a.PerPubThesis
 	i a.PerPubDate'="" d
 	.i ((dateFlag=3)!(dateFlag=4)) s PerPubDate=##class(web.DHCMgNurPerHRComm).getDateFormat(a.PerPubDate)
 	.e  s PerPubDate=""
 	e  s PerPubDate=""
 	s PerJournalTitle=a.PerJournalTitle
 	i a.PerJournalType="1" s PerJournalType="核心期刊"
 	e  i a.PerJournalType="3" s PerJournalType="CN期刊"
 	e  i a.PerJournalType="4" s PerJournalType="统计源期刊"
 	e  i a.PerJournalType="5" s PerJournalType="SCI期刊"
 	e  s PerJournalType=""
 	i a.PerAuthorType="1" s PerAuthorType="第一作者"
 	e  i a.PerAuthorType="2" s PerAuthorType="第二作者"
 	e  i a.PerAuthorType="3" s PerAuthorType="第三作者"
 	e  i a.PerAuthorType="4" s PerAuthorType="通讯作者"
 	e  i a.PerAuthorType="5" s PerAuthorType="独作"
 	e  s PerAuthorType=""
 	s PerJalVol=a.PerJalVol
 	s PerJalPage=a.PerJalPage
 	s PerFlag=a.PerFlag
 	s raw=$tr(rw,"||","__")
 	s ret="PerID|"_PerID_"^PerName|"_PerName_"^PerResearchItem|"_PerResearchItem_"^PerResearchType|"_PerResearchType_"^PerResearchResult|"_PerResearchResult_"^PerPubThesis|"_PerPubThesis_"^PerPubDate|"_PerPubDate_"^PerJournalTitle|"_PerJournalTitle_"^PerJournalType|"_PerJournalType_"^raw|"_raw_"^PerFlag|"_PerFlag_"^PerAuthorType|"_PerAuthorType_"^PerJalVol|"_PerJalVol_"^PerJalPage|"_PerJalPage
	s ret=ret
	d OutRowtyp
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK  

OutRowtyp
	set Data=$lb(ret)
	Set ^CacheTemp(repid,ind)=Data
 	
 	Set ind=ind+1
	quit
}

ClassMethod FindPersonResearchFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPersonResearchExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindPersonResearchClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPersonResearchExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

/// 查询院内业务学习信息
Query FindPersonHosLearn(parrn2 As %String, rowid As %String, typ As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindPersonHosLearnExecute(ByRef qHandle As %Binary, parrn2 As %String, rowid As %String, typ As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s ret=""
 	s parrn2=$ZConvert(parrn2,"U")
 	i typ="Complete"
 	{
	 	s id="" f  s id=$O(^DHCMGNUR.MgNurHosBusLearingI("PerID"," "_parrn2,id)) q:id=""  d
 		.s rmw="" f  s rmw=$O(^DHCMGNUR.MgNurHosBusLearingI("PerID"," "_parrn2,id,rmw)) q:rmw=""  d
 		..s rw=id_"||"_rmw
 		..d outdata(rw)
 	}
 	i typ="Verify"
 	{
	 	s id="" f  s id=$O(^DHCMGNUR.MgNurHosBusLearingI("PerFlag"," 1"," "_parrn2,id)) q:id=""  d
	 	.s rmw="" f  s rmw=$O(^DHCMGNUR.MgNurHosBusLearingI("PerFlag"," 1"," "_parrn2,id,rmw)) q:rmw=""  d
	 	..s rw=id_"||"_rmw
	 	..d outdata(rw)
 	}
 	i typ="unVerify"
 	{
	 	s id="" f  s id=$O(^DHCMGNUR.MgNurHosBusLearingI("PerFlag"," 0"," "_parrn2,id)) q:id=""  d
	 	.s rmw="" f  s rmw=$O(^DHCMGNUR.MgNurHosBusLearingI("PerFlag"," 0"," "_parrn2,id,rmw)) q:rmw=""  d
	 	..s rw=id_"||"_rmw
	 	..d outdata(rw)
 	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outdata(rw)
	s dateFlag=##class(websys.Conversions).DateFormat()
	s a=##class(DHCMGNUR.MgNurHosBusLearing).%OpenId(rw)
 	s PerID=a.PerID
 	s PerName=a.PerName
 	i a.PerLearnDate'="" d
 	.i ((dateFlag=3)!(dateFlag=4)) s PerLearnDate=##class(web.DHCMgNurPerHRComm).getDateFormat(a.PerLearnDate)
 	.e  s PerLearnDate=""
 	e  s PerLearnDate=""
 	s PerLearnContent=a.PerLearnContent
 	s PerPresenter=a.PerPresenter
 	i a.PerCreditType="1" s PerCreditType="国家I 类"
 	e  i a.PerCreditType="0" s PerCreditType="国家II 类"
 	e  i a.PerCreditType="3" s PerCreditType="省内I 类"
 	e  i a.PerCreditType="2" s PerCreditType="院内II类"
 	e  s PerCreditType=""
 	s PerCredit=a.PerCredit
 	s PerFlag=a.PerFlag
 	s raw=$tr(rw,"||","__")
 	s ret="PerID|"_PerID_"^PerName|"_PerName_"^PerLearnDate|"_PerLearnDate_"^PerLearnContent|"_PerLearnContent_"^PerPresenter|"_PerPresenter_"^PerCreditType|"_PerCreditType_"^PerCredit|"_PerCredit_"^PerFlag|"_PerFlag_"^raw|"_raw
 	s ret=ret
	d OutRowtyp
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
 
OutRowtyp
	set Data=$lb(ret)
	Set ^CacheTemp(repid,ind)=Data
 	
 	Set ind=ind+1
	quit
}

ClassMethod FindPersonHosLearnFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPersonHosLearnExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindPersonHosLearnClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPersonHosLearnExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

/// 查询科内业务学习子集
Query FindPersonDepartLearn(parrn As %String, rowid As %String, typ As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindPersonDepartLearnExecute(ByRef qHandle As %Binary, parrn As %String, rowid As %String, typ As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s ret=""
 	s parrn=$ZConvert(parrn,"U")
 	i typ="Complete"
 	{
	 	s id="" f  s id=$O(^DHCMGNUR.MgNurDepartLearningI("PerID"," "_parrn,id)) q:id=""  d
 		.s rmw="" f  s rmw=$O(^DHCMGNUR.MgNurDepartLearningI("PerID"," "_parrn,id,rmw)) q:rmw=""  d
 		..s rw=id_"||"_rmw
 		..d outdata(rw)
 	}
 	i typ="Verify"
 	{
	 	s id="" f  s id=$O(^DHCMGNUR.MgNurDepartLearningI("PerFlag"," 1"," "_parrn,id)) q:id=""  d
	 	.s rmw="" f  s rmw=$O(^DHCMGNUR.MgNurDepartLearningI("PerFlag"," 1"," "_parrn,id,rmw)) q:rmw=""  d
	 	..s rw=id_"||"_rmw
	 	..d outdata(rw)
 	}
 	i typ="unVerify"
 	{
	 	s id="" f  s id=$O(^DHCMGNUR.MgNurDepartLearningI("PerFlag"," 0"," "_parrn,id)) q:id=""  d
	 	.s rmw="" f  s rmw=$O(^DHCMGNUR.MgNurDepartLearningI("PerFlag"," 0"," "_parrn,id,rmw)) q:rmw=""  d
	 	..s rw=id_"||"_rmw
	 	..d outdata(rw)
 	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

outdata(rw)
	s dateFlag=##class(websys.Conversions).DateFormat()
	s a=##class(DHCMGNUR.MgNurDepartLearning).%OpenId(rw)
 	s PerID=a.PerID
 	s PerName=a.PerName
 	i a.PerLearnDate'="" d
 	.i ((dateFlag=3)!(dateFlag=4)) s PerLearnDate=##class(web.DHCMgNurPerHRComm).getDateFormat(a.PerLearnDate)
 	.e  s PerLearnDate=""
 	e  s PerLearnDate=""
 	s PerLearnContent=a.PerLearnContent
 	s PerPresenter=a.PerPresenter
 	i a.PerCreditType="1" s PerCreditType="国家I 类"
 	e  i a.PerCreditType="2" s PerCreditType="科室II 类"
 	e  i a.PerCreditType="3" s PerCreditType="省内I 类"
 	e  s PerCreditType=""
 	s PerCredit=a.PerCredit
 	s PerFlag=a.PerFlag
 	s raw=$tr(rw,"||","__")
 	s ret="PerID|"_PerID_"^PerName|"_PerName_"^PerLearnDate|"_PerLearnDate_"^PerLearnContent|"_PerLearnContent_"^PerPresenter|"_PerPresenter_"^PerCreditType|"_PerCreditType_"^PerCredit|"_PerCredit_"^raw|"_raw_"^PerFlag|"_PerFlag
	s ret=ret
	d OutRowtyp
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutRowtyp
	set Data=$lb(ret)
	Set ^CacheTemp(repid,ind)=Data
 	
 	Set ind=ind+1
	quit
}

ClassMethod FindPersonDepartLearnFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPersonDepartLearnExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindPersonDepartLearnClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPersonDepartLearnExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

/// 查询个人著作子集
Query FindPersonPerBook(parrn As %String, rowid As %String, typ As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindPersonPerBookExecute(ByRef qHandle As %Binary, parrn As %String, rowid As %String, typ As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s ret=""
 	s parrn=$ZConvert(parrn,"U")
 	i typ="Complete"
 	{
	 	s id="" f  s id=$O(^DHCMGNUR.MgNurPersonalBookI("PerID"," "_parrn,id)) q:id=""  d
 		.s rmw="" f  s rmw=$O(^DHCMGNUR.MgNurPersonalBookI("PerID"," "_parrn,id,rmw)) q:rmw=""  d
 		..s rw=id_"||"_rmw
 		..d outdata(rw)	
 	}
 	i typ="Verify"
 	{
	 	s id="" f  s id=$O(^DHCMGNUR.MgNurPersonalBookI("PerFlag"," 1"," "_parrn,id)) q:id=""  d
	 	.s rmw="" f  s rmw=$O(^DHCMGNUR.MgNurPersonalBookI("PerFlag"," 1"," "_parrn,id,rmw)) q:rmw=""  d
	 	..s rw=id_"||"_rmw
	 	..d outdata(rw)	
 	}
 	i typ="unVerify"
 	{
	 	s id="" f  s id=$O(^DHCMGNUR.MgNurPersonalBookI("PerFlag"," 0"," "_parrn,id)) q:id=""  d
	 	.s rmw="" f  s rmw=$O(^DHCMGNUR.MgNurPersonalBookI("PerFlag"," 0"," "_parrn,id,rmw)) q:rmw=""  d
	 	..s rw=id_"||"_rmw
	 	..d outdata(rw)
 	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outdata(rw)
	s dateFlag=##class(websys.Conversions).DateFormat()
	s a=##class(DHCMGNUR.MgNurPersonalBook).%OpenId(rw)
 	s PerID=a.PerID
 	s PerName=a.PerName
 	s PerBookTitle=a.PerBookTitle
 	s PerBookNumber=a.PerBookNumber
 	s PerPubAgency=a.PerPubAgency
 	i a.PerPubDate'="" d
 	.i ((dateFlag=3)!(dateFlag=4)) s PerPubDate=##class(web.DHCMgNurPerHRComm).getDateFormat(a.PerPubDate)
 	.e  s PerPubDate=""
 	e  s PerPubDate=""
 	i a.PerCpyEtTyp="1" s PerCpyEtTyp="主审"
 	e  i a.PerCpyEtTyp="2" s PerCpyEtTyp="主编"
	e  i a.PerCpyEtTyp="3" s PerCpyEtTyp="副主编"
	e  i a.PerCpyEtTyp="4" s PerCpyEtTyp="参编"
	e  s PerCpyEtTyp=""
 	s PerFlag=a.PerFlag
 	s raw=$tr(rw,"||","__")
 	s ret="PerID|"_PerID_"^PerName|"_PerName_"^PerBookTitle|"_PerBookTitle_"^PerBookNumber|"_PerBookNumber_"^PerPubAgency|"_PerPubAgency_"^PerPubDate|"_PerPubDate_"^raw|"_raw_"^PerFlag|"_PerFlag_"^PerCpyEtTyp|"_PerCpyEtTyp
	s ret=ret
	d OutRowtyp
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRowtyp
	set Data=$lb(ret)
	Set ^CacheTemp(repid,ind)=Data
 	
 	Set ind=ind+1
	quit
}

ClassMethod FindPersonPerBookFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPersonPerBookExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindPersonPerBookClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPersonPerBookExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

/// 查询家庭成员及社会关系
Query FindPersonFamilyRelation(parrm As %String, rowid As %String, typ As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindPersonFamilyRelationExecute(ByRef qHandle As %Binary, parrm As %String, rowid As %String, typ As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s ret=""
 	s parrm=$ZConvert(parrm,"U")
 	i typ="Complete"
 	{
	 	s id="" f  s id=$O(^DHCMGNUR.MgNurFamilyRelationI("PerID"," "_parrm,id)) q:id=""  d
 		.s rmw="" f  s rmw=$O(^DHCMGNUR.MgNurFamilyRelationI("PerID"," "_parrm,id,rmw)) q:rmw=""  d
 		..s rw=id_"||"_rmw
 		..d outdata(rw)
 	}
 	i typ="Verify"
 	{
	 	s id="" f  s id=$O(^DHCMGNUR.MgNurFamilyRelationI("PerFlag"," 1"," "_parrm,id)) q:id=""  d
	 	.s rmw="" f  s rmw=$O(^DHCMGNUR.MgNurFamilyRelationI("PerFlag"," 1"," "_parrm,id,rmw)) q:rmw=""  d
	 	..s rw=id_"||"_rmw
	 	..d outdata(rw)		
 	}
 	i typ="unVerify"
 	{
	 	s id="" f  s id=$O(^DHCMGNUR.MgNurFamilyRelationI("PerFlag"," 0"," "_parrm,id)) q:id=""  d
	 	.s rmw="" f  s rmw=$O(^DHCMGNUR.MgNurFamilyRelationI("PerFlag"," 0"," "_parrm,id,rmw)) q:rmw=""  d
	 	..s rw=id_"||"_rmw
	 	..d outdata(rw) 	
 	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
outdata(rw)
	s a=##class(DHCMGNUR.MgNurFamilyRelation).%OpenId(rw)
 	s PerID=a.PerID
 	s PerName=a.PerName
 	s PerRelationSelf=a.PerRelationSelf
 	s PerMemberName=a.PerMemberName
 	s PerMemberWorkUnit=a.PerMemberWorkUnit
 	s PerMemberContact=a.PerMemberContact
 	s PerMemberPosition=a.PerMemberPosition
 	s PerFlag=a.PerFlag
 	s raw=$tr(rw,"||","__")
 	s ret="PerID|"_PerID_"^PerName|"_PerName_"^PerRelationSelf|"_PerRelationSelf_"^PerMemberName|"_PerMemberName_"^PerMemberWorkUnit|"_PerMemberWorkUnit_"^PerMemberContact|"_PerMemberContact_"^PerMemberPosition|"_PerMemberPosition_"^raw|"_raw_"^PerFlag|"_PerFlag
	s ret=ret
	d OutRowtyp  
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRowtyp
	set Data=$lb(ret)
	Set ^CacheTemp(repid,ind)=Data
 	
 	Set ind=ind+1
	quit
}

ClassMethod FindPersonFamilyRelationFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPersonFamilyRelationExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindPersonFamilyRelationClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPersonFamilyRelationExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

/// 查询考核信息
Query FindPersonExamine(parrm As %String, rowid As %String, typ As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindPersonExamineExecute(ByRef qHandle As %Binary, parrm As %String, rowid As %String, typ As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s ret=""
 	s parrm=$ZConvert(parrm,"U")
 	i typ="Complete"
 	{
	 	s id="" f  s id=$O(^DHCMGNUR.MgNurExamineI("PerID"," "_parrm,id)) q:id=""  d
 		.s rmw="" f  s rmw=$O(^DHCMGNUR.MgNurExamineI("PerID"," "_parrm,id,rmw)) q:rmw=""  d
 		..s rw=id_"||"_rmw
 		..d outdata(rw)
 	}
 	i typ="Verify"
 	{
	 	s id="" f  s id=$O(^DHCMGNUR.MgNurExamineI("PerFlag"," 1"," "_parrm,id)) q:id=""  d
	 	.s rmw="" f  s rmw=$O(^DHCMGNUR.MgNurExamineI("PerFlag"," 1"," "_parrm,id,rmw)) q:rmw=""  d
	 	..s rw=id_"||"_rmw
	 	..d outdata(rw)
 	}
 	i typ="unVerify"
 	{
	 	s id="" f  s id=$O(^DHCMGNUR.MgNurExamineI("PerFlag"," 0"," "_parrm,id)) q:id=""  d
	 	.s rmw="" f  s rmw=$O(^DHCMGNUR.MgNurExamineI("PerFlag"," 0"," "_parrm,id,rmw)) q:rmw=""  d
	 	..s rw=id_"||"_rmw
	 	..d outdata(rw)
 	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
outdata(rw)
	s dateFlag=##class(websys.Conversions).DateFormat()
	s a=##class(DHCMGNUR.MgNurExamine).%OpenId(rw)
 	s PerID=a.PerID
 	s PerName=a.PerName
 	i a.PerExamineDate'="" d
 	.i ((dateFlag=3)!(dateFlag=4)) s PerExamineDate=##class(web.DHCMgNurPerHRComm).getDateFormat(a.PerExamineDate)
 	.e  s PerExamineDate=""
 	e  s PerExamineDate=""
 	s PerExamineType=a.PerExamineType
 	s PerExamineContent=a.PerExamineContent
 	s PerExamineResult=a.PerExamineResult
 	s PerExamineOpinion=a.PerExamineOpinion
 	s PerExamineUnit=a.PerExamineUnit
 	s PerExaminePerson=a.PerExaminePerson
 	s PerExamineScore=a.PerExamineScore
 	s PerFlag=a.PerFlag
 	s raw=$tr(rw,"||","__")
 	s ret="PerID|"_PerID_"^PerName|"_PerName_"^PerExamineDate|"_PerExamineDate_"^PerExamineType|"_PerExamineType_"^PerExamineContent|"_PerExamineContent_"^PerExamineResult|"_PerExamineResult_"^PerExamineOpinion|"_PerExamineOpinion_"^PerExamineUnit|"_PerExamineUnit_"^PerExaminePerson|"_PerExaminePerson_"^PerExamineScore|"_PerExamineScore_"^raw|"_raw_"^PerFlag|"_PerFlag
	s ret=ret
	d OutRowtyp
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK 
  
OutRowtyp
	set Data=$lb(ret)
	Set ^CacheTemp(repid,ind)=Data
 	
 	Set ind=ind+1
	quit
}

ClassMethod FindPersonExamineFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPersonExamineExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindPersonExamineClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPersonExamineExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

/// 查询休假信息
Query FindPersonVacation(parrn As %String, rowid As %String, typ As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindPersonVacationExecute(ByRef qHandle As %Binary, parrn As %String, rowid As %String, typ As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s ret=""
 	s parrn=$ZConvert(parrn,"U")
 	i typ="Complete"
 	{
	 	s id="" f  s id=$O(^DHCMGNUR.MgNurHolidayI("PerID"," "_parrn,id)) q:id=""  d
 		.s rmw="" f  s rmw=$O(^DHCMGNUR.MgNurHolidayI("PerID"," "_parrn,id,rmw)) q:rmw=""  d
 		..s rw=id_"||"_rmw
 		..d outdata(rw)
 	}
 	i typ="Verify"
 	{
	 	s id="" f  s id=$O(^DHCMGNUR.MgNurHolidayI("PerFlag"," 1"," "_parrn,id)) q:id=""  d
	 	.s rmw="" f  s rmw=$O(^DHCMGNUR.MgNurHolidayI("PerFlag"," 1"," "_parrn,id,rmw)) q:rmw=""  d
	 	..s rw=id_"||"_rmw
	 	..d outdata(rw)
 	}
 	i typ="unVerify"
 	{
	 	s id="" f  s id=$O(^DHCMGNUR.MgNurHolidayI("PerFlag"," 0"," "_parrn,id)) q:id=""  d
	 	.s rmw="" f  s rmw=$O(^DHCMGNUR.MgNurHolidayI("PerFlag"," 0"," "_parrn,id,rmw)) q:rmw=""  d
	 	..s rw=id_"||"_rmw
	 	..d outdata(rw)
 	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
outdata(rw)
	s dateFlag=##class(websys.Conversions).DateFormat()
	s a=##class(DHCMGNUR.MgNurHoliday).%OpenId(rw)
 	s PerID=a.PerID
 	s PerName=a.PerName
 	s PerWard=a.PerWard   //$p(^CTLOC(a.PerWard),"^",2)
 	i a.PerVacationStDate'="" d
 	.i ((dateFlag=3)!(dateFlag=4)) s PerVacationStDate=##class(web.DHCMgNurPerHRComm).getDateFormat(a.PerVacationStDate)
 	.e  s PerVacationStDate=""
 	e  s PerVacationStDate=""
 	i a.PerVacationEndDate'="" d
 	.i ((dateFlag=3)!(dateFlag=4)) s PerVacationEndDate=##class(web.DHCMgNurPerHRComm).getDateFormat(a.PerVacationEndDate)
 	.e  s PerVacationEndDate=""
 	e  s PerVacationEndDate=""
 	s PerVacationType=a.PerVacationType.Code
 	s PerVacationDay=a.PerVacationDay
 	s PerVacationReason=a.PerVacationReason
 	s PerFlag=a.PerFlag
 	s raw=$tr(rw,"||","__")
 	s ret="PerID|"_PerID_"^PerName|"_PerName_"^PerWard|"_PerWard_"^PerVacationStDate|"_PerVacationStDate_"^PerVacationEndDate|"_PerVacationEndDate_"^PerVacationType|"_PerVacationType_"^PerVacationDay|"_PerVacationDay_"^PerVacationReason|"_PerVacationReason_"^raw|"_raw_"^PerFlag|"_PerFlag
	s ret=ret
	d OutRowtyp 
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK 

OutRowtyp
	set Data=$lb(ret)
	Set ^CacheTemp(repid,ind)=Data
 	
 	Set ind=ind+1
	quit
}

ClassMethod FindPersonVacationFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPersonVacationExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindPersonVacationClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPersonVacationExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

/// 查询休假类别
Query FindVacType(typ As %String = "") As %Query(ROWSPEC = "vactype,raw")
{
}

ClassMethod FindVacTypeExecute(ByRef qHandle As %Binary, typ As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s tp="" f  s tp=$O(^DHCMGNUR.CommDictionaryI("Code",tp)) q:tp=""  d
 	.q:(tp'=" 休假代码")
 	.s id="" f  s id=$O(^DHCMGNUR.CommDictionaryI("Code",tp,id)) q:id=""  d
 	..s tm="" f  s tm=$O(^DHCMGNUR.CommDictionarySubI("Code",tm)) q:tm=""  d
 	...s rw="" f  s rw=$O(^DHCMGNUR.CommDictionarySubI("Code",tm,id,rw)) q:rw=""  d
 	....s raw=id_"||"_rw
 	....s a=##class(DHCMGNUR.CommDictionarySub).%OpenId(raw)
 	....s vactype=a.Code
    ....d OutputRow8
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(vactype,raw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindVacTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindVacTypeExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindVacTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindVacTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 查询调科记录
Query FindPersonTransDep(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindPersonTransDepExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s ^TEMP("p1703011717001")=parr
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s dateFlag=##class(websys.Conversions).DateFormat()
 	s ret=""
 	s parr=$ZConvert(parr,"U")
 	s rw="" f  s rw=$O(^DHCMGNUR.MgNurTransDepI("PerID"," "_parr,rw)) q:rw=""  d
 	.s a=##class(DHCMGNUR.MgNurTransDep).%OpenId(rw)
 	.s PerName=a.PerName
 	.s PerID=a.PerID
 	.i $G(^CTLOC(a.PerDepart))'="" s PerDepart=$p(^CTLOC(a.PerDepart),"^",2)
	.e  d
	..s perWardRw=$O(^DHCMGNUR.MgNurPerWardI("WardLoc",a.PerDepart,""))
	..i perWardRw'="" d
	...s perWardObj=##class(DHCMGNUR.MgNurPerWard).%OpenId(perWardRw)
	...s PerDepart=perWardObj.WardDesc
	..e  s PerDepart=""
	.i a.PerTranStDate'="" d
	..i ((dateFlag=3)!(dateFlag=4)) s PerTranStDate=##class(web.DHCMgNurPerHRComm).getDateFormat(a.PerTranStDate)
	..e  s PerTranStDate=""
 	.e  s PerTranStDate=""
 	.s PerTranStTime=$P($ZT(a.PerTranStTime,1),":",1,2) //$ZT(a.PerTranStTime,1)
 	.i a.PerTranEndDate'="" d
 	..i ((dateFlag=3)!(dateFlag=4)) s PerTranEndDate=##class(web.DHCMgNurPerHRComm).getDateFormat(a.PerTranEndDate)
 	..e  s PerTranEndDate=""
 	.e  s PerTranEndDate=""
 	.i a.PerTranEndTime="" s PerTranEndTime="" 
 	.e  s PerTranEndTime=$P($ZT(a.PerTranEndTime,1),":",1,2)    //$ZT(a.PerTranEndTime,1)
 	.s PerTranCurrent=a.PerTranCurrent
 	.s PerTranMem=a.PerTranMem
 	.s ret="PerID"_"|"_PerID_"^"_"PerName"_"|"_PerName_"^"_"PerDepart"_"|"_PerDepart_"^"_"PerTranStDate"_"|"_PerTranStDate_"^"_"PerTranStTime"_"|"_PerTranStTime_"^"_"PerTranEndDate"_"|"_PerTranEndDate_"^"_"PerTranEndTime"_"|"_PerTranEndTime_"^"_"PerTranCurrent"_"|"_PerTranCurrent_"^"_"PerTranMem"_"|"_PerTranMem_"^"_"rw|"_rw
	.s ret=ret
	.d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(ret)
	Set ^CacheTemp(repid,ind)=Data 	
 	Set ind=ind+1
	quit
}

ClassMethod FindPersonTransDepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPersonTransDepExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindPersonTransDepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPersonTransDepExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetLoc1(ward As %String = "") As %String
{
	s ret2=""
	s ward=$TR($ZConvert(ward,"U")," ","")
 	s ty="" f  s ty=$O(^DHCMGNUR.MgNurWardI("Typ",1,ty)) q:ty=""  d
 	.q:ty'=" WARD"
    .s loc="" f  s loc=$O(^DHCMGNUR.MgNurWardI("Typ",1,ty,loc)) q:loc=""  d
    ..s rw="" f  s rw=$O(^DHCMGNUR.MgNurWardI("Typ",1,ty,loc,rw)) q:rw=""  d
    ...s a=##class(DHCMGNUR.MgNurWard).%OpenId(rw)
    ...s CtLocDr=a.WardLoc         
    ...s p=a.SortPos
    ...s ctlocDesc=$p(^CTLOC(CtLocDr),"^",2)
    ...q:(ctlocDesc']ward)&&(ward'="")
    ...s ret2=ret2_ctlocDesc_"|"_CtLocDr_"^"
   q ret2
}

/// 查询行政职务子集
Query FindPersonChiefPosition(parrm As %String, rowid As %String, typ As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindPersonChiefPositionExecute(ByRef qHandle As %Binary, parrm As %String, rowid As %String, typ As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s ret=""
 	s parrm=$ZConvert(parrm,"U")
 	i typ="Complete"
 	{
	 	s id="" f  s id=$O(^DHCMGNUR.MgNurChiefPositionI("PerID"," "_parrm,id)) q:id=""  d
 		.s rmw="" f  s rmw=$O(^DHCMGNUR.MgNurChiefPositionI("PerID"," "_parrm,id,rmw)) q:rmw=""  d
 		..s rw=id_"||"_rmw
 		..d outdata(rw)	
 	}
 	i typ="Verify"
 	{
	 	s id="" f  s id=$O(^DHCMGNUR.MgNurChiefPositionI("PerFlag"," 1"," "_parrm,id)) q:id=""  d
	 	.s rmw="" f  s rmw=$O(^DHCMGNUR.MgNurChiefPositionI("PerFlag"," 1"," "_parrm,id,rmw)) q:rmw=""  d
	 	..s rw=id_"||"_rmw
	 	..d outdata(rw)	 	
 	}
 	i typ="unVerify"
 	{
	 	s id="" f  s id=$O(^DHCMGNUR.MgNurChiefPositionI("PerFlag"," 0"," "_parrm,id)) q:id=""  d
	 	.s rmw="" f  s rmw=$O(^DHCMGNUR.MgNurChiefPositionI("PerFlag"," 0"," "_parrm,id,rmw)) q:rmw=""  d
	 	..s rw=id_"||"_rmw
	 	..d outdata(rw)
 	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

outdata(rw)
	s dateFlag=##class(websys.Conversions).DateFormat()
	s a=##class(DHCMGNUR.MgNurChiefPosition).%OpenId(rw)
 	s PerID=a.PerID
 	s PerName=a.PerName
 	s PerDutyName=a.PerDutyName.Code
 	i a.PerPromoteDate'="" d
 	.i ((dateFlag=3)!(dateFlag=4)) s PerPromoteDate=##class(web.DHCMgNurPerHRComm).getDateFormat(a.PerPromoteDate)
 	.e  s PerPromoteDate=""
 	e  s PerPromoteDate=""
 	s PerWorkUnit=a.PerWorkUnit
 	s PerFlag=a.PerFlag
 	s raw=$tr(rw,"||","__")
 	s ret="PerID|"_PerID_"^PerName|"_PerName_"^PerDutyName|"_PerDutyName_"^PerPromoteDate|"_PerPromoteDate_"^PerWorkUnit|"_PerWorkUnit_"^raw|"_raw_"^PerFlag|"_PerFlag
	s ret=ret
	d OutRowtyp
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK 

OutRowtyp
	set Data=$lb(ret)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindPersonChiefPositionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPersonChiefPositionExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindPersonChiefPositionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPersonChiefPositionExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

/// 查询专业技术职务子集
Query FindPersonProTechPos(parrm As %String, rowid As %String, typ As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindPersonProTechPosExecute(ByRef qHandle As %Binary, parrm As %String, rowid As %String, typ As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s ret=""
 	s parrm=$ZConvert(parrm,"U")
 	i typ="Complete"
 	{
	 	s id="" f  s id=$O(^DHCMGNUR.MgNurProTechPositionI("PerID"," "_parrm,id)) q:id=""  d
 		.s rmw="" f  s rmw=$O(^DHCMGNUR.MgNurProTechPositionI("PerID"," "_parrm,id,rmw)) q:rmw=""  d
 		..s rw=id_"||"_rmw
 		..d outdata(rw)
 	}
 	i typ="Verify"
 	{
	 	s id="" f  s id=$O(^DHCMGNUR.MgNurProTechPositionI("PerFlag"," 1"," "_parrm,id)) q:id=""  d
	 	.s rmw="" f  s rmw=$O(^DHCMGNUR.MgNurProTechPositionI("PerFlag"," 1"," "_parrm,id,rmw)) q:rmw=""  d
	 	..s rw=id_"||"_rmw
	 	..d outdata(rw)	
 	}
 	i typ="unVerify"
 	{
	 	s id="" f  s id=$O(^DHCMGNUR.MgNurProTechPositionI("PerFlag"," 0"," "_parrm,id)) q:id=""  d
	 	.s rmw="" f  s rmw=$O(^DHCMGNUR.MgNurProTechPositionI("PerFlag"," 0"," "_parrm,id,rmw)) q:rmw=""  d
	 	..s rw=id_"||"_rmw
	 	..d outdata(rw)	
 	}   
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
outdata(rw)
	s dateFlag=##class(websys.Conversions).DateFormat()
	s a=##class(DHCMGNUR.MgNurProTechPosition).%OpenId(rw)
 	s PerID=a.PerID
 	s PerName=a.PerName
 	s PerProfQualName=a.PerProfQualName.Code
 	s PerAppProfQualPosName=a.PerAppProfQualPosName.Code
 	i a.PerOccuQual="1" s PerOccuQual="是"
 	e  i a.PerOccuQual="0" s PerOccuQual="否"
 	e  s PerOccuQual=""
 	i a.PerAppStartDate'="" d
 	.i ((dateFlag=3)!(dateFlag=4)) s PerAppStartDate=##class(web.DHCMgNurPerHRComm).getDateFormat(a.PerAppStartDate)
 	.e  s PerAppStartDate=""
 	e  s PerAppStartDate=""
 	i a.PerAppEndDate'="" d
 	.i ((dateFlag=3)!(dateFlag=4)) s PerAppEndDate=##class(web.DHCMgNurPerHRComm).getDateFormat(a.PerAppEndDate)
 	.e  s PerAppEndDate=""
 	e  s PerAppEndDate=""
 	i a.PerAppExamRersult="1" s PerAppExamRersult="合格"
 	e  i a.PerAppExamRersult="0"  s PerAppExamRersult="不合格"
 	e  s PerAppExamRersult=""
 	s PerFlag=a.PerFlag
 	s raw=$tr(rw,"||","__")
	s ret="PerID|"_PerID_"^PerName|"_PerName_"^PerProfQualName|"_PerProfQualName_"^PerAppProfQualPosName|"_PerAppProfQualPosName_"^PerOccuQual|"_PerOccuQual_"^PerAppStartDate|"_PerAppStartDate_"^PerAppEndDate|"_PerAppEndDate_"^PerAppExamRersult|"_PerAppExamRersult_"^raw|"_raw_"^PerFlag|"_PerFlag
	s ret=ret
	d OutRowtyp
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutRowtyp
	set Data=$lb(ret)
	Set ^CacheTemp(repid,ind)=Data
 	
 	Set ind=ind+1
	quit
}

ClassMethod FindPersonProTechPosFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPersonProTechPosExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindPersonProTechPosClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPersonProTechPosExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

/// 查询护士层级
Query FindPersonNurseLevel(parr As %String, rowid As %String, typ As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindPersonNurseLevelExecute(ByRef qHandle As %Binary, parr As %String, rowid As %String, typ As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s ret=""
 	s parr=$ZConvert(parr,"U")
 	i typ="Complete"
 	{
 		s id="" f  s id=$O(^DHCMGNUR.MgNurNurseLevelI("PerID"," "_parr,id)) q:id=""  d
 		.s rmw="" f  s rmw=$O(^DHCMGNUR.MgNurNurseLevelI("PerID"," "_parr,id,rmw)) q:rmw=""  d
 		..s rw=id_"||"_rmw
 		..d outdata(rw)
 	}
 	i typ="Verify"
 	{
	 	s id="" f  s id=$O(^DHCMGNUR.MgNurNurseLevelI("PerFlag"," 1"," "_parr,id)) q:id=""  d
	 	.s rmw="" f  s rmw=$O(^DHCMGNUR.MgNurNurseLevelI("PerFlag"," 1"," "_parr,id,rmw)) q:rmw=""  d
	 	..s rw=id_"||"_rmw
	 	..d outdata(rw)
 	}
 	i typ="unVerify"
 	{
	 	s id="" f  s id=$O(^DHCMGNUR.MgNurNurseLevelI("PerFlag"," 0"," "_parr,id)) q:id=""  d
	 	.s rmw="" f  s rmw=$O(^DHCMGNUR.MgNurNurseLevelI("PerFlag"," 0"," "_parr,id,rmw)) q:rmw=""  d
	 	..s rw=id_"||"_rmw
	 	..d outdata(rw)
 	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
outdata(rw)
	s dateFlag=##class(websys.Conversions).DateFormat()
	s a=##class(DHCMGNUR.MgNurNurseLevel).%OpenId(rw)
 	s PerID=a.PerID
 	s PerName=a.PerName
 	s PerLevel=a.PerLevel.Code
 	i a.PerPromoDate'="" d
 	.i ((dateFlag=3)!(dateFlag=4)) s PerPromoDate=##class(web.DHCMgNurPerHRComm).getDateFormat(a.PerPromoDate)
 	.e  s PerPromoDate=""
 	e  s PerPromoDate=""
 	s PerFlag=a.PerFlag
 	s raw=$tr(rw,"||","__")
 	s ret="PerID|"_PerID_"^PerName|"_PerName_"^PerLevel|"_PerLevel_"^PerPromoDate|"_PerPromoDate_"^raw|"_raw_"^PerFlag|"_PerFlag
	s ret=ret
	d OutRowtyp
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutRowtyp
	set Data=$lb(ret)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindPersonNurseLevelFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPersonNurseLevelExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindPersonNurseLevelClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPersonNurseLevelExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

/// 查询护士科室工作
Query FindPersonDepartWork(parrm As %String, rowid As %String, typ As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindPersonDepartWorkExecute(ByRef qHandle As %Binary, parrm As %String, rowid As %String, typ As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s ret=""
 	s parrm=$ZConvert(parrm,"U")
 	i typ="Complete"
 	{
 		s id="" f  s id=$O(^DHCMGNUR.MgNurDepartmentWorkI("PerID"," "_parrm,id)) q:id=""  d
 		.s rmw="" f  s rmw=$O(^DHCMGNUR.MgNurDepartmentWorkI("PerID"," "_parrm,id,rmw)) q:rmw=""  d
 		..s rw=id_"||"_rmw
 		..d outdata(rw)
 	}
 	i typ="Verify"
 	{
	 	s id="" f  s id=$O(^DHCMGNUR.MgNurDepartmentWorkI("PerFlag"," 1"," "_parrm,id)) q:id=""  d
	 	.s rmw="" f  s rmw=$O(^DHCMGNUR.MgNurDepartmentWorkI("PerFlag"," 1"," "_parrm,id,rmw)) q:rmw=""  d
	 	..s rw=id_"||"_rmw
	 	..d outdata(rw)
 	}
 	i typ="unVerify"
 	{
	 	s id="" f  s id=$O(^DHCMGNUR.MgNurDepartmentWorkI("PerFlag"," 0"," "_parrm,id)) q:id=""  d
	 	.s rmw="" f  s rmw=$O(^DHCMGNUR.MgNurDepartmentWorkI("PerFlag"," 0"," "_parrm,id,rmw)) q:rmw=""  d
	 	..s rw=id_"||"_rmw
	 	..d outdata(rw)
 	} 
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outdata(rw)
	s dateFlag=##class(websys.Conversions).DateFormat()
	s a=##class(DHCMGNUR.MgNurDepartmentWork).%OpenId(rw)
	s PerID=a.PerID
 	s PerName=a.PerName
 	i a.PerDate'="" d
 	.i ((dateFlag=3)!(dateFlag=4)) s PerDate=##class(web.DHCMgNurPerHRComm).getDateFormat(a.PerDate)
 	.e  s PerDate=""
 	e  s PerDate=""
 	i a.PerInternTeacher="1" s PerInternTeacher="√"
 	e  s PerInternTeacher=""
 	i a.PerInstructor="1" s PerInstructor="√"
 	e  s PerInstructor=""
 	i a.PerHeadInstructor="1" s PerHeadInstructor="√"
 	e  s PerHeadInstructor=""
 	i a.PerQualCtrNurse="1" s PerQualCtrNurse="√"
 	e  s PerQualCtrNurse=""
 	i a.PerMoniNurse="1" s PerMoniNurse="√"
 	e  s PerMoniNurse=""
 	i a.PerFireNurse="1" s PerFireNurse="√"
 	e  s PerFireNurse=""
 	i a.PerDeviceNurse="1" s PerDeviceNurse="√"
 	e  s PerDeviceNurse=""
 	i a.PerTotTeacher="1" s PerTotTeacher="√"
 	e  s PerTotTeacher=""
 	s PerFlag=a.PerFlag
 	s raw=$tr(rw,"||","__")
 	s ret="PerID|"_PerID_"^PerName|"_PerName_"^PerDate|"_PerDate_"^PerInternTeacher|"_PerInternTeacher_"^PerInstructor|"_PerInstructor_"^PerHeadInstructor|"_PerHeadInstructor_"^PerQualCtrNurse|"_PerQualCtrNurse_"^PerMoniNurse|"_PerMoniNurse_"^PerFireNurse|"_PerFireNurse_"^PerDeviceNurse|"_PerDeviceNurse_"^PerTotTeacher|"_PerTotTeacher_"^PerFlag|"_PerFlag_"^raw|"_raw
	s ret=ret
	d OutRowtyp
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRowtyp
	set Data=$lb(ret)
	Set ^CacheTemp(repid,ind)=Data
 	
 	Set ind=ind+1
	quit
}

ClassMethod FindPersonDepartWorkFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPersonDepartWorkExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindPersonDepartWorkClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPersonDepartWorkExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 专业技术资格名称
Query FindPersonProfQualName(typ As %String = "") As %Query(ROWSPEC = "ProfQualName,raw")
{
}

ClassMethod FindPersonProfQualNameExecute(ByRef qHandle As %Binary, typ As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s tp="" f  s tp=$O(^DHCMGNUR.CommDictionaryI("Code",tp)) q:tp=""  d
 	.q:(tp'=" 专业技术资格名称")
 	.s id="" f  s id=$O(^DHCMGNUR.CommDictionaryI("Code",tp,id)) q:id=""  d
 	..s tm="" f  s tm=$O(^DHCMGNUR.CommDictionarySubI("Code",tm)) q:tm=""  d
 	...s rw="" f  s rw=$O(^DHCMGNUR.CommDictionarySubI("Code",tm,id,rw)) q:rw=""  d
 	....s raw=id_"||"_rw
 	....s a=##class(DHCMGNUR.CommDictionarySub).%OpenId(raw)
 	....s ProfQualName=a.Code
    ....d OutputRow8
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(ProfQualName,raw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindPersonProfQualNameFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPersonProfQualNameExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindPersonProfQualNameClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPersonProfQualNameExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 聘任专业技术职务名称
Query FindPersonProfQualPos(typ As %String = "") As %Query(ROWSPEC = "ProfQualPosName,raw")
{
}

ClassMethod FindPersonProfQualPosExecute(ByRef qHandle As %Binary, typ As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s tp="" f  s tp=$O(^DHCMGNUR.CommDictionaryI("Code",tp)) q:tp=""  d
 	.q:(tp'=" 聘任专业技术职称")
 	.s id="" f  s id=$O(^DHCMGNUR.CommDictionaryI("Code",tp,id)) q:id=""  d
 	..s tm="" f  s tm=$O(^DHCMGNUR.CommDictionarySubI("Code",tm)) q:tm=""  d
 	...s rw="" f  s rw=$O(^DHCMGNUR.CommDictionarySubI("Code",tm,id,rw)) q:rw=""  d
 	....s raw=id_"||"_rw
 	....s a=##class(DHCMGNUR.CommDictionarySub).%OpenId(raw)
 	....s ProfQualPosName=a.Code
    ....d OutputRow8
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(ProfQualPosName,raw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindPersonProfQualPosFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPersonProfQualPosExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindPersonProfQualPosClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPersonProfQualPosExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 查询个人事件
Query FindPersonPerEvent(parr As %String, rowid As %String, typ As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindPersonPerEventExecute(ByRef qHandle As %Binary, parr As %String, rowid As %String, typ As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s ret=""
 	s parrn=$ZConvert(parr,"U")
 	i typ="Complete"
 	{
	 	s id="" f  s id=$O(^DHCMGNUR.MgNurPersonalEventI("PerID"," "_parr,id)) q:id=""  d
 		.s rmw="" f  s rmw=$O(^DHCMGNUR.MgNurPersonalEventI("PerID"," "_parr,id,rmw)) q:rmw=""  d
 		..s rw=id_"||"_rmw
 		..d outdata(rw)
 	}
 	i typ="Verify"
 	{
	 	s id="" f  s id=$O(^DHCMGNUR.MgNurPersonalEventI("PerFlag"," 1"," "_parr,id)) q:id=""  d
	 	.s rmw="" f  s rmw=$O(^DHCMGNUR.MgNurPersonalEventI("PerFlag"," 1"," "_parr,id,rmw)) q:rmw=""  d
	 	..s rw=id_"||"_rmw
	 	..d outdata(rw)
 	}
 	i typ="unVerify"
 	{
	 	s id="" f  s id=$O(^DHCMGNUR.MgNurPersonalEventI("PerFlag"," 0"," "_parr,id)) q:id=""  d
	 	.s rmw="" f  s rmw=$O(^DHCMGNUR.MgNurPersonalEventI("PerFlag"," 0"," "_parr,id,rmw)) q:rmw=""  d
	 	..s rw=id_"||"_rmw
	 	..d outdata(rw)
 	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
outdata(rw)
	s dateFlag=##class(websys.Conversions).DateFormat()
	s a=##class(DHCMGNUR.MgNurPersonalEvent).%OpenId(rw)
	s PerID=a.PerID
 	s PerName=a.PerName
 	i a.PerStDate'="" d
 	.i ((dateFlag=3)!(dateFlag=4)) s PerStDate=##class(web.DHCMgNurPerHRComm).getDateFormat(a.PerStDate)
 	.e  s PerStDate=""
 	e  s PerStDate=""
 	i a.PerEndDate'="" d
 	.i ((dateFlag=3)!(dateFlag=4)) s PerEndDate=##class(web.DHCMgNurPerHRComm).getDateFormat(a.PerEndDate)
 	.e  s PerEndDate=""
 	e  s PerEndDate=""
 	s PerPrimaryEvent=a.PerPrimaryEvent
  	s PerFlag=a.PerFlag
 	s raw=$tr(rw,"||","__")
 	s ret="PerID|"_PerID_"^PerName|"_PerName_"^PerStDate|"_PerStDate_"^PerEndDate|"_PerEndDate_"^PerPrimaryEvent|"_PerPrimaryEvent_"^raw|"_raw_"^PerFlag|"_PerFlag
	s ret=ret
	d OutRowtyp
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRowtyp
	set Data=$lb(ret)
	Set ^CacheTemp(repid,ind)=Data
 	
 	Set ind=ind+1
	quit
}

ClassMethod FindPersonPerEventFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPersonPerEventExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindPersonPerEventClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPersonPerEventExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

/// 
/// 人力资源护理单元维护 
Query MaintainPerWard() As %Query(ROWSPEC = "PerDepDR,rw,WardOrd")
{
}

ClassMethod MaintainPerWardExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s ord="" f  s ord=$O(^DHCMGNUR.MgNurPerWardI("WardOrd",ord)) q:ord=""  d
 	.s id="" f  s id=$O(^DHCMGNUR.MgNurPerWardI("WardOrd",ord,id)) q:id=""  d
 	..s a=##class(DHCMGNUR.MgNurPerWard).%OpenId(id)
 	..i ((a.WardLoc'="")&((a.WardLoc'="9999")&(a.WardLoc'="9998")&(a.WardLoc'="9997"))) s PerDepDR=$P(^CTLOC(a.WardLoc),"^",2)
 	..i a.WardLoc="9999" s PerDepDR="待分区(不做统计)"
	..i a.WardLoc="9998" s PerDepDR="退休区(不做统计)"
	..i a.WardLoc="9997" s PerDepDR="离职区(不做统计)"
 	..s WardOrd=a.WardOrd
 	..s rw=a.WardLoc
 	..d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(PerDepDR,rw,WardOrd)
	Set ^CacheTemp(repid,ind)=Data
 	
 	Set ind=ind+1
	quit
}

ClassMethod MaintainPerWardFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MaintainPerWardExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod MaintainPerWardClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MaintainPerWardExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

/// 
/// HIS病区查询 
Query FindWardItem(ward = "") As %Query(ROWSPEC = "LocDes,LocDr")
{
}

ClassMethod FindWardItemExecute(ByRef qHandle As %Binary, ward = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	i ward=""
 	{
 		s CtLocDr="" f  s CtLocDr=$O(^CTLOC(0,"Code",CtLocDr)) q:CtLocDr=""  d
 		.s id="" f  s id=$O(^CTLOC(0,"Code",CtLocDr,id)) q:id=""  d
 		..s ctlocDesc=$p(^CTLOC(id),"^",2)
 		..q:(ctlocDesc'[ward)&&(ward'="")
 		..d OutputRow8
 	}
 	i ward'=""
	{
		s CtLocDr=ward
 		s ctlocDesc=$p(^CTLOC(ward),"^",2)
 		s id=ward
 		d OutputRow8
	}
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(ctlocDesc,id)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindWardItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWardItemExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindWardItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWardItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 
/// HIS Combobox下拉框 
Query FindWardCode(wardid = "") As %Query(ROWSPEC = "LocDes,LocDr")
{
}

ClassMethod FindWardCodeExecute(ByRef qHandle As %Binary, wardid = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s wardid=$ZConvert(wardid,"U")
	s CtLocDr="" f  s CtLocDr=$O(^CTLOC(0,"Code",CtLocDr)) q:CtLocDr=""  d
 	.s id="" f  s id=$O(^CTLOC(0,"Code",CtLocDr,id)) q:id=""  d
 	..s ctlocDesc=$p(^CTLOC(id),"^",2)
 	..q:(ctlocDesc'[wardid)&&(wardid'="")
 	..d OutputRow8
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(ctlocDesc,id)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindWardCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWardCodeExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindWardCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWardCodeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 
/// 护理单元查询 
Query SearchPerWard(typ, ward = "") As %Query(ROWSPEC = "ctlocDesc,CtLocDr")
{
}

ClassMethod SearchPerWardExecute(ByRef qHandle As %Binary, typ, ward = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1 
 	s ward=$TR($ZConvert(ward,"U")," ","")
 	s loc="" f  s loc=$O(^DHCMGNUR.MgNurPerWardI("WardLoc",loc)) q:loc=""  d
   	.s rw="" f  s rw=$O(^DHCMGNUR.MgNurPerWardI("WardLoc",loc,rw)) q:rw=""  d
    ..s a=##class(DHCMGNUR.MgNurPerWard).%OpenId(rw)
    ..s CtLocDr=a.WardLoc 
    ..s ctlocDesc=a.WardDesc 
    ..q:(ctlocDesc'[ward)&&(ward'="")
    ..d OutputRow8
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(ctlocDesc,CtLocDr)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod SearchPerWardFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchPerWardExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SearchPerWardClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchPerWardExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 
/// 首页页面护理单元下拉框   
Query SearchWardCode(ward = "") As %Query(ROWSPEC = "ctlocDesc,CtLocDr")
{
}

ClassMethod SearchWardCodeExecute(ByRef qHandle As %Binary, ward = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1 
 	s ward=$TR($ZConvert(ward,"U")," ","")
 	s ord="" f  s ord=$O(^DHCMGNUR.MgNurPerWardI("WardRow",ord)) q:ord=""  d
 	.s loc="" f  s loc=$O(^DHCMGNUR.MgNurPerWardI("WardRow",ord,loc)) q:loc=""  d
 	..s rw="" f  s rw=$O(^DHCMGNUR.MgNurPerWardI("WardRow",ord,loc,rw)) q:rw=""  d
 	...s a=##class(DHCMGNUR.MgNurPerWard).%OpenId(rw)
    ...s CtLocDr=a.WardLoc
    ...s ctlocDesc=$p($g(^CTLOC(CtLocDr)),"^",2) 
    ...i ctlocDesc="" s ctlocDesc=a.WardDesc 
    ...q:(ctlocDesc'[ward)&&(ward'="")   
    ...d OutputRow8
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(ctlocDesc,CtLocDr)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod SearchWardCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchWardCodeExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SearchWardCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchWardCodeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 
/// 查询护理单元  
Query SearchComboDep(ward1 = "", nurseid) As %Query(ROWSPEC = "ctlocDesc,CtLocDr")
{
}

ClassMethod SearchComboDepExecute(ByRef qHandle As %Binary, ward1 = "", nurseid As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1 
 	s ^TEMP("JYC111")=nurseid
 	s ward1=$TR($ZConvert(ward1,"U")," ","")
 	s nurseNO=$P(nurseid,"^",1)
 	s nurseGroup=$P(nurseid,"^",2)
 	s larLoc=$ZConvert($P(nurseid,"^",3),"U")
 	if ((nurseGroup="hlb")!(nurseGroup="demo")!(nurseGroup="hlbzr"))
 	{
	 	i larLoc'=""
	 	{
		 	s loc="" f  s loc=$O(^DHCMGNUR.MgNurMaCareUnitI("Typ"," "_larLoc,loc)) q:loc=""  d
	 		.s rw="" f  s rw=$O(^DHCMGNUR.MgNurMaCareUnitI("Typ"," "_larLoc,loc,rw)) q:rw=""  d
	 		..s locObj=##class(DHCMGNUR.MgNurMaCareUnit).%OpenId(rw)
	 		..s CtLocDr=locObj.WardLoc
	 		..s ctlocDesc=$P(^CTLOC(locObj.WardLoc),"^",2)
	 		..d OutputRow8
	 	}
	 	else
	 	{
	 		s indexNo="" f  s indexNo=$O(^DHCMGNUR.MgNurPerWardI("WardOrd",indexNo)) q:indexNo=""  d
	 		.s id="" f  s id=$O(^DHCMGNUR.MgNurPerWardI("WardOrd",indexNo,id)) q:id=""  d
	 		..s a=##class(DHCMGNUR.MgNurPerWard).%OpenId(id)	 	
	 		..s CtLocDr=a.WardLoc
	 		..i ((CtLocDr'="9999")&(CtLocDr'="9997")&(CtLocDr'="9998"))  s ctlocDesc=$p(^CTLOC(CtLocDr),"^",2)
	 		..i CtLocDr="9999" s ctlocDesc="待分区(不做统计)"
	 		..i CtLocDr="9998" s ctlocDesc="退休区(不做统计)"
	 		..i CtLocDr="9997" s ctlocDesc="离职区(不做统计)"
	 		..q:(ctlocDesc'[ward1)&&(ward1'="")
	 		..d OutputRow8
	 	}
 	}
 	elseif(nurseGroup="znurhead")
 	{
	 	s larLoc="" f  s larLoc=$O(^DHCMGNUR.DHCMgNurLarNurForLocI("Typ"," "_nurseNO,larLoc)) q:larLoc=""  d
	 	.s loc="" f  s loc=$O(^DHCMGNUR.MgNurMaCareUnitI("Typ",larLoc,loc)) q:loc=""  d
	 	..s id="" f  s id=$O(^DHCMGNUR.MgNurMaCareUnitI("Typ",larLoc,loc,id)) q:id=""  d
	 	...s a=##class(DHCMGNUR.MgNurMaCareUnit).%OpenId(id)
	 	...s CtLocDr=a.WardLoc
	 	...s ctlocDesc=$p(^CTLOC(CtLocDr),"^",2)
	 	...q:(ctlocDesc'[ward1)&&(ward1'="")
	 	...d OutputRow8
 	}
 	elseif(nurseGroup="nurhead")
 	{
	 	;s raw=$O(^DHCMGNUR.MgNurseI("Nurse",nurseNO," NUR",""))
	 	;i raw'="" d
	 	;.s rw="" f  s rw=$O(^DHCMGNUR.MgNurseD(raw,"ChildSub",rw)) q:rw=""  d
	 	;..s a=##class(DHCMGNUR.MgNurseSub).%OpenId(raw_"||"_rw)
	 	;..s CtLocDr=a.WardLoc
	 	;..s ctlocDesc=$p(^CTLOC(CtLocDr),"^",2)
	 	;..d OutputRow8
	 	;e  d
	 	s perNurseId=$P(^SSU("SSUSR",nurseNO),"^",1)
	 	s perNurseId=$ZConvert(perNurseId,"U")
	 	s id="" f  s id=$O(^DHCMGNUR.MgPersonsI("SSID"," "_perNurseId,id)) q:id=""  d
	 	.s a=##class(DHCMGNUR.MgPersons).%OpenId(id)
	 	.b ;22
	 	.s CtLocDr=a.PersonDepDR
	 	.s ctlocDesc=$p(^CTLOC(CtLocDr),"^",2)
	 	.d OutputRow8
 	}
 	else
 	{
	 	s perNurseId=$P(^SSU("SSUSR",nurseNO),"^",1)
	 	s id="" f  s id=$O(^DHCMGNUR.MgPersonsI("SSID"," "_$ZConvert(perNurseId,"U"),id)) q:id=""  d
	 	.s a=##class(DHCMGNUR.MgPersons).%OpenId(id)
	 	.s CtLocDr=a.PersonDepDR
	 	.s ctlocDesc=$p(^CTLOC(CtLocDr),"^",2)
	 	.d OutputRow8
 	}
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow8
	set Data=$lb(ctlocDesc,CtLocDr)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod SearchComboDepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchComboDepExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SearchComboDepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchComboDepExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 
/// Method Description:按照登录人员的级别查询护理单元(分三层次管理)
/// Date:2014-11-14
Query HieQueryComboDep(ward1 = "", nurseid) As %Query(ROWSPEC = "ctlocDesc,CtLocDr")
{
}

ClassMethod HieQueryComboDepExecute(ByRef qHandle As %Binary, ward1 = "", nurseid As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1 
 	s ward1=$TR($ZConvert(ward1,"U")," ","")
 	s nurseNO=$P(nurseid,"^",1)
 	s nurseGroup=$P(nurseid,"^",2)
 	if ((nurseGroup="护理部主任")!(nurseGroup="Demo Group"))
 	{
	 	s indexNo="" f  s indexNo=$O(^DHCMGNUR.MgNurPerWardI("WardOrd",indexNo)) q:indexNo=""  d
	 	.s id="" f  s id=$O(^DHCMGNUR.MgNurPerWardI("WardOrd",indexNo,id)) q:id=""  d
	 	..s a=##class(DHCMGNUR.MgNurPerWard).%OpenId(id)	 	
	 	..s CtLocDr=a.WardLoc
	 	..i ((CtLocDr'="9999")&(CtLocDr'="9997")&(CtLocDr'="9998"))  s ctlocDesc=$p(^CTLOC(CtLocDr),"^",2)
	 	..i CtLocDr="9999" s ctlocDesc="待分区(不做统计)"
	 	..i CtLocDr="9998" s ctlocDesc="退休区(不做统计)"
	 	..i CtLocDr="9997" s ctlocDesc="离职区(不做统计)"
	 	..q:(ctlocDesc'[ward1)&&(ward1'="")
	 	..d OutputRow8
 	}
 	elseif (nurseGroup="总护士长")
 	{
	 	s par="" f  s par=$O(^DHCMGNUR.MgNurseI("Nurse",nurseNO," LOCNUR",par)) q:par=""  d
	 	.s raw="" f  s raw=$O(^DHCMGNUR.MgNurseD(par,"ChildSub",raw)) q:raw=""  d
	 	..s a=##class(DHCMGNUR.MgNurseSub).%OpenId(par_"||"_raw)
	 	..s CtLocDr=a.WardLoc
	 	..s ctlocDesc=$p(^CTLOC(CtLocDr),"^",2)
	 	..d OutputRow8
 	}
 	else
 	{
	 	s perNurseId=$P(^SSU("SSUSR",nurseNO),"^",1)
	 	s id="" f  s id=$O(^DHCMGNUR.MgPersonsI("SSID"," "_perNurseId,id)) q:id=""  d
	 	.s a=##class(DHCMGNUR.MgPersons).%OpenId(id)
	 	.s CtLocDr=a.PersonDepDR
	 	.s ctlocDesc=$p(^CTLOC(CtLocDr),"^",2)
	 	.d OutputRow8
 	}
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(ctlocDesc,CtLocDr)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod HieQueryComboDepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = HieQueryComboDepExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod HieQueryComboDepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = HieQueryComboDepExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 
/// 护士信息综合查询
Query SelectNurse(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod SelectNurseExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
	s ret=""
 	s perDep=$P(parr,"^",1)
 	s perGroup=$P(parr,"^",2)
 	s perId=$ZConvert($P(parr,"^",3),"U")
 	i (perGroup["护理部主任")!(perGroup["Demo Group")
 	{
	 	i perDep=""
	 	{
		 	s row="" f  s row=$O(^DHCMGNUR.MgNurPerWardI("WardOrd",row)) q:row=""  d
		 	.s rowid="" f  s rowid=$O(^DHCMGNUR.MgNurPerWardI("WardOrd",row,rowid)) q:rowid=""  d
		 	..s aa=##class(DHCMGNUR.MgNurPerWard).%OpenId(rowid)
		 	..q:((aa.WardLoc="9999")!(aa.WardLoc="9998")!(aa.WardLoc="9997"))
		 	..s nurDep=aa.WardLoc
		 	..s id="" f  s id=$O(^DHCMGNUR.MgPersonsI("Dep"," "_nurDep,id)) q:id=""  d
		 	...s a=##class(DHCMGNUR.MgPersons).%OpenId(id)
		 	...s PersonName=a.PersonName
	 		...s PersonID=a.PersonID
	 		...s PersonDepDR=$P(^CTLOC(a.PersonDepDR),"^",2)
	 		...s ret="PersonName|"_PersonName_"^PersonID|"_PersonID_"^PersonDepDR|"_PersonDepDR_"^rw|"_id
	 		...s ret=ret 
	 		...d OutRowtyp
	 	}
	 	else
	 	{
			s perid="" f  s perid=$O(^DHCMGNUR.MgPersonsI("SSID",perid)) q:perid=""  d
	 		.s id="" f  s id=$O(^DHCMGNUR.MgPersonsI("SSID",perid,id)) q:id=""  d 
	 		..s a=##class(DHCMGNUR.MgPersons).%OpenId(id)
	 		..q:(perDep'="")&&(a.PersonDepDR'=perDep)
	 		..s PersonName=a.PersonName
	 		..s PersonID=a.PersonID
	 		..s PersonDepDR=$P(^CTLOC(a.PersonDepDR),"^",2)
	 		..s ret="PersonName|"_PersonName_"^PersonID|"_PersonID_"^PersonDepDR|"_PersonDepDR_"^rw|"_id
	 		..s ret=ret 
	 		..d OutRowtyp
	 	}
 	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(ret)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod SelectNurseFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectNurseExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SelectNurseClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectNurseExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

ClassMethod GetPerNurseInformation(checkid, pername, perid, w, h) As %String
{
	s ret="["
	s NurBaseInfor="基本信息"
	s sumecode="DHCNurPerBaseInfor"
	s url="dhcmgnurcomm.csp?EmrCode="_sumecode_"&RowId="_checkid_"&PerID="_perid
	s ret=ret_"{border: false,region: 'center', layout: 'fit', title: '"_NurBaseInfor_"',height:"_h_",width:"_w_",html:'<iframe id =""southTab1"" name=""ddd1"" style=""width:100%;height:100%""  src="""_url_""" ></iframe>'}"
	s ret=ret_","
	s NurSubsetInfor="子集信息"
	s sumecode="DHCNurPerTotalInformation"
	s url="dhcmgnurcomm.csp?EmrCode="_sumecode_"&RowId="_checkid_"&PerID="_perid
	s ret=ret_"{border: false,region: 'center', layout: 'fit', title: '"_NurSubsetInfor_"',height:"_h_",width:"_w_",html:'<iframe id =""southTab1"" name=""ddd1"" style=""width:100%;height:100%""  src="""_url_""" ></iframe>'}"
	s ret=ret_"]"
	q ret
}

/// Hospital:北京协和医院
/// Method Description：护理部按大科查询
/// Date:2015-01-20
Query SearchLarLocCom() As %Query(ROWSPEC = "LocDesc,LocId,rw")
{
}

ClassMethod SearchLarLocComExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1 
 	s loc="" f  s loc=$O(^DHCMGNUR.MgNurLargeLocI("Code",loc)) q:loc=""  d
 	.q:$Tr(loc," ","")="HLB"
 	.s id="" f  s id=$O(^DHCMGNUR.MgNurLargeLocI("Code",loc,id)) q:id=""  d
 	..s locObj=##class(DHCMGNUR.MgNurLargeLoc).%OpenId(id)
 	..s LocId=locObj.LocCode
 	..s LocDesc=locObj.LocDes
 	..s rw=id
	..d OutputRow8
 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(LocDesc,LocId,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod SearchLarLocComFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchLarLocComExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SearchLarLocComClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchLarLocComExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
