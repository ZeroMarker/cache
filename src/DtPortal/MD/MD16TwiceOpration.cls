/// 名称: DtPortal.MD.MD16TwiceOpration
/// 描述: 二次手术服务
/// 编写者：程鹏
/// 编写日期:2018-12-28
/// 
Class DtPortal.MD.MD16TwiceOpration Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

// d ##class(%ResultSet).RunQuery("DtPortal.MD.MD16TwiceOpration","MD160101","2015-06-01","2015-06-21","")

/// Description	:	MD16.01.01 查询某月各科室二次手术数据
/// Input		:	StarDate  开始日期(格式:2018-01-01)
/// 			:	EndDate  结束日期(格式:2018-01-31)
/// 			:	HospitalId  院区ID
Query MD160101(StartDate As %String, EndDate As %String, HospitalId As %String = "") As DtPortal.Query(ROWSPEC = "ind,locID,locDesc,num") [ SqlProc ]
{
}

ClassMethod MD160101Execute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, HospitalId As %String = "") As %Status
{
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	k ^||TMPPortalMD160101
	
	set StartDate=$p(StartDate,"-",1)_"-"_$p(StartDate,"-",2)
	set EndDate=$p(EndDate,"-",1)_"-"_$p(EndDate,"-",2)
	
	//取his数据配置,是否取标识二次手术(1:取全部二次手术  2 取标识二次手术)
	//标识二次手术是指取在手术申请单中【重返手术】选【是】的患者信息
	set isBiao=##Class(DtPortal.Common.PublicService).getValueByCode("TWICEOPRATION")
	
	s dateType="byMonth"
	s kpiRule="DtPortal0008"
	s filterRule=""
	s mode="H"
	s contract=""
	s rs=##class(DHCWL.util.UniteQueryData).GetQueryDateRef("DHCWL.MKPIService.MKPIQuery:KpiQueryGrideShow",StartDate,EndDate,dateType,kpiRule,filterRule,mode,contract)

	While rs.Next(.sc) {
		If $$$ISERR(sc) Quit
		set locID=rs.Data("dimIdCol1")
		set admID=rs.Data("dimIdCol2")
		set type=rs.Data("dimIdCol3")
		continue:((isBiao=2)&&(type'="Y"))
		set hospID=$p($g(^CTLOC(locID)),"^",22)
		i HospitalId'=""  continue:hospID'=HospitalId
		
		
		set ^||TMPPortalMD160101(locID)=+$g(^||TMPPortalMD160101(locID))+1
		
	}
	
	set locID=""
	for
	{
		set locID=$o(^||TMPPortalMD160101(locID))
		quit:locID=""
		
		set num=+$g(^||TMPPortalMD160101(locID))
		
		set locDesc=$p(^CTLOC(locID),"^",2)
		set:locDesc["-" locDesc=$p(locDesc,"-",2)
		
		Set Data=$lb(ind,locID,locDesc,num)
		Set ^||CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	k ^||TMPPortalMD160101
	Quit $$$OK
}

// d ##class(%ResultSet).RunQuery("DtPortal.MD.MD16TwiceOpration","MD160102","2015-06-01","2015-06-21","")

/// Description	:	MD16.01.02 查询某月各科室二次手术数据
/// Input		:	StarDate  开始日期(格式:2018-01-01)
/// 			:	EndDate  结束日期(格式:2018-01-31)
/// 			:	LocID  科室ID
Query MD160102(StartDate As %String, EndDate As %String, LocID As %String) As DtPortal.Query(ROWSPEC = "ind,bedCode,name,sex,age,medicareNo,admReason,regNo,nurseDesc,docDesc,locDesc,wardDesc,diagnoseDesc,inDay,inDateTime,OPNum,OPName1,OPDateTime1,OPName2,OPDateTime2,EpisodeId,OpNameAndTime1,OpNameAndTime2") [ SqlProc ]
{
}

ClassMethod MD160102Execute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, LocID As %String) As %Status
{
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	//取his数据配置,是否取标识二次手术(1:取全部二次手术  2 取标识二次手术)
	//标识二次手术是指取在手术申请单中【重返手术】选【是】的患者信息
	set isBiao=##Class(DtPortal.Common.PublicService).getValueByCode("TWICEOPRATION")
	
	s dateType="byDay"
	s kpiRule="DtPortal0008"
	s filterRule="DtPortal0008:([{PatLoc} = "_LocID_"])"
	s mode="H"
	s contract=""
	s rs=##class(DHCWL.util.UniteQueryData).GetQueryDateRef("DHCWL.MKPIService.MKPIQuery:KpiQueryGrideShow",StartDate,EndDate,dateType,kpiRule,filterRule,mode,contract)

	While rs.Next(.sc) {
		If $$$ISERR(sc) Quit
		set EpisodeID=rs.Data("dimIdCol2")
		set type=rs.Data("dimIdCol3")
		continue:((isBiao=2)&&(type'="Y"))
		set OpIDStr=rs.Data("dimIdCol4")
	
		set OPName1="",OPDateTime1="",OPName2="",OPDateTime2="",OPNum=0
		
		set OpNameAndTime1="",OpNameAndTime2=""
		for index=1:1:$l(OpIDStr,"_")
		{
			set opID=$p(OpIDStr,"_",index)
			
			set opName="",opDate="",opTime="",opDateTime="",OPNum=+OPNum+1
			set OPInfo=##class(DtPortal.Common.Interface.Operation).GetOPInfo(opID)
			set opName=$p(OPInfo,"^",1)
			set opDate=$p(OPInfo,"^",2)
			set opTime=$p(OPInfo,"^",3)
			
			set:opDate'="" opDate=$zd(opDate,3)
			set:opTime'="" opTime=$zt(opTime,2)
			set opDateTime=opDate_"&nbsp;"_opTime
			if OPNum=1
			{
				set OPName1=opName
				set OPDateTime1=opDateTime
				set OpNameAndTime1=opName_"("_opDateTime_")"
			}else
			{
				set:OPName2'="" OPName2=OPName2_"<br/>"_opName,OPDateTime2=OPDateTime2_"<br/>"_opDateTime
				set:OPName2="" OPName2="<br/>"_opName,OPDateTime2="<br/>"_opDateTime
				if (OpNameAndTime2=""){
					set OpNameAndTime2="<span class=""marginR10"">"_opName_"("_opDateTime_")"_"</span>"
				}else{
					set OpNameAndTime2=OpNameAndTime2_"<span class=""marginR10"">"_opName_"("_opDateTime_")"_"</span>"
				}
			}
		}
		
		set patInfoStr=##class(DtPortal.Common.PaadmService).GetPatInfo(EpisodeID)
	 	set bedCode=$p(patInfoStr,"^",1)
	 	set name=$p(patInfoStr,"^",2)
	 	set sex=$p(patInfoStr,"^",3)
	 	set age=$p(patInfoStr,"^",4)
	 	set medicareNo=$p(patInfoStr,"^",5)   															//病案号
	 	set admReason=$p(patInfoStr,"^",6)    															//费用类型
	 	set regNo=$p(patInfoStr,"^",7)   																//登记号
	 	set nurseDesc=$p(patInfoStr,"^",12)																//主管护士
	 	set docDesc=$p(patInfoStr,"^",11)																//主管医生
		set locDesc=$p(patInfoStr,"^",9)																//科室描述
		set wardDesc=$p(patInfoStr,"^",10)																//病区描述
		set diagnoseDesc=##class(DtPortal.Common.PaadmService).GetMainDiagnosis(EpisodeID)				//诊断
		set inDay=##class(DtPortal.Common.PaadmService).getInDayByInPat(EpisodeID)						//在院天数
	    set inTimeStr=##class(DtPortal.Common.PaadmService).GetAdminDateTime(EpisodeID)					//就诊日期
	    set inDate=$p(inTimeStr,"^",1)
	    set inDate=$zd(inDate,3)
	    set inTime=$p(inTimeStr,"^",2)
	    set inTime=$zt(inTime,2)
	    set inDateTime=inDate_"&nbsp;"_inTime
		
		set Data=$lb(ind,bedCode,name,sex,age,medicareNo,admReason,regNo,nurseDesc,docDesc,locDesc,wardDesc,diagnoseDesc,inDay,inDateTime,OPNum,OPName1,OPDateTime1,OPName2,OPDateTime2,EpisodeId,OpNameAndTime1,OpNameAndTime2)
 		set ^||CacheTemp(repid,ind)=Data	
 		set ind=ind+1

		
	}
	Quit $$$OK
}

}
