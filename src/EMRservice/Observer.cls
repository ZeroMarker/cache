/// Class Name:		EMRservice.Observer
/// Description:	对患者基本信息表的操作
/// Creator:		Lina
/// Create Date:	2015-09-17
Class EMRservice.Observer Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description:	根据传入参数，更新订阅数据项的内容
/// Creator:		Lina
/// Create Date:	2015-09-07
/// Return:         1:更新成功   -1：保存失败   -2：缺少参数
/// debug:          d ##class(EMRservice.Observer).BLUpdateData("158","NAME^住院卡测试z^住院卡测试","105","192.168.1.20")
ClassMethod BLUpdateData(ArgPateintID As %String, ArgChangedata As %String, ArgUserID As %String, ArgIPaddress As %String) As %String
{
	q:ArgChangedata="" -2
	//医生站更新基本信息  add by lina  2017-03-07
	set OldDataObject=##class(web.DHCBL.Patient.DHCPatientUpdateLog).GetLogData("User.PAPatMas"_$c(2)_ArgPateintID_"^"_"User.PAPerson"_$c(2)_ArgPateintID)
	for count = 1:1:$l(ArgChangedata,"&")
	{
		s changedata = $p(ArgChangedata,"&",count)
        s Code = $p(changedata,"^",1)
    	s CurrentValue = $p(changedata,"^",2)
    	s CurrentCode = $p(changedata,"^",3)
    	if (Code = "NAME")
    	{
   			s ret = ##class(EMRservice.Observer.PaPatMas).UpdateName(ArgPateintID,CurrentValue)
     	}
		//Modify by lina 2016-01-27
		elseif(Code = "ADDRESS-Province")
		{
			s ret = ##class(EMRservice.Observer.PaPatMas).UpdateAddressProvice(ArgPateintID,CurrentCode)
		}
		elseif(Code = "ADDRESS-City")
		{
			s ret = ##class(EMRservice.Observer.PaPatMas).UpdateAddressCity(ArgPateintID,CurrentCode)
		}
		elseif(Code = "ADDRESS-County")
		{
			s ret = ##class(EMRservice.Observer.PaPatMas).UpdateAddressCounty(ArgPateintID,CurrentCode)
		}
		elseif(Code = "ADDRESS-Street")
		{
			s ret = ##class(EMRservice.Observer.PaPatMas).UpdateAddressStreet(ArgPateintID,CurrentValue)
		}
		//Modify by lina 2016-08-05
		elseif(Code = "WorkPhone"){
			//工作电话
			s ret = ##class(EMRservice.Observer.PaPatMas).UpdateWorkPhone(ArgPateintID,CurrentValue)
	   	}
	   	//Modify by lina 2016-08-16
		elseif(Code = "IDCard"){
			//身份证号
			s ret = ##class(EMRservice.Observer.PaPatMas).UpdateIDCard(ArgPateintID,CurrentValue)
        }
        //Modify by lina 2020-07-10
        elseif(Code = "MobilePhone"){
            //现住址电话
            s ret = ##class(EMRservice.Observer.PaPatMas).UpdateMobilePhone(ArgPateintID,CurrentValue)
        }
        elseif(Code = "LinkName"){
            //联系人姓名
            s ret = ##class(EMRservice.Observer.PaPatMas).UpdateLinkName(ArgPateintID,CurrentValue)
        }
        elseif(Code = "LinkPhone"){
            //联系人电话
            s ret = ##class(EMRservice.Observer.PaPatMas).UpdateLinkPhone(ArgPateintID,CurrentValue)
	   	}
        elseif(Code = "Nation"){
            //民族
            s ret = ##class(EMRservice.Observer.PaPatMas).UpdateNation(ArgPateintID,CurrentCode)
        }
        elseif(Code = "Marriage"){
            //婚姻
            s ret = ##class(EMRservice.Observer.PaPatMas).UpdateMarriage(ArgPateintID,CurrentCode)
        }
        elseif(Code = "Occupation"){
            //职业
            s ret = ##class(EMRservice.Observer.PaPatMas).UpdateOccupation(ArgPateintID,CurrentCode)
        }
        elseif(Code = "HuKouAddress"){
            //户口地址
            s ret = ##class(EMRservice.Observer.PaPatMas).UpdateHuKouAddress(ArgPateintID,CurrentValue)
        }
 		//elseif(){....}
 		if (ret = 1)
 		{
	 		s Logret = ..BLSaveLog(ArgPateintID,changedata,ArgUserID,ArgIPaddress,OldDataObject)
	 		s ret = Logret
 		}
 		q:(ret '= 1)
	}
	q ret
}

/// Description:	取患者基本信息的原数据
/// Creator:		Lina
/// Create Date:	2016-01-27
/// Return:         患者基本信息表原有数据
/// Debug: 			w ##class(EMRservice.Observer).BLGetData("NAME","11")
ClassMethod BLGetData(ArgCode As %String, ArgpateintID As %String) As %String
{
	q:ArgpateintID="" -1
	s original = ""
	s PAPatMasobj = ##class(User.PAPatMas).%OpenId(ArgpateintID)
	if (ArgCode = "NAME")
	{
		s original = PAPatMasobj.PAPMIName
	}
	//Modify by lina 2016-01-27
	elseif(ArgCode = "ADDRESS-Province")
	{
		//现住址省份
   		s curprovinceDR = $p($g(^PAPER(ArgpateintID,"PER",4)),"^",2)
   		if (curprovinceDR'=""){
	   		s curProvinceDesc = $p($g(^CT("PROV",curprovinceDR)),"^",2)
			i $l(curProvinceDesc,"-")'=1 {s curProvinceDesc=$p($g(curProvinceDesc),"-",2)}
			s original = curProvinceDesc
	   	}
	}
	elseif(ArgCode = "ADDRESS-City")
	{
		//现住址城市
		s curcityDR = $p($g(^PAPER(ArgpateintID,"PER",1)),"^",5)
		if (curcityDR'=""){
			s curCityDesc = $p($g(^CT("CIT",curcityDR)),"^",2)
			i $l(curCityDesc,"-")'=1 {s curCityDesc=$p($g(curCityDesc),"-",2)}
			s original = curCityDesc
		}
	}
	elseif(ArgCode = "ADDRESS-County")
	{
		//现住址区县
		s curblockDR = $p($g(^PAPER(ArgpateintID,"PER",4)),"^",9)
		if (curblockDR'=""){
			s curBlockDesc = $p($g(^CT("CITAREA",curblockDR)),"^",2)
			i $l(curBlockDesc,"-")'=1 {s curBlockDesc=$p($g(curBlockDesc),"-",2)}
			s original = curBlockDesc
		}
	}
	elseif(ArgCode = "ADDRESS-Street")
	{
		//现住址街号
		s curStreet = $g(^PAPER(ArgpateintID,"PER","ADD",1))
		s original = curStreet
	}
	//Modify by lina 2016-08-05
	elseif(ArgCode = "WorkPhone"){
		//工作电话
		s workPhone = $p($g(^PAPER(ArgpateintID,"PER",1)),"^",9)
		s original = workPhone
	}
	//Modify by lina 2016-08-16
	elseif(ArgCode = "IDCard"){
		//身份证号
		s idCard = $p($g(^PAPER(ArgpateintID,"ALL")),"^",9)
		s original = idCard
   	}
    //Modify by lina 2020-07-10
    elseif(ArgCode = "MobilePhone"){
        //现住址电话
        s mobilePhone = ##Class(EMRservice.HISInterface.PatientInfoAssist).MobilePhone(ArgpateintID)
        s original = mobilePhone
    }
    elseif(ArgCode = "LinkName"){
        //联系人姓名
        s linkName = ##class(EMRservice.HISInterface.PatientInfoAssist).LinkmanName(ArgpateintID)
        s original = linkName
    }
    elseif(ArgCode = "LinkPhone"){
        //联系人电话
        s linkPhone = ##class(EMRservice.HISInterface.PatientInfoAssist).LinkmanPhone(ArgpateintID)
        s original = linkPhone
    }
    elseif(ArgCode = "Nation"){
        //民族
        s nation = ##class(EMRservice.HISInterface.PatientInfoAssist).Nation(ArgpateintID)
        s original = $p($g(nation),"^",3)
    }
    elseif(ArgCode = "Marriage"){
        //婚姻
        s marriage = ##class(EMRservice.HISInterface.PatientInfoAssist).Marriage(ArgpateintID)
        s original = $p($g(marriage),"^",3)
    }
    elseif(ArgCode = "Occupation"){
        //职业
        s occupation = ##class(EMRservice.HISInterface.PatientInfoAssist).Occupation(ArgpateintID)
        s original = $p($g(occupation),"^",3)
    }
    elseif(ArgCode = "HuKouAddress"){
        //户口地址
        s original = ##class(EMRservice.HISInterface.PatientInfoAssist).HuKouAddress(ArgpateintID)
    }
	//elseif
	
	q original
}

/// Description:	电子病历订阅信息操作日志保存
/// Creator:	    Lina
/// Create Date:	2016-01-27
/// Return:         1:保存成功   -1：保存失败   -2：缺少参数
ClassMethod BLSaveLog(ArgPateintID As %String, ArgChangedata As %String, ArgUserID As %String, ArgIPaddress As %String, ArgOldDataObject As %Library.ListOfObjects) As %String
{
	q:ArgPateintID="" -2
	s ReturnValue = 0
	s Code = $p(ArgChangedata,"^",1)
	s Current = $p(ArgChangedata,"^",2)
	s CurrentCode = $p(ArgChangedata,"^",3)
	s Original= $p(ArgChangedata,"^",4)
	
	s LogObj = ##class(EMRinstance.SubjectLog).%New()
	s LogObj.PateintID = ArgPateintID
	s LogObj.SaveUser = ArgUserID
	s LogObj.SaveCode = Code
	s LogObj.SaveOriginal = Original
	s LogObj.SaveCurrent = Current
	s LogObj.SaveCurrentCode = CurrentCode
	s LogObj.SaveDate = $zd($p($H,",",1),3)
	s LogObj.SaveTime = $zt($p($H,",",2),1)
	s LogObj.SaveIP = ArgIPaddress

    s sc = LogObj.%Save()

    if $system.Status.IsError(sc) 		//检查Save是否成功
	{                               
		d $system.OBJ.DisplayError(sc) 
		set ReturnValue = -1
	}
	else
	{
		//医生站更新基本信息  add by lina  2017-03-16
		set OldDataObject=##class(web.DHCBL.Patient.DHCPatientUpdateLog).GetLogData("User.PAPatMas"_$c(2)_ArgPateintID_"^"_"User.PAPerson"_$c(2)_ArgPateintID)
		set flag=##class(web.DHCBL.Patient.DHCPatientUpdateLog).SaveUpdLog(ArgOldDataObject,"User.PAPatMas"_$c(2)_ArgPateintID_"^"_"User.PAPerson"_$c(2)_ArgPateintID,ArgUserID)
		if (flag '= 0)
		{
			set ReturnValue = -1
		}else
		{
			set ReturnValue = 1
		}
	}
	d LogObj.%Close()
	s LogObj = ""
	
    q ReturnValue
}

/// Description:    自动更新电子病历订阅数据项的内容
/// Create Date:    2020-08-20
/// Return:         1:保存成功   -1：保存失败   -2：缺少参数   ""：没有自动更新的数据
/// Debug:          w ##class(EMRservice.Observer).BLAutoUpdateData("702","36440","6","220.221.218.235","26","SAVE")
ClassMethod BLAutoUpdateData(ArgPatientId As %String, ArgEpisodeId As %String, ArgUserId As %String, ArgIPaddress As %String, ArgTemplateId As %String, ArgAction As %String) As %String
{
    s rtn = ""
    q:(ArgPatientId = "")||(ArgEpisodeId = "")||(ArgTemplateId = "")||(ArgAction = "") -2
    s event = ArgAction_"|"_ArgTemplateId
    s result = ##class(EMRservice.Observer.Subject).GetSubjectInfo(event)
    s key = ""
    for i=1:1:result.Count()
    {
        s entity = result.GetNext(.key)
        s type = entity.Type
        continue:(type '= "PaPatMas")
        s code = entity.Code
        s value = ##Class(EMRservice.Observer.BOUpdateData).GetSubjectValue(ArgEpisodeId,entity)
        s current = $p(value,"^",1)
        s currentcode = $p(value,"^",2)
        s observer = ##Class(EMRservice.Observer.BOUpdateData).GetObserverValue(ArgPatientId,entity)
        continue:(current = observer)
        // 更新数据
        s changedata = code_"^"_current_"^"_currentcode_"^"_observer
        s rtn = ##class(EMRservice.Observer).BLUpdateData(ArgPatientId,changedata,ArgUserId,ArgIPaddress)
        q:(rtn '= 1)
    }
    q rtn
}

}
