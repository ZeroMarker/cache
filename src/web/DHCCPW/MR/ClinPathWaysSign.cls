/// 名称: web.DHCCPW.MR.ClinPathWaysSign
/// 描述: 患者临床路径签名记录
/// 编写者：zhufei
/// 编写日期: 2010-06-27
Class web.DHCCPW.MR.ClinPathWaysSign Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2010-06-27
/// Description:  根据ID取临床路径签名记录
/// Table：       User.DHCMRClinicalPathWaySign
/// Input：       ID:    User.DHCMRClinicalPathWaySign.Id
///               separete: 指定的分隔符
/// Return：      返回object
/// w ##class(web.DHCCPW.MR.ClinPathWaysSign).GetObjById(1)
ClassMethod GetObjById(argId As %String) As User.DHCMRClinicalPathWaySign
{
	New (argId)
	Set return=##Class(User.DHCMRClinicalPathWaySign).%OpenId(argId)
	Do:return'="" return.%Close()
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2010-06-27
/// Description:  更新User.DHCMRClinicalPathWaySign
/// Table：       User.DHCMRClinicalPathWaySign
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1:Rowid 2:CPWSEpStepDR 3:CPWSDoctorDR 4:CPWSNurseDR 5:CPWSActive
/// 6:CPWSDate 7:CPWSTime 8:CPWSUserDR 9:CPWSUpdoDate 10:CPWSUpdoTime
/// 11:CPWSUpdoUserDR
/// w ##class(web.DHCCPW.MR.ClinPathWaysSign).Update(InPutStr)
ClassMethod Update(argInStr As %String) As %String
{
	New (argInStr)
	Set return=-1
	Set ID=$p(argInStr,"^",1)
	Set Parref=$p(ID,"||",1)
	Set ChildSub=$p(ID,"||",2)
	If ChildSub="" {
		Set obj=##class(User.DHCMRClinicalPathWaySign).%New()
	} Else {
		Set obj=##class(User.DHCMRClinicalPathWaySign).%OpenId(ID)
		Quit:obj="" return
	}
	
	Set objParref=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(Parref)
	Quit:objParref="" return
	
	Set EpStepDR=$p(argInStr,"^",2)
	Set objEpStep=##class(web.DHCCPW.MRC.PathWEpStep).GetObjById(EpStepDR)
	Quit:objEpStep="" return
	
	Set DoctorDR=$p(argInStr,"^",3)
	Set NurseDR=$p(argInStr,"^",4)
	Quit:(DoctorDR="")&&(NurseDR="") return
	
	Set ImplNewDR=$p(argInStr,"^",12)
	If (ImplNewDR'="") {
		Set objImplNew=##class(web.DHCCPW.OPCPW.InterfaceOP).GetObjByImplNewID(ImplNewDR)
		Quit:'$IsObject(objImplNew) return
	}
	
	Set IsActive=$p(argInStr,"^",5)
	Set IsActive=$s(IsActive["Y":"Y",1:"N")
	Set Date=$p(argInStr,"^",6)
	Set Time=$p(argInStr,"^",7)
	Set:Date["/" Date=$zdh(Date,4)
	Set:Date["-" Date=$zdh(Date,3)
	Set Date=$s(Date'="":+Date,1:+$h)
	Set:Time[":" Time=$zth(Time,2)
	Set Time=$s(Time'="":+Time,1:$p($h,",",2))
	Set UserDR=$p(argInStr,"^",8)
	
	Set obj.CPWSParRef=objParref
	Set obj.CPWSEpStepDR=objEpStep
	Set obj.CPWSDoctorDR=DoctorDR
	Set obj.CPWSNurseDR=NurseDR
	Set obj.CPWSActive=IsActive
	Set obj.CPWSDate=Date
	Set obj.CPWSTime=Time
	Set obj.CPWSUserDR=UserDR
	Set:(ImplNewDR'="") obj.CPWSImplNewDR=objImplNew
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {                      //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2010-06-27
/// Description:  更新User.DHCMRClinicalPathWaySign
/// Table：       User.DHCMRClinicalPathWaySign
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1:Rowid 2:CPWSUpdoUserDR
/// w ##class(web.DHCCPW.MR.ClinPathWaysSign).UpdoSign(InPutStr)
ClassMethod UpdoSign(argInStr As %String) As %String
{
	New (argInStr)
	Set return=-1
	Quit:argInStr="" return
	
	Set $ZT="UpdoSignErr"
	Set ID=$p(argInStr,"^",1)
	Set UserDR=$p(argInStr,"^",2)
	Set obj=##class(User.DHCMRClinicalPathWaySign).%OpenId(ID)
	Quit:obj="" return
	
	Set obj.CPWSActive="N"
	Set obj.CPWSUpdoDate=+$h
	Set obj.CPWSUpdoTime=$p($h,",",2)
	Set obj.CPWSUpdoUserDR=UserDR
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {                      //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
	
UpdoSignErr
	Quit -1
}

/// Creator：     zhufei
/// CreatDate：   2011-06-27
/// Description:  取阶段步骤对应临床路径签名记录
/// Input：       User.DHCMRClinicalPathWay.ID
///               User.DHCMRCClinPathWaysEpStep.ID
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MR.ClinPathWaysSign","QrySignByStep",9,"8||2||1","D")
Query QrySignByStep(argPathWaysID As %String, argStepID As %String, argType As %String) As %Query(ROWSPEC = "SignID:%String,SignCareProvDR:%String,SignCareProvName:%String,SignDate:%String,SignTime:%String,SignUserDR:%String,SignUserDesc:%String")
{
}

ClassMethod QrySignByStepExecute(ByRef qHandle As %Binary, argPathWaysID As %String, argStepID As %String, argType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Quit:argPathWaysID="" $$$OK
	Quit:'$d(^DHCMR("CPW",argPathWaysID,"SIGN")) $$$OK
	
	Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(argPathWaysID)
	Quit:objPathWay="" $$$OK
	
	Set SignID=""
	For {
		Set SignID=$o(^DHCMR("CPW",argPathWaysID,"SIGN",SignID),-1)
		Quit:SignID=""
		
		Set SignRowid=argPathWaysID_"||"_SignID
		Set objSign=##class(web.DHCCPW.MR.ClinPathWaysSign).GetObjById(SignRowid)
		Continue:'$IsObject(objSign)
		Continue:objSign.CPWSActive'="Y"
		If argType["D" {
			Set CareProvDR=objSign.CPWSDoctorDR
		}Else{
			Set CareProvDR=objSign.CPWSNurseDR
		}
		//update by zf 20130606
		If $IsObject(objSign.CPWSEpStepDR) {
			Set EpStepID=objSign.CPWSEpStepDR.%Id()
			Continue:(argStepID'="")&&(argStepID'=EpStepID)
		}
		
		Set CareProvName=$p($g(^CTPCP(+CareProvDR,1)),"^",2)
		Continue:CareProvName=""
		Set Date=objSign.CPWSDate
		Set Time=objSign.CPWSTime
		;Set Date=$zd(+Date,3)
		Set Date=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(+Date)
		Set Time=$zt(+Time,2)
		Set UserDR=objSign.CPWSUserDR
		Set UserDesc=$p($g(^SSU("SSUSR",+UserDR)),"^",2)
		
		Set Data=$lb(SignRowid,CareProvDR,CareProvName,Date,Time,UserDR,UserDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QrySignByStepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySignByStepExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QrySignByStepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySignByStepExecute ]
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

/// w ##Class(web.DHCCPW.MR.ClinPathWaysSign).GetSignSteps(1)
ClassMethod GetSignSteps(aPathWayID As %String) As %String
{
	New (aPathWayID)
	Set return=""
	
	Set SignID=0,DocSignList="",NurSignList=""
	For {
		Set SignID=$o(^DHCMR("CPW",aPathWayID,"SIGN",SignID))
		Quit:SignID=""
		Set objSign=##class(web.DHCCPW.MR.ClinPathWaysSign).GetObjById(aPathWayID_"||"_SignID)
		Continue:'$IsObject(objSign)
		Continue:objSign.CPWSActive'="Y"
		Continue:'$IsObject(objSign.CPWSEpStepDR)
		Set Doctor=objSign.CPWSDoctorDR
		Set Nurse=objSign.CPWSNurseDR
		Set StepID=objSign.CPWSEpStepDR.%Id()
		If Doctor'="" {
			If $listfind(DocSignList,StepID)<1 {
				Set DocSignList=DocSignList_$lb(StepID)
			}
		}
		IF Nurse'="" {
			If $listfind(NurSignList,StepID)<1 {
				Set NurSignList=NurSignList_$lb(StepID)
			}
		}
	}
	Set DocSignStr="",NurSignStr=""
	For signIndex=1:1:$listlength(DocSignList) {
		Set DocSignStr=DocSignStr_"/"_$list(DocSignList,signIndex)
	}
	Set:DocSignStr'="" DocSignStr=$e(DocSignStr,2,$l(DocSignStr))
	For signIndex=1:1:$listlength(NurSignList) {
		Set NurSignStr=NurSignStr_"/"_$list(NurSignList,signIndex)
	}
	Set:NurSignStr'="" NurSignStr=$e(NurSignStr,2,$l(NurSignStr))
	If (DocSignStr'="")||(NurSignStr'="") {
		Set return=DocSignStr_","_NurSignStr
	}
	Quit return
}

/// add by mxp 2016 -12-07
/// 查询患者路径变异及签名情况
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MR.ClinPathWaysSign","QrySignInfo",29)
Query QrySignInfo(aPathWayID As %String, aUserType As %String) As %Query(ROWSPEC = "EpStepID:%String,EpStepDesc:%String,IsVariance:%String,DoctorSign:%String,NurseSign:%String")
{
}

ClassMethod QrySignInfoExecute(ByRef qHandle As %Binary, aPathWayID As %String, aUserType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(aPathWayID)
	quit:'$IsObject(objPathWay) $$$OK 
	Set aCPWID=objPathWay.CPWPathwayDR.%Id()
	
	//分支型路径 调整步骤
	Set EstTimes=""
	Set EstTimeLS=##class(web.DHCCPW.MR.ClinPathWaysEstimate).GetObjByPathWayID(aPathWayID)
	If EstTimeLS'="" {
		Set EstTimesCnt=$listlength(EstTimeLS)
		For EstTimesInd=1:1:EstTimesCnt {
			Set objEstTime=$list(EstTimeLS,EstTimesInd)
			Set EstEpStepDR=$list(objEstTime,1)
			Set EstTimes=EstTimes_$lb(EstEpStepDR)
		}
	}
	
	Quit:aCPWID="" $$$OK 
	Quit:'$d(^DHCMRC("CPW",aCPWID)) $$$OK 
	
	Set EpID=""
	For {
		Set EpID=$o(^DHCMRC("CPW",aCPWID,"EP",EpID))
		Quit:EpID=""
		Set objEp=##class(web.DHCCPW.MRC.PathWayEp).GetObjById(aCPWID_"||"_EpID)
		Continue:'$IsObject(objEp)
		Set EpNo=objEp.EPEpisode
		Set tmpEpNo=""
		If EpNo'="" {
			Set $p(tmpEpNo,"0",5-$l(EpNo))=EpNo
			Set EpNo=tmpEpNo
		}
		Set EpDesc=objEp.EPDesc
		Continue:(EpNo="")||(EpDesc="")
		
		Set StepID="",Count=0
		For {
			Set StepID=$o(^DHCMRC("CPW",aCPWID,"EP",EpID,"STEP",StepID))
			Quit:StepID=""
			Set EstStepRowid=aCPWID_"||"_EpID_"||"_StepID
			If EstTimes'="" {
				Continue:'$listfind(EstTimes,EstStepRowid)
			}
			Set objStep=##class(web.DHCCPW.MRC.PathWEpStep).GetObjById(EstStepRowid)
			Continue:'$IsObject(objStep)
			Set StepNo=objStep.CPWSDayNumber
			Set tmpStepNo=""
			If StepNo'="" {
				Set $p(tmpStepNo,"0",5-$l(StepNo))=StepNo
				Set StepNo=tmpStepNo
			}
			Set StepDesc=objStep.CPWSDesc
			Continue:(StepNo="")||(StepDesc="")
			Set IsVariance=##Class(DHCCPW.MR.FORM.VarianceSrv).ChkVarItemList(aPathWayID,EstStepRowid,aUserType)
			Set IsVariance=$s(IsVariance>0:"是",1:"否")
		
			Set SignID="",DocSignStr="",NurSignStr=""
			For {
				Set SignID=$o(^DHCMRi(0,"SIGN","IndexEpStep",aPathWayID,EstStepRowid,SignID))
				Quit:SignID=""
				Set SignRowid=aPathWayID_"||"_SignID
				Set objSign=##class(web.DHCCPW.MR.ClinPathWaysSign).GetObjById(SignRowid)
				Continue:'$IsObject(objSign)
				Continue:objSign.CPWSActive'["Y"
				
				Set DocCareProvID=objSign.CPWSDoctorDR
				
				Set NurCareProvID=objSign.CPWSNurseDR
				
				Continue:(DocCareProvID="")&&(NurCareProvID="")
				Set:DocCareProvID'="" CareProvName=$p($g(^CTPCP(+DocCareProvID,1)),"^",2)
				Set:NurCareProvID'="" CareProvName=$p($g(^CTPCP(+NurCareProvID,1)),"^",2)
				Continue:CareProvName=""
				
				Set:DocCareProvID'="" DocSignStr=DocSignStr_","_CareProvName
				Set:NurCareProvID'="" NurSignStr=NurSignStr_","_CareProvName
			}
			Set DocSignStr=$e(DocSignStr,2,$l(DocSignStr))
			Set NurSignStr=$e(NurSignStr,2,$l(NurSignStr))		
			
			Set Data=$lb(EstStepRowid,StepDesc,IsVariance,DocSignStr,NurSignStr)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QrySignInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySignInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QrySignInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySignInfoExecute ]
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

}
