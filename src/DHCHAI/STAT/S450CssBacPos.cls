/// 名称: DHCHAI.STAT.S450CssBacPos
/// 描述: 住院患者医院感染部位分布统计表
/// 编写者：chenjb
/// 编写日期: 2018-10-12
Class DHCHAI.STAT.S450CssBacPos Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2018-12-24 
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
///               aInfType:  感染类型 0：医院感染 1：社区感染
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STAT.S450CssBacPos","QryCSSInfPos","1","")
Query QryCSSInfPos(aSurNumID As %String, aLocModel As %String, aInfType As %String = "") As %Query(ROWSPEC = "InfPosDesc:%String,PosInfSum:%Integer") [ SqlProc ]
{
}

ClassMethod QryCSSInfPosExecute(ByRef qHandle As %Binary, aSurNumID As %String, aLocModel As %String, aInfType As %String = "") As %Status
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
			Set InfPosDescs =..GetCurrInfPosInfo1(Paadm,aDateFrom,aDateTo,aInfType)
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

/// Creator：     chenjb
/// CreatDate：   2018-10-12
/// Description:  现患感染部位分布统计
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
///               aInfType:  感染类型 0：医院感染 1：社区感染
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STAT.S450CssBacPos","QryCSSBacInfPos","3","")
Query QryCSSBacInfPos(aSurNumID As %String, aLocModel As %String, aInfType As %String = "") As %Query(ROWSPEC = "BacName:%String,DiagID:%String,InfDiagDesc:%String,PosNum:%Integer") [ SqlProc ]
{
}

ClassMethod QryCSSBacInfPosExecute(ByRef qHandle As %Binary, aSurNumID As %String, aLocModel As %String, aInfType As %String = "") As %Status
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
	/// 取所有需要调查的科室  默认是全院科室    
    Set NIndex="QryCSSBacInfPos"
	Kill ^TMP($zn,$j,NIndex)
	
	Set xPaadm = ""
	For {
		Set xPaadm = $o(^DHCHAI.IR.INFCSSI("IndexSurEpisodeID"," "_aSurNumID,xPaadm))
		Quit:xPaadm=""
		
		Set InfPosDescs =..GetCurrInfPosInfo(xPaadm,aDateFrom,aDateTo,aInfType)
		Continue:InfPosDescs=""
		If (InfPosDescs'="") {
			// 记录病原体感染部位信息
			For indxi=1:1:$l(InfPosDescs,"|") {
				Set tmpInfPos     = $p(InfPosDescs,"|",indxi)
				Set tmpDiagID     = $p(tmpInfPos,"^",1)
				Set tmpInfPosDesc = $p(tmpInfPos,"^",2)
				Set BacDescs      = $p(tmpInfPos,"^",3)
				For j=1:1:$l(BacDescs,"#") {
					Set tmpBacName     = $p(BacDescs,"#",j)
					Set ^TMP($zn,$j,NIndex,"InfPosList",tmpBacName,tmpDiagID)=tmpInfPosDesc
					Set num=+$g(^TMP($zn,$j,NIndex,"InfPosList",tmpBacName,tmpDiagID,"Cnt"))
					Set ^TMP($zn,$j,NIndex,"InfPosList",tmpBacName,tmpDiagID,"Cnt")=num+1
				}				
			}
		}	
	}
	// 输出Data
	Set xBacName=""
	For {
		Set xBacName=$o(^TMP($zn,$j,NIndex,"InfPosList",xBacName))
		Quit:xBacName=""
			
		Set xDiagID = ""
	 	For {
			Set xDiagID = $o(^TMP($zn,$j,NIndex,"InfPosList",xBacName,xDiagID))
			Quit:xDiagID=""	
		
			Set InfDiagDesc =$g(^TMP($zn,$j,NIndex,"InfPosList",xBacName,xDiagID))
			Set PosNum = +$g(^TMP($zn,$j,NIndex,"InfPosList",xBacName,xDiagID,"Cnt"))
			Set Data=$lb(xBacName,xDiagID,InfDiagDesc,PosNum)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
			
	 	}
	   
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryCSSBacInfPosClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCSSBacInfPosExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCSSBacInfPosFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCSSBacInfPosExecute ]
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

/// 现患感染部位病原体
ClassMethod GetCurrInfPosInfo(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String, aInfType As %String) As %String
{
	New (aEpisodeID,aDateFrom,aDateTo,aInfType)
	Set return=""
	Quit:(aEpisodeID="") return
	
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Quit:(aDateFrom="")||(aDateTo="") return
	Quit:aDateFrom>aDateTo return
	
	Set InfPosDescs=""
	Set RepType="7"  //横断面调查

	Set xID = ""
	For {
		Set xID=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,RepType,xID))
		Quit:xID=""
		Set objINFRep=##class(DHCHAI.IR.INFReport).GetObjById(xID)
		Continue:'$IsObject(objINFRep)
		Set RepStatus=objINFRep.IRStatusDr
		Continue:'$IsObject(RepStatus)        //1 保存 2 提交 3 审核 4 作废
		Continue:RepStatus.BTCode="4"
		
		Set LinkCSSs = objINFRep.GetRepLinkIDs("DHCHAI.IR.INFCSS")
		Continue:LinkCSSs=""
		Set xObj1 = ##class(DHCHAI.IR.INFCSS).GetObjById(+LinkCSSs)  //子父表一对一
		Continue:'$IsObject(xObj1)
		Set IRInfCategory = xObj1.IRInfCategoryDr  // 感染分类 社区:1 院内:0
		Continue:(aInfType'="")&&(aInfType'=IRInfCategory)
		
		// 感染诊断信息
		Set LinkDiags = objINFRep.GetRepLinkIDs("DHCHAI.IR.INFDiagnos")
		For indx = 1:1:$l(LinkDiags,","){
			Set xDiagID = $p(LinkDiags,",",indx)
			Continue:xDiagID=""
			
			Set objDiags = ##class(DHCHAI.IR.INFDiagnos).GetObjById(xDiagID)
			Continue:'$IsObject(objDiags)
			// 感染日期
			Set InfDate  = objDiags.IRInfDate
			Set InfXDate = objDiags.IRInfXDate
			Continue:InfDate>aDateTo    // 感染日期大于查询截止日期，非查询期间发生感染
			Continue:(InfXDate'="")&(InfXDate<=aDateTo) // 调查期间感染已结束
			Continue:objDiags.IRBacteria=""   //病原体统计 没有继续
			// 感染诊断
			Set objInfPos = objDiags.IRInfPosDr
			If $IsObject(objInfPos){
				Set InfPosDescs = InfPosDescs_"|"_xDiagID_"^"_objInfPos.BTDesc_"^"_objDiags.IRBacteria
			}
		}
	}

	Set:InfPosDescs'="" InfPosDescs = $e(InfPosDescs,2,$l(InfPosDescs))
	Set:InfPosDescs'="" return=InfPosDescs
	Quit return
}

/// 现患感染部位
ClassMethod GetCurrInfPosInfo1(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String, aInfType As %String) As %String
{
	New (aEpisodeID,aDateFrom,aDateTo,aInfType)
	Set return=""
	Quit:(aEpisodeID="") return
	
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Quit:(aDateFrom="")||(aDateTo="") return
	Quit:aDateFrom>aDateTo return
	
	Set InfPosDescs=""
	Set RepType="7"  //横断面调查

	Set xID = ""
	For {
		Set xID=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,RepType,xID))
		Quit:xID=""
		Set objINFRep=##class(DHCHAI.IR.INFReport).GetObjById(xID)
		Continue:'$IsObject(objINFRep)
		Set RepStatus=objINFRep.IRStatusDr
		Continue:'$IsObject(RepStatus)        //1 保存 2 提交 3 审核 4 作废
		Continue:RepStatus.BTCode="4"
		
		Set LinkCSSs = objINFRep.GetRepLinkIDs("DHCHAI.IR.INFCSS")
		Continue:LinkCSSs=""
		Set xObj1 = ##class(DHCHAI.IR.INFCSS).GetObjById(+LinkCSSs)  //子父表一对一
		Continue:'$IsObject(xObj1)
		Set IRInfCategory = xObj1.IRInfCategoryDr  // 感染分类 社区:1 院内:0
		Continue:(aInfType'="")&&(aInfType'=IRInfCategory)
		
		// 感染诊断信息
		Set LinkDiags = objINFRep.GetRepLinkIDs("DHCHAI.IR.INFDiagnos")
		For indx = 1:1:$l(LinkDiags,","){
			Set xDiagID = $p(LinkDiags,",",indx)
			Continue:xDiagID=""
			
			Set objDiags = ##class(DHCHAI.IR.INFDiagnos).GetObjById(xDiagID)
			Continue:'$IsObject(objDiags)
			// 感染日期
			Set InfDate  = objDiags.IRInfDate
			Set InfXDate = objDiags.IRInfXDate
			Continue:InfDate>aDateTo    // 感染日期大于查询截止日期，非查询期间发生感染
			Continue:(InfXDate'="")&(InfXDate<=aDateTo) // 调查期间感染已结束
			// 感染诊断
			Set objInfPos = objDiags.IRInfPosDr
			If $IsObject(objInfPos){
				Set InfPosDescs = InfPosDescs_"|"_xDiagID_"^"_objInfPos.BTDesc
			}
		}
	}

	Set:InfPosDescs'="" InfPosDescs = $e(InfPosDescs,2,$l(InfPosDescs))
	Set:InfPosDescs'="" return=InfPosDescs
	Quit return
}

}
