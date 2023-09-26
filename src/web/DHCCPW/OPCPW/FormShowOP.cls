/// Creator		: zhaoyu
/// CreateDate	: 2013-10-17
/// Description	: 门诊临床路径表单展现
Class web.DHCCPW.OPCPW.FormShowOP Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator		: zhaoyu
/// CreateDate	: 2013-12-11
/// Description	: 根据路径ID查询路径步骤
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.OPCPW.FormShowOP","GetEpStepByCPWID","65")
Query GetEpStepByCPWID(CPWDID As %String) As %Query(ROWSPEC = "StepRowID:%String,StepDesc:%String")
{
}

ClassMethod GetEpStepByCPWIDExecute(ByRef qHandle As %Binary, CPWDID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Quit:(CPWDID="") $$$OK
	Set EpID=""
	For {
		Set EpID=$o(^DHCMRC("CPW",CPWDID,"EP",EpID))
		Quit:(EpID="")
		Set objEp=##class(web.DHCCPW.MRC.PathWayEp).GetObjById(CPWDID_"||"_EpID)
		Continue:'$IsObject(objEp)
		Set EpNo=objEp.EPEpisode
		Set EpDesc=objEp.EPDesc
		Continue:(EpNo="")!(EpDesc="")
		Set StepID=""
		For {
			Set StepID=$o(^DHCMRC("CPW",CPWDID,"EP",EpID,"STEP",StepID))
			Quit:(StepID="")
			Set StepRowID=CPWDID_"||"_EpID_"||"_StepID
			Set objStep=##class(web.DHCCPW.MRC.PathWEpStep).GetObjById(StepRowID)
			Continue:'$IsObject(objStep)
			Set StepNo=objStep.CPWSDayNumber
			Set StepDesc=objStep.CPWSDesc
			Continue:(StepNo="")!(StepDesc="")
			Set Data=$lb(StepRowID,StepDesc)
			Set ^CacheTemp(repid,ind)=Data
	 		Set ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod GetEpStepByCPWIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEpStepByCPWIDExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If (ind="") {
		Set AtEnd=1
		Set Row=""
	} Else {
		Set Row=^CacheTemp(repid,ind)
	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetEpStepByCPWIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEpStepByCPWIDExecute ]
{
	Set repid=$LIST($g(qHandle),2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator		: zhaoyu
/// CreateDate	: 2013-12-11
/// Description	: 根据出入径记录ID取新实施记录表已有的步骤
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.OPCPW.FormShowOP","QryImplNew","49")
Query QryImplNew(PathWayID As %String) As %Query(ROWSPEC = "ImplNewID:%String,ImplNewDesc:%String")
{
}

ClassMethod QryImplNewExecute(ByRef qHandle As %Binary, PathWayID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Quit:(+PathWayID=0) $$$OK
	Set ImplNewSub=""
	For {
		Set ImplNewSub=$o(^DHCMR("CPW",PathWayID,"IMPLNEW",ImplNewSub))
		Quit:(ImplNewSub="")
		Set ImplNewID=PathWayID_"||"_ImplNewSub
		Set objImplNew=##class(web.DHCCPW.OPCPW.InterfaceOP).GetObjByImplNewID(ImplNewID)
		Continue:'$IsObject(objImplNew)
		Set ImplNewActive=objImplNew.CPWENActive
		Continue:(ImplNewActive="N")
		Set ImplNewDate=objImplNew.CPWENStepStrDate
		Set ImplNewTime=objImplNew.CPWENStepStrTime
		Set:(ImplNewDate'="") ImplNewDate=$zd(ImplNewDate,3)
		Set:(ImplNewTime'="") ImplNewTime=$zt(ImplNewTime,2)
		Set Paadm=objImplNew.CPWENPaadm
		Set AdmInfo=$g(^PAADM(+Paadm))
		//Set AdmitDate=$p(AdmInfo,"^",6)
		//Set AdmitTime=$p(AdmInfo,"^",7)
		//upadte by pylian 2016-02-18 修改入院时间取值方式
    	Set AdmDateTime=##Class(web.DHCCPW.IO.FromAdmSrv).GetAdmDateTime(Paadm)
		Set AdmitDate=$p(AdmDateTime,"^",1)
		Set AdmitTime=$p(AdmDateTime,"^",2)
		Set:(AdmitDate'="") AdmitDate=$zd(+AdmitDate,3)
		Set:(AdmitTime'="") AdmitTime=$zt(+AdmitTime,2)
		Set tmpTime="(入径时间 "_ImplNewDate_" "_ImplNewTime_" 就诊时间 "_AdmitDate_" "_AdmitTime_")"
		//Set ImplNewDesc=objImplNew.CPWENEpStepDR.CPWSDesc_tmpTime
		Set ImplNewDesc=objImplNew.CPWENEpStepDR.CPWSDesc_" ("_ImplNewDate_" "_ImplNewTime_")"
		Set Data=$lb(ImplNewID,ImplNewDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryImplNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryImplNewExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If (ind="") {
		Set AtEnd=1
		Set Row=""
	} Else {
		Set Row=^CacheTemp(repid,ind)
	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QryImplNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryImplNewExecute ]
{
	Set repid=$LIST($g(qHandle),2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 查询病人门诊路径历史
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.OPCPW.FormShowOP","QryOPCPWByPaadm","1016")
Query QryOPCPWByPaadm(argPaadm As %String, AdmType As %String) As %Query(ROWSPEC = "ImplNewID:%String,AdmitDate:%String,AdmitTime:%String,Loc:%String,PathWayDesc:%String,StatusDesc:%String,StepDesc:%String,StepDate:%String,StepTime:%String,StepDoctor:%String,Note:%String")
{
}

ClassMethod QryOPCPWByPaadmExecute(ByRef qHandle As %Binary, argPaadm As %String, AdmType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set AdmType=$g(AdmType)
	Set:(AdmType="") AdmType="O"
	Quit:(+argPaadm=0) $$$OK
	Set PatientID=$p($g(^PAADM(+argPaadm)),"^",1)
	// ^PAPERdr({PAADM_PAPMI_DR},"ADM",{PAADM_Type},{PAADM_RowID})
	Set Paadm=""
	For {
		Set Paadm=$o(^PAPERdr(PatientID,"ADM",AdmType,Paadm),-1)
		Quit:(Paadm="")
		Set AdmInfo=$g(^PAADM(+Paadm))
		Set AdmLoc=$p(AdmInfo,"^",4)
		//Set AdmitDate=$p(AdmInfo,"^",6)
		//Set AdmitTime=$p(AdmInfo,"^",7)
		//upadte by pylian 2016-02-18 修改入院时间取值方式
    	Set AdmDateTime=##Class(web.DHCCPW.IO.FromAdmSrv).GetAdmDateTime(Paadm)
		Set AdmitDate=$p(AdmDateTime,"^",1)
		Set AdmitTime=$p(AdmDateTime,"^",2)
		Set:(AdmitDate'="") AdmitDate=$zd(+AdmitDate,3)
		Set:(AdmitTime'="") AdmitTime=$zt(+AdmitTime,2)
		Set MRAdm=##class(web.DHCCPW.MR.PAADMSrv).GetMRAdm(Paadm)
		Continue:(MRAdm="")
		Set PathWayID=""
		For {
			Set PathWayID=$o(^DHCMRi("CPW",0,"IndexMRAdm"," "_MRAdm,PathWayID),-1)
			Quit:(PathWayID="")
			Set objPathWay=##Class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(PathWayID)
			Continue:'$IsObject(objPathWay)
			Continue:'$IsObject(objPathWay.CPWPathwayDR)
			Set Status=objPathWay.CPWStatus
			Set StatusDesc=$s(Status="I":"入径",Status="O":"出径",Status="C":"完成",1:"ERROR")
			Set PathWayDesc=objPathWay.CPWPathwayDR.CPWDesc
			Set Loc=objPathWay.CPWInLoc
			Set:(Loc="") Loc=AdmLoc
			Set Loc=$p($g(^CTLOC(Loc)),"^",2)
			Set:($p(Loc,"-",2)'="") Loc=$p(Loc,"-",2)
			Set InDoctorDR=objPathWay.CPWInDoctorDR
			Set:InDoctorDR'="" InDoctorName=$p($g(^CTPCP(InDoctorDR,1)),"^",2)
			Set InDate=objPathWay.CPWInDate
			Set InTime=objPathWay.CPWInTime
			Set:InDate'="" InDate=$zd(+InDate,3)
			Set:InTime'="" InTime=$zt(+InTime,2)
			Set OutDoctorDR=objPathWay.CPWInDoctorDR
			Set:OutDoctorDR'="" OutDoctorName=$p($g(^CTPCP(OutDoctorDR,1)),"^",2)
			Set OutDate=objPathWay.CPWOutDate
			Set OutTime=objPathWay.CPWOutTime
			Set:OutDate'="" OutDate=$zd(+OutDate,3)
			Set:OutTime'="" OutTime=$zt(+OutTime,2)
			Set Note=objPathWay.CPWComments
			Set SubID=""
			For {
				Set SubID=$o(^DHCMR("CPW",PathWayID,"IMPLNEW",SubID),-1)
				Quit:(SubID="")
				Set ImplNewID=PathWayID_"||"_SubID
				Set objImplNew=##class(web.DHCCPW.OPCPW.InterfaceOP).GetObjByImplNewID(ImplNewID)
				Continue:'$IsObject(objImplNew)
				Set ImplNewActive=objImplNew.CPWENActive
				Continue:(ImplNewActive="N")
				Set StepDesc=objImplNew.CPWENEpStepDR.CPWSDesc
				Set StepDate=objImplNew.CPWENStepStrDate
				Set StepTime=objImplNew.CPWENStepStrTime
				Set:StepDate'="" StepDate=$zd(+StepDate,3)
				Set:StepTime'="" StepTime=$zt(+StepTime,2)
				Set StepDoctor=objImplNew.CPWENDoctor
				Set:StepDoctor'="" StepDoctor=$p($g(^CTPCP(StepDoctor,1)),"^",2)
				Set xPaadm=objImplNew.CPWENPaadm
				Set CurrAdm=$s(xPaadm=Paadm:"*",1:"")
				Set StepDesc=StepDesc_CurrAdm
				// 就诊日期 就诊时间 科室 路径名称 路径步骤 入径日期 入径时间 入径人 出径原因
				Set Data=$lb(ImplNewID,AdmitDate,AdmitTime,Loc,PathWayDesc,StatusDesc,StepDesc,StepDate,StepTime,StepDoctor,Note)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	Quit $$$OK
}

ClassMethod QryOPCPWByPaadmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOPCPWByPaadmExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If (ind="") {
		Set AtEnd=1
		Set Row=""
	} Else {
		Set Row=^CacheTemp(repid,ind)
	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QryOPCPWByPaadmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOPCPWByPaadmExecute ]
{
	Set repid=$LIST($g(qHandle),2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator		: zhaoyu
/// CreateDate	: 2013-11-05
/// Description	: 根据新实施记录ID取诊疗、医嘱、护理项目
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.OPCPW.FormShowOP","QryEpStepItems","49||1","02")
Query QryEpStepItems(ImplNewID As %String, Flag As %String) As %Query(ROWSPEC = "ItemRowid:%String,ItemDesc:%String,ItemOptional:%String,ItemImpl:%String,SubCatDesc:%String,OrderDtl:%String,ImplDtl:%String")
{
}

ClassMethod QryEpStepItemsExecute(ByRef qHandle As %Binary, ImplNewID As %String, Flag As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	//Set ^TMP("zy","arg")=ImplNewID_"///"_Flag
	Set (PathWayID,EpStepID)=""
	Set objImplNew=##class(web.DHCCPW.OPCPW.InterfaceOP).GetObjByImplNewID(ImplNewID)
	If $IsObject(objImplNew) {
		Set PathWayID=objImplNew.CPWENParRef.%Id()
		Set EpStepID=objImplNew.CPWENEpStepDR.%Id()
	}
	Set CategFlag=$s(Flag="01":"诊疗",Flag="02":"医嘱",Flag="03":"护理",1:"")
	Quit:(PathWayID="")!(EpStepID="")!(CategFlag="") $$$OK
	Set ZIndex=$zn,JIndex=$j
	Kill ^TMP(ZIndex,JIndex,"QryEpStepItems")
	
	Set CPWID=$p(EpStepID,"||",1),EpID=$p(EpStepID,"||",2),StepID=$p(EpStepID,"||",3)
	Set ItemID=""
	For {
		Set ItemID=$o(^DHCMRC("CPW",CPWID,"EP",EpID,"STEP",StepID,"ITEM",ItemID))
		Quit:(ItemID="")
		Set objItem=##class(web.DHCCPW.MRC.PathWEpStepItem).GetObjById(EpStepID_"||"_ItemID)
		Continue:'$IsObject(objItem)
		Continue:'$IsObject(objItem.CPWSISubCategory)
		Continue:'$IsObject(objItem.CPWSISubCategory.SISCParRef)
		Set CategDesc=objItem.CPWSISubCategory.SISCParRef.SICDesc
		Continue:CategDesc'[CategFlag	//按项目大类过滤
		Set CategID=objItem.CPWSISubCategory.SISCParRef.%Id()
		Set SubCatID=objItem.CPWSISubCategory.%Id()
		Set GroupNo=objItem.CPWSIGroupNo
		Set tmpGroupNo=""
		If (GroupNo'="") {
			Set $p(tmpGroupNo,"0",5-$l(GroupNo))=GroupNo
			Set GroupNo=tmpGroupNo
		}
		Continue:(GroupNo="")
		Set ^TMP(ZIndex,JIndex,"QryEpStepItems",CategID,SubCatID,GroupNo,ItemID)=""
	}
	
	Set CategID=""
	For {
		Set CategID=$o(^TMP(ZIndex,JIndex,"QryEpStepItems",CategID))
		Quit:(CategID="")
		Set SubCatID=""
		For {
			Set SubCatID=$o(^TMP(ZIndex,JIndex,"QryEpStepItems",CategID,SubCatID))
			Quit:(SubCatID="")
			Set objSubCat=##class(web.DHCCPW.MRC.StepItemSubCategory).GetObjById(SubCatID)
			Continue:'$IsObject(objSubCat)
			Set SubCatDesc=objSubCat.SISCDesc
			Continue:(SubCatDesc="")
			Set SubCatPower=objSubCat.SISCPower
			Set GroupNo=""
			For {
				Set GroupNo=$o(^TMP(ZIndex,JIndex,"QryEpStepItems",CategID,SubCatID,GroupNo))
				Quit:(GroupNo="")
				Set ItemID="",ItemIDList="",itemflg=0,tmpIsMust="",tmpArcim=""
				For {
					Set ItemID=$o(^TMP(ZIndex,JIndex,"QryEpStepItems",CategID,SubCatID,GroupNo,ItemID))
					Quit:(ItemID="")
					Set ItemRowid=CPWID_"||"_EpID_"||"_StepID_"||"_ItemID
					Set objItem=##class(web.DHCCPW.MRC.PathWEpStepItem).GetObjById(ItemRowid)
					Continue:'$IsObject(objItem)
					Set ItemDesc=objItem.CPWSIDesc
					Set ItemIsMust=objItem.CPWSIIsMust
					Set:ItemIsMust["Y" tmpIsMust="Y"
					Set:ItemIsMust["N" tmpIsMust="N"
					Set ArcimCnt=objItem.CPWSIARCIM.Count()
					Set:ArcimCnt>0 tmpArcim="Y"
					Set tmpItemID=$o(^TMP(ZIndex,JIndex,"QryEpStepItems",CategID,SubCatID,GroupNo,ItemID))
					Set ItemOptional=0
					Set:tmpIsMust="Y" ItemOptional=1
					Set:(tmpArcim'="Y")&&(tmpItemID="")&&((SubCatPower="OE")!(SubCatPower="NE")) ItemDesc=ItemDesc
					Continue:ItemDesc=""
					Set ItemRowid=ItemRowid_"-"_EpStepID_"-"_SubCatID
					Set OrderDtl=##Class(web.DHCCPW.MRC.ClinPathWaysSrv).GetItemDetailsById(ItemRowid)
					Set ImplDtl=##class(web.DHCCPW.OPCPW.FormShowOP).GetImplements(ImplNewID,ItemRowid)
					Set ItemImpl=$s(ImplDtl="":0,1:1)
					Set ImplDtlCur="null"
					Set ItemImplType=##class(web.DHCCPW.MRC.BaseConfig).GetValueByCode("OPCPWItemImplType")
					If (ItemImplType=1)&&(ItemImpl=1) {
						Set ImplDtlCur=##class(web.DHCCPW.OPCPW.FormShowOP).GetImplements(ImplNewID,ItemRowid,0)
						Set:(ImplDtlCur="") ItemImpl=2
					}
					Set Data=$lb(ItemRowid,ItemDesc,ItemOptional,ItemImpl,SubCatDesc,OrderDtl,ImplDtl)
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
		}
	}
	Kill ^TMP(ZIndex,JIndex,"QryEpStepItems")
	Quit $$$OK
}

ClassMethod QryEpStepItemsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryEpStepItemsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If (ind="") {
		Set AtEnd=1
		Set Row=""
	} Else {
		Set Row=^CacheTemp(repid,ind)
	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QryEpStepItemsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEpStepItemsExecute ]
{
	Set repid=$LIST($g(qHandle),2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator		: zhaoyu
/// CreateDate	: 2013-11-08
/// Description	: 根据新实施记录ID取变异项目
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.OPCPW.FormShowOP","QryEpStepVars","46||1")
Query QryEpStepVars(ImplNewID As %String) As %Query(ROWSPEC = "VarRowID:%String,VarNum:%String,VarDesc:%String,ExtraDesc:%String")
{
}

ClassMethod QryEpStepVarsExecute(ByRef qHandle As %Binary, ImplNewID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set (PathWayID,EpStepID)=""
	Set objImplNew=##class(web.DHCCPW.OPCPW.InterfaceOP).GetObjByImplNewID(ImplNewID)
	If $IsObject(objImplNew) {
		Set PathWayID=objImplNew.CPWENParRef.%Id()
		Set EpStepID=objImplNew.CPWENEpStepDR.%Id()
	}
	Quit:(PathWayID="")!(EpStepID="") $$$OK
	Set ItemImplType=##class(web.DHCCPW.MRC.BaseConfig).GetValueByCode("OPCPWItemImplType")
	Set VarID="",VarNum=0
	For {
		Set VarID=$o(^DHCMRi(0,"VAR","IndexEpStep",PathWayID,EpStepID,VarID))
		Quit:(VarID="")
		Set VarRowID=PathWayID_"||"_VarID
		Set objVar=##class(web.DHCCPW.MR.ClinPathWaysVariance).GetObjById(VarRowID)
		Continue:'$IsObject(objVar)
		Continue:'$IsObject(objVar.CPWVReasonDR)
		Continue:(objVar.CPWVUpdoFlag="Y")
		Continue:'$IsObject(objVar.CPWVImplNewDR)
		Continue:(+ItemImplType'=1)&&(objVar.CPWVImplNewDR.%Id()'=ImplNewID)
		Set VarDesc=objVar.CPWVReasonDR.VRDesc
		Set VarNote=objVar.CPWVNote
		Set:(VarNote'="") VarDesc=VarDesc_":"_VarNote
		Set VarDesc=$tr(VarDesc,$c(13),"")
		Set VarDesc=$tr(VarDesc,$c(10),"")
		Set ExtraDesc=""
		Set VarExtraValues=objVar.CPWVExtraValues
		For ExtraInd=1:1:$l(VarExtraValues,",")-1 {
			Set tmpExtraValues=$p(VarExtraValues,",",ExtraInd)
			Continue:(tmpExtraValues="")
			Set ExtraType=$p(tmpExtraValues,":",1)
			Set ExtraValue=$p(tmpExtraValues,":",2)
			Set tmpDesc=""
			If (ExtraType="STEPTIME") {
				Set objEpStep=##class(web.DHCCPW.MRC.PathWEpStep).GetObjById($p(ExtraValue,"-",2))
				Continue:'$IsObject(objEpStep)
				If ($p(ExtraValue,"-",1)="Max") {
					Set tmpDesc="步骤时间延长("_objEpStep.CPWSDesc_")"
				} ElseIf ($p(ExtraValue,"-",1)="Min") {
					Set tmpDesc="步骤时间缩短("_objEpStep.CPWSDesc_")"
				}
			} ElseIf (ExtraType="CPWITM") {
				Set objItem=##class(web.DHCCPW.MRC.PathWEpStepItem).GetObjById($p(ExtraValue,"-",1))
				Continue:('$IsObject(objItem))
				Continue:'$IsObject(objItem.CPWSISubCategory)
				Continue:'$IsObject(objItem.CPWSISubCategory.SISCParRef)
				Set ItemDesc=objItem.CPWSIDesc
				Set IsMust=objItem.CPWSIIsMust	// 区分必选可选
				Set CategDesc=objItem.CPWSISubCategory.SISCParRef.SICDesc
				Set SubCatDesc=objItem.CPWSISubCategory.SISCDesc
				Set tmpDesc=ItemDesc_"("_CategDesc_"-"_SubCatDesc_")"
			} ElseIf (ExtraType="OEITEM") {
				Set ExtraValue=$p(ExtraValue,"-",1)
				Set OEItemInfo=$g(^OEORD($p(ExtraValue,"||",1),"I",$p(ExtraValue,"||",2),1))
				Set ArcimID=$p(OEItemInfo,"^",2)
				Set ArcimDesc=$p($g(^ARCIM($p(ArcimID,"||",1),$p(ArcimID,"||",2),1)),"^",2)
				Set SttDate=$p(OEItemInfo,"^",9)
				Set SttTime=$p(OEItemInfo,"^",10)
				Set:(SttDate'="") SttDate=$zd(SttDate,3)
				Set:(SttTime'="") SttTime=$zt(SttTime)
				Set OEItemDoc=$p(OEItemInfo,"^",11)
				Set:(OEItemDoc'="") OEItemDoc=$p($g(^CTPCP(+OEItemDoc,1)),"^",2)
				Set tmpDesc=ArcimDesc_"("_OEItemDoc_"  "_SttDate_" "_SttTime_")"
			} ElseIf (ExtraType="ARCIM") {
				Set ExtraValue=$p(ExtraValue,"-",1)
				Set ArcimDesc=$p($g(^ARCIM($p(ExtraValue,"||",1),$p(ExtraValue,"||",2),1)),"^",2)
				Set tmpDesc=ArcimDesc
			}
			Set:(tmpDesc'="") ExtraDesc=ExtraDesc_tmpDesc_","
		}
		Set VarNum=VarNum+1
		Set Data=$lb(VarRowID,VarNum,VarDesc,ExtraDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryEpStepVarsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryEpStepVarsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If (ind="") {
		Set AtEnd=1
		Set Row=""
	} Else {
		Set Row=^CacheTemp(repid,ind)
	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QryEpStepVarsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEpStepVarsExecute ]
{
	Set repid=$LIST($g(qHandle),2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator		: zhaoyu
/// CreateDate	: 2013-11-08
/// Description : 根据新实施记录ID取医师护士签名
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.OPCPW.FormShowOP","QryEpStepSigns","39||1","D")
Query QryEpStepSigns(ImplNewID As %String, Type As %String) As %Query(ROWSPEC = "SignRowID:%String,SignNum:%String,ItemDesc:%String")
{
}

ClassMethod QryEpStepSignsExecute(ByRef qHandle As %Binary, ImplNewID As %String, Type As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set (PathWayID,EpStepID)=""
	Set objImplNew=##class(web.DHCCPW.OPCPW.InterfaceOP).GetObjByImplNewID(ImplNewID)
	If $IsObject(objImplNew) {
		Set PathWayID=objImplNew.CPWENParRef.%Id()
		Set EpStepID=objImplNew.CPWENEpStepDR.%Id()
	}
	Quit:(PathWayID="")!(EpStepID="") $$$OK
	Set ItemImplType=##class(web.DHCCPW.MRC.BaseConfig).GetValueByCode("OPCPWItemImplType")
	Set SignID="",SignNum=0
	For {
		Set SignID=$o(^DHCMRi(0,"SIGN","IndexEpStep",PathWayID,EpStepID,SignID))
		Quit:(SignID="")
		Set SignRowID=PathWayID_"||"_SignID
		Set objSign=##class(web.DHCCPW.MR.ClinPathWaysSign).GetObjById(SignRowID)
		Continue:'$IsObject(objSign)
		Continue:objSign.CPWSActive'["Y"
		Continue:'$IsObject(objSign.CPWSImplNewDR)
		Continue:(objSign.CPWSImplNewDR.%Id()'=ImplNewID)
		//Continue:(+ItemImplType'=1)&&(objSign.CPWSImplNewDR.%Id()'=ImplNewID)
		Set CareProvID=$s(Type="D":objSign.CPWSDoctorDR,Type="N":objSign.CPWSNurseDR,1:"")
		Set CareProvName=$p($g(^CTPCP(+CareProvID,1)),"^",2)
		Continue:(CareProvName="")
		Set SignDate=objSign.CPWSDate
		Set SignTime=objSign.CPWSTime
		Set:(SignDate'="") SignDate=$zd(SignDate,3)
		Set:(SignTime'="") SignTime=$zt(SignTime,2)
		Set ItemDesc=CareProvName_" "_SignDate_" "_SignTime
		Set ItemDesc=$tr(ItemDesc,$c(10),"")
		Set ItemDesc=$tr(ItemDesc,$c(13),"")
		Set SignNum=SignNum+1
		Set Data=$lb(SignRowID,SignNum,ItemDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryEpStepSignsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryEpStepSignsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If (ind="") {
		Set AtEnd=1
		Set Row=""
	} Else {
		Set Row=^CacheTemp(repid,ind)
	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QryEpStepSignsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEpStepSignsExecute ]
{
	Set repid=$LIST($g(qHandle),2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator		: zhaoyu
/// CreateDate	: 2013-12-19
/// Description	: 获取表单项目执行情况
/// w ##class(web.DHCCPW.OPCPW.FormShowOP).GetImplements("50||3","84||4||1||1-84||4||1-2||1")
ClassMethod GetImplements(ImplNewID As %String, ItemID As %String, Type As %String = "") As %String
{
	New (ImplNewID,ItemID,Type)
	Set ret=""
	Quit:(ImplNewID="")!(ItemID="") ret
	Set Type=$g(Type)
	Set ItemImplType=##class(web.DHCCPW.MRC.BaseConfig).GetValueByCode("OPCPWItemImplType")
	Set:Type'="" ItemImplType=+Type
	Set $ZT="GetImplementsError"
	Set PathWayID=$p(ImplNewID,"||",1)
	Set StepID=$p(ItemID,"-",2)
	Set ItemID=$p(ItemID,"-",1)
	
	Set objItem=##class(web.DHCCPW.MRC.PathWEpStepItem).GetObjById(ItemID)
	Quit:'$IsObject(objItem) ret
	Set OrderDtl=##Class(web.DHCCPW.MRC.ClinPathWaysSrv).GetItemDetailsById(ItemID)
	Set cmpItemDesc=","_objItem.CPWSIDesc_","
	Set MedItem=##class(web.DHCCPW.MRC.BaseConfig).GetValueByCode("OPCPWMedItemDesc")
	Set cmpMedItem=","_MedItem_","
	If (cmpMedItem[cmpItemDesc)&&(OrderDtl="") {
		Set OrdMedFlg=##class(web.DHCCPW.OPCPW.FormShowOP).CheckIsOrderMed(ImplNewID)
		Set ret=$s(OrdMedFlg="Y":"^已开中草药医嘱",1:"")
		If (+ItemImplType=1)&&(ret="") {
			Set xImplNewSub="",xOrdMedFlg=""
			For {
				Set xImplNewSub=$o(^DHCMR("CPW",PathWayID,"IMPLNEW",xImplNewSub))
				Quit:(xImplNewSub="")!(xOrdMedFlg="Y")
				Set xImplNewID=PathWayID_"||"_xImplNewSub
				Set xobjImplNew=##class(web.DHCCPW.OPCPW.InterfaceOP).GetObjByImplNewID(xImplNewID)
				Continue:'$IsObject(xobjImplNew)
				Set xImplNewActive=xobjImplNew.CPWENActive
				Continue:(xImplNewActive="N")
				Set xEpStep=xobjImplNew.CPWENEpStepDR.%Id()
				Continue:(xEpStep'=StepID)
				Set xOrdMedFlg=##class(web.DHCCPW.OPCPW.FormShowOP).CheckIsOrderMed(xImplNewID)
			}
			Set:(xOrdMedFlg="Y") ret="^已开中草药医嘱"
		}
		Quit ret
	}
	
	Set SubID=0
	For {
		Set SubID=$o(^DHCMRi(0,"IMPL","IndexStepItem",PathWayID,ItemID,SubID))
		Quit:(SubID="")
		Set ImplementID=PathWayID_"||"_SubID
		Set objImplement=##class(web.DHCCPW.MR.Implement).GetObjById(ImplementID)
		If $IsObject(objImplement) {
			Set Active=objImplement.CPWEActive
			Continue:(Active["N")
			Set ImplNewDR=objImplement.CPWEImplNewDR
			Continue:'$IsObject(ImplNewDR)
			Continue:(+ItemImplType'=1)&&(ImplNewDR.%Id()'=ImplNewID)
			Set CPWEStepDR=objImplement.CPWEStepDR.%Id()
			If (CPWEStepDR'="") {
				Continue:(StepID'="")&&(CPWEStepDR'=StepID)
			}
			Set ImplementDate=objImplement.CPWEImplementDate
			Set:(ImplementDate'="") ImplementDate=$zd(ImplementDate,3)
			Set ImplementTime=objImplement.CPWEImplementTime
			Set:(ImplementTime'="") ImplementTime=$zt(ImplementTime,2)
			Set OEItemID=objImplement.CPWEOEORIDR
			Set ARCItemID="",OEItemDesc=""
			Set:(OEItemID'="") ARCItemID=$p($g(^OEORD(+OEItemID,"I",$p(OEItemID,"||",2),1)),"^",2)
			Set:(ARCItemID'="") OEItemDesc=$p($g(^ARCIM(+ARCItemID,$p(ARCItemID,"||",2),1)),"^",2)
			Set ProcNote=objImplement.CPWEProcNote
			Set ImplDesc=ImplementDate_" "_ImplementTime
			Set DocID=objImplement.CPWEDoctorDR
			Set DocDesc=$p($g(^CTPCP(+DocID,1)),"^",2)
			//Set:(DocDesc'="") ImplDesc=ImplDesc_" ,"_DocDesc
			//Set:(OEItemDesc'="") ImplDesc=ImplDesc_" ,"_OEItemDesc
			//Set:(ProcNote'="") ImplDesc=ImplDesc_" ,"_ProcNote
			If (OEItemID'="") {
				Set ImplementID=""
				Set ImplDesc=OEItemDesc_" "_ImplDesc
			} Else {
				Set ImplDesc=ImplDesc_" "_ProcNote
			}
			Set:(DocDesc'="") ImplDesc=ImplDesc_" "_DocDesc
			Set ret=ret_$c(1)_ImplementID_"^"_ImplDesc
		}
	}
	Set:ret'="" ret=$e(ret,2,$l(ret))
	Quit ret

GetImplementsError
 	Quit ret
}

/// Creator		: zhaoyu
/// CreatDate	: 2013-12-19
/// Description	: 根据新实施记录ID查询变异内容列表
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.OPCPW.FormShowOP","QryVarItemListOP","50||3","D")
Query QryVarItemListOP(ImplNewID As %String, UserType As %String) As %Query(ROWSPEC = "VarItemInd:%String,VarItemCode:%String,VarItemDesc:%String,VarItemGroup:%String")
{
}

ClassMethod QryVarItemListOPExecute(ByRef qHandle As %Binary, ImplNewID As %String, UserType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Quit:(ImplNewID="")!(UserType="") $$$OK
	Set ZIndex=$zn,JIndex=$j,NIndex="QryVarItemListOP"
	Kill ^CacheTemp(ZIndex,JIndex,NIndex)
	// 路径内项目
	Set CPWFlag=##class(web.DHCCPW.OPCPW.FormShowOP).GetCPWVarList(ZIndex,JIndex,NIndex,ImplNewID,UserType)
	// 路径外医嘱
	Set OutFlag=##class(web.DHCCPW.OPCPW.FormShowOP).GetOutVarList(ZIndex,JIndex,NIndex,ImplNewID,UserType)
	Set ItemInd=0
	For {
		Set ItemInd=$o(^CacheTemp(ZIndex,JIndex,NIndex,ItemInd))
		Quit:(ItemInd="")
		Set Data=$g(^CacheTemp(ZIndex,JIndex,NIndex,ItemInd))
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Kill ^CacheTemp(ZIndex,JIndex,NIndex)
	Quit $$$OK
}

ClassMethod QryVarItemListOPFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryVarItemListOPExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If (ind="") {
		Set AtEnd=1
		Set Row=""
	} Else {
		Set Row=^CacheTemp(repid,ind)
	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QryVarItemListOPClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryVarItemListOPExecute ]
{
	Set repid=$LIST($g(qHandle),2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator		: zhaoyu
/// CreatDate	: 2013-12-24
/// Description	: 根据新实施记录ID取变异医嘱(对照用)
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.OPCPW.FormShowOP","QryVarOrder","50||3","D")
Query QryVarOrder(ImplNewID As %String, UserType As %String) As %Query(ROWSPEC = "ItemInd:%String,ArcimID:%String,ArcimDesc:%String,OEItemID:%String")
{
}

ClassMethod QryVarOrderExecute(ByRef qHandle As %Binary, ImplNewID As %String, UserType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Quit:(ImplNewID="")!(UserType="") $$$OK
	Set ZIndex=$zn,JIndex=$j,NIndex="QryVarOrder"
	Kill ^CacheTemp(ZIndex,JIndex)
	Set OutFlag=##class(web.DHCCPW.OPCPW.FormShowOP).GetOutVarList(ZIndex,JIndex,NIndex,ImplNewID,UserType)
	Set ItemInd=0
	For {
		Set ItemInd=$o(^CacheTemp(ZIndex,JIndex,NIndex,ItemInd))
		Quit:(ItemInd="")
		Set tmpStr=$g(^CacheTemp(ZIndex,JIndex,NIndex,ItemInd))
		Set tmpCode=$List(tmpStr,2)
		Set tmpCode=$p(tmpCode,":",2)
		Set tmpCode=$p(tmpCode,"-",1)
		Set OEItemInfo=$g(^OEORD($p(tmpCode,"||",1),"I",$p(tmpCode,"||",2),1))
		Set OEItemID=$p(tmpCode,"||",1)_"||"_$p(tmpCode,"||",2)
		Set ArcimID=$p(OEItemInfo,"^",2)
		Set ArcimDesc=$List(tmpStr,3)
		Set ArcimDesc=$tr(ArcimDesc,$c(1),"")
		Set Data=$lb(ItemInd,ArcimID,ArcimDesc,OEItemID)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Kill ^CacheTemp(ZIndex,JIndex)
	Quit $$$OK
}

ClassMethod QryVarOrderFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryVarOrderExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If (ind="") {
		Set AtEnd=1
		Set Row=""
	} Else {
		Set Row=^CacheTemp(repid,ind)
	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QryVarOrderClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryVarOrderExecute ]
{
	Set repid=$LIST($g(qHandle),2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator		: zhaoyu
/// CreatDate	: 2013-12-19
/// Description	: 查询对照表
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.OPCPW.FormShowOP","QryContrastByEpStepID","84||4||1")
Query QryContrastByEpStepID(EpStepID As %String, Active As %String) As %Query(ROWSPEC = "ContrastID:%String,StepItemID:%String,StepItemDesc:%String,ContItemID:%String,ContItemDesc:%String,ContActive:%String,ContUser:%String,ContDate:%String,ContTime:%String,UpdoUser:%String,UpdoDate:%String,UpdoTime:%String,SubCatDesc:%String,ItemOptional:%String")
{
}

ClassMethod QryContrastByEpStepIDExecute(ByRef qHandle As %Binary, EpStepID As %String, Active As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set Active=$g(Active)
	Quit:(EpStepID="") $$$OK
	Set EpStepItemID=""
	For {
		Set EpStepItemID=$o(^DHCMRi("CPWC",0,"IndexCPWStepItem",$p(EpStepID,"||",1),EpStepID,EpStepItemID))
		Quit:(EpStepItemID="")
		Set ContrastID=""
		For {
			Set ContrastID=$o(^DHCMRi("CPWC",0,"IndexCPWStepItem",$p(EpStepID,"||",1),EpStepID,EpStepItemID,ContrastID))
			Quit:(ContrastID="")
			Set objContrast=##class(web.DHCCPW.OPCPW.InterfaceOP).GetObjByContrastID(ContrastID)
			Continue:'$IsObject(objContrast)
			Set ContActive=objContrast.CPWCActive
			Continue:(Active'="")&&(Active'=ContActive)
			Set StepItemID=objContrast.CPWCEpStepItemDR.%Id()
			Set StepItemDesc=objContrast.CPWCEpStepItemDR.CPWSIDesc
			Set ItemIsMust=objContrast.CPWCEpStepItemDR.CPWSIIsMust
			Set ItemOptional=$s(ItemIsMust["Y":1,1:0)
			Set SubCatDesc=objContrast.CPWCEpStepItemDR.CPWSISubCategory.SISCDesc
			Set ContItemID=objContrast.CPWCContItem
			Set ContItemDesc=$p($g(^ARCIM($p(ContItemID,"||",1),$p(ContItemID,"||",2),1)),"^",2)
			Set ContUser=objContrast.CPWCContUser
			Set ContUser=$p($g(^CTPCP(+ContUser,1)),"^",2)
			Set ContDate=objContrast.CPWCContDate
			Set ContTime=objContrast.CPWCContTime
			Set:(ContDate'="") ContDate=$zd(ContDate,3)
			Set:(ContTime'="") ContTime=$zt(ContTime)
			Set UpdoUser=objContrast.CPWCUpdoUser
			Set UpdoUser=$p($g(^CTPCP(+UpdoUser,1)),"^",2)
			Set UpdoDate=objContrast.CPWCUpdoDate
			Set UpdoTime=objContrast.CPWCUpdoTime
			Set:(UpdoDate'="") UpdoDate=$zd(UpdoDate,3)
			Set:(UpdoTime'="") UpdoTime=$zt(UpdoTime)
			Set Data=$lb(ContrastID,StepItemID,StepItemDesc,ContItemID,ContItemDesc,ContActive,ContUser,ContDate,ContTime,UpdoUser,UpdoDate,UpdoTime,SubCatDesc,ItemOptional)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryContrastByEpStepIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryContrastByEpStepIDExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If (ind="") {
		Set AtEnd=1
		Set Row=""
	} Else {
		Set Row=^CacheTemp(repid,ind)
	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QryContrastByEpStepIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryContrastByEpStepIDExecute ]
{
	Set repid=$LIST($g(qHandle),2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 路径内变异项目
/// w ##class(web.DHCCPW.OPCPW.FormShowOP).GetCPWVarList("50||3")
ClassMethod GetCPWVarList(xZIndex As %String, xJIndex As %String, xNIndex As %String, ImplNewID As %String, UserType As %String) As %String
{
	New (xZIndex,xJIndex,xNIndex,ImplNewID,UserType)
	Set num=0
	Set IsCheckRequired=##class(web.DHCCPW.MRC.BaseConfig).GetValueByCode("CheckFormRequiredItemToSign")
	Set IsCheckOptional=##class(web.DHCCPW.MRC.BaseConfig).GetValueByCode("CheckFormOptionalItemToSign")
	Set:(IsCheckRequired'="N")!(IsCheckRequired[UserType) IsCheckRequired="Y"
	Set:(IsCheckOptional'="N")!(IsCheckOptional[UserType) IsCheckOptional="Y"
	Set CheckType=IsCheckRequired_IsCheckOptional
	Set CheckType=$s(CheckType="YN":"必选",CheckType="NY":"可选",CheckType="YY":"项目",1:"")
	Quit:(ImplNewID="")!(CheckType="") num
	Set rs=##Class(%ResultSet).%New("web.DHCCPW.OPCPW.FormShowOP:QryEpStepItems")
	For VarListInd=1:1:2 {	// 门诊没护理
		Set Flag="0"_VarListInd
		Do rs.Execute(ImplNewID,Flag)
		While (rs.Next()) {
			Set CategDesc=$s(Flag="01":"主要诊疗工作",Flag="02":"重点医嘱",Flag="03":"主要护理工作",1:"")
			Set ItemRowid=rs.Get("ItemRowid")
			Set ItemDesc=rs.Get("ItemDesc")
			Set ItemOptional=rs.Get("ItemOptional")
			Set ItemImpl=rs.Get("ItemImpl")
			Set SubCatDesc=rs.Get("SubCatDesc")
			Set VarItemCode="CPWITM:"_$p(ItemRowid,"-",1)_"-"_$p(ItemRowid,"-",2)
			Set VarItemDesc=ItemDesc_"("_CategDesc_"-"_SubCatDesc_")"
			Set VarItemGroup=""
			If (ItemOptional=1)&&(ItemImpl=1) {
				Set VarItemGroup="可选项目已执行"
			} ElseIf (ItemOptional=0)&&(ItemImpl=0) {
				Set VarItemGroup="必选项目未执行"
			}
			Continue:(VarItemGroup="")!(VarItemGroup'[CheckType)
			Set objItemSubCategory=##class(web.DHCCPW.MRC.StepItemSubCategory).GetObjById($p(ItemRowid,"-",3))
			Continue:'$IsObject(objItemSubCategory)
			Set ItemPower=objItemSubCategory.SISCPower
			Continue:(UserType="D")&&((ItemPower'="D")&&(ItemPower'="OE"))
			Continue:(UserType="N")&&((ItemPower'="N")&&(ItemPower'="NE"))
			Set IsHaveVarRst=##class(web.DHCCPW.OPCPW.FormShowOP).CheckIsVariance(ImplNewID,VarItemCode)
			Continue:(IsHaveVarRst="Y")	//填写过变异记录不再显示
			Set num=$i(^CacheTemp(xZIndex,xJIndex,xNIndex))
			Set ^CacheTemp(xZIndex,xJIndex,xNIndex,num)=$lb(num,VarItemCode,VarItemDesc,VarItemGroup)
		}
		Do rs.Close()
	}
	Quit num
}

/// 路径外变异医嘱
/// w ##class(web.DHCCPW.OPCPW.FormShowOP).GetOutVarList("50||3","D")
ClassMethod GetOutVarList(yZIndex As %String, yJIndex As %String, yNIndex As %String, ImplNewID As %String, UserType As %String) As %String
{
	New (yZIndex,yJIndex,yNIndex,ImplNewID,UserType)
	Set num=0
	Set ImplNewStr=##class(web.DHCCPW.OPCPW.InterfaceOP).GetStringByImplNewID(ImplNewID)
	Set EpStepID=$p(ImplNewStr,"^",2),EpisodeID=$p(ImplNewStr,"^",4)
	Quit:(EpStepID="")!(EpisodeID="") num
	Set IsCheck=##class(web.DHCCPW.MRC.BaseConfig).GetValueByCode("CheckOutOEItemToSign")
	Quit:(IsCheck="N")&&(IsCheck'[UserType) num
	Set ArcimCategList=##Class(web.DHCCPW.MR.ClinPathWaysVariance).GetListFromConfig("OutFormArcimCateg",",")
	Set ArcimSubCatList=##Class(web.DHCCPW.MR.ClinPathWaysVariance).GetListFromConfig("OutFormArcimSubCat",",")
	Set StDtTmIndex=##class(web.DHCCPW.MRC.BaseConfig).GetValueByCode("OEOrdItemStDtTmIndex")
	Set OrdID=$o(^OEORD(0,"Adm",EpisodeID,""))
	Set ArcimID=""
	For {
		Set ArcimID=$o(^OEORDi(0,"ARCIM",OrdID,ArcimID))
		Quit:(ArcimID="")
		Set ItemSubCatDR=$P($g(^ARCIM($P(ArcimID,"||",1),$P(ArcimID,"||",2),1)),"^",10)
		Set ItemSubCatDesc=$p(^ARC("IC",ItemSubCatDR),"^",2)
		Continue:(ArcimSubCatList'="")&&($listfind(ArcimSubCatList,ItemSubCatDesc)>0)	//医嘱子类
		Continue:(ItemSubCatDesc="挂号费")!(ItemSubCatDesc="诊疗费")!(ItemSubCatDesc="其它1")
		Set OrdCatDR=$p(^ARC("IC",ItemSubCatDR),"^",8)
		Set OrdCatDesc=$p(^OEC("ORCAT",OrdCatDR),"^",2)
		Continue:(ArcimCategList'="")&&($listfind(ArcimCategList,OrdCatDesc)>0)	//医嘱大类
		Continue:(OrdCatDesc="挂号费")!(OrdCatDesc="诊疗费")!(OrdCatDesc="其它收费")
		Continue:(OrdCatDesc="中草药")	// 中草药不算
		Set ArcimDesc=$p($g(^ARCIM(+ArcimID,+$p(ArcimID,"||",2),1)),"^",2)
		Set CompareStr0="ARCIM:"_ArcimID_"-"_EpStepID
		Set IsHaveVarRst0=##class(web.DHCCPW.OPCPW.FormShowOP).CheckIsVariance(ImplNewID,CompareStr0)
		Continue:(IsHaveVarRst0="Y")	//填写过变异记录不再显示
		//^OEORDi(0,"ARCIM",{OE_Order.OEORD_RowId},{OEORI_ItmMast_DR},{OEORI_SttDat},{OEORI_Childsub})
		Set SttDate=""
		For {
			Set SttDate=$o(^OEORDi(0,"ARCIM",OrdID,ArcimID,SttDate))
			Quit:(SttDate="")
			Set OrdItmSub=""
			For {
				Set OrdItmSub=$o(^OEORDi(0,"ARCIM",OrdID,ArcimID,SttDate,OrdItmSub))
				Quit:(OrdItmSub="")
				Set OrdItmID=OrdID_"||"_OrdItmSub
				Set OrdItmInfo=$g(^OEORD(+OrdID,"I",+OrdItmSub,1))
				Set OeoriStatus=""
				Set OeoriStatusID=$p(OrdItmInfo,"^",13)
				Set:(OeoriStatusID'="") OeoriStatus=$p($g(^OEC("OSTAT",OeoriStatusID)),"^",1)
				Continue:(OeoriStatus="")
				If (StDtTmIndex="StDtTmNew") {	// 新版本医嘱,医嘱无效通过OE_OrdItem表状态和OE_OrdExec状态判断
					Continue:(OeoriStatus["C")	// 医嘱状态 撤销
					Continue:(OeoriStatus["U")	// 医嘱状态 作废
					Continue:(OeoriStatus["I")	// 医嘱状态 未审核
				} Else {	// 旧版本医嘱,医嘱无效通过OE_OrdItem表状态判断
					//Continue:(OeoriStatus["D")	// 医嘱状态 停止
					Continue:(OeoriStatus["I")	// 医嘱状态 未审核
				}
				Set SttDate=$p(OrdItmInfo,"^",9)
				Set SttTime=$p(OrdItmInfo,"^",10)
				Set OrdItmDoc=$p(OrdItmInfo,"^",11)
				If (OrdItmDoc'="") {
					Set OEDocType=$p($g(^CTPCP(+OrdItmDoc,1)),"^",4)
					Set:(OEDocType'="") OEDocType=$p($g(^CT("CPT",OEDocType)),"^",4)
					Continue:(OEDocType'[UserType)
					Set OrdItmDoc=$p($g(^CTPCP(+OrdItmDoc,1)),"^",2)
				}
				Set IsHaveImplRst=##class(web.DHCCPW.OPCPW.FormShowOP).CheckIsImplement(ImplNewID,OrdItmID)
				Continue:(IsHaveImplRst="Y")	// 已执行的医嘱不再显示
				Set CompareStr1="OEITEM:"_OrdItmID_"-"_EpStepID
				Set IsHaveVarRst1=##class(web.DHCCPW.OPCPW.FormShowOP).CheckIsVariance(ImplNewID,CompareStr1)
				Continue:(IsHaveVarRst1="Y")	//填写过变异记录不再显示
				Set VarItemCode="OEITEM:"_OrdItmID_"-"_EpStepID
				Set VarItemDesc=ArcimDesc_$c(1)_"("_OrdItmDoc_"  "_$zd(SttDate,3)_" "_$zt(SttTime,2)_")"
				Set VarItemGroup="表单外医嘱"
				Set num=$i(^CacheTemp(yZIndex,yJIndex,yNIndex))
				Set ^CacheTemp(yZIndex,yJIndex,yNIndex,num)=$lb(num,VarItemCode,VarItemDesc,VarItemGroup)
			}
		}
	}
	Quit num
}

/// zhaoyu 2014-04-04
/// 检查病人医嘱是否有中草药
/// w ##class(web.DHCCPW.OPCPW.FormShowOP).CheckIsOrderMed()
ClassMethod CheckIsOrderMed(ImplNewID As %String) As %String
{
	New (ImplNewID)
	Set ret=""
	Set ImplNewStr=##class(web.DHCCPW.OPCPW.InterfaceOP).GetStringByImplNewID(ImplNewID)
	Set EpStepID=$p(ImplNewStr,"^",2),EpisodeID=$p(ImplNewStr,"^",4)
	Quit:(EpStepID="")!(EpisodeID="") ret
	Set ret="N"
	Set OrdID=$o(^OEORD(0,"Adm",EpisodeID,""))
	Set ArcimID=""
	For {
		Set ArcimID=$o(^OEORDi(0,"ARCIM",OrdID,ArcimID))
		Quit:(ArcimID="")!(ret="Y")
		Set ItemSubCatDR=$P($g(^ARCIM($P(ArcimID,"||",1),$P(ArcimID,"||",2),1)),"^",10)
		Set ItemSubCatDesc=$p(^ARC("IC",ItemSubCatDR),"^",2)
		Set OrdCatDR=$p(^ARC("IC",ItemSubCatDR),"^",8)
		Set OrdCatDesc=$p(^OEC("ORCAT",OrdCatDR),"^",2)
		Set:(OrdCatDesc="中草药") ret="Y"
	}
	Quit ret
}

/// Creator		: zhaoyu
/// CreateDate	: 2013-12-19
/// Description	: 检查项目是否有变异记录
/// w ##class(web.DHCCPW.OPCPW.FormShowOP).CheckIsVariance("","")
ClassMethod CheckIsVariance(ImplNewID As %String, CompareStr As %String) As %String
{
	New (ImplNewID,CompareStr)
	Set ImplNewStr=##class(web.DHCCPW.OPCPW.InterfaceOP).GetStringByImplNewID(ImplNewID)
	Set PathWayID=$p(ImplNewStr,"^",1),EpStepID=$p(ImplNewStr,"^",2)
	Set ChildSub="",IsHaveVarRst="N"
	Quit:(PathWayID="")!(EpStepID="")!(CompareStr="") IsHaveVarRst
	Set ItemImplType=##class(web.DHCCPW.MRC.BaseConfig).GetValueByCode("OPCPWItemImplType")
	For {
		Set ChildSub=$o(^DHCMRi(0,"VAR","IndexEpStep",PathWayID,EpStepID,ChildSub))
		Quit:(ChildSub="")!(IsHaveVarRst="Y")
		Set VarianceID=PathWayID_"||"_ChildSub
		Set objVariance=##class(web.DHCCPW.MR.ClinPathWaysVariance).GetObjById(VarianceID)
		Continue:'$IsObject(objVariance)
		Set UpdoFlag=objVariance.CPWVUpdoFlag
		Set ExtraValues=objVariance.CPWVExtraValues
		Set ImplNewDR=objVariance.CPWVImplNewDR
		Continue:'$IsObject(ImplNewDR)
		Continue:(+ItemImplType'=1)&&(ImplNewDR.%Id()'=ImplNewID)
		Continue:(UpdoFlag="Y")!(ExtraValues'[CompareStr)
		Set IsHaveVarRst="Y"
	}
	Quit IsHaveVarRst
}

/// Creator		: zhaoyu
/// CreateDate	: 2013-12-19
/// Description	: 检查医嘱是否有实施记录 OEOrdItem
/// w ##class(web.DHCCPW.OPCPW.FormShowOP).CheckIsImplement("50||3","983||11")
ClassMethod CheckIsImplement(ImplNewID As %String, CompareStr As %String) As %String
{
	New (ImplNewID,CompareStr)
	Set ImplNewStr=##class(web.DHCCPW.OPCPW.InterfaceOP).GetStringByImplNewID(ImplNewID)
	Set PathWayID=$p(ImplNewStr,"^",1),EpStepID=$p(ImplNewStr,"^",2)
	Set ChildSub="",IsHaveImplRst="N"
	Quit:(PathWayID="")!(EpStepID="")!(CompareStr="") IsHaveImplRst
	Set ItemImplType=##class(web.DHCCPW.MRC.BaseConfig).GetValueByCode("OPCPWItemImplType")
	For {
		Set ChildSub=$o(^DHCMRi(0,"IMPL","IndexStepDR",PathWayID,EpStepID,ChildSub))
		Quit:(ChildSub="")!(IsHaveImplRst="Y")
		Set ImplementID=PathWayID_"||"_ChildSub
		Set objImplement=##class(web.DHCCPW.MR.Implement).GetObjById(ImplementID)
		Continue:'$IsObject(objImplement)
		Set Active=objImplement.CPWEActive
		Continue:(Active["N")
		Set ImplNewDR=objImplement.CPWEImplNewDR
		Continue:'$IsObject(ImplNewDR)
		Continue:(+ItemImplType'=1)&&(ImplNewDR.%Id()'=ImplNewID)
		Set OEItemID=objImplement.CPWEOEORIDR
		Continue:(OEItemID'=CompareStr)
		Set IsHaveImplRst="Y"
	}
	Quit IsHaveImplRst
}

/// 根据版本ID取步骤列表(帮助文档)
/// w ##class(web.DHCCPW.OPCPW.FormShowOP).GetCPWEpStr("")
ClassMethod GetCPWEpStr(CPWID As %String) As %String
{
	New (CPWID)
	Set EpID="",ret=""
	For {
		Set EpID=$o(^DHCMRC("CPW",CPWID,"EP",EpID))
		Quit:(EpID="")
		Set objEp=##class(web.DHCCPW.MRC.PathWayEp).GetObjById(CPWID_"||"_EpID)
		Continue:'$IsObject(objEp)
		Set EpNo=objEp.EPEpisode
		Set EpDesc=objEp.EPDesc
		Continue:(EpNo="")!(EpDesc="")
		Set StepID=""
		For {
			Set StepID=$o(^DHCMRC("CPW",CPWID,"EP",EpID,"STEP",StepID))
			Quit:(StepID="")
			Set StepRowID=CPWID_"||"_EpID_"||"_StepID
			Set objStep=##class(web.DHCCPW.MRC.PathWEpStep).GetObjById(StepRowID)
			Continue:'$IsObject(objStep)
			Set StepNo=objStep.CPWSDayNumber
			Set StepDesc=objStep.CPWSDesc
			Continue:(StepNo="")!(StepDesc="")
			Set ret=ret_StepRowID_":"_StepDesc_","
		}
	}
	Set:(ret'="") ret=$e(ret,1,$l(ret)-1)
	Quit ret
}

/// Creator		: zhaoyu
/// CreateDate	: 2013-11-05
/// Description	: 版本表单展现(帮助文档)
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.OPCPW.FormShowOP","QryStepItem","84||1||1","02")
Query QryStepItem(EpStepID As %String, Flag As %String) As %Query(ROWSPEC = "ItemRowid:%String,ItemDesc:%String,ItemOptional:%String,SubCatDesc:%String")
{
}

ClassMethod QryStepItemExecute(ByRef qHandle As %Binary, EpStepID As %String, Flag As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set CategFlag=$s(Flag="01":"诊疗",Flag="02":"医嘱",Flag="03":"护理",1:"")
	Quit:(CategFlag="") $$$OK
	Set ZIndex=$zn,JIndex=$j
	Kill ^TMP(ZIndex,JIndex,"QryEpStepItems")
	Set CPWID=$p(EpStepID,"||",1),EpID=$p(EpStepID,"||",2),StepID=$p(EpStepID,"||",3)
	Set ItemID=""
	For {
		Set ItemID=$o(^DHCMRC("CPW",CPWID,"EP",EpID,"STEP",StepID,"ITEM",ItemID))
		Quit:(ItemID="")
		Set objItem=##class(web.DHCCPW.MRC.PathWEpStepItem).GetObjById(EpStepID_"||"_ItemID)
		Continue:'$IsObject(objItem)
		Continue:'$IsObject(objItem.CPWSISubCategory)
		Continue:'$IsObject(objItem.CPWSISubCategory.SISCParRef)
		Set CategDesc=objItem.CPWSISubCategory.SISCParRef.SICDesc
		Continue:(CategDesc'[CategFlag)	//按项目大类过滤
		Set CategID=objItem.CPWSISubCategory.SISCParRef.%Id()
		Set SubCatID=objItem.CPWSISubCategory.%Id()
		Set GroupNo=objItem.CPWSIGroupNo
		Set tmpGroupNo=""
		If (GroupNo'="") {
			Set $p(tmpGroupNo,"0",5-$l(GroupNo))=GroupNo
			Set GroupNo=tmpGroupNo
		}
		Continue:(GroupNo="")
		Set ^TMP(ZIndex,JIndex,"QryEpStepItems",CategID,SubCatID,GroupNo,ItemID)=""
	}
	Set CategID=""
	For {
		Set CategID=$o(^TMP(ZIndex,JIndex,"QryEpStepItems",CategID))
		Quit:(CategID="")
		Set SubCatID=""
		For {
			Set SubCatID=$o(^TMP(ZIndex,JIndex,"QryEpStepItems",CategID,SubCatID))
			Quit:(SubCatID="")
			Set objSubCat=##class(web.DHCCPW.MRC.StepItemSubCategory).GetObjById(SubCatID)
			Continue:'$IsObject(objSubCat)
			Set SubCatDesc=objSubCat.SISCDesc
			Continue:(SubCatDesc="")
			Set SubCatPower=objSubCat.SISCPower
			Set GroupNo=""
			For {
				Set GroupNo=$o(^TMP(ZIndex,JIndex,"QryEpStepItems",CategID,SubCatID,GroupNo))
				Quit:(GroupNo="")
				Set ItemID="",ItemIDList="",itemflg=0,tmpIsMust="",tmpArcim=""
				For {
					Set ItemID=$o(^TMP(ZIndex,JIndex,"QryEpStepItems",CategID,SubCatID,GroupNo,ItemID))
					Quit:(ItemID="")
					Set ItemRowid=CPWID_"||"_EpID_"||"_StepID_"||"_ItemID
					Set objItem=##class(web.DHCCPW.MRC.PathWEpStepItem).GetObjById(ItemRowid)
					Continue:'$IsObject(objItem)
					Set ItemDesc=objItem.CPWSIDesc
					Set ItemIsMust=objItem.CPWSIIsMust
					Set:(ItemIsMust["Y") tmpIsMust="Y"
					Set:(ItemIsMust["N") tmpIsMust="N"
					Set ArcimCnt=objItem.CPWSIARCIM.Count()
					Set:(ArcimCnt>0) tmpArcim="Y"
					Set tmpItemID=$o(^TMP(ZIndex,JIndex,"QryEpStepItems",CategID,SubCatID,GroupNo,ItemID))
					Set ItemOptional=0
					Set:(tmpIsMust="Y") ItemOptional=1
					Set:(tmpArcim'="Y")&&(tmpItemID="")&&((SubCatPower="OE")||(SubCatPower="NE")) ItemDesc=ItemDesc
					Continue:(ItemDesc="")
					Set Data=$lb(ItemRowid,ItemDesc,ItemOptional,SubCatDesc)
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
		}
	}
	Kill ^TMP(ZIndex,JIndex,"QryEpStepItems")
	Quit $$$OK
}

ClassMethod QryStepItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryStepItemExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If (ind="") {
		Set AtEnd=1
		Set Row=""
	} Else {
		Set Row=^CacheTemp(repid,ind)
	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QryStepItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryStepItemExecute ]
{
	Set repid=$LIST($g(qHandle),2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 查询临床路径版本 QryCPWVersion
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.OPCPW.FormShowOP","QryCPWVersion","72")
Query QryCPWVersion(CPWDicID As %String) As %Query(ROWSPEC = "CPWID:%String,Desc:%String,ImgPath:%String")
{
}

ClassMethod QryCPWVersionExecute(ByRef qHandle As %Binary, CPWDicID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set objCPWDic=##class(web.DHCCPW.MRC.ClinPathWaysDicSrv).GetObjById(CPWDicID)
	Quit:'$IsObject(objCPWDic) $$$OK
	Set CPWDVersion=objCPWDic.CPWDVersion
	Set Ver=0
	For {
		Set Ver=$o(^DHCMRCi("CPW",0,"IndexClinPathWaysDicVer",CPWDicID,Ver))
		Quit:(Ver="")
		Set CPWID=0
		For {
			Set CPWID=$o(^DHCMRCi("CPW",0,"IndexClinPathWaysDicVer",CPWDicID,Ver,CPWID))
			Quit:(CPWID="")
			Set objVersion=##class(web.DHCCPW.MRC.CliPathWay).GetObjById(CPWID)
			Continue:'$IsObject(objVersion)
			Set Version=objVersion.CPWVersion
			Set Version=+Version
			Set IsActive=objVersion.CPWActive
			Set DateFrom=objVersion.CPWDateFrom
			Set DateTo=objVersion.CPWDateTo
			Set PublicDate=objVersion.CPWVerDate
			Set:PublicDate'="" PublicDate=$zd(PublicDate,3)
			Set PublicTime=objVersion.CPWVerTime
			Set PublicUser=objVersion.CPWVerUserDR
			Continue:IsActive'["Y"
			Continue:(DateFrom'="")&&(DateFrom>+$h)
			Continue:(DateTo'="")&&(DateTo<+$h)
			Set Desc="V"_Version_".0 "_$s(PublicDate'="":PublicDate,1:"未发布")
			Set:(CPWDVersion=CPWID) Desc=Desc_"(正使用)"
			
			Set ImgPath="../images/websys/"_$s(PublicDate="":"edit_orange.gif",1:"edit_green.gif")
			
			Set Data=$lb(CPWID,Desc,ImgPath)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryCPWVersionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCPWVersionExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If (ind="") {
		Set AtEnd=1
		Set Row=""
	} Else {
		Set Row=^CacheTemp(repid,ind)
	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QryCPWVersionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCPWVersionExecute ]
{
	Set repid=$LIST($g(qHandle),2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 按日期查找入径病人(临时)
/// w ##class(web.DHCCPW.OPCPW.InterfaceOP).FindInOPPatByDate("","")
ClassMethod FindInOPPatByDate(StaDate As %String, EndDate As %String) As %String
{
	New (StaDate,EndDate)
	Set:(StaDate["-") StaDate=+$zdh(StaDate,3)
	Set:(EndDate["-") EndDate=+$zdh(EndDate,3)
	Quit:(+StaDate=0)!(+EndDate=0) "err"
	Set Paadm=""
	For {
		Set Paadm=$o(^DHCMRi(0,"IMPLNEW","IndexPaadm",Paadm))
		Quit:(Paadm="")
		Set PatientID=$p($g(^PAADM(+Paadm)),"^",1)
		Set objPatient=##class(DHCMed.Base.Patient).GetObjById(PatientID)
		Set PatName=objPatient.PatientName
		Set CPWID=""
		For {
			Set CPWID=$o(^DHCMRi(0,"IMPLNEW","IndexPaadm",Paadm,CPWID))
			Quit:(CPWID="")
			Set objPathWay=##Class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(CPWID)
			Continue:'$IsObject(objPathWay)
			Continue:'$IsObject(objPathWay.CPWPathwayDR)
			Set PathWayDesc=objPathWay.CPWPathwayDR.CPWDesc
			//Set Loc=objPathWay.CPWInLoc
			//Set:(Loc="") Loc=AdmLoc
			//Set Loc=$p($g(^CTLOC(Loc)),"^",2)
			//Set:($p(Loc,"-",2)'="") Loc=$p(Loc,"-",2)
			Set SubID=""
			For {
				Set SubID=$o(^DHCMRi(0,"IMPLNEW","IndexPaadm",Paadm,CPWID,SubID))
				Quit:(SubID="")
				Set ImplNewID=CPWID_"||"_SubID
				Set objImplNew=##class(web.DHCCPW.OPCPW.InterfaceOP).GetObjByImplNewID(ImplNewID)
				Continue:'$IsObject(objImplNew)
				Set StepDate=objImplNew.CPWENStepStrDate
				Continue:(StepDate<StaDate)!(StepDate>EndDate)
				Set:StepDate'="" StepDate=$zd(+StepDate,3)
				Set EpStepID=objImplNew.CPWENEpStepDR.%Id()
				w ImplNewID_":"_PatName_":"_PathWayDesc_":"_EpStepID_":"_StepDate,!	//_":"_Loc
			}
		}
	}
	Quit " "
}

}
