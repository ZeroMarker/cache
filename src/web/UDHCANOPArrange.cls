Import SQLUser

Include webimport

IncludeGenerator webimport

Class web.UDHCANOPArrange Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 1060;

/// d ##class(%ResultSet).RunQuery("web.UDHCANOPArrange","GetAnOpList","64140","64141","","","","","","","","","","N")
Query GetAnOpList(stdate As %String, enddate As %String, stat As %String, oproom As %String, Dept As %String, appType As %String = "", userLocId As %String = "", IsAppT As %String = 0, MedCareNo As %String = "", oprFloorId As %String = "", patWardId As %String = "", paidType As %String = "", LogUserType As %String = "", ifAllLoc As %String = "", ifOutOper As %String = "", mulStr As %String = "") As %Query(ROWSPEC = "ordno,status,jzstat,opdate,oproom,opordno,regno,patname,sex,age,opname,diag,opdoc,loc,anmethod,andoc,scrubnurse,circulnurse,yy,opaId,adm,opdatestr,OpAppDateStr,opmem,isAddInstrument,instrument,patWard,anNurse,medCareNo,opRoomId,oprFloor,estiOperDuration,preDiscussDate,isExCirculation,bloodType,opDocNote,anDocNote,opSeqNote,anCompDesc,AnaesthesiaID,operPosition,OPCategory,operInstrument,NeedAnaesthetist,opsttime,mzsupdoc,retReason,anaDoctorOrd,anaNurseOrd,opNurseOrd,inPatNo,admreason,tPacuBed,PACUInDateTime,scNurNote,cirNurNote,anDocAss,bedCode,opUnPlanedOperation,tAnDocDr,bodsDesc,PatientID,PAADMMainMRADMDR,isUseSelfBlood,secretCode,patLevel,secId,selfReport,operResource,queueNo,operStock,operStockNote,patTel,appCtcpId,appDocDesc,ASA,transferFlag,dayOperFlag")
{
}

ClassMethod GetAnOpListExecute(ByRef qHandle As %Binary, stdate As %String, enddate As %String, stat As %String, oproom As %String, Dept As %String, appType As %String = "", userLocId As %String = "", IsAppT As %String = 0, MedCareNo As %String = "", oprFloorId As %String = "", patWardId As %String = "", paidType As %String = "", LogUserType As %String = "", ifAllLoc As %String = "", ifOutOper As %String = "", mulStr As %String = "") As %Status
{
	///paidType "Y"已收费，"N"未收费，其它为全部
 	Set repid=$I(^CacheTemp)
 	s ind=1
    k ^TMPAN("App",$j)
    s dateformatnum=##class(websys.Conversions).DateFormat()
	i (stdate="")!(enddate="") s sdate=+$H,edate=+$H
	e  s sdate=##Class(web.DHCANOPCom).ConvertToDateH(stdate),edate=##Class(web.DHCANOPCom).ConvertToDateH(enddate)
    s linkLocId=##Class(web.DHCClinicCom).GetLinkLocId(userLocId)
    s userLocIdStr=linkLocId_"^"_userLocId
	s userLocTyp="",userLocHosp=""	;20170214+dyl
    i userLocId'="" s userLocTyp=$P(^CTLOC(userLocId),"^",13),userLocHosp=$P($g(^CTLOC(userLocId)),"^",22)
   
    s operLocId="",chl=""
    s j=1
    s SubNode="SDate"
    i IsAppT=1 s SubNode="AppDate"
    k ^tmpDyl("Portsal")
    k ^tmpAnop("Anop")
    s ^tmpAnop("Anop")="Y"
    ;s ^tmpDyl("Portsal")=stdate_"/"_ enddate_"/"_stat_"/"_oproom_"/"_Dept_"/"_appType_"/"_userLocId_"/"_IsAppT_"/"_MedCareNo_"/"_oprFloorId_"/"_patWardId_"/"_paidType_"/"_LogUserType_"/"_ifAllLoc
    f date=sdate:1:edate
    {   
		;q:userLocId=""
		s opaId=""
		f  s opaId=$O(^DHCANOPArrange(0,SubNode,date,opaId)) q:opaId=""  d
		.q:$d(^DHCANOPArrange(opaId))<1
		.s opdate="",oproomdes="",regNo="",patName="",diag="",sex="",yy="",age="",opdes="",locdes="",opd="",mzdoc="",anmethod="",xsh="",xch="",OPCategory="",opUnPlanedOperation="",ASA=""
		.s dayOperFlag="",isdpFlag="",isNeedAn=""
		.i mulStr'="" s isdpFlag=$p(mulStr,"|",1),isNeedAn=$p(mulStr,"|",2)
		.s outOper=$g(^DHCANOPArrange("OUTOP",opaId))
		.q:(ifOutOper="O")&&(ifOutOper'=outOper)
		.q:(ifOutOper="I")&&(outOper'="")
		.s opstdate=$P(^DHCANOPArrange(opaId),"^",14)
		.s opsttime=$P(^DHCANOPArrange(opaId),"^",15)
		.s openddate=$P(^DHCANOPArrange(opaId),"^",16)
		.s opendtime=$P(^DHCANOPArrange(opaId),"^",17)
		.s opmem=$P(^DHCANOPArrange(opaId),"^",19)        	//WKZ 071109
		.i openddate<=opstdate s openddate=""
		.i openddate'=""  s openddate=$ZD(openddate,dateformatnum)_" "
		.i opendtime'=""  s opendtime=$ZT(opendtime,2)
		.i opsttime'=""  s opsttime=$ZT(opsttime,2)
		.i opstdate'="" s opdatestr=$ZD(opstdate,dateformatnum)_" "_opsttime_"~"_openddate_opendtime
		.e  s opdatestr=""
		.s opAppdate=$P(^DHCANOPArrange(opaId),"^",3)         //wkz 071225 S
		.s opApptime=$P(^DHCANOPArrange(opaId),"^",5)
		.i opAppdate'=""  s opAppdate=$ZD(opAppdate,dateformatnum)
		.i opApptime'=""  s opApptime=$ZT(opApptime,2)
		.s OpAppDateStr=$G(opAppdate)_"  "_$G(opApptime)  	 //wkz 071225 E
		.s arrTime=$P(^DHCANOPArrange(opaId),"^",8)
		.s arrDate=$P(^DHCANOPArrange(opaId),"^",7)
		.i arrTime'=""  d 	//安排时间不为空
			..s opdate=$ZD(arrDate,dateformatnum)_" "_$ZT(arrTime,2)
		.e  d
		..i opstdate'="" d
		...s opdate=$ZD(opstdate,dateformatnum)_" "_opsttime
		..e  s opdate=""
		.s oproomdr=$P(^DHCANOPArrange(opaId),"^",20)
		.i oproomdr'="" s oproomdes=$p($g(^DHCANC("OPRoom",oproomdr)),"^",2)
		.q:(oproomdr'=oproom)&(oproom'="")
		.i oproomdr'="" s floorId=$p($g(^DHCANC("OPRoom",oproomdr)),"^",4)
		.e  s floorId=""
		.i floorId'="" s oprFloor=$P($G(^DHCANC("Floor",floorId)),"^",2)
		.e  s oprFloor=""
		.;i $g(^tmpAnop("Anop"))="Y" s ^tmpAnop("Anop",opaId,1)=oprFloorId_"/"_floorId
		.;q:(oprFloorId'="")&(oprFloorId'=floorId)
		.s opordno=$P(^DHCANOPArrange(opaId),"^",26)
		.;;opdate:打印的时间
		.i (sdate=edate)&(opordno'="")&(opordno=1)&(arrTime="") s opdate="8:30"
		.e  i (sdate'=edate)&(opordno'="")&(opordno=1)&(arrTime="") s opdate=$ZD(opstdate,dateformatnum)_" "_"8:30"  
		.e  i (sdate=edate)&(opordno'="")&(opordno=1)&(arrTime'="") s opdate=$ZT(arrTime,2)
		.e  i (sdate'=edate)&(opordno'="")&(opordno=1)&(arrTime'="") s opdate=$ZD(opstdate,dateformatnum)_" "_opsttime
		.e  d
		..i opstdate'="" d
		...s opdate=$ZD(opstdate,dateformatnum)_" "_opsttime
		..e  s opdate=""
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
		.s secretCode="",patLevel="",secId=""	//中日友好涉密
		.s SecretLevel=""
		.s SecretLevel=##class(web.DHCClinicCom).GetPatLevelByPapmiId(adm)
		.i SecretLevel'="" d
			..s secretCode=$p($g(SecretLevel),"^",4),patLevel=$p($g(SecretLevel),"^",2),secId=$p(SecretLevel,"^",3)
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
		.i (opaStatus="D") s status="拒绝"
		.i opaStatus="R" s status="安排"
		.i opaStatus="N" s status="非预约"
		.i opaStatus="I" s status="术中"
		.i opaStatus="P" s status="恢复室"
		.i opaStatus="L" s status="术毕"
		.i opaStatus="F" s status="完成"
		.i (opaStatus="C") s status="撤销"
		.i opaStatus="S" s status="拟日间"
		.;q:(opaStatus="N")&(appType="")
		.q:(opaStatus'="N")&(appType="RegNotApp")
		.q:(opaStatus="C")&(userLocTyp="OP")	;20161214+手术室不看撤销状态的手术
		.s papmiId=$p($g(^PAADM(admId)),"^",1)
		.s paadmtype=$p($g(^PAADM(admId)),"^",2)
		.s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
		.;s medCareNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
		.q:(regNo'[MedCareNo)&(MedCareNo'="")
		.;S medCareNo= ##Class(web.DHCWMRService).IGetMrNoByEpisodeID(admId , .ErrMsg)
	    .s medCareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(admId,paadmtype,.ErrMsg)
		.;q:(medCareNo'=MedCareNo)&(MedCareNo'="")
		.s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
		.s birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
		.;s age=..CalAge(birth,opstdate)
		.s age=##class(web.DHCBillInterface).GetPapmiAge(papmiId,admId)
		.s sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
		.s patTel=$p($g(^PAPER(papmiId,"ALL")),"^",4)  ;add by lyn  患者电话
		.s chl=$P($P(^DHCANOPArrange(opaId),"^",2),"||",2)
		.s admLocId=$p($g(^PAADM(adm)),"^",4)
		.q:admLocId=""
		.s admLocHosp=""
		.s admLocHosp=$P($g(^CTLOC(admLocId)),"^",22)	;20170214+dyl
		.q:(admLocHosp'=userLocHosp)&(userLocHosp'="")&(admLocHosp'="")
		.s appLocId=$p($g(^DHCANOPArrange(opaId)),"^",54)
		.;s ^tmpDyl("UserLoc",opaId)=userLocIdStr_"/"_appLocId
		.q:(opaStatus="D")&(opaPatStatus="I")&(userLocIdStr'="")&(userLocIdStr'[appLocId)
		.s qFlag=1
		.i (LogUserType'="ANDOCTOR")&(LogUserType'="ANNURSE")&(LogUserType'="OPNURSE")&(ifAllLoc="Y") s qFlag=0
		.;q:(Dept'[appLocId)&(Dept'="")&(Dept'[admLocId)&(admLocId'="")
		.i $g(^tmpAnop("Anop"))="Y" s ^tmpAnop("Anop",opaId,4)=Dept_"/"_appLocId_"/"_admLocId
		.q:(("^"_Dept_"^")'[("^"_appLocId_"^"))&(Dept'="")&(("^"_Dept_"^")'[("^"_admLocId_"^"))&(admLocId'="")&(ifAllLoc'="Y")
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
		.s dayOperFlag=$P($g(^OR(adm,"ANA",chl,"OP",1)),"^",22)
		.q:(dayOperFlag'="Y")&(isdpFlag="Y")
		.;;;;最后手术登记存放的时间，20120607+dyl
		.s anaTheatreInDate=$p(^OR(adm,"ANA",chl),"^",39)
		.i anaTheatreInDate'="" s anaTheatreInDate=$zd(anaTheatreInDate,dateformatnum)
		.e  s anaTheatreInDate=opstdate
		.s anaTheatreInTime=$p(^OR(adm,"ANA",chl),"^",40)
		.i anaTheatreInTime'="" s anaTheatreInTime=$zt(anaTheatreInTime,2)
		.e  s anaTheatreInTime=opsttime
		.i opaStatus="F" s opdatestr=anaTheatreInDate_" "_anaTheatreInTime_"~"_openddate_opendtime
		.;;;;;;
		.s mzdr=$P(^OR(adm,"ANA",chl),"^",6)        					;ANA_Anaesthetist_Dr 
		.i mzdr'="" d
		..//s mzdoc=$TR($P($G(^CTPCP(mzdr,1)),"^",2)," ","") 			;麻醉医师
		..s mzdoc=##class(web.DHCANOPCom).GetNameById(mzdr)
		.e  s mzdoc=""
		.s mzsupdr=$P(^OR(adm,"ANA",chl),"^",7)        				;ANA_Supervisor_DR ///ck091203  
		.i mzsupdr'="" d
		..//s mzsupdoc=$TR($P(^CTPCP(mzsupdr,1),"^",2)," ","") 		;麻醉指导医师
		..s mzsupdoc=##class(web.DHCANOPCom).GetNameById(mzsupdr)
		.e  s mzsupdoc=""
		.s anDocAss=""
		.s ass=0,surgeonDesc=""
		.f  s ass=$o(^OR(adm,"ANA",chl,"OP",1,"ANASS",ass)) q:ass=""  d    //麻醉医师
		..s mzzsdr=$p($g(^OR(adm,"ANA",chl,"OP",1,"ANASS",ass)),"^",1)
		..q:mzzsdr=""
		..i anDocAss="" d
		...//s anDocAss=$TR($P($G(^CTPCP(mzzsdr,1)),"^",2)," ","")
		...s anDocAss=##class(web.DHCANOPCom).GetNameById(mzzsdr)
		..e  d
		...//s anDocAss=anDocAss_" "_$TR($P($G(^CTPCP(mzzsdr,1)),"^",2)," ","")
		...s anDocAss=anDocAss_","_##class(web.DHCANOPCom).GetNameById(mzzsdr)
		.;i anDocAss'="" s mzdoc=mzdoc_","_anDocAss	;20170314+dyl
		.s mzNurseId=$P(^OR(adm,"ANA",chl),"^",8)
		.i mzNurseId'="" d
			..//s anNurse=$TR($P($G(^CTPCP(mzNurseId,1)),"^",2)," ","") 	;麻醉护士
			..s anNurse=##class(web.DHCANOPCom).GetNameById(mzNurseId)
		.e  s anNurse=""
		.;ANA_Method:麻醉方法+dyl+20120611
		.s anmethod=""
		.s anmthdr=$P(^OR(adm,"ANA",chl),"^",5)
		.s anmthdr=$tr(anmthdr,"|",",")
		.i anmthdr'="" d
			..s anmetNum=$l(anmthdr,",")
			..f i=1:1:anmetNum d
				...s anmetId=$p(anmthdr,",",i)
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
		.s prediag="",diamen="",OPLevelId="",mainOperDr=""
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
			..;q:i>1   ///ck091117
			..;20170630+dyl
			..s mainOperDr=$P(^OR(adm,"ANA",chl,"OP",1),"^",6)
			..s OPLevelId=$p($g(^OR(adm,"ANA",chl,"OP",1,"DHC")),"^",1)
			..
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
				    ....e  s bodsDesc=bodsDesc_","_bodsDesc2   
			..;;;
			..s opd=""
			..s docdr=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",8)      		;ANAOP_Surgeon_DR   手术医师
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
			..s operLocId=$P(^OR(adm,"ANA",chl,"OP",1),"^",10) 		;ANAOP_CTLOC_DR
		.i $g(^tmpAnop("Anop"))="Y" s ^tmpAnop("Anop",opaId,5)=userLocIdStr_"/"_operLocId_"/"_admLocId_"/"_appLocId
		.q:(("^"_userLocIdStr_"^")'[("^"_+operLocId_"^"))&(("^"_userLocIdStr_"^")'[("^"_+admLocId_"^"))&(("^"_userLocIdStr_"^")'[("^"_+appLocId_"^"))&(qFlag)  //ypz 070318
		.s ash=""
		.s assDocNum=4 //最多显示的助手人数
		.i $p($g(^DHCCLSet("AnOp","Ctcp")),"^",1)'="" s assDocNum=$p($g(^DHCCLSet("AnOp","Ctcp")),"^",1)
		.s p=0
		.s list=0,asName=""
		.s opaDocNote=$P(^DHCANOPArrange(opaId),"^",42) //手动填写OPA_OpDocNote（实习医生1;实习医生2...|主刀|一助|二助|三助|四助|五助...）
		.;s len=$l(opaDocNote,"|")	;这块暂时注释：具体需要再解开
		.;i (len>(assDocNum+2)) d
			.;.s len=assDocNum+2
		.s as=0 f  s as=$O(^OR(adm,"ANA",chl,"OP",sub,"ASS",as)) q:(as="")!(p'<assDocNum)  d
			..s asdr=$P(^OR(adm,"ANA",chl,"OP",sub,"ASS",as),"^",1)
			..s p=p+1
			..q:asdr=""
			..;s asName=asName_"^"_##class(web.DHCANOPCom).GetNameById(asdr)
			..i ash'="" s ash=ash_","_##class(web.DHCANOPCom).GetNameById(asdr)
			..e  s ash=##class(web.DHCANOPCom).GetNameById(asdr)
		.s p=0  ;洗手
		.s xs=0 f  s xs=$O(^OR(adm,"ANA",chl,"OP",sub,"SCN",xs)) q:(xs="")!(p=3)  d
			..q:xs>20
			..s xsdr=$P(^OR(adm,"ANA",chl,"OP",sub,"SCN",xs),"^",1)
			..q:xsdr=""
			..s p=p+1
			..//s xsh=xsh_" "_$TR($P(^CTPCP(xsdr,1),"^",2)," ","")  ;
			..;s xsh=xsh_","_##class(web.DHCANOPCom).GetNameById(xsdr)
			..;20161020+dyl
			..i xsh'="" s xsh=xsh_","_##class(web.DHCANOPCom).GetNameById(xsdr)
			..e  s xsh=##class(web.DHCANOPCom).GetNameById(xsdr)
		.s p=0  ;巡回
		.s xc=0 f  s xc=$O(^OR(adm,"ANA",chl,"OP",sub,"CIRN",xc)) q:(xc="")!(p=3)   d
			..q:xc>20
			..s xchdr=$P(^OR(adm,"ANA",chl,"OP",sub,"CIRN",xc),"^",1)
			..q:xchdr=""
			..s p=p+1
			..//s xch=$G(xch)_" "_$TR($P($G(^CTPCP(xchdr,1)),"^",2)," ","")  
			..;s xch=$G(xch)_","_##class(web.DHCANOPCom).GetNameById(xchdr) 
			..;20161020+dyl
			..i xch'="" s xch=$G(xch)_","_##class(web.DHCANOPCom).GetNameById(xchdr) 
			..e  s xch=##class(web.DHCANOPCom).GetNameById(xchdr) 
		.s scNurNote=$p($G(^DHCANOPArrange(opaId)),"^",51)		//OPA_ScrubNurseNote	器械护士备注 	
		.s cirNurNote=$p($G(^DHCANOPArrange(opaId)),"^",52)		//OPA_CirculNurseNote	巡回护士备注
		.s j=j+1
		.i ifOutOper="I" s opd=opd_","_$G(ash)  //UPDATE BY LYN 
		.;s opd=opd_","_$G(ash)
		.s sortOpRoomDesc=oproomdes
		.i oproomdes="" s oproomdes="无"
		.s sortOpaSeq=opordno
		.i opordno="" s opordno="未排" ;Do OutRow2
		.s NeedAnaesthetist=$p($G(^DHCANOPArrange(opaId)),"^",44)
		.q:(isNeedAn="Y")&(NeedAnaesthetist'="Y")
		.;s oprFloor=""
		.//i NeedAnaesthetist'="Y" s oprFloor="不需要"
		.//e  d
			.;.q:"D"[opaStatus
			.;.s para="M^149^麻醉会诊意见"
			.;.s eprRet=##class(EPRservice.BIL.BIToAN).IsOneGroupComplished(adm, 1, +$h, para)
			.;.i eprRet=0 s oprFloor="未写麻醉会诊意见! "
			.;.s para="M^151^麻醉知情同意书"
			.;.s eprRet=##class(EPRservice.BIL.BIToAN).IsOneGroupComplished(adm, 1, +$h, para)
			.;.i eprRet=0 s oprFloor=oprFloor_"未写麻醉知情同意书! "
			.;.q:"AR"[opaStatus
			.;.i "I"[opaStatus s oprFloor=oprFloor_"未完成麻醉记录单! "
			.;.e  d
				.;..s anoId=$o(^DHCANOrder(0,"OPApp",opaId,""))
				.;..i anoId="" s oprFloor=oprFloor_"未写麻醉记录单! "
			.;.q:"I"[opaStatus
			.;.s para="M^153^麻醉术后访视记录"
			.;.s eprRet=##class(EPRservice.BIL.BIToAN).IsOneGroupComplished(adm, 1, +$h, para)
			.;.i eprRet=0 s oprFloor=oprFloor_"未写麻醉术后访视记录! "
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
		.;20170630+dyl
		.;手术转运单
		.s transferFlag=0
		.s receviceFlag=##class(web.DHCANOPTransfer).ifInsertReceiveAss(adm)
    	.i receviceFlag=1 s transferFlag=1 //接病人护工报到确认
    	.s sendFlag=##class(web.DHCANOPTransfer).ifInsertSendAss(adm)
    	.i sendFlag=1 s transferFlag=2 //送病人护工报到确认
    	.;20170804 YL
		.s OPCategoryId=+OPLevelId,OPCategory=$p($g(^ORC("CATEG",+OPCategoryId)),"^",2)
		.i $g(^tmpAnop("Anop"))="Y" s ^tmpAnop("Anop",opaId,51)=OPLevelId
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
		.;20161214
		.;i estiOperDuration'="" s estiOperDuration=$ZT(estiOperDuration,2)
		.s preDiscussDate=$P($G(^DHCANOPArrange(opaId)),"^",38)
		.i preDiscussDate'="" s preDiscussDate=$ZD(preDiscussDate,dateformatnum)
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
		.i retReasonId'=""  s retReason=$p($g(^ORC("SUSP",retReasonId)),"^",2)   //+ ck091212 手术拒绝原因
		.e  s retReason=retReasonId
		.s anaDoctorOrd=$p($G(^DHCANOPArrange(opaId)),"^",48)     	//+ ck091212 麻醉医生收费状态
		.i anaDoctorOrd="Y"  s anaDoctorOrd="Y"
		.e  s anaDoctorOrd="N"
		.;i $g(^tmpAnop("Anop"))="Y" s ^tmpAnop("Anop",opaId,7)=paidType_"/"_anaDoctorOrd_"/"_LogUserType
		.q:(paidType="Y")&(LogUserType="ANDOCTOR")&(anaDoctorOrd="N") //ck 20100303修改
		.;q:(paidType="N")&(LogUserType="ANDOCTOR")&(anaDoctorOrd="Y")
		.s anaNurseOrd=$p($G(^DHCANOPArrange(opaId)),"^",49)      	//+ ck091212 麻醉护士收费状态
		.i anaNurseOrd="Y"  s anaNurseOrd="Y"
		.e  s anaNurseOrd="N"
		.q:(paidType="Y")&(LogUserType="ANNURSE")&(anaNurseOrd="N")    //ck 20100303修改
		.;q:(paidType="N")&(LogUserType="ANNURSE")&(anaNurseOrd="Y")
		.s opNurseOrd=$p($G(^DHCANOPArrange(opaId)),"^",50)       	//+ ck091212 手术护士收费状态
		.i opNurseOrd="Y"  s opNurseOrd="Y"
		.e  s opNurseOrd="N"
		.q:(paidType="Y")&(LogUserType="OPNURSE")&(opNurseOrd="N") //ck 20100303修改
		.;q:(paidType="N")&(LogUserType="OPNURSE")&(opNurseOrd="Y")
       	.;i $g(^tmpAnop("Anop"))="Y" s ^tmpAnop("Anop",opaId,8)=paidType_"/"_anaDoctorOrd_"/"_LogUserType
		.s tPacuBedId=$P($G(^DHCANOPArrange(opaId)),"^",47)		 	//OPA_PacuBed_Dr	麻醉恢复床
		.i tPacuBedId'="" s tPacuBed=$p(^DHCANC("OPRoom",tPacuBedId),"^",2)
		.e  s tPacuBed=""
		.s PACUInDate=$P($G(^DHCANOPArrange(opaId,"PACU")),"^",6) 	//OPA_PACUInDate	入恢复室日期
		.i PACUInDate'="" s PACUInDate=$zd(PACUInDate,dateformatnum)
		.s PACUInTime=$P($G(^DHCANOPArrange(opaId,"PACU")),"^",7) 	//OPA_PACUInTime	入恢复室时间
		.i PACUInTime'="" s PACUInTime=$zt(PACUInTime)
		.s PACUInDateTime=PACUInDate_" "_PACUInTime
		.i sortOpRoomDesc="" s sortOpRoomDesc=0
		.i sortOpaSeq<10 s sortOpaSeq=0_sortOpaSeq
		.s opaSeqNote=$P($G(^DHCANOPArrange(opaId)),"^",41)	//OPA_SeqNote
		.s appLocId=$P($G(^DHCANOPArrange(opaId)),"^",54)	//OPA_AppLoc_Dr
		.s appLocDesc=$P($G(^CTLOC(+appLocId)),"^",2)
		.s opUnPlanedOperation=$P(^DHCANOPArrange(opaId),"^",46)	//非计划重返
        .//s ^tmpYpz("app",opaId)=sortOpRoomDesc_"/"_sortOpaSeq_","_opaSeqNote_"/"_appLocDesc_","_surgeonDesc_"/"_opaId
        .s isUseSelfBlood=$P(^DHCANOPArrange(opaId),"^",34) //ADD mfc 20140101是否自体血回输并且添加输出参数isUseSelfBlood
		 ./************************start门诊手术排班信息*************************/
	    .s operResource="",selfReport="",queueNo="",operStock="",operStockNote=""
	    .s outFlag=##class(web.DHCANOPArrangeClinics).JudgeLocType(appLocId,"OUTOPDEPT^OUTOP^OUTAN")
	    .;i +outFlag'=0 s bodsDesc=$p($g(^OR(adm,"ANA",chl,"OP",1,"DHC")),"^",6)
	    .
	    .i +outFlag=0 d  ;门诊申请的手术
		    ..;获取主诉
			..s selfReport=""  ; OPA.Sequence (扩展字段) 序号
			..s retSe=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"OPA.SelfReport")
			..i retSe'="" s selfReport=$p(retSe,$c(3),1)
			..;获取手术资源 (暂时未使用)
			..s operResource="",resourceDesc="",asTimeRangeDr="",operResourceId=""  ; OPA.Sequence (扩展字段门诊手术预约资源)
			..s retOR=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"OPA.OperResource")
			..i retOR'="" s operResourceId=$p(retOR,$c(3),1)
			..i operResourceId'="" d
				...s reRowid=$p(operResourceId,"||",1)
				...s reSubId=$p(operResourceId,"||",2)
				...i reRowid'="" d
					....s resourceDesc=$p(^RB("RES",reRowid),"^",17) //资源描述
					....s asTimeRangeDr=$P($g(^RBAS(reRowid,reSubId,"DHC")),"^",17) //排班时段
					....s asTimeRangeDesc=$p($g(^DHCTimeRange(asTimeRangeDr)),"^",2) //排班时段描述
					....s operResource=resourceDesc_"  "_asTimeRangeDesc
			..
			..;获取号源信息 OPA.QueueNo (扩展字段门诊手术预约号)  (暂时未使用)
			..s queueNo=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"OPA.QueueNo")
			..s queueNo=$p(queueNo,$c(3),1)
			..;手术耗材 OPA.OperStock(扩展字段病人须知) 
			..s operStock=""
			..s retOS=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"OPA.OperStock")
			..s operStockIdStr=$p(retOS,$c(3),1)
			..i operStockIdStr'="" d
				...f i=1:1:$l(operStockIdStr,",") d
					....s operStId=$p(operStockIdStr,",",i)
					....q:'$d(^DHCANOPLOCStock(appLocId,operStId))
					....s ancDesc=$p($g(^DHCANOPLOCStock(appLocId,operStId)),"^",2)
					....i operStock="" s operStock=ancDesc
					....e  s operStock=operStock_","_ancDesc
			..;备用耗材备注 ;OPA.OperStockNote(扩展字段病人须知) 
			..s operStockNote=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"OPA.OperStockNote")
			..s operStockNote=$p(operStockNote,$c(3),1)
		./************************end门诊手术排班信息*************************/
		.s appCtcpId=$P(^DHCANOPArrange(opaId),"^",6), appDocDesc=""  //申请手术的人
		.i appCtcpId'="" s appDocDesc=##class(web.DHCANOPCom).GetNameById(appCtcpId)
		.s ASA=$p(##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"ASAClass"),$c(3),1)
		.s ^TMPAN("App",$j,sortOpRoomDesc,sortOpaSeq_","_opaSeqNote,appLocDesc_","_surgeonDesc,opaId)=$lb("d",status,jzstat,opdate,oproomdes,opordno,regNo,patName,sex,age,opdes,diag,opd,locdes,anmethod,mzdoc,xsh,xch,yy,opaId,adm,opdatestr,OpAppDateStr,opmem,isAddInstrument,instrument,patWard,anNurse,medCareNo,oproomdr,oprFloor,estiOperDuration,preDiscussDate,isExCirculation,bloodType,opDocNote,anDocNote,opSeqNote,anCompDesc,AnaesthesiaID,operPosition,OPCategory,operInstrument,NeedAnaesthetist,opsttime,mzsupdoc,retReason,anaDoctorOrd,anaNurseOrd,opNurseOrd,inPatNo,admreason,tPacuBed,PACUInDateTime,scNurNote,cirNurNote,anDocAss,bedCode,opUnPlanedOperation,mzdr,bodsDesc,PatientID,PAADMMainMRADMDR,isUseSelfBlood,secretCode,patLevel,secId,selfReport,operResource,queueNo,operStock,operStockNote,patTel,appCtcpId,appDocDesc,ASA,transferFlag,dayOperFlag)
}
	s sortOpRoomDesc="" f  s sortOpRoomDesc=$o(^TMPAN("App",$j,sortOpRoomDesc)) q:sortOpRoomDesc=""  d
	.s sortSeq="" f  s sortSeq=$o(^TMPAN("App",$j,sortOpRoomDesc,sortSeq)) q:sortSeq=""  d
	..s locDoc="" f  s locDoc=$o(^TMPAN("App",$j,sortOpRoomDesc,sortSeq,locDoc)) q:locDoc=""  d
	...s opaId="" f  s opaId=$o(^TMPAN("App",$j,sortOpRoomDesc,sortSeq,locDoc,opaId)) q:opaId=""  d
	....do OutRow2
	k ^TMPAN("App",$j)
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

/// w ##class(web.UDHCANOPArrange).updateopRecord("407","^3117^02/02/2010^08:00^3117^19068^5^ 备注:^5^^2^^^^^^100201115635000000000000000001^1","!^!","!^!","3117^^^0^1^N|^02/02/2010|08:00|02/02/2010|11:00","RegOp")
/// 目前已经停止使用，新版本从web.DHCANOPArrange走
ClassMethod updateopRecord(opaId As %String, str1 As %String, scr As %String, cir As %String, strward As %String, appType As %String = "") As %String
{
    //手术室填写
	//var str1=appLocId+"^"+appDocId+"^"+opaStartDate+"^"+opaStartTime+"^"+appUser+"^"+adm+"^"+oproomid+"^"+opmem+"^"+BloodRowId+"^"+ArrTime
	//str1=str1+"^"+ANCOPLRowId+"^"+PatHeight+"^"+PatWeight+"^"+preDiscussDate+"^"+estiOperDuration+"^"+opDocNote+"^"+opSeqNote+"^"+ordno+"^"+opaAppDate+"^"+opaAppTime
	//	申请科室ID^申请医师^手术日期^手术时间^登陆用户^病人就诊ID^手术间ID^手术要求^血型^安排时间^麻醉规模^身高^体重^术前讨论日期^预计手术时间^手术医师备注^手术编号^台次^申请日期(空)^申请时间(空)
	//var strward=appUser+"^"+opreq+"^"+note+"^"+chjb+"^"+ordno+"^"+isAddInstrument+"|"+instrumentId+"^"+optime;
	//	登陆用户^备注^注意事项^是否交班^台次^是否增加器材|器材ID^手术开始日期|开始时间|结束日期|结束时间
	n (opaId , str1 , scr , cir, strward,appType)
	s ^tmpYpz("upd")=str1
	q:+opaId=0 "手术排班号为空!"_opaId_"/"
	k PLIST
	s ArrTime=""
	i $p(str1,"^",10)'="" s ArrTime=##class(web.DHCANOPCom).ConvertToTimeH($p(str1,"^",10))
	&sql(select * into :PLIST() from SQLUSER.DHC_AN_OPArrange where opa_rowid=:opaId)
    s anaId=$P(^DHCANOPArrange(opaId),"^",2)
    if $P(strward,"^",7)'=""
    {
		s opdtstr=$P(strward,"^",7)
		s opstdate=##class(web.DHCANOPCom).ConvertToDateH($P(opdtstr,"|",1))
		s opsttime=##class(web.DHCANOPCom).ConvertToTimeH($P(opdtstr,"|",2))
		s openddate=##class(web.DHCANOPCom).ConvertToDateH($P(opdtstr,"|",3))
		s opendtime=##class(web.DHCANOPCom).ConvertToTimeH($P(opdtstr,"|",4))
		;20120514+dyl
		i opstdate>$h q "手术开始日期不能大于系统日期"
		e  i opstdate>openddate q "手术开始日期不能大于手术结束日期"
		e  i (opstdate=openddate)&(opsttime>opendtime) q "手术开始时间不能大于手术结束时间"
    }
    s PLIST(5)=$P(str1,"^",7)  			//OPA_OpRoom_Dr		手术间
    s PLIST(6)=$P(strward,"^",5) 		//OPA_Seq			台次
    ;20120605+dyl+同一天，同一台次，同一手术间
    s opstartdate=$p(str1,"^",3)
    ;s opstartdate=$zdh(opstartdate,4)
    s ret=..CheckArrData(opaId,$P(str1,"^",7),$P(strward,"^",5),opstartdate)
    i ret'=0 q "本手术间台次重复"_"/"_ret
	//s PLIST(12)=$P(str1,"^",2) 		//OPA_AppCtcp_Dr 申请医生
	s PLIST(16)=$P(strward,"^",1) 		//OPA_ArrangeUsr_Dr	安排用户
	s PLIST(17)=PLIST(7)     			//OPA_ArrangeDate	安排日期=OPA_StartDate	手术开始日期
	s PLIST(18)=ArrTime					//OPA_ArrangeTime	安排时间
	if appType'=""
	{
		//rem//if PLIST(7)="" s PLIST(7)=$G(opstdate)
		s PLIST(8)=$G(openddate)
		//rem//i $G(opsttime)'="" s PLIST(9)=$G(opsttime)
		//rem//e  s PLIST(9)=##class(web.DHCANOPCom).ConvertToTimeH($P(str1,"^",4))
		s PLIST(10)=$G(opendtime)
	}
	q:(appType="op")&(PLIST(20)'="")&("IPLF"[PLIST(20)) "病人手术状态不对，不能操作!"
	if appType="op"
	{   
		//s PLIST(13)=$P($H,",",1)  //wkz 071225
		//s PLIST(14)=$P($H,",",2)
		//s PLIST(7)=$P($H,",",1)
		s PLIST(9)=ArrTime
		s PLIST(17)=$P($H,",",1)
		s PLIST(18)=$P($H,",",2)
		s PLIST(20)="R"
	}
	if appType="RegOp"
	{
		q:PLIST(20)="D" "不能对已拒绝手术操作!"
		q:PLIST(20)="I" "不能对未结束手术操作!"
		q:PLIST(49)'="Y"&($P(^DHCANOPArrange(opaId),"^",44)="Y") "麻醉科未计费!" //OPA_AnaDoctorOrdered
		s PLIST(20)="F" //完成
		s PLIST(51)="Y" //OPA_OpNurseOrdered
	}
	if appType="RegNotApp"
	{
		s PLIST(20)="N" 	//非预约
	}
	//if (appType="")&($g(^DHCCLSet("AnOp","AuditArrange"))'="Y")&($G(^DHCCLSet("AnOp","Arrange"))'="AN")
	if ((appType="")!(appType="op"))&($g(^DHCCLSet("AnOp","AuditArrange"))'="Y")&($G(^DHCCLSet("AnOp","Arrange"))'="AN")&($P(str1,"^",7)'="")
	{
		s PLIST(20)="R" 	//安排
	}
	
	//if $P(strward,"^",8)'="" s PLIST(17)=$ZDH($P(strward,"^",8),4) ;arrangedate
	//if $P(strward,"^",9)'=""  s PLIST(18)=$ZTH($P(strward,"^",9))  //arrangetime
	s ^DHCANARRAGE("note",opaId)=$P(strward,"^",3)
	s ^DHCANARRAGE("opreq",opaId)=$P(strward,"^",2)
	s ^DHCANARRAGE("jb",opaId)=$P(strward,"^",4)
	s ^DHCANARRAGE("Pack",opaId)=$P(strward,"^",6) //手术包  已不用
	s PLIST(31)=$P($P(strward,"^",6),"|",2)
	s PLIST(32)=$P($P(strward,"^",6),"|",1)
	i PLIST(22)="G" s PLIST(22)="M"
	i PLIST(20)="F" s PLIST(22)="F"
	s PLIST(43)=$P(str1,"^",16)   	//OPA_OpDocNote			手术医师备注
	s PLIST(52)=$P(scr,"!",3)		//OPA_ScrubNurseNote	器械护士备注
	s PLIST(53)=$P(cir,"!",3)		//OPA_CirculNurseNote	巡回护士备注
	&sql(update SQLUSER.DHC_AN_OPArrange Values :PLIST() where opa_rowid=:opaId)
	q:SQLCODE'=0 "更新排班表出错!"
	//登记手术时间
	if (appType="RegOp")
	{
		if (opstdate'="")&(opsttime'="")&(openddate'="")&(opendtime'=""){
			&sql(update SQLUSER.OR_Anaesthesia set ANA_TheatreInDate=:opstdate,ANA_TheatreInTime=:opsttime,
			ANA_TheatreOutDate=:openddate,ANA_TheatreOutTime=:opendtime where ANA_RowId=:anaId)
		}
	}
	s EpisodeID=+anaId
    s anaSub=$p(anaId,"||",2)
    s anaopSub=0
    f  s anaopSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)) q:anaopSub=""  d
        .q:$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",12)'="M" 
        .i scr'="" d
            ..k ^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"SCN")
            ..s ^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"SCN",0)=100
            ..s scr1=$P(scr,"!",1)
            ..s num=$L(scr1,"^")
            ..for i=1:1:num d
	            ...q:$P(scr1,"^",i)=""
	            ...s ^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"SCN",i)=$P(scr1,"^",i)
            ..s scr2=$P(scr,"!",2)
            ..s num1=$L(scr2,"^")
            ..for i=1:1:num1 d
            ...q:$P(scr2,"^",i)=""
            ...s ^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"SCN",0)=200
            ...s ^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"SCN",20+i)=$P(scr2,"^",i)
        .i cir'="" d
            ..k ^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"CIRN")
            ..s ^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"CIRN",0)=100
            ..s cir1=$P(cir,"!",1)
            ..s num=$L(cir1,"^")
            ..for i=1:1:num d
            ...q:$P(cir1,"^",i)=""
            ...s ^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"CIRN",i)=$P(cir1,"^",i)
            ..s cir2=$P(cir,"!",2)
            ..s num1=$L(cir2,"^")
            ..for i=1:1:num1 d
            ...q:$P(cir2,"^",i)=""
            ...s ^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"CIRN",0)=200
            ...s ^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"CIRN",20+i)=$P(cir2,"^",i)

	   
	
	s UserID=%session.Data("LOGON.USERCODE")
   	//OpDate OperLoc OpRoom OrdNo PatName Dept PreDiag OpName Surgeon Ass AnDoc AnMethod  Infect  BloodType  Opmem OpTime  RegNo  MedcareNo
 	i opaId'="" d
 		.;是否感染
		.s OpDate="",OperLoc="",OpRoom="无",OrdNo="未排",PatName="",Dept="",PreDiag="",OpName=""
		.s Surgeon="",Ass="",AnDoc="",AnMethod="",Infect="",BloodType="未知",Opmem=""
		.s OpTime="",  RegNo="",  MedcareNo=""
	 	.s stat=$P(^DHCANOPArrange(opaId),"^",27) 
	 	.q:(stat'="R")&(stat'="D")
	 	.s yg=$P($g(^DHCANOPArrange(opaId,"PALab")),"^",29)	//OPA_PATestHBsAg  	免疫乙肝表面抗原
		.s bg=$P($g(^DHCANOPArrange(opaId,"PALab")),"^",34)	//OPA_PATestHCVAb 	免疫丙型肝炎抗体
		.s az=$P($g(^DHCANOPArrange(opaId,"PALab")),"^",35)	//OPA_PATestHivAb 	免疫艾滋病毒抗体
		.s md=$P($g(^DHCANOPArrange(opaId,"PALab")),"^",36)	//OPA_PATestTPAb 	免疫梅毒
		.s qt=$P($g(^DHCANOPArrange(opaId,"PALab")),"^",2)	//OPA_PATestOther	检其它阴阳性
		.i yg="阳性" s Infect=Infect_"乙肝阳性"_" "
		.i bg="阳性" s Infect=Infect_"丙肝阳性"_" "
		.i az="阳性" s Infect=Infect_"艾滋病阳性"_" "
		.i md="阳性" s Infect=Infect_"梅毒阳性"_" "
		.i qt="阳性" s Infect=Infect_"其他阳性"_" "
		.;;手术开始日期
		.s OpDate=$P(^DHCANOPArrange(opaId),"^",14)   
		.i OpDate'="" s OpDate=$ZD(OpDate,3)
		.s opsttime=$P(^DHCANOPArrange(opaId),"^",15)
		.i opsttime'=""  s OpTime=$ZT(opsttime,1)
		.;手术间
		.s oproomdr=$P(^DHCANOPArrange(opaId),"^",20)
		.i oproomdr'="" s OpRoom=$p($g(^DHCANC("OPRoom",oproomdr)),"^",2)
		.;手术台次
		.s opordno=$P(^DHCANOPArrange(opaId),"^",26)
		. s opordnoT=opordno
		.i +opordnoT=0 s opordnoT=""
		.e  s opordnoT=opordnoT-1
		.i opordnoT>0 s OrdNo="接台"_opordno
	 	.i opordno=1 s OrdNo="首台"
	 	.;手术要求
	 	.s Opmem=$P(^DHCANOPArrange(opaId),"^",19)  
	 	.;血型
		.s BldTypId=$P(^DHCANOPArrange(opaId),"^",11)
		.i BldTypId'="" s BloodType=$P($G(^PAC("BLDT",BldTypId)),"^",2)
	 	.;病人姓名
	 	.s opaAdmDr=$P(^DHCANOPArrange(opaId),"^",1)   ;就诊号
		.s papmiId=$p($g(^PAADM(opaAdmDr)),"^",1)
		.s paadmtype=$p($g(^PAADM(opaAdmDr)),"^",2)
	 	.s PatName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	 	.;;病案号
	 	.;s MedcareNo=##Class(web.DHCWMRService).IGetMrNoByEpisodeID(opaAdmDr , .ErrMsg)
	    .s MedcareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(opaAdmDr,paadmtype,.ErrMsg)
	 	.;登记号	
	 	.s RegNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)	
	 	.;病人所在科室/病区
	 	.s opaPatDeptDr=$P(^PAADM(opaAdmDr),"^",4)
	 	.s patLoc=$p($P($g(^CTLOC(opaPatDeptDr)),"^",2),"-",2)
	 	.s curWardId=$p($g(^PAADM(opaAdmDr)),"^",70)  
   		.i curWardId'="" s WardDes=$P(^PAWARD(curWardId),"^",1)
		.s Dept=patLoc
		.;_"/"_WardDes
		.s chl=$P($P(^DHCANOPArrange(opaId),"^",2),"||",2)
		.;麻醉医生
		.s anadr=$P(^OR(opaAdmDr,"ANA",anaSub),"^",6)
		.i anadr'="" d
			..s AnDoc=$p($g(^CTPCP(+anadr,1)),"^",2)
		 .s anmthdr=$P(^OR(opaAdmDr,"ANA",anaSub),"^",5) ;/麻醉方法相关
		.;麻醉方法
		.i anmthdr'="" d
			..s anmetNum=$l(anmthdr,"|")
			..f i=1:1:anmetNum d
				...s anmetId=$p(anmthdr,"|",i)
				...q:anmetId=""
				...s anmetDesc=$p($g(^ORC("ANMET",anmetId)),"^",2) ;麻醉方法描述
				...i $P(anmetDesc,"-",2)'="" s anmetDesc=$P(anmetDesc,"-",2)
				...i AnMethod="" s AnMethod=anmetDesc
				...e  s AnMethod=AnMethod_"^"_anmetDesc
		.;术前诊断
	 	.s subchl=0 f  s subchl=$O(^OR(opaAdmDr,"ANA",chl,"OP",subchl)) q:(subchl="")  d 
			..s predigdr=$P(^OR(opaAdmDr,"ANA",chl,"OP",subchl),"^",4) 
			..i predigdr'=""  d
				...s anaOPPreopDiag=$P(^MRC("ID",predigdr),"^",2)
				...s PreDiag=$G(anaOPPreopDiag)
			..e  d
				...i $g(^OR(opaAdmDr,"ANA",chl,"TXT",2))'="" d 
					....s diamen=^OR(opaAdmDr,"ANA",chl,"TXT",2) 
					....s PreDiag=$G(diamen)
			..;shoushushi
			..s operLocId=$P(^OR(opaAdmDr,"ANA",chl,"OP",subchl),"^",10) 
			..i operLocId'="" s OperLoc=$p($p($g(^CTLOC(operLocId)),"^",2),"-",2)
			..;手术医生
			..s docdr=$P(^OR(opaAdmDr,"ANA",chl,"OP",subchl),"^",8)
			..i docdr'="" d
				...s Surgeon=$p($g(^CTPCP(+docdr,1)),"^",2)
			..;手术名称
			..s opdr=$P(^OR(opaAdmDr,"ANA",chl,"OP",subchl),"^",6)
			..q:opdr=""
			..if $D(^ORC("OPER",opdr)) d
				...i OpName="" s OpName=$P(^ORC("OPER",opdr),"^",2)
				...e  s OpName=$G(OpName)_"^"_$P(^ORC("OPER",opdr),"^",2)
			..;手术助手
			..s as=0,p=0 f  s as=$O(^OR(opaAdmDr,"ANA",chl,"OP",subchl,"ASS",as)) q:(as="")  d
				...s asdr=$P(^OR(opaAdmDr,"ANA",chl,"OP",subchl,"ASS",as),"^",1)
				...q:asdr=""
				...s p=p+1
				...i Ass'="" s Ass=Ass_" "_$p($g(^CTPCP(+asdr,1)),"^",2)
				...e  s Ass=$p($g(^CTPCP(+asdr,1)),"^",2)	
 		.s str="{"_"'OpDate'"_":"_"'"_OpDate_"'"_","_"'"_"OperLoc"_"'"_":"_"'"_OperLoc_"'"_","_"'"_"OpRoom"_"'"_":"_"'"_OpRoom_"'"_","_"'"_"OrdNo"_"'"_":"_"'"_OrdNo_"'"_","_"'"_"PatName"_"'"_":"_"'"_PatName
 		.s str=str_"'"_","_"'"_"Dept"_"'"_":"_"'"_Dept_"'"_","_"'"_"PreDiag"_"'"_":"_"'"_PreDiag_"'"_","_"'"_"OpName"_"'"_":"_"'"_OpName_"'"_","_"'"_"Surgeon"_"'"_":"_"'"_Surgeon_"'"_","_"'"_"Ass"_"'"_":"_"'"_Ass
 		.s str=str_"'"_","_"'"_"AnDoc"_"'"_":"_"'"_AnDoc_"'"_","_"'"_"AnMethod"_"'"_":"_"'"_AnMethod_"'"_","_"'"_"Infect"_"'"_":"_"'"_Infect_"'"_","_"'"_"BloodType"_"'"_":"_"'"_BloodType_"'"_","_"'"_"Opmem"_"'"_":"_"'"_Opmem
 		.s str=str_"'"_","_"'"_"OpTime"_"'"_":"_"'"_OpTime_"'"_","_"'"_"RegNo"_"'"_":"_"'"_RegNo_"'"_","_"'"_"MedcareNo"_"'"_":"_"'"_MedcareNo_"'"_"}"
 		.s rstr=UserID_"^"_OpName_"^"_1_"^"_OpDate_"^"_""_"^"_str_"^"_"Operation"_"^"_0
 		.s OAret=..InsertOAM("C02.01.02",rstr)
 		.s ^DHCXPTest("AnOP1","U")=rstr

 q "0"
 //OR_An_Oper_Anaest_Assistant
}

ClassMethod UpdateSeq(str As %String) As %String
{
	if str="" q " "
	s num=$L(str,"^")
	s n=0
	f i=1:1:num
	{
		s opaId=$P(str,"^",i)
		q:opaId=""
		s n=n+1
		&sql(update SQLUSER.DHC_AN_OPArrange set opa_seq=:n where opa_rowid=:opaId)
	    
	}
	q "操作成功!"
}

ClassMethod updatewardRecord(itmjs As %Library.String = "", itmjsex As %Library.String = "", opaId As %String, str1 As %String, op As %String, ass As %String, strcheck As %String, anmetId As %String = "", apptype As %String = "") As %String
{
	
   //病区填写
	;k (str1,anmthid,andocid,op,ass,scr,cir)
	s userId=%session.Data("LOGON.USERID")
	s ctcpId=$p($g(^SSU("SSUSR",userId)),"^",14)
	s ctcptId=$P($g(^CTPCP(ctcpId,1)),"^",4)
	s ctcptType=$p(^CT("CPT",ctcptId),"^",4)
	s locId=$p($g(^DHCANOPArrange(opaId)),"^",54) 
	s docLocId=%session.Data("LOGON.CTLOCID")
	s linkLocId=##Class(web.DHCClinicCom).GetLinkLocId(docLocId)
    s userLocIdStr=linkLocId_"^"_docLocId

	q:(userLocIdStr'[locId)&(ctcptType="DOCTOR") "医生不能修改非本科室手术" 
	;20160908+dyl
	s opaStatus=$P(^DHCANOPArrange(opaId),"^",27)
	;q:(opaStatus'="A")&(apptype="Ward") "手术状态已更新,请刷新界面"
	k PLIST
	//s strcheck="阴性^阴性^阴性^阴性^0^阴性"
	&sql(select * into :PLIST() from SQLUSER.DHC_AN_OPArrange where opa_rowid=:opaId)
	i SQLCODE  q "未找到手术申请记录!"
	//web.UDHCANOPArrange.insertAnRecord
	//var str1=apploc+"^"+appdoc+"^"+appDate+"^"+appTime+"^"+appUser+"^"+adm+"^"+oproomid;
	;s OPDate=$ZDH($P(str1,"^",3),4)
	s OPDate=##class(web.DHCANOPCom).ConvertToDateH($P(str1,"^",3))
	s AppDate=PLIST(13)
	i OPDate<AppDate q "手术日期不能小于申请日期!"
		
	TSTART
    s anaId=$P(^DHCANOPArrange(opaId),"^",2)
    s opdate=$P(^DHCANOPArrange(opaId),"^",14)
	s PLIST(7)=##class(web.DHCANOPCom).ConvertToDateH($P(str1,"^",3)) // starD
	i (PLIST(7)<$h)&(opaStatus="A")  TRollBack  q "手术日期不能早于系统日期!"	//20160908+dyl
	s PLIST(9)=##class(web.DHCANOPCom).ConvertToTimeH($P(str1,"^",4),"") //手术申请时间不填写
	s PLIST(5)=$P(str1,"^",7)  								//OPA_OpRoom_dr	如维护手术间默认使用科室,申请时自动填入手术间
	//s PLIST(12)=$P(str1,"^",2) 								//OPA_AppCtcp_Dr 申请医生
	//s PLIST(3)=$P(str1,"^",1)  							//ypz 070530 病人科室不变,便于统计
	s PLIST(19)=$P(str1,"^",8) 								//OPA_Memo		备注-手术要求
	s groupId=%session.Data("LOGON.GROUPID")				//科主任审核
	
	
	i PLIST(20)="" d
		.i $G(^DHCCLSet("AnOp","DirAudit"))'="" d
			..i $G(^DHCCLSet("AnOp","DirAudit"))[groupId d
				...s PLIST(20)="A"
		.e  d
			..s applyctcpId=$P($g(^DHCANOPArrange(opaId)),"^",6)
			..i applyctcpId'="" d
				...s ctcpt2Id=$p($g(^CTPCP(applyctcpId,1)),"^",4)
				...i ctcpt2Id'="" d
					....s ctcpt2Type=$p($g(^CT("CPT",ctcpt2Id)),"^",1)
					....i ctcpt2Type="PRACTICE" d
						.....s CurctcptType=$p(^CT("CPT",ctcptId),"^",1)  
						.....i CurctcptType'="PRACTICE" s PLIST(20)="A"
    s adm=$P(str1,"^",6)                                    //WKZ 071226 S 	血型更新
	s BldTyId=$P(str1,"^",9)
	s PLIST(28)=$P(strcheck,"^",7)							//OPA_RHBloodType	RH血型							
	s PLIST(29)=$P(strcheck,"^",8)							//OPA_Isolated		是否隔离
	s PLIST(34)=$P(strcheck,"^",9)							//OPA_PrepareBlood	是否备血
	s PLIST(35)=$P(strcheck,"^",10)							//OPA_UseSelfBlood	是否自体血回输
	s PLIST(37)=$P(strcheck,"^",11)							//OPA_ExCirculation	是否体外循环
	s PLIST(45)=$P(strcheck,"^",12)  						//OPA_NeedAnaesthetist是否麻醉会诊
	s PLIST(24)=$P(strcheck,"^",13) 						//OPA_MiniInvasive	是否微创手术
	s PLIST(56)=$p(strcheck,"^",14)                         //OPA_Navigation 是否导航 zhangtao 2010.8.6
	s PLIST(285)=$p(strcheck,"^",15)
	s PLIST(27)=BldTyId										//OPA_BloodType_Dr	血型
	s PLIST(193)=$P(strcheck,"^",1)							//OPA_PATestHBsAg 	免疫乙肝表面抗原
	s PLIST(198)=$P(strcheck,"^",2)							//OPA_PATestHCVAb 	免疫丙型肝炎抗体
	s PLIST(199)=$P(strcheck,"^",3)							//OPA_PATestHivAb 	免疫艾滋病毒抗体
	s PLIST(200)=$P(strcheck,"^",4)							//OPA_PATestTPAb 	免疫梅毒
	s PLIST(166)=$P(strcheck,"^",6)							//OPA_PATestOther 	检验其它阴阳性
	s PLIST(21)=$P(str1,"^",11)								//OPA_OPLevel_Dr	麻醉规模
	s PLIST(25)=$P(str1,"^",12)								//OPA_PatHeight		身高
	s PLIST(26)=$P(str1,"^",13)								//OPA_PatWeight		体重
	;20161214+dyl
	;s PLIST(38)=##class(web.DHCANOPCom).ConvertToTimeH($P(str1,"^",15),"") //OPA_EstiOperDuration
	s PLIST(38)=$P(str1,"^",15)
	s PLIST(39)=##class(web.DHCANOPCom).ConvertToDateH($P(str1,"^",14),"") //OPA_PreDiscussDate
	s PLIST(43)=$P(str1,"^",16)   							//OPA_OpDocNote 实习医生,手术医师备注
	s PLIST(42)=$P(str1,"^",17)   							//OPA_SeqNote	手术编号,医生手术申请编号
	s PLIST(6)=$P(str1,"^",18) 								//OPA_Seq		台次
	s PLIST(54)=$P(str1,"^",21)							    //OPA_MedInfect 院感
	s PLIST(40)=$P(str1,"^",22)                             //OPA_TransferMeans 接病人方式
	;20160908+dyl：统一用|
	s anmetId=$tr(anmetId,",","|")
	i PLIST(20)="A" s PLIST(149)=anmetId                    //OPA_PAAnaestType 拟施麻醉方式
	s PLIST(47)=$P(strcheck,"^",17)		//勿动20160114					
	if PLIST(7)>opdate s PLIST(20)="A"
	;可以去掉
	;增加&(PLIST(13)=+$h)  update by lyn 标准版bug修正 2010928
	i (PLIST(7)=+$h)&($P(strcheck,"^",5)'=1)&(PLIST(20)="A")&(PLIST(13)=+$h) TRollBack  q "非急诊手术日期不能是当前系统日期!"
	//s ^DHCANARRAGE("ch",opaId)=strcheck					//检验值已存入DHC_AN_OPArrange
	i PLIST(22)="G" s PLIST(22)="M"
	&sql(update SQLUSER.DHC_AN_OPArrange Values :PLIST() where opa_rowid=:opaId)
	i SQLCODE TRollBack  q "修改手术申请错误!"
	//-----
	///091204 ck
	s anaNotesList=$lb("")
	s anaNotesList=$lb($p(op,"^",4))
	s SourceType=$P(strcheck,"^",5)							//ANA_SourceType 急诊(E)/择期(B)	
	i SourceType=1  s anaSourceType="E"
	e  s anaSourceType="B"
	s opstdate=##class(web.DHCANOPCom).ConvertToDateH($P(str1,"^",3))		//ANA_TheatreInDate	手术开始日期
	s opstTime=##class(web.DHCANOPCom).ConvertToTimeH($P(str1,"^",4),"")	//ANA_TheatreInTime	手术开始时间
	&sql(update SQLUSER.OR_Anaesthesia set ANA_Notes=:anaNotesList,ANA_SourceType=:anaSourceType,ANA_TheatreInDate=:opstdate,ANA_TheatreInTime=:opstTime where ANA_RowId=:anaId)
	i SQLCODE'=0 TRollBack  q "修改诊断备注或急诊手术错误!" 
	;i anmetId'="" &sql(update SQLUSER.OR_Anaesthesia set ANA_Method=:anmetId where ANA_RowId=:anaId)
	;i SQLCODE'=0 TRollBack  q "修改麻醉方式错误!" //ypz 070405 外科医生填写麻醉方式 
	//保存多个麻醉方法
	s adm=$p(anaId,"||",1)
	s anachl=$p(anaId,"||",2)
	i anmetId'="" s $P(^OR(adm,"ANA",anachl),"^",5)=anmetId 
	
	s adm=$P(anaId,"||",1)
	s anaSub=$P(anaId,"||",2)
	s anaopSub=0  s anaopSub=$O(^OR(adm,"ANA",anaSub,"OP",anaopSub)) 
	i anaopSub="" TRollBack  q "未找到病人的手术定义!"
	s anaopId=anaId_"||"_anaopSub
	k PLIST //op=opid+"^"+diagid+"^"+opdocid+"^"+diagmem+"^"+operLoction
	&sql(select * into :PLIST() from SQLUSER.OR_Anaest_Operation where anaop_rowid=:anaopId)
	i SQLCODE TRollBack  q "手术记录查找错误!"
	s PLIST(6)=""
	s PLIST(7)=""
	s diagIdS=$p($P(op,"^",2),"|",1)
	s diagIdS=$tr(diagIdS,",","$") //主要为了兼容以前的程序，以前是以"$"分隔的，现在前台以","分隔，故替换
	s preDiagIdS=$p(diagIdS,"/",1)
	s postDiagId=$p(diagIdS,"/",2)
    i $l(diagIdS,"/")=1  d
		.i diagIdS'=""  d    //术前诊断Id
			..i diagIdS=+diagIdS s PLIST(6)=$p($P(op,"^",2),"|",1)
			..e  s PLIST(6)=""
		.s PLIST(7)=""
	i $l(diagIdS,"/")=2  d
		.i preDiagIdS'=""  d
			..i preDiagIdS=+preDiagIdS s PLIST(6)=preDiagIdS
			..e  s PLIST(6)=""
		.e  s PLIST(6)=""

	i postDiagId'=""  d      //术后诊断ID
		.i postDiagId=+postDiagId s PLIST(7)=postDiagId
		.e  s PLIST(7)=""
	
	
	q:($p($P(op,"^",1),"|",1)="")&($p($P(op,"^",1),"|",3)="") "手术名称或手术备注为空!"
	i $p($p(op,"^",1),"|",1)'="" d
	;s PLIST(9)=$p($p(op,"^",1),"|",1)
	i $p($p(op,"^",1),"|",1)'=(+$p($p(op,"^",1),"|",1)) d
	.s PLIST(9)="" //20101029 zhangtao
	e  s PLIST(9)=$p($P(op,"^",1),"|",1)
	s PLIST(8)=$lb($p($p(op,"^",1),"|",3))	//手术分类
	s bldtpCode=$p($p(op,"^",1),"|",4)		//手术刀口类型 ANAOP_Blade_DR->ORC_BladeType
	s bldtpId=""
	i bldtpCode'="" d
		.i bldtpCode=+bldtpCode s bldtpId=bldtpCode q
		.s bldtpCode=$$ALPHAUP^SSUTIL4(bldtpCode)
		.q:bldtpCode=""
		.s bldtpId=$o(^ORC("BLDTP",0,"Code",bldtpCode,""))
	s PLIST(12)=bldtpId
	
	s PLIST(11)=$p($P(op,"^",1),"|",7)	//20180118:主刀医师
	s ctlocDesc=$$ALPHAUP^SSUTIL4($P(op,"^",5)),ctlocId="" //ypz 070316
	i ctlocDesc'="" s ctlocId=$o(^CTLOC(0,"Desc",ctlocDesc,"")) //ypz 070316
	i $P(op,"^",5)=+$P(op,"^",5) s ctlocId=$P(op,"^",5)  //ypz 091118
	s PLIST(13)=ctlocId  //ypz 070316：转出科室	
	//s PLIST(42)=$P(op,"^",6)  //ypz 070418 bodySite//100129现直接保存于Global中
	//s PLIST(0)=anaId
 	//&sql(insert into sqluser.OR_Anaest_Operation Values :PLIST())
 	s PLIST(27)=""					//现ANAOP_AreaInTime与ANAOP_BodySite_DR同一节点
 	s PLIST(42)=""					//ANAOP_AreaInTime暂不使用,ANAOP_BodySite_DR含|不直接保存
 	&sql(update sqluser.OR_Anaest_Operation Values :PLIST() where anaop_rowid=:anaopId)
 	//w "oper update="_SQLCODE,!
    i SQLCODE'=0 TRollBack  q "修改手术信息错误!"
	;s ^OR(adm,"ANA",anaSub,"OP",anaopSub,"REM",0)=1
	;s ^OR(adm,"ANA",anaSub,"OP",anaopSub,"REM",1)=$P(op,"^",4)
	//保存多个手术部位于Global中
	i $p($p(op,"^",1),"|",1)'=(+$p($p(op,"^",1),"|",1)) d
		.s ^OR(adm,"ANA",anaSub,"OP",anaopSub,"REM",0)=2
		.;s ^OR(adm,"ANA",anaSub,"OP",anaopSub,"REM",1)=$lb($p($p(op,"^",1),"|",3))
		.s ^OR(adm,"ANA",anaSub,"OP",anaopSub,"REM",2)=$p($p(op,"^",1),"|",1)
	s ^OR(adm,"ANA",anaSub,"TXT",0)=3                  //zhangtao add
    s preDiagS="",preDiagN=""                                          
	i $l(diagIdS,"/")=1  d
		.i diagIdS'=""  d    //术前诊断Id
			..s dNum=$l(diagIdS,"$")
			..f i=1:1:dNum d
				...s diagId=$p(diagIdS,"$",i)
				...q:diagId=""
				...i diagId=+diagId s $p(preDiagS,"|",i)=diagId
				...e  d
				....s $p(preDiagS,"|",i)=""
				....s $p(preDiagN,"|",i)=diagId
	i $l(diagIdS,"/")=2  d
		.i preDiagIdS'=""  d
		..s dNum=$l(preDiagIdS,"$")
		..f i=1:1:dNum d
		...s preDiagId=$p(preDiagIdS,"$",i)
		...i preDiagId=+preDiagId s $p(preDiagS,"|",i)=preDiagId
		...e  d 
		....s $p(preDiagS,"|",i)=""    
		....s $p(preDiagN,"|",i)=preDiagId
		.i postDiagId'=""  d      //术后诊断ID
		..i postDiagId'=+postDiagId s ^OR(adm,"ANA",anaSub,"TXT",3)=postDiagId
	s $p(^OR(adm,"ANA",anaSub,"OP",anaopSub),"^",4)=preDiagS  
	s ^OR(adm,"ANA",anaSub,"TXT",2)=preDiagN   //zhangtao add
	
	s preDiagNote=$p($P(op,"^",2),"|",2)	;诊断备注
	s ^OR(adm,"ANA",anaSub,"TXT",1)=preDiagNote

	s bodySiteId=$P(op,"^",6)
	s bodsDesc="" //liangq 20101105
	i bodySiteId'="" d
	.s $p(^OR(adm,"ANA",anaSub,"OP",anaopSub),"^",24)=bodySiteId
	.s bodsIdNum=$l(bodySiteId,"|")
	.f i=1:1:bodsIdNum d
	..s curBodsId=$p(bodySiteId,"|",i)
	..q:curBodsId=""
	..i bodsDesc="" s bodsDesc=$p($g(^OEC("BODS",+curBodsId)),"^",2)
	..e  s bodsDesc=bodsDesc_","_$p($g(^OEC("BODS",+curBodsId)),"^",2)

	s ancoplCode=$p($p(op,"^",1),"|",2)								//+wxl 091215 保存手术级别->ORC_OperationCategay 
	s ancoplId=""
	i ancoplCode'="" d
	.i ancoplCode=+ancoplCode s ancoplId=ancoplCode q
	.s ancoplCode=$$ALPHAUP^SSUTIL4(ancoplCode)
	.///s ancoplId=$o(^DHCANC("OPLevel",0,"Code",ancoplCode,""))
	.s ancoplId=$o(^ORC("CATEG",0,"Code",ancoplCode,"")) 			//update by lyn 20160811
	s $p(^OR(adm,"ANA",anaSub,"OP",anaopSub,"DHC"),"^",1)=ancoplId	//+wxl 091215 
		//术者科室20180118
	s doclocId=$p($p(op,"^",1),"|",6)
	s $p(^OR(adm,"ANA",anaSub,"OP",anaopSub,"DHC"),"^",7)=doclocId
	i $d(^OR(adm,"ANA",anaSub,"OP",1,"ASS"))>0 k ^OR(adm,"ANA",anaSub,"OP",1,"ASS")  //&sql(delete from sqluser.OR_An_Oper_Assistant where opas_parref=:anaopId)
 	//w "oper asst="_SQLCODE,!

	s operPositionId=$P(op,"^",7)
	i operPositionId'="" d
	.s PLIST(0)=anaopId
	.s PLIST(3)=operPositionId
    .i $D(^OR($P(anaopId,"||"),"ANA",$P(anaopId,"||",2),"OP",$P(anaopId,"||",3),"POS"))'=0 d
    ..s opRowId=anaopId_"||"_1
    ..&sql(update sqluser.OR_An_Oper_Position set OPPOS_Position_DR=:operPositionId where OPPOS_RowId=:opRowId)
	.e  &sql(INSERT INTO sqluser.OR_An_Oper_Position Values :PLIST())
	i SQLCODE'=0 TRollBack  q "插入体位表错误!"
	;20170627+dyl
	s SendMessage=$g(^DHCCLSet("AnOp","SendMessage"))
	i SendMessage="Y" d
		.//修改手术申请向平台发送消息
		.s OAret=##class(web.DHCENS.EnsHISService).DHCHisInterface("SENDOPERATIONAPPLYINFO",opaId)
	//20180119
    s EpisodeID=+anaId
    s anaSub=$p(anaId,"||",2)
    s anaopSub=0
    s ass=""
	s ass1=$p($p(op,"^",1),"|",8)
	s ass2=$p($p(op,"^",1),"|",9)
	s ass3=$p($p(op,"^",1),"|",10)
	s asso=$p($p(op,"^",1),"|",11)
	s asso=$tr(asso,",","^")
	s ass=ass1_"^"_ass2_"^"_ass3_"^"_asso
	s assnum=0
    f  s anaopSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)) q:anaopSub=""  d
        .q:$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",12)'="M" 
        .q:ass=""
        .s num=$L(ass,"^")
        .//s ^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ASS",0)=num
        .for i=1:1:num d
            ..i $p(ass,"^",i)'=""  d
            ...s assnum=assnum+1
            ...s ^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ASS",i)=$P(ass,"^",i)
            ..e  d
            ...s ^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ASS",i)=""
        .s ^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ASS",0)=assnum
	s arcimId=$g(^DHCCLSet("AnOp","AppArcimId"))  	
	s retInsord = ..SaveAnopAppOrdItem(arcimId,opaId,$p(str1,"^",5),"ward",0,1)
   	i retInsord'=0 TRollBack  q "-10000^修改医嘱^"_retInsord

	s subOperStr=$p(op,"^",8)
	s otherOperStatus=..insertchlop("","",anaId,subOperStr,apptype)

	//s retval=itmjs_"('"_$ZCVT(anaId,"O","JS")_"');"
    //i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(anaId,"O","JS")_"');"
    //&javascript<#(retval)#>
 	TCommit

 q 0
 //OR_An_Oper_Anaest_Assistant
}

// 不再使用，新版本从web.DHCANOPArrange走

ClassMethod updateanRecord(opaId As %String, anmthid As %String, andocid As %String, anaNurseId As %String, ancpt As %String, ansupervisor As %String = "", anDocNote As %String = "", ANCOPLRowId As %String = "") As %String
{
   	//麻醉科填写
	;k (str1,anmthid,andocid,op,ass,scr,cir) //andocid1+"^"+jbandocid+"^"+jbandocid1
	k PLIST
    s anaId=$P(^DHCANOPArrange(opaId),"^",2)
    i ($G(^DHCCLSet("AnOp","Arrange"))="AN")&("FILP"'[$P(^DHCANOPArrange(opaId),"^",27)) d
    .&sql(update SQLUSER.DHC_AN_OPArrange set OPA_Status='R' where opa_rowid=:opaId)
   	&sql(update SQLUSER.DHC_AN_OPArrange set OPA_AnDocNote=:anDocNote,OPA_OPLevel_Dr=:ANCOPLRowId where opa_rowid=:opaId)
   	i SQLCODE'=0 q "更新手术申请表出错!"
   	//s ^DHCANARRAGE("jbanadoc",opaId)=jbandocid
   	&sql(select * into :PLIST() from sqluser.OR_Anaesthesia where ana_rowid=:anaId)
    //s PLIST(6)=anmthid 					//anmth
	s PLIST(7)=andocid 						//ANA_Anaesthetist_DR	麻醉主治医师
	////s PLIST(8)=$P(ancpt,"^",1) 			//ANA_Supervisor_DR 	麻醉助手 8
	////s PLIST(9)=$P(ancpt,"^",2)  		//ANA_ORAnaNurse_DR  	交班麻醉师9
	////s PLIST(10)=$P(ancpt,"^",3) 		//ANA_PACUAnaNurse_DR 	副交班麻醉10
	s PLIST(32)=$P($G(ancpt),"!",3) 		//ANA_ASA_DR   WKZ 071224
	//&sql(update sqluser.OR_Anaesthesia Values :PLIST() where ana_rowid=:anaId)
	////&sql(update sqluser.OR_Anaesthesia set ana_method=:anmthid,ana_anaesthetist_dr=:andocid, 
	////ANA_Supervisor_DR=:PLIST(8),ANA_ORAnaNurse_DR=:PLIST(9),ANA_PACUAnaNurse_DR=:PLIST(10),
	////ANA_ASA_DR=:PLIST(32) where ana_rowid=:anaId)
	&sql(update sqluser.OR_Anaesthesia set ana_anaesthetist_dr=:andocid,ANA_ORAnaNurse_DR=:anaNurseId,
	ANA_ASA_DR=:PLIST(32),ana_Supervisor_DR=:ansupervisor where ana_rowid=:anaId)
	i SQLCODE'=0 q 6
    s EpisodeID=+anaId
    s anaSub=$p(anaId,"||",2)
    ;20160908+dyl
    s anmthid=$tr(anmthid,",","|")
    //保存多个麻醉方法
	i anmthid'="" s $P(^OR(EpisodeID,"ANA",anaSub),"^",5)=anmthid 
    s anaopSub=0
    f  s anaopSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)) q:anaopSub=""  d
        .q:$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",12)'="M"
        .k ^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ANASS")
        .s ^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ANASS",0)=100
        .s andocid=$P($G(ancpt),"!",1)		//麻醉助手或其它麻醉医师,小于20				
        .s jbandocid=$P($G(ancpt),"!",2)	//交麻醉医师,大于20
        .f i=1:1:$L(andocid,"^")  d
        ..q:$P(andocid,"^",i)=""
        ..s ^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ANASS",i)=$P(andocid,"^",i)
        .f i=1:1:$L(jbandocid,"^")  d
        ..q:$P(jbandocid,"^",i)=""
        ..s ^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ANASS",0)=200
        ..s ^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ANASS",20+i)=$P(jbandocid,"^",i)
        
  
 q "0"
 //OR_An_Oper_Anaest_Assistant
}

ClassMethod insertchlop(itmjs As %Library.String = "", itmjsex As %Library.String = "", anaId, opstr, appType = "") As %String
{
	s opstr=$tr(opstr,"#","^")
	s err=0
	s ifAll="Y"
	s attAnaopStr=""
	s adm=$P(anaId,"||",1)
	s chl=$P(anaId,"||",2)
	s num=$L(opstr,"^")
	s anaopSubStr="|"
	f i=1:1:num d
		.q:($p($p(opstr,"^",i),"|",1)="")&($p($p(opstr,"^",i),"|",3)="") //手术ID且手术名为空退出
		.s anaopSubStr=anaopSubStr_$p($p(opstr,"^",i),"|",5)
	    .i anaopSubStr'="|" s anaopSubStr=anaopSubStr_"|"
	s i=0
	s subchl=0 f  s subchl=$O(^OR(adm,"ANA",chl,"OP",subchl)) q:subchl=""  d
		.q:(anaopSubStr)[("|"_subchl_"|")
		.s oprowid=adm_"||"_chl_"||"_subchl
		.s i=i+1
		.if i'=1 d
			..&sql(delete from SQLUSER.OR_Anaest_Operation where anaop_rowid=:oprowid)
			..i SQLCODE'=0  s err="操作失败!"
	q:err'=0 err 
	f i=1:1:num
	{   
	    q:($p($p(opstr,"^",i),"|",1)="")&($p($P(opstr,"^",i),"|",3)="")
	    s anaopOperType="S"
	    s attAnaopSub=$p($p(opstr,"^",i),"|",5)
	    s attOperId=$p($P(opstr,"^",i),"|",1)
	    s attOperDesc=$p($P(opstr,"^",i),"|",3)  //手术备注
	    s bldtpCode=$p($p(opstr,"^",i),"|",4)		//+wxl 091215 手术刀口类型 ANAOP_Blade_DR->ORC_BladeType
		
		s bldtpId=""
		i bldtpCode'="" d
			.i bldtpCode=+bldtpCode s bldtpId=bldtpCode q
			.s bldtpCode=$$ALPHAUP^SSUTIL4(bldtpCode)
			.s bldtpId=$o(^ORC("BLDTP",0,"Code",bldtpCode,""))
		s ancoplCode=$p($p(opstr,"^",i),"|",2)		//+wxl 091215 保存手术级别->ORC_OperationCategay 
	   	s ancoplId=""
		i ancoplCode'="" d
			.i ancoplCode=+ancoplCode s ancoplId=ancoplCode q
			.s ancoplCode=$$ALPHAUP^SSUTIL4(ancoplCode)
			.//s ancoplId=$o(^DHCANC("OPLevel",0,"Code",ancoplCode,""))
			.s ancoplId=$o(^ORC("CATEG",0,"Code",ancoplCode,""))
		//20180118
		s opdocLocId=$p($p(opstr,"^",i),"|",6)
		s opdocId=$p($p(opstr,"^",i),"|",7)
		s assId1=$p($p(opstr,"^",i),"|",8)
		s assId2=$p($p(opstr,"^",i),"|",9)
		s assId3=$p($p(opstr,"^",i),"|",10)
		s assoId=$p($p(opstr,"^",i),"|",11)
		s asso=$tr(assoId,",","@")

		
		s ass=assId1_"@"_assId2_"@"_assId3_"@"_asso
		i attAnaopStr="" d
	    	.s attAnaopStr=attAnaopSub_$c(4)_anaopOperType_$c(4)_attOperId_$c(4)_attOperDesc_$c(4)_bldtpId
	    	.s attAnaopStr=attAnaopStr_$c(4)_ancoplId_$c(4)_opdocLocId_$c(4)_opdocId_$c(4)_ass_$c(4)_$c(3)
	    e  d
	    	.s attAnaopStr=attAnaopStr_attAnaopSub_$c(4)_anaopOperType_$c(4)_attOperId_$c(4)_attOperDesc_$c(4)_bldtpId
	    	.s attAnaopStr=attAnaopStr_$c(4)_ancoplId_$c(4)_opdocLocId_$c(4)_opdocId_$c(4)_ass_$c(4)_$c(3)
	}
	
	//Id：类型：手术Id：手术名称：切口：级别
	s err=##Class(DHCANOPCom).UpdateAttOperation(anaId,attAnaopStr,ifAll)
	s err=##class(web.DHCANOPCom).AdjustPlanOperation("",anaId)
	//liangq 20101108
	s arcimId=$g(^DHCCLSet("AnOp","AppArcimId"))   
    //arcimId, anaId,userId,appType,isUpdate
    s opaRowId = ""
    f  s opaRowId=$o(^DHCANOPArrange(0,"Adm",adm,opaRowId)) q:opaRowId=""  d
    .q:$p(^DHCANOPArrange(opaRowId),"^",2)'=anaId
    .s result = ..SaveAnopAppOrdItem(arcimId,opaRowId,"",appType,0,1)

	//s retval=itmjs_"('"_$ZCVT(anaId,"O","JS")_"');"
    //i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(anaId,"O","JS")_"');"
    //&javascript<#(retval)#>
	q err
}

ClassMethod GetIfUserDef(type, Id) As %String
{
    s desc=""
    i type="opNameDef" d 
    .s ifUserDef=$p($g(^DHCCLSet("AnOp","UserDef")),"^",1)
    .i Id'="" s desc=$P($g(^ORC("OPER",+Id)),"^",2)
    i type="preDiagDef" d
    .s ifUserDef=$p($g(^DHCCLSet("AnOp","UserDef")),"^",2)
    .s prediag=$P(^MRC("ID",+Id),"^",2)
	.s desc=$G(prediag)
	i type="postDiagDef" d
	.s ifUserDef=$p($g(^DHCCLSet("AnOp","UserDef")),"^",3)
    .s postDiag=$P(^MRC("ID",+Id),"^",2)
	.s desc=$G(postDiag)
	i ifUserDef="" s ifUserDef="N"
    s ret=ifUserDef_"!"_Id_"!"_desc
    q ret
}

ClassMethod insertAnRecord(itmjs As %Library.String = "", itmjsex As %Library.String = "", str1 As %String, op As %String, ass As %String, strcheck As %String, anmetId As %String = "", ifBLApp As %String = "N", appType As %String = "") As %String
{
	k PLIST
	//web.UDHCANOPArrange.insertAnRecord
	//str1=applocId+"^"+appdocId+"^"+opaStartDate+"^"+opaStartTime+"^"+appUser+"^"+admId+"^"+oproomid+"^"+opmem+"^"+BldTypId+"^"+ArrTime;
	//str1=str1+"^"+opaOPLevelDr^opaPatHeight^opaPatWeight^opaPreDiscussDate^opaEstiOperDuration^opaOpDocNote^opaSeqNote^opaSeq^opaAppDate^opaAppTime
	//str1=str1+"^"+opaMedInfect+"^"+transferMeansCode
	//申请科室ID^申请医师^手术日期^手术时间^登陆用户^病人就诊ID^手术间ID^手术要求^血型^安排时间^麻醉规模^身高^体重^术前讨论日期^预计手术时长^手术医师备注^手术编号^台次^申请日期(空)^申请时间(空)^院内感染
	//s ^tmpYpz("insertAnRecord","str1")=str1
	//=987^4460^11/09/2009^17:40^680^8598^^手术要求手术要求^1^^3^^^^02:00^游邢泳爱耘^10101010^1
	//s op=ANAOP_Type_DR+"^"+preDiagid+"^"+ANAOP_Surgeon_DR+"^"+diagmem+"^"+operLoction^bodsId^operPositionId
	//	手术名称ID^术前诊断ID^手术医师ID^诊断备注^手术室名称^手术部位ID^手术体位ID
	s ^tmpYpz("insertAnRecord","op")=op
	//anaopTypeDR^anaopPreopDiagDR^anaopSurgeonDR^anaopNotes^anaopCtlocDesc^bodsId^operPositionId
	//=4^4^3594^霍乱霍乱^ZYSS-住院手术室^1^2
	s ^tmpYpz("insertAnRecord","ass")=ass
	//ass=firstAssId+"^"+secondAssId+"^"+thirdAssId+"^"+otherAssId
	//=3804^3884^3712^5396^4092
	s ^tmpYpz("insertAnRecord","strcheck")=strcheck
	//var strcheck=chbsag+"^"+chcvab+"^"+chivab+"^"+chmd+"^"+seljz+"^"+qt+"^"+RHBloodType+"^"+isolated+"^"+isPrepareBlood+"^"+isUseSelfBlood+"^"+isExCirculation+"^"+NeedAnaesthetist+"^"+"^"+NeedNavigation
	//	HbsAg^HCV_Ab^Hiv_Ab^梅毒^急诊^其他^RH血型^是否隔离^是否备血^是否自体血回收^是否体外循环^是否麻醉会诊^是否微创^是否导航
	//^^^^^^opaRHBloodType^opaIsolated^opaPrepareBlood^opaUseSelfBlood^opaExCirculation^opaNeedAnaesthetist
	//=未查^阴性^阳性^化验中^1^其他^阴性^Y^Y^Y^Y^Y
	s ^tmpYpz("insertAnRecord","anmetId")=anmetId_"/"_appType
	//=8
	//anmetId 麻醉方法(1|2)
	
	s adm=+$P(str1,"^",6)
	q:adm<1 "-1^就诊号不对!"
	TSTART  //test
	;s adm=$P(str1,"^",6)
	s PLIST(0)=adm 
	s PLIST(48)=##class(web.DHCANOPCom).ConvertToDateH($P(str1,"^",3))		//ANA_TheatreInDate	手术开始日期
	s PLIST(49)=##class(web.DHCANOPCom).ConvertToTimeH($P(str1,"^",4),"")		//ANA_TheatreInTime	手术开始时间
    &sql(INSERT INTO sqluser.OR_Anaesthesia Values :PLIST())
    s anaId=%ROWID
    i SQLCODE'=0  TRollBack  q "-2^插入麻醉表错误!"
	k PLIST
	s PLIST(2)=adm
	s PLIST(13)=##class(web.DHCANOPCom).ConvertToDateH($P(str1,"^",19)) //appDate
	s PLIST(14)=##class(web.DHCANOPCom).ConvertToTimeH($P(str1,"^",20)) //appTime
	s PLIST(7)=##class(web.DHCANOPCom).ConvertToDateH($P(str1,"^",3))
	i PLIST(7)<$h  TRollBack  q "-3^手术日期不能早于系统日期!"
	i (PLIST(7)=+$h)&($P(strcheck,"^",5)'=1) TRollBack  q "-12^非急诊手术日期不能是当前系统日期!"
	//s PLIST(9)=$ZTH($P(str1,"^",4))  //StarT
	s PLIST(9)=##class(web.DHCANOPCom).ConvertToTimeH($P(str1,"^",4),"")
	//s ^TT(3)=$ZTH($P(str1,"^",4))
	
	s PLIST(5)=$P(str1,"^",7)  								//OPA_OpRoom_dr	如维护手术间默认使用科室,申请时自动填入手术间
	s PLIST(12)=$P(str1,"^",2) 								//OPA_AppCtcp_Dr 申请医生
	s PLIST(3)=$p($g(^PAADM(adm)),"^",4)					//patloc //ypz 070530
	s PLIST(55)=$P(str1,"^",1)	//申请科室
	i "EO"[$p($g(^PAADM(adm)),"^",2) s PLIST(55)=$p($g(^PAADM(adm)),"^",4)
	s PLIST(33)=$p($g(^PAADM(adm)),"^",70)
	s PLIST(4)=anaId
	//s PLIST(20)="A"
	s PLIST(20)=""		//科主任审核
	s groupId=%session.Data("LOGON.GROUPID")
	i $G(^DHCCLSet("AnOp","DirAudit"))'="" d
		.i $G(^DHCCLSet("AnOp","DirAudit"))[groupId d
			..s PLIST(20)="A"
	e  s PLIST(20)="A"
	//如果是实习医生申请的手术为空状态
	s appctcpId=$P(str1,"^",2)
	i appctcpId'="" d
		.s ctcptId=$p($g(^CTPCP(appctcpId,1)),"^",4)
		.i ctcptId'="" d
			..s ctcptType=$p($g(^CT("CPT",ctcptId)),"^",1)
			..i ctcptType="PRACTICE" s PLIST(20)=""

	//i $P(strcheck,"^",5)=1 s PLIST(20)="A"
	s BldTyDescOrdId=$P(str1,"^",9)                               	//WKZ 071226 S 血型更新
 	i BldTyDescOrdId'="" d
		.i BldTyDescOrdId=+BldTyDescOrdId s BldTyId=BldTyDescOrdId
		.e  d
			..s BldTyDescOrdId=$$ALPHAUP^SSUTIL4(BldTyDescOrdId)
			..s BldTyId=$o(^PAC("BLDT",0,"Desc",BldTyDescOrdId,""))
	e  s BldTyId=""
	s ifBlood=..GetPatBlood(adm)
	s PLIST(27)=BldTyId										//OPA_BloodType_Dr	血型
	s PLIST(28)=$P(strcheck,"^",7)							//OPA_RHBloodType	RH血型
	s PLIST(29)=$P(strcheck,"^",8)						  	//OPA_Isolated		是否隔离
	i "YN"'[PLIST(29) s PLIST(29)=""
	s PLIST(34)=$P(strcheck,"^",9)							//OPA_PrepareBlood	是否备血
	i "YN"'[PLIST(34) s PLIST(34)=""
	s PLIST(35)=$P(strcheck,"^",10)							//OPA_UseSelfBlood	是否自体血回输
	i "YN"'[PLIST(35) s PLIST(35)=""
	s PLIST(37)=$P(strcheck,"^",11)							//OPA_ExCirculation	是否体外循环
	i "YN"'[PLIST(37) s PLIST(37)=""
	s PLIST(45)=$P(strcheck,"^",12) 						//OPA_NeedAnaesthetist是否麻醉会诊
	i "YN"'[PLIST(45) s PLIST(45)=""
	s PLIST(24)=$P(strcheck,"^",13) 						//OPA_MiniInvasive	是否微创手术
	i "YN"'[PLIST(24) s PLIST(24)=""
	s PLIST(56)=$p(strcheck,"^",14)                         //OPA_Navigation 是否导航
	i "YN"'[PLIST(56) s PLIST(56)=""
	s PLIST(285)=$p(strcheck,"^",15)                         //OPA_CarePathologSection 是否病理标本
    i "YN"'[PLIST(285) s PLIST(285)=""
	s PLIST(193)=$P(strcheck,"^",1)							//OPA_PATestHBsAg 	免疫乙肝表面抗原
	s PLIST(198)=$P(strcheck,"^",2)							//OPA_PATestHCVAb 	免疫丙型肝炎抗体
	s PLIST(199)=$P(strcheck,"^",3)							//OPA_PATestHivAb 	免疫艾滋病毒抗体
	s PLIST(200)=$P(strcheck,"^",4)							//OPA_PATestTPAb 	免疫梅毒
	;其他检验信息+这块maxlen增大了
	s PLIST(166)=$P(strcheck,"^",6)							//OPA_PATestOther 	检验其它阴阳性
	
	s PLIST(19)=$P(str1,"^",8) 								//OPA_Memo			备注-手术要求			
	s PLIST(21)=+$P(str1,"^",11)      //WKZ 071224 S		//OPA_OPLevel_Dr	麻醉规模
	s PLIST(25)=+$P(str1,"^",12)							//OPA_PatHeight		身高
	s PLIST(26)=$P(str1,"^",13)      //WKZ 071224 E			//OPA_PatWeight		体重
	s PLIST(149)=anmetId 
	s PLIST(26)=+PLIST(26)
	;20161214+dyl
	//s PLIST(38)=##class(web.DHCANOPCom).ConvertToTimeH($P(str1,"^",15),"")
	s PLIST(38)=$P(str1,"^",15)
	s PLIST(39)=##class(web.DHCANOPCom).ConvertToDateH(($P(str1,"^",14)),"") //+ wxl 090316

	s PLIST(22)="N"
	s PLIST(43)=$P(str1,"^",16)   							//OPA_OpDocNote 实习医生,手术医师备注
	s PLIST(42)=$P(str1,"^",17)   							//OPA_SeqNote	手术编号,医生手术申请编号
	s PLIST(6)=$P(str1,"^",18) 								//OPA_Seq		台次
	s PLIST(54)=$P(str1,"^",21)							    //OPA_MedInfect 院感
	s PLIST(40)=$P(str1,"^",22)                             //OPA_TransferMeans 接病人方式
	s PLIST(47)=$P(strcheck,"^",17)		//勿动20160114+OPA_UnPlanedOperation+重返手术
	&sql(INSERT INTO SQLUSER.DHC_AN_OPArrange Values :PLIST())
	s Ret1=%ROWID
	;20160908+dyl:统一用"|"分割
	s anmetId=$tr(anmetId,",","|")
	s $P(^DHCANOPArrange(Ret1,"PA"),"^",89)=anmetId
	i SQLCODE'=0 TRollBack  q "-5^插入手术排班表错误!"_"/"_Ret1_"/"_SQLCODE
	
	//手术医师组+dyl+20150319+标准版+旧版没有保存，走扩展字段
	/*多科手术不准备存这个了
	s docGroupId=$P(strcheck,"^",16)	//OPA.OperMedUnitId 手术医师组
	s paraStr="" ,retSur=""
	s paraStr="OPA.OperMedUnitId"_$c(3)_docGroupId
	s retSur=##Class(web.DHCANOPArrangeExtend).SaveArrangeExtend(Ret1,paraStr,$p(str1,"^",5))
	i +retSur<0 TRollBack  q:"-111^插入手术医师组错误"
	*/
	//-----
	
	///ck 091204
	s anaNotesList=$lb("")
	i ($p($P(op,"^",2),"|",1)="")!($p($p($p(op,"^",2),"|",1),"/",2)="")  d
		.s anaNotes=$p(op,"^",4)
		.s anaNotesList=$lb(anaNotes)
	
	s SourceType=$P(strcheck,"^",5)							//ANA_SourceType 急诊(E)/择期(B)	
	i SourceType=1  s anaSourceType="E"
	e  s anaSourceType="B" 
	&sql(update SQLUSER.OR_Anaesthesia set ANA_Notes=:anaNotesList,ANA_SourceType=:anaSourceType where ANA_RowId=:anaId)
	i SQLCODE'=0 TRollBack  q "-6^写入诊断备注或急诊手术错误!"
	//s ^DHCANARRAGE("ch",Ret1)=strcheck					//检验值已存入DHC_AN_OPArrange
	;i anmetId'="" &sql(update SQLUSER.OR_Anaesthesia set ANA_Method=:anmetId where ANA_RowId=:anaId)
	;i SQLCODE'=0 TRollBack  q "-7^写入麻醉方式错误!" //ypz 070405 外科医生填写麻醉方式
	//保存多个麻醉方法
	s adm=$p(anaId,"||",1)
	s anachl=$p(anaId,"||",2)
	i anmetId'="" s $P(^OR(adm,"ANA",anachl),"^",5)=anmetId 	
	k PLIST
	
	s PLIST(7)=""
	s diagIdS=$p($P(op,"^",2),"|",1)
	s diagIdS=$tr(diagIdS,",","$") //主要为了兼容以前的程序，以前是以"$"分隔的，现在前台以","分隔，故替换
	s preDiagIdS=$p(diagIdS,"/",1)
	s postDiagId=$p(diagIdS,"/",2)
    i $l(diagIdS,"/")=1  d
		.i diagIdS'=""  d    //术前诊断Id
		..i diagIdS=+diagIdS s PLIST(6)=diagIdS
		..e  s PLIST(6)=""
		.s PLIST(7)=""
	i $l(diagIdS,"/")=2  d
		.i preDiagIdS'=""  d
		..i preDiagIdS=+preDiagIdS s PLIST(6)=preDiagIdS
		..e  s PLIST(6)=""
		.e  s PLIST(6)=""
	i postDiagId'=""  d      //术后诊断ID
	.i postDiagId=+postDiagId s PLIST(7)=postDiagId
	.e  s PLIST(7)=""
	
	
	
	q:($p($P(op,"^",1),"|",1)="")&($p($P(op,"^",1),"|",3)="") "手术名称或手术备注为空!"
	i $p($p(op,"^",1),"|",1)'=(+$p($p(op,"^",1),"|",1)) d
		.s PLIST(9)="" //20101029 zhangtao
	e  s PLIST(9)=$p($P(op,"^",1),"|",1)
	s PLIST(8)=$lb($p($p(op,"^",1),"|",3))	//ANAOP_Notes
	//s PLIST(11)=$P(op,"^",3)	//主刀医生
	s PLIST(11)=$p($P(op,"^",1),"|",7)	//20180118
	s bldtpCode=$p($p(op,"^",1),"|",4)							//+wxl 091215 手术刀口类型 ANAOP_Blade_DR->ORC_BladeType
	s bldtpId=""
	i bldtpCode'="" d
		.i bldtpCode=+bldtpCode s bldtpId=bldtpCode q
		.s bldtpCode=$$ALPHAUP^SSUTIL4(bldtpCode)
		.q:bldtpCode=""
		.s bldtpId=$o(^ORC("BLDTP",0,"Code",bldtpCode,""))
	s PLIST(12)=bldtpId											//+wxl 091215
	s ctlocDesc=$$ALPHAUP^SSUTIL4($P(op,"^",5)),ctlocId="" //ypz 070316
	i ctlocDesc'="" s ctlocId=$o(^CTLOC(0,"Desc",ctlocDesc,"")) //ypz 070316
	i ctlocId="",ctlocDesc=+ctlocDesc s ctlocId=ctlocDesc
	i ctlocId="",ctlocDesc'=+ctlocDesc TRollBack  q "-11^请选择手术室"
	s PLIST(13)=ctlocId  //ypz 070316
	s PLIST(14)="M" //ypz 070530
	s bodsId=$P(op,"^",6) //ypz 070418
	s PLIST(23)=$p(^PAADM(adm),"^",4) //ypz 090917 病人科室
	
	//s PLIST(42)=bodsId //ypz 070418 OEC_BodySite RowId //100129 现直接保存于Global中
	//s bodsDesc=$p($g(^OEC("BODS",+bodsId)),"^",2) //ypz 070418
	s PLIST(0)=anaId
	&sql(INSERT INTO sqluser.OR_Anaest_Operation Values :PLIST())
	s Ret3=%ROWID
	i SQLCODE'=0 TRollBack  q "-8^插入手术表错误!"
    //保存多个手术部位于GLobal中
    s adm=$P(Ret3,"||",1)	
	s anaSub=$P(Ret3,"||",2)
	s anaopSub=$P(Ret3,"||",3)
	s ^OR(adm,"ANA",anaSub,"TXT",0)=3                  //zhangtao add
    s preDiagS="",preDiagN=""                                          
	i $l(diagIdS,"/")=1  d
		.i diagIdS'=""  d    //术前诊断Id
			..s dNum=$l(diagIdS,"$")
			..f i=1:1:dNum d
				...s diagId=$p(diagIdS,"$",i)
				...q:diagId=""
				...i diagId=+diagId s $p(preDiagS,"|",i)=diagId
				...e  d
					....s $p(preDiagS,"|",i)=""
					....s $p(preDiagN,"|",i)=diagId
	i $l(diagIdS,"/")=2  d
		.i preDiagIdS'=""  d
			..s dNum=$l(preDiagIdS,"$")
			..f i=1:1:dNum d
			...s preDiagId=$p(preDiagIdS,"$",i)
			...i preDiagId=+preDiagId s $p(preDiagS,"|",i)=preDiagId
			...e  d 
			....s $p(preDiagS,"|",i)=""    
			....s $p(preDiagN,"|",i)=preDiagId
			.i postDiagId'=""  d      //术后诊断ID
			..i postDiagId'=+postDiagId s ^OR(adm,"ANA",anaSub,"TXT",3)=postDiagId
	s $p(^OR(adm,"ANA",anaSub,"OP",anaopSub),"^",4)=preDiagS  
	s ^OR(adm,"ANA",anaSub,"TXT",2)=preDiagN   //zhangtao add
	s preDiagNote=$p($P(op,"^",2),"|",2)
	s ^OR(adm,"ANA",anaSub,"TXT",1)=preDiagNote
	i $p($p(op,"^",1),"|",1)'=(+$p($p(op,"^",1),"|",1)) d
		.s ^OR(adm,"ANA",anaSub,"OP",anaopSub,"REM",0)=2
		.;s ^OR(adm,"ANA",anaSub,"OP",anaopSub,"REM",1)=$lb($p($p(op,"^",1),"|",3))
		.s ^OR(adm,"ANA",anaSub,"OP",anaopSub,"REM",2)=$p($p(op,"^",1),"|",1)
	s bodsDesc=""
	i bodsId'="" d
		.s $p(^OR(adm,"ANA",anaSub,"OP",anaopSub),"^",24)=bodsId
		.s bodsIdNum=$l(bodsId,"|")
		.f i=1:1:bodsIdNum d
			..s curBodsId=$p(bodsId,"|",i)
			..q:curBodsId=""
			..i bodsDesc="" s bodsDesc=$p($g(^OEC("BODS",+curBodsId)),"^",2)
			..e  s bodsDesc=bodsDesc_","_$p($g(^OEC("BODS",+curBodsId)),"^",2)
	s operPositionId=$P(op,"^",7)
	i operPositionId'="" d
		.s PLIST(0)=Ret3
		.s PLIST(3)=operPositionId
		.&sql(INSERT INTO sqluser.OR_An_Oper_Position Values :PLIST())
	i SQLCODE'=0 TRollBack  q "-9^插入体位表错误!"
	s chl=$P(Ret3,"||",3)
	s anchl=$P(Ret3,"||",2)
	s ancoplCode=$p($p(op,"^",1),"|",2)							//+wxl 091215 保存手术级别->ORC_OperationCategay 
	s ancoplId=""
	i ancoplCode'="" d
		.i ancoplCode=+ancoplCode s ancoplId=ancoplCode q
		.s ancoplCode=$$ALPHAUP^SSUTIL4(ancoplCode)
		.//s ancoplId=$o(^DHCANC("OPLevel",0,"Code",ancoplCode,""))
		.s ancoplId=$o(^ORC("CATEG",0,"Code",ancoplCode,"")) 		//update by lyn 20160811
	s $p(^OR(adm,"ANA",anchl,"OP",chl,"DHC"),"^",1)=ancoplId	//+wxl 091215 
		//术者科室20180118
	s doclocId=$p($p(op,"^",1),"|",6)
	s $p(^OR(adm,"ANA",anchl,"OP",chl,"DHC"),"^",7)=doclocId
	s ass=""
	s ass1=$p($p(op,"^",1),"|",8)
	s ass2=$p($p(op,"^",1),"|",9)
	s ass3=$p($p(op,"^",1),"|",10)
	s asso=$p($p(op,"^",1),"|",11)
	s asso=$tr(asso,",","^")
	s ass=ass1_"^"_ass2_"^"_ass3_"^"_asso
	s num=$L(ass,"^")
	f i=1:1:num
	{
		i SQLCODE q
		k PLIST
		i $P(ass,"^",i)'=""  d
		.s PLIST(0)=Ret3
		.s PLIST(3)=$P(ass,"^",i)
		.&sql(insert into sqluser.OR_An_Oper_Assistant values :PLIST())
	}
	i SQLCODE TRollBack  q "-10^插入手术助手表错误!"
	

	;20170627+dyl
	s SendMessage=$g(^DHCCLSet("AnOp","SendMessage"))
	i SendMessage="Y" d
		.//申请的时候向平台发送一次信息
		.s OAret=##class(web.DHCENS.EnsHISService).DHCHisInterface("SENDOPERATIONAPPLYINFO",Ret1)
		.s ^tmpDYL("ANOPApp",Ret1)=OAret
		.//申请的时候向电子病历发送一次消息
		.s retEMR=""
		.;s retEMR=##class(EMRservice.BIEMRService).SetOperation(adm,Ret1)
		.//申请的时候向消息平台发送一次信息
		.s applocdr=$P(str1,"^",1)
		.Set rtnMes =##class(websys.DHCMessageInterface).Send("申请手术", "1053", $p(str1,"^",5), adm , "" , "" , "opaId为"_Ret1 ,ctlocId)
   //liangq 20101105
   	s opaId=Ret1
    s arcimId=$g(^DHCCLSet("AnOp","AppArcimId"))   
    s retInsord = ..SaveAnopAppOrdItem(arcimId,opaId,$p(str1,"^",5),"ward",0,0)
   	i retInsord'=0 TRollBack  q "-10000^插入医嘱^"_retInsord
	s otherOperStatus=0
	s subOperStr=$p(op,"^",8)
	s otherOperStatus=..insertchlop("","",anaId,subOperStr,appType)
	if (otherOperStatus'=0) TRollBack  q "-10000^从手术"_otherOperStatus_"/"
   	s retInsord = ..SaveAnopAppOrdItem(arcimId,opaId,$p(str1,"^",5),"ward",0,1)
   	i retInsord'=0 TRollBack  q "-10000^修改医嘱^"_retInsord
   	
	//s retval=itmjs_"('"_$ZCVT(anaId,"O","JS")_"');"
    //i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(anaId,"O","JS")_"');"
    //&javascript<#(retval)#>
		
   	TCOMMIT
   	
   	
   	
 q Ret1
 //OR_An_Oper_Anaest_Assistant
}

ClassMethod InsertOAM(val, str)
{
	s soap=##class(DtPortal.OA.MyEnsembleRequestWebServiceSoap).%New()
	s ret=soap.GetServiceInfo(val,str)
	q ret
}

/// Creator: liangqi
/// CreatDate: 2010-11-03
/// Description: 更新或者插入医嘱
/// Table：
/// Input：
/// Output：
ClassMethod SaveAnopAppOrdItem(arcimId, opaId, userId = "", appType = "", ifBLApp = "", isUpdate = 0)
{
	q:appType'="ward" 0
	q:opaId="" 0
	q:'$d(^DHCANOPArrange(opaId)) 0
	q:+arcimId=0 0
	
    s arcimVer=$p(arcimId,"||",2)
	
	q:arcimVer=""
	q:$d(^ARCIM(+arcimId,arcimVer))<1 0
	s oeoriDepProcNotes=""
	
	s anopGlb = ^DHCANOPArrange(opaId)
	s EpisodeID=$p(anopGlb,"^",1)
	s anaId = $p(anopGlb,"^",2)
	s anaSub = $p(anaId,"||",2)
	s anaOpId=$o(^OR(EpisodeID,"ANA",anaSub,"OP",0))

	//如果是更新
	i isUpdate {
	//该手术对应医嘱
	s oeordId=""
	s oeordId=$o(^OEORDi(0,"Ana",anaId,oeordId))
	q:oeordId="" 0

	//取手术名称以","分隔
	s operId=""
	s val("operDesc")=""
	s anaOpSub=0
	f  s anaOpSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaOpSub)) q:anaOpSub=""  d
	.s operId=$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaOpSub),"^",6)
	.s tmpDesc=""
	.i operId="" d  //手写的手术名称
	..s tmpDesc = $g(^OR(EpisodeID,"ANA",anaSub,"OP",anaOpSub,"REM",2))
	.e  d
	..s tmpDesc = $p($g(^ORC("OPER",operId)),"^",2)
	..i $p(tmpDesc,"-",2)'="" s tmpDesc=$p(tmpDesc,"-",2)
	.i val("operDesc")="" s val("operDesc")=tmpDesc
	.e  s val("operDesc")=val("operDesc")_","_tmpDesc

	s anmthdr=$P(^OR(EpisodeID,"ANA",anaSub),"^",5)
	i anmthdr="" s anmthdr=$P(^DHCANOPArrange(opaId,"PA"),"^",89) 
	//麻醉方法
	s anmetDesc=##class(web.DHCANOPCom).GetAnMethodDescById(anmthdr,",")
		i $l(anmetDesc,"-")>1 s val("anmetDesc")=$p(anmetDesc,"-",2)
	e  s val("anmetDesc")=anmetDesc
	
	s opaStartDate=$p(anopGlb,"^",14)
	s opaStartTime=$p(anopGlb,"^",15)
	i opaStartDate'="" s opaStartDate=##class(web.DHCClinicCom).ConvertToDate(opaStartDate)
    s val("opaStartDate")=opaStartDate

    s val("opaStartTime")=""
    i opaStartTime'="" d
    .s val("opaStartTime")=$zt(opaStartTime)
    
    //手术部位
    s bodsDesc=""
	s bodySiteId= $p($g(^OR(EpisodeID,"ANA",anaSub,"OP",anaOpId)),"^",24)
	i bodySiteId'="" d
	.s bodsIdNum=$l(bodySiteId,"|")
	.f i=1:1:bodsIdNum d
	..s curBodsId=$p(bodySiteId,"|",i)
	..q:curBodsId=""
	..i bodsDesc="" s bodsDesc=$p($g(^OEC("BODS",+curBodsId)),"^",2)
	..e  s bodsDesc=bodsDesc_","_$p($g(^OEC("BODS",+curBodsId)),"^",2)
	s val("bodsDesc")=bodsDesc
	
	//拼出字符串:拟于^opaStartDate^ ^opaStartTime^,在^bodsDesc^anmetDesc^下行^operDesc
   	i val("operDesc")'="" d
       .s oeoriDepProcNotes=""
       .s noteStr=$g(^DHCCLSet("AnOp","Note"))
       .i noteStr'="" d
       	    ..s num=$l(noteStr,"^")
       	    ..f i=1:1:num d
       			...s curVal=$p(noteStr,"^",i)
       			...q:curVal=""
       	        ...i $d(val(curVal))>0 s curVal=val(curVal)
        		...s oeoriDepProcNotes=oeoriDepProcNotes_curVal

	//更新医嘱DEP字段
	s oeoriSub=""
	f  s oeoriSub = $o(^OEORDi(0,"Ana",anaId,oeordId, oeoriSub)) q:oeoriSub=""  d
		.q:$p(^OEORD(oeordId,"I",oeoriSub,1),"^",2)'=arcimId
		.s ordStatCode=##Class(web.DHCClinicCom).GetOrdStatCode(oeordId_"||"_oeoriSub)
		.q:((ordStatCode'="E") && (ordStatCode'="V"))
		.s ^OEORD(oeordId,"I",oeoriSub,"DEP",1)=oeoriDepProcNotes
	q 0 
	}
	
	s retInsord=""
    s oeordId=$o(^OEORD(0,"Adm",EpisodeID,""))
    i oeordId="" d
   	    .s curDate=+$h,curTime=$p($h,",",2)
   	    .&sql(insert into sqluser.OE_Order(OEORD_Adm_DR,OEORD_Date,OEORD_Time) values(:EpisodeID,:curDate,:curTime))
   	    .i 'SQLCODE s oeordId=$g(%ROWID)
   	q:oeordId="" "-10^插入医嘱主表错!"
    s userDeptId=$p(^PAADM(EpisodeID),"^",4)
 	//P5-P8//s retInsord=##Class(web.DHCCLCom).InsertOrdItem(userId, oeordId, arcimId,3,1, userDeptId, anaId, anaId_"||"_anaOpId, "",oeoriDepProcNotes)
    ////20160301+dyl+多加了一个$c(3)
    s miltiOeoriStr=arcimId_$c(3)_$zd(+$h,3)_$c(3)_$zt($p($h,",",2))_$c(3)_userDeptId_$c(3)_$c(3)_1_$c(3)_$c(3)_$c(3)_1_$c(3)_$c(3)_$c(3)_$c(3)_opaId_$c(3)_oeoriDepProcNotes
    s retInsord=##Class(web.DHCANOrder).InsertOrderItem(EpisodeID, miltiOeoriStr, userId, userDeptId)
    i $l(retInsord,"*")>2 s retInsord=0
    i $p(retInsord,"^")=-1 s retInsord=0
    i retInsord'=0 q "-11^插入手术医嘱错误!"_retInsord
    
    //+wxl090901 是否插入病理申请
    s BLAppId=$g(^DHCCLSet("AnOp","BLAppId"))
    s retInsord=0
    i ifBLApp="Y",BLAppId'="" d
        .//P5-P8//s retInsord=##Class(web.DHCCLCom).InsertOrdItem(userId, oeordId, BLAppId,3,1, userDeptId, "", "", "","")
        .s miltiOeoriStr=arcimId_$c(3)_$zd(+$h,3)_$c(3)_$zt($p($h,",",2))_$c(3)_userDeptId_$c(3)_$c(3)_1_$c(3)_$c(3)_$c(3)_1_$c(3)_$c(3)_$c(3)_opaId_$c(3)_""
        .s retInsord=##Class(web.DHCANOrder).InsertOrderItem(EpisodeID, miltiOeoriStr, userId, userDeptId)
        .i $l(retInsord,"*")>2 s retInsord=0
        .i $p(retInsord,"^")=-1 s retInsord=0
    i retInsord'=0  q "-12^插入病理申请医嘱错误!"
    
    q 0
}

ClassMethod GetOpList(anaId As %String) As %String
{
	q:anaId="" ""
	s listop=""
	s adm=$P(anaId,"||",1)
	s chl=$P(anaId,"||",2)
	
	s subchl=0 f  s subchl=$O(^OR(adm,"ANA",chl,"OP",subchl)) q:(subchl="")  d
	   .s sub=subchl
	   .s docdr="",opd="",opdr="",opdes="",predigdr="",prediag="",OPCategory="",OPStatName="",ancopldesc="",OperNotes="",bldtpDesc=""
	   .;s oprdate=$P(^OR(adm,"ANA",chl,"OP",sub),"^",13)   					;ANAOP_OpStartDate  手术日期
	   .s docdr=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",8)      					;ANAOP_Surgeon_DR  	手术医师
	   .//if docdr'="" s opd=$TR($P(^CTPCP(docdr,1),"^",2)," ","")
	   .i docdr'="" s opd=##class(web.DHCANOPCom).GetNameById(docdr)
	   .s opdr=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",6)       					;ANAOP_Type_DR     	手术名称
	   .;q:opdr=""
	   .i opdr'="" d
	   ..i $D(^ORC("OPER",opdr)) d
	   ...s opdes=$P(^ORC("OPER",opdr),"^",2)									;OPER_Desc			ORC_Operation									
	   ...s OPCategoryId=$p(^ORC("OPER",opdr),"^",7) 							;OPER_DefaultCategory_DR	手术分类 
       ...i OPCategoryId'=""  s OPCategory=$p($g(^ORC("CATEG",OPCategoryId)),"^",2)
	   ...s OPStatName=$p(^ORC("OPER",opdr),"^",35)								;OPER_LongDescription		手术统计名称
	   .e  d
	   ..i $g(^OR(adm,"ANA",chl,"OP",subchl,"REM",2))'="" d
	   ...s opdes=$G(^OR(adm,"ANA",chl,"OP",subchl,"REM",2))
	   ...;s opdId=""
	   ...;s opdId=$o(^ORC("OPER",0,"Desc",opdes,opdId))
	   ...;s opdr=$g(opdId)
	   ...s opdId=$g(^OR(adm,"ANA",chl,"OP",subchl,"REM",2))
       ...s opdr=$g(opdId)
	   .s predigdrS=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",4)   					;ANAOP_PreopDiag_DR 术前诊断 zhangtao add
	   .s num=$l(predigdrS,"|")
	   .f i=1:1:num d
	   ..s predigdr=$p(predigdrS,"|",i)
	   ..i predigdr'=""  d
	   ...s $p(predigdrS,"|",i)=predigdr
	   ...s $p(prediag,"|",i)=$P(^MRC("ID",predigdr),"^",2)
	   ..e  d
	   ..i $g(^OR(adm,"ANA",chl,"TXT",2))'="" d
	   ...s $p(predigdrS,"|",i)=$p($g(^OR(adm,"ANA",chl,"TXT",2)),"|",i)
	   ...s $p(prediag,"|",i)=$p($g(^OR(adm,"ANA",chl,"TXT",2)),"|",i)  //ck091210 麻醉表存放诊断备注ANA_Notes zhangtao add
	   .s prediag=""
	   .s ancoplId=$p($g(^OR(adm,"ANA",chl,"OP",subchl,"DHC")),"^",1)
	   .//i ancoplId'="" s ancopldesc=$p(^DHCANC("OPLevel",ancoplId),"^",2)		;DHC_ANC_OPLeve		手术级别
		.i ancoplId'="" s ancopldesc=$p(^ORC("CATEG",ancoplId),"^",2)	//update by lyn   手术级别->ORC_OperationCategay 
	   .s noteSub=0
	   .;f  s noteSub=$o(^OR(adm,"ANA",chl,"OP",subchl,"REM",noteSub)) q:noteSub=""  d
	   ..;s OperNotes=OperNotes_^OR(adm,"ANA",chl,"OP",subchl,"REM",noteSub)		;ANAOP_Notes		手术备注
	   .s OperNotes=$g(^OR(adm,"ANA",chl,"OP",subchl,"REM",1))
	   .s bldtpId=$p(^OR(adm,"ANA",chl,"OP",subchl),"^",9)						;ANAOP_Blade_DR		手术刀口类型
	   .i bldtpId'="" s bldtpDesc=$p(^ORC("BLDTP",bldtpId),"^",2)				;ORC_BladeType
	   .s listop=$G(listop)_docdr_"!"_opd_"!"_opdr_"!"_opdes_"!"_predigdrS_"!"_prediag_"!"_OPCategory_"!"_ancoplId_"!"_ancopldesc_"!"_OperNotes_"!"_bldtpId_"!"_bldtpDesc_"!"_subchl_"^"
  q listop
}

// 新版本不再使用

// w ##class(web.UDHCANOPArrange).ChangeAnopStat("D",403)

ClassMethod ChangeAnopStat(stat, opaId) As %String
{
	q:(opaId="")!(stat="") "手术申请Id和手术状态必须非空!"
	;20161027+dyl+完成不可以取消
	s curStat=""
	i opaId'="" s curStat=$P(^DHCANOPArrange(opaId),"^",27)
	q:((curStat="F") ||(curStat="L"))&(stat="D") "手术已完成,不能取消手术"
	
	TSTART
  //改变状态
	&sql(select * into :PLIST() from SQLUSER.DHC_AN_OPArrange where opa_rowid=:opaId)
	s PLIST(20)=stat //arrangeuser
	i stat="D" s PLIST(22)="C"
	i (stat="A")&(PLIST(22)="G") s PLIST(22)="M"
	&sql(update SQLUSER.DHC_AN_OPArrange Values :PLIST() where opa_rowid=:opaId)
	i SQLCODE'=0 TROLLBACK  q "err"
	;20120528+dyl
	i stat="D" s $P(^DHCANOPArrange(opaId),"^",20)=""
	i stat="D" s $P(^DHCANOPArrange(opaId),"^",26)=""
	s retStr=""
	s (opaRoom,opaSeq,ctcpAnDoc,ctcpAnNur,ctcpDevNur,ctcpTourNur,opstTime)=""
	s userId=%session.Data("LOGON.USERID")
	s opId=opaId
	/* 缺少类方法web.DHCENS.WebServiceNew.DHCCRisXiangYaOneSoap  YuanLin 20171117
	s retStrMessage=##class(web.DHCANArrange).SendMessage(opId,opaRoom,opaSeq,ctcpAnDoc,ctcpAnNur,ctcpDevNur,ctcpTourNur,opstTime,userId)
	i retStrMessage="-1" s retStr="发送消息失败！"
	i retStrMessage="-1" TROLLBACK
	i retStrMessage="0" s retStr=""
	*/
	s retStr=""
	i retStr="" TCOMMIT
	q retStr
}

// 新版本不再使用

ClassMethod GetAnSingle(itmjs As %Library.String = "", itmjsex As %Library.String = "", opaId As %String, EpisodeID As %String = "", userId As %String = "") As %String
{
	n (itmjs , itmjsex, opaId, EpisodeID, userId)
	i EpisodeID="",opaId'="" s EpisodeID=$P(^DHCANOPArrange(opaId),"^",1)
	q:EpisodeID="" ""
	s anaesrw=""
	s opdate="",oproom="",oproomdr="",opaSeq="",operLocDesc="",isAddInstrument="",instrumentDr="",instrument="",regNo="",patName="",sex="",age="",opdes="",opdr="",locdes="",opd="",docdr="",appCtcpDesc="",appCtcpId="",mzz="",anmethod="",xsh="",xch="",oppack="",bedCode="",ward="",admreason="",locdes="",ash="",diagStr="",digdr="",arrdate="",opmem="",diamem="",BldTypId="",bodsList=""
	s PatHeight="",PatWeight="",OPLevelDR="",OPLevel="",ASADR="",ASA="",operLocId="",BldTyp="不详",operPositionId="",operPosition="",opDocNote="",opSeqNote="",OPCategory="",OPStatName="",mzsupdr="",mzsupdoc="",anDocNote="",scNurNote="",cirNurNote=""
    s transferMeans="",transferMeansCode="",docAnMethod="",IsPapEstimDS="N"
	s admreason=""
	s admreasondr=$p($g(^PAADM(EpisodeID,1)),"^",7)
	i admreasondr'="" s admreason=$P(^PAC("ADMREA",admreasondr),"^",2)
	s curWardId=$p($g(^PAADM(EpisodeID)),"^",70)
	s bedSub=$p($p($g(^PAADM(EpisodeID)),"^",73),"||",2)
	s bedCode="" i bedSub'="" s bedCode=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1) //ypz 060916
	s ward="" i curWardId'="" s ward=$P($G(^PAWARD(curWardId)),"^",2)  //ck 091022
	s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
	s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	s birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
	s age=..CalAge(birth,+$h)
	s sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
	s infection=..GetQueryInfPyObjDrugByPaadmStr(EpisodeID)
	s loc=$P(^PAADM(EpisodeID),"^",4)
	s locdes=$P(^CTLOC(loc),"^",2)
	s papEstimDCDate=$p($g(^PAADM(EpisodeID)),"^",59) //ADD MFC 2012-08-01 获取出院评估日期
    s papVStatus=$p($g(^PAADM(EpisodeID)),"^",20) //ADD MFC 2012-08-01 获取医疗结算状态
    i ((papEstimDCDate'="")&(papVStatus="A")) d
      .s IsPapEstimDS="Y"
	s opstdate=+$h
	s day=$zd(opstdate,10)
	i day>4 s opstdate=opstdate+1
	i day=5 s opstdate=opstdate+1
	s opdate=$ZD(opstdate+1,4)_"          "
	s locListCodeStr=##class(web.DHCClinicCom).AdjustLocListCode("OP^OUTOP^EMOP",EpisodeID)
	s ctlocIdList=##class(web.DHCClinicCom).GetLocIdByLocListCode(locListCodeStr)
	i ctlocIdList'="" d
		.s operLocId=$p(ctlocIdList,"^",1)
		.q:operLocId=""
		.q:'$d(^CTLOC(operLocId))
	    .s operLocDesc=$p(^CTLOC(operLocId),"^",2)
	i loc'="" d
		.s curOPRoomId=$o(^DHCANC("OPRoom",0,"DefDep",loc,""))
		.q:curOPRoomId=""
		.s operLocId=$p(^DHCANC("OPRoom",curOPRoomId),"^",3)
		.q:operLocId=""
		.q:'$d(^CTLOC(operLocId))
	    .s operLocDesc=$p(^CTLOC(operLocId),"^",2)
	i userId'="" d
		.s appCtcpId=$p($g(^SSU("SSUSR",userId)),"^",14)
		.q:appCtcpId=""
		.//s appCtcpDesc=$p($g(^CTPCP(appCtcpId,1)),"^",2)
		.s appCtcpDesc=##class(web.DHCANOPCom).GetNameById(appCtcpId)
	i opaId="" d SetRetData q Data
	
	s appCtcpId=$P(^DHCANOPArrange(opaId),"^",6)  //ypz 070318
	//i appCtcpId'="" s appCtcpDesc=$p(^CTPCP(appCtcpId,1),"^",2)   //ypz 070318
	i appCtcpId'="" s appCtcpDesc=##class(web.DHCANOPCom).GetNameById(appCtcpId)
	s opstdate=$P(^DHCANOPArrange(opaId),"^",14)
	s age=..CalAge(birth,opstdate)
	i opstdate'="" s opstdate=$zd(opstdate,4)
	s opsttime=$P(^DHCANOPArrange(opaId),"^",15)
	s oparrdate=$P(^DHCANOPArrange(opaId),"^",7)
	s oparrtime=$P(^DHCANOPArrange(opaId),"^",8)
	s openddate=$P(^DHCANOPArrange(opaId),"^",16)
	s opendtime=$P(^DHCANOPArrange(opaId),"^",17)
	s preDiscussDate=$P(^DHCANOPArrange(opaId),"^",38)
	i preDiscussDate'="" s preDiscussDate=$zd(preDiscussDate,4)
	s estiOperDuration=$P(^DHCANOPArrange(opaId),"^",37)
	i estiOperDuration'="" s estiOperDuration=$ZT(estiOperDuration,2)
	i openddate'=""  s openddate=$ZD(openddate,4)
	i opendtime'=""  s opendtime=$ZT(opendtime,2)
	s transferMeansCode=$p(^DHCANOPArrange(opaId),"^",39)  //zhangtao 2010.8.5
	i transferMeansCode="W" s transferMeans="自行" 
	i transferMeansCode="C" s transferMeans="轮椅"
	i transferMeansCode="S" s transferMeans="平车"
	s opmem=$P(^DHCANOPArrange(opaId),"^",19)
	s BldTypId=$P(^DHCANOPArrange(opaId),"^",11)
	i BldTypId'="" s BldTyp=$P($G(^PAC("BLDT",BldTypId)),"^",2)   //wkz
	e  s BldTyp="不详"
	if oparrdate'="" s oparrdate=$ZD(oparrdate,4)
	if oparrtime'="" s oparrtime=$ZT(oparrtime,2)
	s arrdate=oparrdate_" "_oparrtime
	i opsttime'="" s opsttime=$ZT(opsttime,2)
	
	s oproomdr=$P(^DHCANOPArrange(opaId),"^",20)
	i oproomdr'="" s oproom=$P($G(^DHCANC("OPRoom",oproomdr)),"^",2)
	s opaSeq=$P(^DHCANOPArrange(opaId),"^",26) 							//OPA_seq	台次
	s instrumentDr=$P($G(^DHCANOPArrange(opaId)),"^",30) 
	i instrumentDr'="" s instrument=$P($G(^DHCANC("Instrument",instrumentDr)),"^",2)  	//DHC_ANC_Instrument	器械
	e  s instrument=""
	s isAddInstrument=$P($G(^DHCANOPArrange(opaId)),"^",31) 			//OPA_AddInstrument		是否补充器械
    s scnShiftTime="",cirShiftTime=""                           //2011.3.21 
	s sub=0 f  s sub=$o(^DHCANOPArrange(opaId,"Shift",sub)) q:sub=""  d
	.i $p(^DHCANOPArrange(opaId,"Shift",sub),"^",39)="SN" d 
	..s scnShiftTime=$zt($p(^DHCANOPArrange(opaId,"Shift",sub),"^",19),2)
	.i $p(^DHCANOPArrange(opaId,"Shift",sub),"^",39)="CN" d
	..s cirShiftTime=$zt($p(^DHCANOPArrange(opaId,"Shift",sub),"^",19),2) 
	s anaId=$P(^DHCANOPArrange(opaId),"^",2)
	s anaSub=$P(anaId,"||",2)
	s mzdr=$P(^OR(EpisodeID,"ANA",anaSub),"^",6)        		//ANA_Anaesthetist_Dr	麻醉医师
	i mzdr'="" d
	.//s mzdoc=$TR($P(^CTPCP(mzdr,1),"^",2)," ","") 			 	;麻醉医师
	.s mzdoc=##class(web.DHCANOPCom).GetNameById(mzdr) 
	e  s mzdoc=""
	
	s mzsupdr=$P(^OR(EpisodeID,"ANA",anaSub),"^",7)        		//ANA_Supervisor_Dr ///ck091203
	i mzsupdr'="" d
	.//s mzsupdoc=$TR($P(^CTPCP(mzsupdr,1),"^",2)," ","") 	 	;麻醉辅导医师
	.s mzsupdoc=##class(web.DHCANOPCom).GetNameById(mzsupdr)
	e  s mzsupdoc=""
	
	s mzNurseId=$P(^OR(EpisodeID,"ANA",anaSub),"^",8)			//ANA_ORAnaNurse_DR		麻醉护士
	i mzNurseId'="" d
	.//s mzNurse=$TR($P($G(^CTPCP(mzNurseId,1)),"^",2)," ","") 	;麻醉护士
	.s mzNurse=##class(web.DHCANOPCom).GetNameById(mzNurseId)
	e  s mzNurse=""  
	
	s anaTheatreInDate=$p(^OR(EpisodeID,"ANA",anaSub),"^",39)
	i anaTheatreInDate'="" s anaTheatreInDate=$zd(anaTheatreInDate,4)
	e  s anaTheatreInDate=opstdate
	s anaTheatreInTime=$p(^OR(EpisodeID,"ANA",anaSub),"^",40)
	i anaTheatreInTime'="" s anaTheatreInTime=$zt(anaTheatreInTime,2)
	e  s anaTheatreInTime=opsttime
	
	s anaTheatreOutDate=$p(^OR(EpisodeID,"ANA",anaSub),"^",41)
	i anaTheatreOutDate'="" s anaTheatreOutDate=$zd(anaTheatreOutDate,4)
	s anaTheatreOutTime=$p(^OR(EpisodeID,"ANA",anaSub),"^",42)
	i anaTheatreOutTime'="" s anaTheatreOutTime=$zt(anaTheatreOutTime,2)
	
	s opdate=opstdate_" "_opsttime_" "_oparrtime_" "_openddate_" "_opendtime_" "_preDiscussDate_" "_estiOperDuration_" "_anaTheatreInDate_" "_anaTheatreInTime_" "_anaTheatreOutDate_" "_anaTheatreOutTime
	//s EpisodeID=+anaId
    //s anaSub=$p(anaId,"||",2)
    s anaopSub=0,mzdoc1="",jmzdoc="",jmzdoc1=""
    f  s anaopSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)) q:anaopSub=""  d
        .q:$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",12)'="M" 
        .s mzStr=""
        .s anassSub=0
        .f  s anassSub=$O(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ANASS",anassSub))  q:(anassSub="")||(anassSub>20)  d
        ..s mzdr1=$g(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ANASS",anassSub))
        ..//i mzdr1'="" s mzdoc1=$TR($P(^CTPCP(mzdr1,1),"^",2)," ","")
        ..i mzdr1'="" s mzdoc1=##class(web.DHCANOPCom).GetNameById(mzdr1)
        ..i mzStr="" s mzStr=mzdoc1_"!"_mzdr1
        ..e  s mzStr=mzStr_" "_mzdoc1_"!"_mzdr1
        .s jmzStr=""
        .s anassSub=20
        .f  s anassSub=$O(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ANASS",anassSub)) q:(anassSub="")  d
        ..s jmzdr=$g(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ANASS",anassSub))
        ..//i jmzdr'="" s jmzdoc=$TR($P(^CTPCP(jmzdr,1),"^",2)," ","")
        ..i jmzdr'="" s jmzdoc=##class(web.DHCANOPCom).GetNameById(jmzdr)
        ..i jmzStr="" s jmzStr=jmzdoc_"!"_jmzdr
        ..e  s jmzStr=jmzStr_" "_jmzdoc_"!"_jmzdr
     
	s mzz=mzdoc_"!"_mzdr_"*"_mzNurse_"!"_mzNurseId_"*"_mzStr_"*"_jmzStr
	s anmthdr=$P(^OR(EpisodeID,"ANA",anaSub),"^",5)       ;ANA_Method	麻醉方法
		i anmthdr'="" d
		.s anmetNum=$l(anmthdr,"|")
		.f i=1:1:anmetNum d
		..s anmetId=$p(anmthdr,"|",i)
		..q:anmetId=""
		..s anmetDesc=$p($g(^ORC("ANMET",anmetId)),"^",2)
		..i $P(anmetDesc,"-",2)'="" s anmetDesc=$P(anmetDesc,"-",2)
		..i anmethod="" s anmethod=anmetId_"|"_anmetDesc
		..e  s anmethod=anmethod_"!"_anmetId_"|"_anmetDesc	   

	s i=0
	s anaesrw=EpisodeID_"||"_anaSub
	s subchl=0 f  s subchl=$O(^OR(EpisodeID,"ANA",anaSub,"OP",subchl)) q:(subchl="")!(i=1)  d
	   .s i=i+1
	   .s anaopSub=subchl
	   .;s oprdate=$P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",13)  ;ANAOP_OpStartDate  手术日期
	   .s docdr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",subchl),"^",8)        ;ANAOP_Surgeon_DR  ；手术医师
	   .//i docdr'="" s opd=$TR($P(^CTPCP(docdr,1),"^",2)," ","")
	   .i docdr'="" s opd=##class(web.DHCANOPCom).GetNameById(docdr)
	   .e  s opd=$TR($p($p(^DHCANOPArrange(opaId),"^",42),"|",2)," ","")  //自填写手术医生
	   .s opdr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",subchl),"^",6)         ;ANAOP_Type_DR     ；手术名称
	   .;q:opdr=""
	   .i opdr'="" d
	   ..i $D(^ORC("OPER",opdr)) d
	   ...s opdes=$P(^ORC("OPER",opdr),"^",2)
	   ...s OPCategoryId=$p(^ORC("OPER",opdr),"^",7)  					 //+ wxl 090320 手术分类
       ...i OPCategoryId'=""  s OPCategory=$p($g(^ORC("CATEG",OPCategoryId)),"^",2)
       ...s OPStatName=$P(^ORC("OPER",opdr),"^",35) 						 //+ wxl 090819 手术统计名称
	   .e  d
       ..i $g(^OR(EpisodeID,"ANA",anaSub,"OP",subchl,"REM",2))'="" d
       ...s opdes=$G(^OR(EpisodeID,"ANA",anaSub,"OP",subchl,"REM",2))
       ...s opdr=opdes
	   ..;s oper $p(^OR(adm,"ANA",anchl,"OP",chl,"DHC"),"^",1)
	   ..s predigdr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",subchl),"^",4)   ;ANAOP_PreopDiag_DR 术前诊断
	   ..i predigdr'=""  d
	   ...s prediag=$P(^MRC("ID",predigdr),"^",2)
	   ...s diag=$G(prediag)
	   ..e  d
	   ...i $g(^OR(EpisodeID,"ANA",anaSub,"TXT",1))'="" d 
	   ....s diamen=^OR(EpisodeID,"ANA",anaSub,"TXT",1)  //ck091210 麻醉表存放诊断备注ANA_Notes
	   ....s diag=$G(diamen)
	   .s operLocId=$P(^OR(EpisodeID,"ANA",anaSub,"OP",subchl),"^",10)   //ypz 070317
	   .s operLocDesc="" //ypz 070317
	   .i operLocId'="" s operLocDesc=$p(^CTLOC(operLocId),"^",2) 		 //ypz 070317
	   .s bodsIdList=$P(^OR(EpisodeID,"ANA",anaSub,"OP",subchl),"^",24) 	 //ypz 070418 	手术部位
	   .s bodsList=""
	   .i bodsIdList'="" d
	   ..s bodsIdNum=$l(bodsIdList,"|")
	   ..f j=1:1:bodsIdNum d
	   ...s bodsId=$p(bodsIdList,"|",j)
	   ...q:bodsId=""
	   ...s bodsDesc=$p($g(^OEC("BODS",+bodsId)),"^",2)
	   ...i bodsList="" s bodsList=bodsId_"|"_bodsDesc
	   ...e  s bodsList=bodsList_"!"_bodsId_"|"_bodsDesc	   
	   .s predigdrS=$P(^OR(EpisodeID,"ANA",anaSub,"OP",subchl),"^",4)     ;ANAOP_PreopDiag_DR 术前诊断S //zhangtao add
	   .s num=$l(predigdrS,"|")
	   .f di=1:1:num d
	   ..s predigdr=$p(predigdrS,"|",di)
	   ..i predigdr'=""  d
	   ...s $p(prediag,"|",di)=$P(^MRC("ID",predigdr),"^",2)
	   ...s $p(predigdrS,"|",di)=predigdr
	   ..e  d
	   ...s $p(prediag,"|",di)=$p($g(^OR(EpisodeID,"ANA",anaSub,"TXT",2)),"|",di)
	   ...s $p(predigdrS,"|",di)=$p($g(^OR(EpisodeID,"ANA",anaSub,"TXT",2)),"|",di)   //zhangtao add
	   .;s notesub=0
	   .;f  s notesub=$o(^OR(EpisodeID,"ANA",anaSub,"TXT",notesub)) q:notesub=""  d
	   ..;i diamem="" s diamem=$g(^OR(EpisodeID,"ANA",anaSub,"TXT",notesub))		//ANA_Notes	麻醉表存放诊断备注
	   ..;e  s diamem=diamem_","_$g(^OR(EpisodeID,"ANA",anaSub,"TXT",notesub))
	   .s diamem=$g(^OR(EpisodeID,"ANA",anaSub,"TXT",1))
	   .s postdigdr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",subchl),"^",5)   ;ANAOP_PostDiag_DR 术后诊断
	   .s postdiag=""
	   .i postdigdr'="" d
	   ..s postdiag=$P(^MRC("ID",postdigdr),"^",2)
	   .e  s postdiag=$g(^OR(EpisodeID,"ANA",anaSub,"TXT",3)),postdigdr=postdiag
	   .i postdigdr'="" d
	   ..s digdr=predigdrS_"/"_postdigdr
	   .e  d
	   ..s digdr=predigdrS
	   .i postdiag'="" d
	   ..s diagStr=prediag_"/"_postdiag
	   .e  d
	   ..s diagStr=prediag
	;s i=0
	;q:anaopSub=""
	;s anm=0 f  s anm=$O(^OR(EpisodeID,"ANA",anaSub,"AGN",anm)) q:(anm="")!(i=1)  d  ;麻醉方法
	   ;.s amthdr=$P(^OR(EpisodeID,"ANA",anaSub,"AGN",anm),"^",2)
	   ;.s anmethod=$P(^ORC("ANMET",amthdr),"^",2)
	   ;.s i=i+1
	s p=0  ;助手
	s assDocNum=3
	i $p($g(^DHCCLSet("AnOp","Ctcp")),"^",1)>0 s assDocNum=$p($g(^DHCCLSet("AnOp","Ctcp")),"^",1)
	//w EpisodeID_"||"_anaSub_"||"_anaopSub,!
	s anaopSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",0))
	//w EpisodeID_"||"_anaSub_"||"_anaopSub,!
	s ash=""
	s as=0 f  s as=$O(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ASS",as)) q:(as="")!(p'<assDocNum)  d
	   .s asdr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ASS",as),"^",1)
	   .q:asdr=""
	   .//s p=p+1
	   .//s ash=ash_$TR($P($G(^CTPCP(asdr,1)),"^",2)," ","")_"!"_asdr_" "  ;
	   .s ash=ash_##class(web.DHCANOPCom).GetNameById(asdr)_"!"_asdr_" "
	   //w ash,!
	s xsh1="",xsh2=""    ;洗手
	s xs=0 f  s xs=$O(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"SCN",xs)) q:(xs="")!(xs>20)  d
	   .s xsdr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"SCN",xs),"^",1)
	   .q:xsdr=""
	   .//i xsh1="" s xsh1=$TR($P(^CTPCP(xsdr,1),"^",2)," ","")_"!"_xsdr
	   .//e  s xsh1=xsh1_" "_$TR($P(^CTPCP(xsdr,1),"^",2)," ","")_"!"_xsdr
	   .i xsh1="" s xsh1=##class(web.DHCANOPCom).GetNameById(xsdr)_"!"_xsdr
	   .e  s xsh1=xsh1_" "_##class(web.DHCANOPCom).GetNameById(xsdr)_"!"_xsdr
	s xs1=20 f  s xs1=$O(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"SCN",xs1)) q:(xs1="")  d
	   .s xsdr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"SCN",xs1),"^",1)
	   .q:xsdr=""
	   .//i xsh2="" s xsh2=$TR($P(^CTPCP(xsdr,1),"^",2)," ","")_"!"_xsdr
	   .//e  s xsh2=xsh2_" "_$TR($P(^CTPCP(xsdr,1),"^",2)," ","")_"!"_xsdr
	   .i xsh2="" s xsh2=##class(web.DHCANOPCom).GetNameById(xsdr)_"!"_xsdr
	   .e  s xsh2=xsh2_" "_##class(web.DHCANOPCom).GetNameById(xsdr)_"!"_xsdr
	s xsh=xsh1_"*"_xsh2_"*"_scnShiftTime
	
	s xch1="",xch2=""  ;巡床
	s xc=0 f  s xc=$O(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"CIRN",xc)) q:(xc="")!(xc>20)   d
	   .s xchdr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"CIRN",xc),"^",1)
	   .q:xchdr=""
	   .//i xch1=""  s xch1=$TR($P($G(^CTPCP(xchdr,1)),"^",2)," ","")_"!"_xchdr
	   .//e  s xch1=xch1_" "_$TR($P($G(^CTPCP(xchdr,1)),"^",2)," ","")_"!"_xchdr
	   .i xch1=""  s xch1=##class(web.DHCANOPCom).GetNameById(xchdr)_"!"_xchdr
	   .e  s xch1=xch1_" "_##class(web.DHCANOPCom).GetNameById(xchdr)_"!"_xchdr
	s xc1=20 f  s xc1=$O(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"CIRN",xc1)) q:(xc1="")   d
	   .s xchdr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"CIRN",xc1),"^",1)
	   .q:xchdr=""
	   .//i xch2=""  s xch2=$TR($P(^CTPCP(xchdr,1),"^",2)," ","")_"!"_xchdr
	   .//e  s xch2=xch2_" "_$TR($P(^CTPCP(xchdr,1),"^",2)," ","")_"!"_xchdr
	   .i xch2=""  s xch2=##class(web.DHCANOPCom).GetNameById(xchdr)_"!"_xchdr
	   .e  s xch2=xch2_" "_##class(web.DHCANOPCom).GetNameById(xchdr)_"!"_xchdr
	s xch=xch1_"*"_xch2_"*"_cirShiftTime
	;s xch=xch1_"*"_xch2	   
	s scNurNote=$p($G(^DHCANOPArrange(opaId)),"^",51)			//OPA_ScrubNurseNote 	器械护士,手术录入
	s cirNurNote=$p($G(^DHCANOPArrange(opaId)),"^",52)			//OPA_CirculNurseNote	巡回护士,手工录入
	s PatHeight=$P(^DHCANOPArrange(opaId),"^",22)   //wkz  0724 S
	s PatWeight=$P(^DHCANOPArrange(opaId),"^",24)
	s OPLevelDR=$P(^DHCANOPArrange(opaId),"^",28)
	i OPLevelDR'="" s OPLevel=$P($g(^ORC("CATEG",OPLevelDR)),"^",2)
	e  s OPLevel=""
	s ASADR=$P(^OR(EpisodeID,"ANA",anaSub),"^",26)
	i ASADR'="" s ASA=$P(^ORC("ASA",ASADR),"^",2)
	e  s ASA=""
	
	s operPositionId=$P($G(^OR(EpisodeID,"ANA",anaSub,"OP",1,"POS",1)),"^")
	i operPositionId'="" s operPosition=$P($G(^ORC("OPPOS",operPositionId)),"^",2)
	e  s operPosition=""
	s opDocNote=$P($G(^DHCANOPArrange(opaId)),"^",42)
	s opSeqNote=$P($G(^DHCANOPArrange(opaId)),"^",41)
	s anDocNote=$P($G(^DHCANOPArrange(opaId)),"^",43)
	s docAnMthdr=$P($g(^DHCANOPArrange(opaId,"PA")),"^",89)   //zhangtao 2010.8.27获取医生麻醉方式
	i docAnMthdr'="" d
	.s docAnMthNum=$l(docAnMthdr,"|")
	.f i=1:1:docAnMthNum d
	..s docAnMthId=$p(docAnMthdr,"|",i)
	..q:docAnMthId=""
	..s docAnMthDesc=$p($g(^ORC("ANMET",docAnMthId)),"^",2)
	..i $P(docAnMthDesc,"-",2)'="" s docAnMthDesc=$P(docAnMthDesc,"-",2)
	..i docAnMethod="" s docAnMethod=docAnMthId_"|"_docAnMthDesc
	..e  s docAnMethod=docAnMethod_"!"_docAnMthId_"|"_docAnMthDesc
	d SetRetData
	q Data
SetRetData
	s retval=itmjs_"('"_$ZCVT(anaesrw,"O","JS")_"');"
	i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(anaesrw,"O","JS")_"');"
	&javascript<#(retval)#>
	//10个一行
	s Data=opdate_"^"_oproom_" "_oproomdr_" "_opaSeq_" "_operLocDesc_" "_isAddInstrument_" "_instrumentDr_" "_instrument_"^"_regNo_"^"_patName_"^"_sex_"^"_age_"^"_opdes_" "_opdr_"^"_locdes_"^"_opd_" "_docdr_" "_appCtcpDesc_" "_appCtcpId_"^"_mzz
	s Data=Data_"^"_anmethod_" "_docAnMethod_"^"_xsh_"^"_xch_"^"_oppack_"^"_opaId_"^"_bedCode_"^"_ward_"^"_admreason_"^"_locdes_"^"_ash
	s Data=Data_"^"_diagStr_" "_digdr_"^"_arrdate_"^"_opmem_"^"_diamem_"^"_BldTypId_"^"_EpisodeID_"^"_bodsList_"^"_PatHeight_"^"_PatWeight_"^"_OPLevelDR
	s Data=Data_"^"_OPLevel_"^"_ASADR_"^"_ASA_"^"_operLocId_"^"_BldTyp_"^"_operPositionId_" "_operPosition_"^"_opDocNote_"^"_opSeqNote_"^"_OPCategory_"^"_OPStatName
	s Data=Data_"^"_mzsupdr_"^"_mzsupdoc_"^"_anDocNote_"^"_scNurNote_"^"_cirNurNote_"^"_infection_"^"_transferMeansCode_"^"_transferMeans_"^"_IsPapEstimDS
	q
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

ClassMethod GetOperationClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOperationExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetOperationExecute(ByRef qHandle As %Binary, AnID As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
    ;i type="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    ;i type="I" s ssgroup=11
    ;i type="O" s ssgroup=7
 	If $g(ind)="" Set ind=1
 	s Adm=$p(AnID,"||",1)
 	s AID=$p(AnID,"||",2)
 	;w !,"ffff"_anaId
	s rowid=0
	f  s rowid=$o(^OR(Adm,"ANA",AID,"OP",rowid)) q:rowid=""  d
	.s OperNameDr=$p(^OR(Adm,"ANA",AID,"OP",rowid),"^",6)
	.if OperNameDr'=""  do
	..s OperNameDrName=$p(^ORC("OPER",OperNameDr),"^",2)
	.s OperDiagDr=$p(^OR(Adm,"ANA",AID,"OP",rowid),"^",4)
	.if OperDiagDr'=""  do
	..s OperDiagDrName=$p(^MRC("ID",OperDiagDr),"^",2)
	.s OperSurDr=$p(^OR(Adm,"ANA",AID,"OP",rowid),"^",8)
	.if OperSurDr'=""  do
	..s OperSurDrName=$p(^SSU("SSUSR",OperSurDr),"^",2) 
	.s cnt=0
	.s OperNotes=""
	.f  s cnt=$o(^OR(Adm,"ANA",AID,"OP",rowid,"REM",cnt)) q:cnt=""  d
	..s OperNotes=OperNotes_^OR(Adm,"ANA",AID,"OP",rowid,"REM",1)
	.s rowid0=Adm_"||"_AID_"||"_rowid
 	.Do OutputRow	 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow
	set Data=$lb(rowid0,OperNameDrName,OperDiagDrName,OperSurDrName,OperNotes)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetOperationFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOperationExecute ]
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

Query GetOperation(AnID As %String) As %Query(ROWSPEC = "ID:%String,OperNameDrName:%String,OperDiagDrName:%String,OperSurDrName:%String,OperNotes:%String")
{
}

Query LookUpMrcDiagnosis(mrcidAlias As %String) As %Query(ROWSPEC = "DiagDes:%String,rowid0:%String")
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

ClassMethod JudgeCat(opId, opDocId = "") As %String
{
 q:opId="" ""
 s opCat=""
 i opDocId'="" d
 .s ctCPTId=$P($g(^CTPCP(opDocId,1)),"^",4)  	
 .i ctCPTId'="" s opCat=$g(^DHCCLSet("AnOp","PrvTp",ctCPTId,"OpCat"))
 s opCategoryId=$p(^ORC("OPER",opId),"^",7)
 q:(opCat'="")&(("^"_opCat_"^")'[("^"_opCategoryId_"^")) "您没有权限申请此类手术！"
}

Query FindOrcOperation(operDescAlias As %String, OpDocId As %String = "", ifDayOper As %String = "", surgeonLocId As %String = "") As %Query(ROWSPEC = "OPTypeDes:%String,rowid:%String,OPCategory:%String,OPStatName:%String")
{
}

/// d ##class(%ResultSet).RunQuery("web.UDHCANOPArrange","FindOrcOperation","","","","104")
ClassMethod FindOrcOperationExecute(ByRef qHandle As %Binary, operDescAlias As %String, OpDocId As %String = "", ifDayOper As %String = "", surgeonLocId As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	//取主刀医师所能开的手术分类
	k ^TMPDyl
	;s ^TMPDyl("varoper")=operDescAlias_"/"_OpDocId_"/"_ifDayOper
	s OpCat="",dnum=0,findFlag=0
	i OpDocId'="" d
		.i $d(^DHCANOPDocOper("DocOper",0,"CtcpOper",OpDocId))>0 d
	       ..s tdOperId="" f  s tdOperId=$o(^DHCANOPDocOper("DocOper",0,"CtcpOper",OpDocId,tdOperId)) q:tdOperId=""  d
	            ...q:tdOperId=""
	            ...q:$d(^ORC("OPER",tdOperId))<1
	            ...s rowid0=tdOperId
	            ...s OPTypeDes=$p($g(^ORC("OPER",tdOperId)),"^",2)
	            ...s OPCategoryId=$p(^ORC("OPER",tdOperId),"^",7)
	            ...i OPCategoryId'=""  s OPCategory=$p($g(^ORC("CATEG",OPCategoryId)),"^",2)
	    		...e  s OPCategory="" 
	    		...s opdayFlag=$p($g(^ORC("OPER",tdOperId)),"^",9)
	    		...q:(ifDayOper="Y")&(opdayFlag'=ifDayOper)
	    		...s OPStatName=$p(^ORC("OPER",tdOperId),"^",35) 
	    		...s dnum=dnum+1
	    		...s findFlag=1
	            ...Do OutputRow3
      .e  d
      	..i surgeonLocId'="" d
      		...i $d(^DHCANC("LocOperation",0,"LocOper",surgeonLocId))>0 d
      			....s tdOperId="" f  s tdOperId=$o(^DHCANC("LocOperation",0,"LocOper",surgeonLocId,tdOperId)) q:tdOperId=""  d
      				.....q:tdOperId=""
	            .....q:$d(^ORC("OPER",tdOperId))<1
	            .....s rowid0=tdOperId
	            .....s OPTypeDes=$p($g(^ORC("OPER",tdOperId)),"^",2)
	            .......s OPCategoryId=$p(^ORC("OPER",tdOperId),"^",7)
	            .....i OPCategoryId'=""  s OPCategory=$p($g(^ORC("CATEG",OPCategoryId)),"^",2)
	    		.....e  s OPCategory="" 
	    		.....s opdayFlag=$p($g(^ORC("OPER",tdOperId)),"^",9)
	    		.....q:(ifDayOper="Y")&(opdayFlag'=ifDayOper)
	    		.....s OPStatName=$p(^ORC("OPER",tdOperId),"^",35) 
	    		.....s dnum=dnum+1
	    		.....s findFlag=1
	            .....Do OutputRow3
       	..if (operDescAlias'="") d
       		...s operDescAlias=$$ALPHAUP^SSUTIL4(operDescAlias) //$ZCONVERT(operDescAlias,"U")  ypz 070313
			...s flag="N"
			...s OpDes=$O(^ORC("OPER",0,"ALIAS",operDescAlias),-1)  //ypz 070313 open
		    ...f  s OpDes=$O(^ORC("OPER",0,"ALIAS",OpDes)) q:(OpDes="")!(flag="Y")  d
		    		....i $p(OpDes,operDescAlias)'="" s flag="Y" q
		    		....s operId=""
		    		....f  s operId=$O(^ORC("OPER",0,"ALIAS",OpDes,operId)) q:operId=""  d  //ypz 070313 
		    			.....s rowid0=operId
		    			.....q:($p(^ORC("OPER",operId),"^",6)'="")&($p(^ORC("OPER",operId),"^",6)<$h)
		    			.....;20120723+dyl
		    			.....s OperDateTo=$p(^ORC("OPER",operId),"^",6)
		    			.....q:(OperDateTo'="")&(OperDateTo<$h)
		    			.....s OPTypeDes=$p(^ORC("OPER",operId),"^",2)
		    			.....s OPCategoryId=$p(^ORC("OPER",operId),"^",7)  
		    			.....i OPCategoryId'=""  s OPCategory=$p($g(^ORC("CATEG",OPCategoryId)),"^",2)
		    			.....e  s OPCategory=""  
		    			.....s opdayFlag=$p($g(^ORC("OPER",operId)),"^",9)
	    				.....q:(ifDayOper="Y")&(opdayFlag'=ifDayOper)                          
		    			.....s OPStatName=$p(^ORC("OPER",operId),"^",35)  
		    			.....s dnum=dnum+1
		    			.....s findFlag=1
		    			.....Do OutputRow3
		..e  d
			...s rowid=0
			...f  s rowid=$o(^ORC("OPER",rowid)) q:rowid=""  d
				....q:($p(^ORC("OPER",rowid),"^",6)'="")&($p(^ORC("OPER",rowid),"^",6)<$h)
				....s OPTypeDes=$p(^ORC("OPER",rowid),"^",2)
				....q:OPTypeDes'[operDescAlias
				....s opdayFlag=$p($g(^ORC("OPER",rowid)),"^",9)
	    		....q:(ifDayOper="Y")&(opdayFlag'=ifDayOper) 
				....s OPCategoryId=$p(^ORC("OPER",rowid),"^",7)    
				....i OPCategoryId'=""  s OPCategory=$p($g(^ORC("CATEG",OPCategoryId)),"^",2)
				....e  s OPCategory="" 
				....s OPStatName=$p(^ORC("OPER",rowid),"^",35)                              // +
				....s rowid0=rowid
				....s dnum=dnum+1
			 	....Do OutputRow3	 	
 e  d
    .i surgeonLocId'="" d
      	..i $d(^DHCANC("LocOperation",0,"LocOper",surgeonLocId))>0 d
      		...s tdOperId="" f  s tdOperId=$o(^DHCANC("LocOperation",0,"LocOper",surgeonLocId,tdOperId)) q:tdOperId=""  d
      			....q:tdOperId=""
	            ....q:$d(^ORC("OPER",tdOperId))<1
	            ....s rowid0=tdOperId
	            ....s OPTypeDes=$p($g(^ORC("OPER",tdOperId)),"^",2)
	            ....s OPCategoryId=$p(^ORC("OPER",tdOperId),"^",7)
	            ....i OPCategoryId'=""  s OPCategory=$p($g(^ORC("CATEG",OPCategoryId)),"^",2)
	    		....e  s OPCategory="" 
	    		....s opdayFlag=$p($g(^ORC("OPER",tdOperId)),"^",9)
	    		....q:(ifDayOper="Y")&(opdayFlag'=ifDayOper)
	    		....s OPStatName=$p(^ORC("OPER",tdOperId),"^",35) 
	    		....s dnum=dnum+1
	    		....s findFlag=1
	            ....Do OutputRow3
	.e  d
	..s operDescAlias=$$ALPHAUP^SSUTIL4(operDescAlias)
	..i operDescAlias'="" d
		...s operDescAlias=$$ALPHAUP^SSUTIL4(operDescAlias) //
		...s flag="N"
		...s OpDes=$O(^ORC("OPER",0,"ALIAS",operDescAlias),-1)  //ypz 070313 open
		...f  s OpDes=$O(^ORC("OPER",0,"ALIAS",OpDes)) q:(OpDes="")!(flag="Y")  d
		    ....i $p(OpDes,operDescAlias)'="" s flag="Y" q
		    ....s operId=""
		    ....f  s operId=$O(^ORC("OPER",0,"ALIAS",OpDes,operId)) q:operId=""  d  //ypz 070313 
		    	.....s rowid0=operId
		    	.....q:($p(^ORC("OPER",operId),"^",6)'="")&($p(^ORC("OPER",operId),"^",6)<$h)
		    	.....;20120723+dyl
		    	.....s OperDateTo=$p(^ORC("OPER",operId),"^",6)
		    	.....q:(OperDateTo'="")&(OperDateTo<$h)
		    	.....s OPTypeDes=$p(^ORC("OPER",operId),"^",2)
		    	.....s OPCategoryId=$p(^ORC("OPER",operId),"^",7)  
		    	.....i OPCategoryId'=""  s OPCategory=$p($g(^ORC("CATEG",OPCategoryId)),"^",2)
		    	.....e  s OPCategory=""    
		    	.....s opdayFlag=$p($g(^ORC("OPER",operId)),"^",9)
	    		.....q:(ifDayOper="Y")&(opdayFlag'=ifDayOper)        
		    	.....s OPStatName=$p(^ORC("OPER",operId),"^",35)  
		    	.....s dnum=dnum+1
		    	.....Do OutputRow3
	..e  d
		...s rowid=0
		...f  s rowid=$o(^ORC("OPER",rowid)) q:rowid=""  d
			....q:($p(^ORC("OPER",rowid),"^",6)'="")&($p(^ORC("OPER",rowid),"^",6)<$h)
			....s OPTypeDes=$p(^ORC("OPER",rowid),"^",2)
			....q:OPTypeDes'[operDescAlias
			....s OPCategoryId=$p(^ORC("OPER",rowid),"^",7)    // + wxl 090316 手术分类
			....i OPCategoryId'=""  s OPCategory=$p($g(^ORC("CATEG",OPCategoryId)),"^",2)
			....e  s OPCategory="" 
			....s opdayFlag=$p($g(^ORC("OPER",rowid)),"^",9)
	    	....q:(ifDayOper="Y")&(opdayFlag'=ifDayOper)        
			....s OPStatName=$p(^ORC("OPER",rowid),"^",35)  // + wxl 090819 手术统计名称                            // +
			....s rowid0=rowid
		 	....Do OutputRow3	 	

       
	 Set qHandle=$lb(0,repid,0) 
  	
	Quit $$$OK
    
OutputRow3
	set Data=$lb(OPTypeDes,rowid0,OPCategory,OPStatName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetGradingStaff(n)
{
  s idStr=""
  f i=1:1:n d
  .s id=$p(^TMPCPT,"^",i)
  .if idStr="" s idStr=id
  .e  s idStr=idStr_"^"_id
  q idStr
}

ClassMethod FindOrcOperationFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOrcOperationExecute ]
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

ClassMethod FindOrcOperationClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOrcOperationExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindAncOperRoom(oprDesc As %String, locDescOrId As %String, locListCodeStr As %String = "", EpisodeID As %String, opaId As %String, oprBedType As %String, appLocDescOrId As %String = "") As %Query(ROWSPEC = "oprId:%String,oprDesc:%String,oprCode:%String")
{
}

ClassMethod FindAncOperRoomExecute(ByRef qHandle As %Binary, needOprDesc As %String = "", locDescOrId As %String = "", locListCodeStr As %String = "OP^OUTOP^EMOP", EpisodeID As %String = "", opaId As %String = "", oprBedType As %String = "T", appLocDescOrId As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s LogLocId=%session.Data("LOGON.CTLOCID")
	s curHospId=%session.Data("LOGON.HOSPID")	;当前登陆的医院Id
 	s LogLocTyp=$p(^CTLOC(LogLocId),"^",13)
 	s appLocId=""
 	i appLocDescOrId'="" d
 		.i appLocDescOrId=+appLocDescOrId s appLocId=appLocDescOrId
 		.e  d
		..s appLocDesc=$$ALPHAUP^SSUTIL4(appLocDescOrId)
		..s appLocId=$o(^CTLOC(0,"Desc",appLocDesc,""))
	s ctlocIdList=""
	i locDescOrId'="" d
		.i locDescOrId=+locDescOrId s ctlocIdList=locDescOrId
		.e  d
			..s locDesc=$$ALPHAUP^SSUTIL4(locDescOrId)
			..s ctlocIdList=$o(^CTLOC(0,"Desc",locDesc,""))
	s locListCodeStr=##class(web.DHCClinicCom).AdjustLocListCode(locListCodeStr,EpisodeID)
	i ctlocIdList="" s ctlocIdList=##class(web.DHCClinicCom).GetLocIdByLocListCode(locListCodeStr)
	
	i opaId'="" d
		.k oprIdList
		.s opaStartDate=$p($g(^DHCANOPArrange(opaId)),"^",14)
		.q:opaStartDate=""
		.s opaId=""
	    .f  s opaId=$O(^DHCANOPArrange(0,"SDate",+opaStartDate,opaId)) q:opaId=""  d 
		    ..q:'$d(^DHCANOPArrange(opaId))
		    ..s oprId=$p($g(^DHCANOPArrange(+opaId)),"^",20)
		    ..i oprId'="" s oprIdList(oprId)=$g(oprIdList(oprId))+1
	s oprId=0,locHosId=""
	f  s oprId=$o(^DHCANC("OPRoom",oprId)) q:oprId=""  d
		.q:(oprBedType'="")&(oprBedType'[$p(^DHCANC("OPRoom",oprId),"^",9)) //OPR_BedType T-手术床,P-术后恢复床,I-预麻床
		.q:$p(^DHCANC("OPRoom",oprId),"^",7)="N"  //停用的手术间不起用
		.q:($p(^DHCANC("OPRoom",oprId),"^",9)'=oprBedType)&(oprBedType'="")
		.s ctlocId=$P(^DHCANC("OPRoom",oprId),"^",3)
		.i ctlocId'="" d
		..s locHosId=$p(^CTLOC(ctlocId),"^",22)
		.q:(curHospId'=locHosId)&(locHosId'="")
		.q:(ctlocIdList'="")&(("^"_ctlocIdList_"^")'[("^"_ctlocId_"^"))
		.s oprDesc=$P(^DHCANC("OPRoom",oprId),"^",2)
		.q:(needOprDesc'="")&($p(oprDesc,needOprDesc)'="")
		.i $d(oprIdList(oprId)) s oprDesc=oprDesc_"("_oprIdList(oprId)_"台)"
		.s oprCode=$P(^DHCANC("OPRoom",oprId),"^",1)
		.s DefLocId=$p(^DHCANC("OPRoom",oprId),"^",6)
		.q:(LogLocTyp'="OP")&(DefLocId'="")&(DefLocId'=LogLocId)&(DefLocId'=appLocId)
		.//q:(LogLocTyp'="OP")&((DefLocId="")!((appLocId="")&(DefLocId'=LogLocId))!((appLocId'="")&(DefLocId'=appLocId)))
		.Do OutputRow6
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow6
	set Data=$lb(oprId,oprDesc,oprCode)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod FindAncOperRoomFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAncOperRoomExecute ]
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
	Else {				// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindAncOperRoomClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAncOperRoomExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query FindAnaestMethod(anmethod = "") As %Query(ROWSPEC = "Des:%String,ID:%String")
{
}

ClassMethod FindAnaestMethodExecute(ByRef qHandle As %Binary, anmethod As %String) As %Status
{
 Set repid=$I(^CacheTemp)
 ;i type="" Set qHandle=$lb(0,repid,0) Quit $$$OK
 s anmethod = $ZConvert(anmethod, "U") // by yys 090330
 If $g(ind)="" Set ind=1
 s rowid=0
	f  s rowid=$o(^ORC("ANMET",rowid)) q:rowid=""  d
	.s Dateto=$p(^ORC("ANMET",rowid),"^",6)
	.q:(Dateto'="")&(Dateto<=+$h)
	.s ID=rowid  //$p(^ORC("ANMET",rowid),"^",1)
	.s Des=$p(^ORC("ANMET",rowid),"^",2)
	.q:(Des'[anmethod)&(anmethod'="")
	.i $p(Des,"-",2)'="" s Des=$p(Des,"-",2)
 	.Do OutputRow7	 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK

OutputRow7
	set Data=$lb(Des,ID)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
	quit
}

ClassMethod FindAnaestMethodFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAnaestMethodExecute ]
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

ClassMethod FindAnaestMethodClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAnaestMethodExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetQtPrintData(opaId As %String) As %String
{
	s printdt="",bedCode="",opmem="",mzz="",ash="",xsh="",xch="",opsttime="",arrTime="",ctpcpDesc=""
	s printdt=$ZD($P($H,",",1),3)_" "_$ZT($P($H,",",2))
	s userId=%session.Data("LOGON.USERID")
	s ctpcpId=$p($g(^SSU("SSUSR",userId)),"^",14)
	i ctpcpId'="" d
	.s ctpcpDesc=$P($g(^CTPCP(ctpcpId,1)),"^",2)
	s opsttime=$P($g(^DHCANOPArrange(opaId)),"^",15)
	s arrTime=$P($g(^DHCANOPArrange(opaId)),"^",8)
	i opsttime'="" s opsttime=$zt(opsttime,2) 
	i arrTime'="" s arrTime=$zt(arrTime,2)
	i arrTime'="" s opTime=arrTime
	e  s opTime=opsttime
	s opmem=$P(^DHCANOPArrange(opaId),"^",19)
    s adm=$P(^DHCANOPArrange(opaId),"^",1)
    s chl=$P($P(^DHCANOPArrange(opaId),"^",2),"||",2)  
	s bedSub=$p($p($g(^PAADM(adm)),"^",73),"||",2)
	s curWardId=$p($g(^PAADM(adm)),"^",70)
    s bedCode="" i bedSub'="" s bedCode=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)
	s sub=0  s sub=$O(^OR(adm,"ANA",chl,"OP",sub)) 
	q:sub="" ""
	s mzdr=$P(^OR(adm,"ANA",chl),"^",6)        ; ANA_Anaesthetist_Dr 
	   i mzdr'="" d
	   .//s mzdoc=$TR($P(^CTPCP(mzdr,1),"^",2)," ","") ;麻醉医师
	   .s mzdoc=##class(web.DHCANOPCom).GetNameById(mzdr)
	   e  s mzdoc=""
	   
	s anaId=$p(^DHCANOPArrange(opaId),"^",2)
	s EpisodeID=+anaId
    s anaSub=$p(anaId,"||",2)
    s anaopSub=0,mzdoc1="",jmzdoc="",jmzdoc1=""
    f  s anaopSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)) q:anaopSub=""  d
        .q:$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",12)'="M"
        .s bodsIdList=$P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",24) 	 
	    .s bodsList=""
	    .i bodsIdList'="" d
	    ..s bodsIdNum=$l(bodsIdList,"|")
	    ..f j=1:1:bodsIdNum d
	    ...s bodsId=$p(bodsIdList,"|",j)
	    ...q:bodsId=""
	    ...s bodsDesc=$p($g(^OEC("BODS",+bodsId)),"^",2)
	    ...i bodsList="" s bodsList=bodsDesc
	    ...e  s bodsList=bodsList_","_bodsDesc 
        .s mzdr1=$g(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ANASS",1))
        .//i mzdr1'="" s mzdoc1=$TR($P(^CTPCP(mzdr1,1),"^",2)," ","")
        .i mzdr1'="" s mzdoc1=##class(web.DHCANOPCom).GetNameById(mzdr1)
        .
        .s jmzdr=$g(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ANASS",11))
        .//i jmzdr'="" s jmzdoc=$TR($P(^CTPCP(jmzdr,1),"^",2)," ","")
        .i jmzdr'="" s jmzdoc=##class(web.DHCANOPCom).GetNameById(jmzdr)
        .
        .s jmzdr1=$g(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ANASS",12))
        .//i jmzdr1'="" s jmzdoc1=$TR($P(^CTPCP(jmzdr1,1),"^",2),"","")
        .i jmzdr1'="" s jmzdoc1=##class(web.DHCANOPCom).GetNameById(jmzdr1)

	   /*s mzdr1=$P(^OR(adm,"ANA",chl),"^",7)        ; ANA_Anaesthetist_Dr 
	   i mzdr1'="" d
	   .s mzdoc1=$TR($P(^CTPCP(mzdr1,1),"^",2)," ","") ;麻醉医师
	   e  s mzdoc1=""
	   
	   s jmzdr=$P(^OR(adm,"ANA",chl),"^",8)        ; ANA_Anaesthetist_Dr 
	   i jmzdr'="" d
	   .s jmzdoc=$TR($P(^CTPCP(jmzdr,1),"^",2)," ","") ;麻醉医师
	   e  s jmzdoc=""
	   
	   s jmzdr1=$P(^OR(adm,"ANA",chl),"^",9)        ; ANA_Anaesthetist_Dr 
	   i jmzdr1'="" d
	   .s jmzdoc1=$TR($P(^CTPCP(jmzdr1,1),"^",2)," ","") ;麻醉医师
	   e  s jmzdoc1=""
	   */
	   s mzz=mzdoc_" "_mzdoc1_" "_jmzdoc_" "_jmzdoc1
	   s p=0  ;助手
	   s ash=""
	   s as=0 f  s as=$O(^OR(adm,"ANA",chl,"OP",sub,"ASS",as)) q:(as="")!(p=3)  d
	   .s asdr=$P(^OR(adm,"ANA",chl,"OP",sub,"ASS",as),"^",1)
	   .q:asdr=""
	   .s p=p+1
	   .//s ash=ash_$TR($P($g(^CTPCP(asdr,1)),"^",2)," ","")_" "  ;
	   .s ash=ash_##class(web.DHCANOPCom).GetNameById(asdr)
	   s p=0  ;洗手
	   s xs=0 f  s xs=$O(^OR(adm,"ANA",chl,"OP",sub,"SCN",xs)) q:(xs="")!(p=2)  d
	   .s xsdr=$P(^OR(adm,"ANA",chl,"OP",sub,"SCN",xs),"^",1)
	   .q:xsdr=""
	   .//s p=p+1
	   .//s xsh=xsh_$TR($P($g(^CTPCP(xsdr,1)),"^",2)," ","")_" "  ;
	   .s xsh=xsh_##class(web.DHCANOPCom).GetNameById(xsdr)
	   s p=0  ;巡床
	   s xc=0 f  s xc=$O(^OR(adm,"ANA",chl,"OP",sub,"CIRN",xc)) q:(xc="")!(p=2)   d
	   .s xchdr=$P(^OR(adm,"ANA",chl,"OP",sub,"CIRN",xc),"^",1)
	   .q:xchdr=""
	   .//s p=p+1
	   .//s xch=$G(xch)_$TR($P($g(^CTPCP(xchdr,1)),"^",2)," ","")_" "
	   .s xch=$g(xch)_##class(web.DHCANOPCom).GetNameById(xchdr)
	 s NeedPathologSection=$p(^DHCANOPArrange(opaId,"Care"),"^",21)
	 s str=printdt_"^"_bedCode_"^"_opmem_"^"_mzz_"^"_ash_"^"_xsh_"^"_xch_"^"_opTime_"^"_bodsList_"^"_NeedPathologSection_"^"_ctpcpDesc
	 q str
}

ClassMethod GetQTData(opaId As %String) As %String
{
	s jbanadocdes="", jbnurdes="", jbxunurdes="",jb=0
	s note="",opreq="",strcheck="",jbnur="",jbxunur="",jbanadoc="",OpPack=""
	if $D(^DHCANARRAGE("ch",opaId)) s strcheck=^DHCANARRAGE("ch",opaId)
    s yg=$P($g(^DHCANOPArrange(opaId,"PALab")),"^",29)						//OPA_PATestHBsAg  	免疫乙肝表面抗原
	s bg=$P($g(^DHCANOPArrange(opaId,"PALab")),"^",34)						//OPA_PATestHCVAb 	免疫丙型肝炎抗体
	s az=$P($g(^DHCANOPArrange(opaId,"PALab")),"^",35)						//OPA_PATestHivAb 	免疫艾滋病毒抗体
	s md=$P($g(^DHCANOPArrange(opaId,"PALab")),"^",36)						//OPA_PATestTPAb 	免疫梅毒
	s PATestOther=$P($g(^DHCANOPArrange(opaId,"PALab")),"^",2)				//OPA_PATestOther	检其它阴阳性
	s adm=$P(^DHCANOPArrange(opaId),"^",1)
    s chl=$P($P(^DHCANOPArrange(opaId),"^",2),"||",2)
	s jzstat=$P(^OR(adm,"ANA",chl),"^",32)   								//ANA_SourceType 急诊(E)/择期(B)
	if jzstat="E" s jz=1
	e  s jz=0
	s RHBloodType=$P(^DHCANOPArrange(opaId),"^",25)							//OPA_RHBloodType	RH血型
	s Isolated=$P(^DHCANOPArrange(opaId),"^",10)						  	//OPA_Isolated		是否隔离
	s PrepareBlood=$P(^DHCANOPArrange(opaId),"^",33)						//OPA_PrepareBlood	是否备血
	s UseSelfBlood=$P(^DHCANOPArrange(opaId),"^",34)						//OPA_UseSelfBlood	是否自体血回输
	s ExCirculation=$P(^DHCANOPArrange(opaId),"^",36)						//OPA_ExCirculation	是否体外循环
	s NeedAnaesthetist=$P(^DHCANOPArrange(opaId),"^",44)					//OPA_NeedAnaesthetist是否麻醉会诊
	s MiniInvasive=$P(^DHCANOPArrange(opaId),"^",13) 						//OPA_MiniInvasive	是否微创手术
	s NeedNavigation=$P(^DHCANOPArrange(opaId),"^",55)                      //OPA_NeedNavigation 是否导航
	//s NeedPathologSection=$p(^DHCANOPArrange(opaId,"Care"),"^",21)
	s NeedPathologSection=""
	s unPlanedOper="" 	//20160114
	s unPlanedOper=$P($g(^DHCANOPArrange(opaId)),"^",46)
	//日间手术
	s dayOperFlag="" 
	s anaId=$P($g(^DHCANOPArrange(opaId)),"^",2)
	s anasub=$p(anaId,"||",2)
	s AdmId=$p(anaId,"||",1)
	s dayOperFlag=$P($g(^OR(AdmId,"ANA",anasub,"OP",1)),"^",22)

	s strcheck=yg_"^"_bg_"^"_az_"^"_md_"^"_jz_"^"_PATestOther_"^"_RHBloodType_"^"_Isolated_"^"_PrepareBlood_"^"_UseSelfBlood
	s strcheck=strcheck_"^"_ExCirculation_"^"_NeedAnaesthetist_"^"_MiniInvasive_"^"_NeedNavigation_"^"_NeedPathologSection_"^"_unPlanedOper_"^"_dayOperFlag

    if $D(^DHCANARRAGE("note",opaId)) s note=^DHCANARRAGE("note",opaId)
	if $D(^DHCANARRAGE("opreq",opaId)) s opreq=^DHCANARRAGE("opreq",opaId)
	if $D(^DHCANARRAGE("Pack",opaId)) s OpPack=^DHCANARRAGE("Pack",opaId)
	if $D(^DHCANARRAGE("jb",opaId)) s jb=^DHCANARRAGE("jb",opaId)
   q strcheck_"$"_note_"$"_opreq_"$"_jbnurdes_" "_jbnur_"$"_jbxunurdes_" "_jbxunur_"$"_jb_"$"_jbanadocdes_" "_jbanadoc_"$"_OpPack
}

ClassMethod checkquExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    s typ="不详",ord=1
    d output111
    s typ="阴性(-)",ord=2
    d output111
    s typ="阳性(+)",ord=3
    d output111
    s typ="化验中",ord=4 
    d output111  
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
   
output111
 set Data=$lb(ord,typ)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod checkquFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = checkquExecute ]
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

ClassMethod checkquClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = checkquExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

// Query FindCtcp(ctcptdes As %String, EpisodeID As %String, locdes As %String = "") As %Query(ROWSPEC = "username,ctcpId")

/// Creator: ypz
/// CreatDate: 2010-06-10
/// Description: 取医护人员
/// Table：CT_Loc,RB_Resource,PA_Adm,DHC_ANOPArrange,CT_LocationList
/// Input：needCtcpDesc医护人员姓名前面部分, 
/// 			locListCodeStr科室列表"^"分割的代码串："INOPDEPT"住院手术科室,"OUTOPDEPT"门诊手术科室,"EMOPDEPT"急诊手术科室,
/// 			"AN"麻醉科,"OP"手术室,"OUTAN"门诊麻醉科,"OUTOP"手术室,"EMAN"急诊麻醉科,"EMOP"急诊手术室,"ICU"重症科室,
/// 			locDescOrId科室名或科室Id, EpisodeID就诊号, opaId手术排班Id, ifDoctor是否医生(Y/N)为空是全部, ifSurgeon是否医生(Y)
/// Output：用户Id,用户描述
/// d ##class(%ResultSet).RunQuery("web.UDHCANOPArrange","FindCtcp","","INOPDEPT^OUTOPDEPT^EMOPDEPT","","","","Y","Y","Y",2)
Query FindCtcp(needCtcpDesc As %String, locListCodeStr As %String, locDescOrId As %String = "", EpisodeID As %String = "", opaId As %String = "", ifDoctor As %String = "", ifSurgeon As %String = "", ifDayOper As %String = "", operId As %String = "") As %Query(ROWSPEC = "ctcpId,ctcpDesc,ctcpAlias")
{
}

ClassMethod FindCtcpExecute(ByRef qHandle As %Binary, needCtcpDesc As %String, locListCodeStr As %String, locDescOrId As %String = "", EpisodeID As %String = "", opaId As %String = "", ifDoctor As %String = "", ifSurgeon As %String = "", ifDayOper As %String = "", operId As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	k ^TMPCTCP($j)
	;需要时解开
	k ^TMPDyl("var")
	s ^TMPDyl("var")=needCtcpDesc_"/"_locListCodeStr_"/"_locDescOrId_"/"_EpisodeID_"/"_opaId_"/"_ifDoctor_"/"_ifSurgeon _"*"_operId_"*"_ifDayOper
	s needCtcpDesc=$$ALPHAUP^SSUTIL4(needCtcpDesc)
	s ctlocIdList=""
	i locDescOrId'="" d
		.i locDescOrId=+locDescOrId s ctlocIdList=locDescOrId
		.e  d
			..s locDesc=$$ALPHAUP^SSUTIL4(locDescOrId)
			..s ctlocIdList=$o(^CTLOC(0,"Desc",locDesc,""))
	i EpisodeID="",opaId'="" s EpisodeID=$P($g(^DHCANOPArrange(opaId)),"^",1)
	s locListCodeStr=##class(web.DHCClinicCom).AdjustLocListCode(locListCodeStr,EpisodeID)
	i ctlocIdList="" s ctlocIdList=##class(web.DHCClinicCom).GetLocIdByLocListCode(locListCodeStr)
	i needCtcpDesc="",ctlocIdList="" s ind=1 s qHandle=$lb(0,repid,0) Quit $$$OK
	
	//查询提示已安排手术间的麻醉科医生、手术室护士
	i ((locListCodeStr_"^")["AN^")!((locListCodeStr_"^")["OP^") d
		.s opaStartDate=$p($g(^DHCANOPArrange(+opaId)),"^",14)
		.q:opaStartDate=""
    	.k ctcpList
    	.s opaId=""
    	.f  s opaId=$O(^DHCANOPArrange(0,"SDate",+opaStartDate,opaId)) q:opaId=""  d 
	    	..q:'$d(^DHCANOPArrange(opaId))
	    	..s oprId=$P($G(^DHCANOPArrange(opaId)),"^",20)
    		..q:oprId=""
    		..s oprDesc=$p(^DHCANC("OPRoom",oprId),"^",2)
	    	..s anaId=$P(^DHCANOPArrange(opaId),"^",2)
	    	..s EpisodeID=+anaId
	    	..s anaSub=$p(anaId,"||",2)
	    	..i ((locListCodeStr_"^")]"AN^") d
	    		...s anaSuperCtcpId=$P(^OR(EpisodeID,"ANA",anaSub),"^",7)
	    		...d SetCtcp(anaSuperCtcpId,oprDesc)
	    		...s anaesthCtcpId=$P(^OR(EpisodeID,"ANA",anaSub),"^",6)
	    		...d SetCtcp(anaesthCtcpId,oprDesc)
	    		...s anaopSub=0 
				...f  s anaopSub=$O(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)) q:(anaopSub="")  d
		    		....i $P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",12)'="M" q
		    		....s anassSub=0
		    		....i $P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",12)'="M" q
		    		....f  s anassSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ANASS",anassSub)) q:anassSub=""  d
		        		.....s ctcpId=$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ANASS",anassSub),"^")
		        		.....d SetCtcp(ctcpId,oprDesc)
	    	..q:(locListCodeStr_"^")'["OP^"
	    	..s anaopSub=0 
			..f  s anaopSub=$O(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)) q:(anaopSub="")  d
		    	...i $P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",12)'="M" q
		    	...s scnSub=0
		    	...f  s scnSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"SCN",scnSub)) q:scnSub=""  d
		        	....s ctcpId=$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"SCN",scnSub),"^")
		        	....d SetCtcp(ctcpId,oprDesc)
		    	...s cirnSub=0
		    	...f  s cirnSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"CIRN",cirnSub)) q:cirnSub=""  d
		        	....s ctcpId=$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"CIRN",cirnSub),"^")
		        	....d SetCtcp(ctcpId,oprDesc)
	s ctcptIdStr=$g(^DHCCLSet("AnOp","OpDocTp")) //能为主刀医师的医护人员类型
	s curHospId=%session.Data("LOGON.HOSPID")
	s find=0
	i operId'="" d
		.q:$d(^DHCANOPDocOper("DocOper",0,"OperCtcp",operId))<0 
		.s newctcpid=""
		.f  s newctcpid=$o(^DHCANOPDocOper("DocOper",0,"OperCtcp",operId,newctcpid)) q:newctcpid=""  d
			..s ctcpId=newctcpid
			..q:ctcpId=""
			..s ctcpDayFlag=$g(^DHCANOPDaySurgeryAut(ctcpId))
			..;q:(ifDayOper="Y")&(ctcpDayFlag'=ifDayOper)
			..s ctcptId=$p($g(^CTPCP(ctcpId,1)),"^",4)
			..q:ctcptId=""
			..q:(ifSurgeon="Y")&((locListCodeStr_"^")["OPDEPT^")&((ctcptIdStr'="")&(("^"_ctcptIdStr_"^")'[("^"_ctcptId_"^")))
			..s ctcptType=$p($g(^CT("CPT",ctcptId)),"^",4)
			..q:(ifDoctor'="")&(ifDoctor="Y")&(ctcptType'="DOCTOR")
			..q:(ifDoctor'="")&(ifDoctor'="Y")&(ctcptType'="NURSE")
			..//s ctcpDesc=$p($g(^CTPCP(ctcpId,1)),"^",2)
			..s ctcpDesc=##class(web.DHCANOPCom).GetNameById(ctcpId)
			..q:($p(ctcpDesc,needCtcpDesc)'="")&(needCtcpDesc'="")&(..MatchName(ctcpId,needCtcpDesc)=0)
			..s ctcpDesc=ctcpDesc_$g(ctcpList(ctcpId))
			..s ctcpAlias=$p($g(^CTPCP(ctcpId,3)),"^",28)
			..s ^TMPCTCP($j,1,ctcpId)=$lb(ctcpId,ctcpDesc,ctcpAlias)
			..s find=1
	i find=1
	{
		s n="" 
		f  s n=$o(^TMPCTCP($j,n)) q:n=""  d
		.s ctcptId=""  f  s ctcptId=$o(^TMPCTCP($j,n,ctcptId)) q:ctcptId=""  d
		..d Outputcpt
		Set qHandle=$lb(0,repid,0) Quit $$$OK
	}
	;i (operId'="")&(find=0) Set qHandle=$lb(0,repid,0) Quit $$$OK
	f i=1:1:$l(ctlocIdList) d
		.s ctlocId=$p(ctlocIdList,"^",i)
		.q:ctlocId=""
		.s hospId=$P($g(^CTLOC(ctlocId)),"^",22)
		.q:(hospId'="")&(curHospId'="")&(hospId'=curHospId)
		.s resId=""
		.f  s resId=$O(^RB("RES",0,"CTLOC",ctlocId,resId))  q:resId=""  d
			..s ctcpId=$P(^RB("RES",resId),"^",2)
			..q:ctcpId=""
			..s ctcpDayFlag=$g(^DHCANOPDaySurgeryAut(ctcpId))
			..;q:(ifDayOper="Y")&(ctcpDayFlag'=ifDayOper)	;日间限制
			..s ctcptId=$p($g(^CTPCP(ctcpId,1)),"^",4)
			..q:ctcptId=""
			..q:(ifSurgeon="Y")&((locListCodeStr_"^")["OPDEPT^")&((ctcptIdStr'="")&(("^"_ctcptIdStr_"^")'[("^"_ctcptId_"^")))
			..s ctcptType=$p($g(^CT("CPT",ctcptId)),"^",4)
			..q:(ifDoctor'="")&(ifDoctor="Y")&(ctcptType'="DOCTOR")
			..q:(ifDoctor'="")&(ifDoctor'="Y")&(ctcptType'="NURSE")
			..//s ctcpDesc=$p($g(^CTPCP(ctcpId,1)),"^",2)
			..s ctcpDesc=##class(web.DHCANOPCom).GetNameById(ctcpId)
			..q:($p(ctcpDesc,needCtcpDesc)'="")&(needCtcpDesc'="")&(..MatchName(ctcpId,needCtcpDesc)=0)
			..s ctcpDesc=ctcpDesc_$g(ctcpList(ctcpId))
			..s ctcpAlias=$p($g(^CTPCP(ctcpId,3)),"^",28)
			..s ^TMPCTCP($j,1,ctcpId)=$lb(ctcpId,ctcpDesc,ctcpAlias)
			..;Do Outputcpt
		.s ctcptOtherId = ""
		.s list = ..FindOtherCtcp(ctlocId,needCtcpDesc,ifDoctor) //liangqi 100906 查询外院医护人员
		.q:list.Size=""
		.f j=1:1:list.Size d
		..s str = list.GetAt(j)
		..s ctcptOtherId = "~"_$p(str,"^",1)
		..s ctcpDesc = $p(str,"^",2)_$g(ctcpList(ctcptOtherId))
		..s ctcpAlias=$p(str,"^",3)
		..s ^TMPCTCP($j,2,ctcptOtherId)=$lb(ctcptOtherId,ctcpDesc,ctcpAlias)
		..;d Outputothercpt
		s n="" 
		f  s n=$o(^TMPCTCP($j,n)) q:n=""  d
		.s ctcptId=""  f  s ctcptId=$o(^TMPCTCP($j,n,ctcptId)) q:ctcptId=""  d
		..d Outputcpt
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
SetCtcp(ctcpId,oprDesc)
	q:(ctcpId="")
	q:$g(ctcpList(ctcpId))[("("_oprDesc_")")
	s ctcpList(ctcpId)=$g(ctcpList(ctcpId))_"("_oprDesc_")"
	q

Outputcpt
 set Data=$lb(ctcpId,ctcpDesc)
 Set ^CacheTemp(repid,ind)=^TMPCTCP($j,n,ctcptId)
 Set ind=ind+1
 quit
}

ClassMethod FindCtcpFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCtcpExecute ]
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

ClassMethod FindCtcpClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCtcpExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod MatchName(ctcpId As %String, name As %String, exact As %Boolean = 1)
{
	q:(ctcpId="")!(name="") 0
	s userEmailName = ##class(DHCANOPCom).GetCtcpUserEmailName(ctcpId)
	s userEmailName = $p(userEmailName,"-",1)
	s userInitials=##class(DHCANOPCom).GetCtcpUserInitials(ctcpId)
	s ctcpAlias=$p($g(^CTPCP(ctcpId,3)),"^",28)
	s ctcpAlias=$$ALPHAUP^SSUTIL4(ctcpAlias)
	if exact
	{
		q (userEmailName=name)||(userInitials=name)||(ctcpAlias=name)
	}
	else 
	{
		q (userEmailName_$c(3)_userInitials_$c(3)_ctcpAlias)[name
	}
}

ClassMethod FindOtherCtcp(locId As %String, nameOralias As %String, ifDoc As %String)
{
	
	s rowId = ""
	s list = ##class(%Library.ListOfDataTypes).%New()
	
	i locId '= ""
	{
		f {
			s rowId = $o(^DHCCLCPI("CtLoc",+locId,rowId)) 
			q:rowId=""
			d OutPut
		}
	}
	else
	{
		f {
			s rowId = $o(^DHCCLCP(rowId))
			q:rowId=""
			d OutPut
		}
	}
	
	q list
	
OutPut
	s str =..GetOtherCtcp(rowId,nameOralias ,ifDoc)
	i str '= ""{
		d list.Insert(str)
	}
	q
}

ClassMethod GetOtherCtcp(rowId, nameOralias, ifDoc As %String) As %String
{
	q:rowId="" ""
	
	i ifDoc '= "" {
		i ifDoc = "Y" s ifDoc = 1
		i ifDoc = "N" s ifDoc = 0
	}
	
	s ctName = "", ctAlias = "", ctIfDoc = "",inActive = ""
	s glb = ^DHCCLCP(rowId)
	s inActive = $list(glb,6)
	q:inActive ""	//已离开
	s ctName = $list(glb,2)
	s ctAlias = $list(glb,3)
	q:((nameOralias '= "") && (nameOralias'= ctName) && (nameOralias'= ctAlias)) ""
	s ctIfDoc = $list(glb,7)
	q:((ifDoc '= "") && (+ifDoc '= ctIfDoc)) ""
	s typeCode=$li(glb,8)
    s typeId="",typeDes="" 
    f  s typeId=$o(^DHCCLComCode("UserType",typeId)) q:typeId=""  d
    .i $p(^DHCCLComCode("UserType",typeId),"^",1)=typeCode d
    ..s typeDes=$p(^DHCCLComCode("UserType",typeId),"^",2)
    s ctName=ctName_"("_typeDes_")"
	q rowId_"^"_ctName_"^"_ctAlias
}

Query checkqu() As %Query(ROWSPEC = "ord,typ")
{
}

Query OPPack() As %Query(ROWSPEC = "Id,Pack")
{
}

ClassMethod OPPackFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = OPPackExecute ]
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

ClassMethod OPPackExecute(ByRef qHandle As %Binary) As %Status
{
	 Set repid=$I(^CacheTemp)
     If $g(ind)="" Set ind=1
	 s opaId="" f  s opaId=$O(^User.DHCANOPPACKD(opaId)) q:opaId=""  d
	 .s Pack=$LIST(^User.DHCANOPPACKD(opaId),3)
	 .Do Output2	
     Set qHandle=$lb(0,repid,0)
	 Quit $$$OK

Output2
 set Data=$lb(Pack,opaId)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
	quit
}

ClassMethod OPPackClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = OPPackExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// w ##class(web.UDHCANOPArrange).GetDocLoc(600)
ClassMethod GetDocLoc(userId As %String = "", ctlocId As %String = "") As %String
{
	n (userId,ctlocId)
	q:userId="" ""	
	;i +userId=0 s userId=%session.Data("LOGON.USERID")
	;s ctlocId=%session.Data("LOGON.CTLOCID")

	i ctlocId="" s ctlocId=$P($g(^SSU("SSUSR",+userId)),"^",4)
	s function="",ctlocDesc=""
	if ctlocId'=""
	{
	  s ctlocDesc=$P(^CTLOC(ctlocId),"^",2)
	  s function=$P(^CTLOC(ctlocId),"^",13)
	}
	if function'="E"
	{
		s ctlocId="",ctlocDesc=""
	} 
	q ctlocDesc_"^"_ctlocId
}

// 20170517+dyl

// w ##class(web.UDHCANOPArrange).GetIfOperLoc(43)

ClassMethod GetIfOperLoc(ctlocId As %String = "") As %String
{
	q:ctlocId="" ""	

	s function="",ctlocDesc=""
	if ctlocId'=""
	{
	  s ctlocDesc=$P(^CTLOC(ctlocId),"^",2)
	  s function=$P(^CTLOC(ctlocId),"^",13)
	}
	q:function'="OP" ""
	s ctlocIdList=""
		s locListId=$o(^CT("LL",0,"Code","OUTOP",""))
		q:locListId=""
		s locListLocId=0
		f  s locListLocId=$o(^CT("LL",locListId,"LOC",locListLocId)) q:locListLocId=""  d
			.s octlocId=$p(^CT("LL",locListId,"LOC",locListLocId),"^")
			.q:octlocId=""
			.q:'$d(^CTLOC(octlocId))
			.i ctlocIdList'="" s ctlocIdList=ctlocIdList_"^"
			.s ctlocIdList=ctlocIdList_octlocId
	;b
	s ret=""
	i ("^"_ctlocIdList_"^")[("^"_ctlocId_"^") s ret="OUT"
	q ret
}

// 获取病区

ClassMethod GetNurWard(userId As %String = "", ctlocId As %String = "") As %String
{
	n (userId,ctlocId)
	q:userId="" ""	
	;i +userId=0 s userId=%session.Data("LOGON.USERID")
	;s ctlocId=%session.Data("LOGON.CTLOCID")

	i ctlocId="" s ctlocId=$P($g(^SSU("SSUSR",+userId)),"^",4)
	s function="",ctlocDesc="",wardId=""
	if ctlocId'=""
	{
	  s ctlocDesc=$P(^CTLOC(ctlocId),"^",2)
	  s function=$P(^CTLOC(ctlocId),"^",13)
		i function="W" d
			.s wardId=$o(^PAWARD(0,"WARD_LocationDR",ctlocId,""))

	}
	if function'="W"
	{
		q ""
	} 
	q ctlocDesc_"^"_wardId_"^"_ctlocId
}

Query FindBodySite() As %SQLQuery(CONTAINID = 1, ROWSPEC = "BODS_RowId:%Integer,BODS_Desc:%String")
{
    select BODS_RowId,BODS_Desc from SQLUser.OEC_BodySite
}

ClassMethod AuditArrange(opaId As %String) As %String
{
	q:opaId="" "手术申请RowId有误!"
	k PLIST
	&sql(select * into :PLIST() from SQLUSER.DHC_AN_OPArrange where opa_rowid=:opaId)
    i SQLCODE q "未找到手术申请,请核查!"
    s anaId=$P(^DHCANOPArrange(opaId),"^",2)
	i PLIST(20)'="A" q "手术状态不对!"
	s PLIST(20)="R" //安排
	&sql(update SQLUSER.DHC_AN_OPArrange Values :PLIST() where opa_rowid=:opaId)
	q SQLCODE
}

ClassMethod TranDat(dat) As %String
{
	s Mdat=$zdh(dat,3)
	s WenDay=$zd(Mdat,12)
	q WenDay
}

ClassMethod InOPTempData(opaId, Str) As %String
{
	
	i opaId="" q 0
	s ^TMPAN("Report",opaId)=Str
}

ClassMethod RepOPData(opaId) As %String
{
	i opaId="" q 0
	s Lrw=0
	s Flag="N"
	f  s Lrw=$o(^TMPAN("Report",Lrw)) q:Lrw=""  d
	.i opaId=Lrw s Flag="Y"
	q Flag
}

ClassMethod Time() As %String
{
    s time=$p($h,",",2)
	s Time=""
	i time<=39600 s Time=0
    i time>39600 s Time=1
	q Time
}

Query GetASA() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ORASARowId:%Integer,ORASADesc:%String")
{
    select ORASA_RowId,ORASA_Desc from SQLUser.ORC_ASA_ClassPhActiv
}

/// ##Class(%ResultSet).RunQuery("web.UDHCANOPArrange","GetOPLevel")
/// select ANCOPL_RowId,ANCOPL_Desc from SQLUser.DHC_ANC_OPLevel
Query GetOPLevel() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ANCOPLRowId:%Integer,ANCPLDesc:%String")
{
    select CATEG_RowId,CATEG_Desc from SQLUser.ORC_OperationCategory
}

Query GetBlood() As %SQLQuery(CONTAINID = 1, ROWSPEC = "BLDTRowId:%Integer,BLDTDesc:%String")
{
    select BLDT_RowId,BLDT_Desc from  SQLUser.PAC_BloodType
}

ClassMethod GetPatBlood(AdmId) As %String
{
    s MrAdmDR=$P($G(^PAADM(AdmId)),"^",61) 
    i MrAdmDR'="" s BloodTypeId=$P($G(^MR(MrAdmDR,"PRO",1)),"^",18)
    e  s BloodTypeId=""
	q BloodTypeId
}

ClassMethod UpdatePatBlood(AdmId, BloodTypeId) As %String
{
    s MrAdmDR=$P($G(^PAADM(AdmId)),"^",61) 
    q:MrAdmDR="" 0
	&sql(update SQLUSER.MR_Adm set MRADM_BloodType_DR=:BloodTypeId where MRADM_RowId=:MrAdmDR)
	q SQLCODE
}

Query RHBlood() As %Query(ROWSPEC = "RHId,RHDesc")
{
}

ClassMethod RHBloodExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    s RHDesc="不详",RHId=1
    d outputRH
    s RHDesc="阴性(-)",RHId=2
    d outputRH
    s RHDesc="阳性(+)",RHId=3
    d outputRH
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
   
outputRH
 set Data=$lb(RHId,RHDesc)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod RHBloodFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = RHBloodExecute ]
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

ClassMethod RHBloodClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = RHBloodExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query GetAnaLevel() As %Query(ROWSPEC = "anaLevelId,levelDesc")
{
}

ClassMethod GetAnaLevelExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    s anaLevelId=0
    f  s anaLevelId=$o(^DHCANC("OPLevel",anaLevelId)) q:anaLevelId=""  d
    .q:+anaLevelId=0
    .s anaLevelDesc=$p(^DHCANC("OPLevel",anaLevelId),"^",2)
    .d outputAL
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
   
outputAL
 set Data=$lb(anaLevelId,anaLevelDesc)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod GetAnaLevelFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAnaLevelExecute ]
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

ClassMethod GetAnaLevelClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAnaLevelExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query GetOrdNo() As %Query(ROWSPEC = "Id,Desc")
{
}

ClassMethod GetOrdNoExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    s maxnum=20
    f num=1:1:maxnum  d
    .d outputON
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
   
outputON
 set Data=$lb(num,num)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod GetOrdNoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOrdNoExecute ]
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

ClassMethod GetOrdNoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOrdNoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetIfOutTime() As %String
{
	q:$P($G(^DHCCLSet("AnOp","Time")),"^")="" 0
	s ret=0
	s groupId=%session.Data("LOGON.GROUPID")
	q:$P($G(^DHCCLSet("AnOp","Time")),"^",3)=groupId 0
	s curCTLOCID=%session.Data("LOGON.CTLOCID")  // + wxl 090316 bigen
	s OutTimeStr=$P($G(^DHCCLSet("AnOp","Time")),"^",1)
	s curOutTime=$p(OutTimeStr,"!",1)
	s OutTimeNum=$L(OutTimeStr,"!")
	i OutTimeNum>1  d
		.f i=2:1:OutTimeNum d  q:CTLOCID=curCTLOCID
			..s OutTime=$p(OutTimeStr,"!",i)
			..s CTLOCID=$p(OutTime,"|",2)
			..q:CTLOCID'=curCTLOCID
			..s curOutTime=$p(OutTime,"|",1)
	s ret1=$p($h,",",2)>$ZTH(curOutTime) // + wxl 090316 end
	//s ret1=$p($h,",",2)>$ZTH($P($G(^DHCCLSet("AnOp","Time")),"^"))
	;i (ret1=1)&($P($G(^DHCCLSet("AnOp","Time")),"^",2)="Y") s ret=1
	;i (ret1=1)&($P($G(^DHCCLSet("AnOp","Time")),"^",2)'="Y") s ret=2
    Quit ret1
}

Query GetAnInstrument(instrDesc As %String = "") As %SQLQuery(CONTAINID = 1)
{
	SELECT ANCINSTR_RowId,ANCINSTR_Desc FROM sqluser.DHC_ANC_Instrument
}

Query GetOperPosition(operPosDesc As %String = "") As %SQLQuery(CONTAINID = 1)
{
	SELECT OPPOS_RowId,OPPOS_Desc FROM sqluser.ORC_OperPosition
}

/// SELECT SUSP_RowId,SUSP_Desc  FROM sqluser.ORC_ReasonForSuspend
Query GetReasonForSuspend() As %SQLQuery(CONTAINID = 1)
{
	SELECT SUSP_RowId,SUSP_Desc FROM sqluser.ORC_ReasonForSuspend
}

// 不再使用

ClassMethod UpdateReasSusp(opaId As %String = "", suspId As %String = "") As %String
{
	q:opaId="" "手术申请Id必须非空!"
	q:suspId="" "手术拒绝原因必须非空!"
	s retStr=""
	&sql(update SQLUSER.DHC_AN_OPArrange set OPA_ReturnReason_Dr=:suspId where opa_rowid=:opaId)
	i SQLCODE'=0 s retStr="更新手术拒绝原因失败!"
	i SQLCODE=0 s retStr=..ChangeAnopStat("D", opaId)
	q retStr
}

ClassMethod GetAllOperRoomStr() As %String
{
	;w ##class(web.UDHCANOPArrange).GetAllOperRoomStr()
	s rset=##class(%ResultSet).%New("web.UDHCANOPArrange:FindAncOperRoom")
	s ret=""
	do rset.Execute()
	while (rset.Next()) {
		i ret=""  s ret=rset.GetData(1)_$C(1)_rset.GetData(2)_"-"_rset.GetData(3)
		e  s ret=ret_"^"_rset.GetData(1)_$C(1)_rset.GetData(2)_"-"_rset.GetData(3)
	}	
	d rset.Close()
	q ret
}

ClassMethod GetQueryInfPyObjDrugByPaadmStr(paadm) As %String
{
	;w ##class(web.UDHCANOPArrange).GetAllOperRoomStr()
	q:paadm="" "就诊患者为空！"
	s rset=##class(%ResultSet).%New("web.DHCMedInfService:QueryInfPyObjDrugByPaadm")
	//s rset=##class(%ResultSet).%New("web.UDHCANOPArrange:FindAncOperRoom")
	s ret=""
	do rset.Execute(paadm)
	while (rset.Next()) {
		i ret=""  s ret=rset.GetData(1)_$C(1)_rset.GetData(2)_"-"_rset.GetData(3)
		e  s ret=ret_"^"_rset.GetData(1)_$C(1)_rset.GetData(2)_"-"_rset.GetData(3)
	}
	d rset.Close()
	q ret
}

ClassMethod GetAnDocStr(opaId = "") As %String
{
   s needCtcpDesc="",locListCodeStr="AN^OUTAN^EMAN", locDescOrId = "", EpisodeID = "",ifDoctor = "Y"
	;w ##class(web.DHCANArrange).GetAllOperRoomStr()
	s rset=##class(%ResultSet).%New("web.UDHCANOPArrange:FindCtcp")
	//s rset=##class(%ResultSet).%New("web.UDHCANOPArrange:FindAncOperRoom")
	s ret=""
	do rset.Execute(needCtcpDesc,locListCodeStr,locDescOrId, EpisodeID,opaId,ifDoctor)
	while (rset.Next()) {
		i ret=""  s ret=rset.GetData(1)_$C(1)_rset.GetData(2)_"-"_rset.GetData(3)
		e  s ret=ret_"^"_rset.GetData(1)_$C(1)_rset.GetData(2)_"-"_rset.GetData(3)
	}
	d rset.Close()
	q ret
}

/// 更新手术申请的台次+不再使用
ClassMethod UpdateOpaSeqNo(opaId As %String = "", opaSeqNo As %String = "", opdate As %String = "") As %String
{
	s opaId=+opaId
	q:(opaId=0)!(opaId="") "手术申请不存在!"
	q:opaSeqNo="" 0
	s opaSeqNo=+opaSeqNo
	q:opaSeqNo=0 "台次输入不合法!"
	s roomId=$P($G(^DHCANOPArrange(opaId)),"^",20)
	q:roomId="" "未安排手术间!"
	s flag=..GetFlagRoomSeqNo(roomId,opaSeqNo,opdate)
	q:flag=1 "手术间台次重复!"
	s retStr=""
	TSTART
	&sql(update SQLUSER.DHC_AN_OPArrange set OPA_seq=:opaSeqNo where opa_rowid=:opaId)
	i SQLCODE'=0 s retStr="更新台次失败!"
	i SQLCODE'=0 TROLLBACK
	
	s opaRoom="",ctcpAnDoc="",ctcpAnNur="",ctcpDevNur="",ctcpTourNur="",opstTime=""
	s opId=opaId
	s opaRoom=$p(^DHCANC("OPRoom",roomId),"^",2)
	i opaSeqNo'="" d
		.s retStr=..UpdateAnOpStatus(opId,"R")
		.i retStr="-1" s retStr="更新状态失败!" TROLLBACK
	q:retStr'="0" retStr
	s retStr=##class(web.DHCANArrange).SendMessage(opId,opaRoom,opaSeqNo,ctcpAnDoc,ctcpAnNur,ctcpDevNur,ctcpTourNur,opstTime)
	i retStr="-1" TROLLBACK  q "发送消息失败!"
	i retStr="0" TCOMMIT
	q ""
}

/// 判断手术间内台次是否重复
ClassMethod GetFlagRoomSeqNo(roomId As %String = "", seqNo As %String = "", opdate As %String = "") As %String
{
	s retFlag=0
	q:roomId="" 2
	q:seqNo="" 3
	i opdate'="" s nowDate=$ZDH(opdate,4)
	e  s nowDate=+$H
	s opaRowId=""
	f  s opaRowId=$O(^DHCANOPArrange(0,"SDate",nowDate,opaRowId)) q:(opaRowId="")  d
		.s opRoomId=$P($G(^DHCANOPArrange(opaRowId)),"^",20)
		.q:(opRoomId="")!(opRoomId'=roomId)
		.s opaSeqNo1=$P($G(^DHCANOPArrange(opaRowId)),"^",26)
		.i (opaSeqNo1'="")&(opaSeqNo1=seqNo) s retFlag=1
	q retFlag
}

/// 手术间楼层
Query GetAllOperFloor() As %SQLQuery(ROWSPEC = "ANCF_RowId:%String,ANCF_Desc:%String,ANCF_Code:%String")
{
	SELECT ANCF_RowId,ANCF_Desc,ANCF_Code FROM sqluser.DHC_ANC_Floor
}

/// Creater:zhangtao
/// CreatDate:2010.7.12
/// Description:判断手术间是否在进行手术
/// Input:opaIdStr,opRoomIdStr
/// Return:retStr
ClassMethod GetEditStat(opaIdStr, opRoomIdStr) As %String
{
	q:(opaIdStr="")||(opRoomIdStr="") "输入为空"
	s strLen=$L(opaIdStr,"^")
	s retStr="1"
	f i=1:1:strLen d
	.s opaId=$p(opaIdStr,"^",i)
	.s opRoomId=$p(opRoomIdStr,"^",i)
	.s inroomOpaId=0
	.f  s inroomOpaId=$O(^DHCANOPArrange(0,"RoomStatus",opRoomId,"I",inroomOpaId)) q:(inroomOpaId="")  d
	..q:inroomOpaId=opaId
	..i $d(^DHCANOPArrange(0,"RoomStatus",opRoomId,"I",inroomOpaId))>0  d
	...s papmiId=$p(^PAADM($p(^DHCANOPArrange(inroomOpaId),"^",1)),"^",1)
	...s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	...s opaStartDate=$p(^DHCANOPArrange(inroomOpaId),"^",14)
	...s retStr="InRoom"_"^"_"病人"_patName_"(手术Id:"_inroomOpaId_")正在手术!请选择"_$zd(opaStartDate,3)_"查询，结束手术，退出后方可继续操作!"
	q retStr
}

/// 批量修改手术状态为安排
ClassMethod UpdateAnOpStatus(opaIdStr, status) As %String
{
	q:(opaIdStr="")||(status="") ""
	s strLen=$L(opaIdStr,"^")
	s SQLCODE=-1
	TSTART
	f i=1:1:strLen d
	.s opaId=$p(opaIdStr,"^",i)
	.&sql(select * into :PLIST() from SQLUSER.DHC_AN_OPArrange where opa_rowid=:opaId)
	.s PLIST(20)=status
	.&sql(update SQLUSER.DHC_AN_OPArrange Values :PLIST() where opa_rowid=:opaId)
	.i SQLCODE'=0  TROLLBACK
	i SQLCODE=0 TCOMMIT
	q SQLCODE
}

/// 取是否需要麻醉会诊标志
ClassMethod NeedAnaesthetist(opaId) As %String
{
	q:opaId="" 1
	s retStr=1
	i $p($G(^DHCANOPArrange(opaId)),"^",44)="N" d
	.s retStr=0
	q retStr
}

ClassMethod AnaestCompClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AnaestCompExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod AnaestCompExecute(ByRef qHandle As %Binary) As %Status
{
 Set repid=$I(^CacheTemp)
 If $g(ind)="" Set ind=1
 s rowid=0
 f  s rowid=$o(^ORC("COMP",rowid)) q:rowid=""  d
 .s ID=rowid
 .s Des=$p(^ORC("COMP",rowid),"^",2)
 .Do OutputRow8	 	
 Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow8
	set Data=$lb(Des,ID)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
	quit
}

ClassMethod AnaestCompFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AnaestCompExecute ]
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

Query AnaestComp() As %Query(ROWSPEC = "Des:%String,ID:%String")
{
}

/// 向OR_AnaestComplications表中写入合并疾病
ClassMethod insertAnaestComp(itmjs As %Library.String = "", itmjsex As %Library.String = "", opaId, AnCompStr) As %String
{
	s adm=$P(opaId,"||",1)
	s chl=$P(opaId,"||",2)
	s subchl=0 f  s subchl=$O(^OR(adm,"ANA",chl,"COMP",subchl)) q:subchl=""  d
	.s COMPRowId=adm_"||"_chl_"||"_subchl
	.&sql(delete from SQLUSER.OR_AnaestComplications where COMP_RowId=:COMPRowId)
    i SQLCODE'=0  q "写入合并疾病错误"
	set num=$L(AnCompStr,"^")
	f i=1:1:num
	{
	   k PLIST
	   q:$P(AnCompStr,"^",i)=""
	   s PLIST(3)=$P(AnCompStr,"^",i)
	   s PLIST(0)=opaId
	&sql(INSERT INTO sqluser.OR_AnaestComplications Values :PLIST())
	}
	s retval=itmjs_"('"_$ZCVT(opaId,"O","JS")_"');"
    i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(opaId,"O","JS")_"');"
    &javascript<#(retval)#>
 i SQLCODE'=0 q "操作失败!"
 q "操作成功!"
}

/// 取合并疾病
ClassMethod GetAnaestCompList(anaId As %String) As %String
{
	 q:anaId="" ""
	 s adm=$P(anaId,"||",1)
	 s chl=$P(anaId,"||",2)
	 s AnaestCompList=""
	   s subchl=0 f  s subchl=$O(^OR(adm,"ANA",chl,"COMP",subchl)) q:(subchl="")  d
	   .s AnCompDr="",AnCompDesc=""
	   .s AnCompDr=$P(^OR(adm,"ANA",chl,"COMP",subchl),"^",1)
	   .if AnCompDr'="" s AnCompDesc=$P(^ORC("COMP",AnCompDr),"^",2)
	   .s AnaestCompList=$G(AnaestCompList)_AnCompDr_"!"_AnCompDesc_"^"
  	 q AnaestCompList
}

/// 手术医师组 applocID
Query GetDocGroup(applocDesc) As %Query(ROWSPEC = "DocGroupdesc:%String,DocGroupID:%String")
{
}

ClassMethod GetDocGroupExecute(ByRef qHandle As %Binary, applocDesc As %String = "") As %Status
{
 Set repid=$I(^CacheTemp)
 If $g(ind)="" Set ind=1
 s applocID=""
 i +applocID=0 s applocID=##class(web.DHCClinicCom).GetCtlocIdByCodeOrDesc(applocDesc,"Desc")
 i applocID="" Set qHandle=$lb(0,repid,0) Quit $$$OK
 	s rowid=0
 	f  s rowid=$o(^DHCANC("ODGroup",applocID,rowid)) q:rowid=""  d
 	.s anid0=$p($g(^DHCANC("ODGroup",applocID,rowid)),"^",1)
 	.s anid1=$p($g(^DHCANC("ODGroup",applocID,rowid)),"^",2)
 	.s anid2=$p($g(^DHCANC("ODGroup",applocID,rowid)),"^",3)
 	.s anid3=$p($g(^DHCANC("ODGroup",applocID,rowid)),"^",4)
 	.;s ^cjbtest(rowid)=anid0_","_anid1_","_anid2_","_anid3
 	.i anid0="" s andesc0="" 
 	.e  s andesc0=$p($g(^CTPCP(anid0,1)),"^",2)
 	.i anid1="" s andesc1=""  
 	.e  s andesc1=$p($g(^CTPCP(anid1,1)),"^",2)
 	.i anid2="" s andesc2=""  
 	.e  s andesc2=$p($g(^CTPCP(anid2,1)),"^",2)
 	.i anid3="" s andesc3=""  
 	.e  s andesc3=$p($g(^CTPCP(anid3,1)),"^",2)
 	.s DocGroupdesc=rowid_"组:"_$g(andesc0)_","_$g(andesc1)_","_$g(andesc2)_","_$g(andesc3)
 	.s DocGroupID=rowid_":"_anid0_","_anid1_","_anid2_","_anid3
 	.d OutputDocGroup
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputDocGroup
	set Data=$lb(DocGroupdesc,DocGroupID)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
	quit
}

ClassMethod GetDocGroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDocGroupExecute ]
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

ClassMethod GetDocGroupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDocGroupExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// 取手术刀口类型
Query GetBladeType() As %SQLQuery(CONTAINID = 1, ROWSPEC = "BLDTPRowId:%Integer,BLDTPDesc:%String")
{
    select BLDTP_RowId,BLDTP_Desc from SQLUser.ORC_BladeType
}

/// Creator: wangxinlei
/// CreatDate: 2009-12-18
/// Description: 手术申请界面获取默认手术室与手术间
/// Table：DHC_ANC_OperRoom, CT_Loc
/// Input：AppLocId:填写的申请科室的ID,为空则取用户登陆科室ID,OPLoc: 申请手术室名称或ID
/// Return：返回申请科室对应的手术室ID_"|"_手术室_"^"_手术间ID_"|"_手术间
ClassMethod GetOPLocRoom(AppLocId As %String, OPLoc As %String = "") As %String
{
	//维护手术间默认使用科室后,可以设置手术申请时是否自动填写手术室与手术间
	q:$g(^DHCCLSet("AnOp","InsertDefRoom"))'="Y" ""
	i AppLocId="" q ""
	s OPLocId=""
	i OPLoc'="" d
	.i OPLoc=+OPLoc s OPLocId=OPLoc q
	.s OPLoc=$$ALPHAUP^SSUTIL4(OPLoc)
	.s OPLocId=$o(^CTLOC(0,"Desc",OPLoc,""))
	s flag=0
	s Str="",DefOPLocId="",DefOPLocDesc="",DefOPRoomId="",DefOPRoomDesc=""
	s curOPRoomId=""
	f  s curOPRoomId=$o(^DHCANC("OPRoom",0,"DefDep",AppLocId,curOPRoomId)) q:(curOPRoomId="")!(flag=1)  d
	.s DefOPLocId=$p(^DHCANC("OPRoom",curOPRoomId),"^",3)			//OPR_Ctloc_Dr 	手术室
	.q:(OPLocId'="")&(OPLocId'=DefOPLocId)
	.s DefOPLocDesc=$p(^CTLOC(DefOPLocId),"^",2)					//CTLOC_Desc    手术室描述
	.s DefOPRoomDesc=$p(^DHCANC("OPRoom",curOPRoomId),"^",2)		//OPR_Desc		手术间
	.s DefOPRoomId=curOPRoomId
	.s flag=1
	s Str=DefOPLocId_"|"_DefOPLocDesc_"^"_DefOPRoomId_"|"_DefOPRoomDesc
	q $g(Str)
}

/// Creator: wangxinlei
/// CreatDate: 2009-12-28
/// Description: 转入到恢复床
/// Table：DHC_ANC_OperRoom,DHC_AN_OPArrange
/// Input：PacuBedId:恢复床位ID, OpaId:手术申请ID
/// Return：成功0,否则非0
ClassMethod TranToPacuBed(PacuBedId As %String, OpaId As %String) As %String
{
	q:(PacuBedId="")!(OpaId="") 0
	s curDate=+$h,curTime=$p($h,",",2)
	&sql(update SQLUSER.DHC_AN_OPArrange(OPA_PacuBed_Dr,OPA_PACUInDate,OPA_PACUInTime) Values(:PacuBedId,:curDate,:curTime) where opa_rowid=:OpaId)
	q SQLCODE
}

/// Creator: wangxinlei
/// CreatDate: 2010-01-15
/// Description: 修改手术的器械和巡回护士
/// Table：DHC_AN_OPArrange
/// Input：opaId:手术申请ID, SCNur:器械护士,CIRNur:巡回护士
/// Return：成功返回0,否则返回非0
ClassMethod UpdateOpNurse(opaId As %String, SCNur As %String, CIRNur As %String) As %String
{
	q:(opaId="") -1
	&SQL(update SQLUSER.DHC_AN_OPArrange set OPA_ScrubNurseNote=:SCNur,OPA_CirculNurseNote=:CIRNur  where OPA_RowId=:opaId)
	q SQLCODE
}

/// Creator: chenkai
/// CreatDate: 2010-02-08
/// Description: 修改手术要求(备注)
/// Table：DHC_AN_OPArrange
/// Input：opaId:手术申请ID, opmem手术要求(备注)
/// Return：成功返回0,否则返回非0
ClassMethod UpdateOpmem(opaId As %String, opmem As %String) As %String
{
	q:opaId="" "-1"
	&sql(update SQLUSER.DHC_AN_OPArrange set OPA_Memo=:opmem where opa_rowid=:opaId)
	q SQLCODE
}

/// Creator: chenkai
/// CreatDate: 2010-02-23
/// Description: 取诊断ID
/// Table：mrc_icddx
/// Input：diag诊断名称
/// Return：成功返回diagRowId,否则返回空
ClassMethod GetDiagId(diag As %String) As %String
{
	q:diag="" ""
	s diagRowId=""
	s diagRowId=$o(^MRC("ID",0,"Desc",diag,diagRowId))
	q diagRowId
}

/// Creator: chenkai
/// CreatDate: 2010-03-03
/// Description: 取手术名称对应ID
/// Table：ORC_Operation
/// Input：opName手术名称
/// Return：成功返回opNameId,否则返回空
ClassMethod GetOpNameId(opName As %String) As %String
{
	q:opName="" ""
	s opNameId=""
	s opNameId=$o(^ORC("OPER",0,"Desc",opName,opNameId))
	q opNameId
}

/// 取得所有 麻醉医师 护士未计费手术
/// d ##class(%ResultSet).RunQuery("web.UDHCANOPArrange","GetAllNoPaid","61818","61828")
Query GetAllNoPaid(stdate As %String, enddate As %String) As %Query(ROWSPEC = "opaId:%String,patName:%String,arcimDesc:%String,isPlanPrice:%String,isPaid:%String,adm:%String")
{
}

ClassMethod GetAllNoPaidExecute(ByRef qHandle As %Binary, stdate As %String, enddate As %String) As %Status
{
	 Set repid=$I(^CacheTemp)
     If $g(ind)="" Set ind=1
     i (stdate="")!(enddate="") s sdate=+$H,edate=+$H
     e  s sdate=stdate,edate=enddate
     s isPlanPrice="N",isPaid="N",patName=""
     f date=sdate:1:edate d
     .s opaId=""
     .f  s opaId=$O(^DHCANOPArrange(0,"SDate",date,opaId)) q:opaId=""  d
	 ..q:$d(^DHCANOPArrange(opaId))<1
	 ..s EpisodeID=$p($g(^DHCANOPArrange(opaId)),"^",1)
	 ..s adm=EpisodeID
	 ..s AnaesthesiaID=$p($g(^DHCANOPArrange(opaId)),"^",2)
	 ..s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
     ..s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	 ..s exOeoriDr=""
	 ..f  s exOeoriDr=$o(^DHCEXDE(0,"OEORI",EpisodeID,exOeoriDr)) q:exOeoriDr=""  d
	 ...s exRowId="",isPaidStat=""
	 ...f  s exRowId=$o(^DHCEXDE(0,"OEORI",EpisodeID,exOeoriDr,exRowId)) q:exRowId=""  d
	 ....s anaestDr=$p($g(^OEORD(+exOeoriDr,"I",$p(exOeoriDr,"||",2),4)),"^",9)
	 ....q:anaestDr'=AnaesthesiaID
	 ....s itemStatDR=$p($g(^OEORD(+exOeoriDr,"I",$p(exOeoriDr,"||",2),1)),"^",13)
	 ....q:(itemStatDR="4")!(itemStatDR="")
	 ....s itmMastDr=$p($g(^OEORD(+exOeoriDr,"I",$p(exOeoriDr,"||",2),1)),"^",2)
	 ....s arcimDesc=$p($g(^ARCIM($p(itmMastDr,"||",1),$p(itmMastDr,"||",2),1)),"^",2)
	 ....s exBillingAttr=$p($g(^DHCEXDE(exRowId)),"^",17)
	 ....q:exBillingAttr="F"
	 ....i (exBillingAttr="0")!(exBillingAttr="") s isPlanPrice="N"
	 ....e  i exBillingAttr="1" s isPlanPrice="Y"
	 ....s exStatus=$p($g(^DHCEXDE(exRowId)),"^",18)
	 ....q:exStatus="F"
	 ....i exStatus="A" s isPaid="Y"
	 ....e  i exStatus="" s isPaid="N"
	 ....i isPaidStat="" s isPaidStat=isPaid
	 ....e  s isPaidStat=isPaidStat_"^"_isPaid
	 ....s itemStatDR=$p($g(^OEORD(+exOeoriDr,"I",$p(exOeoriDr,"||",2),1)),"^",13)
	 ....q:(itemStatDR=4)!(itemStatDR="")!(itemStatDR=5)!(itemStatDR=6)
	 ....i isPaidStat="" s isPaidStat=isPaid
	 ....e  s isPaidStat=isPaidStat_isPaid
	 ...i isPaidStat["N" d
     ....Do OutputAllNoPaid	
     Set qHandle=$lb(0,repid,0)
	 Quit $$$OK
OutputAllNoPaid
	set Data=$lb(opaId,patName,arcimDesc,isPlanPrice,isPaid,adm)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod GetAllNoPaidFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllNoPaidExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
 Set AtEnd=1
 Set Row=""
 }
 Else  {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetAllNoPaidClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllNoPaidExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// chenkai 20100419
/// DHC_AN_OPArrange
/// 计算术后登记和当前时间的时间差,判断用户是否可以修改收费项目
/// opaId
/// retStr>0 (retStr<=3600可修改retStr>3600不可修改)成功 retStr=-1失败
/// w ##class(web.UDHCANOPArrange).getTimeDifference("587")
ClassMethod getTimeDifference(opaId As %String) As %String
{
	q:opaId="" "opaId不能为空!"
	s retStr=""
	s regDate=$p(^DHCANOPArrange(opaId),"^",16)
	s regTime=$p(^DHCANOPArrange(opaId),"^",17)
	s nowDate=+$h
	s nowTime=$p($h,",",2)
	s dateDifference=nowDate-regDate
	i dateDifference=0 d
	.i nowTime>regTime s retStr=nowTime-regTime
	.e  s retStr="-1"
	i dateDifference<0 d
	.s retStr="-1"
	i dateDifference>0 d
	.s retStr=(86400*dateDifference)+nowTime-regTime
	q retStr
}

ClassMethod SaveUser(chargeUserIdStr As %String = "", refundUserIdStr As %String = "") As %String
{
	s ^DHCANOPChargeUserId("chargeUserId")=chargeUserIdStr
	s ^DHCANOPRefundUserId("refundUserId")=refundUserIdStr
}

ClassMethod GetUserId() As %String
{
	s retVal=""
	s chargeUserId=^DHCANOPChargeUserId("chargeUserId")
	s refundUserId=^DHCANOPRefundUserId("refundUserId")
	
	i chargeUserId'="" s retVal=retVal_"InitList('chargeUser1','"_$ZCVT(chargeUserId,"O","JS")_"');"
	i refundUserId'="" s retVal=retVal_"InitList('refundUser1','"_$ZCVT(refundUserId,"O","JS")_"');"
    &javascript<#(retVal)#>
    q
}

/// chenkai 20100423
/// 判断用户类型,是否是最终修改医嘱收费人
/// 成功返回0失败返回-1
ClassMethod GetChargeUserType() As %String
{
	s userId=%session.Data("LOGON.USERID")
	s len=$l($g(^DHCANOPChargeUserId("chargeUserId")),"^")
	s retStr="-1"
	f i=1:1:len d
	.s userRowId=$p($p($g(^DHCANOPChargeUserId("chargeUserId")),"^",i),"|",2)
	.i userId=userRowId  s retStr="0" q
	q retStr
}

/// chenkai 20100423
/// 判断用户类型,是否是退费人
/// 成功返回0失败返回-1
ClassMethod GetRefundUserType() As %String
{
	s userId=%session.Data("LOGON.USERID")
	s len=$l($g(^DHCANOPRefundUserId("refundUserId")),"^")
	s retStr="-1"
	f i=1:1:len d
	.s userRowId=$p($p($g(^DHCANOPRefundUserId("refundUserId")),"^",i),"|",2)
	.i userId=userRowId  s retStr="0" q
	q retStr
}

/// chenkai 20100428
/// DHC_AN_OPArrange
/// 手术取消时更新台次和手术间为空
/// opaId
/// 成功返回空失败返回-1
ClassMethod UpdateRoomSeq(opaId As %String) As %String
{
	q:opaId="" "opaId不能为空!"
	s roomDr=""
	s seqno=""
	s retStr=""
	TSTART
	&sql(update SQLUSER.DHC_AN_OPArrange set OPA_OpRoom_dr=:roomDr,OPA_Seq=:seqno where OPA_RowId=:opaId)
	i SQLCODE'=0 s retStr="更新房间和台次失败!"
	i SQLCODE'=0 TRollBack
	TCommit
	q retStr
}

ClassMethod GetCtcpSet(EpisodeID As %String = "") As %String
{
	q $g(^DHCCLSet("AnOp","Ctcp")) //手术助手编辑框数^是否手工编辑手术人员
}

ClassMethod UpdateAnaDoctorOrdered(opaId As %String = "", isOrdered As %String = "Y") As %String
{
	q:opaId="" "手术号为空!"
	q:'$d(^DHCANOPArrange(opaId)) "手术号不对!"
	s $p(^DHCANOPArrange(opaId),"^",48)=isOrdered
	q 0
}

// 20161214+dyl+已录手术医嘱

ClassMethod UpdateOPNurseOrdered(opaId As %String = "", isOrdered As %String = "Y") As %String
{
	q:opaId="" "手术号为空!"
	q:'$d(^DHCANOPArrange(opaId)) "手术号不对!"
	s ret=0
	s oldOrdStat=$p($g(^DHCANOPArrange(opaId)),"^",50)
	i oldOrdStat="" s $p(^DHCANOPArrange(opaId),"^",50)="Y",ret="Y"
	e  i oldOrdStat="Y" s $p(^DHCANOPArrange(opaId),"^",50)="N",ret="N"
	e  s $p(^DHCANOPArrange(opaId),"^",50)="Y",ret="Y"
	q ret
}

ClassMethod GetOperRelated(operId As %String) As %String
{
	q:operId="" ""
	q:'$d(^ORC("OPER",operId)) ""
	s ancoplId=$p($g(^ORC("OPER",operId)),"^",7)
	;$p($g(^ORC("OPER",operId,"DHC")),"^",1):手术级别不再使用
	;s ancoplDesc=$p($g(^DHCANC("OPLevel",+ancoplId)),"^",2)
	;这块改了20161009+dyl
	s ancoplDesc=""
	i ancoplId'="" s ancoplDesc=$p($g(^ORC("CATEG",ancoplId)),"^",2) 
    s bldtpId=$p($g(^ORC("OPER",operId,"DHC")),"^",3)
	s bldtpDesc=$p($g(^ORC("BLDTP",+bldtpId)),"^",2)
	s bodsId=$p($g(^ORC("OPER",operId,"DHC")),"^",2)
	s bodsDesc=$p($g(^OEC("BODS",+bodsId)),"^",2)
	s operPositionId=$p($g(^ORC("OPER",operId,"DHC")),"^",4)
	s operPositionDesc=$P($G(^ORC("OPPOS",+operPositionId)),"^",2)
	q ancoplId_"^"_ancoplDesc_"^"_bldtpId_"^"_bldtpDesc_"^"_bodsId_"^"_bodsDesc_"^"_operPositionId_"^"_operPositionDesc
}

/// 通过医生 护士 ID取得姓名 若ID中有~,则到CTPCP中取值(本院人员),否则到DHC_CL_CareProv中取(进修 实习)
ClassMethod GetNameById(docdr As %String) As %String
{
	i docdr="" q ""
	s len=$l(docdr,"~")
	q:(len'=1)&(len'=2) "" //"用户ID不正确!"
	s docName=""
	i len=1 d
		.s docName=$TR($P(^CTPCP(+docdr,1),"^",2)," ","")
	i len=2 d
		.s clcpRowId=$p(docdr,"~",2)
		.s docName=$li(^DHCCLCP(+clcpRowId),2)
	q docName
}

/// 置手术医生到达时间
ClassMethod SetDocArriveTime(opaId As %String, time As %String, isSuper As %String = "") As %String
{
	i opaId="" q "病人Id不能为空!"
	s time=##class(web.DHCANOPCom).ConvertToTimeH(time)
	q:(isSuper'="Y")&($p(^DHCANOPArrange(opaId),"^",46)'="") "已录医生到达时间!"
	s $p(^DHCANOPArrange(opaId),"^",46)=time
	q 0
}

ClassMethod UPDataOpDirAuditStatus() As %String
{
	  //q:OpDirAuditStatus="" "状态不能为空"
	  s oriOpDirAuditStatus=$G(^DHCCLSet("AnOp","OpDirAuditStatus"))
	  i (oriOpDirAuditStatus="N")!(oriOpDirAuditStatus="") d
	  .s ^DHCCLSet("AnOp","OpDirAuditStatus")="Y"
	  i oriOpDirAuditStatus="Y" d
	  .s ^DHCCLSet("AnOp","OpDirAuditStatus")="N"
	  q $g(^DHCCLSet("AnOp","OpDirAuditStatus"))
}

ClassMethod CheckAppData(EpisodeID) As %String
{
	q:EpisodeID="" ""
	q:'$d(^DHCCLSet("AppCtr")) ""
	q:$g(^DHCCLSet("AppCtr"))'="Y" ""
	;s m=1500
	s entDate=+$h
	;i $zd(+$h,10)=0 s sttDate=+$h-(m+1)
	;e  s sttDate=+$h-m
	s oldOpaId="" 
	i $d(^DHCANOPArrange(0,"Adm",EpisodeID))>0 d
		.s oldOpaId=$o(^DHCANOPArrange(0,"Adm",EpisodeID,""),-1)
	i oldOpaId'="" d
		.s sttDate=$P(^DHCANOPArrange(oldOpaId),"^",3)
	e  d
		.s sttDate=$p(^PAADM(EpisodeID),"^",6)
	s stDate=$zd(sttDate,3)
	s enDate=$zd(+$h,3)
	//检查
	s retStr="",retIns="",oeoriResultFlag="",emerFlag=0,oeoriRISFlag=""
	s inId=0
	f  s inId=$o(^DHCCLSet("Inspect",inId))  q:inId=""   d
	.s inCode=$p(^DHCCLSet("Inspect",inId),"^",1)
	.q:inCode=""
	.s inArcim1=$o(^ARCIM(0,"Code",inCode,""))
	.q:inArcim1=""
	.s inArcimSub=$o(^ARCIM(0,"Code",inCode,inArcim1,""))
	.q:inArcimSub=""
	.s ArcimDr=inArcim1_"||"_inArcimSub
	.s inDesc=$p(^DHCCLSet("Inspect",inId),"^",2)
	.s ctrType=$p($g(^DHCCLSet("Inspect",inId)),"^",3)
	.s oeordId=""
	.s oeordId=$o(^OEORD(0,"Adm",EpisodeID,""),-1) 
	.q:oeordId=""
	.i $d(^OEORDi(0,"ARCIM",oeordId,ArcimDr))<1 d
		..i (ctrType="A") d
			...i retIns="" s retIns=inDesc_"^"_2
			...e  s retIns=retIns_"!"_inDesc_"^"_2
		..i (ctrType="F") d
			...i retIns="" s retIns=inDesc_"^"_1
			...e  s retIns=retIns_"!"_inDesc_"^"_1
	.e  d
		..s sttARDate=$o(^OEORDi(0,"ARCIM",oeordId,ArcimDr,""),-1)
		..s oeoriSub=""
		..f  s oeoriSub=$o(^OEORDi(0,"ARCIM",oeordId,ArcimDr,sttARDate,oeoriSub))   q:oeoriSub=""  d
		...s oeoriResultFlag=$p(^OEORD(oeordId,"I",oeoriSub,1),"^",5)
		...s oeoriRISFlag=..GetRisReportPublishInfo(oeordId_"||"_oeoriSub)
		.;i ((ctrType="A")&(oeoriResultFlag'="CM"))  d
		.i ((ctrType="A")&(oeoriRISFlag<0))  d
			..i retIns="" s retIns=inDesc_"^"_2
			..e  s retIns=retIns_"!"_inDesc_"^"_2 
		.;i ((ctrType="F")&(oeoriResultFlag'="CM"))  d
		.i ((ctrType="F")&(oeoriRISFlag<0))  d
			..i retIns="" s retIns=inDesc_"^"_1
			..e  s retIns=retIns_"!"_inDesc_"^"_1
	//检验
	s retStr=retIns
	s asId=0,emerFlag=0,retAs=""
	f  s asId=$o(^DHCCLSet("Assay",asId)) q:asId=""  d
	.s asCode=$p(^DHCCLSet("Assay",asId),"^",1)
	.s asDesc=$p(^DHCCLSet("Assay",asId),"^",2)
	.q:asCode=""
	.s oeordId=$o(^OEORD(0,"Adm",EpisodeID,""))
	.q:oeordId=""
	.s ctrType=$p($g(^DHCCLSet("Assay",asId)),"^",3)
	.//w ##class(web.UDHCANOPArrange).GetLabResult(25,"RPR",62606,62607)
	.s ret=..GetLabResult(EpisodeID,asCode,stDate,enDate)
	.//s ^tmpYpz("ret",asCode)=ret_"/"_EpisodeID_","_asCode_","_stDate_","_enDate
	.s n=$l(ret,"^")
	.f i=n:-1:1 d
	..s type=$p($p(ret,"^",i),$c(1),1)
	..s resDesc=$p($p(ret,"^",i),$c(1),2)
	..s warning=$p($p(ret,"^",i),$c(1),11)
	..q:type=2
	.i (type=2)&(warning="W") s emerFlag=1
	.i ((ctrType="A")&&(emerFlag=1)) d
	..i retAs="" s retAs=asDesc_"("_resDesc_"),^"_3
	..e  s retAs=retAs_"!"_asDesc_"("_resDesc_"),^"_3
	.i ((ctrType="F")&(type'=2))  d
	..i retAs="" s retAs=asDesc_"("_resDesc_"),^"_1
	..e  s retAs=retAs_"!"_asDesc_"("_resDesc_"),^"_1
	.i ((ctrType="A")&(type'=2))  d
	..i retAs="" s retAs=asDesc_"("_resDesc_"),^"_2
	..e  s retAs=retAs_"!"_asDesc_"("_resDesc_"),^"_2
	i retStr="" s retStr=retAs
	e  s retStr=retStr_"!"_retAs
	;接口
	s ret=0
	
	
	////s ret=##Class(EPRservice.BIL.BIToAN).IsOperRecordComplished(EpisodeID, sttDate, entDate)
	s meId=0,retMe="" ,newpara=""
	f  s meId=$o(^DHCCLSet("MedDoc",meId)) q:meId=""  d
	.s code=$p(^DHCCLSet("MedDoc",meId),"^",1)
	.s meDesc=$p(^DHCCLSet("MedDoc",meId),"^",2)
	.s ctrType=$p($g(^DHCCLSet("MedDoc",meId)),"^",3)
		.s para=code
		.s mlen=$l(para,"|")
		.f mnum=1:1:mlen d
			..i newpara'="" s newpara=newpara_"|"_$p(para,"|",mnum)_"#"_meDesc
			..e  s newpara=$p(para,"|",mnum)_"#"_meDesc
	.//w para,!
	.s ret=##class(EPRservice.BIL.BIToAN).IsOneGroupComplished(EpisodeID, sttDate, entDate, newpara)
	.i 1=1 d  //((meDesc="术前讨论")!(meDesc="术前小结")) d
	..i ((ctrType="A")&(ret=0)) d
	...i retMe="" s retMe=meDesc_"^"_2
	...e  s retMe=retMe_"!"_meDesc_"^"_2
	..i ((ctrType="F")&(ret=0)) d
	...i retMe="" s retMe=meDesc_"^"_1
	...e  s retMe=retMe_"!"_meDesc_"^"_1
	i retStr="" s retStr=retMe
	e  s retStr=retStr_"!"_retMe
	q retStr
}

/// 获取检查报告发布情况
/// 0:全部返回，1：部分返回，-1：全部未返回
ClassMethod GetRisReportPublishInfo(OEORowid) As %String
{
	s bodypartidlist=""
	s result=-1
	// 判断医嘱是否有部位
	s ishaveAPBPFunction=##class(websys.Conversions).IsValidMethodName("web.DHCEMInterface","GetExaReqPart")  //新版申请单获取部位ID
	i ishaveAPBPFunction=1 d
	.s bodypartidlist=##Class(web.DHCEMInterface).GetExaReqPart(OEORowid)
	
	i bodypartidlist="" d
	.s (regRowid,studyNo,reportRowid,statusDR)=""
	.s regRowid=$o(^DHCPACRegInfoi("OEORI",OEORowid,0))
	.q:regRowid=""
	.s studyNo=$p(^DHCPACRegInfo(regRowid),"^",2)
	.q:studyNo=""
	.s reportRowid=$o(^DHCRBStudyi("Report","StudyNo",studyNo,0))
	.q:reportRowid=""
	.s statusDR=$p(^DHCRBStudy("Report",reportRowid),"^",4)
	.i statusDR=5 s result=0
	else
    .s bpilcount=$l(bodypartidlist,"^")
    .s regbodypart=0
    .s regRowid="" f  s regRowid=$o(^DHCPACRegInfoi("OEORI",OEORowid,regRowid))  q:regRowid=""  d
    ..s (studyNo,reportRowid,statusDR)=""
	..s regRowid=$o(^DHCPACRegInfoi("OEORI",OEORowid,0))
	..q:regRowid=""
	..s studyNo=$p(^DHCPACRegInfo(regRowid),"^",2)
	..q:studyNo=""
	..s reportRowid=$o(^DHCRBStudyi("Report","StudyNo",studyNo,0))
	..q:reportRowid=""
	..s statusDR=$p(^DHCRBStudy("Report",reportRowid),"^",4)
	..i statusDR=5 d   // 当报告发布时循环部位登记表，发布报告数加1
    ...s rrbsub="" f  s rrbsub=$o(^DHCPACRegInfoBD("BODYPARTS",0,regRowid,rrbsub))  q:rrbsub=""  d
    ....s regbodypart=regbodypart+1
    .i regbodypart=bpilcount s result=0
    .i regbodypart<bpilcount s result=1
    .i regbodypart=0 s result=-1
    
    q result
}

ClassMethod GetLabResult(EpisodeID, asCode, stDate, enDate) As %String
{
	s rset=##class(%ResultSet).%New("LabService.TCResult:QueryTCResultByAdmId")
	s ret=""
	do rset.Execute(EpisodeID,asCode,stDate,enDate)
	while (rset.Next()) {
		i ret=""  s ret=rset.GetData(1)_$C(1)_rset.GetData(2)_$C(1)_rset.GetData(3)_$C(1)_rset.GetData(4)_$C(1)_rset.GetData(11)
		e  s ret=ret_"^"_rset.GetData(1)_$C(1)_rset.GetData(2)_$C(1)_rset.GetData(3)_$C(1)_rset.GetData(4)_$C(1)_rset.GetData(11)
	}	
	d rset.Close()
	q ret
}

ClassMethod GetNurse(tOprId)
{
   s tOprDefCirculNurseDr=$p(^DHCANC("OPRoom",tOprId),"^",11) 
   s circulNurse=""
   i tOprDefCirculNurseDr'="" d
   .s circulNum=$l(tOprDefCirculNurseDr,"|")
   .f i=1:1:circulNum d
   ..s tOprDefCirculNurseId=$p(tOprDefCirculNurseDr,"|",i)
   ..q:tOprDefCirculNurseId=""
   ..s tCirculNurse=$p($g(^CTPCP(+tOprDefCirculNurseId,1)),"^",2) 
   ..s circulNurse=circulNurse_tCirculNurse_"|"
   s tOprDefScrubNurseDr=$p(^DHCANC("OPRoom",tOprId),"^",10) //zhangtao 2010.8.4
   s scrubNurse=""
   i tOprDefScrubNurseDr'="" d
   .s scrubNum=$l(tOprDefScrubNurseDr,"|")
   .f i=1:1:scrubNum d
   ..s tOprDefScrubNurseId=$p(tOprDefScrubNurseDr,"|",i)
   ..q:tOprDefScrubNurseId=""
   ..s tScrubNurse=$p($g(^CTPCP(+tOprDefScrubNurseId,1)),"^",2)
   ..s scrubNurse=scrubNurse_tScrubNurse_"|"
   s ret=circulNurse_"#"_tOprDefCirculNurseDr_"^"_scrubNurse_"#"_tOprDefScrubNurseDr
   q ret
}

/// 判断某一日同一手术间内台次是否重复+dyl
ClassMethod CheckArrData(opaId As %String, roomId As %String = "", seqNo As %String = "", opdate As %String = "") As %String
{
	s retFlag=0
	q:roomId="" 2
	q:seqNo="" 3
	s dateformatnum=##class(websys.Conversions).DateFormat()
	i opdate'="" s nowDate=##Class(web.DHCANOPCom).ConvertToDateH(opdate)
	e  s nowDate=+$H
	s opaRowId=""
	f  s opaRowId=$O(^DHCANOPArrange(0,"SDate",nowDate,opaRowId)) q:(opaRowId="")  d
		.q:opaId=opaRowId
		.s opRoomId=$P($G(^DHCANOPArrange(opaRowId)),"^",20)
		.q:(opRoomId="")!(opRoomId'=roomId)
		.s opaSeqNo1=$P($G(^DHCANOPArrange(opaRowId)),"^",26)
		.i (opaSeqNo1'="")&(opaSeqNo1=seqNo) s retFlag=1
	q retFlag
}

ClassMethod GetPath()
{
	&sql(select pathtoreports into :reportPath from websys.configuration)
	q reportPath
}

/// d ##class(%ResultSet).RunQuery("web.UDHCANOPArrange","FindODGroupNew","WZZNKB-危重症内科部")
/// 手术医师组 applocID
/// w ##class(web.DHCClinicCom).GetCtlocIdByCodeOrDesc("WZZNKB-危重症内科部","Desc")
Query FindODGroupNew(OpDept As %String = "") As %Query(ROWSPEC = "groupID,surgeon,surgeonID,frtAss,frtAssID,secAss,secAssID,trdAss,trdAssID")
{
}

ClassMethod FindODGroupNewExecute(ByRef qHandle As %Binary, OpDept As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s OpDeptId=""
 	i OpDept'="" s OpDeptId=##class(web.DHCClinicCom).GetCtlocIdByCodeOrDesc(OpDept,"Desc")
 	e  s OpDeptId=%session.Data("LOGON.CTLOCID")
	s deptID=""
	f  s deptID=$o(^DHCANC("ODGroup",deptID)) q:deptID=""  d
			.q:(OpDeptId'="")&(deptID'=OpDeptId)
			.s groupID=""
			.f  s groupID=$o(^DHCANC("ODGroup",deptID,groupID)) q:groupID=""  d
				..s surgeonID=$p(^DHCANC("ODGroup",deptID,groupID),"^",1)
				..i surgeonID="" s surgeon=""
				..e  i $d(^CTPCP(surgeonID)) s surgeon=$p($g(^CTPCP(surgeonID,1)),"^",2)
				..s frtAssID=$p(^DHCANC("ODGroup",deptID,groupID),"^",2)
				..i frtAssID="" s frtAss=""
				..e  i $d(^CTPCP(frtAssID)) s frtAss=$p($g(^CTPCP(frtAssID,1)),"^",2)
				..s secAssID=$p(^DHCANC("ODGroup",deptID,groupID),"^",3)
				..i secAssID="" s secAss=""
				..e  i $d(^CTPCP(secAssID)) s secAss=$p($g(^CTPCP(secAssID,1)),"^",2)
				..s trdAssID=$p(^DHCANC("ODGroup",deptID,groupID),"^",4)
				..i trdAssID="" s trdAss=""
				..e  i $d(^CTPCP(trdAssID)) s trdAss=$p($g(^CTPCP(trdAssID,1)),"^",2)
				..Do OutputG
	s qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputG
	s newGroup=groupID_"("_surgeon_"/"_frtAss_","_secAss_","_trdAss_")"
	s data=$lb(newGroup,surgeon,surgeonID,frtAss,frtAssID,secAss,secAssID,trdAss,trdAssID)
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1
	quit
}

ClassMethod FindODGroupNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindODGroupNewExecute ]
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

ClassMethod FindODGroupNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindODGroupNewExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 20150319+dyl+标准版
/// Desc:for docgroup,通过手术申请科室Id与手术医师组号，返回组号，医护人员Id，医护人员描述
/// d ##class(web.UDHCANOPArrange).GetDocGroupRelated(7,1)
/// Desc:for docgroup,通过手术申请科室Id与手术医师组号，返回组号，医护人员Id，医护人员描述
/// w ##class(web.UDHCANOPArrange).GetDocGroupRelated("YKHJ0-眼科","眼科1组")
ClassMethod GetDocGroupRelated(apploc As %String, groupId As %String) As %String
{
	q:groupId="" ""
	i +apploc=0 s applocID=##class(web.DHCClinicCom).GetCtlocIdByCodeOrDesc(apploc,"Desc")
 	e  s applocID=apploc
	;主刀，一助，二助，三助
	q:applocID=""
	s surgeonId=$p($g(^DHCANC("ODGroup",applocID,groupId)),"^",1)	;主刀
 	s firAssId=$p($g(^DHCANC("ODGroup",applocID,groupId)),"^",2)	;1
 	s secAssId=$p($g(^DHCANC("ODGroup",applocID,groupId)),"^",3)	;2
 	s tirAssId=$p($g(^DHCANC("ODGroup",applocID,groupId)),"^",4)	;3
 	i surgeonId="" s surgeon="" 
 	e  s surgeon=$p($g(^CTPCP(surgeonId,1)),"^",2)
 	i firAssId="" s firAss=""  
 	e  s firAss=$p($g(^CTPCP(firAssId,1)),"^",2)
 	i secAssId="" s secAss=""  
 	e  s secAss=$p($g(^CTPCP(secAssId,1)),"^",2)
 	i tirAssId="" s tirAss=""  
 	e  s tirAss=$p($g(^CTPCP(tirAssId,1)),"^",2)
	s DocGroup=surgeonId_"^"_$g(surgeon)_"^"_firAssId_"^"_$g(firAss)_"^"_secAssId_"^"_$g(secAss)_"^"_tirAssId_"^"_$g(tirAss)
	q DocGroup
}

ClassMethod FindRefusesReasonStr() As %String
{
	s ret=""
	s rowId=0
	f  s rowId=$o(^ORC("SUSP",rowId)) q:rowId=""  d
	.s Code=$p($g(^ORC("SUSP",rowId)),"^",1)
	.s Desc=$p($g(^ORC("SUSP",rowId)),"^",2)
	.i ret'="" s ret=ret_"^"_rowId_"|"_Desc
	.e  d  s ret=rowId_"|"_Desc
	q ret
}

// d ##class(web.UDHCANOPArrange).GetOperByEpisodeID("","","","")

// 20160114+dyl+相同手术名称提示

ClassMethod GetOperByEpisodeID(opaId As %String = "", EpisodeID As %String, OperDesc As %String, operDate As %String) As %String
{
	q:EpisodeID="" ""
	q:operDate="" ""
	s ret=0
	
	s operNDate=##Class(web.DHCANOPCom).ConvertToDateH(operDate)
	s opName=""
	s opId=""
	f  s opId=$O(^DHCANOPArrange(0,"Adm",EpisodeID,opId)) q:opId=""  d
		.s opstdate=$P(^DHCANOPArrange(opId),"^",14)
		.q:opstdate'=operNDate
		.s anaId=$p(^DHCANOPArrange(opId),"^",2)
		.s ordId=$o(^OEORDi(0,"Ana",anaId,""))
		.s ordSubId=$o(^OEORDi(0,"Ana",anaId,ordId,""))
		.s ordStat=$p($g(^OEORD(ordId,"I",ordSubId,1)),"^",13)
		.q:ordStat=12	;撤销不算20161214+dyl
		.q:opId=opaId
		.s ret=1	;只要存在，就提示
	
		
	q ret
}

Query FindPacuRoom(test As %String = "") As %Query(ROWSPEC = "oprId:%String,PacuBedDesc:%String,PacuBedCode:%String")
{
}

ClassMethod FindPacuRoomExecute(ByRef qHandle As %Binary, test As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s oprId=0
	f  s oprId=$o(^DHCANC("OPRoom",oprId)) q:oprId=""  d
		.;q:$p(^DHCANC("OPRoom",oprId),"^",9)'="T"
		.s oprBedType=$p(^DHCANC("OPRoom",oprId),"^",9)
		.q:oprBedType'="P"
		.s PacuBedDesc=$P(^DHCANC("OPRoom",oprId),"^",2)
		.s PacuBedCode=$P(^DHCANC("OPRoom",oprId),"^",1)
		.Do OutputRow9
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow9
	set Data=$lb(oprId,PacuBedDesc,PacuBedCode)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod FindPacuRoomFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPacuRoomExecute ]
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
	Else {				// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindPacuRoomClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPacuRoomExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

// 在web.DHCANArrange中加入下列方法

/// w ##class(web.DHCANArrange).GetRoomIdByRoomDesc("01恢复床")
ClassMethod GetRoomIdByRoomDesc(desc As %String) As %String
{
	q:desc=""
	s roomId="",retStr=""
	f  s roomId=$o(^DHCANC("OPRoom",roomId)) q:roomId=""  d
	.s oproomdes=$p($g(^DHCANC("OPRoom",roomId)),"^",2)
	.q:oproomdes'=desc
	.s retStr=roomId
	q retStr
}

/// Creator: YuanLin
/// CreatDate: 2017-08-23
/// Description: 将术前访视维护数据批量插入到扩展表中
/// Table：dhc_anc_oparrangeextend
/// Input：
/// Output：
/// d ##class(web.UDHCANOPArrange).InsertPreArrangeExtend()
ClassMethod InsertPreArrangeExtend() As %String
{
	&sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Height','身高','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Weight','体重','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_BP','BP/血压','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_Respiration','R/呼吸','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_Pulse','P/脉搏','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_Temper','T/体温','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_ChiefComplaint','主诉','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_OtherNote','其它','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_CardioSystem_YN','心血管是否','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_CardioSystem_ChestPain','胸痛','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_CardioSystem_Palpitation','心悸','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_CardioSystem_Valvular','瓣膜病变','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_CardioSystem_HeartMurmur','杂音','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_CardioSystem_Hypertension','高血压','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_CardioSystem_MyocardialInfarction','心梗','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_CardioSystem_Fatigue','易疲劳','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_CardioSystem_GasTight','气紧','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_CardioSystem_Blank','心血管过去或其它情况','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_RespiSystem_YN','肺和呼吸是否','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_RespiSystem_Smoking','吸烟','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_RespiSystem_QuitSmoking','戒烟','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_RespiSystem_COPD','COPD','PR','Y','术前访视'))  
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_RespiSystem_Pneumonia','肺炎','PR','Y','术前访视'))   
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_RespiSystem_ChronicBronchitis','气管炎','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_RespiSystem_Asthma','哮喘','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_RespiSystem_Corticosteroids','皮质激素','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_RespiSystem_TB','TB','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_RespiSystem_Blank','肺和呼吸过去或其它情况','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_UrogenitalSystem_YN','泌尿生殖是否','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_UrogenitalSystem_Uremia','尿毒症','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_UrogenitalSystem_Hematuria','血尿','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_UrogenitalSystem_RenalInsufficiency','肾功不全','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_UrogenitalSystem_Menstruation','月经','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_UrogenitalSystem_Blank','泌尿生殖过去或其它情况','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_DigestiveSystem_YN','肝胆胃肠是否','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_DigestiveSystem_Hepatopathy','肝病','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_DigestiveSystem_Reflux','反流','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_DigestiveSystem_GastricRetention','胃潴留','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_DigestiveSystem_Ulcer','溃疡','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_DigestiveSystem_Blank','肝胆胃肠过去或其它情况','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_NervoSystem_YN','神经是否','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_NervoSystem_Apoplexy','中风','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_NervoSystem_Twitch','抽搐','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_NervoSystem_NeuromuscularDisorders','神经肌肉病变','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_NervoSystem_Blank','神经过去或其它情况','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_Blood_YN','血液是否','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_Blood_Blank','血液过去或其它情况','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_EndocrSystem_YN','内分泌/代谢是否','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_EndocrSystem_Diabetes','糖尿','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_EndocrSystem_Hyperthyroidism','甲亢/低','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_EndocrSystem_Insulin','胰岛素','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_EndocrSystem_Cortex','皮质','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_EndocrSystem_Blank','内分泌/代谢过去或其它情况','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_Muscle_YN','肌肉是否','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_Muscle_MyastheniaGravis','重症肌无力','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_Muscle_Paralysis','瘫痪','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_Muscle_Blank','肌肉过去或其它情况','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_Spirit_YN','精神是否','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_Spirit_Schizophrenia','精神分裂症','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_Spirit_Depression','抑郁症','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_Spirit_Blank','精神过去或其它情况','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_ObstetricsDepartment_YN','产科是否','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_ObstetricsDepartment_Blank','产科过去或其它情况','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_SmokeDrinkDrug_YN','吸烟嗜酒药物依赖是否','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_Smoking','吸烟','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_Alcohol','嗜酒','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_DrugAddiction','药物成瘾','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_SmokeDrinkDrug_Blank','烟酒药过去或其它情况','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_AllergyHistory_YN','过敏史/病历记录是否','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_DrugAllergy','药物过敏','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_DrugAllergy_Name','药名','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_DrugAllergy_Blank','过敏史/病历记录过去或其它情况','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_OPANHistory_YN','既往麻醉史是否','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_DifficultCannula','插管困难','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_NarcoticAllergy','麻醉药过敏','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_NarcoticAllergy_Blank','既往麻醉史过去或其它情况','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_FamilyHistory_YN','家族史/外科情况是否','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_FamilyHistory_NarcoticAllergy','麻醉药过敏','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_FamilyHistory_NauseaFever','恶性高热','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_FamilyHistory_Blank','家族史/外科情况过去或其它情况','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_SpecialDrugs_YN','现在用特殊药物是否','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_SpecialDrugs_Blank','现在用特殊药物过去或其它情况','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_GeneralCondition_YN','全身情况是否','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_GeneralCondition_Blank','全身情况过去或其它情况','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_AirwayPatency_YN','气道通畅度是否','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_AirwayPatency_Dehisce','张口小于3cm','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_AirwayPatency_Snore','鼾声','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_AirwayPatency_ShortNeck','颈短','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_AirwayPatency_HeadBackRestriction','头后仰受限','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_AirwayPatency_AdamsAppleHight','喉结高','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_AirwayPatency_SmallChin','小下颔','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_AirwayPatency_TrachealTransposition','气管移位','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_AirwayPatency_TrachealCompression','气管压迫','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_AirwayPatency_TrachealTumor','气管肿瘤','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_AirwayPatency_Blank','气道通畅度过去或其它情况','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_Tooth_YN','牙齿是否','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_Tooth_Loose','松动','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_Tooth_Defect','缺失','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_Tooth_Crown','戴冠','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_Tooth_UpperTeeth','上牙','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_Tooth_LowerTeeth','下牙','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_Tooth_Part','部分','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_Tooth_All','全部','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_AnPunctureSite_YN','麻醉穿刺部位是否','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_AnPunctureSite_Infected','感染','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_AnPunctureSite_Malformation','畸形','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_AnPunctureSite_Trauma','外伤','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_AnPunctureSite_Blank','麻醉穿刺部位过去或其它情况','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_ChestRadiograph_YN','胸部X片是否','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_ChestRadiograph_Blank','胸部X片过去或其它情况','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_Electrocardiogram_YN','心电图是否','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_Electrocardiogram_Blank','心电图过去或其它情况','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_WBC','WBC','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_Hb','Hb/HCT','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_PLTS','PLTS','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_PT','PT','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_APTT','APPT','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_LiverFunction','肝功','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_BUN','BUN','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_CREA','CREA','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_Gls','血糖','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_K','K','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_Na','Na','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_Cl','Cl','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_CO2','CO2','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('ASAClass','ASA分级','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('ASAClass.1','ASA分级E','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_FullStomach','是否饱胃','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_HeartFunctionGrade','心功能','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_DyspneaGrade','呼吸困难评级','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_ProblemsSuggestions_Text','目前存在的问题和建议','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_General_Anesthesia','全身麻醉','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_Intraspinal_Anesthesia','椎管内麻醉','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_Field_Blocking','区域阻滞','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_Local_Anesthesia','局部麻醉','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_OpArrangeByPlan','按计划安排手术','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_DelayOperaion','安排当日,但需要延迟手术','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_ArrangeOpOtherDate','继续术前准备,另期安排手术','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_PhysicianAutograph','麻醉住院/主治医师签名','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_PhysicianAutograph_Date','日期','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_ImplementationAutograph','实施麻醉主治医师签名','PR','Y','术前访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Pre_ImplementationAutograph_Date','日期','PR','Y','术前访视'))
}

/// Creator: YuanLin
/// CreatDate: 2017-08-23
/// Description: 将术后访视维护数据批量插入到扩展表中
/// Table：dhc_anc_oparrangeextend
/// Input：
/// Output：
/// d ##class(web.UDHCANOPArrange).InsertPostArrangeExtend()
ClassMethod InsertPostArrangeExtend() As %String
{
 
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Post_BP','BP/血压','PO','Y','术后访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Post_HeartRate','HR/心率','PO','Y','术后访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Post_Respiration','呼吸类型','PO','Y','术后访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Post_Respiration_Text','R/呼吸值','PO','Y','术后访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Post_SPO2','SPO2','PO','Y','术后访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Post_Consciousness_Limpid','清醒','PO','Y','术后访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Post_Consciousness_Lethargy','嗜睡','PO','Y','术后访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Post_Consciousness_Fragile','昏迷','PO','Y','术后访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Post_Consciousness_Death','死亡','PO','Y','术后访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Post_TrachealExtubation','气管拔除','PO','Y','术后访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Post_UnTracheaExtubation','气管未拔','PO','Y','术后访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Post_PCIA','PCIA','PO','Y','术后访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Post_PCEA','PCEA','PO','Y','术后访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Post_AnalgesicEffect_Excellent','镇痛效果优','PO','Y','术后访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Post_AnalgesicEffect_Well','镇痛效果良','PO','Y','术后访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Post_AnalgesicEffect_Poor','镇痛效果差','PO','Y','术后访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Post_SideEffect_NauseaVomit','恶心呕吐','PO','Y','术后访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Post_SideEffect_UrinaryRetention','尿潴留','PO','Y','术后访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Post_SideEffect_Else','其他副作用','PO','Y','术后访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Post_Whereabouts_InpatientWard','病房','PO','Y','术后访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Post_Whereabouts_PACU','麻醉后恢复室(PACU)','PO','Y','术后访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Post_Whereabouts_ICU','重症监护室(ICU)','PO','Y','术后访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Post_NerveBlocking_Whether','神经阻滞麻醉是否','PO','Y','术后访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Post_NerveBlocking_PunctureHematoma','穿刺部位血肿','PO','Y','术后访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Post_NerveBlocking_NerveInjury','神经损伤','PO','Y','术后访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Post_NerveBlocking_Infected','感染','PO','Y','术后访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Post_NerveBlocking_Hemothorax','血气胸','PO','Y','术后访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Post_NerveBlocking_Else','其它神经阻滞麻醉','PO','Y','术后访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Post_IntraspinalAnesthesia_Whether','椎管内麻醉是否','PO','Y','术后访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Post_IntraspinalAnesthesia_PunctureHematoma','穿刺点疼痛红肿','PO','Y','术后访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Post_IntraspinalAnesthesia_BackPain','腰背疼痛','PO','Y','术后访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Post_IntraspinalAnesthesia_NerveInjury','神经损伤','PO','Y','术后访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Post_IntraspinalAnesthesia_Headache','硬脊膜穿破后头痛','PO','Y','术后访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Post_IntraspinalAnesthesia_IntraspinalHematoma','椎管内血肿','PO','Y','术后访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Post_LimbSensation_Upper','上肢','PO','Y','术后访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Post_LimbSensation_Lower','下肢','PO','Y','术后访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Post_LimbSensation_Left','左','PO','Y','术后访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Post_LimbSensation_Right','右','PO','Y','术后访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Post_LimbSensation_Site','部位','PO','Y','术后访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Post_MuscleStrength_Normal','肌力正常','PO','Y','术后访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Post_MuscleStrength_Loss','肌力减退','PO','Y','术后访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Post_MuscleStrength_Disappear','肌力消失','PO','Y','术后访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Post_PainSense_Normal','痛觉正常','PO','Y','术后访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Post_PainSense_Allergy','痛觉过敏','PO','Y','术后访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Post_PainSense_Loss','痛觉减退','PO','Y','术后访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Post_PainSense_Disappear','痛觉消失','PO','Y','术后访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Post_TactileSense_Normal','触觉正常','PO','Y','术后访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Post_TactileSense_Allergy','触觉过敏','PO','Y','术后访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Post_TactileSense_Disappear','触觉消失','PO','Y','术后访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Post_GeneralAnesthesia_Whether','全身麻醉是否','PO','Y','术后访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Post_CerebrovascularAccident','脑血管意外','PO','Y','术后访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Post_PostoperativeAgitation','术后躁动','PO','Y','术后访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Post_CognitiveImpairment','认知障碍','PO','Y','术后访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Post_TracheaIntubation','气管插管','PO','Y','术后访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Post_ToothInjury','牙齿损伤','PO','Y','术后访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Post_SoreThroat','咽喉疼痛','PO','Y','术后访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Post_LaryngealEdema','喉头水肿','PO','Y','术后访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Post_VocalCordInjury','声带损伤','PO','Y','术后访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Post_CartilageDislocation','勺状软骨脱位','PO','Y','术后访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Post_IntraoperativeAwareness','术中知晓','PO','Y','术后访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Post_ElseCondition_Text','其它情况','PO','Y','术后访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Post_AnDoctorSignature','麻醉医师','PO','Y','术后访视'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('Post_SignatureDate','日期','PO','Y','术后访视'))
}

/// Creator: YuanLin
/// CreatDate: 2017-09-15
/// Description: 将恢复室维护数据批量插入到扩展表中
/// Table：dhc_anc_oparrangeextend
/// Input：
/// Output：
/// d ##class(web.UDHCANOPArrange).InsertPacuArrangeExtend()
ClassMethod InsertPacuArrangeExtend() As %String
{
	&sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('PACU_StewardScoreCons2','完全苏醒2分','PA','Y','恢复室'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('PACU_StewardScoreCons1','对刺激有反应1分','PA','Y','恢复室'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('PACU_StewardScoreCons0','对刺激无反应0分','PA','Y','恢复室'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('PACU_StewardScoreResp2','可按医师吩咐咳嗽2分','PA','Y','恢复室'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('PACU_StewardScoreResp1','不用支持可以维持呼吸道通畅1分','PA','Y','恢复室'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('PACU_StewardScoreResp0','呼吸道需要予以支持0分','PA','Y','恢复室'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('PACU_StewardScorePhysical2','肢体能作有意识的活动2分','PA','Y','恢复室'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('PACU_StewardScorePhysical1','肢体无意识活动1分','PA','Y','恢复室'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('PACU_StewardScorePhysical0','肢体无活动0分','PA','Y','恢复室'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('PACU_StewardScore','Steward总分','PA','Y','恢复室'))
    &sql(insert into sqluser.dhc_anc_oparrangeextend(ANCOPAE_Code,ANCOPAE_Desc,ANCOPAE_Type,ANCOPAE_Active,ANCOPAE_ANOPACode) values ('PACU_StewardTime','评分时间','PA','Y','恢复室'))
}

Storage Default
{
<Data name="UDHCANOPArrangeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.UDHCANOPArrangeD</DataLocation>
<DefaultData>UDHCANOPArrangeDefaultData</DefaultData>
<IdLocation>^web.UDHCANOPArrangeD</IdLocation>
<IndexLocation>^web.UDHCANOPArrangeI</IndexLocation>
<StreamLocation>^web.UDHCANOPArrangeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
