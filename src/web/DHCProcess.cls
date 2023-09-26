Import SQLUser

Class web.DHCProcess Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Query LookUpProcAdm(procId As %String, EpisodeID As %String) As %Query(ROWSPEC = "procprId:%String,admId:%String,procprBookingDate:%String,procprDate:%String,procprTime:%String,procprGestatWeek:%String,procprChiefComplaint:%String,procprWeight:%String,procprBPDiastolic:%String,procprBPSystolic:%String,procprUrineProtein:%String,procprHemoglobin:%String,procprEdema:%String,procprUterineHeight:%String,procprAbdomenCircum:%String,procprBabyPosition:%String,procprFetalHeart:%String,procprQuickening:%String,procprPresentation:%String,procprAmnioticFluidVol:%String,procprUrineEstriol:%String,procprBiparictalDis:%String,procprAmnioticFluidThick:%String,procprDisposal:%String,procprCtcpDesc:%String,procprTreat:%String,procprNote:%String,procprUpdateDate:%String,procprUpdateTime:%String,procprUpdateUserName:%String")
{
}

ClassMethod LookUpProcAdmExecute(ByRef qHandle As %Binary, procId As %String = "", EpisodeID As %String = "") As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	i procId="",EpisodeID'="" d
 	    .s procId=$o(^DHCProc(0,"Adm",EpisodeID,""))
 	    .q:procId'=""
 	    .s papmiId=+$g(^PAADM(EpisodeID))
 	    .s procId=$o(^DHCProc(0,"PAPMI",papmiId,""))
 	i procId="" s qHandle=$lb(0,repid,0) q $$$OK
 	s procLnmp=$p(^DHCProc(procId),"^",8)
	s procaSub=0
	f  s procaSub=$o(^DHCProc(procId,"I",procaSub)) q:procaSub=""  d
	    .s admId=$p(^DHCProc(procId,"I",procaSub),"^")
	    .s procprId=$o(^DHCProcPreg(0,"Adm",admId,""))
	    .q:procprId=""
	    .s procprBookingDate=$p(^DHCProcPreg(procprId),"^",2)
	    .i procprBookingDate'="" s procprBookingDate=$zd(procprBookingDate,4)
	    .s procprDate=$p(^DHCProcPreg(procprId),"^",3)
	    .i procprDate'="" s procprDate=$zd(procprDate,4)
	    .s procprTime=$p(^DHCProcPreg(procprId),"^",4)
	    .i procprTime'="" s procprTime=$zt(procprTime)
	    .s procprGestatWeek=$p(^DHCProcPreg(procprId),"^",5)
	    .s curDate=$p(^DHCProcPreg(procprId),"^",3)
	    .i curDate="" s curDate=$p($g(^PAADM(admId)),"^",6)
	    .//s procprGestatWeek=""
	    .i curDate>(procLnmp+30) s procprGestatWeek=(curDate-procLnmp)/7
	    .s procprGestatWeek=$p((procprGestatWeek+0.5),".")
	    .s procprChiefComplaint=$p(^DHCProcPreg(procprId),"^",6)
	    .s procprWeight=$p(^DHCProcPreg(procprId),"^",7)
	    .s procprBPDiastolic=$p(^DHCProcPreg(procprId),"^",8)
	    .s procprBPSystolic=$p(^DHCProcPreg(procprId),"^",9)
	    .s procprUrineProtein=$p(^DHCProcPreg(procprId),"^",10)
	    .s procprHemoglobin=$p(^DHCProcPreg(procprId),"^",11)
	    .s procprEdema=$p(^DHCProcPreg(procprId),"^",12)
	    .s procprUterineHeight=$p(^DHCProcPreg(procprId),"^",13)
	    .s procprAbdomenCircum=$p(^DHCProcPreg(procprId),"^",14)
	    .s babyPosId=$p(^DHCProcPreg(procprId),"^",15)
	    .s procprBabyPosition=""
	    .i babyPosId'="" s procprBabyPosition=$p($g(^PAC("BABYPOS",babyPosId)),"^",2)
	    .s procprFetalHeart=$p(^DHCProcPreg(procprId),"^",16)
	    .s procprQuickening=$p(^DHCProcPreg(procprId),"^",17)
	    .s presId=$p(^DHCProcPreg(procprId),"^",18)
	    .s procprPresentation=""
	    .i presId'="" s procprPresentation=$p($g(^PAC("PRES",presId)),"^",2)
	    .s procprAmnioticFluidVol=$p(^DHCProcPreg(procprId),"^",19)
	    .s procprUrineEstriol=$p(^DHCProcPreg(procprId),"^",20)
	    .s procprBiparictalDis=$p(^DHCProcPreg(procprId),"^",21)
	    .s procprAmnioticFluidThick=$p(^DHCProcPreg(procprId),"^",22)
	    .s procprDisposal=$p(^DHCProcPreg(procprId),"^",23)
	    .s procprCtcpDesc=""
	    .s procprCtcpId=$p(^DHCProcPreg(procprId),"^",24)
	    .i procprCtcpId'="" s procprCtcpDesc=$p($g(^CTPCP(procprCtcpId,1)),"^",2)
	    .s procprTreat=$p(^DHCProcPreg(procprId),"^",25)
	    .s procprNote=$p(^DHCProcPreg(procprId),"^",26)
	    .s procprUpdateDate=$p(^DHCProcPreg(procprId),"^",27)
	    .i procprUpdateDate'="" s procprUpdateDate=$zd(procprUpdateDate,4)
	    .s procprUpdateTime=$p(^DHCProcPreg(procprId),"^",28)
	    .i procprUpdateTime'="" s procprUpdateTime=$zt(procprUpdateTime)
	    .s procprUpdateUserName=""
	    .s procprUpdateUserId=$p(^DHCProcPreg(procprId),"^",29)
	    .i procprUpdateUserId'="" s procprUpdateUserName=$p(^SSU("SSUSR",procprUpdateUserId),"^",2)
	    .
	    .d OutputRow
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow
	s Data=$lb(procprId,admId,procprBookingDate,procprDate,procprTime,procprGestatWeek,procprChiefComplaint,procprWeight,procprBPDiastolic,procprBPSystolic,procprUrineProtein,procprHemoglobin,procprEdema,procprUterineHeight,procprAbdomenCircum,procprBabyPosition,procprFetalHeart,procprQuickening,procprPresentation,procprAmnioticFluidVol,procprUrineEstriol,procprBiparictalDis,procprAmnioticFluidThick,procprDisposal,procprCtcpDesc,procprTreat,procprNote,procprUpdateDate,procprUpdateTime,procprUpdateUserName)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod LookUpProcAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpProcAdmExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {				// fetch row
 		s Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod LookUpProcAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpProcAdmExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

ClassMethod GetProcInfo(regNo As %String = "", EpisodeID As %String = "", procType As %String = "")
{
	q:regNo="" ""
	q:procType="" ""
	q:(regNo="")&(EpisodeID="") ""
	
	s papmiId=+$g(^PAADM(EpisodeID)) //$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(regNo),""))
	i papmiId'="" d
	.s birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
    .s age=..CalAge(birth,+$h)
    .s age=$p(age,"Y",1)_"岁"_$p(age,"Y",2)
    .s age=$p(age,"M",1)_"月"_$p(age,"M",2)
    .s age=$p(age,"D",1)_"天"_$p(age,"D",2)
    .i age>2 s age=$p(age," ",1)
    .i (age>1)&(age<3) s age=$p(age," ",1,2)
    .i age<1 d
    ..s age=$p(age," ",2,3)
    ..i age<1 s age=$p(age," ",2) q
    ..i age>5 s age=$p(age," ",1)
	
	s procId=$o(^DHCProc(0,"Adm",EpisodeID,""))
	i procId="" d
	    .s papmiId=+$g(^PAADM(EpisodeID)) //$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(regNo),""))
	    .q:papmiId=""
	    .s tmpProcId=0
	    .f  s tmpProcId=$o(^DHCProc(0,"PAPMI",papmiId,tmpProcId)) q:(tmpProcId="")!(procId'="")  d
	        ..//q:$p(^DHCProc(tmpProcId),"^",2)'=procctId
	        ..q:$p(^DHCProc(tmpProcId),"^",3)'="O"
	        ..s procId=tmpProcId
	        /*..s procLnmp=$p(^DHCProc(procId),"^",8)
	        ..s formatProcLnmp=""
	        ..i procLnmp>0 s formatProcLnmp=$zd(procLnmp,4)
	        ..s resStr=procId_"^"_formatProcLnmp_"^"
	        ..s procaSub=0
	        ..f  s procaSub=$o(^DHCProc(procId,"I",procaSub)) q:procaSub=""  d
	            ...s resStr=resStr_"!"_$p(^DHCProc(procId,"I",procaSub),"^")*/
	i procId="" q ""

	s procctId=$o(^DHCProcC("Type",0,procType,""))
	q:procctId="" ""
	q:$p($g(^DHCProc(procId)),"^",2)'=procctId ""
	//q:$p(^DHCProc(procId),"^",3)'="O" //对非激活的，只是查询
	s procLnmp=$p(^DHCProc(procId),"^",8)
	s formatProcLnmp=""
	i procLnmp>0 s formatProcLnmp=$zd(procLnmp,4)
	s EpisodeIdStr="!"
	s procaSub=0
	f  s procaSub=$o(^DHCProc(procId,"I",procaSub)) q:procaSub=""  d
	    .s EpisodeIdStr=EpisodeIdStr_$p(^DHCProc(procId,"I",procaSub),"^")_"!"
	s resStr=procId_"^"_EpisodeIdStr_"^"_$p(^DHCProc(procId),"^",3)_"^"_formatProcLnmp_"^"_$p(^DHCProc(procId),"^",9,10)
	s cityAreaId=$p(^DHCProc(procId),"^",14)
	s HRMainReasonId=$p(^DHCProc(procId),"^",17)
	s HRSecondReasonId=$p(^DHCProc(procId),"^",18)
	s lnmpEditReasonID=$p(^DHCProc(procId),"^",19)
	;s resStr=resStr_"^^^^"_cityAreaId_"!"_$p(^CT("CITAREA",+cityAreaId),"^",2)_"^"_$p(^DHCProc(procId),"^",15,16)
	s resStr=resStr_"^^^^"_cityAreaId_"!"_$p(^CT("CITAREA",+cityAreaId),"^",2)_"^"_$p(^DHCProc(procId),"^",15)
	s resStr=resStr_"^"_lnmpEditReasonID_"!"_$p(^DHCProcC("lnmpEditPrReason",+lnmpEditReasonID),"^",2)
	s resStr=resStr_"^"_HRMainReasonId_"!"_$p(^DHCProcC("HRReason",+HRMainReasonId),"^",2)
	s resStr=resStr_"^"_HRSecondReasonId_"!"_$p(^DHCProcC("HRReason",+HRSecondReasonId),"^",2)
	s procbSub=$o(^DHCProc(0,"BookingAdm",EpisodeID,procId,""))
	s bookingDate="",bookingTime=""
	i procbSub'="" s bookingDate=$p(^DHCProc(procId,"Booking",procbSub),"^",5)
	i bookingDate'="" s bookingDate=$zd(bookingDate,4)
	i procbSub'="" s bookingTime=$p(^DHCProc(procId,"Booking",procbSub),"^",6)
	i bookingTime'="" s bookingTime=$zt(bookingTime,2)
	;s resStr=resStr_"^"_bookingDate_"^"_bookingTime
	s resStr=resStr_"^"_bookingDate_"^"_bookingTime_"^"_$g(age)
	q resStr
}

ClassMethod InsertProcess(EpisodeID = "", procType = "", userId = "", formatProcLnmp = "", prePregWeight = "", highRisk = "", cityAreaId = "", phone = "", lnmpEditReason = "", HRMainReasonId = "", HRSecondReasonId = "", lnmpEditReasonID = "") As %String
{
 	//cspRunServerMethod(insertProcess,EpisodeID,"Maternity",userId,procLnmp,prePregWeight,highRisk,cityAreaId,phone,lnmpEditReason,HRMainReasonId,HRSecondReasonId);
 	s ^ypzTmp("epi")=EpisodeID_","_procType_","_userId_","_formatProcLnmp_","_prePregWeight_","_highRisk_","_cityAreaId_","_phone_","_lnmpEditReason_","_HRMainReasonId_","_HRSecondReasonId
	q:EpisodeID="" "就诊号为空!"
	s procId=$o(^DHCProc(0,"Adm",EpisodeID,""))
	i procId'="",$p(^DHCProc(procId),"^",3)'="O" q "本次就诊对应的妊娠已终止!"
	
	i procId="" d
	    .s papmiId=+$g(^PAADM(EpisodeID)) //$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(regNo),""))
	    .q:papmiId=""
	    .s tmpProcId=0
	    .f  s tmpProcId=$o(^DHCProc(0,"PAPMI",papmiId,tmpProcId)) q:(tmpProcId="")!(procId'="")  d
	        ..q:$p(^DHCProc(tmpProcId),"^",3)'="O"
	        ..s procId=tmpProcId

	s regNo=##class(web.DHCCLCom).GetRegNobyEpisodeID(EpisodeID)
	q:procType="" "诊程类型为空!"
	q:userId="" "用户为空!"
	;q:formatProcLnmp="" "末次月经为空!"
	;q:prePregWeight="" "孕前体重为空!"
	q:phone="" "联系电话为空!"
	s papmiId=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(regNo),""))
	q:papmiId="" "未找到登记号为"_regNo_"的病人!"
	s procctId=$o(^DHCProcC("Type",0,procType,""))
	q:procctId="" "未找到诊程类型代码!"
	
	i formatProcLnmp'="" s procLnmp=$zdh(formatProcLnmp,4)
	e  s procLnmp=""
	;xuqy
	s lnmpReasonflag=0
	i procId'="" d
	.s tempProcLnmp=$p($g(^DHCProc(procId)),"^",8)
	.i (procLnmp'="")&(procLnmp'=tempProcLnmp)&(lnmpEditReasonID'="") d
	..s lnmpReasonflag=1
	q:lnmpReasonflag=1 "修改末次月经后，请录入校对原因!"
	;xuqy
	
	//s resStr=procId
	//i procId'="" d
	//    .&sql(update DHC_PA_Process set Proc_Lnmp=:procLnmp where PROC_RowId=:procId)
	//    .i 'SQLCODE s resStr="末次月经日期修改有误!"
	////i procId'="" q resStr
	k PLIST
    s PLIST(2)=papmiId
    s PLIST(3)=procctId
    s PLIST(4)="O"
    s PLIST(6)=+$h
    s PLIST(7)=$p($h,",",2)
    s PLIST(8)=userId
    s PLIST(9)=procLnmp
    s PLIST(10)=prePregWeight
    s PLIST(11)=highRisk
    s PLIST(15)=cityAreaId
    s PLIST(16)=phone
    s PLIST(17)=lnmpEditReason
    s PLIST(18)=HRMainReasonId
    s PLIST(19)=HRSecondReasonId
    s PLIST(20)=lnmpEditReasonID
    i procId'="" d
        .&sql(update DHC_PA_Process  Values :PLIST() WHERE PROC_RowId=:procId)
    e  d
        .&sql(insert into DHC_PA_Process Values :PLIST())
        .i SQLCODE q
        .s procId=$g(%ROWID)
    i SQLCODE q "保存有误! code="_SQLCODE
    q procId
}

ClassMethod SetProcessStatus(procId As %String = "", procStatus As %String = "")
{
	q:procId="" "诊程号为空!"
	i "COX"'[procStatus q "状态不对!"
	&sql(update DHC_PA_Process set PROC_Status=:procStatus where PROC_RowId=:procId)
	i SQLCODE q "修改失败!"
	q "操作成功!"
}

ClassMethod InsertProcAdm(procId As %String = "", admId As %String = "", userId As %String = "")
{
	q:procId="" "无诊程号!"
	q:admId="" "病人就诊号为空!"
	q:userId="" "无用户!"
	&sql(select * from DHC_PA_ProcAdm where PROCA_Parref=:procId and PROCA_Adm_DR=:admId)
	i SQLCODE=0 q SQLCODE //"已有该病人就诊已在诊程中!"
	//s ^ypzTmp("procadm")=procId_"/"_admId
	k PLIST
    s PLIST(0)=procId
    s PLIST(3)=admId
    s PLIST(4)=+$h
    s PLIST(5)=$p($h,",",2)
    s PLIST(6)=userId
    &sql(insert into DHC_PA_ProcAdm Values :PLIST())
    i SQLCODE s err="执行记录插入有误!" q
    q SQLCODE
    //s procaId=$g(%ROWID)
    //q procaId
}

ClassMethod DeleteProcAdm(procId As %String = "", admId As %String = "")
{
	q:procId="" "无诊程号!"
	q:admId="" "病人就诊号为空!"
	&sql(select * from DHC_PA_ProcAdm where PROCA_Parref=:procId and PROCA_Adm_DR=:admId)
	i SQLCODE q "该诊程中没有该病人就诊号!"
	&sql(delete from DHC_PA_ProcAdm where PROCA_Parref=:procId and PROCA_Adm_DR=:admId)
    i SQLCODE q "删除记录有误! 错误码："_SQLCODE
    q "操作成功!"
}

ClassMethod SaveProcPreg(procId As %String = "", EpisodeID As %String = "", userId As %String = "", procprStr As %String = "", nextBookingStr = "")
{
	q:procId="" "无诊程号!"
	q:EpisodeID="" "病人就诊号为空!"
	q:userId="" "无用户!"
	q:procprStr="" "无修改数据!"
	
	//s ^ypzTmp("preg")=procId_"/"_EpisodeID_"/"_userId
	s resStr=..InsertProcAdm(procId,EpisodeID,userId)
	i resStr'=0 q "保存产检有误!"
	k PLIST
	if $o(^DHCProcPreg(0,"Adm",EpisodeID,""))'="" {
		&sql(select * into :PLIST() from DHC_PA_ProcPreg where PROCPR_ADM_DR=:EpisodeID )
		i SQLCODE q "查询数据有误! 错误码: "_SQLCODE
	}
	f i=1:1:$l(procprStr,"^") {
		s PLIST(i+2)=$p(procprStr,"^",i)
	}

	i PLIST(3)'="" s PLIST(3)=$zdh(PLIST(3),4)
	i PLIST(4)'="" s PLIST(4)=$zdh(PLIST(4),4)
	i PLIST(5)'="" s PLIST(5)=$zth(PLIST(5))
	i PLIST(16)'="" s PLIST(16)=$o(^PAC("BABYPOS",0,"Desc",$$ALPHAUP^SSUTIL4(PLIST(16)),""))
	i PLIST(19)'="" s PLIST(19)=$o(^PAC("PRES",0,"Desc",$$ALPHAUP^SSUTIL4(PLIST(19)),""))
	//i PLIST(5)
	s PLIST(25)=$P(^SSU("SSUSR",userId),"^",14)
	s PLIST(28)=+$h
    s PLIST(29)=$p($h,",",2)

    if $o(^DHCProcPreg(0,"Adm",EpisodeID,""))'="" {
	    &sql(update DHC_PA_ProcPreg Values :PLIST() where PROCPR_RowId=:PLIST(1) )
	    i SQLCODE q "修改记录有误! 错误码: "_SQLCODE
	    s procprId=PLIST(1)
    }
    else {
		s PLIST(2)=EpisodeID
	    &sql(insert into DHC_PA_ProcPreg Values :PLIST())
	    i SQLCODE q "执行记录插入有误! 错误码: "_SQLCODE
	    s procprId=$g(%ROWID)
	    //q procprId
    }
    //修改上次预约，插入或更新本次预约
    s ^ypzTmp("book",0)="/1:"_EpisodeID_"/"_procId_"/"_procprId
    ;s procprSub=$o(^DHCProcPreg(0,"Adm",EpisodeID,procId,""))
    s procprSub=""                                          ;xuqy  090623
    s preProcprSub=$o(^DHCProc(procId,"I",procprSub),-1)
    i preProcprSub'="" s preProcprSub=$o(^DHCProc(procId,"I",preProcprSub),-1) ;xuqy  090623
    s ^ypzTmp("book",1)="/1:"_EpisodeID_"/"_procId_"/"_procprId_"/"_preProcprSub
    i preProcprSub>0 d
        .s preEpisodeID=+^DHCProc(procId,"I",preProcprSub)
        .q:preEpisodeID=0
        .s procbSub=$o(^DHCProc(0,"BookingAdm",preEpisodeID,procId,""))
        .q:procbSub=""
        .s procbId=procId_"||"_procbSub
        .s ^ypzTmp("book",11)="/1:"_EpisodeID_"/"_procId_"/"_procbSub
        .s resStr=##class(web.DHCPAProcBooking).UpdateBooking(procbId,"A",EpisodeID,userId)
    i resStr'=0 q resStr
    s procHighRisk=$p(^DHCProc(procId),"^",10)
    s ^ypzTmp("book",2)="/1:"_procId_"/"_preProcprSub_"/"_procHighRisk
    i procHighRisk="Y" d
        .s bookingDept=$p(^PAADM(EpisodeID),"^",4)
        .s bookingDate=$p(nextBookingStr,"^",1)
        .q:bookingDate=""
        .s bookingTime=$p(nextBookingStr,"^",2)
        .q:bookingTime=""
        .s procbSub=$o(^DHCProc(0,"BookingAdm",EpisodeID,procId,""))
        .s ^ypzTmp("book",3)="/1:"_EpisodeID_"/"_procId_"/"_procbSub
        .i procbSub="" d
            ..s resStr=##class(web.DHCPAProcBooking).AddBooking("B",EpisodeID,bookingDept,userId,bookingDate,bookingTime)
        .e  d
            ..s bookingDate=$zdh(bookingDate,4)
            ..s bookingTime=$zth(bookingTime,2)
            ..s procbId=procId_"||"_procbSub
            ..s updateDate=+$h
            ..s updateTime=$p($h,",",2)
            ..&SQL(update DHC_PA_ProcBooking set PROCB_BookingUser_DR=:userId,PROCB_BookingDate=:bookingDate,PROCB_BookingTime=:bookingTime,PROCB_UpdateUser_DR=:userId,PROCB_UpdateDate=:updateDate,PROCB_UpdateTime=:updateTime where PROCB_RowId=:procbId)
            ..s retStr=SQLCODE
    s ^ypzTmp("book",4)="/1:"_EpisodeID_"/"_procbSub
    q resStr //"操作成功!"
}

ClassMethod DeleteProcPreg(procId As %String = "", admId As %String = "")
{
	q:procId="" "无诊程号!"
	q:admId="" "病人就诊号为空!"
	s resStr=..DeleteProcAdm(procId, admId)
	i resStr q "删除该次产检有误!"
	
    if $o(^DHCProcPreg(0,"Adm",admId,""))'="" {
	    &sql(delete from DHC_PA_ProcPreg where PROCPR_ADM_DR=:admId)
	    i SQLCODE q "修改记录有误! 错误码: "_SQLCODE
    }
    else {q "没有该记录!"}
    q "操作成功!"
}

Query GetBabyPosition() As %SQLQuery(CONTAINID = 1, ROWSPEC = "BABYPOS_RowId:%Integer,BABYPOS_Desc:%String")
{
    select BABYPOS_Desc,BABYPOS_RowId from PAC_BabyPosition
}

Query GetPresentation() As %SQLQuery(CONTAINID = 1, ROWSPEC = "PRES_RowId:%Integer,PRES_Desc:%String")
{
    select PRES_Desc,PRES_RowId from PAC_Presentation
}

ClassMethod GetWeek(procLnmp)
{
	q:procLnmp="" "无末次月经日期"
	s gestateDay=+$H-$ZDH(procLnmp,4)
    q (gestateDay\7)_"周"_(gestateDay-(gestateDay\7*7))_"天"
}

Query GetCityArea() As %SQLQuery(CONTAINID = 1, ROWSPEC = "CITAREA_RowId:%Integer,CITAREA_Desc:%String")
{
    select CITAREA_Desc,CITAREA_RowId from CT_CityArea,CT_Hospital where CITAREA_City_DR=HOSP_City
}

Query LookUpProcC(node) As %Query(ROWSPEC = "nodeDesc:%String,nodeId:%String")
{
}

ClassMethod LookUpProcCExecute(ByRef qHandle As %Binary, node As %String = "Type") As %Status
{
 	s repid=$i(^CacheTemp)
 	s ^ypzTmp("node")=node
 	i $g(ind)="" s ind=1
 	i node="" s qHandle=$lb(0,repid,0) q $$$OK
	s nodeId=0
	f  s nodeId=$o(^DHCProcC(node,nodeId)) q:nodeId=""  d
	    .s nodeDesc=$p(^DHCProcC(node,nodeId),"^",2)
	    .d OutputRowProcC
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRowProcC
	s Data=$lb(nodeDesc,nodeId)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod LookUpProcCFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpProcCExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {				// fetch row
 		s Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod LookUpProcCClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpProcCExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 根据出生日计算年龄
ClassMethod CalAge(IBirth As %String, IToday As %String)
{
    s IBirth=$g(IBirth),IToday=$g(IToday)
    i IBirth>2980000 s IBirth=""
    i IBirth<0 s IBirth=""
    q:'$G(IBirth) ""
    s XBirth=$ZD(IBirth)
    s XToday=$ZD(IToday)
    s AgeMth=XToday-XBirth
    s AgeDay=$p(XToday,"/",2)-$p(XBirth,"/",2)
    s CurrYear=$p(XToday,"/",3) s:CurrYear<100 CurrYear=CurrYear+1900
    s BirthYear=$p(XBirth,"/",3) s:BirthYear<100 BirthYear=BirthYear+1900
    s AgeYear=CurrYear-BirthYear
    i AgeDay<0 d
        . s AgeMth=AgeMth-1
	    . s AgeDay=AgeDay+$p("31,31,28,31,30,31,30,31,31,30,31,30,31",",",+XToday)
	    . q:XToday'=2
	    . s:((CurrYear#4)=0)&(((CurrYear#100)'=0)!((CurrYear#400)=0)) AgeDay=AgeDay+1
	i AgeMth<0 s AgeMth=AgeMth+12,AgeYear=AgeYear-1
	s $P(AgeYr,"|",12)=AgeYear
	s reage=$p(AgeYr,"|",12)_"Y "_AgeMth_"M "_AgeDay_"D"
	q reage
}

}
