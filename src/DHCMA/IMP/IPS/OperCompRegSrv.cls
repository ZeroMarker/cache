/// 名称: DHCMA.IMP.IPS.OperCompRegSrv
/// 描述: 手术并发症登记表服务
/// 编写者：dengshaopeng
/// 编写日期: 2020-06-01
Class DHCMA.IMP.IPS.OperCompRegSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     dengshaopeng
/// CreatDate：   2020-06-01
/// Description:  查询手术并发症相关信息
/// Table：       DHCMA.IMP.IP.OperCompReg
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCMA.IMP.IPS.OperCompRegSrv","QryIMPRegOfSurByDate","","2019-01-01","2020-06-22","","")
Query QryIMPRegOfSurByDate(aComplType As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String, aHospID As %String) As %Query(ROWSPEC = "SurID,MrNo,PatientName,LocDesc,Ward,Sex,Age,OperDesc,OperType,OperLocDesc,OperDate,StartTime,EndDate,EndTime,OpertorName,AnesMethod,Incision,ASAScorer,ComplTypeDesc,ComplDate,ComplLvlDesc,EpisodeID,CategoryDR,IMPOrdNo,Status") [ SqlProc ]
{
}

ClassMethod QryIMPRegOfSurByDateExecute(ByRef qHandle As %Binary, aComplType As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String, aHospID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	Set:aDateFrom'="" aDateFrom =##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateFrom)
	Set:aDateTo'="" aDateTo =##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateTo)
	
 	Set xComplDate=aDateFrom-1
 	For {
	 	Set xComplDate = $o(^MA.IMP.IPOperCompRegI("IdxofComplDate",xComplDate))
	 	Quit:xComplDate=""
	 	Quit:xComplDate>aDateTo
	 	
	 	Set xOperCompRegID =""
	 	For {
		 	Set xOperCompRegID = $O(^MA.IMP.IPOperCompRegI("IdxofComplDate",xComplDate,xOperCompRegID))
		 	Quit:xOperCompRegID=""
		 	Set objOperComp = ##class(DHCMA.IMP.IP.OperCompReg).GetObjById(xOperCompRegID)
		 	Quit:'$IsObject(objOperComp)
		 	Set ComplDate = ##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(xComplDate)  //并发症发生日期
		 	Set SurCompID = objOperComp.%Id()
		 	
		 	Set xOperID = objOperComp.OperationID
		 	
		 	Set ComplTypeStr = objOperComp.ComplTypes
		 	
		 	Set ComplTypeDesc = ""    //并发症类型
		 	Set res =""
		 	if (ComplTypeStr["!"){
				For indCom=1:1:$l(ComplTypeStr,"!"){
					Set ComplTypeID=$p(ComplTypeStr,"!",indCom)
					Set:(aComplType'="")&(ComplTypeID=aComplType) res =1
					Set objComlType = ##class(DHCMA.IMP.BT.OperCompDic).GetObjById(ComplTypeID)
					Set ComplTypeDesc=ComplTypeDesc_","_objComlType.BTDesc
				}
			 	Set:ComplTypeDesc'="" ComplTypeDesc=$e(ComplTypeDesc,2,$l(ComplTypeDesc))
		 	}else{
			 	Set:(aComplType'="")&(ComplTypeStr=aComplType) res =1
			 	Set:ComplTypeStr'="" objComlType = ##class(DHCMA.IMP.BT.OperCompDic).GetObjById(ComplTypeStr)
			 	Set ComplTypeDesc = objComlType.BTDesc
			}
			Continue:(aComplType'="")&(res'=1)
			Set ComplLvlID =objOperComp.ComplLevelDr.%Id()
			Set:ComplLvlID'="" objComplLevel = ##class(DHCMA.IMP.BT.OperCompLvL).GetObjById(ComplLvlID)
			Set ComplLvlDesc = objComplLevel.BTCode_"级"   //并发症分级
			
			Set (MrNo,LocDesc,PatientName,Ward,Sex,Age)=""
			
		 	Set xIMPRegID=objOperComp.RegisterDr
		 	Set objIMPReg = ##class(DHCMA.IMP.IP.IMPRegister).GetObjById(xIMPRegID)
		 	Continue:'$IsObject(objIMPReg)
			Set Status = objIMPReg.StatusDr.BTDesc
		 	Set EpisodeID = objIMPReg.EpisodeID      //就诊号
		 	Set CategoryDR = objIMPReg.IMPRecordDr.IMPCateDr.%Id()
		 	Set IMPOrdNo = objIMPReg.IMPRecordDr.IMPOrdNo
		 	Set objPatientAdm = ##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
		 	Set MrNo = objPatientAdm.MrNo             //病案号
		 	Set PatientID = objPatientAdm.PatientID  //病人ID
		 	Set LocId = objPatientAdm.DepartmentID
		 	Continue:(aLocID'="")&(LocId'=aLocID)
		 	Set LocDesc = objPatientAdm.Department    //科室
		 	Set Ward =objPatientAdm.Ward              //病房
		 	
		 	Set objPatient = ##class(DHCMed.Base.Patient).GetObjById(PatientID)
		 	Set PatientName = objPatient.PatientName  //姓名
		 	Set Sex = objPatient.Sex				  //性别
		 	Set Age = ""							  //年龄
			
		 	//Set:objPatient.Age'="" Age = Age
		 	//Set:objPatient.AgeMonth'="" Age = AgeMonth
		 	//	Set:objPatient.AgeDay'="" Age = AgeDay
		 	if (objPatient.Age){
			 	Set Age = objPatient.Age_"岁"
			}elseif (objPatient.AgeMonth){
				Set Age = objPatient.AgeMonth_"月"
			}elseif (objPatient.AgeDay){
				Set Age = objPatient.AgeDay_"天"
			}
			
		 	Set (OperID,OperDesc,OperType,OperLocDesc,OperDate,StartTime,EndDate,EndTime,OpertorName,AnesMethod,Incision,ASAScore)=""
		 	Set OperData = ..GetOperByEpisodeID(EpisodeID,xOperID)
		 	if (OperData'=""){
				Set OperDesc = $lg(OperData,2)
				Set OperType = $lg(OperData,3)
				Set OperLocDesc = $lg(OperData,4)
				Set OperDate = $lg(OperData,5)
				Set StartTime = $lg(OperData,6)
				Set EndDate = $lg(OperData,7)
				Set EndTime = $lg(OperData,8)
				Set OpertorName = $lg(OperData,9)
				Set AnesMethod = $lg(OperData,10)
				Set Incision = $lg(OperData,11)
				Set ASAScorer = $lg(OperData,12)
				
		 		Set StartTime = OperDate_" "_StartTime
  				Set EndTime = EndDate_" "_EndTime
		 	}
  			Set Data=$lb(SurCompID,MrNo,PatientName,LocDesc,Ward,Sex,Age,OperDesc,OperType,OperLocDesc,OperDate,StartTime,EndDate,EndTime,OpertorName,AnesMethod,Incision,ASAScorer,ComplTypeDesc,ComplDate,ComplLvlDesc,EpisodeID,CategoryDR,IMPOrdNo,Status)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
 	}
	Quit $$$OK
}

ClassMethod QryIMPRegOfSurByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryIMPRegOfSurByDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryIMPRegOfSurByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryIMPRegOfSurByDateExecute ]
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

/// Creator：     mayanpeng
/// CreatDate：   2020-06-03
/// Description:  查询手术并发症相关信息
/// Table：       DHCMA.IMP.IP.OperCompReg
/// Input：       aReportID:DHCMA.IMP.IP.OperCompReg.ID
/// D ##class(%ResultSet).RunQuery("DHCMA.IMP.IPS.OperCompRegSrv","QryIMPRegOfSurByAdm","","","")
Query QryIMPRegOfSurByAdm(aPatientID As %String, aEpisodeID As %String, aReportID As %String) As %Query(ROWSPEC = "MrNo,PatientName,LocDesc,Ward,Sex,Age,OperDesc,OperType,OperLocDesc,OperDate,StartTime,EndDate,EndTime,OpertorName,AnesMethod,Incision,ASAScorer,ComplTypeDesc,ComplDate,ComplLvlDesc") [ SqlProc ]
{
}

ClassMethod QryIMPRegOfSurByAdmExecute(ByRef qHandlex As %Binary, aPatientID As %String, aEpisodeID As %String, aReportID As %String) As %Status
{
	Set repidx=$I(^CacheTemp)
	Set qHandlex=$lb(0,repidx,0)
 	Set indx=1
	Quit:(aPatientID="")&&(aEpisodeID="")&&(aReportID="") $$$OK
	
	If (aEpisodeID'="") {
		Do BuildIMPRegOfSur(aEpisodeID)
	} ElseIf (aPatientID'="") {
		Set xAdmType=""
		For {
			Set xAdmType=$o(^PAPERdr(aPatientID,"ADM",xAdmType))
			Quit:xAdmType=""
			
			Set xEpisodeID=""
			For {
				Set xEpisodeID=$o(^PAPERdr(aPatientID,"ADM",xAdmType,xEpisodeID))
				Quit:xEpisodeID=""
				
				Do BuildIMPRegOfSur(xEpisodeID)
			}
		}
	} ElseIf (aReportID'="") {
		//待补充
	}
	
	Quit $$$OK
BuildIMPRegOfSur(xEpisodeID)
	Set objPatAdm = ##class(DHCMed.Base.PatientAdm).GetObjById(xEpisodeID)
 	Set MrNo = objPatAdm.MrNo             //病案号
 	Set PatientID = objPatAdm.PatientID   //病人ID
 	Set LocId = objPatAdm.DepartmentID
 	//Quit:(aLocID'="")&(LocId'=aLocID) ""
 	Set LocDesc = objPatAdm.Department    //科室
 	Set Ward =objPatAdm.Ward              //病房
 	
 	Set objPatient = ##class(DHCMed.Base.Patient).GetObjById(PatientID)
 	Set PatientName = objPatient.PatientName	//姓名
 	Set Sex = objPatient.Sex					//性别
 	Set Age = ""			//年龄
 	if (objPatient.Age){
	 	Set Age = objPatient.Age_"岁"
	}elseif (objPatient.AgeMonth){
		Set Age = objPatient.AgeMonth_"月"
	}elseif (objPatient.AgeDay){
		Set Age = objPatient.AgeDay_"天"
	}
	
	Set xRationID =""
 	For {
	 	
	 	Set xRationID=$O(^MA.IMP.IPIMPRegisterI("IdxofEpisodeID"," "_$zcvt(xEpisodeID,"U"),xRationID))
	 	Quit:xRationID=""
	 	
	 	Set objIMPReg = ##class(DHCMA.IMP.IP.IMPRegister).GetObjById(xRationID)
	 	Continue:'$IsObject(objIMPReg)
	 	
	 	Set IMPRegID=objIMPReg.%Id()
	 	
	 	
	 	Set objSurComp=##class(DHCMA.IMP.IP.OperCompReg).GetObjByRegisterDr(IMPRegID)
	 	Quit:'$IsObject(objSurComp)
	 	Set xOperID = objSurComp.OperationID
	 	Set ComplDate=objSurComp.ComplDate
	 	Set ComplDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ComplDate)  //并发症发生日期
	 	
	 	Set ComplTypeStr = objSurComp.ComplTypes
	 	
	 	Set ComplTypeDesc=""    //并发症类型
	 	if (ComplTypeStr["!"){
			For indCom=1:1:$l(ComplTypeStr,"!"){
				Set ComplTypeID=$p(ComplTypeStr,"!",indCom)
				Set objComlType = ##class(DHCMA.IMP.BT.OperCompDic).GetObjById(ComplTypeID)
				Set ComplTypeDesc=ComplTypeDesc_","_objComlType.BTDesc
			}
		 	Set:ComplTypeDesc'="" ComplTypeDesc=$e(ComplTypeDesc,2,$l(ComplTypeDesc))
	 	}else{
		 	Set:ComplTypeStr'="" objComlType=##class(DHCMA.IMP.BT.OperCompDic).GetObjById(ComplTypeStr)
		 	Set ComplTypeDesc=objComlType.BTDesc
		}
		Set ComplLvlID=objSurComp.ComplLevelDr.%Id()
		Set:ComplLvlID'="" objComplLevel=##class(DHCMA.IMP.BT.OperCompLvL).GetObjById(ComplLvlID)
		Set ComplLvlDesc=objComplLevel.BTCode_"级"   //并发症分级
		
		Set (OperID,OperDesc,OperType,OperLocDesc,OperDate,StartTime,EndDate,EndTime,OpertorName,AnesMethod,Incision,ASAScore)=""
	 	Set OperData = ..GetOperByEpisodeID(xEpisodeID,xOperID)
	 	if (OperData'=""){
		 	Set OperID = $lg(OperData,1)
			Set OperDesc = $lg(OperData,2)
			Set OperType = $lg(OperData,3)
			Set OperLocDesc = $lg(OperData,4)
			Set OperDate = $lg(OperData,5)
			Set StartTime = $lg(OperData,6)
			Set EndDate = $lg(OperData,7)
			Set EndTime = $lg(OperData,8)
			Set OpertorName = $lg(OperData,9)
			Set AnesMethod = $lg(OperData,10)
			Set Incision = $lg(OperData,11)
			Set ASAScorer = $lg(OperData,12)
			
	 		Set StartTime = OperDate_" "_StartTime
			Set EndTime = EndDate_" "_EndTime
		}
		
		Set Data=$lb(MrNo,PatientName,LocDesc,Ward,Sex,Age,OperDesc,OperType,OperLocDesc,OperDate,StartTime,EndDate,EndTime,OpertorName,AnesMethod,Incision,ASAScorer,ComplTypeDesc,ComplDate,ComplLvlDesc)
		Set ^CacheTemp(repidx,indx)=Data
		Set indx=indx+1
	 }
}

ClassMethod QryIMPRegOfSurByAdmClose(ByRef qHandlex As %Binary) As %Status [ PlaceAfter = QryIMPRegOfSurByAdmExecute ]
{
	Set repidx=$LIST(qHandlex,2)
 	Kill ^CacheTemp(repidx)
 	Quit $$$OK
}

ClassMethod QryIMPRegOfSurByAdmFetch(ByRef qHandlex As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryIMPRegOfSurByAdmExecute ]
{
	Set AtEnd=$LIST(qHandlex,1)
 	Set repidx=$LIST(qHandlex,2)
 	Set indx=$LIST(qHandlex,3)
 	Set indx=$o(^CacheTemp(repidx,indx))
 	If indx="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {	
 		Set Row=^CacheTemp(repidx,indx)
 	}
 	s qHandlex=$lb(AtEnd,repidx,indx)
	Quit $$$OK
}

ClassMethod SetArrangeExtendValue(aOpaId As %String, aItemCode As %String) As %String
{
	New (aOpaId,aItemCode)
	
	Set $ZT="SetArrangeExtendValueErr"
	Set return=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(aOpaId,aItemCode)
	Quit return
	
SetArrangeExtendValueErr
	Quit ""
}

/// Creator 丁延丽 2017-08-03   日期索引：^DHCANOPArrange(0,"SDate",日期数字的)
/// d ##class(%ResultSet).RunQuery("DHCMA.IMP.IPS.OperCompRegSrv","GetAnOpListForM","2017-01-13","2020-01-15","312")
Query GetAnOpListForM(stdate As %String, enddate As %String, EpisodeId As %String) As %Query(ROWSPEC = "OperID,EpisodeID,OperICD,OperDesc,OperType,StartDate,StartTime,EndDate,EndTime,OperHour,OperLocCode,OperLocDesc,OpertorCode,OpertorName,Assistant1,Assistant2,IncisionCode,Incision,HealingCode,Healing,AnesMethodCode,AnesMethod,Anesthesia,ASAScore,NNISGrade,WBC,IncisionNum,IsSightGlass,IsImplants,LoseBlood,GotBlood,Complication,OpaStatus,OperAndDateInfo")
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
	// Update By zhoubo 2017-12-12 手术状态为离室、完成的才算
	//q:(opaStatus'="L")&&(opaStatus'="F")
	s opaPatStatus=$P(^DHCANOPArrange(opaId),"^",23)
	s papmiId=$p($g(^PAADM(admId)),"^",1)
	s chl=$P($P(^DHCANOPArrange(opaId),"^",2),"||",2)
	s jz=$P(^OR(adm,"ANA",chl),"^",32) //ANA_SourceType 急诊(E)/择期(B)
	i jz="E" s jzstat="急诊"
	e  s jzstat="择期"
	;;;;最后手术登记存放的时间，20120607+dyl
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
	s anCompDesc=""                                         //+ wxl 090316 合并疾病
	s subchl=0 f  s subchl=$O(^OR(adm,"ANA",chl,"COMP",subchl)) q:(subchl="")  d
	.s AnCompDr=$P(^OR(adm,"ANA",chl,"COMP",subchl),"^",1)
	.q:AnCompDr=""
	.i anCompDesc="" s anCompDesc=$P(^ORC("COMP",AnCompDr),"^",2)
	.e  s anCompDesc=anCompDesc_","_$P(^ORC("COMP",AnCompDr),"^",2)
	s i=0
	s icdCodeStr="",OpertorCode="",opdes="",anaopBladeTypeCode="",anaopBladeType=""
	s subchl=0 f  s subchl=$O(^OR(adm,"ANA",chl,"OP",subchl)) q:(subchl="")  d
	.s opdr=$P($g(^OR(adm,"ANA",chl,"OP",subchl)),"^",6) ;ANAOP_Type_DR ；手术名称
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
	..s tmpCode=$p($g(^ORC("BLDTP",curAnaopBladeTypeId)),"^",1)
	..i anaopBladeTypeCode'="" d
	...s anaopBladeTypeCode=anaopBladeTypeCode_","_tmpCode
	...s anaopBladeType=anaopBladeType_","_$p($g(^ORC("BLDTP",+curAnaopBladeTypeId)),"^",2)
	..e  s anaopBladeTypeCode=tmpCode,anaopBladeType=$p($g(^ORC("BLDTP",+curAnaopBladeTypeId)),"^",2)

	s EpisodeID=$P(^DHCANOPArrange(opaId),"^",1)

	s anaId=$P(^DHCANOPArrange(opaId),"^",2)
	s anaSub=$P(anaId,"||",2)
	s appLocId=$P($G(^DHCANOPArrange(opaId)),"^",54) //OPA_AppLoc_Dr
	s appLocDesc=$P($G(^CTLOC(+appLocId)),"^",2)
	s appLocCode=$P($G(^CTLOC(+appLocId)),"^",1)
	s ASA=##class(web.DHCANAdaptor).GetExtendValueByOpaId(opaId,"NNISRate")
	Set Anesthesia=mzdoc   // 麻醉医师
	// 手术时长
	Set OperHour = ##class(DHCMA.IMP.IPS.OperCompRegSrv).GetHourByDateTime(opstdate,opsttime,openddate,opendtime)
	//术后登记的时候修改手术开始日期
	s newSdate=""
	i anaTheatreInDate'="" s newSdate=anaTheatreInDate
	e  s newSdate=opstdate 
	s OperAndDateInfo = opdes_"("_newSdate_")"
	s ^TMPAN("AppM",$j,opaId)=$lb(opaId,EpisodeID,icdCodeStr,opdes,jzstat,newSdate,opsttime,openddate,opendtime,OperHour,appLocCode,appLocDesc,OpertorCode,surgeonDesc,ass1,ass2,anaopBladeTypeCode,anaopBladeType,HealingCode,Healing,anmethodCodeStr,anmethod,Anesthesia,ASA,NNISGrade,WBC,IncisionNum,IsSightGlass,IsImplants,LoseBlood,GotBlood,anCompDesc,opaStatus,OperAndDateInfo)
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

/// w ##class(DHCMA.IMP.IPS.OperCompRegSrv).GetOperByEpisodeID(1)
ClassMethod GetOperByEpisodeID(aEpisodeId As %String, aOperID As %String) As %List
{
	New (aEpisodeId,aOperID)	
	Set ret=$Lb("")
	
	Quit:aEpisodeId="" ret 
	s opaId=""
	For{
		//Quit:OperDesc'=""
		Set opaId=$O(^DHCANOPArrange(0,"Adm",aEpisodeId,opaId)) 
		q:opaId=""
		
		continue:aOperID'=opaId
		q:$d(^DHCANOPArrange(opaId))<1
		s ifOutOper=$g(^DHCANOPArrange("OUTOP",opaId))
		//continue:(ifOutOper="O") ;门诊不在之内
		s opdate="",oproomdes="",regNo="",patName="",diag=""
		s sopdes="",locdes="",opd="",mzdoc="",anmethod=""
		s xsh="",xch="",OPCategory="",opUnPlanedOperation="",ASA=""
		s IsSightGlass="",IsImplants="",LoseBlood="",GotBlood="",Complication=""
		s OperLocCode="",OperLocDesc="",OpertorCode="",OpertorName="",Assistant1="",Assistant2=""
		s IncisionCode="",Incision="",HealingCode="",Healing="",AnesMethodCode=""
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
		// Update By zhoubo 2017-12-12 手术状态为离室、完成的才算
		//q:(opaStatus'="L")&&(opaStatus'="F")
		s opaPatStatus=$P(^DHCANOPArrange(opaId),"^",23)
		s papmiId=$p($g(^PAADM(admId)),"^",1)
		s chl=$P($P(^DHCANOPArrange(opaId),"^",2),"||",2)
		s jz=$P(^OR(adm,"ANA",chl),"^",32) //ANA_SourceType 急诊(E)/择期(B)
		i jz="E" s jzstat="急诊"
		e  s jzstat="择期"
		;;;;最后手术登记存放的时间，20120607+dyl
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
		
		s OPLevelId = $p($g(^OR(adm,"ANA",chl,"OP",1,"DHC")),"^",1)
		s OPCategoryId=+OPLevelId,OPCategory=$p($g(^ORC("CATEG",+OPCategoryId)),"^",2)  ;通过手术申请获取手术级别
		
		//术前诊断
		s prediag="",diamen="",OPLevelId="",mainOperDr="",opdocstr="",bodsDesc="",diag=""
		s subchl=0 f  s subchl=$O(^OR(adm,"ANA",chl,"OP",subchl)) q:(subchl="")  d ///ck091117
		.i opdocstr'="" s opdocstr=opdocstr_";"_surgeonDesc_","
		.e  s opdocstr=surgeonDesc_","
		.s predigdrS=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",4)   		;ANAOP_PreopDiag_DR 术前诊断字符串  zhangtao add
		.s num=$l(predigdrS,"|")
		.f pi=1:1:num d
			..s predigdr=$p(predigdrS,"|",pi)
			..i predigdr'=""  d
			...s prediag=$P(^MRC("ID",predigdr),"^",2)
			..s $p(diag,",",pi)=$G(prediag)
			..e  d
				...i $g(^OR(adm,"ANA",chl,"TXT",2))'="" d 
				....s diamen=$p(^OR(adm,"ANA",chl,"TXT",2),"|",pi)  	//ck091210 麻醉表存放诊断备注ANA_Notes
				....s $p(diag,",",pi)=$G(diamen)            //zhangtao add
				....b ;1
		.s operLocId=$P(^OR(adm,"ANA",chl,"OP",1),"^",10) 		;ANAOP_CTLOC_DR
		
		.s ass1="",ass2="",ass3=""
		.s as=0 f  s as=$O(^OR(adm,"ANA",chl,"OP",subchl,"ASS",as)) q:(as="")  d
			..s asdr=$P(^OR(adm,"ANA",chl,"OP",subchl,"ASS",as),"^",1)
			..i as=1 s ass1=##class(web.DHCANOPCom).GetNameById(asdr)
			..i as=2 s ass2=##class(web.DHCANOPCom).GetNameById(asdr)
			..i as=3 s ass3=##class(web.DHCANOPCom).GetNameById(asdr)
		
		i mzdr'="" {	
			s mzdoc=##class(web.DHCANOPCom).GetNameById(mzdr)		;麻醉医师
		}else{  
			s mzdoc=""
		}
		s anmethod="",anmethodCodeStr=""
		s anmthdr=$P(^OR(adm,"ANA",chl),"^",5)
		s anmthdr=$tr(anmthdr,"|",",")
		if anmthdr'="" {
			s anmetNum=$l(anmthdr,",")
			for i=1:1:anmetNum {
				s anmetId=$p(anmthdr,",",i)
				q:anmetId=""
				s anmethodCode=$p($g(^ORC("ANMET",anmetId)),"^",1)
				s anmetDesc=$p($g(^ORC("ANMET",anmetId)),"^",2)
				i $P(anmetDesc,"-",2)'="" s anmetDesc=$P(anmetDesc,"-",2)
				i (anmethod'="")&(anmethod'[anmetDesc) s anmethod=anmethod_","_anmetDesc
				i (anmethod'="")&(anmethod[anmetDesc) s anmethod=anmethod
				e  s anmethod=anmetDesc
				e  i (anmethodCodeStr'="")&(anmethodCodeStr'[anmethodCode) s anmethodCodeStr=anmethodCodeStr_","_anmethodCode
				e  i (anmethodCodeStr'="")&(anmethodCodeStr[anmethodCode) s anmethodCodeStr=anmethodCode
				e  s anmethodCodeStr=anmethodCode
			}
		}
		
		;并发症
		s anCompDesc=""                                         //+ wxl 090316 合并疾病
		s subchl=0 
		for {
			s subchl=$O(^OR(adm,"ANA",chl,"COMP",subchl)) 
			q:(subchl="")
			s AnCompDr=$P(^OR(adm,"ANA",chl,"COMP",subchl),"^",1)
			q:AnCompDr=""
			i anCompDesc="" s anCompDesc=$P(^ORC("COMP",AnCompDr),"^",2)
			e  s anCompDesc=anCompDesc_","_$P(^ORC("COMP",AnCompDr),"^",2)
		}
		s i=0
		s icdCodeStr="",OpertorCode="",opdes="",anaopBladeTypeCode="",anaopBladeType=""
		s subchl=0 
		for {
			s subchl=$O(^OR(adm,"ANA",chl,"OP",subchl)) q:(subchl="")  
			s opdr=$P($g(^OR(adm,"ANA",chl,"OP",subchl)),"^",6) ;ANAOP_Type_DR ；手术名称
			i opdr'=""  {
				i $P($g(^ORC("OPER",+opdr)),"^",2)'="" {  
					s operICDcode=$p(^ORC("OPER",+opdr),"^",14)
					i opdes'="" s opdes=opdes_"," _$P($g(^ORC("OPER",+opdr)),"^",2)
					e  s opdes=$P($g(^ORC("OPER",+opdr)),"^",2)
					i icdCodeStr'="" s icdCodeStr=icdCodeStr _"," _operICDcode
					e  s icdCodeStr=operICDcode
				}
			}else{
				i $g(^OR(adm,"ANA",chl,"OP",subchl,"REM",2))'="" {
					s opdes=$G(^OR(adm,"ANA",chl,"OP",subchl,"REM",2))
				}
			}
			s i=i+1
			q:i>1 ;手术级别只取主手术的
			s opd=""
			s docdr=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",8) ;ANAOP_Surgeon_DR 手术医师
			i docdr'="" {
				s opd=##class(web.DHCANOPCom).GetNameById(docdr)
				s userId=$o(^SSU("SSUSR",0,"CTPCP",docdr,""),-1)
				i userId'="" s OpertorCode=$p($g(^SSU("SSUSR",userId)),"^",1)
			}
			s surgeonDesc=opd   
			s operLocId=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",10) ;ANAOP_CTLOC_DR
			s as=0 
			for  {
				s as=$O(^OR(adm,"ANA",chl,"OP",subchl,"ASS",as)) q:(as="")  
				s asdr=$P(^OR(adm,"ANA",chl,"OP",subchl,"ASS",as),"^",1)
				i as=1 s ass1=##class(web.DHCANOPCom).GetNameById(asdr)
				i as=2 s ash=##class(web.DHCANOPCom).GetNameById(asdr)
				}
			s curAnaopBladeTypeId=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",9)
		}
		i curAnaopBladeTypeId'="" {
			s tmpCode=$p($g(^ORC("BLDTP",curAnaopBladeTypeId)),"^",1)
			if anaopBladeTypeCode'="" {
				s anaopBladeTypeCode=anaopBladeTypeCode_","_tmpCode
				s anaopBladeType=anaopBladeType_","_$p($g(^ORC("BLDTP",+curAnaopBladeTypeId)),"^",2)
			}else{ s anaopBladeTypeCode=tmpCode,anaopBladeType=$p($g(^ORC("BLDTP",+curAnaopBladeTypeId)),"^",2)}
		}
		s EpisodeID=$P(^DHCANOPArrange(opaId),"^",1)

		s anaId=$P(^DHCANOPArrange(opaId),"^",2)
		s anaSub=$P(anaId,"||",2)
		s appLocId=$P($G(^DHCANOPArrange(opaId)),"^",54) //OPA_AppLoc_Dr
		s appLocDesc=$P($G(^CTLOC(+appLocId)),"^",2)
		s appLocCode=$P($G(^CTLOC(+appLocId)),"^",1)
		s ASA=##class(web.DHCANAdaptor).GetExtendValueByOpaId(opaId,"NNISRate")
		Set Anesthesia=mzdoc   // 麻醉医师
		// 手术时长
		Set OperHour = ##class(DHCMA.IMP.IPS.OperCompRegSrv).GetHourByDateTime(opstdate,opsttime,openddate,opendtime)
		//术后登记的时候修改手术开始日期
		s newSdate=""
		i anaTheatreInDate'="" s newSdate=anaTheatreInDate
		e  s newSdate=opstdate
		s OperDesc = opdes
		s OperType = jzstat
		s OperLocDesc = appLocDesc
		s OperDate = newSdate
		s StartTime = opsttime
		s EndDate = openddate
		s EndTime = opendtime
		s OpertorName = surgeonDesc
		s Assistant1 = ass1
		s Assistant2 = ass2
		s AnesMethod = anmethod
		s Incision = anaopBladeType
		s ASAScorer = ASA
		
		S Data = $lb(opaId,OperDesc,OperType,OperLocDesc,OperDate,StartTime,EndDate,EndTime,OpertorName,AnesMethod,Incision,ASAScorer,OPCategory,diag,Assistant1,Assistant2)
		S ret =Data
	}
	q ret
}

/// Creator：     dengshaopeng
/// CreatDate：   2020-06-03
/// Description:  查询手术相关信息
/// Table：       
/// Input：       aEpisodeID aOperID
/// w ##class(DHCMA.IMP.IPS.OperCompRegSrv).GetOperDate(4,9)
ClassMethod GetOperDate(aEpisodeID As %String, aOperID As %String) As %String
{
	new (aEpisodeID,aOperID)
	Set return=""
	Set OperData = ..GetOperByEpisodeID(aEpisodeID,aOperID)
 	if (OperData'=""){
	 	Set OperID = $lg(OperData,1)
		Set OperDesc = $lg(OperData,2)
		Set OperType = $lg(OperData,3)
		Set OperLocDesc = $lg(OperData,4)
		Set OperDate = $lg(OperData,5)
		Set StartTime = $lg(OperData,6)
		Set EndDate = $lg(OperData,7)
		Set EndTime = $lg(OperData,8)
		Set OpertorName = $lg(OperData,9)
		Set AnesMethod = $lg(OperData,10)
		Set Incision = $lg(OperData,11)
		Set ASAScorer = $lg(OperData,12)
		Set OPCategory = $lg(OperData,13)
		Set diag = $lg(OperData,14)
		set diagDescStr=""
		if (diag["&&&"){
			For indCom=1:1:$l(diag,"&&&"){
				Set diagStr=$p(diag,"&&&",indCom)
				if (diagStr["###"){
					Set diagDesc = $p(diagStr,"###",2)
					Set diagDescStr = diagDesc_","_diagDescStr		
				}
			}
	 	}else{
		 	if (diag["###"){
				Set diagDesc = $p(diag,"###",2)
				Set diagDescStr = diagDesc
			}else{
				set diagDescStr=diag
			}
		}
		Set Assistant1 = $lg(OperData,15)
		Set Assistant2 = $lg(OperData,16)
	}
	Set return= OperDate_"^"_OPCategory_"^"_diagDescStr_"^"_AnesMethod_"^"_OpertorName_"^"_Assistant1_"^"_Assistant2
	Quit return
}

/// Creator：     dengshaopeng
/// CreatDate：   2020-08-04
/// Description:  查询是否已登记手术并发症
/// Table：       
/// Input：       aEpisodeID aOperID
/// Out：         0 未登记 1 已登记
/// w ##class(DHCMA.IMP.IPS.OperCompRegSrv).IsOperCompRegister(4)
ClassMethod IsOperCompRegister(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return = 0
	Quit:aEpisodeID="" return
	
	Set objIMPRecord = ##class(DHCMA.IMP.IP.IMPRecord).GetObjByEpisodeID(aEpisodeID)
	Quit:'$IsObject(objIMPRecord) return
	//Quit:'$IsObject(objIMPRecord.Status) return
	Set RegStatus = objIMPRecord.Status.BTDesc
	Set LinkedRegInfo = objIMPRecord.LinkedRegInfo
	Quit:'$IsObject(LinkedRegInfo) return
	Set RegInfoId = LinkedRegInfo.%Id()
	Set objRegInfo = ##class(DHCMA.IMP.IP.IMPRecordReg).GetObjById(RegInfoId)
	Set:($IsObject(objRegInfo))&(RegStatus'["排除")&(RegStatus'["自动") return=1
	Quit return
}

/// Creator：     dengshaopeng
/// CreatDate：   2020-08-11
/// Description:  根据就诊号查询入院诊断
/// Table：       
/// Input：       aEpisodeID
/// w ##class(DHCMA.IMP.IPS.OperCompRegSrv).GetAdmDiagnos(4)
ClassMethod GetAdmDiagnos(aEpisodeID As %String) As %String
{
	Set return=""
	Set MRAdm=$p($g(^PAADM(+aEpisodeID)),"^",61)
	Quit:MRAdm="" return
	
	Set xDiagnosID=""
	For {
		Set xDiagnosID=$o(^MR(MRAdm,"DIA",xDiagnosID))
		Quit:xDiagnosID=""
		
		Set tmpDiagnos=$g(^MR(MRAdm,"DIA",xDiagnosID))	
		Set ICDDxID=$p(tmpDiagnos,"^",1)
		Set ICD10=$p($g(^MRC("ID",+ICDDxID)),"^",4)											//ICD10代码
		Set ICDDesc=$p($g(^MRC("ID",+ICDDxID)),"^",2)										//ICD诊断描述
		Set ICDDesc=$tr(ICDDesc," ","")
		Set DesID=$o(^MR(MRAdm,"DIA",xDiagnosID,"DES",0))
		Set:DesID="" DesID=1
		Set ICDDHC=$g(^MR(MRAdm,"DIA",xDiagnosID,"DHC",DesID))								//???好像不存在
		Set ICDDES=$g(^MR(MRAdm,"DIA",xDiagnosID,"DES",DesID))								//诊断备注
		Set MRDiagType=$o(^MR(MRAdm,"DIA",xDiagnosID,"TYP",0))
		Set TypeDesc=""
		If MRDiagType'="" {
			Set TypeDicID=$g(^MR(MRAdm,"DIA",xDiagnosID,"TYP",MRDiagType))
			Set TypeDesc=$p($g(^MRC("DTYP",+TypeDicID)),"^",2) 								//诊断类型描述
			
		}
		Continue:TypeDesc'["入院诊断"
		
		//Set:ICDDES'="" ICDDesc=ICDDesc_" "_ICDDES
		//Set:ICDDHC'="" ICDDesc=ICDDesc_" "_ICDDHC
		Set return =ICDDxID_"^"_ICD10_"^"_ICDDesc_"^"_TypeDesc
	}
	Quit return
}

/// Creator：     dengshaopeng
/// CreatDate：   2020-08-11
/// Description:  根据就诊号查询诊断
/// Table：       
/// Input：       aEpisodeID
/// w ##class(DHCMA.IMP.IPS.OperCompRegSrv).GetDisDiagnos(4)
ClassMethod GetDisDiagnos(aEpisodeID As %String) As %String
{
	Set return=""
	Set MRAdm=$p($g(^PAADM(+aEpisodeID)),"^",61)
	Quit:MRAdm="" return
	
	Set xDiagnosID=""
	For {
		Set xDiagnosID=$o(^MR(MRAdm,"DIA",xDiagnosID))
		Quit:xDiagnosID=""
		
		Set tmpDiagnos=$g(^MR(MRAdm,"DIA",xDiagnosID))	
		Set ICDDxID=$p(tmpDiagnos,"^",1)
		Set ICD10=$p($g(^MRC("ID",+ICDDxID)),"^",4)											//ICD10代码
		Set ICDDesc=$p($g(^MRC("ID",+ICDDxID)),"^",2)										//ICD诊断描述
		Set ICDDesc=$tr(ICDDesc," ","")
		Set DesID=$o(^MR(MRAdm,"DIA",xDiagnosID,"DES",0))
		Set:DesID="" DesID=1
		Set ICDDHC=$g(^MR(MRAdm,"DIA",xDiagnosID,"DHC",DesID))								//???好像不存在
		Set ICDDES=$g(^MR(MRAdm,"DIA",xDiagnosID,"DES",DesID))								//诊断备注
		Set MRDiagType=$o(^MR(MRAdm,"DIA",xDiagnosID,"TYP",0))
		Set TypeDesc=""
		If MRDiagType'="" {
			Set TypeDicID=$g(^MR(MRAdm,"DIA",xDiagnosID,"TYP",MRDiagType))
			Set TypeDesc=$p($g(^MRC("DTYP",+TypeDicID)),"^",2) 								//诊断类型描述
			
		}
		Continue:TypeDesc'["出院诊断"
		
		//Set:ICDDES'="" ICDDesc=ICDDesc_" "_ICDDES
		//Set:ICDDHC'="" ICDDesc=ICDDesc_" "_ICDDHC
		Set return =ICDDxID_"^"_ICD10_"^"_ICDDesc_"^"_TypeDesc
	}
	Quit return
}

/// Creator zhangdc 2020-10-27   日期索引：^DHCANOPArrange(0,"SDate",日期数字的)
/// d ##class(%ResultSet).RunQuery("DHCMA.IMP.IPS.OperCompRegSrv","GetAnOpListForIMP","","","4","9,36")
Query GetAnOpListForIMP(stdate As %String, enddate As %String, EpisodeId As %String, OperationID As %String) As %Query(ROWSPEC = "OperID,EpisodeID,OperICD,OperDesc,OperType,StartDate,StartTime,EndDate,EndTime,OperHour,OperLocCode,OperLocDesc,OpertorCode,OpertorName,Assistant1,Assistant2,IncisionCode,Incision,HealingCode,Healing,AnesMethodCode,AnesMethod,Anesthesia,ASAScore,NNISGrade,WBC,IncisionNum,IsSightGlass,IsImplants,LoseBlood,GotBlood,Complication,OpaStatus")
{
}

ClassMethod GetAnOpListForIMPExecute(ByRef qHandle As %Binary, stdate As %String, enddate As %String, EpisodeId As %String, OperationID As %String) As %Status
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
		.d GetANOperationForIMP
	}else {  
		f date=sdate:1:+edate {
			s opaId=""
			f  s opaId=$O(^DHCANOPArrange(0,"SDate",date,opaId)) q:opaId=""  d
			.d GetANOperationForIMP  
		}
	}  
	k ^TMPAN("AppM",$j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

GetANOperationForIMP
	q:$d(^DHCANOPArrange(opaId))<1
	q:OperationID'[opaId
	s ifOutOper=$g(^DHCANOPArrange("OUTOP",opaId))
	q:(ifOutOper="O") ;门诊不在之内
	s opdate="",oproomdes="",regNo="",patName="",diag=""
	s sopdes="",locdes="",opd="",mzdoc="",anmethod=""
	s xsh="",xch="",OPCategory="",opUnPlanedOperation="",ASA=""
	s IsSightGlass="",IsImplants="",LoseBlood="",GotBlood="",Complication=""
	s OperLocCode="",OperLocDesc="",OpertorCode="",OpertorName="",Assistant1="",Assistant2=""
	s IncisionCode="",Incision="",HealingCode="",Healing="",AnesMethodCode=""
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
	// Update By zhoubo 2017-12-12 手术状态为离室、完成的才算
	//q:(opaStatus'="L")&&(opaStatus'="F")
	s opaPatStatus=$P(^DHCANOPArrange(opaId),"^",23)
	s papmiId=$p($g(^PAADM(admId)),"^",1)
	s chl=$P($P(^DHCANOPArrange(opaId),"^",2),"||",2)
	s jz=$P(^OR(adm,"ANA",chl),"^",32) //ANA_SourceType 急诊(E)/择期(B)
	i jz="E" s jzstat="急诊"
	e  s jzstat="择期"
	;;;;最后手术登记存放的时间，20120607+dyl
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
	s anCompDesc=""                                         //+ wxl 090316 合并疾病
	s subchl=0 f  s subchl=$O(^OR(adm,"ANA",chl,"COMP",subchl)) q:(subchl="")  d
	.s AnCompDr=$P(^OR(adm,"ANA",chl,"COMP",subchl),"^",1)
	.q:AnCompDr=""
	.i anCompDesc="" s anCompDesc=$P(^ORC("COMP",AnCompDr),"^",2)
	.e  s anCompDesc=anCompDesc_","_$P(^ORC("COMP",AnCompDr),"^",2)
	s i=0
	s icdCodeStr="",OpertorCode="",opdes="",anaopBladeTypeCode="",anaopBladeType=""
	s subchl=0 f  s subchl=$O(^OR(adm,"ANA",chl,"OP",subchl)) q:(subchl="")  d
	.s opdr=$P($g(^OR(adm,"ANA",chl,"OP",subchl)),"^",6) ;ANAOP_Type_DR ；手术名称
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
	..s tmpCode=$p($g(^ORC("BLDTP",curAnaopBladeTypeId)),"^",1)
	..i anaopBladeTypeCode'="" d
	...s anaopBladeTypeCode=anaopBladeTypeCode_","_tmpCode
	...s anaopBladeType=anaopBladeType_","_$p($g(^ORC("BLDTP",+curAnaopBladeTypeId)),"^",2)
	..e  s anaopBladeTypeCode=tmpCode,anaopBladeType=$p($g(^ORC("BLDTP",+curAnaopBladeTypeId)),"^",2)

	s EpisodeID=$P(^DHCANOPArrange(opaId),"^",1)

	s anaId=$P(^DHCANOPArrange(opaId),"^",2)
	s anaSub=$P(anaId,"||",2)
	s appLocId=$P($G(^DHCANOPArrange(opaId)),"^",54) //OPA_AppLoc_Dr
	s appLocDesc=$P($G(^CTLOC(+appLocId)),"^",2)
	s appLocCode=$P($G(^CTLOC(+appLocId)),"^",1)
	s ASA=$p(..SetArrangeExtendValue(opaId,"ASAClass"),$c(3),1)
	Set Anesthesia=mzdoc   // 麻醉医师
	// 手术时长
	Set OperHour = ##class(DHCMA.IMP.IPS.OperCompRegSrv).GetHourByDateTime(opstdate,opsttime,openddate,opendtime)
	//术后登记的时候修改手术开始日期
	s newSdate=""
	i anaTheatreInDate'="" s newSdate=anaTheatreInDate
	e  s newSdate=opstdate
	s ^TMPAN("AppM",$j,opaId)=$lb(opaId,EpisodeID,icdCodeStr,opdes,jzstat,newSdate,opsttime,openddate,opendtime,OperHour,appLocCode,appLocDesc,OpertorCode,surgeonDesc,ass1,ass2,anaopBladeTypeCode,anaopBladeType,HealingCode,Healing,anmethodCodeStr,anmethod,Anesthesia,ASA,NNISGrade,WBC,IncisionNum,IsSightGlass,IsImplants,LoseBlood,GotBlood,anCompDesc,opaStatus)
	d OutRow3
	q

OutRow3
	Set ^CacheTemp(repid,ind)=^TMPAN("AppM",$j,opaId)
	Set ind=ind+1
	quit
}

ClassMethod GetAnOpListForIMPFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAnOpListForIMPExecute ]
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

ClassMethod GetAnOpListForIMPClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAnOpListForIMPExecute ]
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
/// Debug:		  w ##class(DHCMA.IMP.IPS.OperCompRegSrv).GetHourByDateTime("2017-08-04","01:00:00","2017-08-04","05:00:00")
ClassMethod GetHourByDateTime(aFromDate As %String, aFromTime As %String, aEndDate As %String, aEndTime As %String) As %String
{
	New (aFromDate,aFromTime,aEndDate,aEndTime)
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

}
