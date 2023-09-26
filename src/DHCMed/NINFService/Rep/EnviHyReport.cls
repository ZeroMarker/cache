/// 名称: DHCMed.NINFService.Rep.EnviHyReport
/// 描述: 环境卫生学监测报告
/// 编写者：zhufei
/// 编写日期: 2012-08-17
Class DHCMed.NINFService.Rep.EnviHyReport Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2012-08-17
/// Description:  保存环境卫生学监测报告
/// Table：       DHCMed.NINF.Rep.EnviHyReport
/// Input：       报告ID^申请科室ID^检测项目ID^检测标准ID^检测对象^6检测日期^标本类型ID^标本数量^9申请人ID^状态码Code^备注^日志记录申请动作的执行科室——执行人
/// Return：      返回ID
/// w ##Class(DHCMed.NINFService.Rep.EnviHyReport).SaveRepRec("^117^1^1^阿道夫^2012-08-27^3292^3^9^1^备注^117/9","^,/")
ClassMethod SaveRepRec(aInput As %String, aSeparate As %String) As %String
{
	New (aInput,aSeparate)
	Set return=0
	Set $ZT="SaveRepRecErr"
	
	Set CHR1=$p(aSeparate,",",1)
	Set CHR2=$p(aSeparate,",",2)
	Quit:(CHR1="")||(CHR2="") return
	Set CtlDate=$p(aInput,CHR1,6)
	;Set:CtlDate["-" CtlDate=$zdh(CtlDate,3)
	Set:CtlDate'="" CtlDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(CtlDate)
	Set:CtlDate="" CtlDate=+$h
	Set ReportStatusCode=$p(aInput,CHR1,10)
	Set ReportStatusID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(ReportStatusCode,"NINFEnviHyReportStatus")
	Set LogStr=$p(aInput,CHR1,12)
	Set LogStr=LogStr_CHR2_ReportStatusID
	Set $p(aInput,CHR1,6)=CtlDate
	Set $p(aInput,CHR1,10)=ReportStatusID
	Set $p(aInput,CHR1,12)=LogStr
	Set return=##Class(DHCMed.NINF.Rep.EnviHyReport).Update(aInput,CHR1_","_CHR2)
	Quit return
	
SaveRepRecErr
	Quit -999
}

/// Creator：     zhufei
/// CreatDate：   2012-08-08
/// Description:  保存环境卫生学监测报告(只报告更新状态)
/// Table：       DHCMed.NINF.Rep.EnviHyReport
/// Input：       
/// Return：      返回ID
/// w ##Class(DHCMed.NINFService.Rep.EnviHyReport).SaveRepStatus("4^117^9^0^","^")
ClassMethod SaveRepStatus(aInput As %String, aSeparate As %String) As %String
{
	New (aInput,aSeparate)
	Set return=0
	Set $ZT="SaveRepStatusErr"
	
	Set RepordID=$p(aInput,aSeparate,1)
	Set LogLoc=$p(aInput,aSeparate,2)
	Set LogUser=$p(aInput,aSeparate,3)
	Set RepStatus=$p(aInput,aSeparate,4)
	Set RepStatusID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(RepStatus,"NINFEnviHyReportStatus")
	Set LogResume=$p(aInput,aSeparate,5)
	Set $p(aInput,aSeparate,4) = RepStatusID
	Set obj=##class(DHCMed.NINF.Rep.EnviHyReport).%OpenId(RepordID)
	Quit:'$IsObject(obj) return
	Set obj.EHRRepStatus=##class(DHCMed.SS.Dictionary).GetObjById(RepStatusID)
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
		
		Set inputStatus=obj.%Id()_"^"_LogLoc_"^"_LogUser_"^"_RepStatusID_"^"_""
		Set flg=##Class(DHCMed.NINF.Rep.EnviHyReportLog).Update(inputStatus,"^")
	}
	Do obj.%Close()
	
	Quit return
	
SaveRepStatusErr
	Quit -999
}

/// Creator：     zhufei
/// CreatDate：   2012-07-01
/// Description:  查询环境卫生学监测报告信息
/// Table：       DHCMed.NINF.Rep.EnviHyReport
/// Input:        
/// 用处：各个显示报告的查询页面
/// do ##class(%ResultSet).RunQuery("DHCMed.NINFService.Rep.EnviHyReport","QryEnviHyRep","2014-07","")
Query QryEnviHyRep(aDate As %String, aLoc As %String, aRepStatus As %String, aHospID As %String = "") As %Query(ROWSPEC = "ReportID:%String,AskForLocID:%String,AskForLocDesc:%String,AskForUserID:%String,AskForUserDesc:%String,ItemID:%String,ItemDesc:%String,NormID:%String,NormDesc:%String,NormMax:%String,NormMin:%String,NormRange:%String,ItemObj:%String,EHRDate:%String,SpecimenTypeID:%String,SpecimenTypeDesc:%String,SpecimenNum:%String,CenterNum:%String,SurroundNum:%String,SpecIssueNum:%String,SpecUnissueNum:%String,AddSpecimenNum:%String,EHRPathogens:%String,EHRResult:%String,UnfinishCount:%String,EHRAutoIsNorm:%String,EHRRepDate:%String,EHRRepTime:%String,EHRRepLocID:%String,EHRRepLocDesc:%String,EHRRepUserID:%String,EHRRepUserDesc:%String,RepStatusID:%String,RepStatusCode:%String,RepStatusDesc:%String,RepResume:%String,EHRBarCode:%String,EHICategID:%String,EHICategDesc:%String")
{
}

ClassMethod QryEnviHyRepExecute(ByRef qHandle As %Binary, aDate As %String, aLoc As %String, aRepStatus As %String, aHospID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set aRepStatus=$g(aRepStatus)
	
	Quit:aDate="" $$$OK
	Set aDateFrom=aDate_"-01"
	Set aDateFrom=$zdh(aDateFrom,3)
	Set aDateTo=aDateFrom+32
	Set aDateTo=$zd(aDateTo,3)
	Set aDateTo=$p(aDateTo,"-",1)_"-"_$p(aDateTo,"-",2)_"-01"
	Set aDateTo=$zdh(aDateTo,3)-1
	
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
			If aHospID'="" {
				Set flg=##class(DHCMed.SSService.HospitalSrv).CheckHospital(+xLoc,aHospID)
				Continue:flg<1
			}
			
			Set xId=0
			For {
				Set xId=$o(^DHCMed.NINFi("EnviRep",0,"IndexDateLoc",xDate,xLoc,xId))
				Quit:xId=""
				Set obj=##class(DHCMed.NINF.Rep.EnviHyReport).GetObjById(xId)
				Continue:'$IsObject(obj)
				
				Set (ReportID,AskForLocID ,AskForLocDesc,AskForUserID,AskForUserDesc)=""
				Set (ItemID,ItemDesc,NormID,NormDesc,NormMax,NormMin,NormRange,ItemObj,EHRDate)=""
				Set (SpecimenTypeID,SpecimenTypeDesc,SpecimenNum,CenterNum,SurroundNum,SpecIssueNum,SpecUnissueNum,AddSpecimenNum)=""
				Set (EHRPathogens,EHRResult,EHRAutoIsNorm,EHRRepDate,EHRRepTime,EHRRepLocID,EHRRepLocDesc,EHRRepUserID,EHRRepUserDesc)=""
				Set (RepStatusID,RepStatusCode,RepStatusDesc,RepResume,EHRBarCode,EHICategID,EHICategDesc)=""
				
				Set ReportID=obj.%Id()
				
				Set LocID=obj.EHRAskForLoc 				///申请科室				
				Set objLoc=##class(DHCMed.Base.Ctloc).GetObjById(LocID)
				If $IsObject(objLoc) {
					Set AskForLocID=objLoc.Rowid
					Set AskForLocDesc=objLoc.Descs
				}
				
				Set EHRAskForUserID =obj.EHRAskForUser  ///申请人
				Set EHRAskForUser=##class(DHCMed.Base.SSUser).GetObjById(EHRAskForUserID)
				If $IsObject(EHRAskForUser) {
					Set AskForUserID=EHRAskForUser.Rowid
					Set AskForUserDesc=EHRAskForUser.Name
				}
				
				If $IsObject(obj.EHRItem) {				/// 检测项目
					Set ItemID=obj.EHRItem.%Id()
					Set ItemDesc=obj.EHRItem.EHIDesc
					Set objEHICateg=obj.EHRItem.EHICateg
					if $IsObject(objEHICateg) {
						Set EHICategID=objEHICateg.%Id()
						Set EHICategDesc=objEHICateg.Description
					}					
				}
				
				set objNorm=obj.EnviHyNorm
				if $IsObject(objNorm) {
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
					if $Isobject(objSpecType){
						Set SpecimenTypeID=objSpecType.%Id()
						Set SpecimenTypeDesc=objSpecType.Description
					}
				}
				
				Set ItemObj=obj.EHRItemObj				/// 项目对象
				Set EHRDate=obj.EHRDate					/// 检测日期
				;Set:EHRDate'="" EHRDate=$zd(EHRDate,3)
				Set:EHRDate'="" EHRDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(EHRDate)
				
				Set SpecIssueNum = obj.SpecimenNum      /// 发放标本数量
				Set SpecIssueNum = +SpecIssueNum
				Set SpecUnissueNum = SpecimenNum-SpecIssueNum
				Set AddSpecimenNum = obj.AddSpecimenNum	/// 补发标本数量
				Set AddSpecimenNum = +AddSpecimenNum
				
				Set EHRResult = obj.EHRResult			/// 检测结果
				Set ResultCount=0
				For indRst=1:1:$l(EHRResult,",") {
					Set tmpResult=$p(EHRResult,",",indRst)
					Continue:tmpResult=""
					Set ResultCount=ResultCount+1
				}
				Set UnfinishCount=ResultCount-SpecimenNum
				
				Set EHRPathogens = obj.EHRPathogens
				Set EHRAutoIsNorm = obj.EHRAutoIsNorm	/// 合格/达标情况 自动判断
				Set EHRRepDate=obj.EHRRepDate
				;Set:EHRRepDate'="" EHRRepDate=$zd(EHRRepDate,3)
				Set:EHRRepDate'="" EHRRepDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(EHRRepDate)
				Set EHRRepTime=obj.EHRRepTime
				Set:EHRRepTime'="" EHRRepTime=$zt(EHRRepTime,1)
				
				Set RepLocID=obj.EHRRepLoc		///报告科室
				Set objRepLoc=##class(DHCMed.Base.Ctloc).GetObjById(RepLocID)
				If $IsObject(objRepLoc) {
					Set EHRRepLocID=objRepLoc.Rowid
					Set EHRRepLocDesc=objRepLoc.Descs
				}
				Set RepUserID=obj.EHRRepUser	///报告人
				Set objRepUser=##class(DHCMed.Base.SSUser).GetObjById(RepUserID)
				If $IsObject(objRepUser) {
					Set EHRRepUserID=objRepUser.Rowid
					Set EHRRepUserDesc=objRepUser.Name
				}
				If $IsObject(obj.EHRRepStatus) {///报告状态
					Set RepStatusID=obj.EHRRepStatus.%Id()
					Continue:(aRepStatus'="")&&(RepStatusID'=aRepStatus)
					Set RepStatusCode=obj.EHRRepStatus.Code
					Continue:RepStatusCode="0"
					Set RepStatusDesc=obj.EHRRepStatus.Description
				}
				Set EHRBarCode = obj.EHRBarCode
				Set RepResume=obj.EHRResume
				
				Set Data=$lb(ReportID,AskForLocID,AskForLocDesc,AskForUserID,AskForUserDesc)
				Set Data=Data_$lb(ItemID,ItemDesc,NormID,NormDesc,NormMax,NormMin,NormRange,ItemObj,EHRDate)
				Set Data=Data_$lb(SpecimenTypeID,SpecimenTypeDesc,SpecimenNum,CenterNum,SurroundNum,SpecIssueNum,SpecUnissueNum,AddSpecimenNum)
				Set Data=Data_$lb(EHRPathogens,EHRResult,UnfinishCount,EHRAutoIsNorm,EHRRepDate,EHRRepTime,EHRRepLocID,EHRRepLocDesc,EHRRepUserID,EHRRepUserDesc)
				Set Data=Data_$lb(RepStatusID,RepStatusCode,RepStatusDesc,RepResume,EHRBarCode,EHICategID,EHICategDesc)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
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

/// 这个Query根据监测日期时间段，可以返回所有报告及所有相关信息
/// 用处：统计工作量、复兴报告 form1 form2
/// do ##class(%ResultSet).RunQuery("DHCMed.NINFService.Rep.EnviHyReport","QryEnviHyForms","2014-03-17","2014-03-17")
Query QryEnviHyForms(FromDate As %String, ToDate As %String) As %Query(ROWSPEC = "ReportID:%String,AskForLocID:%String,AskForLocDesc:%String,AskForUserID:%String,AskForUserDesc:%String,EHRAskForDate:%String,EHRAskForTime:%String,ItemID:%String,ItemDesc:%String,NormID:%String,NormDesc:%String,NormMax:%String,NormMin:%String,NormRange:%String,ItemObj:%String,EHRDate:%String,SpecimenTypeID:%String,SpecimenTypeDesc:%String,SpecimenNum:%Integer,AddSpecimenNum:%String,EHRResult:%String,EHRAutoIsNorm:%String,EHRRepDate:%String,EHRRepTime:%String,EHRRepLocID:%String,EHRRepLocDesc:%String,EHRRepUserID:%String,EHRRepUserDesc:%String,RepResume:%String,EHRBarCode:%String,EHICategDesc:%String,TheAverage:%Float") [ SqlProc ]
{
}

ClassMethod QryEnviHyFormsExecute(ByRef qHandle As %Binary, FromDate As %String, ToDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set:FromDate["/" FromDate=$zdh(FromDate,4)
	Set:ToDate["/" ToDate=$zdh(ToDate,4)
	Set:FromDate["-" FromDate=$zdh(FromDate,3)
	Set:ToDate["-" ToDate=$zdh(ToDate,3)
	Quit:(FromDate="")||(ToDate="") $$$OK
	
	Set AnalysisNorm=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("NINF-EHAnalysisNorm","") 
	
	Set xDate=FromDate-1
	For {
		Set xDate=$o(^DHCMed.NINFi("EnviRep",0,"IndexDateLoc",xDate))
		Quit:xDate=""
		Quit:xDate>ToDate
		Set xLoc=""
		For {
			Set xLoc=$o(^DHCMed.NINFi("EnviRep",0,"IndexDateLoc",xDate,xLoc))
			Quit:xLoc=""
			Set xId=0
			For {
				Set xId=$o(^DHCMed.NINFi("EnviRep",0,"IndexDateLoc",xDate,xLoc,xId))
				Quit:xId=""
				Set obj=##class(DHCMed.NINF.Rep.EnviHyReport).GetObjById(xId)
				Continue:'$IsObject(obj)
				Continue:'$IsObject(obj.EHRRepStatus)
				//Continue:obj.EHRRepStatus.Code'="4"
				Continue:(+AnalysisNorm=0)&&(obj.EHRRepStatus.Code'="4")&&(obj.EHRRepStatus.Code'="5")
				Continue:(+AnalysisNorm=1)&&(obj.EHRRepStatus.Code'="5")
				
				Set (ReportID,AskForLocID ,AskForLocDesc,AskForUserID,AskForUserDesc,EHRAskForDate,EHRAskForTime,ItemID,ItemDesc,NormID,NormDesc,NormMax,NormMin,NormRange,ItemObj,EHRDate,SpecimenTypeID,SpecimenTypeDesc,SpecimenNum,AddSpecimenNum)=""
				Set (EHRResult,EHRAutoIsNorm,EHRRepDate,EHRRepTime,EHRRepLocID,EHRRepLocDesc,EHRRepUserID,EHRRepUserDesc)=""
				Set (RepResume,EHRBarCode,EHICategDesc,TheAverage)=""
				
				Set ReportID=obj.%Id()
				Set LocID=obj.EHRAskForLoc ///申请科室
				Set objLoc=##class(DHCMed.Base.Ctloc).GetObjById(LocID)
				If $IsObject(objLoc) {
					Set AskForLocID=objLoc.Rowid
					Set AskForLocDesc=objLoc.Descs
				}
				Set EHRAskForUserID =obj.EHRAskForUser  ///申请人
				Set EHRAskForUser=##class(DHCMed.Base.SSUser).GetObjById(EHRAskForUserID)
				If $IsObject(EHRAskForUser) {
					Set AskForUserID=EHRAskForUser.Rowid
					Set AskForUserDesc=EHRAskForUser.Name
				}
				Set EHRAskForDate=obj.EHRAskForDate
				Set:EHRAskForDate'="" EHRAskForDate=$zd(EHRAskForDate,3)
				Set EHRAskForTime=obj.EHRAskForTime
				Set:EHRAskForTime'="" EHRAskForTime=$zt(EHRAskForTime,1)
				If $IsObject(obj.EHRItem) {
					Set ItemID=obj.EHRItem.%Id()
					Set ItemDesc=obj.EHRItem.EHIDesc
					Set EHICateg=obj.EHRItem.EHICateg 
					If $IsObject(EHICateg) {
						Set EHICategID=EHICateg.%Id()
						Set EHICategDesc=EHICateg.Description
					}
				}
				If $IsObject(obj.EnviHyNorm) {
					Set NormID=obj.EnviHyNorm.%Id()
					Set NormDesc=obj.EnviHyNorm.EHNNorm
					Set NormMax=obj.EnviHyNorm.EHNNormMax
					Set NormMin=obj.EnviHyNorm.EHNNormMin
					Set NormRange=obj.EnviHyNorm.EHNRange
				}
				Set ItemObj=obj.EHRItemObj
				Set EHRDate=obj.EHRDate
				Set:EHRDate'="" EHRDate=$zd(EHRDate,3)
				If $IsObject(obj.SpecimenType) {
					Set SpecimenTypeID=obj.SpecimenType.%Id()
					Set SpecimenTypeDesc=obj.SpecimenType.Description
				}
				Set SpecimenNum = obj.SpecimenNum
				Set AddSpecimenNum = obj.AddSpecimenNum
				Set EHRResult = obj.EHRResult
				Set TheAverage = $translate(EHRResult,",","+")+0
				Set TheAverage = "Set TheAverage = "_TheAverage_"/"_SpecimenNum
				X TheAverage
				Set EHRAutoIsNorm = obj.EHRAutoIsNorm
				Set EHRRepDate=obj.EHRRepDate
				Set:EHRRepDate'="" EHRRepDate=$zd(EHRRepDate,3)
				Set EHRRepTime=obj.EHRRepTime
				Set:EHRRepTime'="" EHRRepTime=$zt(EHRRepTime,1)
				Set RepLocID=obj.EHRRepLoc
				Set objRepLoc=##class(DHCMed.Base.Ctloc).GetObjById(RepLocID)
				If $IsObject(objRepLoc) {
					Set EHRRepLocID=objRepLoc.Rowid
					Set EHRRepLocDesc=objRepLoc.Descs
				}
				Set RepUserID=obj.EHRRepUser
				Set objRepUser=##class(DHCMed.Base.SSUser).GetObjById(RepUserID)
				If $IsObject(objRepUser) {
					Set EHRRepUserID=objRepUser.Rowid
					Set EHRRepUserDesc=objRepUser.Name
				}
				Set EHRBarCode = obj.EHRBarCode
				Set RepResume=obj.EHRResume
				Set Data=$lb(ReportID,AskForLocID,AskForLocDesc,AskForUserID,AskForUserDesc,EHRAskForDate,EHRAskForTime,ItemID,ItemDesc,NormID,NormDesc,NormMax,NormMin,NormRange,ItemObj,EHRDate,SpecimenTypeID,SpecimenTypeDesc,SpecimenNum,AddSpecimenNum)
				Set Data=Data_$lb(EHRResult,EHRAutoIsNorm,EHRRepDate,EHRRepTime,EHRRepLocID,EHRRepLocDesc,EHRRepUserID,EHRRepUserDesc)
				Set Data=Data_$lb(RepResume,EHRBarCode,EHICategDesc,TheAverage)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	Quit $$$OK
}

ClassMethod QryEnviHyFormsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEnviHyFormsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryEnviHyFormsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryEnviHyFormsExecute ]
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

/// 百级洁净手术室对应报表
/// D ##class(%ResultSet).RunQuery("DHCMed.NINFService.Rep.EnviHyReport","QryEnviHyBaiJi","2014-03")
Query QryEnviHyBaiJi(aDate As %String) As %Query(ROWSPEC = "NormRange:%String,Center1:%Integer,Center2:%Integer ,Center3:%Integer,Center4:%Integer,Center5:%Integer,Around1:%Integer,Around2:%Integer,Around3:%Integer,Around4:%Integer,Around5:%Integer,Around6:%Integer,Around7:%Integer,Around8:%Integer,TheCompare:%Integer,EHRAutoIsNorm:%String") [ SqlProc ]
{
}

ClassMethod QryEnviHyBaiJiExecute(ByRef qHandle As %Binary, aDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:aDate="" $$$OK
 	Set xDateFrom=$e(aDate,1,7)_"-01"
 	Set xDateFrom=$zdh(xDateFrom,3)
 	Set xDateTo=xDateFrom+32
 	Set xDateTo=$zd(xDateTo,3)
 	Set xDateTo=$p(xDateTo,"-",1)_"-"_$p(xDateTo,"-",2)_"-01"
 	Set xDateTo=$zdh(xDateTo,3)-1 
 	
 	Set AnalysisNorm=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("NINF-EHAnalysisNorm","") 
 	
	Set RepDate = xDateFrom - 1
	for {
		Set RepDate=$o(^DHCMed.NINFi("EnviRep",0,"IndexDateLoc",RepDate))
		Quit:RepDate=""
		Quit:RepDate>xDateTo
		Set LocID = ""
		for {
			Set LocID = $o(^DHCMed.NINFi("EnviRep",0,"IndexDateLoc",RepDate,LocID))
			Quit:LocID=""
			Set xId=0
			For {
				Set xId=$o(^DHCMed.NINFi("EnviRep",0,"IndexDateLoc",RepDate,LocID,xId))
				Quit:xId=""
				Set obj=##class(DHCMed.NINF.Rep.EnviHyReport).GetObjById(xId)
				Continue:'$IsObject(obj)
				
				Continue:'$IsObject(obj.EHRRepStatus)
				Continue:(+AnalysisNorm=0)&&(obj.EHRRepStatus.Code'="4")&&(obj.EHRRepStatus.Code'="5")
				Continue:(+AnalysisNorm=1)&&(obj.EHRRepStatus.Code'="5")
				
				Set (NormRange,EHRAutoIsNorm)=""
				Set (Center1,Center2 ,Center3,Center4,Center5,TheCompare)=0
				Set (Around1,Around2,Around3,Around4,Around5,Around6,Around7,Around8)=0
			
				If $IsObject(obj.EHRItem) {
					Set ItemID=obj.EHRItem.%Id()
					Set ItemDesc=obj.EHRItem.EHIDesc
					Set objEHICateg=obj.EHRItem.EHICateg
					Continue:ItemDesc'="百级洁净手术室空气消毒效果监测"
				}
				If $IsObject(obj.EnviHyNorm) {
					Set NormID=obj.EnviHyNorm.%Id()
					Set NormDesc=obj.EnviHyNorm.EHNNorm
					Set NormMax=obj.EnviHyNorm.EHNNormMax
					Set NormMin=obj.EnviHyNorm.EHNNormMin
					Set NormRange=obj.EnviHyNorm.EHNRange
				}
				Set EHRAutoIsNorm = obj.EHRAutoIsNorm
				Set Center1 = $p(obj.EHRResult,",",1)
				Set Center2 = $p(obj.EHRResult,",",2)
				Set Center3 = $p(obj.EHRResult,",",3)
				Set Center4 = $p(obj.EHRResult,",",4)
				Set Center5 = $p(obj.EHRResult,",",5)
				Set Around1 = $p(obj.EHRResult,",",6)
				Set Around2 = $p(obj.EHRResult,",",7)
				Set Around3 = $p(obj.EHRResult,",",8)
				Set Around4 = $p(obj.EHRResult,",",9)
				Set Around5 = $p(obj.EHRResult,",",10)
				Set Around6 = $p(obj.EHRResult,",",11)
				Set Around7 = $p(obj.EHRResult,",",12)
				Set Around8 = $p(obj.EHRResult,",",13)
				Set TheCompare = $p(obj.EHRResult,",",14)
				Set Data=$lb(NormRange,Center1,Center2 ,Center3,Center4,Center5,Around1,Around2,Around3,Around4,Around5,Around6,Around7,Around8,TheCompare,EHRAutoIsNorm)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
		
			}	
		}
	}
	Quit $$$OK
}

ClassMethod QryEnviHyBaiJiFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryEnviHyBaiJiExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QryEnviHyBaiJiClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEnviHyBaiJiExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 千级洁净手术室对应报表
/// D ##class(%ResultSet).RunQuery("DHCMed.NINFService.Rep.EnviHyReport","QryEnviHyQianJi","2014-03")
Query QryEnviHyQianJi(aDate As %String) As %Query(ROWSPEC = "NormRange:%String,Center1:%Integer,Center2:%Integer ,Center3:%Integer,Around1:%Integer,Around2:%Integer,Around3:%Integer,Around4:%Integer,Around5:%Integer,Around6:%Integer,TheCompare:%Integer,EHRAutoIsNorm:%String") [ SqlProc ]
{
}

ClassMethod QryEnviHyQianJiExecute(ByRef qHandle As %Binary, aDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:aDate="" $$$OK
 	Set xDateFrom=$e(aDate,1,7)_"-01"
 	Set xDateFrom=$zdh(xDateFrom,3)
 	Set xDateTo=xDateFrom+32
 	Set xDateTo=$zd(xDateTo,3)
 	Set xDateTo=$p(xDateTo,"-",1)_"-"_$p(xDateTo,"-",2)_"-01"
 	Set xDateTo=$zdh(xDateTo,3)-1 
 	
 	Set AnalysisNorm=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("NINF-EHAnalysisNorm","") 
 	
	Set RepDate = xDateFrom - 1
	for {
		Set RepDate=$o(^DHCMed.NINFi("EnviRep",0,"IndexDateLoc",RepDate))
		Quit:RepDate=""
		Quit:RepDate>xDateTo
		Set LocID = ""
		for {
			Set LocID = $o(^DHCMed.NINFi("EnviRep",0,"IndexDateLoc",RepDate,LocID))
			Quit:LocID=""
			Set xId=0
			For {
				Set xId=$o(^DHCMed.NINFi("EnviRep",0,"IndexDateLoc",RepDate,LocID,xId))
				Quit:xId=""
				Set obj=##class(DHCMed.NINF.Rep.EnviHyReport).GetObjById(xId)
				Continue:'$IsObject(obj)
				Continue:'$IsObject(obj.EHRRepStatus)
				Continue:(+AnalysisNorm=0)&&(obj.EHRRepStatus.Code'="4")&&(obj.EHRRepStatus.Code'="5")
				Continue:(+AnalysisNorm=1)&&(obj.EHRRepStatus.Code'="5")
				
				Set (NormRange,EHRAutoIsNorm)=""
				Set (Center1,Center2 ,Center3,TheCompare)=0
				Set (Around1,Around2,Around3,Around4,Around5,Around6)=0
			
				If $IsObject(obj.EHRItem) {
					Set ItemID=obj.EHRItem.%Id()
					Set ItemDesc=obj.EHRItem.EHIDesc
					Set objEHICateg=obj.EHRItem.EHICateg
					Continue:ItemDesc'="千级洁净手术室空气消毒效果监测"
				}
				If $IsObject(obj.EnviHyNorm) {
					Set NormID=obj.EnviHyNorm.%Id()
					Set NormDesc=obj.EnviHyNorm.EHNNorm
					Set NormMax=obj.EnviHyNorm.EHNNormMax
					Set NormMin=obj.EnviHyNorm.EHNNormMin
					Set NormRange=obj.EnviHyNorm.EHNRange
				}
				Set EHRAutoIsNorm = obj.EHRAutoIsNorm
				Set Center1 = $p(obj.EHRResult,",",1)
				Set Center2 = $p(obj.EHRResult,",",2)
				Set Center3 = $p(obj.EHRResult,",",3)
				Set Around1 = $p(obj.EHRResult,",",4)
				Set Around2 = $p(obj.EHRResult,",",5)
				Set Around3 = $p(obj.EHRResult,",",6)
				Set Around4 = $p(obj.EHRResult,",",7)
				Set Around5 = $p(obj.EHRResult,",",8)
				Set Around6 = $p(obj.EHRResult,",",9)
				Set TheCompare = $p(obj.EHRResult,",",10)
				Set Data=$lb(NormRange,Center1,Center2 ,Center3,Around1,Around2,Around3,Around4,Around5,Around6,TheCompare,EHRAutoIsNorm)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
		
			}	
		}
	}
	Quit $$$OK
}

ClassMethod QryEnviHyQianJiFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryEnviHyQianJiExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QryEnviHyQianJiClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEnviHyQianJiExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 万级洁净手术室对应报表
/// D ##class(%ResultSet).RunQuery("DHCMed.NINFService.Rep.EnviHyReport","QryEnviHyWanJi","2014-03")
Query QryEnviHyWanJi(aDate As %String) As %Query(ROWSPEC = "NormRange:%String,Center1:%Integer,Center2:%Integer ,Center3:%Integer,Around1:%Integer,Around2:%Integer,Around3:%Integer,Around4:%Integer,TheCompare:%Integer,EHRAutoIsNorm:%String") [ SqlProc ]
{
}

ClassMethod QryEnviHyWanJiExecute(ByRef qHandle As %Binary, aDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:aDate="" $$$OK
 	Set xDateFrom=$e(aDate,1,7)_"-01"
 	Set xDateFrom=$zdh(xDateFrom,3)
 	Set xDateTo=xDateFrom+32
 	Set xDateTo=$zd(xDateTo,3)
 	Set xDateTo=$p(xDateTo,"-",1)_"-"_$p(xDateTo,"-",2)_"-01"
 	Set xDateTo=$zdh(xDateTo,3)-1 
 	
 	Set AnalysisNorm=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("NINF-EHAnalysisNorm","")
 	
	Set RepDate = xDateFrom - 1
	for {
		Set RepDate=$o(^DHCMed.NINFi("EnviRep",0,"IndexDateLoc",RepDate))
		Quit:RepDate=""
		Quit:RepDate>xDateTo
		Set LocID = ""
		for {
			Set LocID = $o(^DHCMed.NINFi("EnviRep",0,"IndexDateLoc",RepDate,LocID))
			Quit:LocID=""
			Set xId=0
			For {
				Set xId=$o(^DHCMed.NINFi("EnviRep",0,"IndexDateLoc",RepDate,LocID,xId))
				Quit:xId=""
				Set obj=##class(DHCMed.NINF.Rep.EnviHyReport).GetObjById(xId)
				Continue:'$IsObject(obj)
				Continue:'$IsObject(obj.EHRRepStatus)
				Continue:(+AnalysisNorm=0)&&(obj.EHRRepStatus.Code'="4")&&(obj.EHRRepStatus.Code'="5")
				Continue:(+AnalysisNorm=1)&&(obj.EHRRepStatus.Code'="5")
				
				Set (NormRange,EHRAutoIsNorm)=""
				Set (Center1,Center2 ,Center3,TheCompare)=0
				Set (Around1,Around2,Around3,Around4)=0
			
				If $IsObject(obj.EHRItem) {
					Set ItemID=obj.EHRItem.%Id()
					Set ItemDesc=obj.EHRItem.EHIDesc
					Set objEHICateg=obj.EHRItem.EHICateg
					Continue:ItemDesc'="万级洁净手术室空气消毒效果监测"
				}
				If $IsObject(obj.EnviHyNorm) {
					Set NormID=obj.EnviHyNorm.%Id()
					Set NormDesc=obj.EnviHyNorm.EHNNorm
					Set NormMax=obj.EnviHyNorm.EHNNormMax
					Set NormMin=obj.EnviHyNorm.EHNNormMin
					Set NormRange=obj.EnviHyNorm.EHNRange
				}
				Set EHRAutoIsNorm = obj.EHRAutoIsNorm
				Set Center1 = $p(obj.EHRResult,",",1)
				Set Center2 = $p(obj.EHRResult,",",2)
				Set Center3 = $p(obj.EHRResult,",",3)
				Set Around1 = $p(obj.EHRResult,",",4)
				Set Around2 = $p(obj.EHRResult,",",5)
				Set Around3 = $p(obj.EHRResult,",",6)
				Set Around4 = $p(obj.EHRResult,",",7)
				Set TheCompare = $p(obj.EHRResult,",",8)
				Set Data=$lb(NormRange,Center1,Center2 ,Center3,Around1,Around2,Around3,Around4,TheCompare,EHRAutoIsNorm)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
		
			}	
		}
	}
	Quit $$$OK
}

ClassMethod QryEnviHyWanJiFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryEnviHyWanJiExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QryEnviHyWanJiClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEnviHyWanJiExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 按科室统计报告【空气】
/// do ##class(%ResultSet).RunQuery("DHCMed.NINFService.Rep.EnviHyReport","QryEnviHyLocRep","2014")
Query QryEnviHyLocRep(aDate As %String) As %Query(ROWSPEC = "AskForLocDesc:%String,theDate:%String,NormRange:%String,CenterAvg:%Float,RoundAvg:%Float,NormMax:%Float,NormMin:%Float") [ SqlProc ]
{
}

ClassMethod QryEnviHyLocRepExecute(ByRef qHandle As %Binary, aDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:aDate="" $$$OK
	Set aDateFrom=aDate_"-01"_"-01"
	Set aDateTo=($p(aDateFrom,"-",1)+1)_"-"_$p(aDateFrom,"-",2)_"-01"
	Set aDateTo=$zdh(aDateTo,3)-1
	Set aDateFrom=$zdh(aDateFrom,3)
	Set xDate=aDateFrom-1
	
	Set AnalysisNorm=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("NINF-EHAnalysisNorm","")
	
	/*
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:aDate="" $$$OK
	Set aDateFrom=aDate_"-01"
	Set aDateFrom=$zdh(aDateFrom,3)
	Set aDateTo=aDateFrom+32
	Set aDateTo=$zd(aDateTo,3)
	Set aDateTo=$p(aDateTo,"-",1)_"-"_$p(aDateTo,"-",2)_"-01"
	Set aDateTo=$zdh(aDateTo,3)-1
	Set xDate=aDateFrom-1
	*/
	For {
		Set xDate=$o(^DHCMed.NINFi("EnviRep",0,"IndexDateLoc",xDate))
		Quit:xDate=""
		Quit:xDate>aDateTo
		
		Set xLoc=""
		For {
			Set xLoc=$o(^DHCMed.NINFi("EnviRep",0,"IndexDateLoc",xDate,xLoc))
			Quit:xLoc=""
			//Continue:(aLoc'="")&&(xLoc'=aLoc)
			Set xId=0
			For {
				Set xId=$o(^DHCMed.NINFi("EnviRep",0,"IndexDateLoc",xDate,xLoc,xId))
				Quit:xId=""
				Set obj=##class(DHCMed.NINF.Rep.EnviHyReport).GetObjById(xId)
				Continue:'$IsObject(obj)
				
				If $IsObject(obj.EHRRepStatus) {
					Set RepStatusID=obj.EHRRepStatus.%Id()
					Set RepStatusCode=obj.EHRRepStatus.Code
					//Continue:RepStatusCode'="4"
					Continue:(+AnalysisNorm=0)&&(RepStatusCode'="4")&&(RepStatusCode'="5")
					Continue:(+AnalysisNorm=1)&&(RepStatusCode'="5")
					Set RepStatusDesc=obj.EHRRepStatus.Description
				}
				Set (AskForLocDesc,NormRange)=""
				Set (CenterAvg,RoundAvg,NormMax,NormMin)=0
				
				Set ReportID=obj.%Id()
				Set LocID=obj.EHRAskForLoc ///申请科室
				Set objLoc=##class(DHCMed.Base.Ctloc).GetObjById(LocID)
				If $IsObject(objLoc) {
					Set AskForLocID=objLoc.Rowid
					Set AskForLocDesc=objLoc.Descs
				}
				
				/*
				Set EHRAskForUserID =obj.EHRAskForUser  ///申请人
				Set EHRAskForUser=##class(DHCMed.Base.SSUser).GetObjById(EHRAskForUserID)
				If $IsObject(EHRAskForUser) {
					Set AskForUserID=EHRAskForUser.Rowid
					Set AskForUserDesc=EHRAskForUser.Name
				}
				*/
				If $IsObject(obj.EHRItem) {
					Set ItemID=obj.EHRItem.%Id()
					Set ItemDesc=obj.EHRItem.EHIDesc
					Set objEHICateg=obj.EHRItem.EHICateg
					if $IsObject(objEHICateg) {
						Set EHICategID=objEHICateg.%Id()
						Set EHICategDesc=objEHICateg.Description
					}
					
				}
				If $IsObject(obj.EnviHyNorm) {
					Set NormID=obj.EnviHyNorm.%Id()
					Set NormDesc=obj.EnviHyNorm.EHNNorm
					Set NormMax=obj.EnviHyNorm.EHNNormMax
					Set NormMin=obj.EnviHyNorm.EHNNormMin
					Set NormRange=obj.EnviHyNorm.EHNRange
				}
				Set EHRResult = obj.EHRResult
				if (ItemDesc="百级洁净手术室空气消毒效果监测") {
					Set EHRResult1 = $p(obj.EHRResult,",",1)
					Set EHRResult2 = $p(obj.EHRResult,",",2)
					Set EHRResult3 = $p(obj.EHRResult,",",3)
					Set EHRResult4 = $p(obj.EHRResult,",",4)
					Set EHRResult5 = $p(obj.EHRResult,",",5)
					Set EHRResult6 = $p(obj.EHRResult,",",6)
					Set EHRResult7 = $p(obj.EHRResult,",",7)
					Set EHRResult8 = $p(obj.EHRResult,",",8)
					Set EHRResult9 = $p(obj.EHRResult,",",9)
					Set EHRResult10 = $p(obj.EHRResult,",",10)
					Set EHRResult11 = $p(obj.EHRResult,",",11)
					Set EHRResult12 = $p(obj.EHRResult,",",12)
					Set EHRResult13 = $p(obj.EHRResult,",",13)
					Set CenterAvg = (EHRResult1+EHRResult2+EHRResult3+EHRResult4+EHRResult5)/5
					Set RoundAvg = (EHRResult6+EHRResult7+EHRResult8+EHRResult9+EHRResult10+EHRResult11+EHRResult12+EHRResult13)/8
				}
				if (ItemDesc="千级洁净手术室空气消毒效果监测") {
					Set EHRResult1 = $p(obj.EHRResult,",",1)
					Set EHRResult2 = $p(obj.EHRResult,",",2)
					Set EHRResult3 = $p(obj.EHRResult,",",3)
					Set EHRResult4 = $p(obj.EHRResult,",",4)
					Set EHRResult5 = $p(obj.EHRResult,",",5)
					Set EHRResult6 = $p(obj.EHRResult,",",6)
					Set EHRResult7 = $p(obj.EHRResult,",",7)
					Set EHRResult8 = $p(obj.EHRResult,",",8)
					Set EHRResult9 = $p(obj.EHRResult,",",9)
					Set CenterAvg = (EHRResult1+EHRResult2+EHRResult3)/3
					Set RoundAvg = (EHRResult4+EHRResult5+EHRResult6+EHRResult7+EHRResult8+EHRResult9)/6
				}
				if (ItemDesc="万级洁净手术室空气消毒效果监测") {
					Set EHRResult1 = $p(obj.EHRResult,",",1)
					Set EHRResult2 = $p(obj.EHRResult,",",2)
					Set EHRResult3 = $p(obj.EHRResult,",",3)
					Set EHRResult4 = $p(obj.EHRResult,",",4)
					Set EHRResult5 = $p(obj.EHRResult,",",5)
					Set EHRResult6 = $p(obj.EHRResult,",",6)
					Set EHRResult7 = $p(obj.EHRResult,",",7)
					Set CenterAvg = (EHRResult1+EHRResult2+EHRResult3)/3
					Set RoundAvg = (EHRResult4+EHRResult5+EHRResult6+EHRResult7)/4
				}
				if (ItemDesc["重点科室≧30m2房间空气消毒效果监测") {
					Set EHRResult1 = $p(obj.EHRResult,",",1)
					Set EHRResult2 = $p(obj.EHRResult,",",2)
					Set EHRResult3 = $p(obj.EHRResult,",",3)
					Set EHRResult4 = $p(obj.EHRResult,",",4)
					Set EHRResult5 = $p(obj.EHRResult,",",5)
					Set CenterAvg = (EHRResult1+EHRResult2+EHRResult3+EHRResult4+EHRResult5)/5
					Set RoundAvg = (EHRResult1+EHRResult2+EHRResult3+EHRResult4+EHRResult5)/5
				}
				if (ItemDesc["重点科室﹤30m2房间空气消毒效果监测") {
					Set EHRResult1 = $p(obj.EHRResult,",",1)
					Set EHRResult2 = $p(obj.EHRResult,",",2)
					Set EHRResult3 = $p(obj.EHRResult,",",3)
					Set CenterAvg = (EHRResult1+EHRResult2+EHRResult3)/3
					Set RoundAvg = (EHRResult1+EHRResult2+EHRResult3)/3
				}
				if (ItemDesc["卫生手消毒效果监测") {
					Set EHRResult1 = $p(obj.EHRResult,",",1)
					Set CenterAvg = EHRResult1
					Set RoundAvg = EHRResult1
					Continue
				}
				if (ItemDesc["外科手消毒效果监测") {
					Set EHRResult1 = $p(obj.EHRResult,",",1)
					Set CenterAvg = EHRResult1
					Set RoundAvg = EHRResult1
					Continue
				}
				if (ItemDesc["重点科室物体表面洁净度监测") {
					Set EHRResult1 = $p(obj.EHRResult,",",1)
					Set CenterAvg = EHRResult1
					Set RoundAvg = EHRResult1
					Continue
				}
				if (ItemDesc["非重点科室物体表面洁净度监测") {
					Set EHRResult1 = $p(obj.EHRResult,",",1)
					Set CenterAvg = EHRResult1
					Set RoundAvg = EHRResult1
					Continue
				}
				/*
				Set ItemObj=obj.EHRItemObj
				Set EHRDate=obj.EHRDate
				Set:EHRDate'="" EHRDate=$zd(EHRDate,3)
				If $IsObject(obj.SpecimenType) {
					Set SpecimenTypeID=obj.SpecimenType.%Id()
					Set SpecimenTypeDesc=obj.SpecimenType.Description
				}
				Set SpecimenNum = obj.SpecimenNum
				Set AddSpecimenNum = obj.AddSpecimenNum
				Set EHRAutoIsNorm = obj.EHRAutoIsNorm
				Set EHRRepDate=obj.EHRRepDate
				Set:EHRRepDate'="" EHRRepDate=$zd(EHRRepDate,3)
				Set EHRRepTime=obj.EHRRepTime
				Set:EHRRepTime'="" EHRRepTime=$zt(EHRRepTime,1)
				Set RepLocID=obj.EHRRepLoc
				Set objRepLoc=##class(DHCMed.Base.Ctloc).GetObjById(RepLocID)
				If $IsObject(objRepLoc) {
					Set EHRRepLocID=objRepLoc.Rowid
					Set EHRRepLocDesc=objRepLoc.Descs
				}
				Set RepUserID=obj.EHRRepUser
				Set objRepUser=##class(DHCMed.Base.SSUser).GetObjById(RepUserID)
				If $IsObject(objRepUser) {
					Set EHRRepUserID=objRepUser.Rowid
					Set EHRRepUserDesc=objRepUser.Name
				}
				If $IsObject(obj.EHRRepStatus) {
					Set RepStatusID=obj.EHRRepStatus.%Id()
					Set RepStatusCode=obj.EHRRepStatus.Code
					Continue:RepStatusCode="0"
					Set RepStatusDesc=obj.EHRRepStatus.Description
				}
				Set EHRBarCode = obj.EHRBarCode
				Set RepResume=obj.EHRResume
				*/
				Set theDate=$zd(xDate,3)
				Set theDate=$e(theDate,1,7)
				Set Data=$lb(AskForLocDesc,theDate,NormRange,CenterAvg,RoundAvg,NormMax,NormMin)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	Quit $$$OK
}

ClassMethod QryEnviHyLocRepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryEnviHyLocRepExecute ]
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

ClassMethod QryEnviHyLocRepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEnviHyLocRepExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 按科室统计报告【医护人员和物体表面】
/// do ##class(%ResultSet).RunQuery("DHCMed.NINFService.Rep.EnviHyReport","QryEnviHyLocOrtherRep","2014")
Query QryEnviHyLocOrtherRep(aDate As %String) As %Query(ROWSPEC = "AskForLocDesc:%String,theDate:%String,ItemDesc:%String,ResultFlag:%Float,NormMin:%Float") [ SqlProc ]
{
}

ClassMethod QryEnviHyLocOrtherRepExecute(ByRef qHandle As %Binary, aDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:aDate="" $$$OK
	Set aDateFrom=aDate_"-01"_"-01"
	Set aDateTo=($p(aDateFrom,"-",1)+1)_"-"_$p(aDateFrom,"-",2)_"-01"
	Set aDateTo=$zdh(aDateTo,3)-1
	Set aDateFrom=$zdh(aDateFrom,3)
	
	Set AnalysisNorm=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("NINF-EHAnalysisNorm","")
	
	Set xDate=aDateFrom-1
	For {
		Set xDate=$o(^DHCMed.NINFi("EnviRep",0,"IndexDateLoc",xDate))
		Quit:xDate=""
		Quit:xDate>aDateTo
		
		Set xLoc=""
		For {
			Set xLoc=$o(^DHCMed.NINFi("EnviRep",0,"IndexDateLoc",xDate,xLoc))
			Quit:xLoc=""
			Set xId=0
			For {
				Set xId=$o(^DHCMed.NINFi("EnviRep",0,"IndexDateLoc",xDate,xLoc,xId))
				Quit:xId=""
				Set obj=##class(DHCMed.NINF.Rep.EnviHyReport).GetObjById(xId)
				Continue:'$IsObject(obj)
				
				If $IsObject(obj.EHRRepStatus) {
					Set RepStatusID=obj.EHRRepStatus.%Id()
					Set RepStatusCode=obj.EHRRepStatus.Code
					//Continue:RepStatusCode'="4"
					Continue:(+AnalysisNorm=0)&&(RepStatusCode'="4")&&(RepStatusCode'="5")
					Continue:(+AnalysisNorm=1)&&(RepStatusCode'="5")

					Set RepStatusDesc=obj.EHRRepStatus.Description
				}
				Set (AskForLocDesc,ItemDesc)=""
				Set (ResultFlag,NormMin)=0
				
				Set ReportID=obj.%Id()
				Set LocID=obj.EHRAskForLoc ///申请科室
				Set objLoc=##class(DHCMed.Base.Ctloc).GetObjById(LocID)
				If $IsObject(objLoc) {
					Set AskForLocID=objLoc.Rowid
					Set AskForLocDesc=objLoc.Descs
				}
				If $IsObject(obj.EHRItem) {
					Set ItemID=obj.EHRItem.%Id()
					Set ItemDesc=obj.EHRItem.EHIDesc
					Set objEHICateg=obj.EHRItem.EHICateg
					if $IsObject(objEHICateg) {
						Set EHICategID=objEHICateg.%Id()
						Set EHICategDesc=objEHICateg.Description
					}
					
				}
				If $IsObject(obj.EnviHyNorm) {
					Set NormID=obj.EnviHyNorm.%Id()
					Set NormDesc=obj.EnviHyNorm.EHNNorm
					Set NormMax=obj.EnviHyNorm.EHNNormMax
					Set NormMin=obj.EnviHyNorm.EHNNormMin
					Set NormRange=obj.EnviHyNorm.EHNRange
				}
				Set EHRResult = obj.EHRResult
				Set EHRResult1 = 0
				if (ItemDesc["卫生手消毒效果监测") {
					Set EHRResult1 = $p(obj.EHRResult,",",1)
				} elseif (ItemDesc["外科手消毒效果监测") {
					Set EHRResult1 = $p(obj.EHRResult,",",1)
				} elseif (ItemDesc["重点科室物体表面洁净度监测") {
					Set EHRResult1 = $p(obj.EHRResult,",",1)
				} elseif (ItemDesc["非重点科室物体表面洁净度监测") {
					Set EHRResult1 = $p(obj.EHRResult,",",1)
				} else {
					continue	
				}
				if (EHRResult1<NormMax) {
					Set ResultFlag = 1
				} else {
					Set ResultFlag = 0
				}
				Set theDate=$zd(xDate,3)
				Set theDate=$e(theDate,1,7)
				Set Data=$lb(AskForLocDesc,theDate,ItemDesc,ResultFlag,NormMin)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	Quit $$$OK
}

ClassMethod QryEnviHyLocOrtherRepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryEnviHyLocOrtherRepExecute ]
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

ClassMethod QryEnviHyLocOrtherRepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEnviHyLocOrtherRepExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
