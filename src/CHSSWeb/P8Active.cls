Class CHSSWeb.P8Active Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod ActiveAll() As %String
{
	w ##class(CHSSWeb.CommunityService).GetCommunityFromHospital(26,"乡镇卫生院","")
	w ##class(CHSSWeb.CommunityService).GetCurrentCommunity("100","村卫生所")
	w ##class(CHSSWeb.CommunityService).GetCurrentCommunity("100","乡镇卫生院")
	w ##class(CHSSWeb.CommunityService).GetCommunityInfoWithType(1,"村卫生所")
	w ##class(CHSSWeb.CommunityService).GetCommunityInfoWithType(1,"乡镇卫生院")
	w ##class(CHSSWeb.CommunityService).GetCommunityCode(1),!
	w ##class(CHSSWeb.CommunityService).GetCommunityType(1),!
	w ##class(CHSSWeb.CommunityService).GetCommunityInfo(1),!
	;区域
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictProvince"),!
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictCity"),!
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictSection"),!
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictStreet"),!
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictVillage"),!
	w ##class(CHSSWeb.DictDistrictService).ListPage(0,10,"test",1),!
	
	w ##class(CHSSWeb.DictService).ListPage1(0,10,"")
	w ##class(CHSSWeb.DictCityService).ListPage(0,10)
	w ##class(CHSSWeb.DictProvinceService).ListProvince(0,10)
	w ##class(CHSSWeb.DictProvinceService).ListPage(0,10)
	w ##class(CHSSWeb.DictSectionService).ListPage(0,10,"")
	w ##class(CHSSWeb.DictCityService).ListCity(0,10)
	w ##class(CHSSWeb.DictStreetService).ListPage(0,10,"")
	w ##class(CHSSWeb.DictSectionService).ListSection(0,10)
	w ##class(CHSSWeb.DictHospitalService).ListPage(0,10)
	w ##class(CHSSWeb.DictHospitalService).getxc(0,10,"")
	w ##class(CHSSWeb.DictHospitalService).listct(0,10)
	w ##class(CHSSWeb.CommonDictService).ListOld(0,10,"")
	w ##class(CHSSWeb.CommonDictService).ListPage(0,10,"")
	
	w ##class(CHSSWeb.DictVillageService).ListPage(0,100,"")
	w ##class(CHSSWeb.DictStreetService).ListStreet(0,100)
	
	w ##class(CHSSWeb.DictDistrictService).ListPage(0,100,"DictCity",2)
	w ##class(CHSSWeb.DictDistrictService).ListPage(0,100,"DictSection",1)
	w ##class(CHSSWeb.DictDistrictService).ListPage(0,100,"DictStreet",1)
	w ##class(CHSSWeb.DictDistrictService).ListPage(0,100,"DictVillage",1)
	w ##class(CHSSWeb.DictHospitalService).ListSearch(0,100,"DictCity","",2)
	w ##class(CHSSWeb.DictHospitalService).ListSearch(0,100,"DictSection","",1)
	w ##class(CHSSWeb.DictHospitalService).ListSearch(0,100,"DictStreet","",1)
	w ##class(CHSSWeb.DictHospitalService).ListSearch(0,100,"DictVillage","",1)
	
	;字典
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictArchivesStatus")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictAddressType")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictMedicalInsuranceType")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictDiagnoseType")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictDiagnoseItemType")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictAllergic")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictDangerType")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictDeformityType")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictBacterin")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictKin")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictDocimialType")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictChronicDisease")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictAddressType")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictCommittee")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictPointHospital")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictOPSPart")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictPolice")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictTrauma")
	
	;字典查询
	w ##class(CHSSWeb.CommonDictService).ListSearch(0,100,"DictAllergic","dd")
	w ##class(CHSSWeb.CommonDictService).ListSearch(0,100,"DictChronicDisease","dd")
	w ##class(CHSSWeb.CommonDictService).ListSearch(0,100,"DictDangerType","dd")
	w ##class(CHSSWeb.CommonDictService).ListSearch(0,100,"DictOPSPart","dd")
	w ##class(CHSSWeb.CommonDictService).ListSearch(0,100,"DictDocimialType","dd")
	w ##class(CHSSWeb.CommonDictService).ListSearch(0,100,"DictTrauma","dd")
	w ##class(CHSSWeb.CommonDictService).ListSearch(0,100,"CT_Country","dd")
	w ##class(CHSSWeb.CommonDictService).ListSearch(0,100,"DictBacterin","dd")
	w ##class(CHSSWeb.CommonDictService).ListSearch(0,100,"DictChrnicDisease","dd")
	
	;old Dict
	w ##class(CHSSWeb.CommonDictService).ListOld(0,100,"PAC_CardType")
	w ##class(CHSSWeb.CommonDictService).ListOld(0,100,"CT_Sex")
	w ##class(CHSSWeb.CommonDictService).ListOld(0,100,"CT_Country")
	w ##class(CHSSWeb.CommonDictService).ListOld(0,100,"CT_Nation")
	w ##class(CHSSWeb.CommonDictService).ListOld(0,100,"PAC_BloodType")
	w ##class(CHSSWeb.CommonDictService).ListOld(0,100,"CT_Education")
	w ##class(CHSSWeb.CommonDictService).ListOld(0,100,"CT_Occupation")
	w ##class(CHSSWeb.CommonDictService).ListOld(0,100,"CT_Marital")
	w ##class(CHSSWeb.CommonDictService).ListOld(0,100,"SS_User")
	
	w ##class(CHSSWeb.CommonDictService).ListOldSearch(0,100,"MRC_ICDDx","dd")
	w ##class(CHSSWeb.CommonDictService).ListOldSearch(0,100,"CT_Nation","dd")
	
	
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictBacterin")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictChrnicDisease")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictHouseType")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictFamilyFuelType")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictLavatoryType")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictFamilyProperty")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"HighWayType")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictCommunication")	
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictTypeOfFirstCheck")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictChronicSymptom")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictComplication")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictDiagnoseResult")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictHBVTag")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictKindOfBlood")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictLiverEcho")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictLiverEnvelope")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictLiverFunction")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictLiverNodule")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictLiverPortal")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictLiverRigidity")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictLiverShape")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictLiverSize")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictMonitorFrequency")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictPhysicalSign")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictSpleenDepth")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictTiter")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictTreatEffection")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictTreatInfo")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictTypeOfFirstCheck")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictTypOfBlood")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictUseInjectorInfo")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictVaccinationDosage")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictVaccinationPlace")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictWoundedMedical")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictHouseTypeBefore")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictSanitaryCondition")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictRelativeInfo")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictHurtPart")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictHurtReason")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictAmputation")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictBuryPart")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictSputumSmearResult")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictCureType")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictPayType")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictCureManageType")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictSputumCultureResult")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictDrugSensitiveTest")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictHIVTest")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictReasonOfStopCure")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictOtherHistory")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictDentition")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictCognitiveAbility")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictAffectiveState")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictHearing")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictMotorFunction")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictSkin")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictBarrelChest")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictLymphNodes")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictBarrelChest")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictCardiacRhythm")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictLowerExtremityEdema")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictAnus")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictProstate")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictFecalOccultBlood")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictHBsAG")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictHbsAb")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictSternumSource")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictOralLips")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictChogh")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictExpectoration")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictDyspnea")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictChronicSymptom")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictWheezingRale")
	
	
	
	
	;w ##class(CHSSWeb.DictService).insert("1","测试","2009-08-05","2012-01-01","","1","DictCommittee")
	;w ##class(CHSSWeb.DictService).update(9999,"1","测试","2009-08-05","2012-01-01","","1","DictCommittee")
	;w ##class(CHSSWeb.DictService).delete("9999","DictPolice")
	;w ##class(CHSSWeb.DictService).insert("1","测试","2009-08-05","2012-01-01","","1","DictPolice")
	;w ##class(CHSSWeb.DictService).update(9999,"1","测试","2009-08-05","2012-01-01","","1","DictPolice")

	;个人、家庭编码
	w ##class(CHSSWeb.SystemIdService).GetSystemId("100","PERSONHEALTHRECORDMAIN")
	w ##class(CHSSWeb.SystemIdService).GetSystemId("100","FAMILYHEALTHRECORD")
	w ##class(CHSSWeb.SystemIdService).GetSystemId1("100","PERSONHEALTHRECORDMAIN")
	w ##class(CHSSWeb.SystemIdService).GetSystemId1("100","FAMILYHEALTHRECORD")
	w ##class(CHSSWeb.SystemIdService).GetSystemId2("100","PERSONHEALTHRECORDMAIN")
	w ##class(CHSSWeb.SystemIdService).GetSystemId2("100","FAMILYHEALTHRECORD")

    ;个人地震
	w ##class(CHSSWeb.PersonEarthquakeInfoService).PersonEarthquakeInfoList(1,0,10,"","","")
	;个人档案
	w ##class(CHSSWeb.PHRService).PersonList("100",0,1,"","","")
	w ##class(CHSSWeb.PHRService).GetPersonInfoWithId(1)
	
	w ##class(CHSSWeb.PHRSearchService).PersonSearch("100",0,1,"","","")
	
	w ##class(CHSSWeb.PHRSearchService).PersonSearchSql("100",0,100,"","and HouseHoldName like '%测试%'")
	
	w ##class(CHSSWeb.PHRService).GetFamilyMembers("100",0,0,100,"")
	w ##class(CHSSWeb.PHRSearchService).PersonSearchSql("100",0,1,"","")
	w ##class(CHSSWeb.PHRSearchService).PersonSearchSql("100",0,100,""," and PersonRowId in (select PersonRowIdParref from CHSS.PersonHealthDiagnose where ItemdCode = '22' and ItemAssortName = '乙肝')")
	w ##class(CHSSWeb.PHRSearchService).PersonSearchSql("100",0,100,""," and PersonName like '%测试%' and PersonRowId in (select PersonRowIdParref from CHSS.PersonHealthDiagnose where ItemdCode = '22' and ItemAssortName = '乙肝')")
	w ##class(CHSSWeb.PHRSearchService).PersonSearchSql("100",0,100,""," and PersonName like '%测试%' and SexDR = 1 and PersonRowId in (select PersonRowIdParref from CHSS.PersonHealthDiagnose where ItemdCode = '22' and ItemAssortName = '乙肝')")
	w ##class(CHSSWeb.PHRSearchService).PersonSearchSql("100",0,100,""," and PersonCode like '%123%' and PersonRowId in (select PersonRowIdParref from CHSS.PersonHealthDiagnose where ItemdCode = '22' and ItemAssortName = '乙肝')")
	w ##class(CHSSWeb.PHRSearchService).PersonSearchSql("100",0,100,""," and IDCard ='123' and PersonRowId in (select PersonRowIdParref from CHSS.PersonHealthDiagnose where ItemdCode = '22' and ItemAssortName = '乙肝')")
	w ##class(CHSSWeb.PHRSearchService).PersonSearchSql("100",0,100,""," and PersonRowId in (select PersonRowIdParref from CHSS.PersonHealthDiagnose where ItemdCode = '22' and ItemAssortName = '结核病')")
	w ##class(CHSSWeb.PHRSearchService).PersonSearchSql("100",0,100,""," and PersonName like '%测试%' and PersonRowId in (select PersonRowIdParref from CHSS.PersonHealthDiagnose where ItemdCode = '22' and ItemAssortName = '结核病')")
	w ##class(CHSSWeb.PHRSearchService).PersonSearchSql("100",0,100,""," and PersonName like '%测试%' and SexDR = 1 and PersonRowId in (select PersonRowIdParref from CHSS.PersonHealthDiagnose where ItemdCode = '22' and ItemAssortName = '结核病')")
	w ##class(CHSSWeb.PHRSearchService).PersonSearchSql("100",0,100,""," and PersonCode like '%123%' and PersonRowId in (select PersonRowIdParref from CHSS.PersonHealthDiagnose where ItemdCode = '22' and ItemAssortName = '结核病')")
	w ##class(CHSSWeb.PHRSearchService).PersonSearchSql("100",0,100,""," and IDCard ='123' and PersonRowId in (select PersonRowIdParref from CHSS.PersonHealthDiagnose where ItemdCode = '22' and ItemAssortName = '结核病')")
	
	w ##class(CHSSWeb.PHRSearchService).PersonSearchSql("100",0,1,""," and PersonName like '%测试%'")
	w ##class(CHSSWeb.PHRSearchService).PersonSearchSql("100",0,1,""," and PersonName like '%测试%' and SexDR = 1")
	w ##class(CHSSWeb.PHRSearchService).PersonSearchSql("100",0,1,""," and SexDR = 1")
	w ##class(CHSSWeb.PHRSearchService).PersonSearchSql("100",0,1,""," and PersonCode like '%123%'")
	w ##class(CHSSWeb.PHRSearchService).PersonSearchSql("100",0,1,""," and IDCard ='123'")
	w ##class(CHSSWeb.PHRSearchService).PersonSearchSql("100",0,1,""," and CardNumber ='123'")
	w ##class(CHSSWeb.PHRSearchService).GetPersonInfoWithRowId(1)
	; and FamilyRowId in (select FamilyRowId from CHSS.FamilyHealthRecord where VillageName like '%"_FamilyAddSearch_"%')
	w ##class(CHSSWeb.PHRSearchService).PersonSearchSql("100",0,1,""," and FamilyRowId in (select FamilyRowId from CHSS.FamilyHealthRecord where VillageName like '%11%'")
	
	;个人健康情况
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictAllergic")
	w ##class(CHSSWeb.PersonHealthDiagnoseService).ListPage(0,10,1,1)
	w ##class(CHSSWeb.PersonHealthDiagnoseService).ShowInfo(0, 100, 1, "1")
	w ##class(CHSSWeb.PersonHealthDiagnoseService).ShowInfo(0, 100, 1, "2")
	w ##class(CHSSWeb.PersonHealthDiagnoseService).ShowInfo(0, 100, 1, "3")
	w ##class(CHSSWeb.PersonHealthDiagnoseService).ShowInfo(0, 100, 1, "4")
	w ##class(CHSSWeb.PersonHealthDiagnoseService).ShowInfo(0, 100, 1, "5")
	w ##class(CHSSWeb.PersonHealthDiagnoseService).ShowInfo(0, 100, 1, "52")
	w ##class(CHSSWeb.PersonHealthDiagnoseService).ShowInfo(0, 100, 1, "6")
	w ##class(CHSSWeb.PersonHealthDiagnoseService).ShowInfo(0, 100, 1, "7")
	w ##class(CHSSWeb.PersonHealthDiagnoseService).ShowInfo(0, 100, 1, "8")
	w ##class(CHSSWeb.PersonHealthDiagnoseService).ShowInfo(0, 100, 1, "9")
	w ##class(CHSSWeb.PersonHealthDiagnoseService).ShowInfo(0, 100, 1, "10")
	w ##class(CHSSWeb.PersonHealthDiagnoseService).ShowInfo(0, 100, 1, "11")
	w ##class(CHSSWeb.PersonHealthDiagnoseService).ShowInfo(0, 100, 1, "12")
	w ##class(CHSSWeb.PersonHealthDiagnoseService).ShowInfo(0, 100, 1, "13")
	w ##class(CHSSWeb.PersonHealthDiagnoseService).ShowInfo(0, 100, 1, "14")
	w ##class(CHSSWeb.PersonHealthDiagnoseService).ShowInfo(0, 100, 1, "15")
	w ##class(CHSSWeb.PersonHealthDiagnoseService).ShowInfo(0, 100, 1, "16")
	w ##class(CHSSWeb.PersonHealthDiagnoseService).ShowInfo(0, 100, 1, "17")
	w ##class(CHSSWeb.PersonHealthDiagnoseService).ShowInfo(0, 100, 1, "18")
	w ##class(CHSSWeb.PersonHealthDiagnoseService).ShowInfo(0, 100, 1, "19")
	w ##class(CHSSWeb.PersonHealthDiagnoseService).ShowInfo(0, 100, 1, "20")
	w ##class(CHSSWeb.PersonHealthDiagnoseService).ShowInfo(0, 100, 1, "21")
	w ##class(CHSSWeb.PersonHealthDiagnoseService).ShowInfo(0, 100, 1, "22")
	;add by wangbo 2009-12-08
	w ##class(CHSSWeb.PersonHealthDiagnoseService).ShowInfo(0, 100, 1, "23")

	;个人体检
	w ##class(CHSSWeb.PYCAService).List("1")
	w ##class(CHSSWeb.PYCRService).List("1",0,100)
	w ##class(CHSSWeb.PYCSService).List("1")
	w ##class(CHSSWeb.PersonTBCheckService).PersonTBCheckList(1,1,0,10,1)
	w ##class(CHSSWeb.DrugDictService).ListPage(0,100,"DictDrug",1)
	w ##class(CHSSWeb.DrugDictService).ListPage(0,100,"DictDrug",2)
	
	;个人长期问题目录
	;w ##class(CHSSWeb.PersonLongTermProblemService).List(26,0,15,"")
	w ##class(CHSSWeb.PersonLongTermDrugService).ListPage(0,100,26,"","")
	w ##class(CHSSWeb.PersonHBVCheckHomeService).List(26,3,0,15,"")
	

	;长期用药
	w ##class(CHSSWeb.PersonLongTermDrugService).ListPage(0,100,"",26,"HBVOtherMed")
	w ##class(CHSSWeb.PersonLongTermDrugService).ListPage(0,100,"",29,"")
	w ##class(CHSSWeb.PersonLongTermDrugService).ListPage(0,100,25,"","TreatThenMed")
	w ##class(CHSSWeb.PersonLongTermDrugService).ListPage(0,100,25,"","TreatMed")
	w ##class(CHSSWeb.PersonLongTermDrugService).ShowInfo(0,100,"",26,"HBVOtherMed")
	w ##class(CHSSWeb.PersonLongTermDrugService).ShowInfo(0,100,"",29,"")
	w ##class(CHSSWeb.PersonLongTermDrugService).ShowInfo(0,100,25,"","TreatThenMed")
	w ##class(CHSSWeb.PersonLongTermDrugService).ShowInfo(0,100,25,"","TreatMed")
	w ##class(CHSSWeb.PersonLongTermDrugService).ListPage(0,100,"",62,"")

	;家庭地震情况
	w ##class(CHSSWeb.FamilyEarthquakeInfoService).List(5,0,15,"")

	;家庭档案
	w ##class(CHSSWeb.FamilySearchService).FamilySearch("100",0,1,"","","")
	w ##class(CHSSWeb.FamilySearchService).GetFamilyInfoWithPersonRowId(0)
	w ##class(CHSSWeb.FamilySearchService).FamilySearchSql("100",0,100,"","and HouseHoldName like '%测试%'")
	w ##class(CHSSWeb.FamilySearchService).FamilySearchSql("100",0,100,""," and FamilyCode like '%123%'")
	w ##class(CHSSWeb.FamilySearchService).FamilySearchSql("100",0,100,"","  and DoorPlate like '%11%'")
	w ##class(CHSSWeb.FamilySearchService).FamilySearchSql("100",0,100,"","  and FamilyPhone like '%11%'")
	w ##class(CHSSWeb.FamilySearchService).FamilySearchSql("100",0,100,"","  and VillageName like '%11%'")
	
	w ##class(CHSSWeb.HISInfoService).PersonListFromHIS("123")
	w ##class(CHSSWeb.FamilySearchService).GetFamilyInfoWithPersonRowId(0)
	w ##class(CHSSWeb.FamilySearchService).GetFamilyInfoWithFamilyRowId(0)
	w ##class(CHSSWeb.PHRService).deletePerson(9999999999999)
	w ##class(CHSSWeb.FamilyService).deleteFamily(9999999999999)
	
	w ##class(CHSSWeb.FamilyService).FamilyList("100",0,10,"")
	w ##class(CHSSWeb.FamilySearchService).FamilySearch("100",0,10,"","","")
	w ##class(CHSSWeb.FamilySearchService).FamilySearchSql("100",0,10,"","")
	w ##class(CHSSWeb.SystemIdService).GetSystemId("100","FAMILYHEALTHRECORD")
	w ##class(CHSSWeb.FamilySearchService).GetFamilyInfoWithPersonRowId(0)
	w ##class(CHSSWeb.FamilyService).GetFamilyInfoWithFamilyRowId(0)
	
	
	;家庭主要问题目录
	w ##class(CHSSWeb.FamilyProblemService).FamilyProblemList(1,0,10,"")
	
	;慢性病
	w ##class(CHSSWeb.PersonEarthquakeInfoService).PersonEarthquakeInfoList(1,0,10,"","","")
	w ##class(CHSSWeb.HBPHeadPageService).HBPHeadPageList(1,0,100,1)
	w ##class(CHSSWeb.DiabetesHeadPageService).DiabetesHeadPageList(1,0,100,1)
	w ##class(CHSSWeb.HBPCheckRecordService).HBPCheckRecordList(1,0,1,1)
	w ##class(CHSSWeb.DiabetesCheckRecordService).DiabetesCheckRecordList(1,0,1,1)
	
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictDiseaseHistory")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictSelfCare")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictFood")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictComplyDoctor")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictMentalityAdjust")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictCheckResult")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictCaseType")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictBloodSurgeRate")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictEyeground")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictDoseCondition")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictDrugRegularityRate")
	;add by wangbo 2009-12-07
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictSmoke")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictDrink")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictExercise")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictPsychologicStatus")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictCaseSource")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictChronicSmoke")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictChronicDrink")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictChronicExercise")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictHBPFamHis")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictDiabetesFamHis")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictElderFood")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictChronicExercise")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictMentalStatus")
	
	;老年人
	w ##class(CHSSWeb.ElerlyHealthCheckRecordService).List(26,0,1,"")
	w ##class(CHSSWeb.ElerlyBaseInfoService).List(26,0,1,"")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictEyesight")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictLifeSupport")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictNursing")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictToothDeformity")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictSymptomType")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictPsychologyStatus")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictFood")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictEduKnowledge")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictEyegroundCheck")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictElderCaseType")
	;w ##class(CHSSWeb.DictChronicSymptomService).List(0,1,1,"eldersymptom")
	

	;生活方式
	w ##class(CHSSWeb.PersonLifeStyleService).List(26,0,100)
	w ##class(CHSSWeb.PersonLifeStyleService).ShowDrink(26,0,100)
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictExerciseFre")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictExerciseType")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictTemperType")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictSleepStatus")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictDietHabit")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictDrinkFrequency")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictDrinkType")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictComplyDoctor")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictPneumococcus")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictFoodFavor")
	
	;2009-12-12
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictElderGrade")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictLapseTo")
	
	;预约管理
	w ##class(CHSSWeb.PersonBookingCheckService).List("100",0,10,""," and booking.DateOfBooking between '61708' and '61708'")
	w ##class(CHSSWeb.PersonBookingCheckService).GetBookingCount("100",0,10,""," and booking.DateOfBooking between '61708' and '61708'")
	w ##class(CHSSWeb.PersonBookingCheckService).List("100",0,10,""," and booking.DateOfBooking between '61708' and '61708'  and BookingType = 1")
	w ##class(CHSSWeb.PersonBookingCheckService).List("100",0,10,""," and booking.DateOfBooking between '61708' and '61708'  and BookingType = 2")
	w ##class(CHSSWeb.PersonBookingCheckService).List("100",0,10,""," and booking.DateOfBooking between '61708' and '61708'  and BookingType = 3")
	w ##class(CHSSWeb.PersonBookingCheckService).List("100",0,10,""," and booking.DateOfBooking between '61708' and '61708'  and BookingType = 4")
	w ##class(CHSSWeb.PersonBookingCheckService).List("100",0,10,""," and booking.DateOfBooking between '61708' and '61708'  and BookingType = 5")
	w ##class(CHSSWeb.PersonBookingCheckService).List("100",0,10,""," and booking.DateOfBooking between '61708' and '61708'  and BookingType = 6")

	,!
	w ""
	,!
	w "P8Active1激活已执行完毕,请执行P8Active2"
	,!

	q ""
}

Storage Default
{
<Data name="P8ActiveDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.P8ActiveD</DataLocation>
<DefaultData>P8ActiveDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.P8ActiveD</IdLocation>
<IndexLocation>^CHSSWeb.P8ActiveI</IndexLocation>
<StreamLocation>^CHSSWeb.P8ActiveS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
