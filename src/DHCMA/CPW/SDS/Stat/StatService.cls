/// 统计单病种上报基础信息
Class DHCMA.CPW.SDS.Stat.StatService Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// 单病种病例上报情况统计
/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.SDS.Stat.StatService","QryStat","","2021-01-01","2021-05-01","","","")
Query QryStat(aHospID As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String, aQCEntityID As %String, aDocID As %String = "", aDateType As %String) As %Query(ROWSPEC = "xID:%String,InLocDesc:%String,DishLocDesc:%String,QCEntityName:%String,QCState:%String,HospCost:%Integer,DrugCost:%Integer,MateriaCost:%Integer,CNDrugCost:%Integer,AdmDays:%Integer,DischCondDesc:%String,QCStateFlg:%String,UpLastDays:%Integer,DocDesc:%String,AdmLocID:%String,QCEntityID:%String,OperComFlg:%String") [ SqlProc ]
{
}

ClassMethod QryStatExecute(ByRef qHandle As %Binary, aHospID As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String, aQCEntityID As %String, aDocID As %String = "", aDateType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Set ^tmp520=aDocID
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
 	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
 	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
 	Set:aDateFrom["/" aDateFrom=$zdh(aDateFrom,4)
 	Set:aDateTo["/" aDateTo=$zdh(aDateTo,4)
	Set Count=0
	Set DischDateIndex=##Class(DHCMA.Util.IO.FromHisSrv).GetDischDateIndex()  //update by pylian 2016-01-21取出院时间索引
    Set:aDateType="2" DischDateIndex="PAADM_AdmDate"
    For xDate=aDateFrom:1:aDateTo {
		Set xPaadm=""
		For {
			Set xPaadm=$o(^PAADMi(DischDateIndex,xDate,xPaadm))
			Quit:xPaadm=""
			Set AdmInfo=$g(^PAADM(xPaadm))
			Continue:$p(AdmInfo,"^",2)'="I"           //就诊类型过滤
			Continue:$p(AdmInfo,"^",20)="C"           //就诊状态过滤
			Set EpisodeID=##class(DHCMA.Util.EPS.OIDService).GetValidOID(xPaadm)
			Set xID="",QCStateFlg=0,UpDate="",UpLastDays=""
			Set xID=$o(^DHCMA.CPW.SD.QCMrListI("IndexEpisodeID",EpisodeID,""),-1)
			Continue:xID=""
			Set obj=##class(DHCMA.CPW.SD.QCMrList).GetObjById(xID)
			Continue:'$IsObject(obj)
			Set QCState=obj.QCState
			Continue:QCState="O"
			Set CurrStatusSubID=$o(^DHCMA.CPW.SD.QCMrListStateI("IndexParref",xID,""),-1)
			Set CurrStatusID=xID_"||"_CurrStatusSubID
			Set StatusObj=##class(DHCMA.CPW.SD.QCMrListState).GetObjById(CurrStatusID)	
			Set StateCode=QCState
			Set:$IsObject(StatusObj) StateCode=StatusObj.StateCode.BTCode
			Set QCStateFlg=$Select(StateCode="Submit":1,StateCode="Check":2,StateCode="Up":3,1:0)
			Set:QCStateFlg=3 UpDate=StatusObj.StateDate
			Set QCEntity=obj.QCEntityDr
			Continue:'$IsObject(QCEntity)
			Continue:(QCEntity.BTIsActive'=1)
			Set QCEntityID=QCEntity.%Id()
			Continue:(aQCEntityID'="")&&(aQCEntityID'=QCEntityID)
			Set QCEntityCode=QCEntity.BTCode
			Set QCEntityName=QCEntity.BTDesc
			Set EpisodeID=obj.QCEpisodeID
			Set InLocOID=obj.QCInLocID
			Set objInLoc=##class(DHCMA.Util.EP.Location).GetObjByOID(InLocOID)
			Set InLocDesc="",InLocID=""
			If ($IsObject(objInLoc)){
				Set InLocID=+InLocOID
				Set InLocDesc=objInLoc.BTDesc
				Set:InLocDesc["-" InLocDesc=$p(InLocDesc,"-",2)
			}
			Set xHospID=+$p($g(^CTLOC(($p(InLocID,"!!",1)))),"^",22)
 			Continue:(aHospID'="")&&(aHospID'[xHospID)
			Set (HospCost,DrugCost,MateriaCost,CNDrugCost,AdmDays)=0
			Set objPaadm=##class(DHCMA.Util.EPy.EpisodeSrv).GetSynObjByOID(EpisodeID)
			Continue:'$IsObject(objPaadm)
			Set AdmLoc=objPaadm.PAAdmLocID
			Set AdmDocID=objPaadm.PAAdmDocID
			//按当前科室过滤
			Continue:(aLocID'="")&&(aLocID'=AdmLoc)  
			Continue:(aDocID'="")&&(aDocID'=AdmDocID)
			//Continue:(aLocID'="")&&(aLocID'=InLocID) //以入组科室显示
			Set AdmDays=objPaadm.PAAdmDays
			Set DishDate=objPaadm.PADischDate
			Set:DishDate="" DishDate=+$h
			Set PAAdmDate=objPaadm.PAAdmDate
			Set:PAAdmDate["-" PAAdmDate=$zdh(objPaadm.PAAdmDate,3)
			Set:AdmDays<0 AdmDays=+$h-PAAdmDate
			Set:UpDate'="" UpLastDays=UpDate-DishDate
			Set:UpLastDays<0 UpLastDays=0
			Set Paadm=$P(EpisodeID,"!!",1)
			Set (DrugCost,HospCost,MateriaCost,CNDrugCost)=0
			Set Count=Count+1
			Set objFee=##class(DHCMA.CPW.SD.DataSrv.FeeInfoSrv).GetDataByAdm(Paadm)
			Continue:'$IsObject(objFee) 
			Set HospCost=objFee.Fee1
			Set DrugCost=objFee.Fee18
			Set CNDrugCost=objFee.Fee20+objFee.Fee21 
			Set MateriaCost=objFee.Fee27+objFee.Fee28+objFee.Fee29 
			Set DocID="",xObj="",DocDesc=""
			Set xStateID=$o(^DHCMA.CPW.SD.QCMrListStateI("IndexPState",xID,3,""),-1)
			Set:xStateID'="" xObj=##class(DHCMA.CPW.SD.QCMrListState).GetObjById(xID_"||"_xStateID)
			If $IsObject(xObj){
				Set DocID=xObj.StateDoc
				If (DocID'["!!"){
					Set objUser=##class(DHCMA.Util.EPx.SSUser).GetObjByOID(DocID_"!!1")
					Set:$IsObject(objUser) DocDesc=objUser.BTDesc
				}else{
					Set objCare=##class(DHCMA.Util.EPx.CareProv).GetObjByOID(DocID)
					Set:$IsObject(objCare) DocDesc=objCare.BTDesc
				}
			}
			If (DocDesc=""){
				Set objCare=##class(DHCMA.Util.EPx.CareProv).GetObjByOID(AdmDocID)
				Set:$IsObject(objCare) DocDesc=objCare.BTDesc	
			} 
			//取转归情况
			//治疗结果通过就诊号获取
			Set MRAdm=$p($g(^PAADM(+Paadm)),"^",61)
			Set DischCondID=$p($g(^MR(+MRAdm,"PRO",1)),"^",10)
			Set DischCondDesc=$p($g(^PAC("DISCON",+DischCondID)),"^",2)
			Set DishLocDesc=objPaadm.PAAdmLocDesc
			Set AdmLocID=objPaadm.PAAdmLocID
			Set OperComFlg=0
			//获取单病种表单填写的并发症信息
			Set OperCom=..getMrOperComInfo(xID)
			Set:OperCom'="" OperComFlg=1
			Set Data=$lb(xID,InLocDesc,DishLocDesc,QCEntityName,QCState,HospCost,DrugCost,MateriaCost,CNDrugCost,AdmDays,DischCondDesc,QCStateFlg,UpLastDays,DocDesc,AdmLocID,QCEntityID,OperComFlg)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1

		}
	}
	Quit $$$OK
}

ClassMethod QryStatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryStatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryStatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryStatExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// 单病种病例上报情况统计明细
/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.SDS.Stat.StatService","QryStatDetail","","2001-01-01","2021-05-01")
Query QryStatDetail(aHospID As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String, aQCEntityID As %String, aDocID As %String, aState As %String, aDateType As %String) As %Query(ROWSPEC = "xID:%String,Paadm:%String,MrNo:%String,PapmiNo:%String,PatName:%String,Sex:%String,Age:%String,AdmDate:%String,AdmTime:%String,DischDate:%String,DischTime:%String,InLocDesc:%String,DishLocDesc:%String,QCEntityName:%String,QCState:%String,HospCost:%String,DrugCost:%String,MateriaCost:%String,CNDrugCost:%String,AdmDays:%String,DischCondDesc:%String,QCStateFlg:%String,UpLastDays:%String,DocDesc:%String,Cost:%String,OperCom:%String") [ SqlProc ]
{
}

ClassMethod QryStatDetailExecute(ByRef qHandle As %Binary, aHospID As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String, aQCEntityID As %String, aDocID As %String, aState As %String, aDateType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Set ^zqqyew=$lb(aHospID,aDateFrom,aDateTo,aDateType)
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
 	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
 	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
 	Set:aDateFrom["/" aDateFrom=$zdh(aDateFrom,4)
 	Set:aDateTo["/" aDateTo=$zdh(aDateTo,4)
	Set Count=0
	Set DischDateIndex=##Class(DHCMA.Util.IO.FromHisSrv).GetDischDateIndex()  //update by pylian 2016-01-21取出院时间索引
   	Set:aDateType="2" DischDateIndex="PAADM_AdmDate"
    For xDate=aDateFrom:1:aDateTo {
		Set xPaadm=""
		For {
			Set xPaadm=$o(^PAADMi(DischDateIndex,xDate,xPaadm))
			Quit:xPaadm=""
			Set AdmInfo=$g(^PAADM(xPaadm))
			Continue:$p(AdmInfo,"^",2)'="I"           //就诊类型过滤
			Continue:$p(AdmInfo,"^",20)="C"           //就诊状态过滤
			Set EpisodeID=##class(DHCMA.Util.EPS.OIDService).GetValidOID(xPaadm)
			Set xID="",QCStateFlg=0,UpDate="",UpLastDays=""
			Set xID=$o(^DHCMA.CPW.SD.QCMrListI("IndexEpisodeID",EpisodeID,""),-1)
			Continue:xID=""
			Set obj=##class(DHCMA.CPW.SD.QCMrList).GetObjById(xID)
			Continue:'$IsObject(obj)
			Set QCState=obj.QCState
			Continue:QCState="O"
			/// 状态(I确认,O排除,Save保存/Submit 提交/Check 已审核/tUp 测试上报/Up 正式上报/Back 退回)
			Continue:((aState="1")&&(QCState'="Up"))
			Set QCState=$Select(QCState="Submit":"提交",QCState="Check":"审核",QCState="Up":"正式上报",QCState="tUp":"测试上报",QCState="Save":"保存",1:"")
			Set CurrStatusSubID=$o(^DHCMA.CPW.SD.QCMrListStateI("IndexParref",xID,""),-1)
			Set CurrStatusID=xID_"||"_CurrStatusSubID
			Set StatusObj=##class(DHCMA.CPW.SD.QCMrListState).GetObjById(CurrStatusID)	
			Set StateCode=QCState
			Set:$IsObject(StatusObj) StateCode=StatusObj.StateCode.BTCode
			Set QCStateFlg=$Select(StateCode="Submit":1,StateCode="Check":2,StateCode="Up":3,1:0)
			Set:QCStateFlg=3 UpDate=StatusObj.StateDate
			Set QCEntity=obj.QCEntityDr
			Continue:'$IsObject(QCEntity)
			Continue:(QCEntity.BTIsActive'=1)
			Set QCEntityID=QCEntity.%Id()
			Continue:(aQCEntityID'="")&&(aQCEntityID'=QCEntityID)
			Set QCEntityCode=QCEntity.BTCode
			Set QCEntityName=QCEntity.BTDesc
			Set EpisodeID=obj.QCEpisodeID
			Set InLocOID=obj.QCInLocID
			Set objInLoc=##class(DHCMA.Util.EP.Location).GetObjByOID(InLocOID)
			Set InLocDesc="",InLocID=""
			If ($IsObject(objInLoc)){
				Set InLocID=+InLocOID
				Set InLocDesc=objInLoc.BTDesc
				Set:InLocDesc["-" InLocDesc=$p(InLocDesc,"-",2)
			}
			
			Set xHospID=+$p($g(^CTLOC(($p(InLocID,"!!",1)))),"^",22)
 			Continue:(aHospID'="")&&(aHospID'[xHospID)
			Set (HospCost,DrugCost,MateriaCost,CNDrugCost,AdmDays)=0
			Set objPaadm=##class(DHCMA.Util.EPy.EpisodeSrv).GetSynObjByOID(EpisodeID)
			Continue:'$IsObject(objPaadm)
			Set AdmLoc=objPaadm.PAAdmLocID
			Set AdmDocID=objPaadm.PAAdmDocID
			//按当前科室过滤
			Continue:(aLocID'="")&&(aLocID'=AdmLoc)  
			Continue:(aDocID'="")&&(aDocID'=AdmDocID)
			Set AdmDays=objPaadm.PAAdmDays_"天"
			Set DishDate=objPaadm.PADischDate
			Set:DishDate="" DishDate=+$h
			Set PAAdmDate=objPaadm.PAAdmDate
			Set:PAAdmDate["-" PAAdmDate=$zdh(objPaadm.PAAdmDate,3)
			Set:AdmDays<0 AdmDays=+$h-PAAdmDate_"天"
			//Set:AdmDays<0 AdmDays=+$h-objPaadm.PAAdmDate
			Set:UpDate'="" UpLastDays=UpDate-DishDate
			Set:UpLastDays<0 UpLastDays=0
			Set Paadm=$P(EpisodeID,"!!",1)
			Set (DrugCost,HospCost,MateriaCost,CNDrugCost)=0
			Set Count=Count+1
			Set objFee=##class(DHCMA.CPW.SD.DataSrv.FeeInfoSrv).GetDataByAdm(Paadm)
			Continue:'$IsObject(objFee) 
			Set HospCost=objFee.Fee1
			Set DrugCost=objFee.Fee18
			Set CNDrugCost=objFee.Fee20+objFee.Fee21 
			Set MateriaCost=objFee.Fee27+objFee.Fee28+objFee.Fee29 
			Set DocID="",xObj="",DocDesc=""
			Set xStateID=$o(^DHCMA.CPW.SD.QCMrListStateI("IndexPState",xID,3,""),-1)
			Set:xStateID'="" xObj=##class(DHCMA.CPW.SD.QCMrListState).GetObjById(xID_"||"_xStateID)
			If $IsObject(xObj){
				Set DocID=xObj.StateDoc
				If (DocID'["!!"){
					Set objUser=##class(DHCMA.Util.EPx.SSUser).GetObjByOID(DocID_"!!1")
					Set:$IsObject(objUser) DocDesc=objUser.BTDesc
				}else{
					Set objCare=##class(DHCMA.Util.EPx.CareProv).GetObjByOID(DocID)
					Set DocDesc=objCare.BTDesc
				}
			}
			If (DocDesc=""){
				Set objCare=##class(DHCMA.Util.EPx.CareProv).GetObjByOID(AdmDocID)
				Set DocDesc=objCare.BTDesc	
			} 
			//取转归情况
			//治疗结果通过就诊号获取
			Set MRAdm=$p($g(^PAADM(+Paadm)),"^",61)
			Set DischCondID=$p($g(^MR(+MRAdm,"PRO",1)),"^",10)
			Set DischCondDesc=$p($g(^PAC("DISCON",+DischCondID)),"^",2)
			Set DishLocDesc=objPaadm.PAAdmLocDesc	
			Continue:((aState="2")&&(DischCondDesc'="死亡"))
			Set Paadm=$p(EpisodeID,"!!",1)		//就诊号
			Set MrNo=objPaadm.PAMrNo		//病案号
			Set PapmiNo=objPaadm.PAPapmiNo	// 登记号
			Set PatName=objPaadm.PAPatName	//姓名
			Set Sex=objPaadm.PASex			//性别（M男、F女、O其他）
			Set Sex=$Select(Sex="M":"男",Sex="F":"女",1:"其他")
			Set Age=objPaadm.PAAge			//年龄
			Set AdmDate=objPaadm.PAAdmDate	//入院日期
			Set AdmTime=objPaadm.PAAdmTime	//入院日期
			Set DischDate=objPaadm.PADischDate	//出院日期
			Set DischTime=objPaadm.PADischTime	//出院日期
			Set:DrugCost=0 DrugCost=1
			Set Cost=DrugCost+CNDrugCost
			//手术并发症
			Set OperCom=..getMrOperComInfo(xID)
			Continue:(aState="3")&&(OperCom="")
			Set Data=$lb(xID,Paadm,MrNo,PapmiNo,PatName,Sex,Age,AdmDate,AdmTime,DischDate,DischTime,InLocDesc,DishLocDesc,QCEntityName,QCState,HospCost,DrugCost,MateriaCost,CNDrugCost,AdmDays,DischCondDesc,QCStateFlg,UpLastDays,DocDesc,Cost,OperCom)	  										 		   						   //ID, 入组科室，出院科室  ，病种名     ,病种状态,费用   ,西药    ，耗材费    ，中药费   ，住院日，转归        ，表单状态 ，上报天数 ，医生
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1

		}
	}
	Quit $$$OK
}

ClassMethod QryStatDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryStatDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryStatDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryStatDetailExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// 统计(医生、上报ICD、年龄、治疗结果、离院方式、住院日统计、平均住院费用、住院药费)
/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.SDS.Stat.StatService","QryIndexMStat","2,3","","","","","","","4")
Query QryIndexMStat(aHospID As %String, aStaType As %String, ayear As %String = "", aQuarter As %String = "", aDateFrom As %String = "", aDateTo As %String = "", aLocID As %String = "", aQCEntityID As %String) As %Query(ROWSPEC = "DimenDesc:%String,LocDesc:%String,EntityDesc:%String,DocName:%String,Age:%Integer,InHosDays:%Integer,DischCondDesc:%String,OutHosWay:%String,ICDCode:%String,HosCost:%Float,DrugCost:%Float,MrID:%String,year:%String") [ SqlProc ]
{
}

ClassMethod QryIndexMStatExecute(ByRef qHandle As %Binary, aHospID As %String, aStaType As %String, ayear As %String = "", aQuarter As %String = "", aDateFrom As %String = "", aDateTo As %String = "", aLocID As %String = "", aQCEntityID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set ^tmpzgz123=$lb(aHospID,aStaType,ayear,aQuarter,aDateFrom,aDateTo,aLocID,aQCEntityID)
	//获取统计类别和开始结束日期
	Set Params=..GetStatParams(aStaType,ayear,aQuarter,aDateFrom,aDateTo)
	Set DimenMark	= $p(Params,"^",1)
	Set aDateFrom	= $p(Params,"^",2)
	Set aDateTo		= $p(Params,"^",3)
	Set ArrayStatDimens=..GetArrayStatDimens(DimenMark,aDateFrom,aDateTo)
	Quit:(aDateFrom="")||(aDateTo="")||(aQCEntityID="") $$$OK
 	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
 	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
 	Set:aDateFrom["/" aDateFrom=$zdh(aDateFrom,4)
 	Set:aDateTo["/" aDateTo=$zdh(aDateTo,4)
 	Set xCount=1
 	Set DischDateIndex=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateIndex()
	//获取各个项目值
	For xDate=aDateFrom:1:aDateTo{
		Set xPaadm=""
		For{
			Set xPaadm=$o(^PAADMi(DischDateIndex,xDate,xPaadm))
			Quit:xPaadm=""
			Set AdmInfo=$g(^PAADM(xPaadm))
			Continue:$p(AdmInfo,"^",2)'="I"           //就诊类型过滤
			Continue:$p(AdmInfo,"^",20)="C"           //就诊状态过滤
			//过滤掉已经进入单病种的病例
			Set EpisodeID=##class(DHCMA.Util.EPS.OIDService).GetValidOID(xPaadm)
			Set xID=""
			For{
				Set xID=$o(^DHCMA.CPW.SD.QCMrListI("IndexEpisodeID",EpisodeID,xID))
				Quit:xID=""
				Set obj=##class(DHCMA.CPW.SD.QCMrList).GetObjById(xID)
				Continue:'$IsObject(obj)
				Set QCState=obj.QCState
				Continue:QCState="O" //排除状态过滤 后期应该只统计审核以后的报告，报告医生默认是病人主管医师
				Set QCEntity=obj.QCEntityDr
				Continue:'$IsObject(QCEntity)
				Continue:(QCEntity.BTIsActive'=1)
				Set QCEntityID=QCEntity.%Id()
				Continue:(aQCEntityID'="")&&(aQCEntityID'=QCEntityID)
				Set QCEntityCode=QCEntity.BTCode
				Set QCEntityName=QCEntity.BTDesc
				Set EpisodeID=obj.QCEpisodeID
				Set InLocOID=obj.QCInLocID
				Set VerID=QCEntity.BTVersion.%Id()
				Set objInLoc=##class(DHCMA.Util.EP.Location).GetObjByOID(InLocOID)
				Set InLocDesc="",InLocID=""
				If ($IsObject(objInLoc)){
					Set InLocID=+InLocOID
					Set InLocDesc=objInLoc.BTDesc
				}
				Continue:(aLocID'="")&&(aLocID'=InLocID)
				Set xHospID=+$p($g(^CTLOC(($p(InLocID,"!!",1)))),"^",22)
		 		Continue:(aHospID'="")&&(aHospID'[xHospID)
				Set objPaadm=##class(DHCMA.Util.EP.Episode).GetObjByOID(EpisodeID)
				Continue:'$IsObject(objPaadm)
				Set Paadm=$P(EpisodeID,"!!",1)
				///医生、上报ICD、年龄、治疗结果、离院方式、住院日统计、平均住院费用、住院药费
				Set Age=objPaadm.PAAge
				Set Age=+$p(Age,"岁",1)
				Set InHosDays=objPaadm.PAAdmDays
				Set:InHosDays<0 InHosDays=+$h-objPaadm.PAAdmDate
				//治疗结果通过就诊号获取
				Set MRAdm=##class(web.DHCCPW.MR.PAADMSrv).GetMRAdm(Paadm)
				Set DischCondID=$p($g(^MR(+MRAdm,"PRO",1)),"^",10)
				Set DischCondDesc=$p($g(^PAC("DISCON",+DischCondID)),"^",2)
				Set:(DischCondDesc["稳定")||(DischCondDesc["恶化") DischCondDesc="未愈"
				Set:DischCondDesc["治愈" DischCondDesc="治愈"
				Set:DischCondDesc["好转" DischCondDesc="好转"
				Set:DischCondDesc["已故" DischCondDesc="死亡"
				Set:DischCondDesc["死亡" DischCondDesc="死亡"
				Set OutHosWay=""
				Set xItemCode="",ICDCode="未填报",HosCost=0,DrugCost=0 //上报ICD、平均住院费用、住院药费
				For
			 	{	
		 			Set xItemCode=$o(^DHCMA.CPW.SD.QCEntityItemI("IdxOfQCVerCode",aQCEntityID,VerID,xItemCode))
		 			Quit:xItemCode=""
		 			Set ObjEntityItem = ##class(DHCMA.CPW.SD.QCEntityItem).GetObjByVerCode(VerID,aQCEntityID,$tr(xItemCode," ",""))
					Set xRowID=ObjEntityItem.%Id()
			 		//ICD编码、离院方式、住院费用、药费
			 		Set ESubID=$o(^DHCMA.CPW.SD.QCMrListI("Exec","IndexParrefItemDr",xID,xRowID,""),-1)
					Set ItemExecObj=##class(DHCMA.CPW.SD.QCItemExec).GetObjById(xID_"||"_ESubID)
					Continue:'$IsObject(ItemExecObj)
					Set ExecResultText=""
			 		if (ObjEntityItem.BTDesc["ICD-10") {
			 		 	Set ExecResult=ItemExecObj.ExecResult
		 		 		Set DicItemObj=##class(DHCMA.CPW.SDS.DictionarySrv).GetObjByPCodeItemCode(aQCEntityID,VerID,ObjEntityItem.BTCode,ExecResult)
				 		Set:$IsObject(DicItemObj) ExecResultText=DicItemObj.BTDesc
				 		Set len=$l(ExecResultText)
				 		For index=1:1:len{
					 		Set xICDCode=$e(ExecResultText,index)
					 		if ($ASCII(xICDCode)>122){
						 		Set ICDCode=$e(ExecResultText,1,index-1)	//取ICD
						 		//Set ICDCode=$e(ExecResultText,index,len)	//取描述
						 		Quit
						 	}
					 	}
			 		 	//Set ICDCode=$p(ExecResultText," ",1)
			 		}
			 		Set OutHosWay="其他方式离院"
			 		if (ObjEntityItem.BTDesc["离院方式") {
			 		 	Set ExecResult=ItemExecObj.ExecResult
		 		 		Set DicItemObj=##class(DHCMA.CPW.SDS.DictionarySrv).GetObjByPCodeItemCode(aQCEntityID,VerID,ObjEntityItem.BTCode,ExecResult)
				 		Set:$IsObject(DicItemObj) ExecResultText=DicItemObj.BTDesc
			 		 	Set OutHosWay=ExecResultText
			 		}
					Set:ObjEntityItem.BTDesc["住院总费用" HosCost=ItemExecObj.ExecResult
					Set:ObjEntityItem.BTDesc["西药费" DrugCost=ItemExecObj.ExecResult
					Set:ObjEntityItem.BTDesc["质控医师" DocName=ItemExecObj.ExecResult
			 	}
			 	
			 	//Continue:ICDCode="未填报"
			 	
			 	Set DimenDesc=..GetDimenDesc(xDate,DimenMark)
			 	Set:DimenDesc="" DimenDesc=InLocDesc
			 	//如果统计维护不是标准年季度，则按照实际科室输出（暂不考虑全科室输出）
			 	if (ArrayStatDimens.Find(DimenDesc)="") {
				 		d ArrayStatDimens.SetAt(DimenDesc,xCount)
				 		Set xCount=xCount+1
				 	}
		 		Set ResultArr(DimenDesc,xID)=$lb(DimenDesc,InLocDesc,QCEntityName,DocName,Age,InHosDays,DischCondDesc,OutHosWay,ICDCode,HosCost,DrugCost,xID,year)
			}
		}
	}
	for xind=1:1:ArrayStatDimens.Count()
	{
		Set xDimenDesc=ArrayStatDimens.GetAt(xind)
		Set xID=""
		if '$d(ResultArr(xDimenDesc)) {
				Set ^CacheTemp(repid,ind)=$lb(xDimenDesc)
				Set ind=ind+1
		}else{
			for {
					Set xID=$o(ResultArr(xDimenDesc,xID))
					Quit:xID=""
					Set Data=$g(ResultArr(xDimenDesc,xID))
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
		}
	}
	k ResultArr
	Quit $$$OK
}

ClassMethod QryIndexMStatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryIndexMStatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryIndexMStatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryIndexMStatExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// 获取标准入参
ClassMethod GetStatParams(aStaType As %String, ayear As %String = "", aQuarter As %String = "", aDateFrom As %String = "", aDateTo As %String = "") As %String
{
	new (aStaType,ayear,aQuarter,aDateFrom,aDateTo)
	//aStaType=1 按年季度
	//aStaType=2 按入单日期
	Set DimenMark=""
	//默认按年季度统计
	Set:aStaType="" aStaType=1
	if (aStaType=1) {
		Set CurYear=$p($zd(+$h,3),"-",1)
		if (ayear="") {
			Set DimenMark="Year"
			//默认统计近五年的上报情况，可以考虑使用配置
			Set aStartYear=CurYear-4
			Set aDateFrom=aStartYear_"-01-01"
			Set aDateFrom=$zdh(aDateFrom,3)
			Set aDateTo=+$h
		}elseif(aQuarter=""){
			//按季度，统计当前年份所有季度
			Set DimenMark="Quarter"
			Set aDateFrom=ayear_"-01-01"
			Set aDateFrom=$zdh(aDateFrom,3)
			Set aDateTo=ayear_"-12-31"
			Set aDateTo=$zdh(aDateTo,3)
		}elseif(aQuarter'=""){
			//按月份，统计当前季度所有月份
			Set DimenMark="Month"
			If (aQuarter=1){
				Set aDateFrom=ayear_"-01-01"
				Set aDateTo=ayear_"-03-31"
			}elseif(aQuarter=2){
				Set aDateFrom=ayear_"-04-01"
				Set aDateTo=ayear_"-06-30"
			}elseif(aQuarter=3){
				Set aDateFrom=ayear_"-07-01"
				Set aDateTo=ayear_"-09-30"
			}elseif(aQuarter=4){
				Set aDateFrom=ayear_"-10-01"
				Set aDateTo=ayear_"-12-31"
			}
		}else{
			Set DimenMark="Year"
			Set aStartYear=CurYear-4
			Set aDateFrom=aStartYear_"-01-01"
			Set aDateFrom=$zdh(aDateFrom,3)
			Set aDateTo=+$h
		}
	}else{
		Set DimenMark="Loc"
	}
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
 	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
 	Set:aDateFrom["/" aDateFrom=$zdh(aDateFrom,4)
 	Set:aDateTo["/" aDateTo=$zdh(aDateTo,4)
	Quit DimenMark_"^"_aDateFrom_"^"_aDateTo
}

/// 获取输出维度
ClassMethod GetArrayStatDimens(aDimenMark As %String, aDateFrom As %String, aDateTo As %String) As %Library.ArrayOfDataTypes
{
	New (aDateFrom,aDateTo,aDimenMark)
	Set return=##Class(%Library.ArrayOfDataTypes).%New()
	Quit:(aDateFrom="")||(aDateTo="")||(aDimenMark="") return
	Set Count=0
	if (aDimenMark="Year") {
		Set SYear=$p($zd(aDateFrom,3),"-",1)
		Set EYear=$p($zd(aDateTo,3),"-",1)
		For xYear=SYear:1:EYear {
				Set Count=Count+1
				Set YearStr=xYear_"年"
				Do return.SetAt(YearStr,Count)
			}
	}elseif (aDimenMark="Quarter") {
		Set Year=$p($zd(aDateFrom,3),"-",1)
		For xQuarter=1:1:4 {
				Set Count=Count+1
				Set Quarter		= $Case(xQuarter,1:"一",2:"二",3:"三",4:"四")
				Set QuarterStr	= Year_"年"_Quarter_"季度"
				Do return.SetAt(QuarterStr,Count)
			}
	}elseif (aDimenMark="Month") {
		Set SMonth=+$p($zd(aDateFrom,3),"-",2)
		Set EMonth=+$p($zd(aDateTo,3),"-",2)
		For xMonth=SMonth:1:EMonth {
				Set Count=Count+1
				Set MonthStr=xMonth_"月"
				Do return.SetAt(MonthStr,Count)
			}
	}
	Quit return
}

/// 获取当前统计维护
ClassMethod GetDimenDesc(aDate As %String, aDimenMark As %String) As %String
{
	new (aDate,aDimenMark)
	Quit:(aDate="")||(aDimenMark="") ""
	Set year=$p($zd(aDate,3),"-",1)
 	Set Month=+$p($zd(aDate,3),"-",2)
 	Set Quarter=$Select(Month<4:year_"年一季度",Month<7:year_"年二季度",Month<10:year_"年三季度",1:year_"年四季度")
 	Set DimenDesc=$Case(aDimenMark,"Year":year_"年","Quarter":Quarter,"Month":Month_"月","Loc":"")	
	Quit DimenDesc
}

/// 获取默认统计年份
/// w ##class(DHCMA.CPW.SDS.Stat.StatService).GetDefaultYears()
ClassMethod GetDefaultYears() As %String
{
	Set Json="{id:"""",text:""-"_"年份"_"-""}"
	//默认显示年份 5年
	Set YearLen=5
	Set CurYear=$p($zd(+$h,3),"-",1)
	for xInd=CurYear:-1:(CurYear-YearLen+1) {
		Set Json=Json_","
		Set id=xInd
		Set text=xInd_"年"
		Set Json=Json_"{id:"""_id_""",text:"""_text_"""}"
	}
	Set Json="["_Json_"]"
	Quit Json
}

/// 单病种诊疗信息数据-心力衰竭HF
/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.SDS.Stat.StatService","QryQCHFAlias","2018-10-10","2020-05-10")
Query QryQCHFAlias(aDateFrom As %String, aDateTo As %String, aHospID As %String = "", aLocID As %String = "") As %Query(ROWSPEC = "MrNo:%String,PatName:%String,InHosDays:%String,ICDDesc:%String,HospCost:%String,DrugFee:%String,AntiFee:%String,CheckFee:%String,MaterialFee:%String,DischCondDesc:%String,HF13Timing:%String,HF13Level:%String,HF33Timing:%String,HF42Timing:%String,HF72Flg:%String,HF73Flg:%String,HF923Level:%String,HF8Flg:%String,HF10Flg:%String") [ SqlProc ]
{
}

ClassMethod QryQCHFAliasExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aHospID As %String = "", aLocID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Set DischDateIndex=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateIndex()  //update by pylian 2016-01-21取出院时间索引
	For xDate=aDateFrom:1:aDateTo {
		/*按出院日期
		Set xPaadm=""
		For {
			Set xPaadm=$o(^PAADMi(DischDateIndex,xDate,xPaadm))
			Quit:xPaadm=""
			Set EpisodeID	= ##class(DHCMA.Util.EPS.OIDService).GetValidOID(xPaadm)
			Continue:'$d(^DHCMA.CPW.SD.QCMrListI("IndexEpisodeID",EpisodeID))
			Set MrlistID	= $o(^DHCMA.CPW.SD.QCMrListI("IndexEpisodeID",EpisodeID,""),-1)
			Continue:MrlistID=""
		*End/
		/*按入组日期*/
		Set MrlistID=""
		For {
			Set MrlistID = $o(^DHCMA.CPW.SD.QCMrListI("IndexInDate",xDate,MrlistID))
			Quit:MrlistID=""
		/*End*/
			Set MrListObj	=##class(DHCMA.CPW.SD.QCMrList).GetObjById(MrlistID)
			Continue:MrListObj.QCState="O"
			Continue:MrListObj.QCEntityDr.BTAbbrev'="HF"
			//默认取值版本
			Set QCID=MrListObj.QCEntityDr.%Id()
			Set VerID=MrListObj.QCEntityDr.BTVersion.%Id()
			/*到达医院后首次心功能评价的时间与结果 HF-1-3-2/HF-1-3-3
			出院前心功能评价的结果 HF-9-2-3-2/HF-9-2-3-3
			到达医院后使用ACEI或ARB的时间（有适应症，无禁忌症者） HF-3-3
			到达医院后使用β受体阻滞剂的时间（有适应症，无禁忌症者） HF-4-2
			出院时继续使用β受体阻滞剂(HF-7-3-1)
			出院时继续使用ACEI或ARB的时间（有适应症，无禁忌症者）(HF-7-2-1)
			到院日期时间  HF-0-2-3
			患者服务和满意度取第一项为参考
			患者服务 HF-8-1-1 满意度 HF-10-1
			
			*/
			//将所有涉及的单元格统一赋值
			Set DataList=$lb("HF-8-1-1","HF-10-1","HF-1-3-2","HF-1-3-3","HF-9-2-3-2","HF-9-2-3-3","HF-3-3","HF-4-2","HF-7-3-1","HF-7-2-1")		
			For xind=1:1:$ll(DataList) {
				Set xItemCode=$li(DataList,xind) 
				Set xEntityItem = ##class(DHCMA.CPW.SD.QCEntityItem).GetObjByVerCode(VerID,QCID,xItemCode)
				Set xItemID=xEntityItem.%Id()
				Set xItemValue=..GetItemValue(MrlistID,xItemID)
				Set xVal=$tr(xItemCode,"-","")
				Set Exp="Set "_xVal_"="""_xItemValue_""""
				x Exp
			}
			Set (HF13Timing,HF13Level,HF33Timing,HF42Timing,HF923Level)=""
			Set (HF72Flg,HF73Flg,HF8Flg,HF10Flg)=0
			//由于等级评定的时候没有填写日期时间 HF13Timing评估时机默认小于24小时。
			Set:HF132'="" HF13Timing=1,HF13Level=$s(HF132["Ⅰ":1,HF132["Ⅱ":2,HF132["Ⅲ":3,HF132["Ⅳ":4,1:"")
			Set:HF133'="" HF13Timing=1,HF13Level=$s(HF133["Ⅰ":1,HF133["Ⅱ":2,HF133["Ⅲ":3,HF133["Ⅳ":4,1:"")
			//日期大小比较，合格1，不合格0,三个参数  A-B<=C  返回1
			Set:HF33'="" HF33Timing=..CompareTime(HF33,HF023,24*3600)
			Set:HF42'="" HF42Timing=..CompareTime(HF42,HF023,24*3600)
			Set:HF721'="" HF72Flg=1
			Set:HF731'="" HF73Flg=1
			Set:HF9232'="" HF923Level=$s(HF9232["Ⅰ":1,HF9232["Ⅱ":2,HF9232["Ⅲ":3,HF9232["Ⅳ":4,1:"")
			Set:HF9233'="" HF923Level=$s(HF9233["Ⅰ":1,HF9233["Ⅱ":2,HF9233["Ⅲ":3,HF9233["Ⅳ":4,1:"")
			Set:HF811'="" HF8Flg=1
			Set:(HF101'="")&&((HF101["很满意")||(HF101["较满意")) HF10Flg=1
			//通过公用方法获取病人基本信息
			Set PaadmData=..GetBaseInfo(MrlistID)
			Set Data=PaadmData_$lb(HF13Timing,HF13Level,HF33Timing,HF42Timing,HF72Flg,HF73Flg,HF923Level)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryQCHFAliasClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryQCHFAliasExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryQCHFAliasFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryQCHFAliasExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// 单病种诊疗信息数据-髋膝关节置换术Hip、Knee
/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.SDS.Stat.StatService","QryQCHipKneeAlias","2018-10-10","2020-05-10","","","Knee")
Query QryQCHipKneeAlias(aDateFrom As %String, aDateTo As %String, aHospID As %String = "", aLocID As %String = "", aAbbrev As %String = "Hip|Knee") As %Query(ROWSPEC = "MrNo:%String,PatName:%String,InHosDays:%String,ICDDesc:%String,HospCost:%String,DrugFee:%String,AntiFee:%String,CheckFee:%String,MaterialFee:%String,DischCondDesc:%String,HK122Score:%String,HKAntiCat:%String,HKOper3Hour:%String,HKVTE12:%String,HKVTE24:%String,HKInOperBlood:%String,HK51Flg:%String,HK92Flg:%String,HK72Desc:%String,HK81Flg:%String,HK111Flg:%String") [ SqlProc ]
{
}

ClassMethod QryQCHipKneeAliasExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aHospID As %String = "", aLocID As %String = "", aAbbrev As %String = "Hip|Knee") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Set DischDateIndex=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateIndex()  //update by pylian 2016-01-21取出院时间索引
	For xDate=aDateFrom:1:aDateTo {
		/*按出院日期
		Set xPaadm=""
		For {
			Set xPaadm=$o(^PAADMi(DischDateIndex,xDate,xPaadm))
			Quit:xPaadm=""
			Set EpisodeID	= ##class(DHCMA.Util.EPS.OIDService).GetValidOID(xPaadm)
			Continue:'$d(^DHCMA.CPW.SD.QCMrListI("IndexEpisodeID",EpisodeID))
			Set MrlistID	= $o(^DHCMA.CPW.SD.QCMrListI("IndexEpisodeID",EpisodeID,""),-1)
			Continue:MrlistID=""
		*End/
		/*按入组日期*/
		Set MrlistID=""
		For {
			Set MrlistID = $o(^DHCMA.CPW.SD.QCMrListI("IndexInDate",xDate,MrlistID))
			Quit:MrlistID=""
		/*End*/
			Set MrListObj	=##class(DHCMA.CPW.SD.QCMrList).GetObjById(MrlistID)
			Continue:MrListObj.QCState="O"
			Set Abbrev=MrListObj.QCEntityDr.BTAbbrev
			Continue:aAbbrev'[Abbrev
			//默认取值版本
			Set QCID=MrListObj.QCEntityDr.%Id()
			Set VerID=MrListObj.QCEntityDr.BTVersion.%Id()
			/*
			关节功能评估结果 Hip-1-2-2-2/Hip-1-2-2-1
			预防性抗菌药物选择 Hip-2-2
			手术时间是否超过3小时 Hip-0-2-5-1减Hip-0-2-4-1
			实施预防性手术后深静脉血栓与肺栓塞的时间（术后12小时） Hip-3-3-1  Hip-0-2-5-1
			术中输血量 Hip-4-2-2-1/Hip-4-2-3-1
			术后康复治疗的时间（术后6小时） Hip-5-1 y
			切口愈合 Hip-9-2
			术后并发症  Hip-7-2
			健康教育和满意度取第一项为参考
			健康教育 Hip-8-1
			患者对服务满意度 Hip-11-1
			*/
			//将所有涉及的单元格统一赋值
			Set DataList=$lb(
			"Hip-1-2-2-2","Hip-1-2-2-1","Hip-2-2","Hip-0-2-5-1","Hip-0-2-4-1",
			"Hip-3-3-1","Hip-4-2-2-1","Hip-4-2-3-1","Hip-5-1","Hip-9-2","Hip-7-2","Hip-8-1",
			"Hip-11-1")		
			For xind=1:1:$ll(DataList) {
				Set xItemCode=$li(DataList,xind) 
				Set:Abbrev="Knee" xItemCode=$Replace(xItemCode,"Hip","Knee")
				//由于极个别编码的无规律性，这里做特殊处理
				Set:xItemCode="Knee-0-2-4-1" xItemCode="Knee-0-2-4-2"
				//特殊处理End
				Set xEntityItem = ##class(DHCMA.CPW.SD.QCEntityItem).GetObjByVerCode(VerID,QCID,xItemCode)
				Continue:'$IsObject(xEntityItem)
				Set xItemID=xEntityItem.%Id()
				Set xItemValue=..GetItemValue(MrlistID,xItemID)
				Set xVal=$tr(xItemCode,"-","")
				//Hip和Knee公用变量 取两个简称的首字母 HK
				Set xVal=$Replace(xVal,"Hip","HK")
				Set xVal=$Replace(xVal,"Knee","HK")
				Set Exp="Set "_xVal_"="""_xItemValue_""""
				x Exp
			}
			Set (HK122Score,HKAntiCat,HKOper3Hour,HKVTE12,HKVTE24,HKInOperBlood)=""
			Set (HK51Flg,HK92Flg,HK72Desc,HK81Flg,HK111Flg)=0
			//关节功能评估结果。
			Set:HK1222'="" HK122Score=HK1222
			Set:HK1221'="" HK122Score=HK1221
			//预防性抗菌药物选择
			Set:HK22'="" HKAntiCat=HK22
			Set HKAntiCatCode=$p(HKAntiCat,$c(1),1)
			//根据字典顺序确定级别，其他填写的内容无法识别，作空处理。
			Set:(HKAntiCatCode'="")&($ASCII(HKAntiCatCode)<$ASCII("g")) HKAntiCat=1
			Set:(HKAntiCatCode'="")&(HKAntiCatCode="g") HKAntiCat=3
			//手术时间 Hip-0-2-5-1减Hip-0-2-4-1 大于3小时返回1
			If ((HK0251'="")&&(HK0241'="")) {
				 Set HourFlg=..CompareTime(HK0251,HK0241,3*3600)
				 Set HKOper3Hour=0
				 Set:HourFlg=0 HKOper3Hour=1
			}
			//实施预防性手术后深静脉血栓与肺栓塞的时间（术后12小时）
			If ((HK331'="")&&(HK0251'="")) {
				 Set HKVTE12=0,HKVTE24=1
				 Set Hour12Flg=..CompareTime(HK331,HK0251,24*3600)
				 Set:Hour12Flg=1 HKVTE12=1,HKVTE24=0
			}
			If ((HK4221'="")||(HK4231'="")) {
				 Set HKInOperBlood=HK4221
				 Set:HK4231'="" HKInOperBlood=HK4231						//术中输血量
			}
			Set:HK51["y" HK51Flg=1											//术后康复治疗	
			Set:HK92'="" HK92Flg=$p(HK92,$c(1),2)							//切口愈合
			Set:HK92Flg'="" HK92Flg=$s(HK92Flg["甲":"甲",HK92Flg["乙":"乙",1:"丙")
			Set:HK72'="" HK72Desc=$p(HK72,$c(1),2)							//术后并发症 
			Set:HK72Desc'="" HK72Desc=$p(HK72Desc,"(",1)
			Set:HK81'="" HK81Flg=1											//健康教育
			Set:(HK111'="")&&((HK111["很满意")||(HK111["较满意")) HK111Flg=1 //患者对服务满意度 
	
			//通过公用方法获取病人基本信息
			Set PaadmData=..GetBaseInfo(MrlistID)
			Set Data=PaadmData_$lb(HK122Score,HKAntiCat,HKOper3Hour,HKVTE12,HKVTE24,HKInOperBlood,HK51Flg,HK92Flg,HK72Desc,HK81Flg,HK111Flg)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryQCHipKneeAliasClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryQCHipKneeAliasExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryQCHipKneeAliasFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryQCHipKneeAliasExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// 单病种诊疗信息数据-急性心肌梗死STEMI
/// zhangdc
/// 2020-04-17
/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.SDS.Stat.StatService","QrySTEMI","","2021-09-07","2021-09-30","")
Query QrySTEMI(aHospID As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String) As %Query(ROWSPEC = "MrNo:%String,PatName:%String,InHosDays:%String,ICDDesc:%String,HospCost:%String,DrugFee:%String,AntiFee:%String,CheckFee:%String,MaterialFee:%String,DischCondDesc:%String,ASPLCode:%String,KIPP24h:%String,KIPPLevel:%String,Throm30m:%String,ThromMin:%String,PCI90m:%String,PCIMin:%String,NoReperfusion:%String,BTimeCode:%String,InDrugCode:%String,IfStatins:%String,OutDrugCode:%String,IfComp:%String,IfHealth:%String,IfPleased:%String") [ SqlProc ]
{
}

ClassMethod QrySTEMIExecute(ByRef qHandle As %Binary, aHospID As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set ^tmpzdc=$lb(aHospID,aDateFrom,aDateTo,aLocID)
	Set aDateFrom=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	For xDate=aDateFrom:1:aDateTo {
		/*按入组日期*/
		Set MrlistID=""
		For {
			Set MrlistID = $o(^DHCMA.CPW.SD.QCMrListI("IndexInDate",xDate,MrlistID))
			Quit:MrlistID=""
			Set MrListObj	=##class(DHCMA.CPW.SD.QCMrList).GetObjById(MrlistID)
			Continue:MrListObj.QCState="O"
			Continue:(MrListObj.QCState'["Up")&&(MrListObj.QCState'="Submit")
			Continue:MrListObj.QCEntityDr.BTAbbrev'="STEMI"
			//默认取值版本
			Set QCID=MrListObj.QCEntityDr.%Id()
			Set VerID=MrListObj.QCEntityDr.BTVersion.%Id()
			/*
			入院日期时间 CM-0-2-4-1
			到达本院急诊或者门诊日期时间  CM-0-2-3-2
			到达医院使用阿司匹林(有禁忌证者应给予氯吡格雷) 的时间 STEMI-1-2-4-1
			到达医院后首次心功能评价时间 STEMI-2-2-2-1
			Killip分级 STEMI-1-1-7
			出院前心功能评价结果 暂无
			实施再灌注治疗:STEMI-3-0-2 
				溶栓开始时间 STEMI-3-1-5-1 
				PCI导丝通过梗死相关动脉日期时间 STEMI-3-2-2-2-1 
			使用β受体阻滞剂（有适应症、无禁忌症）的时间 STEMI-4-3-1

			住院期间使用阿司匹林、氯吡格雷、β受体阻滞剂、ACEI或ARB（有适应症、无禁忌症）STEMI-5-1-1/STEMI-5-2-1/STEMI-5-3-3
			血脂评价管理（他汀类药物使用）  STEMI-5-4-3
			出院继续使用阿司匹林、氯吡格雷、β受体阻滞剂、ACEI或ARB（有适应症、无禁忌症）STEMI-6-1/STEMI-6-2/STEMI-6-3
			并发症	STEMI-3-2-5-1
			健康教育	STEMI-8-5-1-1
			患者对服务满意度-整体评价	CM-5-2-1
			
			*/
			//将所有涉及的单元格统一赋值
			Set DataList=$lb("CM-0-2-4-1","CM-0-2-3-2","STEMI-1-2-4-1","STEMI-2-2-2-1","STEMI-1-1-7","STEMI-3-0-2","STEMI-3-1-5-1","STEMI-3-2-2-2-1","STEMI-4-3-1","STEMI-5-1-1","STEMI-5-2-1","STEMI-5-3-3","STEMI-5-2-1","STEMI-5-3-3","STEMI-6-1","STEMI-6-2","STEMI-6-3","STEMI-3-2-5-1","STEMI-8-5-1-1","CM-5-2-1","STEMI-5-4-3","STEMI-8-5-2-1")		
			For xind=1:1:$ll(DataList) {
				Set xItemCode=$li(DataList,xind) 
				Set xEntityItem = ##class(DHCMA.CPW.SD.QCEntityItem).GetObjByVerCode(VerID,QCID,xItemCode)
				If ($IsObject(xEntityItem)) {
					Set xItemID=xEntityItem.%Id()
					Set xItemValue=..GetItemValue(MrlistID,xItemID)
				}else{
					Set xItemValue=""
				}
				Set xVal=$tr(xItemCode,"-","")
				Set Exp="Set "_xVal_"="""_xItemValue_""""
				x Exp
			}
			Set (ASPLCode,KIPP24h,KIPPLevel,Throm30m,PCI90m,NoReperfusion,BTimeCode,InDrugCode,IfStatins,OutDrugCode,IfComp,IfHealth,IfPleased)=""
			//ASPLCode 未使用 ≤10分钟 ≤24小时 >24小时 
			//BTimeCode 未使用 ≤24小时 >24小时 
			//KIPP24h  <24h
			//InDrugCode 阿司匹林 氯吡格雷 β受体阻滞剂 ACEI或ARB
			//OutDrugCode 阿司匹林 氯吡格雷 β受体阻滞剂 ACEI或ARB
			Set ASPLCode=0
			If (STEMI1241'="") {
				If (..CompareTime(STEMI1241,CM0241,10*60)) {
					Set ASPLCode=1	
				}elseIf (..CompareTime(STEMI1241,CM0241,24*3600)){
					Set ASPLCode=2
				}else {
					Set ASPLCode=3
				}
			}
			Set KIPP24h=0
			If (STEMI2221'="") {
				Set KIPP24h=..CompareTime(STEMI2221,CM0241,24*3600)
				
			}
			Set KIPPLevel=$p($p(STEMI117,$c(1),2),"，",1)
			
			Set (Throm30m,PCI90m)=0
			Set (ThromMin,PCIMin)=""
			If (STEMI3151'="") { 
				Set Throm30m=..CompareTime(STEMI3151,CM0232,30*60)
				Set ThromMin=..CalcTime(STEMI3151,CM0232)
			}
			If (STEMI32221'="") { 
				Set PCI90m=..CompareTime(STEMI32221,CM0232,90*60)
				Set PCIMin=..CalcTime(STEMI32221,CM0232)
			}
			Set:(STEMI3151="")&&(STEMI32221="") NoReperfusion=1
			
			//BTimeCode 未使用  ≤24小时 >24小时 
			Set BTimeCode=0
			If (STEMI431'="") {
				If (..CompareTime(STEMI431,CM0241,24*3600)) {
					Set BTimeCode=1	
				}else{
					Set BTimeCode=2
				}
			}
			//InDrugCode 阿司匹林/氯吡格雷 β受体阻滞剂 ACEI或ARB
			Set:STEMI511["是" InDrugCode=InDrugCode_"1"
			Set:STEMI521["是" InDrugCode=InDrugCode_"2"
			Set:STEMI533["是" InDrugCode=InDrugCode_"3"
			
			//OutDrugCode 阿司匹林 氯吡格雷 β受体阻滞剂 ACEI或ARB
			Set:STEMI61["是" OutDrugCode=OutDrugCode_"1"
			Set:STEMI62["是" OutDrugCode=OutDrugCode_"2"
			Set:STEMI63["是" OutDrugCode=OutDrugCode_"3"
			
			Set:STEMI543["是" IfStatins=1
			Set:(STEMI3251'="")&&(STEMI3251'["UTD") IfComp=STEMI3251
			Set:(STEMI8511["是")||(STEMI8521["是") IfHealth=1
			Set:(CM521["10分") IfPleased=1
			
			//通过公用方法获取病人基本信息
			Set PaadmData=..GetBaseInfo(MrlistID)
			Set Data=PaadmData_$lb(ASPLCode,KIPP24h,KIPPLevel,Throm30m,ThromMin,PCI90m,PCIMin,NoReperfusion,BTimeCode,InDrugCode,IfStatins,OutDrugCode,IfComp,IfHealth,IfPleased)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QrySTEMIClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySTEMIExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QrySTEMIFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySTEMIExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// 单病种诊疗信息数据-脑梗死STK
/// zhangdc
/// 2020-04-28
/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.SDS.Stat.StatService","QrySTK","","2020-04-28","2020-04-28","")
Query QrySTK(aHospID As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String) As %Query(ROWSPEC = "MrNo:%String,PatName:%String,InHosDays:%String,ICDDesc:%String,HospCost:%String,DrugFee:%String,AntiFee:%String,CheckFee:%String,MaterialFee:%String,DischCondDesc:%String,STK12L15M:%String,STK12L60M:%String,STK13L60M:%String,STK14L60M:%String,STK15L60M:%String,STK24L270M:%String,STK24L360M:%String,NotSTK24:%String,STK42L48H:%String,STK62L24H:%String,STK52:%String,STK10L1W:%String,STK10M1W:%String,STK72L48H:%String,STK134:%String,STK81ASPL:%String,STK81ZLGL:%String,STK33HFL:%String,STK933JY:%String,STK146Flg:%String") [ SqlProc ]
{
}

ClassMethod QrySTKExecute(ByRef qHandle As %Binary, aHospID As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	For xDate=aDateFrom:1:aDateTo {
		/*按入组日期*/
		Set MrlistID=""
		For {
			Set MrlistID = $o(^DHCMA.CPW.SD.QCMrListI("IndexInDate",xDate,MrlistID))
			Quit:MrlistID=""
			Set MrListObj	=##class(DHCMA.CPW.SD.QCMrList).GetObjById(MrlistID)
			Continue:MrListObj.QCState="O"
			Continue:MrListObj.QCEntityDr.BTAbbrev'="STK"
			//默认取值版本
			Set QCID=MrListObj.QCEntityDr.%Id()
			Set VerID=MrListObj.QCEntityDr.BTVersion.%Id()
			/*
			到院日期时间  STK-0-2-3
			神经功能缺损评估 STK-1-1-1/STK-1-2-1-2/STK-1-2-2-2
			完成头颅CT/MRI STK-1-3-3
			实验室检查 STK-1-4-3-2
			心电图、胸片等检查: STK-1-5-2
			到院实施静脉应用组织纤溶酶原激活剂或尿激酶应用的评估的时间（发病4.5/6小时内患者） STK-2-4-1-1/STK-2-4-2-1
			到院使用首剂阿司匹林或氯吡格雷的时间	STK-4-2-2
			吞咽困难评价时间  STK-6-2-1
			血脂评价（使用他汀类药物）STK-5-2
			接受血管功能评价的时间	STK-10-1
			预防深静脉血栓的时间	STK-7-2-3-1
			康复评价与实施的时间（出院前）	STK-13-4
			出院时继续使用阿司匹林或氯吡格雷	STK-8-1
			伴房颤脑梗死患者口服抗凝剂的治疗华法林	STK-3-3-3
			并发症	暂无
			戒烟咨询/脑梗死健康教育	STK-9-3-3
			患者对服务满意度	STK-14-6
			
			*/
			//将所有涉及的单元格统一赋值
			Set DataList=$lb("STK-0-2-3","STK-1-1-1","STK-1-2-1-2","STK-1-2-2-2","STK-1-3-3","STK-1-4-3-2","STK-1-5-2","STK-2-4-1-1","STK-2-4-2-1","STK-4-2-2","STK-6-2-1","STK-5-2","STK-10-1","STK-7-2-3-1","STK-8-1","STK-3-3-3","STK-9-3-3","STK-14-6")		
			For xind=1:1:$ll(DataList) {
				Set xItemCode=$li(DataList,xind) 
				Set xEntityItem = ##class(DHCMA.CPW.SD.QCEntityItem).GetObjByVerCode(VerID,QCID,xItemCode)
				Set xItemID=xEntityItem.%Id()
				Set xItemValue=..GetItemValue(MrlistID,xItemID)
				Set xVal=$tr(xItemCode,"-","")
				Set Exp="Set "_xVal_"="""_xItemValue_""""
				x Exp
			}
			Set (STK12L15M,STK12L60M,STK13L60M,STK14L60M,STK15L60M,STK24L270M,STK24L360M,NotSTK24,STK42L48H,STK62L24H,STK10L1W,STK10M1W,STK72L48H,STK81ASPL,STK81ZLGL,STK33HFL,STK933JY,STK146Flg)=""
			//日期大小比较，合格1，不合格0,三个参数  A-B<=C  返回1
			if (STK1212'=""){
				Set STK12L15M=..CompareTime(STK1212,STK111,15*60)
				Set STK12L60M=..CompareTime(STK1212,STK111,60*60)
			}elseif (STK1212="")&&(STK1222'=""){
				Set STK12L15M=..CompareTime(STK1222,STK111,15*60)
				Set STK12L60M=..CompareTime(STK1222,STK111,60*60)
			}
			
			Set:STK133'="" STK13L60M=..CompareTime(STK133,STK111,60*60)
			
			Set:STK1432'="" STK14L60M=..CompareTime(STK1432,STK111,60*60)
			
			Set:STK152'="" STK15L60M=..CompareTime(STK152,STK111,60*60)
			
			if (STK2411'="")&&(STK2421'=""){
				Set STK24L270M=..CompareTime(STK2421,STK2411,270*60)
			}
			if STK24L270M=0{
				Set STK24L360M=..CompareTime(STK2421,STK2411,360*60)
			}
			if (STK2411'="")&&(STK2421'="") Set NotSTK24=1
			
			Set:STK422'="" STK42L48H=..CompareTime(STK422,STK023,48*3600)
			
			Set:STK621'="" STK62L24H=..CompareTime(STK621,STK023,24*3600)
			
			Set:(STK101'="")&&(STK101["一周内") STK10L1W=1
			Set:(STK101'="")&&(STK101["一周之后") STK10M1W=1
			
			Set:STK7231'="" STK72L48H=..CompareTime(STK7231,STK023,48*3600)
			
			Set:(STK81'="")&&(STK81["阿司匹林") STK81ASPL=1
			Set:(STK81'="")&&(STK81["氯吡格雷") STK81ZLGL=1
			
			Set:(STK333'="")&&(STK333["华法林") STK33HFL=1
			
			Set:(STK933'="")&&(STK933["不接受") STK933JY=0
			
			Set:(STK146'="")&&((STK146["很满意")||(STK146["较满意")) STK146Flg=1
	
			//通过公用方法获取病人基本信息
			Set PaadmData=..GetBaseInfo(MrlistID)
			Set Data=PaadmData_$lb(STK12L15M,STK12L60M,STK13L60M,STK14L60M,STK15L60M,STK24L270M,STK24L360M,NotSTK24,STK42L48H,STK62L24H,STK52,STK10L1W,STK10M1W,STK72L48H,STK134,STK81ASPL,STK81ZLGL,STK33HFL,STK933JY,STK146Flg)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QrySTKClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySTKExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QrySTKFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySTKExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// 单病种诊疗信息数据-社区获得性肺炎Cap-Adult
/// zhangdc
/// 2020-04-30
/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.SDS.Stat.StatService","QryCapAdult","","2020-04-28","2020-05-28","")
Query QryCapAdult(aHospID As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String) As %Query(ROWSPEC = "MrNo:%String,PatName:%String,InHosDays:%String,ICDDesc:%String,HospCost:%String,DrugFee:%String,AntiFee:%String,CheckFee:%String,MaterialFee:%String,DischCondDesc:%String,CapAdult1:%String,CapAdult1Score:%String,CapAdult21:%String,CapAdult313Coll:%String,CapAdult313Before:%String,Frontline:%String,Secondline:%String,Threeline:%String,CapAdult42L4H:%String,CapAdult42M4H:%String,CapAdult621:%String,AntiDays:%String,CapAdult83JY:%String,CapAdult116Flg:%String") [ SqlProc ]
{
}

ClassMethod QryCapAdultExecute(ByRef qHandle As %Binary, aHospID As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	For xDate=aDateFrom:1:aDateTo {
		/*按入组日期*/
		Set MrlistID=""
		For {
			Set MrlistID = $o(^DHCMA.CPW.SD.QCMrListI("IndexInDate",xDate,MrlistID))
			Quit:MrlistID=""
			Set MrListObj	=##class(DHCMA.CPW.SD.QCMrList).GetObjById(MrlistID)
			Continue:MrListObj.QCState="O"
			Continue:MrListObj.QCEntityDr.BTAbbrev'="Cap-Adult"
			//默认取值版本
			Set QCID=MrListObj.QCEntityDr.%Id()
			Set VerID=MrListObj.QCEntityDr.BTVersion.%Id()
			/*
			到达医院后首次病情严重程度评估的时间与结果 时间暂无->Cap-Adult-1 评分：Cap-Adult-1-1-A/Cap-Adult-1-1-B/Cap-Adult-1-1-C-1/Cap-Adult-1-1-D-1
			重症患者、入院ICU患者实施氧合评估的时间 时间暂无->Cap-Adult-2-1
			重症患者、入院ICU患者实施病原学检查的时间 Cap-Adult-3-1-3/Cap-Adult-3-1-2
			起始抗菌药物种类（经验性用药）选择: Cap-Adult-5-2/Cap-Adult-5-2-1/Cap-Adult-5-2-2/Cap-Adult-5-2-3/Cap-Adult-5-2-4/Cap-Adult-5-2-5/Cap-Adult-5-2-6
				一线抗菌药物:青霉素类-青霉素G,青霉素V,氨苄西林,阿莫西林,羧苄西林,苯唑西林,氯唑西林,氨苄西林+舒巴坦
							 头孢菌素类-头孢拉定,头孢唑啉,头孢羟氨苄,头孢克洛,头孢丙烯,头孢呋辛
							 大环内酯类-红霉素
							 喹诺酮类-左氧氟沙星,环丙沙星,吉米沙星
							 其他类-多西环素,利奈唑胺,利福平,厄他培南,美罗培南,克林霉素
							 抗真菌药物-卡泊芬净,米卡芬净,伏利康唑,两性霉素B含脂制剂
				二线抗菌药物:青霉素类-美洛西林,
							 头孢菌素类-头孢地尼,头孢噻肟,头孢曲松
							 大环内酯类-罗红霉素,阿奇霉素,克拉霉素
							 喹诺酮类-莫西沙星
							 其他类-氨曲南
							 抗真菌药物-伊曲康唑
				三线抗菌药物:青霉素类-哌拉西林,
							 头孢菌素类-头孢哌酮
							 其他类-万古霉素,亚胺培南,帕尼培南
			入院后患者接受首次抗菌药物治疗的时间 Cap-Adult-4-2
			初始治疗后评价无效，重复病原学检查的时间	暂无->Cap-Adult-6-2-1
			抗菌药物使用天数  Cap-Adult-4-1-1/Cap-Adult-7-1-2
			健康教育 Cap-Adult-8-3
			患者对服务满意度	Cap-Adult-11-6
			*/
			//将所有涉及的单元格统一赋值
			Set DataList=$lb("Cap-Adult-1-1-A","Cap-Adult-1-1-B","Cap-Adult-1-1-C-1","Cap-Adult-1-1-D-1","Cap-Adult-1","Cap-Adult-2-1","Cap-Adult-3-1-3","Cap-Adult-3-1-2","Cap-Adult-5-2-1","Cap-Adult-5-2-2","Cap-Adult-5-2-3","Cap-Adult-5-2-4","Cap-Adult-5-2-5","Cap-Adult-5-2-6","Cap-Adult-5-2","Cap-Adult-4-2","Cap-Adult-6-2-1","Cap-Adult-4-1-1","Cap-Adult-7-1-2","Cap-Adult-8-3","Cap-Adult-11-6")		
			For xind=1:1:$ll(DataList) {
				Set xItemCode=$li(DataList,xind) 
				Set xEntityItem = ##class(DHCMA.CPW.SD.QCEntityItem).GetObjByVerCode(VerID,QCID,xItemCode)
				Set xItemID=xEntityItem.%Id()
				Set xItemValue=..GetItemValue(MrlistID,xItemID)
				Set xVal=$tr(xItemCode,"-","")
				Set Exp="Set "_xVal_"="""_xItemValue_""""
				x Exp
			}
			Set (CapAdult1Score,CapAdult313Coll,CapAdult313Before,Frontline,Secondline,Threeline,CapAdult42L4H,CapAdult42M4H,AntiDays,CapAdult83JY,CapAdult116Flg)=""
			//日期大小比较，合格1，不合格0,三个参数  A-B<=C  返回1
			Set:CapAdult11A'="" CapAdult1Score=CapAdult11A
			Set:CapAdult11B'="" CapAdult1Score=CapAdult11B
			Set:CapAdult11C1'="" CapAdult1Score=CapAdult11C1
			Set:CapAdult11D1'="" CapAdult1Score=CapAdult11D1
			
			if (CapAdult313'=""){
				if (CapAdult313["血")||(CapAdult313["痰"){
					Set CapAdult313Coll=1
				}
			}
			Set:(CapAdult312'="")&&(CapAdult312["治疗之前") CapAdult313Before=1
			
			Set medicineList=$lb("Cap-Adult-5-2-1","Cap-Adult-5-2-2","Cap-Adult-5-2-3","Cap-Adult-5-2-4","Cap-Adult-5-2-5","Cap-Adult-5-2-6")
			For xind=1:1:$ll(medicineList){
				Set xItemCode=$li(medicineList,xind)
				Set exp="Set xVal="_$tr(xItemCode,"-","")
				x exp
				Set:xVal'="" xVal=$p(xVal,$c(1),1)
				Set Resume=""
				Set objDictionary= ##class(DHCMA.CPW.SD.Dictionary).GetObjByCode(xItemCode,xVal)
				Set:$isObject(objDictionary) Resume=objDictionary.BTResume
				Set:(Resume["一线") Frontline=1
				Set:(Resume["二线") Secondline=1
				Set:(Resume["三线") Threeline=1
			}
			
			Set:(CapAdult42["≤4h") CapAdult42L4H=1
			Set:(CapAdult42["≤6h")||(CapAdult42["≤8h")||(CapAdult42[">8h") CapAdult42M4H=1
			
			if (CapAdult411'="")&&(CapAdult712'=""){
				Set date1 = $p(CapAdult411," ",1)
				Set date2 = $p(CapAdult712," ",1)
				Set date1Seconds=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(date1)
				Set date2Seconds=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(date2)
				if (date2Seconds>date1Seconds){
					Set AntiDays=(date2Seconds-date1Seconds)
				}
			}
			
			Set:(CapAdult83["不接受") CapAdult83JY=0
			
			Set:((CapAdult116["很满意")||(CapAdult116["较满意")) CapAdult116Flg=1
	
			//通过公用方法获取病人基本信息
			Set PaadmData=..GetBaseInfo(MrlistID)
			Set Data=PaadmData_$lb(CapAdult1,CapAdult1Score,CapAdult21,CapAdult313Coll,CapAdult313Before,Frontline,Secondline,Threeline,CapAdult42L4H,CapAdult42M4H,CapAdult621,AntiDays,CapAdult83JY,CapAdult116Flg)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryCapAdultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCapAdultExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCapAdultFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCapAdultExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// 日期时间差与目标值比较大小
/// w ##class(DHCMA.CPW.SDS.Stat.StatService).CompareTime("2020-04-21 11:00:00","2020-04-20 10:00:00",24*3600)
ClassMethod CompareTime(thisDT, targetDT, CmpVal As %String = 0) As %String
{
	n (thisDT,targetDT,CmpVal)
	Set return=0
	//将时间入参转换为秒
	Set thisDate=$p(thisDT," ",1)
	Set thisTime=$p(thisDT," ",2)
	Set thisLogicDate=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(thisDate)
	Set thisLogicTime=##Class(DHCMA.Util.IO.FromHisSrv).TimeHtmlToLogical(thisTime)
	Set thisValue=thisLogicDate*86400+thisLogicTime
	Set targetDate=$p(targetDT," ",1)
	Set targetTime=$p(targetDT," ",2)
	Set targetLogicDate=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(targetDate)
	Set targetLogicTime=##Class(DHCMA.Util.IO.FromHisSrv).TimeHtmlToLogical(targetTime)
	Set targetValue=targetLogicDate*86400+targetLogicTime
	Set Exp="Set return="_thisValue_"-"_targetValue_"<="_CmpVal
	x Exp
	Quit return
}

/// 计算日期时间差 分钟
/// w ##class(DHCMA.CPW.SDS.Stat.StatService).CalcTime("2020-04-21 11:00:00","2020-04-20 10:00:00")
ClassMethod CalcTime(thisDT, targetDT) As %String
{
	n (thisDT,targetDT)
	Set return=0
	//将时间入参转换为秒
	Set thisDate=$p(thisDT," ",1)
	Set thisTime=$p(thisDT," ",2)
	Set thisLogicDate=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(thisDate)
	Set thisLogicTime=##Class(DHCMA.Util.IO.FromHisSrv).TimeHtmlToLogical(thisTime)
	Set thisValue=thisLogicDate*86400+thisLogicTime
	Set targetDate=$p(targetDT," ",1)
	Set targetTime=$p(targetDT," ",2)
	Set targetLogicDate=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(targetDate)
	Set targetLogicTime=##Class(DHCMA.Util.IO.FromHisSrv).TimeHtmlToLogical(targetTime)
	Set targetValue=targetLogicDate*86400+targetLogicTime
	Set tmpTime=thisValue-targetValue
	Set return=tmpTime/60
	Quit return
}

/// 获取单病种患者表单基本信息,将常用的基本信息单独处理
/// w ##class(DHCMA.CPW.SDS.Stat.StatService).GetBaseInfo(15)
ClassMethod GetBaseInfo(aMrListID) As %Library.List
{
	n (aMrListID)
	Set return=""
	//住院号 姓名 诊断 住院天数
	Set MrlistObj=##class(DHCMA.CPW.SD.QCMrList).GetObjById(aMrListID)
	Quit:'$IsObject(MrlistObj) return
	Set Abbrev=MrlistObj.QCEntityDr.BTAbbrev
	Set EpisodeID=MrlistObj.QCEpisodeID
	Set QCID=MrlistObj.QCEntityDr.%Id()
	Set VerID=MrlistObj.QCEntityDr.BTVersion.%Id()
	Set:(EpisodeID["!!") EpisodeID=$p(EpisodeID,"!!",1)
	Set objPaadm=##class(DHCMA.Util.EP.Episode).GetObjByOID(EpisodeID)
	Quit:'$IsObject(objPaadm) return
	Set MrNo=objPaadm.PAMrNo
	Set PatName=objPaadm.PAPatName
	Set InHosDays=objPaadm.PAAdmDays
	Set:InHosDays<0 InHosDays=+$h-objPaadm.PAAdmDate
	//单病种表单诊断或手术
	Set ICDItemCode="CM-0-1-3-1"
	Set ObjEntityItem = ##class(DHCMA.CPW.SD.QCEntityItem).GetObjByVerCode(VerID,QCID,ICDItemCode)
	Set ItemID=ObjEntityItem.%Id()
	Set ESubID=$o(^DHCMA.CPW.SD.QCMrListI("Exec","IndexParrefItemDr",aMrListID,ItemID,""),-1)
	Set ICDDesc=""
	IF (ESubID'="") {
		Set ItemExecObj=##class(DHCMA.CPW.SD.QCItemExec).GetObjById(aMrListID_"||"_ESubID)
		Set ExecResult=ItemExecObj.ExecResult
 		Set DicItemObj=##class(DHCMA.CPW.SDS.DictionarySrv).GetObjByPCodeItemCode(QCID,VerID,ICDItemCode,ExecResult)
		Set BTDesc=""
		Set:$IsObject(DicItemObj) BTDesc=DicItemObj.BTDesc
		For yInd=1:1:$l(BTDesc) {
				Set xcon=$e(BTDesc,yInd,yInd)
				//分离字母数字，取疾病描述
				Continue:$ASCII(xcon)<127
				Set ICDDesc=ICDDesc_xcon
			}
	}
	//MCNew:新病案首页子分类,	TMCNew:新病案首页大类
	Set FeeInfo=##class(DHCMA.CPW.SD.DataSrv.FeeInfoSrv).GetDataByAdm(EpisodeID)
	Set (HospCost,DrugFee,AntiFee,CheckFee,MaterialFee)=0

	Set HospCost=FeeInfo.Fee1
	Set DrugFee=FeeInfo.Fee18+FeeInfo.Fee20+FeeInfo.Fee21
	Set AntiFee=FeeInfo.Fee19
	Set CheckFee=FeeInfo.Fee9
	Set MaterialFee=FeeInfo.Fee27	
	//治疗效果
	Set MRAdm=$P($g(^PAADM(EpisodeID)),"^",61)
	Set DischCondID=$p($g(^MR(+MRAdm,"PRO",1)),"^",10)
	Set DischCondDesc=$p($g(^PAC("DISCON",+DischCondID)),"^",2)
	Set:(DischCondDesc["稳定")||(DischCondDesc["恶化") DischCondDesc="未愈"
	Set:DischCondDesc["治愈" DischCondDesc="治愈"
	Set:DischCondDesc["好转" DischCondDesc="好转"
	Set:DischCondDesc["已故" DischCondDesc="死亡"
	Set:DischCondDesc["死亡" DischCondDesc="死亡"
	Set return=$lb(MrNo,PatName,InHosDays,ICDDesc,HospCost,DrugFee,AntiFee,CheckFee,MaterialFee,DischCondDesc)
	Quit return
}

/// 获取表单项目值
ClassMethod GetItemValue(MrListID As %String, xRowID As %String) As %String
{
	n (MrListID,xRowID)
	Set return=""
	Set ESubID=$o(^DHCMA.CPW.SD.QCMrListI("Exec","IndexParrefItemDr",MrListID,xRowID,""),-1)
	Set EditPower=1 //默认每个项目可编辑
	Quit:ESubID="" return
	Set ItemExecObj=##class(DHCMA.CPW.SD.QCItemExec).GetObjById(MrListID_"||"_ESubID)
	Set ObjEntityItem = ##class(DHCMA.CPW.SD.QCEntityItem).GetObjById(xRowID)
	Quit:'ObjEntityItem.BTIsActive return
	Set QCID=ObjEntityItem.Parref.%Id()
	Set aVerID=ObjEntityItem.BTVersion.%Id()
 	Set BTCode = ObjEntityItem.BTCode
	If $IsObject(ItemExecObj){
 		Set ExecResult=ItemExecObj.ExecResult
 		Set ExecResultText=""
 		//如果存的是字典代码  需要转换为描述
 		for ResultInd=1:1:$l(ExecResult,",") {
	 		Set ExecResultSub=$p(ExecResult,",",ResultInd)
 			Set DicItemObj=##class(DHCMA.CPW.SDS.DictionarySrv).GetObjByPCodeItemCode(QCID,aVerID,BTCode,ExecResultSub)
 			Set:$IsObject(DicItemObj) ExecResultText=ExecResultText_","_DicItemObj.BTDesc
 		}
 		Set:ExecResultText'="" ExecResultText=$e(ExecResultText,2,$l(ExecResultText))
 		Set ExecRowID=MrListID_"||"_ESubID
	}
	Set return=ExecResult
	Set:ExecResultText'="" return=ExecResult_$c(1)_ExecResultText
	Quit return
}

/// 2020-04-24
/// zhangdc
/// 获取最小日期
/// w ##class(DHCMA.CPW.SDS.Stat.StatService).getMinDateTime($lb("2018-01-01 10:00:11","","2018-05-03 10:00:11"))
ClassMethod getMinDateTime(arr As %ArrayOfDataTypes) As %String
{
	Set len=$LL(arr)
	Set return="",MinDate=""
	for i=1:1:len{
		Set tmpDateTime=$lg(arr,i)
		continue:tmpDateTime=""
		Set date = $p(tmpDateTime," ",1)
		Set time = $p(tmpDateTime," ",2)
		Set date=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(date)
		Set time=##Class(DHCMA.Util.IO.FromHisSrv).TimeHtmlToLogical(time)
		Set LogicDT=date*86400+time
		Set:return="" return=LogicDT,MinDate=tmpDateTime
		Set:return>LogicDT return=LogicDT,MinDate=tmpDateTime
	}
	Quit MinDate
}

/// 获取表单手术并发症信息
/// w ##class(DHCMA.CPW.SDS.Stat.StatService).getMrOperComInfo(7)
ClassMethod getMrOperComInfo(aMrlistID As %String)
{
	new (aMrlistID)
	Set return=""
	Set MrlistObj=##class(DHCMA.CPW.SD.QCMrList).GetObjById(aMrlistID)
	Quit:'$IsObject(MrlistObj) return
	Set QCID=MrlistObj.QCEntityDr.%Id()
	Set VerID=MrlistObj.QCEntityDr.BTVersion.%Id()
	Set DataList=$lb("CM-2-2","CS-6-1-3-1")		//通用手术并发症项目以及剖宫产并发症，可扩展
	For xind=1:1:$ll(DataList) {
		Set xItemCode=$li(DataList,xind) 
		Set xEntityItem = ##class(DHCMA.CPW.SD.QCEntityItem).GetObjByVerCode(VerID,QCID,xItemCode)
		If ($IsObject(xEntityItem)) {
			Set xItemID=xEntityItem.%Id()
			Set isShow=##class(DHCMA.CPW.SDS.Stat.CommonSrv).GetItemShowValue(aMrlistID,xItemID)
			Continue:isShow'=1
			Set xItemValue=..GetItemValue(aMrlistID,xItemID)
			Set:xItemValue[$c(1) xItemValue=$p(xItemValue,$c(1),2) //字典类型项目取描述
			Set return=xItemValue
			Quit
		}	
	}
	Quit return
}

/// 单病种病种手术诊断分配比
/// zqy
/// 2022-08-30
/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.SDS.Stat.StatService","QryOperData","2","2022-01-1","2022-01-12","4","1")
Query QryOperData(aHospID As %String, aDateFrom As %String, aDateTo As %String, aEntityID As %String, aType As %String) As %Query(ROWSPEC = "EntityDesc:%String,BTDesc:%String,BTICD:%String,BTCount:%Float,BTUpCount:%Float,BTOutCount:%Float,BTAdmDays:%Float,BTAdmFee:%Float,BTDeath:%Float,BTPlications:%Integer") [ SqlProc ]
{
}

ClassMethod QryOperDataExecute(ByRef qHandle As %Binary, aHospID As %String, aDateFrom As %String, aDateTo As %String, aEntityID As %String, aType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Kill ^||TMP("QryOperData",repid)
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set:aType=1 Item="CM-0-1-4-1"	//4位手术编码code
	Set:aType=0 Item="CM-0-1-3-1"	//4位诊断编码code
	Set aDateFrom=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Set obj=##class(DHCMA.CPW.SD.QCEntity).GetObjById(aEntityID)
	Quit:'$IsObject(obj)
	Set EntityDesc=obj.BTDesc
	Set DischDateIndex=##Class(DHCMA.Util.IO.FromHisSrv).GetDischDateIndex()  //update by pylian 2016-01-21取出院时间索引
	Set Array=##class(DHCMA.Util.IO.CommonSrv).GetArrayOfQueryData("DHCMA.CPW.SDS.DictionarySrv","QryDictByType",aEntityID,"2",Item,"1")
	For Index=1:1:Array.Count() {
		Set Info=Array.GetAt(Index)
		Set BTDesc=Info.GetAt("BTDesc")		
		Set Code=Info.GetAt("BTCode")		
		Continue:BTDesc["请选择"
		Set DescICD=..GetDescAndICD(BTDesc)
		Set Desc=$p(DescICD,"^",1)
		Set ICD=$p(DescICD,"^",2)
		Continue:ICD=""
		if ('$d(^||TMP("QryOperData",repid,"Code",Code))){
			Set ^||TMP("QryOperData",repid,"Code",Code)=DescICD
		}
	}
	For xDate=aDateFrom:1:aDateTo {
		Set xPaadm=""
		For {
			Set xPaadm=$o(^PAADMi(DischDateIndex,xDate,xPaadm))
			Quit:xPaadm=""
			Set AdmInfo=$g(^PAADM(xPaadm))
			Continue:$p(AdmInfo,"^",2)'="I"           //就诊类型过滤
			Continue:$p(AdmInfo,"^",20)="C"           //就诊状态过滤
			Set EpisodeID=##class(DHCMA.Util.EPS.OIDService).GetValidOID(xPaadm)
			Set xID=""
			Set xID=$o(^DHCMA.CPW.SD.QCMrListI("IndexEpisodeID",EpisodeID,""),-1)
			Continue:xID=""
			Set obj=##class(DHCMA.CPW.SD.QCMrList).GetObjById(xID)
			Continue:'$IsObject(obj)
			Set QCState=obj.QCState
			Set QCEntity=obj.QCEntityDr
			Continue:'$IsObject(QCEntity)
			Continue:(QCEntity.BTIsActive'=1)
			Set QCEntityID=QCEntity.%Id()
			Continue:(aEntityID'=QCEntityID)
			Set InLocOID=obj.QCInLocID
			Set objInLoc=##class(DHCMA.Util.EP.Location).GetObjByOID(InLocOID)
			Set InLocDesc="",InLocID=""
			If ($IsObject(objInLoc)){
				Set InLocID=+InLocOID
				Set InLocDesc=objInLoc.BTDesc
				Set:InLocDesc["-" InLocDesc=$p(InLocDesc,"-",2)
			}
			Set xHospID=+$p($g(^CTLOC(($p(InLocID,"!!",1)))),"^",22)
 			Continue:(aHospID'="")&&(aHospID'[xHospID)
			Set EpisodeID=obj.QCEpisodeID
			Set QCCurrStatusSubID=$o(^DHCMA.CPW.SD.QCMrListStateI("IndexParref",xID,""),-1)
			Set QCCurrStatusID=xID_"||"_QCCurrStatusSubID
			Set StatusObj=##class(DHCMA.CPW.SD.QCMrListState).GetObjById(QCCurrStatusID)
			Set:$IsObject(StatusObj) QCState=StatusObj.StateCode.BTCode
			Set Itemobj=##class(DHCMA.CPW.SD.QCEntityItem).GetObjByVerCode("2",QCEntityID,Item)
			Continue:'$IsObject(Itemobj)
			Set ItemID=Itemobj.%Id()
			Set ret=..InitItemValue(xID,ItemID,aEntityID)	//返回的是code
			if (ret'=""){
				Set len=$l(ret,",")
				For index=1:1:len{
					Set Code=$p(ret,",",index)
					Continue:(Code="")
					Continue:($ASCII(Code)>122)
					//记录当前除排除的人
					if (('$d(^||TMP("QryOperData",repid,"All",xID)))&&((QCState'="O"))){
						Set ^||TMP("QryOperData",repid,"All",xID)=Code
					}
					if ('$d(^||TMP("QryOperData",repid,Code,"Count"))){
						Set ^||TMP("QryOperData",repid,Code,"Count")=1
					}else{
						Set ^||TMP("QryOperData",repid,Code,"Count")=$g(^||TMP("QryOperData",repid,Code,"Count"))+1
					}
					if (QCState="O"){
						if ('$d(^||TMP("QryOperData",repid,Code,"Out"))){
							Set ^||TMP("QryOperData",repid,Code,"Out")=1
						}else{
							Set ^||TMP("QryOperData",repid,Code,"Out")=$g(^||TMP("QryOperData",repid,Code,"Out"))+1
						}
					}elseIf(QCState="Up"){
						//上报人数
						if ('$d(^||TMP("QryOperData",repid,Code,"Up"))){
							Set ^||TMP("QryOperData",repid,Code,"Up")=1
						}else{
							Set ^||TMP("QryOperData",repid,Code,"Up")=$g(^||TMP("QryOperData",repid,Code,"Up"))+1
						}
					}
			
				}
			}else{
				//记录当前除排除的人
				if (('$d(^||TMP("QryOperData",repid,"All",xID)))&&((QCState'="O"))){
					Set ^||TMP("QryOperData",repid,"All",xID)=""
				}
				if ('$d(^||TMP("QryOperData",repid,"Other","Count"))){
						Set ^||TMP("QryOperData",repid,"Other","Count")=1
					}else{
						Set ^||TMP("QryOperData",repid,"Other","Count")=$g(^||TMP("QryOperData",repid,"Other","Count"))+1
					}
					if (QCState="O"){
						if ('$d(^||TMP("QryOperData",repid,"Other","Out"))){
							Set ^||TMP("QryOperData",repid,"Other","Out")=1
						}else{
							Set ^||TMP("QryOperData",repid,"Other","Out")=$g(^||TMP("QryOperData",repid,"Other","Out"))+1
						}
					}elseIf(QCState="Up"){
						//上报人数
						if ('$d(^||TMP("QryOperData",repid,"Other","Up"))){
							Set ^||TMP("QryOperData",repid,"Other","Up")=1
						}else{
							Set ^||TMP("QryOperData",repid,"Other","Up")=$g(^||TMP("QryOperData",repid,"Other","Up"))+1
						}
					}
			}
		}
	}
	//遍历索引来取所有的值
	Set MrListID=""
	For{
		Set MrListID=$o(^||TMP("QryOperData",repid,"All",MrListID))
		Quit:MrListID=""
		Set Code=$g(^||TMP("QryOperData",repid,"All",MrListID))
		Set:Code="" Code="Other"
		Set obj=##class(DHCMA.CPW.SD.QCMrList).GetObjById(MrListID)
		Continue:'$IsObject(obj)
		Set objPaadm=##class(DHCMA.Util.EPy.EpisodeSrv).GetSynObjByOID(obj.QCEpisodeID)
		Continue:'$IsObject(objPaadm)
		Set AdmDate=objPaadm.PAAdmDate
		Set DischDate=objPaadm.PADischDate
		Set:AdmDate["-" AdmDate=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(AdmDate)
		Set:DischDate["-" DischDate=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(DischDate)
		//住院日
		Set:DischDate="" DischDate=+$h
		Set AdmDays=DischDate-AdmDate	
		if ('$d(^||TMP("QryOperData",repid,Code,"Days"))){
			Set ^||TMP("QryOperData",repid,Code,"Days")=AdmDays
		}else{
			Set ^||TMP("QryOperData",repid,Code,"Days")=$g(^||TMP("QryOperData",repid,Code,"Days"))+AdmDays
		}
		//费用
		Set Paadm=$p(obj.QCEpisodeID,"!!",1)
		Set objFee=##class(DHCMA.CPW.SD.DataSrv.FeeInfoSrv).GetDataByAdm(Paadm)
		Continue:'$IsObject(objFee) 
		if ('$d(^||TMP("QryOperData",repid,Code,"Fee"))){
			Set ^||TMP("QryOperData",repid,Code,"Fee")=objFee.Fee1
		}else{
			Set ^||TMP("QryOperData",repid,Code,"Fee")=$g(^||TMP("QryOperData",repid,Code,"Fee"))+objFee.Fee1
		}
		
		Set Glossary=##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossaryCategory(Paadm,"HDSD00.11")
		Continue:'$IsObject(Glossary)
		
		Set flag=0
		Set DeathFlag=Glossary.GetAt("HDSD00.11.057")	//出院状态术语集	
		Set:DeathFlag=5 flag=1	
		if ('$d(^||TMP("QryOperData",repid,Code,"Death"))){
			Set ^||TMP("QryOperData",repid,Code,"Death")=flag
		}else{
			Set ^||TMP("QryOperData",repid,Code,"Death")=$g(^||TMP("QryOperData",repid,Code,"Death"))+flag
		}
		//并发症
		Set return=Glossary.GetAt("HDSD00.11.1276")	//并发症术语集
		Set xflag=0
		Set:return="1" xflag=1
		Set:return="是" xflag=1
		if ('$d(^||TMP("QryOperData",repid,Code,"Plications"))){
			Set ^||TMP("QryOperData",repid,Code,"Plications")=xflag
		}else{
			Set ^||TMP("QryOperData",repid,Code,"Plications")=$g(^||TMP("QryOperData",repid,Code,"Plications"))+xflag
		}
	}
	Set xCode=""
	For{
		Set xCode=$o(^||TMP("QryOperData",repid,"Code",xCode))	
		Quit:xCode=""
		Set Count=0,UpCount=0,OutCount=0,AdmDays=0,AdmFee=0,Death=0,Plications=0
		Set DescICD=$g(^||TMP("QryOperData",repid,"Code",xCode))
		Set Desc=$p(DescICD,"^",1)	//名称
		Set ICD=$p(DescICD,"^",2)	//编码
		Set Count=$g(^||TMP("QryOperData",repid,xCode,"Count"))		//例数
		Set UpCount=$g(^||TMP("QryOperData",repid,xCode,"Up"))		//上报例数
		Set OutCount=$g(^||TMP("QryOperData",repid,xCode,"Out"))	//排除例数
		Set AdmDays=$g(^||TMP("QryOperData",repid,xCode,"Days"))	//住院天数
		Set AdmFee=$g(^||TMP("QryOperData",repid,xCode,"Fee"))		//费用
		Set Death=$g(^||TMP("QryOperData",repid,xCode,"Death"))		//病死率
		Set Plications=$g(^||TMP("QryOperData",repid,xCode,"Plications"))	//并发症例数
		Set Data=$lb(EntityDesc,Desc,ICD,Count,UpCount,OutCount,AdmDays,AdmFee,Death,Plications)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Set OtherCount=$g(^||TMP("QryOperData",repid,"Other","Count"))	//其他的例数
	Set OtherUpCount=$g(^||TMP("QryOperData",repid,"Other","Up"))	//其他的上报例数
	Set OtherOutCount=$g(^||TMP("QryOperData",repid,"Other","Out"))	//其他的排除例数
	Set OtherAdmDays=$g(^||TMP("QryOperData",repid,"Other","Days"))	//住院天数
	Set OtherAdmFee=$g(^||TMP("QryOperData",repid,"Other","Fee"))	//费用
	Set OtherDeath=$g(^||TMP("QryOperData",repid,"Other","Death"))	//病死率
	Set OtherPlications=$g(^||TMP("QryOperData",repid,"Other","Plications"))	//并发症例数
	Set Data=$lb(EntityDesc,"其他","无",OtherCount,OtherUpCount,OtherOutCount,OtherAdmDays,OtherAdmFee,OtherDeath,OtherPlications)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QryOperDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOperDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOperDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOperDataExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// 统计单病种排除病例明细
/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.SDS.Stat.StatService","QryOutQCPatSta","","2012-09-01","2022-09-30","15!!1","","")
Query QryOutQCPatSta(aHospID As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String, aQCEntityID As %String, aDocID As %String, aStaType As %String = "USER") As %Query(ROWSPEC = "ind:%String,xID:%String,InLocDesc:%String,DishLocDesc:%String,QCEntityName:%String,QCState:%String,OperStateDate:%String,OutReason:%String,xPaadm,MrNo:%String,QCInDate:%String,PAPatName:%String,DishDate:%String,PAAdmDocName:%String,DocDesc:%String") [ SqlProc ]
{
}

ClassMethod QryOutQCPatStaExecute(ByRef qHandle As %Binary, aHospID As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String, aQCEntityID As %String, aDocID As %String, aStaType As %String = "USER") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Set ^tmpzgz33=aLocID
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
 	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
 	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
 	Set:aDateFrom["/" aDateFrom=$zdh(aDateFrom,4)
 	Set:aDateTo["/" aDateTo=$zdh(aDateTo,4)
	Set Count=0
	Set DischDateIndex=##Class(DHCMA.Util.IO.FromHisSrv).GetDischDateIndex()  //update by pylian 2016-01-21取出院时间索引
	For xDate=aDateFrom:1:aDateTo {
		Set xPaadm=""
		For {
			Set xPaadm=$o(^PAADMi(DischDateIndex,xDate,xPaadm))
			Quit:xPaadm=""
			Set AdmInfo=$g(^PAADM(xPaadm))
			Continue:$p(AdmInfo,"^",2)'="I"           //就诊类型过滤
			Continue:$p(AdmInfo,"^",20)="C"           //就诊状态过滤
			Set EpisodeID=##class(DHCMA.Util.EPS.OIDService).GetValidOID(xPaadm)
			Set xID="",QCStateFlg=0,UpDate="",UpLastDays=""
			Set xID=$o(^DHCMA.CPW.SD.QCMrListI("IndexEpisodeID",EpisodeID,""),-1)
			Continue:xID=""
			Set obj=##class(DHCMA.CPW.SD.QCMrList).GetObjById(xID)
			Continue:'$IsObject(obj)
			Set QCState=obj.QCState
			Continue:(QCState'="O")
			
			Set QCEntity=obj.QCEntityDr
			Continue:'$IsObject(QCEntity)
			Continue:(QCEntity.BTIsActive'=1)
			Set QCEntityID=QCEntity.%Id()
			Continue:(aQCEntityID'="")&&(aQCEntityID'=QCEntityID)
			Set QCEntityCode=QCEntity.BTCode
			Set QCEntityName=QCEntity.BTDesc
			Set EpisodeID=obj.QCEpisodeID
			Set InLocOID=obj.QCInLocID
			Set objInLoc=##class(DHCMA.Util.EP.Location).GetObjByOID(InLocOID)
			Set InLocDesc="",InLocID=""
			If ($IsObject(objInLoc)){
				Set InLocID=+InLocOID
				Set InLocDesc=objInLoc.BTDesc
				Set:InLocDesc["-" InLocDesc=$p(InLocDesc,"-",2)
			}
			Set xHospID=+$p($g(^CTLOC(($p(InLocID,"!!",1)))),"^",22)
 			Continue:(aHospID'="")&&(aHospID'[xHospID)
			Set objPaadm=##class(DHCMA.Util.EPy.EpisodeSrv).GetSynObjByOID(EpisodeID)
			Continue:'$IsObject(objPaadm)
			Set AdmLoc=objPaadm.PAAdmLocID
			Set AdmLocDesc=objPaadm.PAAdmLocDesc	
			Set AdmDocID=objPaadm.PAAdmDocID
			//按当前科室过滤
			Continue:(aLocID'="")&&(aLocID'=AdmLoc)  
			Continue:(aDocID'="")&&(aDocID'=AdmDocID)
			//Continue:(aLocID'="")&&(aLocID'=InLocID) //以入组科室显示
			Set DishDate=objPaadm.PADischDate		
			
			Set PAPatName=objPaadm.PAPatName
			Set MrNo=objPaadm.PAMrNo
			Set PAAdmDocName=objPaadm.PAAdmDocName
			Set QCInDate=obj.QCInDate
			Set:QCInDate'="" QCInDate=$zd(QCInDate,3)
			Set DocID="",xObj="",DocDesc="",OperStateDate="",OutReason=""
			//取最后一次操作记录，排除状态病例最后一条即为排除操作
			Set xStateID=$o(^DHCMA.CPW.SD.QCMrListStateI("IndexParref",xID,""),-1)
			Set:xStateID'="" xObj=##class(DHCMA.CPW.SD.QCMrListState).GetObjById(xID_"||"_xStateID)
			Continue:'$IsObject(xObj)
			Continue:xObj.StateCode.BTCode'="O"
			Set OperStateDate=xObj.StateDate
			Set:OperStateDate'="" OperStateDate=$zd(OperStateDate,3)
			Set DocID=xObj.StateDoc
			Set objUser=##class(DHCMA.Util.EPx.SSUser).GetObjByOID(DocID_"!!1")
			Set:$IsObject(objUser) DocDesc=objUser.BTDesc
			Set StateType=""
			//如果存在操作类型属性，取该属性值
			Set:(##class(%Dictionary.PropertyDefinition).%ExistsId("DHCMA.CPW.SD.QCMrListState||StateType")) StateType=xObj.StateType
			If (StateType'="") {
				Continue:(aStaType'="")&&(aStaType'=StateType)
			}else{
				If (DocID'["!!"){ //手工排除
					Continue:(aStaType="SYS")
				}else{
					Set DocDesc="系统操作"  ;默认系统排除
					Continue:(aStaType="USER")
				}
			}
			Set xAliasId=$o(^DHCMA.CPW.SD.QCMrStateAliasI("IndexParref",xID,xStateID,""),-1)
			if (xAliasId'=""){
				Set xobjAlias=##class(DHCMA.CPW.SD.QCMrStateAlias).GetObjById(xID_"||"_xStateID_"||"_xAliasId)
				if ($IsObject(xobjAlias)){
					Set xobjOperRule=xobjAlias.OperRule
		 			If $IsObject(xobjOperRule) {
						For aLInd=1:1:xobjOperRule.Count(){
							Set xRuleObj=xobjOperRule.GetAt(aLInd)
							Continue:'$IsObject(xRuleObj)
							Set Exclude=xRuleObj.RuleDesc
							Continue:Exclude=""
							Set OutReason=OutReason_"/"_Exclude
						}
		 			}
		 			Set:OutReason'="" OutReason=$e(OutReason,2,$l(OutReason))
		 			if (xobjAlias.OperResume'=""){
			 			Set OutReason=OutReason_" 备注："_xobjAlias.OperResume
				 	}
				}
			}		
			Set Data=$lb(ind,xID,InLocDesc,AdmLocDesc,QCEntityName,QCState,OperStateDate,OutReason,xPaadm,MrNo,QCInDate,PAPatName,DishDate,PAAdmDocName,DocDesc)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1

		}
	}
	Quit $$$OK
}

ClassMethod QryOutQCPatStaClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOutQCPatStaExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOutQCPatStaFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOutQCPatStaExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// zqy
/// 获取手术名称及icd编码
/// w ##class(DHCMA.CPW.SDS.Stat.StatService).GetDescAndICD("31.1 暂时性气管造口术")
ClassMethod GetDescAndICD(DescICD As %String) As %String
{
	new (DescICD)
	Set ICD="",Desc=""
	If ((DescICD["：")||(DescICD[":")){
		//区间范围
		Set DescICD=$tr(DescICD,"：",":")
		Set DescICD=$tr(DescICD," ","")
		Set ICD=$p(DescICD,":",2)
		Set Desc=$p(DescICD,":",1)
		Set ICD=$tr(ICD,"至","-") 
	}else{
		Set ICDCode=""
		for yInd=1:1:$l(DescICD) {
			Set xcon=$e(DescICD,yInd,yInd)
			//编码为空或者为汉字，则退出
			Quit:(xcon="")||($ASCII(xcon)>127)
			Set ICDCode=ICDCode_xcon
		}
		Set Desc=$Replace(DescICD,ICDCode,"")
		Set ICD=ICDCode
	}
	
	Set Desc=$tr(Desc," ","")
	Set Desc=$tr(Desc,"ICD-9-CM-3","")
	Set ICD=$tr(ICD," ","")
	Quit Desc_"^"_ICD
}

/// 单独生成某个项目的值
/// w ##class(DHCMA.CPW.SDS.Stat.StatService).InitItemValue("14340","2||12",2)
ClassMethod InitItemValue(aMrListID, aItemID, aEntityID) As %String
{
	New (aMrListID,aItemID,aEntityID)
	Set return="",ret=""
	Quit:(aMrListID="")||(aItemID="") return
	set objItem=##class(DHCMA.CPW.SD.QCEntityItem).GetObjById(aItemID)
	set objMr=##class(DHCMA.CPW.SD.QCMrList).GetObjById(aMrListID)
	set EpisodeID=objMr.QCEpisodeID
	set ItemID=aItemID
	/**关联项目取值**/
	Set Result=""
	set exp=objItem.BTExpressDr.BTExpress
	if (exp'=""){
		//配置项目直接取值参数，走该方式
		Set:exp'["()" exp=exp_"()"
		/// 运行项目表达式
		set expResult="set Result="_exp
		x expResult
	}else{
		//配置项目数据源标准取值，走该方式
		set Result=##class(DHCMA.CPW.SDS.QCItemDataConfigSrv).GetValByDataConfig(EpisodeID,ItemID)
		Set:$p(Result,"^",1)="" Result="" //如果结果值为空，置整个返回值为空
	}
	if (Result=""){
		Set objType = ##class(DHCMA.CPW.SD.DicType).GetObjByCode(aEntityID,"2",objItem.BTCode)
	 	if ($Isobject(objType)) {
		 	Set TypeDr = objType.%Id()
		 	Set xCode = ""
		 	For {
			 	Set xCode= $o(^DHCMA.CPW.SD.DictionaryI("IdxofTypeDrCode",TypeDr,xCode))
			 	Quit:xCode=""	 	
			 	Set DicRowID = ""
			 	For {
				   	Set DicRowID= $o(^DHCMA.CPW.SD.DictionaryI("IdxofTypeDrCode",TypeDr,xCode,DicRowID))
				   	Quit:DicRowID=""
				 	Set BTDicObj= ##class(DHCMA.CPW.SD.Dictionary).GetObjById(DicRowID)
				 	Continue:'$IsObject(BTDicObj)
				 	Continue:BTDicObj.BTIsActive'=1
				 	Continue:BTDicObj.BTIsDefault'=1
				 	Set Result=Result_","_BTDicObj.BTCode
			 	}
		 	}
		 	Set:Result'="" Result=$e(Result,2,$l(Result))
		 	}
		 	Quit:Result="" return
	}		
	/// 运行表达式|获取默认值后更新项目执行记录
	if (Result'="")
	{
		Set objItemTmp=objItem
		d InitOneItemValue
	}
	if (return=""){
		Set return=Result	
	}else{
		Set return=return_"^"_Result	
	}
	quit return
InitOneItemValue
	Set ResultTmp=Result
	Set ResultOth=""
	Set Result=$p(Result,"^",1)
	Set:$l(ResultTmp,"^")>1 ResultOth=$e(ResultTmp,($l(Result)+2),$l(ResultTmp))
	//如果是字典类型，通过名称匹配代码
	if (objItem.BTTypeDr.BTDesc["字典")  {
		//特殊字典对照
		Set ResultCode=""
		if (Result="M"){
			Set Result="男"
		}elseif(Result="F"){
			Set Result="女"
		}elseif(Result="有"){
			Set Result="有，是"
		}elseif(Result="无"){
			Set Result="无，否"
		}
		Set DicTypeCode=objItem.BTCode
		Set DicTypeID=$o(^DHCMA.CPW.SD.DicTypeI("IdxofQCVerCode",aEntityID,"2"," "_$zcvt(DicTypeCode,"U"),0))
		Set DicCode=""
		For {
			Set DicCode=$o(^DHCMA.CPW.SD.DictionaryI("IdxofTypeDrCode",DicTypeID,DicCode))
			Quit:DicCode=""
			Set DicID=$o(^DHCMA.CPW.SD.DictionaryI("IdxofTypeDrCode",DicTypeID,DicCode,""),-1)
			Set DicObj=##class(DHCMA.CPW.SD.Dictionary).GetObjById(DicID)
			Set DicDesc=DicObj.BTDesc
			//增加值域字典，关键字信息匹配（来源于值域字典对照+标准字典关键字信息）
			Set KeyInfo=##class(DHCMA.CPW.SD.QCOptionMatchKey).GetKeyInfoByDicId(DicID)
			If (KeyInfo'=""){
				Set DicKey=$p(KeyInfo,"^",1)
				Set DicFilter=$p(KeyInfo,"^",2)
				Set KeyFlg=..CheckDicKey(Result,DicKey,DicFilter)
				Set:KeyFlg=1 ResultCode=ResultCode_","_DicObj.BTCode 
			}
			//$ASCII(Result) 判断，如果是汉字描述/或者超长描述，走描述匹配
			If (($ASCII(Result)>122)||($l(Result)>8)){
				If (KeyInfo'=""){
					Set DicKey=$p(KeyInfo,"^",1)
					Set DicFilter=$p(KeyInfo,"^",2)
					Set KeyFlg=..CheckDicKey(Result,DicKey,DicFilter)
					Set:KeyFlg=1 ResultCode=ResultCode_","_DicObj.BTCode 
				}elseif (((DicDesc[Result)||(Result[DicDesc))){
						Set ResultCode=ResultCode_","_DicObj.BTCode
				}
			}
			//考虑到病人医嘱可能会执行多个字典结果，拼串
			Set:((","_DicObj.BTCode_",")[(","_Result))||((","_Result_",")[(","_DicObj.BTCode_",")) ResultCode=ResultCode_","_DicObj.BTCode
			//非多选项目，ResultCode不为空则退出
			Quit:((ResultCode'="")&&(objItem.BTTypeDr.BTDesc'["多选"))
		}
		Set:ResultCode'="" ResultCode=$e(ResultCode,2,$l(ResultCode))
		Set Result=ResultCode
	}
	Quit Result
}

/// w ##class(DHCMA.CPW.SDS.QCTask).CheckDicKey("城镇医疗保险","城镇")
ClassMethod CheckDicKey(DicDesc, DicKey = "", DicFilter = "") As %String
{
	new (DicDesc,DicKey,DicFilter)
	Set return=0
	Quit:DicDesc="" return
	Quit:(DicKey="")&&(DicFilter="") return
	For KeyInd=1:1:$l(DicKey,"|") {
		Set DicSubKey=$p(DicKey,"|",KeyInd)
		Continue:DicSubKey=""
		Set:DicDesc[DicSubKey return=1
		Quit:return=1
	}
	//如果有关键字滤除，而没有关键字，默认关键字信息符合。
	Set:DicKey="" return=1
	For FilterInd=1:1:$l(DicFilter,"|") {
		Set DicFSubKey=$p(DicFilter,"|",FilterInd)
		Continue:DicFSubKey=""
		Set:DicDesc[DicFSubKey return=0
		Quit:return=0
	}
	Quit return
}

/// w ##class(DHCMA.CPW.SDS.Stat.StatService).GetAdmDays()
ClassMethod GetAdmDays(aEntityID, xItemCode, MrlistID) As %String
{
	new (aEntityID,xItemCode,MrlistID)
	Set return=""
	Set xEntityItem = ##class(DHCMA.CPW.SD.QCEntityItem).GetObjByVerCode("2",aEntityID,xItemCode)
	Set xItemID=xEntityItem.%Id()
	Set xCode="",xValue=""
	Set xItemValue=..GetItemValue(MrlistID,xItemID)
	Set:xItemValue'="" xCode=$p(xItemValue ,$c(1),1) 
	Set:xItemValue'="" xValue=$p(xItemValue ,$c(1),2)
	Quit:xCode="" return
	if ((xCode["/")||(xCode["-"))&&((xCode[" ")&&(xCode[":")){
		//将各个时间参数换算为小时
		Set thisDate=$p(xCode," ",1)
		Set thisTime=$p(xCode," ",2)
		Set thisLogicDate=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(thisDate)
		Set thisLogicTime=##Class(DHCMA.Util.IO.FromHisSrv).TimeHtmlToLogical(thisTime)
		Set return=(thisLogicDate*86400+thisLogicTime)\(3600*24)
	}elseif ((xCode["-")||(xCode["/")){
		Set return=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(xCode)
	}else{
		Set return=xCode
	}
	Quit return
}

// 单病种医生工作量统计

/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.SDS.Stat.StatService","QryDocWorkData","2!!1","2023-04-01","2023-06-01","","","","2")
Query QryDocWorkData(aHospID As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String, aQCEntityID As %String, aDocID As %String = "", aType As %String = "") As %Query(ROWSPEC = "xID:%String,DishLocDesc:%String,QCEntityName:%String,DocDesc:%String,UserName:%String,StateDate:%String,PatName:%String,Sex:%String,MrNo:%String,PapmiNo:%String,AdmDate:%String,DischDate:%String,tCount:%String") [ SqlProc ]
{
}

ClassMethod QryDocWorkDataExecute(ByRef qHandle As %Binary, aHospID As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String, aQCEntityID As %String, aDocID As %String = "", aType As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
 	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
 	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
 	Set:aDateFrom["/" aDateFrom=$zdh(aDateFrom,4)
 	Set:aDateTo["/" aDateTo=$zdh(aDateTo,4)
 	Set aStatusID=##Class(DHCMA.Util.BTS.DictionarySrv).GetDicIDByCode("SDQCMrStatus","Submit")	//取提交状态
 	b ;0
 	if (aType=1){
	 	//出院时间索引
		Set DischDateIndex=##Class(DHCMA.Util.IO.FromHisSrv).GetDischDateIndex()  //update by pylian 2016-01-21取出院时间索引
	    For xDate=aDateFrom:1:aDateTo {
			Set xPaadm=""
			For {
				Set xPaadm=$o(^PAADMi(DischDateIndex,xDate,xPaadm))
				Quit:xPaadm=""
				b ;1
				Set AdmInfo=$g(^PAADM(xPaadm))
				Continue:$p(AdmInfo,"^",2)'="I"           //就诊类型过滤
				Continue:$p(AdmInfo,"^",20)="C"           //就诊状态过滤
				Set EpisodeID=##class(DHCMA.Util.EPS.OIDService).GetValidOID(xPaadm)
				Set xID=""
				Set xID=$o(^DHCMA.CPW.SD.QCMrListI("IndexEpisodeID",EpisodeID,""),-1)
				Continue:xID=""
				Set obj=##class(DHCMA.CPW.SD.QCMrList).GetObjById(xID)
				Continue:'$IsObject(obj)
				Set QCState=obj.QCState
				Continue:QCState="O"
				Set ECount=obj.ECount		//已填数量
				Set ACount=obj.ACount		//自动采集数量
				Set tCount=+(ECount-ACount)	//手工填报项目数
				Set QCEntity=obj.QCEntityDr
				Continue:'$IsObject(QCEntity)
				Continue:(QCEntity.BTIsActive'=1)
				Set QCEntityID=QCEntity.%Id()
				Continue:(aQCEntityID'="")&&(aQCEntityID'=QCEntityID)
				Set QCEntityName=QCEntity.BTDesc
				
				//Set CurrStatusSubID=$o(^DHCMA.CPW.SD.QCMrListStateI("IndexParref",xID,""),-1)
				Set CurrStatusSubID=$o(^DHCMA.CPW.SD.QCMrListStateI("IndexPState",xID,aStatusID,""),-1)	//取最后一次提交状态的信息
				Set CurrStatusID=xID_"||"_CurrStatusSubID
				Set StatusObj=##class(DHCMA.CPW.SD.QCMrListState).GetObjById(CurrStatusID)	
				Continue:'$IsObject(StatusObj)
				Set StateDate=StatusObj.StateDate	//提交时间
				Set StateDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(StateDate)
				Set StateDoc=StatusObj.StateDoc		//提交人
				Set:StateDoc'["!!" StateDoc=StateDoc_"!!"_1
				Set UserName=""
				Set objUser=##class(DHCMA.Util.EP.SSUser).GetObjByOID(StateDoc)
	 			Set:$IsObject(objUser) UserName=objUser.BTDesc
				
				Set EpisodeID=obj.QCEpisodeID
				Set InLocOID=obj.QCInLocID
				Set xHospID=+$p($g(^CTLOC(($p(InLocOID,"!!",1)))),"^",22)
	 			Continue:(aHospID'="")&&(aHospID'[xHospID)

				Set objPaadm=##class(DHCMA.Util.EPy.EpisodeSrv).GetSynObjByOID(EpisodeID)
				Continue:'$IsObject(objPaadm)
				Set AdmLocID=objPaadm.PAAdmLocID
				Set AdmDocID=objPaadm.PAAdmDocID
				//按当前科室过滤
				Continue:(aLocID'="")&&(aLocID'=AdmLocID)  
				Continue:(aDocID'="")&&(aDocID'=AdmDocID)
				//主管医生
				Set DocDesc=""
				Set objCare=##class(DHCMA.Util.EPx.CareProv).GetObjByOID(AdmDocID)
				Set:$IsObject(objCare) DocDesc=objCare.BTDesc	
				Set DishLocDesc=objPaadm.PAAdmLocDesc	//科室
				Set MrNo=objPaadm.PAMrNo		//病案号
				Set PapmiNo=objPaadm.PAPapmiNo	// 登记号
				Set PatName=objPaadm.PAPatName	//姓名
				Set Sex=objPaadm.PASex			//性别（M男、F女、O其他）
				Set Sex=$Select(Sex="M":"男",Sex="F":"女",1:"其他")
				Set Age=objPaadm.PAAge			//年龄
				Set AdmDate=objPaadm.PAAdmDate	//入院日期
				Set AdmDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
				Set DischDate=objPaadm.PADischDate	//出院日期
				Set DischDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(DischDate)

				Set Data=$lb(xID,DishLocDesc,QCEntityName,DocDesc,UserName,StateDate,PatName,Sex,MrNo,PapmiNo,AdmDate,DischDate,tCount)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1

			}
		}
 	}else{
	 	For xDate=aDateFrom:1:aDateTo {
		 	Set Parref=""
			For {
				Set Parref=$o(^DHCMA.CPW.SD.QCMrListStateI("IndexDateState",xDate,aStatusID,Parref)) 
				Quit:Parref=""
				Set xSubID=$o(^DHCMA.CPW.SD.QCMrListStateI("IndexDateState",xDate,aStatusID,Parref,""),-1) 
				Continue:xSubID=""
				Set obj=##class(DHCMA.CPW.SD.QCMrList).GetObjById(Parref)
				Continue:'$IsObject(obj)
				Set SubObj = ##class(DHCMA.CPW.SD.QCMrListState).GetObjById(Parref_"||"_xSubID)
				Continue:'$IsObject(SubObj)
				Set QCState=obj.QCState
				Continue:QCState="O"
				Set ECount=obj.ECount		//已填数量
				Set ACount=obj.ACount		//自动采集数量
				Set tCount=+(ECount-ACount)	//手工填报项目数
				Set QCEntity=obj.QCEntityDr
				Continue:'$IsObject(QCEntity)
				Continue:(QCEntity.BTIsActive'=1)
				Set QCEntityID=QCEntity.%Id()
				Continue:(aQCEntityID'="")&&(aQCEntityID'=QCEntityID)
				Set QCEntityName=QCEntity.BTDesc
				
				Set StateDate=SubObj.StateDate	//提交时间
				Set StateDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(StateDate)
				Set StateDoc=SubObj.StateDoc		//提交人
				Set:StateDoc'["!!" StateDoc=StateDoc_"!!"_1
				Set UserName=""
				Set objUser=##class(DHCMA.Util.EP.SSUser).GetObjByOID(StateDoc)
	 			Set:$IsObject(objUser) UserName=objUser.BTDesc
				
				Set EpisodeID=obj.QCEpisodeID
				Set InLocOID=obj.QCInLocID
				Set xHospID=+$p($g(^CTLOC(($p(InLocOID,"!!",1)))),"^",22)
	 			Continue:(aHospID'="")&&(aHospID'[xHospID)

				Set objPaadm=##class(DHCMA.Util.EPy.EpisodeSrv).GetSynObjByOID(EpisodeID)
				Continue:'$IsObject(objPaadm)
				Set AdmLocID=objPaadm.PAAdmLocID
				Set AdmDocID=objPaadm.PAAdmDocID
				//按当前科室过滤
				Continue:(aLocID'="")&&(aLocID'=AdmLocID)  
				Continue:(aDocID'="")&&(aDocID'=AdmDocID)
				//主管医生
				Set DocDesc=""
				Set objCare=##class(DHCMA.Util.EPx.CareProv).GetObjByOID(AdmDocID)
				Set:$IsObject(objCare) DocDesc=objCare.BTDesc	
				Set DishLocDesc=objPaadm.PAAdmLocDesc	//科室
				Set MrNo=objPaadm.PAMrNo		//病案号
				Set PapmiNo=objPaadm.PAPapmiNo	// 登记号
				Set PatName=objPaadm.PAPatName	//姓名
				Set Sex=objPaadm.PASex			//性别（M男、F女、O其他）
				Set Sex=$Select(Sex="M":"男",Sex="F":"女",1:"其他")
				Set Age=objPaadm.PAAge			//年龄
				Set AdmDate=objPaadm.PAAdmDate	//入院日期
				Set AdmDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
				Set DischDate=objPaadm.PADischDate	//出院日期
				Set DischDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(DischDate)

				Set Data=$lb(xID,DishLocDesc,QCEntityName,DocDesc,UserName,StateDate,PatName,Sex,MrNo,PapmiNo,AdmDate,DischDate,tCount)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	Quit $$$OK
}

ClassMethod QryDocWorkDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDocWorkDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryDocWorkDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDocWorkDataExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

}
