Class web.BriefEntry Extends (%Library.RegisteredObject, websys.Abstract) [ Not Abstract, ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// w ##class(web.BriefEntry).GetPatientMessageBAK("","1767469","")
ClassMethod GetPatientMessage(PatNo As %Library.String, MediCareNo As %Library.String, PaadmRowid As %Library.String)
{
	//1：基本信息  患者ID号和病案号，这两项作为查询条件。患者姓名、性别、年龄、
    //2：就诊信息 科室、病区、床号、费别、入院日期。
  
    s ^GetPatientMessage=$g(PatNo)_","_$g(MediCareNo)_","_$g(PaadmRowid)
    s ret="",CTLoc="",EpisodeSubTypeDesc=""
    if (PatNo'="") {
	s FindPatPapmi=$o(^PAPERi("PAPMI_PatNo",$ZCVT(PatNo,"U"),0))
	
	q:FindPatPapmi="" ""
	s PaadmRowid=0 f  s PaadmRowid=$o(^PAPERdr(FindPatPapmi,"ADM","I",PaadmRowid)) q:PaadmRowid=""  d
    .s VisitStatus=$p($g(^PAADM(PaadmRowid)),"^",20)
    .if (VisitStatus'="A") q 
    .s PAPMI=$p($g(^PAADM(PaadmRowid)),"^",1)
    .if FindPatPapmi'=PAPMI q
    .s PatientID=PAPMI
    .s EpisodeID=PaadmRowid
    .s AdmType=$p($g(^PAADM(PaadmRowid)),"^",2)
    .q:AdmType'="I" 
    .do PatAdmInfo
   
    q ret
    }
    elseif($g(MediCareNo)'="") {
	   
		s PatNo=""
		s NO1=1
		s ret=""
		s InMedNO=$ZConvert(MediCareNo,"U")
		s PersonRowId="",RowId="",PaadmRowid=""
		q:$d(^PAPERi("Medicare1",InMedNO))=0 "InputCorrectMedicare"
		f  s RowId=$o(^PAPERi("Medicare1",InMedNO,RowId),-1) q:((RowId="")||(PaadmRowid'=""))  d
	    .//update at 5.8  增加病案号筛选只选最新就诊记录病案号					
		.s PatNo=$p(^PAPER(RowId,"PAT",1),"^",1)
		.s FindPatPapmi=RowId
		.s PaadmRowid=$o(^PAPERdr(FindPatPapmi,"ADM","I",0))
		.q:PaadmRowid=""
		q:$g(FindPatPapmi)="" ""
	
		s PaadmRowid=0,FindFlag=0
		f  s PaadmRowid=$o(^PAPERdr(FindPatPapmi,"ADM","I",PaadmRowid)) q:((PaadmRowid="")||(FindFlag=1))  d 
	    .s VisitStatus=$p($g(^PAADM(PaadmRowid)),"^",20)
	    .i (VisitStatus'="A") q 
	    .s PAPMI=$p($g(^PAADM(PaadmRowid)),"^",1)
	    .i FindPatPapmi'=PAPMI q
	    .s PatientID=PAPMI
	    .s EpisodeID=PaadmRowid
	    .s AdmType=$p($g(^PAADM(PaadmRowid)),"^",2)
	    .q:AdmType'="I"
	    .do:PaadmRowid'="" PatAdmInfo
	    .s:PaadmRowid'="" FindFlag=1
	
	   
        q ret
    } elseif($g(PaadmRowid)'="") {
		s EpisodeID=PaadmRowid  
	    s ^Temp("GetPatientMessage")=PaadmRowid
		s VisitStatus=$p($g(^PAADM(PaadmRowid)),"^",20)
		
	    i (VisitStatus'="A") q ""
	    s PatientID=$p($g(^PAADM(PaadmRowid)),"^",1)
	    b
	    s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)
	    s EpisodeID=PaadmRowid
	    s AdmType=$p($g(^PAADM(PaadmRowid)),"^",2)
	    
	    q:AdmType'="I" ""
	    do PatAdmInfo
	    q ret
    }
    
    
PatAdmInfo
    s ^paadmrowidyl=PaadmRowid
 	s AdmDate=$p($g(^PAADM(PaadmRowid)),"^",6)
    s AdmDate=$zd(AdmDate,3)
    s AdmTime=$p($g(^PAADM(PaadmRowid)),"^",7)
    s AdmTime=$zt(AdmTime,2)
    s AdmReason=$p($g(^PAADM(PaadmRowid,1)),"^",7)
    //费别
    s AdmReason=$p(^PAC("ADMREA",AdmReason),"^",2)
	s Admdepcode=$p($g(^PAADM(PaadmRowid)),"^",4)
 	s AdmDept=$p($p($g(^CTLOC(Admdepcode)),"^",2),"-",2)
 	s Admdoccode=$p($g(^PAADM(PaadmRowid)),"^",9) 
 	s CreateUserDr=$p($g(^PAADM(PaadmRowid)),"^",43)
 	
 	s Comm=$p($g(^SSU("SSUSR",CreateUserDr)),"^",2)
 
 	s Ward=$P($g(^PAADM(PaadmRowid)),"^",70)
 	i (Ward'="")
 	{
	 	s LinkCTLoc=$p(^PAWARD(Ward),"^",5)
	 	i LinkCTLoc'="" {
	 	s CTLoc=$o(^CTLOC(LinkCTLoc,"LINK",0,"Loc",""))
	 	s CTLoc=$p(^CTLOC(CTLoc),"^",2)
	 	}
 	}
	i Ward'="" s PAAdmWard=$P($g(^PAWARD(Ward)),"^",2)
	e  s PAAdmWard=""

	Set Bed=$P($g(^PAADM(PaadmRowid)),"^",73)
	if Bed'="" Set PAAdmBed=$P($g(^PAWARD(+Bed,"BED",$P(Bed,"||",2))),"^",1)
	else  Set PAAdmBed="" 
 	i Admdoccode="" s admdoc="aa" 
 	e  s AdmDoc=$p($g(^CTPCP(Admdoccode,1)),"^",2)
 	s Age=##class(web.PAPerson).calculateAge(PatientID,"Y")
 	s PatientName=$p($g(^PAPER(PatientID,"ALL")),"^",1)
    s MediCare=$p($g(^PAPER(PatientID,"PAT",1)),"^",22)
    s DOB=$P($G(^PAPER(PatientID,"ALL")),"^",6)
    s DOB=$zd(DOB,3)
    s Sex=##class(web.PAPerson).GetSex(PatientID)
    
    //添加特需标志 
    s AdmEpissubtypeID=$p($g(^PAADM(EpisodeID,1)),"^",6)
	s EpisodeSubTypeDesc=""
	s:AdmEpissubtypeID'="" EpisodeSubTypeDesc=$p($g(^PAC("SUBT",AdmEpissubtypeID)),"^",2)
	s ret=PatientID_"^"_MediCare_"^"_PatientName_"^"_Sex_"^"_DOB_"^"_PAAdmWard_"^"_PAAdmBed_"^"_PaadmRowid_"^"_PatNo_"^"_CTLoc
	s ret=ret_"^"_Age_"^"_AdmReason_"^"_AdmDate_"^"_EpisodeSubTypeDesc
	q
}

ClassMethod GetOpByEpisodeID(stdate As %String, enddate As %String, EpisodeID As %String, ctlocId As %String, opastatus As %String)
{
	s $zt="GetOpByEpisodeIDError"
	
	Set ^Temp("UHDCANOPArrange","input")=stdate_","_enddate_","_EpisodeID_","_ctlocId_","_opastatus
	Set result="[",count=1
	Set RetStreamObj=##class(web.DHCANAdaptor).GetANOperation(stdate,enddate,EpisodeID,ctlocId,opastatus)
	Set reader = ##class(%XML.Reader).%New()
	Set sc=reader.OpenStream(RetStreamObj)
	
	
		
	If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit "ReadError"
	Do reader.Correlate("Response","web.DHCDocANAdaptor")

	if reader.Next(.object,.sc) {
		If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit "ReadobjectError"
		Set ANListObj=object.ANList
		Set Len=ANListObj.Count()
		for i=1:1:Len {
			s ItemInfoObj=ANListObj.GetAt(i)
			Set OPAStartDate=ItemInfoObj.OPAStartDate
			Set OpName=ItemInfoObj.OpName
			Set ANAOPSurgeonDR=ItemInfoObj.ANAOPSurgeonDR
			set ANAOPSurgeon=ItemInfoObj.ANAOPSurgeon
			set AssistantFirstCtcpId=ItemInfoObj.AssistantFirstCtcpId
			set AssistantSecondCtcpId=ItemInfoObj.AssistantSecondCtcpId
			set AnaMethod=ItemInfoObj.AnaMethod
			set OPSCNScrubNurseDR=ItemInfoObj.OPSCNScrubNurseDR
			set ANAOPCirculNurseDR=ItemInfoObj.ANAOPCirculNurseDR
			set OPAStatus=ItemInfoObj.OPAStatus
			//set ANAOPPreopDiagDR=ItemInfoObj.ANAOPPreopDiagDR
			set OPAAppDate=ItemInfoObj.OPAAppDate
			set RegNo=ItemInfoObj.RegNo
			set PatName=ItemInfoObj.PatName
			set Age=ItemInfoObj.Age
			set Sex=ItemInfoObj.Sex
			set OpaId=ItemInfoObj.OpaId
			set OPAOpRoomDr=ItemInfoObj.OPAOpRoomDr
			set OPASeq=ItemInfoObj.OPASeq
			set OPAAdmDr=ItemInfoObj.OPAAdmDr
			set OPAPatDeptDr=ItemInfoObj.OPAPatDeptDr
			set OpTime=ItemInfoObj.OpTime
			set OPAPATestHBsAg=ItemInfoObj.OPAPATestHBsAg
			set OPAPATestHCVAb=ItemInfoObj.OPAPATestHCVAb
			set OPAPATestHivAb=ItemInfoObj.OPAPATestHivAb
			set OPAPATestTPAb=ItemInfoObj.OPAPATestTPAb
			set OPAPATestOther=ItemInfoObj.OPAPATestOther
			set OPALabResult=ItemInfoObj.OPALabResult
			set OpDate=ItemInfoObj.OpDate
			set OpDocCtcpId=ItemInfoObj.OpDocCtcpId
			set AnaDocCtcpId=ItemInfoObj.AnaDocCtcpId
			set ScrubNurFirstCtcpId=ItemInfoObj.ScrubNurFirstCtcpId
			set ScrubNurSecondCtcpId=ItemInfoObj.ScrubNurSecondCtcpId
			set ScrubNurThirdCtcpId=ItemInfoObj.ScrubNurThirdCtcpId
			set CirculNurFirstCtcpId=ItemInfoObj.CirculNurFirstCtcpId
			set CirculNurSecondCtcpId=ItemInfoObj.CirculNurSecondCtcpId
			set CirculNurThirdCtcpId=ItemInfoObj.CirculNurThirdCtcpId
			set BodsDesc=ItemInfoObj.BodsDesc
			set EpisodeID=ItemInfoObj.EpisodeID
			set Prediag=ItemInfoObj.Prediag
			set JzStat=ItemInfoObj.JzStat
			set OPAAppLocDr=ItemInfoObj.OPAAppLocDr
			set OpDoctor=ItemInfoObj.OpDoctor
			set AnaDoctor=ItemInfoObj.AnaDoctor
			set AnaesthesiaID=ItemInfoObj.AnaesthesiaID
			set ^Temp("UHDCANOPArrange")=OPAStartDate
			s:count>1 result=result_",["""_AnaesthesiaID_""","""_OpName_"""]"
			s:count=1 result=result_"["""_AnaesthesiaID_""","""_OpName_"""]"
			s ^Temp("UHDCANOPArrange",count)=AnaesthesiaID
			s count=count+1
		}
	}
		
	s result=result_"]"
    q result

GetOpByEpisodeIDError
    set ^Temp("GetOpByEpisodeID","error",$j)=$ze
    q
}

ClassMethod ConvertToJson()
{
}

/// Creator:      yl
/// CreatDate:    ？
/// Description:  手术室医嘱病人警告信心
/// Table:        
/// Input:        EpisodeId就诊ID
/// Return:       警告信息
/// w ##class(web.BriefEntry)GetWarnMessage("")
ClassMethod GetWarnMessage(EpisodeID As %String)
{
	s ^GetWarMessage=$g(EpisodeID)
	;判断登录用户是否属于病人所在科室或者病区
	;医技科室不控制
	s IsEpLocDoctor=1
    s IsClinicalLoc=1
	s warning=""
	q:$g(EpisodeID)="" ""
	s VisitStatus=$p($g(^PAADM(EpisodeID)),"^",20)
	s FinFlag=$p($g(^PAADM(EpisodeID)),"^",45)
	s PAADMDate=$p($g(^PAADM(EpisodeID)),"^",6)
	s PAADMDocDR=$p($g(^PAADM(EpisodeID)),"^",9)
	s PAADMBedDR=$p($g(^PAADM(EpisodeID)),"^",73)
	s today=$P($h,",",1)
	s PAAdmType=$p($g(^PAADM(EpisodeID)),"^",2)
	s DocID=$P(^SSU("SSUSR",%session.Data("LOGON.USERID")),"^",14)
	i (PAAdmType="I") d
	. i (PAADMBedDR="")&&(IsClinicalLoc'=1) d
	. . s warning="此病人未分配床位,不允许开医嘱."
	. i (PAADMDocDR="")&&(CFIPNeedDoctor=1) d
	. . s warning="此病人未分配医生,不允许开医嘱." 
	. s OrderUnabled=##class(web.DHCDocOrderCommon).CheckOrderUnabled(EpisodeID)
	. i OrderUnabled=1 d
	. . s warning="此病人正在结算中,不允许再开医嘱."
	. i FinFlag="Y" d
	. . s warning="此病人已结算出院,不允许再开医嘱."
	. i ((VisitStatus="D")!(VisitStatus="C"))&(DocID'="") d
	. . s warning="此病人已做最终结算,不允许医护人员再开医嘱."
	i ((VisitStatus="C")!((OPAdmDayLimit'=0)&(today-PAADMDate>(OPAdmDayLimit-1))))&(PAAdmType="O") d
	. i VisitStatus="C" s warning="此病人已退号,不允许再开医嘱."
	. e  i (today-PAADMDate>(OPAdmDayLimit-1))  s warning="此就诊记录的挂号日期在"_OPAdmDayLimit_"天以前,不允许再开医嘱."
	i warning="",IsEpLocDoctor'=1 d
	. ;s warning="您还没有维护到本科室或病区,请与系统维护部门联系."
	i warning="",PAAdmType="I",IPDefaultDurRowId="" d
	. s warning="住院没有设定默认的疗程?请与系统维护部门联系."
	;护士审核本科室或本病区下医护人员不允许再下医嘱,住院处除外,医技科室判断财务审核
	i warning="",PAAdmType="I",IsEpLocDoctor=1,%session.Get("LOGON.GROUPID")'=322 d
	. i IsClinicalLoc=1 d
	. . s BillNo=$O(^DHCPB(0,"ADM",EpisodeID,""),-1)
	. . s ChargeAudit=##class(web.DHCIPBillConfirm).GetFinalConfFlag(+BillNo)
	. . i ($p(ChargeAudit,"^")="Y") d
	. . . //s warning=" 已经做财务审核,不允许再开医嘱."
	. . .s warning=""
	. e  d
	. . s NurAuditFlag=##class(User.DHCNurIpFeeAudit).IsNurAudit(EpisodeID)
	. . i ($p(NurAuditFlag,"^")="Y") d
	. . . s warning=" 护士已经做出院费用审核,不允许再开医嘱."
	i warning'="" d
	. s EnableButton=0	
	q warning
}

/// Creator:      yl
/// CreatDate:    2012.05.10
/// Description:  手术室医嘱录入日志
/// Table:        
/// Input:        EpisodeId就诊ID OrderItemStr 医嘱串
/// Return:       就诊ID
/// w ##class(web.BriefEntry)SavePhyisicalReg("")
ClassMethod BriefLog(EpisodeId As %String, OrderItemStr As %String)
{
	 
	 s:EpisodeId'="" ^DHCCyl("BriefLog",$i(^DHCCyl),EpisodeId,$h)=""
	 s:EpisodeId="" ^DHCCyl("BriefLog","EpisodeIDNUll",$h)=""
	 if (OrderItemStr'=""){
		 s:EpisodeId'="" ^DHCCyl("BriefLog","beforeSave",EpisodeId,$h)=OrderItemStr
	 }
}

//

/// Creator:      yl
/// CreatDate:    2012.08.10
/// Description:  体检收费
/// Table:        
/// Input:        病人基本信息串
/// Return:       就诊ID
/// w ##class(web.BriefEntry)SavePhyisicalReg("")
ClassMethod SavePhyisicalReg(str)
{
	 s ^SavePhyisicalReg=str
	 s $zt="SavePhyisicalRegError"
	 n person
	 s hasError=""
	 s reader=##class(%XML.Reader).%New()
	 s status=reader.OpenString(str)
     If $system.Status.IsError(status) do $System.Status.DisplayError(status)
     s doc=reader.Document
     s root=doc.GetDocumentElement()
     do root.MoveToFirstChild(1)     
	 s name=root.GetAttributeValue("name")
	 s sex=root.GetAttributeValue("sex")
	 s age=root.GetAttributeValue("age")
	 s dob=root.GetAttributeValue("dob")
	 s admreason=root.GetAttributeValue("admreason")
	 s admreasonDesc=$p(^PAC("ADMREA",admreason),"^",2)
	 s EpissubtypeFlag=root.GetAttributeValue("Epissubtype")
	 d reader.Close()
	 s reader=""
	
	 tstart
	 s person=##class(User.PAPerson).%New()
	 s person.PAPERName=name
	 s person.PAPERAge=age
	 //病人类型
	 d person.PAPERSocialStatusDRSetObjectId(1)
	 s:dob["-" person.PAPERDob=$zdh(dob,3)
	 d:sex'="" person.PAPERSexDRSetObjectId(sex)
	 s rs=person.%Save()
	 i rs=1
	 {
		 s PatientID=person.%Id()
		 b ;PatientID
		 s patmas=##class(User.PAPatMas).%OpenId(PatientID)
		 i $d(^PAPER(0,"CNT","I")) d
		  .;s myMAXNo=^PAPER(0,"CNT","I") //最大登记号
		 e  d
		 .s myMAXNo=0
		 s myMAXNo=$i(^PAPER(0,"CNT","I"))
		 s myPatLen=+$p(^CF("PATCF",1,3),"^",5)
		 s myMAXNo=$e("0000000000000000000",1,myPatLen-$l(myMAXNo))_myMAXNo 
		 s patmas.PAPMINo=myMAXNo
		 s patmas.PAPMIIPNo=myMAXNo
		 s patmas.PAPMIOPNo=myMAXNo
		 s patmasSave=patmas.%Save()
		 d patmas.%Close()
		 s patmas=""
	 }
	 q:rs'=1 "0"
	          
	// s ctlocid=$o(^CTLOC(0,"Code",3310000,"")) //体检中心
	 s hospital=%session.Get("LOGON.HOSPID")
	 i hospital=2 d
	 .s ctlocid=572 //西院健康医学部
	 e  d
	 .s ctlocid=$o(^CTLOC(0,"Code",1610000,""))
	 s Epissubtype=$o(^PAC("SUBT",0,"Code",3,""))
	 //i admreasonDesc["特需收费" d
	 i +EpissubtypeFlag=-1 d
	 .s insertAdm=##class(web.BriefEntry).InsertAdm(PatientID,ctlocid,"","O","A",Epissubtype)
	 e  d
	 .s insertAdm=##class(web.BriefEntry).InsertAdm(PatientID,ctlocid,"","O","A")
	
	 tcommit
	 q:hasError="" $g(myMAXNo)
SavePhyisicalRegError
    s ^SavePhyisicalReg("error",name,$h)=$ze
    s hasError=$ze
      trollback
    q ""
}

/// Creator:      yl
/// CreatDate:    2012.09.04
/// Description:  体检VIP挂号
/// Table:      
/// Input:        LocationID科室 Doctor 医生 CardNo 卡号 TimeRangRowID 时段 AdmDate 排班日期
/// Return:       1 成功 2 该医生已有排班 3获取挂号费失败 5加号失败 6 增加排班失败 4挂号失败
/// w ##class(web.BriefEntry).SavePhyisicalVIP(194,1001,4612183,2157355923,2,2012-09-25)
ClassMethod SavePhyisicalVIP(LocationID, DoctorID, PatientID, CardNo, TimeRangeRowID, AdmDate As %String = "", PayModeCode As %String = "")
{
   
    k ^SavePhyisicalVIP
	s ^SavePhyisicalVIP=LocationID_","_DoctorID_","_PatientID_","_CardNo_","_TimeRangeRowID_","_AdmDate_","_PayModeCode
	
	s $zt="PhyisicalVIPError"
	
	s insert="",success=0,ASIrregularFlag="",RegResult="",SessionTypeID=""
    s UserRowID=%session.Get("LOGON.USERID")
    s:PayModeCode="" PayModeCode="CASH"

	q:$d(^RB("RES",0,"CTPCP",DoctorID))'=10 0
	q:$d(^RB("RES",0,"CTPCP",DoctorID,LocationID))'=10 0	
	
	s ResRowId=$o(^RB("RES",0,"CTPCP",DoctorID,LocationID,""))
	s ^SavePhyisicalVIP("ResRowId")=ResRowId
	//从模板获取职称
	s RBResEffDateChildsub=0
	f  s RBResEffDateChildsub=$O(^RB("RES",ResRowId,"DATE",RBResEffDateChildsub)) q:(RBResEffDateChildsub="")  d
	.s SESSChildsub=0
	.s SESSChildsub=$o(^RB("RES",ResRowId,"DATE",RBResEffDateChildsub,"SESS",SESSChildsub)) q:((SESSChildsub="")||(SessionTypeID'=""))  d
	..s:SessionTypeID="" SessionTypeID=$p(^RB("RES",ResRowId,"DATE",RBResEffDateChildsub,"SESS",SESSChildsub),"^",9)
	
	i SessionTypeID="" {
		 s ASChildsub=0
		 f  s ASChildsub=$o(^RBAS(ResRowId,ASChildsub)) q:((ASChildsub="")||(SessionTypeID'=""))  d
		 .s:SessionTypeID="" SessionTypeID=$p(^RBAS(ResRowId,ASChildsub,"DHC"),6)
	}
	//TXNFMKMZ-特需内分泌科门诊  潘慧 
	s:(DoctorID=3146)&&(LocationID=166) SessionTypeID=12
	//s:(DoctorID=141)&&(LocationID=140) SessionTypeID=4
	s ^SavePhyisicalVIP("SessionTypeID",PatientID)=SessionTypeID
	s CurrentTime=$P($h,",",2)
	i TimeRangeRowID=1 d
	.s SelectTRQuery=1,BookNum="",TotalNum=1,OverBookNum=0 //加号数
	i TimeRangeRowID=2 d
	.s SelectTRQuery=1

	s:AdmDate="" AdmDate=+$h
	s:AdmDate["-" AdmDate=$zdh(AdmDate,3)
	s AdmTime=""
	s tmpTRowid=TimeRangeRowID
	s ASRowIdStr=##Class(web.DHCRBApptSchedule).GetAvailRA(ResRowId,AdmDate,AdmTime,tmpTRowid,SelectTRQuery,1)
	
	set scheduleRowID=""
	s ^SavePhyisicalVIP("AvailRA",PatientID)=ASRowIdStr
	s:AdmDate["-" AdmDate=$zdh(AdmDate,3)
	s (SecheduleDate, TotalNum, BookNum, OverBookNum,RoomID,ClinicGroupID, BookStartNum , SessStartTime, SessEndTime, StatusCode, TimeRangeInfoStr)="" 
	//排班日期当天  现可以挂非当天号
	s SecheduleDate=$zd(AdmDate,4)
	s StatusCode="N" //出诊状态 正常    
    i TimeRangeRowID=1  d
	.s SelectTRQuery=1
	.s BookNum=""
	.s TotalNum=1
	.s OverBookNum=0 //加号数
	i TimeRangeRowID=2 d
	.s SelectTRQuery=2
	.s BookNum=""
	.s TotalNum=1
	.s OverBookNum=0 //加号数
	s:SessionTypeID="" SessionTypeID=5
    //	tstart 
	//ASIrregularFlag =A 为VIP,便民增加排班
	i ASRowIdStr'="" {
		i ASRowIdStr'["^" d
		.s ASIrregularFlag=$p(^RBAS(+ASRowIdStr,$p(ASRowIdStr,"||",2)),"^",13)
		.i ASIrregularFlag="A" d
		..s RBApptScheduleID=ASRowIdStr
	    ..s ret=$$DocAddAndReg(RBApptScheduleID)
	    .e  d
	    ..s success=2 //该医生已有排班
	   // tc:success=1
        //trollback:success'=1
		q:((ASIrregularFlag="A")&&(success=1)) success_"RegResult"_RegResult
		q success
	} else  {
		s:AdmDate>+$h SecheduleDate=$zd(AdmDate,4)
	    s ^SavePhyisicalVIP("Date")=SecheduleDate_","_AdmDate
	    s tmpTRowid=TimeRangeRowID
		s insert=##class(web.DHCRBApptSchedule).InsertOneSchedule(SecheduleDate,DoctorID,LocationID, tmpTRowid, TotalNum, BookNum, OverBookNum,RoomID,SessionTypeID,ClinicGroupID, BookStartNum , SessStartTime, SessEndTime, StatusCode, TimeRangeInfoStr,"A",0)
		b ;insertOneSchedule
		s ^SavePhyisicalVIP("InsertOneSchedule")=insert
		i $p(insert,"^",1)=0 d 
		.s RBApptScheduleID=$p(insert,"^",2)	
		.s ret=$$DocAddAndReg(RBApptScheduleID)
		e  d
		.s success=6  
		.s ^SavePhyisicalVIP("InserSchedulFailed",$h)=insert //增加排班失败
		.s ^SavePhyisicalVIP("InserSchedulFailed",$h,"input")=SecheduleDate_","_DoctorID_","_LocationID_","_TimeRangeRowID_","_TotalNum_","_BookNum_","_OverBookNum_","_RoomID_","_SessionTypeID_","_ClinicGroupID_","_BookStartNum _","_SessStartTime_","_SessEndTime_","_StatusCode_","_TimeRangeInfoStr_","_"A"_","_0
        //tc:success=1
	   // tcommit
	    q:ASRowIdStr'="" 2 //已经有排班
		q success_"RegResult"_RegResult
  }
PhyisicalVIPError
    s ^SavePhyisicalVIP("error",$h)=$ze  	
   //	trollback
   	q 0
GetFeeStr 
    s DocResValue=##class(web.DHCOPAdmReg).GetMarkRegFee(RBApptScheduleID,1,PatientID)
	b ;DocResValue
	s RegFee=$p(DocResValue,"^",12)
    s CheckFee=$p(DocResValue,"^",14)
	s HoliFee=$p(DocResValue,"^",16)
	s AppFee=$p(DocResValue,"^",18)
	s mrfee=0
	s ReCheckFee=$p(DocResValue,"^",15)
	s CardFee=""
	s OtherFee=$p(DocResValue,"^",20)
	s FeeStr=RegFee_"||"_CheckFee_"||"_HoliFee_"||"_AppFee_"||"_mrfee_"||"_ReCheckFee_"||"_0
   q ""
DocAddAndReg(RBApptScheduleID)
		//加号为正常诊间加号非护士加号
		s DocAddResult=##class(web.DHCOPAdmReg).OPAppDocBroker("","",PatientID,RBApptScheduleID,"",UserRowID,"DOCADD","","")
		s ^SavePhyisicalVIP("DocAddResult")=DocAddResult
		b ;DOCAdd
		i $p(DocAddResult,"^",1)=0 d
		.s (ResRowId,AdmReason,QueueNo,FeeStr,AccRowId,user,group,AdmType,DiagnosCatRowId,FreeRegFlag,FreeCheckFlag,RegfeeRowId,InsuJoinStr,DiscountFactor, SaveType,EmployeeNo,InsuranceStr,SourceType)=""
		.s RegPatientID=PatientID_"^N"
		.s RBAppointID=$p(DocAddResult,"^",2)
		.s AdmReason=1 //自费
     	.s user=UserRowID
		.s group=%session.Get("LOGON.GROUPID")
		.s SaveType="Reg"
		.s PayModeCode=PayModeCode_"^^"_LocationID_"^"_%session.Data("LOGON.HOSPID")
	    .d GetFeeStr
		.s:+RegFee=0 success=3
		.q:success=3 //获取挂号费失败
		.s SourceType="HIS"
		.s ^SavePhyisicalVIP("OPRegistBroker")=RegPatientID_","_RBApptScheduleID_","_AdmReason_","_QueueNo_","_FeeStr_","_PayModeCode_","_AccRowId_","_user_","_group_","_AdmType_","_DiagnosCatRowId_","_FreeRegFlag_","_FreeCheckFlag_","_RegfeeRowId_","_InsuJoinStr_","_DiscountFactor_","_SaveType_","_EmployeeNo_","_InsuranceStr_","_SourceType
		.s RegResult=##class(web.DHCOPAdmReg).OPRegistBroker(RegPatientID,RBApptScheduleID_"^"_RBAppointID,AdmReason,QueueNo,FeeStr,PayModeCode,AccRowId,user,group,AdmType,DiagnosCatRowId,FreeRegFlag,FreeCheckFlag,RegfeeRowId,InsuJoinStr,DiscountFactor, SaveType,EmployeeNo,InsuranceStr,SourceType)
		.s RegResultFlag=$p(RegResult,"$",1)
		.s:RegResultFlag=0 success=1
		.s:RegResultFlag'=0 success=4,^SavePhyisicalVIP("挂号失败结果")=RegResult //挂号失败
		e  d
		.s success=5 //加号失败
		.s ^SavePhyisicalVIP("DocAddResult",LocationID, DoctorID, PatientID, CardNo)=DocAddResult  
	q success
}

ClassMethod SaveNurseAddLicense(userid, locid, docid)
{
	s ^SaveNurseAddLicense(userid,locid)=docid
	q:((userid="")||(locid="")||(docid=""))

	s ^DHCNurseAddLicense(userid,locid,docid)=""
}

ClassMethod GetLocTree()
{
	s OneStr="{'id': 'LocID','text':'LocDesc','leaf':TrueOrFalse,'checked':undefined}"		
	s RetStr=""
	s id=0
        s CTLocID=""
	 	f  s CTLocID=$o(^RB("RES",0,"CTLOC",CTLocID))	q:CTLocID=""  d	  
		.s Desc=$P(^CTLOC(CTLocID),"^",2)
		.q:($d(^PAC("ADMLOC",0,"AdmType","O",CTLocID))'=10)&&($d(^PAC("ADMLOC",0,"AdmType","E",CTLocID))'=10)
		.s:Desc["-" Desc=$p(Desc,"-",2)
		.s Str=..Replace(OneStr,"LocID",CTLocID)
		.s Str=..Replace(Str,"LocDesc",Desc)
		.s Str=..Replace(Str,"TrueOrFalse","true")
		.i $d(^NightLoc("NIGHT")) d
		..i ^NightLoc("NIGHT")'[("^"_CTLocID_"^") d
		...s Str=..Replace(Str,"undefined","false")
		..e  d
		...s Str=..Replace(Str,"undefined","true")
		.e  d
		..s Str=..Replace(Str,"undefined","false")
		.i RetStr="" d
		..s RetStr=Str
		.e  d
		..s RetStr=RetStr_","_Str
	

	i RetStr'="" s RetStr="["_RetStr_"]"
	q RetStr
}

ClassMethod Replace(Strings, Str, Rep) As %String [ Language = basic ]
{
	return Replace(Strings,Str,Rep)
}

ClassMethod SaveNigthGroupConfig(GroupIDS)
{
	s ^NightLoc("NIGHT")=GroupIDS_"^"
	q ""
}

/// Creator:      yl
/// CreatDate:    2012.09.03
/// Description:  根据卡号获取病人ID
/// Table:        ^DHCCARDi
/// Input:        CardNo卡号
/// Return:       卡号 病人基本信息ID 登记号
ClassMethod GetPatientIDByCardNumber(CardNo)
{
	s ^GetPatientIDByCardNumber=CardNo
 	q:+CardNo=0 ""
	s CFRowID="0",PatientID="",CFPAPMINo=""
	b ;1
	q:$d(^DHCCARDi("CF",0,"CardNo",CardNo))=0
	b ;2
	f  s CFRowID=$o(^DHCCARDi("CF",0,"CardNo",CardNo,CFRowID)) q:((CFRowID="")||(PatientID'=""))  d
	.b ;3
	.s ActiveFlag=$p(^DHCCARD("CF",CFRowID),"^",10)
	.q:ActiveFlag'="N"
	.s PatientID=$p(^DHCCARD("CF",CFRowID),"^",4)
	.s CFPAPMINo=$p(^DHCCARD("CF",CFRowID),"^",6)
	q CardNo_","_PatientID_","_CFPAPMINo
}

//检查是否是本院职工 是 则返回用户名

ClassMethod CheckVIPPatient(EmployeeNo As %String = "")
{
	q:EmployeeNo="" 0
	s UserID=$O(^SSU("SSUSR",0,"SSUSR_Initials",$ZCVT(EmployeeNo,"U"),""))
	i UserID'=""  d
	.s UserName=$p($g(^SSU("SSUSR",UserID)),"^",2)
	q:UserID'="" UserID_"^"_UserName	
	q 0
}

//

/// Creator:      yl
/// CreatDate:    2012.09.01
/// Description:  模板维护界面获取排班信息：
/// Table:        ^CTLOC，^RB("RES"
/// Input:        DepartID 科室ID ResRowID资源ID
/// Return:       Json串 科室是否提交 诊室，出诊级别 
/// w ##class(web.BriefEntry).getScheduleMessage(3,10686)
ClassMethod getScheduleMessage(DepartID, ResRowID As %String)
{
	s ^getScheduleMessage=DepartID_","_ResRowID
    q:+DepartID=0 0
    s SubmitInfo=$G(^CTLOC(DepartID,"RBSSubmit"))
	s Flag=$P(SubmitInfo,"^",1)	
	s SESSRoomDR=""
	s RBCSessionType=""
	i ResRowID'="" 
	{
	  s (SESSChildsub,DATEChildsub,RBCSessionType,SESSRoomDR)=""
	 i $d(^RB("RES",ResRowID,"DATE"))=10 d
	 .f  s DATEChildsub=$o(^RB("RES",ResRowID,"DATE",DATEChildsub)) q:DATEChildsub=""  d
	   ..f  s SESSChildsub=$o(^RB("RES",ResRowID,"DATE",DATEChildsub,"SESS",SESSChildsub)) q:SESSChildsub=""  d
	    ...s SESS=$g(^RB("RES",ResRowID,"DATE",DATEChildsub,"SESS",SESSChildsub))
	 	...s:SESSRoomDR="" SESSRoomDR=$p(SESS,"^",19) //诊室
	 	...s:RBCSessionType="" RBCSessionType=$p(SESS,"^",9) //出诊级别 
		
	}
	q "{IfSumbit:'"_Flag_"'"_",Room:'"_SESSRoomDR_"',"_"SessionType:'"_RBCSessionType_"'}"
}

//检查费别是否是医保

ClassMethod CheckIfInsurance(AdmReasonID)
{
	q:+AdmReasonID=0 ""
	q:$d(^PAC("ADMREA",AdmReasonID))=0 ""
	q $p(^PAC("ADMREA",AdmReasonID),"^",9)
}

//保存医保卡是否按照9位数检索

ClassMethod SaveInsurCardSearch(ifsearch)
{

 s:ifsearch=1 ^DHCCARD("InsuranceSearch")=1
 k:ifsearch'=1 ^DHCCARD("InsuranceSearch")
}

Query GetStopDocUser() As %Query(ROWSPEC = "UserRowID:%String,UserName:%String,StopDocUserID:%String")
{
}

//d ##class(%ResultSet).RunQuery("web.CTCareProv","GetStopDocUser","","wx","TXVIP")

ClassMethod GetStopDocUserExecute(ByRef QHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s QHandle=$lb(0,repid,0)
	s StopDocUserID=0
	 for StopDocUserID=$o(^User.DHCStopDocUserD(StopDocUserID)) q:StopDocUserID=""  d
	 .s UserRowId=$ListGet(^User.DHCStopDocUserD(StopDocUserID),1)
	 .s UserName=$ListGet(^User.DHCStopDocUserD(StopDocUserID),2)
     .s ^CacheTemp(repid,ind)=$lb(UserRowId,UserName,StopDocUserID)
     .s ind=ind+1
	Quit $$$OK
}

ClassMethod GetStopDocUserClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = GetStopDocUserExecute ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetStopDocUserFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetStopDocUserExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

//更新停诊批准人

ClassMethod UpdateStopDocUser(RowID As %String, UserRowID As %String, UserName As %String, Type As %String = "")
{
  //insert
  if UserRowID="" d
  .s NewObj=##class(User.DHCStopDocUser).%New()
  .s NewObj.UserName=UserName
  .d NewObj.UserRowIDSetObjectId(UserRowID)
  .s rs=NewObj.%Save()
  .d NewObj.%Close()
  .s NewObj=""
  else  if (Type="")  d //update
  .s UpdateObj=##class(User.DHCStopDocUser).%OpenId(RowID)
  .s UpdateObj.UserName=UserName
  .d UpdateObj.UserRowIDSetObjectId(UserRowID)
  .s rs=UpdateObj.%Save()
  .d UpateObj.%Close()
  .s UpdateObj=""
  else  d
  .s rs=##class(User.DHCStopDocUser).%DeleteId(RowID)
}

ClassMethod SaveInAdvanceReg()
{
	
	q "[]"
}

//获取提前挂号配置JSON串 w ##class(web.BriefEntry).GetInAdvanceConfig()

ClassMethod GetInAdvanceConfigBAK() As %String
{
	  
       /* 
	   s date=+$h-3
	   for i=1:1:7
	   {
		    s nodeName=$zd(date,12)		    
			s ^DHCOPRegConfig("DHCOPInAdvance",nodeName,"StartTime")=""
			for j=0:1:6
			{
					s ^DHCOPRegConfig("DHCOPInAdvance",nodeName,j)=""
			}
			s date=date+1
	   }
 	   q ""
    	*/

	s (Week,StartTime,Days,JsonObject)=""
	s IAOpRegJson="{record:["
	s JsonObjectTemplate="{StartWeek:'sw',StartTime:'st',Monday:'mon',Tuesday:'tue',Wednesday:'wed',Thursday:'thu',Friday:'fri',Saturday:'sat',Sunday:'sun'}"
	for i=0:1:6 {
		
		s StartWeek=$SELECT(i=1:"Monday",i=2:"Tuesday",i=3:"Wednesday",i=4:"Thursday",i=5:"Friday",i=6:"Saturday",i=0:"Sunday")
	
		//b ;StartWeek
		s StartTime=$g(^DHCOPRegConfig("DHCOPInAdvance",StartWeek,"StartTime"))
		s TmpStartWeek=$SELECT(i=1:"周一",i=2:"周二",i=3:"周三",i=4:"周四",i=5:"周五",i=6:"周六",i=0:"周日")
		s JsonObjectTemplate=$Replace(JsonObjectTemplate,"sw",TmpStartWeek)
		s JsonObjectTemplate=$Replace(JsonObjectTemplate,"st",StartTime)
		for j=0:1:6
		{
		  s Week=$SELECT(j=1:"mon",j=2:"tue",j=3:"wed",j=4:"thu",j=5:"fri",j=6:"sat",j=0:"sun")
		  s JsonObjectTemplate=$Replace(JsonObjectTemplate,Week,$g(^DHCOPRegConfig("DHCOPInAdvance",StartWeek,j)))
		}
		
		i JsonObject'="" d
		 .s JsonObject=JsonObject_","_JsonObjectTemplate
		e  d
		.s JsonObject=JsonObjectTemplate
		s JsonObjectTemplate="{StartWeek:'sw',StartTime:'st',Monday:'mon',Tuesday:'tue',Wednesday:'wed',Thursday:'thu',Friday:'fri',Saturday:'sat',Sunday:'sun'}"
		
	}
	s IAOpRegJson=IAOpRegJson_JsonObject_"],total:7}"
    q IAOpRegJson
}

/// Creator:      yl
/// CreatDate:    2012.09.10
/// Description:  获取提前挂号设置
/// Table:        ^DHCOPRegConfig
/// Input:        空
/// Return:       Json串
ClassMethod GetInAdvanceConfig() As %String
{
	
	s (ExceptionDate,JsonObject)=""
	s count=0
	s IAOpRegJson="{record:["
	s JsonObjectTemplate="{ExceptionDate:'ed'}"
	i $d(^DHCOPRegConfig("DHCOPInAdvance","ExceptionDate"))=10 d
    .for  s ExceptionDate=$o(^DHCOPRegConfig("DHCOPInAdvance","ExceptionDate",ExceptionDate)) q:ExceptionDate=""  d
    ..s ExceptionDateValue=$zd(ExceptionDate,3)
    ..s JsonObjectTemplate=$Replace(JsonObjectTemplate,"ed",ExceptionDateValue)
    ..i JsonObject'="" d
	...s JsonObject=JsonObject_","_JsonObjectTemplate
	..e  d
	...s JsonObject=JsonObjectTemplate
	..s count=count+1
	..s JsonObjectTemplate="{ExceptionDate:'ed'}"
	s IAOpRegJson=IAOpRegJson_JsonObject_"],total:"_count_"}"
    q IAOpRegJson
}

/// Creator:      yl
/// CreatDate:    2012.09.10
/// Description:  删除提前挂号例外日期
/// Table:        PA_Adm
/// Input:        提前挂号例外日期
/// Return:       挂号费
ClassMethod DeleteExceptionDate(ExceptionDate)
{
	i ExceptionDate["-" d
	.s ExceptionDate=$zdh(ExceptionDate,3)
	.k ^DHCOPRegConfig("DHCOPInAdvance","ExceptionDate",ExceptionDate)
	q 1
}

/// Creator:      yl
/// CreatDate:    2012.09.10
/// Description:  保存提前挂号例外日期设置
/// Table:        ^DHCOPRegConfig
/// Input:        例外日期串
/// Return:       1成功
ClassMethod SaveInAdvanceConfig(str) As %String
{
	s ^SaveInAdvanceConfig=str
	
	s length=$Length(str,"!!!")
	for i=1:1:length{
		s ExceptionDate=$p(str,"!!!",i)
		s:ExceptionDate["-" ^DHCOPRegConfig("DHCOPInAdvance","ExceptionDate",$zdh(ExceptionDate,3))=""
	}
	s DeleteDate=""
	for  s DeleteDate=$O(^DHCOPRegConfig("DHCOPInAdvance","ExceptionDate",DeleteDate)) q:DeleteDate=""  d
	.k:DeleteDate<+$h ^DHCOPRegConfig("DHCOPInAdvance","ExceptionDate",DeleteDate)

	q 1
}

ClassMethod SaveInAdvanceConfigBAK(str) As %String
{
	s ^SaveInAdvanceConfig=str
 	s $zt="SaveInAdvanceConfigErrorBAK"
	s length=$Length(str,"!!!")
	for i=1:1:length{
		s WeekMessage=$p(str,"!!!",i)
		s count=$length(WeekMessage,"^")
			s StartWeek=$p(WeekMessage,"^",1)
			s StartTime=$p(WeekMessage,"^",2)
			s StartWeek=$SELECT(StartWeek="周一":"Monday",StartWeek="周二":"Tuesday",StartWeek="周三":"Wednesday",StartWeek="周四":"ThursDay",StartWeek="周五":"Friday",StartWeek="周六":"Saturday",StartWeek="周日":"Sunday")			
			s ^SaveInAdvanceConfig("StartWeek")=StartWeek
			s ^DHCOPRegConfig("DHCOPInAdvance",StartWeek,"StartTime")=StartTime
			s Monday=$p(WeekMessage,"^",3)
			s ^DHCOPRegConfig("DHCOPInAdvance",StartWeek,1)=$SELECT(Monday="true":1,Monday="false":"",Monday="":"")
			s Tuesday=$p(WeekMessage,"^",4)
			s ^DHCOPRegConfig("DHCOPInAdvance",StartWeek,2)=$SELECT(Tuesday="true":1,Tuesday="false":"",Tuesday="":"")
			s Wednesday=$p(WeekMessage,"^",5)
			s ^DHCOPRegConfig("DHCOPInAdvance",StartWeek,3)=$SELECT(Wednesday="true":1,Wednesday="false":"",Wednesday="":"")
			s ThursDay=$p(WeekMessage,"^",6)
			s ^DHCOPRegConfig("DHCOPInAdvance",StartWeek,4)=$SELECT(ThursDay="true":1,ThursDay="false":"",ThursDay="":"")
			s Friday=$p(WeekMessage,"^",7)
			s ^DHCOPRegConfig("DHCOPInAdvance",StartWeek,5)=$SELECT(Friday="true":1,Friday="false":"",Friday="":"")
			s Saturday=$p(WeekMessage,"^",8)
			s ^DHCOPRegConfig("DHCOPInAdvance",StartWeek,6)=$SELECT(Saturday="true":1,Saturday="false":"",Saturday="":"")
			s Sunday=$p(WeekMessage,"^",9)
			s ^DHCOPRegConfig("DHCOPInAdvance",StartWeek,0)=$SELECT(Sunday="true":1,Sunday="false":"",Sunday="":"")
			
			
		
		
	}
	q 1
SaveInAdvanceConfigErrorBAK
      s ^SaveInAdvanceConfigError=$ze
   q 0
}

/// Creator:      yl
/// CreatDate:    2012.08.10
/// Description:  体检收费插入就诊表
/// Table:        PA_Adm
/// Input:        PatientID病人基本信息RowID ,AdmDep就诊科室,AdmWard就诊病区 AdmType就诊类型 VisitusStatus状态 Epissubtype就诊子类 AdmReason费别
/// Return:       挂号费
ClassMethod InsertAdm(PatientID, AdmDep, AdmWard, AdmType As %String = "", VisitusStatus As %String = "", Epissubtype As %String = "", AdmReason As %String = "", IPBookID As %String = "")
{

	s ^BriefEntryInsertAdmPara=PatientID_","_AdmDep_","_AdmWard_","_AdmType_","_VisitusStatus_","_Epissubtype
	s Para=""
	s (AdmRoom,AdmBed,AdmCate,AdmRefDocListDR,AdmDiagnosCatRowId,AdmInPatNo,AdmSrcDr,FirstOrReadmis,InsuCoRowid,BLFlag)=""
	s AdmDate=+$h,AdmTime=$p($h,",",2),AdmDoc="",CreateUser=%session.Get("LOGON.USERID")
	s:AdmType="" AdmType="I"
	s:VisitusStatus="" VisitusStatus="P" //住院证预约
	i IPBookID'="" d
	.d  &sql(select EpisodeIDTo into:EpisodeIDTo from SQLUser.DHCDocIPBooking where %id=:IPBookID)
	b ;EpisodeIDTo
	q:$g(EpisodeIDTo)'="" EpisodeIDTo
	s $P(Para,"^",1)=PatientID
	s $P(Para,"^",2)=AdmType
	s $P(Para,"^",3)=AdmDate
	s $P(Para,"^",4)=AdmTime
	s $P(Para,"^",5)=AdmDep
	s $P(Para,"^",6)=AdmDoc
	i AdmReason="" 	s $P(Para,"^",7)=1
	e  s $P(Para,"^",7)=AdmReason
	s $P(Para,"^",8)=CreateUser
	s $P(Para,"^",9)=AdmWard
	s $P(Para,"^",10)=AdmRoom
	s $P(Para,"^",11)=AdmBed
	s $P(Para,"^",12)=Epissubtype
	s $P(Para,"^",13)=AdmCate
	s $P(Para,"^",14)=AdmRefDocListDR
	s $P(Para,"^",15)=AdmDiagnosCatRowId
	s $P(Para,"^",17)=AdmInPatNo
	s $P(Para,"^",18)=AdmSrcDr   //病人来源PAADMAdmSrcDR / PAADM_AdmSrc_DR
	s $P(Para,"^",19)=FirstOrReadmis
	s $P(Para,"^",20)=InsuCoRowid
	s $P(Para,"^",21)=BLFlag ;是否取病历标志
	s $P(Para,"^",23)=VisitusStatus
	s EpisodeID=##class(web.DHCPAADM).ADMInsert(Para)
	i IPBookID'="" d
	.d  &sql(update SQLUser.DHCDocIPBooking  set EpisodeIDTo=:EpisodeID where %id=:IPBookID)
	q $g(EpisodeID)
}

/// Creator:      yl
/// CreatDate:    2012.09.01
/// Description:  获取挂号费
/// Table:        
/// Input:        DoctorID医生ID ,LocationID科室ID,SessionTypeRowId职称 AdmDate 出诊日期 TimeRangeRowID出诊时段
/// Return:       挂号费
ClassMethod GetRegFee(DoctorID, LocationID, SessionTypeRowId As %String = "", AdmDate As %String, TimeRangeRowID As %String) As %String
{
	s ^YLGetRegFee="w ##class(web.BriefEntry).GetRegFee("_DoctorID_","_LocationID_","_SessionTypeRowId_","_AdmDate_","_TimeRangeRowID
	s ScheduleID=""	
	
    d FindScheduleID	
    //特需心内科倪超 正教授 300
    //s:(DoctorID=141)&&(LocationID=140) ScheduleID=""
	i ScheduleID=""{
	    i SessionTypeRowId="" {
		    //从模板获取职称
	    	s ResRowId=$o(^RB("RES",0,"CTPCP",DoctorID,LocationID,""))
			s RBResEffDateChildsub=0
			f  s RBResEffDateChildsub=$O(^RB("RES",ResRowId,"DATE",RBResEffDateChildsub)) q:RBResEffDateChildsub=""  d
			.s SESSChildsub=0
			.s SESSChildsub=$o(^RB("RES",ResRowId,"DATE",RBResEffDateChildsub,"SESS",SESSChildsub)) q:((SESSChildsub="")||(SessionTypeRowId'=""))  d
			..s:SessionTypeRowId="" SessionTypeRowId=$p(^RB("RES",ResRowId,"DATE",RBResEffDateChildsub,"SESS",SESSChildsub),"^",9)
	    }
	    b ;Find SessTypeRowID
		s ArcimIdStr=""
		i SessionTypeRowId="" {
		 s ASChildsub=0
		 f  s ASChildsub=$o(^RBAS(ResRowId,ASChildsub)) q:((ASChildsub="")||(SessionTypeRowId'=""))  d
		 .s:SessionTypeRowId="" SessionTypeRowId=$p(^RBAS(ResRowId,ASChildsub,"DHC"),6)
	 	}
	 	//TXNFMKMZ-特需内分泌科门诊  潘慧 
		s:(DoctorID=3146)&&(LocationID=166) SessionTypeRowId=12
		//s:(DoctorID=141)&&(LocationID=140) SessionTypeRowId=4
		i SessionTypeRowId'="" {
			s Child=0 f  s Child=$O(^RBC("SESS",SessionTypeRowId,"SER",Child)) q:(Child="")  d
			.s ArcimId=$p(^RBC("SESS",SessionTypeRowId,"SER",Child),"^",1)
			.i ArcimIdStr="" s ArcimIdStr=ArcimId
			.e  s ArcimIdStr=ArcimIdStr_"^"_ArcimId
		}
		set Price=0
		s FeeStr="0||1||1||1||1||0||0"
		s Fee=$P(FeeStr,"||",1)
		s checkfee=$P(FeeStr,"||",2)
		s holi=$P(FeeStr,"||",3)
		s appfee=$P(FeeStr,"||",4)
		s recheckfee=$P(FeeStr,"||",6)
		s AdmReason=1,AdmDate=+$h
	    s SerIdStr=ArcimIdStr
	    i SerIdStr'="" {
		   f i=1:1:$l(SerIdStr,"^") {		
			 s ArcimId=$P(SerIdStr,"^",i)
			 i (ArcimId="") {continue}
			 ;判断挂号所涉及的费用分类性质并插入医嘱表		
			 s RegSerBillSubType=##class(web.DHCOPAdmReg).GetRegArcimBillSubType(ArcimId)
			 ;诊查费
			 i (RegSerBillSubType="Check")&&((checkfee=0)!(checkfee="")) {continue}
			 ;复诊诊查费
			 i (RegSerBillSubType="ReCheck")&&((recheckfee=0)!(recheckfee="")) {continue}
			 ;收复诊费则不收诊查费
			 i (RegSerBillSubType="Check")&&((recheckfee'=0)&&(recheckfee'="")) {continue}
			 i (RegSerBillSubType="App")&&((appfee=0)!(appfee="")) {continue}
			 i (RegSerBillSubType="Holi")&&((holi=0)!(holi="")) {continue}
			 s BillPrice=$p(##Class(web.UDHCJFPRICE).GetOrderPrice("",AdmReason,ArcimId,AdmDate,"","","",""),"^",4)
	    
			 s Price=Price+BillPrice
	 	}
	 }
	}else{
		s DocResValue=##class(web.DHCOPAdmReg).GetMarkRegFee(ScheduleID,1,"")	
		s RegFee=$p(DocResValue,"^",12)
	    s CheckFee=$p(DocResValue,"^",14)
		s HoliFee=$p(DocResValue,"^",16)
		s AppFee=$p(DocResValue,"^",18)
		s mrfee=0
		s ReCheckFee=$p(DocResValue,"^",15)
		s CardFee=0
		s OtherFee=$p(DocResValue,"^",20)
		s FeeStr=RegFee_"||"_CheckFee_"||"_HoliFee_"||"_AppFee_"||"_mrfee_"||"_ReCheckFee_"||"_CardFee
		s Price=+RegFee+CheckFee+HoliFee+AppFee+ReCheckFee+CardFee+OtherFee
	}
	Q Price
FindScheduleID
    b ;FindScheduleID
	s ResRowId=$o(^RB("RES",0,"CTPCP",DoctorID,LocationID,""))
	s AdmTime=""
	i TimeRangeRowID=1 d
	.s SelectTRQuery=1
	i TimeRangeRowID=2 d
	.s SelectTRQuery=1
	s:AdmDate["-" AdmDate=$Zdh(AdmDate,3)
	s ASRowIdStr=##Class(web.DHCRBApptSchedule).GetAvailRA(ResRowId,AdmDate,AdmTime,TimeRangeRowID,SelectTRQuery,1)
	i (ASRowIdStr'="")&&(ASRowIdStr'["^") d
	.s ASIrregularFlag=$p(^RBAS(+ASRowIdStr,$p(ASRowIdStr,"||",2)),"^",13)	
	.s ScheduleID=ASRowIdStr
	q ""
}

//获取星期几

ClassMethod GetWeekOfDate(Date)
{
    Q:Date'["/" ""
    Q $zd($zdh(Date,4),10)
}

/// Creator:      yl
/// CreatDate:    2012.08.20
/// Description:  体检VIP预约加号
/// Table:        RB_ApptSchedule
/// Input:        LocationID科室ID ,PatientID 病人RowID CardNo卡号 
/// Return:       1:成功 2没有排班 3  获取挂号费失败 5 加号失败 4挂号失败
ClassMethod SavePhysicalApp(LocationID, DoctorID, PatientID, CardNo, TimeRangeRowID, AdmDate As %String = "", PayModeCode As %String = "")
{
	s $zt="PhyisicalAppError"
	s insert="",success=0,ASIrregularFlag="",RegResult="",SessionTypeID=""
    s UserRowID=%session.Get("LOGON.USERID")
	q:$d(^RB("RES",0,"CTPCP",DoctorID))'=10 0
	q:$d(^RB("RES",0,"CTPCP",DoctorID,LocationID))'=10 0
    k ^PhyisicalApp
	s ^PhyisicalApp=LocationID_","_DoctorID_","_PatientID_","_CardNo_","_TimeRangeRowID_","_AdmDate_","_PayModeCode
	
	i TimeRangeRowID=1 d
	.s SelectTRQuery=1,BookNum="",TotalNum=1,OverBookNum=0 //加号数
	i TimeRangeRowID=2 d
	.s SelectTRQuery=1

	s:AdmDate="" AdmDate=+$h
	s:AdmDate["-" AdmDate=$zdh(AdmDate,3)
	s AdmTime=""
	s tmpTRowid=TimeRangeRowID
	s ResRowId=$o(^RB("RES",0,"CTPCP",DoctorID,LocationID,""))
	s ^PhyisicalApp("ResRowId")=ResRowId

	//tstart
	s ASRowIdStr=##Class(web.DHCRBApptSchedule).GetAvailRA(ResRowId,AdmDate,AdmTime,tmpTRowid,SelectTRQuery)
	s ^PhyisicalApp("ASRowIdStr")=ASRowIdStr
	i (ASRowIdStr'="")&&(ASRowIdStr'["^") d
	.s ASIrregularFlag=$p(^RBAS(+ASRowIdStr,$p(ASRowIdStr,"||",2)),"^",13)	
	.s RBApptScheduleID=ASRowIdStr
	.//护士加号
	.s DocAddResult=##class(web.DHCOPAdmReg).OPAppDocBroker("","",PatientID,RBApptScheduleID,"",UserRowID,"NURSEADD","","")
	.s ^PhyisicalApp("DocAddResult")=DocAddResult
    .b ;DOCADD
	.i $p(DocAddResult,"^",1)=0 d
	..s (ResRowId,AdmReason,QueueNo,FeeStr,AccRowId,user,group,AdmType,DiagnosCatRowId,FreeRegFlag,FreeCheckFlag,RegfeeRowId,InsuJoinStr,DiscountFactor, SaveType,EmployeeNo,InsuranceStr,SourceType)=""
	..s RBAppointID=$p(DocAddResult,"^",2)
	..s RegPatientID=PatientID_"^N"
	..s AdmReason=1 //自费
	..s user=UserRowID
	..s group=%session.Get("LOGON.GROUPID") 
	..s SaveType="Reg"
	..s PayModeCode=PayModeCode_"^^"_LocationID_"^"_%session.Data("LOGON.HOSPID")
	..s DocResValue=##class(web.DHCOPAdmReg).GetMarkRegFee(RBApptScheduleID,1,PatientID)
	..b ;DocResValue
	..s RegFee=$p(DocResValue,"^",12)
    ..s CheckFee=$p(DocResValue,"^",14)
	..s HoliFee=$p(DocResValue,"^",16)
	..s AppFee=$p(DocResValue,"^",18)
	..s mrfee=0
	..s ReCheckFee=$p(DocResValue,"^",15)
	..s CardFee=""
	..s OtherFee=$p(DocResValue,"^",20)
	..s FeeStr=RegFee_"||"_CheckFee_"||"_HoliFee_"||"_AppFee_"||"_mrfee_"||"_ReCheckFee_"||"_0
	..s ^PhyisicalApp("FeeStr")=FeeStr
	..s:RegFee="" success=3
	..q:success=3 //挂号费失败
	..s SourceType="HIS"
	..s ^PhyisicalApp("OPRegistBroker")=RegPatientID_","_RBApptScheduleID_","_AdmReason_","_QueueNo_","_FeeStr_","_PayModeCode_","_AccRowId_","_user_","_group_","_AdmType_","_DiagnosCatRowId_","_FreeRegFlag_","_FreeCheckFlag_","_RegfeeRowId_","_InsuJoinStr_","_DiscountFactor_","_SaveType_","_EmployeeNo_","_InsuranceStr_","_SourceType
	..b ;挂号开始
	..s RegResult=##class(web.DHCOPAdmReg).OPRegistBroker(RegPatientID,ASRowIdStr_"^"_RBAppointID,AdmReason,QueueNo,FeeStr,PayModeCode,AccRowId,user,group,AdmType,DiagnosCatRowId,FreeRegFlag,FreeCheckFlag,RegfeeRowId,InsuJoinStr,DiscountFactor, SaveType,EmployeeNo,InsuranceStr,SourceType)
	..s RegResultFlag=$p(RegResult,"$",1)
	..b ;挂号结果
	..s:RegResultFlag=0 success=1
	..s:RegResultFlag'=0 success=4,^PhyisicalApp("RegErrorResult")=RegResult
	.e  d
	..i DocAddResult="-1111" d
	...s NurseAddLoad=$p(^RBAS(+ASRowIdStr,$p(ASRowIdStr,"||",2)),"^",27)
	...s success="DOCADDAuth"_NurseAddLoad //超过加号限额
	..s:DocAddResult'="-1111" success=5
	..s ^PhyisicalApp("DOCADDError",LocationID, DoctorID, PatientID, CardNo)=DocAddResult  //加号失败
	
	//trollback:success'=1
    e  d
    .s success=2 //该医生没有排班
	q:success=1 success_"RegResult"_RegResult
	q success
PhyisicalAppError
    s ^PhyisicalApp("error",$h)=$ze
    b ;error
    //trollback
    q ""
}

//w ##class(web.BriefEntry).GetAvailAddNumber("2050||24")

ClassMethod GetAvailAddNumber(ASRowId As %String) As %String
{
	    s ^GetAvailAddNumber=ASRowId
	    q:+ASRowId=0 0
		s NurseAddObj=##class(User.DHCRBApptSchedule).%OpenId(ASRowId)
		s NurseAddLoad=NurseAddObj.ASAuthAddQty	
		s ResRowId=+ASRowId
		s AdmDoc=$P($G(^RB("RES",ResRowId)),"^",2)
		s AdmDocUserRowid=$o(^SSU("SSUSR",0,"CTPCP",AdmDoc,""))
		s SpecLocAddRegFlag=##class(web.DHCDocHardCoded).IsSpecLocAddReg(+ASRowId)
		i SpecLocAddRegFlag {
			s ASLoad=$p($g(^RBAS(+ASRowId,$p(ASRowId,"||",2))),"^",8)
			i +NurseAddLoad<1 s NurseAddLoad=ASLoad
		}
		
		
		q:+NurseAddLoad=0 0
		s ApptMethodCode=""
		s ApptScheduleASChildSub=$p(ASRowId,"||",2),APPTChildSub=""
		i $d(^RBAS(ResRowId,ApptScheduleASChildSub,"APPT"))=10 d
		.f  s APPTChildSub=$o(^RBAS(ResRowId,ApptScheduleASChildSub,"APPT",APPTChildSub)) q:APPTChildSub=""  d
		..s RBApointment=^RBAS(ResRowId,ApptScheduleASChildSub,"APPT",APPTChildSub)
		..s APPTMethodDR=$P(RBApointment,"^",12)
		..s:APPTMethodDR'="" ApptMethodCode=$p($g(^RBC("APTM",APPTMethodDR)),"^",1)
		..s APPTTransUserDR=$P(RBApointment,"^",11)
		..s APPTStatus=$P(RBApointment,"^",3)
		..q:APPTStatus="X"
		..s AdmStatus=""
		..s APPTAdmDR=$p(RBApointment,"^",4)
		..i APPTAdmDR'="" s AdmStatus=$P(^PAADM(APPTAdmDR),"^",20)
		..q:AdmStatus="C"
		..s:((APPTTransUserDR'=AdmDocUserRowid)&&(ApptMethodCode="DOCADD")) NurseAddLoad=NurseAddLoad-1
		s:+NurseAddLoad<0 NurseAddLoad=0
		q NurseAddLoad
}

Query OPDocList(Dept As %String = "", IsAppFlag As %String = "") As %Query(ROWSPEC = "ASRowId:%String,MarkDesc:%String,Load:%String,AppLoad:%String,AddLoad:%String,AvailSeqNoStr:%String,AvailAddSeqNoStr:%String,RoomDesc:%String,ClinicGroupDesc:%String,SessionTypeDesc:%String,RegFee:%String,RegFeeDr:%String,ExamFee:%String,ReCheckFee:%String,HoliFee:%String,HoliFeeDr:%String,AppFee:%String,AppFeeDr:%String,RoomCode:%String,DepDesc:%String,RegedCount:%String,AppedCount:%String,AddedCount:%String,AvailNorSeqNoStr:%String,ScheduleStatus:%String,ScheduleDate:%String,ScheduleDateWeek:%String,TimeRange:%String,TotalFee:%String,NurseAdd:%String")
{
}

ClassMethod OPDocListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = OPDocListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

//d ##class(%ResultSet).RunQuery("web.BriefEntry","OPDocList","^3881^^^1^2121^^^^2^^^N^N","")

ClassMethod OPDocListExecute(ByRef qHandle As %Binary, Dept As %String = "", IsAppFlag As %String = "") As %Status
{
	k ^CustomOPDocList
	s ^CustomOPDocList=Dept_","_IsAppFlag	
	set $zt="CustomOPDocList"

	Set repid=$I(^CacheTemp)	
	If $g(ind)="" Set ind=1
	s QHandle=$lb(0,repid,0)
	Set rset=##class(%ResultSet).%New("web.DHCOPAdmReg:OPDocList")
	do rset.Execute(Dept,IsAppFlag)
	   
		While (rset.Next()) {
	      
	        set MarkDesc=rset.Data("MarkDesc")
	        set RoomDesc=rset.Data("RoomDesc")
	        set ClinicGroupDesc=rset.Data("ClinicGroupDesc")
	        set SessionTypeDesc=rset.Data("SessionTypeDesc")
	        set Load=rset.Data("Load")
	        set AppLoad=rset.Data("AppLoad")
	        set AddLoad=rset.Data("AddLoad")
	        set AvailAddSeqNoStr=rset.Data("AvailAddSeqNoStr")
	        set AvailAddSeqNoStr=rset.Data("AvailAddSeqNoStr")
	        set RegFee=rset.Data("RegFee")
	        set ExamFee=rset.Data("ExamFee")
	        set AppFee=rset.Data("AppFee")
	        set ReCheckFee=rset.Data("ReCheckFee")
	        set RoomCode=rset.Data("RoomCode")
	        set DepDesc=rset.Data("DepDesc")
	        set AppedCount=rset.Data("AppedCount")
	        set RegedCount=rset.Data("RegedCount")
	        set ScheduleStatus=rset.Data("ScheduleStatus")
	        set AvailNorSeqNoStr=rset.Data("AvailNorSeqNoStr")
	        set TimeRange=rset.Data("TimeRange")
	        set AddedCount=rset.Data("AddedCount")
	        set HoliFee=rset.Data("HoliFee")
	        set HoliFeeDr=rset.Data("HoliFeeDr")
	        set AppFee=rset.Data("AppFee")
	        set AppFeeDr=rset.Data("AppFeeDr")
	        set ASRowId=rset.Data("ASRowId")
	        set ScheduleDate=rset.Data("ScheduleDate")
	        set RegedCount=rset.Data("RegedCount")
	        set AppedCount=rset.Data("AppedCount")
	        d:DepDesc["国际医疗"  &sql(select count(*) into:AppedCount from sqluser.rb_appointment where APPT_Method_DR=3 and APPT_AS_ParRef=:ASRowId and APPT_Status in ("I","A"))
	        set AddedCount=rset.Data("AddedCount")
	        set ScheduleStatus=rset.Data("ScheduleStatus")
	        set ScheduleDateWeek=rset.Data("ScheduleDateWeek")
	        set TotalFee=rset.Data("TotalFee")
	        set NurseAdd=##class(web.BriefEntry).GetAvailAddNumber(ASRowId)
	         set:ASRowId'="" ^CustomOPDocList("ASRowId",ASRowId)=NurseAdd_","_MarkDesc_","_Load_","_AppLoad
			set Data=$lb(ASRowId,MarkDesc,Load,AppLoad,AddLoad,AvailSeqNoStr,AvailAddSeqNoStr,RoomDesc,ClinicGroupDesc,SessionTypeDesc,RegFee,RegFeeDr,CheckFee,ReCheckFee,HoliFee,HoliFeeDr,AppFee,AppFeeDr,RoomCode,DepDesc,RegedCount,AppedCount,AddedCount,AvailNorSeqNoStr,ScheduleStatus,ScheduleDate,ScheduleDateWeek,TimeRange,TotalFee,NurseAdd)
			Set ^CacheTemp(repid,ind)=Data
			set ind=ind+1
		}
		d rset.%Close()
		s rset=""
		Quit $$$OK
CustomOPDocList
   set ^CustomOPDocList("error")=$ze
   b ;error
   q ""
}

ClassMethod OPDocListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = OPDocListExecute ]
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

//撤销提交或者提交所有科室 C 撤销 S 提交

ClassMethod LocSubmitAll(Type As %String = "")
{
	 s LocID=0
	 q:Type=""
	 for  s LocID=$o(^CTLOC(LocID)) q:LocID=""  d
	 .s ret=##class(web.DHCOPAdmRegQuery).LocSubmit(LocID,Type,3901)
}

ClassMethod ConvertDateByDays(CurrenDate As %String, Days As %String)
{
	q:$Length(CurrenDate,"-")'=3 CurrenDate
	s $zt="ConvertError"
	s CurrenDate=$zdh(CurrenDate,3)

	s CurrenDate=CurrenDate+Days
	s CurrenDate=$zd(CurrenDate,3)
	q CurrenDate
ConvertError
     q ""
}

//w ##class(web.BriefEntry).GetUnUsualScheudule()

ClassMethod GetUnUsualScheudule()
{
	k TMPYL
	s AdmDate=$zdh("2012-10-23",3)
	s ResRowId=0
    f  s ResRowId=$O(^RBAS(ResRowId)) q:ResRowId=""  d
    .f  s AdmDate=$O(^RBAS(ResRowId,0,"DateSTime",AdmDate))  q:AdmDate=""  d
	..s ASSessStartTime=0 
	..q:'$d(^RBAS(ResRowId,0,"DateSTime",AdmDate))
	..q:AdmDate<$zdh("2012-10-23",3)
	..f  s ASSessStartTime=$O(^RBAS(ResRowId,0,"DateSTime",AdmDate,ASSessStartTime)) q:ASSessStartTime=""  d
	...s ASChildSub=0  f  s ASChildSub=$O(^RBAS(ResRowId,0,"DateSTime",AdmDate,ASSessStartTime,ASChildSub)) q:(ASChildSub="")  d
	....s StartTime=ASSessStartTime
	....s EndTime=$P($G(^RBAS(ResRowId,ASChildSub)),"^",5)
	....s DocResValue=##class(web.DHCOPAdmReg).GetMarkRegFee(ResRowId_"||"_ASChildSub,"","")
	....s ASLoad=$P($G(^RBAS(ResRowId,ASChildSub)),"^",8)
	....s AvailNorSeqNoStr=$p(DocResValue,"^",26)
	....s CareProvID=$p($g(^RB("RES",ResRowId)),"^",2)
	....s CTLOCID=$p($g(^RB("RES",ResRowId)),"^",1)
	....s CTLocDesc=$p(^CTLOC(CTLOCID),"^",2)
	....s DocDesc=$p(^CTPCP(CareProvID,1),"^",2)
	....d Get114Count
	....d GetAppMethodCount
	....//s:(+ToatlQty)>(+ASLoad) TMPYL(AdmDate,ResRowId,ASChildSub)=ResRowId_"||"_ASChildSub_",日期"_$zd(AdmDate,3)_",科室"_CTLocDesc_","_DocDesc_",开始时间"_$zt(StartTime)_",现场剩号"_AvailNorSeqNoStr
	....//w:(+ToatlQty)>(+ASLoad) ResRowId_"||"_ASChildSub_",日期"_$zd(AdmDate,3)_",科室"_CTLocDesc_","_DocDesc_",开始时间"_$zt(StartTime)_",现场剩号"_AvailNorSeqNoStr,!
	....//w:(+AvailNorSeqNoStr<0) ResRowId_"||"_ASChildSub_",日期"_$zd(AdmDate,3)_",科室"_CTLocDesc_","_DocDesc_",开始时间"_$zt(StartTime)_",现场剩号"_AvailNorSeqNoStr_",114"_count, !
	....//w:(+AvailNorSeqNoStr<0) ToatlQty_","_ASLoad,!
	....s:(+AvailNorSeqNoStr<0) TMPYL(AdmDate,ResRowId,ASChildSub)=ResRowId_"||"_ASChildSub_",日期"_$zd(AdmDate,3)_",科室"_CTLocDesc_","_DocDesc_",开始时间"_$zt(StartTime)_",现场剩号"_AvailNorSeqNoStr
	s (a,b,c)=0
    for  s a=$O(TMPYL(a)) q:a=""  d
    .f  s b=$O(TMPYL(a,b)) q:b=""  d
    ..f  s c=$O(TMPYL(a,b,c)) Q:c=""  d
    ...w TMPYL(a,b,c),!
	q ""
Get114Count
    s count=0
	s APPTChildSub=0
    f  s APPTChildSub=$O(^RBAS(ResRowId,ASChildSub,"APPT",APPTChildSub)) q:APPTChildSub=""  d
    .s APPTMethodDR=$P(^RBAS(ResRowId,ASChildSub,"APPT",APPTChildSub),"^",12)
	.s:APPTMethodDR'="" ApptMethodCode=$p($g(^RBC("APTM",APPTMethodDR)),"^",1)
    .s APPTStatus=$P(^RBAS(ResRowId,ASChildSub,"APPT",APPTChildSub),"^",3)
	.s:(ApptMethodCode=114)&&(APPTStatus="I") count=count+1
GetAppMethodCount
    s (ASQChildsub,AQQty,ToatlQty)=0    
    f  s ASQChildsub=$o(^RBAS(ResRowId,ASChildSub,"AQ",ASQChildsub)) q:ASQChildsub=""  d
    .s AQQty=$P(^RBAS(ResRowId,ASChildSub,"AQ",ASQChildsub),"^",2)
    .s ToatlQty=ToatlQty+AQQty
}

//自动生成提前挂号例外日期

ClassMethod AutoCreateExceptionDate(WeekCount As %String = "")
{
	s datecount=+$h
	s end=(+$h+(WeekCount*7))
	for datecount=+$h:1:(+$h+(WeekCount*7)) d
	.s week=$zd(datecount,10)
	.s:((week=0)||(week=6)) ^DHCOPRegConfig("DHCOPInAdvance","ExceptionDate",datecount)=""
	q ""
}

ClassMethod SetTimeInterval()
{
	s CTLocID=0
	s RESRowId=""
	f  s CTLocID=$o(^RB("RES",0,"CTLOC",CTLocID)) q:CTLocID=""  d
	.s LocDesc=$P(^CTLOC(CTLocID),"^",2)
	.q:LocDesc'["国际医疗"
	.f  s RESRowId=$o(^RB("RES",0,"CTLOC",CTLocID,RESRowId))	q:RESRowId=""  d
	..//q:'$d(^RB("RES",RESRowId,"DHC"))
    ..s $p(^RB("RES",RESRowId,"DHC"),"^",18)="Y"
}

//获取医生是否有执业医师资格证号方法

ClassMethod CheckIfHasDoctorAuth(DoctorID As %String = "", ResRowID As %String = "")
{
	q:(DoctorID="")&&(ResRowID="") 1
	q:((DoctorID'="")&&('$d(^SSU("SSUSR",0,"CTPCP",DoctorID)))) 1
	i DoctorID'=""{
		s SSUSRRowId=$O(^SSU("SSUSR",0,"CTPCP",DoctorID,""))
		q:SSUSRRowId="" 1
		s UserCoce=$P($g(^SSU("SSUSR",SSUSRRowId)),"^",1)
		q +##Class(web.INSUDicDataCtl).QueryByCodeNB("DocCodeCon",UserCoce)
	}
	i ResRowID'=""{
		
		q:'$d(^RB("RES",ResRowID)) 1
		set DoctorID=$p($g(^RB("RES",ResRowID)),"^",2)
		q:'$d(^SSU("SSUSR",0,"CTPCP",DoctorID)) 1
		s SSUSRRowId=$O(^SSU("SSUSR",0,"CTPCP",DoctorID,""))
		q:SSUSRRowId="" 1
		s UserCoce=$P($g(^SSU("SSUSR",SSUSRRowId)),"^",1)
		q +##Class(web.INSUDicDataCtl).QueryByCodeNB("DocCodeCon",UserCoce)
	}
}

}
