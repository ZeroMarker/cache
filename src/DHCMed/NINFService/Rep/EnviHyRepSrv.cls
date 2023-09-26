/// 名称: DHCMed.NINFService.Rep.EnviHyRepSrv
/// 描述: 环境卫生学监测报告查询（检验）
/// 编写者：zhufei
/// 编写日期: 2014-07-30
Class DHCMed.NINFService.Rep.EnviHyRepSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2014-07-30
/// Description:  查询环境卫生学监测报告列表
/// Table：       DHCMed.NINF.Rep.EnviHyReport
/// Input:        aQueryCode ：查询代码
///               aDateFrom  ：开始日期
///               aDateTo    ：结束日期
///               aLoc       ：科室
///               aBarCode   ：条码
/// do ##class(%ResultSet).RunQuery("DHCMed.NINFService.Rep.EnviHyRepSrv","QryEnviHyRep",4,"2014-08-01","2014-08-17","","0000002001")
Query QryEnviHyRep(aQueryCode As %String, aDateFrom As %String, aDateTo As %String, aLoc As %String, aBarCode As %String) As %Query(ROWSPEC = "ReportID:%String,RepBarCode:%String,RepStatusCode:%String,RepStatusDesc:%String,AskForLocID:%String,AskForLocDesc:%String,AskForUserID:%String,AskForUserDesc:%String,ItemID:%String,ItemDesc:%String,ItemCategID:%String,ItemCategDesc:%String,NormID:%String,NormDesc:%String,NormMax:%String,NormMin:%String,NormRange:%String,ItemObj:%String,ItemDate:%String,SpecTypeID:%String,SpecTypeDesc:%String,SpecimenNum:%String,CenterNum:%String,SurroundNum:%String,IssueSpecNum:%String,UnissueSpecNum:%String,AddSpecNum:%String,UnfinishCount:%String,Pathogens:%String,Result:%String,AutoIsNorm:%String,RepDate:%String,RepTime:%String,RepLocID:%String,RepLocDesc:%String,RepUserID:%String,RepUserDesc:%String,RepResume:%String,ArgBarCode:%String")
{
}

ClassMethod QryEnviHyRepExecute(ByRef qHandle As %Binary, aQueryCode As %String, aDateFrom As %String, aDateTo As %String, aLoc As %String, aBarCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set aQueryCode=+aQueryCode
	Quit:(aLoc="")&&(aBarCode="") $$$OK
	Quit:(aBarCode'="")&&($l(aBarCode)'=10) $$$OK
	
	;Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	;Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set aDateFrom=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateTo)
	
	If aBarCode'="" {
		Set ID=+$e(aBarCode,2,8)
		Set SubCode=$e(aBarCode,9,10)
		Set objRep=##class(DHCMed.NINF.Rep.EnviHyReport).GetObjById(ID)
		Quit:'$IsObject(objRep) $$$OK
		Quit:'$IsObject(objRep.EHRRepStatus) $$$OK
		Set RepStatusCode=objRep.EHRRepStatus.Code
		Quit:RepStatusCode="0" $$$OK  //删除状态报告
		
		Set RepStatusInfo=..GetStatusByBarCode("",aBarCode)
		Set RepStatusCode=$p(RepStatusInfo,"^",1)
		Set RepStatusDesc=$p(RepStatusInfo,"^",2)
		Set BarStatus=$p(RepStatusInfo,"^",3)
		
		If aQueryCode="1" { //材料发放
			Quit:(RepStatusCode'="1")&&((RepStatusCode'="2")||(BarStatus'="0")) $$$OK //只显示"申请"状态记录
		} ElseIf aQueryCode="2" { //标本接收
			Quit:(RepStatusCode'="2")&&((RepStatusCode'="3")||(BarStatus'="0")) $$$OK //只显示"材料发放"状态记录
		} ElseIf aQueryCode="3" { //录入结果
			Quit:(RepStatusCode'="3")&&((RepStatusCode'="4")||(BarStatus'="0")) $$$OK //只显示"标本接收"状态记录
		} Else {
			//显示所有有效报告
		}
		
		Set Data=..BuildData(objRep)
		Quit:Data="" $$$OK
		Set Data=Data_$lb(aBarCode)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	} Else {
		Set xDate=aDateFrom-1
		For {
			Set xDate=$o(^DHCMed.NINFi("EnviRep",0,"IndexDateLoc",xDate))
			Quit:xDate=""
			Quit:xDate>aDateTo
			
			Set xLoc=""
			For {
				Set xLoc=$o(^DHCMed.NINFi("EnviRep",0,"IndexDateLoc",xDate,xLoc))
				Quit:xLoc=""
				Continue:(aLoc'="")&&(xLoc'=aLoc)
				
				Set xId=0
				For {
					Set xId=$o(^DHCMed.NINFi("EnviRep",0,"IndexDateLoc",xDate,xLoc,xId))
					Quit:xId=""
					
					Set objRep=##class(DHCMed.NINF.Rep.EnviHyReport).GetObjById(xId)
					Continue:'$IsObject(objRep)
					Continue:'$IsObject(objRep.EHRRepStatus)
					Set RepStatusCode=objRep.EHRRepStatus.Code
					Continue:RepStatusCode="0"  //删除状态报告
					
					Set RepStatusInfo=..GetStatusByBarCode(xId,"")
					Set RepStatusCode=$p(RepStatusInfo,"^",1)
					Set RepStatusDesc=$p(RepStatusInfo,"^",2)
					Set BarStatus=$p(RepStatusInfo,"^",3)
					
					If aQueryCode="1" { //材料发放
						Continue:(RepStatusCode'="1")&&((RepStatusCode'="2")||(BarStatus'="0")) //只显示"申请"状态记录
					} ElseIf aQueryCode="2" { //标本接收
						Continue:(RepStatusCode'="2")&&((RepStatusCode'="3")||(BarStatus'="0")) //只显示"材料发放"状态记录
					} ElseIf aQueryCode="3" { //录入结果
						Continue:(RepStatusCode'="3")&&((RepStatusCode'="4")||(BarStatus'="0")) //只显示"标本接收"状态记录
					} Else {
						//显示所有有效报告
					}
					
					Set Data=..BuildData(objRep)
					Continue:Data=""
					Set Data=Data_$lb(aBarCode)
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
		}
	}
	Quit $$$OK
}

ClassMethod QryEnviHyRepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEnviHyRepExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryEnviHyRepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryEnviHyRepExecute ]
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

ClassMethod BuildData(obj As DHCMed.NINF.Rep.EnviHyReport) As %List
{
	New (obj)
	Set return=""
	
	Quit:'$IsObject(obj) return
	Quit:'$IsObject(obj.EHRRepStatus) return
	Quit:obj.EHRRepStatus.Code="0" return
	
	Set ReportID=obj.%Id()
	Set RepStatusID=obj.EHRRepStatus.%Id()
	Set RepStatusCode=obj.EHRRepStatus.Code
	Set RepStatusDesc=obj.EHRRepStatus.Description
	
	Set AskForLocID=obj.EHRAskForLoc 				//申请科室
	Set AskForLocDesc=""
	Set objLoc=##class(DHCMed.Base.Ctloc).GetObjById(AskForLocID)
	If $IsObject(objLoc) {
		Set AskForLocID=objLoc.Rowid
		Set AskForLocDesc=objLoc.Descs
	}
	Set AskForUserID=obj.EHRAskForUser           //申请人
	Set AskForUserDesc=""
	Set EHRAskForUser=##class(DHCMed.Base.SSUser).GetObjById(AskForUserID)
	If $IsObject(EHRAskForUser) {
		Set AskForUserID=EHRAskForUser.Rowid
		Set AskForUserDesc=EHRAskForUser.Name
	}
	
	Set (ItemID,ItemDesc,ItemCategID,ItemCategDesc)=""
	If $IsObject(obj.EHRItem) {				    //检测项目
		Set ItemID=obj.EHRItem.%Id()
		Set ItemDesc=obj.EHRItem.EHIDesc
		Set objEHICateg=obj.EHRItem.EHICateg
		If $IsObject(objEHICateg) {
			Set ItemCategID=objEHICateg.%Id()
			Set ItemCategDesc=objEHICateg.Description
		}					
	}
	
	Set (NormID,NormDesc,NormMax,NormMin,NormRange,SpecimenNum,CenterNum,SurroundNum,SpecTypeID,SpecTypeDesc)=""
	Set objNorm=obj.EnviHyNorm
	If $IsObject(objNorm) {
		Set NormID=objNorm.%Id()
		Set NormDesc=objNorm.EHNNorm            //检测标准
		Set NormMax=objNorm.EHNNormMax          //中心值检测标准
		Set NormMin=objNorm.EHNNormMin          //周边值检测标准
		Set NormRange=objNorm.EHNRange          //检测范围
		set SpecimenNum=objNorm.SpecimenNum     //标本数量
		set SpecimenNum=+SpecimenNum
		set CenterNum=objNorm.CenterNum         //中心值数量
		set CenterNum=+CenterNum
		set SurroundNum=objNorm.SurroundNum     //周边值数量
		set SurroundNum=+SurroundNum
		set objSpecType=objNorm.SpecimenType	//标本类型
		If $Isobject(objSpecType){
			Set SpecTypeID=objSpecType.%Id()
			Set SpecTypeDesc=objSpecType.Description
		}
	}
	
	Set ItemObj=obj.EHRItemObj				    //项目对象
	Set ItemDate=obj.EHRDate					//检测日期
	;Set:ItemDate'="" ItemDate=$zd(ItemDate,3)
	Set:ItemDate'="" ItemDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ItemDate)
	
	Set IssueSpecNum=obj.SpecimenNum            //发放标本数量
	Set IssueSpecNum=+IssueSpecNum
	Set UnissueSpecNum=SpecimenNum-IssueSpecNum //未发标本数量
	Set AddSpecNum=obj.AddSpecimenNum	        //补发标本数量
	Set AddSpecNum=+AddSpecNum
	
	Set Result = obj.EHRResult			        //检测结果
	Set Pathogens = obj.EHRPathogens            //病原菌
	Set AutoIsNorm = obj.EHRAutoIsNorm	        //合格/达标情况 自动判断
	
	Set RepDate=obj.EHRRepDate
	;Set:RepDate'="" RepDate=$zd(RepDate,3)
	Set:RepDate'="" RepDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(RepDate)
	Set RepTime=obj.EHRRepTime
	Set:RepTime'="" RepTime=$zt(RepTime,1)
	
	Set RepLocID=obj.EHRRepLoc		            //报告科室
	Set RepLocDesc=""
	Set objRepLoc=##class(DHCMed.Base.Ctloc).GetObjById(RepLocID)
	If $IsObject(objRepLoc) {
		Set RepLocID=objRepLoc.Rowid
		Set RepLocDesc=objRepLoc.Descs
	}
	Set RepUserID=obj.EHRRepUser	            //报告人
	Set RepUserDesc=""
	Set objRepUser=##class(DHCMed.Base.SSUser).GetObjById(RepUserID)
	If $IsObject(objRepUser) {
		Set RepUserID=objRepUser.Rowid
		Set RepUserDesc=objRepUser.Name
	}
	Set RepResume=obj.EHRResume
	
	//申请号
	Set RepBarCode = obj.EHRBarCode
	
	//计算当前操作是否完成
	Set UnfinishCount=""
	If RepStatusCode="4" {
		Set ResultCount=0
		For indRst=1:1:$l(Result,",") {
			Set tmpResult=$p(Result,",",indRst)
			Continue:tmpResult=""
			Set ResultCount=ResultCount+1
		}
		Set UnfinishCount=ResultCount-SpecimenNum
	} Else {
		Set FinishStatusList=""
		If (RepStatusCode="0")||(RepStatusCode="1") {
			Set UnfinishCount=0
		} Else {
			Set LogCnt=obj.ChildLog.Count()
			For indLog=1:1:LogCnt {
				Set objLog=obj.ChildLog.GetAt(indLog)
				Continue:'$IsObject(objLog)
				Continue:'$IsObject(objLog.LogStatus)
				Set LogStatusCode=objLog.LogStatus.Code
				Continue:RepStatusCode'=LogStatusCode
				
				Set LogBarCode=objLog.LogBarCode
				
				If LogBarCode="" {
					Set UnfinishCount=0
				} Else {
					Set LogSubIndex=+$e(LogBarCode,$l(LogBarCode)-1,$l(LogBarCode))
					If LogSubIndex=0 {
						Set UnfinishCount=0
					} Else {
						Continue:$listfind(FinishStatusList,LogSubIndex)>0
						Set FinishStatusList=FinishStatusList_$lb(LogSubIndex)
						Set UnfinishCount=$listlength(FinishStatusList)-SpecimenNum
					}
				}
				
				Quit:UnfinishCount=0 //标示当前操作已完成
			}
		}
	}
	Set:UnfinishCount>0 UnfinishCount=0
	
	Set return=$lb(ReportID,RepBarCode,RepStatusCode,RepStatusDesc)
	Set return=return_$lb(AskForLocID,AskForLocDesc,AskForUserID,AskForUserDesc)
	Set return=return_$lb(ItemID,ItemDesc,ItemCategID,ItemCategDesc)
	Set return=return_$lb(NormID,NormDesc,NormMax,NormMin,NormRange,ItemObj,ItemDate,SpecTypeID,SpecTypeDesc)
	Set return=return_$lb(SpecimenNum,CenterNum,SurroundNum,IssueSpecNum,UnissueSpecNum,AddSpecNum,UnfinishCount)
	Set return=return_$lb(Pathogens,Result,AutoIsNorm)
	Set return=return_$lb(RepDate,RepTime,RepLocID,RepLocDesc,RepUserID,RepUserDesc,RepResume)
	Quit return
}

/// 取条码对应记录状态
/// w ##Class(DHCMed.NINF.Rep.EnviHyReportLog).GetStatusByBarCode("10","")
ClassMethod GetStatusByBarCode(aReportID As %String, aBarCode As %String) As %String
{
	New (aReportID,aBarCode)
	Set return=""
	Quit:(aBarCode="")&&(aReportID="") return
	
	If aBarCode'="" {
		Set ReportID=+$e(aBarCode,2,$l(aBarCode)-2)
		Set SubIndex=+$e(aBarCode,$l(aBarCode)-1,$l(aBarCode))
	} Else {
		Set ReportID=aReportID
		Set SubIndex=0
	}
	
	Set objRep=##class(DHCMed.NINF.Rep.EnviHyReport).GetObjById(ReportID)
	Quit:'$IsObject(objRep) return
	Quit:'$IsObject(objRep.EHRRepStatus) return
	Set StatusCode=objRep.EHRRepStatus.Code
	Set StatusDesc=objRep.EHRRepStatus.Description
	
	Quit:'$IsObject(objRep.EnviHyNorm) return
	Set SpecimenNum=objRep.EnviHyNorm.SpecimenNum
	Set SpecimenList=""
	
	Set BarStatus=0
	If (StatusCode="0")||(StatusCode="1") {
		Set BarStatus=1
	} Else {
		Set LogCnt=objRep.ChildLog.Count()
		For indLog=1:1:LogCnt {
			Set objLog=objRep.ChildLog.GetAt(indLog)
			Continue:'$IsObject(objLog)
			Continue:'$IsObject(objLog.LogStatus)
			Set LogStatusCode=objLog.LogStatus.Code
			Continue:StatusCode'=LogStatusCode
			Set LogStatusDesc=objLog.LogStatus.Description
			Set LogBarCode=objLog.LogBarCode
			If LogBarCode="" {
				Set BarStatus=1
			} Else {
				Set LogSubIndex=+$e(LogBarCode,$l(LogBarCode)-1,$l(LogBarCode))
				If (SubIndex>0) {
					Continue:SubIndex'=LogSubIndex
					Set BarStatus=1
				} Else {
					Continue:$listfind(SpecimenList,LogSubIndex)>0
					Set SpecimenList=SpecimenList_$lb(LogSubIndex)
					Set:$listlength(SpecimenList)=SpecimenNum BarStatus=1
				}
			}
			Quit:BarStatus=1
		}
	}
	Set return=StatusCode_"^"_StatusDesc_"^"_BarStatus
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-08-11
/// Description:  查询环境卫生学监测条码状态列表
/// Table：       DHCMed.NINF.Rep.EnviHyReport,DHCMed.NINF.Rep.EnviHyReportLog
/// Input:        aReportID  ：查询代码
/// do ##class(%ResultSet).RunQuery("DHCMed.NINFService.Rep.EnviHyRepSrv","QryBarCodeStatus",19,"")
Query QryBarCodeStatus(aReportID As %String, aBarCode As %String) As %Query(ROWSPEC = "BarCode:%String,StatusCode:%String,StatusDesc:%String,LogDate:%String,LogTime:%String,LogUser:%String,CurrFlag:%String")
{
}

ClassMethod QryBarCodeStatusExecute(ByRef qHandle As %Binary, aReportID As %String, aBarCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	If aBarCode'="" {
		Set ReportID=+$e(aBarCode,2,8)
	} Else {
		Set ReportID=aReportID
	}
	
	Set objRep=##class(DHCMed.NINF.Rep.EnviHyReport).GetObjById(ReportID)
	Quit:'$IsObject(objRep) $$$OK
	Quit:'$IsObject(objRep.EHRRepStatus) $$$OK
	Set StatusCode=objRep.EHRRepStatus.Code
	Set StatusDesc=objRep.EHRRepStatus.Description
	
	Quit:'$IsObject(objRep.EnviHyNorm) $$$OK
	Set SpecimenNum=objRep.EnviHyNorm.SpecimenNum
	Set RepBarCode=objRep.EHRBarCode
	
	Set AskForDate=objRep.EHRAskForDate
	;Set:AskForDate'="" AskForDate=$zd(AskForDate,3)
	Set:AskForDate'="" AskForDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(AskForDate)
	Set AskForTime=objRep.EHRAskForTime
	Set:AskForTime'="" AskForTime=$zt(AskForTime,1)
	Set AskForUser=objRep.EHRAskForUser
	Set:AskForUser'="" AskForUser=$p($g(^SSU("SSUSR",AskForUser)),"^",2)
	
	Kill BarCodeList
	If StatusCode="1" {
		Set BarCodeList(0)=$lb(StatusCode,StatusDesc,AskForDate,AskForTime,AskForUser)
	} Else {
		Set LogCnt=objRep.ChildLog.Count()
		For indLog=1:1:LogCnt {
			Set objLog=objRep.ChildLog.GetAt(indLog)
			Continue:'$IsObject(objLog)
			Continue:'$IsObject(objLog.LogStatus)
			Set LogStatusCode=objLog.LogStatus.Code
			Continue:StatusCode'=LogStatusCode
			Set LogStatusDesc=objLog.LogStatus.Description
			
			Set LogDate=objLog.LogDate
			;Set:LogDate'="" LogDate=$zd(LogDate,3)
			Set:LogDate'="" LogDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(LogDate)
			Set LogTime=objLog.LogTime
			Set:LogTime'="" LogTime=$zt(LogTime,1)
			Set LogUser=objLog.LogUser
			Set:LogUser'="" LogUser=$p($g(^SSU("SSUSR",LogUser)),"^",2)
			
			Set LogBarCode=objLog.LogBarCode
			If LogBarCode="" {
				Set BarCodeList(0)=$lb(StatusCode,StatusDesc,LogDate,LogTime,LogUser)
			} Else {
				Set LogSubIndex=+$e(LogBarCode,$l(LogBarCode)-1,$l(LogBarCode))
				Set BarCodeList(LogSubIndex)=$lb(StatusCode,StatusDesc,LogDate,LogTime,LogUser)
			}
		}
	}
	
	For indBar=1:1:SpecimenNum {
		Set BarCode=RepBarCode_$s($l(indBar)<2:"0"_indBar,1:indBar)
		
		Set (StatusCode,StatusDesc,LogDate,LogTime,LogUser)=""
		If $d(BarCodeList(indBar)) {
			Set BarInfo=$g(BarCodeList(indBar))
		} Else {
			Set BarInfo=$g(BarCodeList(0))
		}
		If BarInfo'="" {
			Set StatusCode=$list(BarInfo,1)
			Set StatusDesc=$list(BarInfo,2)
			Set LogDate=$list(BarInfo,3)
			Set LogTime=$list(BarInfo,4)
			Set LogUser=$list(BarInfo,5)
		}
		
		Set CurrFlag=(BarCode=aBarCode)
		
		Set Data=$lb(BarCode,StatusCode,StatusDesc,LogDate,LogTime,LogUser,CurrFlag)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryBarCodeStatusClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryBarCodeStatusExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryBarCodeStatusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryBarCodeStatusExecute ]
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
