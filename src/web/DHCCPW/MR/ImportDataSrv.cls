/// 名称: web.DHCCPW.MR.ImportDataSrv
/// 描述: 切换新旧版本临床路径业务数据
/// 编写者：zhufei
/// 编写日期: 2010-11-02
Class web.DHCCPW.MR.ImportDataSrv Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2010-11-02
/// Description:  切换临床路径业务数据（旧版本-->新版本）
/// Table：       
/// Input：       argFrom,argTo
/// Return：      return>0 成功
/// w ##class(web.DHCCPW.MR.ImportDataSrv).ChangeData(argFrom,argTo)
/// w ##class(web.DHCCPW.MR.ImportDataSrv).ChangeData(481051,481051)
/// w ##class(web.DHCCPW.MR.ImportDataSrv).ChangeData(3660599,3660599)
ClassMethod ChangeData(argFrom As %String, argTo As %String) As %String
{
	New (argFrom,argTo)
	Set return=-1
	Set $ZT="ChangeDataErr"
	Quit:argFrom="" return
	Set:argTo="" argTo=$o(^MR(""),-1)
	
	//^MR({MR_Adm.MRADM_RowId},"CPW",{CPW_Childsub})
	Set Count=0
	Set MRAdmID=argFrom-1
	For {
		Set MRAdmID=$o(^MR(MRAdmID))
		Quit:MRAdmID=""
		Quit:MRAdmID>argTo
		
		Set PathWaySub=0
		For {
			Set PathWaySub=$o(^MR(MRAdmID,"CPW",PathWaySub))
			Quit:PathWaySub=""
			
			Set Count=Count+1
			Write:(Count#100)=0 "Count="_Count,!
			
			Set tmp=$g(^MR(MRAdmID,"CPW",PathWaySub))
			Set OPathWayID=$p(tmp,"^",1)
			If OPathWayID'="" {
				Set OPathWay=$p($g(^MRC("CPW",OPathWayID)),"^",2)
			}
			Set OPathWay=$g(OPathWay)
			Continue:OPathWay=""
			
			//1	甲状腺恶性肿瘤
			//2	急性单纯性阑尾炎
			//3	腹股沟疝
			//4	股骨干骨折
			//5	子宫平滑肌瘤
			//6	结节性甲状腺肿
			//7	乳腺癌
			//8	计划性剖宫产
			
			Set PathWayID=""
			Set:OPathWay="甲状腺恶性肿瘤" PathWayID=14
			Set:OPathWay="急性单纯性阑尾炎" PathWayID=19
			Set:OPathWay="腹股沟疝" PathWayID=20
			Set:OPathWay="股骨干骨折" PathWayID=21
			Set:OPathWay="子宫平滑肌瘤" PathWayID=18
			Set:OPathWay="结节性甲状腺肿" PathWayID=15
			Set:OPathWay="乳腺癌" PathWayID=1
			Set:OPathWay="计划性剖宫产" PathWayID=17
			Continue:PathWayID=""
			
			Set OStatus=$p(tmp,"^",6)
			Set Status=$s(OStatus=1:"O",3:"I",1:"")
			
			Set EpisodeID=##Class(web.DHCCPW.MR.PAADMSrv).GetEpisodeID(MRAdmID)
			Continue:EpisodeID=""
			Set AdmType=$p($g(^PAADM(EpisodeID)),"^",2)
			Continue:AdmType="O"
			//Set AdmDate=$p($g(^PAADM(EpisodeID)),"^",6)
			//Set AdmTime=$p($g(^PAADM(EpisodeID)),"^",7)
			//upadte by pylian 2016-02-18 修改入院时间取值方式
    		Set AdmDateTime=##Class(web.DHCCPW.IO.FromAdmSrv).GetAdmDateTime(EpisodeID)
			Set AdmDate=$p(AdmDateTime,"^",1)
			Set AdmTime=$p(AdmDateTime,"^",2)
			//Set DischDate=$p($g(^PAADM(EpisodeID)),"^",17)
			//Set DischTime=$p($g(^PAADM(EpisodeID)),"^",18)
			//Update by pylian 2016-01-21 修改出院时间取值方式
			Set DischDateTime=##Class(web.DHCCPW.IO.FromAdmSrv).GetDischDateTime(EpisodeID)
			Set DischDate=$p(DischDateTime,"^",1)
			Set DischTime=$p(DischDateTime,"^",2)
			Set InDoctorDR=$p(tmp,"^",12)
			Set:InDoctorDR="" InDoctorDR=$p($g(^PAADM(EpisodeID)),"^",9)
			Set InDate=$p(tmp,"^",3)
			Set InTime=$p(tmp,"^",4)
			If (InDate="")||(InTime="") {
				Set InDate=AdmDate
				Set InTime=AdmTime
			}
			Set (OutDate,OutTime,OutDoctorDR,OutReasonDR)=""
			If Status="O" {
				Set OutDoctorDR=InDoctorDR
				Set OutDate=$p(tmp,"^",10)
				If (OutDate="")||(OutDate<InDate) {
					Set OutDate=InDate
				}
				Set OutTime=InTime
				Set OutReasonDR="6"  //设置固定值  6-主治医师决定
			} ElseIf Status="I" {
				If DischDate'="" {
					Set Status="C"
					Set OutDoctorDR=""
					Set OutDate=DischDate
					Set OutTime=DischTime
					If (OutDate<InDate)||((OutDate=InDate)&&(OutTime<InTime)) {
						Set OutDate=InDate
						Set OutTime=InTime
					}
				}
			} Else {
				Set Status="I"
			}
			Set UpdateDate=+$h
			Set UpdateTime=$p($h,",",2)
			Set UpdateUserDR=$o(^SSU("SSUSR",0))
			Set Comments=""
			
			Set InputStr=""_"^"_MRAdmID
			Set InputStr=InputStr_"^"_PathWayID
			Set InputStr=InputStr_"^"_PathWayID_"||1||1"
			Set InputStr=InputStr_"^"_Status
			Set InputStr=InputStr_"^"_InDoctorDR
			Set InputStr=InputStr_"^"_InDate
			Set InputStr=InputStr_"^"_InTime
			Set InputStr=InputStr_"^"_$g(OutDoctorDR)
			Set InputStr=InputStr_"^"_$g(OutDate)
			Set InputStr=InputStr_"^"_$g(OutTime)
			Set InputStr=InputStr_"^"_UpdateDate
			Set InputStr=InputStr_"^"_UpdateTime
			Set InputStr=InputStr_"^"_$g(OutReasonDR)
			Set InputStr=InputStr_"^"_Comments
			Set InputStr=InputStr_"^"_UpdateUserDR
			
			Set flg=##Class(web.DHCCPW.MR.ClinicalPathWays).Update(InputStr)
			Write:flg<0 "Count="_Count_",flg="_flg,!
		}
	}
	
	Set return=Count
	Quit return
	
ChangeDataErr
	Quit -1
}

/// 处理V2.0版本的数据到V3.0版本
/// w ##Class(web.DHCCPW.MR.ImportDataSrv).ChangeBaseData()
ClassMethod ChangeBaseData() As %String
{
	New
	Set return=0
	Set $ZT="ChangeBaseDataErr"
	
	Set CPWID=0,Count=0
	For {
		Set CPWID=$o(^DHCMRC("CPW",CPWID))
		Quit:CPWID=""
		
		Set CPWData=$g(^DHCMRC("CPW",CPWID))
		Set CPWDID=CPWID
		Set CPWDCode=$listget(CPWData,2)
		Set CPWDDesc=$listget(CPWData,3)
		Set CPWDType=$listget(CPWData,4)
		Set CPWDActive=$listget(CPWData,5)
		Set CPWDDateFrom=$listget(CPWData,6)
		Set CPWDDateTo=$listget(CPWData,7)
		
		Set CPWDData=$lb("",CPWDCode,CPWDDesc,CPWDType,CPWDActive,CPWDDateFrom,CPWDDateTo,CPWID)
		Set ^DHCMRC("CPWD",CPWDID)=CPWDData
		
		Set $li(CPWData,8)=$listget(CPWData,8)
		Set $li(CPWData,9)=$listget(CPWData,9)
		Set $li(CPWData,10)=$listget(CPWData,10)
		Set $li(CPWData,11)=$listget(CPWData,11)
		Set $li(CPWData,12)=$listget(CPWData,12)
		Set $li(CPWData,13)=1
		Set $li(CPWData,14)=+$h
		Set $li(CPWData,15)=$p($h,",",2)
		Set $li(CPWData,16)=$o(^SSU("SSUSR",0))
		Set $li(CPWData,17)=CPWDID
		Set ^DHCMRC("CPW",CPWID)=CPWData
		
		Set Count=Count+1
	}
	Set ^DHCMRC("CPWD")=$g(^DHCMRC("CPW"))
	
	Set return=Count
	Quit return
	
ChangeBaseDataErr
	Quit -1
}

/// 取路径科室
/// w ##Class(web.DHCCPW.MR.ImportDataSrv).getCPWLoc(16571)
ClassMethod getCPWLoc(EpisodeID As %String) As %String
{
	New (EpisodeID)
	Set return=""
	Quit:EpisodeID="" return
	
	Set $ZT="getCPWLocErr"
	
	//入院科室默认为路径科室
	Set TransID=0,CPWLocID="",CPWLoc=""
	For {
		Set TransID=$o(^PAADM(EpisodeID,"TRANS",TransID))
		Quit:TransID=""
		Quit:CPWLocID'=""
		Set CPWLocID=$p($g(^PAADM(EpisodeID,"TRANS",TransID)),"^",6)
		Set CPWLoc=$p($g(^CTLOC(+CPWLocID)),"^",2)
		Set:$p(CPWLoc,"-",2)'="" CPWLoc=$p(CPWLoc,"-",2)
	}
	Set return=CPWLoc
	
	If return="" {
		Set return=$p($g(^PAADM(+aEpisodeID)),"^",4)
	}
	
	Quit return
	
getCPWLocErr
	Quit ""
}

/// 取路径病区
/// w ##class(web.DHCCPW.MR.ImportDataSrv).getCPWWard(16571)
ClassMethod getCPWWard(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	
	//入院病区默认为路径病区
	Set TransID=0
	For {
		Set TransID=$o(^PAADM(aEpisodeID,"TRANS",TransID))
		Quit:TransID=""
		Quit:return'=""
		
		Set CPWWardID=+$p($g(^PAADM(aEpisodeID,"TRANS",TransID)),"^",8)
		Continue:CPWWardID<1
		Set CPWWardID=+$p($g(^PAWARD(CPWWardID)),"^",5)
		Continue:CPWWardID<1
		Set CPWWard=$p($g(^CTLOC(+CPWWardID)),"^",2)
		Continue:CPWWard=""
		
		Set return=CPWWardID
	}
	
	If return="" {
		Set AdmWard=$p($g(^PAADM(+aEpisodeID)),"^",70)
		Set return=$p($g(^PAWARD(+AdmWard)),"^",5)
	}
	
	Quit return
}

/// 处理入径科室问题
/// w ##class(web.DHCCPW.MR.ImportDataSrv).ProcessData()
ClassMethod ProcessData()
{
	New
	
	Set PathWayID=0
	For {
		Set PathWayID=$o(^DHCMR("CPW",PathWayID))
		Quit:PathWayID=""
		
		Set obj=##class(User.DHCMRClinicalPathWay).%OpenId(PathWayID)
		Continue:'$IsObject(obj)
		
		Set MRAdm=obj.CPWMRADMDR
		Set Paadm=##class(web.DHCCPW.MR.PAADMSrv).GetEpisodeID(MRAdm)
		Set CPWInLoc=..getCPWLoc(Paadm)
		Set CPWInWard=..getCPWWard(Paadm)
		
		Set obj.CPWInLoc=CPWInLoc
		Set obj.CPWInWard=CPWInWard
		set sc=obj.%Save()
		if $system.Status.IsError(sc) {                      //检查Save是否成功
	   		do $system.OBJ.DisplayError(sc) 
	   		set return=-1
		} else {
			set return=obj.%Id()
		}
		do obj.%Close()
	}
	
	Quit "Over!"
}

}
