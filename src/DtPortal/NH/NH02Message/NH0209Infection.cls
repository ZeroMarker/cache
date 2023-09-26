/// ClassName:    DtPortal.NH.NH02Message.NH0209Infection
/// Description:  护士长医院感染服务
/// Creator：     chengpeng
/// CreatDate:    2014-12-4
Class DtPortal.NH.NH02Message.NH0209Infection Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     bmz--重新封装
/// CreatDate：   2018-12-13
/// Description:  查询护士长所辖病区医院感染病人详细信息
/// 服务代码：    NH02.09.01
/// Table：       DHCMed.NINF.Rep.InfReport
/// Input：       UserCode    :  护士长工号  WardId：病区id
/// Return：      病人详细信息
/// do ##class(%Library.ResultSet).RunQuery("DtPortal.NH.NH02Message.NH0209Infection","NH020901","411",10)
Query NH020901(UserCode As %String, WardId As %String) As DtPortal.Query(ROWSPEC = "Name:%String,Sex:%String,Age:%String,MedicareNo:%String,AdmReason:%String,BedNo:%String,PaadmID:%String,InfeDate:%String,InfPos:%String,RepDate:%String,RepUserName:%String,ReportStatus:%String,admDocName:%String,admNurseName:%String,diagnoseDesc:%String,inDay:%String,PAPMINo:%String")
{
}

ClassMethod NH020901Execute(ByRef qHandle As %Binary, UserCode As %String, WardId As %String) As %Status
{
	new (qHandle,UserCode,WardId)
	Q:WardId="" $$$OK
	Set repid=$I(^||CacheTemp)
	Set ind=1
	
	//判断是否有院感提供的新接口，没有的话用原来的接口
	//判断这个query是否存在
	set qdf=##class(%Dictionary.QueryDefinition).%OpenId("DHCHAI.IO.ToDtPortal03||NHInfReportPatFind")
	if $IsObject(qdf) {
		set obj=##class(%ResultSet).%New("DHCHAI.IO.ToDtPortal03:NHInfReportPatFind")
	}else{
		set obj=##class(%ResultSet).%New("DtPortal.NH.NH02Message.NH0209Infection:NH020901Old")
	}
	
	d obj.Execute(UserCode,WardId)
    f  Quit:'obj.Next()  d
	.set (Name,Sex,Age,MedicareNo,AdmReason,BedNo,EpisodeID,InfDate,InfPos,RepDate,RepUserName,ReportStatus,admDocName,admNurseName,diagnoseDesc,inDay,PAPMINo)=""
	.s InfDate=obj.Data("InfeDate")
	.s InfPos=obj.Data("InfPos")
	.s RepDate=obj.Data("RepDate")
	.s RepUserName=obj.Data("RepUserName")
	.s ReportStatus=obj.Data("ReportStatus")
	.s EpisodeID=obj.Data("PaadmID")
	.s patInfoStr=##class(DtPortal.Common.PaadmService).GetPatInfo(EpisodeID)
	
	
	.s BedNo=$p(patInfoStr,"^",1)
 	.s Name=$p(patInfoStr,"^",2)
 	.s Sex=$p(patInfoStr,"^",3)
 	.s Age=$p(patInfoStr,"^",4)
 	.s MedicareNo=$p(patInfoStr,"^",5)   //病案号
 	.s AdmReason=$p(patInfoStr,"^",6)    //费用类型
 	.s PAPMINo=$p(patInfoStr,"^",7)    //登记号
 	
 	.s admDocName=$p(patInfoStr,"^",11)
	.s admNurseName=$p(patInfoStr,"^",12)
	.s diagnoseDesc=##class(DtPortal.Common.PaadmService).GetMainDiagnosis(EpisodeID)
	.s inDay=##class(DtPortal.Common.PaadmService).getInDayByInPat(EpisodeID)
	
    .s inTimeStr=##class(DtPortal.Common.PaadmService).GetAdminDateTime(EpisodeID)
    .s inDate=$p(inTimeStr,"^",1)
    .s inDate=$zd(inDate,3)
    .s inTime=$p(inTimeStr,"^",2)
    .s inTime=$zt(inTime,2)
    .s inDateTime=inDate_"&nbsp;"_inTime
	.Do OutInfoRow
	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutInfoRow
	set Data=$lb(Name,Sex,Age,MedicareNo,AdmReason,BedNo,EpisodeID,InfDate,InfPos,RepDate,RepUserName,ReportStatus,admDocName,admNurseName,diagnoseDesc,inDay,PAPMINo)
 	Set ^||CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

/// Creator：     chengpeng
/// CreatDate：   2014-12-4
/// Description:  查询护士长所辖病区医院感染病人详细信息
/// 服务代码：    NH02.09.01
/// Table：       DHCMed.NINF.Rep.InfReport
/// Input：       UserCode    :  护士长工号
/// Return：      病人详细信息
/// do ##class(%Library.ResultSet).RunQuery("DtPortal.NH.NH02Message.NH0209Infection","NH020901Old","2156","10")
Query NH020901Old(UserCode As %String, WardId As %String) As DtPortal.Query(ROWSPEC = "Name:%String,Sex:%String,Age:%String,MedicareNo:%String,AdmReason:%String,BedNo:%String,PaadmID:%String,InfeDate:%String,InfPos:%String,RepDate:%String,RepUserName:%String,ReportStatus:%String,admDocName:%String,admNurseName:%String,diagnoseDesc:%String,inDay:%String,PAPMINo:%String")
{
}

ClassMethod NH020901OldExecute(ByRef qHandle As %Binary, UserCode As %String, WardId As %String) As %Status
{
	new (qHandle,UserCode,WardId)
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	Q:WardId="" $$$OK
	set PatPaadmIDList=##class(DtPortal.Common.PaadmService).GetIPPaadmList("ward","",WardId)
	Q:PatPaadmIDList="" $$$OK
	Set WarldLocId=$p($g(^PAWARD(WardId)),"^",5)
	Q:WarldLocId="" $$$OK
	set WarldDesc=$p($g(^CTLOC(WarldLocId)),"^",2)
	set:WarldDesc'="" WarldDesc=$p(WarldDesc,"-",2)
	for i=1:1:$l(PatPaadmIDList,"^")
	{
		set PaadmID=$p(PatPaadmIDList,"^",i)
		
		set InfReportID=""
		for
		{
			set InfReportID=$o(^DHCMed.NINFi("InfRep","0","IndexPaadm",PaadmID,InfReportID))
			quit:InfReportID=""
			
			set objInfReport=##class(DHCMed.NINF.Rep.InfReport).GetObjById(InfReportID)
			continue:'$IsObject(objInfReport)
			set ReportStatus=objInfReport.ReportStatus.Description				//报告状态
			
			continue:ReportStatus["删除"
			continue:ReportStatus["退回"
			set ReportLoc=objInfReport.ReportLoc
			set LocDesc=$p($g(^CTLOC(ReportLoc)),"^",2)
			set:LocDesc'="" LocDesc=$p(LocDesc,"-",2)
			
			continue:WarldDesc'[LocDesc				//感染报告科室与当前护士长登录病区不一致退出
			
			set InfeDate=""
			set InfPos=""
			//add by pylian 20160315 根据报告类型取感染部位、感染日期
			Set ReportTypeDesc=objInfReport.ReportType.Code					                //报告类型      
		
			If (ReportTypeDesc="COMP")||(ReportTypeDesc="NCOM")||(ReportTypeDesc="MRB"){
				set InfPosSubID=0
				For
				{
					set InfPosSubID=$o(^DHCMed.NINF("InfRep",InfReportID,"InfPos",InfPosSubID))
					quit:InfPosSubID=""
				
					set objInfPos=##class(DHCMed.NINF.Rep.InfReportInfPos).GetObjById(InfReportID_"||"_InfPosSubID)
					continue:'$IsObject(objInfPos)
					if (InfeDate="")
					{
						if (objInfPos.InfDate'=""){
							set InfeDate=$zd(objInfPos.InfDate,3) //感染日期
						}
												
					}else
					{
						if (objInfPos.InfDate'=""){
							set InfeDate=InfeDate_"/"_$zd(objInfPos.InfDate,3)
						}
						
					}
				
					if (InfPos="")
					{
						set InfPos=objInfPos.InfPos.IPDesc							//感染部位

					}else
					{
						set InfPos=InfPos_"/"_objInfPos.InfPos.IPDesc
					}
				}
				set OprSubID=0
				For
				{
					set OprSubID=$o(^DHCMed.NINF("InfRep",InfReportID,"Opr",OprSubID))
					quit:OprSubID=""
				
					set objOper=##class(DHCMed.NINF.Rep.InfReportOpr).GetObjById(InfReportID_"||"_OprSubID)
					continue:'$IsObject(objOper)
				    
					if (InfPos="")
					{
						set InfPos=objOper.OperInfType.Description							//感染部位
					}else
					{
						if (objOper.CuteInfFlag.Description="是"){
						  set InfPos=InfPos_"/"_objOper.OperInfType.Description
						}
					}
				}
			}ElseIf(ReportTypeDesc="ICU")||(ReportTypeDesc="NICU") {
				set ICUSubID=0
				For
				{
					set ICUSubID=$o(^DHCMed.NINF("InfRep",InfReportID,"ICU",ICUSubID))
					quit:ICUSubID=""
				
					set objICU=##class(DHCMed.NINF.Rep.InfReportICU).GetObjById(InfReportID_"||"_ICUSubID)
					continue:'$IsObject(objICU)
				    
					if (InfeDate="")
					{
						if (objICU.InfDate'=""){
							set InfeDate=$zd(objICU.InfDate,3)	 //感染日期	
						}
											
					}else
					{
						if (objICU.InfDate'=""){
							set InfeDate=InfeDate_"/"_$zd(objICU.InfDate,3)
						}
						
					}
					
					if objICU.InfDate'="" { //感染日期为空，不算感染 
						if (InfPos="")
						{
							set InfPos=objICU.IntubateType.Description							//感染部位
						}else
						{
							set InfPos=InfPos_"/"_objICU.IntubateType.Description
						}
					}
				}
				
			}ElseIf(ReportTypeDesc="OPR") {
				set OprSubID=0
				For
				{
					set OprSubID=$o(^DHCMed.NINF("InfRep",InfReportID,"Opr",OprSubID))
					quit:OprSubID=""
				
					set objOper=##class(DHCMed.NINF.Rep.InfReportOpr).GetObjById(InfReportID_"||"_OprSubID)
					continue:'$IsObject(objOper)
				    
					set InfeDate=""    //感染日期
				
					if (InfPos="")
					{
						set InfPos=objOper.OperInfType.Description							//感染部位
					}else
					{
						if (objOper.CuteInfFlag.Description="是"){
							set InfPos=InfPos_"/"_objOper.OperInfType.Description
						}
					}
				}
				
			}								
			set RepDate=$zd(objInfReport.ReportDate,3)									//报告日期
			set RepUserID=objInfReport.ReportUser	
			set RepUserName=$p($g(^SSU("SSUSR",RepUserID)),"^",2)				//报告人
			set PatInfo=##class(DtPortal.Common.PaadmService).GetPatInfo(PaadmID)
			Continue:PatInfo=""
			set Name=$p(PatInfo,"^",2)											//姓名
			set Sex=$p(PatInfo,"^",3)											//性别
			set Age=$p(PatInfo,"^",4)											//年龄
			set MedicareNo=$p(PatInfo,"^",5)									//病案号
			set AdmReason=$p(PatInfo,"^",6)										//费用类别
			set BedNo=$p(PatInfo,"^",1)											//床号
			set PAPMINo=$p(PatInfo,"^",7)	 					//登记号
			
			set PapmiID=$p($g(^PAADM(PaadmID)),"^",1)
			
			
			
			Set Data=$lb(Name,Sex,Age,MedicareNo,AdmReason,BedNo,PaadmID,InfeDate,InfPos,RepDate,RepUserName,ReportStatus,admDocName,admNurseName,diagnoseDesc,inDay,PAPMINo)
			Set ^||CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
		
	}
	
	Quit $$$OK
}

/// Creator：     chengpeng
/// CreatDate：   2014-08-11
/// Description:  判断病人是否患有院感报卡
/// Table：       DHCMed.NINF.Rep.InfReport
/// Input：       aEpisodeID     : 患者就诊号
/// Return：      return=0:不是  return=1:是
/// w ##class(DtPortal.NH.NH02Message.NH0209Infection).IsNINFPat("20")
ClassMethod IsNINFPat(aEpisodeID As %String)
{
	New (aEpisodeID)
	set return=0
	q:aEpisodeID="" return
	
	
	set RowID=""
	for 
	{
		set RowID=$o(^DHCMed.NINFi("InfRep",0,"IndexPaadm",aEpisodeID,RowID)) 
		q:RowID=""
		set objNINFRep=##class(DHCMed.NINF.Rep.InfReport).GetObjById(RowID)
		continue:'$IsObject(objNINFRep)
		set repStatus=objNINFRep.ReportStatus.Code
		
		Continue:(repStatus="0")    //检查报告状态（0:删除）
		Continue:(repStatus="5")    //检查报告状态（5:退回）
		set return=1
	} 
	q return
}

}
