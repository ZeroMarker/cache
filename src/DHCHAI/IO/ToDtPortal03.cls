/// ClassName:    DHCHAI.IO.ToDtPortal03
///               替换类DtPortal.NH.NH02Infection
/// Description:  护士长医院感染服务
/// Creator：     zhufei
/// CreatDate:    2018-03-19
Class DHCHAI.IO.ToDtPortal03 Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2018-03-19
/// Description:  查询护士长所辖病区医院感染病人详细信息
///               服务代码：    NH02.09.01
/// Table：       DHCHAI.IR.INFReport
/// Input：       UserCode    :  护士长工号
/// Input：       wardId    :  病区ID
/// Return：      病人详细信息
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IO.ToDtPortal03","NHInfReportPatFind","2156","")
Query NHInfReportPatFind(UserCode As %String, wardId As %String) As DtPortal.Query(ROWSPEC = "Name:%String,Sex:%String,Age:%String,MedicareNo:%String,AdmReason:%String,BedNo:%String,PaadmID:%String,InfeDate:%String,InfPos:%String,RepDate:%String,RepUserName:%String,ReportStatus:%String,PAPMINo:%String")
{
}

ClassMethod NHInfReportPatFindExecute(ByRef qHandle As %Binary, UserCode As %String, wardId As %String) As %Status
{
	new (qHandle,UserCode,wardId)
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	Quit:(wardId="") $$$OK   
	Set UserCode=$$ALPHAUP^SSUTIL4(UserCode)
	//Set WarldLocId=$p($g(^SSU("SSUSR",userId)),"^",4)
	//set WarldDesc=$p($g(^CTLOC(WarldLocId)),"^",2)
	Set WarldDesc=$p($g(^PAWARD(wardId)),"^",2)   //修改需求779737 ,以入参wardId为准
	Set:WarldDesc["-" WarldDesc=$p(WarldDesc,"-",2)
	Set LocationDR = $p($g(^PAWARD(wardId)),"^",5)  //对应CT_Loc表中科室ID
	Set LinkLocList = ""   //病区对应的关联科室List
	Set xLinkLocID=""       
	For	{
		Set xLinkLocID=$o(^CTLOC(LocationDR,"LINK",0,"Loc",xLinkLocID))
		Quit:xLinkLocID=""
		Set WardFlag = $p($g(^CTLOC(xLinkLocID)),"^",5)
		Continue:WardFlag="Y"
		Set LinkLocList=LinkLocList_","_xLinkLocID	
	}
	Set:LinkLocList'="" LinkLocList=LinkLocList_","
	
	//Set PatPaadmIDList=##class(DtPortal.Common.PaadmService).getAdmIdStrByUserCodeAndWardId(UserCode,wardId)
	Set PatPaadmIDList=##Class(DtPortal.Common.PaadmService).GetIPPaadmList("ward",UserCode,wardId)  //调用新方法
	Quit:PatPaadmIDList="" $$$OK
	
	For indAdm=1:1:$l(PatPaadmIDList,"^") {
		Set EpisodeID=$p(PatPaadmIDList,"^",indAdm)
		Continue:EpisodeID=""
		
		Set EpisodeDr=##class(DHCHAI.CUS.ToClinReport).GetEpisodeDr(EpisodeID)
		Continue:EpisodeDr=""
		
		Set arrInfRep=##class(DHCHAI.IO.ToDtPortalSrv).GetInfReports(EpisodeDr)
		For indIR=1:1:arrInfRep.Count() {
			Set objInfRep=arrInfRep.GetAt(indIR)
			Continue:'$IsObject(objInfRep)
			Continue:'$IsObject(objInfRep.IRStatusDr)
			
			//1保存、2提交、3审核、4删除、5退回、6取消审核
			Set StatusCode=objInfRep.IRStatusDr.BTCode
			Set StatusDesc=objInfRep.IRStatusDr.BTDesc
			Continue:(StatusCode="4")||(StatusCode="5")
			
			Set (RepLocID,LocDesc)=""
			Set objRepLoc=objInfRep.IRRepLocDr
			If $IsObject(objRepLoc){
				Set RepLocXCode=objRepLoc.BTXCode
				Set RepLocID=$p(RepLocXCode,"||",2)
				Set:RepLocID'="" LocDesc=$p($g(^CTLOC(RepLocID)),"^",2)
				Set:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
			}
			//Continue:WarldDesc'[LocDesc //感染报告科室与当前护士长登录病区不一致退出（呼吸内科一二护理单元，不包含呼吸内科二，该判断有问题）
			Set:RepLocID'="" RepLocID=","_RepLocID_","
			Continue:LinkLocList'[RepLocID  //感染报告科室与当前病区对应的关联科室不一致退出
			
			Set ReportDr=objInfRep.%Id()
			Set RepDate=objInfRep.IRRepDate
			Set:RepDate'="" RepDate=$zd(RepDate,3)
			Set ReportStatus=StatusDesc
			
			Set RepUserName=""
			Set objRepUser=objInfRep.IRRepUser
			If $IsObject(objRepUser){
				Set RepUserName =objRepUser.BTDesc
				Set RepUserXCode=objRepUser.BTXCode
				Set RepUserID=$p(RepUserXCode,"||",2)
				//Set:RepUserID'="" RepUserName=$p($g(^SSU("SSUSR",RepUserID)),"^",2)  //报告人
				Set:$d(^SSU("SSUSR",RepUserID)) RepUserName=$p($g(^SSU("SSUSR",RepUserID)),"^",2)  //报告人
			}
			
			Set InfDate="",InfPos=""
			Set arrInfDiagnos=##class(DHCHAI.IO.ToDtPortalSrv).GetInfDiagnos(ReportDr)
			For indID=1:1:arrInfDiagnos.Count() {
				Set objInfDiagnos=arrInfDiagnos.GetAt(indID)
				Continue:'$IsObject(objInfDiagnos)
				Continue:'$IsObject(objInfDiagnos.IRInfPosDr)
				Set tInfDate=objInfDiagnos.IRInfDate
				Set:tInfDate'="" tInfDate=$zd(tInfDate,3)
				Set tInfPos=objInfDiagnos.IRInfPosDr.BTDesc
				Set InfDate=InfDate_"/"_tInfDate
				Set InfPos=InfPos_"/"_tInfPos
			}
			Set:InfDate'="" InfDate=$e(InfDate,2,$l(InfDate))
			Set:InfPos'="" InfPos=$e(InfPos,2,$l(InfPos))
			set PatInfo=##class(DtPortal.Common.PublicService).GetPatInfo(EpisodeID)
			Continue:PatInfo=""
			set Name=$p(PatInfo,"^",2)											//姓名
			set Sex=$p(PatInfo,"^",3)											//性别
			set Age=$p(PatInfo,"^",4)											//年龄
			set MedicareNo=$p(PatInfo,"^",5)									//病案号
			set AdmReason=$p(PatInfo,"^",6)										//费用类别
			set BedNo=$p(PatInfo,"^",1)											//床号
			
			//根据portal组要求去掉多余的输出项目
			/*
			set NHPatInfo=##class(DtPortal.NH.CommonService).GetPatInfoNH(EpisodeID)
			set admDocName=$p(NHPatInfo,"^",1)									//主管医生
			set admNurseName=$p(NHPatInfo,"^",2)								//主管护士
			set diagnoseDesc=$p(NHPatInfo,"^",3)								//诊断
			set inDay=$p(NHPatInfo,"^",4)										//住院天数
			*/
			set PapmiID=$p($g(^PAADM(EpisodeID)),"^",1)
			set PAPMINo=$p($g(^PAPER(+PapmiID,"PAT",1)),"^",1) 					//登记号
			
			Set Data=$lb(Name,Sex,Age,MedicareNo,AdmReason,BedNo,EpisodeID,InfDate,InfPos,RepDate,RepUserName,ReportStatus,PAPMINo)
			Set ^||CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
		
	}
	
	Quit $$$OK
}

}
