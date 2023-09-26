Import SQLUser

Class web.DHCANAdaptor Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// d ##class(web.DHCANAdaptor).GetANOperation("","","","","","","21")
/// d ##class(web.DHCANAdaptor).GetANOperation(64527,64558,"","","LF")
/// 手术麻醉通用查询接口，主要用于公司内部
/// 入参：按手术开始日期、结束日期、就诊号、申请手术科室、手术状态、手术室ID或描述、手术Id，起止日期和就诊号不能同时空
///    手术状态opaStatus：A:申请,D:拒绝,C:撤销,R:安排,I:术中,P:恢复室,L:离室,F:完成,S:拟日间。""是全部。可以用"ARF"这样的组合查询多个状态。
/// 返回：web.DHCANInterface.cls对象XML序列化流
ClassMethod GetANOperation(stdate As %String, enddate As %String, needEpisodeID As %String = "", ctlocId As %String = "", opastatus As %String = "", operLocCodeOrDesc As %String = "", opId As %String = "") As %GlobalCharacterStream
{

	s retStr=##class(%GlobalCharacterStream).%New()
	//b "start"
	d retStr.Rewind()
	d retStr.Write("<Response>")
	i stdate="" s stdate=""
	e  s stdate=##class(web.DHCClinicCom).ConvertToDateH(stdate)	
	i enddate="" s enddate=+$h
	e  s enddate=##class(web.DHCClinicCom).ConvertToDateH(enddate)
	s SubNode="SDate"
	//i IsAppT=1 s SubNode="AppDate"
	s userLocId= "", appType = ""
	s linkLocId=##Class(web.DHCClinicCom).GetLinkLocId(userLocId)
	s userLocIdStr=linkLocId_"^"_userLocId
	s userLocTyp=""
	i userLocId'="" s userLocTyp=$P(^CTLOC(userLocId),"^",13)
	s operLocCodeOrDesc=$$ALPHAUP^SSUTIL4(operLocCodeOrDesc)
	s operLocIdArg=""
	i operLocCodeOrDesc'="" d
	.s operLocIdArg=$o(^CTLOC(0,"Code",operLocCodeOrDesc,""))
	.i operLocIdArg=""  s operLocIdArg=$o(^CTLOC(0,"Desc",operLocCodeOrDesc,""))
	if (opId'="")
	{
		s opaId=opId
		d GetANOperationSingle
	}
	elseif (needEpisodeID'="")
	{   
		s opaId=""
		f  s opaId=$O(^DHCANOPArrange(0,"Adm",needEpisodeID,opaId)) q:opaId=""  d
		.d GetANOperationSingle
	}
	else
	{  
		f date=+stdate:1:+enddate
		{
			s opaId=""
			f  s opaId=$O(^DHCANOPArrange(0,SubNode,date,opaId)) q:opaId=""  d
				.d GetANOperationSingle  
		}
	}
	d retStr.Write("</Response>")
	q retStr
	
GetANOperationSingle
    ;b ;"1"
	s ANAStartDate="",anaStartTime="",ANAEndDate="",anaEndTime="",SurgeonStartDate="",surgeonStartTime="",SurgeonEndDate="",surgeonEndTime=""
	
	s yg=$P($g(^DHCANOPArrange(opaId,"PALab")),"^",29)			//OPA_PATestHBsAg  	免疫乙肝表面抗原
	s bg=$P($g(^DHCANOPArrange(opaId,"PALab")),"^",34)			//OPA_PATestHCVAb 	免疫丙型肝炎抗体
	s az=$P($g(^DHCANOPArrange(opaId,"PALab")),"^",35)			//OPA_PATestHivAb 	免疫艾滋病毒抗体
	s md=$P($g(^DHCANOPArrange(opaId,"PALab")),"^",36)			//OPA_PATestTPAb 	免疫梅毒
	s qt=$P($g(^DHCANOPArrange(opaId,"PALab")),"^",2)			//OPA_PATestOther	检其它阴阳性
	s yy=""
	i yg="阳性" s yy=yy_"乙肝阳性"_" "
	i bg="阳性" s yy=yy_"丙肝阳性"_" "
	i az="阳性" s yy=yy_"艾滋病阳性"_" "
	i md="阳性" s yy=yy_"梅毒阳性"_" "
	i qt="阳性" s yy=yy_"其他阳性"_" "
	s stat=$P(^DHCANOPArrange(opaId),"^",27)
	//b "staaaaa"
	q:(stat="")&(userLocTyp'="")&(userLocTyp'="E")
	q:(opastatus'="")&((opastatus'[stat)!(stat=""))
	s opaStatus=""  ;手术状态
	s statCode=""
	i stat="A" s opaStatus="申请"
	i stat="S" s opaStatus="拟日间"
	i stat="D" s opaStatus="拒绝"
	i stat="C" s opaStatus="撤销"
	i stat="R" s opaStatus="安排",statCode=0  
	i stat="N" s opaStatus="非预约"
	i stat="I" s opaStatus="术中"
	i stat="P" s opaStatus="恢复室"
	i stat="L" s opaStatus="术毕"
	i stat="F" s opaStatus="完成"
	i stat="" s opaStatus="未审核"
	i stat="V" s opaStatus="审核"
	q:(stat="N")&(appType="")
	q:(stat'="N")&(appType="RegNotApp")  
	s EpisodeID=$P(^DHCANOPArrange(opaId),"^",1)   ;就诊号
	q:EpisodeID=""
	q:(needEpisodeID'="")&(needEpisodeID'=EpisodeID)
	s opaAppDate=$P(^DHCANOPArrange(opaId),"^",3)     ;申请日期
	s opaAppDate=$zd(opaAppDate,3)
    s anaId=$P(^DHCANOPArrange(opaId),"^",2) ;手术麻醉Id
    s anaSub=$P(anaId,"||",2)
    s opStartDate=$P(^OR(EpisodeID,"ANA",anaSub),"^",39)
	s opsttime=$P(^OR(EpisodeID,"ANA",anaSub),"^",40)
	s opaEstiOperDuration=$P(^DHCANOPArrange(opaId),"^",37)
	s planOPAEndDateTime=""
	i opsttime'="" s planOPAEndDateTime=opsttime+planOPAEndDateTime
	i planOPAEndDateTime'="" s planOPAEndDateTime=$ZT(planOPAEndDateTime,2)
	s opaPlanStartDate=$P(^DHCANOPArrange(opaId),"^",14)
	s opaPlanStartTime=$P(^DHCANOPArrange(opaId),"^",15)
	s opaPlanStartDateTime=""
	i opaPlanStartDate'="" s opaPlanStartDateTime=$zd(opaPlanStartDate,3)_" "_$zt(opaPlanStartTime,2)
	i opStartDate="" s opStartDate=$P(^DHCANOPArrange(opaId),"^",14),opsttime=$P(^DHCANOPArrange(opaId),"^",15) ;手术开始日期
	i opStartDate'="" s opStartDate=$ZD(opStartDate,3)
	set DateFormat=$lg(^websys.ConfigurationD(1),10)
    if ((DateFormat="DMY")&&(opStartDate'="")) set opStartDate=$zd($zdh(opStartDate,3),,4)
	i opsttime'=""  s opsttime=$ZT(opsttime,2)
	s openddate=$P(^OR(EpisodeID,"ANA",anaSub),"^",41)
	s opendtime=$P(^OR(EpisodeID,"ANA",anaSub),"^",42)
	i openddate="" s openddate=$P(^DHCANOPArrange(opaId),"^",16),opendtime=$P(^DHCANOPArrange(opaId),"^",17)
	i openddate'="" s openddate=$zd(openddate,3)
	e  s openddate=""
	i opendtime'="" s opendtime=$zt(opendtime,2)
	e  s opendtime=""
	s opmem=$P(^DHCANOPArrange(opaId),"^",19)        	
	i openddate<opStartDate s openddate="",opendtime=""
	//q:openddate=""
	s opTime=opStartDate_" "_opsttime_"~"_openddate_" "_opendtime 
	s opaOpRoom=""
	s oproomdr=$P(^DHCANOPArrange(opaId),"^",20)
	i oproomdr'="" s opaOpRoom=$p($g(^DHCANC("OPRoom",oproomdr)),"^",2)
	s oprFloorId=""
	i oproomdr'="" s floorId=$p($g(^DHCANC("OPRoom",oproomdr)),"^",4)
	e  s floorId=""
	i floorId'="" s oprFloor=$P($G(^DHCANC("Floor",floorId)),"^",2)
	e  s oprFloor=""
	q:(oprFloorId'="")&(oprFloorId'=floorId)
	s opordno=$P(^DHCANOPArrange(opaId),"^",26)
	i (opordno'="")&(opordno=1) s opdate="8:30"   				;ck  091016
	s tmpDateStr=opordno
	i +tmpDateStr=0 s tmpDateStr=""
	e  s tmpDateStr=tmpDateStr-1
	s tmpDateStr="接台"_tmpDateStr
		.i sdate'=edate s tmpDateStr=$p(opStartDate," ")_" "_opaOpRoom_tmpDateStr
	i (opordno'="")&(opordno'=1) s opdate=tmpDateStr  	
		.s sortOpRoomDesc=opaOpRoom
		.i opaOpRoom="" s opaOpRoom="无"
	s sortOpaSeq=opordno
	i opordno="" s opordno="未排" 
	s arrUser=""
	s arrUserDr=$P(^DHCANOPArrange(opaId),"^",9)
	i arrUserDr'="" d
	.s arrUser=$p($g(^SSU("SSUSR",arrUserDr)),"^",2)
	s arrTime=$P(^DHCANOPArrange(opaId),"^",8)
	s arrDate=$P(^DHCANOPArrange(opaId),"^",7)
	s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
	;s BloodTypeId=$P($G(^MR(papmiId,"PRO",1)),"^",18)
	;s BloodTypeId=
	s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	s birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
	s medCareNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
	;s age=##class(web.UDHCANOPArrange).CalAge(birth,+$h)
	s age=##class(web.DHCBillInterface).GetPapmiAge(papmiId,EpisodeID)
	s sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
	s paadmtype=$p($g(^PAADM(EpisodeID)),"^",2)
	i paadmtype="I" s paadmtype="住院"
	i paadmtype="O" s paadmtype="门诊"
	s curWardId=$p($g(^PAADM(EpisodeID)),"^",70)
	s bedSub=$p($p($g(^PAADM(EpisodeID)),"^",73),"||",2)
	s bedCode="" i (bedSub'="")&(curWardId'="") s bedCode=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)
	s bedRoomDr="" i (bedSub'="")&(curWardId'="") s bedRoomDr=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",3)
	s bedRoom=""  i bedRoomDr'="" s bedRoom=$p($g(^PAROOM(bedRoomDr)),"^",2)
	s ward="" i curWardId'="" s ward=$p($P($G(^PAWARD(curWardId)),"^",2),"-",2)
	s anaSourceType=$P(^OR(EpisodeID,"ANA",anaSub),"^",32)   						;ANA_SourceType 急诊(E)/择期(B)
	i anaSourceType="E" s anaSourceTypeDesc="急诊"
	e  s anaSourceTypeDesc="择期"
	s dayOperFlag=""
	s anaOpSubTmp2="",inum=0,anaOpSubTmp=0
	f  s anaOpSubTmp2=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaOpSubTmp2)) q:(anaOpSubTmp2="")!(inum>0)  d
		.s inum=anaOpSubTmp2
		.i inum>0 s anaOpSubTmp=inum

	s dayOperFlag=$P($g(^OR(EpisodeID,"ANA",anaSub,"OP",anaOpSubTmp)),"^",22)
	s inRoomTime=$p(^OR(+anaId,"ANA",anaSub),"^",40)
	i ('(inRoomTime>$p($h,",",2))&&(inRoomTime'="")&&(stat="I")) s statCode=1
	s anaStartTime=##class(web.DHCANOrder).GetAnoEventSingle(opaId,"AnaStart",1,"Y","","T")
	s anaStartTime=##Class(web.DHCClinicCom).ConvertToTimeH(anaStartTime,"")
	i ('(anaStartTime>$p($h,",",2))&&(anaStartTime'="")) s statCode=2
	s surgeonStartTime=##class(web.DHCANOrder).GetAnoEventSingle(opaId,"OperStart",1,"Y","","T")
	s surgeonStartTime=##Class(web.DHCClinicCom).ConvertToTimeH(surgeonStartTime,"")
	i ('(surgeonStartTime>$p($h,",",2))&&(surgeonStartTime'="")) s statCode=3
	s surgeonEndTime=##class(web.DHCANOrder).GetAnoEventSingle(opaId,"OperEnd",-1,"Y","","T")
	s surgeonEndTime=##Class(web.DHCClinicCom).ConvertToTimeH(surgeonEndTime,"")
	i ('(surgeonEndTime>$p($h,",",2))&&(surgeonEndTime'="")) s statCode=4
	s anaEndTime=##class(web.DHCANOrder).GetAnoEventSingle(opaId,"AnaEnd",-1,"Y","","T")
	s anaEndTime=##Class(web.DHCClinicCom).ConvertToTimeH(anaEndTime,"")
	i ('(anaEndTime>$p($h,",",2))&&(anaEndTime'="")) s statCode=5
	s leaveRoomTime=##class(web.DHCANOrder).GetAnoEventSingle(opaId,"TheatreOut",-1,"Y","","T")
	s leaveRoomTime=##Class(web.DHCClinicCom).ConvertToTimeH(leaveRoomTime,"")
	s anoStr=##class(web.DHCANCom).GetAncoByCode(opaId,"TheatreOut","E")
	s anoNote=$p($g(anoStr),"^",10)
	i ('(leaveRoomTime>$p($h,",",2))&&(leaveRoomTime'="")&&(anoNote="PACU")) s statCode=6
	i ('(leaveRoomTime>$p($h,",",2))&&(leaveRoomTime'="")&&(anoNote'="PACU")) s statCode=7
	i (stat="F") d
	.i anoNote="PACU" s statCode=9
	.e  s statCode=8	
	s opaPACUInTime=leaveRoomTime
	s opaPACUOutTime=$P($g(^DHCANOPArrange(opaId,"PACU")),"^",9)
	s appLocId=$P($G(^DHCANOPArrange(opaId)),"^",54)  ;申请科室
	i appLocId="" s appLocId=$P(^PAADM(EpisodeID),"^",4)
	q:(ctlocId'="")&(ctlocId'=appLocId)
	;s opaAppLocDr=$P($G(^CTLOC(+appLocId)),"^",2)?谁改的，为什么？
	s opaAppLocDr=appLocId
	s opaAppLoc=$P($G(^CTLOC(+appLocId)),"^",2)
	s opaPatDeptDr=$P(^PAADM(EpisodeID),"^",4)   ;申请科室
	q:(ctlocId'="")&(ctlocId'=opaPatDeptDr)
	s patlocdesc=$P($g(^CTLOC(opaPatDeptDr)),"^",2)
	i $l(patlocdesc,"-")>1 s patLoc=$p(patlocdesc,"-",2)
	e  s patLoc=patlocdesc
	s anaOPPreopDiagDR="",diamen="",anaopBladeTypeId="",anaopBladeType="",diag=""
	s anaopSub=0 f  s anaopSub=$O(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)) q:(anaopSub="")  d 
		.s predigdrS=$P($g(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)),"^",4)   		;ANAOP_PreopDiag_DR 术前诊断字符串  zhangtao add
		.s num=$l(predigdrS,"|")
		.f pi=1:1:num d
		..s predigdr=$p(predigdrS,"|",pi)
		..i predigdr'=""  d
		...s anaOPPreopDiagDR=$P(^MRC("ID",predigdr),"^",2)
		..s $p(diag,",",pi)=$G(anaOPPreopDiagDR)
		..e  d
		...i $g(^OR(EpisodeID,"ANA",anaSub,"TXT",2))'="" d 
		....s diamen=$p(^OR(EpisodeID,"ANA",anaSub,"TXT",2),"|",pi)  
		....s $p(diag,",",pi)=$G(diamen)            //zhangtao add
	    .s curAnaopBladeTypeId=$P($g(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)),"^",9)
		.i curAnaopBladeTypeId'="" d
		..i anaopBladeTypeId'="" s anaopBladeTypeId=anaopBladeTypeId_"|",anaopBladeType=anaopBladeType_","
		..s anaopBladeTypeId=anaopBladeTypeId_curAnaopBladeTypeId
		..s anaopBladeType=anaopBladeType_$p($g(^ORC("BLDTP",+anaopBladeTypeId)),"^",2)
	s anadr=$P(^OR(EpisodeID,"ANA",anaSub),"^",6)        ; ANA_Anaesthetist_Dr
	i anadr'="" d
		.s anaDoctor=##class(web.DHCClinicCom).GetNameById(anadr)
	e  s anaDoctor="" 
	s anaDocCtcpId=$g(anadr)
	s anmthdr=$P(^OR(EpisodeID,"ANA",anaSub),"^",5) ;/麻醉方法相关
	s anaMethod=""        
	i anmthdr'="" d
		.s anmetNum=$l(anmthdr,"|")
		.f i=1:1:anmetNum d
			..s anmetId=$p(anmthdr,"|",i)
			..q:anmetId=""
			..s anmetDesc=$p($g(^ORC("ANMET",anmetId)),"^",2) ;麻醉方法描述
			..i $P(anmetDesc,"-",2)'="" s anmetDesc=$P(anmetDesc,"-",2)
			..i anaMethod="" s anaMethod=anmetDesc
			..e  s anaMethod=anaMethod_"^"_anmetDesc
	s anaopSub=0,anadoc1="",janadoc="",janadoc1="",operLocId="",bodsDesc=""
	f  s anaopSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)) q:anaopSub=""  d
		.q:$p($g(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)),"^",12)'="M" 
		.s operLocId=$P($g(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)),"^",10) 		;ANAOP_CTLOC_DR//2012
		.s bodsId=$p($g(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)),"^",24) ;身体部位
		.s bodsDesc=""
		.i bodsId'="" d
			..s bodsIdNum=$l(bodsId,"|")
			..f i=1:1:bodsIdNum d
				...s curBodsId=$p(bodsId,"|",i)
				...q:curBodsId=""
				...i bodsDesc="" s bodsDesc=$p($g(^OEC("BODS",+curBodsId)),"^",2)
				...e  s bodsDesc=bodsDesc_"^"_$p($g(^OEC("BODS",+curBodsId)),"^",2)		 
		.s anaOtherStr="" ;麻醉助手
		.s ii=0 f  s ii=$O(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ANASS",ii))  q:(ii="")||(ii>20)  d
			..s anadocOther=""
			..s anadr1=$g(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ANASS",ii))
			..i anadr1'="" s anadocOther=##class(web.DHCClinicCom).GetNameById(anadr1)
			..i anaOtherStr="" s anaOtherStr=$g(anadocOther)_"!"_anadr1
			..e  s anaOtherStr=anaOtherStr_" "_$g(anadocOther)_"!"_anadr1
		.s sanaStr=""
		.;交麻醉医师
		.s iii="" f  s iii=$O(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ANASS",iii),-1) q:(iii="")||(iii<21)  d
			..s sanadoc=""
			..s sanadr=$g(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ANASS",iii))
			..i sanadr'="" s sanadoc=##class(web.DHCClinicCom).GetNameById(sanadr)
			..i sanaStr="" s sanaStr=sanadoc_"!"_sanadr
			..e  s sanaStr=sanaStr_" "_sanadoc_"!"_sanadr
	q:(operLocIdArg'=operLocId)&&(operLocIdArg'="")
	s opName="",anaOPSurgeonDR="",operId="",opLevelDesc="",opLevelId=""
		s anaOpSubTmp2="",inum=0,anaOpSubTmp=0
	f  s anaOpSubTmp2=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaOpSubTmp2)) q:(anaOpSubTmp2="")!(inum>0)  d
		.s inum=anaOpSubTmp2
		.i inum>0 s anaOpSubTmp=inum

	s docdr=$P($g(^OR(EpisodeID,"ANA",anaSub,"OP",anaOpSubTmp)),"^",8)      ;ANAOP_Surgeon_DR  ；手术医师
	s anaOPSurgeonDR=$g(docdr)
	s anaOpSurgeon=##class(web.DHCClinicCom).GetNameById(anaOPSurgeonDR)
	s mainOperLevelDr="",mainOperLevel="",OperICDCode="",OplevelCode=""
	s anaopSub=0 f  s anaopSub=$O(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)) q:(anaopSub="")  d  
		.s curOperId=$P($g(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)),"^",6)       ;ANAOP_Type_DR；手术名称
		.i curOperId="" s opName=opName_$G(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"REM",2)) 
		.q:curOperId=""
		.if $D(^ORC("OPER",curOperId)) d
			..i opName="" s opName=$P(^ORC("OPER",curOperId),"^",2),operId=curOperId
			..e  s opName=$G(opName)_","_$P(^ORC("OPER",curOperId),"^",2),operId=operId_"|"_curOperId
			..s OperCode=$P($g(^ORC("OPER",+curOperId)),"^",14)
			..i OperICDCode'="" s OperICDCode=OperICDCode_"|"_OperCode
			..i OperICDCode="" s OperICDCode=OperCode
		.;//获取手术分类
		.s anaOpSubTmp2="",inum=0,anaOpSubTmp=""
		.f  s anaOpSubTmp2=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaOpSubTmp2)) q:(anaOpSubTmp2="")!(inum>0)  d
		..s inum=anaOpSubTmp2
		..i inum>0 s anaOpSubTmp=inum
		.s mainOperLevelDr=$p($g(^OR(EpisodeID,"ANA",anaSub,"OP",anaOpSubTmp,"DHC")),"^",1)
		.i +mainOperLevelDr>0 s mainOperLevel=$p($g(^ORC("CATEG",mainOperLevelDr)),"^",2)
		.s curopLevelId=$p($g(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"DHC")),"^",1)
		.q:curopLevelId=""
		. i opLevelDesc'="" s opLevelDesc=opLevelDesc_","_$p($g(^ORC("CATEG",curopLevelId)),"^",2),opLevelId=opLevelId_"|"_curopLevelId
		. e  s opLevelDesc=$p($g(^ORC("CATEG",curopLevelId)),"^",2),opLevelId=curopLevelId
		.s levelcode=$p($g(^ORC("CATEG",curopLevelId)),"^",1)
		.i OplevelCode'="" s OplevelCode=OplevelCode_"|"_levelcode
		.i OplevelCode="" s OplevelCode=levelcode
		
	s p=0,assistantFirstCtcpId="",assistantFirstCtcp="",assOtherId="",assOther="",assistantSecondCtcpId="",assistantSecondCtcp="",assistantThirdCtcpId="",assistantThirdCtcp=""
	s anaopSub=1
	s as=0 f  s as=$O(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ASS",as)) q:(as="")!(p=6)  d
		.s asdr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ASS",as),"^",1)
		.q:asdr=""
		.s p=p+1
		.i p=1 s assistantFirstCtcpId=$g(asdr)  ;一助
		.i assistantFirstCtcpId'="" s assistantFirstCtcp=##class(web.DHCClinicCom).GetNameById(assistantFirstCtcpId)
		.i p=2 s assistantSecondCtcpId=$g(asdr) ;二助
		.i assistantSecondCtcpId'="" s assistantSecondCtcp=##class(web.DHCClinicCom).GetNameById(assistantSecondCtcpId)
		.i p=3 s assistantThirdCtcpId=$g(asdr)  ;三助
		.i assistantThirdCtcpId'="" s assistantThirdCtcp=##class(web.DHCClinicCom).GetNameById(assistantThirdCtcpId)
		.i p>3 d
			..i assOtherId'="" s assOtherId=assOtherId_" "_asdr
			..e  s assOtherId=asdr
			..s assOther=$g(assOther)_" "_##class(web.DHCClinicCom).GetNameById(asdr)  ;其他助手
   
    s operPositionList=""
    s operPositionIdList=$G(^OR(EpisodeID,"ANA",anaSub,"OP",1,"POS",1)) ;手术体位
	i operPositionIdList'="" d
	  .s operPositionIdNum=$l(operPositionIdList,"|")	
	  .f j=1:1:operPositionIdNum d
	   ..s oposId=$p(operPositionIdList,"|",j)
	   ..q:oposId=""
	   ..s oposDesc=$p(^ORC("OPPOS",+oposId),"^",2)
	   ..i operPositionList="" s operPositionList=oposDesc
	   ..e  s operPositionList=operPositionList_"!"_oposDesc	
	
	s anaopSub=1
	s p=0,scrubNurFirstCtcpId="",scrubNurFirstCtcp="",scrubNurSecondCtcpId="",scrubNurSecondCtcp="",scrubNurThirdCtcpId="",scrubNurThirdCtcp="" ;洗手、器械护士
	s scnSub=0 f  s scnSub=$O(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"SCN",scnSub)) q:(scnSub="")!(p=4)  d
		.;q:scnSub>20
		.s scnDr=$P($g(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"SCN",scnSub)),"^",1)
		.q:scnDr=""
		.s p=p+1
		.i p=1 s scrubNurFirstCtcpId=$g(scnDr) ;器械护士1
		.i scrubNurFirstCtcpId'="" s scrubNurFirstCtcp=##class(web.DHCClinicCom).GetNameById(scrubNurFirstCtcpId)
		.i p=2 s scrubNurSecondCtcpId=$g(scnDr) ;器械护士2
		.i scrubNurSecondCtcpId'="" s scrubNurSecondCtcp=##class(web.DHCClinicCom).GetNameById(scrubNurSecondCtcpId)
		.i p=3 s scrubNurThirdCtcpId=$g(scnDr)  ;器械护士3
		.i scrubNurThirdCtcpId'="" s scrubNurThirdCtcp=##class(web.DHCClinicCom).GetNameById(scrubNurThirdCtcpId)
	s p=0,circulNurFirstCtcpId="",circulNurFirstCtcp="",circulNurSecondCtcpId="",circulNurSecondCtcp="",circulNurThirdCtcpId="",circulNurThirdCtcp="" ;巡回护士
	s cirnSub=0 f  s cirnSub=$O(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"CIRN",cirnSub)) q:(cirnSub="")!(p=4)   d
		.;q:cirnSub>20
		.s cirnDr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"CIRN",cirnSub),"^",1)
		.q:cirnDr=""
		.s p=p+1
		.i p=1 s circulNurFirstCtcpId=$g(cirnDr)
		.i circulNurFirstCtcpId'="" s circulNurFirstCtcp=##class(web.DHCClinicCom).GetNameById(circulNurFirstCtcpId)
		.i p=2 s circulNurSecondCtcpId=$g(cirnDr)
		.i circulNurSecondCtcpId'="" s circulNurSecondCtcp=##class(web.DHCClinicCom).GetNameById(circulNurSecondCtcpId)
		.i p=3 s circulNurThirdCtcpId=$g(cirnDr)
		.i circulNurThirdCtcpId'="" s circulNurThirdCtcp=##class(web.DHCClinicCom).GetNameById(circulNurThirdCtcpId)
	s rettimedate=##class(web.DHCANCom).GetANDateTime(opaId)
	
	s ANAStartDate=$p($g(rettimedate),"^",9) ;麻醉开始日期
    i anaStartTime=""	s anaStartTime=$p($g(rettimedate),"^",10) ;麻醉开始时间
	s ANAEndDate=$p($g(rettimedate),"^",11) ; 麻醉结束日期
	i anaEndTime="" s anaEndTime=$p($g(rettimedate),"^",12) ; 麻醉结束时间
	s SurgeonStartDate=$p($g(rettimedate),"^",13) ;手术开始日期
	i surgeonStartTime="" s surgeonStartTime=$p($g(rettimedate),"^",14) ;手术开始时间
	s SurgeonEndDate=$p($g(rettimedate),"^",15) ;手术结束日期
	i surgeonEndTime="" s surgeonEndTime=$p($g(rettimedate),"^",16) ;手术结束时间
	
	s bloodTypId=$P(^DHCANOPArrange(opaId),"^",11) ;血型
	i (+bloodTypId'=0)&($d(^PAC("BLDT",+bloodTypId))) s bloodType=$P($G(^PAC("BLDT",bloodTypId)),"^",2)
	e  s bloodType="不详"
	s OPAUseSelfBlood=$P(^DHCANOPArrange(opaId),"^",34) ;自体血回输
	s OPAExCirculation=$P(^DHCANOPArrange(opaId),"^",36) ;体外循环
	s ASAId=$P(^OR(EpisodeID,"ANA",anaSub),"^",26) ;ASA分级
	i ASAId'="" d
	.s ASA=$P(^ORC("ASA",ASAId),"^",2) 	;ASA分级
	e  s ASA=""
	s returnOpe=$P($G(^DHCANOPArrange(opaId)),"^",46) ;重返手术
	i $g(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"CRS",2))'="" d ;拒绝原因
	.s RejectReason=$G(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"CRS",2))
	e  s RejectReason=""
	s NorInstrument=$P($g(^DHCANOPArrange(opaId)),"^",30) ;常规器械
	s SpeInstrument=""		;特殊器械 暂无
	
	// by ccq 20150407 Steward评分
	s stewardScore=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"PACU.StewardScore")
	// by ccq 20150407 术后镇痛
	s analgesiaSub=0
	s analgesiaSub=$order(^DHCANOPArrange(opaId,"PAA",analgesiaSub))
	s analgesia="N"
	if (+analgesiaSub>0)
	{
		s analgesia="Y"	
	}
	s PRKillipI="",PRKillipII="",PRKillipIII="",PRKillipIV="",PRKillip=""
	s extendId=$o(^DHCANOPArrangeExtend(0,"OPACode",opaId,"PRKillipI",""))
	i extendId'=""  s PRKillipI=$li(^DHCANOPArrangeExtend(extendId),6)
    s extendId=$o(^DHCANOPArrangeExtend(0,"OPACode",opaId,"PRKillipII",""))
	i extendId'=""  s PRKillipII=$li(^DHCANOPArrangeExtend(extendId),6)
	s extendId=$o(^DHCANOPArrangeExtend(0,"OPACode",opaId,"PRKillipIII",""))
	i extendId'=""  s PRKillipIII=$li(^DHCANOPArrangeExtend(extendId),6)
	s extendId=$o(^DHCANOPArrangeExtend(0,"OPACode",opaId,"PRKillipIV",""))
	i extendId'=""  s PRKillipIV=$li(^DHCANOPArrangeExtend(extendId),6)
	i PRKillipI="True"  s PRKillip="I级"
	i PRKillipII="True"  s PRKillip="II级"
	i PRKillipIII="True"  s PRKillip="III级"
	i PRKillipIV="True"  s PRKillip="IV级"


	s obj=##class(web.DHCANInterface).%New()
	s obj.OpDate=opStartDate          ;手术日期
	s obj.OPAStartDateTime=opStartDate_" "_opsttime ;手术开始日期
	s obj.OPAEndDateTime=openddate_" "_opendtime	;手术结束时间
	;w obj.OPAStartDateTime_"||"_obj.OPAEndDateTime,!
	s obj.PlanOPAStartDateTime=opaPlanStartDateTime ;计划手术开始时间
	s obj.PlanOPAEndDateTime=planOPAEndDateTime	;计划结束时间
	s obj.OpTime=opTime            ;手术时间,
	s obj.OperId=operId			//手术码表Id,多个以"|"分割
	s obj.OpName=opName                ;手术名称，多个以","分割
	s obj.ANAOPPreopDiag=diag    ;术前诊断
	s obj.PatName=patName			;姓名
	s obj.Age=age					;年龄
	s obj.Sex=sex  				;性别
	s obj.Birthday=birth          ;出生日期 
	s obj.PaAdmType=paadmtype     ;病人类型
	s obj.Ward=ward               ;病区
	s obj.Bed=bedCode             ;床位
	s obj.BedRoom=bedRoom         ;床位所在房间号
	s obj.PatLoc=patLoc           ;病人所在科室
	s obj.ANAOPSurgeonDR=anaOPSurgeonDR      ;手术医师Id
	s obj.ANAOPSurgeon=anaOpSurgeon           ;手术医师
	;---请合并的时候不要去掉，给平台的接口中需要
	s anaOpSurgeonCode=""
	i anaOPSurgeonDR'="" d
		.s userId=$o(^SSU("SSUSR",0,"CTPCP",anaOPSurgeonDR,""),-1)
		.i userId'="" s anaOpSurgeonCode=$p($g(^SSU("SSUSR",userId)),"^",1)
	s obj.ANAOPSurgeonCode=anaOpSurgeonCode		;手术医师Code
	;---***
	s obj.AssistantFirstCtcpId=assistantFirstCtcpId    ;一助ID
	s obj.AssistantFirstCtcp=assistantFirstCtcp    ;一助描述
	;---请合并的时候不要去掉，给平台的接口中需要
	s assistantFirstCtcpCode=""
	i assistantFirstCtcpId'="" d
		.s firstAssId=$o(^SSU("SSUSR",0,"CTPCP",assistantFirstCtcpId,""),-1)
		.i firstAssId'="" s assistantFirstCtcpCode=$p($g(^SSU("SSUSR",firstAssId)),"^",1)
	s obj.AssistantFirstCtcpCode=assistantFirstCtcpCode	;一助Code
	;---***----
	;w obj.ANAOPSurgeonDR_"||"_obj.ANAOPSurgeon_"||"_obj.AssistantFirstCtcpId_"||"_obj.AssistantFirstCtcp,!
	s obj.AssistantSecondCtcpId=assistantSecondCtcpId  ;二助ID
	s obj.AssistantSecondCtcp=assistantSecondCtcp  ;二助描述
	;---请合并的时候不要去掉，给平台的接口中需要
	s AssistantSecondCtcpCode=""
	i assistantSecondCtcpId'="" d
		.s secAssId=$o(^SSU("SSUSR",0,"CTPCP",assistantSecondCtcpId,""),-1)
		.i secAssId'="" s AssistantSecondCtcpCode=$p($g(^SSU("SSUSR",secAssId)),"^",1)
	s obj.AssistantSecondCtcpCode=AssistantSecondCtcpCode	;二助Code
	;---***----
	 s obj.AssistantThirdCtcpId=assistantThirdCtcpId		;三助
	 s obj.AssistantThirdCtcp=assistantThirdCtcp			;三助描述
	 s AssistantThirdCtcpCode=""
	i assistantThirdCtcpId'="" d
		.s thrAssId=$o(^SSU("SSUSR",0,"CTPCP",assistantThirdCtcpId,""),-1)
		.i thrAssId'="" s AssistantThirdCtcpCode=$p($g(^SSU("SSUSR",thrAssId)),"^",1)
	s obj.AssistantThirdCtcpCode=AssistantThirdCtcpCode	;三助Code
	//
	 s obj.AssOtherCtcpStrId=assOtherId
	 s obj.AssOtherCtcpStr=assOther
	 ;----------
	s obj.AnaMethod=anaMethod          ;麻醉方法
	s obj.AnaDocCtcpId=anaDocCtcpId    ;麻醉医师Id
	s obj.AnaDoctor=anaDoctor         ;麻醉医师
	s AnaDoctorCode=""
	i anaDocCtcpId'="" d
		.s anDocId=$o(^SSU("SSUSR",0,"CTPCP",anaDocCtcpId,""),-1)
		.i anDocId'="" s AnaDoctorCode=$p($g(^SSU("SSUSR",anDocId)),"^",1)
	s obj.AnaDoctorCode=AnaDoctorCode	;andCode
	;-----------
	s obj.ScrubNurFirstCtcpId=scrubNurFirstCtcpId      ;器械护士一
	s obj.ScrubNurFirstCtcp=scrubNurFirstCtcp
	s obj.ScrubNurSecondCtcpId=scrubNurSecondCtcpId    ;器械护士二
	s obj.ScrubNurSecondCtcp=scrubNurSecondCtcp
	s obj.ScrubNurThirdCtcpId=scrubNurThirdCtcpId
	s obj.ScrubNurThirdCtcp=scrubNurThirdCtcp
	s obj.CirculNurFirstCtcpId=circulNurFirstCtcpId    ;巡回护士一
	s obj.CirculNurFirstCtcp=circulNurFirstCtcp
	s obj.CirculNurSecondCtcpId=circulNurSecondCtcpId	;巡回护士二
	s obj.CirculNurSecondCtcp=circulNurSecondCtcp		;巡回护士二
	s obj.CirculNurThirdCtcpId=circulNurThirdCtcpId	;巡回护士三
	s obj.CirculNurThirdCtcp=circulNurThirdCtcp
	s obj.BodsDesc=bodsDesc              ;手术部位
	s obj.OperPosition=operPositionList  ;手术体位
	s obj.OPAStatusCode=stat
	s obj.OPAStatus=opaStatus            ;状态
	s obj.StatCode=statCode				;状态代码
	s obj.DayOperFlag=dayOperFlag
	s obj.ANASourceTypeDesc=anaSourceTypeDesc     ;类型
	s obj.OPAPatDeptDr=opaPatDeptDr         ;病人所在科室
	s obj.OPAAppLocDr=opaAppLocDr      ;申请科室Id
	s obj.OPAAppLoc=opaAppLoc      ;申请科室，20170913
	s obj.OPAOperLocDr=operLocId      ;手术室ID
	s obj.OPAAppDate=opaAppDate        ;手术申请日期
	s obj.EpisodeID=EpisodeID           ;就诊号
	//s obj.OPAAdmDr=EpisodeID	;----勿删，Portal需要
	s obj.RegNo=regNo                 ;登记号
	s obj.MedCareNo=medCareNo         ;病案号
	s obj.OpaId=opaId                 ;手术Id
	s obj.AnaesthesiaID=anaId			;麻醉Id
	s obj.OPAOpRoomDr=oproomdr      ;手术间Id
	s obj.OPAOpRoom=opaOpRoom		;手术间描述
	s obj.OPASeq=opordno              ;手术台次
	s obj.OPAPATestHBsAg=yg		;乙肝
	s obj.OPAPATestHCVAb=bg		;丙肝
	s obj.OPAPATestHivAb=az		;HIV
	s obj.OPAPATestTPAb=md		;梅毒
	s obj.OPAPATestOther=qt		;其他
	s obj.OPALabResult=yy			;特殊感染
	s obj.ANAOPBladeTypeId=anaopBladeTypeId	;刀口类型Id
	s obj.ANAOPBladeType=anaopBladeType ;刀口类型
	s obj.OPAArrangeUser=arrUser	;安排者
	s obj.OPAArrangeDate=arrDate	;安排日期
	s obj.OPAArrangeTime=arrTime	;安排时间
	i inRoomTime="" s inRoomTime=" "
	s obj.InRoomTime=inRoomTime	;入室时间
	i leaveRoomTime="" s leaveRoomTime=" "
	s obj.LeaveRoomTime=leaveRoomTime	;离室时间
	i ANAStartDate="" s ANAStartDate=" "
	s obj.ANAStartDate=ANAStartDate	;麻醉开始日期
	i anaStartTime="" s anaStartTime=" "
	s obj.ANAStartTime=anaStartTime	;麻醉开始时间
	i ANAEndDate="" s ANAEndDate=" "
	s obj.ANAEndDate=ANAEndDate	;麻醉结束日期
	i anaEndTime="" s anaEndTime=" "
	s obj.ANAEndTime=anaEndTime	;麻醉结束时间
	s obj.SurgeonStartDate=SurgeonStartDate	;手术医生开始手术日期
	s obj.SurgeonStartTime=surgeonStartTime	;手术医生开始手术时间
	s obj.SurgeonEndDate=SurgeonEndDate	;手术医生结束手术日期
	s obj.SurgeonEndTime=surgeonEndTime	;手术医生结束手术时间
	;w obj.SurgeonStartDate_"||"_obj.SurgeonStartTime_"||"_obj.SurgeonEndDate_"||"_obj.SurgeonEndTime,!
	//s obj.OPAFinishTime=leaveRoomTime	;手术结束时间
	s obj.OPAPACUInTime=opaPACUInTime	;入恢复室时间
	s obj.OPAPACUOutTime=opaPACUOutTime	;离恢复室时间
	s obj.opLevelId=opLevelId         ;手术分类Id
	s obj.opLevelDesc=opLevelDesc     ;手术分类
	s obj.MainOperLevelDr=mainOperLevelDr	;主手术级别Id
	s obj.MainOperLevel=mainOperLevel	;主手术级别
	s obj.bloodType=bloodType		;血型
	s obj.OPAUseSelfBlood=OPAUseSelfBlood	;自体血回输
	s obj.OPAExCirculation=OPAExCirculation ;体外循环
	s obj.ASA=ASA	;ASA分级
	s obj.returnOpe=returnOpe ;重返手术
	s obj.RejectReason=RejectReason ;拒绝原因
	s obj.NorInstrument=NorInstrument ;常规器械
	s obj.SpeInstrument=SpeInstrument ;特殊器械
	s obj.Analgesia=analgesia ;术后镇痛
	s obj.StewardScore=stewardScore ;Steward评分
    s obj.PRKillip=PRKillip  ;心功能分级
    s obj.Prediag=anaOPPreopDiagDR
	;b ;"1"
	;电子病历
	s rettimedate=##class(web.DHCANCom).GetANDateTime(opaId)
	s inRoomDate=$p($g(rettimedate),"^",5)
	s leaveRoomDate=$p($g(rettimedate),"^",7)
	
	s obj.PlanOperId=operId			//手术码表Id,多个以"|"分割
	s obj.PlanOperName=opName                ;手术名称，多个以","分割
	s obj.LeaveRoomDate=leaveRoomDate
	s obj.PostDiagId=" "	;标准版未区分
	s obj.PostDiag=" "	;标准版未区分
	s obj.InRoomDate=inRoomDate
	s obj.inroomdatenew=inRoomDate
	s obj.AnaMethodStandardCode=" "	;安贞有接口
	s obj.BladeStandardCode=" "	;安贞有接口
	s obj.OperStandardCode=OperICDCode
	s obj.OplevelCode=OplevelCode
	s obj.RBloodXH=" "	;安贞有标准版没有，电子病历需要
	s obj.RBloodXHB=" "
	s obj.RBloodXJ=" "
	s obj.RBloodZTX=" "
	s obj.RBloodOther=" "
	s obj.technicianId=" "	;安贞有标准版没有
	s obj.technicianDes=" "
	
	s Xml=##class(%GlobalCharacterStream).%New()
	s ret=obj.XMLExportToStream(.Xml,"PatInfo")
	q:ret=0
	d retStr.CopyFrom(Xml)
	q
}

ClassMethod GetANAInfo(opaId) As %String
{
	s ret=""
	q ret
}

ClassMethod GetAnoEventNote(opaId, ancoCode, order = 1, ifSingle = "") As %String
{
	q:(opaId="") ""
	i delimter="" s delimter="^"
	q:ancoCode="" ""
	i order'=-1 s order=1
	s note=""
	s ancoId=$o(^DHCICUC("RecordItem",0,"TypeCode","E",ancoCode,""))
	q:ancoId="" ""
	s anoId="",ifFind=0
	f  s anoId=$o(^DHCANOrder(0,"CommOrd",ancoId,opaId,anoId),order) q:(anoId="")!(ifFind)  d
		.q:"CD"[$p($g(^DHCANOrder(anoId)),"^",25)
		.s note=$p($g(^DHCANOrder(anoId)),"^",10)
		.i ifSingle="Y" s ifFind=1
	q note
}

ClassMethod GetANOPArrangeId(stdate As %String, enddate As %String, needEpisodeID As %String = "") As %GlobalCharacterStream
{
	s retStr=""
	i stdate="" s stdate=""
	e  s stdate=##class(web.DHCClinicCom).ConvertToDateH(stdate)	
	i enddate="" s enddate=+$h
	e  s enddate=##class(web.DHCClinicCom).ConvertToDateH(enddate)
	s subNode="SDate"
	if (needEpisodeID'="")
	{   
		s opaId=""
		f  s opaId=$O(^DHCANOPArrange(0,"Adm",needEpisodeID,opaId)) q:opaId=""  d
			.q:"ARD"[$P(^DHCANOPArrange(opaId),"^",27)
			.s anaId=$P(^DHCANOPArrange(opaId),"^",2)
			.q:anaId=""
			.i retStr'="" s retStr=retStr_"^"
			.s retStr=retStr_opaId_$c(3)_anaId
	}
	else
	{  
		f date=+stdate:1:+enddate
		{
			s opaId=""
			f  s opaId=$O(^DHCANOPArrange(0,subNode,date,opaId)) q:opaId=""  d
				.q:"D"[$P(^DHCANOPArrange(opaId),"^",27)
				.s anaId=$P(^DHCANOPArrange(opaId),"^",2)
				.q:anaId=""
				.i retStr'="" s retStr=retStr_"^"
				.s retStr=retStr_opaId
				.s retStr=retStr_opaId_$c(3)_anaId
		}
	}
	q retStr
}

/// w ##class(web.DHCANAdaptor).GetAnOpCRFInfo(41,"opaStartDateTime")
ClassMethod GetAnOpCRFInfo(opaId As %String, inputKey As %String) As %String
{
	q:+opaId=0 ""
	s retStr=""
	
	s yg=$P($g(^DHCANOPArrange(opaId,"PALab")),"^",29)			//OPA_PATestHBsAg  	免疫乙肝表面抗原
	s bg=$P($g(^DHCANOPArrange(opaId,"PALab")),"^",34)			//OPA_PATestHCVAb 	免疫丙型肝炎抗体
	s az=$P($g(^DHCANOPArrange(opaId,"PALab")),"^",35)			//OPA_PATestHivAb 	免疫艾滋病毒抗体
	s md=$P($g(^DHCANOPArrange(opaId,"PALab")),"^",36)			//OPA_PATestTPAb 	免疫梅毒
	s qt=$P($g(^DHCANOPArrange(opaId,"PALab")),"^",2)			//OPA_PATestOther	检其它阴阳性
	s yy=""
	i yg="阳性" s yy=yy_"乙肝阳性"_" "
	i bg="阳性" s yy=yy_"丙肝阳性"_" "
	i az="阳性" s yy=yy_"艾滋病阳性"_" "
	i md="阳性" s yy=yy_"梅毒阳性"_" "
	i qt="阳性" s yy=yy_"其他阳性"_" "
	s stat=$P(^DHCANOPArrange(opaId),"^",27)
	//q:(opastatus '="")&(opastatus '=stat)
	s opaStatus=""  ;手术状态
	i stat="A" s opaStatus="申请"
	i stat="D" s opaStatus="拒绝"
	i stat="R" s opaStatus="安排"
	i stat="N" s opaStatus="非预约"
	i stat="I" s opaStatus="术中"
	i stat="P" s opaStatus="恢复室"
	i stat="L" s opaStatus="术毕"
	i stat="F" s opaStatus="完成"
	i stat="" s opaStatus="未审核"
	s opaAppDate=$P(^DHCANOPArrange(opaId),"^",3)     ;"完成"
	s opaAppDate=$zd(opaAppDate,3)
	s opaStartDate=$P(^DHCANOPArrange(opaId),"^",14)   ;手术开始日期
	i opaStartDate'="" s opaStartDate=$ZD(opaStartDate,3)
	s opsttime=$P(^DHCANOPArrange(opaId),"^",15)
	i opsttime'=""  s opsttime=$ZT(opsttime,2)
	s openddate=$P(^DHCANOPArrange(opaId),"^",16)
	i openddate'="" s openddate=$zd(openddate,3)
	e  s openddate=""
	s opendtime=$P(^DHCANOPArrange(opaId),"^",17)
	i opendtime'="" s opendtime=$zt(opendtime,2)
	e  s opendtime=""
	s opmem=$P(^DHCANOPArrange(opaId),"^",19)        	
	i openddate<=opaStartDate s openddate=""
	s opaStartDateTime=opaStartDate_" "_opsttime
	s opTime=opaStartDate_" "_opsttime_"~"_openddate_"^"_opendtime  
	s oproomdr=$P(^DHCANOPArrange(opaId),"^",20)
	i oproomdr'="" s opaOpRoom=$p($g(^DHCANC("OPRoom",oproomdr)),"^",2)
	s oprFloorId=""
	i oproomdr'="" s floorId=$p($g(^DHCANC("OPRoom",oproomdr)),"^",4)
	e  s floorId=""
	i floorId'="" s oprFloor=$P($G(^DHCANC("Floor",floorId)),"^",2)
	e  s oprFloor=""
	
	s opaPatDeptDesc=$P($g(^CTLOC(+$P(^DHCANOPArrange(opaId),"^",21))),"^",2)
	s opaPatHeight=$P(^DHCANOPArrange(opaId),"^",22)
	s opaPatWeight=$P(^DHCANOPArrange(opaId),"^",24)
	s opaPreAnaDrug=$p(^DHCANOPArrange(opaId),"^",29)
	
	s opordno=$P(^DHCANOPArrange(opaId),"^",26)
	i (opordno'="")&(opordno=1) s opdate="8:30"   				;ck  091016
	s tmpDateStr=opordno
	i +tmpDateStr=0 s tmpDateStr=""
	e  s tmpDateStr=tmpDateStr-1
	s tmpDateStr="接台"_tmpDateStr
		.i sdate'=edate s tmpDateStr=$p(opaStartDate," ")_" "_opaOpRoom_tmpDateStr
	i (opordno'="")&(opordno'=1) s opdate=tmpDateStr  	
		.s sortOpRoomDesc=opaOpRoom
		.i opaOpRoom="" s opaOpRoom="无"
	s sortOpaSeq=opordno
	i opordno="" s opordno="未排" 
	s EpisodeID=$P(^DHCANOPArrange(opaId),"^",1)   ;就诊号
	//q:(needEpisodeID'="")&(needEpisodeID'=EpisodeID)
	s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
	;s BloodTypeId=$P($G(^MR(papmiId,"PRO",1)),"^",18)
	;s BloodTypeId=
	s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	s birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
	s age=##class(web.DHCClinicCom).CalAge(birth,+$P(^DHCANOPArrange(opaId),"^",14),1)
	s anaSub=$P($P(^DHCANOPArrange(opaId),"^",2),"||",2)
	s anaSourceType=$P(^OR(EpisodeID,"ANA",anaSub),"^",32)   						;ANA_SourceType 急诊(E)/择期(B)
	i anaSourceType="E" s anaSourceTypeDesc="急诊"
	e  s anaSourceTypeDesc="择期"
	s appLocId=$P($G(^DHCANOPArrange(opaId)),"^",54)  ;申请科室
	//q:(ctlocId'="")&(ctlocId'=appLocId)
	s opaAppLocDr=$P($G(^CTLOC(+appLocId)),"^",2)
	s opaPatDeptDr=$P(^PAADM(EpisodeID),"^",4)   ;申请科室
	//q:(ctlocId'="")&(ctlocId'=opaPatDeptDr)
	s anaopPreopDiag="",diamen=""
	s anaopSub=0 f  s anaopSub=$O(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)) q:(anaopSub="")  d ;/ck091117
		.s preMrcidId=$P($g(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)),"^",4)   ;ANAOP_PreopDiag_DR 术前诊断
		.i preMrcidId'=""  d
			..s anaopPreopDiag=$P(^MRC("ID",preMrcidId),"^",2)
		.e  d
			..i $g(^OR(EpisodeID,"ANA",anaSub,"TXT",2))'="" d 
				...s anaopPreopDiag=^OR(EpisodeID,"ANA",anaopSub,"TXT",2)  	;麻醉表存放诊断备注ANA_Notes
		.s postMrcidId=$P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",5)  ;ANAOP_PostDiag_DR 术后诊断
		.i postMrcidId="" s postMrcidId=preMrcidId
		.i postMrcidId=+postMrcidId s anaopPostDiag=$P(^MRC("ID",+postMrcidId),"^",2)
		.i anaopPostDiag="" s anaopPostDiag=$g(^OR(EpisodeID,"ANA",anaopSub,"TXT",3))

	s anaId=$P(^DHCANOPArrange(opaId),"^",2) ;手术麻醉Id
	s anaSub=$P(anaId,"||",2)
	
	s asaId=$P(^OR(EpisodeID,"ANA",anaSub),"^",26)
	s orAsaDesc=$P(^ORC("ASA",+asaId),"^",2)
	s anaAnaesthetist=##class(web.DHCClinicCom).GetNameById($P(^OR(EpisodeID,"ANA",anaSub),"^",6))
	s anaSupervisor=##class(web.DHCClinicCom).GetNameById($P(^OR(EpisodeID,"ANA",anaSub),"^",7))
	s anmthdr=$P(^OR(EpisodeID,"ANA",anaSub),"^",5) ;/麻醉方法相关
	s anmetDesc=""        
	i anmthdr'="" d
		.s anmetNum=$l(anmthdr,"|")
		.f i=1:1:anmetNum d
			..s anmetId=$p(anmthdr,"|",i)
			..q:anmetId=""
			..s tmpAnmetDesc=$p($g(^ORC("ANMET",anmetId)),"^",2) ;麻醉方法描述
			..i $P(tmpAnmetDesc,"-",2)'="" s tmpAnmetDesc=$P(tmpAnmetDesc,"-",2)
			..i anmetDesc="" s anmetDesc=tmpAnmetDesc
			..e  s anmetDesc=anmetDesc_"^"_tmpAnmetDesc
	
	s anaopSub=0,anadoc1="",janadoc="",janadoc1="",anaAnaestAssistant=""
	f  s anaopSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)) q:anaopSub=""  d
		.q:$p($g(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)),"^",12)'="M" 
		.s bodsId=$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",24) ;身体部位
		.s bodsDesc=""
		.i bodsId'="" d
			..s bodsIdNum=$l(bodsId,"|")
			..f i=1:1:bodsIdNum d
				...s curBodsId=$p(bodsId,"|",i)
				...q:curBodsId=""
				...i bodsDesc="" s bodsDesc=$p($g(^OEC("BODS",+curBodsId)),"^",2)
				...e  s bodsDesc=bodsDesc_"^"_$p($g(^OEC("BODS",+curBodsId)),"^",2)
		.;麻醉助手
		.s ii=0 f  s ii=$O(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ANASS",ii))  q:(ii="")||(ii>20)  d
			..s anadocOther=""
			..s anadr1=$g(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ANASS",ii))
			..i anadr1'="" s anadocOther=##class(web.DHCClinicCom).GetNameById(anadr1)
			..i anaAnaestAssistant="" s anaAnaestAssistant=anadocOther
			..e  s anaAnaestAssistant=anaAnaestAssistant_"^"_anadocOther
		.s sanaStr=""
		.;交麻醉医师
		.s iii="" f  s iii=$O(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ANASS",iii),-1) q:(iii="")||(iii<21)  d
			..s sanadoc=""
			..s sanadr=$g(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ANASS",iii))
			..i sanadr'="" s sanadoc=##class(web.DHCClinicCom).GetNameById(sanadr)
			..i sanaStr="" s sanaStr=sanadoc_"!"_sanadr
			..e  s sanaStr=sanaStr_" "_sanadoc_"!"_sanadr
	s operDesc="",anaopSurgeon="",opposDesc=""
	s anaopSub=0 f  s anaopSub=$O(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)) q:(anaopSub="")  d  
		.s anaOPSurgeonDR=$P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",8)      ;ANAOP_Surgeon_DR  ；手术医师
		.s anaOpSurgeon=##class(web.DHCClinicCom).GetNameById(anaOPSurgeonDR)
		.s curOperId=$P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",6)       ;ANAOP_Type_DR；手术名称
		.q:curOperId=""
		.if $D(^ORC("OPER",curOperId)) d
			..i operDesc="" s operDesc=$P(^ORC("OPER",curOperId),"^",2)
			..e  s operDesc=operDesc_"^"_$P(^ORC("OPER",curOperId),"^",2)
		.s opposSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"POS",0)) //体位多个?
		.s opposId=+$g(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"POS",+opposSub))
		.s opposDesc=$p($g(^ORC("OPPOS",opposId)),"^",2)

	s p=0,assistantFirstCtcpId="",assOther="",assistantSecondCtcpId="",assistantThirdCtcpId=""	
	s anaopSub=1
	s as=0 f  s as=$O(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ASS",as)) q:(as="")!(p=6)  d
		.s asdr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ASS",as),"^",1)
		.q:asdr=""
		.s p=p+1
		.i p=1 s assistantFirstCtcpId=$g(asdr)  ;一助
		.i p=2 s assistantSecondCtcpId=$g(asdr) ;二助
		.i p=3 s assistantThirdCtcpId=$g(asdr)  ;三助
		.i p>3 d
			..s assOther=$g(assOther)_" "_$P(^CTPCP(asdr,1),"^",2)  ;其他助手
	s anaopFirstAssistant=##class(web.DHCClinicCom).GetNameById(assistantFirstCtcpId)
	s anaopSecondAssistant=##class(web.DHCClinicCom).GetNameById(assistantSecondCtcpId)
	s anaopThirdAssistant=##class(web.DHCClinicCom).GetNameById(assistantThirdCtcpId)
	//i assistantSecondCtcpId'="" s anaopAssistant=anaopAssistant_"^"_##class(web.DHCANOPCom).GetNameById(assistantSecondCtcpId)
	//i assistantThirdCtcpId'="" s anaopAssistant=anaopAssistant_"^"_##class(web.DHCANOPCom).GetNameById(assistantThirdCtcpId)
	s anaopSub=1
	s p=0,opSCNScrubNurse="",scrubNurSecondCtcpId="",scrubNurThirdCtcpId="" ;洗手、器械护士
	s scnSub=0 f  s scnSub=$O(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"SCN",scnSub)) q:(scnSub="")!(p=4)  d
		.q:scnSub>20
		.s scnDr=$P($g(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"SCN",scnSub)),"^",1)
		.q:scnDr=""
		.s p=p+1
		.i p=1 s opSCNScrubNurse=$g(scnDr) ;手术器械护士
		.i p=2 s scrubNurSecondCtcpId=$g(scnDr) ;器械护士2
		.i p=3 s scrubNurThirdCtcpId=$g(scnDr)   ;器械护士3
	s p=0,anaOPCirculNurseDR="",circulNurSecondCtcpId="",circulNurThirdCtcpId="" ;巡回护士
	s cirnSub=0 f  s cirnSub=$O(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"CIRN",cirnSub)) q:(cirnSub="")!(p=4)   d
		.q:cirnSub>20
		.s cirnDr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"CIRN",cirnSub),"^",1)
		.q:cirnDr=""
		.s p=p+1
		.i p=1 s anaOPCirculNurseDR=$g(cirnDr)
		.i p=2 s circulNurSecondCtcpId=$g(cirnDr)
		.i p=3 s circulNurThirdCtcpId=$g(cirnDr)
	s anaAnestDuration=##class(web.DHCANOrder).GetAnoDuraMinute(opaId,"AnaStart","AnaEnd")
	s anaSurgeryDuration=##class(web.DHCANOrder).GetAnoDuraMinute(opaId,"OperStart","OperEnd")
	s anoBPSystolic=##class(web.DHCANOrder).GetAnoVitalSignQty(opaId,"NIBPs^ARTs")
	s anoBPDiastolic=##class(web.DHCANOrder).GetAnoVitalSignQty(opaId,"NIBPd^ARTd")
	s anoHeartRate=##class(web.DHCANOrder).GetAnoVitalSignQty(opaId,"HR")
	s anoRespRate=##class(web.DHCANOrder).GetAnoVitalSignQty(opaId,"Resp")
	s anoOxygenSaturation=##class(web.DHCANOrder).GetAnoVitalSignQty(opaId,"SPO2")
	s anoEvent=##class(web.DHCANOrder).GetAnoEvent(opaId,"")
	//s myobj.OPAPATestHBsAg=yg
	//s myobj.OPAPATestHCVAb=bg
	//s myobj.OPAPATestHivAb=az
	//s myobj.OPAPATestTPAb=md
	//s myobj.OPAPATestOther=qt
	//s myobj.OPALabResult=yy
	i inputKey="patAgeYear" s retStr=+age
	i inputKey="patAgeMonth" s retStr=+$p($p(age,"岁",2),"月")
	i inputKey="patAgeDay" s retStr=+$p($p(age,"月",2),"天")
	i inputKey="opaPatHeight" s retStr=opaPatHeight
	i inputKey="opaPatWeight" s retStr=opaPatWeight
	i inputKey="opaPatDeptDesc" s retStr=opaPatDeptDesc
	i inputKey="opaStartDateTime" s retStr=opaStartDateTime
	i inputKey="orAsaDesc" s retStr=orAsaDesc
	i inputKey="opaPreAnaDrug" s retStr=opaPreAnaDrug
	i inputKey="anmetDesc" s retStr=anmetDesc
	i inputKey="anaopPreopDiag" s retStr=anaopPreopDiag
	i inputKey="anaopPostDiag" s retStr=anaopPostDiag
	i inputKey="operDesc" s retStr=operDesc
	i inputKey="opposDesc" s retStr=opposDesc
	i inputKey="anaAnestDuration" s retStr=anaAnestDuration
	i inputKey="anaSurgeryDuration" s retStr=anaSurgeryDuration
	i inputKey="anaopSurgeon" s retStr=anaOpSurgeon
	i inputKey="anaopFirstAssistant" s retStr=anaopFirstAssistant
	i inputKey="anaopSecondAssistant" s retStr=anaopSecondAssistant
	i inputKey="anaopThirdAssistant" s retStr=anaopThirdAssistant
	i inputKey="bodsDesc" s retStr=bodsDesc
	i inputKey="anaSupervisor" s retStr=anaSupervisor
	i inputKey="anaAnaesthetist" s retStr=anaAnaesthetist
	i inputKey="anaAnaestAssistant" s retStr=anaAnaestAssistant
	i inputKey="anaSourceTypeDesc" s retStr=anaSourceTypeDesc
	
	i inputKey="anoBPSystolic" s retStr=anoBPSystolic
	i inputKey="anoBPDiastolic" s retStr=anoBPDiastolic
	i inputKey="anoHeartRate" s retStr=anoHeartRate
	i inputKey="anoRespRate" s retStr=anoRespRate
	i inputKey="anoOxygenSaturation" s retStr=anoOxygenSaturation
	i inputKey="anoEvent" s retStr=anoEvent
	q retStr
}

ClassMethod GetOperPatInfoEpr(stdate As %String, enddate As %String, EpisodeID As %String, ctlocId As %String)
{
    
  ;s a=##class(web.DHCANAdaptor).GetOperPatInfo("2009-2-18","2009-2-18","","")
  
  i (stdate="") s sdate=+$H
  e  s sdate=$zdh(stdate,3)	
  i (enddate="") s edate=+$H
  e  s edate=$zdh(enddate,3)
  i EpisodeID'="",stdate="" s sdate=$p($g(^PAADM(EpisodeID)),"^",6)
  s SubNode="SDate"
  ;i IsAppT=1 s SubNode="AppDate"
  s i=0
  s retStr=##class(%GlobalCharacterStream).%New()
  d retStr.Rewind()
  d retStr.Write("<Response>")
  f date=sdate:1:edate
  {  
	s opaId=""
    f  s opaId=$O(^DHCANOPArrange(0,SubNode,date,opaId)) q:opaId=""  d 
	.s Status=$P(^DHCANOPArrange(opaId),"^",27)
	.q:Status="F"                                  ;"完成"
    .s admId=$P(^DHCANOPArrange(opaId),"^",1)
	.q:(EpisodeID'="")&(EpisodeID'=admId)
	.s locDr=$P(^PAADM(admId),"^",4)
	.q:(ctlocId'="")&(ctlocId'=locDr)
	.s opstdate=$P(^DHCANOPArrange(opaId),"^",14)
	.i opstdate'="" s opstdate=$ZD(opstdate,3)
	.s opDate=opstdate
	
        .s anaId=$P(^DHCANOPArrange(opaId),"^",2)
	.s anaSub=$P(anaId,"||",2)
	.s anadr=$P(^OR(admId,"ANA",anaSub),"^",6)        ; ANA_Anaesthetist_Dr 
	.i anadr'="" d
	..s anaMethodssid=$P($g(^CTPCP(anadr,1)),"^",1)
	..s anaDoctor=anaMethodssid_"^"_$TR($P(^CTPCP(anadr,1),"^",2)," ","") ;麻醉医师
	.e  s anaDoctor=""
	.s anmthdr=$P(^OR(admId,"ANA",anaSub),"^",5)        
	.i anmthdr'="" d
	..s anaMethod=$P(^ORC("ANMET",anmthdr),"^",2)
	.e  s anaMethod=""
	.s anaopSub=0,anadoc1="",janadoc="",janadoc1=""
    .f  s anaopSub=$o(^OR(admId,"ANA",anaSub,"OP",anaopSub)) q:anaopSub=""  d
    ..q:$p(^OR(admId,"ANA",anaSub,"OP",anaopSub),"^",12)'="M" 
    ..s anaOtherStr=""
    ..s ii=0 f  s ii=$O(^OR(admId,"ANA",anaSub,"OP",anaopSub,"ANASS",ii))  q:(ii="")||(ii>20)  d
    ...s anadocOther=""
    ...s anadr1=$g(^OR(admId,"ANA",anaSub,"OP",anaopSub,"ANASS",ii))
    ...i anadr1'="" s anadoc1=$TR($P(^CTPCP(anadr1,1),"^",2)," ","")
    ...i anaOtherStr="" s anaOtherStr=$g(anadocOther)_"!"_anadr1
    ...e  s anaOtherStr=anaOtherStr_" "_$g(anadocOther)_"!"_anadr1
    ..s janaStr=""
    ..s iii="" f  s iii=$O(^OR(admId,"ANA",anaSub,"OP",anaopSub,"ANASS",iii),-1) q:(iii="")||(iii<21)  d
    ...s janadoc=""
    ...s janadr=$g(^OR(admId,"ANA",anaSub,"OP",anaopSub,"ANASS",iii))
    ...i janadr'="" s janadoc=$TR($P(^CTPCP(janadr,1),"^",2)," ","")
    ...i janaStr="" s janaStr=janadoc_"!"_janadr
    ...e  s janaStr=janaStr_" "_janadoc_"!"_janadr
	.s anaz=anaDoctor_"*"_anaOtherStr_"*"_janaStr
    .s chl=$P($P(^DHCANOPArrange(opaId),"^",2),"||",2)
    .s opName="",opDoctor=""
	.s subchl=0 f  s subchl=$O(^OR(admId,"ANA",chl,"OP",subchl)) q:(subchl="")  d  
	..s docdr=$P(^OR(admId,"ANA",chl,"OP",subchl),"^",8)      ;ANAOP_Surgeon_DR  ；手术医师
	..i (docdr'="")&(opDoctor="") 
	...s opDoctor=$TR($P(^CTPCP(docdr,1),"^",2)," ","")
	...s opDoctorssid=$P($g(^CTPCP(docdr,1)),"^",1)
	...s opDoctor=opDoctorssid_"^"_opDoctor
	..s opdr=$P(^OR(admId,"ANA",chl,"OP",subchl),"^",6)       ;ANAOP_Type_DR     ；手术名称
	..q:opdr=""
	..if $D(^ORC("OPER",opdr)) s opName=$G(opName)_" "_$P(^ORC("OPER",opdr),"^",2)
    .s p=0,assistant1="",assOther="",assistant2="",assistant3=""	
    .s sub=1
	.s as=0 f  s as=$O(^OR(admId,"ANA",chl,"OP",sub,"ASS",as)) q:(as="")!(p=6)  d
	..s asdr=$P(^OR(admId,"ANA",chl,"OP",sub,"ASS",as),"^",1)
	..q:asdr=""
	..s p=p+1
	..i p=1 s assistant1=$P($g(^CTPCP(asdr,1)),"^",1)_"^"_$P(^CTPCP(asdr,1),"^",2)
	..i p=2 s assistant2=$P($g(^CTPCP(asdr,1)),"^",1)_"^"_$P(^CTPCP(asdr,1),"^",2)
	..i p=3 s assistant3=$P($g(^CTPCP(asdr,1)),"^",1)_"^"_$P(^CTPCP(asdr,1),"^",2)
	..i p>3 d
	...s assOther=$g(assOther)_" "_$P(^CTPCP(asdr,1),"^",2) 
	.;w !,opDate_"&"_opName_"&"_opDoctor_"&"_assistant1_"&"_assistant2_"&"_anamethod_"&"_anaDoctor 
	.s myobj=##class(web.DHCANInterfaceReg).%New()
	.s myobj.OpDate=opDate
	.s myobj.OpName=opName
	.s myobj.OpDoctor=opDoctor
	.s myobj.Assistant1=assistant1
	.s myobj.Assistant2=assistant2
	.s myobj.AnaMethod=anaMethod
	.s myobj.AnaDoctor=anaDoctor
    .s Xml=##class(%GlobalCharacterStream).%New()
	.s ret=myobj.XMLExportToStream(.Xml,"PatInfo")
	.q:ret=0
	.d retStr.CopyFrom(Xml)
	}  
	d retStr.Write("</Response>")
	;s b=a.ReadLine()
	q retStr
}

ClassMethod GetOperPatInfo(stdate As %String, endDate As %String, EpisodeID As %String, ctlocId As %String) As %GlobalCharacterStream
{
    
  ;s a=##class(web.DHCANAdaptor).GetOperPatInfo("2009-2-18","2009-2-18","","")
  
  i (stdate="") s sdate=+$H
  e  s sdate=$zdh(stdate,3)	
  i (endDate="") s edate=+$H
  e  s edate=$zdh(endDate,3)
  i EpisodeID'="",stdate="" s sdate=$p($g(^PAADM(EpisodeID)),"^",6)
  s SubNode="SDate"
  ;i IsAppT=1 s SubNode="AppDate"
  s i=0
  s retStr=##class(%GlobalCharacterStream).%New()
  d retStr.Rewind()
  d retStr.Write("<Response>")
  f date=sdate:1:edate
  {  
	s opaId=""
    f  s opaId=$O(^DHCANOPArrange(0,SubNode,date,opaId)) q:opaId=""  d 
	   .s Status=$P(^DHCANOPArrange(opaId),"^",27)
	   .q:Status'="F"                                  ;"完成"
       .s admId=$P(^DHCANOPArrange(opaId),"^",1)
	   .q:(EpisodeID'="")&(EpisodeID'=admId)
	.s locDr=$P(^PAADM(admId),"^",4)
	.q:(ctlocId'="")&(ctlocId'=locDr)
	.s opstdate=$P(^DHCANOPArrange(opaId),"^",14)
	.i opstdate'="" s opstdate=$ZD(opstdate,4)
	.s opDate=opstdate
	.s anaId=$P(^DHCANOPArrange(opaId),"^",2)
	.s anaSub=$P(anaId,"||",2)
	.s anadr=$P(^OR(admId,"ANA",anaSub),"^",6)        ; ANA_Anaesthetist_Dr 
	.i anadr'="" d
	..s anaDoctor=$TR($P(^CTPCP(anadr,1),"^",2)," ","") ;麻醉医师
	.e  s anaDoctor=" "
	.s anmthdr=$P(^OR(admId,"ANA",anaSub),"^",5)        
	.i anmthdr'="" d
	..s anaMethod=$P(^ORC("ANMET",+anmthdr),"^",2)
	.e  s anaMethod=""
	.s anaopSub=0,anadoc1="",janadoc="",janadoc1=""
    .f  s anaopSub=$o(^OR(admId,"ANA",anaSub,"OP",anaopSub)) q:anaopSub=""  d
    ..q:$p(^OR(admId,"ANA",anaSub,"OP",anaopSub),"^",12)'="M" 
    ..s anaOtherStr=""
    ..s ii=0 f  s ii=$O(^OR(admId,"ANA",anaSub,"OP",anaopSub,"ANASS",ii))  q:(ii="")||(ii>20)  d
    ...s anadocOther=""
    ...s anadr1=$g(^OR(admId,"ANA",anaSub,"OP",anaopSub,"ANASS",ii))
    ...i anadr1'="" s anadocOther=##class(web.DHCClinicCom).GetNameById(anadr1)
    ...i anaOtherStr="" s anaOtherStr=$g(anadocOther)_"!"_anadr1
    ...e  s anaOtherStr=anaOtherStr_" "_$g(anadocOther)_"!"_anadr1
    ..s janaStr=""
    ..s iii="" f  s iii=$O(^OR(admId,"ANA",anaSub,"OP",anaopSub,"ANASS",iii),-1) q:(iii="")||(iii<21)  d
    ...s janadoc=""
    ...s janadr=$g(^OR(admId,"ANA",anaSub,"OP",anaopSub,"ANASS",iii))
    ...i janadr'="" s janadoc=$TR($P(^CTPCP(janadr,1),"^",2)," ","")
    ...i janaStr="" s janaStr=janadoc_"!"_janadr
    ...e  s janaStr=janaStr_" "_janadoc_"!"_janadr
    .s anaSub=$P($P(^DHCANOPArrange(opaId),"^",2),"||",2)
    .s opName="",opDoctor=""
	.s anaSub=0 f  s anaSub=$O(^OR(admId,"ANA",anaSub,"OP",anaSub)) q:(anaSub="")  d  
	..s docdr=$P(^OR(admId,"ANA",anaSub,"OP",anaSub),"^",8)      ;ANAOP_Surgeon_DR  ；手术医师
	..i (docdr'="")&(opDoctor="") s opDoctor=$TR($P(^CTPCP(docdr,1),"^",2)," ","")
	..s curOperId=$P(^OR(admId,"ANA",anaSub,"OP",anaSub),"^",6)       ;ANAOP_Type_DR     ；手术名称
	..q:curOperId=""
	..if $D(^ORC("OPER",curOperId)) s opName=$G(opName)_" "_$P(^ORC("OPER",curOperId),"^",2)
    .s p=0,assistant1="",assOther="",assistant2="",assistant3=""	
    .s anaopSub=1
	.s as=0 f  s as=$O(^OR(admId,"ANA",anaSub,"OP",anaopSub,"ASS",as)) q:(as="")!(p=6)  d
	..s asdr=$P(^OR(admId,"ANA",anaSub,"OP",anaopSub,"ASS",as),"^",1)
	..q:asdr=""
	..s p=p+1
	..i p=1 s assistant1=$P(^CTPCP(asdr,1),"^",2)
	..i p=2 s assistant2=$P(^CTPCP(asdr,1),"^",2)
	..i p=3 s assistant3=$P(^CTPCP(asdr,1),"^",2)
	..i p>3 d
	...s assOther=$g(assOther)_" "_$P(^CTPCP(asdr,1),"^",2)
	.s p=0  ;洗手
	.
	.s scnSub=0 f  s scnSub=$O(^OR(admId,"ANA",anaSub,"OP",+anaSub,"SCN",scnSub)) q:(scnSub="")!(p=3)  d
	..q:scnSub>20
	..s scrubDr=$P(^OR(admId,"ANA",anaSub,"OP",anaSub,"SCN",scnSub),"^",1)
	..q:scrubDr=""
	..s p=p+1
	..;s scrubNurse=scrubNurse_" "_$TR($P(^CTPCP(scrubDr,1),"^",2)," ","")  ;
	..;s scrubNurse=scrubNurse_" "_##class(web.DHCANOPCom).GetNameById(scrubDr)
	.s p=0  ;巡回
	.s cirnSub=0 f  s cirnSub=$O(^OR(admId,"ANA",anaSub,"OP",+anaSub,"CIRN",cirnSub)) q:(cirnSub="")!(p=3)   d
	..q:cirnSub>20
	..s circuitDr=$P(^OR(admId,"ANA",anaSub,"OP",anaSub,"CIRN",cirnSub),"^",1)
	..q:circuitDr=""
	..s p=p+1
	..;s circuitNurse=$G(circuitNurse)_" "_$TR($P($G(^CTPCP(circuitDr,1)),"^",2)," ","")
	..;s circuitNurse=$G(circuitNurse)_" "_##class(web.DHCANOPCom).GetNameById(circuitDr) 
	.s myobj=##class(web.DHCANRegInterface).%New()
	.s myobj.OpDate=opDate
	.s myobj.OpName=opName
	.s myobj.OpDoctor=opDoctor
	.s myobj.Assistant1=assistant1
	.s myobj.Assistant2=assistant2
	.s myobj.AnaMethod=anaMethod
	.s myobj.AnaDoctor=anaDoctor
    .s Xml=##class(%GlobalCharacterStream).%New()
	.s ret=myobj.XMLExportToStream(.Xml,"PatInfo")
	.q:ret=0
	.d retStr.CopyFrom(Xml)
	}  
	d retStr.Write("</Response>")
	;s b=a.ReadLine()
	q retStr
}

ClassMethod Temp(opaId As %String, ctlocId As %String) As %String
{
    
  ;s a=##class(web.DHCANAdaptor).GetOperPatInfo("2009-2-18","2009-2-18","","")
  q "abcdefg"
  s retStr=""
  i (stdate="") s sdate=+$H
  e  s sdate=$zdh(stdate,3)	
  i (endDate="") s edate=+$H
  e  s edate=$zdh(endDate,3)
	q retStr
}

/// w ##class(web.DHCANAdaptor).InsertAnopApply(opaStr,anaStr,anaopStr,assDocStr,arrStr,operStr)
/// w ##class(web.DHCANAdaptor).InsertAnopApply("2102^LIBO^10/11/2009^13:08^LIBO^17731^^^A^^^170^60^^^手术医师备注^0509110310563900000000001^^04/11/2009^10:00","A^","^I000001^LIBO^诊断备注^710101^03^1","ZLMEI^LDQUN^SZH^CLMING^LZLAN","未查^阴性^阳性^化验中^0^其他^阳性^N^Y^N^Y^Y^Y","481|中")
/// w ##class(web.DHCANAdaptor).InsertAnopApply("2102^LIBO^10/11/2009^08:00^LIBO^17731^^kjh^3^^中^0^0^^^彭道地^050911091147230000000000000001^0^09/11/2009^11:47","4^","^Q24.902^MOL^lh^710102^107^2","MOL^MOL^MOL^MOL^MOL","未查^化验中^未查^阴性^0^其他^未查^Y^Y^Y^Y^N^Y","3024|中")//HUANG  OK
/// w ##class(web.DHCANAdaptor).InsertAnopApply("2102^LIBO^07/01/2010^08:00^LIBO^17731^^dfdfdsa 备注:^X^^SM^^^^^||||||杨天伦^100106113936000000000000000001^^06/01/2010^11:39","W^","^I003479|先天性心脏病^CHENF^^710102^4^3","CXB^PENGDAODI^JXN09009^XIONGF^JXN09005","未查^未查^未查^阴性^0^其他^不详^N^N^N^Y^N^Y","2841|SM|眶内血肿清除术^626|SM|开放性骨折清创缝合术^2523|SM|髋人字石膏固定术")
/// Creator：      	ypz
/// CreatDate：    	2009-09-15
/// Description： 	插入手术申请
/// Table：        	DHC_AN_OPArrange,OR_Anaesthesia,OR_Anaest_Operation,OR_An_Oper_Assistant,OR_An_Oper_Position
/// Input：        	opaStr:  实施手术科室代码^申请医生代码^手术日期^手术时间^申请用户工号^就诊号^--手术间^手术要求^血型代码^--手术安排时间^
///                          手术规模(空,由operStr传主医嘱)^病人身高^病人体重^--术前讨论日期^--预计手术持续时间^实习手术医生^医生手术编号^手术台次^手术申请日期^手术申请时间
///                 anaStr:  麻醉方式代码^
///                 anaopStr:手术名称代码(空,由operStr传)^术前诊断代码|术前诊断备注^主刀医生工号^诊断备注^手术室代码^手术部位代码^手术体位代码^
///                 assDocStr:  第一手术助手工号^第二手术助手工号^第三手术助手工号^第四手术助手工号^第五手术助手工号
///                 arrStr:  HbsAg^HCVAb^HivAb^梅毒^急诊/择期 1/0^其它^RH血型^是否隔离Y/N^是否备血Y/N^是否自体血Y/N^是否体外循环Y/N^是否需要麻醉Y/N^是否微创Y/N
///                 operStr: 手术1|手术1规模代码|手术名称^手术2|手术2规模代码|手术名称^...
/// Output：       
/// Return：       	手术申请RowID，其他-异常返回信息
ClassMethod InsertAnopApply(opaStr As %String, anaStr As %String, anaopStr As %String, assDocStr As %String, arrStr As %String, operStr As %String) As %String
{
	s opaStr=$tr(opaStr,$c(0),"")
	s anaStr=$tr(anaStr,$c(0),"")
	s anaopStr=$tr(anaopStr,$c(0),"")
	s assDocStr=$tr(assDocStr,$c(0),"")
	s arrStr=$tr(arrStr,$c(0),"")
	s operStr=$tr(operStr,$c(0),"")
	
	/*
	s ^tmpANDebug("insertAnRecord","opaStr")=opaStr
	s ^tmpANDebug("insertAnRecord","anaopStr")=anaopStr
	s ^tmpANDebug("insertAnRecord","assDocStr")=assDocStr
	s ^tmpANDebug("insertAnRecord","arrStr")=arrStr
	s ^tmpANDebug("insertAnRecord","anaStr")=anaStr
	s ^tmpANDebug("insertAnRecord","operStr")=operStr
	
	//831^2290^17/09/2009^13:08^10376^1053654^^手术要求^3^^2^^^^04:00^手术医师备注^手术编号^1
	s opaStr="A102^zyys001^17/09/2009^13:08^zyys001^1053654^^手术要求^A^^B^170^60^^04:00^手术医师备注^手术编号^1^17/09/2009^10:00"
	//16059^40980^2193^诊断备注^sss-手术室^7^3
	s anaopStr="0500010001^000054^234^诊断备注^201601^07^3"
	//241^2493^1659^1765^237
	s assDocStr="230^2697^3165^3587^243"
	//未查^阴性^阳性^化验中^0^其他^阳性^N^Y^N^Y^Y
	s arrStr="未查^阴性^阳性^化验中^0^其他^阳性^N^Y^N^Y^Y^Y"
	s operStr="0500010001|B^0500010002|M^0500010020|SP"
	*/
	s $zt="ERROR"
	s mainOperStr=$p(operStr,"^",1)
	s mainOperName=$p(mainOperStr,"|",3)
	q:mainOperName="" "主手术为空！"

	s $p(opaStr,"^",1)=##class(web.DHCClinicCom).GetCtlocIdByCodeOrDesc($p(opaStr,"^",1),"Code")	//1  实施手术科室Id
	q:$p(opaStr,"^",1)="" "无手术实施科室!"
	s $p(opaStr,"^",2)=##class(web.DHCClinicCom).GetCtcpIdByInitials($p(opaStr,"^",2))				//2  申请医生Id
	q:$p(opaStr,"^",2)="" "无手术申请医生!"
	s $p(opaStr,"^",3)=##class(web.DHCClinicCom).ConvertToDateH($p(opaStr,"^",3))					//3  手术日期
	q:$p(opaStr,"^",3)="" "无手术申请日期!"
	s $p(opaStr,"^",4)=##class(web.DHCClinicCom).ConvertToTimeH($p(opaStr,"^",4))					//4  手术时间
	q:$p(opaStr,"^",4)="" "无手术申请时间!"
	s $p(opaStr,"^",5)=##class(web.DHCClinicCom).GetUserIdByInitials($p(opaStr,"^",5))				//5  申请用户Id
	q:$p(opaStr,"^",6)="" "就诊号为空!"  //s $p(opaStr,"^",6)=EpisodeID							//6  就诊号，平台提供
	/*s oprCode=$p(opaStr,"^",7)
	s tmpOprId=0,oprId=""
	f  s tmpOprId=$o(^DHCANC("OPRoom",tmpOprId)) q:tmpOprId=""  d
	    .i oprCode=$p(^DHCANC("OPRoom",tmpOprId),"^") s oprId=tmpOprId
	q:oprId="" "没有手术间!"
	s $p(opaStr,"^",7)=oprId //手术间 */														//7  手术间 申请不需要
    s $p(opaStr,"^",7)=""    //暂!!
	//opaMemo																					//8  手术要求
	s bldtCode=$$ALPHAUP^SSUTIL4($p(opaStr,"^",9))
	s bldtId=""
	i bldtCode'="" s bldtId=$o(^PAC("BLDT",0,"Code",bldtCode,""))
	s $p(opaStr,"^",9)=bldtId																	//9  血型Id
	s $p(opaStr,"^",10)=""
	//10 opaArrangeTime																			//10 手术安排时间，申请时不需要
	s ancoplCode=$p(mainOperStr,"|",2)
	s ancoplId=""
	i ancoplCode'="" s ancoplId=$o(^DHCANC("OPLevel",0,"Code",ancoplCode,""))
	s $p(opaStr,"^",11)=ancoplId 																//11 手术规模
	s $p(opaStr,"^",12)=+$p(opaStr,"^",12)							//opaPatHeight				//12 病人身高
	//s $p(opaStr,"^",13)="平台" s $p(opaStr,"^",13)=-100			//opaPatWeight				//13 病人体重
	i $p(opaStr,"^",13)=+$p(opaStr,"^",13)
	s $p(opaStr,"^",14)=""	//暂!!									//opaPreDiscussDate			//14 术前讨论日期,暂无
	s $p(opaStr,"^",15)=""	//暂!!									//opaEstiOperDuration		//15 预计手术持续时间
	//16 opaOpDocNote																			//16 实习手术医生
	q:$p(opaStr,"^",17)="" "无HIS手术编号!"							//17 opaSeqNote				//17 医生手术编号//HIS手术号
	s $p(opaStr,"^",18)=""	//暂!!									//18 opaSeq					//18 手术台次
	s $p(opaStr,"^",19)=##class(web.DHCClinicCom).ConvertToDateH($p(opaStr,"^",19))					//19.手术申请日期
	s $p(opaStr,"^",20)=##class(web.DHCClinicCom).ConvertToTimeH($p(opaStr,"^",20))					//20.手术申请时间
	s anmetCode=$$ALPHAUP^SSUTIL4($p(anaStr,"^",1))
	s anmetId=""
	i anmetCode'="" s anmetId=$o(^ORC("ANMET",0,"Code",anmetCode,""))							//1 麻醉方式Id
	
	s operId=""
	i $p(mainOperStr,"|",1)'=""  d
	.s operCode=$$ALPHAUP^SSUTIL4($p(mainOperStr,"|",1))
	.i operCode'="" s operId=$o(^ORC("OPER",0,"Code",operCode,""))
	
	s $p(anaopStr,"^",1)=operId_"|"_$p(mainOperStr,"|",2)_"|"_$p(mainOperStr,"|",3)                                                              //1 手术名称Id
	s mainOperName=$p(mainOperStr,"|",3)
	q:mainOperName="" "未找到手术代码!"
    s preMrcid=$p(anaopStr,"^",2)
    i $p($G(preMrcid),"|",1)'=""  d
	.s preMrcidCode=$$ALPHAUP^SSUTIL4($p(preMrcid,"|",1))
	.s mrcidId=""
	.i preMrcidCode'="" s mrcidId=$o(^MRC("ID",0,"Code",preMrcidCode,""))
	.s $p(anaopStr,"^",2)=mrcidId_"|"_$p(preMrcid,"|",2)										//2 术前诊断Id
	e  d
	.s $p(anaopStr,"^",2)=preMrcid
	;s preMrcidCode=$$ALPHAUP^SSUTIL4($p(anaopStr,"^",2))
	;s mrcidId=""
	;i preMrcidCode'="" s mrcidId=$o(^MRC("ID",0,"Code",preMrcidCode,""))
	;s $p(anaopStr,"^",2)=mrcidId																//2 术前诊断Id
	s $p(anaopStr,"^",3)=##class(web.DHCClinicCom).GetCtcpIdByInitials($p(anaopStr,"^",3))			//3 主刀医生Id
	q:($p(anaopStr,"^",3)="")&($p(opaStr,"^",16)="") "无主刀医生!"
	;q:$p(anaopStr,"^",3)="" "无主刀医生!"
	//4 operNotes																				//4 诊断备注
	s $p(anaopStr,"^",5)=##class(web.DHCClinicCom).GetCtlocIdByCodeOrDesc($p(anaopStr,"^",5),"Code") //5.手术室Id
	q:$p(anaopStr,"^",5)="" "无手术室!"
	s bodsCode=$$ALPHAUP^SSUTIL4($p(anaopStr,"^",6))
	s bodsId=""
	i bodsCode'="" s bodsId=$o(^OEC("BODS",0,"Code",bodsCode,""))
	s $p(anaopStr,"^",6)=bodsId																	//6 手术部位Id
	s opposCode=$$ALPHAUP^SSUTIL4($p(anaopStr,"^",7))
	s opposId=""
	i opposCode'="" s opposId=$o(^ORC("OPPOS",0,"Code",opposCode,""))
	s $p(anaopStr,"^",7)=opposId																//7 手术体位Id
	s $p(assDocStr,"^",1)=##class(web.DHCClinicCom).GetCtcpIdByInitials($p(assDocStr,"^",1))	//1 第一手术助手Id
	s $p(assDocStr,"^",2)=##class(web.DHCClinicCom).GetCtcpIdByInitials($p(assDocStr,"^",2))	//2 第二手术助手Id
	s $p(assDocStr,"^",3)=##class(web.DHCClinicCom).GetCtcpIdByInitials($p(assDocStr,"^",3))	//3 第三手术助手Id
	s $p(assDocStr,"^",4)=##class(web.DHCClinicCom).GetCtcpIdByInitials($p(assDocStr,"^",4))	//4 第四手术助手Id
	s $p(assDocStr,"^",5)=##class(web.DHCClinicCom).GetCtcpIdByInitials($p(assDocStr,"^",5))	//5 第五手术助手Id
	
																	//1 HbsAg 
																	//2 HCVAb
																	//3 HivAb
																	//4 梅毒
	i $p(arrStr,"^",5)="" s $p(arrStr,"^",5)=0						//5 急诊/择期 1/0
																	//6 其它
																	//7 opaRHBloodType RH血型
	f i=8:1:13 d
	    .i "YN"'[$p(arrStr,"^",i)="" s $p(arrStr,"^",i)=""			//8 opaIsolated    是否隔离
																	//9 opaPrepareBlood 是否备血
																	//10 opaUseSelfBlood 是否自体血
																	//11 opaExCirculation 是否体外循环
																	//12 opaNeedAnaesthetist 是否需要麻醉
																	//13.opaMiniInvasive 是否微创
	s subOperStr=""
	s curOperId=""
	f i=2:1:$l(operStr,"^") d
	    .s curOperStr=$p(operStr,"^",i)
	    .i $p(curOperStr,"|",1)'="" d
	    ..s curOperCode=$$ALPHAUP^SSUTIL4($p(curOperStr,"|",1))
	    ..s curOperId=""
	    ..i curOperCode'="" d
	    ...s curOperId=$o(^ORC("OPER",0,"Code",curOperCode,""))
	    ...q:curOperId=""
	    .e  d
	    ..s curOperCode=$p(curOperStr,"|",3)
	    ..s curOperId=$o(^ORC("OPER",0,"Desc",curOperCode,curOperId))
	    ..q:curOperId=""
	    .i subOperStr'="" s subOperStr=subOperStr_"^"
	    .s subOperStr=subOperStr_curOperId_"|"_$p(curOperStr,"|",2)_"|"_$p(curOperStr,"|",3)
 
	//s ^tmpANDebug("insertSubOperNew")=subOperStr
    /*
	s opaId=##class(web.UDHCANOPArrange).insertAnRecord("", "", opaStr, anaopStr, assDocStr, arrStr, anmetId)
	q:opaId'=+opaId opaId
	s anaId=$p(^DHCANOPArrange(opaId),"^",2)
	s retStr=##class(web.UDHCANOPArrange).insertchlop("", "", anaId, subOperStr)
	q:retStr'="操作成功!" "插入附加手术错!"
	q opaId
	*/
	s tmpOpaId="",opaId=""
	f  s tmpOpaId=$o(^DHCANOPArrange(0,"Adm",$p(opaStr,"^",6),tmpOpaId)) q:tmpOpaId=""  d
	    .s opaSeqNote=$p(^DHCANOPArrange(tmpOpaId),"^",41)
	    .i opaSeqNote=$p(opaStr,"^",17) s opaId=tmpOpaId
	
	s retStr=""
	i opaId="" d
	    .s retStr=##Class(web.UDHCANOPArrange).insertAnRecord("", "", opaStr, anaopStr, assDocStr, arrStr, anmetId)
	    .q:retStr'=+retStr
	    .i retStr<1 s retStr="插入手术申请有误!" q
	    .s opaId=retStr
	    .s anaId=$p(^DHCANOPArrange(opaId),"^",2)
	    .s retStr=##Class(web.UDHCANOPArrange).insertchlop("","",anaId,subOperStr)
	    .i retStr=0 s retStr=opaId
	    .
	e  d
	    .s retStr=##Class(web.UDHCANOPArrange).updatewardRecord("", "", opaId, opaStr, anaopStr, assDocStr, arrStr, anmetId)
	    .q:retStr'=0
	    .s anaId=$p(^DHCANOPArrange(opaId),"^",2)
	    .s retStr=##Class(web.UDHCANOPArrange).insertchlop("","",anaId,subOperStr)
	    .i retStr=0 s retStr=opaId

	q retStr
ERROR	; 
	s ErrorMsg=$ZE	           //得到系统返回的错误消息
 	q "接口服务调用错:"_ ErrorMsg
}

/// -------------------------------------------------------------------------------------------------
/// Creator：      	zt
/// CreatDate：    	2011-08-17
/// Description： 	插入门诊手术申请
/// Table：        	DHC_AN_OPArrange,OR_Anaesthesia,OR_Anaest_Operation,OR_An_Oper_Assistant,OR_An_Oper_Position
/// Input：        	appLocCode: 申请手术科室代码
///                 appDocCode:申请医生代码
///                 opDate:手术日期
///                 opTime:手术时间
///                 admId:  就诊id
///                 operLocCode:手术室代码
///                 operCode:手术名称代码
///                 operNote:手术医师备注 （医嘱备注）
/// Output：       
/// Return：       	手术申请RowID，其他-异常返回信息
ClassMethod InsertAnopApplyForOp(appLocCode As %String, appDocCode As %String, opDate As %String, opTime As %String, admId As %String, operLocCode As %String, operCode As %String, operNote As %String) As %String [ ProcedureBlock = 0 ]
{
	new (appLocCode,appDocCode,opDate,opTime,admId,operLocCode,operCode,operNote)
	s ^tempwhl("InsertAnopApplyForOp")=appLocCode_"666666"
	//s appLocCode="1500010",appDocCode="00967",opDate="22/08/2011",opTime="11:00",admId="545",operLocCode="1270070",operCode="1"
	s $zt="ERROR"
	q:operCode="" "主手术代码为空！"
	s opaStr=appLocCode_"^"_appDocCode_"^"_opDate_"^"_opTime_"^"_appDocCode_"^"_admId_"^^^^^^^^^^"_operNote_"^^^^"
	s ^tempwhl("opaStr$h",$h)=opaStr
	s assDocStr="",arrStr="",anaStr=""
	//arrStr:  HbsAg^HCVAb^HivAb^梅毒^急诊/择期 1/0^其它^RH血型^是否隔离Y/N^是否备血Y/N^是否自体血Y/N^是否体外循环Y/N^是否需要麻醉Y/N^是否微创Y/N
	s arrStr="未查^未查^未查^未查^0^其他^阳性^N^Y^N^Y^Y^Y"
	s operStr=operCode_"||"
	s anaopStr="^^^^"_operLocCode_"^^"
	s mainOperStr=$p(operStr,"^",1)
	s mainOperName=$p(mainOperStr,"|",3)
	//q:mainOperName="" "主手术为空！"
	b ;"1"
	s $p(opaStr,"^",1)=##class(web.DHCClinicCom).GetCtlocIdByCodeOrDesc($p(opaStr,"^",1),"Code")	//1  实施手术科室Id
	q:$p(opaStr,"^",1)="" "无手术实施科室!"
	b ;"2"
	s $p(opaStr,"^",2)=##class(web.DHCClinicCom).GetCtcpIdByInitials($p(opaStr,"^",2))				//2  申请医生Id
	q:$p(opaStr,"^",2)="" "无手术申请医生!"
	b ;"3"
	s $p(opaStr,"^",3)=##class(web.DHCClinicCom).ConvertToDateH($p(opaStr,"^",3))					//3  手术日期
	q:$p(opaStr,"^",3)="" "无手术申请日期!"
	b ;"4"
	s $p(opaStr,"^",4)=##class(web.DHCClinicCom).ConvertToTimeH($p(opaStr,"^",4))					//4  手术时间
	q:$p(opaStr,"^",4)="" "无手术申请时间!"
	b ;"5"
	s $p(opaStr,"^",5)=##class(web.DHCClinicCom).GetUserIdByInitials($p(opaStr,"^",5))				//5  申请用户Id
	q:$p(opaStr,"^",6)="" "就诊号为空!"  //s $p(opaStr,"^",6)=EpisodeID							//6  就诊号，平台提供
	b ;"6"
	/*s oprCode=$p(opaStr,"^",7)
	s tmpOprId=0,oprId=""
	f  s tmpOprId=$o(^DHCANC("OPRoom",tmpOprId)) q:tmpOprId=""  d
	    .i oprCode=$p(^DHCANC("OPRoom",tmpOprId),"^") s oprId=tmpOprId
	q:oprId="" "没有手术间!"
	s $p(opaStr,"^",7)=oprId //手术间 */														//7  手术间 申请不需要
    s $p(opaStr,"^",7)=""    //暂!!
	//opaMemo	
																				//8  手术要求
	s bldtCode=$$ALPHAUP^SSUTIL4($p(opaStr,"^",9))
	s bldtId=""
	i bldtCode'="" s bldtId=$o(^PAC("BLDT",0,"Code",bldtCode,""))
	s $p(opaStr,"^",9)=bldtId																	//9  血型Id
	s $p(opaStr,"^",10)=""
	//10 opaArrangeTime																			//10 手术安排时间，申请时不需要
	s ancoplCode=$p(mainOperStr,"|",2)
	s ancoplId=""
	i ancoplCode'="" s ancoplId=$o(^DHCANC("OPLevel",0,"Code",ancoplCode,""))
	s $p(opaStr,"^",11)=ancoplId 																//11 手术规模
	s $p(opaStr,"^",12)=+$p(opaStr,"^",12)							//opaPatHeight				//12 病人身高
	//s $p(opaStr,"^",13)="平台" s $p(opaStr,"^",13)=-100			//opaPatWeight				//13 病人体重
	i $p(opaStr,"^",13)=+$p(opaStr,"^",13)
	s $p(opaStr,"^",14)=""	//暂!!									//opaPreDiscussDate			//14 术前讨论日期,暂无
	s $p(opaStr,"^",15)=""	//暂!!									//opaEstiOperDuration		//15 预计手术持续时间
	//16 opaOpDocNote																			//16 实习手术医生
	//q:$p(opaStr,"^",17)="" "无HIS手术编号!"							//17 opaSeqNote				//17 医生手术编号//HIS手术号
	s $p(opaStr,"^",18)=""	//暂!!									//18 opaSeq					//18 手术台次
	s $p(opaStr,"^",19)=##class(web.DHCClinicCom).ConvertToDateH($p(opaStr,"^",19))					//19.手术申请日期
	s $p(opaStr,"^",20)=##class(web.DHCClinicCom).ConvertToTimeH($p(opaStr,"^",20))					//20.手术申请时间
	s anmetCode=$$ALPHAUP^SSUTIL4($p(anaStr,"^",1))
	s anmetId=""
	i anmetCode'="" s anmetId=$o(^ORC("ANMET",0,"Code",anmetCode,""))							//1 麻醉方式Id
	s operId=""
	i $p(mainOperStr,"|",1)'=""  d
	.s operCode=$$ALPHAUP^SSUTIL4($p(mainOperStr,"|",1))
	.i operCode'="" s operId=$o(^ORC("OPER",0,"Code",operCode,""))
	q:operId="" "无对应手术ID"
	b ;"7"
	s $p(anaopStr,"^",1)=operId_"|"_$p(mainOperStr,"|",2)_"|"_$p(mainOperStr,"|",3)                                                              //1 手术名称Id
	//s mainOperName=$p(mainOperStr,"|",3)
	//q:mainOperName="" "未找到手术代码!"
    s preMrcid=$p(anaopStr,"^",2)
    i $p($G(preMrcid),"|",1)'=""  d
	.s preMrcidCode=$$ALPHAUP^SSUTIL4($p(preMrcid,"|",1))
	.s mrcidId=""
	.i preMrcidCode'="" s mrcidId=$o(^MRC("ID",0,"Code",preMrcidCode,""))
	.s $p(anaopStr,"^",2)=mrcidId_"|"_$p(preMrcid,"|",2)										//2 术前诊断Id
	e  d
	.s $p(anaopStr,"^",2)=preMrcid
	;s preMrcidCode=$$ALPHAUP^SSUTIL4($p(anaopStr,"^",2))
	;s mrcidId=""
	;i preMrcidCode'="" s mrcidId=$o(^MRC("ID",0,"Code",preMrcidCode,""))
	;s $p(anaopStr,"^",2)=mrcidId																//2 术前诊断Id
	s $p(anaopStr,"^",3)=##class(web.DHCClinicCom).GetCtcpIdByInitials($p(anaopStr,"^",3))			//3 主刀医生Id
	//q:($p(anaopStr,"^",3)="")&($p(opaStr,"^",16)="") "无主刀医生!"
	;q:$p(anaopStr,"^",3)="" "无主刀医生!"
	//4 operNotes	
																			//4 诊断备注
	s $p(anaopStr,"^",5)=##class(web.DHCClinicCom).GetCtlocIdByCodeOrDesc($p(anaopStr,"^",5),"Code") //5.手术室Id
	q:$p(anaopStr,"^",5)="" "无手术室!"
	s bodsCode=$$ALPHAUP^SSUTIL4($p(anaopStr,"^",6))
	s bodsId=""
	i bodsCode'="" s bodsId=$o(^OEC("BODS",0,"Code",bodsCode,""))
	s $p(anaopStr,"^",6)=bodsId																	//6 手术部位Id
	s opposCode=$$ALPHAUP^SSUTIL4($p(anaopStr,"^",7))
	s opposId=""
	i opposCode'="" s opposId=$o(^ORC("OPPOS",0,"Code",opposCode,""))
	s $p(anaopStr,"^",7)=opposId																//7 手术体位Id
	s $p(assDocStr,"^",1)=##class(web.DHCClinicCom).GetCtcpIdByInitials($p(assDocStr,"^",1))	//1 第一手术助手Id
	s $p(assDocStr,"^",2)=##class(web.DHCClinicCom).GetCtcpIdByInitials($p(assDocStr,"^",2))	//2 第二手术助手Id
	s $p(assDocStr,"^",3)=##class(web.DHCClinicCom).GetCtcpIdByInitials($p(assDocStr,"^",3))	//3 第三手术助手Id
	s $p(assDocStr,"^",4)=##class(web.DHCClinicCom).GetCtcpIdByInitials($p(assDocStr,"^",4))	//4 第四手术助手Id
	s $p(assDocStr,"^",5)=##class(web.DHCClinicCom).GetCtcpIdByInitials($p(assDocStr,"^",5))	//5 第五手术助手Id

																	//1 HbsAg 
																	//2 HCVAb
																	//3 HivAb
																	//4 梅毒
	i $p(arrStr,"^",5)="" s $p(arrStr,"^",5)=0						//5 急诊/择期 1/0
    i $zd(opDate)=$zd($h) s $p(arrStr,"^",5)=1																	//6 其它
																	//7 opaRHBloodType RH血型
	f i=8:1:13 d
	    .i "YN"'[$p(arrStr,"^",i)="" s $p(arrStr,"^",i)=""			//8 opaIsolated    是否隔离
																	//9 opaPrepareBlood 是否备血
																	//10 opaUseSelfBlood 是否自体血
																	//11 opaExCirculation 是否体外循环
																	//12 opaNeedAnaesthetist 是否需要麻醉
																	//13.opaMiniInvasive 是否微创
	s subOperStr=""
	s curOperId=""
	f i=2:1:$l(operStr,"^") d
	    .s curOperStr=$p(operStr,"^",i)
	    .i $p(curOperStr,"|",1)'="" d
	    ..s curOperCode=$$ALPHAUP^SSUTIL4($p(curOperStr,"|",1))
	    ..s curOperId=""
	    ..i curOperCode'="" d
	    ...s curOperId=$o(^ORC("OPER",0,"Code",curOperCode,""))
	    ...q:curOperId=""
	    .e  d
	    ..s curOperCode=$p(curOperStr,"|",3)
	    ..s curOperId=$o(^ORC("OPER",0,"Desc",curOperCode,curOperId))
	    ..q:curOperId=""
	    .i subOperStr'="" s subOperStr=subOperStr_"^"
	    .s subOperStr=subOperStr_curOperId_"|"_$p(curOperStr,"|",2)_"|"_$p(curOperStr,"|",3)
 
	s tmpOpaId="",opaId=""
	/*f  s tmpOpaId=$o(^DHCANOPArrange(0,"Adm",$p(opaStr,"^",6),tmpOpaId)) q:tmpOpaId=""  d
	    .s opaSeqNote=$p(^DHCANOPArrange(tmpOpaId),"^",41)
	    .i opaSeqNote=$p(opaStr,"^",17) s opaId=tmpOpaId*/
	
	s retStr=""
	b ;"8"
	i opaId="" d
	    .s retStr=##Class(web.UDHCANOPArrange).insertAnRecord("", "", opaStr, anaopStr, assDocStr, arrStr, anmetId)
	    .q:retStr'=+retStr
	    .b ;5
	    .i retStr<1 s retStr="插入手术申请有误!" q
	    .s opaId=retStr
	    .s anaId=$p(^DHCANOPArrange(opaId),"^",2)
	    .s retStr=##Class(web.UDHCANOPArrange).insertchlop("","",anaId,subOperStr)
	    .i retStr=0 s retStr=opaId_"^"_anaId
	    .
	e  d
	    .s retStr=##Class(web.UDHCANOPArrange).updatewardRecord("", "", opaId, opaStr, anaopStr, assDocStr, arrStr, anmetId)
	    .q:retStr'=0
	    .s anaId=$p(^DHCANOPArrange(opaId),"^",2)
	    .s retStr=##Class(web.UDHCANOPArrange).insertchlop("","",anaId,subOperStr)
	    .i retStr=0 s retStr=opaId_"^"_anaId
	b ;"9"
	q retStr
ERROR	;
	TRO 
	s ErrorMsg=$ZE	           //得到系统返回的错误消息
 	q "接口服务调用错:"_ ErrorMsg
}

/// ---------------------------------------------------------------------------------------
ClassMethod AnopApplyParaAdapter(opaStr As %String, anaStr As %String, anaopStr As %String, assDocStr As %String, arrStr As %String, operStr As %String) As %String
{
	s retStr=##class(web.DHCANAdaptor).InsertAnopApply(opaStr,anaStr,anaopStr,assDocStr,arrStr,operStr)
}

/// DHC_AN_OPArrange     
/// OPA_SeqNote：手术台次
ClassMethod DeleteAnopApply(opaSeqNote As %String, opaAppDate As %String) As %String
{
	q:opaSeqNote="" "病人账号不能为空！"
	q:opaAppDate="" "手术申请时间不能为空！"
    
    s $zt="ERROR"
	s retStr="-1"
	TSTART
	s opaAppDate=$ZDH(opaAppDate,4)
	s opaRowId=""
	f  s opaRowId=$O(^DHCANOPArrange(0,"AppDate",opaAppDate,opaRowId)) q:opaRowId=""  d
	.s seqNote=$p($g(^DHCANOPArrange(opaRowId)),"^",41)
	.q:(opaSeqNote'=seqNote)||(seqNote="")
	.s opaStatus=$p($g(^DHCANOPArrange(opaRowId)),"^",27)
	.q:opaStatus=""
	.i opaStatus="A"  d ;申请单的状态为A,可以删除
	..&sql(delete from SQLUSER.DHC_AN_OPArrange where OPA_SeqNote=:opaSeqNote)
	..s retStr=opaRowId
	..i SQLCODE'=0 TRollBack
	.i opaStatus'="A"  d ;申请单的状态不为A,不可以删除
	..s retStr="-1"
	TCOMMIT
	q retStr
ERROR	; 
	s ErrorMsg=$ZE	           //得到系统返回的错误消息
 	q "接口服务调用错:"_ ErrorMsg
}

/// Creator：      	ypz
/// CreatDate：    	2011-07-05
/// Description： 	查询病人手术情况
/// Table：        	DHC_AN_OPArrange,OR_Anaesthesia
/// Input：        	EpisodeID
/// Output：        
/// Return：       	以"^"分割的串：是否有手术申请(Y/N)^是否完成手术(Y/N)
ClassMethod GetAdmOperationInfo(EpisodeID As %String) As %String
{
	s retStr="N^N"
	q:EpisodeID="" retStr
	s opaId="",ifFinish="Y"
	f  s opaId=$o(^DHCANOPArrange(0,"Adm",EpisodeID,opaId)) q:opaId=""  d
		.q:'$d(^DHCANOPArrange(opaId))
		.s opaStatus=$P(^DHCANOPArrange(opaId),"^",27)
		.q:"D"[opaStatus
		.s $p(retStr,"^")="Y"
		.i opaStatus'="F" s ifFinish="N"
	s $p(retStr,"^",2)=ifFinish
	q retStr
}

// 根据就诊号，和手术编码撤销手术 modify by whl 20130307,医生站侧小医嘱时调用接口

ClassMethod CancleOperationInfobyAdm(EpisodeID As %String, opercode As %String, stdate As %String) As %String
{
	s status="F"
	q:EpisodeID=""
	s adm=EpisodeID
	s sdate=##Class(web.DHCClinicCom).ConvertToDateH(stdate)
	s opaId="",chl=0,id="",code=""
	f  s opaId=$o(^DHCANOPArrange(0,"Adm",EpisodeID,opaId)) q:opaId=""  d
		.q:'$d(^DHCANOPArrange(opaId))
		.s opstdate=$P(^DHCANOPArrange(opaId),"^",14)
		.q:sdate'=opstdate
		.s chl=$P($P(^DHCANOPArrange(opaId),"^",2),"||",2)
		.s subchl=0 f  s subchl=$O(^OR(adm,"ANA",chl,"OP",subchl)) q:(subchl="")  d 
		..s opdr=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",6)       		;ANAOP_Type_DR     ；手术名称
		..q:opdr=""
		..s code=$p($g(^ORC("OPER",opdr)),"^",1) 
        .q:code'=opercode
        .s id=opaId
	&sql(update SQLUSER.DHC_AN_OPArrange set OPA_Status=:status where OPA_RowId=:id)
	q:SQLCODE'=0 "撤销手术成功！"
}

/// d ##class(web.DHCANAdaptor).Test()
ClassMethod Test() As %String
{
	 s count=0
	 s resultString=""
	 //s end=start+limit-1
	 //w ##class(herp.bone.udata.uDonateConsentNotify).Import()
	 // Create an instance of %XML.Reader
	 // Begin processing of the file
	 //Do reader.OpenFile("test.xml")
	 //s ret= ##class(web.DHCInterfaceAnOperation).GetLocOperPatInfo(831)
	 //w ##class(herp.bone.udata.uDonateConsentNotify).Import("2009-11-01","2009-11-02","","",0,25,"")
	// s ret=##class(web.DHCANAdaptor).GetANOperation("2011-1-01","2011-11-08","","","")
	 s ret=##class(web.DHCANAdaptor).GetANOperation(66617,66617,238)
	  ;s ret=##class(web.DHCANAdaptor).GetANOperation(satrtDate,endDate,patDr,reqDept)
	 //s ret=##class(web.DHCANAdaptor).GetANOperation(satrtDate,endDate,patDr,reqDept,"")
	 Set reader = ##class(%XML.Reader).%New()
	 Do reader.OpenStream(ret)
	 // Associate a class name with the XML element name
	 //Do reader.Correlate("PatInfo","User.DHCInterfaceInPatientInfo")
	 Do reader.Correlate("PatInfo","web.DHCANInterface")
	 
	 //s json=##class(herp.bone.comm.JsonObj).%New()
	 //s jsonTitle="OpDate^OpName^OpDocCtcpId^AssistantFirstCtcpId^AssistantSecondCtcpId^AnaMethod^AnaDocCtcpId^ScrubNurFirstCtcpId^ScrubNurSecondCtcpId^ScrubNurThirdCtcpId^CirculNurFirstCtcpId^CirculNurSecondCtcpId^CirculNurThirdCtcpId^BodsDesc^EpisodeID^EpisodeName^state^sighDate^InformDoctor^ExcisionCondition^MainDiagnose^Age^Sex"
	//	_"^OPAStatus^Prediag^JzStat^OPAPatDeptDr^OPAAppLocDr^OpDoctor^AnaDoctor^OPAAppDate^OPAAdmDr^RegNo^OpaId^OPAOpRoomDr^OPASeq^OpTime^BodsDesc"
	 // Read objects from xml file
	 
	 While (reader.Next(.object,.sc)) {
		 w object.PatName,"/",object.AnaDoctor,"/",object.ScrubNurSecondCtcpId,"/",object.ANAOPCirculNurseDR,!
		 //Write object.BodsDesc_","_object.OpDocCtcpId_","_object.AssistantFirstCtcpId,!
		 s state="N"
		 s sighDate=""
		 s EpisodeName="" 
		 s InformDoctor=""  //洽谈医生
		 s ExcisionCondition="" //切除情况
		 s MainDiagnose="" //主要诊断
		 s ExcisionDept="" // 部位
		 //i object.EpisodeID'=""  d
		 i sighDate'="" s sighDate=$zd(sighDate,3)
		 ;w state_isConfim,! 
		 s tmp=object.OpDate_"^"_object.OpName_"^"_object.AssistantFirstCtcpId_"^"_object.AssistantSecondCtcpId_"^"_object.AnaMethod_"^"_object.AnaDocCtcpId_"^"_object.ScrubNurFirstCtcpId_"^"_object.ScrubNurSecondCtcpId_"^"_object.ScrubNurThirdCtcpId_"^"_object.CirculNurFirstCtcpId_"^"_object.CirculNurSecondCtcpId_"^"_object.CirculNurThirdCtcpId_"^"_object.BodsDesc_"^"_object.EpisodeID_"^"_EpisodeName_"^"_state_"^"_sighDate_"^"_InformDoctor_"^"_ExcisionCondition_"^"_MainDiagnose_"^"_object.Age_"^"_object.Sex_"^"_object.OPAStatus_"^"_object.Prediag_"^"_object.ANASourceTypeDesc_"^"_object.OPAPatDeptDr
		  _"^"_object.OPAAppLocDr_"^"_object.OpDoctor_"^"_object.AnaDoctor_"^"_object.OPAAppDate_"^"_object.OPAAdmDr_"^"_object.RegNo_"^"_object.OpaId
		   _"^"_object.OPAOpRoomDr_"^"_object.OPASeq_"^"_object.OpTime_"^"_ExcisionDept_"^"_object.OPAEndDateTime_"^"_object.OperPosition
		 //i (count>=start)&(count<=end)&((isConfim=state)||(isConfim="")) d
		 //.d json.InsertRowData(tmp)
		 w tmp,!
		 s count=count+1
		 //w "curCount=",count,!
	 }
	 
	 //s resultString = json.getJsonData(jsonTitle,count)
	 // If error found during processing, show it
	 If $system.Status.IsError(sc) do $system.OBJ.DisplayError(sc)
	
	 q resultString
}

/// Creator:     MaFuCheng
/// CreateDate:  2012-5-28
/// Description: 根据麻醉表ID或就诊号，获取最近一次手术身体部位对应医嘱
/// Table:       DHC_AN_Oparrange,麻醉表、手术表、DHCANCSiteProphyAntibiotics
/// Input:       麻醉ID，就诊号EpisodeID;当麻醉ID为空时才判断EpisodeID
/// Return:      医嘱码表Id串，用"^"分隔
ClassMethod GetArcimByOperSite(anaId As %String, EpisodeID As %String) As %String
{
	i (anaId="")&(EpisodeID'="") d  	   
		.s opaId=""
		.f  s opaId=$O(^DHCANOPArrange(0,"Adm",EpisodeID,opaId),-1) q:opaId=""  d
			..q:"D"[$P(^DHCANOPArrange(opaId),"^",27)	
			..s anaId=$P(^DHCANOPArrange(opaId),"^",2) ;手术麻醉Id  
	q:anaId="" ""
	s anaSub=$P(anaId,"||",2)
	s anaopSub=0,retStr=""
	f  s anaopSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)) q:anaopSub=""  d
		.//w anaopSub,!
		.q:$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",12)'="M"
		.s BladeTypeId=$P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",9) ;切口类型
		.s BladeTypeCode=$p($g(^ORC("BLDTP",+BladeTypeId)),"^",1)		
		.q:(BladeTypeCode'="I")	//"I"类切口
		.s bodsId=$p($g(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)),"^",24) ;身体部位			
		.f i=1:1:$l(bodsId,"|") d
			..s curBodsId=$p(bodsId,"|",i)
			..q:curBodsId=""						
			..s arcimIdStr=##Class(web.DHCANCSiteProphyAntibiotics).GetArcimByBodySite(curBodsId) //身体部位对应预防用药医嘱	
			..f j=1:1:$l(arcimIdStr,"^") d  
				...s arcimId=$p(arcimIdStr,"^",j)		 		
				...q:arcimId=""
				...q:("^"_retStr_"^")[("^"_arcimId_"^")
				...i retStr'="" s retStr=retStr_"^"
				...s retStr=retStr_arcimId			
	q retStr
}

/// 供时间线调用的方法
ClassMethod InsertTimeLine(stDate As %String, endDate As %String, EpisodeID As %String = "") As %String
{
	s stDate=##class(web.DHCClinicCom).ConvertToDateH(stDate,"")	
	s endDate=##class(web.DHCClinicCom).ConvertToDateH(endDate,"")
	s subNode="SDate"
	q:(stDate="")&(endDate="")&(EpisodeID="") ""
	//s userLocId= "", appType = ""
	//s linkLocId=##Class(web.DHCCLCom).GetLinkLocId(userLocId)
	//s userLocIdStr=linkLocId_"^"_userLocId
	//s userLocTyp=""
	//i userLocId'="" s userLocTyp=$P(^CTLOC(userLocId),"^",13)
	if (EpisodeID'="")
	{   
		s opaId=""
		f  s opaId=$O(^DHCANOPArrange(0,"Adm",EpisodeID,opaId)) q:opaId=""  d
			.d GetANTimeLine
	}
	else
	{  
		f date=+stDate:1:+endDate
		{
			s opaId=""
			f  s opaId=$O(^DHCANOPArrange(0,subNode,date,opaId)) q:opaId=""  d
				.d GetANTimeLine  
		}
	}
	q 0
GetANTimeLine
	s opaStatus=$P(^DHCANOPArrange(opaId),"^",27)
	
	q:("D"[opaStatus)
	k timeList
	s EpisodeID=$P(^DHCANOPArrange(opaId),"^",1)   ;就诊号
	s anaId=$P(^DHCANOPArrange(opaId),"^",2)
	s anaSub=$P(anaId,"||",2)
	s anaId=$P(^DHCANOPArrange(opaId),"^",2) ;手术麻醉Id
	s anaSub=$P(anaId,"||",2)
	s operDesc="",anaopSurgeon="",opposDesc=""
	s anaopSub=0 f  s anaopSub=$O(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)) q:(anaopSub="")  d  
		.s anaOPSurgeonDR=$P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",8)      ;ANAOP_Surgeon_DR  ；手术医师
		.s anaOpSurgeon=##class(web.DHCClinicCom).GetNameById(anaOPSurgeonDR)
		.s opdr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",6)       ;ANAOP_Type_DR；手术名称
		.q:opdr=""
		.i $D(^ORC("OPER",opdr)) d
			..i operDesc="" s operDesc=$P(^ORC("OPER",opdr),"^",2)
			..e  s operDesc=operDesc_","_$P(^ORC("OPER",opdr),"^",2)
	i $P(^DHCANOPArrange(opaId),"^",3)'="" s timeList("080101")="手术申请"_"^"_$P(^DHCANOPArrange(opaId),"^",3)_"^"_$P(^DHCANOPArrange(opaId),"^",5,6)
	
	i "AR"'[opaStatus
	{
		i $p(^OR(EpisodeID,"ANA",anaSub),"^",39)'="" s timeList("080102")="入室"_"^"_$p(^OR(EpisodeID,"ANA",anaSub),"^",39,40)_"^"
		s tmpStr=##class(web.DHCANOrder).GetAnoEventSingle(opaId,"AnaStart",1,"Y","Y","I")
		i $p(tmpStr,$c(3),2)'="" s timeList("080103")=$tr(tmpStr,$c(3),"^")
		s tmpStr=##class(web.DHCANOrder).GetAnoEventSingle(opaId,"OperStart",1,"Y","Y","I")
		i $p(tmpStr,$c(3),2)'="" s timeList("080104")=$tr(tmpStr,$c(3),"^")
		s tmpStr=##class(web.DHCANOrder).GetAnoEventSingle(opaId,"OperEnd",-1,"Y","Y","I")
		i $p(tmpStr,$c(3),2)'="" s timeList("080105")=$tr(tmpStr,$c(3),"^")
		s tmpStr=##class(web.DHCANOrder).GetAnoEventSingle(opaId,"AnaEnd",-1,"Y","Y","I")
		i $p(tmpStr,$c(3),2)'="" s timeList("080106")=$tr(tmpStr,$c(3),"^")
		i $p(^OR(EpisodeID,"ANA",anaSub),"^",41)'="" s timeList("080107")="离室"_"^"_$p(^OR(EpisodeID,"ANA",anaSub),"^",41,42)_"^"
	}
	
	s actCode=""
	f  s actCode=$o(timeList(actCode)) q:actCode=""  d
		.//w opaId_"/"_opaStatus_"/"_actCode_"/"_timeList(actCode),!
		.s obj=##class(icare.entity.ClinicalRepository).%New()
		.s obj.ActCode=actCode
		.s obj.ActDate=$p(timeList(actCode),"^",2)
		.s obj.ActTime=$p(timeList(actCode),"^",3)
		.s obj.CareProviderID=$p(timeList(actCode),"^",4)
		.s obj.DataTypeCode="0801"
		.s obj.DataValue=$p(timeList(actCode),"^",1)
		.s obj.EpisodeID=EpisodeID
		.s obj.ObjectID=opaId
		.s obj.Summary=operDesc
		.s obj.Parameters="websys.default.csp?WEBSYS.TCOMPONENT=UDHCANOPAPP&opaId="_opaId_"&appType=ward"
		.//w obj.Parameters
		.s retStr=##class(icare.TimeLineService.BOClinicalRepository).Insert(obj)
		.d obj.%Close()
	q
	//s oproomdr=$P(^DHCANOPArrange(opaId),"^",20)
	//i oproomdr'="" s opaOpRoom=$p($g(^DHCANC("OPRoom",oproomdr)),"^",2)
}

ClassMethod GetAsA(rowid As %String) As %String
{
 s ASA="",adm="",ASAId="",opaId=""
 s opaId=rowid
 q:opaId=""
 s adm=$P(^DHCANOPArrange(opaId),"^",1)
 s chl=$P($P(^DHCANOPArrange(opaId),"^",2),"||",2)
 s ASAId=$P($g(^OR(adm,"ANA",chl)),"^",26) ;ASA分级
 i ASAId="" q 0
 s ASA=$P($g(^ORC("ASA",ASAId)),"^",2) ;ASA
 q ASA
}

/// 更新ASA等级w ##Class(web.DHCANAdaptor).SetAsA() 获取ASA
/// 入参为手术排班表Id，ASA分级的描述，前提先在his中维护相关的asa分级数据
/// 返回0：插入成功，-1，码表中无相关数据
ClassMethod SetAsA(opaRowID As %String, ASAdesc As %String)
{
 s ASA="",adm="",ASA="",chl="",opaId="",desc=""
 s opaId=opaRowID
 s ASAId=""
 f  s ASAId=$O(^ORC("ASA",ASAId)) q:ASAId=""  d
   .s desc=$p(^ORC("ASA",ASAId),"^",2)
   .i desc=ASAdesc  s ASA= $p(^ORC("ASA",ASAId),"^",1)
 q:opaId=""
 s adm=$P(^DHCANOPArrange(opaId),"^",1)
 s chl=$P($P(^DHCANOPArrange(opaId),"^",2),"||",2)
 s $P(^OR(adm,"ANA",chl),"^",26)=ASA
 i ASA="" q -1
 i ASA'="" q 0
}

// 人参数ADM号，需要返回这个患者的手术总例数^清洁手术例数^择期手术例数

// w ##class(web.DHCANAdaptor).GetOpcount(80)

ClassMethod GetOpcount(adm As %String) As %String
{
	 s count=0,count1=0,count2=0
	 s resultString=""
	 s ret=##class(web.DHCANAdaptor).GetANOperation("","",adm,"","R")
	 b ;"1"
	 Set reader = ##class(%XML.Reader).%New()
	 Do reader.OpenStream(ret)
	 Do reader.Correlate("PatInfo","web.DHCANInterface")	 
	 While (reader.Next(.object,.sc)) {
		 w object.PatName,"/",object.AnaDoctor,"/",object.ScrubNurSecondCtcpId,"/",object.ANAOPCirculNurseDR,!
		 s chl=$P($P(^DHCANOPArrange(object.OpaId),"^",2),"||",2)
		 s jz=$P(^OR(adm,"ANA",chl),"^",32) //ANA_SourceType 急诊(E)/择期(B)
		 i jz="E" s jzstat="急诊"
		 e  i jz="B" s jzstat="择期"
		 e  s jzstat="超时"
		 s count=count+1 ;总例数
		 i jzstat="择期" s count2=count2+1 ;择期手术例数
		 i object.ANAOPBladeType="I" s count1=count1+1 ;切口为清洁手术的例数
		 s resultString=count_"^"_count1_"^"_count2
	 }
	 If $system.Status.IsError(sc) do $system.OBJ.DisplayError(sc)
	 q resultString
}

// ADM号和手术日期，返回手术的ASA分级^手术开始日期^时间^手术结束日期^时间 不同手术用"|"分割

ClassMethod GetOpASAanddatetime(adm As %String, stdate As %String) As %String
{
	 i stdate="" s stdate=""
	 e  s stdate=##class(web.DHCClinicCom).ConvertToDateH(stdate)	
	 
	 s resultString="",opstdatetime="",openddatetime="",result="",admid=""
	 s admid=adm
	 s ret=##class(web.DHCANAdaptor).GetANOperation(stdate,"",adm,"","R")
	 Set reader = ##class(%XML.Reader).%New()
	 Do reader.OpenStream(ret)
	 Do reader.Correlate("PatInfo","web.DHCANInterface")	
	 b ;"1" 
	 While (reader.Next(.object,.sc)) {
		 s chl=$P($P(^DHCANOPArrange(object.OpaId),"^",2),"||",2)
		 b ;"3"
		 s ASA=..GetAsA(object.OpaId)
		 s opstdatetime=object.OPAStartDateTime ;手术开始日期时间
	     s openddatetime=object.OPAEndDateTime ;手术结束日期时间
		 s resultString=object.OpaId_"^"_ASA_"^"_opstdatetime_"^"_openddatetime_"|"
	 }
	 If $system.Status.IsError(sc) do $system.OBJ.DisplayError(sc)
	 q resultString
}

// 测试用

ClassMethod GetDevInfo(equipId As %String, devIP As %String, devPort As %String, interfaceProgram As %String = "PhilipsMP", anoSource As %String = "QR") As %String
{
	// w ##class(web.DHCANAdaptor).GetDevInfo(4,"10.150.69.19",24105)
	// w ##class(web.DHCNurCom).GetDevInfo(2,"10.136.24.17",24105)
	s objDeviceServer=##class(web.DHCEKGService.OAICUDevSrvSoap).%New() 
	s mIP=$g(^DHCCLSet("MSrvIP"))   
    i mIP'="" d
    .s mIP="10.160.16.110"
    .s locStr=objDeviceServer.Location
    .s $p(locStr,"/",3)=mIP ;
    .s objDeviceServer.Location=locStr

    w objDeviceServer.Location,!
	s retStr=objDeviceServer.GetDevInfo(equipId,devIP,devPort,interfaceProgram, anoSource)
	q retStr
}

// Return:patName^patSex^birth^otherInfo

// w ##class(web.DHCANAdaptor).GetPatInfo(876,"I")

ClassMethod GetPatInfo(pId As %String, idType = "")
{
	S $ZT="ERROR"
	s logDate=+$h
	s logTime=$p($h,",",2)
	s ^DHCANICUDEBUG("GetPatInfo",logDate,logTime)=pId_","_idType
	// w ##class(web.DHCANAdaptor).GetPatInfo("2000563","")
	// w ##class(web.DHCANAdaptor).GetPatInfo("1","I")
	// w ##class(web.DHCANAdaptor).GetPatInfo("1","A")
	i idType=$c(0) s idType=""
	
	
	s sub="" s patName="" s EpisodeID="" s papmiId="" s medCareNo="" s icuaId="" s patSex="" s birth="" s anIcuInfo=""
	i pId="" q "1:NoPatInfo"
	i idType="I"  d
	.s icuaId=pId 
	.s episodeID=$p($g(^DHCICUArrange(pId)),"^",1)
	.s bedId=$p($g(^DHCICUArrange(pId)),"^",4)
	.
	.i episodeID'="" s papmiId=$p($g(^PAADM(episodeID)),"^",1)
	.i bedId'="" d
	..s wardId=$p(bedId,"||",1)
	..s RoomDesc=$p(^PAWARD(wardId,"BED",$p(bedId,"||",2)),"^",1)
	..s wardDesc=$p(^PAWARD(wardId),"^",2)
	..s anIcuInfo=$p(wardDesc,"-",2)_"^Bed"_RoomDesc
	e  i idType="A" d
	.s EpisodeID=$p($g(^DHCANOPArrange(pId)),"^",1)
	.s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
	.s oproomdr=$P(^DHCANOPArrange(pId),"^",20)
	.
	.s floorId="",oproomdes="",oprFloor=""
	.i oproomdr'="" s oproomdes=$p($g(^DHCANC("OPRoom",oproomdr)),"^",2)
	.i oproomdr'="" s floorId=$p($g(^DHCANC("OPRoom",oproomdr)),"^",4)
	.e  s floorId=""
	.i floorId'="" s oprFloor=$P($G(^DHCANC("Floor",floorId)),"^",2)
	.s anIcuInfo=oprFloor_"^Room"_oproomdes
    e  i idType=""  d
    .d NOValueFun
	i papmiId'="" d
	.;设置病人信息
	.s isFind="true"
	.s medCareNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
	.s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	.s patSex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
	.s birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
		
	i papmiId=""  q "2:InvalidPatInfo"
	e  q patName_"^"_patSex_"^"_$zd(birth,3)_"^"_anIcuInfo
NOValueFun
	b
	s pId=$$UPPER^SSUTIL4(pId)
	// 若是检验号则通过检验号查找病人ID
	s tStr=$g(^TEPI(pId))
	s isFind="false"
	i tStr'=""  d
	.s pId=$p(tStr,"\",18) 
	.s papmiId=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(pId),""))
	e  d
	.;认为是病案号
	.w ";认为是病案号"
	.f  s sub=$O(^PAPERi("Medicare1",pId,sub)) q:((sub="")||(isFind="true"))  d
	..s itemStr=$g(^PAPER(sub,"PAT",1))
	..q:itemStr=""
	..s pId=$p(itemStr,"^",1)
	..i pId="" s pID=$p(itemStr,"^",2)
	..s isFind="true"
	..s papmiId=sub
	e  d
	.s papmiId=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(pId),""))
	q
ERROR	
	s retStr=$ZERROR
	s ^DHCANICUDEBUG("GetPatInfo")=pId_"^"_idType_"^"_retStr
	q $ZERROR
}

/// Creator：      	whl
/// CreatDate：    	2013-08-20
/// Description： 	查询病人手术情况
/// Table：        	,
/// Input：        	EpisodeID
/// d ##class(web.DHCANAdaptor).GetOperationInfoByAdm("3034264")
/// Return：       	以"^"分割  adm^手术ID!手术日期!状态^手术ID!手术日期!状态
///       状态R为安排  F为完成状态
ClassMethod GetOperationInfoByAdm(EpisodeID As %String) As %String
{
	s retStr=EpisodeID
	s opdate=""
	q:EpisodeID="" retStr
	s opaId="",ifFinish="Y"
	f  s opaId=$o(^DHCANOPArrange(0,"Adm",EpisodeID,opaId)) q:opaId=""  d
		.q:'$d(^DHCANOPArrange(opaId))
		.s opaStatus=$P(^DHCANOPArrange(opaId),"^",27)
		.s opdate=$ZD($P(^DHCANOPArrange(opaId),"^",14),3)
		.s retStr=retStr_"^"_opaId_"!"_opdate_"!"_opaStatus
	q retStr
}

/// Creator：      	mfc
/// CreatDate：    	2014-02-20
/// Description： 	特定范围内手术类型为延时的数据导出
/// Table：        	,
/// Input：        	FromDate开始日期，ToDate结束日期
/// ##class(web.DHCANAdaptor).GetOperationInfoByDate("2014-01-01","2014-01-31")
/// Return：       	可以直接显示出来或者保存到global中
ClassMethod GetOperationInfoByDate(FromDate As %String, ToDate As %String) As %String
{
	s admId="",tempmfc=""
	s FromDate=##class(web.DHCClinicCom).ConvertToDateH(FromDate)	
	s ToDate=##class(web.DHCClinicCom).ConvertToDateH(ToDate)
	f date=FromDate:1:ToDate
    {
	   s opaId=""
	   f  s opaId=$O(^DHCANOPArrange(0,"SDate",date,opaId)) q:(opaId="")  d
	   .s status=$P(^DHCANOPArrange(opaId),"^",27)
	   .q:(status="D")||(status="F")	    	    
	   .s adm=$P(^DHCANOPArrange(opaId),"^",1),admId=adm	  
	   .s anaId=$P(^DHCANOPArrange(opaId),"^",2)
	   .&sql(select * into :PLIST() from SQLUSER.OR_Anaesthesia where ANA_RowId=:anaId)
	   .s ANASourceType=PLIST(41)
	   .q:ANASourceType'="N"
	   .s opstdate=$P(^DHCANOPArrange(opaId),"^",14)
	   .s opsttime=$P(^DHCANOPArrange(opaId),"^",15)
	   .s papmiId=$p($g(^PAADM(admId)),"^",1)
	   .s paadmtype=$p($g(^PAADM(admId)),"^",2)
	   .s regno=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	   .s medCareNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
	   .s patname=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	   
	   .s sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
	   .s admLocId=$p($g(^PAADM(adm)),"^",4)
		.i admLocId'="" s admLocdes=$P($g(^CTLOC(admLocId)),"^",2)  //Add mfc 20131217 病人所在科室
		.i $l(admLocdes,"-")>1 s admLocdes=$p(admLocdes,"-",2)
		.i paadmtype="O" s admLocdes=admLocdes_"(门)"
		.e  s admLocdes=admLocdes
		.s chl=$P($P(^DHCANOPArrange(opaId),"^",2),"||",2)
		.s jz=$P(^OR(adm,"ANA",chl),"^",32)   						//ANA_SourceType 急诊(E)/择期(B)
		.i jz="E" s jzstat="急诊"
		.e  i jz="B" s jzstat="择期"
		.e  s jzstat="超时"
		.q:(jz'="N")
		.s i=0,opdes=""
		.s prediag="",diamen=""
			.s subchl=0 f  s subchl=$O(^OR(adm,"ANA",chl,"OP",subchl)) q:(subchl="")  d ///ck091117
				..s opdr=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",6)       		;ANAOP_Type_DR     ；手术名称
				..i opdr'=""  d   //ck091210
					...i $P($g(^ORC("OPER",+opdr)),"^",2)'="" d     ///ck091117
					....i opdes'="" s opdes=opdes_";"     ///ck091117
					....s opdes=opdes_$P($g(^ORC("OPER",+opdr)),"^",2)     ///ck091117
				..e  d
					...i $g(^OR(adm,"ANA",chl,"OP",subchl,"REM",2))'="" d
					....i opdes'="" s opdes=opdes_";"
					....s opdes=opdes_$G(^OR(adm,"ANA",chl,"OP",subchl,"REM",2))    ///ck091210
		..s docdr=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",8)
		..i docdr'="" s opdoc=##class(web.DHCClinicCom).GetNameById(docdr)
		..e  s opdoc=$TR($p($p(^DHCANOPArrange(opaId),"^",42),"|",2)," ","")
        .;w "手术Id:"_opaId_"^"_"开始时间:"_opstdate_"^"_"就诊号:"_admId_"^"_"登记号:"_regno_"^"_"手术名称"_opdoc_"^"_"病人:"_patname_"^"_"所在科室:"_admLocdes_"$"
        .;i tempmfc'="" s tempmfc=tempmfc_"手术Id:"_opaId_"^"_"开始时间:"_opstdate_"^"_"就诊号:"_admId_"^"_"登记号:"_regno_"^"_"住院号"_medCareNo_"^"_"手术名称"_opdoc_"^"_"病人:"_patname_"^"_"性别:"_sex_"^"_"所在科室:"_admLocdes_"^"_"类型:"_"jzstat"_"$"
        .;e  s tempmfc="手术Id:"_opaId_"^"_"开始时间:"_opstdate_"^"_"就诊号:"_admId_"^"_"登记号:"_regno_"^"_"住院号"_medCareNo_"^"_"手术名称"_opdoc_"^"_"病人:"_patname_"^"_"性别:"_sex_"^"_"所在科室:"_admLocdes_"^"_"类型:"_"jzstat"_"$"
        .s ^tempmfc(opaId)=opaId_"^"_$zdt(opstdate,3)_"^"_admId_"^"_regno_"^"_medCareNo_"^"_opdoc_"^"_patname_"^"_sex_"^"_admLocdes_"^"_jzstat
    }
}

/// Creator：      	mfc
/// CreatDate：    	2014-02-20
/// Description： 	特定范围内获取手术排班数据导出
/// Table：        	,
/// Input：        	FromDate开始日期，ToDate结束日期
/// d ##class(web.DHCANAdaptor).GetOperByDate("2014-03-01","2014-03-07")
/// Return：       	可以直接显示出来或者保存到global中
ClassMethod GetOperByDate(FromDate As %String, ToDate As %String) As %String
{
	s admId="",tempmfc=""
	s FromDate=##class(web.DHCClinicCom).ConvertToDateH(FromDate)	
	s ToDate=##class(web.DHCClinicCom).ConvertToDateH(ToDate)
	f date=FromDate:1:ToDate
    {
	   s opaId=""
	   f  s opaId=$O(^DHCANOPArrange(0,"SDate",date,opaId)) q:(opaId="")  d
	   .s status=$P(^DHCANOPArrange(opaId),"^",27)
	   .q:(status'="F")	    	    
	   .s adm=$P(^DHCANOPArrange(opaId),"^",1),admId=adm	  
	   .s anaId=$P(^DHCANOPArrange(opaId),"^",2)	 
	   .s opstdate=$P(^DHCANOPArrange(opaId),"^",14)
	   .s opsttime=$P(^DHCANOPArrange(opaId),"^",15)
	   .s papmiId=$p($g(^PAADM(admId)),"^",1)
	   .s paadmtype=$p($g(^PAADM(admId)),"^",2)
	   .s regno=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	   .s medCareNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
	   .s patname=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	   .s appCtcpId=$P(^DHCANOPArrange(opaId),"^",6)  //ypz 070318
	   .i appCtcpId'="" s appCtcpDesc=$p(^CTPCP(appCtcpId,1),"^",2)
	   .e  s appCtcpDesc=""  
	   .s sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
	   .s admLocId=$p($g(^PAADM(adm)),"^",4)
	   .q:admLocId'="40" //血管外科
		.i admLocId'="" s admLocdes=$P($g(^CTLOC(admLocId)),"^",2)  //Add mfc 20131217 病人所在科室
		.i $l(admLocdes,"-")>1 s admLocdes=$p(admLocdes,"-",2)
		.i paadmtype="O" s admLocdes=admLocdes_"(门)"
		.e  s admLocdes=admLocdes
		.s chl=$P($P(^DHCANOPArrange(opaId),"^",2),"||",2)
		.s jz=$P(^OR(adm,"ANA",chl),"^",32)   						//ANA_SourceType 急诊(E)/择期(B)
		.i jz="E" s jzstat="急诊"
		.e  i jz="B" s jzstat="择期"
		.e  s jzstat="超时"
		.q:jz'="E"
		.s i=0
		.s opdes="",opnodedesc=""
		.s prediag="",diamen=""
			.s subchl=0 f  s subchl=$O(^OR(adm,"ANA",chl,"OP",subchl)) q:(subchl="")  d ///ck091117
				..s opdr=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",6)       		;ANAOP_Type_DR     ；手术名称
				..i opdr'=""  d   //ck091210
					...i $P($g(^ORC("OPER",+opdr)),"^",2)'="" d     ///ck091117
					....i opdes'="" s opdes=opdes_";"     ///ck091117
					....s opdes=opdes_$P($g(^ORC("OPER",+opdr)),"^",2)     ///ck091117
				..e  d
					...i $g(^OR(adm,"ANA",chl,"OP",subchl,"REM",2))'="" d
					....i opnodedesc'="" s opnodedesc=opnodedesc_";"
					....s opnodedesc=opnodedesc_$G(^OR(adm,"ANA",chl,"OP",subchl,"REM",2))    ///ck091210
				..s docdr=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",8)
				..i docdr'="" s opdoc=##class(web.DHCClinicCom).GetNameById(docdr)
				..e  s opdoc=$TR($p($p(^DHCANOPArrange(opaId),"^",42),"|",2)," ","")
        .;w "手术Id:"_opaId_"^"_"开始时间:"_opstdate_"^"_"就诊号:"_admId_"^"_"登记号:"_regno_"^"_"手术名称"_opdoc_"^"_"病人:"_patname_"^"_"所在科室:"_admLocdes_"$"
        .;i tempmfc'="" s tempmfc=tempmfc_"手术Id:"_opaId_"^"_"开始时间:"_opstdate_"^"_"就诊号:"_admId_"^"_"登记号:"_regno_"^"_"住院号"_medCareNo_"^"_"手术名称"_opdoc_"^"_"病人:"_patname_"^"_"性别:"_sex_"^"_"所在科室:"_admLocdes_"^"_"类型:"_"jzstat"_"$"
        .;e  s tempmfc="手术Id:"_opaId_"^"_"开始时间:"_opstdate_"^"_"就诊号:"_admId_"^"_"登记号:"_regno_"^"_"住院号"_medCareNo_"^"_"手术名称"_opdoc_"^"_"病人:"_patname_"^"_"性别:"_sex_"^"_"所在科室:"_admLocdes_"^"_"类型:"_"jzstat"_"$"
        .s ^tempmfc(opaId)=opaId_"^"_$zdt(opstdate,3)_" "_$zt(opsttime,2)_"^"_admId_"^"_regno_"^"_medCareNo_"^"_opdes_"^"_opnodedesc_"^"_opdoc_"^"_appCtcpDesc_"^"_patname_"^"_sex_"^"_admLocdes_"^"_jzstat_"$"
    }
}

/// Creator：      	mfc
/// CreatDate：    	2014-05-22
/// Description： 	特定范围内手术名称为手工录入的数据导出
/// Table：        	,
/// Input：        	FromDate开始日期，ToDate结束日期
/// ##class(web.DHCANAdaptor).GetWriteOpDescByDate("2014-05-01","2014-05-31")
/// Return：       	可以直接显示出来或者保存到global中
ClassMethod GetWriteOpDescByDate(FromDate As %String, ToDate As %String) As %String
{
	
    s admId="",tempmfc=""
	s FromDate=##class(web.DHCClinicCom).ConvertToDateH(FromDate)	
	s ToDate=##class(web.DHCClinicCom).ConvertToDateH(ToDate)
	f date=FromDate:1:ToDate
    {
	   s opaId=""
	   f  s opaId=$O(^DHCANOPArrange(0,"SDate",date,opaId)) q:(opaId="")  d
	   .s status=$P(^DHCANOPArrange(opaId),"^",27)
	   .q:(status'="F")	    	    
	   .s adm=$P(^DHCANOPArrange(opaId),"^",1),admId=adm	  
	   .s anaId=$P(^DHCANOPArrange(opaId),"^",2)	 
	   .s opstdate=$P(^DHCANOPArrange(opaId),"^",14)
	   .s opsttime=$P(^DHCANOPArrange(opaId),"^",15)
	   .s papmiId=$p($g(^PAADM(admId)),"^",1)
	   .s paadmtype=$p($g(^PAADM(admId)),"^",2)
	   .s regno=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	   .s medCareNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
	   .s patname=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	   .s appCtcpId=$P(^DHCANOPArrange(opaId),"^",6)  //ypz 070318
	   .i appCtcpId'="" s appCtcpDesc=$p(^CTPCP(appCtcpId,1),"^",2)
	   .e  s appCtcpDesc=""  
	   .s sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
	   .s admLocId=$p($g(^PAADM(adm)),"^",4)
		.i admLocId'="" s admLocdes=$P($g(^CTLOC(admLocId)),"^",2)  //Add mfc 20131217 病人所在科室
		.i $l(admLocdes,"-")>1 s admLocdes=$p(admLocdes,"-",2)
		.i paadmtype="O" s admLocdes=admLocdes_"(门)"
		.e  s admLocdes=admLocdes
		.s chl=$P($P(^DHCANOPArrange(opaId),"^",2),"||",2)
		.s jz=$P(^OR(adm,"ANA",chl),"^",32)   						//ANA_SourceType 急诊(E)/择期(B)
		.i jz="E" s jzstat="急诊"
		.e  i jz="B" s jzstat="择期"
		.e  s jzstat="超时"
		.s i=0
		.s opdes="",opnodedesc=""
		.s prediag="",diamen=""
			.s subchl="" f  s subchl=$O(^OR(adm,"ANA",chl,"OP",subchl)) q:(subchl="")  d ///ck091117
				..s opdr=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",6)       		;ANAOP_Type_DR     ；手术名称
				..q:opdr'=""
				..i opdr=""  d 
				...i $g(^OR(adm,"ANA",chl,"OP",subchl,"REM",2))'="" d
				....i opdes'="" s opdes=opdes_";"
				....s opdes=opdes_$G(^OR(adm,"ANA",chl,"OP",subchl,"REM",2))
				..s docdr=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",8)
				..i docdr'="" s opdoc=##class(web.DHCClinicCom).GetNameById(docdr)
				..e  s opdoc=$TR($p($p(^DHCANOPArrange(opaId),"^",42),"|",2)," ","")
		.q:opdes=""
        .;w "手术Id:"_opaId_"^"_"开始时间:"_opstdate_"^"_"就诊号:"_admId_"^"_"登记号:"_regno_"^"_"手术名称"_opdoc_"^"_"病人:"_patname_"^"_"所在科室:"_admLocdes_"$"
        .;i tempmfc'="" s tempmfc=tempmfc_"手术Id:"_opaId_"^"_"开始时间:"_opstdate_"^"_"就诊号:"_admId_"^"_"登记号:"_regno_"^"_"住院号"_medCareNo_"^"_"手术名称"_opdoc_"^"_"病人:"_patname_"^"_"性别:"_sex_"^"_"所在科室:"_admLocdes_"^"_"类型:"_"jzstat"_"$"
        .;e  s tempmfc="手术Id:"_opaId_"^"_"开始时间:"_opstdate_"^"_"就诊号:"_admId_"^"_"登记号:"_regno_"^"_"住院号"_medCareNo_"^"_"手术名称"_opdoc_"^"_"病人:"_patname_"^"_"性别:"_sex_"^"_"所在科室:"_admLocdes_"^"_"类型:"_"jzstat"_"$"
        .s ^tempmfc(opaId)=opaId_"^"_$zdt(opstdate,3)_"^"_admId_"^"_regno_"^"_medCareNo_"^"_opdes_"^"_opnodedesc_"^"_opdoc_"^"_appCtcpDesc_"^"_patname_"^"_sex_"^"_admLocdes_"^"_jzstat_"$"
    }
}

/// Creator：      	mfc
/// CreatDate：    	2014-08-15
/// Description： 	手术分台数据导出
/// Table：        	,
/// Input：        	FindType:查询类型(4为分台查询)
/// w ##class(web.DHCANAdaptor).GetCLLogByDateType("2014-07-01","2014-07-31",4)
/// Return：       	返回申请分台、处理分台例数
ClassMethod GetCLLogByDateType(FromDate As %String, ToDate As %String, FindType As %String) As %String
{
	q:FindType="" "查询类型不能为空！"
	s tClclogId=FindType
	s FromDate=##class(web.DHCClinicCom).ConvertToDateH(FromDate)	
	s ToDate=##class(web.DHCClinicCom).ConvertToDateH(ToDate)
	s appSum=0,repeatSum=0,arrOkSum=0,cancelSum=0
	k ^tempCLLogSum("temp")
	f date=FromDate:1:ToDate
    {
	    s tLogRecordId=0
	    f  s tLogRecordId=$o(^DHCCLLogI("ClclogDate",tClclogId,date,tLogRecordId)) q:tLogRecordId=""  d
	    	.s tCllogId=0
	        .f  s tCllogId=$o(^DHCCLLogI("ClclogDate",tClclogId,date,tLogRecordId,tCllogId)) q:tCllogId=""  d
	                ..s tClclogDesc=$li(^DHCCLC("Log",tClclogId),2)
	                ..s appSum=appSum+1 //申请分台总例数
	                ..i ((tClclogId=1)||(tClclogId=4)||(tClclogId=3))  d 
	                ...s admId=$P(^DHCANOPArrange(tLogRecordId),"^",1)
	                ...i admId'="" s papmiId=$p(^PAADM(admId),"^",1)
	                ...i papmiId'="" s tMedCareNo=$p(^PAPER(papmiId,"PAT",1),"^",22) //病案号
	                ...s stat=$P(^DHCANOPArrange(tLogRecordId),"^",27)
	                ...s arrOk=$li(^DHCCLLogD(tCllogId),11)
	                ...i arrOk="Y" s arrOkSum=arrOkSum+1 //分台处理例数
	                ...s postNote=$li(^DHCCLLogD(tCllogId),6)
	                ...i postNote'="" s postQT=$p(postNote,"|",2) //原因
	                ...i postQT=11 s cancelSum=cancelSum+1	//分台取消申请列数               
	                ...i ("^"_$g(^tempCLLogSum("temp"))_"^")[("^"_tLogRecordId_"^") s repeatSum=repeatSum+1 q //重复分台申请例数	                
	                ...s ^tempCLLogSum("temp")=$g(^tempCLLogSum("temp"))_"^"_tLogRecordId
    }
    q "申请分台总例数:"_appSum_"  "_"护士分台处理例数:"_arrOkSum_"   "_"重复分台申请例数:"_repeatSum_"   "_"分台取消申请列数："_cancelSum
	k ^tempCLLogSum("temp")
}

ClassMethod GetGender(EpisodeID As %String) As %String
{
	
	s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
	s sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
	i sex="男"  s sex="Male"
	e  s sex="Female"
	q sex
}

/// Creator： ypz
/// CreatDate： 2012-11-28
/// Description： 保存数据到ICU表中
/// Table： DHC_AN_Order,DHC_AN_RoomEquip,DHC_AN_RoomEquipDetail
/// Input： opaId手术安排ID,icuaId重症监护安排ID,anreOrIcubeId手术间设备或监护床设备ID,userId;
/// para：分两级，第一级"^",第二级#。每条记录的数据。
/// chanalNo_#_sttDate_"#"_sttTime_"#"_ancoType(医嘱类型)_"#"_itemValue_"%"_itemValue2_"%"_itemValue3_"#"_ctuomId_"#"_icuoId(未用)_"#"_ancvcId_"#"_oeoriId(未用)"^"....
/// status: 当前设备任务的状态：
/// "Unstarted"：未启动
/// "Running"：正运行
/// "NetOffline"：网络问题
/// “NoData"：无数据，很可能是MOXA原因
/// Output： 
/// Return： 0-正常，1-病人ID不存在，2-未找到icuaId,3-equipId为空，4-equipId错误,其他-插入数据库有误
/// s equipId=1,anoSource="S",userId=""
/// s dataPara="Datetime#2013-04-28#11:16:56#V#2013-04-28 10:00:00####^PatientID#2013-04-28#11:16:56#V#C736539####^SampleType#2013-04-28#11:16:56#V#动脉^####^pH#2013-04-28#11:16:56#V#7.426####^pCO2#2013-04-28#11:16:56#V#29.3####^pO2(A)#2013-04-28#11:16:56#V#220####^K+#2013-04-28#11:16:56#V#3.6####^Na+#2013-04-28#11:16:56#V#136####^Ca++#2013-04-28#11:16:56#V#1.23####^Cl-#2013-04-28#11:16:56#V#112####^Glu#2013-04-28#11:16:56#V#6.5####^Lac#2013-04-28#11:16:56#V#1.1####^tHb#2013-04-28#11:16:56#V#9.0####^RHb#2013-04-28#11:16:56#V#-0.5####^O2Hb#2013-04-28#11:16:56#V#98.9####^sO2#2013-04-28#11:16:56#V#100.5####^COHb#2013-04-28#11:16:56#V#1.1####^MetHb#2013-04-28#11:16:56#V#0.5####^tBil#2013-04-28#11:16:56#V#9####^T#2013-04-28#11:16:56#V#37.0####^FIO2#2013-04-28#11:16:56#V#40.0####^p50(st)#2013-04-28#11:16:56#V#26.84####^pH(T)#2013-04-28#11:16:56#V#7.426####^pCO2(T)#2013-04-28#11:16:56#V#29.3####^HCO3-#2013-04-28#11:16:56#V#19.2####^SBE#2013-04-28#11:16:56#V#-5.2####^SBC#2013-04-28#11:16:56#V#20.5####^pO2(T)#2013-04-28#11:16:56#V#220####^pO2(A)#2013-04-28#11:16:56#V#100.3####^pO2(A),T#2013-04-28#11:16:56#V#150.3####^p50(act)#2013-04-28#11:16:56#V#25.23####^p50(act),T#2013-04-28#11:16:56#V#25.23####^AaDO2#2013-04-28#11:16:56#V#30.6####^tO2#2013-04-28#11:16:56#V#5.8####^RI#2013-04-28#11:16:56#V#14####^RI,T#2013-04-28#11:16:56#V#14####^Anion gap#2013-04-28#11:16:56#V#4.8####"
/// w ##class(web.DHCANAdaptor).InsertShareDev(equipId,anoSource,userId,dataPara)
ClassMethod InsertShareDev(anreOrIcubeId As %String, anoSource As %String = "S", userId As %String = "", dataPara As %String = "", status As %String = "") As %String
{
	s ^TMPANDEBUG("InsertShareDev")=$ztime($p($h,",",2))_anreOrIcubeId_","_anoSource_","_userId_","_dataPara_","_status
	// equipID是否在Global中
	
	// 查找病人ID
	s pId=..GetValue(dataPara,"PatientID") , isInserted=0 ,txtValue="" ,numValue=""
	s dateTime=..GetValue(dataPara,"Datetime")
	s actDate=##class(web.DHCANOPCom).ConvertToDateH($p(dateTime," ",1))
	s actTime=$zth($p(dateTime," ",2))
	i pId="" q 1
	// 若是检验号则通过检验号查找病人ID
	s tStr=$g(^TEPI(pId))
	i tStr'="" s pId=$p(tStr,"\",18)
	// 通过病人ID查找icuaId
	s icuaId= ##class(web.DHCICUCom).GetIcuaId("",pId,"")
	i icuaId=""  q 2
	// 获取设备类型ID
	i $g(^DHCCLSet("ShareDev",anreOrIcubeId))="" q 3
	s ancctId=$p(^DHCCLSet("ShareDev",anreOrIcubeId),"^",6)
	q:ancctId="" 4
	// 插入数据库
	s retStr=0 s itemNum=$L(dataPara,"^")	
	f i=1:1:itemNum d
	.;查找对应常用医嘱项
	.q:retStr'=0
	.s itemStr=$P(dataPara,"^",i)
	.s icubedChannelNo=$P(itemStr,"#",1)
	.q:icubedChannelNo=""
	.s ancctiSub=$o(^DHCANC("CType",0,"ChannelNo",icubedChannelNo,ancctId,""))
	.q:ancctiSub=""
	.q:$p(^DHCANC("CType",ancctId,"I",ancctiSub),"^",3)'="Y"
	.s ancoId=$p(^DHCANC("CType",ancctId,"I",ancctiSub),"^",1)
	.q:ancoId=""
	.
	.s sttDate=$P(itemStr,"#",2) ;发送日期
	.s sttTime=$P(itemStr,"#",3) ;发送时间
	.
	.s sttDate=##class(web.DHCANOPCom).ConvertToDateH(sttDate)
	.i $l(sttTime,":")>1 s sttTime=$zth(sttTime)
	.s endDate=sttDate
	.s endTime=sttTime
	.s ancoOrArcimValue=$P(itemStr,"#",5)
	.;是否在医嘱配置范围内
	.s max=$p($g(^DHCANC("ComOrd",ancoId)),"^",21)
	.s min=$p($g(^DHCANC("ComOrd",ancoId)),"^",22)
	.q:ancoOrArcimValue>max!ancoOrArcimValue>8000000!ancoOrArcimValue<min
	.s txtValue=numValue=""
	.s field=$p(^DHCANC("ComOrd",ancoId),"^",24)
	.i field="Qty" s numValue=+ancoOrArcimValue
	.e  s txtValue=ancoOrArcimValue
	.d Insert2ICUOrder 
	i SQLCODE'=0 q SQLCODE
	
	// 根据时间找出这一时间的生理参数(监护仪、呼吸机等)并插入到DHC_ICU_Order
	s time=sttTime-60*10
	f  s time=$o(^DHCICUArrange(0,"CData",icuaId,sttDate,time),-1) q:time=""  d
	.i sttTime-time>900 s isExit=1 q // 15分钟内数据
	.s icucdSub=""
	.f  s icucdSub=$o(^DHCICUArrange(0,"CData",icuaId,sttDate,time,icucdSub)) q:icucdSub=""  d
	..s item=$g(^DHCICUArrange(icuaId,"C",icucdSub))
	..q:item=""
	..s ancoId=$p(item,"^",1)
	..q:ancoId=""
	..
	..// 查询后插入
	..s isFind=0
	..s sub=""
	..f  s sub=$o(^DHCICUOrder(0,"SttDateTime",sttDate,icuaId,sttTime,sub)) q:sub=""!isFind=1  d
	...s ctuomId=$p($g(^DHCICUOrder(sub)),"^",2)
	...i ctuomId=ancoId s isFind=1
	...
	..q:isFind=1
	..s txtValue=numValue=""
	..s txtValue=$p(item,"^",4)
	..s numValue=$p(item,"^",5)
	..d Insert2ICUOrder
	..q
	
	i (isInserted=0)&&(retStr=0) s retStr=2	
	q retStr
	
Insert2ICUOrder
	k PLIST
	s PLIST(2)=icuaId //icuaId
	s PLIST(3)=ancoId //ancoId
	s PLIST(5)="" //userId
	s PLIST(6)=actDate //startDate
	s PLIST(7)=actTime //startTime
	s PLIST(8)=sttDate //endDate
	s PLIST(9)=sttTime //endTime
	s PLIST(11)=txtValue
	s PLIST(12)=numValue
	s PLIST(13)="" //ctuomId
	s PLIST(17)=$p($g(^DHCANC("ComOrd",ancoId)),"^",5) //ancvcId
	s PLIST(18)="N" //ICUO_Flag
	s PLIST(22)=+$h //ICUO_UpdateDate
	s PLIST(23)=$p($h,",",2) //ICUO_UpdateTime
	s PLIST(24)="" //ICUO_ICUO_Dr
	s PLIST(26)="N" //ICUO_EditFlag
	s PLIST(30)="I" //ICUO_ICUO_Source
	s PLIST(31)=$p($g(^DHCANC("ComOrd",ancoId)),"^",3) //ICUO_Type
	&SQL(Insert into DHC_ICU_Order Values :PLIST())
	s isInserted=1
	i SQLCODE s retStr=icuaId_":ICU SQLCODE:"_SQLCODE //icuoId"插入数据错! SQLCode="_SQLCODE
	s ^tmpICUDebug("ShareDev",$h)=SQLCODE_",rowId="_$g(%ROWID)
	s retStr=0
	q
}

ClassMethod GetValue(dataPara As %String, itemName As %String) As %String
{
	s itemValue=""
	s itemNum=$L(dataPara,"^")
	f i=1:1:itemNum q:itemValue'=""  d
	.s itemStr=$P(dataPara,"^",i)
	.q:itemStr=""
	.s chNo=$P(itemStr,"#",1)
	.i chNo=itemName s itemValue=$P(itemStr,"#",5) s i=itemNum	
	q itemValue
}

ClassMethod GetEqIdByName(equipName As %String) As %String
{
	s eqTypeId=""
	f  s sub=$O(^DHCANC("CType",0,"Code",equipName,sub)) q:sub=""  d
}

/// w ##class(web.DHCANAdaptor).GetOperOrdStatByAdmId(1243)
/// 20161220+dyl
/// 输入参数：就诊号
/// 返回：如果手术室麻醉科合并收费则返回手术室收费状态^医嘱id^手术室^手术状态
/// 合并收费  N@0^1641||26^手术室^A~0^1641||27^手术室^A
///  反之，返回手术室收费状态^麻醉医生收费状态^麻醉护士收费状态^医嘱id^是否手术完成   分开收费  N@0^0^0^1641||26^手术室^A~0^0^0^1641||27^手术室^A
/// 备注：麻醉护士收费状态一般不作为是否收费依据  
/// @前为合并标志，Y：合并；N：分开;"~"分隔多个手术。0是未收费 1是已收费 
/// 手术状态opaStatus："A"是申请，"D"是拒绝，"R"是安排，"I"是术中，"P"是恢复室，"L"是离室，"F"是完成。
ClassMethod GetOperOrdStatByAdmId(needEpisodeID As %String) As %String
{
	q:needEpisodeID="" "就诊号不可为空"
	s cahrgeTogether=$g(^DHCCLSet("AnOp","ChargeTogether"))
	i cahrgeTogether="" s cahrgeTogether="N"
	s tmpOrdId=$o(^OEORD(0,"Adm",needEpisodeID,""))	////20200708
	s retstr=""
	s opaId="" f  s opaId=$O(^DHCANOPArrange(0,"Adm",needEpisodeID,opaId)) q:opaId=""  d
		.s opaStatus=$P(^DHCANOPArrange(opaId),"^",27)
		.q:(opaStatus="")!(opaStatus="C")!(opaStatus="D")
		.s anaDoctorOrd=$p($G(^DHCANOPArrange(opaId)),"^",48)
		.i anaDoctorOrd="Y" s anaDoctorOrd=1
		.e  s anaDoctorOrd=0
		.s opNurseOrd=$p($G(^DHCANOPArrange(opaId)),"^",50)
		.i opNurseOrd="Y" s opNurseOrd=1
		.e  s opNurseOrd=0
		.s anaNurseOrd=$p($G(^DHCANOPArrange(opaId)),"^",49) 
		.i anaNurseOrd="Y" s anaNurseOrd=1
		.e  s anaNurseOrd=0
		.s anaId=$p(^DHCANOPArrange(opaId),"^",2)
		.s adm=$p(anaId,"||",1)
		.s chl=$p(anaId,"||",2)
		.s opdes=""
		.s anaOpSubTmp2="",inum=0,anaOpSubTmp=""
		.f  s anaOpSubTmp2=$o(^OR(adm,"ANA",chl,"OP",anaOpSubTmp2)) q:(anaOpSubTmp2="")!(inum>0)  d
		..s inum=anaOpSubTmp2
		..i inum>0 s anaOpSubTmp=inum
		.s operLocId=$P(^OR(adm,"ANA",chl,"OP",anaOpSubTmp),"^",10)
		.s operloc=$p(^CTLOC(operLocId),"^",2)
		.s ordId=$o(^OEORDi(0,"Ana",anaId,""))
		.q:tmpOrdId'=ordId	//20200708
		.s ordSubId=$o(^OEORDi(0,"Ana",anaId,ordId,""))
		.s oeordId=ordId_"||"_ordSubId
		.i retstr="" d
			..i cahrgeTogether="N" d
				...s retstr=opNurseOrd_"^"_anaDoctorOrd_"^"_anaNurseOrd_"^"_oeordId_"^"_operloc_"^"_opaStatus
			..i cahrgeTogether="Y" d
				...s retstr=opNurseOrd_"^"_oeordId_"^"_operloc_"^"_opaStatus
		.e  i retstr'="" d
			..i cahrgeTogether="N" d
				...s retstr=retstr_"~"_opNurseOrd_"^"_anaDoctorOrd_"^"_anaNurseOrd_"^"_oeordId_"^"_operloc_"^"_opaStatus
			..i cahrgeTogether="Y" d
				...s retstr=retstr_"~"_opNurseOrd_"^"_oeordId_"^"_operloc_"^"_opaStatus
	i retstr="" s retstr="该就诊号没有对应手术记录"
	e  s retstr=cahrgeTogether_"@"_retstr

	q retstr
}

// 1.参数说明：opaId：手术排班表Id；

// 		suspId：手术撤销原因Id，参见手术和过程下手术延缓原因，表名为ORC_ReasonForSuspend，如果表中没有亦可手工			填写原因；

// 		userId：用户Id；

// 2.方法说明：此方法根据opaId获取医嘱Id，再根据医嘱执行状态判断是否可以取消手术申请。如果未执行则调用##class(appcom.OEOrdItem).CancelMulti方法撤销医嘱，然后改变手术状态。

// 其中手术撤销原因存储在：$P(^DHCANOPArrange(opaId),"^",35)，为表DHC_AN_OPArrange中OPA_ReturnReason_Dr字段。

// 手术状态存储位置为：$p(^DHCANOPArrange(opaId),"^",27)，其中"C"状态代表撤销，表DHC_AN_OPArrange中OPA_Status。

ClassMethod CancelOper(opaId As %String = "", suspId As %String = "", userId As %String) As %String
{
	q:opaId="" "手术申请Id必须非空!"
	q:suspId="" "手术撤销原因必须非空!"
	s retStr=""
	s anaId=$P(^DHCANOPArrange(opaId),"^",2)
	s ordId=$o(^OEORDi(0,"Ana",anaId,""))
	s ordSubId=$o(^OEORDi(0,"Ana",anaId,ordId,""))
	s orderId=ordId_"||"_ordSubId
	s ordStat=""
	s ordEctStatCode=""
	s ordEctStatId=$p(^OEORD(ordId,"I",ordSubId,"X",1),"^",16)
	i ordEctStatId'="" d
		.s ordEctStatCode=$p(^OEC("STAT",ordEctStatId),"^",1)
		.i ordEctStatCode="F" s retStr="该医嘱已执行,无法取消申请"
	i retStr="" d
		.s ret=##class(appcom.OEOrdItem).CancelMulti(orderId,userId,"","N")
		.TSTART
		.&sql(select * into :PLIST() from SQLUSER.DHC_AN_OPArrange where opa_rowid=:opaId)
		.&sql(update SQLUSER.DHC_AN_OPArrange set OPA_ReturnReason_Dr=:suspId,OPA_Status="C" where opa_rowid=:opaId)
		.i SQLCODE'=0 s retStr="更新手术撤销原因失败!" TROLLBACK
		.i SQLCODE=0 TCOMMIT
	q retStr
}

// MD2704.01.01:MD2704.01手术执行详情服务定义

// 20161226+dyl

// w ##class(web.DHCANAdaptor).GetOperDetailsByRoomId(6)

ClassMethod GetOperDetailsByRoomId(opRoomId As %String) As %GlobalCharacterStream
{
	q:opRoomId="" ""
	s retStr="",ret=0,aopsttime="0"
	s retStr=##class(%GlobalCharacterStream).%New()
	d retStr.Rewind()
	d retStr.Write("<Response>")
    s diag="",surgeonDesc=""
	s date=+$h
	s opaId=""
	f  s opaId=$o(^DHCANOPArrange(0,"SDate",date,opaId)) q:opaId=""  d
		.s adm=$P(^DHCANOPArrange(opaId),"^",1)
		.s statCode=""
		.s opaStatus=$P(^DHCANOPArrange(opaId),"^",27)	;手术状态
		.i opaStatus="R" s statCode=3
		.i opaStatus="I" s statCode=2
		.i opaStatus="L" s statCode=2
		.i opaStatus="F" s statCode=1
		.i opaStatus="P" s statCode=2
		.;b ;1
		.q:statCode=""
		.s appLocId=$p($g(^DHCANOPArrange(opaId)),"^",54)
		.i appLocId="" s appLocId=$p($g(^PAADM(adm)),"^",4)
		.s appLoc=$p(^CTLOC(appLocId),"^",2)
		.s opStDate=$P(^DHCANOPArrange(opaId),"^",14)	;手术日期
		.i opStDate'="" s opStDate=$zd(opStDate,4)
		.s opsttime=$P(^DHCANOPArrange(opaId),"^",15)	;预约时间
		.s opEndDate=$P(^DHCANOPArrange(opaId),"^",16)	;预约时间
		.i opEndDate'="" s opEndDate=$zd(opEndDate,4)
		.e  s opEndDate=opStDate
		.s aopsttime=opsttime
		.i aopsttime'="" s opsttime=$zt(opsttime,2)
		.;b
		.s oproomdr=$P(^DHCANOPArrange(opaId),"^",20)
		.q:oproomdr'=opRoomId
		.
		.s admId=adm
		.s bedCode="",inPatNo="",admreason=""
		.s bedSub=$p($p($g(^PAADM(adm)),"^",73),"||",2)
		.s curWardId=$p($g(^PAADM(adm)),"^",70)  
		.i curWardId'="" s WardDes=$P(^PAWARD(curWardId),"^",1)
		.i (bedSub'="")&(curWardId'="") d
			..s bedCode=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)	;床号
		.s inPatNo=$p($g(^PAADM(adm)),"^",29)
		.s papmiId=$p($g(^PAADM(admId)),"^",1)
		.s paadmtype=$p($g(^PAADM(admId)),"^",2)
		.s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
		.S medCareNo= ##Class(web.DHCWMRService).IGetMrNoByEpisodeID(admId , .ErrMsg)	;病案号
		.s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)	;姓名
		.s age=##class(web.DHCBillInterface).GetPapmiAge(papmiId,admId)	;年龄
		.s sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)	;性别
		.s patTel=$p($g(^PAPER(papmiId,"ALL")),"^",4)  ;add by lyn  患者电话
		.s chl=$P($P(^DHCANOPArrange(opaId),"^",2),"||",2)
		.s opStTime=$P(^DHCANOPArrange(opaId),"^",15)
		.s opEndTime=$P(^DHCANOPArrange(opaId),"^",17)
		.i opStTime'="" s opStTime=$ZT(opStTime,2)
		.i opEndTime'=""  s opEndTime=$ZT(opEndTime,2)
		.s mzdr=$P(^OR(adm,"ANA",chl),"^",6)        					;ANA_Anaesthetist_Dr 
		.i mzdr'="" d
			..s mzdoc=##class(web.DHCANOPCom).GetNameById(mzdr)	;麻醉医师
		.e  s mzdoc=""
		.;b ;2
		.s anaTheatreInTime=""	;麻醉监护的开始时间
		.s anaTheatreInTime=$p(^OR(adm,"ANA",chl),"^",40)
		.i anaTheatreInTime'="" s anaTheatreInTime=$zt(anaTheatreInTime,2)
		.s anaTheatreOutTime=""	;麻醉监护的结束时间
		.s anaTheatreOutTime=$p(^OR(adm,"ANA",chl),"^",42)
		.i anaTheatreOutTime'="" s opEndTime=$zt(anaTheatreOutTime,2)
		.s opdes=""
		.s subchl=0 f  s subchl=$O(^OR(adm,"ANA",chl,"OP",subchl)) q:(subchl="")  d
			..s opdr=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",6)       		;ANAOP_Type_DR     ；手术名称
			..i opdr'=""  d 
				...i $P($g(^ORC("OPER",+opdr)),"^",2)'="" d     
					....i opdes'="" s opdes=opdes_";"     
					....s opdes=opdes_$P($g(^ORC("OPER",+opdr)),"^",2)    ;手术名称
			..s opd=""
			..s docdr=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",8)   ;ANAOP_Surgeon_DR   手术医师
			..i docdr'="" s opd=##class(web.DHCANOPCom).GetNameById(docdr)
			..e  s opd=$TR($p($p(^DHCANOPArrange(opaId),"^",42),"|",2)," ","")  //手术医生备注(外来手术医生)
			..s surgeonDesc=opd   
			..s predigdrS=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",4)   		;ANAOP_PreopDiag_DR 术前诊断字符串  zhangtao add
			..s num=$l(predigdrS,"|")
			..f pi=1:1:num d
				...s predigdr=$p(predigdrS,"|",pi)
				...i predigdr'=""  d
				....s prediag=$P(^MRC("ID",predigdr),"^",2)
				...s $p(diag,",",pi)=$G(prediag)
				...e  d
					....i $g(^OR(adm,"ANA",chl,"TXT",2))'="" d 
					.....s diamen=$p(^OR(adm,"ANA",chl,"TXT",2),"|",pi)  	// 麻醉表存放诊断备注ANA_Notes
					.....s $p(diag,",",pi)=$G(diamen)            //zhangtao add
		.s p=0,ash1="",ash2=""
		.s as=0 f  s as=$O(^OR(adm,"ANA",chl,"OP",1,"ASS",as)) q:(as="")  d
			..s asdr=$P(^OR(adm,"ANA",chl,"OP",1,"ASS",as),"^",1)
			..q:asdr=""
			..s p=p+1
			..i p=1 d
				...s ash1=##class(web.DHCANOPCom).GetNameById(asdr)
			..i p=2 d
				...s ash2=##class(web.DHCANOPCom).GetNameById(asdr)
	.s p=0,scr=""
	.s scnSub=0 f  s scnSub=$O(^OR(adm,"ANA",chl,"OP",1,"SCN",scnSub)) q:(scnSub="")  d
		..;q:scnSub>20
		..s scnDr=$P($g(^OR(adm,"ANA",chl,"OP",1,"SCN",scnSub)),"^",1)
		..q:scnDr=""
		..i scr'="" s scr=scr_","_##class(web.DHCANOPCom).GetNameById(scnDr)
		..e  s scr=##class(web.DHCANOPCom).GetNameById(scnDr)
	.s p=0,ccr=""
	.s cirnSub=0 f  s cirnSub=$O(^OR(adm,"ANA",chl,"OP",1,"CIRN",cirnSub)) q:(cirnSub="")   d
		..;q:cirnSub>20
		..s cirnDr=$P(^OR(adm,"ANA",chl,"OP",1,"CIRN",cirnSub),"^",1)
		..q:cirnDr=""
		..i ccr'="" s ccr=ccr_","_##class(web.DHCANOPCom).GetNameById(cirnDr)
		..e  s ccr=##class(web.DHCANOPCom).GetNameById(cirnDr)
	.s a1=opStDate_"^"_opaId_"^"_$zd(($zdh(opStDate,4)),3)_"  "_opsttime _"^"_$zd(($zdh(opStDate,4)),3)_"  "_anaTheatreInTime_"^"_$zd(($zdh(opEndDate,4)),3)_"  "_opEndTime
	.s a2=opdes_"^"_diag_"^"_patName_"^"_age_"^"_sex
	.s a3=bedCode_"^"_surgeonDesc_"^"_ash1_"^"_ash2_"^"_mzdoc_"^"_scr_"!"_ccr_"^"_statCode_"^"_appLoc_"^"_medCareNo 
	.
	.s ^TMPPortall($j,aopsttime,opaId)=a1_"^"_a2_"^"_a3
	
	s opsttime="" f  s opsttime=$o(^TMPPortall($j,opsttime)) q:opsttime=""  d
			.s opaId="" f  s opaId=$o(^TMPPortall($j,opsttime,opaId)) q:opaId=""  d
				..s valueStr=^TMPPortall($j,opsttime,opaId)
				..d OperDetails
	k ^TMPPortall($j)	
	d retStr.Write("</Response>")
	q retStr			
OperDetails
		s obj=##class(User.DHCANOPInterfaceForPortalOperDetails).%New()
		s obj.OpDate=$p(valueStr,"^",1)          ;手术日期1
		s obj.operId=$p(valueStr,"^",2)		;2 
		s obj.appointTime=$p(valueStr,"^",3)           ;手术时间,3
		s obj.startTime=$p(valueStr,"^",4)	;4
		s obj.endTime=$p(valueStr,"^",5)		;5
		s obj.operName=$p(valueStr,"^",6)                ;手术名称，多个以","分割,6
		s obj.diagnosis=$p(valueStr,"^",7)    ;术前诊断7
		s obj.name=$p(valueStr,"^",8)			;姓名8
		s obj.age=$p(valueStr,"^",9)					;年龄9
		s obj.sex=$p(valueStr,"^",10) 				;性别10
		s obj.bedNo=$p(valueStr,"^",11)             ;床位11
		s obj.surgeonName=$p(valueStr,"^",12)           ;手术医师12
		s obj.firstAssistantName=$p(valueStr,"^",13)   ;一助描述13
		s obj.secondAssistantName=$p(valueStr,"^",14)  ;二助描述14
		s obj.anesthesiaName=$p(valueStr,"^",15)         ;麻醉医师15 
		s obj.nurseName=$p(valueStr,"^",16)	;16
		s obj.operState=$p(valueStr,"^",17)				;状态代码17
		s obj.operDep=$p(valueStr,"^",18)      ;申请科室18
		s obj.medicalNo=$p(valueStr,"^",19)        ;病案号19
		
		s Xml=##class(%GlobalCharacterStream).%New()
		s ret=obj.XMLExportToStream(.Xml,"OperationDetails")
		q:ret=0
		d retStr.CopyFrom(Xml)
		q
}

/// 20161229+dyl+MD2703.01.01
/// 手术室内手术情况
/// d ##class(web.DHCANAdaptor).GetOperDetailsBySSSLocId(362)
ClassMethod GetOperDetailsBySSSLocId(OperLocId As %String) As %GlobalCharacterStream
{
	q:OperLocId="" ""
	s operLoc=$p(^CTLOC(OperLocId),"^",2)
	s retStr="",ret=0
	s retStr=##class(%GlobalCharacterStream).%New()
	d retStr.Rewind()
	d retStr.Write("<Response>")

	s date=+$h
	s opStDate=$zd(date,4)
	
	s opaId="",operTotalNum=0
	f  s opaId=$o(^DHCANOPArrange(0,"SDate",date,opaId)) q:opaId=""  d
		.s adm=$P(^DHCANOPArrange(opaId),"^",1)
		.s statCode=""
		.s opaStatus=$P(^DHCANOPArrange(opaId),"^",27)	;手术状态
		.i opaStatus="R" s type=2
		.i opaStatus="I" s type=1
		.i opaStatus="L" s type=1
		.i opaStatus="P" s type=1
		.i opaStatus="F" s type=3
		.;q:statCode=""
		.s appLocId=$p($g(^DHCANOPArrange(opaId)),"^",54)
		.i appLocId="" s appLocId=$p($g(^PAADM(adm)),"^",4)
		.;q:AppLocId'=appLocId
		.s operTotalNum=operTotalNum+1
		.s appLoc=$p(^CTLOC(appLocId),"^",2)
		.s opStDate=$P(^DHCANOPArrange(opaId),"^",14)	;手术日期
		.i opStDate'="" s opStDate=$zd(opStDate,4)
		.s opsttime=$P(^DHCANOPArrange(opaId),"^",15)	;预约时间
		.s sopsttime=opsttime
		.i opsttime'="" s opsttime=$zt(opsttime,2)
		.s oproomdr=$P(^DHCANOPArrange(opaId),"^",20)
		.q:oproomdr=""
		.s oproomdes=$p($g(^DHCANC("OPRoom",oproomdr)),"^",2)
		.s operNum=$P(^DHCANOPArrange(opaId),"^",26)
		.
		.s admId=adm
		.s bedCode="",inPatNo="",admreason=""
		.s bedSub=$p($p($g(^PAADM(adm)),"^",73),"||",2)
		.s curWardId=$p($g(^PAADM(adm)),"^",70)  
		.i curWardId'="" s WardDes=$P(^PAWARD(curWardId),"^",1)
		.i (bedSub'="")&(curWardId'="") d
			..s bedCode=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)	;床号
		.s inPatNo=$p($g(^PAADM(adm)),"^",29)
		.s papmiId=$p($g(^PAADM(admId)),"^",1)
		.s paadmtype=$p($g(^PAADM(admId)),"^",2)
		.s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
		.S medCareNo= ##Class(web.DHCWMRService).IGetMrNoByEpisodeID(admId , .ErrMsg)	;病案号
		.s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)	;姓名
		.s age=##class(web.DHCBillInterface).GetPapmiAge(papmiId,admId)	;年龄
		.s sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)	;性别
		.s patTel=$p($g(^PAPER(papmiId,"ALL")),"^",4)  ;add by lyn  患者电话
		.s chl=$P($P(^DHCANOPArrange(opaId),"^",2),"||",2)
		.s opStTime=$P(^DHCANOPArrange(opaId),"^",15)
		.s opEndTime=$P(^DHCANOPArrange(opaId),"^",17)
		.i opStTime'="" s opStTime=$ZT(opStTime,2)
		.i opEndTime'=""  s opEndTime=$ZT(opEndTime,2)
		.s mzdr=$P(^OR(adm,"ANA",chl),"^",6)        					;ANA_Anaesthetist_Dr 
		.i mzdr'="" d
			..s mzdoc=##class(web.DHCANOPCom).GetNameById(mzdr)	;麻醉医师
		.e  s mzdoc=""
		.s surgeonName="",operLoc=""
		.s subchl=0 f  s subchl=$O(^OR(adm,"ANA",chl,"OP",subchl)) q:(subchl="")  d
			..s opd=""
			..s docdr=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",8)   ;ANAOP_Surgeon_DR   手术医师
			..i docdr'="" s opd=##class(web.DHCANOPCom).GetNameById(docdr)
			..e  s opd=$TR($p($p(^DHCANOPArrange(opaId),"^",42),"|",2)," ","")  //手术医生备注(外来手术医生)
			..s surgeonName=opd 
			..s operLocId=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",10)  
			..q:OperLocId'=operLocId
			..
		.s a1=opsttime_"^"_opaId_"^"_type_"^"_operTotalNum_"^"_operNum
		.s a2=oproomdr_"^"_oproomdes_"^"_patName_"^"_age_"^"_sex
		.s a3=surgeonName_"^"_appLoc
		.s ^TMPPortal($j,oproomdr,sopsttime,opaId)=a1_"^"_a2_"^"_a3
	
	s oprId=0 f  s oprId=$o(^DHCANC("OPRoom",oprId)) q:oprId=""  d
	.q:$p(^DHCANC("OPRoom",oprId),"^",9)'="T"  //只选手术间
	.q:$p(^DHCANC("OPRoom",oprId),"^",7)="N" 
	.s ctlocId=$P(^DHCANC("OPRoom",oprId),"^",3)
	.q:OperLocId'=ctlocId
	.s roomdesc=$P(^DHCANC("OPRoom",oprId),"^",2)
	.s roomList(oprId)=roomdesc
	//按照手术预约时间排序
	s curroomdr="" f  s curroomdr=$o(roomList(curroomdr)) q:curroomdr=""  d
		.i $d(^TMPPortal($j,curroomdr)) d
			..s roomDr=curroomdr
			..s sttime="" f  s sttime=$o(^TMPPortal($j,roomDr,sttime)) q:sttime=""  d
				...s opaId="" f  s opaId=$o(^TMPPortal($j,roomDr,sttime,opaId)) q:opaId=""  d
					....s valueStr=^TMPPortal($j,roomDr,sttime,opaId)
					....d OperDetailsByOperLoc
		.e  d
				..;b	;2
				..s valueStr=" "_"^"_" "_"^"_4_"^"_" "_"^"_" "_"^"
				..s valueStr=valueStr_curroomdr_"^"_roomList(curroomdr)_"^"_" "_"^"_" "_"^"_" "_"^"
				..s valueStr=valueStr_" "_"^"_" "
				..d OperDetailsByOperLoc
  	k ^TMPPortal($j)	
	d retStr.Write("</Response>")
	q retStr			
OperDetailsByOperLoc		
		s obj=##class(User.DHCANOPInterfaceForPortalAppLoc).%New()
		s obj.OpDate=$p(valueStr,"^",1)          ;手术日期1
		s obj.operId=$p(valueStr,"^",2)	;手术唯一标示2
		s obj.type=$p(valueStr,"^",3)	;手术状态标识3
		s obj.operTotalNum=$p(valueStr,"^",4)	;总共多少手术4
		s obj.operNum=$p(valueStr,"^",5)	;手术台次5
		s obj.operRoomId=$p(valueStr,"^",6)	;手术间Id6
		s obj.operRoomDesc=$p(valueStr,"^",7)	;手术间7
		s obj.name=$p(valueStr,"^",8)			;姓名8
		s obj.age=$p(valueStr,"^",9)					;年龄9
		s obj.sex=$p(valueStr,"^",10)  				;性别10
		s obj.surgeonName=$p(valueStr,"^",11)           ;手术医师11
		s obj.operDep=$p(valueStr,"^",12)      ;手术室12
		s Xml=##class(%GlobalCharacterStream).%New()
		s ret=obj.XMLExportToStream(.Xml,"OperDetailsByAppLoc")
		q:ret=0
		d retStr.CopyFrom(Xml)
		q
}

/// 科室内手术情况
/// w ##class(web.DHCANAdaptor).GetOperDetailsByAppLocId(43)
/// AppLocId:手术室id
/// 
ClassMethod GetOperDetailsByAppLocId(AppLocId As %String) As %GlobalCharacterStream
{
	q:AppLocId="" ""
	s retStr="",ret=0
	s retStr=##class(%GlobalCharacterStream).%New()
	d retStr.Rewind()
	d retStr.Write("<Response>")
	s date=+$h
	s opaId="",operTotalNum=0
	f  s opaId=$o(^DHCANOPArrange(0,"SDate",date,opaId)) q:opaId=""  d
		.s adm=$P(^DHCANOPArrange(opaId),"^",1)
		.s statCode=""
		.s opaStatus=$P(^DHCANOPArrange(opaId),"^",27)	;手术状态
		.i opaStatus="R" s type=2
		.i opaStatus="I" s type=1
		.i opaStatus="L" s type=1
		.i opaStatus="F" s type=3
		.;q:statCode=""
		.s appLocId=$p($g(^DHCANOPArrange(opaId)),"^",54)
		.i appLocId="" s appLocId=$p($g(^PAADM(adm)),"^",4)
		.;q:AppLocId'=appLocId
		.s appLoc=$p(^CTLOC(appLocId),"^",2)
		.s opStDate=$P(^DHCANOPArrange(opaId),"^",14)	;手术日期
		.i opStDate'="" s opStDate=$zd(opStDate,4)
		.s opsttime=$P(^DHCANOPArrange(opaId),"^",15)	;预约时间
		.i opsttime'="" s opsttime=$zt(opsttime,2)
		.s oproomdr=$P(^DHCANOPArrange(opaId),"^",20)
		.q:oproomdr=""
		.s oproomdes=$p($g(^DHCANC("OPRoom",oproomdr)),"^",2)
		.s operNum=$P(^DHCANOPArrange(opaId),"^",26)
		.
		.s admId=adm
		.s bedCode="",inPatNo="",admreason=""
		.s bedSub=$p($p($g(^PAADM(adm)),"^",73),"||",2)
		.s curWardId=$p($g(^PAADM(adm)),"^",70)  
		.i curWardId'="" s WardDes=$P(^PAWARD(curWardId),"^",1)
		.i (bedSub'="")&(curWardId'="") d
			..s bedCode=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)	;床号
		.s inPatNo=$p($g(^PAADM(adm)),"^",29)
		.s papmiId=$p($g(^PAADM(admId)),"^",1)
		.s paadmtype=$p($g(^PAADM(admId)),"^",2)
		.s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
		.S medCareNo= ##Class(web.DHCWMRService).IGetMrNoByEpisodeID(admId , .ErrMsg)	;病案号
		.s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)	;姓名
		.s age=##class(web.DHCBillInterface).GetPapmiAge(papmiId,admId)	;年龄
		.s sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)	;性别
		.s patTel=$p($g(^PAPER(papmiId,"ALL")),"^",4)  ;add by lyn  患者电话
		.s chl=$P($P(^DHCANOPArrange(opaId),"^",2),"||",2)
		.s opStTime=$P(^DHCANOPArrange(opaId),"^",15)
		.s opEndTime=$P(^DHCANOPArrange(opaId),"^",17)
		.i opStTime'="" s opStTime=$ZT(opStTime,2)
		.i opEndTime'=""  s opEndTime=$ZT(opEndTime,2)
		.s mzdr=$P(^OR(adm,"ANA",chl),"^",6)        					;ANA_Anaesthetist_Dr 
		.i mzdr'="" d
			..s mzdoc=##class(web.DHCANOPCom).GetNameById(mzdr)	;麻醉医师
		.e  s mzdoc=""
		.s subchl=0 f  s subchl=$O(^OR(adm,"ANA",chl,"OP",subchl)) q:(subchl="")  d
			..s opd=""
			..s docdr=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",8)   ;ANAOP_Surgeon_DR   手术医师
			..i docdr'="" s opd=##class(web.DHCANOPCom).GetNameById(docdr)
			..e  s opd=$TR($p($p(^DHCANOPArrange(opaId),"^",42),"|",2)," ","")  //手术医生备注(外来手术医生)
			..s surgeonName=opd 
	.s operTotalNum=operTotalNum+1  
	.s a1=opStDate_"^"_opaId_"^"_type_"^"_operTotalNum_"^"_operNum
	.s a2=oproomdr_"^"_oproomdes_"^"_patName_"^"_age_"^"_sex
	.s a3=surgeonName_"^"_appLoc
	.b ;a1_"^"_a2_"^"_a3
	.s ^TMPPortal($j,oproomdr,operNum,opaId)=a1_"^"_a2_"^"_a3
	s roomDr="" f  s roomDr=$o(^TMPPortal($j,roomDr)) q:roomDr=""  d
	.s ctlocLongId=$P($g(^DHCANC("OPRoom",roomDr)),"^",3)
	.q:AppLocId'=ctlocLongId
	.s ordno="" f  s ordno=$o(^TMPPortal($j,roomDr,ordno)) q:ordno=""  d
		..s opaId="" f  s opaId=$o(^TMPPortal($j,roomDr,ordno,opaId)) q:opaId=""  d
			...s valueStr=^TMPPortal($j,roomDr,ordno,opaId)
			...d OperDetailsByApp
  	k ^TMPPortal($j)	
	d retStr.Write("</Response>")
	b
	q retStr			
OperDetailsByApp		
		s obj=##class(User.DHCANOPInterfaceForPortalAppLoc).%New()
		s obj.OpDate=$p(valueStr,"^",1)          ;手术日期1
		s obj.operId=$p(valueStr,"^",2)	;手术唯一标示2
		s obj.type=$p(valueStr,"^",3)	;手术状态标识3
		s obj.operTotalNum=$p(valueStr,"^",4)	;总共多少手术4
		s obj.operNum=$p(valueStr,"^",5)	;手术台次5
		s obj.operRoomId=$p(valueStr,"^",6)	;手术间Id6
		s obj.operRoomDesc=$p(valueStr,"^",7)	;手术间7
		s obj.name=$p(valueStr,"^",8)			;姓名8
		s obj.age=$p(valueStr,"^",9)					;年龄9
		s obj.sex=$p(valueStr,"^",10)  				;性别10
		s obj.surgeonName=$p(valueStr,"^",11)           ;手术医师11
		s obj.operDep=$p(valueStr,"^",12)      ;申请科室12
		b ;$p(valueStr,"^",1)
		s Xml=##class(%GlobalCharacterStream).%New()
		s ret=obj.XMLExportToStream(.Xml,"OperDetailsByAppLoc")
		q:ret=0
		d retStr.CopyFrom(Xml)
		q
}

// 20161229+dyl+MD2701.01.01+查询当日手术间占用信息

// w ##class(web.DHCANAdaptor).GetOpRoomStat("2")

ClassMethod GetOpRoomStat(hospitalId As %String = "") As %GlobalCharacterStream
{
	s retStr="",ret=0
	s retStr=##class(%GlobalCharacterStream).%New()
	d retStr.Rewind()
	d retStr.Write("<Response>")

	s date=+$h
	s roomId="",operRoomTotalNum=0
	f  s roomId=$o(^DHCANC("OPRoom",roomId)) q:roomId=""  d
		.q:$p(^DHCANC("OPRoom",roomId),"^",7)="N"
		.q:$p(^DHCANC("OPRoom",roomId),"^",9)'="T"   //只选手术间
		.s locId=$p(^DHCANC("OPRoom",roomId),"^",3)
		.s hospID=$p($g(^CTLOC(locId)),"^",22)
		.q:(hospitalId'="")&&(hospID'=hospitalId)
		.;w hospID
		.s operRoomTotalNum=operRoomTotalNum+1
		.;d OperRoomDetail
	s opnum=0
	s opaId="" 
	f  s opaId=$o(^DHCANOPArrange(0,"SDate",date,opaId)) q:opaId=""  d
	.s oproomdr=$P(^DHCANOPArrange(opaId),"^",20)
	.q:oproomdr=""
 	.s adm=$P(^DHCANOPArrange(opaId),"^",1)
 	.s chl=$P($P(^DHCANOPArrange(opaId),"^",2),"||",2)
 	.s anaOpSubTmp2="",inum=0,anaOpSubTmp=""
	.f  s anaOpSubTmp2=$o(^OR(adm,"ANA",chl,"OP",anaOpSubTmp2)) q:(anaOpSubTmp2="")!(inum>0)  d
		..s inum=anaOpSubTmp2
		..i inum>0 s anaOpSubTmp=inum
 	.s operLocId=$P(^OR(adm,"ANA",chl,"OP",anaOpSubTmp),"^",10) 
 	.s hospID=$p($g(^CTLOC(operLocId)),"^",22)
	.q:(hospitalId'="")&&(hospID'=hospitalId)
	.;w hospID
	.s totalnum(oproomdr)=""
	s oproomdr="" 
	f  s oproomdr=$o(totalnum(oproomdr)) q:oproomdr=""  d
	   .s opnum=opnum+1
	s operVacancyNum=operRoomTotalNum-opnum
	
	s obj=##class(User.DHCANOPInterfaceForPortalRoomStat).%New()
	s obj.operTotalNum=operRoomTotalNum	;全院开放手术间数
	s obj.operUsedNum=opnum	;当日安排手术间数
	s obj.operVacancyNum=operVacancyNum      ;当日空闲手术间数
	s Xml=##class(%GlobalCharacterStream).%New()
	s ret=obj.XMLExportToStream(.Xml,"OperDetailsRoomStat")
	q:ret=0
	d retStr.CopyFrom(Xml)

	d retStr.Write("</Response>")
	q retStr
}

// 20161229+dyl+MD2702.01.01+查询所有手术执行科室信息

ClassMethod GetAllOperDept(hospitalId As %String = "") As %GlobalCharacterStream
{
	s retStr="",ret=0
	s retStr=##class(%GlobalCharacterStream).%New()
	d retStr.Rewind()
	d retStr.Write("<Response>")
	//增加住院手术室，门诊手术室，急诊手术室
	s ctlocIdList=##class(web.DHCClinicCom).GetLocIdByLocListCode("OP^OUTOP^EMOP")
	f i=1:1:$l(ctlocIdList,"^") d
		.s locId=$p(ctlocIdList,"^",i)
		.q:locId=""
		.s hospID=$p($g(^CTLOC(locId)),"^",22)
		.q:(hospitalId'="")&&(hospID'=hospitalId)
		.s loc=$p(^CTLOC(locId),"^",2)
		.d OperDeptInfo
	d retStr.Write("</Response>")
	q retStr

OperDeptInfo	
	s obj=##class(User.DHCANOPInterfaceForPortalOperDept).%New()
	s obj.operRoomId=locId	;手术室id
	s obj.operRoomName=loc	;手术室名称
	s Xml=##class(%GlobalCharacterStream).%New()
	s ret=obj.XMLExportToStream(.Xml,"AllOperatingRoom")
	q:ret=0
	d retStr.CopyFrom(Xml)
	q
}

// 20161229+dyl+MD2702.01.02+查询某手术室当天手术及手术间情况

ClassMethod GetDeptOperInfo(operCurLocId) As %GlobalCharacterStream
{
 s retStr="",ret=0
 s retStr=##class(%GlobalCharacterStream).%New()
 d retStr.Rewind()
 d retStr.Write("<Response>")

 s date=+$h
 //s date="64343"
 s roomId="",operRoomTotalNum=0
 f  s roomId=$o(^DHCANC("OPRoom",roomId)) q:roomId=""  d
 .q:$p(^DHCANC("OPRoom",roomId),"^",7)="N"
 .q:$p(^DHCANC("OPRoom",roomId),"^",9)'="T"
 .q:$p(^DHCANC("OPRoom",roomId),"^",3)'=operCurLocId
 .s operRoomTotalNum=operRoomTotalNum+1
 s opnum=0
 s opaId="" f  s opaId=$o(^DHCANOPArrange(0,"SDate",date,opaId)) q:opaId=""  d
 .s oproomdr=$P(^DHCANOPArrange(opaId),"^",20)
 .q:oproomdr=""
 .s adm=$P(^DHCANOPArrange(opaId),"^",1)
 .s chl=$P($P(^DHCANOPArrange(opaId),"^",2),"||",2)
	.s anaOpSubTmp2="",inum=0,anaOpSubTmp=""
 .f  s anaOpSubTmp2=$o(^OR(adm,"ANA",chl,"OP",anaOpSubTmp2)) q:(anaOpSubTmp2="")!(inum>0)  d
		..s inum=anaOpSubTmp2
		..i inum>0 s anaOpSubTmp=inum
		.s operLocId=$P(^OR(adm,"ANA",chl,"OP",anaOpSubTmp),"^",10)
 .s operLocId=$P(^OR(adm,"ANA",chl,"OP",anaOpSubTmp),"^",10) 
 .q:operCurLocId'=operLocId
 .s opaStatus=$P(^DHCANOPArrange(opaId),"^",27)	;手术状态
 .s opaSeq=$P(^DHCANOPArrange(opaId),"^",26)    ;台次
 .i (opaStatus="F") s totalFinishnum(oproomdr,opaSeq)=""   //相同手术间看台词
 .s totalnum(oproomdr)=""
 .s opnum=opnum+1

 s oproomnum=0
 s oproomdr=""  f  s oproomdr=$o(totalnum(oproomdr)) q:oproomdr=""  d
 .s oproomnum=oproomnum+1
 s operVacancyNum=operRoomTotalNum-oproomnum

 s fnum=0
 s roomdr="" f  s roomdr=$o(totalFinishnum(roomdr)) q:roomdr=""  d
    .s seq="" f  s seq=$o(totalFinishnum(roomdr,seq)) q:seq=""  d  //相同手术间看台词
 ..s fnum=fnum+1
 b
 s obj=##class(User.DHCANOPInterfaceForPortalDeptOperInfo).%New()
 s obj.operUsedNum=oproomnum	 ;当日安排手术间数
 s obj.operVacancyNum=operVacancyNum  ;当日空闲手术间数
 s obj.operCompletedNum=fnum	 ;当日已完成手术台数
 s obj.operUnfinishedNum=opnum-fnum	;当日未完成手术台数（包含正在进行手术）
 s Xml=##class(%GlobalCharacterStream).%New()
 s ret=obj.XMLExportToStream(.Xml,"OperDetailsDeptOperInfo")
 q:ret=0
 d retStr.CopyFrom(Xml)

 d retStr.Write("</Response>")
 q retStr
}

// w ##class(web.DHCANAdaptor).GetOperInfoByAnaId("236||4")

// 20170525For医生站+dyl

ClassMethod GetOperInfoByAnaId(anaId As %String, langId As %String = "20") As %String
{
	q:anaId="" ""
	s EpisodeID=$p(anaId,"||",1)
	s anaSub=$p(anaId,"||",2)
	s opName="",operId="",retStr=""
	s anaopSub=0 f  s anaopSub=$O(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)) q:(anaopSub="")  d  
		.s curOperId=$P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",6)       ;ANAOP_Type_DR；手术名称
		.i curOperId="" s opName=opName_$G(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"REM",2)) 
		.q:curOperId=""
		.if $D(^ORC("OPER",curOperId)) d
			..s OperDesc=$P(^ORC("OPER",curOperId),"^",2)
			..s OperDesc=##class(User.ORCOperation).GetTranByDesc("OPERDesc",OperDesc,langId)
			..i retStr="" s retStr=OperDesc_$c(1)_EpisodeID_"||"_anaSub_"||"_anaopSub
			..e  s retStr=retStr_"^"_OperDesc_$c(1)_EpisodeID_"||"_anaSub_"||"_anaopSub
	q retStr
}

/// Creator：      	dyl
/// CreatDate：    	2017-05-31
/// Description： 	通过就诊号查询病人手术情况
/// Table：        	dhc_an_oparrange
/// Input：        	EpisodeID
/// w ##class(web.DHCANAdaptor).GetOperationStatByAdm("236")
/// Return：       	以"@"分割  手术ID^状态@手术ID^状态
///        0为完成 1为未完成
ClassMethod GetOperationStatByAdm(EpisodeID As %String) As %String
{
	s retStr=""
	q:EpisodeID="" retStr
	s opaId="",ifFinish=""
	f  s opaId=$o(^DHCANOPArrange(0,"Adm",EpisodeID,opaId)) q:opaId=""  d
		.q:'$d(^DHCANOPArrange(opaId))
		.s opaStatus=$P(^DHCANOPArrange(opaId),"^",27)
		.q:((opaStatus="D")!(opaStatus="C"))
		.i opaStatus="F" s ifFinish="0"
		.e  s ifFinish="1"
		.i retStr'="" s retStr=retStr_"@"_opaId_"^"_ifFinish
		.e  s retStr=opaId_"^"_ifFinish
	q retStr
}

// 

/// Creator 丁延丽 2017-08-03   日期索引：^DHCANOPArrange(0,"SDate",日期数字的)
/// d ##class(%ResultSet).RunQuery("DHCHAI.DI.DHS.IO.FromOpsSrv","GetAnOpListForM","2017-04-05","2017-04-05","1513755")
Query GetAnOpListForM(stdate As %String, enddate As %String, EpisodeId As %String) As %Query(ROWSPEC = "OperID,EpisodeID,OperICD,OperDesc,OperType,StartDate,StartTime,EndDate,EndTime,OperHour,OperLocCode,OperLocDesc,OpertorCode,OpertorName,Assistant1,Assistant2,IncisionCode,Incision,HealingCode,Healing,AnesMethodCode,AnesMethod,Anesthesia,ASAScore,NNISGrade,WBC,IncisionNum,IsSightGlass,IsImplants,LoseBlood,GotBlood,Complication,Diag,Oproomdes,OpaStatus,OperTypeValue")
{
}

ClassMethod GetAnOpListForMExecute(ByRef qHandle As %Binary, stdate As %String, enddate As %String, EpisodeId As %String) As %Status
{
	///paidType "Y"已收费，"N"未收费，其它为全部
  	Set repid=$I(^CacheTemp)
  	s ind=1
    k ^TMPAN("AppM",$j)
	//手麻记录ID：OperID、手术编码：OperICD、手术名称：OperDesc、手术类型：OperType、手术开始日期：StartDate
	//OperID,OperICD,OperDesc,OperType,StartDate
	//、手术开始时间：StartTime、手术结束日期：EndDate、手术结束时间：EndTime、手术时长：OperHour、手术科室代码：OperLocCode
	//,StartTime,EndDate,EndTime,OperHour,OperLocCode
	//手术科室名称：OperLocDesc、术者代码：OpertorCode、术者名称：OpertorName、一助：Assistant1、二助：Assistant2
	//,OperLocCode,OperLocDesc,OpertorCode,OpertorName,Assistant1,Assistant2
	//切口类型代码：IncisionCode、切口类型：Incision、愈合情况代码：HealingCode、愈合情况：Healing、麻醉方式代码：AnesMethodCode
	//,IncisionCode,Incision,HealingCode,Healing,AnesMethodCode
	//麻醉方式：AnesMethod、麻醉医师：Anesthesia,ASA评分：ASAScore、NNIS分级：NNISGrade、术前外周WBC计数：WBC、切口个数：IncisionNum
	//,AnesMethod,Anesthesia,ASAScore,NNISGrade,WBC,IncisionNum
	//是否使用窥镜：IsSightGlass、是否有植入物：IsImplants、失血量：LoseBlood、输血量：GotBlood、术后并发症：Complication
	//,IsSightGlass,IsImplants,LoseBlood,GotBlood,Complication
	i (stdate="")!(enddate="") s sdate=+$H,edate=+$H
	Set sdate=stdate
	Set edate=enddate
	Set:stdate["-" sdate=$zdh(stdate,3)
	Set:enddate["-" edate=$zdh(enddate,3)
	if (EpisodeId'=""){   
		s opaId=""
		f  s opaId=$O(^DHCANOPArrange(0,"Adm",EpisodeId,opaId)) q:opaId=""  d
		.d GetANOperationForM
	}else {  
		f date=sdate:1:+edate {
			s opaId=""
			f  s opaId=$O(^DHCANOPArrange(0,"SDate",date,opaId)) q:opaId=""  d
			.d GetANOperationForM  
		}
	}  
	k ^TMPAN("AppM",$j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

GetANOperationForM
	q:$d(^DHCANOPArrange(opaId))<1
	s ifOutOper=$g(^DHCANOPArrange("OUTOP",opaId))
	q:(ifOutOper="O") ;门诊不在之内
	s opdate="",oproomdes="",regNo="",patName="",diag=""
	s sopdes="",locdes="",opd="",mzdoc="",anmethod=""
	s xsh="",xch="",OPCategory="",opUnPlanedOperation="",ASA=""
	s IsSightGlass="",IsImplants="",LoseBlood="",GotBlood="",Complication=""
	s OperLocCode="",OperLocDesc="",OpertorCode="",OpertorName="",Assistant1="",Assistant2=""
	s IncisionCode="",Incision="",HealingCode="",Healing="",AnesMethodCode=""
	s oproomdes=""
	s LoseBlood=$p($g(^DHCANOPArrange(opaId,"InOut",11)),"^",3) 
	s opstdate=$P(^DHCANOPArrange(opaId),"^",14)
	i opstdate'="" s opstdate=$ZD(opstdate,3)
	s opsttime=$P(^DHCANOPArrange(opaId),"^",15)
	i opsttime'=""  s opsttime=$ZT(opsttime,2)
	s openddate=$P(^DHCANOPArrange(opaId),"^",16)
	i openddate'="" s openddate=$ZD(openddate,3)
	s opendtime=$P(^DHCANOPArrange(opaId),"^",17)
	i opendtime'=""  s opendtime=$ZT(opendtime,2)
	s adm=$P(^DHCANOPArrange(opaId),"^",1),admId=adm
	q:adm=""
	s opaStatus=$P(^DHCANOPArrange(opaId),"^",27)
	q:(opaStatus="D")!(opaStatus="C")
		i opaStatus="A" s status="申请"
	i (opaStatus="D") s status="拒绝"
	i opaStatus="R" s status="安排"
	i opaStatus="N" s status="非预约"
	i opaStatus="I" s status="术中"
	i opaStatus="P" s status="恢复室"
	i opaStatus="L" s status="术毕"
	i opaStatus="F" s status="完成"
	i (opaStatus="C") s status="撤销"
	i opaStatus="S" s status="拟日间"
	s oproomdr=$P(^DHCANOPArrange(opaId),"^",20)
	i oproomdr'="" s oproomdes=$p($g(^DHCANC("OPRoom",oproomdr)),"^",2)
	s opaPatStatus=$P(^DHCANOPArrange(opaId),"^",23)
	s papmiId=$p($g(^PAADM(admId)),"^",1)
	s chl=$P($P(^DHCANOPArrange(opaId),"^",2),"||",2)
	s jz=$P(^OR(adm,"ANA",chl),"^",32) //ANA_SourceType 急诊(E)/择期(B)
	i jz="E" s jzstat="急诊"
	e  s jzstat="择期"
	;;;;最后手术登记存放的时间，20120607+dyl
	s anaTheatreIn=""
	s anaTheatreInDate=$p(^OR(adm,"ANA",chl),"^",39)
	i anaTheatreInDate'="" s anaTheatreInDate=$zd(anaTheatreInDate,3)
	e  s anaTheatreInDate=opstdate
	s anaTheatreInTime=$p(^OR(adm,"ANA",chl),"^",40)
	i anaTheatreInTime'="" s anaTheatreInTime=$zt(anaTheatreInTime,2)
	e  s anaTheatreInTime=opsttime
	
	s ass=0,surgeonDesc=""
	;ANA_Method:麻醉方法+dyl+20120611
	s mzdoc=""
	s mzdr=$P(^OR(adm,"ANA",chl),"^",6)        				;ANA_Anaesthetist_Dr 
	i mzdr'="" d		
	.s mzdoc=##class(web.DHCANOPCom).GetNameById(mzdr)		;麻醉医师
	.e  s mzdoc=""
	s anmethod="",anmethodCodeStr=""
	s anmthdr=$P(^OR(adm,"ANA",chl),"^",5)
	s anmthdr=$tr(anmthdr,"|",",")
	i anmthdr'="" d
	.s anmetNum=$l(anmthdr,",")
	.f i=1:1:anmetNum d
	..s anmetId=$p(anmthdr,",",i)
	..q:anmetId=""
	..s anmethodCode=$p($g(^ORC("ANMET",anmetId)),"^",1)
	..s anmetDesc=$p($g(^ORC("ANMET",anmetId)),"^",2)
	..i $P(anmetDesc,"-",2)'="" s anmetDesc=$P(anmetDesc,"-",2)
	..i (anmethod'="")&(anmethod'[anmetDesc) s anmethod=anmethod_","_anmetDesc
	..i (anmethod'="")&(anmethod[anmetDesc) s anmethod=anmethod
	..e  s anmethod=anmetDesc
	..e  i (anmethodCodeStr'="")&(anmethodCodeStr'[anmethodCode) s anmethodCodeStr=anmethodCodeStr_","_anmethodCode
	..e  i (anmethodCodeStr'="")&(anmethodCodeStr[anmethodCode) s anmethodCodeStr=anmethodCode
	..e  s anmethodCodeStr=anmethodCode

	;并发症
	s anCompDesc="" ,diag=""                                        //+ wxl 090316 合并疾病
	s subchl=0 f  s subchl=$O(^OR(adm,"ANA",chl,"COMP",subchl)) q:(subchl="")  d
	.s AnCompDr=$P(^OR(adm,"ANA",chl,"COMP",subchl),"^",1)
	.q:AnCompDr=""
	.i anCompDesc="" s anCompDesc=$P(^ORC("COMP",AnCompDr),"^",2)
	.e  s anCompDesc=anCompDesc_","_$P(^ORC("COMP",AnCompDr),"^",2)
		.s predigdrS=$P($g(^OR(adm,"ANA",chl,"OP",subchl)),"^",4)   		;ANAOP_PreopDiag_DR 术前诊断字符串  zhangtao add
	.s num=$l(predigdrS,"|")
	.f pi=1:1:num d
	..s predigdr=$p(predigdrS,"|",pi)
	..i predigdr'=""  d
	...s anaOPPreopDiagDR=$P(^MRC("ID",predigdr),"^",2)
	..s $p(diag,",",pi)=$G(anaOPPreopDiagDR)
	..e  d
	...i $g(^OR(EpisodeID,"ANA",anaSub,"TXT",2))'="" d 
	....s diamen=$p(^OR(EpisodeID,"ANA",anaSub,"TXT",2),"|",pi)  
	....s $p(diag,",",pi)=$G(diamen)            //zhangtao add
	s i=0
	s icdCodeStr="",OpertorCode="",opdes="",anaopBladeTypeCode="",anaopBladeType=""
	s subchl=0 f  s subchl=$O(^OR(adm,"ANA",chl,"OP",subchl)) q:(subchl="")  d
	.s opdr=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",6) ;ANAOP_Type_DR ；手术名称
	.i opdr'=""  d
	..i $P($g(^ORC("OPER",+opdr)),"^",2)'="" d  
	...s operICDcode=$p(^ORC("OPER",+opdr),"^",14)
	...i opdes'="" s opdes=opdes_"," _$P($g(^ORC("OPER",+opdr)),"^",2)
	...e  s opdes=$P($g(^ORC("OPER",+opdr)),"^",2)
	...i icdCodeStr'="" s icdCodeStr=icdCodeStr _"," _operICDcode
	...e  s icdCodeStr=operICDcode
	.e  d
	..i $g(^OR(adm,"ANA",chl,"OP",subchl,"REM",2))'="" d
	...s opdes=$G(^OR(adm,"ANA",chl,"OP",subchl,"REM",2))
	.s i=i+1
	.q:i>1 ;手术级别只取主手术的
	.s opd=""
	.s docdr=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",8) ;ANAOP_Surgeon_DR 手术医师
	.i docdr'="" d
	..s opd=##class(web.DHCANOPCom).GetNameById(docdr)
	..s userId=$o(^SSU("SSUSR",0,"CTPCP",docdr,""),-1)
	..i userId'="" s OpertorCode=$p($g(^SSU("SSUSR",userId)),"^",1)
	.s surgeonDesc=opd   
	.s operLocId=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",10) ;ANAOP_CTLOC_DR
	.s as=0 f  s as=$O(^OR(adm,"ANA",chl,"OP",subchl,"ASS",as)) q:(as="")  d
	..s asdr=$P(^OR(adm,"ANA",chl,"OP",subchl,"ASS",as),"^",1)
	..i as=1 s ass1=##class(web.DHCANOPCom).GetNameById(asdr)
	..i as=2 s ash=##class(web.DHCANOPCom).GetNameById(asdr)
	    .s curAnaopBladeTypeId=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",9)
	.i curAnaopBladeTypeId'="" d
	..s tmpCode=$p(^ORC("BLDTP",curAnaopBladeTypeId),"^",1)
	..i anaopBladeTypeCode'="" d
	...s anaopBladeTypeCode=anaopBladeTypeCode_","_tmpCode
	...s anaopBladeType=anaopBladeType_","_$p(^ORC("BLDTP",+curAnaopBladeTypeId),"^",2)
	..e  s anaopBladeTypeCode=tmpCode,anaopBladeType=$p(^ORC("BLDTP",+curAnaopBladeTypeId),"^",2)

	s EpisodeID=$P(^DHCANOPArrange(opaId),"^",1)

	s anaId=$P(^DHCANOPArrange(opaId),"^",2)
	s anaSub=$P(anaId,"||",2)
	s appLocId=$P($G(^DHCANOPArrange(opaId)),"^",54) //OPA_AppLoc_Dr
	s adm=$P(^DHCANOPArrange(opaId),"^",1)
	i appLocId="" s appLocId=$P(^PAADM(adm),"^",4)
	s appLocDesc=$P($G(^CTLOC(+appLocId)),"^",2)
	s appLocCode=$P($G(^CTLOC(+appLocId)),"^",1)
	s ASA=$p(##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"ASAClass"),$c(3),1)
	s NNISGrade=$p(##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"NNISRate"),$c(3),1)
	Set Anesthesia=mzdoc   // 麻醉医师
	// 手术时长
	Set OperHour = ..GetHourByDateTime(opstdate,opsttime,openddate,opendtime)
	s newSdate=""
	i anaTheatreInDate'="" s newSdate=anaTheatreInDate
	e  s newSdate=opstdate
	s operTypeValue=""
	s retStrT=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"comOPType")
	i retStrT'="" s operTypeValue=$p(retStrT,$c(3),1)
	/*
	&sql(select RowId into :tmpopaId from CIS_AN.OperSchedule where ExternalID=:opaId )	
	s sheetId=""
	f  s sheetId=$o(^CIS.AN.RecordSheetI("IOPS",tmpopaId,sheetId)) q:sheetId=""  d
	.s sheetObj=##class(CIS.AN.RecordSheet).%OpenId(sheetId)
	.s DataModule=sheetObj.DataModule.Code
	.q:DataModule'="AN_ANS_006"
	.;SELECT * FROM CIS_AN.OperData
	.s selDataItem="OperationType"
	.&sql(select DataValue into :operTypeValue from CIS_AN.OperData where RecordSheet=:sheetId and DataItem=:selDataItem)	
	*/
	s ^TMPAN("AppM",$j,opaId)=$lb(opaId,EpisodeID,icdCodeStr,opdes,jzstat,newSdate,opsttime,openddate,opendtime,OperHour,appLocCode,appLocDesc,OpertorCode,surgeonDesc,ass1,ass2,anaopBladeTypeCode,anaopBladeType,HealingCode,Healing,anmethodCodeStr,anmethod,Anesthesia,ASA,NNISGrade,WBC,IncisionNum,IsSightGlass,IsImplants,LoseBlood,GotBlood,anCompDesc,diag,oproomdes,opaStatus,operTypeValue)
	d OutRow2
	q

OutRow2
	Set ^CacheTemp(repid,ind)=^TMPAN("AppM",$j,opaId)
	Set ind=ind+1
	quit
}

ClassMethod GetAnOpListForMFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAnOpListForMExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
  	Set repid=$LIST(qHandle,2)
  	Set ind=$LIST(qHandle,3)
  	Set ind=$o(^CacheTemp(repid,ind))
  	If ind="" { // if there are no more rows, finish fetching
  		Set AtEnd=1
  		Set Row=""
  	}
  	Else {
  		Set Row=^CacheTemp(repid,ind)
  	}
  	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetAnOpListForMClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAnOpListForMExecute ]
{
	Set repid=$LIST(qHandle,2)
  	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Creator：     zhoubo
/// CreatDate：   2017-08-04
/// Description:  计算两个时间的间隔小时数（时差-小时）
/// Input：       aFromDate ：开始日期  YYYY-MM-DD 或者 数字格式
///               aFromTime : 开始时间  HH:MM:SS   或者 数字格式
///               aEndDate  ：结束日期  YYYY-MM-DD 或者 数字格式
///               aEndTime  : 结束时间  HH:MM:SS   或者 数字格式
/// Return:		  时间间隔小时数
/// Debug:		  w ##class(DHCHAI.Utils.CommonSrv).GetHourByDateTime("2017-08-04","01:00:00","2017-08-04","05:00:00")
ClassMethod GetHourByDateTime(aFromDate As %String, aFromTime As %String, aEndDate As %String, aEndTime As %String) As %String
{
	Set return=0
	Quit:(aFromDate="")||(aFromTime="")||(aEndDate="")||(aEndTime="") return
	Set Hours=0
	Set:aFromDate["-" aFromDate=$zdh(aFromDate,3)
	Set:aFromTime[":" aFromTime=$zth(aFromTime,1)
	Set:aEndDate["-" aEndDate=$zdh(aEndDate,3)
	Set:aEndTime[":" aEndTime=$zth(aEndTime,1)
	Quit:(aFromDate>aEndDate) return  // 开始日期大于结束日期
	Quit:(aFromDate=aEndDate)&&(aFromTime>aEndTime) return
	
	If (aFromDate=aEndDate) {
		Set Hours=$Number((aEndTime-aFromTime)/3600,0)+1     // 向上取整
	} Else {  // aFromDate<aEndDate
		Set DayHours=(aEndDate-aFromDate)*24
		Set tmpHours=$Number((aEndTime-aFromTime)/3600,0)+1  // 向上取整
		Set Hours=DayHours+tmpHours
	}
	Set return = Hours
	Quit return
}

/// 20170809+dyl+停台率
/// 入参：stdate：开始日期,enddate:结束日期
/// 返回结果：AppLocId：申请科室Id,AppLoc：申请科室描述
/// ,AllOperNum:科室内手术总数,DeclineOperNum：拒绝手术总数,CancelOperNum：撤销手术总数
/// ,DeclinePer:拒绝百分比,CancelPer:撤销百分比
/// d ##class(%ResultSet).RunQuery("web.DHCANAdaptor","OperPercent","2017-01-01","2017-07-07")
Query OperPercent(stdate, enddate) As %Query(ROWSPEC = "AppLocId,AppLoc,AllOperNum,DeclineOperNum,CancelOperNum,DeclinePer,CancelPer")
{
}

ClassMethod OperPercentExecute(ByRef qHandle As %Binary, stdate, enddate) As %Status
{
	 Set repid=$I(^CacheTemp)
     If $g(ind)="" Set ind=1
     i (stdate="")!(enddate="") s sdate=+$H,edate=+$H
	e  s sdate=##Class(web.DHCANOPCom).ConvertToDateH(stdate),edate=##Class(web.DHCANOPCom).ConvertToDateH(enddate)
	k LocAllOpList,LocDeclineOpList,LocCancelOpList
	f date=sdate:1:edate
    {
	s opaId=""
		f  s opaId=$O(^DHCANOPArrange(0,"SDate",date,opaId)) q:opaId=""  d
		.q:$d(^DHCANOPArrange(opaId))<1
		.s appLocId=$p($g(^DHCANOPArrange(opaId)),"^",54)
		.s adm=$P(^DHCANOPArrange(opaId),"^",1)
		.i appLocId="" s appLocId=$P(^PAADM(adm),"^",4)
		.s opaStatus=$P(^DHCANOPArrange(opaId),"^",27)
		.i opaStatus="A" s status="申请"
		.i (opaStatus="D") s status="拒绝",LocDeclineOpList(appLocId,opaId)=""
		.i opaStatus="R" s status="安排"
		.i opaStatus="N" s status="非预约"
		.i opaStatus="I" s status="术中"
		.i opaStatus="P" s status="恢复室"
		.i opaStatus="L" s status="术毕"
		.i opaStatus="F" s status="完成"
		.i (opaStatus="C") s status="撤销",LocCancelOpList(appLocId,opaId)=""
		.q:opaStatus="A"	;申请没有安排不在统计之内
		.s LocAllOpList(appLocId,opaId)=""
    }	
    	s locId="" f  s locId=$o(LocAllOpList(locId)) q:locId=""  d
    	.s apploc=$p(^CTLOC(locId),"^",2)
			.s locallnum=0,locdnum=0,loccnum=0,dper="",cper=""
			.s topaId="" f  s topaId=$o(LocAllOpList(locId,topaId)) q:topaId=""  d
				..s locallnum=locallnum+1
			.s dopaId="" f  s dopaId=$o(LocDeclineOpList(locId,dopaId)) q:dopaId=""  d
				..s locdnum=locdnum+1
			.s copaId="" f  s dopaId=$o(LocCancelOpList(locId,copaId)) q:copaId=""  d
				..s loccnum=loccnum+1
			.i locallnum'=0 d
			..i locdnum'=0 d
			...s dper=$fn(100*(locdnum/locallnum),"",2)_"%"
			..i loccnum'=0 d
			...s cper=$fn(100*(loccnum/locallnum),"",2)_"%"
			.d Output2

     Set qHandle=$lb(0,repid,0)
	 Quit $$$OK

Output2
	 set Data=$lb(locId,apploc,locallnum,locdnum,loccnum,dper,cper)
	 Set ^CacheTemp(repid,ind)=Data
	 Set ind=ind+1
	 quit
}

ClassMethod OperPercentFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = OperPercentExecute ]
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

ClassMethod OperPercentClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = OperPercentExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// 20170809+dyl+停台率
/// 入参：stdate：开始日期,enddate:结束日期
/// 返回结果：CtlocId：申请科室Id,locDesc：申请科室描述
/// ,AllOperNum:科室内手术总数,StopS：拒绝手术总数+比例,StopA：撤销手术总数+比例
/// ,StartEarly:首台过9:00,FinishLate:手术完成时间超过17:00，LocAllNum科室内总手术数(除去申请状态)
/// ,OverNum:不管是不是台次1，只要是最早，且大于9点的，统计,OverPer：超时+比例
/// d ##class(%ResultSet).RunQuery("web.DHCANAdaptor","OperActInfo","2016-01-01","2017-07-07","")
Query OperActInfo(stdate, enddate, type) As %Query(ROWSPEC = "CtlocId,locDesc,StopS,StopA,OpNum,StartEarly,FinishLate,LocAllNum,OverNum,OverPer")
{
}

ClassMethod OperActInfoExecute(ByRef qHandle As %Binary, stdate, enddate, type) As %Status
{
	 Set repid=$I(^CacheTemp)
     If $g(ind)="" Set ind=1
     i (stdate="")!(enddate="") s sdate=+$H,edate=+$H
	e  s sdate=##Class(web.DHCANOPCom).ConvertToDateH(stdate),edate=##Class(web.DHCANOPCom).ConvertToDateH(enddate)
	k LocAllOpList,LocDeclineOpList,LocCancelOpList,LocFinishOpList,RoomLastList,RoomFirstList
	k RoomNewList
	f date=sdate:1:edate
    {
	s opaId="",lastroomtime=0
		f  s opaId=$O(^DHCANOPArrange(0,"SDate",date,opaId)) q:opaId=""  d
		.q:$d(^DHCANOPArrange(opaId))<1
		.s appLocId=$p($g(^DHCANOPArrange(opaId)),"^",54)
		.s adm=$P(^DHCANOPArrange(opaId),"^",1)
		.i appLocId="" s appLocId=$P(^PAADM(adm),"^",4)
		.s chl=$P($P(^DHCANOPArrange(opaId),"^",2),"||",2)
		.s jz=$P(^OR(adm,"ANA",chl),"^",32)   						//ANA_SourceType 急诊(E)/择期(B)
		.i jz="E" s jzstat="1"
		.e  s jzstat="2"
		.q:(type'="")&(jzstat'=type)
		.s opaStatus=$P(^DHCANOPArrange(opaId),"^",27)
		.i opaStatus="A" s status="申请"
		.i (opaStatus="D") s status="拒绝",LocDeclineOpList(appLocId,opaId)=""
		.i opaStatus="R" s status="安排"
		.i opaStatus="N" s status="非预约"
		.i opaStatus="I" s status="术中"
		.i opaStatus="P" s status="恢复室"
		.i opaStatus="L" s status="术毕"
		.i opaStatus="F" s status="完成",LocFinishOpList(appLocId,opaId)=""
		.i (opaStatus="C") s status="撤销",LocCancelOpList(appLocId,opaId)=""
		.q:opaStatus="A"	;申请没有安排不在统计之内
		.s LocAllOpList(appLocId,opaId)=""
		.;
		.s opstdate=$P(^DHCANOPArrange(opaId),"^",14)
		.s opendtime=$P(^DHCANOPArrange(opaId),"^",17)
		.s opsttime=$P(^DHCANOPArrange(opaId),"^",15)
		.s oproomdr=$P(^DHCANOPArrange(opaId),"^",20)
		.s opordno=$P(^DHCANOPArrange(opaId),"^",26)
		.i oproomdr'="" s lastroomtime=$g(RoomNewList(appLocId,opstdate,oproomdr))
		.i (lastroomtime>opsttime) s lastroomtime=opsttime
		.e  s lastroomtime=opsttime
		.i oproomdr'="" s RoomNewList(appLocId,opstdate,oproomdr)=lastroomtime
		.i (opordno=1)&(opsttime>32400) s RoomFirstList(appLocId,opstdate,oproomdr)=""
		.
		.i (opendtime>61200) s RoomLastList(appLocId,opaId)=""
    }	
    			
    	s locId="" f  s locId=$o(LocAllOpList(locId)) q:locId=""  d
    		.s apploc=$p(^CTLOC(locId),"^",2)
			.s locallnum=0,locdnum=0,loccnum=0,dper="",cper="",flocnum=0,fper="",lper=""
			.s postnum=0,pper=""
	    	.s newday=""  f  s newday=$o(RoomNewList(locId,newday)) q:newday=""  d
	    		..s nroomdr=""  f  s nroomdr=$o(RoomNewList(locId,newday,nroomdr)) q:nroomdr=""  d
	    			...s posttime=$g(RoomNewList(locId,newday,nroomdr))
	    			...i posttime>32400 s postnum=postnum+1
	    	.s firstnum=0,lastnum=0,locd="",locc="",locf="",lloc=""
	    	.
	    	.s day1=""  f  s day1=$o(RoomFirstList(locId,day1)) q:day1=""  d
	    		..s room=""  f  s room=$o(RoomFirstList(locId,day1,room)) q:room=""  d
	    			...s firstnum=firstnum+1
	    	.s day2=""  f  s day2=$o(RoomLastList(locId,day2)) q:day2=""  d
    				..s lastnum=lastnum+1
			.s topaId="" f  s topaId=$o(LocAllOpList(locId,topaId)) q:topaId=""  d
				..s locallnum=locallnum+1
			.s fopaId="" f  s fopaId=$o(LocFinishOpList(locId,fopaId)) q:fopaId=""  d
				..s flocnum=flocnum+1
			.s dopaId="" f  s dopaId=$o(LocDeclineOpList(locId,dopaId)) q:dopaId=""  d
				..s locdnum=locdnum+1
			.s copaId="" f  s dopaId=$o(LocCancelOpList(locId,copaId)) q:copaId=""  d
				..s loccnum=loccnum+1
			.i locallnum'=0 d
				..i locdnum'=0 d
					...s dper=$fn(100*(locdnum/locallnum),"",2)_"%"
				..i loccnum'=0 d
					...s cper=$fn(100*(loccnum/locallnum),"",2)_"%"
				..i firstnum'=0 d
					...s fper=$fn(100*(firstnum/locallnum),"",2)_"%"
				..i lastnum'=0 d
					...s lper=$fn(100*(lastnum/locallnum),"",2)_"%"
				..i postnum'=0 d
					...s pper=$fn(100*(postnum/locallnum),"",2)_"%"
			.i dper'="" s locd=locdnum_"("_dper_")"
			.e  s locd=locdnum
			.i cper'="" s locc=loccnum_"("_cper_")"
			.e  s locc=loccnum
			.i fper'="" s locf=firstnum_"("_fper_")"
			.e  s locf=firstnum
			.i lper'="" s lloc=lastnum_"("_lper_")"
			.e  s lloc=lastnum
			.i pper'="" s ploc=postnum_"("_pper_")"
			.e  s ploc=postnum
			.d OutputAI

     Set qHandle=$lb(0,repid,0)
	 Quit $$$OK

OutputAI
	 set Data=$lb(locId,apploc,locd,locc,flocnum,locf,lloc,locallnum,postnum,ploc)
	 Set ^CacheTemp(repid,ind)=Data
	 Set ind=ind+1
	 quit
}

ClassMethod OperActInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = OperActInfoExecute ]
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

ClassMethod OperActInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = OperActInfoExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// 20170918+dyl
/// 通过就诊号获取病人手术是否收费信息
/// w ##class(web.DHCANAdaptor).GetOperOrdInfoByAdmId(236)
/// 返回病人某日在某手术室做的某手术是否收费，分为四种情况:已收费，未收费，手术室未收费，麻醉科未收费
ClassMethod GetOperOrdInfoByAdmId(needEpisodeID As %String) As %String
{
	q:needEpisodeID="" "就诊号不可为空"
	s papmiId=$p($g(^PAADM(needEpisodeID)),"^",1)
	s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	s cahrgeTogether=$g(^DHCCLSet("AnOp","ChargeTogether"))
	i cahrgeTogether="" s cahrgeTogether="N"
	s ordFlag=""
	s retstr=""
	s opaId="" f  s opaId=$O(^DHCANOPArrange(0,"Adm",needEpisodeID,opaId)) q:opaId=""  d
		.s opNurseOrd=$p($G(^DHCANOPArrange(opaId)),"^",50)
		.s anaDoctorOrd=$p($G(^DHCANOPArrange(opaId)),"^",48)
		.s opaStatus=$P(^DHCANOPArrange(opaId),"^",27)
		.q:(opaStatus="")!(opaStatus="C")!(opaStatus="D")
		.i (cahrgeTogether="Y") d
			..i opNurseOrd'="Y" d
				...s ordFlag="未收费"
			..e  s ordFlag="已收费"
		.e  d
			..i (opNurseOrd="Y")&(anaDoctorOrd'="Y") d
				...s ordFlag="麻醉科未收费"
			..i (opNurseOrd'="Y")&(anaDoctorOrd="Y") d
				...s ordFlag="手术室未收费"
			..i (opNurseOrd'="Y")&(anaDoctorOrd'="Y") d
				...s ordFlag="未收费"
			..e  s ordFlag="已收费"
		.s opstdate=$P(^DHCANOPArrange(opaId),"^",14)
		.s opstd=$zd(opstdate,3)
		.s anaId=$p(^DHCANOPArrange(opaId),"^",2)
		.s adm=$p(anaId,"||",1)
		.s chl=$p(anaId,"||",2)
		.s opdes=""
		.s subchl=0 f  s subchl=$O(^OR(adm,"ANA",chl,"OP",subchl)) q:(subchl="")  d 
			..s opdr=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",6)       		;ANAOP_Type_DR     ；手术名称
			..i opdr'=""  d
				...i $P($g(^ORC("OPER",+opdr)),"^",2)'="" d  
				....i opdes'="" s opdes=opdes_";"     
				....s opdes=opdes_$P($g(^ORC("OPER",+opdr)),"^",2)    
			..e  d
				...i $g(^OR(adm,"ANA",chl,"OP",subchl,"REM",2))'="" d
					....i opdes'="" s opdes=opdes_";"
					....s opdes=opdes_$G(^OR(adm,"ANA",chl,"OP",subchl,"REM",2))
			..s anaOpSubTmp2="",inum=0,anaOpSubTmp=""
			..f  s anaOpSubTmp2=$o(^OR(adm,"ANA",chl,"OP",anaOpSubTmp2)) q:(anaOpSubTmp2="")!(inum>0)  d
				...s inum=anaOpSubTmp2
				...i inum>0 s anaOpSubTmp=inum
			..s operLocId=$P(^OR(adm,"ANA",chl,"OP",anaOpSubTmp),"^",10)
			..s oploc=$p(^CTLOC(operLocId),"^",2)
		.i retstr="" d
			..s retstr=patName_"于"_opstd_"在"_oploc_"所行手术:"_opdes_ordFlag
		.e  i retstr'="" d
			..s retstr=retstr_"^"_patName_"于"_opstd_"在"_oploc_"所行手术:"_opdes_ordFlag
	i retstr="" s retstr="该就诊号没有对应手术记录"
	e  s retstr=cahrgeTogether_"@"_retstr
	q retstr
}

/// 入参：就诊号
/// 返回：开始日期，手术结束时间，申请日期，主刀，一助，二助
/// 		麻醉医生，麻醉方法，手术详细信息，opaId(手术唯一标示)
/// 说明：多条手术记录用"^"分割，返回值用"#"分割，
///      单条具体手术信息用"/"分割:opdesc:手术名称，OPCategory：手术分类，OPICDCode：ICD10，anaopBladeType：切口类型
ClassMethod GetAdmOperInfoForEMR(EpisodeID As %String) As %String
{
	s retStr=""
	q:EpisodeID="" retStr
	s opaId="",OPCategory=""
	f  s opaId=$o(^DHCANOPArrange(0,"Adm",EpisodeID,opaId)) q:opaId=""  d
		.q:'$d(^DHCANOPArrange(opaId))
		.s opaStatus=$P(^DHCANOPArrange(opaId),"^",27)
		.q:opaStatus'="F"
		.q:(opaStatus="")||(opaStatus="D")
		.s opstdate=$P(^DHCANOPArrange(opaId),"^",14)
		.s opsttime=$P(^DHCANOPArrange(opaId),"^",15)
		.s openddate=$P(^DHCANOPArrange(opaId),"^",16)
		.s opendtime=$P(^DHCANOPArrange(opaId),"^",17)
		.s opst=$zd(opstdate,3)_" "_$zt(opsttime,2)
		.s opend=$zd(openddate,3)_" "_$zt(opendtime,2)
		.s opAppdate=$P(^DHCANOPArrange(opaId),"^",3)
		.s opApptime=$P(^DHCANOPArrange(opaId),"^",5)
		.s opapp=$zd(opAppdate,3)_" "_$zt(opApptime,2)
		.s adm=EpisodeID
		.s chl=$P($P(^DHCANOPArrange(opaId),"^",2),"||",2)
		.s opStr="",anaopBladeType="",OPICDCode="",OPCategory=""
		.s subchl=0 f  s subchl=$O(^OR(adm,"ANA",chl,"OP",subchl)) q:(subchl="")  d
		    ..s curAnaopBladeTypeId=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",9)
			..i curAnaopBladeTypeId'="" d
				...s anaopBladeType=$p(^ORC("BLDTP",+curAnaopBladeTypeId),"^",2)
			..s opdr=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",6)     ;ANAOP_Type_DR ；手术名称
			..q:opdr=""	;手工填写暂时不考虑
			..i opdr'=""  d
				...q:$d(^ORC("OPER",+opdr))<1
				...s opdesc=$P($g(^ORC("OPER",+opdr)),"^",2)
				...;手术分类
				...s OPCategoryId=$p($g(^ORC("OPER",opdr)),"^",7)
				...i OPCategoryId'="" s OPCategory=$p($g(^ORC("CATEG",OPCategoryId)),"^",2)
				...s OPICDCode=$p($g(^ORC("OPER",opdr)),"^",14)	;ICD10
				...i opStr'="" s opStr=opStr_","_opdesc_"/"_OPCategory_"/"_OPICDCode_"/"_anaopBladeType
				...e  s opStr=opdesc_"/"_OPCategory_"/"_OPICDCode_"/"_anaopBladeType
			..;ANAOP_Surgeon_DR  ；手术医师
			..s docdr=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",8)      
			..s anaOPSurgeonDR=$g(docdr)
			..s anaOpSurgeon=##class(web.DHCClinicCom).GetNameById(anaOPSurgeonDR)
			..;切口愈合等级
		..s p=0,assistantSecondCtcpId="",assistantFirstCtcpId="",assistantFirstCtcp=""
		..s assistantSecondCtcp=""
		..s as=0 f  s as=$O(^OR(adm,"ANA",chl,"OP",1,"ASS",as)) q:(as="")  d
			...s asdr=$P(^OR(adm,"ANA",chl,"OP",subchl,"ASS",as),"^",1)
			...q:asdr=""
			...s p=p+1
			...i p=1 s assistantFirstCtcpId=$g(asdr)  ;一助
			...i assistantFirstCtcpId'="" s assistantFirstCtcp=##class(web.DHCClinicCom).GetNameById(assistantFirstCtcpId)
			...i p=2 s assistantSecondCtcpId=$g(asdr) ;二助
			...i assistantSecondCtcpId'="" s assistantSecondCtcp=##class(web.DHCClinicCom).GetNameById(assistantSecondCtcpId)
		.s anmthdr=$P(^OR(adm,"ANA",chl),"^",5) ;/麻醉方法相关
		.s anaMethod=""        
		.i anmthdr'="" d
			..s anmetNum=$l(anmthdr,"|")
			..f i=1:1:anmetNum d
				...s anmetId=$p(anmthdr,"|",i)
				...q:anmetId=""
				...s anmetDesc=$p($g(^ORC("ANMET",anmetId)),"^",2) ;麻醉方法描述
				...i $P(anmetDesc,"-",2)'="" s anmetDesc=$P(anmetDesc,"-",2)
				...i anaMethod="" s anaMethod=anmetDesc
				...e  s anaMethod=anaMethod_"^"_anmetDesc
		.s anaDoctor=""
		.s anadr=$P(^OR(adm,"ANA",chl),"^",6)        ; ANA_Anaesthetist_Dr
		.i anadr'="" d
			..s anaDoctor=##class(web.DHCClinicCom).GetNameById(anadr)
		.e  s anaDoctor="" 
		.i retStr'="" d
			..s retStr=retStr_"^"_opst_"#"_opend_"#"_opapp_"#"_anaOpSurgeon_"#"_assistantFirstCtcp_"#"_assistantSecondCtcp
			..s retStr=retStr_"#"_anaDoctor_"#"_anaMethod_"#"_opStr_"#"_opaId
		.e  d
			..s retStr=opst_"#"_opend_"#"_opapp_"#"_anaOpSurgeon_"#"_assistantFirstCtcp_"#"_assistantSecondCtcp
			..s retStr=retStr_"#"_anaDoctor_"#"_anaMethod_"#"_opStr_"#"_opaId
	q retStr
}

/// 入参改为多个:医生Code1^手术Id1^授权码1!医生Code2^手术Id2^授权码2!.......，多个授权之间以!分割    
/// str:医生Code^手术Id^授权码（Y/N）[64^3860^Y]
/// 第一种条件
/// w ##class(web.UDHCANOPArrange).GetOrcDocOper("095^3860^Y")
/// 第二种条件
/// w ##class(web.UDHCANOPArrange).GetOrcDocOper("095^3860^N")
/// 第三种条件
/// w ##class(web.UDHCANOPArrange).GetOrcDocOper("095^1^Y")
/// 第四种条件
/// w ##class(web.UDHCANOPArrange).GetOrcDocOper("095^2^N")
/// 第五种条件
/// w ##class(web.DHCANAdaptor).GetOrcDocOper("073^1^Y")
ClassMethod GetOrcDocOper(str As %String) As %String
{
	q:str="" ""
	s ret=0
	s strlen=$l(str,"!")
	f j=1:1:strlen d
	.s opStr=$p(str,"!",j)
	.d SetOrcDocOper
	q ret
SetOrcDocOper	
	s docId="",docCode="",operId="",yesOrNo=""
	//s docCode=$p($g(str),"^",1),operId=$p($g(str),"^",2),yesOrNo=$p($g(str),"^",3)
	s docCode=$p($g(opStr),"^",1),operId=$p($g(opStr),"^",2),yesOrNo=$p($g(opStr),"^",3)
	if docCode="" s ret="医护人员Code不能为空"
	q:ret'=0
	s docId=$o(^CTPCP(0,"Code",$$ALPHAUP^SSUTIL4(docCode),0))
	if docId="" s ret="医护人员Id不能为空"
	q:ret'=0
	s operStr="",operStr1="",operStr2="",operStr3=""
	s operStr=$g(^CTPCP(docId,"DHCAN","OperId"))
	s operStr1="^"_$g(^CTPCP(docId,"DHCAN","OperId"))_"^"
	
	i ((operStr'="")&(operStr1[("^"_operId_"^"))&(yesOrNo="Y"))		///1
	{
		s ^CTPCP(docId,"DHCAN","OperId")=operStr
	}
	i ((operStr'="")&(operStr1[("^"_operId_"^"))&(yesOrNo="N"))		///2
	{
		s operStr2=$p(operStr1,"^"_operId_"^",1)_"^"_$p(operStr1,"^"_operId_"^",2)
		s len=$l(operStr2,"^")
		f i=1:1:len  d
		.s operId1=$p(operStr2,"^",i)
		.q:operId1=""
		.i (operStr3="")  s operStr3=operId1
		.else  s operStr3=operStr3_"^"_operId1
		s ^CTPCP(docId,"DHCAN","OperId")=operStr3
	}
	
	i ((operStr'="")&(operStr1'[("^"_operId_"^"))&(yesOrNo="Y"))	///3
	{
		s ^CTPCP(docId,"DHCAN","OperId")=operStr_"^"_operId
	}
	
	i ((operStr'="")&(operStr1'[("^"_operId_"^"))&(yesOrNo="N"))	///4
	{
		s ^CTPCP(docId,"DHCAN","OperId")=operStr
	}
	i (operStr="")													///5
	{
		s ^CTPCP(docId,"DHCAN","OperId")=operId
	}
}

/// 手术字典
ClassMethod GetOrcOperation(inPut As %String = "") As %GlobalCharacterStream
{
	;w ##class(web.DHCANAdaptor).GetOrcOperation()
	s retStr=""
	s retStr=##class(%GlobalCharacterStream).%New()
	d retStr.Rewind()
	d retStr.Write("<Response>")
	s ret=0
    s operId=""
    f  s operId=$O(^ORC("OPER",operId)) q:operId=""  d
    .s myobj=##class(User.DHCInterfaceOperation).%New()
    .s opname=$p(^ORC("OPER",operId),"^",2)
    .s opICDCode=$p(^ORC("OPER",operId),"^",14)
    .s myobj.OperId =operId
	.s myobj.OperName=opname     
	.s myobj.OperICDCode=opICDCode  
	.s Xml=##class(%GlobalCharacterStream).%New()
	.s ret=myobj.XMLExportToStream(.Xml,"Operation")
	.q:ret=0
	.d retStr.CopyFrom(Xml)
	d retStr.Write("</Response>")
	q retStr
}

/// 有返回1，无返回0
/// w ##class(web.DHCANAdaptor).GetOperationFlagByAdm(236,2293)
ClassMethod GetOperationFlagByAdm(EpisodeID As %String, operId As %String) As %String
{
	s retStr=0
	q:EpisodeID="" retStr
	s opaId=""
	f  s opaId=$o(^DHCANOPArrange(0,"Adm",EpisodeID,opaId)) q:opaId=""  d
		.q:'$d(^DHCANOPArrange(opaId))
		.s chl=$P($P(^DHCANOPArrange(opaId),"^",2),"||",2)
		.s subchl=0 f  s subchl=$O(^OR(EpisodeID,"ANA",chl,"OP",subchl)) q:(subchl="")  d
			..s opdr=$P(^OR(EpisodeID,"ANA",chl,"OP",subchl),"^",6)     ;ANAOP_Type_DR     ；手术名称
			..i opdr=operId  s retStr=1 
	q retStr
}

/// Id,OpaId:手术排班表唯一标示,OperId：手术字典Id,OpDesc：手术名称
/// ,OpDoc:主刀医生,BladeTypeCode：切口代码,RegNo：登记号
/// ,BodySite:手术部位,TelNo:电话,OpStDate：手术开始日期,OpStTime,OperLoc：手术室,OperRoom：手术间
/// d ##class(%ResultSet).RunQuery("web.DHCANAdaptor","GetOperInfo","2017-01-02","2017-01-10")
Query GetOperInfo(stdate, enddate) As %Query(ROWSPEC = "RegNo,OpaId,OperId,OpDesc,OpDoc,BladeTypeCode,BodySite,TelNo,OpStDate,OpStTime,OperLoc,OperRoom") [ SqlProc ]
{
}

ClassMethod GetOperInfoExecute(ByRef qHandle As %Binary, stdate, enddate) As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    i (stdate="")!(enddate="") s sdate=+$H,edate=+$H
	e  s sdate=##Class(web.DHCANOPCom).ConvertToDateH(stdate),edate=##Class(web.DHCANOPCom).ConvertToDateH(enddate)
 	f date=sdate:1:edate
    {   
		s opaId="",opernum=0
		f  s opaId=$O(^DHCANOPArrange(0,"SDate",date,opaId)) q:opaId=""  d
			.q:$d(^DHCANOPArrange(opaId))<1
			.s adm=$P(^DHCANOPArrange(opaId),"^",1)
			.q:adm=""
			.s telNo=""
			.s PAADMMainMRADMDR=$p($g(^PAADM(adm)),"^",61) 
			.s PatientID=+$g(^PAADM(+adm))
			.s papmiId=$p($g(^PAADM(adm)),"^",1)
			.s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
			.s telNo=$p($g(^PAPER(papmiId,"ALL")),"^",4)
			.s chl=$P($P(^DHCANOPArrange(opaId),"^",2),"||",2)
			.s oproomdes=""
			.s oproomdr=$P(^DHCANOPArrange(opaId),"^",20)
			.i oproomdr'="" s oproomdes=$p($g(^DHCANC("OPRoom",oproomdr)),"^",2)
			 .s opStDate=$P(^DHCANOPArrange(opaId),"^",14)
    		.i opStDate'="" s opStDate=##class(web.DHCClinicCom).ConvertToDate(opStDate)
    		.s opsttime=$P(^DHCANOPArrange(opaId),"^",15)
    		.i opsttime'=""  s opsttime=$ZT(opsttime,2)
    		.s opSTDT=opStDate_" "_opsttime
			.s opdes="",anaopBladeTypeCode=""
			.;目前只传了主手术，考虑到多条手术id不好确定
			.s subchl=0 f  s subchl=$O(^OR(adm,"ANA",chl,"OP",subchl)) q:(subchl="")  d
			..q:subchl>1
			..s opdr=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",6)       		;ANAOP_Type_DR     ；手术名称
			..q:opdr=""
			..i opdr'=""  d
				...s opdes=$P($g(^ORC("OPER",+opdr)),"^",2)   
			..s docdr=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",8)      		;ANAOP_Surgeon_DR   手术医师
			..s opd=""
			..i docdr'="" s opd=##class(web.DHCANOPCom).GetNameById(docdr)
			..s anaopBladeTypeId=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",9)
			..s anaopBladeTypeCode=0
			..i anaopBladeTypeId'="" d
				...i anaopBladeTypeId'="" s anaopBladeTypeCode=$p($g(^ORC("BLDTP",+anaopBladeTypeId)),"^",1)
			..s bodsIdList=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",24) 	 //ypz 070418 	手术部位
		    ..s bodsList="",bodsDesc=""
		    ..i bodsIdList'="" d
			    ...s bodsIdNum=$l(bodsIdList,"|")
			    ...f j=1:1:bodsIdNum d
				    ....s bodsId=$p(bodsIdList,"|",j)
				    ....q:bodsId=""
				    ....s bodsDesc2=$p($g(^OEC("BODS",+bodsId)),"^",2)
				    ....;i bodsList="" s bodsList=bodsId_"|"_bodsDesc
				    ....;e  s bodsList=bodsList_"!"_bodsId_"|"_bodsDesc	
				    ....i bodsDesc="" s bodsDesc=bodsDesc2
				    ....e  s bodsDesc=bodsDesc_","_bodsDesc2 
			..s operLocId=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",10) 
			..s operLoc=$p(^CTLOC(operLocId),"^",2)  
		.d output

    }
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
   
output
 set Data=$lb(regNo,opaId,opdr,opdes,opd,anaopBladeTypeCode,bodsDesc,telNo,opStDate,opsttime,operLoc,oproomdes)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod GetOperInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOperInfoExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
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

ClassMethod GetOperInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOperInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 入参：就诊号
/// 返回值：用#分割，返回最近一次的手术记录,没有则返回:无相关手术记录
/// 返回值:opst:1开始日期时间_"#"_opend：2手术结束日期时间_"#"_anaOpSurgeon：3主刀
/// _"#"_assistantFirstCtcp:4一助_"#"_assistantSecondCtcp：5二助
/// retStr_"#"_opStr：6手术_"#"_bodsDesc：7手术部位_"#"_operloc：8手术室
/// _"#"_oproomdes:9手术间_"#"_opaId
/// w ##class(web.DHCANAdaptor).GetAdmLastOperInfo(236)
ClassMethod GetAdmLastOperInfo(EpisodeID As %String, LanguageId As %String = "") As %String
{
	///
	i LanguageId=""	Set langid=20
	e  set langid=LanguageId
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
	}

	s retStr=""
	q:EpisodeID="" retStr
	s opaId="",OPCategory=""
	q:$d(^DHCANOPArrange(0,"Adm",EpisodeID))<1 "无相关手术记录"
	s opaId=$o(^DHCANOPArrange(0,"Adm",EpisodeID,""),-1) 
	s opaStatus=$P(^DHCANOPArrange(opaId),"^",27)
	;q:opaStatus'="F"
	q:(opaStatus="")||(opaStatus="D")||(opaStatus="C") "未审核撤销或已拒绝"
	s opstdate=$P(^DHCANOPArrange(opaId),"^",14)	//开始日期
	s opsttime=$P(^DHCANOPArrange(opaId),"^",15)
	s opst=""
	i opstdate'="" s opst=##class(websys.Conversions).DateLogicalToHtml(opstdate)_" "_$zt(opsttime,2)
	s openddate=$P(^DHCANOPArrange(opaId),"^",16)	//结束日期
	s opendtime=$P(^DHCANOPArrange(opaId),"^",17)
	s opend=""
	i openddate'="" s opend=##class(websys.Conversions).DateLogicalToHtml(openddate)_" "_$zt(opendtime,2)
	s oproomdes="" ;手术间
	s oproomdr=$P(^DHCANOPArrange(opaId),"^",20)
	i oproomdr'="" s oproomdes=$p($g(^DHCANC("OPRoom",oproomdr)),"^",2)

	s adm=EpisodeID
	s chl=$P($P(^DHCANOPArrange(opaId),"^",2),"||",2)
	s opStr="",anaopBladeType="",OPICDCode="",OPCategory=""
	s subchl=0 f  s subchl=$O(^OR(adm,"ANA",chl,"OP",subchl)) q:(subchl="")  d
		 .s curAnaopBladeTypeId=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",9)
		 .i curAnaopBladeTypeId'="" d
			..s anaopBladeType=$p($g(^ORC("BLDTP",+curAnaopBladeTypeId)),"^",2)
		.s operloc=""
		.s operLocId=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",10)	;手术室
		.i operLocId'="" s operloc=$p(^CTLOC(operLocId),"",2)
		.s opdr=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",6)     ;ANAOP_Type_DR ；手术名称
		.q:opdr=""	;手工填写暂时不考虑
		.i opdr'=""  d
			..q:$d(^ORC("OPER",+opdr))<1
			..s opdesc=$P($g(^ORC("OPER",+opdr)),"^",2)
			..i opdesc'="" s opdesc=##class(User.ORCOperation).GetTranByDesc("OPERDesc",opdesc,langid)
			..;##class(CIS.AN.COM.String).GetTranslationByBDP("User.ORCOperation","OPERDesc",opdesc)
			..;w opdesc
			..;手术分类
			..s OPCategoryId=$p($g(^ORC("OPER",opdr)),"^",7)
			..i OPCategoryId'="" s OPCategory=$p($g(^ORC("CATEG",OPCategoryId)),"^",2)
			..i OPCategory'="" s OPCategory=##class(User.ORCOperationCategory).GetTranByDesc("CATEGDesc",OPCategory,langid)
			..s OPICDCode=$p($g(^ORC("OPER",opdr)),"^",14)	;ICD10
			..i opStr'="" s opStr=opStr_","_opdesc
			..;_"/"_OPCategory_"/"_OPICDCode_"/"_anaopBladeType
			..e  s opStr=opdesc
			..;_"/"_OPCategory_"/"_OPICDCode_"/"_anaopBladeType
			.;ANAOP_Surgeon_DR  ；手术医师
			.s docdr=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",8)      
			.s anaOPSurgeonDR=$g(docdr)
			.s anaOpSurgeon=##class(web.DHCClinicCom).GetNameById(anaOPSurgeonDR)
			.i anaOpSurgeon'="" s anaOpSurgeon=##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",anaOpSurgeon,langid)
			.;切口愈合等级
			.s bodsIdList=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",24) 	 //ypz 070418 	手术部位
		    .s bodsList="",bodsDesc=""
		    .i bodsIdList'="" d
			    ..s bodsIdNum=$l(bodsIdList,"|")
			    ..f j=1:1:bodsIdNum d
				    ...s bodsId=$p(bodsIdList,"|",j)
				    ...q:bodsId=""
				    ...s bodsDesc2=$p($g(^OEC("BODS",+bodsId)),"^",2)
				    ...i bodsDesc2'="" s bodsDesc2=##class(User.OECBodySite).GetTranByDesc("BODSDesc",bodsDesc2,langid)
				    ...;##class(CIS.AN.COM.String).GetTranslationByBDP("CT.AN.OperStatus","Description",StatusDesc)
				    ...i bodsDesc'="" s bodsDesc=bodsDesc_","_bodsDesc2
				    ...e  s bodsDesc=bodsDesc2   
		.s p=0,assistantSecondCtcpId="",assistantFirstCtcpId="",assistantFirstCtcp=""
		.s assistantSecondCtcp=""
		.s as=0 f  s as=$O(^OR(adm,"ANA",chl,"OP",1,"ASS",as)) q:(as="")  d
			..s asdr=$P(^OR(adm,"ANA",chl,"OP",subchl,"ASS",as),"^",1)
			...q:asdr=""
			...s p=p+1
			...i p=1 s assistantFirstCtcpId=$g(asdr)  ;一助
			...i assistantFirstCtcpId'="" s assistantFirstCtcp=##class(web.DHCClinicCom).GetNameById(assistantFirstCtcpId)
			...i assistantFirstCtcp'="" s assistantFirstCtcp=##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",assistantFirstCtcp,langid)
			...i p=2 s assistantSecondCtcpId=$g(asdr) ;二助
			...i assistantSecondCtcpId'="" s assistantSecondCtcp=##class(web.DHCClinicCom).GetNameById(assistantSecondCtcpId)
			...i assistantSecondCtcp'="" s assistantSecondCtcp=##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",assistantSecondCtcp,langid)
		.s retStr=opst_"#"_opend_"#"_anaOpSurgeon_"#"_assistantFirstCtcp_"#"_assistantSecondCtcp
		.s retStr=retStr_"#"_opStr_"#"_bodsDesc_"#"_operloc_"#"_oproomdes_"#"_opaId
	q retStr
}

/// w ##class(web.DHCANAdaptor).CheckValidDayOper(9581)
/// 入参：就诊号，
/// 返回Y^A^数字，存在正式日间申请
/// 返回Y^W^数字，存在拟日间申请
/// 返回N^N^数字，不存在日间手术
/// 返回N^C^数字，存在撤销的拟日间申请
/// 只适合日间
ClassMethod CheckValidDayOper(AdmId) As %String
{
	s ret1="",ret2="",ret=""
	s opaId=$o(^DHCANOPArrange(0,"Adm",AdmId,""),-1)
	i opaId="" s ret1="N",ret2="N"
	e  d
		.s operStat=$P($g(^DHCANOPArrange(opaId)),"^",27)
		.s anaId=$P($g(^DHCANOPArrange(opaId)),"^",2)
		.s anasub=$p(anaId,"||",2)
		.s adm=AdmId
		.s chl=anasub
		.s anaOpSubTmp2="",inum=0,anaOpSubTmp=""
		.f  s anaOpSubTmp2=$o(^OR(adm,"ANA",chl,"OP",anaOpSubTmp2)) q:(anaOpSubTmp2="")!(inum>0)  d
		..s inum=anaOpSubTmp2
		..i inum>0 s anaOpSubTmp=inum
		.s dayOperFlag=$P(^OR(AdmId,"ANA",anasub,"OP",anaOpSubTmp),"^",22)
		.i dayOperFlag'="Y" d
			..s ret1="N",ret2="N"	;不存在日间手术
		.e  d
			..i operStat="C" s ret1="N",ret2="C"
			..e  i operStat="D" s ret1="N",ret2="C"
			..e  i operStat="S" s ret1="Y",ret2="W"	;存在拟日间申请
			..e  s ret1="Y",ret2="A"	;存在正式申请
	s ret=ret1_"^"_ret2_"^"_opaId
	q ret
}

/// w ##class(web.DHCANAdaptor).CheckDayOperAnAudit(827)
/// 入参：就诊号
/// 返回值：是否已做麻醉评估^日间手术是否需要麻醉评估
/// 返回Y：已做麻醉评估，N：未做麻醉评估
/// 只适合日间
ClassMethod CheckDayOperAnAudit(AdmId) As %String
{
	s ret="",canvalue="",isNeedAnAudit=""
	s opaId=$o(^DHCANOPArrange(0,"Adm",AdmId,""),-1)
	i opaId="" s ret="N"
	e  d
		.;这块加是否进行了麻醉评估
		.i (^CIS.AN.OperScheduleD'="" ) d
			..s isNeedAnAudit=..GetIfNeedAnAudit("DaySurgeryANAssessment")
			..s canvalue=..GetOperAnAuditData(opaId,"IsCanDayOper","AN_ANS_018")
			..i canvalue'="" s ret="Y"
			..e  s ret="N"
		.e  d
			..s isNeedAnAudit=$g(^DHCCLSet("AnOp","DayOperNeedAN"))
			..s retCan=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"BDS_IsCanDayOper")
			..i retCan'="" s canvalue=$p(retCan,$c(3),1),ret="Y"
			..e  s ret="N"
	q ret_"^"_isNeedAnAudit_"^"_canvalue
}

ClassMethod GetIfNeedAnAudit(key)
{
	set DataKey=""
	&sql(select DataKey into :DataKey from CF_AN.DataConfig where DataKey=:key)

	q DataKey
}

/// w ##class(web.DHCANAdaptor).CancelDayOper(827)
/// 入参：就诊号，返回1：撤销成功，文字描述：撤销失败
/// 只适合日间
ClassMethod CancelDayOper(AdmId, userId As %String = "") As %String
{
	s opaId=$o(^DHCANOPArrange(0,"Adm",AdmId,""),-1)
	
	q:opaId="" "无相关拟日间申请"
	;如果做了麻醉评估，不允许撤销
	s value=""
	
	i ($d(^CIS.AN.OperScheduleD)>1 )
	{
		s value=..GetOperAnAuditData(opaId,"IsCanDayOper","AN_ANS_018")
		;q:value="Y" "已做麻醉评估不允许撤销,如需撤销请联系开单医生"
		s newOpaId=..GetNewOpaIDByOld(opaId)
    	q:newOpaId="" "0^无相关手术记录"
    	s oeordId=""
    	
    	&sql(select AppOrderItem into :oeordId from CIS_AN.OperSchedule where  ExternalID=:opaId)


		s restr=..CancelOperation(newOpaId,"1",userId)
		i restr="S^" d
		.set cancelret=""
		.;撤销医嘱
		.i oeordId'="" set cancelret=##class(appcom.OEOrdItem).Cancel(oeordId,userId)
		.s $P(^DHCANOPArrange(opaId),"^",27)="C"
		e  q restr
	}
	else
	{
		s retAu=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"BDS_IsCanDayOper")
		i retAu'="" s value=$p(retAu,$c(3),1)
		q:value="Y" "已做麻醉评估不允许撤销"
		s $P(^DHCANOPArrange(opaId),"^",27)="C"
	}
	
	q 1
}

ClassMethod GetNewOpaIDByOld(opaId)
{
		set operDataID=""
	&sql(select RowId into :operDataID from CIS_AN.OperSchedule where  ExternalID=:opaId)

	q operDataID
}

/// w ##class(web.DHCANAdaptor).GetOperAnAuditData(253,"IsCanDayOper")
ClassMethod GetOperAnAuditDataOld(opaId As %String, dataItem As %String) As %String
{
	set operDataID="",operSheetId="",dataValue=""
	&sql(select RowId into :operDataID from CIS_AN.OperSchedule where  ExternalID=:opaId)
	
	&sql(select RowId into :operSheetId from CIS_AN.RecordSheet where  OperSchedule=:operDataID)
	&sql(select DataValue into :dataValue from CIS_AN.OperData where RecordSheet=:operSheetId and DataItem=:dataItem)

	quit dataValue
}

/// w ##class(web.DHCANAdaptor).GetOperAnAuditData(971,"IsCanDayOper","AN_ANS_018")
ClassMethod GetOperAnAuditData(opaId As %String, dataItem As %String, sheetcode As %String = "AN_ANS_018") As %String
{
	set operDataID="",operSheetId="",dataValue="",moduleId=""
	//获取排班id
	&sql(select RowId into :operDataID from CIS_AN.OperSchedule where  ExternalID=:opaId)
	i sheetcode'="" d //获取表单module
		.&sql(select RowId into :moduleId from CT_AN.DataModule where Code=:sheetcode)
		.;b	;1
		.&sql(select RowId into :operSheetId from CIS_AN.RecordSheet where OperSchedule=:operDataID and DataModule=:moduleId)
		.;b	;2
		.&sql(select DataValue into :dataValue from CIS_AN.OperData where RecordSheet=:operSheetId and DataItem=:dataItem)
	e  d
		.;b	;3
		.&sql(select RowId into :operSheetId from CIS_AN.RecordSheet where  OperSchedule=:operDataID)
		.;b	;4
		.&sql(select DataValue into :dataValue from CIS_AN.OperData where RecordSheet=:operSheetId and DataItem=:dataItem)

	quit dataValue
}

ClassMethod CheckIsNeedAuditAudit() As %String
{
	
	q 0
}

/// 
/// 入参：医嘱id，返回：0：撤销申请单成功
/// -1^Mgs：撤销申请单失败,以及撤销失败文字描述
/// 100：不属于申请单医嘱
/// w ##class(web.DHCANAdaptor).CancelOperByOeordId("216||3")
ClassMethod CancelOperByOeordId(OeordId) As %String
{
	q:OeordId="" "-1^医嘱id为空"
	s OerId=$p(OeordId,"||",1)
	s subOerId=$p(OeordId,"||",2)
	s oeordItemDr=$p($g(^OEORD(OerId,"I",subOerId,1)),"^",2)
	s appordDr=$g(^DHCCLSet("AnOp","AppArcimId"))
	//q:oeordItemDr'=appordDr "100"
	s anaId=$p($g(^OEORD(OerId,"I",subOerId,4)),"^",9)
	s AdmId=+anaId
	s oldTmpOpaId=..GetOpaIdByAnaestID(anaId)
	s opaId="",newOpaId=""
	i $d(^CIS.AN.OperScheduleD)&&(^CIS.AN.OperScheduleD'="" )
    {
	  	s newOpaId=..GetNewOpaIdDataByOeord(OeordId)
     	q:newOpaId="" "0^无相关手术记录"
     	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(newOpaId)
     	set StatusCode=""
     	if (operSchedule.Status'="")
			{
				set StatusID=operSchedule.Status.%Id()
				set StatusCode=operSchedule.Status.Code
			}
		q:((StatusCode'="Application")&&(StatusCode'="Audit")) "-1^非申请状态手术不可撤销医嘱记录"
    	s restr=..CancelOperation(newOpaId,"1","")
    	i restr="S^" s $P(^DHCANOPArrange(oldTmpOpaId),"^",27)="C"
    }
   else{
    s opaId="",newOpaId=""	
     f  s opaId=$o(^DHCANOPArrange(0,"Adm",AdmId,opaId)) q:opaId=""  d
		.q:opaId=""
		.s newanaId=$p(^DHCANOPArrange(opaId),"^",2)
		.q:anaId'=newanaId
		.s newOpaId=opaId
	 q:newOpaId="" "0^无相关手术记录"
	 s operStat=$P(^DHCANOPArrange(newOpaId),"^",27)
	 q:(operStat'="A")&(operStat'="") "-1^该手术状态不允许撤销手术"
	 s $P(^DHCANOPArrange(newOpaId),"^",27)="C"
   }
    
	q 0
}

ClassMethod GetNewOpaIdDataByOeord(oeordId As %String) As %String
{
	set operDataID="",operSheetId="",dataValue=""
	&sql(select RowId into :operDataID from CIS_AN.OperSchedule where  AppOrderItem=:oeordId)
	
	quit operDataID
}

ClassMethod CancelOperation(opsId As %String, reason As %String, cancelUserId As %String) As %String
{
	set $zt="Error"
	tstart
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set cancelStatusID=##class(CIS.AN.BL.OperStatus).GetStatusIDByCode("Cancel")	
	set operSchedule.Status=##class(CT.AN.OperStatus).%OpenId(cancelStatusID)
	set sc=operSchedule.%Save()
	if ($System.Status.IsError(sc))
	{
		trollback
		quit "E^"_$System.Status.GetErrorText(sc)	
	}
	set operArrange=##class(CIS.AN.OperArrange).%New()
	set operArrange.OperSchedule=operSchedule
	set operArrange.ReleaseUser=cancelUserId
	set operArrange.OperStatus=operSchedule.Status
	set operArrange.Note=reason
	set sc=operArrange.%Save()
	if ($System.Status.IsError(sc))
	{
		trollback
		quit "E^"_$System.Status.GetErrorText(sc)	
	}
	
	//set saveResult=##class(CIS.AN.BL.OEOrder).CancelOEOrder(operSchedule.AppOrderItem,cancelUserId)
	//if ($p(saveResult,"^",1)'="S")
	//{
	//	trollback
	//	quit saveResult		
	//}
	tcommit
	quit "S^"
Error
	trollback
	quit "E^"_$ze
}

ClassMethod GetOpaIdByAnaestID(anaId)
{
	q:anaId="" ""
	s AdmId=$p(anaId,"||",1)
	s opaId="",newTmpOpaId=""
	f  s opaId=$o(^DHCANOPArrange(0,"Adm",AdmId,opaId)) q:opaId=""  d
		.q:opaId=""
		.q:$d(^DHCANOPArrange(opaId))<1
		.s newanaId=$p(^DHCANOPArrange(opaId),"^",2)
		.q:newanaId'=anaId
		.s newTmpOpaId=opaId
	q newTmpOpaId
}

/// w ##class(web.DHCANAdaptor).SaveRecord(date)
/// 给医生资质推送前一天的手术记录，日期默认为空，推送前一天数据，不为空可执行推送入参的日期的手术
ClassMethod SaveRecord(date As %String = "") As %String
{
	i date="" s date=+$h-1
	e  s date=##Class(web.DHCANOPCom).ConvertToDateH(date)
	//s date=64397
	s opaId="",data="",ret=""
	f  s opaId=$o(^DHCANOPArrange(0,"SDate",date,opaId)) q:opaId=""  d
	.s status=$p(^DHCANOPArrange(opaId),"^",27)
	.q:((status'="F")&&(status'="L"))
	.s adm=$p(^DHCANOPArrange(opaId),"^",1)
	.s chl=$p($p(^DHCANOPArrange(opaId),"^",2),"||",2)
	.s papmiId=$p($g(^PAADM(adm)),"^",1)
	.s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	.s opstdate=$P(^DHCANOPArrange(opaId),"^",14)
	.i opstdate'="" s opstdate=$zd(opstdate,3)
	.s opsttime=$P(^DHCANOPArrange(opaId),"^",15)
	.i opsttime'="" s opsttime=$zt(opsttime)
	.s opdrStr="",opdes="",doc=""
	.s subchl=0 f  s subchl=$O(^OR(adm,"ANA",chl,"OP",subchl)) q:(subchl="")  d
	..s opdr=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",6)       		;ANAOP_Type_DR     ；手术名称
	..i opdr'=""  d 
		...i opdrStr'="" s opdrStr=opdrStr_";"_opdr
		...i opdrStr="" s opdrStr=opdr
		...i $P($g(^ORC("OPER",+opdr)),"^",2)'="" d     
		....i opdes'="" s opdes=opdes_";"     
		....s opdes=opdes_$P($g(^ORC("OPER",+opdr)),"^",2)     
	..e  d
		...i $g(^OR(adm,"ANA",chl,"OP",subchl,"REM",2))'="" d
		....i opdes'="" s opdes=opdes_";"
		....s opdes=opdes_$G(^OR(adm,"ANA",chl,"OP",subchl,"REM",2))
	..s docdr=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",8)      		;ANAOP_Surgeon_DR   手术医师
	..i docdr'="" d
	...s docId=$o(^SSU("SSUSR",0,"CTPCP",docdr,""))
	...i docId'="" s doc=$P(^SSU("SSUSR",docId),"^",1)
	
	.i data'="" s data=data_"!"_doc_"^"_patName_"^"_adm_"^"_opdes_"^"_opstdate_" "_opsttime_"^"_"OPS"_"^^"_opdrStr
	.i data="" s data=doc_"^"_patName_"^"_adm_"^"_opdes_"^"_opstdate_" "_opsttime_"^"_"OPS"_"^^"_opdrStr
	s CommonService=##class(CommonService.CommonServiceHttpPort).%New()
	s ret=CommonService.saveRecord(data)
	 
	q ret
}

/// w ##class(web.DHCANAdaptor).GetOpInfoByAdmForDrugDept(176)
/// 入参：就诊号
/// 输出：就诊号，手术排班表id,麻醉子表,手术名称，手术id,切口描述,切口id
/// 多条记录中间用#分割，数据之间用^分割
ClassMethod GetOpInfoByAdmForDrugDept(adm)
{
	s opaId="",retStr=""
	f  s opaId=$o(^DHCANOPArrange(0,"Adm",adm,opaId)) q:opaId=""  d
		.q:'$d(^DHCANOPArrange(opaId))
		.s anSub=$p($p(^DHCANOPArrange(opaId),"^",2),"||",2)
		.s opSub=0 f  s opSub=$O(^OR(adm,"ANA",anSub,"OP",opSub)) q:(opSub="")  d
			..s opdes=""
			..s opdr=$P(^OR(adm,"ANA",anSub,"OP",opSub),"^",6)       		;ANAOP_Type_DR     ；手术名称
			..q:opdr=""
			..i +opdr'=0  d 
				...s opdes=$P($g(^ORC("OPER",+opdr)),"^",2)     
			..s bldType=""
			..s bldTpId=$p(^OR(adm,"ANA",anSub,"OP",opSub),"^",9)			;ANAOP_Blade_DR		手术刀口类型
			..i +bldTpId'=0 s bldType=$p($g(^ORC("BLDTP",bldTpId)),"^",2)	;ORC_BladeType	
			..s operAnaId=adm_"||"_anSub_"||"_opSub
			..i retStr'="" s retStr=retStr_"#"_adm_"^"_opaId_"^"_operAnaId_"^"_opdes_"^"_opdr_"^"_bldType_"^"_bldTpId
			..e  s retStr=adm_"^"_opaId_"^"_operAnaId_"^"_opdes_"^"_opdr_"^"_bldType_"^"_bldTpId
	q retStr
}

/// 20190812+dyl+根据就诊号获取患者的icd手术操作码
/// 入参：就诊号
/// 输出:手术1icd|手术1名称,手术2icd|手术2名称,...
/// w ##class(web.DHCANAdaptor).GetOperCodeByAdmId(76)
ClassMethod GetOperCodeByAdmId(adm)
{
	s opaId="",retStr=""
	f  s opaId=$o(^DHCANOPArrange(0,"Adm",adm,opaId)) q:opaId=""  d
		.q:'$d(^DHCANOPArrange(opaId))
		.s opaStatus=$P(^DHCANOPArrange(opaId),"^",27)
		.q:(opaStatus="C")!(opaStatus="D")!(opaStatus="A")
		.s anSub=$p($p(^DHCANOPArrange(opaId),"^",2),"||",2)
		.s opSub=0 f  s opSub=$O(^OR(adm,"ANA",anSub,"OP",opSub)) q:(opSub="")  d
			..s opdes=""
			..s opdr=$P(^OR(adm,"ANA",anSub,"OP",opSub),"^",6)       		;ANAOP_Type_DR     ；手术名称
			..q:opdr=""
			..i +opdr'=0  d 
				...s opdes=$P($g(^ORC("OPER",+opdr)),"^",2)
				...s opicd9code=$P($g(^ORC("OPER",+opdr)),"^",14) 
			..i retStr'="" s retStr=retStr_","_opicd9code_"|"_opdes
			..e  s retStr=opicd9code_"|"_opdes
	q retStr
}

/// date:20190802+for电子病历5
/// creator：dmr
/// d ##class(%ResultSet).RunQuery("web.DHCANAdaptor","GetOperInfoEMR5","2019-04-01","2019-07-01")
Query GetOperInfoEMR5(stdate, enddate) As %Query(ROWSPEC = "anMethId,anMethDesc,anNum") [ SqlProc ]
{
}

ClassMethod GetOperInfoEMR5Execute(ByRef qHandle As %Binary, stdate, enddate) As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    i (stdate="")!(enddate="") s sdate=+$H,edate=+$H
	e  s sdate=##Class(web.DHCANOPCom).ConvertToDateH(stdate),edate=##Class(web.DHCANOPCom).ConvertToDateH(enddate)
 	k AnMethodList
 	f date=sdate:1:edate
    {   
		s opaId=""
		f  s opaId=$O(^DHCANOPArrange(0,"SDate",date,opaId)) q:opaId=""  d
			.q:$d(^DHCANOPArrange(opaId))<1
			.s adm=$P(^DHCANOPArrange(opaId),"^",1)
			.q:adm=""
			.s opaStatus=$P(^DHCANOPArrange(opaId),"^",27)
			.;q:(opaStatus'="L")&&(opaStatus'="F")
			.s chl=$p($P(^DHCANOPArrange(opaId),"^",2),"||",2)
			.s anmethod=""
			.s anmthdr=$P(^OR(adm,"ANA",chl),"^",5)
			.s anmthdr=$tr(anmthdr,"|",",")
			.s anmetId="",anmetDesc=""
			.s anmetNum=$l(anmthdr,",")
			.i anmthdr'="" d 
				..s anmetId=$p(+anmthdr,",",1)
				..q:+anmetId<1
				..q:$d(^ORC("ANMET",anmetId))<1
				..s anmetDesc=$p($g(^ORC("ANMET",anmetId)),"^",2)
				..s AnMethodList(anmetId,opaId)=anmetDesc
			.e  s AnMethodList("无",opaId)="无"

    }
    s opanDr="",annum=0
    f  s opanDr=$o(AnMethodList(opanDr)) q:opanDr=""  d
	    .s sannum=0
	    .;b
	    .s tmpmetId=""
	    .f  s tmpmetId=$o(AnMethodList(opanDr,tmpmetId)) q:tmpmetId=""  d
	    	..s anMet=$g(AnMethodList(opanDr,tmpmetId))
	    	..s sannum=sannum+1
	    	..;s annum=annum+1
	    .s annum=sannum
	    .d outputemr5
    	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
   
outputemr5
 set Data=$lb(opanDr,anMet,annum)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod GetOperInfoEMR5Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOperInfoEMR5Execute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
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

ClassMethod GetOperInfoEMR5Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOperInfoEMR5Execute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

// 根据手术编码获取手术类别

ClassMethod GetOperCatByCode(code)
{
	q:code="" "code is null"
	s operId=$o(^ORC("OPER",0,"Code",$$ALPHAUP^SSUTIL4(code),""),-1)
	q:operId "can not find record"
	s opcat=""
	s opcat=$p($g(^ORC("OPER",operId,"DHC")),"^",11)
	i opcat="N" s opcat="手术" 
	i opcat="T" s opcat="治疗性操作" 
	i opcat="D" s opcat="诊断性操作" 
	i opcat="I" s opcat="介入治疗"
	q opcat
}

/// w ##class(web.DHCANAdaptor).GetMaterialByOpaId(199)
ClassMethod GetMaterialByOpaId(opaId) As %String
{
	q:opaId="" "手术排班表Id为空"
	;20190919+dyl
	s material=""
	s retStrT=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"OPA.OperMaterialMem")
	i retStrT'="" d
		.s material=$p(retStrT,$c(3),1)
	q material
}

/// w ##class(web.DHCANAdaptor).CheckIfCurentDateOper(831,"")
ClassMethod CheckIfCurentDateOper(EpisodeId, date As %String = "") As %String
{
	i date="" s date=+$h
	s flag=0
	if (EpisodeId'=""){   
		s opaId=""
		f  s opaId=$O(^DHCANOPArrange(0,"Adm",EpisodeId,opaId)) q:opaId=""  d
		.s opaStatus=$P(^DHCANOPArrange(opaId),"^",27)
		.q:$d(^DHCANOPArrange(opaId))<1
		.q:opaStatus="C"
		.q:opaStatus="D"
		.i $d(^DHCANOPArrange(0,"SDate",date,opaId))>0 d
		..s flag=1
	}  
	
	q flag
}

/// 入参：医嘱项id
/// 返回值：0：是手术医嘱，其他则返回具体信息
ClassMethod CheckARCIMIsOper(ArcimDr)
{
	q:ArcimDr="" "-1^医嘱项id为空"
	;s OerId=$p(OeordId,"||",1)
	;s subOerId=$p(OeordId,"||",2)
	;s oeordItemDr=$p($g(^OEORD(OerId,"I",subOerId,1)),"^",2)
	s oeordItemDr=ArcimDr
	s appordDr=$g(^DHCCLSet("AnOp","AppArcimId"))
	set newAppDr="",dataCode="AppArcim"
	&sql(select DataValue into :newAppDr from CF_AN.DataConfig where DataKey=:dataCode)
	
	i appordDr="" d
	.i newAppDr'="" d
	..s appordDr=newAppDr
	e  d
	.i newAppDr'=appordDr d
	..s appordDr=newAppDr
	q:oeordItemDr'=appordDr "100^非手术医嘱"
	q 0
}

ClassMethod GetDiagInfoByAdmId(mradmDr)
{
	q:mradmDr="" ""
	s rset=##class(%ResultSet).%New("DHCDoc.Interface.Inside.Service:DiagnosList")
	s ret=""
	do rset.Execute(mradmDr,"","")
	while (rset.Next()) {
		i ret'=""  s ret=ret_"^"_rset.GetData(1)_"&&"_rset.GetData(3)_"&&"_rset.GetData(4)_"&&"_rset.GetData(12)_"&&"_rset.GetData(6)_"&&"_rset.GetData(11)
		e  s ret=rset.GetData(1)_"&&"_rset.GetData(3)_"&&"_rset.GetData(4)_"&&"_rset.GetData(12)_"&&"_rset.GetData(6)_"&&"_rset.GetData(11)
	}
	d rset.Close()
	q ret
}

ClassMethod GetSterilityPackage(xmlContent)
{
    set xml=##class(%GlobalCharacterStream).%New()
    do xml.Rewind()
    do xml.Write(xmlContent)
    
    set reader=##class(%XML.Reader).%New()
    
    do reader.OpenStream(xml)
    do reader.Correlate()
    while(reader.Next(.object,.sc))
    {
    }
}

/// Creator：  YuanLin
/// CreatDate：2021-06-11
/// Input：    opaId,项目Code
/// Output:    ASAClass,NNISRateValue,OperClassDesc
/// Function:  获取扩展信息(手术ASA评分、NNIS分级、手术级别(可能有多个,逗号分隔)、麻醉单失血量、输血量)
/// d ##class(web.DHCANAdaptor).GetExtendValueByOpaId("347","NNISRate")
ClassMethod GetExtendValueByOpaId(opaId As %String, code As %String) As %String
{
	q:opaId="" ""
	q:code="" ""
	s ExtendValue="",opsId="",DataModuldId="",RecordSheetId="",OperDataId="",AnaesthesiaId=""
	s DataCategoryId="",dataCategoryId="",ParaItemId="",AnaDataId=""
	s opsId=$o(^CIS.AN.OperScheduleI("Ext"," "_opaId,opsId))
	f  s DataCategoryId=$o(^CT.AN.DataCategoryD(DataCategoryId)) q:DataCategoryId=""  d
	.s DataCategoryDesc=$lg(^CT.AN.DataCategoryD(DataCategoryId),2)
	.s MainCategory=$lg(^CT.AN.DataCategoryD(DataCategoryId),3)
	.q:MainCategory=""
	.q:DataCategoryDesc'="血浆制品"
	.s dataCategoryId=DataCategoryId
	
    i code="ASAClass" d
    .s AnaesthesiaId=$o(^CIS.AN.AnaesthesiaI("IOPS",opsId,AnaesthesiaId))
    .s ExtendValue=$lg(^CIS.AN.AnaesthesiaD(AnaesthesiaId),19)
    i code="OperClass" d
	.s operListObj=##class(CIS.AN.BL.OperationList).GetOperListObject(opsId)
	.s OperClass=operListObj.OperClass
	.s ExtendValue=operListObj.OperClassDesc
	i code="NNISRate" d
	.s url="CIS.AN.OperRiskAssessment.csp"
	.f  s DataModuldId=$o(^CT.AN.DataModuleD(DataModuldId)) q:DataModuldId=""  d
	..s URL=$lg(^CT.AN.DataModuleD(DataModuldId),4)
	..q:URL'=url
	..f  s RecordSheetId=$o(^CIS.AN.RecordSheetI("IOPS",opsId,RecordSheetId)) q:RecordSheetId=""  d
	...s dataModuldId=$lg(^CIS.AN.RecordSheetD(RecordSheetId),2)
	...q:(dataModuldId'=DataModuldId)
	...f  s OperDataId=$o(^CIS.AN.OperDataI("ISheet",RecordSheetId,OperDataId)) q:OperDataId=""  d
	....s OperCode=$lg(^CIS.AN.OperDataD(OperDataId),2)
	....q:(OperCode'=code)
	....s ExtendValue=$lg(^CIS.AN.OperDataD(OperDataId),3)
	i code="BloodVol" d
	.s url="CIS.AN.AnaestRecord.csp"
	.f  s DataModuldId=$o(^CT.AN.DataModuleD(DataModuldId)) q:DataModuldId=""  d
	..s URL=$lg(^CT.AN.DataModuleD(DataModuldId),4)
	..q:URL'=url
	..f  s RecordSheetId=$o(^CIS.AN.RecordSheetI("IOPS",opsId,RecordSheetId)) q:RecordSheetId=""  d
	...s dataModuldId=$lg(^CIS.AN.RecordSheetD(RecordSheetId),2)
	...q:(dataModuldId'=DataModuldId)
	...f  s ParaItemId=$o(^CIS.AN.ParaItemI("ISheet",RecordSheetId,ParaItemId)) q:ParaItemId=""  d
	....s DataCategory=$lg(^CIS.AN.ParaItemD(ParaItemId),5)
	....i (DataCategory=dataCategoryId) d
	.....f  s AnaDataId=$o(^CIS.AN.AnaDataI("IParaItem",ParaItemId,AnaDataId)) q:AnaDataId=""  d
	......s DrugDataId=""
	......s EditFlag=$lg(^CIS.AN.AnaDataD(AnaDataId),7)
	......q:EditFlag'="N"
	......s DrugDataId=$o(^CIS.AN.DrugDataI("IAnaData",AnaDataId,DrugDataId))
	......s Blood=$lg(^CIS.AN.DrugDataD(DrugDataId),2)
	......s ExtendValue=ExtendValue+Blood
	...s:ExtendValue'="" ExtendValue=ExtendValue_"ml"
	i code="BloodLoss" d
	.s url="CIS.AN.AnaestRecord.csp"
	.f  s DataModuldId=$o(^CT.AN.DataModuleD(DataModuldId)) q:DataModuldId=""  d
	..s URL=$lg(^CT.AN.DataModuleD(DataModuldId),4)
	..q:URL'=url
	..f  s RecordSheetId=$o(^CIS.AN.RecordSheetI("IOPS",opsId,RecordSheetId)) q:RecordSheetId=""  d
	...s dataModuldId=$lg(^CIS.AN.RecordSheetD(RecordSheetId),2)
	...q:(dataModuldId'=DataModuldId)
	...f  s ParaItemId=$o(^CIS.AN.ParaItemI("ISheet",RecordSheetId,ParaItemId)) q:ParaItemId=""  d
	....s ParaDesc=$lg(^CIS.AN.ParaItemD(ParaItemId),4)
	....q:ParaDesc'="失血量"
	....f  s AnaDataId=$o(^CIS.AN.AnaDataI("IParaItem",ParaItemId,AnaDataId)) q:AnaDataId=""  d
	.....s EditFlag=$lg(^CIS.AN.AnaDataD(AnaDataId),7)
	.....q:EditFlag'="N"
	.....s ExtendValue=$lg(^CIS.AN.AnaDataD(AnaDataId),6)
	....s:ExtendValue'="" ExtendValue=ExtendValue_"ml"
	q ExtendValue
}

/// w ##class(web.DHCANAdaptor).GetDaySurgeryInfoByAdmId(2899)
/// 【日间手术】为医生站提供获取日间手术信息接口，
/// 入参：就诊号
/// 出参:本次就诊的日间手术日期、手术状态、日间手术信息
/// 		、麻醉术前评估状态、申请人 
ClassMethod GetDaySurgeryInfoByAdmId(AdmId)
{
	s ret=""
	q:AdmId="" "EpisodeId is null"
	s scheduleId=""
	f  s scheduleId=$o(^CIS.AN.OperScheduleI("Adm"," "_AdmId,scheduleId)) q:scheduleId=""  d
		.q:$d(^CIS.AN.OperScheduleD(scheduleId))<1
		.s operSchedule=##class(CIS.AN.OperSchedule).%OpenId(scheduleId)
		.s tmpDaySurgery=operSchedule.DaySurgery
		.q:tmpDaySurgery'="Y"
		.s extendOpaId=operSchedule.ExternalID
		.s isAnAudit=..GetOperAnAuditData(extendOpaId,"IsCanDayOper","AN_ANS_018")
		.s AppCareProvDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTCareProv","CTPCPDesc",operSchedule.AppCareProvID)
    	.s StatusDesc=operSchedule.Status.Description
		.s OperExecDeptID=operSchedule.OperExecDeptID  //日间预住院科室
		.s OperExecDept=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",OperExecDeptID)
		.s OperDate=##class(CIS.AN.COM.DateTime).ConvertToDate(operSchedule.OperDate,"")
		.s operlistId="",curOperInfo=""
		.f  s operlistId=$o(^CIS.AN.OperListI("IOPS",scheduleId,operlistId)) q:operlistId=""  d
			..s listObj=##class(CIS.AN.OperList).%OpenId(operlistId)
			..s operId=listObj.Operation
			..s operdesc=##class(CIS.AN.COM.String).GetDescByID("User.ORCOperation","OPERDesc",operId)
			..s surgeonId=listObj.Surgeon
			..s surgeonDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTCareProv","CTPCPDesc",surgeonId)
			..s surgeonLocId=listObj.SurgeonDeptID
			..s surgeonLoc=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",surgeonLocId)
			..d listObj.%Close()
			..i curOperInfo'="" set curOperInfo=curOperInfo_";"_operdesc_","_surgeonDesc_","_surgeonLoc
			..e  s curOperInfo=operdesc_","_surgeonDesc_","_surgeonLoc
		.i ret'="" s ret=ret_"|"_OperDate_"^"_StatusDesc_"^"_curOperInfo_"^"_isAnAudit_"^"_AppCareProvDesc
		.e  s ret=OperDate_"^"_StatusDesc_"^"_curOperInfo_"^"_isAnAudit_"^"_AppCareProvDesc
	q ret
}

/// w ##class(web.DHCANAdaptor).GetEventNew(156,"入手术间")
ClassMethod GetEventNew(opsId, EventDesc)
{
	s ret=""
	//&sql(select DataValue into :newAppDr from CF_AN.DataConfig where DataKey=:dataCode)
	s retUserId=""
	s retDate=+$h
	s retTime=$p($h,",",2)
	&sql(SELECT CreateUserID,StartDate,StartTime into :retUserId,:retDate,:retTime FROM cis_an.anadata WHERE ParaItem->RecordSheet->OperSchedule=:opsId and DataItem->Description=:EventDesc)
	s ret=retUserId_"^"_..ConvertToDateTime(retDate,retTime)
	q ret
}

ClassMethod GetOperDataNew(opsId, Code)
{
	s ret=""
	//&sql(select DataValue into :newAppDr from CF_AN.DataConfig where DataKey=:dataCode)
	//PreOutTransDT
	s retUserId=""
	s retDate=""
	s retTime=$p($h,",",2)
	s retDateStr=""
	//cis_an.operdata WHERE RecordSheet->OperSchedule=650
	&sql(SELECT UpdateUserID,DataValue into :retUserId,:retDateStr FROM cis_an.operdata WHERE RecordSheet->OperSchedule=:opsId and DataItem=:Code)
	i retDateStr'="" d
	.set date1=$p($g(retDateStr)," ",1)
	.s dateH=##class(CIS.AN.COM.DateTime).ConvertToDateH(date1)
	.;set retDate1=..ConvertToDateCircle(dateH)
	.b
	.set time1=$p($g(retDateStr)," ",2)
	.set timH=##class(CIS.AN.COM.DateTime).ConvertToTimeH(time1)
	.s retDate=..ConvertToDateTime(dateH,timH)
	
	s ret=retUserId_"^"_retDate
	q ret
}

/// w ##class(web.DHCANAdaptor).UpdateOperCircle(650,"","1")
ClassMethod UpdateOperCircle(opsId As %String, userId As %String = "", Status As %String) As %String
{
	s jsonStr=..CreateOperCircleJson(opsId,userId,Status)
	q:jsonStr="" ""
	set stream=##class(%GlobalCharacterStream).%New()
		        d stream.Write("["_jsonStr_"]")
	s EnsRet=##class(web.DHCENS.EnsHISService).DHCHisInterface("UpdateSystemStatus",stream)
	q EnsRet
}

ClassMethod ConvertToDateCircle(dateVal As %String, defaultStr As %String = "$H") As %String [ SqlProc ]
{
    q:((+dateVal=0)!(dateVal<0)!(dateVal>2980013))&(defaultStr="") ""
    q:(+dateVal=0)!(dateVal<0)!(dateVal>2980013) $zd($h,3)
	
	set dateValue=$zd(dateVal,3)
    q dateValue
}

ClassMethod ConvertToTimeCircle(dateVal As %String, defaultStr As %String = "$H") As %String [ SqlProc ]
{
    q:(+dateVal=0) $zt(dateVal)
    q:((+dateVal=0)!(dateVal>86399)!(dateVal<0))&(defaultStr="") ""
    q:(+dateVal=0)!(dateVal>86399)!(dateVal<0) $zt($p($h,",",2))
    q $zt(dateVal)
}

ClassMethod ConvertToDateTime(dateVal As %String, timeVal As %String, defaultStr As %String = "$H") As %String [ SqlProc ]
{
    quit:(+dateVal<=0)!(timeVal="") ""
    set dateStr=..ConvertToDateCircle(dateVal,defaultStr)
    set timeStr=..ConvertToTimeCircle(timeVal, defaultStr)
    set result=dateStr
    if (timeStr'="")
    {
        if (result'="")
        {
            set result=result_" "   
        }   
        set result=result_timeStr
    }
    q result
}

/// w ##class(web.DHCANAdaptor).CreateOperCircleJson(156,"","9")
ClassMethod CreateOperCircleJson(opsId As %String, userId As %String = "", Status As %String)
{
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set anaestId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
	set anaesthesia=##class(CIS.AN.Anaesthesia).%OpenId(anaestId)
    set UserID=""
    
	set ops=##class(%DynamicObject).%New()
	set opaId=operSchedule.ExternalID
	set ops.ExamID=opsId
	set ops.Position=""
	set ops.OEOrdItemID=operSchedule.AppOrderItem	;医嘱id
	if ops.OEOrdItemID="" set ops.OEOrdItemID=opsId	
	set ret=..GetEventNew(opsId,"麻醉开始")
	i ret'="" set AnUserID=$p(ret,"^",1)
	set dateTime=""
	i Status=1 d
	.set statCode="CISANAP"	;日间手术申请
	.i userId="" set userId=operSchedule.AppUserID
	.s UserID=userId
	.s dateTime=..ConvertToDateTime(operSchedule.AppDate,operSchedule.AppTime)
	.set ops.Notes=""
	i Status=2 d
	.set statCode="CISANCAP"	;取消日间手术申请
	.i userId="" set userId=operSchedule.AppUserID
	.s UserID=userId
	.s dateTime=..ConvertToDateTime($h,$p($h,",",2))
	.set ops.Notes=""
	i Status=3 d
	.set statCode="CISANAE"	;麻醉评估
	.s UserID=userId
	.s dateTime=..ConvertToDateTime($h,$p($h,",",2))
	.set ops.Notes=""
	i Status=4 d
	.set statCode="CISANCM"	;日间确认
	.s UserID=userId
	.s dateTime=..ConvertToDateTime($h,$p($h,",",2))
	.set ops.Notes=""
	i Status=5 d
	.set statCode="CISANA"	;手术排班
	.s UserID=userId
	.s dateTime=..ConvertToDateTime($h,$p($h,",",2))
	.set ops.Notes=""
	i Status=6 d
	.set statCode="CISANCA"	;取消手术排班
	.s UserID=userId
	.s dateTime=..ConvertToDateTime($h,$p($h,",",2))
	.set ops.Notes=""
	i Status=7 d
	.;set statCode="CISANWO"	;出病区
	.s UserID=userId
	.;set ret=..GetOperDataNew(opsId,"PreANTransDT")
	.;i ret'="" set UserID=$p(ret,"^",1),dateTime=$p(ret,"^",2)
	.set ops.Notes=""
	i Status=8 d
	.set statCode="CISANAI"	;入手术室
	.;set ret=..GetOperDataNew(opsId,"PreANTransDT")
	.;i ret'="" set UserID=$p(ret,"^",1),dateTime=$p(ret,"^",2)
	.;麻醉监护中没有入室离室，所以从术后登记取 YL 20230511
	.&sql(select TheatreInDT into :dateTime from CIS_AN.Anaesthesia WHERE OperSchedule=:opsId )	
	.set UserID=userId
	.set ops.Notes=""
	i Status=9 d
	.set statCode="CISANRI"	;入手术间
	.set ret=..GetEventNew(opsId,"入手术间")
	.i ret'="" set UserID=$p(ret,"^",1),dateTime=$p(ret,"^",2)
	.set ops.Notes=""
	i Status=10 d
	.set statCode="CISANANS"	;麻醉开始
	.set ret=..GetEventNew(opsId,"麻醉开始")
	.i ret'="" set UserID=$p(ret,"^",1),dateTime=$p(ret,"^",2)
	.set ops.Notes=""
	i Status=11 d
	.set statCode="CISANOPS"	;手术开始
	.set ret=..GetEventNew(opsId,"手术开始")
	.i ret'="" set UserID=$p(ret,"^",1),dateTime=$p(ret,"^",2)
	.set ops.Notes=""
	i Status=12 d
	.set statCode="CISANOPF"	;手术结束
	.set ret=..GetEventNew(opsId,"手术结束")
	.i ret'="" set UserID=$p(ret,"^",1),dateTime=$p(ret,"^",2)
	.set ops.Notes=""
	i Status=13 d
	.set statCode="CISANANF"	;麻醉结束
	.set ret=..GetEventNew(opsId,"麻醉结束")
	.i ret'="" set UserID=$p(ret,"^",1),dateTime=$p(ret,"^",2)
	.set ops.Notes=""
	i Status=14 d
	.set statCode="CISANRO"	;出手术间
	.set ret=..GetEventNew(opsId,"离手术间")
	.i ret'="" set UserID=$p(ret,"^",1),dateTime=$p(ret,"^",2)
	.set ops.Notes=""
	i Status=15 d
	.set statCode="CISANPO"	;出PACU
	.set ret=..GetEventNew(opsId,"出恢复室")
	.i ret'="" set UserID=$p(ret,"^",1),dateTime=$p(ret,"^",2)
	.set ops.Notes=""
	i Status=16 d
	.set statCode="CISANPI"	;入PACU
	.set ret=..GetEventNew(opsId,"入恢复室")
	.i ret'="" set UserID=$p(ret,"^",1),dateTime=$p(ret,"^",2)
	.set ops.Notes=""
	i Status=17 d
	.set statCode="CISANAO"	;出手术室
	.;set ret=..GetOperDataNew(opsId,"PreANTransDT")
	.;i ret'="" set UserID=$p(ret,"^",1),dateTime=$p(ret,"^",2)
	.;麻醉监护中没有入室离室，所以从术后登记取
	.&sql(select TheatreOutDT into :dateTime from CIS_AN.Anaesthesia WHERE OperSchedule=:opsId )	
	.set UserID=userId
	.set ops.Notes=""
	i Status=18 d
	.;set statCode="CISANWI"	;入病区
	.;set dateTime=anaesthesia.AreaInDT
	.s UserID=userId
	.set ops.Notes=""
	i Status=19 d
	.set statCode="CISANDA"	;出院评估
	.s UserID=userId
	.s dateTime=..ConvertToDateTime($h,$p($h,",",2),"3")
	.set ops.Notes=""
	.s UserID=userId
	i Status=20 d
		.set statCode="CISANFU"	;随访
		.s dateTime=..ConvertToDateTime($h,$p($h,",",2))
		.s UserID=userId
		.set ops.Notes=""
	i Status=21 d
		.set statCode="CISANAR"	;麻醉安排
		.s UserID=userId
		.s dateTime=..ConvertToDateTime($h,$p($h,",",2))
		.set ops.Notes=""
	i Status=22 d
		.set statCode="CISANCAR"	;取消麻醉安排
		.s UserID=userId
		.s dateTime=..ConvertToDateTime($h,$p($h,",",2))
		.set ops.Notes=""
	q:UserID="" ""
	set ops.UpDateTime=dateTime
	s ops.Status=statCode
	s userName=""
	i UserID'="" s userName=$p(^SSU("SSUSR",UserID),"^",2)
	set ops.UserID=UserID	;用户
	set ops.UserName=userName	;名称
	set ops.SourceSystem="AN"
	quit ops.%ToJSON()
}

/// 入参就诊号，返回日间手术排班新表id
/// w ##class(web.DHCANAdaptor).GetDaySurgeryIdByAdmId(197)
ClassMethod GetDaySurgeryIdByAdmId(AdmId) As %String
{
	s ret=""
	q:AdmId="" "EpisodeId is null"
	s scheduleId=""
	f  s scheduleId=$o(^CIS.AN.OperScheduleI("Adm"," "_AdmId,scheduleId)) q:scheduleId=""  d
		.q:$d(^CIS.AN.OperScheduleD(scheduleId))<1
		.s operSchedule=##class(CIS.AN.OperSchedule).%OpenId(scheduleId)
		.s tmpDaySurgery=operSchedule.DaySurgery
		.q:tmpDaySurgery'="Y"
		.s StatusCode=operSchedule.Status.Code
		.q:(StatusCode="Cancel")!(StatusCode="Decline")
    	.s StatusDesc=operSchedule.Status.Description
		.s OperExecDeptID=operSchedule.OperExecDeptID  //日间预住院科室
		.s OperDate=##class(CIS.AN.COM.DateTime).ConvertToDate(operSchedule.OperDate,"")
		.s ret=scheduleId
	q ret
}

/// 入参手术排班新表id，预约日期
/// 返回0 正常
/// w ##class(web.DHCANAdaptor).UpdateOperDate(184,"2021-12-08")
ClassMethod UpdateOperDate(opsId, opDate) As %String
{
	s newDate=##class(CIS.AN.COM.DateTime).ConvertToDateH(opDate)
	q:$d(^CIS.AN.OperScheduleD(opsId))<1 "WrongId"
	s operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	s operSchedule.OperDate=newDate
	s extendId=operSchedule.ExternalID
	s opArrange=##class(User.DHCANOPArrange).%OpenId(extendId)
	s opArrange.OPAStartDate=newDate
	set saveStatus1=opArrange.%Save()
	q:(+saveStatus1=0) "arrange数据保存失败!"
	set saveStatus2=operSchedule.%Save()
	q:(+saveStatus1=0) "schedule数据保存失败!"
	d opArrange.%Close()
	d operSchedule.%Close()
	q 0
}

/// 根据就诊号判断日间实手术是否进行日间出院评估
/// w ##class(web.DHCANAdaptor).CheckDayIsOutFlag(7139)
ClassMethod CheckDayIsOutFlag(AdmId) As %String
{
	s ret=""
	q:+AdmId=0 ret
	s opsId=..GetDaySurgeryIdByAdmId(AdmId)
	q:+opsId=0 ret
	s operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	s statusCode=operSchedule.Status.Code
		s extendOpaId=operSchedule.ExternalID

	s finish="N",finishOut="N"
	i (statusCode="RoomOut")!(statusCode="Finish") s finish="Y"
	s outScore=..GetOperAnAuditData(extendOpaId,"OutScore","AN_ANS_020")
	i outScore'="" s finishOut="Y"
	s ret=finishOut
	q ret
}

/// 通过就诊号获取日间手术名称、日期、手术科室、主刀医师、手术状态、麻醉评估是否通过
/// 7139
ClassMethod GetDaySurgeryInfoByAdm(AdmId)
{
	s ret=""
	s opsId=..GetDaySurgeryIdByAdmId(AdmId)
	q:+opsId=0 ret
	s operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	s statusCode=operSchedule.Status.Description
	s extendOpaId=operSchedule.ExternalID
	Set OperDate=##class(web.DHCClinicCom).ConvertToDate(operSchedule.OperDate,"")           // 手术日期(计划)
	s isAnAudit=..GetOperAnAuditData(extendOpaId,"IsCanDayOper","AN_ANS_018")
	s opId=0
	f  s opId=$o(^CIS.AN.OperListI("IOPS",opsId,opId)) q:opId=""  d
		.s operListObj=##class(CIS.AN.OperList).%OpenId(opId)
		.s operId=operListObj.Operation
		.set objoper=##class(User.ORCOperation).%OpenId(operId)
		.s OperDesc=objoper.OPERDesc
		.s surgeonDept=operListObj.SurgeonDeptID
		.i surgeonDept="" s surgeonDept=operSchedule1.AppDeptID
		.s surgeonDeptDesc=$p(^CTLOC(surgeonDept),"^",2)
		.s surgeon=""
		.s surgeonId=operListObj.Surgeon
		.i surgeonId>0 s surgeon=$p(^CTPCP(surgeonId,1),"^",2)
		.e  s surgeonId="199999",surgeon="未填"
	s ret=OperDesc_"^"_OperDate_"^"_surgeonDept_"^"_surgeon_"^"_statusCode_"^"_isAnAudit
	q ret
}

}
