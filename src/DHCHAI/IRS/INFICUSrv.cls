/// 名称: DHCHAI.IRS.INFICUSrv
/// 描述: ICU三管相关服务
/// 编写者：pylian
/// 编写日期: 2018-01-09
Class DHCHAI.IRS.INFICUSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     jiangpengpeng
/// CreatDate：   2018-07-17
/// Description:  打印ICU报告
/// Table：       
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCHAI.IRS.INFICUSrv","QryAdmToPrint",47)
Query QryAdmToPrint(aPaadm As %String) As %Query(ROWSPEC = "ID:%String,LocID:%String,LocDesc:%String,AdmLocID:%String,AdmLocDesc:%String,AdmWardID:%String,AdmWardDesc:%String,PapmiNo:%String,Paadm:%String,PatientName:%String,Sex:%String,Age:%String,PAAdmBed:%String,PAAdmDate:%String,PADischDate:%String,IsPICC:%String,IsUC:%String,IsVAP:%String,PatWeight:%String,IsNewIn:%String,IsNewOut:%String,RepID:%String,RepStatus:%String,RepUserID:%String,RepUserName:%String,RepDate:%String,RegNo:%String,ReportLocDesc:%String,InIntubatDesc:%String,OutIntubatListDesc:%String,IsICUINFDesc:%String") [ SqlProc ]
{
}

ClassMethod QryAdmToPrintExecute(ByRef qHandle As %Binary, aPaadm As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:(aPaadm="") $$$OK
	Set objAdm=##class(DHCHAI.DP.PAAdm).GetObjById(aPaadm)
	Quit:'$IsObject(objAdm)
	Set VisitStatus=objAdm.PAVisitStatus
	
	Set (PatientID,PatientName,Sex,Age,Type,BedDr,BedDesc)=""
	Set xPaadm     = objAdm.%Id()
	Set PatientID  = objAdm.PAPatientIDx
	Set PatientName= objAdm.PAPatName
	Set PapmiNo    = objAdm.PAMrNo
	Set Sex        = objAdm.PASex        //性别
	Set Sex        = $s(Sex="M":"男",Sex="F":"女",1:"其他")
	Set Age        = objAdm.PAAge
	Set RegNo      = objAdm.PAPapmiNo    //登记号
	If $IsObject(objAdm.PAAdmBedDr){     // 床位
		Set BedDr  = objAdm.PAAdmBedDr.%Id()
		Set BedDesc= objAdm.PAAdmBedDr.BTDesc
	}
	Set PAAdmDate  = objAdm.PAAdmDate    //入院日期
	Set PADischDate= objAdm.PADischDate  //出院日期
	
	Set (IsPICC,IsUC,IsVAP)="0"  //无
	
	//入院日期、出院日期
	Set:PAAdmDate'="" PAAdmDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(PAAdmDate)
	Set:PADischDate'="" PADischDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(PADischDate)
		
	//当前科室
	Set (AdmLocID,AdmLocDesc,AdmWardID,AdmWardDesc)=""
	If $IsObject(objAdm.PAAdmLocDr){
		Set AdmLocID = objAdm.PAAdmLocDr.%Id()
		Set AdmLocDesc = objAdm.PAAdmLocDr.BTDesc
		Set:$p(AdmLocDesc,"-",2)'="" AdmLocDesc=$p(AdmLocDesc,"-",2)
		Set AdmLocDesc2 = objAdm.PAAdmLocDr.BTDesc2
		Set:AdmLocDesc2'="" AdmLocDesc=AdmLocDesc2
	}
	If $IsObject(objAdm.PAAdmWardDr){
		Set AdmWardID = objAdm.PAAdmWardDr.%Id()
		Set AdmWardDesc = objAdm.PAAdmWardDr.BTDesc
		Set:$p(AdmWardDesc,"-",2)'="" AdmWardDesc=$p(AdmWardDesc,"-",2)
		Set AdmWardDesc2 = objAdm.PAAdmWardDr.BTDesc2
		Set:AdmWardDesc2'="" AdmWardDesc=AdmWardDesc2
	}
	
	Set Data=$lb(ind,aLocDr,LocDesc,AdmLocID,AdmLocDesc,AdmWardID,AdmWardDesc)
	Set Data=Data_$lb(PapmiNo,xPaadm,PatientName,Sex,Age,BedDesc,PAAdmDate,PADischDate)
	Set Data=Data_$lb(IsPICC,IsUC,IsVAP,PatWeight,IsNewIn,IsNewOut)
	
	//调查报告信息
	Set (RepID,RepStatus,ReportLocDesc,RepUserID,RepUserName,IsICUINFDesc,RepDate,InIntubatID,InIntubatDesc,OutIntubatListID,OutIntubatListDesc)=""
	Set xRepID = ""
	Set xRepID = $o(^DHCHAI.IR.INFReportI("IndexPaadmType",xPaadm,3,xRepID))
	if +xRepID'=0 {
		Set objRep = ##class(DHCHAI.IR.INFReport).GetObjById(xRepID)
		if $Isobject(objRep)
		{
			Set RepID =objRep.%Id()
			if $Isobject(objRep.IRStatusDr)
			{
				Set RepStatus = objRep.IRStatusDr.BTDesc
			}
			if $Isobject(objRep.IRRepUser)
			{
				Set RepUserID = objRep.IRRepUser.%Id()
				Set RepUserName =objRep.IRRepUser.BTDesc
			}
			if $Isobject(objRep.ICUIsICUINF)
			{
				Set IsICUINFID = objRep.ICUIsICUINF.%Id()
				Set IsICUINFDesc =objRep.ICUIsICUINF.BTDesc
			}
			if $Isobject(objRep.IRRepLocDr)
			{
				Set ReportLocDesc =objRep.IRRepLocDr.BTDesc2
				Set:ReportLocDesc="" ReportLocDesc=objRep.IRRepLocDr.BTDesc
			}
			Set InIntubatList = objRep.IRInIntubats
			For indx = 1:1:InIntubatList.Count(){
			 	Set objDic = InIntubatList.GetAt(indx)
				Continue:'$IsObject(objDic)	
				Set InIntubatID=InIntubatID_","_objDic.%Id()
				Set InIntubatDesc=InIntubatDesc_","_objDic.BTDesc
			} 
			Set:InIntubatID'="" InIntubatID=$e(InIntubatID,2,$l(InIntubatID))
			Set:InIntubatDesc'="" InIntubatDesc=$e(InIntubatDesc,2,$l(InIntubatDesc))
			Set OutIntubatList = objRep.IROutIntubats
			For indx = 1:1:OutIntubatList.Count(){
			 	Set objDic = OutIntubatList.GetAt(indx)
				Continue:'$IsObject(objDic)	
				Set OutIntubatListID=OutIntubatListID_","_objDic.%Id()
				Set OutIntubatListDesc=OutIntubatListDesc_","_objDic.BTDesc
			} 
			Set:OutIntubatListID'="" OutIntubatListID=$e(OutIntubatListID,2,$l(OutIntubatListID))
			Set:OutIntubatListDesc'="" OutIntubatListDesc=$e(OutIntubatListDesc,2,$l(OutIntubatListDesc))
				
			Set RepDate = objRep.IRRepDate
			//Set:+RepDate'=0 RepDate = $zd(RepDate,3)
			Set:RepDate'="" RepDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RepDate)
		}
	}
	Set Data=Data_$lb(RepID,RepStatus,RepUserID,RepUserName,RepDate,RegNo,ReportLocDesc,InIntubatDesc,OutIntubatListDesc,IsICUINFDesc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	
	Quit $$$OK
}

ClassMethod QryAdmToPrintClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAdmToPrintExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAdmToPrintFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAdmToPrintExecute ]
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

/// Creator：     pylian
/// CreatDate：   2018-01-09
/// Description:  审核单条数据
/// Input：       aEpisodeID:就诊ID
/// Return：      >0 审核成功
/// Table：       DHCHAI.IR.INFICUPICC,DHCHAI.IR.INFICUUC，DHCHAI.IR.INFICUVAP
/// w ##class(DHCHAI.IRS.INFICUSrv).CheckItem(414)
ClassMethod CheckItem(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=0
	Quit:(aEpisodeID="") return
	Set $ZT="CheckItemErr"
	
	TStart
	// 中心静脉置管
	Set return = -1
	Set xPICCID = ""
	For {
		Set xPICCID = $o(^DHCHAI.IR.INFICUPICCI("IdxofIREpisodeDr",aEpisodeID,xPICCID))
		Quit:xPICCID=""
		Set flg=..SavePICCStatus(xPICCID)
		If (+flg)<1 TRollback
		Continue:(+flg)<1 
	}

	// 泌尿道插管
	Set return = -2
	Set xUCID = ""
	For {
		Set xUCID = $o(^DHCHAI.IR.INFICUUCI("IdxofIREpisodeDr",aEpisodeID,xUCID))
		Quit:xUCID=""
		Set flg=..SaveUCStatus(xUCID)
		If (+flg)<1 TRollback
		Continue:(+flg)<1 
	}
	
	// 呼吸机
	Set return = -3
	Set xVAPID = ""
	For {
		Set xVAPID = $o(^DHCHAI.IR.INFICUVAPI("IdxofIREpisodeDr",aEpisodeID,xVAPID))
		Quit:xVAPID=""
		Set flg=..SaveVAPStatus(xVAPID)
		If (+flg)<1 TRollback
		Continue:(+flg)<1 
	}

    TCommit
	Set return=1
	Quit return
CheckItemErr
	Quit -999_"^"_$ZError
}

/// Creator：     pylian
/// CreatDate：   2018-01-09
/// Description:  保存中心静脉置管内容(只更新是否审核)
/// Table：       DHCHAI.IR.INFICUPICC
/// Input：       
/// Return：      返回ID
/// w ##Class(DHCHAI.IRS.INFICUSrv).SavePICCStatus("5")
ClassMethod SavePICCStatus(aID As %String) As %String
{
	New (aID)
	Set return=0
	Quit:(aID="") return
	Set $ZT="SavePICCStatusErr"

	Set obj=##class(DHCHAI.IR.INFICUPICC).%OpenId(aID)
	Quit:'$IsObject(obj) return
	Quit:(obj.IRIsCheck=1) 1   //已审核数据不再审核
	Set obj.IRIsCheck = 1
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
	
SavePICCStatusErr
	Quit -999_"^"_$ZError
}

/// Creator：     pylian
/// CreatDate：   2018-01-09
/// Description:  保存泌尿道插管内容(只更新是否审核)
/// Table：       DHCHAI.IR.INFICUUC
/// Input：       
/// Return：      返回ID
/// w ##Class(DHCHAI.IRS.INFICUSrv).SaveUCStatus("1")
ClassMethod SaveUCStatus(aID As %String) As %String
{
	New (aID)
	Set return=0
	Quit:(aID="") return
	Set $ZT="SaveUCStatusErr"

	Set obj=##class(DHCHAI.IR.INFICUUC).%OpenId(aID)
	Quit:'$IsObject(obj) return
	Quit:(obj.IRIsCheck=1) 1   //已审核数据不再审核
	Set obj.IRIsCheck = 1
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
	
SaveUCStatusErr
	Quit -999_"^"_$ZError
}

/// Creator：     pylian
/// CreatDate：   2018-01-09
/// Description:  保存呼吸机内容(只更新是否审核)
/// Table：       DHCHAI.IR.INFICUVAP
/// Input：       
/// Return：      返回ID
/// w ##Class(DHCHAI.IRS.INFICUSrv).SaveVAPStatus("1")
ClassMethod SaveVAPStatus(aID As %String) As %String
{
	New (aID)
	Set return=0
	Quit:(aID="") return
	Set $ZT="SaveVAPStatusErr"

	Set obj=##class(DHCHAI.IR.INFICUVAP).%OpenId(aID)
	Quit:'$IsObject(obj) return
	Quit:(obj.IRIsCheck=1) 1   //已审核数据不再审核
	Set obj.IRIsCheck = 1
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
	
SaveVAPStatusErr
	Quit -999_"^"_$ZError
}

/// Creator：     pylian
/// CreatDate：   2018-01-09
/// Description:  判断报告中是否有未审核内容
/// Input：       aEpisodeID:就诊ID
/// Table：       DHCHAI.IR.INFICUPICC,DHCHAI.IR.INFICUUC，DHCHAI.IR.INFICUVAP      
/// Return：      :<0 有未审核  
/// w ##Class(DHCHAI.IRS.INFICUSrv).GetIsUnCheck("616")
ClassMethod GetIsUnCheck(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=0
	Quit:(aEpisodeID="") return

    Set IsUnCheck=0
	// 中心静脉置管
    Set return = -1 
	Set xPICCID = ""
	For {
		Set xPICCID = $o(^DHCHAI.IR.INFICUPICCI("IdxofIREpisodeDr",aEpisodeID,xPICCID))
		Quit:xPICCID=""
		Set objPICC=##class(DHCHAI.IR.INFICUPICC).%OpenId(xPICCID)
		Continue:'$IsObject(objPICC) 
		Continue:(objPICC.IRIsCheck=1)
		Set IsUnCheck=1
	}
    Quit:(IsUnCheck=1) return
    
	// 泌尿道插管
	Set return = -2
	Set xUCID = ""
	For {
		Set xUCID = $o(^DHCHAI.IR.INFICUUCI("IdxofIREpisodeDr",aEpisodeID,xUCID))
		Quit:xUCID=""
		Set objUC=##class(DHCHAI.IR.INFICUUC).%OpenId(xUCID)
		Continue:'$IsObject(objUC) 
		Continue:(objUC.IRIsCheck=1)
		Set IsUnCheck=1
	}
    Quit:(IsUnCheck=1) return
	
	// 呼吸机
	Set return = -3
	Set xVAPID = ""
	For {
		Set xVAPID = $o(^DHCHAI.IR.INFICUVAPI("IdxofIREpisodeDr",aEpisodeID,xVAPID))
		Quit:xVAPID=""
		Set objVAP=##class(DHCHAI.IR.INFICUVAP).%OpenId(xVAPID)
		Continue:'$IsObject(objVAP) 
		Continue:(objVAP.IRIsCheck=1)
		Set IsUnCheck=1
	}
    Quit:(IsUnCheck=1) return
	
	Set return=1
	Quit return
}

}
