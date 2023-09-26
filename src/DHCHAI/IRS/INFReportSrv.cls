/// 名称: DHCHAI.IRS.INFReportSrv
/// 描述: 医院感染报告相关服务
/// 编写者：zhufei
/// 编写日期: 2017-03-07
Class DHCHAI.IRS.INFReportSrv Extends (%RegisteredObject, DHCHAI.Abstract, User.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2022-08-25
/// Description:  批量审核横断面报告状态
/// Input：       aRepLog：状态变更日志信息
/// Return:		  return>0:成功、return<1:失败 
/// Debug:		  w ##class(DHCHAI.IRS.INFReportSrv).SaveCSSReportStatus()
ClassMethod SaveCSSReportStatus(aReportIDs As %String, aStatusCode As %String) As %String
{
	New (aReportIDs,aStatusCode)
	Set return=""
	Quit:(aReportIDs="")||(aStatusCode="") return
	TStart
	Set isError=0
	For indRep=1:1:$l(aReportIDs,","){
		Set ReportID=$p(aReportIDs,",",indRep)
		Continue:ReportID=""
		
		Set objRep = ##class(DHCHAI.IR.INFReport).GetObjById(ReportID)
		Continue:'$IsObject(objRep)
		
		Set objStatus=##class(DHCHAI.BT.Dictionary).GetObjByCode("InfReportStatus",aStatusCode)
		Continue:'$IsObject(objStatus)
		Set obj=##class(DHCHAI.IR.INFReport).%OpenId(ReportID)
		Set obj.IRStatusDr = objStatus
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

/// Creator：     liyi
/// CreatDate：   2017-09-27
/// Description:  保存报告状态
/// Input：       aRepLog：状态变更日志信息
/// Return:		  return>0:成功、return<1:失败 
/// Debug:		  w ##class(DHCHAI.IRS.INFReportSrv).SaveINFReportStatus(aRepLog)
ClassMethod SaveINFReportStatus(aRepLog As %String, separete As %String) As %String
{
	New (aRepLog,separete)
	Set return=""
	Quit:(aRepLog="")||(separete="") return
	
	Set ReportID = $p(aRepLog,separete,1)
	Quit:ReportID="" return
	
	Set objRep = ##class(DHCHAI.IR.INFReport).GetObjById(ReportID)
	Quit:'$IsObject(objRep) return
	
	TStart
	
	Set flg =1
	Set StatusCode = $p(aRepLog,separete,2)
	Set objStatus=##class(DHCHAI.BT.Dictionary).GetObjByCode("InfReportStatus",StatusCode)
	If $IsObject(objStatus){
		Set $p(aRepLog,separete,2)=objStatus.%Id()
	}
	Set obj=##class(DHCHAI.IR.INFReport).%OpenId(ReportID)
	Set obj.IRStatusDr   = objStatus
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
	Set ret = ##class(DHCHAI.IR.INFRepLog).Update(aRepLog,separete)
	if ret<1{
		Trollback
		Quit return
	}
	
	TCommit
	Set return = 1
	Quit return
}

/// Creator：     XWJ
/// CreatDate：   2020-03-06
/// Description:  退回报告时发送消息
/// Input：       Message:消息内容
/// Return:		  return>0:成功、return<1:失败 
/// Debug:		  w ##class(DHCHAI.IRS.INFReportSrv).SentMsg("退回原因：【肉肉日日日若】",8,"4")
ClassMethod SentMsg(Message As %String, FromUserDr As %String, HisPaadm As %String, LnkJson As %String = "", ToUserDr As %String = "") As %String
{
	New (Message,FromUserDr,HisPaadm,LnkJson,ToUserDr)
	Set ^TMPXWJ = $lb(Message,FromUserDr,HisPaadm,LnkJson,ToUserDr)
	Set return=""
	Quit:(Message="")||(HisPaadm="") return
	Set objFromUser= ##class(DHCHAI.BT.SysUser).GetObjById(FromUserDr)
	Quit:'$IsObject(objFromUser) return
	Set FromUserID=$p(objFromUser.BTXCode,"||",2)
	Set objToUserDr= ##class(DHCHAI.BT.SysUser).GetObjById(ToUserDr)
	Quit:'$IsObject(objToUserDr) return
	Set ToUserDr=$p(objToUserDr.BTXCode,"||",2)
	Set otherInfoJson=LnkJson ;"{""linkParam"":""&MsgType=1&ReportID="_ReportID_"""}"   //处理消息对应的链接
	Set CSMsgDtlID = ##class(DHCHAI.IO.FromHisSrv).SendMsg(Message,"1012",FromUserID,HisPaadm,ToUserDr,otherInfoJson)
	Set return = CSMsgDtlID
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-09-27
/// Description:  保存报告
/// Input：       aRepInfo：主表信息
/// 			  aPreFactors：易感因素
/// 			  aInvasOpers：侵害性操作
/// 			  aDiags：感染信息
/// 			  aOPSs：手术
/// 			  aLabs：病原学送检
/// 			  aAntis：抗菌药物
/// 			  aRepLog：日志
/// Return:		  return>0:成功、return<1:失败 
/// Debug:		  w ##class(DHCHAI.IRS.INFReportSrv).SaveINFReport(1,1,1,1,1,1,1,1)
ClassMethod SaveINFReport(aRepInfo As %String, aPreFactors As %String, aInvasOpers As %String, aDiags As %String, aOPSs As %String, aLabs As %String, aAntis As %String, aRepLog As %String, aCSS As %String = "")
{
	Set return = ""
	New (aRepInfo,aPreFactors,aInvasOpers,aDiags,aOPSs,aLabs,aAntis,aRepLog,aCSS)
	//Set ^TMP("SaveINFReport")=$lb(aRepInfo,aPreFactors,aInvasOpers,aDiags,aOPSs,aLabs,aAntis,aRepLog)
	//Set aRepInfo = $lg($g(^TMP("SaveINFReport")),1)
	//Set aPreFactors = $lg($g(^TMP("SaveINFReport")),2)
	//Set aInvasOpers = $lg($g(^TMP("SaveINFReport")),3)
	//Set aDiags = $lg($g(^TMP("SaveINFReport")),4)
	//Set aOPSs = $lg($g(^TMP("SaveINFReport")),5)
	//set aLabs = $lg($g(^TMP("SaveINFReport")),6)
	//Set aAntis = $lg($g(^TMP("SaveINFReport")),7)
	//Set aRepLog= $lg($g(^TMP("SaveINFReport")),8)
	TStart
	// 侵害性操作
	Set LinkInvOpers = "",flg=1
	For Ind = 1:1:$length(aInvasOpers,$c(2)){
		Set InvasOperStr = $p(aInvasOpers,$c(2),Ind)
		Continue:InvasOperStr=""
		
		Set ret = ##Class(DHCHAI.IR.INFInvOper).Update(InvasOperStr,$c(1))
		If ret<1 {
			Set flg=0
		}else{
			Set LinkInvOpers = LinkInvOpers_","_(+ret)
		}
	}
	Set:LinkInvOpers'="" LinkInvOpers = $e(LinkInvOpers,2,$length(LinkInvOpers))
	if flg=0{
		Trollback
		Set return = -1
		Quit return
	}
	// 易感因素
	Set LinkPreFactors = "",flg=1
	For Ind = 1:1:$length(aPreFactors,$c(2)){
		Set PreFactorStr = $p(aPreFactors,$c(2),Ind)
		Continue:PreFactorStr=""
		
		Set ret = ##Class(DHCHAI.IR.INFPreFactor).Update(PreFactorStr,$c(1))
		If ret<1 {
			Set flg=0
		}else{
			Set LinkPreFactors = LinkPreFactors_","_(+ret)
		}
	}
	Set:LinkPreFactors'="" LinkPreFactors = $e(LinkPreFactors,2,$length(LinkPreFactors))
	if flg=0{
		Trollback
		Set return = -2
		Quit return
	}	
	
	// 手术
	Set LinkOPSs = "",flg=1
	For Ind = 1:1:$length(aOPSs,$c(2)){
		Set OPSStr = $p(aOPSs,$c(2),Ind)
		Continue:OPSStr=""
		
		Set ret = ##Class(DHCHAI.IR.INFOPS).Update(OPSStr,$c(1))
		If ret<1 {
			Set flg=0
		}else{
			Set LinkOPSs = LinkOPSs_","_(+ret)
			Set OPSID =+ret
			//手术切口调查表手术信息合并到手麻记录表DHCHAI.DP.OROperAnaes
			Set EpisodeDr  = $p(OPSStr,$c(1),2)	
			Set AnaesDr  = $p(OPSStr,$c(1),3)
			Continue:AnaesDr=""
			//合并数据
			Set RetAnaesDr = ##class(DHCHAI.DP.OROperAnaes).OperINFOPSMerge(AnaesDr,OPSID)
			If ((+RetAnaesDr)<1)&&(AnaesDr'="") {
				//记录错误日志
				Set ErrClass  = "DHCHAI.DP.OROperAnaes"
				Set ErrMethod = "OperINFOPSMerge"
				Set ErrArgStr = $lb(AnaesDr_"^"_OPSID,"^")
				Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
			}
		}
	}
	Set:LinkOPSs'="" LinkOPSs = $e(LinkOPSs,2,$length(LinkOPSs))
	if flg=0{
		Trollback
		Set return = -4
		Quit return
	}
	
	// 病原学检验
	Set ZIndex=$zn,JIndex=$j,Nindx="SaveINFReport"
	Kill ^TMP(ZIndex,JIndex,Nindx)
	Set LinkLabs = "",flg=1,Bacterias = ""  //增加把关联的病原体保存到诊断信息里
	For Ind = 1:1:$length(aLabs,$c(2)){
		Set LabData = $p(aLabs,$c(2),Ind)
		Continue:LabData=""
		
		Set MainLab = $p(LabData,$c(4),1)
		// 保存检验主表信息
		Set ret = ##Class(DHCHAI.IR.INFLab).Update(MainLab,$c(1))
		If ret<1 {
			Set flg=0
		}else{
			Set LinkLabs = LinkLabs_","_(+ret)
		}
		Quit:flg=0	//主表保存失败退出
		
		Set INFLabID = +ret
		
		// 处理病原菌信息
		Set SenDatas = $p(LabData,$c(4),2)	// 药敏+菌
		For IndSen = 1:1:$length(SenDatas,$c(3)){
			Set SenData = $p(SenDatas,$c(3),IndSen)
			Continue:SenData=""
			Set BacteriaID   = $p(SenData,$c(1),2)
			Set AntID	     = $p(SenData,$c(1),4)
			Set:AntID="" AntID=0
			Set ^TMP(ZIndex,JIndex,Nindx,BacteriaID,AntID)=SenData
		}
		// 保存菌信息
		Set LabBactIDs=""
		Set xBactID = ""
		For {
			Set xBactID = $o(^TMP(ZIndex,JIndex,Nindx,xBactID))
			Quit:xBactID=""
			
			Set DrugSensList="",Bacteria="",RuleMBRID=""
			Set xAntID = ""
			For {
				Set xAntID = $o(^TMP(ZIndex,JIndex,Nindx,xBactID,xAntID))
				Quit:xAntID=""
				
				Set SenData = $g(^TMP(ZIndex,JIndex,Nindx,xBactID,xAntID))
				Set Bacteria     = $p(SenData,$c(1),3)
				Set AntID	     = $p(SenData,$c(1),4)
				Set AntDesc      = $p(SenData,$c(1),5)
				Set SensitivityID= $p(SenData,$c(1),6)
				Set RuleMBRID	 = $p(SenData,$c(1),8)
				Set InputSen = $lb(AntID,AntDesc,SensitivityID)
				Set DrugSensList = DrugSensList_$lb(InputSen)
			}
			
			Set SubID = $o(^DHCHAI.IR.INFLabI("BACT","IndexParrefBactDicDr",INFLabID,xBactID,""))
			Set Input = INFLabID_"^"_SubID_"^"_xBactID_"^"_Bacteria_"^"_RuleMBRID
			Set Bacterias = Bacterias_"#"_Bacteria
			Set ret = ##Class(DHCHAI.IR.INFLabBact).Update(Input,DrugSensList,"^")
			If ret<1 {
				Set flg=0
			}
			Set LabBactIDs=LabBactIDs_","_ret
		}
		Set:LabBactIDs'="" LabBactIDs=$e(LabBactIDs,2,$l(LabBactIDs))
	
		// 处理删除药敏结果的数据
	    Set xBactID = ""
	 	For {
	 		Set xBactID = $o(^DHCHAI.IR.INFLabI("BACT","IndexParrefBactDicDr",INFLabID,xBactID))
	 		Quit:xBactID=""
	 	
		    Set xSubID = ""
	 		For {
		 		Set xSubID = $o(^DHCHAI.IR.INFLabI("BACT","IndexParrefBactDicDr",INFLabID,xBactID,xSubID))
	 			Quit:xSubID=""
	 		
	 			Set xID = INFLabID_"||"_xSubID
	 			If (LabBactIDs'="") {   //非完全删除数据
	 				Continue:((","_LabBactIDs_",")[(","_xID_","))  //在保存的子表范围内
	 			}
	 			Set ret = ##Class(DHCHAI.IR.INFLabBact).DeleteById(xID)
	 			If ret<1 {
					Set flg=0
				}
	 		}
	 	}
	    
		Kill ^TMP(ZIndex,JIndex,Nindx)
	}
	Set:LinkLabs'="" LinkLabs = $e(LinkLabs,2,$length(LinkLabs))
	Kill ^TMP(ZIndex,JIndex,Nindx)
	if flg=0{
		Trollback
		Set return = -5
		Quit return
	}
	// 感染诊断
	Set:Bacterias'="" Bacterias = $e(Bacterias,2,$length(Bacterias))
	Set LinkDiags = "",flg=1
	For Ind = 1:1:$length(aDiags,$c(2)){
		Set DiagStr = $p(aDiags,$c(2),Ind)
		Continue:DiagStr=""
		Set:Bacterias'="" $p(DiagStr,$c(1),16)=Bacterias
		Set ret = ##Class(DHCHAI.IR.INFDiagnos).Update(DiagStr,$c(1))
		If ret<1 {
			Set flg=0
		}else{
			Set LinkDiags = LinkDiags_","_(+ret)
		}
	}
	Set:LinkDiags'="" LinkDiags = $e(LinkDiags,2,$length(LinkDiags))
	if flg=0{
		Trollback
		Set return = -3
		Quit return
	}
	// 抗菌药物
	Set LinkAntis = "",flg=1
	For Ind = 1:1:$length(aAntis,$c(2)){
		Set AntStr = $p(aAntis,$c(2),Ind)
		Continue:AntStr=""
		
		Set ret = ##Class(DHCHAI.IR.INFAnti).Update(AntStr,$c(1))
		If ret<1 {
			Set flg=0
		}else{
			Set LinkAntis = LinkAntis_","_(+ret)
		}
	}
	Set:LinkAntis'="" LinkAntis = $e(LinkAntis,2,$length(LinkAntis))
	if flg=0{
		Trollback
		Set return = -6
		Quit return
	}
	// 横断面调查
	Set LinkCSS = "",flg=1
	For Ind = 1:1:$length(aCSS,$c(2)){
		Set CSSStr = $p(aCSS,$c(2),Ind)
		Continue:CSSStr=""
		
		Set ret = ##Class(DHCHAI.IR.INFCSS).Update(CSSStr,$c(1))
		If ret<1 {
			Set flg=0
		}else{
			Set LinkCSS = LinkCSS_","_(+ret)
		}
	}
	Set:LinkCSS'="" LinkCSS = $e(LinkCSS,2,$length(LinkCSS))
	if flg=0{
		Trollback
		Set return = -7
		Quit return
	}
	// 主表信息
	//*****************************************************
	//转换操作代码->ID
	Set StatusCode = $p(aRepInfo,$c(1),8)
	Set StatusDr   = ""
	Set objStatus=##class(DHCHAI.BT.Dictionary).GetObjByCode("InfReportStatus",StatusCode)
	Set:$IsObject(objStatus) StatusDr=objStatus.%Id()
	Set $p(aRepInfo,$c(1),8)=StatusDr
	//*****************************************************
	if StatusDr="" {
		Trollback
		Set return = -7
		Quit return
	}
	//add 20220127
	Set IsInfLab  = $p(aRepInfo,$c(1),9)
	Set IsInfAnti = $p(aRepInfo,$c(1),10)
	Set IsInfOpr  = $p(aRepInfo,$c(1),11)
	Set Opinion   = $p(aRepInfo,$c(1),12)
	Set $p(aRepInfo,$c(1),10)=""
	
	Set $p(aRepInfo,$c(1),9)=LinkDiags
	//Set $p(aRepInfo,$c(1),10)=LinkICDs
	Set $p(aRepInfo,$c(1),11)=LinkLabs
	Set $p(aRepInfo,$c(1),12)=LinkAntis
	Set $p(aRepInfo,$c(1),13)=LinkOPSs
	Set $p(aRepInfo,$c(1),15)=LinkInvOpers
	Set $p(aRepInfo,$c(1),16)=LinkPreFactors
	Set $p(aRepInfo,$c(1),27)=LinkCSS   //横断面
	Set $p(aRepInfo,$c(1),29)=IsInfLab
	Set $p(aRepInfo,$c(1),30)=IsInfAnti
	Set $p(aRepInfo,$c(1),31)=IsInfOpr 
	
	Set ret = ##class(DHCHAI.IR.INFReport).Update(aRepInfo,$c(1))
	if ret<1{
		Trollback
		Set return = -7
		Quit return
	}else{
		Set ReportID = +ret
	}
	
	// 日志
	Set $p(aRepLog,$c(1),1)=ReportID
	Set $p(aRepLog,$c(1),2)=objStatus.%Id()
	Set $p(aRepLog,$c(1),3)=Opinion
	Set ret = ##class(DHCHAI.IR.INFRepLog).Update(aRepLog,$c(1))
	if ret<1{
		Trollback
		Set return = -8
		Quit return
	}
	
	Tcommit
	Set return = ReportID
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2020-04-14
/// Description:  保存医院感染,历史就诊
/// Input：       aEpisodeIDs
/// Return:		  return>0:成功、return<1:失败 
/// Debug:		  w ##class(DHCHAI.IRS.INFReportSrv).SaveINFRepAdm(20,"29",8)
ClassMethod SaveINFRepAdm(aReportID As %String, aEpisodeIDs As %String, aUser As %String) As %String
{
	New (aReportID,aEpisodeIDs,aUser)
	Set return="0"
	
	Quit:(aEpisodeIDs="") return
	Set LinkAdms=""
	Set flg=1
	For Ind=1:1:$l(aEpisodeIDs,"^"){
		Set xEpisID=$p(aEpisodeIDs,"^",Ind)
		Continue:xEpisID=""
		Set ret = ##Class(DHCHAI.IR.INFLastAdm).Update(xEpisID)
		If ret<1 {
			Set flg=0
		}else{
			Set LinkAdms = LinkAdms_","_(+ret)
		}
	}
	Set:LinkAdms'="" LinkAdms = $e(LinkAdms,2,$length(LinkAdms))
	if flg=0{
		Set return = -1
		Quit return
	}
	Set ActInfo=(+$h)_"^"_($p($h,",",2))_"^"_aUser
	Set flg=##class(DHCHAI.IR.INFRepExt).SaveRepExt(aReportID,"DHCHAI.IR.INFLastAdm",LinkAdms,ActInfo)
	Set return=flg	
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2020-04-14
/// Description:  删除医院感染,历史就诊
/// Input：       aEpisodeIDs
/// Return:		  return>0:成功、return<1:失败 
/// Debug:		  w ##class(DHCHAI.IRS.INFReportSrv).DelINFRepAdm(46,"7")
ClassMethod DelINFRepAdm(aReportID As %String, aEpisodeIDs As %String) As %String
{
	New (aReportID,aEpisodeIDs)
	Set return="0"
	Quit:(aEpisodeIDs="")||(aReportID="") return
	For indxx=1:1:$l(aEpisodeIDs,"^"){
		Set xEpisID=$p(aEpisodeIDs,"^",indxx)
		Continue:xEpisID=""
		Set LastAdmID=$o(^DHCHAI.IR.INFLastAdmI("IndexLastAdm",xEpisID,""))
		Continue:LastAdmID=""
		Set xSub=0
		For {
			Set xSub=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt("DHCHAI.IR.INFLastAdm","U"),aReportID,xSub))
			Quit:xSub=""
			
			Set RepExtID=aReportID_"||"_xSub
			Set obj=##class(DHCHAI.IR.INFRepExt).GetObjById(RepExtID)
			Continue:'$IsObject(obj)
			// 关联报告ID
			Set ObjectID = obj.IRObjectID
			Continue:LastAdmID'=ObjectID
			Set flg=##class(DHCHAI.IR.INFRepExt).DeleteById(RepExtID)
			If (+flg)>=0 {
				Set return=1
			}
		}
	}
	Quit return
}

/// Creator：     chenjb
/// CreatDate：   2017-07-06
/// Description:  查询患者住院科室列表
/// Table：       DHCHAI.DP.PAAdmTrans
/// Input:        argYYMM,argLoc
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.INFReportSrv","QryLocByTrans","4673","E")
Query QryLocByTrans(aEpisodeID As %String, aLocType As %String) As %Query(ROWSPEC = "TransDr:%String,LocCode,LocDesc:%String,TransLocID:%String") [ SqlProc ]
{
}

ClassMethod QryLocByTransExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aLocType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aEpisodeID="")||(aLocType="") $$$OK
	
	Set TransLocList=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransLocList(aEpisodeID,aLocType)
	//Quit:TransLocList="" $$$OK
	For indTLL=1:1:$ll(TransLocList){
		Set tmpTransLoc=$lg(TransLocList,indTLL)
		Continue:tmpTransLoc=""
		Set TransDr=$lg(tmpTransLoc,1)
		Set TransLocID=$lg(tmpTransLoc,2)
		Set TranLocCode=$lg(tmpTransLoc,3)
		Set TranLocDesc=$lg(tmpTransLoc,4)
		Continue:TranLocDesc=""
		Set Data=$lb(TransDr,TranLocCode,TranLocDesc,TransLocID)
		Set ^CacheTemp(repid,ind)=Data
    	Set ind=ind+1
	}
	If (ind=1){  // 科室加上急诊留观
		Set ChangeAdmTypeByEPLoc=##class(DHCHAI.BT.Config).GetValByCode("CUS-ChangeAdmTypeByEPLoc")
		For indId=1:1:$l(ChangeAdmTypeByEPLoc,"|"){
			Set ELocDr=+$p(ChangeAdmTypeByEPLoc,"|",indId)
			Continue:ELocDr=0
			Set objLoc=##class(DHCHAI.BT.Location).GetObjById(ELocDr)
			Continue:'$IsObject(objLoc)
			Continue:'$IsObject(objLoc.BTTypeDr)
			Set LocType=objLoc.BTTypeDr.BTCode
			//急诊留观作为病区显示，这儿要求感染科室，不用过滤科室类型。
			//Continue:aLocType'=LocType
			
			Set TransDr=""
			Set TransLocID=ELocDr
			Set TranLocCode=objLoc.BTCode
			Set TranLocDesc=objLoc.BTDesc2
			Continue:TranLocDesc=""
			Set Data=$lb(TransDr,TranLocCode,TranLocDesc,TransLocID)
			Set ^CacheTemp(repid,ind)=Data
	    	Set ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryLocByTransClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLocByTransExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryLocByTransFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLocByTransExecute ]
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
/// CreatDate：   2017-09-25
/// Description:  取患者院感报告状态：作废 0、其余 1
/// Table：       DHCHAI.IR.INFReport
/// Input：       aEpisodeID    : 就诊号///               
/// Return：      返回String
/// w ##class(DHCHAI.IRS.INFReportSrv).GetInfReportStatus(95)
ClassMethod GetInfReportStatus(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return="0"
	Quit:(aEpisodeID="") return
	
	Set RepType = ""
	For {
		Set RepType=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,RepType))
		Quit:RepType=""
		Continue:(RepType'="1")
		
		Set xID = ""
		For {
			Set xID=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,RepType,xID))
			Quit:xID=""
			Quit:return="1"
			Set objINFRep=##class(DHCHAI.IR.INFReport).GetObjById(xID)
			Quit:'$IsObject(objINFRep)
			Set RepStatus=objINFRep.IRStatusDr
			Continue:'$IsObject(RepStatus) //1 保存 2 提交 3 审核 4 作废
			Set return="1"
			Set:RepStatus.BTCode="4" return=0		
		}
	}
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-09-21
/// Description:  查询报告主表明细
/// Table：       DHCHAI.IR.INFReport
/// Input:        报告ID
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.INFReportSrv","QryRepInfo","91")
Query QryRepInfo(aRepotID As %String) As %Query(ROWSPEC = "RepotID:%String,EpisodeID:%String,RepType:%String,RepDate:%String,RepTime:%String,RepLocID:%String,RepLoc:%String,RepUserID:%String,RepUser:%String,RepStatusID:%String,RepStatusCode:%String,RepStatus:%String,LinkDiags:%String,LinkICDs:%String,LinkLabs:%String,LinkAntis:%String,LinkOPSs:%String,LinkMRBs:%String,LinkInvOpers:%String,LinkPreFactors:%String,LinkICUUCs:%String,LinkICUVAPs:%String,LinkICUPICCs:%String,InLocID:%String,InLoc:%String,OutLocID:%String,OutLoc:%String,InDate:%String,OutDate:%String,APACHEScoreID:%String,APACHEScore:%String,OutIntubatsID:%String,OutIntubats:%String,Out48IntubatsID:%String,Out48Intubats:%String,IsInfLab:%String,IsInfAnti:%String,IsInfOpr:%String,Opinion:%String") [ SqlProc ]
{
}

ClassMethod QryRepInfoExecute(ByRef qHandle As %Binary, aRepotID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:aRepotID="" $$$OK
	
	Set Data = ..BuildINFRepData(aRepotID)
	Quit:Data="" $$$OK
	
	Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
	Quit $$$OK
}

ClassMethod QryRepInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRepInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryRepInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRepInfoExecute ]
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

/// 取单个报告主表信息
ClassMethod BuildINFRepData(aRepotID As %String) As %String
{
	New (aRepotID,%session)
	Set return = ""
	Quit:aRepotID="" return
	
	Set objRep = ##class(DHCHAI.IR.INFReport).GetObjById(aRepotID)
	Quit:'$IsObject(objRep) return
	Quit:'$IsObject(objRep.IREpisodeDr) return
	
	Set EpisodeID = objRep.IREpisodeDr.%Id()
	Set RepType  = objRep.IRRepType
	Set RepDate  = objRep.IRRepDate
	Set:RepDate'="" RepDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RepDate)
	Set RepTime  = objRep.IRRepTime
	Set:RepTime'="" RepTime=$zt(RepTime)
	Set objRepLoc= objRep.IRRepLocDr
	Set (RepLocID,RepLoc)=""
	If $IsObject(objRepLoc){
		Set RepLocID = objRepLoc.%Id()
		Set LocDesc2 = objRepLoc.BTDesc2
		Set LocDesc = objRepLoc.BTDesc
		Set RepLoc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
	}
	Set objRepUser  = objRep.IRRepUser
	Set (RepUserID,RepUser)=""
	If $IsObject(objRepUser){
		Set RepUserID = objRepUser.%Id()
		Set RepUser = objRepUser.BTDesc
	}
	Set objStatus  = objRep.IRStatusDr
	Set (RepStatusID,RepStatus,RepStatusCode)=""
	If $IsObject(objStatus){
		Set RepStatusID = objStatus.%Id()
		Set RepStatus = objStatus.BTDesc
		Set RepStatusCode  = objStatus.BTCode
	}
	
	Set LinkDiags      = objRep.GetRepLinkIDs("DHCHAI.IR.INFDiagnos")
	Set LinkICDs       = objRep.GetRepLinkIDs("DHCHAI.IR.INFICD")
	Set LinkLabs       = objRep.GetRepLinkIDs("DHCHAI.IR.INFLab")
	Set LinkAntis      = objRep.GetRepLinkIDs("DHCHAI.IR.INFAnti")
	Set LinkOPSs       = objRep.GetRepLinkIDs("DHCHAI.IR.INFOPS")
	Set LinkMRBs       = objRep.GetRepLinkIDs("DHCHAI.IR.INFMBR")
	Set LinkInvOpers   = objRep.GetRepLinkIDs("DHCHAI.IR.INFInvOper")
	Set LinkPreFactors = objRep.GetRepLinkIDs("DHCHAI.IR.INFPreFactor")
	Set LinkICUUCs     = objRep.GetRepLinkIDs("DHCHAI.IR.INFICUUC")
	Set LinkICUVAPs    = objRep.GetRepLinkIDs("DHCHAI.IR.INFICUVAP")
	Set LinkICUPICCs   = objRep.GetRepLinkIDs("DHCHAI.IR.INFICUPICC")
	
	Set objInLoc       = objRep.IRInLocDr
	Set (InLocID,InLoc)=""
	If $IsObject(objInLoc){
		Set InLocID = objInLoc.%Id()
		Set LocDesc2 = objInLoc.BTDesc2
		Set LocDesc = objInLoc.BTDesc
		Set InLoc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
	}
	Set objOutLoc  = objRep.IROutLocDr
	Set (OutLocID,OutLoc)=""
	If $IsObject(objOutLoc){
		Set OutLocID = objOutLoc.%Id()
		Set LocDesc2 = objOutLoc.BTDesc2
		Set LocDesc = objOutLoc.BTDesc
		Set OutLoc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
	}
	Set InDate  = objRep.IRInDate
	Set:InDate'="" InDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InDate)
	Set OutDate  = objRep.IROutDate
	Set:OutDate'="" OutDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OutDate)
	Set objAPACHEScore  = objRep.IRAPACHEScore
	Set (APACHEScoreID,APACHEScore)=objRep.IRAPACHEScore
	Set objOutIntubats  = objRep.IROutIntubats
	Set (OutIntubatsID,OutIntubats)=""
	If $IsObject(objOutIntubats){
		Set OutIntubatsID = "" //objOutIntubats.%Id()
		Set OutIntubats = "" //objOutIntubats.BTDesc
	}
	Set objOut48Intubats  = objRep.IROut48Intubats
	Set (Out48IntubatsID,Out48Intubats)=""
	If $IsObject(objOut48Intubats){
		Set Out48IntubatsID = "" //objOut48Intubats.%Id()
		Set Out48Intubats = "" //objOut48Intubats.BTDesc
	}
	
	Set IsInfLab    =  objRep.IRIsInfLab
	Set IsInfAnti   =  objRep.IRIsInfAnti
	Set IsInfOpr    =  objRep.IRIsInfOpr
	Set Opinion=""
	If (RepStatusCode=3) { //审核状态
	    Set xLogID =""
	    For {
		    Set xLogID=$o(^DHCHAI.IR.INFReportD(aRepotID,"LOG",xLogID),-1)
		    Quit:xLogID=""
		    Set objLog=##class(DHCHAI.IR.INFRepLog).GetObjById(aRepotID_"||"_xLogID)
	      	Continue:'$IsObject(objLog)
	      	Continue:'$IsObject(objLog.IRStatusDr)
	      	Continue:objLog.IRStatusDr.BTCode'=3
	      	Set Opinion  =  objLog.IROpinion
	      	Quit:Opinion'=""
	   	}
	}
	//多语言
	Set RepLoc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",RepLoc,"User.CTLoc")
	Set RepUser=##Class(DHCHAI.Abstract).HAIGetTranByDesc("SSUSRName",RepUser,"User.SSUser")
	Set RepStatus=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",RepStatus,"DHCHAI.BT.Dictionary")
	Set return=$lb(aRepotID,EpisodeID,RepType,RepDate,RepTime,RepLocID,RepLoc,RepUserID,RepUser,RepStatusID,RepStatusCode,RepStatus,LinkDiags,LinkICDs,LinkLabs,LinkAntis,LinkOPSs,LinkMRBs,LinkInvOpers,LinkPreFactors,LinkICUUCs,LinkICUVAPs,LinkICUPICCs,InLocID,InLoc,OutLocID,OutLoc,InDate,OutDate,APACHEScoreID,APACHEScore,OutIntubatsID,OutIntubats,Out48IntubatsID,Out48Intubats,IsInfLab,IsInfAnti,IsInfOpr,Opinion)
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-09-21
/// Description:  查询病人报告信息
/// Table：       DHCHAI.IR.INFReport
/// Input:        报告ID
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.INFReportSrv","QryRepByAdm","88919",1)
Query QryRepByAdm(aEpisodeID As %String, aRepType As %String) As %Query(ROWSPEC = "RepID:%String,RepTypeDesc:%String,RepStatus:%String,InfPosDescs:%String,InfSubDescs:%String,InfDateDescs:%String,InfLocDescs:%String,SpecimenDescs:%String,BactDescs:%String,RepType:%String,InfType:%String,InfXDate:%String,InfEffect:%String,DeathRelation:%String,RepDate:%String,RepLoc:%String,RepUser:%String,CheckDate:%String,CheckUser:%String")
{
}

ClassMethod QryRepByAdmExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aRepType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:(aEpisodeID="")||(aRepType="") $$$OK
	
	Quit:'$d(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,aRepType)) $$$OK
	
	Set xRepID = ""
	For {
		Set xRepID = $o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,aRepType,xRepID))
		Quit:xRepID=""
		
		Set objRep = ##class(DHCHAI.IR.INFReport).GetObjById(xRepID)
		Continue:'$IsObject(objRep)
		
		// 报告信息
		Set RepTypeDesc = $s(aRepType=1:"医院感染报告",aRepType=2:"新生儿感染报告",aRepType=3:"ICU调查表",aRepType=4:"手术切口调查表",aRepType=5:"多重耐药调查表",aRepType=6:"抗菌药物调查表",1:"")
		Set objStatus = objRep.IRStatusDr
		Set RepStatus = ""
		If $IsObject(objStatus){
			Set RepStatus = objStatus.BTDesc
		}
		
		Set LinkDiags      = objRep.GetRepLinkIDs("DHCHAI.IR.INFDiagnos")
		Set LinkLabs       = objRep.GetRepLinkIDs("DHCHAI.IR.INFLab")
		// 感染诊断信息
		Set (InfPosDescs,InfSubDescs,InfDateDescs,InfLocDescs)=""
        Set (InfXDate,InfEffect,DeathRelation,InfType)=""
		For indx = 1:1:$l(LinkDiags,","){
			Set xDiagID = $p(LinkDiags,",",indx)
			Continue:xDiagID=""
			
			Set objDiags = ##class(DHCHAI.IR.INFDiagnos).GetObjById(xDiagID)
			Continue:'$IsObject(objDiags)
            Set InfType=objDiags.IRInfType
			
			// 感染部位/感染诊断
			Set objInfPos = objDiags.IRInfPosDr
			If $IsObject(objInfPos){
				Set InfPosDescs = InfPosDescs_","_objInfPos.BTDesc
			}
			// 感染分类
			Set objInfSub = objDiags.IRInfSubDr
			If $IsObject(objInfSub){
				Set InfSubDescs = InfSubDescs_","_objInfSub.BTDesc
			}
			// 感染日期
			Set InfDate = objDiags.IRInfDate
			Set:InfDate'="" InfDate= ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InfDate)
			Set:InfDate'="" InfDateDescs=InfDateDescs_","_InfDate
			// 感染科室
			Set objInfLoc = objDiags.IRInfLocDr
			If $IsObject(objInfLoc){
				Set InfLocDesc2 = objInfLoc.BTDesc2
				Set InfLocDesc = objInfLoc.BTDesc
				Set InfLocDesc = $s(InfLocDesc2'="":InfLocDesc2,1:InfLocDesc)
				Set InfLocDescs = InfLocDescs_","_InfLocDesc
			}
            // 感染转归日期  感染转归 与死亡关系
            Set InfXDate=objDiags.IRInfXDate
            Set:InfXDate'="" InfXDate= ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InfXDate)
            Set InfEffect=objDiags.IRInfEffectDr
            If $IsObject(InfEffect){
               Set InfEffect = objDiags.IRInfEffectDr.BTDesc
               
            }
            Set DeathRelation=objDiags.IRDeathRelationDr
             If $IsObject(DeathRelation){
                Set DeathRelation = objDiags.IRDeathRelationDr.BTDesc 
            }

        }
		Set:InfPosDescs'="" InfPosDescs = $e(InfPosDescs,2,$l(InfPosDescs))
		Set:InfSubDescs'="" InfSubDescs = $e(InfSubDescs,2,$l(InfSubDescs))
		Set:InfDateDescs'="" InfDateDescs = $e(InfDateDescs,2,$l(InfDateDescs))
		Set:InfLocDescs'="" InfLocDescs = $e(InfLocDescs,2,$l(InfLocDescs))
        Continue:InfDateDescs=""    //任意一个为空都可以返回
		// 病原体送检
		Set (SpecimenDescs,BactDescs)=""
		For indx = 1:1:$l(LinkLabs,","){
			Set xLabID = $p(LinkLabs,",",indx)
			Continue:xLabID=""
			
			Set objLab = ##class(DHCHAI.IR.INFLab).GetObjById(xLabID)
			Continue:'$IsObject(objLab)
			
			Set objSpecimen = objLab.IRSpecimenDr
			If $IsObject(objSpecimen){
				Set SpecimenDescs = SpecimenDescs_","_objSpecimen.BTSpecDesc
			}
			
			Set xSubID = "",Bacterias=""
			For {
				Set xSubID = $o(^DHCHAI.IR.INFLabD(xLabID,"BACT",xSubID))
				Quit:xSubID=""
				
				Set objLabBact = ##class(DHCHAI.IR.INFLabBact).GetObjById(xLabID_"||"_xSubID)
				Continue:'$IsObject(objLabBact)
				Continue:'$IsObject(objLabBact.IRBactDicDr)
				Set Bacteria = objLabBact.IRBactDicDr.BTBacDesc
                if $lf(BactDescs,Bacteria)<1{
                    Set BactDescs= BactDescs_$lb(Bacteria)
			}
			}
		}
		Set:SpecimenDescs'="" SpecimenDescs = $e(SpecimenDescs,2,$l(SpecimenDescs))
        Set:$ll(BactDescs)>0 BactDescs = $listtoString(BactDescs)
        // 报告科室 报告日期 报告人 审核人
        Set (RepDate,RepLoc,RepUser)=""
        Set RepDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(objRep.IRRepDate)
        Set:$IsObject(objRep.IRRepLocDr) RepLoc=objRep.IRRepLocDr.BTDesc
        Set:$IsObject(objRep.IRRepUser) RepUser=objRep.IRRepUser.BTDesc
        
        //审核人+审核时间  
        Set CheckFlag="0"
        Set CheckUser="",CheckDate=""
        Set xLogDr=""
        For {
            Set xLogDr=$o(^DHCHAI.IR.INFReportD(xRepID,"LOG",xLogDr),-1)
            Quit:(xLogDr="")
            Quit:CheckFlag="1"
            Set objLog=##class(DHCHAI.IR.INFRepLog).GetObjById(xRepID_"||"_xLogDr)
            Continue:'$IsObject(objLog)
            Continue:'$IsObject(objLog.IRStatusDr)
            
            Set StatusDesc=objLog.IRStatusDr.BTDesc
            if (StatusDesc="审核"){
                Set CheckUser=objLog.IRUpdateUserDr.BTDesc
                Set CheckDate=objLog.IRUpdateDate
                Set:CheckDate'="" CheckDate=$zd(CheckDate,3)
                Set CheckFlag="1"
            }
            Quit
        }
        Set RepType=objRep.IRRepType
        //多语言改造基础数据
        Set InfPosDescs=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",InfPosDescs,"DHCHAI.BT.InfPos")
        Set RepStatus=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",RepStatus,"DHCHAI.BT.Dictionary")
        Set InfSubDescs=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",RepStatus,"DHCHAI.BT.InfSub")
        Set InfLocDescs=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",InfLocDescs,"User.CTLoc")
        Set InfEffect=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",InfEffect,"DHCHAI.BT.Dictionary")
        Set DeathRelation=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",DeathRelation,"DHCHAI.BT.Dictionary")
        Set RepLoc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",RepLoc,"User.CTLoc")
        Set RepUser=##Class(DHCHAI.Abstract).HAIGetTranByDesc("SSUSRName",RepUser,"User.SSUser")
        Set CheckUser=##Class(DHCHAI.Abstract).HAIGetTranByDesc("SSUSRName",CheckUser,"User.SSUser")
        
        Set InfType=$Select(InfType="1":"医院感染",InfType="0":"社区感染",1:"")     //这是报告最后一个诊断对应的感染类型,大部分情况下兼容-旧版一个报告多个诊断另行计算
        Set Data = $lb(xRepID,RepTypeDesc,RepStatus,InfPosDescs,InfSubDescs,InfDateDescs,InfLocDescs,SpecimenDescs,BactDescs,RepType,InfType)  
        //转归日期 转归 与死亡关系 报告科室 报告日期 审核日期 审核人
        Set Data = Data_$lb(InfXDate,InfEffect,DeathRelation,RepDate,RepLoc,RepUser,CheckDate,CheckUser)   //20220901添加历史报告记录2815814
        
		Set ^CacheTemp(repid,ind)=Data
    	Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryRepByAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRepByAdmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryRepByAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRepByAdmExecute ]
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

/// Creator：     mayanpeng
/// CreatDate：   2017-11-27
/// Description:  前台更新院感报告表（报告状态类型为字典Code，需要转换为ID）
/// Table：       DHCHAI.IR.INFReport
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IRS.INFReportSrv).UpdateReport()
ClassMethod UpdateReport(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return = ""
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set IRStatusCode = $p(aInputStr,aSeparete,8)
	Set objDic = ##class(DHCHAI.BT.Dictionary).GetObjByCode("InfReportStatus",IRStatusCode)
	Quit:'$IsObject(objDic) return
	Set DicID = objDic.%Id()
	Set $p(aInputStr,aSeparete,8) = DicID
	Set return = ##class(DHCHAI.IR.INFReport).Update(aInputStr, aSeparete)
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2018-07-04
/// Description:  打印报告信息
/// Table：       DHCHAI.IR.INFReport
/// Input:        报告ID
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.INFReportSrv","QryToPrint","53")
Query QryToPrint(aReportID As %String) As %Query(ROWSPEC = "ReportID:%String,ReportLocDesc:%String,ReportUserDesc:%String,ReportDate:%String,StrPreFactor:%String,StrInvOper:%String,StrInfSub:%String,IsInfLab:%String,IsInfLabDesc:%String,IsInfAnti:%String,IsInfAntiDesc:%String,IsInfOpr:%String,IsInfOprDesc:%String,Opinion:%String") [ SqlProc ]
{
}

ClassMethod QryToPrintExecute(ByRef qHandle As %Binary, aReportID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:(aReportID="") $$$OK
	
	Set objReport = ##class(DHCHAI.IR.INFReport).GetObjById(aReportID)
	Quit:'$IsObject(objReport) $$$OK
	Quit:'$IsObject(objReport.IREpisodeDr) $$$OK
	
	Set (ReportLocDesc,ReportUserDesc,ReportDate)=""
	Set objRepLoc=objReport.IRRepLocDr
	If $IsObject(objRepLoc) {
		Set ReportLocID=objRepLoc.%Id()
		Set ReportLocDesc=objRepLoc.BTDesc2
		Set:ReportLocDesc="" ReportLocDesc=objRepLoc.BTDesc
	}
	Set objRepUser=objReport.IRRepUser
	If $IsObject(objRepUser) {
		Set ReportUserID=objRepUser.%Id()
		Set ReportUserDesc=objRepUser.BTDesc
	}
	Set ReportDate=objReport.IRRepDate
	Set:ReportDate'="" ReportDate=$zd(ReportDate,3)
	
	Set StrPreFactor=""
	Set LinkPreFactors=objReport.GetRepLinkIDs("DHCHAI.IR.INFPreFactor")
	If (LinkPreFactors'="") {
		for indx = 1:1:$length(LinkPreFactors,","){
			Set ID=$p(LinkPreFactors,",",indx)
			Continue:ID=""
			Set objPreFactor = ##class(DHCHAI.IR.INFPreFactor).GetObjById(ID)
			Continue:'$IsObject(objPreFactor)
			Continue:'$IsObject(objPreFactor.IREpisodeDr)
			
			Set objPreDic = objPreFactor.IRPreFactorDr
			Continue:'$IsObject(objPreDic)
			
			Set (PreFactorID,PreFactor)=""
			If $IsObject(objPreDic){
				Set PreFactorID = objPreDic.%Id()
				Set PreFactor = objPreDic.BTDesc
			}
			Set:PreFactor'="" StrPreFactor=StrPreFactor_","_PreFactor
		}
		Set:StrPreFactor'="" StrPreFactor=$e(StrPreFactor,2,$l(StrPreFactor))
	}
	
	Set StrInvOper=""
	Set LinkInvOpers=objReport.GetRepLinkIDs("DHCHAI.IR.INFInvOper")
	If (LinkInvOpers'="") {
		for indx = 1:1:$length(LinkInvOpers,","){
			Set ID=$p(LinkInvOpers,",",indx)
			Continue:ID=""
			Set objInvOper = ##class(DHCHAI.IR.INFInvOper).GetObjById(ID)
			Continue:'$IsObject(objInvOper)
			Continue:'$IsObject(objInvOper.IREpisodeDr)
			
			Set objInvOperDic = objInvOper.IRInvOperDr
			Continue:'$IsObject(objInvOperDic)
			
			Set (InvOperID,InvOper)=""
			If $IsObject(objInvOperDic){
				Set InvOperID = objInvOperDic.%Id()
				Set InvOper = objInvOperDic.BTDesc
			}
			Set:InvOper'="" StrInvOper=StrInvOper_","_InvOper
		}
		Set:StrInvOper'="" StrInvOper=$e(StrInvOper,2,$l(StrInvOper))
	}
	
	Set StrInfSub=""
	Set LinkStrInfSubs=objReport.GetRepLinkIDs("DHCHAI.IR.INFDiagnos")
	If (LinkStrInfSubs'="") {
		for indx = 1:1:$length(LinkStrInfSubs,","){
			Set ID=$p(LinkStrInfSubs,",",indx)
			Continue:ID=""
			Set objINFDiagnos = ##class(DHCHAI.IR.INFDiagnos).GetObjById(ID)
			Continue:'$IsObject(objINFDiagnos)
			Continue:'$IsObject(objINFDiagnos.IRInfSubDr)
			
			Set objInfSubDr = objINFDiagnos.IRInfSubDr
			Continue:'$IsObject(objInfSubDr)
			
			Set (InfSubID,InfSub)=""
			If $IsObject(objInfSubDr){
				Set InfSubID = objInfSubDr.%Id()
				Set InfSub = objInfSubDr.BTDesc
			}
			Set:InfSub'="" StrInfSub=StrInfSub_","_InfSub
		}
		Set:StrInfSub'="" StrInfSub=$e(StrInfSub,2,$l(StrInfSub))
	}
	
	Set IsInfLab    =  objReport.IRIsInfLab
	Set IsInfLabDesc=$s(IsInfLab=1:"是",1:"否")
	Set IsInfAnti   =  objReport.IRIsInfAnti
	Set IsInfAntiDesc=$s(IsInfAnti=1:"是",1:"否")
	Set IsInfOpr    =  objReport.IRIsInfOpr
	Set IsInfOprDesc=$s(IsInfOpr=1:"是",1:"否")
	
	Set Opinion=""
	Set objStatus  = objReport.IRStatusDr
	Set (RepStatusID,RepStatus,RepStatusCode)=""
	If $IsObject(objStatus){
		Set RepStatusID = objStatus.%Id()
		Set RepStatus = objStatus.BTDesc
		Set RepStatusCode  = objStatus.BTCode
	}
	If (RepStatusCode=3) { //审核状态
	    Set xLogID =""
	    For {
		    Set xLogID=$o(^DHCHAI.IR.INFReportD(aReportID,"LOG",xLogID),-1)
		    Quit:xLogID=""
		    Set objLog=##class(DHCHAI.IR.INFRepLog).GetObjById(aReportID_"||"_xLogID)
	      	Continue:'$IsObject(objLog)
	      	Continue:'$IsObject(objLog.IRStatusDr)
	      	Continue:objLog.IRStatusDr.BTCode'=3
	      	Set Opinion  =  objLog.IROpinion
	      	Quit:Opinion'=""
	   	}
	}
	Set Data = $lb(aReportID,ReportLocDesc,ReportUserDesc,ReportDate,StrPreFactor,StrInvOper,StrInfSub,IsInfLab,IsInfLabDesc,IsInfAnti,IsInfAntiDesc,IsInfOpr,IsInfOprDesc,Opinion)
	Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    
	Quit $$$OK
}

ClassMethod QryToPrintClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryToPrintExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryToPrintFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryToPrintExecute ]
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

/// Creator：     mayanpeng
/// CreatDate：   2018-08-21
/// Description:  通过就诊查询本次就诊报告列表
/// Table：       DHCHAI.IR.INFReport
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IRS.INFReportSrv).GetInfRepIDList("18160")
ClassMethod GetInfRepIDList(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:(aEpisodeID="") return
	
	Set xID = ""
	For {
		Set xID=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,1,xID))
		Quit:xID=""
		
		Set objINFRep=##class(DHCHAI.IR.INFReport).GetObjById(xID)
		Quit:'$IsObject(objINFRep)
		Set RepStatus=objINFRep.IRStatusDr
		Continue:'$IsObject(RepStatus)
		Continue:(RepStatus.BTDesc="删除")||(RepStatus.BTDesc="退回")||(RepStatus.BTDesc="作废")
		Set:return'="" return=return_"^"_xID
		Set:return="" return=xID
	}
	Quit return
}

/// Creator：     ShenC
/// CreatDate：   2020-12-15
/// Description:  通过报告ID查询ICU调查登记表相关信息
/// Table：       DHCHAI.IR.INFReport
/// Input：       aRepID: 报告ID
/// Return：      成功：返回字符串，失败：空
/// w ##class(DHCHAI.IRS.INFICUPICCSrv).GetICURepList("69")
ClassMethod GetICURepList(aRepID As %String) As %String
{
	New (aRepID)
	Set return=""
	
	Set objRep = ##class(DHCHAI.IR.INFReport).GetObjById(aRepID)
	Quit:'$ISObject(objRep) ""
	
	if $Isobject(objRep.IRStatusDr){
		Set RepStatus = objRep.IRStatusDr.BTDesc
	}
	if $Isobject(objRep.IRRepUser){
		Set RepUserID = objRep.IRRepUser.%Id()
		Set RepUserName =objRep.IRRepUser.BTDesc
	}
	Set RepDate = objRep.IRRepDate
	Set:RepDate'="" RepDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RepDate)
	Set APACHEScore = objRep.IRAPACHEScore				
	
	Set return=aRepID_"^"_RepStatus_"^"_RepUserID_"^"_RepUserName_"^"_RepDate_"^"_APACHEScore
	Quit return
}

}
