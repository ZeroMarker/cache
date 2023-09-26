Import sqluser

Class web.DHCADVExaDetails Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description: 查询[审批表信息]
/// Creator:     sufan
/// CreateDate:  2018-01-10
/// Table: 		 DHC_MedAdrRepAudit
/// Input:  	 报告ID^报告类型代码
/// Output:  	 DHC_MedAdrRepAudit表中的数据信息   
/// Others:		 w ##class(web.DHCADVExaDetails).QueryAuditMess("357","advNursing")
ClassMethod QueryAuditMess(ReportID As %String, TypeCode As %String) As %String
{
	N (ReportID,TypeCode,%session)
	S RepTypeString=##class(web.DHCADVCOMMONPART).GetRepTypeString(ReportID)
	S TypeDr=$p(RepTypeString,"^",4)
	S TypeCode=$p(RepTypeString,"^",5)
		
	S MedadrID=$o(^DHCMEDREPADT(0,"Pointer",TypeDr,ReportID,""),-1)
	Q:MedadrID="" ""
	S ID="",StatuList=""
	F  S ID=$o(^DHCMEDREPADT(0,"Pointer",TypeDr,ReportID,ID),-1) Q:ID=""  D
	.Q:ID=0
	.S Subflag=0
	.S Sub=$o(^DHCMEDREPADT(ID,"MEDADRI",""))
	.S:Sub'="" Subflag=1
	.S StatusDR=$p(^DHCMEDREPADT(ID),"^",3) //状态
	.S Status=""
	.S:StatusDR'="" Status=$p(^DHCADREVTWFI(+StatusDR,"ADREWI",$p(StatusDR,"||",2)),"^",2)	
	.S AuditUserDR=$p(^DHCMEDREPADT(ID),"^",4) //审批人
	.S AuditUser=""
	.S:AuditUserDR'="" AuditUser=$p(^SSU("SSUSR",AuditUserDR),"^",2)
	.S AuditUser=##class(web.DHCADVCOMMON).GetTransDesc("User.SSUser","SSUSRName","",AuditUser)
	.S AuditDate=$p(^DHCMEDREPADT(ID),"^",5) //审批日期
	.I AuditDate'="" S AuditDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(AuditDate)
	.S AuditTime=$p(^DHCMEDREPADT(ID),"^",6) //审批时间
	.I AuditTime'="" S AuditTime=$zt(AuditTime,1)
	.S NextLocDR=$p(^DHCMEDREPADT(ID),"^",7) //科室指向
	.S NextLoc=""
	.S:NextLocDR'="" NextLoc=$p(^CTLOC(NextLocDR),"^",2)
  	.S NextLoc=##class(web.DHCADVCOMMON).GetTransDesc("User.CTLoc","CTLOCDesc","",NextLoc)
	.S LocAdvice=$p(^DHCMEDREPADT(ID),"^",8) //科室意见
	.S ReceiveDR=$p(^DHCMEDREPADT(ID),"^",9) //接收状态
	.I ReceiveDR=""  S ReceiveDR="未接收"
	.S Receive=$S(ReceiveDR="未接收":"未接收",ReceiveDR="1":"接收",ReceiveDR="2":"驳回",ReceiveDR="3":"撤销",ReceiveDR="4":"审核",ReceiveDR="5":"归档",ReceiveDR="6":"撤销归档",ReceiveDR="7":"归档待复核",1:"")
	.s CopyInfo=..QueryAudItmMess(ID)
	.S TempStr=ID_"^"_StatusDR_"^"_AuditUserDR_"^"_AuditUser_"^"_AuditDate_" "_AuditTime_"^"_NextLocDR_"^"_NextLoc_"^"_LocAdvice_"^^"_"^"_Receive_"^"_Status_"^"_Subflag
	.i StatuList="" s StatuList=TempStr
	.e  i CopyInfo="" d
	..s StatuList=StatuList_"$$"_TempStr
	.e  i CopyInfo'="" d
	..s StatuList=StatuList_"$$"_CopyInfo_"$$"_TempStr
	q StatuList
}

/// Description: 查询[审批子表信息]
/// Creator:     sufan
/// CreateDate:  2018-01-10
/// Table: 		 DHC_MedAdrRepAuditItm
/// Input:  	 报告ID^报告类型代码
/// Output:  	 DHC_MedAdrRepAuditItm表中的数据信息   
/// Others:		 w ##class(web.DHCADVExaDetails).QueryAudItmMess("2645")
ClassMethod QueryAudItmMess(params As %String) As %String
{
	N (params,%session)
	S AuditID=$p(params,"^",1)
	S Sub="",TempStr="",AuditItmList=""
	F  S Sub=$o(^DHCMEDREPADT(AuditID,"MEDADRI",Sub),-1) Q:Sub=""  D
	.Q:Sub=0
	.S MedIAuditDate=$p(^DHCMEDREPADT(AuditID,"MEDADRI",Sub),"^",1) //审批日期
	.I MedIAuditDate'="" S MedIAuditDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(MedIAuditDate)
	.S MedIAuditTime=$p(^DHCMEDREPADT(AuditID,"MEDADRI",Sub),"^",2) //审批时间
	.I MedIAuditTime'="" S MedIAuditTime=$zt(MedIAuditTime,1)
	.S MedIAuditUserCode=$p(^DHCMEDREPADT(AuditID,"MEDADRI",Sub),"^",3) //审批人
	.S MedIAuditUser="",MedIAuditUserDR=""
	.S:MedIAuditUserCode'="" MedIAuditUserDR=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(MedIAuditUserCode),""))
	.S:MedIAuditUserDR'="" MedIAuditUser=$p(^SSU("SSUSR",MedIAuditUserDR),"^",2)
	.S MedIAuditUser=##class(web.DHCADVCOMMON).GetTransDesc("User.SSUser","SSUSRName","",MedIAuditUser)
	.S MedINextLocCode=$p(^DHCMEDREPADT(AuditID,"MEDADRI",Sub),"^",4) //指向科室
	.S MedINextLoc="",MedINextLocDR=""
	.S:MedINextLocCode'="" MedINextLocDR=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(MedINextLocCode),""))
	.S:MedINextLocDR'="" MedINextLoc=$p(^CTLOC(MedINextLocDR),"^",2)
  	.S MedINextLoc=##class(web.DHCADVCOMMON).GetTransDesc("User.CTLoc","CTLOCDesc","",MedINextLoc)
	.S MedINextUserCode=$p(^DHCMEDREPADT(AuditID,"MEDADRI",Sub),"^",5) //指向人员
	.S MedINextUser="",MedINextUserDR=""
	.S:MedINextUserCode'="" MedINextUserDR=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(MedINextUserCode),""))
	.S:MedINextUserDR'="" MedINextUser=$p(^SSU("SSUSR",MedINextUserDR),"^",2)
	.S MedINextUser=##class(web.DHCADVCOMMON).GetTransDesc("User.SSUser","SSUSRName","",MedINextUser)
	.S MedIUserAdvice=$p(^DHCMEDREPADT(AuditID,"MEDADRI",Sub),"^",6) //人员意见
	.S MedIReceiveDR=$p(^DHCMEDREPADT(AuditID,"MEDADRI",Sub),"^",7) //接收状态
	.I MedIReceiveDR=""  S MedIReceiveDR="N"
	.S MedIReceive=$S(MedIReceiveDR="N":"未接收",MedIReceiveDR="Y":"接收",1:"")
	.S MedIReceiveDate=$p(^DHCMEDREPADT(AuditID,"MEDADRI",Sub),"^",8) //接收日期
	.I MedIReceiveDate'="" S MedIReceiveDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(MedIReceiveDate)
	.S MedIReceiveTime=$p(^DHCMEDREPADT(AuditID,"MEDADRI",Sub),"^",9) //接收时间
	.I MedIReceiveTime'="" S MedIReceiveTime=$zt(MedIReceiveTime,1)
	.S MedICompleteDate=$p(^DHCMEDREPADT(AuditID,"MEDADRI",Sub),"^",10) //完成日期
	.I MedICompleteDate'="" S MedICompleteDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(MedICompleteDate)
	.S MedICompleteTime=$p(^DHCMEDREPADT(AuditID,"MEDADRI",Sub),"^",11) //完成时间
	.I MedICompleteTime'="" S MedICompleteTime=$zt(MedICompleteTime,1)
	.s CopyStatus="转抄"
	.S MedILocAdvice=$p(^DHCMEDREPADT(AuditID,"MEDADRI",Sub),"^",12) //部门意见
	.S AuditDutyFlag=$p(^DHCMEDREPADT(AuditID,"MEDADRI",Sub),"^",13) //备注
    .I AuditDutyFlag="N"  S AuditDutyFlag=""
    .I AuditDutyFlag="Y"  S AuditDutyFlag="该事件已报告本部门第一责任人"
	.S TempStr="^^"_MedIAuditUserDR_"^"_MedIAuditUser_"^"_MedIAuditDate_" "_MedIAuditTime_"^"_MedINextUserDR_"^"_MedINextUser_"^"_MedINextLocDR_"^"_MedINextLoc_"^"_MedIUserAdvice_"^"_MedIReceive_"^"_CopyStatus_"^^"_"^"_MedIReceiveDate_" "_MedIReceiveTime_"^"_MedICompleteDate_" "_MedICompleteTime_"^"_MedILocAdvice_"^"_AuditDutyFlag
	.i AuditItmList="" d
	..s AuditItmList=TempStr
	.e  d
	..s AuditItmList=AuditItmList_"$$"_TempStr
	q AuditItmList
}

}
