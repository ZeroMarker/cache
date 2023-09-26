Class web.DHCANService Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "AnInterface";

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://tempuri.org";

/*

/// 取科室字典信息
ClassMethod GetDeptDict(inPut As %String) As %GlobalCharacterStream [ WebMethod ]
{
	Quit ##class(web.DHCANAdaptor).GetDeptDict(inPut)
}


/// 取工作人员字典信息
ClassMethod GetHisUsers(inPut As %String) As %GlobalCharacterStream [ WebMethod ]
{
	Quit ##class(web.DHCANAdaptor).GetHisUsers(inPut)
}


/// 取病人基本信息
ClassMethod GetPatientMasterIndex(PatientID As %String) As %String [ WebMethod ]
{
	Quit ##class(web.DHCANAdaptor).GetPatientMasterIndex(PatientID)
}
*/

// ClassMethod GetInPatientInfo(VisitID As %String) As %String [ WebMethod ]

// {

// 	Quit ##class(web.DHCANAdaptor).GetInPatientInfo(VisitID)

// }

/*

/// 取手术申请预约信息
/// ScheduleDateStart 20080517
ClassMethod GetOperationSchedule(ScheduleDateStart As %String, ScheduleDateStop As %String, PerformedCode As %String, OperStatus As %String) As %GlobalCharacterStream [ WebMethod ]
{
	Quit ##class(web.DHCANAdaptor).GetOperationSchedule(ScheduleDateStart, ScheduleDateStop, PerformedCode, OperStatus)
}


/// 取申请手术名称信息
ClassMethod GetOperationScheduleName(ScheduleID As %String) As %String [ WebMethod ]
{
	Quit ##class(web.DHCANAdaptor).GetOperationScheduleName(ScheduleID)
}


/// 更新手术状态信息
ClassMethod UpdateOperStatus(ScheduleID As %String, OperStatus As %String) As %String [ WebMethod ]
{
	Quit ##class(web.DHCANAdaptor).UpdateOperStatus(ScheduleID, OperStatus)

}*/

// 电子病历接口

ClassMethod GetLocOperPatInfo(stdate As %String, enddate As %String, EpisodeID As %String, ctlocId As %String) As %GlobalCharacterStream [ WebMethod ]
{
	Quit ##class(web.DHCANAdaptor).GetANOperation(stdate,enddate,EpisodeID,ctlocId)
}

// ClassMethod GetLocOperPatInfo(ctlocId As %String, date As %String) As %GlobalCharacterStream [ WebMethod ]

// {

// 	Quit ##class(web.DHCANAdaptor).GetLocOperPatInfo(ctlocId,date)

// }

/// 插入手术排班信息
ClassMethod InsertANOpArrange(opaStr As %String, anaStr As %String, anaopStr As %String, assDocStr As %String, arrStr As %String, operStr As %String) As %String [ WebMethod ]
{
	//s dataPara="HR#2009-3-11#10:0#V#1#315###"
	//Quit ##class(web.DHCANAdaptor).InsertANOrder(opaId,icuaId,equipId,anoSource,userId,dataPara)
	Quit ##class(web.DHCANAdaptor).InsertAnopApply(opaStr,anaStr,anaopStr,assDocStr,arrStr,operStr)
}

/// 手术排班通用接口
ClassMethod GetANOperation(stdate As %String, enddate As %String, EpisodeID As %String = "", ctlocId As %String = "", opastatus As %String = "", operLocCodeOrDesc As %String = "", opId As %String = "") As %GlobalCharacterStream [ WebMethod ]
{
	Quit ##class(web.DHCANAdaptor).GetANOperation(stdate,enddate,EpisodeID,ctlocId,opastatus,operLocCodeOrDesc,opId)
}

ClassMethod GetANOperCRFInfo(opaId As %String, inputKey As %String = "") As %GlobalCharacterStream [ WebMethod ]
{
	Quit ##class(web.DHCANAdaptor).GetAnOpCRFInfo(opaId,inputKey)
}

ClassMethod GetPatInfo(pId As %String = "", type = "") As %String [ WebMethod ]
{
	Quit ##class(web.DHCANAdaptor).GetPatInfo(pId,type)
}

/// 获取当日手术间内手术:MD2704.01.01
ClassMethod GetOperDetailsByRoomId(opRoomId As %String) As %GlobalCharacterStream [ WebMethod ]
{
	Quit ##class(web.DHCANAdaptor).GetOperDetailsByRoomId(opRoomId)
}

/// 通过手术执行室Id查询当日手术信息:MD2703.01.01
ClassMethod GetOperDetailsByAppLocId(OperLocId As %String) As %GlobalCharacterStream [ WebMethod ]
{
	//Quit ##class(web.DHCANAdaptor).GetOperDetailsByAppLocId(OperLocId)
	Quit ##class(web.DHCANAdaptor).GetOperDetailsBySSSLocId(OperLocId)
}

/// 查询当日手术间占用信息:MD2701.01.01
ClassMethod GetOpRoomStat(hospitalId As %String = "") As %GlobalCharacterStream [ WebMethod ]
{
	Quit ##class(web.DHCANAdaptor).GetOpRoomStat(hospitalId)
}

/// 查询所有手术室信息:MD2702.01.01
ClassMethod GetAllOperDept(hospitalId As %String = "") As %GlobalCharacterStream [ WebMethod ]
{
	Quit ##class(web.DHCANAdaptor).GetAllOperDept(hospitalId)
}

/// +MD2702.01.02+查询某手术室当天手术及手术间情况
ClassMethod GetDeptOperInfo(operCurLocId As %String) As %GlobalCharacterStream [ WebMethod ]
{
	Quit ##class(web.DHCANAdaptor).GetDeptOperInfo(operCurLocId)
}

ClassMethod GetOrcDocOper(str As %String) As %String [ WebMethod ]
{
	Quit ##class(web.DHCANAdaptor).GetOrcDocOper(str)
}

ClassMethod GetCurPatient(type, equipId, patientId) As %String [ WebMethod ]
{
	i patientId=$c(0) s patientId=""
	i equipId=$c(0) s equipId=""
	i patientId=$c(0) s patientId=""
	i type=$c(0) s type=""
	set res=""
	try
	{
		if (equipId="")
		{
			set res=##class(web.DHCANAdaptor).GetPatInfo(patientId,type)
			//quit "李三^2021-07-21^男^ICU^Room1^Bed01"
			//quit "patName^birthDay^gender"
		}
		else 
		{
			i type="B" s res=##class(web.DHCBPCom).GetPatInfo(patientId,equipId)
			e  i type="I" s res=##class(web.DHCICUDeviceTask).GetPatInfo(patientId,equipId)
			e  i type="A" s res=##class(web.DHCANDeviceTask).GetPatInfo(patientId,taskId) // 以后记得改!!!
		}
	}
	catch
    {
	    s res=$ZERROR
	    s ^DHCANICUDEBUG("GetCurPatient",$h,"Error")=equipId_" "_retStr
    }
    quit res
}

/// Creator：      	dtj
/// CreatDate：    	2017-3-14
/// Description： 	保存数据
/// Table：        	DHC_ICU_DeviceData,DHC_ICU_Device,DHC_ICU_BedDevice
/// Input：        	source: 来源 I: ICU, A:手麻,B:血透      //  PE:体检,EM:急诊(旧:QR)
///                 taskId: 任务ID 在HIS端为设备号
/// 			   	dataPara: 数据
///                 extInfo: 扩展信息
/// Output：       
/// Return：       	0-正常，其他-异常返回信息
ClassMethod AddData(source, taskId, dataPara, extInfo, patientId) As %String [ WebMethod ]
{
	
	if source=$c(0) s source=""
	if taskId=$c(0) s taskId=""
	if dataPara=$c(0) s dataPara=""
	if extInfo=$c(0) s extInfo=""
	if source="" 
	{
	    quit "source is null"
	}
	if taskId="" 
	{
	    quit "equipId is null"
	}
	try
	{	
		s dStr=$zd($p($h,",",1))
		s iDate=+($p(dStr,"/",2))
		s time=$p($h,",",2)
		s hour=time\3600
		s min=(time-(hour*3600))\60
		s sec=time-(hour*3600)-(min*60)
		s sub="" s i=1
		f  s sub=$O(^DHCANICUDEBUG("InsertToOrder",source,taskId,iDate,hour,min,sec,sub)) q:sub=""  d
		.s i=i+1
		s ^DHCANICUDEBUG("InsertToOrder",source,taskId,iDate,hour,min,sec,i)=$zt(time)_"=>"_source_","_taskId_","_source_","_extInfo_","_","_dataPara
		;手麻ICU
		s retStr="InvalidSource"
		// A:手麻,I:ICU,S:共享设备(根据病人信息识别)
		i (source="A") s retStr=##class(web.DHCANDeviceData).InsertANOrder(equipId, userId, dataPara, status)
		e  i (source="I") s retStr=##class(web.DHCICUDeviceData).InsertToDb(taskId,dataPara,extInfo)
		;e  i (source="S") s retStr=##class(web.DHCICUCom).InsertShareDev(equipId,source,extInfo,dataPara,status)
		;e  i (source="B") s retStr=##class(web.DHCBPCom).InsertToDb(icuaId,equipId,extInfo,dataPara,status)
		;e  i (source="Pump") s retStr=##class(web.DHCICUPump).InsertToDb(equipId,extInfo,dataPara,status)
		s ^DHCANICUDEBUG("InsertToOrder",source,taskId,iDate,hour,min,sec,i,"res")=retStr
		w "-->",!
		set res="<![CDATA["_retStr_"]]>"
   }
   catch
   {	
		s retStr=$ZERROR
		s ^DHCANICUDEBUG("InsertToOrder",source,taskId,iDate,hour,min,sec,i,"res")=retStr
		s retStr=##class(web.DHCClinicCom).Replace(retStr,"<","(")
		s retStr=##class(web.DHCClinicCom).Replace(retStr,">",")")
		w "-->",!
		set res="<![CDATA["_retStr_"]]>"
   }
   quit res
}

ClassMethod PushTaskStatus(source, equipId, lastRecvPacketDataTime, lastRecvValidDataTime) As %String [ WebMethod ]
{
	set ^TempDebug("Para")=source_","_equipId_","_lastRecvPacketDataTime_","_lastRecvValidDataTime
	set res=""
	if (source="A")
	{
		try
		{
			set res=##class(CIS.AN.BL.DeviceStatus).SaveStatus(equipId, lastRecvPacketDataTime, lastRecvValidDataTime)
		}
		catch
		{
			set ^TempDebug("PushTaskStatusError")=$ZError
		}
	}
	elseif (source="I")
	{
		try
		{
			set res=##class(web.DHCICUDeviceStatus).SaveStatus(equipId, lastRecvPacketDataTime, lastRecvValidDataTime)
		}
		catch
		{
			set ^TempDebug("PushTaskStatusError")=$ZError
		}
	}
	quit res
}

ClassMethod AddDataByIP(source, ip, port, dataPara) As %String [ WebMethod ]
{
	set ^DHCANICUDEBUG("InsertToOrder",source, ip, port)=dataPara
	try
	{
		set res="-2"
		if (source="I")
		{
			s equipId=$$FindICUEquipId()
			if (equipId'="")
			{
				s res=##class(web.DHCICUDeviceData).InsertToDb(equipId,dataPara,"")
			}
			else
			{
				set res="Not Found"_ip_":"_port
			}
		}
		elseif (source="A")
		{
			s equipId=$$FindANEquipId()
			set res=##class(CIS.AN.BL.CollectData).AddData(equipId,dataPara,"")
		}
	}
	catch
	{
		set res="Eror:"_$ZERROR
	}
	quit res
FindICUEquipId()
    set equipId=""
    &sql(SELECT RowId into:equipId FROM SQLUser.DHC_ICU_Device WHERE Ip=:ip and Port=:port)
    quit equipId
	
FindANEquipId()
    set equipId=""
    &sql(SELECT Equip into:equipId FROM CF_AN.EquipCollection WHERE TcpipAddress=:ip and ComPort=:port)
    quit equipId
}

}
