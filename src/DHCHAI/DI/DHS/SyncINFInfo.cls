/// 名称: DHCHAI.DI.DHS.SyncINFInfo
/// 描述: 同步东华历史感染信息
/// 编写者：zhufei
/// 编写日期: 2017-10-27
Class DHCHAI.DI.DHS.SyncINFInfo Extends (%RegisteredObject, DHCHAI.Abstract, User.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// 同步院感历史报告方法
/// w ##class(DHCHAI.DI.DHS.SyncINFInfo).SyncInfRep("2012-01-01","2012-12-31")
ClassMethod SyncInfRep(aDateFrom As %String, aDateTo As %String) As %String
{
	New (aDateFrom,aDateTo)
	Set return=""
	Quit:(aDateFrom="")||(aDateTo="") return
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateFrom'="" aDateFrom=+aDateFrom
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set:aDateFrom'="" aDateTo=+aDateTo
	Quit:(aDateFrom="")||(aDateTo="") "OK"
	
	Set CurrTime = $h
	Set arrAdm=##class(DHCHAI.Task.DPAdmListSrv).GetEpisodeIDXByDate(aDateFrom,aDateTo)
	For indAdm=1:1:arrAdm.Count() {
		Set xEpisodeID=arrAdm.GetAt(indAdm)
		Continue:xEpisodeID=""
		
		Write "EpisodeID="_xEpisodeID,!
		
		Do ##class(DHCHAI.DI.DHS.SyncINFInfo).SyncInfRepByAdm(xEpisodeID)
	}
	Write "用时："_($p($h,",",2)-$p(CurrTime,",",2))_"s",!
	Quit "OK"
}

/// 取对照转换信息
/// w ##class(DHCHAI.DI.DHS.SyncINFInfo).GetMapDic("感染诊断","败血症（bacteremia）")
ClassMethod GetMapDic(aType As %String, aValue As %String) As %String
{
	New (aType,aValue)
	Set return=""
	Quit:(aType="")||(aValue="") return
	
	//需要字典对照内容
	Set ^TMP("HAIMap.SyncInfRep","报告状态","删除")                     ="删除"
	Set ^TMP("HAIMap.SyncInfRep","报告状态","退回")                     ="保存"
	//Set ^TMP("HAIMap.SyncInfRep","感染诊断","败血症（bacteremia）")   ="败血症"
	Set ^TMP("HAIMap.SyncInfRep","感染诊断","泌尿道其它感染")           ="其它泌尿系感染"
	Set ^TMP("HAIMap.SyncInfRep","感染诊断","其它")                     ="其它部位感染"
	Set ^TMP("HAIMap.SyncInfRep","感染诊断","阴道穹窿部感染")           ="阴道穹隆部感染"
	Set ^TMP("HAIMap.SyncInfRep","感染诊断","纵膈感染")                 ="纵隔炎"
	Set ^TMP("HAIMap.SyncInfRep","诊断子分类","继发感染-其他部位")      ="继发血流感染（其他部位）"
	Set ^TMP("HAIMap.SyncInfRep","诊断子分类","继发感染-泌尿系统")      ="继发血流感染（泌尿系统）"
	Set ^TMP("HAIMap.SyncInfRep","诊断子分类","继发感染-皮肤软组织")    ="继发血流感染（皮肤软组织）"
	Set ^TMP("HAIMap.SyncInfRep","诊断子分类","继发感染-肺部")          ="继发血流感染（肺部）"
	Set ^TMP("HAIMap.SyncInfRep","诊断子分类","继发感染-胃肠道")        ="继发血流感染（胃肠道）"
	Set ^TMP("HAIMap.SyncInfRep","诊断子分类","继发感染-腹盆腔")        ="继发血流感染（腹盆腔）"
	// 协和zhoubo 
	Set ^TMP("HAIMap.SyncInfRep","感染诊断","表浅切口")       ="表浅手术切口感染"
	Set ^TMP("HAIMap.SyncInfRep","感染诊断","深部切口")       ="深部手术切口感染"
	Set ^TMP("HAIMap.SyncInfRep","感染诊断","器官/腔隙")      ="器官和腔隙感染"
	Set ^TMP("HAIMap.SyncInfRep","感染诊断","其它")           ="其它部位感染"
	
	Set ^TMP("HAIMap.SyncInfRep","侵害性操作","气管插管/切开")	="气管切开"
	Set ^TMP("HAIMap.SyncInfRep","标本","颈静脉导管抽血")		="中心静脉导管抽血"
	
	//青医
	Set ^TMP("HAIMap.SyncInfRep","报告状态","已审")                     ="审核"

	Set ^TMP("HAIMap.SyncInfRep","感染诊断","支气管炎")           ="下呼吸道感染"
	Set ^TMP("HAIMap.SyncInfRep","感染诊断","败血症")             ="血流感染"
	Set ^TMP("HAIMap.SyncInfRep","感染诊断","纵膈感染")           ="纵隔炎"
	Set ^TMP("HAIMap.SyncInfRep","感染诊断","腹(盆)腔内组织感染") = "腹（盆）腔内组织感染"
	Set ^TMP("HAIMap.SyncInfRep","感染诊断","阴道穹窿部感染") = "阴道穹隆部感染"
	Set ^TMP("HAIMap.SyncInfRep","感染诊断","颅内脓肿（包括脑脓肿、硬膜下和硬膜外脓肿等）") = "颅内脓肿"
	Set ^TMP("HAIMap.SyncInfRep","感染诊断","泌尿道感染") = "有症状的泌尿道感染"
	Set ^TMP("HAIMap.SyncInfRep","感染诊断","侵犯心脏瓣膜（包括人工心瓣膜）的心内膜炎") = "心内膜炎"
	Set ^TMP("HAIMap.SyncInfRep","感染诊断","口腔感染") = "口腔、舌、牙龈部位感染"
	Set ^TMP("HAIMap.SyncInfRep","感染诊断","牙龈炎") = "口腔、舌、牙龈部位感染" 
    Set ^TMP("HAIMap.SyncInfRep","感染诊断","牙髓炎") = "口腔、舌、牙龈部位感染" 
	Set ^TMP("HAIMap.SyncInfRep","感染诊断","眼内炎") = "眼部感染（结膜除外）"   
	Set ^TMP("HAIMap.SyncInfRep","感染诊断","角膜炎") = "眼部感染（结膜除外）"   
	Set ^TMP("HAIMap.SyncInfRep","感染诊断","眼部感染") = "眼部感染（结膜除外）"  
	Set ^TMP("HAIMap.SyncInfRep","感染诊断","外耳道炎") = "耳、乳突感染"    
	Set ^TMP("HAIMap.SyncInfRep","感染诊断","中耳炎") = "耳、乳突感染"    
	Set ^TMP("HAIMap.SyncInfRep","感染诊断","骨膜炎") = "耳、乳突感染"     
	Set ^TMP("HAIMap.SyncInfRep","感染诊断","耳部感染") = "耳、乳突感染" 
	   
	Set ^TMP("HAIMap.SyncInfRep","诊断子分类","其它肺炎")       ="其他肺炎"
	Set ^TMP("HAIMap.SyncInfRep","诊断子分类","导管相关性血流感染(CR-BSI)") ="导管相关血流感染（CLABSI）"
	Set ^TMP("HAIMap.SyncInfRep","诊断子分类","继发性血流感染")       ="继发血流感染（其他部位）"
	Set ^TMP("HAIMap.SyncInfRep","诊断子分类","原发性血流感染")       ="其他原发性血流感染"
	
	Set tValue=$g(^TMP("HAIMap.SyncInfRep",aType,aValue))
	Set:tValue'="" aValue=tValue
	
	If aType="报告状态" {
		Set objDic=##class(DHCHAI.BT.Dictionary).GetObjByDesc("InfReportStatus",aValue)
		Set:$IsObject(objDic) return=objDic.%Id()
	}
	
	If aType="与死亡关系" {
		Set objDic=##class(DHCHAI.BT.Dictionary).GetObjByDesc("RepDeathRelative",aValue)
		Set:$IsObject(objDic) return=objDic.%Id()
	}
	
	If aType="感染诊断" {
		Set objDic=##class(DHCHAI.BT.InfPos).GetObjByDesc(aValue)
		Set:$IsObject(objDic) return=objDic.%Id()
	}
	
	If aType="感染部位" {
		Set objDic=##class(DHCHAI.BT.InfPos).GetObjByDesc(aValue)
		Set:$IsObject(objDic) return=objDic.%Id()
	}
	
	If aType="诊断子分类" {
		Set objDic=##class(DHCHAI.BT.InfSub).GetObjByDesc(aValue)
		Set:$IsObject(objDic) return=objDic.%Id()
	}
	
	If aType="疾病转归" {
		Set objDic=##class(DHCHAI.BT.Dictionary).GetObjByDesc("InfDiseasePrognosis",aValue)
		Set:$IsObject(objDic) return=objDic.%Id()
	}
	
	If aType="侵害性操作" {
		Set objDic=##class(DHCHAI.BT.InvasOper).GetObjByDesc(aValue)
		Set:$IsObject(objDic) return=objDic.%Id()
	}
	
	If aType="标本" {
		Set objDic=##class(DHCHAI.DP.LabSpecimen).GetObjByCodeDesc("",aValue)
		Set:$IsObject(objDic) return=objDic.%Id()
	}
	
	//有值返回
	Quit:return'="" return
	
	Set ^TMP("HAIMap.SyncInfRep",aType,aValue)=""
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-10-27
/// Description:  根据就诊号同步历史感染信息
/// Input：       aEpisodeID：就诊号
/// Return：      处理报告数量
/// w ##class(DHCHAI.DI.DHS.SyncINFInfo).SyncInfRepByAdm("HIS01||18220599")
ClassMethod SyncInfRepByAdm(aEpisodeIDX As %String) As %String
{
	New (aEpisodeIDX)
	Set return=0,Count=0
	Quit:(aEpisodeIDX="") return
	Kill ^TMP($j,"SyncInfRep")
	
	Set SCode=$p(aEpisodeIDX,"||",1)
	Set EpisodeID=$p(aEpisodeIDX,"||",2)
	Quit:(SCode="")||(EpisodeID="") return
	
	//就诊记录检查
	Set objAdm=##class(DHCHAI.DP.PAAdm).GetObjByEpisodeIDX(aEpisodeIDX)
	Quit:'$IsObject(objAdm) return
	Set EpisodeDr=objAdm.%Id()
	Set DischDate=objAdm.PADischDate
	Set DischTime=objAdm.PADischTime
	
	Set rs=##Class(%ResultSet).%New("DHCHAI.DI.DIO.FromINFSrv:QryInfRepList")
  	Set sc=rs.Execute(EpisodeID)
  	If $$$ISERR(sc) {
	  	Do $System.Status.DisplayError(sc)
	  	Quit return
  	}
	Set rowData=##Class(%ArrayOfDataTypes).%New()
	If rowData'="" Do rowData.%Close()
    While (rs.Next()){
	    
	    Do rowData.Clear()  //清空数组
	    Do rowData.SetAt(SCode,"SCode")
	    Do rowData.SetAt(EpisodeID,"EpisodeID")
	    Do rowData.SetAt(EpisodeDr,"EpisodeDr")                    // 就诊号（DHCHAI.DP.PAAdm.ID）
		Do rowData.SetAt(rs.Data("ID"),"ID")                       // 历史报告ID
		Do rowData.SetAt(rs.Data("ReportType"),"ReportType")       // 报告类型
		Do rowData.SetAt(rs.Data("RepLocID"),"RepLocID")           // 报告科室ID
		Do rowData.SetAt(rs.Data("RepLocCode"),"RepLocCode")       // 报告科室代码
		Do rowData.SetAt(rs.Data("RepLocDesc"),"RepLocDesc")       // 报告科室名称
		Do rowData.SetAt(rs.Data("ReportDate"),"ReportDate")       // 报告日期
		Do rowData.SetAt(rs.Data("ReportTime"),"ReportTime")       // 报告时间
		Do rowData.SetAt(rs.Data("RepUserID"),"RepUserID")         // 报告人ID
		Do rowData.SetAt(rs.Data("RepUserCode"),"RepUserCode")     // 报告人工号
		Do rowData.SetAt(rs.Data("RepUserDesc"),"RepUserDesc")     // 报告人姓名
		Do rowData.SetAt(rs.Data("RepStatusCode"),"RepStatusCode") // 报告状态代码
		Do rowData.SetAt(rs.Data("RepStatusDesc"),"RepStatusDesc") // 报告状态名称
	    Set ReportType=rs.Data("ReportType")
	    If ReportType="COMP" {	//保存历史感染报告
			Set InfRepDr=..SaveInfRep(rowData)
			Continue:(+InfRepDr)<1
	    }
	    //青医附院增加同步新生儿报告
	    If ReportType="NCOM" {	//保存历史新生儿感染报告
			Set InfRepDr=..SaveNInfRep(rowData)
			Continue:(+InfRepDr)<1
	    }
		
		//计数
		Set Count=Count+1
    }
    
	Set return=Count
	Kill ^TMP($j,"SyncInfRep")
	Quit return
}

ClassMethod SaveInfRep(rd As %ArrayOfDataTypes) As %String
{
	New (rd)
	Set return=0
	Quit:(rd="") return
	
	Set $ZT="SaveInfRepErr"
	
	Set SCode          = rd.GetAt("SCode")
	Set EpisodeID      = rd.GetAt("EpisodeID")
	Set EpisodeDr      = rd.GetAt("EpisodeDr")
	Set ReportID       = rd.GetAt("ID")             // 旧版报告ID
	Set ReportType     = rd.GetAt("ReportType")     // 报告类型
	Set RepLocID       = rd.GetAt("RepLocID")       // 报告科室ID
	Set RepLocCode     = rd.GetAt("RepLocCode")     // 报告科室代码
	Set RepLocDesc     = rd.GetAt("RepLocDesc")     // 报告科室名称
	Set ReportDate     = rd.GetAt("ReportDate")     // 报告日期
	Set ReportTime     = rd.GetAt("ReportTime")     // 报告时间
	Set RepUserID      = rd.GetAt("RepUserID")      // 报告人ID
	Set RepUserCode    = rd.GetAt("RepUserCode")    // 报告人工号
	Set RepUserDesc    = rd.GetAt("RepUserDesc")    // 报告人姓名
	Set RepStatusCode  = rd.GetAt("RepStatusCode")  // 报告状态代码
	Set RepStatusDesc  = rd.GetAt("RepStatusDesc")  // 报告状态名称
	Quit:ReportID="" return
	// 如果报告存在,重复同步时,先删除报告下的易感因素、侵害性操作、病原体药敏
	Set NewRepID = ##class(DHCHAI.IR.INFRepExt).GetObjIDByHisID("DHCHAI.IR.INFReport",ReportID)
	
	If (NewRepID'="") {
		Set flg=##class(DHCHAI.IR.INFRepExt).DelRepExtInfo(NewRepID,"DHCHAI.IR.INFPreFactor")
		Set flg=##class(DHCHAI.IR.INFRepExt).DelRepExtInfo(NewRepID,"DHCHAI.IR.INFInvOper")
		// 删除病原体  DHCHAI.IR.INFLabBact
		Set xSub=0
		For {
			Set xSub=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt("DHCHAI.IR.INFLab","U"),NewRepID,xSub))
			Quit:xSub=""
			
			Set RepExtID=NewRepID_"||"_xSub
			Set obj=##class(DHCHAI.IR.INFRepExt).GetObjById(RepExtID)
			Continue:'$IsObject(obj)
			// 关联报告ID
			Set ObjectID = obj.IRObjectID
			
			Set xBactID = ""
		 	For {
		 		Set xBactID = $o(^DHCHAI.IR.INFLabI("BACT","IndexParrefBactDicDr",ObjectID,xBactID))
		 		Quit:xBactID=""
		 		
		 		Set xSubID = ""
		 		For {
			 		Set xSubID = $o(^DHCHAI.IR.INFLabI("BACT","IndexParrefBactDicDr",ObjectID,xBactID,xSubID))
		 			Quit:xSubID=""
		 			Set xID = ObjectID_"||"_xSubID
		 			Set flg = ##Class(DHCHAI.IR.INFLabBact).DeleteById(xID)
		 		}
		 	}
		}
	}
	Set RepLocDr=""
	Set objRepLoc=##class(DHCHAI.BT.Location).GetObjByLocCode(SCode,RepLocCode)
	If '$IsObject(objRepLoc){
		W:RepLocDesc'="" "报告科室："_RepLocCode_"//"_RepLocDesc,!
	}
	Set:$IsObject(objRepLoc) RepLocDr=objRepLoc.%Id()
	
	Set RepUserDr=""
	Set objRepUser=##class(DHCHAI.BT.SysUser).GetObjByUserCode(SCode,RepUserCode)
	If '$IsObject(objRepUser){
		W:RepUserDesc'="" "报告人："_RepUserCode_"//"_RepUserDesc,!
	}
	Set:$IsObject(objRepUser) RepUserDr=objRepUser.%Id()
	
	Set RepStatusDr=..GetMapDic("报告状态",RepStatusDesc)
	
	Set arrRepInfo=##Class(DHCHAI.DI.DIO.FromINFSrv).GetInfReport(ReportID)
	Quit:arrRepInfo.Count()<1 return
	
	Set DeathRelation=arrRepInfo.GetAt("DeathRelation")
	Set DeathRelationDr=..GetMapDic("与死亡关系",DeathRelation)
	
	// 感染信息
	Set LinkDiagDrs=""
	Set arrInfRepPos=arrRepInfo.GetAt("InfRepPos")
	For indInfPos=1:1:arrInfRepPos.Count() {
		Set InfPosStr=arrInfRepPos.GetAt(indInfPos)
		Continue:InfPosStr=""
		Set RepPosID         = $p(InfPosStr,"^",1)   //旧版感染诊断ID
		Set InfPosDesc       = $p(InfPosStr,"^",2)   //感染部位
		Set InfDiagDesc      = $p(InfPosStr,"^",3)   //感染诊断
		Set InfDiagCatDesc   = $p(InfPosStr,"^",4)   //诊断子分类
		Set InfDate          = $p(InfPosStr,"^",5)   //感染日期
		Set InfXDate         = $p(InfPosStr,"^",6)   //感染转归日期
		Set InfEndResultDesc = $p(InfPosStr,"^",7)   //转归
		Set DiagnosisBasis   = $p(InfPosStr,"^",8)   //诊断依据
		Set DiseaseCourse    = $p(InfPosStr,"^",9)   //感染性疾病病程
		
		//协和
		If (InfEndResultDesc="")&&(arrRepInfo.GetAt("DiseasePrognosis")'=""){
			Set InfEndResultDesc=arrRepInfo.GetAt("DiseasePrognosis").Description	//转归
		}
		If InfDiagDesc'="" {
			Set InfPosDr=..GetMapDic("感染诊断",InfDiagDesc)
		} Else {
			Set InfPosDr=..GetMapDic("感染部位",InfPosDesc)
		}
		Set InfSubDr=..GetMapDic("诊断子分类",InfDiagCatDesc)
		Set InfEndResultDr=..GetMapDic("疾病转归",InfEndResultDesc)
		
		Set tID=##class(DHCHAI.IR.INFRepExt).GetObjIDByHisID("DHCHAI.IR.INFDiagnos",RepPosID)
		Set InputStr=tID
		Set InputStr=InputStr_"^"_EpisodeDr
		Set InputStr=InputStr_"^"_InfPosDr
		Set InputStr=InputStr_"^"_InfSubDr
		Set InputStr=InputStr_"^"_InfDate
		Set InputStr=InputStr_"^"_RepLocDr  //报告科室作为感染科室
		Set InputStr=InputStr_"^"_DiagnosisBasis
		Set InputStr=InputStr_"^"_DiseaseCourse
		Set InputStr=InputStr_"^"_InfXDate
		Set InputStr=InputStr_"^"_InfEndResultDr
		Set InputStr=InputStr_"^"_DeathRelationDr
		Set InputStr=InputStr_"^"_ReportDate
		Set InputStr=InputStr_"^"_ReportTime
		Set InputStr=InputStr_"^"_RepUserDr
		
		Set InfDiagnosDr=##class(DHCHAI.IR.INFDiagnos).Update(InputStr,"^")
		If (+InfDiagnosDr)<1 {
			//记录错误日志
			Set ErrClass  = "DHCHAI.IR.INFDiagnos"
			Set ErrMethod = "Update"
			Set ErrArgStr = $lb(InputStr,"^")
			Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
		} Else {
			Set LinkDiagDrs=LinkDiagDrs_","_InfDiagnosDr
			Set ^TMP($j,"SyncInfRep","DHCHAI.IR.INFDiagnos",InfDiagnosDr)=RepPosID
		}
	}
	Set:LinkDiagDrs'="" LinkDiagDrs=$e(LinkDiagDrs,2,$l(LinkDiagDrs))
	// 易感因素 zhoubo
	Set LinkPreFactDrs=""
	Set FactorsList=arrRepInfo.GetAt("FactorsDesc")
	For indFact=1:1:$l(FactorsList,",") {
		Set InfFactStr=$p(FactorsList,",",indFact)
		Continue:InfFactStr=""
		Set FactDr = ..GetObjIDByFactDesc(InfFactStr)
		
		Set InputStr=""
		Set InputStr=InputStr_"^"_EpisodeDr
		Set InputStr=InputStr_"^"_FactDr
		Set InputStr=InputStr_"^"_RepUserDr
		
		Set PreFactDr=##class(DHCHAI.IR.INFPreFactor).Update(InputStr,"^")
		If (+PreFactDr)<1 {
			//记录错误日志
			Set ErrClass  = "DHCHAI.IR.INFPreFactor"
			Set ErrMethod = "Update"
			Set ErrArgStr = $lb(InputStr,"^")
			Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
		} Else {
			Set LinkPreFactDrs=LinkPreFactDrs_","_PreFactDr
		}
	}
	Set:LinkPreFactDrs'="" LinkPreFactDrs=$e(LinkPreFactDrs,2,$l(LinkPreFactDrs))
	
	// 侵害性操作 zhoubo
	Set LinkInvOperDrs=""
	Set InvasList=arrRepInfo.GetAt("InvasiveDesc")
	For indInvas=1:1:$l(InvasList,",") {
		Set InfInvasStr=$p(InvasList,",",indInvas)
		Continue:InfInvasStr=""
		Set InvasDr=..GetMapDic("侵害性操作",InfInvasStr)
		//Set InvasDr = ..GetObjIDByInvOper(InfInvasStr)
		
		Set InputStr=""
		Set InputStr=InputStr_"^"_EpisodeDr
		Set InputStr=InputStr_"^"_InvasDr
		Set InputStr=InputStr_"^"_""       // 开始日期
		Set InputStr=InputStr_"^"_""       // 结束日期
		Set InputStr=InputStr_"^"_RepUserDr
		
		Set InvasDr=##class(DHCHAI.IR.INFInvOper).Update(InputStr,"^")
		If (+InvasDr)<1 {
			//记录错误日志
			Set ErrClass  = "DHCHAI.IR.INFInvOper"
			Set ErrMethod = "Update"
			Set ErrArgStr = $lb(InputStr,"^")
			Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
		} Else {
			Set LinkInvOperDrs=LinkInvOperDrs_","_InvasDr
		}
	}
	Set:LinkInvOperDrs'="" LinkInvOperDrs=$e(LinkInvOperDrs,2,$l(LinkInvOperDrs))
	
	//基础疾病 zhoubo
	Set LinkICDDrs=""        
	Set arrRepICD=arrRepInfo.GetAt("InfRepDiag")
	For indInfICD=1:1:arrRepICD.Count() {
		Set InfICDStr=arrRepICD.GetAt(indInfICD)
		Continue:InfICDStr=""
		
		Set RepICDID      = $p(InfICDStr,"^",1)   // 旧版疾病ID
		Set Diagnos       = $p(InfICDStr,"^",2)   // 诊断字典名称
		Set DiagnosDesc   = $p(InfICDStr,"^",3)   // 诊断名称
		Set DiagnosDate   = $p(InfICDStr,"^",4)   // 诊断日期
		Set DiagnosTime   = $p(InfICDStr,"^",5)   // 诊断时间
		
		Set DiagDr = ##class(DHCHAI.DP.MRICDDx).GetObjByCodeDesc("",Diagnos)
		Set:DiagDr="" DiagDr = ##class(DHCHAI.DP.MRICDDx).GetObjByCodeDesc("",DiagnosDesc)
		Set:$IsObject(DiagDr) DiagDr=DiagDr.%Id()
		
		Set tID=##class(DHCHAI.IR.INFRepExt).GetObjIDByHisID("DHCHAI.IR.INFICD",RepICDID)
		Set InputStr=tID
		Set InputStr=InputStr_"^"_EpisodeDr
		Set InputStr=InputStr_"^"_DiagDr
		Set InputStr=InputStr_"^"_DiagnosDesc
		Set InputStr=InputStr_"^"_DiagnosDesc
		Set InputStr=InputStr_"^"_DiagnosDate
		Set InputStr=InputStr_"^"_DiagnosTime
		Set InputStr=InputStr_"^"_RepUserDr
		
		Set InfICDDr=##class(DHCHAI.IR.INFICD).Update(InputStr,"^")
		If (+InfICDDr)<1 {
			//记录错误日志
			Set ErrClass  = "DHCHAI.IR.INFICD"
			Set ErrMethod = "Update"
			Set ErrArgStr = $lb(InputStr,"^")
			Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
		} Else {
			Set LinkICDDrs=LinkICDDrs_","_InfICDDr
			Set ^TMP($j,"SyncInfRep","DHCHAI.IR.INFICD",InfICDDr)=RepICDID
		}
	}
	Set:LinkICDDrs'="" LinkICDDrs=$e(LinkICDDrs,2,$l(LinkICDDrs))
	
	// 手术信息  zhoubo
	Set LinkOperDrs=""
	Set arrInfRepOper=arrRepInfo.GetAt("InfRepOper")
	For indInfOper=1:1:arrInfRepOper.Count() {
		Set InfOperStr=arrInfRepOper.GetAt(indInfOper)
		Continue:InfOperStr=""
		Set RepOperID        = $p(InfOperStr,"^",1)    // 旧版手术ID
		Set OperationDesc    = $p(InfOperStr,"^",2)    // 手术名称
		Set OperStartDate    = $p(InfOperStr,"^",3)    // 手术开始日期
		Set OperStartTime    = $p(InfOperStr,"^",4)    // 手术开始时间
		Set OperEndDate      = $p(InfOperStr,"^",5)    // 手术结束日期
		Set OperEndTime      = $p(InfOperStr,"^",6)    // 手术结束时间
		Set OperDoc          = $p(InfOperStr,"^",7)    // 手术医生
		Set OperDocDr        = ..GetObjIDByUserDesc(OperDoc)
		Set OperTypeDesc     = $p(InfOperStr,"^",8)    // 手术类型
		Set OperTypeDr       = ..GetMapIDByPhrase("HIS01","NINFInfOperationType",OperTypeDesc)
		Set AnesDesc         = $p(InfOperStr,"^",9)    // 麻醉方式
		Set AnesthesiaDr     = ..GetMapIDByPhrase("HIS01","NINFInfAnesthesia",AnesDesc)
		Set CuteTypeDesc     = $p(InfOperStr,"^",10)   // 切口类型
		Set CuteTypeDr       = ..GetMapIDByPhrase("HIS01","NINFInfCuteType",CuteTypeDesc)
		Set CuteHealingDesc  = $p(InfOperStr,"^",11)   // 愈合情况
		Set CuteHealingDr    = ..GetMapIDByPhrase("HIS01","NINFInfCuteHealing",CuteHealingDesc)
		Set CuteInfFlag      = $p(InfOperStr,"^",12)   // 切口感染(是/否)
		Set CuteInfFlag      = $S(CuteInfFlag="是":1,1:0)
		Set OperInfTypeDesc  = $p(InfOperStr,"^",13)   // 手术感染类型
		Set InfTypeDr        = ..GetMapDic("感染诊断",OperInfTypeDesc)
		Set ASAScoreDesc     = $p(InfOperStr,"^",14)   // ASA评分
		Set ASAScoreDr       = ..GetMapIDByPhrase("HIS01","NINFInfASAScore",ASAScoreDesc)
		Set InHospInfFlag    = $p(InfOperStr,"^",15)   // 引起院感(是/否)
		Set InHospInfFlag    = $S(InHospInfFlag="是":1,1:0)
		Set CuteNumberDesc   = $p(InfOperStr,"^",16)   // 切口个数
		Set EndoscopeFlag    = $p(InfOperStr,"^",17)   //使用窥镜(是/否)
		Set EndoscopeFlag    = $S(EndoscopeFlag="是":1,1:0)
		Set ImplantFlag      = $p(InfOperStr,"^",18)   // 植入物(是/否)
		Set ImplantFlag      = $S(ImplantFlag="是":1,1:0)
		Set PreoperWBC       = $p(InfOperStr,"^",19)   // 术前外周WBC计数
		Set BloodLoss        = $p(InfOperStr,"^",20)   // 失血量
		Set BloodTrans       = $p(InfOperStr,"^",21)   // 输血量
		Set PreoperAntiFlag  = $p(InfOperStr,"^",22)   // 术前口服抗生素肠道准备
		Set PreoperAntiFlag  = $S(PreoperAntiFlag="是":1,1:0)
		Set BloodLossFlag    = $p(InfOperStr,"^",23)   // 失血(是/否)
		Set InHospInfFlag    = $S(InHospInfFlag="是":1,1:0)
		Set BloodTransFlag   = $p(InfOperStr,"^",24)   // 输血(是/否)
		Set InHospInfFlag    = $S(InHospInfFlag="是":1,1:0)
		
		Set tID=##class(DHCHAI.IR.INFRepExt).GetObjIDByHisID("DHCHAI.IR.INFOPS",RepOperID)
		Set InputStr=tID
		Set InputStr=InputStr_"^"_EpisodeDr
		Set InputStr=InputStr_"^"_"" 
		Set InputStr=InputStr_"^"_RepLocDr           // 报告科室作为手术科室
		Set InputStr=InputStr_"^"_OperationDesc      // 手术名称
		Set InputStr=InputStr_"^"_OperationDesc      // 标准手术名称
		Set InputStr=InputStr_"^"_OperStartDate      // 手术开始日期
		Set InputStr=InputStr_"^"_OperEndDate        // 手术结束日期
		Set InputStr=InputStr_"^"_OperStartTime      // 手术开始时间
		Set InputStr=InputStr_"^"_OperEndTime        // 手术结束时间
		Set InputStr=InputStr_"^"_""                 // 手术时长
		Set InputStr=InputStr_"^"_OperDoc            // 手术医生
		Set InputStr=InputStr_"^"_OperDocDr          // 手术医生DR
		Set InputStr=InputStr_"^"_OperTypeDr         // 手术类型
		Set InputStr=InputStr_"^"_AnesthesiaDr       // 麻醉方式
		Set InputStr=InputStr_"^"_""                 // NNIS分级
		Set InputStr=InputStr_"^"_CuteTypeDr         // 切口类型
		Set InputStr=InputStr_"^"_CuteHealingDr      // 愈合情况
		Set InputStr=InputStr_"^"_CuteInfFlag        // 切口是否感染
		Set InputStr=InputStr_"^"_InfTypeDr          // 手术感染类型
		Set InputStr=InputStr_"^"_InHospInfFlag      // 是否引起院感
		Set InputStr=InputStr_"^"_ASAScoreDr         // ASA评分
		Set InputStr=InputStr_"^"_PreoperWBC         // 术前外周WBC计数
		Set InputStr=InputStr_"^"_CuteNumberDesc     // 切口个数
		Set InputStr=InputStr_"^"_EndoscopeFlag      // 是否使用窥镜
		Set InputStr=InputStr_"^"_ImplantFlag        // 植入物(是/否)
		Set InputStr=InputStr_"^"_PreoperAntiFlag    // 术前口服抗生素肠道准备
		Set InputStr=InputStr_"^"_BloodLoss          // 失血量
		Set InputStr=InputStr_"^"_BloodTrans         // 输血量
		Set InputStr=InputStr_"^"_""                 // 并发症
		Set InputStr=InputStr_"^"_ReportDate         // 更新日期
		Set InputStr=InputStr_"^"_ReportTime         // 更新时间
		Set InputStr=InputStr_"^"_RepUserDr          // 更新人 
		
		Set InfOpertionDr=##class(DHCHAI.IR.INFOPS).Update(InputStr,"^")
		If (+InfOpertionDr)<1 {
			//记录错误日志
			Set ErrClass  = "DHCHAI.IR.INFOPS"
			Set ErrMethod = "Update"
			Set ErrArgStr = $lb(InputStr,"^")
			Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
		} Else {
			Set LinkOperDrs=LinkOperDrs_","_InfOpertionDr
			Set ^TMP($j,"SyncInfRep","DHCHAI.IR.INFOPS",InfOpertionDr)=RepOperID
		}
	}
	Set:LinkOperDrs'="" LinkOperDrs=$e(LinkOperDrs,2,$l(LinkOperDrs))
	
	// 抗菌药物信息  zhoubo
	Set LinkAntiDrs=""
	Set arrInfRepAnti=arrRepInfo.GetAt("InfRepAnti")
	For indInfAnti=1:1:arrInfRepAnti.Count() {
		Set InfAntiStr=arrInfRepAnti.GetAt(indInfAnti)
		Continue:InfAntiStr=""
		Set RepAntiID        = $p(InfAntiStr,"^",1)    // 旧版抗菌药物ID
		Set ArcimDesc        = $p(InfAntiStr,"^",2)    // 医嘱名称
		Set StartDate        = $p(InfAntiStr,"^",3)    // 开始日期
		Set StartTime        = $p(InfAntiStr,"^",4)    // 开始时间
		Set EndDate          = $p(InfAntiStr,"^",5)    // 结束日期
		Set EndTime          = $p(InfAntiStr,"^",6)    // 结束时间
		Set DoseQty          = $p(InfAntiStr,"^",7)    // 剂量
		Set DoseUnit         = $p(InfAntiStr,"^",8)    // 剂量单位
		Set DoseUnit         = ..GetMapIDByPhrase("HIS01","NINFInfAntiUOM",DoseUnit)
		Set PhcFreq          = $p(InfAntiStr,"^",9)    // 频次
		Set PhcFreq          = ..GetMapIDByPhrase("HIS01","NINFInfAntiFreq",PhcFreq)
		Set PreMedTime       = $p(InfAntiStr,"^",10)   // 术前用药时间(分钟)  1小时0分钟
		Set PreMedTimeH      = $p(PreMedTime,"小时",1)
		Set PreMedTimeM      = +$p(PreMedTime,"小时",2)
		Set PreMedTime       = (PreMedTimeH*60)+PreMedTimeM
		Set PostMedDays      = +$p(InfAntiStr,"^",11)  // 术后用药天数(天)
		Set UseDesc          = $p(InfAntiStr,"^",12)   // 用途
		Set UsePurposeDr     = ..GetMapIDByPhrase("HIS01","NINFInfMedUsePurpose",UseDesc)
		Set AdminRouteDesc   = $p(InfAntiStr,"^",13)   // 给药途径
		Set AdminRouteDr     = ..GetMapIDByPhrase("HIS01","NINFInfAdminRoute",AdminRouteDesc)
		Set MedPurposeDesc   = $p(InfAntiStr,"^",14)   // 目的
		Set PurposeDr        = ..GetMapIDByPhrase("HIS01","NINFInfMedPurpose",MedPurposeDesc)
		Set TreatmentDesc    = $p(InfAntiStr,"^",15)   // 治疗用药方式
		Set TreatmentDr      = ..GetMapIDByPhrase("HIS01","NINFInfTreatmentMode",TreatmentDesc)
		Set PreMedIndDesc    = $p(InfAntiStr,"^",16)   // 预防用药指征
		Set PreMedIndDr      = ..GetMapIDByPhrase("HIS01","NINFInfPreMedIndicat",PreMedIndDesc)
		Set EffectDesc       = $p(InfAntiStr,"^",17)   // 预防用药效果
		Set EffectDr         = ..GetMapIDByPhrase("HIS01","NINFInfPreMedEffect",EffectDesc)
		Set CombinedMedDesc  = $p(InfAntiStr,"^",18)   // 联合用药
		Set CombinedDr       = ..GetMapIDByPhrase("HIS01","NINFInfCombinedMed",CombinedMedDesc)
		
		Set tID=##class(DHCHAI.IR.INFRepExt).GetObjIDByHisID("DHCHAI.IR.INFAnti",RepAntiID)
		Set InputStr=tID
		Set InputStr=InputStr_"^"_EpisodeDr
		Set InputStr=InputStr_"^"_"" 
		Set InputStr=InputStr_"^"_ArcimDesc        // 医嘱名称
		Set InputStr=InputStr_"^"_ArcimDesc        // 医嘱名称2
		Set InputStr=InputStr_"^"_StartDate        // 开始日期
		Set InputStr=InputStr_"^"_EndDate          // 结束日期
		Set InputStr=InputStr_"^"_DoseQty          // 剂量
		Set InputStr=InputStr_"^"_DoseUnit         // 剂量单位
		Set InputStr=InputStr_"^"_PhcFreq          // 频次
		Set InputStr=InputStr_"^"_UsePurposeDr     // 用途
		Set InputStr=InputStr_"^"_AdminRouteDr     // 给药途径
		Set InputStr=InputStr_"^"_PurposeDr        // 目的
		Set InputStr=InputStr_"^"_TreatmentDr      // 治疗用药方式
		Set InputStr=InputStr_"^"_EffectDr         // 预防用药效果
		Set InputStr=InputStr_"^"_PreMedIndDr      // 预防用药指征
		Set InputStr=InputStr_"^"_CombinedDr       // 联合用药
		Set InputStr=InputStr_"^"_PreMedTime       // 术前用药时间(分钟)
		Set InputStr=InputStr_"^"_PostMedDays      // 术后用药天数(天)
		Set InputStr=InputStr_"^"_""               // SenAna
		Set InputStr=InputStr_"^"_ReportDate       // 更新日期
		Set InputStr=InputStr_"^"_ReportTime       // 更新时间
		Set InputStr=InputStr_"^"_RepUserDr        // 更新人 
		
		Set InfAntiDr=##class(DHCHAI.IR.INFAnti).Update(InputStr,"^")
		If (+InfAntiDr)<1 {
			//记录错误日志
			Set ErrClass  = "DHCHAI.IR.INFAnti"
			Set ErrMethod = "Update"
			Set ErrArgStr = $lb(InputStr,"^")
			Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
		} Else {
			Set LinkAntiDrs=LinkAntiDrs_","_InfAntiDr
			Set ^TMP($j,"SyncInfRep","DHCHAI.IR.INFAnti",InfAntiDr)=RepAntiID
		}
	}
	Set:LinkAntiDrs'="" LinkAntiDrs=$e(LinkAntiDrs,2,$l(LinkAntiDrs))
	
	// 病原学检验信息  zhoubo
	Set LinkLabDrs=""
	Set arrInfRepLab=arrRepInfo.GetAt("InfRepLab")
	For indInfLab=1:1:arrInfRepLab.Count() {
		Set InfLabStr=arrInfRepLab.GetAt(indInfLab)
		Continue:InfLabStr=""
		Set RepLabID         = $p(InfLabStr,"^",1)    // 旧版检验ID
		Set ArcimDesc        = $p(InfLabStr,"^",2)    // 检验医嘱名称
		Set SpecimenDesc     = $p(InfLabStr,"^",3)    // 标本
		Set SpecimenDr       = ##class(DHCHAI.DP.LabSpecMap).GetStanSpecByDesc("LIS01",SpecimenDesc)
		Set:$IsObject(SpecimenDr) SpecimenDr=SpecimenDr.%Id()
		Set:SpecimenDr="" SpecimenDr=..GetMapDic("标本",SpecimenDesc)
		Set AssayMethodDesc  = $p(InfLabStr,"^",4)    // 检验方法
		Set AssayMethodDr    = ..GetMapIDByPhrase("HIS01","NINFInfAssayMethod",AssayMethodDesc)
		Set SubmissionDate   = $p(InfLabStr,"^",5)    // 送检日期
		Set PathogenTestDesc = $p(InfLabStr,"^",6)    // 病原学检验
		Set PathTestDr       = ..GetMapIDByPhrase("HIS01","NINFInfPathogenTest",PathogenTestDesc)
		
		Set tID=##class(DHCHAI.IR.INFRepExt).GetObjIDByHisID("DHCHAI.IR.INFLab",RepLabID)
		Set InputStr=tID
		Set InputStr=InputStr_"^"_EpisodeDr
		Set InputStr=InputStr_"^"_"" 
		Set InputStr=InputStr_"^"_ArcimDesc        // 检验医嘱名称
		Set InputStr=InputStr_"^"_ArcimDesc        // 检验组套（标准医嘱）
		Set InputStr=InputStr_"^"_SpecimenDr       // 标本
		Set InputStr=InputStr_"^"_SubmissionDate   // 送检日期
		Set InputStr=InputStr_"^"_RepLocDr         // 报告科室作为送检科室
		Set InputStr=InputStr_"^"_AssayMethodDr    // 检验方法
		Set InputStr=InputStr_"^"_PathTestDr       // 病原学检验
		Set InputStr=InputStr_"^"_ReportDate       // 更新日期
		Set InputStr=InputStr_"^"_ReportTime       // 更新时间
		Set InputStr=InputStr_"^"_RepUserDr        // 更新人 
		Set InputStr=InputStr_"^"_""               // 是否传染病病原
		
		Set InfLabDr=##class(DHCHAI.IR.INFLab).Update(InputStr,"^")
		If (+InfLabDr)<1 {
			//记录错误日志
			Set ErrClass  = "DHCHAI.IR.INFLab"
			Set ErrMethod = "Update"
			Set ErrArgStr = $lb(InputStr,"^")
			Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
		} Else {
			Set LinkLabDrs=LinkLabDrs_","_InfLabDr
			Set ^TMP($j,"SyncInfRep","DHCHAI.IR.INFLab",InfLabDr)=RepLabID
		}
		
		Set InfRepLabPy = $p(InfLabStr,"^",7)    // 检验结果(病原体)
		For indPy=1:1:$l(InfRepLabPy,",") {
			Set tmpInfRepLabPy  = $p(InfRepLabPy,",",indPy)
			Set PathogenyDesc   = $p(tmpInfRepLabPy,"#",1)   // 病原体
			Set:PathogenyDesc'="" PathogenyDesc=$tr(PathogenyDesc," ","")
			Set PYWhonet        = $p(tmpInfRepLabPy,"#",2)   // whonet码
			Set PYDesc          = $p(tmpInfRepLabPy,"#",3)   // 病原体名称
			Set:PYDesc'="" PYDesc=$tr(PYDesc," ","")
			Set BactDicDr = ##class(DHCHAI.DP.LabBactMap).GetStanBactByDesc("LIS01",PYDesc)
			Set:BactDicDr="" BactDicDr=##class(DHCHAI.DP.LabBactMap).GetStanBactByDesc("LIS01",PathogenyDesc)
			Set:$IsObject(BactDicDr) BactDicDr=BactDicDr.%Id()
			Set DrugSenTest = $p(tmpInfRepLabPy,"#",4)   // 药敏实验
			
			Set DrugSens=""
			
			For indPyTest=1:1:$l(DrugSenTest,"&") {
				Set tmpSenTest  = $p(DrugSenTest,"&",indPyTest)
				Set AntibioticsDesc   = $p(tmpSenTest,"!",1)   // 抗生素
				Set:AntibioticsDesc'="" AntibioticsDesc=$tr(AntibioticsDesc," ","")
				Set ANTCode           = $p(tmpSenTest,"!",2)   // 代码
				Set ANTDesc           = $p(tmpSenTest,"!",3)   // 抗菌药物名称
				Set:ANTDesc'="" ANTDesc=$tr(ANTDesc," ","")
				Set AntiDicDr = ##class(DHCHAI.DP.LabAntiMap).GetStanAntiByDesc("LIS01",ANTDesc)
				Set:AntiDicDr="" AntiDicDr = ##class(DHCHAI.DP.LabAntiMap).GetStanAntiByDesc("LIS01",AntibioticsDesc)
				Set:$IsObject(AntiDicDr) AntiDicDr=AntiDicDr.%Id()
				Set SenTestRstDesc = $p(tmpSenTest,"!",4)   // 药敏结果
				Set DrugSenDr = ..GetMapIDByPhrase("HIS01","NINFInfSenTestRst",SenTestRstDesc)
				Set DrugSens  =DrugSens_$lb($lb(AntiDicDr,AntibioticsDesc,DrugSenDr))
			}
			Set InputStr=InfLabDr
			Set InputStr=InputStr_"^"_"" 
			Set InputStr=InputStr_"^"_BactDicDr        // 病原体字典
			Set InputStr=InputStr_"^"_PathogenyDesc    // 病原体
			Set InfLabBactDr=##class(DHCHAI.IR.INFLabBact).Update(InputStr,DrugSens,"^")
			
			If (+InfLabBactDr)<1 {
				//记录错误日志
				Set ErrClass  = "DHCHAI.IR.INFLabBact"
				Set ErrMethod = "Update"
				Set ErrArgStr = $lb(InputStr,"^")
				Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
			}
		}
	}
	Set:LinkLabDrs'="" LinkLabDrs=$e(LinkLabDrs,2,$l(LinkLabDrs))
		
	Set tID = ##class(DHCHAI.IR.INFRepExt).GetObjIDByHisID("DHCHAI.IR.INFReport",ReportID)
	Set InputStr=tID
	Set $p(InputStr,"^",2)=EpisodeDr
	Set $p(InputStr,"^",3)=1  //感染报告
	Set $p(InputStr,"^",4)=ReportDate
	Set $p(InputStr,"^",5)=ReportTime
	Set $p(InputStr,"^",6)=RepLocDr
	Set $p(InputStr,"^",7)=RepUserDr
	Set $p(InputStr,"^",8)=RepStatusDr
	Set $p(InputStr,"^",9)=LinkDiagDrs
	Set $p(InputStr,"^",10)=LinkICDDrs   // LinkICDDrs
	Set $p(InputStr,"^",11)=LinkLabDrs   // LinkLabDrs
	Set $p(InputStr,"^",12)=LinkAntiDrs  // LinkAntiDrs
	Set $p(InputStr,"^",13)=LinkOperDrs  // LinkOPSDrs
	Set $p(InputStr,"^",14)=""  // LinkMRBDrs
	Set $p(InputStr,"^",15)=LinkInvOperDrs  // LinkInvOperDrs
	Set $p(InputStr,"^",16)=LinkPreFactDrs  // LinkPreFactDrs
	Set $p(InputStr,"^",17)=""  // LinkICUUCDrs
	Set $p(InputStr,"^",18)=""  // LinkICUVAPDrs
	Set $p(InputStr,"^",19)=""  // LinkICUPICCDrs
	Set $p(InputStr,"^",20)=""  // IRInLocDr
	Set $p(InputStr,"^",21)=""  // IROutLocDr
	Set $p(InputStr,"^",22)=""  // IRInDate
	Set $p(InputStr,"^",23)=""  // IROutDate
	Set $p(InputStr,"^",24)=""  // IRAPACHEScore
	Set $p(InputStr,"^",25)=""  // IROutIntubats
	Set $p(InputStr,"^",26)=""  // IROut48Intubats
	Set $p(InputStr,"^",27)=""  // 横断面
	Set $p(InputStr,"^",28)=ReportID  // 旧版报告ID
	Set InfReportDr=##class(DHCHAI.IR.INFReport).Update(InputStr,"^")
	If (+InfReportDr)<1 {
		//记录错误日志
		Set ErrClass  = "DHCHAI.IR.INFReport"
		Set ErrMethod = "Update"
		Set ErrArgStr = $lb(InputStr,"^")
		Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
	}
	Set return=InfReportDr
	Quit return
	
SaveInfRepErr
	Set return="-999^"_$ZError
	Quit return
}

ClassMethod SaveNInfRep(rd As %ArrayOfDataTypes) As %String
{
	New (rd)
	Set return=0
	Quit:(rd="") return
	
	Set $ZT="SaveNInfRepErr"
	
	Set SCode          = rd.GetAt("SCode")
	Set EpisodeID      = rd.GetAt("EpisodeID")
	Set EpisodeDr      = rd.GetAt("EpisodeDr")
	Set ReportID       = rd.GetAt("ID")             // 旧版报告ID
	Set ReportType     = rd.GetAt("ReportType")     // 报告类型
	Set RepLocID       = rd.GetAt("RepLocID")       // 报告科室ID
	Set RepLocCode     = rd.GetAt("RepLocCode")     // 报告科室代码
	Set RepLocDesc     = rd.GetAt("RepLocDesc")     // 报告科室名称
	Set ReportDate     = rd.GetAt("ReportDate")     // 报告日期
	Set ReportTime     = rd.GetAt("ReportTime")     // 报告时间
	Set RepUserID      = rd.GetAt("RepUserID")      // 报告人ID
	Set RepUserCode    = rd.GetAt("RepUserCode")    // 报告人工号
	Set RepUserDesc    = rd.GetAt("RepUserDesc")    // 报告人姓名
	Set RepStatusCode  = rd.GetAt("RepStatusCode")  // 报告状态代码
	Set RepStatusDesc  = rd.GetAt("RepStatusDesc")  // 报告状态名称
	Quit:ReportID="" return
	// 如果报告存在,重复同步时,先删除报告下的易感因素、病原体药敏
	Set NewRepID = ##class(DHCHAI.IR.INFRepExt).GetObjIDByHisID("DHCHAI.IR.INFReport",ReportID)
	
	If (NewRepID'="") {
		// 删除病原体  DHCHAI.IR.INFLabBact
		Set xSub=0
		For {
			Set xSub=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt("DHCHAI.IR.INFLab","U"),NewRepID,xSub))
			Quit:xSub=""
			
			Set RepExtID=NewRepID_"||"_xSub
			Set obj=##class(DHCHAI.IR.INFRepExt).GetObjById(RepExtID)
			Continue:'$IsObject(obj)
			// 关联报告ID
			Set ObjectID = obj.IRObjectID
			
			Set xBactID = ""
		 	For {
		 		Set xBactID = $o(^DHCHAI.IR.INFLabI("BACT","IndexParrefBactDicDr",ObjectID,xBactID))
		 		Quit:xBactID=""
		 		
		 		Set xSubID = ""
		 		For {
			 		Set xSubID = $o(^DHCHAI.IR.INFLabI("BACT","IndexParrefBactDicDr",ObjectID,xBactID,xSubID))
		 			Quit:xSubID=""
		 			Set xID = ObjectID_"||"_xSubID
		 			Set flg = ##Class(DHCHAI.IR.INFLabBact).DeleteById(xID)
		 		}
		 	}
		}
	}
	Set RepLocDr=""
	Set objRepLoc=##class(DHCHAI.BT.Location).GetObjByLocCode(SCode,RepLocCode)
	If '$IsObject(objRepLoc){
		W:RepLocDesc'="" "报告科室："_RepLocCode_"//"_RepLocDesc,!
	}
	Set:$IsObject(objRepLoc) RepLocDr=objRepLoc.%Id()
	
	Set RepUserDr=""
	Set objRepUser=##class(DHCHAI.BT.SysUser).GetObjByUserCode(SCode,RepUserCode)
	If '$IsObject(objRepUser){
		W:RepUserDesc'="" "报告人："_RepUserCode_"//"_RepUserDesc,!
	}
	Set:$IsObject(objRepUser) RepUserDr=objRepUser.%Id()
	
	Set RepStatusDr=..GetMapDic("报告状态",RepStatusDesc)
	
	Set arrRepInfo=##Class(DHCHAI.DI.DIO.FromINFSrv).GetInfReport(ReportID)
	Quit:arrRepInfo.Count()<1 return
	
	Set DeathRelation=arrRepInfo.GetAt("DeathRelation")
	Set DeathRelationDr=..GetMapDic("与死亡关系",DeathRelation)
   
	// 感染信息
	Set LinkDiagDrs=""
	Set arrInfRepPos=arrRepInfo.GetAt("InfRepPos")
	For indInfPos=1:1:arrInfRepPos.Count() {
		Set InfPosStr=arrInfRepPos.GetAt(indInfPos)
		Continue:InfPosStr=""
		Set RepPosID         = $p(InfPosStr,"^",1)   //旧版感染诊断ID
		Set InfPosDesc       = $p(InfPosStr,"^",2)   //感染部位
		Set InfDiagDesc      = "新生儿感染"          //感染诊断
		Set InfDiagCatDesc   = $p(InfPosStr,"^",4)   //诊断子分类
		Set InfDate          = $p(InfPosStr,"^",5)   //感染日期
	    Set InfXDate         = $p(InfPosStr,"^",6)   //感染转归日期
		Set InfEndResultDesc = $p(InfPosStr,"^",7)   //转归
		Set DiagnosisBasis   = $p(InfPosStr,"^",8)   //诊断依据
		Set DiseaseCourse    = $p(InfPosStr,"^",9)   //感染性疾病病程
		
		//协和
		If (InfEndResultDesc="")&&(arrRepInfo.GetAt("DiseasePrognosis")'=""){
			Set InfEndResultDesc=arrRepInfo.GetAt("DiseasePrognosis").Description	//转归
		}
		
		Set InfPosDr=..GetMapDic("感染诊断",InfDiagDesc)
		Set InfSubDr=..GetMapDic("诊断子分类",InfDiagCatDesc)
		Set InfEndResultDr=..GetMapDic("疾病转归",InfEndResultDesc)
		
		Set tID=##class(DHCHAI.IR.INFRepExt).GetObjIDByHisID("DHCHAI.IR.INFDiagnos",RepPosID)
		Set InputStr=tID
		Set InputStr=InputStr_"^"_EpisodeDr
		Set InputStr=InputStr_"^"_InfPosDr
		Set InputStr=InputStr_"^"_InfSubDr
		Set InputStr=InputStr_"^"_InfDate
		Set InputStr=InputStr_"^"_RepLocDr  //报告科室作为感染科室
		Set InputStr=InputStr_"^"_DiagnosisBasis
		Set InputStr=InputStr_"^"_DiseaseCourse
		Set InputStr=InputStr_"^"_InfXDate
		Set InputStr=InputStr_"^"_InfEndResultDr
		Set InputStr=InputStr_"^"_DeathRelationDr
		Set InputStr=InputStr_"^"_ReportDate
		Set InputStr=InputStr_"^"_ReportTime
		Set InputStr=InputStr_"^"_RepUserDr
		
		Set InfDiagnosDr=##class(DHCHAI.IR.INFDiagnos).Update(InputStr,"^")
		If (+InfDiagnosDr)<1 {
			//记录错误日志
			Set ErrClass  = "DHCHAI.IR.INFDiagnos"
			Set ErrMethod = "Update"
			Set ErrArgStr = $lb(InputStr,"^")
			Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
		} Else {
			Set LinkDiagDrs=LinkDiagDrs_","_InfDiagnosDr
			Set ^TMP($j,"SyncInfRep","DHCHAI.IR.INFDiagnos",InfDiagnosDr)=RepPosID
		}
	}
	Set:LinkDiagDrs'="" LinkDiagDrs=$e(LinkDiagDrs,2,$l(LinkDiagDrs))
	// 易感因素 
	Set LinkPreFactDrs=""
	Set FactorsList=arrRepInfo.GetAt("FactorsDesc")
	For indFact=1:1:$l(FactorsList,",") {
		Set InfFactStr=$p(FactorsList,",",indFact)
		Continue:InfFactStr=""
		Set FactDr = ..GetObjIDByFactDesc(InfFactStr)
		
		Set InputStr=""
		Set InputStr=InputStr_"^"_EpisodeDr
		Set InputStr=InputStr_"^"_FactDr
		Set InputStr=InputStr_"^"_RepUserDr
		
		Set PreFactDr=##class(DHCHAI.IR.INFPreFactor).Update(InputStr,"^")
		If (+PreFactDr)<1 {
			//记录错误日志
			Set ErrClass  = "DHCHAI.IR.INFPreFactor"
			Set ErrMethod = "Update"
			Set ErrArgStr = $lb(InputStr,"^")
			Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
		} Else {
			Set LinkPreFactDrs=LinkPreFactDrs_","_PreFactDr
		}
	}
	Set:LinkPreFactDrs'="" LinkPreFactDrs=$e(LinkPreFactDrs,2,$l(LinkPreFactDrs))
	
	//基础疾病 zhoubo
	Set LinkICDDrs=""        
	Set arrRepICD=arrRepInfo.GetAt("InfRepDiag")
	For indInfICD=1:1:arrRepICD.Count() {
		Set InfICDStr=arrRepICD.GetAt(indInfICD)
		Continue:InfICDStr=""
		
		Set RepICDID      = $p(InfICDStr,"^",1)   // 旧版疾病ID
		Set Diagnos       = $p(InfICDStr,"^",2)   // 诊断字典名称
		Set DiagnosDesc   = $p(InfICDStr,"^",3)   // 诊断名称
		Set DiagnosDate   = $p(InfICDStr,"^",4)   // 诊断日期
		Set DiagnosTime   = $p(InfICDStr,"^",5)   // 诊断时间
		
		Set DiagDr = ##class(DHCHAI.DP.MRICDDx).GetObjByCodeDesc("",Diagnos)
		Set:DiagDr="" DiagDr = ##class(DHCHAI.DP.MRICDDx).GetObjByCodeDesc("",DiagnosDesc)
		Set:$IsObject(DiagDr) DiagDr=DiagDr.%Id()
		
		Set tID=##class(DHCHAI.IR.INFRepExt).GetObjIDByHisID("DHCHAI.IR.INFICD",RepICDID)
		Set InputStr=tID
		Set InputStr=InputStr_"^"_EpisodeDr
		Set InputStr=InputStr_"^"_DiagDr
		Set InputStr=InputStr_"^"_DiagnosDesc
		Set InputStr=InputStr_"^"_DiagnosDesc
		Set InputStr=InputStr_"^"_DiagnosDate
		Set InputStr=InputStr_"^"_DiagnosTime
		Set InputStr=InputStr_"^"_RepUserDr
		
		Set InfICDDr=##class(DHCHAI.IR.INFICD).Update(InputStr,"^")
		If (+InfICDDr)<1 {
			//记录错误日志
			Set ErrClass  = "DHCHAI.IR.INFICD"
			Set ErrMethod = "Update"
			Set ErrArgStr = $lb(InputStr,"^")
			Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
		} Else {
			Set LinkICDDrs=LinkICDDrs_","_InfICDDr
			Set ^TMP($j,"SyncInfRep","DHCHAI.IR.INFICD",InfICDDr)=RepICDID
		}
	}
	Set:LinkICDDrs'="" LinkICDDrs=$e(LinkICDDrs,2,$l(LinkICDDrs))
	
	// 抗菌药物信息  zhoubo
	Set LinkAntiDrs=""
	Set arrInfRepAnti=arrRepInfo.GetAt("InfRepAnti")
	For indInfAnti=1:1:arrInfRepAnti.Count() {
		Set InfAntiStr=arrInfRepAnti.GetAt(indInfAnti)
		Continue:InfAntiStr=""
		Set RepAntiID        = $p(InfAntiStr,"^",1)    // 旧版抗菌药物ID
		Set ArcimDesc        = $p(InfAntiStr,"^",2)    // 医嘱名称
		Set StartDate        = $p(InfAntiStr,"^",3)    // 开始日期
		Set StartTime        = $p(InfAntiStr,"^",4)    // 开始时间
		Set EndDate          = $p(InfAntiStr,"^",5)    // 结束日期
		Set EndTime          = $p(InfAntiStr,"^",6)    // 结束时间
		Set DoseQty          = $p(InfAntiStr,"^",7)    // 剂量
		Set DoseUnit         = $p(InfAntiStr,"^",8)    // 剂量单位
		Set DoseUnit         = ..GetMapIDByPhrase("HIS01","NINFInfAntiUOM",DoseUnit)
		Set PhcFreq          = $p(InfAntiStr,"^",9)    // 频次
		Set PhcFreq          = ..GetMapIDByPhrase("HIS01","NINFInfAntiFreq",PhcFreq)
		Set PreMedTime       = $p(InfAntiStr,"^",10)   // 术前用药时间(分钟)  1小时0分钟
		Set PreMedTimeH      = $p(PreMedTime,"小时",1)
		Set PreMedTimeM      = +$p(PreMedTime,"小时",2)
		Set PreMedTime       = (PreMedTimeH*60)+PreMedTimeM
		Set PostMedDays      = +$p(InfAntiStr,"^",11)  // 术后用药天数(天)
		Set UseDesc          = $p(InfAntiStr,"^",12)   // 用途
		Set UsePurposeDr     = ..GetMapIDByPhrase("HIS01","NINFInfMedUsePurpose",UseDesc)
		Set AdminRouteDesc   = $p(InfAntiStr,"^",13)   // 给药途径
		Set AdminRouteDr     = ..GetMapIDByPhrase("HIS01","NINFInfAdminRoute",AdminRouteDesc)
		Set MedPurposeDesc   = $p(InfAntiStr,"^",14)   // 目的
		Set PurposeDr        = ..GetMapIDByPhrase("HIS01","NINFInfMedPurpose",MedPurposeDesc)
		Set TreatmentDesc    = $p(InfAntiStr,"^",15)   // 治疗用药方式
		Set TreatmentDr      = ..GetMapIDByPhrase("HIS01","NINFInfTreatmentMode",TreatmentDesc)
		Set PreMedIndDesc    = $p(InfAntiStr,"^",16)   // 预防用药指征
		Set PreMedIndDr      = ..GetMapIDByPhrase("HIS01","NINFInfPreMedIndicat",PreMedIndDesc)
		Set EffectDesc       = $p(InfAntiStr,"^",17)   // 预防用药效果
		Set EffectDr         = ..GetMapIDByPhrase("HIS01","NINFInfPreMedEffect",EffectDesc)
		Set CombinedMedDesc  = $p(InfAntiStr,"^",18)   // 联合用药
		Set CombinedDr       = ..GetMapIDByPhrase("HIS01","NINFInfCombinedMed",CombinedMedDesc)
		
		Set tID=##class(DHCHAI.IR.INFRepExt).GetObjIDByHisID("DHCHAI.IR.INFAnti",RepAntiID)
		Set InputStr=tID
		Set InputStr=InputStr_"^"_EpisodeDr
		Set InputStr=InputStr_"^"_"" 
		Set InputStr=InputStr_"^"_ArcimDesc        // 医嘱名称
		Set InputStr=InputStr_"^"_ArcimDesc        // 医嘱名称2
		Set InputStr=InputStr_"^"_StartDate        // 开始日期
		Set InputStr=InputStr_"^"_EndDate          // 结束日期
		Set InputStr=InputStr_"^"_DoseQty          // 剂量
		Set InputStr=InputStr_"^"_DoseUnit         // 剂量单位
		Set InputStr=InputStr_"^"_PhcFreq          // 频次
		Set InputStr=InputStr_"^"_UsePurposeDr     // 用途
		Set InputStr=InputStr_"^"_AdminRouteDr     // 给药途径
		Set InputStr=InputStr_"^"_PurposeDr        // 目的
		Set InputStr=InputStr_"^"_TreatmentDr      // 治疗用药方式
		Set InputStr=InputStr_"^"_EffectDr         // 预防用药效果
		Set InputStr=InputStr_"^"_PreMedIndDr      // 预防用药指征
		Set InputStr=InputStr_"^"_CombinedDr       // 联合用药
		Set InputStr=InputStr_"^"_PreMedTime       // 术前用药时间(分钟)
		Set InputStr=InputStr_"^"_PostMedDays      // 术后用药天数(天)
		Set InputStr=InputStr_"^"_""               // SenAna
		Set InputStr=InputStr_"^"_ReportDate       // 更新日期
		Set InputStr=InputStr_"^"_ReportTime       // 更新时间
		Set InputStr=InputStr_"^"_RepUserDr        // 更新人 
		
		Set InfAntiDr=##class(DHCHAI.IR.INFAnti).Update(InputStr,"^")
		If (+InfAntiDr)<1 {
			//记录错误日志
			Set ErrClass  = "DHCHAI.IR.INFAnti"
			Set ErrMethod = "Update"
			Set ErrArgStr = $lb(InputStr,"^")
			Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
		} Else {
			Set LinkAntiDrs=LinkAntiDrs_","_InfAntiDr
			Set ^TMP($j,"SyncInfRep","DHCHAI.IR.INFAnti",InfAntiDr)=RepAntiID
		}
	}
	Set:LinkAntiDrs'="" LinkAntiDrs=$e(LinkAntiDrs,2,$l(LinkAntiDrs))
	
	// 病原学检验信息  zhoubo
	Set LinkLabDrs=""
	Set arrInfRepLab=arrRepInfo.GetAt("InfRepLab")
	For indInfLab=1:1:arrInfRepLab.Count() {
		Set InfLabStr=arrInfRepLab.GetAt(indInfLab)
		Continue:InfLabStr=""
		Set RepLabID         = $p(InfLabStr,"^",1)    // 旧版检验ID
		Set ArcimDesc        = $p(InfLabStr,"^",2)    // 检验医嘱名称
		Set SpecimenDesc     = $p(InfLabStr,"^",3)    // 标本
		Set SpecimenDr       = ##class(DHCHAI.DP.LabSpecMap).GetStanSpecByDesc("LIS01",SpecimenDesc)
		Set:$IsObject(SpecimenDr) SpecimenDr=SpecimenDr.%Id()
		Set:SpecimenDr="" SpecimenDr=..GetMapDic("标本",SpecimenDesc)
		Set AssayMethodDesc  = $p(InfLabStr,"^",4)    // 检验方法
		Set AssayMethodDr    = ..GetMapIDByPhrase("HIS01","NINFInfAssayMethod",AssayMethodDesc)
		Set SubmissionDate   = $p(InfLabStr,"^",5)    // 送检日期
		Set PathogenTestDesc = $p(InfLabStr,"^",6)    // 病原学检验
		Set PathTestDr       = ..GetMapIDByPhrase("HIS01","NINFInfPathogenTest",PathogenTestDesc)
		
		Set tID=##class(DHCHAI.IR.INFRepExt).GetObjIDByHisID("DHCHAI.IR.INFLab",RepLabID)
		Set InputStr=tID
		Set InputStr=InputStr_"^"_EpisodeDr
		Set InputStr=InputStr_"^"_"" 
		Set InputStr=InputStr_"^"_ArcimDesc        // 检验医嘱名称
		Set InputStr=InputStr_"^"_ArcimDesc        // 检验组套（标准医嘱）
		Set InputStr=InputStr_"^"_SpecimenDr       // 标本
		Set InputStr=InputStr_"^"_SubmissionDate   // 送检日期
		Set InputStr=InputStr_"^"_RepLocDr         // 报告科室作为送检科室
		Set InputStr=InputStr_"^"_AssayMethodDr    // 检验方法
		Set InputStr=InputStr_"^"_PathTestDr       // 病原学检验
		Set InputStr=InputStr_"^"_""
		Set InputStr=InputStr_"^"_ReportDate       // 更新日期
		Set InputStr=InputStr_"^"_ReportTime       // 更新时间
		Set InputStr=InputStr_"^"_RepUserDr        // 更新人 
		
		Set InfLabDr=##class(DHCHAI.IR.INFLab).Update(InputStr,"^")
		If (+InfLabDr)<1 {
			//记录错误日志
			Set ErrClass  = "DHCHAI.IR.INFLab"
			Set ErrMethod = "Update"
			Set ErrArgStr = $lb(InputStr,"^")
			Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
		} Else {
			Set LinkLabDrs=LinkLabDrs_","_InfLabDr
			Set ^TMP($j,"SyncInfRep","DHCHAI.IR.INFLab",InfLabDr)=RepLabID
		}
		
		Set InfRepLabPy = $p(InfLabStr,"^",7)    // 检验结果(病原体)
		For indPy=1:1:$l(InfRepLabPy,",") {
			Set tmpInfRepLabPy  = $p(InfRepLabPy,",",indPy)
			Set PathogenyDesc   = $p(tmpInfRepLabPy,"#",1)   // 病原体
			Set:PathogenyDesc'="" PathogenyDesc=$tr(PathogenyDesc," ","")
			Set PYWhonet        = $p(tmpInfRepLabPy,"#",2)   // whonet码
			Set PYDesc          = $p(tmpInfRepLabPy,"#",3)   // 病原体名称
			Set:PYDesc'="" PYDesc=$tr(PYDesc," ","")
			Set BactDicDr = ##class(DHCHAI.DP.LabBactMap).GetStanBactByDesc("LIS01",PYDesc)
			Set:BactDicDr="" BactDicDr=##class(DHCHAI.DP.LabBactMap).GetStanBactByDesc("LIS01",PathogenyDesc)
			Set:$IsObject(BactDicDr) BactDicDr=BactDicDr.%Id()
			Set DrugSenTest = $p(tmpInfRepLabPy,"#",4)   // 药敏实验
			
			Set DrugSens=""
			For indPyTest=1:1:$l(DrugSenTest,"&") {
				Set tmpSenTest  = $p(DrugSenTest,"&",indPyTest)
				Set AntibioticsDesc   = $p(tmpSenTest,"!",1)   // 抗生素
				Set:AntibioticsDesc'="" AntibioticsDesc=$tr(AntibioticsDesc," ","")
				Set ANTCode           = $p(tmpSenTest,"!",2)   // 代码
				Set ANTDesc           = $p(tmpSenTest,"!",3)   // 抗菌药物名称
				Set:ANTDesc'="" ANTDesc=$tr(ANTDesc," ","")
				Set AntiDicDr = ##class(DHCHAI.DP.LabAntiMap).GetStanAntiByDesc("LIS01",ANTDesc)
				Set:AntiDicDr="" AntiDicDr = ##class(DHCHAI.DP.LabAntiMap).GetStanAntiByDesc("LIS01",AntibioticsDesc)
				Set:$IsObject(AntiDicDr) AntiDicDr=AntiDicDr.%Id()
				Set SenTestRstDesc = $p(tmpSenTest,"!",4)   // 药敏结果
				Set DrugSenDr = ..GetMapIDByPhrase("HIS01","NINFInfSenTestRst",SenTestRstDesc)
				Set DrugSens  =DrugSens_$lb($lb(AntiDicDr,AntibioticsDesc,DrugSenDr))
			}
			Set InputStr=InfLabDr
			Set InputStr=InputStr_"^"_"" 
			Set InputStr=InputStr_"^"_BactDicDr        // 病原体字典
			Set InputStr=InputStr_"^"_PathogenyDesc    // 病原体
			Set InfLabBactDr=##class(DHCHAI.IR.INFLabBact).Update(InputStr,DrugSens,"^")
			
			If (+InfLabBactDr)<1 {
				//记录错误日志
				Set ErrClass  = "DHCHAI.IR.INFLabBact"
				Set ErrMethod = "Update"
				Set ErrArgStr = $lb(InputStr,"^")
				Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
			}
		}
	}
	Set:LinkLabDrs'="" LinkLabDrs=$e(LinkLabDrs,2,$l(LinkLabDrs))
		
	Set tID = ##class(DHCHAI.IR.INFRepExt).GetObjIDByHisID("DHCHAI.IR.INFReport",ReportID)
	Set InputStr=tID
	Set $p(InputStr,"^",2)=EpisodeDr
	Set $p(InputStr,"^",3)=2  //新生儿感染报告
	Set $p(InputStr,"^",4)=ReportDate
	Set $p(InputStr,"^",5)=ReportTime
	Set $p(InputStr,"^",6)=RepLocDr
	Set $p(InputStr,"^",7)=RepUserDr
	Set $p(InputStr,"^",8)=RepStatusDr
	Set $p(InputStr,"^",9)=LinkDiagDrs
	Set $p(InputStr,"^",10)=LinkICDDrs   // LinkICDDrs
	Set $p(InputStr,"^",11)=LinkLabDrs   // LinkLabDrs
	Set $p(InputStr,"^",12)=LinkAntiDrs  // LinkAntiDrs
	Set $p(InputStr,"^",13)=""  // LinkOPSDrs
	Set $p(InputStr,"^",14)=""  // LinkMRBDrs
	Set $p(InputStr,"^",15)=""  // LinkInvOperDrs
	Set $p(InputStr,"^",16)=LinkPreFactDrs  // LinkPreFactDrs
	Set $p(InputStr,"^",17)=""  // LinkICUUCDrs
	Set $p(InputStr,"^",18)=""  // LinkICUVAPDrs
	Set $p(InputStr,"^",19)=""  // LinkICUPICCDrs
	Set $p(InputStr,"^",20)=""  // IRInLocDr
	Set $p(InputStr,"^",21)=""  // IROutLocDr
	Set $p(InputStr,"^",22)=""  // IRInDate
	Set $p(InputStr,"^",23)=""  // IROutDate
	Set $p(InputStr,"^",24)=""  // IRAPACHEScore
	Set $p(InputStr,"^",25)=""  // IROutIntubats
	Set $p(InputStr,"^",26)=""  // IROut48Intubats
	Set $p(InputStr,"^",27)=""  // 横断面
	Set $p(InputStr,"^",28)=ReportID  // 旧版报告ID
	
	Set InfReportDr=##class(DHCHAI.IR.INFReport).Update(InputStr,"^")
	If (+InfReportDr)<1 {
		//记录错误日志
		Set ErrClass  = "DHCHAI.IR.INFReport"
		Set ErrMethod = "Update"
		Set ErrArgStr = $lb(InputStr,"^")
		Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
	}
	Set return=InfReportDr
	Quit return
	
SaveNInfRepErr
	Set return="-999^"_$ZError
	Quit return
}

/// w ##class(DHCHAI.DI.DHS.SyncINFInfo).GetObjIDByUserDesc("med")
ClassMethod GetObjIDByUserDesc(aUserDesc As %String) As %String
{
	New (aUserDesc)
	Set return = ""
	Quit:(aUserDesc="") return
	
	Set xID=""
	For {
		Set xID = $o(^DHCHAI.BT.SysUserD(xID))
		Quit:((xID="")||(return'=""))
		
		Set objUser = ##class(DHCHAI.BT.SysUser).GetObjById(xID)
		Continue:'$isobject(objUser)  
	    Set UserDesc = objUser.BTDesc
	    Continue:aUserDesc'=UserDesc
	    Set return = xID
	}
	Quit return
}

/// w ##class(DHCHAI.DI.DHS.SyncINFInfo).GetMapIDByPhrase("HIS01","NINFInfCuteHealing","甲")
ClassMethod GetMapIDByPhrase(aScode As %String, aTypeCode As %String, aDesc As %String) As %String
{
	New (aScode,aTypeCode,aDesc)
	Set return=""
	Quit:(aScode="")||(aTypeCode="")||(aDesc="") return
	
	Set TypeID=$o(^DHCHAI.DP.PhraseTypeI("IndexCode"," "_$zcvt(aTypeCode,"U"),0))
	Quit:TypeID="" return
	Set ID=$o(^DHCHAI.DP.PhraseMapI("IndexTypeDesc",aScode,TypeID,aDesc,0))
	Quit:ID="" return
	Set obj=##class(DHCHAI.DP.PhraseMap).GetObjById(ID)
	Quit:'$IsObject(obj) return
	Quit:obj.BTIsActive'=1 return
	Quit:'$IsObject(obj.BTMapDicDr) return
	Set return=obj.BTMapDicDr.%Id()
	Quit return
}

/// w ##class(DHCHAI.DI.DHS.SyncINFInfo).GetObjIDByFactDesc("糖尿病")
ClassMethod GetObjIDByFactDesc(aFactDesc As %String) As %String
{
	New (aFactDesc)
	Set return = ""
	Quit:(aFactDesc="") return
	
	Set xID=""
	For {
		Set xID = $o(^DHCHAI.BT.PreFactorD(xID))
		Quit:((xID="")||(return'=""))
		
		Set objPreFactor = ##class(DHCHAI.BT.PreFactor).GetObjById(xID)
		Continue:'$isobject(objPreFactor)  
	    Set BTDesc = objPreFactor.BTDesc
	    Continue:aFactDesc'=BTDesc
	    Set return = xID
	}
	Quit return
}

/// w ##class(DHCHAI.DI.DHS.SyncINFInfo).GetObjIDByInvOper("气管切开")
ClassMethod GetObjIDByInvOper(aInvOper As %String) As %String
{
	New (aInvOper)
	Set return = ""
	Quit:(aInvOper="") return
	
	Set xID=""
	For {
		Set xID = $o(^DHCHAI.BT.InvasOperD(xID))
		Quit:((xID="")||(return'=""))
		
		Set objInvOper = ##class(DHCHAI.BT.InvasOper).GetObjById(xID)
		Continue:'$isobject(objInvOper)  
	    Set BTDesc = objInvOper.BTDesc
	    Continue:aInvOper'=BTDesc
	    Set return = xID
	}
	Quit return
}

}
