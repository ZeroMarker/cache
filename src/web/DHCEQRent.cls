/// ------------------------------------
/// Modified By HZY 2011-7-19. Bug HZY0006
/// Description：在查询方法GetRentList中加个RequestNo参数，以实现按申请单号查询的功能。
/// ----------------------------------
/// 创建:zy 2010-07-22    No ZY0024
/// ----------------------------------
Class web.DHCEQRent Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// ----------------------------------
/// 创建:zy 2010-07-22  No ZY0024
/// 描述:新增、更新、删除、提交、借出、归还
/// w ##Class(web.DHCEQRent).SaveData("^^488^126^2620^1212^4176^435^02/03/2016^15:38^02/03/2016^18:00^^^^^^^2620^^^^^^^2620^^^^^^^^","0")
/// w ##Class(web.DHCEQRent).SaveData("^^488^126^2620^1212^4176^435^^^^^^^^^^^2620^^^^^^^2620^^^^^^^^","0")
ClassMethod SaveData(val, type, ActionCode As %String = "", User As %String = "", GroupID As %String = "", Action As %String = "")
{
	new RowID,PLIST,RequestNo,EquipDR,RequestLocDR
	Set $ZT="ERRORSave"
	s Date=+$H
	s Time=$P($H,",",2)
	i User="" s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s RowID = $p(val,"^",1)	;RowID
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("30")
	TSTART
	if type=0   //更新
	{
		s PLIST(3) = $p(val,"^",3)	;RequestLocDR
		s PLIST(4) = $p(val,"^",4)	;FromLocDR
		s PLIST(5) = $p(val,"^",5)	;RequestUserDR
		s PLIST(6) = Date			;RequestDate
		s PLIST(7) = Time			;RequestTime
		s PLIST(8) = $p(val,"^",6)	;ItemDR
		s PLIST(9) = $p(val,"^",7)	;ModelDR
		s PLIST(10) = $p(val,"^",8)	;EquipDR
		i $p(val,"^",13)'="" s PLIST(11) =##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",13),"date")	;StartDate
		i $p(val,"^",13)=""  s PLIST(11) =+$H  //add by zx 2016-08-12
		i $p(val,"^",14)'="" s PLIST(12) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",14),"time") ;StartTime
		i $p(val,"^",14)=""  s PLIST(12) =$p($H,",",2)  //add by zx 2016-08-12
		s PLIST(15) = $p(val,"^",15)	;RentManagerDR
		s PLIST(16) = $p(val,"^",16)	;LocReceiverDR
		s PLIST(17) = $p(val,"^",17)	;RentStatus
		s PLIST(18) = $p(val,"^",18)	;RentStatusRemark
		s PLIST(19) = $p(val,"^",19)	;RentOperatorDR
		s PLIST(20) = Date				;RentOperateDate
		s PLIST(21) = Time				;RentOperateTime
		s PLIST(37) = 0 			;status
		s PLIST(40) = $p(val,"^",33) ;Quantity
		s PLIST(41) = $p(^DHCEQCCode("DHCEQCMasterItem",PLIST(8)),"^",3) ;EquipType
		s PLIST(42) = 0 			;approvestatus
		s PLIST(48) = $p(val,"^",39)	//Hold3  add by zx 2016-07-06 联系电话
        	// BUG ZX0045
		if $p(val,"^",40)="true" s PLIST(49) ="Y"  
        	if $p(val,"^",40)="false" s PLIST(49) ="N"
		//i $p(val,"^",9)'="" s PLIST(38) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",9),"date")	;PlanBeginDate
		//i $p(val,"^",10)'="" s PLIST(39) = $ZTH($p(val,"^",10),2) ;PlanBeginTime
		//i $p(val,"^",11)'="" s PLIST(13) =##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",11),"date")	;PlanEndDate
		//i $p(val,"^",12)'="" s PLIST(14) = $ZTH($p(val,"^",12),2) ;PlanEndTime
		// 日期格式统一调整 mwz 2017-3-2
		s PLIST(38) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",9),"date")	;PlanBeginDate
		s PLIST(39)=##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",10),"time")
		s PLIST(13) =##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",11),"date")	;PlanEndDate
		s PLIST(14)=##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",12),"time")
		if RowID=""
		{
			s PLIST(2)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQRent",+$H,$p(val,"^",4),PLIST(41))	// Mozy	2016-10-21
			&SQL(insert into sqluser.DHC_EQRent values :PLIST())
			s RowID=$G(%ROWID)
		}
		else
		{
            		s Status=$p($g(^DHCEQRent(RowID)),"^",36)  //add by zx 2017-02-27 提交后状态不符不能再次提交 BUG ZX0045
            		if Status'="0" q -2015
			&SQL(update sqluser.DHC_EQRent values :PLIST() where R_RowID=:RowID)
		}
		if SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
		s ID=RowID
		TCOMMIT
		q RowID
	}
	elseif type=1   //删除
	{
		&SQL(delete from  sqluser.DHC_EQRent where R_RowID=:RowID)
		if SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
		TCOMMIT
		q RowID
	}
	elseif type=2   //提交  modify by GBX 2015-12-08  新增审批流
	{
		s Status=$p($g(^DHCEQRent(RowID)),"^",36)  //add by zx 2016-11-22 提交后状态不符不能再次提交 ZX0036
		if Status'="0" q -2015
		s ApproveSet=##class(web.DHCEQCApproveSet).JudgeApproveSet(ApproveType, "", "", "", "","")
		i ApproveSet="" q "审批设置为空"
		s SQLCODE=##class(web.DHCEQApproveList).DeleteApproveList(ApproveSet,RowID,"30",User)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
		s ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, RowID, 0, "")
		s AutoAuditFlag=$p(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
		s LastFlag=$P(ApproveFlow,"^",1)
		s NextStep=$P(ApproveFlow,"^",2)
		s NextRole=$P(ApproveFlow,"^",3)
		s AppInfoStatus="1"
		//add by zx 2016-11-03 修改AppInfo生成方式 ZX0036
		
	 	/*Set AppInfo(2)=ApproveType
		Set AppInfo(3)=RowID
		Set AppInfo(4)=ApproveSet
		Set AppInfo(5)=NextRole
		Set AppInfo(6)=NextStep
		Set AppInfo(7)=""			;ApproveStatus  当前审核步骤
		Set AppInfo(8)=""			;ApproveRoleDR
		Set AppInfo(9)="1"			;Status*/
		&SQL(update sqluser.DHC_EQRent set R_Status='1',R_ApproveStatus='1' where R_RowID=:RowID)
		if SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
		Set AuditFlag=0 		
		i AutoAuditFlag="Y"
		{
			i (NextStep="")||(LastFlag="Y")
			{
			 	s AuditFlag=1
				//最后一步审核
				s SQLCODE=..SaveData(val, "6")
				if SQLCODE<0
				{
					TROLLBACK
					q SQLCODE
				}
			}
		}
		//add by zx 2016-11-03 修改AppInfo生成方式 ZX0036
		s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,RowID,NextRole,NextStep,"","",AppInfoStatus)
		If SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}
		/*Set ApproveInfoID=$Order(^DHCEQApproveInfo(0,"SourceID",ApproveType,RowID,0))
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
		}*/
		
		s ID=RowID
		//租赁消息
		s ApproveFlow=ApproveFlow_"^"_ApproveSet
		s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("64", RowID, User, ApproveFlow, "N","",AuditFlag)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
		
		TCOMMIT
		q RowID
	}
	elseif type=3   //复制
	{
		s RequestNo=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQRent",+$H)
		&SQL(Insert Into sqluser.DHC_EQRent
    	(R_RequestNo,R_RequestLocDR,R_FromLocDR,R_RequestUserDR,R_RequestDate,
    	R_RequestTime,R_ItemDR,R_ModelDR,R_EquipDR,R_PlanEndDate,R_PlanEndTime,
    	R_Status,R_PlanBeginDate,R_PlanBeginTime) 
		Select :RequestNo,R_RequestLocDR,R_FromLocDR,R_RequestUserDR,:Date,
		:Time,R_ItemDR,R_ModelDR,R_EquipDR,R_PlanEndDate,R_PlanEndTime,
		'0',R_PlanBeginDate,R_PlanBeginTime
		From sqluser.DHC_EQRent Where R_RowID=:RowID)
	}
	elseif type=4   //反提交
	{
		s CurRole=$p(val,"^",2)  //Role
		Set AppInfo=##class(web.DHCEQApprove).GetApproveInfoBySourceID("30",RowID)
		;获取取消到上一步的信息
		Set CancelToFlowDR=$Piece(AppInfo,"^",8)
		Set Status="0"
		set RStatus="0"
		Set ApproveRoleDR=""
		Set Step=""
		Set ApproveType=##class(web.DHCEQApproveList).GetApproveType("30")
		Set ApproveSet=##class(web.DHCEQApproveList).GetApproveSet("30", RowID)
		if (CancelToFlowDR'="")
		{
			Set ApproveRoleDR=$Piece($Get(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",2)
			Set Step=$Piece($Get(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",3)
			Set Status="1"
			if (Step=1)
			{
				s RStatus="1"
			}
			else
			{
				s RStatus="2"
			}
		}
		;Modify by zx 2020-06-12 生成审批记录
		s CurStep=##class(web.DHCEQCApproveSet).GetStepByRole(ApproveSet,CurRole)
		s SQLCODE=##class(web.DHCEQApproveList).UpdateData(ApproveType,RowID,"拒绝","",CurRole,CurStep,User,"1")
		if SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}
		//add by zx 2016-11-03 修改AppInfo生成方式 ZX0036
		s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,RowID,ApproveRoleDR,Step,"","",Status,"Y")
		If SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}	
		/*
		s AppInfo(5)=ApproveRoleDR
		s AppInfo(6)=Step
		s AppInfo(7)=""		;ApproveStatus
		s AppInfo(8)=""		;ApproveRoleDR
		s AppInfo(9)=Status	;Status
		s AppInfo(20)=$p($g(^DHCEQRent(RowID)),"^",4)	//RequestUserDR
		s ApproveInfoID=$o(^DHCEQApproveInfo(0,"SourceID",ApproveType,RowID,0))		
		&SQL(update sqluser.DHC_EQApproveInfo values :AppInfo() where AI_RowID=:ApproveInfoID)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}*/
		&SQL(update sqluser.DHC_EQRent set R_ApproveStatus=:Status,R_Status=:RStatus where R_RowID=:RowID)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
		else
		{
			s ApproveFlow=""
			i CancelToFlowDR'=""
			{
				s ApproveFlow="N^"_Step_"^"_ApproveRoleDR_"^"_$p(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR),"^",7,11)_"^"_ApproveSet
			}
			else
			{
				s ApproveFlow="^^^^^^^^"_ApproveSet
			}
			s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("64", RowID, User, ApproveFlow, "Y", CurRole)
			i SQLCODE
			{
				TROLLBACK
				q SQLCODE
			}
		}
		 TCOMMIT
		 q RowID	
	}
	elseif type=5   //借出
	{
		s CurRole=$p(val,"^",34)  //Role
		//##class(web.DHCEQOpenCheckRequest).GetApproveSet(RowID,CurRole)	
		s ApproveSet=##class(web.DHCEQCApproveSet).JudgeApproveSet(ApproveType, "", "", "", "","")
		s CurStep=##class(web.DHCEQCApproveSet).GetStepByRole(ApproveSet, CurRole, Action)		//Add By DJ 2016-05-30
        	// add by zx 2017-06-27 BUG ZX0045
        	i ActionCode'="" d
        	.s RoleStep=##class(web.DHCEQCApproveSet).GetRoleByAction(ApproveSet,ActionCode)
        	.s CurRole=$p(RoleStep,"^",1)
        	.s CurStep=$p(RoleStep,"^",2)       //Add By DJ 2016-05-30
		s NextApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, RowID, CurStep, CurRole)
	 	s LastFlag=$p(NextApproveFlow,"^",1)
	 	s NextStep=$p(NextApproveFlow,"^",2)  //NextStep
	 	s NextRole=$p(NextApproveFlow,"^",3)  //NextRole
	 	s AutoAuditFlag=$p(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
	 	
	 	s PLIST(8) = $p(val,"^",6)	;ItemDR
		s PLIST(9) = $p(val,"^",7)	;ModelDR
		s PLIST(10) = $p(val,"^",8)	;EquipDR
		i $p(val,"^",13)'="" s PLIST(11) =##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",13),"date")	;StartDate
		i $p(val,"^",14)'="" s PLIST(12) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",14),"time") ;StartTime
		s PLIST(15) = $p(val,"^",15)	;RentManagerDR
		s PLIST(16) = $p(val,"^",16)	;LocReceiverDR
		s PLIST(17) = $p(val,"^",17)	;RentStatus
		s PLIST(18) = $p(val,"^",18)	;RentStatusRemark
		s PLIST(19) = $p(val,"^",19)	;RentOperatorDR
		s PLIST(20) = Date				;RentOperateDate
		s PLIST(21) = Time				;RentOperateTime
		s PLIST(40) = $p(val,"^",33) 	;Quantity
		s PLIST(41) = $p(^DHCEQCCode("DHCEQCMasterItem",PLIST(8)),"^",3) 	;EquipType
		s PLIST(37) = "2"				;status
		s PLIST(42) = "1"				;approvestatus  //modify by GBX 2015-12-14
		s PLIST(44) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",35),"date")	;RenewalToDate
		s PLIST(45) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",36),"time")	;RenewalToTime
		s PLIST(46) = $p(val,"^",37)	//Hold1
		s PLIST(47) = $p(val,"^",38)	//Hold2
		s PLIST(48) = $p(val,"^",39)	//Hold3
		//s PLIST(49) = $p(val,"^",40)	//Hold4
		s PLIST(49) ="N"  // add by zx 2016-06-28 附件齐全标志
        if $p(val,"^",40)="true" s PLIST(49) ="Y"
		;s PLIST(50) = $p(val,"^",41)	//Hold5
		//add by zx 2016-11-03 修改AppInfo生成方式 ZX0036
		/*
	 	Set AppInfo(5)=NextRole
		Set AppInfo(6)=NextStep	
		Set AppInfo(7)=CurStep		;
		Set AppInfo(8)=CurRole		;
		Set AppInfo(9)="1"			;Status	*/
		&SQL(update sqluser.DHC_EQRent values :PLIST()  where R_RowID=:RowID)
		if SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
		/// Mozy	更新设备台账信息
		s EquipDR=$p(val,"^",8)
		s RequestLocDR=$p($g(^DHCEQRent(RowID)),"^",2)
		&SQL(Update SQLUSER.DHC_EQEquip Set EQ_RentLocDR=:RequestLocDR,EQ_RentStatus=1 Where EQ_RowID=:EquipDR)
		// BUG ZX0045
        	if (ActionCode="ZL_Loan")||(ActionCode="ZL_Return")
        	{
            		i ActionCode="ZL_Loan" s RentStatus="1"
            		i ActionCode="ZL_Return" s RentStatus="2"
			s SQLCODE=##Class(web.DHCEQRent).SaveRentAffix(RowID,RentStatus) //add by zx 2016-07-05 租赁附件处理
		    if SQLCODE
		    {
			    TROLLBACK
			    q SQLCODE
		    }
		}
		
		s AuditFlag=0
	 	i AutoAuditFlag="Y"
		{
		 	i (NextStep="")||(LastFlag="Y")
		 	{	
		 		s SQLCODE=..SaveData(val, "6")	 	
				if SQLCODE<0
				{
		 			TROLLBACK
		 			q SQLCODE
				}
				Set AppInfo(9)="2"
			 	s AuditFlag=1
		 	}
		}
		s SQLCODE=##class(web.DHCEQApproveList).UpdateData(ApproveType, RowID, "", "", CurRole, CurStep,User)  //add by zx 2016-11-30  审批生成消息且修改approvelist ZX0036
		if SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
		//add by zx 2016-11-03 修改AppInfo生成方式 ZX0036
		s AppInfoStatus="1"
		i AutoAuditFlag="Y" s AppInfoStatus="2"
		s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,RowID,NextRole,NextStep,CurStep,CurRole,AppInfoStatus)
		If SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}
		/*
		&SQL(update sqluser.DHC_EQApproveInfo values :AppInfo() where AI_SourceID=:RowID and  AI_ApproveSetDR=:ApproveSet)
		If SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}*/
		s ApproveFlow=NextApproveFlow_"^"_ApproveSet		//Add By DJ 2016-05-30
		s vLimitLocActions=$o(^DHCEQCCode("DHCEQCAction",0,"Code","ZL_LocReturn",0)) //add by zx 2016-11-29 消息生成设置 ZX0036
		s LimitLocDR=$Piece($Get(^DHCEQRent(RowID)),"^",2)
		s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("64", RowID, User, ApproveFlow, "N",CurRole,AuditFlag,"","","",vLimitLocActions,LimitLocDR)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
		
		TCOMMIT
		q RowID	
	}
	elseif type=6   //归还
	{
		s PLIST(22) = $p(val,"^",20)		;ReturnManagerDR
		s PLIST(23) = $p(val,"^",21)		;LocReturnDR
		i $p(val,"^",22)'="" s PLIST(24) =##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",22),"date")	;ReturnDate
		i $p(val,"^",23)'="" s PLIST(25) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",23),"time")		;ReturnTime
		s PLIST(26) = $p(val,"^",24)		;ReturnStatus
		s PLIST(27) = $p(val,"^",25)		;ReturnStatusRemark
		s PLIST(28) = $p(val,"^",26)		;ReturnOperatorDR
		s PLIST(29) = Date					;ReturnOperateDate
		s PLIST(30) = Time					;ReturnOperateTime
		s PLIST(31) = $p(val,"^",27)		;WorkLoad
		s PLIST(32) = $p(val,"^",28)		;WorkLoadUOMDR
		s PLIST(33) = $p(val,"^",29)		;RentFee
		s PLIST(34) = $p(val,"^",30)		;LucreFee
		s PLIST(35) = $p(val,"^",31)		;LosingFee
		s PLIST(36) = $p(val,"^",32)		;TotalFee
		s PLIST(40) = $p(val,"^",33) 		;Quantity
		;s PLIST(41) = $p(val,"^",41) 		;EquipType
		s PLIST(37) = "3"					;status
		s PLIST(42) = "2"					;approvestatus  //modify by GBX 2015-12-14
		s PLIST(50) ="N"  					// add by zx 2016-06-28 附件齐全标志
        if $p(val,"^",41)="true" s PLIST(50) ="Y"
		&SQL(update sqluser.DHC_EQRent values :PLIST() where R_RowID=:RowID)
		i SQLCODE
	 	{
			TROLLBACK
			q SQLCODE
	 	}
		/// Mozy	更新设备台账信息
		s EquipDR=$p(val,"^",8)
		&SQL(Update SQLUSER.DHC_EQEquip Set EQ_RentLocDR=null,EQ_RentStatus=0 Where EQ_RowID=:EquipDR)
	}
	i SQLCODE
 	{
		TROLLBACK
		q SQLCODE
 	}
 	s ID=$G(%ROWID)
 	TCOMMIT
 	q ID
ERRORSave 
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit "ERRORSave"_ErrorMsg     //返回错误消息
}

/// ----------------------------------
/// 创建:zy 2010-07-22  No ZY0024
/// 描述:借出、归还
/// w ##Class(web.DHCEQRent).Update("20^223^20/07/2010^16:13^1^10773^0^@21^223^20/07/2010^16:13^1^10667^0^","Rent")
/// ----------------------------------
ClassMethod Update(val, type)
{
	new flag,Date,Time,User,len,Num,valList,RowID,EquipDR
	k PLIST
	s flag=0
	s Date=+$H
	s Time=$P($H,",",2)
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	S $ZT="ERRORUpdate"
	s len=$L(val,"@")
	TSTART
	for i=1:1:len
	{
		q:flag'=0
		s Num=0
		s valList=	$p(val,"@",i)
		s RowID= $p(valList,"^",1)  		;RowID
		s PLIST(10) = $p(valList,"^",2)		;EquipDR
		s EquipDR = $p(valList,"^",2)		;EquipDR
		if type="Rent"
		{
			&SQL(select Count(R_RowID) into :Num from sqluser.DHC_EQRent where R_EquipDR=:PLIST(10) and R_Status='2')
			i Num'=0 s flag="第"_i_"条申请的设备已经被借出."
			q:flag'=0
			i $p(valList,"^",3)'="" s PLIST(11) =##class(web.DHCEQCommon).TransValueFromPage($p(valList,"^",3),"date")	;StartDate
			i $p(valList,"^",4)'="" s PLIST(12) = ##class(web.DHCEQCommon).TransValueFromPage($p(valList,"^",4),"time") ;StartTime
			s PLIST(15) = $p(valList,"^",5)	;RentManagerDR
			s PLIST(16) = $p(valList,"^",6)	;LocReceiverDR
			s PLIST(17) = $p(valList,"^",7)	;RentStatus
			s PLIST(18) = $p(valList,"^",8)	;RentStatusRemark
			s PLIST(19) = User				;RentOperatorDR
			s PLIST(20) = Date				;RentOperateDate
			s PLIST(21) = Time				;RentOperateTime
			s PLIST(37) = "2"				;status
		}
		elseif (type="Return")
		{
			s (SourceID,SourceType,EquipRentDR,WorkLoadDR,Price)=""
			s PLIST(22) = $p(valList,"^",5)	;ReturnManagerDR
			s PLIST(23) = $p(valList,"^",6)	;LocReturnDR
			i $p(valList,"^",2)'="" s PLIST(24) =##class(web.DHCEQCommon).TransValueFromPage($p(valList,"^",3),"date")	;ReturnDate
			i $p(valList,"^",3)'="" s PLIST(25) = ##class(web.DHCEQCommon).TransValueFromPage($p(valList,"^",4),"time")		;ReturnTime
			s PLIST(26) = $p(valList,"^",7)	;ReturnStatus
			s PLIST(27) = $p(valList,"^",8)	;ReturnStatusRemark
			s PLIST(28) = User				;ReturnOperatorDR
			s PLIST(29) = Date				;ReturnOperateDate
			s PLIST(30) = Time				;ReturnOperateTime
			s PLIST(31) = $p(valList,"^",9)	;WorkLoad
			s Str=##Class(web.DHCEQEquipRent).GetEquipRentInfo(EquipDR)
			s WorkLoadDR=$p(Str,"^",3)
			s PLIST(32) =WorkLoadDR	;WorkLoadUOMDR
			;s PLIST(33) = $p(valList,"^",10)	;RentFee
			;s PLIST(34) = $p(valList,"^",11)	;LucreFee
			;s PLIST(35) = $p(valList,"^",12)	;LosingFee
			s PLIST(36) = $p(valList,"^",10)	;TotalFee
			s PLIST(40) = $p(val,"^",33) ;Quantity
			;s PLIST(41) = $p(val,"^",34) ;EquipType
			s PLIST(37) = "3"				;status
		}
		&SQL(update sqluser.DHC_EQRent values :PLIST() where R_RowID=:RowID)
		i SQLCODE=100 s SQLCODE=0
		i SQLCODE'=0 s flag=SQLCODE
	}
	i flag'=0
 	{
		TROLLBACK
		q flag
 	}
 	TCOMMIT
 	q flag
ERRORUpdate
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit "ERRORUpdate"_ErrorMsg  //返回错误消息 ;
}

/// Creator：      WL
/// CreatDate：    2019-12-19
/// Description:   润乾打印(接送单)
/// Input：        RRowID:租借ID  DHC_EQRent 
/// d ##class(%ResultSet).RunQuery("web.DHCEQRent","GetRentPrint","20") 
Query GetRentPrint(RRowID As %String = "") As %Query(ROWSPEC = "RRequestNo:%String,RFromLocDR_DeptDesc:%String,RHold3:%String,RStartDate:%String,REquipDR_EQName:%String,RModelDR_MDesc:%String,REquipDR_EQNo:%String") [ SqlProc ]
{
}

ClassMethod GetRentPrintExecute(ByRef qHandle As %Binary, RRowID As %String = "") As %Status
{
	
	s repid=$I(^CacheTemp)
 	s ind=1
 	s qHandle=$lb(0,repid,0)
 	i RRowID="" q $$$OK
 	s (TRequestNo,TRequestLocDR,TRequestLoc,TFromLocDR,TFromLoc,TRequestUserDR,TRequestUser,THold3,TStartDate,TEquipName)=""    
	s TRequestNo=$p($g(^DHCEQRent(RRowID)),"^",1)  
	s TFromLocDR=$p($g(^DHCEQRent(RRowID)),"^",3)
	i TFromLocDR'=""  s TFromLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TFromLocDR) 
	s THold3=$p($g(^DHCEQRent(RRowID)),"^",47) //联系电话
	s TStartDate=$p($g(^DHCEQRent(RRowID)),"^",10)
	i TStartDate'="" s TStartDate=##class(DHCEQCommon).TransValueToPage(TStartDate,"date")
	s TEquipDR=$p($g(^DHCEQRent(RRowID)),"^",9)
	i TEquipDR'="" d
	.s TEquipName=$p($g(^DHCEQEquip(TEquipDR)),"^",1)
	.s TEquipNo=$p($g(^DHCEQEquip(TEquipDR)),"^",71)
	s TModelDR=$p($g(^DHCEQRent(RRowID)),"^",8)
	i TModelDR'="" s TModel= $p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	d OutputRowGetRentPrint

 
 Quit $$$OK	 
OutputRowGetRentPrint
 set Data=$lb(TRequestNo,TFromLoc,THold3,TStartDate ,TEquipName,TModel,TEquipNo) 
 set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod GetRentPrintFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRentPrintExecute ]
{
	 Set AtEnd=$LIST(qHandle,1)
	 Set repid=$LIST(qHandle,2)
	 Set ind=$LIST(qHandle,3)
	 Set ind=$o(^CacheTemp(repid,ind))
	 If ind=""
	 {
	  //if there are no more rows,finish fetching...
	  Set AtEnd=1
	  Set Row=""
	 }
	 Else
	 {
	  Set Row=^CacheTemp(repid,ind)
	 }
	 s qHandle=$lb(AtEnd,repid,ind)
	 Quit $$$OK
}

ClassMethod GetRentPrintPrintClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRentPrintExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 创建:zy 2010-07-22  No ZY0024
/// 描述:根据rowid取记录
/// w ##Class(web.DHCEQRent).GetRentByID("13")
ClassMethod GetRentByID(rowid As %Library.String = "", ApproveRoleDR As %Library.String = "")
{
	;Set UserID=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))    //modified by czf 2017-10-13   需求号：355515
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQRent(rowid)
	s resultex=resultex_"^"	
	i $p(result,"^",2)'=""  d  //requestloc   1
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",2))
	s resultex=resultex_"^"
	i $p(result,"^",3)'=""  d  //fromloc	2
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",3))
	s resultex=resultex_"^"
	i $p(result,"^",4)'=""  d  //requestuser	3
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",4))
	s resultex=resultex_"^"
	i $p(result,"^",5)'=""  d  //requestdate	4
	.s resultex=resultex_##class(web.DHCEQCommon).TransValueToPage($p(result,"^",5),"date")
	s resultex=resultex_"^"
	i $p(result,"^",6)'=""  d  //requesttime	5
	.s resultex=resultex_$ZT($p(result,"^",6),2)
	s resultex=resultex_"^"
	i $p(result,"^",7)'=""  d  //item		6
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCMasterItem",$p(result,"^",7))),"^",1)
	s resultex=resultex_"^"
	i $p(result,"^",8)'=""  d  //model		7
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCModel",$p(result,"^",8))),"^",2)
	s resultex=resultex_"^"
	i $p(result,"^",9)'=""  d  //equipname		8
	.s resultex=resultex_$p($g(^DHCEQEquip($p(result,"^",9))),"^",1)
	s resultex=resultex_"^"
	i $p(result,"^",10)'=""  d  //startdate		9
	.s resultex=resultex_##class(web.DHCEQCommon).TransValueToPage($p(result,"^",10),"date")
	s resultex=resultex_"^"
	i $p(result,"^",11)'=""  d  //starttime		10
	.s resultex=resultex_$ZT($p(result,"^",11),2)
	s resultex=resultex_"^"
	i $p(result,"^",12)'=""  d  //planenddate		11
	.s resultex=resultex_##class(web.DHCEQCommon).TransValueToPage($p(result,"^",12),"date")
	s resultex=resultex_"^"
	i $p(result,"^",13)'=""  d  //planendtime		12
	.s resultex=resultex_$ZT($p(result,"^",13),2)
	s resultex=resultex_"^"
	i $p(result,"^",14)'=""  d  //rentmanager		13
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",14))
	s resultex=resultex_"^"
	i $p(result,"^",15)'=""  d  //locreceiver		14
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",15))
	s resultex=resultex_"^"
	i $p(result,"^",16)'=""  d  //rentstatus		15
	.s resultex=resultex_$CASE($p(result,"^",16),"0":"完好", "1":"有缺陷")
	s resultex=resultex_"^"
	i $p(result,"^",18)'=""  d  //rentopeart		16
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",18))
	s resultex=resultex_"^"
	i $p(result,"^",19)'=""  d  //opeartdate		17
	.s resultex=resultex_##class(web.DHCEQCommon).TransValueToPage($p(result,"^",19),"date")
	s resultex=resultex_"^"
	i $p(result,"^",20)'=""  d  //opearttime		18
	.s resultex=resultex_$ZT($p(result,"^",20),2)
	s resultex=resultex_"^"
	i $p(result,"^",21)'=""  d  //returnmanager		19
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",21))
	;e  d
	;.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",UserID)    //modified by czf 2017-10-13   需求号：355515
	s resultex=resultex_"^"
	i $p(result,"^",22)'=""  d  //locreturner		20
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",22))
	s resultex=resultex_"^"
	i $p(result,"^",23)'=""  d  //returndate		21
	.s resultex=resultex_##class(web.DHCEQCommon).TransValueToPage($p(result,"^",23),"date")
	e  d
	.s resultex=resultex_##class(web.DHCEQCommon).TransValueToPage($h,"date")             //modified by czf 2017-04-05  需求号：355515
	s resultex=resultex_"^"
	i $p(result,"^",24)'=""  d  //returntime		22
	.s resultex=resultex_$ZT($p(result,"^",24),2)
	s resultex=resultex_"^"
	i $p(result,"^",25)'=""  d  //returnstatus		23
	.s resultex=resultex_$CASE($p(result,"^",25),"0":"完好", "1":"有缺陷","2":"故障")
	s resultex=resultex_"^"
	i $p(result,"^",27)'=""  d  //returnopeart		24
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",27))
	s resultex=resultex_"^"
	i $p(result,"^",28)'=""  d  //returndate		25
	.s resultex=resultex_##class(web.DHCEQCommon).TransValueToPage($p(result,"^",28),"date")
	s resultex=resultex_"^"
	i $p(result,"^",29)'=""  d  //returntime		26
	.s resultex=resultex_$ZT($p(result,"^",29),2)
	s resultex=resultex_"^"
	i $p(result,"^",31)'=""  d  //workuom		27
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("uom",$p(result,"^",31))
	s $p(result,"^",32)=##Class(web.DHCEQCommon).FormatNumber($p(result,"^",32),"")
	s $p(result,"^",33)=##Class(web.DHCEQCommon).FormatNumber($p(result,"^",33),"")
	s $p(result,"^",34)=##Class(web.DHCEQCommon).FormatNumber($p(result,"^",34),"")
	s $p(result,"^",35)=##Class(web.DHCEQCommon).FormatNumber($p(result,"^",35),"")
	s resultex=resultex_"^"
	i $p(result,"^",36)'=""  d  //status		28
	.s resultex=resultex_$CASE($p(result,"^",36),"0":"新增", "1":"申请","2":"借出","3":"归还","4":"其他")
	s resultex=resultex_"^"
	i $p(result,"^",37)'=""  d  //planbegindate		29
	.s resultex=resultex_##class(web.DHCEQCommon).TransValueToPage($p(result,"^",37),"date")
	s resultex=resultex_"^"
	i $p(result,"^",38)'=""  d  //planbegintime		30
	.s resultex=resultex_$ZT($p(result,"^",38),2)
	s resultex=resultex_"^"
	i $p(result,"^",9)'=""  d  //equipno		32
	.s resultex=resultex_$p($g(^DHCEQEquip($p(result,"^",9))),"^",71)
	
	//计算工作量
	//add by wy 2017-8-18 添加工作量单位
	s (Price,Mode,Str,WorkLoadUOMDR,WorkLoadUOM)=""
	i $p(result,"^",9)'=""  d  //price  33,34
	.s Str=##Class(web.DHCEQEquipRent).GetEquipRentInfo($p(result,"^",9))
	.i Str'="" d
	..s Price=$p(Str,"^",2)
	..s EquipRentID=$p(Str,"^",1)
	..s Mode=$p($g(^DHCEQEquipRent(EquipRentID)),"^",4)		//计价方式
	..s WorkLoadUOMDR=$p($g(^DHCEQEquipRent(EquipRentID)),"^",10)		//add by wy 2017-8-18
	..s WorkLoadUOM=##class(web.DHCEQCommon).GetTrakNameByID("uom",WorkLoadUOMDR)    //工作量单位
	
	s $p(result,"^",43)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",43),"date")
	s $p(result,"^",44)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",44),"time")
	
	//Add By DJ 2016-06-01
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("30")
	s ApproveSet=##class(web.DHCEQCApproveSet).JudgeApproveSet(ApproveType, "", "", "", "","")
	s ApproveAction=""
	i ApproveType'=""  d
	.s ApproveInfoID=$o(^DHCEQApproveInfo(0,"SourceID",ApproveType,rowid,0))
	.i ApproveInfoID'=""  d
	..s CurStep=$p($g(^DHCEQApproveInfo(ApproveInfoID)),"^",5)
	..i ((CurStep'="")&&(ApproveSet'=""))  d
	...s AFRowID=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",ApproveSet,CurStep,0))
	...i AFRowID'=""  d
	....s ChangeTypeFlag=$p($g(^DHCEQCCode("DHCEQCApproveFlow",AFRowID)),"^",15)
	....s ApproveActionDR=$p(^DHCEQCCode("DHCEQCApproveFlow",AFRowID),"^",9)
	....i ApproveActionDR'=""  d
	.....s ApproveAction=$p($g(^DHCEQCCode("DHCEQCAction",ApproveActionDR)),"^",1)
	.....i ChangeTypeFlag="Y"  d		//可被其它步骤中断,检测可被中断步骤
	......s AllowFlowDR=0
	......f  s AllowFlowDR=$o(^DHCEQCCode("DHCEQCApproveFlowAllow",0,"SourceFlow",2,AFRowID,AllowFlowDR)) q:AllowFlowDR=""  d
	.......s AllowActionDR=$p($g(^DHCEQCCode("DHCEQCApproveFlow",AllowFlowDR)),"^",9)
	.......i AllowActionDR'="" s ApproveAction=ApproveAction_","_$p($g(^DHCEQCCode("DHCEQCAction",AllowActionDR)),"^",1)
	i ApproveAction'="" s ApproveAction=","_ApproveAction_","
	
	s resultex=resultex_"^"_Price_"^"_Mode_"^"_ApproveSet_"^"_ApproveAction
    s resultex=resultex_"^"_##Class(web.DHCEQRent).GetworkNumByMonth($p(result,"^",10),$p(result,"^",11),$p(result,"^",23),$p(result,"^",24))
	Set AppInfo=##class(web.DHCEQApprove).GetApproveInfoBySourceID("30",rowid,ApproveRoleDR)  //add by zx 2016-07-14 获取审批流信息
	s result=result_"^"_resultex_"^"_AppInfo
	
	; Mozy	2016-8-17
	s result=result_"^"
	i $p(result,"^",9)'="" s result=result_$p($g(^DHCEQEquip($p(result,"^",9))),"^",85)	;EQFileNo
	s result=result_"^"
	i $p(result,"^",9)'="" s result=result_$p($g(^DHCEQEquip($p(result,"^",9))),"^",10)	;EQLeaveFactoryNo
	s result=result_"^"			;科室电话存储在科室类型表备注内
	Set Tel=""
	Set LocType=""
	For  Set LocType=$Order(^DHCEQCCode("DHCEQCLocType",0,"LocType",LocType)) Quit:(LocType="")  Do
	.Set LocTypeCode=$p(^DHCEQCCode("DHCEQCLocGroupType",LocType),"^",2)
	.Quit:LocTypeCode'="0102"	;只取库房科室中的科室定义的备注
	.Set ltid=$Order(^DHCEQCCode("DHCEQCLocType",0,"LocType",LocType,$p(result,"^",2),""))
	.If ltid'="" Set Tel=$Piece(^DHCEQCCode("DHCEQCLocType",ltid),"^",8)
	s result=result_Tel_"^"_WorkLoadUOMDR_"^"_WorkLoadUOM
	
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result
}

/// 创建:zy 2010-07-22  No ZY0024
/// 描述:借出时设备状态
/// ----------------------------------
ClassMethod GetRentStatus(name, width, Type) As %String
{
	;;下拉列表
	;w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	;modify by lmm 2019-09-05 修改下拉列表必填提示
	;w ##class(web.DHCEQCommon).GetDefaultStyle(name,"")	//add by csj 20180903 hisui下拉列表调整
	if (width="")||(width=0) s width=155	//modified by czf 20181211
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"px;HEIGHT:30px;;' class='hisui-combobox' data-required=true data-options="""_"prompt:"_"'必填项'"_""">"
	w "<option value=></option>"
	w "<option value=0>完好</option>"
	w "<option value=1>有缺陷</option>"
	w "</select>",!
}

/// 创建:zy 2010-07-22  No ZY0024
/// 描述:归还时设备状态
/// ----------------------------------
ClassMethod GetReturnStatus(name, width, Type) As %String
{
	;;下拉列表
	;w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w ##class(web.DHCEQCommon).GetDefaultStyle(name,"")	//add by csj 20180903 hisui下拉列表调整
	w "<option value=></option>"
	w "<option value=0>完好</option>"
	w "<option value=1>有缺陷</option>"
	w "<option value=2>故障</option>"
	w "</select>",!
}

/// 创建:zy 2010-07-22  No ZY0024
/// 描述:租赁申请单的状态
/// ----------------------------------
ClassMethod GetStatus(name, width, Type) As %String
{
	;;下拉列表
	;w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w ##class(web.DHCEQCommon).GetDefaultStyle(name,"")	;add by csj 20180901 2.	问题：自定义下拉列表显示格式错误
	w "<option value=></option>"
	i (Type="Apply")||(Type="Find") w "<option value=0>新增</option>"
	w "<option value=1>申请</option>"
	w "<option value=2>借出</option>"
	w "<option value=3>归还</option>"
	w "<option value=4>其他</option>"
	w "</select>",!
}

/// -----------------------------------
/// Modified By HZY 2011-7-19. Bug HZY0006
/// Description：在查询方法GetRentList中加个RequestNo参数，以实现按申请单号查询的功能。
/// -----------------------------------
/// 创建:zy 2010-07-22  No ZY0024
/// 描述:租赁申请单的查询
/// -----------------------------------
/// add by zx 2016-06-17 
/// 增加'EquipDR'查询,移动端根据设备遍历单据
/// modified by csj 20190116 增加WaitAD待操作单据参数
/// d ##class(%ResultSet).RunQuery("web.DHCEQRent","GetRentList",0,0,"Apply",,,,0,,"2017-10-31",,,,,,)
Query GetRentList(QXType As %String = "", vQXType As %String = "", Type As %String = "", RequestLocDR As %String = "", FromLocDR As %String = "", ItemDR As %String = "", StatusDR As %String = "", BeginDate As %String = "", EndDate As %String = "", RequestNo As %String = "", EquipType As %String = "", ApproveRole As %String = "", Action As %String = "", EquipDR As %String = "", FileNo As %String = "", CurUser As %String = "", WaitAD As %String = "") As %Query(ROWSPEC = "TRowID:%String,TRequestNo:%String,TRequestLoc:%String,TRequestLocDR:%String,TFromLocDR:%String,TFromLoc:%String,TRequestUser:%String,TRequestUserDR:%String,TRequestDate:%String,TRequestTime:%String,TItem:%String,TItemDR:%String,TModel:%String,TModelDR:%String,TEquip:%String,TEquipDR:%String,TStartDate:%String,TStartTime:%String,TPlanEndDate:%String,TPlanEndTime:%String,TRentManager:%String,TRentManagerDR:%String,TLocReceiver:%String,TLocReceiverDR:%String,TRentStatus:%String,TRentStatusRemark:%String,TRentOperatorDR:%String,TRentOperateDate:%String,TRentOperateTime:%String,TReturnManager:%String,TReturnManagerDR:%String,TLocReturn:%String,TLocReturnDR:%String,TReturnDate:%String,TReturnTime:%String,TReturnStatus:%String,TReturnStatusRemark:%String,TReturnOperatorDR:%String,TReturnOperateDate:%String,TReturnOperateTime:%String,TWorkLoad:%String,TWorkLoadUOM:%String,TWorkLoadUOMDR:%String,TRentFee:%String,TLucreFee:%String,TLosingFee:%String,TTotalFee:%String,TStatus:%String,TPlanBeginDate:%String,TPlanBeginTime:%String,TNo:%String,TPrice:%String,TFlag:%String,TMode:%String,TQuantity:%String,TRow:%String,TRequestTel:%String,TFileNo:%String,TApproveInfo:%String,TApproveDate:%String,TWaringFlag:%String,TApprovals:%String")
{
}

ClassMethod GetRentListExecute(ByRef qHandle As %Binary, QXType As %String = "", vQXType As %String = "", Type As %String = "", RequestLocDR As %String = "", FromLocDR As %String = "", ItemDR As %String = "", StatusDR As %String = "", BeginDate As %String = "", EndDate As %String = "", RequestNo As %String = "", EquipType As %String = "", ApproveRole As %String = "", Action As %String = "", EquipDR As %String = "", FileNo As %String = "", CurUser As %String = "", WaitAD As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	
	s Date=##class(web.DHCEQCommon).TransValueToPage($h,"date")
	//add by csj 20180901 hisui统一日期格式
	i BeginDate'="" s BeginDate=##class(web.DHCEQCommon).TransValueFromPage(BeginDate,"date")
	i EndDate'="" s EndDate=##class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")
	s rowid=0
	s TRow=0
	if RequestNo'=""  d
	.s FindRequestNo=$Order(^DHCEQRent(0,"RequestNo"," "_RequestNo),-1)
	.For  Set FindRequestNo=$Order(^DHCEQRent(0,"RequestNo",FindRequestNo))  Quit:((FindRequestNo="")||(FindRequestNo'[RequestNo))  Do
	..Set rowid=0	 
	..For  Set rowid=$Order(^DHCEQRent(0,"RequestNo",FindRequestNo,rowid))  Quit:rowid=""  Do
	...d BuildDataGetGetRentList
	e  d
	.Set rowid=0
	.For  Set rowid=$Order(^DHCEQRent(rowid))  Quit:rowid=""  Do
	..d BuildDataGetGetRentList
	Quit $$$OK

BuildDataGetGetRentList		////2011-7-19 HZY. Bug HZY0006. 去掉for循环。
	;f  s rowid=$o(^DHCEQRent(rowid))  quit:rowid=""  d
	d ResetVariablesEquipRent
	s TRowID = rowid	//rowid
	s TStatus=$p($g(^DHCEQRent(rowid)),"^",36)
	q:(StatusDR'="")&(TStatus'=StatusDR)
	q:((Type'="Apply")&&(Type'="Find")&&(TStatus=0))  //不是新增和查找界面不显示新增的申请单
	i TStatus'="" s TStatus=$CASE(TStatus,"0":"新增", "1":"申请","2":"借出","3":"归还","4":"其他")
	s TRequestLocDR=$p($g(^DHCEQRent(rowid)),"^",2)
	q:(RequestLocDR'="")&(TRequestLocDR'=RequestLocDR)
	i ((Type="Apply")||(Type="Find")) q:(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TRequestLocDR)))  //去掉不是当前申请科室的申请单
	s TFromLocDR=$p($g(^DHCEQRent(rowid)),"^",3)
	q:(FromLocDR'="")&(TFromLocDR'=FromLocDR)
	;i ((Type="Rent")||(Type="Return")) q:(1=(##class(web.DHCEQCommon).LocIsInEQ(vQXType,TFromLocDR)))  //去掉不是当前供给科室的申请单
	s TItemDR=$p($g(^DHCEQRent(rowid)),"^",7)
	q:(ItemDR'="")&(TItemDR'=ItemDR)
	s TStartDate=$p($g(^DHCEQRent(rowid)),"^",10)
	q:(BeginDate'="")&&(TStartDate<BeginDate)
	s TReturnDate=$p($g(^DHCEQRent(rowid)),"^",23)
	q:(EndDate'="")&&(TStartDate>EndDate) ///276894 Modify By BRB  2016-11-12 修改查找结束日期
	s TRequestNo=$p($g(^DHCEQRent(rowid)),"^",1) 
	i TRequestLocDR'="" s TRequestLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TRequestLocDR)
	i TFromLocDR'="" s TFromLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TFromLocDR)
	s TRequestUserDR=$p($g(^DHCEQRent(rowid)),"^",4)
	i TRequestUserDR'="" s TRequestUser=##class(web.DHCEQCommon).GetTrakNameByID("user",TRequestUserDR)
	s TRequestDate=$p($g(^DHCEQRent(rowid)),"^",5)
	i TRequestDate'="" s TRequestDate=##class(web.DHCEQCommon).TransValueToPage(TRequestDate,"date")
	s TRequestTime=$p($g(^DHCEQRent(rowid)),"^",6)
	//i TRequestTime'="" s TRequestTime=$ZT(TRequestTime,2)
	// 日期格式统一调整 mwz 2017-3-2
 	s TRequestTime=##class(web.DHCEQCommon).TransValueToPage(TRequestTime,"time")
	i TItemDR'="" s TItem=$p($g(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",1)
	s TModelDR=$p($g(^DHCEQRent(rowid)),"^",8)
	i TModelDR'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	s TEquipDR=$p($g(^DHCEQRent(rowid)),"^",9)
	q:(EquipDR'="")&&(TEquipDR'=EquipDR) // add by zx 2016-06-17 设备过滤
	s TQuantity=$p($g(^DHCEQRent(rowid)),"^",39)
	
	// add by zx 2016-12-02 根据人员筛选个人单据 ZX0036
	i CurUser'=""  d
	.s CurUserID="^"_CurUser_"^"
	.s CurUserIDs="^"_$Piece($Get(^DHCEQRent(rowid)),"^",4)_"^"_$Piece($Get(^DHCEQRent(rowid)),"^",14)_"^"_$Piece($Get(^DHCEQRent(rowid)),"^",15)_"^"_$Piece($Get(^DHCEQRent(rowid)),"^",18)_"^"_$Piece($Get(^DHCEQRent(rowid)),"^",21)_"^"_$Piece($Get(^DHCEQRent(rowid)),"^",22)_"^"_$Piece($Get(^DHCEQRent(rowid)),"^",27)_"^"
	q:(CurUser'="")&&(CurUserIDs'[CurUserID)
	
	Set ApproveType=##class(web.DHCEQApproveList).GetApproveType("30")
	Set ApproveInfoID=$Order(^DHCEQApproveInfo(0,"SourceID",ApproveType,rowid,0))
	s TApprovals="无"
	s ApproveRoleDR=""
	if ApproveInfoID'=""  d
	.Set ApproveRoleDR = $Piece($Get(^DHCEQApproveInfo(ApproveInfoID)),"^",4)
	.s TApproveRole=$Piece(^DHCEQApproveInfo(ApproveInfoID),"^",7)
	.i TApproveRole'="" s TApprovals=$p(^DHCEQCCode("DHCEQCApproveRole",TApproveRole),"^",2)	//add by CZF0080 2020-02-24
	i $p($g(^DHCEQRent(rowid)),"^",36)=0 s TApprovals="" //modified by czf 1214221 2020-03-05
	s ReturnFlag=0
	i ((ApproveRole'="")&(ApproveRoleDR'=ApproveRole)) s ReturnFlag=1
	i ApproveInfoID'=""  d
	.s CurStep=$p($g(^DHCEQApproveInfo(ApproveInfoID)),"^",5)
	.s RoleStep=##class(web.DHCEQCApproveSet).GetStepByRole(##class(web.DHCEQApproveList).GetApproveSet("30",rowid),ApproveRole,Action)
	.i +CurStep'=RoleStep s ReturnFlag=1			//Add By DJ 2016-12-05
	.s TCanChangeValue=##Class(web.DHCEQCApproveFlow).CheckApproveFlagAbove("30",Action,rowid,2)
	.i ($p(TCanChangeValue,"^",3)'="")&&((","_$p(TCanChangeValue,"^",3))[(","_RoleStep_",")) d
	..Set ReturnFlag=0 
	//q:(ApproveRole'="")&(ApproveRoleDR'=ApproveRole)			//Add By DJ 2016-05-30 begin
	/*
	s ReturnFlag=0
	i (Action="ZL_Return")  d			//显示在续借，续借确认步骤被归还步骤中断数据
	.i ApproveInfoID'=""  d
	..s CurStep=$p($g(^DHCEQApproveInfo(ApproveInfoID)),"^",5)
	..s RoleStep=##class(web.DHCEQCApproveSet).GetStepByRole(##class(web.DHCEQApproveList).GetApproveSet("30",rowid),ApproveRole,Action)
	..i CurStep'=RoleStep s ReturnFlag=1
	..s TCanChangeValue=##Class(web.DHCEQCApproveFlow).CheckApproveFlagAbove("30",Action,rowid,2)
	..i ($p(TCanChangeValue,"^",3)'="")&&((","_$p(TCanChangeValue,"^",3))[(","_RoleStep_",")) d
	...Set ReturnFlag=0 
	.e  d
	..s ReturnFlag=1
	e  d
	.i (ApproveRole'="")&(ApproveRoleDR'=ApproveRole) s ReturnFlag=1
	*/
	;;;;;;;;;;;;;;;;;;;;;;;;;;;q:((StatusDR'="")&&(ReturnFlag'=0)&&(Type'="Find"))		Mozy	2016-9-20注释
	q:(ReturnFlag'=0)&&(Type'="Find")&&(WaitAD="checked") //add by csj 20190116 增加待操作单据控制
	//Add By DJ 2016-05-30 end
	//看看借出的设备是否还回，没有还回的设备再次借出的申请在借出界面不显示
	s flag=""
	i (Type="Rent")&(TEquipDR'="")&(StatusDR="1") d
	.s id=0
	.f  s id=$o(^DHCEQRent(0,"Status",2,id)) q:(id="")||(flag=1)  d
	..s equipDR=$p($g(^DHCEQRent(id)),"^",9)
	..i equipDR=TEquipDR  s flag=1
	i (Type="Rent")&(TEquipDR'="")&(flag=1) s TFlag=1
	i TEquipDR'=""  d
	.s TEquip=$p($g(^DHCEQEquip(TEquipDR)),"^",1)
	.s TNo=$p($g(^DHCEQEquip(TEquipDR)),"^",71)
	.Set TFileNo=$p($g(^DHCEQEquip(TEquipDR)),"^",85)
	q:(FileNo'="")&&(TFileNo'[FileNo)
	i TStartDate'="" s TStartDate=##class(web.DHCEQCommon).TransValueToPage(TStartDate,"date")
	s TStartTime=$p($g(^DHCEQRent(rowid)),"^",11)
	//i TStartTime'="" s TStartTime=$ZT(TStartTime,2)
	// 日期格式统一调整 mwz 2017-3-2
 	s TStartTime=##class(web.DHCEQCommon).TransValueToPage(TStartTime,"time")
	s TPlanEndDate=$p($g(^DHCEQRent(rowid)),"^",12)
	i TPlanEndDate'="" s TPlanEndDate=##class(web.DHCEQCommon).TransValueToPage(TPlanEndDate,"date")
	s TPlanEndTime=$p($g(^DHCEQRent(rowid)),"^",13)
	//i TPlanEndTime'="" s TPlanEndTime=$ZT(TPlanEndTime,2)
	s TPlanEndTime=##class(web.DHCEQCommon).TransValueToPage(TPlanEndTime,"time")
	s TRentManagerDR=$p($g(^DHCEQRent(rowid)),"^",14)
	i TRentManagerDR'="" s TRentManager=##class(web.DHCEQCommon).GetTrakNameByID("user",TRentManagerDR)
	s TLocReceiverDR=$p($g(^DHCEQRent(rowid)),"^",15)
	i TLocReceiverDR'="" s TLocReceiver=##class(web.DHCEQCommon).GetTrakNameByID("user",TLocReceiverDR)
	s TRentStatus=$p($g(^DHCEQRent(rowid)),"^",16)
	i TRentStatus'="" s TRentStatus=$CASE(TRentStatus,"0":"完好", "1":"有缺陷")
	s TRentStatusRemark=$p($g(^DHCEQRent(rowid)),"^",17)
	;s TRentOperatorDR=$p($g(^DHCEQRent(rowid)),"^",18)
	;s TRentOperateDate=$p($g(^DHCEQRent(rowid)),"^",19)
	;s TRentOperateTime=$p($g(^DHCEQRent(rowid)),"^",20)
	s TReturnManagerDR=$p($g(^DHCEQRent(rowid)),"^",21)
	i TReturnManagerDR'="" s TReturnManager=##class(web.DHCEQCommon).GetTrakNameByID("user",TReturnManagerDR)
	s TLocReturnDR=$p($g(^DHCEQRent(rowid)),"^",22)
	i TLocReturnDR'="" s TLocReturn=##class(web.DHCEQCommon).GetTrakNameByID("user",TLocReturnDR)
	i TReturnDate'="" s TReturnDate=##class(web.DHCEQCommon).TransValueToPage(TReturnDate,"date")
	s TReturnTime=$p($g(^DHCEQRent(rowid)),"^",24)
	//i TReturnTime'="" s TReturnTime=$ZT(TReturnTime,2)
    // 日期格式统一调整 mwz 2017-3-2
 	s TReturnTime=##class(web.DHCEQCommon).TransValueToPage(TReturnTime,"time")
	s TReturnStatus=$p($g(^DHCEQRent(rowid)),"^",25)
	i TReturnStatus'="" s TReturnStatus=$CASE(TReturnStatus,"0":"完好", "1":"有缺陷", "2":"故障")
	s TReturnStatusRemark=$p($g(^DHCEQRent(rowid)),"^",26)
	;s TReturnOperatorDR=$p($g(^DHCEQRent(rowid)),"^",27)
	;s TReturnOperateDate=$p($g(^DHCEQRent(rowid)),"^",28)
	;s TReturnOperateTime=$p($g(^DHCEQRent(rowid)),"^",29)
	s TWorkLoad=$p($g(^DHCEQRent(rowid)),"^",30)
	s TWorkLoadUOMDR=$p($g(^DHCEQRent(rowid)),"^",31)
	i TWorkLoadUOMDR'="" s TWorkLoadUOM=##class(web.DHCEQCommon).GetTrakNameByID("uom",TWorkLoadUOMDR)
	s TRentFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQRent(rowid)),"^",32),"")
	s TLucreFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQRent(rowid)),"^",33),"")
	s TLosingFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQRent(rowid)),"^",34),"")
	s TTotalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQRent(rowid)),"^",35),"")
	s TPlanBeginDate=$p($g(^DHCEQRent(rowid)),"^",37)
	i TPlanBeginDate'="" s TPlanBeginDate=##class(web.DHCEQCommon).TransValueToPage(TPlanBeginDate,"date")
	s TPlanBeginTime=$p($g(^DHCEQRent(rowid)),"^",38)
	//i TPlanBeginTime'="" s TPlanBeginTime=$ZT(TPlanBeginTime,2)
	// 日期格式统一调整 mwz 2017-3-2
 	s TPlanBeginTime=##class(web.DHCEQCommon).TransValueToPage(TPlanBeginTime,"time")
	//取价格
	i TEquipDR'="" s Str=##Class(web.DHCEQEquipRent).GetEquipRentInfo(TEquipDR)
	i Str'="" d
	.s TPrice=$p(Str,"^",2)
	.s EquipRentID=$p(Str,"^",1)
	.s TMode=$p($g(^DHCEQEquipRent(EquipRentID)),"^",4)		//计价方式
	s TRequestTel=$p($g(^DHCEQRent(rowid)),"^",47)
	
	//add by zx 2016-12-02 获取上一步的审批信息 ZX0036

	s LastOperate=##Class(web.DHCEQApproveList).GetLastApproveListOpinion("30",rowid)
	s TApproveInfo=$p(LastOperate,"^",2)_$p(LastOperate,"^",3)
	s TApproveDate=$p(LastOperate,"^",4)
	s TWaringFlag=+##Class(web.DHCEQPrescription).GetPrescriptionInfo("30",rowid) //add by zx 2016-12-28 获取预警标志 ZX0036
	
	d OutputRowEquipRent
	quit
OutputRowEquipRent
	s TRow=TRow+1
    s Data=$lb(TRowID,TRequestNo,TRequestLoc,TRequestLocDR,TFromLocDR,TFromLoc,TRequestUser,TRequestUserDR,TRequestDate,TRequestTime,TItem,TItemDR,TModel,TModelDR,TEquip,TEquipDR,TStartDate,TStartTime,TPlanEndDate,TPlanEndTime,TRentManager,TRentManagerDR,TLocReceiver,TLocReceiverDR,TRentStatus,TRentStatusRemark,TRentOperatorDR,TRentOperateDate,TRentOperateTime,TReturnManager,TReturnManagerDR,TLocReturn,TLocReturnDR,TReturnDate,TReturnTime,TReturnStatus,TReturnStatusRemark,TReturnOperatorDR,TReturnOperateDate,TReturnOperateTime,TWorkLoad,TWorkLoadUOM,TWorkLoadUOMDR,TRentFee,TLucreFee,TLosingFee,TTotalFee,TStatus,TPlanBeginDate,TPlanBeginTime,TNo,TPrice,TFlag,TMode,TQuantity,TRow,TRequestTel,TFileNo,TApproveInfo,TApproveDate,TWaringFlag,TApprovals)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesEquipRent
	s (TRowID,TRequestNo,TRequestLoc,TRequestLocDR,TFromLocDR,TFromLoc,TRequestUser,TRequestUserDR,TRequestDate,TRequestTime,TItem,TItemDR,TModel,TModelDR,TEquip,TEquipDR,TStartDate,TStartTime,TPlanEndDate,TPlanEndTime,TRentManager,TRentManagerDR,TLocReceiver,TLocReceiverDR,TRentStatus,TRentStatusRemark,TRentOperatorDR,TRentOperateDate,TRentOperateTime,TReturnManager,TReturnManagerDR,TLocReturn,TLocReturnDR,TReturnDate,TReturnTime,TReturnStatus,TReturnStatusRemark,TReturnOperatorDR,TReturnOperateDate,TReturnOperateTime,TWorkLoad,TWorkLoadUOM,TWorkLoadUOMDR,TRentFee,TLucreFee,TLosingFee,TTotalFee,TStatus,TPlanBeginDate,TPlanBeginTime,TNo,TPrice,Str,TFlag,TMode,TQuantity,TRequestTel,TFileNo,LastOperate,TApproveInfo,TApproveDate,TWaringFlag,TApprovals)=""
	quit
}

ClassMethod GetRentListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRentListExecute ]
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

ClassMethod GetRentListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRentListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// 创建:zy 2010-07-22  No ZY0024
/// 描述:根据设备项和供给科室查设备
/// ----------------------------------
Query GetEquipByItem(Equip As %String = "", ItemDR As %String = "", LocDR As %String = "", ModelDR As %String = "") As %Query(ROWSPEC = "Name:%String,hidden:%String,No:%String")
{
}

ClassMethod GetEquipByItemExecute(ByRef qHandle As %Binary, Equip As %String = "", ItemDR As %String = "", LocDR As %String = "", ModelDR As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	i Equip'="" s Equip=$ZCONVERT(Equip,"U")
	d BuildDataGetGetEquipByItem
	Quit $$$OK
BuildDataGetGetEquipByItem
	q:LocDR=""
	s rowid=0
	f  s rowid=$o(^DHCEQEquip(0,"StoreLoc",LocDR,rowid)) q:rowid=""  d
	.d ResetVariablesEquip
	.s RowID = rowid
	.s flag=0
	.s id=0
	.f  s id=$o(^DHCEQRent(0,"Status",2,id)) q:(id="")||(flag=1)  d
	..s TREquipDR=$p($g(^DHCEQRent(id)),"^",9)
	..i TREquipDR=rowid  s flag=1
	.q:flag'=0
	.s TModelDR=$p($g(^DHCEQEquip(rowid)),"^",3)
	.q:(ModelDR'="")&&(TModelDR'=ModelDR)
	.s TItemDR=$p($g(^DHCEQEquip(rowid)),"^",7)
	.q:(ItemDR'="")&&(TItemDR'=ItemDR)
	.s TStatus=$p($g(^DHCEQEquip(rowid)),"^",38)
	.q:(TStatus="2")||(TStatus="3")||(TStatus="4")
	.s TStockStatus=$p($g(^DHCEQEquip(rowid)),"^",60)
	.q:TStockStatus'=1
	.s Name=$p($g(^DHCEQEquip(rowid)),"^",1)
	.q:(Equip'="")&&(Name'=Equip)
	.s No=$p($g(^DHCEQEquip(rowid)),"^",71)
	.d OutputRowEquip
	quit
OutputRowEquip
    s Data=$lb(Name,RowID,No)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesEquip
	s (Name,RowID,No)=""
	quit
}

ClassMethod GetEquipByItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEquipByItemExecute ]
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

ClassMethod GetEquipByItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEquipByItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// ----------------------------------
/// 添加:zy 2010-07-20  No ZY0024
/// 描述:检查设备是否被借出
/// w ##Class(web.DHCEQRent).CheckEquipStockStatus("11")
/// ----------------------------------
ClassMethod CheckEquipStockStatus(equipdr As %String = "")
{
	new (equipdr)
	s flag=0
	s rowid=0
	for  s rowid=$o(^DHCEQRent(0,"Status",2,rowid)) q:(rowid="")||(flag=1)  d
	.s EquipID=$p($g(^DHCEQRent(rowid)),"^",9)
	.i EquipID=equipdr  s flag=1
	q:flag=1 -1001
	s flag=0
	s rowid=0
	for  s rowid=$o(^DHCEQRent(0,"Status",1,rowid)) q:(rowid="")||(flag=1)  d
	.s EquipID=$p($g(^DHCEQRent(rowid)),"^",9)
	.i EquipID=equipdr  s flag=1
	q:flag=1 -1002
	q flag
}

ClassMethod GetInfoByEquipNo(EquipNo, FromLocDR, FromLoc)
{
	new EquipDR,EquipName,ModelDR,Model,ItemDR,Item,EquipRentID,ItemRentID
	s EquipDR=$o(^DHCEQEquip(0,"No",EquipNo,0))
	i EquipDR="" q "-1"
	s Result=##Class(web.DHCEQEquipRent).GetEquipUsedInfo(EquipDR)
	q:(Result=1) "-2"
	s EquipName=$p($g(^DHCEQEquip(EquipDR)),"^",1)
	s Model=""		;Mozy	2017-9-28	457461
	s ModelDR=$p($g(^DHCEQEquip(EquipDR)),"^",3)
	i ModelDR'="" s Model=$p($g(^DHCEQCCode("DHCEQCModel",ModelDR)),"^",2)
	s ItemDR=$p($g(^DHCEQEquip(EquipDR)),"^",7)
	s Item=EquipName
	
	s EquipRentID=$o(^DHCEQEquipRent(0,"SourceID",1,EquipDR,0))
	s ItemRentID=$o(^DHCEQEquipRent(0,"SourceID",2,ItemDR,0))
	q:((EquipRentID="")&&(ItemRentID="")) "-3"
	
	q EquipName_"^"_EquipDR_"^"_EquipNo_"^"_Model_"^"_ModelDR_"^"_FromLoc_"^"_FromLocDR_"^"_Item_"^"_ItemDR
}

/// 判断归还设备
ClassMethod GetBackInfoByEquipNo(EquipNo, RowID)
{
	n EquipID,EquipDR
	s EquipID=$p($g(^DHCEQRent(RowID)),"^",9)
	s EquipDR=$o(^DHCEQEquip(0,"No",EquipNo,0))
	q:(EquipID'=EquipDR) "-1"
	q:(EquipID=EquipDR) "0"
	q "-2"
}

/// add by zx 2016-07-05
/// 根据租赁单保存租赁附件信息
/// w ##Class(web.DHCEQRent).SaveRentAffix(44,3)
ClassMethod SaveRentAffix(rentid, rentstatus)
{
	s ItemID = $p($g(^DHCEQRent(rentid)),"^",7)
	s EquipID = $p($g(^DHCEQRent(rentid)),"^",9)
	
	k RAPL 
	s RAPL(2)=rentid
	s RAPL(3)=rentstatus
	s sourceFlag=0
	s sqlFlag=0
	s Flag=0
	//若租赁设备来源为设备
	s EquipRentID = 0
	f  s EquipRentID = $o(^DHCEQEquipRent(0,"SourceID",1,EquipID,EquipRentID)) q:(EquipRentID="")||(sqlFlag'=0)  d
	.s sourceFlag = 1 //存在以设备为来源，标志值为1，后面不执行设备项来源
	...d SetRentAffix
	
	i sourceFlag=0 d //未以设备为来源时，以设备项为来源
	.s EquipRentID = 0
	.f  s EquipRentID = $o(^DHCEQEquipRent(0,"SourceID",2,ItemID,EquipRentID)) q:(EquipRentID="")||(sqlFlag'=0)  d
	..d SetRentAffix
	q Flag
	
SetRentAffix	
	s EquipAffixID = 0
	f  s EquipAffixID = $o(^DHCEQEquipRentAffix(0,"EquipRent",EquipRentID,EquipAffixID)) q:(EquipAffixID="")||(sqlFlag'=0)  d
	.s RAPL(4)=EquipAffixID
	.&SQL(Insert Into SQLUSER.DHC_EQRentAffix Values :RAPL())
	.i SQLCODE d
	..s sqlFlag=1
	..s Flag=SQLCODE
	
	quit
}

/// add by zx 2016-07-05
/// 根据租赁单获取附件信息
/// w ##Class(web.DHCEQRent).GetRentAffix(15)
ClassMethod GetRentAffix(rentid)
{
	i rentid="" q ""
	s str=""
	s RentAffixID=0	
	f  s RentAffixID=$o(^DHCEQRentAffix(0,"Rent",rentid,RentAffixID)) q:RentAffixID=""  d
	.s RentStatus=$p($g(^DHCEQRentAffix(RentAffixID)),"^",2)
	.s AffixStatus=$p($g(^DHCEQRentAffix(RentAffixID)),"^",4)
	.s EquipAffixDR=$p($g(^DHCEQRentAffix(RentAffixID)),"^",3)
	.i EquipAffixDR'="" d
	..s EquipAffixName=$p($g(^DHCEQEquipRentAffix(EquipAffixDR)),"^",2)
	..s EquipAffixNum=$p($g(^DHCEQEquipRentAffix(EquipAffixDR)),"^",4)
	..i RentStatus=1 d //南方医院只需要取到附件名称
	...i str="" d
	....s str=EquipAffixName
	...e  d
	....s str=str_"^"_EquipAffixName
	q str
}

/// add by zx 2016-07-05
/// 租赁跨月打印单据时工作量处理 
/// w ##Class(web.DHCEQRent).GetworkNumByMonth(64091,38640,64091,38769)
ClassMethod GetworkNumByMonth(startdate, starttime, enddate, endtime)
{
	i (startdate="")||(starttime="")||(enddate="")||(endtime="") q ""
	s return=""
	s startmonth=+$p($zd(startdate,3),"-",2)
	s endmonth=+$p($zd(enddate,3),"-",2)
	i startmonth'=endmonth d
	.s firstdate=$p($zd(enddate,3),"-",1,2)_"-"_"01"
	.s firstdate=$zdh(firstdate,3)
	.s return=startmonth_":"_(((firstdate-startdate)*24)+$fn(((86400-starttime)/3600),"",0))_";"_endmonth_":"_(((enddate-firstdate)*24)+$fn(((endtime)/3600),"",0))_";"
	e  d
	.s return=startmonth_":"_(((enddate-startdate)*24)+$fn(((endtime-starttime)/3600),"",0))_";"
	
	q return
}

/// w ##Class(web.DHCEQRent).TimePrint()
/// 获取未打印单据
ClassMethod TimePrint()
{
	s rentIDs=""
	s rentID=0
	f  s rentID=$o(^DHCEQRent(0,"Status","2",rentID)) q:rentID=""  d
	.s Operate=$Order(^DHCEQOperateLog(0,"Source","1","64",rentID,""),-1)
	.q:Operate'=""
	.s rentIDs=rentIDs_"^"_rentID

	q rentIDs
}

/// add by sjh 租赁登记单据打印润乾 BUG00018
/// d ##class(%ResultSet).RunQuery("web.DHCEQRent","RentPrint","1")
Query RentPrint(RowID As %String = "") As %Query(ROWSPEC = "TRowID:%String,TRequestNo:%String,TRequestLoc:%String,TTel:%String,TEquipName:%String,TFileNo:%String,TLeaveFactoryNo:%String,TStartDate:%String,TReturnDate:%String") [ SqlProc ]
{
}

/// TRowID,TRequestNo,TRequestLoc,TTel,TEquipName,TFileNo,TLeaveFactoryNo,TStartDate,TReturnDate
ClassMethod RentPrintExecute(ByRef qHandle As %Binary, RowID As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1

	s rowid=0
	f  s rowid=$o(^DHCEQRent(rowid)) q:rowid=""  d
	.q:rowid'=RowID
	.d ResetVariablesEquipRentPrint
	.s TRowID=rowid
	.s TRequestNo=$p($g(^DHCEQRent(rowid)),"^",1)
	.q:TRequestNo=""
	.s TRequestLocDR=$p($g(^DHCEQRent(rowid)),"^",2)
	.i TRequestLocDR'="" s TRequestLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TRequestLocDR)
	.s LocType="" 
	.f  s LocType=$o(^DHCEQCCode("DHCEQCLocType",0,"LocType",LocType)) q:(LocType="")  d
	..s LocTypeCode=$p(^DHCEQCCode("DHCEQCLocGroupType",LocType),"^",2)
	..q:LocTypeCode'="0102"
	..s ltid=$o(^DHCEQCCode("DHCEQCLocType",0,"LocType",LocType,TRequestLocDR,""))
	..i ltid'="" s TTel=$p(^DHCEQCCode("DHCEQCLocType",ltid),"^",8)
	.s EquipDR=$p($g(^DHCEQRent(rowid)),"^",9)
	.i EquipDR'="" s TEquipName=$p($g(^DHCEQEquip(EquipDR)),"^",1)
	.s TFileNo=$p($g(^DHCEQEquip(EquipDR)),"^",85)
	.s TLeaveFactoryNo=$p($g(^DHCEQEquip(EquipDR)),"^",10)
	.s TStartDate=$p($g(^DHCEQRent(rowid)),"^",10)
	.b
	.i TStartDate'="" s TStartDate=$zd(TStartDate,3)
	.s TReturnDate=$p($g(^DHCEQRent(rowid)),"^",23)
	.i TReturnDate'="" s TReturnDate=$zd(TReturnDate,3)
	.d OutputRowEquipRentPrint
	quit $$$OK
OutputRowEquipRentPrint
	;;s TRow=TRow+1
    s Data=$lb(TRowID,TRequestNo,TRequestLoc,TTel,TEquipName,TFileNo,TLeaveFactoryNo,TStartDate,TReturnDate)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesEquipRentPrint
	s (TRowID,TRequestNo,TRequestLoc,TTel,TEquipName,TFileNo,TLeaveFactoryNo,TStartDate,TReturnDate)=""
	quit
}

ClassMethod RentPrintFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = RentPrintExecute ]
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

ClassMethod RentPrintClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = RentPrintExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

Storage Default
{
<Data name="DHCEQRentDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCEQRentD</DataLocation>
<DefaultData>DHCEQRentDefaultData</DefaultData>
<IdLocation>^web.DHCEQRentD</IdLocation>
<IndexLocation>^web.DHCEQRentI</IndexLocation>
<StreamLocation>^web.DHCEQRentS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
