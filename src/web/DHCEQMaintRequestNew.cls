/// Modified By HZY 2011-7-19. Bug HZY0005 .
/// Description:在查询方法GetMaintRequest中添加一个参数RequestNo，以实现按申请单号查询的功能。
/// ---------------------------------------
/// Mozy	2010-8-25
Class web.DHCEQMaintRequestNew Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter GlobalLen = 43;

ClassMethod UpdateMaintRequest(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String)
{
	Set $ZT="ERRORUpdateMaintRequest"
	//Flag=0 新增,更新
	k PLIST,IRowID
	s IRowID=$p(val,"^",1)
	s PLIST(1) = $p(val,"^",1)		;RowID
 	s PLIST(2) = $p(val,"^",2)		;EquipDR
 	s PLIST(3) = $p(val,"^",3)		;RequestLocDR
 	s PLIST(4) = $p(val,"^",4)		;FaultCaseDR
 	s PLIST(5) = $p(val,"^",5)		;FaultCaseRemark
 	s PLIST(6) = $p(val,"^",6)		;FaultReasonDR
 	s PLIST(7) = $p(val,"^",7)		;FaultReasonRemark
 	s PLIST(8) = $p(val,"^",8)		;DealMethodDR
 	s PLIST(9) = $p(val,"^",9)		;DealMethodRemark
 	s PLIST(10) = $p(val,"^",10)	;StartDate
 	i $p(val,"^",10)'=""  s PLIST(10) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",10),"date")	;StartDate
 	s PLIST(11) = $p(val,"^",11)	;StartTime
 	s PLIST(12) = $p(val,"^",12)	;EndDate
 	i $p(val,"^",12)'=""  s PLIST(12) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",12),"date")	;EndDate
 	s PLIST(13) = $p(val,"^",13)	;EndTime
 	s PLIST(14) = $p(val,"^",14)	;RequestDate
 	i $p(val,"^",14)'=""  s PLIST(14) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",14),"date")	;RequestDate
 	s PLIST(15) = $p(val,"^",15)	;RequestTime
 	s PLIST(16) = $p(val,"^",16)	;FaultTypeDR
 	s PLIST(17) = $p(val,"^",17)	;AcceptDate
 	i $p(val,"^",17)'=""  s PLIST(17) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",17),"date")	;AcceptDate
 	s PLIST(18) = $p(val,"^",18)	;AcceptTime
 	s PLIST(19) = $p(val,"^",19)	;AcceptUserDR
 	//s PLIST(20) = $p(val,"^",20)	;AssignDR
 	s PLIST(21) = $p(val,"^",21)	;MaintModeDR
 	s PLIST(22) = $p(val,"^",22)	;PayedMaintFlag
 	i $p(val,"^",22)'=""  s PLIST(22) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",22),"bool")	;PayedMaintFlag
 	s PLIST(23) = +$P(val,"^",35)+..GetTotalFee(IRowID,1) ;$p(val,"^",23)	;MaintFee
 	s PLIST(24) = $p(val,"^",24)	;UserSignDR
 	s PLIST(25) = $p(val,"^",25)	;UserOpinion
 	s PLIST(26) = $p(val,"^",26)	;ManageLocDR
 	s PLIST(27) = $p(val,"^",27)	;UseLocDR
 	s PLIST(28) = $p(val,"^",28)	;IsInputFlag
 	//i $p(val,"^",28)'=""  s PLIST(28) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",28),"bool")	;IsInputFlag
 	s PLIST(29) = $p(val,"^",29)	;Remark
 	s PLIST(30) = $p(val,"^",30)	;Status
 	If PLIST(30)="" Set PLIST(30)=0
 	s PLIST(40) = $p(val,"^",32)	;MaintLocDR
 	s PLIST(41) = $p(val,"^",33)	;MaintRemark
 	s PLIST(42) = $p(val,"^",34)	;MaintDept
 	s PLIST(43) = +$P(val,"^",35)   ;OtherFee
 	s PLIST(44) = $P(val,"^",36)    ;RequestNO
 	s PLIST(48) = "N"
 	/*
 	s PLIST(31) = $p(val,"^",31)	;AddUserDR
 	s PLIST(32) = $p(val,"^",32)	;AddDate
 	i $p(val,"^",32)'=""  s PLIST(32) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",32),"date")	;AddDate
 	s PLIST(33) = $p(val,"^",33)	;AddTime
 	s PLIST(34) = $p(val,"^",34)	;UpdateUserDR
 	s PLIST(35) = $p(val,"^",35)	;UpdateDate
 	i $p(val,"^",35)'=""  s PLIST(35) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",35),"date")	;UpdateDate
 	s PLIST(36) = $p(val,"^",36)	;UpdateTime
 	s PLIST(37) = $p(val,"^",37)	;SubmitUserDR
 	s PLIST(38) = $p(val,"^",38)	;SubmitDate
 	i $p(val,"^",38)'=""  s PLIST(38) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",38),"date")	;SubmitDate
 	s PLIST(39) = $p(val,"^",39)	;SubmitTime*/
	k PLIST(1)
	
	i IRowID'="" //2011-10-31 DJ DJ0098
	{
		s InvalidFlag=$p($g(^DHCEQMaintRequest(IRowID)),"^",47)
		i InvalidFlag="Y" q -1015
	}
	
	TStart
	
	If IRowID'=""
	{
		If $Piece(val,"^",31)'="" Set PLIST(34) = $Piece(val,"^",31)
		Set PLIST(35)=+$H
		Set PLIST(36)=$Piece($H,",",2)
		&sql(Update sqluser.DHC_EQMaintRequest Values :PLIST() where MR_RowID=:IRowID)
		Set ID=$Get(%ROWID)
	}
	Else
	{
		s EquipTypeDR=""
		if $p(val,"^",2)'="" s EquipTypeDR=$P($g(^DHCEQEquip($p(val,"^",2))),"^",63)
		If $Piece(val,"^",31)'="" Set PLIST(31) = $Piece(val,"^",31)
		Set PLIST(32)=+$H
		Set PLIST(33)=$Piece($H,",",2)
		If PLIST(44)="" Set PLIST(44)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQMaintRequest",+$H,"",EquipTypeDR)
		&sql(Insert Into SQLUser.DHC_EQMaintRequest Values :PLIST())
		Set ID=$Get(%ROWID)
 	}
 	If SQLCODE
	{
		TRollBack
		Quit SQLCODE
	}
	TCOMMIT
	Quit ID
ERRORUpdateMaintRequest
	TRollBack
	Set ErrorMsg=$ZE	     		//得到系统返回的错误消息
 	Quit "ERRORUpdateMaintRequest"_ErrorMsg     //返回错误消息
}

/// w ##class(web.DHCEQMaintRequestNew).GetOneMaintRequest("","",9)
ClassMethod GetOneMaintRequest(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String)
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQMaintRequest(rowid)
	set count=..#GlobalLen-$l(result,"^")
	for i=count:-1:1 { s result=result_"^"}
	s resultex=resultex_"^"	;EquipDR
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$Piece($Get(^DHCEQEquip($p(result,"^",1))),"^",1)
	s resultex=resultex_"^"	;RequestLocDR
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",2))
	s resultex=resultex_"^"	;FaultCaseDR
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_$Piece($Get(^DHCEQCCode("DHCEQCFaultCase",$p(result,"^",3))),"^",2)
	s resultex=resultex_"^"	;FaultReasonDR
	i $p(result,"^",5)'=""  d
	.s resultex=resultex_$Piece($Get(^DHCEQCCode("DHCEQCFaultReason",$p(result,"^",5))),"^",2)
	s resultex=resultex_"^"	;DealMethodDR
	i $p(result,"^",7)'=""  d
	.s resultex=resultex_$Piece($Get(^DHCEQCCode("DHCEQCDealMethod",$p(result,"^",7))),"^",2)
	s $p(result,"^",9)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",9),"date")	;StartDate
	s $p(result,"^",11)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",11),"date")	;EndDate
	s $p(result,"^",13)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",13),"date")	;RequestDate
	s resultex=resultex_"^"	;FaultTypeDR
	i $p(result,"^",15)'=""  d
	.s resultex=resultex_$Piece($Get(^DHCEQCCode("DHCEQCFaultType",$p(result,"^",15))),"^",2)
	s $p(result,"^",16)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",16),"date")	;AcceptDate
	s resultex=resultex_"^"	;AcceptUserDR
	i $p(result,"^",18)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",18))
	s resultex=resultex_"^"	;AssignDR
	i $p(result,"^",19)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",19))
	s resultex=resultex_"^"	;MaintModeDR
	i $p(result,"^",20)'=""  d
	.s resultex=resultex_$Piece($Get(^DHCEQCCode("DHCEQCMaintMode",$p(result,"^",20))),"^",2)
	s $p(result,"^",21)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",21),"bool")	;PayedMaintFlag
	s $p(result,"^",22)=##Class(web.DHCEQCommon).FormatNumber($p(result,"^",22),"")
	s resultex=resultex_"^"	;UserSignDR
	i $p(result,"^",23)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",23))
	s resultex=resultex_"^"	;ManageLocDR
	i $p(result,"^",25)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",25))
	s resultex=resultex_"^"	;UseLocDR
	i $p(result,"^",26)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",26))
	s $p(result,"^",27)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",27),"bool")	;IsInputFlag
	s resultex=resultex_"^"	;AddUserDR
	i $p(result,"^",30)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",30))
	s $p(result,"^",31)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",31),"date")	;AddDate
	s resultex=resultex_"^"	;UpdateUserDR
	i $p(result,"^",33)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",33))
	s $p(result,"^",34)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",34),"date")	;UpdateDate
	s resultex=resultex_"^"	;SubmitUserDR
	i $p(result,"^",36)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",36))
	s $p(result,"^",37)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",37),"date")	;SubmitDate
	s $p(result,"^",42)=##Class(web.DHCEQCommon).FormatNumber($p(result,"^",42),"")
	Set AppInfo=##class(web.DHCEQApprove).GetApproveInfoBySourceID("16",rowid)
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result_resultex_"^"_AppInfo
}

/// w ##class(web.DHCEQMaintRequestNew).SubmitMaintRequest("","",9,1,1)
ClassMethod SubmitMaintRequest(itmjs As %Library.String = "", itmjsex As %Library.String = "", MRRowID As %Library.String, MRStatus As %Library.String, User As %Library.String)
{
	Set $ZT="ERRORSubmit"
	i MRRowID'="" //2011-10-31 DJ DJ0098
	{
		s InvalidFlag=$p($g(^DHCEQMaintRequest(MRRowID)),"^",47)
		i InvalidFlag="Y" q -1015
	}
	s Status=$Piece($G(^DHCEQMaintRequest(MRRowID)),"^",29)
	if Status'="0" q -2015   //该记录状态不符合,不能执行操作!
	Set ApproveType=##class(web.DHCEQApproveList).GetApproveType("16")
	Set ApproveSet=##class(web.DHCEQCApproveSet).JudgeApproveSet(ApproveType, "", "", "", "", "")
	If ApproveSet="" Quit -4007
	Set ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, MRRowID, 0, "")
	Set AutoAuditFlag=$Piece(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
	Set LastFlag=$Piece(ApproveFlow,"^",1)
	Set NextStep=$Piece(ApproveFlow,"^",2)
	Set NextRole=$Piece(ApproveFlow,"^",3)
	
	Set AppInfo(2)=ApproveType
	Set AppInfo(3)=MRRowID
	Set AppInfo(4)=ApproveSet
	Set AppInfo(5)=NextRole
	Set AppInfo(6)=NextStep
	Set AppInfo(7)=""			;ApproveStatus  当前审核步骤
	Set AppInfo(8)=""			;ApproveRoleDR
	Set AppInfo(9)="1"			;Status
	
	Set AuditFlag=0
	;Modified by jdl 2011-3-9  jdl0073
	If (AutoAuditFlag="Y")&&(NextStep="")
	{
		Set AuditFlag=1
		Set AppInfo(9)="2"		;Status
	}
	Set ApproveInfoID=$Order(^DHCEQApproveInfo(0,"SourceID",ApproveType,MRRowID,0))
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	TSTART
	Set SQLCODE=##class(web.DHCEQApproveList).DeleteApproveList(ApproveSet,MRRowID,"16",User)
	If SQLCODE
	{
		TROLLBACK
	 	Quit SQLCODE
	}
	If ApproveInfoID=""
 	{
	 	&SQL(insert into sqluser.DHC_EQApproveInfo values :AppInfo())		
 	}
 	Else
 	{
		&SQL(update sqluser.DHC_EQApproveInfo values :AppInfo() where AI_RowID=:ApproveInfoID)		
 	}
 	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	Set SMDate=+$H
	Set SMTime=$Piece($H,",",2)
	&sql(Update sqluser.DHC_EQMaintRequest set MR_Status=:MRStatus,MR_SubmitUserDR=:User,MR_SubmitDate=:SMDate,MR_SubmitTime=:SMTime  where MR_RowID=:MRRowID)
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	
	;Modified by jdl 2011-3-9  jdl0073
	i AuditFlag=1
	{
		Set SQLCODE= ##Class(web.DHCEQMaintRequestNew).LastAuditAction(MRRowID)
		If SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}
	}	
 	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("31", MRRowID, User, ApproveFlow, "N","",AuditFlag)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	
	Tcommit
	Quit 0
ERRORSubmit 
	TRollBack	
	Set ErrorMsg=$ZE	     		//得到系统返回的错误消息
 	Quit "ERRORSubmit"_ErrorMsg     //返回错误消息
}

/// 创建:Mozy 2010-8-30
/// 描述:取消提交
/// w ##Class(web.DHCEQMaintRequestNew).CancelSubmitData("22^1^110")
ClassMethod CancelSubmitData(val, CurRole)
{
	new (val,CurRole)
	Set $ZT="ERRORCancel"
	Set RowID=$Piece(val,"^",1)
	Quit:RowID=""

	Set User=$Piece(val,"^",2)
	Set CancelToFlowDR=$Piece(val,"^",3)
	Set Date=+$H
	Set Time=$Piece($H,",",2)
	
	;获取取消到上一步的信息
	Set Status="0"
	Set ApproveRoleDR=""
	Set Step=""
	Set ApproveType=##class(web.DHCEQApproveList).GetApproveType("16")
	if (CancelToFlowDR'="")
	{
		Set ApproveRoleDR=$Piece($Get(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",2)
		Set Step=$Piece($Get(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",3)
		Set Status="1"
	}

	TSTART
	;Set PLIST(4)=RejectReasonDR
	Set PLIST(9)=User		;RejectUserDR
	Set PLIST(10)=Date		;RejectDate
	Set PLIST(11)=Status
	;Set PLIST(12)=Remark
	
	Set AppInfo(5)=ApproveRoleDR
	Set AppInfo(6)=Step
	Set AppInfo(7)=""		;ApproveStatus
	Set AppInfo(8)=""		;ApproveRoleDR
	Set AppInfo(9)=Status	;Status	
	
	&SQL(update sqluser.DHC_EQApproveInfo values :AppInfo() where AI_SourceID=:RowID and AI_ApproveTypeDR=:ApproveType)
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}

	&sql(Update sqluser.DHC_EQMaintRequest set MR_Status=:Status,MR_UpdateUserDR=:User,MR_UpdateDate=:Date,MR_UpdateTime=:Time where MR_RowID=:RowID)
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	
	;Modified by jdl 2011-3-9  jdl0073
	s ApproveFlow=""
	i CancelToFlowDR'=""
	{
		s ApproveFlow="N^"_Step_"^"_ApproveRoleDR_"^"_$p(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR),"^",7,11)
	}
	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("31", RowID, User, ApproveFlow, "Y",CurRole)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	
	TCOMMIT

 	Quit RowID
 	
ERRORCancel
	TRollBack	
	Set ErrorMsg=$ZE	     		//得到系统返回的错误消息
 	Quit "ERRORCancel"_ErrorMsg     //返回错误消息
}

/// Modified By HZY 2011-7-19. Bug HZY0005
/// Description:在查询方法GetMaintRequest中添加一个参数RequestNo，以实现按申请单号查询的功能。
/// ---------------------------------------
/// Modify	Mozy	2010-8-30
/// d ##class(%ResultSet).RunQuery("web.DHCEQMaintRequestNew","GetMaintRequest","","","","","","")
Query GetMaintRequest(Status, EquipDR, ModelDR, RequestLocDR, StartDate, EndDate, ApproveRole, WaitAD, QXType, RequestNo As %String = "", InvalidFlag As %String = "N") As %Query(ROWSPEC = "TRowID:%String,TEquipDR:%String,TRequestLocDR:%String,TFaultCaseDR:%String,TFaultCaseRemark:%String,TFaultReasonDR:%String,TFaultReasonRemark:%String,TDealMethodDR:%String,TDealMethodRemark:%String,TStartDate:%String,TStartTime:%String,TEndDate:%String,TEndTime:%String,TRequestDate:%String,TRequestTime:%String,TFaultTypeDR:%String,TAcceptDate:%String,TAcceptTime:%String,TAcceptUserDR:%String,TAssignDR:%String,TMaintModeDR:%String,TPayedMaintFlag:%String,TMaintFee:%String,TUserSignDR:%String,TUserOpinion:%String,TManageLocDR:%String,TUseLocDR:%String,TIsInputFlag:%String,TRemark:%String,TStatus:%String,TAddUserDR:%String,TAddDate:%String,TAddTime:%String,TUpdateUserDR:%String,TUpdateDate:%String,TUpdateTime:%String,TSubmitUserDR:%String,TSubmitDate:%String,TSubmitTime:%String,TEquip:%String,TRequestLoc:%String,TFaultCase:%String,TFaultReason:%String,TDealMethod:%String,TFaultType:%String,TAcceptUser:%String,TAssign:%String,TMaintMode:%String,TUserSign:%String,TManageLoc:%String,TUseLoc:%String,TAddUser:%String,TUpdateUser:%String,TSubmitUser:%String,TModel:%String,TMaintLocDR:%String,TMaintRemark:%String,TMaintDept:%String,TOtherFee:%String,TRequestNO:%String,TOperateID:%String,TJob:%String")
{
}

ClassMethod GetMaintRequestExecute(ByRef qHandle As %Binary, Status, EquipDR, ModelDR, RequestLocDR, StartDate, EndDate, ApproveRole, WaitAD, QXType, RequestNo As %String = "", InvalidFlag As %String = "N") As %Status
{
 	new repid, index, rowid
 	New ApproveType,ApproveInfoID,ApproveRoleDR
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	//add by zy 0112
	s PNum=1
	s TJob=$J
	s TotalFee=0
 	d ##Class(web.DHCEQCommon).KillTempGlobal("MaintRequetList")
	//2011-7-19 Start Modify By HZY. Bug HZY0005.   
	if RequestNo'=""  d
	.s FindRequestNo=$Order(^DHCEQMaintRequest(0,"RequestNo"," "_RequestNo),-1)
	.For  Set FindRequestNo=$Order(^DHCEQMaintRequest(0,"RequestNo",FindRequestNo))  Quit:((FindRequestNo="")||(FindRequestNo'[RequestNo))  Do
	..Set rowid=0	
	..For  Set rowid=$Order(^DHCEQMaintRequest(0,"RequestNo",FindRequestNo,rowid))  Quit:rowid=""  Do
	...d BuildDataGetMaintRequest
	e  d
	.Set rowid=0
	.For  Set rowid=$Order(^DHCEQMaintRequest(rowid))  Quit:rowid=""  Do
	..d BuildDataGetMaintRequest
	Quit $$$OK
	//2011-7-19 End Modify By HZY. Bug HZY0005. 
	
BuildDataGetMaintRequest		//2011-7-19 HZY. Bug HZY0005. 去掉for循环。
	;Set rowid=0
	;For  Set rowid=$Order(^DHCEQMaintRequest(rowid))  Quit:rowid=""  Do
	Do ResetVariablesGetMaintRequest
	Set TRowID = rowid
	s MRFlag=$p($g(^DHCEQMaintRequest(rowid)),"^",47)
	i MRFlag="" s MRFlag="N"
	q:(InvalidFlag'="")&&(InvalidFlag'=MRFlag)
	;Quit:(ModelDR="")&&(EquipDR="")&&(Status="")&&(RequestLocDR="")&&(StartDate="")&&(EndDate="")	//2011-7-19 HZY. Bug HZY0005.
	Set TEquipDR = $Piece($Get(^DHCEQMaintRequest(rowid)),"^",1)
	Quit:(EquipDR'="")&&(TEquipDR'=EquipDR)
	If TEquipDR '=""  Do
	.Set TEquip = $Piece($Get(^DHCEQEquip(TEquipDR)),"^",1)
	.Set TModelDR = $Piece($Get(^DHCEQEquip(TEquipDR)),"^",3)
	.If TModelDR '= "" s TModel = $Piece($Get(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	Quit:(ModelDR'="")&&(TModelDR'=ModelDR)
	//q:(Equip'="")&&(TEquip'[Equip)
	Set TRequestLocDR = $Piece($Get(^DHCEQMaintRequest(rowid)),"^",2)
	Quit:(RequestLocDR'="")&&(TRequestLocDR'=RequestLocDR)
	q:(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TRequestLocDR))) //2010-10-28 DJ
	If TRequestLocDR '=""  Do
	.Set TRequestLoc = $Piece($Get(^CTLOC(TRequestLocDR)),"^",2)
	Set TFaultCaseDR = $Piece($Get(^DHCEQMaintRequest(rowid)),"^",3)
	If TFaultCaseDR '=""  Do
	.Set TFaultCase = $Piece($Get(^DHCEQCCode("DHCEQCFaultCase",TFaultCaseDR)),"^",2)
	Set TFaultCaseRemark = $Piece($Get(^DHCEQMaintRequest(rowid)),"^",4)
	Set TFaultReasonDR = $Piece($Get(^DHCEQMaintRequest(rowid)),"^",5)
	If TFaultReasonDR '=""  Do
	.Set TFaultReason = $Piece($Get(^DHCEQCCode("DHCEQCFaultReason",TFaultReasonDR)),"^",2)
	Set TFaultReasonRemark = $Piece($Get(^DHCEQMaintRequest(rowid)),"^",6)
	Set TDealMethodDR = $Piece($Get(^DHCEQMaintRequest(rowid)),"^",7)
	If TDealMethodDR '=""  Do
	.Set TDealMethod = $Piece($Get(^DHCEQCCode("DHCEQCDealMethod",TDealMethodDR)),"^",2)
	Set TDealMethodRemark = $Piece($Get(^DHCEQMaintRequest(rowid)),"^",8)
	Set TStartDate = ##class(web.DHCEQCommon).TransValueToPage($Piece($Get(^DHCEQMaintRequest(rowid)),"^",9),"date")
	Set TStartTime = $Piece($Get(^DHCEQMaintRequest(rowid)),"^",10)
	Set TEndDate = ##class(web.DHCEQCommon).TransValueToPage($Piece($Get(^DHCEQMaintRequest(rowid)),"^",11),"date")
	Set TEndTime = $Piece($Get(^DHCEQMaintRequest(rowid)),"^",12)
	If StartDate="" Set StartDate=0
	If EndDate="" Set EndDate=+$h
	Quit:($Piece($Get(^DHCEQMaintRequest(rowid)),"^",13)<StartDate)!($Piece($Get(^DHCEQMaintRequest(rowid)),"^",13)>EndDate)
	Set TRequestDate = ##class(web.DHCEQCommon).TransValueToPage($Piece($Get(^DHCEQMaintRequest(rowid)),"^",13),"date")
	Set TRequestTime = $Piece($Get(^DHCEQMaintRequest(rowid)),"^",14)
	Set TFaultTypeDR = $Piece($Get(^DHCEQMaintRequest(rowid)),"^",15)
	If TFaultTypeDR '=""  Do
	.Set TFaultType = $Piece($Get(^DHCEQCCode("DHCEQCFaultType",TFaultTypeDR)),"^",2)
	Set TAcceptDate = ##class(web.DHCEQCommon).TransValueToPage($Piece($Get(^DHCEQMaintRequest(rowid)),"^",16),"date")
	Set TAcceptTime = $Piece($Get(^DHCEQMaintRequest(rowid)),"^",17)
	Set TAcceptUserDR = $Piece($Get(^DHCEQMaintRequest(rowid)),"^",18)
	If TAcceptUserDR '=""  Do
	.Set TAcceptUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TAcceptUserDR)
	Set TAssignDR = $Piece($Get(^DHCEQMaintRequest(rowid)),"^",19)
	If TAssignDR '=""  Do
	.Set TAssign = ##class(web.DHCEQCommon).GetTrakNameByID("user",TAssignDR)
	Set TMaintModeDR = $Piece($Get(^DHCEQMaintRequest(rowid)),"^",20)
	If TMaintModeDR '=""  Do
	.Set TMaintMode = $Piece($Get(^DHCEQCCode("DHCEQCMaintMode",TMaintModeDR)),"^",2)
	Set TPayedMaintFlag = $Piece($Get(^DHCEQMaintRequest(rowid)),"^",21)
	Set TMaintFee = ##Class(web.DHCEQCommon).FormatNumber($Piece($Get(^DHCEQMaintRequest(rowid)),"^",22),"")
	Set TUserSignDR = $Piece($Get(^DHCEQMaintRequest(rowid)),"^",23)
	If TUserSignDR '=""  Do
	.Set TUserSign = ##class(web.DHCEQCommon).GetTrakNameByID("user",TUserSignDR)
	Set TUserOpinion = $Piece($Get(^DHCEQMaintRequest(rowid)),"^",24)
	Set TManageLocDR = $Piece($Get(^DHCEQMaintRequest(rowid)),"^",25)
	If TManageLocDR '=""  Do
	.Set TManageLoc = $Piece($Get(^CTLOC(TManageLocDR)),"^",2)
	Set TUseLocDR = $Piece($Get(^DHCEQMaintRequest(rowid)),"^",26)
	If TUseLocDR '=""  Do
	.Set TUseLoc = $Piece($Get(^CTLOC(TUseLocDR)),"^",2)
	Set TIsInputFlag = $Piece($Get(^DHCEQMaintRequest(rowid)),"^",27)
	Set TRemark = $Piece($Get(^DHCEQMaintRequest(rowid)),"^",28)
	Set TStatus = $Piece($Get(^DHCEQMaintRequest(rowid)),"^",29)
	Quit:(WaitAD="on")&&(TStatus="0")
	Quit:(Status'="")&&(TStatus'[Status)
	Set TStatus=..GetStatus(TStatus)
	Set TAddUserDR = $Piece($Get(^DHCEQMaintRequest(rowid)),"^",30)
	If TAddUserDR '=""  Do
	.Set TAddUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TAddUserDR)
	Set TAddDate = ##class(web.DHCEQCommon).TransValueToPage($Piece($Get(^DHCEQMaintRequest(rowid)),"^",31),"date")
	Set TAddTime = $Piece($Get(^DHCEQMaintRequest(rowid)),"^",32)
	Set TUpdateUserDR = $Piece($Get(^DHCEQMaintRequest(rowid)),"^",33)
	If TUpdateUserDR '=""  Do
	.Set TUpdateUser =##class(web.DHCEQCommon).GetTrakNameByID("user",TUpdateUserDR)
	Set TUpdateDate = ##class(web.DHCEQCommon).TransValueToPage($Piece($Get(^DHCEQMaintRequest(rowid)),"^",34),"date")
	Set TUpdateTime = $Piece($Get(^DHCEQMaintRequest(rowid)),"^",35)
	Set TSubmitUserDR = $Piece($Get(^DHCEQMaintRequest(rowid)),"^",36)
	If TSubmitUserDR '=""  Do
	.Set TSubmitUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TSubmitUserDR)
	Set TSubmitDate = ##class(web.DHCEQCommon).TransValueToPage($Piece($Get(^DHCEQMaintRequest(rowid)),"^",37),"date")
	Set TSubmitTime = $Piece($Get(^DHCEQMaintRequest(rowid)),"^",38)
	Set TMaintLocDR = $Piece($Get(^DHCEQMaintRequest(rowid)),"^",39)
	Set TMaintRemark = $Piece($Get(^DHCEQMaintRequest(rowid)),"^",40)
	Set TMaintDept = $Piece($Get(^DHCEQMaintRequest(rowid)),"^",41)
	Set TOtherFee=##Class(web.DHCEQCommon).FormatNumber($Piece($Get(^DHCEQMaintRequest(rowid)),"^",42),"")
	Set TotalFee=##Class(web.DHCEQCommon).FormatNumber(TotalFee+TOtherFee,"")
	Set TRequestNO=$Piece($Get(^DHCEQMaintRequest(rowid)),"^",43)
	
	Set roleFlag=0
	If ApproveRole'="" Do
	.Set ApproveType=##class(web.DHCEQApproveList).GetApproveType("16")
	.Set ApproveInfoID=$Order(^DHCEQApproveInfo(0,"SourceID",ApproveType,rowid,0))
	.Quit:ApproveInfoID=""
	.Set ApproveRoleDR = $Piece($Get(^DHCEQApproveInfo(ApproveInfoID)),"^",4)
	.If (ApproveRole'=ApproveRoleDR)&&(WaitAD="on") Set roleFlag=1
	Quit:roleFlag'=0
	If (##class(web.DHCEQOperateLog).GetOperateLogInfo(31,rowid)="") Set TOperateID=rowid
	Do OutputRowGetMaintRequest
	//add by zy 0112

	s TotalFlag=##class(web.DHCEQCommon).GetSysInfo("301006")  //将'401001'改为'301006'. Modified By HZY 2012-04-23 HZY0027.公司测试出的Bug.
	i (TotalFlag'="")&&(TotalFlag'="0")
	{
		i TotalFlag="1" s TotalLoc=1
		i TotalFlag="2" s TotalLoc=index+1
		i TotalFlag="3" s TotalLoc=0
		d ResetVariablesGetMaintRequest
		s TOtherFee=TotalFee
		s TEquipName="合计:"
		Set Data=$lb(TRowID,TEquipDR,TRequestLocDR,TFaultCaseDR,TFaultCaseRemark,TFaultReasonDR,TFaultReasonRemark,TDealMethodDR,TDealMethodRemark,TStartDate,TStartTime,TEndDate,TEndTime,TRequestDate,TRequestTime,TFaultTypeDR,TAcceptDate,TAcceptTime,TAcceptUserDR,TAssignDR,TMaintModeDR,TPayedMaintFlag,TMaintFee,TUserSignDR,TUserOpinion,TManageLocDR,TUseLocDR,TIsInputFlag,TRemark,TStatus,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TSubmitUserDR,TSubmitDate,TSubmitTime,TEquip,TRequestLoc,TFaultCase,TFaultReason,TDealMethod,TFaultType,TAcceptUser,TAssign,TMaintMode,TUserSign,TManageLoc,TUseLoc,TAddUser,TUpdateUser,TSubmitUser,TModel,TMaintLocDR,TMaintRemark,TMaintDept,TOtherFee,TRequestNO,"",TJob)
		Set ^CacheTemp(repid,index)=Data
		Set ^DHCEQTemp("MaintRequetList",+$H,TJob,PNum)=TRowID_"^"_TFaultCaseRemark_"^"_TFaultReasonRemark_"^"_TDealMethodRemark_"^"_TStartDate_"^"_TStartTime_"^"_TEndDate_"^"_TEndTime_"^"_TRequestDate_"^"_TRequestTime_"^"_TAcceptDate_"^"_TAcceptTime_"^"_TPayedMaintFlag_"^"_TMaintFee_"^"_TUserOpinion_"^"_TIsInputFlag_"^"_TRemark_"^"_TStatus_"^"_TAddDate_"^"_TAddTime_"^"_TUpdateDate_"^"_TUpdateTime_"^"_TSubmitDate_"^"_TSubmitTime_"^"_TEquip_"^"_TRequestLoc_"^"_TFaultCase_"^"_TFaultReason_"^"_TDealMethod_"^"_TFaultType_"^"_TAcceptUser_"^"_TAssign_"^"_TMaintMode_"^"_TUserSign_"^"_TManageLoc_"^"_TUseLoc_"^"_TAddUser_"^"_TUpdateUser_"^"_TSubmitUser_"^"_TModel_"^"_TMaintRemark_"^"_TMaintDept_"^"_TOtherFee_"^"_TRequestNO
	}
	Quit
OutputRowGetMaintRequest
	Set Data=$lb(TRowID,TEquipDR,TRequestLocDR,TFaultCaseDR,TFaultCaseRemark,TFaultReasonDR,TFaultReasonRemark,TDealMethodDR,TDealMethodRemark,TStartDate,TStartTime,TEndDate,TEndTime,TRequestDate,TRequestTime,TFaultTypeDR,TAcceptDate,TAcceptTime,TAcceptUserDR,TAssignDR,TMaintModeDR,TPayedMaintFlag,TMaintFee,TUserSignDR,TUserOpinion,TManageLocDR,TUseLocDR,TIsInputFlag,TRemark,TStatus,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TSubmitUserDR,TSubmitDate,TSubmitTime,TEquip,TRequestLoc,TFaultCase,TFaultReason,TDealMethod,TFaultType,TAcceptUser,TAssign,TMaintMode,TUserSign,TManageLoc,TUseLoc,TAddUser,TUpdateUser,TSubmitUser,TModel,TMaintLocDR,TMaintRemark,TMaintDept,TOtherFee,TRequestNO,TOperateID,TJob)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	//add by zy 0112

	Set ^DHCEQTemp("MaintRequetList",+$H,TJob,PNum)=TRowID_"^"_TFaultCaseRemark_"^"_TFaultReasonRemark_"^"_TDealMethodRemark_"^"_TStartDate_"^"_TStartTime_"^"_TEndDate_"^"_TEndTime_"^"_TRequestDate_"^"_TRequestTime_"^"_TAcceptDate_"^"_TAcceptTime_"^"_TPayedMaintFlag_"^"_TMaintFee_"^"_TUserOpinion_"^"_TIsInputFlag_"^"_TRemark_"^"_TStatus_"^"_TAddDate_"^"_TAddTime_"^"_TUpdateDate_"^"_TUpdateTime_"^"_TSubmitDate_"^"_TSubmitTime_"^"_TEquip_"^"_TRequestLoc_"^"_TFaultCase_"^"_TFaultReason_"^"_TDealMethod_"^"_TFaultType_"^"_TAcceptUser_"^"_TAssign_"^"_TMaintMode_"^"_TUserSign_"^"_TManageLoc_"^"_TUseLoc_"^"_TAddUser_"^"_TUpdateUser_"^"_TSubmitUser_"^"_TModel_"^"_TMaintRemark_"^"_TMaintDept_"^"_TOtherFee_"^"_TRequestNO
	Set PNum=PNum+1
	Quit
ResetVariablesGetMaintRequest
	Set (TRowID,TEquipDR,TRequestLocDR,TFaultCaseDR,TFaultCaseRemark,TFaultReasonDR,TFaultReasonRemark,TDealMethodDR,TDealMethodRemark,TStartDate,TStartTime,TEndDate,TEndTime,TRequestDate,TRequestTime,TFaultTypeDR,TAcceptDate,TAcceptTime,TAcceptUserDR,TAssignDR,TMaintModeDR,TPayedMaintFlag,TMaintFee,TUserSignDR,TUserOpinion,TManageLocDR,TUseLocDR,TIsInputFlag,TRemark,TStatus,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TSubmitUserDR,TSubmitDate,TSubmitTime,TEquip,TRequestLoc,TFaultCase,TFaultReason,TDealMethod,TFaultType,TAcceptUser,TAssign,TMaintMode,TUserSign,TManageLoc,TUseLoc,TAddUser,TUpdateUser,TSubmitUser,TModel,TMaintLocDR,TMaintRemark,TMaintDept,TOtherFee,TRequestNO,TOperateID)=""
	Quit
}

ClassMethod GetMaintRequestFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMaintRequestExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetMaintRequestClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMaintRequestExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 创建:Mozy 2010-8-27
/// 描述:审核
/// w ##Class(web.DHCEQMaintRequestNew).AuditData("29^1^","7","1","")
ClassMethod AuditData(val, CurRole, RoleStep, editFieldsInfo, ContinueFlag As %Library.String = "N")
{
	New EquipType,ApproveType,ApproveSet,ApproveFlow,AutoAuditFlag,LastFlag,NextStep,NextRole
	New User,Date,RowID,result,MaintDR,Status
	Set $ZT="ERRORAudit"
	Set RowID=$Piece(val,"^",1)
	Quit:RowID="" ""
	s Status=$Piece($G(^DHCEQMaintRequest(RowID)),"^",29)
	if Status'="1" q -2015   //该记录状态不符合,不能执行操作!
	
	Set User=$Piece(val,"^",2)
	Set Date=+$H
	Set Time=$Piece($H,",",2)
	
	Set AppInfo(7)=RoleStep		;ApproveStatus
	Set AppInfo(8)=CurRole		;ApproveRoleDR
	;Set EquipType=$Piece($Get(^DHCEQInStock(RowID)),"^",20)
	Set ApproveType=##class(web.DHCEQApproveList).GetApproveType("16")
	Set ApproveSet=##class(web.DHCEQApproveList).GetApproveSet("16", RowID)	
	If ApproveSet="" Quit -4007
	Set ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, RowID, RoleStep, CurRole)
	
	Set AutoAuditFlag=$Piece(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
	Set LastFlag=$Piece(ApproveFlow,"^",1)
	Set NextStep=$Piece(ApproveFlow,"^",2)
	Set NextRole=$Piece(ApproveFlow,"^",3)
	
	Set AppInfo(5)=NextRole
	Set AppInfo(6)=NextStep	
	Set AppInfo(9)="1"			;Status	
	
	;Modified by jdl 2011-3-9  jdl0073
	s AuditFlag=0
	
	TSTART	
	
	If editFieldsInfo'=""
	{
		Set SQLCODE=##class(web.DHCEQApprove).EditRoleReqFields(editFieldsInfo)	//编辑要修改的字段
		If SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}
	}
	
	Set Actions=##Class(web.DHCEQCApproveAction).GetApproveActions(ApproveSet, RoleStep, CurRole)
	If Actions'=""					//执行当前角色要执行的动作
	{
		Set SQLCODE=##Class(web.DHCEQCApproveAction).DoActions(RowID,User,Actions,,ContinueFlag)
		If SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}
	}
	// 最终审核操作
	If ((NextStep="")||(LastFlag="Y"))
	{
		//add by zy 2014-12-29  ZY0121
		s BudgetFlag=##Class(web.DHCEQBudget).UpdateBudgetInfo(7,RowID,2,ContinueFlag)
		i BudgetFlag'=0  //-1001 没有预算信息设置;-1002 已用和占用金额之和超过预算金额
		{
			TROLLBACK
			q BudgetFlag
		}
		Set SQLCODE= ##Class(web.DHCEQMaintRequestNew).LastAuditAction(RowID)
		If SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}
		Set AppInfo(9)="2"		;Status
		;Modified by jdl 2011-3-9  jdl0073
		Set AuditFlag=1
	}
	;生成审批记录
	Set SQLCODE=##class(web.DHCEQApproveList).UpdateData(ApproveType,RowID,"","",CurRole,RoleStep)
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	;记录单据当前审批状态
	&SQL(update sqluser.DHC_EQApproveInfo values :AppInfo() where AI_SourceID=:RowID and  AI_ApproveSetDR=:ApproveSet)
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	
	;Modified by jdl 2011-3-9  jdl0073
	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("31", RowID, User, ApproveFlow, "N",CurRole,AuditFlag)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	
	TCOMMIT
 	Quit 0
ERRORAudit
	TRollBack	
	Set ErrorMsg=$ZE				//得到系统返回的错误消息
 	Quit "ERRORAudit"_ErrorMsg		//返回错误消息
}

/// 创建:Mozy 2010-8-27
/// 描述:审核最后一步操作
/// w ##Class(web.DHCEQMaintRequestNew).LastAuditAction("10^1","7","1")
ClassMethod LastAuditAction(RowID)
{
	New MaintDR,User,Date,Time,result
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$P($H,",",2)
	Set result= ^DHCEQMaintRequest(RowID)
	Set PL(2)=$Piece(result,"^",1) 		//EquipDR	
	Set PL(3)=3 						//Type
	set PL(4)=RowID		 				//SourceID
	//set PL(5)=PLIST(21) 				//MaintType
	Set PL(6)=$Piece(result,"^",16) 	//MaintDate
	Set PL(7)=$Piece(result,"^",39) 	//MaintLoc
	Set PL(8)=$Piece(result,"^",18) 	//MaintUser
	Set PL(9)=$Piece(result,"^",20) 	//MaintMode
	Set PL(11)="" 						//NormalFlag
	Set PL(12)=$Piece(result,"^",25)  	//ManageLoc
	Set PL(13)=$Piece(result,"^",26)  	//UseLoc
	Set PL(14)=2
	Set PL(25)=$Piece(result,"^",42)	//OtherFee
	Set PL(10)=..GetTotalFee(RowID,1)+PL(25)   //Fee
	Set PL(19)=User
	Set PL(20)=Date
	Set PL(21)=Time
	//20150616       ZY0129
	Set PL(26)=$Piece(result,"^",50)   //记录维修费用分摊的月份 hold1
	
	Set MaintDR=##class(web.DHCEQMaintRequestNew).GetOneMaintDR(RowID)
	If MaintDR=""
	{
		&sql(Insert Into SQLUser.DHC_EQMaint Values :PL())
		If SQLCODE
		{
			Quit SQLCODE
		}
	}
	Else
	{
		&sql(Update sqluser.DHC_EQMaint Values :PL() where MT_RowID=:MaintDR)
		If SQLCODE<0
		{
			Quit SQLCODE
		}
	}
	
	Set PLIST(23)=+$Piece(result,"^",42)+..GetTotalFee(RowID,1)
	Set PLIST(30)=2			;审核
	&sql(Update sqluser.DHC_EQMaintRequest Values :PLIST() where MR_RowID=:RowID)
	If SQLCODE
	{
		Quit SQLCODE
	}
	Set result= ^DHCEQMaintRequest(RowID)
	// 生命周期
	Set LI(2)=$Piece(result,"^",1)  	//设备
	If LI(2)'="" d
	.Set LI(9)=$Piece($Get(^DHCEQEquip(LI(2))),"^",19)   	//变动后使用科室
	.Set LI(10)=$Piece($Get(^DHCEQEquip(LI(2))),"^",17) 		//变动后管理科室
	.Set LI(11)=$Piece($Get(^DHCEQEquip(LI(2))),"^",67)  	//变动后库房
	.Set LI(12)=$Piece($Get(^DHCEQEquip(LI(2))),"^",27)  	//变动后原值
	.Set LI(13)=$Piece($Get(^DHCEQEquip(LI(2))),"^",28)  	//变动后净值
	If $Piece(result,"^",3)'="" Set LI(14)=$Piece($Get(^DHCEQCCode("DHCEQCFaultCase",$Piece(result,"^",3))),"^",2)  //变动原因
	Set LI(15)=$Piece(result,"^",4)  	//变动描述
	Set LI(16)=Date						//变动日期
	Set LI(17)=Time						//变动时间
	Set LI(18)=$Piece(result,"^",22)  	//费用
	Set LI(19)="P"						//生命周期类型
	Set LI(20)=31						//来源类型
	Set LI(21)=RowID					//来源ID
	Set LI(23)=$Piece(result,"^",28)  	//备注
	Set LI(27)=User						//更新人
	Set LI(28)=Date						//更新日期
	Set LI(29)=Time						//更新时间
	&sql(Insert Into SQLUSER.DHC_EQLifeInfo Values :LI())
	Quit SQLCODE
}

/// w ##class(web.DHCEQMaintRequestNew).GetOneMaintDR(4)
ClassMethod GetOneMaintDR(RowID As %Library.String, Type As %Library.String = "3")
{
	Quit:RowID="" ""
	New MRowID,MRDR,Return
	Set Return=""
	Set MRowID=0
	For  Set MRowID=$Order(^DHCEQMaint(MRowID))  Quit:MRowID=""  Do
	.q:$Piece($Get(^DHCEQMaint(MRowID)),"^",2)'=Type
	.Set MRDR= $Piece($Get(^DHCEQMaint(MRowID)),"^",3)
	.If MRDR=RowID Set Return=MRowID
	Quit Return
}

ClassMethod GetTotalFee(RowID, Type)
{
	Set (OtherFee,PartFee)=0
	If RowID="" 
	{
		Set OtherFee=0
	}
	Else
	{
		Set OtherFee=$Piece($Get(^DHCEQMaintRequest(RowID)),"^",42)
	}
	If OtherFee="" Set OtherFee=0
	Set MaintDR=##class(web.DHCEQMaintRequestNew).GetOneMaintDR(RowID)
	If MaintDR=""
	{
		Set PartFee=0
	}
	Else
	{
		&sql(select sum(MTP_TotalFee) into :PartFee from sqluser.DHC_EQMaintPart where MTP_MaintDR=:MaintDR and MTP_FeeFlag='Y')
	}	
	IF PartFee="" Set PartFee=0
	IF Type=2 Quit OtherFee+PartFee
	IF Type=1 Quit PartFee
}

ClassMethod StatusList(name, width, WaitAD) As %String
{
	w ##class(web.DHCEQCommon).GetDefaultStyle(name,"")
	;;下拉列表
	;w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=></option>"
	i (WaitAD="off") w "<option value=0>"_..GetStatus(0)_"</option>"
	;w "<option value=0>"_..GetStatus(0)_"</option>"
	w "<option value=1>"_..GetStatus(1)_"</option>"
	w "<option value=2>"_..GetStatus(2)_"</option>"
	w "</select>",!
}

ClassMethod GetStatus(Status)
{
	Quit $CASE(Status,0:"新增",1:"提交",2:"审核",:"未定义")
}

ClassMethod DeleteMaintRequest(itmjs As %Library.String = "", itmjsex As %Library.String = "", RowID As %Library.String)
{
	Set $ZT="ERRORDelete"
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$P($H,",",2)
	TSTART
	//add by zy 2014-12-29 ZY0121
	s BudgetFlag=##Class(web.DHCEQBudget).UpdateBudgetInfo(7,RowID,3)
	i BudgetFlag'=0  //-1001 没有预算信息设置;-1002 已用和占用金额之和超过预算金额
	{
		TROLLBACK
		q BudgetFlag
	}
	&sql(Update sqluser.DHC_EQMaintRequest Set MR_InvalidFlag='Y',MR_CancelUser=:User,MR_CancelDate=:Date,MR_CancelTime=:Time where MR_RowID=:RowID)
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	TCOMMIT
	Quit 0
ERRORDelete
	TRollBack	
	Set ErrorMsg=$ZE	     		//得到系统返回的错误消息
 	Quit "ERRORDelete"_ErrorMsg     //返回错误消息
}

ClassMethod SetContrat(EquipDR)
{
	s Flag="0"
	s SignDate=0
	s MaxDate=0
	s StartDate=""
	s EndDate=""
	s rowid=0
	s MaxContractDR=0
	f  s rowid=$o(^DHCEQServiceContract(0,"Equip",EquipDR,rowid))  quit:rowid=""  d
	.s ContractDR=$P(^DHCEQServiceContract(rowid),"^",2)
	.s SignDate=$P(^DHCEQContract(ContractDR),"^",7)
	.s Flag="1"
	.i SignDate>MaxDate d
	..s MaxContractDR=ContractDR
	..s MaxDate=SignDate
	i MaxContractDR>0 s StartDate=##class(web.DHCEQCommon).TransValueToPage($Piece($Get(^DHCEQContract(MaxContractDR)),"^",11),"date")
	i MaxContractDR>0 s EndDate=##class(web.DHCEQCommon).TransValueToPage($Piece($Get(^DHCEQContract(MaxContractDR)),"^",12),"date")
	q Flag_"^"_StartDate_"^"_EndDate
}

ClassMethod GetValue(User, Date, Time, MaintRequestDR)
{
	s val=""
	s val=val_$Piece($Get(^DHCEQMaintRequest(MaintRequestDR)),"^",1)_"^" //EquipDR 1
	s val=val_MaintRequestDR_"^" //MaintRequestDR 2
	s val=val_""_"^" //CostallotDR 3
	s val=val_$Piece($Get(^DHCEQMaintRequest(MaintRequestDR)),"^",22)_"^" //UseFee 4
	s val=val_$Piece($Get(^DHCEQMaintRequest(MaintRequestDR)),"^",16)_"^" //FeeDate 5
	s val=val_$Piece($Get(^DHCEQMaintRequest(MaintRequestDR)),"^",26)_"^" //UseLocDR 6
	s val=val_$Piece($Get(^DHCEQMaintRequest(MaintRequestDR)),"^",25)_"^" //ManageLocDR 7
	s val=val_##class(web.DHCEQMaint).GetFeeType(3)_"^" //FeeTypeDR 8
	s val=val_User_"^" //user 9
	s val=val_Date_"^" //Date 10
	s val=val_Time_"^" //Time 11
	s val=val_"维修记录产生费用" //Remark 12	
	s Return=##class(web.DHCEQMaintRequestNew).InsertLifeFee(27,val)
	q Return
}

ClassMethod InsertLifeFeeOld(i, val)
{
	//i=3保养，i=4检查,27=维修，由于表结构改变i现在无用了
	k PUP
	s PUP(2)=$P(val,"^",1) //EquipDR
	s PUP(3)=$P(val,"^",2) //MaintDR,InsepectDR
	s PUP(4)="" //$P(val,"^",3) //CostallotDR
	s PUP(5)=$P(val,"^",4) //UseFee
	i (PUP(5)=0||PUP(5)="") q 0 //如果费用为0，退出
	s PUP(6)=$P(val,"^",5) //FeeDate
	s PUP(7)=$P(val,"^",6) //UseLocDR
	s PUP(8)=$P(val,"^",7) //ManageLocDR
	s PUP(9)=$P(val,"^",8) //FeeTypeDR	
	s PUP(13)="N" //InputFlag
	s PUP(15)=$P(val,"^",9) //AddUser
	s PUP(16)=$P(val,"^",10) //AddDate
	s PUP(17)=$P(val,"^",11) //AddTime
	s PUP(14)=$P(val,"^",12) //Remark
	s PUP(18)=PUP(15) //UpdateUser
	s PUP(19)=PUP(16) //UpdateDate
	s PUP(20)=PUP(17) //UpdateTime
	s PUP(21)=PUP(15) //AduitUser
	s PUP(22)=PUP(16) //AduitDate
	s PUP(23)=PUP(17) //AduitTime
	&sql(insert into sqluser.DHC_EQLifeFee values :PUP())
	q SQLCODE
}

ClassMethod GetMaintFee(itmjs As %Library.String = "", itmjsex As %Library.String = "", ArgList, ArgDR)
{
	if ArgList="1"
	{
		//MaintPlan ArgDR=MaintPlanDR
		s MaintModeDR=##class(web.DHCEQMaintPlan).GetMaintMode(ArgDR)
		s FeeType=##class(web.DHCEQMaintPlan).GetFeeType("","",MaintModeDR)
		s MaintFee=$Piece($Get(^DHCEQMaintPlan(ArgDR)),"^",9)
		q FeeType_"^"_MaintFee
	}
	if ArgList="2"
	{
		//Maint ArgDR=MaintDR
		s MaintModeDR=##class(web.DHCEQMaint).GetMaintMode(ArgDR)
		s FeeType=##class(web.DHCEQMaintPlan).GetFeeType("","",MaintModeDR)
		s MaintFee=$Piece($Get(^DHCEQMaint(ArgDR)),"^",9)
		q FeeType_"^"_MaintFee
	}
	if ArgList="3"
	{
		//MaintRequest ArgDR=MaintDR
		;s MaintRequestDR=..GetMaintRequestDRByMtDR(ArgDR)^DHCEQMaint(rowid)
		s MaintRequestDR=$Piece($Get(^DHCEQMaint(ArgDR)),"^",2)
		s MaintModeDR=$Piece($Get(^DHCEQMaintRequest(MaintRequestDR)),"^",20)
		s FeeType=##class(web.DHCEQMaintPlan).GetFeeType("","",MaintModeDR)
		s MaintFee=$Piece($Get(^DHCEQMaintRequest(MaintRequestDR)),"^",22)
		q FeeType_"^"_MaintFee
	}
}

Query TroubleAnalyze(StartDate, EndDate, FaultCaseDR, FaultReasonDR, DealMethodDR) As %Query(ROWSPEC = "TRowID:%String,TEquipDR:%String,TRequestLocDR:%String,TFaultCaseDR:%String,TFaultCaseRemark:%String,TFaultReasonDR:%String,TFaultReasonRemark:%String,TDealMethodDR:%String,TDealMethodRemark:%String,TStartDate:%String,TStartTime:%String,TEndDate:%String,TEndTime:%String,TRequestDate:%String,TRequestTime:%String,TFaultTypeDR:%String,TAcceptDate:%String,TAcceptTime:%String,TAcceptUserDR:%String,TAssignDR:%String,TMaintModeDR:%String,TPayedMaintFlag:%String,TMaintFee:%String,TUserSignDR:%String,TUserOpinion:%String,TManageLocDR:%String,TUseLocDR:%String,TIsInputFlag:%String,TRemark:%String,TStatus:%String,TAddUserDR:%String,TAddDate:%String,TAddTime:%String,TUpdateUserDR:%String,TUpdateDate:%String,TUpdateTime:%String,TSubmitUserDR:%String,TSubmitDate:%String,TSubmitTime:%String,TEquip:%String,TRequestLoc:%String,TFaultCase:%String,TFaultReason:%String,TDealMethod:%String,TFaultType:%String,TAcceptUser:%String,TAssign:%String,TMaintMode:%String,TUserSign:%String,TManageLoc:%String,TUseLoc:%String,TAddUser:%String,TUpdateUser:%String,TSubmitUser:%String,TModel:%String,TMaintLocDR:%String,TMaintRemark:%String,TMaintDept:%String")
{
}

ClassMethod TroubleAnalyzeExecute(ByRef qHandle As %Binary, StartDate, EndDate, FaultCaseDR, FaultReasonDR, DealMethodDR) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataTroubleAnalyze
	Quit $$$OK
BuildDataTroubleAnalyze
	f  s rowid=$o(^DHCEQMaintRequest(rowid))  quit:rowid=""  d
	.d ResetVariablesTroubleAnalyze
	.s TRowID = rowid
	.s TEquipDR = $Piece($Get(^DHCEQMaintRequest(rowid)),"^",1)
	.i TEquipDR '=""  d
	..s TEquip = $Piece($Get(^DHCEQEquip(TEquipDR)),"^",1)
	..s TModelDR = $Piece($Get(^DHCEQEquip(TEquipDR)),"^",3)
	..i TModelDR '= "" s TModel = $Piece($Get(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	.s TRequestLocDR = $Piece($Get(^DHCEQMaintRequest(rowid)),"^",2)
	.i TRequestLocDR '=""  d
	..s TRequestLoc = $Piece($Get(^CTLOC(TRequestLocDR)),"^",2)
	.s TFaultCaseDR = $Piece($Get(^DHCEQMaintRequest(rowid)),"^",3)
	.q:(FaultCaseDR'="")&&(FaultCaseDR'=TFaultCaseDR)
	.i TFaultCaseDR '=""  d
	..s TFaultCase = $Piece($Get(^DHCEQCCode("DHCEQCFaultCase",TFaultCaseDR)),"^",2)
	.s TFaultCaseRemark = $Piece($Get(^DHCEQMaintRequest(rowid)),"^",4)
	.s TFaultReasonDR = $Piece($Get(^DHCEQMaintRequest(rowid)),"^",5)
	.q:(FaultReasonDR'="")&&(FaultReasonDR'=TFaultReasonDR)
	.i TFaultReasonDR '=""  d
	..s TFaultReason = $Piece($Get(^DHCEQCCode("DHCEQCFaultReason",TFaultReasonDR)),"^",2)
	.s TFaultReasonRemark = $Piece($Get(^DHCEQMaintRequest(rowid)),"^",6)
	.s TDealMethodDR = $Piece($Get(^DHCEQMaintRequest(rowid)),"^",7)
	.q:(DealMethodDR'="")&&(DealMethodDR'=TDealMethodDR)
	.i TDealMethodDR '=""  d
	..s TDealMethod = $Piece($Get(^DHCEQCCode("DHCEQCDealMethod",TDealMethodDR)),"^",2)
	.s TDealMethodRemark = $Piece($Get(^DHCEQMaintRequest(rowid)),"^",8)
	.s TStartDate = ##class(web.DHCEQCommon).TransValueToPage($Piece($Get(^DHCEQMaintRequest(rowid)),"^",9),"date")
	.s TStartTime = $Piece($Get(^DHCEQMaintRequest(rowid)),"^",10)
	.s TEndDate = ##class(web.DHCEQCommon).TransValueToPage($Piece($Get(^DHCEQMaintRequest(rowid)),"^",11),"date")
	.s TEndTime = $Piece($Get(^DHCEQMaintRequest(rowid)),"^",12)
	.i StartDate="" s StartDate=0
	.i EndDate="" s EndDate=+$h
	.q:($Piece($Get(^DHCEQMaintRequest(rowid)),"^",13)<StartDate)!($Piece($Get(^DHCEQMaintRequest(rowid)),"^",13)>EndDate)
	.s TRequestDate = ##class(web.DHCEQCommon).TransValueToPage($Piece($Get(^DHCEQMaintRequest(rowid)),"^",13),"date")
	.s TRequestTime = $Piece($Get(^DHCEQMaintRequest(rowid)),"^",14)
	.s TFaultTypeDR = $Piece($Get(^DHCEQMaintRequest(rowid)),"^",15)
	.i TFaultTypeDR '=""  d
	..s TFaultType = $Piece($Get(^DHCEQCCode("DHCEQCFaultType",TFaultTypeDR)),"^",2)
	.s TAcceptDate = ##class(web.DHCEQCommon).TransValueToPage($Piece($Get(^DHCEQMaintRequest(rowid)),"^",16),"date")
	.s TAcceptTime = $Piece($Get(^DHCEQMaintRequest(rowid)),"^",17)
	.s TAcceptUserDR = $Piece($Get(^DHCEQMaintRequest(rowid)),"^",18)
	.i TAcceptUserDR '=""  d
	..s TAcceptUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TAcceptUserDR)
	.s TAssignDR = $Piece($Get(^DHCEQMaintRequest(rowid)),"^",19)
	.i TAssignDR '=""  d
	..s TAssign = ##class(web.DHCEQCommon).GetTrakNameByID("user",TAssignDR)
	.s TMaintModeDR = $Piece($Get(^DHCEQMaintRequest(rowid)),"^",20)
	.i TMaintModeDR '=""  d
	..s TMaintMode = $Piece($Get(^DHCEQCCode("DHCEQCMaintMode",TMaintModeDR)),"^",2)
	.s TPayedMaintFlag = $Piece($Get(^DHCEQMaintRequest(rowid)),"^",21)
	.s TMaintFee = $Piece($Get(^DHCEQMaintRequest(rowid)),"^",22)
	.s TUserSignDR = $Piece($Get(^DHCEQMaintRequest(rowid)),"^",23)
	.i TUserSignDR '=""  d
	..s TUserSign = ##class(web.DHCEQCommon).GetTrakNameByID("user",TUserSignDR)
	.s TUserOpinion = $Piece($Get(^DHCEQMaintRequest(rowid)),"^",24)
	.s TManageLocDR = $Piece($Get(^DHCEQMaintRequest(rowid)),"^",25)
	.i TManageLocDR '=""  d
	..s TManageLoc = $Piece($Get(^CTLOC(TManageLocDR)),"^",2)
	.s TUseLocDR = $Piece($Get(^DHCEQMaintRequest(rowid)),"^",26)
	.i TUseLocDR '=""  d
	..s TUseLoc = $Piece($Get(^CTLOC(TUseLocDR)),"^",2)
	.s TIsInputFlag = $Piece($Get(^DHCEQMaintRequest(rowid)),"^",27)
	.s TRemark = $Piece($Get(^DHCEQMaintRequest(rowid)),"^",28)
	.s TStatus = $Piece($Get(^DHCEQMaintRequest(rowid)),"^",29)
	.q:(TStatus'=4)
	.d OutputRowTroubleAnalyze
	quit
OutputRowTroubleAnalyze
	s Data=$lb(TRowID,TEquipDR,TRequestLocDR,TFaultCaseDR,TFaultCaseRemark,TFaultReasonDR,TFaultReasonRemark,TDealMethodDR,TDealMethodRemark,TStartDate,TStartTime,TEndDate,TEndTime,TRequestDate,TRequestTime,TFaultTypeDR,TAcceptDate,TAcceptTime,TAcceptUserDR,TAssignDR,TMaintModeDR,TPayedMaintFlag,TMaintFee,TUserSignDR,TUserOpinion,TManageLocDR,TUseLocDR,TIsInputFlag,TRemark,TStatus,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TSubmitUserDR,TSubmitDate,TSubmitTime,TEquip,TRequestLoc,TFaultCase,TFaultReason,TDealMethod,TFaultType,TAcceptUser,TAssign,TMaintMode,TUserSign,TManageLoc,TUseLoc,TAddUser,TUpdateUser,TSubmitUser,TModel,TMaintLocDR,TMaintRemark,TMaintDept)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesTroubleAnalyze
	s (TRowID,TEquipDR,TRequestLocDR,TFaultCaseDR,TFaultCaseRemark,TFaultReasonDR,TFaultReasonRemark,TDealMethodDR,TDealMethodRemark,TStartDate,TStartTime,TEndDate,TEndTime,TRequestDate,TRequestTime,TFaultTypeDR,TAcceptDate,TAcceptTime,TAcceptUserDR,TAssignDR,TMaintModeDR,TPayedMaintFlag,TMaintFee,TUserSignDR,TUserOpinion,TManageLocDR,TUseLocDR,TIsInputFlag,TRemark,TStatus,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TSubmitUserDR,TSubmitDate,TSubmitTime,TEquip,TRequestLoc,TFaultCase,TFaultReason,TDealMethod,TFaultType,TAcceptUser,TAssign,TMaintMode,TUserSign,TManageLoc,TUseLoc,TAddUser,TUpdateUser,TSubmitUser,TModel,TMaintLocDR,TMaintRemark,TMaintDept)=""
	quit
}

ClassMethod TroubleAnalyzeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = TroubleAnalyzeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod TroubleAnalyzeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = TroubleAnalyzeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// add by zy 0112

/// 描述:取到打印导出的查询信息
/// w ##class(web.DHCEQCommon).GetNum(0,3604)
/// -------------------------------
ClassMethod GetOneMaintDetail(PNum, job)
{
	i PNum=0 q $o(^DHCEQTemp("MaintRequetList",+$H,job,""),-1)
	q $g(^DHCEQTemp("MaintRequetList",+$H,job,PNum))
}

// add by zy 0112

/// Modified by jdl 2011-10-28 JDL0099 与web.DHCEQCommon统一方法参数
ClassMethod GetNum(node As %Library.String = "", job)
{
	q ..GetOneMaintDetail(0,job)
}

// add by zy 0112

/// Modified by jdl 2011-10-28 JDL0099 与web.DHCEQCommon统一方法参数
ClassMethod GetList(node As %Library.String = "", job, gnum)
{
	q ..GetOneMaintDetail(gnum,job)
}

///   ZY0124
/// w ##class(web.DHCEQMaintRequestNew).GetMRRowIDByEquipID(1)
ClassMethod GetMRRowIDByEquipID(equipdr)
{
	i equipdr="" q ""
	s MRRowID=""
	s rowid=""
	f  s rowid=$o(^DHCEQMaintRequest(0,"Equip",equipdr,rowid),-1)  quit:(rowid="")||(MRRowID'="")  d
	.quit:$p($g(^DHCEQMaintRequest(rowid)),"^",47)="Y"
	.quit:$Piece($G(^DHCEQMaintRequest(rowid)),"^",29)'="0"
	.s MRRowID=rowid
	q MRRowID
}

}
