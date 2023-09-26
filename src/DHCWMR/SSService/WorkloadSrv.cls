/// 名称: DHCWMR.SSService.WorkloadSrv
/// 描述: 工作量统计相关服务
/// 编写者：zhufei
/// 编写日期: 2014-09-23
Class DHCWMR.SSService.WorkloadSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2014-09-23
/// Description:  工作量统计
/// Table：       DHCWMR.SS.Operation、DHCWMR.SS.VolStatus
/// Input：       MrTypeID : 病案类型ID
///               FromDate : 开始日期
///               ToDate : 结束日期
///               WFItemID : 工作流项目
///               QryFlag : 查询标记（按卷/病案统计）
/// Return：      返回Query
/// do ##class(%Library.ResultSet).RunQuery("DHCWMR.SSService.WorkloadSrv","StatWorkload","4","7","2014-12-01","2014-12-05","")
Query StatWorkload(aHospID As %String, aMrTypeID As %String, aDateFrom As %String, aDateTo As %String, aWFItemID As %String) As %Query(ROWSPEC = "UserID:%String,UserCode:%String,UserDesc:%String,Item1:%String,Item2:%String,Item3:%String,Item4:%String,Item5:%String,Item6:%String,Item7:%String,Item8:%String,Item9:%String,Item10:%String,Item11:%String,Item12:%String,Item13:%String,Item14:%String,Item15:%String,Item16:%String,Item17:%String,Item18:%String,Item19:%String,Item20:%String,Item21:%String,Item22:%String,Item23:%String,Item24:%String,Item25:%String")
{
}

ClassMethod StatWorkloadExecute(ByRef qHandle As %Binary, aHospID As %String, aMrTypeID As %String, aDateFrom As %String, aDateTo As %String, aWFItemID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	//Set ^ZF=$lb(aHospID,aMrTypeID,aDateFrom,aDateTo,aWFItemID)
	
	Quit:(aHospID="")||(aMrTypeID="") $$$OK
	Set:aHospID'="" aHospID=","_aHospID_","
	
	Set aDateFrom=##Class(DHCWMR.SSService.CommonSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCWMR.SSService.CommonSrv).DateHtmlToLogical(aDateTo)
	Set:aDateFrom'="" aDateFrom=+aDateFrom
	Set:aDateTo'="" aDateTo=+aDateTo
	
	Kill arrWorkload
	Kill ^TMP($zn,$j,"StatWorkload")
	Set xItemID=0
	For {
		Set xItemID=$o(^DHCWMR.SS.OperationI("IndexItemDrDate",aMrTypeID,xItemID))
		Quit:xItemID=""
		
		Set objWFItem=##class(DHCWMR.SS.WorkFItem).GetWFItem(aMrTypeID,xItemID)
		Continue:'$IsObject(objWFItem)
		Set WFItemID=objWFItem.%Id()
		Continue:(aWFItemID'="")&&(WFItemID'=aWFItemID)
		Continue:objWFItem.WFISysOpera="I"  //初始状态过滤
		Set WFIType=objWFItem.WFIType       //add by pylian
		Set WFIIndex=objWFItem.WFIIndex
		Continue:WFIIndex=""
		
		Set xDate=aDateFrom-1
		For {
			Set xDate=$o(^DHCWMR.SS.OperationI("IndexItemDrDate",aMrTypeID,xItemID,xDate))
			Quit:xDate=""
			Quit:xDate>aDateTo
			
			Set xTime=""
			For {
				Set xTime=$o(^DHCWMR.SS.OperationI("IndexItemDrDate",aMrTypeID,xItemID,xDate,xTime))
				Quit:xTime=""
				Set xOperaID=0
				For {
					Set xOperaID=$o(^DHCWMR.SS.OperationI("IndexItemDrDate",aMrTypeID,xItemID,xDate,xTime,xOperaID))
					Quit:xOperaID=""
					
					Set objOpera=##class(DHCWMR.SS.Operation).GetObjById(xOperaID)
					Continue:'$IsObject(objOpera)
					Set BatchNumber=objOpera.OPBatchNumber
					Continue:BatchNumber=""
					Set OperaUser=objOpera.OPUserFrom
					Continue:OperaUser=""
					Set UserLocRowid=+$p($g(^SSU("SSUSR",+OperaUser)),"^",4)
					Set AdmHospID = ##class(DHCWMR.SSService.HospitalSrv).GetCTHospID(+UserLocRowid)
					Continue:(aHospID'="")&&(aHospID'[(","_AdmHospID_","))
					
					Set xVolID=0,MCount=0,VCount=0
					For {
						Set xVolID=$o(^DHCWMR.SS.VolumeI("VS","IndexBatchNumber"," "_BatchNumber,xVolID))
						Quit:xVolID=""
						
						Set objVol=##Class(DHCWMR.SS.Volume).GetObjById(xVolID)
						Continue:'$IsObject(objVol)
						Continue:objVol.SVIsActive'=1  //卷无效
						Set objMain=objVol.SVMainDr
						Continue:'$IsObject(objMain)
						Continue:objMain.SMIsActive'=1  //病案无效
						Continue:'$IsObject(objMain.SMMrType)
						Continue:objMain.SMMrType.%Id()'=aMrTypeID  //病案类型不一致
						Set MainID=objMain.%Id()
						
						//检查卷操作是否有效
						Set xSub=$o(^DHCWMR.SS.VolumeI("VS","IndexBatchNumber"," "_BatchNumber,xVolID,""),-1)
						Continue:xSub=""
						Set objVolStatus=##Class(DHCWMR.SS.VolStatus).GetObjById(xVolID_"||"_xSub)
						Continue:'$IsObject(objVolStatus)
						Continue:objVolStatus.VSUpdoOpera="U" //作废记录
						If '$d(^TMP($zn,$j,"StatWorkload",BatchNumber,MainID)){
							Set MCount=MCount+1
						}
						If '$d(^TMP($zn,$j,"StatWorkload",BatchNumber,MainID,xVolID)){
							Set VCount=VCount+1
						}
						Set ^TMP($zn,$j,"StatWorkload",BatchNumber,MainID,xVolID)=""
						
					}
					Continue:'$d(^TMP($zn,$j,"StatWorkload",BatchNumber))			
					Set tmpCount=$g(arrWorkloadTmp(OperaUser,WFIIndex))  //临时计数
					Set tmpMCount=+$p(tmpCount,"/",1)
					Set MCount=MCount+tmpMCount
					Set tmpVCount=+$p(tmpCount,"/",2)
					Set VCount=VCount+tmpVCount
					Set arrWorkloadTmp(OperaUser,WFIIndex)=MCount_"/"_VCount
				    //modify by pylian
					If WFIType="O" {
						Set arrWorkload(OperaUser,WFIIndex)=VCount  //顺序流操作记卷
					} Else {
						Set arrWorkload(OperaUser,WFIIndex)=MCount	//突发流操作记病案
					}
				}
			}
		}
	}
	Kill ^TMP($zn,$j,"StatWorkload")
	
	Set xUserID=0
	For {
		Set xUserID=$o(arrWorkload(xUserID))
		Quit:xUserID=""
		
		Set UserCode=$p($g(^SSU("SSUSR",xUserID)),"^",1)
		Set UserDesc=$p($g(^SSU("SSUSR",xUserID)),"^",2)
		Continue:(UserCode="")&&(UserDesc="")
		
		Set Data=$lb(xUserID,UserCode,UserDesc)
		For itemIndex=1:1:25 {
			Set Count=$g(arrWorkload(xUserID,itemIndex))
			Set Data=Data_$lb(Count)
		}
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Kill arrWorkload
	Kill arrWorkloadTmp
	
	Quit $$$OK
}

ClassMethod StatWorkloadClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StatWorkloadExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod StatWorkloadFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StatWorkloadExecute ]
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

/// Creator：     zhoubo
/// CreatDate：   2016-07-10
/// Description:  工作量统计明细
/// Table：       DHCWMR.SS.Operation、DHCWMR.SS.VolStatus
/// Input：       MrTypeID : 病案类型ID
///               FromDate : 开始日期
///               ToDate : 结束日期
///               WFItemID : 工作流项目
///               QryFlag : 查询标记（按卷/病案统计）   ,2,^7^64278^64278^^140^1||2
/// Return：      返回Query    
/// do ##class(%Library.ResultSet).RunQuery("DHCWMR.SSService.WorkloadSrv","StatWorkloadDtl",",2,","7","64284","64287","1||3"","143")
Query StatWorkloadDtl(aHospID As %String, aMrTypeID As %String, aDateFrom As %String, aDateTo As %String, aWFItemID As %String, aUserID As %String) As %Query(ROWSPEC = "RecordID:%String,VolumeID:%String,EpisodeID:%String,MrNo:%String,BackDate:%String,OperDate:%String,OperTime:%String,DischDiagnos:%String,PatName:%String,PapmiNo:%String,Sex:%String,Age:%String,IDCode:%String,AdmitDate:%String,AdmitDeptDesc:%String,AdmitWardDesc:%String,VPAdmitDiagnos:%String,DischDate:%String,VPDischDiagnos:%String")
{
}

ClassMethod StatWorkloadDtlExecute(ByRef qHandle As %Binary, aHospID As %String, aMrTypeID As %String, aDateFrom As %String, aDateTo As %String, aWFItemID As %String, aUserID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aHospID="")||(aMrTypeID="") $$$OK
	Set:aHospID'="" aHospID=","_aHospID_","
	
	Set aDateFrom=##Class(DHCWMR.SSService.CommonSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCWMR.SSService.CommonSrv).DateHtmlToLogical(aDateTo)
	Set:aDateFrom'="" aDateFrom=+aDateFrom
	Set:aDateTo'="" aDateTo=+aDateTo

	Set xItemID=0
	For {
		Set xItemID=$o(^DHCWMR.SS.OperationI("IndexItemDrDate",aMrTypeID,xItemID))
		Quit:xItemID=""
		
		Set objWFItem=##class(DHCWMR.SS.WorkFItem).GetWFItem(aMrTypeID,xItemID)
		Continue:'$IsObject(objWFItem)
		Set WFItemID=objWFItem.%Id()
		Continue:(aWFItemID'="")&&(WFItemID'=aWFItemID)
		Continue:objWFItem.WFISysOpera="I"  //初始状态过滤
		Set WFIType=objWFItem.WFIType
		Set WFIIndex=objWFItem.WFIIndex
		Continue:WFIIndex=""
		
		Set xDate=aDateFrom-1
		For {
			Set xDate=$o(^DHCWMR.SS.OperationI("IndexItemDrDate",aMrTypeID,xItemID,xDate))
			Quit:xDate=""
			Quit:xDate>aDateTo
			
			Set xTime=""
			For {
				Set xTime=$o(^DHCWMR.SS.OperationI("IndexItemDrDate",aMrTypeID,xItemID,xDate,xTime))
				Quit:xTime=""
				Set xOperaID=0
				For {
					Set xOperaID=$o(^DHCWMR.SS.OperationI("IndexItemDrDate",aMrTypeID,xItemID,xDate,xTime,xOperaID))
					Quit:xOperaID=""
					
					Set objOpera=##class(DHCWMR.SS.Operation).GetObjById(xOperaID)
					Continue:'$IsObject(objOpera)
					Set BatchNumber=objOpera.OPBatchNumber
					Continue:BatchNumber=""
					Set OperaUser=objOpera.OPUserFrom
					Continue:OperaUser=""
					Continue:(aUserID'="")&&(OperaUser'=aUserID) // 过滤操作员
					Set UserLocRowid=+$p($g(^SSU("SSUSR",+OperaUser)),"^",4)
					Set AdmHospID = ##class(DHCWMR.SSService.HospitalSrv).GetCTHospID(+UserLocRowid)
					Continue:(aHospID'="")&&(aHospID'[(","_AdmHospID_","))
					
					Set OperDate=##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(xDate)
					Set OperTime=$zt(objOpera.OPActTime,1)
					
					Set xVolID=0,MCount=0,VCount=0
					For {
						Set xVolID=$o(^DHCWMR.SS.VolumeI("VS","IndexBatchNumber"," "_BatchNumber,xVolID))
						Quit:xVolID=""
						Set (PatName,PapmiNo,Sex,Age,IDCode,VPAdmitDate,VPAdmitDeptDesc,VPAdmitWardDesc,VPAdmitDiagnos,VPDischDate)=""
						Set objVol=##Class(DHCWMR.SS.Volume).GetObjById(xVolID)
						Continue:'$IsObject(objVol)
						Continue:objVol.SVIsActive'=1  //卷无效
						Set objMain=objVol.SVMainDr
						Continue:'$IsObject(objMain)
						Continue:objMain.SMIsActive'=1  //病案无效
						Set SMMrNo=objMain.SMMrNo
						Continue:'$IsObject(objMain.SMMrType)
						Continue:objMain.SMMrType.%Id()'=aMrTypeID  //病案类型不一致
						Set MainID=objMain.%Id()
						
						//检查卷操作是否有效
						Set xVSSub=$o(^DHCWMR.SS.VolumeI("VS","IndexBatchNumber"," "_BatchNumber,xVolID,""),-1)
						Continue:xVSSub=""
						Set objVolStatus=##Class(DHCWMR.SS.VolStatus).GetObjById(xVolID_"||"_xVSSub)
						Continue:'$IsObject(objVolStatus)
						Continue:objVolStatus.VSUpdoOpera="U" //作废记录
						Set xVPSubID=$o(^DHCWMR.SS.VolumeD(xVolID,"P",0))
						Continue:xVPSubID=""
						Set objVolPaadm=##class(DHCWMR.SS.VolPaadm).GetObjById(xVolID_"||"_xVPSubID)
						Continue:'$IsObject(objVolPaadm)
						Set EpisodeID = objVolPaadm.VPEpisodeID
						
						Set PatName   = objVolPaadm.VPPatName
						Set PatientID = objVolPaadm.VPPatientID
						Set PapmiNo   = $p($g(^PAPER(PatientID,"PAT",1)),"^",1)
						Set Sex = objVolPaadm.VPSex
						Set Age=##class(DHCWMR.IO.FromHisSrv).GetPapmiAge(PatientID,"","","")  //年龄
						Set IDCode=objVolPaadm.VPIdentityCode //身份证
						Set AdmitDate=objVolPaadm.VPAdmitDate
						Set:AdmitDate'="" AdmitDate=##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(AdmitDate)
						Set AdmitDeptDesc=objVolPaadm.VPAdmitDeptDesc
						Set:AdmitDeptDesc["-" AdmitDeptDesc=$p(AdmitDeptDesc,"-",2)
						Set AdmitWardDesc=objVolPaadm.VPAdmitWardDesc
						Set:AdmitWardDesc["-" AdmitWardDesc=$p(AdmitWardDesc,"-",2)
						Set VPAdmitDiagnos=objVolPaadm.VPAdmitDiagnos
						Set VPDischDiagnos=objVolPaadm.VPDischDiagnos
						Set DischDate=objVol.SVDischDate	
						Set:DischDate'="" DischDate=##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(DischDate)
						Set SVBackDate=objVol.SVBackDate
						Set:SVBackDate'="" SVBackDate=##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(SVBackDate)
						Set DischDiagnos=""
						
						Set RecordID=xVolID_"-"_xVolID_"||"_xVSSub
						
						Set Data=$lb(RecordID,xVolID,EpisodeID,SMMrNo,SVBackDate,OperDate,OperTime,DischDiagnos,PatName,PapmiNo,Sex,Age,IDCode,AdmitDate,AdmitDeptDesc,AdmitWardDesc,VPAdmitDiagnos,DischDate,VPDischDiagnos)
						Set ^CacheTemp(repid,ind)=Data
						Set ind=ind+1
					}				
				}
			}
		}
	}
	Quit $$$OK
}

ClassMethod StatWorkloadDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StatWorkloadDtlExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod StatWorkloadDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StatWorkloadDtlExecute ]
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
