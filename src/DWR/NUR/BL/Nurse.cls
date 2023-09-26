/// 护理数据
Class DWR.NUR.BL.Nurse Extends %RegisteredObject
{

/// 三测单数据查询
ClassMethod ThreeSTDataQry(RtStream As %GlobalCharacterStream) As %GlobalCharacterStream
{
	set $ZT="ThreeSTDataQryET"
	set pResponse=##Class(DWR.NUR.MSG.ThreeSTDataQryRp).%New()

	set reader = ##class(%XML.Reader).%New()
	set sc=reader.OpenStream(RtStream)
	If $$$ISERR(sc) 
	{
		do Output("100","HIS接收到的入参数据格式有误"_sc)
	    Quit RpStream
	}
	Do reader.Correlate("Request","DWR.NUR.MSG.ThreeSTDataQryRt")
	if (reader.Next(.pRequest,.sc))
	{   
	}
	if ('$IsObject(pRequest))
	{
		do Output("100","HIS接收到的入参数据格式有误")
	    Quit RpStream
	}
	
	
	set pResponse=..ThreeSTDataQryExe(pRequest)
	do Output(pResponse.ResultCode,pResponse.ResultContent)
	
	quit RpStream
	
Output(ResultCode,ResultContent)
	set RpStream=""
	set pResponse.ResultCode=ResultCode
	set pResponse.ResultContent=ResultContent
	set RtStream=##class(%GlobalCharacterStream).%New()
	do pResponse.XMLExportToStream(.RpStream,"Response")
	quit
ThreeSTDataQryET
	set pResponse=##Class(DWR.NUR.MSG.ThreeSTDataQryRp).%New()
	do Output("-100","HIS端错误："_$ZERROR)
	quit RpStream
}

ClassMethod ThreeSTDataQryExe(Rt As DWR.NUR.MSG.ThreeSTDataQryRt) As DWR.NUR.MSG.ThreeSTDataQryRp
{
	set $ZT="ThreeSTDataQryExeET"
	set ResultCode="100"
	set ResultContent="没有查询到医嘱记录"
	set Rp=##Class(DWR.NUR.MSG.ThreeSTDataQryRp).%New()
	set EpisodeID=Rt.EpisodeID
	set StartDate=Rt.StartDate
	if (StartDate'="") set StartDate=$ZDateH(StartDate,3)
	set EndDate=Rt.EndDate
	if (EndDate'="") set EndDate=$ZDateH(EndDate,3)
	if (EpisodeID="")
	{
		do OutputResult("101","就诊ID不能为空")
	    Quit Rp
	}
	if ('$data(^PAADM(EpisodeID)))
	{
		do OutputResult("106","就诊ID不存在")
    	quit Rp
	}
	
	set PatientID=$piece($get(^PAADM(EpisodeID)),"^",1)
	set PatRt=##Class(DWR.PAT.MSG.PatientQryRt).%New()
	set PatRt.PatientID=PatientID
	set PatRp=##Class(DWR.PAT.MSG.PatientQryRp).%New()
	set PatRp=##Class(DWR.PAT.BL.Patient).PatientQryExe(PatRt)
	if (PatRp.PatientList.Count()=0)
	{
		do OutputResult("102","没有在院的就诊记录")
	    Quit Rp
	}
	set myPatObj=PatRp.PatientList.GetAt(1)
	set Rp.PatientID=myPatObj.PatientID
	set Rp.PatientNo=myPatObj.PatientNo
	set Rp.PatientName=myPatObj.PatientName
	set Rp.Sex=myPatObj.Sex
	set Rp.Age=myPatObj.Age
	set Rp.InDate=myPatObj.InDate
	set Rp.InDays=myPatObj.InDays
	set Rp.BedNo=myPatObj.BedNo
	set Rp.WardName=myPatObj.WardName
	set Rp.DepartmentName=myPatObj.DepartmentName
	set Rp.Doctor=myPatObj.Doctor
	
	
	set Week=Rt.Week
	set myrtn=..GetDateFromWeek(EpisodeID,Week)
	set myWeek=$piece(myrtn,"^",1)
	set myStartDate=$piece(myrtn,"^",2)
	set myEndDate=$piece(myrtn,"^",3)
	set myAllWeek=$piece(myrtn,"^",4)
	set Rp.Week=myAllWeek
	
	set myDay=0
	for myDate=myStartDate:1:myEndDate
	{
		set myDay=myDay+1
		set DayRowObj=##Class(DWR.NUR.MSG.ThreeSTDataDay).%New()
		
		set DayRtn=..GetThreeSTDataDay(EpisodeID,myDate,myDay,.DayRowObj)
		do Rp.ThreeSTDataList.Insert(DayRowObj)
		do DayRowObj.%Close()
	}
	set ResultCode="0"
	set ResultContent="查询成功"
	do OutputResult(ResultCode,ResultContent)
	quit Rp
	


OutputResult(ResultCode,ResultContent)
	set Rp.ResultCode=ResultCode
	set Rp.ResultContent=ResultContent
	quit
ThreeSTDataQryExeET
	set Rp=##Class(DWR.NUR.MSG.ThreeSTDataQryRp).%New()
	do OutputResult("-100","HIS端错误："_$ZERROR)
	quit Rp
}

/// 取就诊的第n周的开始日期和结束日期
ClassMethod GetDateFromWeek(EpisodeID As %String, Week As %String) As %String
{
	set myrtn=""
	set myAdmDate=+$piece($get(^PAADM(EpisodeID)),"^",6)
	set myToday=+$Horolog
	set myInDays=myToday-myAdmDate+1
	set DaysofWeek=7
	set myWeek=+Week
	set myAllWeek=(myInDays\DaysofWeek)+1
	if (myWeek=0)
	{
		set myWeek=myAllWeek
	}
	
	set myStartDate=myAdmDate+((myWeek-1)*DaysofWeek)
	set myEndDate=myAdmDate+(myWeek*DaysofWeek)-1
	
	set myrtn=myWeek_"^"_myStartDate_"^"_myEndDate_"^"_myAllWeek
	quit myrtn
}

/// 取三测单一天的数据
ClassMethod GetThreeSTDataDay(EpisodeID As %String, myDate As %String, myDay As %String, ByRef DayRowObj As DWR.NUR.MSG.ThreeSTDataDay) As %String
{
	set myrtn=""
	set MRAdm=$piece($get(^PAADM(EpisodeID)),"^",61)
	set myAdmDate=+$piece($get(^PAADM(EpisodeID)),"^",6)
	set myInDays=myDate-myAdmDate+1
	set DataDate=..FormatThreeSTDate(myDate,myInDays,myDay)
	set DaysAfterSurgery=""
	set DayRowObj.WeekDay=myDay
	set DayRowObj.DataDate=DataDate
	set DayRowObj.InDays=myInDays
	set DayRowObj.DaysAfterSurgery=DaysAfterSurgery
	
	/// 取体温、脉搏、呼吸的数据
	set TimeNum=0
	while($order(^DHCDWRSET("NUR","ThreeSTTime",TimeNum))'="")
	{
		set TimeNum=$order(^DHCDWRSET("NUR","ThreeSTTime",TimeNum))
		set myTime=$get(^DHCDWRSET("NUR","ThreeSTTime",TimeNum))
		set myTimeH=$ZTimeH(myTime,2)
		
		set TemperatureCode=$get(^DHCDWRSET("NUR","ThreeSTItemCode",1))
		set TemperatureValue=..GetItemValueByCode(MRAdm,myDate,TemperatureCode,myTimeH)	
			
		set PulseCode=$get(^DHCDWRSET("NUR","ThreeSTItemCode",2))
		set PulseValue=..GetItemValueByCode(MRAdm,myDate,PulseCode,myTimeH)	
		
		set RespirationCode=$get(^DHCDWRSET("NUR","ThreeSTItemCode",3))	
		set RespirationValue=..GetItemValueByCode(MRAdm,myDate,RespirationCode,myTimeH)
		
		set TPObj=##Class(DWR.NUR.MSG.TemperaturePulse).%New()
		set TPObj.TimeNum=TimeNum
		set TPObj.Hour=+myTime
		set TPObj.Temperature=..FormatNumber(TemperatureValue)
		set TPObj.TemperatureMethod=""
		set TPObj.Pulse=..FormatNumber(PulseValue)
		set TPObj.Respiration=..FormatNumber(RespirationValue)
		do DayRowObj.TempPulseList.Insert(TPObj)
		do TPObj.%Close()
	}
	
	/// 取其它项目的数据
	set ItemNum=0
	while($order(^DHCDWRSET("NUR","ThreeSTItemCode2",ItemNum))'="")
	{
		set ItemNum=$order(^DHCDWRSET("NUR","ThreeSTItemCode2",ItemNum))
		set ItemCode=$get(^DHCDWRSET("NUR","ThreeSTItemCode2",ItemNum))
		set ItemDesc=$get(^DHCDWRSET("NUR","ThreeSTItem2",ItemNum))
		set ItemValue=..GetItemValue(MRAdm,myDate,ItemCode)
		set myObj=##Class(DWR.NUR.MSG.OtherDataOnce).%New()
		set myObj.ItemName=ItemDesc
		set myObj.ItemValue=ItemValue
		do DayRowObj.OtherDataList.Insert(myObj)
		do myObj.%Close()
	}
	set myrtn="0"
	quit myrtn
}

/// 格式化三测单中的日期格式
ClassMethod FormatThreeSTDate(myDate As %String, myInDays As %String, myDay As %String) As %String
{
	set tDate=$ZDate(myDate,3)
	set tDate2=$piece(tDate,"-",2,3)
	set tDate3=$piece(tDate,"-",3)
	if (myInDays="1") quit tDate
	if (tDate2="01-01") quit tDate
	if (myDay=1) quit tDate2
	if (tDate3="01") quit tDate2
	
	quit tDate3
}

/// 格式化数字
ClassMethod FormatNumber(myNumber As %String) As %String
{
	if (myNumber="") quit myNumber
	set myNumber=$tr(myNumber,"。",".")
	set myNumber=+myNumber
	if (myNumber=0) quit myNumber
	quit myNumber
}

/// 通过项目代码取单个项目的某一时刻的数据
ClassMethod GetItemValueByCode(MRAdm As %String, myDate As %String, ItemCode As %String, ItemTime As %String = "") As %String
{
	set ItemValue=""
	if (ItemCode'="")
	{
		set myItemID=$order(^MRC("OBITM",0,"Code",$$ALPHAUP^SSUTIL4(ItemCode),""))
		if (myItemID'="")
		{
			set ItemValue=..GetItemValueByTime(MRAdm,myDate,myItemID,ItemTime)
		}
	}
	
	quit ItemValue
}

/// 通过项目ID取单个项目的某一时刻的数据
ClassMethod GetItemValueByTime(MRAdm As %String, myDate As %String, ItemID As %String, ItemTime As %String = "") As %String
{
	set ItemValue=""
	set Sub="0"
	while($order(^MR(MRAdm,"OBS",0,"Date",myDate,ItemID,Sub))'="")
	{
		set Sub=$order(^MR(MRAdm,"OBS",0,"Date",myDate,ItemID,Sub))
		set OBSTime=$piece($get(^MR(MRAdm,"OBS",Sub)),"^",4)
		if ((ItemTime'="")&&(ItemTime'=OBSTime)) continue
		set ItemValue=$piece($get(^MR(MRAdm,"OBS",Sub)),"^",2)
	}
	
	quit ItemValue
}

/// 取项目的数据
ClassMethod GetItemValue(MRAdm As %String, myDate As %String, ItemCode As %String) As %String
{
	set ItemValue=""
	set mydel="/"
	if (ItemCode[mydel)                       // 血压   收缩压/舒张压
	{
		set mylen=$length(ItemCode,mydel)
		for i=1:1:mylen
		{
			set myval=""
			set mycode=$piece(ItemCode,mydel,i)
			set myval=..GetItemValueByCode(MRAdm,myDate,mycode,"")
			if (i=1)
			{
				set ItemValue=myval
			}
			else
			{
				set ItemValue=ItemValue_mydel_myval
			}
		}
		set ItemValue="120/80"	                    ////
	}
	elseif ((ItemCode="I")||(ItemCode="O"))            // I--入量    O--出量
	{
		set myItemID=0
		while($order(^MRC("OBITM",myItemID))'="")
		{
			set myItemID=$order(^MRC("OBITM",myItemID))
			set ItemType=$piece($get(^MRC("OBITM",myItemID)),"^",6)
			if (ItemType'=ItemCode) continue
			set myval=..GetItemValueByTime(MRAdm,myDate,myItemID,"")
			set ItemValue=(+ItemValue)+(+myval)
		}
		set ItemValue="1300"	                    ////
	}
	else
	{
		set ItemValue=..GetItemValueByCode(MRAdm,myDate,ItemCode,"")
		set ItemValue="1"	                       ////
	}
	
	if (ItemValue=0) set ItemValue=""
	quit ItemValue
}

}
