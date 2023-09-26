/// 手术清点和手术护理业务类
Class CIS.AN.BL.OperCount Extends %RegisteredObject
{

/// 判断手术间的第一台手术
/// 深圳南山医院每天第一台择期手术的时间固定为7:45
/// 如果是第一台手术返回“Y”，如果不是第一台手术返回“N”
/// w ##class(CIS.AN.BL.OperCount).GetFirstArriveOper("1276","PatArriveTime")
ClassMethod GetFirstArriveOper(sheetId As %String, operDataCode As %String, baseTime As %String = "07:45") As %String
{
	set res="Y"
	set recordSheet=##class(CIS.AN.RecordSheet).%OpenId(sheetId)
	quit:(recordSheet.OperSchedule.SourceType'="B") "N"		// 非择期手术不做判断
	set operDate=##class(CIS.AN.COM.DateTime).ConvertToDate(recordSheet.OperSchedule.OperDate)
	set operRoomId=""
	set:($isobject(recordSheet.OperSchedule.OperRoom)) operRoomId=recordSheet.OperSchedule.OperRoom.%Id()
	quit:(operRoomId="") "N^手术还未安排手术间"
	
	set moduleCode=recordSheet.DataModule.Code
	set operDeptId=recordSheet.OperSchedule.OperDeptID
	set opsId=recordSheet.OperSchedule.%Id()
	set baseTimeH=##class(CIS.AN.COM.DateTime).ConvertToTimeH(baseTime,"")
	set operDataValue=##class(CIS.AN.BL.OperData).GetOperDataByCode(opsId,moduleCode,operDataCode)
	set firstTimeH=##class(CIS.AN.COM.DateTime).ConvertToTimeH(operDataValue,"")
	quit:(firstTimeH=baseTimeH) "Y"
	
	set rs=##class(%ResultSet).%New("CIS.AN.BL.OperScheduleList:FindOperScheduleList")
	set sc=rs.Execute(operDate,operDate,operDeptId,"","","","",operRoomId)
	set statusStr="^Arrange^RoomIn^RoomOut^PACUIn^PACUOut^AreaOut^Finish^"
	while(rs.Next())
	{
		set statusCode=rs.Get("StatusCode")
		continue:(statusStr '[ ("^"_statusCode_"^"))
		
		set sourceType=rs.Get("SourceType")
		// 非择期手术，不判断
		continue:(sourceType'="B")
		set curOpsId=rs.Get("OPSID")
		continue:(curOpsId=opsId)
		set operDataValue=##class(CIS.AN.BL.OperData).GetOperDataByCode(curOpsId,moduleCode,operDataCode)
		set firstTimeH=##class(CIS.AN.COM.DateTime).ConvertToTimeH(operDataValue,"")
		set:(firstTimeH=baseTimeH) res="N"
		quit:(res="N")
	}
	
	quit res
}

// s obj=##class(CIS.AN.BL.OperCount).GetOperDateTime("4230")

ClassMethod GetOperDateTime(opsId As %String) As %DynamicObject
{
	
	set operDate=##class(CIS.AN.BL.OperData).GetOperDataByCode(opsId,"AN_OPS_006","OperDate")
	set recordDate=##class(CIS.AN.BL.OperData).GetOperDataByCode(opsId,"AN_OPS_006","RecordDate")
	set operDateH=##class(CIS.AN.COM.DateTime).ConvertToDateH(operDate,"")
	set recordDateH=##class(CIS.AN.COM.DateTime).ConvertToDateH(recordDate,"")
	set baseTimeH=##class(CIS.AN.COM.DateTime).ConvertToTimeH("07:45")
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set:(operDate="") operDateH=operSchedule.OperDate
	set baseStartDTH=operSchedule.OperDate+(baseTimeH/100000)
	set baseEndDTH=operSchedule.OperDate+1+(baseTimeH/100000)
	
	
	
	set theatreInTime=##class(CIS.AN.BL.OperData).GetOperDataByCode(opsId,"AN_OPS_006","TheatreInTime")
	set:theatreInTime="/" theatreInTime=""
	set theatreInTime=$tr(theatreInTime,"：",":")
	set theatreInTimeH=##class(CIS.AN.COM.DateTime).ConvertToTimeH(theatreInTime,"")
	set theatreInDTH=operDateH+(theatreInTimeH/100000)
	
	set theatreOutTime=##class(CIS.AN.BL.OperData).GetOperDataByCode(opsId,"AN_OPS_006","TheatreOutTime")
	set:theatreOutTime="/" theatreOutTime=""
	set theatreOutTime=$tr(theatreOutTime,"：",":")
	set theatreOutTimeH=##class(CIS.AN.COM.DateTime).ConvertToTimeH(theatreOutTime,"")
	set theatreOutDTH=operDateH+(theatreOutTimeH/100000)

	if (recordDateH>operDateH)&(theatreInDTH<baseStartDTH)
	{
		set theatreInDTH=recordDateH+(theatreInTimeH/100000)	
	}
	if (theatreOutDTH<theatreInDTH)
	{
		set theatreOutDTH=operDateH+1+(theatreOutTimeH/100000)	
	}
	
	set operStartTime=##class(CIS.AN.BL.OperData).GetOperDataByCode(opsId,"AN_OPS_006","OperStartTime")
	set:operStartTime="/" operStartTime=""
	set operStartTime=$tr(operStartTime,"：",":")
	set operStartTimeH=##class(CIS.AN.COM.DateTime).ConvertToTimeH(operStartTime,"")
	set operStartDTH=operDateH+(operStartTimeH/100000)
	
	set operFinishTime=##class(CIS.AN.BL.OperData).GetOperDataByCode(opsId,"AN_OPS_006","OperFinishTime")
	set:operFinishTime="/" operFinishTime=""
	set operFinishTime=$tr(operFinishTime,"：",":")
	set operFinishTimeH=##class(CIS.AN.COM.DateTime).ConvertToTimeH(operFinishTime,"")
	set operFinishDTH=operDateH+(operFinishTimeH/100000)
	
	if (recordDateH>operDateH)&(operStartDTH<baseStartDTH)
	{
		set operStartDTH=recordDateH+(operStartTimeH/100000)	
	}
	if (operFinishDTH<operStartDTH)
	{
		set operFinishDTH=operDateH+1+(operFinishTimeH/100000)	
	}
	
	set anaStartTime=##class(CIS.AN.BL.OperData).GetOperDataByCode(opsId,"AN_OPS_006","AnaStartTime")
	set:anaStartTime="/" anaStartTime=""
	set anaStartTimeH=##class(CIS.AN.COM.DateTime).ConvertToTimeH(anaStartTime,"")
	set anaStartDTH=operDateH+(anaStartTimeH/100000)
	if (recordDateH>operDateH)&(anaStartDTH<baseStartDTH)
	{
		set anaStartDTH=recordDateH+(anaStartTimeH/100000)	
	}
	
	set rowData=##class(%DynamicObject).%New()
	set theatreInDateH=$p(theatreInDTH,".",1),theareInTimeH=(theatreInDTH-theatreInDateH)*100000
	set rowData.TheatreInDT=$zdt(theatreInDateH_","_theatreInTimeH,3)
	
	set theatreOutDateH=$p(theatreOutDTH,".",1),theareOutTimeH=(theatreOutDTH-theatreOutDateH)*100000
	set rowData.TheatreOutDT=$zdt(theatreOutDateH_","_theatreOutTimeH,3)
	
	set rowData.TheatreDuration=""
	if (theatreInDTH>0)&(theatreOutDTH>0)&(theatreOutDTH>theatreInDTH)
	{
		set rowData.TheatreDuration=##class(CIS.AN.COM.DateTime).CalculateDurationSNew(rowData.TheatreInDT,rowData.TheatreOutDT,"H")
		set rowData.TheatreDuration=$fn(rowData.TheatreDuration,"",2)_"h"		
	}
	
	set operStartDateH=$p(operStartDTH,".",1),operStartTimeH=(operStartDTH-operStartDateH)*100000
	set rowData.OperStartDT=$zdt(operStartDateH_","_operStartTimeH,3)
	
	set operFinishDateH=$p(operFinishDTH,".",1),operFinishTimeH=(operFinishDTH-operFinishDateH)*100000
	set rowData.OperFinishDT=$zdt(operFinishDateH_","_operFinishTimeH,3)
	
	set rowData.OperDuration=""
	if (operStartDTH>0)&(operFinishDTH>0)&(operStartDTH<operFinishDTH)
	{
		set rowData.OperDuration=##class(CIS.AN.COM.DateTime).CalculateDurationSNew(rowData.OperStartDT,rowData.OperFinishDT,"H")
		set rowData.OperDuration=$fn(rowData.OperDuration,"",2)_"h"	
	}
	
	
	set anaStartDateH=$p(anaStartDTH,".",1),anaStartTimeH=(anaStartDTH-anaStartDateH)*100000
	set rowData.AnaStartDT=$zdt(anaStartDateH_","_anaStartTimeH,3)
	
	set rowData.AnaDuration=""
	if (anaStartDTH>0)&(theatreOutDTH>0)&(anaStartDTH<theatreOutDTH)
	{
		set rowData.AnaDuration=##class(CIS.AN.COM.DateTime).CalculateDurationSNew(rowData.AnaStartDT,rowData.TheatreOutDT,"H")	
		set rowData.AnaDuration=$fn(rowData.AnaDuration,"",2)_"h"
	}
	
	quit rowData
}

}
