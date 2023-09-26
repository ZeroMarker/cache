/// 名称:DHCMed.DTHService.CommonSrv
/// 描述: 死亡管理公共类
/// 编写者：wangCS
/// 编写日期: 2011-07-19
Class DHCMed.DTHService.CommonSrv Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Not ProcedureBlock ]
{

/// W ##CLASS(DHCMed.DTHService.CommonSrv).ConvertToDate("2013-10-01")
ClassMethod ConvertToDate(dateStr As %String) As %String
{
		new (dateStr)
		set return=""
		if ($g(dateStr)="")
		{
			set return=+$h
		}
		set:dateStr["-" return=$zdh(dateStr,3)
		set:dateStr["/" return=$zdh(dateStr,4)
		quit return
}

/// w ##Class(DHCMed.DTHService.CommonSrv).ConvertToTime("8:45:00")
ClassMethod ConvertToTime(timeStr As %String) As %String
{
		new (timeStr)
		set return=""
		if ($g(timeStr)="")
		{
			set return=$p($h,",",2)
		}
		set:timeStr[":" return=$zth(timeStr,1) 
		quit return
}

/// 验证用户的用户名/密码
/// userCode：用户工号
/// Pass：密码
/// 如果用户验证成功，返回用户信息，否则返回空
/// w ##Class(DHCMed.DTHService.CommonSrv).VerifyUser("med^1","^")
ClassMethod VerifyUser(instr, separate) As %String
{
   New (instr, separate)
   if ($g(separate)="")
	{
	    Set separate="^"
	}
   Set userCode=$p($g(instr),separate,1)
   Set Pass=$p($g(instr),separate,2)
   Set Ret=-1
   Set UserID=##Class(web.SSUser).IsValidUser(userCode,Pass)
   If (UserID>0){
   Set ObjUser=##Class(User.SSUser).%OpenId(UserID)
   If ($IsObject(ObjUser)){
   Set UserName=ObjUser.SSUSRName
   Set Ret=UserID_"/"_userCode_"/"_UserName
 }
  Do ObjUser.%Close()
  }
  Quit Ret
}

/// w ##class(DHCMed.DTHService.CommonSrv).GetMrNoByAdm(3782456)
ClassMethod GetMrNoByAdm(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	
	Set VolID=0,MrNo=""
	For {
		Set VolID=$o(^DHCWMRVOL(0,"PaadmDr",aEpisodeID,VolID))
		Quit:VolID=""
		Quit:MrNo'=""
		Set IsActive=$p($g(^DHCWMRVOL(VolID)),"^",7)
		Continue:IsActive'="Y"
		Set MainID=$p($g(^DHCWMRVOL(VolID)),"^",1)
		Set IsActive=$p($g(^DHCWMRMAIN(+MainID)),"^",6)
		Continue:IsActive'="Y"
		Set MrNo=$p($g(^DHCWMRMAIN(+MainID)),"^",2)
	}
	Set return=MrNo
	Quit return
}

/// Creator：     maxiangping
/// CreatDate：   2016-12-20
/// Description:  获取病人的有效证件号
/// Table：       Pa_Patmas
/// Input：       TypeCode:
/// Return：      %String
/// w ##class(DHCMed.DTHService.CommonSrv).GetPatActiveCardNo(106)
ClassMethod GetPatActiveCardNo(PatientID As %String) As %String
{
	New (PatientID,PapmiID,%session)
	Set Languages = "CH"
	If ($d(%session)){
		Set langid=+$g(%session.Data("LOGON.LANGID"))
		Set:langid'="" Languages=$p($g(^SS("LAN",langid)),"^",1)
	}
	Set return=""
	Quit:PatientID="" return
	
	Set PatIDType=""
	/* add by xwj 2020/02/28 bug:1203578
	Set PersonalID=$p($g(^PAPER(PatientID,"ALL")),"^",9)
	if PersonalID'="" {
		Set PatIDType="身份证"
	}
	else {
	*/
		Set PersonalIDTypeID = $p($g(^PAPER(PatientID,"PAT",3)),"^",7)
		Set PersonalIDType = $p($g(^PAC("CARD",+PersonalIDTypeID)),"^",2)
		Set PAPMIDVAnumber=$p($g(^PAPER(PatientID,"PAT",3)),"^",6)
		Set:PersonalIDType["户口" PatIDType="户口"
		Set:PersonalIDType["护照" PatIDType="护照"
		Set:PersonalIDType["军官证" PatIDType="军官证"
		Set:PersonalIDType["驾驶证" PatIDType="驾驶证"
		Set:PersonalIDType["港澳" PatIDType="港澳通行证"
		Set:PersonalIDType["台湾" PatIDType="台湾通行证"
		Set:PersonalIDType["其他" PatIDType="其他"
		Set:PatIDType="" PatIDType="身份证"
		Set PersonalID=PAPMIDVAnumber
	//}
	
	Set DicRowID = 0
	For {
		Set DicRowID = $o(^DHCMed.SS.DictionaryI("IdxofType"," "_$ZCVT("DTHCardType","U"),DicRowID))
		Quit:DicRowID=""
		Quit:return'=""
		
		Set objDic = ##class(DHCMed.SS.Dictionary).GetObjById(DicRowID)
		Continue:'$IsObject(objDic)
		Continue:objDic.Active'=1
		if (objDic.Description=PatIDType)||(objDic.Description[PatIDType) {
			Set PatIDTypeSSID=objDic.%Id()
			set return=PersonalID_"^"_PatIDTypeSSID_"^"_##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description",Languages,objDic.Description)
		}
	}
		
	Quit return
}

/// Creator：     yukai
/// CreatDate：   2019-01-26
/// Description:  死亡证报告未审核数量
/// Table：       DHCMed.DTHService.CommonSrv
/// Input：       aDateFrom : 开始日期
///               aDateTo   : 开始日期
/// Return：      返回String
/// w ##class(DHCMed.DTHService.CommonSrv).GetUnChkDthCnt("2020-07-12","2020-08-12")
/// w ##class(DHCMed.DTHService.CommonSrv).GetUnChkDthCnt("","")
ClassMethod GetUnChkDthCnt(aDateFrom As %String, aDateTo As %String, aLoc As %String = "") As %String
{
	New (aDateFrom,aDateTo,aLoc)
	Set return=0
	Set Cnt=0
	Set aDateFrom=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateTo)
	Set:aDateFrom="" aDateFrom=$p($h,",",1)-30
	Set:aDateTo="" aDateTo=$p($h,",",1)
	Quit:((aDateFrom="")||(aDateTo="")) $$$OK
	
	Set aHospCode=##class(DHCMed.SSService.HospitalSrv).GetSSHospCodeByLoc(aLoc,"DTH")
	
	Set xDate=aDateFrom-1
	For {
		Set xDate=$o(^DHCMed.DTHi("REP","IndexDate",xDate))
		Quit:(xDate="")||(xDate>aDateTo)
		Set xReportID=0
		For {
			Set xReportID=$o(^DHCMed.DTHi("REP","IndexDate",xDate,xReportID))
			Quit:xReportID="" 
			Set objRep=##Class(DHCMed.DTH.Report).GetObjById(xReportID)
			continue:'$IsObject(objRep) 
			If (aHospCode'=""){
		    	Set flag=##class(DHCMed.SSService.HospitalSrv).CheckIsHosp(aHospCode,objRep.EpisodeID,"DTH")
		    	continue:flag<1
		    }
			//Set RepStatusID=objRep.RepStatusDR
			Set RepStatusDesc=objRep.RepStatusDR.Description
			//Set objRepStatus=##class(DHCMed.SS.Dictionary).GetByTypeCode("EPIDEMICREPORTSTATUS",RepStatusID,"")
			//Set RepStatusDesc=objRepStatus.Description
			//b ;1
			//w RepStatusDesc,!
			Set:RepStatusDesc="待审" Cnt=Cnt+1
			}
		}
		Set:Cnt'="" return=Cnt
	Quit return
}

/// Creator：     yukai
/// CreatDate：   2019-01-26
/// Description:  儿童死亡证报告未审核数量
/// Table：       DHCMed.DTHService.CommonSrv
/// Input：       aDateFrom : 开始日期
///               aDateTo   : 开始日期
/// Return：      返回String
/// w ##class(DHCMed.DTHService.CommonSrv).GetUnChkChildDthCnt("2017-03-14","2017-06-20")
/// w ##class(DHCMed.DTHService.CommonSrv).GetUnChkChildDthCnt("","")
ClassMethod GetUnChkChildDthCnt(aDateFrom As %String, aDateTo As %String, aLoc As %String = "") As %String
{
	New (aDateFrom,aDateTo,aLoc)
	Set return=0
	Set Cnt=0
	Set aDateFrom=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateTo)
	Set:aDateFrom="" aDateFrom=$p($h,",",1)-30
	Set:aDateTo="" aDateTo=$p($h,",",1)
	Quit:((aDateFrom="")||(aDateTo="")) $$$OK
	
	Set aHospCode=##class(DHCMed.SSService.HospitalSrv).GetSSHospCodeByLoc(aLoc,"DTH")
	
	Set xDate=aDateFrom-1
	For {
		Set xDate=$o(^DHCMed.DTHi("ChildREP","IndexRepDate",xDate))
		Quit:(xDate="")||(xDate>aDateTo)
		Set xRepStatusID=""
		For {
			Set xRepStatusID=$o(^DHCMed.DTHi("ChildREP","IndexRepDate",xDate,xRepStatusID))
			Quit:xRepStatusID="" 
			Set xReportID=""
			For {
				Set xReportID=$o(^DHCMed.DTHi("ChildREP","IndexRepDate",xDate,xRepStatusID,xReportID))
				Quit:xReportID=""
				If (aHospCode'=""){
					Set objChild=##Class(DHCMed.DTH.ChildReport).GetObjById(xReportID)
					continue:'$IsObject(objChild)
		    		Set flag=##class(DHCMed.SSService.HospitalSrv).CheckIsHosp(aHospCode,objChild.EpisodeID,"DTH")
		    		continue:flag<1
		    	}
				Set objRepStatus=##class(DHCMed.SS.Dictionary).GetObjById(xRepStatusID)
				Continue:'$IsObject(objRepStatus)
				Set RepStatusDesc=objRepStatus.Description  
				Continue:RepStatusDesc'="待审"
				Set Cnt=Cnt+1
			}
		}
		}
		Set:Cnt'="" return=Cnt
	Quit return
}

/// Creator：     yukai
/// CreatDate：   2019-02-18
/// Description:  查询死亡患者科室汇总
/// Input:        aLocID：登录科室ID
/// Do ##class(%Library.ResultSet).RunQuery("DHCMed.DTHService.CommonSrv","QryDthRepLocCnt","2")
Query QryDthRepLocCnt(aLocID As %String, aDateFrom As %String = "", aDateTo As %String = "") As %Query(ROWSPEC = "LocDesc:%String,Cnt:%String") [ SqlProc ]
{
}

ClassMethod QryDthRepLocCntExecute(ByRef qHandle As %Binary, aLocID As %String, aDateFrom As %String = "", aDateTo As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set:aDateFrom="" aDateFrom=+$h-30     
	Set:aDateTo="" aDateTo=+$h
	Set aDateFrom=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateTo)
	Quit:((aDateFrom="")||(aDateTo="")) $$$OK 
	
	Set aHospCode=##class(DHCMed.SSService.HospitalSrv).GetSSHospCodeByLoc(aLocID,"DTH")
	
	Set NIndex="QryDthRepLocCnt"
	Kill ^TMP($zn,$j,NIndex)
	Kill ^TMP($zn,$j,"DthCnt")
	Set xDate=aDateFrom-1
	For {
		Set xDate=$o(^DHCMed.DTHi("REP","IndexSearch",xDate))
		Quit:(xDate="")||(xDate>aDateTo)
		Set xLocID=0
		For {
			Set xLocID=$o(^DHCMed.DTHi("REP","IndexSearch",xDate,xLocID))
			Quit:xLocID=""
			
			
			Set xRepStatusID=""
			For {
				Set xRepStatusID=$o(^DHCMed.DTHi("REP","IndexSearch",xDate,xLocID,xRepStatusID))
				Quit:xRepStatusID=""
				Set xReportID=""
				For {
					Set xReportID=$o(^DHCMed.DTHi("REP","IndexSearch",xDate,xLocID,xRepStatusID,xReportID))
					Quit:xReportID=""
					Set objRepStatus=##class(DHCMed.SS.Dictionary).GetObjById(xRepStatusID)
					Continue:'$IsObject(objRepStatus)
					Set RepStatusDesc=objRepStatus.Description
					Continue:(RepStatusDesc="删除")||(RepStatusDesc="退回")||(RepStatusDesc="作废")||(RepStatusDesc="草稿")
					Set DthReportobj=##Class(DHCMed.DTH.Report).GetObjById(xReportID)
					Quit:'$IsObject(DthReportobj)
					Set EpisodeID=DthReportobj.EpisodeID
					If (aHospCode'=""){
		    			Set flag=##class(DHCMed.SSService.HospitalSrv).CheckIsHosp(aHospCode,EpisodeID,"DTH")
		    			continue:flag<1
		   			}
		   			Set EpisodeID=DthReportobj.EpisodeID
					Set AdmInfo=$g(^PAADM(EpisodeID))
					Set AdmLocID=$p(AdmInfo,"^",4)
					/*Set LocID=$p(xLocID," ",2)
				
					Set objLoc=##class(DHCHAI.BT.Location).GetObjById(LocID)
					Continue:'$isobject(objLoc)
					Set LocDesc=objLoc.BTDesc2
					Set:LocDesc="" LocDesc=objLoc.BTDesc
					*/
					//w xReportID_"||"_LocDesc,!
					//Continue:$d(^TMP($zn,$j,NIndex,xDate,EpisodeID))  //一次就诊只算一次
					//Set ^TMP($zn,$j,NIndex,LocID,EpisodeID,1)=""
					Set num=$i(^TMP($zn,$j,NIndex,AdmLocID,"同期科室死亡人数"))
				}
			}
		}
	}
	Set xLoc=""
	For {
		//S LocDthCount=0
		Set xLoc=$o(^TMP($zn,$j,NIndex,xLoc))
		Quit:xLoc=""
      	Set LocDthCount =^TMP($zn,$j,NIndex,xLoc,"同期科室死亡人数")
		Continue:LocDthCount=0
		Set AdmLoc=$p(^CTLOC(xLoc),"^",2)
		Set:AdmLoc["-" AdmLoc=$p(AdmLoc,"-",2)
		//s LocDthCount =^TMP($zn,$j,"QryDthRepLocCnt",16,"同期科室死亡人数")
		Set ^TMP($zn,$j,"DthCnt",LocDthCount,AdmLoc)=1
	}
	set Count=0
	Set xDthCnt=""
	For {
		Set xDthCnt=$o(^TMP($zn,$j,"DthCnt",xDthCnt),-1)
		Quit:((xDthCnt="")||(Count>9))
		Set xLocDesc=""
		For {
			Set xLocDesc=$o(^TMP($zn,$j,"DthCnt",xDthCnt,xLocDesc))
			Quit:((xLocDesc="")||(Count>9))
			Set LocDesc=xLocDesc
			set Count=Count+1
      		Set Data=$lb(LocDesc,xDthCnt)
       	 	Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Kill ^TMP($zn,$j,NIndex)
	Kill ^TMP($zn,$j,"DthCnt")
	Quit $$$OK
}

ClassMethod QryDthRepLocCntClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDthRepLocCntExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryDthRepLocCntFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDthRepLocCntExecute ]
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

/// Creator：     yukai
/// CreatDate：   2019-02-18
/// Description:  查询死亡患者疾病ICD汇总
/// Input:        aLocID：登录科室ID
/// Do ##class(%Library.ResultSet).RunQuery("DHCMed.DTHService.CommonSrv","QryDthRepICDCnt","2")
Query QryDthRepICDCnt(aLocID As %String, aDateFrom As %String = "", aDateTo As %String = "") As %Query(ROWSPEC = "ICDDesc:%String,ICDCnt:%String") [ SqlProc ]
{
}

ClassMethod QryDthRepICDCntExecute(ByRef qHandle As %Binary, aLocID As %String, aDateFrom As %String = "", aDateTo As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set:aDateFrom="" aDateFrom=+$h-30
	Set:aDateTo="" aDateTo=$p($h,",",1)
	Set aDateFrom=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateTo)
	Quit:((aDateFrom="")||(aDateTo="")) $$$OK 
	
	Set aHospCode=##class(DHCMed.SSService.HospitalSrv).GetSSHospCodeByLoc(aLocID,"DTH")
	
	Set NIndex="QryDthRepICDCnt"
	Kill ^TMP($zn,$j,NIndex)
	Kill ^TMP($zn,$j,"ICDCnt")
	Set xDate=aDateFrom-1
	For {
		Set xDate=$o(^DHCMed.DTHi("REP","IndexDate",xDate))
		Quit:(xDate="")||(xDate>aDateTo)
		Set xReportID=0
		For {
			Set xReportID=$o(^DHCMed.DTHi("REP","IndexDate",xDate,xReportID))
			Quit:xReportID=""
			Set DthReportobj=##Class(DHCMed.DTH.Report).GetObjById(xReportID)
			Quit:'$IsObject(DthReportobj)
			If (aHospCode'=""){
		    	Set flag=##class(DHCMed.SSService.HospitalSrv).CheckIsHosp(aHospCode,DthReportobj.EpisodeID,"DTH")
		    	continue:flag<1
		    }
			Set RepStatusDesc=DthReportobj.RepStatusDR.Description
			Continue:(RepStatusDesc="删除")||(RepStatusDesc="退回")||(RepStatusDesc="作废")||(RepStatusDesc="草稿")
			Set AReason=DthReportobj.AReason    //根本死因
			Continue:AReason=""
			Set num=$i(^TMP($zn,$j,NIndex,AReason,"同期死亡人数"))
			}
	}
	Set xAReason=""
	For {
		//S LocDthCount=0
		Set xAReason=$o(^TMP($zn,$j,NIndex,xAReason))
		Quit:xAReason=""
      	Set DthICDCount =^TMP($zn,$j,NIndex,xAReason,"同期死亡人数")
		Continue:DthICDCount=0
		Set ^TMP($zn,$j,"ICDCnt",DthICDCount,xAReason)=1
	}
	set Count=0
	Set xDthICDCnt=""
	For {
		Set xDthICDCnt=$o(^TMP($zn,$j,"ICDCnt",xDthICDCnt),-1)
		Quit:((xDthICDCnt="")||(Count>11))
		Set xAReason=""
		For {
			Set xAReason=$o(^TMP($zn,$j,"ICDCnt",xDthICDCnt,xAReason))
			Quit:((xAReason="")||(Count>11))
			Set AReason=xAReason
			set Count=Count+1
      		Set Data=$lb(AReason,xDthICDCnt)
       	 	Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Kill ^TMP($zn,$j,NIndex)
	Kill ^TMP($zn,$j,"ICDCnt")
	Quit $$$OK
}

ClassMethod QryDthRepICDCntClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDthRepICDCntExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryDthRepICDCntFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDthRepICDCntExecute ]
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
