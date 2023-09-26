/// 名称: DHCHAI.IRS.OccExpRegSrv
/// 描述: 职业暴露服务
/// 编写者：pylian
/// 编写日期: 2018-05-11
Class DHCHAI.IRS.OccExpRegSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2021-10-14
/// Description:  根据报告ID+类型获取检验计划项目ID列表
/// Table：       DHCHAI.IR.OccExpReg，DHCHAI.IR.OccExpRegLab，DHCHAI.IR.OccExpTypeLab
/// Input:        报告ID
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.OccExpRegSrv","QryExpLabSubByType","9","HIV")
Query QryExpLabSubByType(aRepID As %String, aLabList As %String) As %Query(ROWSPEC = "RepID:%String,SubID:%String,Desc:%String,BTResume:%String,SpenBarCode:%String,LabResult:%String,RegTypeDesc:%String") [ SqlProc ]
{
}

ClassMethod QryExpLabSubByTypeExecute(ByRef qHandle As %Binary, aRepID As %String, aLabList As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:(aRepID="")||(aLabList="") $$$OK
	
	Set return = $$$OK
	Set objRep = ##Class(DHCHAI.IR.OccExpReg).GetObjById(aRepID)
	Quit:'$IsObject(objRep) return
	
	Set objRegType = objRep.OERegTypeDr
	Quit:'$IsObject(objRegType) return
	Set TypeID = objRegType.%Id()
	Set RegTypeDesc = objRegType.BTDesc
	Set xSubID=0	
	For {
		Set xSubID=$o(^DHCHAI.IR.OccExpTypeD(TypeID,"LAB",xSubID))
		Quit:xSubID=""
		
		Set LabID=TypeID_"||"_xSubID
		Set objLAB = ##class(DHCHAI.IR.OccExpTypeLab).GetObjById(LabID)
		Continue:'$Isobject(objLAB)
		
	    Set IsActive  = objLAB.BTIsActive
		Continue:(IsActive'=1)
	    Set Desc = objLAB.BTDesc
	    Set:Desc["梅毒" Desc=Desc_"MD"
	    Set Flag=0
	    For indType=1:1:$l(aLabList,","){
			Set LabType=$p(aLabList,",",indType)
			Set:Desc[LabType Flag=1
		}
		Continue:Flag'=1
		Set BTResume = objLAB.BTResume
	    // 职业暴露条码规则：8位  报告ID+血清学检查计划（SubID）
		Set SpenBarCode = ##class(DHCHAI.IR.OccExpReg).GetSpenBarCode(aRepID,xSubID)
		Set LabResult=""
		Set RstInfo = ##Class(DHCHAI.DPS.LabInfVisitNumberSrv).GetLabByCode(SpenBarCode,2)
		If (RstInfo'=""){   // 职业暴露目前只考虑一个项目一个检验结果
		   Set LabTestDesc  = $p(RstInfo,"^",1)
		   Set LabTestCode  = $p(RstInfo,"^",2)
		   Set LabRegDate   = $p(RstInfo,"^",3)
		   Set LabAuthDate  = $p(RstInfo,"^",4)
		   Set LabRstFormat = $p(RstInfo,"^",5)
		   Set LabResult    = $p(RstInfo,"^",6)
		   Set LabResNoes   = $p(RstInfo,"^",7)
		   Set LabAbFlag    = $p(RstInfo,"^",8)
		   Set LabRefRanges = $p(RstInfo,"^",9)
		}
	    Set Data=$lb(aRepID,xSubID,Desc,BTResume,SpenBarCode,LabResult,RegTypeDesc)  
	    Set ^CacheTemp(repid,ind)=Data
    	Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryExpLabSubByTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryExpLabSubByTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryExpLabSubByTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryExpLabSubByTypeExecute ]
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
/// CreatDate：   2021-09-07
/// Description:  根据报告ID获取检验计划项目ID列表
/// Table：       DHCHAI.IR.OccExpReg，DHCHAI.IR.OccExpRegLab，DHCHAI.IR.OccExpTypeLab
/// Input:        报告ID
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.OccExpRegSrv","QryExpLabSubID","6")
Query QryExpLabSubID(aRepID As %String) As %Query(ROWSPEC = "RepID:%String,SubID:%String,Desc:%String,LabTestDesc:%String,LabTestCode:%String,LabRegDate:%String,LabAuthDate:%String,LabRstFormat:%String,LabResult:%String,LabResNoes:%String,LabAbFlag:%String,LabRefRanges:%String") [ SqlProc ]
{
}

ClassMethod QryExpLabSubIDExecute(ByRef qHandle As %Binary, aRepID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:aRepID="" $$$OK
	
	Set objRep = ##Class(DHCHAI.IR.OccExpReg).GetObjById(aRepID)
	Quit:'$IsObject(objRep) return
	
	Set objRegType = objRep.OERegTypeDr
	Quit:'$IsObject(objRegType) return
	Set TypeID = objRegType.%Id()
	Set xSubID=0	
	For {
		Set xSubID=$o(^DHCHAI.IR.OccExpTypeD(TypeID,"LAB",xSubID))
		Quit:xSubID=""
		
		Set LabID=TypeID_"||"_xSubID
		Set objLAB = ##class(DHCHAI.IR.OccExpTypeLab).GetObjById(LabID)
		Continue:'$Isobject(objLAB)
		
	    Set IsActive  = objLAB.BTIsActive
		Continue:(IsActive'=1)
	    Set Desc = objLAB.BTDesc
	    // 职业暴露条码规则：报告ID+血清学检查计划（SubID）
		Set SpenBarCode = ##class(DHCHAI.IR.OccExpReg).GetSpenBarCode(aRepID,xSubID)
		Set (LabTestDesc,LabTestCode,LabRegDate,LabAuthDate,LabRstFormat,LabResult,LabResNoes,LabAbFlag,LabRefRanges) =""
	    Set RstInfo = ##Class(DHCHAI.DPS.LabInfVisitNumberSrv).GetLabByCode(SpenBarCode,2)
	    If (RstInfo'=""){   // 职业暴露目前只考虑一个项目一个检验结果
		   Set LabTestDesc  = $p(RstInfo,"^",1)
		   Set LabTestCode  = $p(RstInfo,"^",2)
		   Set LabRegDate   = $p(RstInfo,"^",3)
		   Set LabAuthDate  = $p(RstInfo,"^",4)
		   Set LabRstFormat = $p(RstInfo,"^",5)
		   Set LabResult    = $p(RstInfo,"^",6)
		   Set LabResNoes   = $p(RstInfo,"^",7)
		   Set LabAbFlag    = $p(RstInfo,"^",8)
		   Set LabRefRanges = $p(RstInfo,"^",9)
		}
	    
	    Set Data=$lb(aRepID,xSubID,Desc,LabTestDesc,LabTestCode,LabRegDate,LabAuthDate,LabRstFormat,LabResult,LabResNoes,LabAbFlag,LabRefRanges)  
	    Set ^CacheTemp(repid,ind)=Data
    	Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryExpLabSubIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryExpLabSubIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryExpLabSubIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryExpLabSubIDExecute ]
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
/// CreatDate：   2018-06-08
/// Description:  保存职业暴露报告
/// Input：       aExpReg：主表信息
/// 			  aExpRegExt：扩展表
/// 			  aExpRegLog：日志
/// Return:		  return>0:成功、return<1:失败 
/// Debug:		  w ##class(DHCHAI.IRS.OccExpRegSrv).SaveExpReport()
ClassMethod SaveExpReport(aExpReg As %String, aExpRegExts As %String, aExpRegLog As %String)
{
	Set return = ""
	New (aExpReg,aExpRegExts,aExpRegLog)
	
	//Set ^REG("SaveExpReport")=$lb(aExpReg,aExpRegExts,aExpRegLog)
	//Set aExpReg=$lg($g(^REG("SaveExpReport")),1)
	//Set aExpRegExts=$lg($g(^REG("SaveExpReport")),2)
	//Set aExpRegLog=$lg($g(^REG("SaveExpReport")),3)
    //Set ReportID=""
	TStart
	
	// 主表信息
	Set return = -1
	Set ReportID  = $p(aExpReg,$c(1),1)

	//转换操作代码->ID
	Set StatusCode = $p(aExpReg,$c(1),7)
	Set StatusDr   = ""
	Set ObjStatus=##class(DHCHAI.BT.Dictionary).GetObjByCode("OERegStatus",StatusCode)
	Set:$IsObject(ObjStatus) StatusDr=ObjStatus.%Id()
	Set $p(aExpReg,$c(1),7)=StatusDr
    Set flg=##Class(DHCHAI.IR.OccExpReg).Update(aExpReg,$c(1))
	If flg=-1 TRollback
	Quit:(+flg)<1 return
	Set ReportID=+flg
		
    //保存扩展表
	Set return = -2
	Set aExpRegExt="" 
	For indx = 1:1:$length(aExpRegExts,$c(2)){
		Set aExpRegExt = $p(aExpRegExts,$c(2),indx)
		Continue:aExpRegExt="" 
		
	    Set $p(aExpRegExt,$c(1),1)= ReportID
		Set flg=##Class(DHCHAI.IR.OccExpRegExt).Update(aExpRegExt,$c(1))
		If flg=-1 TRollback
		Quit:(+flg)<1  
	}
	
	// 保存日志信息
	Set return = -3
	Set $p(aExpRegLog,$c(1),1)=ReportID
	//转换操作代码->ID
	Set StatusCode = $p(aExpRegLog,$c(1),3)
	Set StatusDr   = ""
	Set ObjStatus=##class(DHCHAI.BT.Dictionary).GetObjByCode("OERegStatus",StatusCode)
	Set:$IsObject(ObjStatus) StatusDr=ObjStatus.%Id()
	Set $p(aExpRegLog,$c(1),3)=StatusDr
	Set flg=##Class(DHCHAI.IR.OccExpRegLog).Update(aExpRegLog,$c(1))
	If flg=-1 TRollback
	Quit:(+flg)<1 return
    
    TCommit
    
	Set return = ReportID	
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2018-06-08
/// Description:  保存职业暴露血清学信息
/// 			  aExpRegLab：血清学检检
/// 			  aExpRegLog：日志
/// Return:		  return>0:成功、return<1:失败 
/// Debug:		  w ##class(DHCHAI.IRS.OccExpRegSrv).SaveExpLab("")
ClassMethod SaveExpLab(aExpRegLabs As %String, aExpRegLog As %String)
{
	Set return = ""
	New (aExpRegLabs,aExpRegLog)
	
	Set ReportID=""
	TStart
	
	// 保存血清学信息
	//Set ^LAB("SaveExpLab")=$lb(aExpRegLabs,aExpRegLog)
	Set return = -1
	Set aExpRegLab="" ,ReportID =""
	For indx = 1:1:$length(aExpRegLabs,$c(2)){
		Set aExpRegLab = $p(aExpRegLabs,$c(2),indx)
		Continue:aExpRegLab="" 
	    Set ReportID =$p(aExpRegLab,$c(1),1)
	   	
		Set flg=##Class(DHCHAI.IR.OccExpRegLab).Update(aExpRegLab,$c(1))
		If flg=-1 TRollback
	    Continue:(+flg)<1 
		Set ReportID=+flg
		
	}
	
	// 保存日志信息
	Set return = -2
	Set $p(aExpRegLog,$c(1),1)=ReportID
	//转换操作代码->ID
	Set StatusCode = $p(aExpRegLog,$c(1),3)
	Set StatusDr   = ""
	Set ObjStatus=##class(DHCHAI.BT.Dictionary).GetObjByCode("OERegStatus",StatusCode)
	Set:$IsObject(ObjStatus) StatusDr=ObjStatus.%Id()
	Set $p(aExpRegLog,$c(1),3)=StatusDr
	
	Set flg=##Class(DHCHAI.IR.OccExpRegLog).Update(aExpRegLog,$c(1))
	If flg=-1 TRollback
	Quit:(+flg)<1 return
 
    TCommit
    
	Set return = ReportID
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2018-06-08
/// Description:  保存报告内容(只保存更新状态,日志)
/// Table：       DHCHAI.IR.OccExpReg
/// Input：       
/// Return：      返回ID
/// w ##Class(DHCHAI.IRS.OccExpRegSrv).SaveRepStatus("3","9","")
ClassMethod SaveRepStatus(aReportID As %String, aStatus As %String, aExpRegLog As %String) As %String
{
	New (aReportID,aStatus,aExpRegLog)
	Set return=0
	Quit:((aReportID="")||(aStatus="")) return
    
    Set ReportID=""

    TStart
    
    Set flg =1
	Set objStatus = ##class(DHCHAI.BT.Dictionary).GetObjByCode("OERegStatus",aStatus)
	Quit:'$IsObject(objStatus) return
	
	Set obj=##class(DHCHAI.IR.OccExpReg).%OpenId(aReportID)
	Quit:'$IsObject(obj) return
	Set obj.OEStatusDr=objStatus
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set flg=-1
	} 
	Do obj.%Close()
	If flg=-1 TRollback	
	Quit:(+flg)<1 return
	
	// 日志
	//转换操作代码->ID
	Set StatusCode = $p(aExpRegLog,$c(1),3)
	Set StatusDr   = ""
	Set ObjStatus=##class(DHCHAI.BT.Dictionary).GetObjByCode("OERegStatus",StatusCode)
	Set:$IsObject(ObjStatus) StatusDr=ObjStatus.%Id()
	Set $p(aExpRegLog,$c(1),3)=StatusDr
	
	Set ret = ##class(DHCHAI.IR.OccExpRegLog).Update(aExpRegLog,$c(1))
	If ret=-1 TRollback	
	Quit:(+ret)<1 return
	Set ReportID = +ret
	TCommit
	
	Set return = ReportID
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2018-06-08
/// Description:  保存职业暴露日志
/// 			  aExpRegLog：日志
/// Return:		  return>0:成功、return<1:失败 
/// Debug:		  w ##class(DHCHAI.IRS.OccExpRegSrv).SaveRepLog("")
ClassMethod SaveRepLog(aReportID As %String, aExpRegLog As %String)
{
	Set return = 0
	New (aReportID,aExpRegLog)
	
	Set ReportID=""
	TStart
	
	Set return =-1
	Set $p(aExpRegLog,$c(1),1)=aReportID
	//转换操作代码->ID
	Set StatusCode = $p(aExpRegLog,$c(1),3)
	Set StatusDr   = ""
	Set ObjStatus=##class(DHCHAI.BT.Dictionary).GetObjByCode("OERegStatus",StatusCode)
	Set:$IsObject(ObjStatus) StatusDr=ObjStatus.%Id()
	Set $p(aExpRegLog,$c(1),3)=StatusDr
	
	Set flg=##Class(DHCHAI.IR.OccExpRegLog).Update(aExpRegLog,$c(1))
	If flg=-1 TRollback
	Quit:(+flg)<1 return
	Set ReportID = +flg
 
    TCommit
    
	Set return = ReportID
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2018-06-29
/// Description:  保存职业暴露报告(部分内容)
/// 			  aExpRegExt：扩展表
/// 			  aExpRegLog：日志
/// Return:		  return>0:成功、return<1:失败 
/// Debug:		  w ##class(DHCHAI.IRS.OccExpRegSrv).SaveRegExt()
ClassMethod SaveRegExt(aExpRegExts As %String, aExpRegLog As %String)
{
	Set return = ""
	New (aExpRegExts,aExpRegLog)
	
	//Set ^REG("SaveRegExt")=$lb(aExpRegExts,aExpRegLog)
	//Set aExpRegExts=$lg($g(^REG("SaveRegExt")),1)
	//Set aExpRegLog=$lg($g(^REG("SaveRegExt")),2)
    Set ReportID=""
	TStart
	
    //保存扩展表
	Set return = -1
	Set aExpRegExt="" 
	For indx = 1:1:$length(aExpRegExts,$c(2)){
		Set aExpRegExt = $p(aExpRegExts,$c(2),indx)
		Continue:aExpRegExt="" 

		Set flg=##Class(DHCHAI.IR.OccExpRegExt).Update(aExpRegExt,$c(1))
		If flg=-1 TRollback
		Quit:(+flg)<1 
		Set ReportID = +flg 
	}
	
	// 保存日志信息
	Set return = -2
	Set StatusCode = $p(aExpRegLog,$c(1),3)
	Set StatusDr   = ""
	Set ObjStatus=##class(DHCHAI.BT.Dictionary).GetObjByCode("OERegStatus",StatusCode)
	Set:$IsObject(ObjStatus) StatusDr=ObjStatus.%Id()
	Set $p(aExpRegLog,$c(1),3)=StatusDr
	Set flg=##Class(DHCHAI.IR.OccExpRegLog).Update(aExpRegLog,$c(1))
	If flg=-1 TRollback
	Quit:(+flg)<1 return
	Set ReportID = +flg
    
    TCommit
    
	Set return = ReportID	
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2018-06-08
/// Description:  查询职业暴露主表明细
/// Table：       DHCHAI.IR.OccExpReg
/// Input:        报告ID
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.OccExpRegSrv","QryRepInfo","1")
Query QryRepInfo(aRepID As %String) As %Query(ROWSPEC = "RegID:%String,RegTypeCode:%String,RegTypeDesc:%String,RegLocID:%String,RegLocDesc:%String,RegUserCode:%String,RegUserDesc:%String,ExposerCode:%String,ExposerDesc:%String,Name:%String,RegNo:%String,Sex:%String,Age:%String,WorkAge:%String,Duty:%String,TelPhone:%String,ExpAddr:%String,ExpLocID:%String,ExpLocDesc:%String,RegDate:%String,RegTime:%String,StatusCode:%String,StatusDesc:%String,ExpDate:%String,ExpTime:%String,RegUserID:%String,RegDate:%String,RegTime:%String") [ SqlProc ]
{
}

ClassMethod QryRepInfoExecute(ByRef qHandle As %Binary, aRepID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:aRepID="" $$$OK
	
	Set objReg = ##class(DHCHAI.IR.OccExpReg).GetObjById(aRepID)
	Quit:'$IsObject(objReg) return
	
	Set objRegTypeDr  = objReg.OERegTypeDr
	Set RegTypeID="", RegTypeCode="",RegTypeDesc=""
	If $IsObject(objRegTypeDr) {
		Set RegTypeID = objRegTypeDr.%Id()
		Set RegTypeCode = objRegTypeDr.BTCode
		Set RegTypeDesc = objRegTypeDr.BTDesc
	}	   
    Set RegDate  = objReg.OERegDate
    Set:RegDate'="" RegDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RegDate) 
    Set RegTime  = objReg.OERegTime
 	Set:RegTime'="" RegTime=$zt(RegTime,1)
	   	
    Set objRegUser = objReg.OERegUserDr
    Set RegUserID="", RegUserCode="",RegUserDesc=""
	If $IsObject(objRegUser) {
		Set RegUserID = objRegUser.%Id()
		Set RegUserCode = objRegUser.BTCode
		Set RegUserDesc = objRegUser.BTDesc
	}	   	
    Set objStatus  = objReg.OEStatusDr
    Set StatusID="", StatusCode="",StatusDesc=""
	If $IsObject(objStatus) {
		Set StatusID = objStatus.%Id()
		Set StatusCode = objStatus.BTCode
		Set StatusDesc = objStatus.BTDesc
	}
	
	Set objExpLoc  = objReg.OEExpLocDr	
    Set ExpLocID="", ExpLocCode="",ExpLocDesc=""
	If $IsObject(objExpLoc) {
		Set ExpLocID = objExpLoc.%Id()
		Set ExpLocCode = objExpLoc.BTCode
		Set ExpLocDesc = objExpLoc.BTDesc
	}
	
    Set objRegLoc  = objReg.OERegLocDr	
    Set RegLocID="", RegLocCode="",RegLocDesc=""
	If $IsObject(objRegLoc) {
		Set RegLocID = objRegLoc.%Id()
		Set RegLocCode = objRegLoc.BTCode
		Set RegLocDesc = objRegLoc.BTDesc
	} 
	Set RegDate  = objReg.OERegDate
    Set:RegDate'="" RegDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RegDate) 
    Set RegTime  = objReg.OERegTime
    Set:RegTime'="" RegTime=$zt(RegTime,1)
        
    Set objExposer = objReg.OEExposerDr
    Set ExposerID="", ExposerCode="",ExposerDesc=""
	If $IsObject(objExposer) {
		Set ExposerID = objExposer.%Id()
		Set ExposerCode = objExposer.BTCode
		Set ExposerDesc = objExposer.BTDesc
	}	   	
    Set ExpDate  = objReg.OEExpDate
    Set:ExpDate'="" ExpDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ExpDate) 
    Set ExpTime  = objReg.OEExpTime
    Set:ExpTime'="" ExpTime=$zt(ExpTime,1)
    
    Set Name    = objReg.OEName
    Set RegNo   = objReg.OERegNo
    Set Sex     = objReg.OESex
    Set Sex = $s(Sex="M":"男",Sex="F":"女",Sex="O":"其他")  //M男、F女、O其他
    Set Age     = objReg.OEAge
    Set WorkAge = objReg.OEWorkAge
    Set Duty    = objReg.OEDuty
    Set ExpAddr  = objReg.OEExpAddr
    Set TelPhone = objReg.OETelPhone
    //多语言处理
    Set RegTypeDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",RegTypeDesc,"DHCHAI.IR.OccExpType")
	Set Sex=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTSEXDesc",Sex,"User.CTSex")
    Set RegLocDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",RegLocDesc,"User.CTLoc")
    Set RegUserDesc =##Class(DHCHAI.Abstract).HAIGetTranByDesc("SSUSRName",RegUserDesc,"User.SSUser")
	Set StatusDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",StatusDesc,"DHCHAI.BT.Dictionary")	    
    Set Data=$lb(aRepID,RegTypeCode,RegTypeDesc,RegLocID,RegLocDesc,RegUserCode,RegUserDesc,ExposerCode,ExposerDesc,Name,RegNo,Sex,Age,WorkAge,Duty,TelPhone,ExpAddr,ExpLocID,ExpLocDesc,RegDate,RegTime,StatusCode,StatusDesc,ExpDate,ExpTime,RegUserID,RegDate,RegTime)

	Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
	Quit $$$OK
}

ClassMethod QryRepInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRepInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryRepInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRepInfoExecute ]
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
/// CreatDate：   2018-06-08
/// Description:  查询职业暴露扩展表明细
/// Table：       DHCHAI.IR.OccExpReg，DHCHAI.IR.OccExpRegExt，DHCHAI.IR.OccExpTypeExt
/// Input:        报告ID
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.OccExpRegSrv","QryExpExtInfo","1")
Query QryExpExtInfo(aRepID As %String) As %Query(ROWSPEC = "RepID:%String,SubID:%String,Code:%String,Desc:%String,ItemDesc:%String,DataType:%String,ResultID:%String,ResultCode:%String,ResultDesc:%String,ResultList:%String,ResultListCode:%String,ResultListDesc:%String,ResultTxt:%String,ActDate:%String,ActTime:%String,ActUserID:%String,ActUserCode:%String,ActUserDesc:%String") [ SqlProc ]
{
}

ClassMethod QryExpExtInfoExecute(ByRef qHandle As %Binary, aRepID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:aRepID="" $$$OK
	
	Set xSubID = ""
	For {
		Set xSubID =$o(^DHCHAI.IR.OccExpRegD(aRepID,"EXT",xSubID))
		Quit:xSubID=""
		
		Set ExtID=aRepID_"||"_xSubID
		Set objExt = ##class(DHCHAI.IR.OccExpRegExt).GetObjById(ExtID)
	    Continue:'$IsObject(objExt) 
		Set objItemDr  = objExt.OEItemDr
	    Continue:'$IsObject(objItemDr)	    
	    Set Code 	  = objItemDr.BTCode	   
	    Set Desc 	  = objItemDr.BTDesc	   	
	  
		Set ItemDesc   = objExt.OEItemDesc  
		Set DataType   = objExt.OEDataType  
		Set objResult  = objExt.OEResultDr 
		Set ResultID="", ResultCode="",ResultDesc=""
		If $IsObject(objResult) {
			Set ResultID = objResult.%Id()
			Set ResultCode = objResult.BTCode
			Set ResultDesc = objResult.BTDesc
		}
    
		Set ResultList = objExt.OEResultList
		Set ResultListID="",ResultListCode="",ResultListDesc=""
		For indx = 1:1:ResultList.Count(){
		 	Set objDic = ResultList.GetAt(indx)
			Continue:'$IsObject(objDic)	
			Set ResultListID=ResultListID_","_objDic.%Id()
			Set ResultListCode=ResultListCode_","_objDic.BTCode
			Set ResultListDesc=ResultListDesc_","_objDic.BTDesc
		} 
		Set:ResultListID'="" ResultListID=$e(ResultListID,2,$l(ResultListID))
		Set:ResultListCode'="" ResultListCode=$e(ResultListCode,2,$l(ResultListCode))
		Set:ResultListDesc'="" ResultListDesc=$e(ResultListDesc,2,$l(ResultListDesc))
		
		Set ResultTxt  = objExt.OEResultTxt 
		Set ActDate	   = objExt.OEActDate
		Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)  	  
		Set ActTime	   = objExt.OEActTime
		Set:ActTime'="" ActTime=$zt(ActTime,1)	  
		Set objActUser  = objExt.OEActUserDr 
        Set ActUserID="", ActUserCode="",ActUserDesc=""
		If $IsObject(objActUser) {
			Set ActUserID = objActUser.%Id()
			Set ActUserCode = objActUser.BTCode
			Set ActUserDesc = objActUser.BTDesc
		}	   	
	
		Set Data=$lb(aRepID,xSubID,Code,Desc,ItemDesc,DataType,ResultID,ResultCode,ResultDesc,ResultListID,ResultListCode,ResultListDesc,ResultTxt,ActDate,ActTime,ActUserID,ActUserCode,ActUserDesc)  
	    Set ^CacheTemp(repid,ind)=Data
    	Set ind=ind+1
	}

	Quit $$$OK
}

ClassMethod QryExpExtInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryExpExtInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryExpExtInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryExpExtInfoExecute ]
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
/// CreatDate：   2018-06-08
/// Description:  查询职业暴露血清学检查表明细
/// Table：       DHCHAI.IR.OccExpReg，DHCHAI.IR.OccExpRegLab，DHCHAI.IR.OccExpTypeLab
/// Input:        报告ID
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.OccExpRegSrv","QryExpLabInfo","8")
Query QryExpLabInfo(aRepID As %String) As %Query(ROWSPEC = "RepID:%String,SubID:%String,LabTimID:%String,Desc:%String,Days:%String,LabDate:%String,LabItem:%String,Result:%String,DeptDesc:%String,Reterence:%String,Collector:%String,Examiner:%String") [ SqlProc ]
{
}

ClassMethod QryExpLabInfoExecute(ByRef qHandle As %Binary, aRepID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:aRepID="" $$$OK
	
	Set xSubID = ""
	For {
		Set xSubID =$o(^DHCHAI.IR.OccExpRegD(aRepID,"LAB",xSubID))
		Quit:xSubID=""
		
		Set LabID=aRepID_"||"_xSubID
		Set objLab = ##class(DHCHAI.IR.OccExpRegLab).GetObjById(LabID)
	    Continue:'$IsObject(objLab) 
	   	Set objLabTim  = objLab.OELabTimDr
	   	Continue:'$IsObject(objLabTim) 
	   	Set LabTimID  = objLabTim.%Id()
	   	Set Desc	  = objLabTim.BTDesc
		Set Days	  = objLabTim.BTDays
	   	Set IsActive  = objLabTim.BTIsActive
	   	Continue:IsActive'=1
		Set LabDate   = objLab.OELabDate 
		Set:LabDate'="" LabDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(LabDate)  
		Set LabItem   = objLab.OELabItem  
		Set Result    = objLab.OEResult   
		Set DeptDesc  = objLab.OEDeptDesc 
		Set Collector = objLab.OECollector
		Set Reterence = objLab.OEReterence
		Set Examiner  = objLab.OEExaminer 
	
		Set Data=$lb(aRepID,xSubID,LabTimID,Desc,Days,LabDate,LabItem,Result,DeptDesc,Reterence,Collector,Examiner)  
	    Set ^CacheTemp(repid,ind)=Data
    	Set ind=ind+1
	}

	Quit $$$OK
}

ClassMethod QryExpLabInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryExpLabInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryExpLabInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryExpLabInfoExecute ]
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
/// CreatDate：   2018-06-28
/// Description:  查询职业暴露登记（管理员可查看本科室）
/// Table：       DHCHAI.IR.OccExpReg
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCHAI.IRS.OccExpRegSrv","QryExpRegInfo","","","")
Query QryExpRegInfo(aUserID As %String = "", aRegLoc As %String = "") As %Query(ROWSPEC = "ID:%String,RegTypeID:%String,RegTypeCode:%String,RegTypeDesc:%String,RegLocID:%String,RegLocDesc:%String,RegUserCode:%String,RegUserDesc:%String,ExposerCode:%String,ExposerDesc:%String,Name:%String,RegNo:%String,Sex:%String,Age:%String,WorkAge:%String,Duty:%String,ExpAddr:%String,TelPhone:%String,RegDate:%String,RegTime:%String,StatusCode:%String,StatusDesc:%String,ExpDate:%String,ExpTime:%String") [ SqlProc ]
{
}

ClassMethod QryExpRegInfoExecute(ByRef qHandle As %Binary, aUserID As %String = "", aRegLoc As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	
 	Set xType="" 
 	For {
 		Set xType=$o(^DHCHAI.IR.OccExpRegI("IndexRegTypeDate",xType))
		Quit:xType=""
			
		Set xDate=""
		For {
			Set xDate=$o(^DHCHAI.IR.OccExpRegI("IndexRegTypeDate",xType,xDate),-1)  //登记日期
			Quit:xDate=""
			Continue:xDate>+$h
			
			Set xID=""
			For {
	 			Set xID=$o(^DHCHAI.IR.OccExpRegI("IndexRegTypeDate",xType,xDate,xID))
				Quit:xID=""	
				
				Set objReg = ##class(DHCHAI.IR.OccExpReg).GetObjById(xID)
				Continue:'$IsObject(objReg) 
				Set objRegTypeDr  = objReg.OERegTypeDr
				Set RegTypeID="", RegTypeCode="",RegTypeDesc=""
				If $IsObject(objRegTypeDr) {
					Set RegTypeID = objRegTypeDr.%Id()
					Set RegTypeCode = objRegTypeDr.BTCode
					Set RegTypeDesc = objRegTypeDr.BTDesc
				}	   
			    Set RegDate  = objReg.OERegDate
			    Set:RegDate'="" RegDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RegDate) 
			    Set RegTime  = objReg.OERegTime
			 	Set:RegTime'="" RegTime=$zt(RegTime,1)
				   	
			    Set objRegUser = objReg.OERegUserDr
			    Set RegUserID="", RegUserCode="",RegUserDesc=""
				If $IsObject(objRegUser) {
					Set RegUserID = objRegUser.%Id()
					Set RegUserCode = objRegUser.BTCode
					Set RegUserDesc = objRegUser.BTDesc
				}
				Continue:(aUserID'="")&&(aUserID'=RegUserID) 	
				   	
			    Set objStatus  = objReg.OEStatusDr
			    Set StatusID="", StatusCode="",StatusDesc=""
				If $IsObject(objStatus) {
					Set StatusID = objStatus.%Id()
					Set StatusCode = objStatus.BTCode
					Set StatusDesc = objStatus.BTDesc
				}
				Continue:StatusDesc="删除"	//过滤删除报告
			    Set objRegLoc  = objReg.OERegLocDr	
			    Set RegLocID="", RegLocCode="",RegLocDesc=""
				If $IsObject(objRegLoc) {
					Set RegLocID = objRegLoc.%Id()
					Set RegLocCode = objRegLoc.BTCode
					Set RegLocDesc = objRegLoc.BTDesc
				}
				Continue:(aRegLoc'="")&&(aRegLoc'=RegLocID) 
						     
			    Set objExposer = objReg.OEExposerDr
			    Set ExposerID="", ExposerCode="",ExposerDesc=""
				If $IsObject(objExposer) {
					Set ExposerID = objExposer.%Id()
					Set ExposerCode = objExposer.BTCode
					Set ExposerDesc = objExposer.BTDesc
				}	   	
			    Set ExpDate  = objReg.OEExpDate
			    Set:ExpDate'="" ExpDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ExpDate) 
			    Set ExpTime  = objReg.OEExpTime
			    Set:ExpTime'="" ExpTime=$zt(ExpTime,1)
			    
			    Set Name    = objReg.OEName
			    Set RegNo   = objReg.OERegNo
			    Set Sex     = objReg.OESex
			    Set Sex = $s(Sex="M":"男",Sex="F":"女",Sex="O":"其他")  //M男、F女、O其他
			    Set Age     = objReg.OEAge
			    Set WorkAge = objReg.OEWorkAge
			    Set Duty    = objReg.OEDuty
			    Set ExpAddr = objReg.OEExpAddr
			    Set TelPhone= objReg.OETelPhone
			    //多语言处理
			    Set RegTypeDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",RegTypeDesc,"DHCHAI.IR.OccExpType")
			    Set Sex=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTSEXDesc",Sex,"User.CTSex")
			    Set RegLocDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",RegLocDesc,"User.CTLoc")
			    Set RegUserDesc =##Class(DHCHAI.Abstract).HAIGetTranByDesc("SSUSRName",RegUserDesc,"User.SSUser")
			    Set StatusDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",StatusDesc,"DHCHAI.BT.Dictionary")
			    Set Data=$lb(xID,RegTypeID,RegTypeCode,RegTypeDesc,RegLocID,RegLocDesc,RegUserCode,RegUserDesc,ExposerCode,ExposerDesc,Name,RegNo,Sex,Age,WorkAge,Duty,ExpAddr,TelPhone,RegDate,RegTime,StatusCode,StatusDesc,ExpDate,ExpTime)
				Continue:Data=""
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
					
			}
		}
 	}

	Quit $$$OK
}

ClassMethod QryExpRegInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryExpRegInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryExpRegInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryExpRegInfoExecute ]
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
/// CreatDate：   2018-06-12
/// Description:  查询职业暴露
/// Table：       DHCHAI.IR.OccExpReg
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCHAI.IRS.OccExpRegSrv","QryOccExpReg","1|2|3","1","1","2022-08-01","2022-09-20","","","")
Query QryOccExpReg(aHospIDs As %String, aRepType As %String, aDateType As %String, aDateFrom As %String, aDateTo As %String, aRegLoc As %String, aStatus As %String, aLabStatus As %String = "") As %Query(ROWSPEC = "ID:%String,RegTypeID:%String,RegTypeCode:%String,RegTypeDesc:%String,ExpLocID:%String,ExpLocDesc:%String,RegLocID:%String,RegLocDesc:%String,RegUserCode:%String,RegUserDesc:%String,ExposerCode:%String,ExposerDesc:%String,Name:%String,RegNo:%String,Sex:%String,Age:%String,WorkAge:%String,Duty:%String,ExpAddr:%String,TelPhone:%String,RegDate:%String,RegTime:%String,StatusCode:%String,StatusDesc:%String,ExpDate:%String,ExpTime:%String,Item1:%String,Item2:%String,Item3:%String,Item4:%String,Item5:%String,Item6:%String,Item7:%String,Item8:%String,Item9:%String,Item10:%String,Item11:%String,Item12:%String,Item13:%String,Item14:%String,Item15:%String,Item16:%String,Item17:%String,Item18:%String,Item19:%String,Item20:%String,Item21:%String,Item22:%String") [ SqlProc ]
{
}

ClassMethod QryOccExpRegExecute(ByRef qHandle As %Binary, aHospIDs As %String, aRepType As %String, aDateType As %String, aDateFrom As %String, aDateTo As %String, aRegLoc As %String, aStatus As %String, aLabStatus As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Set aStatus  = ##class(DHCHAI.Utils.CommonSrv).ListFromString(aStatus,"|")
	Set aHospIDs  = ##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Quit:(aDateFrom>aDateTo) $$$OK
 	Set:aDateFrom>+$h aDateFrom=+$h
 	Set:aDateTo>+$h aDateTo=+$h
 	Quit:(aDateFrom="")||(aDateTo="")||(aDateType="") $$$OK
 	
 	If aDateType=1 { //登记日期
	 	Set xType="" 
	 	For {
	 		Set xType=$o(^DHCHAI.IR.OccExpRegI("IndexRegTypeDate",xType))
			Quit:xType=""
			Continue:(aRepType'="")&&(aRepType'=xType)
			
			Set xDate=aDateFrom-1
			For {
				Set xDate=$o(^DHCHAI.IR.OccExpRegI("IndexRegTypeDate",xType,xDate))  //登记日期
				Quit:xDate=""
				Quit:xDate>aDateTo  
				
				Set xID=""
				For {
		 			Set xID=$o(^DHCHAI.IR.OccExpRegI("IndexRegTypeDate",xType,xDate,xID))
					Quit:xID=""	
					
					Set Data=$$GetExpRegExtInfo(xType, xID)
					Continue:Data=""
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
						
				}
			}
	 	}
 	}
 	If aDateType=2 {  //暴露日期
	 	Set xType="" 
	 	For {
	 		Set xType=$o(^DHCHAI.IR.OccExpRegI("IndexTypeExpDate",xType))
			Quit:xType=""
			Continue:(aRepType'="")&&(aRepType'=xType)
			
			Set xDate=aDateFrom-1
			For {
				Set xDate=$o(^DHCHAI.IR.OccExpRegI("IndexTypeExpDate",xType,xDate))  //暴露日期
				Quit:xDate=""
				Quit:xDate>aDateTo  
				
				Set xID=""
				For {
		 			Set xID=$o(^DHCHAI.IR.OccExpRegI("IndexTypeExpDate",xType,xDate,xID))
					Quit:xID=""	
					
					Set Data=$$GetExpRegExtInfo(xType, xID)
					Continue:Data=""
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}	
			}
		}
 	}
	Quit $$$OK
	
GetExpRegExtInfo(xType, xID)
	Set Data=..BuildExpReg(xID)	//主表信息
	Quit:Data="" ""
	
	Set StatusDesc=$li(Data,24)
	Quit:StatusDesc="删除" ""
	//过滤追踪检测
	Set LabStatus=..GetLabStatus(xType,xID)
	Quit:(aLabStatus'="")&&(LabStatus'=aLabStatus) ""
	
	
	Set TypeCodeList=$lb("010100")	 //工龄-1
	Set TypeCodeList=TypeCodeList_$lb("010200")  	//本次职业暴露是-2
	Set TypeCodeList=TypeCodeList_$lb("010300")		//工作类别-3
	Set TypeCodeList=TypeCodeList_$lb("010400")		//暴露地点-4
	Set TypeCodeList=TypeCodeList_$lb("010500")     //锐器类型-5
	Set TypeCodeList=TypeCodeList_$lb("010510")     //损伤和危险度-6
	Set TypeCodeList=TypeCodeList_$lb("010520")     //危险物来源-7
	Set TypeCodeList=TypeCodeList_$lb("010700")     //是否接种过乙肝疫苗-8
	Set TypeCodeList=TypeCodeList_$lb("010800")  	//暴露程度-9
	Set TypeCodeList=TypeCodeList_$lb("010900")		//暴露部位-10
	Set TypeCodeList=TypeCodeList_$lb("020110")   	//暴露源姓名-11
	Set TypeCodeList=TypeCodeList_$lb("020120")   	//病案号/登记号-12
	Set TypeCodeList=TypeCodeList_$lb("020210")  	//暴露源[HBV]-13
	Set TypeCodeList=TypeCodeList_$lb("020220")  	//暴露源[HCV]-14
	Set TypeCodeList=TypeCodeList_$lb("020230")  	//暴露源[HIV]-15
	Set TypeCodeList=TypeCodeList_$lb("020240")  	//暴露源[梅毒]-16
	Set TypeCodeList=TypeCodeList_$lb("030100")  	//本次职业暴露是否接受了专科医师评估-17
	Set TypeCodeList=TypeCodeList_$lb("030200")  	//本次职业暴露接受干预用药-18
	Set TypeCodeList=TypeCodeList_$lb("040100")  	//本次职业暴露发生原因分析-19
	Set TypeCodeList=TypeCodeList_$lb("050110")  	//暴露结论-20
	Set TypeCodeList=TypeCodeList_$lb("050120")  	//结论日期-21
	Set TypeCodeList=TypeCodeList_$lb("050130")  	//备注-22
	
	Set xItemCode=""
	For {
		Set xItemCode=$o(^DHCHAI.IR.OccExpTypeI("EXT","IndexCode",xType,xItemCode))
		Quit:xItemCode=""
		
		Continue:$ListFind(TypeCodeList,xItemCode)<1
		
		Set xItemSubID=$o(^DHCHAI.IR.OccExpTypeI("EXT","IndexCode",xType,xItemCode,""))
		
		Set objItem=##class(DHCHAI.IR.OccExpTypeExt).GetObjById(xType_"||"_xItemSubID)
		Continue:'$IsObject(objItem)
		
		Set TypeDesc=objItem.BTDesc
		
		Set RegExtSubID=$o(^DHCHAI.IR.OccExpRegI("EXT","IndexItem",xID,xType_"||"_xItemSubID,""))
		If (RegExtSubID="") {
			Set Data=Data_$lb("")
		} Else {
			Set objRegExt=##class(DHCHAI.IR.OccExpRegExt).GetObjById(xID_"||"_RegExtSubID)
			Continue:'$IsObject(objRegExt)
			Set ResultTxt = objRegExt.OEResultTxt
			Set ResultDr = objRegExt.OEResultDr
			Set ResultList = objRegExt.OEResultList
			
			Set Result=""
			If (ResultTxt'="") {
				Set Result=ResultTxt
			} ElseIF (ResultDr'="") {
				Set Result=ResultDr.BTDesc
			} ElseIF (ResultList) {
				For ResInd=1:1:ResultList.Count(){
					Set Result=Result_","_ResultList.GetAt(ResInd).BTDesc
				}
				Set:Result'="" Result=$e(Result,8,$Length(Result))
			}
			Set Data=Data_$lb(Result)
		}
	}
	Quit Data
}

ClassMethod QryOccExpRegClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOccExpRegExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOccExpRegFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOccExpRegExecute ]
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

/// 取单个职业暴露报告主表信息
ClassMethod BuildExpReg(aRepID As %String) As %List
{
	Set return = ""
	Quit:aRepID="" return
    
	Set objReg = ##class(DHCHAI.IR.OccExpReg).GetObjById(aRepID)
	Quit:'$IsObject(objReg) return

	Set objRegTypeDr  = objReg.OERegTypeDr
	Set RegTypeID="", RegTypeCode="",RegTypeDesc=""
	If $IsObject(objRegTypeDr) {
		Set RegTypeID = objRegTypeDr.%Id()
		Set RegTypeCode = objRegTypeDr.BTCode
		Set RegTypeDesc = objRegTypeDr.BTDesc
	}	 
    Set RegDate  = objReg.OERegDate
    Set:RegDate'="" RegDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RegDate) 
    Set RegTime  = objReg.OERegTime
 	Set:RegTime'="" RegTime=$zt(RegTime,1)
	   	
    Set objRegUser = objReg.OERegUserDr
    Set RegUserID="", RegUserCode="",RegUserDesc=""
	If $IsObject(objRegUser) {
		Set RegUserID = objRegUser.%Id()
		Set RegUserCode = objRegUser.BTCode
		Set RegUserDesc = objRegUser.BTDesc
	}	   	
    Set objStatus  = objReg.OEStatusDr
    Set StatusID="", StatusCode="",StatusDesc=""
	If $IsObject(objStatus) {
		Set StatusID = objStatus.%Id()
		Set StatusCode = objStatus.BTCode
		Set StatusDesc = objStatus.BTDesc
	}
	Quit:(aStatus'="")&($listfind(aStatus,StatusID)<1) return   //状态过滤 
	
	Set objExpLoc  = objReg.OEExpLocDr	
    Set ExpLocID="", ExpLocCode="",ExpLocDesc=""
	If $IsObject(objExpLoc) {
		Set ExpLocID = objExpLoc.%Id()
		Set ExpLocCode = objExpLoc.BTCode
		Set ExpLocDesc = objExpLoc.BTDesc
	}
	
    Set objRegLoc  = objReg.OERegLocDr	
    Set RegLocID="", RegLocCode="",RegLocDesc=""
	If $IsObject(objRegLoc) {
		Set RegLocID = objRegLoc.%Id()
		Set RegLocCode = objRegLoc.BTCode
		Set RegLocDesc = objRegLoc.BTDesc
		If $IsObject(objRegLoc.BTHospDr){
			Set HospID=objRegLoc.BTHospDr.%Id()	
			Quit:(aHospIDs'="")&($listfind(aHospIDs,HospID)<1) return 	//医院过滤	
		}
	}
	Quit:(aRegLoc'="")&&(aRegLoc'=RegLocID) return
			     
    Set objExposer = objReg.OEExposerDr
    Set ExposerID="", ExposerCode="",ExposerDesc=""
	If $IsObject(objExposer) {
		Set ExposerID = objExposer.%Id()
		Set ExposerCode = objExposer.BTCode
		Set ExposerDesc = objExposer.BTDesc
	}	   	
    Set ExpDate  = objReg.OEExpDate
    Set:ExpDate'="" ExpDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ExpDate) 
    Set ExpTime  = objReg.OEExpTime
    Set:ExpTime'="" ExpTime=$zt(ExpTime,1)
    
    Set Name    = objReg.OEName
    Set RegNo   = objReg.OERegNo
    Set Sex     = objReg.OESex
    Set Sex = $s(Sex="M":"男",Sex="F":"女",Sex="O":"其他")  //M男、F女、O其他
    Set Age     = objReg.OEAge
    Set WorkAge = objReg.OEWorkAge
    Set Duty    = objReg.OEDuty
    Set ExpAddr = objReg.OEExpAddr
    Set TelPhone= objReg.OETelPhone
 	
    Set return=$lb(aRepID,RegTypeID,RegTypeCode,RegTypeDesc,ExpLocID,ExpLocDesc,RegLocID,RegLocDesc,RegUserCode,RegUserDesc,ExposerCode,ExposerDesc,Name,RegNo,Sex,Age,WorkAge,Duty,ExpAddr,TelPhone,RegDate,RegTime,StatusCode,StatusDesc,ExpDate,ExpTime)
    Quit return
}

/// Creator：     pylian
/// CreatDate：   2018-06-29
/// Description:  查询职业暴露操作明细
/// Table：       DHCHAI.IR.OccExpRegLog
/// Input:        aLocID：登录科室ID 
/// d ##class(%ResultSet).RunQuery("DHCHAI.IRS.OccExpRegSrv","QryExpRepLog","1")
Query QryExpRepLog(aRepID As %String, aStatus As %String = "") As %Query(ROWSPEC = "SubID:%String,LogID:%String,StatusCode:%String,StatusDesc:%String,Opinion:%String,UpdateDate:%String,UpdateTime:%String,UpdateUserCode:%String,UpdateUserDesc:%String") [ SqlProc ]
{
}

ClassMethod QryExpRepLogExecute(ByRef qHandle As %Binary, aRepID As %String, aStatus As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set NIndex="QryExpRepLog"
	Kill ^TMP($zn,$j,NIndex)	
	Quit:(aRepID="") $$$OK
 	
 	Set xStatus=""
 	For {
	 	Set xStatus=$o(^DHCHAI.IR.OccExpRegI("LOG","IndexStatusDate",aRepID,xStatus))
		Quit:xStatus=""
		
		Set xDate=""
		For {
 			Set xDate=$o(^DHCHAI.IR.OccExpRegI("LOG","IndexStatusDate",aRepID,xStatus,xDate))
			Quit:xDate=""		
		
			Set xSubID=""
			For {
	 			Set xSubID=$o(^DHCHAI.IR.OccExpRegI("LOG","IndexStatusDate",aRepID,xStatus,xDate,xSubID))
				Quit:xSubID=""	
				
				Set LogID=aRepID_"||"_xSubID	
				Set objRegLog = ##class(DHCHAI.IR.OccExpRegLog).GetObjById(LogID)
				Continue:'$IsObject(objRegLog) 
				
				Set objStatus=objRegLog.OEStatusDr
				Set StatusID="", StatusCode="",StatusDesc=""
				If $IsObject(objStatus) {
					Set StatusID = objStatus.%Id()
					Set StatusCode = objStatus.BTCode
					Set StatusDesc = objStatus.BTDesc
				}
				Continue:(aStatus'="")&&(aStatus'=StatusCode)
				Set Opinion=objRegLog.OEOpinion
				Set TimDescList = ""
				If (StatusCode=4)&&(Opinion'="") {
					Set LabTimList = $p(Opinion,"#",2)
					Set Opinion = $p(Opinion,"#",1)
					For indx=1:1:$length(LabTimList,",") {
						Set LabTimID=$p(LabTimList,",",indx)
						Set objLab = ##class(DHCHAI.IR.OccExpTypeLab).GetObjById(LabTimID)
						Continue:'$IsObject(objLab)
						Set TimDesc = objLab.BTDesc
						Set Resume = objLab.BTResume
						Set TimDescList = TimDescList_","_TimDesc_" "_Resume
					}
					Set:TimDescList'="" TimDescList=$e(TimDescList,2,$l(TimDescList)) 
					Set Opinion=Opinion_" "_TimDescList
				}
				Set UpdateDate=objRegLog.OEUpdateDate
				Set:UpdateDate'="" UpdateDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(UpdateDate) 
				Set UpdateTime=objRegLog.OEUpdateTime
	    		Set:UpdateTime'="" UpdateTime=$zt(UpdateTime,1)
	    		
				Set objUser=objRegLog.OEUpdateUserDr
				Set UpdateUserID="", UpdateUserCode="",UpdateUserDesc=""
				If $IsObject(objUser) {
					Set UpdateUserID = objUser.%Id()
					Set UpdateUserCode = objUser.BTCode
					Set UpdateUserDesc = objUser.BTDesc
				}	
				   
				Set Data=$lb(xSubID,LogID,StatusCode,StatusDesc,Opinion,UpdateDate,UpdateTime,UpdateUserCode,UpdateUserDesc)
				Continue:Data=""
				//保存操作记录
				Set ^TMP($zn,$j,NIndex,"RepLog",UpdateDate,UpdateTime,xSubID)=	Data
			}
	
		}
 	}
 	//按更新日期-时间重排
 	Set xUpdateDate=""
 	For{
		Set xUpdateDate=$o(^TMP($zn,$j,NIndex,"RepLog",xUpdateDate))
		Quit:xUpdateDate=""
		
		Set xUpdateTime=""
		For{
			Set xUpdateTime=$o(^TMP($zn,$j,NIndex,"RepLog",xUpdateDate,xUpdateTime))
			Quit:xUpdateTime=""
		
			Set xSubID=""
			For{
				Set xSubID=$o(^TMP($zn,$j,NIndex,"RepLog",xUpdateDate,xUpdateTime,xSubID))
				Quit:xSubID=""
				
				Set Data=$g(^TMP($zn,$j,NIndex,"RepLog",xUpdateDate,xUpdateTime,xSubID))
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1	
			}
		}
	}
 	
 	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryExpRepLogClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryExpRepLogExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryExpRepLogFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryExpRepLogExecute ]
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
/// CreatDate：   2018-06-13
/// Description:  查询职业暴露待审核数量
/// Table：       DHCHAI.IR.OccExpReg
/// Input:        aLocID：登录科室ID 
/// d ##class(%ResultSet).RunQuery("DHCHAI.IRS.OccExpRegSrv","QryExpCheckCnt","119")
Query QryExpCheckCnt(aLocID As %String) As %Query(ROWSPEC = "Count:%String") [ SqlProc ]
{
}

ClassMethod QryExpCheckCntExecute(ByRef qHandle As %Binary, aLocID) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set objLoc=##class(DHCHAI.BT.Location).GetObjById(aLocID)
	Quit:'$IsObject(objLoc) $$$OK
	Quit:'$IsObject(objLoc.BTHospDr) $$$OK
	Quit:'$IsObject(objLoc.BTHospDr.BTGroupDr) $$$OK
	Set HospID=objLoc.BTHospDr.%Id() 
	Set HospGrpID=objLoc.BTHospDr.BTGroupDr.%Id()
    
    Kill arrExpRegLab
	Set Count=0
	
 	Set xType="" 
 	For {
 		Set xType=$o(^DHCHAI.IR.OccExpRegI("IndexRegTypeDate",xType))
		Quit:xType=""
	
		Set xDate=""
		For {
			Set xDate=$o(^DHCHAI.IR.OccExpRegI("IndexRegTypeDate",xType,xDate))
			Quit:xDate=""
		
			Set xID=""
			For {
	 			Set xID=$o(^DHCHAI.IR.OccExpRegI("IndexRegTypeDate",xType,xDate,xID))
				Quit:xID=""	
				
				Set objReg = ##class(DHCHAI.IR.OccExpReg).GetObjById(xID)
				Continue:'$IsObject(objReg) 
                Set objRegLoc  = objReg.OERegLocDr	
			    Set RegLocID="", RegLocCode="",RegLocDesc=""
				If $IsObject(objRegLoc) {
					Set RegLocID = objRegLoc.%Id()
					Set RegLocCode = objRegLoc.BTCode
					Set RegLocDesc = objRegLoc.BTDesc
					If $IsObject(objRegLoc.BTHospDr){
						Continue:'$IsObject(objRegLoc.BTHospDr.BTGroupDr)
						Set tHospGrpID=objRegLoc.BTHospDr.BTGroupDr.%Id()
						Continue:HospGrpID'=tHospGrpID          //医院院区过滤	
						//Continue:(HospID'="")&(HospID'=objRegLoc.BTHospDr.%Id()) 	//医院过滤	
					}
				}
	            Continue:'$IsObject(objReg.OEStatusDr) 
				Set StatusCode = objReg.OEStatusDr.BTCode
				Continue:(StatusCode'="1")&&(StatusCode'="6")&&(StatusCode'="7")
	
				Set arrExpRegLab(xID)=""
				Set Count=Count+1
			}
		}
	}
	
	Kill arrExpRegLab
	Set ^CacheTemp(repid,ind)=$lb(Count)
	Set ind=ind+1

	Quit $$$OK
}

ClassMethod QryExpCheckCntClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryExpCheckCntExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryExpCheckCntFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryExpCheckCntExecute ]
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
/// CreatDate：   2018-06-13
/// Description:  查询职业暴露近日需提醒检验数量
/// Table：       DHCHAI.IR.OccExpReg
/// Input:        aLocID：登录科室ID 
/// d ##class(%ResultSet).RunQuery("DHCHAI.IRS.OccExpRegSrv","QryRemindCnt","119")
Query QryRemindCnt(aLocID As %String) As %Query(ROWSPEC = "Count:%String") [ SqlProc ]
{
}

ClassMethod QryRemindCntExecute(ByRef qHandle As %Binary, aLocID) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set objLoc=##class(DHCHAI.BT.Location).GetObjById(aLocID)
	Quit:'$IsObject(objLoc) $$$OK
	Quit:'$IsObject(objLoc.BTHospDr) $$$OK
	Quit:'$IsObject(objLoc.BTHospDr.BTGroupDr) $$$OK
	Set HospID=objLoc.BTHospDr.%Id() 	
    Set HospGrpID=objLoc.BTHospDr.BTGroupDr.%Id()

    Kill arrExpReg
	Set Count=0
	
 	Set xType="" 
 	For {
 		Set xType=$o(^DHCHAI.IR.OccExpRegI("IndexRegTypeDate",xType))
		Quit:xType=""
	
		Set xDate=""
		For {
			Set xDate=$o(^DHCHAI.IR.OccExpRegI("IndexRegTypeDate",xType,xDate))
			Quit:xDate=""
		
			Set xID=""
			For {
	 			Set xID=$o(^DHCHAI.IR.OccExpRegI("IndexRegTypeDate",xType,xDate,xID))
				Quit:xID=""	
				
				Set objReg = ##class(DHCHAI.IR.OccExpReg).GetObjById(xID)
				Continue:'$IsObject(objReg) 
                
                Set objRegLoc  = objReg.OERegLocDr	
			    Set RegLocID="", RegLocCode="",RegLocDesc=""
				If $IsObject(objRegLoc) {
					Set RegLocID = objRegLoc.%Id()
					Set RegLocCode = objRegLoc.BTCode
					Set RegLocDesc = objRegLoc.BTDesc
					If $IsObject(objRegLoc.BTHospDr){
						Continue:'$IsObject(objRegLoc.BTHospDr.BTGroupDr)
						Set tHospGrpID=objRegLoc.BTHospDr.BTGroupDr.%Id()
						Continue:HospGrpID'=tHospGrpID          //医院院区过滤	
						//Continue:(HospID'="")&(HospID'=objRegLoc.BTHospDr.%Id()) 	//医院过滤	
					}
				}
	
			   	Set ReqInfo =..CheckIsRequire(xID,+$h,+$h)
				Set IsRequire  = $p(ReqInfo,"^",1)
				Set LabTimList = $p(ReqInfo,"^",2)
				
				Continue:IsRequire'=1
				
				Set arrExpReg(xID)=""
				Set Count=Count+1
			}
		}
	}
	
	Kill arrExpReg
	Set ^CacheTemp(repid,ind)=$lb(Count)
	Set ind=ind+1

	Quit $$$OK
}

ClassMethod QryRemindCntClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRemindCntExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryRemindCntFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRemindCntExecute ]
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
/// CreatDate：   2018-06-27
/// Description:  查询职业暴露报告提醒
/// Table：       DHCHAI.IR.OccExpReg、DHCHAI.IR.OccExpLab、DHCHAI.IR.OccTypeLab、DHCHAI.IR.OccExpLog
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCHAI.IRS.OccExpRegSrv","QryOccExpRemind","1|2","1","1","2018-07-01","2018-07-03","")
Query QryOccExpRemind(aHospIDs As %String, aRepType As %String, aDateType As %String, aDateFrom As %String, aDateTo As %String, aRegLoc As %String) As %Query(ROWSPEC = "ID:%String,RegTypeID:%String,RegTypeCode:%String,RegTypeDesc:%String,RegLocID:%String,RegLocDesc:%String,RegUserCode:%String,RegUserDesc:%String,ExposerCode:%String,ExposerDesc:%String,Name:%String,RegNo:%String,Sex:%String,Age:%String,WorkAge:%String,Duty:%String,ExpAddr:%String,TelPhone:%String,RegDate:%String,RegTime:%String,StatusCode:%String,StatusDesc:%String,ExpDate:%String,ExpTime:%String,IsRemind:%String,RemindDate:%String,IsRequire:%String,LabTimList:%String,RequireLsit:%String,Oper:%String,Detil:%String") [ SqlProc ]
{
}

ClassMethod QryOccExpRemindExecute(ByRef qHandle As %Binary, aHospIDs As %String, aRepType As %String, aDateType As %String, aDateFrom As %String, aDateTo As %String, aRegLoc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Kill ^TMP($zn,$j,"QryOccExpRemind")
  
	Set aHospIDs  = ##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Quit:(aDateFrom>aDateTo) $$$OK
 	Quit:(aDateFrom="")||(aDateTo="")||(aDateType="") $$$OK
  
    If (aDateType=1) {  //待提醒
	 	Set xType="" 
	 	For {
	 		Set xType=$o(^DHCHAI.IR.OccExpRegI("IndexTypeExpDate",xType))
			Quit:xType=""
			Continue:(aRepType'="")&&(aRepType'=xType)
			
			Set xDate=""
			For {
				Set xDate=$o(^DHCHAI.IR.OccExpRegI("IndexTypeExpDate",xType,xDate))
				Quit:xDate=""
				Quit:xDate>aDateTo
				
				Set xID=""
				For {
		 			Set xID=$o(^DHCHAI.IR.OccExpRegI("IndexTypeExpDate",xType,xDate,xID))
					Quit:xID=""	
					
					Set ReqInfo =..CheckIsRequire(xID,aDateFrom,aDateTo)
					Set IsRequire  = $p(ReqInfo,"^",1)
					Set LabTimList = $p(ReqInfo,"^",2)
			        Set ReqDateList = $p(ReqInfo,"^",3)		   
			     	
			     	Continue:IsRequire'=1
			     	
					For indy=1:1:$length(LabTimList,",") {
						Set LabTimID=$p(LabTimList,",",indy)
						Continue:LabTimID=""
						Set ReqDate=$p(ReqDateList,",",indy)
				
						Set num=+$g(^TMP($zn,$j,"QryOccExpRemind",xID,ReqDate,LabTimID))
						Set ^TMP($zn,$j,"QryOccExpRemind",xID,ReqDate,LabTimID)=num+1	
					}				
				}	
			}
		}
    }Else {   //已提醒
	    Set xType="" 
	 	For {
	 		Set xType=$o(^DHCHAI.IR.OccExpRegI("IndexRegTypeDate",xType))
			Quit:xType=""
			Continue:(aRepType'="")&&(aRepType'=xType)
			
			Set xDate=""
			For {
				Set xDate=$o(^DHCHAI.IR.OccExpRegI("IndexRegTypeDate",xType,xDate))
				Quit:xDate=""
				Quit:xDate>aDateTo
				
				Set xID=""
				For {
		 			Set xID=$o(^DHCHAI.IR.OccExpRegI("IndexRegTypeDate",xType,xDate,xID))
					Quit:xID=""	
					
					Set Data=..BuildExpRemind(xID)
					Continue:Data=""
					
					Set RedInfo =..CheckIsRemind(xID,aDateFrom,aDateTo)
					Set IsRemind   = $p(RedInfo,"^",1)
					Continue:IsRemind'=1
					Set RemindDate = $p(RedInfo,"^",2)
					
					Set ReqInfo =..CheckIsRequire(xID,aDateFrom,aDateTo)
					Set IsRequire  = $p(ReqInfo,"^",1)
					Set LabTimList = $p(ReqInfo,"^",2)
			        
					Set RequireList=""
					Set Data = Data_$lb(IsRemind,RemindDate,IsRequire,LabTimList,RequireList)
					Continue:Data=""
					Set ^CacheTemp(repid,ind)=Data	
					Set ind=ind+1
				}	
			}
		}
    }

    Set xRepID=""
	For {
		Set xRepID=$o(^TMP($zn,$j,"QryOccExpRemind",xRepID))
		Quit:xRepID=""
		
		Set xDate =""
		For {
			Set xDate=$o(^TMP($zn,$j,"QryOccExpRemind",xRepID,xDate))
			Quit:xDate=""
			
			Set xTimID ="",TimList="",TimIDList=""
			For {
				Set xTimID=$o(^TMP($zn,$j,"QryOccExpRemind",xRepID,xDate,xTimID))
				Quit:xTimID=""
				
				Set objLAB = ##class(DHCHAI.IR.OccExpTypeLab).GetObjById(xTimID)
				Continue:'$Isobject(objLAB)
				Set LabTimDesc = objLAB.BTDesc
				Set Resume = objLAB.BTResume
				Set TimList = TimList_","_LabTimDesc_"("_Resume_")"
				Set TimIDList = TimIDList_","_xTimID
			}
			Set:TimList'="" TimList=$e(TimList,2,$l(TimList))
			Set:TimIDList'="" TimIDList=$e(TimIDList,2,$l(TimIDList))
			Set RequireList= xDate_" -> "_TimList
			
			Set RedInfo =..CheckIsRemind(xRepID,aDateFrom,aDateTo)
			Set IsRemind   = $p(RedInfo,"^",1)
			Set RemindDate = $p(RedInfo,"^",2)
			Set ReqInfo =..CheckIsRequire(xRepID,aDateFrom,aDateTo)
			Set IsRequire  = $p(ReqInfo,"^",1)
					
			Set Data=..BuildExpRemind(xRepID)
			Continue:Data=""
			Set Data = Data_$lb(IsRemind,RemindDate,IsRequire,TimIDList,RequireList)			
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
		
	}

 	Kill ^TMP($zn,$j,"QryOccExpRemind")
 	Quit $$$OK
}

ClassMethod QryOccExpRemindClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOccExpRemindExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOccExpRemindFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOccExpRemindExecute ]
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

/// 取单个职业暴露报告主表信息
ClassMethod BuildExpRemind(aRepID As %String) As %List
{
	Set return = ""
	Quit:aRepID="" return
    
	Set objReg = ##class(DHCHAI.IR.OccExpReg).GetObjById(aRepID)
	Quit:'$IsObject(objReg) return

	Set objRegTypeDr  = objReg.OERegTypeDr
	Set RegTypeID="", RegTypeCode="",RegTypeDesc=""
	If $IsObject(objRegTypeDr) {
		Set RegTypeID = objRegTypeDr.%Id()
		Set RegTypeCode = objRegTypeDr.BTCode
		Set RegTypeDesc = objRegTypeDr.BTDesc
	}	   
    Set RegDate  = objReg.OERegDate
    Set:RegDate'="" RegDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RegDate) 
    Set RegTime  = objReg.OERegTime
 	Set:RegTime'="" RegTime=$zt(RegTime,1)
	   	
    Set objRegUser = objReg.OERegUserDr
    Set RegUserID="", RegUserCode="",RegUserDesc=""
	If $IsObject(objRegUser) {
		Set RegUserID = objRegUser.%Id()
		Set RegUserCode = objRegUser.BTCode
		Set RegUserDesc = objRegUser.BTDesc
	}	   	
    Set objStatus  = objReg.OEStatusDr
    Set StatusID="", StatusCode="",StatusDesc=""
	If $IsObject(objStatus) {
		Set StatusID = objStatus.%Id()
		Set StatusCode = objStatus.BTCode
		Set StatusDesc = objStatus.BTDesc
	}
	
    Set objRegLoc  = objReg.OERegLocDr	
    Set RegLocID="", RegLocCode="",RegLocDesc=""
	If $IsObject(objRegLoc) {
		Set RegLocID = objRegLoc.%Id()
		Set RegLocCode = objRegLoc.BTCode
		Set RegLocDesc = objRegLoc.BTDesc
		If $IsObject(objRegLoc.BTHospDr){
			Set HospID=objRegLoc.BTHospDr.%Id()			
			Quit:(aHospIDs'="")&($listfind(aHospIDs,HospID)<1) return 	//医院过滤	
		}
	}
	Quit:(aRegLoc'="")&&(aRegLoc'=RegLocID) return
			     
    Set objExposer = objReg.OEExposerDr
    Set ExposerID="", ExposerCode="",ExposerDesc=""
	If $IsObject(objExposer) {
		Set ExposerID = objExposer.%Id()
		Set ExposerCode = objExposer.BTCode
		Set ExposerDesc = objExposer.BTDesc
	}	   	
    Set ExpDate  = objReg.OEExpDate
    Set:ExpDate'="" ExpDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ExpDate) 
    Set ExpTime  = objReg.OEExpTime
    Set:ExpTime'="" ExpTime=$zt(ExpTime,1)
    
    Set Name    = objReg.OEName
    Set RegNo   = objReg.OERegNo
    Set Sex     = objReg.OESex
    Set Sex = $s(Sex="M":"男",Sex="F":"女",Sex="O":"其他")  //M男、F女、O其他
    Set Age     = objReg.OEAge
    Set WorkAge = objReg.OEWorkAge
    Set Duty    = objReg.OEDuty
    Set ExpAddr = objReg.OEExpAddr
    Set TelPhone= objReg.OETelPhone
    
    Set return=$lb(aRepID,RegTypeID,RegTypeCode,RegTypeDesc,RegLocID,RegLocDesc,RegUserCode,RegUserDesc,ExposerCode,ExposerDesc,Name,RegNo,Sex,Age,WorkAge,Duty,ExpAddr,TelPhone,RegDate,RegTime,StatusCode,StatusDesc,ExpDate,ExpTime)
    Quit return
}

/// Creator：     pylian
/// CreatDate：   2018-06-28
/// Description:  判断一份职业暴露报告查询时间段内是否需提醒
/// Table：       DHCHAI.IR.OccExpReg
///               时机： 没填写/未提醒、没填写/已提醒 、已填写/未提醒 、已填写/已提醒
/// Table：       DHCHAI.IR.OccExpReg
/// Input:        aRepID:职业暴露报告ID 
///               aDateFrom: 开始日期
///               aDateTo：结束日期
/// w ##class(DHCHAI.IRS.OccExpRegSrv).CheckIsRequire("4","2018-07-04","2018-07-04")
ClassMethod CheckIsRequire(aRepID As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	New (aRepID,aDateFrom,aDateTo)
	Set return = ""
	Quit:(aRepID="")||(aDateFrom="")||(aDateTo="") return

	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Quit:(aDateFrom>aDateTo) return
	
	Set objReg = ##class(DHCHAI.IR.OccExpReg).GetObjById(aRepID)
	Quit:'$IsObject(objReg) return
    Quit:'$IsObject(objReg.OERegTypeDr) return
    Set RegTypeID = objReg.OERegTypeDr.%Id()
    Quit:'$IsObject(objReg.OEStatusDr) return
	Set StatusCode = objReg.OEStatusDr.BTCode
	Quit:((StatusCode="3")||(StatusCode="4")) return
    Set ExpDate  = objReg.OEExpDate
    Set ExpTime  = objReg.OEExpTime
    Set RemindDays=##class(DHCHAI.BT.Config).GetValByCode("ExpLabRemindDays")
    Set PerDay = $p(RemindDays,"-",1)
    Set AftDay = $p(RemindDays,"-",2)
    
    //待提醒
	Set IsRequire =0 ,LabTimLists="",ReqDateLists=""
	Set xID=0
	For {
		Set xID=$o(^DHCHAI.IR.OccExpTypeD(RegTypeID,"LAB",xID))
		Quit:xID=""
		
		Set LabID=RegTypeID_"||"_xID
		Set objLAB = ##class(DHCHAI.IR.OccExpTypeLab).GetObjById(LabID)
		Continue:'$Isobject(objLAB)
	    
	    Set SubID=$o(^DHCHAI.IR.OccExpRegI("LAB","IndexLabTim",aRepID,LabID,0))  //当前检查时机是否已填写
	    Continue:SubID'=""
	    Set IsActive 	  = objLAB.BTIsActive
	    Continue:IsActive'=1
	    //过滤检验类型
	    Set Desc 	 = objLAB.BTDesc
	    Set Code=""
	    Set:Desc["HBV暴露" Code="HBV"
	    Set:Desc["HCV暴露" Code="HCV"
	    Set:Desc["HIV暴露" Code="HIV"
	     Set:Desc["梅毒" Code="MD"
	    Set objReg = ##class(DHCHAI.IR.OccExpReg).GetObjById(aRepID)
		Continue:'$IsObject(objReg) 
		Set OELabList  = objReg.OELabList
		Continue:OELabList'[Code
	    
	    Set Days 	 = objLAB.BTDays
	    Set ReqDate  = ExpDate+(Days-1)        //待提醒日期 
	    Continue:((ReqDate-AftDay)>aDateTo)    //最迟预警日期大于结束日期
	    Continue:(ReqDate+PerDay<aDateFrom)        
	    Set LabTimLists = LabTimLists_","_LabID
	    Set:ReqDate'="" ReqDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ReqDate)   
        Set ReqDateLists =ReqDateLists_","_ReqDate
	    Set IsRequire=1
	}
	Set:LabTimLists'="" LabTimLists=$e(LabTimLists,2,$l(LabTimLists))
	Set:ReqDateLists'="" ReqDateLists=$e(ReqDateLists,2,$l(ReqDateLists))
	
    //已提醒
    Set StatusID = ##class(DHCHAI.BT.Dictionary).GetIDByCode("OERegStatus",4) 
    Quit:StatusID="" return
    Set IsRemind = 0 ,RemindDate ="",LabTimList=""
    Set xLogDate=""   //历史所有已提醒
	For {
		Set xLogDate=$o(^DHCHAI.IR.OccExpRegI("LOG","IndexStatusDate",aRepID,StatusID,xLogDate))  //已提醒日志 
		Quit:xLogDate=""
		Quit:xLogDate>(aDateTo+AftDay)
		
		Set xSubID=""
		For {
 			Set xSubID=$o(^DHCHAI.IR.OccExpRegI("LOG","IndexStatusDate",aRepID,StatusID,xLogDate,xSubID))
			Quit:xSubID=""
			
			Set objLog= ##class(DHCHAI.IR.OccExpRegLog).GetObjById(aRepID_"||"_xSubID)
			Continue:'$IsObject(objLog)
			
			Set IsRemind = 1 
			Set RemindDate = xLogDate
			Set:RemindDate'="" RemindDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RemindDate) 
			Set Opinion=objLog.OEOpinion  //已提醒#1||1,1||3
			Set LabTim=$p(Opinion,"#",2)
		    If (LabTim'="") {
				Set LabTimList=LabTimList_","_LabTim
		    }
		}	
	}
	Set:LabTimList'="" LabTimList=$e(LabTimList,2,$l(LabTimList))

	Set Flg=0,LabTim="",LabDate =""
	If (IsRequire=1)&&(IsRemind=1) {
		If (LabTimList'="") {
			For indx=1:1:$length(LabTimLists,",") {
				Set LabTimID=$p(LabTimLists,",",indx)
				Continue:LabTimID=""
				Continue:(LabTimList[LabTimID)
		        Set LabTim=LabTim_","_LabTimID
		        Set LabDate = LabDate_","_$p(ReqDateLists,",",indx)
				Set Flg =1
			}
			Set:LabTim'="" LabTim=$e(LabTim,2,$l(LabTim))
		    Set:LabDate'="" LabDate=$e(LabDate,2,$l(LabDate))
		    
			Set IsRequire = Flg
			Set LabTimLists = LabTim
			Set ReqDateLists = LabDate
		}
	}
	
	Set return = IsRequire_"^"_LabTimLists_"^"_ReqDateLists
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2018-06-28
/// Description:  判断一份职业暴露报告查询时间段内是否已经提醒
/// Table：       DHCHAI.IR.OccExpReg
/// Input:        aRepID:职业暴露报告ID 
/// w ##class(DHCHAI.IRS.OccExpRegSrv).CheckIsRemind("4","2018-06-01","2018-07-29")
ClassMethod CheckIsRemind(aRepID As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	New (aRepID,aDateFrom,aDateTo)
	Set return = ""
	Quit:(aRepID="")||(aDateFrom="")||(aDateTo="") return

	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Quit:(aDateFrom>aDateTo) return
		
	Set objReg = ##class(DHCHAI.IR.OccExpReg).GetObjById(aRepID)
	Quit:'$IsObject(objReg) return
    Quit:'$IsObject(objReg.OERegTypeDr) return
    Set RegTypeID = objReg.OERegTypeDr.%Id()
    Quit:'$IsObject(objReg.OEStatusDr) return
	Set StatusCode = objReg.OEStatusDr.BTCode
	Quit:((StatusCode="3")||(StatusCode="4")) return
    Set ExpDate  = objReg.OEExpDate
    Set ExpTime  = objReg.OEExpTime
    
   //已提醒
    Set StatusID = ##class(DHCHAI.BT.Dictionary).GetIDByCode("OERegStatus",4) 
	Set IsRemind = 0 ,RemindDate =""
	Set xLogDate=aDateFrom-1
	For {
		Set xLogDate=$o(^DHCHAI.IR.OccExpRegI("LOG","IndexStatusDate",aRepID,StatusID,xLogDate))  //已提醒日志 
		Quit:xLogDate=""
		Quit:xLogDate>aDateTo
	    //Continue:IsRemind=1  //最近一次提醒
	    
		Set xSubID=""
		For {
 			Set xSubID=$o(^DHCHAI.IR.OccExpRegI("LOG","IndexStatusDate",aRepID,StatusID,xLogDate,xSubID),-1)
			Quit:xSubID=""
				
			Set objLog= ##class(DHCHAI.IR.OccExpRegLog).GetObjById(aRepID_"||"_xSubID)
			Continue:'$IsObject(objLog)
			
			Set IsRemind = 1 
			Set RemindDate = xLogDate
			Set:RemindDate'="" RemindDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RemindDate) 
	
		}	
	}
	Set return = IsRemind_"^"_RemindDate
	Quit return
}

/// Creator：     ShenC
/// CreatDate：   2021-09-18
/// Description:  打印职业暴露报告基本信息
/// Table：       DHCHAI.IR.OccExpRegExt
/// Input:        aRepID:报告ID 
/// d ##class(%ResultSet).RunQuery("DHCHAI.IRS.OccExpRegSrv","PrintExpReg","1")
Query PrintExpReg(aRepID As %String) As %Query(ROWSPEC = "Title:%String,Name:%String,RegNo:%String,Sex:%String,Age:%String,TelPhone:%String,ExpDateTime:%String,ExpLoc:%String,RegUser:%String") [ SqlProc ]
{
}

ClassMethod PrintExpRegExecute(ByRef qHandle As %Binary, aRepID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aRepID="" $$$OK
	
	Set objReg = ##class(DHCHAI.IR.OccExpReg).GetObjById(aRepID)
	Quit:'$IsObject(objReg) return
    //报告类型
    Set objRegType=objReg.OERegTypeDr
    Quit:'$IsObject(objRegType) return
    Set RegType=objRegType.BTDesc
    Set Title=RegType_"报告单"
    //1.姓名
    Set Name=objReg.OEName
    //2.工号
    Set RegNo=objReg.OERegNo
    //3.性别
    Set Sex=objReg.OESex
    If (Sex="M"){
		Set Sex="男"
	}
	elseif (Sex="F"){
		Set Sex="女"
	}
	else{
		Set Sex="其他"
	}
    //4.年龄
    Set Age=objReg.OEAge
    //5.电话
    Set TelPhone=objReg.OETelPhone
    //6.暴露时间
    Set ExpDate=objReg.OEExpDate
    Set:ExpDate'="" ExpDate=$zd(ExpDate,3)
    /*
    Set ExpTime=objReg.OEExpTime
    Set:ExpTime'="" ExpTime=$zt(ExpTime,1)
    Set:ExpTime'="" ExpTime=$p(ExpTime,":",1,2)
    Set ExpDateTime=ExpDate_" "_ExpTime
    */
    Set ExpDateTime=ExpDate
    //7.所在科室
    Set objExpLoc=objReg.OEExpLocDr
    Set ExpLoc=""
    If ($IsObject(objExpLoc)){
	 	Set ExpLoc=objExpLoc.BTDesc
	}
    //8.登记人
    Set objRegUser=objReg.OERegUserDr
    Set RegUser=""
    If ($IsObject(objRegUser)){
	 	Set RegUser=objRegUser.BTDesc
	}
    
    Set Data=$lb(Title,Name,RegNo,Sex,Age,TelPhone,ExpDateTime,ExpLoc,RegUser)  
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod PrintExpRegClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PrintExpRegExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod PrintExpRegFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PrintExpRegExecute ]
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
/// CreatDate：   2018-07-04
/// Description:  打印职业暴露报告扩展信息
/// Table：       DHCHAI.IR.OccExpRegExt
/// Input:        aRepID:报告ID 
/// d ##class(%ResultSet).RunQuery("DHCHAI.IRS.OccExpRegSrv","PrintExpRegExt","13","1")
Query PrintExpRegExt(aRepID As %String, aTypeID As %String = "1") As %Query(ROWSPEC = "RepID:%String,SubID:%String,Code:%String,Desc:%String,DataType:%String,ResultTxt:%String") [ SqlProc ]
{
}

ClassMethod PrintExpRegExtExecute(ByRef qHandle As %Binary, aRepID As %String, aTypeID As %String = "1") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aRepID="" $$$OK
	
	Set objReg = ##class(DHCHAI.IR.OccExpReg).GetObjById(aRepID)
	Quit:'$IsObject(objReg) return
    
    Set xSubID = ""
	For {
		Set xSubID =$o(^DHCHAI.IR.OccExpRegD(aRepID,"EXT",xSubID))
		Quit:xSubID=""
		
		Set ExtID=aRepID_"||"_xSubID
		Set objExt = ##class(DHCHAI.IR.OccExpRegExt).GetObjById(ExtID)
	    Continue:'$IsObject(objExt) 
		Set objItemDr  = objExt.OEItemDr
	    Continue:'$IsObject(objItemDr)	
	    Set objExtType=objItemDr.BTExtType
	    Continue:'$IsObject(objExtType)	
	    Set ExtTypeCode=objExtType.BTCode
	    Continue:ExtTypeCode'[("-"_aTypeID)		//过滤类型[登记报告/审核观察]
	    //记录结果
	    Set ResultList=""
	    If (objExt.OEResultTxt'=""){
			Set ResultList=ResultList_"^"_objExt.OEResultTxt
		}
		If ($IsObject(objExt.OEResultDr)){
			Set ResultList=ResultList_"^"_objExt.OEResultDr.BTDesc
		}
		if (objExt.OEResultList.Count()>0){
			For indx = 1:1:objExt.OEResultList.Count(){
		 		Set objDic = objExt.OEResultList.GetAt(indx)
				Continue:'$IsObject(objDic)
					
				Set ResultList=ResultList_"^"_objDic.BTDesc
			}
		}
		Set Code 	  	= objItemDr.BTCode	 	//010100  
	    Set Desc 	  	= objItemDr.BTDesc	 	//工龄  	
		Set DataType   	= objExt.OEDataType  	//单选框
	    
	    Set:ResultList'="" ResultList=$p(ResultList,"^",2,$l(ResultList,"^"))
		Set Data=$lb(aRepID,xSubID,Code,Desc,DataType,ResultList)  
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod PrintExpRegExtClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PrintExpRegExtExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod PrintExpRegExtFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PrintExpRegExtExecute ]
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
/// CreatDate：   2018-07-05
/// Description:  打印职业暴露报告扩展信息
/// Table：       DHCHAI.IR.OccExpRegExt
/// Input:        aRepID:报告ID 
/// d ##class(%ResultSet).RunQuery("DHCHAI.IRS.OccExpRegSrv","PrintSinSelect","1")
Query PrintSinSelect(aRepID As %String) As %Query(ROWSPEC = "RepID:%String,SubID:%String,Code:%String,Desc:%String,DataType:%String,ResultID:%String,ResultCode:%String,ResultDesc:%String") [ SqlProc ]
{
}

ClassMethod PrintSinSelectExecute(ByRef qHandle As %Binary, aRepID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aRepID="" $$$OK
	
	Set objReg = ##class(DHCHAI.IR.OccExpReg).GetObjById(aRepID)
	Quit:'$IsObject(objReg) return
    
    Set xSubID = ""
	For {
		Set xSubID =$o(^DHCHAI.IR.OccExpRegD(aRepID,"EXT",xSubID))
		Quit:xSubID=""
		
		Set ExtID=aRepID_"||"_xSubID
		Set objExt = ##class(DHCHAI.IR.OccExpRegExt).GetObjById(ExtID)
	    Continue:'$IsObject(objExt) 
		Set objItemDr  = objExt.OEItemDr
	    Continue:'$IsObject(objItemDr)	    
	    Set Code 	  = objItemDr.BTCode	   
	    Set Desc 	  = objItemDr.BTDesc	   	
		Set DataType   = objExt.OEDataType  
		Continue:(DataType'="T")&&(DataType'="DS")&&(DataType'="DSL")&&(DataType'="S")&&(DataType'="B1")&&(DataType'="B2")
		Set objResult  = objExt.OEResultDr 
		Set ResultID="", ResultCode="",ResultDesc=""
		If $IsObject(objResult) {
			Set ResultID = objResult.%Id()
			Set ResultCode = objResult.BTCode
			Set ResultDesc = objResult.BTDesc
		}
		
		Set Data=$lb(aRepID,xSubID,Code,Desc,DataType,ResultID,ResultCode,ResultDesc)  
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	
	}
	Quit $$$OK
}

ClassMethod PrintSinSelectClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PrintSinSelectExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod PrintSinSelectFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PrintSinSelectExecute ]
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
/// CreatDate：   2018-07-05
/// Description:  打印职业暴露报告扩展信息
/// Table：       DHCHAI.IR.OccExpRegExt
/// Input:        aRepID:报告ID 
/// d ##class(%ResultSet).RunQuery("DHCHAI.IRS.OccExpRegSrv","PrintMultiSelect","1")
Query PrintMultiSelect(aRepID As %String) As %Query(ROWSPEC = "RepID:%String,xSubID:%String,Code:%String,Desc:%String,DataType:%String,ResultListID:%String,ResultListCode:%String,ResultListDesc:%String,Comps1:%String,Comps2:%String,Comps3:%String,Comps4:%String,Comps5:%String,Comps6:%String,Comps7:%String,Comps8:%String,Comps9:%String,Comps10:%String,Comps11:%String,Comps12:%String,Comps13:%String,Comps14:%String,Comps15:%String,Comps16:%String,Comps17:%String,Comps18:%String,Comps19:%String,Comps20:%String") [ SqlProc ]
{
}

ClassMethod PrintMultiSelectExecute(ByRef qHandle As %Binary, aRepID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aRepID="" $$$OK
	
	Set objReg = ##class(DHCHAI.IR.OccExpReg).GetObjById(aRepID)
	Quit:'$IsObject(objReg) return
    
    Set xSubID = ""
	For {
		Set xSubID =$o(^DHCHAI.IR.OccExpRegD(aRepID,"EXT",xSubID))
		Quit:xSubID=""
		
		Set ExtID=aRepID_"||"_xSubID
		Set objExt = ##class(DHCHAI.IR.OccExpRegExt).GetObjById(ExtID)
	    Continue:'$IsObject(objExt) 
		Set objItemDr  = objExt.OEItemDr
	    Continue:'$IsObject(objItemDr)	    
	    Set Code 	  = objItemDr.BTCode	   
	    Set Desc 	  = objItemDr.BTDesc	   	
		Set DataType   = objExt.OEDataType  
		Continue:(DataType'="DB")&&(DataType'="DBL")
		
		Set ResultList = objExt.OEResultList
		Set ResultListID="",ResultListCode="",ResultListDesc=""  
		//定义20个项目
		Set (Comps1,Comps2,Comps3,Comps4,Comps5,Comps6,Comps7,Comps8,Comps9,Comps10)="□"
		Set (Comps11,Comps12,Comps13,Comps14,Comps15,Comps16,Comps17,Comps18,Comps19,Comps20)="□"
		For indx = 1:1:ResultList.Count(){
		 	Set objDic = ResultList.GetAt(indx)
			Continue:'$IsObject(objDic)	
			Set ResultListID=ResultListID_","_objDic.%Id()
			Set ResultListCode=ResultListCode_","_objDic.BTCode
			Set ResultListDesc=ResultListDesc_","_objDic.BTDesc
			Set:objDic.BTCode=1 Comps1="☑"
			Set:objDic.BTCode=2 Comps2="☑"
			Set:objDic.BTCode=3 Comps3="☑"
			Set:objDic.BTCode=4 Comps4="☑"
			Set:objDic.BTCode=5 Comps5="☑"
			Set:objDic.BTCode=6 Comps6="☑"
			Set:objDic.BTCode=7 Comps7="☑"
			Set:objDic.BTCode=8 Comps8="☑"
			Set:objDic.BTCode=9 Comps9="☑"
			Set:objDic.BTCode=10 Comps10="☑"
			Set:objDic.BTCode=11 Comps11="☑"
			Set:objDic.BTCode=12 Comps12="☑"
			Set:objDic.BTCode=13 Comps13="☑"
			Set:objDic.BTCode=14 Comps14="☑"
			Set:objDic.BTCode=15 Comps15="☑"
			Set:objDic.BTCode=16 Comps16="☑"
			Set:objDic.BTCode=17 Comps17="☑"
			Set:objDic.BTCode=18 Comps18="☑"
			Set:objDic.BTCode=19 Comps19="☑"
			Set:objDic.BTCode=20 Comps20="☑"
		  
		} 
		Set:ResultListID'="" ResultListID=$e(ResultListID,2,$l(ResultListID))
		Set:ResultListCode'="" ResultListCode=$e(ResultListCode,2,$l(ResultListCode))
		Set:ResultListDesc'="" ResultListDesc=$e(ResultListDesc,2,$l(ResultListDesc))

		Set Data=$lb(aRepID,xSubID,Code,Desc,DataType,ResultListID,ResultListCode,ResultListDesc,Comps1,Comps2,Comps3,Comps4,Comps5,Comps6,Comps7,Comps8,Comps9,Comps10,Comps11,Comps12,Comps13,Comps14,Comps15,Comps16,Comps17,Comps18,Comps19,Comps20)  
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	
	}
	Quit $$$OK
}

ClassMethod PrintMultiSelectClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PrintMultiSelectExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod PrintMultiSelectFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PrintMultiSelectExecute ]
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
/// CreatDate：   2019-01-23
/// Description:  职业暴露-取暴露源部分检验医嘱(包含输血8项、感染4项、乙型肝炎、丙型肝炎、乙肝、丙肝、梅毒、艾滋病的检验医嘱)
/// Table：       DHCHAI.IR.OccExpRegExt
/// Input:        就诊号、检验医嘱关键词 
/// w ##class(DHCHAI.IRS.OccExpRegSrv).GetLabTestSet("162112","")
ClassMethod GetLabTestSet(aEpisodeID As %String, aAlias As %String = "") As %String
{
	New (aEpisodeID, aAlias)
	Set return=""
	Quit:aEpisodeID="" return
	
	Set:aAlias="" aAlias="输血8项|感染4项|乙型肝炎|丙型肝炎|乙肝|丙肝|梅毒|艾滋病" //默认筛选项目
	Set aAlias=##class(DHCHAI.Utils.CommonSrv).ListFromString(aAlias,"|")
	
	Set IsHandle=0 //是否开相关医嘱
	Set IsPositive=0 //是否包含阳性
	
    Set xVisitNumberDr=""
	For {
		Set xVisitNumberDr=$o(^DHCHAI.DP.LabVisitNumberI("IndexEpisodeDr",aEpisodeID,xVisitNumberDr))
		Quit:xVisitNumberDr=""
		
		Set objVisitNumber=##class(DHCHAI.DP.LabVisitNumber).GetObjById(xVisitNumberDr) //检验标本
		Continue:'$isobject(objVisitNumber)
		Continue:objVisitNumber.LabIsActive'=1
    	
    	Set xUpdateDate=""
		For {
			Set xUpdateDate=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitUpdateDate",xVisitNumberDr,xUpdateDate))
			Quit:xUpdateDate=""
			
			Set xVisitReportDr=""
			For {
				Set xVisitReportDr=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitUpdateDate",xVisitNumberDr,xUpdateDate,xVisitReportDr))
				Quit:xVisitReportDr=""
				
				Set objVisitReport=##class(DHCHAI.DP.LabVisitReport).GetReportByID(xVisitReportDr)
				Continue:'$IsObject(objVisitReport)
				
				Set Status = objVisitReport.LabStatus
				//Continue:Status=6	//作废
				Set IsActive = objVisitReport.LabIsActive
				Continue:IsActive=0
				
				Set LabTestSetDr=objVisitReport.LabTestSetDr //检验医嘱
				Continue:'$IsObject(LabTestSetDr)
				Set LabTestSetID=LabTestSetDr.%Id()
				Set LabTestSetCode=LabTestSetDr.LabTestSetCode //检验医嘱
				Set LabTestSetDesc=LabTestSetDr.LabTestSetDesc
				
				Set LabOrdTSCode=LabTestSetDr.LabOrdTSCode //医嘱项
				Set LabOrdTSDesc=LabTestSetDr.LabOrdTSDesc
				//过滤医嘱项
				If (aAlias'="") {
					Set IsInclude=0 //是否包含
					For xAliasInd=1:1:$ListLength(aAlias) {
						Set xAlias=$List(aAlias,xAliasInd)
						Set:LabOrdTSDesc[xAlias IsInclude=1
						
						Quit:IsInclude=1
					}
					Continue:IsInclude=0 //不包含时过滤
					Set IsHandle=1
				}
				
				Set xResultID=""
				For {
					Set xResultID = $o(^DHCHAI.DP.LabVisitRepResultI("IndexLabReportDr",xVisitReportDr,xResultID))
					Quit:xResultID=""
					
					Set objResult = ##class(DHCHAI.DP.LabVisitRepResult).GetObjById(xResultID)
					Continue:'$isobject(objResult)
					
					Set TestDesc 	= objResult.LabTestDesc
					Set TestCode 	= objResult.LabTestCode
					Set RstFormat 	= objResult.LabRstFormat
					Set Result 		= objResult.LabResult
					Set TextRes 	= objResult.LabTextRes
					Set ResNoes 	= objResult.LabResNoes
					Set AbFlag 		= objResult.LabAbFlag	//异常提示
					Set Unit 		= objResult.LabUnit
					Set RefRanges 	= objResult.LabRefRanges
					Set MDRResult 	= objResult.LabMDRResult
					
					If (AbFlag=""){
						Continue:Result'["阳性"		//过滤出阳性结果
					} Else {
						Set Result=Result_"("_AbFlag_")"	//当存在异常提示时，结果为待确证，但属于异常
					}
					Set IsPositive=1
					Set ResultInfo	= Result_"-"_LabOrdTSDesc_"-"_TestDesc
					Set return=return_" | "_ResultInfo
				}
			}
		}
	}
	Set:return'="" return=$e(return,4,$Length(return))
	Set:IsHandle=0 return="感染四项不详"
	Set:(IsHandle=1)&&(IsPositive=0) return="感染四项均阴性"
	Quit return
}

/// Creator：     ShenC
/// CreatDate：   2022-01-26
/// Description:  打印职业暴露检验结果信息
/// Table：       DHCHAI.IR.OccExpRegExt
/// Input:        aRepID:报告ID 
/// d ##class(%ResultSet).RunQuery("DHCHAI.IRS.OccExpRegSrv","PrintLabSelect","1")
Query PrintLabSelect(aRepID As %String) As %Query(ROWSPEC = "Desc:%String,Days:%String,LabDate:%String,LabItem:%String,Result:%String") [ SqlProc ]
{
}

ClassMethod PrintLabSelectExecute(ByRef qHandle As %Binary, aRepID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set NIndex="PrintLabSelect"
	Kill ^TMP($zn,$j,NIndex)	
	
	Quit:aRepID="" $$$OK
	
	Set RegData=$g(^DHCHAI.IR.OccExpRegD(aRepID))
	Quit:RegData="" return

    //1.检验类别(HBV|HCV|HIV|梅毒)
    Set LabList=$lg(RegData,21)
    //2.登记类型
    Set TypeID=$lg(RegData,2)
    Quit:TypeID="" 
   
	//循环血清学检验
    Set xID=0	
	For {
		Set xID=$o(^DHCHAI.IR.OccExpTypeD(TypeID,"LAB",xID))
		Quit:xID=""
		
		Set LabID=TypeID_"||"_xID
		//职业暴露血清学检查计划
		Set LABData=$g(^DHCHAI.IR.OccExpTypeD(TypeID,"LAB",xID)) 
		//b:LABData'=""
		Continue:LABData=""
	  	Set IsActive  =$lg(LABData,5) 
		Continue:IsActive'=1
	   	Set Desc 	  = $lg(LABData,2) 			//名称
	   	Set LabType="LAB"
	 	Set:Desc["HBV" LabType="HBV" 
	 	Set:Desc["HCV" LabType="HCV" 
	 	Set:Desc["HIV" LabType="HIV" 
	 	Set:Desc["梅毒" LabType="MD" 
	 	Continue:LabList'[LabType
	   	Set Days 	  = $lg(LABData,6) 				//时间间隔
	   	
	    Set IndNo 	  = $lg(LABData,3) 			
	    Set:IndNo="" IndNo="0"	//解决为空报错
	    
	   	Set LabDate="检验日期：",LabItem="检验项目：",Result="检验结果："
	   	//是否已填写内容
	   	Set RegLabID=$o(^DHCHAI.IR.OccExpRegI("LAB","IndexLabTim",aRepID,LabID,""))
	   	If (RegLabID'=""){

		   	//职业暴露填写内容
		   	Set RepLabData =$g(^DHCHAI.IR.OccExpRegD(aRepID,"LAB",RegLabID))
		   			   
		   	Continue:RepLabData=""

		   	Set LabTimID=$lg(RepLabData,2) //OELabTimDr
		   	Set LabTimID=$p(LabTimID,"||",2)
		   	Set LabTimData=$g(^DHCHAI.IR.OccExpTypeD(TypeID,"LAB",LabTimID))
		   	Continue:LabTimData=""
	
	   		Set IsActive  =$lg(LabTimData,5)
	   		Continue:IsActive'=1
	   		
			Set LabDate   =$lg(RepLabData,3) 	//日期
			Set:LabDate'="" LabDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(LabDate)  
			Set LabDate="检验日期："_LabDate
			Set LabItem   =$lg(RepLabData,4) 	//项目
			Set LabItem="检验项目："_LabItem
			Set Result    =$lg(RepLabData,5)  	//结果
			Set Result="检验结果："_$p(Result,"|",2)
		}
		//存储数据
		Set ^TMP($zn,$j,NIndex,"IndNo",IndNo,LabID)=$lb(Desc,Days,LabDate,LabItem,Result)
	}
	Set xIndNo=""
	For {
		Set xIndNo=$o(^TMP($zn,$j,NIndex,"IndNo",xIndNo))
		Quit:xIndNo=""
		
		Set xLabID=""
		for{
			Set xLabID=$o(^TMP($zn,$j,NIndex,"IndNo",xIndNo,xLabID))
			Quit:xLabID=""
		
			Set Data=$g(^TMP($zn,$j,NIndex,"IndNo",xIndNo,xLabID))
			Continue:Data=""
			
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod PrintLabSelectClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PrintLabSelectExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod PrintLabSelectFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PrintLabSelectExecute ]
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

/// Creator：     ShenC
/// CreatDate：   2022-09-01
/// Description:  职业暴露-获取报告完成状态(1:已完成,2:未完成)
/// Table：       DHCHAI.IR.OccExpRegExt
/// Input:        就诊号、检验医嘱关键词 
/// w ##class(DHCHAI.IRS.OccExpRegSrv).GetLabStatus("12")
ClassMethod GetLabStatus(aTypeID As %String, aRepID As %String) As %String
{
	New (aTypeID,aRepID)
	Set return=""
	Quit:(aTypeID="")||(aRepID="") return
	//报告关联检验类别[HBV,HCV,HIV,梅毒]
	Set LabList=##class(DHCHAI.IR.OccExpReg).GetOELabList(aRepID)
	
	//须填写+已填写
	Set NeedCnt=0,SuccessCnt=0
	
	Set xID=0	
	For {
		Set xID=$o(^DHCHAI.IR.OccExpTypeD(aTypeID,"LAB",xID))
		Quit:xID=""
		
		Set LabID=aTypeID_"||"_xID
		Set objRegLab = ##class(DHCHAI.IR.OccExpTypeLab).GetObjById(LabID)
		Continue:'$Isobject(objRegLab)
	   
	    Set Desc 	  = objRegLab.BTDesc
	    Set LabType="LAB"
	 	Set:Desc["HBV" LabType="HBV" 
	 	Set:Desc["HCV" LabType="HCV" 
	 	Set:Desc["HIV" LabType="HIV" 
	 	Set:Desc["梅毒" LabType="MD" 
	 	Continue:(","_LabList_",")'[LabType			//过滤无需显示类别
	 	Set NeedCnt=NeedCnt+1
	 	
	 	Set xRepLabID=""
	 	For{
			Set xRepLabID=$o(^DHCHAI.IR.OccExpRegI("LAB","IndexLabTim",aRepID,LabID,xRepLabID)) 
			Quit:xRepLabID=""
			
			Set objOccLab = ##class(DHCHAI.IR.OccExpRegLab).GetObjById(aRepID_"||"_xRepLabID)
	    	Continue:'$IsObject(objOccLab) 
	   		Set objLabTim  = objOccLab.OELabTimDr
	   		Continue:'$IsObject(objLabTim) 
	   		Set IsActive  = objLabTim.BTIsActive
	   		Continue:IsActive'=1
			Set Result    = objOccLab.OEResult
			Set:Result'="" Result=$p(Result,"|",2)
			Set:Result'="" SuccessCnt=SuccessCnt+1
		}
	}
	If (NeedCnt=SuccessCnt){
		Set return=1
	}
	else{
		Set return=2
	}
	
	Quit return
}

}
