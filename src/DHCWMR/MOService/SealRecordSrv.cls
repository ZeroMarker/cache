/// 名称: DHCWMR.MOService.SealRecordSrv
/// 描述: 病案封存相关服务
/// 编写者：liyi
/// 编写日期: 2015-09-23
Class DHCWMR.MOService.SealRecordSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liyi
/// CreatDate：   2015-11-23
/// Description:  封存操作入口
/// Table：       DHCWMR_MO.SealRecord，DHCWMR_MO.SealRecordStatus，DHCWMR_MO.SealRecordVol.....
/// Input:		  aOperType:操作类型
///               aFromUserID：操作用户
///               aToUserID：验证用户
/// 			  aMrInfo:病案信息
/// 			  aSealInfo:封存信息
/// Return：      成功>=0,失败<1
/// w ##class(DHCWMR.MOService.SealRecordSrv).SealOper("U","9","","","1")
ClassMethod SealOper(aOperType As %String, aFromUserID As %String, aToUserID As %String, aMrInfo As %String, aSealInfo As %String)
{
	New (aOperType,aFromUserID,aToUserID,aMrInfo,aSealInfo)
	Set return = 0
	//Set ^LIYI=$lb(aOperType,aFromUserID,aToUserID,aMrInfo,aSealInfo)
	Quit:(aOperType="")||(aFromUserID="")||(aSealInfo="") return
	
	Set BatchNumber=##class(DHCWMR.SSService.OperationSrv).GetBatchNumber()
	
	If (aOperType="S"){
		Set RecordID = $p(aSealInfo,"^",1)
		Set ClientName = $p(aSealInfo,"^",2)
		Set ClientRelation = $p(aSealInfo,"^",3)
		Set CardType = $p(aSealInfo,"^",4)
		Set PersonalID = $p(aSealInfo,"^",5)
		Set Telephone = $p(aSealInfo,"^",6)
		Set Address = $p(aSealInfo,"^",7)
		Set Content = $p(aSealInfo,"^",8)
		Set Reason = $p(aSealInfo,"^",9)
		Set Count = $p(aSealInfo,"^",10)
		Set DocID = $p(aSealInfo,"^",11)			//医护人员ID
		Set MedUserID = $p(aSealInfo,"^",12)
		Set Note = $p(aSealInfo,"^",13)
		
		Set MainID = $p(aMrInfo,"^",1)
		Set VolumeIDs = $p(aMrInfo,"^",2)
		Quit:(MainID="")||(VolumeIDs="") return
		
		Set DocID=$o(^SSU("SSUSR",0,"CTPCP",DocID,""),-1)
		Set DocCode=$p($g(^SSU("SSUSR",DocID)),"^",1)
		Set DocName=$p($g(^SSU("SSUSR",DocID)),"^",2)
		Set MedUserID=$o(^SSU("SSUSR",0,"CTPCP",MedUserID,""),-1)
		Set MedUserCode=$p($g(^SSU("SSUSR",MedUserID)),"^",1)
		Set MedUserName=$p($g(^SSU("SSUSR",MedUserID)),"^",2)
		
		Set objMain = ##class(DHCWMR.SS.Main).GetObjById(MainID)
		Quit:'$IsObject(objMain) return
		Quit:'$IsObject(objMain.SMMrType) return
		Set MrTypeID=objMain.SMMrType.%Id()
		
		Set objWFItem=##class(DHCWMR.SS.WorkFItem).GetWFItemBySysOpera(MrTypeID,"SS")
		Quit:'$IsObject(objWFItem) return
		Quit:'$IsObject(objWFItem.WFIItem) return
		Set WorkItemID=objWFItem.WFIItem.%Id()
		
		Tstart
		Set return="-1^保存病案操作失败"
		Set ErrorFlg = 1
		For xInd=1:1:$l(VolumeIDs,",") {
			Set VolumeID = $p(VolumeIDs,",",xInd)
			Continue:VolumeID=""
			Set xflg = ##class(DHCWMR.SSService.OperationSrv).Operation(VolumeID,objWFItem.%Id(),"",aFromUserID,aToUserID,"",BatchNumber,"")
			Set:(+xflg)<1 ErrorFlg=0
			Quit:ErrorFlg<1
		}
		If (+ErrorFlg)<1 Trollback
		Quit:(+ErrorFlg)<1 return
			
		Set return="-2^保存病案封存记录失败"
		Set InputStr=""
		Set $p(InputStr,"^",1)=RecordID
		Set $p(InputStr,"^",2)=MrTypeID
		Set $p(InputStr,"^",3)=MainID
		Set $p(InputStr,"^",4)=aOperType
		Set $p(InputStr,"^",5)=+$h
		Set $p(InputStr,"^",6)=$p($h,",",2)
		Set $p(InputStr,"^",7)=aFromUserID 
		Set $p(InputStr,"^",8)=""
		Set $p(InputStr,"^",9)=""
		Set $p(InputStr,"^",10)=""
		Set $p(InputStr,"^",11)=ClientName
		Set $p(InputStr,"^",12)=ClientRelation
		Set $p(InputStr,"^",13)=CardType
		Set $p(InputStr,"^",14)=PersonalID
		Set $p(InputStr,"^",15)=Telephone
		Set $p(InputStr,"^",16)=Address
		Set $p(InputStr,"^",17)=Content
		Set $p(InputStr,"^",18)=Reason
		Set $p(InputStr,"^",19)=Count
		Set $p(InputStr,"^",20)=DocCode
		Set $p(InputStr,"^",21)=DocName
		Set $p(InputStr,"^",22)=MedUserCode
		Set $p(InputStr,"^",23)=MedUserName
		Set $p(InputStr,"^",24)=Note
		Set $p(InputStr,"^",25)=+$h
		Set $p(InputStr,"^",26)=$p($h,",",2)
		Set $p(InputStr,"^",27)=aFromUserID
		Set $p(InputStr,"^",28)=+$h
		Set $p(InputStr,"^",29)=$p($h,",",2)
		Set $p(InputStr,"^",30)=aFromUserID
		Set flg=##class(DHCWMR.MO.SealRecord).Update(InputStr,"^")
		If (+flg)<1 TRollback
		Quit:(+flg)<1 return
		Set RecordID = +flg
		
		Set return="-3^保存病案封存卷失败"
		Set ErrorFlg=1
		For xInd=1:1:$l(VolumeIDs,",") {
			Set VolumeID = $p(VolumeIDs,",",xInd)
			Continue:VolumeID=""
			Set InputStr=""
			Set $p(InputStr,"^",1)=RecordID
			Set $p(InputStr,"^",2)=""
			Set $p(InputStr,"^",3)=VolumeID
			Set flg=##class(DHCWMR.MO.SealRecordVol).Update(InputStr,"^")
			Set:(+flg)<1 ErrorFlg=0
			Quit:ErrorFlg<1
		}
		If (+ErrorFlg)<1 Trollback
		Quit:(+ErrorFlg)<1 return
		
		Set return="-4^保存病案封存状态失败"
		Set InputStr=""
		Set $p(InputStr,"^",1)=RecordID
		Set $p(InputStr,"^",2)=""
		Set $p(InputStr,"^",3)=WorkItemID      //操作项目
		Set $p(InputStr,"^",4)=aFromUserID     //操作员
		Set $p(InputStr,"^",5)=+$h             //操作日期
		Set $p(InputStr,"^",6)=$p($h,",",2)    //操作时间
		Set $p(InputStr,"^",7)=aToUserID       //验证用户
		Set $p(InputStr,"^",8)=BatchNumber     //批次号
		Set $p(InputStr,"^",9)=""              //撤销标记
		Set $p(InputStr,"^",10)=""             //撤销日期
		Set $p(InputStr,"^",11)=""             //撤销时间
		Set $p(InputStr,"^",12)=""             //撤销人
		Set $p(InputStr,"^",13)=""             //撤销原因
		Set $p(InputStr,"^",14)=""             //备注信息
		Set flg=##class(DHCWMR.MO.SealRecordStatus).Update(InputStr,"^")
		If (+flg)<1 TRollback
		Quit:(+flg)<1 return
	}elseif (aOperType="F"){
		Set RecordIDs = $p(aSealInfo,"^",1)
		Quit:RecordIDs="" return
		
		Tstart
		Set ErrorFlg = 1
		For indS=1:1:$l(RecordIDs,",") {
			Set RecordID=$p(RecordIDs,",",indS)
			Continue:RecordID=""
			Set objRecord = ##class(DHCWMR.MO.SealRecord).GetObjById(RecordID)
			Continue:'$isobject(objRecord)
		
			Set MrTypeID=objRecord.SRMrType.%Id()
		
			Set objWFItem=##class(DHCWMR.SS.WorkFItem).GetWFItemBySysOpera(MrTypeID,"SF")
			Continue:'$IsObject(objWFItem)
			Continue:'$IsObject(objWFItem.WFIItem)
			Set WorkItemID=objWFItem.WFIItem.%Id()
		
			Set return="-1^保存病案操作失败"
			For indVol=1:1:objRecord.ChildVol.Count() {
				Set objRecordVol=objRecord.ChildVol.GetAt(indVol)
				Continue:'$IsObject(objRecordVol)
				Set VolumeID=objRecordVol.RVolumeDr.%Id()
				Continue:VolumeID=""
				Set xflg = ##class(DHCWMR.SSService.OperationSrv).Operation(VolumeID,objWFItem.%Id(),"",aFromUserID,aToUserID,"",BatchNumber,"")
				Set:(+xflg)<1 ErrorFlg=-1
				Quit:ErrorFlg<1
			} 
			Quit:(+ErrorFlg)<1
			
			Set return="-2^保存病案封存记录失败"
			Set InputStr=""
			Set $p(InputStr,"^",1)=RecordID
			Set $p(InputStr,"^",2)=MrTypeID
			Set $p(InputStr,"^",3)=objRecord.SRMainDr.%Id()
			Set $p(InputStr,"^",4)=aOperType
			Set $p(InputStr,"^",5)=objRecord.SRSealDate
			Set $p(InputStr,"^",6)=objRecord.SRSealTime
			Set $p(InputStr,"^",7)=objRecord.SRSealUser 
			Set $p(InputStr,"^",8)=+$h
			Set $p(InputStr,"^",9)=$p($h,",",2)
			Set $p(InputStr,"^",10)=aFromUserID
			Set $p(InputStr,"^",11)=objRecord.SRClientName
			Set $p(InputStr,"^",12)=objRecord.SRClientRelation
			Set $p(InputStr,"^",13)=objRecord.SRCardTypeDr
			Set $p(InputStr,"^",14)=objRecord.SRPersonalID
			Set $p(InputStr,"^",15)=objRecord.SRTelephone
			Set $p(InputStr,"^",16)=objRecord.SRAddress
			Set $p(InputStr,"^",17)=objRecord.SRContent
			Set $p(InputStr,"^",18)=objRecord.SRPurpose
			Set $p(InputStr,"^",19)=objRecord.SRCount
			Set $p(InputStr,"^",20)=objRecord.SRDocCode
			Set $p(InputStr,"^",21)=objRecord.SRDocName
			Set $p(InputStr,"^",22)=objRecord.SRMedUserCode
			Set $p(InputStr,"^",23)=objRecord.SRMedUserName
			Set $p(InputStr,"^",24)=objRecord.SRNote
			Set $p(InputStr,"^",25)=objRecord.SRCreateDate
			Set $p(InputStr,"^",26)=objRecord.SRCreateTime
			Set $p(InputStr,"^",27)=objRecord.SRCreateUser
			Set $p(InputStr,"^",28)=+$h
			Set $p(InputStr,"^",29)=$p($h,",",2)
			Set $p(InputStr,"^",30)=aFromUserID
			Set flg=##class(DHCWMR.MO.SealRecord).Update(InputStr,"^")
			Set:(+xflg)<1 ErrorFlg=-1
			Quit:(+ErrorFlg)<1
		
			Set return="-4^保存病案封存状态失败"
			Set InputStr=""
			Set $p(InputStr,"^",1)=RecordID
			Set $p(InputStr,"^",2)=""
			Set $p(InputStr,"^",3)=WorkItemID      //操作项目
			Set $p(InputStr,"^",4)=aFromUserID     //操作员
			Set $p(InputStr,"^",5)=+$h             //操作日期
			Set $p(InputStr,"^",6)=$p($h,",",2)    //操作时间
			Set $p(InputStr,"^",7)=aToUserID       //验证用户
			Set $p(InputStr,"^",8)=BatchNumber     //批次号
			Set $p(InputStr,"^",9)=""              //撤销标记
			Set $p(InputStr,"^",10)=""             //撤销日期
			Set $p(InputStr,"^",11)=""             //撤销时间
			Set $p(InputStr,"^",12)=""             //撤销人
			Set $p(InputStr,"^",13)=""             //撤销原因
			Set $p(InputStr,"^",14)=""             //备注信息
			Set flg=##class(DHCWMR.MO.SealRecordStatus).Update(InputStr,"^")
			Set:(+xflg)<1 ErrorFlg=-1
			Quit:(+ErrorFlg)<1
		}
		If (+ErrorFlg)<1 Trollback
		Quit:(+ErrorFlg)<1
	}else {
		Set RecordID = $p(aSealInfo,"^",1)
		Quit:RecordID="" return
		
		Set objRecord = ##class(DHCWMR.MO.SealRecord).GetObjById(RecordID)
		Quit:'$isobject(objRecord) return
		
		Tstart
		Set MrTypeID=objRecord.SRMrType.%Id()
		Set MainID=objRecord.SRMainDr.%Id()
		Set return="-4^修正卷状态失败"
		Set ErrorFlg = 1
		If (objRecord.SRStatus'="U") {			
			If objRecord.SRStatus="S"{
				Set objWFItem=##class(DHCWMR.SS.WorkFItem).GetWFItemBySysOpera(MrTypeID,"SF")
			}
			If objRecord.SRStatus="F"
			{
				Set objWFItem=##class(DHCWMR.SS.WorkFItem).GetWFItemBySysOpera(MrTypeID,"SS")
			}
			Quit:'$IsObject(objWFItem) return
			Quit:'$IsObject(objWFItem.WFIItem) return
			Set WorkItemID=objWFItem.WFIItem.%Id()
			Set WFIPostStep = objWFItem.WFIPostStep
			
			Set InputStr=""
			Set InputStr=InputStr_"^"_MrTypeID
			Set InputStr=InputStr_"^"_WorkItemID
			Set InputStr=InputStr_"^"_aFromUserID
			Set InputStr=InputStr_"^"_""  //操作日期
			Set InputStr=InputStr_"^"_""  //操作时间
			Set InputStr=InputStr_"^"_""
			Set InputStr=InputStr_"^"_BatchNumber
			Set InputStr=InputStr_"^"_1
			Set InputStr=InputStr_"^"_""
			Set flg=##class(DHCWMR.SS.Operation).Update(InputStr,"^")
			If (+flg)<1 TRollback
			Quit:(+flg)<1 return
			Set OperationID=+flg
			
			For indVol=1:1:objRecord.ChildVol.Count() {
				Set objRecordVol=objRecord.ChildVol.GetAt(indVol)
				Continue:'$IsObject(objRecordVol)
				Set VolumeID=objRecordVol.RVolumeDr.%Id()
				Continue:VolumeID=""
				Set objSealVol = objRecordVol.RVolumeDr
				
				Set InputStr=VolumeID
				Set InputStr=InputStr_"^"_""
				Set InputStr=InputStr_"^"_WorkItemID
				Set InputStr=InputStr_"^"_aFromUserID
				Set InputStr=InputStr_"^"_+$h
				Set InputStr=InputStr_"^"_$p($h,",",2)
				Set InputStr=InputStr_"^"_""
				Set InputStr=InputStr_"^"_BatchNumber
				Set InputStr=InputStr_"^"_"R"           //修正标记
				Set InputStr=InputStr_"^"_+$h           //修正日期
				Set InputStr=InputStr_"^"_$p($h,",",2)  //修正时间
				Set InputStr=InputStr_"^"_aFromUserID   //修正人
				Set InputStr=InputStr_"^"_""
				Set InputStr=InputStr_"^"_""
				Set InputStr=InputStr_"^"_""
				Set InputStr=InputStr_"^"_""
				Set InputStr=InputStr_"^"_""
				Set flg=##class(DHCWMR.SS.VolStatus).Update(InputStr,"^")
				Set:(+flg)<1 ErrorFlg=-1
				Quit:(+flg)<1
				
				Set InputStr=VolumeID
				Set InputStr=InputStr_"^"_MainID
				Set InputStr=InputStr_"^"_WorkItemID
				Set InputStr=InputStr_"^"_objSealVol.SVOrdStep
				Set InputStr=InputStr_"^"_objSealVol.SVIsLend
				Set InputStr=InputStr_"^"_objSealVol.SVIsCopy
				Set InputStr=InputStr_"^"_objSealVol.SVIsStore
				Set InputStr=InputStr_"^"_objSealVol.SVQCLock
				Set InputStr=InputStr_"^"_objSealVol.SVDischDate
				Set InputStr=InputStr_"^"_objSealVol.SVBackDate
				Set InputStr=InputStr_"^"_objSealVol.SVIPTimes
				Set InputStr=InputStr_"^"_objSealVol.SVBuildDate
				Set InputStr=InputStr_"^"_objSealVol.SVBuildTime
				Set InputStr=InputStr_"^"_objSealVol.SVIsActive
				Set InputStr=InputStr_"^"_objSealVol.SVResume
				Set InputStr=InputStr_"^"_objSealVol.SVBarcode
				Set InputStr=InputStr_"^"_objSealVol.SVIsExPaper
				Set flg=##class(DHCWMR.SS.Volume).Update(InputStr,"^")
				Set:(+flg)<1 ErrorFlg=-1
				Quit:(+flg)<1
			}
		}
		If (+ErrorFlg)<1 Trollback
		Quit:(+ErrorFlg)<1
			
		If (objRecord.SRStatus="F")   //解封作废-->封存
		{
			Set CurrStatus = "S"
		}else{		//封存作废-->作废
			Set CurrStatus = "U"
		}
			
		Set return="-2^保存病案封存记录失败"
		Set InputStr=""
		Set $p(InputStr,"^",1)=RecordID
		Set $p(InputStr,"^",2)=MrTypeID
		Set $p(InputStr,"^",3)=objRecord.SRMainDr.%Id()
		Set $p(InputStr,"^",4)=CurrStatus
		Set $p(InputStr,"^",5)=objRecord.SRSealDate
		Set $p(InputStr,"^",6)=objRecord.SRSealTime
		Set $p(InputStr,"^",7)=objRecord.SRSealUser 
		Set $p(InputStr,"^",8)=objRecord.SRFreeDate
		Set $p(InputStr,"^",9)=objRecord.SRFreeTime
		Set $p(InputStr,"^",10)=objRecord.SRFreeUser
		Set $p(InputStr,"^",11)=objRecord.SRClientName
		Set $p(InputStr,"^",12)=objRecord.SRClientRelation
		Set $p(InputStr,"^",13)=objRecord.SRCardTypeDr
		Set $p(InputStr,"^",14)=objRecord.SRPersonalID
		Set $p(InputStr,"^",15)=objRecord.SRTelephone
		Set $p(InputStr,"^",16)=objRecord.SRAddress
		Set $p(InputStr,"^",17)=objRecord.SRContent
		Set $p(InputStr,"^",18)=objRecord.SRPurpose
		Set $p(InputStr,"^",19)=objRecord.SRCount
		Set $p(InputStr,"^",20)=objRecord.SRDocCode
		Set $p(InputStr,"^",21)=objRecord.SRDocName
		Set $p(InputStr,"^",22)=objRecord.SRMedUserCode
		Set $p(InputStr,"^",23)=objRecord.SRMedUserName
		Set $p(InputStr,"^",24)=objRecord.SRNote
		Set $p(InputStr,"^",25)=objRecord.SRCreateDate
		Set $p(InputStr,"^",26)=objRecord.SRCreateTime
		Set $p(InputStr,"^",27)=objRecord.SRCreateUser
		Set $p(InputStr,"^",28)=+$h
		Set $p(InputStr,"^",29)=$p($h,",",2)
		Set $p(InputStr,"^",30)=aFromUserID
		Set flg=##class(DHCWMR.MO.SealRecord).Update(InputStr,"^")
		If (+flg)<1 TRollback
		Quit:(+flg)<1 return
		Set RecordID = +flg
		
		Set return="-4^保存病案封存状态失败"
		Set InputStr=""
		Set $p(InputStr,"^",1)=RecordID
		Set $p(InputStr,"^",2)=""
		Set $p(InputStr,"^",3)=WorkItemID      //操作项目
		Set $p(InputStr,"^",4)=aFromUserID     //操作员
		Set $p(InputStr,"^",5)=+$h             //操作日期
		Set $p(InputStr,"^",6)=$p($h,",",2)    //操作时间
		Set $p(InputStr,"^",7)=aToUserID       //验证用户
		Set $p(InputStr,"^",8)=BatchNumber     //批次号
		Set $p(InputStr,"^",9)=""              //撤销标记
		Set $p(InputStr,"^",10)=""             //撤销日期
		Set $p(InputStr,"^",11)=""             //撤销时间
		Set $p(InputStr,"^",12)=""             //撤销人
		Set $p(InputStr,"^",13)=""             //撤销原因
		Set $p(InputStr,"^",14)=""             //备注信息
		Set flg=##class(DHCWMR.MO.SealRecordStatus).Update(InputStr,"^")
		If (+flg)<1 TRollback
		Quit:(+flg)<1 return
	}
	Tcommit
	
	Set return = RecordID
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2015-10-14
/// Description:  查询封存卷
/// Table：       DHCWMR.MO.SealRecord
/// Return：      返回Query
/// do ##class(%Library.ResultSet).RunQuery("DHCWMR.MOService.SealRecordSrv","QrySealVolume","7","500001")
Query QrySealVolume(aMrTypeID As %String, aMrNo As %String) As %Query(ROWSPEC = "VolID:%String,MainID:%String,EpisodeID:%String,PatientID:%String,MrNo:%String,PapmiNo:%String,PatName:%String,Sex:%String,Age:%String,IdentityCode:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmDate:%String,AdmTime:%String,DischDate:%String,BackDate:%String,StepDesc:%String,StatusDesc:%String")
{
}

ClassMethod QrySealVolumeExecute(ByRef qHandle As %Binary, aMrTypeID As %String, aMrNo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aMrTypeID="")||(aMrNo="") $$$OK
	
	Set aMrNo=$zcvt(aMrNo,"U")
	Set xMainID=""
	For{
		Set xMainID=$o(^DHCWMR.SS.MainI("IndexTypeNoAct",aMrTypeID," "_aMrNo,1,xMainID))
		Quit:xMainID=""
		
		Set xVolID=0
		For {
			Set xVolID=$o(^DHCWMR.SS.VolumeI("IndexSVMainDr",xMainID,xVolID))
			Quit:xVolID=""

			Set Data=..BuildVolume(xVolID)
			Continue:Data=""
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod QrySealVolumeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySealVolumeExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QrySealVolumeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySealVolumeExecute ]
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
	Quit:objVol.SVIsActive'=1 return  //卷无效
	Set objMain=objVol.SVMainDr
	Quit:'$IsObject(objMain) return
	Quit:objMain.SMIsActive'=1 return  //病案无效
	Quit:'$IsObject(objMain.SMMrType) return
	Quit:objMain.SMMrType.%Id()'=aMrTypeID return  //病案类型不一致
	Set MainID=objMain.%Id()
	
	Set OrdStep=objVol.SVOrdStep
	Set MrNo=objVol.SVMainDr.SMMrNo
	Set DischDate=objVol.SVDischDate
	;Set:DischDate'="" DischDate=$zd(DischDate,3)
	Set:DischDate'="" DischDate=##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(DischDate)
	Set BackDate=objVol.SVBackDate
	;Set:BackDate'="" BackDate=$zd(BackDate,3)
	Set:BackDate'="" BackDate=##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(BackDate)
	Set StatusDesc=objVol.SVStatus.WIDesc
	Set StepDesc=$s(OrdStep="A":"未回收",OrdStep="D":"回收",OrdStep="S":"归档",1:"临时") //fix bug 6537 by pylian 2015-01-21
	
	Set VolAdmStr=##Class(DHCWMR.SS.VolPaadm).GetAdmStrByVol(aVolID)
	Quit:VolAdmStr="" return
	Set VolAdmID=$p(VolAdmStr,",",1)
	Set EpisodeID=$p(VolAdmStr,",",2)
	Set AdmLoc=$p(VolAdmStr,",",3)
	Set AdmWard=$p(VolAdmStr,",",4)
	
	Set objVolAdm=##Class(DHCWMR.SS.VolPaadm).GetPatObjByAdm("","",VolAdmID)
	Quit:'$IsObject(objVolAdm) return
	Set PatientID=objVolAdm.VPPatientID
	Set EpisodeID=objVolAdm.VPEpisodeID
	Set PapmiNo=$p($g(^PAPER(+PatientID,"PAT",1)),"^",1)
	Set PatName=objVolAdm.VPPatName
	Set Sex=objVolAdm.VPSex
	Set Birthday=objVolAdm.VPBirthday
	Set IdentityCode=objVolAdm.VPIdentityCode
	Set Age=objVolAdm.VPAge
	
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
	
	Set return=$lb(aVolID,MainID,EpisodeID,PatientID,MrNo,PapmiNo,PatName,Sex,Age,IdentityCode)
	Set return=return_$lb(AdmLocDesc,AdmWardDesc,AdmDate,AdmTime,DischDate,BackDate,StepDesc,StatusDesc)
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2015-10-14
/// Description:  查询病案封存记录
/// Table：       DHCWMR.MO.SealRecord
/// Return：      返回Query
/// do ##class(%Library.ResultSet).RunQuery("DHCWMR.MOService.SealRecordSrv","QrySealRecord","3","7","2015-10-05","2015-12-15","","S")
Query QrySealRecord(aHospID As %String, aMrTypeID As %String, aDateFrom As %String, aDateTo As %String, aMrNo As %String, aQryType As %String) As %Query(ROWSPEC = "RecordID:%String,PatientID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,Status:%String,StatusDesc:%String,SealDate:%String,SealTime:%String,SealUser:%String,FreeDate:%String,FreeTime:%String,FreeUser:%String")
{
}

ClassMethod QrySealRecordExecute(ByRef qHandle As %Binary, aHospID As %String, aMrTypeID As %String, aDateFrom As %String, aDateTo As %String, aMrNo As %String, aQryType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	//Set ^LIYI = $lb(aHospID,aMrTypeID,aDateFrom,aDateTo,aMrNo,aQryType)
	;Set:aDateFrom["/" aDateFrom=$zdh(aDateFrom,4)
	;Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set aDateFrom=##Class(DHCWMR.SSService.CommonSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCWMR.SSService.CommonSrv).DateHtmlToLogical(aDateTo)
	Set:aDateFrom'="" aDateFrom=+aDateFrom
	;Set:aDateTo["/" aDateTo=$zdh(aDateTo,4)
	;Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set:aDateTo'="" aDateTo=+aDateTo
	Quit:(aDateFrom="")||(aDateTo="")||(aHospID="")||(aMrTypeID="") $$$OK
	
	If aMrNo=""{
		If aQryType="S" { //封存列表
			For xDate=aDateFrom:1:aDateTo {
				Set xStatus = ""
				For {
					Set xStatus=$o(^DHCWMR.MO.SealRecordI("IndexMrTypeSealDateStatus",aMrTypeID,xDate,xStatus))
					Quit:xStatus=""
					
					Set xSealRecordID=""
					For {
						Set xSealRecordID=$o(^DHCWMR.MO.SealRecordI("IndexMrTypeSealDateStatus",aMrTypeID,xDate,xStatus,xSealRecordID))
						Quit:xSealRecordID=""
						
						Set Data=..BuildSealRecordData(xSealRecordID,aQryType)
						Continue:Data=""
						Set ^CacheTemp(repid,ind)=Data
						Set ind=ind+1
					}
				}
			}
		} ElseIf aQryType="F" {	//解封列表
			For xDate=aDateFrom:1:aDateTo {
				Set xStatus = ""
				For {
					Set xStatus=$o(^DHCWMR.MO.SealRecordI("IndexMrTypeFreeDateStatus",aMrTypeID,xDate,xStatus))
					Quit:xStatus=""
					
					Set xSealRecordID=""
					For {
						Set xSealRecordID=$o(^DHCWMR.MO.SealRecordI("IndexMrTypeFreeDateStatus",aMrTypeID,xDate,xStatus,xSealRecordID))
						Quit:xSealRecordID=""
						
						Set Data=..BuildSealRecordData(xSealRecordID,aQryType)
						Continue:Data=""
						Set ^CacheTemp(repid,ind)=Data
						Set ind=ind+1
					}
				}
			}
		}
	}else{
		Set xMainID=""
		For{
			Set xMainID=$o(^DHCWMR.SS.MainI("IndexTypeNoAct",aMrTypeID," "_aMrNo,1,xMainID))
			Quit:xMainID=""
			
			//处理修改病案号之后的历史数据
			Set HisMainIDs=##class(DHCWMR.SS.Main).GetHisMainByID(xMainID)
			If HisMainIDs'="" {
				Set flg=##Class(DHCWMR.MO.SealRecord).UpdateErrorMainDr(HisMainIDs)
			}
			
			Set xSealRecordID=""
			For {
				Set xSealRecordID=$o(^DHCWMR.MO.SealRecordI("IndexMainDr",xMainID,xSealRecordID))
				Quit:xSealRecordID=""
				
				Set Data=..BuildSealRecordData(xSealRecordID,aQryType)
				Continue:Data=""
			
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod QrySealRecordClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySealRecordExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QrySealRecordFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySealRecordExecute ]
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

ClassMethod BuildSealRecordData(ID, QryType) As %List
{
	Set return=""
	Quit:(ID="")||(QryType="") return
	
	Set objRecord = ##class(DHCWMR.MO.SealRecord).GetObjById(ID)
	Quit:'$IsObject(objRecord) return
	Quit:objRecord.SRStatus'=aQryType return    //状态检查
	Quit:'$IsObject(objRecord.SRMainDr) return
	Quit:'$IsObject(objRecord.SRMainDr.SMMrType) return
	Set MainID=objRecord.SRMainDr.%Id()
	Set MrNo=objRecord.SRMainDr.SMMrNo
	Set MrTypeID=objRecord.SRMainDr.SMMrType.%Id()
	
	Set Status = objRecord.SRStatus
	Set:Status="S" StatusDesc = "封存"
	Set:Status="F" StatusDesc = "解封"
	Set:Status="U" StatusDesc = "作废"
	Set SealDate = objRecord.SRSealDate
	;Set:SealDate'="" SealDate=$zd(SealDate,3)
	Set:SealDate'="" SealDate=##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(SealDate)
	Set SealTime = objRecord.SRSealTime
	Set:SealTime'="" SealTime=$zt(SealTime)
	Set SealUser = objRecord.SRSealUser
	Set:SealUser'="" SealUser=$p($g(^SSU("SSUSR",SealUser)),"^",2)
	Set FreeDate = objRecord.SRFreeDate
	;Set:FreeDate'="" FreeDate=$zd(FreeDate,3)
	Set:FreeDate'="" FreeDate=##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(FreeDate)
	Set FreeTime = objRecord.SRFreeTime
	Set:FreeTime'="" FreeTime=$zt(FreeTime)
	Set FreeUser = objRecord.SRFreeUser
	Set:FreeUser'="" FreeUser=$p($g(^SSU("SSUSR",FreeUser)),"^",2)
	
	Set PatientID=##class(DHCWMR.SSService.MrNoSrv).GetPatientIDByMrNo(MrNo,MrTypeID)
	Quit:PatientID="" return
	Set PapmiNo=$p(^PAPER(PatientID,"PAT",1),"^",1)            //登记号
	Set PatName=$p($g(^PAPER(PatientID,"ALL")),"^",1)          //姓名
	Set Sex=$p($g(^PAPER(PatientID,"ALL")),"^",7)              //性别
	Set:Sex'="" Sex=$p($g(^CT("SEX",Sex)),"^",2)
	Set Age=##class(DHCWMR.IO.FromHisSrv).GetPapmiAge(PatientID,"","","")  //年龄
	
	Set return = $lb(ID,PatientID,PapmiNo,MrNo,PatName,Sex,Age,Status,StatusDesc,SealDate,SealTime,SealUser,FreeDate,FreeTime,FreeUser)
	Quit return
}

}
