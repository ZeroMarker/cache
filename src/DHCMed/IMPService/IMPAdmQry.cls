/// 名称：DHCMed.IMPService.IMPAdmQry
/// 描述：按科室取得住院、门诊病人列表
/// 创建者：李阳
/// 创建时间：2010-04-07
Class DHCMed.IMPService.IMPAdmQry Extends (%Persistent, DHCMed.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

ClassMethod Test()
{
	//w ##class(DHCMed.IMPService.IMPAdmQry).Test()
	d ##Class(%ResultSet).RunQuery("DHCMed.IMPService.IMPAdmQry","QueryCurrentInPatient",5)	
	q ""
}

ClassMethod GetData(argPaadm As %String, SubjectID As %String) As %String
{
	New (argPaadm,SubjectID,%ZIndex,%JIndex)
	Set return=""
	Set Paadm=argPaadm
	
	Set $ZT="GetDataErr"
	s objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(Paadm)
	q:$IsObject(objAdm)=0 return
	s objPatient=##class(DHCMed.Base.Patient).GetObjById(objAdm.PatientID)
	q:$IsObject(objPatient)=0 return
	s data=$lb("")
	s $li(data,1)=objAdm.AdmRowID
	s $li(data,2)=objAdm.PatientID
	s $li(data,3)=objPatient.PapmiNo
	s $li(data,4)=objPatient.PatientName
	s $li(data,5)=objPatient.Sex
	s $li(data,6)=objPatient.Age
	s $li(data,7)=objAdm.AdmitDate
	s $li(data,8)=objAdm.Room
	s $li(data,9)=objAdm.Bed
	s $li(data,10)=objAdm.AdmType
	q:objAdm.AdmType'="I" return
	s $li(data,11)=objAdm.Department
	s:$p(objAdm.Department,"-",2)'="" $li(data,11)=$p(objAdm.Department,"-",2)
	s $li(data,12)=objAdm.Ward
	s:$p(objAdm.Ward,"-",2)'="" $li(data,12)=$p(objAdm.Ward,"-",2)
	s $li(data,14)=objAdm.DepartmentID
	s $li(data,15)=objAdm.WardID
	s $li(data,16)=objAdm.DoctorID
	s $li(data,17)=objAdm.DoctorName
	
	// Add By LiYang 2011-12-17监控项目
	set ctlData=##class(DHCMed.CCService.Sys.CtrlProcess).Main(argPaadm)
	set ctlDetail=..BuildCtrlDtl(ctlData)
	s $li(data,18)=$lg(ctlDetail,2)
	;S ^CacheTemp("AAA",objAdm.AdmRowID)=ctlData
	;S ^CacheTemp("AAA",1,objAdm.AdmRowID)=ctlDetail
	
	s tmp=""
	s impRowid="" f  s impRowid=$o(^DHCMed.IMP.ImpPatientI("PaadmIndex",objAdm.AdmRowID,impRowid)) q:impRowid=""  d
	.s flg=##class(DHCMed.IMPService.Interface).GetStatusByIMPID(impRowid)
	.q:flg=""
	.s objImp=##class(DHCMed.IMP.ImpPatient).GetObjById(impRowid)
	.q:$IsObject(objImp)=0
	.s FromDate=objImp.FromDate
	.s:FromDate'="" FromDate=$zd(FromDate,3)
	.s FromTime=objImp.FromTime
	.s:FromTime'="" FromTime=$zt(FromTime,2)
	.s ToDate=objImp.ToDate
	.s:ToDate'="" ToDate=$zd(ToDate,3)
	.s ToTime=objImp.ToTime
	.s:ToTime'="" ToTime=$zt(ToTime,2)
	.s objStatus=##class(DHCMed.SS.Dictionary).%OpenId(objImp.Status)
	.s objSubType=##class(DHCMed.IMP.PatientTypeSub).GetObjById(objImp.ImpType)
	.q:'$IsObject(objSubType)
	.s objType=##class(DHCMed.IMP.PatientType).GetObjById(objSubType.ParentID)
	.s objDutyUser=##class(DHCMed.Base.SSUser).GetObjById(objImp.DutyUser)
	.s DutyLoc=objImp.DutyLoc
	.s DutyLocDesc=""
	.s:DutyLoc'="" DutyLocDesc=$p($g(^CTLOC(DutyLoc)),"^",2)
	.s:$p(DutyLocDesc,"-",2)'="" DutyLocDesc=$p(DutyLocDesc,"-",2)
	.s:$IsObject(objDutyUser) DutyUserName=objDutyUser.Name
	.i objStatus.Code'="0"  d //作废状态不显示了
	..s:tmp'="" tmp=tmp_$c(1)
	..s tmp=tmp_objImp.%Id()_"^"_objType.%Id()_"^"_objSubType.%Id()_"^"_objType.Description_"^"_objSubType.Description_"^"_objImp.Status_"^"_objStatus.Description_"^"_objImp.ResumeText_"^"_objSubType.MarkColor_"^"_objStatus.Code_"^"_$g(DutyUserName)_"^"_FromDate_" "_FromTime_"^"_ToDate_" "_ToTime_"^"_$g(DutyLocDesc)
	..//Add By LiYang 2011-03-05 在重点患者标记界面显示图标
	..i (objStatus.Code=1)!(objStatus.Code=4)  d
	...s tmp=tmp_"^"_$s(objSubType.IconFileName="":objType.IconFileName,1:objSubType.IconFileName) //如果子类型没有图标，就用大类的图标
	..e  d
	...s tmp=tmp_"^"_$s(objSubType.IconFileNameDisable="":objType.IconFileNameDisable,1:objSubType.IconFileNameDisable) //如果子类型没有图标，就用大类的图标
	.d objImp.%Close()
	.d objType.%Close()
	.d objSubType.%Close()
	.d objStatus.%Close()
	.if objDutyUser'="" d objDutyUser.%Close()
	.k objImp
	.k objSubType
	.k objType
	.k objStatus
	.k objDutyUser
	s $li(data,13)=tmp
	d objAdm.%Close()
	d objPatient.%Close()
	k objAdm
	k objPatient
	
	Set return=data
	Quit return
	
GetDataErr
	Quit ""
}

ClassMethod BuildCtrlDtl(argCtrlDtls)
{
	New (argCtrlDtls)
	Set return="",DtlInfo="",ScoreCount=""
	Set $ZT="BuildCtrlDtlErr"
	
	//$lb($lb("病毒性乙型肝炎",5,2,$lb("","病毒性肝炎乙型慢性重度(2008-07-28 09:14)","药物性肝炎(2008-07-28 09:16)"),$lb("")))
	//Set DtlInfo=DtlInfo_"<b style=margin:20px'>触发项目：列出此次就诊触发的项目明细。</b><br>"
	For i=1:1:$listlength(argCtrlDtls)
	{
		Set ctrlDtl=$li(argCtrlDtls,i)
		Set ItemDesc=$li(ctrlDtl,1)
		Set Score=$li(ctrlDtl,2)
		Set Result=$li(ctrlDtl,3)
		Set RstDtls=$li(ctrlDtl,4)
		Set RstErrs=$li(ctrlDtl,5)
		Set ScoreCount=ScoreCount+Score
		Set DtlInfo=DtlInfo_"<b style=margin:40px'>"_"项目"_i_"："_ItemDesc_"  分值："_Score_""_"</b><br>"
		For j=1:1:$listlength(RstDtls)
		{
			Set RstDtl=$li(RstDtls,j)
			Continue:RstDtl=""
			Set DtlInfo=DtlInfo_"<a style=margin:80px'>"_"Value："_RstDtl_"</a><br>"
		}
		For j=1:1:$listlength(RstErrs)
		{
			Set RstErr=$li(RstErrs,j)
			Continue:RstErr=""
			Set DtlInfo=DtlInfo_"<a style=margin:80px'>"_"Error："_RstErr_"</a><br>"
		}
	}
	Set return=$lb(ScoreCount,DtlInfo)
	Quit return
BuildCtrlDtlErr
	Set DtlInfo="<b style=margin:20px'>Error: "_$ZERROR_"</b><br>"
	Set return=$lb(-999,DtlInfo)
	Quit return
}

/// 查询当前在院病人
/// d ##Class(%ResultSet).RunQuery("DHCMed.IMPService.IMPAdmQry","QueryCurrentInPatient","","0000000089","2")
Query QueryCurrentInPatient(WardID As %String, RegNo As %String, SubjectID As %String) As %Query(ROWSPEC = "Paadm:%String,PatientID:%String,RegNo:%String:登记号,PatientName:%String:患者姓名,Sex:%String:性别,Age:%String:年龄,AdmitDate:%String:住院日期,Room:%String:病室,Bed:%String:病床,AdmType:%String:就诊类型,LocDesc:%String:科室,WardDesc:%String:病区,PatTypes:%String:归类,LocID:%String:科室ID,WardID:%String:病区ID,DoctorID:%String:医生ID,DoctorName:%String:主管医生,CtrlDtl:%String")
{
}

ClassMethod QueryCurrentInPatientExecute(ByRef qHandle As %Binary, WardID As %String, RegNo As %String, SubjectID As %String) As %Status
{
   Set flg=##Class(DHCMed.IMPService.Interface).SyncDataCRToIMP("","")
   Quit:flg<0 $$$OK        //同步数据错误
   
   Set %ZIndex=$zn,%JIndex=$j
   Kill ^TMP(%ZIndex,%JIndex,"DHCMedCCExpList")
   Set flg=##class(DHCMed.CCService.Sys.CtrlProcess).GetDHCMedCCExpList(SubjectID,"")
   Quit:flg<1 $$$OK
   
   Set repid=$I(^CacheTemp)
   Set ind=1
   Set qHandle=$lb(0,repid,0)
   
   If RegNo'="" {
	   Set RegNo=##Class(DHCMed.Base.CommFunSrv).RegNoCon(RegNo)
	   Set Papmi=$o(^PAPERi("PAPMI_PatNo",RegNo,0))
	   Quit:Papmi="" $$$OK
	   Set AdmType=""
	   For {
		   Set AdmType=$o(^PAPERdr(Papmi,"ADM",AdmType))
		   Quit:AdmType=""
		   Continue:AdmType'="I"
		   Set Paadm=0
		   For {
			   Set Paadm=$o(^PAPERdr(Papmi,"ADM",AdmType,Paadm))
			   Quit:Paadm=""
			   Set Data=..GetData(Paadm,SubjectID) //Add By LiYang 2011-12-17增加监控项目
			   Continue:Data=""
			   Set ^CacheTemp(repid,ind)=Data
			   Set ind=ind+1
		   }
	   }
   } Else {
		Quit:'$d(^PAADMi("CurrWard",+WardID)) $$$OK
		Set Room=""
		For {
			Set Room=$o(^PAADMi("CurrWard",+WardID,Room))
			Quit:Room=""
			Set Paadm=""
			For {
				Set Paadm=$o(^PAADMi("CurrWard",+WardID,Room,Paadm))
				Quit:Paadm=""
				Set Data=..GetData(Paadm,SubjectID)
				Continue:Data=""
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
   }
   Kill ^TMP(%ZIndex,%JIndex,"DHCMedCCExpList")
   
   Quit $$$OK
}

ClassMethod QueryCurrentInPatientClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryCurrentInPatientExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryCurrentInPatientFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryCurrentInPatientExecute ]
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

/// 通过病人的登记号获取病人就诊列表
Query QueryAdmByPatientID(PatientRegNo As %String, AdmType As %String) As %Query(ROWSPEC = "Paadm:%String,PatientID:%String,RegNo:%String:登记号,PatientName:%String:患者姓名,Sex:%String:性别,Age:%String:年龄,AdmitDate:%String:住院日期,Room:%String:病室,Bed:%String:病床,AdmType:%String:就诊类型,Department:%String:科室,Ward:%String:病区,PatTypes:%String:归类")
{
}

ClassMethod QueryAdmByPatientIDExecute(ByRef qHandle As %Binary, PatientRegNo As %String, AdmType As %String) As %Status
{
   Set repid=$I(^CacheTemp)
   Set ind=1
   Set qHandle=$lb(0,repid,0)
   
   s objPatient=##class(DHCMed.Base.Patient).GetPatientByRegNo(PatientRegNo)
   q:$IsObject(objPatient)=0 $$$OK
   
   //^PAPERdr({PAADM_PAPMI_DR},"ADM",{PAADM_Type},{PAADM_RowID})
   s AdmType="" f  s AdmType=$o(^PAPERdr(objPatient.Papmi,"ADM",AdmType)) q:AdmType=""  d
   .s paadm="" f  s paadm=$o(^PAPERdr(objPatient.Papmi,"ADM",AdmType,paadm)) q:paadm=""  d
   ..s objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(paadm)
   ..q:$IsObject(objAdm)=0
   ..s objPatient=##class(DHCMed.Base.Patient).GetObjById(objAdm.PatientID)
   ..q:$IsObject(objPatient)=0
   ..s data=$lb("")
   ..s $li(data,1)=objAdm.AdmRowID
   ..s $li(data,2)=objAdm.PatientID
   ..s $li(data,3)=objPatient.PapmiNo
   ..s $li(data,4)=objPatient.PatientName
   ..s $li(data,5)=objPatient.Sex
   ..s $li(data,6)=objPatient.Age
   ..s $li(data,7)=objAdm.AdmitDate
   ..s $li(data,8)=objAdm.Room
   ..s $li(data,9)=objAdm.Bed
   ..s $li(data,10)=objAdm.AdmType
   ..s $li(data,11)=objAdm.Department
   ..s $li(data,12)=objAdm.Ward
   ..s:objAdm.AdmType="I" $li(data,10)="住院"
   ..s:objAdm.AdmType="O" $li(data,10)="门诊"
   ..s:objAdm.AdmType="E" $li(data,10)="急诊"
   ..s:objAdm.AdmType="H" $li(data,10)="体检"
   ..
   ..//增加归类
   ..s tmp=""
   ..s impRowid="" f  s impRowid=$o(^DHCMed.IMP.ImpPatientI("PaadmIndex",objAdm.AdmRowID,impRowid)) q:impRowid=""  d
   ...s objImp=##class(DHCMed.IMP.ImpPatient).GetObjById(impRowid)
   ...q:'$IsObject(objImp)
   ...s FromDate=objImp.FromDate
   ...s:FromDate'="" FromDate=$zd(FromDate,3)
   ...s FromTime=objImp.FromTime
   ...s:FromTime'="" FromTime=$zt(FromTime,2)
   ...s ToDate=objImp.ToDate
   ...s:ToDate'="" ToDate=$zd(ToDate,3)
   ...s ToTime=objImp.ToTime
   ...s:ToTime'="" ToTime=$zt(ToTime,2)
   ...s objStatus=##class(DHCMed.SS.Dictionary).%OpenId(objImp.Status)
   ...s objSubType=##class(DHCMed.IMP.PatientTypeSub).GetObjById(objImp.ImpType)
   ...s objType=##class(DHCMed.IMP.PatientType).GetObjById(objSubType.ParentID)
   ...s objDutyUser=##class(DHCMed.Base.SSUser).GetObjById(objImp.DutyUser)
   ...s:$IsObject(objDutyUser) DutyUserName=objDutyUser.Name
   ...i objStatus.Code'="0"  d //作废状态不显示了
   ....s:tmp'="" tmp=tmp_$c(1)
   ....s tmp=tmp_objImp.%Id()_"^"_objType.%Id()_"^"_objSubType.%Id()_"^"_objType.Description_"^"_objSubType.Description_"^"_objImp.Status_"^"_objStatus.Description_"^"_objImp.ResumeText_"^"_objSubType.MarkColor_"^"_objStatus.Code_"^"_$g(DutyUserName)_"^"_FromDate_" "_FromTime_"^"_ToDate_" "_ToTime
   ...i objImp'="" d objImp.%Close()
   ...i objType'="" d objType.%Close()
   ...i objSubType'="" d objSubType.%Close()
   ...i objStatus'="" d objStatus.%Close()
   ...i objDutyUser'="" d objDutyUser.%Close()
   ...k objImp
   ...k objSubType
   ...k objType
   ...k objStatus
   ...k objDutyUser
   ..s $li(data,13)=tmp
   ..
   ..d objAdm.%Close()
   ..k objAdm
   ..s ^CacheTemp(repid,ind)=data
   ..s ind=ind+1
   d objPatient.%Close()
   k objPatient
   Quit $$$OK
}

ClassMethod QueryAdmByPatientIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAdmByPatientIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryAdmByPatientIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAdmByPatientIDExecute ]
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
