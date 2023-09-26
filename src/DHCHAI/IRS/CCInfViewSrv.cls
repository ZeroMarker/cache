/// 名称: DHCHAI.IRS.CCInfViewSrv
/// 描述: 感染集成视图相关服务
/// 编写者：zhufei
/// 编写日期: 2017-03-20
Class DHCHAI.IRS.CCInfViewSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2017-03-20
/// Description:  取感染集成视图病人信息
/// Input：       aEpisodeID ：就诊表DHCHAI.DP.PAAdm.ID
/// Return:		  return>0:成功
/// Debug:		  w ##class(DHCHAI.IRS.CCInfViewSrv).GetPatViewInfo(135)
ClassMethod GetPatViewInfo(aEpisodeID As %String) As %String
{
	New (aEpisodeID,%session)
	Set return=""
	Quit:aEpisodeID="" return
	
	Set objPaadm = ##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeID)
	Quit:'$isobject(objPaadm) return
	
	Set EpisodeIDx      = objPaadm.PAEpisodeIDx
	Set SCode           = $p(EpisodeIDx,"||",1)
	Set EpisodeID 		= objPaadm.PAEpisodeIDx
	Set PatientID 		= objPaadm.PAPatientIDx
	Set PapmiNo 		= objPaadm.PAPapmiNo
	Set MrNo 			= objPaadm.PAMrNo
	Set PatName 		= objPaadm.PAPatName
	Set Sex 			= objPaadm.PASex
    Set Sex=$Case(Sex,"M":"男","F":"女",:"")
	Set Nation 			= objPaadm.PANation
	Set Birthday 		= objPaadm.PABirthday
	Set Age 			= objPaadm.PAAge
	
	//Set:Birthday'="" Birthday = $zd(Birthday,3)
	Set:Birthday'="" Birthday=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(Birthday)
	Set IdentityCode 	= objPaadm.PAIdentityCode
	Set HomeAddress 	= objPaadm.PAHomeAddress
	Set Company 		= objPaadm.PACompany
	Set RelativeName 	= objPaadm.PARelativeName
	Set RelativeTel 	= objPaadm.PARelativeTel
	Set IsDeath 		= objPaadm.PAIsDeath
	Set DeathDate 		= objPaadm.PADeathDate
	//Set:DeathDate'="" DeathDate = $zd(DeathDate,3)
	Set:DeathDate'="" DeathDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DeathDate)
	Set DeathTime 		= objPaadm.PADeathTime
	Set:DeathTime'="" DeathTime = $zt(DeathTime)
	Set AdmType 		= objPaadm.PAAdmType
	Set VisitStatus 	= objPaadm.PAVisitStatus
	Set VisitStatusInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"VisitStatus",VisitStatus)
	If VisitStatusInfo'="" {
		Set VisitStatus=$p(VisitStatusInfo,"^",2)
	}
	
	Set AdmDate 		= objPaadm.PAAdmDate
	//Set:AdmDate'="" AdmDate = $zd(AdmDate,3)
	Set:AdmDate'="" AdmDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
	Set AdmTime 		= objPaadm.PAAdmTime
	Set:AdmTime'="" AdmTime = $zt(AdmTime)
	Set objAdmLoc 		= objPaadm.PAAdmLocDr
	Set AdmLocDesc = ""
	Set:$isobject(objAdmLoc) AdmLocDesc = objAdmLoc.BTDesc
	Set:AdmLocDesc["-" AdmLocDesc = $p(AdmLocDesc,"-",2)

	Set objAdmWard 		= objPaadm.PAAdmWardDr
	Set AdmWardDesc = ""
	Set:$isobject(objAdmWard) AdmWardDesc = objAdmWard.BTDesc
	Set:AdmWardDesc["-" AdmWardDesc = $p(AdmWardDesc,"-",2)

	Set AdmRoom 		= objPaadm.PAAdmRoom
	Set (AdmBedDr,AdmBed)=""
	If $IsObject(objPaadm.PAAdmBedDr){
		Set AdmBedDr=objPaadm.PAAdmBedDr.%Id()
		Set AdmBed=objPaadm.PAAdmBedDr.BTDesc
	}
	Set DischDate 		= objPaadm.PADischDate
	//Set:DischDate'="" DischDate = $zd(DischDate,3)
	Set:DischDate'="" DischDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DischDate)
	Set DischTime 		= objPaadm.PADischTime
	Set:DischTime'="" DischTime = $zt(DischTime)
	Set objDischLoc 	= objPaadm.PADischLocDr
	Set DischLocDesc = ""
	Set:$isobject(objDischLoc) DischLocDesc = objDischLoc.BTDesc
	Set:DischLocDesc["-" DischLocDesc = $p(DischLocDesc,"-",2)
	Set objDischWard 	= objPaadm.PADischWardDr
	Set DischWardDesc = ""
	Set:$isobject(objDischWard) DischWardDesc = objDischWard.BTDesc
	Set:DischWardDesc["-" DischWardDesc = $p(DischWardDesc,"-",2)
	Set IsNewBaby 		= objPaadm.PAIsNewBaby
	Set BirthWeight 	= objPaadm.PABirthWeight
	Set AdmitWeight 	= objPaadm.PAAdmitWeight
	//多语言
	Set Sex=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTSEXDesc",Sex,"User.CTSex")
	Set:Age["岁" Age=$Replace(Age,"岁",##class(websys.Translation).Get(" Bill.Com.Age","岁"))
	Set AdmLocDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",AdmLocDesc,"User.CTLoc")
	Set AdmWardDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",AdmWardDesc,"User.CTLoc")
	Set return = EpisodeID_"^"_PatientID_"^"_PapmiNo_"^"_MrNo_"^"_PatName_"^"_Sex_"^"_Nation
	_"^"_Birthday_"^"_Age_"^"_IdentityCode_"^"_HomeAddress_"^"_Company_"^"_RelativeName_"^"_RelativeTel
	_"^"_IsDeath_"^"_DeathDate_"^"_DeathTime_"^"_AdmType_"^"_VisitStatus_"^"_AdmDate_"^"_AdmTime
	_"^"_AdmLocDesc_"^"_AdmWardDesc_"^"_AdmRoom_"^"_AdmBed_"^"_DischDate_"^"_DischTime
	_"^"_DischLocDesc_"^"_DischWardDesc_"^"_IsNewBaby_"^"_BirthWeight_"^"_AdmitWeight
	//诊断
	Set xDiagnosID = "",DiagDesc="",Count=0
	For {
		Set xDiagnosID = $o(^DHCHAI.DP.MRDiagnosI("IndexEpisodeDr",aEpisodeID,xDiagnosID))
		Quit:xDiagnosID=""
		//Quit:Count>2  //去掉诊断只显示前3条的控制
		
		Set objDiagnos = ##class(DHCHAI.DP.MRDiagnos).GetObjById(xDiagnosID)
		Continue:'$isobject(objDiagnos)
		Continue:objDiagnos.MRIsActive'=1
		Continue:objDiagnos.MRDiagSource'="C"  //临床诊断
		
		Set Count = Count+1
		
		Set DiagDesc = DiagDesc_","_objDiagnos.MRDiagDesc
	}
	Set:DiagDesc'="" DiagDesc = $e(DiagDesc,2,$l(DiagDesc))
	Set return = return_"^"_DiagDesc
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-08-04
/// Description:  感染集成视图图标
/// Return：      返回ROWSPEC,代码，图标路径，描述，显示顺序（第二行开始，第一行显示入院天数）
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.CCInfViewSrv","QryInfViewIcon")
Query QryInfViewIcon() As %Query(ROWSPEC = "code:%String,src:%String,desc:%String,index:%String") [ SqlProc ]
{
}

ClassMethod QryInfViewIconExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set Array(2)=$lb("TMP","../scripts/dhchai/img/体温.png",##class(websys.Translation).Get("dhcma.ir.view.summary.csp","发热"))
 	Set Array(3)=$lb("OPER","../scripts/dhchai/img/手术.png",##class(websys.Translation).Get("dhcma.ir.view.summary.csp","手术"))
 	Set Array(4)=$lb("VAP","../scripts/dhchai/img/呼吸机.png",##class(websys.Translation).Get("dhcma.ir.view.summary.csp","呼吸机"))
 	Set Array(5)=$lb("PICC","../scripts/dhchai/img/静脉插管.png",##class(websys.Translation).Get("dhcma.ir.view.summary.csp","中央血管导管"))
 	Set Array(6)=$lb("UC","../scripts/dhchai/img/导尿管.png",##class(websys.Translation).Get("dhcma.ir.view.summary.csp","导尿管"))
 	Set Array(7)=$lb("BUG","../scripts/dhchai/img/细菌.png",##class(websys.Translation).Get("dhcma.ir.view.summary.csp","细菌"))
 	Set Array(8)=$lb("MDR","../scripts/dhchai/img/多重耐药菌.png",##class(websys.Translation).Get("dhcma.ir.view.summary.csp","多重耐药菌"))
 	Set Array(9)=$lb("ISO","../scripts/dhchai/img/隔离医嘱.png",##class(websys.Translation).Get("dhcma.ir.view.summary.csp","隔离医嘱"))
 	Set Array(10)=$lb("VIRUS","../scripts/dhchai/img/virus.png",##class(websys.Translation).Get("dhcma.ir.view.summary.csp","病毒"))
 	Set Array(11)=$lb("RBT","../scripts/dhchai/img/血常规.png",##class(websys.Translation).Get("dhcma.ir.view.summary.csp","血常规"))
 	Set Array(12)=$lb("RUT","../scripts/dhchai/img/尿常规.png",##class(websys.Translation).Get("dhcma.ir.view.summary.csp","尿常规"))
 	Set Array(13)=$lb("ROT","../scripts/dhchai/img/其他常规.png",##class(websys.Translation).Get("dhcma.ir.view.summary.csp","其他常规"))
 	Set Array(14)=$lb("RIS","../scripts/dhchai/img/影像.png",##class(websys.Translation).Get("dhcma.ir.view.summary.csp","影像"))
 	Set Array(15)=$lb("HAI","../scripts/dhchai/img/院感报告.png",##class(websys.Translation).Get("dhcma.ir.view.summary.csp","院感报告"))
 	Set xIndex= 0
 	For {
		Set xIndex = $o(Array(xIndex))
		Quit:xIndex=""
		
		Set code = $listget(Array(xIndex),1) 
		Set src = $listget(Array(xIndex),2)
		Set desc = $listget(Array(xIndex),3)
		Set Data=$lb(code,src,desc,xIndex)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	kill Array
	Quit $$$OK
}

ClassMethod QryInfViewIconClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfViewIconExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInfViewIconFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfViewIconExecute ]
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

/// Creator：     liyi
/// CreatDate：   2017-08-04
/// Description:  感染集成视图表头数据
/// Input：       aEpisodeID ：就诊表DHCHAI.DP.PAAdm.ID
/// 			  aColumnCount ：前台计算的表格列数
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.CCInfViewSrv","QryInfViewTitle","296","60",1)
Query QryInfViewTitle(aEpisodeID As %String, aColumnCount As %String, aCurrNo As %String = "1") As %Query(ROWSPEC = "DateShow:%String,DateIndex:%String,TransFlag:%String,AdmLoc:%String,AdmWard:%String,AdmDays:%String,TransLoc:%String,TransWard:%String,TransBed:%String,FXSum:%String") [ SqlProc ]
{
}

ClassMethod QryInfViewTitleExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aColumnCount As %String, aCurrNo As %String = "1") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
	Quit:(aEpisodeID="")||(aColumnCount="") $$$OK
	//Set aCurrNo = 1
	//数据不够时自动填满aColumnCount天数
	Set rCount =0
	Set objPaadm = ##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeID)
	Quit:'$isobject(objPaadm) $$$OK
	
	// 转科（转科记录）
	Kill arrTransLoc
	Set xDate=0
	For {
		Set xDate=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDrTransDate","E",aEpisodeID,xDate))
		Quit:xDate=""
		
		Set xTransID=0
		For {
			Set xTransID=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDrTransDate","E",aEpisodeID,xDate,xTransID))
			Quit:xTransID=""
			
			Set objTrans=##class(DHCHAI.DP.PAAdmTrans).GetObjById(xTransID)
			Continue:'$IsObject(objTrans)
			Continue:'$IsObject(objTrans.PATransLocDr)
			Set objLoc=objTrans.PATransLocDr
			Set LocID=objLoc.%Id()
			Set LocDesc=objLoc.BTDesc
			Set LocDesc2=objLoc.BTDesc2
			Set:LocDesc2'="" LocDesc=LocDesc2
			Set TransDate=objTrans.PATransDate
			Set TransTime=objTrans.PATransTime
			Set:TransDate'="" TransDate=$zd(TransDate,3)
			Set:TransTime'="" TransTime=$zt(TransTime,1)
			Set arrTransLoc(TransDate_" "_TransTime)=$lb(xTransID,LocDesc)
		}
	}
	// 转床（转科记录）
	Kill arrTransBed
	Set xDate=0
	For {
		Set xDate=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDrTransDate","B",aEpisodeID,xDate))
		Quit:xDate=""
		
		Set xTransID=0
		For {
			Set xTransID=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDrTransDate","B",aEpisodeID,xDate,xTransID))
			Quit:xTransID=""
			
			Set objTrans=##class(DHCHAI.DP.PAAdmTrans).GetObjById(xTransID)
			Continue:'$IsObject(objTrans)
			Continue:'$IsObject(objTrans.PATransLocDr)
			Continue:'$IsObject(objTrans.PATransBedDr)
			Set objLoc=objTrans.PATransLocDr
			Set LocID=objLoc.%Id()
			Set LocDesc=objLoc.BTDesc
			Set LocDesc2=objLoc.BTDesc2
			Set:LocDesc2'="" LocDesc=LocDesc2
			Set Bed=objTrans.PATransBedDr.BTDesc
			Set:Bed'["床" Bed=Bed_"床"
			Set TransDate=objTrans.PATransDate
			Set TransTime=objTrans.PATransTime
			Set:TransDate'="" TransDate=$zd(TransDate,3)
			Set:TransTime'="" TransTime=$zt(TransTime,1)
			Set arrTransBed(TransDate_" "_TransTime)=$lb(xTransID,LocDesc,Bed)
		}
	}
	
 	Set AdmDate = objPaadm.PAAdmDate
 	Set DischDate = objPaadm.PADischDate
 	Set StartDate = AdmDate
 	Set EndDate = $s(DischDate'="":DischDate,1:+$h)		//没有出院当天未最后日期
 	// 在院天数小于传入的默认天数，采用默认天数计算
 	Set ColumnCount = $s((EndDate-StartDate+1)>aColumnCount:EndDate-StartDate+1,1:aColumnCount)
 	Set:(DischDate="")&((EndDate-StartDate+1)<aColumnCount) EndDate =StartDate+aColumnCount
 	Set AdmDays = 0
 	Set:((EndDate-StartDate)#aColumnCount)'=0 allNo =((EndDate-StartDate)\aColumnCount)+1
 	Set:((EndDate-StartDate)#aColumnCount)=0 allNo =((EndDate-StartDate)\aColumnCount)
    Set:allNo=0 allNo=1    //最少应有一页
 	Quit:aCurrNo>allNo $$$OK
 	For xDate = StartDate:1:StartDate+ColumnCount-1{
	 	Set DateShow = $e($zd(xDate,8),5,8)
	 	Set DateIndex = xDate
	 	
		//住院科室及床位以23:59:59所在科室和床位为准
	 	if ((DischDate'="")&(xDate>DischDate))||((DischDate="")&(xDate>(+$h))){
		 	Set AdmLoc=""
		 	Set AdmWard=""
		 	Set AdmBed=""
		 	Set TransLoc=""
		 	Set TransWard=""
		 	Set TransBed=""
		 	Set TransFlag=""
		} Else {
		 	Set TransFlag=0
		 	
			//转科
			Set PrevTransLoc="",TransLoc=""
			Set tTransDT=$o(arrTransLoc($zd(xDate,3)_" "_"00:00:01"),-1)
			If tTransDT="" {
			 	Set TransFlag=TransFlag+1
				Set tTransDT=$o(arrTransLoc($zd(xDate,3)_" "_"00:00:01"))
				Set:$p(tTransDT," ",1)'=$zd(xDate,3) tTransDT=""
			}
			If tTransDT'="" {
				Set TransLocInfo=$g(arrTransLoc(tTransDT))
				Set PrevTransLoc=$listget(TransLocInfo,2)
			}
			Set tTransDT=$o(arrTransLoc($zd(xDate,3)_" "_"23:59:59"),-1)
			If tTransDT'="" {
				Set TransLocInfo=$g(arrTransLoc(tTransDT))
				Set TransLoc=$listget(TransLocInfo,2)

			}
			
			//转床
			Set PrevTransBed="",PrevTransWard="",TransBed="",TransWard=""
			Set tTransDT=$o(arrTransBed($zd(xDate,3)_" "_"00:00:01"),-1)
			If tTransDT="" {
			 	Set TransFlag=TransFlag+2
				Set tTransDT=$o(arrTransBed($zd(xDate,3)_" "_"00:00:01"))
				Set:$p(tTransDT," ",1)'=$zd(xDate,3) tTransDT=""
			}
			If tTransDT'="" {
				Set TransBedInfo=$g(arrTransBed(tTransDT))
				Set PrevTransWard=$listget(TransBedInfo,2)
				Set PrevTransBed=PrevTransWard_"("_$listget(TransBedInfo,3)_")"
			}
			Set tTransDT=$o(arrTransBed($zd(xDate,3)_" "_"23:59:59"),-1)
			If tTransDT'="" {
				Set TransBedInfo=$g(arrTransBed(tTransDT))
				Set TransWard=$listget(TransBedInfo,2)
				Set TransBed=TransWard_"("_$listget(TransBedInfo,3)_")"
			}
			Set AdmLoc=PrevTransLoc
			Set AdmWard=PrevTransWard
		 	Set TransLoc=TransLoc
			//多语言
			Set TransLoc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",TransLoc,"User.CTLoc")
		 	Set TransWard=TransWard
		 	//多语言
			Set TransWard=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",TransWard,"User.CTLoc")
		 	Set TransBed=TransBed
		 	If PrevTransLoc'=TransLoc {
			 	Set TransFlag=TransFlag+1
			}
		 	If PrevTransWard'=TransWard {
			 	Set TransFlag=TransFlag+2
			}
		}
		
		If (DischDate'=""){
			If (xDate<=DischDate){
				Set AdmDays = AdmDays +1
			}else{
				Set AdmDays = ""
			}
		}else{
			If (+$h)>=xDate {
				Set AdmDays = AdmDays +1
			}else{
				Set AdmDays = ""
			}
		}
		Continue:xDate<(EndDate-(aColumnCount*aCurrNo))		//显示只显示60天 根据传入的参数控制输出内容		
		//Continue:xDate>(EndDate-(aColumnCount*(+aCurrNo-1)))
		Set rCount=rCount+1
		Continue:(rCount>aColumnCount)	
		Set FXSum=0
		Set xSCode=""
		For {
			Set xSCode=$o(^DHCHAI.DP.MRObservationsI("IndexEpisodeItemDescDate",aEpisodeID,xSCode))
			Quit:xSCode=""
			
			Set xItemDesc=""
			For {
				Set xItemDesc=$o(^DHCHAI.DP.MRObservationsI("IndexEpisodeItemDescDate",aEpisodeID,xSCode,xItemDesc))
				Quit:xItemDesc=""
				
				//根据体温筛查“腹泻”项目
				Set objOBSIM=##class(DHCHAI.DP.MROBSItemMap).GetObjByItemDesc(xSCode,xItemDesc)
				Continue:'$IsObject(objOBSIM)
				Continue:'$IsObject(objOBSIM.BTMapItemDr)
				Set OBSItemCat=objOBSIM.BTMapItemDr.BTCatDr
				Continue:'$IsObject(OBSItemCat)
				Set LabType=OBSItemCat.BTDesc
				Continue:(LabType'="大便次数")
				
				Set xObID=$o(^DHCHAI.DP.MRObservationsI("IndexEpisodeItemDescDate",aEpisodeID,xSCode,xItemDesc,xDate,""))
				Set objMRObs=##class(DHCHAI.DP.MRObservations).GetObjById(xObID)
				Continue:'$IsObject(objMRObs)
				Set IsActive=objMRObs.OBIsActive
				Continue:IsActive'=1
				Set tmpFXSum=+objMRObs.OBItemValue    //结果
				Set:tmpFXSum'="0" FXSum=tmpFXSum
			}
		}
	 	Set Data=$lb(DateShow,DateIndex,TransFlag,AdmLoc,AdmWard,AdmDays,TransLoc,TransWard,TransBed,FXSum)
 		Set ^CacheTemp(repid,ind)=Data
 		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryInfViewTitleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfViewTitleExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInfViewTitleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfViewTitleExecute ]
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

/// Creator：     zhufei
/// CreatDate：   2017-03-20
/// Description:  感染集成视图查询结果（抗生素特殊处理）
/// Table：       DHCHAI.IR.CCResult、DHCHAI.DP.MRObservations、DHCHAI.DP.OEAntiUse、DHCHAI.DP.OEOrdItem、DHCHAI.DP.OROperation
/// Input：       aEpisodeID ：就诊表DHCHAI.DP.PAAdm.ID
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.CCInfViewSrv","QryInfViewResult","86380")
Query QryInfViewResult(aEpisodeID As %String) As %Query(ROWSPEC = "IVDate:%String,IVItemCode:%String,IVFlag:%String,IVResult:%String,IVRows:%String,IVDateType:%String") [ SqlProc ]
{
}

ClassMethod QryInfViewResultExecute(ByRef qHandle As %Binary, aEpisodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:aEpisodeID="" $$$OK
 	
	Set ZIndex=$zn,JIndex=$j
	Kill ^TMP(ZIndex,JIndex,"QryInfViewResult")
	//发热
	Set xOBSIMMapID=""
	For {
		Set xOBSIMMapID = $o(^DHCHAI.DP.MROBSItemMapD(xOBSIMMapID))
		Quit:xOBSIMMapID=""
		
		Set objOBSIMMap = ##class(DHCHAI.DP.MROBSItemMap).GetObjById(xOBSIMMapID)
		Continue:'$isobject(objOBSIMMap)
		Continue:objOBSIMMap.BTIsActive'=1
		Continue:'$isobject(objOBSIMMap.BTMapItemDr)
		Continue:'$isobject(objOBSIMMap.BTMapItemDr.BTCatDr)
		Continue:(objOBSIMMap.BTMapItemDr.BTCatDr.BTDesc'="体温")
		
		Set ItemDesc = objOBSIMMap.BTItemDesc
		//多语言
		Set ItemDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTItemDesc",ItemDesc,"DHCHAI.DP.MROBSItemMap")
		Continue:ItemDesc=""
		
		Set xSCode = ""
		For {
			Set xSCode = $o(^DHCHAI.DP.MRObservationsI("IndexEpisodeItemDescDate",aEpisodeID,xSCode))
			Quit:xSCode=""
			
			Set xEntryDate=""
			For {
				Set xEntryDate = $o(^DHCHAI.DP.MRObservationsI("IndexEpisodeItemDescDate",aEpisodeID,xSCode,ItemDesc,xEntryDate))
				Quit:xEntryDate=""
				
				Set xMRObsID = ""
				For {
					Set xMRObsID = $o(^DHCHAI.DP.MRObservationsI("IndexEpisodeItemDescDate",aEpisodeID,xSCode,ItemDesc,xEntryDate,xMRObsID),-1)  //倒序查找体温，一个时刻多个体温，取最后一个
					Quit:xMRObsID=""
					
					Set objMRObs = ##class(DHCHAI.DP.MRObservations).GetObjById(xMRObsID)
					Continue:'$isobject(objMRObs)
					Continue:objMRObs.OBIsActive'=1
					Set ItemValue=objMRObs.OBItemValue    //结果
					Continue:ItemValue=""    //发热标准
					Set IsFever=##class(DHCHAI.IRS.CRuleOBSSrv).CheckIsFever(objMRObs)
					Continue:IsFever<1  //检查发热规则（不同科室、不同年龄可能不同）
					
					
					Set EntryDate = xEntryDate
					Set:EntryDate'="" EntryDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(EntryDate)
					Set EntryTime = objMRObs.OBEntryTime
					Set:EntryTime'="" EntryTime=$zt(EntryTime)
					
					//过滤一个时刻多余数据
					Continue:($d(^TMP(ZIndex,JIndex,"QryInfViewResult","TMP",EntryDate,EntryTime)))
					Set ^TMP(ZIndex,JIndex,"QryInfViewResult","TMP",EntryDate,EntryTime)=""
				
					Set Result = ItemDesc_"："_ItemValue_"℃ "_EntryDate_" "_EntryTime
					Set ^TMP(ZIndex,JIndex,"QryInfViewResult","TMP",xEntryDate,1,"Result")=$g(^TMP(ZIndex,JIndex,"QryInfViewResult","TMP",xEntryDate,1,"Result"))_"^"_Result
				}
			}
		}
	}
	// 呼吸机,静脉插管,导尿管,隔离医嘱
	Set VAPOrdList="",PICCOrdList="",ISOOrdList="",UCOrdList="",AntGenericList=""
	Set CODOrdList="" //请会诊医嘱
	Set xItmMastMapD=""
	For {
		Set xItmMastMapD = $o(^DHCHAI.DP.OEItmMastMapD(xItmMastMapD))
		Quit:xItmMastMapD=""
		
		Set objTtmMastMap = ##class(DHCHAI.DP.OEItmMastMap).GetObjById(xItmMastMapD)
		
		Continue:'$isobject(objTtmMastMap)
		Continue:'$isobject(objTtmMastMap.BTMapItemDr)
		Continue:'$isobject(objTtmMastMap.BTMapItemDr.BTCatDr)
		
		Set OrdDesc = objTtmMastMap.BTOrdDesc
		If objTtmMastMap.BTMapItemDr.BTCatDr.BTDesc="呼吸机辅助插管"{
			Set VAPOrdList = VAPOrdList_$lb(OrdDesc)
		}
		If objTtmMastMap.BTMapItemDr.BTCatDr.BTDesc="中央血管导管"{
			Set PICCOrdList = PICCOrdList_$lb(OrdDesc)
		}
		If objTtmMastMap.BTMapItemDr.BTCatDr.BTDesc="泌尿道插管"{
			Set UCOrdList = UCOrdList_$lb(OrdDesc)
		}
		If objTtmMastMap.BTMapItemDr.BTCatDr.BTDesc="隔离医嘱"{
			Set ISOOrdList = ISOOrdList_$lb(OrdDesc)
		}
		If objTtmMastMap.BTMapItemDr.BTCatDr.BTDesc="院内会诊"{
			Set CODOrdList = CODOrdList_$lb(OrdDesc)
		}
	}
	Set xOrdItemID =""
	For {
		Set xOrdItemID = $o(^DHCHAI.DP.OEOrdItemI("IndexEpisodeDr",aEpisodeID,xOrdItemID))
		Quit:xOrdItemID=""
		
		Set objOrdItem = ##class(DHCHAI.DP.OEOrdItem).GetObjById(xOrdItemID)
		Continue:'$isobject(objOrdItem)
		Continue:objOrdItem.OEIsActive=0	// 无效医嘱
		
		Set OrdDesc 	= objOrdItem.OEOrdDesc
	    Set OrdDesc=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(OrdDesc)  //add 20230211 去掉特殊字符，医嘱项对照界面医嘱名称做了处理
		
		Set Priority	= objOrdItem.OEPriority
		Set AntDrgPoison = objOrdItem.OEAntDrgPoison
		Set:AntDrgPoison="" AntDrgPoison="KSS1"
		Set SttDate = objOrdItem.OESttDate
		Set EndDate	= objOrdItem.OEXDate
		Set UsePurpose = objOrdItem.OEAntUsePurpose
	    Set IsCure=0
	    Set:UsePurpose["治疗" IsCure=1
	    
		Set DisDate=objOrdItem.OEEpisodeDr.PADischDate	//出院日期
		If EndDate="" {
			If Priority["长期" {
				if DisDate=""{
					Set EndDate = +$h	// 未出院无停止日期
				}else{
					Set EndDate=DisDate
				}
			} Else {
				Set EndDate=SttDate
			}
		}
		//多语言处理
		Set OrdDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("ARCIMDesc",OrdDesc,"User.ARCItmMast")
		Set Priority=##Class(DHCHAI.Abstract).HAIGetTranByDesc("OECPRDesc",Priority,"User.OECPriority")
		Set UsePurpose=##Class(DHCHAI.Abstract).HAIGetTranByDesc("PDCValue",UsePurpose,"DHCAnt.Base.PurposeDataConfig")
		
		If $listfind(VAPOrdList,OrdDesc)
		||$listfind(PICCOrdList,OrdDesc)
		||$listfind(UCOrdList,OrdDesc)
		||$listfind(ISOOrdList,OrdDesc)
		||$listfind(CODOrdList,OrdDesc) {
			For xDate = SttDate:1:EndDate{
				If $listfind(VAPOrdList,OrdDesc){	//VAP 呼吸机
					Set Result = OrdDesc_"【"_Priority_"】"
					Set ^TMP(ZIndex,JIndex,"QryInfViewResult","VAP",xDate,1,"Result") =  $g(^TMP(ZIndex,JIndex,"QryInfViewResult","VAP",xDate,1,"Result"))_"^"_Result
				}
				If $listfind(PICCOrdList,OrdDesc){	//PICC 中心静脉置管
					Set Result = OrdDesc_"【"_Priority_"】"
					Set ^TMP(ZIndex,JIndex,"QryInfViewResult","PICC",xDate,1,"Result") =  $g(^TMP(ZIndex,JIndex,"QryInfViewResult","PICC",xDate,1,"Result"))_"^"_Result
				}
				If $listfind(UCOrdList,OrdDesc){	//UC 导尿管
					Set Result = OrdDesc_"【"_Priority_"】"
					Set ^TMP(ZIndex,JIndex,"QryInfViewResult","UC",xDate,1,"Result") =  $g(^TMP(ZIndex,JIndex,"QryInfViewResult","UC",xDate,1,"Result"))_"^"_Result
				}
				If $listfind(ISOOrdList,OrdDesc){	//ISO 隔离医嘱
					Set Result = OrdDesc_"【"_Priority_"】"
					Set ^TMP(ZIndex,JIndex,"QryInfViewResult","ISO",xDate,1,"Result") =  $g(^TMP(ZIndex,JIndex,"QryInfViewResult","ISO",xDate,1,"Result"))_"^"_Result
				}
				If $listfind(CODOrdList,OrdDesc){	//COD 请会诊医嘱
					Set Result = OrdDesc_"【"_Priority_"】"
					Set ^TMP(ZIndex,JIndex,"QryInfViewResult","COD",xDate,1,"Result") =  $g(^TMP(ZIndex,JIndex,"QryInfViewResult","COD",xDate,1,"Result"))_"^"_Result
				}
			}
		}
		If objOrdItem.OEAntUseFlag{		//抗生素（一个通用名显示一行）
			Set Generic = objOrdItem.OEGeneric
			Continue:Generic=""
			
			Set:'$listfind(AntGenericList,Generic) AntGenericList = AntGenericList_$lb(Generic)
			Set Rows = $listfind(AntGenericList,Generic)
			For xDate = SttDate:1:EndDate{
				Set Result = OrdDesc_"【"_Priority_"】"_" "_##class(websys.Translation).Get("dhcma.ir.view.summary.csp","用药目的")_"："_UsePurpose_"|"_AntDrgPoison_"|"_IsCure
				Set ^TMP(ZIndex,JIndex,"QryInfViewResult","ANT",xDate,Rows,"Result") =  $g(^TMP(ZIndex,JIndex,"QryInfViewResult","ANT",xDate,Rows,"Result"))_"^"_Result
			}
		}
	}
	// 血常规【RBT】、尿常规【RUT】、其他常规【ROT】（便常规、脑脊液常规、腹水常规、胸水常规、C反应蛋白、降钙素原）
	Set KeyWordList = $lb("血常规","尿常规","便常规","脑脊液常规","腹水常规","胸水常规","C反应蛋白","降钙素原")
	Set xItemID=0
	For {
		Set xItemID=$o(^DHCHAI.IR.CCResultI("IndexItemDrKeyWordDr",aEpisodeID,xItemID))
		Quit:xItemID=""
		
		Set objItmMast=##class(DHCHAI.IR.CCItmMast).GetObjById(xItemID)
		Continue:'$IsObject(objItmMast)
		Continue:objItmMast.CCCode'="LAB-TestAb"  //检验-常规检验异常
		
		Set xKeyWordDr=""
		For {
			Set xKeyWordDr=$o(^DHCHAI.IR.CCResultI("IndexItemDrKeyWordDr",aEpisodeID,xItemID,xKeyWordDr))
			Quit:xKeyWordDr=""
			
			Set objKeyWord=##class(DHCHAI.IR.CCKeyWord).GetObjById(xKeyWordDr)
			Continue:'$IsObject(objKeyWord)
			Set KeyWord=objKeyWord.CCDesc
			//多语言
			Set KeyWord=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CCDesc",KeyWord," DHCHAI.IR.CCKeyWord")
			Set TestSetCat=""
			Set objTestSet=##class(DHCHAI.DP.LabTestSet).GetObjByCodeDesc("",KeyWord)
			If ($IsObject(objTestSet)) {
				If ($IsObject(objTestSet.BTCatDr)) {
					Set TestSetCat=objTestSet.BTCatDr.BTDesc
				}
			}
			Continue:('$listfind(KeyWordList,KeyWord))&&(TestSetCat'="生化免疫检测")  	//update 20211129  病毒支原体检测修改为生化免疫检测
			
			Set ItemCode = $s(KeyWord="血常规":"RBT",KeyWord="尿常规":"RUT",1:"ROT")
			Set:TestSetCat="生化免疫检测" ItemCode="VIRUS"
			Set xID=0
			For {
				Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemDrKeyWordDr",aEpisodeID,xItemID,xKeyWordDr,xID))
				Quit:xID=""
				
				Set obj=##class(DHCHAI.IR.CCResult).GetObjById(xID)
				Continue:'$IsObject(obj)
				Continue:'$IsObject(obj.CCEpisodeDr)
				Continue:'$IsObject(obj.CCItemDr)
				Continue:obj.CCIsActive'=1
				
				Set SCode	 =	obj.CCSCode
				Set Specimen =	obj.CCSpecimen
				Set objMapSpec=##class(DHCHAI.DP.LabSpecMap).GetStanSpecByDesc(SCode,Specimen)
				If $IsObject(objMapSpec){
					Set Specimen=objMapSpec.BTSpecDesc
					//多语言
					Set Specimen=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTSpecDesc",Specimen," DHCHAI.DP.LabSpecMap")
				}
				Set ActDate	 = obj.CCActDate
				Set RepDate = obj.CCRepDate
				Set Params = obj.CCParams
				Continue:ActDate=""
				Continue:Params=""
				
				Set RstID = $p(Params,"=",2)
				Set objRst=##class(DHCHAI.DP.LabVisitRepResult).GetObjById(RstID)
				Continue:'$IsObject(objRst)
				
				Set LabResult=objRst.LabResult		// 结果
				Continue:LabResult=""
				
				Set TextRes = objRst.LabTextRes	// 定性结果
				Set Unit = objRst.LabUnit			// 单位
				Set AbFlag = objRst.LabAbFlag		// 异常标记
				Set TestDesc = objRst.LabTestDesc
				//多语言
				
				If (ItemCode="VIRUS"){
					Set Result = KeyWord_"："_TestDesc_" "_LabResult_"【"_Specimen_"】"
				}Else{
					Set Result = KeyWord_"："_TestDesc_" "_LabResult_"（"_Unit_"）【"_Specimen_"】"
				}
				Set tActDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
				Set tRepDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RepDate)
				Set Result=Result_##class(websys.Translation).Get("dhcma.ir.view.summary.csp"," 送检日期")_":"_tActDate_##class(websys.Translation).Get("dhcma.ir.view.summary.csp"," 报告日期")_":"_tRepDate
			
				Set ^TMP(ZIndex,JIndex,"QryInfViewResult",ItemCode,ActDate,1,"Result") =  $g(^TMP(ZIndex,JIndex,"QryInfViewResult",ItemCode,ActDate,1,"Result"))_"^"_Result
				If (ActDate'=RepDate) {
					Set ^TMP(ZIndex,JIndex,"QryInfViewResult",ItemCode,RepDate,2,"Result") =  $g(^TMP(ZIndex,JIndex,"QryInfViewResult",ItemCode,RepDate,2,"Result"))_"^"_Result
				}
				
			}
		}
	}
	// 细菌、多耐
	Set xItemID=0
	For {
		Set xItemID=$o(^DHCHAI.IR.CCResultI("IndexItemDrBacteria",aEpisodeID,xItemID))
		Quit:xItemID=""
		
		Set objItmMast=##class(DHCHAI.IR.CCItmMast).GetObjById(xItemID)
		Continue:'$IsObject(objItmMast)
		Continue:objItmMast.CCCode'="LAB-Bacteria"  //检验-检出菌
		
		Set xBacteria=""
		For {
			Set xBacteria=$o(^DHCHAI.IR.CCResultI("IndexItemDrBacteria",aEpisodeID,xItemID,xBacteria))
			Quit:xBacteria=""
			Continue:$l(xBacteria)<2 //表示菌为空
			
			Set xID=0
			For {
				Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemDrBacteria",aEpisodeID,xItemID,xBacteria,xID))
				Quit:xID=""
				
				Set obj=##class(DHCHAI.IR.CCResult).GetObjById(xID)
				Continue:'$IsObject(obj)
				Continue:'$IsObject(obj.CCEpisodeDr)
				Continue:'$IsObject(obj.CCItemDr)
				Continue:obj.CCIsActive'=1
				
				Set SCode=obj.CCSCode
				Set Bacteria=obj.CCBacteria
				Set objBactMap=##class(DHCHAI.DP.LabBactMap).GetObjByBacteria(SCode,Bacteria)
				If $IsObject(objBactMap){
					Continue:objBactMap.BTIsActive'=1
					If $IsObject(objBactMap.BTMapItemDr){
						Set Bacteria=objBactMap.BTMapItemDr.BTBacDesc
						//多语言
						Set Bacteria=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTBacDesc",Bacteria,"DHCHAI.DP.LabBacteria")						
					}
				}
				Continue:Bacteria=""  //细菌
				
				Set Specimen=obj.CCSpecimen
				Set objStanSpec=##class(DHCHAI.DP.LabSpecMap).GetStanSpecByDesc(SCode,Specimen)
				If $IsObject(objStanSpec){
					Set Specimen=objStanSpec.BTSpecDesc
					//多语言
					Set Specimen=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTSpecDesc",Specimen," DHCHAI.DP.LabSpecMap")
				}
				Set ActDate=obj.CCActDate
				Set RepDate = obj.CCRepDate
				Set ObjectID=obj.CCObjectID
				Continue:ActDate=""
				
				//多耐
				Set MRBTypeID="",MRBTypeDesc=""
				If $IsObject(obj.CCMRBTpDr) {
					Set MRBTypeID=obj.CCMRBTpDr.%Id()
					Set MRBTypeDesc=obj.CCMRBTpDr.BTDesc
				}
				
				If MRBTypeID'="" {
					Set ItemCode = "MDR"
					Set Result = Bacteria_"("_##class(websys.Translation).Get("dhcma.ir.view.summary.csp","多耐")_")【"_Specimen_"】"
				}else{
					Set ItemCode = "BUG"
					Set Result = Bacteria_"【"_Specimen_"】"
				}
				
				Set tActDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
				Set tRepDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RepDate)
				Set Result=Result_##class(websys.Translation).Get("dhcma.ir.view.summary.csp"," 送检日期")_":"_tActDate_##class(websys.Translation).Get("dhcma.ir.view.summary.csp"," 报告日期")_":"_tRepDate
			
				Set ^TMP(ZIndex,JIndex,"QryInfViewResult",ItemCode,ActDate,1,"Result") =  $g(^TMP(ZIndex,JIndex,"QryInfViewResult",ItemCode,ActDate,1,"Result"))_"^"_Result
				If (ActDate'=RepDate) {
					Set ^TMP(ZIndex,JIndex,"QryInfViewResult",ItemCode,RepDate,2,"Result") =  $g(^TMP(ZIndex,JIndex,"QryInfViewResult",ItemCode,RepDate,2,"Result"))_"^"_Result
				}
			}
		}
	}
	/*细菌送检阴性展示-add by chenjb 20220728 ITemCode=BUG值为3*/
    Set aCatCode="1"		//检验大类 1=菌培养
    Set aTestSetDr=""	//检验子类 细菌检测 真菌检测 镜检	
	//循环标本表
	Set xVisitNumberDr=""
	For {
		Set xVisitNumberDr=$o(^DHCHAI.DP.LabVisitNumberI("IndexEpisodeDr",aEpisodeID,xVisitNumberDr))
		Quit:xVisitNumberDr=""
		
		Set objVisitNumber=##class(DHCHAI.DP.LabVisitNumber).GetObjById(xVisitNumberDr)
		Continue:'$isobject(objVisitNumber)
		Continue:objVisitNumber.LabIsActive'=1
		
		Set CollDate=objVisitNumber.LabCollDate		//采集日期
		Set CollTime=objVisitNumber.LabCollTime
		
		Set RecDate=objVisitNumber.LabRecDate		//接收日期
		Set RecTime=objVisitNumber.LabRecTime
		
		Set CollDate=$s(CollDate'="":CollDate,1:RecDate)		//送检日期优先用采集日期
		Set CollTime=$s(CollTime'="":CollTime,1:RecTime)
		
		Set SCode	 	= objVisitNumber.LabSCode		//LIS01
		Set EpisodeNo 	= objVisitNumber.LabEpisodeNo	//检验号|标本号
		Set Specimen 	= objVisitNumber.LabSpecimen	//标本名称[血.....]
		//多语言
		
		Set BacteriaBZ =""                              //送检结果菌全部为阴才算
		Set AuthDate =""                                //报告日期
		// 循环检验医嘱表[检查送检记录是否是(检出菌、常规检验、PCT（降钙素原）、CRP（C反应蛋白）、G试验、M试验)]
		Set OrdListDesc=""	//检验医嘱名称
		Set RAuthDate="",RCollDate=""
		Set LabResults="" 
		Set xTestSetDesc="",checkFlg=0,IsCom=0
		For {
			Set xTestSetDesc=$o(^DHCHAI.DP.LabVisitTestSetI("IndexVisitNumberTestSet",xVisitNumberDr,xTestSetDesc))
			Quit:xTestSetDesc=""
			//多语言
			
			Set OrdListDesc=OrdListDesc_"+"_xTestSetDesc
			
			Set xID =""
			For {
				Set xID=$o(^DHCHAI.DP.LabVisitTestSetI("IndexVisitNumberTestSet",xVisitNumberDr,xTestSetDesc,xID))
				Quit:xID=""
				Set LabVisitTestData=$g(^DHCHAI.DP.LabVisitTestSetD(xID))
				Continue:LabVisitTestData=""
				Set ComSetCode =$lg(LabVisitTestData,7)		
				Set:ComSetCode'="" IsCom=1			//合管检验医嘱代码
			}
			Continue:'$d(^DHCHAI.DP.LabTestSetMapI("IndexSCodeTestSet",SCode,xTestSetDesc))		//排除未对照医嘱
			//对照后检验医嘱
			Set TestSetMapID=$o(^DHCHAI.DP.LabTestSetMapI("IndexSCodeTestSet",SCode,xTestSetDesc,""))
			Set objTestSetMap=##class(DHCHAI.DP.LabTestSetMap).GetObjById(TestSetMapID)
			Continue:'$isobject(objTestSetMap)
			Continue:'$isobject(objTestSetMap.BTMapItemDr)
			Continue:'$isobject(objTestSetMap.BTMapItemDr.BTCatDr)
			Set CatCode=objTestSetMap.BTMapItemDr.BTCatDr.BTCode
			Continue:(aCatCode'="")&&(aCatCode'=CatCode)
			Set checkFlg =1			
		}
		
		//循环检验报告表
		Set xTestSetDr=""
		For {
			Set xTestSetDr=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",xVisitNumberDr,xTestSetDr))
			Quit:xTestSetDr=""
			
			//最新检验报告
			Set xOrder = $o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",xVisitNumberDr,xTestSetDr,""),-1)
			Set xVisitReportDr=0
			For {
				Set xVisitReportDr=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",xVisitNumberDr,xTestSetDr,xOrder,xVisitReportDr))
				Quit:xVisitReportDr=""
				
				If (checkFlg=0) {  			//检查检验项目是否存在于检验结果中
					Set xTestCode=""
					For {
						Set xTestCode=$o(^DHCHAI.DP.LabVisitRepResultI("IndexLabTCCode",xVisitReportDr,xTestCode))
						Quit:xTestCode=""
						Quit:checkFlg=1
						//循环检验项目对照表
						Set xMapItemDr=0
						For {
							Set xMapItemDr= $o(^DHCHAI.DP.LabTCMapI("IndexMapCodeDr",xTestCode,xMapItemDr))
							Quit:xMapItemDr=""
							
							Continue:(aTestSetDr'="")&&(xMapItemDr'=aTestSetDr)		//过滤检验子类[血常规,尿常规....]						
							Set objTSMapItem=##class(DHCHAI.DP.LabTestSet).GetObjById(xMapItemDr)	//标准医嘱
							Continue:'$isobject(objTSMapItem)
							Continue:'$isobject(objTSMapItem.BTCatDr)	
							Set CatCode=objTSMapItem.BTCatDr.BTCode
							Continue:(aCatCode'="")&&(aCatCode'=CatCode)	//过滤检验大类[细菌检测,常规,病毒]
							
							Set checkFlg=1
							Quit
						}
					}
				}
				Continue:checkFlg=0
				
				Set objVisitReport=##class(DHCHAI.DP.LabVisitReport).GetReportByID(xVisitReportDr)
				Continue:'$IsObject(objVisitReport)
				
				Set IsActive = objVisitReport.LabIsActive
				Continue:IsActive=0
								
				Set VisitReportID = objVisitReport.%Id()
				Set AuthDate=objVisitReport.LabAuthDate
				Set AuthTime=objVisitReport.LabAuthTime
				//Set:AuthDate'="" AuthDate=$zd(AuthDate,3)
				
				Set:AuthDate'="" RAuthDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AuthDate)
				Set:CollDate'="" RCollDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(CollDate)
				Set objVisitTestSet=objVisitReport.LabTestSetDr
				Continue:'$IsObject(objVisitTestSet)
				
				Set CollDateR=CollDate
				Set AuthDateR=AuthDate
				
				
				Set xReusltID = ""				
				For {
					Set xReusltID = $o(^DHCHAI.DP.LabVisitRepResultI("IndexLabReportDr",VisitReportID,xReusltID))
					Quit:xReusltID=""
					
					Set objResult = ##class(DHCHAI.DP.LabVisitRepResult).GetObjById(xReusltID)
					Continue:'$IsObject(objResult)
					
					// 细菌
					Set RstFormat   = objResult.LabRstFormat   
					If (RstFormat="M") {     //结果类型为细菌
						Set Bacteria   = objResult.LabResult
						Set objBactMap = ##class(DHCHAI.DP.LabBactMap).GetObjByBacteria(SCode,Bacteria)
						Continue:'$isobject(objBactMap)
						Continue:objBactMap.BTIsActive=0
						Continue:'$isobject(objBactMap.BTMapItemDr)
						Set BacteriaID = objBactMap.BTMapItemDr.%Id()
						Set BacteriaBZ = objBactMap.BTMapItemDr.BTBacDesc  //标准菌名称	
					}Else {   //结果写在培养结果中，文本结果或列表结果等
						Set Result   = objResult.LabResult
						Continue:(Result'["菌")
						Continue:(Result["正常")&(Result["生长")
						Continue:(Result["无")&(Result["生长")
						Continue:(Result["未检出")
						Continue:(Result["未见")
						Set LabResults=LabResults_","_Result
					}									
				}				
			}
			Continue:BacteriaBZ'=""
			Continue:AuthDate=""
			
			If (LabResults'="") {
				Set LabResults=$e(LabResults,2,$l(LabResults))
				Set Result = LabResults_"【"_Specimen_"】"
				Set Result=Result_##class(websys.Translation).Get("dhcma.ir.view.summary.csp"," 送检日期")_":"_RCollDate_##class(websys.Translation).Get("dhcma.ir.view.summary.csp"," 报告日期")_":"_RAuthDate
				Set ItemCode="BUG"
				Set ^TMP(ZIndex,JIndex,"QryInfViewResult",ItemCode,CollDate,1,"Result") =  $g(^TMP(ZIndex,JIndex,"QryInfViewResult",ItemCode,CollDate,1,"Result"))_"^"_Result
				If (CollDate'=AuthDate) {
					Set ^TMP(ZIndex,JIndex,"QryInfViewResult",ItemCode,AuthDate,2,"Result") =  $g(^TMP(ZIndex,JIndex,"QryInfViewResult",ItemCode,AuthDate,2,"Result"))_"^"_Result
				}
			}Else {
			//Set ^TMP(ZIndex,JIndex,"QryInfViewResult",ItemCode,ActDate,1,"Result") =  $g(^TMP(ZIndex,JIndex,"QryInfViewResult",ItemCode,ActDate,1,"Result"))_"^"_Result
			Set:OrdListDesc'="" OrdListDesc=$e(OrdListDesc,2,$l(OrdListDesc))
			Set Result = OrdListDesc_"【"_Specimen_"("_##class(websys.Translation).Get("dhcma.ir.view.summary.csp","阴性")_")】"
			Set Result=Result_##class(websys.Translation).Get("dhcma.ir.view.summary.csp"," 送检日期")_":"_RCollDate_##class(websys.Translation).Get("dhcma.ir.view.summary.csp"," 报告日期")_":"_RAuthDate
			Set ItemCode="BUG"
				Set ^TMP(ZIndex,JIndex,"QryInfViewResult",ItemCode,CollDate,3,"Result") =  $g(^TMP(ZIndex,JIndex,"QryInfViewResult",ItemCode,CollDate,3,"Result"))_"^"_Result
			}
		}
	}
	// 放射
	Set xResultID = ""
	For {
		Set xResultID = $o(^DHCHAI.IR.CCResultI("IndexEpisodeDr",aEpisodeID,xResultID))
		Quit:xResultID=""
		
		Set objResult =##class(DHCHAI.IR.CCResult).GetObjById(xResultID)
		Continue:'$isobject(objResult)
		Continue:objResult.CCIsActive'=1
		
		Set objCCItem 	= objResult.CCItemDr
		Continue:'$IsObject(objCCItem)
		Continue:objCCItem.CCCode'="RME-Radiology"  // 语义-放射学检查
		
		Set objKeyWord 	= objResult.CCKeyWordDr
		Set Result 		= objResult.CCResult
		Set ActDate 	= objResult.CCRepDate  //报告日期 update by zf 20190327
		Continue:ActDate=""
		Continue:Result=""
		
		Continue:objResult.CCObjectID=""
		// 视图增加显示检查医嘱项目
		Set ObjRBRep = ##class(DHCHAI.DP.RBReport).GetObjById(objResult.CCObjectID)
		Continue:'$isobject(ObjRBRep)
		Continue:ObjRBRep.RBIsActive'=1
		
		Set CheckItem = ObjRBRep.RBCheckItem
				
		Set ItemCode = "RIS"
		Set ^TMP(ZIndex,JIndex,"QryInfViewResult",ItemCode,ActDate,1,"Result")=$g(^TMP(ZIndex,JIndex,"QryInfViewResult",ItemCode,ActDate,1,"Result"))_"^"_CheckItem_"："_Result
	}
	// 院感报告
	Set xRepType = ""
	For {
		Set xRepType = $o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,xRepType))
		Quit:xRepType=""
		
		Continue:xRepType'=1	//医院感染报告
		Set xReportID =""
		For {
			Set xReportID = $o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,xRepType,xReportID))
			Quit:xReportID=""
			
			Set objReport = ##class(DHCHAI.IR.INFReport).GetObjById(xReportID)
			Continue:'$isobject(objReport)
			Set tRepDate = objReport.IRRepDate
			Continue:tRepDate=""
			Set RepDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(tRepDate)
			Set objStatus  = objReport.IRStatusDr
			Set StatusCode=""
			If $IsObject(objStatus){
				Set StatusCode = objStatus.BTCode
			}
			Continue:(StatusCode=4)  //作废状态不显示
			Set DiagDesc = ""
			Set arrInfDiag=objReport.GetRepLinkObjs("DHCHAI.IR.INFDiagnos")
			Continue:arrInfDiag.Count()<1
			For indD=1:1:arrInfDiag.Count() {
				Set objDiag=arrInfDiag.GetAt(indD)
				Continue:'$IsObject(objDiag)
				Continue:'$isobject(objDiag.IRInfPosDr)
				Set tInfDate=objDiag.IRInfDate
				Set tDiagDesc=objDiag.IRInfPosDr.BTDesc
				//多语言
				Set tDiagDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",tDiagDesc," DHCHAI.BT.InfPos")
				
				Continue:tDiagDesc=""
				Continue:tInfDate=""
				
				Set InfDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(tInfDate)
				Set tDiagDesc=tDiagDesc_##class(websys.Translation).Get("dhcma.ir.view.summary.csp"," 感染日期")_":"_InfDate_"|"_xReportID
			
				Set ^TMP(ZIndex,JIndex,"QryInfViewResult","HAI",tInfDate,1,"Result") =  $g(^TMP(ZIndex,JIndex,"QryInfViewResult","HAI",tInfDate,1,"Result"))_"^"_tDiagDesc
				If (StatusCode=3) {					
					Set tDiagDesc=$p(tDiagDesc,"|",1)_##class(websys.Translation).Get("dhcma.ir.view.summary.csp"," 报告日期")_":"_RepDate_"|"_$p(tDiagDesc,"|",2)
					Set ^TMP(ZIndex,JIndex,"QryInfViewResult","HAI",tRepDate,3,"Result") =  $g(^TMP(ZIndex,JIndex,"QryInfViewResult","HAI",tRepDate,3,"Result"))_"^"_tDiagDesc
				   
				}
			}
			Continue:DiagDesc=""
		}
	}
	// 手术（手麻数据）
	Set xDate = ""
	For {
		Set xDate = $o(^DHCHAI.DP.OROperAnaesI("IndexEpisodeDrOperDate",aEpisodeID,xDate))
		Quit:xDate=""
		
		Set xOperID =""
		For {
			Set xOperID = $o(^DHCHAI.DP.OROperAnaesI("IndexEpisodeDrOperDate",aEpisodeID,xDate,xOperID))
			Quit:xOperID=""
			
			Set objOper = ##class(DHCHAI.DP.OROperAnaes).GetObjById(xOperID)
			Continue:'$isobject(objOper)
			Continue:objOper.ORIsActive'=1
			Set OperDesc = objOper.OROperDesc
			Set OperType = objOper.OROperType
			Set ORIncision = objOper.ORIncision
			Set OROperDate = objOper.OROperDate
			Set:OROperDate'="" OROperDate= $zd(OROperDate,3)
			Set ORSttTime = objOper.ORSttTime
			Set:ORSttTime'="" ORSttTime=$zt(ORSttTime,1)
			Set OREndDate = objOper.OREndDate
			Set:OREndDate'="" OREndDate= $zd(OREndDate,3)
			Set OREndTime = objOper.OREndTime
			Set:OREndTime'="" OREndTime=$zt(OREndTime,1)
			Set OperDateTime=OROperDate_" "_ORSttTime_"~"_OREndDate_" "_OREndTime
			Set ORHealing = objOper.ORHealing
			
			Set Result = OperDesc_"【"_OperType_"】&#10;"_OperDateTime_"&#10;"_##class(websys.Translation).Get("dhcma.ir.view.summary.csp","切口等级")_":"_ORIncision_##class(websys.Translation).Get("dhcma.ir.view.summary.csp"," 愈合情况")_": "_ORHealing
			
			Set ^TMP(ZIndex,JIndex,"QryInfViewResult","OPER",xDate,1,"Result") =  $g(^TMP(ZIndex,JIndex,"QryInfViewResult","OPER",xDate,1,"Result"))_"^"_Result
		}
	}
	
	// 输出数据
	Set xItemCode = ""
	For {
		Set xItemCode = $o(^TMP(ZIndex,JIndex,"QryInfViewResult",xItemCode))
		Quit:xItemCode=""
		
		Set xDate = ""
		For {
			Set xDate = $o(^TMP(ZIndex,JIndex,"QryInfViewResult",xItemCode,xDate))
			Quit:xDate=""
			
			If xItemCode="ANT"{
				Set xRows =""
				For {
					Set xRows =  $o(^TMP(ZIndex,JIndex,"QryInfViewResult",xItemCode,xDate,xRows))
					Quit:xRows=""
					
					Set Result = $g(^TMP(ZIndex,JIndex,"QryInfViewResult",xItemCode,xDate,xRows,"Result"))
					Continue:Result=""
					
					Set Result = $e(Result,2,$length(Result))
					Set Data = $lb(xDate,xItemCode,1,Result,xRows+1)
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}else{
				Set xType = 0
				For {
					Set xType= $o(^TMP(ZIndex,JIndex,"QryInfViewResult",xItemCode,xDate,xType))
					Quit:xType=""
					
					Set Result = $g(^TMP(ZIndex,JIndex,"QryInfViewResult",xItemCode,xDate,xType,"Result"))
					Continue:Result=""
					Set Result = $e(Result,2,$length(Result))
					
					Set Data = $lb(xDate,xItemCode,1,Result,"",xType)
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
		}
	}
	Kill ^TMP(ZIndex,JIndex,"QryInfViewResult")
	Quit $$$OK
}

ClassMethod QryInfViewResultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfViewResultExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInfViewResultFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfViewResultExecute ]
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

/// Creator：     liyi
/// CreatDate：   2017-08-008
/// Description:  感染视图明细
/// Table：       数据池、监控结果
/// Input：       aEpisodeID ：就诊表DHCHAI.DP.PAAdm.ID
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.CCInfViewSrv","QryInfViewDetail","101","2020-01-01","2021-11-22")
Query QryInfViewDetail(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "ActDate:%String,DiagStr:%String,TreatStr:%String") [ SqlProc ]
{
}

ClassMethod QryInfViewDetailExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %Status
{
	new (qHandle,aEpisodeID,aDateFrom,aDateTo,%session)
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
	//Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	//Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Quit:(aEpisodeID="")||(aDateFrom="")||(aDateTo="") $$$OK
	
	Kill arrQryInfViewDetail
	// 体温异常
	Set xOBSIMMapID=""
	For {
		Set xOBSIMMapID = $o(^DHCHAI.DP.MROBSItemMapD(xOBSIMMapID))
		Quit:xOBSIMMapID=""
		
		Set objOBSIMMap = ##class(DHCHAI.DP.MROBSItemMap).GetObjById(xOBSIMMapID)
		Continue:'$isobject(objOBSIMMap)
		Continue:objOBSIMMap.BTIsActive'=1
		Continue:'$isobject(objOBSIMMap.BTMapItemDr)
		Continue:'$isobject(objOBSIMMap.BTMapItemDr.BTCatDr)
		Set CatDesc=objOBSIMMap.BTMapItemDr.BTCatDr.BTDesc
		Continue:((CatDesc'="体温")&&(CatDesc'="大便次数"))
		
		Set ItemDesc=objOBSIMMap.BTItemDesc
		Continue:ItemDesc=""
		
		Set xSCode=""
		For {
			Set xSCode=$o(^DHCHAI.DP.MRObservationsI("IndexEpisodeItemDescDate",aEpisodeID,xSCode))
			Quit:xSCode=""
			
			Set xEntryDate=""
			For {
				Set xEntryDate=$o(^DHCHAI.DP.MRObservationsI("IndexEpisodeItemDescDate",aEpisodeID,xSCode,ItemDesc,xEntryDate))
				Quit:xEntryDate=""
				Continue:(xEntryDate<aDateFrom)||(xEntryDate>aDateTo)
				
				
				Set PriorDate=""
				Set PriorTime=""
				
				Set xMRObsID=""
				For {
					Set xMRObsID=$o(^DHCHAI.DP.MRObservationsI("IndexEpisodeItemDescDate",aEpisodeID,xSCode,ItemDesc,xEntryDate,xMRObsID),-1)  //倒序查找体温，一个时刻多个体温，取最后一个
					Quit:xMRObsID=""
					
					Set objMRObs=##class(DHCHAI.DP.MRObservations).GetObjById(xMRObsID)
					Continue:'$isobject(objMRObs)
					Continue:objMRObs.OBIsActive'=1
					Set ItemValue=objMRObs.OBItemValue
					Continue:ItemValue=""
					If (CatDesc="体温"){
						Set IsFever=##class(DHCHAI.IRS.CRuleOBSSrv).CheckIsFever(objMRObs)
						Continue:IsFever<1  //检查发热规则（不同科室、不同年龄可能不同）
						
						//过滤一个时刻多余数据
						if ((PriorDate=objMRObs.OBEntryDate)&(PriorTime=objMRObs.OBEntryTime))
						{
							continue
						}
						Set PriorDate=objMRObs.OBEntryDate
						Set PriorTime=objMRObs.OBEntryTime
						
						Set tResult=$g(arrQryInfViewDetail(xEntryDate,"OBS"))
						If tResult'="" {
							Set tResult=tResult_";"_ItemValue_"℃ "
						} Else {
							Set tResult=##class(websys.Translation).Get("dhcma.ir.view.summary.csp","体温")_"："_ItemValue_"℃ "
						}
						Set arrQryInfViewDetail(xEntryDate,"OBS")=tResult
					}Else{ // 腹泻次数
						Continue:(+ItemValue)<1
						Set tResult=$g(arrQryInfViewDetail(xEntryDate,"FXT"))
						If tResult'="" {
							Set tResult=tResult_";"_ItemValue_" "
						} Else {
							Set tResult=##class(websys.Translation).Get("dhcma.ir.view.summary.csp","大便次数")_"："_ItemValue_" "
						}
						Set arrQryInfViewDetail(xEntryDate,"FXT")=tResult
					}
				}
			}
		}
	}
	
	// 常规检验（血常规、尿常规、便常规、脑脊液常规、腹水常规、胸水常规）
	Set xItemID=0
	For {
		Set xItemID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeID,xItemID))
		Quit:xItemID=""
		
		Set objItmMast=##class(DHCHAI.IR.CCItmMast).GetObjById(xItemID)
		Continue:'$IsObject(objItmMast)
		Continue:objItmMast.CCCode'="LAB-TestAb"  //检验-常规检验异常
		
		Set xActDate=aDateFrom-1
		For {
			Set xActDate=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeID,xItemID,xActDate))
			Quit:xActDate=""
			Quit:xActDate>aDateTo
			
			Set xID=0
			For {
				Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeID,xItemID,xActDate,xID))
				Quit:xID=""
				
				Set obj=##class(DHCHAI.IR.CCResult).GetObjById(xID)
				Continue:'$IsObject(obj)
				Continue:'$IsObject(obj.CCEpisodeDr)
				Continue:'$IsObject(obj.CCItemDr)
				Continue:obj.CCIsActive'=1
				Set ActDate=obj.CCActDate
				Continue:ActDate=""
				Continue:(ActDate<aDateFrom)||(ActDate>aDateTo)
				
				Set KeyWord=""
				If $IsObject(obj.CCKeyWordDr) {
					Set KeyWord=obj.CCKeyWordDr.CCDesc
					//多语言
					Set KeyWord=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CCDesc",KeyWord," DHCHAI.IR.CCKeyWord")
				}
				Set SCode=obj.CCSCode
				Set Specimen=obj.CCSpecimen
				Set objMapSpec=##class(DHCHAI.DP.LabSpecMap).GetStanSpecByDesc(SCode,Specimen)
				If $IsObject(objMapSpec){
					Set Specimen=objMapSpec.BTSpecDesc
					//多语言
					Set Specimen=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTSpecDesc",Specimen," DHCHAI.DP.LabSpecMap")
				}
				Else{
				    //多语言
				    //Set Specimen=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CCSpecimen",Specimen," DHCHAI.IR.CCResult")
					
				}
				Set TextRes=obj.CCTextRes
				Set Result=obj.CCResult
				Set IsAbFlag=obj.CCIsAbFlag
				Continue:IsAbFlag'=1
				// add by liyi 修复bug：501136，TestDesc未定义
				Set CCParams=obj.CCParams
				Set LabRstID = $p(obj.CCParams,"=",2)
				Set objLabRst = ##class(DHCHAI.DP.LabVisitRepResult).GetObjById(LabRstID)
				Continue:'$IsObject(objLabRst)
				Set TestDesc = objLabRst.LabTestDesc
				//多语言
				//Set TestDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("LabTestDesc",TestDesc," DHCHAI.DP.LabVisitRepResult")
				Set tResult=$g(arrQryInfViewDetail(ActDate,"LIS"))
				If tResult'="" {
					Set tResult=tResult_"<br>"_KeyWord_"："_TestDesc_" "_Result_"（"_Specimen_"）"
				} Else {
					Set tResult=KeyWord_"："_TestDesc_" "_Result_"（"_Specimen_"）"
				}
				Set arrQryInfViewDetail(ActDate,"LIS")=tResult
			}
		}
	}
	
	// 放射检查
	Set xItemID=0
	For {
		Set xItemID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeID,xItemID))
		Quit:xItemID=""
		
		Set objItmMast=##class(DHCHAI.IR.CCItmMast).GetObjById(xItemID)
		Continue:'$IsObject(objItmMast)
		Continue:objItmMast.CCCode'="RME-Radiology"  // 语义-放射学检查
		
		Set xActDate=aDateFrom-1
		For {
			Set xActDate=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeID,xItemID,xActDate))
			Quit:xActDate=""
			Quit:xActDate>aDateTo
			
			Set xID=0
			For {
				Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeID,xItemID,xActDate,xID))
				Quit:xID=""
				
				Set objResult=##class(DHCHAI.IR.CCResult).GetObjById(xID)
				Continue:'$isobject(objResult)
				Continue:objResult.CCIsActive'=1
				Set ActDate=objResult.CCRepDate  //报告日期 update by zf 20190327
				Continue:ActDate=""
				Set Result=objResult.CCResult
				
				Continue:objResult.CCObjectID=""
				// 视图增加显示检查医嘱项目
				Set ObjRBRep = ##class(DHCHAI.DP.RBReport).GetObjById(objResult.CCObjectID)
				Continue:'$isobject(ObjRBRep)
				Continue:ObjRBRep.RBIsActive'=1
				
				Set CheckItem = ObjRBRep.RBCheckItem
				
				Set tResult=$g(arrQryInfViewDetail(ActDate,"RIS"))
				If tResult'="" {
					Set tResult=tResult_"；"_CheckItem_"："_Result
				} Else {
					Set tResult=##class(websys.Translation).Get("dhcma.ir.view.summary.csp","影像学")_"："_CheckItem_"："_Result
				}
				Set arrQryInfViewDetail(ActDate,"RIS")=tResult
			}
		}
	}
	
	// 手术记录
	Set xDate=aDateFrom-1
	For {
		Set xDate=$o(^DHCHAI.DP.OROperAnaesI("IndexEpisodeDrOperDate",aEpisodeID,xDate))
		Quit:xDate=""
		Quit:xDate>aDateTo
		
		Set xOperID=""
		For {
			Set xOperID=$o(^DHCHAI.DP.OROperAnaesI("IndexEpisodeDrOperDate",aEpisodeID,xDate,xOperID))
			Quit:xOperID=""
			
			Set objOper=##class(DHCHAI.DP.OROperAnaes).GetObjById(xOperID)
			Continue:'$isobject(objOper)
			Continue:objOper.ORIsActive'=1
			Set OperDate=objOper.OROperDate
			Continue:OperDate=""
			
			Set OperDesc = objOper.OROperDesc
			Set OperType = objOper.OROperType
			
			Set tResult=$g(arrQryInfViewDetail(OperDate,"OPS"))
			If tResult'="" {
				Set tResult=tResult_";"_OperDesc_"（"_OperType_"）"
			} Else {
				Set tResult=##class(websys.Translation).Get("dhcma.ir.view.summary.csp","手术")_"："_OperDesc_"（"_OperType_"）"
			}
			Set arrQryInfViewDetail(OperDate,"OPS")=tResult
		}
	}
	
	// 抗菌用药、器械相关治疗
	Set DisDate=""  //出院日期
	Set xID=""
	For {
		Set xID=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisodeDr",aEpisodeID,xID))
		Quit:xID=""
		
		Set objOrdItem=##class(DHCHAI.DP.OEOrdItem).GetObjById(xID)
		Continue:'$IsObject(objOrdItem)
		Continue:objOrdItem.OEIsActive=0	// 无效医嘱
		//出院日期
		Set:DisDate="" DisDate=objOrdItem.OEEpisodeDr.PADischDate
		
		Set SCode   = objOrdItem.OESCode
		Set OrdType = objOrdItem.OEOrdType
		Set OrdDesc = objOrdItem.OEOrdDesc
		Set Priority= objOrdItem.OEPriority
		Set SttDate = objOrdItem.OESttDate
		Set EndDate	= objOrdItem.OEXDate
		If EndDate="" {
			If Priority["长期" {
				Set EndDate=DisDate
				Set:EndDate="" EndDate=$p($h,",",1)   //长期医嘱未停止，没有出院日期，截止日期记为当前日期
			} Else {
				Set EndDate=SttDate
			}
		}
		If OrdType="R" {
			//药品医嘱
			Continue:objOrdItem.OEAntUseFlag'=1
			Set Generic=objOrdItem.OEGeneric
			Set Result=Generic
			Set:Result="" Result=OrdDesc
			Set:Priority["长期" Result=Result_"（"_##class(websys.Translation).Get("dhcma.ir.view.summary.csp","长期")_"）"
			For xDate=SttDate:1:EndDate {
				Continue:(xDate<aDateFrom)||(xDate>aDateTo)
				
				Set tResult=$g(arrQryInfViewDetail(xDate,"OE-ANT"))
				If tResult'="" {
					Set tResult=tResult_";"_Result
				} Else {
					Set tResult=##class(websys.Translation).Get("dhcma.ir.view.summary.csp","抗菌用药")_"："_Result
				}
				Set arrQryInfViewDetail(xDate,"OE-ANT")=tResult
			}
		} Else {
			//非药品医嘱
			Set objItmMap=##class(DHCHAI.DP.OEItmMastMap).GetObjByOrdDesc(SCode,OrdDesc)
			Continue:'$IsObject(objItmMap)
			Continue:'$IsObject(objItmMap.BTMapItemDr)
			Continue:'$IsObject(objItmMap.BTMapItemDr.BTCatDr)
			Continue:'$IsObject(objItmMap.BTMapItemDr.BTCatDr.BTTypeDr)
			Set TypeCode=objItmMap.BTMapItemDr.BTCatDr.BTTypeDr.BTCode
			Continue:(TypeCode'="DRT") //器械相关治疗
			
			Set Result=OrdDesc
			Set:Priority["长期" Result=Result_"（"_##class(websys.Translation).Get("dhcma.ir.view.summary.csp","长期")_"）"
			For xDate=SttDate:1:EndDate {
				Continue:(xDate<aDateFrom)||(xDate>aDateTo)
				
				Set tResult=$g(arrQryInfViewDetail(xDate,"OE-DRT"))
				If tResult'="" {
					Set tResult=tResult_";"_Result
				} Else {
					Set tResult=##class(websys.Translation).Get("dhcma.ir.view.summary.csp","器械相关治疗")_"："_Result
				}
				Set arrQryInfViewDetail(xDate,"OE-DRT")=tResult
			}
		}
	}
	
	// 病程
	Set xItemID=0
	For {
		Set xItemID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeID,xItemID))
		Quit:xItemID=""
		
		Set objItmMast=##class(DHCHAI.IR.CCItmMast).GetObjById(xItemID)
		Continue:'$IsObject(objItmMast)
		Continue:objItmMast.CCCode'="RME-Symptom"  // 语义-症状或体征
		
		Set xActDate=aDateFrom-1
		For {
			Set xActDate=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeID,xItemID,xActDate))
			Quit:xActDate=""
			Quit:xActDate>aDateTo
			
			Set xID=0
			For {
				Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeID,xItemID,xActDate,xID))
				Quit:xID=""
				
				Set objResult=##class(DHCHAI.IR.CCResult).GetObjById(xID)
				Continue:'$isobject(objResult)
				Continue:objResult.CCIsActive'=1
				Set ActDate=objResult.CCActDate
				Continue:ActDate=""
				Set Result=objResult.CCResult
				
				Set tResult=$g(arrQryInfViewDetail(ActDate,"EMR"))
				If tResult'="" {
					Set tResult=tResult_"；"_Result
				} Else {
					Set tResult=##class(websys.Translation).Get("dhcma.ir.view.summary.csp","病程")_"："_Result
				}
				Set arrQryInfViewDetail(ActDate,"EMR")=tResult
			}
		}
	}

	Set xDate=""
	For {
		Set xDate=$o(arrQryInfViewDetail(xDate),-1)
		Quit:xDate=""
		
		Set OBS=$g(arrQryInfViewDetail(xDate,"OBS"))
		Set FXT=$g(arrQryInfViewDetail(xDate,"FXT"))
		Set LIS=$g(arrQryInfViewDetail(xDate,"LIS"))
		Set RIS=$g(arrQryInfViewDetail(xDate,"RIS"))
		Set EMR=$g(arrQryInfViewDetail(xDate,"EMR"))
		
		Set OPS=$g(arrQryInfViewDetail(xDate,"OPS"))
		Set OEDRT=$g(arrQryInfViewDetail(xDate,"OE-DRT"))
		Set OEANT=$g(arrQryInfViewDetail(xDate,"OE-ANT"))
		
		//Set ActDate=$zd(xDate,3)
		Set ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(xDate)
		Set DiagStr=""
		
		Set:OBS'="" DiagStr=DiagStr_"<br>"_OBS
		Set:FXT'="" DiagStr=DiagStr_"<br>"_"<font color='red'>"_FXT_"</font>"
		Set:LIS'="" DiagStr=DiagStr_"<br>"_"<font color='red'>"_LIS_"</font>"
		Set:RIS'="" DiagStr=DiagStr_"<br>"_"<font color='red'>"_RIS_"</font>"
		Set:EMR'="" DiagStr=DiagStr_"<br>"_EMR
		Set:DiagStr'="" DiagStr=$e(DiagStr,5,$l(DiagStr))
		
		Set TreatStr=""
		Set:OPS'="" TreatStr=TreatStr_"<br>"_"<font color='red'>"_OPS_"</font>"
		Set:OEDRT'="" TreatStr=TreatStr_"<br>"_"<font color='red'>"_OEDRT_"</font>"
		Set:OEANT'="" TreatStr=TreatStr_"<br>"_OEANT
		Set:TreatStr'="" TreatStr=$e(TreatStr,5,$l(TreatStr))
		
		Set Data=$lb(ActDate,DiagStr,TreatStr)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Kill arrQryInfViewDetail
	Quit $$$OK
}

ClassMethod QryInfViewDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfViewDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInfViewDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfViewDetailExecute ]
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
