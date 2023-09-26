/// 名称: web.DHCCPW.MR.ClinicalPathWays
/// 描述: 患者临床路径记录
/// 编写者：zhufei
/// 编写日期: 2010-05-13
Class web.DHCCPW.MR.ClinicalPathWays Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2010-05-16
/// Description:  根据ID取临床路径记录
/// Table：       User.DHCMRClinicalPathWay
/// Input：       ID:    User.DHCMRClinicalPathWay.Id
///               separete: 指定的分隔符
/// Return：      返回object
/// w ##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(1)
ClassMethod GetObjById(argId As %String) As User.DHCMRClinicalPathWay
{
	New (argId)
	Set return=""
	
	Set objPathWay=##Class(User.DHCMRClinicalPathWay).%OpenId(argId)
	If $IsObject(objPathWay){
		Set objCPW=objPathWay.CPWPathwayDR
		If $IsObject(objCPW){
			If $IsObject(objCPW.CPWCPWDicDR)
			{
				Set objCPW.CPWCode=objCPW.CPWCPWDicDR.CPWDCode
				Set objCPW.CPWDesc=objCPW.CPWCPWDicDR.CPWDDesc
				Set objCPW.CPWCPWTypeDR=objCPW.CPWCPWDicDR.CPWDCPWTypeDR
				Set objCPW.CPWActive=objCPW.CPWCPWDicDR.CPWDActive
				Set objCPW.CPWDateFrom=objCPW.CPWCPWDicDR.CPWDDateFrom
				Set objCPW.CPWDateTo=objCPW.CPWCPWDicDR.CPWDDateTo
			}
		}
		Set objPathWay.CPWPathwayDR=objCPW
		Set return=objPathWay
	}
	Do:objPathWay'="" objPathWay.%Close()
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2010-05-16
/// Description:  根据ID取临床路径记录
/// Table：       User.DHCMRClinicalPathWay
/// Input：       ID:    User.DHCMRClinicalPathWay.Id
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(web.DHCCPW.MR.ClinicalPathWays).GetStringById(1,"^")
ClassMethod GetStringById(argId As %String, argSeparete As %String) As %String
{
	New (argId,argSeparete)
	Set return=""
	
	Set obj=..GetObjById(argId)
	If $IsObject(obj) {
		Set:$g(argSeparete)="" argSeparete=..#SEPARATE
		
		Set ID=obj.%Id()
		Set MRAdm=obj.CPWMRADMDR
		
		If $IsObject(obj.CPWPathwayDR)
		{
			Set PathWayDR=obj.CPWPathwayDR.%Id()
			Set PathWayDesc=obj.CPWPathwayDR.CPWDesc
		}
		
		If $IsObject(obj.CPWPathwayEpStepDR)
		{
			Set EpStepDR=obj.CPWPathwayEpStepDR.%Id()
			Set EpStepDesc=obj.CPWPathwayEpStepDR.CPWSDesc
			
			Set EpDR=$p(EpStepDR,"||",1)_"||"_$p(EpStepDR,"||",2)
			Set objPathWayEp=##class(web.DHCCPW.MRC.PathWayEp).GetObjById(EpDR)
			If $IsObject(objPathWayEp)
			{
				Set EpDR=objPathWayEp.%Id()
				Set EpDesc=objPathWayEp.EPDesc
			}
			Do:objPathWayEp'="" objPathWayEp.%Close()
		}
		
		Set Status=obj.CPWStatus
		Set StatusDesc=$s(Status="I":"入径",Status="O":"出径",Status="C":"完成",1:"ERROR")
		
		Set InDoctorDR=obj.CPWInDoctorDR
		Set:InDoctorDR'="" InDoctorName=$p($g(^CTPCP(InDoctorDR,1)),"^",2)
		Set InDate=obj.CPWInDate
		Set InTime=obj.CPWInTime
		Set:InDate'="" InDate=$zd(+InDate,3)
		Set:InTime'="" InTime=$zt(+InTime,2)
		
		Set OutDoctorDR=obj.CPWInDoctorDR
		Set:OutDoctorDR'="" OutDoctorName=$p($g(^CTPCP(OutDoctorDR,1)),"^",2)
		Set OutDate=obj.CPWOutDate
		Set OutTime=obj.CPWOutTime
		Set:OutDate'="" OutDate=$zd(+OutDate,3)
		Set:OutTime'="" OutTime=$zt(+OutTime,2)
		
		If $IsObject(obj.CPWOutReasonDR)
		{
			Set OutReasonDR=obj.CPWOutReasonDR.%Id()
			Set OutReasonDesc=obj.CPWOutReasonDR.VRDesc
			If $IsObject(obj.CPWOutReasonDR.VRVarCategDR) {
				Set OutReasonCategDR=obj.CPWOutReasonDR.VRVarCategDR.%Id()
				Set OutReasonCategDesc=obj.CPWOutReasonDR.VRVarCategDR.VCDesc
			}
		}
		
		Set UpdateUserDR=obj.CPWUpdateUserDR
		Set:UpdateUserDR'="" UpdateUserDesc=$p($g(^SSU("SSUSR",UpdateUserDR)),"^",2)
		
		Set UpdateDate=obj.CPWUpdateDate
		Set UpdateTime=obj.CPWUpdateTime
		Set:UpdateDate'="" UpdateDate=$zd(+UpdateDate,3)
		Set:UpdateTime'="" UpdateTime=$zt(+UpdateTime,2)
		
		Set Comments=obj.CPWComments
	} Else {
		Quit return
	}
	
	Set return=$g(ID)_argSeparete
	Set return=return_$g(MRAdm)_argSeparete
	Set return=return_$g(PathWayDR)_argSeparete
	Set return=return_$g(PathWayDesc)_argSeparete
	Set return=return_$g(EpDR)_argSeparete
	Set return=return_$g(EpDesc)_argSeparete
	Set return=return_$g(EpStepDR)_argSeparete
	Set return=return_$g(EpStepDesc)_argSeparete
	Set return=return_$g(Status)_argSeparete
	Set return=return_$g(StatusDesc)_argSeparete
	Set return=return_$g(InDoctorDR)_argSeparete
	Set return=return_$g(InDoctorName)_argSeparete
	Set return=return_$g(InDate)_argSeparete
	Set return=return_$g(InTime)_argSeparete
	Set return=return_$g(OutDoctorDR)_argSeparete
	Set return=return_$g(OutDoctorName)_argSeparete
	Set return=return_$g(OutDate)_argSeparete
	Set return=return_$g(OutTime)_argSeparete
	Set return=return_$g(OutReasonDR)_argSeparete
	Set return=return_$g(OutReasonDesc)_argSeparete
	Set return=return_$g(UpdateUserDR)_argSeparete
	Set return=return_$g(UpdateUserDesc)_argSeparete
	Set return=return_$g(UpdateDate)_argSeparete
	Set return=return_$g(UpdateTime)_argSeparete
	Set return=return_$g(Comments)_argSeparete
	Set return=return_$g(OutReasonCategDR)_argSeparete
	Set return=return_$g(OutReasonCategDesc)
			
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2010-05-16
/// Description:  更新User.DHCMRClinicalPathWay
/// Table：       User.DHCMRClinicalPathWay
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1:Rowid 2:MRADMDR 3:PathwayDR 4:PathwayEpStepDR 5:Status 6:InDoctorDR
/// 7:InDate 8:InTime 9:OutDoctorDR 10:OutDate 11:OutTime 12:UpdateDate
/// 13:UpdateTime 14:OutReasonDR 15:Comments 16:UpdateUserDR
/// w ##class(web.DHCCPW.MR.ClinicalPathWays).Update(InPutStr)
ClassMethod Update(argInStr As %String) As %String
{
	New (argInStr)
	Set return=-1
	Set ID=$p(argInStr,"^",1)
	If ID="" {
		Set obj=##class(User.DHCMRClinicalPathWay).%New()
	} Else {
		Set obj=##class(User.DHCMRClinicalPathWay).%OpenId(ID)
		Quit:obj="" return
	}
	
	Set MRADM=$p(argInStr,"^",2)
	Quit:MRADM="" return
	
	Set MRCPathwayDR=$p(argInStr,"^",3)
	Set objMRCPathway=##class(web.DHCCPW.MRC.CliPathWay).GetObjById(MRCPathwayDR)
	Quit:objMRCPathway="" return
	
	Set MRCPathwayEpStepDR=$p(argInStr,"^",4)
	Set objMRCPathwayEpStep=##class(web.DHCCPW.MRC.PathWEpStep).GetObjById(MRCPathwayEpStepDR)
	Quit:objMRCPathwayEpStep="" return
	
	Set Status=$p(argInStr,"^",5)
	Quit:Status="" return
	
	Set InDoctorDR=$p(argInStr,"^",6)
	Set InDate=$p(argInStr,"^",7)
	Set InTime=$p(argInStr,"^",8)
	Set:InDate["/" InDate=$zdh(InDate,4)
	Set:InDate["-" InDate=$zdh(InDate,3)
	Set:InDate'="" InDate=+InDate
	Set:InTime[":" InTime=$zth(InTime,2)
	Set:InTime'="" InTime=+InTime
	
	Set OutDoctorDR=$p(argInStr,"^",9)
	Set OutDate=$p(argInStr,"^",10)
	Set OutTime=$p(argInStr,"^",11)
	Set:OutDate["/" OutDate=$zdh(OutDate,4)
	Set:OutDate["-" OutDate=$zdh(OutDate,3)
	Set:OutDate'="" OutDate=+OutDate
	Set:OutTime[":" OutTime=$zth(OutTime,2)
	Set:OutTime'="" OutTime=+OutTime
	Set OutReasonDR=$p(argInStr,"^",14)
	Set objOutReason=##class(web.DHCCPW.MRC.VarianceReason).GetObjById(OutReasonDR)
	
	Set UpdateUserDR=$p(argInStr,"^",16)
	Set UpdateDate=$p(argInStr,"^",12)
	Set UpdateTime=$p(argInStr,"^",13)
	Set:UpdateDate["/" UpdateDate=$zdh(UpdateDate,4)
	Set:UpdateDate["-" UpdateDate=$zdh(UpdateDate,3)
	Set UpdateDate=$s(UpdateDate'="":+UpdateDate,1:+$h)
	Set:UpdateTime[":" UpdateTime=$zth(UpdateTime,2)
	Set UpdateTime=$s(UpdateTime'="":+UpdateTime,1:$p($h,",",2))
	
	Set Comments=$p(argInStr,"^",15)
	
	Set obj.CPWMRADMDR=MRADM
	Set obj.CPWPathwayDR=objMRCPathway
	Set obj.CPWPathwayEpStepDR=objMRCPathwayEpStep
	Set obj.CPWStatus=Status
	Set obj.CPWInDoctorDR=InDoctorDR
	Set obj.CPWInDate=InDate
	Set obj.CPWInTime=InTime
	Set obj.CPWOutDoctorDR=OutDoctorDR
	Set obj.CPWOutDate=OutDate
	Set obj.CPWOutTime=OutTime
	Set obj.CPWOutReasonDR=objOutReason
	Set obj.CPWUpdateUserDR=UpdateUserDR
	Set obj.CPWUpdateDate=UpdateDate
	Set obj.CPWUpdateTime=UpdateTime
	Set obj.CPWComments=Comments
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {                      //检查Save是否成功
   		do $system.OBJ.DisplayError(sc) 
   		set return=-1
	} else {
		set return=obj.%Id()
	}
	do obj.%Close()
	quit return
}

/// Creator：     wuqk
/// CreatDate：   2010-05-31
/// Description:  入径
/// Table：       User.DHCMRClinicalPathWay
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1:Rowid 2:MRADMDR 3:PathwayDR 4:PathwayEpStepDR 5:Status 6:InDoctorDR
/// 7:InDate 8:InTime 9:OutDoctorDR 10:OutDate 11:OutTime 12:UpdateDate
/// 13:UpdateTime 14:OutReasonDR 15:Comments 16:UpdateUserDR
/// w ##class(web.DHCCPW.MR.ClinicalPathWays).InPathWay(InPutStr)
ClassMethod InPathWay(argInStr As %String) As %String
{
	//New (argInStr)
	Set return=-1
	Set ID=$p(argInStr,"^",1)
	Set obj=##class(User.DHCMRClinicalPathWay).%New()
	
	Set MRADM=$p(argInStr,"^",2)
	Quit:MRADM="" return
	
	Set MRCPathwayDR=$p(argInStr,"^",3)
	Set objMRCPathway=##class(web.DHCCPW.MRC.CliPathWay).GetObjById(MRCPathwayDR)
	Quit:objMRCPathway="" return
	
	//update by liuyh 2017-12-26 增加判断是否有入径状态的路径
	Set EpisodeID=$p($g(^MR(+MRADM,"PRO",1)),"^",9)
	Quit:EpisodeID="" return
	Set InPathWayName=##class(web.DHCCPW.MR.Interface).GetInPathWayName(EpisodeID)
	Quit:InPathWayName'="" return
	
	Set MRCPathwayEpStepDR=$p(argInStr,"^",4)
	if MRCPathwayEpStepDR="" {       //如果未在页面选择step，取该路径的第一个step
		set stepList=##class(web.DHCCPW.MRC.ClinPathWaysSrv).BuildSteps(MRCPathwayDR)
		quit:stepList="" 
		set firstStep=$li(stepList,1)
		quit:firstStep=""
		set MRCPathwayEpStepDR=$li(firstStep,1)
	}
	Quit:MRCPathwayEpStepDR="" -2
	set objMRCPathwayEpStep=##class(web.DHCCPW.MRC.PathWEpStep).GetObjById(MRCPathwayEpStepDR)
	
	Set Status=$p(argInStr,"^",5)
	Quit:Status="" return
	
	Set InDoctorDR=$p(argInStr,"^",6)
	Set InDate=$p(argInStr,"^",7)
	If (InDate'=""){
		Set:InDate["/" InDate=$zdh(InDate,4)
		Set:InDate["-" InDate=$zdh(InDate,3)
		Set:InDate'="" InDate=+InDate
	}
	else{
		Set InDate=+$h
	}
	Set InTime=$p(argInStr,"^",8)
	If (InTime'=""){		
		Set:InTime[":" InTime=$zth(InTime,2)
		Set:InTime'="" InTime=+InTime
	}
	else{
		Set InTime=$p($h,",",2)
	}
	
	Set UpdateUserDR=$p(argInStr,"^",16)
	Set UpdateDate=+$h
	Set UpdateTime=$p($h,",",2)
	
	Set Comments=$p(argInStr,"^",15)
	
	//add by zf 20121012
	//增加入径科室和入径病区
	Set Paadm=##class(web.DHCCPW.MR.PAADMSrv).GetEpisodeID(MRADM)
	Set AdmLoc=$p($g(^PAADM(+Paadm)),"^",4)
	Set AdmWard=$p($g(^PAADM(+Paadm)),"^",70)
	Set AdmWard=$p($g(^PAWARD(+AdmWard)),"^",5)
	
	Set obj.CPWMRADMDR=MRADM
	Set obj.CPWPathwayDR=objMRCPathway
	Set obj.CPWPathwayEpStepDR=objMRCPathwayEpStep
	Set obj.CPWStatus=Status
	Set obj.CPWInDoctorDR=InDoctorDR
	Set obj.CPWInDate=InDate
	Set obj.CPWInTime=InTime
	//Set obj.CPWOutDoctorDR=objOutDoctor
	//Set obj.CPWOutDate=OutDate
	//Set obj.CPWOutTime=OutTime
	//Set obj.CPWOutReasonDR=objOutReason
	Set obj.CPWUpdateUserDR=UpdateUserDR
	Set obj.CPWUpdateDate=UpdateDate
	Set obj.CPWUpdateTime=UpdateTime
	Set obj.CPWComments=Comments
	Set obj.CPWInLoc=AdmLoc
	Set obj.CPWInWard=AdmWard
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {                      //检查Save是否成功
   		do $system.OBJ.DisplayError(sc) 
   		set return=-1
	} else {
		set return=obj.%Id()
		//add by zf 2012-01-10
		Set EpisodeID=##class(web.DHCCPW.MR.PAADMSrv).GetEpisodeID(MRADM)
		Set flg1=##Class(web.DHCCPW.MR.InterfaceToPrj).InPathWayToHIS(EpisodeID_"^"_return)
	}
	do obj.%Close()
	quit return
}

/// Creator：     wuqk
/// CreatDate：   2010-05-31
/// Description:  出径
/// Table：       User.DHCMRClinicalPathWay
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1:Rowid  2:Status 
/// 3:OutDoctorDR 4:OutDate 5:OutTime 6:OutReasonDR 
/// 7:Comments 8:UpdateUserDR
/// w ##class(web.DHCCPW.MR.ClinicalPathWays).OutPathWay(InPutStr)
ClassMethod OutPathWay(argInStr As %String) As %String
{
	//New (argInStr)
	Set return=-1
	Set ID=$p(argInStr,"^",1)
	
	Set obj=##class(User.DHCMRClinicalPathWay).%OpenId(ID)
	Quit:'$IsObject(obj) return
	
	Set Status=$p(argInStr,"^",2)
	Quit:Status="" return
	
	Set OutDoctorDR=$p(argInStr,"^",3)
	
	Set OutDate=$p(argInStr,"^",4)
	If (OutDate'=""){
		Set:OutDate["/" OutDate=$zdh(OutDate,4)
		Set:OutDate["-" OutDate=$zdh(OutDate,3)
		Set:OutDate'="" OutDate=+OutDate
	}
	else{
		Set OutDate=+$h
	}
	Set OutTime=$p(argInStr,"^",5)
	If (OutTime'=""){		
		Set:OutTime[":" OutTime=$zth(OutTime,2)
		Set:OutTime'="" OutTime=+OutTime
	}
	else{
		Set OutTime=$p($h,",",2)
	}
	Set OutReasonDR=$p(argInStr,"^",6)
	Set objOutReason=##class(web.DHCCPW.MRC.VarianceReason).GetObjById(OutReasonDR)
	
	Set Comments=$p(argInStr,"^",7)
	
	Set UpdateUserDR=$p(argInStr,"^",8)
	Set UpdateDate=+$h
	Set UpdateTime=$p($h,",",2)
	
	Set obj.CPWStatus=Status
	Set obj.CPWOutDoctorDR=OutDoctorDR
	Set obj.CPWOutDate=OutDate
	Set obj.CPWOutTime=OutTime
	Set obj.CPWOutReasonDR=objOutReason
	Set obj.CPWUpdateUserDR=UpdateUserDR
	Set obj.CPWUpdateDate=UpdateDate
	Set obj.CPWUpdateTime=UpdateTime
	Set obj.CPWComments=Comments
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {                      //检查Save是否成功
   		do $system.OBJ.DisplayError(sc) 
   		set return=-1
	} else {
		set return=obj.%Id()
		//add by zf 2012-01-10
		Set MRADM=obj.CPWMRADMDR
		Set EpisodeID=##class(web.DHCCPW.MR.PAADMSrv).GetEpisodeID(MRADM)
		Set flg1=##Class(web.DHCCPW.MR.InterfaceToPrj).ClosePathWayToHIS(EpisodeID)
	}
	do obj.%Close()
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2010-05-16
/// Description:  删除User.DHCMRClinicalPathWay
/// Table：       User.DHCMRClinicalPathWay
/// Input：       User.DHCMRClinicalPathWay.Id
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(web.DHCCPW.MR.ClinicalPathWays).DeleteById(1)
ClassMethod DeleteById(argId As %String) As %Boolean
{
	new (argId)
	set return=0
	set sc = ##class(User.DHCMRClinicalPathWay).%DeleteId(argId)
	if $system.Status.IsError(sc) {         //检查删除是否成功
   		do $system.OBJ.DisplayError(sc) 
   		set return=-1
	} else {
		set return=0
	}
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2010-05-16
/// Description:  删除User.DHCMRClinicalPathWay
/// Table：       User.DHCMRClinicalPathWay
/// Input：       User.DHCMRClinicalPathWay.Id
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(web.DHCCPW.MR.ClinicalPathWays).GetActiveCPWByadm(136662,$C(1))
ClassMethod GetActiveCPWByadm(argMRAdm As %String, argSeparete As %String) As %String
{
	New (argMRAdm,argSeparete)
	Set return=""
	
	//^DHCMRi("CPW",0,"IndexMRAdm",{CPWMRADMDR},{ID})
	Quit:argMRAdm="" return
	Quit:'$d(^DHCMRi("CPW",0,"IndexMRAdm"," "_argMRAdm)) return
	
	Set CPWID=0
	For {
		Set CPWID=$o(^DHCMRi("CPW",0,"IndexMRAdm"," "_argMRAdm,CPWID))
		Quit:(CPWID="")||(return'="")
		Set obj=..GetObjById(CPWID)
		If $IsObject(obj)
		{
			Set Status=obj.CPWStatus
		} Else {
			Set Status=""
		}
		Continue:Status'="I"
		Set:$g(argSeparete)="" argSeparete=..#SEPARATE
		Set return=..GetStringById(CPWID,argSeparete)
	}
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2010-05-13
/// Description:  取临床路径字典
/// Input：       Code,Desc,Type
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MR.ClinicalPathWays","QryPathWayByAdm",13268685)
Query QryPathWayByAdm(argMRAdm As %String) As %Query(ROWSPEC = "Rowid:%Integer,CPWMRAdm:%String,CPWDR:%String,CPWDesc:%String,CPWEpDR:%String,CPWEpDesc:%String,CPWEpStepDR:%String,CPWEPStepDesc:%String,Status:%String,StatusDesc:%String,InDoctorDR:%String,InDoctorDesc:%String,InDate:%String,InTime:%String,OutDoctorDR:%String,OutDoctorDesc:%String,OutDate:%String,OutTime:%String,OutReasonDR:%String,OutReasonDesc:%String,UpdateUserDR:%String,UpdateUserDesc:%String,UpdateDate:%String,UpdateTime:%String,Comments:%String")
{
}

ClassMethod QryPathWayByAdmExecute(ByRef qHandle As %Binary, argMRAdm As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	//^DHCMRi("CPW",0,"IndexMRAdm",{CPWMRADMDR},{ID})
	Quit:argMRAdm="" $$$OK
	Quit:'$d(^DHCMRi("CPW",0,"IndexMRAdm"," "_argMRAdm)) $$$OK
	
	Set ClinPathWaysID=""
	For {
		Set ClinPathWaysID=$o(^DHCMRi("CPW",0,"IndexMRAdm"," "_argMRAdm,ClinPathWaysID),-1)
		Quit:ClinPathWaysID=""
		Set obj=..GetObjById(ClinPathWaysID)
		
		Set (CPWMRAdm,CPWPathwayDR,CPWPathWayDesc,CPWPathWayEpDR,CPWPathWayEpDesc)=""
		Set (CPWEpStepDR,CPWEPStepDesc,CPWStatus,CPWStatusDesc)=""
		Set (CPWInDoctorDR,CPWInDoctorDesc,CPWInDate,CPWInTime)=""
		Set (CPWOutDoctorDR,CPWOutDoctorDesc,CPWOutDate,CPWOutTime,CPWOutReasonDR)=""
		Set (CPWOutReasonDesc)=""
		Set (CPWUpdateUserDR,CPWUpdateUserDesc,CPWUpdateDate,CPWUpdateTime,CPWComments)=""
		
		If $IsObject(obj)
		{
			Set CPWMRAdm=obj.CPWMRADMDR
			
			If $IsObject(obj.CPWPathwayDR)
			{
				Set CPWPathwayDR=obj.CPWPathwayDR.%Id()
				If $IsObject(obj.CPWPathwayDR.CPWCPWDicDR){
					Set CPWPathWayDesc=obj.CPWPathwayDR.CPWCPWDicDR.CPWDDesc
				}
			}
			
			If $IsObject(obj.CPWPathwayEpStepDR)
			{
				Set CPWEpStepDR=obj.CPWPathwayEpStepDR.%Id()
				Set CPWEPStepDesc=obj.CPWPathwayEpStepDR.CPWSDesc
				Set CPWPathWayEpDR=$p(CPWEpStepDR,"||",1)_"||"_$p(CPWEpStepDR,"||",2)
				Set objPathWayEp=##class(web.DHCCPW.MRC.PathWayEp).GetObjById(CPWPathWayEpDR)
				If $IsObject(objPathWayEp)
				{
					Set CPWPathWayEpDesc=objPathWayEp.EPDesc
				}
				Do:objPathWayEp'="" objPathWayEp.%Close()
			}
			
			Set CPWStatus=obj.CPWStatus
			Set CPWStatusDesc=$s(CPWStatus="I":"入径",CPWStatus="O":"出径",CPWStatus="C":"完成",1:"ERROR")
			
			Set CPWInDoctorDR=obj.CPWInDoctorDR
			Set:CPWInDoctorDR'="" CPWInDoctorDesc=$p($g(^CTPCP(CPWInDoctorDR,1)),"^",2)
			Set CPWInDate=obj.CPWInDate
			Set CPWInTime=obj.CPWInTime
			Set:CPWInDate'="" CPWInDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(+CPWInDate)
			Set:CPWInTime'="" CPWInTime=$zt(+CPWInTime,2)
			
			Set CPWOutDoctorDR=obj.CPWOutDoctorDR
			Set:CPWOutDoctorDR'="" CPWOutDoctorDesc=$p($g(^CTPCP(CPWOutDoctorDR,1)),"^",2)
			Set CPWOutDate=obj.CPWOutDate
			Set CPWOutTime=obj.CPWOutTime
			Set:CPWOutDate'="" CPWOutDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(+CPWOutDate)
			Set:CPWOutTime'="" CPWOutTime=$zt(+CPWOutTime,2)
			
			If $IsObject(obj.CPWOutReasonDR)
			{
				Set CPWOutReasonDR=obj.CPWOutReasonDR.%Id()
				Set CPWOutReasonDesc=obj.CPWOutReasonDR.VRDesc
			}
			
			Set CPWUpdateUserDR=obj.CPWUpdateUserDR
			Set:CPWUpdateUserDR'="" CPWUpdateUserDesc=$p($g(^SSU("SSUSR",CPWUpdateUserDR)),"^",2)
			Set CPWUpdateDate=obj.CPWUpdateDate
			Set CPWUpdateTime=obj.CPWUpdateTime
			Set:CPWUpdateDate'="" CPWUpdateDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(+CPWUpdateDate)
			Set:CPWUpdateTime'="" CPWUpdateTime=$zt(+CPWUpdateTime,2)
			
			Set CPWComments=obj.CPWComments
		} Else {
			Continue
		}
		
		Set Data=$lb($g(ClinPathWaysID),$g(CPWMRAdm),$g(CPWPathwayDR),$g(CPWPathWayDesc),$g(CPWPathWayEpDR),$g(CPWPathWayEpDesc),$g(CPWEpStepDR),$g(CPWEPStepDesc),$g(CPWStatus),$g(CPWStatusDesc))
		Set Data=Data_$lb($g(CPWInDoctorDR),$g(CPWInDoctorDesc),$g(CPWInDate),$g(CPWInTime))
		Set Data=Data_$lb($g(CPWOutDoctorDR),$g(CPWOutDoctorDesc),$g(CPWOutDate),$g(CPWOutTime),$g(CPWOutReasonDR),$g(CPWOutReasonDesc))
		Set Data=Data_$lb($g(CPWUpdateUserDR),$g(CPWUpdateUserDesc),$g(CPWUpdateDate),$g(CPWUpdateTime),$g(CPWComments))
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryPathWayByAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPathWayByAdmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPathWayByAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPathWayByAdmExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     wuqk
/// CreatDate：   2010-06-01
/// Description:  根据paadm取临床路径当前step信息
/// Table：       User.DHCMRClinicalPathWay
/// Input：       EpisodeID ：Paadm
///               separete: 指定的分隔符
/// Return：      
/// 1:admDateNo        入院后第几日
/// 2:cpwDateNo        入径后第几日
/// 3:currentStepId    当前stepId
/// 4:currentStepDesc  当前step描述
/// 5:currentStepDayNo 当前step的第几日
/// 6:currentStepIndex 当前step的序号
/// w ##class(web.DHCCPW.MR.ClinicalPathWays).GetCurrentStepInfo(76547)
ClassMethod GetCurrentStepInfo(EpisodeID, separete) As %String
{
	New (EpisodeID,separete)
	Set return=""
	Set:$g(separete)="" separete=..#SEPARATE
	set admInfo=##class(web.DHCCPW.MR.PAADMSrv).GetAdmInfoByID(EpisodeID,separete)
	set MrADM=$p(admInfo,separete,13)
	set admDate=$p(admInfo,separete,3)                   //入院日期
	
	set CurrentCPW=..GetActiveCPWByadm(MrADM,separete)
	quit:CurrentCPW="" return
	set cpwRowId=$p(CurrentCPW,separete,3)               //当前路径Id
	set cpwDesc=$p(CurrentCPW,separete,4)                //当前路径描述
	set cpwInStepDr=$p(CurrentCPW,separete,7)            //入径stepId
	set cpwInDate=$p(CurrentCPW,separete,13)             //入径日期
	
	set currentDate=+$h
	set admDateNo=currentDate-##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(admDate)+1
	set cpwDateNo=currentDate-$zdh(cpwInDate,3)+1                   //入径后第几日
	
	set currentStepId=""                                    //当前stepId
	set currentStepDesc=""                                  //当前step描述
	set currentStepDayNo=0                                  //当前step的第几日
	set currentStepIndex=0                                  //当前step序号
	set tempDays=cpwDateNo
	set tempInCPWFlag=0
	set stepList=##class(web.DHCCPW.MRC.ClinPathWaysSrv).BuildSteps(cpwRowId)
	if stepList'="" {
		set stepLength=$ll(stepList)
		set ind=1
		//while ((ind<stepLength)&&(tempDays'<1)) {
		//Modify by wuqk 2010-11-05 计算错误
		while ((ind'>stepLength)&&(tempDays'<1)) {
			set tempStep=$li(stepList,ind)
			set currentStepIndex=currentStepIndex+1
			if tempStep'=""{
				set tempStepId=$li(tempStep,1)
				//w !,tempStepId
				set tempStepDesc=$li(tempStep,2)
				set tempStepDays=$li(tempStep,3)
				set:(tempStepId=cpwInStepDr) tempInCPWFlag=1
				if (tempInCPWFlag){
					set calcDays=tempDays-tempStepDays
					if calcDays<1 {                          //此step即为当前阶段
						set currentStepId=tempStepId         //当前stepId
						set currentStepDesc=tempStepDesc     //当前step描述
						set currentStepDayNo=tempDays        //当前step的第几日
					}
					set tempDays=calcDays
				}
			}
			set ind=ind+1
		}
	}
	//如果天数已经超出临床路径，按照最后step计算
	if tempDays>0 {
		set currentStepId=$g(tempStepId)         //当前stepId
		set currentStepDesc=$g(tempStepDesc)     //当前step描述
		set currentStepDayNo=$g(tempDays)        //当前step的第几日
	}
	
	set ret=admDateNo
	set ret=ret_separete_cpwDateNo
	set ret=ret_separete_currentStepId
	set ret=ret_separete_currentStepDesc
	set ret=ret_separete_currentStepDayNo
	set ret=ret_separete_currentStepIndex
	quit ret
}

/// Description: 需求177783 病人信息条临床路径内容修改 
/// w ##class(web.DHCCPW.MR.ClinicalPathWays).GetCPWByadm(308)
ClassMethod GetCPWByadm(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	Set MRAdm=$p($g(^PAADM(aEpisodeID)),"^",61)
	Quit:'$d(^DHCMRi("CPW",0,"IndexMRAdm"," "_MRAdm)) return
	
	Set CPWDesc=$p(..GetActiveCPWByadm(MRAdm,"^"),"^",4)
    Set CPWStepDesc=$p(..GetCurrentStepInfo(MRAdm,"^"),"^",4)
    Set CPWDayNo=$p(..GetCurrentStepInfo(MRAdm,"^"),"^",2 )
    Set:CPWDayNo'="" CPWDayNo="入径第"_CPWDayNo_"天"
	Set return=CPWDesc_" "_CPWStepDesc_" "_CPWDayNo
	Quit return
}

/// Creator:		周志强          
/// CreatDate:		2010.03.13   
/// Description:	将临床路径对应的医嘱直接增加到界面上
/// Table:        	DHC_MRC_ClinPathWaysEpStepItem,DHC_MRC_ClinicalPathways
/// Input:        	以"^"分隔的参数串：步骤ID_"^"_医嘱项序号
/// Return:       	
/// Others:			w ##class(web.DHCCPW.MR.ClinicalPathWays).AddMRCPWItemToList("AddCopyItemToList","","")
ClassMethod AddMRCPWItemToList(itmjs As %Library.String = "", itmjsex As %Library.String = "", StepItemIDS As %String) As %String
{
	s jsval=""
	s LinkNo=""
	
	//修改关联医嘱程序改动 update by zf 20150622
	Set ret=##class(DHCCPW.MR.FORM.OEOrderSrv).AddMRCPWItemToList(itmjs,itmjsex,StepItemIDS)
	Quit ret
	
	//s tmpStepItemIDS=..CheckStepItemIDS(StepItemIDS)
	//s:tmpStepItemIDS'="" StepItemIDS=tmpStepItemIDS
	s MaxItmNo=..GetMaxItmNo(StepItemIDS)
	for j=1:1:MaxItmNo {
		s:LinkNo'="" LinkNo=LinkNo_"^"_0
		s:LinkNo="" LinkNo=0
	}
	
	//取临时医嘱类型对应ID
	s tmpID=$o(^OECPR(0,"Desc","临时医嘱",""))
	if tmpID="" {
		s tmpID=$o(^OECPR(0))
	}
	s tmpDesc=$p($g(^OECPR(+tmpID)),"^",2)
	
	for i=1:1:$length(StepItemIDS,",") {
		s StepItem=$P(StepItemIDS,",",i)
		s xxxStepItemID=$P(StepItem,"^",1)
		s StepItemID=$p(xxxStepItemID,"-",1)
		s StepItemIDArcimSeqNo=$P(StepItem,"^",2)
		if StepItemID="" Continue
		s obj=##class(web.DHCCPW.MRC.PathWEpStepItem).GetObjById(StepItemID)
		if StepItemIDArcimSeqNo'="" {
			s ItmInd=StepItemIDArcimSeqNo
			/* update by zf 20111027 ???
			s ItmInd=""
			for ARCIMInd=1:1:obj.CPWSIARCIM.Count() {
				q:ItmInd'=""
				s objARCIMTMP=obj.CPWSIARCIM.GetAt(ARCIMInd)
				continue:'$IsObject(objARCIMTMP)
				s ItmNo=objARCIMTMP.ITMNo
				s:StepItemIDArcimSeqNo=ItmNo ItmInd=ARCIMInd
			}
			*/
			continue:ItmInd=""
			s ARCIMobj=obj.CPWSIARCIM.GetAt(ItmInd)
			s ARCIMID=ARCIMobj.ITMARCIMDR
			
			if $l(ARCIMID,"||")=2 {  //医嘱项
				s:LinkNo'="" LinkNo=LinkNo_"^"_0
				s:LinkNo="" LinkNo=0
				s code=ARCIMobj.ITMARCIMDR
				s OrderPackQty=ARCIMobj.ITMQty
				s OrderFreqRowid=ARCIMobj.ITMFreqDR
				s OrderDurRowid=ARCIMobj.ITMDuratDR
				s OrderInstrRowid=ARCIMobj.ITMInstrucDR
				s OrderDoseUOMRowid=ARCIMobj.ITMUOMDR
				s OrderDoseQty=ARCIMobj.ITMDoseQty
				s ITMLinkNo=ARCIMobj.ITMLinkNo
				s OrderSeqNo=ARCIMobj.ITMNo
				s OrderResume=ARCIMobj.ITMResume
				
				s objCPWSISubCategory=obj.CPWSISubCategory
				s CPWSISubCategory=objCPWSISubCategory.SISCDesc
				s OrderPriorRowid=ARCIMobj.ITMPriority
				s OrderPriorDesc=$p($g(^OECPR(+OrderPriorRowid)),"^",2)
				if OrderPriorDesc="" {
					s OrderPriorRowid=tmpID
					s OrderPriorDesc=tmpDesc
				}
				
				if ITMLinkNo'="" do
				.Set $p(LinkNo,"^",ITMLinkNo)=$p(LinkNo,"^",ITMLinkNo)+1
				.s OrderSeqNo=ITMLinkNo_"."_$p(LinkNo,"^",ITMLinkNo)
				s OrderDoseUOM=""
				if OrderDoseUOMRowid'="" s OrderDoseUOM=$P(^CT("UOM",OrderDoseUOMRowid),"^",2)
				
				s OrderFreq="",OrderFreqFactor="",OrderFreqInterval=""
				if OrderFreqRowid'="" {
					s OrderFreq=$P($g(^PHCFR(OrderFreqRowid)),"^",3)
					s OrderFreqFactor=$P($g(^PHCFR(OrderFreqRowid)),"^",2)
					s OrderFreqInterval=$P($g(^PHCFR(OrderFreqRowid)),"^",5)
				}
				s OrderInstr=""
				if OrderInstrRowid'="" s OrderInstr=$P($g(^PHCIN(OrderInstrRowid)),"^",2)
				
				s OrderDurFactor="",OrderDur=""
				if OrderDurRowid'="" {
					s OrderDurFactor=$P($g(^PHCDU(OrderDurRowid)),"^",2)
					s OrderDur=$P($g(^PHCDU(OrderDurRowid)),"^",3)
				}
				
				s OrderPackUOM=""
				s OrderPackUOMRowid=$p($g(^ARCIM(+code,$p(code,"||",2),8)),"^",14)
				if OrderPackUOMRowid'="" s OrderPackUOM=$P($G(^CT("UOM",OrderPackUOMRowid)),"^",2)
				
				i OrderPriorRowid'="" s OrderPrior=$p($g(^OECPR(+OrderPriorRowid)),"^",2)
				
				s ItemData=OrderDoseQty_$C(1)_OrderDoseUOM_$C(1)_OrderDoseUOMRowid
				s ItemData=ItemData_"^"_OrderFreq_$C(1)_OrderFreqRowid_$C(1)_OrderFreqFactor_$C(1)_OrderFreqInterval
				s ItemData=ItemData_"^"_OrderInstr_$C(1)_OrderInstrRowid
				s ItemData=ItemData_"^"_OrderDur_$C(1)_OrderDurRowid_$C(1)_OrderDurFactor
				s ItemData=ItemData_"^"_OrderPackQty_$C(1)_OrderPackUOM_$C(1)_OrderPackUOMRowid
				//update by zf 2015-02-14 找郭荣勇修改内容
				//s ItemData=ItemData_"^"_OrderPrior_$C(1)_OrderPriorRowid_$c(1)_OrderResume
				//s ItemData=ItemData_"^^^"  //医嘱套ID、空、医嘱子类ID
				s ItemData=ItemData_"^"_OrderPrior_$C(1)_OrderPriorRowid_$c(1)_""
				s ItemData=ItemData_"^"_""
				s ItemData=ItemData_"^^"_""_"^"_OrderResume_"^"_""
				
				s OrderType=""
				s SubCatRowId=$p(^ARCIM(+code,$p(code,"||",2),1),"^",10)
				if SubCatRowId'="" s OrderType=$p(^ARC("IC",SubCatRowId),"^",7)
				
				s jsval=jsval_"Copyary[Copyary.length]="""_code_"!"_OrderSeqNo_"!"_ItemData_"!"_OrderType_"!!Order!"_xxxStepItemID_""";"
			}else{    //医嘱套
				s ARCOSRowId=ARCIMID
				if ARCOSRowId="" continue
				
				s rs=##Class(%ResultSet).%New("web.DHCDocOrderCommon:FindOSItems")
				d rs.Execute(ARCOSRowId)
				s columns = rs.GetColumnCount()
				while (rs.Next()) {
					s code=$ZCVT(rs.Data("ItemRowid"),"O","JS")
					s ItemData=$ZCVT(rs.Data("ItemData"),"O","JS")
					s Type=$ZCVT(rs.Data("ItemOrderType"),"O","JS")
					s OrderSeqNo=$ZCVT(rs.Data("ItemSeqNo"),"O","JS")
					s jsval=jsval_"Copyary[Copyary.length]="""_code_"!"_OrderSeqNo_"!"_ItemData_"!"_Type_"!!OSItem!"_xxxStepItemID_""";"
				}
				d rs.Close()
			}
		}else{    //医嘱套
			s ARCOSRowId=obj.CPWSIOrdSetDR
			if ARCOSRowId="" continue
			
			s rs=##Class(%ResultSet).%New("web.DHCDocOrderCommon:FindOSItems")
			d rs.Execute(ARCOSRowId)
			s columns = rs.GetColumnCount()
			while (rs.Next()) {
				s code=$ZCVT(rs.Data("ItemRowid"),"O","JS")
				s ItemData=$ZCVT(rs.Data("ItemData"),"O","JS")
				s Type=$ZCVT(rs.Data("ItemOrderType"),"O","JS")
				s OrderSeqNo=$ZCVT(rs.Data("ItemSeqNo"),"O","JS")
				s jsval=jsval_"Copyary[Copyary.length]="""_code_"!"_OrderSeqNo_"!"_ItemData_"!"_Type_"!!OSItem!"_xxxStepItemID_""";"
			}
			d rs.Close()
		}
		d obj.%Close()
	}
	if (itmjs'="")&&(jsval'="") {
		s jsval="var Copyary=new Array();"_jsval_itmjs_"(Copyary);"
		&javascript<#(jsval)#>
	}
	
	q 0
}

ClassMethod GetMaxItmNo(StepItemIDS As %String) As %String
{
	New (StepItemIDS)
	Set MaxItmNo=0
	Quit:StepItemIDS="" MaxItmNo
	
	Set LinkNo=""
	For i=1:1:$length(StepItemIDS) {
		Set StepItem=$P(StepItemIDS,",",i)
		Set StepItemID=$P(StepItem,"^",1)
		Set StepItemID=$p(StepItemID,"-",1)
		Set StepItemIDArcimSeqNo=$P(StepItem,"^",2)
		Continue:StepItemID=""
		Set obj=##class(User.DHCMRCClinPathWaysEpStepItem).%OpenId(StepItemID)
		If StepItemIDArcimSeqNo'="" {
			Set:LinkNo'="" LinkNo=LinkNo_"^"_0
			Set:LinkNo="" LinkNo=0
			
			Set ItmInd=""
			For ARCIMInd=1:1:obj.CPWSIARCIM.Count() {
				Quit:ItmInd'=""
				Set objARCIMTMP=obj.CPWSIARCIM.GetAt(ARCIMInd)
				Continue:'$IsObject(objARCIMTMP)
				Set ItmNo=objARCIMTMP.ITMNo
				Set:StepItemIDArcimSeqNo=ItmNo ItmInd=ARCIMInd
			}
			Continue:ItmInd=""
			
			Set ARCIMobj=obj.CPWSIARCIM.GetAt(ItmInd)
			Set ITMLinkNo=ARCIMobj.ITMLinkNo
			Set OrderSeqNo=ARCIMobj.ITMNo
			If OrderSeqNo>MaxItmNo {
				Set MaxItmNo=OrderSeqNo
			}
		}
	}
	
	Quit MaxItmNo
}

ClassMethod CheckStepItemIDS(aStepItemIDS As %String) As %String
{
	New (aStepItemIDS)
	Set return=""
	Quit:aStepItemIDS="" return
	
	Set $ZT="CheckStepItemIDSErr"
	Set ZIndex=$zn,JIndex=$j
	Kill ^TMP(ZIndex,JIndex,"CheckStepItemIDS")
	For itmInd=1:1:$length(aStepItemIDS,",") {
		Set StepItem=$p(aStepItemIDS,",",itmInd)
		Set StepItemID=$p(StepItem,"^",1)
		Set StepItemIDArcimSeqNo=$p(StepItem,"^",2)
		If StepItemID="" Continue
		Set objStepItem=##class(web.DHCCPW.MRC.PathWEpStepItem).GetObjById(StepItemID)
		Set StepItemARCIM=objStepItem.CPWSIARCIM
		Set StepItemGroupNo=objStepItem.CPWSIGroupNo
		If StepItemIDArcimSeqNo'="" {
			Set objARCIM=StepItemARCIM.GetAt(StepItemIDArcimSeqNo)
			If $IsObject(objARCIM){
				Set ITMGroupNo=+objARCIM.ITMGroupNo
				Set ITMIsMain=objARCIM.ITMIsMain
				Set ITMNo=+objARCIM.ITMNo
				Set ^TMP(ZIndex,JIndex,"CheckStepItemIDS","Data",+StepItemGroupNo,StepItemID,ITMGroupNo,ITMNo)=ITMIsMain
			}
		}
	}
	
	Set StepItemGroupNo=""
	For {
		Set StepItemGroupNo=$o(^TMP(ZIndex,JIndex,"CheckStepItemIDS","Data",StepItemGroupNo))
		Quit:StepItemGroupNo=""
		Set StepItemID=""
		For {
			Set StepItemID=$o(^TMP(ZIndex,JIndex,"CheckStepItemIDS","Data",StepItemGroupNo,StepItemID))
			Quit:StepItemID=""
			Set objStepItem=##class(web.DHCCPW.MRC.PathWEpStepItem).GetObjById(StepItemID)
			Set StepItemARCIM=objStepItem.CPWSIARCIM
			Set StepItemARCIMCnt=objStepItem.CPWSIARCIM.Count()
			For arcimInd=1:1:StepItemARCIMCnt {
				Set objARCIM=StepItemARCIM.GetAt(arcimInd)
				If $IsObject(objARCIM){
					Set ITMGroupNo=+objARCIM.ITMGroupNo
					Set ITMIsMain=objARCIM.ITMIsMain
					Set ITMNo=+objARCIM.ITMNo
					Set ^TMP(ZIndex,JIndex,"CheckStepItemIDS","TmpData",StepItemGroupNo,StepItemID,ITMGroupNo,ITMNo)=ITMIsMain
				}
			}
			Set ITMGroupNo=0  //无分组医嘱项不再考虑
			For {
				Set ITMGroupNo=$o(^TMP(ZIndex,JIndex,"CheckStepItemIDS","Data",StepItemGroupNo,StepItemID,ITMGroupNo))
				Quit:ITMGroupNo=""
				
				Set ITMNo=""
				For {
					Set ITMNo=$o(^TMP(ZIndex,JIndex,"CheckStepItemIDS","Data",StepItemGroupNo,StepItemID,ITMGroupNo,ITMNo))
					Quit:ITMNo=""
					Set ITMIsMain=$g(^TMP(ZIndex,JIndex,"CheckStepItemIDS","Data",StepItemGroupNo,StepItemID,ITMGroupNo,ITMNo))
					Continue:ITMIsMain'["Y"
					
					Set xITMNo=""
					For {
						Set xITMNo=$o(^TMP(ZIndex,JIndex,"CheckStepItemIDS","TmpData",StepItemGroupNo,StepItemID,ITMGroupNo,xITMNo))
						Quit:xITMNo=""
						Set xITMIsMain=$g(^TMP(ZIndex,JIndex,"CheckStepItemIDS","TmpData",StepItemGroupNo,StepItemID,ITMGroupNo,xITMNo))
						Set ^TMP(ZIndex,JIndex,"CheckStepItemIDS","Data",StepItemGroupNo,StepItemID,ITMGroupNo,xITMNo)=xITMIsMain
					}
					Quit  //同一步骤和组只取一次
				}
			}
			Set ITMGroupNo=""
			For {
				Set ITMGroupNo=$o(^TMP(ZIndex,JIndex,"CheckStepItemIDS","Data",StepItemGroupNo,StepItemID,ITMGroupNo))
				Quit:ITMGroupNo=""
				Set ITMNo=""
				For {
					Set ITMNo=$o(^TMP(ZIndex,JIndex,"CheckStepItemIDS","Data",StepItemGroupNo,StepItemID,ITMGroupNo,ITMNo))
					Quit:ITMNo=""
					Set return=return_","_StepItemID_"^"_ITMNo
				}
			}
		}
	}
	Kill ^TMP(ZIndex,JIndex,"CheckStepItemIDS")
	
	Set:return'="" return=$e(return,2,$l(return))
	Quit return
	
CheckStepItemIDSErr
	Quit ""
}

/// Creator：     zhufei
/// CreatDate：   2010-07-26
/// Description:  根据EpisodeID做临床路径出径操作
/// Table：       User.DHCMRClinicalPathWay
/// Input：       EpisodeID ：Paadm
/// Return：      return<0 不成功；return>0 成功；return=0 没有入径记录，不需要出境
/// w ##class(web.DHCCPW.MR.ClinicalPathWays).ClosePathWay(EpisodeID,OutDoctor,OutDate,OutTime,UpdateUser)
ClassMethod ClosePathWay(EpisodeID, OutDoctor, OutDate, OutTime) As %String
{
	New (EpisodeID,OutDoctor,OutDate,OutTime)
	Set return=0
	
	Quit:EpisodeID="" return
	Set MRAdm=$p($g(^PAADM(EpisodeID)),"^",61)
	Set:OutDoctor="" OutDoctor=$p($g(^PAADM(EpisodeID)),"^",19)
	//Set:OutDate="" OutDate=$p($g(^PAADM(EpisodeID)),"^",17)
	//Update by pylian 2016-01-22 修改出院时间取值方式
	Set DischDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateTime(EpisodeID)
	Set DischDate=$p(DischDateTime,"^",1)
	Set:OutDate="" OutDate=DischDate
	Set:OutTime="" OutTime=$p($g(^PAADM(EpisodeID)),"^",18)
	Quit:MRAdm="" return
	
	Set:OutDate["-" OutDate=$zdh(OutDate,3)
	Set:OutDate["/" OutDate=$zdh(OutDate,4)
	Set OutDate=+OutDate
	Set:OutDate<1 OutDate=+$h
	Set:OutTime[":" OutTime=$zth(OutTime,1)
	Set OutTime=+OutTime
	Set:OutTime<1 OutTime=$p($h,",",2)
	
	Set ID=0
	For {
		Set ID=$o(^DHCMRi("CPW",0,"IndexMRAdm"," "_MRAdm,ID))
		Quit:ID=""
		Set obj=##Class(User.DHCMRClinicalPathWay).%OpenId(ID)
		Continue:obj=""
		Set obj.CPWStatus="C"
		Set obj.CPWOutDoctorDR=OutDoctor
		Set obj.CPWOutDate=OutDate
		Set obj.CPWOutTime=OutTime
		//Set obj.CPWUpdateUserDR=UpdateUser
		Set obj.CPWUpdateDate=+$h
		Set obj.CPWUpdateTime=$p($h,",",2)
		Set sc=obj.%Save()
		If $System.Status.IsError(sc) {    //检查Save是否成功
   			Do $system.OBJ.DisplayError(sc) 
   			Set return=-1
		} Else {
			Set return=obj.%Id()
			//add by zf 2012-01-10
			Set flg1=##Class(web.DHCCPW.MR.InterfaceToPrj).ClosePathWayToHIS(EpisodeID)
		}
		Do obj.%Close()
	}
	Quit return
}

/*
/// w ##class(web.DHCCPW.MR.ClinicalPathWays).GetEpisodeID(4939742)
ClassMethod GetEpisodeID(argMRAdm As %String) As %String
{
	New (argMRAdm)
	Set return=$p($g(^MR(+argMRAdm,"PRO",1)),"^",9)
	Quit return
}

/// w ##class(web.DHCCPW.MR.ClinicalPathWays).GetMRAdm(4939148)
ClassMethod GetMRAdm(argEpisodeID As %String) As %String
{
	New (argEpisodeID)
	Set return=$p($g(^PAADM(+argEpisodeID)),"^",61)
	Quit return
}
*/
/// Creator：     zhufei
/// CreatDate：   2011-01-26
/// Description:  根据就诊号取当前执行路径
/// Table：       User.DHCMRClinicalPathWay
/// Input：       EpisodeID ：Paadm
/// Return：      
/// w ##class(web.DHCCPW.MR.ClinicalPathWays).GetActiveCPWByMradm(EpisodeID)
ClassMethod GetActiveCPWByMradm(EpisodeID As %String)
{
	Set argEpisodeID=$p(^PAADM(EpisodeID),"^",61)
	Quit ..GetActiveCPWByadm(argEpisodeID)
}

/// Creator：     zhufei
/// CreatDate：   2011-01-26
/// Description:  根据就诊号取当前执行路径ID
/// Table：       User.DHCMRClinicalPathWay
/// Input：       EpisodeID ：Paadm
/// Return：      
/// w ##class(web.DHCCPW.MR.ClinicalPathWays).GetActiveCPWByMradm(EpisodeID)
ClassMethod GetInUseMRCPW(argEpisodeID As %String)
{
	New (argEpisodeID)
	Set return=""
	Set return=..GetActiveCPWByMradm(argEpisodeID)
	Set return=+return
	Quit return
}

/// w ##class(web.DHCCPW.MR.ClinicalPathWays).GetEpisodeID(4939742)
ClassMethod GetEpisodeID(argMRAdm As %String) As %String
{
	New (argMRAdm)
	Set return=##class(web.DHCCPW.MR.PAADMSrv).GetEpisodeID(argMRAdm)
	Quit return
}

/// w ##class(web.DHCCPW.MR.PAADMSrv).GetMRAdm(4939148)
ClassMethod GetMRAdm(argEpisodeID As %String) As %String
{
	New (argEpisodeID)
	Set return=##class(web.DHCCPW.MR.PAADMSrv).GetMRAdm(argEpisodeID)
	Quit return
}

/// Creator:		zhufei          
/// CreatDate:		2011-06-13 
/// Description:	将临床路径对应的医嘱直接增加到医嘱录入界面上
/// Table:        	DHC_MRC_ClinPathWaysEpStepItem,DHC_MRC_ClinicalPathways
/// Input:        	以"^"分隔的参数串：步骤ID_"^"_医嘱项序号
/// Return:       	
/// Others:			w ##class(web.DHCCPW.MR.ClinicalPathWays).AddMRCPWItemToListToVB("","")
ClassMethod AddMRCPWItemToListToVB(argPathWayID As %String, argStepItemIDS As %String) As %String
{
	New (argPathWayID,argStepItemIDS)
	Set return=""
	Quit:(argPathWayID="")||(argStepItemIDS="") return
	
	Set $zt="AddMRCPWItemToListToVBErr"
	Set ZIndex=$zn,JIndex=$j
	Kill ^TMP(ZIndex,JIndex,"ARCIMToVB")
	
	//取临时医嘱类型对应ID
	Set tmpID=$o(^OECPR(0,"Desc","临时医嘱",""))
	Set:tmpID="" tmpID=$o(^OECPR(0))
	Set tmpDesc=$p($g(^OECPR(+tmpID)),"^",2)
	
	Set StepItemIDS=argStepItemIDS
	For i=1:1:$length(StepItemIDS) {
		Set StepItem=$P(StepItemIDS,",",i)
		Set xxxStepItemID=$P(StepItem,"^",1)
		Set StepItemID=$p(xxxStepItemID,"-",1)
		Set ArcimSeqNo=$P(StepItem,"^",2)
		Continue:(StepItemID="")||(ArcimSeqNo="")
		
		Set obj=##class(web.DHCCPW.MRC.PathWEpStepItem).GetObjById(StepItemID)
		Continue:'$IsObject(obj)
		Set ItmInd=ArcimSeqNo
		/* update by zf 20111027 ???
		Set ItmInd=""
		For ARCIMInd=1:1:obj.CPWSIARCIM.Count() {
			Quit:ItmInd'=""
			Set objARCIMTMP=obj.CPWSIARCIM.GetAt(ARCIMInd)
			Continue:'$IsObject(objARCIMTMP)
			Set ItmNo=objARCIMTMP.ITMNo
			Set:ArcimSeqNo=ItmNo ItmInd=ARCIMInd
		}
		*/
		Continue:ItmInd=""
		
		Set ARCIMobj=obj.CPWSIARCIM.GetAt(ItmInd)
		Set ARCIMID=ARCIMobj.ITMARCIMDR                    //医嘱项
		Set OrderPackQty=ARCIMobj.ITMQty                   //数量
		Set OrderFreqRowid=ARCIMobj.ITMFreqDR              //频次
		Set OrderDurRowid=ARCIMobj.ITMDuratDR              //疗程
		Set OrderInstrRowid=ARCIMobj.ITMInstrucDR          //用法
		Set OrderDoseUOMRowid=ARCIMobj.ITMUOMDR            //剂量单位
		Set OrderDoseQty=ARCIMobj.ITMDoseQty               //剂量
		Set ITMLinkNo=ARCIMobj.ITMLinkNo                   //关联号
		Set OrderSeqNo=ARCIMobj.ITMNo                      //序号
		Set OrderResume=ARCIMobj.ITMResume                 //备注
		Set OrderPriorRowid=ARCIMobj.ITMPriority           //医嘱类型
		Set OrderPrior=""
		Set:OrderPriorRowid'="" OrderPrior=$p($g(^OECPR(OrderPriorRowid)),"^",2)
		If OrderPrior="" {
			Set OrderPriorRowid=tmpID
			Set OrderPrior=tmpDesc
		}
		
		If $l(ARCIMID,"||")=2 {    //医嘱项
			Set OrderDoseUOM=""
			Set:OrderDoseUOMRowid'="" OrderDoseUOM=$P(^CT("UOM",OrderDoseUOMRowid),"^",2)
			
			Set OrderFreq="",OrderFreqFactor="",OrderFreqInterval=""
			If OrderFreqRowid'="" {
				Set OrderFreq=$P($g(^PHCFR(OrderFreqRowid)),"^",3)
				Set OrderFreqFactor=$P($g(^PHCFR(OrderFreqRowid)),"^",2)
				Set OrderFreqInterval=$P($g(^PHCFR(OrderFreqRowid)),"^",5)
			}
			Set OrderInstr=""
			Set:OrderInstrRowid'="" OrderInstr=$P($g(^PHCIN(OrderInstrRowid)),"^",2)
			
			Set OrderDurFactor="",OrderDur=""
			If OrderDurRowid'="" {
				Set OrderDurFactor=$P($g(^PHCDU(OrderDurRowid)),"^",2)
				Set OrderDur=$P($g(^PHCDU(OrderDurRowid)),"^",3)
			}
			Set OrderPackUOM=""
			Set OrderPackUOMRowid=$p($g(^ARCIM(+ARCIMID,+$p(ARCIMID,"||",2),8)),"^",14)
			Set:OrderPackUOMRowid'="" OrderPackUOM=$P($G(^CT("UOM",OrderPackUOMRowid)),"^",2)
			
			Set num=$i(^TMP(ZIndex,JIndex,"ARCIMToVB"))
			
			Set ARCIMStr=""                              //序号
			Set ARCIMStr=ARCIMStr_"^"_""                 //关联号
			Set ARCIMStr=ARCIMStr_"^"_ARCIMID            //医嘱项ID
			Set ARCIMStr=ARCIMStr_"^"_OrderPackQty       //数量
			Set ARCIMStr=ARCIMStr_"^"_OrderFreqRowid     //频次ID
			Set ARCIMStr=ARCIMStr_"^"_OrderDurRowid      //疗程ID
			Set ARCIMStr=ARCIMStr_"^"_OrderInstrRowid    //用法ID
			Set ARCIMStr=ARCIMStr_"^"_OrderDoseUOMRowid  //剂量单位ID
			Set ARCIMStr=ARCIMStr_"^"_OrderDoseQty       //剂量
			Set ARCIMStr=ARCIMStr_"^"_OrderPriorRowid    //医嘱类型ID
			Set ARCIMStr=ARCIMStr_"^"_OrderPrior         //医嘱类型
			Set ARCIMStr=ARCIMStr_"^"_OrderResume        //备注
			Set ARCIMStr=ARCIMStr_"^"_""                 //医嘱套ID
			Set ARCIMStr=ARCIMStr_"^"_""                 //医嘱套子ID
			Set ARCIMStr=ARCIMStr_"^"_""                 //检验码
			
			Set ^TMP(ZIndex,JIndex,"ARCIMToVB","Data",num)=ARCIMStr
			Set ^TMP(ZIndex,JIndex,"ARCIMToVB","SeqNoToLinkNo",xxxStepItemID_"||"_ArcimSeqNo_"||1")=xxxStepItemID_"||"_ITMLinkNo_"||1"
			Set ^TMP(ZIndex,JIndex,"ARCIMToVB","SeqNoToBaseNo",xxxStepItemID_"||"_ArcimSeqNo_"||1")=num
			Set ^TMP(ZIndex,JIndex,"ARCIMToVB","BaseNoToSeqNo",num)=xxxStepItemID_"||"_ArcimSeqNo_"||1"
		}Else{    //医嘱套
			Set rs=##Class(%ResultSet).%New("web.DHCDocOrderCommon:FindOSItems")
			Do rs.Execute(ARCIMID)
			Set columns = rs.GetColumnCount()
			Set ARCOSNum=0
			While (rs.Next()) {
				Set ArcimRowid=rs.Data("ItemRowid")
				Set ItemData=rs.Data("ItemData")
				Set OrderPackQty=$p($p(ItemData,"^",5),$c(1),1)
				Set OrderFreqRowid=$p($p(ItemData,"^",2),$c(1),2)
				Set OrderDurRowid=$p($p(ItemData,"^",4),$c(1),2)
				Set OrderInstrRowid=$p($p(ItemData,"^",3),$c(1),2)
				Set OrderDoseUOMRowid=$p($p(ItemData,"^",1),$c(1),3)
				Set OrderDoseQty=$p($p(ItemData,"^",1),$c(1),1)
				Set ARCOSRowid=$p(ItemData,"^",7)
				Set ARCOSSubCatRowid=$p(ItemData,"^",9)
				Set ARCOSNum=$i(ARCOSNum)
				Set ARCOSSubCatRowid=ARCOSNum
				Set LabSetNo=$p($g(^ARCOS(+ARCOSRowid)),"^",11)
				
				Set num=$i(^TMP(ZIndex,JIndex,"ARCIMToVB"))
				
				Set ARCIMStr=""                              //序号
				Set ARCIMStr=ARCIMStr_"^"_""                 //关联号
				Set ARCIMStr=ARCIMStr_"^"_ArcimRowid         //医嘱项ID
				Set ARCIMStr=ARCIMStr_"^"_OrderPackQty       //数量
				Set ARCIMStr=ARCIMStr_"^"_OrderFreqRowid     //频次ID
				Set ARCIMStr=ARCIMStr_"^"_OrderDurRowid      //疗程ID
				Set ARCIMStr=ARCIMStr_"^"_OrderInstrRowid    //用法ID
				Set ARCIMStr=ARCIMStr_"^"_OrderDoseUOMRowid  //剂量单位ID
				Set ARCIMStr=ARCIMStr_"^"_OrderDoseQty       //剂量
				Set ARCIMStr=ARCIMStr_"^"_OrderPriorRowid    //医嘱类型ID
				Set ARCIMStr=ARCIMStr_"^"_OrderPrior         //医嘱类型
				Set ARCIMStr=ARCIMStr_"^"_OrderResume        //备注
				Set ARCIMStr=ARCIMStr_"^"_ARCOSRowid         //医嘱套ID
				Set ARCIMStr=ARCIMStr_"^"_ARCOSSubCatRowid   //医嘱套子ID
				Set ARCIMStr=ARCIMStr_"^"_LabSetNo           //检验码
				
				Set ^TMP(ZIndex,JIndex,"ARCIMToVB","Data",num)=ARCIMStr
				Set ^TMP(ZIndex,JIndex,"ARCIMToVB","SeqNoToLinkNo",xxxStepItemID_"||"_ArcimSeqNo_"||"_ARCOSSubCatRowid)=xxxStepItemID_"||"_ITMLinkNo_"||"_ARCOSSubCatRowid
				Set ^TMP(ZIndex,JIndex,"ARCIMToVB","SeqNoToBaseNo",xxxStepItemID_"||"_ArcimSeqNo_"||"_ARCOSSubCatRowid)=num
				Set ^TMP(ZIndex,JIndex,"ARCIMToVB","BaseNoToSeqNo",num)=xxxStepItemID_"||"_ArcimSeqNo_"||"_ARCOSSubCatRowid
			}
			Do rs.Close()
		}
	}
	
	Set num=0
	For {
		Set num=$o(^TMP(ZIndex,JIndex,"ARCIMToVB","Data",num))
		Quit:num=""
		Set SeqNo=$g(^TMP(ZIndex,JIndex,"ARCIMToVB","BaseNoToSeqNo",num))
		Set LinNo=$g(^TMP(ZIndex,JIndex,"ARCIMToVB","SeqNoToLinkNo",SeqNo))
		Set:LinNo'="" LinNo=$g(^TMP(ZIndex,JIndex,"ARCIMToVB","SeqNoToBaseNo",LinNo))
		Set Data=$g(^TMP(ZIndex,JIndex,"ARCIMToVB","Data",num))
		Continue:Data=""
		Set $p(Data,"^",1)=num
		Set $p(Data,"^",2)=LinNo
		Set return=return_$c(2)_Data
	}
	Kill ^TMP(ZIndex,JIndex,"ARCIMToVB")
	
	Set:return'="" return=$e(return,2,$l(return))
	Quit return
	
AddMRCPWItemToListToVBErr
	Quit ""
}

/// Creator:		zhufei          
/// CreatDate:		2011-07-21
/// Description:	增加临床路径并发症或合并症
/// Table:        	DHC_MR_ClinicalPathway
/// Input:        	argPathWayID：入径记录ID
///                 argCompCPWID：并发症路径ID
/// Return:       	ret<=0:Error ret>0:Success
/// Others:			w ##class(web.DHCCPW.MR.ClinicalPathWays).AddComplication("1","2")
ClassMethod AddComplication(argPathWayID As %String, argCompCPWID As %String) As %String
{
	New (argPathWayID,argCompCPWID)
	Set return=0
	
	Set obj=##class(User.DHCMRClinicalPathWay).%OpenId(argPathWayID)
	Quit:'$IsObject(obj) return
	
	Set SaveIndex=""
	For CompListInd=1:1:obj.CPWCompList.Count() {
		Quit:SaveIndex'=""
		Set CompCPWID=obj.CPWCompList.GetAt(CompListInd)
		Continue:CompCPWID=""
		Continue:CompCPWID'=argCompCPWID
		Set SaveIndex=CompListInd
	}
	
	If SaveIndex'="" {
		Do obj.CPWCompList.SetAt(argCompCPWID,SaveIndex)
	}Else{
		Do obj.CPWCompList.Insert(argCompCPWID)
	}
	
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {                      //检查Save是否成功
   		//Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	Quit return
}

/// Creator:		zhufei          
/// CreatDate:		2011-07-26
/// Description:	删除临床路径并发症或合并症前的检查
/// Table:        	DHC_MR_ClinicalPathway
/// Input:        	argPathWayID：入径记录ID
///                 argCompCPWID：并发症路径ID
/// Return:       	ret<=0:Error ret>0:Success
/// Others:			w ##class(web.DHCCPW.MR.ClinicalPathWays).CheckCompToDel("1","2")
ClassMethod CheckCompToDel(argPathWayID As %String, argCompCPWID As %String) As %String
{
	New (argPathWayID,argCompCPWID)
	Set return=""
	Quit:(argCompCPWID="")||(argPathWayID="") return
	
	Set objComp=##class(web.DHCCPW.MRC.CliPathWay).GetObjById(argCompCPWID)
	Quit:'$IsObject(objComp) return
	Set CompDesc=objComp.CPWDesc
	
	//有实施记录不允许删除合并症
	//^DHCMRi(0,"IMPL","IndexStepItem",10,"8||1||1||1",1)
	Set IsHaveImpl="N"
	Set ItemID=argCompCPWID
	For {
		Set ItemID=$o(^DHCMRi(0,"IMPL","IndexStepItem",argPathWayID,ItemID))
		Quit:ItemID=""
		Quit:$p(ItemID,"||",1)'=argCompCPWID
		Quit:IsHaveImpl="Y"
		Set SubID=0
		For {
			Set SubID=$o(^DHCMRi(0,"IMPL","IndexStepItem",argPathWayID,ItemID,SubID))
			Quit:SubID=""
			Quit:IsHaveImpl="Y"
			Set ImplementID=argPathWayID_"||"_SubID
			Set objImplement=##class(web.DHCCPW.MR.Implement).GetObjById(ImplementID)
			Continue:'$IsObject(objImplement)
			Set Active=objImplement.CPWEActive
			Continue:Active["N"
			Set IsHaveImpl="Y"
		}
	}
	Set:IsHaveImpl="Y" return=return_"实施记录,"
	
	Set:return'="" return="合并症 "_CompDesc_" 已产生"_return_"不允许再删除!"
	Quit return
}

/// Creator:		zhufei          
/// CreatDate:		2011-07-21
/// Description:	删除临床路径并发症或合并症
/// Table:        	DHC_MR_ClinicalPathway
/// Input:        	argPathWayID：入径记录ID
///                 argCompCPWID：并发症路径ID
/// Return:       	ret<=0:Error ret>0:Success
/// Others:			w ##class(web.DHCCPW.MR.ClinicalPathWays).DelComplication("1","2")
ClassMethod DelComplication(argPathWayID As %String, argCompCPWID As %String) As %String
{
	New (argPathWayID,argCompCPWID)
	Set return=0
	Quit:(argCompCPWID="")||(argPathWayID="") return
	
	Set obj=##class(User.DHCMRClinicalPathWay).%OpenId(argPathWayID)
	Quit:'$IsObject(obj) return
	
	Set SaveIndex=""
	For CompListInd=1:1:obj.CPWCompList.Count() {
		Set CompCPWID=obj.CPWCompList.GetAt(CompListInd)
		Continue:CompCPWID=""
		Continue:CompCPWID'=argCompCPWID
		Set SaveIndex=CompListInd
		Do obj.CPWCompList.SetAt("",SaveIndex)
	}
	
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {                      //检查Save是否成功
   		//Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	Quit return
}

/// w ##Class(web.DHCCPW.MR.ClinicalPathWays).IsTuneUpEpStep(11)
ClassMethod IsTuneUpEpStep(aPathWayID As %String) As %String
{
	New (aPathWayID)
	Set return="N"
	Quit:aPathWayID="" return
	
	Set $ZT="IsTuneUpEpStepErr"
	Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(aPathWayID)
	Quit:'$IsObject(objPathWay) return
	
	//判断是否弹出步骤调整界面
	Set IsOffShootCPW=objPathWay.CPWPathwayDR.CPWOffShoot
	Set EstChildSub=$o(^DHCMR("CPW",aPathWayID,"EST",""),-1)
	If (IsOffShootCPW["Y")&&(EstChildSub="") {
		Set return="Y"
	}
	Quit return
	
IsTuneUpEpStepErr
	Set return="N"
	Quit return
}

/// add by niepeng 20170608 取入过路径列表ID
/// w ##class(web.DHCCPW.MR.ClinicalPathWays).GetOldPathWayID(1)
ClassMethod GetOldPathWayID(argMRAdm) As %String
{
	New (argMRAdm)
	set ret=""
	Quit:argMRAdm="" ret
	Quit:'$d(^DHCMRi("CPW",0,"IndexMRAdm"," "_argMRAdm)) ret
	
	Set (CPWPathwayDR)=""
	Set ClinPathWaysID=""
	For {
		Set ClinPathWaysID=$o(^DHCMRi("CPW",0,"IndexMRAdm"," "_argMRAdm,ClinPathWaysID),-1)
		Quit:ClinPathWaysID=""
		Set obj=..GetObjById(ClinPathWaysID)
		Continue:'$IsObject(obj)
		If $IsObject(obj.CPWPathwayDR)
		{
			Set CPWPathwayDR=obj.CPWPathwayDR.%Id()
		}
		Set ret=ret_"^"_CPWPathwayDR
	}
	quit ret
}

/// add by niepeng 20170619 判断是否有该路径下对应诊断
/// w ##class(web.DHCCPW.MR.ClinicalPathWays).GetIsCPWICD(1,82)
ClassMethod GetIsCPWICD(aPaadm As %String, aCPWID As %String) As %String
{
	New (aPaadm,aCPWID)
	Set return=0
	Quit:(aPaadm="")||(aCPWID="") return
	
	//取病种ICD
	Set objPathWay=##class(User.DHCMRCClinPathWays).GetObjById(aCPWID)
	Quit:'$IsObject(objPathWay) return
	Set CPWICD=objPathWay.CPWICD
	Set CPWKeys=objPathWay.CPWKeys
	
	Set MRAdm=$p($g(^PAADM(+aPaadm)),"^",61)
	Set GetCPWICDType=##class(web.DHCCPW.MRC.BaseConfig).GetValueByCode("GetCPWICDType")  //诊断判断类型(基础参数设置)
	Set MrDiagnoseSub=""
	For {
		Set MrDiagnoseSub=$o(^MR(MRAdm,"DIA",MrDiagnoseSub))
		Quit:MrDiagnoseSub=""
		Quit:return=1
		
		Set MRCICDRowid=$p($g(^MR(MRAdm,"DIA",MrDiagnoseSub)),"^",1)
		Continue:MRCICDRowid=""
		Set tmpICD=##Class(web.DHCCPW.MR.SysBaseSrv).GetMRCICDDX(MRCICDRowid)
		Set ICD10=$p(tmpICD,"^",4)
		Set ICDDesc=$p(tmpICD,"^",3)
		Continue:(ICD10="")&&(ICDDesc="")
		Set TypeDicCode=""
		Set MRDiagType=$o(^MR(MRAdm,"DIA",MrDiagnoseSub,"TYP",0))
		If MRDiagType'="" {
			Set TypeDicID=$p($g(^MR(MRAdm,"DIA",MrDiagnoseSub,"TYP",MRDiagType)),"^",1)
			Set TypeDicCode=$p($g(^MRC("DTYP",+TypeDicID)),"^",1)
		}
		If (GetCPWICDType=1){		//主要诊断
			Continue:TypeDicCode'="M" 
		}
		ElseIf (GetCPWICDType=3){		//初步诊断
			Continue:TypeDicCode'="PRE"
		}
		ElseIf (GetCPWICDType=4){		//入院诊断
			Continue:TypeDicCode'="C008"
		}
		else {	//所有诊断
		}
		Set flg1=##Class(web.DHCCPW.MR.SysBaseSrv).CheckICDArea(ICD10,CPWICD)
		Set flg2=##Class(web.DHCCPW.MR.SysBaseSrv).CheckKeysArea(ICDDesc,CPWKeys)
		Continue:(flg1<=0)&&(flg2<=0)
		
		Set return=1
	}
	
	Quit return
}

/// w ##Class(web.DHCCPW.MR.ClinicalPathWays).IsInPathWay(11)
ClassMethod IsInPathWay(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set reuturn="N"
	Quit:aEpisodeID="" return
	
	Set $ZT="IsInPathWayErr"
	
	Set MRAdm=##class(web.DHCCPW.MR.PAADMSrv).GetMRAdm(aEpisodeID)
	Quit:MRAdm="" return
	Quit:'$d(^DHCMRi("CPW",0,"IndexMRAdm"," "_MRAdm)) return
	
	Set CPWID=0
	For {
		Set CPWID=$o(^DHCMRi("CPW",0,"IndexMRAdm"," "_MRAdm,CPWID))
		Quit:CPWID=""
		Set obj=..GetObjById(CPWID)
		If $IsObject(obj)
		{
			Set Status=obj.CPWStatus
		} Else {
			Set Status=""
		}
		Continue:Status'="I"
		Set return="Y"
	}
	
	Quit return
	
IsInPathWayErr
	Quit "N"
}

Storage Default
{
<Data name="ClinicalPathWaysDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCCPW.MR.ClinicalPath650D</DataLocation>
<DefaultData>ClinicalPathWaysDefaultData</DefaultData>
<IdLocation>^web.DHCCPW.MR.ClinicalPath650D</IdLocation>
<IndexLocation>^web.DHCCPW.MR.ClinicalPath650I</IndexLocation>
<StreamLocation>^web.DHCCPW.MR.ClinicalPath650S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
