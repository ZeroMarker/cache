/// 名称: DHCHAI.IRS.CCResultSrv
/// 描述: 疑似病例筛查相关服务
/// 编写者：chenjb
/// 编写日期: 2018-04-09
Class DHCHAI.IRS.CCResultSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2019-03-08
/// Description:  华西三管统计报表
/// Table：       DHCHAI.DP.PAAdm、 DHCHAI.IR.CCResult
/// Input：       aDateFrom : CCActDate开始日期
///               aDateTo   : CCActDate结束日期
///               aLocID    : 就诊科室
/// 		      aHospIDs  : 院区过滤 1|2|3 格式
/// 			  aItemID   : CCItemDr监控项目过滤
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.CCResultSrv","QryICUResult","65045","65080","5","1|5|7","7")
Query QryICUResult(aDateFrom As %String, aDateTo As %String, aLocID As %String, aHospIDs As %String = "", aItemID As %String = "") As %Query(ROWSPEC = "LocID:%String,LocDesc:%String,VAPPatSum:%Integer,UCPatSum:%Integer,PICCPatSum:%Integer") [ SqlProc ]
{
}

ClassMethod QryICUResultExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aLocID As %String, aHospIDs As %String = "", aItemID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	//Set ^zhoubo=aDateFrom_"^"_aDateTo_"^"_aLocID_"^"_aHospIDs_"^"_aItemID
 	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aItemID="")&((aDateFrom="")||(aDateTo="")) $$$OK 	
 	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	
	Set NIndex="QryICUResult"
	Kill ^TMP($zn,$j,NIndex)
	
	For xDate=aDateFrom:1:aDateTo{
		Set xResultID=""
		For {
			Set xResultID=$o(^DHCHAI.IR.CCResultI("IndexItemActDate",aItemID,xDate,xResultID))
			Quit:xResultID=""			  
			Set objResult=##class(DHCHAI.IR.CCResult).GetObjById(xResultID)
			Continue:'$IsObject(objResult) 
			Continue:'$IsObject(objResult.CCEpisodeDr)
			Continue:objResult.CCIsActive'=1
			Set EpisodeID=objResult.CCEpisodeDr.%Id()
			Set ObjAdmLoc = objResult.CCEpisodeDr.PAAdmLocDr
			Continue:'$IsObject(ObjAdmLoc)
			Set AdmLocID = ObjAdmLoc.%Id() 
			Continue:(aLocID'="")&&(aLocID'=AdmLocID)
			Set CCObjectID = objResult.CCObjectID
			Set objOrdItem = ##class(DHCHAI.DP.OEOrdItem).GetObjById(CCObjectID)
			Continue:'$Isobject(objOrdItem)
			Set IsActive=objOrdItem.OEIsActive
			Continue:IsActive'=1
			Set OEOrdDesc = objOrdItem.OEOrdDesc
			Set OESCode = objOrdItem.OESCode
			//取的临床医嘱名称
			Set xMastMapID = $o(^DHCHAI.DP.OEItmMastMapI("IndexSCodeOrdDesc",OESCode,OEOrdDesc,""))	
			Continue:xMastMapID=""
			Set objMap = ##class(DHCHAI.DP.OEItmMastMap).GetObjById(xMastMapID)
			Continue:'$Isobject(objMap)			
			Continue:'$Isobject(objMap.BTMapItemDr)          // 治疗医嘱项  
			Continue:'$Isobject(objMap.BTMapItemDr.BTCatDr)  // 治疗医嘱分类	
			Set BTCode = objMap.BTMapItemDr.BTCatDr.BTCode   // DRT-I-PICC,DRT-I-VAP,DRT-I-UC
			
			If '$d(^TMP($zn,$j,NIndex,"Loc",AdmLocID,BTCode,EpisodeID))
			{   
				Set ^TMP($zn,$j,NIndex,"Loc",AdmLocID,BTCode,EpisodeID)=""
				Set num=+$g(^TMP($zn,$j,NIndex,"Loc",AdmLocID,BTCode))
				Set ^TMP($zn,$j,NIndex,"Loc",AdmLocID,BTCode)=num+1
			}
		}
	}
	
	Set xLocID = ""
	For {
		Set xLocID = $o(^TMP($zn,$j,NIndex,"Loc",xLocID))
		Quit:xLocID=""
		
		Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(xLocID)
		Continue:'$isobject(objLoc)
		Set LocDesc = objLoc.BTDesc2
		Set:LocDesc="" LocDesc = objLoc.BTDesc
		Continue:LocDesc=""
		Set:$p(LocDesc,"-",2)'="" LocDesc=$p(LocDesc,"-",2)
		
	    Set VAPPatSum   =+$g(^TMP($zn,$j,NIndex,"Loc",xLocID,"DRT-I-VAP"))   
	    Set UCPatSum    =+$g(^TMP($zn,$j,NIndex,"Loc",xLocID,"DRT-I-UC"))	 
		Set PICCPatSum  =+$g(^TMP($zn,$j,NIndex,"Loc",xLocID,"DRT-I-PICC"))		  
		
		Set Data=$lb(xLocID,LocDesc,VAPPatSum,UCPatSum,PICCPatSum)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
		
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryICUResultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryICUResultExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryICUResultFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryICUResultExecute ]
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
/// CreatDate：   2019-03-08
/// Description:  华西三管统计明细
/// Table：       DHCHAI.DP.PAAdm、 DHCHAI.IR.CCResult
/// Input：       aDateFrom : CCActDate开始日期
///               aDateTo   : CCActDate结束日期
///               aLocID    : 就诊科室
/// 		      aHospIDs  : 院区过滤 1|2|3 格式
/// 			  aItemID   : CCItemDr监控项目过滤
///               aType     : 插管类型   
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.CCResultSrv","QryICUResultDtl","65045","65080","6","1|5|7","7","DRT-I-VAP")
Query QryICUResultDtl(aDateFrom As %String, aDateTo As %String, aLocID As %String, aHospIDs As %String, aItemID As %String, aType As %String) As %Query(ROWSPEC = "EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,OEOrdDesc:%String,OESttDate:%String,OEXDate:%String,InfPos:%String,InfDate:%String,InfType:%String,DeasResult:%String,ResultDT:%String") [ SqlProc ]
{
}

ClassMethod QryICUResultDtlExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aLocID As %String, aHospIDs As %String, aItemID As %String, aType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aItemID="")&((aDateFrom="")||(aDateTo="")) $$$OK 	
 	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	set tmpType = $s(aType="DRT-I-PICC":"PICC",aType="DRT-I-VAP":"VAP",aType="DRT-I-UC":"UC",1:"")
	
	Set NIndex="QryICUResult"
	Kill ^TMP($zn,$j,NIndex)
	
	For xDate=aDateFrom:1:aDateTo{
		Set xResultID=""
		For {
			Set xResultID=$o(^DHCHAI.IR.CCResultI("IndexItemActDate",aItemID,xDate,xResultID))
			Quit:xResultID=""			  
			Set objResult=##class(DHCHAI.IR.CCResult).GetObjById(xResultID)
			Continue:'$IsObject(objResult) 
			Continue:'$IsObject(objResult.CCEpisodeDr)
			Continue:objResult.CCIsActive'=1
			Set EpisodeID=objResult.CCEpisodeDr.%Id()
			Set ObjAdmLoc = objResult.CCEpisodeDr.PAAdmLocDr
			Continue:'$IsObject(ObjAdmLoc)
			Set AdmLocID = ObjAdmLoc.%Id()
			Continue:(aLocID'="")&&(aLocID'=AdmLocID)
			
			Set CCObjectID = objResult.CCObjectID
			Set objOrdItem = ##class(DHCHAI.DP.OEOrdItem).GetObjById(CCObjectID)
			Continue:'$Isobject(objOrdItem)
			Set IsActive=objOrdItem.OEIsActive
			Continue:IsActive'=1
			Set OEOrdDesc = objOrdItem.OEOrdDesc
			Set OESCode = objOrdItem.OESCode
			Set OESttDate = objOrdItem.OESttDate
			Set OEXDate = objOrdItem.OEXDate
			Set:OESttDate'="" OESttDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OESttDate)
			Set:OEXDate'="" OEXDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OEXDate)
			//取的临床医嘱名称
			Set xMastMapID = $o(^DHCHAI.DP.OEItmMastMapI("IndexSCodeOrdDesc",OESCode,OEOrdDesc,""))	
			Continue:xMastMapID=""
			Set objMap = ##class(DHCHAI.DP.OEItmMastMap).GetObjById(xMastMapID)
			Continue:'$Isobject(objMap)			
			Continue:'$Isobject(objMap.BTMapItemDr)          // 治疗医嘱项  
			Continue:'$Isobject(objMap.BTMapItemDr.BTCatDr)  // 治疗医嘱分类	
			Set BTCode = objMap.BTMapItemDr.BTCatDr.BTCode   // DRT-I-PICC,DRT-I-VAP,DRT-I-UC
			Continue:(aType'="")&&(aType'=BTCode)
			
			Continue:$d(^TMP($zn,$j,NIndex,"Loc",AdmLocID,BTCode,EpisodeID))
			Set ^TMP($zn,$j,NIndex,"Loc",AdmLocID,BTCode,EpisodeID)=""
			
			//病人基本信息		
	    	Set PatData =..BuildPaadmData(EpisodeID)
	    	Continue:PatData=""
	    	
	    	//三管感染信息
	    	Set (InfDate,InfPos,InfType,DeasResult,ResultDT)=""
	    	Set xInfType="医院感染"
	    	Set PatInfInfo = ##class(DHCHAI.STAT.S300PICCInf).GetTubeInf(EpisodeID,tmpType)
	    	for zindex=1:1:$l(PatInfInfo,",") {	
				Set subInfMsg=$p(PatInfInfo,",",zindex)
				continue:subInfMsg=""
				continue:$p(subInfMsg,"^",2)=""
				Set:($p(subInfMsg,"^",1)-AdmDate)<2 xInfType="社区感染" //如果感染日期在入院2天内，算作社区感染
				Set xInfDate=$p(subInfMsg,"^",1)
				//continue:(xInfDate<aDateFrom)||(xInfDate>aDateTo) //感染日期不在统计范围之内 过滤
				Set InfDate=InfDate_","_$zd($p(subInfMsg,"^",1),3)
				Set InfPos=InfPos_","_ $p(subInfMsg,"^",2)
				Set InfType=InfType_","_xInfType
				Set DeasResult=DeasResult_","_ $p(subInfMsg,"^",3)
				Set ResultDT=ResultDT_","_$s($p(subInfMsg,"^",4)'="":$zd($p(subInfMsg,"^",4),3),1:"")
			}
	    	Set:InfDate'="" InfDate=$e(InfDate,2,$l(InfDate))	
			Set:InfPos'="" InfPos=$e(InfPos,2,$l(InfPos))
			Set:InfType'="" InfType=$e(InfType,2,$l(InfType))
			Set:DeasResult'="" DeasResult=$e(DeasResult,2,$l(DeasResult))
			Set:ResultDT'="" ResultDT=$e(ResultDT,2,$l(ResultDT))
			
			Set Data=PatData_$lb(OEOrdDesc,OESttDate,OEXDate,InfPos,InfDate,InfType,DeasResult,ResultDT)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryICUResultDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryICUResultDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryICUResultDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryICUResultDtlExecute ]
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
/// CreatDate：   2017-03-20
/// Description:  监控结果病人列表
/// Table：       DHCHAI.DP.PAAdm、 DHCHAI.IR.CCResult DHCHAI.IR.CCScreening
/// Input：       aTypeFlag : 查询类型（0 逻辑或 or、1 逻辑且 and）
///               aDateFrom : CCActDate开始日期
///               aDateTo   : CCActDate结束日期
///               aLocID    : CCActLocDr 发生科室ID 为空查所有科室
/// 				  aHospIDs    : 院区过滤 1|2|3 格式
/// 				  aItemIDs    : CCItemDr监控项目过滤 多个 1|2|3 格式
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.CCResultSrv","QryResultPatList","1","2017-08-01","2017-08-30","","1|2|3|4","1|7")
Query QryResultPatList(aTypeFlag As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String, aHospIDs As %String = "", aItemIDs As %String = "") As %Query(ROWSPEC = "EpisodeID:%String,RegNo:%String,PatName:%String,Sex:%String,Age:%String,CurrLoc:%String,CurrBed:%String,VisitStatus:%String,CurrLocDesc:%String,IsNeedAtt:%String,SuspendCode:%String,SuspendDesc:%String,CCItemDr:%String,CCItemDesc:%String,CCResult:%String,CCActDate:%String") [ SqlProc ]
{
}

ClassMethod QryResultPatListExecute(ByRef qHandle As %Binary, aTypeFlag As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String, aHospIDs As %String = "", aItemIDs As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	//Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
 	//Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
 	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Set:aTypeFlag="" aTypeFlag ="0"
 	Quit:(aItemIDs="")&((aDateFrom="")||(aDateTo="")) $$$OK 	
  	
  	Quit:(aDateTo-aDateFrom)>31 $$$OK
  	
 	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
 	//Continue:(aHospIDs'="")&($listfind(aHospIDs,objLoc.BTHospDr.%Id())<1)  //按医院过滤
 	Set QryName = "QryResultPatList"
 	kill ^TMP($zn,$j,QryName)
 	Set ItemList = ""
	For xDate=aDateFrom:1:aDateTo{
		For indItem=1:1:$l(aItemIDs,"|") {
			Set xItemID=$p(aItemIDs,"|",indItem)
			Continue:xItemID=""
			Set xResultID=""
			For {
				Set xResultID=$o(^DHCHAI.IR.CCResultI("IndexItemActDate",xItemID,xDate,xResultID))
				Quit:xResultID=""			  
				Set objResult=##class(DHCHAI.IR.CCResult).GetObjById(xResultID)
				Continue:'$IsObject(objResult) 
				Continue:objResult.CCIsActive'=1
				Set EpisodeID=objResult.CCEpisodeDr.%Id()				
				Set tmpL = $g(^TMP($zn,$j,QryName,EpisodeID))
				Set:$listfind(tmpL,xItemID)<1 ^TMP($zn,$j,QryName,EpisodeID)=tmpL_$lb(xItemID)
				Set ^TMP($zn,$j,QryName,EpisodeID,xResultID)=""
			}		
				
		}
	}
	
	Set aItemIDList=##class(DHCHAI.Utils.CommonSrv).ListFromString(aItemIDs,"|")
	Set xEpisodeID=0
	For {
		Set xEpisodeID=$o(^TMP($zn,$j,QryName,xEpisodeID))
		Quit:xEpisodeID=""
		Set tmpL = $g(^TMP($zn,$j,QryName,xEpisodeID))
		Continue:(aTypeFlag="1")&(tmpL'="")&($ll(tmpL)<$ll(aItemIDList))	//存在的比查询的还少
		Set aFlag = "1"  //符合条件标识
		if (aTypeFlag="1")
		{
			For indItem=1:1:$l(aItemIDs,"|") {
				Quit:aFlag="0"
				Set xItemID=$p(aItemIDs,"|",indItem)
				Set:(xItemID'="")&($listfind(tmpL,xItemID)<1) aFlag ="0"				
			}
		}
		Continue:aFlag="0"		
		Set objPaadm =##class(DHCHAI.DP.PAAdm).GetObjById(xEpisodeID)
		Quit:'$IsObject(objPaadm)
		Set EpisodeID=xEpisodeID
		Set EpisodeIDx=objPaadm.PAEpisodeIDx
		Set SCode = $p(EpisodeIDx,"||",1)
		Set VisitStatus=objPaadm.PAVisitStatus
		Set VisitStatusInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"VisitStatus",VisitStatus)
		If VisitStatusInfo'="" {
			Set VisitStatus=$p(VisitStatusInfo,"^",2)
		}
		Quit:(VisitStatus="P")||(VisitStatus="C")||(VisitStatus="U") //预住院、退院、作废
		
		Set RegNo=objPaadm.PAPapmiNo
		Set PatName = objPaadm.PAPatName

		Set Sex = objPaadm.PASex
		Set Sex = $s(Sex="M":"男",Sex="F":"女",1:"")
		Set Birthday = objPaadm.PABirthday
		Set:Birthday'="" Birthday = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(Birthday)
		Set Age = objPaadm.PAAge
		
		Set TransLocInfo=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransLocInfo(EpisodeID,"E")
		Quit:TransLocInfo="" 
		Set CurrLocID=$p(TransLocInfo,"^",5)
		Set CurrLocDesc=$p(TransLocInfo,"^",6)
		Set:CurrLocID="" CurrLocID=objPaadm.PAAdmLocDr.%Id()
		Set:CurrLocID="" CurrLocDesc=objPaadm.PAAdmLocDr.BTDesc
		Set CurrBed = ""
		Set:$Isobject(objPaadm.PAAdmBedDr) CurrBed= objPaadm.PAAdmBedDr.BTDesc
		Set:CurrBed'["床" CurrBed=CurrBed_"床"
		Continue:(aLocID'="")&&(CurrLocID'=aLocID)
		Set ScreenAttInfo=##class(DHCHAI.IRS.CCScreenAttSrv).GetScreenAttInfo(xEpisodeID)
		Set xResultID=0
		For {
			Set xResultID=$o(^TMP($zn,$j,"QryResultPatList",xEpisodeID,xResultID))
			Quit:xResultID=""
			Set objResult=##class(DHCHAI.IR.CCResult).GetObjById(xResultID)
			Continue:'$IsObject(objResult) 
			Set CCItemDesc=objResult.CCItemDr.CCDesc
			Set CCResult=objResult.CCResult
			Set CCActDate=objResult.CCActDate
			
			Set:CCActDate'="" CCActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(CCActDate)
			
			Set ScreenAttInfo=##class(DHCHAI.IRS.CCScreenAttSrv).GetScreenAttInfo(xEpisodeID)
			Set IsNeedAtt=+$p(ScreenAttInfo,"^",1)
			Set IsSusInf=+$p(ScreenAttInfo,"^",2)
			Set IsSuspend=+$p(ScreenAttInfo,"^",3)	
							
			Set IsNeedAtt=""
			Set SuspendCode=IsSusInf_","_IsSuspend
			Set SuspendDesc="非疑似"
			if (IsSusInf=1)
			{
				Set SuspendDesc = "疑似"
				Set SuspendDesc = SuspendDesc_$s(IsSuspend=0:"待处理",IsSuspend=1:"已确诊",IsSuspend=2:"已排除",IsSuspend=3:"已上报",1:"")
			}
			
			 
			Set Data=$lb(EpisodeID,RegNo,PatName,Sex,Age,CurrLocID,CurrBed,VisitStatus,CurrLocDesc,IsNeedAtt,SuspendCode,SuspendDesc,xItemID,CCItemDesc,CCResult,CCActDate)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}		
	}
	kill ^TMP($zn,$j,QryName)
	Quit $$$OK
}

ClassMethod QryResultPatListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryResultPatListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryResultPatListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryResultPatListExecute ]
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
/// CreatDate：   2018-04-11
/// Description:  取多耐分类
/// Table：       DHCHAI.IR.CCResult
/// Input：       aEpisodeID就诊号 aItemCode监控项目 aBacteria细菌名称
/// Return：      返回DHCHAI.IR.CRuleMRB的obj
/// w ##class(DHCHAI.IRS.CCResultSrv).GetMRBType("99719","","无乳链球菌")
ClassMethod GetMRBType(aEpisodeID As %String, aItemCode As %String, aBacteria As %String, aResultID As %String = "") As DHCHAI.IR.CRuleMRB
{
	New (aEpisodeID,aItemCode,aBacteria,aResultID)
	Set return=""
	Quit:(aEpisodeID="")||(aBacteria="") return
	
	Set obj=""
	If (aItemCode=""){
		Set xItemDr=""
		For {
			Set xItemDr=$o(^DHCHAI.IR.CCResultI("IndexItemDrBacteria",aEpisodeID,xItemDr))
			Quit:xItemDr=""
			
			Set xResultID=""
			For {
				Set xResultID = $o(^DHCHAI.IR.CCResultI("IndexItemDrBacteria",aEpisodeID,xItemDr," "_aBacteria,xResultID))
				Quit:xResultID=""
				Set obj=##class(DHCHAI.IR.CCResult).GetObjById(xResultID)
				Continue:'$IsObject(obj)
				Set LabResultID = $p(obj.CCParams,"=",2)
				Continue:(aResultID'="")&(aResultID'=LabResultID)
				Quit:$IsObject(obj.CCMRBTpDr)
			}
		}
	} Else {
		Set ItemDr = $o(^DHCHAI.IR.CCItmMastI("IdxofCode",aItemCode,""))
		Quit:ItemDr="" return
		
		Set xResultID=""
		For {
			Set xResultID = $o(^DHCHAI.IR.CCResultI("IndexItemDrBacteria",aEpisodeID,ItemDr," "_aBacteria,xResultID))
			Quit:xResultID=""
			
			Set obj=##class(DHCHAI.IR.CCResult).GetObjById(xResultID)
			Continue:'$IsObject(obj)
			Set LabResultID = $p(obj.CCParams,"=",2)
			Continue:(aResultID'="")&(aResultID'=LabResultID)
			Quit:$IsObject(obj.CCMRBTpDr)
		}
		
	}
	Quit:'$IsObject(obj) return
	Quit obj.CCMRBTpDr
}

ClassMethod BuildPaadmData(aEpisodeID) As %String
{
	Set return=""
	Quit:aEpisodeID="" return
	Set objPaadm = ##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeID)
	Quit:'$isobject(objPaadm) return
	
	Set EpisodeIDx = objPaadm.PAEpisodeIDx
	Set SCode = $p(EpisodeIDx,"||",1)
	Set PatientIDx = objPaadm.PAPatientIDx
	Set PapmiNo = objPaadm.PAPapmiNo
	Set MrNo = objPaadm.PAMrNo
	Set PatName = objPaadm.PAPatName
	Set Sex = objPaadm.PASex
	Set Sex = $s(Sex="M":"男",Sex="F":"女",1:"")
	Set Age = objPaadm.PAAge
	Set AdmType = objPaadm.PAAdmType
	
	// O门诊、E急诊、EP急诊留观、I住院
	If AdmType="I"{
		Set AdmType="住院"
	}ElseIf AdmType="O" {
		Set AdmType="门诊"
	}ElseIf AdmType="E" {
		Set AdmType="急诊"
	}ElseIf AdmType="EP" {
		Set AdmType="急诊留观"
	}
	
	Set VisitStatus = objPaadm.PAVisitStatus
	Set VisitStatusInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"VisitStatus",VisitStatus)
	If VisitStatusInfo'="" {
		Set VisitStatus=$p(VisitStatusInfo,"^",2)
	}
	Set AdmDate = objPaadm.PAAdmDate
	Set:AdmDate'="" AdmDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
	Set AdmTime = objPaadm.PAAdmTime
	Set:AdmTime'="" AdmTime=$zt(AdmTime)
	Set objAdmLoc = objPaadm.PAAdmLocDr
	Set AdmLocDesc=""
	If $isobject(objAdmLoc) {
		Set LocDesc2 = objAdmLoc.BTDesc2
		Set LocDesc = objAdmLoc.BTDesc
		Set AdmLocDesc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
	}
	Set objAdmWard = objPaadm.PAAdmWardDr
	Set AdmWardDesc=""
	If $isobject(objAdmWard) {
		Set WardDesc2 = objAdmWard.BTDesc2
		Set WardDesc = objAdmWard.BTDesc
		Set AdmWardDesc = $s(WardDesc2'="":WardDesc2,1:WardDesc)
	}

	Set AdmRoom = objPaadm.PAAdmRoom
	Set objAdmBed = objPaadm.PAAdmBedDr
	Set AdmBed=""
	If $isobject(objAdmBed) {
		Set AdmBed = objAdmBed.BTDesc
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
	
	Set AdmDateTime=AdmDate_" "_AdmTime
	Set DischDateTime=DischDate_" "_DischTime

	Set return = $lb(aEpisodeID,PapmiNo,MrNo,PatName,Sex,Age,AdmType,VisitStatus,AdmDateTime,AdmLocDesc,AdmWardDesc,AdmRoom,AdmBed,DischDateTime,DischLocDesc,DischWardDesc)
	Quit return
}

}
