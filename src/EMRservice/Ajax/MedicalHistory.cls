Class EMRservice.Ajax.MedicalHistory Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s patientID = $Get(%request.Data("PatientID",1),"")
	s hospitalID = $Get(%request.Data("HospitalID",1),"")
	s action = $Get(%request.Data("Action",1),"")
	s questDatas = $Get(%request.Data("QuestDatas",1),"")
	s userID = $Get(%request.Data("UserID",1),"")
	if (action = "ChangeData")
	{
		w ##Class(EMRservice.BL.BLMedicalHistory).ChangeData(patientID,questDatas,userID)
	}
	elseif(action = "GetPatientInfo")
	{
		w ..GetPatientInfoInBrowser(patientID,hospitalID)
	}
	Quit $$$OK
}

/// CreatDate:2014-2-16
/// Desc:	取病人基本信息
/// Table:
/// Input:	patientID As %String
/// Output:
/// Return:	格式为Json的病人基本信息字符串
/// Others:	病历浏览页面上病人基本信息加载
/// debug: w ##Class(EMRservice.Ajax.MedicalHistory).GetPatientInfoInBrowser(1)
ClassMethod GetPatientInfoInBrowser(patientID As %String, hospitalID As %String) As %String
{
	s HasPatEncryptLevel = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName("HasPatEncryptLevel")
	s patientInfo = ""
	s birthday = "" 
	s papmiNo = ""		//登记号
	s name = ""			//姓名
	s age = ""			//年龄
	s gender = ""		//性别
	s ipRecordNo = "" 	//病案号
	//用patientID取病人信息
	if (patientID '= "")&&(patientID '= $C(0))
	{
		//登记号
		s papmiNo = ##class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiNo(patientID)
		
		//姓名
		s name = ##class(EMRservice.HISInterface.PatientInfoAssist).Name(patientID)
		
		//性别
		s gender = ##class(EMRservice.HISInterface.PatientInfoAssist).Gender(patientID, "")
		s gender = $P(gender, "^", 3)
		
		s birthday = ##class(EMRservice.HISInterface.PatientInfoAssist).Birthday(patientID)
		s birthday = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",birthday)
		
		s age = ##class(web.DHCBillInterface).GetPapmiAge(patientID,"",hospitalID,"","")
		
		if (HasPatEncryptLevel = "Y")
		{
			//病人密级和病人级别
			//SecAlias_"^"_EmployeeFunction_"^"_SecCode_"^"_SecDesc
			//密级特殊字符^病人级别^密级代码^密级描述 或 空
			s PatEncryptLevelStr = ##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(patientID)
			s SecAlias = $P(PatEncryptLevelStr, "^",1)
			s EmployeeFunction = $P(PatEncryptLevelStr, "^",2)
			s SecCode = $P(PatEncryptLevelStr, "^",3)
			s SecDesc = $P(PatEncryptLevelStr, "^",4)
		
			//s SecAlias = "1"
			//s EmployeeFunction = "2"
			//s SecCode = "3"
			//s SecDesc = "4"
		}
		else
		{
			s SecAlias = ""
			s EmployeeFunction = ""
			s SecCode = ""
			s SecDesc = ""
		}
	}
		
	s patientInfo = "papmiNo:'"_papmiNo_"',name:'"_name_"',gender:'"_gender_"',age:'"_age_"',ipRecordNo:'"_$g(ipRecordNo)_"',birthday:'"_birthday_"',SecAlias:'"_SecAlias_"',EmployeeFunction:'"_EmployeeFunction_"',SecCode:'"_SecCode_"',SecDesc:'"_SecDesc_"'"
	//转换特殊字符
	s patientInfo = $ZSTRIP(patientInfo,"*C")
	
	q "[{"_patientInfo_"}]"
}

}
