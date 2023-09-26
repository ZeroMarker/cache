/// Name:         DHCHAI.DI.DWS.SyncPatVaeData
/// Creator：     zhoubo
/// CreatDate：   2022-02-18
/// Description:  同步患者重症系统VAE数据
Class DHCHAI.DI.DWS.SyncPatVaeData Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2022-02-18
/// Description:  根据就诊获取患者VAE数据
/// aEpisodeIDX:  HIS就诊号
/// aDateTo：     结束日期
/// aDateFrom :   开始日期
/// Return：      处理报告数
/// w ##class(DHCHAI.DI.DWS.SyncPatVaeData).SyncVAEByDate("HIS01||161866060","2022-03-20","2022-04-11")
ClassMethod SyncVAEByDate(aEpisodeIDX As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	New (aEpisodeIDX,aDateFrom,aDateTo)
	Set return=0,Count=0
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Quit:(aEpisodeIDX="")||(aDateFrom="")||(aDateTo="") return

	Set aEpisodeID = $p(aEpisodeIDX,"||",2)
	Set HISCode = $p(aEpisodeIDX,"||",1)
	Set objAdm=##class(DHCHAI.DP.PAAdm).GetObjByEpisodeIDX(aEpisodeIDX)
	Quit:'$IsObject(objAdm) return
	
	Set EpisodeDr = objAdm.%Id()
	
	/// 获取检查报告列表
	Set rs=##Class(%ResultSet).%New("DHCHAI.DI.DWS.SyncPatVaeData:QryVAE")
	Set sc=rs.Execute(aEpisodeID,aDateFrom,aDateTo)
	If $$$ISERR(sc) {
  		Do $System.Status.DisplayError(sc)
  		Quit return
	}
	Set rowData=##Class(%ArrayOfDataTypes).%New()
	If rowData'="" Do rowData.%Close()
    While (rs.Next()){
	    Set ICUOrderID  = rs.Data("ICUOrderID")	   // 重症ID
	    Set ResultType  = rs.Data("ResultType")    // 结果类型 PEEP 或FiO2
		Set ResultType  = $zcvt(ResultType,"U")
		Set:ResultType["PEEP" ResultType="PEEP"
		Set:ResultType["FIO2" ResultType="FIO2"
		Set ResultDate  = rs.Data("ResultDate")    // 用户填写日期
		Set ResultTime  = rs.Data("ResultTime")    // 用户填写时间
		Set Result      = rs.Data("Result")        // 结果
		Set RegUser     = rs.Data("RegUser")       // 录入人
		Set RstIsActive = rs.Data("RstIsActive")   // 是否有效
		Set:RstIsActive="Y" RstIsActive=1
		Set:RstIsActive="N" RstIsActive=0
		
		//保存患者VAE数据
		Set ID=$o(^DHCHAI.DP.VAEICUPeepI("IndexEpisICU",EpisodeDr,ICUOrderID,0))
		Set InputStr = ID
		Set InputStr = InputStr_"^"_EpisodeDr
		Set InputStr = InputStr_"^"_ICUOrderID
		Set InputStr = InputStr_"^"_ResultType
		Set InputStr = InputStr_"^"_Result
		Set InputStr = InputStr_"^"_RstIsActive
		Set InputStr = InputStr_"^"_ResultDate
		Set InputStr = InputStr_"^"_ResultTime
		Set InputStr = InputStr_"^"_RegUser
		Set VAEDr = ##class(DHCHAI.DP.VAEICUPeep).Update(InputStr,"^")
		If (+VAEDr)<1 {
			//记录错误日志
			Set ErrClass  = "DHCHAI.DP.VAEICUPeep"
			Set ErrMethod = "Update"
			Set ErrArgStr = $lb(InputStr,"^")
			Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
		}
		Continue:(+VAEDr)<1
		
		//计数
		Set Count=Count+1
    }
    Quit Count
}

/// Creator：      zhoubo
/// CreatDate：    2022-02-18
/// Description:   查询单个就诊VAE列表
/// Input：        aEpisodeID, aDateFrom, aDateTo
/// Output：       返回患者VAE数据
/// d ##class(%ResultSet).RunQuery("DHCHAI.DI.DWS.SyncPatVaeData","QryVAE","163240160","2022-03-29","2022-04-09")
Query QryVAE(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "ICUOrderID:%String,ResultType:%String,ResultDate:%String,ResultTime:%String,Result:%String,RegUser:%String,RstIsActive:%String")
{
}

ClassMethod QryVAEExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	Quit:(aEpisodeID="") $$$OK
 	
 	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Set aDateFrom=$zd(aDateFrom,3)
	Set aDateTo=$zd(aDateTo,3)
 
	set service=##class(DHCCL.Factory.ICUInterfaceFactory).GetService()
	set xmlStream=service.GetVAEInfoByEpisodeID(aEpisodeID,aDateFrom,aDateTo)
	//测试XML代码
	//Set xmlStream="<Response><VAE><ICUOrderID>1</ICUOrderID><ResultType>PEEP</ResultType><ResultDate>2017-08-01</ResultDate><ResultTime>20:00:00</ResultTime><Result>5</Result><RegUser>王敬娥</RegUser><RstIsActive>Y</RstIsActive></VAE><VAE><ICUOrderID>92</ICUOrderID><ResultType>FiO2</ResultType><ResultDate>2017-08-02</ResultDate><ResultTime>08:00:00</ResultTime><Result>350</Result><RegUser>王敬娥</RegUser><RstIsActive>Y</RstIsActive></VAE></Response>"

	Set sc =##class(%XML.XPATH.Document).CreateFromStream(xmlStream,.documentList)
	Quit:($$$ERROR(sc)) $$$OK 
	
	Set sc = documentList.EvaluateExpression("/Response","count(VAE)",.documentNode)
	Quit:($$$ERROR(sc)||(documentNode.GetAt(1)="")) $$$OK
	Set DCount = documentNode.GetAt(1).Value
	For i=1:1:DCount
	{
		Set sc = documentList.EvaluateExpression("/Response/VAE["_i_"]/ICUOrderID","text()",.result)
		Continue:($$$ERROR(sc)||(result.GetAt(1)=""))
		Set ICUOrderID = result.GetAt(1).Value
		
		Set sc = documentList.EvaluateExpression("/Response/VAE["_i_"]/ResultType","text()",.result)
		Continue:($$$ERROR(sc)||(result.GetAt(1)=""))
		Set ResultType = result.GetAt(1).Value
		
		Set sc = documentList.EvaluateExpression("/Response/VAE["_i_"]/ResultDate","text()",.result)
		Continue:($$$ERROR(sc)||(result.GetAt(1)=""))
		Set ResultDate = result.GetAt(1).Value
		
		Set sc = documentList.EvaluateExpression("/Response/VAE["_i_"]/ResultTime","text()",.result)
		Continue:($$$ERROR(sc)||(result.GetAt(1)=""))
		Set ResultTime = result.GetAt(1).Value
		
		Set sc = documentList.EvaluateExpression("/Response/VAE["_i_"]/Result","text()",.result)
		Continue:($$$ERROR(sc)||(result.GetAt(1)=""))
		Set Result = result.GetAt(1).Value
		
		Set sc = documentList.EvaluateExpression("/Response/VAE["_i_"]/RegUser","text()",.result)
		Continue:($$$ERROR(sc)||(result.GetAt(1)=""))
		Set RegUser = result.GetAt(1).Value
		
		Set sc = documentList.EvaluateExpression("/Response/VAE["_i_"]/RstIsActive","text()",.result)
		Continue:($$$ERROR(sc)||(result.GetAt(1)=""))
		Set RstIsActive = result.GetAt(1).Value
		
		Set Data = $lb(ICUOrderID,ResultType,ResultDate,ResultTime,Result,RegUser,RstIsActive)
		Set ^CacheTemp(repid,ind) = Data
		Set ind=ind + 1
	}
	Quit $$$OK
}

ClassMethod QryVAEClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryVAEExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QryVAEFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryVAEExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
