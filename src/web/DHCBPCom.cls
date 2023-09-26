Import SQLUser

Class web.DHCBPCom Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod GetCurDateAndTime() As %String
{
	s dat=$zd(+$h,3)
	s tim=$zt($p($h,",",2))
	q dat_"^"_tim
}

ClassMethod GetEqUomQty(arcimId) As %String
{
	q:arcimId="" "^1"
	s phcdfId=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),1)),"^",12)
	q:phcdfId="" "^1"
	s phcdId=+phcdfId,phcdfSub=$p(phcdfId,"||",2)
	q:phcdfSub="" "^1"
	s baseUomId=$p(^PHCD(phcdId,"DF",phcdfSub,2),"^",4)
	
	s eqUomId=baseUomId,eqQty=1
	s eqId=0
	f  s eqId=$o(^PHCD(phcdId,"DF",phcdfSub,"EQ",eqId)) q:eqId=""  d
		.s eqUomId=+^PHCD(phcdId,"DF",phcdfSub,"EQ",eqId)
		.s eqQty=$p(^PHCD(phcdId,"DF",phcdfSub,"EQ",eqId),"^",2) q
	i eqQty=0 s eqQty=1
	i $p(eqQty,".",1)="" s eqQty=0_eqQty
	q eqUomId_"^"_eqQty
}

ClassMethod GetCTUom() As %String
{
	k ^TMPBP("Com",$i)
	s ctuomCode=0,i=0
	f  s ctuomCode=$o(^CT("UOM",0,"Code",ctuomCode)) q:ctuomCode=""  d
	    .s ctuomId=$o(^CT("UOM",0,"Code",ctuomCode,""))
	    .q:ctuomId=""
	    .s sortNo=$p(^CT("UOM",ctuomId),"^",3)
	    .i +sortNo'=sortNo s sortNo=10000
	    .s sortNo=sortNo+(ctuomId/10000)
	    .s unitDesc=$ZCVT($p($g(^CT("UOM",+ctuomId)),"^",2),"l")
	    .s unitCode=$p(^CT("UOM",+ctuomId),"^",1)
	    .s tmpUom(sortNo)=ctuomId_"^"_unitDesc_"^"_unitCode
	s sortNo=""
	f  s sortNo=$o(tmpUom(sortNo)) q:sortNo=""  d
	    .s i=i+1 
		.s ^TMPBP("Com",$i,i)=tmpUom(sortNo)
	q i
}

ClassMethod GetPHCInstruct() As %String
{
	k ^TMPBP("Com",$i)
	s phcinId=0,i=0
	f  s phcinId=$o(^PHCIN(phcinId)) q:phcinId=""  d
	    .s sortNo=+$p(^PHCIN(phcinId),"^",3)
	    .i sortNo=0 s sortNo=10000
	    .s sortNo=sortNo+(phcinId/10000)
	    .s tmpPhcin(sortNo)=phcinId_"^"_$p(^PHCIN(phcinId),"^",2)_"^"_$p(^PHCIN(phcinId),"^",1)
	s sortNo=""
	f  s sortNo=$o(tmpPhcin(sortNo)) q:sortNo=""  d
	    .s i=i+1 
		.s ^TMPBP("Com",$i,i)=tmpPhcin(sortNo)
	q i
}

ClassMethod GetPHCFreq() As %String
{
	k ^TMPBP("Com",$i)
	s phcfrId=0,i=0
	f  s phcfrId=$o(^PHCFR(phcfrId)) q:phcfrId=""  d
	.s sortNo=+$p(^PHCFR(phcfrId),"^",3)
	.i sortNo=0 s sortNo=10000
	.s sortNo=sortNo+(phcfrId/10000)
	.s tmpPhcfr(sortNo)=phcfrId_"^"_$p(^PHCFR(phcfrId),"^",4)_"^"_$p(^PHCFR(phcfrId),"^",1)
	s sortNo=""
	f  s sortNo=$o(tmpPhcfr(sortNo)) q:sortNo=""  d
	    .s i=i+1 
		.s ^TMPBP("Com",$i,i)=tmpPhcfr(sortNo)
	q i
}

ClassMethod GetPHCDuration() As %String
{
	k ^TMPBP("Com",$i)
	s phcduId=0,i=0
	f  s phcduId=$o(^PHCDU(phcduId)) q:phcduId=""  d
	.s statDate=$p($g(^PHCDU(phcduId)),"^",5) //开始日期 add mfc 20201120
	.q:(statDate'="")&&(statDate>+$h)
	.s endDate=$p($g(^PHCDU(phcduId)),"^",6) //结束日期
	.q:(endDate'="")&&(endDate<+$h)
	.s sortNo=+$p(^PHCDU(phcduId),"^",2)
	.i sortNo=0 s sortNo=10000
	.s sortNo=sortNo+(phcduId/10000)
	.s tmpPhcdu(sortNo)=phcduId_"^"_$p(^PHCDU(phcduId),"^",3)_"^"_$p(^PHCDU(phcduId),"^",1)
	s sortNo=""
	f  s sortNo=$o(tmpPhcdu(sortNo)) q:sortNo=""  d
	    .s i=i+1 
		.s ^TMPBP("Com",$i,i)=tmpPhcdu(sortNo)
	q i
}

ClassMethod GetCTLoc(typeStr As %String = "W^E^D^OP^EM^CL") As %String
{
	k ^TMPBP("Com",$i)
	s ctlocId=0,i=0
	f  s ctlocId=$o(^CTLOC(ctlocId)) q:ctlocId=""  d
	    .q:"^"_typeStr_"^"'[("^"_$p(^CTLOC(ctlocId),"^",13)_"^")
	    .s ctlocStatDate=$p(^CTLOC(ctlocId),"^",24) //开始日期 add mfc 20201112
		.q:(ctlocStatDate'="")&&(ctlocStatDate>+$h)
	    .s ctlocEndDate=$p(^CTLOC(ctlocId),"^",25) //结束日期
		.q:(ctlocEndDate'="")&&(ctlocEndDate<+$h)
	    .//w $p(^CTLOC(ctlocId),"^",2),!
	    .s ^TMPBP("Com",$i,i)=ctlocId_"^"_$p(^CTLOC(ctlocId),"^",2)
	    .s i=i+1 
	q i
}

ClassMethod UpdateBedEquip(wardId As %String, bedEquipIp As %String) As %String
{
	q:(wardId="" || bedEquipIp="") "-1"
	s bedEquipId=""
	s count=0
	f  s bedEquipId=$o(^DHCBPBedEquip(bedEquipId)) q:bedEquipId=""  d
		.s bedId=$p($g(^DHCBPBedEquip(bedEquipId)),"^",1)
		.s bedWardId=$p($g(bedId),"||",1)
		.q:(bedWardId'=wardId)
		.s equipAddress=$p($g(^DHCBPBedEquip(bedEquipId)),"^",3)
		.s firstField=$p($g(equipAddress),"|",1)
		.s secondField=$p($g(equipAddress),"|",2)
		.s thirdField=$p($g(equipAddress),"|",3)
		.s fourthField=$p($g(equipAddress),"|",4)
		.s secondField=bedEquipIp
		.s $p(^DHCBPBedEquip(bedEquipId),"^",3)=firstField_"|"_secondField_"|"_thirdField_"|"_fourthField
		.s count=count+1
	q count
}

// 未修改

ClassMethod AutoTerminal(bpaId, bedId) As %String
{
	s retStr=0
	q:bpaId="" 0
	q:'$d(^DHCBPArrange(bpaId)) 0
	q:bedId="" 0
	q:$lg(^DHCBPArrange(bpaId),9)'="M" 0
	//s EpisodeID=$p(^DHCBPArrange(+bpaId),"^",1)
	///q:EpisodeID="" 0
	//s paadmVisitStatus=$p($g(^PAADM(EpisodeID)),"^",20)
	//q:paadmVisitStatus="" 0
	s bprTime=$o(^DHCBPRecord(0,"DateTime",$h,bpaId,""))
	i (bprTime="") d
		.s ^tmpCLEquip("autoBP",bpaId)=$zd($h,3)_" "_$zt($p($h,",",2))
		.&sql(update DHC_BP_Arrange set BPA_Status='T' where BPA_RowId=:bpaId)
		.s retStr=..StopEquipCollect(bpaId,bedId)
	e  d
		.s bpprId=$lg(^DHCBPArrange(bpaId),1)
		.q:bpprId=""
		.s papmiId=$lg(^DHCBPPatRegister(bpprId),1)
		.q:papmiId=""
		.s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
		.s bpaStartDate=$p(^DHCBPArrange(bpaId),"^",6)
		.s retStr="InRoom"_"^"_"病人"_patName_"(监护Id:"_bpaId_")正在监护!请选择日期"_$zd(bpaStartDate,3)_"查询,结束监护,退出后方可继续操作!"
	q retStr
}

ClassMethod SetInDateTime(bpaId As %String, startDate As %String, startTime As %String, isSet As %String = "1") As %String
{
	q:(+bpaId=0) "-1"
	s startDate=##class(web.DHCANOPCom).ConvertToDateH(startDate)
	s startTime=##class(web.DHCANOPCom).ConvertToTimeH(startTime)
	q:'$d(^DHCBPArrange(bpaId)) -2
	//R为准备，M为监护，T为中止，只有这三种才能开始重症监护
	q:"RMT"'[$lg(^DHCBPArrange(bpaId),9) "监护状态不对!"
	s bpcBedId=$lg(^DHCBPArrange(bpaId),7)
	q:+bpcBedId=0 -3 ;"未定义床位!"
	
	s retStr=0
	s monBpaId=$o(^DHCBPArrange(0,"BedStatus",bpcBedId,"M",""))
	i monBpaId'="",monBpaId'=bpaId d
		.s retStr=..AutoTerminal(monBpaId, bpcBedId)
	q:retStr'=0 retStr
	
	////s bpaId=..GetBPpId(bpaId)
	s interval="" ///get from roomequip
	
	i "RT"[$lg(^DHCBPArrange(bpaId),9) d
		.s null=""
		.&sql(update DHC_BP_Arrange set bpa_Status='M',BPA_EndDate=:null,BPA_EndTime=:null where BPA_RowId=:bpaId)
		.s retStr=SQLCODE
	q:retStr'=0 retStr
	
	//为点击开始按钮进入，写入室时间
	i isSet d
		.//s retStr=##class(web.DHCBPArrange).AdjBpaStartDateTime(EpisodeID, .startDate, .startTime)
		.//q:retStr'=0
		.i (startDate="")!(startTime="") s retStr="该病人转病区时间有误!" q
		.&sql(update DHC_BP_Arrange set BPA_Date=:startDate,BPA_Time=:startTime where BPA_RowId=:bpaId)
		.i SQLCODE s retStr="修改入室时间错！SQLCODE="_SQLCODE
	q:retStr'=0 retStr
	
	//不论启动设备是否成功，都可以手工操作
	s retStr=..StartEquipCollect(bpaId)
	q retStr
}

ClassMethod SetOutDateTime(bpaId As %String, outDate As %String, outTime As %String) As %String
{
	q:(+bpaId=0) -1
	s outDate=##class(web.DHCANOPCom).ConvertToDateH(outDate)
	s outTime=##class(web.DHCANOPCom).ConvertToTimeH(outTime)
	s bpcBedId=$lg(^DHCBPArrange(bpaId),7)
	q:+bpcBedId=0 -2
	s retStr=..StopEquipCollect(bpaId)
	    
	i outDate>$h s outDate=+$h,outTime=$p($h,",",2)
	i retStr=0 d
	    .&sql(update DHC_BP_Arrange set BPA_Status='T',BPA_EndDate=:outDate,BPA_EndTime=:outTime where BPA_RowId=:bpaId)
	    .i SQLCODE s retStr=SQLCODE
    q retStr
}

// 启动血透设备任务

ClassMethod StartEquipCollect(bpaId As %String) As %String
{
	// w ##class(web.DHCBPCom).StartEquipCollect(bpaId)
	q:(+bpaId=0) "无监护Id!"
	//R为准备，M为监护，T为中止，只有这三种才能开始重症监护过程
	s bpaStatus=$lg($g(^DHCBPArrange(bpaId)),9)
	//q:"RMT"'[bpaStatus "监护状态不对:"_bpaStatus
    s bpcBedId=$lg(^DHCBPArrange(bpaId),7)
    q:+bpcBedId=0 "未定义床位!"
	
    s monBpaId=bpaId
	i $d(^DHCBPArrange(0,"BedStatus",bpcBedId,"M"))>0 d
	    .s monBpaId=$o(^DHCBPArrange(0,"BedStatus",bpcBedId,"M",""))
	    .i monBpaId'=bpaId s retStr="otherPat:"_monBpaId ; 前一个病人未停止监护
	s arrangDate=""
	&sql(
	select BPA_Date into:arrangDate from dhc_bp_arrange where BPA_RowId=:monBpaId)
	// 如果该床有在监护的患者且安排时间是当天的则不开始监护
	s patName=""
	i monBpaId'="" s patName=..GetPatInfo(monBpaId) s patName=$p(patName,"^",1)
    q:((monBpaId'=bpaId)&&(arrangDate=+$h)) patName_"未下机  "_monBpaId ; 前一个病人未停止监护
    
    s retStr=""
    // 循环 DHC_BP_BedEquip 表中该床位中的所有设备
    s rowId="" f  s rowId=$o(^DHCBPBedEquip(0,"Bed",bpcBedId,rowId)) q:((rowId="")||(retStr["TimeOut"))  d
        .q:'$d(^DHCBPBedEquip(rowId))
        .i bpaStatus="R" s $li(^DHCBPBedEquip(rowId),8)=1
        .s curRet=""
		.i $li(^DHCBPBedEquip(rowId),8)=1 s curRet=..ExcuteTask(rowId, bpaId, "StartEq")
		.e  s curRet=rowId_":已手动停止监护"
        .i retStr="" s retStr=curRet
        .e  s retStr=retStr_";"_curRet
        
		
    q retStr
}

// 执行采集任务

// equipId:

ClassMethod ExcuteTask(equipId As %String, bpaId As %String, cmd As %String) As %String
{
	// w ##class(web.DHCBPCom).ExcuteTask(equipId,bpaId,"StopEq") ;"StartEq"
	s retStr="" ,source="B",interval=0,devType="",devTypeId="",extInfo=""
	s eqObj=##Class(User.DHCBPBedEquip).%OpenId(equipId)
	q:eqObj="" "Inavlid equipId:"_equipId
	s IP=eqObj.BPBETcpipAddress
	s port=eqObj.BPBEPort
	q:eqObj.BPBECollectTypeDr="" "DevType is NULL"
	s devType=eqObj.BPBECollectTypeDr.ANCCTCode
	s interval=+eqObj.BPBEDefaultInterval
	i +interval=0 s interval=300
	s interval=interval*1000 ; 转化为毫秒
	
	d eqObj.%Close()
	s retStr=##class(web.DHCCLDevTool).ExcuteDevTask(source,equipId,bpaId,IP,port,interval,devType,extInfo,cmd)
    
    q retStr
}

/// 停止监护设备
ClassMethod StopEquipCollect(bpaId As %String) As %String
{
	//w ##class(web.DHCBPCom).StopEquipCollect(bpaId)
	q:(+bpaId=0) -1
	s bedId=$lg(^DHCBPArrange(bpaId),7)
	q:+bedId=0 -2
    s bpbeId="",retStr=0
    f  s bpbeId=$o(^DHCBPBedEquip(0,"Bed",bedId,bpbeId)) q:(bpbeId="")||(retStr["TimeOut")  d
        .q:'$d(^DHCBPBedEquip(bpbeId))
        .s retStr=..ExcuteTask(bpbeId, bpaId, "StopEq")
    q retStr
}

ClassMethod StartAllTask(para = "Start") As %String
{
	// w ##class(web.DHCBPCom).StartAllTask()
	&sql(DECLARE EmpCursor CURSOR FOR 
	select BPBE_RowId,BPBE_Bed_Dr into :equipId ,:bedId
	from DHC_BP_BedEquip)
	&sql(OPEN EmpCursor)
    FOR {
	    &sql(FETCH EmpCursor)
        QUIT:SQLCODE 
        set bpaId=""
        &sql(SELECT BPA_RowId into :bpaId 
        FROM DHC_BP_Arrange 
        WHERE BPA_Status='M' AND BPA_BPCBed_Dr=:bedId)
        w "equipId:",equipId,"  bapId:",bpaId,!
        do ..ExcuteTask(equipId, bpaId, "StartEq")
    }
    quit 0
    
	/*
	s ondeDay=3600*24
	//s rowId="",bedId="",ip="",port="",interfaceCode="",interval=60
	&sql(DECLARE EmpCursor CURSOR FOR 
	SELECT BPBE_RowId, BPBE_Bed_Dr, BPBE_TcpipAddress, BPBE_Port, BPBE_CollectType_Dr->ANCCT_Code, BPBE_DefaultInterval into :equipId,:bedId,:ip,:port,:interfaceCode,:interval FROM DHC_BP_BedEquip WHERE BPBE_Bed_Dr IS NOT NULL)
	&sql(OPEN EmpCursor)
    FOR {&sql(FETCH EmpCursor)
        QUIT:SQLCODE 
    s date=+$h
    s time=$p($h,",",2)
    
    s daySeqNo=""
    i time<=(12*3600) s daySeqNo="A"
    i time>(12*3600) s daySeqNo="P"
    i time>(18*3600) s daySeqNo="N"
    &sql(SELECT top 1 BPA_RowId ,BPA_Date*:ondeDay+BPA_Time AS DateTime into:bpaId,:dateTime 
    FROM DHC_BP_Arrange WHERE BPA_Status='M' AND BPA_BPCBed_Dr=:bedId and BPA_Date=:date and BPA_DaySeqNo=:daySeqNo
    ORDER BY DATETIME desc)
    i para="Start" s retStr=..StartEquipCollect(bpaId)
    e  s retStr=..StopEquipCollect(bpaId)
    w para_":"_retStr,!
 	}
 	&sql(CLOSE EmpCursor)
 	q ""
 	*/
}

ClassMethod GetPatInfo(bpaId As %String, equipId As %String = "") As %String
{
	// w ##class(web.DHCBPCom).GetPatInfo(bpaId)
	if bpaId=""
	{
		set bedDesc=""
		&sql(SELECT BPBE_Bed_Dr->BPCB_Desc into :bedDesc 
		FROM DHC_BP_BedEquip 
		WHERE BPBE_RowId=:equipId)
		return "无病人，床位:"_bedDesc
	}
	q:(+bpaId=0) ""
	s bpprId=$lg(^DHCBPArrange(bpaId),1)
	q:bpprId="" ""
	s papmiId=$lg(^DHCBPPatRegister(bpprId),1)
	q:papmiId="" ""
	s regNo=$p(^PAPER(papmiId,"PAT",1),"^",1)
	s patName=$p(^PAPER(papmiId,"ALL"),"^",1)

	s patSex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
	s patBirth=$p($g(^PAPER(papmiId,"ALL")),"^",6)	//出生日期
	s bpaBPCBedDr=$lg(^DHCBPArrange(bpaId),7)
	s bpaBPCBedDesc=$lg($g(^DHCBPC("Bed",+bpaBPCBedDr)),2)
	s patAge=##class(web.DHCClinicCom).CalAge(patBirth,+$h)
	q patName_"^"_patSex_"^"_$zd(patBirth,3)_";"_bpaBPCBedDesc_";"_regNo
}

ClassMethod GetInOutDateTime(bpaId As %String) As %String
{
	s inOutDateTime = $zd(+$h,3)_"^"_$zt($p($h,",",2))_"^"_$zd(+$h,3)_"^"_$zt($p($h,",",2))
	q:(+bpaId=0) inOutDateTime
	q:'$d(^DHCBPArrange(bpaId)) inOutDateTime

	s resStr=$zd($lg(^DHCBPArrange(bpaId),4),3)
	s resStr=resStr_"^"_$zt($lg(^DHCBPArrange(bpaId),"^",5))
	s resStr=resStr_"^"_$zd($lg(^DHCBPArrange(bpaId),"^",55),3)
	s resStr=resStr_"^"_$zt($lg(^DHCBPArrange(bpaId),"^",56))
	q resStr
}

ClassMethod FormatDuration(intervalSec, dayExpress) As %String
{
	//dayExpress不为空，显示的是日期的显示单位及间隔符，为空显示小时数，不显示天数
	i intervalSec<0.0001 q ""
	s intervalDay=$p((intervalSec/86400),".")
	//w intervalSec,!
	
	i +intervalDay=0 s intervalDay=""
	s formatTime=$zt((intervalSec-(86400*intervalDay)),2)
	i intervalDay'="" d
	    .i dayExpress="" d
	        ..s $p(formatTime,":")=intervalDay*24+formatTime
	        ..s intervalDay=""
	    .s intervalDay=intervalDay_dayExpress
	q intervalDay_formatTime
}

ClassMethod GetPatientAgeByDate(bpaId As %String, date As %String) As %String
{
	q:(+bpaId=0) ""
	i date="" s date=##class(web.DHCANOPCom).ConvertToDateH(+$h)
	e  s date=##class(web.DHCANOPCom).ConvertToDateH(date)
	s bpprId=$lg($g(^DHCBPArrange(bpaId)),1)
	q:bpprId="" ""
	s papmiId=$lg(^DHCBPPatRegister(bpprId),1)
	s birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
	s ageInfo=##class(web.DHCANOPCom).CalAge(birth,date)
	q ageInfo
}

ClassMethod GetPatientBedInfoByDateTime(bpaId As %String, date As %String, time As %String) As %String
{
	
	q:(+bpaId=0) ""
	s bpaBPCBedDr=$lg(^DHCBPArrange(bpaId),7)
	s bpaBPCBedDesc=$lg($g(^DHCBPC("Bed",+bpaBPCBedDr)),2)
	q bpaBPCBedDesc
}

/// 返回以^分割的串
/// patBaseInfo^patInfo^patOtherHIS^patAnInfo
/// patInfo:就诊日期，诊断，BP住天数，就诊号，病区Id，常规开始日期，常规开始时间，入病区时间，重症监护安排表Id，BP病人身高
/// 			BP病人体重，转入科室，转入病区
/// patAnInfo:日期date_$c(3)_时间time_$c(3)_手术排班ID_$c(3)_用|分割的麻醉方法ID_$c(4)_用+分割的麻醉方法描述串
/// 			_$c(3)_用|分割的手术ID_$c(4)_用+分割的手术描述串_$c(3)_镇痛方式_$c(3)_失血量_$c(3)_尿量_$c(3)_输液量_$c(3)_输血量
/// 			_$c(3)_回室意识_$c(3)_回室体位ID_$c(4)_回室体位描述_$c(3)_回室日期_$c(3)_回室时间_$c(3)_备注
ClassMethod GetBpaInfo(bpaId As %String, date As %String = "", time As %String = "", EpisodeID As %String = "") As %String
{
	q:(+bpaId=0)&(EpisodeID="") ""
	i EpisodeID="" s EpisodeID=$p($g(^DHCBPArrange(+bpaId)),"^",1)
	q:EpisodeID="" ""
	q:'$d(^PAADM(EpisodeID)) ""
 	i bpaId="" s bpaId=..GetBpaId(EpisodeID,"","")
	s date=##class(web.DHCANOPCom).ConvertToDateH(date)
	s time=##class(web.DHCANOPCom).ConvertToTimeH(time)
	s patInfo=##class(web.DHCANOPCom).PatInfo("^"_EpisodeID,"",date,time)
	s transInfo=##class(web.DHCANOPCom).GetTransInfoByTime(EpisodeID,date,time)
	//s retStr=regNo_"^"_ctlocDesc_"^"_$g(room)_"^"_$g(sex)_"^"_$g(patName)_"^"_$g(safetyNetCardNo)_"^"_$g(bedCode)_"^"_$g(age)_"^"_$g(wardDesc)_"^"_homeAddres_"^"_homeTel_"  "_workTel_"  "_handtel_"^"_$G(DocDes)_"^"_MedCareNo_"^"_MRDiagnos_"^"_Nation_"^"_paersonLX_"^"_DrugCell_"^"_$G(birthDate)_"^"_$G(patWordUnit)_"^"_$G(PersonID)_"^"_BloodType_"^"_PAAdmReasonDesc_"^"_AdmDoc_"^"_MainNurse_"^"_admStayDay
	s ctlocDesc=$p($g(^CTLOC(+$p(transInfo,"^",1))),"^",2)
	i $p(ctlocDesc,"-",2)'="" s ctlocDesc=$p(ctlocDesc,"-",2)
	s wardDesc=$p($g(^PAWARD(+$p(transInfo,"^",2))),"^",2)
	i $p(wardDesc,"-",2)'="" s wardDesc=$P(wardDesc,"-",2)
	s roomDesc=$p($g(^PAROOM(+$p(transInfo,"^",3))),"^",2)
	s bedId=$p(transInfo,"^",4)
	i bedId="" s bedId=$p(^PAADM(EpisodeID),"^",73)
	s bedSub=$p(bedId,"||",2)
	s wardId=$p(bedId,"||",1)
	s bedCode=$p($g(^PAWARD(+bedId,"BED",+bedSub)),"^",1)
	s preCtlocDesc=$p($g(^CTLOC(+$p(transInfo,"^",5))),"^",2)
	s preWardDesc=$p($g(^PAWARD(+$p(transInfo,"^",6))),"^",2)
	s $p(patInfo,"^",2)=ctlocDesc
	s $p(patInfo,"^",9)=wardDesc
	s $p(patInfo,"^",3)=roomDesc
	s $p(patInfo,"^",7)=bedCode
	
	s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
	s birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
	s $p(patInfo,"^",8)=##class(web.DHCANOPCom).CalAge(birth,date)
	s resStr=patInfo //$p(patInfo,"^",1,9) //regNo_"^"_ctlocDesc_"^"_$g(room)_"^"_$g(sex)_"^"_$g(patName)_"^"_$g(safetyNetCardNo)_"^"_$g(bedCode)_"^"_$g(age)_"岁^"_$g(wardDesc)
	s resStr=$tr(resStr,"^",$c(3))
	
	s admDate=$p($g(^PAADM(EpisodeID)),"^",6)
	i admDate'="" s admDate=$zd(admDate,3)
	//s dtypIdStr=$g(^DHCCLSet("Disch","DiagTypeId"))
	//q:dtypIdStr="" 0
	s mradmId=$P(^PAADM(EpisodeID),"^",61)
	s bpaRelatedDiagDr=$p(^DHCBPArrange(+bpaId),"^",20)
	s mrdiaSub=0,mrcidDesc=""
	f  s mrdiaSub=$O(^MR(mradmId,"DIA",mrdiaSub)) q:(mrdiaSub="")  d
		.//q:$p(^MR(mradmId,"DIA",mrdiaSub),"^",7)>date
		.s mrcidId=$p(^MR(mradmId,"DIA",mrdiaSub),"^")
		.//q:("|"_bpaRelatedDiagDr_"|")'[("|"_mrcidId_"|")
		.i mrcidId'="" s curMrcidDesc=$p($g(^MRC("ID",+mrcidId)),"^",2)
		.e  s curMrcidDesc=$g(^MR(mradmId,"DIA",mrdiaSub,"DES",1))
		.q:curMrcidDesc=""
		.s mrcidDesc=$tr(mrcidDesc,$c(13))
		.s mrcidDesc=$tr(mrcidDesc,$c(10))
		.i mrcidDesc'="" s mrcidDesc=mrcidDesc_","
		.s mrcidDesc=mrcidDesc_curMrcidDesc
	s bedTpId=$p($g(^PAWARD(+bedId,"BED",+bedSub)),"^",2)
	s BPBed=$p($g(^PAC("BEDTP",+bedTpId)),"^",5)
	s fromDate=""
	i BPBed="Y" d
		.s preBedId="",findFlag="N"
		.s transId="" f  s transId=$o(^PAADM(EpisodeID,"TRANS",transId),-1) q:(transId="")!(findFlag="Y")  d  
			..s transStr=^PAADM(EpisodeID,"TRANS",transId)
			..s preBedId=$p(transStr,"^",8)
			..s endDate=$p(transStr,"^",3)    ;end date
			..q:(preBedId="")
			..i preBedId=bedId s findFlag="Y",fromDate=$p(transStr,"^",1)
	s BPDays=""
	i fromDate'="" s BPDays=date-fromDate //$h-fromDate
	
	s BPANormalStartDate=##class(web.DHCANOPCom).ConvertToDate($p($g(^DHCBPArrange(+bpaId)),"^",22),"")
	s BPANormalStartTime=##class(web.DHCANOPCom).ConvertToTime($p($g(^DHCBPArrange(+bpaId)),"^",23),"")
	i BPANormalStartDate="" s BPANormalStartTime=""
	s inWardDT=##class(web.DHCANOPCom).GetWardInDateTime(EpisodeID,"","")
	s inWardDT=$p(inWardDT,"^",1)_" "_$p(inWardDT,"^",2)
	s bpaPatHeight=$p($g(^DHCBPArrange(+bpaId)),"^",24)
	s bpaPatWeight=$p($g(^DHCBPArrange(+bpaId)),"^",25)
 	
 	//CCQ20101108 添加手术名称、手术日期和病人体重信息//移到下一部分
 	s opaId=##class(web.DHCANOPCom).GetPreviousOpaId(EpisodeID,date) //取最近一次手术
 	//s tempOpaId=0
 	//f  s opaId=$o(^DHCANOPArrange(0,"Adm",EpisodeID,opaId),-1) q:opaId=""  d
 	//.i tempOpaId<opaId s tempOpaId=opaId
 	//s opaId=tempOpaId
 	s anOpString=##class(web.DHCANCom).GetAnaInfo(opaId)
 	s operationName=""
 	s operationDate=""
 	s patientWeight=""
 	i anOpString'=""  d
 	.s patientInfo=$p($g(anOpString),"^",2)
 	.s patientWeight=$p($g(patientInfo),$c(3),2)
 	.s operationInfo=$p($g(anOpString),"^",3)
 	.s operationDate=$p($g(operationInfo),$c(3),16)
 	.i operationDate=""  d
 	..s operationInfo=$p($g(anOpString),"^",2)
 	..s operationDate=$p($g(operationInfo),$c(3),10)
 	.s operationNameInfo=$p($g(anOpString),"^",6)
 	.s operationName=$p($g(operationNameInfo),$c(4),4)
 	
 	s resStr=resStr_"^"_admDate_$c(3)_mrcidDesc_$c(3)_BPDays_$c(3)_EpisodeID_$c(3)_wardId_$c(3)_BPANormalStartDate_$c(3)_BPANormalStartTime_$c(3)_inWardDT_$c(3)_bpaId_$c(3)_bpaPatHeight
 	s resStr=resStr_$c(3)_bpaPatWeight_$c(3)_preCtlocDesc_$c(3)_preWardDesc_$c(3)_operationName_$c(3)_operationDate_$c(3)_patientWeight
 	
 	//start CCQ20101008 添加湘雅医院HIS信息，病人ID和住院次数
    s oaRowId=$o(^DHCENSOA("0","Paadm",+EpisodeID,""))
    s otherHisPatientId=$p($g(^DHCENSOA(+oaRowId)),"^",4)
    s otherHisVisitId=$p($g(^DHCENSOA(+oaRowId)),"^",5)
    s resStr=resStr_"^"_otherHisPatientId_$c(3)_otherHisVisitId //end CCQ
    
	s bpaType=$p($g(^DHCBPArrange(+bpaId)),"^",5)
	s resStr=resStr_"^"_bpaType //
	q resStr
}

// ancoStr以$c(3)分割

ClassMethod GetBppId(bpaId, ctlocId = "")
{
	q 0 
	
	
	
	q:(+bpaId=0) 0
	s BPpId=$o(^DHCBPPara(0,bpaId,""))
	i BPpId'="" q BPpId
	i ctlocId="" s ctlocId="Default"
	
	i $d(^DHCBPC("Para","Default"))<10 q ""
	s ^DHCBPPara(0)=$g(^DHCBPPara(0))+1
	s ^DHCBPPara(0,bpaId,^DHCBPPara(0))=""
	i $d(^DHCBPC("Para",ctlocId))<1 m ^DHCBPC("Para",ctlocId)=^DHCBPC("Para","Default")
	m ^DHCBPPara(^DHCBPPara(0))=^DHCBPC("Para",ctlocId)
	s $p(^DHCBPPara(^DHCBPPara(0)),"^",1)=bpaId  //ypz end
	s BPpId=^DHCBPPara(0)
	q BPpId
}

ClassMethod GetAncViewCat(type = "", needAncvcId = "") As %String
{
	q 0
}

ClassMethod GetArcimDesc(arcimId = "") As %String
{
	q:arcimId="" ""
	s arcimDesc=""
	s arcimDesc=$p(^ARCIM(+arcimId,+$p(arcimId,"||",2),1),"^",2)
	q arcimDesc
}

ClassMethod GetBpcByNode(node) As %String
{
	s resStr="",id=0
	f  s id=$o(^DHCBPC(node,id)) q:id=""  d
	    .s desc=$p(^DHCBPC(node,id),"^",2)
	    .i "^VSCat^"[("^"_node_"^") s desc=$p(desc,"[")
	    .i resStr'="" s resStr=resStr_"^"
	    .s resStr=resStr_id_$c(3)_desc
	q resStr
}

ClassMethod GetBpcCodeDescByNode(node) As %String
{
	s resStr="",id=0
	f  s id=$o(^DHCBPC(node,id)) q:id=""  d
	    .s desc=$p(^DHCBPC(node,id),"^",2)
	    .i "^VSCat^"[("^"_node_"^") s desc=$p(desc,"[")
	    .i resStr'="" s resStr=resStr_"^"
	    .s resStr=resStr_id_$c(3)_$p(^DHCBPC(node,id),"^",1)_$c(3)_desc
	q resStr
}

ClassMethod GetLocCtcp(bpaId, anNode) As %String
{
	q:+bpaId=0 -1
	s bpcBedId=$lg(^DHCBPArrange(bpaId),7)
	q:+bpcBedId=0 -2 ;"未定义床位!"
	s bpcbgId=$lg(^DHCBPC("Bed",bpcBedId),3)
	q:bpcbgId="" -3 
	s wardId=$p($g(^DHCBPC("BedGroup",bpcbgId)),3)
	q:wardId="" -4
	s wardLocId=$p(^PAWARD(+wardId),"^",5)
	i wardLocId'="" s locIdStr=locIdStr_"^"_wardLocId
	s num=$l(locIdStr,"^")
	
	s resStr=""
	f i=1:1:num d
	   .s str=$P(locIdStr,"^",i)
	   .s locId=$P(str,"|")
	   .s resId="" f  s resId=$O(^RB("RES",0,"CTLOC",locId,resId)) q:resId=""  d
	       ..s ctcpId=$P(^RB("RES",resId),"^",2)
	       ..q:ctcpId=""
	       ..s ctcpDesc=$p(^CTPCP(ctcpId,1),"^",2)
	       ..i resStr'="" s resStr=resStr_"^"
	       ..s resStr=resStr_ctcpId_$c(3)_ctcpDesc
	 q resStr
}

ClassMethod GetDiag(mrcidStr)
{
	k ^TMPBP("Com",$i)
    s i=0
	s mrcidStr=$$ALPHAUP^SSUTIL4(mrcidStr)  //ypz 070313 $ZCONVERT(mrcidStr,"U")
    q:mrcidStr="" 0
	if mrcidStr'=""
	{
		s flag="N"
		s aliasTextAlphaUp=$O(^MRC("ID",0,"ALIAS",mrcidStr),-1) //ypz 070313 保证找到当前串
    	f  s aliasTextAlphaUp=$O(^MRC("ID",0,"ALIAS",aliasTextAlphaUp)) q:(aliasTextAlphaUp="")!(flag="Y")  d
    		.i $p(aliasTextAlphaUp,mrcidStr)'="" s flag="Y" q
    		.//i $e(aliasTextAlphaUp,1,$L(mrcidStr))'=mrcidStr s flag="Y" q
    		.s mrcidId=""
    		.f  s mrcidId=$O(^MRC("ID",0,"ALIAS",aliasTextAlphaUp,mrcidId)) q:(mrcidId="")  d
    			..s mrcidDesc=$p(^MRC("ID",mrcidId),"^",2)
    			..s ^TMPBP("Com",$i,i)=mrcidId_"^"_mrcidDesc
    			..//w ^TMPBP("Com",$i,i)_".",!
    			..s i=i+1
	}
	i i>0 q i
	s mrcidId=0
	f  s mrcidId=$o(^MRC("ID",mrcidId)) q:mrcidId=""  d
	    .s mrcidDesc=$p(^MRC("ID",mrcidId),"^",2)
	    .//s LinkStr=$ZCONVERT(mrcidStr,"U")
	    .i $$ALPHAUP^SSUTIL4(mrcidDesc)[mrcidStr  do
    		..s ^TMPBP("Com",$i,i)=mrcidId_"^"_mrcidDesc
    		..//w ^TMPBP("Com",$i,i)
    		..s i=i+1
    q i
}

ClassMethod GetEditStat(bpaId, userLocId) As %String
{
	q:(+bpaId=0) "noBpaId^无病人监护号!"
	s bpaStatus=$lg($g(^DHCBPArrange(bpaId)),9)
	q:bpaStatus="" "noBpaStat^无监护状态!"
	q:bpaStatus="A" "appBpa^不能对监护状态为申请的病人操作!"
	q:bpaStatus="D" "declineBpa^不能对监护状态为拒绝的病人操作!"
	q:bpaStatus="N" "unAppointBpa^不能对监护状态为非预约的病人操作!"
	s bpprId=$lg(^DHCBPArrange(bpaId),1)
	w bpprId,!
	q:bpprId="" "noRegisterId^无病人登记记录!"
	s papmiId=$lg(^DHCBPArrange(bpaId),2)
	q:papmiId="" "noPapmiId^无病人基本信息记录!"
		
	//s retStr=..ReviseArrangeBedEquip(bpaId)
	//q:retStr'=0 "errorRevise"_retStr
	
	s bpaStatus=$lg($g(^DHCBPArrange(bpaId)),9) //调整后会变
	s bpcBedId=$lg(^DHCBPArrange(bpaId),7)
	s bpcBedGroupId=$lg($g(^DHCBPC("Bed",+bpcBedId)),3)
	s wardId=$lg($g(^DHCBPC("BedGroup",+bpcBedGroupId)),3)
	q:wardId="" "CanRead^"
	s ctlocId=$p($g(^PAWARD(+wardId)),"^",5)
	s locIdStr=ctlocId
	i locIdStr'="" d
	    .s linkLocIdStr=##class(web.DHCCLCom).GetLinkLocId(ctlocId)
	    .i linkLocIdStr'="" s locIdStr=locIdStr_"^"_linkLocIdStr
	
	q:bpaStatus="F" "CanRead^"
	q:("RMT"'[bpaStatus) "errBpaStat^监护状态不对!"
	s bpbeId="",retStr="CanRead^"
	f  s bpbeId=$o(^DHCBPBedEquip(0,"Bed",bpcBedId,bpbeId)) q:bpbeId=""  d
		.s BPbeEditTcpipAddress=$lg($g(^DHCBPBedEquip(bpbeId)),7)
		.q:BPbeEditTcpipAddress=""
		.//s ^tmpYpz("ip")=$zu(67,15,$j)
		.//i (remoteAddr="")&(BPbeEditTcpipAddress[$zu(67,15,$j)) s retStr="CanStart^"
		.//i (remoteAddr'="")&(BPbeEditTcpipAddress[remoteAddr) s retStr="CanStart^"
		.q:ctlocId'=userLocId
		.s retStr="CanStart^"
	q:retStr'["CanStart^" retStr
	//130306//q:wardId'=+bedId "CanEdit^"
	s bpprStatus=$lg(^DHCBPPatRegister(bpprId),14)
	q:(bpprStatus="D")&(bpaStatus="R") "CanRead^"
	q:(bpprStatus="D")&(bpaStatus="M") "CanRead^"
	q:(bpprStatus="D")&(bpaStatus="T") "CanEdit^"
	i $d(^DHCBPArrange(0,"BedStatus",bpcBedId,"M"))>0 d
		.i bpaStatus="T" s retStr="CanEdit^" q //术后进入时，已有新监护，只能手工修改
		.s monBpaId=$o(^DHCBPArrange(0,"BedStatus",bpcBedId,"M",""))
		.i monBpaId=bpaId,retStr="CanStart^" s retStr="CanStop^"
		.i monBpaId'=bpaId,retStr="CanStart^" d
			..s tmpRetStr=..AutoTerminal(monBpaId, bedId)
			..i tmpRetStr'=0 s retStr=tmpRetStr
	q:retStr'["CanStart^" retStr
	i (bpaStatus="T")&(retStr["CanStart^") s retStr="CanRestart^"
	i $d(^DHCBPArrange(0,"BedStatus",bpcBedId,"M"))>0 q retStr
	i $d(^DHCBPArrange(0,"BedStatus",bpcBedId,"T"))>0 q retStr
	i $d(^DHCBPArrange(0,"BedStatus",bpcBedId,"R",bpaId))>0 q retStr
	q retStr
	q "CanRead^"
}

/// 调整当前病区的全部监护：
/// 转病区(一次转病区只有一次BP安排)，同病区到等待区、到非监护床，停止病人采集数据，调整前一次监护为结束。
/// 启动本病区设备。
ClassMethod ReviseArrangeBedEquip(bpaId, EpisodeID = "", wardId = "") As %String
{
	q 0 //不用
	
	
	q:(bpaId="")&(EpisodeID="")&(wardId="") 0
	s retStr=0
	i wardId="" d
		.i EpisodeID="" s EpisodeID=$p(^DHCBPArrange(+bpaId),"^",1)
		.s wardId=$p($g(^PAADM(+EpisodeID)),"^",70)	
	q:wardId="" retStr //无病人病区
	
	s bedSub=0,startbpaIdStr=""
	f  s bedSub=$o(^PAWARD(wardId,"BED",bedSub)) q:(bedSub="")!(retStr'=0)  d
		.s wardDesc=$p(^PAWARD(wardId),"^",2)
		.s bedId=wardId_"||"_bedSub
		.s bedCode=$p(^PAWARD(+bedId,"BED",bedSub),"^",1)
		.//w "all:"_bedId_"/"_bedCode,!
		.s bedAdmSub=0,bedEpisodeID=""
		.f  s bedAdmSub=$o(^PAWARDA(+bedId,"BED",bedSub,"ADM",bedAdmSub)) q:bedAdmSub=""  d
			..s bedEpisodeID=$p(^PAWARDA(+bedId,"BED",bedSub,"ADM",bedAdmSub),"^")
			..i $o(^PAWARDA(+bedId,"BED",bedSub,"ADM",bedAdmSub))'="" s retStr=wardDesc_bedCode_"("_bedId_")床位与病人关联错!" q
		.q:retStr'=0
		.//清理床位上监护
		.s monbpaId=""
		.f  s monbpaId=$o(^DHCBPArrange(0,"BedStatus",bedId,"M",monbpaId)) q:monbpaId=""  d
			..q:'$d(^DHCBPArrange(monBpaId))
			..s monEpisodeID=$p(^DHCBPArrange(+monBpaId),"^",1)
			..q:'$d(^PAADM(monEpisodeID))
			..q:(bedEpisodeID=monEpisodeID)
			..s retStr=..StopEquipCollect(monBpaId,bedId)
			..s monAdmVisitStatus=$p($g(^PAADM(monEpisodeID)),"^",20)
			..s monWardId=$p($g(^PAADM(monEpisodeID)),"^",70)
			..s monBedId=$p($g(^PAADM(monEpisodeID)),"^",73)
			..s monBpaStatus=$p($g(^DHCBPArrange(monBpaId)),"^",18)
			..s monBPBedId=$p($g(^DHCBPArrange(monBpaId)),"^",4)
			..//w "status:"_monAdmVisitStatus_"/"_monWardId_"/"_monBedId,!
			..i (monAdmVisitStatus="D")!(monWardId'=wardId) d 	//出院或转病区
				...s monBedBpaId=..GetBpaId(monEpisodeID,"","") //判断跨病区提前转
				...q:(monAdmVisitStatus'="D")&(monBpaId=monBedBpaId)
				...//w monBpaId_"出院或转病区",! //
				...&sql(update DHC_BP_Arrange set BPA_Status='T' where BPA_RowId=:monBpaId)
				...i retStr=0,SQLCODE'=0 s retStr="修改监护安排表状态错误!"
			..e  d 		//同病区，床位错，前一监护没停，可能转回的
				...i monBedId="" s monBedId=bedId //保证转到等待区时，有值
				...e  d
					....s monBedBpaId=..GetBpaId(monEpisodeID,"","") //返回单条，不创建新监护,有可能跨过病区
					....//w monBpaId_"/"_monBedBpaId_"同病区，床位错，前一监护没停",!
					....i monBpaId'=monBedBpaId s monBedId=bedId q //同人，跨病区又回的不重启
					....q:("^"_startBpaIdStr_"^")[("^"_monBpaId_"^")
					....i startBpaIdStr'="" s startBpaIdStr=startBpaIdStr_"^"
					....s startBpaIdStr=startBpaIdStr_monBpaId
				...//w monBedId_"修改床位",! //
				...s updateBedId=monBedId
				...s updateBedId=monBpBedId
				...&sql(update DHC_BP_Arrange set BPA_Status='T' where BPA_RowId=:monBpaId)
				...i retStr=0,SQLCODE'=0 s retStr="修改监护安排状态、床位错误!"
				...
		.q:retStr'=0
		.//处理当前床上病人的不一致信息
		.q:bedEpisodeID=""
		.s bedBpaId=..GetBpaId(bedEpisodeID,"","") //返回单条，不创建新监护
		.//w bedEpisodeID,"/"_bedBpaId,!
		.i bedBpaId'="" d
			..s bpaBedId=$p($g(^DHCBPArrange(bedBpaId)),"^",4)
			..s bpaStatus=$p($g(^DHCBPArrange(bedBpaId)),"^",18)
			..i (bpaStatus="M")&(bedId'=bpaBedId)&(+bedId=+bpaBedId) d //本区新转床，旧床没停
				...//w bedBpaId_"停，修改上一监护安排床位!",! //
				...s retStr=..StopEquipCollect(bedBpaId,bpaBedId)
				...s updateBedId=bedId
				...s updateBedId=bpaBedId
				...&sql(update DHC_BP_Arrange set BPA_Status='T' where BPA_RowId=:bedBpaId)
				...i retStr=0,SQLCODE'=0 s retStr="修改上一监护安排床位、状态错误!"
				...q:("^"_startBpaIdStr_"^")[("^"_bedBpaId_"^")
				...i startBpaIdStr'="" s startBpaIdStr=startBpaIdStr_"^"
				...s startBpaIdStr=startBpaIdStr_bedBpaId
			..i (bedId'=bpaBedId)&(+bedId=+bpaBedId) d //未监护或已停止监护，床位不对
				...//w bedBpaId_"未监护或已停止监护，床位不对",! //
				...//temp//&sql(update DHC_BP_Arrange set BPA_Bed_Dr=:bedId where BPA_RowId=:bedBpaId)
				...i retStr=0,SQLCODE'=0 s retStr="修改监护安排床位错误! Code="_SQLCODE
		.e  d
			..s bedBpaId=+..GetBpaId(bedEpisodeID,"","","N") //返回多条，不创建新监护
			..//w bedBpaId,!
			..q:bedBpaId=0
			..s bpaBedId=$p($g(^DHCBPArrange(bedBpaId)),"^",4)
			..s bpaStatus=$p($g(^DHCBPArrange(bedBpaId)),"^",18)
			..i (bpaStatus="M") d //跨病区后的转来的，旧床没停
				...//w bedBpaId_"跨病区后的转来的，旧床没停",! //
				...s retStr=..StopEquipCollect(bedBpaId,bpaBedId)
				...&sql(update DHC_BP_Arrange set BPA_Status='T' where BPA_RowId=:bedBpaId)
				...i retStr=0,SQLCODE'=0 s retStr="修改监护安排表状态错误!"
	q:retStr'=0 retStr
	
	//w "start:"_startBpaIdStr,! 
	
	q:startBpaIdStr="" retStr
	//h 10 //等待10秒,采集服务提供相应程序后注释
	//启动设备
	f i=1:1:$l(startBpaIdStr,"^") d
		.q:retStr'=0
		.s startBpaId=$p(startBpaIdStr,"^",i)
		.q:startBpaId=""
		.s endDate=$p($g(^DHCBPArrange(bpaId)),"^",7)
		.;防止转床改为T状态
		.s stat=$p($g(^DHCBPArrange(bpaId)),"^",18)
		.i endDate'=""&&stat'="M" &sql(update DHC_BP_Arrange set BPA_Status='M' where BPA_RowId=:bpaId)
		.;停止设备		
		.s retStr=..StartEquipCollect(bpaId, "", "")
	q retStr
}

ClassMethod GetBedStat(bpaId, userlocId = "") As %String
{
	q 0 //未用
	
	//q:(+bpaId=0)&(userId="") "noBpaIdAndUserId^无病人监护号和用户!"
	q:(+bpaId=0)&(userLocId="") "noBpaIdAndUserLocId^无病人监护号和用户科室!"
	s locIdStr="",patLocId=""
	i bpaId'="" d
	    .s bpaStatus=$p($g(^DHCBPArrange(bpaId)),"^",18)
	    .q:bpaStatus="" //"noBpaStat^无监护状态!"
	    .q:bpaStatus="A" //"appBpa^不能对监护状态为申请的病人操作!"
	    .q:bpaStatus="D" //"declineBpa^不能对监护状态为拒绝的病人操作!"
	    .q:bpaStatus="N" //"unAppointBpa^不能对监护状态为非预约的病人操作!"
	    .//s bedId=$p($g(^DHCBPArrange(bpaId)),"^",4)
	    .s EpisodeID=$p(^DHCBPArrange(+bpaId),"^",1)
	    .q:EpisodeID=""
	    .s bedId=$p($g(^PAADM(EpisodeID)),"^",73)
	    .q:bedId="" //"noBpaBed^无病人监护床位!"
	    .s bedSub=$p(bedId,"||",2)
	    .q:+bedSub=0 ;"未定义床位!"
	    .s bedTpId=$p($g(^PAWARD(+bedId,"BED",+bedSub)),"^",2)
	    .s bpBed=$p($g(^PAC("BEDTP",+bedTpId)),"^",5)
	    .q:bpBed'="Y" //"非重症床!"
	    .s locIdStr=$p($g(^PAWARD(+bedId)),"^",5) //病人病区科室
	    .//s patLocId=$p($g(^DHCBPArrange(bpaId)),"^",2) ////病人科室
	i locIdStr'="" d
	    .s linkLocIdStr=##class(web.DHCCLCom).GetLinkLocId(locIdStr)
	    .i linkLocIdStr'="" s locIdStr=locIdStr_"^"_linkLocIdStr

	i locIdStr="" d //"无监护科室!"
	    .s ctcpId=$p($g(^SSU("SSUSR",userId)),"^",14)
	    .q:ctcpId=""
	    .s locId=""
	    .f  s locId=$O(^RB("RES",0,"CTPCP",ctcpId,locId)) q:(locId="")  d
	 	    ..i locIdStr'="" s locIdStr=locIdStr_"^"
	 	    ..s locIdStr=locIdStr_locId
	 	    ..s linkLocIdStr=##class(web.DHCCLCom).GetLinkLocId(locId)
	 	    ..i linkLocIdStr'="" s locIdStr=locIdStr_"^"_linkLocIdStr
	
	s operLocId="",retStr="",i=0 //以下要改为按病区床位找
	f  s operLocId=$o(^DHCANC("OPRoom",0,operLocId)) q:operLocId=""  d
	    .q:(locIdStr'="")&(locIdStr'[operLocId)
	    .s bedId=""
	    .f  s bedId=$o(^DHCANC("OPRoom",0,operLocId,bedId)) q:bedId=""  d
	        ..s i=i+1
	        ..//q:(locIdStr="")&(i>10)
	        ..q:'$d(^DHCANC("OPRoom",bedId))
	        ..s bpaId=$o(^DHCBPArrange(0,"BedStatus",bedId,"M",""))
	        ..i retStr'="" s retStr=retStr_"^"
	        ..s retStr=retStr_bedId
	        ..s retStr=retStr_$c(3)_$p(^DHCANC("OPRoom",bedId),"^")_$c(3)_$p(^DHCANC("OPRoom",bedId),"^",2)
	        ..s retStr=retStr_$c(3)_bpaId
	q retStr
}

ClassMethod GetUserTypeName(userId As %String) As %String
{

	//取用户的类别:医生还是护士
	q:userId="" "用户有误!"
	s ctpcpId=$p($g(^SSU("SSUSR",userId)),"^",14)
	q:ctpcpId="" "该用户未关联医护人员!"
	s ctpcpDesc=$P($g(^CTPCP(ctpcpId,1)),"^",2)
	s ctcptId=$P($g(^CTPCP(ctpcpId,1)),"^",4)  ;CTPCP_CarPrvTp_DR
	q:ctcptId="" "该医护人员未定义医护类型!"
    s ctcptInternalType=$P($g(^CT("CPT",ctcptId)),"^",4)  ;CT_CarPrvTp:CTCPT_InternalType
	q:ctcptInternalType="" "医护人员类型定义有误!"
	s userName=$p($g(^SSU("SSUSR",userId)),"^",2)
	s loadName=$p($g(^SSU("SSUSR",userId)),"^",1)
	q ctcptInternalType_"^"_userName_"^"_loadName_"^"_ctpcpId_"^"_ctpcpDesc
}

ClassMethod GetPatientWardId(EpisodeID As %String) As %String
{
	q:(EpisodeID="") ""
	s wardId=$p($g(^PAADM(EpisodeID)),"^",70)
	q $g(wardId)
}

/// 根据就诊号取监护申请号RowId：转入当前病区后的bpaId。每次转入病区到转出病区间最多只有一个bpaId
ClassMethod GetBpaId(EpisodeID, regNo, userId, ifSingle = "Y", ifCreate = "N", userCtlocId = "", bedId = "") As %String
{
	q 0 //应该不用了
	
	
	s userWardIdStr=""
	i userCtlocId'="" d
		.s userWardIdStr=$o(^PAWARD(0,"WARD_LocationDR",userCtlocId,0))
		.i (userWardIdStr="")!(userWardIdStr=$p(^PAADM(EpisodeID),"^",70)) s bedId=""
		.i userWardIdStr="" d
			..s linkLocIdStr=##class(web.DHCCLCom).GetLinkLocId(userCtlocId)
			..f i=1:1:$l(linkLocIdStr,"^") d
				...s curCtlocId=$p(linkLocIdStr,"^",i)
				...q:curCtlocId=""
				...s curWardId=$o(^PAWARD(0,"WARD_LocationDR",curCtlocId,0))
				...q:curWardId=""
				...i userWardIdStr'="" s userWardIdStr=userWardIdStr_"^"
				...s userWardIdStr=userWardIdStr_curWardId
	e  s bedId=""
		
	s EpisodeIDList=EpisodeID
	i EpisodeID="",regNo'="" d
		.s papmiId=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(regNo),""))
		.//w papmiId
		.q:papmiId=""
		.f  s EpisodeID=$o(^PAPERdr(papmiId,"ADM","I",EpisodeID),-1) q:EpisodeID=""  d
			..q:'$d(^PAADM(EpisodeID))
			..s pavisit=$p($g(^PAADM(EpisodeID)),"^",20)
			..//w EpisodeID_"/"_pavisit
			..q:"AD"'[pavisit
			..i EpisodeIDList'="" s EpisodeIDList=EpisodeIDList_"^"
			..s EpisodeIDList=EpisodeIDList_EpisodeID
	q:(EpisodeIDList="") ""
	
	s bpaIdList="",latestBpaId="",isFirst="Y"
	f i=1:1:$l(EpisodeIDList,"^") d
		.s EpisodeID=$p(EpisodeIDList,"^",i)
		.q:'$d(^PAADM(EpisodeID))
		.s retStr=##class(web.DHCANOPCom).GetAdmTransWardList(EpisodeID, .transWardList)
		.q:'$d(transWardList) 	//没有转病区记录
		.s bpaId="",isQuit=0
		.f  s bpaId=$o(^DHCBPArrange(0,"Adm",EpisodeID,bpaId),-1) q:(bpaId="")!(isQuit)  d
			..q:'$d(^DHCBPArrange(bpaId))
			..s bpaStatus=$p($g(^DHCBPArrange(bpaId)),"^",18)
			..q:bpaStatus=""
			..q:"D"[bpaStatus //停止的
			..s wardId=$p(^PAADM(EpisodeID),"^",70)
			..s bpaBedId=$p($g(^DHCBPArrange(bpaId)),"^",4)
			..s bpaWardId=+bpaBedId
			..i (isFirst="Y")&(("^"_userWardIdStr_"^")[("^"_bpaWardId_"^")) s latestBpaId=bpaId
			..s isFirst="N"
			..q:(userCtlocId'="")&(("^"_userWardIdStr_"^")'[("^"_bpaWardId_"^")) //非用户病区
			..i $p($g(^DHCBPArrange(+bpaId)),"^",7)'="" s latestBpaId="" //有结束日期
			..s bpaDateTime=$p(^DHCBPArrange(bpaId),"^",6)+(($p(^DHCBPArrange(bpaId),"^",8)+1)/100000)
			..s dateTime=$o(transWardList(bpaDateTime),-1)
			..i dateTime="" s dateTime=$o(transWardList(bpaDateTime)) //早于第一次
			..q:dateTime="" //无转病区记录，应不会出现
			..i +bpaBedId'=transWardList(dateTime) d //取后一转病区，看是否符合条件
				...s postDateTime=$o(transWardList(dateTime))
				...i postDateTime="" d
					....i bpaIdList'="" s bpaIdList=bpaIdList_"^"
					....s bpaIdList=bpaIdList_bpaId
				...q:postDateTime=""
				...q:+bpaBedId'=transWardList(postDateTime) //病区不对
				...s tmpPostDateTime=postDateTime-0.18 //转科提前5小时
				...i $p(tmpPostDateTime,".")<$p(postDateTime,".") d 
					....s tmpPostDateTime=tmpPostDateTime-0.136
				...i tmpPostDateTime<dateTime s tmpPostDateTime=dateTime
				...q:tmpPostDateTime>bpaDateTime
				...s dateTime=postDateTime
			..q:+bpaBedId'=transWardList(dateTime) //未生成!! HX不一样
			..i (ifSingle="Y")&(userCtlocId'="")&(("^"_userWardIdStr_"^")'[("^"_bpaWardId_"^")) s isQuit=1 q //只找一次时，监护的不是当前科室退出
			..i $o(transWardList(bpaDateTime),-1)="" s bpaDateTime=$o(transWardList(bpaDateTime))+0.00001
			..//w ifSingle_"/"_dateTime,!
			..i (ifSingle="Y")&($o(transWardList(dateTime))'="") q //只找一次时，不是最后一次转病区，退出
			..i ifSingle="Y" s isQuit=1
			..i bpaIdList'="" s bpaIdList=bpaIdList_"^"
			..s bpaIdList=bpaIdList_bpaId
			..//s transSub="",preWardId="",dateTime=0 //$h+($p($h,",",2)/100000)
			..//f  s transSub=$o(^PAADM(EpisodeID,"TRANS",transSub),-1) q:(transSub="")!(preWardId>0)  d
			..//.q:$p(^PAADM(EpisodeID,"TRANS",transSub),"^",9)=wardId
			..//.s preWardId=$p(^PAADM(EpisodeID,"TRANS",transSub),"^",9)
			..//.q:preWardId=""
			..//.s dateTime=^PAADM(EpisodeID,"TRANS",transSub)+($p(^PAADM(EpisodeID,"TRANS",transSub),"^",2)/100000)
			..//w " preWardId="_preWardId," dt="_dateTime,!
			..//i (preWardId="")!((preWardId'="")&(bpaDateTime>dateTime)) d
			..//.i bpaIdList'="" s bpaIdList=bpaIdList_"^"
			..//.s bpaIdList=bpaIdList_bpaId
			..//.//w "list:"_bpaIdList
			..//.i ifSingle="Y" s isQuit=1 //只找第一个
		.s isFirst="N"
	q:(ifSingle'="Y") bpaIdList //找全部
	s bpaId=bpaIdList
	//q:bpaId'="" bpaId //HX用!!单个找已有
	
	//q:(bpaId="")&(latestBpaId'="") latestBpaId //HX用!! 转过科未停
	q:userId="" bpaIdList
	q:(ifCreate'="Y") bpaIdList
	q:(userCtlocId="") bpaIdList
	
	i bpaId="",ifSingle="Y" d //只找一个时，病区用户能生成同病区床位上病人记录
		.s curBedId=$p($g(^PAADM(EpisodeID)),"^",73)
		.i bedId'="" s curBedId=bedId
		.q:(curBedId="") //在等待区不生成
		.q:(userCtlocId'="")&(("^"_userWardIdStr_"^")'[("^"_+curBedId_"^")) //不是同一病区不生成
		.k PLIST
		.s curDate=+$h,curTime=$p($h,",",2)
		.s PLIST(2)=EpisodeID
		.s PLIST(3)=$p($g(^PAADM(EpisodeID)),"^",4)
		.s PLIST(5)=curBedId
		.s PLIST(7)=curDate
		.s PLIST(9)=curTime
		.s PLIST(12)=userId
		.s PLIST(13)=curDate
		.s PLIST(14)=curTime
		.s PLIST(15)=userId
		.s PLIST(16)=curDate
		.s PLIST(17)=curTime
		.s PLIST(19)="R"
		.&SQL(Insert into DHC_BP_Arrange Values :PLIST())
		.i 'SQLCODE s bpaId=$g(%ROWID)
		.i bpaId'="" s ^tmpBP("GetBpaId",bpaId,$h)=EpisodeID_"/"_regNo_"/"_userId_"/"_ifSingle_"/"_ifCreate_"/"_userCtlocId_"/"_bedId_"/"_$p($g(^PAADM(EpisodeID)),"^",73)_"/"_userWardIdStr
		.i bpaId'="" m ^tmpBP("GetBpaId",bpaId,$h,"trans")=transWardList
	q bpaId
}

/// Creator：      	ypz
/// CreatDate：    	2010-03-12
/// Description： 	查找病区病人:有wardId直接找病人,无则根据ctlocId则找病人:是病区直接找病人,是科室找关联病区的病人
/// Table：        	PA_Adm,PA_Patmas,PAC_Ward,PAC_Bed
/// Input：        	wardId病区ID,ctlocId医生/护士科室ID
/// Output：       
/// Return：       	返回以"^"分割的病人信息串，病人信息:就诊号EpisodeID_"|"_床位bedCode_"|"_病人姓名patName
ClassMethod FindWardPatient(wardId As %String = "", ctlocId As %String = "") As %String
{
	
	q 0 //应该不用了
	
	s retStr=""
	q:(wardId="")&(ctlocId="") retStr
	
	s wardIdList=wardId
	i wardId="" d
	    .s ctlocType=$p($g(^CTLOC(ctlocId)),"^",13)
		.i ctlocType="W" d
			..s wardIdList=$o(^PAWARD(0,"WARD_LocationDR",ctlocId,0))
		.e  d
			..i ctlocType="E" d  
			..s linksub=0
			..f  s linksub=$o(^CTLOC(ctlocId,"LINK",linksub)) q:linksub=""  d
				...s linkCtlocId=$p($g(^CTLOC(ctlocId,"LINK",linksub)),"^",1)
				...i linkCtlocId'="" d
					....s linkCtlocType=$p($g(^CTLOC(linkCtlocId)),"^",13)
					....i linkCtlocType="W" d 
						.....i wardIdList'="" s wardIdList=wardIdList_"^"
						.....s wardIdList=wardIdList_$o(^PAWARD(0,"WARD_LocationDR",linkCtlocId,0))
	q:wardIdList="" retStr
	
	f i=1:1:$l(wardIdList,"^") d
	    .s wardId=$p(wardIdList,"^",i)
	    .i ctlocId="" s ctlocId=$p(^PAWARD(+wardId),"^",5)
	    .s roomId=0
	    .f  s roomId=$o(^PAADMi("CurrWard",wardId,roomId)) q:roomId=""  d
    		..s EpisodeID=0
    		..f  s EpisodeID=$o(^PAADMi("CurrWard",wardId,roomId,EpisodeID)) q:EpisodeID=""  d
        		...q:'$d(^PAADM(EpisodeID))
        		...s paadmVisitStatus=$p($g(^PAADM(EpisodeID)),"^",20)
        		...i paadmVisitStatus'="A" q
        		...s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
        		...s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
       			...s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
        		...//s sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
        		...s bedId=$p($g(^PAADM(EpisodeID)),"^",73)
        		...s bedSub=$p(bedId,"||",2)
        		...q:bedSub=""
        		...s bedTypeId=$p($g(^PAWARD(+bedId,"BED",+bedSub)),"^",2)
        		...s ifBp=$p($g(^PAC("BEDTP",+bedTypeId)),"^",5)
        		...q:ifBp'="Y"
        		...s bedCode=$p($g(^PAWARD(wardId,"BED",bedSub)),"^",1)
        		...q:bedCode="" ;防止床位码表被删
        		...s bpaId=..GetBpaId(EpisodeID, "", "", "Y", "N",ctlocId) //返回单条，不创建新监护
        		...i retStr'="" s retStr=retStr_"^"
        		...s retStr=retStr_EpisodeID_"|"_bedCode_"|"_patName_"|"_bpaId //用床位号好找
    q retStr
}

/// 按病区时，只找当前最新的
ClassMethod FindBpaIdList(bpaId As %String, EpisodeID As %String, ctlocId As %String) As %Library.String
{
	
	s bpaIdList=bpaId
	i bpaId="" d
	    .s EpisodeIDList=EpisodeID
	    .i EpisodeID="" s EpisodeIDList=..FindWardPatient("", ctlocId)
	    .q:EpisodeIDList=""
	    .f i=1:1:$l(EpisodeIDList,"^") d
	        ..s EpisodeID=+$p(EpisodeIDList,"^",i)
	        ..s bpaId=..GetBpaId(EpisodeID,"","") //返回单条，不创建新监护
	        ..q:bpaId=""
	        ..i bpaIdList'="" s bpaIdList=bpaIdList_"^"
	        ..s bpaIdList=bpaIdList_bpaId
	q bpaIdList
}

/// Creator：      	ypz
/// CreatDate：    	2010-08-02
/// Description： 	把当前病人参数作为科室参数，替换全部已监护病人参数
/// Table：        	DHC_IUC_Arrange,PA_Adm,CT_Loc
/// Input：        	bpaId监护安排表ID,ctlocId病人所在病区对应的科室ID
/// Output：       
/// Return：       	返回0正常，其他返回提示信息。
ClassMethod SaveAsWardPara(bpaId As %String, ctlocId As %String) As %Library.String
{
	q:ctlocId="" "科室Id为空!"
	q:bpaId="" "重症监护Id为空!"
	s EpisodeID=+$g(^DHCBPArrange(bpaId))
	q:EpisodeID=0 "就诊号为空!"
	s wardId=$p($g(^PAADM(EpisodeID)),"^",70)
	s wardLocId=$p(^PAWARD(+wardId),"^",5)
	q:wardLocId'=ctlocId "病人当前科室与待操作科室不一致!"
	q:'$d(^PAADM(EpisodeID)) "就诊记录无数据!"
	s bppId=$o(^DHCBPPara(0,bpaId,""))
	q:bppId="" "无当前病人参数Id!"
	q:'$d(^DHCBPPara(bppId,"I")) "当前病人参数有误!"
	m ^DHCBPC("Para",ctlocId)=^DHCBPPara(bppId)
	
	s EpisodeIDList=..FindWardPatient("", ctlocId)
	q:EpisodeIDList="" 0
	f i=1:1:$l(EpisodeIDList,"^") d
	    .s EpisodeID=+$p(EpisodeIDList,"^",i)
	    .s curBpaId=..GetBpaId(EpisodeID,"","") //返回单条，不创建新监护
	    .q:curBpaId=bpaId
	    .s curBppId=..GetBppId(curBpaId,ctlocId)
	    .k ^DHCBPPara(curBppId,"I")
	    .m ^DHCBPPara(curBppId,"I")=^DHCBPPara(bppId,"I")
	q 0
}

/// Creator：      	ypz
/// CreatDate：    	2010-08-02
/// Description： 	取监护病人床位定义的采集监护项的常用医嘱ID
/// Table：        	DHC_IUC_Arrange,DHC_BP_BedEquip,DHC_BP_BedEquipDetail
/// Input：        	bpaId监护安排表ID
/// Output：       
/// Return：       	返回以^分割的串，第一个为0正常返回,后面为常用医嘱ID串;第一个小于0数据,后面为出错信息。
ClassMethod GetBedEquipBpcriId(bpaId As %String) As %Library.String
{
    q:$g(^DHCCLSet("BP","UnCollect"))="Y" "0^"
	q:bpaId="" "-1^重症监护Id为空!"
	s EpisodeID=+$g(^DHCBPArrange(bpaId))
	q:EpisodeID=0 "-1^就诊号为空!"
	s bedId=$p($g(^PAADM(EpisodeID)),"^",73)
	q:bedId="" "-1^病人不在床位上!"
    s bedSub=$p(bedId,"||",2)
    q:+bedSub=0 "-2^未定义床位!"
    s bedTpId=$p($g(^PAWARD(+bedId,"BED",+bedSub)),"^",2)
    s bpBed=$p($g(^PAC("BEDTP",+bedTpId)),"^",5)
    q:bpBed'="Y" "-3^非重症床!"
    s bpbeId="",retStr=0
    f  s bpbeId=$o(^DHCBPBedEquip(0,"Bed",bedId,bpbeId)) q:bpbeId=""  d
        .q:'$d(^DHCBPBedEquip(bpbeId))
        .s eqId=$p($g(^DHCBPBedEquip(bpbeId)),"^",2)
        .//q:eqId=""
        .q:$p($g(^DHCBPBedEquip(bpbeId)),"^",5)="" //未定义设备名
        .s bpBedSub=0
        .f  s bpBedSub=$o(^DHCBPBedEquip(bpbeId,"I",bpBedSub)) q:bpBedSub=""  d
        	..s bpcriId=$p(^DHCBPBedEquip(bpbeId,"I",bpBedSub),"^")
        	..q:bpcriId=""
        	..s retStr=retStr_"^"_bpcriId
    q retStr
}

/// Creator：      	ypz
/// CreatDate：    	2010-08-03
/// Description： 	按日期取ctlocId科室的，出院病人，
/// Table：        	DHC_BP_Arrange,PA_ADM
/// Input：        	toDate结束日期，ctlocId科室Id,aheadDays向前查看天数
/// Output：       
/// Return：       	返回出院病人的bpaId串，以"^"分割。
ClassMethod GetDischargeBpaId(toDate As %String = "", ctlocId As %String = "", aheadDays As %String = 3, bpaId As %String = "") As %Library.String
{
    s toDate=##class(web.DHCANOPCom).ConvertToDateH(toDate)
    s wardId=""
    i ctlocId'="" d
    	.s ctlocType=$p($g(^CTLOC(ctlocId)),"^",13)
		.i ctlocType="W" d
			..s wardId=$o(^PAWARD(0,"WARD_LocationDR",ctlocId,0))
			..s ctlocId=""
    s retStr=""
    s fromDate=toDate-aheadDays+1
    f date=fromDate:1:toDate d 
        .s EpisodeID=""
        .f  s EpisodeID=$o(^PAADMi("DischDate",date,EpisodeID)) q:EpisodeID=""  d
        	..q:'$d(^PAADM(EpisodeID))
        	..q:(ctlocId'="")&(ctlocId'=$p($g(^PAADM(EpisodeID)),"^",4))
        	..q:(wardId'="")&(wardId'=$p($g(^PAADM(EpisodeID)),"^",70))
        	..s curBpaId=..GetBpaId(EpisodeID,"","") //返回单条，不创建新监护
        	..q:curBpaId=""
        	..i retStr'="" s retStr=retStr_"^"
        	..s retStr=retStr_curBpaId
    i bpaId'="" d
    	.q:'$d(^DHCBPArrange(bpaId))
    	.s bpaBedId=$p($g(^DHCBPArrange(bpaId)),"^",4)
    	.q:wardId'=+bpaBedId //病人不是在用户登录病区监护的
    	.s EpisodeID=+$g(^DHCBPArrange(bpaId))
    	.q:'$d(^PAADM(EpisodeID))
    	.s bedId=$p($g(^PAADM(EpisodeID)),"^",73)
    	.s admVisitStatus=$p($g(^PAADM(EpisodeID)),"^",20)
    	.q:(admVisitStatus="A")&(+bpaBedId=$p($g(^PAADM(EpisodeID)),"^",70))
    	.i ("^"_retStr_"^")'[("^"_bpaId_"^") d
    		..i retStr'="" s retStr=retStr_"^"
    		..s retStr=retStr_bpaId
    q retStr
}

/// Creator：      	ypz
/// CreatDate：    	2011-11-29
/// Description： 	获取重症病人监护信息
/// Table：        	DHC_Bp_Arrange
/// Input：        	登记号regNo,就诊号EpisodeID,第三方住院号oaPatientId,第三方住院次数oaVisitId,用户工号ssusrInitials="",用户科室代码userCtlocCode=""
/// Output：        
/// Return：       	返回值分两级，第一级以"^"分割多条记录，第二级以$c(3)分割。
/// 					第二级：重症安排bpaId,用户userId,安全组ssgrpId,病人病区科室wardCtlocId,病区wardDesc,开始时间startDateTime,结束时间endDateTime
ClassMethod GetPatBpaInfo(regNo, EpisodeID, oaPatientId, oaVisitId, ssusrInitials = "", userCtlocCode = "") As %String
{
	i EpisodeID="" d
		.q:oaPatientId=""
		.q:oaVisitId=""
		.s oaPaadmType="I"
		.s oaId=$o(^DHCENSOA("0","VisitId",oaPaadmType,oaPatientId,oaVisitId,""))
		.q:oaId=""
		.s papmiId=$p(^DHCENSOA(oaId),"^",2)
		.s EpisodeID=$p(^DHCENSOA(oaId),"^",3)
	s bpaIdList=..GetBpaId(EpisodeID,regNo,"","N")
	q:bpaIdList="" ""
	
	s userCtlocId=##class(web.DHCCLCom).GetCtlocIdByCodeOrDesc(userCtlocCode,"Code")
 	s userCtlocType=$p($G(^CTLOC(+userCtlocId)),"^",13)
 	s userWardCtlocId=userCtlocId
 	i userCtlocType="W" d
 		.s userWardCtlocId=userCtlocId
 	e  d
 		.q:userCtlocType=""
 		.s linkChildSub=0   
 		.f  s linkChildSub=$o(^CTLOC(userCtlocId,"LINK",linkChildSub)) q:linkChildSub=""  d
 			..s linklocId=$p($G(^CTLOC(userCtlocId,"LINK",linkChildSub)),"^",1)
 			..q:$p($G(^CTLOC(+linklocId)),"^",13)'="W"
 			..i userWardCtlocId'="" s userWardCtlocId=userWardCtlocId_"^"
 			..s userWardCtlocId=userWardCtlocId_linklocId
	
	s retStr="",isFind=0
	s userId=##class(web.DHCCLCom).GetUserIdByInitials(ssusrInitials)
	i userId'="" s userId=$o(^SSU("SSUSR",userId),-1)
	f  s userId=$o(^SSU("SSUSR",userId)) q:(userId="")!(isFind)  d
		.s ctcpId=$p(^SSU("SSUSR",userId),"^",14)
		.q:ctcpId=""
		.s ctcptId=$p($g(^CTPCP(+ctcpId,1)),"^",4)  ;CTPCP_CarPrvTp_DR
		.s ctcptType=$p($g(^CT("CPT",+ctcptId)),"^",4)  ;CT_CarPrvTp
		.q:ctcptType=""
		.q:(ssusrInitials="")&(ctcptType="NURSE") //传入为空时，不是护士身份
		.s ssgrpId=$p(^SSU("SSUSR",userId),"^",5)
		.//w userId_","_ctcptType_","_ssgrpId,!
		.s isFind=1
		.f i=1:1:$l(bpaIdList,"^") d
			..s bpaId=$p(bpaIdList,"^",i)
			..q:bpaId=""
			..q:'$d(^DHCBPArrange(bpaId))
			..q:"D"[$p(^DHCBPArrange(bpaId),"^",6)
			..s startDate=$p(^DHCBPArrange(bpaId),"^",6)
			..s endDate=$p(^DHCBPArrange(bpaId),"^",7)
			..s bpBedId=$p(^DHCBPArrange(bpaId),"^",4)
			..s bedId=$p($g(^PAADM(EpisodeID)),"^",73)
			..s bedSub=$p(bedId,"||",2)
			..q:(+bedSub=0) ;"未定义床位!"
			..s wardCtlocId=$p(^PAWARD(+bedId),"^",5)
			..q:(userWardCtlocId'="")&(("^"_userWardCtlocId_"^")'[("^"_wardCtlocId_"^"))
			..s bedTpId=$p($g(^PAWARD(+bedId,"BED",+bedSub)),"^",2)
			..s tBedCode=$p($g(^PAWARD(+bedId,"BED",+bedSub)),"^",1)
			..s wardDesc=$P($g(^PAWARD(+bedId)),"^",2)
			..s startDateTime=""
			..i startDate'="" s startDateTime=$zd(startDate,3)
			..s startTime=$p(^DHCBPArrange(bpaId),"^",8)
			..i startTime'="" s startDateTime=startDateTime_" "_$zt(startTime)
			..s endDateTime=""
			..i endDate'="" s endDateTime=$zd(endDate,3)
			..s endTime=$p(^DHCBPArrange(bpaId),"^",9)
			..i endTime'="" s endDateTime=endDateTime_" "_$zt(endTime)
			..i retStr'="" s retStr=retStr_"^"
			..s retStr=retStr_bpaId_$c(3)_userId_$c(3)_ssgrpId_$c(3)_wardCtlocId_$c(3)_wardDesc_$c(3)_startDateTime_$c(3)_endDateTime
	q retStr
}

ClassMethod GetItems(i As %String, j As %String) As %Library.List
{
 s k=0,returnList=""
 f k=i:1:(i+j) d
     .i $d(^TMPBP("Com",$i,k))=1 d
     ..s returnList=returnList_$LB($LB(^TMPBP("Com",$i,k)))
     ..k ^TMPBP("Com",$i,k)
 q returnList
}

/// w ##class(web.DHCBPCom).GetPatientEpisodeID("",83,+$h-100,+$h,249)
ClassMethod GetPatientEpisodeID(regNo = "", papmiId = "", fromDate = "", toDate = "", locId = "") As %String
{
	q:(regNo="")&(papmiId="") ""
	s fromDate=##class(web.DHCANOPCom).ConvertToDateH(fromDate,"")
	s toDate=##class(web.DHCANOPCom).ConvertToDateH(toDate,"")
	i papmiId="" s papmiId=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(regNo),""))
	q:papmiId="" ""
	s EpisodeID="",EpisodeIDList=""
	s admType=""
	f  s admType=$o(^PAPERdr(papmiId,"ADM",admType),-1) q:admType=""  d
	.f  s EpisodeID=$o(^PAPERdr(papmiId,"ADM",admType,EpisodeID),-1) q:EpisodeID=""  d 
	..s paadmVisitStatus=$p($g(^PAADM(EpisodeID)),"^",20)
	..q:(paadmVisitStatus'="A")&(paadmVisitStatus'="D")
	..s admDate=$p($g(^PAADM(EpisodeID)),"^",6)
	..s admDeptId=$p($g(^PAADM(EpisodeID)),"^",4)
	..q:(admDeptId'=locId)&(locId'="")
	..q:(fromDate'="")&(admDate<fromDate)
	..q:(toDate'="")&(admDate>toDate)
	..i EpisodeIDList'="" s EpisodeIDList=EpisodeIDList_"^"
	..s EpisodeIDList=EpisodeIDList_EpisodeID
	q EpisodeIDList
}

/// d ##class(%ResultSet).RunQuery("web.DHCBPCom","FindUserByLoc",42)
Query FindUserByLoc(locId, ctcpType) As %Query(ROWSPEC = "CareprovId,CareprovDesc,Id,Name,Account,GroupId")
{
}

ClassMethod FindUserByLocExecute(ByRef qHandle As %Binary, locId, ctcpType) As %Status
{
	s repid=$I(^CacheTemp)	
	s ind=1
	i locId="" Set qHandle=$lb(0,repid,0) Quit $$$OK

	s locIdList=locId_"^"_##class(web.DHCCLCom).GetLinkLocId(locId)
	f i=1:1:$l(locIdList,"^") d
		.s curLocId=$p(locIdList,"^",i)
		.q:+curLocId=0
		.s resId=""
		.f  s resId=$O(^RB("RES",0,"CTLOC",curLocId,resId))  q:resId=""  d
			..;医护人员Id
			..s ctcpId=$P(^RB("RES",resId),"^",2)
			..q:ctcpId=""
			..s ctcptDesc=$p($g(^CTPCP(+ctcpId,1)),"^",2)
			..;医护人员类型
			..s ctcptId=$p($g(^CTPCP(ctcpId,1)),"^",4)
			..q:ctcptId=""
			..s ctcptType=$p($g(^CT("CPT",ctcptId)),"^",4)
			..q:ctcptType'=ctcpType
			..;UserId
			..s userId=$o(^SSU("SSUSR",0,"CTPCP",ctcpId,""))
			..q:userId=""
			..s userName=$p($g(^SSU("SSUSR",userId)),"^",2)
			..s userStatDate=$p($g(^SSU("SSUSR",userId)),"^",96) //20201130开始日期
			..q:(userStatDate'="")&&(userStatDate>+$h)
			..s userEndDate=$p($g(^SSU("SSUSR",userId)),"^",97) //20201130截止日期
			..q:(userEndDate'="")&&(userEndDate<+$h) 
			..;登录号？
			..;s ssusrInitials=$o(^SSU("SSUSR",0,"SSUSR_Initials",ctcpId,""))
			..s ssusrInitials=$p($g(^SSU("SSUSR",userId)),"^",1)
			..;默认登录安全组Id
			..s groupId=$p($g(^SSU("SSUSR",userId)),"^",5)
			..s tmpLId=""
			..;其他登录安全组
			..f  s tmpLId=$o(^SSU("SSUSR",userId,"OTHLL",tmpLId))   q:tmpLId=""  d
				...q:$d(^SSU("SSUSR",userId,"OTHLL",tmpLId))<1
				...;登录科室Id
				...s tmpLocId=$p(^SSU("SSUSR",userId,"OTHLL",tmpLId),"^",1)
				...q:tmpLocId'=curLocId
				...;登录安全组Id
				...s tmpGroupId=$p($g(^SSU("SSUSR",userId,"OTHLL",tmpLId)),"^",2)
				...i (tmpGroupId'="")&(("^"_groupId_"^")'[("^"_tmpGroupId_"^")) d
					....i groupId'="" s groupId=groupId_"^"
					....s groupId=groupId_tmpGroupId
			..d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow
	set Data=$lb(ctcpId,ctcptDesc,userId,userName,ssusrInitials,groupId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindUserByLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindUserByLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindUserByLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindUserByLocExecute ]
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

Query LookUpMrcDiagnosis(mrcidAlias As %String) As %Query(ROWSPEC = "Description:%String,Id:%String")
{
}

ClassMethod LookUpMrcDiagnosisExecute(ByRef qHandle As %Binary, mrcidAlias As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	s rowid=0,i=0 //ypz 060811
	if mrcidAlias'=""
	{
	 // s icdx=""  s icdx=$O(^MRC("IK_Name",$ZCONVERT(mrcidAlias,"U"),icdx),-1)
    	//if (icdx'="")
	//   {
	//	 if $D(^MRC("ID",icdx))
	//	 {
		 // s DiagDes=$p(^MRC("ID",icdx),"^",2)
	     // s rowid0=icdx
	     // d OutputRow2
	     // b
	     // Set qHandle=$lb(0,repid,0)
	     // Quit $$$OK
		// }
     // }
	s type=$$ALPHAUP^SSUTIL4(mrcidAlias)  //ypz 070313 $ZCONVERT(mrcidAlias,"U")
    i type'="" d
		.s flag="N"
		.s OpDiag=$O(^MRC("ID",0,"ALIAS",type),-1) //ypz 070313 保证找到当前串
    	.f  s OpDiag=$O(^MRC("ID",0,"ALIAS",OpDiag)) q:(OpDiag="")!(flag="Y")  d
    		..if $e(OpDiag,1,$L(type))'=type s flag="Y" q
    		..s mrcidId=""
    		..f  s mrcidId=$O(^MRC("ID",0,"ALIAS",OpDiag,mrcidId)) q:(mrcidId="")  d
    			...//s opaId="" s opaId=$O(^MRC("ID",0,"ALIAS",OpDiag,opaId),-1) 
    			...s rowid0=mrcidId
    			...s DiagDes=$p(^MRC("ID",mrcidId),"^",2)
    			...s i=i+1
    			...Do OutputRow2
	}
	if i>0 Set qHandle=$lb(0,repid,0) Quit $$$OK
	f  s rowid=$o(^MRC("ID",rowid)) q:rowid=""  d
	.s DiagDes=$p(^MRC("ID",rowid),"^",2)
	.;s userloc=$p(^SSU("SSUSR",rowid),"^",4)
	.s rowid0=rowid
	.s LinkStr=$ZCONVERT(mrcidAlias,"U")
	.if (DiagDes)[(LinkStr)  do
 	..Do OutputRow2	 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow2
	set Data=$lb(DiagDes,rowid0)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod LookUpMrcDiagnosisFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpMrcDiagnosisExecute ]
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

ClassMethod LookUpMrcDiagnosisClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpMrcDiagnosisExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCBPCom","LookUpTestResult","","C886583","15","HBSAG","2013-10-01","00:00","2014-11-01","23:59",0)
Query LookUpTestResult(needEpisodeID, regNoList, ctlocId, standardCode, startDate, startTime, endDate, endTime, ifSingle = 0) As %Query(ROWSPEC = "ReceiveDate,ItemName,Abbreviation,Result,Range,Unit")
{
}

ClassMethod LookUpTestResultExecute(ByRef qHandle As %Binary, needEpisodeID, regNoList, ctlocId, standardCode, startDate, startTime, endDate, endTime, ifSingle = 0) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	s rowid=0,i=0 //ypz 060811
	k labCode
	q:standardCode="" ""
	s testCode="",testCodeStr=""
	f  s testCode=$o(^TTABi("TC","NNL",standardCode,testCode)) q:testCode=""  d
		.i testCodeStr'="" s testCodeStr=testCodeStr_"^"
		.s testCodeStr=testCodeStr_testCode
	s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s startTime=##class(web.DHCClinicCom).ConvertToTimeH(startTime)
	s endDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	s endTime=##class(web.DHCClinicCom).ConvertToTimeH(endTime)
	i needEpisodeID'="" d
	.s papmiId=$p($g(^PAADM(needEpisodeID)),"^",1)
	.s regNoList=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	.s paadmDate=$p(^PAADM(needEpisodeID),"^",6)
	.i paadmDate'="" d
	..q:(paadmDate<startDate)
	..s paadmTime=$p(^PAADM(needEpisodeID),"^",7)
	..q:(paadmDate=startDate)&(paadmTime<startTime)
	..s startDate=paadmDate,startTime=paadmTime
	.s paadmDischgDate=$p(^PAADM(needEpisodeID),"^",17)
	.i paadmDischgDate>paadmDate d
	..q:(paadmDischgDate>endDate)
	..s paadmDischgTime=$p(^PAADM(needEpisodeID),"^",18)
	..q:(paadmDischgDate=endDate)&(paadmDischgTime>endTime)
	..s endDate=paadmDischgDate,endTime=paadmDischgTime
	i regNoList="" d
	.s EpisodeIDList=##class(web.DHCICUCom).FindWardPatient("", ctlocId)
	.q:EpisodeIDList=""
	.f i=1:1:$l(EpisodeIDList,"^") d
	..s EpisodeID=+$p(EpisodeIDList,"^",i)
	..s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
	..i regNoList'="" s regNoList=regNoList_"^"
	..s regNoList=regNoList_$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	q:regNoList="" ""
	s retStr=""
	f i=1:1:$l(regNoList,"^") d
	.s regNo=$p(regNoList,"^",i)
	.q:regNo=""
	.s testCode="",ifFind=0
	.f  s testCode=$o(^TDHCOldResult(1,regNo,testCode)) q:(testCode="")!(ifFind)  d
	..q:("^"_testCodeStr_"^")'[("^"_testCode_"^")
	..s date=endDate+11
	..f  s date=$o(^TDHCOldResult(1,regNo,testCode,date),-1) q:(date="")!(date<startDate)!(ifFind)  d
	...s time=""
	...f  s time=$o(^TDHCOldResult(1,regNo,testCode,date,time),-1) q:(time="")!(ifFind)  d
	....q:(date<startDate) //&(time*60<startTime)
	....//q:(date=endDate)&(time*60'<endTime)
	....s labNo=""
	....f  s labNo=$o(^TDHCOldResult(1,regNo,testCode,date,time,labNo)) q:(labNo="")!(ifFind)  d
	.....s testSet=""
	.....f  s testSet=$o(^TDHCOldResult(1,regNo,testCode,date,time,labNo,testSet)) q:testSet=""  d
	......s sub=$o(^TDHCOldResult(1,regNo,testCode,date,time,labNo,testSet,""))
	......s result=$p(^TEPI(labNo,1,testSet,sub,"DATA",testCode),"\",1)
	......s receiveDate=$p(^TEPI(labNo,1,testSet,sub),"\",1)
	......s receiveTime=$p(^TEPI(labNo,1,testSet,sub),"\",2)
	......q:(receiveDate=startDate)&(receiveTime*60<startTime)
	......q:(receiveDate>endDate)!((receiveDate=endDate)&(receiveTime*60>endTime))
	......s receiveDate=$zd(receiveDate)
	......s range=^TEPI(labNo,1,testSet,sub,"DATA",testCode,"Ranges")
	......s unit=^TEPI(labNo,1,testSet,sub,"DATA",testCode,"Unit")
	......//w labNo_"/"_testSet_"/"_date_"/"_time,!
	......//q:$d(labCode(testSet,testCode))
	......//s labCode(testSet,testCode)=""
	......//w regNo_" "_$zd(date,3)_" "_$zt(time,2)_":" 
	......//w testSet_":"_$p(^TTAB("TS",testSet),"\",1)_"/"_testCode_":"_$p(^TTAB("TC",testCode),"\",1)_"/"_result_" "_unit_":"_range,!
	......;i retStr'="" s retStr=retStr_"^"
	......;s retStr=retStr_result_"\"_unit_"\"_range
	......;i ifSingle s ifFind=1
	......s itemName=$p(^TTAB("TC",testCode),"\",1)
	......s abbreviation=$p(^TTAB("TC",testCode),"\",12)
	......Do OutputRow2
							
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow2
	set Data=$lb(receiveDate,itemName,abbreviation,result,range,unit)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod LookUpTestResultFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpTestResultExecute ]
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

ClassMethod LookUpTestResultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpTestResultExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCBPCom","LookUpTestDaily","3373065||9308")
Query LookUpTestDaily(ordItemId) As %Query(ROWSPEC = "ItemName:%String,Abbreviation:%String,ResultStr:%String")
{
}

ClassMethod LookUpTestDailyExecute(ByRef qHandle As %Binary, ordItemId) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s ^TMPzt("ordItemId")=ordItemId
    s ord=$p(ordItemId,"||",1),sub=$p(ordItemId,"||",2)
 	s recLoc=$p(^OEORD(ord,"I",sub,3),"^",6)
 	s tsRowId=$p($g(^OEORD(ord,"I",sub,3)),"^",35)
    s arcimId=$p($g(^OEORD(ord,"I",sub,1)),"^",2)
    i tsRowId="" w "Test Set not in LabTrak" q
 	s labNo=$p(tsRowId,"||",1),ts=$p(tsRowId,"||",2),tsCnt=$p(tsRowId,"||",3)
 	
 	s specDate=$p(##class(web.DHCNurCom).GetSpecCollInfo(ordItemId),"^",3) //采集日期
	s specTime=$p(##class(web.DHCNurCom).GetSpecCollInfo(ordItemId),"^",4) //采集时间
 	s debtor=$p(^TEPI(labNo),"\",18)
 	b ;1
    s days=6
    s preDate=specDate-days
   
    s flag=0
    s testCode=""
 	f  s testCode=$o(^TEPI(labNo,1,ts,tsCnt,"DATA",testCode)) q:testCode=""  d
 	.;b ;t1
 	.s date="" f  s date=$o(^TDHCOldResult("1",debtor,testCode,date),-1) q:(date="")!(flag=1)  d
    ..;q:(days>0)&(date-preDate<0)  s flag=1
    ..;b ;t2
    ..s time="" f  s time=$o(^TDHCOldResult("1",debtor,testCode,date,time),-1)  q:(time="")  d
    ...s tmpLabNo=""  f  s tmpLabNo=$o(^TDHCOldResult("1",debtor,testCode,date,time,tmpLabNo)) q:tmpLabNo=""  d 
    ....s testSet=""  f  s testSet=$o(^TDHCOldResult("1",debtor,testCode,date,time,tmpLabNo,testSet)) q:testSet=""  d
    .....s tsSub="" f  s tsSub=$o(^TDHCOldResult("1",debtor,testCode,date,time,tmpLabNo,testSet,tsSub)) q:tsSub=""  d
    ......s result="",range=""
    ......;b t3
    ......s result=$p($g(^TEPI(tmpLabNo,1,testSet,tsSub,"DATA",testCode)),"\",1)
    ......s range=$g(^TEPI(tmpLabNo,1,testSet,tsSub,"DATA",testCode,"Ranges"))
	......s dt=$zd(date,3)_" "_$zt(time,2)
	......i $d(^TMPLab($j,"TCRes",testCode)) d
	.......s ^TMPLab($j,"TCRes",testCode)=^TMPLab($j,"TCRes",testCode)_"^"_dt_"|"_result_"|"_range
	......e  s ^TMPLab($j,"TCRes",testCode)=dt_"|"_result_"|"_range
    ....;s ^TMPLab($j,"TCRes",testCode,date,time)=result
    ....;s itemName=$p(^TTAB("TC",testCode),"\",1)
	....;s abbreviation=$p(^TTAB("TC",testCode),"\",12)
    
    s testCode=""
    f  s testCode=$o(^TMPLab($j,"TCRes",testCode)) q:(testCode="")  d
	.s itemName=$p(^TTAB("TC",testCode),"\",1)
	.s abbreviation=$p(^TTAB("TC",testCode),"\",12)	
	.s reStr=^TMPLab($j,"TCRes",testCode)
	.d OutputRow2
	k ^TMPLab($j,"TCRes")			
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow2
	set Data=$lb(itemName,abbreviation,reStr)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod LookUpTestDailyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpTestDailyExecute ]
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

ClassMethod LookUpTestDailyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpTestDailyExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindBodySite() As %SQLQuery(CONTAINID = 1, ROWSPEC = "Id:%String,Description:%String")
{
    select BODS_RowId,BODS_Desc from SQLUser.OEC_BodySite
}

ClassMethod GetServerDateTime() As %String
{
	s date=$zd(+$h,3)
	s time=$zt($p($h,",",2))
	q date_"^"_time
}

// 常用码表查找

Query LookUpComCode(type) As %Query(ROWSPEC = "Id:%String,Code:%String,Description:%String")
{
}

ClassMethod LookUpComCodeExecute(ByRef qHandle As %Binary, type) As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	i type="" s type="Default"
	s codeId=0
	f  s codeId=$o(^DHCCLComCode(type,codeId)) q:codeId=""  d
		.s ifActive=$p(^DHCCLComCode(type,codeId),"^",3)
		.q:(ifActive'="Y")&(ifActive'="")
		.s tCode=$p(^DHCCLComCode(type,codeId),"^",1)
		.s tDesc=$p(^DHCCLComCode(type,codeId),"^",2)
		.d OutputRow2
	s qHandle=$lb(0,repid,0)
	q $$$OK

OutputRow2
	s Data=$lb(codeId,tCode,tDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod LookUpComCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpComCodeExecute ]
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

ClassMethod LookUpComCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpComCodeExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

// 向DHC_BP_Record添加数据

//    bapId的recordId在相应的date和time,有数据则更新

ClassMethod InsertBPRecord(bpaId, recordId, date, time, value, note)
{
	i date'=+date s date=##class(web.DHCClinicCom).ConvertToDateH(date)
	i time'=+time s time=##class(web.DHCClinicCom).ConvertToTimeH(time)
	s updateDate=+$h
	s updateTime=$p($h,",",2)
	s editStatus="N"
	s rowId=""
	&sql(SELECT BPR_RowId INTO :rowId 
        FROM DHC_BP_Record where BPR_BPArrange_Dr=:bpaId and BPR_BPCRecordItem_Dr=:recordId and BPR_StartDate=:date and BPR_StartTime=:time)
	s res=""
	
	i rowId'="" d
	.; 当值(ICUCD_Note,ICUCD_Qty)与不同时修改;否则不修改
	.s obj=##class(User.DHCBPRecord).%OpenId(rowId)
	.s obj.BPRUpdateDate=updateDate
	.s obj.BPRUpdateTime=updateTime
	.s obj.BPRQty=value
	.s obj.BPRNote=note
	.d obj.%Save()
	.s res="update:"_rowId
	.; &SQL(update DHC_BP_Record set BPR_Note=:note,BPR_Qty=:value, BPR_UpdateDate=:updateDate,BPR_UpdateTime=:updateTime where BPR_BPArrange_Dr=:bpaId and BPR_BPCRecordItem_Dr=:recordId and BPR_UpdateDate=:date and BPR_UpdateTime=:time and (BPR_Note<>:note or BPR_Qty<>:value))
	e  d
	.&SQL(insert into DHC_BP_Record(BPR_BPArrange_Dr,BPR_BPCRecordItem_Dr,BPR_EditStatus,BPR_StartDate,BPR_StartTime,BPR_Qty,BPR_Note,BPR_UpdateDate,BPR_UpdateTime) values(:bpaId,:recordId,:editStatus,:date,:time,:value,:note,:updateDate,:updateTime))
	.i SQLCODE=0 s res="insert:"_$g(%ROWID)
	.e  s res="Error"_SQLCODE
	q res
}

/// 通过医生 护士 ID取得姓名 若ID中有~,则到CTPCP中取值(本院人员),否则到DHC_CL_CareProv中取(进修 实习)
ClassMethod GetNameById(docdr As %String) As %String
{
	q:(docdr="")!(docdr=0) ""
	s len=$l(docdr,"~")
	q:(len'=1)&(len'=2) "用户ID不正确!"
	s docName=""
	i len=1 d
	.s docName=$tr($p($g(^CTPCP(+docdr,1)),"^",2)," ","")
	.i $l(docName,"-")>1 s docName=$p(docName,"-",1)
	i len=2 d
	.s clcpRowId=$p(docdr,"~",2)
	.i $g(^DHCCLCP(+clcpRowId))'="" s docName=$li(^DHCCLCP(+clcpRowId),2)
	.e  s docName=""
	i docName="" q "用户不存在!"
	q docName
}

/// 根据就诊号、登记号或科室的化验项目标准码standardCode，取检验结果,ifSingle=1取最新值
/// 返回值：多个结果以^分割,每个以"\"分割：检验值，单位，检验正常值范围
/// w ##class(web.DHCBPCom).GetTestResult("","16047898","","UREA","2016/8/23","0:00","2016/8/24","23:59","1","SP36","")
ClassMethod GetTestResult(needEpisodeID, regNoList, ctlocId, standardCode, startDate, startTime, endDate, endTime, ifSingle = 0, needNote = "", dataField = "") As %String
{
	s STX=$c(2)
	s ETX=$c(3)
	
	s retStr=""
	s testResult=##class(web.DHCClinicCom).GetTestResult(needEpisodeID, regNoList, ctlocId, standardCode, startDate, startTime, endDate, endTime,ifSingle,needNote,dataField)
	i testResult'="" d
  	.f y=1:1:$l(testResult,ETX) d
  	..s labStrList=$p(testResult,ETX,y)
  	..s receiveDate=$p(labStrList,STX,4)
  	..if receiveDate'="" s receiveDate=$zd($p(labStrList,STX,4),3)  	
  	..s $p(labStrList,STX,4)=receiveDate
  	..s labStrTime=$p(labStrList,STX,5)
  	..if labStrTime'="" s labStrTime=$zt($p(labStrList,STX,5),2)  	
  	..s $p(labStrList,STX,5)=labStrTime  	
  	..i retStr'="" s retStr=retStr_ETX
	..s retStr=retStr_labStrList
	q retStr
}

/// 按bpaId和recordItemId找出离查询时间(dateTime)最近的时间点和数据
/// bpaId:血透按排Id
/// date:日期
/// time:时间
/// recordItemId: 码表ID
/// scope: 查询范围，默认为30分钟(1800秒)
ClassMethod GetCollectData(bpaId, date, time, recordItemId, scope = 1800)
{
	// w ##class(web.DHCBPCom).GetCollectData(bpaId,date,time)
	s date=##class(web.DHCClinicCom).ConvertToDateH(date)
	s time=##class(web.DHCClinicCom).ConvertToTimeH(time)
	s oneDay=3600*24
	s dateTime=(oneDay*date)+time
	s startDate="",startTime="",timegap="",text="",num=""
	// 按bpaId和recordItemId找出离查询时间(dateTime)最近的时间点和数据
	&SQL(SELECT TOP 1 ABS((BPCD_StartDate*:oneDay+BPCD_StartTime)-:dateTime) as timegap,BPCD_StartDate,BPCD_StartTime,BPCD_Text,BPCD_Num into:timegap,:startDate,:startTime,:text,:num FROM DHC_BP_CollectData 
	WHERE BPCD_BPArrange_Dr=:bpaId and BPCD_RecordItem_Dr=:recordItemId order by timegap)
	
	s timegap=+timegap
	
	s Id="",OeoriId="",UpdateUserId="",UpdateUserDesc="",EndDate="",EndTime="",ArcimId="",Note="",Qty="",UomId="",InstructId="",RecordCatId="",Speed="",UpdateDate="",UpdateTime="",EditStatus="",RecvLocId="",SpeedUnitId="",DataSource="",DataType="",ArcimDesc=""
	i ((timegap>scope)) d // ||(timegap=0)
	.w "未找到数据:" ,!
	.s startDate="",startTime=""
	.s Data=""
	.//s Data=$lb(Id,bpaId,recordItemId ,OeoriId,UpdateUserId,UpdateUserDesc,startDate,startTime,EndDate,EndTime,ArcimId,"","",UomId,InstructId,RecordCatId,Speed,UpdateDate,UpdateTime,EditStatus,RecvLocId,SpeedUnitId,DataSource,DataType,ArcimDesc)
	e  d
	.w "StartDate:",$zd(startDate),"  startTime:",$zt(startTime),"Value:",num,"  ",text,!
	.
	.s startDate=##class(web.DHCClinicCom).ConvertToDate(date),startTime=##class(web.DHCClinicCom).ConvertToTime(time)
	.s Data=$lb(Id,bpaId,recordItemId ,OeoriId,UpdateUserId,UpdateUserDesc,startDate,startTime,EndDate,EndTime,ArcimId,text,num,UomId,InstructId,RecordCatId,Speed,UpdateDate,UpdateTime,EditStatus,RecvLocId,SpeedUnitId,DataSource,DataType,ArcimDesc)
 
	q Data
}

/// 取离某时间点最近的采集数据
/// 入参：
///   bapId监护Id
///   para:[[date]<空格>]<^>[recordId1,recordId2,..,recordIdn]],例如：2015/1/13 13:01^1;2;3;17;6;8;4;16;
/// 
Query FindCollectData(bpaId, para) As %Query(ROWSPEC = "Id:%String,ArrangeId:%String,RecordItemId :%String,OeoriId:%String,UpdateUserId:%String,UpdateUserDesc:%String,StartDate:%String,StartTime:%String,EndDate:%String,EndTime:%String,ArcimId:%String,Note:%String,Qty:%String,UomId:%String,InstructId:%String,RecordCatId:%String,Speed:%String,UpdateDate:%String,UpdateTime:%String,EditStatus:%String,RecvLocId:%String,SpeedUnitId:%String,DataSource:%String,DataType:%String,ArcimDesc:%String") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCBPRecord","FindBPRecord",8,60000,0,66000,0)
ClassMethod FindCollectDataExecute(ByRef qHandle As %Binary, bpaId, para) As %Status
{
	// D ##class(%ResultSet).RunQuery("web.DHCBPCom","FindCollectData",bpaId,para)
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	
	s ^TmpBpDebug("para")=para
	s dateTime=$p(para,"^",1)
	s date=##class(web.DHCClinicCom).ConvertToDateH($p(dateTime," ",1))
	s time=##class(web.DHCClinicCom).ConvertToTimeH($p(dateTime," ",2))
	
	s recordItemList=$p(para,"^",2)
	s recordItemList=$Replace(recordItemList,",",";")
	s len=$L(recordItemList,";")
	s i=0  f i=1:1:len  d
	.s recordItemId=$p(recordItemList,";",i)
	.q:recordItemId=""
	.
	.s Data=..GetCollectData(bpaId,date,time,recordItemId)
	.w recordItemId,!
	.i Data'="" d
	..d OutputBPRecord(Data)
	s qHandle=$lb(0,repid,0)
	q $$$OK
OutputBPRecord(Data)
	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindCollectDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBPRecordExecute ]
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

ClassMethod FindCollectDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCollectDataExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 采集入库
/// 入参:bpaId    :按排表ID
///      equipId  :设备ID，即DHC_BP_BedEquip表的RowId
///      extInfo  :扩展字段，自动采集时表示设备类型
///      dataPara :数据
///      status   :状态
/// 返回值:
///      0        :正常(后跟入库的信息)
/// /     其他     :未入库
ClassMethod InsertToDb(bpaId As %String, equipId As %String, extInfo As %String = "", dataPara As %String = "", status As %String = "")
{
	s monStatus=""
	set equip=##class(User.DHCBPBedEquip).%OpenId(equipId)
	quit:equip="" "Unkonw Device"_equipId
	set bedId=""
	if (equip.BPBEBedDr'="") set bedId=equip.BPBEBedDr.%Id()
	&sql(SELECT BPA_RowId into :bpaId FROM DHC_BP_Arrange WHERE BPA_Status='M' and BPA_BPCBed_Dr=:bedId)
	quit:bpaId="" "当前床位未找到病人"
	
	// 查找设备类型ID
	s devTypeId=$$GetDevTypeId(equipId,extInfo)
	q:((+devTypeId)<=0) "未知采集设备类型"
	
	// 循环解析数据
	s rerStr="",itemNum=$L(dataPara,"^")
	f i=1:1:itemNum d
	.s itemStr=$P(dataPara,"^",i)
	.q:itemStr=""
	.s itemName=$P(itemStr,"#",1)
	.s date=$P(itemStr,"#",2)
	.s time=$P(itemStr,"#",3)
	.s date=##class(web.DHCClinicCom).ConvertToDateH(date)
	.s time=##class(web.DHCClinicCom).ConvertToTimeH(time)
	.s value=$P(itemStr,"#",5)
	.s ancctiSub=$o(^DHCANC("CType",0,"ChannelNo",itemName,devTypeId,""))
	.q:ancctiSub=""
	.s recordItemId=$p(^DHCANC("CType",devTypeId,"I",ancctiSub),"^",1)
	.b
	.q:recordItemId=""
	.s res=..InsertCollectData(bpaId,recordItemId,date,time,value)
	.i rerStr="" s rerStr="0 "_itemName_":"_res
	.e  s rerStr=rerStr_","_itemName_":"_res
	
	q rerStr
GetDevTypeId(equipId,extInfo)
	s devTypeId="",devTypeCode=""
	&sql(SELECT BPBE_CollectType_Dr,BPBE_CollectType_Dr->ANCCT_Code into:devTypeId,:devTypeCode FROM DHC_BP_BedEquip WHERE BPBE_RowId=:equipId)
	
	i (((devTypeCode="AutoCheckDev")||(devTypeCode="TestDev"))&&(extInfo'="")) d
	.s devTypeId=""
	.&sql(SELECT ANCCT_RowId into :devTypeId FROM DHC_ANC_CollectType WHERE ANCCT_Code=:extInfo)
	.
	q devTypeId
}

ClassMethod InsertCollectData(bpaId, recordItemId, date, time, value)
{
	// w ##class(web.DHCBPCom).InsertCollectData(1,1,"2015-01-14","10:00",133)
	i '$ISVALIDNUM(date) s date=##class(web.DHCClinicCom).ConvertToDateH(date)
	i '$ISVALIDNUM(time) s time=##class(web.DHCClinicCom).ConvertToTimeH(time)
	&sql(SELECT BPCRI_DataType into :numType FROM DHC_BPC_RecordItem WHERE BPCRI_RowId=:recordItemId)
	q:numType="" "未指定数据类型"
	i numType="N" s text="",num=+value
	e  s text=value,num=""
	s updateDate=+$h
	s updateTime=$p($h,",",2)
	s count=0
	&sql(SELECT count(*) into:count FROM DHC_BP_CollectData WHERE BPCD_BPArrange_Dr=:bpaId and BPCD_RecordItem_Dr=:recordItemId AND BPCD_StartDate=:date AND BPCD_StartTime=:time)
	s res=""
	i count>0 d
	.
	.&sql(UPDATE DHC_BP_CollectData SET BPCD_Text=:text, BPCD_Num=:num, BPCD_UpdateDate=:updateDate,BPCD_UpdateTime=:updateTime WHERE BPCD_BPArrange_Dr=:bpaId and BPCD_RecordItem_Dr=:recordItemId AND BPCD_StartDate=:date AND BPCD_StartTime=:time)
	.i SQLCODE=0 s res=$g(%ROWID)
	.w "更新",!
	e  d
	.&sql(INSERT INTO DHC_BP_CollectData(BPCD_BPArrange_Dr,BPCD_StartDate,BPCD_StartTime,BPCD_RecordItem_Dr,BPCD_Text,BPCD_Num,BPCD_UpdateDate,BPCD_UpdateTime) VALUES(:bpaId,:date,:time,:recordItemId,:text,:num,:updateDate,:updateTime))
	.w "Insert",!
	.i SQLCODE=0 s res=$g(%ROWID)
	q res
}

/// 根据就诊号或者登记号、医嘱码表ID取医嘱结果,ifSingle=1取最新值
/// 返回值：医嘱名字或者值或者执行时间等
ClassMethod GetOeordResult(needEpisodeID, regNo, bpciodCode, startDate, startTime, endDate, endTime, inDateTime, outDateTime, ifSingle = 0, needNote = "", dataField = "", oeoriNote = "", typeCat = "", specCode = "") As %String
{
	//w ##class(web.DHCBPCom).GetOeordResult("","43423435","32454||1","64374",0,"64384","23:59:59","","","1","","")
	q:(needEpisodeID="")&&(regNo="") "notPatient"	
	i needEpisodeID="" s needEpisodeList=##class(web.DHCClinicCom).GetPatientEpisodeID(regNo,"","","","IEO")
	e  s needEpisodeList=needEpisodeID
	//i regNo="C879608" w "测试0:"_needEpisodeList,!
	s value="",times=0,isFind=0
	f i=1:1:$l(needEpisodeList,"^") d
	 .s episodeID=$p(needEpisodeList,"^",i)	 
	 .s oeordId=$o(^OEORD(0,"Adm",episodeID,""))
	 .q:oeordId=""
	 .//i regNo="C879608" w "测试1:"_oeordId_"/"_episodeID,!	
	 .s arcimId=""
	 .f  s arcimId=$o(^OEORDi(0,"ARCIM",oeordId,arcimId)) q:(arcimId="")!(isFind)  d
	    ..q:(typeCat="")&(("^"_bpciodCode_"^")'[("^"_arcimId_"^"))
	    ..
		..s phcPoisonCode=""
		..i (typeCat="Poison")||(typeCat="Antibiotics") d
		....s phcPoisonCode=##class(web.DHCClinicCom).GetPHCPoisonCode(arcimId)
		..q:(typeCat="Poison")&(("^"_bpciodCode_"^")'[("^"_phcPoisonCode_"^"))
		..//i regNo="C879608" w "测试2:"_oeordId_"/"_arcimId_"/"_(startDate-1)_"/"_endDate,!		
		..s oeoriSttDate="",ArcimDesc=""
		..s oeoriSttDate=startDate-1
		..f  s oeoriSttDate=$o(^OEORDi(0,"ARCIM",oeordId,arcimId,oeoriSttDate)) q:(oeoriSttDate="")!(isFind)  d
		   ...i (oeoriSttDate>endDate) s oeoriSttDate=$h+100000 //退出	
		   ...;i regNo="C879608" w oeoriSttDate,!	
		   ...s oeoriSub=""
		   ...f  s oeoriSub=$o(^OEORDi(0,"ARCIM",oeordId,arcimId,oeoriSttDate,oeoriSub)) q:(oeoriSub="")!(isFind)  d
			....q:'$d(^OEORD(oeordId,"I",oeoriSub))
			....s oeoriId=oeordId_"||"_oeoriSub
			....s oecprCode="",oecprType="",exStDate="",exStTime=""						
			....s oecprId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",8)								
			....i oecprId>0 s oecprCode=$p($g(^OECPR(+oecprId)),"^",1) 
			....//i regNo="C879608" w "测试3:"_oecprId_"/"_oecprCode,!
			....i (oecprCode="S")!(oecprCode="OMST")!(oecprCode="OMCQZT") s oecprType="Y" //长期医嘱
			....s ordStatCode=##Class(web.DHCClinicCom).GetOrdStatCode(oeoriId)		
			....q:("DIU"[ordStatCode)&&(oecprType'="Y")
			....q:("IU"[ordStatCode)&&(oecprType="Y")
			....//i regNo="C879608" w "测试4:"_ordStatCode,!								
			....;i (oeoriSub=719) s ^dhctmpmfc(bpaId,oeordId,oeoriSub,arcimId,oeoriSttDate)="Antibiotics"_"/"_##class(web..DHCClinicCom)..GetDDD(arcimId)								
			....//w $p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2),!
			....;q:$p($g(^OEORD(oeordId,"I",oeoriSub,9)),"^",12)'=""								
			....s oeoriSttDat=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",9)
			....s oeoriSttTim=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",10)
			....s oeoriSttDateTime=oeoriSttDat+(oeoriSttTim/100000)								
			....q:(inDateTime'="")&&(oeoriSttDateTime<inDateTime)
			....q:(outDateTime'="")&&(oeoriSttDateTime>outDateTime)
			....//i regNo="C879608" w "测试5:"_oeoriSttDateTime_"/"_inDateTime_"/"_outDateTime,!
			....;i (bpaId=10196) s ^dhctmpmfc(bpaId,oeordId,oeoriSub,arcimId,oeoriSttDat,oeoriSttTim)=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),1)),"^",2)_"/"_oeoriSttDateTime_"/"_inDateTime_"/"_outDateTime
			....s oeoriEndDate=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",34)
			....s oeoriEndTime=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",15)								
			....i (oecprType="Y")  d
			  	.....s oeoreSub=0,isFrist=0
			  	.....f  s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)) q:(oeoreSub="")!(isFrist)  d
			  	......q:'$g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub))								
				......s exStDate=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",1)
				......s exStTime=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",2)
				......s isFrist=1								
				..........;i (bpaId=10233) s ^dhcmfctmp(bpaId,oeordId,oeoriSub,oeoreSub)=oeoriEndDate_"/"_oeoriEndTime_"/"_exStDate_"/"_exStTime	
			....q:(oeoriEndDate'="")&&(exStDate'="")&&(exStDate>oeoriEndDate)
			....q:(oeoriEndDate'="")&&(oeoriEndTime'="")&&(exStDate'="")&&(exStTime'="")&&(exStDate=oeoriEndDate)&&(exStTime>oeoriEndTime)
			....//i regNo="C879608" w "测试6:"_oeoriEndDate_"/"_oeoriEndTime_"/"_exStDate_"/"_exStTime,!
			....s curSpecCode=""
			....i specCode'="" d
				.....s curSpecSub=$o(^OEORD(oeordId,"I",oeoriSub,"SPEC",0))
				.....s curSpecCode=$p(^OEORD(oeordId,"I",oeoriSub,"SPEC",curSpecSub),"^",1)
				.....q:(specCode'="")&(specCode'=curSpecCode)								
			....i (dataField["Times")&&(dataField["DateTime") d //add 20140801显示次数和时间
				.....s times=times+1 //$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",12)
				.....s ArcimDesc=ArcimDesc_" "_$zd(oeoriSttDat,3)_" "_$zt(oeoriSttTim,2)
				.....s value=times_"次日期,"_ArcimDesc_" "
			....e  i typeCat="Antibiotics" d  //抗生素DDD值
				.....;s tmpValue=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),1)),"^",2) ;医嘱名称
				.....;i (oeoriSub=719) s ^dhctmpmfc(bpaId,oeordId,oeoriSub,arcimId,oeoriSttDate)="Antibiotics"_"/"_##class(web..DHCClinicCom)..GetDDD(arcimId)
				.....;s value=value+(doseQty/##class(web..DHCClinicCom)..GetDDD(arcimId))
				.....s arcicOrderType=##class(web.DHCClinicCom).GetOrdSubCatType(oeordId_"||"_oeoriSub)
				.....q:(arcicOrderType'="R") //非药品退出
				.....s oeoreSub=0
				.....f  s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)) q:(oeoreSub="")  d
					......q:'$g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub))								
					......s exStDate=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",1)
					......s exStTime=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",2)								
					......q:(oeoriEndDate'="")&&(exStDate>oeoriEndDate)
					......q:(oeoriEndDate'="")&&(oeoriEndTime'="")&&(exStDate=oeoriEndDate)&&(exStTime>oeoriEndTime)
					......s dddQty=$p(##class(web.DHCClinicCom).GetDDD(arcimId),"^",1)
					......s phQtyOrd=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",5)
					......q:('(phQtyOrd>0))||('(dddQty>0))
					......
					......s arcimDr=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
					......s arcimPHCDFDR=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),1)),"^",12)
					......q:'$o(^PHCD(+arcimPHCDFDR,"DF",$p(arcimPHCDFDR,"||",2),""))
					......s formDoseEquiv=$o(^PHCD(+arcimPHCDFDR,"DF",$p(arcimPHCDFDR,"||",2),"EQ",0))
					......q:formDoseEquiv=""
					......s eqQty=$p($g(^PHCD(+arcimPHCDFDR,"DF",$p(arcimPHCDFDR,"||",2),"EQ",formDoseEquiv)),"^",2)
					......;i (bpaId=10233) s ^dhctmpmfc(bpaId,oeordId,oeoriSub,oeoreSub,arcimId,oeoriSttDate)=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),1)),"^",2)_"/"_phQtyOrd_"/"_eqQty_"/"_##class(web..DHCClinicCom)..GetDDD(arcimId)
					......i eqQty>0 d
					.......s pheqQtyValue=(phQtyOrd/eqQty)
					.......s value=value+(pheqQtyValue/dddQty)															
			....e  d
				.....;i dataField'="Times" s isFind=1 
				.....;e  s times=times+1 //$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",12)
				.....i dataField'="DateTime" d  //获取医嘱名称 add mfc 20140609								
					......i (dataField="NoteAndOriQty")||(dataField="OriQty")||(dataField="OriDecide") d //医嘱备注和剂量或者总剂量
						.......s oriNote=$g(^OEORD(oeordId,"I",+oeoriSub,"DEP",1))
						.......i oriNote="" s oriNote="未填写医嘱备注"
						.......s times=times+1										
					......e  d									    
						.......s oriNote=$g(^OEORD(oeordId,"I",+oeoriSub,"DEP",1))
						.......;i (icuaId=10196) s ^dhctmpmfc(icuaId,oeordId,oeoriSub,arcimId,oeoriSttDate)=arcicOrderType_"/"_oriNote							
						.......q:(oeoriNote'="")&&((oriNote)'[(oeoriNote))
						.......s ArcimDesc=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),1)),"^",2) ;医嘱名称
						.......//i regNo="C879608" w "测试7:"_ArcimDesc,!
						.......i (needNote'="")&&(ArcimDesc'="")&&(ArcimDesc=needNote) s value="是"															  													
						.......i (dataField'="Times")&&(dataField'="touchQty") d
						........s isFind=1
						........s value=ArcimDesc
						........;w value,!
						.......e  d
						........s times=times+1
						........i value="" s value=ArcimDesc_" "_$zd(oeoriSttDat,3)_" "_$zt(oeoriSttTim,2)
 						........e  s value=value_"#"_ArcimDesc_" "_$zd(oeoriSttDat,3)_" "_$zt(oeoriSttTim,2)
 						........s isFind=ifSingle
						........;i (icuciId=25)&&(icuciiSub=46)&&(icuaId=6963) s ^MfcTemp("2011")=times						
				.....e  d
					......s value=$zd(oeoriSttDat,3)_" "_$zt(oeoriSttTim,2) //获取医嘱时间 add mfc 20140609																						
					......s isFind=1
				.....//w "         times="_value_":"_times,!
			....i dataField="NoteAndOriQty" d //医嘱备注和剂量
				.....q:(oeoriNote'="")&&(oriNote'="未填写医嘱备注")&&((oriNote)'[(oeoriNote)) //区分备注名称医嘱
				.....q:(oeoriNote'="")&&(oriNote="未填写医嘱备注")&&(oeoriNote'="RBC") //未填写备注算入RBC
				.....i value="" s value=oriNote
				.....e  s value=value_"#"_oriNote
			....i dataField="OriQty" d //总剂量
				.....q:(oeoriNote'="")&&(oriNote'="未填写医嘱备注")&&((oriNote)'[(oeoriNote)) //区分备注名称医嘱
				.....q:(oeoriNote'="")&&(oriNote="未填写医嘱备注")&&(oeoriNote'="RBC") //未填写备注算入RBC							
				.....s value=value+doseQty
			....i dataField="OriDecide" d //下医嘱为是(把第一次的时间点记录下来)
				.....q:(oeoriNote'="")&&(oriNote'="未填写医嘱备注")&&((oriNote)'[(oeoriNote)) //区分备注名称医嘱
				.....q:(oeoriNote'="")&&(oriNote="未填写医嘱备注")&&(oeoriNote'="RBC") //未填写备注算入RBC							
				.....i oriNote'="" s value="是"
				.....;q:(LevelIf'="")&&(LevelIf'="1") //多个主项目时，选择LevelIf为1的项目执行	
	i dataField="Times" q times
	e  q value
}

/// 获取关联科室
/// w ##Class(web.DHCBPCom).GetLinkLocByLocId()
ClassMethod GetLinkLocByLocId(locId As %String = "") As %String
{
	q:locId="" ""
	q:$g(^DHCBPBedGroupWardLikeLoc(locId))="" locId
	s retLocId=$g(^DHCBPBedGroupWardLikeLoc(locId)) //床位组病区关联科室
	q retLocId
}

/// 获取关联就诊科室
/// w ##Class(web.DHCBPCom).GetLinkAdmLocByLocId()
ClassMethod GetLinkAdmLocByLocId(locId As %String = "") As %String
{
	q:locId="" ""
	q:$g(^DHCBPLinkAdmLoc(locId))="" locId
	s retLocId=$g(^DHCBPLinkAdmLoc(locId)) //科室关联就诊科室
	q retLocId
}

/// 是否启用叫号
/// w ##Class(web.DHCBPCom).GetIsVisServiceByLocId()
ClassMethod GetIsVisServiceByLocId(locId As %String = "") As %String
{
	q:locId="" "0"
	q:$g(^DHCBPIsVisServicem(locId))="" 0
	s ret=$g(^DHCBPIsVisServicem(locId)) //科室是否启用叫号接口程序
	q ret
}

/// 获取接诊时间
/// w ##Class(web.DHCBPCom).GetPatReceptionTime()
ClassMethod GetPatReceptionTime(locId As %String = "") As %String
{
	s locId=##Class(web.DHCBPCom).GetLinkLocByLocId(locId) //医生科室关联护士科室
	q:locId="" ""	
	q:$g(^DHCBPPatReceptionTime(locId))="" ""
	s receptionTime=$g(^DHCBPPatReceptionTime(locId)) //接诊时间
	q receptionTime
}

/// 获取可以提前签到的时间范围
/// w ##Class(web.DHCBPCom).GetPatAdvanceSignInTime()
ClassMethod GetPatAdvanceSignInTime(locId As %String = "") As %String
{
	s locId=##Class(web.DHCBPCom).GetLinkLocByLocId(locId) //医生科室关联护士科室
	q:locId="" ""	
	q:$g(^DHCBPPatAdvanceSignInTime(locId))="" ""
	s advanceSignInTime=$g(^DHCBPPatAdvanceSignInTime(locId)) //可以提前签到的时间(单位：秒)
	q advanceSignInTime
}

/// 根据卡号或者登记号获取相关病人信息
/// w ##Class(web.DHCBPCom).GetPatInfobyCardID("000000000224","1","2")
/// 入参：StrNO卡号或者登记号，Flag(1卡号、2登记号)，CardTypeID卡类型
ClassMethod GetPatInfobyCardID(StrNO As %String, Flag As %String = "1", CardTypeID As %String = "2") As %String
{
	q:StrNO="" ""
	s CFPAPMINo="",CFPAPMIDR="",CardTypeDr="",TypeDesc="",PatName=""
	w Flag,!
	if (Flag="1")  d	
	.s CFRowID=0
	.f  s CFRowID=$O(^DHCCARDi("CF",0,"CardNo",StrNO,CFRowID))  Q:CFRowID=""  d
	..s status=$p(^DHCCARD("CF",CFRowID),"^",10)
	..Q:status'="N"
	..s CFPAPMINo=$P($G(^DHCCARD("CF",CFRowID)),"^",6)
	..s CFPAPMIDR=$P($G(^DHCCARD("CF",CFRowID)),"^",4)
	..s CardTypeDr=$P($G(^DHCCARD("CF",CFRowID)),"^",16)
	..Q:((CardTypeID'="")&&(CardTypeDr'=CardTypeID))
	..s TypeDesc=$P(^DHCCARDTYPEDef(CardTypeDr),"^",2)
	..s PatName=$p($g(^PAPER(CFPAPMIDR,"ALL")),"^",1)
	else  if (Flag="2")  d
	.w Flag,!
	.s PAPMIRowId=$O(^PAPERi("PAPMI_PatNo",StrNO,0))
	.s CFRowID=0
	.f  s CFRowID=$O(^DHCCARDi("CF",0,"PAPMIDR",PAPMIRowId,CFRowID)) Q:CFRowID=""  d
	..s status=$p(^DHCCARD("CF",CFRowID),"^",10)
	..Q:status'="N"
	..s CFPAPMINo=$P($G(^DHCCARD("CF",CFRowID)),"^",6)
	..s CFPAPMIDR=$P($G(^DHCCARD("CF",CFRowID)),"^",4)
	..s CardTypeDr=$P($G(^DHCCARD("CF",CFRowID)),"^",16)
	..Q:((CardTypeID'="")&&(CardTypeDr'=CardTypeID))
	..s TypeDesc=$P(^DHCCARDTYPEDef(CardTypeDr),"^",2)
	..s PatName=$p($g(^PAPER(CFPAPMIDR,"ALL")),"^",1)
	q CFPAPMINo_"^"_CFPAPMIDR_"^"_CardTypeDr_"^"_TypeDesc_"^"_PatName
}

Query FindLocList(desc As %String, typeStr As %String = "W^E^D^OP^EM^CL") As %Query(ROWSPEC = "Id:%String,Desc:%String") [ SqlProc ]
{
}

ClassMethod FindLocListExecute(ByRef qHandle As %Binary, desc As %String, typeStr As %String = "W^E^D^OP^EM^CL") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s desc=$$ALPHAUP^SSUTIL4(desc)
	/*
	s ctlocId=0,i=0
	f  s ctlocId=$o(^CTLOC(0,"Desc",desc,ctlocId)) q:ctlocId=""  d
	.b 	
		.s ctlocDesc=$p(^CTLOC(ctlocId),"^",2)
		.s ctloctype=$p(^CTLOC(ctlocId),"^",13)
		.q:"^"_typeStr_"^"'[("^"_ctloctype_"^")
		.//q:(desc'="")&&(ctlocDesc'[desc)
		.q:(desc'="")&($$ALPHAUP^SSUTIL4(##class(web.DHCClinicCom).GetChinaChar(ctlocDesc))'[desc)
		.s ctlocStatDate=$p(^CTLOC(ctlocId),"^",24) //开始日期过滤
		.q:(ctlocStatDate'="")&&(ctlocStatDate>+$h)
		.s ctlocEndDate=$p(^CTLOC(ctlocId),"^",25) //结束日期过滤
		.q:(ctlocEndDate'="")&&(ctlocEndDate<+$h)
		.Do OutputRow6 
	*/	
		&sql(declare ctloc cursor  for select distinct CTLOC_RowId,CTLOC_Desc from SQLUser.CT_LOC WHERE ((UPPER(CTLOC_ContactName)[:desc or UPPER(CTLOC_Desc)[:desc) and (CTLOC_DateActiveFrom<=+$h) and ((CTLOC_DateActiveTo is null) or ((CTLOC_DateActiveTo is not null) and (CTLOC_DateActiveTo>=+$h)))))
		&sql(open ctloc)
		f  &sql(fetch ctloc into :ctlocId,:ctlocDesc) q:SQLCODE  d
			
			.Do OutputRow6	 	
		&sql(close ctloc)
		
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow6
	set Data=$lb(ctlocId,ctlocDesc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod FindLocListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLocListExecute ]
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

ClassMethod FindLocListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindLocListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator: mfc
/// CreatDate: 2018-10-25
/// Description: 获取全部速度单位 
/// Table：DHC_BPC_SpeedUnit
/// Return：速度单位ID:Id,速度单位代码:Code,速度单位名称:Desc
/// d ##class(%ResultSet).RunQuery("web.DHCBPCom","FindSUnitList")
Query FindSUnitList() As %Query(ROWSPEC = "Id:%String,Code:%String,Desc:%String") [ SqlProc ]
{
}

ClassMethod FindSUnitListExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	s Id=""
	f  s Id=$o(^DHCBPC("SUnit",Id)) q:(Id="")  d
	.s Code=$p($g(^DHCBPC("SUnit",Id)),"^",1)
	.s Desc=$p($g(^DHCBPC("SUnit",Id)),"^",2)
	.d OutputUomRow
	s qHandle=$lb(0,repid,0)
	q $$$OK

OutputUomRow
	s Data=$lb(Id,Code,Desc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod FindSUnitListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSUnitListExecute ]
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

ClassMethod FindSUnitListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSUnitListExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

// w ##Class(web.DHCBPCom).getOutPatDataCollect("112560","weight")

/// bpaId透析记录arrangeId;code:对应自助采集程序的代码,在SystemSet.xml文件中
/// 获取自助采集到的体重、血压数据，提供给透析前、后
ClassMethod getOutPatDataCollect(bpaId, code) As %String
{
	q:bpaId="" ""
	q:code="" ""
	s bpprId=$lg(^DHCBPArrange(bpaId),1)
	s papmiId=$lg(^DHCBPPatRegister(bpprId),1)
	s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	//w regNo,!
	s bpaStartOperTime=$lg(^DHCBPArrange(bpaId),105)
	//w bpaStartOperTime,!
	s bpaDate=$lg(^DHCBPArrange(bpaId),4)
	s date=bpaDate,CollectId="",Value=""
	f  s CollectId=$o(^User.DHCBPOUTPatDataCollectI("Value"," "_regNo,date,CollectId)) q:CollectId=""  d
	.s codeValue=$li(^User.DHCBPOUTPatDataCollectD(CollectId),3)
	.//b ;01
	.q:codeValue'=code
	.s time=$li(^User.DHCBPOUTPatDataCollectD(CollectId),5)
	.;w CollectId_"/"_time,!
	.q:(bpaStartOperTime'="")&&(time<bpaStartOperTime)	
	.//b ;02
	.s Value=$li(^User.DHCBPOUTPatDataCollectD(CollectId),6)
	.//i code="Weight" s Value=$p(Value,"Kg",1)
	q Value
}

ClassMethod GetCtcpUserId(ctcpId) As %String
{
	q:ctcpId="" ""
	s userId=$o(^SSU("SSUSR",0,"CTPCP",ctcpId,""))
	q:userId="" ""
	q userId
}

}
