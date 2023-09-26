/// 手麻4.0接口服务
Class DHCCL.Implement.ANOld.OperArrangeService Extends (%RegisteredObject, DHCCL.Interface.AN.IOperInfoService)
{

/// 获取手术信息
Method GetOperInfoByEpisodeID(EpisodeID As %String) As %GlobalCharacterStream
{
	set retStream=##class(%GlobalCharacterStream).%New()
    do retStream.Rewind()
    
    do retStream.Write("<Response>")
	
	set rset=##class(%ResultSet).%New("DHCCL.Implement.ANOld.OperArrangeService:FindOperArrangeList")
	do rset.Execute("","",EpisodeID)
	while (rset.Next()) 
	{
		set opaId=rset.Get("opaId") 
		set operInfoObj=##class(DHCCL.DTO.AN.OperInfo).%New()
		set operInfoObj.RowId=opaId
		set operInfoObj.OPAID=opaId
		set operInfoObj.EpisodeID=rset.Get("admId")
		set operInfoObj.ExtAnaestID=rset.Get("anaId") 
		set operInfoObj.PatName=rset.Get("patName")
		set operInfoObj.PatGender=rset.Get("sex")
		set operInfoObj.PatAge=rset.Get("age") 
		set operInfoObj.PatDOB=rset.Get("birth") 
		set operInfoObj.RegNo=rset.Get("regNo") 
		set operInfoObj.MedcareNo=rset.Get("medcareNo")
		set operInfoObj.PatientID=rset.Get("papmiId") 
		set operInfoObj.PatDeptID=rset.Get("curLocId")
		set operInfoObj.PatDeptDesc=rset.Get("curLocDesc")
		set operInfoObj.PatWardID=rset.Get("curWardId")
		set operInfoObj.PatWardDesc=rset.Get("curWardDesc")  
		set operInfoObj.PatBedID=rset.Get("bedId")
		set operInfoObj.PatBedCode=rset.Get("bedCode")
		set operInfoObj.AppCareProvID=rset.Get("AppCtcpId") 
		set operInfoObj.AppCareProvDesc=rset.Get("AppCtcpDesc")
		set operInfoObj.OperDeptID=rset.Get("OperLocId")
		set operInfoObj.OperDeptDesc=rset.Get("OperLocDesc")
		set operInfoObj.SourceType=rset.Get("SourceTypeCode")
		set operInfoObj.SourceTypeDesc=rset.Get("SourceTypeDesc")
		set operInfoObj.Status=rset.Get("Status")
		set operInfoObj.StatusDesc=rset.Get("StatusDesc")
		set operInfoObj.StatusCode=rset.Get("Status")
		set operInfoObj.OperDate=rset.Get("OperDate")
		set operInfoObj.OperTime=rset.Get("OperTime")
		set operInfoObj.OperDuration=rset.Get("EstiOperDuration")
		set operInfoObj.Anaesthesia=rset.Get("NeedAnaesthetist")
		set operInfoObj.PrevAnaMethod=rset.Get("AnaMethodId")
		set operInfoObj.PrevAnaMethodDesc=rset.Get("AnaMethodDesc")
		set operInfoObj.PlanSeq=rset.Get("SeqNo")
		set operInfoObj.PrevDiagnosis=rset.Get("PreopDiag")
		set operInfoObj.OperDesc=rset.Get("OperDesc")
		set operInfoObj.SurgeonDesc=rset.Get("SurgeonDesc")
		set operInfoObj.AsstDesc=rset.Get("AsstDesc")
		set operInfoObj.BodySite=rset.Get("BodySiteDesc")
		set operInfoObj.OperPosition=rset.Get("PositionDesc")
		set operInfoObj.IsoOperation=rset.Get("Isolated")
		set operInfoObj.ECC=rset.Get("ExCirculation")
		set operInfoObj.TransAutoBlood=rset.Get("UseSelfBlood")
		set operInfoObj.PrepareBlood=rset.Get("PrepareBlood")
		set operInfoObj.OperRequirement=rset.Get("OpMemo")
		set operInfoObj.BloodType=rset.Get("BloodTypeDesc")
		set operInfoObj.RHType=rset.Get("RHBloodType")
		set operInfoObj.HbsAg=rset.Get("PATestHBsAg")
		set operInfoObj.HcvAb=rset.Get("PATestHCVAb")
		set operInfoObj.HivAb=rset.Get("PATestHivAb")
		set operInfoObj.OperRoom=rset.Get("OpRoomId")
		set operInfoObj.RoomDesc=rset.Get("OpRoomDesc")
		set operInfoObj.OperSeq=rset.Get("SeqNo")
		set operInfoObj.ScrubNurse=rset.Get("ScrubNurseCtcpId")
		set operInfoObj.ScrubNurseDesc=rset.Get("ScrubNurseCtcpDesc")
		set operInfoObj.CircualNurse=rset.Get("CirculNurseCtcpId")
		set operInfoObj.CircualNurseDesc=rset.Get("CirculNurseCtcpDesc")
		set operInfoObj.WardBed=rset.Get("bedCode")
		set operInfoObj.TheatreInDT=rset.Get("TheatreInDT")
		set operInfoObj.TheatreOutDT=rset.Get("TheatreOutDT")
		set operInfoObj.OperStartDT=rset.Get("operStartDT")
		set operInfoObj.OperFinishDT=rset.Get("operFinishDT")
		set operInfoObj.AnaStartDT=rset.Get("anaStartDT")
		set operInfoObj.AnaFinishDT=rset.Get("anaFinishDT")
		set operInfoObj.AreaInDT=rset.Get("areaInDT")
		set operInfoObj.AreaOutDT=rset.Get("areaOutDT")
		set operInfoObj.PACUInDT=rset.Get("opaPACUInDT")
		set operInfoObj.PACUOutDT=rset.Get("opaPACUOutDT")
		set operInfoObj.OperDateTime=rset.Get("OperDateTime")
		set operInfoObj.AnaestID=rset.Get("anaId")
		set operInfoObj.AnaMethod=rset.Get("AnaMethodId")
		set operInfoObj.AnaMethodDesc=rset.Get("AnaMethodDesc")
		set operInfoObj.AnaExpert=rset.Get("AnaSupervisorCtcpId")
		set operInfoObj.AnaExpertDesc=rset.Get("AnaSupervisorCtcpDesc")
		set operInfoObj.Anesthesiologist=rset.Get("AnaesthetistId")
		set operInfoObj.AnesthesiologistDesc=rset.Get("AnaesthetistDesc")
		set operInfoObj.AnaAssistant=rset.Get("AnaestAssistantId")
		set operInfoObj.AnaAssistantDesc=rset.Get("AnaestAssistantDesc")
		set operInfoObj.BodySiteDesc=rset.Get("BodySiteDesc")
		set operInfoObj.OperPositionDesc=rset.Get("PositionDesc")

		set operListSet=##class(%ResultSet).%New("DHCCL.Implement.ANOld.OperArrangeService:FindOperationDetail")
		do operListSet.Execute(opaId)
		while (operListSet.Next()) 
		{
			set operListObj=##class(DHCCL.DTO.AN.OperationList).%New()
			set operListObj.RowId=opaId
			set operListObj.Operation=operListSet.Get("OperId")
			set operListObj.OperationDesc=operListSet.Get("OperDesc")
			set operListObj.OperClass=operListSet.Get("OperLevelId")
			set operListObj.OperClassDesc=operListSet.Get("OperLevelDesc")
			set operListObj.BladeType=operListSet.Get("BladeTypeId")
			set operListObj.BladeTypeDesc=operListSet.Get("BladeTypeDesc")
			set operListObj.OperNote=operListSet.Get("operNote")
			do operInfoObj.OperationDetail.Insert(operListObj)
		}
		
        set xml=##class(%GlobalCharacterStream).%New()
		set ret=operInfoObj.XMLExportToStream(.xml,"OperInfo")
		do retStream.CopyFrom(xml)
	}
	
	do retStream.Write("</Response>")
	quit retStream
}

/// 获取质控指标信息
Method GetAnaQualityControl(startDate As %String, endDate As %String, anaDeptId As %String, userId As %String, Version As %String = "") As %GlobalCharacterStream
{
	quit ""
}

/// d ##class(%ResultSet).RunQuery("DHCCL.Implement.ANOld.OperArrangeService","FindOperArrangeList","","","29")
Query FindOperArrangeList(stdate As %String, enddate As %String, EpisodeID As %String) As %Query(ROWSPEC = "opaId,admId,papmiId,anaId,patName,regNo,sex,birth,age,medcareNo,curLocId,curLocDesc,curWardId,curWardDesc,bedId,bedCode,secretCode,patLevel,Status,StatusDesc,OperLocId,OperLocDesc,OperDate,OperTime,EstiOperDuration,AppCtcpId,AppCtcpDesc,SourceTypeCode,SourceTypeDesc,NeedAnaesthetist,PreopDiag,PreDiscussDate,SurgeonId,SurgeonDesc,AssDesc,assistantFirstCtcpId,assistantFirstCtcpDesc,assistantSecondCtcpId,assistantSecondCtcpDesc,assistantThirdCtcpId,assistantThirdCtcpDesc,assOtherId,assOtherDesc,OperId,OperDesc,OpMemo,BodySiteId,BodySiteDesc,PositionId,PositionDesc,Isolated,ExCirculation,UseSelfBlood,PrepareBlood,BloodTypeId,BloodTypeDesc,RHBloodType,PATestHBsAg,PATestHCVAb,PATestHivAb,PATestOther,AnaesthetistId,AnaesthetistDesc,AnaestAssistantId,AnaestAssistantDesc,ORAnaNurseCtcpId,ORAnaNurseCtcpDesc,AnaMethodId,AnaMethodDesc,AnaSupervisorCtcpId,AnaSupervisorCtcpDesc,AnDocNote,ASAId,ASADesc,OpRoomId,OpRoomDesc,SeqNo,ArrangeDate,ArrangeTime,NurseShift,ScrubNurseCtcpId,ScrubNurseCtcpDesc,ShiftScrubNurseCtcpId,ShiftScrubNurseCtcpDesc,CirculNurseCtcpId,CirculNurseCtcpDesc,ShiftCirculNurseCtcpId,ShiftCirculNurseCtcpDesc,ScrubNurseNote,CirculNurseNote,OpNurseNote,OpNurseMemo,TheatreInDT,TheatreOutDT,operStartDT,operFinishDT,areaInDT,areaOutDT,anaStartDT,anaFinishDT,opaPACUInDT,opaPACUOutDT,OperDateTime") [ SqlProc ]
{
}

ClassMethod FindOperArrangeListExecute(ByRef qHandle As %Binary, stdate As %String, enddate As %String, EpisodeID As %String) As %Status
{
	
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	
	set SubNode="SDate"
	if (EpisodeID'="")
	{
		s opaId=""
		f  s opaId=$O(^DHCANOPArrange(0,"Adm",EpisodeID,opaId)) q:opaId=""  d
		.d GetOperArrangeInfo(opaId)
	}
	else
	{
		s stdate=##class(web.DHCClinicCom).ConvertToDateH(stdate)
		s enddate=##class(web.DHCClinicCom).ConvertToDateH(enddate)
		f date=stdate:1:enddate
		{
			s opaId=""
			f  s opaId=$O(^DHCANOPArrange(0,SubNode,date,opaId)) q:opaId=""  d
			.d GetOperArrangeInfo(opaId)
		}
	}
	
	s qHandle=$lb(0,repid,0)
	q $$$OK
	
GetOperArrangeInfo(opaId)
	set admId=$piece(^DHCANOPArrange(opaId),"^",1)
	set anaId=$P(^DHCANOPArrange(opaId),"^",2) ;手术麻醉Id
	set anaSub=$piece(anaId,"||",2)
	
	//病人基本信息
	s papmiId=$p($g(^PAADM(admId)),"^",1)
	s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	s sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
	s birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
	s age=##class(web.DHCBillInterface).GetPapmiAge(papmiId,admId)
	s medcareNo=##class(web.DHCWMRService).IGetMrNoByEpisodeID(admId , .ErrMsg)
	s curLocId=$p($g(^PAADM(admId)),"^",4)
	s curLocDesc=$P(^CTLOC(curLocId),"^",2)
	s curWardId=$p($g(^PAADM(admId)),"^",70)
	s curWardDesc=$P($G(^PAWARD(curWardId)),"^",2)
	s bedId=$p($g(^PAADM(admId)),"^",73)
	s bedSub=$p(bedId,"||",2)
	s bedCode="" 
	i bedSub'="" s bedCode=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)
	s secretCode="",patLevel=""
	s SecretLevel=##class(web.DHCClinicCom).GetPatLevelByPapmiId(admId)
	i SecretLevel'="" s secretCode=$p($g(SecretLevel),"^",4),patLevel=$p($g(SecretLevel),"^",2)
	
	//手术状态
	set Status=$P(^DHCANOPArrange(opaId),"^",27)
	set StatusDesc=""
	i Status="A" s StatusDesc="申请"
	i Status="D" s StatusDesc="拒绝"
	i Status="R" s StatusDesc="安排" 
	i Status="N" s StatusDesc="非预约"
	i Status="I" s StatusDesc="术中"
	i Status="P" s StatusDesc="恢复室"
	i Status="L" s StatusDesc="术毕"
	i Status="F" s StatusDesc="完成"
	i Status="" s StatusDesc="未审核"
	
	//手术室
	set OperLocId=$P($g(^OR(admId,"ANA",anaSub,"OP",1)),"^",10)
	set OperLocDesc=""
	if OperLocId'="" set OperLocDesc=$P(^CTLOC(OperLocId),"^",2)
	
	//手术日期时间
	set OperDate=$P(^DHCANOPArrange(opaId),"^",14)
	set OperTime=$P(^DHCANOPArrange(opaId),"^",15)
	if OperDate'="" set OperDate=$zd(OperDate,3)
	if OperTime'="" set OperTime=$zt(OperTime)
	
	//预计手术时间
	set EstiOperDuration=$P(^DHCANOPArrange(opaId),"^",37)
	
	//医师
	set AppCtcpId=$P(^DHCANOPArrange(opaId),"^",6)
	set AppCtcpDesc=##class(web.DHCANOPCom).GetNameById(AppCtcpId)
	
	//急诊
	set SourceTypeCode=$P(^OR(admId,"ANA",anaSub),"^",32)
	set SourceTypeDesc=""
	if SourceTypeCode="E" set SourceTypeDesc="急诊"
	if SourceTypeCode="B" set SourceTypeDesc="择期"
	
	//麻醉否
	set NeedAnaesthetist=$P(^DHCANOPArrange(opaId),"^",44)
	
	//术前诊断
	set PreopDiag=##class(DHCCL.Implement.ANOld.OperArrangeService).GetPreDiagDesc(opaId)
	
	//术前讨论日期
	set PreDiscussDate=$P(^DHCANOPArrange(opaId),"^",38)
	
	//手术医师
	set SurgeonId=$P(^OR(admId,"ANA",anaSub,"OP",1),"^",8)
	set SurgeonDesc=##class(web.DHCANOPCom).GetNameById(SurgeonId)
	
	//手术助手
	s AssDesc=""
	s assistantFirstCtcpId="",assistantFirstCtcpDesc=""  //一助
	s assistantSecondCtcpId="",assistantSecondCtcpDesc="" //二助
	s assistantThirdCtcpId="",assistantThirdCtcpDesc=""  //三助
	s assOtherId="",assOtherDesc="" //其他助手
	s p=0
	s anaopSub=1
	s as=0 f  s as=$O(^OR(admId,"ANA",anaSub,"OP",anaopSub,"ASS",as)) q:(as="")!(p=6)  d
		.s asdr=$P(^OR(admId,"ANA",anaSub,"OP",anaopSub,"ASS",as),"^",1)
		.q:asdr=""
		.s p=p+1
		.i p=1 s assistantFirstCtcpId=$g(asdr)  ;一助
		.i assistantFirstCtcpId'="" s assistantFirstCtcpDesc=##class(web.DHCClinicCom).GetNameById(assistantFirstCtcpId)
		.i p=2 s assistantSecondCtcpId=$g(asdr) ;二助
		.i assistantSecondCtcpId'="" s assistantSecondCtcpDesc=##class(web.DHCClinicCom).GetNameById(assistantSecondCtcpId)
		.i p=3 s assistantThirdCtcpId=$g(asdr)  ;三助
		.i assistantThirdCtcpId'="" s assistantThirdCtcpDesc=##class(web.DHCClinicCom).GetNameById(assistantThirdCtcpId)
		.i p>3 d
		..i assOtherId'="" s assOtherId=assOtherId_"|"_asdr
		..e  s assOtherId=asdr
		..s assOtherDesc=$g(assOther)_","_$P(^CTPCP(asdr,1),"^",2)  ;其他助手
		.i AssDesc="" s AssDesc=##class(web.DHCClinicCom).GetNameById(asdr)
		.e  s AssDesc=AssDesc_","_##class(web.DHCClinicCom).GetNameById(asdr)
		
	set OperId="",OperDesc=""  //拟施手术
	set operDetailSet=##class(%ResultSet).%New("DHCCL.Implement.ANOld.OperArrangeService:FindOperationDetail")
	do operDetailSet.Execute(opaId)
	while (operDetailSet.Next()) 
	{
		if OperId="" set OperId=operDetailSet.Get("OperId") 
		else  set OperId=OperId_","_operDetailSet.Get("OperId") 
		
		if OperDesc="" set OperDesc=operDetailSet.Get("OperDesc") 
		else  set OperDesc=OperDesc_","_operDetailSet.Get("OperDesc") 
	}
	
	set OpMemo=$P(^DHCANOPArrange(opaId),"^",19)
	
	//手术部位
	set BodySiteId=$P(^OR(admId,"ANA",anaSub,"OP", 1),"^",24) 
	set BodySiteDesc=""
	if BodySiteId'="" set BodySiteDesc=$p($g(^OEC("BODS",BodySiteId)),"^",2)
	
	//手术体位
	set PositionId=$P($G(^OR(admId,"ANA",anaSub,"OP",1,"POS",1)),"^")
	set PositionDesc=""
	if PositionId'="" set PositionDesc=$P($G(^ORC("OPPOS",PositionId)),"^",2)
	
	//隔离
	set Isolated=$P(^DHCANOPArrange(opaId),"^",10)
	
	//是否体外循环
	set ExCirculation=$P(^DHCANOPArrange(opaId),"^",36)
	
	//自体血回输
	set UseSelfBlood=$P(^DHCANOPArrange(opaId),"^",34)
	
	//是否备血
	set PrepareBlood=$P(^DHCANOPArrange(opaId),"^",33)
	
	//血型
	set BloodTypeId=$P(^DHCANOPArrange(opaId),"^",11)
	set BloodTypeDesc=""
	if BloodTypeId'="" set BloodTypeId=$P($G(^PAC("BLDT",BloodTypeId)),"^",2)
	
	//RH血型
	set RHBloodType=$P(^DHCANOPArrange(opaId),"^",25)
	
	//HbsAg
	set PATestHBsAg=$P($g(^DHCANOPArrange(opaId, "PALab")),"^",29)
	
	//HCV_Ab
	set PATestHCVAb=$P($g(^DHCANOPArrange(opaId, "PALab")),"^",34)
	
	//Hiv_Ab
	set PATestHivAb=$P($g(^DHCANOPArrange(opaId, "PALab")),"^",36)
	
	//其他检验结果
	set PATestOther=$P($g(^DHCANOPArrange(opaId, "PALab")),"^",2)
	
	//麻醉主治医师
	set AnaesthetistId=$P($g(^OR(admId,"ANA",anaSub)),"^",6)
	set AnaesthetistDesc=##class(web.DHCANOPCom).GetNameById(AnaesthetistId)
	
	//麻醉助手
	set AnaestAssistantId="",AnaestAssistantDesc=""
	s ass=0 f  s ass=$o(^OR(admId,"ANA",anaSub,"OP",1,"ANASS",ass)) q:ass=""  d    
	.s mzzsdr=$p($g(^OR(admId,"ANA",anaSub,"OP",1,"ANASS",ass)),"^",1)
	.q:mzzsdr=""
	.i AnaestAssistantId="" s AnaestAssistantId=mzzsdr
	.e  s AnaestAssistantId=AnaestAssistantId_"|"_mzzsdr
	.i AnaestAssistantDesc="" s AnaestAssistantDesc=##class(web.DHCANOPCom).GetNameById(mzzsdr)
	.e  s AnaestAssistantDesc=AnaestAssistantDesc_","_##class(web.DHCANOPCom).GetNameById(mzzsdr)
	
	//麻醉护士
	s ORAnaNurseCtcpId=$P(^OR(admId,"ANA",anaSub),"^",8)
	s ORAnaNurseCtcpDesc=##class(web.DHCClinicCom).GetNameById(ORAnaNurseCtcpId)
	
	//麻醉方法
	s AnaMethodId=$P(^OR(admId,"ANA",anaSub),"^",5)
	s AnaMethodDesc=""
	f i=1:1:$l(AnaMethodId,"|") d
		.s anmetId=$p(AnaMethodId,"|",i)
		.q:anmetId=""
		.i AnaMethodDesc="" s AnaMethodDesc=$p($g(^ORC("ANMET",anmetId)),"^",2)
		.e  s AnaMethodDesc=AnaMethodDesc_"^"_$p($g(^ORC("ANMET",anmetId)),"^",2)
		
	//麻醉指导
	s AnaSupervisorCtcpId=$P(^OR(admId,"ANA",anaSub),"^",7)
	s AnaSupervisorCtcpDesc=##class(web.DHCClinicCom).GetNameById(AnaSupervisorCtcpId)
	
	//麻醉医生备注
	s AnDocNote=$P($G(^DHCANOPArrange(opaId)),"^",43)
	
	//ASA分级
	s ASAId=$P(^OR(admId,"ANA",anaSub),"^",26)
	s ASADesc=""
	i ASAId'="" s ASADesc=$P(^ORC("ASA",ASAId),"^",2)
	
	//手术间
	s OpRoomId=$P(^DHCANOPArrange(opaId),"^",20)
	s OpRoomDesc=""
	i OpRoomId'="" s OpRoomDesc=$p($g(^DHCANC("OPRoom",OpRoomId)),"^",2)
	
	//台次
	s SeqNo=$P(^DHCANOPArrange(opaId),"^",26)
	
	//安排时间
	s ArrangeDate=$P(^DHCANOPArrange(opaId),"^",7)
	i ArrangeDate'="" s ArrangeDate=$zd(ArrangeDate,3)
	s ArrangeTime=$P(^DHCANOPArrange(opaId),"^",8)
	i ArrangeTime'="" s ArrangeTime=$zt(ArrangeTime)
	
	//护士交班
	s NurseShift=$g(^DHCANARRAGE("jb",opaId))
	
	//器械护士，交器械护士 
	s ScrubNurseCtcpId="", ScrubNurseCtcpDesc=""
	s ShiftScrubNurseCtcpId="", ShiftScrubNurseCtcpDesc=""
	s xs=0 f  s xs=$O(^OR(admId,"ANA",anaSub,"OP",1,"SCN",xs)) q:(xs="")  d
		.i xc<20 d
		..s xsdr=$P(^OR(admId,"ANA",anaSub,"OP",1,"SCN",xs),"^",1)
		..q:xsdr=""
		..i ScrubNurseCtcpId="" s ScrubNurseCtcpId=xsdr
		..e  s ScrubNurseCtcpId=ScrubNurseCtcpId_"|"_xsdr
		..i ScrubNurseCtcpDesc="" s ScrubNurseCtcpDesc=##class(web.DHCANOPCom).GetNameById(xsdr)
		..e  s ScrubNurseCtcpDesc=ScrubNurseCtcpDesc_","_##class(web.DHCANOPCom).GetNameById(xsdr)
		.
		.i xc>20 d
		..s xsdr=$P(^OR(admId,"ANA",anaSub,"OP",1,"SCN",xs),"^",1)
		..q:xsdr=""
		..i ShiftScrubNurseCtcpId="" s ShiftScrubNurseCtcpId=xsdr
		..e  s ShiftScrubNurseCtcpId=ShiftScrubNurseCtcpId_"|"_xsdr
		..i ShiftScrubNurseCtcpDesc="" s ShiftScrubNurseCtcpDesc=##class(web.DHCANOPCom).GetNameById(xsdr)
		..e  s ShiftScrubNurseCtcpDesc=ShiftScrubNurseCtcpDesc_","_##class(web.DHCANOPCom).GetNameById(xsdr)
	
	//巡回护士，交巡回护士	
	s CirculNurseCtcpId="",CirculNurseCtcpDesc=""
	s ShiftCirculNurseCtcpId="",ShiftCirculNurseCtcpDesc=""
	s xc=0 f  s xc=$O(^OR(admId,"ANA",anaSub,"OP",1,"CIRN",xc)) q:(xc="")  d
		.i xc<20 d
		..s xchdr=$P(^OR(admId,"ANA",anaSub,"OP",1,"CIRN",xc),"^",1)
		..q:xchdr=""
		..i CirculNurseCtcpId="" s CirculNurseCtcpId=xchdr
		..e  s CirculNurseCtcpId=CirculNurseCtcpId_"|"_xchdr
		..i CirculNurseCtcpDesc="" s CirculNurseCtcpDesc=##class(web.DHCANOPCom).GetNameById(xchdr) 
		..e  s ShiftCirculNurseCtcpDesc=ShiftCirculNurseCtcpDesc_","_##class(web.DHCANOPCom).GetNameById(xchdr) 
		.
		.i xc>20 d
		..s xchdr=$P(^OR(admId,"ANA",anaSub,"OP",1,"CIRN",xc),"^",1)
		..q:xchdr=""
		..i ShiftCirculNurseCtcpId="" s ShiftCirculNurseCtcpId=xchdr
		..e  s ShiftCirculNurseCtcpId=ShiftCirculNurseCtcpId_"|"_xchdr
		..i ShiftCirculNurseCtcpDesc="" s ShiftCirculNurseCtcpDesc=##class(web.DHCANOPCom).GetNameById(xchdr) 
		.. e  s ShiftCirculNurseCtcpDesc=ShiftCirculNurseCtcpDesc_","_##class(web.DHCANOPCom).GetNameById(xchdr)
	
	//器械护士备注	
	s ScrubNurseNote=$p($G(^DHCANOPArrange(opaId)),"^",51)
	//巡回护士备注
	s CirculNurseNote=$p($G(^DHCANOPArrange(opaId)),"^",52)
	//备注
	s OpNurseNote=$g(^DHCANARRAGE("opreq",opaId))
	//注意事项
	s OpNurseMemo=$g(^DHCANARRAGE("note",opaId))
	
	//患者入手术间日期时间(手术开始日期时间)
	s TheatreInDate=$P(^OR(admId,"ANA",anaSub),"^",39)
	i TheatreInDate'="" s TheatreInDate=$zd(TheatreInDate,3)
	s TheatreInTime=$P(^OR(admId,"ANA",anaSub),"^",40)
	i TheatreInTime'="" s TheatreInTime=$zt(TheatreInTime)
	set TheatreInDT=""
	if (TheatreInDate'="")&&(TheatreInTime'="") set TheatreInDT=TheatreInDate_" "_TheatreInTime
	
	//患者离手术间日期时间(手术结束日期时间)
	s TheatreOutDate=$P(^OR(admId,"ANA",anaSub),"^",41)
	i TheatreOutDate'="" s TheatreOutDate=$zd(TheatreOutDate,3)
	s TheatreOutTime=$P(^OR(admId,"ANA",anaSub),"^",42)
	i TheatreOutTime'="" s TheatreOutTime=$zt(TheatreOutTime)
	set TheatreOutDT=""
	if (TheatreOutDate'="")&&(TheatreOutTime'="") set TheatreOutDT=TheatreOutDate_" "_TheatreOutTime
	
	//手术开始日期时间
	s operStartDate=$P(^OR(admId,"ANA",anaSub),"^",39)
	i operStartDate'="" s operStartDate=$zd(operStartDate,3)
	s operStartTime=$P(^OR(admId,"ANA",anaSub),"^",40)
	i operStartTime'="" s operStartTime=$zt(operStartTime)
	set operStartDT=""
	if (operStartDate'="")&&(operStartTime'="") set operStartDT=operStartDate_" "_operStartTime
	
	//手术结束日期时间
	s operFinishDate=$P(^OR(admId,"ANA",anaSub),"^",41)
	i operFinishDate'="" s operFinishDate=$zd(operFinishDate,3)
	s operFinishTime=$P(^OR(admId,"ANA",anaSub),"^",42)
	i operFinishTime'="" s operFinishTime=$zt(operFinishTime)
	set operFinishDT=""
	if (operFinishDate'="")&&(operFinishTime'="") set operFinishDT=operFinishDate_" "_operFinishTime
	
	//入手术间日期时间
	s areaInDate=$p(^OR(+anaId,"ANA",anaSub),"^",35)
	i areaInDate'="" s areaInDate=$zd(areaInDate,3)
	s areaInTime=$p(^OR(+anaId,"ANA",anaSub),"^",36)
	i areaInTime'="" s areaInTime=$zt(areaInTime)
	set areaInDT=""
	if (areaInDate'="")&&(areaInTime'="") set areaInDT=areaInDate_" "_areaInTime
	
	//离手术间日期时间
	s areaOutDate=$p(^OR(+anaId,"ANA",anaSub),"^",37)
	i areaOutDate'="" s areaOutDate=$zd(areaOutDate,3)
	s areaOutTime=$p(^OR(+anaId,"ANA",anaSub),"^",38)
	i areaOutTime'="" s areaOutTime=$zt(areaOutTime)
	set areaOutDT=""
	if (areaOutDate'="")&&(areaOutTime'="") set areaOutDT=areaOutDate_" "_areaOutTime
	
	//麻醉开始日期时间
	s anaStartDate=$p(^OR(+anaId,"ANA",anaSub),"^",2)
	i anaStartDate'="" s anaStartDate=$zd(anaStartDate,3)
	s anaStartTime=$p(^OR(+anaId,"ANA",anaSub),"^",3)
	i anaStartTime'="" s anaStartTime=$zt(anaStartTime)
	set anaStartDT=""
	if (anaStartDate'="")&&(anaStartTime'="") set anaStartDT=anaStartDate_" "_anaStartTime
	
	//麻醉结束日期时间
	s anaFinishDate=$p(^OR(+anaId,"ANA",anaSub),"^",29)
	i anaFinishDate'="" s anaFinishDate=$zd(anaFinishDate,3)
	s anaFinishTime=$p(^OR(+anaId,"ANA",anaSub),"^",4)
	i anaFinishTime'="" s anaFinishTime=$zt(anaFinishTime)
	set anaFinishDT=""
	if (anaFinishDate'="")&&(anaFinishTime'="") set anaFinishDT=anaFinishDate_" "_anaFinishTime
	
	//入恢复室日期时间
	s opaPACUInDate=$p($g(^DHCANOPArrange(opaId,"PACU")),"^",6)
	i opaPACUInDate'="" s opaPACUInDate=$zd(opaPACUInDate,3)
	s opaPACUInTime=$p($g(^DHCANOPArrange(opaId,"PACU")),"^",7)
	i opaPACUInTime'="" s opaPACUInTime=$zt(opaPACUInTime)
	set opaPACUInDT=""
	if (opaPACUInDate'="")&&(opaPACUInTime'="") set opaPACUInDT=opaPACUInDate_" "_opaPACUInTime
	
	//出恢复室日期时间
	s opaPACUOutDate=$p($g(^DHCANOPArrange(opaId,"PACU")),"^",8)
	i opaPACUOutDate'="" s opaPACUOutDate=$zd(opaPACUOutDate,3)
	s opaPACUOutTime=$p($g(^DHCANOPArrange(opaId,"PACU")),"^",9)
	i opaPACUOutTime'="" s opaPACUOutTime=$zt(opaPACUOutTime)
	set opaPACUOutDT=""
	if (opaPACUOutDate'="")&&(opaPACUOutTime'="") set opaPACUOutDT=opaPACUOutDate_" "_opaPACUOutTime
	
	//手术预计日期时间
	set OperDateTime=""
	if (OperDate'="")&&(OperTime'="") set OperDateTime=OperDate_" "_OperTime
	
	do OutputRow
	quit
	
	
OutputRow
	set Data=$lb(opaId,admId,papmiId,anaId,patName,regNo,sex,birth,age,medcareNo,curLocId,curLocDesc,curWardId,curWardDesc,bedId,bedCode,secretCode,patLevel,Status,StatusDesc,OperLocId,OperLocDesc,OperDate,OperTime,EstiOperDuration,AppCtcpId,AppCtcpDesc,SourceTypeCode,SourceTypeDesc,NeedAnaesthetist,PreopDiag,PreDiscussDate,SurgeonId,SurgeonDesc,AssDesc,assistantFirstCtcpId,assistantFirstCtcpDesc,assistantSecondCtcpId,assistantSecondCtcpDesc,assistantThirdCtcpId,assistantThirdCtcpDesc,assOtherId,assOtherDesc,OperId,OperDesc,OpMemo,BodySiteId,BodySiteDesc,PositionId,PositionDesc,Isolated,ExCirculation,UseSelfBlood,PrepareBlood,BloodTypeId,BloodTypeDesc,RHBloodType,PATestHBsAg,PATestHCVAb,PATestHivAb,PATestOther,AnaesthetistId,AnaesthetistDesc,AnaestAssistantId,AnaestAssistantDesc,ORAnaNurseCtcpId,ORAnaNurseCtcpDesc,AnaMethodId,AnaMethodDesc,AnaSupervisorCtcpId,AnaSupervisorCtcpDesc,AnDocNote,ASAId,ASADesc,OpRoomId,OpRoomDesc,SeqNo,ArrangeDate,ArrangeTime,NurseShift,ScrubNurseCtcpId,ScrubNurseCtcpDesc,ShiftScrubNurseCtcpId,ShiftScrubNurseCtcpDesc,CirculNurseCtcpId,CirculNurseCtcpDesc,ShiftCirculNurseCtcpId,ShiftCirculNurseCtcpDesc,ScrubNurseNote,CirculNurseNote,OpNurseNote,OpNurseMemo,TheatreInDT,TheatreOutDT,operStartDT,operFinishDT,areaInDT,areaOutDT,anaStartDT,anaFinishDT,opaPACUInDT,opaPACUOutDT,OperDateTime)
 	Set ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod FindOperArrangeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOperArrangeListExecute ]
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

ClassMethod FindOperArrangeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOperArrangeListExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// 获取术前诊断，多个诊断用','分割
ClassMethod GetPreDiagDesc(opaId As %String) As %String
{
	set EpisodeID=$piece(^DHCANOPArrange(opaId),"^",1)
	set anaId=$P(^DHCANOPArrange(opaId),"^",2) ;手术麻醉Id
	set anaSub=$piece(anaId,"||",2)
	
	set diag=""
	s subchl=0 f  s subchl=$O(^OR(EpisodeID,"ANA",anaSub,"OP",subchl)) q:(subchl="")  do
	.s predigdrS=$P(^OR(EpisodeID,"ANA",anaSub,"OP",subchl),"^",4) 	
	.f pi=1:1:$l(predigdrS,"|") d
	..s predigdr=$p(predigdrS,"|",pi)
	..i predigdr'=""  d
	...s preDiagDesc=$P(^MRC("ID",predigdr),"^",2)
	...s $p(diag,",",pi)=$G(preDiagDesc)
	..e  d
	...i $g(^OR(EpisodeID,"ANA",anaSub,"TXT",2))'="" d 
	....s diamen=$p(^OR(EpisodeID,"ANA",anaSub,"TXT",2),"|",pi)  
	....s $p(diag,",",pi)=$G(diamen) 
	
	quit diag
}

/// 获取拟施麻醉方法，返回:麻醉方法Id^麻醉方法描述，多个Id或描述用'|'隔开
ClassMethod GetPreAnaMethod(opaId As %String) As %String
{
	set EpisodeID=$piece(^DHCANOPArrange(opaId),"^",1)
	set anaId=$P(^DHCANOPArrange(opaId),"^",2) ;手术麻醉Id
	set anaSub=$piece(anaId,"||",2)
	
	set PrevAnaMethod=$P(^OR(EpisodeID,"ANA",anaSub),"^",5)
	set PrevAnaMethodDesc=""
	i PrevAnaMethod'=""
	{
		f i=1:1:$l(PrevAnaMethod,"|")
		{
			s anmetId=$p(PrevAnaMethod,"|",i)
			continue:anmetId=""
			s anmetDesc=$p($g(^ORC("ANMET",anmetId)),"^",2) ;麻醉方法描述
			i $P(anmetDesc,"-",2)'="" s anmetDesc=$P(anmetDesc,"-",2)
			i PrevAnaMethodDesc="" s PrevAnaMethodDesc=anmetDesc
			e  s PrevAnaMethodDesc=AnMethod_"|"_anmetDesc
		}		
	}
	
	quit PrevAnaMethod_"^"_PrevAnaMethodDesc
}

/// 获取手术详细信息
/// d ##class(%ResultSet).RunQuery("DHCCL.Implement.ANOld.OperArrangeService","FindOperationDetail",1)
Query FindOperationDetail(opaId As %String) As %Query(ROWSPEC = "OperId,OperDesc,OperNote,OperLevelId,OperLevelDesc,BladeTypeId,BladeTypeDesc")
{
}

ClassMethod FindOperationDetailExecute(ByRef qHandle As %Binary, opaId As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	set EpisodeID=$piece(^DHCANOPArrange(opaId),"^",1)
	set anaId=$P(^DHCANOPArrange(opaId),"^",2) ;手术麻醉Id
	set anaSub=$piece(anaId,"||",2)
	
	s anaopSub=0 f  s anaopSub=$O(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)) q:(anaopSub="")  do
	.//手术名称
	.s operId=$P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",6)
	.s operDesc=""
	.if operId'="" d
	..s operDesc=$P(^ORC("OPER",operId),"^",2)
	.//手术备注
	.set operNote=$G(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"REM",2))
	.//手术级别
	.s operLevelId=$p($g(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"DHC")),"^",1) 
	.s operLevelDesc=""
	.if operLevelId'="" set operLevelDesc=$p($g(^ORC("CATEG",operLevelId)),"^",2)
	.//切口类型
	.s bladeTypeId=$P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",9)
	.s bladeTypeDesc=""
	.if bladeTypeId'="" s bladeTypeDesc=$p(^ORC("BLDTP",bladeTypeId),"^",2)
	.do OutputRow
	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow
	set Data=$lb(operId,operDesc,operNote,operLevelId,operLevelDesc,bladeTypeId,bladeTypeDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindOperationDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOperationDetailExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {	
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindOperationDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOperationDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
