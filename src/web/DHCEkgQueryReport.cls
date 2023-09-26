Class web.DHCEkgQueryReport Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 病人状态 A：申请 R：拒绝 B：预约：I：登记 E：正在检查 O：结束
/// 报告状态：N：未写报告 I：已有图象 R ：已录入 D：全科会诊 V 审核 S 拒绝
Query QueryRptItem(QueryInfo As %String(MAXLEN=65535), strRegDate As %String) As %Query(ROWSPEC = "TPattype:%String,TRegNo:%String,TStudyID:%String,TName:%String,TSex:%String,TAge:%String,TBrithday:%String,TOrderItem:%String,TStudyWay:%String,TStudyStatus:%String,TRptID:%String,TRptStatus:%String,TImgCount:%String,TClinic:%String,TReqDocName:%String,TReqLocName:%String,TRptDocName:%String,TRptDate:%String,TRptTime:%String,TVerifyDocName:%String,TVerifyDate:%String,TVerifyTime:%String,TIsJZ:%String,TIsYX:%String,TIsTSBL:%String,TIsKYBL:%String,TRegDate:%String,RegTime:%String,TTotalPrice:%String,TEQdesc:%String,TOrderDate:%String,TOrderTime:%String,TAccessionNum:%String,GetIndex:%String,AppointDate:%String,AppointTime:%String,GetResDesc:%String,Getifbed:%String,GetIPNo:%String,GetWardName:%String,Getroomdesc:%String,GetBedNo:%String,feetype:%String,BodyPart:%String,Getbilled:%String,MainDoc:%String,AssiantDoc:%String,Paadmdr:%String,OEordDR:%String,GroupDesc:%String,OldNo:%String,Required:%String,SafetynetCardNo:%String,TMemo:%String,TCallStatus:%String,TNumber:%String,TTelphone:%String,TOEItemNum:%String,TAssisName:%String,TRoomIndex:%String,TReportInfo:%String,TNation:%String,TOccupation:%String,TAddress:%String,TCheckGroupIndex:%String,TPregnantWeeks:%String,TVisitMemo:%String,TResultDesc:%String,TVisitResult:%String,TCardNo:%String,TIssueDocName:%String,TIssueDate:%String,TIssueTime:%String")
{
}

}
