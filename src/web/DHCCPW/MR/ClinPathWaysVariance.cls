/// 名称: web.DHCCPW.MR.ClinPathWaysVariance
/// 描述: 患者临床路径变异记录
/// 编写者：zhufei
/// 编写日期: 2010-05-15
Class web.DHCCPW.MR.ClinPathWaysVariance Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2010-05-16
/// Description:  根据ID取临床路径记录
/// Table：       User.DHCMRClinicalPathWayVariance
/// Input：       ID:    User.DHCMRClinicalPathWayVariance.Id
///               separete: 指定的分隔符
/// Return：      返回object
/// w ##class(web.DHCCPW.MR.ClinPathWaysVariance).GetObjById(1)
ClassMethod GetObjById(argId As %String) As User.DHCMRClinicalPathWayVariance
{
	New (argId)
	Set return=##Class(User.DHCMRClinicalPathWayVariance).%OpenId(argId)
	Do:return'="" return.%Close()
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2010-05-16
/// Description:  根据ID取临床路径记录
/// Table：       User.DHCMRClinicalPathWayVariance
/// Input：       ID:    User.DHCMRClinicalPathWayVariance.Id
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(web.DHCCPW.MR.ClinPathWaysVariance).GetStringById(1,"^")
ClassMethod GetStringById(argId As %String, argSeparete As %String) As %String
{
	New (argId,argSeparete)
	Set return=""
	
	Set obj=..GetObjById(argId)
	If $IsObject(obj) {
		Set:$g(argSeparete)="" argSeparete=..#SEPARATE
		Set ID=obj.%Id()
		
		If $IsObject(obj.CPWVEpisodeDR)
		{
			Set EpisodeDR=obj.CPWVEpisodeDR.%Id()
			Set EpisodeDesc=obj.CPWVEpisodeDR.EPDesc
		}
		
		If $IsObject(obj.CPWVEpStepDR)
		{
			Set EpStepDR=obj.CPWVEpStepDR.%Id()
			Set EpStepDesc=obj.CPWVEpStepDR.CPWSDesc
		}
		
		If $IsObject(obj.CPWVCategoryDR)
		{
			Set CategoryDR=obj.CPWVCategoryDR.%Id()
			Set CategoryDesc=obj.CPWVCategoryDR.VCDesc
		}
		
		If $IsObject(obj.CPWVReasonDR)
		{
			Set ReasonDR=obj.CPWVReasonDR.%Id()
			Set ReasonDesc=obj.CPWVReasonDR.VRDesc
		}
		
		Set UserDR=obj.CPWVUserDR
		Set:UserDR'="" UserName=$p($g(^SSU("SSUSR",UserDR)),"^",2)
		Set CPWVDate=obj.CPWVDate
		Set CPWVTime=obj.CPWVTime
		Set:CPWVDate'="" CPWVDate=$zd(+CPWVDate,3)
		Set:CPWVTime'="" CPWVTime=$zt(+CPWVTime,2)
		Set DoctorDR=obj.CPWVDoctorDR
		Set:DoctorDR'="" DoctorName=$p($g(^CTPCP(DoctorDR,1)),"^",2)
		Set Note=obj.CPWVNote
		
		Set return=$g(ID)_argSeparete
		Set return=return_$g(EpisodeDR)_argSeparete
		Set return=return_$g(EpisodeDesc)_argSeparete
		Set return=return_$g(CategoryDR)_argSeparete
		Set return=return_$g(CategoryDesc)_argSeparete
		Set return=return_$g(ReasonDR)_argSeparete
		Set return=return_$g(ReasonDesc)_argSeparete
		Set return=return_$g(UserDR)_argSeparete
		Set return=return_$g(UserName)_argSeparete
		Set return=return_$g(CPWVDate)_argSeparete
		Set return=return_$g(CPWVTime)_argSeparete
		Set return=return_$g(DoctorDR)_argSeparete
		Set return=return_$g(DoctorName)_argSeparete
		Set return=return_$g(Note)_argSeparete
		Set return=return_$g(EpStepDR)_argSeparete
		Set return=return_$g(EpStepDesc)
	}
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2010-05-16
/// Description:  更新User.DHCMRClinicalPathWayVariance
/// Table：       User.DHCMRClinicalPathWayVariance
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1:Rowid 2:VEpisodeDR 3:VCategoryDR 4:VReasonDR 5:VUserDR 6:VDate 7:VTime 8:VDoctorDR 9:VNote  10:EpStepID  11:ExtraValues
/// w ##class(web.DHCCPW.MR.ClinPathWaysVariance).Update(InPutStr)
ClassMethod Update(argInStr As %String) As %String
{
	New (argInStr)
	Set return=-1
	Set ID=$p(argInStr,"^",1)
	Set Parref=$p(ID,"||",1)
	Set ChildSub=$p(ID,"||",2)
	
	If ChildSub="" {
		Set obj=##class(User.DHCMRClinicalPathWayVariance).%New()
	} Else {
		Set obj=##class(User.DHCMRClinicalPathWayVariance).%OpenId(ID)
		Quit:obj="" return
	}
	
	Set objParref=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(Parref)
	Quit:objParref="" return
	
	Set EpisodeDR=$p(argInStr,"^",2)
	Set EpStepDR=$p(argInStr,"^",10)
	Set:EpStepDR'="" EpisodeDR=$p(EpStepDR,"||",1)_"||"_$p(EpStepDR,"||",2)
	Set objEpisode=##class(web.DHCCPW.MRC.PathWayEp).GetObjById(EpisodeDR)
	Quit:objEpisode="" return
	
	Set CategoryDR=$p(argInStr,"^",3)
	Set objCategory=##class(web.DHCCPW.MRC.VarianceCategory).GetObjById(CategoryDR)
	
	Set ReasonDR=$p(argInStr,"^",4)
	Set objReason=##class(web.DHCCPW.MRC.VarianceReason).GetObjById(ReasonDR)
	
	Set UserDR=$p(argInStr,"^",5)
	Quit:UserDR="" return
	
	Set Date=$p(argInStr,"^",6)
	Set Time=$p(argInStr,"^",7)
	Set:Date["/" Date=$zdh(Date,4)
	Set:Date["-" Date=$zdh(Date,3)
	Set Date=$s(Date'="":+Date,1:+$h)
	Set:Time[":" Time=$zth(Time,2)
	Set Time=$s(Time'="":+Time,1:$p($h,",",2))
	
	Set DoctorDR=$p(argInStr,"^",8)
	Set Note=$p(argInStr,"^",9)
	
	Set EpStepDR=$p(argInStr,"^",10)
	Set objEpStep=##class(web.DHCCPW.MRC.PathWEpStep).GetObjById(EpStepDR)
	Quit:objEpStep="" return
	
	Set ExtraValues=$p(argInStr,"^",11)  //医嘱项ID
	
	Set ImplNewDR=$p(argInStr,"^",12)
	If (ImplNewDR'="") {
		Set objImplNew=##class(web.DHCCPW.OPCPW.InterfaceOP).GetObjByImplNewID(ImplNewDR)
		Quit:'$IsObject(objImplNew) return
	}
	
	Set obj.CPWVParRef=objParref
	Set obj.CPWVEpisodeDR=objEpisode
	Set obj.CPWVCategoryDR=objCategory
	Set obj.CPWVReasonDR=objReason
	Set obj.CPWVUserDR=UserDR
	Set obj.CPWVDate=Date
	Set obj.CPWVTime=Time
	Set obj.CPWVDoctorDR=DoctorDR
	Set obj.CPWVNote=Note
	Set obj.CPWVEpStepDR=objEpStep
	Set obj.CPWVExtraValues=ExtraValues
	Set:(ImplNewDR'="") obj.CPWVImplNewDR=objImplNew
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {                      //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2010-06-13
/// Description:  更新User.DHCMRClinicalPathWayVariance
/// Table：       User.DHCMRClinicalPathWayVariance
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1:VID 2:VUpdoFlag 3:VUpdoDate 4:VUpdoTime 5:VUpdoUserDR
/// w ##class(web.DHCCPW.MR.ClinPathWaysVariance).UpdoVariance(InPutStr)
ClassMethod UpdoVariance(argInStr As %String) As %String
{
	New (argInStr)
	Set return=-1
	Quit:argInStr="" return
	
	Set $ZT="UpdoVarianceErr"
	Set ID=$p(argInStr,"^",1)
	Set UserDR=$p(argInStr,"^",2)
	Set obj=##class(User.DHCMRClinicalPathWayVariance).%OpenId(ID)
	Quit:obj="" return
	
	Set obj.CPWVUpdoFlag="Y"
	Set obj.CPWVUpdoDate=+$h
	Set obj.CPWVUpdoTime=$p($h,",",2)
	Set obj.CPWVUpdoUserDR=UserDR
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {                      //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
	
UpdoVarianceErr
	Quit -1
}

/// Creator：     zhufei
/// CreatDate：   2010-05-16
/// Description:  删除User.DHCMRClinicalPathWayVariance
/// Table：       User.DHCMRClinicalPathWayVariance
/// Input：       User.DHCMRClinicalPathWayVariance.Id
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(web.DHCCPW.MR.ClinPathWaysVariance).DeleteById(1)
ClassMethod DeleteById(argId As %String) As %Boolean
{
	new (argId)
	set return=0
	set sc = ##class(User.DHCMRClinicalPathWayVariance).%DeleteId(argId)
	if $system.Status.IsError(sc) {         //检查删除是否成功
   		do $system.OBJ.DisplayError(sc) 
   		set return=-1
	} else {
		set return=0
	}
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2010-05-15
/// Description:  取临床路径变异记录
/// Input：       User.DHCMRClinicalPathWay.ID
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MR.ClinPathWaysVariance","QryVarianceByCPW",6)
Query QryVarianceByCPW(argPathWaysID As %String) As %Query(ROWSPEC = "VID:%String,VCPWID:%String,VCPWDesc:%String,VEpisodeDR:%String,VEpisodeDesc:%String,VEpStepDR:%String,VEpStepDesc:%String,VCategoryDR:%String,VCategoryDesc:%String,VReasonDR:%String,VReasonDesc:%String,VUserDR:%String,VUserDesc:%String,VDate:%String,VTime:%String,VNote:%String,VDoctorDR:%String,VDoctorDesc:%String")
{
}

ClassMethod QryVarianceByCPWExecute(ByRef qHandle As %Binary, argPathWaysID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	//^DHCMR("CPW",{ClinPathWays.ID},"VAR",{ChildSub})
	Quit:argPathWaysID="" $$$OK
	Quit:'$d(^DHCMR("CPW",argPathWaysID,"VAR")) $$$OK
	
	Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(argPathWaysID)
	Quit:objPathWay="" $$$OK
	If $IsObject(objPathWay) {
		If $IsObject(objPathWay.CPWPathwayDR) {
			Set CPWID=objPathWay.CPWPathwayDR.%Id()
			Set CPWDesc=objPathWay.CPWPathwayDR.CPWDesc
		}
	}
	
	Set ChildSub=""
	For {
		Set ChildSub=$o(^DHCMR("CPW",argPathWaysID,"VAR",ChildSub),-1)
		Quit:ChildSub=""
		Set CPWVID=argPathWaysID_"||"_ChildSub
		Set (CPWVEpisodeDR,CPWVEpisodeDesc,CPWVEpStepDR,CPWVEpStepDesc,CPWVCategoryDR)=""
		Set (CPWVCategoryDesc,CPWVReasonDR,CPWVReasonDesc,CPWVDate,CPWVTime,CPWVNote)=""
		Set (CPWVDoctorDR,CPWVDoctorDesc)=""
		Set objVariance=##class(web.DHCCPW.MR.ClinPathWaysVariance).GetObjById(CPWVID)
		If $IsObject(objVariance){
			
			If $IsObject(objVariance.CPWVEpisodeDR){
				Set CPWVEpisodeDR=objVariance.CPWVEpisodeDR.%Id()
				Set CPWVEpisodeDesc=objVariance.CPWVEpisodeDR.EPDesc
			}
			If $IsObject(objVariance.CPWVEpStepDR){
				Set CPWVEpStepDR=objVariance.CPWVEpStepDR.%Id()
				Set CPWVEpStepDesc=objVariance.CPWVEpStepDR.CPWSDesc
			}
			If $IsObject(objVariance.CPWVCategoryDR)
			{
				Set CPWVCategoryDR=objVariance.CPWVCategoryDR.%Id()
				Set CPWVCategoryDesc=objVariance.CPWVCategoryDR.VCDesc
			}
			
			If $IsObject(objVariance.CPWVReasonDR)
			{
				Set CPWVReasonDR=objVariance.CPWVReasonDR.%Id()
				Set CPWVReasonDesc=objVariance.CPWVReasonDR.VRDesc
			}
			
			Set CPWVUserDR=objVariance.CPWVUserDR
			Set CPWVUserDesc=$p($g(^SSU("SSUSR",+CPWVUserDR)),"^",2)
			
			Set CPWVDate=objVariance.CPWVDate
			Set CPWVTime=objVariance.CPWVTime
			Set CPWVNote=objVariance.CPWVNote
			Set CPWVDate=$zd(+CPWVDate,3)
			Set CPWVTime=$zt(+CPWVTime,2)
			
			Set CPWVDoctorDR=objVariance.CPWVDoctorDR
			Set CPWVDoctorDesc=$p($g(^CTPCP(+CPWVDoctorDR,1)),"^",2)
			
			Continue:objVariance.CPWVUpdoFlag="Y"
		} Else {
			Continue
		}
		
		Set Data=$lb($g(CPWVID),$g(CPWID),$g(CPWDesc),$g(CPWVEpisodeDR),$g(CPWVEpisodeDesc),$g(CPWVEpStepDR),$g(CPWVEpStepDesc),$g(CPWVCategoryDR),$g(CPWVCategoryDesc),$g(CPWVReasonDR),$g(CPWVReasonDesc))
		Set Data=Data_$lb($g(CPWVUserDR),$g(CPWVUserDesc),$g(CPWVDate),$g(CPWVTime),$g(CPWVNote),$g(CPWVDoctorDR),$g(CPWVDoctorDesc))
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryVarianceByCPWClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryVarianceByCPWExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryVarianceByCPWFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryVarianceByCPWExecute ]
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

/// Creator：     zhufei
/// CreatDate：   2011-06-13
/// Description:  取阶段步骤对应临床路径变异记录
/// Input：       User.DHCMRClinicalPathWay.ID
///               User.DHCMRCClinPathWaysEpStep.ID
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MR.ClinPathWaysVariance","QryVarByStep",9,"8||2||1")
Query QryVarByStep(argPathWaysID As %String, argStepID As %String) As %Query(ROWSPEC = "VID:%String,VCPWID:%String,VCPWDesc:%String,VEpisodeDR:%String,VEpisodeDesc:%String,VEpStepDR:%String,VEpStepDesc:%String,VCategoryDR:%String,VCategoryDesc:%String,VReasonDR:%String,VReasonDesc:%String,VUserDR:%String,VUserDesc:%String,VDate:%String,VTime:%String,VNote:%String,VDoctorDR:%String,VDoctorDesc:%String,varitmnum:%String")
{
}

ClassMethod QryVarByStepExecute(ByRef qHandle As %Binary, argPathWaysID As %String, argStepID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Quit:argPathWaysID="" $$$OK
	Quit:'$d(^DHCMR("CPW",argPathWaysID,"VAR")) $$$OK
	
	Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(argPathWaysID)
	Quit:objPathWay="" $$$OK
	If $IsObject(objPathWay) {
		If $IsObject(objPathWay.CPWPathwayDR) {
			Set CPWID=objPathWay.CPWPathwayDR.%Id()
			Set CPWDesc=objPathWay.CPWPathwayDR.CPWDesc
		}
	}
	
	Set ChildSub="",varitmnum=0
	For {
		Set ChildSub=$o(^DHCMR("CPW",argPathWaysID,"VAR",ChildSub),-1)
		Quit:ChildSub=""
		Set CPWVID=argPathWaysID_"||"_ChildSub
		Set (CPWVEpisodeDR,CPWVEpisodeDesc,CPWVEpStepDR,CPWVEpStepDesc,CPWVCategoryDR)=""
		Set (CPWVCategoryDesc,CPWVReasonDR,CPWVReasonDesc,CPWVDate,CPWVTime,CPWVNote)=""
		Set (CPWVDoctorDR,CPWVDoctorDesc)=""
		Set objVariance=##class(web.DHCCPW.MR.ClinPathWaysVariance).GetObjById(CPWVID)
		If $IsObject(objVariance){
			
			If $IsObject(objVariance.CPWVEpisodeDR){
				Set CPWVEpisodeDR=objVariance.CPWVEpisodeDR.%Id()
				Set CPWVEpisodeDesc=objVariance.CPWVEpisodeDR.EPDesc
			}
			If $IsObject(objVariance.CPWVEpStepDR){
				Set CPWVEpStepDR=objVariance.CPWVEpStepDR.%Id()
				Set CPWVEpStepDesc=objVariance.CPWVEpStepDR.CPWSDesc
			}
			Continue:(argStepID'="")&&(CPWVEpStepDR'=argStepID)
			If $IsObject(objVariance.CPWVCategoryDR)
			{
				Set CPWVCategoryDR=objVariance.CPWVCategoryDR.%Id()
				Set CPWVCategoryDesc=objVariance.CPWVCategoryDR.VCDesc
			}
			
			If $IsObject(objVariance.CPWVReasonDR)
			{
				Set CPWVReasonDR=objVariance.CPWVReasonDR.%Id()
				Set CPWVReasonDesc=objVariance.CPWVReasonDR.VRDesc
			}
			
			Set CPWVUserDR=objVariance.CPWVUserDR
			Set CPWVUserDesc=$p($g(^SSU("SSUSR",+CPWVUserDR)),"^",2)
			
			Set CPWVDate=objVariance.CPWVDate
			Set CPWVTime=objVariance.CPWVTime
			Set CPWVNote=objVariance.CPWVNote
			;Set CPWVDate=$zd(+CPWVDate,3)
			Set CPWVDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(+CPWVDate)
			Set CPWVTime=$zt(+CPWVTime,2)
			
			Set CPWVDoctorDR=objVariance.CPWVDoctorDR
			Set CPWVDoctorDesc=$p($g(^CTPCP(+CPWVDoctorDR,1)),"^",2)
			
			Continue:objVariance.CPWVUpdoFlag="Y"
		} Else {
			Continue
		}
		Set varitmnum=$i(varitmnum)
		Set Data=$lb($g(CPWVID),$g(CPWID),$g(CPWDesc),$g(CPWVEpisodeDR),$g(CPWVEpisodeDesc),$g(CPWVEpStepDR),$g(CPWVEpStepDesc),$g(CPWVCategoryDR),$g(CPWVCategoryDesc),$g(CPWVReasonDR),$g(CPWVReasonDesc))
		Set Data=Data_$lb($g(CPWVUserDR),$g(CPWVUserDesc),$g(CPWVDate),$g(CPWVTime),$g(CPWVNote),$g(CPWVDoctorDR),$g(CPWVDoctorDesc))
		Set Data=Data_$lb($g(varitmnum))
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryVarByStepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryVarByStepExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryVarByStepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryVarByStepExecute ]
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

/// Creator：     zhufei
/// CreatDate：   2011-06-13
/// Description:  取阶段步骤对应临床路径变异记录
/// Input：       User.DHCMRClinicalPathWay.ID
/// w ##Class(web.DHCCPW.MR.ClinPathWaysVariance).GetVarInfo(9)
ClassMethod GetVarInfo(argPathWayID As %String) As %String
{
	New (argPathWayID)
	Set return=""
	Quit:argPathWayID="" return
	Quit:'$d(^DHCMR("CPW",argPathWayID,"VAR")) return
	
	Set VarCount=0,VarReason=""
	Set ChildSub=""
	For {
		Set ChildSub=$o(^DHCMR("CPW",argPathWayID,"VAR",ChildSub))
		Quit:ChildSub=""
		Set CPWVID=argPathWayID_"||"_ChildSub
		Set objVariance=..GetObjById(CPWVID)
		If $IsObject(objVariance){
			Continue:objVariance.CPWVUpdoFlag="Y"
			Continue:'$IsObject(objVariance.CPWVReasonDR)
			Set VarReason=VarReason_","_objVariance.CPWVReasonDR.VRDesc
			Set VarCount=VarCount+1
		}
	}
	Set:VarReason'="" VarReason=$e(VarReason,2,$l(VarReason))
	Set return=$lb(VarCount,VarReason)
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2011-07-09
/// Description:  更新User.DHCMRClinicalPathWayVariance
/// Table：       User.DHCMRClinicalPathWayVariance
/// Input：       argInStr=Paadm^ReasonDR^Note^UserDR^ArcimIDs
/// Return：      return=-1     参数、设置问题
///               return=-2     就诊、路径问题
///               return=-3     当前步骤问题
///               return=-4     路径外医嘱问题
///               return=-5     变异原因、变异类型问题
///               return=-6     用户、医护人员问题
///               return=-7     保存失败
///               return=1      保存成功
/// w ##class(web.DHCCPW.MR.ClinPathWaysVariance).UpdateExtraVar(InPutStr)
ClassMethod UpdateExtraVar(argInStr As %String) As %String
{
	New (argInStr)
	Set return=-1
	Quit:argInStr="" return
	
	Set return=-2
	Set Paadm=$p(argInStr,"^",1)
	Set MRAdm=##class(web.DHCCPW.MR.PAADMSrv).GetMRAdm(Paadm)
	Quit:MRAdm="" return
	Set PathWayID=$o(^DHCMRi("CPW",0,"IndexMRAdm"," "_MRAdm,""),-1)
	Set AdmType=$p($g(^PAADM(Paadm)),"^",2)
	If (AdmType="O") {
		Set CurrStepOP=##class(web.DHCCPW.OPCPW.InterfaceOP).IsCurrStepOP(Paadm)
		Set PathWayID=$p(CurrStepOP,"^",1)
	}
	Quit:PathWayID="" return
	
	Set return=-3
	Set CurrStepDR=$p(argInStr,"^",7)  //当前步骤
	Set CurrDate=+$h,CurrTime=$p($h,",",2),LastStepDR=""
	Set EstTimeLS=##class(web.DHCCPW.MR.ClinPathWaysEstimate).GetObjByPathWayID(PathWayID)
	If EstTimeLS'="" {
		Set EstTimesCnt=$listlength(EstTimeLS)
		For EstTimesInd=1:1:EstTimesCnt {
			Quit:CurrStepDR'=""
			Set objEstTime=$list(EstTimeLS,EstTimesInd)
			Set EstEpStepDR=$list(objEstTime,1)
			Continue:EstEpStepDR=""
			Set EstStratDate=$list(objEstTime,3)
			Set EstStartTime=$list(objEstTime,4)
			Set EstEndDate=$list(objEstTime,5)
			Set EstEndTime=$list(objEstTime,6)
			Continue:(CurrDate<EstStratDate)||((CurrDate=EstStratDate)&&(CurrTime<EstStartTime))
			Continue:(CurrDate>EstEndDate)||((CurrDate=EstEndDate)&&(CurrTime>EstEndTime))
			Set CurrStepDR=EstEpStepDR
		}
		Set:CurrStepDR="" CurrStepDR=LastStepDR
	}
	Quit:CurrStepDR="" return
	Set CurrEpDR=$p(CurrStepDR,"||",1)_"||"_$p(CurrStepDR,"||",2)
	
	Set return=-4
	Set ArcimStr=""
	Set ArcimIDs=$p(argInStr,"^",5)
	For ArcimInd=1:1:$l(ArcimIDs,",") {
		Set ArcimID=$p(ArcimIDs,",",ArcimInd)
		Continue:ArcimID=""
		Set ArcimStr=ArcimStr_"ARCIM:"_ArcimID_"-"_CurrStepDR_","
	}
	Set SignCheckStr=$p(argInStr,"^",6)
	For SignCheckInd=1:1:$l(SignCheckStr,",") {
		Set SignCheckItm=$p(SignCheckStr,",",SignCheckInd)
		Set ArcimStr=ArcimStr_SignCheckItm_","
	}
	Quit:ArcimStr="" return
	Set ArcimStr=$e(ArcimStr,1,$l(ArcimStr)-1)
	
	Set return=-5
	Set ReasonDR=$p(argInStr,"^",2)
	Set Note=$p(argInStr,"^",3)
	Set objReason=##class(web.DHCCPW.MRC.VarianceReason).GetObjById(+ReasonDR)
	Quit:'$IsObject(objReason) return
	Quit:'$IsObject(objReason.VRVarCategDR) return
	Set CategoryDR=objReason.VRVarCategDR.%Id()
	Quit:CategoryDR="" return
	
	Set return=-6
	Set UserDR=$p(argInStr,"^",4)
	Set DoctorDR=##class(web.DHCCPW.MR.CTCareProvSrv).GetCareProvByUserID(+UserDR,"^")
	Set DoctorDR=+DoctorDR
	Quit:DoctorDR="" return
	
	Set ImplNewDR=$p(argInStr,"^",8)
	
	Set return=-7
	Set InputStr=PathWayID_"^"_CurrEpDR_"^"_CategoryDR_"^"_ReasonDR_"^"_UserDR_"^"_+$h_"^"_$p($h,",",2)_"^"_DoctorDR_"^"_Note_"^"_CurrStepDR_"^"_ArcimStr
	Set InputStr=InputStr_"^"_ImplNewDR
	Set flg=..Update(InputStr)
	Quit:+flg<0 return
	
	Set return=1
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2011-07-09
/// Description:  检查要审核的医嘱中是否存在路径外医嘱
/// Table：       
/// Input：       
/// Return：      return=-1     参数错误或无检查设置
///               return=-2    不是入径患者
///               return=-3    已出径或已完成路径
///               return=-4    没有符合当前时间的步骤（可能时间调整有问题）
///               return=1^医嘱列表     检查存在路径外医嘱
/// w ##class(web.DHCCPW.MR.ClinPathWaysVariance).CheckOutARCIM(Paadm,ArcimIDs)
ClassMethod CheckOutARCIM(argPaadm As %String, argArcimIDs As %String, argUserID As %String, argLocID As %String) As %String
{
	New (argPaadm,argArcimIDs,argUserID,argLocID)
	Set return=-1
	Quit:(argPaadm="")||(argArcimIDs="")||(argLocID="") return
	
	Set $ZT="CheckOutARCIMErr"
	
	//下医嘱时检查是否需要填写变异设置
	//Y:如果下了路径外医嘱，必须填写变异
	Set UserType=##Class(web.DHCCPW.MR.PaPatmasSrv).getCPTInternalType(argUserID)
	Set UserType=$s(UserType="DOCTOR":"D",UserType="NURSE":"N",1:"")
	Quit:(UserType="") return
	Set CheckOEItemToVariance=""
	Set objConfig=##class(web.DHCCPW.MRC.BaseConfig).GetObjByCode("CheckOEItemToVariance")
	If $IsObject(objConfig){
		Set CheckOEItemToVariance=objConfig.BCValue
	}
	//Quit:CheckOEItemToVariance'="Y" return
	Quit:(CheckOEItemToVariance'="Y")&&(CheckOEItemToVariance'=UserType) return
	
	Set return=-2
	Set MRAdm=##class(web.DHCCPW.MR.PAADMSrv).GetMRAdm(argPaadm)
	Quit:MRAdm="" return
	Set PathWayID=$o(^DHCMRi("CPW",0,"IndexMRAdm"," "_MRAdm,""),-1)
	Quit:PathWayID="" return
	Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(PathWayID)
	Quit:'$IsObject(objPathWay) return
	
	Set return=-3
	Quit:'$IsObject(objPathWay.CPWPathwayDR) return
	Set CPWID=objPathWay.CPWPathwayDR.%Id()
	Set CPWStatus=objPathWay.CPWStatus
	Quit:CPWStatus'="I" return
	
	Set return=-4
	Set CurrDate=+$h,CurrTime=$p($h,",",2),CurrStepDR=""
	Set CompStepList=""
	Set EstTimeLS=##class(web.DHCCPW.MR.ClinPathWaysEstimate).GetObjByPathWayID(PathWayID)
	If EstTimeLS'="" {
		Set EstTimesCnt=$listlength(EstTimeLS)
		For EstTimesInd=1:1:EstTimesCnt {
			Quit:CurrStepDR'=""
			Set objEstTime=$list(EstTimeLS,EstTimesInd)
			Set EstEpStepDR=$list(objEstTime,1)
			Continue:EstEpStepDR=""
			Set EstStratDate=$list(objEstTime,3)
			Set EstStartTime=$list(objEstTime,4)
			Set EstEndDate=$list(objEstTime,5)
			Set EstEndTime=$list(objEstTime,6)
			Set CompStepList=$list(objEstTime,8)
			Continue:(CurrDate<EstStratDate)||((CurrDate=EstStratDate)&&(CurrTime<EstStartTime))
			Continue:(CurrDate>EstEndDate)||((CurrDate=EstEndDate)&&(CurrTime>EstEndTime))
			Set CurrStepDR=EstEpStepDR
		}
	}
	Quit:CurrStepDR="" return
	
	Set ArcimCategList=##Class(web.DHCCPW.MR.ClinPathWaysVariance).GetListFromConfig("OutFormArcimCateg",",")
	Set ArcimSubCatList=##Class(web.DHCCPW.MR.ClinPathWaysVariance).GetListFromConfig("OutFormArcimSubCat",",")
	set IsFilterNurseOrder=##class(web.DHCCPW.MRC.BaseConfig).GetValueByCode("IsFilterNurseOrder")
	set filterLocList=##Class(web.DHCCPW.MR.ClinPathWaysVariance).GetListFromConfig("FilterLocOrder",",")
	Set CareProvDR=$p($g(^SSU("SSUSR",argUserID)),"^",14)
	Set CareProvTpDr=$p($g(^CTPCP(CareProvDR,1)),"^",4)
	Set CTCPTType=$p($g(^CT("CPT",CareProvTpDr)),"^",4)
	Set LocDesc=$p($g(^CTLOC(argLocID)),"^",1) 
	Quit:(IsFilterNurseOrder="Y")&&(CTCPTType="NURSE") return
	Quit:(LocDesc'="")&&(filterLocList'="")&&($listfind(filterLocList,LocDesc)>0) return
	
	Kill ArcimGeneList
	
	Set CPWID=$p(CurrStepDR,"||",1),EpID=$p(CurrStepDR,"||",2),StepID=$p(CurrStepDR,"||",3)
	Set ItemID=""
	For {
		Set ItemID=$o(^DHCMRC("CPW",CPWID,"EP",EpID,"STEP",StepID,"ITEM",ItemID))
		Quit:ItemID=""
		
		Set StepItemID=CPWID_"||"_EpID_"||"_StepID_"||"_ItemID
		Set ArcimList=##class(DHCCPW.MR.FORM.ItemImplSrv).GetArcimByItem(StepItemID)
		Continue:ArcimList=""
		For indArc=1:1:$listlength(ArcimList) {
			Set ArcimID=$list(ArcimList,indArc)
			Continue:ArcimID=""
			
			Set PHCGeneDesc=""
			Set PHCGeneID=$p($g(^ARCIM(+ArcimID,1,8)),"^",20)  //通用名
			Set:PHCGeneID'="" PHCGeneDesc=$p($g(^PHCGE("GE",PHCGeneID)),"^",2)
			Set:PHCGeneDesc="" PHCGeneDesc=$p($g(^ARCIM(+ArcimID,1,1)),"^",2)    //医嘱名称
			Set PHCGeneDesc=$zcvt(PHCGeneDesc,"U")
			Set ArcimGeneList(PHCGeneDesc)=""
		}
	}
	
	For compIndex=1:1:$listlength(CompStepList) {
		Set CompStepID=$list(CompStepList,compIndex)
		Set CPWID=$p(CompStepID,"||",1)
		Set EpID=$p(CompStepID,"||",2)
		Set StepID=$p(CompStepID,"||",3)
		Continue:(CPWID="")||(EpID="")||(StepID="")
		
		Set ItemID=0
		For {
			Set ItemID=$o(^DHCMRC("CPW",CPWID,"EP",EpID,"STEP",StepID,"ITEM",ItemID))
			Quit:ItemID=""
			
			Set StepItemID=CPWID_"||"_EpID_"||"_StepID_"||"_ItemID
			Set ArcimList=##class(DHCCPW.MR.FORM.ItemImplSrv).GetArcimByItem(StepItemID)
			Continue:ArcimList=""
			For indArc=1:1:$listlength(ArcimList) {
				Set ArcimID=$list(ArcimList,indArc)
				Continue:ArcimID=""
				
				Set PHCGeneDesc=""
				Set PHCGeneID=$p($g(^ARCIM(+ArcimID,1,8)),"^",20)  //通用名
				Set:PHCGeneID'="" PHCGeneDesc=$p($g(^PHCGE("GE",PHCGeneID)),"^",2)
				Set:PHCGeneDesc="" PHCGeneDesc=$p($g(^ARCIM(+ArcimID,1,1)),"^",2)    //医嘱名称
				Set PHCGeneDesc=$zcvt(PHCGeneDesc,"U")
				Set ArcimGeneList(PHCGeneDesc)=""
			}
		}
	}
	
	Set ArcimIDs="",Count=0
	For ArcimInd=1:1:$l(argArcimIDs,",") {
		Set ArcimID=$p(argArcimIDs,",",ArcimInd)
		Continue:ArcimID=""
		
		Set (ArcimSubCatID,ArcimSubCat,ArcimCategID,ArcimCateg)=""
		Set ArcimSubCatID=$p($g(^ARCIM(+ArcimID,+$p(ArcimID,"||",2),1)),"^",10)
		Set:ArcimSubCatID'="" ArcimSubCat=$p($g(^ARC("IC",+ArcimSubCatID)),"^",2)
		Set:ArcimSubCatID'="" ArcimCategID=$p($g(^ARC("IC",+ArcimSubCatID)),"^",8)
		Set:ArcimCategID'="" ArcimCateg=$p($g(^OEC("ORCAT",+ArcimCategID)),"^",2)
		Continue:(ArcimCategList'="")&&(ArcimCateg'="")&&($listfind(ArcimCategList,ArcimCateg)>0)
		Continue:(ArcimSubCatList'="")&&(ArcimSubCat'="")&&($listfind(ArcimSubCatList,ArcimSubCat)>0)
		
		Set PHCGeneDesc=""
		Set PHCGeneID=$p($g(^ARCIM(+ArcimID,1,8)),"^",20)  //通用名
		Set:PHCGeneID'="" PHCGeneDesc=$p($g(^PHCGE("GE",PHCGeneID)),"^",2)
		Set:PHCGeneDesc="" PHCGeneDesc=$p($g(^ARCIM(+ArcimID,1,1)),"^",2)    //医嘱名称
		Set PHCGeneDesc=$zcvt(PHCGeneDesc,"U")
		Continue:$d(ArcimGeneList(PHCGeneDesc))
		
		Set ChildSub="",IsHaveVarRst="N"
		For {
			Set ChildSub=$o(^DHCMR("CPW",PathWayID,"VAR",ChildSub))
			Quit:ChildSub=""
			Quit:IsHaveVarRst="Y"
			Set CPWVID=PathWayID_"||"_ChildSub
			Set objVariance=##class(web.DHCCPW.MR.ClinPathWaysVariance).GetObjById(CPWVID)
			If $IsObject(objVariance){
				Set UpdoFlag=objVariance.CPWVUpdoFlag
				Continue:UpdoFlag="Y"
				Set ExtraValues=objVariance.CPWVExtraValues
				Continue:ExtraValues'[("ARCIM:"_ArcimID_"-"_CurrStepDR)
				Set IsHaveVarRst="Y"
			}
		}
		Continue:IsHaveVarRst="Y" //填写过变异记录不再显示
		
		Set ArcimIDs=ArcimIDs_","_ArcimID
		Set Count=Count+1
	}
	Set:ArcimIDs'="" ArcimIDs=$e(ArcimIDs,2,$l(ArcimIDs))
	
	Set return=Count_"^"_PathWayID_"^"_CurrStepDR_"^"_ArcimIDs
	Quit return
	
CheckOutARCIMErr
	Quit -999
}

/// Creator：     zhufei
/// CreatDate：   2011-07-09
/// Description:  取路径外医嘱项
/// Input：       
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MR.ClinPathWaysVariance","QryArcimsOutForm","10982||1,9734||1")
Query QryArcimsOutForm(argArcimIDs As %String) As %Query(ROWSPEC = "ArcimID:%String,ArcimDesc:%String")
{
}

ClassMethod QryArcimsOutFormExecute(ByRef qHandle As %Binary, argArcimIDs As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set ArcimCategList=##Class(web.DHCCPW.MR.ClinPathWaysVariance).GetListFromConfig("OutFormArcimCateg",",")
	Set ArcimSubCatList=##Class(web.DHCCPW.MR.ClinPathWaysVariance).GetListFromConfig("OutFormArcimSubCat",",")
	For ArcimInd=1:1:$l(argArcimIDs,",")
	{
		Set ArcimID=$p(argArcimIDs,",",ArcimInd)
		Continue:ArcimID=""
		
		Set (ArcimSubCatID,ArcimSubCat,ArcimCategID,ArcimCateg)=""
		Set ArcimSubCatID=$p($g(^ARCIM(+ArcimID,+$p(ArcimID,"||",2),1)),"^",10)
		Set:ArcimSubCatID'="" ArcimSubCat=$p($g(^ARC("IC",+ArcimSubCatID)),"^",2)
		Set:ArcimSubCatID'="" ArcimCategID=$p($g(^ARC("IC",+ArcimSubCatID)),"^",8)
		Set:ArcimCategID'="" ArcimCateg=$p($g(^OEC("ORCAT",+ArcimCategID)),"^",2)
		Continue:(ArcimCategList'="")&&(ArcimCateg'="")&&($listfind(ArcimCategList,ArcimCateg)>0)
		Continue:(ArcimSubCatList'="")&&(ArcimSubCat'="")&&($listfind(ArcimSubCatList,ArcimSubCat)>0)
		
		Set ArcimDesc=$p($g(^ARCIM(+ArcimID,+$p(ArcimID,"||",2),1)),"^",2)
		Continue:ArcimDesc=""
		Set ArcimDesc=$tr(ArcimDesc,$c(13),"")
		Set ArcimDesc=$tr(ArcimDesc,$c(10),"")
		Set ArcimDesc=$tr(ArcimDesc,$c(0),"")
		Set Data=$lb(ArcimID,ArcimDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryArcimsOutFormClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryArcimsOutFormExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryArcimsOutFormFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryArcimsOutFormExecute ]
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

/// w ##Class(web.DHCCPW.MR.ClinPathWaysVariance).GetListFromConfig("OutFormArcimCateg",",")
ClassMethod GetListFromConfig(argStr As %String, argSep As %String) As %List
{
	New (argStr,argSep)
	Set return=""
	Quit:(argStr="")||(argSep="") return
	Set $ZT="GetListFromConfigErr"
	
	Set objConfig=##class(web.DHCCPW.MRC.BaseConfig).GetObjByCode(argStr)
	If $IsObject(objConfig){
		Set ConfigDatas=objConfig.BCValue
		For configIndex=1:1:$l(ConfigDatas,argSep)
		{
			Set ConfigData=$p(ConfigDatas,argSep,configIndex)
			Continue:ConfigData=""
			Set return=return_$lb(ConfigData)
			//w ConfigData,!
		}
	}
	Quit return
	
GetListFromConfigErr
	Quit ""
}

Storage Default
{
<Data name="ClinPathWaysVarianceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCCPW.MR.ClinPathWays7E0D</DataLocation>
<DefaultData>ClinPathWaysVarianceDefaultData</DefaultData>
<IdLocation>^web.DHCCPW.MR.ClinPathWays7E0D</IdLocation>
<IndexLocation>^web.DHCCPW.MR.ClinPathWays7E0I</IndexLocation>
<StreamLocation>^web.DHCCPW.MR.ClinPathWays7E0S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
