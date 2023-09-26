/// 名称: DHCWMR.SSService.OperationQry
/// 描述: 病案流程操作 查询服务
/// 编写者：zhufei
/// 编写日期: 2014-09-18
Class DHCWMR.SSService.OperationQry Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2014-09-18
/// Description:  根据病案号/条码号/批次号查询病案卷列表
/// Table：       DHCWMR.SS.Main、DHCWMR.SS.Volume
/// Input：       MrTypeID : 病案类型ID
///               OperaList : 菜单操作列表（权限控制）
/// Return：      返回Query
/// do ##class(%Library.ResultSet).RunQuery("DHCWMR.SSService.OperationQry","QrySelVolList","7","2||10","1043551","")
Query QrySelVolList(aMrTypeID As %String, aWFItemID As %String, aMrNo As %String, aCatCode As %String) As %Query(ROWSPEC = "RecordID:%String,ProblemCode:%String,ProblemDesc:%String,HappenDate:%String,HappenTime:%String,HappenUser:%String,HappenUserDesc:%String,RequestDate:%String,RequestTime:%String,RequestUser:%String,RequestUserDesc:%String,VolID:%String,MainID:%String,EpisodeID:%String,PatientID:%String,MrNo:%String,PapmiNo:%String,PatName:%String,Sex:%String,Age:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmDate:%String,AdmTime:%String,DischCondit:%String,DischDate:%String,BackDate:%String,StepDesc:%String,StatusDesc:%String")
{
}

ClassMethod QrySelVolListExecute(ByRef qHandle As %Binary, aMrTypeID As %String, aWFItemID As %String, aMrNo As %String, aCatCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	//Set ^ZF=$lb(aMrTypeID,aWFItemID,aMrNo,aCatCode)
	
	Quit:(aMrTypeID="")||(aWFItemID="")||(aMrNo="") $$$OK
	
	Set objWFItem=##class(DHCWMR.SS.WorkFItem).GetObjById(aWFItemID)
	Quit:'$IsObject(objWFItem) $$$OK
	Quit:'$IsObject(objWFItem.WFIItem) $$$OK
	Set WFIType=objWFItem.WFIType
	Set WFISysOpera=objWFItem.WFISysOpera
	Set WFISubFlow=objWFItem.WFISubFlow
	Set WFIBeRequest=objWFItem.WFIBeRequest
	
	Set aMrNo=##Class(DHCWMR.SSService.CommonSrv).ChangeMrNo(aMrNo)
	Quit:aMrNo="" $$$OK
	
	Set BatchNumber="",MainID="",VolID="",RegNo="",MrNo=""
	If ($l(aMrNo)=13)&&($e(aMrNo,1,2)="B") {  //批次号
		Set BatchNumber=aMrNo
	} ElseIf ($l(aMrNo)=13)&&($e(aMrNo,1,2)="01") {  //病案条码号
		Set Barcode=aMrNo
		Set MainID=$o(^DHCWMR.SS.MainI("IndexTypeBarcodeAct",aMrTypeID," "_Barcode,1,0))
	} ElseIf ($l(aMrNo)=13)&&($e(aMrNo,1,2)="02") {  //卷条码号
		Set Barcode=aMrNo
		Set VolID=$o(^DHCWMR.SS.VolumeI("IndexBarcodeAct"," "_Barcode,1,0))
	} ElseIf $l(aMrNo)=10 {  //登记号
		Set RegNo=aMrNo
	} Else {  //病案号
		Set MrNo=aMrNo
	}
	
	If MainID'="" {
		Quit:MainID<1 $$$OK
		Set xVolID=0
		For {
			Set xVolID=$o(^DHCWMR.SS.VolumeI("IndexMainDrAct",+MainID,1,xVolID))
			Quit:xVolID=""
			Do BuildVolumeList
		}
	} ElseIf VolID'="" {
		Quit:VolID<1 $$$OK
		Set xVolID=VolID
		Do BuildVolumeList
	} ElseIf BatchNumber'="" {
		Set xVolID=0
		For {
			Set xVolID=$o(^DHCWMR.SS.VolumeI("VS","IndexBatchNumber"," "_$zcvt(BatchNumber,"U"),xVolID))
			Quit:xVolID=""
			
			//检查卷操作批次号是否有效
			Set xSub=$o(^DHCWMR.SS.VolumeI("VS","IndexBatchNumber"," "_$zcvt(BatchNumber,"U"),xVolID,""),-1)
			Continue:xSub=""
			Set objVolStatus=##Class(DHCWMR.SS.VolStatus).GetObjById(xVolID_"||"_xSub)
			Continue:'$IsObject(objVolStatus)
			Continue:objVolStatus.VSUpdoOpera'="" //撤销状态 作废U或回置B
			Do BuildVolumeList
		}
	} ElseIf RegNo'="" {
		Set PatientID=##Class(DHCWMR.SSService.CommonSrv).GetPatientID(RegNo)
		Quit:PatientID="" $$$OK
		Set xVolID=0
		For {
			Set xVolID=$o(^DHCWMR.SS.VolumeI("VP","IndexPatientID",PatientID,xVolID))
			Quit:xVolID=""
			Do BuildVolumeList
		}
	} ElseIf MrNo'="" {
		Set MainID=$o(^DHCWMR.SS.MainI("IndexTypeNoAct",aMrTypeID," "_$zcvt(MrNo,"U"),1,""))
		Quit:MainID="" $$$OK
		Set xVolID=0
		For {
			Set xVolID=$o(^DHCWMR.SS.VolumeI("IndexMainDrAct",MainID,1,xVolID))
			Quit:xVolID=""
			Do BuildVolumeList
		}
	} Else {}
	
	Quit $$$OK
	
BuildVolumeList
	Set xData=..BuildVolume(xVolID)
	Quit:xData="" //退出
	
	Set flg=##class(DHCWMR.SSService.OperationSrv).CheckOperation(xVolID,aWFItemID)
	Set ProblemCode=$p(flg,"^",1)
	Set ProblemDesc=$p(flg,"^",2)
	
	If (WFISubFlow'="O")&&(WFISysOpera="B"){  //突发还回，查找突发发生记录
		Set xCatCode=""
		For {
			Set xCatCode=$o(^DHCWMR.SS.VolumeI("VS","IndexStatusCate",xVolID,xCatCode))
			Quit:xCatCode=""
			
			Set xWorkItemID=0
			For {
				Set xWorkItemID=$o(^DHCWMR.SS.VolumeI("VS","IndexStatusCate",xVolID,xCatCode,xWorkItemID))
				Quit:xWorkItemID=""
				
				Set objWFItem=##class(DHCWMR.SS.WorkFItem).GetWFItem(aMrTypeID,xWorkItemID)
				Continue:'$IsObject(objWFItem)
				Continue:objWFItem.WFISubFlow'=WFISubFlow
				Continue:objWFItem.WFISysOpera'="H"  //突发发生操作
				
				Set xSubID=0
				For {
					Set xSubID=$o(^DHCWMR.SS.VolumeI("VS","IndexStatusCate",xVolID,xCatCode,xWorkItemID,xSubID))
					Quit:xSubID=""
					
					Set objStatus=##Class(DHCWMR.SS.VolStatus).GetObjById(xVolID_"||"_xSubID)
					Continue:'$IsObject(objStatus)
					Continue:objStatus.VSUpdoOpera="U"
					Continue:objStatus.VSLnkOperaDr'=""
					
					Set HappenDate=objStatus.VSActDate
					;Set:HappenDate'="" HappenDate=$zd(HappenDate,3)
					Set:HappenDate'="" HappenDate=##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(HappenDate)
					Set HappenTime=objStatus.VSActTime
					Set:HappenTime'="" HappenTime=$zt(HappenTime,2)
					Set HappenUser=objStatus.VSUserFrom
					Set HappenUserDesc=""
					Set:HappenUser'="" HappenUserDesc=$p($g(^SSU("SSUSR",HappenUser)),"^",2)
					
					Set (RequestDate,RequestTime,RequestUser,RequestUserDesc)=""
					If $IsObject(objStatus.VSRequestDr){
						Set RequestDate=objStatus.VSRequestDr.RQRequestDate
						;Set:RequestDate'="" RequestDate=$zd(RequestDate,3)
						Set:RequestDate'="" RequestDate=##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(RequestDate)
						Set RequestTime=objStatus.VSRequestDr.RQRequestTime
						Set:RequestTime'="" RequestTime=$zt(RequestTime,2)
						Set RequestUser=objStatus.VSRequestDr.RQRequestUser
						Set RequestUserDesc=""
						Set:RequestUser'="" RequestUserDesc=$p($g(^SSU("SSUSR",RequestUser)),"^",2)
					}
					
					Set RecordID=xVolID_"-"_xVolID_"||"_xSubID_"-"_""
					Set Data=$lb(RecordID,ProblemCode,ProblemDesc,HappenDate,HappenTime,HappenUser,HappenUserDesc,RequestDate,RequestTime,RequestUser,RequestUserDesc)_xData
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
		}
	} ElseIf (WFIBeRequest=1){  //需要申请，查找申请记录
		Set xRequestID=0
		For {
			Set xRequestID=$o(^DHCWMR.SS.RequestI("RD","IndexVolumeStatus",xVolID," R",xRequestID))
			Quit:xRequestID=""
			
			Set objRequest=##class(DHCWMR.SS.RequestDtl).GetObjById(xRequestID)
			Continue:'$IsObject(objRequest)
			Continue:objRequest.RQReqStatus="U"  //作废申请单
			Continue:objRequest.Parref.RQReqStatus="U"  //作废申请单
			Set RequestDate=objRequest.Parref.RQRequestDate
			;Set:RequestDate'="" RequestDate=$zd(RequestDate,3)
			Set:RequestDate'="" RequestDate=##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(RequestDate)
			Set RequestTime=objRequest.Parref.RQRequestTime
			Set:RequestTime'="" RequestTime=$zt(RequestTime,2)
			Set RequestUser=objRequest.Parref.RQRequestUser
			Set RequestUserDesc=""
			Set:RequestUser'="" RequestUserDesc=$p($g(^SSU("SSUSR",RequestUser)),"^",2)
			
			Set RecordID=xVolID_"-"_""_"-"_xRequestID
			Set Data=$lb(RecordID,ProblemCode,ProblemDesc,"","","","",RequestDate,RequestTime,RequestUser,RequestUserDesc)_xData
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	} Else {
		Set RecordID=xVolID_"-"_""_"-"_""
		Set Data=$lb(RecordID,ProblemCode,ProblemDesc,"","","","","","","","")_xData
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit //退出
}

ClassMethod QrySelVolListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySelVolListExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QrySelVolListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySelVolListExecute ]
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

/// Creator：     zhufei
/// CreatDate：   2014-09-18
/// Description:  根据病案号/条码号/批次号查询病案卷列表
/// Table：       DHCWMR.SS.Main、DHCWMR.SS.Volume
/// Input：       MrTypeID : 病案类型ID
///               OperaList : 菜单操作列表（权限控制）
/// Return：      返回Query
/// do ##class(%Library.ResultSet).RunQuery("DHCWMR.SSService.OperationQry","QryOperaVolList",7,"1||13",4479)
Query QryOperaVolList(aMrTypeID As %String, aWFItemID As %String, aUserID As %String) As %Query(ROWSPEC = "RowIndex:%String,RecordID:%String,ProblemCode:%String,ProblemDesc:%String,HappenDate:%String,HappenTime:%String,HappenUser:%String,HappenUserDesc:%String,RequestDate:%String,RequestTime:%String,RequestUser:%String,RequestUserDesc:%String,VolID:%String,MainID:%String,EpisodeID:%String,PatientID:%String,MrNo:%String,PapmiNo:%String,PatName:%String,Sex:%String,Age:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmDate:%String,AdmTime:%String,DischCondit:%String,DischDate:%String,BackDate:%String,StepDesc:%String,StatusDesc:%String,EncryptLevel:%String,PatLevel:%String")
{
}

ClassMethod QryOperaVolListExecute(ByRef qHandle As %Binary, aMrTypeID As %String, aWFItemID As %String, aUserID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aMrTypeID="")||(aWFItemID="")||(aUserID="") $$$OK
	
	Set xMainID=0
	For {
		Set xMainID=$o(^DHCWMR.SS.WorkList($zd(+$h,3),aMrTypeID,aWFItemID,aUserID,xMainID))
		Quit:xMainID=""
		
		Set xVolID=0
		For {
			Set xVolID=$o(^DHCWMR.SS.WorkList($zd(+$h,3),aMrTypeID,aWFItemID,aUserID,xMainID,xVolID))
			Quit:xVolID=""
			
			Set xData=..BuildVolume(xVolID)
			Continue:xData=""
			
			Set xFlag=""
			For {
				Set xFlag=$o(^DHCWMR.SS.WorkList($zd(+$h,3),aMrTypeID,aWFItemID,aUserID,xMainID,xVolID,xFlag))
				Quit:xFlag=""
				
				If xFlag="V" {  //卷操作
					Set tmpInfo=$g(^DHCWMR.SS.WorkList($zd(+$h,3),aMrTypeID,aWFItemID,aUserID,xMainID,xVolID,xFlag))
					Continue:tmpInfo=""
					Set RowIndex=+$p(tmpInfo,",",1)
					
					Set flg=##class(DHCWMR.SSService.OperationSrv).CheckOperation(xVolID,aWFItemID)
					Set ProblemCode=$p(flg,"^",1)
					Set ProblemDesc=$p(flg,"^",2)
					
					Set RecordID=xVolID_"-"_""_"-"_""
					Set Data=$lb(RowIndex,RecordID,ProblemCode,ProblemDesc,"","","","","","","","")_xData
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				} ElseIf xFlag="S" {  //还回操作
					Set xStatusID=""
					For {
						Set xStatusID=$o(^DHCWMR.SS.WorkList($zd(+$h,3),aMrTypeID,aWFItemID,aUserID,xMainID,xVolID,xFlag,xStatusID))
						Quit:xStatusID=""
						
						Set tmpInfo=$g(^DHCWMR.SS.WorkList($zd(+$h,3),aMrTypeID,aWFItemID,aUserID,xMainID,xVolID,xFlag,xStatusID))
						Continue:tmpInfo=""
						Set RowIndex=+$p(tmpInfo,",",1)
						
						Set flg=##class(DHCWMR.SSService.OperationSrv).CheckOperation(xVolID,aWFItemID)
						Set ProblemCode=$p(flg,"^",1)
						Set ProblemDesc=$p(flg,"^",2)
						
						Set objStatus=##Class(DHCWMR.SS.VolStatus).GetObjById(xStatusID)
						Continue:'$IsObject(objStatus)
						Continue:objStatus.VSUpdoOpera="U"
						Continue:$IsObject(objStatus.VSLnkOperaDr)
						
						Set HappenDate=objStatus.VSActDate
						Set:HappenDate'="" HappenDate=$zd(HappenDate,3)
						Set HappenTime=objStatus.VSActTime
						Set:HappenTime'="" HappenTime=$zt(HappenTime,2)
						Set HappenUser=objStatus.VSUserFrom
						Set HappenUserDesc=""
						Set:HappenUser'="" HappenUserDesc=$p($g(^SSU("SSUSR",HappenUser)),"^",2)
						
						Set (RequestDate,RequestTime,RequestUser,RequestUserDesc)=""
						If $IsObject(objStatus.VSRequestDr){
							Set RequestDate=objStatus.VSRequestDr.RQRequestDate
							Set:RequestDate'="" RequestDate=$zd(RequestDate,3)
							Set RequestTime=objStatus.VSRequestDr.RQRequestTime
							Set:RequestTime'="" RequestTime=$zt(RequestTime,2)
							Set RequestUser=objStatus.VSRequestDr.RQRequestUser
							Set RequestUserDesc=""
							Set:RequestUser'="" RequestUserDesc=$p($g(^SSU("SSUSR",RequestUser)),"^",2)
						}
						
						Set RecordID=xVolID_"-"_xStatusID_"-"_""
						Set Data=$lb(RowIndex,RecordID,ProblemCode,ProblemDesc,HappenDate,HappenTime,HappenUser,HappenUserDesc,RequestDate,RequestTime,RequestUser,RequestUserDesc)_xData
						Set ^CacheTemp(repid,ind)=Data
						Set ind=ind+1
					}
				} ElseIf xFlag="R" {  //申请操作
					Set xRequestID=""
					For {
						Set xRequestID=$o(^DHCWMR.SS.WorkList($zd(+$h,3),aMrTypeID,aWFItemID,aUserID,xMainID,xVolID,xFlag,xRequestID))
						Quit:xRequestID=""
						
						Set tmpInfo=$g(^DHCWMR.SS.WorkList($zd(+$h,3),aMrTypeID,aWFItemID,aUserID,xMainID,xVolID,xFlag,xRequestID))
						Continue:tmpInfo=""
						Set RowIndex=+$p(tmpInfo,",",1)
						
						Set flg=##class(DHCWMR.SSService.OperationSrv).CheckOperation(xVolID,aWFItemID)
						Set ProblemCode=$p(flg,"^",1)
						Set ProblemDesc=$p(flg,"^",2)
						
						Set objRequest=##class(DHCWMR.SS.RequestDtl).GetObjById(xRequestID)
						Continue:'$IsObject(objRequest)
						Continue:objRequest.RQReqStatus="U"  //作废申请单
						Continue:objRequest.Parref.RQReqStatus="U"  //作废申请单
						Set RequestDate=objRequest.Parref.RQRequestDate
						Set:RequestDate'="" RequestDate=$zd(RequestDate,3)
						Set RequestTime=objRequest.Parref.RQRequestTime
						Set:RequestTime'="" RequestTime=$zt(RequestTime,2)
						Set RequestUser=objRequest.Parref.RQRequestUser
						Set RequestUserDesc=""
						Set:RequestUser'="" RequestUserDesc=$p($g(^SSU("SSUSR",RequestUser)),"^",2)
						
						Set RecordID=xVolID_"-"_""_"-"_xRequestID
						Set Data=$lb(RowIndex,RecordID,ProblemCode,ProblemDesc,"","","","",RequestDate,RequestTime,RequestUser,RequestUserDesc)_xData
						Set ^CacheTemp(repid,ind)=Data
						Set ind=ind+1
					}
				} Else {}
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod QryOperaVolListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOperaVolListExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryOperaVolListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOperaVolListExecute ]
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

/// Creator：     zhufei
/// CreatDate：   2014-12-04
/// Description:  撤销卷列表查询（当日查询）
/// Table：       DHCWMR.SS.Main、DHCWMR.SS.Volume
/// Input：       MrTypeID : 病案类型ID
///               WFItemID : 操作项目
///               UserID : 操作用户
/// Return：      返回Query
/// do ##class(%Library.ResultSet).RunQuery("DHCWMR.SSService.OperationQry","QryUpdoVolList","7","1||2","13","")
Query QryUpdoVolList(aMrTypeID As %String, aWFItemID As %String, aUserID As %String, aMrNo As %String) As %Query(ROWSPEC = "RowIndex:%String,RecordID:%String,ProblemCode:%String,ProblemDesc:%String,HappenDate:%String,HappenTime:%String,HappenUser:%String,HappenUserDesc:%String,RequestDate:%String,RequestTime:%String,RequestUser:%String,RequestUserDesc:%String,VolID:%String,MainID:%String,EpisodeID:%String,PatientID:%String,MrNo:%String,PapmiNo:%String,PatName:%String,Sex:%String,Age:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmDate:%String,AdmTime:%String,DischCondit:%String,DischDate:%String,BackDate:%String,StepDesc:%String,StatusDesc:%String,EncryptLevel:%String,PatLevel:%String")
{
}

ClassMethod QryUpdoVolListExecute(ByRef qHandle As %Binary, aMrTypeID As %String, aWFItemID As %String, aUserID As %String, aMrNo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	//Set ^ZF=$lb(aMrTypeID,aWFItemID,aUserID,aMrNo)
	
	Quit:(aMrTypeID="")||(aWFItemID="")||(aUserID="") $$$OK
	
	Set objWFItem=##class(DHCWMR.SS.WorkFItem).GetObjById(aWFItemID)
	Quit:'$IsObject(objWFItem) $$$OK
	Quit:'$IsObject(objWFItem.WFIItem) $$$OK
	Set WorkItemID=objWFItem.WFIItem.%Id()
	
	Set BatchNumber="",MainID="",VolID="",RegNo="",MrNo=""
	Set aMrNo=##Class(DHCWMR.SSService.CommonSrv).ChangeMrNo(aMrNo)
	If aMrNo'="" {
		If ($l(aMrNo)=13)&&($e(aMrNo,1,2)="B") {  //批次号
			Set BatchNumber=aMrNo
		} ElseIf ($l(aMrNo)=13)&&($e(aMrNo,1,2)="01") {  //病案条码号
			Set Barcode=aMrNo
			Set MainID=$o(^DHCWMR.SS.MainI("IndexTypeBarcodeAct",aMrTypeID," "_Barcode,1,0))
		} ElseIf ($l(aMrNo)=13)&&($e(aMrNo,1,2)="02") {  //卷条码号
			Set Barcode=aMrNo
			Set VolID=$o(^DHCWMR.SS.VolumeI("IndexBarcodeAct"," "_Barcode,1,0))
		} ElseIf $l(aMrNo)=10 {  //登记号
			Set RegNo=aMrNo
		} Else {  //病案号
			Set MrNo=aMrNo
		}
	}
	
	Set RowIndex=0
	If MainID'="" {
		Quit:MainID<1 $$$OK
		Set xVolID=0
		For {
			Set xVolID=$o(^DHCWMR.SS.VolumeI("IndexMainDrAct",+MainID,1,xVolID))
			Quit:xVolID=""
			Set xSubID=0
			For {
				Set xSubID=$o(^DHCWMR.SS.VolumeD(xVolID,"S",xSubID))
				Quit:xSubID=""
				Do BuildVolumeStatus
			}
		}
	} ElseIf VolID'="" {
		Quit:VolID<1 $$$OK
		Set xVolID=VolID
		Set xSubID=0
		For {
			Set xSubID=$o(^DHCWMR.SS.VolumeD(xVolID,"S",xSubID))
			Quit:xSubID=""
			Do BuildVolumeStatus
		}
	} ElseIf MrNo'="" {
		Set MainID=$o(^DHCWMR.SS.MainI("IndexTypeNoAct",aMrTypeID," "_$zcvt(MrNo,"U"),1,""))
		Quit:MainID="" $$$OK
		Set xVolID=0
		For {
			Set xVolID=$o(^DHCWMR.SS.VolumeI("IndexMainDrAct",MainID,1,xVolID))
			Quit:xVolID=""
			Set xSubID=0
			For {
				Set xSubID=$o(^DHCWMR.SS.VolumeD(xVolID,"S",xSubID))
				Quit:xSubID=""
				Do BuildVolumeStatus
			}
		}
	} ElseIf BatchNumber'="" {
		Set xVolID=0
		For {
			Set xVolID=$o(^DHCWMR.SS.VolumeI("VS","IndexBatchNumber"," "_$zcvt(BatchNumber,"U"),xVolID))
			Quit:xVolID=""
			
			Set xSubID=$o(^DHCWMR.SS.VolumeI("VS","IndexBatchNumber"," "_$zcvt(BatchNumber,"U"),xVolID,""),-1)
			Continue:xSubID=""
			Do BuildVolumeStatus
		}
	} ElseIf RegNo'="" {
		Set PatientID=##Class(DHCWMR.SSService.CommonSrv).GetPatientID(RegNo)
		Quit:PatientID="" $$$OK
		Set xVolID=0
		For {
			Set xVolID=$o(^DHCWMR.SS.VolumeI("VP","IndexPatientID",PatientID,xVolID))
			Quit:xVolID=""
			Set xSubID=0
			For {
				Set xSubID=$o(^DHCWMR.SS.VolumeD(xVolID,"S",xSubID))
				Quit:xSubID=""
				Do BuildVolumeStatus
			}
		}
	} Else {
		Set xTime=""
		For {
			Set xTime=$o(^DHCWMR.SS.OperationI("IndexItemDrDate",aMrTypeID,WorkItemID,+$h,xTime))
			Quit:xTime=""
			Set xID=0
			For {
				Set xID=$o(^DHCWMR.SS.OperationI("IndexItemDrDate",aMrTypeID,WorkItemID,+$h,xTime,xID))
				Quit:xID=""
				
				Set objOpera=##class(DHCWMR.SS.Operation).GetObjById(xID)
				Continue:'$IsObject(objOpera)
				Continue:objOpera.OPUserFrom'=aUserID
				Continue:objOpera.OPIsActive'=1
				Set BatchNumber=objOpera.OPBatchNumber
				
				Set xVolID=0
				For {
					Set xVolID=$o(^DHCWMR.SS.VolumeI("VS","IndexBatchNumber"," "_$zcvt(BatchNumber,"U"),xVolID))
					Quit:xVolID=""
					
					Set xSubID=$o(^DHCWMR.SS.VolumeI("VS","IndexBatchNumber"," "_$zcvt(BatchNumber,"U"),xVolID,""),-1)
					Continue:xSubID=""
					Do BuildVolumeStatus
				}
			}
		}
	}
	
	Quit $$$OK
	
BuildVolumeStatus
	Set xData=..BuildVolume(xVolID)
	Quit:xData=""
	
	Set StatusID=xVolID_"||"_xSubID
	Set objStatus=##Class(DHCWMR.SS.VolStatus).GetObjById(StatusID)
	Quit:'$IsObject(objStatus)
	Quit:objStatus.VSUpdoOpera'="" //撤销状态 作废U或回置B
	Quit:'$IsObject(objStatus.VSStatus)
	Quit:objStatus.VSStatus.%Id()'=WorkItemID
	Quit:(aUserID'="")&&(objStatus.VSUserFrom'=aUserID)
	//Quit:objStatus.VSActDate'=+$h  //非当天记录不允许撤销
	
	Set flg=##class(DHCWMR.SSService.OperationSrv).CheckUpdoOperation(StatusID)
	Set ProblemCode=$p(flg,"^",1)
	Set ProblemDesc=$p(flg,"^",2)
	
	Set HappenDate=objStatus.VSActDate
	;Set:HappenDate'="" HappenDate=$zd(HappenDate,3)
	Set:HappenDate'="" HappenDate=##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(HappenDate)
	Set HappenTime=objStatus.VSActTime
	Set:HappenTime'="" HappenTime=$zt(HappenTime,2)
	Set HappenUser=objStatus.VSUserFrom
	Set HappenUserDesc=""
	Set:HappenUser'="" HappenUserDesc=$p($g(^SSU("SSUSR",HappenUser)),"^",2)
	
	Set (RequestDate,RequestTime,RequestUser,RequestUserDesc)=""
	If $IsObject(objStatus.VSRequestDr){
		Set RequestDate=objStatus.VSRequestDr.RQRequestDate
		;Set:RequestDate'="" RequestDate=$zd(RequestDate,3)
		Set:RequestDate'="" RequestDate=##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(RequestDate)
		Set RequestTime=objStatus.VSRequestDr.RQRequestTime
		Set:RequestTime'="" RequestTime=$zt(RequestTime,2)
		Set RequestUser=objStatus.VSRequestDr.RQRequestUser
		Set RequestUserDesc=""
		Set:RequestUser'="" RequestUserDesc=$p($g(^SSU("SSUSR",RequestUser)),"^",2)
	}
	
	Set RowIndex=RowIndex+1
	Set RecordID=StatusID
	Set Data=$lb(RowIndex,RecordID,ProblemCode,ProblemDesc,HappenDate,HappenTime,HappenUser,HappenUserDesc,RequestDate,RequestTime,RequestUser,RequestUserDesc)_xData
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod QryUpdoVolListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryUpdoVolListExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryUpdoVolListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryUpdoVolListExecute ]
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

ClassMethod BuildVolume(aVolID As %String) As %List
{
	Set return=""
	Quit:aVolID="" return
	
	Set objVol=##Class(DHCWMR.SS.Volume).GetObjById(aVolID)
	Quit:'$IsObject(objVol) return
	Quit:objVol.SVIsActive'=1 return
	Quit:'$IsObject(objVol.SVMainDr) return
	Quit:objVol.SVMainDr.SMIsActive'=1 return
	Quit:'$IsObject(objVol.SVMainDr.SMMrType) return
	Set MainID=objVol.SVMainDr.%Id()
	Set OrdStep=objVol.SVOrdStep
	Set MrNo=objVol.SVMainDr.SMMrNo
	Set DischDate=objVol.SVDischDate
	Set MrClassType=objVol.SVMainDr.SMMrType.MTMrClass.MCCode
	Quit:(DischDate="")&&(MrClassType="I") return	//add by niepeng 20150206 无出院日期不允许任何操作
	;Set:DischDate'="" DischDate=$zd(DischDate,3)
	Set:DischDate'="" DischDate=##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(DischDate)
	Set BackDate=objVol.SVBackDate
	;Set:BackDate'="" BackDate=$zd(BackDate,3)
	Set:BackDate'="" BackDate=##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(BackDate)
	Set StatusDesc=objVol.SVStatus.WIDesc
	Set StepDesc=$s(OrdStep="A":"未回收",OrdStep="D":"回收",OrdStep="S":"归档",1:"临时")
	
	Set VolAdmStr=##Class(DHCWMR.SS.VolPaadm).GetAdmStrByVol(aVolID)
	Quit:VolAdmStr="" return
	Set VolAdmID=$p(VolAdmStr,",",1)
	
	Set objVolAdm=##Class(DHCWMR.SS.VolPaadm).GetPatObjByAdm("","",VolAdmID)
	Quit:'$IsObject(objVolAdm) return
	Set PatientID=objVolAdm.VPPatientID
	Set EpisodeID=objVolAdm.VPEpisodeID
	Set PapmiNo=$p($g(^PAPER(+PatientID,"PAT",1)),"^",1)
	Set PatName=objVolAdm.VPPatName
	Set Sex=objVolAdm.VPSex
	Set Birthday=objVolAdm.VPBirthday
	Set IdentityCode=objVolAdm.VPIdentityCode
	//Set Age=objVolAdm.VPAge
	//统一调用年龄计算方法
	Set tmpDate=$p($g(^PAADM(+EpisodeID)),"^",6)
	Set tmpTime=$p($g(^PAADM(+EpisodeID)),"^",7)
	Set Age=##class(DHCWMR.IO.FromHisSrv).GetPapmiAge(PatientID,EpisodeID,tmpDate,tmpTime)	//返回“*岁*月*天”
	
    Set AdmLoc=objVolAdm.VPAdmitDept
	Set AdmLocDesc=objVolAdm.VPAdmitDeptDesc
	Set:AdmLocDesc["-" AdmLocDesc=$p(AdmLocDesc,"-",2)
    Set AdmWard=objVolAdm.VPAdmitWard
	Set AdmWardDesc=objVolAdm.VPAdmitWardDesc
	Set:AdmWardDesc["-" AdmWardDesc=$p(AdmWardDesc,"-",2)
    Set DischDept=objVolAdm.VPDischDept
	Set DischDeptDesc=objVolAdm.VPDischDeptDesc
	Set:DischDeptDesc["-" DischDeptDesc=$p(DischDeptDesc,"-",2)
    Set DischWard=objVolAdm.VPDischWard
	Set DischWardDesc=objVolAdm.VPDischWardDesc
	Set:DischWardDesc["-" DischWardDesc=$p(DischWardDesc,"-",2)
	Set:DischDept'="" AdmLoc=DischDept
	Set:DischDeptDesc'="" AdmLocDesc=DischDeptDesc
	Set:DischWard'="" AdmWard=DischWard
	Set:DischWardDesc'="" AdmWardDesc=DischWardDesc
	Set AdmDate=objVolAdm.VPAdmitDate
	;Set:AdmDate'="" AdmDate=$zd(AdmDate,3)
	Set:AdmDate'="" AdmDate=##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(AdmDate)
	Set AdmTime=objVolAdm.VPAdmitTime
	Set:AdmTime'="" AdmTime=$zt(AdmDate,2)
	
	Set DischCondit=##Class(DHCWMR.IO.FromHisSrv).GetDischCondit(EpisodeID)  //update by zf 20150402 出院转归情况
	
	Set (EncryptLevel,PatLevel)=""
	Set SecretStr=##class(DHCWMR.IO.FromSecSrv).GetPatEncryptLevel(PatientID,.ErrMsg)
	Set:SecretStr'="" EncryptLevel=$p(SecretStr,"^",1)   //病人密级
	Set:SecretStr'="" PatLevel=$p(SecretStr,"^",2)		//病人级别
	
	Set return=$lb(aVolID,MainID,EpisodeID,PatientID,MrNo,PapmiNo,PatName,Sex,Age)
	Set return=return_$lb(AdmLocDesc,AdmWardDesc,AdmDate,AdmTime,DischCondit,DischDate,BackDate,StepDesc,StatusDesc)
	Set return=return_$lb(EncryptLevel,PatLevel)
	Quit return
}

}
