/// Desc: 		患者病史信息绑定数据Bl层 
/// Creator:	Donglulu
/// CreatDate:	2020-1-21
Class EMRservice.BL.BLMedicalHistoryBindData Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:      获取患者病史问卷中填写的某一题数据
/// Input:     APatientID 患者ID
/// 		   AQuestCode 题目的code（EMRmeta.QuestionData表的QuestionCode）
/// Output:    result 患者病史问卷中填写的某一题数据
/// Debug:     w ##Class(EMRservice.BL.BLMedicalHistoryBindData).GetQuestValue(1,"MedicalHistory")
ClassMethod GetQuestValue(APatientID As %String, AQuestCode As %String) As %String
{
	s result = ""
	q:(APatientID = "")||(AQuestCode = "") result
	
	s rowId = $o(^DHCEMRI.MedicalHistoryI("IdxPatQuestCode"," "_APatientID," "_$zcvt(AQuestCode,"U"),""))
	q:(rowId = "") result
	
	s obj = ##Class(EMRinstance.MedicalHistory).%OpenId(rowId)
	q:(obj = "") result
	s values = obj.Value
		
	q values
}

///  Creator:    Donglulu
///  CreateDate: 2021-03-17
///  Desc:       获取病人既往病史数据
///  Input:      APatientID 患者ID
///  return:     病人既往病史数据
///  Debug:      w ##Class(EMRservice.BL.BLMedicalHistoryBindData).GetMedicalHistory("1")
ClassMethod GetMedicalHistory(APatientID As %String) As %String
{
	s result = ""
	s values = ##Class(EMRservice.BL.BLMedicalHistoryBindData).GetQuestValue(APatientID,"MedicalHistory")
	q:(values = "") result
	
	s length = $l(values,"^")
	for I=1:1:length
	{
		s value = $p(values,"^",I)
		s text = $p(value,"|",2)
		s:(I > 1) result = result_"，"
		s:(I = 1) result = result_"既往"
		s result = result_text
	}	
	q result
}

/// 通过就诊号获取既往史信息
/// d ##class(%ResultSet).RunQuery("EMRservice.BL.BLMedicalHistoryBindData","GetMedicalHistoryInfo",1)
Query GetMedicalHistoryInfo(parAdmId As %String) As %Query(ROWSPEC = "result")
{
}

ClassMethod GetMedicalHistoryInfoExecute(ByRef qHandle As %Binary, parAdmId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	q:(parAdmId = "") $$$OK
	
	s patientID=$P(^PAADM(parAdmId),"^",1)
	q:(patientID = "") $$$OK
	
	s result = ##Class(EMRservice.BL.BLMedicalHistoryBindData).GetMedicalHistory(patientID)
	
	Set ^CacheTemp(repid, ind) = $LB(result)
	Set ind = ind + 1
	Quit $$$OK
}

ClassMethod GetMedicalHistoryInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMedicalHistoryInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod GetMedicalHistoryInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMedicalHistoryInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" 
	{				// if there are no more rows, finish fetching
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

///  Creator:    Donglulu
///  CreateDate: 2021-03-17
///  Desc:       获取病人传染病史
///  Input:      APatientID 患者ID
///  return:     病人传染病史数据
///  Debug:      w ##Class(EMRservice.BL.BLMedicalHistoryBindData).GetInfectionDiseaseHistory("4")
ClassMethod GetInfectionDiseaseHistory(APatientID As %String) As %String
{
	s result = ""
	s values = ##Class(EMRservice.BL.BLMedicalHistoryBindData).GetQuestValue(APatientID,"InfectionDisease")
	q:(values = "") result
	s length = $l(values,"^")
	for I=1:1:length
	{
		s value = $p(values,"^",I)
		s text = $p(value,"|",2)
		s:(I > 1) result = result_"，"
		s result = result_text
	}	
	q result
}

/// 通过就诊号获取传染病史信息
/// d ##class(%ResultSet).RunQuery("EMRservice.BL.BLMedicalHistoryBindData","GetInfectionDiseaseHistoryInfo",1)
Query GetInfectionDiseaseHistoryInfo(parAdmId As %String) As %Query(ROWSPEC = "result")
{
}

ClassMethod GetInfectionDiseaseHistoryInfoExecute(ByRef qHandle As %Binary, parAdmId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	q:(parAdmId = "") $$$OK
	
	s patientID=$P(^PAADM(parAdmId),"^",1)
	q:(patientID = "") $$$OK
	
	s result = ##Class(EMRservice.BL.BLMedicalHistoryBindData).GetInfectionDiseaseHistory(patientID)
	
	Set ^CacheTemp(repid, ind) = $LB(result)
	Set ind = ind + 1
	Quit $$$OK
}

ClassMethod GetInfectionDiseaseHistoryInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInfectionDiseaseHistoryInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod GetInfectionDiseaseHistoryInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInfectionDiseaseHistoryInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" 
	{				// if there are no more rows, finish fetching
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

///  Creator:    Donglulu
///  CreateDate: 2021-03-17
///  Desc:       获取病人手术史数据
///  Input:      APatientID 患者ID
///  return:     病人手术史数据数据
///  Debug:      w ##Class(EMRservice.BL.BLMedicalHistoryBindData).GetSurgicalHistory("1")
ClassMethod GetSurgicalHistory(APatientID As %String) As %String
{
	s result = ""
	s value = ##Class(EMRservice.BL.BLMedicalHistoryBindData).GetQuestValue(APatientID,"SurgicalHistory")
	q:(value = "") result
	
	s array = ##Class(EMRservice.Util.Json).FromJson(value)
	
	for
	{		
		s value = array.GetNext(.key)
		q:(key = "")
		s:(result '= "") result = result_"，"
		s date = value.GetAt("field0")
		s name = value.GetAt("field1")
		s result = result_date
		s result = result_"："
		s result = result_name
		
	} 
	
	q result
}

/// 通过就诊号获取手术史信息
/// d ##class(%ResultSet).RunQuery("EMRservice.BL.BLMedicalHistoryBindData","GetSurgicalHistoryInfo",1)
Query GetSurgicalHistoryInfo(parAdmId As %String) As %Query(ROWSPEC = "result")
{
}

ClassMethod GetSurgicalHistoryInfoExecute(ByRef qHandle As %Binary, parAdmId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	q:(parAdmId = "") $$$OK
	
	s patientID=$P(^PAADM(parAdmId),"^",1)
	q:(patientID = "") $$$OK
	
	s result = ##Class(EMRservice.BL.BLMedicalHistoryBindData).GetSurgicalHistory(patientID)
	
	Set ^CacheTemp(repid, ind) = $LB(result)
	Set ind = ind + 1
	Quit $$$OK
}

ClassMethod GetSurgicalHistoryInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSurgicalHistoryInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod GetSurgicalHistoryInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSurgicalHistoryInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" 
	{				// if there are no more rows, finish fetching
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

///  Creator:    Donglulu
///  CreateDate: 2021-03-17
///  Desc:       获取病人住院史数据
///  Input:      APatientID 患者ID
///  return:     病人住院史数据
///  Debug:      w ##Class(EMRservice.BL.BLMedicalHistoryBindData).GetHospitalization("4")
ClassMethod GetHospitalization(APatientID As %String) As %String
{
	s result = ""
	s value = ##Class(EMRservice.BL.BLMedicalHistoryBindData).GetQuestValue(APatientID,"Hospitalization")
	q:(value = "") result
	
	s array = ##Class(EMRservice.Util.Json).FromJson(value)
	
	for
	{		
		s value = array.GetNext(.key)
		q:(key = "")
		s:(result '= "") result = result_"，"
		s date = value.GetAt("field0")
		s name = value.GetAt("field1")
		s result = result_date
		s result = result_"："
		s result = result_name
		
	} 
	
	q result
}

/// 通过就诊号获取住院史信息
/// d ##class(%ResultSet).RunQuery("EMRservice.BL.BLMedicalHistoryBindData","GetHospitalizationInfo",1)
Query GetHospitalizationInfo(parAdmId As %String) As %Query(ROWSPEC = "result")
{
}

ClassMethod GetHospitalizationInfoExecute(ByRef qHandle As %Binary, parAdmId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	q:(parAdmId = "") $$$OK
	
	s patientID=$P(^PAADM(parAdmId),"^",1)
	q:(patientID = "") $$$OK
	
	s result = ##Class(EMRservice.BL.BLMedicalHistoryBindData).GetHospitalization(patientID)
	
	Set ^CacheTemp(repid, ind) = $LB(result)
	Set ind = ind + 1
	Quit $$$OK
}

ClassMethod GetHospitalizationInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetHospitalizationInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod GetHospitalizationInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetHospitalizationInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" 
	{				// if there are no more rows, finish fetching
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

///  Creator:    Donglulu
///  CreateDate: 2021-03-17
///  Desc:       获取婚育史数据
///  Input:      APatientID 患者ID
///  return:     婚育史数据
///  Debug:      w ##Class(EMRservice.BL.BLMedicalHistoryBindData).GetMarriageHistory("1")
ClassMethod GetMarriageHistory(APatientID As %String) As %String
{
	s result = ""
	s status = ##Class(EMRservice.BL.BLMedicalHistoryBindData).GetQuestValue(APatientID,"MarriageStatus")
	s status = $p(status,"|",2)
	s result = result_"婚姻状态："_status_"，"
	if (status '= "未婚")
	{
		s age = ##Class(EMRservice.BL.BLMedicalHistoryBindData).GetQuestValue(APatientID,"MarriageAge")
		s result = result_"结婚年龄"_age_"岁"_"，"
		
		s sexInfo = ##Class(EMRservice.HISInterface.PatientInfoAssist).Gender(APatientID)
		s sex = $p(sexInfo,"^",3)
		if (sex = "女")
		{
			s pregnancyNumber = ##Class(EMRservice.BL.BLMedicalHistoryBindData).GetQuestValue(APatientID,"PregnancyNumber")
			s abortionNumber = ##Class(EMRservice.BL.BLMedicalHistoryBindData).GetQuestValue(APatientID,"AbortionNumber")
			s deliveryNumber = ##Class(EMRservice.BL.BLMedicalHistoryBindData).GetQuestValue(APatientID,"DeliveryNumber")
			s result = result_"孕G"_pregnancyNumber_" 流A"_abortionNumber_" 产P"_deliveryNumber_"，"
		}
		
		s sonNum = ##Class(EMRservice.BL.BLMedicalHistoryBindData).GetQuestValue(APatientID,"SonNumber")
		s daughterNum = ##Class(EMRservice.BL.BLMedicalHistoryBindData).GetQuestValue(APatientID,"DaughterNumber")
		s result = result_"育有"_sonNum_"子"_daughterNum_"女"
	}
	
	q result
}

/// 通过就诊号获取婚育史数据
/// d ##class(%ResultSet).RunQuery("EMRservice.BL.BLMedicalHistoryBindData","GetMarriageHistoryInfo",1)
Query GetMarriageHistoryInfo(parAdmId As %String) As %Query(ROWSPEC = "result")
{
}

ClassMethod GetMarriageHistoryInfoExecute(ByRef qHandle As %Binary, parAdmId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	q:(parAdmId = "") $$$OK
	
	s patientID=$P(^PAADM(parAdmId),"^",1)
	q:(patientID = "") $$$OK
	
	s result = ##Class(EMRservice.BL.BLMedicalHistoryBindData).GetMarriageHistory(patientID)
	
	Set ^CacheTemp(repid, ind) = $LB(result)
	Set ind = ind + 1
	Quit $$$OK
}

ClassMethod GetMarriageHistoryInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMarriageHistoryInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod GetMarriageHistoryInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMarriageHistoryInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" 
	{				// if there are no more rows, finish fetching
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

///  Creator:    Donglulu
///  CreateDate: 2021-03-17
///  Desc:       获取病人家族史数据
///  Input:      APatientID 患者ID
///  return:     病人家族史数据
///  Debug:      w ##Class(EMRservice.BL.BLMedicalHistoryBindData).GetFamilyMedicalHistory("1")
ClassMethod GetFamilyMedicalHistory(APatientID As %String) As %String
{
	s result = ""
	s value = ##Class(EMRservice.BL.BLMedicalHistoryBindData).GetQuestValue(APatientID,"FamilyMedicalHistory")
	q:(value = "") result
	
	s array = ##Class(EMRservice.Util.Json).FromJson(value)
	
	for
	{		
		s value = array.GetNext(.key)
		q:(key = "")
		s:(result '= "") result = result_"，"
		s level = value.GetAt("field0Desc")
		s relation = value.GetAt("field1Desc")
		s status = value.GetAt("field2Desc")
		s diseaze = value.GetAt("field3Desc")
		s result = result_level
		s result = result_relation
		s result = result_status
		s result = result_diseaze
		
	} 
	
	q result
}

/// 通过就诊号获取家族史信息
/// d ##class(%ResultSet).RunQuery("EMRservice.BL.BLMedicalHistoryBindData","GetFamilyMedicalHistoryInfo",1)
Query GetFamilyMedicalHistoryInfo(parAdmId As %String) As %Query(ROWSPEC = "result")
{
}

ClassMethod GetFamilyMedicalHistoryInfoExecute(ByRef qHandle As %Binary, parAdmId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	q:(parAdmId = "") $$$OK
	
	s patientID=$P(^PAADM(parAdmId),"^",1)
	q:(patientID = "") $$$OK
	
	s result = ##Class(EMRservice.BL.BLMedicalHistoryBindData).GetFamilyMedicalHistory(patientID)
	
	Set ^CacheTemp(repid, ind) = $LB(result)
	Set ind = ind + 1
	Quit $$$OK
}

ClassMethod GetFamilyMedicalHistoryInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetFamilyMedicalHistoryInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod GetFamilyMedicalHistoryInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetFamilyMedicalHistoryInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" 
	{				// if there are no more rows, finish fetching
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

}
