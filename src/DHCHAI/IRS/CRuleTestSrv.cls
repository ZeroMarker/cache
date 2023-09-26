/// 名称: DHCHAI.IRS.CRuleTestSrv
/// 描述: 常规检验项目维护相关服务
/// 编写者： pylian
/// 编写日期: 2017-05-19
Class DHCHAI.IRS.CRuleTestSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian
/// CreatDate：   2017-05-05
/// Description:  查询常规检验项目维护
/// Table：       DHCHAI.IR.CRuleTestAb
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.CRuleTestSrv","QryCRuleTestAb")
Query QryCRuleTestAb() As %Query(ROWSPEC = "ID:%String,TestSet:%String,TestCode:%String,IsActive:%String,TSPFlag:%String,TRFFlag:%String,TRFlag:%String,TRVMaxFlag:%String,MaxValM:%Float,MaxValF:%Float,TRVMinFlag:%String,MinValM:%Float,MinValF:%Float") [ SqlProc ]
{
}

ClassMethod QryCRuleTestAbExecute(ByRef qHandle As %Binary) As %Status
{

	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)

	Set xID = ""
	For {
		Set xID = $o(^DHCHAI.IR.CRuleTestAbD(xID))
		Quit:xID=""
	  
		Set objTS = ##class(DHCHAI.IR.CRuleTestAb).GetObjById(xID)
		Continue:'$Isobject(objTS)
		
		Set TestSet    = objTS.BTTestSet
		Set TestCode   = objTS.BTTestCode
		Set IsActive   = objTS.BTIsActive
		Set TSPFlag    = objTS.BTTSPFlag
		Set TRFFlag    = objTS.BTTRFFlag
		Set TRFlag     = objTS.BTTRFlag
		Set TRVMaxFlag = objTS.BTTRVMaxFlag
		Set MaxValM	   = objTS.BTMaxValM
		Set MaxValF	   = objTS.BTMaxValF
		Set TRVMinFlag = objTS.BTTRVMinFlag
		Set MinValM    = objTS.BTMinValM
		Set MinValF    = objTS.BTMinValF
		
		Set:$e(MaxValM,1)="." MaxValM = "0"_MaxValM
		Set:$e(MaxValF,1)="." MaxValF = "0"_MaxValF
		Set:$e(MinValM,1)="." MinValM = "0"_MinValM
		Set:$e(MinValF,1)="." MinValF = "0"_MinValF
		
		Set Data = $lb(xID,TestSet,TestCode,IsActive,TSPFlag,TRFFlag,TRFlag,TRVMaxFlag,MaxValM,MaxValF,TRVMinFlag,MinValM,MinValF)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryCRuleTestAbClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCRuleTestAbExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryCRuleTestAbFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCRuleTestAbExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     pylian
/// CreatDate：   2017-05-05
/// Description:  根据常规检验项目查询常规检验-异常标志维护
/// Table：       DHCHAI.IR.CRuleTestAbFlag
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.CRuleTestSrv","QryTSAbFlagByTsAb","1")
Query QryTSAbFlagByTsAb(aTsAbID As %String) As %Query(ROWSPEC = "ID:%String,TSRstID:%String,TSRstFlag:%String,MapText:%String,TCMapAbID:%String,TestCode:%String,ActDate:%String,ActTime:%String,ActUserID:%String,ActUser:%String,ActUserDesc:%String") [ SqlProc ]
{
}

ClassMethod QryTSAbFlagByTsAbExecute(ByRef qHandle As %Binary, aTsAbID As %String) As %Status
{

	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aTsAbID="" $$$OK
	
	Set xSubID =""
    For {
		Set xSubID = $o(^DHCHAI.IR.CRuleTestAbD(aTsAbID,"TRF",xSubID))
		Quit:xSubID="" 
	
		Set ID=aTsAbID_"||"_xSubID
		Set objAbFlg = ##class(DHCHAI.IR.CRuleTestAbFlag).GetObjById(ID)
		Continue:'$Isobject(objAbFlg)
		Continue:'$IsObject(objAbFlg.BTAbFlagDr)
		Continue:'$IsObject(objAbFlg.BTAbFlagDr.BTTCMapDr)
		
		Set TSRstID   = objAbFlg.BTAbFlagDr.%Id()
		Set TSRstFlag = objAbFlg.BTAbFlagDr.BTAbFlag
		Set MapText   = objAbFlg.BTAbFlagDr.BTMapText
		Set TCMapAbID = objAbFlg.BTAbFlagDr.BTTCMapDr.%Id()
		Set TestCode = objAbFlg.BTAbFlagDr.BTTCMapDr.BTTestCode

		Set ActDate      = objAbFlg.BTActDate
		Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)    	
		Set ActTime      = objAbFlg.BTActTime 
		Set:ActTime'="" ActTime=$zt(ActTime,1)  
		
		Set ActUserID="",ActUser="",ActUserDesc=""
		If $IsObject(objAbFlg.BTActUserDr) {
			Set ActUserID   = objAbFlg.BTActUserDr.%Id()
			Set ActUser     = objAbFlg.BTActUserDr.BTCode
			Set ActUserDesc = objAbFlg.BTActUserDr.BTDesc
		}
		
		Set Data = $lb(ID,TSRstID,TSRstFlag,MapText,TCMapAbID,TestCode,ActDate,ActTime,ActUserID,ActUser,ActUserDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
    }
	    
	Quit $$$OK
}

ClassMethod QryTSAbFlagByTsAbClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryTSAbFlagByTsAbExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryTSAbFlagByTsAbFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryTSAbFlagByTsAbExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     pylian
/// CreatDate：   2017-05-05
/// Description:  根据常规检验项目查询常规检验-检验项目维护
/// Table：       DHCHAI.IR.CRuleTestCode
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.CRuleTestSrv","QryTSCodeByTsAb","1")
Query QryTSCodeByTsAb(aTsAbID As %String) As %Query(ROWSPEC = "ID:%String,TCMID:%String,TCMCode:%String,TCMDesc:%String,RstFormat:%String,MapRstFormat:%String,ActDate:%String,ActTime:%String,ActUserID:%String,ActUser:%String,ActUserDesc:%String") [ SqlProc ]
{
}

ClassMethod QryTSCodeByTsAbExecute(ByRef qHandle As %Binary, aTsAbID As %String) As %Status
{

	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aTsAbID="" $$$OK
	
	Set xSubID =""
    For {
		Set xSubID = $o(^DHCHAI.IR.CRuleTestAbD(aTsAbID,"TC",xSubID))
		Quit:xSubID="" 
	
		Set ID=aTsAbID_"||"_xSubID
		Set objTSCode = ##class(DHCHAI.IR.CRuleTestCode).GetObjById(ID)
		Continue:'$Isobject(objTSCode)
		Continue:'$Isobject(objTSCode.BTTestCodeDr)
		
		Set TCMID     = objTSCode.BTTestCodeDr.%Id()
		Set TCMCode   = objTSCode.BTTestCodeDr.BTTestCode
		Set TCMDesc   = objTSCode.BTTestCodeDr.BTTestDesc
		Set RstFormat = objTSCode.BTTestCodeDr.BTRstFormat
		Set SCode     = objTSCode.BTTestCodeDr.BTSCode
		Set MapRstFormat = ##class(DHCHAI.DP.PhraseMap).GetMapValue(SCode,"LABRstFormat",RstFormat)
		
		Set ActDate   = objTSCode.BTActDate
		Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)    	
		Set ActTime   = objTSCode.BTActTime 
		Set:ActTime'="" ActTime=$zt(ActTime,1)  
		 	
		Set ActUserID="",ActUser="",ActUserDesc=""
		If $IsObject(objTSCode.BTActUserDr) {
			Set ActUserID   = objTSCode.BTActUserDr.%Id()
			Set ActUser     = objTSCode.BTActUserDr.BTCode
			Set ActUserDesc = objTSCode.BTActUserDr.BTDesc
		}
		
		Set Data = $lb(ID,TCMID,TCMCode,TCMDesc,RstFormat,MapRstFormat,ActDate,ActTime,ActUserID,ActUser,ActUserDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
    }
	    
	Quit $$$OK
}

ClassMethod QryTSCodeByTsAbClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryTSCodeByTsAbExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryTSCodeByTsAbFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryTSCodeByTsAbExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     pylian
/// CreatDate：   2017-05-05
/// Description:  根据常规检验项目查询常规检验-检验结果维护
/// Table：       DHCHAI.IR.CRuleTestAbResult
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.CRuleTestSrv","QryTSResultByTsAb","1")
Query QryTSResultByTsAb(aTsAbID As %String) As %Query(ROWSPEC = "ID:%String,TestID:%String,TestResult:%String,MapText:%String,TCMapAbID:%String,TestCode:%String,ActDate:%String,ActTime:%String,ActUserID:%String,ActUser:%String,ActUserDesc:%String") [ SqlProc ]
{
}

ClassMethod QryTSResultByTsAbExecute(ByRef qHandle As %Binary, aTsAbID As %String) As %Status
{

	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aTsAbID="" $$$OK
	
	Set xSubID =""
    For {
		Set xSubID = $o(^DHCHAI.IR.CRuleTestAbD(aTsAbID,"TR",xSubID))
		Quit:xSubID="" 
	
		Set ID=aTsAbID_"||"_xSubID
		Set objTSResult = ##class(DHCHAI.IR.CRuleTestResult).GetObjById(ID)
		Continue:'$Isobject(objTSResult)
		Continue:'$Isobject(objTSResult.BTTestResultDr)
		Continue:'$Isobject(objTSResult.BTTestResultDr.BTTCMapDr)
		
		Set TestID      = objTSResult.BTTestResultDr.%Id()
		Set TestResult  = objTSResult.BTTestResultDr.BTTestRes
		Set MapText     = objTSResult.BTTestResultDr.BTMapText
		Set TCMapAbID   = objTSResult.BTTestResultDr.BTTCMapDr.%Id()
		Set TestCode    = objTSResult.BTTestResultDr.BTTCMapDr.BTTestCode
		Set ActDate   = objTSResult.BTActDate
		Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)    	
		Set ActTime   = objTSResult.BTActTime 
		Set:ActTime'="" ActTime=$zt(ActTime,1)  
		 	
		Set ActUserID="",ActUser="",ActUserDesc=""
		If $IsObject(objTSResult.BTActUserDr) {
			Set ActUserID   = objTSResult.BTActUserDr.%Id()
			Set ActUser     = objTSResult.BTActUserDr.BTCode
			Set ActUserDesc = objTSResult.BTActUserDr.BTDesc
		}
				
		Set Data = $lb(ID,TestID,TestResult,MapText,TCMapAbID,TestCode,ActDate,ActTime,ActUserID,ActUser,ActUserDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
    }
	    
	Quit $$$OK
}

ClassMethod QryTSResultByTsAbClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryTSResultByTsAbExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryTSResultByTsAbFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryTSResultByTsAbExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     pylian
/// CreatDate：   2017-05-05
/// Description:  根据常规检验项目查询常规检验-标本维护
/// Table：       DHCHAI.IR.CRuleTestAbSpec
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.CRuleTestSrv","QryTSSpecByTsAb","1")
Query QryTSSpecByTsAb(aTsAbID As %String) As %Query(ROWSPEC = "ID:%String,TSSpecID:%String,TSSpec:%String,MapSpec:%String,ActDate:%String,ActTime:%String,ActUserID:%String,ActUser:%String,ActUserDesc:%String") [ SqlProc ]
{
}

ClassMethod QryTSSpecByTsAbExecute(ByRef qHandle As %Binary, aTsAbID As %String) As %Status
{

	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aTsAbID="" $$$OK
	
	Set xSubID =""
    For {
		Set xSubID = $o(^DHCHAI.IR.CRuleTestAbD(aTsAbID,"TSP",xSubID))
		Quit:xSubID="" 
	
		Set ID=aTsAbID_"||"_xSubID
		Set objTSSpec = ##class(DHCHAI.IR.CRuleTestSpec).GetObjById(ID)
		Continue:'$Isobject(objTSSpec)
		
		Set TSSpecID="",TSSpec="",MapSpec=""
		If $IsObject(objTSSpec.BTTestSpecDr) {
			Set TSSpecID   = objTSSpec.BTTestSpecDr.%Id()
			Set TSSpec     = objTSSpec.BTTestSpecDr.BTSpecDesc
			Set objMapSpec = objTSSpec.BTTestSpecDr.BTMapItemDr
			If $IsObject(objMapSpec) {
				Set MapSpec = objMapSpec.BTSpecDesc
			}
		}
		Set ActDate  = objTSSpec.BTActDate
		Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)    	
		Set ActTime  = objTSSpec.BTActTime 
		Set:ActTime'="" ActTime=$zt(ActTime,1)  
		
		Set ActUserID="",ActUser="",ActUserDesc=""
		If $IsObject(objTSSpec.BTActUserDr) {
			Set ActUserID   = objTSSpec.BTActUserDr.%Id()
			Set ActUser     = objTSSpec.BTActUserDr.BTCode
			Set ActUserDesc = objTSSpec.BTActUserDr.BTDesc
		}
				
		Set Data = $lb(ID,TSSpecID,TSSpec,MapSpec,ActDate,ActTime,ActUserID,ActUser,ActUserDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
    }
	    
	Quit $$$OK
}

ClassMethod QryTSSpecByTsAbClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryTSSpecByTsAbExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryTSSpecByTsAbFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryTSSpecByTsAbExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
