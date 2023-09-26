/// 名称: DHCWMR.SSService.OperationWL
/// 描述: 病案流程操作 工作列表（WorkList）服务
/// 编写者：zhufei
/// 编写日期: 2014-09-19
Class DHCWMR.SSService.OperationWL Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2014-09-19
/// Description:  把卷加入工作列表中
/// Table：       ^DHCWMR.SS.WorkList("日期","病案类型","工作流项目","MainID","VolID")=
///               ^DHCWMR.SS.WorkList("日期","病案类型","工作流项目","MainID","VolID",UserID)=
/// Input：       MrTypeID : 病案类型
///               WFItemID : 工作流项目
///               RecordIDs : 病案卷ID/病案卷状态ID
///               UserID : 操作用户
///               CatCode : 作废，为了程序兼容性保留此参数
/// Return：      验证成功，返回用户信息，否则返回空
/// w ##class(DHCWMR.SSService.OperationWL).SetVolume()
ClassMethod SetVolume(aMrTypeID As %String, aWFItemID As %String, aRecordIDs As %String, aUserID As %String, aCatCode As %String = "") As %String
{
	New (aMrTypeID,aWFItemID,aRecordIDs,aUserID,aCatCode)
	Set return=0
	Quit:(aMrTypeID="")||(aWFItemID="")||(aRecordIDs="")||(aUserID="") return
	
	For indRec=1:1:$l(aRecordIDs,",") {
		Set RecordID=$p(aRecordIDs,",",indRec)
		Continue:RecordID=""
		Set VolID=$p(RecordID,"-",1)
		Set StatusID=$p(RecordID,"-",2)
		Set RequestID=$p(RecordID,"-",3)
		Continue:VolID<1
		
		Set objVol=##Class(DHCWMR.SS.Volume).GetObjById(VolID)
		Continue:'$Isobject(objVol)
		Continue:objVol.SVIsActive'=1
		Continue:'$Isobject(objVol.SVMainDr)
		Continue:objVol.SVMainDr.SMIsActive'=1
		Set MainID=objVol.SVMainDr.%Id()
		Continue:MainID=""
		
		Set return=return+1
		
		//设置病案卷操作
		Set RowIndex=$i(^DHCWMR.SS.WorkList($zd(+$h,3),aMrTypeID,aWFItemID,aUserID))
		If StatusID'="" {
			Set ^DHCWMR.SS.WorkList($zd(+$h,3),aMrTypeID,aWFItemID,aUserID,MainID,VolID,"S",StatusID)=RowIndex
		} ElseIf RequestID'="" {
			Set ^DHCWMR.SS.WorkList($zd(+$h,3),aMrTypeID,aWFItemID,aUserID,MainID,VolID,"R",RequestID)=RowIndex
		} Else {
			Set ^DHCWMR.SS.WorkList($zd(+$h,3),aMrTypeID,aWFItemID,aUserID,MainID,VolID,"V")=RowIndex
		}
	}
	
    Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-09-19
/// Description:  删除工作列表中的卷
/// Table：       ^DHCWMR.SS.WorkList("日期","病案类型","工作流项目","MainID","VolID")=
///               ^DHCWMR.SS.WorkList("日期","病案类型","工作流项目","MainID","VolID",UserID)=
/// Input：       MrTypeID : 病案类型
///               WFItemID : 工作流项目
///               RecordIDs : 病案卷ID/病案卷状态ID
///               UserID : 操作用户
/// Return：      验证成功，返回用户信息，否则返回空
/// w ##class(DHCWMR.SSService.OperationWL).DelVolume(7,"1||13",2937,4598)
ClassMethod DelVolume(aMrTypeID As %String, aWFItemID As %String, aRecordIDs As %String, aUserID As %String) As %String
{
	New (aMrTypeID,aWFItemID,aRecordIDs,aUserID)
	Set return=0
	Quit:(aMrTypeID="")||(aWFItemID="")||(aRecordIDs="")||(aUserID="") return
	
	For indRec=1:1:$l(aRecordIDs,",") {
		Set RecordID=$p(aRecordIDs,",",indRec)
		Continue:RecordID=""
		Set VolID=$p(RecordID,"-",1)
		Set StatusID=$p(RecordID,"-",2)
		Set RequestID=$p(RecordID,"-",3)
		Continue:VolID<1
		
		Set objVol=##Class(DHCWMR.SS.Volume).GetObjById(VolID)
		Continue:'$Isobject(objVol)
		Continue:objVol.SVIsActive'=1
		Continue:'$Isobject(objVol.SVMainDr)
		Continue:objVol.SVMainDr.SMIsActive'=1
		Set MainID=objVol.SVMainDr.%Id()
		Continue:MainID=""
		
		Set return=return+1
		
		//删除病案卷操作
		If StatusID'="" {
			Kill ^DHCWMR.SS.WorkList($zd(+$h,3),aMrTypeID,aWFItemID,aUserID,MainID,VolID,"S",StatusID)
		} ElseIf RequestID'="" {
			Kill ^DHCWMR.SS.WorkList($zd(+$h,3),aMrTypeID,aWFItemID,aUserID,MainID,VolID,"R",RequestID)
		} Else {
			Kill ^DHCWMR.SS.WorkList($zd(+$h,3),aMrTypeID,aWFItemID,aUserID,MainID,VolID,"V")
		}
	}
	
    Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-09-19
/// Description:  清空工作列表中卷
/// Table：       ^DHCWMR.SS.WorkList("日期","病案类型","工作流项目","MainID","VolID")=
///               ^DHCWMR.SS.WorkList("日期","病案类型","工作流项目","MainID","VolID",UserID)=
/// Input：       MrTypeID : 病案类型
///               WFItemID : 工作流项目
///               UserID : 操作用户
/// Return：      验证成功，返回用户信息，否则返回空
/// w ##class(DHCWMR.SSService.OperationWL).ClearVolume(7,"1||13",4598)
ClassMethod ClearVolume(aMrTypeID As %String, aWFItemID As %String, aUserID As %String) As %String
{
	New (aMrTypeID,aWFItemID,aUserID)
	Set return=0
	Quit:(aMrTypeID="")||(aWFItemID="")||(aUserID="") return
	
	//清空病案卷操作
	Kill ^DHCWMR.SS.WorkList($zd(+$h,3),aMrTypeID,aWFItemID,aUserID)
	
	Set return=1
    Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-09-19
/// Description:  批量处理工作列表中卷
/// Table：       ^DHCWMR.SS.WorkList("日期","病案类型","工作流项目","MainID","VolID")=
///               ^DHCWMR.SS.WorkList("日期","病案类型","工作流项目","MainID","VolID",UserID)=
/// Input：       MrTypeID : 病案类型
///               WFItemID : 工作流项目
///               UserID : 操作用户
/// Return：      验证成功，返回用户信息，否则返回空
/// w ##class(DHCWMR.SSService.OperationWL).WorkFlowOpera("7","1||14","L|H"_$c(1)_"asdfa"_$c(1)_"fgs"_$c(1)_"daf"_$c(1)_"adf"_$c(1)_"143"_$c(1)_"2014-12-04"_$c(1),"4479","1","1009-1009||21-,2982-2982||18-")
ClassMethod WorkFlowOpera(aMrTypeID As %String, aWFItemID As %String, aWFDetail As %String, aUserID As %String, aToUserID As %String, aRecordIDs As %String) As %String
{
	New (aMrTypeID,aWFItemID,aWFDetail,aUserID,aToUserID,aRecordIDs)
	Set return="0^参数错误"
	Quit:(aMrTypeID="")||(aWFItemID="")||(aUserID="") return
	
	//Set ^ZF=$lb(aMrTypeID,aWFItemID,aWFDetail,aUserID,aToUserID,aRecordIDs)
	
	Set $ZT="WorkFlowOperaErr"
	
	Set BatchNumber=##class(DHCWMR.SSService.OperationSrv).GetBatchNumber()
	
	Set return="-1^执行错误",IsError=0
	If aRecordIDs'="" {
		For ind=1:1:$l(aRecordIDs,",") {
			Set RecordID=$p(aRecordIDs,",",ind)
			Continue:RecordID=""
			Set xVolID=$p(RecordID,"-",1)
			Set xStatusID=$p(RecordID,"-",2)
			Set xRequestID=$p(RecordID,"-",3)
			
			Set objVol=##Class(DHCWMR.SS.Volume).GetObjById(xVolID)
			Continue:'$Isobject(objVol)
			Continue:objVol.SVIsActive'=1
			Continue:'$Isobject(objVol.SVMainDr)
			Continue:objVol.SVMainDr.SMIsActive'=1
			Set xMainID=objVol.SVMainDr.%Id()
			
			If xStatusID'="" {
				Set xFlag="S"
				Set tmpInfo=$g(^DHCWMR.SS.WorkList($zd(+$h,3),aMrTypeID,aWFItemID,aUserID,xMainID,xVolID,xFlag,xStatusID))
				Continue:tmpInfo=""
				Set RowIndex=+$p(tmpInfo,",",1)
			} ElseIf xRequestID'="" {
				Set xFlag="R"
				Set tmpInfo=$g(^DHCWMR.SS.WorkList($zd(+$h,3),aMrTypeID,aWFItemID,aUserID,xMainID,xVolID,xFlag,xRequestID))
				Continue:tmpInfo=""
				Set RowIndex=+$p(tmpInfo,",",1)
			} Else {
				Set xFlag="V"
				Set tmpInfo=$g(^DHCWMR.SS.WorkList($zd(+$h,3),aMrTypeID,aWFItemID,aUserID,xMainID,xVolID,xFlag))
				Continue:tmpInfo=""
				Set RowIndex=+$p(tmpInfo,",",1)
			}
			
			Set flg=##class(DHCWMR.SSService.OperationSrv).CheckOperation(xVolID,aWFItemID)
			If (+flg)<1 {
				Set IsError=1
				Continue
			}
			
			Set flg=##class(DHCWMR.SSService.OperationSrv).Operation(RecordID,aWFItemID,aWFDetail,aUserID,aToUserID,"",BatchNumber)
			If (+flg)>0 {
				Set flg=..DelVolume(aMrTypeID,aWFItemID,RecordID,aUserID)
			} Else {
				Set IsError=1
				Continue
			}
		}
	} Else {
		Set xMainID=0
		For {
			Set xMainID=$o(^DHCWMR.SS.WorkList($zd(+$h,3),aMrTypeID,aWFItemID,aUserID,xMainID))
			Quit:xMainID=""
			Set xVolID=0
			For {
				Set xVolID=$o(^DHCWMR.SS.WorkList($zd(+$h,3),aMrTypeID,aWFItemID,aUserID,xMainID,xVolID))
				Quit:xVolID=""
				
				Set objVol=##Class(DHCWMR.SS.Volume).GetObjById(xVolID)
				Continue:'$Isobject(objVol)
				Continue:objVol.SVIsActive'=1
				Continue:'$Isobject(objVol.SVMainDr)
				Continue:objVol.SVMainDr.SMIsActive'=1
				
				Set xFlag=""
				For {
					Set xFlag=$o(^DHCWMR.SS.WorkList($zd(+$h,3),aMrTypeID,aWFItemID,aUserID,xMainID,xVolID,xFlag))
					Quit:xFlag=""
					
					If xFlag="V" {  //卷操作
						Set tmpInfo=$g(^DHCWMR.SS.WorkList($zd(+$h,3),aMrTypeID,aWFItemID,aUserID,xMainID,xVolID,xFlag))
						Continue:tmpInfo=""
						Set RowIndex=+$p(tmpInfo,",",1)
						
						Set flg=##class(DHCWMR.SSService.OperationSrv).CheckOperation(xVolID,aWFItemID)
						If (+flg)<1 {
							Set IsError=1
							Continue
						}
						
						Set RecordID=xVolID_"-"_""_"-"_""
						Set flg=##class(DHCWMR.SSService.OperationSrv).Operation(RecordID,aWFItemID,aWFDetail,aUserID,aToUserID,"",BatchNumber)
						If (+flg)>0 {
							Set flg=..DelVolume(aMrTypeID,aWFItemID,RecordID,aUserID)
						} Else {
							Set IsError=1
							Continue
						}
					} ElseIf xFlag="S" {  //还回操作
						Set xStatusID=""
						For {
							Set xStatusID=$o(^DHCWMR.SS.WorkList($zd(+$h,3),aMrTypeID,aWFItemID,aUserID,xMainID,xVolID,xFlag,xStatusID))
							Quit:xStatusID=""
							
							Set tmpInfo=$g(^DHCWMR.SS.WorkList($zd(+$h,3),aMrTypeID,aWFItemID,aUserID,xMainID,xVolID,xFlag,xStatusID))
							Continue:tmpInfo=""
							Set RowIndex=+$p(tmpInfo,",",1)
							
							Set flg=##class(DHCWMR.SSService.OperationSrv).CheckOperation(xVolID,aWFItemID)
							If (+flg)<1 {
								Set IsError=1
								Continue
							}
							
							Set RecordID=xVolID_"-"_xStatusID_"-"_""
							Set flg=##class(DHCWMR.SSService.OperationSrv).Operation(RecordID,aWFItemID,aWFDetail,aUserID,aToUserID,"",BatchNumber)
							If (+flg)>0 {
								Set flg=..DelVolume(aMrTypeID,aWFItemID,RecordID,aUserID)
							} Else {
								Set IsError=1
								Continue
							}
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
							If (+flg)<1 {
								Set IsError=1
								Continue
							}
							
							Set RecordID=xVolID_"-"_""_"-"_xRequestID
							Set flg=##class(DHCWMR.SSService.OperationSrv).Operation(RecordID,aWFItemID,aWFDetail,aUserID,aToUserID,"",BatchNumber)
							If (+flg)>0 {
								Set flg=..DelVolume(aMrTypeID,aWFItemID,RecordID,aUserID)
							} Else {
								Set IsError=1
								Continue
							}
						}
					} Else {
						Set IsError=1
						Quit
					}
				}
			}
		}
	}
	Quit:IsError=1 return
 	
	Set return="1^执行成功^"_BatchNumber
    Quit return
    
WorkFlowOperaErr
	Quit "-999^"_$ZError
}

/// Creator：     zhufei
/// CreatDate：   2014-12-06
/// Description:  批量撤销病案卷操作记录
/// Input：       MrTypeID : 病案类型
///               WFItemID : 工作流项目
///               UserID : 操作用户
/// Return：      验证成功，返回用户信息，否则返回空
/// w ##class(DHCWMR.SSService.OperationWL).UpdoWorkFlowOpera("2982||24","4479","测试")
ClassMethod UpdoWorkFlowOpera(aRecordIDs As %String, aUserID As %String, aUpdoReason As %String) As %String
{
	New (aRecordIDs,aUserID,aUpdoReason)
	Set return="0^参数错误"
	Quit:(aRecordIDs="")||(aUserID="")||(aUpdoReason="") return
	
	//Set ^ZF=$lb(aRecordIDs,aUserID,aUpdoReason)
	
	Set $ZT="UpdoWorkFlowOperaErr"
	
	Set return="-1^执行错误",IsError=0
	For ind=1:1:$l(aRecordIDs,",") {
		Set RecordID=$p(aRecordIDs,",",ind)
		Continue:RecordID=""
		
		Set flg=##class(DHCWMR.SSService.OperationSrv).CheckUpdoOperation(RecordID)
		If (+flg)<1 {
			Set IsError=1
			Continue
		}
		
		Set flg=##class(DHCWMR.SSService.OperationSrv).UpdoOperation(RecordID,aUserID,aUpdoReason)
		If (+flg)<1 {
			Set IsError=1
			Continue
		}
	}
	Quit:IsError=1 return
 	
	Set return="1^执行成功"
    Quit return
    
UpdoWorkFlowOperaErr
	Quit "-999^"_$ZError
}

/// Creator：     zhufei
/// CreatDate：   2015-03-27
/// Description:  批量执行病案卷操作方法
/// Input：       MrTypeID : 病案类型
///               SysOpera : 系统操作代码
///               UserID : 操作用户
///               VolumeIDs : 卷(ID)列表
/// Return：      验证成功，返回用户信息，否则返回空
/// w ##class(DHCWMR.SSService.OperationWL).BatchOperaByVol("7","RC","9","643,649")
ClassMethod BatchOperaByVol(aMrTypeID As %String, aSysOpera As %String, aUserID As %String, aVolumeIDs As %String) As %String
{
	New (aMrTypeID,aSysOpera,aUserID,aVolumeIDs)
	Set return="0^参数错误"
	Quit:(aMrTypeID="")||(aSysOpera="")||(aUserID="")||(aVolumeIDs="") return
	
	Set $ZT="BatchOperaByVolErr"
	
	Set objWFItem=##class(DHCWMR.SS.WorkFItem).GetWFItemBySysOpera(aMrTypeID,aSysOpera)
	Quit:'$IsObject(objWFItem) return
	Set WFItemID=objWFItem.%Id()
	
	Set BatchNumber=##class(DHCWMR.SSService.OperationSrv).GetBatchNumber()
	
	Set return="-1^执行错误",IsError=0
	For indVol=1:1:$l(aVolumeIDs,",") {
		Set xVolID=$p(aVolumeIDs,",",indVol)
		Continue:xVolID=""
		
		Set flg=##class(DHCWMR.SSService.OperationSrv).CheckOperation(xVolID,WFItemID)
		If (+flg)<1 {
			Set IsError=1
			Continue
		}
		
		Set RecordID=xVolID_"-"_""_"-"_""
		Set flg=##class(DHCWMR.SSService.OperationSrv).Operation(RecordID,WFItemID,"",aUserID,"","",BatchNumber)
		If (+flg)>0 {
			Set flg=..DelVolume(aMrTypeID,WFItemID,RecordID,aUserID)
		} Else {
			Set IsError=1
			Continue
		}
	}
	Quit:IsError=1 return
 	
	Set return="1^执行成功^"_BatchNumber
    Quit return
    
BatchOperaByVolErr
	Quit "-999^"_$ZError
}

}
