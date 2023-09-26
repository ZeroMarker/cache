/// 名称: DHCWMR.SSService.RequestSrv
/// 描述: 附加信息申请登记
/// 编写者：zhufei
/// 编写日期: 2014-12-04
Class DHCWMR.SSService.RequestSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2014-12-04
/// Description:  申请登记主程序
/// Input：       RequestID:申请ID
///               VolumeIDs:卷ID
/// Return:		  成功：>0，失败：<0
/// w ##class(DHCWMR.SSService.RequestSrv).SaveRequest()
ClassMethod SaveRequest(aRequestID As %String, aMrTypeID As %String, aWorkItemID As %String, aDetail As %String, aUserID As %String, aVolIDs As %String, aBatchNumber As %String) As %String
{
	New (aRequestID,aMrTypeID,aWorkItemID,aDetail,aUserID,aVolIDs,aBatchNumber)
	Set return=""
	Quit:(aDetail="")||(aUserID="")||(aVolIDs="") return
	Quit:(aRequestID="")&&(aBatchNumber="") return
	
	Set ReqFlag=$p(aDetail,$c(1),1)
	Set SubFlow=$p(ReqFlag,"|",1)
	Set ReqStatus=$p(ReqFlag,"|",2)
	Quit:(SubFlow="")||(ReqStatus="") return
	
	If aRequestID="" {
		Set aRequestID=$o(^DHCWMR.SS.RequestI("RD","IndexBatchNumber"," "_aBatchNumber,0))
	}
	
	If aRequestID'="" {
		Set objRequest=##class(DHCWMR.SS.Request).GetObjById(aRequestID)
		Quit:'$IsObject(objRequest) return
		Set aVolIDs=""
		Set InputStr=objRequest.%Id()
		Set InputStr=InputStr_"^"_objRequest.RQMrType.%Id()
		Set InputStr=InputStr_"^"_objRequest.RQItemDr.%Id()
		Set InputStr=InputStr_"^"_objRequest.RQRequestDate
		Set InputStr=InputStr_"^"_objRequest.RQRequestTime
		Set InputStr=InputStr_"^"_objRequest.RQRequestUser
		Set InputStr=InputStr_"^"_objRequest.RQCreateDate
		Set InputStr=InputStr_"^"_objRequest.RQCreateTime
		Set InputStr=InputStr_"^"_objRequest.RQCreateUser
		Set InputStr=InputStr_"^"_+$h
		Set InputStr=InputStr_"^"_$p($h,",",2)
		Set InputStr=InputStr_"^"_aUserID
		Set InputStr=InputStr_"^"_ReqStatus
		Set InputStr=InputStr_"^"_objRequest.RQResume
		Set InputStr=InputStr_"^"_objRequest.RQBatchNumber  //批次号
		
		Set InputStr=InputStr_"^"_objRequest.RQQCReason
		Set InputStr=InputStr_"^"_objRequest.RQClientName
		Set InputStr=InputStr_"^"_objRequest.RQClientRelation
		Set InputStr=InputStr_"^"_objRequest.RQCardTypeDr
		Set InputStr=InputStr_"^"_objRequest.RQPersonalID
		Set InputStr=InputStr_"^"_objRequest.RQTelephone
		Set InputStr=InputStr_"^"_objRequest.RQAddress
		Set InputStr=InputStr_"^"_objRequest.RQClientNote
		Set InputStr=InputStr_"^"_objRequest.RQLLocTel
		Set InputStr=InputStr_"^"_objRequest.RQLUserCode
		Set InputStr=InputStr_"^"_objRequest.RQLUserName
		Set InputStr=InputStr_"^"_objRequest.RQLUserTel
		Set InputStr=InputStr_"^"_objRequest.RQLPurpose
		Set InputStr=InputStr_"^"_objRequest.RQLBackDate
		Set InputStr=InputStr_"^"_objRequest.RQLReturnStatus
		Set InputStr=InputStr_"^"_objRequest.RQLNote
		Set InputStr=InputStr_"^"_objRequest.RQCContent
		Set InputStr=InputStr_"^"_objRequest.RQCPurpose
		Set InputStr=InputStr_"^"_objRequest.RQCPageNumber
		Set InputStr=InputStr_"^"_objRequest.RQCUnitPrice
		Set InputStr=InputStr_"^"_objRequest.RQCMoneyCount
		Set InputStr=InputStr_"^"_objRequest.RQCNote
		Set InputStr=InputStr_"^"_objRequest.RQSContent
		Set InputStr=InputStr_"^"_objRequest.RQSPurpose
		Set InputStr=InputStr_"^"_objRequest.RQSCount
		Set InputStr=InputStr_"^"_objRequest.RQSDocCode
		Set InputStr=InputStr_"^"_objRequest.RQSDocName
		Set InputStr=InputStr_"^"_objRequest.RQSMedUserCode
		Set InputStr=InputStr_"^"_objRequest.RQSMedUserName
		Set InputStr=InputStr_"^"_objRequest.RQSNote
	} Else {
		Quit:aVolIDs="" return  //新的申请登记，卷ID不允许为空
		
		Set InputStr=""
		Set InputStr=InputStr_"^"_aMrTypeID
		Set InputStr=InputStr_"^"_aWorkItemID
		Set InputStr=InputStr_"^"_""
		Set InputStr=InputStr_"^"_""
		Set InputStr=InputStr_"^"_""
		Set InputStr=InputStr_"^"_+$h
		Set InputStr=InputStr_"^"_$p($h,",",2)
		Set InputStr=InputStr_"^"_aUserID
		Set InputStr=InputStr_"^"_+$h
		Set InputStr=InputStr_"^"_$p($h,",",2)
		Set InputStr=InputStr_"^"_aUserID
		Set InputStr=InputStr_"^"_ReqStatus
		Set InputStr=InputStr_"^"_""
		Set InputStr=InputStr_"^"_aBatchNumber
	}
	
	If SubFlow="Q" {
		Set $p(InputStr,"^",16)=$p(aDetail,$c(1),2)
	} ElseIf SubFlow="L" {
		Set $p(InputStr,"^",24)=$p(aDetail,$c(1),2)
		Set $p(InputStr,"^",25)=$p(aDetail,$c(1),3)
		Set $p(InputStr,"^",26)=$p(aDetail,$c(1),4)
		Set $p(InputStr,"^",27)=$p(aDetail,$c(1),5)
		Set $p(InputStr,"^",28)=$p(aDetail,$c(1),6)
		Set $p(InputStr,"^",29)=$p(aDetail,$c(1),7)
		Set $p(InputStr,"^",30)=$p(aDetail,$c(1),8)
		Set $p(InputStr,"^",31)=$p(aDetail,$c(1),9)
	} ElseIf SubFlow="C" {
		Set $p(InputStr,"^",17)=$p(aDetail,$c(1),2)
		Set $p(InputStr,"^",18)=$p(aDetail,$c(1),3)
		Set $p(InputStr,"^",19)=$p(aDetail,$c(1),4)
		Set $p(InputStr,"^",20)=$p(aDetail,$c(1),5)
		Set $p(InputStr,"^",21)=$p(aDetail,$c(1),6)
		Set $p(InputStr,"^",22)=$p(aDetail,$c(1),7)
		Set $p(InputStr,"^",23)=$p(aDetail,$c(1),8)
		Set $p(InputStr,"^",32)=$p(aDetail,$c(1),9)
		Set $p(InputStr,"^",33)=$p(aDetail,$c(1),10)
		Set $p(InputStr,"^",34)=$p(aDetail,$c(1),11)
		Set $p(InputStr,"^",35)=$p(aDetail,$c(1),12)
		Set $p(InputStr,"^",36)=$p(aDetail,$c(1),13)
		Set $p(InputStr,"^",37)=$p(aDetail,$c(1),14)
	} ElseIf SubFlow="S" {
		Set $p(InputStr,"^",17)=$p(aDetail,$c(1),2)
		Set $p(InputStr,"^",18)=$p(aDetail,$c(1),3)
		Set $p(InputStr,"^",19)=$p(aDetail,$c(1),4)
		Set $p(InputStr,"^",20)=$p(aDetail,$c(1),5)
		Set $p(InputStr,"^",21)=$p(aDetail,$c(1),6)
		Set $p(InputStr,"^",22)=$p(aDetail,$c(1),7)
		Set $p(InputStr,"^",23)=$p(aDetail,$c(1),8)
		Set $p(InputStr,"^",38)=$p(aDetail,$c(1),9)
		Set $p(InputStr,"^",39)=$p(aDetail,$c(1),10)
		Set $p(InputStr,"^",40)=$p(aDetail,$c(1),11)
		Set $p(InputStr,"^",41)=$p(aDetail,$c(1),12)
		Set $p(InputStr,"^",42)=$p(aDetail,$c(1),13)
		Set $p(InputStr,"^",43)=$p(aDetail,$c(1),14)
		Set $p(InputStr,"^",44)=$p(aDetail,$c(1),15)
		Set $p(InputStr,"^",45)=$p(aDetail,$c(1),16)
	}
	Set flg=##class(DHCWMR.SS.Request).Update(InputStr,"^")
	If (+flg)<1 {
		Set return=+flg
	} Else {
		Set return=+flg
		Set RequestID=+flg
		
		For indVol=1:1:$l(aVolIDs,",") {
			Set VolumeID=$p(aVolIDs,",",indVol)
			Continue:VolumeID=""
			Set InputStr=RequestID
			Set InputStr=InputStr_"^"_""
			Set InputStr=InputStr_"^"_VolumeID
			Set InputStr=InputStr_"^"_ReqStatus
			Set InputStr=InputStr_"^"_+$h
			Set InputStr=InputStr_"^"_$p($h,",",2)
			Set InputStr=InputStr_"^"_aUserID
			Set InputStr=InputStr_"^"_""
			Set flg=##class(DHCWMR.SS.RequestDtl).Update(InputStr,"^")
		}
	}
	
	Quit return
}

}
