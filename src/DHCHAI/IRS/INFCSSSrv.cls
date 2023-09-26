/// 名称: DHCHAI.IRS.INFCSSSrv
/// 描述: 横断面调查相关服务
/// 编写者：pylian
/// 编写日期: 2017-08-11
Class DHCHAI.IRS.INFCSSSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2018-12-24 
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.INFCSSSrv","QryCSSInfPos","1","")
Query QryCSSInfPos(aSurNumID As %String, aLocModel As %String) As %Query(ROWSPEC = "InfPosDesc:%String,PosInfSum:%Integer") [ SqlProc ]
{
}

ClassMethod QryCSSInfPosExecute(ByRef qHandle As %Binary, aSurNumID As %String, aLocModel As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aSurNumID="") $$$OK
	Set objSExec = ##class(DHCHAI.IR.SurveyExec).GetObjById(aSurNumID)
	Quit:'$IsObject(objSExec) $$$OK
 	Set aDateFrom 	= objSExec.SESurvSttDate    //通过调查定义表取开始结束日期
 	Set aDateTo 	= objSExec.SESurvEndDate
 	Set SurNumber = objSExec.SESurvNumber	//
 	Quit:'$IsObject(objSExec.SEHospDr) $$$OK
 	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(objSExec.SEHospDr.%Id(),"|")
 	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
    
    Set NIndex="QryCSSInfPos"
	Kill ^TMP($zn,$j,NIndex)
    //重要：判断标准都是以时间为准，在科期间 框定感染日期是否在期间，并未结束的
    
    //同期在科:某段时间的在科人数
    Set ListLocArray=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransEpisByLocDate(aDateFrom,aDateTo,"E","","I")
    For index1=1:1:ListLocArray.Count() {
		Set TransInfo=ListLocArray.GetAt(index1)	
		Continue:TransInfo=""
		
		Set Date   = $LIST(TransInfo,1)
		Set Paadm  = $LIST(TransInfo,2)
		Set Status = $LIST(TransInfo,3)			
		Set LocID  = $LIST(TransInfo,4)	
		Set TansID = $LIST(TransInfo,5)
		Continue:(Status="I")                 // 当天转入不算在内
		//Continue:(Status="A2")              // 当天转入当天转出不算在内
		//未调查
		Continue:'$d(^DHCHAI.IR.INFCSSI("IndexSurEpisodeID"," "_aSurNumID,Paadm))
		Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(LocID)
		Continue:'$IsObject(objLoc)
		// 医院过滤
		Continue:'$IsObject(objLoc.BTHospDr)
		Continue:(aHospIDs'="")&&($listfind(aHospIDs,objLoc.BTHospDr.%Id())<1)	
		// 避免重复获取感染部位
		Set InfPosDescs=""
		If '$d(^TMP($zn,$j,NIndex,"Hosp","InfFlg",Paadm))
		{
			Set InfPosDescs =##class(DHCHAI.STAT.S410CssInf).GetCurrInfPosInfo(Paadm,aDateFrom,aDateTo)
		}
		Set ^TMP($zn,$j,NIndex,"Hosp","InfFlg",Paadm)=""
		If (InfPosDescs'="") {
			For i=1:1:$l(InfPosDescs,"|") {
				Set InfPoss=$p(InfPosDescs,"|",i)
				Set InfPosDesc = $p(InfPoss,"^",2)
				Continue:InfPosDesc=""
				Set num=+$g(^TMP($zn,$j,NIndex,"Pos",InfPosDesc))
				Set ^TMP($zn,$j,NIndex,"Pos",InfPosDesc)=num+1
			}
		}
	}

	// 输出Data
	Set xPos=""
	For {
		Set xPos=$o(^TMP($zn,$j,NIndex,"Pos",xPos))
		Quit:xPos=""
		Set InfPosDesc = xPos
		Set PosInfSum  = +$g(^TMP($zn,$j,NIndex,"Pos",InfPosDesc))
		Set Data=$lb(InfPosDesc,PosInfSum)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryCSSInfPosClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCSSInfPosExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCSSInfPosFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCSSInfPosExecute ]
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

/// Creator：     zhoubo
/// CreatDate：   2019-07-01
/// Description:  根据调查编号同步电子病历横断面调查数据
/// Return：      处理报告数 特需：1209   急诊：229
/// w ##class(DHCHAI.IRS.INFCSSSrv).SyncCSSRepByDate("1","1209")
ClassMethod SyncCSSRepByDate(aSurNumID As %String, aLocID As %String) As %String
{
	New (aSurNumID,aLocID)
	Set return=0,Count=0
	Quit:aSurNumID="" return
	Set objSExec = ##class(DHCHAI.IR.SurveyExec).GetObjById(aSurNumID)
	Quit:'$IsObject(objSExec) return
 	Set aDateFrom = objSExec.SESurvSttDate    //通过调查定义表取开始结束日期
 	Set aDateTo   = objSExec.SESurvEndDate
    Set objLoc=##class(DHCHAI.BT.Location).GetObjById(aLocID)
	Quit:'$IsObject(objLoc) return
	Quit:'$IsObject(objLoc.BTCateDr) return
	Set CateCode=objLoc.BTCateDr.BTCode
	Set NIndex="SyncCSSRepByDate"
	Kill ^TMP($zn,$j,NIndex)
 	//某段日期的在科人数
 	If (CateCode="E"){
 		Set RstEpisArr = ##class(DHCHAI.DPS.PAAdmTransSrv).GetTransEpisByLocDate(aDateFrom,aDateTo,"E",aLocID,"EP") 
 	}Else{
 		Set RstEpisArr = ##class(DHCHAI.DPS.PAAdmTransSrv).GetTransEpisByLocDate(aDateFrom,aDateTo,"E",aLocID,"I") 
 	}
 	Set xPaadms=""
 	For i=1:1:RstEpisArr.Count(){
		Set TransInfo= RstEpisArr.GetAt(i)
		Continue:TransInfo=""	
		Set Date      = $LIST(TransInfo,1)
		Set EpisodeID = $LIST(TransInfo,2)
		Set Status    = $LIST(TransInfo,3)			
		Set LocID     = $LIST(TransInfo,4)	
		Set TansID    = $LIST(TransInfo,5)
		Set num=$i(^TMP($zn,$j,NIndex,Date,EpisodeID,LocID))
		Continue:num>1                        //当天转出不算在内
		Continue:(Status="I")                 //当天转入不算在内
		Continue:'((EpisodeID'="")&($listfind(xPaadms,EpisodeID)<1))  //去重复
		Set xPaadms=xPaadms_$lb(EpisodeID)
		Set objPaadm = ##class(DHCHAI.DP.PAAdm).GetObjById(EpisodeID)
		Continue:'$isobject(objPaadm)
		Set EpisodeIDx = objPaadm.PAEpisodeIDx
		Set AdmID = $p(EpisodeIDx,"||",2)
		//报告信息
		Set InputRep=""
		Set ID               = ""
		Set IREpisodeDr      = EpisodeID
		Set IRRepType        = "7"
		Set IRRepDate        = aDateFrom
		Set IRRepTime        = ""
		Set IRRepLocDr       = aLocID
		Set IRRepUser        = "MedManager"
		Set IRStatusDr       = "2"
		Set InputRep=ID_"^"_IREpisodeDr_"^"_IRRepType_"^"_IRRepDate_"^"_IRRepTime_"^"_IRRepLocDr_"^"_IRRepUser
		//横断面调查报告信息
		Set CSSID=""
		Set IRSurvUser = ##Class(EMRservice.BL.BLScatterData).GetDataByGlossary(AdmID,"HDSD00.11.050")
		Set InputCSS=CSSID
		Set InputCSS=InputCSS_"^"_EpisodeID
		Set InputCSS=InputCSS_"^"_aSurNumID
		
		Set InputCSS=InputCSS_"^"_IRSurvUser
		Set InputCSS=InputCSS_"^"_"1"
		Set InputCSS=InputCSS_"^"_EpisodeID
		Set InputCSS=InputCSS_"^"_EpisodeID
		
		Do ##class(DHCHAI.IRS.INFReportSrv).SaveINFReport(InputRep,"","","","","","","",InputCSS)
		Set Count=Count+1
	}
	
    Quit Count
}

/// Creator：     chenjb
/// CreatDate：   2018-01-26
/// Description:  横断面病例查询[以0点在院为准]
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.INFCSSSrv","QryAdm","1^^^3^^^^","")
Query QryAdm(aIntputs As %String, aSearch As %String = "") As %Query(ROWSPEC = "RepID:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmBed:%String,DischDate:%String,AdmDate:%String,SurvNumber:%String,EpisodeID:%String,EpisodeIDx:%String,PatientIDx:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,IdentityCode:%String,AdmTimes:%String,AllDiag:%String,OBSCnt:%String,OperFlag:%String,CuteTypeID:%String,CuteType:%String,IROperDate:%String,IROperName:%String,IRSurvUser:%String,InfectionDr:%String,InfectionDesc:%String,InfCateDr:%String,InfCateDesc:%String,YYInfPos11Dr:%String,YYInfPos11Desc:%String,YYBacteria11Dr:%String,YYBacteria11Desc:%String,YYMDR11Dr:%String,YYMDR11Desc:%String,YYBacteria12Dr:%String,YYBacteria12Desc:%String,YYMDR12Dr:%String,YYMDR12Desc:%String,YYBacteria13Dr:%String,YYBacteria13Desc:%String,YYMDR13Dr:%String,YYMDR13Desc:%String,YYInfPos21Dr:%String,YYInfPos21Desc:%String,YYBacteria21Dr:%String,YYBacteria21Desc:%String,YYMDR21Dr:%String,YYMDR21Desc:%String,YYBacteria22Dr:%String,YYBacteria22Desc:%String,YYMDR22Dr:%String,YYMDR22Desc:%String,YYBacteria23Dr:%String,YYBacteria23Desc:%String,YYMDR23Dr:%String,YYMDR23Desc:%String,YYInfPos31Dr:%String,YYInfPos31Desc:%String,YYBacteria31Dr:%String,YYBacteria31Desc:%String,YYMDR31Dr:%String,YYMDR31Desc:%String,YYBacteria32Dr:%String,YYBacteria32Desc:%String,YYMDR32Dr:%String,YYMDR32Desc:%String,YYBacteria33Dr:%String,YYBacteria33Desc:%String,YYMDR33Dr:%String,YYMDR33Desc:%String,OprInfDr:%String,OprInfDesc:%String,IRComInfPathogen1:%String,IRComInfPathogen2:%String,IRComInfPathogen3:%String,IRBugsAntiSen:%String,IRAntiFlag:%String,IRAntiDrList:%String,PurposeDr:%String,PurposeDesc:%String,CombinDr:%String,CombinDesc:%String,IRAntiSenFlag:%String,IROperAntiFlag:%String,IRRepFinishFlag:%String,UpdateDate:%String,UpdateUserDesc:%String,InfPosDescs:%String,DiagnosDr:%String,DiagnosDesc:%String,AdmDoc:%String,Abstract:%String,ComInfPos1:%String,SQMethod1:%String,ComSpecimen11:%String,ComSpecimen12:%String,ComBacteria11:%String,ComBacteria12:%String,ComBacteria13:%String,ComInfPos2:%String,SQMethod2:%String,ComSpecimen21:%String,ComSpecimen22:%String,ComBacteria21:%String,ComBacteria22:%String,ComBacteria23:%String,ComInfPos3:%String,SQMethod3:%String,ComSpecimen31:%String,ComSpecimen32:%String,ComBacteria31:%String,ComBacteria32:%String,ComBacteria33:%String,CSSSpecGLFlag:%String,CSSSpecKSFlag:%String,CSSSpecMZFlag:%String,CSSSpecJYFlag:%String,FirInfDate:%String,RepStatus:%String,SurLocDesc:%String,CSSID:%String,RepID:%String") [ SqlProc ]
{
}

ClassMethod QryAdmExecute(ByRef qHandle As %Binary, aIntputs As %String, aSearch As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	//入参处理[aIntputs拆分]
 	Quit:aIntputs="" $$$OK
 	Set aHospIDs 	= $p(aIntputs,"^",1) 		//院区ID
 	Set aLocationID = $p(aIntputs,"^",2)		//科室ID
 	Set aWardID 	= $p(aIntputs,"^",3)		//病区ID
 	Set aSEID 	    = $p(aIntputs,"^",4)   		//调查编号ID
 	Set aPatName 	= $p(aIntputs,"^",5)		//患者姓名
 	Set aPapmiNo 	= $p(aIntputs,"^",6)		//登记号
 	Set aMrNo 		= $p(aIntputs,"^",7)		//病案号
 	Set aStatus		= $p(aIntputs,"^",8)		//状态
    Set aInfType     = $p(aIntputs,"^",9)       //感染类型
    Set aLocType="W"
 	Set:aStatus="1" aStatus="未调查"
 	Set:aStatus="2" aStatus="已调查"
 	Set:aStatus="3" aStatus="已审核"
 	Quit:(aHospIDs="")||(aSEID="") $$$OK
 	
 	Set:((aSearch=1)||(aSearch=2)) aSearch=""
   
 	//通过'调查编号'取'调查开始日期'和'调查结束日期'
 	Set SExecData=$g(^DHCHAI.IR.SurveyExecD(aSEID))
 	Quit:SExecData="" $$$OK
 	
 	Set aDateFrom 	= $li(SExecData,5)  
 	Set aDateTo 	= $li(SExecData,6)  
 	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	//调查科室(为空查询全部科室)
 	Set:aWardID'="" aLocationID=aWardID
 	If (aLocationID'=""){
	 	Set LocData=$g(^DHCHAI.BT.LocationD(aLocationID))
 		Quit:LocData="" $$$OK
        Set BTType=$lg(LocData,5)
        Set:BTType'="" aLocType=$lg($g(^DHCHAI.BT.DictionaryD(BTType)),2)
	}
	
	Set xPaadms =""
	//定义临时Gloabl
	Set NIndex="QryAdm"
	Kill ^TMP($zn,$j,NIndex)
    Set:aLocType'="E" aLocType="W"
 	//横断面调查病人就诊列表[统计0点患者]
    Set LocEpisArray=##class(DHCHAI.IRS.UtilHCSSSrv).GetLocEpisByBed(aHospIDs,aDateFrom,aDateTo,aLocType)         
     //调查院区
    Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
   
    For index1=1:1:LocEpisArray.Count() {
        Set TransInfo=LocEpisArray.GetAt(index1)   
        Continue:TransInfo=""
        
        Set LocID   = $LIST(TransInfo,1)
		Set xPaadmId  = $LIST(TransInfo,2)		//就诊号
        
		//过滤重复患者
		Continue:$d(^TMP($zn,$j,NIndex,"CssPat",xPaadmId))
		Set ^TMP($zn,$j,NIndex,"CssPat",xPaadmId)=""
        Continue:(aLocationID'="")&&(aLocationID'=LocID)
		//过滤院区
		Set LocData = $g(^DHCHAI.BT.LocationD(LocID))
		Continue:LocData=""
		Set HospDr=$li(LocData,8)
		Continue:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1)	 
		
		Set SurLocDesc=$li(LocData,3)	//调查科室|病区
		
		Set Data = ..BuildPaadmData(xPaadmId,aHospIDs,aSEID,LocID,aPatName)
		Continue:Data=""
        Set InfCateDesc=$lg(Data,29)
        Set InfCateDesc=$s(InfCateDesc="医院感染":"医院",InfCateDesc="社区感染":"社区",1:"")
        Continue:(aInfType'="")&&(InfCateDr'[InfCateDesc)
		//取报告状态 4  13 
		Set PatName=$li(Data,13)
		Set PatBed=$li(Data,4)
		Continue:(aSearch'="")&&(PatName'[aSearch)&&(PatBed'[aSearch)
		Set RepStatus=""
		Set RepID=$li(Data,1)
		If (RepID'=""){
			Set RepData=$g(^DHCHAI.IR.INFReportD(RepID))
			If (RepData'=""){
				Set RepStatusID=$li(RepData,8)
				If (RepStatusID'=""){
					Set RepStatusData=$g(^DHCHAI.BT.DictionaryD(RepStatusID))
					If (RepStatusData'=""){
						Set RepStatus=$li(RepStatusData,3)
					}
				}
			}
		}
		If (RepStatus=""){
			Set RepStatus="未调查"
		}
		elseIf (RepStatus="审核"){
			Set RepStatus="已审核"
		}
		else{
			Set RepStatus="已调查"
		}
		Continue:(aStatus'="")&&(aStatus'=RepStatus)
		//增加cssid
		//调查编号+患者唯一	
    	Set xCSSIDAdd =$o(^DHCHAI.IR.INFCSSI("IndexSurEpisodeID"," "_aSEID,xPaadmId,0)) 
		Set ^CacheTemp(repid,ind)=Data_$lb(RepStatus,SurLocDesc,xCSSIDAdd,RepID)
		Set ind=ind+1
	}
	
 	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAdmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAdmExecute ]
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

/// Creator：     chenjb
/// CreatDate：   2018-01-26
/// Description:  横断面病例查询
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.INFCSSSrv","QryCSSByPaadm","2773","3")
Query QryCSSByPaadm(aEpisodeID As %String, aSurNumber As %String) As %Query(ROWSPEC = "RepID:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmBed:%String,DischDate:%String,AdmDate:%String,SurvNumber:%String,EpisodeID:%String,EpisodeIDx:%String,PatientIDx:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,IdentityCode:%String,AdmTimes:%String,AllDiag:%String,OBSCnt:%String,OperFlag:%String,CuteTypeID:%String,CuteType:%String,IROperDate:%String,IROperName:%String,IRSurvUser:%String,InfectionDr:%String,InfectionDesc:%String,InfCateDr:%String,InfCateDesc:%String,YYInfPos11Dr:%String,YYInfPos11Desc:%String,YYBacteria11Dr:%String,YYBacteria11Desc:%String,YYMDR11Dr:%String,YYMDR11Desc:%String,YYBacteria12Dr:%String,YYBacteria12Desc:%String,YYMDR12Dr:%String,YYMDR12Desc:%String,YYBacteria13Dr:%String,YYBacteria13Desc:%String,YYMDR13Dr:%String,YYMDR13Desc:%String,YYInfPos21Dr:%String,YYInfPos21Desc:%String,YYBacteria21Dr:%String,YYBacteria21Desc:%String,YYMDR21Dr:%String,YYMDR21Desc:%String,YYBacteria22Dr:%String,YYBacteria22Desc:%String,YYMDR22Dr:%String,YYMDR22Desc:%String,YYBacteria23Dr:%String,YYBacteria23Desc:%String,YYMDR23Dr:%String,YYMDR23Desc:%String,YYInfPos31Dr:%String,YYInfPos31Desc:%String,YYBacteria31Dr:%String,YYBacteria31Desc:%String,YYMDR31Dr:%String,YYMDR31Desc:%String,YYBacteria32Dr:%String,YYBacteria32Desc:%String,YYMDR32Dr:%String,YYMDR32Desc:%String,YYBacteria33Dr:%String,YYBacteria33Desc:%String,YYMDR33Dr:%String,YYMDR33Desc:%String,OprInfDr:%String,OprInfDesc:%String,IRComInfPathogen1:%String,IRComInfPathogen2:%String,IRComInfPathogen3:%String,IRBugsAntiSen:%String,IRAntiFlag:%String,IRAntiDrList:%String,PurposeDr:%String,PurposeDesc:%String,CombinDr:%String,CombinDesc:%String,IRAntiSenFlag:%String,IROperAntiFlag:%String,IRRepFinishFlag:%String,UpdateDate:%String,UpdateUserDesc:%String,InfPosDescs:%String,DiagnosDr:%String,DiagnosDesc:%String") [ SqlProc ]
{
}

ClassMethod QryCSSByPaadmExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aSurNumber As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:(aEpisodeID="")||(aSurNumber="") $$$OK
 	
 	Set aHospIDs=""
	Set Data = ..BuildPaadmData(aEpisodeID,aHospIDs,aSurNumber)
 	Quit:Data="" $$$OK 		
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1	
 		
	Quit $$$OK
}

ClassMethod QryCSSByPaadmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCSSByPaadmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCSSByPaadmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCSSByPaadmExecute ]
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

/// Creator：     chenjb
/// CreatDate：   2018-02-02
/// Description:  横断面病例查询 单个患者
/// Return：      返回ROWSPEC
/// S list =  ##class(DHCHAI.IRS.INFCSSSrv).BuildPaadmData("671",$lb("1","2","3","4"),"3")
ClassMethod BuildPaadmData(aEpisodeID As %String, aHospIDs As %String = "", aSEID As %String, aLocID As %String = "", aPatName As %String = "") As %String
{
	New (aEpisodeID,aHospIDs,aSEID,aLocID,aPatName)
	Set return=""
	Quit:aEpisodeID="" return
	
	//调查定义表
	Set SExecData=$g(^DHCHAI.IR.SurveyExecD(aSEID))
	Quit:SExecData="" return
	
	Set aDateFrom 	= $li(SExecData,5)  		//调查开始日期
 	Set aDateTo 	= $li(SExecData,6)  		//调查结束日期
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	
	//就诊表
	Set AdmData=$g(^DHCHAI.DP.PAAdmD(aEpisodeID))
	Quit:AdmData="" return
	
	Set EpisodeIDx=$li(AdmData,2)				//就诊序号(PAEpisodeIDx)
	Set SCode = $p(EpisodeIDx,"||",1)			//系统子代码[HIS01]
	Set VisitStatus = $li(AdmData,19)			//就诊状态[PAVisitStatus]
	Set VisitStatusInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"VisitStatus",VisitStatus)
	Set:VisitStatusInfo'="" VisitStatus=$p(VisitStatusInfo,"^",2)	//对照后
	//过滤就诊状态(预住院P、在院A、出院D、退院C、作废U)
	Quit:(VisitStatus="P")||(VisitStatus="C")||(VisitStatus="U") return		
	
	Set PatientIDx = $li(AdmData,2)				//病人主索引(PAPatientIDx)
	
	Set PapmiNo = $li(AdmData,4)				//登记号(PAPapmiNo)
	//过滤登记号
	Quit:($g(aPapmiNo)'="")&&($g(aPapmiNo)'=PapmiNo) return
	
	Set MrNo = $li(AdmData,5)					//病案号(PAMrNo)
	//过滤病案号
	Quit:($g(aMrNo)'="")&&($g(aMrNo)'=MrNo) return
	
	Set PatName = $li(AdmData,6)				//患者姓名(PAPatName)
	//过滤患者姓名
	Quit:('(PatName[$g(aPatName)))&&($g(aPatName)'="") return
	
	Set Sex = $li(AdmData,7)					//姓名(PASex)
	Set Sex = $s(Sex="M":"男",Sex="F":"女",1:"")
	
	Set Nation = $li(AdmData,8)					//民族(PANation)
	Set Birthday = $li(AdmData,9)				//出生日期(PABirthday)
	Set:Birthday'="" Birthday = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(Birthday)
	Set IdentityCode = $li(AdmData,10)			//身份证号码(PAIdentityCode)
	Set HomeAddress = $li(AdmData,11)			//现住址(PAHomeAddress)
	Set Company = $li(AdmData,12)				//工作单位(PACompany)
	Set RelativeName = $li(AdmData,13)			//联系人(PARelativeName)
	Set RelativeTel = $li(AdmData,14)			//联系人电话(PARelativeTel)
	Set IsDeath = $li(AdmData,15)				//死亡标志(PAIsDeath)
	Set DeathDate = $li(AdmData,16)				//死亡日期(PADeathDate)
	Set:DeathDate'="" DeathDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DeathDate)
	Set DeathTime = $li(AdmData,17)				//死亡时间(PADeathTime)
	Set:DeathTime'="" DeathTime=$zt(DeathTime)
	Set AdmType = $li(AdmData,18)				//就诊类型(PAAdmType)
	
	Set AdmDate = $li(AdmData,20)				//入院日期(PAAdmDate)
	Set:AdmDate'="" AdmDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
	Set AdmTime = $li(AdmData,21)				//入院时间(PAAdmTime)
	Set:AdmTime'="" AdmTime=$zt(AdmTime)
	
	Set AdmLocDr = $li(AdmData,22)				//入院科室(PAAdmLocDr)
	Set AdmLocData = $g(^DHCHAI.BT.LocationD(AdmLocDr))
	Quit:AdmLocData="" return
	Set LocDesc2 = $li(AdmLocData,4)
	Set LocDesc = $li(AdmLocData,3)
	Set AdmLocDesc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
	
	Set AdmWardDr = $li(AdmData,23)				//入院病区(PAAdmWardDr)
	Set AdmWardData = $g(^DHCHAI.BT.LocationD(AdmWardDr))
	Quit:AdmWardData="" return
	Set WardDesc2 = $li(AdmWardData,4)
	Set WardDesc = $li(AdmWardData,3)
	Set AdmWardDesc = $s(WardDesc2'="":WardDesc2,1:WardDesc)
	
	Set AdmRoom = $li(AdmData,24)				//就诊房间(PAAdmRoom)
	Set AdmBedDr= $li(AdmData,25)				//就诊床位(PAAdmBedDr)
	Set AdmBed=""
	If (AdmBedDr'=""){
		Set AdmBedData=$g(^DHCHAI.BT.PACBedD(AdmBedDr))
		If (AdmBedData'=""){
			Set AdmBed=$li(AdmBedData,3)
		}
	}
	
	Set DischDate = $li(AdmData,26)				//出院日期	
	Set:DischDate'="" DischDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DischDate)
	Set DischTime = $li(AdmData,27)				//出院时间
	Set:DischTime'="" DischTime=$zt(DischTime)
	Set DischLocID = $li(AdmData,28)			//出院科室
	Set DischLocDesc=""
	If (DischLocID'=""){
		Set DischLocData = $g(^DHCHAI.BT.LocationD(DischLocID))
		If (DischLocData'="") {
			Set LocDesc2 = $li(DischLocData,4)
			Set LocDesc = $li(DischLocData,3)
			Set DischLocDesc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
		}
	}
	Set DischWardID = $li(AdmData,29)			//出院病区
	Set DischWardDesc=""
	If (DischLocID'=""){
		Set DischWardData = $g(^DHCHAI.BT.LocationD(DischWardID))
		If (DischWardData'="") {
			Set WardDesc2 = $li(DischWardData,4)
			Set WardDesc = $li(DischWardData,3)
			Set DischWardDesc = $s(WardDesc2'="":WardDesc2,1:WardDesc)
		}	
	}
	
	Set AdmDays = $li(AdmData,31)				//住院天数(住院病人未出院值为-1)
	if AdmDays=-1{
		//未出院患者计算入院到当天天数
		Set AdmDays = (+$h)-$li(AdmData,20)+1	
	}
	Set IsNewBaby = $li(AdmData,32)				//新生儿标记
	Set BirthWeight = $li(AdmData,33)			//新生儿出生体重
	Set AdmitWeight = $li(AdmData,34)			//新生儿入院体重
	Set Age = $li(AdmData,37)					//年龄(PAAge)
	Set AdmTimes = $li(AdmData,38)				//住院次数(PAAdmTimes)
	Set AdmDoc	= $li(AdmData,39)				//主管医生(PAAdmDoc)
	Set:AdmDoc'="" AdmDoc=$p(AdmDoc,"|",3)
	
	// 增加返回诊断信息
	Set (MainDiag,AdmitDiag,OtherDiag,DischDiag)=""		// 主要诊断、入院诊断、其他诊断、出院诊断
	Set xDiagnosID = ""
	For {
		Set xDiagnosID = $o(^DHCHAI.DP.MRDiagnosI("IndexEpisodeDr",aEpisodeID,xDiagnosID))
		Quit:xDiagnosID=""
		
		Set objDiagnos = ##class(DHCHAI.DP.MRDiagnos).GetObjById(xDiagnosID)
		Continue:'$isobject(objDiagnos)
		Set IsActive = objDiagnos.MRIsActive
		Continue:IsActive'=1
		Continue:objDiagnos.MRDiagSource'="C"  //临床诊断
		Set SCode	   = objDiagnos.MRSCode
		Set ICD10  	   = objDiagnos.MRDiagICD10
		Set DiagDesc   = objDiagnos.MRDiagDesc
		Set DiagTpCode = objDiagnos.MRDiagTpCode
		Set DiagTpDesc = objDiagnos.MRDiagTpDesc
		Set DiagTypeMap=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"DiagType",DiagTpDesc)
		If DiagTypeMap'="" {
			Set DiagTpCode=$p(DiagTypeMap,"^",2)
			Set DiagTpDesc=$p(DiagTypeMap,"^",3)
		}
		
		If DiagTpDesc="入院诊断"{
			Set AdmitDiag = AdmitDiag_","_DiagDesc
		}elseif DiagTpDesc="主要诊断"{
			Set MainDiag = MainDiag_","_DiagDesc
		}elseif DiagTpDesc="出院诊断"{
			Set DischDiag = DischDiag_","_DiagDesc
		}else {
			Set OtherDiag = OtherDiag_","_DiagDesc
		}
	}
	Set:MainDiag'="" MainDiag = $e(MainDiag,2,$l(MainDiag))
	Set:AdmitDiag'="" AdmitDiag = $e(AdmitDiag,2,$l(AdmitDiag))
	Set:DischDiag'="" DischDiag = $e(DischDiag,2,$l(DischDiag))
	Set:OtherDiag'="" OtherDiag = $e(OtherDiag,2,$l(OtherDiag))
	Set AllDiag =""  //基础诊断 #
	Set:MainDiag'="" AllDiag = AllDiag_"#"_MainDiag
	Set:AdmitDiag'="" AllDiag = AllDiag_"#"_AdmitDiag
	Set:DischDiag'="" AllDiag = AllDiag_"#"_DischDiag 
	Set:OtherDiag'="" AllDiag = AllDiag_"#"_OtherDiag 
	Set:AllDiag'="" AllDiag = $e(AllDiag,2,$l(AllDiag))
	//取报告横断面调查
	Set xRepID = ""
	//Set xRepID = $o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,"7",xRepID))
	//调查编号+患者唯一	
    Set xCSSID =$o(^DHCHAI.IR.INFCSSI("IndexSurEpisodeID"," "_aSEID,aEpisodeID,0)) 
    Set arrReport=##class(DHCHAI.IR.INFRepExt).GetINFReports("DHCHAI.IR.INFCSS",xCSSID)
	For indRep=1:1:arrReport.Count() {
		Set objRep=arrReport.GetAt(indRep)
		Continue:'$IsObject(objRep)
		Set xRepID=objRep.%Id()		
	}
	Set (OperFlag,CuteTypeID,CuteType,IROperDate,IROperName,IRSurvUser,InfectionDr,InfectionDesc,InfCateDr,InfCateDesc)=""
	Set (YYInfPos11Dr,YYInfPos11Desc,YYBacteria11Dr,YYBacteria11Desc,YYMDR11Dr,YYMDR11Desc,YYBacteria12Dr,YYBacteria12Desc,YYMDR12Dr,YYMDR12Desc,YYBacteria13Dr,YYBacteria13Desc,YYMDR13Dr,YYMDR13Desc)=""
	Set (YYInfPos21Dr,YYInfPos21Desc,YYBacteria21Dr,YYBacteria21Desc,YYMDR21Dr,YYMDR21Desc,YYBacteria22Dr,YYBacteria22Desc,YYMDR22Dr,YYMDR22Desc,YYBacteria23Dr,YYBacteria23Desc,YYMDR23Dr,YYMDR23Desc)=""
	Set (YYInfPos31Dr,YYInfPos31Desc,YYBacteria31Dr,YYBacteria31Desc,YYMDR31Dr,YYMDR31Desc,YYBacteria32Dr,YYBacteria32Desc,YYMDR32Dr,YYMDR32Desc,YYBacteria33Dr,YYBacteria33Desc,YYMDR33Dr,YYMDR33Desc)=""
	Set (OprInfDr,OprInfDesc,IRComInfPathogen1,IRComInfPathogen2,IRComInfPathogen3,IRBugsAntiSen,IRAntiFlag,IRAntiDrList,PurposeDr,PurposeDesc)=""
	Set (DiagnosDr,DiagnosDesc,CombinDr,CombinDesc,IRAntiSenFlag,IROperAntiFlag,IRRepFinishFlag,UpdateDate,UpdateUserDesc)=""
		
	if (xRepID =""){
		//24小时内腹泻次数  针对的是当前日期
		Set xOBSToDate = +$h-1
		Set OBSCnt = ..GetKeyWordCntData(aEpisodeID,xOBSToDate,+$h,"MR-ObsDiarr","腹泻")
		Set:OBSCnt>0 OBSCnt=1
		//感染信息 现患的
		Set InfDias =""
		Set InfPosDescs = ""
		Set xID=""
		For {
			Set xID=$o(^DHCHAI.IR.INFDiagnosI("IndexPaadm",aEpisodeID,xID))
			Quit:xID=""
			
			Set obj=##class(DHCHAI.IR.INFDiagnos).GetObjById(xID)
			Continue:'$IsObject(obj)
			Continue:'$IsObject(obj.IRInfPosDr)
			Set InfDiagnosDr=obj.%Id()
			Set InfPosDr=obj.IRInfPosDr.%Id()
			Set InfPosDesc=obj.IRInfPosDr.BTDesc
			
			Set InfDate=obj.IRInfDate
			Continue:InfDate=""
			Set InfXDate=obj.IRInfXDate
			Set InfPosDesc=obj.IRInfPosDr.BTDesc
			Set InfSubDesc=""
			If $IsObject(obj.IRInfSubDr) {
				Set InfSubDesc=obj.IRInfSubDr.BTDesc
			}
			Set IsReportDiag=obj.IRIsReportDiag
			
			//Continue:InfDate>aDateFrom  //调查时未感染开始
			Continue:(+InfXDate'=0)&(InfXDate<=aDateFrom)  //感染转归日期小于调查日期即调查时已经结束
			Set listReports=##class(DHCHAI.IR.INFRepExt).GetINFReports("DHCHAI.IR.INFDiagnos",InfDiagnosDr)
			Set ReportCnt=listReports.Count()
			
			// 处理临床上报的感染诊断并且关联报告已经删除add by liyi 2017-12-06
			If (IsReportDiag=1)&&(ReportCnt<1){
				Continue
			}
			Set IRBacteria = obj.IRBacteria  //病原体#分割
			Set:InfDias'="" InfDias = InfDias_"#"_InfDiagnosDr_"^"_InfPosDesc_"^"_IRBacteria
			Set:InfDias="" InfDias = InfDiagnosDr_"^"_InfPosDesc_"^"_IRBacteria	
			Set:InfPosDescs'="" InfPosDescs = InfPosDescs _"#"_InfPosDesc
			Set:InfPosDescs="" InfPosDescs =InfPosDesc 			
		}
       
        Set IRAntiFlag ="",PurposeDesc ="",CombinDesc = "",IRAntiSenFlag =""
		//手术切口类型
        Set OperFlag = "",CuteTypeID = "",CuteType = ""   //20221130登记表中的切口等级取消自动取值默认为空
     
	}Else {
		//取报告里的信息
		Set xObjRep = ##class(DHCHAI.IR.INFReport).GetObjById(xRepID)
		Quit:'$isobject(xObjRep) return
		Set LinkCSSs = xObjRep.GetRepLinkIDs("DHCHAI.IR.INFCSS")
		Quit:LinkCSSs="" return
		Set xObj = ##class(DHCHAI.IR.INFCSS).GetObjById(+LinkCSSs)  //子父表一对一
		Quit:'$IsObject(xObj) return
		//24小时内腹泻次数  针对的是当前日期
		Set xOBSToDate = +$h-1
		Set OBSCnt = ..GetKeyWordCntData(aEpisodeID,xOBSToDate,+$h,"MR-ObsDiarr","腹泻")
		Set:OBSCnt>0 OBSCnt=1
		//感染信息 现患的
		Set InfDias =""
		Set InfPosDescs = ""
		Set xID=""
		For {
			Set xID=$o(^DHCHAI.IR.INFDiagnosI("IndexPaadm",aEpisodeID,xID))
			Quit:xID=""
			
			Set obj=##class(DHCHAI.IR.INFDiagnos).GetObjById(xID)
			Continue:'$IsObject(obj)
			Continue:'$IsObject(obj.IRInfPosDr)
			Set InfDiagnosDr=obj.%Id()
			Set InfPosDr=obj.IRInfPosDr.%Id()
			Set InfPosDesc=obj.IRInfPosDr.BTDesc
			
			Set InfDate=obj.IRInfDate
			Continue:InfDate=""
			Set InfXDate=obj.IRInfXDate
			Set InfPosDesc=obj.IRInfPosDr.BTDesc
			Set InfSubDesc=""
			If $IsObject(obj.IRInfSubDr) {
				Set InfSubDesc=obj.IRInfSubDr.BTDesc
			}
			Set IsReportDiag=obj.IRIsReportDiag
			
			//Continue:InfDate>aDateFrom  //调查时未感染开始
			Continue:(+InfXDate'=0)&(InfXDate<=aDateFrom)  //感染转归日期小于调查日期即调查时已经结束
			Set listReports=##class(DHCHAI.IR.INFRepExt).GetINFReports("DHCHAI.IR.INFDiagnos",InfDiagnosDr)
			Set ReportCnt=listReports.Count()
			
			// 处理临床上报的感染诊断并且关联报告已经删除add by liyi 2017-12-06
			If (IsReportDiag=1)&&(ReportCnt<1){
				Continue
			}
			Set IRBacteria = obj.IRBacteria  //病原体#分割
			Set:InfDias'="" InfDias = InfDias_"#"_InfDiagnosDr_"^"_InfPosDesc_"^"_IRBacteria
			Set:InfDias="" InfDias = InfDiagnosDr_"^"_InfPosDesc_"^"_IRBacteria	
			Set:InfPosDescs'="" InfPosDescs = InfPosDescs _"#"_InfPosDesc
			Set:InfPosDescs="" InfPosDescs =InfPosDesc 			
		}
		Set OperFlag = xObj.IROperFlag      //是否手术
		Set CuteTypeID="",CuteType=""            //手术切口
		If $IsObject(xObj.IROperCuteTypeDr) {
			Set CuteTypeID = xObj.IROperCuteTypeDr.%Id()
			Set CuteType   = xObj.IROperCuteTypeDr.BTDesc
		}
		Set IROperDate = xObj.IROperDate
		Set:IROperDate'="" IROperDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(IROperDate)
		Set IROperName=xObj.IROperName
		
		Set IRSurvNumber=xObj.IRSurvNumber
		Set IRSurvUser=xObj.IRSurvUser
		Set IRInfectionDr=xObj.IRInfectionDr
		Set (InfectionDr,InfectionDesc)=""
		If ($IsObject(IRInfectionDr)){
			Set InfectionDr   = IRInfectionDr.%Id()
			Set InfectionDesc = IRInfectionDr.BTDesc	
		}
		Set (DiagnosDr,DiagnosDesc)=""
		If ($IsObject(xObj.IRCSSDiagnosDr)){
			Set DiagnosDr   = xObj.IRCSSDiagnosDr.%Id()
			Set DiagnosDesc = xObj.IRCSSDiagnosDr.BTDesc	
		}
		Set IRInfCategoryDr=xObj.IRInfCategoryDr
		Set (InfCateDr,InfCateDesc)=""
		If ($IsObject(IRInfCategoryDr)){
			Set InfCateDr   = IRInfCategoryDr.%Id()
			Set InfCateDesc = IRInfCategoryDr.BTDesc	
		}
        Set FirInfDate = xObj.IRFirInfDate
        Set:FirInfDate'="" FirInfDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(FirInfDate)
		Set IRInfPathogen1=xObj.IRInfPathogen1
		Set (YYInfPos11Dr,YYInfPos11Desc,YYBacteria11Dr,YYBacteria11Desc,YYMDR11Dr,YYMDR11Desc,YYBacteria12Dr,YYBacteria12Desc,YYMDR12Dr,YYMDR12Desc,YYBacteria13Dr,YYBacteria13Desc,YYMDR13Dr,YYMDR13Desc)=""
		If ((IRInfPathogen1'="")&&(IRInfPathogen1'="######")){
			Set YYInfPos11Dr = $p(IRInfPathogen1,"#",1)
            Set YYInfPos11Desc = $$GetDiagDesc(YYInfPos11Dr)
			Set YYBacteria11Dr = $p(IRInfPathogen1,"#",2)
			Set objBacteria = ##class(DHCHAI.DP.LabBacteria).GetObjById(YYBacteria11Dr)
			Set:$IsObject(objBacteria) YYBacteria11Desc = objBacteria.BTBacDesc
			Set YYMDR11Dr = $p(IRInfPathogen1,"#",3)
			Set objMDR = ##class(DHCHAI.BT.Dictionary).GetObjById(YYMDR11Dr)
			Set:$IsObject(objMDR) YYMDR11Desc = objMDR.BTDesc
			Set YYBacteria12Dr = $p(IRInfPathogen1,"#",4)
			Set objBacteria = ##class(DHCHAI.DP.LabBacteria).GetObjById(YYBacteria12Dr)
			Set:$IsObject(objBacteria) YYBacteria12Desc = objBacteria.BTBacDesc
			Set YYMDR12Dr = $p(IRInfPathogen1,"#",5)
			Set objMDR = ##class(DHCHAI.BT.Dictionary).GetObjById(YYMDR12Dr)
			Set:$IsObject(objMDR) YYMDR12Desc = objMDR.BTDesc
			Set YYBacteria13Dr = $p(IRInfPathogen1,"#",6)
			Set objBacteria = ##class(DHCHAI.DP.LabBacteria).GetObjById(YYBacteria13Dr)
			Set:$IsObject(objBacteria) YYBacteria13Desc = objBacteria.BTBacDesc
			Set YYMDR13Dr = $p(IRInfPathogen1,"#",7)
			Set objMDR = ##class(DHCHAI.BT.Dictionary).GetObjById(YYMDR13Dr)
			Set:$IsObject(objMDR) YYMDR13Desc = objMDR.BTDesc
		}
		Set IRInfPathogen2=xObj.IRInfPathogen2
		Set (YYInfPos21Dr,YYInfPos21Desc,YYBacteria21Dr,YYBacteria21Desc,YYMDR21Dr,YYMDR21Desc,YYBacteria22Dr,YYBacteria22Desc,YYMDR22Dr,YYMDR22Desc,YYBacteria23Dr,YYBacteria23Desc,YYMDR23Dr,YYMDR23Desc)=""
		If ((IRInfPathogen2'="")&&(IRInfPathogen2'="######")){
			Set YYInfPos21Dr = $p(IRInfPathogen2,"#",1)
            Set YYInfPos21Desc = $$GetDiagDesc(YYInfPos21Dr)
			Set YYBacteria21Dr = $p(IRInfPathogen2,"#",2)
			Set objBacteria = ##class(DHCHAI.DP.LabBacteria).GetObjById(YYBacteria21Dr)
			Set:$IsObject(objBacteria) YYBacteria21Desc = objBacteria.BTBacDesc
			Set YYMDR21Dr = $p(IRInfPathogen2,"#",3)
			Set objMDR = ##class(DHCHAI.BT.Dictionary).GetObjById(YYMDR21Dr)
			Set:$IsObject(objMDR) YYMDR21Desc = objMDR.BTDesc
			Set YYBacteria22Dr = $p(IRInfPathogen2,"#",4)
			Set objBacteria = ##class(DHCHAI.DP.LabBacteria).GetObjById(YYBacteria22Dr)
			Set:$IsObject(objBacteria) YYBacteria22Desc = objBacteria.BTBacDesc
			Set YYMDR22Dr = $p(IRInfPathogen2,"#",5)
			Set objMDR = ##class(DHCHAI.BT.Dictionary).GetObjById(YYMDR22Dr)
			Set:$IsObject(objMDR) YYMDR22Desc = objMDR.BTDesc
			Set YYBacteria23Dr = $p(IRInfPathogen2,"#",6)
			Set objBacteria = ##class(DHCHAI.DP.LabBacteria).GetObjById(YYBacteria23Dr)
			Set:$IsObject(objBacteria) YYBacteria23Desc = objBacteria.BTBacDesc
			Set YYMDR23Dr = $p(IRInfPathogen2,"#",7)
			Set objMDR = ##class(DHCHAI.BT.Dictionary).GetObjById(YYMDR23Dr)
			Set:$IsObject(objMDR) YYMDR23Desc = objMDR.BTDesc
		}
		Set IRInfPathogen3=xObj.IRInfPathogen3
		Set (YYInfPos31Dr,YYInfPos31Desc,YYBacteria31Dr,YYBacteria31Desc,YYMDR31Dr,YYMDR31Desc,YYBacteria32Dr,YYBacteria32Desc,YYMDR32Dr,YYMDR32Desc,YYBacteria33Dr,YYBacteria33Desc,YYMDR33Dr,YYMDR33Desc)=""
		If ((IRInfPathogen3'="")&&(IRInfPathogen3'="######")){
			Set YYInfPos31Dr = $p(IRInfPathogen3,"#",1)
            Set YYInfPos31Desc =$$GetDiagDesc(YYInfPos31Dr)
			Set YYBacteria31Dr = $p(IRInfPathogen3,"#",2)
			Set objBacteria = ##class(DHCHAI.DP.LabBacteria).GetObjById(YYBacteria31Dr)
			Set:$IsObject(objBacteria) YYBacteria31Desc = objBacteria.BTBacDesc
			Set YYMDR31Dr = $p(IRInfPathogen3,"#",3)
			Set objMDR = ##class(DHCHAI.BT.Dictionary).GetObjById(YYMDR31Dr)
			Set:$IsObject(objMDR) YYMDR31Desc = objMDR.BTDesc
			Set YYBacteria32Dr = $p(IRInfPathogen3,"#",4)
			Set objBacteria = ##class(DHCHAI.DP.LabBacteria).GetObjById(YYBacteria32Dr)
			Set:$IsObject(objBacteria) YYBacteria32Desc = objBacteria.BTBacDesc
			Set YYMDR32Dr = $p(IRInfPathogen3,"#",5)
			Set objMDR = ##class(DHCHAI.BT.Dictionary).GetObjById(YYMDR32Dr)
			Set:$IsObject(objMDR) YYMDR32Desc = objMDR.BTDesc
			Set YYBacteria33Dr = $p(IRInfPathogen3,"#",6)
			Set objBacteria = ##class(DHCHAI.DP.LabBacteria).GetObjById(YYBacteria33Dr)
			Set:$IsObject(objBacteria) YYBacteria33Desc = objBacteria.BTBacDesc
			Set YYMDR33Dr = $p(IRInfPathogen3,"#",7)
			Set objMDR = ##class(DHCHAI.BT.Dictionary).GetObjById(YYMDR33Dr)
			Set:$IsObject(objMDR) YYMDR33Desc = objMDR.BTDesc
		}
		Set IROprInf=xObj.IROprInf
		Set (OprInfDr,OprInfDesc)=""
		If ($IsObject(IROprInf)){
			Set OprInfDr   = IROprInf.%Id()
			Set OprInfDesc = IROprInf.BTDesc	
		}
		Set IRComInfPathogen1=xObj.IRComInfPathogen1
		Set IRComInfPathogen2=xObj.IRComInfPathogen2
		Set IRComInfPathogen3=xObj.IRComInfPathogen3
        If ((IRComInfPathogen1'="")&&(IRComInfPathogen1'="######")){
            Set ComData1=$listFromString(IRComInfPathogen1,"#")
            Set ComInfPos1=$$GetDiagDesc($lg(ComData1,1)) //33 社区感染部位1
            Set SQMethod1=xObj.SQMethod1 //34 社区感染类别
            Set SQMethod1=$s(SQMethod1=1:"外院发生",SQMethod1=2:"社区发生",1:"")
            Set ComSpecimen11="" //35 标本编号1 
            Set ComSpecimen12="" //36 标本编号2
            Set ComBacteria11=$$GetBacDesc($lg(ComData1,2)) //病原体1
            Set ComBacteria12=$$GetBacDesc($lg(ComData1,4)) //病原体2
            Set ComBacteria13=$$GetBacDesc($lg(ComData1,6)) //病原体3
        }
        If ((IRComInfPathogen2'="")&&(IRComInfPathogen2'="######")){
            Set ComData2=$listFromString(IRComInfPathogen2,"#")
            Set ComInfPos2=$$GetDiagDesc($lg(ComData2,1)) //39 社区感染部位2
            Set SQMethod2=xObj.SQMethod2    
            Set SQMethod2=$s(SQMethod2=1:"外院发生",SQMethod2=2:"社区发生",1:"")
            Set ComSpecimen21="" //40 标本编号1 
            Set ComSpecimen22="" //41 标本编号2
            Set ComBacteria21=$$GetBacDesc($lg(ComData2,2)) // 病原体1
            Set ComBacteria22=$$GetBacDesc($lg(ComData2,4)) // 病原体2
            Set ComBacteria23=$$GetBacDesc($lg(ComData2,6)) // 病原体3
        }
        If ((IRComInfPathogen3'="")&&(IRComInfPathogen3'="######")){
            Set ComData3=$listFromString(IRComInfPathogen3,"#")
            Set ComInfPos3=$$GetDiagDesc($lg(ComData3,1)) //39 社区感染部位2
            Set SQMethod3=xObj.SQMethod3
            Set SQMethod3=$s(SQMethod3=1:"外院发生",SQMethod3=2:"社区发生",1:"")
            Set ComSpecimen31="" // 标本编号1 
            Set ComSpecimen32="" // 标本编号2
            Set ComBacteria31=$$GetBacDesc($lg(ComData3,2)) // 病原体1
            Set ComBacteria32=$$GetBacDesc($lg(ComData3,4)) // 病原体2
            Set ComBacteria33=$$GetBacDesc($lg(ComData3,6)) // 病原体3
        }
        Set CSSSpecGLFlag=$case(xObj.IRCSSSpecGLFlag,1:"是",0:"否",:"")  // 标本革兰染色  
    Set CSSSpecKSFlag=$case(xObj.IRCSSSpecKSFlag,1:"是",0:"否",:"")  // 标本抗酸染色
    Set CSSSpecMZFlag=$case(xObj.IRCSSSpecMZFlag,1:"是",0:"否",:"")  // 标本墨汁染色
    Set CSSSpecJYFlag=$case(xObj.IRCSSSpecJYFlag,1:"是",0:"否",:"")  // 标本基因测序
		Set IRBugsAntiSen = xObj.IRBugsAntiSen
		Set IRAntiFlag = xObj.IRAntiFlag
		Set IRAntiDrList=xObj.IRAntiDrList
		Set IRAntiUsePurposeDr=xObj.IRAntiUsePurposeDr
		Set (PurposeDr,PurposeDesc)=""
		If ($IsObject(IRAntiUsePurposeDr)){
			Set PurposeDr   = IRAntiUsePurposeDr.%Id()
			Set PurposeDesc = IRAntiUsePurposeDr.BTDesc	
		}
		Set IRAntiCombinedMedDr=xObj.IRAntiCombinedMedDr
		Set (CombinDr,CombinDesc)=""
		If ($IsObject(IRAntiCombinedMedDr)){
			Set CombinDr   = IRAntiCombinedMedDr.%Id()
			Set CombinDesc = IRAntiCombinedMedDr.BTDesc	
		}
		
		Set IRAntiSenFlag=xObj.IRAntiSenFlag
		Set IROperAntiFlag=xObj.IROperAntiFlag
		Set IRRepFinishFlag=xObj.IRRepFinishFlag
		Set UpdateDate=xObj.IRUpdateDate
		Set:UpdateDate'="" UpdateDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(UpdateDate)
		Set IRUpdateUserDr=xObj.IRUpdateUserDr
		Set (UpdateUserDr,UpdateUserDesc)=""
		If ($IsObject(IRUpdateUserDr)){
			Set UpdateUserDr   = IRUpdateUserDr.%Id()
			Set UpdateUserDesc = IRUpdateUserDr.BTDesc	
		}
	}
	Set OperFlag  	   = $s(OperFlag>0:"是",OperFlag=0:"否",1:"")
	Set OBSCnt  	   = $s(OBSCnt=1:"是",OBSCnt=0:"否",1:"")
	Set IRAntiSenFlag  = $s(IRAntiSenFlag=1:"是",IRAntiSenFlag=0:"否",1:"")
	Set IROperAntiFlag  = $s(IROperAntiFlag=1:"是",IROperAntiFlag=0:"否",1:"")
	Set IRAntiFlag     = $s(IRAntiFlag=1:"是",IRAntiFlag=0:"否",1:"")
	Set Abstract = "摘要"
	Set return = $lb(xRepID,AdmLocDesc,AdmWardDesc,AdmBed,DischDate,AdmDate,SurvNumber,aEpisodeID,EpisodeIDx,PatientIDx,PapmiNo,MrNo,PatName,Sex,Age,IdentityCode,AdmTimes,AllDiag,OBSCnt)
	Set return =return_$lb(OperFlag,CuteTypeID,CuteType,IROperDate,IROperName,IRSurvUser,InfectionDr,InfectionDesc,InfCateDr,InfCateDesc)
	Set return =return_$lb(YYInfPos11Dr,YYInfPos11Desc,YYBacteria11Dr,YYBacteria11Desc,YYMDR11Dr,YYMDR11Desc,YYBacteria12Dr,YYBacteria12Desc,YYMDR12Dr,YYMDR12Desc,YYBacteria13Dr,YYBacteria13Desc,YYMDR13Dr,YYMDR13Desc)
	Set return =return_$lb(YYInfPos21Dr,YYInfPos21Desc,YYBacteria21Dr,YYBacteria21Desc,YYMDR21Dr,YYMDR21Desc,YYBacteria22Dr,YYBacteria22Desc,YYMDR22Dr,YYMDR22Desc,YYBacteria23Dr,YYBacteria23Desc,YYMDR23Dr,YYMDR23Desc)
	Set return =return_$lb(YYInfPos31Dr,YYInfPos31Desc,YYBacteria31Dr,YYBacteria31Desc,YYMDR31Dr,YYMDR31Desc,YYBacteria32Dr,YYBacteria32Desc,YYMDR32Dr,YYMDR32Desc,YYBacteria33Dr,YYBacteria33Desc,YYMDR33Dr,YYMDR33Desc)
	Set return =return_$lb(OprInfDr,OprInfDesc,IRComInfPathogen1,IRComInfPathogen2,IRComInfPathogen3,IRBugsAntiSen,IRAntiFlag,IRAntiDrList,PurposeDr,PurposeDesc)
	Set return =return_$lb(CombinDr,CombinDesc,IRAntiSenFlag,IROperAntiFlag,IRRepFinishFlag,UpdateDate,UpdateUserDesc,InfPosDescs,DiagnosDr,DiagnosDesc,AdmDoc,Abstract)
    Set return =return_$lb(ComInfPos1,SQMethod1,ComSpecimen11,ComSpecimen12,ComBacteria11,ComBacteria12,ComBacteria13,ComInfPos2,SQMethod2,ComSpecimen21,ComSpecimen22,ComBacteria21,ComBacteria22,ComBacteria23,ComInfPos3,SQMethod3,ComSpecimen31,ComSpecimen32,ComBacteria31,ComBacteria32,ComBacteria33,CSSSpecGLFlag,CSSSpecKSFlag,CSSSpecMZFlag,CSSSpecJYFlag,FirInfDate)
    Quit return
GetDiagDesc(InfPosID)
    Set CSSRepPosDispalyConfig=##class(DHCHAI.BT.Config).GetValByCode("CSSRepPosDispalyConfig")     //根据CSS配置取感染部位
    if (+CSSRepPosDispalyConfig=0){
         Set return=$lg($g(^DHCHAI.BT.DictionaryD(InfPosID)),3)
         Quit return
    }else{
        Set return="" 
        Set objInfPos = ##class(DHCHAI.BT.InfPos).GetObjById(InfPosID)
        Set:$IsObject(objInfPos) return = objInfPos.BTDesc //22 医院感染部位
        Quit return
    }
GetBacDesc(BacID)
    Set return="" 
    Set objBacteria = ##class(DHCHAI.DP.LabBacteria).GetObjById(BacID)
    Set:$IsObject(objBacteria) return = objBacteria.BTBacDesc
	Quit return
}

/// Creator：     chenjb
/// CreatDate：   2018-01-26
/// Description:  获取某类型的筛查项目时间段里的触发次数 "MR-ObsDiarr","腹泻" LAB-Bacteria 检出菌
/// Return：      返回ROWSPEC
/// w ##class(DHCHAI.IRS.INFCSSSrv).GetKeyWordCntData("18","64496","64500","MR-ObsDiarr","腹泻")
ClassMethod GetKeyWordCntData(aEpisodeID As %String, aSttDate As %String = "", aEndDate As %String = "", aCCType As %String, aKeyWord As %String = "") As %String
{
	New (aEpisodeID, aSttDate,aEndDate,aCCType,aKeyWord)
	Set return =0
	Quit:aKeyWord="" return
	
	Set KeyWords=aKeyWord

	Set xItemID=0,num=0
	For {
		Set xItemID=$o(^DHCHAI.IR.CCResultI("IndexItemDrKeyWordDr",aEpisodeID,xItemID))
		Quit:xItemID=""
		
		Set objItmMast=##class(DHCHAI.IR.CCItmMast).GetObjById(xItemID)
		Continue:'$IsObject(objItmMast)
		Continue:objItmMast.CCCode'=aCCType // "MR-ObsFever" 护理-发热
		
		Set xKeyWordDr=""
		For {
			Set xKeyWordDr=$o(^DHCHAI.IR.CCResultI("IndexItemDrKeyWordDr",aEpisodeID,xItemID,xKeyWordDr))
			Quit:xKeyWordDr=""
			
			Set objKeyWord=##class(DHCHAI.IR.CCKeyWord).GetObjById(xKeyWordDr)
			Continue:'$IsObject(objKeyWord)
			Set tKeyword=objKeyWord.CCDesc
			Continue:KeyWords'[tKeyword  //发热
			
			Set xID=0
			For {
				Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemDrKeyWordDr",aEpisodeID,xItemID,xKeyWordDr,xID))
				Quit:xID=""
				
				Set obj=##class(DHCHAI.IR.CCResult).GetObjById(xID)
				Continue:'$IsObject(obj)
				Continue:'$IsObject(obj.CCEpisodeDr)
				Continue:'$IsObject(obj.CCItemDr)
				Continue:obj.CCIsActive'=1
				
				Set SCode=obj.CCSCode
				Set ActDate=obj.CCActDate
				Set RepDate=obj.CCRepDate
				Continue:ActDate=""
				Continue:'((aSttDate<=ActDate)&(aEndDate>=ActDate))
				Set return=return+1
				//Set arrResult(ActDate,"Rst",xID)=$lb(xID,ActDate)
				
				//判断是否入院48小时后项目
				//Set flg=##class(DHCHAI.IRC.CSResultSrv).CheckIs48HourRst(obj)
				//Set arrResult(ActDate,"48H",+flg)=""
			}
		}
	}
	Quit return
}

/// Creator：     chenjb
/// CreatDate：   2018-04-03
/// Description:  横断面病例查询
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.INFCSSSrv","StaCSSByNo","1|2|3|4","6","")
Query StaCSSByNo(aHospIDs As %String, aSurNumber As %String, aLocIDs As %String = "") As %Query(ROWSPEC = "LocID:%String,LocDesc:%String,SurNumber:%String,xPaadmId:%String,EpisodeIDx:%String,PatientIDx:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmTimes:%String,AllDiag:%String,AdmBed:%String,RepID:%String,IsOpr:%String,CutType:%String,InfType:%String,InfPosDesc:%String,InfDiagDesc:%String,InfDateDesc:%String,InfPosBac:%String,IsAnti:%String,AntiComb:%String,AntiPos:%String,AntiSen:%String,RepUser:%String,RepLoc:%String,RepDate,IRHbsAg:%String,IRHCV:%String,IRHIV:%String,IsPICC:%String,IsUC:%String,IsVAP:%String,IsJMSY:%String,IsXH:%String,RecordDesc:%String") [ SqlProc ]
{
}

ClassMethod StaCSSByNoExecute(ByRef qHandle As %Binary, aHospIDs As %String, aSurNumber As %String, aLocIDs As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:(aHospIDs="")||(aSurNumber="") $$$OK
 	
 	Set objSExec = ##class(DHCHAI.IR.SurveyExec).GetObjById(aSurNumber)
	Quit:'$IsObject(objSExec) $$$OK
 	Set aDateFrom 	= objSExec.SESurvSttDate    //通过调查定义表取开始结束日期
 	Set aDateTo 	= objSExec.SESurvEndDate
 	Set SurNumber = objSExec.SESurvNumber
 	//
 	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
 	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	/// 取所有需要调查的科室  默认是全院科室
	Set NIndex="StaCSSByNo"
	Kill ^TMP($zn,$j,NIndex)

    //同期在科天数
    Set Count=0,num=0
    Set ListArray=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransEpisByLocDate(aDateFrom,aDateTo,"E","","I") //某段时间的在科人数
    For index=1:1:ListArray.Count() {
		Set TransInfo=ListArray.GetAt(index)	
		Continue:TransInfo=""	
		Set Date   = $LIST(TransInfo,1)
		Set Paadm  = $LIST(TransInfo,2)
		Set Status = $LIST(TransInfo,3)			
		Set LocID  = $LIST(TransInfo,4)	
		Set TansID = $LIST(TransInfo,5)
		Set num=$i(^TMP($zn,$j,NIndex,Date,Paadm,LocID))
		Continue:num>1                        //当天转出不算在内
		Continue:(Status="I")                 //当天转入不算在内
        Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(LocID)
		Continue:'$IsObject(objLoc)
		Continue:'$IsObject(objLoc.BTHospDr)
		Continue:(aLocIDs'="")&(aLocIDs'=LocID)  //按科室过滤
		Continue:(aHospIDs'="")&($listfind(aHospIDs,objLoc.BTHospDr.%Id())<1)  //按医院过滤	
		Set ^TMP($zn,$j,NIndex,LocID,Paadm)=Paadm
		Set Count=$i(^TMP($zn,$j,NIndex,LocID,Paadm,"InDays"))		
    }
    //同期在科人数
	Set xLocID="",InCount=0
	For {
		Set xLocID=$o(^TMP($zn,$j,NIndex,xLocID))
		Quit:xLocID=""
	
		Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(xLocID)
		Continue:'$isobject(objLoc)
		Set xLocDesc=objLoc.BTDesc2
		Set:xLocDesc="" xLocDesc=objLoc.BTDesc
		Set LocDesc	    = ##class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(xLocDesc)
		Set xPaadm="",xPaadms = ""
		For {
			Set xPaadm=$o(^TMP($zn,$j,NIndex,xLocID,xPaadm))
			Quit:xPaadm=""
			
			Set (EpisodeIDx,PatientIDx,PapmiNo,MrNo,PatName,Sex,Age,AdmTimes,AllDiag,AdmBed,AdmDays)=""
			
			Continue:'((xPaadm'="")&($listfind(xPaadms,xPaadm)<1))  
			Set xPaadms=xPaadms_$lb(xPaadm)
			
			Set objPaadm = ##class(DHCHAI.DP.PAAdm).GetObjById(xPaadm)
			Continue:'$isobject(objPaadm)
			
			Set EpisodeIDx=objPaadm.PAEpisodeIDx
			Set SCode = $p(EpisodeIDx,"||",1)
			Set VisitStatus = objPaadm.PAVisitStatus
			Set VisitStatusInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"VisitStatus",VisitStatus)
			If VisitStatusInfo'="" {
				Set VisitStatus=$p(VisitStatusInfo,"^",2)
			}
			Continue:(VisitStatus="P")||(VisitStatus="C")||(VisitStatus="U") //预住院P、在院A、出院D、退院C、作废U
			
			Set EpisodeIDx = objPaadm.PAEpisodeIDx
			Set PatientIDx = objPaadm.PAPatientIDx
			Set PapmiNo = objPaadm.PAPapmiNo
			Set MrNo = objPaadm.PAMrNo
			Set PatName = objPaadm.PAPatName

			Set Sex = objPaadm.PASex
			Set Sex = $s(Sex="M":"男",Sex="F":"女",1:"")
			Set Birthday = objPaadm.PABirthday
			Set:Birthday'="" Birthday = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(Birthday)
			Set Age = objPaadm.PAAge
			Set IsDeath = objPaadm.PAIsDeath
			
			Set AdmType = objPaadm.PAAdmType
			Set AdmDate = objPaadm.PAAdmDate
			Set:AdmDate'="" AdmDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
			Set AdmTime = objPaadm.PAAdmTime
			Set:AdmTime'="" AdmTime=$zt(AdmTime)
			Set objAdmLoc = objPaadm.PAAdmLocDr
			Set AdmTimes = objPaadm.PAAdmTimes
			
			
			Set AdmRoom = objPaadm.PAAdmRoom
			Set (AdmBedDr,AdmBed)=""
			If $IsObject(objPaadm.PAAdmBedDr){
				Set AdmBedDr=objPaadm.PAAdmBedDr.%Id()
				Set AdmBed=objPaadm.PAAdmBedDr.BTDesc
			}
			
			Set AdmDays = objPaadm.PAAdmDays
			if AdmDays=-1{
				Set AdmDays = (+$h)-objPaadm.PAAdmDate+1	//未出院患者计算入院到当天天数
			}
			// 增加返回诊断信息
			Set (MainDiag,AdmitDiag,OtherDiag,DischDiag)=""		// 主要诊断、入院诊断、其他诊断、出院诊断
			Set xDiagnosID = ""
			For {
				Set xDiagnosID = $o(^DHCHAI.DP.MRDiagnosI("IndexEpisodeDr",xPaadm,xDiagnosID))
				Quit:xDiagnosID=""
				
				Set objDiagnos = ##class(DHCHAI.DP.MRDiagnos).GetObjById(xDiagnosID)
				Continue:'$isobject(objDiagnos)
				Set IsActive = objDiagnos.MRIsActive
				Continue:IsActive'=1
				Continue:objDiagnos.MRDiagSource'="C"  //临床诊断
				Set SCode	   = objDiagnos.MRSCode
				Set ICD10  	   = objDiagnos.MRDiagICD10
				Set DiagDesc   = objDiagnos.MRDiagDesc
				Set DiagTpCode = objDiagnos.MRDiagTpCode
				Set DiagTpDesc = objDiagnos.MRDiagTpDesc
				Set DiagTypeMap=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"DiagType",DiagTpDesc)
				If DiagTypeMap'="" {
					Set DiagTpCode=$p(DiagTypeMap,"^",2)
					Set DiagTpDesc=$p(DiagTypeMap,"^",3)
				}
				
				If DiagTpDesc="入院诊断"{
					Set AdmitDiag = AdmitDiag_","_DiagDesc
				}elseif DiagTpDesc="主要诊断"{
					Set MainDiag = MainDiag_","_DiagDesc
				}elseif DiagTpDesc="出院诊断"{
					Set DischDiag = DischDiag_","_DiagDesc
				}else {
					Set OtherDiag = OtherDiag_","_DiagDesc
				}
			}
			Set:MainDiag'="" MainDiag = $e(MainDiag,2,$l(MainDiag))
			Set:AdmitDiag'="" AdmitDiag = $e(AdmitDiag,2,$l(AdmitDiag))
			Set:DischDiag'="" DischDiag = $e(DischDiag,2,$l(DischDiag))
			Set:OtherDiag'="" OtherDiag = $e(OtherDiag,2,$l(OtherDiag))
			Set AllDiag =""  //基础诊断 #
			Set:MainDiag'="" AllDiag = AllDiag_"#"_MainDiag
			Set:AdmitDiag'="" AllDiag = AllDiag_"#"_AdmitDiag
			Set:DischDiag'="" AllDiag = AllDiag_"#"_DischDiag 
			Set:OtherDiag'="" AllDiag = AllDiag_"#"_OtherDiag 
			Set:AllDiag'="" AllDiag = $e(AllDiag,2,$l(AllDiag))
			//横断面调查信息
			Set xRepID = ""
			Set xRepID = $o(^DHCHAI.IR.INFReportI("IndexPaadmType",xPaadm,"7",xRepID))			
			Set (RepID,IsOpr,CuteType,InfType,InfPosDesc,InfDiagDesc,InfDateDesc,InfPosBac,IsAnti,AntiComb,AntiPos,AntiSen,RepUser,RepLoc,RepDate)=""
			Set (IRHbsAg,IRHCV,IRHIV,IsPICC,IsUC,IsVAP,IsJMSY,RecordDesc)=""  
			Set IsXH=0 //现患例次数
			if (xRepID'=""){
				//取报告里的信息
				Set xObjRep = ##class(DHCHAI.IR.INFReport).GetObjById(xRepID)
				if $Isobject(xObjRep) {
					Set:$Isobject(xObjRep.IRRepUser) RepUser = xObjRep.IRRepUser.BTDesc
					Set:$Isobject(xObjRep.IRRepLocDr) RepLoc = xObjRep.IRRepLocDr.BTDesc
					Set RepDate = ##class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(xObjRep.IRRepDate)
					Set RepID = xRepID				
					Set LinkCSSs = xObjRep.GetRepLinkIDs("DHCHAI.IR.INFCSS")
					Set xObj = ##class(DHCHAI.IR.INFCSS).GetObjById(+LinkCSSs)  //子父表一对一
					if $IsObject(xObj) {
						If $IsObject(xObj.IRRecordDr) {
							Set RecordDesc= xObj.IRRecordDr.BTDesc
						}
						Set InfType = xObj.IRInfCategoryDr  //0院内/1社区感染
						Set OBSCnt        = xObj.IROBSDiarrhea   //是否腹泻
						Set:+OBSCnt>0 OBSCnt= 1
						Set IsOpr      = xObj.IROperFlag      //是否手术
						Set CuteTypeID="",CuteType=""            //手术切口
						If $IsObject(xObj.IROperCuteTypeDr) {
							Set CuteTypeID = xObj.IROperCuteTypeDr.%Id()
							Set CuteType   = xObj.IROperCuteTypeDr.BTDesc
						}
						Set IsAnti    = xObj.IRAntiFlag      //是否抗菌药物
						Set AntiPos     = xObj.IRAntiUsePurposeDr
						Set:$Isobject(AntiPos) AntiPos=AntiPos.BTDesc
						Set AntiComb = xObj.IRAntiCombinedMedDr
						Set:$Isobject(AntiComb) AntiComb =AntiComb.BTDesc 
						Set AntiSen  = xObj.IRAntiSenFlag   //是否药敏用药
						//药敏
						//Set IsHA=0,IsHACF=0,IsDZ=0,IsDZCF=0,BacDescs=""
						Set:$Isobject(xObj.IRHbsAgDr) IRHbsAg =xObj.IRHbsAgDr.BTDesc
						Set:$Isobject(xObj.IRHCVDr) IRHCV = xObj.IRHCVDr.BTDesc
						Set:$Isobject(xObj.IRHIVDr) IRHIV =xObj.IRHIVDr.BTDesc
						Set IsPICC = xObj.IRAddPICC
						Set IsUC = xObj.IRAddUC
						Set IsVAP = xObj.IRAddVAP
						Set IsJMSY = xObj.IRAddJMSY	
						//感染信息
						Set InfPosList="",InfSubList="",InfDateList=""
						Set InfDiagList=xObjRep.GetRepLinkIDs("DHCHAI.IR.INFDiagnos")
						For indInfD=1:1:$l(InfDiagList,","){													
							Set xInfDiagnosID=$p(InfDiagList,",",indInfD)
							Continue:xInfDiagnosID=""
							Set objInfDiagnos=##class(DHCHAI.IR.INFDiagnos).GetObjById(xInfDiagnosID)
							Continue:'$IsObject(objInfDiagnos)
							Continue:'$IsObject(objInfDiagnos.IRInfPosDr)			
							Set tInfPos=objInfDiagnos.IRInfPosDr.BTDesc
							Set tInfSub=objInfDiagnos.IRInfSubDr.BTDesc
							Set tInfDate=objInfDiagnos.IRInfDate
							Set InfXDate=objInfDiagnos.IRInfXDate
							
							Continue:tInfDate>aDateFrom  //调查时未感染开始
							Continue:(+InfXDate'=0)&(InfXDate<=aDateFrom)  //感染转归日期小于调查日期即调查时已经结束
							//Set:tInfDate="" tInfDate=$zd(tInfDate,3)
							Set:tInfDate'="" tInfDate= ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(tInfDate)
							Set InfPosList=InfPosList_$lb(tInfPos)
							Set InfSubList=InfSubList_$lb(tInfSub)
							Set InfDateList=InfDateList_$lb(tInfDate)
							Set InfPosBac =objInfDiagnos.IRBacteria
							
						}
						Set IsXH = $ll(InfPosList)
						Set InfPosDesc=##class(DHCHAI.Utils.CommonSrv).ListToString(InfPosList,";")
						Set InfDiagDesc=##class(DHCHAI.Utils.CommonSrv).ListToString(InfSubList,";")
						Set InfDateDesc=##class(DHCHAI.Utils.CommonSrv).ListToString(InfDateList,";")									
					}
				}
			}
			Set Data = $lb(xLocID,LocDesc,SurNumber,xPaadm,EpisodeIDx,PatientIDx,PapmiNo,MrNo,PatName,Sex,Age,AdmTimes,AllDiag,AdmBed)		
			Set Data =Data_$lb(RepID,IsOpr,CuteType,InfType,InfPosDesc,InfDiagDesc,InfDateDesc,InfPosBac,IsAnti,AntiComb,AntiPos,AntiSen,RepUser,RepLoc,RepDate)
			Set Data =Data_$lb(IRHbsAg,IRHCV,IRHIV,IsPICC,IsUC,IsVAP,IsJMSY,IsXH,RecordDesc)
			
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
			
		}
	}
	Quit $$$OK
}

ClassMethod StaCSSByNoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StaCSSByNoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod StaCSSByNoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StaCSSByNoExecute ]
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

/// Creator：     chenjb
/// CreatDate：   2017-03-07
/// Description:  通过编码查询
/// Table：       DHCHAI.BT.Config
/// Input：       aCode : 代码
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.INFCSSSrv","QueryByCode","",1)
Query QueryByCode(aHospIDs As %String = "", aFlag As %String = "") As %Query(ROWSPEC = "ID:%String,SESurvNumber:%String,SESurvSttDate:%String,SESurvEndDate:%String,HospDr:%String,HospCode:%String,HospDesc:%String,UserDr:%String,UserDesc:%String,HospIDs:%String") [ SqlProc ]
{
}

ClassMethod QueryByCodeExecute(ByRef qHandle As %Binary, aHospIDs As %String = "", aFlag As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
 	Set aCode=$ZCVT($g(aCode),"U")
 	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
 	Set xID=""
 	For {
	 	Set xID=$o(^DHCHAI.IR.SurveyExecD(xID),-1)
	 	Quit:xID=""
	 	
	 	Set obj=##class(DHCHAI.IR.SurveyExec).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	
	 	Set ID=obj.%Id()
	 	Set Code=obj.SESurvNumber
	 	Set SESurvSttDate=obj.SESurvSttDate
	 	Set SESurvEndDate=obj.SESurvEndDate
	 
        Set HospID="",HospCode="",HospDesc="",HospIDs=""
		If $IsObject(obj.SEHospDr) {
			Set HospID  =obj.SEHospDr.%Id()
	 		Set HospCode=obj.SEHospDr.BTCode
	 		Set HospDesc=obj.SEHospDr.BTDesc
	 		Continue:(aHospIDs'="")&($listfind(aHospIDs,HospID)<1)
        }else{
            Set HospIDs=obj.SEHospDr
		}
		
		Set UserDr="",UserDesc=""
		If $IsObject(obj.SEUpdateUserDr) {
			Set UserDr=obj.SEUpdateUserDr.BTCode
			Set UserDesc=obj.SEUpdateUserDr.BTDesc
		}
		Set:SESurvSttDate'="" SESurvSttDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(SESurvSttDate)
		Set:SESurvEndDate'="" SESurvEndDate =##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(SESurvEndDate)
        Set Data=$lb(ID,Code,SESurvSttDate,SESurvEndDate,HospID,HospCode,HospDesc,UserDr,UserDesc,HospIDs)
        Set ^CacheTemp(repid,ind)=Data
        Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QueryByCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryByCodeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryByCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryByCodeExecute ]
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

/// Creator：     liuzhenhe
/// CreatDate：   2020-10 
/// Description:  取现患里个案登记表数据 （）
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.INFCSSSrv","QryNewCSSByPaadm","7","6")
Query QryNewCSSByPaadm(aEpisodeID As %String, aSurNumber As %String) As %Query(ROWSPEC = "RepID:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmBed:%String,DischDate:%String,AdmDate:%String,SurvNumber:%String,EpisodeID:%String,EpisodeIDx:%String,PatientIDx:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,IdentityCode:%String,AdmTimes:%String,OBSCnt:%String,OperFlag:%String,CuteTypeID:%String,CuteType:%String,IROperDate:%String,IROperName:%String,IRSurvUser:%String,InfectionDr:%String,InfectionDesc:%String,InfCateDr:%String,InfCateDesc:%String,YYInfPos11Dr:%String,YYInfPos11Desc:%String,YYBacteria11Dr:%String,YYBacteria11Desc:%String,YYBacteria12Dr:%String,YYBacteria12Desc:%String,YYBacteria13Dr:%String,YYBacteria13Desc:%String,YYInfPos21Dr:%String,YYInfPos21Desc:%String,YYBacteria21Dr:%String,YYBacteria21Desc:%String,YYBacteria22Dr:%String,YYBacteria22Desc:%String,YYBacteria23Dr:%String,YYBacteria23Desc:%String,YYInfPos31Dr:%String,YYInfPos31Desc:%String,YYBacteria31Dr:%String,YYBacteria31Desc:%String,YYBacteria32Dr:%String,YYBacteria32Desc:%String,YYBacteria33Dr:%String,YYBacteria33Desc:%String,SQInfPos11Dr:%String,SQInfPos11Desc:%String,SQBacteria11Dr:%String,SQBacteria11Desc:%String,SQBacteria12Dr:%String,SQBacteria12Desc:%String,SQBacteria13Dr:%String,SQBacteria13Desc:%String,SQInfPos21Dr:%String,SQInfPos21Desc:%String,SQBacteria21Dr:%String,SQBacteria21Desc:%String,SQBacteria22Dr:%String,SQBacteria22Desc:%String,SQBacteria23Dr:%String,SQBacteria23Desc:%String,SQInfPos31Dr:%String,SQInfPos31Desc:%String,SQBacteria31Dr:%String,SQBacteria31Desc:%String,SQBacteria32Dr:%String,SQBacteria32Desc:%String,SQBacteria33Dr:%String,SQBacteria33Desc:%String,OprInfDr:%String,OprInfDesc:%String,IRBugsAntiSen:%String,IRAntiFlag:%String,IRAntiDrList:%String,PurposeDr:%String,PurposeDesc:%String,CombinDr:%String,CombinDesc:%String,IRAntiSenFlag:%String,IROperAntiFlag:%String,IRRepFinishFlag:%String,UpdateDate:%String,UpdateUserDesc:%String,InfPosDescs:%String,DiagnosDr:%String,DiagnosDesc:%String,FirInfDate:%String,IsVD:%String,IsANTVD:%String,HBVInf:%String,HCVInf:%String,HIVInf:%String,TPInf:%String,IsCa:%String,IsBloodMT:%String,IsTNB:%String,IsARF:%String,IsARI:%String,IsLC:%String,ISHM:%String,ISISD:%String,IsGlucocorticoid:%String,RepUser:%String,RepDate:%String,RepStatus:%String,IRCSSSpecGLFlag:%String,IRCSSSpecKSFlag:%String,IRCSSSpecMZFlag:%String,IRCSSSpecJYFlag:%String,IRBugsAntiSen1:%String,IRBugsAntiSen2:%String,IRBugsAntiSen3:%String,IRBugsAntiSen4:%String,IRBugsAntiSen5:%String,IRBugsAntiSen6:%String,IRBugsAntiSen7:%String,IRBugsAntiSen8:%String,IRBugsAntiSen9:%String,CSSRepDispalyItem:%String,SQMethod1:%String,SQMethod2:%String,SQMethod3:%String,SQMethod1Desc:%String,SQMethod2Desc:%String,SQMethod3Desc:%String") [ SqlProc ]
{
}

ClassMethod QryNewCSSByPaadmExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aSurNumber As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:(aEpisodeID="")||(aSurNumber="") $$$OK
 	
 	Set aHospIDs=""
	//Set Data = ..BuildPaadmData(aEpisodeID,aHospIDs,aSurNumber)
	Set objSExec = ##class(DHCHAI.IR.SurveyExec).GetObjById(aSurNumber)
	Quit:'$IsObject(objSExec) $$$OK
	Set aDateFrom 	= objSExec.SESurvSttDate    //调查表开始日期
	Set aDateTo 	= objSExec.SESurvEndDate	//调查表结束日期
	Set aSEID = objSExec.SESurvNumber

	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Set CSSRepDispalyItem=##class(DHCHAI.BT.Config).GetValByCode("CSSRepDispalyItemConfig","")
	Set objPaadm = ##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeID)
	Quit:'$isobject(objPaadm) $$$OK
	Set EpisodeIDx=objPaadm.PAEpisodeIDx
	Set SCode = $p(EpisodeIDx,"||",1)
	Set VisitStatus = objPaadm.PAVisitStatus
	Set VisitStatusInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"VisitStatus",VisitStatus)
	If VisitStatusInfo'="" {
		Set VisitStatus=$p(VisitStatusInfo,"^",2)
	}
	Quit:(VisitStatus="P")||(VisitStatus="C")||(VisitStatus="U") $$$OK //预住院P、在院A、出院D、退院C、作废U
	
	Set EpisodeIDx = objPaadm.PAEpisodeIDx
	Set PatientIDx = objPaadm.PAPatientIDx
	Set PapmiNo = objPaadm.PAPapmiNo
	Set MrNo = objPaadm.PAMrNo
	Set PatName = objPaadm.PAPatName
	Quit:('(PatName[$g(aPatName)))&&($g(aPatName)'="") $$$OK
	Quit:($g(aPapmiNo)'="")&&($g(aPapmiNo)'=PapmiNo) $$$OK
	Quit:($g(aMrNo)'="")&&($g(aMrNo)'=MrNo) $$$OK
	
	Set Sex = objPaadm.PASex
	Set Sex = $s(Sex="M":"男",Sex="F":"女",1:"")
	Set Nation = objPaadm.PANation
	Set Birthday = objPaadm.PABirthday
	Set:Birthday'="" Birthday = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(Birthday)
	Set Age = objPaadm.PAAge
	Set IdentityCode = objPaadm.PAIdentityCode
	Set HomeAddress = objPaadm.PAHomeAddress
	Set Company = objPaadm.PACompany
	Set RelativeName = objPaadm.PARelativeName
	Set RelativeTel = objPaadm.PARelativeTel
	Set IsDeath = objPaadm.PAIsDeath
	Set DeathDate = objPaadm.PADeathDate
	Set:DeathDate'="" DeathDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DeathDate)
	Set DeathTime = objPaadm.PADeathTime
	Set:DeathTime'="" DeathTime=$zt(DeathTime)
	Set AdmType = objPaadm.PAAdmType
	Set AdmDate = objPaadm.PAAdmDate
	Set:AdmDate'="" AdmDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
	Set AdmTime = objPaadm.PAAdmTime
	Set:AdmTime'="" AdmTime=$zt(AdmTime)
	Set objAdmLoc = objPaadm.PAAdmLocDr
	Set AdmTimes = objPaadm.PAAdmTimes
	Set AdmLocDesc=""
	If $isobject(objAdmLoc) {
		Set LocDesc2 = objAdmLoc.BTDesc2
		Set LocDesc = objAdmLoc.BTDesc
		Set AdmLocDesc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
		Set HospGroupID=""
		If $isobject(objPaadm.PAAdmLocDr.BTHospDr){
			Set HospID=objPaadm.PAAdmLocDr.BTHospDr.%Id()
			Quit:($g(aHospIDs)'="")&($listfind($g(aHospIDs),HospID)<1) return	//医院过滤
		}
	}
	Set objAdmWard = objPaadm.PAAdmWardDr
	Set AdmWardDesc=""
	If $isobject(objAdmWard) {
		Set WardDesc2 = objAdmWard.BTDesc2
		Set WardDesc = objAdmWard.BTDesc
		Set AdmWardDesc = $s(WardDesc2'="":WardDesc2,1:WardDesc)
	}
	
	Set AdmRoom = objPaadm.PAAdmRoom
	Set (AdmBedDr,AdmBed)=""
	If $IsObject(objPaadm.PAAdmBedDr){
		Set AdmBedDr=objPaadm.PAAdmBedDr.%Id()
		Set AdmBed=objPaadm.PAAdmBedDr.BTDesc
	}
	Set DischDate = objPaadm.PADischDate
	Set:DischDate'="" DischDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DischDate)
	Set DischTime = objPaadm.PADischTime
	Set:DischTime'="" DischTime=$zt(DischTime)
	Set objDischLoc = objPaadm.PADischLocDr
	Set DischLocDesc=""
	If $isobject(objDischLoc) {
		Set LocDesc2 = objDischLoc.BTDesc2
		Set LocDesc = objDischLoc.BTDesc
		Set DischLocDesc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
	}
	Set objDischWard = objPaadm.PADischWardDr
	Set DischWardDesc=""
	If $isobject(objDischWard) {
		Set WardDesc2 = objDischWard.BTDesc2
		Set WardDesc = objDischWard.BTDesc
		Set DischWardDesc = $s(WardDesc2'="":WardDesc2,1:WardDesc)
	}
	Set AdmDays = objPaadm.PAAdmDays
	if AdmDays=-1{
		Set AdmDays = (+$h)-objPaadm.PAAdmDate+1	//未出院患者计算入院到当天天数
	}
	Set IsNewBaby = objPaadm.PAIsNewBaby
	Set BirthWeight = objPaadm.PABirthWeight
	Set AdmitWeight = objPaadm.PAAdmitWeight
	
	//取报告横断面调查
	Set xRepID = ""
	//调查编号+患者唯一	
	Set xCSSID =$o(^DHCHAI.IR.INFCSSI("IndexSurEpisodeID"," "_aSurNumber,aEpisodeID,0)) 
	Set arrReport=##class(DHCHAI.IR.INFRepExt).GetINFReports("DHCHAI.IR.INFCSS",xCSSID)
	For indRep=1:1:arrReport.Count() {
		Set objRep=arrReport.GetAt(indRep)
		Continue:'$IsObject(objRep)
		Set xRepID=objRep.%Id()			
	}
	Set (RepUser,RepDate)=""
	Set (OperFlag,CuteTypeID,CuteType,IROperDate,IROperName,IRSurvUser,InfectionDr,InfectionDesc,InfCateDr,InfCateDesc)=""
	Set (IRInfPathogen1,IRInfPathogen2,IRInfPathogen3,IRComInfPathogen1,IRComInfPathogen2,IRComInfPathogen3)=""
	Set (OprInfDr,OprInfDesc,IRComInfPathogen1,IRComInfPathogen2,IRComInfPathogen3,IRBugsAntiSen,IRAntiFlag,IRAntiDrList,PurposeDr,PurposeDesc)=""
	Set (DiagnosDr,DiagnosDesc,CombinDr,CombinDesc,IRAntiSenFlag,IROperAntiFlag,IRRepFinishFlag,UpdateDate,UpdateUserDesc)=""
	Set (FirInfDate,IsVD,IsANTVD,HBVInf,HCVInf,HIVInf,TPInf,IsCa,IsBloodMT,IsTNB,IsARF,IsARI,IsLC,ISHM,ISISD,IsGlucocorticoid)=""
	Set (IRCSSSpecGLFlag,IRCSSSpecKSFlag,IRCSSSpecMZFlag,IRCSSSpecJYFlag)=""
	Set (IRBugsAntiSen1,IRBugsAntiSen2,IRBugsAntiSen3,IRBugsAntiSen4,IRBugsAntiSen5,IRBugsAntiSen6,IRBugsAntiSen7,IRBugsAntiSen8,IRBugsAntiSen9)=""
	Set (SQMethod1,SQMethod2,SQMethod3,SQMethod1Desc,SQMethod2Desc,SQMethod3Desc)=""	
	if (xRepID =""){
		//24小时内腹泻次数  针对的是当前日期
		Set xOBSToDate = +$h-1
		Set OBSCnt = ..GetKeyWordCntData(aEpisodeID,xOBSToDate,+$h,"MR-ObsDiarr","腹泻")
		Set:OBSCnt>0 OBSCnt=1
		//感染信息 现患的
		Set InfDias =""
		Set InfPosDescs = ""
		Set xID=""
		For {
			Set xID=$o(^DHCHAI.IR.INFDiagnosI("IndexPaadm",aEpisodeID,xID))
			Quit:xID=""
			
			Set obj=##class(DHCHAI.IR.INFDiagnos).GetObjById(xID)
			Continue:'$IsObject(obj)
			Continue:'$IsObject(obj.IRInfPosDr)
			Set InfDiagnosDr=obj.%Id()
			Set InfPosDr=obj.IRInfPosDr.%Id()
			Set InfPosDesc=obj.IRInfPosDr.BTDesc
			
			Set InfDate=obj.IRInfDate
			Continue:InfDate=""
			Set InfXDate=obj.IRInfXDate
			Set InfPosDesc=obj.IRInfPosDr.BTDesc
			Set InfSubDesc=""
			If $IsObject(obj.IRInfSubDr) {
				Set InfSubDesc=obj.IRInfSubDr.BTDesc
			}
			Set IsReportDiag=obj.IRIsReportDiag
			
			//Continue:InfDate>aDateFrom  //调查时未感染开始
			Continue:(+InfXDate'=0)&(InfXDate<=aDateFrom)  //感染转归日期小于调查日期即调查时已经结束
			Set listReports=##class(DHCHAI.IR.INFRepExt).GetINFReports("DHCHAI.IR.INFDiagnos",InfDiagnosDr)
			Set ReportCnt=listReports.Count()
			
			// 处理临床上报的感染诊断并且关联报告已经删除add by liyi 2017-12-06
			If (IsReportDiag=1)&&(ReportCnt<1){
				Continue
			}
			Set IRBacteria = obj.IRBacteria  //病原体#分割
			Set:InfDias'="" InfDias = InfDias_"#"_InfDiagnosDr_"^"_InfPosDesc_"^"_IRBacteria
			Set:InfDias="" InfDias = InfDiagnosDr_"^"_InfPosDesc_"^"_IRBacteria	
			Set:InfPosDescs'="" InfPosDescs = InfPosDescs _"#"_InfPosDesc
			Set:InfPosDescs="" InfPosDescs =InfPosDesc 			
		}
        //抗菌药物 用药目的(预防,治疗) 联合用药 是否送检
        Set IRAntiFlag =0,PurposeDesc ="",CombinDesc = "",IRAntiSenFlag =0
        Set AntInfo = ##class(DHCHAI.IRS.INFCSSSHSrv).GetAntInfo(aEpisodeID,aDateFrom,aDateTo)
        Set len=$l(AntInfo,$c(1))
        Set AntUsePurpose=""
        if (len>2){
            Set IRAntiFlag="是"
            Set xNum=$p(AntInfo,$c(1),2) //联用情况
            Set CombinDesc  = $s(xNum=1:"一联",xNum=2:"二联",xNum=3:"三联",xNum>=4:"四联及以上",1:"")
           
            for index1=3:1:len{
                Set PatInfo=$p(AntInfo,$c(1),index1)
                Continue:PatInfo="" 
                Set UsePurpose=$p(PatInfo,"^",2)  //用药目的
                Set:AntUsePurpose'[UsePurpose AntUsePurpose=AntUsePurpose_","_UsePurpose
            }
            Set:AntUsePurpose'="" AntUsePurpose=$e(AntUsePurpose,2,*)
        }
        Set CombinDr=##class(DHCHAI.BT.Dictionary).GetIDByDesc("IRCSSCombinedMed",CombinDesc)
        // 是否治疗前送检 AntIsInspected
        Set:AntUsePurpose["预防" PurposeDesc="预防用药"
        if (AntUsePurpose["治疗"){
            Set PurposeDesc="治疗用药"
            Set:AntUsePurpose["治疗" PurposeDesc="治疗+预防"
            Set PurposeDr=##class(DHCHAI.BT.Dictionary).GetIDByDesc("IRCSSPurpose",PurposeDesc)     //AntiMedPurpose
            Set LabInfoArr=##class(DHCHAI.STATV2.AbstractComm).GetLabInfo(aEpisodeID,"",aDateTo)
            Set:LabInfoArr.Count()>0 IRAntiSenFlag=1
        }
        
		//手术切口类型
        Set OperFlag = "",CuteTypeID = "",CuteType = ""
        /*Set xID = ""   //改为用户自填
        For {
            Set xID = $o(^DHCHAI.DP.OROperAnaesI("IndexEpisodeDr",aEpisodeID,xID))
            Quit:xID=""       
            Set OperAnaData = ##class(DHCHAI.DPS.OROperAnaesSrv).BuildOperData(xID,"")
            Continue:OperAnaData=""
            Set OperFlag    = 1
            Quit
        }  */     
	}Else {
		//取报告里的信息
		Set xObjRep = ##class(DHCHAI.IR.INFReport).GetObjById(xRepID)
		Quit:'$isobject(xObjRep) return
		Set objRepUser  = xObjRep.IRRepUser
		Set (RepUserID,RepUser)=""
		If $IsObject(objRepUser){
			Set RepUserID = objRepUser.%Id()
			Set RepUser = objRepUser.BTDesc
		}
		Set RepDate  = xObjRep.IRRepDate
		Set:RepDate'="" RepDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RepDate)
		Set LinkCSSs = xObjRep.GetRepLinkIDs("DHCHAI.IR.INFCSS")
		Quit:LinkCSSs="" return
		Set xObj = ##class(DHCHAI.IR.INFCSS).GetObjById(+LinkCSSs)  //子父表一对一
		Quit:'$IsObject(xObj) return
		//24小时内腹泻次数  针对的是当前日期
		Set xOBSToDate = +$h-1
		Set OBSCnt = ..GetKeyWordCntData(aEpisodeID,xOBSToDate,+$h,"MR-ObsDiarr","腹泻")
		Set:OBSCnt>0 OBSCnt=1
		//感染信息 现患的
		Set InfDias =""
		Set InfPosDescs = ""
		Set xID=""
		For {
			Set xID=$o(^DHCHAI.IR.INFDiagnosI("IndexPaadm",aEpisodeID,xID))
			Quit:xID=""
			
			Set obj=##class(DHCHAI.IR.INFDiagnos).GetObjById(xID)
			Continue:'$IsObject(obj)
			Continue:'$IsObject(obj.IRInfPosDr)
			Set InfDiagnosDr=obj.%Id()
			Set InfPosDr=obj.IRInfPosDr.%Id()
			Set InfPosDesc=obj.IRInfPosDr.BTDesc
			
			Set InfDate=obj.IRInfDate
			Continue:InfDate=""
			Set InfXDate=obj.IRInfXDate
			Set InfPosDesc=obj.IRInfPosDr.BTDesc
			Set InfSubDesc=""
			If $IsObject(obj.IRInfSubDr) {
				Set InfSubDesc=obj.IRInfSubDr.BTDesc
			}
			Set IsReportDiag=obj.IRIsReportDiag
			
			//Continue:InfDate>aDateFrom  //调查时未感染开始
			Continue:(+InfXDate'=0)&(InfXDate<=aDateFrom)  //感染转归日期小于调查日期即调查时已经结束
			Set listReports=##class(DHCHAI.IR.INFRepExt).GetINFReports("DHCHAI.IR.INFDiagnos",InfDiagnosDr)
			Set ReportCnt=listReports.Count()
			
			// 处理临床上报的感染诊断并且关联报告已经删除add by liyi 2017-12-06
			If (IsReportDiag=1)&&(ReportCnt<1){
				Continue
			}
			Set IRBacteria = obj.IRBacteria  //病原体#分割
			Set:InfDias'="" InfDias = InfDias_"#"_InfDiagnosDr_"^"_InfPosDesc_"^"_IRBacteria
			Set:InfDias="" InfDias = InfDiagnosDr_"^"_InfPosDesc_"^"_IRBacteria	
			Set:InfPosDescs'="" InfPosDescs = InfPosDescs _"#"_InfPosDesc
			Set:InfPosDescs="" InfPosDescs =InfPosDesc 			
		}
		Set OperFlag = xObj.IROperFlag      //是否手术
		Set CuteTypeID="",CuteType=""            //手术切口
		If $IsObject(xObj.IROperCuteTypeDr) {
			Set CuteTypeID = xObj.IROperCuteTypeDr.%Id()
			Set CuteType   = xObj.IROperCuteTypeDr.BTDesc
		}
		Set IROperDate = xObj.IROperDate
		Set:IROperDate'="" IROperDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(IROperDate)
		Set IROperName=xObj.IROperName
		
		Set IRSurvNumber=xObj.IRSurvNumber
		Set IRSurvUser=xObj.IRSurvUser
		Set IRInfectionDr=xObj.IRInfectionDr
		Set (InfectionDr,InfectionDesc)=""
		If ($IsObject(IRInfectionDr)){
			Set InfectionDr   = IRInfectionDr.%Id()
			Set InfectionDesc = IRInfectionDr.BTDesc	
		}
		Set (DiagnosDr,DiagnosDesc)=""
		If ($IsObject(xObj.IRCSSDiagnosDr)){
			Set DiagnosDr   = xObj.IRCSSDiagnosDr.%Id()
			Set DiagnosDesc = xObj.IRCSSDiagnosDr.BTDesc	
		}
		Set IRInfCategoryDr=xObj.IRInfCategoryDr
		Set (InfCateDr,InfCateDesc)=""
		If ($IsObject(IRInfCategoryDr)){
			Set InfCateDr   = IRInfCategoryDr.%Id()
			Set InfCateDesc = IRInfCategoryDr.BTDesc	
		}
		Set IRInfPathogen1=xObj.IRInfPathogen1
		Set IRInfPathogen2=xObj.IRInfPathogen2
		Set IRInfPathogen3=xObj.IRInfPathogen3
		
		Set SQMethod1 = xObj.SQMethod1
		Set SQMethod2 = xObj.SQMethod2
		Set SQMethod3 = xObj.SQMethod3
		Set SQMethod1Desc = $s(SQMethod1="1":"(外院发生)",SQMethod1="2":"(社区发生)",1:"")
		Set SQMethod2Desc = $s(SQMethod2="1":"(外院发生)",SQMethod2="2":"(社区发生)",1:"")
		Set SQMethod3Desc = $s(SQMethod3="1":"(外院发生)",SQMethod3="2":"(社区发生)",1:"")
		Set IROprInf=xObj.IROprInf
		Set (OprInfDr,OprInfDesc)=""
		If ($IsObject(IROprInf)){
			Set OprInfDr   = IROprInf.%Id()
			Set OprInfDesc = IROprInf.BTDesc	
		}
		Set IRComInfPathogen1=xObj.IRComInfPathogen1
		Set IRComInfPathogen2=xObj.IRComInfPathogen2
		Set IRComInfPathogen3=xObj.IRComInfPathogen3
		
		Set IRBugsAntiSen = xObj.IRBugsAntiSen
		If (IRBugsAntiSen'=""){
			Set IRBugsAntiSen1=$p(IRBugsAntiSen,"#",1)_"||"
			Set IRBugsAntiSen2=$p(IRBugsAntiSen,"#",2)_"||"
			Set IRBugsAntiSen3=$p(IRBugsAntiSen,"#",3)_"||"
			Set IRBugsAntiSen4=$p(IRBugsAntiSen,"#",4)_"||"
			Set IRBugsAntiSen5=$p(IRBugsAntiSen,"#",5)_"||"
			Set IRBugsAntiSen6=$p(IRBugsAntiSen,"#",6)_"||"
			Set IRBugsAntiSen7=$p(IRBugsAntiSen,"#",7)_"||"
			Set IRBugsAntiSen8=$p(IRBugsAntiSen,"#",8)_"||"
			Set IRBugsAntiSen9=$p(IRBugsAntiSen,"#",9)_"||"
		}
		Set IRAntiFlag = xObj.IRAntiFlag
		Set IRAntiDrList=xObj.IRAntiDrList
		Set IRAntiUsePurposeDr=xObj.IRAntiUsePurposeDr
		Set (PurposeDr,PurposeDesc)=""
		If ($IsObject(IRAntiUsePurposeDr)){
			Set PurposeDr   = IRAntiUsePurposeDr.%Id()
			Set PurposeDesc = IRAntiUsePurposeDr.BTDesc	
		}
		Set IRAntiCombinedMedDr=xObj.IRAntiCombinedMedDr
		Set (CombinDr,CombinDesc)=""
		If ($IsObject(IRAntiCombinedMedDr)){
			Set CombinDr   = IRAntiCombinedMedDr.%Id()
			Set CombinDesc = IRAntiCombinedMedDr.BTDesc	
		}
		
		Set IRAntiSenFlag=xObj.IRAntiSenFlag
		Set IROperAntiFlag=xObj.IROperAntiFlag
		Set IRRepFinishFlag=xObj.IRRepFinishFlag
		Set UpdateDate=xObj.IRUpdateDate
		Set:UpdateDate'="" UpdateDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(UpdateDate)
		Set IRUpdateUserDr=xObj.IRUpdateUserDr
		Set (UpdateUserDr,UpdateUserDesc)=""
		If ($IsObject(IRUpdateUserDr)){
			Set UpdateUserDr   = IRUpdateUserDr.%Id()
			Set UpdateUserDesc = IRUpdateUserDr.BTDesc	
		}
		Set FirInfDate = xObj.IRFirInfDate
		Set:FirInfDate'="" FirInfDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(FirInfDate)
		Set TransBloodInf=xObj.IRTransBloodInf
		if (TransBloodInf'=""){
			Set IsVD 	= $p(TransBloodInf,"#",1)
			Set IsANTVD = $p(TransBloodInf,"#",2)
			Set HBVInf 	= $p(TransBloodInf,"#",3)
			Set HCVInf	= $p(TransBloodInf,"#",4)
			Set HIVInf	= $p(TransBloodInf,"#",5)
			Set TPInf 	= $p(TransBloodInf,"#",6)
		}
		Set BaseRisk=xObj.IRBaseRisk
		if (BaseRisk'=""){
			Set IsCa	= $p(BaseRisk,"#",1)
			Set IsBloodMT = $p(BaseRisk,"#",2)
			Set IsTNB	= $p(BaseRisk,"#",3)
			Set IsARF	= $p(BaseRisk,"#",4)
			Set IsARI	= $p(BaseRisk,"#",5)
			Set IsLC	= $p(BaseRisk,"#",6)
			Set ISHM	= $p(BaseRisk,"#",7)
			Set ISISD	= $p(BaseRisk,"#",8)
			Set IsGlucocorticoid = $p(BaseRisk,"#",9)
		}
		Set IRCSSSpecGLFlag=xObj.IRCSSSpecGLFlag
		Set IRCSSSpecKSFlag=xObj.IRCSSSpecKSFlag
		Set IRCSSSpecMZFlag=xObj.IRCSSSpecMZFlag
		Set IRCSSSpecJYFlag=xObj.IRCSSSpecJYFlag
		
	}
	//取报告状态
	Set RepStatus=""
	If (xRepID'=""){
		Set RepData=$g(^DHCHAI.IR.INFReportD(xRepID))
		If (RepData'=""){
			Set RepStatusID=$li(RepData,8)
			If (RepStatusID'=""){
				Set RepStatusData=$g(^DHCHAI.BT.DictionaryD(RepStatusID))
				If (RepStatusData'=""){
					Set RepStatus=$li(RepStatusData,3)
				}
			}
		}
	}
	If (RepStatus=""){
		Set RepStatus="未调查"
	}
	elseIf (RepStatus="审核"){
		Set RepStatus="已审核"
	}
	else{
		Set RepStatus="已调查"
	}
		
	Set Data = $lb(xRepID,AdmLocDesc,AdmWardDesc,AdmBed,DischDate,AdmDate,SurvNumber,aEpisodeID,EpisodeIDx,PatientIDx,PapmiNo,MrNo,PatName,Sex,Age,IdentityCode,AdmTimes,OBSCnt)
	Set Data =Data_$lb(OperFlag,CuteTypeID,CuteType,IROperDate,IROperName,IRSurvUser,InfectionDr,InfectionDesc,InfCateDr,InfCateDesc)
	Set Data =Data_..BuildInfPathogen(IRInfPathogen1)				//(YYInfPos11Dr,YYInfPos11Desc,YYBacteria11Dr,YYBacteria11Desc,YYBacteria12Dr,YYBacteria12Desc,YYBacteria13Dr,YYBacteria13Desc)
	Set Data =Data_..BuildInfPathogen(IRInfPathogen2)
	Set Data =Data_..BuildInfPathogen(IRInfPathogen3)
	Set Data =Data_..BuildInfPathogen(IRComInfPathogen1)   			//(SQInfPos11Dr,SQInfPos11Desc,SQBacteria11Dr,SQBacteria11Desc,SQBacteria12Dr,SQBacteria12Desc,SQBacteria13Dr,SQBacteria13Desc)
	Set Data =Data_..BuildInfPathogen(IRComInfPathogen2)
	Set Data =Data_..BuildInfPathogen(IRComInfPathogen3)
	Set Data =Data_$lb(OprInfDr,OprInfDesc,IRBugsAntiSen,IRAntiFlag,IRAntiDrList,PurposeDr,PurposeDesc)
	Set Data =Data_$lb(CombinDr,CombinDesc,IRAntiSenFlag,IROperAntiFlag,IRRepFinishFlag,UpdateDate,UpdateUserDesc,InfPosDescs,DiagnosDr,DiagnosDesc)
	Set Data = Data_$lb(FirInfDate,IsVD,IsANTVD,HBVInf,HCVInf,HIVInf,TPInf,IsCa,IsBloodMT,IsTNB,IsARF,IsARI,IsLC,ISHM,ISISD,IsGlucocorticoid,RepUser,RepDate)
	Set Data = Data_$lb(RepStatus,IRCSSSpecGLFlag,IRCSSSpecKSFlag,IRCSSSpecMZFlag,IRCSSSpecJYFlag,IRBugsAntiSen1,IRBugsAntiSen2,IRBugsAntiSen3,IRBugsAntiSen4,IRBugsAntiSen5,IRBugsAntiSen6,IRBugsAntiSen7,IRBugsAntiSen8,IRBugsAntiSen9,CSSRepDispalyItem,SQMethod1,SQMethod2,SQMethod3,SQMethod1Desc,SQMethod2Desc,SQMethod3Desc)
	
	Quit:Data="" $$$OK 		
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1	
 		
	Quit $$$OK
}

ClassMethod QryNewCSSByPaadmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryNewCSSByPaadmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryNewCSSByPaadmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryNewCSSByPaadmExecute ]
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

/// Creator：     liuzhenhe
/// CreatDate：   2020-10
/// Description:  横断面病例查询 提取感染诊断部位和病原体
/// Return：      返回ROWSPEC
/// S list =  ##class(DHCHAI.IRS.INFCSSSrv).BuildInfPathogen("1#2#3#4#5#6")
ClassMethod BuildInfPathogen(aInfPathogen As %String, aSeparete As %String = "#") As %String
{
	New (aInfPathogen,aSeparete)

	Set (InfPosDr,InfPosDesc,Bacteria1Dr,Bacteria1Desc,Bacteria2Dr,Bacteria2Desc,Bacteria3Dr,Bacteria3Desc)=""
	Set InfPosDr = $p(aInfPathogen,aSeparete,1)
    Set CSSRepPosDispalyConfig=##class(DHCHAI.BT.Config).GetValByCode("CSSRepPosDispalyConfig")     //根据CSS配置取感染部位
    if (+CSSRepPosDispalyConfig=0){
         Set:InfPosDr'="" InfPosDesc=$lg($g(^DHCHAI.BT.DictionaryD(InfPosDr)),3)
    }else{
        Set objInfPos = ##class(DHCHAI.BT.InfPos).GetObjById(InfPosDr)
        Set:$IsObject(objInfPos) InfPosDesc = objInfPos.BTDesc
    }
	Set Bacteria1Dr = $p(aInfPathogen,aSeparete,2)
	Set objBacteria = ##class(DHCHAI.DP.LabBacteria).GetObjById(Bacteria1Dr)
	Set:$IsObject(objBacteria) Bacteria1Desc = objBacteria.BTBacDesc
	
	Set Bacteria2Dr = $p(aInfPathogen,aSeparete,4)
	Set objBacteria = ##class(DHCHAI.DP.LabBacteria).GetObjById(Bacteria2Dr)
	Set:$IsObject(objBacteria) Bacteria2Desc = objBacteria.BTBacDesc
	
	Set Bacteria3Dr = $p(aInfPathogen,aSeparete,6)
	Set objBacteria = ##class(DHCHAI.DP.LabBacteria).GetObjById(Bacteria3Dr)
	Set:$IsObject(objBacteria) Bacteria3Desc = objBacteria.BTBacDesc
	
	Set return=$lb(InfPosDr,InfPosDesc,Bacteria1Dr,Bacteria1Desc,Bacteria2Dr,Bacteria2Desc,Bacteria3Dr,Bacteria3Desc)		
	Quit return
}

}
