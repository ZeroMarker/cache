Class CIS.AN.BL.StatisticItem Extends %RegisteredObject
{

/// Creator：      	雍阳
/// CreatDate：    	2017-12-21
/// Description： 	获取就诊相关信息
/// Table：        	
/// Input:			operScheduleId:手术安排表ID; itemId:统计项目ID
/// Return：       	1:true; 0:false; out param itemData As %List
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.StatisticItem","GetDataList",1,.itemIdList,.itemDataList)
ClassMethod GetDataList(operScheduleId, ByRef itemIdList As %List, ByRef itemDataList As %List) As %Boolean
{
	kill itemDataList
	
	set EpisodeID = $lg(^DHCAN.OperScheduleD(operScheduleId),1)
	
	set itemId=""
	for
	{
		set itemId=$o(itemIdList(itemId))
		quit:itemId=""
		
		kill itemData
		set method=$lg(^DHCANCD("StatisticItem",itemId),8)
		
		if (method = "PAT")
		{
			set success = ..GetPatientData(EpisodeID,itemId,.itemData)
		}
		elseif (method = "OPS")
		{
			set success = ..GetOperScheduleData(operScheduleId,itemId,.itemData)
		}
		elseif(method = "ANAS")
		{
			set success = ..GetAnaSheetData(operScheduleId,itemId,.itemData)
		}
		
		merge itemDataList(itemId,"Data")=itemData
	}
	
	quit 1
}

/// Creator：      	雍阳
/// CreatDate：    	2017-12-21
/// Description： 	获取就诊相关信息
/// Table：        	PAAdm,PAPatMas
/// Input:			operScheduleId:手术安排表ID; itemId:统计项目ID
/// Return：       	1:true; 0:false; out param itemData As %List
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.StatisticItem","GetPatientData", 65218, 2,.itemData)
ClassMethod GetPatientData(EpisodeID, itemId, ByRef itemData As %List) As %Boolean
{
	set papmiId = $p($g(^PAADM(EpisodeID)),"^",1)
	set value="",text = ""
	set itemCode = $lg(^DHCANCD("StatisticItem",itemId),1)
	if itemCode="RegNo"   //登记号
	{
   		set text=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
   		set itemData(1)=$lg("",text,text)
	}
	elseif itemCode="EpisodeID"   //就诊号
	{
   		set itemData(1)=$lg("",EpisodeID,EpisodeID)
	}
	elseif itemCode="MedCareNo"   //病案号
	{
		set ErrMsg = ""
		//set text = ##Class(web.DHCWMRService).IGetMrNoByEpisodeID(EpisodeID,.ErrMsg)
        set MedType=$P(^PAADM(EpisodeID),"^",2)
	    set text=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,MedType,.ErrMsg)
		set itemData(1)=$lg("",text,text)
	}
	elseif itemCode="PersonID"   //身份证号
	{
   		set text=$p($g(^PAPER(papmiId,"ALL")),"^",9)
   		set itemData(1)=$lg("",text,text)
	}
	elseif itemCode="PatName"   //姓名
	{
   		set text=$p($g(^PAPER(papmiId,"ALL")),"^",1)
   		set itemData(1)=$lg("",text,text)
	}
	elseif itemCode="Birth"   //生日
	{
   		set text=$p($g(^PAPER(papmiId,"ALL")),"^",6)
   		set itemData(1)=$lg("",text,text)
	}
	elseif itemCode="Sex"   //性别
	{
   		set sexId=$p($g(^PAPER(papmiId,"ALL")),"^",7)
   		set text=$p($g(^CT("SEX",+sexId)),"^",2)
   		set itemData(1)=$lg("",sexId,text)
	}
	elseif itemCode="AdmDateTime"   //入院日期时间
	{
		set admDate=$p($g(^PAADM(EpisodeID)),"^",6)
		set admTime=$p($g(^PAADM(EpisodeID)),"^",7)
   		set text=$zd(admDate,3)_" "_$zt(admTime)
   		set itemData(1)=$lg("",admDate_","_admTime,text)
	}
	elseif itemCode="VisitStatus"   //就诊状态
	{
   		set value=$p($g(^PAADM(EpisodeID)),"^",20)
   		set text=$s(value="A":"在院",value="C":"取消住院",value="D":"出院",value="P":"预约",1:"无")
   		set itemData(1)=$lg("",value,text)
	}
	elseif itemCode="DischargeDateTime"   //出院日期时间
	{
		set dischargeDate=$p($g(^PAADM(EpisodeID)),"^",17)
		set dischargeTime=$p($g(^PAADM(EpisodeID)),"^",18)
		set value=dischargeDate_","_dischargeTime
   		set text=$zd(dischargeDate,3)_" "_$zt(dischargeTime)
   		set itemData(1)=$lg("",value,text)
	}
	elseif itemCode="DoctorInCharge"   //主管医生
	{
   		set value=$p($g(^PAADM(EpisodeID)),"^",9)
   		set text=##class(CIS.AN.COM.String).GetDescByID("User.CTCareProv","CTPCPDesc",value)
   		set itemData(1)=$lg("",value,text)
	}
	elseif itemCode="AdmType"   //就诊类型
	{
   		set value=$p($g(^PAADM(EpisodeID)),"^",2)
   		set text=$s(value="I":"住院",value="O":"门诊",value="E":"急诊",value="N":"新生",value="H":"体检",1:"无")
   		set itemData(1)=$lg("",value,text)
	}
	elseif itemCode="AdmOutPatLoc"   //住院前门诊科室
	{
		set IPBookid=$o(^DHCDocIPBK(0,"EpisodeIDTo",EpisodeID,""))
    	set value=$p($g(^DHCDocIPBK(+IPBookid)),"^",11)
   		set text=$p($g(^CTLOC(+value)),"^",2)
   		set itemData(1)=$lg("",value,text)
	}
	elseif itemCode="DischargeLoc"   //出院科室
	{
   		set value=$p($g(^PAADM(EpisodeID)),"^",4)
   		set text=$p($g(^CTLOC(+value)),"^",2)
   		set itemData(1)=$lg("",value,text)
	}
	
	quit 1
}

/// Creator：      	雍阳
/// CreatDate：    	2017-12-21
/// Description： 	获取手术安排相关信息
/// Table：        	DHCAN.OperSchedule
/// Input:			operScheduleId:手术安排表ID; 
/// 				itemId:统计项目ID
/// Return：       	1:true;
/// 				0:false;
/// 				out param itemData As %List
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.StatisticItem","GetOperScheduleData")
ClassMethod GetOperScheduleData(operScheduleId, itemId, ByRef itemData As %List) As %Boolean
{
	set itemCode = $lg(^DHCANCD("StatisticItem",itemId),1)
	if (itemCode = "OperStatus")   //手术状态
	{
		set value=$lg(^DHCAN.OperScheduleD(operScheduleId),9)
		set text=$lg(^DHCANCD("OperStatus",+value),2)
		set itemData(1)=$lb("",value,text)
	}
	elseif (itemCode = "OperScheduleId")    //手术安排ID
	{
		set itemData(1)=$lb("",operScheduleId,operScheduleId)
	}
	elseif itemCode="Age"   //年龄
	{
		set EpisodeID = $lg(^DHCAN.OperScheduleD(operScheduleId),1)
		set papmiId = $p($g(^PAADM(EpisodeID)),"^",1)
		set operDate=$lg(^DHCAN.OperScheduleD(operScheduleId),24)
		set birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
		set value=operDate-birth
   		set text=##class(CIS.AN.COM.DateTime).CalAge(birth,operDate,0)
   		set itemData(1)=$lg("",value,text)
   		
   		/*--设置字段值--*/
   		set text=##class(CIS.AN.COM.DateTime).CalAge(birth,operDate,0,"D")
   		set itemDate(1,"Day")=$lg("",+text,text)
   		set text=##class(CIS.AN.COM.DateTime).CalAge(birth,operDate,0,"M")
   		set itemDate(1,"Month")=$lg("",+text,text)
   		set text=##class(CIS.AN.COM.DateTime).CalAge(birth,operDate,0,"Y")
   		set itemDate(1,"Year")=$lg("",+text,text)
	}
	elseif (itemCode = "SourceType")    //急诊择期
	{
		set value=$lg(^DHCAN.OperScheduleD(operScheduleId),41)
		set text=$s(value="B":"择期",value="E":"急诊")
		set itemData(1)=$lb("",value,text)
	}
	elseif (itemCode = "AdmOPDateDuration")    //手术前住院天数
	{
		set EpisodeID = $lg(^DHCAN.OperScheduleD(operScheduleId),1)
		set admDate=$p($g(^PAADM(EpisodeID)),"^",6)
		set operDate=$lg(^DHCAN.OperScheduleD(operScheduleId),24)
		set value=operDate-admDate
		set text=value_"天"
		set itemData(1)=$lb("",value,text)
	}
	elseif (itemCode = "AppLoc")    //申请科室
	{
		set value=$lg(^DHCAN.OperScheduleD(operScheduleId),3)
		set text=$p($g(^CTLOC(+value)),"^",2)
		set itemData(1)=$lb("",value,text)
	}
	elseif (itemCode = "SurgeonLoc")    //术者科室
	{
		set operListId=""
		for
		{
			set operListId=$o(^DHCAN.OperationListI("OPS",operScheduleId,operListId))
			quit:operListId=""
			
			set value=$lg(^DHCAN.OperationListD(operListId),10)
			set text=$p($g(^CTLOC(+value)),"^",2)
			set itemData(operListId)=$lb(operListId,value,text)
		}
	}
	elseif (itemCode = "Hospital")    //医院名称
	{
		//set itemData()
	}
	elseif (itemCode = "Operation")    //手术名称
	{
		set operListId=""
		for
		{
			set operListId=$o(^DHCAN.OperationListI("OPS",operScheduleId,operListId))
			quit:operListId=""
			
			set value=$lg(^DHCAN.OperationListD(operListId),2)
			set text=$lg(^DHCANCD("Operation",+value),2)
			set itemData(operListId)=$lb(operListId,value,text)
		}
	}
	elseif (itemCode = "Surgeon")
	{
		set operListId=""
		for
		{
			set operListId=$o(^DHCAN.OperationListI("OPS",operScheduleId,operListId))
			quit:operListId=""
			
			set value=$lg(^DHCAN.OperationListD(operListId),8)
			set text=##class(CIS.AN.COM.String).GetDescByID("User.CTCareProv","CTPCPDesc",value)
			set itemData(operListId)=$lb(operListId,value,text)
		}
	}
	
	quit 1
}

/// Creator：      	雍阳
/// CreatDate：    	2017-12-21
/// Description： 	获取麻醉表单信息
/// Table：        	DHCAN.SheetRecord
/// Input:			itemId:统计项目ID
/// Return：       	1:true;0:false; out param itemData As %List
/// d ##class(%ResultSet).RunQuery("DHCAN.DataQuery","FindOperClass")
ClassMethod GetAnaSheetData(operScheduleId, itemId, ByRef itemData As %List) As %Boolean
{
}

/// w ##class(CIS.AN.BL.StatisticItem).Test()
ClassMethod Test() As %String
{
	kill itemData
	set success=..GetPatientData(1,1,.itemData)
	
	zw itemData
	quit "1"
}

}
