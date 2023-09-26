/// 名称：DHCMed.IMPService.IMPQuery
/// 描述：重点病人上报查询
/// 创建者：李阳
/// 创建日期：2010-4-23
Class DHCMed.IMPService.IMPQuery Extends (%Persistent, DHCMed.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod BuildData(objPatient, objAdm, objIMP, SubjectID)
{
	n (objPatient,objAdm,objIMP,SubjectID,%ZIndex,%JIndex)
	//ImpID:%String,PatientID:%String,Paadm:%String,PatientNo:%String:登记号,
	//InPatientMrNo:%String:住院号,PatientName:%String:患者姓名,Sex:%String:性别,Age:%String:年龄,AdmitDate:%String:就诊日期,
	//DisDate:%String:出院日期,Loc:%String:科室,Ward:%String:病房,Bed:%String:病床,
	//PatType:%String:大类,PatSubType:%String:小类,Status:%String:当前状态,PatTypeID:%String,
	//PatSubTypeID:%String,UpdateUser:%String:上报人,UpdateDate:%String:上报日期,UpdateTime:%String:上报时间
	s objStatus=##class(DHCMed.SS.Dictionary).%OpenId(objIMP.Status)
	q:objStatus.Code="0" ""
	s objSubType=##class(DHCMed.IMP.PatientTypeSub).%OpenId(objIMP.ImpType)
	s objType=##class(DHCMed.IMP.PatientType).%OpenId(objSubType.ParentID)
	s objUpdateUser=##class(DHCMed.Base.SSUser).GetObjById(objIMP.UpdateUser)
	s data=$lb("")
	s $li(data,1)=objIMP.%Id() //ImpID:%String
	s $li(data,2)=objPatient.Papmi //PatientID:%String
	s $li(data,3)=objAdm.AdmRowID //Paadm:%String
	s $li(data,4)=objPatient.PapmiNo //PatientNo:%String:登记号
	s $li(data,5)=objPatient.InPatientMrNo //PatientNo:%String:登记号
	s $li(data,6)=objPatient.PatientName //PatientName:%String:患者姓名
	s $li(data,7)=objPatient.Sex //Sex:%String:性别
	s $li(data,8)=objPatient.Age //Age:%String:年龄
	s $li(data,9)=objAdm.AdmitDate //AdmitDate:%String:就诊日期
	s $li(data,10)=objAdm.DisDate //DisDate:%String:出院日期
	s $li(data,11)=objAdm.Department //Loc:%String:科室
	s:$p(objAdm.Department,"-",2)'="" $li(data,11)=$p(objAdm.Department,"-",2)
	s $li(data,12)=objAdm.Ward //Ward:%String:病房
	s:$p(objAdm.Ward,"-",2)'="" $li(data,12)=$p(objAdm.Ward,"-",2)
	s $li(data,13)=objAdm.Bed //Bed:%String:病床
	s $li(data,14)=objType.Description //PatType:%String:大类
	s $li(data,15)=objSubType.Description //PatSubType:%String:小类
	s $li(data,16)=objStatus.Description //Status:%String:当前状态
	s $li(data,17)=objType.%Id() //PatTypeID:%String
	s $li(data,18)=objSubType.%Id() //PatSubTypeID:%String
	s $li(data,19)=$s($IsObject(objUpdateUser):objUpdateUser.Name,1:"") //,UpdateUser:%String:上报人
	s $li(data,20)=$s(objIMP.UpdateDate'="":$zd(objIMP.UpdateDate,3),1:"") //UpdateDate:%String:上报日期,
	s $li(data,21)=$s(objIMP.UpdateTime'="":$zt(objIMP.UpdateTime,1),1:"") //UpdateTime:%String:上报时间,
	s $li(data,22)=objStatus.Code //状态ID
	s $li(data,23)=objAdm.DepartmentID //LocID
	s $li(data,24)=objAdm.WardID       //WardID
	s DoctorID=objIMP.DutyUser
	s $li(data,25)=DoctorID            //DoctorID 责任人
	s:DoctorID'="" DoctorName=$p($g(^SSU("SSUSR",DoctorID)),"^",2)
	s $li(data,26)=$g(DoctorName)      //DoctorName 责任医生
	s DutyLocID=objIMP.DutyLoc
	s $li(data,27)=DutyLocID           //DutyLocID
	s:DutyLocID'="" DutyLocDesc=$p($g(^CTLOC(DutyLocID)),"^",2)
	s:$p($g(DutyLocDesc),"-",2)'="" DutyLocDesc=$p(DutyLocDesc,"-",2)
	s $li(data,28)=$g(DutyLocDesc)     //DutyLocDesc
	
	Set Prognosis=objIMP.Prognosis
	If Prognosis'=""
	{
		Set objPrognosis=##class(DHCMed.SS.Dictionary).%OpenId(Prognosis)
		If $IsObject(objPrognosis)
		{
			Set PrognosisDesc=objPrognosis.Description
		}
		If objPrognosis'="" Do objPrognosis.%Close()
	}
	Set $li(data,29)=$g(PrognosisDesc)     //转归
	
	//add by liuyh 2010-10-08 for 增加诊断信息列
	s DiagInfo=""
	s MrDiagnoseInfo=##class(DHCMed.Base.MRDiagnose).GetByPaadm(objAdm.AdmRowID)
	f i=1:1:$l(MrDiagnoseInfo,$c(1)) d
	.q:$p(MrDiagnoseInfo,$c(1),i)=""
	.q:$p($p($g(MrDiagnoseInfo),$c(1),i),"^",14)=""
	.s:DiagInfo'="" DiagInfo=DiagInfo_"  "_i_": "_$p($p($g(MrDiagnoseInfo),$c(1),i),"^",14) 
	.s:((DiagInfo="")&(i=1)) DiagInfo=$p($p($g(MrDiagnoseInfo),$c(1),i),"^",14) 
	Set $li(data,30)=DiagInfo

	// Add By LiYang 2011-12-17监控项目
	set ctlData=##class(DHCMed.CCService.Sys.CtrlProcess).Main(objAdm.AdmRowID)
	set ctlDetail=..BuildCtrlDtl(ctlData)
	s $li(data,31)=$lg(ctlDetail,2)
	
	d:$IsObject(objStatus) objStatus.%Close()
	d:$IsObject(objSubType) objSubType.%Close()
	d:$IsObject(objType) objType.%Close()
	d:$IsObject(objUpdateUser) objUpdateUser.%Close()
	k objStatus
	k objSubType
	k objType
	k objUpdateUser
	k objCheckUser
	q data
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

/// 查询重点病人记录
/// d ##Class(%ResultSet).RunQuery("DHCMed.IMPService.IMPQuery","QueryImp",1,"","00336448","","","","","","","","")
Query QueryImp(QueryType As %String, DutyUser As %String, PatientNo As %String, PatientName As %String, FromDate As %String, ToDate As %String, Status As %String, Loc As %String, TypeID As %String = "", SubTypeID As %String = "", IsActive As %String) As %Query(ROWSPEC = "ImpID:%String,PatientID:%String,Paadm:%String,PatientNo:%String:登记号,InPatientMrNo:%String:住院号,PatientName:%String:患者姓名,Sex:%String:性别,Age:%String:年龄,AdmitDate:%String:就诊日期,DisDate:%String:出院日期,Loc:%String:科室,Ward:%String:病房,Bed:%String:病床,PatType:%String:大类,PatSubType:%String:小类,Status:%String:当前状态,PatTypeID:%String,PatSubTypeID:%String,UpdateUser:%String:上报人,UpdateDate:%String:上报日期,UpdateTime:%String:上报时间,StatusCode:%String,LocID:%String,WardID:%String,DoctorID:%String,DoctorName:%String:责任人,DutyLocID:%String,DutyLocDesc:%String:责任科室,Prognosis:%String:转归,DiagInfo:%String:诊断信息,CtrlDtl")
{
}

ClassMethod QueryImpExecute(ByRef qHandle As %Binary, QueryType As %String, DutyUser As %String, PatientNo As %String, PatientName As %String, FromDate As %String, ToDate As %String, Status As %String, Loc As %String, TypeID As %String = "", SubTypeID As %String = "", IsActive As %String) As %Status
{
	Set flg=##Class(DHCMed.IMPService.Interface).SyncDataCRToIMP("","")
	Quit:flg<0 $$$OK        //同步数据错误
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	set SubjectID=0
	set objSubject=##class(DHCMed.CC.Subject).GetObjByCode("ImpCC")
	do:$IsObject(objSubject)=1 objSubject.%Close()
	Set:$IsObject(objSubject) SubjectID=objSubject.%Id()
	
	//Modified By LiYang 2012-07-04
	Set %ZIndex=$zn,%JIndex=$j
	Set ret=##class(DHCMed.CCService.Sys.CtrlProcess).GetDHCMedCCExpList(SubjectID,"")
	
	i QueryType=1  d  //按登记号查找
	.s PatientNo=##Class(DHCMed.Base.CommFunSrv).RegNoCon(PatientNo)
	.s objPatient=##class(DHCMed.Base.Patient).GetPatientByRegNo(PatientNo)	
	.i $IsObject(objPatient)  d
	..s rowid="" f  s rowid=$o(^DHCMed.IMP.ImpPatientI("PatientIDIndex",objPatient.Papmi,rowid)) q:rowid=""  d
	...//同步临床路径与重点患者状态数据
	...s flg=##class(DHCMed.IMPService.Interface).GetStatusByIMPID(rowid)
	...q:flg=""
	...s objIMP=##class(DHCMed.IMP.ImpPatient).%OpenId(rowid)
	...q:$IsObject(objIMP)=0
	...s objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(objIMP.Paadm)
	...q:$IsObject(objAdm)=0
	...q:((IsActive'="true")&(objAdm.DisDate'=""))
	...s data=..BuildData(objPatient,objAdm,objIMP,SubjectID)
	...q:data=""
	...d objIMP.%Close()
	...d objAdm.%Close()
	...k objAdm,objIMP
	...s ^CacheTemp(repid,ind)=data
	...s ind=ind+1
	..d objPatient.%Close()
	..k objPatient
	
	i QueryType=2  d //按患者姓名查找
	.s myName=" "_PatientName
	.s rule=myName
	.s myName=$o(^DHCMed.IMP.ImpPatientI("SummaryInfoIndex",myName),-1)
	.f  s myName=$o(^DHCMed.IMP.ImpPatientI("SummaryInfoIndex",myName)) q:((myName="")!(myName'[rule))  d
	..s rowid="" f  s rowid=$o(^DHCMed.IMP.ImpPatientI("SummaryInfoIndex",myName,rowid)) q:rowid=""  d
	...//同步临床路径与重点患者状态数据
	...s flg=##class(DHCMed.IMPService.Interface).GetStatusByIMPID(rowid)
	...q:flg=""
	...s objIMP=##class(DHCMed.IMP.ImpPatient).%OpenId(rowid)
	...q:$IsObject(objIMP)=0
	...s objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(objIMP.Paadm)
	...q:$IsObject(objAdm)=0
	...s objPatient=##class(DHCMed.Base.Patient).GetObjById(objIMP.PatientID)
	...q:$IsObject(objPatient)=0
	...q:((IsActive'="true")&(objAdm.DisDate'=""))
	...s data=..BuildData(objPatient,objAdm,objIMP,SubjectID)
	...q:data=""
	...d objIMP.%Close()
	...d objAdm.%Close()
	...d objPatient.%Close()
	...k objPatient,objAdm,objIMP
	...s ^CacheTemp(repid,ind)=data
	...s ind=ind+1
	
	i QueryType=3  d //按日期查找
	.s:FromDate["-" FromDate=$zdh(FromDate,3)
	.s:ToDate["-" ToDate=$zdh(ToDate,3)
	.f tmpDate=FromDate:1:ToDate  d
	..s rowid="" f  s rowid=$o(^DHCMed.IMP.ImpPatientI("FromDateIndex",tmpDate,rowid)) q:rowid=""   d
	...//同步临床路径与重点患者状态数据
	...s flg=##class(DHCMed.IMPService.Interface).GetStatusByIMPID(rowid)
	...q:flg=""
	...s objIMP=##class(DHCMed.IMP.ImpPatient).%OpenId(rowid)
	...q:$IsObject(objIMP)=0
	...q:(objIMP.ImpType'=SubTypeID)&&(SubTypeID'="") //子类型不符合
	...s objSubType=##class(DHCMed.IMP.PatientTypeSub).%OpenId(objIMP.ImpType)
	...d objSubType.%Close()
	...q:(objSubType.ParentID'=TypeID)&&(TypeID'="") //大类不符合
	...k objSubType
	...q:((objIMP.Status'=Status)&&(Status'=""))
	...s objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(objIMP.Paadm)
	...q:$IsObject(objAdm)=0
	...q:((objAdm.DepartmentID'=Loc)&&(Loc'=""))
	...s objPatient=##class(DHCMed.Base.Patient).GetObjById(objIMP.PatientID)
	...q:$IsObject(objPatient)=0
	...q:((IsActive'="true")&(objAdm.DisDate'=""))
	...s data=..BuildData(objPatient,objAdm,objIMP,SubjectID)
	...q:data=""
	...d objIMP.%Close()
	...d objAdm.%Close()
	...d objPatient.%Close()
	...k objPatient,objAdm,objIMP
	...s ^CacheTemp(repid,ind)=data
	...s ind=ind+1	
	
	i QueryType=4  d //按负责人查找
	.;w "DutyUser:"_DutyUser,!
	.s statusID="" f  s statusID=$o(^DHCMed.IMP.ImpPatientI("DutyUserIndex",DutyUser,statusID)) quit:statusID=""  d
	..s rowid="" f  s rowid=$o(^DHCMed.IMP.ImpPatientI("DutyUserIndex",DutyUser,statusID,rowid)) q:rowid=""   d
	...//同步临床路径与重点患者状态数据
	...s flg=##class(DHCMed.IMPService.Interface).GetStatusByIMPID(rowid)
	...q:flg=""
	...;w rowid,!
	...s objIMP=##class(DHCMed.IMP.ImpPatient).%OpenId(rowid)
	...q:$IsObject(objIMP)=0
	...q:((objIMP.Status'=Status)&&(Status'=""))
	...s objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(objIMP.Paadm)
	...q:$IsObject(objAdm)=0
	...q:((objAdm.DepartmentID'=Loc)&&(Loc'=""))	
	...s objPatient=##class(DHCMed.Base.Patient).GetObjById(objIMP.PatientID)
	...q:$IsObject(objPatient)=0
	....q:((IsActive'="true")&(objAdm.DisDate'=""))
	...s data=..BuildData(objPatient,objAdm,objIMP,SubjectID)
	...q:data=""
	...d objIMP.%Close()
	...d objAdm.%Close()
	...d objPatient.%Close()
	...k objPatient,objAdm,objIMP
	...s ^CacheTemp(repid,ind)=data
	...s ind=ind+1
	
	
	//删除监控结果数据
	Kill ^TMP(%ZIndex,%JIndex,"DHCMedCCExpList")
	
	Quit $$$OK
}

ClassMethod QueryImpClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryImpExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryImpFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryImpExecute ]
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
/// CreatDate：   2010-08-25
/// Description:  按统计科室转归重点患者数量
/// d ##Class(%ResultSet).RunQuery("DHCMed.IMPService.IMPQuery","QueryPrognosis","2010-08-01","2010-08-25","","")
Query QueryPrognosis(argFromDate As %String, argToDate As %String, argTypeID As %String, argTypeSubID As %String) As %Query(ROWSPEC = "Index:%String,LocDesc:%String:科室,TypeDesc:%String:大类,TypeSubDesc:%String:子类,CountZS:%String:总人数,CountCY:%String:出院人数,CountHZ:%String:好转人数,CountSW:%String:死亡人数,CountJZ:%String:加重人数,CountZK:%String:转科人数")
{
}

ClassMethod QueryPrognosisExecute(ByRef qHandle As %Binary, argFromDate As %String, argToDate As %String, argTypeID As %String, argTypeSubID As %String) As %Status
{
	Set flg=##Class(DHCMed.IMPService.Interface).SyncDataCRToIMP("","")
	Quit:flg<0 $$$OK        //同步数据错误
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set:argFromDate["-" argFromDate=$zdh(argFromDate,3)
	Set:argFromDate["/" argFromDate=$zdh(argFromDate,4)
	Set:argFromDate'="" argFromDate=+argFromDate
	Set:argToDate["-" argToDate=$zdh(argToDate,3)
	Set:argToDate["/" argToDate=$zdh(argToDate,4)
	Set:argToDate'="" argToDate=+argToDate
	Quit:(argFromDate="")||(argToDate="") $$$OK
	
	Kill ^TMP("QueryPrognosis",$zn,$j)
	Set tmpDate=argFromDate-1
	For {
		Set tmpDate=$o(^DHCMed.IMP.ImpPatientI("FromDateIndex",tmpDate))
		Quit:(tmpDate="")||(tmpDate>argToDate)
		Set IMPID=0
		For {
			Set IMPID=$o(^DHCMed.IMP.ImpPatientI("FromDateIndex",tmpDate,IMPID))
			Quit:IMPID=""
			
			//同步临床路径与重点患者状态数据
			Set flg=##class(DHCMed.IMPService.Interface).GetStatusByIMPID(IMPID)
			Continue:flg=""
			
			Set objIMP=##Class(DHCMed.IMP.ImpPatient).%OpenId(IMPID)
			If $IsObject(objIMP) {
				Set Status=objIMP.Status,StatusCode="",StatusDesc=""
				If Status'="" {
					Set objStatus=##class(DHCMed.SS.Dictionary).%OpenId(Status)
					If $IsObject(objStatus) {
						Set StatusCode=objStatus.Code
						Set StatusDesc=objStatus.Description
					}
					If objStatus'="" Do objStatus.%Close()
				}
				Continue:(StatusCode'="1")&&(StatusCode'="2")
				
				Set Prognosis=objIMP.Prognosis,PrognosisDesc=""
				
				Set DutyLoc=objIMP.DutyLoc
				Continue:DutyLoc=""
				
				Set IMPTypeSub=objIMP.ImpType,IMPType=""
				Set objTypeSub=##Class(DHCMed.IMP.PatientTypeSub).%OpenId(IMPTypeSub)
				If $IsObject(objTypeSub) {
					Set IMPType=objTypeSub.ParentID
				}
				If objTypeSub'="" Do objTypeSub.%Close()
				Continue:(IMPType="")||(IMPTypeSub="")
				Continue:(argTypeID'="")&&(argTypeID'=IMPType)
				Continue:(argTypeSubID'="")&&(argTypeSubID'=IMPTypeSub)
				
				Set Count=$i(^TMP("QueryPrognosis",$zn,$j,DutyLoc,IMPType,IMPTypeSub))
				Set:Prognosis'="" Count=$i(^TMP("QueryPrognosis",$zn,$j,DutyLoc,IMPType,IMPTypeSub,Prognosis))
			}
		}
	}
	
	Set DutyLoc=""
	For {
		Set DutyLoc=$o(^TMP("QueryPrognosis",$zn,$j,DutyLoc))
		Quit:DutyLoc=""
		Set DutyLocDesc=$p($g(^CTLOC(+DutyLoc)),"^",2)
		Set:$p(DutyLocDesc,"-",2)'="" DutyLocDesc=$p(DutyLocDesc,"-",2)
		
		Set IMPType=""
		For {
			Set IMPType=$o(^TMP("QueryPrognosis",$zn,$j,DutyLoc,IMPType))
			Quit:IMPType=""
			Set objType=##Class(DHCMed.IMP.PatientType).%OpenId(IMPType)
			If $IsObject(objType){
				Set IMPTypeDesc=objType.Description
			}
			If objType'="" Do objType.%Close()
			
			Set (CountZS1,CountCY1,CountHZ1,CountSW1,CountZK1,CountJZ1)=0
			Set IMPTypeSub=""
			For {
				Set IMPTypeSub=$o(^TMP("QueryPrognosis",$zn,$j,DutyLoc,IMPType,IMPTypeSub))
				Quit:IMPTypeSub=""
				Set objTypeSub=##Class(DHCMed.IMP.PatientTypeSub).%OpenId(IMPTypeSub)
				If $IsObject(objTypeSub) {
					Set IMPTypeSubDesc=objTypeSub.Description
				}
				If objTypeSub'="" Do objTypeSub.%Close()
				
				Set (CountZS,CountCY,CountHZ,CountSW,CountZK,CountJZ)=0
				Set CountZS=+$g(^TMP("QueryPrognosis",$zn,$j,DutyLoc,IMPType,IMPTypeSub))
				Set Prognosis=""
				For {
					Set Prognosis=$o(^TMP("QueryPrognosis",$zn,$j,DutyLoc,IMPType,IMPTypeSub,Prognosis))
					Quit:Prognosis=""
					Set objPrognosis=##class(DHCMed.SS.Dictionary).%OpenId(Prognosis)
					If $IsObject(objPrognosis) {
						Set PrognosisDesc=objPrognosis.Description
					}
					If objPrognosis'="" Do objPrognosis.%Close()
					Set:PrognosisDesc="出院" CountCY=+$g(^TMP("QueryPrognosis",$zn,$j,DutyLoc,IMPType,IMPTypeSub,Prognosis))
					Set:PrognosisDesc="好转" CountHZ=+$g(^TMP("QueryPrognosis",$zn,$j,DutyLoc,IMPType,IMPTypeSub,Prognosis))
					Set:PrognosisDesc="死亡" CountSW=+$g(^TMP("QueryPrognosis",$zn,$j,DutyLoc,IMPType,IMPTypeSub,Prognosis))
					Set:PrognosisDesc="转科" CountZK=+$g(^TMP("QueryPrognosis",$zn,$j,DutyLoc,IMPType,IMPTypeSub,Prognosis))
					Set:PrognosisDesc="加重" CountJZ=+$g(^TMP("QueryPrognosis",$zn,$j,DutyLoc,IMPType,IMPTypeSub,Prognosis))
				}
				
				Set CountZS1=CountZS1+CountZS
				Set CountCY1=CountCY1+CountCY
				Set CountHZ1=CountHZ1+CountHZ
				Set CountSW1=CountSW1+CountSW
				Set CountZK1=CountZK1+CountZK
				Set CountJZ1=CountJZ1+CountJZ
				
				Set Data=$lb(ind,DutyLocDesc,IMPTypeDesc,IMPTypeSubDesc,CountZS,CountCY,CountHZ,CountSW,CountJZ,CountZK)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
			
			Set Data=$lb(ind,DutyLocDesc,IMPTypeDesc,"合计",CountZS1,CountCY1,CountHZ1,CountSW1,CountJZ1,CountZK1)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Kill ^TMP("QueryPrognosis",$zn,$j)
	
	Quit $$$OK
}

ClassMethod QueryPrognosisClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryPrognosisExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryPrognosisFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPrognosisExecute ]
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

/// Creator：    liuyh
/// CreatDate：  2010-10-08
/// Description：重点患者报告打印列表数据
/// Query：      QueryImp
/// Input：      itmjs：js处理返回值函数
/// 			 strArguments：Query入参，"^"分隔
/// Return：     返回值交由js中itmjs方法处理
/// Debug:       w ##Class(DHCMed.IMPService.IMPQuery).QueryRepToPrint(itmjs,strArguments)
ClassMethod QueryRepToPrint(itmjs As %Library.String = "", strArguments As %String) As %Status
{
	n (itmjs,strArguments)
	s Count=0
	s QueryType=$p(strArguments,"^",1)
	s UserID=$p(strArguments,"^",2)
	s txtRegNo=$p(strArguments,"^",3)
	s txtPatientName=$p(strArguments,"^",4)
    s dtFrom=$p(strArguments,"^",5)
    s dtTo=$p(strArguments,"^",6)
	s cboStatus=$p(strArguments,"^",7)
	s cboDep=$p(strArguments,"^",8)
	s cboPatType=$p(strArguments,"^",9)
    s cboPatSubType=$p(strArguments,"^",10)
    s IsActive=$p(strArguments,"^",11)
	s ds = ##class(%Library.ResultSet).%New("DHCMed.IMPService.IMPQuery.QueryImp")
	d ds.Execute(QueryType,UserID,txtRegNo,txtPatientName,dtFrom,dtTo,cboStatus,cboDep,cboPatType,cboPatSubType,IsActive)
	s StartRow=4
	while(ds.Next())
	{
		s PatientNo=ds.Data("PatientNo")				        //登记号
		s PatientName=ds.Data("PatientName") 	                //姓名
		s Loc=ds.Data("Loc") 		        					//科室
		s Ward=ds.Data("Ward")	                    			//病区
		s PatType=ds.Data("PatType")		            		//大类
		s PatSubType=ds.Data("PatSubType")			    		//子类
		s Status=ds.Data("Status")								//状态
		s Prognosis=ds.Data("Prognosis")						//转归

		s valCells=PatientNo_$c(1)_PatientName_$c(1)_Loc_$c(1)_Ward_$c(1)_PatType_$c(1)_PatSubType_$c(1)_Status_$c(1)_Prognosis
	 	s retval=itmjs_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',"_StartRow_",1);"
		&javascript<#(retval)#>
		s Count=Count+1
		s StartRow=StartRow+1
	}
	d ds.Close()
	q Count
}

}
