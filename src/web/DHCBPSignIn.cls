Import SQLUser

Class web.DHCBPSignIn Extends (%Library.RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// 获取病人签到列表(透析记录为依据)
/// registerId透析登记号，daySeqNo班次(早中晚)
/// d ##class(%ResultSet).RunQuery("web.DHCBPSignIn","FindSignIn","2020-06-29","2020-07-01","")
Query FindSignIn(startDate, endDate, daySeqNo As %String = "", locId As %String = "") As %Query(ROWSPEC = "Id,RegNo,PatName,BedGroupDesc,BedDesc,DayPartCode,DayPart,ModeId,ModeDesc,ArrangeDate,StatusDesc,DocOperStatus,siId,siDate,siTime,siStatusDesc,siCtcpDesc,siSignInNo,siReceiveTime,curReceiveTime,ReceiveMark,PlanReceiveTime,StartVitalSigns,EndVitalSigns") [ SqlProc ]
{
}

ClassMethod FindSignInExecute(ByRef qHandle As %Binary, startDate, endDate, daySeqNo As %String = "", locId As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1	
	s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s endDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	s locIdList=##Class(web.DHCBPCom).GetLinkLocByLocId(locId) //科室关联
	f curDate=startDate:1:endDate d
		.s bpaId=""
		.f  s bpaId=$o(^DHCBPArrange(0,"Date",curDate,bpaId)) q:bpaId=""  d
			..q:$$GetSignIn()<0
			..i siReceiveTime="" s siReceiveTime="23:59"
			..s siReceiveTime=$zth(siReceiveTime)
			..i siSignInNo="" s siSignInNo="1000"
			..s ^TMPBP("SignIn",$j,siReceiveTime,siSignInNo,bpaId)=""
	d Output
	K ^TMPBP("SignIn",$j) //排序的临时global	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetSignIn()
	q:bpaId="" -1
	s bpprId=$lg(^DHCBPArrange(bpaId),1)
	s bpprPatLocDr=$lg(^DHCBPPatRegister(bpprId),34)	
    q:((locId'="")&&(bpprPatLocDr'="")&&($p($g(^CTLOC(locId)),"^",22)'=$p($g(^CTLOC(bpprPatLocDr)),"^",22))) -1.1 //病人所在医院判断
    q:(bpprPatLocDr'="")&&(locIdList'="")&&(("^"_locIdList_"^")'[("^"_bpprPatLocDr_"^")) -1.2
	s papmiId=$lg(^DHCBPPatRegister(bpprId),1)
	q:papmiId="" -2	
	s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	s bpprStatus=$lg(^DHCBPPatRegister(bpprId),14)	
	s bpprEndDate=$lg(^DHCBPPatRegister(bpprId),13)
	s bpaDate=$lg(^DHCBPArrange(bpaId),4)
	q:(bpprStatus="D")&&(bpprEndDate<bpaDate) -2.5 //转归后
	s arrDate=bpaDate
	s bpaDate=##class(web.DHCClinicCom).ConvertToDate(bpaDate)	
	s bpaStatus=$lg(^DHCBPArrange(bpaId),9)
	q:bpaStatus="D" -3
	i bpaStatus="A" s bpaStatus="申请"	
	i bpaStatus="R" s bpaStatus="安排"
	i bpaStatus="M" s bpaStatus="治疗"
	i bpaStatus="F" s bpaStatus="完成"
	s bpaDaySeqNo=$lg(^DHCBPArrange(bpaId),6)
	q:(daySeqNo'="")&&(daySeqNo'=bpaDaySeqNo) -4
	i bpaDaySeqNo="A" s bpaDaySeqNoDesc="上午"	
	i bpaDaySeqNo="P" s bpaDaySeqNoDesc="下午"
	i bpaDaySeqNo="E" s bpaDaySeqNoDesc="晚上"
	s bpaBPCBedDr=$lg(^DHCBPArrange(bpaId),7)
	s bpaBPCBedDesc=$lg($g(^DHCBPC("Bed",+bpaBPCBedDr)),2)
	s bpaBedGroupDesc=""
	i (bpaBPCBedDr'=""&&bpaBPCBedDr'="0") d
		.s bpaBedGroupDr=$lg($g(^DHCBPC("Bed",+bpaBPCBedDr)),3) 	
		.s bpaBedGroupDesc=$lg($g(^DHCBPC("BedGroup",+bpaBedGroupDr)),2) //床位组
	e  d
		.s bppId=##class(web.DHCBPPatSetUpBedGroup).GetPatSetUpBedGroupID(bpprId,bpaDaySeqNo) //病人绑定床位组记录ID
		.i bppId'="" d
			..s bpaBedGroupDr=$lg($g(^DHCBPPatSetUpBedGroup(bppId)),1) //绑定床位组
			..s bpaBedGroupDesc=$lg($g(^DHCBPC("BedGroup",+bpaBedGroupDr)),2)
	s bpaBPCBPModeDr=$lg(^DHCBPArrange(bpaId),26)
	s bpaBPCBPModeDesc=$lg($g(^DHCBPC("BloodPurificationMode",+bpaBPCBPModeDr)),2)
	s bpaDocOperStatus=$lg($g(^DHCBPArrange(bpaId)),55) //确认方案
	s bpaConfirmScheme=""
	i (bpaDocOperStatus="C")||(bpaDocOperStatus="R") s bpaConfirmScheme="已确认"
	s bpsiId="",siId="",siRegNo="",siDate="",siTime="",siStatus="",siStatus="",siStatusDesc=""
	s siCtcp="",siCtcpDesc="",siSignInNo="",siReceiveTime=""
	f  s bpsiId=$o(^DHCBPSignIn(0,"Date",curDate,bpsiId)) q:bpsiId=""  d
		.s siRegNo=$lg(^DHCBPSignIn(bpsiId),1)
		.q:regNo'=siRegNo
		.s siDate=$lg(^DHCBPSignIn(bpsiId),2)
		.s siDate=##class(web.DHCClinicCom).ConvertToDate(siDate)
		.s siTime=$lg(^DHCBPSignIn(bpsiId),3)
		.s siTime=##class(web.DHCClinicCom).ConvertToTime(siTime)
		.s siStatus=$lg(^DHCBPSignIn(bpsiId),4)
		.q:siStatus="D"
		.i siStatus="N" s siStatusDesc="已签到"	
		.s siCtcp=$lg(^DHCBPSignIn(bpsiId),5)
		.//s siCtcpDesc=$p($g(^CTPCP(+siCtcp,1)),"^",2)
		.i siCtcp'="" s siCtcpDesc=##class(web.DHCANOPCom).GetNameById(siCtcp)
		.s siSignInNo=$lg(^DHCBPSignIn(bpsiId),7)
		.s siReceiveTime=$lg(^DHCBPSignIn(bpsiId),9)
		.s siId=bpsiId
	s bpaReceiveTime="" //获取当次透析设置接诊时间(临时)
	s arrExtValue=##class(web.DHCBPArrangeExtend).GetArrangeExtendValue(bpaId,"SignInReceiveTime")
	i arrExtValue'="" s bpaReceiveTime= $p(arrExtValue,$c(3),1)
	s bpaReceiveMark="" //接诊标识	
	i (bpaDocOperStatus="R") d //透前复核
		.s bpaReceiveMark="已接诊"
	s bpaStartVitalSigns=..GetPatVitalSigns(bpaId,"Start") //透析前体重血压脉搏(采集)
	s bpaEndVitalSigns=..GetPatVitalSigns(bpaId,"End") //透析后体重血压脉搏(采集)
	s planReceiveTime=##class(web.DHCBPPatSetUpBedGroup).GetCalReceptionTime(bpprId,arrDate,bpaDaySeqNo) //绑定的接诊时间
	q 0
Output
    // 编号排序
	s tmpReceiveTime=""
	f  s tmpReceiveTime=$o(^TMPBP("SignIn",$j,tmpReceiveTime)) q:tmpReceiveTime=""  d
	.s tmpSignInNo=""
	.f  s tmpSignInNo=$o(^TMPBP("SignIn",$j,tmpReceiveTime,tmpSignInNo)) q:tmpSignInNo=""  d
	..s bpaId=""
	..f  s bpaId=$o(^TMPBP("SignIn",$j,tmpReceiveTime,tmpSignInNo,bpaId)) q:bpaId=""  d
	...q:$$GetSignIn()<0
	...d OutputRow	
	quit
OutputRow
	set Data=$lb(bpaId,regNo,patName,bpaBedGroupDesc,bpaBPCBedDesc,bpaDaySeqNo,bpaDaySeqNoDesc,bpaBPCBPModeDr,bpaBPCBPModeDesc,bpaDate,bpaStatus,bpaConfirmScheme,siId,siDate,siTime,siStatusDesc,siCtcpDesc,siSignInNo,siReceiveTime,bpaReceiveTime,bpaReceiveMark,planReceiveTime,bpaStartVitalSigns,bpaEndVitalSigns)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindSignInFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSignInExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

ClassMethod FindSignInClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSignInExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 获取透析前、后体重、血压、脉搏(采集),异常值"*"开头
/// input：Start透析前，End透析后
ClassMethod GetPatVitalSigns(bpaId As %String = "", type As %String = "Start") As %String
{
	s bpaVitalSigns="",abnormal="" //生命体征/异常
	s bpaWeight="",bpaDP="",bpaSP="",bpaHeartRate=""
	q:(type="End")&&($lg(^DHCBPArrange(bpaId),105)="") bpaVitalSigns //未上机+获取透析后
	i type="Start" s bpaWeight=$lg(^DHCBPArrange(bpaId),10) //透析前体重
	e  s bpaWeight=$lg(^DHCBPArrange(bpaId),14) //透析后体重
	i (bpaWeight="")||(bpaWeight=0) d 
		.s bpaWeight=##Class(web.DHCBPCom).getOutPatDataCollect(bpaId,"weight") //测量体重
	i (bpaWeight'="")&&(bpaWeight'=0) s bpaVitalSigns=bpaVitalSigns_"体重"_bpaWeight
	i type="Start" s bpaDP=$lg(^DHCBPArrange(bpaId),62) //透析前舒张压
	e  s bpaDP=$lg(^DHCBPArrange(bpaId),63) //透析后舒张压
	i (bpaDP="")||(bpaDP=0) d
		.s bpaDP=##Class(web.DHCBPCom).getOutPatDataCollect(bpaId,"DIA") //测量舒张压
	i ((bpaDP'="")&&(bpaDP'=0)&&((bpaDP<50)||(bpaDP>110))) s abnormal="*"
	i type="Start" s bpaSP=$lg(^DHCBPArrange(bpaId),64) //透析前收缩压
	e  s bpaSP=$lg(^DHCBPArrange(bpaId),65) //透析后收缩压
	i (bpaSP="")||(bpaSP=0) d
		.s bpaSP=##Class(web.DHCBPCom).getOutPatDataCollect(bpaId,"SYS") //测量收缩压
	i ((bpaSP'="")&&(bpaSP'=0)&&((bpaSP<90)||(bpaSP>180))) s abnormal="*"
	i ((bpaDP'="")&&(bpaDP'=0))&&((bpaSP'="")&&(bpaSP'=0)) d
		.s bpaVitalSigns=bpaVitalSigns_"血压("_bpaSP_"/"_bpaDP_")"
	e  i ((bpaDP'="")&&(bpaDP'=0)) d
		.s bpaVitalSigns=bpaVitalSigns_"血压("_bpaDP_")"
	e  i ((bpaSP'="")&&(bpaSP'=0)) d
		.s bpaVitalSigns=bpaVitalSigns_"血压("_bpaSP_")"
    i type="Start" s bpaHeartRate=$lg(^DHCBPArrange(bpaId),66) //透析前脉搏
    e  s bpaHeartRate=$lg(^DHCBPArrange(bpaId),67) //透析后脉搏
    i (bpaHeartRate="")||(bpaHeartRate=0) d
    	.s bpaHeartRate=##Class(web.DHCBPCom).getOutPatDataCollect(bpaId,"PR") //测量脉搏
    i (bpaHeartRate'="")&&(bpaHeartRate'=0) s bpaVitalSigns=bpaVitalSigns_"脉搏"_bpaHeartRate
    i abnormal'="" s bpaVitalSigns=abnormal_bpaVitalSigns
    q bpaVitalSigns
}

/// 不再使用
/// 获取透析前体重、血压、脉搏(采集),异常值"*"开头
ClassMethod GetStartVitalSigns(bpaId As %String = "") As %String
{
	s bpaStartVitalSigns="",abnormal="" //生命体征/异常
	s bpaStartWeight=$lg(^DHCBPArrange(bpaId),10) //透析前体重
	i (bpaStartWeight="")||(bpaStartWeight=0) d 
		.s bpaStartWeight=##Class(web.DHCBPCom).getOutPatDataCollect(bpaId,"weight") //测量体重
	i (bpaStartWeight'="")&&(bpaStartWeight'=0) s bpaStartVitalSigns=bpaStartVitalSigns_"体重"_bpaStartWeight
	s bpaStartDP=$lg(^DHCBPArrange(bpaId),62) //透析前舒张压
	i (bpaStartDP="")||(bpaStartDP=0) d
		.s bpaStartDP=##Class(web.DHCBPCom).getOutPatDataCollect(bpaId,"DIA") //测量舒张压
	i ((bpaStartDP'="")&&(bpaStartDP'=0)&&((bpaStartDP<50)||(bpaStartDP>110))) s abnormal="*"
	s bpaStartSP=$lg(^DHCBPArrange(bpaId),64) //透析前收缩压
	i (bpaStartSP="")||(bpaStartSP=0) d
		.s bpaStartSP=##Class(web.DHCBPCom).getOutPatDataCollect(bpaId,"SYS") //测量收缩压
	i ((bpaStartSP'="")&&(bpaStartSP'=0)&&((bpaStartSP<90)||(bpaStartSP>180))) s abnormal="*"
	i ((bpaStartDP'="")&&(bpaStartDP'=0))&&((bpaStartSP'="")&&(bpaStartSP'=0)) d
		.s bpaStartVitalSigns=bpaStartVitalSigns_"血压("_bpaStartSP_"/"_bpaStartDP_")"
	e  i ((bpaStartDP'="")&&(bpaStartDP'=0)) d
		.s bpaStartVitalSigns=bpaStartVitalSigns_"血压("_bpaStartDP_")"
	e  i ((bpaStartSP'="")&&(bpaStartSP'=0)) d
		.s bpaStartVitalSigns=bpaStartVitalSigns_"血压("_bpaStartSP_")"
    s bpaStartHeartRate=$lg(^DHCBPArrange(bpaId),66) //透析前脉搏
    i (bpaStartHeartRate="")||(bpaStartHeartRate=0) d
    	.s bpaStartHeartRate=##Class(web.DHCBPCom).getOutPatDataCollect(bpaId,"PR") //测量脉搏
    i (bpaStartHeartRate'="")&&(bpaStartHeartRate'=0) s bpaStartVitalSigns=bpaStartVitalSigns_"脉搏"_bpaStartHeartRate
    i abnormal'="" s bpaStartVitalSigns=abnormal_bpaStartVitalSigns
    q bpaStartVitalSigns
    //s bpaStartVitalSigns=abnormal_"体重"_bpaStartWeight_"血压("_bpaStartSP_"/"_bpaStartDP_")"_"脉搏"_bpaStartHeartRate
}

/// creator:	mfc
/// createtime:	20200630
/// function:	血液净化提供自助机接口：添加病人签到记录；大屏登记显示
/// rucan:		PatientInfo(RegNo病人ID；Date日期；Time时间；Status签到状态默认N；Equip设备名称)
/// retutn:		PatientResult(xlm)；其中：RetCode为0正常签到，为1时为签到失败；InfoMessage提示消息；ErrorMessage错误信息
/// note:		参考接口文档(血液净化提供自助机接口)
/// w ##Class(web.DHCBPSignIn).InsertSignInInfo("")
ClassMethod InsertSignInInfo(PatientInfo As %String = "") As %String
{
	Set $ZTrap = "SignInMessageCatch"
	s fromDate=$o(^DHCBPSignInSeqNo("")) //清空前几天的班次签到序号
	i (fromDate'="")&&(fromDate'=+$h) k ^DHCBPSignInSeqNo(fromDate)
    i PatientInfo="" s PatientInfo="<PatientInfo><RegNo>C686155</RegNo><Date>2020-07-03</Date><Time>12:24</Time><Status>N</Status><Equip>测试签到设备</Equip></PatientInfo>"
    s XMLTitle="<?xml version=""1.0"" encoding=""gb2312""?>"
    i $P(PatientInfo,XMLTitle,2)'="" s PatientInfo=$P(PatientInfo,XMLTitle,2)
    i $P(PatientInfo,"<!-版本,编码信息-->",2)'="" s PatientInfo=$P(PatientInfo,"<!-版本,编码信息-->",2)
    s nowDate=+$h,nowTime=$p($h,",",2)
    s reader=##class(%XML.Reader).%New()
    s sc=reader.OpenString(PatientInfo)
    d reader.Correlate("PatientInfo","web.DHCBPSignInService.SignInInfo")
    B ;001
    s RegNo="",patName="",bpaBedDesc="",SeqNo="",InfoMessage="",ErrorMessage="",RetCode=1
    s SignInNo="",DaySeqDesc="",patLoc="",ReceiveTime="",BedGroupDesc=""
	While reader.Next(.person,.sc)
	{
		B ;002
        s RegNo=$TR(person.RegNo,$C(0))
        i RegNo="" s ErrorMessage="病人ID为空，无法签到！" Quit
        s bpaId=##Class(web.DHCBPSignIn).GetBPArrangeId(RegNo) //判断是否存在透析安排
        i bpaId="" s ErrorMessage="今天未安排血液净化或者已上机完成，无法签到！" Quit       
        s Date=$TR(person.Date,$C(0))
        s Date=##class(web.DHCClinicCom).ConvertToDateH(Date)
        s Time=$TR(person.Time,$C(0))
        s Time=##class(web.DHCClinicCom).ConvertToTimeH(Time)
        //i (Time<23400) s ErrorMessage="此时间段无法签到！签到时间6:30-8:30 12:00-13:30" Quit //6:30
        //i ((Time>30600)&&(Time<43200)) s ErrorMessage="此时间段无法签到！签到时间6:30-8:30 12:00-13:30" Quit //8:30-12:00
        //i (Time>48600) s ErrorMessage="此时间段无法签到！签到时间6:30-8:30 12:00-13:30" Quit //13:30
        s Status=$TR(person.Status,$C(0))
        s Equip=$TR(person.Equip,$C(0))
        s bpprId=$lg($g(^DHCBPArrange(bpaId)),1)
        s patLocDr=$lg($g(^DHCBPPatRegister(bpprId)),34) //所在病区
        s patLoc=$p($g(^CTLOC(patLocDr)),"^",2)
       	i $l(patLoc,"-")>1 s patLoc=$p(patLoc,"-",2)
	    s papmiId=$lg($g(^DHCBPPatRegister(bpprId)),1)
	    s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1) //姓名
	    s bpaDate=$lg(^DHCBPArrange(bpaId),4)
		s arrDate=bpaDate	   
        s bpaDaySeqNo=$lg($g(^DHCBPArrange(bpaId)),6) //班次
        s DaySeqDesc=""
        i bpaDaySeqNo="A" s DaySeqDesc="上午"	
	    i bpaDaySeqNo="P" s DaySeqDesc="下午"
	    i bpaDaySeqNo="E" s DaySeqDesc="晚上"
        s SignInNo=$g(^DHCBPSignInSeqNo(+$h,bpaDaySeqNo)) //当前班次签到序号起始值
        i SignInNo="" s SignInNo=1
        e  s SignInNo=SignInNo+1
        s Id="",bpsiReceiveTime="",bpsiSignInNo=""
        &sql(select %ID,BPSI_ReceiveTime,BPSI_SeqNo into :Id,:bpsiReceiveTime,:bpsiSignInNo from DHC_BP_SignIn where BPSI_RegNo=:RegNo and BPSI_Date=:Date and BPSI_Status='N' and BPSI_DaySeqNo=:bpaDaySeqNo)
	    i Id'="" s SignInNo=bpsiSignInNo
	    i bpsiReceiveTime'="" s ReceiveTime=bpsiReceiveTime
	    e  d
			.s signInRT="" //获取当次透析设置接诊时间(临时)
			.s arrExtValue=##class(web.DHCBPArrangeExtend).GetArrangeExtendValue(bpaId,"SignInReceiveTime")
			.i arrExtValue'="" s signInRT= $p(arrExtValue,$c(3),1)
			.i signInRT="" s ReceiveTime=##class(web.DHCBPPatSetUpBedGroup).GetCalReceptionTime(bpprId,arrDate,bpaDaySeqNo) //绑定的接诊时间	
    		.e  s ReceiveTime=signInRT	    
	    s tmpReceiveTime=##class(web.DHCClinicCom).ConvertToTimeH(ReceiveTime) //提前10分钟签到限制
    	s advanceSignInTime=##Class(web.DHCBPCom).GetPatAdvanceSignInTime(patLocDr) //获取提前签到限制时间
    	s tmpStartReceiveTime=$zt(tmpReceiveTime-advanceSignInTime,2)    	
	    i ((tmpReceiveTime-Time)>advanceSignInTime) s ErrorMessage="签到失败！请在"_tmpStartReceiveTime_"到"_ReceiveTime_"之间签到！" Quit
	    //&SQL(Insert into DHC_BP_SignIn (BPSI_RegNo,BPSI_Date,BPSI_Time,BPSI_Status,BPSI_Equip,BPSI_SeqNo,BPSI_DaySeqNo) values(:RegNo,:Date,:Time,:Status,:Equip,:SignInNo,:bpaDaySeqNo))
		s PLIST(2)=RegNo
		s PLIST(3)=Date
		s PLIST(4)=Time
		s PLIST(5)=Status
		s PLIST(7)=Equip	
		s PLIST(8)=SignInNo
		s PLIST(9)=bpaDaySeqNo
		s PLIST(10)=ReceiveTime
		i Id="" d	
			.&SQL(insert into DHC_BP_SignIn values:PLIST())  //签到记录
		e  d
			.&SQL(update DHC_BP_SignIn Values:PLIST() where BPSI_RowId=:Id)
        i (SQLCODE'=0)&(SQLCODE'=100) s ErrorMessage=SQLCODE q
        e  s RetCode=0
        i Id="" s ^DHCBPSignInSeqNo(+$h,bpaDaySeqNo)=SignInNo //保存签到序号
	    //s ret=##class(web.DHCBPSignIn).AutoBPArrangeBed(bpaId) //自动安排床位
	    //i ret=0 s RetCode=0
	    //e  s ErrorMessage=ret
		s visService=##Class(web.DHCBPCom).GetIsVisServiceByLocId(patLocDr) //是否大屏显示更新
    	i (visService){
	    	s ret=##class(web.DHCBPVISService).RisSendRegQueue(bpaId,"",Equip,"Reg") //大屏登记显示
	    	i ret=0 s RetCode=0
	    	e  s ErrorMessage=ret
    	}
	    s bpaBedDr=$lg($g(^DHCBPArrange(bpaId)),7)
	    s bpaBedDesc=""
	    i (bpaBedDr'="")&&(bpaBedDr'="0") d
	    	.s bpaBedDesc=$lg($g(^DHCBPC("Bed",bpaBedDr)),2) //床位
	    	.s BedGroupDr=$lg($g(^DHCBPC("Bed",bpaBedDr)),3)
			.s BedGroupDesc=$lg($g(^DHCBPC("BedGroup",BedGroupDr)),2)    
    }
    //返回xml格式，详细说明见文档
    s ReturnInfo="<PatientResult><RegNo>"_RegNo_"</RegNo><PatName>"_patName_"</PatName><SignInNo>"_SignInNo_"</SignInNo><BedDesc>"_bpaBedDesc_"</BedDesc><RetCode>"_RetCode_"</RetCode><InfoMessage>"_InfoMessage_"</InfoMessage><ErrorMessage>"_ErrorMessage_"</ErrorMessage>"
    s ReturnInfo=ReturnInfo_"<DaySeqDesc>"_DaySeqDesc_"</DaySeqDesc><PatLoc>"_patLoc_"</PatLoc><ReceptionTime>"_ReceiveTime_"</ReceptionTime><BedGroupDesc>"_BedGroupDesc_"</BedGroupDesc></PatientResult>"   
	q ReturnInfo
SignInMessageCatch
	Set $ZTrap = ""
  	Quit $$$ERROR($$$GeneralError,"Error in OnProcessInput():  "_$ZError)
}

/// creator:	mfc
/// createtime:	20200630
/// function:	手工签到：添加病人签到记录；大屏登记显示
/// rucan:		RegNo病人ID；Date日期；Time时间；Status签到状态默认N；InsertSign签到用户；HostName计算机名称
/// retutn:		sqlcode
/// w ##Class(web.DHCBPSignIn).InsertSignIn("18900917","2020/7/25","17:47:11","N","196")
ClassMethod InsertSignIn(RegNo As %String, Date As %String, Time As %String, Status As %String = "N", CtcpDr As %String = "", HostName As %String = "") As %String
{
	s $zt="Error"
	k PLIST
	s SQLCODE=-1
	s fromDate=$o(^DHCBPSignInSeqNo("")) //清空之前天的班次签到序号
	i (fromDate'="")&&(fromDate'=+$h) k ^DHCBPSignInSeqNo(fromDate)
	s Date=##class(web.DHCClinicCom).ConvertToDateH(Date)
	s Time=##class(web.DHCClinicCom).ConvertToTimeH(Time)
	s bpaId=##Class(web.DHCBPSignIn).GetBPArrangeId(RegNo) //判断是否存在透析安排
	i bpaId="" q "今天未安排血液净化或已上机完成"
	s bpaDate=$lg(^DHCBPArrange(bpaId),4)
	s arrDate=bpaDate
	s bpaDaySeqNo=$lg(^DHCBPArrange(bpaId),6) //班次	
	s bpprId=$lg(^DHCBPArrange(bpaId),1)	
	s SignInNo=$g(^DHCBPSignInSeqNo(+$h,bpaDaySeqNo)) //当前班次签到序号起始值
    i SignInNo="" s SignInNo=1
    e  s SignInNo=SignInNo+1 
	s Id="",bpsiReceiveTime="",bpsiSignInNo="",ReceiveTime="" 
    &sql(select %ID,BPSI_ReceiveTime,BPSI_SeqNo into :Id,:bpsiReceiveTime,:bpsiSignInNo from DHC_BP_SignIn where BPSI_RegNo=:RegNo and BPSI_Date=:Date and BPSI_Status='N' and BPSI_DaySeqNo=:bpaDaySeqNo)
	i Id'="" s SignInNo=bpsiSignInNo
	i bpsiReceiveTime'="" s ReceiveTime=bpsiReceiveTime
	e  d
		.s signInRT="" //获取当次透析设置接诊时间(临时)
		.s arrExtValue=##class(web.DHCBPArrangeExtend).GetArrangeExtendValue(bpaId,"SignInReceiveTime")
		.i arrExtValue'="" s signInRT= $p(arrExtValue,$c(3),1)		
		.i signInRT="" s ReceiveTime=##class(web.DHCBPPatSetUpBedGroup).GetCalReceptionTime(bpprId,arrDate,bpaDaySeqNo) //绑定的接诊时间	
    	.e  s ReceiveTime=signInRT		
	TSTART	
    s PLIST(2)=RegNo
	s PLIST(3)=Date
	s PLIST(4)=Time
	s PLIST(5)=Status
	s PLIST(6)=CtcpDr
	s PLIST(7)=HostName		
	s PLIST(8)=SignInNo
	s PLIST(9)=bpaDaySeqNo
	s PLIST(10)=ReceiveTime
	i Id="" d	
		.&SQL(insert into DHC_BP_SignIn values:PLIST())  //签到记录
	e  d
		.&SQL(update DHC_BP_SignIn Values:PLIST() where BPSI_RowId=:Id)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE	
	}	
	i Id="" s ^DHCBPSignInSeqNo(+$h,bpaDaySeqNo)=SignInNo //保存签到序号		
	TCOMMIT
	//s retBed=##class(web.DHCBPSignIn).AutoBPArrangeBed(bpaId) //自动安排床位
	//i retBed'=0 q "自动安排床位:"_retBed

	s bpprPatLocationDr=$lg($g(^DHCBPPatRegister(bpprId)),34) //患者所属病区ID(护士科室ID)
	s visService=##Class(web.DHCBPCom).GetIsVisServiceByLocId(bpprPatLocationDr) //是否大屏显示更新
    i (visService){
		s retRis=##class(web.DHCBPVISService).RisSendRegQueue(bpaId,CtcpDr,HostName,"Reg") //大屏登记显示	
		i retRis'=0 q "大屏登记显示:"_retRis
    }	
	q SQLCODE
Error
	trollback
	quit "E^"_$ze
}

/// 自动分配透析床位
/// ArrangeId透析记录ID
/// 通过病人绑定床位组维护，确定病人分配到具体哪个床位组；通过床位支持滤过维护，确定床位是普通透析床位还是支持透析滤过
/// 净化方式：1、透析滤过只能安排到支持滤过的床位；2、普通透析优先分配到普通床位，没有位置再分配到支持滤过的床位
/// w ##Class(web.DHCBPSignIn).AutoBPArrangeBed(114065)
ClassMethod AutoBPArrangeBed(ArrangeId As %String) As %String
{
	s retStr=""	
	q:ArrangeId="" "安排Id为空"
	s bpprId=$lg(^DHCBPArrange(ArrangeId),1)
	s bpprPatLocationDr=$lg(^DHCBPPatRegister(bpprId),34)
	s bpprStatus=$lg(^DHCBPPatRegister(bpprId),14)
	q:bpprStatus="D" "已转归" //转归
	s bpprPatType=$lg(^DHCBPPatRegister(bpprId),25)
	//q:bpprPatType'="N" "临时病人不支持自动安排床位"
	s status=$lg(^DHCBPArrange(ArrangeId),9)	
	q:status="D" "透析安排已取消"
	s bedDr=$lg(^DHCBPArrange(ArrangeId),7)
	q:(bedDr'="")&&(bedDr'="0") "透析床位已安排，不能重复安排"
	s daySeqNo=$lg(^DHCBPArrange(ArrangeId),6) //班次
	s modeDr=$lg(^DHCBPArrange(ArrangeId),26) //净化方式
	q:modeDr="" "无有效净化方式"
	s modeCode=$lg($g(^DHCBPC("BloodPurificationMode",+modeDr)),1)	
	s IsFiltration=0 //支持滤过
	i (modeCode="HDF")||(modeCode="HF") s IsFiltration=1
	q:(modeCode'="HDF")&&(modeCode'="HF")&&(modeCode'="HD")&&(modeCode'="HFD") "0" //"不属于常规透析"
	s bpaDate=$lg(^DHCBPArrange(ArrangeId),4)	
	s papmiId=$lg($g(^DHCBPPatRegister(bpprId)),1)
	s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1) //姓名	
	s bppId=##class(web.DHCBPPatSetUpBedGroup).GetPatSetUpBedGroupID(bpprId,daySeqNo) //病人绑定床位组记录
	q:bppId="" "未绑定班次床位组，无法安排床位"
	s bppbebGroupId=$lg($g(^DHCBPPatSetUpBedGroup(bppId)),1) //绑定床位组
	s bppbedId=$lg($g(^DHCBPPatSetUpBedGroup(bppId)),9) //绑定床位
	i bppbedId'="" d
		.s bpBedEquipDr=$o(^DHCBPBedEquip(0,"Bed",+bppbedId,"")) //净化设备    	
    	.&sql(select BPA_RowId into :ifBedArrId from DHC_BP_Arrange where BPA_Date=:bpaDate and BPA_DaySeqNo=:daySeqNo and BPA_BPCBed_Dr=:bppbedId)
    	.i ifBedArrId'="" s retStr="绑定的床位"_$lg($g(^DHCBPC("Bed",+bppbedId)),2)_"被占用，无法安排"
		.e  d
			..i bpBedEquipDr'="" d
				...s bpEquipDr=$lg($g(^DHCBPBedEquip(+bpBedEquipDr)),2)
				...&SQL(update DHC_BP_Arrange set BPA_BPCBed_Dr=:bppbedId,BPA_Status="R",BPA_BPCEquip_Dr=:bpEquipDr where BPA_RowId=:ArrangeId)
				...s retStr=SQLCODE
			..e  d
				...&SQL(update DHC_BP_Arrange set BPA_BPCBed_Dr=:bppbedId,BPA_Status="R" where BPA_RowId=:ArrangeId)
				...s retStr=SQLCODE
	i retStr'="" q retStr	
	s bpaId=""
	f  s bpaId=$o(^DHCBPArrange(0,"Date",bpaDate,bpaId)) q:bpaId=""  d //占用床位
		.s tmpbpprId=$lg(^DHCBPArrange(bpaId),1)
		.s bpaStatus=$lg(^DHCBPArrange(bpaId),9)
		.q:bpaStatus="D"
		.s bpaDaySeqNo=$lg(^DHCBPArrange(bpaId),6) //班次
		.q:(daySeqNo'="")&&(daySeqNo'=bpaDaySeqNo)
		.s tmpbppId=##class(web.DHCBPPatSetUpBedGroup).GetPatSetUpBedGroupID(tmpbpprId,bpaDaySeqNo) //病人绑定床位组记录
		.i tmpbppId'="" s tmpbppbedId=$lg($g(^DHCBPPatSetUpBedGroup(tmpbppId)),9) //绑定床位
		.e  s tmpbppbedId=""
		.s bpaBedDr=$lg(^DHCBPArrange(bpaId),7)
		.i ((bpaBedDr="")||(bpaBedDr=0))&&(tmpbppbedId'="") s bpaBedDr=tmpbppbedId
		.q:(bpaBedDr="")||(bpaBedDr=0)
		.s bpaBedDesc=$lg($g(^DHCBPC("Bed",+bpaBedDr)),2)
		.s bpaBedGroupDr=$lg(^DHCBPC("Bed",+bpaBedDr),3) //床位组
		.q:(bppbebGroupId'="")&&(bppbebGroupId'=bpaBedGroupDr)		
		.s bpaBedGroupDesc=$lg(^DHCBPC("BedGroup",+bpaBedGroupDr),2)
		.//w bpaBedGroupDesc,!
		.s bpaIsFiltration=$lg(^DHCBPC("Bed",+bpaBedDr),11)
		.i bpaIsFiltration="" s bpaIsFiltration=0
		.//s bpaBedType=$lg(^DHCBPC("Bed",+bpaBedDr),5) //床位类型(HCV丙肝、HBV乙肝、Special特殊床位、空阴性)
		.s ^DHCBPBedList($j,bpaBedDr)=bpaIsFiltration
	//5透析,6透析,12滤过,13透析,14滤过
	s firstBedId=$o(^DHCBPBedList($j,"")) //占用床起始值
	//w "firstBedId:"_firstBedId,!	
	s predictBedId="" //计划安排床位
	s defaultBedId="" //床位组的起始床位(滤过、普通透析)
	i IsFiltration=1 d
		.&sql(select %ID into :defaultBedId from DHC_BPC_Bed where BPCB_BPCBedGroup_Dr=:bppbebGroupId and BPCB_IsFiltration=:IsFiltration)
	e  d
		.&sql(select %ID into :defaultBedId from DHC_BPC_Bed where BPCB_BPCBedGroup_Dr=:bppbebGroupId and (BPCB_IsFiltration=0 or BPCB_IsFiltration is null))
		.i defaultBedId="" d //没有普通透析床位，获取滤过床位
			..&sql(select %ID into :defaultBedId from DHC_BPC_Bed where BPCB_BPCBedGroup_Dr=:bppbebGroupId and BPCB_IsFiltration=1)
	q:defaultBedId="" "床位组内没有绑定净化方式支持的床位"	
	i (firstBedId="") s predictBedId=defaultBedId //组内起始直接分配
	//s ^dhcbpmfc(+$h,patName,bpprId,ArrangeId,daySeqNo,1)=firstBedId_"/"_predictBedId
	//w "defaultBedId:"_defaultBedId,!
	i predictBedId="" d //第一次(相同净化方式：透析对应透析，滤过对应滤过)
		.s predictBedId=..PredictBedIdByBedGroup(bppbebGroupId,IsFiltration,1)
	i predictBedId="" d //第二次(支持净化方式：滤过对应滤过或者透析)
		.s predictBedId=..PredictBedIdByBedGroup(bppbebGroupId,IsFiltration,0)
	//w "predictBedId"_predictBedId,!
	//s ^dhcbpmfc(+$h,patName,bpprId,ArrangeId,daySeqNo,2)=firstBedId_"/"_predictBedId_"/"_bppbebGroupId_"/"_IsFiltration
	i predictBedId'="" d
		.s bpBedEquipDr=$o(^DHCBPBedEquip(0,"Bed",+predictBedId,"")) //净化设备    	
    	.i bpBedEquipDr'="" d
    		..s bpEquipDr=$lg($g(^DHCBPBedEquip(+bpBedEquipDr)),2)
			..&SQL(update DHC_BP_Arrange set BPA_BPCBed_Dr=:predictBedId,BPA_Status="R",BPA_BPCEquip_Dr=:bpEquipDr where BPA_RowId=:ArrangeId)
			..s retStr=SQLCODE
		.e  d
			..&SQL(update DHC_BP_Arrange set BPA_BPCBed_Dr=:predictBedId,BPA_Status="R" where BPA_RowId=:ArrangeId)
			..s retStr=SQLCODE	 
	k ^DHCBPBedList($j)
	q retStr
}

/// 获取空床床位(相同或者支持的净化方式)
/// BedGroupId床位组；IsFiltration净化方式支持滤过：1支持，0不支持；IsFirst格则：1要求相同净化方式，0支持净化方式(滤过)
/// w ##Class(web.DHCBPSignIn).PredictBedIdByBedGroup(0,"0")
ClassMethod PredictBedIdByBedGroup(BedGroupId As %String, IsFiltration As %String, IsFirst As %String = 1) As %String
{
	s predictBedId="",effectiveBedId=""
	&sql(declare C8 cursor for select BPCB_RowId into :effectiveBedId from DHC_BPC_Bed where BPCB_BPCBedGroup_Dr=:BedGroupId)
	&sql(open C8)
	&sql(fetch C8)
	while(SQLCODE=0)  
	{
	  s bpaIsFiltration=$g(^DHCBPBedList(+$j,effectiveBedId)) //床位是否占用
	  s bedIsFiltration=$lg(^DHCBPC("Bed",effectiveBedId),11)
	  i bedIsFiltration="" s bedIsFiltration=0
	  //w "bpaIsFiltration"_bpaIsFiltration_"/"_"bedIsFiltration"_bedIsFiltration_"/"_"IsFiltration"_IsFiltration,! 
	  i IsFirst=1 d //获取相同净化方式的空床床位
	  	.i (bpaIsFiltration="")&&(bedIsFiltration=IsFiltration) d
	  		..s predictBedId=effectiveBedId
	  e  d //获取空床床位(支持净化方式)
	  	.i (bpaIsFiltration="") d
	  		..s predictBedId=effectiveBedId
	  q:predictBedId'=""
	  &sql(fetch C8)
	}
	&sql(close C8)
	q predictBedId
}

/// 获取当日有效透析记录(申请、安排透析)
/// w ##Class(web.DHCBPSignIn).GetBPArrangeId("C686155")
ClassMethod GetBPArrangeId(regNo As %String) As %String
{
	q:regNo="" ""
	s retStr="",ifExist=0
	s papmiId=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(regNo),""))
	//w papmiId,!
	s bpprId=""
	f  s bpprId=$o(^DHCBPPatRegister(0,"PaPatMas",papmiId,bpprId)) q:(bpprId="")!(ifExist)  d
		.s bpStatus=$lg(^DHCBPPatRegister(bpprId),14) //正常N、转归D
		.q:bpStatus="D"
		.s bpPatType=$lg(^DHCBPPatRegister(bpprId),25) //常规N、临时T
		.//q:bpPatType="T"
		.//w bpprId,!
		.s ifQuit=0,idcount=0		
		.s bpaId=""
		.f  s bpaId=$o(^DHCBPArrange(0,"PatRegister",bpprId,bpaId),-1) q:(bpaId="")!(ifQuit)  d
			..s idcount=idcount+1
			..i idcount>30 s ifQuit=1 //透析记录从后往前查找前30条记录(防止之前透析记录太多，耗费时间)		
			..s bpaDate=$lg(^DHCBPArrange(bpaId),4) //透析日期
			..//w bpaId_"/"_bpaDate,!			
			..q:bpaDate'=+$h
			..s bpaStatus=$lg(^DHCBPArrange(bpaId),9) //透析状态(A计划安排、R已安排)
			..q:(bpaStatus'="A")&&(bpaStatus'="R")
			..//w bpaStatus,!
			..s ifQuit=1,retStr=bpaId,ifExist=1
			..//w bpaId,!
	q retStr
}

/// 任务执行，自动安排病人第二天床位
/// w ##Class(web.DHCBPSignIn).ConfirmBPAutoArrangeBed("")
ClassMethod ConfirmBPAutoArrangeBed(isDebug As %String = "") As %String
{
	s retStr="0"
	//s curDate=(+$h)+1 //日期第二天  如果周六任务自动安排下周一床位失败，适合周日手工执行，放开这句。注解下面3句的判断
	i $zd(+$h,10)=6 s curDate=(+$h)+2 //周六安排下周一
	e  i $zd(+$h,10)=0 q retStr //周日不安排
	e  s curDate=(+$h)+1 //安排第二天
	s bpaId=""
	f  s bpaId=$o(^DHCBPArrange(0,"Date",curDate,bpaId)) q:bpaId=""  d
		.//q:bpaId'="115638"
		.q:$$GetSignIn()<0 
		.q:bpaDaySeqNo="" //班次
		.q:bpaBedGroupDesc="" //关联床位组			
		.i bpaReceiveTime="" s bpaReceiveTime="23:59" //临时设置接诊时间或者关联接诊时间
		.s bpaReceiveTime=$zth(bpaReceiveTime)			
		.s ^TMPBP("AutoArrangeBed",$j,bpaDaySeqNo,bpaBedGroupDesc,bpaReceiveTime,bpaId)=""	
	q:isDebug'="" ""
	d Output
	K ^TMPBP("AutoArrangeBed",$j) //排序的临时global
	q retStr	
GetSignIn()
	q:bpaId="" -1
	s bpprId=$lg(^DHCBPArrange(bpaId),1)
	//w curDate,!
	s papmiId=$lg(^DHCBPPatRegister(bpprId),1)
	q:papmiId="" -2
	s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	s bpaDate=$lg(^DHCBPArrange(bpaId),4)
	s arrDate=bpaDate
	s bpaDate=##class(web.DHCClinicCom).ConvertToDate(bpaDate)
	s bpaStatus=$lg(^DHCBPArrange(bpaId),9)
	q:bpaStatus'="A" -3
	s bpaDaySeqNo=$lg(^DHCBPArrange(bpaId),6)
	s bpaBPCBedDr=$lg(^DHCBPArrange(bpaId),7)
	q:(bpaBPCBedDr'="")&&(bpaBPCBedDr'="0") -4  //已安排床位退出
	s bpaBPCBedDesc=$lg($g(^DHCBPC("Bed",+bpaBPCBedDr)),2)
	s bpaBedGroupDr="",bpaBedGroupDesc=""
	i (bpaBPCBedDr="")||(bpaBPCBedDr="0") d
		.s bppId=##class(web.DHCBPPatSetUpBedGroup).GetPatSetUpBedGroupID(bpprId,bpaDaySeqNo) //病人绑定床位组记录ID
		.i bppId'="" d
			..s bpaBedGroupDr=$lg($g(^DHCBPPatSetUpBedGroup(bppId)),1) //绑定床位组
			..s bpaBedGroupDesc=$lg($g(^DHCBPC("BedGroup",+bpaBedGroupDr)),2)	
	s bpaBPCBPModeDr=$lg(^DHCBPArrange(bpaId),26)
	s bpaReceiveTime="" //获取当次透析接诊时间
	s arrExtValue=##class(web.DHCBPArrangeExtend).GetArrangeExtendValue(bpaId,"SignInReceiveTime")
	i arrExtValue'="" s bpaReceiveTime= $p(arrExtValue,$c(3),1)
	i bpaReceiveTime="" s bpaReceiveTime=##class(web.DHCBPPatSetUpBedGroup).GetCalReceptionTime(bpprId,arrDate,bpaDaySeqNo)
	q 0
Output
    // 编号排序
    s tmpDaySeqNo=""
	f  s tmpDaySeqNo=$o(^TMPBP("AutoArrangeBed",$j,tmpDaySeqNo)) q:tmpDaySeqNo=""  d
		.s tmpBedGroup=""
		.f  s tmpBedGroup=$o(^TMPBP("AutoArrangeBed",$j,tmpDaySeqNo,tmpBedGroup)) q:tmpBedGroup=""  d
			..s tmpReceiveTime=""
			..f  s tmpReceiveTime=$o(^TMPBP("AutoArrangeBed",$j,tmpDaySeqNo,tmpBedGroup,tmpReceiveTime)) q:tmpReceiveTime=""  d
				...s bpaId=""
				...f  s bpaId=$o(^TMPBP("AutoArrangeBed",$j,tmpDaySeqNo,tmpBedGroup,tmpReceiveTime,bpaId)) q:bpaId=""  d
					....s ret=..AutoBPArrangeBed(bpaId)
					....i ret'=0 d
						.....i retStr="" s retStr=tmpBedGroup_"/"_tmpReceiveTime_"/"_bpaId_"/"_ret
						.....e  s retStr=retStr_"#"_tmpBedGroup_"/"_tmpReceiveTime_"/"_bpaId_"/"_ret
					....e  s retStr=ret
	quit
}

}
