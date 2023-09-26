Import SQLUser

Include Nur.DateFormat

/// pengjunfu  2015-11-23
/// 新出院
Class web.DHCDischargeHistory Extends %Persistent [ ProcedureBlock ]
{

// 插入出院日志

ClassMethod InsertDischargeHistory(EpisodeID, type, userId, date, time, dischargeDate, dischargeTime, orderDr)
{
	
	i date="" s date=+$h
	i time="" s time=$p($h,",",2)
	s object=##class(User.DHCDischargeHistory).%New(EpisodeID)
	//d object.DHCDisPAADMParRefSetObjectId(EpisodeID)
	i EpisodeID'="" d object.DHCDisPAADMEXTParRefSetObjectId(EpisodeID)
	i date'="" s object.DisUpdateDate=date
	i time'="" s object.DisUpdateTime=time
	i type'="" s object.DisUpdateType=type
	i userId'="" d object.DisUpdateUserDRSetObjectId(userId)
	i (type="E")!(type="F") d
	.i dischargeDate'="" s object.DisDate=dischargeDate
	.i dischargeTime'="" s object.DisTime=dischargeTime
	i (type="E") d
	.i orderDr'="" d object.DisOEOrderDrSetObjectId(orderDr)
	s sc=object.%Save()
	If $$$ISERR(sc) q "-1"
	d object.%Close()
	s object=""
	
	i type="F" d
	.//插入出院事件
	.d ##class(web.DHCThreeNew).SyncEvent(EpisodeID,date,time,"discharge",userId,1)
	i type="R" d
	.d ##class(web.DHCThreeNew).DeleteEvent(EpisodeID,"discharge")
	q 0
}

// 获取出院医嘱 

ClassMethod GetDischargeNeedArcim(code)
{
	q $g(^DHCDishChargeSet("Disch",code))
}

// 获取日志表当前状态

ClassMethod GetCurrentDischargeStatus(EpisodeID)
{
	s sub=""
	s sub=$o(^DHCDischargeHistory(EpisodeID,"History",sub),-1)
	i (sub'=0)&(sub'="") d
	.s type=$p($g(^DHCDischargeHistory(EpisodeID,"History",sub)),"^",4)
	.i type="E" d
	..s date=$p($g(^DHCDischargeHistory(EpisodeID,"History",sub)),"^",5)
	..i date>+$h s type=""
	q $g(type)
}

// 获取出院日期

ClassMethod GetDischargeDateTime(EpisodeID)
{
	s date=$p($g(^PAADM(EpisodeID,"DHC")),"^",29)
	s time=$p($g(^PAADM(EpisodeID,"DHC")),"^",30)
	q date_"^"_time
}

// 获取入院日期

ClassMethod GetAdminDateTime(EpisodeID)
{
	s date=$p($g(^PAADM(EpisodeID,"DHC")),"^",31)
	s time=$p($g(^PAADM(EpisodeID,"DHC")),"^",32)
	q date_"^"_time
}

// 存入院日期时间  type: 1: 住院登记  2:第一次分床  3:退院  

// date  time 要转换成数字

// 返回值:-1 无需更新  0 成功  -2 日期时间病区科室为空  -3 日期时间病区科室不为空

// ##class(web.DHCDischargeHistory).SaveAdminDateTime("746",64762,"51671",2,"157",45)	

ClassMethod SaveAdminDateTime(EpisodeID, date, time, type, locDr, wardDr)
{
	s ^tempsc("DHCDischargeHistory")=$lb(EpisodeID, date, time, type, locDr, wardDr)
	s ifNewBaby=..ifNewBaby(EpisodeID)
	s inHospDate=$p($g(^PAADM(EpisodeID,"DHC")),"^",31)
	s inHospTime=$p($g(^PAADM(EpisodeID,"DHC")),"^",32)
	s admLoc=$p(^PAADM(EpisodeID),"^",4)
	s hospital=$p($g(^CTLOC(admLoc)),"^",22)
	s defHospID=##class(Nur.Interface.Other.BDPInterface).GetDefHospIdByTableName("Nur_IP_NeedCareOrderSet",hospital)
	i defHospID'=""  s flag=$g(^DHCDishChargeSet("Disch","ifGetAdmDateTimeByBed",defHospID))
	e  s flag=$g(^DHCDishChargeSet("Disch","ifGetAdmDateTimeByBed"))
	q:(type=1)&(flag="Y") -1
	q:(type=2)&(flag'="Y")&(ifNewBaby'=1) -1
	q:((type=1)!(type=2))&((date="")!(time="")!(locDr="")!(wardDr="")) -2
	q:(type=3)&((date'="")!(time'="")!(locDr'="")!(wardDr'="")) -3
	q:(type'=1)&(type'=2)&(type'=3) -1	
	q:((type'=1)&&(ifNewBaby=1)&&(inHospDate'="")&&(inHospTime'="")&&(date'="")&&(time'="")) -1
	&sql(update PA_AdmExt set PAADM_AdminDate=:date,PAADM_AdminTime=:time,PAADM_AdminLoc=:locDr,PAADM_AdminWard=:wardDr where PAADM_RowId=:EpisodeID)
	q SQLCODE
}

/// Creator:      SongChao
/// CreateDate:   2017.6.28
/// Description:  传入就诊号判断病人是不是新生儿
/// Input:        EpisodeID
/// Return:       0:否,1:是
/// Other: w ##class(web.DHCDischargeHistory).ifNewBaby("151")
ClassMethod ifNewBaby(EpisodeID)
{
	s ifNewBaby=0
	q:EpisodeID="" ifNewBaby
	s motherADM =""
	s motherADM = $p(^PAADM(EpisodeID),"^",75)
	i motherADM'="" s ifNewBaby=1
	q ifNewBaby
}

ClassMethod IfGetAdminDateTimeByBed()
{
	s flag=$g(^DHCDishChargeSet("Disch","ifGetAdmDateTimeByBed"))
	i flag="Y" q 1
	q 0
}

ClassMethod ifGetDischgDateTimeByDoc()
{
	s flag=$g(^DHCDishChargeSet("Disch","ifGetDischgDateTimeByDoc"))
	i flag="Y" q 1
	q 0
}

ClassMethod ifUseNewDischarge()
{
	s flag=$g(^DHCDishChargeSet("Disch","ifUseNewDischarge"))
	i flag="Y" q 1
	q 0
}

/// Test:  ##class(web.DHCDischargeHistory).GetDischargeInfo(960)
ClassMethod GetDischargeInfo(EpisodeID)
{
	s EstimDischargeDate=""
	s EstimDischargeTime=""
	s DischgDate=""
	s DischgTime=""
	s MedDischDoc=""
	s DischgDoc=""
	s DeceasedDate=""
	s DeceasedTime=""
	s DisconId="" 
	s DisconDesc=""
	s DischgDays=0 //已出院天数
	
	&sql(select 
		PAADM_EstimDischargeDate,
		PAADM_EstimDischargeTime,
		PAADM_MedDischDoc_DR,
		PAADM_DischgDate,
		PAADM_DischgTime,
		PAADM_DischgDoc_DR,
		PAADM_DischCond_DR into
			:EstimDischargeDate,
			:EstimDischargeTime,
			:MedDischDoc,
			:DischgDate,
			:DischgTime,
			:DischgDoc,
			:DisconId
				from PA_ADM where PAADM_RowId=:EpisodeID)
	s paperId=+^PAADM(EpisodeID)
	&sql(select 
		PAPER_Deceased_Date,
		PAPER_DeceasedTime into
		  :DeceasedDate,
		  :DeceasedTime
		  from PA_Person where Paper_RowId=:paperId)
	i EstimDischargeDate'="" s EstimDischargeDate=$$$zd(EstimDischargeDate,3)
	i EstimDischargeTime'="" s EstimDischargeTime=$zt(EstimDischargeTime)
	s PAPERDeceased=$p($g(^PAPER(paperId,"ALL")),"^",12)
	if (DischgDate'=""){
		s DischgDays=(+$h)-DischgDate+1
		s DischgDate=$$$zd(DischgDate,3)
		s DischgTime=$zt(DischgTime)
	}else{
		s admLoc=$p(^PAADM(EpisodeID),"^",4)
		s hospital=$p($g(^CTLOC(admLoc)),"^",22)
		s defHospID=##class(Nur.Interface.Other.BDPInterface).GetDefHospIdByTableName("Nur_IP_NeedCareOrderSet",hospital)
		if (PAPERDeceased="Y"){
			s nurDiaChargeTime=$g(^DHCDishChargeSet("Disch","nurDeathChargeTime",defHospID))
			e  s nurDiaChargeTime=$g(^DHCDishChargeSet("Disch","nurDeathChargeTime"))
		}else{
			s nurDiaChargeTime=$g(^DHCDishChargeSet("Disch","nurDiaChargeTime",defHospID))
			e  s nurDiaChargeTime=$g(^DHCDishChargeSet("Disch","nurDiaChargeTime"))
		}
		if ((nurDiaChargeTime="")||(nurDiaChargeTime="EstimDischargeDateTime"))&&(EstimDischargeDate'="") {
			s dischgDateTime=..getEstimDischargeDateTime(EpisodeID)
			if (dischgDateTime'=""){
				s DischgDate=$$$zd($p(dischgDateTime," ",1),3)
				s DischgTime=$zt($p(dischgDateTime," ",2))
			}
		}elseif (nurDiaChargeTime="DisOrdExecDateTime") {
			s DischgDateTime=..getDisOrdExecDate(EpisodeID) //出院医嘱执行时间
			if (DischgDateTime'=""){
				s DischgDate=$p(DischgDateTime," ")
				s DischgTime=$p(DischgDateTime," ",2)
			}
			//母亲婴儿一起出院,取母亲和婴儿最晚的出院医嘱执行时间
			if ($p(^DHCTarC("CF",2),"^",5)="Y"){
				s motherloc=..GetPatLoc(EpisodeID)
				s babyAdmId=""
				for{
					s babyAdmId=$o(^PAADMi("Mother",EpisodeID,babyAdmId)) q:babyAdmId=""
				    s pavisit=$p($g(^PAADM(babyAdmId)),"^",20)
				    continue:(pavisit'="A")
				    s babyloc=..GetPatLoc(babyAdmId)
				    continue:motherloc'=babyloc
				    s babyDischgDateTime=..getDisOrdExecDate(babyAdmId)
				    s babyDischgDate=$p(babyDischgDateTime," ")
					s babyDischgTime=$p(babyDischgDateTime," ",2)
					continue:(babyDischgDate="")
				    if (DischgDate="")||(babyDischgDate>DischgDate) {
					    s DischgDate=babyDischgDate
					    s DischgTime=babyDischgTime
					}elseif(babyDischgDate=DischgDate)&&(DischgTime<babyDischgTime) {
						s DischgTime=babyDischgTime
					}
			    }
			}
			if (DischgTime'=""){
				s EstimDischgDateTime=..getEstimDischargeDateTime(EpisodeID) //期望出院时间
				if (EstimDischgDateTime'=""){
					s tmpDischgDate=$p(EstimDischgDateTime," ",1)
					s tmpDischgTime=$p(EstimDischgDateTime," ",2)
					if (tmpDischgDate>DischgDate){
						s DischgDate=tmpDischgDate
						s DischgTime=tmpDischgTime
					}elseif (DischgDate=tmpDischgDate)&&(DischgTime<tmpDischgTime){
						s DischgTime=tmpDischgTime
					}
				}
				i DischgTime'="" s DischgDateTime=DischgDate_" "_DischgTime
			}
			i DischgDateTime'="" {
				s DischgDate=$$$zd($p(DischgDateTime," "),3)
				s DischgTime=$zt($p(DischgDateTime," ",2))
			}
		} 
	}
	if (DischgDate=""){
		s DischgDate=$$$zd(+$h,3)
		s DischgTime=$zt($p($h,",",2))
	}	
	/*i DischgDate'="" s DischgDate=$$$zd(DischgDate,3)
	e  s DischgDate=$$$zd(+$h,3)
	i DischgTime'="" s DischgTime=$zt(DischgTime)
	e  s DischgTime=$zt($p($h,",",2))*/
	i MedDischDoc'="" s MedDischDoc=$P($g(^CTPCP(MedDischDoc,1)),"^",2),MedDischDoc=##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",MedDischDoc)
	i DischgDoc'="" s DischgDoc=$P($g(^CTPCP(DischgDoc,1)),"^",2),DischgDoc=##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",DischgDoc)
	i DeceasedDate'="" s DeceasedDate=$$$zd(DeceasedDate,3)
	i DeceasedTime'="" s DeceasedTime=$zt(DeceasedTime)
	i DisconId'="" s DisconDesc=$p(^PAC("DISCON",DisconId),"^",2),DisconDesc=##class(User.PACDischCondit).GetTranByDesc("DISCONDesc",DisconDesc)
	
	s ret=EstimDischargeDate_"^"_
		EstimDischargeTime_"^"_
		DischgDate_"^"_
		DischgTime_"^"_
		MedDischDoc_"^"_
		DischgDoc_"^"_
		DeceasedDate_"^"_
		DeceasedTime_"^"_
		DisconDesc_"^"_
		DischgDays
	q ret
}

/// 获取母亲和婴儿的最晚期望出院日期
ClassMethod getEstimDischargeDateTime(EpisodeID)
{
	s dischargeDate=$p($g(^PAADM(EpisodeID)),"^",59)
	s dischargeTime=$p($g(^PAADM(EpisodeID)),"^",60)
	//母亲婴儿一起出院,取母亲和婴儿最晚的出院医嘱开始时间
	if ($p(^DHCTarC("CF",2),"^",5)="Y"){
		s motherloc=..GetPatLoc(EpisodeID)
		s babyAdmId=""
		for{
			s babyAdmId=$o(^PAADMi("Mother",EpisodeID,babyAdmId)) q:babyAdmId=""
		    s pavisit=$p($g(^PAADM(babyAdmId)),"^",20)
		    continue:(pavisit'="A")
		    s babyloc=..GetPatLoc(babyAdmId) //
		    continue:motherloc'=babyloc
		    s babyEstimDischargeDate=$p($g(^PAADM(babyAdmId)),"^",59)
		    s babyEstimDischargeTime=$p($g(^PAADM(babyAdmId)),"^",60)
		    continue:(babyEstimDischargeDate="")||(babyEstimDischargeDate="")
		    if (dischargeDate="")||(babyEstimDischargeDate>dischargeDate) {
			    s dischargeDate=babyEstimDischargeDate
			    s dischargeTime=babyEstimDischargeTime
			}elseif(babyEstimDischargeDate=dischargeDate)&&(dischargeTime<babyEstimDischargeTime) {
				s dischargeTime=babyEstimDischargeTime
			}
	    }
	}
	q:dischargeDate="" ""
	q dischargeDate_" "_dischargeTime
}

// 医生办理出院

ClassMethod doctorDischarge(EpisodeID, orderId, userId, disconId, deaddate = "", deadtime = "", disChargeMethodId = "")
{
	q:EpisodeID="" "没有选择就诊病人!"
	q:$p(^PAADM(EpisodeID),"^",20)="D" "不能对出院病人操作!"
	s ctcpId=$p($g(^SSU("SSUSR",+userId)),"^",14)
	s oeordId=+orderId
	s oeordSub=$p(orderId,"||",2)
	s orderId=oeordId_"||"_oeordSub
	s estimDischargeDate=$p(^OEORD(oeordId,"I",oeordSub,1),"^",9)   //期望出院日期
 	s estimDischargeTime=$p(^OEORD(oeordId,"I",oeordSub,1),"^",10)  //期望出院时间
    i (deaddate["/") s deaddate=$$$zdh(deaddate,4)
	i (deaddate["-") s deaddate=$$$zdh(deaddate,3)
	i (deadtime[":") s deadtime=$zth(deadtime)
	s currentDate=+$h
	s currentTime=$p($h,",",2)
	//更新期望出院日期时间及出院日期时间
	&sql(update PA_ADM set 
		PAADM_EstDischConfirmed='Y',
		PAADM_EstimDischargeDate=:estimDischargeDate,
		PAADM_EstimDischargeTime=:estimDischargeTime,
		PAADM_MedDischDoc_DR=:ctcpId,
		PAADM_UpdateDate=:currentDate,
		PAADM_UpdateTime=:currentTime,
		PAADM_UpdateUser_DR=:userId 
		where PAADM_RowId=:EpisodeID)
	i SQLCODE q "办理出院失败-SQLCODE:"_SQLCODE
	
	&sql(update PA_AdmExt set PAADM_DischgOrderId=:orderId,PAADM_DischargeMethod_DR=:disChargeMethodId where PAADM_RowId=:EpisodeID)
	
	i SQLCODE q "更新出院关联医嘱失败-SQLCODE:"_SQLCODE
	
	//更新出院条件
	i disconId'="" d
    .s mrAdmId=##Class(web.PAAdm).GetMRAdm($g(EpisodeID)) 
    .&sql(update PA_ADM set PAADM_DischCond_DR=:disconId where PAADM_RowId=:EpisodeID)
	.&sql(update MR_Adm set MRADM_ConditAtDisch_DR=:disconId where MRADM_RowId=:mrAdmId)
	.//更新死亡时间
	.i $p(^PAC("DISCON",disconId),"^",3)="D" d
	..s paperDeceased="Y"
	..s paperId=+^PAADM(EpisodeID)
	..//&sql(update PA_Person set PAPER_Deceased=:paperDeceased,PAPER_Deceased_Date=:estimDischargeDate,PAPER_DeceasedTime=:estimDischargeTime where Paper_RowId=:paperId)
	..&sql(update PA_Person set PAPER_Deceased=:paperDeceased,PAPER_Deceased_Date=:deaddate,PAPER_DeceasedTime=:deadtime where Paper_RowId=:paperId)
#;	..i ('SQLCODE) d
#;	...//插入死亡事件(配置：体温单事件维护)
#;	...d ##class(Nur.NIS.Service.VitalSign.Event).AddOrDelPatEvent(EpisodeID, "死亡", "", deaddate, deadtime, 1)
	i SQLCODE q "办理出院失败-SQLCODE:"_SQLCODE
	s ret=..InsertDischargeHistory(EpisodeID,"E",userId,currentDate,currentTime,estimDischargeDate,estimDischargeTime,orderId)
	i ret q "插入日志失败-SQLCODE:"_ret
	
	s admLoc=$p(^PAADM(EpisodeID),"^",4)
	s hospital=$p($g(^CTLOC(admLoc)),"^",22)
	s defHospID=##class(Nur.Interface.Other.BDPInterface).GetDefHospIdByTableName("Nur_IP_NeedCareOrderSet",hospital)
	i defHospID'=""  s ifGetDischgDateTimeByDoc=$g(^DHCDishChargeSet("Disch","ifGetDischgDateTimeByDoc",defHospID))
	e  s ifGetDischgDateTimeByDoc=$g(^DHCDishChargeSet("Disch","ifGetDischgDateTimeByDoc"))
	i ifGetDischgDateTimeByDoc="Y" d ;i $g(^DHCDishChargeSet("Disch","ifGetDischgDateTimeByDoc"))="Y" d
	.&sql(update PA_AdmExt set PAADM_DischargeDate=:estimDischargeDate,PAADM_DischargeTime=:estimDischargeTime where PAADM_RowId=:EpisodeID)
#;	.//插入出院事件(配置：体温单事件维护)
#;	.i deaddate="" d ##class(Nur.NIS.Service.VitalSign.Event).AddOrDelPatEvent(EpisodeID, "出院", "", estimDischargeDate, estimDischargeTime, 1)
	i SQLCODE q "更新出院日期时间失败-SQLCODE:"_SQLCODE
	
	q 0
}

// 医生撤销出院

ClassMethod CancelDoctorDischarge(EpisodeID, userId) As %String
{
	q:EpisodeID="" "没有选择就诊病人!"
	q:$p(^PAADM(EpisodeID),"^",20)="D" "不能对出院病人操作!"
	s paperId=+^PAADM(EpisodeID)
	s estimDischargeDate=$p($g(^PAADM(EpisodeID)),"^",59)
	s estimDischargeTime=$p($g(^PAADM(EpisodeID)),"^",60)
	s deaddate=$p($g(^PAPER(paperId,"ALL")),"^",13)
	s deadtime=$p($g(^PAPER(paperId,"ALL")),"^",8)
	s currentDate=+$h
	s currentTime=$p($h,",",2)
	&sql(update PA_ADM set 
		PAADM_EstDischConfirmed='N',
		PAADM_EstimDischargeDate=null,
		PAADM_EstimDischargeTime=null,
		PAADM_MedDischDoc_DR=null,
		PAADM_DischCond_DR=null,
		PAADM_UpdateDate=:currentDate,
		PAADM_UpdateTime=:currentTime,
		PAADM_UpdateUser_DR=:userId 
		where PAADM_RowId=:EpisodeID)
	i SQLCODE q "撤消出院失败!-SQLCODE:"_SQLCODE
	
	&sql(update PA_AdmExt set PAADM_DischgOrderId=null,PAADM_DischargeMethod_DR=null where PAADM_RowId=:EpisodeID)
	i SQLCODE q "更新出院关联医嘱失败-SQLCODE:"_SQLCODE
	
	s ret=..InsertDischargeHistory(EpisodeID,"C",userId,currentDate,currentTime,"","","")
	i ret q "插入日志失败-SQLCODE:"_ret
	
	s paperId=+^PAADM(EpisodeID)
	&sql(update PA_Person set PAPER_Deceased='N',PAPER_Deceased_Date=null,PAPER_DeceasedTime=null where Paper_RowId=:paperId)
	i SQLCODE q "撤消出院失败!-SQLCODE:"_SQLCODE
	s mrAdmId=$p(^PAADM(EpisodeID),"^",61)
	i mrAdmId'="" d
	.&sql(update MR_Adm set MRADM_ConditAtDisch_DR=null where MRADM_RowId=:mrAdmId)
	i SQLCODE q "撤消出院失败!-SQLCODE:"_SQLCODE
#;	//删除插入的死亡事件
#;	d ##class(Nur.NIS.Service.VitalSign.Event).AddOrDelPatEvent(EpisodeID, "死亡", "", deaddate, deadtime, 0)
	s admLoc=$p(^PAADM(EpisodeID),"^",4)
	s hospital=$p($g(^CTLOC(admLoc)),"^",22)
	s defHospID=##class(Nur.Interface.Other.BDPInterface).GetDefHospIdByTableName("Nur_IP_NeedCareOrderSet",hospital)
	i defHospID'="" s ifGetDischgDateTimeByDoc=$g(^DHCDishChargeSet("Disch","ifGetDischgDateTimeByDoc",defHospID))
	e  s ifGetDischgDateTimeByDoc=$g(^DHCDishChargeSet("Disch","ifGetDischgDateTimeByDoc"))
	i ifGetDischgDateTimeByDoc="Y" d
	.&sql(update PA_AdmExt set PAADM_DischargeDate=null,PAADM_DischargeTime=null where PAADM_RowId=:EpisodeID)
#;	.//删除插入的出院事件(配置：体温单事件维护)
#;	.i deaddate="" d ##class(Nur.NIS.Service.VitalSign.Event).AddOrDelPatEvent(EpisodeID, "出院", "", estimDischargeDate, estimDischargeTime, 0)
	i SQLCODE q "更新出院日期时间失败-SQLCODE:"_SQLCODE
	
	q SQLCODE
}

// 护士召回病人

ClassMethod RecallPatient(EpisodeID, userId)
{
	q:EpisodeID="" "没有选择就诊病人!"
	q:$p(^PAADM(EpisodeID),"^",20)'="D" "不能对非出院病人操作!"
	// +add 过滤已出院并重新办理入院患者
	s inHosFlag=0
	s PAPMIID=+$g(^PAADM(EpisodeID))
    s PAPERDeceased=$p($g(^PAPER(PAPMIID,"ALL")),"^",12)
	s admID=0 f  s admID=$o(^PAPERdr(PAPMIID,"ADM","I",admID)) q:admID=""  d
	.q:EpisodeID=admID
	.s visitStatus=$p(^PAADM(admID),"^",20)
	.s:(visitStatus'="D")&&(visitStatus'="C") inHosFlag=1
	q:inHosFlag=1 "患者已在院！"
	s disChargeDate=$p(^PAADM(EpisodeID),"^",29)
	s disChargeTime=$p(^PAADM(EpisodeID),"^",30)
	s ctcpId=$p($g(^SSU("SSUSR",+userId)),"^",14)
	q:ctcpId="" "请用医护人员的身份操作!"
    s ctcptId=$P($g(^CTPCP(ctcpId,1)),"^",4)
	q:ctcptId="" "未定义医护人员类型!"
    s ctcptInternalType=$P($g(^CT("CPT",ctcptId)),"^",4)
    q:(ctcptInternalType'="NURSE") "请用护士操作!"
    s currentStatus=..GetCurrentDischargeStatus(EpisodeID)
   	q:currentStatus="B" "请先结束费用调整!"
	s retStr=..GetFinalStat(EpisodeID)
	i retStr'=0 q retStr
    
    s orderId=$p(^PAADM(EpisodeID,"DHC"),"^",28)
    s currentDate=+$h
	s currentTime=$p($h,",",2)
	s visitStatusCode="A"
	Set $ZT="ERROR"
	TSTART
	&sql(update PA_ADM set 
		PAADM_VisitStatus=:visitStatusCode,
		PAADM_DischgDoc_DR=null,
		PAADM_DischgDate=null,
		PAADM_DischgTime=null,
		PAADM_UpdateDate=:currentDate,
		PAADM_UpdateTime=:currentTime,
		PAADM_UpdateUser_DR=:userId 
		where PAADM_RowId=:EpisodeID)
		
	i SQLCODE q "召回失败!-SQLCODE:"_SQLCODE
	s retStr=..InsertDischargeHistory(EpisodeID,"R",userId,currentDate,currentTime,"","","")
	i retStr TROLLBACK  q "插入日志失败-SQLCODE:"_retStr
	
	//转到等待区
	s wardId=$p(^PAADM(EpisodeID),"^",70)
	s retStr=##class(web.DHCADTTransaction).MoveAdm(EpisodeID, userId, wardId, "","N")
	i retStr'=0 TROLLBACK  q retStr
	s admLoc=$p(^PAADM(EpisodeID),"^",4)
	s hospital=$p($g(^CTLOC(admLoc)),"^",22)
	s defHospID=##class(Nur.Interface.Other.BDPInterface).GetDefHospIdByTableName("Nur_IP_NeedCareOrderSet",hospital)
	i defHospID'=""  s ifGetDischgDateTimeByDoc=$g(^DHCDishChargeSet("Disch","ifGetDischgDateTimeByDoc",defHospID))
	e  s ifGetDischgDateTimeByDoc=$g(^DHCDishChargeSet("Disch","ifGetDischgDateTimeByDoc"))
	i ifGetDischgDateTimeByDoc'="Y" d
	.&sql(update PA_AdmExt set PAADM_DischargeDate=null,PAADM_DischargeTime=null where PAADM_RowId=:EpisodeID)
#;	.if ('SQLCODE)&&(PAPERDeceased'="Y") d
#;	..//删除插入的出院事件(配置：体温单事件维护)
#;	..d ##class(Nur.NIS.Service.VitalSign.Event).AddOrDelPatEvent(EpisodeID, "出院", "", disChargeDate, disChargeTime, 0)
	i SQLCODE TROLLBACK  q "更新出院日期时间失败-SQLCODE:"_SQLCODE
	#;删除出科记录 add for 交班本
	s inoutSC=##class(Nur.SHIFT.InOutRecord).DeleteLatesetOutRecord(EpisodeID,wardId)
	i inoutSC tro  q "删除出科记录失败-SQLCODE:"_inoutSC
	
	TCOMMIT
	d ..ISendCancelDisInfo(EpisodeID) 
	q retStr
ERROR	; 
	Set ErrorMsg=$ZE	           //得到系统返回的错误消息
 	TROLLBACK		       //回滚事务
 	Quit "错误提示:"_ErrorMsg
}

// 费用调整

ClassMethod RecallPatientForBill(EpisodeID, userId)
{
	q:EpisodeID="" "没有选择就诊病人!"
	q:$p(^PAADM(EpisodeID),"^",20)'="D" "不能对非出院病人操作!"
	s ctcpId=$p($g(^SSU("SSUSR",+userId)),"^",14)
	q:ctcpId="" "请用医护人员的身份操作!"
    s ctcptId=$P($g(^CTPCP(ctcpId,1)),"^",4)
	q:ctcptId="" "未定义医护人员类型!"
    s ctcptInternalType=$P($g(^CT("CPT",ctcptId)),"^",4)
    q:(ctcptInternalType'="NURSE") "请用护士操作!"
   	s currentStatus=..GetCurrentDischargeStatus(EpisodeID)
   	q:currentStatus="B" "该病人已是费用调整状态，不能进行此操作!"
   	
   	s jfFlag=##class(web.UDHCJFBillDetailOrder).ConfirmByAdm(EpisodeID, userId, "费用调整", "C")
   	q:jfFlag'=0 "撤销费用审核失败,不能费用调整"
   	
   	s fzFlag=##class(web.DHCBillInterface).ICheckIsCloseAcount(EpisodeID, "")  //调用计费接口,判断是否封账 20170807
   	q:fzFlag="Y" "已经封账,不能进行费用调整"
   	
	s retStr=..GetFinalStat(EpisodeID)
	i retStr'=0 q retStr
	// 2022.06.14 改为了判断出入转及需关注配置-护士出入转及召回流程控制
    //q:(currentStatus'="F")&(currentStatus'="T") "只能对办理了出院的病人进行操作"
    s currentDate=+$h
	s currentTime=$p($h,",",2)
	Set $ZT="ERROR"
	TSTART
	s retStr=..InsertDischargeHistory(EpisodeID,"B",userId,currentDate,currentTime,"","","")
	i retStr TROLLBACK  q "插入日志失败-SQLCODE:"_retStr

	//s wardId=$p(^PAADM(EpisodeID),"^",70)
	//s retStr=##class(web.DHCADTTransaction).MoveAdm(EpisodeID, userId, wardId, "","N")
	//i retStr'=0 TROLLBACK  q retStr
	
	TCOMMIT
	q retStr
ERROR	; 
	Set ErrorMsg=$ZE	           //得到系统返回的错误消息
 	TROLLBACK		       //回滚事务
 	Quit "错误提示:"_ErrorMsg
}

// 结束费用调整

ClassMethod TerminalRecallPatientForBill(EpisodeID, userId)
{
	q:EpisodeID="" "没有选择就诊病人!"
	q:$p(^PAADM(EpisodeID),"^",20)'="D" "不能对非出院病人操作!"
	s ctcpId=$p($g(^SSU("SSUSR",+userId)),"^",14)
	q:ctcpId="" "请用医护人员的身份操作!"
    s ctcptId=$P($g(^CTPCP(ctcpId,1)),"^",4)
	q:ctcptId="" "未定义医护人员类型!"
    s ctcptInternalType=$P($g(^CT("CPT",ctcptId)),"^",4)
    q:(ctcptInternalType'="NURSE") "请用护士操作!"
    
	s type=..GetCurrentDischargeStatus(EpisodeID)
	q:type'="B" "不能对非费用调整病人进行操作!"
    
    s currentDate=+$h
	s currentTime=$p($h,",",2)
	Set $ZT="ERROR"
	TSTART
	s retStr=..InsertDischargeHistory(EpisodeID,"T",userId,currentDate,currentTime,"","","")
	i retStr TROLLBACK  q "插入日志失败-SQLCODE:"_retStr

	//s wardId=$p(^PAADM(EpisodeID),"^",70)
	//s retStr=##class(web.DHCADTTransaction).MoveAdm(EpisodeID, userId, wardId, "","N")
	//i retStr'=0 TROLLBACK  q retStr
	
	TCOMMIT
	q retStr
ERROR	; 
	Set ErrorMsg=$ZE	           //得到系统返回的错误消息
 	TROLLBACK		       //回滚事务
 	Quit "错误提示:"_ErrorMsg
}

ClassMethod ifDoctorDischarge(EpisodeID)
{
	s estimDischargeDate=$p($g(^PAADM(EpisodeID)),"^",59)
    q:(estimDischargeDate="") 0
    q 1
}

// 护士办理出院

ClassMethod NurseDischarge(EpisodeID, userId, dischgDate, dischgTime)
{
	
	q:EpisodeID="" "没有选择就诊病人!"
	q:$p(^PAADM(EpisodeID),"^",20)="D" "不能对出院病人操作!"
	s ctcpId=$p($g(^SSU("SSUSR",+userId)),"^",14)
	q:ctcpId="" "请用医护人员的身份操作!"
    s ctcptId=$P($g(^CTPCP(ctcpId,1)),"^",4)
	q:ctcptId="" "未定义医护人员类型!"
    s ctcptInternalType=$P($g(^CT("CPT",ctcptId)),"^",4)
    q:(ctcptInternalType'="NURSE") "请用护士操作!"
	s retStr=##class(web.DHCADTTransaction).IfPatOccupyBed(EpisodeID)
	q:retStr'=0 "病人有包床未退!"
	;s dischgDate=$$$zdh(dischgDate,3)
	s dischgDate=##class(websys.Conversions).DateHtmlToLogical(dischgDate)
	s dischgTime=##class(websys.Conversions).TimeHtmlToLogical(dischgTime)  ;$zth(dischgTime)
	s estimDischargeDate=$p($g(^PAADM(EpisodeID)),"^",59)
	s estimDischargeTime=$p($g(^PAADM(EpisodeID)),"^",60)
    q:(estimDischargeDate="") "医生期望出院日期为空,不能办理出院!"
    q:dischgDate>+$h "出院日期不能大于当前日期!"
    s paperId=+^PAADM(EpisodeID)
    s PAPERDeceased=$p($g(^PAPER(paperId,"ALL")),"^",12)
    if (PAPERDeceased="Y"){
	    s deceasedDate=$p($g(^PAPER(paperId,"ALL")),"^",13)
	    s deceasedTime=$p($g(^PAPER(paperId,"ALL")),"^",8)
	    q:dischgDate<deceasedDate "出院日期不能小于患者死亡日期!"
	    q:(deceasedDate=dischgDate)&&(deceasedTime>dischgTime) "护士出院时间不能小患者死亡时间!"
	}else{
	    q:dischgDate<estimDischargeDate "出院日期不能小于医生期望出院日期!"
	    q:(estimDischargeDate=dischgDate)&&(estimDischargeTime>dischgTime) "护士出院时间不能小于医生出院医嘱的开始时间!"
    }
    ts
    s retStr=..DischargeBaby(EpisodeID, userId,$$$zd(dischgDate,3),$zt(dischgTime))
    q:retStr'=0 retStr
    s visitStatusCode="D"	
    s currentDate=+$h
	s currentTime=$p($h,",",2)				
	&sql(update PA_ADM set 
		PAADM_VisitStatus=:visitStatusCode,
		PAADM_DischgDoc_DR=:ctcpId,
		PAADM_DischgDate=:dischgDate,
		PAADM_DischgTime=:dischgTime,
		PAADM_UpdateDate=:currentDate,
		PAADM_UpdateTime=:currentTime,
		PAADM_UpdateUser_DR=:userId 
		where PAADM_RowId=:EpisodeID)
	i SQLCODE tro  q "办理出院失败-SQLCODE:"_SQLCODE
	
	s admLoc=$p(^PAADM(EpisodeID),"^",4)
	s hospital=$p($g(^CTLOC(admLoc)),"^",22)
	s defHospID=##class(Nur.Interface.Other.BDPInterface).GetDefHospIdByTableName("Nur_IP_NeedCareOrderSet",hospital)
	i defHospID'=""  s ifGetDischgDateTimeByDoc=$g(^DHCDishChargeSet("Disch","ifGetDischgDateTimeByDoc",defHospID))
	e  s ifGetDischgDateTimeByDoc=$g(^DHCDishChargeSet("Disch","ifGetDischgDateTimeByDoc"))
	i ifGetDischgDateTimeByDoc'="Y" d
	.&sql(update PA_AdmExt set PAADM_DischargeDate=:dischgDate,PAADM_DischargeTime=:dischgTime where PAADM_RowId=:EpisodeID)
#;	.if ('SQLCODE) d
#;	..//插入出院事件(配置：体温单事件维护)
#;	..i PAPERDeceased'="Y" d ##class(Nur.NIS.Service.VitalSign.Event).AddOrDelPatEvent(EpisodeID, "出院", "", dischgDate, dischgTime, 1)
	i SQLCODE tro  q "更新出院日期时间失败-SQLCODE:"_SQLCODE
	
	s ret=..InsertDischargeHistory(EpisodeID,"F",userId,currentDate,currentTime,dischgDate,dischgTime,"")
	i ret tro  q "插入日志失败-SQLCODE:"_ret
	
#;	s wardId=$o(^PAWARDA(0,"WADM",EpisodeID,""))
#;	i wardId'="" d
#;	    .s wardSub=$o(^PAWARDA(0,"WADM",EpisodeID,wardId,""))
#;	    .i wardSub'="" d
#;	        ..s wadmId=wardId_"||"_wardSub
#;	        ..s transId=$p(^PAWARDA(wardId,"WADM",wardSub),"^",3)
#;	        ..&sql(delete from PAC_WardAdm where WADM_RowId=:wadmId)
#;	s wardId=$o(^PAWARDA(0,"ADM",EpisodeID,""))
#;	i wardId'="" d
#;	    .s bedSub=$o(^PAWARDA(0,"ADM",EpisodeID,wardId,""))
#;	    .i bedSub'="" d
#;	        ..s admSub=$o(^PAWARDA(0,"ADM",EpisodeID,wardId,bedSub,""))
#;	        ..i admSub'="" d
#;	        	...s bedAdmId=wardId_"||"_bedSub_"||"_admSub
#;	        	...s transId=$p(^PAWARDA(wardId,"BED",bedSub,"ADM",admSub),"^",3)
#;	        	...&sql(delete from PAC_BedAdm where ADM_RowId=:bedAdmId)
	
	s wardId="" f  s wardId=$O(^PAWARDA(0,"WADM",EpisodeID,wardId)) q:(wardId="")  d
	.s wardSub="" f  s wardSub=$O(^PAWARDA(0,"WADM",EpisodeID,wardId,wardSub)) q:(wardSub="")  d
	..s wadmId=wardId_"||"_wardSub
	..s transId=$p(^PAWARDA(wardId,"WADM",wardSub),"^",3)
	..&sql(delete from PAC_WardAdm where WADM_RowId=:wadmId)
	        	
	s wardId="" f  s wardId=$O(^PAWARDA(0,"ADM",EpisodeID,wardId)) q:(wardId="")  d
	.s bedSub="" f  s bedSub=$O(^PAWARDA(0,"ADM",EpisodeID,wardId,bedSub)) q:(bedSub="")  d
	..s admSub="" f  s admSub=$O(^PAWARDA(0,"ADM",EpisodeID,wardId,bedSub,admSub)) q:(admSub="")  d
	...s bedAdmId=wardId_"||"_bedSub_"||"_admSub
	...s transId=$p(^PAWARDA(wardId,"BED",bedSub,"ADM",admSub),"^",3)
	...&sql(delete from PAC_BedAdm where ADM_RowId=:bedAdmId)        	
	
	i SQLCODE tro  q "修改病人病区位置错误!"
	#;插入出科记录 for 交班本
	s inoutSC=0
	s:wardId="" wardId=$p(^PAADM(EpisodeID),"^",70)
	i wardId'="" d
	.s inoutSC=##class(Nur.SHIFT.InOutRecord).InsertRecord(EpisodeID,"PO",wardId,$p($g(^PAADM(EpisodeID,"DHC")),"^",29),$p($g(^PAADM(EpisodeID,"DHC")),"^",30))
	i inoutSC tro  q "插入出科记录错误!-SQLCODE:"_inoutSC
	i $g(transId)'="" d
		.s reqstId=$o(^PAC("REQST",0,"Code","D",""))
		.&sql(update PA_AdmTransaction set TRANS_Status_DR=:reqstId,TRANS_UpdateDate=:currentDate,
		TRANS_UpdateTime=:currentTime,TRANS_UpdateUser_DR=:userId where TRANS_RowId=:transId)
	i SQLCODE tro  q "修改病人转科状态错误!"
	//释放小孩床位
	s curPAADMMotherAdmDR=$p(^PAADM(EpisodeID),"^",75)
	s curPAADMMotherAdmDR=+curPAADMMotherAdmDR
	i curPAADMMotherAdmDR'=0 d
	.s babyBedId=$p(^PAADM(EpisodeID),"^",73)
	.s babyBedSub=$p(babyBedId,"||",2)
	.s babyBedtpId=""
	#;.s mBabyBedtpId=$o(^PAC("BEDTP",0,"BEDTP_Code","MATERNALBABY",""))
	.i babyBedSub'="" s babyBedtpId=$p(^PAWARD(+babyBedId,"BED",babyBedSub),"^",2)
	.s mBabyBedtpId="" f  s mBabyBedtpId=$o(^PAC("BEDTP",0,"BEDTP_Code","MATERNALBABY",mBabyBedtpId)) q:(mBabyBedtpId="")  d
	..i babyBedtpId=mBabyBedtpId d
	...s $p(^PAWARD(+babyBedId,"BED",babyBedSub),"^",4)="N"
	...s $p(^PAWARD(+babyBedId,"BED",babyBedSub),"^",1)="BABYBED"_babyBedSub
	
	
	d ..ISendDischargeInfo(EpisodeID) //调用平台接口方法
	s userName=$p(^SSU("SSUSR",userId),"^",2)
	i userName'="" d
	.d ##Class(RISService.InvokeRISService).DiscontinueAllAppInfoPACS(EpisodeID,userName)
	//************************************************************
	//add by zf 20101108
	//最终结算时自动关闭临床路径
	i 'SQLCODE d
	.s flg=##class(web.DHCCPW.MR.Interface).ClosePathWay(EpisodeID)	
	if ##class(websys.Conversions).IsValidMethodName("Nur.SHIFT.Service.ShiftBiz","SavePatientCount")
	{
		d ##class(Nur.SHIFT.Service.ShiftBiz).SavePatientCount(wardId)
	}
	//////////// 如果是妊娠病人置状态为分娩完成 C 
	s pregDr=##class(Nur.IP.Delivery).GetPregnancyID(EpisodeID)
    i pregDr'="" d
    .s PREGStatus=$o(^PAC("PREGST",0,"Code","C",""))
    .&sql(update PA_Pregnancy set  PREG_Status=:PREGStatus where  PREG_RowId=:pregDr)
	tc

	q SQLCODE
}

// 护士办理出院

ClassMethod DischargeBaby(EpisodeID, userId, dischgDate, dischgTime) As %String
{
    //为EpisodeID办理子女的出院
    q:EpisodeID="" "无病人就诊号!"
    q:userId="" "无操作用户!"
    s motherloc=..GetPatLoc(EpisodeID) //
    s babyAdmId="",babyEstimDisch=0
	f  s babyAdmId=$o(^PAADMi("Mother",EpisodeID,babyAdmId)) q:babyAdmId=""  d
	    .s pavisit=$p($g(^PAADM(babyAdmId)),"^",20)
	    .q:(pavisit'="A")
	    .s babyloc=..GetPatLoc(babyAdmId) //
	    .q:motherloc'=babyloc
	    .i $p($g(^PAADM(babyAdmId)),"^",59)="" s babyEstimDisch=1 q
	//i babyEstimDisch  q "请先为该病人的婴儿做医疗结算!"
	
    i ((babyEstimDisch)&($p(^DHCTarC("CF",2),"^",5)="Y")) q "请先为该患者的婴儿做医疗结算!"
    q:$p(^DHCTarC("CF",2),"^",5)'="Y" 0
    #;s mBabyBedtpId=$o(^PAC("BEDTP",0,"BEDTP_Code","MATERNALBABY",""))
    s babyAdmId="",retStr=0
	f  s babyAdmId=$o(^PAADMi("Mother",EpisodeID,babyAdmId)) q:(babyAdmId="")!(retStr'=0)  d
	.s pavisit=$p($g(^PAADM(babyAdmId)),"^",20)
	.q:(pavisit'="A")
	.s babyloc=..GetPatLoc(babyAdmId) //
	.i motherloc'=babyloc  q  //
	.s retStr=..NurseDischarge(babyAdmId, userId,dischgDate,dischgTime)
	.i retStr="不能对出院病人操作!" s retStr=0
	.q:retStr'=0
	.s babyBedId=$p(^PAADM(babyAdmId),"^",73)
	.s babyBedSub=$p(babyBedId,"||",2)
	.s babyBedtpId=""
	.i babyBedSub'="" s babyBedtpId=$p(^PAWARD(+babyBedId,"BED",babyBedSub),"^",2)
	.s mBabyBedtpId="" f  s mBabyBedtpId=$o(^PAC("BEDTP",0,"BEDTP_Code","MATERNALBABY",mBabyBedtpId)) q:(mBabyBedtpId="")  d
	..i babyBedtpId=mBabyBedtpId  d
	...s $p(^PAWARD(+babyBedId,"BED",babyBedSub),"^",4)="N"
	...s $p(^PAWARD(+babyBedId,"BED",babyBedSub),"^",1)="BABYBED"_babyBedSub
    q retStr
}

// 判断病人当前所在科室

ClassMethod GetPatLoc(Adm As %String)
{
  	
  	q:Adm="" "就诊id不存在"
    s dep=""
  	s chl="" f  s chl=$O(^PAADM(Adm,"TRANS",chl),-1) q:(chl="")||(dep'="")  d
    .s loc=$P(^PAADM(Adm,"TRANS",chl),"^",6)
    .q:loc=""
    .s dep=loc
     i dep'="" s dep=$p($p(^CTLOC(dep),"^",2),"-",2)
     q dep
}

ClassMethod ISendDischargeInfo(Adm As %String)
{
	s res=0
	q:Adm="" res
	s rtn=##class(web.DHCENS.EnsHISService).DHCHisInterface("SENDADMOUTINFO",Adm)
    s rtnmes1=$p(rtn,"^")
    s rtnmes2=$p(rtn,"^",2)
    i rtnmes1'=0 s res=rtnmes2
    q rtnmes1
}

ClassMethod ISendCancelDisInfo(Adm As %String)
{
	s res=0
	q:Adm="" res
	s rtn=##class(web.DHCENS.EnsHISService).DHCHisInterface("SENDADMCANCELOUTINFO",Adm)
    s rtnmes1=$p(rtn,"^")
    s rtnmes2=$p(rtn,"^",2)
    i rtnmes1'=0 s res=rtnmes2
    q res
}

ClassMethod GetFinalStat(EpisodeID) As %String
{
    //取得病人财务结算状态,财务最终结算,财务审核。
    s retStr=0
    q:EpisodeID="" "没有病人就诊号!"
    s auditUser=$P($G(^PAADM(EpisodeID,2)),"^",92)
    i auditUser'="" s retStr="财务已审核,不能操作病人!"
    s billFlag=$P($G(^PAADM(EpisodeID)),"^",45)
    i billFlag="Y" s retStr="已做财务结算,不能操作病人!"
    s inadmId=$o(^DHCINADM("0","ADM",EpisodeID,""),-1)
    i inadmId'="" d 
        .s inadmActiveFlag=$p($g(^DHCINADM(inadmId)),"^",11)        ;INSU_AdmInfo表中的INADM_ActiveFlag字段
        .i inadmActiveFlag="out" s retStr="医保已经导出,不能操作病人!"
    q retStr
}

// 判断医生是否可以办理出院接口

ClassMethod GetDocIfCanDischarge(EpisodeID As %String, AllDiagType As %String = "Y") As %String
{
	q ##class(Nur.HISUI.NeedCareOrder).getAbnormalOrder(EpisodeID,"DOCTOR","D","" ,"", "","","A",AllDiagType)
	s retStr=0
	i 1  d
	
	.//出院前必须停的医嘱
	.s stopOrdBeforeDisch = $g(^DHCDishChargeSet("Disch","stopOrdBeforeDisch"))
	.s oeordId=$o(^OEORD(0,"Adm",EpisodeID,""))
	.q:oeordId="" 
	.s oeoriSub=0,oeoreIdStr="",arcimDescStr = ""
	.f  s oeoriSub=$o(^OEORD(oeordId,"I",oeoriSub)) q:oeoriSub=""  d
	..s oeoreId=oeordId_"||"_oeoriSub
    ..s ordStatCode=##Class(web.DHCCLCom).GetOrdStatCode(oeoreId)
    ..q:ordStatCode'="V"
    ..s arcimId=$p(^OEORD(oeordId,"I",oeoriSub,1),"^",2)
    ..s arcimDesc = $p(^ARCIM($p(arcimId,"||"),$p(arcimId,"||",2),1),"^",2)
    ..q:arcimId=""
    ..q:("^"_stopOrdBeforeDisch_"^")'[("^"_arcimId_"^")
    ..i arcimDescStr'[arcimDesc d
	...s arcimDescStr=arcimDescStr_"  "_arcimDesc
	.i arcimDescStr'="" s retStr="1^"_arcimDescStr_" 出院前必须停止！"
	
	.//出院前必须开的医嘱子类//
	.s arcItmChartBeforeDisch=$g(^DHCDishChargeSet("Disch","arcItmChartBeforeDisch"))
	.s itemChartLength = $l(arcItmChartBeforeDisch,"^")
	.f itemIndex=1:1:itemChartLength d
	..s arcicID = $p(arcItmChartBeforeDisch,"^",itemIndex)
	..q:arcicID=""
	..s arcicDesc = $p(^ARC("IC",arcicID),"^",2)
	..s flag = ##class(Nur.DHCADTDischarge).ifExistItmCat(EpisodeID,arcicID)
	..i flag'=1  d
	...i retStr=0 s retStr="1^该病人未开"_arcicDesc_" 医嘱！"
	...e  s retStr=retStr_"^该病人未开"_arcicDesc_" 医嘱！"
	
	.//出院前必须开的诊断类型//
	.s diagBeforeDisch=$g(^DHCDishChargeSet("Disch","diagBeforeDisch"))
  	.s mradmId=$P(^PAADM(EpisodeID),"^",61)
    .s motherAdmId=$P(^PAADM(EpisodeID),"^",75)
    .s motherDeptId=$p($g(^PAADM(+motherAdmId)),"^",4)
    .q:$p($g(^PAADM(+EpisodeID)),"^",4)=motherDeptId 
  	.s mrdiaSub=0
  	.s dtypIdStr=""
  	.f  s mrdiaSub=$O(^MR(mradmId,"DIA",mrdiaSub)) q:(mrdiaSub="")  d
  	..s typSub=0  f  s typSub=$O(^MR(mradmId,"DIA",mrdiaSub,"TYP",typSub)) q:(typSub="")   d
  	...s dtypId=$P(^MR(mradmId,"DIA",mrdiaSub,"TYP",typSub),"^",1)
  	...q:dtypId=""
  	...s dtypIdStr=dtypIdStr_"^"_dtypId
  	.s dtypIdStr=dtypIdStr_"^"
  	.f diagIndex=1:1:$l(diagBeforeDisch,"^")  d
  	..s diaTypeID = $p(diagBeforeDisch,"^",diagIndex)
  	..q:diaTypeID=""
  	..q:$g(^MRC("DTYP",diaTypeID))=""
  	..s DTYPDesc=$p(^MRC("DTYP",diaTypeID),"^",2)
  	..i dtypIdStr'[("^"_diaTypeID_"^") d
  	...i retStr=0 s retStr="1^"_"该病人未开"_DTYPDesc 
  	...e  s retStr=retStr_"^"_"该病人未开"_DTYPDesc 
  	q retStr
}

/// 【尸检病理检查】时未调用接口判断病人是否死亡
/// 返回值：N:未死亡；Y^1840-12-31 00:00:00 死亡^死亡时间
/// W ##class(web.DHCDischargeHistory).GetDocIfCanAutopsy(476)
ClassMethod GetDocIfCanAutopsy(Adm) As %String
{
	q:Adm="" "就诊ID为空"
	s ret=""
	s paperId=+^PAADM(Adm)
	s Tdate = $p($g(^PAPER(paperId,"ALL")),"^",13)
	s Ttime = $p($g(^PAPER(paperId,"ALL")),"^",8)
	i ((Tdate="")&&(Ttime="")) d
	.s ret="N"
	e  d
	.s date = $$$zd(Tdate,3)
	.s time = $zt(Ttime)
	.s datetime = date_" "_time
	.s ret="Y"_"^"_$G(datetime)
	q ret
}

/// Creator:      SongChao
/// CreateDate:   2017.12.22
/// Description:  计费费用核查接口
/// Input:        EpisodeID
/// Return:       0:否,1:是
/// Other: w ##class(web.DHCDischargeHistory).nurSettlementCheck("151")
ClassMethod nurSettlementCheck(EpisodeID)
{
	q:EpisodeID="" 0
	s retsult=0
	s ret = ##class(web.DHCBillInterface).IAdmSettlementCheck(EpisodeID, "", "")
	s count = $l(ret,"^") 
	f index=1:1:count{
		s retsult=$p(ret,"^",index)
		i retsult'=0 s retsult="费用核查未通过,请到【患者住院费用核查】界面处理!"
		q:retsult'=0
	}
	q retsult
}

/// 取出院医嘱对应执行时间
/// w ##class(web.DHCDischargeHistory).getDisOrdExecDate(9)
ClassMethod getDisOrdExecDate(EpisodeID)
{
	s execDateTime="",disChargeOrdId=""
	s sub="" 
	for {
		s sub=$o(^DHCDischargeHistory(EpisodeID,"History",sub),-1) q:(sub="")||(disChargeOrdId'="")
		s data=^DHCDischargeHistory(EpisodeID,"History",sub)
		continue:$P(data,"^",4)'="E" //过滤非医生出院类型
		s disChargeOrdId=$P(data,"^",7)
		continue:disChargeOrdId=""
	}
	q:disChargeOrdId="" execDateTime
	s oeordID=$P(disChargeOrdId,"||"),oeoriSub=$P(disChargeOrdId,"||",2)
	s oeoreSub=0 
	for {
		s oeoreSub=$o(^OEORD(oeordID,"I",oeoriSub,"X",oeoreSub)) q:(oeoreSub="")||(execDateTime'="")
		s execStateDR= $p($g(^OEORD(+oeordID,"I",oeoriSub,"X",oeoreSub)),"^",16)
    	i +execStateDR>0 s execStateCode=$p(^OEC("STAT",execStateDR),"^",1)	
    	continue:($g(execStateCode)'="F")
		s execDate=$p($g(^OEORD(oeordID,"I",oeoriSub,"X",oeoreSub)),"^",19)
		s execTime=$p($g(^OEORD(oeordID,"I",oeoriSub,"X",oeoreSub)),"^",20)
		continue:(execDate="")||(execTime="")
		//s execDate=$$$zd(execDate,3)
		//s execTime=$zt(execTime)
		s execDateTime=execDate_" "_execTime
	}
	q execDateTime
}

Query QueryDichReCallQuery(Startdate As %String, Enddate, recallType, searchLocID, searchWardID, finishStatus, searchPatNo, searchName, HospDr As %String = "") As websys.Query(ROWSPEC = "admLoc,admWard,regNo,patName,telPhone,recallTypeDesc,status,recallDate,recallTime,endDate,endTime,updateUser")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCDischargeHistory","QueryDichReCallQuery","2023-02-11","2023-02-11","","","","","0000000711","",2)
ClassMethod QueryDichReCallQueryExecute(ByRef qHandle As %Binary, Startdate As %String, Enddate, recallType, searchLocID, searchWardID, finishStatus, searchPatNo, searchName, HospDr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s defHospID=##class(Nur.Interface.Other.BDPInterface).GetDefHospIdByTableName("Nur_IP_NeedCareOrderSet",HospDr)
	i defHospID'=""  s ifGetDischgDateTimeByDoc=$g(^DHCDishChargeSet("Disch","ifGetDischgDateTimeByDoc",defHospID))
	e  s ifGetDischgDateTimeByDoc=$g(^DHCDishChargeSet("Disch","ifGetDischgDateTimeByDoc"))
	
 	s Startdate=##class(websys.Conversions).DateHtmlToLogical(Startdate)
	s Enddate=##class(websys.Conversions).DateHtmlToLogical(Enddate)
	s:Startdate="" Startdate=+$h
	s:Enddate="" Enddate=+$h
 	i recallType="" s recallType="C^R"
 	for date=Startdate:1:Enddate {
	 	for i=1:1:$l(recallType,"^"){
		 	s type=$p(recallType,"^",i)
		 	s admId=""
		 	for {
			 	s admId=$o(^DHCDischargeHistory(0,"UpdateDate",date,type,admId)) q:admId=""
			 	s AdmLocID=$p($g(^PAADM(admId)),"^",4)
				s AdmHospID=$p(^CTLOC(AdmLocID),"^",22)
				continue:AdmHospID'=HospDr
				s locID=$p(^PAADM(admId),"^",4)
				continue:(locID'=searchLocID)&&(searchLocID'="")
				s wardID = $p(^PAADM(admId),"^",70)
				continue:(wardID'=searchWardID)&&(searchWardID'="")
				s admLoc=##class(Nur.NIS.Service.Base.Patient).GetCtLocDesc(admId)
				s admWard=##class(Nur.NIS.Service.Base.Patient).GetWardDesc(admId)
				s regNo=##class(Nur.NIS.Service.Base.Patient).GetRegNo(admId)
				continue:(searchPatNo'="")&&(regNo'=searchPatNo)
				s patName=##class(Nur.NIS.Service.Base.Patient).GetPatientName(admId)
				continue:(searchName'="")&&($zcvt(patName,"U")'[$zcvt(searchName,"U"))
				s telPhone=##class(Nur.NIS.Service.Base.Patient).GetTelphone(admId)
				s recallTypeDesc=$case(type,"C":"医生召回","R":"护士召回")
				s recallDate=##class(websys.Conversions).DateLogicalToHtml(date)
			 	s dischHisId=""
			 	for {
				 	s dischHisId=$o(^DHCDischargeHistory(0,"UpdateDate",date,type,admId,dischHisId)) q:dischHisId=""
				 	s recallTime=$p($g(^DHCDischargeHistory(admId,"History",dischHisId)),"^",2)
				 	s recallTime=$zt(recallTime,1)
				 	s updateUserDr=$p($g(^DHCDischargeHistory(admId,"History",dischHisId)),"^",3)
				 	s updateUser=##class(User.SSUser).GetTranByDesc("SSUSRName",$p($g(^SSU("SSUSR",updateUserDr)),"^",2))
				 	s status="未结束",endDate="",endTime=""
				 	s searchTypeStr=$case(ifGetDischgDateTimeByDoc,"Y":"E^F",:"F")
				 	s disDate=date-1
				 	for {
					 	s disDate=$o(^DHCDischargeHistory(0,"DisDate",disDate)) q:disDate=""
					 	for k=1:1:$l(searchTypeStr,"^"){
						 	s searchType=$p(searchTypeStr,"^",k)
						 	s disChildSub=dischHisId-1
						 	for {
							 	s disChildSub=$o(^DHCDischargeHistory(0,"DisDate",disDate,searchType,admId,disChildSub)) q:(disChildSub="")||(endTime'="")
							 	s endDate=$p($g(^DHCDischargeHistory(admId,"History",disChildSub)),"^",5)
							 	s endDate=##class(websys.Conversions).DateLogicalToHtml(endDate)
							 	s endTime=$p($g(^DHCDischargeHistory(admId,"History",disChildSub)),"^",6)
							 	s:endTime'="" endTime=$zt(endTime,1)
							}
							q:endTime'=""
						}
					 	q:endTime'=""
					}
					i endDate'="" s status="结束"
					continue:(finishStatus'=status)&&(finishStatus'="")
					d OutputRow
				}
			}
		}
	}
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow
	set Data=$lb(admLoc,admWard,regNo,patName,telPhone,recallTypeDesc,status,recallDate,recallTime,endDate,endTime,updateUser)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

Storage Default
{
<Data name="DHCDischargeHistoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCDischargeHistoryD</DataLocation>
<DefaultData>DHCDischargeHistoryDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCDischargeHistoryD</IdLocation>
<IndexLocation>^web.DHCDischargeHistoryI</IndexLocation>
<StreamLocation>^web.DHCDischargeHistoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
