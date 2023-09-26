Class CIS.AN.SRV.Assembler.OP.Arrangement Extends %RegisteredObject
{

/// 数据表名
Parameter TableName = "CIS.AN.OperSchedule";

/// 外部系统
Parameter ExternalSystem = "OPApp";

/// if debug is 1, then write console logs
Parameter DEBUG = 0;

ClassMethod Query(params As CIS.AN.DTO.ENS.Request.Arguments) As %ListOfObjects
{
	set collection=##class(%ListOfObjects).%New()
	if ..VerifyInput(params)
	{
		//查询Query，或者调用业务方法
		set list=""
		if (params.RowId'="")
		{
			set list=$lb(params.RowId)
		}
		elseif (params.ApplicationID'="")
		{
			set opsId=##class(CIS.AN.BL.DataMapping).GetInstanceID(..#TableName,params.ApplicationID,..#ExternalSystem)
			if opsId'="" set list=$lb(opsId)
		}
		elseif (params.EpisodeID'="")
		{
			set opsIdStr=##class(CIS.AN.BL.OperScheduleList).GetOpsIdListByAdm(params.EpisodeID)
			set list=$LISTFROMSTRING(opsIdStr,",")
		}
		elseif (params.RegNo'="") 
		{
			set opsIdStr=##class(CIS.AN.BL.OperScheduleList).GetOpsIdListByRegNo(params.RegNo)
			set list=$LISTFROMSTRING(opsIdStr,",")
		}
		elseif (params.MedcareNo'="") 
		{
			set opsIdStr=##class(CIS.AN.BL.OperScheduleList).GetOpsIdListByMedcareNo(params.MedCareNo)
			set list=$LISTFROMSTRING(opsIdStr,",")
		}
		elseif (params.OldID'="")
		{
			set opsId=$o(^CIS.AN.OperScheduleI("Ext"," "_params.OldID,""))
			set list=$lb(opsId)
		}
		else
		{
			set list=""
			set indexNode="OPDate"
    		//set indexNode="AppDate"
    		set startDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(params.StartDate)
    		set endDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(params.EndDate,startDateH)
			for date=startDateH:1:endDateH
		    {
		        set opsId=0
		        for
		        {
		            set opsId=$order(^CIS.AN.OperScheduleI(indexNode,date,opsId))
		            quit:(opsId="")
		            
		            set ExternalID=##class(CIS.AN.BL.DataMapping).GetExternalID(..#TableName,opsId,..#ExternalSystem)
		            continue:(ExternalID="")
		            
		            set list=list_$lb(opsId)
		        }
		    }
		}
	    
	   	if (list'="")
	    {
	        for i=1:1:$ll(list)
	        {
		        set opsId=$lg(list,i)
		        do collection.Insert(..GetInstance(opsId))
	        }
	    }
	}
	
	quit collection
}

ClassMethod VerifyInput(params As CIS.AN.DTO.ENS.Request.Arguments) As %Boolean
{
	quit 1
}

/// w ##class(CIS.AN.DTO.OP.Appointment).GetInstance(4166)
ClassMethod GetInstance(opsId As %String) As CIS.AN.DTO.OP.Arrangement
{
	set instance=##class(CIS.AN.DTO.OP.Arrangement).Create()
	
    set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
    set anaesthesia=##class(CIS.AN.BL.Anaesthesia).GetAnaesthesia(opsId)
    
    // 获取手术预约ID
    set instance.RowId=opsId
    set instance.ExternalID=##class(CIS.AN.BL.DataMapping).GetExternalID(..#TableName,opsId,..#ExternalSystem)
    set instance.ApplicationID=instance.ExternalID
    set instance.OldID=operSchedule.ExternalID
    
    // 获取手术室安排信息
    set instance.EpisodeID=operSchedule.EpisodeID
    set instance.StatusCode=operSchedule.Status.Code
   	set instance.StatusDesc=operSchedule.Status.Description
    set instance.OperRoomID=""
    set instance.OperRoom=""
    if $IsObject(operSchedule.ArrOperRoom)
    {
	    set instance.OperRoomID=operSchedule.ArrOperRoom.%Id()
	    set instance.OperRoom=operSchedule.ArrOperRoom.Description
    }
    set instance.OperSeq=operSchedule.ArrOperSeq
    set instance.ScrubNurses=##class(CIS.AN.SRV.Assembler.Base.CareProvider).GetInstanceList($LISTFROMSTRING(operSchedule.ArrScrubNurse,","))
    set instance.CirculatingNurses=##class(CIS.AN.SRV.Assembler.Base.CareProvider).GetInstanceList($LISTFROMSTRING(operSchedule.ArrCircualNurse,","))
    
    // 获取提交操作者
    set log=##class(CIS.AN.BL.OperArrange).GetLeatestLog(opsId)
    set instance.SubmitDateTime=log.Date_" "_log.Time
    set instance.SubmitUserID=log.UserID
    set instance.SubmitUser=##class(CIS.AN.COM.String).GetDescByID("User.SSUser","SSUSRName",log.UserID)
   	
   	// 获取手术执行闭环流程
   	set args=##class(CIS.AN.DTO.ENS.Request.Arguments).%New()
   	set args.ApplicationID=opsId
   	set instance.Procedures=##class(CIS.AN.SRV.Assembler.OP.Procedure).Query(args)
   	
   	quit instance
}

}
