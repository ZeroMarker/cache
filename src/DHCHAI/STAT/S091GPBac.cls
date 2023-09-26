/// 名称: DHCHAI.STAT.S091GPBac
/// 描述: HAI0091革兰阳性细菌构成比统计表
/// 编写者: mayanpeng
/// 编写日期: 2018-07-31
Class DHCHAI.STAT.S091GPBac Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：		mayanpeng
/// CreateDate：	2018-07-31
/// Description:	采集日期查询检验报告病原体(医院感染病原体构成比、革兰氏阴/阳性菌占比)
/// Input:          aHospIDs： 多个医院用"|"连接
///         	    aLocType： 科室E、病区W
///                 aLocIDs：  科室/病区ID（DHCHAI.BT.Location.ID）
/// 				aDateFrom：开始日期
/// 				aDateTo：  结束日期 
/// Do ##class(%Library.ResultSet).RunQuery("DHCHAI.STAT.S091GPBac","QryPathogeny","2|1","W","","2018-01-01","2018-04-10")
Query QryPathogeny(aHospIDs As %String, aLocType As %String, aLocIDs As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "ind:%String,EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,LocTypeDesc:%String,LocID:%String,LocDesc:%String,WardID:%String,WardDesc:%String,LabNumID:%String,EpisodeNo:%String:%String,Specimen:%String,ReportID:%String,ResultID:%String,RecDate:%String,RecTime:%String,BacID:%String,BacCode:%String,BacDesc:%String,CatID:%String,CatCode:%String,CatDesc:%String,TypeID:%String,TypeCode:%String,TypeDesc:%String") [ SqlProc ]
{
}

ClassMethod QryPathogenyExecute(ByRef qHandle As %Binary, aHospIDs As %String, aLocType As %String, aLocIDs As %String, aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
 	
 	//Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
 	Set aLocIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aLocIDs,"|")
 	
	Set ListArray=##class(DHCHAI.DPS.PAAdmSrv).GetEpisodeDrByDate(aDateFrom,aDateTo,aHospIDs,aLocIDs,"I")
	For index=1:1:ListArray.Count() {
		Set xEpisodeID=ListArray.GetAt(index)
		Continue:xEpisodeID=""
		//过滤出医院感染的病例
		//Continue:'$d(^DHCHAI.IR.INFDiagnosI("IndexPaadm",xEpisodeID))
     	
		Set objAdm = ##class(DHCHAI.DP.PAAdm).GetObjById(xEpisodeID)
		Continue:'$Isobject(objAdm)
		Set PatientID = objAdm.PAPatientIDx
		Set PapmiNo   = objAdm.PAPapmiNo
		Set MrNo      = objAdm.PAMrNo
		Set PatName   = objAdm.PAPatName
		Set Sex       = objAdm.PASex
		Set Sex       = $s(Sex="M":"男",Sex="F":"女",Sex="O":"其他")
		Set AdmDate   = objAdm.PAAdmDate
		Set AdmTime   = objAdm.PAAdmTime
		Set Age       = objAdm.PAAge
		
		Set IsHA=0,IsHACF=0,IsDZ=0,IsDZCF=0     //HA、HA重复、定值、定值重复
	    Set ResultList=""
	    Set ListVisitArray=##class(DHCHAI.STAS.StaService).GetVisitNumber(xEpisodeID,aDateFrom,aDateTo)
		For indx=1:1:ListVisitArray.Count() {
		    Set VisitInfo=ListVisitArray.GetAt(indx)	
			Continue:VisitInfo=""
			Set LabNumID  = $LIST(VisitInfo,1)
			Set EpisodeNo = $LIST(VisitInfo,2)
			Set Specimen  = $LIST(VisitInfo,3)
			Set RecDate   = $LIST(VisitInfo,4)	 //接收日期
			Set RecTime   = $LIST(VisitInfo,5)   //接收时间
		    Set IPHour=((RecDate-AdmDate)*24)+((RecTime-AdmTime)\3600)  //排除CA
			Continue:IPHour<48
			
			//采集病区
			Set LocIfno=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(xEpisodeID,RecDate,RecTime)
		    Set LocID = $p(LocIfno,"^",1)
		    Set WardID = $p(LocIfno,"^",2)
			Continue:(aLocIDs'="")&($listfind(aLocIDs,LocID)<1)  //按科室过滤
			Continue:(aLocIDs'="")&($listfind(aLocIDs,WardID)<1)  //按病区过滤
		   	Set objRecLoc = ##class(DHCHAI.BT.Location).GetObjById(LocID)
		   	Set objRecWard = ##class(DHCHAI.BT.Location).GetObjById(WardID)
			Continue:'$IsObject(objRecLoc)||('$IsObject(objRecWard))
			If ($IsObject(objRecLoc.BTGroupDr)){
				Set LocTypeDesc = objRecLoc.BTGroupDr.BTDesc  // 科室分类
			}Else {
				Set LocTypeDesc="其他科"
			}
		    Set LocDesc=objRecLoc.BTDesc2
		    Set:LocDesc="" LocDesc=objRecLoc.BTDesc
		    Set WardDesc=objRecWard.BTDesc2
		    Set:WardDesc="" WardDesc=objRecWard.BTDesc
		    
			//Continue:'$IsObject(objRecLoc.BTHospDr)
			//Continue:(aHospIDs'="")&($listfind(aHospIDs,objRecLoc.BTHospDr.%Id())<1)  //按医院过滤	
			Set:RecDate'="" RecDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RecDate)
			Set:RecTime'="" RecTime=$zt(RecTime)

			Set ListResultArray=##class(DHCHAI.STAS.StaService).GetVisitRepResult(LabNumID)
			For indy=1:1:ListResultArray.Count() {
		    	Set ResultInfo=ListResultArray.GetAt(indy)
		    	Continue:ResultInfo=""
				Set ReportID = $LIST(ResultInfo,1)
				Set ResultID = $LIST(ResultInfo,2)
				Set objReport=##class(DHCHAI.DP.LabVisitReport).GetReportByID(ReportID)
				Continue:'$IsObject(objReport)
			    Set TSReportID=objReport.LabReportID  //检验报告号
	            Set SCode=objReport.LabSCode
	            
				Set objResult=##class(DHCHAI.DP.LabVisitRepResult).GetObjById(ResultID)
				Continue:'$IsObject(objResult)
				Set Bacteria  = objResult.LabResult
	            Set objBactMap = ##class(DHCHAI.DP.LabBactMap).GetObjByBacteria(SCode,Bacteria)
	            Continue:'$IsObject(objBactMap)
				Continue:'$IsObject(objBactMap.BTMapItemDr)
				Set BacID=objBactMap.BTMapItemDr.%Id()
				Set BacCode=objBactMap.BTMapItemDr.BTBacCode
				Set BacDesc=objBactMap.BTMapItemDr.BTBacDesc
				
				/***********如何判断HA?*******/
				/*****************************/
				If ((ResultList'="")&&($listfind(ResultList,BacDesc)>0)) { //判断HA重复 ？
				   Set IsHACF=1 
				   Continue:IsHACF=1
				}
				Set ResultList=ResultList_$lb(BacDesc)
				/*****判断定值、定值重复******/
				/*****************************/
				
				Set CatID="",CatCode="",CatDesc=""
				Set TypeID="",TypeCode="",TypeDesc=""
				Set objBact=##class(DHCHAI.DP.LabBacteria).GetObjById(BacID)
				Continue:'$Isobject(objBact)
				If $IsObject(objBact.BTCatDr){
					Set CatID   = objBact.BTCatDr.%Id()
					Set CatCode = objBact.BTCatDr.BTCode
					Set CatDesc = objBact.BTCatDr.BTDesc
				}
				If $IsObject(objBact.BTTypeDr){
					Set TypeID   = objBact.BTTypeDr.%Id()
					Set TypeCode = objBact.BTTypeDr.BTCode
					Set TypeDesc = objBact.BTTypeDr.BTDesc
				}
				Set AbFlag    = objResult.LabAbFlag
				Set MDRResult = objResult.LabMDRResult
			
				Set Data=$lb(xEpisodeID,PapmiNo,MrNo,PatName,Sex,Age,LocTypeDesc,LocID,LocDesc,WardID,WardDesc,LabNumID,EpisodeNo,Specimen,ReportID,ResultID,RecDate,RecTime,BacID,BacCode,BacDesc,CatID,CatCode,CatDesc,TypeID,TypeCode,TypeDesc)
				Set ^CacheTemp(repid,ind)=$lb(ind)_Data
				Set ind=ind+1
			}
		}
	}
	Quit $$$OK
}

ClassMethod QryPathogenyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPathogenyExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPathogenyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPathogenyExecute ]
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
