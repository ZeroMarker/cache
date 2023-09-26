/// 名称: DHCHAI.IRS.BPSurverySrv
/// 描述: 血透个案调查相关服务
/// 编写者: zhoubo
/// 编写日期: 2022-10-20
Class DHCHAI.IRS.BPSurverySrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2022-10-23
/// Description:  保存报告
/// Input：       aRepInfo：主表信息
/// 			  aRegComRep： 扩展表信息
/// 			  aRepLog ：日志
/// Return:		  return>0:成功、return<1:失败 
/// Debug:		  w ##class(DHCHAI.IRS.BPSurverySrv).SaveBPReport(1,1,1)
ClassMethod SaveBPReport(aRepInfo As %String, aRegComRep As %Text, aRepLog As %String) As %String
{
	Set return = ""
	New (aRepInfo,aRegComRep,aRepLog)
	TStart
	
	// 主表信息
	Set StatusCode = $p(aRepInfo,$c(1),10)
	Set StatusDr   = ""
	Set objStatus=##class(DHCHAI.BT.Dictionary).GetObjByCode("InfReportStatus",StatusCode)
	Set:$IsObject(objStatus) StatusDr=objStatus.%Id()
	Set $p(aRepInfo,$c(1),10)=StatusDr
	if StatusDr="" {
		Trollback
		Set return = -1
		Quit return
	}
	Set ret = ##class(DHCHAI.IR.BPSurvery).Update(aRepInfo,$c(1))
	if ret<1{
		Trollback
		Set return = -2
		Quit return
	}else{
		Set ReportID = +ret
	}
	// 扩展包信息
	Set flg=1
	For Ind = 1:1:$L(aRegComRep,"&"){
		Set RegComStr = $p(aRegComRep,"&",Ind)
		Continue:RegComStr=""
		Set $p(RegComStr,"^",3)=ReportID
		Set ret = ##Class(DHCHAI.IR.ComTempRep).Update(RegComStr,"^")
		If ret<1 {
			Set flg=0
		}
	}
	if flg=0{
		Trollback
		Set return = -3
		Quit return
	}
	// 日志
	Set $p(aRepLog,$c(1),1) = ReportID
	Set $p(aRepLog,$c(1),3) = StatusDr
	Set ret = ##class(DHCHAI.IR.BPSurvLog).Update(aRepLog,$c(1))
	if ret<1{
		Trollback
		Set return = -4
		Quit return
	}
	
	Tcommit
	Set return = ReportID
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2022-10-23
/// Description:  保存报告状态
/// Input：       aRepLog：状态变更日志信息
/// Return:		  return>0:成功、return<1:失败 
/// Debug:		  w ##class(DHCHAI.IRS.BPSurverySrv).SaveReportStatus(aRepLog)
ClassMethod SaveReportStatus(aRepLog As %String, separete As %String) As %String
{
	New (aRepLog,separete)
	Set return=""
	Quit:(aRepLog="")||(separete="") return
	
	Set ReportID = $p(aRepLog,separete,1)
	Quit:ReportID="" return
	TStart
	Set flg =1
	Set StatusCode = $p(aRepLog,separete,3)
	Set objStatus=##class(DHCHAI.BT.Dictionary).GetObjByCode("InfReportStatus",StatusCode)
	If $IsObject(objStatus){
		Set $p(aRepLog,separete,3)=objStatus.%Id()
	}
	Set obj=##class(DHCHAI.IR.BPSurvery).%OpenId(ReportID)
	Set obj.BPStatusDr = objStatus
	
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //保存失败
   		Set flg=0
	}
	Do obj.%Close()
	if flg=0{
		Trollback
		Quit return
	}
	
	// 日志
	Set ret = ##class(DHCHAI.IR.BPSurvLog).Update(aRepLog,separete)
	if ret<1{
		Trollback
		Quit return
	}
	
	TCommit
	Set return = 1
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2022-10-24
/// Description:  批量审核报告状态
/// Input：       aRepLog：状态变更日志信息
/// Return:		  return>0:成功、return<1:失败 
/// Debug:		  w ##class(DHCHAI.IRS.BPSurverySrv).SaveBPRepStatus()
ClassMethod SaveBPRepStatus(aReportIDs As %String, aStatusCode As %String) As %String
{
	New (aReportIDs,aStatusCode)
	Set return=""
	Quit:(aReportIDs="")||(aStatusCode="") return
	TStart
	Set isError=0
	For indRep=1:1:$l(aReportIDs,","){
		Set ReportID=$p(aReportIDs,",",indRep)
		Continue:ReportID=""
		
		Set objRep = ##class(DHCHAI.IR.BPSurvery).GetObjById(ReportID)
		Continue:'$IsObject(objRep)
		
		Set objStatus=##class(DHCHAI.BT.Dictionary).GetObjByCode("InfReportStatus",aStatusCode)
		Continue:'$IsObject(objStatus)
		Set obj=##class(DHCHAI.IR.BPSurvery).%OpenId(ReportID)
		Set obj.BPStatusDr = objStatus
		
		Set sc=obj.%Save()
		Set flg=1
		If $system.Status.IsError(sc) {        //保存失败
	   		Set flg=0
		}
		Do obj.%Close()
		if flg=0{
			Trollback
			Quit
		}
	}
	Quit:isError>0 return
	TCommit
	Set return=1
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2022-10-21
/// Description:  查询单个患者血透信息
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.BPSurverySrv","QryAdmInfo","5",1)
Query QryAdmInfo(aBPRegID As %String, aSurvNumber As %String) As %Query(ROWSPEC = "BPRegID:%String,PABPRegID:%String,PAEpisodeID:%String,PAPatientID:%String,PAMrNo:%String,PAPatName:%String,PapmiNo:%String,PAPatSex:%String,PAPatAge:%String,PAPatType:%String,PABirthday:%String,PARelTel:%String,PAHDTime:%String,PAAdmDoc:%String,PAAdmNurse:%String,PAEpiInfo:%String,PABPPatType:%String,PADiagnosis:%String,BAccessType:%String,PAStartDate:%String,PAEndDate:%String,PAStatusDate:%String,PAStatusTime:%String,PARegDate:%String,PARegTime:%String,AdmLocID:%String,AdmLocDesc:%String,PAIsActive:%String,BPSurvID:%String,BPStatusDr:%String,RepStatus:%String,BPRegDate:%String,BPRegTime:%String,BPRegLocDr:%String,BPRegLocDesc:%String,BPRegUserDr:%String,BPRegUserDesc:%String,SurvNumberID:%String,RepStatusCode:%String") [ SqlProc ]
{
}

ClassMethod QryAdmInfoExecute(ByRef qHandle As %Binary, aBPRegID As %String, aSurvNumber As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:((aBPRegID="")||(aSurvNumber="")) $$$OK
 	
	Set BPRegData=$g(^MA.HAI.DP.BPRegisterD(aBPRegID))
	Quit:BPRegData="" $$$OK
	Set PABPRegID    = $li(BPRegData,2) 
	Set PAEpisodeID  = $li(BPRegData,3) 
	Set PAPatientID	 = $li(BPRegData,4)
	Set PAMrNo		 = $li(BPRegData,5)
	Set PAPatName	 = $li(BPRegData,6)
	Set PAPatSex	 = $li(BPRegData,7)
	Set PAPatAge	 = $li(BPRegData,8)
	Set PAPatType	 = $li(BPRegData,9)
	Set PABirthday	 = $li(BPRegData,10)
	Set PARelTel	 = $li(BPRegData,11)
	Set PAAdmLoc	 = $li(BPRegData,12)
	Set PAHDTime     = $li(BPRegData,13)
	Set PAAdmDoc	 = $li(BPRegData,14)
	Set PAAdmNurse	 = $li(BPRegData,15)
	Set PAEpiInfo    = $li(BPRegData,16)
	Set PABPPatType  = $li(BPRegData,17)
	Set PADiagnosis  = $li(BPRegData,18)
	Set PAStartDate  = $li(BPRegData,19)
	Set PAEndDate    = $li(BPRegData,20)
	Set PAStatusDate = $li(BPRegData,21)
	Set PAStatusTime = $li(BPRegData,22)
	Set PARegDate    = $li(BPRegData,23)
	Set PARegTime    = $li(BPRegData,24)
	Set PAIsActive   = $li(BPRegData,25)
	Set PapmiNo=""
	If (PAPatientID'=""){
		Set PapmiNo = $p($g(^PAPER(PAPatientID,"PAT",1)),"^",1)
	}
	Set PAStartDate  = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(PAStartDate)
	Set PAEndDate    = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(PAEndDate)
	Set PAStatusDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(PAStatusDate)
	Set PARegDate    = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(PARegDate)
	Set PAPatSex     = $s(PAPatSex="M":"男",PAPatSex="F":"女",1:"")
	Set PABirthday   = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(PABirthday)
	Set PAPatType    = $s(PAPatType="O":"门诊",PAPatType="E":"急症",PAPatType="EP":"急诊留观",PAPatType="I":"住院",1:"")
	Set PAIsActive   = $s(PAIsActive="1":"是",1:"否")
	Set:PAStatusTime'="" PAStatusTime=$zt(PAStatusTime,1)
	Set:PARegTime'="" PARegTime=$zt(PARegTime,1)
	
	Set AdmLocID=PAAdmLoc,AdmLocDesc=""
	If (AdmLocID'=""){
		Set LocData = $g(^DHCHAI.BT.LocationD(AdmLocID))
		If (LocData'=""){
			Set HospDr = $li(LocData,8)
			Set AdmLocDesc = $li(LocData,3)
		}
	}
	If (PAAdmDoc'=""){
		Set PAAdmDoc = $p(PAAdmDoc,"|",3)
	}
	If (PAAdmNurse'=""){
		Set PAAdmNurse = $p(PAAdmNurse,"|",3)
	}
	Set BAccessType=""  // 血管通路类型
	Set xBPAccID = ""
	For {
		Set xBPAccID = $o(^MA.HAI.DP.BPAccessTypeI("IndexBARegAccessID",aBPRegID,xBPAccID),-1)
		Quit:xBPAccID=""
		Set BPAccData=$g(^MA.HAI.DP.BPAccessTypeD(xBPAccID))
		Continue:BPAccData=""
		Set BAStatus = $li(BPAccData,6)
		Continue:BAStatus'="使用"
		Set BAccessTypeDr = $li(BPAccData,4)
		If (BAccessTypeDr'=""){
			Set AccessTypeData = $g(^DHCHAI.BT.DictionaryD(BAccessTypeDr))
			If (AccessTypeData'=""){
				Set BAccessType = $li(AccessTypeData,3)
			}
		}
		Quit:BAccessType'=""
	}
	
	Set (BPStatusDr,RepStatus,RepStatusCode,BPRegDate,BPRegTime,BPRegLocDr,BPRegLocDesc,BPRegUserDr,BPRegUserDesc)=""
	//调查编号+血透登记唯一	
    Set xBPSurvID =$o(^MA.HAI.IR.BPSurveryI("IndexSurBPRegDr"," "_aSurvNumber,aBPRegID,0)) 
    If (xBPSurvID'=""){
		Set BPSurvData = $g(^MA.HAI.IR.BPSurveryD(xBPSurvID))
		If (BPSurvData'=""){
			Set BPRegDate  = $li(BPSurvData,6)
			Set BPRegDate  = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(BPRegDate)
			Set BPRegTime  = $li(BPSurvData,7)
			Set:BPRegTime'="" BPRegTime=$zt(BPRegTime,1)
			Set BPRegLocDr = $li(BPSurvData,8)
			If (BPRegLocDr'=""){
				Set LocData = $g(^DHCHAI.BT.LocationD(BPRegLocDr))
				If (LocData'=""){
					Set BPRegLocDesc = $li(LocData,3)
				}
			}
			Set BPRegUserDr = $li(BPSurvData,9)
			If (BPRegUserDr'=""){
				Set UserData = $g(^DHCHAI.BT.SysUserD(BPRegUserDr))
				If (UserData'=""){
					Set BPRegUserDesc = $li(UserData,3)
				}
			}
			Set BPStatusDr = $li(BPSurvData,10)
			If (BPStatusDr'=""){
				Set StatusData = $g(^DHCHAI.BT.DictionaryD(BPStatusDr))
				If (StatusData'=""){
					Set RepStatusCode = $li(StatusData,2)
					Set RepStatus = $li(StatusData,3)
				}
			}
		}
	}
	Set BPSurvID = xBPSurvID
	
	If ((RepStatus="")||(RepStatus="删除")){
		Set RepStatus="未调查"
	}
	elseIf (RepStatus="审核"){
		Set RepStatus="已审核"
	}
	else{
		Set RepStatus="已调查"
	}
	
	Set Data=$lb(aBPRegID,PABPRegID,PAEpisodeID,PAPatientID,PAMrNo,PAPatName,PapmiNo,PAPatSex,PAPatAge,PAPatType,PABirthday,PARelTel,PAHDTime,PAAdmDoc,PAAdmNurse,PAEpiInfo,PABPPatType,PADiagnosis,BAccessType,PAStartDate,PAEndDate,PAStatusDate,PAStatusTime,PARegDate,PARegTime,AdmLocID,AdmLocDesc,PAIsActive,BPSurvID,BPStatusDr,RepStatus,BPRegDate,BPRegTime,BPRegLocDr,BPRegLocDesc,BPRegUserDr,BPRegUserDesc,SurvNumberID,RepStatusCode)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
		
	Quit $$$OK
}

ClassMethod QryAdmInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAdmInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAdmInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAdmInfoExecute ]
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
/// CreatDate：   2022-10-20
/// Description:  查询血透病例列表[以0点在院为准]
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.BPSurverySrv","QryBPPatList","^^^3^^^^")
Query QryBPPatList(aIntputs As %String, aSearch As %String = "") As %Query(ROWSPEC = "BPRegID:%String,PABPRegID:%String,PAEpisodeID:%String,PAPatientID:%String,PAMrNo:%String,PAPatName:%String,PapmiNo:%String,PAPatSex:%String,PAPatAge:%String,PAPatType:%String,PABirthday:%String,PARelTel:%String,PAHDTime:%String,PAAdmDoc:%String,PAAdmNurse:%String,PAEpiInfo:%String,PABPPatType:%String,PADiagnosis:%String,BAccessType:%String,PAStartDate:%String,PAEndDate:%String,PAStatusDate:%String,PAStatusTime:%String,PARegDate:%String,PARegTime:%String,AdmLocID:%String,AdmLocDesc:%String,PAIsActive:%String,BPSurvID:%String,BPStatusDr:%String,RepStatus:%String,BPRegDate:%String,BPRegLocDr:%String,BPRegLocDesc:%String,BPRegUserDr:%String,BPRegUserDesc:%String,SurvNumberID:%String,RepStatusCode:%String") [ SqlProc ]
{
}

ClassMethod QryBPPatListExecute(ByRef qHandle As %Binary, aIntputs As %String, aSearch As %String = "") As %Status
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
 	Set:aStatus="1" aStatus="未调查"
 	Set:aStatus="2" aStatus="已调查"
 	Set:aStatus="3" aStatus="已审核"
 	Quit:(aSEID="") $$$OK
 	Set:((aSearch=1)||(aSearch=2)) aSearch=""
 	Set SurvNumberID = aSEID
 	//调查院区
 	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
 	//通过'调查编号'取'调查开始日期'和'调查结束日期'
 	Set SExecData=$g(^CT.MA.HAI.IR.BPSurveyExecD(SurvNumberID))
 	Quit:SExecData="" $$$OK
 	Set aDateFrom 	= $li(SExecData,5)  
 	Set aDateTo 	= $li(SExecData,6)  
 	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	
	// 维护血透室科室ID
	Set BDLocIDs=##class(DHCHAI.BT.Config).GetValByCode("BloodDialysisLocIDs")
	// 血透患者数据来源1：血透系统  2：血透室(PABPRegID血透记录ID即就诊ID)
	Set IsBPPatSource=##class(DHCHAI.BT.Config).GetValByCode("IsBPPatSource")
	// 血透个案调查对象1：调查期间进行血透的患者，2：调查期间在血透室的患者
	Set BDSurveObject=##class(DHCHAI.BT.Config).GetValByCode("BDSurveObject")
	
 	//调查科室(为空查询全部科室)
 	Set:aWardID'="" aLocationID=aWardID
 	
	Set xPaadms =""
	//定义临时Gloabl
	Set NIndex="QryBPPatList"
	Kill ^TMP($zn,$j,NIndex)
	If (IsBPPatSource=1){
		// 血透调查病人列表
		Set xBPRegID = ""
		For {
			Set xBPRegID = $o(^MA.HAI.DP.BPRegisterD(xBPRegID))
			Quit:xBPRegID=""
			
			Do BuildBPData
		}
	}Else{
		// 走血透室
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
			Continue:$d(^TMP($zn,$j,NIndex,"AdmPat",Paadm)) // 避免重复取重复病人
			Set ^TMP($zn,$j,NIndex,"AdmPat",Paadm)=""
			Set LocFlag=0
			If (BDLocIDs'=""){
				Set LocLinks=##class(DHCHAI.BT.LocationLink).GetLocLinks(LocID)
				Set:LocLinks="" LocLinks=LocID
				For xi=1:1:$l(LocLinks,"|"){
					Set xLocID=$p(LocLinks,"|",xi)
					Continue:xLocID=""
					If (((","_BDLocIDs_",")[(","_xLocID_","))||((","_BDLocIDs_",")[(","_LocID_","))){
						Set LocFlag=1
					}
				}
				Continue:LocFlag'=1
			}
			Set xBPRegID = $o(^MA.HAI.DP.BPRegisterI("IndexBPRegID"," "_Paadm,0))
			Set ObjReg = ##class(DHCHAI.DP.BPRegister).GetObjById(xBPRegID)
			Continue:'$IsObject(ObjReg)
			Do BuildBPData
	    }
	}
 	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
BuildBPData
	Set BPRegData=$g(^MA.HAI.DP.BPRegisterD(xBPRegID))
	Quit:BPRegData=""
	Set PABPRegID    = $li(BPRegData,2) 
	Set PAEpisodeID  = $li(BPRegData,3) 
	Set PAPatientID	 = $li(BPRegData,4)
	Set PAMrNo		 = $li(BPRegData,5)
	Set PAPatName	 = $li(BPRegData,6)
	Set PAPatSex	 = $li(BPRegData,7)
	Set PAPatAge	 = $li(BPRegData,8)
	Set PAPatType	 = $li(BPRegData,9)
	Set PABirthday	 = $li(BPRegData,10)
	Set PARelTel	 = $li(BPRegData,11)
	Set PAAdmLoc	 = $li(BPRegData,12)
	Set PAHDTime     = $li(BPRegData,13)
	Set PAAdmDoc	 = $li(BPRegData,14)
	Set PAAdmNurse	 = $li(BPRegData,15)
	Set PAEpiInfo    = $li(BPRegData,16)
	Set PABPPatType  = $li(BPRegData,17)
	Set PADiagnosis  = $li(BPRegData,18)
	Set PAStartDate  = $li(BPRegData,19)
	Set PAEndDate    = $li(BPRegData,20)
	Set PAStatusDate = $li(BPRegData,21)
	Set PAStatusTime = $li(BPRegData,22)
	Set PARegDate    = $li(BPRegData,23)
	Set PARegTime    = $li(BPRegData,24)
	Set PAIsActive   = $li(BPRegData,25)
	Set PapmiNo=""
	If (PAPatientID'=""){
		Set PapmiNo = $p($g(^PAPER(PAPatientID,"PAT",1)),"^",1)
	}
	If (IsBPPatSource=1){
		// 血透系统，透析在查询期间
		Quit:(((PAEndDate'="")&&(PAEndDate<aDateFrom))||(PAStartDate>aDateTo))  // 日期过滤
	}
	Quit:(aSearch'="")&&(PAPatName'[aSearch)&&(PAMrNo'[aSearch)
	Quit:(aPatName'="")&&(PAPatName'[aPatName)
	Quit:(aPapmiNo'="")&&(PapmiNo'="")&&(aPapmiNo'[PapmiNo)
	Quit:(aPapmiNo'="")&&(PapmiNo="")
	Quit:(aMrNo'="")&&(aMrNo'[PAMrNo)
	Set PAStartDate  = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(PAStartDate)
	Set PAEndDate    = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(PAEndDate)
	Set PAStatusDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(PAStatusDate)
	Set PARegDate    = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(PARegDate)
	Set PAPatSex     = $s(PAPatSex="M":"男",PAPatSex="F":"女",1:"")
	Set PABirthday   = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(PABirthday)
	Set PAPatType    = $s(PAPatType="O":"门诊",PAPatType="E":"急诊",PAPatType="EP":"急诊留观",PAPatType="I":"住院",1:"")
	Set PAIsActive   = $s(PAIsActive="1":"是",1:"否")
	Set:PAStatusTime'="" PAStatusTime=$zt(PAStatusTime,1)
	Set:PARegTime'="" PARegTime=$zt(PARegTime,1)
	If (BDSurveObject=1){
		// 判断患者在调查期间是否进行透析
		Set RecordID="",HDDoDate=""
		Set xRecordID = ""
		For {
			Set xRecordID = $o(^MA.HAI.DP.BPRecordI("IndexHDBPRegID",xBPRegID,xRecordID),-1)
			Quit:xRecordID=""
			Set RecordData=$g(^MA.HAI.DP.BPRecordD(xRecordID))
			Continue:RecordData=""
			Set HDDoDate = $li(RecordData,7)
			Continue:((HDDoDate<aDateFrom)||(HDDoDate>aDateTo))  // 日期过滤
			Set RecordID = xRecordID
			Quit
		}
		Quit:RecordID=""  //在调查期间没有透析记录
	}
	
	Set AdmLocID=PAAdmLoc,AdmLocDesc=""
	If (AdmLocID'=""){
		Set LocData = $g(^DHCHAI.BT.LocationD(AdmLocID))
		If (LocData'=""){
			Set HospDr = $li(LocData,8)
			Quit:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1)
			Set AdmLocDesc = $li(LocData,3)
		}
	}
	Quit:(aLocationID'="")&&((","_aLocationID_",")'[(","_AdmLocID_","))
	If (PAAdmDoc'=""){
		Set PAAdmDoc = $p(PAAdmDoc,"|",3)
	}
	If (PAAdmNurse'=""){
		Set PAAdmNurse = $p(PAAdmNurse,"|",3)
	}
	Set BAccessType=""  // 血管通路类型
	Set xBPAccID = ""
	For {
		Set xBPAccID = $o(^MA.HAI.DP.BPAccessTypeI("IndexBARegAccessID",xBPRegID,xBPAccID),-1)
		Quit:xBPAccID=""
		Set BPAccData=$g(^MA.HAI.DP.BPAccessTypeD(xBPAccID))
		Continue:BPAccData=""
		Set BAStatus = $li(BPAccData,6)
		Continue:BAStatus'="使用"
		Set BAccessTypeDr = $li(BPAccData,4)
		If (BAccessTypeDr'=""){
			Set AccessTypeData = $g(^DHCHAI.BT.DictionaryD(BAccessTypeDr))
			If (AccessTypeData'=""){
				Set BAccessType = $li(AccessTypeData,3)
			}
		}
		Quit:BAccessType'=""
	}
	
	Set (BPStatusDr,RepStatus,RepStatusCode,BPRegDate,BPRegLocDr,BPRegLocDesc,BPRegUserDr,BPRegUserDesc)=""
	//调查编号+血透登记唯一	
    Set xBPSurvID =$o(^MA.HAI.IR.BPSurveryI("IndexSurBPRegDr"," "_aSEID,xBPRegID,0))
    If (xBPSurvID'=""){
		Set BPSurvData = $g(^MA.HAI.IR.BPSurveryD(xBPSurvID))
		If (BPSurvData'=""){
			Set BPRegDate  = $li(BPSurvData,6)
			Set BPRegDate  = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(BPRegDate)
			Set BPRegLocDr = $li(BPSurvData,8)
			If (BPRegLocDr'=""){
				Set LocData = $g(^DHCHAI.BT.LocationD(BPRegLocDr))
				If (LocData'=""){
					Set BPRegLocDesc = $li(LocData,3)
				}
			}
			Set BPRegUserDr = $li(BPSurvData,9)
			If (BPRegUserDr'=""){
				Set UserData = $g(^DHCHAI.BT.SysUserD(BPRegUserDr))
				If (UserData'=""){
					Set BPRegUserDesc = $li(UserData,3)
				}
			}
			Set BPStatusDr = $li(BPSurvData,10)
			If (BPStatusDr'=""){
				Set StatusData = $g(^DHCHAI.BT.DictionaryD(BPStatusDr))
				If (StatusData'=""){
					Set RepStatusCode = $li(StatusData,2)
					Set RepStatus = $li(StatusData,3)
				}
			}
		}
	}
	Set BPSurvID = xBPSurvID
	
	If ((RepStatus="")||(RepStatus="删除")){
		Set RepStatus="未调查"
	}elseIf (RepStatus="审核"){
		Set RepStatus="已审核"
	}else{
		Set RepStatus="已调查"
	}
	Quit:(aStatus'="")&&(aStatus'=RepStatus)
	//多语言处理
	Set PAPatSex=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTSEXDesc",PAPatSex,"User.CTSex")  //性别
	Set:PAPatAge["岁" PAPatAge=$Replace(PAPatAge,"岁",##class(DHCHAI.Abstract).TranslationGet("Bill.Com.Age","岁"))  //年龄
	Set:PAPatAge["月" PAPatAge=$Replace(PAPatAge,"月",##class(DHCHAI.Abstract).TranslationGet("Bill.Com.Age","月"))
	Set:PAPatAge["天" PAPatAge=$Replace(PAPatAge,"天",##class(DHCHAI.Abstract).TranslationGet("Bill.Com.Age","天"))
	Set BAccessType = ##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",BAccessType,"DHCHAI.BT.Dictionary")
	Set PAAdmDoc = ##Class(DHCHAI.Abstract).HAIGetTranByDesc("SSUSRName",PAAdmDoc,"User.SSUser")
	Set PAPatType=##Class(DHCHAI.Abstract).TranslationGet("dhcma.hai.ir.bpsurvery.csp",PAPatType)
	Set PAAdmNurse = ##Class(DHCHAI.Abstract).HAIGetTranByDesc("SSUSRName",PAAdmNurse,"User.SSUser")
	Set PAEpiInfo=##Class(DHCHAI.Abstract).TranslationGet("dhcma.hai.ir.bpsurvery.csp",PAEpiInfo)
	Set PABPPatType=##Class(DHCHAI.Abstract).TranslationGet("dhcma.hai.ir.bpsurvery.csp",PABPPatType)
	Set PADiagnosis = ##Class(DHCHAI.Abstract).HAIGetTranByDesc("MRCIDDesc",PADiagnosis,"User.MRCICDDx")
	Set PAIsActive = ##Class(DHCHAI.Abstract).TranslationGet("dhcma.hai.ir.bpsurvery.csp",PAIsActive)
	Set AdmLocDesc = ##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",AdmLocDesc,"User.CTLoc")
	Set BPRegLocDesc = ##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",BPRegLocDesc,"User.CTLoc")
	Set RepStatus=##Class(DHCHAI.Abstract).TranslationGet("dhcma.hai.ir.bpsurvery.csp",RepStatus)
	Set BPRegUserDesc = ##Class(DHCHAI.Abstract).HAIGetTranByDesc("SSUSRName",BPRegUserDesc,"User.SSUser")
	
	Set Data=$lb(xBPRegID,PABPRegID,PAEpisodeID,PAPatientID,PAMrNo,PAPatName,PapmiNo,PAPatSex,PAPatAge,PAPatType,PABirthday,PARelTel,PAHDTime,PAAdmDoc,PAAdmNurse,PAEpiInfo,PABPPatType,PADiagnosis,BAccessType,PAStartDate,PAEndDate,PAStatusDate,PAStatusTime,PARegDate,PARegTime,AdmLocID,AdmLocDesc,PAIsActive,BPSurvID,BPStatusDr,RepStatus,BPRegDate,BPRegLocDr,BPRegLocDesc,BPRegUserDr,BPRegUserDesc,SurvNumberID,RepStatusCode)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod QryBPPatListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryBPPatListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryBPPatListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryBPPatListExecute ]
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
/// CreatDate：   2022-10-20
/// Description:  查询血透科室
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.BPSurverySrv","QryBPLocation")
Query QryBPLocation() As %Query(ROWSPEC = "LocID:%String,LocDesc2:%String") [ SqlProc ]
{
}

ClassMethod QryBPLocationExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1

	// 维护血透室科室ID
	Set BDLocIDs=##class(DHCHAI.BT.Config).GetValByCode("BloodDialysisLocIDs")
	For xi=1:1:$l(BDLocIDs,","){
		Set LocID = $p(BDLocIDs,",",xi)
		Continue:LocID=""
		Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(LocID)
		Continue:'$isobject(objLoc)
		
		Set LocDesc	 = ##class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(objLoc.BTDesc)
		Set LocDesc2 = ##class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(objLoc.BTDesc2)
		Set:LocDesc2="" LocDesc2 = LocDesc
		Set:$p(LocDesc2,"-",2)'="" LocDesc2=$p(LocDesc2,"-",2)
		Set Data=$lb(LocID,LocDesc2)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryBPLocationClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryBPLocationExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryBPLocationFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryBPLocationExecute ]
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
