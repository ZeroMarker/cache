Class web.DHCDocMainOut Extends DHCDoc.Util.RegisteredObject
{

ClassMethod GetLimirDay(CalDate, Limit) As %String
{
	q:CalDate="" ""
	q:Limit="" CalDate
	if CalDate'="" s CalDate=..%ZDH(CalDate)
	if (Limit<CalDate)  s CalDate=CalDate-Limit
	s CalDate=$zd(CalDate,3)
	q CalDate
}

/// d ##class(%ResultSet).RunQuery("web.DHCDocMainOut","FindCurrentAdmProxy","","0000000099","","","O","","2018-03-22","2018-03-22","on","","","","","")
Query FindCurrentAdmProxy(Type As %String = 0, PatientNo As %String = "", Name As %String = "", MedicalNo As %String = "", PAADMType As %String = "I", CardNo As %String = "", OutStartDate As %Date = "", OutEndDate As %Date = "", OutArrivedQue As %String = "", OutRegQue As %String = "", OutConsultation As %String = "", OutAllPatient As %String = "", AdmReqNo As %String = "", MarkID As %String = "") As websys.Query(ROWSPEC = "PatientID:%String,EpisodeID:%String,mradm:%String,PAPMINO:%String:登记号,PAPMIName:%String:姓名,PAPMIDOB:%String:出生日期,PAPMISex:%String:性别,PAAdmDate:%String:就诊日期,PAAdmTime:%Time:就诊时间,PAAdmNo:%String:就诊号,PAAdmDepCodeDR:%String:就诊科室,PAAdmDocCodeDR:%String:医生,PAAdmType:%String:就诊类型,Hospital:%String:医院,PAAdmWard:%String:病房,PAAdmBed:%String:床号^50,FinancialDischargeFlag:%String,MedicalDischargeFlag:%String,FinalDischargeFlag:%String:最终结算标志,PAAdmReason:%String:病人类型,DischargeDate:%String:出院日期,RegDoctor:%String:号别,Diagnosis:%String:诊断,ArrivedDate:%String:到达日期,ArrivedTime:%String:到达时间,LeavedDate:%String:离开日期,LeavedTime:%String:离开时间,LocSeqNo:%String:序号,PAAdmPriority:%String:优先级,WalkStatus:%String:状态,ConsultRoom:%String:诊室,ConsultArea:%String:诊区,PAAdmReasonCode:%String,StatusCode:%String,Age:%String:年龄,PriorityCode:%String,Called:%String,RegDocDr:%String,TPoliticalLevel:%String:病人级别,TSecretLevel:%String:病人密级,RegRangeTime:%String:时段,Patcdinfo:%String,Totalmoey:%String:总费用,PatTelNo:%String:电话^110,IconProfile:%String:图标菜单,Arrived:%String:到达,Transfer:%String:转诊,BGColor:%String,RegAdmSource:%String:来源,APPTTransUser:%String:预约人")
{
}

ClassMethod FindCurrentAdmProxyExecute(ByRef qHandle As %Binary, Type As %String = 0, PatientNo As %String = "", Name As %String = "", MedicalNo As %String = "", PAADMType As %String = "I", CardNo As %String = "", OutStartDate As %Date = "", OutEndDate As %Date = "", OutArrivedQue As %String = "", OutRegQue As %String = "", OutConsultation As %String = "", OutAllPatient As %String = "", AdmReqNo As %String = "", MarkID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	s (AllPatient,ArrivedQue,MedUnit,HisPat,WardFlag)=""
	s ^Temp("FindCurrentAdmProxy")=$lb(Type , PatientNo , Name , MedicalNo , PAADMType, CardNo , OutStartDate , OutEndDate , OutArrivedQue , OutRegQue, OutConsultation , OutAllPatient)
	s LocID=%session.Get("LOGON.CTLOCID")
	Set UserID=%session.Get("LOGON.USERID")
	s GroupID=%session.Get("LOGON.GROUPID")
	S CONTEXT =$g(%session.Data("CONTEXT"))
	s:Type="" Type=0
	k ^||OrderByBed,^||OrderByNullBed
	if OutStartDate["-" Set OutStartDate=$zdh(OutStartDate,3)
	if OutEndDate["-" Set OutEndDate=$zdh(OutEndDate,3)
	i OutStartDate'="" s OutStartDate=..%ZDH(OutStartDate)
    i OutEndDate'="" s OutEndDate=..%ZDH(OutEndDate)
	if (((PatientNo="") && (Name="") && (MedicalNo="") && (CardNo=""))||(PAADMType="O")||(PAADMType="E")){	
			#dim rs As %ResultSet
			set StartDate=..%SysDate(),EndDate=..%SysDate()
			if (PAADMType="O"){
				s rs = ##class(%ResultSet).%New("web.DHCDocOutPatientList:FindLocDocCurrentAdm")
				d rs.Execute(LocID,UserID,"",OutAllPatient,PatientNo,Name,$g(OutStartDate),$g(OutEndDate),OutArrivedQue,OutRegQue,OutConsultation,MarkID)
			}elseif (PAADMType="E"){
				s rs = ##class(%ResultSet).%New("web.DHCDocOutPatientList:FindLocDocCurrentAdmE")
				d rs.Execute(LocID,UserID,"",OutAllPatient,PatientNo,Name,$g(OutStartDate),$g(OutEndDate),OutArrivedQue,OutRegQue,"",MarkID)
			
			}else{
				s rs = ##class(%ResultSet).%New("web.DHCDocEmergencyPatientList:FindLocDocCurrentAdm")
				d rs.Execute(LocID,UserID,"",OutAllPatient,PatientNo,Name,$g(OutStartDate),$g(OutEndDate),OutArrivedQue,OutRegQue)	
			}
			s BGColor=""
			s columnNum = rs.GetColumnCount()
			s rowNum=0
			while(rs.Next()){
				s rowNum = rowNum+1
				s rowData=""
				f i=1:1:columnNum  s $list(rowData,i)=rs.GetData(i)
				s bed = rs.GetDataByName("PAAdmBed")
				s EpisodeID = rs.GetDataByName("EpisodeID")
				s PatientID = rs.GetDataByName("PatientID")
				if EpisodeID="" continue
				s LocSeqNo = rs.GetDataByName("LocSeqNo")
				continue:(AdmReqNo'="")&&(AdmReqNo'=LocSeqNo)

				set Deposit=##class(web.UDHCJFBaseCommon).deposit(EpisodeID)
				set Amount=##class(web.UDHCJFCKD).totalamount(EpisodeID)
				set Charge=##class(web.DHCDocOrderCommon).GetCurrentDeposit(EpisodeID)
				if ((PAADMType="O")||(PAADMType="E")) {
				    if (OutRegQue="on")&&($list(rowData,30)="到达") continue
				    //到达
					s $list(rowData,columnNum+5)= $zcvt("<A><img style='cursor:pointer' SRC='../images/websys/update.gif' BORDER='0' onclick=SetPatArrived()></A>","O","HTML")
					if $list(rowData,30)="过号"{
						//s $list(rowData,5)="<A style='cursor:pointer' onclick=GHCallPatient()>"_$list(rowData,5)_"</A>"
					}else{
						s $list(rowData,5)=$zcvt("<A style='cursor:pointer;color:red' onclick=GHCallPatient()>"_$list(rowData,5)_"</A>","O","HTML")
						s $list(rowData,28)=$zcvt("<A style='cursor:pointer;color:red' >"_$list(rowData,28)_"</A>","O","HTML")
					}
					if $list(rowData,30)="到达" s $list(rowData,30)="已诊"  /// mark 20160831 
					s $list(rowData,columnNum+4)= $zcvt(##class(web.DHCDocMain).ShowIcon("MAP",EpisodeID_"^^^"_PatientID,CONTEXT),"O","HTML")	//加图表菜单
				    s $list(rowData,columnNum+2)= Amount
				    s PatTelNo=$p($g(^PAPER(PatientID,"PER",1)),"^",11)
					s PatMobil=$p($g(^PAPER(PatientID,"PER",4)),"^",21)
					if PatTelNo="" s PatTelNo=PatMobil
					s $list(rowData,columnNum+3)= PatTelNo
					//就诊号->挂号表
					s RegRowId="",RegfeeRBASDr="",APPTRowId=""
					s RegRowId=$o(^User.DHCRegistrationFeeI("ADM",EpisodeID,0))
					//挂号表->排班表
					i RegRowId'=""  s RegfeeRBASDr=$list(^User.DHCRegistrationFeeD(RegRowId),18) 
					//排班表->预约表
					i RegfeeRBASDr'=""  s APPTRowId=$o(^RBAS("ADM",EpisodeID,+RegfeeRBASDr,$p(RegfeeRBASDr,"||",2),0))
					i APPTRowId'=""{
						s APPTTransUserDr=$p(^RBAS(+RegfeeRBASDr,$p(RegfeeRBASDr,"||",2),"APPT",APPTRowId),"^",11)
						s CTPCPRowId=$p(^SSU("SSUSR",APPTTransUserDr),"^",14)
						i CTPCPRowId=""  s CTPCPDesc=$p(^SSU("SSUSR",APPTTransUserDr),"^",2)
						e  s CTPCPDesc=$p(^CTPCP(CTPCPRowId,1),"^",2)
						s $list(rowData,columnNum+9)= CTPCPDesc
					}					
				}else{
					s $list(rowData,columnNum+2)= $zcvt(##class(web.DHCDocMain).ShowIcon("MAP",EpisodeID_"^^^"_PatientID,CONTEXT),"O","HTML")	//加图表菜单
				}
				//转诊
				s $list(rowData,columnNum+6)= $zcvt("<A><img style='cursor:pointer' SRC='../images/websys/update.gif' BORDER='0' onclick=PatTransfer()></A>","O","HTML")
				s PAAdmWard=rs.GetDataByName("PAAdmWard")
				s BGColor=""
				Set Loc=$P($g(^PAADM(EpisodeID)),"^",4)
				s TransAdmFlag=..checkIsTransAdm(EpisodeID,Loc)
				i TransAdmFlag=1 {
					s BGColor="#00ff04"
					s $list(rowData,5)=$list(rowData,5)_"(转)"
				}
				;lxz 获取展示的颜色
				if BGColor="" d
				.s BGColor=..GetDisPlayColor(EpisodeID)
				
				
				s RegAdmSource=..GetRegAdmSource(EpisodeID)
				//缴费情况
				i $g(^DHCDocLocalSysP("Doc.Mouth.Group"))[("^"_GroupID_"^") {
					s PaySit=..GetPaySit(EpisodeID,UserID,LocID)
					i PaySit'="" s $list(rowData,4)="【"_PaySit_"】"_$list(rowData,4)
					
				}
				
				if (PAADMType="O")||(PAADMType="E") {
					s ^||OrderByNullBed(" "_PAAdmWard,rowNum)=rowData_$LB(BGColor)_$LB(RegAdmSource)   //_$LB("123",Deposit,Amount,Charge)
				}else{
					i bed="" s ^||OrderByNullBed(" "_PAAdmWard,EpisodeID)=rowData_$LB("","123",Deposit,Amount,Charge)_$LB(RegAdmSource)  //by houjian
					e  s ^||OrderByBed(" "_PAAdmWard," "_bed,EpisodeID)=rowData_$LB("","123",Deposit,Amount,Charge)_$LB(RegAdmSource)
				}
			}
			d rs.%Close()
			s rs = ""
		
	}else{	
	b //45
		if (PatientNo'=""){
			//登记号查询
			Set PAPMI=$O(^PAPERi("PAPMI_PatNo",PatientNo,""))
			if $g(PAPMI)="" Set qHandle=$lb(0,repid,0)	Quit $$$OK
			Set PAAdm="", CurrentAdmType=PAADMType
			For  Set PAAdm=$O(^PAPERdr(PAPMI,"ADM",CurrentAdmType,PAAdm)) Quit:PAAdm=""  Do
			.Set AdmDate=$p(^PAADM(PAAdm),"^",6)
			.//Quit:(AdmDate<OutStartDate)||(AdmDate>OutEndDate)
			.d OutputRow
		}Elseif (MedicalNo'=""){
			b
			Set PAPMI="", CurrentAdmType=PAADMType
			For  Set PAPMI = $O(^PAPERi("Medicare1",$$ALPHAUP^SSUTIL4(MedicalNo),PAPMI)) Q:PAPMI=""  Do
			.Set PAAdm="" For  Set PAAdm=$O(^PAPERdr(PAPMI,"ADM",CurrentAdmType,PAAdm)) Q:PAAdm=""  Do
			..Set AdmDate=$p(^PAADM(PAAdm),"^",6)
			..Quit:(AdmDate<OutStartDate)||(AdmDate>OutEndDate)
			..d OutputRow
		}ELSEIF (Name'=""){
			Set PAPMI="", CurrentAdmType=PAADMType
			For  Set PAPMI = $O(^PAPERi("PAPER_PatName",$$ALPHAUP^SSUTIL4(Name),PAPMI)) Q:PAPMI=""  Do
			.Set PAAdm="" For  Set PAAdm=$O(^PAPERdr(PAPMI,"ADM",CurrentAdmType,PAAdm)) Q:PAAdm=""  Do
			..Set AdmDate=$p(^PAADM(PAAdm),"^",6)
			..Quit:(AdmDate<OutStartDate)||(AdmDate>OutEndDate)
			..d OutputRow
		}ELSEIF (CardNo'=""){
			Set CFRowID="", PAPMI="", CurrentAdmType=PAADMType
			Set CFRowID = $o(^DHCCARDi("CF",0,"CardNo",$$ALPHAUP^SSUTIL4(CardNo),CFRowID))
			if (CFRowID'=""){
				Set ActiveFlag = $p(^DHCCARD("CF",CFRowID),"^",10)
				if ("N"=ActiveFlag){
					Set PAPMI = $p(^DHCCARD("CF",CFRowID),"^",4)
					Set PAAdm="" For  Set PAAdm=$O(^PAPERdr(PAPMI,"ADM",CurrentAdmType,PAAdm)) Q:PAAdm=""  Do
					.Set AdmDate=$p(^PAADM(PAAdm),"^",6)
					.Quit:(AdmDate<OutStartDate)||(AdmDate>OutEndDate)
					.d OutputRow
				}
			}
		}
	}
	;输出病人列表信息
	s wardDesc="" for  s wardDesc = $o(^||OrderByBed(wardDesc)) q:wardDesc=""  d
	.s bedind=0 for  s bedind=$o(^||OrderByBed(wardDesc ,bedind)) q:bedind=""  d
	..s subind="" f   s subind=$o(^||OrderByBed(wardDesc ,bedind,subind)) q:subind=""  d
	...s ^CacheTemp(repid,ind) = ^||OrderByBed(wardDesc ,bedind,subind)
	...s ind=ind+1
	
	s wardDesc="" for  s wardDesc = $o(^||OrderByNullBed(wardDesc)) q:wardDesc=""  d
	.s subind="" f   s subind=$o(^||OrderByNullBed(wardDesc,subind)) q:subind=""  d
	..s ^CacheTemp(repid,ind) = ^||OrderByNullBed(wardDesc,subind)
	..s ind=ind+1

	Set qHandle=$lb(0,repid,0)	
	Quit $$$OK
findAdmTransWard(PAAdm,WardID)
	s find=0
	s child=0 f {
		s child=$O(^PAADM(PAAdm,"TRANS",child))
		Q:child=""
		s TransWardID=$P(^PAADM(PAAdm,"TRANS",child),"^",9)
		if TransWardID=WardID {
			s find=1
			Quit
		}
	}
	Q find
ResetVariables
	Set (PatientID,EpisodeID,mradm,PAPMINO,PAPMIName,PAPMIDOB,PAPMISex,PAAdmDate,PAAdmTime,PAAdmNo,PAAdmDepCodeDR,PAAdmDocCodeDR,PAAdmType,Hospital,PAAdmWard,PAAdmBed,FinancialDischargeFlag,MedicalDischargeFlag,FinalDischargeFlag,PAAdmReason,DischargeDate,Diagnosis,RegDoctor,ArrivedDate,ArrivedTime,LeavedDate,LeavedTime,LocSeqNo,PAAdmPriority,WalkStatus,ConsultRoom,ConsultArea,PAAdmReasonCode,StatusCode,PAPMIAge,PriorityCode,Called,RegDocDr,Deposit,RegAdmSource)=""
	Quit

OutputRow
	Do ResetVariables
	//PatientID,EpisodeID,mradm
	Set PatientID=$P(^PAADM(PAAdm),"^",1)
	Set EpisodeID=PAAdm
	Set mradm=$P(^PAADM(PAAdm),"^",61)
	//PAPMINO,PAPMIName,PAPMIDOB,PAPMISex
	Set PAPMINO=$P(^PAPER(PatientID,"PAT",1),"^",1)
	Set PAPMIName=$P(^PAPER(PatientID,"ALL"),"^",1)
	Set PAPMIDOB=..%ZD($P(^PAPER(PatientID,"ALL"),"^",6)) //$ZD($P(^PAPER(PatientID,"ALL"),"^",6),3)
	Set Sex=$P(^PAPER(PatientID,"ALL"),"^",7)
	Set PAPMISex=$P($g(^CT("SEX",Sex)),"^",2)
	//
	Set DobDate=$P($g(^PAPER(PatientID,"ALL")),"^",6)
	If DobDate'="" Do
	.Set PAPMIDOB=..%ZD($P(^PAPER(PatientID,"ALL"),"^",6)) //$ZD($P(^PAPER(PatientID,"ALL"),"^",6),3)
	.Set PAPMIAge=$fn((+$H-DobDate)/365,"",0)
	Else  Set PAPMIDOB="",PAPMIAge=""
	//PAAdmDate,PAAdmTime,PAAdmNo,PAAdmDepCodeDR,PAAdmDocCodeDR,PAAdmType,Hospital,PAAdmWard,PAAdmBed
	Set PAAdmDate=..%ZD($P($g(^PAADM(PAAdm)),"^",6)) //$ZD($P($g(^PAADM(PAAdm)),"^",6),3)
	Set PAAdmTime=..%ZT($P($g(^PAADM(PAAdm)),"^",7),3)
	set Deposit=##class(web.UDHCJFBaseCommon).deposit(PAAdm)
	//Add Date Check
	Set PAAdmNo=$P($g(^PAADM(PAAdm)),"^",81)
	Set Loc=$P($g(^PAADM(PAAdm)),"^",4)
	Set PAAdmDepCodeDR=##class(web.DHCDocInPatientList).RemoveAlias($P($g(^CTLOC(Loc)),"^",2))
	Set Doctor=$P($g(^PAADM(PAAdm)),"^",9)
	If Doctor'="" Set PAAdmDocCodeDR=$P($g(^CTPCP(Doctor,1)),"^",2)
	Else  Set PAAdmDocCodeDR=""
	Set PAAdmType=$P($g(^PAADM(PAAdm)),"^",2)
	Set Hosp=$P($g(^CTLOC(Loc)),"^",22)
	If Hosp'="" Set Hospital=$P($g(^CT("HOSP",Hosp)),"^",2)
	Set WardDr=$P($g(^PAADM(PAAdm)),"^",70)
	if WardDr'="" Set PAAdmWard=##class(web.DHCDocInPatientList).RemoveAlias($P($g(^PAWARD(WardDr)),"^",2))
	else  Set PAAdmWard=""
	Set BedId=$P($g(^PAADM(PAAdm)),"^",73)
	if BedId'="" Set PAAdmBed=$P($g(^PAWARD(+BedId,"BED",$P(BedId,"||",2))),"^",1)
	else  Set PAAdmBed="" 
	//FinancialDischargeFlag,MedicalDischargeFlag,FinalDischargeFlag,PAAdmReason,DischargeDate,Diagnosis
	Set FinancialDischargeFlag=$P($g(^PAADM(PAAdm)),"^",45)
	Set MedicalDischargeFlag=$P($g(^PAADM(PAAdm)),"^",63)
	Set PAAdmStatus=$P($g(^PAADM(PAAdm)),"^",20)
	Set FinalDischargeFlag=$S($g(PAAdmStatus)="D":"Y",1:"N")
	Set AdmReason=$P($g(^PAADM(PAAdm,1)),"^",7)
	If AdmReason'="" Set PAAdmReason=$P($g(^PAC("ADMREA",AdmReason)),"^",2),PAAdmReasonCode=$P($g(^PAC("ADMREA",AdmReason)),"^",5)
	Else  Set PAAdmReason="",PAAdmReasonCode=""
	Set DischargeDate=$P($g(^PAADM(PAAdm)),"^",17)
	s:DischargeDate'="" DischargeDate=..%ZD(DischargeDate) //$zd(DischargeDate,3)
	If mradm'="" Set Diagnosis=##class(web.DHCDocInPatientList).GetMRAdmDiagnosis(mradm) 
	Else  Set Diagnosis=""
	//RegDoctor,ArrivedDate,ArrivedTime,LeavedDate,LeavedTime,LocSeqNo,PAAdmPriority
	Set Seq=EpisodeID
	Set PatientMedicare=$p($g(^PAPER(PatientID,"PAT",1)),"^",22)   //住院号
	set IconProfile=$ZCVT(##class(web.DHCDocMain).ShowIcon("MAP",EpisodeID_"^^^"_PatientID,CONTEXT),"O","HTML")	//加图表菜单
	set Arrived="websys/update.gif"
	s Transfer= $zcvt("<A><img style='cursor:pointer' SRC='../images/websys/update.gif' BORDER='0' onclick=PatTransfer()></A>","O","HTML")
	s BGColor=""
	s TransAdmFlag=..checkIsTransAdm(EpisodeID,Loc)
	i TransAdmFlag=1 s BGColor="#00ff04",PAPMIName=PAPMIName_"(转)"
	s RegAdmSource=..GetRegAdmSource(EpisodeID)
	s QueRowId=##class(web.DHCDocOutPatientList).GetQueRowidByMore(EpisodeID,"")
	s LocSeqNo=$lg(^User.DHCQueueD(QueRowId),10)
	
	//缴费情况
	i $g(^DHCDocLocalSysP("Doc.Mouth.Group"))[("^"_GroupID_"^") {
		s PaySit=..GetPaySit(EpisodeID,UserID,LocID)
		i PaySit'="" s PAPMINO="【"_PaySit_"】"_PAPMINO
		
	}
	s TPoliticalLevel="",TSecretLevel=""
	s PatEncryptLevel=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(PatientID,.ErrMsg)
	i PatEncryptLevel'="" {
		s TPoliticalLevel=$p(PatEncryptLevel,"^",2)
		s TSecretLevel=$p(PatEncryptLevel,"^",1)
	}
	//电话
	s PatTelNo=$p($g(^PAPER(PatientID,"PER",1)),"^",11)
	s PatMobil=$p($g(^PAPER(PatientID,"PER",4)),"^",21)
	if PatTelNo="" s PatTelNo=PatMobil
	S Totalmoney=##class(web.UDHCJFCKD).totalamount(EpisodeID)
	//PatientID:%String,EpisodeID:%String,mradm:%String,PAPMINO:%String:登记号,PAPMIName:%String:姓名, 1-5 
	//PAPMIDOB:%String:出生日期,PAPMISex:%String:性别,PAAdmDate:%String:就诊日期,PAAdmTime:%Time:就诊时间, 6-9
	//PAAdmNo:%String:就诊号,PAAdmDepCodeDR:%String:就诊科室,PAAdmDocCodeDR:%String:医生, 10-12
	//PAAdmType:%String:就诊类型,Hospital:%String:医院,PAAdmWard:%String:病房,PAAdmBed:%String:床号^50, 13-16
	//FinancialDischargeFlag:%String,MedicalDischargeFlag:%String,FinalDischargeFlag:%String:最终结算标志, 17-19
	//PAAdmReason:%String:病人类型,DischargeDate:%String:出院日期,RegDoctor:%String:号别,Diagnosis:%String:诊断, 20-23
	//ArrivedDate:%String:到达日期,ArrivedTime:%String:到达时间,LeavedDate:%String:离开日期, 24-26
	//LeavedTime:%String:离开时间,LocSeqNo:%String:序号,PAAdmPriority:%String:优先级,WalkStatus:%String:状态, 27-30
	//ConsultRoom:%String:诊室,ConsultArea:%String:诊区,PAAdmReasonCode:%String,StatusCode:%String, 31-34
	//Age:%String:年龄,PriorityCode:%String,Called:%String,RegDocDr:%String,TPoliticalLevel:%String:病人级别, 35-39
	//TSecretLevel:%String:病人密级,RegRangeTime:%String:时段,Patcdinfo:%String,Totalmoey:%String:总费用, 40-43
	//PatTelNo:%String:电话^110,IconProfile:%String:图表菜单, 44-45
	//Arrived:%String:到达,Transfer:%String:转诊,BGColor:%String,RegAdmSource:%String:来源 46-49
	
	//PatientID,EpisodeID,mradm,PAPMINO,PAPMIName,PAPMIDOB,PAPMISex,PAAdmDate,PAAdmTime,PAAdmNo, 1-10
	//PAAdmDepCodeDR,PAAdmDocCodeDR,PAAdmType,Hospital,PAAdmWard,PAAdmBed,FinancialDischargeFlag, 11-17
	//MedicalDischargeFlag,FinalDischargeFlag,PAAdmReason,DischargeDate,RegDoctor,Diagnosis,ArrivedDate, 18-24
	//ArrivedTime,LeavedDate,LeavedTime,LocSeqNo,PAAdmPriority,WalkStatus,ConsultRoom,ConsultArea, 25-32
	//PAAdmReasonCode,StatusCode,PAPMIAge, 33-35
	//PriorityCode,Called,RegDocDr,TPoliticalLevel,TSecretLevel,"",PatientMedicare,
	//Totalmoney,PatTelNo,IconProfile,Arrived,Transfer,BGColor,RegAdmSource
	
	//PatientID:%String,EpisodeID:%String,mradm:%String,PAPMINO:%String,PAPMIName:%String,
	//PAPMIDOB:%String,PAPMISex:%String,PAAdmDate:%String,PAAdmTime:%String,PAAdmNo:%String,
	//PAAdmDepCodeDR:%String,PAAdmDocCodeDR:%String,PAAdmType:%String,Hospital:%String,
	//PAAdmWard:%String,PAAdmBed:%String,FinancialDischargeFlag:%String,MedicalDischargeFlag:%String,
	//FinalDischargeFlag:%String,PAAdmReason:%String,DischargeDate:%String,RegDoctor:%String,
	//Diagnosis:%String,ArrivedDate:%String,ArrivedTime:%String,LeavedDate:%String,
	//LeavedTime:%String,LocSeqNo:%String,PAAdmPriority:%String,WalkStatus:%String,
	//ConsultRoom:%String,ConsultArea:%String,PAAdmReasonCode:%String,StatusCode:%String,
	//Age:%String,PriorityCode:%String,Called:%String,RegDocDr:%String,TPoliticalLevel:%String,
	//TSecretLevel:%String,RegRangeTime:%String
	
	set Data=$LB(PatientID,EpisodeID,mradm,PAPMINO,PAPMIName,PAPMIDOB,PAPMISex,PAAdmDate,PAAdmTime,PAAdmNo,PAAdmDepCodeDR,PAAdmDocCodeDR,PAAdmType,Hospital,PAAdmWard,PAAdmBed,FinancialDischargeFlag,MedicalDischargeFlag,FinalDischargeFlag,PAAdmReason,DischargeDate,RegDoctor,Diagnosis,ArrivedDate,ArrivedTime,LeavedDate,LeavedTime,LocSeqNo,PAAdmPriority,WalkStatus,ConsultRoom,ConsultArea,PAAdmReasonCode,StatusCode,PAPMIAge,PriorityCode,Called,RegDocDr,TPoliticalLevel,TSecretLevel,"",PatientMedicare,Totalmoney,PatTelNo,IconProfile,Arrived,Transfer,BGColor,RegAdmSource)
	i PAAdmBed="" s ^||OrderByNullBed(" "_PAAdmWard,EpisodeID)=Data
	e  s ^||OrderByBed(" "_PAAdmWard," "_PAAdmBed,EpisodeID)=Data
	Quit
}

/// d ##class(%ResultSet).RunQuery("web.DHCDocMainOut","FindCurrentAdmProxy1","","","","","O","","2013-07-15T00:00:00","2013-07-15T00:00:00","on","","","")
Query FindCurrentAdmProxy1(Type As %String = 0, PatientNo As %String = "", Name As %String = "", MedicalNo As %String = "", PAADMType As %String = "I", CardNo As %String = "", OutStartDate As %Date = "", OutEndDate As %Date = "", OutArrivedQue As %String = "", OutRegQue As %String = "", OutConsultation As %String = "", OutAllPatient As %String = "") As websys.Query(ROWSPEC = "PatientID:%String,EpisodeID:%String,mradm:%String,PAPMINO:%String:登记号,PAPMIName:%String:姓名,PAPMIDOB:%String:出生日期,PAPMISex:%String:性别,PAAdmDate:%Date:就诊日期,PAAdmTime:%Time:就诊时间,PAAdmNo:%String:就诊号,PAAdmDepCodeDR:%String:就诊科室,PAAdmDocCodeDR:%String:医生,PAAdmType:%String:就诊类型,Hospital:%String:医院,PAAdmWard:%String:病房,PAAdmBed:%String:床号^50,FinancialDischargeFlag:%String,MedicalDischargeFlag:%String,FinalDischargeFlag:%String,PAAdmReason:%String:病人类型,DischargeDate:%String:出院日期,RegDoctor:%String:号别,Diagnosis:%String:诊断,ArrivedDate:%String:到达日期,ArrivedTime:%String:到达时间,LeavedDate:%String:离开日期,LeavedTime:%String:离开时间,LocSeqNo:%String:序号,PAAdmPriority:%String:优先级,WalkStatus:%String:状态,ConsultRoom:%String:诊室,ConsultArea:%String:诊区,PAAdmReasonCode:%String,StatusCode:%String,Age:%String:年龄,PriorityCode:%String,Called:%String,RegDocDr:%String,IconProfile:%String:图标菜单,Arrived:%String:到达")
{
}

ClassMethod FindCurrentAdmProxy1Execute(ByRef qHandle As %Binary, Type As %String = 0, PatientNo As %String = "", Name As %String = "", MedicalNo As %String = "", PAADMType As %String = "I", CardNo As %String = "", OutStartDate As %Date = "", OutEndDate As %Date = "", OutArrivedQue As %String = "", OutRegQue As %String = "", OutConsultation As %String = "", OutAllPatient As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s (AllPatient,ArrivedQue,MedUnit,HisPat,WardFlag)=""	
	s LocID=523   //%session.Get("LOGON.CTLOCID")
	Set UserID=4380   //%session.Get("LOGON.USERID")
	S CONTEXT =""  //$g(%session.Data("CONTEXT"))
	//if UserID=4756 s ^liyufeng("FindCurrentAdmProxyExecute1")=Type_","_PatientNo_","_Name_","_MedicalNo_","_PAADMType_","_CardNo_","_OutStartDate_","_OutEndDate_","_OutArrivedQue_","_OutRegQue_","_OutConsultation_","_OutAllPatient 
	//d ##class(%ResultSet).RunQuery("web.DHCDocMainOut","FindCurrentAdmProxy1","","0005706428","","","O","0000000918","2016-08-25","2016-08-25","","","",")
	s ^liyufeng("FindCurrentAdmProxyExecute")=Type_","_PatientNo_","_Name_","_MedicalNo_","_PAADMType_","_CardNo_","_OutStartDate_","_OutEndDate_","_OutArrivedQue_","_OutRegQue_","_OutConsultation_","_OutAllPatient 
	s:Type="" Type=0
	b ;4545
	k ^||OrderByBed,^||OrderByNullBed
	if (((PatientNo="") && (Name="") && (MedicalNo="") && (CardNo=""))||(PAADMType="O")){		
			#dim rs As %ResultSet
					set StartDate=..%SysDate(),EndDate=..%SysDate()
					//LocID_","_UserID_","_IPAddress_","_AllPatient_","_PatientNo_","_SurName_","_StartDate_","_EndDate_","_ArrivedQue_","_RegQue_","_Consultation
					if OutStartDate["-" Set OutStartDate=$zdh(OutStartDate,3)
					if OutEndDate["-" Set OutEndDate=$zdh(OutEndDate,3)
					s rs = ##class(%ResultSet).%New("web.DHCDocOutPatientList:FindLocDocCurrentAdm")
					d rs.Execute(LocID,UserID,"",OutAllPatient,PatientNo,Name,$g(OutStartDate),$g(OutEndDate),OutArrivedQue,OutRegQue,OutConsultation)
			//LocID,UserID,IPAddress , AllPatient , PatientNo , SurName , StartDate  , EndDate  , ArrivedQue  , RegQue , MedUnit
			//LocID , UserID , IPAddress , AllPatient , PatientNo , SurName , StartDate , EndDate , ArrivedQue, RegQue, Consultation
			//d rs.Execute("","","",AllPatient,"","","","",ArrivedQue,"",MedUnit)
			s columnNum = rs.GetColumnCount()
			s rowNum=0
			while(rs.Next()){
				s rowNum = rowNum+1
				s rowData=""
				f i=1:1:columnNum  s $list(rowData,i)=rs.GetData(i)
				s bed = rs.GetDataByName("PAAdmBed")
				s EpisodeID = rs.GetDataByName("EpisodeID")
				s PatientID = rs.GetDataByName("PatientID")
				set Deposit=##class(web.UDHCJFBaseCommon).deposit(EpisodeID)
				set Amount=##class(web.UDHCJFCKD).totalamount(EpisodeID)
				set Charge=##class(web.DHCDocOrderCommon).GetCurrentDeposit(EpisodeID)
				if (PAADMType="O") {
					s $list(rowData,columnNum+1)= $zcvt(##class(web.DHCDocMain).ShowIcon("MAP",EpisodeID_"^^^"_PatientID,CONTEXT),"O","HTML")	//加图表菜单
					s $list(rowData,columnNum+2)= $zcvt("<A><img style='cursor:pointer' SRC='../images/websys/update.gif' BORDER='0' onclick=SetPatArrived()></A>","O","HTML")
					if $list(rowData,30)="过号"{
						//s $list(rowData,5)="<A style='cursor:pointer' onclick=GHCallPatient()>"_$list(rowData,5)_"</A>"
					}else{
						//s $list(rowData,5)="<A style='cursor:pointer' >"_$list(rowData,5)_"</A>"	
						//s $list(rowData,5)="<A style='cursor:pointer' onclick=DHCAMSCallPat()>"_$list(rowData,5)_"</A>"
						s $list(rowData,5)=$zcvt("<A style='cursor:pointer;color:red' onclick=GHCallPatient()>"_$list(rowData,5)_"</A>","O","HTML")
					}
				}else{
					s $list(rowData,columnNum+2)= $zcvt(##class(web.DHCDocMain).ShowIcon("MAP",EpisodeID_"^^^"_PatientID,CONTEXT),"O","HTML")	//加图表菜单
				}
				s PAAdmWard=rs.GetDataByName("PAAdmWard")
				if (PAADMType="O") {
					s ^||OrderByNullBed(" "_PAAdmWard,rowNum)=rowData   //_$LB("123",Deposit,Amount,Charge)
				}else{
					i bed="" s ^||OrderByNullBed(" "_PAAdmWard,EpisodeID)=rowData_$LB("","123",Deposit,Amount,Charge)  //by houjian
					e  s ^||OrderByBed(" "_PAAdmWard," "_bed,EpisodeID)=rowData_$LB("","123",Deposit,Amount,Charge)
				}
			}
			d rs.%Close()
			s rs = ""
		
	}else{	
		b ;54545
		if (PatientNo'=""){
			b ;3433
			//登记号查询
			Set PAPMI=$O(^PAPERi("PAPMI_PatNo",PatientNo,""))
			if $g(PAPMI)="" Set qHandle=$lb(0,repid,0)	Quit $$$OK
			Set PAAdm="", CurrentAdmType=PAADMType
			For  Set PAAdm=$O(^PAPERdr(PAPMI,"ADM",CurrentAdmType,PAAdm)) Quit:PAAdm=""  Do
			.d OutputRow
		}Elseif (MedicalNo'=""){
			b
			Set PAPMI="", CurrentAdmType=PAADMType
			For  Set PAPMI = $O(^PAPERi("Medicare1",$$ALPHAUP^SSUTIL4(MedicalNo),PAPMI)) Q:PAPMI=""  Do
			.Set PAAdm="" For  Set PAAdm=$O(^PAPERdr(PAPMI,"ADM",CurrentAdmType,PAAdm)) Q:PAAdm=""  Do
			..b
			..d OutputRow
		}ELSEIF (Name'=""){
			Set PAPMI="", CurrentAdmType=PAADMType
			For  Set PAPMI = $O(^PAPERi("PAPER_PatName",$$ALPHAUP^SSUTIL4(Name),PAPMI)) Q:PAPMI=""  Do
			.Set PAAdm="" For  Set PAAdm=$O(^PAPERdr(PAPMI,"ADM",CurrentAdmType,PAAdm)) Q:PAAdm=""  Do
			..d OutputRow
		}ELSEIF (CardNo'=""){
			Set CFRowID="", PAPMI="", CurrentAdmType=PAADMType
			Set CFRowID = $o(^DHCCARDi("CF",0,"CardNo",$$ALPHAUP^SSUTIL4(CardNo),CFRowID))
			if (CFRowID'=""){
				Set ActiveFlag = $p(^DHCCARD("CF",CFRowID),"^",10)
				if ("N"=ActiveFlag){
					Set PAPMI = $p(^DHCCARD("CF",CFRowID),"^",4)
					Set PAAdm="" For  Set PAAdm=$O(^PAPERdr(PAPMI,"ADM",CurrentAdmType,PAAdm)) Q:PAAdm=""  Do
					.d OutputRow
				}
			}
		}
	}
	;输出病人列表信息
	s wardDesc="" for  s wardDesc = $o(^||OrderByBed(wardDesc)) q:wardDesc=""  d
	.s bedind=0 for  s bedind=$o(^||OrderByBed(wardDesc ,bedind)) q:bedind=""  d
	..s subind="" f   s subind=$o(^||OrderByBed(wardDesc ,bedind,subind)) q:subind=""  d
	...s ^CacheTemp(repid,ind) = ^||OrderByBed(wardDesc ,bedind,subind)
	...s ind=ind+1
	
	s wardDesc="" for  s wardDesc = $o(^||OrderByNullBed(wardDesc)) q:wardDesc=""  d
	.s subind="" f   s subind=$o(^||OrderByNullBed(wardDesc,subind)) q:subind=""  d
	..s ^CacheTemp(repid,ind) = ^||OrderByNullBed(wardDesc,subind)
	..s ind=ind+1

	Set qHandle=$lb(0,repid,0)	
	Quit $$$OK
findAdmTransWard(PAAdm,WardID)
	s find=0
	s child=0 f {
		s child=$O(^PAADM(PAAdm,"TRANS",child))
		Q:child=""
		s TransWardID=$P(^PAADM(PAAdm,"TRANS",child),"^",9)
		if TransWardID=WardID {
			s find=1
			Quit
		}
	}
	Q find
ResetVariables
	Set (PatientID,EpisodeID,mradm,PAPMINO,PAPMIName,PAPMIDOB,PAPMISex,PAAdmDate,PAAdmTime,PAAdmNo,PAAdmDepCodeDR,PAAdmDocCodeDR,PAAdmType,Hospital,PAAdmWard,PAAdmBed,FinancialDischargeFlag,MedicalDischargeFlag,FinalDischargeFlag,PAAdmReason,DischargeDate,Diagnosis,RegDoctor,ArrivedDate,ArrivedTime,LeavedDate,LeavedTime,LocSeqNo,PAAdmPriority,WalkStatus,ConsultRoom,ConsultArea,PAAdmReasonCode,StatusCode,PAPMIAge,PriorityCode,Called,RegDocDr,Deposit)=""
	Quit

OutputRow
	Do ResetVariables
	//PatientID,EpisodeID,mradm
	Set PatientID=$P(^PAADM(PAAdm),"^",1)
	Set EpisodeID=PAAdm
	Set mradm=$P(^PAADM(PAAdm),"^",61)
	//PAPMINO,PAPMIName,PAPMIDOB,PAPMISex
	Set PAPMINO=$P(^PAPER(PatientID,"PAT",1),"^",1)
	Set PAPMIName=$P(^PAPER(PatientID,"ALL"),"^",1)
	Set PAPMIDOB=$ZD($P(^PAPER(PatientID,"ALL"),"^",6),3)
	Set Sex=$P(^PAPER(PatientID,"ALL"),"^",7)
	Set PAPMISex=$P($g(^CT("SEX",Sex)),"^",2)
	//
	Set DobDate=$P($g(^PAPER(PatientID,"ALL")),"^",6)
	If DobDate'="" Do
	.Set PAPMIDOB=$ZD($P(^PAPER(PatientID,"ALL"),"^",6),3)
	.Set PAPMIAge=$fn((+$H-DobDate)/365,"",0)
	Else  Set PAPMIDOB="",PAPMIAge=""
	//PAAdmDate,PAAdmTime,PAAdmNo,PAAdmDepCodeDR,PAAdmDocCodeDR,PAAdmType,Hospital,PAAdmWard,PAAdmBed
	Set PAAdmDate=$ZD($P($g(^PAADM(PAAdm)),"^",6),3)
	Set PAAdmTime=..%ZT($P($g(^PAADM(PAAdm)),"^",7),3)
	set Deposit=##class(web.UDHCJFBaseCommon).deposit(PAAdm)
	//Add Date Check
	Set PAAdmNo=$P($g(^PAADM(PAAdm)),"^",81)
	Set Loc=$P($g(^PAADM(PAAdm)),"^",4)
	Set PAAdmDepCodeDR=##class(web.DHCDocInPatientList).RemoveAlias($P($g(^CTLOC(Loc)),"^",2))
	Set Doctor=$P($g(^PAADM(PAAdm)),"^",9)
	If Doctor'="" Set PAAdmDocCodeDR=$P($g(^CTPCP(Doctor,1)),"^",2)
	Else  Set PAAdmDocCodeDR=""
	Set PAAdmType=$P($g(^PAADM(PAAdm)),"^",2)
	Set Hosp=$P($g(^CTLOC(Loc)),"^",22)
	If Hosp'="" Set Hospital=$P($g(^CT("HOSP",Hosp)),"^",2)
	Set WardDr=$P($g(^PAADM(PAAdm)),"^",70)
	if WardDr'="" Set PAAdmWard=##class(web.DHCDocInPatientList).RemoveAlias($P($g(^PAWARD(WardDr)),"^",2))
	else  Set PAAdmWard=""
	Set BedId=$P($g(^PAADM(PAAdm)),"^",73)
	if BedId'="" Set PAAdmBed=$P($g(^PAWARD(+BedId,"BED",$P(BedId,"||",2))),"^",1)
	else  Set PAAdmBed="" 
	//FinancialDischargeFlag,MedicalDischargeFlag,FinalDischargeFlag,PAAdmReason,DischargeDate,Diagnosis
	Set FinancialDischargeFlag=$P($g(^PAADM(PAAdm)),"^",45)
	Set MedicalDischargeFlag=$P($g(^PAADM(PAAdm)),"^",63)
	Set PAAdmStatus=$P($g(^PAADM(PAAdm)),"^",20)
	Set FinalDischargeFlag=$S($g(PAAdmStatus)="D":"Y",1:"N")
	Set AdmReason=$P($g(^PAADM(PAAdm,1)),"^",7)
	If AdmReason'="" Set PAAdmReason=$P($g(^PAC("ADMREA",AdmReason)),"^",2),PAAdmReasonCode=$P($g(^PAC("ADMREA",AdmReason)),"^",5)
	Else  Set PAAdmReason="",PAAdmReasonCode=""
	Set DischargeDate=$P($g(^PAADM(PAAdm)),"^",17)
	s:DischargeDate'="" DischargeDate=$zd(DischargeDate,3)
	If mradm'="" Set Diagnosis=##class(web.DHCDocInPatientList).GetMRAdmDiagnosis(mradm) 
	Else  Set Diagnosis=""
	//RegDoctor,ArrivedDate,ArrivedTime,LeavedDate,LeavedTime,LocSeqNo,PAAdmPriority
	Set Seq=EpisodeID
	Set PatientMedicare=$p($g(^PAPER(PatientID,"PAT",1)),"^",22)   //住院号
	set IconProfile=$ZCVT(##class(web.DHCDocMain).ShowIcon("MAP",EpisodeID_"^^^"_PatientID,CONTEXT),"O","HTML")	//加图表菜单
	set Arrived="websys/update.gif"
	s BGColor=..GetDisPlayColor(PAAdm)
	set Data=$LB(PatientID,EpisodeID,mradm,PAPMINO,PAPMIName,PAPMIDOB,PAPMISex,PAAdmDate,PAAdmTime,PAAdmNo,PAAdmDepCodeDR,PAAdmDocCodeDR,PAAdmType,Hospital,PAAdmWard,PAAdmBed,FinancialDischargeFlag,MedicalDischargeFlag,FinalDischargeFlag,PAAdmReason,DischargeDate,RegDoctor,Diagnosis,ArrivedDate,ArrivedTime,LeavedDate,LeavedTime,LocSeqNo,PAAdmPriority,WalkStatus,ConsultRoom,ConsultArea,PAAdmReasonCode,StatusCode,PAPMIAge,PriorityCode,Called,RegDocDr,PatientMedicare,"",IconProfile,Arrived,"123",BGColor,"4")
	i PAAdmBed="" s ^||OrderByNullBed(" "_PAAdmWard,EpisodeID)=Data
	e  s ^||OrderByBed(" "_PAAdmWard," "_PAAdmBed,EpisodeID)=Data
	Quit
}

ClassMethod ReadCardTypeDefineListBroker(SessionStr As %String = "") As %String
{
	///读取卡类型定义
	;^DHCCARDTYPEDef(myTypeID)
	;w ##class(web.DHCDocMain).ReadCardTypeDefineListBroker("")
	;m ^TMPCardTypeDefine=%session.Data
	s ^TMPSessionStr=SessionStr
	s myTypeID=0
	s mydes=""
	s myval=""
	s mySelFlag=0
	s myDataFlag=0
	s ^TMPSessionStr=SessionStr
	s myPEObj=##class(web.DHCBL.Configure.PatEnroll).DHCGetDataObjectBySession(SessionStr)
	if ($IsObject(myPEObj)){
		s myDataFlag=1
	}
	Set CardTypeJson=""
	s myIdx=0
	f  s myTypeID=$o(^DHCCARDTYPEDef(myTypeID)) q:(myTypeID="")  d
	.s mydes=$p(^DHCCARDTYPEDef(myTypeID),"^", 2)
	.s myActiveFlag=$p(^DHCCARDTYPEDef(myTypeID),"^", 11)		;CTD_ActiveFlag
	.q:(myActiveFlag'="IE")
	.s myDateTo=+$p(^DHCCARDTYPEDef(myTypeID),"^", 10)		;CTD_DateTo
	.q:((+myDateTo'=0)&(myDateTo<+$h))			;失效日
	.s myval=myTypeID
	.s myval=myval_"^"_$g(^DHCCARDTYPEDef(myTypeID))
	.s myDefault=$p(^DHCCARDTYPEDef(myTypeID),"^", 8)
	.i myDefault="Y" d
	..s mySelFlag=1
	.e  d
	..s mySelFlag=0
	.s myFindFlag=1
	.i +myDataFlag  d
	..s myFindFlag=myPEObj.FindCardTypeByDR(myTypeID)
	..i myPEObj.DefaultCardTypeDR=myTypeID  d
	...s mySelFlag=1
	.q:(+myFindFlag=0)
	.;s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")
	.;s rtnval=rtnval_"','"_$ZCVT(mySelFlag,"O","JS")_"');"
	.;&javascript<#(rtnval)#>
	.;s myIdx=myIdx+1
	.if CardTypeJson="" Set CardTypeJson="['"_myval_"','"_mydes_"']"
	.else  Set CardTypeJson=CardTypeJson_",['"_myval_"','"_mydes_"']"
	q CardTypeJson
}

ClassMethod GetReadCardTypeDefault(SessionStr As %String = "") As %String
{
	///读取卡类型定义
	;^DHCCARDTYPEDef(myTypeID)
	;w ##class(web.DHCDocMain).GetReadCardTypeDefault("")
	;m ^TMPCardTypeDefine=%session.Data
	s ^TMPSessionStr=SessionStr
	s myTypeID=""
	s mydes=""
	s myval=""
	s mySelFlag=0
	s myDataFlag=0
	s ^TMPSessionStr=SessionStr
	s myPEObj=##class(web.DHCBL.Configure.PatEnroll).DHCGetDataObjectBySession(SessionStr)
	if ($IsObject(myPEObj)){
		s myDataFlag=1
	}
	Set CardTypeJson=""
	Set myval=""
	s myIdx=0
	f  s myTypeID=$o(^DHCCARDTYPEDef(myTypeID),-1) q:(myTypeID="")||(mySelFlag=1)  d
	.s mydes=$p(^DHCCARDTYPEDef(myTypeID),"^", 2)
	.s myActiveFlag=$p(^DHCCARDTYPEDef(myTypeID),"^", 11)		;CTD_ActiveFlag
	.q:(myActiveFlag'="IE")
	.s myDateTo=+$p(^DHCCARDTYPEDef(myTypeID),"^", 10)		;CTD_DateTo
	.q:((+myDateTo'=0)&(myDateTo<+$h))			;失效日
	.s myval=myTypeID
	.s myval=myval_"^"_$g(^DHCCARDTYPEDef(myTypeID))
	.s myDefault=$p(^DHCCARDTYPEDef(myTypeID),"^", 8)
	.i myDefault="Y" d
	..s mySelFlag=1
	.e  d
	..s mySelFlag=0
	.s myFindFlag=1
	.i +myDataFlag  d
	..s myFindFlag=myPEObj.FindCardTypeByDR(myTypeID)
	..i myPEObj.DefaultCardTypeDR=myTypeID  d
	...s mySelFlag=1
	.q:(+myFindFlag=0)
	q myval
}

ClassMethod GetCardInfo(PatientID)
{
	/*
	 S CardId=$o(^DHCCARDi("CF",0,"PAPMIDR",PatientID,""))

	 if (CardId'="") {
		 s CardNo=$p(^DHCCARD("CF",CardId),"^",2)
		 s CardTypeDr=$p(^DHCCARD("CF",CardId),"^",16)
		 if (CardTypeDr'=""){
			 s CardType=$p(^DHCCARDTYPEDef(CardTypeDr),"^",2)
			 }
		 }
	q $g(CardNo)_"^"_$g(CardType)
	*/
	
	s CFRowID = "",CFActiveFlag = "",CardNo = "", CardType=""
	
	for 
	{
		
		s CFRowID = $O(^DHCCARDi("CF",0,"PAPMIDR",PatientID,CFRowID))
		q:(CFRowID = "")
		s CFActiveFlag = $P(^DHCCARD("CF",CFRowID),"^",10)
		continue:(CFActiveFlag'="N")
 		s:(CFRowID'="") CardNo = $P(^DHCCARD("CF",CFRowID),"^",2)
 		s CardTypeDr=$p(^DHCCARD("CF",CFRowID),"^",16)
		 if (CardTypeDr'=""){
			 s CardType=$p(^DHCCARDTYPEDef(CardTypeDr),"^",2)
			 }
		}
		
	q $g(CardNo)_"^"_$g(CardType)
}

ClassMethod GetPatientBaseInfo(papmi, adm)
{
	;患者信息栏-新版(流程线版本)不使用此方法,只有V7.2-V8.2使用
	s name="",bedno="",age="",sex="",weight="",ipno="",insu="",ipdate=""
	q:(papmi="")&&(adm="") "{}"
	s:papmi="" papmi = +^PAADM(adm)
	q:'$d(^PAPER(papmi)) "{}"
	S CONTEXT = $g(%session.Data("CONTEXT"))	
	s:$d(^PAPER(papmi,"ALL")) name = $p(^PAPER(papmi,"ALL"),"^",1)
	s:$d(^PAADM(adm)) beddr = $p(^PAADM(adm),"^",73)
	s:+beddr>0 bedno=$p(^PAWARD(+beddr,"BED",$p(beddr,"||",2)),"^",1)	
	s sexDr=$p(^PAPER(papmi,"ALL"),"^",7) 
	i sexDr'="" s sex=$p(^CT("SEX",sexDr),"^","2")
	s weight=##class(web.DHCDocInPatientList).GetWeight(adm)
	s age = ##class(web.DHCDocMainOrderInterface).GetPatientAge(papmi,adm)

	;s ipno = ##class(web.PAPatMas).GetRegistration(papmi)
	;s ipno=""
	;s:$d(^PAPER(papmi,"PAT",1)) ipno = $p(^PAPER(papmi,"PAT",1),"^",22)
	s ipno = ##class(web.DHCDocMainOrderInterface).IGetMrNoByEpisodeID(adm)
	s insu = $p(^PAADM(adm,1),"^",7) ;PAADMAdmReasonDR
	s:insu'="" insu=$p(^PAC("ADMREA",insu),"^",2)
	s ipdate = $p(^PAADM(adm),"^",6)
	s:ipdate'="" ipdate=$zd(ipdate,3)
	s isEstDisch = ..isEstDisch(adm)
	set IconProfile=$ZCVT(..ShowIcon("MAP",adm_"^^^"_papmi,CONTEXT),"O","HTML")	//加图表菜单
	s admDept = $p(^PAADM(adm),"^",4)
	s:+admDept>0 TdeptDesc = ##class(web.DHCDocOrderCommon).GetLocDesc(admDept)
	s PatientNo= $p(^PAPER(papmi,"PAT",1),"^",1)
	
	/// zzz 20160819 
	s CardNo=""
	s CardRowid="" f  s CardRowid=$o(^DHCCARDi("CF",0,"PAPMIDR",papmi,CardRowid)) q:CardRowid=""  do
    .s CFActiveFlag=$p(^DHCCARD("CF",CardRowid),"^",10)
	.q:CFActiveFlag'="N"
	.s CFCancleDate=$p(^DHCCARD("CF",CardRowid),"^",13)
	.q:(CFCancleDate'="")&&(CFCancleDate<+$H)
	.s CardNo=$P(^DHCCARD("CF",CardRowid),"^",2)       //卡号
	
	s jsonObj = ##class(ext.util.JsonObject).%New()
	d jsonObj.Put("baseInfoName",name).Put("baseInfoBedno",bedno).Put("baseInfoAge",age).Put("baseInfoSex",sex).Put("baseInfoNo",PatientNo)
	d jsonObj.Put("baseInfoBodyWeight",weight).Put("baseInfoIPNo",ipno).Put("baseInfoInsu",insu).Put("baseInfoIPDate",ipdate)
	d jsonObj.Put("baseIsEstDisch",isEstDisch) //.Put("baseIconProfile",IconProfile)
	d jsonObj.Put("baseInfoCardNo",CardNo)
	;"{baseInfoName:"""_name_""",baseInfoBedno:"""_bedno_""",baseInfoAge:"""_age_""",baseInfoSex:"""_sex_""",baseInfoBodyWeight:"""_weight_""",baseInfoIPNo:"""_ipno_""",baseInfoInsu:"""_insu_""",baseInfoIPDate:"""_ipdate_"""}"
	q jsonObj.Json()
}

/// 是否医疗结算
ClassMethod isEstDisch(adm)
{
	s EstDischConfirmed=$p($g(^PAADM(adm,2)),"^",25) ;59--EstDisDate
	q:EstDischConfirmed="Y" 1
	q 0
}

/// 是否最终结算
ClassMethod isDischg(adm)
{
	s DischgDate=$p(^PAADM(adm),"^",17) ;PAADM_DischgDate
	q:DischgDate'="" 1
	q 0
}

// w ##class(web.DHCDocMain).ShowIcon("MAP","8956^^^6537490","")

ClassMethod ShowIcon(code As %String, val As %String, context As %String = "") [ ProcedureBlock = 0 ]
{
	n (code,val,context,%session,%request)
	Quit ##class(epr.CTIconProfile).ShowIcon(code,val,context)
}

// 判断是否是转诊记录

ClassMethod checkIsTransAdm(EpisodeID As %String, Loc As %String) As %String
{
	s TransID=0,TransFlag=0
	f  s TransID=$o(^DHCOPTransAdmI("Adm",EpisodeID,TransID)) q:(TransID="")||(TransFlag=1)  d
	.s TransToLoc=$p(^DHCOPTransAdm(TransID),"^",16)
	.Q:TransToLoc'=Loc
	.s TransToDoc=$p(^DHCOPTransAdm(TransID),"^",17)
	.s TransFlag=1
	Q TransFlag
}

ClassMethod GetRegAdmSource(Adm As %String) As %String
{
	;n (Adm)
	;0 门诊挂号,1 预约,2 加号
	s myrtn=0
	q:Adm="" ""
	if ..%IsValidMethod("DHCDoc.Common.pa","GetAdmRegType"){
		s AdmRegType=##class(DHCDoc.Common.pa).GetAdmRegType(Adm)	
		if AdmRegType'=""{
			s AdmRegType=$p(AdmRegType,"^",2)
			Q AdmRegType
		}
	}
	
	s RowId=""
	&sql(select APPT_RowId into :RowId from SQLUser.RB_Appointment where APPT_Adm_DR=:Adm)
	;^RBAS("ADM",Adm,{RB_Resource.RES_RowId},{RB_ApptSchedule.AS_ChildSub},{APPT_ChildSub})
	i RowId'="" {
		s Data=$g(^RBAS(+RowId,$p(RowId,"||",2),"APPT",$p(RowId,"||",3)))
		s MethodCode="",MethodDesc=""
		s MethodDR=$p(Data,"^",12)
		i MethodDR'="" s MethodCode=$p($g(^RBC("APTM",MethodDR)),"^",1),MethodDesc=$p($g(^RBC("APTM",MethodDR)),"^",2)
		s myrtn=MethodDesc
		i $ZCVT(MethodCode,"U")="WIN" s myrtn=0
	}
	
	s RegfeeDr=$O(^User.DHCRegistrationFeeI("ADM",Adm,""))
	i RegfeeDr'="" {
		s ASRowId = $list(^User.DHCRegistrationFeeD(RegfeeDr), 18)
		s ASNoLimitLoadFlag=##class(web.DHCRBApptSchedule).GetASNoLimitLoadFlag(ASRowId)
		s RegfeeNo=$List(^User.DHCRegistrationFeeD(RegfeeDr),8)
		i (ASNoLimitLoadFlag'="Y")&&(RegfeeNo="") s myrtn="便民登记"
	}
	/*
	;是否转诊
	s TransferFlag=""
	i RegfeeDr'="" s TransferFlag=$List(^User.DHCRegistrationFeeD(RegfeeDr),22)
	i TransferFlag'="" s myrtn=myrtn_"(转诊)"
	*/
	i myrtn=0 s myrtn="门诊挂号"
	Q myrtn
}

/// 得到缴费情况
ClassMethod GetPaySit(EpisodeId As %String, userId As %String, ctLocId As %String) As %String
{
	;s ^tmpgry("PaySitDesc",EpisodeId)=EpisodeId_","_userId_","_ctLocId
	s PaySit=""
	Set rs=##Class(%ResultSet).%New("web.DHCDocMouth:FindNoPaymentDetil")
	If rs.QueryIsValid() { 
		 Set Status=rs.Execute(EpisodeId,userId,ctLocId,.PaySit)
		 If 'Status Quit
		 ;if 'rs.Next() s PaySit=""
	}
	Q PaySit
}

/// lxz 获取展示颜色 
/// w ##class(web.DHCDocMainOut).GetDisPlayColor(50000361)
ClassMethod GetDisPlayColor(adm) As %String
{
	
	s $ZT="ErrorDisPlayColor"
	s Collor=""
	set QueueID=$O(^User.DHCQueueI("QuePaadmDrIndex",adm,0))
	if (QueueID'=""){
		s QueComDr=$Listget(^User.DHCQueueD(QueueID),2)
		s:(Collor="")&(QueComDr=1) Collor="#00DB00"
		s statudr=$ListGet(^User.DHCQueueD(QueueID),14)
		s statuDesc=""
		s:statudr'="" statuDesc=$listGet(^User.DHCPerStateD(statudr),4)
		s:((statuDesc["过号")&&(Collor="")) Collor="#FFA07A"
	
	}
	q Collor
ErrorDisPlayColor
	q ""
}

/// 获取呼叫信息
ClassMethod GetCallMesage(adm, UserID) As %String
{
	Q:adm="" ""
	s IP=##class(web.DHCDocOutPatientList).GetIPAndName()
	s QueueID=$O(^User.DHCQueueI("QuePaadmDrIndex",adm,0))
	Q:QueueID="" ""
	s UserName=""
	s:UserID'="" UserName=$p($G(^SSU("SSUSR",UserID)),"^",2)
	s PAPMIID=$P($G(^PAADM(adm)),"^",1)
	s CardNo=$$GetPatCard()
	s PatName=$P($G(^PAPER(PAPMIID,"ALL")),"^",1)
	s PAPMINO=$P(^PAPER(PAPMIID,"PAT",1),"^",1)
	
	
	s CTLOCDesc=""
	if IP'=""  d
	.s ID=+$O(^User.DHCRoomCompI("RoomcIpIndex"," "_IP,0))
	.if ID'=0  d
	..s roomdr=$listget(^User.DHCRoomCompD(ID),5)
	..s:roomdr'="" CTLOCDesc=$P($G(^CTLOC(roomdr)),"^",2)
	&SQL(select RegfeeNo,RegfeeRBASDr,RegfeeSessionTypeDr into :QueNO,:RBASDr,:SessionTypeDr from SQLUSER.DHCRegistrationFee where RegfeeAdmDr=:adm)
	Q:SQLCODE'=0 ""
	s CTPCP=$p($G(^RB("RES",+RBASDr)),"^",2)
	s MarkDesc=""
	s:CTPCP'="" MarkDesc=$P($G(^CTPCP(CTPCP,1)),"^",2)
	s SessType=""
	s:SessionTypeDr'="" SessType=$p($G(^RBC("SESS",SessionTypeDr)),"^",1)
	if SessType["专家" s ZJFlag=1
	else  s ZJFlag=0
	
	&SQL(select QueExabDr into :QueExabDr from SQLUSER.DHCQueue where ID=:QueueID)
	Q:SQLCODE'=0 ""
	Q:QueExabDr="" ""
	&SQL(select ExabSubCallFilePath into:FilePath from SQLUSER.DHCExaBoroughFilePath where ExabDr=:QueExabDr)
	Q:SQLCODE'=0 ""
	;查找诊区地址
	Q:FilePath="" ""
	
	;0就诊1候诊，就诊ID,患者卡号，队列号，患者姓名，诊室名字，医生姓名，号别，0普通，1专家
	s CallMesag="0"_","_adm_","_PAPMINO_","_QueNO_","_PatName_","_CTLOCDesc_","_UserName_","_MarkDesc_","_ZJFlag
	Q:CTLOCDesc="" ""
	q FilePath_"^"_CTLOCDesc_"^"_CallMesag
	
GetPatCard()
	s FindCardNO=""
	if PAPMIID'=""  d
	.s CFRowId=0
	.f  s CFRowId=$O(^DHCCARDi("CF",0,"PAPMIDR",PAPMIID,CFRowId)) Q:CFRowId=""  d
	..s ActiveFlag=$P(^DHCCARD("CF",CFRowId),"^",10)
	..Q:ActiveFlag'="N" 
	..s CardNO=$P(^DHCCARD("CF",CFRowId),"^",2)
	..if FindCardNO="" s FindCardNO=CardNO
	..s CardTypeG=$P(^DHCCARD("CF",CFRowId),"^",16)
	..if CardTypeG=2  d
	...s FindCardNO=FindCardNO
	q CardNO
}

}
