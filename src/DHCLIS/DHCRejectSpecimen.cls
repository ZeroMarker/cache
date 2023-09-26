Class DHCLIS.DHCRejectSpecimen Extends %RegisteredObject
{

/// Creator：      liuzf
/// CreatDate：    20160130
/// Description:： 查询拒收信息
/// Table：        
/// Input：        
/// Output：       
/// Return：       
/// Others：
/// d ##Class(%ResultSet).RunQuery("DHCLIS.DHCRejectSpecimen","QryRejectSpec","300","","","","","","","","","","14","","","","123^15^^12^1")
Query QryRejectSpec(EpisodeID, fIsFinish, FromDate, ToDate, fWardID, RegNo, fLocationDR, VisitNumberRejectSpecDR, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %Query(ROWSPEC = "RegNo,SurName,Doctor,Location,Ward,Labno,TestSetDesc,SpecimenDesc,RejectDR,VisitNumberDR,CreateDate,CreateTime,CreateUser,RejectNotes,RejectType,NoticePatient,NoticePhone,NoticeNotes,OperateDate,OperateTime,OperateUser,OperateNotes,IsFinish,AdmNo")
{
}

ClassMethod QryRejectSpecExecute(ByRef qHandle As %Binary, EpisodeID, fIsFinish, FromDate, ToDate, fWardID, RegNo, fLocationDR, VisitNumberRejectSpecDR, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	s ^TMP("QryRejectSpec")=$LB(EpisodeID, fIsFinish, FromDate, ToDate, fWardID, RegNo, P6, P7, P8, P9, P10, P11, P12, P13, Sessions)
	i $l(FromDate) s FromDate=$tr(FromDate,"-")
	i $l(ToDate) S ToDate=$tr(ToDate,"-")
	i '$l(ToDate) s ToDate=$tr($zd(+$h,3),"-")
		
	s tFind=0
 	i $l(EpisodeID),tFind=0 d  ///就诊号查询
	.s tFind=1
    .s VisitNumberDR="" f  s VisitNumberDR=$o(^dbo.RPVisitNumberRejectSpecI("IndexAdmNo",##Class(LIS.Util.Common).IndexData(EpisodeID),VisitNumberDR)) q:VisitNumberDR=""  d
    ..s VisRejectDR="" f  s VisRejectDR=$o(^dbo.RPVisitNumberRejectSpecI("IndexAdmNo",##Class(LIS.Util.Common).IndexData(EpisodeID),VisitNumberDR,VisRejectDR)) q:VisRejectDR=""  d
	...d GetData

	i $l(RegNo),tFind=0 d ///登记号查询
	.s tFind=1
	.s RequestDate="" f  s RequestDate=$o(^dbo.RPVisitNumberI("IndexPatientRequest",##Class(LIS.Util.Common).IndexData(RegNo),RequestDate)) q:RequestDate=""  d
    ..s VisitNumberDR="" f  s VisitNumberDR=$o(^dbo.RPVisitNumberI("IndexPatientRequest",##Class(LIS.Util.Common).IndexData(RegNo),RequestDate,VisitNumberDR)) q:VisitNumberDR=""  d
	...s AdmNo=$lg($g(^dbo.RPVisitNumberD(VisitNumberDR)),5)
    ...s VisRejectDR="" f  s VisRejectDR=$o(^dbo.RPVisitNumberRejectSpecI("IndexAdmNo",##Class(LIS.Util.Common).IndexData(AdmNo),VisitNumberDR,VisRejectDR)) q:VisRejectDR=""  d
	....d GetData

	
	i $l(FromDate),$l(ToDate),tFind=0 d  ///日期查询
	.s tFind=1
	.s CreateDate = FromDate-1
	.f  s CreateDate = $o(^dbo.RPVisitNumberRejectSpecI("IndexMaster",CreateDate)) q:(CreateDate>ToDate)||(CreateDate="")  d
	..s CreateTime="" f  s CreateTime = $o(^dbo.RPVisitNumberRejectSpecI("IndexMaster",CreateDate,CreateTime)) q:(CreateTime="")  d
	...s VisitNumberDR="" f  s VisitNumberDR = $o(^dbo.RPVisitNumberRejectSpecI("IndexMaster",CreateDate,CreateTime,VisitNumberDR)) q:(VisitNumberDR="")  d
	....s VisRejectDR="" f  s VisRejectDR = $o(^dbo.RPVisitNumberRejectSpecI("IndexMaster",CreateDate,CreateTime,VisitNumberDR,VisRejectDR)) q:(VisRejectDR="")  d
	.....d GetData

 	s qHandle=$lb(0,repid,0)
	q $$$OK 

GetData    
	s gVisRejSpecData=$g(^dbo.RPVisitNumberRejectSpecD(VisRejectDR))
	i $l(VisitNumberRejectSpecDR),VisitNumberRejectSpecDR'=VisRejectDR q
	s IsFinish=$lg(gVisRejSpecData,15)
	i fIsFinish=0,IsFinish=1 q
	i fIsFinish=1,IsFinish'=1 q
	s Labno=$lg($g(^dbo.RPVisitNumberD(VisitNumberDR)),2)
	s RegNo=$lg($g(^dbo.RPVisitNumberD(VisitNumberDR)),3)
	s SurName=$lg($g(^dbo.RPVisitNumberD(VisitNumberDR)),13)
	s LocationDR=$lg($g(^dbo.RPVisitNumberD(VisitNumberDR)),22)
	i $l(fLocationDR),fLocationDR'=LocationDR q
	s DoctorDR=$lg($g(^dbo.RPVisitNumberD(VisitNumberDR)),23)
	s WardDR=$lg($g(^dbo.RPVisitNumberD(VisitNumberDR)),26)
	s BedNo=$lg($g(^dbo.RPVisitNumberD(VisitNumberDR)),27)
	s (Doctor,Location,Ward)=""
	i $l(DoctorDR) s Doctor=$lg($g(^dbo.BTDoctorD(DoctorDR)),3)
	i $l(LocationDR) s Location=$lg($g(^dbo.BTLocationD(LocationDR)),3)
	i Location["-" s Location=$p(Location,"-",2),WardCode=""
	i $l(WardDR) s Ward=$lg($g(^dbo.BTWardD(WardDR)),3),WardCode=$lg($g(^dbo.BTWardD(WardDR)),4)
	i Ward["-" s Ward=$p(Ward,"-",2)
	i $l(fWardID),fWardID'=WardDR q
	s TestSetDesc=""
	s TestSetDR="" f  s TestSetDR=$o(^dbo.RPVisitNumberTestSetI("IndexMaster",VisitNumberDR,TestSetDR)) q:TestSetDR=""  d
	.i $l(TestSetDesc) s TestSetDesc=TestSetDesc_"+"_$lg($g(^dbo.BTTestSetD(TestSetDR)),3)
	.e  s TestSetDesc=$lg(^dbo.BTTestSetD(TestSetDR),3)
	s SpecimenDR=$lg($g(^dbo.RPVisitNumberD(VisitNumberDR)),56),SpecimenDesc=""
	i $l(SpecimenDR) s SpecimenDesc=$lg($g(^dbo.BTSpecimenD(SpecimenDR)),3)
	s CreateUserDR=$li(gVisRejSpecData,5),CreateUser=""
	s RejectTypeDR=$li(gVisRejSpecData,7)
 	s RejectType=$s($l(RejectTypeDR):$lg($g(^dbo.BTRejectTypeD(RejectTypeDR)),3),1:"")
	s OperateUserDR=$li(gVisRejSpecData,13),OperateUser=""
	i $l(CreateUserDR) s CreateUser=$lg($g(^dbo.SYSUserD(CreateUserDR)),3)
	i $l(OperateUserDR) s OperateUser=$lg($g(^dbo.SYSUserD(OperateUserDR)),3)
	s $li(gVisRejSpecData,1)=VisRejectDR
	s $li(gVisRejSpecData,5)=CreateUser
	s $li(gVisRejSpecData,7)=RejectType
	s $li(gVisRejSpecData,13)=OperateUser
	s Data=$lb(RegNo,SurName,Doctor,Location,Ward,Labno,TestSetDesc,SpecimenDesc)_gVisRejSpecData
	d OutputRej
 	q
OutputRej
	set ColFields="RegNo,SurName,Doctor,Location,Ward,Labno,TestSetDesc,SpecimenDesc,RejectDR,VisitNumberDR,CreateDate,CreateTime,CreateUser,RejectNotes,RejectType,NoticePatient,NoticePhone,NoticeNotes,OperateDate,OperateTime,OperateUser,OperateNotes,IsFinish,AdmNo"
 	Set ^CacheTemp(repid,ind)=##Class(LIS.Util.Common).TransListNull(Data,ColFields)
 	Set ind=ind+1
	Quit
}

ClassMethod QryRejectSpecFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRejectSpecExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {
 		s AtEnd=1
 		s Row=""
 	}
 	else {
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod QryRejectSpecClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRejectSpecExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 拒收标本床位图标提示
ClassMethod getIfRejectSp(EpisodeID) As %String
{
  //是否有拒收标本 
  s EpisodeID=$g(EpisodeID)
  s flag=0
  q:$g(EpisodeID)="" flag
  q:'$d(^PAADM(EpisodeID)) flag
  s PaitentID=$p(^PAADM(EpisodeID),"^",1)
  s admType=$p(^PAADM(EpisodeID),"^",2)
  q:$g(PaitentID)="" flag
  q:'$D(^PAPER(PaitentID,"PAT",1)) flag
  q:admType'="I" flag
  
  s VisitNumberDR="" f  s VisitNumberDR=$o(^dbo.RPVisitNumberRejectSpecI("IndexAdmNo",##Class(LIS.Util.Common).IndexData(EpisodeID),VisitNumberDR)) q:(VisitNumberDR="")||(flag=1)  d
  .s VisRejectDR="" f  s VisRejectDR=$o(^dbo.RPVisitNumberRejectSpecI("IndexAdmNo",##Class(LIS.Util.Common).IndexData(EpisodeID),VisitNumberDR,VisRejectDR)) q:(VisRejectDR="")||(flag=1)  d
  ..s IsFinish=$lg(^dbo.RPVisitNumberRejectSpecD(VisRejectDR),15) 
  ..i IsFinish'=1 s flag=1
  q flag
}

/// 更新拒收处理说明及状态
/// w ##Class(DHCLIS.DHCRejectSpecimen).SaveOperate("1","290","3123123123","2")
ClassMethod SaveOperate(RejectDR, UserID, OperateNotes, HospID, DetailsId) As %String
{
	s RejectDR=$g(RejectDR),UserID=$g(UserID),OperateNotes=$g(OperateNotes),HospID=$g(HospID),DetailsId=$g(DetailsId)
	i '$l(RejectDR) q 100
	
	//同步
	s (HospCode,HospDesc,HospitalDR)=""
	i $l(HospID) s HospCode=$p($g(^CT("HOSP",HospID)),"^",1),HospDesc=$p($g(^CT("HOSP",HospID)),"^",2)
	i $l(HospCode) s HospitalDR=##Class(DHCLIS.DHCCommon).GetHospitalDR(HospCode,HospDesc)
	
	s (UserCode,UserName,UserDR)=""
	i $l(UserID) s UserCode=$p($g(^SSU("SSUSR",UserID)),"^",1),UserName=$p($g(^SSU("SSUSR",UserID)),"^",2)
	i $l(UserCode) s UserDR=##Class(DHCLIS.DHCCommon).GetUserDR(UserCode,UserName,HospitalDR)
	
	s objReject=##Class(dbo.RPVisitNumberRejectSpec).%OpenId(RejectDR)
	If '$IsObject(objReject) q 100
	s objReject.OperateDate=$tr($zd(+$h,3),"-")
	s objReject.OperateTime=$p($h,",",2)
	s objReject.OperateUserDR=UserDR
	s objReject.OperateNotes=OperateNotes
	s objReject.IsFinish=1
	s sc=objReject.%Save()
	s ret=100
 	If ($SYSTEM.Status.IsOK(sc)) {
		//消息处理完成接口	
		i ##Class(%ClassDefinition).%ExistsId("websys.DHCMessageInterface") {
			s VisitNumberDR=$lg($g(^dbo.RPVisitNumberRejectSpecD(RejectDR)),2)
			s retVal=##Class(LISAPP.TASK.LisRealTimeInterface).LabnoToOrdInfo("","DHC-LISDATA",VisitNumberDR)
  			s ActionTypeCode="1006"	//消息动作代码
  			s EpisodeId=$p(retVal,"^",1)	//病人就诊Id
	  		s OrdItemId=$p(retVal,"^",2)	//医嘱Id
			s ret=##class(websys.DHCMessageInterface).Exec("",ActionTypeCode,EpisodeId,OrdItemId,"",UserID)

		}
	 	s ret=1
 	}
 	else {
	 	s ret=$SYSTEM.Status.GetErrorText(sc)
	}
		
 	q ret
}

/// 获取病区拒收标本数量
/// 入参: WardID病区Rowid Days查询天数默认当天
/// w ##Class(DHCLIS.DHCRejectSpecimen).GetWardRejectNum(10,"")
ClassMethod GetWardRejectNum(WardID, Days) As %String
{
	s WardID=$g(WardID)
	s Days=+$g(Days)
	s EndDate=+$h,SttDate=EndDate-Days
	s RetValue=0
	f Date=SttDate:1:EndDate d
	.s CreateDate=$tr($zd(Date,3),"-")
  	.s CreateTime="" f  s CreateTime=$o(^dbo.RPVisitNumberRejectSpecI("IndexMaster",CreateDate, CreateTime)) q:CreateTime=""  d
	..s VisitNumberDR="" f  s VisitNumberDR=$o(^dbo.RPVisitNumberRejectSpecI("IndexMaster",CreateDate, CreateTime,VisitNumberDR)) q:(VisitNumberDR="")  d
  	...s VisRejectDR="" f  s VisRejectDR=$o(^dbo.RPVisitNumberRejectSpecI("IndexMaster",CreateDate, CreateTime,VisitNumberDR,VisRejectDR)) q:(VisRejectDR="")  d
	....s gVisRejSpecData=$g(^dbo.RPVisitNumberRejectSpecD(VisRejectDR))
	....s IsFinish=$lg(gVisRejSpecData,15),WardCode=""
	....s WardDR=$lg($g(^dbo.RPVisitNumberD(VisitNumberDR)),26)
	....i $l(WardDR) s WardCode=$lg($g(^dbo.BTWardD(WardDR)),2)
	....i IsFinish=1 q
	....s WardDR=$lg($g(^dbo.RPVisitNumberD(VisitNumberDR)),26)
	....i $l(WardDR) s WardCode=$lg($g(^dbo.BTWardD(WardDR)),4)
	....i $l(WardID),WardID'=WardCode q
	....s RetValue=RetValue+1
 	q RetValue
}

/// 通过检验号获取拒收原因 
/// 入参: 检验号  出参："" 没有拒收  拒收原因
/// w ##Class(DHCLIS.DHCRejectSpecimen).GetRejectSpecByLabno(1000004421)
ClassMethod GetRejectSpecByLabno(Labno) As %String
{
	s Labno=$g(Labno)
	i '$l(Labno) q ""
	i '$d(^dbo.RPVisitNumberI("IndexVisitNumber",##Class(LIS.Util.Common).IndexData(Labno))) q ""
	s VisitNumberDR=$o(^dbo.RPVisitNumberI("IndexVisitNumber",##Class(LIS.Util.Common).IndexData(Labno),""))
	s AdmNo=$lg($g(^dbo.RPVisitNumberD(VisitNumberDR)),5)
    s VisRejectDR=$o(^dbo.RPVisitNumberRejectSpecI("IndexAdmNo",##Class(LIS.Util.Common).IndexData(AdmNo),VisitNumberDR,""),-1)
	i '$l(VisRejectDR) q ""
	s RejectNotes=$lg($g(^dbo.RPVisitNumberRejectSpecD(VisRejectDR)),6)
 	q RejectNotes
}

/// w ##Class(DHCLIS.DHCRejectSpecimen).GetAllInfo(56,42)
ClassMethod GetAllInfo(VisitNumberRejectSpecDR, EpisodeID)
{
	s VisitNumberRejectSpecDR=$g(VisitNumberRejectSpecDR),EpisodeID=$g(EpisodeID)
	s obj=##class(BSP.SYS.COM.ProxyObject).%New()

	if ((VisitNumberRejectSpecDR="")||(EpisodeID="")) {
		d obj.%Set("success",0)
		d obj.%Set("msg","错误的危急值ID")
		q obj.%ToJSON()
	}
	//==================标本拒收信息=============================================
	s (rowid,repInfo,repStatus,repDateDesc,repTime,repUser,repUserName)=""
	s gVisRejSpecData=$g(^dbo.RPVisitNumberRejectSpecD(VisitNumberRejectSpecDR))
	s repDate=$li(gVisRejSpecData,11)
	s repTime=$li(gVisRejSpecData,12)
	s repDateDesc=##class(websys.Conversions).DateLogicalToHtml(repDate)
	s:repTime'="" repTime=$zt(repTime)
	s OperateUserDR=$li(gVisRejSpecData,13),repUser=""
	i $l(OperateUserDR) s repUser=$lg($g(^dbo.SYSUserD(OperateUserDR)),3)
	s repTypeDesc="检验",repType=1
	s VisitNumberDR=$li(gVisRejSpecData,2)
	s Labno=$lg($g(^dbo.RPVisitNumberD(VisitNumberDR)),2)

	d obj.%Set("rowid",VisitNumberRejectSpecDR).%Set("repType",repType).%Set("repLabno",Labno).%Set("repTypeDesc",repTypeDesc)
	d obj.%Set("repDateDesc",repDateDesc).%Set("repTime",repTime).%Set("repUserName",repUserName).%Set("repStatus",repStatus)
	
	//================标本拒收-报告内容==========================
	s RejectNotes=$li(gVisRejSpecData,6)
	s RejectTypeDR=$li(gVisRejSpecData,7)
 	s RejectType=$s($l(RejectTypeDR):$lg($g(^dbo.BTRejectTypeD(RejectTypeDR)),3),1:"")
 	s repResult=RejectType_":"_RejectNotes
	d obj.%Set("repResult",repResult)
	
	//==================标本拒收-医嘱信息=============================================
	s (ordItm,ordDesc)=""
	s TestSetDesc=""
	s TestSetDR="" f  s TestSetDR=$o(^dbo.RPVisitNumberTestSetI("IndexMaster",VisitNumberDR,TestSetDR)) q:TestSetDR=""  d
	.i $l(TestSetDesc) s TestSetDesc=TestSetDesc_"+"_$lg($g(^dbo.BTTestSetD(TestSetDR)),3)
	.e  s TestSetDesc=$lg(^dbo.BTTestSetD(TestSetDR),3)

	s LocationDR=$lg($g(^dbo.RPVisitNumberD(VisitNumberDR)),22)
	s DoctorDR=$lg($g(^dbo.RPVisitNumberD(VisitNumberDR)),23)
	s (Doctor,Location,Ward)=""
	i $l(DoctorDR) s Doctor=$lg($g(^dbo.BTDoctorD(DoctorDR)),3)
	i $l(LocationDR) s Location=$lg($g(^dbo.BTLocationD(LocationDR)),3)

	d obj.%Set("ordItm",ordItm).%Set("ordDesc",TestSetDesc).%Set("ordDocName",Doctor).%Set("ordLocDesc",Location)

	//==================标本拒收-就诊信息=============================================
	s (admType,admLoc,admLocDesc,admDoc,admDocName,admDate)=""
	s admType=$p(^PAADM(EpisodeID),"^",2)
	s admLoc=$p(^PAADM(EpisodeID),"^",4)
	i admLoc>0 s admLocDesc=$p(^CTLOC(admLoc),"^",2)
	s admDoc=$p(^PAADM(EpisodeID),"^",9)
	i admDoc>0 s admDocName=$p(^CTPCP(admDoc,1),"^",2)
	s admDate=$P($G(^PAADM(EpisodeID)),"^",6)
	i admDate>0 s admDate=##class(websys.Conversions).DateLogicalToHtml(admDate)
	set mradm=$P(^PAADM(EpisodeID),"^",61)
	d obj.%Set("EpisodeID",EpisodeID).%Set("admType",admType).%Set("admLocDesc",admLocDesc).%Set("admLoc",admLoc)
	d obj.%Set("admDocName",admDocName).%Set("admDate",admDate).%Set("mradm",mradm)
	
	//==================标本拒收-病人信息=============================================
	s (PatientID,patName,sexDr,gender,age,DOB,PAPMINO)=""
	s PatientID=$p(^PAADM(EpisodeID),"^",1)
	s patName=$p(^PAPER(PatientID,"ALL"),"^",1)
	s sexDr=$p(^PAPER(PatientID,"ALL"),"^",7)
	i sexDr>0 s gender=$p(^CT("SEX",sexDr),"^",2)
	s age=##class(web.DHCBillInterface).GetPapmiAge(PatientID,EpisodeID)
	s DOB=$p(^PAPER(PatientID,"ALL"),"^",6)
	i DOB>0 s DOB=##class(websys.Conversions).DateLogicalToHtml(DOB)
	s PAPMINO=$p(^PAPER(PatientID,"PAT",1),"^",1)
	s patPhone=$p(^PAPER(PatientID,"PER",1),"^",11)  //PAPER_TelH
	d obj.%Set("PatientID",PatientID).%Set("patName",patName).%Set("gender",gender).%Set("DOB",DOB)
	d obj.%Set("age",age).%Set("PAPMINO",PAPMINO).%Set("patPhone",patPhone)
	
	//======================标本拒收-病案号===================================
	s patMrNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,admType,.ErrMsg)
	d obj.%Set("patMrNo",patMrNo)
	
	//==============================标本拒收-实际报告链接==========================================
	s reportUrl=""
	if repType=1 {
		//s reportUrl=..GetLisReportUrl(ordItm)
	}
	d obj.%Set("reportUrl",reportUrl)
	
	//==================标本拒收-处理记录=============================================
	/*
	set trArray=##class(BSP.SYS.COM.ProxyArray).%New()
	s trOrder=0 
	for {
		s trOrder=$o(^DHCAntCVReport(repType,repLabno,repOrder,"TR",trOrder))
		q:trOrder=""
		s (trContact,trPhone,trMemo,trDT,trDate,trTime,trUser,trUserId,trUserName,trStatus)=""
		if trOrder>0{
			s trInfo=$g(^DHCAntCVReport(repType,repLabno,repOrder,"TR",trOrder))
			s trDate=$p(trInfo,"\",1)
			s:trDate>0 trDate=##class(websys.Conversions).DateLogicalToHtml(trDate)
			s trTime=$p(trInfo,"\",2)
			s:trTime'="" trTime=$zt(trTime)
			s trUser=$p(trInfo,"\",3)
			if (trUser'="") s trUserId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$zcvt(trUser,"U"),""))
			if trUserId>0 s trUserName=$p(^SSU("SSUSR",trUserId),"^",2)
			s trContact=$p(trInfo,"\",5)
			s trPhone=$p(trInfo,"\",6)
			s trMemo=$p(trInfo,"\",7)
			s trStatus=$p(trInfo,"\",8)
			s trAdvice=$p(trInfo,"\",9)
			s trExecResult=$p(trInfo,"\",10)
			s trOpType=$p(trInfo,"\",16)
			
			s trObj=##class(BSP.SYS.COM.ProxyObject).%New()
			d trObj.%Set("trUserName",trUserName).%Set("trDate",trDate).%Set("trTime",trTime)
			d trObj.%Set("trContact",trContact).%Set("trPhone",trPhone).%Set("trMemo",trMemo).%Set("trStatus",trStatus)
			d trObj.%Set("trAdvice",trAdvice).%Set("trExecResult",trExecResult).%Set("trOpType",trOpType)
			d trArray.%Push(trObj)
		}
	}*/
	//d obj.%Set("transArray",trArray)
	
	d obj.%Set("success",1)
	q obj.%ToJSON()
}

}
