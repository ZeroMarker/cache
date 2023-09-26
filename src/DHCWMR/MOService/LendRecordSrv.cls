/// 名称: DHCWMR.MOService.LendRecordSrv
/// 描述: 病案借阅相关服务
/// 编写者：liyi
/// 编写日期: 2015-09-23
Class DHCWMR.MOService.LendRecordSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2015-09-30
/// Description:  插入申请出库记录
/// Input：		  aOperType：操作类型
///               aFromUserID：操作用户
///               aToUserID：验证用户
///               aMRecord：病案操作记录
///               aLRecord：借阅操作记录
///               aDetail：操作明细
/// Return：      成功>=0,失败<1
/// w ##class(DHCWMR.MOService.LendRecordSrv).LendOperation("U","9","","","7","","")
ClassMethod LendOperation(aOperType As %String, aFromUserID As %String, aToUserID As %String, aMRecord As %String, aLRecord As %String, aDetail As %String, aLendFlag As %String = "") As %String
{
	New (aOperType,aFromUserID,aToUserID,aMRecord,aLRecord,aDetail,aLendFlag)
	Set return=0
	Quit:(aOperType="")||(aFromUserID="") return
	Quit:(aMRecord="")&&(aLRecord="") return
	
	//Set ^ZF=$lb(aOperType,aFromUserID,aToUserID,aMRecord,aLRecord,aDetail,aLendFlag)
	
	Set LLocID	        = $p(aDetail,"^",1)
	Set LLocDesc 	    = $p(aDetail,"^",2)
	Set LLocTel 		= $p(aDetail,"^",3)
	Set LCareProvID     = $p(aDetail,"^",4)			//医护人员ID
	Set LUserDesc   	= $p(aDetail,"^",5)
	Set LUserTel 	    = $p(aDetail,"^",6)
	Set Purpose 	    = $p(aDetail,"^",7)
	Set ExpBackDate     = $p(aDetail,"^",8)
	Set Note 		    = $p(aDetail,"^",9)
	Set EpisodeID       = $p(aDetail,"^",10)
	Set Category        = +$p(aDetail,"^",11)
	Set BatchNumber=##class(DHCWMR.SSService.OperationSrv).GetBatchNumber()
	If (aOperType="R")||((aOperType="L")&(aMRecord'="")) {
		Set MainID=$p(aMRecord,"^",1)
		Set VolumeIDs=$p(aMRecord,"^",2)
		If MainID="" {
			Set VolumeID=$p(VolumeIDs,",",1)
			Quit:VolumeID="" return
			Set objVolume=##Class(DHCWMR.SS.Volume).GetObjById(VolumeID)
			Quit:'$IsObject(objVolume) return
			Quit:'$IsObject(objVolume.SVMainDr) return
			Set MainID=objVolume.SVMainDr.%Id()
		}
		Quit:MainID="" return
		
		Set objMain = ##class(DHCWMR.SS.Main).GetObjById(MainID)
		Quit:'$IsObject(objMain) return
		Quit:'$IsObject(objMain.SMMrType) return
		Set MrTypeID=objMain.SMMrType.%Id()
		If VolumeIDs="" {
			Set xVolID=""
			For {
				Set xVolID=$o(^DHCWMR.SS.VolumeI("IndexSVMainDr",MainID,xVolID))
				Quit:xVolID=""
				
				Set objVol=##class(DHCWMR.SS.Volume).GetObjById(xVolID)
				Continue:'$IsObject(objVol)
				Continue:objVol.SVIsActive'=1
				Set VolumeIDs=VolumeIDs_","_xVolID
			}
			Set:VolumeIDs'="" VolumeIDs=$e(VolumeIDs,2,$l(VolumeIDs))
		}
		Quit:VolumeIDs="" return
		
		If aOperType="R" {
			Set objWFItem=##class(DHCWMR.SS.WorkFItem).GetWFItemBySysOpera(MrTypeID,"LR")
		} ElseIf aOperType="L" {
			Set objWFItem=##class(DHCWMR.SS.WorkFItem).GetWFItemBySysOpera(MrTypeID,"LL")
		}
		Quit:'$IsObject(objWFItem) return
		Quit:'$IsObject(objWFItem.WFIItem) return
		Set WorkItemID=objWFItem.WFIItem.%Id()
		
		Set (LLocID,LLocCode,LLocDesc,LUserID,LUserCode,LUserDesc)=""
		If EpisodeID'=""{	//就诊相关申请：挂号;建档
			Set AdmStr = $g(^PAADM(EpisodeID))
			Set LCareProvID=$p(AdmStr,"^",9)
			Set LLocID =$p(AdmStr,"^",4)
		}
		If LCareProvID'="" {
			Set LUserID=$o(^SSU("SSUSR",0,"CTPCP",LCareProvID,""),-1)
			Set LUserCode = $p($g(^CTPCP(LCareProvID,1)),"^",1)		//借阅人员工号
			If (LUserID'=""){
				Set LUserDesc=$p($g(^SSU("SSUSR",LUserID)),"^",2)
			}
		}
		Set:LLocID="" LLocID=$p(aDetail,"^",1)
		If LLocID'="" {
			Set LLocCode=$p($g(^CTLOC(LLocID)),"^",1)
			Set LLocDesc=$p($g(^CTLOC(LLocID)),"^",2)
		}
		
		TStart
		
		Set return="-1^保存病案操作失败"
		If (aOperType="L"){
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
		}
		
		Set return="-2^处理病案借阅记录失败"
		Set InputStr=""
		Set $p(InputStr,"^",1)=""
		Set $p(InputStr,"^",2)=objMain.SMMrType.%Id()
		Set $p(InputStr,"^",3)=objMain.%Id()
		If aOperType="R" {
			Set $p(InputStr,"^",4)="R"               //申请状态
			Set $p(InputStr,"^",5)=+$h               //申请日期
			Set $p(InputStr,"^",6)=$p($h,",",2)      //申请时间
			Set $p(InputStr,"^",7)=aFromUserID       //申请人
			Set $p(InputStr,"^",8)=""                //出库日期
			Set $p(InputStr,"^",9)=""                //出库时间
			Set $p(InputStr,"^",10)=""               //出库人
		} ElseIf aOperType="L" {
			Set $p(InputStr,"^",4)="L"               //出库状态
			Set $p(InputStr,"^",5)=""                //申请日期
			Set $p(InputStr,"^",6)=""                //申请时间
			Set $p(InputStr,"^",7)=""                //申请人
			Set $p(InputStr,"^",8)=+$h               //出库日期
			Set $p(InputStr,"^",9)=$p($h,",",2)      //出库时间
			Set $p(InputStr,"^",10)=aFromUserID      //出库人
		}
		Set $p(InputStr,"^",11)=""                //入库日期
		Set $p(InputStr,"^",12)=""                //入库时间
		Set $p(InputStr,"^",13)=""                //入库人
		Set $p(InputStr,"^",14)=LLocID            //借阅科室
		Set $p(InputStr,"^",15)=LLocCode          //借阅科室代码
		Set $p(InputStr,"^",16)=LLocDesc          //借阅科室名称
		Set $p(InputStr,"^",17)=LLocTel           //借阅科室电话
		Set $p(InputStr,"^",18)=LUserID           //借阅人员
		Set $p(InputStr,"^",19)=LUserCode         //借阅人员工号
		Set $p(InputStr,"^",20)=LUserDesc         //借阅人员名称
		Set $p(InputStr,"^",21)=LUserTel          //借阅人员电话
		Set $p(InputStr,"^",22)=Purpose           //借阅目的
		Set $p(InputStr,"^",23)=ExpBackDate       //预计归还时间
		Set $p(InputStr,"^",24)=Note              //备注信息
		Set $p(InputStr,"^",25)=+$h               //创建日期
		Set $p(InputStr,"^",26)=+$p($h,",",2)     //创建时间
		Set $p(InputStr,"^",27)=aFromUserID       //创建人
		Set $p(InputStr,"^",28)=+$h               //更新日期
		Set $p(InputStr,"^",29)=+$p($h,",",2)     //更新时间
		Set $p(InputStr,"^",30)=aFromUserID       //更新人
		Set $p(InputStr,"^",31)=0                 //打印标记
		Set $p(InputStr,"^",32)=EpisodeID         //就诊号
		Set $p(InputStr,"^",33)=Category          //病历分类
		Set $p(InputStr,"^",34)=aLendFlag         //出库标记
		Set flg=##class(DHCWMR.MO.LendRecord).Update(InputStr,"^")
		If (+flg)<1 TRollback
		Quit:(+flg)<1 return
		Set RecordID=flg
		
		Set return="-3^保存借阅病案卷表失败"
		Set ErrorFlg=1
		For xInd=1:1:$l(VolumeIDs,",") {
			Set VolumeID = $p(VolumeIDs,",",xInd)
			Continue:VolumeID=""
			Set InputStr=""
			Set $p(InputStr,"^",1)=""
			Set $p(InputStr,"^",2)=RecordID
			Set $p(InputStr,"^",3)=VolumeID
			Set flg=##class(DHCWMR.MO.LendRecordVol).Update(InputStr,"^")
			Set:(+flg)<1 ErrorFlg=0
			Quit:ErrorFlg<1
		}
		If (+ErrorFlg)<1 Trollback
		Quit:(+ErrorFlg)<1 return
		
		
		Set return="-4^保存病案借阅日志失败"
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
		Set flg=##class(DHCWMR.MO.LendRecordStatus).Update(InputStr,"^")
		If (+flg)<1 TRollback
		Quit:(+flg)<1 return
		
		TCommit
		
		Set return=RecordID
	} ElseIf ((aOperType="L")&(aLRecord'=""))||(aOperType="B") {
		Set MrTypeIDs=""
		For indL=1:1:$l(aLRecord,",") {
			Set LRecordID=$p(aLRecord,",",indL)
			Continue:LRecordID=""
			Set objLRecord=##class(DHCWMR.MO.LendRecord).GetObjById(LRecordID)
			Continue:'$IsObject(objLRecord)
			Continue:'$IsObject(objLRecord.LRMrType)
			Set MrTypeID=objLRecord.LRMrType.%Id()
			Continue:$listfind(MrTypeIDs,MrTypeID)>0
			Set MrTypeIDs=MrTypeIDs_$lb(MrTypeID)
		}
		Quit:MrTypeIDs="" return
		Quit:$listlength(MrTypeIDs)>1 return
		Set MrTypeID=$list(MrTypeIDs,1)
		
		If aOperType="L" {
			Set objWFItem=##class(DHCWMR.SS.WorkFItem).GetWFItemBySysOpera(MrTypeID,"LL")
		} ElseIf aOperType="B" {
			Set objWFItem=##class(DHCWMR.SS.WorkFItem).GetWFItemBySysOpera(MrTypeID,"LB")
		}
		Quit:'$IsObject(objWFItem) return
		Quit:'$IsObject(objWFItem.WFIItem) return
		Set WorkItemID=objWFItem.WFIItem.%Id()
		
		TStart

		For indL=1:1:$l(aLRecord,",") {
			Set LRecordID=$p(aLRecord,",",indL)
			Continue:LRecordID=""
			Set objLRecord=##class(DHCWMR.MO.LendRecord).GetObjById(LRecordID)
			Continue:'$IsObject(objLRecord)
			Continue:'$IsObject(objLRecord.LRMainDr)
			Set objMain=objLRecord.LRMainDr
			Continue:(aOperType="L")&(objLRecord.LRStatus'="R")
			Continue:(aOperType="B")&(objLRecord.LRStatus'="L")
			
			Set return="-1^保存病案操作记录失败"
			Set ErrorFlg = 1
			Set xSubID=""
			For {
				Set xSubID = $o(^DHCWMR.MO.LendRecordD(LRecordID,"VOL",xSubID))
				Quit:xSubID=""
				Set objLendVol = ##class(DHCWMR.MO.LendRecordVol).GetObjById(LRecordID_"||"_xSubID)
				Continue:'$IsObject(objLendVol)
				Set VolumeID = objLendVol.RVolumeDr.%Id()
				Continue:VolumeID=""
				Set xflg = ##class(DHCWMR.SSService.OperationSrv).Operation(VolumeID,objWFItem.%Id(),"",aFromUserID,aToUserID,"",BatchNumber,"")
				Set:(+xflg)<1 ErrorFlg=0
				Quit:(+xflg)<1
			}
			If (+ErrorFlg)<1 Trollback
			Set:(+ErrorFlg)<1 flg=-1
			Quit:(+ErrorFlg)<1
			
			Set return="-2^处理病案借阅记录失败"
			Set InputStr=""
			Set $p(InputStr,"^",1)=objLRecord.%Id()
			Set $p(InputStr,"^",2)=objMain.SMMrType.%Id()
			Set $p(InputStr,"^",3)=objMain.%Id()
			Set $p(InputStr,"^",4)=objLRecord.LRStatus           //状态
			Set $p(InputStr,"^",5)=objLRecord.LRReqDate          //申请日期
			Set $p(InputStr,"^",6)=objLRecord.LRReqTime          //申请时间
			Set $p(InputStr,"^",7)=objLRecord.LRReqUser          //申请人
			Set $p(InputStr,"^",8)=objLRecord.LRLendDate         //出库日期
			Set $p(InputStr,"^",9)=objLRecord.LRLendTime         //出库时间
			Set $p(InputStr,"^",10)=objLRecord.LRLendUser        //出库人
			Set $p(InputStr,"^",11)=objLRecord.LRLendDate        //入库日期
			Set $p(InputStr,"^",12)=objLRecord.LRLendTime        //入库时间
			Set $p(InputStr,"^",13)=objLRecord.LRLendUser        //入库人
			Set $p(InputStr,"^",14)=objLRecord.LRLocID           //借阅科室
			Set $p(InputStr,"^",15)=objLRecord.LRLocCode         //借阅科室代码
			Set $p(InputStr,"^",16)=objLRecord.LRLocDesc         //借阅科室名称
			Set $p(InputStr,"^",17)=objLRecord.LRLocTel          //借阅科室电话
			Set $p(InputStr,"^",18)=objLRecord.LRUserID          //借阅人员
			Set $p(InputStr,"^",19)=objLRecord.LRUserCode        //借阅人员工号
			Set $p(InputStr,"^",20)=objLRecord.LRUserDesc        //借阅人员名称
			Set $p(InputStr,"^",21)=objLRecord.LRUserTel         //借阅人员电话
			Set $p(InputStr,"^",22)=objLRecord.LRPurpose         //借阅目的
			Set $p(InputStr,"^",23)=objLRecord.LRExpBackDate     //预计归还时间
			Set $p(InputStr,"^",24)=objLRecord.LRNote            //备注信息
			Set $p(InputStr,"^",25)=objLRecord.LRCreateDate      //创建日期
			Set $p(InputStr,"^",26)=objLRecord.LRCreateTime      //创建时间
			Set $p(InputStr,"^",27)=objLRecord.LRCreateUser      //创建人
			Set $p(InputStr,"^",28)=+$h                          //更新日期
			Set $p(InputStr,"^",29)=+$p($h,",",2)                //更新时间
			Set $p(InputStr,"^",30)=aFromUserID                  //更新人
			Set $p(InputStr,"^",31)=objLRecord.LRPrintFlag       //打印标记
			Set $p(InputStr,"^",32)=objLRecord.LREpisodeID       //就诊号
			Set $p(InputStr,"^",33)=objLRecord.LRCategory        //病历分类
			Set $p(InputStr,"^",34)=objLRecord.LRLendFlag        //出库标记
			
			If aOperType="L" {
				Set $p(InputStr,"^",4)="L"                       //出库状态
				Set $p(InputStr,"^",8)=+$h                       //出库日期
				Set $p(InputStr,"^",9)=$p($h,",",2)              //出库时间
				Set $p(InputStr,"^",10)=aFromUserID              //出库人
				Set $p(InputStr,"^",31)=0                        //打印标记
				Set $p(InputStr,"^",33)=Category                 //病历分类
				Set $p(InputStr,"^",34)=aLendFlag                //出库标记
			} ElseIf aOperType="B" {
				Set $p(InputStr,"^",4)="B"                       //入库状态
				Set $p(InputStr,"^",11)=+$h                      //入库日期
				Set $p(InputStr,"^",12)=$p($h,",",2)             //入库时间
				Set $p(InputStr,"^",13)=aFromUserID              //入库人
			}
			Set flg=##class(DHCWMR.MO.LendRecord).Update(InputStr,"^")
			If (+flg)<1 TRollback
			Quit:(+flg)<1
			Set RecordID=flg
			
			Set return="-3^保存病案借阅日志失败"
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
			Set flg=##class(DHCWMR.MO.LendRecordStatus).Update(InputStr,"^")
			If (+flg)<1 TRollback
			Quit:(+flg)<1
		}
		Quit:(+flg)<1 return
		
		TCommit
		
		Set return=1
	} ElseIf aOperType="U" {
		
		TStart
		
		Set ErrorFlg = 1
		For indL=1:1:$l(aLRecord,",") {
			Set LRecordID=$p(aLRecord,",",indL)
			Continue:LRecordID=""
			Set objLRecord=##class(DHCWMR.MO.LendRecord).GetObjById(LRecordID)
			Continue:'$IsObject(objLRecord)
			Continue:'$IsObject(objLRecord.LRMainDr)
			Set objMain=objLRecord.LRMainDr
			Set MainID = objMain.%Id()
			
			Set return="-4^修正卷状态失败"
			If (objLRecord.LRStatus'="R")&&(objLRecord.LRStatus'="U") {
				Set MrTypeID = objMain.SMMrType.%Id()
				
				If objLRecord.LRStatus="L" {
					Set objWFItem=##class(DHCWMR.SS.WorkFItem).GetWFItemBySysOpera(MrTypeID,"LB")
				}
				If objLRecord.LRStatus="B" {
					Set objWFItem=##class(DHCWMR.SS.WorkFItem).GetWFItemBySysOpera(MrTypeID,"LL")
				}
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
				Set:(+flg)<1 ErrorFlg=-1
				Quit:(+flg)<1
				Set OperationID=+flg
				
				Set xSubID=""
				For {
					Set xSubID = $o(^DHCWMR.MO.LendRecordD(LRecordID,"VOL",xSubID))
					Quit:xSubID=""
					
					Set objLendVol = ##class(DHCWMR.MO.LendRecordVol).GetObjById(LRecordID_"||"_xSubID)
					Continue:'$IsObject(objLendVol)
					Set VolumeID = objLendVol.RVolumeDr.%Id()
					Continue:VolumeID=""
					
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
					Set InputStr=InputStr_"^"_objLendVol.RVolumeDr.SVOrdStep
					Set InputStr=InputStr_"^"_objLendVol.RVolumeDr.SVIsLend
					Set InputStr=InputStr_"^"_objLendVol.RVolumeDr.SVIsCopy
					Set InputStr=InputStr_"^"_objLendVol.RVolumeDr.SVIsStore
					Set InputStr=InputStr_"^"_objLendVol.RVolumeDr.SVQCLock
					Set InputStr=InputStr_"^"_objLendVol.RVolumeDr.SVDischDate
					Set InputStr=InputStr_"^"_objLendVol.RVolumeDr.SVBackDate
					Set InputStr=InputStr_"^"_objLendVol.RVolumeDr.SVIPTimes
					Set InputStr=InputStr_"^"_objLendVol.RVolumeDr.SVBuildDate
					Set InputStr=InputStr_"^"_objLendVol.RVolumeDr.SVBuildTime
					Set InputStr=InputStr_"^"_objLendVol.RVolumeDr.SVIsActive
					Set InputStr=InputStr_"^"_objLendVol.RVolumeDr.SVResume
					Set InputStr=InputStr_"^"_objLendVol.RVolumeDr.SVBarcode
					Set InputStr=InputStr_"^"_objLendVol.RVolumeDr.SVIsExPaper
					Set flg=##class(DHCWMR.SS.Volume).Update(InputStr,"^")
					Set:(+flg)<1 ErrorFlg=-1
					Quit:(+flg)<1
				}
			}
			If (+ErrorFlg)<1 Trollback
			Quit:(+ErrorFlg)<1
			
			Set return="-2^处理病案借阅记录失败"
			Set InputStr=""
			Set $p(InputStr,"^",1)=objLRecord.%Id()
			Set $p(InputStr,"^",2)=objMain.SMMrType.%Id()
			Set $p(InputStr,"^",3)=objMain.%Id()
			Set $p(InputStr,"^",4)=objLRecord.LRStatus           //状态
			Set $p(InputStr,"^",5)=objLRecord.LRReqDate          //申请日期
			Set $p(InputStr,"^",6)=objLRecord.LRReqTime          //申请时间
			Set $p(InputStr,"^",7)=objLRecord.LRReqUser          //申请人
			Set $p(InputStr,"^",8)=objLRecord.LRLendDate         //出库日期
			Set $p(InputStr,"^",9)=objLRecord.LRLendTime         //出库时间
			Set $p(InputStr,"^",10)=objLRecord.LRLendUser        //出库人
			Set $p(InputStr,"^",11)=objLRecord.LRLendDate        //入库日期
			Set $p(InputStr,"^",12)=objLRecord.LRLendTime        //入库时间
			Set $p(InputStr,"^",13)=objLRecord.LRLendUser        //入库人
			Set $p(InputStr,"^",14)=objLRecord.LRLocID           //借阅科室
			Set $p(InputStr,"^",15)=objLRecord.LRLocCode         //借阅科室代码
			Set $p(InputStr,"^",16)=objLRecord.LRLocDesc         //借阅科室名称
			Set $p(InputStr,"^",17)=objLRecord.LRLocTel          //借阅科室电话
			Set $p(InputStr,"^",18)=objLRecord.LRUserID          //借阅人员
			Set $p(InputStr,"^",19)=objLRecord.LRUserCode        //借阅人员工号
			Set $p(InputStr,"^",20)=objLRecord.LRUserDesc        //借阅人员名称
			Set $p(InputStr,"^",21)=objLRecord.LRUserTel         //借阅人员电话
			Set $p(InputStr,"^",22)=objLRecord.LRPurpose         //借阅目的
			Set $p(InputStr,"^",23)=objLRecord.LRExpBackDate     //预计归还时间
			Set $p(InputStr,"^",24)=objLRecord.LRNote            //备注信息
			Set $p(InputStr,"^",25)=objLRecord.LRCreateDate      //创建日期
			Set $p(InputStr,"^",26)=objLRecord.LRCreateTime      //创建时间
			Set $p(InputStr,"^",27)=objLRecord.LRCreateUser      //创建人
			Set $p(InputStr,"^",28)=+$h                          //更新日期
			Set $p(InputStr,"^",29)=+$p($h,",",2)                //更新时间
			Set $p(InputStr,"^",30)=aFromUserID                  //更新人
			Set $p(InputStr,"^",31)=objLRecord.LRPrintFlag       //打印标记
			Set $p(InputStr,"^",32)=objLRecord.LREpisodeID       //就诊号
			Set $p(InputStr,"^",33)=objLRecord.LRCategory        //病历分类
			
			Set OldStatus=objLRecord.LRStatus
			If objLRecord.LRStatus="R" {
				Set CurrStatus="U"
			} ElseIf objLRecord.LRStatus="L" {
				If objLRecord.LRReqDate="" {
					Set CurrStatus="U"
				} Else {
					Set CurrStatus="R"
				}
			} ElseIf objLRecord.LRStatus="B" {
				Set CurrStatus="L"
			}
			Set $p(InputStr,"^",4)=CurrStatus
			Set flg=##class(DHCWMR.MO.LendRecord).Update(InputStr,"^")
			If (+flg)<1 TRollback
			Set:(+flg)<1 ErrorFlg=-1
			Quit:(+flg)<1
			Set RecordID=flg
			
			Set objCurrStatus=""
			Set xSub=0
			For {
				Set xSub=$o(^DHCWMR.MO.LendRecordD(RecordID,"S",xSub),-1)
				Quit:xSub=""
				Set objStatus=##class(DHCWMR.MO.LendRecordStatus).GetObjById(RecordID_"||"_xSub)
				Continue:'$IsObject(objStatus)
				Continue:'$IsObject(objStatus.RStatus)
				Continue:'$IsObject(objStatus.Parref.LRMrType)
				Continue:objStatus.RUpdoOpera'=""
				Set WorkItemID=objStatus.RStatus.%Id()
				Set MrTypeID=objStatus.Parref.LRMrType.%Id()
				Set objWFItem=##class(DHCWMR.SS.WorkFItem).GetWFItem(MrTypeID,WorkItemID)
				Continue:'$IsObject(objWFItem)
				Continue:(OldStatus="R")&(objWFItem.WFISysOpera'="LR")
				Continue:(OldStatus="L")&(objWFItem.WFISysOpera'="LL")
				Continue:(OldStatus="B")&(objWFItem.WFISysOpera'="LB")
				Set objCurrStatus=objStatus
				Quit
			}
			Continue:objCurrStatus=""
			Set StatusID=objCurrStatus.%Id()
			
			Set return="-3^保存病案借阅日志失败"
			Set InputStr=""
			Set $p(InputStr,"^",1)=$p(StatusID,"||",1)
			Set $p(InputStr,"^",2)=$p(StatusID,"||",2)
			Set $p(InputStr,"^",3)=objCurrStatus.RStatus.%Id()      //操作项目
			Set $p(InputStr,"^",4)=objCurrStatus.RUserFrom          //操作员
			Set $p(InputStr,"^",5)=objCurrStatus.RActDate           //操作日期
			Set $p(InputStr,"^",6)=objCurrStatus.RActTime           //操作时间
			Set $p(InputStr,"^",7)=objCurrStatus.RUserTo            //验证用户
			Set $p(InputStr,"^",8)=objCurrStatus.RBatchNumber       //批次号
			Set $p(InputStr,"^",9)="U"                              //撤销标记
			Set $p(InputStr,"^",10)=+$h                             //撤销日期
			Set $p(InputStr,"^",11)=$p($h,",",2)                    //撤销时间
			Set $p(InputStr,"^",12)=aFromUserID                     //撤销人
			Set $p(InputStr,"^",13)=""                              //撤销原因
			Set $p(InputStr,"^",14)=""                              //备注信息
			Set flg=##class(DHCWMR.MO.LendRecordStatus).Update(InputStr,"^")
			If (+flg)<1 TRollback
			Set:(+flg)<1 ErrorFlg=-1
			Quit:(+flg)<1
		}		
		Quit:(+ErrorFlg)<1 return
		
		TCommit
		
		Set return=1
	}
	
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2015-09-28
/// Description:  查询病案借阅记录
/// Table：       DHCWMR.MO.LendRecord
/// Return：      返回Query
/// do ##class(%Library.ResultSet).RunQuery("DHCWMR.MOService.LendRecordSrv","QryLendRecord","2","7","2015-11-30","2015-11-30","","L")
Query QryLendRecord(aHospID As %String, aMrTypeID As %String, aDateFrom As %String, aDateTo As %String, aMrNo As %String, aQryType As %String) As %Query(ROWSPEC = "RecordID:%String,PatientID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,MainID:%String,StatusCode:%String,StatusDesc:%String,ReqDate:%String,ReqTime:%String,ReqUser:%String,LendDate:%String,LendTime:%String,LendUser:%String,BackDate:%String,BackTime:%String,BackUser:%String,LLocCode:%String,LLocDesc:%String,LLocTel:%String,LUserCode:%String,LUserDesc:%String,LUserTel:%String,PurposeDescs:%String,PrintFlag:%String,ExpBackDate:%String,Note:%String,VolumeIDs:%String,LendFlag:%String")
{
}

ClassMethod QryLendRecordExecute(ByRef qHandle As %Binary, aHospID As %String, aMrTypeID As %String, aDateFrom As %String, aDateTo As %String, aMrNo As %String, aQryType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	//Set ^LIYI = $lb(aHospID,aMrTypeID,aDateFrom,aDateTo,aMrNo,aQryType)
	
	Set aDateFrom=##Class(DHCWMR.SSService.CommonSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCWMR.SSService.CommonSrv).DateHtmlToLogical(aDateTo)
	Set:aDateFrom'="" aDateFrom=+aDateFrom
	Set:aDateTo'="" aDateTo=+aDateTo
	Quit:(aDateFrom="")||(aDateTo="")||(aHospID="")||(aMrTypeID="") $$$OK
	Set:aHospID'="" aHospID=","_aHospID_","
	
	If aMrNo=""{
		If aQryType="R" { //申请列表
			For xDate=aDateFrom:1:aDateTo {
				Set xStatus = ""
				For {
					Set xStatus=$o(^DHCWMR.MO.LendRecordI("IndexMrTypeReqDateStatus",aMrTypeID,xDate,xStatus))
					Quit:xStatus=""
					
					Set xLendRecordID=""
					For {
						Set xLendRecordID=$o(^DHCWMR.MO.LendRecordI("IndexMrTypeReqDateStatus",aMrTypeID,xDate,xStatus,xLendRecordID))
						Quit:xLendRecordID=""
						Set objLRecord = ##class(DHCWMR.MO.LendRecord).GetObjById(xLendRecordID)
						Continue:'$IsObject(objLRecord)
						Continue:objLRecord.LRStatus'=aQryType
						//Continue:(aHospID'="")&&(aHospID'=objLRecord.LRMainDr.SMFirstHosp)&&(objLRecord.LRMainDr.SMFirstHosp'="")
						Set HospID=objLRecord.LRMainDr.SMFirstHosp
						Set:HospID="" HospID=##class(DHCWMR.SSService.HospitalSrv).GetCTHospID(objLRecord.LRLocID)
						Continue:(aHospID'="")&&(HospID'="")&&(aHospID'[(","_HospID_","))
						
						Set Data=..BuildLendRecordData(xLendRecordID)
						Continue:Data=""
						Set ^CacheTemp(repid,ind)=Data
						Set ind=ind+1
					}
				}
			}
		} ElseIf aQryType="L" {	//出库列表
			For xDate=aDateFrom:1:aDateTo {
				Set xStatus = ""
				For {
					Set xStatus=$o(^DHCWMR.MO.LendRecordI("IndexMrTypeLendDateStatus",aMrTypeID,xDate,xStatus))
					Quit:xStatus=""
					
					Set xLendRecordID=""
					For {
						Set xLendRecordID=$o(^DHCWMR.MO.LendRecordI("IndexMrTypeLendDateStatus",aMrTypeID,xDate,xStatus,xLendRecordID))
						Quit:xLendRecordID=""
						Set objLRecord = ##class(DHCWMR.MO.LendRecord).GetObjById(xLendRecordID)
						Continue:'$IsObject(objLRecord)
						Continue:objLRecord.LRStatus'=aQryType
						//Continue:(aHospID'="")&&(aHospID'=objLRecord.LRMainDr.SMFirstHosp)&&(objLRecord.LRMainDr.SMFirstHosp'="")
						Set HospID=objLRecord.LRMainDr.SMFirstHosp
						Set:HospID="" HospID=##class(DHCWMR.SSService.HospitalSrv).GetCTHospID(objLRecord.LRLocID)
						Continue:(aHospID'="")&&(HospID'="")&&(aHospID'[(","_HospID_","))
						
						Set Data=..BuildLendRecordData(xLendRecordID)
						Continue:Data=""
						Set ^CacheTemp(repid,ind)=Data
						Set ind=ind+1
					}
				}
			}
		} ElseIf aQryType="B" {	//入库列表
			For xDate=aDateFrom:1:aDateTo {
				Set xStatus = ""
				For {
					Set xStatus=$o(^DHCWMR.MO.LendRecordI("IndexMrTypeBackDateStatus",aMrTypeID,xDate,xStatus))
					Quit:xStatus=""
				
					Set xLendRecordID=""
					For {
						Set xLendRecordID=$o(^DHCWMR.MO.LendRecordI("IndexMrTypeBackDateStatus",aMrTypeID,xDate,xStatus,xLendRecordID))
						Quit:xLendRecordID=""
						Set objLRecord = ##class(DHCWMR.MO.LendRecord).GetObjById(xLendRecordID)
						Continue:'$IsObject(objLRecord)
						Continue:objLRecord.LRStatus'=aQryType
						//Continue:(aHospID'="")&&(aHospID'=objLRecord.LRMainDr.SMFirstHosp)&&(objLRecord.LRMainDr.SMFirstHosp'="")
						Set HospID=objLRecord.LRMainDr.SMFirstHosp
						Set:HospID="" HospID=##class(DHCWMR.SSService.HospitalSrv).GetCTHospID(objLRecord.LRLocID)
						Continue:(aHospID'="")&&(HospID'="")&&(aHospID'[(","_HospID_","))
						
						Set Data=..BuildLendRecordData(xLendRecordID)
						Continue:Data=""
						Set ^CacheTemp(repid,ind)=Data
						Set ind=ind+1
					}
				}
			}
		}
	}else{
		If $l(aMrNo)=13 { //病案条码
			Set Barcode=aMrNo
			Set BarType=$e(Barcode,1,2)
			If BarType="01" {
				Set MainID=$o(^DHCWMR.SS.MainI("IndexTypeBarcodeAct",aMrTypeID," "_Barcode,1,0))
				Quit:MainID="" $$$OK
				Set objMain = ##class(DHCWMR.SS.Main).GetObjById(MainID)
				Quit:'$IsObject(objMain) $$$OK
				Set aMrNo = objMain.SMMrNo
				Quit:aMrNo="" $$$OK
			} Else {
				Set VolID=$o(^DHCWMR.SS.VolumeI("IndexBarcodeAct"," "_Barcode,1,0))
				Quit:VolID="" $$$OK
				Set objVol = ##class(DHCWMR.SS.Volume).GetObjById(VolID)
				Quit:'$IsObject(objVol) $$$OK
				Quit:objVol.SVMainDr.SMIsActive'=1 $$$OK
				Set aMrNo = objVol.SVMainDr.SMMrNo
				Quit:aMrNo="" $$$OK
			}
		}
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
				Set objLRecord = ##class(DHCWMR.MO.LendRecord).GetObjById(xLendRecordID)
				Continue:'$IsObject(objLRecord)
				Continue:objLRecord.LRStatus'=aQryType
				//Continue:(aHospID'="")&&(aHospID'=objLRecord.LRMainDr.SMFirstHosp)&&(objLRecord.LRMainDr.SMFirstHosp'="")
				Set HospID=objLRecord.LRMainDr.SMFirstHosp
				Set:HospID="" HospID=##class(DHCWMR.SSService.HospitalSrv).GetCTHospID(objLRecord.LRLocID)
				Continue:(aHospID'="")&&(HospID'="")&&(aHospID'[(","_HospID_","))
						
				Set Data=..BuildLendRecordData(xLendRecordID)
				Continue:Data=""
			
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod QryLendRecordClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLendRecordExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryLendRecordFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLendRecordExecute ]
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

ClassMethod BuildLendRecordData(aLRecordID As %String) As %String
{
	New (aLRecordID)
	Set return=""
	Quit:aLRecordID="" return
	
	Set objLRecord = ##class(DHCWMR.MO.LendRecord).GetObjById(aLRecordID)
	Quit:'$IsObject(objLRecord) return
	Quit:'$IsObject(objLRecord.LRMainDr) return
	Quit:'$IsObject(objLRecord.LRMainDr.SMMrType) return
	Set MainID=objLRecord.LRMainDr.%Id()
	Set MrNo=objLRecord.LRMainDr.SMMrNo
	Set MrTypeID=objLRecord.LRMainDr.SMMrType.%Id()
	
	Set PatientID=##class(DHCWMR.SSService.MrNoSrv).GetPatientIDByMrNo(MrNo,MrTypeID)
	Quit:PatientID="" return
	Set PapmiNo=$p(^PAPER(PatientID,"PAT",1),"^",1)            //登记号
	Set PatName=$p($g(^PAPER(PatientID,"ALL")),"^",1)          //姓名
	Set Sex=$p($g(^PAPER(PatientID,"ALL")),"^",7)              //性别
	Set:Sex'="" Sex=$p($g(^CT("SEX",Sex)),"^",2)
	Set Age=##class(DHCWMR.IO.FromHisSrv).GetPapmiAge(PatientID,"","","")  //年龄
	
	Set xSubID="",VolumeIDs=""
	For {
		Set xSubID=$o(^DHCWMR.MO.LendRecordD(aLRecordID,"VOL",xSubID))
		Quit:xSubID=""
		Set objLRVol=##class(DHCWMR.MO.LendRecordVol).GetObjById(aLRecordID_"||"_xSubID)
		Continue:'$IsObject(objLRVol)
		Continue:'$IsObject(objLRVol.RVolumeDr)
		Set VolumeID=objLRVol.RVolumeDr.%Id()
		Set VolumeIDs = VolumeIDs_","_VolumeID
	}
	Set:VolumeIDs'="" VolumeIDs=$e(VolumeIDs,2,$l(VolumeIDs))
	
	Set StatusCode=objLRecord.LRStatus
	Set StatusDesc=""
	Set:StatusCode="R" StatusDesc="申请"
	Set:StatusCode="L" StatusDesc="出库"
	Set:StatusCode="B" StatusDesc="入库"
	Set:StatusCode="U" StatusDesc="作废"
	
	Set ReqDate=objLRecord.LRReqDate
	Set:ReqDate'="" ReqDate=##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(ReqDate)
	Set ReqTime=objLRecord.LRReqTime
	Set:ReqTime'="" ReqTime=$zt(ReqTime,1)
	Set ReqUser=objLRecord.LRReqUser
	Set:ReqUser'="" ReqUser=$p($g(^SSU("SSUSR",ReqUser)),"^",2)
	Set LendDate=objLRecord.LRLendDate
	Set:LendDate'="" LendDate=##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(LendDate)
	Set LendTime=objLRecord.LRLendTime
	Set:LendTime'="" LendTime=$zt(LendTime)
	Set LendUser=objLRecord.LRLendUser
	Set:LendUser'="" LendUser=$p($g(^SSU("SSUSR",LendUser)),"^",2)
	Set BackDate=objLRecord.LRBackDate
	Set:BackDate'="" BackDate=##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(BackDate)
	Set BackTime=objLRecord.LRBackTime
	Set:BackTime'="" BackTime=$zt(BackTime)
	Set BackUser=objLRecord.LRBackUser
	Set:BackUser'="" BackUser=$p($g(^SSU("SSUSR",BackUser)),"^",2)
	
	Set LLocCode=objLRecord.LRLocCode
	Set LLocDesc=objLRecord.LRLocDesc
	Set:LLocDesc["-" LLocDesc=$p(LLocDesc,"-",2)
	Set LLocTel=objLRecord.LRLocTel
	Set LUserCode=objLRecord.LRUserCode
	Set LUserDesc=""
	If (LUserCode'=""){
		Set LCareProvID=$o(^CTPCP(0,"Code",$zcvt(LUserCode,"U"),""))
		Set:LCareProvID'="" LUserDesc=$p($g(^CTPCP(LCareProvID,1)),"^",2)
	}
	Set LUserTel=objLRecord.LRUserTel
	Set Purpose=objLRecord.LRPurpose
	Set PurposeDescs=""
	For indPur=1:1:$l(Purpose,"#") {
		Set PurposeId=$p(Purpose,"#",indPur)
		Continue:PurposeId=""
		Set objDic=##class(DHCWMR.SS.Dictionary).GetObjById(PurposeId)
		Continue:'$IsObject(objDic)
		Set PurposeDesc=objDic.SDDesc
		Set PurposeDescs=PurposeDescs_","_PurposeDesc
	}
	Set:PurposeDescs'="" PurposeDescs=$e(PurposeDescs,2,$l(PurposeDescs))
	Set PrintFlag=objLRecord.LRPrintFlag
	Set ExpBackDate=objLRecord.LRExpBackDate
	Set:ExpBackDate'="" ExpBackDate=##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(ExpBackDate)
	Set Note=objLRecord.LRNote
	Set LendFlag = objLRecord.LRLendFlag
	Set return = $lb(aLRecordID,PatientID,PapmiNo,MrNo,PatName,Sex,Age,MainID,StatusCode,StatusDesc,ReqDate,ReqTime,ReqUser,LendDate,LendTime,LendUser,BackDate,BackTime,BackUser,LLocCode,LLocDesc,LLocTel,LUserCode,LUserDesc,LUserTel,PurposeDescs,PrintFlag,ExpBackDate,Note,VolumeIDs,LendFlag)
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-09-28
/// Description:  查询借阅病案卷列表
/// Table：       DHCWMR.SS.Volume
/// Return：      返回Query
/// do ##class(%Library.ResultSet).RunQuery("DHCWMR.MOService.LendRecordSrv","QryLendVolume","7","050026")
Query QryLendVolume(aMrTypeID As %String, aMrNo As %String) As %Query(ROWSPEC = "VolID:%String,MainID:%String,EpisodeID:%String,PatientID:%String,MrNo:%String,PapmiNo:%String,PatName:%String,Sex:%String,Age:%String,IdentityCode:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmDate:%String,AdmTime:%String,DischDate:%String,BackDate:%String,StepDesc:%String,StatusDesc:%String,ProblemCode:%String,ProblemDesc:%String")
{
}

ClassMethod QryLendVolumeExecute(ByRef qHandle As %Binary, aMrTypeID As %String, aMrNo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aMrTypeID="")||(aMrNo="") $$$OK
	
	Set objWFItem=##class(DHCWMR.SS.WorkFItem).GetWFItemBySysOpera(aMrTypeID,"LL")
	Quit:'$IsObject(objWFItem) $$$OK
	Quit:'$IsObject(objWFItem.WFIItem) $$$OK
	
	Set WFItemID=objWFItem.%Id()
	
	Set aMrNo=$zcvt(aMrNo,"U")
	If $l(aMrNo)=13 { //病案条码
		Set Barcode=aMrNo
		Set BarType=$e(Barcode,1,2)
		If BarType="01" {
			Set MainID=$o(^DHCWMR.SS.MainI("IndexTypeBarcodeAct",aMrTypeID," "_Barcode,1,0))
			Quit:MainID="" $$$OK
			Set objMain = ##class(DHCWMR.SS.Main).GetObjById(MainID)
			Quit:'$IsObject(objMain) $$$OK
			Set aMrNo = objMain.SMMrNo
			Quit:aMrNo="" $$$OK
		} Else {
			Set VolID=$o(^DHCWMR.SS.VolumeI("IndexBarcodeAct"," "_Barcode,1,0))
			Quit:VolID="" $$$OK
			Set objVol = ##class(DHCWMR.SS.Volume).GetObjById(VolID)
			Quit:'$IsObject(objVol) $$$OK
			Quit:objVol.SVMainDr.SMIsActive'=1 $$$OK
			Set aMrNo = objVol.SVMainDr.SMMrNo
			Quit:aMrNo="" $$$OK
		}
	}
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

ClassMethod QryLendVolumeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLendVolumeExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryLendVolumeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLendVolumeExecute ]
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
	Quit:'$IsObject(objMain.SMMrType.MTMrClass) return
	Set MainID=objMain.%Id()
	Set MrClass=objMain.SMMrType.MTMrClass.MCCode
	
	Set OrdStep=objVol.SVOrdStep
	Set MrNo=objVol.SVMainDr.SMMrNo
	Set DischDate=objVol.SVDischDate
	Set:DischDate'="" DischDate=##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(DischDate)
	Set BackDate=objVol.SVBackDate
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
	//Set Age=objVolAdm.VPAge
	//统一调用年龄计算方法
	Set tmpDate=$p($g(^PAADM(+EpisodeID)),"^",6)
	Set tmpTime=$p($g(^PAADM(+EpisodeID)),"^",7)
	Set Age=##class(DHCWMR.IO.FromHisSrv).GetPapmiAge(PatientID,EpisodeID,tmpDate,tmpTime)	//返回“*岁*月*天”
	
	Set tmpDeptWard=##Class(DHCWMR.SSService.CommonSrv).GetAdmitDept(883)
    Set AdmLoc=$p(tmpDeptWard,",",1)
    //Set AdmLoc=objVolAdm.VPAdmitDept
	//Set AdmLocDesc=objVolAdm.VPAdmitDeptDesc
	Set AdmLocDesc=""
	Set:AdmLoc'="" AdmLocDesc=$p($g(^CTLOC(+AdmLoc)),"^",2)
	Set:AdmLocDesc["-" AdmLocDesc=$p(AdmLocDesc,"-",2)
	Set AdmWard=$p(tmpDeptWard,",",2)
    //Set AdmWard=objVolAdm.VPAdmitWard
	//Set AdmWardDesc=objVolAdm.VPAdmitWardDesc
	Set AdmWardDesc=""
	Set:AdmWard'="" AdmWardDesc=$p($g(^CTLOC(+AdmWard)),"^",2)
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
	Set:AdmDate'="" AdmDate=##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(AdmDate)
	Set AdmTime=objVolAdm.VPAdmitTime
	Set:AdmTime'="" AdmTime=$zt(AdmDate,2)
	
	//检查是否允许操作
	Set ProblemCode=1,ProblemDesc=""
	Set Checkflg=##class(DHCWMR.SSService.OperationSrv).CheckOperation(aVolID,WFItemID)
    If (+Checkflg)<1{
		Set ProblemCode=$p(Checkflg,"^",1)
		Set ProblemDesc=$p(Checkflg,"^",2)
	}
	Set LendFlag=..GetVolLendFlag(aVolID,MainID)
	If LendFlag=1 {
		Set ProblemCode=-5
		Set ProblemDesc="当前病案卷已出库,不允许重复出库操作"
	}
	If (MrClass="O")  //门诊就诊科室和日期为初诊科室和初诊日期
	{
		Set FirstLoc=objMain.SMFirstLoc
		Set AdmLocDesc=$p($g(^CTLOC(+FirstLoc)),"^",2)
		Set:AdmLocDesc["-" AdmLocDesc=$p(AdmLocDesc,"-",2)
		Set AdmDate=objMain.SMFirstDate
		Set:AdmDate'="" AdmDate=##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(AdmDate)
	}
	Set return=$lb(aVolID,MainID,EpisodeID,PatientID,MrNo,PapmiNo,PatName,Sex,Age,IdentityCode)
	Set return=return_$lb(AdmLocDesc,AdmWardDesc,AdmDate,AdmTime,DischDate,BackDate,StepDesc,StatusDesc,ProblemCode,ProblemDesc)
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-09-28
/// Description:  查询归还病案记录
/// Table：       DHCWMR.SS.Volume
/// Return：      返回Query
/// do ##class(%Library.ResultSet).RunQuery("DHCWMR.MOService.LendRecordSrv","QryBackVolume","6","00144")
Query QryBackVolume(aMrTypeID As %String, aMrNo As %String) As %Query(ROWSPEC = "RecordID:%String,PatientID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,MainID:%String,StatusCode:%String,StatusDesc:%String,ReqDate:%String,ReqTime:%String,ReqUser:%String,LendDate:%String,LendTime:%String,LendUser:%String,BackDate:%String,BackTime:%String,BackUser:%String,LLocCode:%String,LLocDesc:%String,LLocTel:%String,LUserCode:%String,LUserDesc:%String,LUserTel:%String,PurposeDescs:%String,PrintFlag:%String,ExpBackDate:%String,Note:%String,VolumeIDs:%String")
{
}

ClassMethod QryBackVolumeExecute(ByRef qHandle As %Binary, aMrTypeID As %String, aMrNo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aMrTypeID="")||(aMrNo="") $$$OK
	
	Set aMrNo=$zcvt(aMrNo,"U")
	If $l(aMrNo)=13 { //病案条码
		Set Barcode=aMrNo
		Set BarType=$e(Barcode,1,2)
		If BarType="01" {
			Set MainID=$o(^DHCWMR.SS.MainI("IndexTypeBarcodeAct",aMrTypeID," "_Barcode,1,0))
			Quit:MainID="" $$$OK
			Set objMain = ##class(DHCWMR.SS.Main).GetObjById(MainID)
			Quit:'$IsObject(objMain) $$$OK
			Set aMrNo = objMain.SMMrNo
			Quit:aMrNo="" $$$OK
		} Else {
			Set VolID=$o(^DHCWMR.SS.VolumeI("IndexBarcodeAct"," "_Barcode,1,0))
			Quit:VolID="" $$$OK
			Set objVol = ##class(DHCWMR.SS.Volume).GetObjById(VolID)
			Quit:'$IsObject(objVol) $$$OK
			Quit:objVol.SVMainDr.SMIsActive'=1 $$$OK
			Set aMrNo = objVol.SVMainDr.SMMrNo
			Quit:aMrNo="" $$$OK
		}
	}
	
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
			
			Set objLRecord = ##class(DHCWMR.MO.LendRecord).GetObjById(xLendRecordID)
			Continue:'$IsObject(objLRecord)
			Continue:objLRecord.LRStatus'="L"
			Continue:objLRecord.LRLendFlag="F"	//过滤掉出库的副页
			
			Set Data=..BuildLendRecordData(xLendRecordID)
			Continue:Data=""
			
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod QryBackVolumeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryBackVolumeExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryBackVolumeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryBackVolumeExecute ]
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

/// 批量借阅 add by mxp 20170504
/// d ##class(DHCWMR.MOService.LendRecordSrv).BatchLendOper("L","9","208","4^19|4^4","","1^产科^11^1432^伊诺^22^107^2016-02-24^33","")
ClassMethod BatchLendOper(aOperType As %String, aFromUserID As %String, aToUserID As %String, aMRecords As %String, aLRecord As %String, aDetail As %String, aLendFlag As %String = "") As %String
{
	New (aOperType,aFromUserID,aToUserID,aMRecords,aLRecord,aDetail,aLendFlag)
	Set return=0
	Quit:(aOperType="")||(aFromUserID="") return
	Quit:(aMRecords="")&&(aLRecord="") return
	
	Set MRecordLen = $length(aMRecords,"|")
	Set ErrorLog="",RetLog=""
	For xInd=1:1:MRecordLen{
		Set aMRecord=$p(aMRecords,"|",xInd)
		Set ret=..LendOperation(aOperType,aFromUserID,aToUserID,aMRecord,aLRecord,aDetail,aLendFlag)
		if ret<=0{
			Set ErrorLog=1
		}else{
			If (RetLog="") { 
				Set RetLog=aMRecords
			}else{
				Set RetLog=RetLog_"|"_aMRecords
			}
		}
	}
	if ErrorLog=""{
		Quit 1
	}else{
		Quit RetLog
	}
}

/// 取病案卷是否处于借阅状态  add by mxp 20170504
/// w ##class(DHCWMR.MOService.LendRecordSrv).GetVolLendFlag(86,1)
ClassMethod GetVolLendFlag(aVolumeID As %String, aMainID As %String = "") As %String
{
	New (aVolumeID,aMainID)
	Set return=0
	Quit:(aVolumeID="") -1
	
	If aMainID="" {
		Set objVol=##class(DHCWMR.SS.Volume).GetObjById(aVolumeID)
		Quit:'$IsObject(objVol) -1
		Quit:objVol.SVIsActive'=1 -1
		Quit:'$IsObject(objVol.SVMainDr) -1
		Quit:$IsObject(objVol.SVMainDr.SMIsActive'=1) -1
		Set aMainID=objVol.SVMainDr.%Id()
	}
	
	Set xLendRecordID=""
	For {
		Set xLendRecordID=$o(^DHCWMR.MO.LendRecordI("IndexMainDrStatus",aMainID," L",xLendRecordID))
		Quit:xLendRecordID=""
		Set objLRecord = ##class(DHCWMR.MO.LendRecord).GetObjById(xLendRecordID)
		Continue:'$IsObject(objLRecord)
		Continue:objLRecord.LRStatus'="L"
		Continue:objLRecord.LRBackDate'=""
		
		Set xSubID="",VolumeIDs=""
		For {
			Set xSubID=$o(^DHCWMR.MO.LendRecordD(xLendRecordID,"VOL",xSubID))
			Quit:xSubID=""
			Set objLRVol=##class(DHCWMR.MO.LendRecordVol).GetObjById(xLendRecordID_"||"_xSubID)
			Continue:'$IsObject(objLRVol)
			Continue:'$IsObject(objLRVol.RVolumeDr)
			Set VolumeID=objLRVol.RVolumeDr.%Id()
			Continue:VolumeID'=aVolumeID
			Set return=1
		}
	}
	
	Quit return
}

}
