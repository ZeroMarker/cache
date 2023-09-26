Class web.DHCANRecord Extends %RegisteredObject
{

/// d ##class(%ResultSet).RunQuery("web.UDHCANOPArrange","GetAnOpList","61857","61859","","","","","312","0","","","","N")
Query GetAnOpList(stdate As %String, enddate As %String, stat As %String, oproom As %String, Dept As %String, appType As %String = "", userLocId As %String = "", IsAppT As %String = 0, MedCareNo As %String = "", oprFloorId As %String = "", patWardId As %String = "", paidType As %String = "", LogUserType As %String = "", ifAllLoc As %String = "") As %Query(ROWSPEC = "ordno,status,jzstat,opdate,oproom,opordno,regno,patname,sex,age,opname,diag,opdoc,loc,anmethod,andoc,scrubnurse,circulnurse,yy,opaId,adm,opdatestr,OpAppDateStr,opmem,isAddInstrument,instrument,patWard,anNurse,medCareNo,opRoomId,oprFloor,estiOperDuration,preDiscussDate,isExCirculation,bloodType,opDocNote,anDocNote,opSeqNote,anCompDesc,AnaesthesiaID,operPosition,OPCategory,operInstrument,NeedAnaesthetist,opsttime,mzsupdoc,retReason,anaDoctorOrd,anaNurseOrd,opNurseOrd,inPatNo,admreason,tPacuBed,PACUInDateTime,scNurNote,cirNurNote,anDocAss,bedCode,tDocArriveTime,tAnDocDr,bodsDesc,PatientID,PAADMMainMRADMDR,opUnPlanedOperation,weight")
{
}

ClassMethod GetAnOpListExecute(ByRef qHandle As %Binary, stdate As %String, enddate As %String, stat As %String, oproom As %String, Dept As %String, appType As %String = "", userLocId As %String = "", IsAppT As %String = 0, MedCareNo As %String = "", oprFloorId As %String = "", patWardId As %String = "", paidType As %String = "", LogUserType As %String = "", ifAllLoc As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
    k ^TMPAN("App",$j)
	i (stdate="")!(enddate="") s sdate=+$H,edate=+$H
	e  s sdate=##Class(web.DHCANOPCom).ConvertToDateH(stdate),edate=##Class(web.DHCANOPCom).ConvertToDateH(enddate)
    s linkLocId=##Class(web.DHCCLCom).GetLinkLocId(userLocId)
    s userLocIdStr=linkLocId_"^"_userLocId
	s userLocTyp=""
    i userLocId'="" s userLocTyp=$P(^CTLOC(userLocId),"^",13)
    s operLocId="",chl=""
    s j=1
    s SubNode="SDate"
    i IsAppT=1 s SubNode="AppDate"
    f date=sdate:1:edate
    {   
		;q:userLocId=""
		s opaId=""
		f  s opaId=$O(^DHCANOPArrange(0,SubNode,date,opaId)) q:opaId=""  d
		.q:$d(^DHCANOPArrange(opaId))<1
		.s opdate="",oproomdes="",regNo="",patName="",diag="",sex="",yy="",age="",opdes="",locdes="",opd="",mzdoc="",anmethod="",xsh="",xch="",OPCategory="",weight=""
		.s weight=$P(^DHCANOPArrange(opaId),"^",24)
		.s opstdate=$P(^DHCANOPArrange(opaId),"^",14)
		.s opsttime=$P(^DHCANOPArrange(opaId),"^",15)
		.s openddate=$P(^DHCANOPArrange(opaId),"^",16)
		.s opendtime=$P(^DHCANOPArrange(opaId),"^",17)
		.s opmem=$P(^DHCANOPArrange(opaId),"^",19)        	//WKZ 071109
		.i openddate<=opstdate s openddate=""
		.i openddate'=""  s openddate=$ZD(openddate,3)_" "
		.i opendtime'=""  s opendtime=$ZT(opendtime,2)
		.i opsttime'=""  s opsttime=$ZT(opsttime,2)
		.s opdatestr=$ZD(opstdate,3)_" "_opsttime_"~"_openddate_opendtime
		.s opAppdate=$P(^DHCANOPArrange(opaId),"^",3)         //wkz 071225 S
		.s opApptime=$P(^DHCANOPArrange(opaId),"^",5)
		.i opAppdate'=""  s opAppdate=$ZD(opAppdate,3)
		.i opApptime'=""  s opApptime=$ZT(opApptime,2)
		.s OpAppDateStr=$G(opAppdate)_"  "_$G(opApptime)  	 //wkz 071225 E
		.s arrTime=$P(^DHCANOPArrange(opaId),"^",8)
		.s arrDate=$P(^DHCANOPArrange(opaId),"^",7)
		.i arrTime'=""  d 	//安排时间不为空
			..s opdate=$ZD(arrDate,3)_" "_$ZT(arrTime,2)
		.e  s opdate=$ZD(opstdate,3)_" "_opsttime
		.s oproomdr=$P(^DHCANOPArrange(opaId),"^",20)
		.i oproomdr'="" s oproomdes=$p($g(^DHCANC("OPRoom",oproomdr)),"^",2)
		.q:(oproomdr'=oproom)&(oproom'="")
		.i oproomdr'="" s floorId=$p($g(^DHCANC("OPRoom",oproomdr)),"^",4)
		.e  s floorId=""
		.i floorId'="" s oprFloor=$P($G(^DHCANC("Floor",floorId)),"^",2)
		.e  s oprFloor=""
		.i $g(^tmpAnop("Anop"))="Y" s ^tmpAnop("Anop",opaId,1)=oprFloorId_"/"_floorId
		.q:(oprFloorId'="")&(oprFloorId'=floorId)
		.s opordno=$P(^DHCANOPArrange(opaId),"^",26)
		.;;opdate:打印的时间
		.i (sdate=edate)&(opordno'="")&(opordno=1)&(arrTime="") s opdate="8:30"
		.e  i (sdate'=edate)&(opordno'="")&(opordno=1)&(arrTime="") s opdate=$ZD(opstdate,3)_" "_"8:30"  
		.e  i (sdate=edate)&(opordno'="")&(opordno=1)&(arrTime'="") s opdate=$ZT(arrTime,2)
		.e  i (sdate'=edate)&(opordno'="")&(opordno=1)&(arrTime'="") s opdate=$ZD(opstdate,3)_" "_opsttime
		.s tmpDateStr=opordno
		.i +tmpDateStr=0 s tmpDateStr=""
		.e  s tmpDateStr=tmpDateStr-1
		.s tmpDateStr="接台"_tmpDateStr
		.i sdate'=edate s tmpDateStr=$p(opdate," ")_" "_oproomdes_tmpDateStr
		.e  s tmpDateStr=oproomdes_tmpDateStr
		.i (opordno'="")&(opordno'=1) s opdate=tmpDateStr 
		.s adm=$P(^DHCANOPArrange(opaId),"^",1),admId=adm
		.q:adm=""
		.s PAADMMainMRADMDR=$p($g(^PAADM(adm)),"^",61) 
		.s PatientID=+$g(^PAADM(+adm))
		.s bedCode="",inPatNo="",admreason=""
		.s bedSub=$p($p($g(^PAADM(adm)),"^",73),"||",2)
		.s curWardId=$p($g(^PAADM(adm)),"^",70)  
		.i curWardId'="" s WardDes=$P(^PAWARD(curWardId),"^",1)
		.i (bedSub'="")&(curWardId'="") s bedCode=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)
		.s inPatNo=$p($g(^PAADM(adm)),"^",29)
		.s admreasondr=$p($g(^PAADM(adm,1)),"^",7)
		.i admreasondr'="" s admreason=$p(^PAC("ADMREA",admreasondr),"^",2)
		.s yg=$P($g(^DHCANOPArrange(opaId,"PALab")),"^",29)			//OPA_PATestHBsAg  	免疫乙肝表面抗原
		.s bg=$P($g(^DHCANOPArrange(opaId,"PALab")),"^",34)			//OPA_PATestHCVAb 	免疫丙型肝炎抗体
		.s az=$P($g(^DHCANOPArrange(opaId,"PALab")),"^",35)			//OPA_PATestHivAb 	免疫艾滋病毒抗体
		.s md=$P($g(^DHCANOPArrange(opaId,"PALab")),"^",36)			//OPA_PATestTPAb 	免疫梅毒
		.s qt=$P($g(^DHCANOPArrange(opaId,"PALab")),"^",2)			//OPA_PATestOther	检其它阴阳性
		.i yg="阳性(+)" s yy="乙肝阳性"
		.i bg="阳性(+)" s yy=yy_"丙肝阳性"_" "
		.i az="阳性(+)" s yy=yy_"艾滋病阳性"_" "
		.i md="阳性(+)" s yy=yy_"梅毒阳性"_" "
		.i qt="阳性(+)" s yy=yy_"其他阳性"_" "
		.s opaStatus=$P(^DHCANOPArrange(opaId),"^",27)
		.i $g(^tmpAnop("Anop"))="Y" s ^tmpAnop("Anop",opaId,2)=userLocTyp_"/"_opaStatus_"/"_curWardId
		.q:(opaStatus="")&(userLocTyp'="E")
		.;20120608+dyl
		.s opaPatStatus=$P(^DHCANOPArrange(opaId),"^",23)
		.q:(stat'="")&(stat'=opaStatus)
		.s status=""
		.i opaStatus="A" s status="申请"
		.i (opaStatus="D")&(opaPatStatus'="I") s status="拒绝"
		.i opaStatus="R" s status="安排"
		.i opaStatus="N" s status="非预约"
		.i opaStatus="I" s status="术中"
		.i opaStatus="P" s status="恢复室"
		.i opaStatus="L" s status="术毕"
		.i opaStatus="F" s status="完成"
		.i (opaStatus="D")&(opaPatStatus="I") s status="撤销"
		.q:(opaStatus="N")&(appType="")
		.q:(opaStatus'="N")&(appType="RegNotApp")
		.s papmiId=$p($g(^PAADM(admId)),"^",1)
		.s paadmtype=$p($g(^PAADM(admId)),"^",2)
		.s regNo=$p($g(^PAPER($g(papmiId),"PAT",1)),"^",1)
		.;s medCareNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
	    .s medCareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(admId,paadmtype,.ErrMsg)
		.q:(medCareNo'=MedCareNo)&(MedCareNo'="")
		.s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
		.s birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
		.s age=..CalAge(birth,opstdate)
		.s sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
		.s chl=$P($P(^DHCANOPArrange(opaId),"^",2),"||",2)
		.s admLocId=$p($g(^PAADM(adm)),"^",4)
		.q:admLocId=""
		.s appLocId=$p($g(^DHCANOPArrange(opaId)),"^",54)
		.s qFlag=1
		.i (LogUserType'="ANDOCTOR")&(LogUserType'="ANNURSE")&(LogUserType'="OPNURSE")&(ifAllLoc="Y")&(LogUserType'="DemoGroup") s qFlag=0
		.i $g(^tmpAnop("Anop"))="Y" s ^tmpAnop("Anop",opaId,4)=Dept_"/"_appLocId_"/"_admLocId
		.q:(("^"_Dept_"^")'[("^"_appLocId_"^"))&(Dept'="")&(("^"_Dept_"^")'[("^"_admLocId_"^"))&(admLocId'="")&(qFlag)
		.i +appLocId=0 s appLocId=admLocId
		.i +appLocId=0 s locdes=""
		.e  s locdes=$P($g(^CTLOC(appLocId)),"^",2)
		.i (appLocId'="")&(admLocId'=appLocId)&(paadmtype'="O") s locdes=locdes_"(借)"
		.i $l(locdes,"-")>1 s locdes=$p(locdes,"-",2)
		.i paadmtype="O" s locdes=locdes_"(门)"
		.e  s locdes=locdes_"/"_bedCode
		.s jz=$P(^OR(adm,"ANA",chl),"^",32)   						//ANA_SourceType 急诊(E)/择期(B)
		.i jz="E" s jzstat="急诊"
		.e  s jzstat="择期"
		.s anaTheatreInDate=$p(^OR(adm,"ANA",chl),"^",39)
		.i anaTheatreInDate'="" s anaTheatreInDate=$zd(anaTheatreInDate,3)
		.e  s anaTheatreInDate=opstdate
		.s anaTheatreInTime=$p(^OR(adm,"ANA",chl),"^",40)
		.i anaTheatreInTime'="" s anaTheatreInTime=$zt(anaTheatreInTime,2)
		.e  s anaTheatreInTime=opsttime
		.i opaStatus="F" s opdatestr=anaTheatreInDate_" "_anaTheatreInTime_"~"_openddate_opendtime
		.;;;;;;
		.s mzdr=$P(^OR(adm,"ANA",chl),"^",6)        					;ANA_Anaesthetist_Dr 
		.i mzdr'="" d
		..s mzdoc=##class(web.DHCANOPCom).GetNameById(mzdr)
		.e  s mzdoc=""
		.s mzsupdr=$P(^OR(adm,"ANA",chl),"^",7)        				;ANA_Supervisor_DR ///ck091203  
		.i mzsupdr'="" d
		..s mzsupdoc=##class(web.DHCANOPCom).GetNameById(mzsupdr)
		.e  s mzsupdoc=""
		.s anDocAss=""
		.s ass=0,surgeonDesc=""
		.f  s ass=$o(^OR(adm,"ANA",chl,"OP",1,"ANASS",ass)) q:ass=""  d    //麻醉医师
		..s mzzsdr=$p($g(^OR(adm,"ANA",chl,"OP",1,"ANASS",ass)),"^",1)
		..q:mzzsdr=""
		..i anDocAss="" d
		...s anDocAss=##class(web.DHCANOPCom).GetNameById(mzzsdr)
		..e  d
		...s anDocAss=anDocAss_" "_##class(web.DHCANOPCom).GetNameById(mzzsdr)
		.i anDocAss'="" s mzdoc=mzdoc_","_anDocAss
		.s mzNurseId=$P(^OR(adm,"ANA",chl),"^",8)
		.i mzNurseId'="" d
		..s anNurse=##class(web.DHCANOPCom).GetNameById(mzNurseId)
		.e  s anNurse=""
		.s anmthdr=$P(^OR(adm,"ANA",chl),"^",5)
		.s anmethod=""
		.i anmthdr'="" d
			..s anmetNum=$l(anmthdr,"|")
			..f i=1:1:anmetNum d
				...s anmetId=$p(anmthdr,"|",i)
				...q:anmetId=""
				...s anmetDesc=$p($g(^ORC("ANMET",anmetId)),"^",2)
				...i $P(anmetDesc,"-",2)'="" s anmetDesc=$P(anmetDesc,"-",2)
				...i anmethod="" s anmethod=anmetDesc
				...;e  s anmethod=anmethod_","_anmetDesc
				...e  i (anmethod'="")&(anmethod'[anmetDesc) s anmethod=anmethod_","_anmetDesc
				...e  i (anmethod'="")&(anmethod[anmetDesc) s anmethod=anmethod
		.s anCompDesc=""                                        		//+ wxl 090316 合并疾病
		.s subchl=0 f  s subchl=$O(^OR(adm,"ANA",chl,"COMP",subchl)) q:(subchl="")  d
		..s AnCompDr=$P(^OR(adm,"ANA",chl,"COMP",subchl),"^",1)
		..q:AnCompDr=""
		..i anCompDesc="" s anCompDesc=$P(^ORC("COMP",AnCompDr),"^",2)
		..e  s anCompDesc=anCompDesc_","_$P(^ORC("COMP",AnCompDr),"^",2)	   
		.s i=0
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
		..s i=i+1
		..q:i>1   ///ck091117
		..s sub=subchl
		..;手术部位
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
			    ....e  s bodsDesc=bodsDesc_"|"_bodsDesc2   
		..;;;
		..s docdr=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",8)      		;ANAOP_Surgeon_DR   手术医师
		..s opd=""
		..//i docdr'="" s opd=$TR($P(^CTPCP(docdr,1),"^",2)," ","")
		..i docdr'="" s opd=##class(web.DHCANOPCom).GetNameById(docdr)
		..e  s opd=$TR($p($p(^DHCANOPArrange(opaId),"^",42),"|",2)," ","")  //CK 091210 手术医生备注(外来手术医生)
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
		.....s diamen=$p(^OR(adm,"ANA",chl,"TXT",2),"|",pi)  	//ck091210 麻醉表存放诊断备注ANA_Notes
		.....s $p(diag,",",pi)=$G(diamen)            //zhangtao add
		..s operLocId=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",10) 		;ANAOP_CTLOC_DR
		.i $g(^tmpAnop("Anop"))="Y" s ^tmpAnop("Anop",opaId,5)=userLocIdStr_"/"_operLocId_"/"_admLocId_"/"_appLocId
		.;q:(("^"_userLocIdStr_"^")'[("^"_+operLocId_"^"))&(("^"_userLocIdStr_"^")'[("^"_+admLocId_"^"))&(("^"_userLocIdStr_"^")'[("^"_+appLocId_"^"))&(qFlag)  //ypz 070318
		.s i=0
		.q:sub=""
		..s i=i+1
		.s ash=""
		.
		.s assDocNum=2 //最多显示的助手人数
		.i $p($g(^DHCCLSet("AnOp","Ctcp")),"^",1)'="" s assDocNum=$p($g(^DHCCLSet("AnOp","Ctcp")),"^",1)
		.s p=0
		.s list=0,asName=""
		.s opaDocNote=$P(^DHCANOPArrange(opaId),"^",42) //手动填写OPA_OpDocNote（实习医生1;实习医生2...|主刀|一助|二助|三助|四助|五助...）
		.s len=$l(opaDocNote,"|")
		.s as=0 f  s as=$O(^OR(adm,"ANA",chl,"OP",sub,"ASS",as)) q:(as="")!(p'<assDocNum)  d
		..s asdr=$P(^OR(adm,"ANA",chl,"OP",sub,"ASS",as),"^",1)
		..s p=p+1
		..q:asdr=""
		..//s asName=asName_"^"_$P(^CTPCP(asdr,1),"^",2)
		..s asName=asName_"^"_##class(web.DHCANOPCom).GetNameById(asdr)
		.i len>assDocNum+2 s len=assDocNum+2
		.f getLen=3:1:len  d
		..i $p(opaDocNote,"|",getLen)'=""  d
		...s getName=$p(opaDocNote,"|",getLen)
		..e  d
		...s list=list+1
		...s getName=$p(asName,"^",list+1)
		..s ash=ash_" "_getName
		.
		.s p=0  ;洗手
		.s xs=0 f  s xs=$O(^OR(adm,"ANA",chl,"OP",sub,"SCN",xs)) q:(xs="")!(p=3)  d
		..q:xs>20
		..s xsdr=$P(^OR(adm,"ANA",chl,"OP",sub,"SCN",xs),"^",1)
		..q:xsdr=""
		..s p=p+1
		..//s xsh=xsh_" "_$TR($P(^CTPCP(xsdr,1),"^",2)," ","")  ;
		..s xsh=xsh_" "_##class(web.DHCANOPCom).GetNameById(xsdr)
		.s p=0  ;巡回
		.s xc=0 f  s xc=$O(^OR(adm,"ANA",chl,"OP",sub,"CIRN",xc)) q:(xc="")!(p=3)   d
		..q:xc>20
		..s xchdr=$P(^OR(adm,"ANA",chl,"OP",sub,"CIRN",xc),"^",1)
		..q:xchdr=""
		..s p=p+1
		..//s xch=$G(xch)_" "_$TR($P($G(^CTPCP(xchdr,1)),"^",2)," ","")  
		..s xch=$G(xch)_" "_##class(web.DHCANOPCom).GetNameById(xchdr)  
		.s scNurNote=$p($G(^DHCANOPArrange(opaId)),"^",51)		//OPA_ScrubNurseNote	器械护士备注 	
		.s cirNurNote=$p($G(^DHCANOPArrange(opaId)),"^",52)		//OPA_CirculNurseNote	巡回护士备注
		.s j=j+1
		.s opd=opd_","_$G(ash)
		.s sortOpRoomDesc=oproomdes
		.i oproomdes="" s oproomdes="无"
		.s sortOpaSeq=opordno
		.i opordno="" s opordno="未排" ;Do OutRow2
		.s NeedAnaesthetist=$p($G(^DHCANOPArrange(opaId)),"^",44)
		.
		.s oprFloor=""
		.//i NeedAnaesthetist'="Y" s oprFloor="不需要"
		.//e  d
			..q:"D"[opaStatus
			..s para="M^149^麻醉会诊意见"
			..s eprRet=##class(EPRservice.BIL.BIToAN).IsOneGroupComplished(adm, 1, +$h, para)
			..i eprRet=0 s oprFloor="未写麻醉会诊意见! "
			..s para="M^151^麻醉知情同意书"
			..s eprRet=##class(EPRservice.BIL.BIToAN).IsOneGroupComplished(adm, 1, +$h, para)
			..i eprRet=0 s oprFloor=oprFloor_"未写麻醉知情同意书! "
			..q:"AR"[opaStatus
			..i "I"[opaStatus s oprFloor=oprFloor_"未完成麻醉记录单! "
			..e  d
				...s anoId=$o(^DHCANOrder(0,"OPApp",opaId,""))
				...i anoId="" s oprFloor=oprFloor_"未写麻醉记录单! "
			..q:"I"[opaStatus
			..s para="M^153^麻醉术后访视记录"
			..s eprRet=##class(EPRservice.BIL.BIToAN).IsOneGroupComplished(adm, 1, +$h, para)
			..i eprRet=0 s oprFloor=oprFloor_"未写麻醉术后访视记录! "
		.
		.s operInstrumentId=$P(^DHCANOPArrange(opaId),"^",30)
		.i operInstrumentId'="" s operInstrument=$P($G(^DHCANC("Instrument",operInstrumentId)),"^",2)
		.e  s operInstrument=""
		.s EpisodeID=$P(^DHCANOPArrange(opaId),"^",1)
		.s anaId=$P(^DHCANOPArrange(opaId),"^",2)
		.s anaSub=$P(anaId,"||",2)
		.;手术体位
		.s operPositionId=$P($G(^OR(EpisodeID,"ANA",anaSub,"OP",1,"POS",1)),"^")
		.i operPositionId'="" s operPosition=$P($G(^ORC("OPPOS",operPositionId)),"^",2)
		.e  s operPosition=""
		.s OPCategory="",OPCategoryId=""
		.;s OPCategoryId=$p(^ORC("OPER",opdr),"^",7)
		.i opdr'="" s OPCategoryId=$p($g(^ORC("OPER",opdr)),"^",7)
		.i OPCategoryId'=""  s OPCategory=$p($g(^ORC("CATEG",OPCategoryId)),"^",2)
		.s isAddInstrument=$P($G(^DHCANOPArrange(opaId)),"^",31)
		.s instrumentDr=$P($G(^DHCANOPArrange(opaId)),"^",30)
		.i instrumentDr'="" s instrument=$P($G(^DHCANC("Instrument",instrumentDr)),"^",2)
		.e  s instrument=""
		.s patWardId1=$P($G(^DHCANOPArrange(opaId)),"^",32)
		.i $g(^tmpAnop("Anop"))="Y" s ^tmpAnop("Anop",opaId,6)=patWardId1_"/"_patWardId
		.q:(patWardId'="")&(patWardId'=patWardId1)
		.i patWardId1'="" s patWard=$P($G(^PAWARD(patWardId1)),"^",2)
		.e  s patWard=""
		.s estiOperDuration=$P($G(^DHCANOPArrange(opaId)),"^",37)
		.i estiOperDuration'="" s estiOperDuration=$ZT(estiOperDuration,2)
		.s preDiscussDate=$P($G(^DHCANOPArrange(opaId)),"^",38)
		.s preDiscussDate=$ZD(preDiscussDate,4)
		.s isExCirculation=$P($G(^DHCANOPArrange(opaId)),"^",36)
		.s bloodTypId=$P(^DHCANOPArrange(opaId),"^",11)
		.i (+bloodTypId'=0)&($d(^PAC("BLDT",+bloodTypId))) s bloodType=$P($G(^PAC("BLDT",bloodTypId)),"^",2)
		.e  s bloodType="不详"
		.s opDocNote=$P($G(^DHCANOPArrange(opaId)),"^",42)
		.s anDocNote=$P($G(^DHCANOPArrange(opaId)),"^",43)
		.s opSeqNote=$P($G(^DHCANOPArrange(opaId)),"^",41)
		.s AnaesthesiaID=$P($G(^DHCANOPArrange(opaId)),"^",2)
		.s retReasonId=$P($G(^DHCANOPArrange(opaId)),"^",35)
		.i opaStatus'="D" s retReasonId=""	;20120613+dyl
		.i retReasonId'=""  s retReason=$p(^ORC("SUSP",retReasonId),"^",2)   //+ ck091212 手术拒绝原因
		.e  s retReason=""
		.s anaDoctorOrd=$p($G(^DHCANOPArrange(opaId)),"^",48)     	//+ ck091212 麻醉医生收费状态
		.i anaDoctorOrd="Y"  s anaDoctorOrd="Y"
		.e  s anaDoctorOrd="N"
		.i $g(^tmpAnop("Anop"))="Y" s ^tmpAnop("Anop",opaId,7)=paidType_"/"_anaDoctorOrd_"/"_LogUserType
		.q:(paidType="Y")&(LogUserType="ANDOCTOR")&(anaDoctorOrd="N") //ck 20100303修改
		.q:(paidType="N")&(LogUserType="ANDOCTOR")&(anaDoctorOrd="Y")
		.s anaNurseOrd=$p($G(^DHCANOPArrange(opaId)),"^",49)      	//+ ck091212 麻醉护士收费状态
		.i anaNurseOrd="Y"  s anaNurseOrd="Y"
		.e  s anaNurseOrd="N"
		.q:(paidType="Y")&(LogUserType="ANNURSE")&(anaNurseOrd="N")    //ck 20100303修改
		.q:(paidType="N")&(LogUserType="ANNURSE")&(anaNurseOrd="Y")
		.s opNurseOrd=$p($G(^DHCANOPArrange(opaId)),"^",50)       	//+ ck091212 手术护士收费状态
		.i opNurseOrd="Y"  s opNurseOrd="Y"
		.e  s opNurseOrd="N"
		.q:(paidType="Y")&(LogUserType="OPNURSE")&(opNurseOrd="N") //ck 20100303修改
		.q:(paidType="N")&(LogUserType="OPNURSE")&(opNurseOrd="Y")
		.s tPacuBedId=$P($G(^DHCANOPArrange(opaId)),"^",47)		 	//OPA_PacuBed_Dr	麻醉恢复床
		.i tPacuBedId'="" s tPacuBed=$p(^DHCANC("OPRoom",tPacuBedId),"^",2)
		.e  s tPacuBed=""
		.s PACUInDate=$P($G(^DHCANOPArrange(opaId,"PACU")),"^",6) 	//OPA_PACUInDate	入恢复室日期
		.i PACUInDate'="" s PACUInDate=$zd(PACUInDate,3)
		.s PACUInTime=$P($G(^DHCANOPArrange(opaId,"PACU")),"^",7) 	//OPA_PACUInTime	入恢复室时间
		.i PACUInTime'="" s PACUInTime=$zt(PACUInTime)
		.s PACUInDateTime=PACUInDate_" "_PACUInTime
		.s ret=0
		.s ret=..GetOpNum(opaId)
		.i ret>1 s opUnPlanedOperation="是" 
		.i ret<2 s opUnPlanedOperation="否"
		.i sortOpRoomDesc="" s sortOpRoomDesc=0
		.i sortOpaSeq<10 s sortOpaSeq=0_sortOpaSeq
		.s opaSeqNote=$P($G(^DHCANOPArrange(opaId)),"^",41)	//OPA_SeqNote
		.s appLocId=$P($G(^DHCANOPArrange(opaId)),"^",54)	//OPA_AppLoc_Dr
		.s appLocDesc=$P($G(^CTLOC(+appLocId)),"^",2)
		.s tDocArriveTime=$P(^DHCANOPArrange(opaId),"^",46)
		.i tDocArriveTime'="" s tDocArriveTime=##class(web.DHCANOPCom).ConvertToTime(tDocArriveTime)
		.//s ^tmpYpz("app",opaId)=sortOpRoomDesc_"/"_sortOpaSeq_","_opaSeqNote_"/"_appLocDesc_","_surgeonDesc_"/"_opaId
		.s ^TMPAN("App",$j,sortOpRoomDesc,sortOpaSeq_","_opaSeqNote,appLocDesc_","_surgeonDesc,opaId)=$lb("d",status,jzstat,opdate,oproomdes,opordno,regNo,patName,sex,age,opdes,diag,opd,locdes,anmethod,mzdoc,xsh,xch,yy,opaId,adm,opdatestr,OpAppDateStr,opmem,isAddInstrument,instrument,patWard,anNurse,medCareNo,oproomdr,oprFloor,estiOperDuration,preDiscussDate,isExCirculation,bloodType,opDocNote,anDocNote,opSeqNote,anCompDesc,AnaesthesiaID,operPosition,OPCategory,operInstrument,NeedAnaesthetist,opsttime,mzsupdoc,retReason,anaDoctorOrd,anaNurseOrd,opNurseOrd,inPatNo,admreason,tPacuBed,PACUInDateTime,scNurNote,cirNurNote,anDocAss,bedCode,tDocArriveTime,mzdr,bodsDesc,PatientID,PAADMMainMRADMDR,opUnPlanedOperation,weight)
}
	s sortOpRoomDesc="" f  s sortOpRoomDesc=$o(^TMPAN("App",$j,sortOpRoomDesc)) q:sortOpRoomDesc=""  d
	.s sortSeq="" f  s sortSeq=$o(^TMPAN("App",$j,sortOpRoomDesc,sortSeq)) q:sortSeq=""  d
	..s locDoc="" f  s locDoc=$o(^TMPAN("App",$j,sortOpRoomDesc,sortSeq,locDoc)) q:locDoc=""  d
	...s opaId="" f  s opaId=$o(^TMPAN("App",$j,sortOpRoomDesc,sortSeq,locDoc,opaId)) q:opaId=""  d
	....do OutRow2
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutRow2
	//set Data=$lb(ind,status,jzstat,opdate,oproomdes,opordno,regNo,patName,sex,age,opdes,diag,opd,locdes,anmethod,mzdoc,xsh,xch,yy,oppack,opaId)
 	Set ^CacheTemp(repid,ind)=^TMPAN("App",$j,sortOpRoomDesc,sortSeq,locDoc,opaId)
 	Set ind=ind+1
	quit
}

ClassMethod GetAnOpListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAnOpListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetAnOpListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAnOpListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 根据opaId取术中的用药和事件
/// FQC
/// 20141022
/// d ##class(%ResultSet).RunQuery("web.DHCANRecord","FindAnInfo","184694")
Query FindAnInfo(opaId As %String) As %Query(ROWSPEC = "AnRowId:%String,ANOType:%String,ANOAbbreviate:%String,start:%String,end:%String,ANORecLoc:%String,ANOQty:%String,ANOInstr:%String,ANUom:%String,ANODensity:%String,ANOSpeed:%String,ANOVolume:%String,ANODrugMode:%String,ANOSource:%String")
{
}

ClassMethod FindAnInfoExecute(ByRef qHandle As %Binary, opaId As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	 q:opaId="" 
	 s AnRowId="",start="",end=""
	 f  s AnRowId=$O(^DHCANOrder(0,"OPApp",opaId,AnRowId)) q:AnRowId=""  d
	 .s ANOType=$p(^DHCANOrder(AnRowId),"^",30)
	 .s ANOStartDate=$p(^DHCANOrder(AnRowId),"^",5)
	 .i ANOStartDate'="" s ANOStartDate=$ZD(ANOStartDate,3)  
	 .s ANOStartTime=$p(^DHCANOrder(AnRowId),"^",6)
	 .i ANOStartTime'="" s ANOStartTime=$ZT(ANOStartTime,2)
	 .s start=ANOStartDate_" "_ANOStartTime       //医嘱开始时间
	 .s ANOEndDate=$p(^DHCANOrder(AnRowId),"^",7)
	 .i ANOEndDate'="" s ANOEndDate=$ZD(ANOEndDate,3)
	 .s ANOEndTime=$p(^DHCANOrder(AnRowId),"^",8)
	 .i ANOEndTime'="" s ANOEndTime=$ZT(ANOEndTime,2)
	 .s end=ANOEndDate_" "_ANOEndTime            //医嘱结束时间
	 .s ANOAbbreviate=$p(^DHCANOrder(AnRowId),"^",35)
	 .s ANORecLocDr=$p(^DHCANOrder(AnRowId),"^",26)   //接收科室
	 .i ANORecLocDr'="" s ANORecLoc=$p(^CTLOC(ANORecLocDr),"^",2)
	 .s ANOSource=$p(^DHCANOrder(AnRowId),"^",29) //数据来源:I-仪器,M-手工
     .i ANOSource="I" s ANOSource="仪器采集"
     .i ANOSource="M" s ANOSource="手工录入"
	 .i ANOType="D" d
	 ..s ANODrugMode="",ANOQty="",ANOUomDr="",ANUom="",ANODensity="",ANOInstrDr="",ANOInstr="",ANODrugMode="",ANOSpeed="",ANOVolume=""
	 ..s ANOType="术中用药"
     ..s ANOQty=$p(^DHCANOrder(AnRowId),"^",11) //数量
     ..s ANOUomDr=$p(^DHCANOrder(AnRowId),"^",12) //单位指向
     ..i ANOUomDr'="" s ANUom=$p(^CT("UOM",ANOUomDr),"^",2) //单位
     ..s ANODensity=$p(^DHCANOrder(AnRowId),"^",13) //浓度
     ..s ANOInstrDr=$p(^DHCANOrder(AnRowId),"^",15) //用药途径
     ..i ANOInstrDr'="" s ANOInstr=$p(^PHCIN(ANOInstrDr),"^",2)
     ..s ANODrugMode=$p(^DHCANOrder(AnRowId),"^",18) //给药方式
     ..i ANODrugMode="C" s ANODrugMode="连续给药"
     ..i ANODrugMode="S" s ANODrugMode="一次性用药"
     ..s ANOSpeed=$p(^DHCANOrder(AnRowId),"^",19) //用药速度
     ..s ANOVolume=$p(^DHCANOrder(AnRowId),"^",28) //容量
     ..d OutputRow6
	 .i ANOType="E" d
	 ..s ANOType="术中事件"
	 ..s ANODrugMode="",ANOQty="",ANOUomDr="",ANUom="",ANODensity="",ANOInstrDr="",ANOInstr="",ANODrugMode="",ANOSpeed="",ANOVolume="",ANOEditFlag=""
	 ..s ANOEditFlag=$p(^DHCANOrder(AnRowId),"^",25)
	 ..q:(ANOEditFlag'="N")&(ANOEditFlag'="E")
	 ..d OutputRow6
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow6
	set Data=$lb(AnRowId,ANOType,ANOAbbreviate,start,end,ANORecLoc,ANOQty,ANOInstr,ANUom,ANODensity,ANOSpeed,ANOVolume,ANODrugMode,ANOSource)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod FindAnInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAnInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindAnInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAnInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 根据出生日计算年龄
ClassMethod CalAge(IBirth As %String, IToday As %String) As %String
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
	//s reage=$p(AgeYr,"|",12)_"Y "_AgeMth_"M "_AgeDay_"D"
	i $p(AgeYr,"|",12)>0 s reage=$p(AgeYr,"|",12)_"岁"
	e  d
	.i AgeMth>0 s reage=AgeMth_"月"
	.e  d
	..s reage=AgeDay_"天"
	q reage
}

ClassMethod GetOpNum(opaId As %String)
{
 s ret=0
 s adm=$p($G(^DHCANOPArrange(opaId)),"^",1)
 s opstatus=$p($G(^DHCANOPArrange(opaId)),"^",27)
 i opstatus'="D" d
 .s id="" 
 .f  s id=$o(^DHCANOPArrange(0,"Adm",adm,id)) q:(id="")||(id>opaId)  d
 ..s opstatus=$p($G(^DHCANOPArrange(id)),"^",27)
 ..i (opstatus'="D") d
 ...s ret=ret+1
 q ret
}

ClassMethod getTime(opaId As %String) As %String
{
	q:opaId=""
	s proAnTime="",leaveTime="",inICUTime="",toWarTime="",ret=""
	//预计麻醉时间   离病区时间  入icu时间  返回病房时间
	s proAnTime=$g(^DHCTime("proAnTime",opaId))
	s leaveTime=$g(^DHCTime("leaveTime",opaId))
	s inICUTime=$g(^DHCTime("toICUTime",opaId))
	s toWarTime=$g(^DHCTime("toWarTime",opaId))
	s ret=proAnTime_"^"_leaveTime_"^"_inICUTime_"^"_toWarTime
	q ret
}

ClassMethod UpdateTime(opaId As %String, proAnTime As %String, leaveTime As %String, toICUTime As %String, toWarTime As %String)
{
	q:opaId=""
	s ^DHCTime("proAnTime",opaId)=proAnTime   //预计麻醉时间
	s ^DHCTime("leaveTime",opaId)=leaveTime   //离病区时间
	s ^DHCTime("toICUTime",opaId)=toICUTime   //入ICU时间
	s ^DHCTime("toWarTime",opaId)=toWarTime   //返回病房时间
	q 0
}

}
