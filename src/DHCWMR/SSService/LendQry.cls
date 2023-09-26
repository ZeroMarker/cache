/// 名称: DHCWMR.SSService.LendQry
/// 描述: 病案借阅相关查询
/// 编写者：liyi
/// 编写日期: 2015-10-10
Class DHCWMR.SSService.LendQry Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liyi
/// CreatDate：   2015-10-10
/// Description:  借阅综合查询
/// Table：       
/// Input：       
/// Return：      返回Query
/// do ##class(%Library.ResultSet).RunQuery("DHCWMR.SSService.LendQry","QryLend",""2^7^LL^2015-11-30^2015-11-30^^^"")
Query QryLend(ArgInput As %String) As %Query(ROWSPEC = "ID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,HospDesc:%String,StatusDesc:%String,LendDate:%String,LendLoc:%String,LendUser:%String,BackDate:%String,BackUser:%String")
{
}

ClassMethod QryLendExecute(ByRef qHandle As %Binary, ArgInput As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	//Set ^LIYI=ArgInput
	Quit:ArgInput="" $$$OK

	Set aHospID 	=  $p(ArgInput,"^",1)
	Set aMrTypeID 	=  $p(ArgInput,"^",2)
	Set aOperation 	=  $p(ArgInput,"^",3)
	Set aDateFrom 	=  $p(ArgInput,"^",4)
	Set aDateTo 	=  $p(ArgInput,"^",5)
	Set aLendLoc 	=  $p(ArgInput,"^",6)
	Set aLendUser 	=  $p(ArgInput,"^",7)		//医护人员ID
	Set aMrNo 		=  $p(ArgInput,"^",8)
	Set aLendUserCode=""
	Set:aLendUser'="" aLendUserCode = $p($g(^CTPCP(aLendUser,1)),"^",1)
	
	Quit:(aHospID="")||(aMrTypeID="")||(aDateFrom="")||(aDateTo="") $$$OK
	Set:aHospID'="" aHospID=","_aHospID_","
	
	Set aDateFrom=##Class(DHCWMR.SSService.CommonSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCWMR.SSService.CommonSrv).DateHtmlToLogical(aDateTo)
	Set:aDateFrom'="" aDateFrom=+aDateFrom
	Set:aDateTo'="" aDateTo=+aDateTo
	
	Set aWorkItemID=""
	Set objWFItem=##class(DHCWMR.SS.WorkFItem).GetWFItemBySysOpera(aMrTypeID,aOperation)
	Set:objWFItem'="" aWorkItemID=objWFItem.WFIItem.%Id()
	If (aMrNo=""){
		For xDate = aDateFrom:1:aDateTo{
			Set xTime = ""
			For {
				Set xTime=$o(^DHCWMR.MO.LendRecordI("STATUS","IndexActDateTime",xDate,xTime))
				Quit:xTime=""
				
				Set xLendRecordID=""
				For {
					Set xLendRecordID=$o(^DHCWMR.MO.LendRecordI("STATUS","IndexActDateTime",xDate,xTime,xLendRecordID))
					Quit:xLendRecordID=""
					
					Set objLendRecord = ##class(DHCWMR.MO.LendRecord).GetObjById(xLendRecordID)
					Continue:'$IsObject(objLendRecord)
					Continue:aMrTypeID'=objLendRecord.LRMrType.%Id()
					Continue:(aLendLoc'="")&&(aLendLoc'=objLendRecord.LRLocID)
					Continue:(aLendUserCode'="")&&(aLendUserCode'=objLendRecord.LRUserCode)
					Set xSubID=""
					For {
						Set xSubID=$o(^DHCWMR.MO.LendRecordI("STATUS","IndexActDateTime",xDate,xTime,xLendRecordID,xSubID))
						Quit:xSubID=""
						
						Set objLendRecordStatus = ##class(DHCWMR.MO.LendRecordStatus).GetObjById(xLendRecordID_"||"_xSubID)
						Continue:'$IsObject(objLendRecordStatus)
						
						Set objStatus = objLendRecordStatus.RStatus
						Continue:(aWorkItemID'="")&&(aWorkItemID'=objStatus.%Id())
						
						Do BuildLendList
					}
				}
			}
		}
	}else{
		Set xMainID=""
		For{
			Set xMainID=$o(^DHCWMR.SS.MainI("IndexTypeNoAct",aMrTypeID," "_aMrNo,1,xMainID))
			Quit:xMainID=""
			
			Set objMain=##class(DHCWMR.SS.Main).GetObjById(xMainID)
			Continue:'$IsObject(objMain)
			
			//处理修改病案号之后的历史数据
			Set HisMainIDs=##class(DHCWMR.SS.Main).GetHisMainByID(xMainID)
			If HisMainIDs'="" {
				Set flg=##Class(DHCWMR.MO.LendRecord).UpdateErrorMainDr(HisMainIDs)
			}
			
			Set xLendRecordID=""
			For {
				Set xLendRecordID=$o(^DHCWMR.MO.LendRecordI("IndexMainDr",xMainID,xLendRecordID))
				Quit:xLendRecordID=""
				
				Set objLendRecord = ##class(DHCWMR.MO.LendRecord).GetObjById(xLendRecordID)
				Continue:'$IsObject(objLendRecord)
				Continue:aMrTypeID'=objLendRecord.LRMrType.%Id()
				Continue:(aLendLoc'="")&&(aLendLoc'=objLendRecord.LRLocID)
				Continue:(aLendUserCode'="")&&(aLendUserCode'=objLendRecord.LRUserCode)
				For indStatus=1:1:objLendRecord.ChildStatus.Count() {
					Set objLendRecordStatus=objLendRecord.ChildStatus.GetAt(indStatus)
					Continue:'$IsObject(objLendRecordStatus)
					Set objStatus = objLendRecordStatus.RStatus
					Continue:(aWorkItemID'="")&&(aWorkItemID'=objStatus.%Id())
					
					Do BuildLendList
				}
			}
		}
	}
	Quit $$$OK
	
BuildLendList
	Set ID =xLendRecordID
	Set MrNo = objLendRecord.LRMainDr.SMMrNo
	Quit:objLendRecord.LRMainDr.SMIsActive=0
	Set PatientID = ##class(DHCWMR.SSService.MrNoSrv).GetPatientIDByMrNo(MrNo,aMrTypeID)
	Quit:PatientID=""
	Set PapmiNo=$p(^PAPER(PatientID,"PAT",1),"^",1)            //登记号
	Set PatName=$p($g(^PAPER(PatientID,"ALL")),"^",1)          //姓名
	Set Sex=$p($g(^PAPER(PatientID,"ALL")),"^",7)              //性别
	Set:Sex'="" Sex=$p($g(^CT("SEX",Sex)),"^",2)
	Set Age=##class(DHCWMR.IO.FromHisSrv).GetPapmiAge(PatientID,"","","")  //年龄
	Set FirstHosp = objLendRecord.LRMainDr.SMFirstHosp		   //归属院区
	Set:FirstHosp="" FirstHosp=##class(DHCWMR.SSService.HospitalSrv).GetCTHospID(objLendRecord.LRLocID)
	Quit:(aHospID'="")&&(FirstHosp'="")&&(aHospID'[(","_FirstHosp_","))
	Set HospCode = ##class(DHCWMR.SSService.HospitalSrv).GetSSHospCode(FirstHosp)
	Set SSHospID = $o(^DHCWMR.SS.HospitalI("IndexCode"," "_HospCode," "_FirstHosp,""))
	Set objSSHosp = ##class(DHCWMR.SS.Hospital).GetObjById(SSHospID)
	//Quit:'$IsObject(objSSHosp)&&(FirstHosp'="")
	Set HospDesc=""
	Set:$IsObject(objSSHosp) HospDesc=objSSHosp.SHDesc
	Set LendDate = objLendRecord.LRLendDate
	Set:LendDate'="" LendDate=##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(LendDate)
	Set LendLoc = objLendRecord.LRLocID
	Set:LendLoc'="" LendLoc=$p($g(^CTLOC(+LendLoc)),"^",2)
	Set:LendLoc["-" LendLoc=$p(LendLoc,"-",2)
	Set LendUser = objLendRecord.LRLendUser
	Set:LendUser'="" LendUser=$p($g(^SSU("SSUSR",LendUser)),"^",2)
	Set BackDate = objLendRecord.LRBackDate
	Set:BackDate'="" BackDate=##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(BackDate)
	Set BackUser = objLendRecord.LRBackUser
	Set:BackUser'="" BackUser=$p($g(^SSU("SSUSR",BackUser)),"^",2)
	//modify by mxp 2018-03-15 借阅已归还,查询结果当前状态仍显示“病案借阅”
	Set StatusDesc = objStatus.WIDesc
	If BackDate'="" {
		Set objWFItem=##class(DHCWMR.SS.WorkFItem).GetWFItemBySysOpera(aMrTypeID,"LB")
		Set:$IsObject(objWFItem) StatusDesc=objWFItem.WFIItem.WIDesc
	}
	
	Set Data=$lb(ID,PapmiNo,MrNo,PatName,Sex,Age,HospDesc,StatusDesc,LendDate,LendLoc,LendUser,BackDate,BackUser)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod QryLendClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLendExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryLendFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLendExecute ]
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

/// Creator：     liyi
/// CreatDate：   2015-10-10
/// Description:  未还回病历科室汇总
/// Table：       
/// Input：       
/// Return：      返回Query
/// do ##class(%Library.ResultSet).RunQuery("DHCWMR.SSService.LendQry","QryNotBackCollect","2","7","2015-09-09","2016-11-29")
Query QryNotBackCollect(aHospID As %String, aMrTypeID As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "ID:%String,LendLoc:%String,LendUser:%String,LendLocDesc:%String,LendUserDesc:%String,LendSum:%String")
{
}

ClassMethod QryNotBackCollectExecute(ByRef qHandle As %Binary, aHospID As %String, aMrTypeID As %String, aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)

	Set aDateFrom=##Class(DHCWMR.SSService.CommonSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCWMR.SSService.CommonSrv).DateHtmlToLogical(aDateTo)
	Set:aDateFrom'="" aDateFrom=+aDateFrom
	Set:aDateTo'="" aDateTo=+aDateTo
	Quit:(aHospID="")||(aMrTypeID="")||(aDateFrom="")||(aDateTo="") $$$OK
	Set:aHospID'="" aHospID=","_aHospID_","
	
	Kill ^TMP($zn,$j,"QryNotBackCollect")
	
	For xDate=aDateFrom:1:aDateTo{
		Set xLendRecordID=""
		For{
			Set xLendRecordID=$o(^DHCWMR.MO.LendRecordI("IndexMrTypeLendDateStatus",aMrTypeID,xDate," L",xLendRecordID))
			Quit:xLendRecordID=""
			
			Set objLendRecord=##class(DHCWMR.MO.LendRecord).GetObjById(xLendRecordID)
			Continue:'$IsObject(objLendRecord)
			Continue:objLendRecord.LRMainDr.SMIsActive=0
		
			Set FirstHosp = objLendRecord.LRMainDr.SMFirstHosp		   //归属院区
			Continue:(aHospID'="")&&(FirstHosp'="")&&(aHospID'[(","_FirstHosp_","))
			Continue:'objLendRecord.LRStatus="L"
			Set LendLoc  = objLendRecord.LRLocID
			If (aHospID'="")&&(FirstHosp="") {
				Set AdmHospID=##class(DHCWMR.SSService.HospitalSrv).GetCTHospID(LendLoc)
				Continue:(aHospID'[(","_AdmHospID_","))  //检查院区是否符合
			}
			Set LendUserCode = objLendRecord.LRUserCode
			
			If (LendUserCode'=""){
				Set ^TMP($zn,$j,"QryNotBackCollect",LendLoc,LendUserCode)=+$g(^TMP($zn,$j,"QryNotBackCollect",LendLoc,LendUserCode))+1
			}else{
				Set ^TMP($zn,$j,"QryNotBackCollect",LendLoc)=+$g(^TMP($zn,$j,"QryNotBackCollect",LendLoc))+1
			}
			
		}
	}
	Set xLoc=""
	For {
		Set xLoc = $o(^TMP($zn,$j,"QryNotBackCollect",xLoc))
		Quit:xLoc=""
		
		Set LocDesc  = $p($g(^CTLOC(+xLoc)),"^",2)
		Set:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
		Set xUserCode = ""
		For {
			Set xUserCode = $o(^TMP($zn,$j,"QryNotBackCollect",xLoc,xUserCode))
			Quit:xUserCode=""
			
			Set UserDesc=""
			Set LCareProvID=$o(^CTPCP(0,"Code",xUserCode,""))
			Set:LCareProvID'="" UserDesc=$p($g(^CTPCP(LCareProvID,1)),"^",2)
			Set Sum=+$g(^TMP($zn,$j,"QryNotBackCollect",xLoc,xUserCode))
			Set Data=$lb(ind,xLoc,xUserCode,LocDesc,UserDesc,Sum)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
		Set Sum=+$g(^TMP($zn,$j,"QryNotBackCollect",xLoc))
		If (Sum>0)
		{
			Set UserDesc="",xUserCode=""
			Set Data=$lb(ind,xLoc,xUserCode,LocDesc,UserDesc,Sum)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}		
	Kill ^TMP($zn,$j,"QryNotBackCollect")
	Quit $$$OK
}

ClassMethod QryNotBackCollectClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryNotBackCollectExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryNotBackCollectFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryNotBackCollectExecute ]
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

/// Creator：     liyi
/// CreatDate：   2015-10-10
/// Description:  未还回病历科室明细
/// Table：       
/// Input：       
/// Return：      返回Query
/// do ##class(%Library.ResultSet).RunQuery("DHCWMR.SSService.LendQry","QryNotBackDetail","")
Query QryNotBackDetail(ArgInput As %String) As %Query(ROWSPEC = "ID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,LendLoc:%String,LendUser:%String,LendDate:%String,UpdateUser:%String,BackUser:%String")
{
}

ClassMethod QryNotBackDetailExecute(ByRef qHandle As %Binary, ArgInput As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Set aHospID   		= $p(ArgInput,"^",1)
	Set aMrTypeID 		= $p(ArgInput,"^",2)
	Set aDateFrom	 	= $p(ArgInput,"^",3)
	Set aDateTo   		= $p(ArgInput,"^",4)
	Set aLendLoc  		= $p(ArgInput,"^",5)
	Set aLendUserCode 	= $p(ArgInput,"^",6)

	Set aDateFrom=##Class(DHCWMR.SSService.CommonSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCWMR.SSService.CommonSrv).DateHtmlToLogical(aDateTo)
	Set:aDateFrom'="" aDateFrom=+aDateFrom
	Set:aDateTo'="" aDateTo=+aDateTo
	Quit:(aHospID="")||(aMrTypeID="")||(aDateFrom="")||(aDateTo="")||(aLendLoc="") $$$OK
	Set:aHospID'="" aHospID=","_aHospID_","
	
	For xDate=aDateFrom:1:aDateTo{
		Set xLendRecordID=""
		For{
			Set xLendRecordID=$o(^DHCWMR.MO.LendRecordI("IndexMrTypeLendDateStatus",aMrTypeID,xDate," L",xLendRecordID))
			Quit:xLendRecordID=""
			
			Set objLendRecord=##class(DHCWMR.MO.LendRecord).GetObjById(xLendRecordID)
			Continue:'$IsObject(objLendRecord)
			Continue:objLendRecord.LRMainDr.SMIsActive=0
			
			Set FirstHosp = objLendRecord.LRMainDr.SMFirstHosp		   //归属院区
			Continue:(aHospID'="")&&(FirstHosp'="")&&(aHospID'[(","_FirstHosp_","))
			
			Set LendLoc  = objLendRecord.LRLocID
			Set LendUserCode = objLendRecord.LRUserCode
			Continue:LendLoc'=aLendLoc
			If (aHospID'="")&&(FirstHosp="") {
				Set AdmHospID=##class(DHCWMR.SSService.HospitalSrv).GetCTHospID(LendLoc)
				Continue:(aHospID'[(","_AdmHospID_","))  //检查院区是否符合
			}
			
			Continue:LendUserCode'=aLendUserCode
			D BuildDetailList
		}
	}

	Quit $$$OK

BuildDetailList
	Set ID =xLendRecordID
	Set MrNo = objLendRecord.LRMainDr.SMMrNo
	Set PatientID = ##class(DHCWMR.SSService.MrNoSrv).GetPatientIDByMrNo(MrNo,aMrTypeID)
	Set PapmiNo=$p(^PAPER(PatientID,"PAT",1),"^",1)            //登记号
	Set PatName=$p($g(^PAPER(PatientID,"ALL")),"^",1)          //姓名
	Set Sex=$p($g(^PAPER(PatientID,"ALL")),"^",7)              //性别
	Set:Sex'="" Sex=$p($g(^CT("SEX",Sex)),"^",2)
	Set Age=##class(DHCWMR.IO.FromHisSrv).GetPapmiAge(PatientID,"","","")  //年龄
	Set LendDate = objLendRecord.LRLendDate
	Set:LendDate'="" LendDate=##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(LendDate)
	Set LendLoc = objLendRecord.LRLocID
	Set:LendLoc'="" LendLoc=$p($g(^CTLOC(+LendLoc)),"^",2)
	Set:LendLoc["-" LendLoc=$p(LendLoc,"-",2)
	Set LendUser="",LCareProvID=""
	Set:LendUserCode'="" LCareProvID=$o(^CTPCP(0,"Code",LendUserCode,""))
	Set:LCareProvID'="" LendUser=$p($g(^CTPCP(LCareProvID,1)),"^",2)	
	Set BackUser = objLendRecord.LRBackUser
	Set:BackUser'="" BackUser=$p($g(^SSU("SSUSR",BackUser)),"^",2)
	Set UpdateUser = objLendRecord.LRUpdateUser
	Set:UpdateUser'="" UpdateUser=$p($g(^SSU("SSUSR",UpdateUser)),"^",2)
	
	Set Data=$lb(ID,PapmiNo,MrNo,PatName,Sex,Age,LendLoc,LendUser,LendDate,UpdateUser,BackUser)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
			
	Quit
}

ClassMethod QryNotBackDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryNotBackDetailExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryNotBackDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryNotBackDetailExecute ]
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

/// Creator：     liyi
/// CreatDate：   2015-11-15
/// Description:  科室借阅查询
/// Table：       
/// Input：       
/// Return：      返回Query
/// do ##class(%Library.ResultSet).RunQuery("DHCWMR.SSService.LendQry","QryLocLend","2",6,"2016-05-10","2016-12-12","",1)
Query QryLocLend(aHospID As %String, aMrTypeID As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String, aBackFlg As %String) As %Query(ROWSPEC = "ID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,LendLoc:%String,LendUser:%String,LendDate:%String,UpdateUser:%String,BackUser:%String")
{
}

ClassMethod QryLocLendExecute(ByRef qHandle As %Binary, aHospID As %String, aMrTypeID As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String, aBackFlg As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set aDateFrom=##Class(DHCWMR.SSService.CommonSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCWMR.SSService.CommonSrv).DateHtmlToLogical(aDateTo)
	Set:aDateFrom'="" aDateFrom=+aDateFrom
	Set:aDateTo'="" aDateTo=+aDateTo
	
	Quit:(aHospID="")||(aMrTypeID="")||(aDateFrom="")||(aDateTo="")||(aBackFlg="") $$$OK
	Set:aHospID'="" aHospID=","_aHospID_","
	
	For xDate = aDateFrom:1:aDateTo{
		Set xStatus = ""
		For {
			Set xStatus = $o(^DHCWMR.MO.LendRecordI("IndexMrTypeLendDateStatus",aMrTypeID,xDate,xStatus))
			Quit:xStatus=""

			Set xLendRecordID = ""
			For {
				Set xLendRecordID = $o(^DHCWMR.MO.LendRecordI("IndexMrTypeLendDateStatus",aMrTypeID,xDate,xStatus,xLendRecordID))
				Quit:xLendRecordID=""
				
				Set objLendRecord = ##class(DHCWMR.MO.LendRecord).GetObjById(xLendRecordID)
				Continue:'$IsObject(objLendRecord)
				Continue:'$IsObject(objLendRecord.LRMainDr)
				
				Set FirstHosp = objLendRecord.LRMainDr.SMFirstHosp		   //归属院区
				Continue:(aHospID'="")&&(FirstHosp'="")&&(aHospID'[(","_FirstHosp_","))
				
				Set LendLoc  = objLendRecord.LRLocID
				Continue:(aLocID'="")&&(aLocID'=LendLoc)
				If (aHospID'="")&&(FirstHosp="") {
					Set AdmHospID=##class(DHCWMR.SSService.HospitalSrv).GetCTHospID(LendLoc)
					Continue:(aHospID'[(","_AdmHospID_","))  //检查院区是否符合
				}				
				
				Set Status = objLendRecord.LRStatus
				
				Continue:(aBackFlg=1)&&(Status="L")
				Continue:(aBackFlg=0)&&((Status="U")||(Status="R")||(Status="B"))
				D BuildLocLend
			}
		}
	}
	
	Quit $$$OK
	
BuildLocLend
	Set ID =xLendRecordID
	Set MrNo = objLendRecord.LRMainDr.SMMrNo
	Set PatientID = ##class(DHCWMR.SSService.MrNoSrv).GetPatientIDByMrNo(MrNo,aMrTypeID)
	Quit:PatientID=""
	Set PapmiNo=$p(^PAPER(PatientID,"PAT",1),"^",1)            //登记号
	Set PatName=$p($g(^PAPER(PatientID,"ALL")),"^",1)          //姓名
	Set Sex=$p($g(^PAPER(PatientID,"ALL")),"^",7)              //性别
	Set:Sex'="" Sex=$p($g(^CT("SEX",Sex)),"^",2)
	Set Age=##class(DHCWMR.IO.FromHisSrv).GetPapmiAge(PatientID,"","","")  //年龄
	Set LendDate = objLendRecord.LRLendDate
	Set:LendDate'="" LendDate=##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(LendDate)
	Set LendLoc = objLendRecord.LRLocID
	Set:LendLoc'="" LendLoc=$p($g(^CTLOC(+LendLoc)),"^",2)
	Set:LendLoc["-" LendLoc=$p(LendLoc,"-",2)
	Set LUserCode=objLendRecord.LRUserCode
	Set LendUser=""
	If (LUserCode'=""){
		Set LCareProvID=$o(^CTPCP(0,"Code",LUserCode,""))
		Set:LCareProvID'="" LendUser=$p($g(^CTPCP(LCareProvID,1)),"^",2)
	}
	Set BackUser = objLendRecord.LRBackUser
	Set:BackUser'="" BackUser=$p($g(^SSU("SSUSR",BackUser)),"^",2)
	Set UpdateUser = objLendRecord.LRUpdateUser
	Set:UpdateUser'="" UpdateUser=$p($g(^SSU("SSUSR",UpdateUser)),"^",2)
	Set Data=$lb(ID,PapmiNo,MrNo,PatName,Sex,Age,LendLoc,LendUser,LendDate,UpdateUser,BackUser)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
			
	Quit
}

ClassMethod QryLocLendClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLocLendExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryLocLendFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLocLendExecute ]
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
