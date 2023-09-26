Class DHCMed.FBDService.StatofReportCases Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator: chenrui
/// CreateDate: 2023-02-14
/// Description:  食源性疾病报告统计
/// Table：       DHCMed.FBD.Report
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCMed.FBDService.StatofReportCases","QryReprotCases","2","2022-01-01","2023-02-14")
Query QryReprotCases(aHospIDs As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "LocID:%String,AdmLoc:%String,UserID:%String,RepUserName:%String,UserNum:%Integer") [ SqlProc ]
{
}

ClassMethod QryReprotCasesExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom = ##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateFrom)
	Set aDateTo   = ##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
 	
    Set:aHospIDs'="" aHospIDs=","_aHospIDs_","
    
	Set NIndex="QryReprotCases"
	k ^TMP($zn,$j,NIndex)
	
	For xDate=aDateFrom:1:aDateTo{
		
		Set xTime=""
		For{
			Set xTime=$o(^DHCMed.FBD.ReportI("IndexReportDate",xDate,xTime))
			Quit:xTime=""
			Set xRepID = ""
			For{
				Set xRepID=$o(^DHCMed.FBD.ReportI("IndexReportDate",xDate,xTime,xRepID))
				Quit:xRepID=""
				Set RepInfo = $g(^DHCMed.FBD.ReportD(xRepID))
				Set FRReportLoc = $lg(RepInfo,30)
				Set HospID=$p(^CTLOC(FRReportLoc),"^",22)
				Continue:(aHospIDs'="")&&(aHospIDs'[(","_HospID_","))
				Set StatusID = $lg(RepInfo,6)
				Set StatusDesc = $lg($g(^DHCMed.SS.DictionaryD(StatusID)),4)
				Continue:((StatusDesc="")||(StatusDesc="作废"))
				Set RepUser = $lg(RepInfo,31)
				Set ^TMP($zn,$j,NIndex,"Loc",FRReportLoc,"Doc",RepUser,"Rep",xRepID)=""
				Set Num=+$g(^TMP($zn,$j,NIndex,"Loc",FRReportLoc,"Doc",RepUser,"Rep"))
				Set ^TMP($zn,$j,NIndex,"Loc",FRReportLoc,"Doc",RepUser,"Rep")=Num+1
			}
		}
	}
	Set tLocID=""
	For{
		Set tLocID=$o(^TMP($zn,$j,NIndex,"Loc",tLocID))
		Quit:tLocID=""
		
		Set AdmLoc=$p(^CTLOC(tLocID),"^",2)
		Set:AdmLoc["-" AdmLoc=$p(AdmLoc,"-",2)

		Set xUser=""
		For{
			Set xUser=$o(^TMP($zn,$j,NIndex,"Loc",tLocID,"Doc",xUser))
			Quit:xUser=""
			
			Set objRepUser=##class(DHCMed.Base.SSUser).GetObjById(xUser)
			If $IsObject(objRepUser){
				Set RepUserName=objRepUser.Name
			}
			Set UserNum=+$g(^TMP($zn,$j,NIndex,"Loc",tLocID,"Doc",xUser,"Rep"))
			
			Set Data=$lb(tLocID,AdmLoc,xUser,RepUserName,UserNum)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}	
	}

	Quit $$$OK
}

ClassMethod QryReprotCasesClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryReprotCasesExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryReprotCasesFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryReprotCasesExecute ]
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

///  d ##class(%ResultSet).RunQuery("DHCMed.FBDService.StatofReportCases","QueryRepDtlByDate","2022-01-01","2023-02-14","","","2")
Query QueryRepDtlByDate(FromDate As %String, ToDate As %String, Loc As %String, Doc As %String, Hosp As %String) As %Query(ROWSPEC = "ind:%String,RowID:%String,PatientID:%String,RegNo:%String:登记号,PatientName:%String:患者姓名,Sex:%String:姓别,Age:%String:年龄,CateDesc:%String:疾病分类,DiseaseDesc:%String:疾病名称,ReportDep:%String:上报科室,RepUserName:%String:上报人姓名,RepDate:%String:上报日期,RepTime:%String:上报时间,Status:%String:状态,Paadm:%String,CheckUserName:%String,CheckDate:%String,CheckTime:%String") [ SqlProc ]
{
}

ClassMethod QueryRepDtlByDateExecute(ByRef qHandle As %Binary, FromDate As %String, ToDate As %String, Loc As %String, Doc As %String, Hosp As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(FromDate="")||(ToDate="") $$$OK
	Set FromDate = ##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(FromDate)
	Set ToDate   = ##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(ToDate)
	Quit:((FromDate="")||(ToDate="")) $$$OK


	For xDate=FromDate:1:ToDate{
		Set xTime=""
		For{
			Set xTime=$o(^DHCMed.FBD.ReportI("IndexReportDate",xDate,xTime))
			Quit:xTime=""
			Set xRepID = ""
			For{
				Set xRepID=$o(^DHCMed.FBD.ReportI("IndexReportDate",xDate,xTime,xRepID))
				Quit:xRepID=""
				Set RepInfo = $g(^DHCMed.FBD.ReportD(xRepID))
				Set FRReportLoc = $lg(RepInfo,30)
				Set HospID=$p(^CTLOC(FRReportLoc),"^",22)
				If (Loc'=""){
					Continue:(FRReportLoc'=Loc)
				}ElseIf(Hosp'=""){
					set flg=##class(DHCMed.SSService.HospitalSrv).CheckHospital(FRReportLoc,Hosp)
					continue:flg<1
				}
				Set StatusID = $lg(RepInfo,6)
				Set StatusDesc = $lg($g(^DHCMed.SS.DictionaryD(StatusID)),4)
				Continue:((StatusDesc="")||(StatusDesc="作废"))
				Set tmpData=..BuildData(ind,xRepID)
				Set ^CacheTemp(repid,ind)=tmpData
				Set ind=ind+1
			}
		}
	}	
	Quit $$$OK
}

ClassMethod QueryRepDtlByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryRepDtlByDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryRepDtlByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryRepDtlByDateExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	// if there are no more rows, finish fetching
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	// fetch row
 	Else {
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod BuildData(ind, RepID) As %List
{
	New (ind,RepID)
	Set return=""
	
	Set (PatientID,EpisodeID,PapmiNo,PatientName,PatientSex,AdmDate,AdmitTime,PatientAge,DiseaseDesc,CateID,CateDesc,RepLoc,RepUserCode,RepUserName,RepDate,RepTime,StatusDesc,CheckDate,CheckTime,CheckUserCode,CheckUserName) = ""
	
	Set RepInfo = $g(^DHCMed.FBD.ReportD(RepID))
	Set EpisodeID = $lg(RepInfo,2)	//EpisodeID
	Set PatientID = $lg(RepInfo,3)	//PatientID
	Set objPatient=##class(DHCMed.Base.Patient).GetObjById(PatientID)
	If $IsObject(objPatient){
		Set PapmiNo=objPatient.PapmiNo              //登记号
		Set PatientName=objPatient.PatientName      //姓名
		Set PatientSex=objPatient.Sex               //性别
		//统一调用年龄计算方法
		//upadte by pylian 2016-02-18 修改入院时间取值方式
    	Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(EpisodeID)
		Set AdmDate=$p(AdmDateTime,"^",1)
		Set AdmitTime=$p(AdmDateTime,"^",2)
		Set:AdmDate'="" AdmDate=$zd(AdmDate,3)
		Set:AdmitTime'="" AdmitTime=$zt(AdmitTime,2)
		Set PatientAge=##class(DHCMed.SSIO.FromHisSrv).GetPapmiAge(PatientID,EpisodeID,AdmDate,AdmitTime)
	}
	Set DiseaseDr = $lg(RepInfo,4)	// DiseaseDr
	if (DiseaseDr'=""){
		Set DiseaseDesc = $lg(^DHCMed.SS.DiseaseD(DiseaseDr),3)
		Set CateID = $lg(^DHCMed.SS.DiseaseD(DiseaseDr),5)
		Set:CateID'="" CateDesc = $lg(^DHCMed.SS.DictionaryD(CateID),4)
	}
	Set RepLoc	=$lg(RepInfo,30)	                     //报告科室
	Set objRepLoc=##class(DHCMed.Base.Ctloc).GetObjById(RepLoc)
	If $IsObject(objRepLoc){
		Set RepLoc=objRepLoc.Descs
	}
	
	Set RepUser	= $lg(RepInfo,31)                		 //报告人
	Set objRepUser=##class(DHCMed.Base.SSUser).GetObjById(RepUser)
	If $IsObject(objRepUser){
		Set RepUserCode=objRepUser.Code
		Set RepUserName=objRepUser.Name
	}
	Set RepDate = $lg(RepInfo,32)                  //报告日期
	Set:RepDate'="" RepDate = ##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(RepDate)
	Set RepTime = $lg(RepInfo,33)                  //报告时间
	Set:RepTime'="" RepTime = ##Class(DHCMed.SSService.CommonCls).ChangeTimeFormat(RepTime)
	Set RepStatus=$lg(RepInfo,6)                 //报告状态
	Set:RepStatus'="" StatusDesc = $lg($g(^DHCMed.SS.DictionaryD(RepStatus)),4)
	Set CheckDate=$lg(RepInfo,35)               //审核日期
	Set:CheckDate'="" CheckDate = ##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(CheckDate)
	Set CheckTime=$lg(RepInfo,36)               //审核时间
	Set:CheckTime'="" CheckTime = ##Class(DHCMed.SSService.CommonCls).ChangeTimeFormat(CheckTime)
	
	Set CheckUser=$lg(RepInfo,34)                //审核人
	Set objCheckUser=##class(DHCMed.Base.SSUser).GetObjById(CheckUser)
	If $IsObject(objCheckUser){
		Set CheckUserCode=objCheckUser.Code
		Set CheckUserName=objCheckUser.Name
	}
	If (StatusDesc'="已审"){
		Set CheckDate=""
		Set CheckTime=""
		Set CheckUserCode=""
		Set CheckUserName=""
	}
	
	Set return=return_$lb($g(ind))
	Set return=return_$lb($g(RepID))             	    //报告ID
	Set return=return_$lb($g(PatientID))                //PatientID
	Set return=return_$lb($g(PapmiNo))                  //登记号
	Set return=return_$lb($g(PatientName))              //姓名
	Set return=return_$lb($g(PatientSex))               //性别
	Set return=return_$lb($g(PatientAge))               //年龄
	Set return=return_$lb($g(CateDesc))                 //疾病分类
	Set return=return_$lb($g(DiseaseDesc))              //疾病名称
	Set return=return_$lb($g(RepLoc))                   //报告科室
	Set return=return_$lb($g(RepUserName))              //报告人
	Set return=return_$lb($g(RepDate))                  //报告日期
	Set return=return_$lb($g(RepTime))                  //报告时间
	Set return=return_$lb($g(StatusDesc))         	    //报告状态
	Set return=return_$lb($g(EpisodeID))                //EpisodeID
	Set return=return_$lb($g(CheckUserName))            //审核人
	Set return=return_$lb($g(CheckDate))                //审核日期
	Set return=return_$lb($g(CheckTime))                //审核时间

	Quit return
}

}
